`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:51:42 10/17/2018
// Design Name:   jtag_access
// Module Name:   F:/DCFEB/firmware/ISE_14.7/xdcfeb3a/source/Sim/jtag_access_sim_tf.v
// Project Name:  xdcfeb3a
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: jtag_access
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module jtag_access_sim_tf;

	// Inputs
	reg CLK1MHZ;
	reg CLK20;
	reg CLK40;
	reg CLK120;
	reg FSTCLK;
	reg RST;
	reg EOS;
	reg [6:1] BKY_RTN;
	reg [15:0] DCFEB_STATUS;
	reg [15:0] STARTUP_STATUS;
	reg [7:0] QPLL_CNT;
	reg [191:0] ADCDATA;
	reg [15:0] AL_DATA;
	reg SLOW_FIFO_RST;
	reg AUTO_LOAD;
	reg AUTO_LOAD_ENA;
	reg [5:0] AL_CNT;
	reg CLR_AL_DONE;
	reg AL_RESTART;
	reg LOAD_DFLT;
	reg [7:0] I2C_RBK_FIFO_DATA;
	reg [7:0] I2C_STATUS;
	reg I2C_CLR_START;
	reg SPI_RTN;
	reg [23:0] SEM_FAR_PA;
	reg [23:0] SEM_FAR_LA;
	reg [15:0] SEM_ERRCNT;
	reg [15:0] SEM_STATUS;
	reg [23:0] L1ACNT;
	reg [11:0] L1AMCNT;
	reg [11:0] INJPLSCNT;
	reg [11:0] EXTPLSCNT;
	reg [11:0] BC0CNT;
	reg [15:0] CMP_PHS_ERRCNT;
	reg [15:0] FIFO_LOAD_ERRCNT;
	reg [15:0] XF2RB_ERRCNT;
	reg [15:0] RGTRNS_ERRCNT;
	reg [15:0] SMPPRC_ERRCNT;
	reg [15:0] FRMPRC_ERRCNT;

	// Outputs
	wire AL_DONE;
	wire AL_ABORT;
	wire QP_RST_B;
	wire JTAG_SYS_RST;
	wire RDFIFO;
	wire JTAG_RD_MODE;
	wire [1:0] COMP_MODE;
	wire [2:0] COMP_TIME;
	wire CDAC_ENB;
	wire CALDAC_ENB;
	wire CALADC_ENB;
	wire SPI_CK;
	wire SPI_DAT;
	wire CAL_MODE;
	wire [6:1] TO_BKY;
	wire [6:1] BKY_CLK;
	wire ADC_WE;
	wire [25:0] ADC_MEM;
	wire [11:0] ADC_MASK;
	wire ADC_INIT;
	wire JC_ADC_CNFG;
	wire RSTRT_PIPE;
	wire [8:0] PDEPTH;
	wire DAQ_OP_RST;
	wire TRG_OP_RST;
	wire [1:0] TTC_SRC;
	wire [6:0] SAMP_MAX;
	wire [4:0] CMP_CLK_PHASE;
	wire [2:0] SAMP_CLK_PHASE;
	wire CMP_PHS_JTAG_RST;
	wire SAMP_CLK_PHS_CHNG;
	wire [2:0] TMB_TX_MODE;
	wire [29:0] LAY1_TO_6_HALF_STRIP;
	wire [5:0] LAYER_MASK;
	wire JDAQ_RATE;
	wire [2:0] JDAQ_PRBS_TST;
	wire JDAQ_INJ_ERR;
	wire USE_ANY_L1A;
	wire L1A_HEAD;
	wire JTAG_TK_CTRL;
	wire JTAG_DED_RST;
	wire JTAG_RST_SEM_CNTRS;
	wire JTAG_SEND_CMD;
	wire [7:0] JTAG_CMD_DATA;
	wire PROM2FF;
	wire ECC;
	wire CRC;
	wire DECODE;
	wire PF_RDENA;
	wire GBT_ENA_TEST;
	wire [7:0] I2C_WRT_FIFO_DATA;
	wire I2C_WE;
	wire I2C_RDENA;
	wire I2C_RESET;
	wire I2C_START;
	wire FUNC75;
	wire JSELECT2;
	wire UPDT2;
	wire BTCK1;
	wire BTMS1;
	wire BTDI1;
	wire BTDI2;

	// Instantiate the Unit Under Test (UUT)
	jtag_access uut (
		.CLK1MHZ(CLK1MHZ), 
		.CLK20(CLK20), 
		.CLK40(CLK40), 
		.CLK120(CLK120), 
		.FSTCLK(FSTCLK), 
		.RST(RST), 
		.EOS(EOS), 
		.BKY_RTN(BKY_RTN), 
		.DCFEB_STATUS(DCFEB_STATUS), 
		.STARTUP_STATUS(STARTUP_STATUS), 
		.QPLL_CNT(QPLL_CNT), 
		.ADCDATA(ADCDATA), 
		.AL_DATA(AL_DATA), 
		.SLOW_FIFO_RST(SLOW_FIFO_RST), 
		.AUTO_LOAD(AUTO_LOAD), 
		.AUTO_LOAD_ENA(AUTO_LOAD_ENA), 
		.AL_CNT(AL_CNT), 
		.CLR_AL_DONE(CLR_AL_DONE), 
		.AL_RESTART(AL_RESTART), 
		.LOAD_DFLT(LOAD_DFLT), 
		.I2C_RBK_FIFO_DATA(I2C_RBK_FIFO_DATA), 
		.I2C_STATUS(I2C_STATUS), 
		.I2C_CLR_START(I2C_CLR_START), 
		.AL_DONE(AL_DONE), 
		.AL_ABORT(AL_ABORT), 
		.QP_RST_B(QP_RST_B), 
		.JTAG_SYS_RST(JTAG_SYS_RST), 
		.RDFIFO(RDFIFO), 
		.JTAG_RD_MODE(JTAG_RD_MODE), 
		.COMP_MODE(COMP_MODE), 
		.COMP_TIME(COMP_TIME), 
		.CDAC_ENB(CDAC_ENB), 
		.CALDAC_ENB(CALDAC_ENB), 
		.CALADC_ENB(CALADC_ENB), 
		.SPI_CK(SPI_CK), 
		.SPI_DAT(SPI_DAT), 
		.SPI_RTN(SPI_RTN), 
		.CAL_MODE(CAL_MODE), 
		.TO_BKY(TO_BKY), 
		.BKY_CLK(BKY_CLK), 
		.ADC_WE(ADC_WE), 
		.ADC_MEM(ADC_MEM), 
		.ADC_MASK(ADC_MASK), 
		.ADC_INIT(ADC_INIT), 
		.JC_ADC_CNFG(JC_ADC_CNFG), 
		.RSTRT_PIPE(RSTRT_PIPE), 
		.PDEPTH(PDEPTH), 
		.DAQ_OP_RST(DAQ_OP_RST), 
		.TRG_OP_RST(TRG_OP_RST), 
		.TTC_SRC(TTC_SRC), 
		.SAMP_MAX(SAMP_MAX), 
		.CMP_CLK_PHASE(CMP_CLK_PHASE), 
		.SAMP_CLK_PHASE(SAMP_CLK_PHASE), 
		.CMP_PHS_JTAG_RST(CMP_PHS_JTAG_RST), 
		.SAMP_CLK_PHS_CHNG(SAMP_CLK_PHS_CHNG), 
		.TMB_TX_MODE(TMB_TX_MODE), 
		.LAY1_TO_6_HALF_STRIP(LAY1_TO_6_HALF_STRIP), 
		.LAYER_MASK(LAYER_MASK), 
		.JDAQ_RATE(JDAQ_RATE), 
		.JDAQ_PRBS_TST(JDAQ_PRBS_TST), 
		.JDAQ_INJ_ERR(JDAQ_INJ_ERR), 
		.USE_ANY_L1A(USE_ANY_L1A), 
		.L1A_HEAD(L1A_HEAD), 
		.JTAG_TK_CTRL(JTAG_TK_CTRL), 
		.JTAG_DED_RST(JTAG_DED_RST), 
		.JTAG_RST_SEM_CNTRS(JTAG_RST_SEM_CNTRS), 
		.JTAG_SEND_CMD(JTAG_SEND_CMD), 
		.JTAG_CMD_DATA(JTAG_CMD_DATA), 
		.PROM2FF(PROM2FF), 
		.ECC(ECC), 
		.CRC(CRC), 
		.DECODE(DECODE), 
		.PF_RDENA(PF_RDENA), 
		.GBT_ENA_TEST(GBT_ENA_TEST), 
		.I2C_WRT_FIFO_DATA(I2C_WRT_FIFO_DATA), 
		.I2C_WE(I2C_WE), 
		.I2C_RDENA(I2C_RDENA), 
		.I2C_RESET(I2C_RESET), 
		.I2C_START(I2C_START), 
		.FUNC75(FUNC75), 
		.JSELECT2(JSELECT2), 
		.UPDT2(UPDT2), 
		.BTCK1(BTCK1), 
		.BTMS1(BTMS1), 
		.BTDI1(BTDI1), 
		.BTDI2(BTDI2), 
		.SEM_FAR_PA(SEM_FAR_PA), 
		.SEM_FAR_LA(SEM_FAR_LA), 
		.SEM_ERRCNT(SEM_ERRCNT), 
		.SEM_STATUS(SEM_STATUS), 
		.L1ACNT(L1ACNT), 
		.L1AMCNT(L1AMCNT), 
		.INJPLSCNT(INJPLSCNT), 
		.EXTPLSCNT(EXTPLSCNT), 
		.BC0CNT(BC0CNT), 
		.CMP_PHS_ERRCNT(CMP_PHS_ERRCNT), 
		.FIFO_LOAD_ERRCNT(FIFO_LOAD_ERRCNT), 
		.XF2RB_ERRCNT(XF2RB_ERRCNT), 
		.RGTRNS_ERRCNT(RGTRNS_ERRCNT), 
		.SMPPRC_ERRCNT(SMPPRC_ERRCNT), 
		.FRMPRC_ERRCNT(FRMPRC_ERRCNT)
	);

   parameter PERIOD = 24;  // CMS clock period (40MHz)
	parameter JPERIOD = 100;
	parameter ir_width = 10;
	parameter max_width = 300;
	integer i;
	
//JTAG
	reg TMS,TDI,TCK;
	reg [7:0] jrst;
	reg [3:0] sir_hdr;
	reg [3:0] sdr_hdr;
	reg [2:0] trl;
	reg [ir_width-1:0] usr1;
	reg [ir_width-1:0] usr2;
	reg [ir_width-1:0] usr3;
	reg [ir_width-1:0] usr4;

	initial begin  // CMS clock from QPLL 40 MHz
		CLK1MHZ = 1;  // start high
      forever begin
         #(20* PERIOD) begin
				CLK1MHZ = ~CLK1MHZ;  //Toggle
			end
		end
	end

	initial begin  // CMS clock from QPLL 40 MHz
		CLK120 = 1;  // start high
      forever begin
         #(PERIOD/6) begin
				CLK120 = ~CLK120;  //Toggle
			end
		end
	end

	initial begin  // CMS clock from QPLL 40 MHz
		CLK40 = 1;  // start high
      forever begin
         #(PERIOD/2) begin
				CLK40 = ~CLK40;  //Toggle
			end
		end
	end

	initial begin  // CMS clock from QPLL 40 MHz
		CLK20 = 1;  // start high
      forever begin
         #(PERIOD) begin
				CLK20 = ~CLK20;  //Toggle
			end
		end
	end
	
	initial begin  // CMS clock from QPLL 40 MHz
		FSTCLK = 1;  // start high
      forever begin
         #(PERIOD/8) begin
				FSTCLK = ~FSTCLK;  //Toggle
			end
		end
	end
	
	initial begin
		// Initialize Inputs
		RST = 1;
		EOS = 0;
		BKY_RTN = 0;
		DCFEB_STATUS = 0;
		STARTUP_STATUS = 0;
		QPLL_CNT = 0;
		ADCDATA = 0;
		AL_DATA = 0;
		SLOW_FIFO_RST = 0;
		AUTO_LOAD = 0;
		AUTO_LOAD_ENA = 0;
		AL_CNT = 0;
		CLR_AL_DONE = 0;
		AL_RESTART = 0;
		LOAD_DFLT = 0;
		I2C_RBK_FIFO_DATA = 0;
		I2C_STATUS = 0;
		I2C_CLR_START = 0;
		SPI_RTN = 0;
		SEM_FAR_PA = 0;
		SEM_FAR_LA = 0;
		SEM_ERRCNT = 0;
		SEM_STATUS = 0;
		L1ACNT = 0;
		L1AMCNT = 0;
		INJPLSCNT = 0;
		EXTPLSCNT = 0;
		BC0CNT = 0;
		CMP_PHS_ERRCNT = 0;
		FIFO_LOAD_ERRCNT = 0;
		XF2RB_ERRCNT = 0;
		RGTRNS_ERRCNT = 0;
		SMPPRC_ERRCNT = 0;
		FRMPRC_ERRCNT = 0;
		
		TMS = 1'b1;
		TDI = 1'b0;
		TCK = 1'b0;
      jrst = 8'b00111111;
      sir_hdr = 4'b0011;
      sdr_hdr = 4'b0010;
		trl = 3'b001;
		usr1 = 10'h3c2; // usr1 instruction
		usr2 = 10'h3c3; // usr2 instruction
		usr3 = 10'h3e2; // usr3 instruction
		usr4 = 10'h3e3; // usr4 instruction


		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#500
		EOS = 1;
		#(50*PERIOD);
		RST = 0;

		#1;
		#(5*PERIOD);
		JTAG_reset;
		#(50*PERIOD);
		Set_Func(8'd78);           // I2C_reset
		#(5*PERIOD);
		Set_Func(8'd75);           // Write I2C_FIFO.
		Set_User(usr2);            // User 2 for User Reg access
		Shift_Data(8,8'h16);       // shift command
		#(5*PERIOD);
		Set_Func(8'd75);           // Write I2C_FIFO.
		Set_User(usr2);            // User 2 for User Reg access
		Shift_Data(8,8'h00);       // shift command
		#(5*PERIOD);
		Set_Func(8'd75);           // Write I2C_FIFO.
		Set_User(usr2);            // User 2 for User Reg access
		Shift_Data(8,8'h84);       // shift command
		#(5*PERIOD);
		Set_Func(8'd79);           // Disable L1A headers.
		#(5*PERIOD);

	end
      

   // JTAG_SIM_VIRTEX6: JTAG Interface Simulation Model
   //                   Virtex-6
   // Xilinx HDL Language Template, version 12.4
   
   JTAG_SIM_VIRTEX6 #(
      .PART_NAME("LX130T") // Specify target V6 device.  Possible values are:
                          // "CX130T","CX195T","CX240T","CX75T","HX250T","HX255T","HX380T","HX45T","HX565T",
                          // "LX115T","LX130T","LX130TL","LX195T","LX195TL","LX240T","LX240TL","LX365T","LX365TL",
                          // "LX40T","LX550T","LX550TL","LX75T","LX760","SX315T","SX475T" 
   ) JTAG_SIM_VIRTEX6_inst (
      .TDO(TDO), // 1-bit JTAG data output
      .TCK(TCK), // 1-bit Clock input
      .TDI(TDI), // 1-bit JTAG data input
      .TMS(TMS)  // 1-bit JTAG command input
   );
	
task JTAG_reset;
begin
	// JTAG reset
	TMS = 1'b1;
	TDI = 1'b0;
	for(i=0;i<8;i=i+1) begin
		TMS = jrst[i];
		TCK = 1'b0;
		#(JPERIOD/2) TCK = 1'b1;
		#(JPERIOD/2);
	end
end
endtask

task Set_Func;
input [7:0] func;
begin
	Set_User(usr1);       // User 1 for instruction decode
	Shift_Data(8,func);   // Shift function code
end
endtask


task Set_User;
input [ir_width-1:0] usr;
begin
	// go to sir
	TDI = 1'b0;
	for(i=0;i<4;i=i+1) begin
		TMS = sir_hdr[i];
		TCK = 1'b0;
		#(JPERIOD/2) TCK = 1'b1;
		#(JPERIOD/2);
	end
	// shift instruction
	TMS = 1'b0;
	for(i=0;i<ir_width;i=i+1) begin
		if(i==ir_width-1)TMS = 1'b1;
		TDI = usr[i];       // User 1, 2, 3, or 4 instruction
		TCK = 1'b0;
		#(JPERIOD/2) TCK = 1'b1;
		#(JPERIOD/2);
	end
	// go to rti
	TDI = 1'b0;
	for(i=0;i<3;i=i+1) begin
		TMS = trl[i];
		TCK = 1'b0;
		#(JPERIOD/2) TCK = 1'b1;
		#(JPERIOD/2);
	end
end
endtask


task Shift_Data;
input integer width;
input [max_width-1:0] d;
begin
		// go to sdr
		TDI = 1'b0;
		for(i=0;i<4;i=i+1) begin
		   TMS = sdr_hdr[i];
			TCK = 1'b0;
			#(JPERIOD/2) TCK = 1'b1;
			#(JPERIOD/2);
		end
		// shift function data 
		TMS = 1'b0;
		for(i=0;i<width;i=i+1) begin
		   if(i==(width-1))TMS = 1'b1;
			TDI = d[i];
			TCK = 1'b0;
			#(JPERIOD/2) TCK = 1'b1;
			#(JPERIOD/2);
		end
		// go to rti
		TDI = 1'b0;
		for(i=0;i<3;i=i+1) begin
		   TMS = trl[i];
			TCK = 1'b0;
			#(JPERIOD/2) TCK = 1'b1;
			#(JPERIOD/2);
		end
end
endtask

endmodule

