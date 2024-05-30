/*
1. interface has encapsulated all the signals which are required for the communication between master and slave.
*/

interface ahb_intf(input logic clk,resetn);
  
  logic [31:0]HADDR;
  logic [31:0]HWDATA;
  logic [2:0]HBURST;
  logic [2:0]HSIZE;
  logic [1:0]HTRANS;
  logic [1:0]HRESP;
  logic HWRITE;
  logic HREADY;
  logic HREADYOUT;
  logic [31:0]HRDATA;

  clocking mdrv_cb @(posedge clk);
   default input #0 output #1;

   output HADDR,HWDATA,HWRITE,HBURST,HSIZE,HTRANS;
   input HREADYOUT,HRESP,HRDATA;

  endclocking

  clocking mmon_cb @(posedge clk);
   default input #1 output #0;

   input HADDR,HWDATA,HWRITE,HBURST,HSIZE,HTRANS;
   input HREADYOUT,HRESP,HRDATA;

  endclocking

  
  
endinterface
