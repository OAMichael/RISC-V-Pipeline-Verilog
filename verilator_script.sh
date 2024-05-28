verilator -CFLAGS '-std=c++17 -I../Emulator -I../Emulator/asmjit/src -I../Emulator/build' -LDFLAGS '-lelf' -cc -Mdir Sim --exe --build --public -ISim Sim.cpp ../Emulator/simulator/Hart.cpp ../Emulator/simulator/OSHelper.cpp ../Emulator/simulator/memory/Memory.cpp ../Emulator/simulator/memory/MMU.cpp ../Emulator/utils/Debug.cpp ../Emulator/build/generated/Decoder.cpp ../Emulator/build/generated/Dispatcher.cpp -IModel PipelineTop.v

riscv64-unknown-elf-as ./Emulator/test/asmtests/loop.s -o ./Emulator/test/asmtests/loop.o
riscv64-unknown-elf-ld ./Emulator/test/asmtests/loop.o -o ./Emulator/test/asmtests/loop.exe
rm ./Emulator/test/asmtests/loop.o

./Sim/VPipelineTop ./Emulator/test/asmtests/loop.exe
