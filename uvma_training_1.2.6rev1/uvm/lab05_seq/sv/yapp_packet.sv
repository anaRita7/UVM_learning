/*-----------------------------------------------------------------
File name     : yapp_packet.sv
Description   : lab01_data YAPP UVC packet template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

// Define your enumerated type(s) here
typedef enum bit { BAD_PARITY, GOOD_PARITY } parity_t;

class yapp_packet extends uvm_sequence_item;

// Follow the lab instructions to create the packet.
// Place the packet declarations in the following order:

  // Define protocol data
  rand bit [5:0]  length;
  rand bit [1:0]  addr;
  rand bit [7:0]  payload [];
  bit      [7:0]  parity;

  // Define control knobs
  rand parity_t parity_type;
  rand int packet_delay;

  // Enable automation of the packet's fields
    `uvm_object_utils_begin(yapp_packet)
    `uvm_field_int(length, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_array_int(payload, UVM_ALL_ON)
    `uvm_field_int(parity, UVM_ALL_ON)
    `uvm_field_enum(parity_t, parity_type, UVM_ALL_ON)
    `uvm_field_int(packet_delay, UVM_ALL_ON | UVM_DEC | UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "yapp_packet");
    super.new(name);
  endfunction : new

  // Define packet constraints
  constraint valid_addr     {addr != 'b11;}
  constraint valid_length   {length > 0; length < 64;}
  constraint payload_size   {length == payload.size();}
  constraint default_parity {parity_type dist {BAD_PARITY := 1, GOOD_PARITY := 5};}
  constraint valid_delay    {packet_delay >= 0; packet_delay < 20; }

  // Add methods for parity calculation and class construction
  function bit [7:0] calc_parity();
    calc_parity = {length, addr};
    for (int i=0; i<length; i++)
      calc_parity = calc_parity ^ payload[i];
  endfunction : calc_parity

  function void set_parity();
    parity = calc_parity();
    if (parity_type == BAD_PARITY)
      parity++;
  endfunction : set_parity

  function void post_randomize();
    set_parity();
  endfunction : post_randomize

endclass: yapp_packet

class short_yapp_packet extends yapp_packet;

  `uvm_object_utils(short_yapp_packet)

  function new (string name = "short_yapp_packet");
    super.new(name);
  endfunction : new

  constraint packet_length { length < 15; }
  //constraint not_addr_2    { addr != 'b10; }

endclass : short_yapp_packet
