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
typedef enum {UNIDED, IDED} tag_t;

// packet class
class packet;

  // add properties here
  local string name;

  rand bit [3:0] target;
       bit [3:0] source;
  rand bit [7:0] data;

  rand ptype_t ptype;

  tag_t tagmode;
  int tag;
  static int pktcount;

  // add constructor to set instance name and source by arguments and packet type

  function new(string name, int idt);
    this.name   = name;
    this.source = 1 << idt;
    this.ptype  = ANY;
    this.pktcount++;
    this.tag = this.pktcount;
  endfunction

  static function int getcount();
    return pktcount;
  endfunction

  function void post_randomize();
    if (tagmode == IDED) data = tag;
  endfunction

  constraint target_not_0_c {target != 0;}
  constraint ptype_order_c {solve ptype before target;}
  constraint packet_type_c {ptype == SINGLE -> { target inside {1,2,4,8}; (target & source) == 4'b0; }
                          ptype == MULTICAST -> { target inside {3,[5:7],[9:14]}; (target & source) == 4'b0; } 
                          ptype == BROADCAST -> target == 15;} 

  function string gettype();
    return ptype.name();
  endfunction

  function string getname();
    return this.name;
  endfunction

 // add print with policy

 function void print(input pformat_t pf = DEC);
  $display("-----------------------------------------");
  $display("NAME: %s TYPE: %s TAG: %0d pktcount: %0d TAGMODE: %s", getname(), gettype(), tag, pktcount, tagmode.name());
  case(pf)
    HEX: $display("SOURCE: %h TARGET: %h DATA: %h", this.source, this.target, this.data);
    DEC: $display("SOURCE: %d TARGET: %d DATA: %d", this.source, this.target, this.data);
    BIN: $display("SOURCE: %b TARGET: %b DATA: %b", this.source, this.target, this.data);
  endcase
  $display("-----------------------------------------");
 endfunction
 
endclass