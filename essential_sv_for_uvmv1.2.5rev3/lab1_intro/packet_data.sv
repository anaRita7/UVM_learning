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

  bit [3:0] target;
  bit [4:0] source;
  bit [7:0] data;

  ptype_t ptype;

  // add constructor to set instance name and source by arguments and packet type

  function new(string name, int idt);
    this.name   = name;
    this.source = 1 << idt;
    this.ptype  = ANY;
  endfunction

  function string gettype();
    return ptype.name();
  endfunction

  function string getname();
    return this.name;
  endfunction

 // add print with policy

 function void print(input pformat_t pf = DEC);
  $display("-----------------------------------------");
  $display("NAME: %s TYPE: %s", getname(),gettype());
  case(pf)
    HEX: $display("SOURCE: %h TARGET: %h DATA: %h", this.source, this.target, this.data);
    DEC: $display("SOURCE: %d TARGET: %d DATA: %d", this.source, this.target, this.data);
    BIN: $display("SOURCE: %b TARGET: %b DATA: %b", this.source, this.target, this.data);
  endcase
  $display("-----------------------------------------");
 endfunction
 
endclass

