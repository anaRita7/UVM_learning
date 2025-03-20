class monitor extends component_base;

    // constructor with name and parent arguments
    function new (string name, component_base parent);
        super.new(name, parent);
    endfunction

    task run();
        $display("Monitor @%s",pathname());
    endtask

endclass