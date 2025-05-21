/*-----------------------------------------------------------------
File name     : run.f
Description   : lab01_data simulator run template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
              : Set $UVMHOME to install directory of UVM library
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
// 64 bit option for AWS labs
-64

-uvmhome /home/Tools/cadence/XCELIUM2403/tools/methodology/UVM/CDNS-1.1d

// include directories
-incdir ../sv

// compile files
../sv/yapp_pkg.sv
top.sv
// +UVM_TESTNAME=short_packet_test
// +UVM_TESTNAME=set_config_test
// +UVM_TESTNAME=incr_payload_test
+UVM_TESTNAME=exhaustive_seq_test
+UVM_VERBOSITY=UVM_LOW
