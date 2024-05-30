/*
1. interface has encapsulated all the signals which are required for the communication between master and slave.
*/

interface apb_interface(input logic clk,resetn);
  
  logic [31:0]PADDR;
  logic PSEL1,PSEL2,PSEL3,PSEL4;
  logic PWRITE;
  logic [31:0]PWDATA;
  logic [31:0]PRDATA;
  logic PENABLE;
  logic PREADY;
  logic Pslverr;

  clocking sdrv_cb @(posedge clk);
   default input #(0) output #(1);

   output PADDR,PSEL1,PSEL2,PSEL3,PSEL4,PWRITE,PWDATA,PENABLE,Pslverr;

  endclocking


  clocking smon_cb @(posedge clk);
   default input #(1) output #(0);

   input PADDR,PSEL1,PSEL2,PSEL3,PSEL4,PWRITE,PWDATA,PENABLE;
   input PRDATA,PREADY,Pslverr;

  endclocking

  
  
endinterface
