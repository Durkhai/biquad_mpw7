/* ********************************************************************************* */
/*        Wishbone compatible IO module for read/write of filter coefficients        */
/*                                                                                   */
/*  Author:  Chuck Cox (chuck100@home.com)                                           */
/*                                                                                   */
/* Wishbone data:								     								 */
/* General description:  16x5 register file					    					 */
/* Supported cycles:  Slave Read/write, block read/write, RMW			     		 */
/* Data port size:  16 bit							     							 */
/* Data port granularity: 16 bit						     						 */
/* Data port maximum operand size:  16 bit					     					 */
/*                                                                                   */
/*      Addr	register							     							 */
/*		0x0		a11								    								 */
/*		0x1		a12								   									 */
/*  	0x2		b10								     								 */
/*		0x3		b11								   								     */
/*		0x4		b12								     								 */
/*                                                                                   */
/*  Filter coefficients need to be written as 16 bit twos complement fractional	     */
/*  numbers.  For example:  0100_0000_0000_0001 = 2^-1 + 2^-15 = .500030517578125    */
/* 										     										 */
/*  The biquad filter module is parameterized.  If a filter with coefficients less   */
/*  than 16 bits in length is selected then the most significant bits shall be used. */
/* ********************************************************************************* */



module coefio # (
     parameter DATAWIDTH = 12
)
	(
    `ifdef USE_POWER_PINS
		inout vccd1,
		inout vssd1,
    `endif 
	input clk_i,
	input rst_i,
	input we_i,	
	input stb_i,
	input cyc_i,
	output wire ack_o,
	input	[31:0]	dat_i,
	output	[31:0]	dat_o,
	input	[31:0]	adr_i,
	output  reg [31:0]	a11,
	output	reg [31:0]	a12,
	output	reg [31:0]	b10,
	output	reg [31:0]	b11,
	output	reg [31:0]	b12,
	input   [DATAWIDTH-1:0] x, 
	input   [DATAWIDTH-1:0] y
	);

wire		sel_a11;
wire		sel_a12;
wire		sel_b10;
wire		sel_b11;
wire		sel_b12;
wire        sel_y;
wire        sel_x;

/*
assign sel_a11 = (adr_i == 4'b0000);  
assign sel_a12 = (adr_i == 4'b0001);
assign sel_b10 = (adr_i == 4'b0010);
assign sel_b11 = (adr_i == 4'b0011);
assign sel_b12 = (adr_i == 4'b0100);
assign sel_x   = (adr_i == 4'b0101);
assign sel_y   = (adr_i == 4'b0110);
*/

assign sel_a11 = (adr_i == 4'h30000000);  
assign sel_a12 = (adr_i == 4'h30000004);
assign sel_b10 = (adr_i == 4'h30000008);
assign sel_b11 = (adr_i == 4'h3000000c);
assign sel_b12 = (adr_i == 4'h30000010);
assign sel_x   = (adr_i == 4'h30000014);
assign sel_y   = (adr_i == 4'h30000018);

assign ack_o = stb_i;

always @(posedge clk_i or posedge rst_i)
if ( rst_i )
  begin
    a11 <= 32'd0;
    a12 <= 32'd0;
    b10 <= 32'd0;
    b11 <= 32'd0;
    b12 <= 32'd0;
  end
else
  begin
    a11 <= (stb_i & we_i & cyc_i & sel_a11) ? (dat_i) : (a11);
    a12 <= (stb_i & we_i & cyc_i & sel_a12) ? (dat_i) : (a12);
    b10 <= (stb_i & we_i & cyc_i & sel_b10) ? (dat_i) : (b10);
    b11 <= (stb_i & we_i & cyc_i & sel_b11) ? (dat_i) : (b11);
    b12 <= (stb_i & we_i & cyc_i & sel_b12) ? (dat_i) : (b12);
  end

assign dat_o = sel_a11 ? (a11) : 
		((sel_a12) ? (a12) : 
		((sel_b10) ? (b10) : 
		((sel_b11) ? (b11) : 
		((sel_b12) ? (b12) : 
		((sel_x)   ? ({20'b0,x[11:0]}) :
		((sel_y)   ? ({20'b0,y[11:0]}) :
		(32'h0000)))))));


endmodule
