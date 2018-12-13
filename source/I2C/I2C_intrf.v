`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:07:52 09/11/2018 
// Design Name: 
// Module Name:    I2C_intrf 
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
module I2C_intrf #(
	parameter USE_CHIPSCOPE = 0,
	parameter Dev_Addr = 8'hA2
)(
	//Inputs
	input CLK40,
	input CLK1MHZ,
	input RST,
	input RTN_DATA,
	input DEV_SEL,
	input LOAD_N_BYTE,
	input LOAD_ADDR,
	input [3:0] WRT_ADDR,
	input [7:0] WRT_DATA,
	input WRT_ENA,
	input EXECUTE,
	//Outputs
	output READY,
	output RBK_WE,
	output reg S_NACK,
//	output reg TRISTATE_SDA,
	output reg [7:0] RBK_DATA,
	output reg SCL,
	output reg SDA
);


// I2C_intrf_FMS State machine outputs
wire incr_byte_adr;
wire load_adr;
wire load_byte;
wire mstr_ack;
wire mstr_nack;
wire restart;
wire shift_addr;
wire shift_data;
wire shift_dev_rd;
wire shift_dev_wrt;
wire start;
wire stop;
wire slave_ack;
wire [4:0] I2C_state;

wire last_byte;
wire my_execute;

wire ena_step3;
wire ena_step4;
wire ena_data_clk;

reg [2:0] step3;
reg [2:0] data_clk;
reg [2:0] tristate;
reg [2:0] drv_low;
reg [2:0] start_data;
reg [2:0] start_clk;
reg [2:0] stop_data;
reg [2:0] stop_clk;
//reg [3:0] stop_data; //use for simulation kludge
//reg [3:0] stop_clk; //use for simulation kludge
reg [3:0] step4;
reg [3:0] rpt_start_data;
reg [3:0] rpt_start_clk;
reg [7:0] dev_w;
reg [7:0] dev_r;
reg [7:0] adr_reg_srl;
reg [7:0] data_srl;
reg [3:0] byte_adr;

reg [7:0] data_mem [0:15];
wire [7:0] snd_data;
reg [3:0] n_bytes;
reg [7:0] addr_reg;
reg I2C_read;
reg I2C_write;
wire push_rbk;
reg push_rbk_d1;

assign ena_step3 = slave_ack || mstr_ack || mstr_nack || shift_addr || shift_data || shift_dev_rd || shift_dev_wrt || start || stop;
//assign ena_step3 = slave_ack || mstr_ack || mstr_nack || shift_addr || shift_data || shift_dev_rd || shift_dev_wrt || start; //use for simulation kludge
assign ena_step4 = restart;
//assign ena_step4 = restart || stop; //use for simulation kludge

assign ena_data_clk = slave_ack || mstr_nack || mstr_ack || shift_data || shift_addr || shift_dev_rd || shift_dev_wrt;
assign last_byte = (byte_adr == n_bytes-1);
assign my_execute = DEV_SEL && EXECUTE;
assign snd_data = data_mem[byte_adr];
assign RBK_WE = push_rbk && !push_rbk_d1;  //leading edge, 25ns write enable for RBK_FIFO


always @(posedge CLK40) begin
	push_rbk_d1 <= push_rbk;
end

always @(posedge CLK40) begin
	if(DEV_SEL && WRT_ENA) begin
		data_mem[WRT_ADDR] <= WRT_DATA;
	end
end


always @(posedge CLK40 or posedge RST) begin
	if(RST) begin
		n_bytes <= 4'h0;
		I2C_read <= 1'b0;
		I2C_write <= 1'b0;
		addr_reg <= 8'h00;
	end
	else begin
		if(DEV_SEL && LOAD_N_BYTE) begin
			n_bytes <= WRT_DATA[7:4];
			I2C_read <= WRT_DATA[3];
			I2C_write <= ~WRT_DATA[3];
		end
		if(DEV_SEL && LOAD_ADDR) begin
			addr_reg <= WRT_DATA;
		end
	end
end

//always @(posedge CLK1MHZ) begin
//   TRISTATE_SDA <= slave_ack || (shift_data && I2C_read);
//end

// shift registers for clock and data patterns
(* syn_srlstyle = "select_srl" *)
always @(posedge CLK1MHZ or posedge RST) begin
	if(RST) begin
		step3          <= 3'b001;
		data_clk       <= 3'b010;
		tristate       <= 3'b111;
		drv_low        <= 3'b000;
		start_data     <= 3'b100;
		start_clk      <= 3'b110;
		stop_data      <= 3'b001;
		stop_clk       <= 3'b011;
//		stop_data      <= 4'b1001; //use for simulation kludge
//		stop_clk       <= 4'b0011; //use for simulation kludge
		step4          <= 4'b0001;
		rpt_start_data <= 4'b1100;
		rpt_start_clk  <= 4'b0110;
	end
	else begin
		if(ena_step3) begin
			step3          <= {step3[1:0],step3[2]};
		end 
		if(ena_data_clk) begin
			data_clk       <= {data_clk[1:0],data_clk[2]};
		end 
		if(slave_ack || mstr_nack) begin
			tristate       <= {tristate[1:0],tristate[2]};
		end 
		if(mstr_ack) begin
			drv_low        <= {drv_low[1:0],drv_low[2]};
		end 
		if(start) begin
			start_data     <= {start_data[1:0],start_data[2]};
			start_clk      <= {start_clk[1:0],start_clk[2]};
		end 
		if(stop) begin
			stop_data      <= {stop_data[1:0],stop_data[2]};
			stop_clk       <= {stop_clk[1:0],stop_clk[2]};
//			stop_data      <= {stop_data[2:0],stop_data[3]}; //use for simulation kludge
//			stop_clk       <= {stop_clk[2:0],stop_clk[3]}; //use for simulation kludge
		end 
		if(ena_step4) begin
			step4          <= {step4[2:0],step4[3]};
		end
		if(restart) begin
			rpt_start_data <= {rpt_start_data[2:0],rpt_start_data[3]};
			rpt_start_clk  <= {rpt_start_clk[2:0],rpt_start_clk[3]};
		end
	end
end
(* syn_srlstyle = "select_srl" *)
always @(posedge CLK1MHZ or posedge RST) begin
	if(RST) begin
		dev_w    <= {Dev_Addr[7:1],1'b0};
		dev_r    <= {Dev_Addr[7:1],1'b1};
	end
	else begin
		if(shift_dev_wrt && step3[2]) begin
			dev_w <= {dev_w[6:0],dev_w[7]};
		end
		if(shift_dev_rd && step3[2]) begin
			dev_r <= {dev_r[6:0],dev_r[7]};
		end
	end
end
(* syn_srlstyle = "select_srl" *)
always @(posedge CLK1MHZ or posedge RST) begin
	if(RST) begin
		adr_reg_srl    <= 8'h00;
	end
	else begin
		if(load_adr) begin
			adr_reg_srl <= addr_reg;
		end
		else if(shift_addr && step3[2]) begin
			adr_reg_srl <= {adr_reg_srl[6:0],adr_reg_srl[7]};
		end
	end
end

(* syn_srlstyle = "select_srl" *)
always @(posedge CLK1MHZ or posedge RST) begin
	if(RST) begin
		data_srl    <= 8'h00;
	end
	else begin
		if(load_byte) begin
			data_srl <= snd_data;
		end
		else if(shift_data && I2C_write && step3[2]) begin
			data_srl <= {data_srl[6:0],data_srl[7]};
		end
	end
end
always @(posedge CLK1MHZ or posedge RST) begin
	if(RST) begin
		byte_adr    <= 4'h0;
	end
	else begin
		if(READY) begin
			byte_adr <= 4'h0;
		end
		else if(incr_byte_adr) begin
			byte_adr <= byte_adr + 1;
		end
	end
end

(* syn_srlstyle = "select_srl" *)
always @(posedge CLK1MHZ or posedge RST) begin
	if(RST) begin
		RBK_DATA    <= 8'h00;
	end
	else begin
		if(shift_data && I2C_read && step3[2]) begin
			RBK_DATA <= {RBK_DATA[6:0],RTN_DATA};
		end
	end
end
always @(posedge CLK1MHZ or posedge RST) begin
	if(RST) begin
		S_NACK <= 1'b0;
	end
	else begin
		if(start) begin
			S_NACK <= 1'b0;
		end
		if(slave_ack && step3[0]) begin
			S_NACK <= RTN_DATA;
		end
	end
end

always @(posedge CLK1MHZ) begin
	if(shift_dev_wrt) begin
		SDA <= dev_w[7];
	end
	else if(shift_dev_rd) begin
		SDA <= dev_r[7];
	end
	else if(shift_addr) begin
		SDA <= adr_reg_srl[7];
	end
	else if(shift_data && I2C_write) begin
		SDA <= data_srl[7];
	end
	else if(slave_ack || mstr_nack || (shift_data && I2C_read)) begin
		SDA <= tristate[2];
	end 
	else if(mstr_ack) begin
		SDA <= drv_low[2];
	end 
	else if(start) begin
		SDA <= start_data[2];
	end 
	else if(stop) begin
		SDA <= stop_data[2];
//		SDA <= stop_data[3]; //use for simulation kludge
	end 
	else if(restart) begin
		SDA <= rpt_start_data[3];
	end
	else begin
		SDA <= 1'b1;
	end
end

always @(posedge CLK1MHZ) begin
	if(ena_data_clk) begin
		SCL <= data_clk[2];
	end 
	else if(start) begin
		SCL <= start_clk[2];
	end 
	else if(stop) begin
		SCL <= stop_clk[2];
//		SCL <= stop_clk[3]; //use for simulation kludge
	end 
	else if(restart) begin
		SCL <= rpt_start_clk[3];
	end
	else begin
		SCL <= 1'b1;
	end
end


I2C_intrf_FSM 
I2C_intrf_i(
	//outputs 
	.INCR(incr_byte_adr),
	.LOAD_ADDR(load_adr),
	.LOAD_BYTE(load_byte),
	.M_ACK(mstr_ack),
	.M_NACK(mstr_nack),
	.PUSH(push_rbk),
	.READY(READY),
	.RESTART(restart),
	.SHADR(shift_addr),
	.SHDATA(shift_data),
	.SHDEVRD(shift_dev_rd),
	.SHDEVWRT(shift_dev_wrt),
	.START(start),
	.STOP(stop),
	.S_ACK(slave_ack),
	.I2C_STATE(I2C_state),
	//inputs
	.CLK(CLK1MHZ),
	.EXECUTE(my_execute),
	.LAST_BYTE(last_byte),
	.READ(I2C_read),
	.RST(RST),
	.STEP3(step3[2]),
	.STEP4(step4[3]),
	.WRITE(I2C_write)
);


endmodule
