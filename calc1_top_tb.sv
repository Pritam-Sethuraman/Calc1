/////////////////////////////////////////////////////////////////////
// Purpose: Testbench for calc1_top.v
// Author: Pritam Sethuraman
//
// Revesion 1.3  13/02/2023 Pritam
// Updated task to check corner cases
/////////////////////////////////////////////////////////////////////

`default_nettype none
module calc1_top_tb;
  // inputs instantiated to the calc1
  bit c_clk;
  bit [0:7] reset;
  bit signed [0:3] req1_cmd_in;
  bit signed [0:31] req1_data_in;
  bit signed [0:3] req2_cmd_in;
  bit signed [0:31] req2_data_in;
  bit signed [0:3] req3_cmd_in;
  bit signed [0:31] req3_data_in;
  bit signed [0:3] req4_cmd_in;
  bit signed [0:31] req4_data_in;
  
  // outputs instantiated to the calc1
  logic signed [0:1] out_resp1;
  logic signed [0:31] out_data1;
  logic signed [0:1] out_resp2;
  logic signed [0:31] out_data2;
  logic signed [0:1] out_resp3;
  logic signed [0:31] out_data3;
  logic signed [0:1] out_resp4;
  logic signed [0:31] out_data4;
  
  // Command Decode Values
  localparam No_Operation = 4'b0000;
  localparam Add = 4'b0001;
  localparam Sub = 4'b0010;
  localparam Shift_Left = 4'b0101;
  localparam Shift_Right = 4'b0110;
  
  // Edge values (localparam are by deafult 32bits so we can define in integers)
  localparam MAXVAL = 32'hFFFFFFFF;
  localparam MINVAL = -32'hFFFFFFFF;
  localparam ZERO = 32'h00000000;
  
  int unsigned count;
  int unsigned count2;
  
  
  calc1_top calc1_top (
  .c_clk(c_clk),
  .reset(reset[0:7]),
  .req1_cmd_in(req1_cmd_in[0:3]),
  .req1_data_in(req1_data_in[0:31]),
  .req2_cmd_in(req2_cmd_in[0:3]),
  .req2_data_in(req2_data_in[0:31]),
  .req3_cmd_in(req3_cmd_in[0:3]),
  .req3_data_in(req3_data_in[0:31]),
  .req4_cmd_in(req4_cmd_in[0:3]),
  .req4_data_in(req4_data_in[0:31]),
  .out_resp1(out_resp1[0:1]),
  .out_data1(out_data1[0:31]),
  .out_resp2(out_resp2[0:1]),
  .out_data2(out_data2[0:31]),
  .out_resp3(out_resp3[0:1]),
  .out_data3(out_data3[0:31]),
  .out_resp4(out_resp4[0:1]),
  .out_data4(out_data4[0:31])
  );
  
  // Generating clock
  initial begin
    c_clk <= 0;
    forever #5 c_clk <= !c_clk;
  end
  
  // Generating reset
  initial begin
    #20;
    reset <= 8'b00000000;
    #10;
    reset <= 8'b11111111;
    #100;
    reset <= 8'b00000000;
  end
  
  
  // Testing begins
  initial begin
    #305;
    //------------ Port 1 ------------
    // ---- Test for No Operation ----
    req1_cmd_in <= 4'b0000;
    req1_data_in <= 32'b00000000000000000000000000000001;
    #10;
    req1_cmd_in <= 4'b0000;  
    req1_data_in <= 32'b00000000000000000000000000000001;
    #10;
    req1_data_in <= 32'b00000000000000000000000000000000;
    #20;
    
    // ---- Test for Add ----
    req1_cmd_in <= 4'b0001;
    req1_data_in <= 32'b00000000000000000000000000011010;
    #10;
    req1_cmd_in <= 4'b0000;  
    req1_data_in <= 32'b00000000000000000000000000000101;
    #10;
    req1_data_in <= 32'b00000000000000000000000000000000;
    #20;
    
    // ---- Test for Add without Overflow
    req1_cmd_in <= 4'b0001;  
	  req1_data_in <= 32'b11111011111111111111111111111111;
	  #10;
	  req1_cmd_in <= 4'b0000;  
	  req1_data_in <= 32'b00000100000000000000000000000000;
	  #10;
	  req1_data_in <= 32'b00000000000000000000000000000000;
	  #20;
    
    // ---- Test for Add with Overflow ----
    req1_cmd_in <= 4'b0001;
    req1_data_in <= 32'b11111111111111111111111111111111;
    #10;
    req1_cmd_in <= 4'b0000;  
    req1_data_in <= 32'b00000000000000000000000000000001;
    #10;
    req1_data_in <= 32'b00000000000000000000000000000000;
    #20;
    
    // ---- Test for Sub ----
    req1_cmd_in <= 4'b0010;  
    req1_data_in <= 32'b00000000000000000000000000011010;
    #10;
    req1_cmd_in <= 4'b0000;  
    req1_data_in <= 32'b00000000000000000000000000000101;
    #10;
    req1_data_in <= 32'b00000000000000000000000000000000;
    #20;
    
    // --- Test for Sub of Equal Numbers ----
    req1_cmd_in <= 4'b0010;  
    req1_data_in <= 32'b10000010000010000000100000100001;
    #10;
    req1_cmd_in <= 4'b0000;  
    req1_data_in <= 32'b10000010000010000000100000100001;
    #10;
    req1_data_in <= 32'b00000000000000000000000000000000;
    #20;
    
    // ---- Test for Sub with Underflow ----
    	req1_cmd_in <= 4'b0010;  
	req1_data_in <= 32'h00000001;
	#10;
	req1_cmd_in <= 4'b0000;  
	req1_data_in <= 32'hFFFFFFFF;
	#10;
	req1_data_in <= 32'h00000000;
	#20;

//-------------test for one time shift left
	req1_cmd_in <= 4'b0101;  
	req1_data_in <= 32'hDEE71D7E;
	#10;
	req1_cmd_in <= 4'b0000;  
	req1_data_in <= 32'h00000001;
	#10;
	req1_data_in <= 32'h00000000;
	#20;

//------------test for zero time shift left 
	req1_cmd_in = 4'b0101;
    req1_data_in = 32'hdeec1d7e;
    #10;
    req1_cmd_in = 4'b0000;
    req1_data_in = 32'h00000000;
    #10;
    req1_data_in = 32'h00000000;
    #20;

//------------test for 31 times shift left 
	for (int i=1; i<=31; i++) begin
        count++;
        req1_cmd_in = 4'b0101;
        req1_data_in = 32'hdeec1d7e;
        #10;
        req1_cmd_in = 4'b0000;
        req1_data_in = count;
        #10;
        req1_data_in = 32'h00000000;
        #20;
    end
//------------test for big than 31 times shift left
	req1_cmd_in <= 4'b0101;  
    req1_data_in <= 32'b11111111111111111111111111111111;
    #10;
    req1_cmd_in <= 4'b0000;  
    req1_data_in <= 32'b00011000000001100000000000111111;
    #10;
    req1_data_in <= 32'b00000000000000000000000000000000;
    #20;
//------------test one time shift right
	req1_cmd_in <= 4'b0110;  
    req1_data_in <= 32'b11011101111001110001110111101110;
    #10;
    req1_cmd_in <= 4'b0000;  
    req1_data_in <= 32'b00000000000000000000000000000001;
    #10;
    req1_data_in <= 32'b00000000000000000000000000000000;
    #20;
//-------------test for zero time shift right
	req1_cmd_in = 4'b0110;  
	req1_data_in = 32'h6DDC71EE;
	#10;
	req1_cmd_in = 4'b0000;  
	req1_data_in = 32'h00000000;
	#10;
	req1_data_in = 32'h00000000;
	#20;
//------------test for 31 times shift right 
	count2 = 0;
	for (int i = 0; i < 31; i++) begin
		count2++;
		req1_cmd_in = 4'b0110;  
		req1_data_in = 32'h6DDC71EE;
		#10;
		req1_cmd_in = 4'b0000;  
		req1_data_in = count2;
		#10;
		req1_data_in = 32'h00000000;
		#20;
	end
//------------test for big than 31 times shift right
	req1_cmd_in <= 4'b0110;  
	req1_data_in <= 32'hffffffff;
	#10;
	req1_cmd_in <= 4'b0000;  
	req1_data_in <= 32'h1800603f;
	#10;
	req1_data_in <= 32'h0;
	#20;
//------------test for invalid
	req1_cmd_in <= 4'b0111;  
	req1_data_in <= 32'h1;
	#10;
	req1_cmd_in <= 4'b0000;  
	req1_data_in <= 32'h1;
	#10;
	req1_data_in <= 32'h0;
	#20;
	end
// -----------------------------------port 2-------------------------------*
//-----------------test for no operation-------------------
initial begin
    req2_cmd_in <= 4'b0000;  
    req2_data_in <= 32'h00000001;
    #10;
    req2_cmd_in <= 4'b0000;  
    req2_data_in <= 32'h00000001;
    #10;
    req2_data_in <= 32'h00000000;
    #20;
 
//-----------------test for simple add---------------------

    req2_cmd_in <= 4'b0001;  
    req2_data_in <= 32'h0000001A;
    #10;
    req2_cmd_in <= 4'b0000;  
    req2_data_in <= 32'h00000005;
    #10;
    req2_data_in <= 32'h00000000;
    #20;

//---------------test for add without carry
	req2_cmd_in <= 4'b0001;  
	req2_data_in <= 32'b11111011111111111111111111111111;
	#10;
	req2_cmd_in <= 4'b0000;  
	req2_data_in <= 32'b00000100000000000000000000000000;
	#10;
	req2_data_in <= 32'b00000000000000000000000000000000;
	#20;

//----------------test for add with carry(overflow)
	req2_cmd_in <= 4'b0001;  
	req2_data_in <= 32'b11111111111111111111111111111111;
	#10;
	req2_cmd_in <= 4'b0000;  
	req2_data_in <= 32'b00000000000000000000000000000001;
	#10;
	req2_data_in <= 32'b00000000000000000000000000000000;
	#20;

//---------------test for simple sub
	req2_cmd_in <= 4'b0010;  
	req2_data_in <= 32'b00000000000000000000000000011010;
	#10;
	req2_cmd_in <= 4'b0000;  
	req2_data_in <= 32'b00000000000000000000000000000101;
    #10;
    req2_data_in <= 32'b00000000000000000000000000000000;
    #20;
//-------------test for sub(equal numbers)
	req2_cmd_in <= 4'b0010;  
	req2_data_in <= 32'b10000010000010000000100000100001;
    #10;
    req2_cmd_in <= 4'b0000;  
    req2_data_in <= 32'b10000010000010000000100000100001;
    #10;
    req2_data_in <= 32'b00000000000000000000000000000000;
    #20;

//--------------test for sub(underflow)
	req2_cmd_in <= 4'b0010;  
	req2_data_in <= 32'h00000001;
	#10;
	req2_cmd_in <= 4'b0000;  
	req2_data_in <= 32'hFFFFFFFF;
	#10;
	req2_data_in <= 32'h00000000;
	#20;

//-------------test for one time shift left
	req2_cmd_in <= 4'b0101;  
	req2_data_in <= 32'hDEE71D7E;
	#10;
	req2_cmd_in <= 4'b0000;  
	req2_data_in <= 32'h00000001;
	#10;
	req2_data_in <= 32'h00000000;
	#20;

//------------test for zero time shift left 
	req2_cmd_in = 4'b0101;
    req2_data_in = 32'hdeec1d7e;
    #10;
    req2_cmd_in = 4'b0000;
    req2_data_in = 32'h00000000;
    #10;
    req2_data_in = 32'h00000000;
    #20;

//------------test for 31 times shift left 
	for (int i=1; i<=31; i++) begin
        count++;
        req2_cmd_in = 4'b0101;
        req2_data_in = 32'hdeec1d7e;
        #10;
        req2_cmd_in = 4'b0000;
        req2_data_in = count;
        #10;
        req2_data_in = 32'h00000000;
        #20;
    end
//------------test for big than 31 times shift left
	req2_cmd_in <= 4'b0101;  
    req2_data_in <= 32'b11111111111111111111111111111111;
    #10;
    req2_cmd_in <= 4'b0000;  
    req2_data_in <= 32'b00011000000001100000000000111111;
    #10;
    req2_data_in <= 32'b00000000000000000000000000000000;
    #20;
//------------test one time shift right
	req2_cmd_in <= 4'b0110;  
    req2_data_in <= 32'b11011101111001110001110111101110;
    #10;
    req2_cmd_in <= 4'b0000;  
    req2_data_in <= 32'b00000000000000000000000000000001;
    #10;
    req2_data_in <= 32'b00000000000000000000000000000000;
    #20;
//-------------test for zero time shift right
	req2_cmd_in = 4'b0110;  
	req2_data_in = 32'h6DDC71EE;
	#10;
	req2_cmd_in = 4'b0000;  
	req2_data_in = 32'h00000000;
	#10;
	req2_data_in = 32'h00000000;
	#20;
//------------test for 31 times shift right 
	count2 = 0;
	for (int i = 0; i < 31; i++) begin
		count2++;
		req2_cmd_in = 4'b0110;  
		req2_data_in = 32'h6DDC71EE;
		#10;
		req2_cmd_in = 4'b0000;  
		req2_data_in = count2;
		#10;
		req2_data_in = 32'h00000000;
		#20;
	end
//------------test for big than 31 times shift right
	req2_cmd_in <= 4'b0110;  
	req2_data_in <= 32'hffffffff;
	#10;
	req2_cmd_in <= 4'b0000;  
	req2_data_in <= 32'h1800603f;
	#10;
	req2_data_in <= 32'h0;
	#20;
//------------test for invalid
	req2_cmd_in <= 4'b0111;  
	req2_data_in <= 32'h1;
	#10;
	req2_cmd_in <= 4'b0000;  
	req2_data_in <= 32'h1;
	#10;
	req2_data_in <= 32'h0;
	#20;
end
// -----------------------------------port 3-------------------------------*
//-----------------test for no operation-------------------
initial begin
    req3_cmd_in <= 4'b0000;  
    req3_data_in <= 32'h00000001;
    #10;
    req3_cmd_in <= 4'b0000;  
    req3_data_in <= 32'h00000001;
    #10;
    req3_data_in <= 32'h00000000;
    #20;
 
//-----------------test for simple add---------------------

    req3_cmd_in <= 4'b0001;  
    req3_data_in <= 32'h0000001A;
    #10;
    req3_cmd_in <= 4'b0000;  
    req3_data_in <= 32'h00000005;
    #10;
    req3_data_in <= 32'h00000000;
    #20;

//---------------test for add without carry
	req3_cmd_in <= 4'b0001;  
	req3_data_in <= 32'b11111011111111111111111111111111;
	#10;
	req3_cmd_in <= 4'b0000;  
	req3_data_in <= 32'b00000100000000000000000000000000;
	#10;
	req3_data_in <= 32'b00000000000000000000000000000000;
	#20;

//----------------test for add with carry(overflow)
	req3_cmd_in <= 4'b0001;  
	req3_data_in <= 32'b11111111111111111111111111111111;
	#10;
	req3_cmd_in <= 4'b0000;  
	req3_data_in <= 32'b00000000000000000000000000000001;
	#10;
	req3_data_in <= 32'b00000000000000000000000000000000;
	#20;

//---------------test for simple sub
	req3_cmd_in <= 4'b0010;  
	req3_data_in <= 32'b00000000000000000000000000011010;
	#10;
	req3_cmd_in <= 4'b0000;  
	req3_data_in <= 32'b00000000000000000000000000000101;
    #10;
    req3_data_in <= 32'b00000000000000000000000000000000;
    #20;
//-------------test for sub(equal numbers)
	req3_cmd_in <= 4'b0010;  
	req3_data_in <= 32'b10000010000010000000100000100001;
    #10;
    req3_cmd_in <= 4'b0000;  
    req3_data_in <= 32'b10000010000010000000100000100001;
    #10;
    req3_data_in <= 32'b00000000000000000000000000000000;
    #20;

//--------------test for sub(underflow)
	req3_cmd_in <= 4'b0010;  
	req3_data_in <= 32'h00000001;
	#10;
	req3_cmd_in <= 4'b0000;  
	req3_data_in <= 32'hFFFFFFFF;
	#10;
	req3_data_in <= 32'h00000000;
	#20;

//-------------test for one time shift left
	req3_cmd_in <= 4'b0101;  
	req3_data_in <= 32'hDEE71D7E;
	#10;
	req3_cmd_in <= 4'b0000;  
	req3_data_in <= 32'h00000001;
	#10;
	req3_data_in <= 32'h00000000;
	#20;

//------------test for zero time shift left 
	req3_cmd_in = 4'b0101;
    req3_data_in = 32'hdeec1d7e;
    #10;
    req3_cmd_in = 4'b0000;
    req3_data_in = 32'h00000000;
    #10;
    req3_data_in = 32'h00000000;
    #20;

//------------test for 31 times shift left 
	for (int i=1; i<=31; i++) begin
        count++;
        req3_cmd_in = 4'b0101;
        req3_data_in = 32'hdeec1d7e;
        #10;
        req3_cmd_in = 4'b0000;
        req3_data_in = count;
        #10;
        req3_data_in = 32'h00000000;
        #20;
    end
//------------test for big than 31 times shift left
	req3_cmd_in <= 4'b0101;  
    req3_data_in <= 32'b11111111111111111111111111111111;
    #10;
    req3_cmd_in <= 4'b0000;  
    req3_data_in <= 32'b00011000000001100000000000111111;
    #10;
    req3_data_in <= 32'b00000000000000000000000000000000;
    #20;
//------------test one time shift right
	req3_cmd_in <= 4'b0110;  
    req3_data_in <= 32'b11011101111001110001110111101110;
    #10;
    req3_cmd_in <= 4'b0000;  
    req3_data_in <= 32'b00000000000000000000000000000001;
    #10;
    req3_data_in <= 32'b00000000000000000000000000000000;
    #20;
//-------------test for zero time shift right
	req3_cmd_in = 4'b0110;  
	req3_data_in = 32'h6DDC71EE;
	#10;
	req3_cmd_in = 4'b0000;  
	req3_data_in = 32'h00000000;
	#10;
	req3_data_in = 32'h00000000;
	#20;
//------------test for 31 times shift right 
  count2 = 0;
	for (int i = 0; i < 31; i++) begin
		count2++;
		req3_cmd_in = 4'b0110;  
		req3_data_in = 32'h6DDC71EE;
		#10;
		req3_cmd_in = 4'b0000;  
		req3_data_in = count2;
		#10;
		req3_data_in = 32'h00000000;
		#20;
	end
//------------test for big than 31 times shift right
	req3_cmd_in <= 4'b0110;  
	req3_data_in <= 32'hffffffff;
	#10;
	req3_cmd_in <= 4'b0000;  
	req3_data_in <= 32'h1800603f;
	#10;
	req3_data_in <= 32'h0;
	#20;
//------------test for invalid
	req3_cmd_in <= 4'b0111;  
	req3_data_in <= 32'h1;
	#10;
	req3_cmd_in <= 4'b0000;  
	req3_data_in <= 32'h1;
	#10;
	req3_data_in <= 32'h0;
	#20;
	end
// -----------------------------------port 4-------------------------------*
//-----------------test for no operation-------------------
initial begin
    req4_cmd_in <= 4'b0000;  
    req4_data_in <= 32'h00000001;
    #10;
    req4_cmd_in <= 4'b0000;  
    req4_data_in <= 32'h00000001;
    #10;
    req4_data_in <= 32'h00000000;
    #20;
 
//-----------------test for simple add---------------------

    req4_cmd_in <= 4'b0001;  
    req4_data_in <= 32'h0000001A;
    #10;
    req4_cmd_in <= 4'b0000;  
    req4_data_in <= 32'h00000005;
    #10;
    req4_data_in <= 32'h00000000;
    #20;

//---------------test for add without carry
	req4_cmd_in <= 4'b0001;  
	req4_data_in <= 32'b11111011111111111111111111111111;
	#10;
	req4_cmd_in <= 4'b0000;  
	req4_data_in <= 32'b00000100000000000000000000000000;
	#10;
	req4_data_in <= 32'b00000000000000000000000000000000;
	#20;

//----------------test for add with carry(overflow)
	req4_cmd_in <= 4'b0001;  
	req4_data_in <= 32'b11111111111111111111111111111111;
	#10;
	req4_cmd_in <= 4'b0000;  
	req4_data_in <= 32'b00000000000000000000000000000001;
	#10;
	req4_data_in <= 32'b00000000000000000000000000000000;
	#20;

//---------------test for simple sub
	req4_cmd_in <= 4'b0010;  
	req4_data_in <= 32'b00000000000000000000000000011010;
	#10;
	req4_cmd_in <= 4'b0000;  
	req4_data_in <= 32'b00000000000000000000000000000101;
    #10;
    req4_data_in <= 32'b00000000000000000000000000000000;
    #20;
//-------------test for sub(equal numbers)
	req4_cmd_in <= 4'b0010;  
	req4_data_in <= 32'b10000010000010000000100000100001;
    #10;
    req4_cmd_in <= 4'b0000;  
    req4_data_in <= 32'b10000010000010000000100000100001;
    #10;
    req4_data_in <= 32'b00000000000000000000000000000000;
    #20;

//--------------test for sub(underflow)
	req4_cmd_in <= 4'b0010;  
	req4_data_in <= 32'h00000001;
	#10;
	req4_cmd_in <= 4'b0000;  
	req4_data_in <= 32'hFFFFFFFF;
	#10;
	req4_data_in <= 32'h00000000;
	#20;

//-------------test for one time shift left
	req4_cmd_in <= 4'b0101;  
	req4_data_in <= 32'hDEE71D7E;
	#10;
	req4_cmd_in <= 4'b0000;  
	req4_data_in <= 32'h00000001;
	#10;
	req4_data_in <= 32'h00000000;
	#20;

//------------test for zero time shift left 
	req4_cmd_in = 4'b0101;
    req4_data_in = 32'hdeec1d7e;
    #10;
    req4_cmd_in = 4'b0000;
    req4_data_in = 32'h00000000;
    #10;
    req4_data_in = 32'h00000000;
    #20;

//------------test for 31 times shift left 
	for (int i=1; i<=31; i++) begin
        count++;
        req4_cmd_in = 4'b0101;
        req4_data_in = 32'hdeec1d7e;
        #10;
        req4_cmd_in = 4'b0000;
        req4_data_in = count;
        #10;
        req4_data_in = 32'h00000000;
        #20;
    end
//------------test for big than 31 times shift left
	req4_cmd_in <= 4'b0101;  
    req4_data_in <= 32'b11111111111111111111111111111111;
    #10;
    req4_cmd_in <= 4'b0000;  
    req4_data_in <= 32'b00011000000001100000000000111111;
    #10;
    req4_data_in <= 32'b00000000000000000000000000000000;
    #20;
//------------test one time shift right
	req4_cmd_in <= 4'b0110;  
    req4_data_in <= 32'b11011101111001110001110111101110;
    #10;
    req4_cmd_in <= 4'b0000;  
    req4_data_in <= 32'b00000000000000000000000000000001;
    #10;
    req4_data_in <= 32'b00000000000000000000000000000000;
    #20;
//-------------test for zero time shift right
	req4_cmd_in = 4'b0110;  
	req4_data_in = 32'h6DDC71EE;
	#10;
	req4_cmd_in = 4'b0000;  
	req4_data_in = 32'h00000000;
	#10;
	req4_data_in = 32'h00000000;
	#20;
//------------test for 31 times shift right 
	count2 = 0;
	for (int i = 0; i < 31; i++) begin
		count2++;
		req4_cmd_in = 4'b0110;  
		req4_data_in = 32'h6DDC71EE;
		#10;
		req4_cmd_in = 4'b0000;  
		req4_data_in = count2;
		#10;
		req4_data_in = 32'h00000000;
		#20;
	end
//------------test for big than 31 times shift right
	req4_cmd_in <= 4'b0110;  
	req4_data_in <= 32'hffffffff;
	#10;
	req4_cmd_in <= 4'b0000;  
	req4_data_in <= 32'h1800603f;
	#10;
	req4_data_in <= 32'h0;
	#20;
//------------test for invalid
	req4_cmd_in <= 4'b0111;  
	req4_data_in <= 32'h1;
	#10;
	req4_cmd_in <= 4'b0000;  
	req4_data_in <= 32'h1;
	#10;
	req4_data_in <= 32'h0;
	#20;
	

//--------------------------------------simultaneously--------------------------------------

//-----------------test for 4 add Simultaneously
	req1_cmd_in <= 4'b0001;
	req1_data_in <= 32'b00000000000000000000000000000001;
	req2_cmd_in <= 4'b0001;
	req2_data_in <= 32'b00000000000000000000000000000010;
	req3_cmd_in <= 4'b0001;
	req3_data_in <= 32'b10000000000000000000000000000000;
	req4_cmd_in <= 4'b0001;
	req4_data_in <= 32'b00000000000011000000000000000000;
	#20;
	req1_cmd_in <= 4'b0000;
	req1_data_in <= 32'b00000000000000000000000000000001;
	req2_cmd_in <= 4'b0000;
	req2_data_in <= 32'b00000000000000000000000000000010;
	req3_cmd_in <= 4'b0000;
	req3_data_in <= 32'b10000000000000000000000000000000;
	req4_cmd_in <= 4'b0000;
	req4_data_in <= 32'b00000000000011000000000000000000;
	#20;
	req1_data_in <= 32'b00000000000000000000000000000000;
	req2_data_in <= 32'b00000000000000000000000000000000;
	req3_data_in <= 32'b00000000000000000000000000000000;
	req4_data_in <= 32'b00000000000000000000000000000000;
	#100;
//--------------test for 4 sub simultaneously
	req1_cmd_in <= 4'b0010;
	req1_data_in <= 32'b00000000000000000000000000000111;
	req2_cmd_in <= 4'b0010;
	req2_data_in <= 32'b00000000000000000000000000000010;
	req3_cmd_in <= 4'b0010;
	req3_data_in <= 32'b10000000000000000000000000000000;
	req4_cmd_in <= 4'b0010;
	req4_data_in <= 32'b00000000000011000000000000000000;
	#20;
	req1_cmd_in <= 4'b0000;
	req1_data_in <= 32'b00000000000000000000000000000111;
	req2_cmd_in <= 4'b0000;
	req2_data_in <= 32'b00000000000000000000000000000010;
	req3_cmd_in <= 4'b0000;
	req3_data_in <= 32'b10000000000000000000000000000000;
	req4_cmd_in <= 4'b0000;
	req4_data_in <= 32'b00000000000011000000000000000000;
	#20;
	req1_data_in <= 32'b00000000000000000000000000000000;
	req2_data_in <= 32'b00000000000000000000000000000000;
	req3_data_in <= 32'b00000000000000000000000000000000;
	req4_data_in <= 32'b00000000000000000000000000000000;
	#100;
  
   //-----------------test for 4 shift right simultaneously
	req1_cmd_in = 4'b0110;
    req1_data_in = 32'b11011101111001110001110111101110;
    req2_cmd_in = 4'b0110;
    req2_data_in = 32'b11011101111001110001110111101110;
    req3_cmd_in = 4'b0110;
    req3_data_in = 32'b11011101111001110001110111101110;
    req4_cmd_in = 4'b0110;
    req4_data_in = 32'b11011101111001110001110111101110;
    #20;
    req1_cmd_in = 4'b0000;
    req1_data_in = 32'b00000000000000000000000000000111;
    req2_cmd_in = 4'b0000;
    req2_data_in = 32'b00000000000000000000000000000001;
    req3_cmd_in = 4'b0000;
    req3_data_in = 32'b00000000000000000000000000000000;
    req4_cmd_in = 4'b0000;
    req4_data_in = 32'b00000000000000000000000000011000;
    #20;
    req1_data_in = 32'b00000000000000000000000000000000;
    req2_data_in = 32'b00000000000000000000000000000000;
    req3_data_in = 32'b00000000000000000000000000000000;
    req4_data_in = 32'b00000000000000000000000000000000;
    #100;


//-----------------test for 4 shift left simultaneously
	req1_cmd_in = 4'b0101;
    req1_data_in = 32'b11011101111001110001110111101110;
    req2_cmd_in = 4'b0101;
    req2_data_in = 32'b11011101111001110001110111101110;
    req3_cmd_in = 4'b0101;
    req3_data_in = 32'b11011101111001110001110111101110;
    req4_cmd_in = 4'b0101;
    req4_data_in = 32'b11011101111001110001110111101110;
    #20;
	req1_cmd_in = 4'b0000;
    req1_data_in = 32'b00000000000000000000000000000111;
    req2_cmd_in = 4'b0000;
    req2_data_in = 32'b00000000000000000000000000000001;
    req3_cmd_in = 4'b0000;
    req3_data_in = 32'b00000000000000000000000000000000;
    req4_cmd_in = 4'b0000;
    req4_data_in = 32'b00000000000000000000000000011000;
    #20;
    req1_data_in = 32'b00000000000000000000000000000000;
    req2_data_in = 32'b00000000000000000000000000000000;
    req3_data_in = 32'b00000000000000000000000000000000;
    req4_data_in = 32'b00000000000000000000000000000000;
    #100;

//----------------test for add/sub simultaneously
	req1_cmd_in <= 4'b0010;  
	req1_data_in <= 32'b00000000000000000000000000000111;
	req2_cmd_in <= 4'b0001;  
	req2_data_in <= 32'b00000000000000000000000000000010;
	req3_cmd_in <= 4'b0010;  
	req3_data_in <= 32'b10000000000000000000000000000000;
	req4_cmd_in <= 4'b0001;  
	req4_data_in <= 32'b00000000000011000000000000000000;
	#20;
	req1_cmd_in <= 4'b0000;  
	req1_data_in <= 32'b00000000000000000000000000000111;
	req2_cmd_in <= 4'b0000;  
	req2_data_in <= 32'b00000000000000000000000000000010;
	req3_cmd_in <= 4'b0000;  
	req3_data_in <= 32'b10000000000000000000000000000000;
	req4_cmd_in <= 4'b0000;  
	req4_data_in <= 32'b00000000000011000000000000000000;
	#20;
	req1_data_in <= 32'b00000000000000000000000000000000;
	req2_data_in <= 32'b00000000000000000000000000000000;
	req3_data_in <= 32'b00000000000000000000000000000000;
	req4_data_in <= 32'b00000000000000000000000000000000;
	#100;

//----------------test for shift left/right simultaneously

	req1_cmd_in <= 4'b0101;
    req1_data_in <= 32'b11011101111001110001110111101110;
    req2_cmd_in <= 4'b0110;
    req2_data_in <= 32'b11011101111001110001110111101110;
    req3_cmd_in <= 4'b0101;
    req3_data_in <= 32'b11011101111001110001110111101110;
    req4_cmd_in <= 4'b0110;
    req4_data_in <= 32'b11011101111001110001110111101110;
    #20; // Wait for 20 ns
    
    
    req1_cmd_in <= 4'b0000;
    req1_data_in <= 32'b00000000000000000000000000000111;
    req2_cmd_in <= 4'b0000;
    req2_data_in <= 32'b00000000000000000000000000000001;
    req3_cmd_in <= 4'b0000;
    req3_data_in <= 32'b00000000000000000000000000000000;
    req4_cmd_in <= 4'b0000;
    req4_data_in <= 32'b00000000000000000000000000011000;
    #20; // Wait for 20 ns
    
    
    req1_data_in <= 32'b0;
    req2_data_in <= 32'b0;
    req3_data_in <= 32'b0;
    req4_data_in <= 32'b0;
    #100; // Wait for 100 ns

//----------------test for all command simultaneously

	req1_cmd_in = 4'b0101;  
  req1_data_in = 32'hDEECEBAA;
  req2_cmd_in = 4'b0010;  
  req2_data_in = 32'hDEECEBAA;
  req3_cmd_in = 4'b0001;  
  req3_data_in = 32'hDEECEBAA;
  req4_cmd_in = 4'b0110;  
  req4_data_in = 32'hDEECEBAA;
  #20;
  req1_cmd_in = 4'b0000;  
  req1_data_in = 32'h00000007;
  req2_cmd_in = 4'b0000;  
  req2_data_in = 32'h00000001;
  req3_cmd_in = 4'b0000;  
  req3_data_in = 32'h00000000;
  req4_cmd_in = 4'b0000;  
  req4_data_in = 32'h00000018;
  #20;
  req1_data_in = 32'h00000000;
  req2_data_in = 32'h00000000;
  req3_data_in = 32'h00000000;
  req4_data_in = 32'h00000000;
  #100;

//--------------test with delay for commands
	req1_cmd_in <= 4'b0001;  
	req1_data_in <= 32'b00000000000000000000000000000001;
	#20;
	req1_cmd_in <= 4'b0000;  
	req1_data_in <= 32'b00000000000000000000000000000010;
	req2_cmd_in <= 4'b0001;  
	req2_data_in <= 32'h80000000;
	#20;
	req1_data_in <= 32'b00000000000000000000000000000000;
	req2_cmd_in <= 4'b0000;  
	req2_data_in <= 32'h00030000;
	#20;
	req2_data_in <= 32'b00000000000000000000000000000000;
	req3_cmd_in <= 4'b0001;  
	req3_data_in <= 32'b00000000000000000000000000000001;
	#20;
	req3_cmd_in <= 4'b0000;  
	req3_data_in <= 32'b00000000000000000000000000000010;
	#20;
	req3_data_in <= 32'b00000000000000000000000000000000;
	req4_cmd_in <= 4'b0001;  
	req4_data_in <= 32'h00030000;
	#20;
	req4_cmd_in <= 4'b0000;  
	req4_data_in <= 32'h00030000;
	req1_cmd_in <= 4'b0010;  
	req1_data_in <= 32'h00030000;
	#20;
	req4_data_in <= 32'b00000000000000000000000000000000;
	req1_cmd_in <= 4'b0000;  
	req1_data_in <= 32'b00000000000000000000000000000010;
	req2_cmd_in <= 4'b0010;  
	req2_data_in <= 32'h80000000;
	#20;
	req1_data_in <= 32'b00000000000000000000000000000000;
	req2_cmd_in <= 4'b0000;  
	req2_data_in <= 32'h00030000;
	req3_cmd_in <= 4'b0010;  
	req3_data_in <= 32'b00000000000000000000000000000010;
	#20;
	req2_data_in <= 32'b00000000000000000000000000000000;
	req3_cmd_in <= 4'b0000;  
	req3_data_in <= 32'b00000000000000000000000000000010;
	req4_cmd_in <= 4'b0010;  
	req4_data_in <= 32'h00030000;
	#20;
	req3_data_in <= 32'b00000000000000000000000000000000;
	req4_cmd_in <= 4'b0000;  
	req4_data_in <= 32'h00030000;
	#20;
	req4_data_in <= 32'b00000000000000000000000000000000;
	#100;
$finish;
end  
endmodule
