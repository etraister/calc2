Make sure you compile the calculator separately from the testbench. I.e.,
compile the Verilog separately from the SystemVerilog:

```bash
vlog *.v
vlog top.sv
```

Note that you only need to compile `top.sv`. Other SystemVerilog files will be included as needed.

Then, run the testbench:

```bash
vsim -c top -do "run -all"
```
