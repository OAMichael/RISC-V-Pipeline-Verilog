#include "Sim.h"

#include "simulator/OSHelper.h"
#include "simulator/Hart.h"
#include "utils/utils.h"

#include <iostream>

#define MAX_STEPS 15

static uint64_t PCEnd = 0;
static uint32_t clocksToMatch = 0;


static void printMismatch(Sim::Model& model, RISCV::Hart& emu) {
    for (int j = 0; j < 32; ++j) {
        if (model.getReg(j) != emu.getReg((RISCV::RegisterType)j)) {
            printf("[MISMATCH x%d] sim: %lu, emu: %lu\n", j, model.getReg(j), emu.getReg((RISCV::RegisterType)j));
        }
    }
    printf("\n");
}


static bool compareModels(Sim::Model& model, RISCV::Hart& emu) {
    for (int i = 0; i < MAX_STEPS; ++i) {
        bool regsEqual = true;
        for (int j = 0; j < 32; ++j) {
            if (model.getReg(j) != emu.getReg((RISCV::RegisterType)j)) {
                regsEqual = false;
                break;
            }
        }
        if (regsEqual) {
            // Use sim memory by emu PC since sim PC has changed because of pipeline
            uint32_t instr = model.getIMem32(emu.getPC());
            printf("EMU PC %lx: Matched instruction \'\033[1;32m", emu.getPC());
            Sim::printInst(instr);
            printf("\033[0m\' for %d clocks\n", clocksToMatch);
            clocksToMatch = 0;
            return true;
        }
        model.clock();
        ++clocksToMatch;
    }
    return false;
}



int main(int argc, char** argv) {
    if (argc < 2) {
        std::cout << "Usage: " << argv[0] << " <elf_filename>\n";
        return -1;
    }

    Sim::Model model;

    model.resetState();
    model.loadElfFile(argv[1], PCEnd);

    RISCV::Hart emu;
    RISCV::OSHelper::getInstance()->loadElfFile(emu, argv[1]);
    emu.setReg(RISCV::RegisterType::SP, 0);     // Reset registers

    model.startState();
    model.clock();
    model.clock();
    model.clock();
    model.clock();

    auto& bb = emu.getBasicBlock();
    emu.executeBasicBlock(bb);

    while(model.getPCPlus4W() < PCEnd) {
        if (!compareModels(model, emu)) {
            printMismatch(model, emu);
            break;
        }

        if (emu.getPC() < PCEnd) {
            auto& bb = emu.getBasicBlock();
            emu.executeBasicBlock(bb);
        }

        model.clock();
        ++clocksToMatch;
    }

    return 0;
}
