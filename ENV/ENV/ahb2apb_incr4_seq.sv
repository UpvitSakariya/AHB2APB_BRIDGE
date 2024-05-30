class ahb2apb_incr4_seq extends ahb2apb_base_seq;

  `uvm_object_utils(ahb2apb_incr4_seq)


  function new(string name = "ahb2apb_incr4_seq");
   super.new(name);
   `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
  endfunction


  task body();
   `uvm_info(get_type_name(),"inside body task",UVM_LOW)

   repeat(2)begin
   
   req = ahb2apb_transaction::type_id::create("req");
   start_item(req);

    assert(req.randomize() with {req.HBURST==INCR4;req.HSIZE==BYTE4;req.HWRITE==1;});
	addr_queue.push_back(req.HADDR);
   `uvm_info(get_type_name(),"-------generated packet----------",UVM_LOW)
    req.print();

   finish_item(req);

   end

   #110;

   repeat(2)begin
   
   req = ahb2apb_transaction::type_id::create("req");
   start_item(req);

    assert(req.randomize() with {req.HADDR==addr_queue[0];req.HBURST==INCR4;req.HSIZE==BYTE4;req.HWRITE==0;});
	addr_queue = addr_queue[1:$];
   `uvm_info(get_type_name(),"-------generated packet----------",UVM_LOW)
    req.print();

   finish_item(req);


   end



  endtask

endclass

