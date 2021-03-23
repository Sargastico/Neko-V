<div align="center">
  <img src="https://i.pinimg.com/originals/15/f1/63/15f16379e576615e08aa1270e34f4c90.png" width="40%">
  <h1>Neko-V</h1>
  <i>RISC-V 32-bit FPGA [Verilog] Processor with neko ears! :p</i><br>
  <i>For study purposes (sh1TTy Code Disclaimer)</b></i>
  <h1></h1>
  

<div align="left">
<br>

Implements the RV32E ISA (Instruction Set Architecture).
</br>
<br>
<h2># Requirements:</h2>

  * [GTKWave](http://gtkwave.sourceforge.net/)
  * [Icarus Verilog](http://iverilog.icarus.com/)

<br>
<h2># Running tests</h2>
<br>

Running a test from a specific module, ALU for example:

> Path : /Neko-V/cpu/alu
```
iverilog -o alu_tb.vvp alu_tb.v
```
To generate the wave view:

```
vvp alu_tb.vvp
```
The output should not contain any errors. Open the file with the GTKWave:
```
gtkwave alu_tb.vcd
```

Result:
<div align="center">
<img src="https://i.imgur.com/zUmVqLR.png">
<div align="left">

<br>
<br>
To test the CPU module, it's necessary to specify the path for all other modules:

```
iverilog -o cpu_tb.vvp cpu_tb.v -I ./cpu/programCounter -I ./cpu/registerBank -I ./cpu/instructionDecoder -I ./cpu/alu
```

Then:
```
vvp cpu_tb.vvp
```

<br>
<br>

<h2># Compile the test code </h2>
<br>

To compile the assembly instructions from 'test' folder, install the gcc for riscv (for ubuntu):
```
sudo apt install gcc-10-riscv64-linux-gnu
```

Generate .hex code for the online simulator:
```
make simhex
```

Generate .mem for the CPU unit testing:
```
make testmem
```
Clean the test files:
```
make clean
```
<br>
<h1># Greetz & References:</h1>
<br>

Awesome RISC-V projects:
* ["Riscow" by racerxdl](https://github.com/racerxdl/riskow)
* ["DarkRISCV" by Darklife](https://github.com/darklife/darkriscv)
<br>

Recommended Reading:

* ["The RISC-V Reader: An Open Architecture Atlas"](http://riscvbook.com/)

</div>


