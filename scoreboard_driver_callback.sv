`ifndef SCOREBOARD_DRIVER_CALLBACK_SV
`define SCOREBOARD_DRIVER_CALLBACK_SV

`include "driver_callback.sv"
`include "scoreboard.sv"

class ScoreboardDriverCallback extends DriverCallback;
  Scoreboard scoreboard;

  function new(Scoreboard scoreboard);
    this.scoreboard = scoreboard;
  endfunction : new

  virtual task command_sent(Driver driver, Command command);
    scoreboard.save_expected(driver, command);
  endtask : command_sent
endclass : ScoreboardDriverCallback

`endif
