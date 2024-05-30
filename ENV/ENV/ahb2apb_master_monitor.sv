/*
1. master monitor is registered in the factory
2. instantiation of interface and sequence item is taken
3. build phase will get the interface that is setted inside the config_db data base
*/


class ahb2apb_m_monitor extends uvm_monitor;
  
  `uvm_component_utils(ahb2apb_m_monitor)
   virtual ahb_intf ahb_vif;
   ahb2apb_transaction addr_tx,addr_que[$],tx;
   int M_Queue[$];
   uvm_analysis_port #(ahb2apb_transaction) m_monitor_port;
  
  extern function new(string name = "ahb2apb_m_monitor",uvm_component parent);
    
  extern function void build_phase(uvm_phase phase);
     
  extern function void connect_phase(uvm_phase phase);
      
  extern task run_phase(uvm_phase phase);

  extern task packet();
       
  extern task addr_phase();

  extern task data_phase();
  //endtask
 
  
endclass:ahb2apb_m_monitor

  function ahb2apb_m_monitor::new(string name = "ahb2apb_m_monitor",uvm_component parent);
    super.new(name,parent);
    `uvm_info("m_monitor_class","inside constructor",UVM_LOW)
  endfunction
  
  function void ahb2apb_m_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("m_monitor_class","build phase",UVM_LOW)
    m_monitor_port = new("m_monitor_port",this);
    
   if(!(uvm_config_db#(virtual ahb_intf)::get(this,"*","ahb_vif",ahb_vif)))begin
      `uvm_error("m_monitor_class","failed to get ahb_vif inside a driver")
    end 
    
  endfunction

  function void ahb2apb_m_monitor::connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     `uvm_info("m_monitor_class","connect phase",UVM_LOW)
  endfunction
  
  task ahb2apb_m_monitor::run_phase(uvm_phase phase);
    super.run_phase(phase); 
    `uvm_info("s_monitor_class","run phase",UVM_LOW)
      
      wait(ahb_vif.resetn);

    forever begin
      
      @(ahb_vif.mmon_cb);
      
	  
	  packet();
	  
	 /* fork
	    addr_phase();
		data_phase();
	  join	 
      @(ahb_vif.mmon_cb);
       tx.HWRITE = ahb_vif.mmon_cb.HWRITE;
       tx.HADDR = ahb_vif.mmon_cb.HADDR;
       tx.HWDATA.push_back(ahb_vif.mmon_cb.HWDATA);
       tx.HSIZE = hsize_type'(ahb_vif.mmon_cb.HSIZE);
       tx.HBURST = hburst_type'(ahb_vif.mmon_cb.HBURST);
       tx.HTRANS.push_back(htrans_type'(ahb_vif.mmon_cb.HTRANS));
	   tx.HRDATA.push_back(ahb_vif.mmon_cb.HRDATA);
	   tx.HRESP = hresp_type'(ahb_vif.mmon_cb.HRESP);
	   tx.HREADYOUT = ahb_vif.mmon_cb.HREADYOUT;
      
      //`uvm_info(get_type_name(),$sformatf("received from m_driver into m_monitor:: hwrite=%0d, haddr=%0h, hwdata=%0p, hsize=%0d, hburst=%0d, htrans=%0p, hrdata=%0p, hresp=%0d, and hreadyout=%0d",tx.HWRITE,tx.HADDR,tx.HWDATA,tx.HSIZE,tx.HBURST,tx.HTRANS,tx.HRDATA,tx.HRESP,tx.HREADYOUT),UVM_LOW)
      
      //send item to scoreboard
	  if
      //m_monitor_port.write(tx); */
      
    end 
    
  endtask
 
  task ahb2apb_m_monitor::packet();
    //forever @(ahb_vif.mmon_cb)begin
   
      tx = ahb2apb_transaction::type_id::create("tx");
     `uvm_info("MM","inside a packet",UVM_LOW) 
       wait(ahb_vif.HREADYOUT);
	  // wait(htrans_type'(ahb_vif.mmon_cb.HTRANS==NONSEQ));
    // `uvm_info("MM","inside a packet",UVM_LOW) 
   
  // if(ahb_vif.mmon_cb.HTRANS==NONSEQ)begin
	   tx.HWRITE = ahb_vif.mmon_cb.HWRITE;
       tx.HADDR = ahb_vif.mmon_cb.HADDR;
       tx.HSIZE = hsize_type'(ahb_vif.mmon_cb.HSIZE);
       tx.HBURST = hburst_type'(ahb_vif.mmon_cb.HBURST);
	   //tx.HRDATA.push_back(ahb_vif.mmon_cb.HRDATA);
	   tx.HRESP = hresp_type'(ahb_vif.mmon_cb.HRESP);
	   tx.HREADYOUT = ahb_vif.mmon_cb.HREADYOUT;
	   //for(int i=0;i<=tx.HWDATA.size();i++)begin
	   // @(ahb_vif.mmon_cb);
        tx.HTRANS.push_back(htrans_type'(ahb_vif.mmon_cb.HTRANS));
        tx.HWDATA.push_back(ahb_vif.mmon_cb.HWDATA);
	   //end
     //`uvm_info("MM","inside a packet",UVM_LOW) 
      `uvm_info("set","received from m_driver into m_monitor",UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("received from m_driver into m_monitor:: hwrite=%0d, haddr=%0h, hwdata=%0p, hsize=%0d, hburst=%0d, htrans=%0p, hrdata=%0p, hresp=%0d, and hreadyout=%0d",tx.HWRITE,tx.HADDR,tx.HWDATA,tx.HSIZE,tx.HBURST,tx.HTRANS,tx.HRDATA,tx.HRESP,tx.HREADYOUT),UVM_LOW)
      //`uvm_info(get_type_name(),$sformatf("received from m_driver into m_monitor:: hwrite=%0d, haddr=%0h, hwdata=%0p, hsize=%0d, hburst=%0d, htrans=%0p, hrdata=%0p, hresp=%0d, and hreadyout=%0d",ahb_vif.mmon_cb.HWRITE,ahb_vif.mmon_cb.HADDR,ahb_vif.mmon_cb.HWDATA,ahb_vif.mmon_cb.HSIZE,ahb_vif.mmon_cb.HBURST,ahb_vif.mmon_cb.HTRANS,ahb_vif.mmon_cb.HRDATA,ahb_vif.mmon_cb.HRESP,ahb_vif.mmon_cb.HREADYOUT),UVM_LOW)
      
	     `uvm_info("Master Monitor","This is Pacacket before sending to the scoreboard",UVM_MEDIUM)
	     tx.print();
       //send item to scoreboard
	   if(tx.HWDATA.size()==4)begin
         m_monitor_port.write(tx);
	     `uvm_info("Master Monitor","This is Pacacket sending to the scoreboard",UVM_MEDIUM)
	     tx.print();
       end

   // end
  endtask

 task ahb2apb_m_monitor::addr_phase();
    //forever @(ahb_vif.mmon_cb)begin
   
      tx = ahb2apb_transaction::type_id::create("tx");
     `uvm_info("MM","inside a packet",UVM_LOW) 
       //wait(ahb_vif.mmon_cb.HREADYOUT);
    // `uvm_info("MM","inside a packet",UVM_LOW) 
   
  // if(ahb_vif.mmon_cb.HTRANS==NONSEQ)begin
	   tx.HWRITE = ahb_vif.mmon_cb.HWRITE;
       tx.HADDR = ahb_vif.mmon_cb.HADDR;
       tx.HSIZE = hsize_type'(ahb_vif.mmon_cb.HSIZE);
       tx.HBURST = hburst_type'(ahb_vif.mmon_cb.HBURST);
	   //addr_tx.HRDATA.push_back(ahb_vif.mmon_cb.HRDATA);
	   tx.HRESP = hresp_type'(ahb_vif.mmon_cb.HRESP);
	   tx.HREADYOUT = ahb_vif.mmon_cb.HREADYOUT;
	   //for(int i=0;i<tx.HWDATA.size();i++)begin
	    //@(ahb_vif.mmon_cb);
        tx.HTRANS.push_back(htrans_type'(ahb_vif.mmon_cb.HTRANS));
	   //end
     //`uvm_info("MM","inside a packet",UVM_LOW) 
     // `uvm_info("set","received from m_driver into m_monitor",UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("received from m_driver into m_monitor:: hwrite=%0d, haddr=%0h, hwdata=%0p, hsize=%0d, hburst=%0d, htrans=%0p, hrdata=%0p, hresp=%0d, and hreadyout=%0d",tx.HWRITE,tx.HADDR,tx.HWDATA,tx.HSIZE,tx.HBURST,tx.HTRANS,tx.HRDATA,tx.HRESP,tx.HREADYOUT),UVM_LOW)
     // `uvm_info(get_type_name(),$sformatf("received from m_driver into m_monitor:: hwrite=%0d, haddr=%0h, hwdata=%0p, hsize=%0d, hburst=%0d, htrans=%0p, hrdata=%0p, hresp=%0d, and hreadyout=%0d",ahb_vif.mmon_cb.HWRITE,ahb_vif.mmon_cb.HADDR,ahb_vif.mmon_cb.HWDATA,ahb_vif.mmon_cb.HSIZE,ahb_vif.mmon_cb.HBURST,ahb_vif.mmon_cb.HTRANS,ahb_vif.mmon_cb.HRDATA,ahb_vif.mmon_cb.HRESP,ahb_vif.mmon_cb.HREADYOUT),UVM_LOW)
      
       addr_que.push_back(tx);
	   `uvm_info("que","pushing into the que",UVM_LOW)
	    tx.print();
	   `uvm_info("addr_que",$sformatf("addr_que=%0p, and size=%0d",addr_que,addr_que.size()),UVM_LOW)
	  //wait(ahb_vif.mmon_cb.HTRANS==NONSEQ);
	  // addr_tx.print();
      //end

    //end
  endtask

  task ahb2apb_m_monitor::data_phase();
    
	//forever @(ahb_vif.mmon_cb)begin
      //wait(ahb_vif.mmon_cb.HREADYOUT);
      tx = ahb2apb_transaction::type_id::create("tx");
      wait(addr_que.size()>0);
	  //tx = addr_que[0];
	   //`uvm_info("data_phae",$sformatf("addr_que=%0p, and size=%0d",addr_que,addr_que.size()),UVM_LOW)
      //M_Queue = addr_que.find_index with (item.HADDR==ahb_vif.mmon_cb.HADDR);
      //tx = addr_que[M_Queue[0]];
      //tx = addr_que[0];
      tx.HWDATA.push_back(ahb_vif.mmon_cb.HWDATA);

      
	  if(ahb_vif.mmon_cb.HBURST==INCR4 && tx.HWDATA.size==2**tx.HSIZE)begin
       //send item to scoreboard
	  // wait(tx.HWDATA.size==tx.HBURST)
       m_monitor_port.write(tx);
	   //addr_que = addr_que[1:$];;
	   `uvm_info("Master Monitor",$sformatf("This is Pacacket sending to the scoreboard:: Hwdata=%0p",tx.HWDATA),UVM_MEDIUM)
	   tx.print();
      end

	//end

  endtask
  
