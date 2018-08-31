`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:58:40 10/30/2017 
// Design Name: 
// Module Name:    I2C_interfaces 
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
module I2C_interfaces(
	inout DAQ_LDSDA,
	output DAQ_LDSCL,
	inout TRG_LDSDA,
	output TRG_LDSCL,
	output NVIO_I2C_EN,
	inout NVIO_SDA_25,
	output NVIO_SCL_25
);

wire daq_ldsda_dir;
wire daq_ldsda_in;
wire daq_ldsda_out;
wire daq_ldscl_out;

wire trg_ldsda_dir;
wire trg_ldsda_in;
wire trg_ldsda_out;
wire trg_ldscl_out;

wire nvio_i2c_enb;
wire nvio_sda_25_dir;
wire nvio_sda_25_in;
wire nvio_sda_25_out;
wire nvio_scl_25_out;

assign daq_ldsda_dir = 1'b1;
assign daq_ldsda_out = 1'b1;
assign daq_ldscl_out = 1'b1;

assign trg_ldsda_dir = 1'b1;
assign trg_ldsda_out = 1'b1;
assign trg_ldscl_out = 1'b1;

assign nvio_i2c_enb = 1'b0;
assign nvio_sda_25_dir = 1'b1;
assign nvio_sda_25_out = 1'b1;
assign nvio_scl_25_out = 1'b1;

  IOBUF #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) IOBUF_DAQ_LDSDA (.O(daq_ldsda_in),.IO(DAQ_LDSDA),.I(daq_ldsda_out),.T(daq_ldsda_dir));
  OBUF  #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_DAQ_LDSCL (.O(DAQ_LDSCL),.I(daq_ldscl_out));

  IOBUF #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) IOBUF_TRG_LDSDA (.O(trg_ldsda_in),.IO(TRG_LDSDA),.I(trg_ldsda_out),.T(trg_ldsda_dir));
  OBUF  #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_TRG_LDSCL (.O(TRG_LDSCL),.I(trg_ldscl_out));

  OBUF  #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_NVIO_I2C_EN (.O(NVIO_I2C_EN),.I(nvio_i2c_enb));
  IOBUF #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) IOBUF_NVIO_SDA_25 (.O(nvio_sda_25_in),.IO(NVIO_SDA_25),.I(nvio_sda_25_out),.T(nvio_sda_25_dir));
  OBUF  #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_NVIO_SCL_25 (.O(NVIO_SCL_25),.I(nvio_scl_25_out));


endmodule
