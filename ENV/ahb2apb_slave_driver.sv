class ahb2apb_s_driver extends uvm_driver;
  
  `uvm_component_utils(ahb2apb_s_driver)
   virtual apb_intf apb_vif;
  //int queue[$];
  bit [31:0]mem[int];
  int i;
  
  function new(string name = "ahb2apb_s_driver",uvm_component parent);
    super.new(name,parent);
    `uvm_info("s_driver_class","inside constructor",UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("s_driver_class","build phase",UVM_LOW)
    if(!(uvm_config_db#(virtual apb_intf)::get(this,"*","apb_vif",apb_vif)))begin
        `uvm_error("s_driver_class","passed to get apb_vif inside a driver")
    end 
    
  endfunction
  
    task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("s_driver_class","run phase",UVM_LOW)
      
    
      
     forever begin
       
       @(apb_vif.sdrv_cb);
       
       if(!apb_vif.resetn)begin
         for(i=0;i<=31;i++)begin
         mem[i]=0;
         end
       end
       
 
      wait(apb_vif.resetn);
        
     @(apb_vif.sdrv_cb);
       wait(apb_vif.PENABLE);  
      // apb_vif.PREADY <= 1;
       if(apb_vif.PWRITE && apb_vif.PENABLE)begin 
         `uvm_info(get_type_name(),$sformatf("sending from s_driver into m_monitor before updating into the memory ::Pwdata=%0h",apb_vif.PWDATA),UVM_LOW)
         mem[apb_vif.PADDR] = apb_vif.PWDATA;
        // queue.push_back(apb_vif.Paddr);
         `uvm_info(get_type_name(),$sformatf("sending from s_driver into s_monitor after updating into the memory::mem[%0h]=%0h",apb_vif.PADDR,mem[apb_vif.PADDR]),UVM_LOW)
        end
       else if(!apb_vif.PWRITE && apb_vif.PENABLE)begin    
          $display("---");
        
          apb_vif.sdrv_cb.PRDATA <= mem[apb_vif.PADDR];
         `uvm_info(get_type_name(),$sformatf("sending from s_driver into m_monitor::Paddr=%0h,Prdata=%0h,",apb_vif.PADDR,mem[apb_vif.PADDR]),UVM_LOW)
         
        end 
       
       //if(apb_vif.Penable && apb_vif.Pready)begin
     /*  if(apb_vif.PADDR>=5'd10 && !apb_vif.PWRITE)begin
           apb_vif.Pslverr <= 1;
         end
         else begin
           apb_vif.Pslverr <= 0;
         end */
      // end
            
     end       
     
    endtask
    
  
endclass
