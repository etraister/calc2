`ifndef DRIVER_CALLBACK_SV
`define DRIVER_CALLBACK_SV

`include "driver.sv"
`include "command.sv"

typedef Driver;

class DriverCallback;
  virtual task command_sent(Driver driver, Command command); 
  endtask : command_sent
endclass : DriverCallback

`endif
