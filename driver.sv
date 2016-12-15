`ifndef DRIVER_SV
`define DRIVER_SV

`include "command.sv"
`include "driver_callback.sv"

typedef DriverCallback;

class Driver;
  mailbox gen2drv;
  event drv2gen;
  mailbox mon2drv;
  virtual Port_ifc.Driver port_ifc;
  int port;
  DriverCallback callback_queue[$];

  extern function new(
      input mailbox gen2drv,
      input event drv2gen, 
      virtual Port_ifc.Driver port_ifc,
      int port,
      mailbox mon2drv);
  extern task run();
endclass : Driver

function Driver::new(
    input mailbox gen2drv,
    input event drv2gen, 
    virtual Port_ifc.Driver port_ifc,
    int port,
    mailbox mon2drv);
  this.gen2drv = gen2drv;
  this.drv2gen = drv2gen;
  this.port_ifc = port_ifc;
  this.port = port;
  this.mon2drv = mon2drv;
endfunction : new

task Driver::run();
  Command command;
  int tag;

  port_ifc.cbd.data_in <= 0;
  port_ifc.cbd.cmd_in <= 0;
  port_ifc.cbd.tag_in <= 0;

  forever begin
    gen2drv.peek(command);

    // Get an available tag.
    mon2drv.get(tag);  

    repeat(command.cycle_delay) @(port_ifc.cbd);

    port_ifc.cbd.cmd_in <= command.cmd; 
    port_ifc.cbd.data_in <= command.data1;
    port_ifc.cbd.tag_in <= tag;
    @(port_ifc.cbd);
    port_ifc.cbd.cmd_in <= 0;
    port_ifc.cbd.data_in <= command.data2;
    port_ifc.cbd.tag_in <= 0;
    @(port_ifc.cbd);
    port_ifc.cbd.data_in <= 0;

    // Log the tag and time.
    command.time_inserted = $time;
    command.tag = tag;

    // Send the command out to the scoreboard and anyone else who
    // might be listening.
    foreach (callback_queue[i]) callback_queue[i].command_sent(this, command);

    // Now we remove the item from the mailbox and signal the generator.
    gen2drv.get(command);
    ->drv2gen;
  end
endtask : run

`endif
