`ifndef PORT_IFC_SV
`define PORT_IFC_SV

interface Port_ifc(input logic clk);

  logic [0:3] cmd_in;
  logic [0:31] data_in, data_out; 
  logic [0:1] tag_in, tag_out;
  logic [0:1] resp_out;

  clocking cbd @ (posedge clk);
    output clk, cmd_in, data_in, tag_in;
  endclocking : cbd

  clocking cbm @ (posedge clk);
    input data_out, tag_out, resp_out;
  endclocking : cbm

  modport Driver (
    clocking cbd
  );

  modport Monitor (
    clocking cbm
  );

endinterface : Port_ifc

`endif
