`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:27:42 01/14/2014 
// Design Name: 
// Module Name:    al_buckeye_load 
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
module al_buckeye_load #(
	parameter TMR = 0
)(
    input CLK40,
    input CLK1MHZ,
    input RST,
    input SLOW_FIFO_RST,
    input CLR_AL_DONE,
    input CAPTURE,
	 input LOAD_DFLT,
    input [15:0] BPI_AL_REG,
    output AL_BKY_ENA,
    output SHCK_ENA,
    output SDATA,
    output AL_DONE
    );
	 
	wire set_done;
	wire load_bky_dflt_i;

// FIFO signals
	wire bky_mt;
	wire bky_full;
	wire bky_sbiterr;
	wire bky_dbiterr;
	wire bky_rdena;
	wire [15:0] bky_data;
	 
generate
if(TMR==1) 
begin : BkyLd_FSM_TMR

	(* syn_preserve = "true" *) reg load_bky_1;
	(* syn_preserve = "true" *) reg load_bky_2;
	(* syn_preserve = "true" *) reg load_bky_3;
	(* syn_preserve = "true" *) reg load_bky_dflt_1;
	(* syn_preserve = "true" *) reg load_bky_dflt_2;
	(* syn_preserve = "true" *) reg load_bky_dflt_3;
	(* syn_preserve = "true" *) reg done_1;
	(* syn_preserve = "true" *) reg done_2;
	(* syn_preserve = "true" *) reg done_3;
	(* syn_preserve = "true" *) reg [15:0] bky_shft_1;
	(* syn_preserve = "true" *) reg [15:0] bky_shft_2;
	(* syn_preserve = "true" *) reg [15:0] bky_shft_3;

	(* syn_keep = "true" *) wire vt_load_bky_1;
	(* syn_keep = "true" *) wire vt_load_bky_2;
	(* syn_keep = "true" *) wire vt_load_bky_3;
	(* syn_keep = "true" *) wire vt_load_bky_dflt_1;
	(* syn_keep = "true" *) wire vt_load_bky_dflt_2;
	(* syn_keep = "true" *) wire vt_load_bky_dflt_3;
	(* syn_keep = "true" *) wire vt_done_1;
	(* syn_keep = "true" *) wire vt_done_2;
	(* syn_keep = "true" *) wire vt_done_3;
	
	(* syn_keep = "true" *) wire sdata_1;
	(* syn_keep = "true" *) wire sdata_2;
	(* syn_keep = "true" *) wire sdata_3;
	
	assign vt_load_bky_1 = (load_bky_1 & load_bky_2) | (load_bky_2 & load_bky_3) | (load_bky_1 & load_bky_3); // Majority logic
	assign vt_load_bky_2 = (load_bky_1 & load_bky_2) | (load_bky_2 & load_bky_3) | (load_bky_1 & load_bky_3); // Majority logic
	assign vt_load_bky_3 = (load_bky_1 & load_bky_2) | (load_bky_2 & load_bky_3) | (load_bky_1 & load_bky_3); // Majority logic
	assign vt_load_bky_dflt_1 = (load_bky_dflt_1 & load_bky_dflt_2) | (load_bky_dflt_2 & load_bky_dflt_3) | (load_bky_dflt_1 & load_bky_dflt_3); // Majority logic
	assign vt_load_bky_dflt_2 = (load_bky_dflt_1 & load_bky_dflt_2) | (load_bky_dflt_2 & load_bky_dflt_3) | (load_bky_dflt_1 & load_bky_dflt_3); // Majority logic
	assign vt_load_bky_dflt_3 = (load_bky_dflt_1 & load_bky_dflt_2) | (load_bky_dflt_2 & load_bky_dflt_3) | (load_bky_dflt_1 & load_bky_dflt_3); // Majority logic
	assign vt_done_1     = (done_1     & done_2    ) | (done_2     & done_3    ) | (done_1     & done_3    ); // Majority logic
	assign vt_done_2     = (done_1     & done_2    ) | (done_2     & done_3    ) | (done_1     & done_3    ); // Majority logic
	assign vt_done_3     = (done_1     & done_2    ) | (done_2     & done_3    ) | (done_1     & done_3    ); // Majority logic

	always @(posedge CLK40 or posedge RST) begin
		if(RST) begin
			load_bky_1 <= 1'b0;
			load_bky_2 <= 1'b0;
			load_bky_3 <= 1'b0;
			load_bky_dflt_1 <= 1'b0;
			load_bky_dflt_2 <= 1'b0;
			load_bky_dflt_3 <= 1'b0;
			done_1 <= 1'b0;
			done_2 <= 1'b0;
			done_3 <= 1'b0;
		end
		else begin
			load_bky_1 <= vt_done_1      ? 1'b0 : (CAPTURE   ? 1'b1 : vt_load_bky_1);
			load_bky_2 <= vt_done_2      ? 1'b0 : (CAPTURE   ? 1'b1 : vt_load_bky_2);
			load_bky_3 <= vt_done_3      ? 1'b0 : (CAPTURE   ? 1'b1 : vt_load_bky_3);
			load_bky_dflt_1 <= vt_done_1 ? 1'b0 : (LOAD_DFLT ? 1'b1 : vt_load_bky_dflt_1);
			load_bky_dflt_2 <= vt_done_2 ? 1'b0 : (LOAD_DFLT ? 1'b1 : vt_load_bky_dflt_2);
			load_bky_dflt_3 <= vt_done_3 ? 1'b0 : (LOAD_DFLT ? 1'b1 : vt_load_bky_dflt_3);
			done_1 <= CLR_AL_DONE ? 1'b0 : (set_done ? 1'b1 : vt_done_1);
			done_2 <= CLR_AL_DONE ? 1'b0 : (set_done ? 1'b1 : vt_done_2);
			done_3 <= CLR_AL_DONE ? 1'b0 : (set_done ? 1'b1 : vt_done_3);
		end
	end

	always @(negedge CLK1MHZ or posedge RST) begin
		if(RST) begin
			bky_shft_1 <= 16'h0000;
			bky_shft_2 <= 16'h0000;
			bky_shft_3 <= 16'h0000;
		end
		else begin
			bky_shft_1 <= bky_rdena ? bky_data : (SHCK_ENA ? {1'b0,bky_shft_1[15:1]} : bky_shft_1);
			bky_shft_2 <= bky_rdena ? bky_data : (SHCK_ENA ? {1'b0,bky_shft_2[15:1]} : bky_shft_2);
			bky_shft_3 <= bky_rdena ? bky_data : (SHCK_ENA ? {1'b0,bky_shft_3[15:1]} : bky_shft_3);
		end
	end


	bky_load_FSM_TMR         //States change on negative edge of clock
	bky_load_FSM_i(
	  .RDENA(bky_rdena),
	  .SET_DONE(set_done),
	  .SHFT_ENA(SHCK_ENA),
	  .CLK(CLK1MHZ),
	  .MT(bky_mt),
	  .RST(RST),
	  .START(vt_load_bky_1 || vt_load_bky_dflt_1) 
	);
	
	assign sdata_1 = bky_shft_1[0];
	assign sdata_2 = bky_shft_2[0];
	assign sdata_3 = bky_shft_3[0];
	assign SDATA   = (sdata_1 & sdata_2) | (sdata_2 & sdata_3) | (sdata_1 & sdata_3); // Majority logic
	assign AL_BKY_ENA = vt_load_bky_1 || vt_load_bky_dflt_1;
	assign AL_DONE = vt_done_1;
	assign load_bky_dflt_i = vt_load_bky_dflt_1;

end
else 
begin : BkyLd_FSM

	reg load_bky;
	reg load_bky_dflt;
	reg done;
	reg [15:0] bky_shft;

	always @(negedge CLK1MHZ or posedge RST) begin
		if(RST) begin
			bky_shft <= 16'h0000;
		end
		else begin
			bky_shft <= bky_rdena ? bky_data : (SHCK_ENA ? {1'b0,bky_shft[15:1]} : bky_shft);
		end
	end

	always @(posedge CLK40 or posedge RST) begin
		if(RST) begin
			load_bky <= 1'b0;
			load_bky_dflt <= 1'b0;
			done <= 1'b0;
		end
		else begin
			load_bky      <= done        ? 1'b0 : (CAPTURE   ? 1'b1 : load_bky);
			load_bky_dflt <= done        ? 1'b0 : (LOAD_DFLT ? 1'b1 : load_bky_dflt);
			done          <= CLR_AL_DONE ? 1'b0 : (set_done  ? 1'b1 : done);
		end
	end

	bky_load_FSM         //States change on negative edge of clock
	bky_load_FSM_i(
	  .RDENA(bky_rdena),
	  .SET_DONE(set_done),
	  .SHFT_ENA(SHCK_ENA),
	  .CLK(CLK1MHZ),
	  .MT(bky_mt),
	  .RST(RST),
	  .START(load_bky || load_bky_dflt) 
	);
	
	assign SDATA = bky_shft[0];
	assign AL_BKY_ENA = load_bky || load_bky_dflt;
	assign AL_DONE = done;
	assign load_bky_dflt_i = load_bky_dflt;

end
endgenerate
	
reg [17:0] dflt_srl;
wire dflt_we;
wire [15:0] ff_data;

// pipeline for loading default bits into FIFO
(* syn_srlstyle = "select_srl" *)
always @(posedge CLK40) begin
	dflt_srl <= {dflt_srl[16:0],load_bky_dflt_i};
end

assign dflt_we = load_bky_dflt_i && !dflt_srl[17];
assign ff_data = load_bky_dflt_i ? 16'h0000 : BPI_AL_REG;


// ECC protected FIFO, 16 bit wide 512 words deep
al_Buckeye_load_FIFO 
al_Buckeye_load_FIFO_i (
  .rst(SLOW_FIFO_RST),   // input rst
  .wr_clk(CLK40),        // input wr_clk
  .rd_clk(~CLK1MHZ),     // input rd_clk
  .din(ff_data),         // input [15 : 0] din
  .wr_en(CAPTURE || dflt_we), // input wr_en
  .rd_en(bky_rdena),     // input rd_en
  .dout(bky_data),       // output [15 : 0] dout
  .full(bky_full),       // output full
  .empty(bky_mt),        // output empty
  .sbiterr(bky_sbiterr), // output sbiterr
  .dbiterr(bky_dbiterr)  // output dbiterr
);
	
endmodule
