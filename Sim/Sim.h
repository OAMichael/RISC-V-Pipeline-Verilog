#ifndef SIM_SIM_H
#define SIM_SIM_H

#include "VModule.hpp"
#include "VPipelineTop.h"

#include <fcntl.h>
#include <gelf.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <string>


namespace Sim {

template<uint8_t signBitNum>
static uint32_t signExtend(const uint64_t val) {
    return ~(((val & (1 << signBitNum)) - 1)) | val;
}

template<uint32_t first, uint32_t second>
static uint32_t getPartialBits(const uint32_t val) {
    const uint32_t mask = ((1 << (first - second + 1)) - 1) << second;
    return (val & mask);
}

static void printInst(const uint32_t inst) {
    const uint32_t opcode = inst & 0b1111111;

    switch (opcode) {
        case 0b1100011: {       // BEQ or BNE or BLT or BGE
            const uint32_t funct3 = getPartialBits<14, 12>(inst) >> 12;

            uint32_t rs1 = getPartialBits<19, 15>(inst) >> 15;
            uint32_t rs2 = getPartialBits<24, 20>(inst) >> 20;  

            uint32_t imm =
                (getPartialBits<11, 8>(inst) >> 7) +
                (getPartialBits<30, 25>(inst) >> 20) +
                (getPartialBits<7, 7>(inst) << 4) +
                (getPartialBits<31, 31>(inst) >> 19);

            imm = signExtend<12>(imm);

            switch (funct3) {
                case 0b000: {   // BEQ
                    printf("beq     x%d, x%d, %d", rs1, rs2, imm);
                    break;
                }
                case 0b001: {   // BNE
                    printf("bne     x%d, x%d, %d", rs1, rs2, imm);
                    break;
                }
                case 0b100: {   // BLT
                    printf("blt     x%d, x%d, %d", rs1, rs2, imm);
                    break;
                }
                case 0b101: {   // BGE
                    printf("bge     x%d, x%d, %d", rs1, rs2, imm);
                    break;
                }
                default: {
                    printf("<unknown>");
                    break;
                }
            }
            break;
        }
        case 0b0000011: {       // LW
            const uint32_t funct3 = getPartialBits<14, 12>(inst) >> 12;

            uint32_t rd  = getPartialBits<11, 7>(inst) >> 7;
            uint32_t rs1 = getPartialBits<19, 15>(inst) >> 15; 
            uint32_t imm = getPartialBits<31, 20>(inst) >> 20;

            imm = signExtend<11>(imm);

            switch (funct3) {
                case 0b010: {   // LW
                    printf("lw      x%d, x%d, %d", rd, rs1, imm);
                    break;
                }
                default: {
                    printf("<unknown>");
                    break;
                }
            }
            break;
        }
        case 0b0100011: {       // SW
            const uint32_t funct3 = getPartialBits<14, 12>(inst) >> 12;

            uint32_t rs1 = getPartialBits<19, 15>(inst) >> 15;
            uint32_t rs2 = getPartialBits<24, 20>(inst) >> 20;
            uint32_t imm = (getPartialBits<11, 7>(inst) >> 7) + (getPartialBits<31, 25>(inst) >> 20);

            imm = signExtend<11>(imm);

            switch (funct3) {
                case 0b010: {   // SW
                    printf("sw      x%d, x%d, %d", rs1, rs2, imm);
                    break;
                }
                default: {
                    printf("<unknown>");
                    break;
                }
            }
            break;
        }
        case 0b0010011: {       // ADDI or ORI or ANDI
            const uint32_t funct3 = getPartialBits<14, 12>(inst) >> 12;
            const uint32_t funct7 = getPartialBits<31, 25>(inst) >> 25;

            uint32_t rd  = getPartialBits<11, 7>(inst) >> 7;
            uint32_t rs1 = getPartialBits<19, 15>(inst) >> 15;
            uint32_t imm = getPartialBits<31, 20>(inst) >> 20;

            imm = signExtend<11>(imm);

            switch (funct3) {
                case 0b000: {   // ADDI
                    printf("addi    x%d, x%d, %d", rd, rs1, imm);
                    break;
                }
                case 0b110: {   // ORI
                    printf("ori     x%d, x%d, %d", rd, rs1, imm);
                    break;
                }
                case 0b111: {   // ANDI
                    printf("andi    x%d, x%d, %d", rd, rs1, imm);
                    break;
                }
                default: {
                    printf("<unknown>");
                    break;
                }
            }
            break;
        }
        case 0b0110011: {       // ADD or OR or AND or SUB
            const uint32_t funct3 = getPartialBits<14, 12>(inst) >> 12;
            const uint32_t funct7 = getPartialBits<31, 25>(inst) >> 25;

            uint32_t rd  = getPartialBits<11, 7>(inst) >> 7;
            uint32_t rs1 = getPartialBits<19, 15>(inst) >> 15;
            uint32_t rs2 = getPartialBits<24, 20>(inst) >> 20;

            if (funct7 == 0b0000000) {
                switch (funct3) {
                    case 0b000: {   // ADD
                        printf("add     x%d, x%d, x%d", rd, rs1, rs2);
                        break;
                    }
                    case 0b110: {   // OR
                        printf("or      x%d, x%d, x%d", rd, rs1, rs2);
                        break;
                    }
                    case 0b111: {   // AND
                        printf("and     x%d, x%d, x%d", rd, rs1, rs2);
                        break;
                    }
                    default: {
                        printf("<unknown>");
                        break;
                    }
                }
            }
            else if (funct7 == 0b0100000) {
                switch (funct3) {
                    case 0b000: {   // SUB
                        printf("sub     x%d, x%d, x%d", rd, rs1, rs2);
                        break;
                    }
                    default: {
                        printf("<unknown>");
                        break;
                    }
                }
            }
            else {
                printf("<unknown>");
                break;
            }
            break;
        }
        default: {
            printf("<unknown>");
            break;
        }
    }
}


class Model : public VModule<VPipelineTop> {

public:

    using VModule<VPipelineTop>::VModule;

    uint64_t getPC() const {
        return (*this)->PipelineTop__DOT__Fetch__DOT__PCF;
    }

    void setPC(const uint64_t newPC) {
        (*this)->PipelineTop__DOT__Fetch__DOT__PCF = newPC;
        (*this)->PipelineTop__DOT__Fetch__DOT__PC_F = newPC;
        (*this)->PipelineTop__DOT__Fetch__DOT__PCPlus4F = newPC;
        eval();
    }

    uint64_t getPCPlus4W() const {
        return (*this)->PipelineTop__DOT__PCPlus4W;
    }

    uint64_t getReg(size_t idx) const {
        return (*this)->PipelineTop__DOT__Decode__DOT__RegFile__DOT__Registers[idx];
    }

    void setReg(size_t idx, uint64_t val) {
        (*this)->PipelineTop__DOT__Decode__DOT__RegFile__DOT__Registers[idx] = val;
        eval();
    }

    // Aligned uint32 load
    uint32_t getIMem32(const size_t addr) const {
        return (*this)->PipelineTop__DOT__Fetch__DOT__IMEM__DOT__Memory[addr / 4];
    }

    // Aligned uint32 store
    void setIMem32(const size_t addr, const uint32_t val) {
        (*this)->PipelineTop__DOT__Fetch__DOT__IMEM__DOT__Memory[addr / 4] = val;
        eval();
    }

    // Aligned uint32 load
    uint32_t getDMem32(const size_t addr) const {
        return (*this)->PipelineTop__DOT__Memory__DOT__DMEM__DOT__Memory[addr / 4];
    }

    // Aligned uint32 store
    void setDMem32(const size_t addr, const uint32_t val) {
        (*this)->PipelineTop__DOT__Memory__DOT__DMEM__DOT__Memory[addr / 4] = val;
        eval();
    }

    uint32_t getInstrF() const {
        return (*this)->PipelineTop__DOT__Fetch__DOT__InstrF;
    }

    void resetState() {
        for (size_t i = 0; i < 32; ++i) {
            setReg(i, 0);
        }
        setPC(0);
        (*this)->rst = 1;
        eval();
    }

    void startState() {
        (*this)->rst = 0;
        eval();
    }

    void dumpRegs() const {
        printf("[SIM] [ PC: %lx, x0: 0", getPC());
        for (int i = 1; i < 32; ++i) {
            printf(", x%d: %lu", i, getReg(i));
        }
        printf(" ]\n");
    }

    void eval() {
        (*this)->eval();
    }

    bool loadElfFile(const std::string &filename, uint64_t& PCEnd) {
        int fd = open(filename.c_str(), O_RDONLY);
        if (fd == -1) {
            fprintf(stderr, "failed to open file \'%s\'\n", filename.c_str());
            return false;
        }

        if (elf_version(EV_CURRENT) == EV_NONE) {
            fprintf(stderr, "ELF init failed\n");
            return false;
        }

        Elf *elf = elf_begin(fd, ELF_C_READ, nullptr);
        if (!elf) {
            fprintf(stderr, "elf_begin() failed\n");
            return false;
        }

        if (elf_kind(elf) != ELF_K_ELF) {
            fprintf(stderr, "%s is not ELF file\n", filename.c_str());
            return false;
        }

        GElf_Ehdr ehdr;
        if (!gelf_getehdr(elf, &ehdr)) {
            fprintf(stderr, "gelf_getehdr() failed\n");
            return false;
        }

        struct stat fileStat;
        if (fstat(fd, &fileStat) == -1) {
            fprintf(stderr, "Cannot stat %s\n", filename.c_str());
            return false;
        }

        void *fileBuffer = mmap(NULL, fileStat.st_size, PROT_READ, MAP_SHARED, fd, 0);
        if (fileBuffer == NULL) {
            fprintf(stderr, "mmap() failed\n");
            return false;
        }

        PCEnd = 0;
        for (size_t i = 0; i < ehdr.e_phnum; ++i) {
            GElf_Phdr phdr;
            gelf_getphdr(elf, i, &phdr);

            if (phdr.p_type != PT_LOAD)
                continue;

            if (phdr.p_flags & (PF_R | PF_W)) {
                for (uint64_t addr = 0; addr < phdr.p_filesz; addr += 4) {
                    uint32_t data = *(uint32_t*)((uint8_t*)fileBuffer + phdr.p_offset + addr);
                    setDMem32(phdr.p_vaddr + addr, data);
                }
            }
            if (phdr.p_flags & PF_X) {
                for (uint64_t addr = 0; addr < phdr.p_filesz; addr += 4) {
                    uint32_t instr = *(uint32_t*)((uint8_t*)fileBuffer + phdr.p_offset + addr);
                    uint64_t VAPC = phdr.p_vaddr + addr;
                    setIMem32(VAPC, instr);
                    PCEnd = std::max(PCEnd, VAPC);
                }
            }
        }

        munmap(fileBuffer, fileStat.st_size);
        elf_end(elf);
        close(fd);
        setPC(ehdr.e_entry);

        eval();
        return true;
    }
};
}

#endif
