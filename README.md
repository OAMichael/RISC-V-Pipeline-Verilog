# RISC-V processor pipeline written in Verilog and its co-simulation with [Emulator](!https://github.com/MIPT-2023-RISC-V-Emulator-Team/Emulator)

## How to build and run
### First, you have to make sure that you have all submodules:
```
git submodule update --init --recursive
```
### Then, you can run build script which will do all the work:
```
sh build.sh
```
### And now you can run co-simulation:
```
./Sim/VPipelineTop ./Emulator/test/asmtests/loop.exe
```
