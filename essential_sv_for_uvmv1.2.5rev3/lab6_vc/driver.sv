class driver extends component_base;

    sequencer sref;
    virtual interface port_if vif;
    packet pkt;

    // constructor with name and parent arguments
    function new (string name, component_base parent);
        super.new(name, parent);
    endfunction

    task run(int runs);
        repeat (runs) begin
            sref.get_next_item(pkt);
            //$display("Driver (%s) sends packet IN @%t", pathname(), $time);
            //pkt.print();
            vif.drive_packet(pkt);
        end
    endtask

endclass