`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:27:42 01/14/2014 
// Design Name: 
// Module Name:    al_cdac 
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
module al_cdac #(
	parameter TMR = 0
)(
    input CLK40,
    input CLK1MHZ,
    input RST,
    input CLR_AL_DONE,
    input CAPTURE,
	 input LOAD_DFLT,
    input [11:0] BPI_AL_REG,
    output SHCK_ENA,
    output SDATA,
    output DAC_ENB,
    output CDAC_DONE
    );
	 
	 
	wire set_done;

generate
if(TMR==1) 
begin : CmpTh_FSM_TMR

	(* syn_preserve = "true" *) reg load_cthresh_1;
	(* syn_preserve = "true" *) reg load_cthresh_2;
	(* syn_preserve = "true" *) reg load_cthresh_3;
	(* syn_preserve = "true" *) reg load_cthresh_r1_1;
	(* syn_preserve = "true" *) reg load_cthresh_r1_2;
	(* syn_preserve = "true" *) reg load_cthresh_r1_3;
	(* syn_preserve = "true" *) reg done_1;
	(* syn_preserve = "true" *) reg done_2;
	(* syn_preserve = "true" *) reg done_3;
	(* syn_preserve = "true" *) reg [15:0] cth_shft_1;
	(* syn_preserve = "true" *) reg [15:0] cth_shft_2;
	(* syn_preserve = "true" *) reg [15:0] cth_shft_3;
	(* syn_preserve = "true" *) reg [11:0] cthresh_hold_1;
	(* syn_preserve = "true" *) reg [11:0] cthresh_hold_2;
	(* syn_preserve = "true" *) reg [11:0] cthresh_hold_3;
	
	(* syn_keep = "true" *) wire vt_load_cthresh_1;
	(* syn_keep = "true" *) wire vt_load_cthresh_2;
	(* syn_keep = "true" *) wire vt_load_cthresh_3;
	(* syn_keep = "true" *) wire vt_load_cthresh_r1_1;
	(* syn_keep = "true" *) wire vt_load_cthresh_r1_2;
	(* syn_keep = "true" *) wire vt_load_cthresh_r1_3;
	(* syn_keep = "true" *) wire vt_done_1;
	(* syn_keep = "true" *) wire vt_done_2;
	(* syn_keep = "true" *) wire vt_done_3;
	(* syn_keep = "true" *) wire [11:0] vt_cthresh_hold_1;
	(* syn_keep = "true" *) wire [11:0] vt_cthresh_hold_2;
	(* syn_keep = "true" *) wire [11:0] vt_cthresh_hold_3;

	(* syn_keep = "true" *) wire le_load_cthresh_1;
	(* syn_keep = "true" *) wire le_load_cthresh_2;
	(* syn_keep = "true" *) wire le_load_cthresh_3;
	(* syn_keep = "true" *) wire sdata_1;
	(* syn_keep = "true" *) wire sdata_2;
	(* syn_keep = "true" *) wire sdata_3;
  
	assign vt_load_cthresh_1    = (load_cthresh_1    & load_cthresh_2   ) | (load_cthresh_2    & load_cthresh_3   ) | (load_cthresh_1    & load_cthresh_3   ); // Majority logic
	assign vt_load_cthresh_2    = (load_cthresh_1    & load_cthresh_2   ) | (load_cthresh_2    & load_cthresh_3   ) | (load_cthresh_1    & load_cthresh_3   ); // Majority logic
	assign vt_load_cthresh_3    = (load_cthresh_1    & load_cthresh_2   ) | (load_cthresh_2    & load_cthresh_3   ) | (load_cthresh_1    & load_cthresh_3   ); // Majority logic
	assign vt_load_cthresh_r1_1 = (load_cthresh_r1_1 & load_cthresh_r1_2) | (load_cthresh_r1_2 & load_cthresh_r1_3) | (load_cthresh_r1_1 & load_cthresh_r1_3); // Majority logic
	assign vt_load_cthresh_r1_2 = (load_cthresh_r1_1 & load_cthresh_r1_2) | (load_cthresh_r1_2 & load_cthresh_r1_3) | (load_cthresh_r1_1 & load_cthresh_r1_3); // Majority logic
	assign vt_load_cthresh_r1_3 = (load_cthresh_r1_1 & load_cthresh_r1_2) | (load_cthresh_r1_2 & load_cthresh_r1_3) | (load_cthresh_r1_1 & load_cthresh_r1_3); // Majority logic
	assign vt_done_1            = (done_1            & done_2           ) | (done_2            & done_3           ) | (done_1            & done_3           ); // Majority logic
	assign vt_done_2            = (done_1            & done_2           ) | (done_2            & done_3           ) | (done_1            & done_3           ); // Majority logic
	assign vt_done_3            = (done_1            & done_2           ) | (done_2            & done_3           ) | (done_1            & done_3           ); // Majority logic
	assign vt_cthresh_hold_1    = (cthresh_hold_1    & cthresh_hold_2   ) | (cthresh_hold_2    & cthresh_hold_3   ) | (cthresh_hold_1    & cthresh_hold_3   ); // Majority logic
	assign vt_cthresh_hold_2    = (cthresh_hold_1    & cthresh_hold_2   ) | (cthresh_hold_2    & cthresh_hold_3   ) | (cthresh_hold_1    & cthresh_hold_3   ); // Majority logic
	assign vt_cthresh_hold_3    = (cthresh_hold_1    & cthresh_hold_2   ) | (cthresh_hold_2    & cthresh_hold_3   ) | (cthresh_hold_1    & cthresh_hold_3   ); // Majority logic

	always @(negedge CLK1MHZ) begin
		load_cthresh_r1_1 <= vt_load_cthresh_1;
		load_cthresh_r1_2 <= vt_load_cthresh_2;
		load_cthresh_r1_3 <= vt_load_cthresh_3;
	end
	always @(negedge CLK1MHZ or posedge RST) begin
		if(RST) begin
			cth_shft_1 <= 16'h0000;
			cth_shft_2 <= 16'h0000;
			cth_shft_3 <= 16'h0000;
		end
		else begin
			cth_shft_1 <= le_load_cthresh_1 ? {3'b0,vt_cthresh_hold_1,1'b0} : (SHCK_ENA ? {cth_shft_1[14:0],1'b0} : cth_shft_1);
			cth_shft_2 <= le_load_cthresh_2 ? {3'b0,vt_cthresh_hold_2,1'b0} : (SHCK_ENA ? {cth_shft_2[14:0],1'b0} : cth_shft_2);
			cth_shft_3 <= le_load_cthresh_3 ? {3'b0,vt_cthresh_hold_3,1'b0} : (SHCK_ENA ? {cth_shft_3[14:0],1'b0} : cth_shft_3);
		end
	end

	always @(posedge CLK40 or posedge RST) begin
		if(RST) begin
			load_cthresh_1 <= 1'b0;
			load_cthresh_2 <= 1'b0;
			load_cthresh_3 <= 1'b0;
			cthresh_hold_1 <= 12'hFDD;  // 30 mV threshold default; VREF is 3.59V
			cthresh_hold_2 <= 12'hFDD;  // 30 mV threshold default; VREF is 3.59V
			cthresh_hold_3 <= 12'hFDD;  // 30 mV threshold default; VREF is 3.59V
			done_1 <= 1'b0;
			done_2 <= 1'b0;
			done_3 <= 1'b0;
		end
		else begin
			load_cthresh_1 <= vt_done_1 ? 1'b0 : ((CAPTURE || LOAD_DFLT) ? 1'b1 : vt_load_cthresh_1);
			load_cthresh_2 <= vt_done_2 ? 1'b0 : ((CAPTURE || LOAD_DFLT) ? 1'b1 : vt_load_cthresh_2);
			load_cthresh_3 <= vt_done_3 ? 1'b0 : ((CAPTURE || LOAD_DFLT) ? 1'b1 : vt_load_cthresh_3);
			cthresh_hold_1 <= CAPTURE ? BPI_AL_REG[11:0] : vt_cthresh_hold_1;
			cthresh_hold_2 <= CAPTURE ? BPI_AL_REG[11:0] : vt_cthresh_hold_2;
			cthresh_hold_3 <= CAPTURE ? BPI_AL_REG[11:0] : vt_cthresh_hold_3;
//			cthresh_hold_1 <= CAPTURE ? 12'hFDD : vt_cthresh_hold_1; // temporary 30 mV threshold until autoload mnodule is written VREF is 3.59V
//			cthresh_hold_2 <= CAPTURE ? 12'hFDD : vt_cthresh_hold_2; // temporary 30 mV threshold until autoload mnodule is written VREF is 3.59V
//			cthresh_hold_3 <= CAPTURE ? 12'hFDD : vt_cthresh_hold_3; // temporary 30 mV threshold until autoload mnodule is written VREF is 3.59V
			done_1 <= CLR_AL_DONE ? 1'b0 : (set_done ? 1'b1 : vt_done_1);
			done_2 <= CLR_AL_DONE ? 1'b0 : (set_done ? 1'b1 : vt_done_2);
			done_3 <= CLR_AL_DONE ? 1'b0 : (set_done ? 1'b1 : vt_done_3);
		end
	end

	comp_thresh_load_FSM_TMR         //States change on negative edge of clock
	comp_thresh_load_FSM_i(
	  .SET_DONE(set_done),
	  .SHFT_ENA(SHCK_ENA),
	  .CLK(CLK1MHZ),
	  .RST(RST),
	  .START(vt_load_cthresh_1) 
	);

	assign le_load_cthresh_1   = vt_load_cthresh_1 & ~vt_load_cthresh_r1_1;
	assign le_load_cthresh_2   = vt_load_cthresh_2 & ~vt_load_cthresh_r1_2;
	assign le_load_cthresh_3   = vt_load_cthresh_3 & ~vt_load_cthresh_r1_3;
	assign sdata_1 = cth_shft_1[15];
	assign sdata_2 = cth_shft_2[15];
	assign sdata_3 = cth_shft_3[15];
	
	assign CDAC_DONE       = vt_done_1;
	assign DAC_ENB         = vt_load_cthresh_1;
	assign SDATA           = (sdata_1 & sdata_2) | (sdata_2 & sdata_3) | (sdata_1 & sdata_3); // Majority logic

end
else 
begin : CmpTh_FSM
	
	reg load_cthresh;
	reg load_cthresh_r1;
	reg done;
	reg [15:0] cth_shft;
	reg [11:0] cthresh_hold;
	
	wire le_load_cthresh;
  

	always @(negedge CLK1MHZ) begin
		load_cthresh_r1 <= load_cthresh;
	end
	always @(negedge CLK1MHZ or posedge RST) begin
		if(RST) begin
			cth_shft <= 16'h0000;
		end
		else begin
			cth_shft <= le_load_cthresh ? {3'b0,cthresh_hold,1'b0} : (SHCK_ENA ? {cth_shft[14:0],1'b0} : cth_shft);
		end
	end

	always @(posedge CLK40 or posedge RST) begin
		if(RST) begin
			load_cthresh <= 1'b0;
			cthresh_hold <= 12'hFDD;  // 30 mV threshold default; VREF is 3.59V
			done <= 1'b0;
		end
		else begin
			load_cthresh <= done ? 1'b0 : ((CAPTURE || LOAD_DFLT) ? 1'b1 : load_cthresh);
			cthresh_hold <= CAPTURE ? BPI_AL_REG[11:0] : cthresh_hold;
//			cthresh_hold <= CAPTURE ? 12'hFDD : cthresh_hold; // temporary 30 mV threshold until autoload mnodule is written VREF is 3.59V
			done <= CLR_AL_DONE ? 1'b0 : (set_done ? 1'b1 : done);
		end
	end

	comp_thresh_load_FSM         //States change on negative edge of clock
	comp_thresh_load_FSM_i(
	  .SET_DONE(set_done),
	  .SHFT_ENA(SHCK_ENA),
	  .CLK(CLK1MHZ),
	  .RST(RST),
	  .START(load_cthresh) 
	);
	
	assign CDAC_DONE = done;
	assign DAC_ENB = load_cthresh;
	assign SDATA = cth_shft[15];
	assign le_load_cthresh   = load_cthresh & ~load_cthresh_r1;

end
endgenerate

endmodule
