// top module
//Author:- Upvit Sakariya
//----------------------

import uvm_pkg::*;
`include "ahb_interface.sv"
`include "apb_interface.sv"
`include "uvm_macros.svh"

import ahb2apb_pkg::*;

module ahb2apb_top;


logic clk,resetn;
  
  ahb_intf ahb_pintf(clk,resetn);
  apb_intf apb_pintf(clk,resetn);
  
  top dut(.HADDR(ahb_pintf.HADDR),.HWDATA(ahb_pintf.HWDATA),.HTRANS(ahb_pintf.HTRANS),.HREADYin(ahb_pintf.HREADY),.HWRITE(ahb_pintf.HWRITE),.HRESP(ahb_pintf.HRESP),.HRDATA(ahb_pintf.HRDATA),.HREADYout(ahb_pintf.HREADYOUT),.HSIZE(ahb_pintf.HSIZE),.HRESETn(resetn),.HCLK(clk),.PADDR(apb_pintf.PADDR),.PWDATA(apb_pintf.PWDATA),.PSEL(apb_pintf.PSEL),.PWRITE(apb_pintf.PWRITE),.PENABLE(apb_pintf.PENABLE),.PRDATA(apb_pintf.PRDATA));

  initial begin
    uvm_config_db#(virtual apb_intf)::set(null,"*","apb_vif",apb_pintf);
    uvm_config_db#(virtual ahb_intf)::set(null,"*","ahb_vif",ahb_pintf);
  end
  
   initial begin
    clk = 1;
    forever #5 clk = ~clk;
   end
  
   initial begin
    resetn = 0;
     repeat(2)@(posedge clk);
    resetn = 1;
   end 
  
   initial begin
    reset(); 
    run_test("ahb2apb_test");
   end
  
  function void reset();
    
   //apb interface signals	
   apb_pintf.PSEL = 0;
   apb_pintf.PWRITE = 0;
   apb_pintf.PREADY = 0;
   apb_pintf.PADDR = 0;
   apb_pintf.PWDATA = 0;
   apb_pintf.PRDATA = 0;
   apb_pintf.Pslverr = 0;
   apb_pintf.PENABLE = 0; 

   //ahb interface signals
   ahb_pintf.HADDR = 0;
   ahb_pintf.HWDATA = 0;
   ahb_pintf.HBURST = 0;
   ahb_pintf.HSIZE = 0;
   ahb_pintf.HTRANS = 0;
   ahb_pintf.HWRITE = 0;
   ahb_pintf.HRESP = 0;
   ahb_pintf.HREADY = 0;
   ahb_pintf.HREADYOUT = 0;
   ahb_pintf.HRDATA = 0; 
    

    
  endfunction
  
  

endmodule
