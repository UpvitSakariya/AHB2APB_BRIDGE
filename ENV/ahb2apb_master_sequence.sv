/*
1. sequence is a object and it is registered into the factory
2. contains the instantiation of sequence item
3. object constructor is implemented 
4. body task will create the sequence item at simulation time, it will start randomizing the sequence item based on the request from the driver and send the randomized data to the driver through sequencer
*/

class base_sequence extends uvm_sequence#(ahb2apb_transaction);
  
  `uvm_object_utils(base_sequence)
 
  function new(string name = "base_sequence");
    super.new(name);
    `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
  endfunction
  
endclass


