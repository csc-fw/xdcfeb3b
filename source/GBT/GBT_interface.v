`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:46:05 10/30/2017 
// Design Name: 
// Module Name:    GBT_intrf 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module GBT_interface(
	//internal inputs
	input GBT_ENA_TEST,
	input [15:0] GBT_DATA_IN,
	//external inputs
	input  GBT_RXRDY_FPGA,
	input  GBT_RXDATAVALID_FPGA,
	//external oputputs
	output GBT_TXVD,
	output GBT_TEST_MODE,
	output [15:0] GBT_RTN_DATA_P,
	output [15:0] GBT_RTN_DATA_N
);

wire [15:0] to_gbtx;
wire rx_rdy;
wire rxdatavalid;
wire txdatavalid;
wire txvd;
//reg rxvd;



	IBUF  #(.IBUF_LOW_PWR("TRUE"),.IOSTANDARD("DEFAULT"))    IBUF_GBT_RXRDY_FPGA  (.O(rx_rdy),.I(GBT_RXRDY_FPGA));
	IBUF  #(.IBUF_LOW_PWR("TRUE"),.IOSTANDARD("DEFAULT"))    IBUF_GBT_RXDATAVALID_FPGA (.O(rxdatavalid),.I(GBT_RXDATAVALID_FPGA));
	OBUF  #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_GBT_TX_VALID (.O(GBT_TXVD),.I(txdatavalid));
	OBUF  #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_GBT_TEST_MODE (.O(GBT_TEST_MODE),.I(GBT_ENA_TEST));
	OBUFDS #(.IOSTANDARD("DEFAULT")) OBUFDS_GBT_RTN_DATA[15:0] (.O(GBT_RTN_DATA_P),.OB(GBT_RTN_DATA_N),.I(to_gbtx));

assign txdatavalid = GBT_ENA_TEST ? txvd : 1'b0;
assign to_gbtx = GBT_DATA_IN;
assign txvd = rxdatavalid && rx_rdy;

endmodule
