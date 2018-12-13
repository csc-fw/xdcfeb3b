///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 14.7
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : param_xfer_vio.v
// /___/   /\     Timestamp  : Wed May 09 14:28:21 Eastern Daylight Time 2018
// \   \  /  \
//  \___\/\___\
//
// Design Name: Verilog Synthesis Wrapper
///////////////////////////////////////////////////////////////////////////////
// This wrapper is used to integrate with Project Navigator and PlanAhead

`timescale 1ns/1ps

module param_xfer_vio(
    CONTROL,
    CLK,
    ASYNC_IN,
    SYNC_OUT) /* synthesis syn_black_box syn_noprune=1 */;


inout [35 : 0] CONTROL;
input CLK;
input [19 : 0] ASYNC_IN;
output [7 : 0] SYNC_OUT;

endmodule
