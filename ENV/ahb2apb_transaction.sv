/*
1. sequence item is a object which is registered inside the factory
2. it contains the signals that needs to be randomize
3. object constructor will create the object when it is called
*/

typedef enum bit [2:0]{SINGLE=0,INCR,WRAP4,INCR4,WRAP8,INCR8,WRAP16,INCR16}hburst_type; 
typedef enum bit [2:0]{BYTE1=0,BYTE2,BYTE4,BYTE8,BYTE16,BYTE32,BYTE64,BYTE128}hsize_type;
typedef enum bit [1:0]{IDLE=0,BUSY,NONSEQ,SEQ}htrans_type;
typedef enum bit [1:0]{OKAY=0,ERROR,RETRY,SPLIT}hresp_type;

class ahb2apb_transaction extends uvm_sequence_item;
   
  // ahb protocol signals 
  rand bit [31:0]HADDR;
  rand bit [31:0]HWDATA[$];
  rand hburst_type HBURST;
  rand hsize_type HSIZE;
  rand int beat;
  rand htrans_type HTRANS[$];
  rand hresp_type HRESP;
  rand bit HWRITE;
  rand bit HREADYOUT;
  bit [31:0]HRDATA[$];
  rand bit [3:0]incr;

  // apb protocol signal
  bit [31:0]PADDR;
   bit [31:0]PWDATA;
   bit [31:0]PRDATA;
   bit Pslverr;
   bit PREADY;
  
  constraint  addr{HADDR>=32'h4000_0000 && HADDR <= 32'h4000_FFFF;}
 //constraint aligned_addr{HADDR%(2**HSIZE)==0;}
 //constraint ahb_1kb{HADDR%1024 + (2**HSIZE*(beat)) <= 1024;}

  constraint data{if(HBURST==SINGLE)HWDATA.size()==1;
                  if(HBURST==INCR)HWDATA.size()==incr;    
				  if(HBURST==WRAP4 || HBURST==INCR4)HWDATA.size()==4;
				  if(HBURST==WRAP8 || HBURST==INCR8)HWDATA.size()==8;
				  if(HBURST==WRAP16 || HBURST==INCR16)HWDATA.size()==16;
				  } 

   constraint beat1{if(HBURST==SINGLE)beat==1;
                  if(HBURST==INCR)beat==incr;    
				  if(HBURST==WRAP4 || HBURST==INCR4)beat==4;
				  if(HBURST==WRAP8 || HBURST==INCR8)beat==8;
				  if(HBURST==WRAP16 || HBURST==INCR16)beat==16;
				  }  

  //constraint cnt{()}

  constraint trans{HTRANS.size()==HWDATA.size();
                 HTRANS[0]==NONSEQ;
				 foreach(HTRANS[i])
				 if(i>0)HTRANS[i]==SEQ;
				 }				  
				  

  //bit Penable;

    `uvm_object_utils_begin(ahb2apb_transaction)
     `uvm_field_int(HADDR,UVM_ALL_ON)
     `uvm_field_int(HWRITE,UVM_ALL_ON)
     `uvm_field_enum(hsize_type,HSIZE,UVM_ALL_ON)
     `uvm_field_enum(hburst_type,HBURST,UVM_ALL_ON)
     `uvm_field_queue_enum(htrans_type,HTRANS,UVM_ALL_ON)
     `uvm_field_queue_int(HWDATA,UVM_ALL_ON)
     `uvm_field_queue_int(HRDATA,UVM_ALL_ON)
     `uvm_field_int(HREADYOUT,UVM_ALL_ON)
     `uvm_field_enum(hresp_type,HRESP,UVM_ALL_ON)
     `uvm_field_int(PADDR,UVM_ALL_ON)
     `uvm_field_int(PWDATA,UVM_ALL_ON)
     `uvm_field_int(PRDATA,UVM_ALL_ON)
    `uvm_object_utils_end
  
  function new(string name = "ahb2apb_transaction");
    super.new(name);
    `uvm_info("m_sequence_item_class","inside constructor",UVM_LOW)
  endfunction
  
  
endclass
