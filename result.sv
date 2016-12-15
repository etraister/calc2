`ifndef RESULT_SV
`define RESULT_SV

class Result;
  logic [0:1] resp;
  logic [0:31] data;
  logic [0:1] tag;
  
  function new(logic[0:1] resp, logic[0:31] data, logic[0:1] tag);
    this.resp = resp;
    this.data = data;
    this.tag = tag;
  endfunction : new

endclass : Result

`endif
