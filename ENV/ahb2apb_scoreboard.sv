/*
1. declaring analysis implementation port so that it is able to differenciate between two write methods.
2. taking two queues of sequence_item and memory into it.
3. two analysis implentation ports, one for master monitor and one for slave monitor.
4. constructing these two ports in build phase
5. two write methods one for master monitor and one for slave monitor where dataes are phush back into the queue.
6. then two sequence item handles are taken inside run phase where we will get the datas from the queue. 
7. generating the expected data and comparing it with actual data in run phase.
*/

`uvm_analysis_imp_decl(_master)
`uvm_analysis_imp_decl(_slave)


class ahb2apb_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(ahb2apb_scoreboard)
   ahb2apb_transaction m_item[$];
   ahb2apb_transaction s_item[$];
   bit [31:0]mem[bit[31:0]];
   bit [31:0] temp_addr;
   bit [31:0] temp_data;
  
   uvm_analysis_imp_master #(ahb2apb_transaction,ahb2apb_scoreboard) m_scoreboard_port;
  
   uvm_analysis_imp_slave #(ahb2apb_transaction,ahb2apb_scoreboard) s_scoreboard_port;

  extern function new(string name = "ahb2apb_scoreboard",uvm_component parent);
  
  extern function void build_phase(uvm_phase phase);

  extern function void write_master(ahb2apb_transaction item);

  extern function void write_slave(ahb2apb_transaction item);

  extern task run_phase(uvm_phase phase);

  extern task compare();

  extern task ref_model();

endclass


  function ahb2apb_scoreboard::new(string name = "ahb2apb_scoreboard",uvm_component parent);
    super.new(name,parent);
    `uvm_info("scoreboard_class","inside constructor",UVM_LOW)
  endfunction
  
  function void ahb2apb_scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("scoreboard_class","build phase",UVM_LOW)
    m_scoreboard_port = new("m_scoreboard_port",this);
    s_scoreboard_port = new("s_scoreboard_port",this);
  endfunction
  
  function void ahb2apb_scoreboard::write_master(ahb2apb_transaction item);
    m_item.push_back(item);
    //print both
    `uvm_info(get_type_name(),$sformatf("transaction from sequence item m_item=%0p",item),UVM_LOW)
  endfunction
 
  function void ahb2apb_scoreboard::write_slave(ahb2apb_transaction item);
    s_item.push_back(item);
    //print both queue
    `uvm_info(get_type_name(),$sformatf("transaction from sequence item s_item=%0p",item),UVM_LOW)
  endfunction 
  
  task ahb2apb_scoreboard::run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin 
       //get the packet
       //generate the expected value
       //compare the actual value
       //score the transaction accordingly
      
    /*  ahb2apb_transaction curr_m_item,curr_s_item;
      wait(m_item.size()!=0);
      curr_m_item = m_item.pop_front();
      wait(s_item.size()!=0);
      curr_s_item = s_item.pop_front();
      
     // $display("m_item=%0d and s_item=%0d",m_item.size(),s_item.size());
      
      
      if(curr_m_item.HWRITE==1)begin
        mem[curr_m_item.HADDR] = curr_m_item.HWDATA;
        $display("writting into the memory");
        `uvm_info(get_type_name(),$sformatf("writting into the memory Haddr=%0d, Hwdata=%0d",curr_m_item.HADDR,curr_m_item.HWDATA),UVM_LOW)
      end
      else if(curr_m_item.HWRITE == 0)begin
        if(mem[curr_m_item.HADDR] == curr_s_item.PRDATA)begin 
          $display("comparing the memory");
          `uvm_info(get_type_name(),$sformatf("item Matched act=%0d and exp=%0d",curr_s_item.PRDATA,mem[curr_m_item.HADDR]),UVM_LOW)
        end
        else begin
          `uvm_error(get_type_name(),$sformatf("item MisMatched act=%0d and exp=%0d",curr_s_item.PRDATA,mem[curr_m_item.HADDR]))
        end         
      end 
          */

		  fork 
           compare();
		   ref_model();
		  join

    end  
    
  endtask 

  task ahb2apb_scoreboard::ref_model();

  forever begin
  
  ahb2apb_transaction expected_item,actual_item;
  wait(m_item.size()>0);
  expected_item = m_item.pop_front();
       
	   temp_addr = expected_item.HADDR;
	  for(int i=0;i<=expected_item.HWDATA.size();i++)begin
	   temp_data = expected_item.HWDATA[i];


          mem[temp_addr] = temp_data;
		 `uvm_info("SCOREBOARD","[expected task]Wrtitting data into the memory",UVM_LOW)
         `uvm_info("SCOREBOARD",$sformatf("HADDR=%0h , DATA=%0h",expected_item.HADDR,temp_data),UVM_LOW)
          temp_addr = temp_addr + 4;

	   `uvm_info("Write associative queue",$sformatf("mem=%0p, and temp_addr=%0h",mem,temp_addr),UVM_NONE)

	  end

   end

  endtask
    
  task ahb2apb_scoreboard::compare();

  forever begin
	 ahb2apb_transaction expected_item,actual_item;
     wait(s_item.size()>0 && m_item.size()>0);
	 expected_item = m_item.pop_front();
     actual_item = s_item.pop_front();

	   temp_addr = actual_item.PADDR;
         `uvm_info("1",$sformatf("HADDR=%0h",actual_item.PADDR),UVM_LOW)
	  for(int i=0;i<=expected_item.HWDATA.size();i++)begin
      
	  temp_data = actual_item.PWDATA;
      `uvm_info("2",$sformatf("ADDR=%0h , DATA=%0h",actual_item.PADDR,temp_data),UVM_LOW)


           `uvm_info("SCOREBOARD",$sformatf("actual_ADDR=%0h",actual_item.PADDR),UVM_LOW)
           if(mem[temp_addr] == temp_data)begin 
             `uvm_info("SCOREBOARD","[compare] comparing the memory",UVM_LOW);
             `uvm_info(get_type_name(),$sformatf("item Matched act=%0h and exp=%0p",temp_data,mem[actual_item.PADDR]),UVM_LOW)
           end
           else begin
             `uvm_error(get_type_name(),$sformatf("item MisMatched act=%0h and exp=%0p",temp_data,mem[actual_item.PADDR]))
           end   
		   temp_addr = temp_addr + 4;


	   `uvm_info("Read associative queue",$sformatf("mem=%0p",mem),UVM_NONE)
	  end

  end

  endtask
  



    

  
