/*-----------------------------------------------------------------
File name     : yapp_tx_seqs.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : YAPP UVC simple TX test sequence for labs 2 to 4
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// SEQUENCE: base yapp sequence - base sequence with objections from which 
// all sequences can be derived
//
//------------------------------------------------------------------------------
class yapp_base_seq extends uvm_sequence #(yapp_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_base_seq)

  // Constructor
  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : yapp_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 yapp_5_packets::get_type());
//
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_5_packets)

  // Constructor
  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask
  
endclass : yapp_5_packets

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_1_seq - send a random packet to Channel 1
//
//------------------------------------------------------------------------------
class yapp_1_seq extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_1_seq)

  // Constructor
  function new(string name="yapp_1_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing YAPP_1_SEQ", UVM_LOW)
    `uvm_do_with(req, {req.addr == 2'b01;})
  endtask
  
endclass : yapp_1_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_012_seq - send random packets to channel 0, 1, 2 in order
//
//------------------------------------------------------------------------------
class yapp_012_seq extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_012_seq)

  // Constructor
  function new(string name="yapp_012_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing YAPP_012_SEQ", UVM_LOW)
    `uvm_do_with(req, {req.addr == 2'b00;})
    `uvm_do_with(req, {req.addr == 2'b01;})
    `uvm_do_with(req, {req.addr == 2'b10;})
  endtask
  
endclass : yapp_012_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_111_seq - send three random packets to channel 1
//
//------------------------------------------------------------------------------
class yapp_111_seq extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_111_seq)

  // Nested Sequence - executes yapp_1_seq three times
  yapp_1_seq addr_1_seq;

  // Constructor
  function new(string name="yapp_111_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing YAPP_111_SEQ", UVM_LOW)
    repeat (3) 
      `uvm_do(addr_1_seq)

  endtask
  
endclass : yapp_111_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_repeat_addr_seq - sends two packets to the same random address
//
//------------------------------------------------------------------------------
class yapp_repeat_addr_seq extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_repeat_addr_seq)

  // Constructor
  function new(string name="yapp_repeat_addr_seq");
    super.new(name);
  endfunction

  // rand sequence property
  rand bit [1:0] seqaddr;
  constraint legal_addr {seqaddr != 3;}


  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing REPEAT_ADDR_SEQ", UVM_LOW)
    repeat (2) 
      `uvm_do_with(req, {req.addr == seqaddr;})
//  alternative
//  `uvm_do(req);
//  seqaddr = req.addr;
//  `uvm_do_with(req, {req.addr == seqaddr;})
  endtask

endclass : yapp_repeat_addr_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_incr_payload_seq - sends single packet with incrementing payload
//
//------------------------------------------------------------------------------
class yapp_incr_payload_seq extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_incr_payload_seq)

  // Constructor
  function new(string name="yapp_incr_payload_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    int ok;
    `uvm_info(get_type_name(), "Executing YAPP_INCR_PAYLOAD_SEQ", UVM_LOW)
    // simple solution using constraint
    //`uvm_do_with(req, {foreach (payload[i]) payload[i] == i ; })
    // intended solution using create and send macros
    `uvm_create(req)
    ok = req.randomize();
    foreach (req.payload [i])
      req.payload[i] = i;
    req.set_parity();  // recalculate parity taking into account parity_type
    `uvm_send(req)     // send without further randomization
  endtask
endclass : yapp_incr_payload_seq
  
//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_rnd_seq
//
//------------------------------------------------------------------------------

class yapp_rnd_seq extends yapp_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(yapp_rnd_seq)

  // Parameter for this sequence
  rand int count;

  // Sequence Constraints
  constraint count_limit { count inside {[1:10]}; }

  // Constructor
  function new(string name="yapp_rnd_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), $sformatf("Executing YAPP_RND_SEQ %0d times...", count), UVM_LOW)
    repeat (count) begin
      `uvm_do(req)
    end
  endtask

endclass : yapp_rnd_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: six_yapp_seq
//
//------------------------------------------------------------------------------

class six_yapp_seq extends yapp_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(six_yapp_seq)

  // Parameter for this sequence
  yapp_rnd_seq yss;

  // Constructor
  function new(string name="six_yapp_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing SIX_YAPP_SEQ" , UVM_LOW)
    `uvm_do_with(yss, {count==6;})
  endtask

endclass : six_yapp_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_exhaustive_seq
//
//------------------------------------------------------------------------------

class yapp_exhaustive_seq extends yapp_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(yapp_exhaustive_seq)

  // handles for all lab05 sequences - use meaningful handles for debug!
  yapp_012_seq y012;
  yapp_1_seq y1;
  yapp_111_seq y111;
  yapp_repeat_addr_seq yaddr;
  yapp_incr_payload_seq yinc;
  //six_yapp_seq ysix;

  // Constructor
  function new(string name="yapp_exhaustive_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing YAPP_EXHAUSTIVE_SEQ" , UVM_LOW)
    `uvm_do(y012)
    `uvm_do(y1)
    `uvm_do(y111)
    `uvm_do(yaddr)
    `uvm_do(yinc)
   // `uvm_do(ysix)
  endtask

endclass : yapp_exhaustive_seq
