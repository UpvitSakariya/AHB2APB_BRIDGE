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


class ahb2apb_base_test extends uvm_test;
  
  `uvm_component_utils(ahb2apb_base_test)
   //ahb2 write_seq;
   ahb2apb_env env;
  
  function new(string name = "ahb2apb_base_test",uvm_component parent);
    super.new(name,parent);
    `uvm_info("test_class","inside constructor",UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("test_class","build phase",UVM_LOW)
    env = ahb2apb_env::type_id::create("env",this);
  endfunction
 
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
      uvm_top.print_topology();
  endfunction 
    
  
 /*
 1. In run phase we are running the sequence on the sequencer inside a raise and drop objection
 2. it is written inside uvm_object class extended from uvm_report_object to coordinate information between two or more components and objects.
 3. raise and drop objection means internal counter is incremented and drecremented respectively.
 4. if all the objections are droped means simulation activity is completed.
 5. it will never stop your stimulation abruptly(instantly) and helpful to soomthly end our simulation process.
 */

 
  
endclass
