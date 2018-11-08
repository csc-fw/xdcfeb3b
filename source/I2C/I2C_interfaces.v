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
module I2C_interfaces #(
	parameter Simulation = 0,
	parameter USE_CHIPSCOPE = 0
)(
	input	CLK40,
	input	CLK1MHZ,
	input	RST,
	
	inout DAQ_LDSDA,
	input DAQ_LDSDA_RTN,
	output DAQ_LDSCL,
	
	inout TRG_LDSDA,
	input TRG_LDSDA_RTN,
	output TRG_LDSCL,
	
	output NVIO_I2C_EN,
	inout NVIO_SDA_25,
	output NVIO_SCL_25,
	
	// JTAG signals
	input [7:0] I2C_WRT_FIFO_DATA,  // Data word for I2C write FIFO
	input I2C_WE,               // Write enable for I2C Write FIFO
	input I2C_RDENA,            // Read enable for I2C Readback FIFO
	input I2C_RESET,                // Reset I2C FIFO
	input I2C_START,                // Start I2C processing

	output [7:0] I2C_RBK_FIFO_DATA, // Data read back from I2C device
	output I2C_CLR_START,           // Clear the I2C_START instruction
	output [7:0] I2C_STATUS         // STATUS word for I2C interface
	
);

wire daq_ldsda_dir;
wire daq_ldsda_in;
wire daq_ldsda_rtn;
wire daq_ldsda_out;
wire daq_ldscl_out;

wire trg_ldsda_dir;
wire trg_ldsda_in;
wire trg_ldsda_rtn;
wire trg_ldsda_out;
wire trg_ldscl_out;

wire nvio_i2c_enb;
wire nvio_sda_25_dir;
wire nvio_sda_25_in;
wire nvio_sda_25_out;
wire nvio_scl_25_out;


//wire trg_tristate_sda;
//wire daq_tristate_sda;
//wire nvio_tristate_sda;

assign daq_ldsda_dir = daq_ldsda_out;
//assign daq_ldsda_dir = daq_tristate_sda;

assign trg_ldsda_dir = trg_ldsda_out;
//assign trg_ldsda_dir = trg_tristate_sda;

assign nvio_sda_25_dir = nvio_sda_25_out;
//assign nvio_sda_25_dir = nvio_tristate_sda;
//assign nvio_sda_25_dir = 1'b0;

  IOBUF #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) IOBUF_DAQ_LDSDA (.O(daq_ldsda_in),.IO(DAQ_LDSDA),.I(daq_ldsda_out),.T(daq_ldsda_dir));
  IBUF  #(.IBUF_LOW_PWR("TRUE"),.IOSTANDARD("DEFAULT"))    IBUF_DAQ_LDSDA_RTN (.O(daq_ldsda_rtn),.I(DAQ_LDSDA_RTN));
  OBUFT #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUFT_DAQ_LDSCL (.O(DAQ_LDSCL),.I(daq_ldscl_out),.T(daq_ldscl_out));

  IOBUF #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) IOBUF_TRG_LDSDA (.O(trg_ldsda_in),.IO(TRG_LDSDA),.I(trg_ldsda_out),.T(trg_ldsda_dir));
  IBUF  #(.IBUF_LOW_PWR("TRUE"),.IOSTANDARD("DEFAULT"))    IBUF_TRG_LDSDA_RTN (.O(trg_ldsda_rtn),.I(TRG_LDSDA_RTN));
  OBUFT #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUFT_TRG_LDSCL (.O(TRG_LDSCL),.I(trg_ldscl_out),.T(trg_ldscl_out));

  OBUF  #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_NVIO_I2C_EN (.O(NVIO_I2C_EN),.I(nvio_i2c_enb));
  IOBUF #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) IOBUF_NVIO_SDA_25 (.O(nvio_sda_25_in),.IO(NVIO_SDA_25),.I(nvio_sda_25_out),.T(nvio_sda_25_dir));
  OBUF  #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_NVIO_SCL_25 (.O(NVIO_SCL_25),.I(nvio_scl_25_out));

wire rst_fifo;
wire wrt_full;
wire wrt_empty;
wire rd_full;
wire rd_empty;
wire read_ff;
wire load_dev;
wire load_n_byte;
wire load_addr;
wire wrt_ena;
wire [7:0] ff_dout;
reg [3:0] n_bytes;
reg I2C_read;
wire execute;
reg [3:0] wrt_addr;
wire clr_wrt_addr;

wire [3:0] I2C_parser_state;

wire rbk_we;
wire daq_rbk_we;
wire trg_rbk_we;
wire nvio_rbk_we;

wire [7:0] rbk_data;
wire [7:0] daq_rbk_data;
wire [7:0] trg_rbk_data;
wire [7:0] nvio_rbk_data;

wire gbl_ready;
wire daq_ready;
wire trg_ready;
wire nvio_ready;

reg  trg_sel;
reg  daq_sel;
reg  nvio_sel;

assign clr_wrt_addr = RST || load_addr;
assign gbl_ready = (daq_sel || trg_sel || nvio_sel) && ((!daq_sel || (daq_sel && daq_ready)) && (!trg_sel || (trg_sel && trg_ready)) && (!nvio_sel || (nvio_sel && nvio_ready)));
assign rbk_data  =  daq_sel ? daq_rbk_data : (trg_sel ? trg_rbk_data : (nvio_sel ? nvio_rbk_data : 8'h00));
assign rbk_we    =  daq_sel ? daq_rbk_we   : (trg_sel ? trg_rbk_we   : (nvio_sel ? nvio_rbk_we   : 1'b0));

assign rst_fifo = RST || I2C_RESET;

generate
if(Simulation==1)
begin : Sim_I2C_FIFOs
	// I2C write FIFO
	reg [4:0] I2C_wrt_waddr;
	reg [4:0] I2C_wrt_raddr;
	reg [7:0] I2C_wrt_fifo [31:0];
	
	always @(posedge CLK40 or posedge rst_fifo) begin
		if(rst_fifo) begin
			I2C_wrt_waddr <= 5'h00;
		end
		else
			if(I2C_WE) begin
				I2C_wrt_waddr <= I2C_wrt_waddr + 1;
			end
	end
	always @(posedge CLK40) begin
		if(I2C_WE) I2C_wrt_fifo[I2C_wrt_waddr] <= I2C_WRT_FIFO_DATA;
	end
	
	always @(posedge CLK40 or posedge rst_fifo) begin
		if(rst_fifo) begin
			I2C_wrt_raddr <= 5'h00;
		end
		else
			if (read_ff) begin
				I2C_wrt_raddr <= I2C_wrt_raddr + 1;
			end
	end
	assign ff_dout = I2C_wrt_fifo[I2C_wrt_raddr];
	assign wrt_full = (I2C_wrt_waddr-I2C_wrt_raddr)==5'h1F;
	assign wrt_empty   = I2C_wrt_waddr==I2C_wrt_raddr;
	
	// I2C readback FIFO
	reg [4:0] I2C_rbk_waddr;
	reg [4:0] I2C_rbk_raddr;
	reg [7:0] I2C_rbk_fifo [31:0];
	
	always @(posedge CLK40 or posedge rst_fifo) begin
		if(rst_fifo) begin
			I2C_rbk_waddr <= 5'h00;
		end
		else
			if(rbk_we) begin
				I2C_rbk_waddr <= I2C_rbk_waddr + 1;
			end
	end
	always @(posedge CLK40) begin
		if(rbk_we) I2C_rbk_fifo[I2C_rbk_waddr] <= rbk_data;
	end
	
	always @(posedge CLK40 or posedge rst_fifo) begin
		if(rst_fifo) begin
			I2C_rbk_raddr <= 5'h00;
		end
		else
			if (I2C_RDENA) begin
				I2C_rbk_raddr <= I2C_rbk_raddr + 1;
			end
	end
	assign I2C_RBK_FIFO_DATA = I2C_rbk_fifo[I2C_rbk_raddr];
	assign rd_full    = (I2C_rbk_waddr-I2C_rbk_raddr)==5'h1F;
	assign rd_empty   = I2C_rbk_waddr==I2C_rbk_raddr;
	
end
else
begin : builtin_I2C_FIFOs

I2C_write_FIFO
I2C_write_FIFO_i (
  .clk(CLK40), // input clk
  .rst(rst_fifo), // input rst
  .din(I2C_WRT_FIFO_DATA), // input [7 : 0] din
  .wr_en(I2C_WE), // input wr_en
  .rd_en(read_ff), // input rd_en
  .dout(ff_dout), // output [7 : 0] dout
  .full(wrt_full), // output full
  .empty(wrt_empty) // output empty
);

I2C_rbk_FIFO
I2C_rbk_FIFO_i (
  .clk(CLK40), // input clk
  .rst(rst_fifo), // input rst
  .din(rbk_data), // input [7 : 0] din
  .wr_en(rbk_we), // input wr_en
  .rd_en(I2C_RDENA), // input rd_en
  .dout(I2C_RBK_FIFO_DATA), // output [7 : 0] dout
  .full(rd_full), // output full
  .empty(rd_empty) // output empty
);
	
end
endgenerate

always @(posedge CLK40 or posedge clr_wrt_addr) begin
	if(clr_wrt_addr) begin
		wrt_addr = 4'h0;
	end
	else begin
	   if(wrt_ena) begin
		   wrt_addr = wrt_addr +1;
		end
	end
end

always @(posedge CLK40 or posedge rst_fifo) begin
	if(rst_fifo) begin
		daq_sel  <= 1'b0;
		trg_sel  <= 1'b0;
		nvio_sel <= 1'b0;
	end
	else begin
		if(load_dev) begin
			trg_sel  <= ff_dout[2];
			daq_sel  <= ff_dout[1];
			nvio_sel <= ff_dout[0];
		end
	end
end

always @(posedge CLK40 or posedge rst_fifo) begin
	if(rst_fifo) begin
		n_bytes <= 4'h0;
		I2C_read <= 1'b0;
	end
	else begin
		if(load_n_byte) begin
			n_bytes <= ff_dout[7:4];
			I2C_read <= ff_dout[3];
		end
	end
end

I2C_cmd_parser_FSM
I2C_parser_i (
   // outputs
	.CLR_START(I2C_CLR_START),
	.EXECUTE(execute),
	.LD_ADDR(load_addr),
	.LD_DEV(load_dev),
	.LD_N_BYTE(load_n_byte),
	.NVIO_ENA(nvio_i2c_enb),
	.READ_FF(read_ff),
	.WRT_ENA(wrt_ena),
	.I2C_PARSER_STATE(I2C_parser_state),
   // inputs
	.CLK(CLK40),
	.I2C_START(I2C_START),
	.MT(wrt_empty),
	.N_BYTES(n_bytes),
	.READ(I2C_read),
	.READY(gbl_ready),
	.RST(rst_fifo)
);

//
// TRG laser driver optical transmitter
//

I2C_intrf #(
		.USE_CHIPSCOPE(0),
		.Dev_Addr(8'hFC)
	)		
I2C_TRG_LD_i  (
	//Inputs
	.CLK40(CLK40),
	.CLK1MHZ(CLK1MHZ),
	.RST(rst_fifo),
	.RTN_DATA(trg_ldsda_rtn),
	.DEV_SEL(trg_sel),
	.LOAD_N_BYTE(load_n_byte),
	.LOAD_ADDR(load_addr),
	.WRT_ADDR(wrt_addr),
	.WRT_DATA(ff_dout),
	.WRT_ENA(wrt_ena),
	.EXECUTE(execute),
	//Outputs
	.READY(trg_ready),
	.RBK_WE(trg_rbk_we),
	.RBK_DATA(trg_rbk_data),
//	.TRISTATE_SDA(trg_tristate_sda),
	.SCL(trg_ldscl_out),
	.SDA(trg_ldsda_out)
);

//
// DAQ laser driver optical transmitter
//

I2C_intrf #(
		.USE_CHIPSCOPE(0),
		.Dev_Addr(8'hFC)
	)		
I2C_DAQ_LD_i  (
	//Inputs
	.CLK40(CLK40),
	.CLK1MHZ(CLK1MHZ),
	.RST(rst_fifo),
	.RTN_DATA(daq_ldsda_rtn),
	.DEV_SEL(daq_sel),
	.LOAD_N_BYTE(load_n_byte),
	.LOAD_ADDR(load_addr),
	.WRT_ADDR(wrt_addr),
	.WRT_DATA(ff_dout),
	.WRT_ENA(wrt_ena),
	.EXECUTE(execute),
	//Outputs
	.READY(daq_ready),
	.RBK_WE(daq_rbk_we),
	.RBK_DATA(daq_rbk_data),
//	.TRISTATE_SDA(daq_tristate_sda),
	.SCL(daq_ldscl_out),
	.SDA(daq_ldsda_out)
);


//
// Non-Volatile I/O devjice DS4550
//

I2C_intrf #(
		.USE_CHIPSCOPE(0),
		.Dev_Addr(8'hA2)
	)		
I2C_NVIO_i  (
	//Inputs
	.CLK40(CLK40),
	.CLK1MHZ(CLK1MHZ),
	.RST(rst_fifo),
	.RTN_DATA(nvio_sda_25_in),
	.DEV_SEL(nvio_sel),
	.LOAD_N_BYTE(load_n_byte),
	.LOAD_ADDR(load_addr),
	.WRT_ADDR(wrt_addr),
	.WRT_DATA(ff_dout),
	.WRT_ENA(wrt_ena),
	.EXECUTE(execute),
	//Outputs
	.READY(nvio_ready),
	.RBK_WE(nvio_rbk_we),
	.RBK_DATA(nvio_rbk_data),
//	.TRISTATE_SDA(nvio_tristate_sda),
	.SCL(nvio_scl_25_out),
	.SDA(nvio_sda_25_out)
);

endmodule
