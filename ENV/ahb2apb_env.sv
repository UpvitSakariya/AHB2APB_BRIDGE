 /*
1. env is registered into the factory
2. instantiation of master agent, slave agent, scoreboard, and coverage is taken
3. env constructor is implemented
4. build phase will build all the instantiation of the components
5. connect phase is used for the future purpose if needed

*/




class ahb2apb_env extends uvm_env;
  
  `uvm_component_utils(ahb2apb_env)
 
  ahb2apb_master_agent master_agent;
  ahb2apb_slave_agent slave_agent;
  ahb2apb_scoreboard scb;
  ahb2apb_subscriber sub;
  
  function new(string name = "ahb2apb_env",uvm_component parent);
    super.new(name,parent);
    `uvm_info("env_class","inside constructor",UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("env_class","build phase",UVM_LOW)
    master_agent = ahb2apb_master_agent::type_id::create("master_agent",this);
    slave_agent = ahb2apb_slave_agent::type_id::create("slave_agent",this);
    scb = ahb2apb_scoreboard::type_id::create("scb",this);
    sub = ahb2apb_subscriber::type_id::create("sub",this);
  endfunction
  
   function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     `uvm_info("env_class","connect phase",UVM_LOW)  
    master_agent.m_mon.m_monitor_port.connect(scb.m_scoreboard_port);
    slave_agent.s_mon.s_monitor_port.connect(scb.s_scoreboard_port);
    master_agent.m_mon.m_monitor_port.connect(sub.analysis_export);
    //slave_agent.s_mon.s_monitor_port.connect(sub.analysis_export);
  endfunction
 
  
endclass
