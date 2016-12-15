// tests all four ports with 4 concurrent instructions

`include "calc2_top.v"

module atest;

   wire [0:31] out_data1, out_data2, out_data3, out_data4;
   wire [0:1]  out_resp1, out_resp2, out_resp3, out_resp4, out_tag1, out_tag2, out_tag3, out_tag4;
   wire 	 scan_out;

   reg 	 a_clk, b_clk, c_clk, reset, scan_in;
   reg [0:3] 	 req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in;
   reg [0:1] 	 req1_tag_in, req2_tag_in, req3_tag_in, req4_tag_in;
   reg [0:31]  req1_data_in, req2_data_in, req3_data_in, req4_data_in;

   wire 	 out_adder_overflow, port1_invalid_op, port2_invalid_op, port3_invalid_op, port4_invalid_op, prio_adder_out_vld, prio_shift_out_vld, scan_ring1, scan_ring2, scan_ring3, scan_ring4, scan_ring5, scan_ring6, scan_ring7, scan_ring8, scan_ring9, scan_ring10, scan_ring11, shift_overflow;
   
   calc2_top C2 ( out_data1, out_data2, out_data3, out_data4, out_resp1, out_resp2, out_resp3, out_resp4, out_tag1, out_tag2, out_tag3, out_tag4, scan_out, a_clk, b_clk, c_clk, req1_cmd_in, req1_data_in, req1_tag_in, req2_cmd_in, req2_data_in, req2_tag_in, req3_cmd_in, req3_data_in, req3_tag_in, req4_cmd_in, req4_data_in, req4_tag_in, reset, scan_in);
   
   
   initial 
     begin
	c_clk = 0;
	a_clk = 0;
	b_clk = 0;
	scan_in = 0;
	
     end
   
	
   always #100 c_clk = ~c_clk;
   
   initial
     begin

	reset = 1;
	req1_cmd_in = 0;
	req1_data_in = 0 ;
	req1_tag_in = 0;
	req2_cmd_in = 0;
	req2_data_in = 0;
	req2_tag_in = 0;
	req3_cmd_in = 0;
	req3_data_in = 0;
	req3_tag_in = 0;
	req4_cmd_in = 0;
	req4_data_in = 0;
	req4_tag_in = 0;
	
	#600 

	  reset = 0;
	req1_cmd_in = 1;
	req1_data_in = 10;
	req1_tag_in = 1;
	req2_cmd_in = 1;
	req2_data_in = 1000000;
	req2_tag_in = 1;
	req3_cmd_in = 1;
	req3_data_in = {{30{1'b1}}, 1'b0};
	req3_tag_in = 1;
	req4_cmd_in = 1;
	req4_data_in = {{20{1'b1}}, 1'b0};
	req4_tag_in = 1;
	
	#200 
	  req1_cmd_in = 0;
	req1_data_in = 25;
	req1_tag_in = 0;
	req2_cmd_in = 0;
	req2_data_in = 2000000;
	req2_tag_in = 0;
	req3_cmd_in = 0;
	req3_data_in = 2;
	req3_tag_in = 0;
	req4_cmd_in = 0;
	req4_data_in = 5;
	req4_tag_in = 0;
	
	#200

	  req1_cmd_in = 2;
	req1_data_in = 5;
	req1_tag_in = 2;
	req2_cmd_in = 2;
	req2_data_in = 10;
	req2_tag_in = 2;
	req3_cmd_in = 2;
	req3_data_in = 50000;
	req3_tag_in = 2;
	req4_cmd_in = 2;
	req4_data_in = {31{1'b1}};
	req4_tag_in = 2;
		
	#200

	  req1_cmd_in = 0;
	req1_data_in = 5;
	req1_tag_in = 0;
	req2_cmd_in = 0;
	req2_data_in = 9;
	req2_tag_in = 0;
	req3_cmd_in = 0;
	req3_data_in = 1999;
	req3_tag_in = 0;
	req4_cmd_in = 0;
	req4_data_in = {31{1'b1}};
	req4_tag_in = 0;
		
	#200

	req1_cmd_in = 1;
	req1_data_in = 'b111110000011111000001111100000;
	req1_tag_in = 3;
	req2_cmd_in = 1;
	req2_data_in = 'b1011;
	req2_tag_in = 3;
	req3_cmd_in = 1;
	req3_data_in = 'b111100011;
	req3_tag_in = 3;
	req4_cmd_in = 1;
	req4_data_in = 'b100000000001;
	req4_tag_in = 3;
	
	#200 
	  req1_cmd_in = 0;
	req1_data_in = 'b000001111100000111110000011111;
	req1_tag_in = 0;
	req2_cmd_in = 0;
	req2_data_in = 'b1001;
	req2_tag_in = 0;
	req3_cmd_in = 0;
	req3_data_in = 'b11100011;
	req3_tag_in = 0;
	req4_cmd_in = 0;
	req4_data_in = 'b10;
	req4_tag_in = 0;
	
	#200

	  req1_cmd_in = 1;
	req1_data_in = 'b100;
	req1_tag_in = 0;
	req2_cmd_in = 1;
	req2_data_in = 'b1000;
	req2_tag_in = 0;
	req3_cmd_in = 1;
	req3_data_in ='b10000;
	req3_tag_in = 0;
	req4_cmd_in = 1;
	req4_data_in = 'b100000;
	req4_tag_in = 0;
	
	#200 
	  req1_cmd_in = 0;
	req1_data_in =  'b100;
	req1_tag_in = 0;
	req2_cmd_in = 0;
	req2_data_in = 'b1000;
	req2_tag_in = 0;
	req3_cmd_in = 0;
	req3_data_in = 'b10000;
	req3_tag_in = 0;
	req4_cmd_in = 0;
	req4_data_in = 'b100000;
	req4_tag_in = 0;
	
	#200

	  req1_cmd_in = 2;
	req1_data_in = 5;
	req1_tag_in = 1;
	req2_cmd_in = 2;
	req2_data_in = 10;
	req2_tag_in = 1;
	req3_cmd_in = 2;
	req3_data_in = 50000;
	req3_tag_in = 1;
	req4_cmd_in = 2;
	req4_data_in = {31{1'b1}};
	req4_tag_in = 1;
		
	#200

	  req1_cmd_in = 0;
	req1_data_in = 5;
	req1_tag_in = 0;
	req2_cmd_in = 0;
	req2_data_in = 9;
	req2_tag_in = 0;
	req3_cmd_in = 0;
	req3_data_in = 1999;
	req3_tag_in = 0;
	req4_cmd_in = 0;
	req4_data_in = {31{1'b1}};
	req4_tag_in = 0;
		
	#200
	  
	  req1_cmd_in = 1;
	req1_data_in = 5;
	req1_tag_in = 2;
	req2_cmd_in = 1;
	req2_data_in = 10;
	req2_tag_in = 2;
	req3_cmd_in = 1;
	req3_data_in = 50000;
	req3_tag_in = 2;
	req4_cmd_in = 1;
	req4_data_in = {31{1'b1}};
	req4_tag_in = 2;
		
	#200

	  req1_cmd_in = 0;
	req1_data_in = 5;
	req1_tag_in = 0;
	req2_cmd_in = 0;
	req2_data_in = 9;
	req2_tag_in = 0;
	req3_cmd_in = 0;
	req3_data_in = 1999;
	req3_tag_in = 0;
	req4_cmd_in = 0;
	req4_data_in = {31{1'b1}};
	req4_tag_in = 0;
		
	#200
	  
	req1_cmd_in = 5;
	req1_data_in = 'b11111;
	req1_tag_in = 3;
	req2_cmd_in = 5;
	req2_data_in = 'b1010101;
	req2_tag_in = 3;
	req3_cmd_in = 5;
	req3_data_in = {{30{1'b1}}, 1'b0};
	req3_tag_in = 3;
	req4_cmd_in = 5;
	req4_data_in = {{20{1'b1}}, 1'b0};
	req4_tag_in = 3;
	
	#200
	  
	  req1_cmd_in = 0;
	req1_data_in = 2;
	req1_tag_in = 0;
	req2_cmd_in = 0;
	req2_data_in = 5;
	req2_tag_in = 0;
	req3_cmd_in = 0;
	req3_data_in = 20;
	req3_tag_in = 0;
	req4_cmd_in = 0;
	req4_data_in = 32;
	req4_tag_in = 0;
	
	#200

	  req1_cmd_in = 6;
	req1_data_in = {31{1'b1}};
	req1_tag_in = 0 ;
	req2_cmd_in = 6;
	req2_data_in = 'b111100001111;
	req2_tag_in = 0;
	req3_cmd_in = 6;
	req3_data_in = 'b101010;
	req3_tag_in = 0;
	req4_cmd_in = 6;
	req4_data_in = {15{1'b1}};
	req4_tag_in = 0;
		
	#200

	  req1_cmd_in = 0;
	req1_data_in = 2;
	req1_tag_in = 0;
	req2_cmd_in = 0;
	req2_data_in = 4;
	req2_tag_in = 0;
	req3_cmd_in = 0;
	req3_data_in = 20;
	req3_tag_in = 0;
	req4_cmd_in = 0;
	req4_data_in = 32;
	req4_tag_in = 0;

	#200
	
	  req1_cmd_in = 5;
	req1_data_in = 'b1011011101111;
	req1_tag_in = 1;
	req2_cmd_in = 5;
	req2_data_in = 'b1111110000011;
	req2_tag_in = 1;
	req3_cmd_in = 5;
	req3_data_in = 'b1010011100100;
	req3_tag_in = 1;
	req4_cmd_in = 5;
	req4_data_in = 'b100101010101;
	req4_tag_in = 1;
		
	#200

	  req1_cmd_in = 0;
	req1_data_in = 5;
	req1_tag_in = 0;
	req2_cmd_in = 0;
	req2_data_in = 10;
	req2_tag_in = 0;
	req3_cmd_in = 0;
	req3_data_in = 15;
	req3_tag_in = 0;
	req4_cmd_in = 0;
	req4_data_in = 20;
	req4_tag_in = 0;
		
	#200
	  
	  req1_cmd_in = 6;
	req1_data_in = {32{1'b1}};
	req1_tag_in = 2;
	req2_cmd_in = 6;
	req2_data_in = {25{1'b1}};
	req2_tag_in = 2;
	req3_cmd_in = 6;
	req3_data_in = { {10{1'b1}},{10{1'b0}},{10{1'b1}} };
	req3_tag_in = 2;
	req4_cmd_in = 6;
	req4_data_in = {5{1'b1}};
	req4_tag_in = 2;
		
	#200

	  req1_cmd_in = 0;
	req1_data_in = 10;
	req1_tag_in = 0;
	req2_cmd_in = 0;
	req2_data_in = 20;
	req2_tag_in = 0;
	req3_cmd_in = 0;
	req3_data_in = 29;
	req3_tag_in = 0;
	req4_cmd_in = 0;
	req4_data_in = 3;
	req4_tag_in = 0;
		
       
	
	#2000 $stop;

     end // initial begin

   always
     @ (reset or c_clk or req1_cmd_in or req1_data_in or req2_cmd_in or req2_data_in or req3_cmd_in or req3_data_in or req4_cmd_in or req4_data_in) begin
	
	$display ("%t: r:%b \n 
1c:%d,1d:%d,1t:%d  
2c:%d,2d:%d,2t:%d  
3c:%d,3d:%d,3t:%d  
4c:%d,4d:%d,4t:%d  
1r:%d,1d:%d,1t:%d  
2r:%d,2d:%d,2t:%d  
3r:%d,3d:%d,3t:%d  
4r:%d,4d:%d,4t:%d \n\n", 

$time, reset, 
req1_cmd_in, req1_data_in, req1_tag_in,
req2_cmd_in, req2_data_in, req2_tag_in,
req3_cmd_in, req3_data_in, req3_tag_in,
req4_cmd_in, req4_data_in, req4_tag_in,
out_resp1, out_data1, out_tag1,
out_resp2, out_data2, out_tag2,
out_resp3, out_data3, out_tag3,
out_resp4, out_data4, out_tag4);
	
     end

endmodule
   






