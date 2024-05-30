class ahb2apb_subscriber extends uvm_subscriber#(ahb2apb_transaction);
  
  `uvm_component_utils(ahb2apb_subscriber)
  
   
  
  function new(string name = "ahb2apb_subscriber",uvm_component parent);
    super.new(name,parent);
    `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
     //cgp = new;
  endfunction
  
  function void write(ahb2apb_transaction t);
    //`uvm_info(get_type_name(),$sformatf("Subscriber received pkt=%0p",t), UVM_NONE);
    //$display("coverage=",cgp.get_coverage());
  endfunction 
  
  
endclass
