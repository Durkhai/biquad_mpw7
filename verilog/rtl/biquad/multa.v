/* ********************************************************************************* */
/*                      multiplier place holder                                      */
/*                                                                                   */
/*  Author:  Chuck Cox (chuck100@home.com)                                           */
/*                                                                                   */
/*                                                                                   */
/*                                                                                   */
/* ********************************************************************************* */


module multa#(
    parameter	DATAWIDTH = 12,
    parameter	COEFWIDTH = 16
)
	(
    `ifdef USE_POWER_PINS
		inout vccd1,
		inout vssd1,
    `endif 
	input clk,			/* clock */
	input nreset,			/* active low reset */
	input	[COEFWIDTH-2:0] a,			/* data input */
	input	[DATAWIDTH+2:0] b,			/* input data valid */
	output	[DATAWIDTH + COEFWIDTH + 1:0]	r		/* filter pole coefficient */
	);

assign r = a*b;


endmodule
