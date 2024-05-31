//apb test class
// Author:- Upvit sakariya
//-------------------------

/*
1. registering the test component into the factory
2. taken instantiation of sequence and env
3. test constructor
4. inside a build_phase env is created
5. inside end_of_elaboration I have printed the topology
6. inside a run phase we have created the sequence and running the sequence on the sequencer

*/


class ahb2apb_incr_test extends ahb2apb_base_test;
  
  `uvm_component_utils(ahb2apb_incr_test)
   ahb2apb_incr_seq incr_seq;
   ahb2apb_incr4_seq incr4_seq;
   ahb2apb_incr8_seq incr8_seq;
   ahb2apb_incr16_seq incr16_seq;
  
  function new(string name = "ahb2apb_incr_test",uvm_component parent);
    super.new(name,parent);
    `uvm_info("test_class","inside constructor",UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("test_class","build phase",UVM_LOW)
  endfunction

/* 
 1. In run phase we are running the sequence on the sequencer inside a raise and drop objection
 2. it is written inside uvm_object class extended from uvm_report_object to coordinate information between two or more components and objects.
 3. raise and drop objection means internal counter is incremented and drecremented respectively.
 4. if all the objections are droped means simulation activity is completed.
 5. it will never stop your stimulation abruptly(instantly) and helpful to soomthly end our simulation process.
 */
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("test_class","run phase",UVM_LOW)
    
    incr_seq = ahb2apb_incr_seq::type_id::create("incr_seq");
    incr4_seq = ahb2apb_incr4_seq::type_id::create("incr4_seq");
    incr8_seq = ahb2apb_incr8_seq::type_id::create("incr8_seq");
    incr16_seq = ahb2apb_incr16_seq::type_id::create("incr16_seq");

   phase.raise_objection(this);
    
    `uvm_info("test_class","sequence constructed",UVM_LOW)
    
     // #100;
//1. start method is a task which is written inside a uvm_sequence_base class, it will executes the sequence and return when it is completed.
//2. sequencer argument specifies the sequencer on which to run this sequence

    //incr_seq.start(env.master_agent.m_sqr);
    incr4_seq.start(env.master_agent.m_sqr);
    //incr8_seq.start(env.master_agent.m_sqr);
    //incr16_seq.start(env.master_agent.m_sqr);
	phase.phase_done.set_drain_time(this,500);
    
    phase.drop_objection(this); 
    
  endtask
 
  
endclass
