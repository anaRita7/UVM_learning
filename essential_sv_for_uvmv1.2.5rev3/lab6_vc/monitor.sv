class monitor extends component_base;

    virtual interface port_if vif;
    int portno;
    packet pkt;

    // constructor with name and parent arguments
    function new (string name, component_base parent);
        super.new(name, parent);
    endfunction

    task run();
        forever begin
            vif.collect_packet(pkt);
            $display("Port%0d Monitor (%s) captures packet IN @%t", portno, pathname(), $time);
            pkt.print();
        end
    endtask
endclass