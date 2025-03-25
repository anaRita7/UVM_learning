/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module top;
    // import the UVM library
    import uvm_pkg::*;
    // include the UVM macros
    `include "uvm_macros.svh"

    // import the YAPP package
    import yapp_pkg::*;

    yapp_packet packet;
    int ok;

    yapp_packet copy_packet;
    yapp_packet clone_packet;

    // generate 5 random packets and use the print method
    // to display the results
    initial begin
        for (int i=0; i<5; i++) begin
            packet = new($sformatf("packet%0d",i));
            ok = packet.randomize();
            packet.print();
        end

        // experiment with the copy, clone and compare UVM method
        copy_packet = new("copy_packet");
        $display("COPY");
        copy_packet.copy(packet);
        copy_packet.print();

        $display("CLONE");
        $cast(clone_packet, packet.clone()); 
        clone_packet.print();

    end

endmodule : top
