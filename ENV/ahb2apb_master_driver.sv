/*
1. master driver will be registered into the factory
2. will have instantiation of sequence item and interface
3. master driver constructor is implemented
4. build phase will get the interface that is setted inside the config_db data base
5. run phase will have the logic to drive the signals into the dut through interface.
6. driver is a perameterized class it will contain the packet instantiation that says that i will be receiving this kind of data
*/


class ahb2apb_m_driver extends uvm_driver#(ahb2apb_transaction);
  
  `uvm_component_utils(ahb2apb_m_driver)
   virtual ahb_intf ahb_vif;
   virtual apb_intf apb_vif;
   ahb2apb_transaction addrQ[$],addr_tx,dataQ[$],data_tx,atx,dtx;

   bit [31:0]start_addr;
   bit [31:0]lower_wrap,upper_wrap;
   int total_size;

  // total_size=(addr_tx.beat)*(2**addr_tx.HSIZE);
  // remainder=addr_tx.HADDR%total_size;
  // lower_wrap=addr_tx.HADDR-remainder;
  // upper_wrap=lower_wrap+total_size;

  
  extern function new(string name = "ahb2apb_m_driver",uvm_component parent);
   
  extern function void build_phase(uvm_phase phase);  
 
/*
1. it will get all the randomized sequences from the sequencer then it will drive those signals into the dut
*/
  extern task run_phase(uvm_phase phase);
     
  extern task get();

  extern task addr_phase();
  
  extern task data_phase();
  
endclass:ahb2apb_m_driver

 
  function ahb2apb_m_driver::new(string name = "ahb2apb_m_driver",uvm_component parent);
    super.new(name,parent);
    `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
  endfunction
  
  function void ahb2apb_m_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("m_driver_class","build phase",UVM_LOW)
    if(!(uvm_config_db#(virtual ahb_intf)::get(this,"*","ahb_vif",ahb_vif)))begin
        `uvm_error(get_type_name(),"failed to get vif inside a driver")
    end 
  endfunction

   task ahb2apb_m_driver::run_phase(uvm_phase phase);
     super.run_phase(phase); 
     `uvm_info(get_type_name(),"run phase",UVM_LOW)
     
       wait(ahb_vif.resetn);

     forever begin  

	 //  @(ahb_vif.mdrv_cb);
	  // wait(ahb_vif.HREADYOUT);
	   ahb_vif.HREADY <= 1;
       
	   fork
        get();
		addr_phase();
		data_phase();
		join

       `uvm_info(get_type_name(),$sformatf("received from sequence:: haddr=%0d and hwdata=%0p",req.HADDR,req.HWDATA),UVM_LOW)
       //seq_item_port.item_done();
      // wait(ahb_vif.Pready);
       
      end
     
   endtask



 task ahb2apb_m_driver::get();

   //forever begin

       seq_item_port.get(req);
	   `uvm_info("Master Driver","this packet is pushed back into the queue",UVM_NONE)
	   req.print();

       atx = new req;
	   dtx = new req;
     
	   addrQ.push_back(atx);
	   dataQ.push_back(dtx);

   //end


 endtask

  task ahb2apb_m_driver::addr_phase();
   //forever begin
   // @(ahb_vif.mdrv_cb);
	
	wait(addrQ.size()>0); 
	//wait(ahb_vif.HREADYOUT);
	`uvm_info("ahb_vif_addr_phase",$sformatf(" 1-->HREADYOUT=%0d",ahb_vif.HREADYOUT),UVM_LOW);
	addr_tx = addrQ.pop_front();

    total_size=(addr_tx.beat)*(2**addr_tx.HSIZE);
    lower_wrap=addr_tx.HADDR-(2**addr_tx.HSIZE);
    upper_wrap=lower_wrap+total_size;
    
	ahb_vif.mdrv_cb.HWRITE <= addr_tx.HWRITE;
	ahb_vif.mdrv_cb.HBURST <= addr_tx.HBURST;
	ahb_vif.mdrv_cb.HSIZE <= addr_tx.HSIZE;
	ahb_vif.mdrv_cb.HADDR <= addr_tx.HADDR;
    ahb_vif.mdrv_cb.HTRANS <= addr_tx.HTRANS[0];
   // start_addr = addr_tx.HADDR;
	//wait(ahb_vif.HREADYOUT);
	//`uvm_info("before",$sformatf("from r_channel::start_addr=%0h,addr_tx.beat=%0d, addr_tx.hsize=%0d, total_size=%0d, lower_wrap=%0h, upper_wrap=%0h",start_addr,addr_tx.beat,addr_tx.HSIZE,total_size,lower_wrap,upper_wrap),UVM_NONE)
	for(int i=0;i<addr_tx.HWDATA.size()-1;i++)begin
	`uvm_info("BEFORE",$sformatf(" ///////////////////////////// loop is started %0d times",i),UVM_LOW)
	
	@(ahb_vif.mdrv_cb);
	wait(ahb_vif.HREADYOUT);
	`uvm_info("AFTER",$sformatf(" ///////////////////////////// loop is started after the delay %0d times",i),UVM_LOW)

	`uvm_info("-------------",$sformatf("-------------------- 2-->HREADYOUT=%0d",ahb_vif.HREADYOUT),UVM_LOW);
		if(addr_tx.HBURST==INCR||addr_tx.HBURST==INCR4||addr_tx.HBURST==INCR8||addr_tx.HBURST==INCR16)begin
		ahb_vif.mdrv_cb.HTRANS <= addr_tx.HTRANS[i+1];
		//start_addr = start_addr+4;
		addr_tx.HADDR = addr_tx.HADDR + 2**addr_tx.HSIZE;
		ahb_vif.mdrv_cb.HADDR <= addr_tx.HADDR;
		`uvm_info("INCR_ADDR",$sformatf("ahb_vif.HTRANS=%0d, and ahb_vif.HADDR=%0h",ahb_vif.HTRANS,ahb_vif.mdrv_cb.HADDR),UVM_LOW)
		//continue;
		end 
		else if(addr_tx.HBURST==WRAP4||addr_tx.HBURST==WRAP8||addr_tx.HBURST==WRAP16)begin
		ahb_vif.mdrv_cb.HTRANS <= addr_tx.HTRANS[i];
		addr_tx.HADDR = addr_tx.HADDR+ 2**addr_tx.HSIZE;
			if(addr_tx.HADDR==upper_wrap)begin
              addr_tx.HADDR = lower_wrap;
			end
		ahb_vif.mdrv_cb.HADDR <= addr_tx.HADDR;
	//	`uvm_info("WRAP_ADDR",$sformatf("ahb_vif.HTRANS=%0d, and ahb_vif.HADDR=%0h",ahb_vif.HTRANS,ahb_vif.HADDR),UVM_LOW)
		end
	//wait(ahb_vif.HREADYOUT);
     	@(ahb_vif.mdrv_cb);
		`uvm_info("AFTER",$sformatf("****************loop is complited %0d times",i),UVM_LOW)
	end  
	  
   //end
  endtask

  task ahb2apb_m_driver::data_phase();
   //forever begin
   // @(ahb_vif.mdrv_cb);
     
	wait(dataQ.size()>0);
	data_tx = dataQ.pop_front();

    for(int i=0;i<data_tx.HWDATA.size();i++)begin
	//`uvm_info("BEFORE_DATA_PHASE",$sformatf(" ///////////////////////////// loop is started %0d times",i),UVM_LOW)
     @(ahb_vif.mdrv_cb);
	wait(ahb_vif.HREADYOUT);
	//`uvm_info("AFTER_DATA_PHASE",$sformatf(" ///////////////////////////// loop is started after the delay %0d times",i),UVM_LOW)
	 `uvm_info("ahb_vif_data_phase",$sformatf("HREADYOUT=%0d",ahb_vif.HREADYOUT),UVM_LOW);

	 ahb_vif.mdrv_cb.HWDATA <= data_tx.HWDATA[i]; 
	// `uvm_info("MDRV",$sformatf("hwdata=%0h",data_tx.HWDATA[i]),UVM_LOW)
	@(ahb_vif.mdrv_cb);
	//`uvm_info("AFTER_DATA_PHASE",$sformatf(" ///////////////////////////// loop is complited %0d times",i),UVM_LOW)

	end

   //end
  endtask



