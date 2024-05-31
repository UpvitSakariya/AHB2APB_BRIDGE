/*
1. slave agent is registered inside a factory
2. have instantiation of slave monitor only
3. slave agent constructor is implemented
4. build phase will construct the slave monitor
*/


class ahb2apb_slave_agent extends uvm_agent;
  
  `uvm_component_utils(ahb2apb_slave_agent)
  ahb2apb_s_monitor s_mon;
  ahb2apb_s_driver s_drv;
  
  
  function new(string name = "ahb2apb_slave_agent",uvm_component parent);
    super.new(name,parent);
    `uvm_info("slave_agent_class","inside constructor",UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("slave_agent_class","build phase",UVM_LOW)
    s_drv = ahb2apb_s_driver::type_id::create("s_drv",this);
    s_mon = ahb2apb_s_monitor::type_id::create("s_mon",this);
  endfunction
  
   function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     `uvm_info("slave_agent_class","connect phase",UVM_LOW)
  endfunction
 
  
endclass
