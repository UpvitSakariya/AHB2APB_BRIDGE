module ahb_slave(HADDR,HWDATA,HTRANS,HREADYin,HWRITE,HRESP, HRDATA,
		HSIZE,HCLK,HRESETn,HADDR_1,HWDATA_1,HADDR_2,HWDATA_2,
		HADDR_3,HWDATA_3,HWRITEreg,valid,TEMP_SEL,PRDATA);

input	[31:0]HADDR,HWDATA,PRDATA;
input	[1:0]HTRANS;
input	HREADYin,HWRITE;
input	[2:0]HSIZE;
input	HCLK,HRESETn;
	

output reg	[31:0]HADDR_1,
		HWDATA_1,
		HADDR_2,
		HWDATA_2,
		HADDR_3,
		HWDATA_3;

output 		[31:0]HRDATA;
	

output reg 	HWRITEreg,valid;
output reg	[1:0]HRESP;
output reg	[2:0]TEMP_SEL;



assign HRDATA=PRDATA;


parameter IDLE=2'b00,
	  BUSY=2'b01,
	  NONSEQ=2'b10,
	  SEQ=2'b11;

initial begin
	$display($time," Entered into ahb_slave");
end


always@(posedge HCLK,negedge HRESETn)
  begin
	HRESP=0;

	if(~HRESETn)
       	 begin
	  $display($time," all address signals are reseted::Hresetn = %0d",HRESETn);
      HADDR_1<=0;
	  HADDR_2<=0;
	  HADDR_3<=0;
	 end

	
	else
	  begin
	    HADDR_1<=HADDR;
	    HADDR_2<=HADDR_1;
	    HADDR_3<=HADDR_2;
    	$strobe($time,"haddr=%0d,haddr_1=%0d,haddr_2=%0d, and haddr_3=%0d",HADDR,HADDR_1,HADDR_2,HADDR_3);
	  end
 end


always@(posedge HCLK, negedge HRESETn)
  begin
	if(~HRESETn)
	  begin
	    HWDATA_1<=0;
	    HWDATA_2<=0;
	    HWDATA_3<=0;
	  end

	else
	  begin
	   HWDATA_1<=HWDATA;
	   HWDATA_2<=HWDATA_1;
	   HWDATA_3<=HWDATA_2;
       $strobe($time,"hwdata=%0d,hwdata_1=%0d,hwdata_2=%0d, and hwdata_3=%0d",HWDATA,HWDATA_1,HWDATA_2,HWDATA_3);
	  end
  end


always@(posedge HCLK, negedge HRESETn)
  begin
	if(~HRESETn)
	   HWRITEreg<=0;
	else
	   HWRITEreg<=HWRITE;
	$display($time," Entered into ahb_slave::HWRITEreg=%0d",HWRITEreg);
  end
       

always@(*)
  begin
    if(~HRESETn)
       valid=0;
    
    else if((HADDR>=32'h4000_0000 && HADDR<= 32'h4000_FFFF) /*&&  (HTRANS==NONSEQ || HTRANS==SEQ)*/)begin
         valid=1'b1;
	    $display($time," ----------------------------------------------haddr is in the range and setted::valid=%0d*********************************8",valid);
	end
    else
         valid=1'b0;
   end


always@(*)
  begin

   
     if(( HADDR>=32'h4000_2000 && HADDR<= 32'h4000_2FFF))begin
		TEMP_SEL=3'b100;
	    $display($time," TEMP_SEL=%0d",TEMP_SEL);
	 end	
	 else if((HADDR>=32'h4000_1000 && HADDR<= 32'h4000_1FFF))begin
		TEMP_SEL=3'b010;
	    $display($time," TEMP_SEL=%0d",TEMP_SEL);
	 end
 	 else if((HADDR>=32'h4000_0000 && HADDR<= 32'h4000_0FFF))begin
		TEMP_SEL=3'b001;
	    $display($time," TEMP_SEL=%0d",TEMP_SEL);
	 end
	//secure purpose , modified
//	else TEMP_SEL=3'b000;
		
	 
  end
endmodule



 
     
    








	
	    
	









	
	
	
	
