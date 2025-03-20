/*-----------------------------------------------------------------
File name     : packet_data.sv
Developers    : Brian Dickinson
Created       : 01/08/19
Description   : lab1 packet data item 
Notes         : From the Cadence "Essential SystemVerilog for UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/

// Follow instructions in lab book
  
// add print and type policies here
typedef enum {ANY, SINGLE, MULTICAST, BROADCAST} ptype_t;
typedef enum {HEX, DEC, BIN} pformat_t;

// packet class
class packet;

  // add properties here
  local string name;

  rand bit [3:0] target;
       bit [3:0] source;
  rand bit [7:0] data;

  ptype_t ptype;

  // add constructor to set instance name and source by arguments and packet type

  function new(string name, int idt);
    this.name = name;
    source = 1 << idt;
    ptype  = ANY;
  endfunction

  constraint target_source_not_equal_c {(target & source) == 4'b0;}
  constraint target_not_0_c            {target != 0;}

  // constraint ptype_order_c {solve ptype before target;}
  // constraint packet_type_c {ptype == SINGLE -> { target inside {1,2,4,8}; (target & source) == 4'b0; }
  //                           ptype == MULTICAST -> { target inside {3,[5:7],[9:14]}; (target & source) == 4'b0; } 
  //                           ptype == BROADCAST -> target == 15;} 

  function string gettype();
    return ptype.name();
  endfunction

  function string getname();
    return name;
  endfunction

 // add print with policy

  function void print(input pformat_t pf = BIN);
    $display("-----------------------------------------");
    $display("NAME: %s TYPE: %s", getname(), gettype());
    case(pf)
      HEX: $display("SOURCE: %h TARGET: %h DATA: %h", source, target, data);
      DEC: $display("SOURCE: %d TARGET: %d DATA: %d", source, target, data);
      BIN: $display("SOURCE: %b TARGET: %b DATA: %b", source, target, data);
    endcase
    $display("-----------------------------------------");
  endfunction

endclass

  // single packet sub-class
class psingle extends packet;
  constraint single_c {target inside {1,2,4,8};}
  function new (string name, int idt);
    super.new(name,idt);
    ptype = SINGLE;
  endfunction
endclass

// multicast packet sub-class
class pmulticast extends packet;
  constraint multicast_c {target inside {3,[5:7],[9:14]};}
  function new (string name, int idt);
    super.new(name,idt);
    ptype = MULTICAST;
  endfunction
endclass

// broadcast packet sub-class
class pbroadcast extends packet;
  // remove basic constraint from packet parent!!
  constraint target_source_not_equal_c {}
  constraint broadcast_c {target==15;}
  function new (string name, int idt);
    super.new(name,idt);
    ptype = BROADCAST;
  endfunction
endclass