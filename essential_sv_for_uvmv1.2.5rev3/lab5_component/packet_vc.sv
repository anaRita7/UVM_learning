class packet_vc extends component_base;

    agent agt;

    function new (string name, component_base parent);
        super.new(name, parent);
        agt = new("agt", this);
    endfunction

    task run();
        agt.drv.run();
        agt.mon.run();
    endtask

endclass