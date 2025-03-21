class packet_vc extends component_base;

    agent agt;

    function new (string name, component_base parent);
        super.new(name, parent);
        agt = new("agt", this);
    endfunction

    function void configure(virtual interface port_if vif, int portno);
        agt.drv.vif = vif;
        agt.mon.vif = vif;
        agt.seq.portno = portno;
        agt.mon.portno = portno;
    endfunction

    task run(int runs);
        fork
            agt.mon.run();
        join_none
        agt.drv.run(runs);
    endtask

endclass