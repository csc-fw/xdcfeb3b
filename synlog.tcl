history clear
set wid1 [get_window_id]
set wid2 [open_file F:/DCFEB/firmware/ISE_14.7/xdcfeb3a/xdcfeb3a.srr]
win_activate $wid2
run_tcl -fg F:/DCFEB/firmware/ISE_14.7/xdcfeb3a/xdcfeb3a_open_file.tcl
text_select 1682 10 1682 16
project -close F:/DCFEB/firmware/ISE_14.7/xdcfeb3a/xdcfeb3a.prj
