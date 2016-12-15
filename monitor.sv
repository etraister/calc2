`ifndef MONITOR_SV
`define MONITOR_SV

`include "result.sv"
`include "monitor_callback.sv"

typedef MonitorCallback;

class Monitor;
  virtual Port_ifc.Monitor port_ifc;
  int port;
  mailbox mon2drv;
  MonitorCallback callback_queue[$];
  function new(virtual Port_ifc.Monitor port_ifc, int port, 
      mailbox mon2drv);
    this.port_ifc =port_ifc;
    this.port = port;
    this.mon2drv = mon2drv;
  endfunction
  extern task run();
endclass

task Monitor::run();
  Result result;
  forever begin
    while (port_ifc.cbm.resp_out === 0) @(port_ifc.cbm);
    result = new(port_ifc.cbm.resp_out, port_ifc.cbm.data_out, port_ifc.cbm.tag_out);

    mon2drv.put(result.tag);

    foreach (callback_queue[i]) callback_queue[i].result_received(this, result);

    // Wait a cycle. This ensures that we don't re-catch this same packet! That
    // is, before this statement, we're still in a cycle where resp_out!=0. So 
    // if we exit the "forever" block, another forever block will be triggered 
    // for this same cycle, leading us to catch this same result again.    
    @(port_ifc.cbm);    
  end
endtask : run

`endif
