GREEN='\033[0;32m'
NOCOLOR='\033[0m'

if [ ! -d "./Emulator/build" ]; then
    echo "${GREEN}Generating Emulator autogenerated files...${NOCOLOR}"
    cd ./Emulator
    cmake -B build .
    cd ../
fi

echo "${GREEN}Translating Verilog to C++ sources...${NOCOLOR}"
verilator --version
verilator -CFLAGS '-std=c++17 -I../Emulator -I../Emulator/asmjit/src -I../Emulator/build' -LDFLAGS '-lelf' -cc -Mdir Sim --exe --build --public -ISim Sim.cpp ../Emulator/simulator/Hart.cpp ../Emulator/simulator/OSHelper.cpp ../Emulator/simulator/memory/Memory.cpp ../Emulator/simulator/memory/MMU.cpp ../Emulator/utils/Debug.cpp ../Emulator/build/generated/Decoder.cpp ../Emulator/build/generated/Dispatcher.cpp -IModel PipelineTop.v

echo "${GREEN}Building RISC-V assembly test...${NOCOLOR}"
riscv64-unknown-elf-as ./Emulator/test/asmtests/loop.s -o ./Emulator/test/asmtests/loop.o
riscv64-unknown-elf-ld ./Emulator/test/asmtests/loop.o -o ./Emulator/test/asmtests/loop.exe
rm ./Emulator/test/asmtests/loop.o