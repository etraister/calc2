`ifndef SCOREBOARD_MONITOR_CALLBACK_SV
`define SCOREBOARD_MONITOR_CALLBACK_SV

`include "monitor_callback.sv"
`include "scoreboard.sv"

class ScoreboardMonitorCallback extends MonitorCallback;
  Scoreboard scoreboard;

  function new(Scoreboard scoreboard);
    this.scoreboard = scoreboard;
  endfunction : new

  virtual task result_received(Monitor monitor, Result result);
    scoreboard.check_actual(monitor, result);
  endtask : result_received
endclass : ScoreboardMonitorCallback

`endif
