`ifndef COMMAND_SV
`define COMMAND_SV

class Command;
  rand logic [0:3] cmd;
  rand logic [0:31] data1, data2;
  logic [0:1] tag;
  time time_inserted;
  // The number of cycles the driver should wait between issuing the 
  // previous instruction and issuing this instruction.
  rand int unsigned cycle_delay;
  int unsigned port;

  function new(logic [0:3] cmd = 0, logic [0:31] data1 = 0, data2 = 0,
                int unsigned cycle_delay= 0);
    this.cmd = cmd;
    this.data1 = data1;
    this.data2 = data2;
    this.tag = -1;
    this.cycle_delay = cycle_delay;
    this.port = -1;
    this.time_inserted = -1;
  endfunction : new

  constraint legal_command {
    // add/sub, shifts, and example invalid command (7)
    cmd dist {
      1 := 1,
      2 := 1,
      5 := 5,
      6 := 5,
      7 := 1
    };
    cycle_delay >= 0;
    cycle_delay <= 1000;
  }

endclass : Command
  
`endif
