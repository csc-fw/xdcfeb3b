`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:55 09/21/2018 
// Design Name: 
// Module Name:    I2C_slave_sim 
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
module I2C_slave_sim #(
	parameter Dev_Addr = 8'hA2
)(
	input CLK40,
	input CLK1MHZ,
	input RST,
	input SCL,
	inout SDA
);


wire rise_edge;
wire fall_edge;
reg sda_1;
wire clr_start;
wire clr_stop;
reg step;
wire cap_rw;
reg read;
reg write;
wire shift_adr_reg;
wire shift_dev;
wire shift_data;
wire [3:0] bit_cnt;
wire load_adr;
wire load_rbk_data;
wire store;
wire chk_dev;
wire abort;
wire chk_m_ack;
reg m_ack;
reg m_nack;

wire ack;
wire s_ack;
reg start;
reg stop;

reg [6:0] dev_adr;
reg [7:0] reg_adr_srl;
reg [7:0] reg_adr;
reg [7:0] data;
reg [7:0] dev_mem [0:15];
wire [7:0] dev_mem_out;
reg [7:0] rbk_reg_srl;
reg rbk_data;
wire we;
wire incr_ra;

initial begin
	start = 0;
	stop  = 0;
	dev_mem[10] = 8'hFF;
	dev_mem[11] = 8'hFF;
	dev_mem[12] = 8'hFF;
	dev_mem[13] = 8'hFF;
	dev_mem[14] = 8'hFF;
	dev_mem[15] = 8'hFF;
end

assign s_ack = ack && write;
assign SDA = s_ack ? 1'b0 : ((shift_data && read) ? rbk_data : 1'bz);
assign abort = chk_dev && (dev_adr != Dev_Addr[7:1]);

assign rise_edge = SDA & ~sda_1;
assign fall_edge = ~SDA & sda_1;
assign rst_start = RST || clr_start;
assign rst_stop  = RST || clr_stop;

assign we = SCL && store && write;
assign incr_ra = SCL && store && (read || write);
assign chk_m_ack =  store && read;
assign dev_mem_out = dev_mem[reg_adr];

always @(posedge CLK40) begin
	sda_1 <= SDA;
end

always @(posedge CLK40 or posedge rst_start) begin
	if(rst_start) begin
		start <= 1'b0;
	end
	else begin
		if(SCL && fall_edge) begin
			start <= 1'b1;
		end
	end
end

always @(posedge CLK40 or posedge rst_stop) begin
	if(rst_stop) begin
		stop <= 1'b0;
	end
	else begin
		if(SCL && rise_edge) begin
			stop <= 1'b1;
		end
	end
end

always @(posedge CLK1MHZ) begin
	step <= SCL;
end

always @(posedge CLK1MHZ) begin
   if(SCL && cap_rw) begin
	   read <= SDA;
	   write <= ~SDA;
	end
end


always @(posedge CLK1MHZ or posedge RST) begin
	if(RST) begin
		dev_adr <= 7'h00;
	end
	else begin
		if(SCL && shift_dev) begin
			dev_adr <= {dev_adr[5:0],SDA};
		end
	end
end

always @(posedge CLK1MHZ or posedge RST) begin
	if(RST) begin
		reg_adr_srl <= 8'h00;
	end
	else begin
		if(SCL && shift_adr_reg) begin
			reg_adr_srl <= {reg_adr_srl[6:0],SDA};
		end
	end
end

always @(posedge CLK1MHZ or posedge RST) begin
	if(RST) begin
		reg_adr <= 8'h00;
	end
	else begin
		if(load_adr) begin
			reg_adr <= reg_adr_srl & 8'h7F;
		end
		else if(incr_ra) begin
			reg_adr <= reg_adr + 1;
		end
	end
end

always @(posedge CLK1MHZ or posedge RST) begin
	if(RST) begin
		data <= 8'h00;
	end
	else begin
		if(SCL && shift_data) begin
			data <= {data[6:0],SDA};
		end
	end
end

always @(posedge CLK1MHZ) begin
	if(we) dev_mem[reg_adr] <= data & 8'h7F;
end

always @(posedge CLK1MHZ or posedge RST) begin
	if(RST) begin
		rbk_reg_srl <= 8'h00;
	end
	else begin
		if(load_rbk_data) begin
			rbk_reg_srl <= dev_mem_out;
		end
		else if(SCL && shift_data) begin
			rbk_reg_srl <= {rbk_reg_srl[6:0],rbk_reg_srl[7]};
		end
	end
end

always @(posedge CLK1MHZ) begin
   rbk_data <= rbk_reg_srl[7];
end

always @(posedge CLK1MHZ) begin
   if(SCL && chk_m_ack) begin
	   m_ack <= ~SDA;
	   m_nack <= SDA;
	end
end

I2C_slave_sim_FSM 
I2C_slave_sim_FSM_i (
	.ACK(ack),
	.CAP_RW(cap_rw),
	.CHK_DEV(chk_dev),
	.CLR_START(clr_start),
	.CLR_STOP(clr_stop),
	.LOAD_ADR(load_adr),
	.LOAD_RBK_DATA(load_rbk_data),
	.SHIFT_ADR_REG(shift_adr_reg),
	.SHIFT_DATA(shift_data),
	.SHIFT_DEV(shift_dev),
	.STORE(store),
	.bit_cnt(bit_cnt),
	.ABORT(abort),
	.CLK(CLK1MHZ),
	.M_ACK(m_ack),
	.M_NACK(m_nack),
	.READ(read),
	.RST(RST),
	.START(start),
	.STEP(step),
	.STOP(stop),
	.WRITE(write)
);


endmodule
