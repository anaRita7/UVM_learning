class driver extends component_base;

    sequencer sref;

    // constructor with name and parent arguments
    function new (string name, component_base parent);
        super.new(name, parent);
    endfunction

    task run();
        $display("Driver @%s",pathname());
        $display("Sequencer @%s",sref.pathname());
    endtask

endclass