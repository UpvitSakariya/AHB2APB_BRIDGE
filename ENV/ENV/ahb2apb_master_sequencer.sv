/*
1. it is a perameterized class that says that i will be reciving and sending this packet of data.
2. sequencer is registered into the factory.
3. it is a component so its constructor is implemented.
4. no phases are needed here
*/

class ahb2apb_m_sequencer extends uvm_sequencer#(ahb2apb_transaction);
  
  `uvm_component_utils(ahb2apb_m_sequencer)
  
  function new(string name = "ahb2apb_m_sequencer",uvm_component parent);
    super.new(name,parent);
    `uvm_info("m_sequencer_class","inside constructor",UVM_LOW)
  endfunction
 
  
endclass
