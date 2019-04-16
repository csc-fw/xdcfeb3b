`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:33:56 04/16/2019
// Design Name:   I2C_interfaces
// Module Name:   F:/DCFEB/firmware/ISE_14.7/xdcfeb3b/I2C_interfaces_al_sim_top_tf.v
// Project Name:  xdcfeb3b
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: I2C_interfaces
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module I2C_interfaces_al_sim_top_tf;

	// Inputs
	reg CLK40;
	reg CLK1MHZ;
	reg RST;
	wire DAQ_LDSDA_RTN;
	wire TRG_LDSDA_RTN;
	reg [7:0] AL_DATA;
	reg AL_VTTX_REGS;
	reg [7:0] I2C_WRT_FIFO_DATA;
	reg I2C_WE;
	reg I2C_RDENA;
	reg I2C_RESET;
	reg I2C_START;

	// Outputs
	wire DAQ_LDSCL;
	wire TRG_LDSCL;
	wire NVIO_I2C_EN;
	wire NVIO_SCL_25;
	wire [7:0] I2C_RBK_FIFO_DATA;
	wire I2C_CLR_START;
	wire I2C_SCOPE_SYNC;
	wire [7:0] I2C_STATUS;

	// Bidirs
	wire DAQ_LDSDA;
	wire TRG_LDSDA;
	wire NVIO_SDA_25;

	
pullup daq_pu (DAQ_LDSDA);
pullup trg_pu (TRG_LDSDA);
pullup nvio_pu (NVIO_SDA_25);
pullup daq_cl_pu (DAQ_LDSCL);
pullup trg_cl_pu (TRG_LDSCL);
pullup nvio_cl_pu (NVIO_SCL_25);

	// Instantiate the Unit Under Test (UUT)
	I2C_interfaces #(
		.Simulation(1),
		.USE_CHIPSCOPE(0),
		.Hard_Code_Defaults(1)
	) 
	uut (
		.CLK40(CLK40), 
		.CLK1MHZ(CLK1MHZ), 
		.RST(RST), 
		
		.DAQ_LDSDA(DAQ_LDSDA), 
		.DAQ_LDSDA_RTN(DAQ_LDSDA_RTN), 
		.DAQ_LDSCL(DAQ_LDSCL), 
		
		.TRG_LDSDA(TRG_LDSDA), 
		.TRG_LDSDA_RTN(TRG_LDSDA_RTN), 
		.TRG_LDSCL(TRG_LDSCL), 
		
		.NVIO_I2C_EN(NVIO_I2C_EN), 
		.NVIO_SDA_25(NVIO_SDA_25), 
		.NVIO_SCL_25(NVIO_SCL_25), 
		
		.AL_DATA(AL_DATA), 
		.AL_VTTX_REGS(AL_VTTX_REGS), 
		
	// JTAG signals
		.I2C_WRT_FIFO_DATA(I2C_WRT_FIFO_DATA), 
		.I2C_WE(I2C_WE), 
		.I2C_RDENA(I2C_RDENA), 
		.I2C_RESET(I2C_RESET), 
		.I2C_START(I2C_START), 
		//outputs
		.I2C_RBK_FIFO_DATA(I2C_RBK_FIFO_DATA), 
		.I2C_CLR_START(I2C_CLR_START), 
		.I2C_SCOPE_SYNC(I2C_SCOPE_SYNC), 
		.I2C_STATUS(I2C_STATUS)
	);
	
   parameter PERIOD = 24;  // CMS clock period (40MHz)

	initial begin  // CMS clock from QPLL 40 MHz
		CLK40 = 1;  // start high
      forever begin
         #(PERIOD/2) begin
				CLK40 = ~CLK40;  //Toggle
			end
		end
	end
	initial begin  // CMS clock from QPLL 40 MHz
		CLK1MHZ = 1;  // start high
      forever begin
         #(20* PERIOD) begin
				CLK1MHZ = ~CLK1MHZ;  //Toggle
			end
		end
	end
	
assign DAQ_LDSDA_RTN = DAQ_LDSDA;
assign TRG_LDSDA_RTN = TRG_LDSDA;

always @* begin
	if(I2C_CLR_START) I2C_START = 1'b0;
end

I2C_slave_sim  #(
	.Dev_Addr(8'hFC)
) 
TRG_slave_i(
	.CLK40(CLK40),
	.CLK1MHZ(CLK1MHZ),
	.RST(RST),
	.SCL(TRG_LDSCL),
	.SDA(TRG_LDSDA)
);

I2C_slave_sim  #(
	.Dev_Addr(8'hFC)
) 
DAQ_slave_i(
	.CLK40(CLK40),
	.CLK1MHZ(CLK1MHZ),
	.RST(RST),
	.SCL(DAQ_LDSCL),
	.SDA(DAQ_LDSDA)
);

I2C_slave_sim  #(
	.Dev_Addr(8'hA2)
) 
NVIO_slave_i(
	.CLK40(CLK40),
	.CLK1MHZ(CLK1MHZ),
	.RST(RST),
	.SCL(NVIO_SCL_25),
	.SDA(NVIO_SDA_25)
);


	initial begin
		// Initialize Inputs
		RST = 0;
		AL_DATA = 0;
		AL_VTTX_REGS = 0;
		I2C_WRT_FIFO_DATA = 0;
		I2C_WE = 0;
		I2C_RDENA = 0;
		I2C_RESET = 0;
		I2C_START = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		#(5*PERIOD);
		RST = 0;
		#(25*PERIOD);
		I2C_RESET = 1;
		#(11*PERIOD);
		I2C_RESET = 0;
		#(25*PERIOD);
		#(25*PERIOD);
		#(25*PERIOD);
		AL_VTTX_REGS = 1;
		#(7*PERIOD);
		AL_VTTX_REGS = 0;
		#(25*PERIOD);
		#(14168*PERIOD);
	end
      
endmodule

