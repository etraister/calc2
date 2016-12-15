`ifndef MONITOR_CALLBACK_SV
`define MONITOR_CALLBACK_SV

`include "monitor.sv"
`include "result.sv"

typedef Monitor;

class MonitorCallback;
  virtual task result_received(Monitor monitor, Result result); 
  endtask : result_received
endclass

`endif
