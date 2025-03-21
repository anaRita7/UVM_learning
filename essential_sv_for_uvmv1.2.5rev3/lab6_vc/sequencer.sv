class sequencer extends component_base;

    int portno;
    int ok;

    // constructor with name and parent arguments
    function new (string name, component_base parent);
        super.new(name, parent);
    endfunction

    function void get_next_item(output packet pkt);
        psingle ps;
        pbroadcast pb;
        pmulticast pm;
        randcase
            1:begin : single_packet
                ps = new("ps", portno);
                ok = ps.randomize();
                pkt = ps;
            end
            1:begin : multicast_packet
                pm = new("pm", portno);
                ok = pm.randomize();
                pkt = pm;
            end
            1:begin : broadcast_packet
                pb = new("pb",portno);
                ok = pb.randomize();
                pkt = pb;
            end
        endcase
    endfunction

endclass