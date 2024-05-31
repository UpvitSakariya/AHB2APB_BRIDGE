/*1. master agent will be registered into the factory
2. instantiation of monitor, driver, and sequencer is taken
3. master agent constructor is implemented
4. build phase will build all the lower hierarchicall components.
5. connect phase will connect the driver and sequencer with the in-built tlm port connection
*/



class ahb2apb_master_agent extends uvm_agent;
  
  `uvm_component_utils(ahb2apb_master_agent)
  ahb2apb_m_monitor m_mon;
  ahb2apb_m_driver m_drv;
  ahb2apb_m_sequencer m_sqr;
  
  function new(string name = "ahb2apb_master_agent",uvm_component parent);
    super.new(name,parent);
    `uvm_info("master_agent_class","inside constructor",UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("master_agent_class","build phase",UVM_LOW)
    m_drv = ahb2apb_m_driver::type_id::create("m_drv",this);
    m_mon = ahb2apb_m_monitor::type_id::create("m_mon",this);
    m_sqr = ahb2apb_m_sequencer::type_id::create("m_sqr",this);
  endfunction
  
/*
1. The seq_item_port(driver has it) and seq_item_export(sequencer has it) are an instance handle for uvm_seq_item_pull_port and uvm_seq_item_pull_export respectively.
2. here driver is consumer will have port and sequencer is producer will have imp port, they are working in pull mode.
3. seq_item_port is buit-in port in uvm_driver class is used to request item from the sequencer.
4. seq_item_export is built-in imp port in uvm_sequencer class is used to send item to the driver.
*/
   function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     `uvm_info("master_agent_class","connect phase",UVM_LOW)
      m_drv.seq_item_port.connect(m_sqr.seq_item_export);
   endfunction
 
  
endclass
