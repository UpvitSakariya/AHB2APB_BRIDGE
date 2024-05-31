module fsm(HADDR_1,HADDR_2,HADDR_3,HWDATA_1,HWDATA_2,HWDATA_3,HWRITE,HWRITEreg,HSIZE,
           TEMP_SEL,valid,PADDR,PWDATA,PSEL,PWRITE,PENABLE,HCLK,HRESETn,HTRANS,HREADYout);

input	[31:0]HADDR_1,
	      HADDR_2,
	      HADDR_3,

	      HWDATA_1,
	      HWDATA_2,
	      HWDATA_3;

input	[1:0]HTRANS;
input	[2:0]HSIZE,
	     TEMP_SEL;

input	HRESETn,
	HCLK,
	valid,
	HWRITE,
	HWRITEreg;


output reg	[31:0]PADDR,
		      PWDATA;
output reg	[2:0]PSEL;
output reg	PWRITE,
		PENABLE,
		HREADYout;

reg [2:0]STATE,NX_STATE;
reg tmp;


parameter	ST_IDLE=3'b000,
		ST_WWAIT=3'b001,
		ST_READ=3'b010,
		ST_WRITE=3'b011,
		ST_WRITEP=3'b100,
		ST_RENABLE=3'b101,
		ST_WENABLE=3'b110,
		ST_WENABLEP=3'b111;

initial begin
	$display($time," Entered into RTL fsm");
end

always@(posedge HCLK, negedge HRESETn)
begin
  if(~HRESETn)begin
    STATE<=ST_IDLE;
	$strobe($time," ------------------------Entered into if part::STATE=%0d, and Hreadyout = %0d",STATE,HREADYout);
  end
  else begin
    STATE<=NX_STATE;
	$strobe($time," ------------------------Entered into else part::STATE=%0d",STATE);
  end
end



always@(*)
 begin

      NX_STATE=ST_IDLE;
	PSEL = 0;
	PENABLE = 0;
	HREADYout = 0;
        PWRITE = 0;
	case(STATE)

         ST_IDLE:begin
	          PSEL=0;
		  PENABLE=0;
		  HREADYout= 0; // made changes here it was Hreadyout = 1; 

		  if(~valid)begin
		    NX_STATE=ST_IDLE;
			$display($time," Entered into if valid=0 part::NX_STATE=%0d----------------------",NX_STATE);
		  end
		  else if(valid && HWRITE)begin
		    NX_STATE=ST_WWAIT;
			$display($time," Entered into else if part::valid=1 valid=%0d && HWRITE=%0d NX_STATE=%0d, Hreadyout=%0d----------------",valid,HWRITE,NX_STATE,HREADYout);
		  end
		  else begin
		    NX_STATE=ST_READ;
			$display($time," Entered into else part::NX_STATE=%0d---------------------",NX_STATE);
		  end
		end

	 ST_WWAIT:begin
		  
		  HREADYout=1'b1;
	//	  PSEL=0;
		  PENABLE=0;
          tmp=1;

		  if(~valid)begin
		    NX_STATE=ST_WRITE;
			$display($time," -------Entered into valid=0::if part::NX_STATE=%0d, Hreadyout=%0d",NX_STATE,HREADYout);
		  end
		  else if(valid)begin
		    NX_STATE=ST_WRITEP;
			$display($time," -------Entered into valid=1::else part::NX_STATE=%0d, and HREADYout=%0d",NX_STATE,HREADYout);
		  end
		end


	ST_READ: begin
		 PSEL=TEMP_SEL;
		 PENABLE=1'b0;
		 PADDR=HADDR_1;
		 PWRITE=1'b0;
		 HREADYout=1'b0;
		 
		 $display($time," ----------Entered inside a ST_READ::STATE=%0d and PADDR=%0h, and PWRITE=%0d",STATE,PADDR,PWRITE);
		 NX_STATE=ST_RENABLE;
		 $display($time," ----------will Entered into ST_RENABLE::NX_STATE=%0d",NX_STATE);
		end


	ST_WRITE:begin
		 PSEL=TEMP_SEL;
		 PADDR=HADDR_2;
		 PWRITE=1'b1;
		 PWDATA=HWDATA_1;
		 PENABLE=1'b0;
		 $display($time," Entered inside a ST_READ::STATE=%0d",STATE);
		  if(~valid)begin
		      NX_STATE=ST_WENABLE;
		      $display($time," -------will Entered into ST_WENABLE::NX_STATE=%0d",NX_STATE);
		  end
		  else if(valid)begin
		      NX_STATE=ST_WENABLEP;
		      $display($time," -------will Entered into ST_WENABLEP::NX_STATE=%0d",NX_STATE);
		  end
		 end


	ST_WRITEP: begin
		//	if()
		//	   PADDR=HADDR_2;
		//	else
			if(tmp == 1)begin
			PADDR=HADDR_2;
		    $display($time," 1*********** entered if tmp=1 and addr is::::PADDR=%0h",PADDR);
			end
			else begin
			PADDR=HADDR_3;
		    $display($time," 2*********** entered if tmp=0 and addr is::::PADDR=%0h",PADDR);
			end
			PSEL=TEMP_SEL;
			PENABLE=1'b1; // made changes it was penable =0;
			PWRITE=1'b1;
			PWDATA=HWDATA_1;
		    HREADYout=1'b0; 

		    $display($time," ***********Entered inside ST_WRITEP::STATE=%0d, and hreadyout = %0d",STATE,HREADYout);
			NX_STATE=ST_WENABLEP;
		    $display($time," ***********will Entered into ST_WENABLE::NX_STATE=%0d,PADDR=%0h,PWDATA=%0h",NX_STATE,PADDR,PWDATA);
               end


	ST_RENABLE: begin
		     PENABLE=1'b1;
		     PSEL=TEMP_SEL;
		     PWRITE=1'b0;
		     HREADYout=1'b1;
		     $display($time," Entered inside a ST_RENABLE::STATE=%0d********",STATE);

		      if(~valid)begin
				NX_STATE=ST_IDLE;
		    	$display($time," will Entered into ST_IDLE::NX_STATE=%0d********",NX_STATE);
			  end
		      else if(valid && ~HWRITE)begin
				NX_STATE=ST_READ;
		    	$display($time," will Entered into ST_READ::NX_STATE=%0d*******",NX_STATE);
			  end
		      else if(valid && HWRITE)begin
				NX_STATE=ST_WWAIT;
		    	$display($time," will Entered into ST_WWAIT::NX_STATE=%0d******",NX_STATE);
			  end
		   end

	ST_WENABLE: begin
		      PENABLE=1'b1;
		      PSEL=TEMP_SEL;
		      PWRITE=1'b1;
		      HREADYout=1'b1;
		     $display($time," Entered inside a ST_WENABLE::STATE=%0d*********",STATE);

			if(valid && ~HWRITE)begin
				NX_STATE=ST_READ;
		    	$display($time," will Entered into ST_READ::NX_STATE=%0d**********",NX_STATE);
			end
		    else if(~valid)begin
				NX_STATE=ST_IDLE;
		    	$display($time," will Entered into ST_IDLE::NX_STATE=%0d*******",NX_STATE);
			end
		    else if(valid && HWRITE)begin
				NX_STATE=ST_WWAIT;
		    	$display($time," will Entered into ST_WWAIT::NX_STATE=%0d*******",NX_STATE);
			end

		    end

	ST_WENABLEP: begin
			tmp=0;
		       PSEL=TEMP_SEL;
		       PENABLE=1'b0; // made changes it was penable = 1;
		       PWRITE=1'b1;
		       HREADYout=1'b1;
		//	PADDR=HADDR_3;
		//	PWDATA=HWDATA_3;
		//HREADYout=1'b0;
		     $display($time," *********Entered inside a ST_WENABLEP::STATE=%0d, and HREADYout=%0d******",STATE,HREADYout);

		       
		       if(~HWRITEreg)begin
				NX_STATE=ST_READ;
		    	$display($time," *******will Entered into ST_READ::NX_STATE=%0d********",NX_STATE);
			   end
		       else if(~valid && HWRITEreg)begin
				NX_STATE=ST_WRITE;
		    	$display($time," *****will Entered into ST_WRITE::NX_STATE=%0d*******8",NX_STATE);
			   end
		       else if(valid && HWRITEreg)begin
				NX_STATE=ST_WRITEP;
		    	$display($time," *******will Entered into ST_WRITEP::NX_STATE=%0d********8",NX_STATE);
			   end
		     end
		 default:NX_STATE=ST_IDLE;
		endcase
             end
          
endmodule		    
		





	
