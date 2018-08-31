`define HEADER TRUE
//`define PreProduction_Version TRUE
//`define Simulation TRUE
//`define Slave TRUE



/////////////////////////////////////////////////////////
//                                                     //
// Definitions common to all Command Processor modules //
//                                                     //
/////////////////////////////////////////////////////////

// Definitions for Receive Buss Commands RCTRL.
`define  Rx_NoData  3'h0  //No valid data.
`define  Rx_OpCode  3'h1  //Command OpCode
`define  Rx_Data    3'h2  //Valid packet Data
`define  Rx_ErrWrd1 3'h3  //Error word 1 on bus.
`define  Rx_ErrWrd2 3'h4  //Error word 2 on bus.
`define  Rx_MAC     3'h5  //Data is MAC address.
`define  Rx_HDR     3'h6  //Data is Header info.
`define  Rx_EOP     3'h7  //End of Packet command.

// Definitions for transmit data categories
`define  Tx_Not_Valid 2'd0  //No valid data on bus
`define  Tx_Norm_Cat  2'd1  //Normal data on bus
`define  Tx_Prio_Cat  2'd2  //Priority data on bus
`define  Tx_Spont_Cat 2'd3  //Spontaneous data on bus

// Definitions for transmit instructions.
`define  Tx_NoData 3'h0  //No valid data.
`define  Tx_AST    3'h1  //Data is Ack/Status/Type
`define  Tx_MAC    3'h2  //Data is MAC address
`define  Tx_Head   3'h3  //Data is Header info
`define  Tx_NoMAC  3'h4  //No MAC information is available, use default Dest. MAC
`define  Tx_NoHead 3'h5  //No Header information is available, zero fields.
`define  Tx_Data   3'h6  //Valid packet Data.
`define  Tx_Send   3'h7  //No data, send packet command.

// State definitions for Transmit Processor FSM
`define  TxP_Idle     4'h0
`define  TxP_BR       4'h1
`define  TxP_Ini_Stat 4'h2
`define  TxP_MAC      4'h3
`define  TxP_Data     4'h4
`define  TxP_Mid_Stat 4'h5
`define  TxP_Clr_Intr 4'h6
`define  TxP_Inc_Stat 4'h7
`define  TxP_Fin_Stat 4'h8
`define  TxP_Send_Pkt 4'h9
`define  TxP_Flush    4'hA
`define  TxP_Rel_Bus  4'hB
`define  TxP_Done     4'hC





////////////////////////////////////////////////////////////////////////////////////////////////////////
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ //
// ========================== Clock Manager Module ================================================== //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

// DCM control FSM State definitions (Runs on the RAW clock):

`define  RST_DCM 3'd0
`define   W4Lock 3'd1
`define  RST_TMO 3'd2
`define    W4TMO 3'd3
`define  Clk_Rdy 3'd4
`define Inc_Lost 3'd5
`define  W4Retry 3'd6

// DCM Time Out
`define DCM_TMO 6'd40 //40 dv32 clocks or 20.48 uS


////////////////////////////////////////////////////////////////////////////////////////////////////////
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ //
// ========================== Startup/Shutdown Module =============================================== //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

// Power on reset FSM State definitions (Runs on the RAW clock):

`define       W4Clks 3'd0
`define FIFO_Startup 3'd1
`define   Pow_on_Rst 3'd2
`define       W4Uclk 3'd3
//`define   W4Sclk_POR 3'd4
//`define       W4Sclk 3'd5
`define    Run_State 3'd6

// Power on reset timeouts
`define  POR_TMO     4'hC

// Power up configuration sequence FSM state definitions
`define             PUC 4'd0
`define   Get_Dflt_Cnfg 4'd1
`define        Hrdw_Ini 4'd2
`define         HndShk1 4'd3
`define       Rstr_MACs 4'd4
`define         HndShk2 4'd5
`define       Rstr_Cnfg 4'd6
`define         HndShk3 4'd7
`define    PU_Cnfg_Done 4'd8


// State definitions for Ethernet Startup
`define  Wait_for_Fiber 4'h0
`define Start_RIO_RX_TX 4'h1
`define     Wait_Time_1 4'h2
`define         AN_Proc 4'h3
`define        W4OpLink 4'h4
`define         W4PUCVR 4'h5
`define        Start_TX 4'h6
`define        Load_Dly 4'h7
`define        Rndm_Dly 4'h8
`define   Snd_Start_Pkt 4'h9
`define         Running 4'ha

// Wait time after Sync and Command Processor holdoff
`define Sync_Wait_Time 5'h1A
`ifdef Simulation
   `define    OpLink_Holdoff 16'h0000 //0nS holdoff for simulations 
   `define    Start_up_Delay 4'h0 //0nS delay for simulations 
`else
//   `define    OpLink_Holdoff 16'h3B9A //0.25 sec wait for link to be established (16.384uS clk)
//   `define    OpLink_Holdoff 16'h5372 //0.35 sec wait for link to be established (16.384uS clk)
   `define    OpLink_Holdoff 16'h17D7 //0.1 sec wait for link to be established (16.384uS clk)
   `define    Start_up_Delay 4'hC //High order bits of the startup countdown timer (16.384uS clk) units of 67mS.
`endif

// State definitions for Shutdown handling
`define SD_Wait4Shtdwn 3'd0
`define SD_Send_Warn   3'd1
`define SD_Wait4TX     3'd2
`define SD_Wait4Ready  3'd3
`define SD_Rdy4Shtdwn  3'd4

// Shutdown Timeout
`define Shutdown_Time_Out 24'h2FAF08  // Time out for clearing pending transactions 50 mSec.

// Reduced Transmit Packet State Machine
`define rTxP_Idle    4'd0
`define rTxP_BR      4'd1
`define rTxP_No_MAC  4'd2         
`define rTxP_No_Hdr  4'd3        
`define rTxP_Data    4'd4      
`define rTxP_Stat    4'd5      
`define rTxP_Send    4'd6      
`define rTxP_Flush   4'd7      
`define rTxP_Rel_Bus 4'd8      
`define rTxP_Done    4'd9      


////////////////////////////////////////////////////////////////////////////////////////////////////////
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ //
// ========================== Reset Handler Module ================================================== //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

`define RST_hold_off  16'hFFFF        // hold off time to enable RESETs after power up (~1 Sec).

// Reset Enable signals
`define      Internal 5'b00001
`define   Front_Panel 5'b00010
`define  System_Reset 5'b00100
`define    Hard_Reset 5'b01000
`define External_JTAG 5'b10000


////////////////////////////////////////////////////////////////////////////////////////////////////////
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ //
// ========================== Commands and Function definitions for Opcodes ========================= //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

// === Config Module Commands === 
`define        Funct_NoOp 8'h00
`define       Set_FF_Test 8'h01
`define        Set_FF_VME 8'h02
`define        ECC_enable 8'h03
`define       ECC_disable 8'h04
`define     Save_Cnfg_Num 8'h05
`define Read_Cnfg_Num_Dir 8'h06
`define Read_Cnfg_Num_Dcd 8'h07
`define     Rstr_Cnfg_Num 8'h08
`define     Set_Cnfg_Dflt 8'h09
`define    Read_Cnfg_Dflt 8'h0A
`define          Set_MACs 8'h0B
`define     Read_MACs_Dir 8'h0C
`define     Read_MACs_Dcd 8'h0D
`define          Read_CRs 8'h0E
`define        Wrt_Eth_CR 8'h0F
`define        Wrt_Ext_CR 8'h10
`define        Wrt_Rst_CR 8'h11
`define        Wrt_VME_CR 8'h12
`define        Wrt_BTO_CR 8'h13
`define       Wrt_BGTO_CR 8'h14
`define       Wrt_All_CRs 8'h15
`define       Set_Clr_CRs 8'h16
`define       Set_Inj_Err 8'h17
`define       Rst_Inj_Err 8'h18
`define     Warn_On_Shdwn 8'h19
`define  No_Warn_On_Shdwn 8'h1A
`define   Snd_Startup_Pkt 8'h1B
`define    No_Startup_Pkt 8'h1C
`define       Wrt_Ser_Num 8'h1D
`define        Rd_Ser_Num 8'h1E
`define         Wrt_CR_ID 8'h1F
//
// === External FIFO command (buffered VME commands) === 
`define          VME_Cmds 8'h20
//
// === VME Direct Commands === 
//`define          VME_Cnfg 8'h21 //Not used
`define      VME_Dir_Cmds 8'h22
//`define      VME_Dir_Cnfg 8'h23 //Not used
//`define       UnDefined 8'h24
//                       .
//                       .
//                       .
//`define       UnDefined 8'h2F
//
// === JTAG Module Commands ===
`define         Rd_Dev_ID 8'h30
`define      Rd_User_Code 8'h31
`define      Rd_Cust_Code 8'h32
`define      Rd_Back_PROM 8'h33
`define        Erase_PROM 8'h34
`define      Program_PROM 8'h35
`define       Reload_FPGA 8'h36
`define       Verify_PROM 8'h37
`define     Chk_JTAG_Conn 8'h38
`define      Exec_Routine 8'h39
`define  Ld_Rtn_Base_Addr 8'h3A
`define     Module_Status 8'h3B
`define   Write_JTAG_FIFO 8'h3C
`define   Write_Prg_Space 8'h3D
`define    Read_Prg_Space 8'h3E
`define  Abort_JTAG_Cmnds 8'h3F
//
// === FLASH Module Commands ===
`define         Flash_R_W 8'h40
//                       .
//                       .
//                       .
//`define       UnDefined 8'h4F
//
// === Unassigned Command Space (handled by Ethernet Module) ===
//`define       UnDefined 8'h50
//                       .
//                       .
//                       .
//`define       UnDefined 8'hDF
//
// === External FIFO Module Commands ===
`define        Wrt_Ext_FF 8'hE0
`define       Prg_Ext_Off 8'hE1
`define      Rdbk_Ext_Off 8'hE2
`define       PRst_Ext_FF 8'hE3
`define         Rd_Ext_FF 8'hE4
`define         RT_Ext_FF 8'hE5
`define       MRst_Ext_FF 8'hE6
`define      ST_MK_Ext_FF 8'hE7
`define     RST_MK_Ext_FF 8'hE8
`define   Rst_Ext_Err_Cnt 8'hE9
`define   Rd_Ext_Err_Cnts 8'hEA
//`define       UnDefined 8'hEB
//                       .
//                       .
//                       .
//`define       UnDefined 8'hEE
`define       Flush_2_BOD 8'hEF
//
// === Ethernet Module Commands ===
`define        Rst_Seq_ID 8'hF0
//`define       UnDefined 8'hF1
//                       .
//                       .
//                       .
//`define     UnDefined 8'hF6
`ifdef Slave
   `define      Gen_Intr 8'hF7    //For Slave configuration only
   `define  Gen_Hard_Rst 8'hF8    //For Slave configuration only
`endif
`define      Force_Reload 8'hF9
//`define       UnDefined 8'hFA
//`define       UnDefined 8'hFB
//`define       UnDefined 8'hFC
`define      Send_N_Words 8'hFD
`define     Load_User_Reg 8'hFE
`define          Loopback 8'hFF


////////////////////////////////////////////////////////////////////////////////////////////////////////
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ //
// ========================== Retun Data, Error Handling, and Status Info. ========================== //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////


// Return Packet Type definitions
`define   Rtn_NoDat_Pkt 8'h00  //No data
`define   Rtn_LpBck_Pkt 8'h01  //Loopback packet
`define    Rtn_TXNW_Pkt 8'h02  //Transmit N Words packet
`define    Rtn_ExFF_Pkt 8'h03  //External FIFO packet (data or offsets)
`define  Rtn_VMED08_Pkt 8'h04  //VME data with  8 bit words
`define  Rtn_VMED16_Pkt 8'h05  //VME data with 16 bit words
`define  Rtn_VMED32_Pkt 8'h06  //VME data with 32 bit words
`define  Rtn_VMED64_Pkt 8'h07  //VME data with 64 bit words
`define    Rtn_JTAG_Pkt 8'h08  //JTAG packet
`define    Rtn_CNFG_Pkt 8'h0A  //Config module packet
`define   Rtn_Flash_Pkt 8'h0B  //Flash readback packet
`define  Rtn_EthNet_Pkt 8'h10  //Ethernet module packet
`define  Rtn_Intr08_Pkt 8'hF8  //Interrupt with  8 bit status ID
`define  Rtn_Intr16_Pkt 8'hF9  //Interrupt with 16 bit status ID
`define  Rtn_Intr32_Pkt 8'hFA  //Interrupt with 32 bit status ID
`define    Rtn_Info_Pkt 8'hFD  //Information packet
`define    Rtn_Warn_Pkt 8'hFE  //Warning packet
`define     Rtn_Err_Pkt 8'hFF  //Error packet

// Report Sources (Source ID's)  for INFOs, WARNs, and ERRs
`define Misc          4'h0  //No specified source
`define VME_Ctrl      4'h1  //VME Controller module
`define VME_Master    4'h2  //VME Master module
`define VME_Rdbk      4'h3  //VME Readback module
`define VME_IH        4'h4  //VME Interrupt module
`define VME_Slv       4'h5  //VME Slave module
`define VME_Arb       4'h6  //VME Arbiter module
`define Ext_FIFO_mod  4'h7  //External FIFO module
`define Eth_Rcv       4'h8  //Ethernet Receive module
`define Eth_Trns      4'h9  //Ethernet Transmit module
`define JTAG_mod      4'hA  //JTAG Interface
`define Flash_mod     4'hB  //Flash module
`define Config_mod    4'hC  //Configuration module
`define CP_mod        4'hD  //Command Processor module
`define Rst_Hndlr     4'hE  //Reset Handler module
`define Strtup_Shtdwn 4'hF  //Start-up / Shutdown module

// Error, Warning, and Info header codes
`define  HDR_Info       2'b00
`define  HDR_Warn       2'b01
`define  HDR_Error      2'b10

// Universal Code Words for Error, Warnings, and Information. 
// Misc.
`define  G_No_Info      10'h000 //    0 |I| No information
`define CP_Un_Asgn      10'h001 //    1 |E| Command has not been assign to a module
`define CP_Not_Def      10'h002 //    2 |E| Command is not defined in this module
`define CP_No_Data      10'h003 //    3 |E| Expected data was not present
`define CP_Not_Exec     10'h004 //    4 |E| Command was not executed
//
// VME Command Processor (VME Direct commands)
`define VD_Dat_WtErr    10'h100 //  256 |E| VME Direct Data FIFO Write error (written to while full)
`define VD_Dat_AF       10'h101 //  257 |W| VME Direct Data FIFO Almost Full (Stop sending VME Direct Commands)
`define VD_Hdr_WtErr    10'h102 //  258 |E| VME Direct MAC/Hdr FIFO Write error (written to while full)
`define VD_Hdr_AF       10'h103 //  259 |W| VME Direct MAC/Hdr FIFO Almost Full (Stop sending VME Direct Commands)
// VME Controller
`define VC_Unkn_Addr    10'h110 //  272 |E| Unknown VME Address
`define VC_Unkn_Dly     10'h111 //  273 |E| Unknown VME Delay type
`define VC_Incomp_Opt   10'h112 //  274 |E| Incompatible options specified in VME Control word
`define VC_RdEr_Units   10'h113 //  275 |E| Read error while reading number of VME Units
`define VC_RdEr_CtrlWrd 10'h114 //  276 |E| Read error while reading VME Control word
`define VC_RdEr_Addr    10'h115 //  277 |E| Read error while reading VME Address word
`define VC_RdEr_Dcnt    10'h116 //  278 |E| Read error while reading VME Data count word
`define VC_RdEr_Data    10'h117 //  279 |E| Read error while reading VME Data word
`define VC_MTEr_Fifo    10'h118 //  280 |E| FIFO Empty error; timedout while waiting to read
// VME Master
`define VM_BERR_Slv     10'h120 //  288 |E| VME Bus Error initiated by slave
`define VM_BTO          10'h121 //  289 |E| VME Bus Time Out
`define VM_Not_Sup      10'h122 //  290 |E| VME command is not supported
// VME Readback
`define VR_Mis_SOP      10'h130 //  304 |E| VME Read controller - missing Start of Packet
`define VR_Wrng_Typ     10'h131 //  305 |E| VME Read controller - wrong packet type seen
`define VR_Rd_TMO       10'h132 //  306 |E| VME Read controller - Timed out waiting for data
// VME Interrupt Handler
`define VI_BERR_Slv     10'h140 //  320 |E| VME Bus Error initiated by slave (during interrupt)
`define VI_BTO          10'h141 //  321 |E| VME Bus Time Out (during interrupt)
`define VI_Msk_Chg      10'h142 //  322 |W| IRQ Mask has changed
// VME Slave
// VME Arbiter
`define VA_BGTO         10'h161 //  353 |E| VME Bus Grant Time Out
// External FIFO
`define EF_Rd_Err       10'h200 //  512 |E| External FIFO went empty after Read started
`define EF_MT_Err       10'h201 //  513 |E| External FIFO was empty when Read was requested
`define EF_Rt_Err       10'h202 //  514 |E| External FIFO empty or Mark not set when retransmit read was requested
`define EF_Mk_Err       10'h203 //  515 |E| External FIFO attempt to set Mark when almost empty
`define EF_Wrt_Err      10'h204 //  516 |E| External FIFO went full after Write sequence started
`define EF_FF_PAF       10'h205 //  517 |W| External FIFO is almost full (stop sending FIFO or VME commands)
`define EF_V_wrt_Wrn    10'h206 //  518 |W| VME command received while in FIFO TEST mode (Data written to FIFO)
`define EF_Rd_V_Err     10'h207 //  519 |E| FIFO read command received while in VME mode (no data read from FIFO)
`define EF_Mltp_Err     10'h208 //  520 |E| Multiple FIFO Errors
`define EF_Wrt_Wrn      10'h209 //  521 |W| Write command received while in VME mode (Data written to FIFO)
`define EF_MHAF_Wrn     10'h20A //  522 |W| MAC/Header FIFO is almost full (Stop sending packets)
`define EF_Drp_Err      10'h20B //  523 |E| Packet was dropped due to MAC/Header FIFO being full.
`define EF_MHAMT_Inf    10'h20C //  524 |I| MAC/Header FIFO is almost empty
`define EF_AMT_Inf      10'h20D //  525 |I| External FIFO is almost empty
// Ethernet Receive
`define ER_Rcv_Err      10'h210 //  528 |E| Ethernet Receive FIFO went empty before all packet data was read
// Ethernet Transmit
// JTAG
`define JT_Buf_AF       10'h230 //  560 |W| JTAG Buffer is almost full (stop sending JTAG commands)
`define JT_Buf_Ovfl     10'h231 //  561 |E| JTAG Buffer Overflowed (some JTAG commands are lost)
`define JT_Buf_AMT      10'h232 //  562 |I| JTAG Buffer is almost MT (start sending JTAG commands)
`define JT_Buf_RdErr    10'h233 //  563 |E| JTAG Buffer Read Error
`define JT_Unk_Cmd      10'h234 //  564 |E| Unknown JTAG Command
`define JT_Ver_Fail     10'h235 //  565 |E| PROM Verification failed
`define JT_Prg_Fail     10'h236 //  566 |E| PROM Programming failed
// Flash Controller
`define FL_In_AF        10'h240 //  576 |W| Flash Cntrl Input FIFO is almost full (stop sending Flash or Config commands)
`define FL_In_WtErr     10'h241 //  577 |E| Flash Cntrl Input FIFO Write Error (attempted write when full; some information lost)
`define FL_In_RdErr     10'h242 //  578 |E| Flash Cntrl Input FIFO Read Error (attempted read when empty; data invalid)
`define FL_TRDS_WtErr   10'h243 //  579 |E| Flash Cntrl Total ReaDS FIFO Write Error (attempted write when full; some information lost)
`define FL_TRDS_RdErr   10'h244 //  580 |E| Flash Cntrl Total ReaDS FIFO Read Error (attempted read when empty; data invalid)
`define FL_PgRd_WtErr   10'h245 //  581 |E| Flash Cntrl Page/Read FIFO Write Error (attempted write when full; some information lost)
`define FL_PgRd_RdErr   10'h246 //  582 |E| Flash Cntrl Page/Read FIFO Read Error (attempted read when empty; data invalid)
`define FL_ADFF_WtErr   10'h247 //  583 |E| Flash Cntrl Address FIFO Write Error (attempted write when full; some information lost)
`define FL_ADFF_RdErr   10'h248 //  584 |E| Flash Cntrl Address FIFO Read Error (attempted read when empty; data invalid)

// Config
`define CF_Mltp_Flsh    10'h250 //  592 |E| Multiple errors from Flash Controller (see following data word for error bits). 
`define CF_Crptd_Dat    10'h251 //  593 |E| Corrupted data from Flash Controller (uncorrected bit errors).
`define CF_Bit_Errs     10'h252 //  594 |W| Bit errors in data from Flash Controller were found and corrected.

// Rst_Hndlr
`define RH_xxx_xxx      10'h260 //  608 |W| 

// Strtup_Shtdwn
`define SS_Rld_Pndg     10'h270 //  624 |W| Controller is shuting down to reload firmware
`define SS_Sys_Up       10'h271 //  625 |I| Controller system is back up

//Acknowledgement Status Word
`define  No_Ack 4'h0  //No Acknowledgement Requested or not implemented
`define  CC_S   4'h1  //Command Completed Sucessfully
`define  CC_W   4'h2  //Command Completed with Warnings
`define  CC_E   4'h3  //Command Completed with Errors
`define  CE_I   4'h4  //Command Execution finished Incomplete
`define  CiP    4'h5  //Command in Progress no warnings no errors
`define  CiP_W  4'h6  //Command in Progress with Warnings
`define  CiP_E  4'h7  //Command in Progress with Errors

////////////////////////////////////////////////////////////////////////////////////////////////////////
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ //
// ================================= Ethernet Parameters Common to both Receive and Transmit ======== //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

// Define Octet constants
`define     D2_2 8'h42        
`define     D5_6 8'hC5        
`define    D16_2 8'h50        
`define    D21_5 8'hB5        
`define    K28_5 8'hBC      
`define    K23_7 8'hF7     // /R/ Carrier Extend
`define    K27_7 8'hFB     // /S/ SOP
`define    K29_7 8'hFD     // /T/ EOP
`define    K30_7 8'hFE     // /V/ ERROR_Prop
//
`define    PRMBL 8'h55     // Preamble octet
`define    SOF_BYTE 8'hD5  // Start of Frame octet

`define    CONFIG1 {`K28_5,`D21_5}  // First half of configuration code groups
`define    CONFIG2 {`K28_5,`D2_2}   // First half of configuration code groups
//`define    AN_adv_ability 16'h8020  // Auto Negotiate advertised abilities (Full Duplex and Next Page)
`define    AN_adv_ability 16'h6041  // Auto Negotiate advertised abilities
`define    AN_np_tx 16'h2001        // Auto Negotiate Message Page (Null Message)
`define    IDLE1 {`K28_5,`D5_6}
`define    IDLE2 {`K28_5,`D16_2}
`define    PREAMBLE1 {`K27_7,`PRMBL}     // Start of Packet plus first preamble word 
`define    PREAMBLE2 {`PRMBL,`PRMBL}     // Preamble words 
`define    PREAMBLE3 {`PRMBL,`PRMBL}     // Preamble words 
`define    PREAMBLE4 {`PRMBL,`SOF_BYTE}  // Preamble plus Start of Frame word 
`define    Carrier_Extend {`K23_7,`K23_7}  // Carrier extend 
`define    End_of_Packet {`K29_7,`K23_7}  // End of Packet plus carrier extend 

//
////////////////////////////////////////////////////////////////////////////////////////////////////////
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ //
// ================================= Ethernet Receiver Modules ====================================== //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////
//                                               //
// RXSTAT_ERR_MON.v                              //
//                                               //
///////////////////////////////////////////////////

// CRC Checking State Machine
`define       Wait_for_SOP  3'o0
`define    Wait_for_Update  3'o1
`define Wait_for_CRC_Check  3'o2
`define           Good_CRC  3'o3
`define            Bad_CRC  3'o4
`define       No_CRC_Check  3'o5
`define       Record_Stats  3'o6

// Timeout waiting for CRC check
`define    Time_Limit  3'o7

///////////////////////////////////////////////////
//                                               //
// Receive MAC processor                         //
//                                               //
///////////////////////////////////////////////////

// Packet Parameters
`define    MAC_BCAST 16'hFFFF
`define    PRMB_TIMEOUT 16'd10
`define    PACKET_TIMEOUT 16'd5000
`define    MAX_BYTE 16'd9000   //Maximum number of bytes in jumbo packets. For rcvd. pkt. len. check.

// State definitions for ethernet packets
`define    Wait_for_packet 3'o0
`define           Preamble 3'o1
`define           MAC_Dest 3'o2
`define         MAC_Source 3'o3
`define          Store_LEN 3'o4
`define            Payload 3'o5
`define       Update_Stats 3'o6
`define      Wait_for_Idle 3'o7

///////////////////////////////////////////////////
//                                               //
// Receive FIFO                                  //
//                                               //
///////////////////////////////////////////////////

// Comparison constants
`define Rx_Full_Cnt  13'd8191         // FIFO word count when full (Now using 8k FIFOs)
`define Rx_AF_Cnt 13'd8063            // FIFO word count when almost full

// State definitions for RX FIFO Write Control
`define          RST_all  3'o0
`define        Save_Addr  3'o1
`define    Wait_for_Data  3'o2
`define Store_MAC_Source  3'o3
`define Store_Frame_Data  3'o4
`define     Bad_Frame_St  3'o5
`define    Good_Frame_St  3'o6
`define         Not_def2  3'o7

// State definitions for RX FIFO Read Control
`define   Wait_for_Frame  2'o0
`define     Load_Cnt_Dwn  2'o1
`define    Issue_Frm_Rdy  2'o2
`define        Not_def_2  3'o3


///////////////////////////////////////////////////
//                                               //
// Ethernet Receive Frame Interface              //
//                                               //
///////////////////////////////////////////////////
 
// State definitions for FIFO read state machine FF_READ_ST
`define        RxFr_Idle 4'h0
`define   Store_Ctrl_Wrd 4'h1
`define   Wait_4_MAC_Req 4'h2
`define    RxFr_Send_MAC 4'h3
`define        Send_Ctrl 4'h4 
`define         Send_Seq 4'h5 
`define Wait_4_Frame_Req 4'h6
`define        Read_FIFO 4'h7
`define        Rpt_Error 4'h8
`define        Err_Wrd_2 4'h9
`define       End_of_Pkt 4'hA 
`define         Clr_Buss 4'hB 

///////////////////////////////////////////////////
//                                               //
// Ethernet Command Processor Controller         //
//                                               //
///////////////////////////////////////////////////
 
// State definitions for Ethernet Command Processor FSM
`define  Eth_CP_Idle        4'h0
`define  Eth_CP_Get_Funct   4'h1
`define  Eth_CP_Need_Bus    4'h2
`define  Eth_CP_Req_Bus     4'h3
`define  Eth_CP_Ini_Stat    4'h4
`define  Eth_CP_Get_Frame   4'h5
`define  Eth_CP_Fin_Stat    4'h6
`define  Eth_CP_Send_Pkt    4'h7
`define  Eth_CP_Rel_Bus     4'h8
`define  Eth_CP_Send_Data   4'h9
`define  Eth_CP_Send_Ack    4'hA
`define  Eth_CP_Rel_Snd     4'hB
`define  Eth_CP_Gen_Err_Pkt 4'hC
`define  Eth_CP_Rdy4Shtdwn  4'hF

///////////////////////////////////////////////////
//                                               //
// Auto Negotiate Function                       //
//                                               //
///////////////////////////////////////////////////
 
// State definitions for Auto Negotiate FSM (AN_FSM)
`define  Eth_AN_Enable      4'h0
`define  Eth_AN_Restart     4'h1
`define  Eth_AN_Ability_Det 4'h2
`define  Eth_AN_Ack_Det     4'h3
`define  Eth_AN_Cmplt_Ack   4'h4
`define  Eth_AN_Idle_Det    4'h5
`define  Eth_AN_Link_OK     4'h6
`define  Eth_AN_NP_Wait     4'h7
`define  Eth_AN_Disable     4'h8

// Link Timer time out
`define AN_Link_Timer_Done  10'h263 //10 mS
//`define AN_Link_Timer_Done  10'h005 //81.92 uS

// Auto Negotiate time out
//`define AN_TimeOut          16'h2FAF //200 mS
`define AN_TimeOut          16'h0BEC //50 mS


////////////////////////////////////////////////////////////////////////////////////////////////////////
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ //
// ========================== Ethernet Transmit Modules ============================================= //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////
//                                               //
// Packet Builder                                //
//                                               //
///////////////////////////////////////////////////

// Comparison constants
`define Pb_AF_Cnt 13'd8063            // FIFO word count when almost full
// State definitions for TX FIFO Read Control
`define Wait_for_Payload  3'd0
`define    Load_Data_Len  3'd1
`define        With_Data  3'd2
`define      Issue_Send1  3'd3
`define      Issue_Send2  3'd4
`define      Issue_Send3  3'd5
// State definitions for TX FIFO Write Control
`define  Frag_Rst  2'd0
`define  New_Pkts  2'd1
`define Cont_Pkts  2'd2
// State definitions for TX FIFO DFLT MAC control
`define DMACA0 3'd0
`define DMACA1 3'd1
`define DMACA2 3'd2
`define DMACP1 3'd3
`define DMACP2 3'd4
// State definitions for TX FIFO DFLT HDR control
`define DHDR00 2'd0
`define DHDRP0 2'd1
`define DHDRP1 2'd2

//`define Max_Payload 13'd4493-`Header_Size // Maximum data payload size in 16 bit words (for 9000 byte jumbo pkts)
`define Max_Payload 13'd3993-`Header_Size // Maximum data payload size (for 8000 byte jumbo pkts)
//`define Max_Payload 13'd1000 // For simulation testing Maximum data payload size in 16 bit words

///////////////////////////////////////////////////
//                                               //
// Tx_MAC_Frame                                  //
//                                               //
///////////////////////////////////////////////////

`define       Pkt_Space 4'd6   //Minimum inter-packet spacing is 12 bytes (6 words) 
`define  Min_Frame_Size 6'd32  //Minimum packet size is 64 Bytes (32 words) 
`define        Min_Pkt 16'd46  //16 bit Minimum packet size in Bytes (data payload)
`define    Min_Pkt_Size 6'd23  //Minimum packet size (data payload) is 46 Bytes (23 words) 
`define   Min_Time_Slot 8'd255 //Minimum time slot is 4096 bit times 512 bytes (256 words) 
`define     Header_Size 3'd4   //Header size in words if present 
`define        Attempts 2'd3   //Maximum number of transmit attempts

// State definitions for Transmit Control
`define Wait_4_TX_Ready 3'h0
`define   Rst_Addr_Cntr 3'h1
`define         Read_MH 3'h2
`define       Read_HDRs 3'h3
`define Transmit_Packet 3'h4
`define    Wait_TX_Done 3'h5
`define    Upd_TX_Stats 3'h6

// State definitions for ethernet packets
`define        Xmit_Idle 4'h0
`define      TX_Preamble 4'h1
`define      TX_MAC_Dest 4'h2
`define    TX_MAC_Source 4'h3
`define           Length 4'h4
`define    Proto_Encoder 4'h5
`define     Payload_Data 4'h6
`define     Min_Pkt_Fill 4'h7
`define        CRC_Space 4'h8
`define              EOP 4'h9
`define       Byte_Extnd 4'ha
`define    Int_Pkt_Space 4'hb

// Mux selection constants
`define   Sel_Constants 3'o0
`define Sel_Destination 3'o1
`define      Sel_Source 3'o2
`define      Sel_Length 3'o3
`define    Sel_Protocol 3'o4
`define        Sel_Data 3'o5

// State definitions for MAC recall
`define Wait_for_SOF 3'h0
`define          MP1 3'h1
`define          MP2 3'h2
`define          MP3 3'h3
`define          MS1 3'h4
`define          MS2 3'h5
`define          MS3 3'h6

// State definitions for Header recall
`define  Wait_for_Len 3'h0
`define          HDR1 3'h1
`define          HDR2 3'h2
`define          HDR3 3'h3
`define          HDR4 3'h4

// State definitions for ROM address
`define       Send_Idles 4'h0
`define        Preamble1 4'h1
`define        Preamble2 4'h2
`define        Preamble3 4'h3
`define        Preamble4 4'h4
`define            M_P_F 4'h5
`define            CRC_1 4'h6
`define            CRC_2 4'h7
`define            E_O_P 4'h8
`define            B_Ext 4'h9
`define            I_P_S 4'hA
`define      AN_Cnfg1    4'hB
`define      AN_Cnfg_Reg 4'hC
`define      AN_Cnfg2    4'hD


////////////////////////////////////////////////////////////////////////////////////////////////////////
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ //
// ================================= Configuration Module =========================================== //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////
//                                               //
// Configuration Command Processor               //
//                                               //
///////////////////////////////////////////////////

// State definitions for Configuration Command Processor FSM
`define  CCP_Idle        4'h0
`define  CCP_Get_Funct   4'h1
`define  CCP_Get_MAC     4'h2
`define  CCP_Cnfg_Rdy    4'h3
`define  CCP_Ld_CFR      4'h4
`define  CCP_Get_Frame   4'h5
`define  CCP_Exec        4'h6
`define  CCP_W4FD        4'h7
`define  CCP_Send_Data   4'h8
`define  CCP_Send_Ack    4'h9
`define  CCP_W4Data      4'hA
`define  CCP_Rel_Snd     4'hB
`define  CCP_Abort       4'hC
`define  CCP_Send_Err    4'hD
`define  CCP_Clr_CFR     4'hE
`define  CCP_Rdy4Shtdwn  4'hF

// Masks for setting flags in control registers
`define     Test_FF_Mode_msk 32'h00000001
`define      VME_FF_Mode_msk 32'hFFFFFFFE
`define       ECC_Enable_msk 32'h00000002
`define      ECC_Disable_msk 32'hFFFFFFFD
`define      Set_Inj_Err_msk 32'h00000004
`define      Rst_Inj_Err_msk 32'hFFFFFFFB
`define    Warn_On_Shdwn_msk 32'h00000020
`define No_Warn_On_Shdwn_msk 32'hFFFFFFDF
`define  Snd_Startup_Pkt_msk 32'h00000040
`define   No_Startup_Pkt_msk 32'hFFFFFFBF

// Control register selection codes for reading out
`define   Sel_Eth_CR  3'd0
`define   Sel_Ext_CR  3'd1
`define   Sel_Rst_CR  3'd2
`define  Sel_VMEh_CR  3'd3
`define  Sel_VMEl_CR  3'd4
`define   Sel_BTO_CR  3'd5
`define  Sel_BGTO_CR  3'd6

// Configure Register ID's
`define       Eth_CR  4'd0
`define    Ext_FF_CR  4'd1
`define   Rst_Ena_CR  4'd2
`define       VME_CR  4'd3
`define       BTO_CR  4'd4
`define      BGTO_CR  4'd5
`define       ALL_CR  4'd8


// Configure Register default values

////////////////////////////////////////////////////////////////////////////////////////
//
// ETHER_CNFG(15:0)
// Ethernet configuration bits:
// Bit  Signal        Function
//  0   TXINHIBIT     Inhibits RocketIO transmission   (DISABLED)
//  1   TDIS          Disables fiber optic transmitter (DISABLED)
//  2   PASSTHRU      Received packets are transmitted back to sender without any processing
//  3   PROMISCUOUS   Accepts packets regardless of intended MAC destination.
//  4   PROTO_ENABLE  Enables a protocol header on transmitted packets.
//  5   XTEND         Enables carrier extend for packet bursting.
//  6   SPONT_PKT_ENA Enables spontaneously generated packet sending for error, warning and info reporting.
//  7   SWITCH_CNTRL  Enables front panel switch control over some of the above signals. (DISABLED)
// 8-15 RSVD          Reserved.
//
//////////////////////////////////////////////////////////////////////////////////////
`define    Ether_Cnfg_Dflt  16'h0050

////////////////////////////////////////////////////////////////////////////////////////
//
// EXT_FIFO_CNFG(15:0)
// External FIFO configuration bits:
// Bit  Signal        Function
//  0   FF_TEST_MODE  Allows for dircet readback for testing the FIFO. (FIFO reads from the VME module are disabled)
//  1   FF_ECC_ENA    Enables error correcting codes to be used in the external FIFO
//  2   FF_INJ_ERRS   Will inject errors after ECC encoding for FIFO decode testing
// 3-15 RSVD          Reserved.
//
//////////////////////////////////////////////////////////////////////////////////////
`define Ext_FIFO_Cnfg_Dflt  16'h0002

////////////////////////////////////////////////////////////////////////////////////////
//
// RESET_CNFG(15:0)
// Configuration bits for enabling Reset sources:
// Bit  Signal          Function
//  0   ENA_INTERNAL    Allows reprograming from an FPGA gernerated signal (on command through ethernet).
//  1   ENA_FP          Allows reprograming from front panel push button.
//  2   SYS_RESET       Allows reprograming on VME SYSRESET signal.
//  3   HARD_RESET      Allows reprograming on the custom backplane Hard Reset signal.
//  4   Ext_JTAG        Allows reprograming thru JTAG from the CF pin on the configuration PROM 
//  5   Warn_On_Shdwn   Sends a warning packet to the server when a shutdown is pending
//  6   Snd_Startup_Pkt Sends a Info packet to the server after initialization. 
//  7   RSVD            Reserved.
// 8-9  Msg_Lvl         Message level 
//                          0: No messages
//                          1: Errors only
//                          2: Errors and warnings
//                          3: Errors, warnings, and info packets
// 10-15 RSVD           Reserved.
//
//////////////////////////////////////////////////////////////////////////////////////
`define    Reset_Cnfg_Dflt  16'h031B

////////////////////////////////////////////////////////////////////////////////////////
//
// VME_CNFG(31:0)
// Configuration bits for the VME module:
// Bit  Signal          Function
//  0   VME_MSTR_ENA    Enables the VME master.
//  1   VME_SYSCLK_ENA  Enables the VME SYSCLK on the backplane (if it's a System Controller ie. slot 1)
//  2   BTO_ENA         Enables the Bus Timer module.
//  3   ARB_ENA         Enables the Arbiter module for controlling bus arbitration (if System Controller).
//  4   MASK_BERR       Mask off monitoring of BERR signal. 
//  5   LOC_MON_ENA     Enables the Location Monitor features.
//  6   INTR_HNDLR_ENA  Enables interrupt handling.
//  7   USER_DEFS_ENA   Enables user defined buffers on J2.
// 8,9  MSTR_REQ_TYPE   Specifies the requester type for the master module.
//                          0: Release On Request (ROR)
//                          1: Release When Done (RWD)
//                          2: Fair ROR requester
//                          3: Fair RWD requester
//10,11 MSTR_REQ_LVL    Specifies the bus request level for the master module.
//12,13 ARB_TYPE        Specifies the Arbiter type.
//                          0: No Arbitration (disabled)
//                          1: SinGLe Level Arbiter (SGL)
//                          2: PRIoritized Arbiter (PRI)
//                          3: Round Robin Select (RRS)
// 14   ENA_HI_ORDER    Enable the high order bits of Address and Data Buses.
// 15   FRC_SYSRST      Force a SYSRESET.
//16-22 IH_LVLS         Specifies the Levels (1-7) the Interrupt Handler will service (7 bits).
// 23   UPD_IRQ_MSK     Update IRQ mask - restores the mask to IH_LVLS set in this register and auto resets itself to 0.
//24,25 IH_REQ_TYPE     Specifies the requester type for the Interrupt Handler.
//26,27 IH_REQ_LVL      Specifies the bus request level for the Interrupt Handler.
//28,29 IH_DT_SZ        Specifies the data transfer capability of the Interrupt Handler.
//30    SYSRST_OUT_ENA  Enable SYSRESETs out to backplane.
//31    SYSRST_IN_ENA   Enable Monitoring SYSRESETs on the backplane
//
//////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////
//  Only the following are used for the Slave version.
////////////////////////////////////////////////////////////////////////////////////////
//
// VME_CNFG(31:0)
// Configuration bits for the VME module:
// Bit  Signal          Function
//  4   SLAVE_ENA       Enables the Slave module features. 
// 9-5  CRD_ADDR        Card Address when not in VME64X slot. 
// 15   FRC_SYSRST      Force a SYSRESET.
//24    INTR_ENA        Enables the Interrupter.
//25,27 IRQ_LVL         Specifies the request level assigned to this Interrupter (1-7).
//28,29 I_DT_SZ         Specifies the data transfer capability of the Interrupter.
//30    SYSRST_OUT_ENA  Enable SYSRESETs out to backplane.
//31    SYSRST_IN_ENA   Enable Monitoring SYSRESETs on the backplane
//
//////////////////////////////////////////////////////////////////////////////////////
`ifdef Slave
   `define      VME_Cnfg_Dflt 32'h0F000190   //Default for slave configuration
`else
   `define      VME_Cnfg_Dflt 32'hEDFF1D0F   //Default for master configuration
`endif
////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////
// VME Bus Timeout default
`ifdef Simulation
   `define       VME_BTO_Dflt 16'h00D4     // 212 (3.392 uS in 16 nS units) for simulation
`else
   `define       VME_BTO_Dflt 16'h30D4     //Default is 12,500 (16'h30D4)(200 uS in 16 nS units)
`endif
//////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////
// VME Bus Grant Timeout default
`ifdef Simulation
   `define      VME_BGTO_Dflt 16'h0139     //  313 (5.0 usec. in nS units) for simulation
`else
   `define      VME_BGTO_Dflt 16'h0C35     //Default is  3,125 (16'h0C35)(50 uS in 16 nS units)
`endif
//////////////////////////////////////////////////////////////////////////////////////

// State definitions for Configuration Module FSM
`define       Cnfg_Idle  6'h00
`define     W4ValDat_CR  6'h01
`define    W4ValDat_Wrt  6'h02
`define       Wrt_VME_L  6'h03
`define    W4ValDat_All  6'h04
`define     W4ValDat_SC  6'h05
`define        Mask_LD1  6'h06
`define        Mask_LD2  6'h07
`define    Set_Clr_Bits  6'h08
`define    Get_Cnfg_Num  6'h09
`define      Get_MAC_ID  6'h0A
`define     Wrt_MAC_Seq  6'h0B
`define      Set_MAC_ID  6'h0C
`define   Get_Ser_Num_H  6'h0D
`define   Get_Ser_Num_L  6'h0E
`define      Funct_Done  6'h0F
`define          W4Exec  6'h10
`define     Get_MAC_Seq  6'h11
`define      Ld_MAC_Reg  6'h12
`define     Snd_MAC_Seq  6'h13
`define     Incr_MAC_ID  6'h14
`define    Snd_Cnfg_Seq  6'h15
`define    Snd_Dflt_Seq  6'h16
`define  Snd_SerNum_Seq  6'h17
`define     Read_1_Dflt  6'h18
`define       Load_Dflt  6'h19
`define       Send_Dflt  6'h1A
`define   Read_1_SerNum  6'h1B
`define     Load_SerNum  6'h1C
`define     Send_SerNum  6'h1D
`define      Ena_Rd_Seq  6'h1E
`define         PH1Done  6'h1F
`define     Rcv_From_FL  6'h20
`define      Read_2_MAC  6'h21
`define      Load_2_MAC  6'h22
`define        Send_MAC  6'h23
`define    Wrt_MAC_Seq2  6'h24
`define    Incr_MAC_ID2  6'h25
`define     Read_2_Cnfg  6'h26
`define     Load_2_Cnfg  6'h27
`define      Send_CnfgA  6'h28
`define       Load_CRsA  6'h29
`define         Incr_Lp  6'h2A
`define     Read_1_Cnfg  6'h2B
`define     Load_1_Cnfg  6'h2C
`define      Send_CnfgB  6'h2D
`define       Load_CRsB  6'h2E

`define   Cnfg_Snd_Data  6'h30
`define        Send_Dir  6'h31
`define  Cnfg_Data_Done  6'h32
`define     Cnfg_W4TXDN  6'h33
`define        PH2_Done  6'h34


// State definitions for Send MAC Sequence FSM
`define        SM1_Idle 4'h0
`define     SM1_Req_Snd 4'h1
`define        SM1_Hdr1 4'h2
`define       SM1_Hdr2a 4'h3
`define      SM1_NoHdr1 4'h4
`define      SM1_NoHdr2 4'h5
`define    SM1_MC1_Load 4'h6
`define   SM1_MC1_Shift 4'h7
`define  SM1_MC2_ShiftA 4'h8
`define    SM1_MC2_Load 4'h9
`define  SM1_MC2_ShiftB 4'hA
`define       SM1_Shift 4'hB
`define        SM1_Pipe 4'hC
`define        SM1_Done 4'hD

// State definitions for Send Default Sequence FSM
`define         SD1_Idle 3'h0
`define      SD1_Req_Snd 3'h1
`define         SD1_Hdr1 3'h2
`define        SD1_Hdr2b 3'h3
`define    SD1_Dflt_Load 3'h4
`define   SD1_Dflt_Shift 3'h5
`define         SD1_Pipe 3'h6
`define         SD1_Done 3'h7

// State definitions for Send Serial Number Sequence FSM
`define        SSN1_Idle 3'h0
`define     SSN1_Req_Snd 3'h1
`define        SSN1_Hdr1 3'h2
`define       SSN1_Hdr2d 3'h3
`define SSN1_SerNum_Load 3'h4
`define       SSN1_Shift 3'h5
`define        SSN1_Pipe 3'h6
`define        SSN1_Done 3'h7

// State definitions for Send Cnfg Sequence FSM
`define         SC1_Idle 4'h0
`define      SC1_Req_Snd 4'h1
`define         SC1_Hdr1 4'h2
`define        SC1_Hdr2c 4'h3
`define   SC1_Cnfg_LoadA 4'h4
`define  SC1_Cnfg_ShiftA 4'h5
`define  SC1_Cnfg_ShiftB 4'h6
`define  SC1_Cnfg_ShiftC 4'h7
`define   SC1_Cnfg_LoadB 4'h8
`define         SC1_Pipe 4'h9
`define         SC1_Done 4'hA

// State definitions for Flash to Configuration model FSM (F2C_FSM).
`define  F2C_Idle    2'h0
`define  F2C_Shift   2'h1
`define  F2C_Load_AC 2'h2
`define F2C_Complete 2'h3


//// For simulations of Config module only
//`define    Exc_Idle 3'o0
//`define   Exc_Wait1 3'o1
//`define   Exc_Hold1 3'o2
//`define   Exc_Wait2 3'o3
//`define   Exc_Hold2 3'o4
//// For simulations of Config module only
//`define        PU_Idle 3'o0
//`define   PU_Rstr_Dflt 3'o1
//`define       PU_Wait1 3'o2
//`define   PU_Rstr_MACs 3'o3
//`define       PU_Wait2 3'o4
//`define   PU_Rstr_Cnfg 3'o5
//`define PU_Clr_Startup 3'o6

//Definition of MAC types
`define   Device_MAC 3'o0
`define   Mcast1_MAC 3'o1
`define   Mcast2_MAC 3'o2
`define   Mcast3_MAC 3'o3
`define Dflt_Srv_MAC 3'o4


// MAC address firmware defaults (Type,Addr,MAC_Wrd):
`define   Dflt_MAC0 21'h00AABB
`define   Dflt_MAC1 21'h01CCDD
`define   Dflt_MAC2 21'h02EEFF
`define   Dflt_MAC3 21'h04FFFF
`define   Dflt_MAC4 21'h05FFFF
`define   Dflt_MAC5 21'h06FFFE
`define   Dflt_MAC6 21'h08FFFF
`define   Dflt_MAC7 21'h09FFFF
`define   Dflt_MAC8 21'h0AFFFD
`define   Dflt_MAC9 21'h0CFFFF
`define   Dflt_MACA 21'h0DFFFF
`define   Dflt_MACB 21'h0EFFFC
`define   Dflt_MACC 21'h10FFFF
`define   Dflt_MACD 21'h11FFFF
`define   Dflt_MACE 21'h12FFFF


////////////////////////////////////////////////////////////////////////////////////////////////////////
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ //
// ================================= Flash Controller Module ======================================== //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

// Sources of errors, data, and ACK in Flash Controller
`define FL_No_Req     3'h0  //Flash No Requests
`define FL_SD_Data    3'h1  //Flash Send Data, Data
`define FL_SD_Err     3'h2  //Flash Send Data, Errors
`define FL_CI_Ack     3'h3  //Flash Control Input Acknowledgments
`define FL_CI_Err     3'h4  //Flash Control Input Errors
`define FL_CP_Warn    3'h5  //Flash Command Processor, Warnings
`define FL_CP_Err     3'h6  //Flash Command Processor, Errors

///////////////////////////////////////////////////
//                                               //
// Flash Command Processor Controller            //
//                                               //
///////////////////////////////////////////////////

// State definitions for Flash Command Processor FSM (FL_CP_ST)
`define  FL_CP_Idle        4'h0
`define  FL_CP_RmHold      4'h1
`define  FL_CP_Hold        4'h2
`define  FL_CP_Get_Funct   4'h3
`define  FL_CP_Get_MAC     4'h4
`define  FL_CP_isAF        4'h5
`define  FL_CP_Get_Frame   4'h6
`define  FL_CP_SRL2FF      4'h7
`define  FL_CP_Snd_Warn    4'h8
`define  FL_CP_isAMT       4'h9
`define  FL_CP_Dmy_Get     4'hA
`define  FL_CP_Snd_Err     4'hB
`define  FL_CP_Rdy4Shtdwn  4'hF

// Flash Memory Controller Input FIFO State Machine Definitions  (FLCI_ST)
`define FLCI_Idle    4'h0
`define Rd_NumPg     4'h1
`define Ld_NumPg     4'h2
`define Rd_WPNB      4'h3
`define Ld_WPNB      4'h4
`define W4Rdy        4'h5
`define Xfer2Fl      4'h6
`define Push_TRDS    4'h7 
`define Push_EWRAP   4'h8 
`define Dmp_Hdr      4'h9 
`define FF2SRL       4'hA 
`define FF2HFF       4'hB 
`define FLCI_Snd_Ack 4'hC 
`define FLCI_Snd_Err 4'hD 
`define FLCI_Rdy4Shtdwn  4'hF

// Flash Memory Controller Send return data to Config or Transmit Bus  (FL_SD_ST)
`define FL_SD_Idle    5'h00
`define Rd_Counts     5'h01
`define Ld_Counts     5'h02
`define Chk_Rcv2      5'h03
`define HFF2SDSRL     5'h04
`define W4AllRds      5'h05
`define FL_Snd_Data   5'h06
`define Xmit_Page     5'h07
`define Xmit_Reads    5'h08
`define Rd_Pg_Rd      5'h09
`define Ld_Pg_Rd      5'h0A
`define Cnfg_Done     5'h0B
`define W4Cnfg        5'h0C
`define Data_Done     5'h0D
`define W4TXDone      5'h0E
`define FL_SD_Snd_Err 5'h0F
`define FL_SD_Rdy4Shtdwn  5'h1F

///////////////////////////////////////////////////
//                                               //
// Flash Memory Interface                        //
//                                               //
///////////////////////////////////////////////////

// Flash Memory Interface State Machine Definitions  (FLC_ST)
`define  FL_Idle      5'h00
`define  W100         5'h01
`define  Read1        5'h02
`define  RelOE1       5'h03
`define  Read2        5'h04
`define  Rel_Cmp_D6   5'h05
`define  W4Data       5'h06
`define  Have_Data    5'h07
`define  Pop_n_Load   5'h08
`define  W4RdAcc      5'h09
`define  Ld_FLout_Rd  5'h0A
`define  Start_Rd     5'h0B
`define  PopPg_n_Ld   5'h0C
`define  W4WrtAcc1    5'h0D
`define  Ld_FLout_Wrt 5'h0E
`define  Start_Wrt    5'h0F
`define  W4WrtAcc2    5'h10
`define  Ld_DPW_Seq   5'h11
`define  Wrt_DPW_Seq  5'h12
`define  W4WrtAcc3    5'h13
`define  Write_Page   5'h14
`define  Poll_D7      5'h15
`define  Rel_Cmp_D7   5'h16
`define  FL_Ready     5'h17


// Dummy Flash Memory State Machine Definitions  (DP_ST)
`define  NORM_DATA    1'b0
`define  TOG_DATA_BAR 1'b1


////////////////////////////////////////////////////////////////////////////////////////////////////////
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ //
// ================================= External FIFO Module =========================================== //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////
//                                               //
// External FIFO  Command Processor  Controller  //
//                                               //
///////////////////////////////////////////////////

`define  FCP_Idle        5'h00
`define  FCP_Get_Funct   5'h01
`define  FCP_Get_MAC     5'h02
`define  FCP_FFR_Rdy     5'h03
`define  FCP_Ld_RFunct   5'h04
`define  FCP_FFW_Rdy     5'h05
`define  FCP_Ld_WFunct   5'h06
`define  FCP_Get_Frame   5'h07
`define  FCP_Send_Wrn    5'h08
`define  FCP_PAE         5'h09
`define  FCP_Dmy_Get     5'h0A
`define  FCP_W4Hld       5'h0B
`define  FCP_ReadFF      5'h0C
`define  FCP_W4Done      5'h0D
`define  FCP_Rel_Snd     5'h0E
`define  FCP_Send_Err    5'h0F
`define  FCP_Send_Data   5'h10
`define  FCP_Send_Ack    5'h11
`define  FCP_W4FD        5'h12
`define  FCP_SRL2FF      5'h13
`define  FCP_Clr_RWF     5'h14
`define  FCP_Rdy4Shtdwn  5'h1F

// External FIFO Write Function codes
`define        WNoOp 3'd0
`define      MRst_FF 3'd1
`define      PRst_FF 3'd2
`define       Wrt_FF 3'd3
`define  Prg_Offsets 3'd4
`define Rst_Err_Cnts 3'd5
 
// External FIFO Read Function codes
`define        RNoOp 4'd0
`define        Rd_FF 4'd1
`define        RT_FF 4'd2
`define    SET_MK_FF 4'd3
`define    RST_MK_FF 4'd4
`define Rdbk_Offsets 4'd5
`define  Rd_Err_Cnts 4'd6
`define     Flush_FF 4'd7
`define    Read_MHVF 4'd8
`define    Read_MHCF 4'd8 //Alternate name for VME Command Processor module
 
// State definitions for External FIFO Write controller
`define         FFW_Rst 5'h00
`define    FFW_Rst_Mark 5'h01
`define        Set_FWFT 5'h02
`define         MRst_St 5'h03
`define       Hold_FWFT 5'h04
`define       MRst_Done 5'h05
`define        FFW_Idle 5'h06
`define         PRst_St 5'h07
`define       PRst_Done 5'h08
`define       Input_Rdy 5'h09
`define         Enc_BOD 5'h0A
`define        Load_BOD 5'h0B
`define       W_Valdat1 5'h0C
`define        Write_FF 5'h0D
`define         Wrt_Err 5'h0E
`define       W_Valdat2 5'h0F
`define    Load_Offsets 5'h10
`define    Wrt_Off_to_1 5'h11
`define    Wrt_Off_to_2 5'h12
`define        Prg_Done 5'h13
`define  Rst_Err_Cnt_St 5'h14

// OFFSET definitions
`define       Hi_Full_Off 5'b00001
`define       Lo_Full_Off 5'b00011
`define       Hi_Empt_Off 5'b00111
`define       Lo_Empt_Off 5'b01111
`define Hi_Un_Cor_Err_Cnt 5'b10001
`define Lo_Un_Cor_Err_Cnt 5'b10011
`define    Hi_Cor_Err_Cnt 5'b10111
`define    Lo_Cor_Err_Cnt 5'b11111

// State definitions for External FIFO Read controller
`define      FFR_Idle 5'h00
`define      RST_Mark 5'h01
`define      Set_Mark 5'h02
`define         Pause 5'h03
`define Wait_for_Read 5'h04
`define       Read_FF 5'h05
`define       ReTrans 5'h06
`define   ReTrans_Err 5'h07
`define     FF_MT_Err 5'h08
`define     FF_MK_Err 5'h09
`define     FF_Rd_Err 5'h0A
`define        Rd_Off 5'h0B
`define    Pause_Off1 5'h0C
`define    Rd_Off_Upd 5'h0D
`define    Pause_Off2 5'h0E
`define    Update_Off 5'h0F
`define     W4Capture 5'h10
`define  FF_Snd_Data1 5'h11
`define  Send_Offsets 5'h12
`define      Rbk_Done 5'h13
`define  FF_Snd_Data2 5'h14
`define Send_Err_Cnts 5'h15
`define     Flush_BOD 5'h16
`define       W4Vldt1 5'h17
`define      Drop_Wrd 5'h18
`define       W4Vldt2 5'h19
`define    Flush_Done 5'h1A
`define      PoP_MHVF 5'h1B
`define     MHVF_Done 5'h1C

// External FIFO Read Timeout
`define    Ex_FF_Rd_TmOut 12'hFFF


////////////////////////////////////////////////////////////////////////////////////////////////////////
// -------------------------------------------------------------------------------------------------- //
// ================================= JTAG Interface Module ========================================== //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////
//                                               //
// JTAG Interface state machine                  //
//                                               //
///////////////////////////////////////////////////

//Commands for JTAG Interface (JI_CMD[2:0])
`define JI_NoOp    3'b000
`define JI_Instr   3'b001
`define JI_Data    3'b010
`define JI_Rst_Idl 3'b011
`define JI_NoOp2   3'b100
`define JI_I_stp   3'b101
`define JI_D_stp   3'b110
`define JI_Rst     3'b111

//Mux selection options for JTAG Interface input (JI_LOAD)
`define Ld_I_Hdr     4'h0
`define Ld_D_Hdr     4'h1
`define Ld_I_Dat     4'h2
`define Ld_D_Dat     4'h3
`define Ld_N_Dat     4'h4
`define Ld_Tlr       4'h5
`define Ld_R_Hdr     4'h6
`define JI_Bit_Shift 4'h8

// State definitions for JTAG Interface FSM (JI_ST)
`define JI_Idle      4'h0
`define JI_Ld_I_Hdr  4'h1
`define JI_Ld_D_Hdr  4'h2
`define Snd_H_Bits   4'h3
`define JI_Ld_I_Dat  4'h4
`define JI_Ld_D_Dat  4'h5
`define Snd_D_Bits   4'h6
`define JI_Nxt_Wrd   4'h7
`define JI_Ld_N_Dat  4'h8
`define JI_Ld_Tlr    4'h9
`define Snd_T_Bits   4'hA
`define JI_Ld_R_Hdr  4'hB
`define Snd_R_Bits   4'hC
`define JI_Cmd_Dn    4'hF

////////////////////////////////////////////////////////////////////////////////////////////////////////
// -------------------------------------------------------------------------------------------------- //
// ================================= JTAG Control Module ============================================ //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////
//                                               //
// JTAG Control state machine                    //
//                                               //
///////////////////////////////////////////////////
`define JC_Idle      6'h00
`define JC_Ld_Base   6'h01
`define JC_Wrt_Mode  6'h02
`define JC_Rd_Mode   6'h03
`define JC_Init      6'h04
`define JC_Start     6'h05
`define JC_Ld_PInt   6'h06
`define JC_W2Poll    6'h07
`define JC_Tst_Stat  6'h08
`define JC_Ld_Loop   6'h09
`define JC_Tst_Cntr  6'h0A
`define JC_Ld_Lp_Cntr 6'h0B
`define JC_Tst_Done  6'h0C
`define JC_Ck_FF     6'h0D
`define JC_Ld_IBD    6'h0E
`define JC_Nxt_Dat1  6'h0F
`define JC_Ld_Ver1   6'h10
`define JC_Nxt_Dat4  6'h11
`define JC_Ld_Msk1   6'h12
`define JC_Send      6'h13
`define JC_Rbk_Vld1  6'h14
`define JC_Cmp       6'h15
`define JC_Nxt_Dat2  6'h16
`define JC_Ld_Data   6'h17
`define JC_Nxt_Dat3  6'h18
`define JC_Ld_Ver2   6'h19
`define JC_Nxt_Dat5  6'h1A
`define JC_Ld_Msk2   6'h1B
`define JC_Nxt_Rdy   6'h1C
`define JC_Pause     6'h1D
`define JC_Rbk_Vld2  6'h1E
`define JC_Fin_Cmp   6'h1F
`define JC_Nxt_Instr 6'h20
`define JC_Latnc     6'h21
`define JC_Rd_Latnc  6'h22
`define JC_Cmd_Cpltd 6'h23
`define JC_Flush_FF  6'h2C
`define JC_Instr_Err 6'h2D
`define JC_Clr_Ierr  6'h2E
`define JC_Cmd_Err   6'h2F


//PROM instructions
`define null_wrd       16'h0000
`define ispen          16'h00e8
`define poll           16'h00e3
`define conld          16'h00f0
`define config_        16'h00ee
`define idcode         16'h00fe
`define ISC_PROGRAM    16'h00ea
`define ISC_ADDR_SHIFT 16'h00eb
`define ISC_ERASE      16'h00ec
`define ISC_DATA_SHIFT 16'h00ed
`define XSC_READ_PROT  16'h0004
`define XSC_DATA_UC    16'h0006
`define XSC_DATA_CC    16'h0007
`define XSC_DATA_DONE  16'h0009
`define XSC_DATA_CCB   16'h000c
`define XSC_DATA_SUCR  16'h000e
`define XSC_READ       16'h00ef
`define XSC_DATA_BTC   16'h00f2
`define XSC_WRT_PROT   16'h00f7
`define XSC_UNLOCK     16'haa55
`define bypass         16'hffff


// JTAG Control Program Instruction OpCode definitions 
`define JC_ShI_Imd         6'h00   // Shift Instruction reg. with immediate data
`define JC_ShI_Imd_rbk     6'h01   // Shift Instruction reg. with immediate data and readback
`define JC_ShI_Imd_ver_Imd 6'h02   // Shift Instruction reg. with immediate data and verify with immediate
`define JC_ShI_Imd_vermsk_Imd 6'h03   // Shift Instruction reg. with immediate data and verify with mask from immediate
`define JC_ShI_Imd_stpupdt 6'h0E   // Shift Instruction reg. with immediate data and stop at 'update' TAP state
`define JC_ShDZ            6'h10   // Shift Data reg. with zero's
`define JC_ShDZrbk         6'h11   // Shift Data reg. with zero's and readback
`define JC_ShDZver_Imd     6'h12   // Shift Data reg. with zero's and verify with immediate
`define JC_ShDZverff       6'h13   // Shift Data reg. with zero's and verify with FIFO data
`define JC_ShD_Imd         6'h14   // Shift Data reg. with immediate data
`define JC_ShD_Imd_rbk     6'h15   // Shift Data reg. with immediate data and readback
`define JC_ShD_Imd_ver_Imd 6'h16   // Shift Data reg. with immediate data and verify with immediate
`define JC_ShD_Imd_vermsk_Imd 6'h17   // Shift Data reg. with immediate data and verify with mask from immediate
`define JC_ShDff           6'h18   // Shift Data reg. with FIFO data
`define JC_ShDffrbk        6'h19   // Shift Data reg. with FIFO data and readback
`define JC_ShDffverff      6'h1B   // Shift Data reg. with FIFO data and verify with FIFO data
`define JC_ShDffvermskff   6'h1C   // Shift Data reg. with FIFO data and verify with mask from FIFO data
`define JC_ShDZstpupdt     6'h1D   // Shift Data reg. with zero's and stop at 'update' TAP state
`define JC_ShD_Imd_stpupdt 6'h1E   // Shift Data reg. with immediate data and stop at 'update' TAP state
`define JC_ShDffstpupdt    6'h1F   // Shift Data reg. with FIFO data and stop at 'update' TAP state
`define JC_SetPollInt      6'h20   // Set Polling Interval for checking PROM status
`define JC_Wait2Poll       6'h21   // Wait for Poll interval time before polling
`define JC_TstatLp_Imd     6'h22   // Test Status and if 'busy' loop to immediate address
`define JC_TcntrLp_Imd     6'h23   // Test loop counter and loop to immediate address if not zero
`define JC_TDone           6'h24   // Test 'Done' bit for succesfull completion
`define JC_LdLpCntr_Imd    6'h25   // Load loop counter with immediate address
`define JC_Cont_Data       6'h30   // Continued data don't change instruction
`define JC_RstIdl_TAP      6'h3D   // Goto TAP Idle state via Reset
`define JC_Rst_TAP         6'h3E   // Goto TAP Reset state
`define JC_End_Prg         6'h3F   // End of Program go back to idle

// Default Polling intervals
`ifdef Simulation
   `define Poll_Dflt  16'h0015
   `define Poll_Shrt  16'h000A
   `define Poll_Long  16'h0020
`else
   `define Poll_Dflt  16'h3D09    // 2 mSec default polling interval
   `define Poll_Shrt  16'h0075    // 15 uSec Short polling interval
   `define Poll_Long  16'h9896    // 5 mSec Long polling interval
`endif
// Polling status definitions
`define JC_PROM_Busy 8'h32     // busy programming
`define JC_PROM_Done 8'h36     // completed individual programming operation

// JTAG Controller Commands (JC_CMD[2:0])
`define  JCMD_NoOp  3'b000
`define  JCMD_Write 3'b001
`define  JCMD_Read  3'b010
`define  JCMD_Exec  3'b011
`define  JCMD_Abrt  3'b100

// Routines in Program memory
`define  JC_Rd_DevID   4'h0
`define  JC_Rd_UC      4'h1
`define  JC_Rd_CC      4'h2
`define  JC_Rdbk_PROM  4'h3
`define  JC_Erase      4'h4
`define  JC_Program    4'h5
`define  JC_Reload     4'h6
`define  JC_Verify     4'h7
`define  JC_Chk_Conn   4'h8
`define  JC_Custom_Rtn 4'hF
// Base Address for Routines in Program memory
`define  JC_Rd_DevID_Base  9'h0D0
`define  JC_Rd_UC_Base     9'h0E0
`define  JC_Rd_CC_Base     9'h0F0
`define  JC_Rdbk_PROM_Base 9'h100
`define  JC_Erase_Base     9'h000
`define  JC_Program_Base   9'h020
`define  JC_Reload_Base    9'h0B0
`define  JC_Verify_Base    9'h090
`define  JC_Chk_Conn_Base  9'h120

////////////////////////////////////////////////////////////////////////////////////////////////////////
// -------------------------------------------------------------------------------------------------- //
// ========================= JTAG Command Processor Module ========================================== //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////
//                                               //
// JTAG Command Processor state machine          //
//                                               //
///////////////////////////////////////////////////
`define JCP_Idle       4'h0
`define JCP_Get_Funct  4'h1
`define JCP_Get_MAC    4'h2
`define JCP_Wrt_Cmd    4'h3
`define JCP_Abrt_Cmd   4'h4
`define JCP_Get_Frame  4'h5
`define JCP_Dmy_Get    4'h6
`define JCP_SRL2FF     4'h7
`define JCP_Snd_Data   4'h8
`define JCP_Snd_Ack    4'h9
`define JCP_W4Read     4'hA
`define JCP_Rel_Snd    4'hB
`define JCP_Snd_Err    4'hC
`define JCP_Clear      4'hD
`define JCP_Rdy4Shtdwn 4'hF

///////////////////////////////////////////////////
//                                               //
// To JTAG Control Module state machine          //
//                                               //
///////////////////////////////////////////////////
`define TJC_Idle       5'h00
`define TJC_Wrt_Mode   5'h01
`define TJC_Wrt_Data   5'h02
`define TJC_Rd_Rdy     5'h03
`define TJC_Rd_Mode    5'h04
`define TJC_Rd_Fin     5'h05
`define TJC_Abrt_Mode  5'h06
`define TJC_Abrt_Fin   5'h07
`define TJC_Read_Rtn   5'h08
`define TJC_Ld_Rtn     5'h09
`define TJC_FF2SRL     5'h0A
`define TJC_Exec       5'h0B
`define TJC_W4Cmplt    5'h0C
`define TJC_Snd_JAck   5'h0D
`define TJC_Snd_JRtn   5'h0E
`define TJC_Rel_Snd    5'h0F
`define TJC_Snd_Err    5'h10
`define TJC_Cmplt      5'h11
`define TJC_Rdy4Shtdwn 5'h12

// Sources of errors, data, and ACK in JTAG Controller
`define JT_No_Req   3'h0  //JTAG No Requests
`define JCP_Data    3'h1  //JTAG Command Processor Send Data
`define JCP_Ack     3'h2  //JTAG Command Processor Acknowledgments
`define JCP_Err     3'h3  //JTAG Command Processor Errors
`define TJC_JAck    3'h4  //To JTAG Control Acknowledgments
`define TJC_JRtn    3'h5  //To JTAG Control Send Data
`define TJC_Err     3'h6  //To JTAG Control Errors
`define MonFF_Err   3'h7  //Monitor FIFO Errors

///////////////////////////////////////////////////
//                                               //
// Monitor FIFO state machine                    //
//                                               //
///////////////////////////////////////////////////
`define MFF_Idle       2'h0
`define MFF_Snd_Err    2'h1
`define MFF_Done       2'h2
`define MFF_Rdy4Shtdwn 2'h3

////////////////////////////////////////////////////////////////////////////////////////////////////////
// -------------------------------------------------------------------------------------------------- //
// ================================= VME Modules ==================================================== //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////
//                                               //
// VME Command Processor Controller              //
//                                               //
///////////////////////////////////////////////////

// State definitions for VME Command Processor FSM (VCP_ST)
`define  VCP_Idle        4'h0
`define  VCP_Get_Funct   4'h1
`define  VCP_Get_MAC     4'h2
`define  VCP_isAF        4'h3
`define  VCP_Ld_BOD      4'h4
`define  VCP_Get_Frame   4'h5
`define  VCP_SRL2FF      4'h6
`define  VCP_Snd_Warn    4'h7
`define  VCP_isAMT       4'h8
`define  VCP_Dmy_Get     4'h9
`define  VCP_Snd_Err     4'hA
`define  VCP_Rdy4Shtdwn  4'hF


////////////////////////////////////////////////////////
//                                                    //
// External FIFO / VME Direct Selection State Machine //
//                                                    //
////////////////////////////////////////////////////////

// State definitions for EXFF/VDIR Selection FSM (EXD_ST)
`define  ExD_Idle        2'h0
`define  ExD_Dir_Cmds    2'h1
`define  ExD_ExFF_Wait   2'h2
`define  ExD_ExFF_Cmds   2'h3

///////////////////////////////////////////////////
//                                               //
// VME CP FIFO Read Controller                   //
//                                               //
///////////////////////////////////////////////////

// State definitions for External FIFO Read controller
`define       VCPF_Idle 4'h0
`define      VCPF_Pause 4'h1
`define       VCPF_W4Rd 4'h2
`define      VCPF_Rd_FF 4'h3
`define     VCPF_MT_Err 4'h4
`define     VCPF_Rd_Err 4'h5
`define  VCPF_Flush_BOD 4'h6
`define    VCPF_W4Vldt1 4'h7
`define   VCPF_Drop_Wrd 4'h8
`define    VCPF_W4Vldt2 4'h9
`define VCPF_Flush_Done 4'hA
`define     VCPF_PoP_MH 4'hB
`define    VCPF_MH_Done 4'hC

// External FIFO Read Timeout
`define VCP_FF_Rd_TmOut 12'h139
///////////////////////////////////////////////////
//                                               //
// VME Processors                                //
//                                               //
///////////////////////////////////////////////////

// VME Power up sequenc VME_Pwr_Up_FSM
`define Vstrt_hold 3'd0
`define W40ms      3'd1
`define Cap_BG3    3'd2
`define V_Ena_Outs 3'd3
`define VME_Rdy    3'd4

// VME Delay types
`define     No_Dly   3'd0  // No delay; VME transfer.
`define     D4nsX16  3'd1  // 4ns Res. 16 bit range
`define     D16nsX16 3'd2  // 16ns Res. 16 bit range
`define     D16usX16 3'd3  // 16us Res. 16 bit range
`define     D4nsX32  3'd4  // 4ns Res. 32 bit range
`define     D16nsX32 3'd5  // 16ns Res. 32 bit range
`define     D16usX32 3'd6  // 16us Res. 32 bit range

// VME Data Transfer Type
`define     SNGL  2'b00    // Single transfer (SNGL)
`define     BLOCK 2'b01    // Block transfer (BLOCK)
`define     RMW   2'b10    // Read-Modify-Write transfer (RMW)
`define     UNALG 2'b11    // Unaligned transfer (UNALG)

// VME Data Transfer Size
`define     Byte  2'b00
`define     Word  2'b01
`define     LWord 2'b10
`define     Eight 2'b11

// VME Address Transfer Size
`define     No_Addr  3'h0
`define     ASZ_A16  3'd1
`define     ASZ_A24  3'd2
`define     ASZ_A32  3'd3
`define     ASZ_A40  3'd4
`define     ASZ_A64  3'd5


//Address modifer encoding
//{ADDR_SZ,ACCS_TYP}
// 1-5,UD,CR,LCK,SUP,PRG
`define Usr_AM              {3'hx,5'b1xxxx}  //AM = user defined (UD_AM)
`define CR_CSR_AM           {3'hx,5'b01xxx}  //AM = 2F
//
`define A16LCK_AM       {`ASZ_A16,5'b001xx}  //AM = 2C
`define A16SUP_AM       {`ASZ_A16,5'b0001x}  //AM = 2D
`define A16non_AM       {`ASZ_A16,5'b0000x}  //AM = 29
//
`define A24LCK_AM       {`ASZ_A24,5'b001xx}  //AM = 32
`define A24SUP_AM       {`ASZ_A24,5'b0001x}  //AM = 3C-3F
`define A24non_AM       {`ASZ_A24,5'b0000x}  //AM = 38-3B
//
`define A32LCK_AM       {`ASZ_A32,5'b001xx}  //AM = 05
`define A32SUP_AM       {`ASZ_A32,5'b0001x}  //AM = 0C-0F
`define A32non_AM       {`ASZ_A32,5'b0000x}  //AM = 08-0B
//
`define A40LCK_AM       {`ASZ_A40,5'b001xx}  //AM = 35
`define A40_AM          {`ASZ_A40,5'b000xx}  //AM = 34,37
//
`define A64LCK_AM       {`ASZ_A64,5'b001xx}  //AM = 04
`define A64_AM          {`ASZ_A64,5'b000xx}  //AM = 00,01,03

// Bus Arbiter Type Definitions
`define    No_Arb  2'b00  //no bus arbitration
`define    SGL     2'b01  //Single Level Arbiter
`define    PRI     2'b10  //Priority Arbiter
`define    RRS     2'b11  //Round Robin Select Arbiter

// Bus Arbiter Priority Select FSM states
`define Mon_BR3    2'b00
`define BG3        2'b01
`define BG_Err_S   2'b10

// Bus Arbiter Priority Select FSM states
`define Mon_BR     3'b000
`define BG_lvl3    3'b001
`define BG_lvl2    3'b010
`define BG_lvl1    3'b011
`define BG_lvl0    3'b100
`define BG_Err_P   3'b101

// Bus Arbiter Round Robin Select FSM states
`define       RRS3 3'b000
`define       RRS2 3'b001
`define       RRS1 3'b010
`define       RRS0 3'b011
`define BG_Err_RR3 3'b100
`define BG_Err_RR2 3'b101
`define BG_Err_RR1 3'b110
`define BG_Err_RR0 3'b111

// VME input control codes
`define     VME_idle     3'd0
`define     VME_CMD_FF   3'd1
`define     VME_CNFG_FF  3'd2
`define     VME_CMD_DIR  3'd3
`define     VME_CNFG_DIR 3'd4
// VME output control codes
`define     VME_NoOp    3'd0
`define     VME_Has_Bus 3'd1

`define     PRBS_seed 21'h1B49C7

// State definitions for VME_MASTER_FSM
`define     M_idle       5'h00
`define     Capture1     5'h01
`define     Req_DTB      5'h02
`define     R1           5'h03
`define     No_Exe       5'h04
`define     Wait_4_DTB   5'h09
`define     Start        5'h0A
`define     Add_Phase    5'h0B
`define Wait_4_DTACK_Rel 5'h0C
`define     Sngl_Block   5'h0D
`define     RMW_1        5'h0E
`define     RMW_Read     5'h0F
`define     RMW_2        5'h10
`define     RMW_Write    5'h11
`define     M_Read       5'h12
`define     M_Write      5'h13
`define     Cycle_Done   5'h14
`define     Next_Cycle   5'h15
`define     Xfer_Done    5'h16
`define     Load_Delay   5'h17
`define     Delay        5'h18
`define     Ld_Err_Typ   5'h19
`define     Bus_Error    5'h1A

// State definitions for VME control Write state machine (VME_WRT_CTRL_FSM)
`define      VW_idle     6'h00
`define    Trns_Pkt_Inf  6'h01
`define      Rd_FIFO     6'h02
`define      Rd_units    6'h03
`define      Ld_units    6'h04
`define      Rd_type     6'h05
`define      Ld_type     6'h06
`define      Rd_UAM      6'h07
`define      Rd_Wrd_1a   6'h08
`define      Rd_Wrd_1b   6'h09
`define      Rd_Wrd_2b   6'h0A
`define      Rd_Wrd_1c   6'h0B
`define      Rd_Wrd_2c   6'h0C
`define      Rd_Wrd_3c   6'h0D
`define      Rd_Wrd_1d   6'h0E
`define      Rd_Wrd_2d   6'h0F
`define      Rd_Wrd_3d   6'h10
`define      Rd_Wrd_4d   6'h11
`define     Ld_Add_Pause 6'h12
`define      Rd_Dcnt     6'h13
`define      Ld_Dcnt     6'h14
`define      Continue    6'h15
`define      Rd_Dat_1a   6'h16
`define      Rd_Dat_1b   6'h17
`define      Rd_Dat_2b   6'h18
`define      Rd_Dat_1d   6'h19
`define      Rd_Dat_2d   6'h1A
`define      Rd_Dat_3d   6'h1B
`define      Rd_Dat_4d   6'h1C
`define     Ld_Dat_Pause 6'h1D
`define      VPause      6'h1E
`define      Execute_Blk 6'h1F
`define      Dec_Dcnt    6'h20
`define      Execute     6'h21
`define      Dec_Units   6'h22
`define    Wait4VRd_Idle 6'h23
`define      Send_Data   6'h24
`define     Unkn_Addr_Sz 6'h25
`define     Unkn_Dly_Typ 6'h26
`define      Incomp_Opt  6'h27
`define    Rpt_Vctrl_Err 6'h28
`define    Clr_Mstr_Err1 6'h29
`define    Clr_Mstr_Err2 6'h2A
`define        Flush2BOD 6'h2B
`define     Rd_Err_Units 6'h2C
`define   Rd_Err_CtrlWrd 6'h2D
`define      Rd_Err_Addr 6'h2E
`define      Rd_Err_Dcnt 6'h2F
`define      Rd_Err_Data 6'h30
`define      VW_Hnd_Shk  6'h31
`define      MT_Err_FIFO 6'h32
`define   VW_Prep4Shtdwn 6'h3E
`define    VW_Rdy4Shtdwn 6'h3F


// State definitions for VME control Read  to FIFO write  (VME_RD_FFWRT_CTRL_FSM)
`define     VRd_Idle    5'h00
`define     Ld_Drbk     5'h01
`define     Ackn        5'h02
`define     Push8       5'h03
`define     Push16      5'h04
`define     Push32A     5'h05
`define     Push32B     5'h06
`define     Push64A     5'h07
`define     Push64B     5'h08
`define     Push64C     5'h09
`define     Push64D     5'h0A
`define     Push_MER    5'h0B
`define     Push_VState 5'h0C
`define     Rd_Cmplt    5'h0D
`define     Dummy8      5'h0E
`define     Dummy16     5'h0F
`define     Dummy32A    5'h10
`define     Dummy32B    5'h11
`define     Dummy64A    5'h12
`define     Dummy64B    5'h13
`define     Dummy64C    5'h14
`define     Dummy64D    5'h15
`define     Push_EOP    5'h16
`define   Data_Pkt_Sent 5'h17
`define     Push_N_SOP  5'h18
`define     Push_SOP    5'h19
`define     Push_N_SOP2 5'h1A
`define     Ackn_No_Wrt 5'h1B

// State definitions for VME control Read  from FIFO: VFFR_ST  (VME_RD_FFRD_CTRL_FSM)
`define  VR_Idle        4'h0
`define  VR_Req_Bus     4'h1
`define  VR_Pop_SOP     4'h2
`define  VR_Cap_Pkt_Typ 4'h3
`define  VR_Ini_Stat    4'h4
`define  VR_MAC         4'h5
`define  VR_Pop_VFF     4'h6
`define  VR_Fin_Stat    4'h7
`define  VR_Snd_Pkt     4'h8
`define  VR_Hnd_Shk     4'h9
`define  VR_Flush       4'hA
`define  VR_Rel_Bus     4'hB
`define  VR_Err_SOP     4'hC
`define  VR_Err_Typ     4'hD
`define  VR_Err_TMO     4'hE
`define  VR_Rpt_VFF_Err 4'hF

// State definitions for Transmit Bus controller
`define     TB_Free     4'h0
`define     VME_BG      4'h1
`define     VCP_BG      4'h2
`define     ETH_RCV_BG  4'h3
`define     EX_FIFO_BG  4'h4
`define     JTAG_BG     4'h5
`define     CNFG_BG     4'h6
`define     FLASH_BG    4'h7
`define     SS_BG       4'h8

//Bus Request codes for Command Processor
`define     CP_NoOp       4'h0
`define     Rd_Eth_FIFO   4'h1
`define     Lpback        4'h2
`define     Rd_RX_STAT    4'h3
`define     Rd_Ext_FIFO   4'h4
`define     Direct_VME    4'h5
`define     Spont_Rpt     4'h6
`define     CP_Cnfg_Store 4'h7
`define     Rd_Curr_Cnfg  4'h8

//Bus Request codes for VME Write Controller
`define     VMEW_NoOp     2'h0
`define     VME_fr_FIFO   2'h1
`define     VME_cnfg_save 2'h2
//`define                 2'h3

//Bus Request codes for VME Read Controller
`define     VMER_NoOp     1'b0
`define     VME_Output    1'b1

//Bus Request codes for Flash Controller
`define     FL_NoOp       1'b0
`define     FL_Output     1'b1

//Bus Request codes for Configuration Controller
`define     Cnfg_NoOp     2'h0
`define     Cnfg_Store    2'h1
`define     Cnfg_Xmit     2'h2

//FIFO Usage definitions
`define     FFNONE     2'd0
`define     VCMD       2'd1
`define     VCNFG      2'd2
`define     TSTDAT     2'd3



// Sources of errors and data in VME master
`define V_No_Req      4'h0  //No Requests
`define V_Mstr_Err    4'h1  //VME Master Error
`define V_IH_Err      4'h2  //VME Interrupt Handler Error
`define V_Ctrl_Err    4'h3  //VME Control Error
`define V_Arb_Err     4'h4  //VME Arbiter Error
`define V_Mstr_Dav    4'h5  //VME Master Data Available
`define V_IH_Dav      4'h6  //VME Interrupt Handler Data Available
`define V_IH_Warn     4'h7  //VME Interrupt Handler Warning
`define V_VRbk_Err    4'h8  //VME Readback/Read FIFO Error

// Packet type definitions for VME Controller Read FIFO
`define   VC_Norm_Pkt       3'd0  //Normal data packet
`define   VC_INFO_Pkt       3'd1  //Informational packet
`define   VC_WARN_Pkt       3'd2  //Warning packet
`define   VC_ERR_Pkt        3'd3  //Error packet
`define   VC_INTR_Pkt       3'd4  //Interrupt Status/ID packet
`define   VC_INFO_NoMAC_Pkt 3'd5  //Informational packet not associated with the packet in progress
`define   VC_WARN_NoMAC_Pkt 3'd6  //Warning packet not associated with the packet in progress
`define   VC_ERR_NoMAC_Pkt  3'd7  //Error packet not associated with the packet in progress

// State definitions for Interrupt Handler Module FSM
`define IH_Idle       4'h0
`define IH_Cap_IRQ    4'h1
`define IH_Req_DTB    4'h2
`define IH_Wait4DTB   4'h3
`define IH_Start      4'h4
`define IACK_Cycle    4'h5
`define Status_ID     4'h6
`define IACK_Done     4'h7
`define IH_Ld_Err     4'h8
`define IH_Bus_Err    4'h9
`define IH_Rel_BR     4'hA
`define Mask_Intr     4'hB
`define IH_Ld_Warn    4'hC
`define IH_Warn       4'hD

// Time out for releasing Interrupt Request lines.
`define IACK_Time_Out  7'h7F      // 500 ns for ROAK interrupters (ROAR interrupters not supported)



////////////////////////////////////////////////////////////////////////////////////////////////////////
// -------------------------------------------------------------------------------------------------- //
// ================================= Error Checking and Correcting code definitiions ================ //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

// Columns of Parity part of Generator Matrix for ECC code Golay(24,12)
`define  BI1   12'h7FF
`define  BI2   12'hEE2
`define  BI3   12'hDC5
`define  BI4   12'hB8B
`define  BI5   12'hF16
`define  BI6   12'hE2D
`define  BI7   12'hC5B
`define  BI8   12'h8B7
`define  BI9   12'h96E
`define  BI10  12'hADC
`define  BI11  12'hDB8
`define  BI12  12'hB71

// Rows of Parity part of Generator Matrix for ECC code Golay(24,12)
`define  BR1   12'h7FF
`define  BR2   12'hEE2
`define  BR3   12'hDC5
`define  BR4   12'hB8B
`define  BR5   12'hF16
`define  BR6   12'hE2D
`define  BR7   12'hC5B
`define  BR8   12'h8B7
`define  BR9   12'h96E
`define  BR10  12'hADC
`define  BR11  12'hDB8
`define  BR12  12'hB71

// Rows of Identity matrix
`define  IDR1   12'h800
`define  IDR2   12'h400
`define  IDR3   12'h200
`define  IDR4   12'h100
`define  IDR5   12'h080
`define  IDR6   12'h040
`define  IDR7   12'h020
`define  IDR8   12'h010
`define  IDR9   12'h008
`define  IDR10  12'h004
`define  IDR11  12'h002
`define  IDR12  12'h001




////////////////////////////////////////////////////////////////////////////////////////
//  The following (from here to end) are used only for the Slave version.
////////////////////////////////////////////////////////////////////////////////////////
`ifdef Slave

   // State definitions for Interrupter Module FSM
   `define Intr_Idle    3'h0
   `define Set_IRQ      3'h1
   `define Drv_IACKOUT  3'h2
   `define Rel_IACKOUT  3'h3
   `define Chk_SZ       3'h4
   `define Send_Status  3'h5
   `define Rel_IRQ      3'h6
   `define I_Bus_Err    3'h7

   // Masks for address modes
   `define A16_Mask 64'h00000000000007FF
   `define A24_Mask 64'h000000000007FFFF
   `define A32_Mask 64'h0000000007FFFFFF
   `define A40_Mask 64'h00000007FFFFFFFF
   `define A64_Mask 64'h07FFFFFFFFFFFFFF
   // Slave board device addresses
   `define MEMA16_a  64'h00000000000000XX
   `define MEMA16_b  64'h00000000000001XX
   `define MEMA16_c  64'h00000000000002XX
   `define MEMA16_d  64'h00000000000003XX
   `define MEMA16_e  64'h00000000000004XX
   `define MEMA16_f  64'h00000000000005XX
   `define MEMA16_g  64'h00000000000006XX
   `define MEMA16_h  64'h00000000000007XX
   `define MEMA32_a  64'h00000000000008XX
   `define MEMA32_b  64'h00000000000009XX
   `define MEMA32_c  64'h0000000000000AXX
   `define MEMA32_d  64'h0000000000000BXX
   `define MEMA32_e  64'h0000000000000CXX
   `define MEMA32_f  64'h0000000000000DXX
   `define MEMA32_g  64'h0000000000000EXX
   `define MEMA32_h  64'h0000000000000FXX
   `define MEMB8     64'h0000000000001XXX
   `define MEMB64    64'h0000000000002XXX
   `define FIFO_a    64'h0000000000003000
   `define FIFO_b    64'h0000000000003002
   `define FIFO_c    64'h0000000000003004
   `define FIFO_d    64'h0000000000003006
   `define Rnd_Rbn   64'h0000000000003008
   // Slave board device definition codes
   `define No_Such_Dev 4'h0
   `define MEMA16_Dev  4'h1
   `define MEMA32_Dev  4'h2
   `define MEMB8_Dev   4'h3
   `define MEMB64_Dev  4'h4
   `define FIFO_Dev    4'h5
   `define Rnd_Rbn_Dev 4'h6

   // Data Transfer Types (DTT)
   //
   //   0    unsupported combination           UnSup
   //   1    D08      Byte(0)                  D08_B0
   //   2    D08      Byte(1)                  D08_B1
   //   3    D08      Byte(2)                  D08_B2
   //   4    D08      Byte(3)                  D08_B3
   //   5    D16      Byte(0-1)                D16_B01
   //   6    D16      Byte(2-3)                D16_B23
   //   7    D32      Byte(0-3)                D32_B03
   //   8    MD32     Byte(0-3)                MD32_B03
   //   9    MBLT(D64)Byte(0-7)                D64_B07
   //   A    D32:UAT  Byte(0-2)                UAT_B02
   //   B    D32:UAT  Byte(1-3)                UAT_B13
   //   C    D32:UAT  Byte(1-2)                UAT_B12
   `define UnSup     4'h0
   `define D08_B0    4'h1
   `define D08_B1    4'h2
   `define D08_B2    4'h3
   `define D08_B3    4'h4
   `define D16_B01   4'h5
   `define D16_B23   4'h6
   `define D32_B03   4'h7
   `define MD32_B03  4'h8
   `define D64_B07   4'h9
   `define UAT_B02   4'hA
   `define UAT_B13   4'hB
   `define UAT_B12   4'hC


   // State definitions for Slave Response FSM
   `define  Slv_Idle     5'h00
   `define  Cap_AM       5'h01
   `define  Dcd_Addr     5'h02
   `define  Select_Dev   5'h03
   `define  AD_Hndshk    5'h04
   `define  W_4_DS_1     5'h05
   `define  W_4_DS_2     5'h06
   `define  Rpt_BERR     5'h07
   `define  DTACK_1      5'h08
   `define  DTACK_2      5'h09
   `define  Get_DTT      5'h0A
   `define  Ld_A0        5'h0B
   `define  Cap_Dat      5'h0C
   `define  W_4_Status   5'h0D
   `define  W_4_ValDat   5'h0E
   `define  DTACK_3      5'h0F
   `define  W_4_DS_3     5'h10
   `define  Inc_Addr     5'h11
   `define  Clr_All      5'h12


   // State definitions for Memory FSM
   `define  Mem_Idle     3'h0
   `define  Chk_Sz_Wrt   3'h1
   `define  Wrt_Ackn     3'h2
   `define  Parity_Chk   3'h3
   `define  Data_Valid   3'h4
   `define  Dat_Err      3'h5

`endif
