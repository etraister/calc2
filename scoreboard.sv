`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

`include "result.sv"
`include "driver.sv"
`include "command.sv"
`include "monitor.sv"

class Expectation;
  Command command;
  logic [0:31] expected_data;
  logic [0:1] expected_resp;
endclass : Expectation

class Scoreboard;
  Expectation add_queue[$], shift_queue[$], other_queue[$];
  Expectation port_queues[4][$];
  extern function new();
  extern function void save_expected(Driver driver, Command command);
  extern function void check_actual(Monitor monitor, Result result);
endclass

function Scoreboard::new();
endfunction

function void Scoreboard::save_expected(Driver driver, Command command);
  logic [0:31] expected_data;
  logic [0:1] expected_resp;
  Expectation e;

  begin
    //$display("[port %1d] Command in: cmd = %b, operands = %b (%d), %b (%d), tag = %b",
    //    driver.port, command.cmd, command.data1, command.data1, command.data2, command.data2,
    //    command.tag);

    case(command.cmd)
      1:  begin
            expected_data = command.data1 + command.data2;
            expected_resp = (command.data1 + command.data2 + 64'b0 > 32'hFFFFFFFF) 
                ? 2 : 1;
          end
      2:  begin
            expected_data = command.data1 - command.data2;
            expected_resp = (command.data1 < command.data2) ? 2 : 1;
          end
      5:  begin
            expected_data = command.data1 << command.data2[27:31];
            expected_resp = 1;
          end
      6:  begin
            expected_data = command.data1 >> command.data2[27:31];
            expected_resp = 1;
          end
      default: begin
            expected_data = 0;
            expected_resp = 2;
          end
    endcase

    e = new();
    e.command = command;
    e.expected_data = expected_data;
    e.expected_resp = expected_resp;

    // Enqueue the expectation in the proper queues.
    port_queues[driver.port].push_back(e);
    case(command.cmd)
      1: add_queue.push_back(e);
      2: add_queue.push_back(e);
      5: shift_queue.push_back(e);
      6: shift_queue.push_back(e);
      default: other_queue.push_back(e);
    endcase 
  end
endfunction

function void Scoreboard::check_actual(Monitor monitor, Result result);
  int index = -1, i = 0;
  Expectation e;
  begin
    //$display("[port %1.d] Result out: resp = %b, data = %b (%d), tag = %b",
    //    monitor.port, result.resp, result.data, result.data, result.tag);
    
    for (i = 0; i < port_queues[monitor.port].size(); i++) 
      if (port_queues[monitor.port][i].command.tag == result.tag)
        index = i;
    assert(index >= 0 && index <= 3) 
    else begin
      $error("No Expectation object found in queue corresponding to Result. Result: port = %1.d, resp = %b, data = %b (%d), tag = %b",
          monitor.port, result.resp, result.data, result.data, result.tag);
      return;
    end

    e = port_queues[monitor.port][index];

    assert(((e.expected_resp == 1) -> (result.data == e.expected_data)) 
        && result.resp == e.expected_resp)
    else begin
      $error("Incorrect response!");
      $display("Command: cmd = %b, data1 = %d, data2 = %d, tag = %d",
          e.command.cmd, e.command.data1,
          e.command.data2, e.command.tag);
      $display("Expected: data = %d, resp = %b",
          e.expected_data, e.expected_resp);
      $display("Got: data = %d, resp = %b",
          result.data, result.resp);
    end

    port_queues[monitor.port].delete(index);

  end
endfunction
`endif
