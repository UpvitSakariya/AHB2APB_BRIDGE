/*
1. master monitor is registered in the factory
2. instantiation of interface and sequence item is taken
3. build phase will get the interface that is setted inside the config_db data base
*/

class ahb2apb_s_monitor extends uvm_monitor;
  
  `uvm_component_utils(ahb2apb_s_monitor)
  virtual apb_intf apb_vif;
  ahb2apb_transaction s_item;
  uvm_analysis_port #(ahb2apb_transaction) s_monitor_port;
  
  function new(string name = "ahb2apb_s_monitor",uvm_component parent);
    super.new(name,parent);
    `uvm_info("s_monitor_class","inside constructor",UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("s_monitor_class","build phase",UVM_LOW)
    s_monitor_port = new("s_monitor_port",this);
    
    if(!(uvm_config_db#(virtual apb_intf)::get(this,"*","apb_vif",apb_vif)))begin
      `uvm_error("s_monitor_class","passed to get apb_vif inside a driver")
    end 
    
  endfunction
  
   function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     `uvm_info("s_monitor_class","connect phase",UVM_LOW)
  endfunction
  
    task run_phase(uvm_phase phase);
    super.run_phase(phase);
      `uvm_info("s_monitor_class","run phase",UVM_LOW)
      
    forever begin
      s_item = ahb2apb_transaction::type_id::create("s_item");
      
      wait(apb_vif.resetn);
      
      @(apb_vif.smon_cb);
	   s_item.PADDR = apb_vif.smon_cb.PADDR;
       s_item.PREADY = apb_vif.smon_cb.PREADY;
       s_item.Pslverr = apb_vif.smon_cb.Pslverr;
       s_item.PWDATA = apb_vif.smon_cb.PWDATA;
       
      `uvm_info(get_type_name(),$sformatf("received from s_driver into s_monitor::Pready=%0d,Pslverr=%0d,Pwdata=%0d",apb_vif.PREADY,apb_vif.Pslverr,apb_vif.PWDATA),UVM_LOW)
     
      
      //send item to scoreboard
      s_monitor_port.write(s_item);
	 // `uvm_info("Slave Monitor","This is Pacacket sending to the scoreboard",UVM_MEDIUM)
     // s_item.print();
    end
      
  endtask
 
 
  
endclass
