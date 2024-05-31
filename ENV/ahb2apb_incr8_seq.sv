class ahb2apb_incr8_seq extends ahb2apb_base_seq;

  `uvm_object_utils(ahb2apb_incr8_seq)


  function new(string name = "ahb2apb_incr8_seq");
   super.new(name);
   `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
  endfunction


  task body();
   `uvm_info(get_type_name(),"inside body task",UVM_LOW)

   repeat(2)begin
   
   req = ahb2apb_transaction::type_id::create("req");
   start_item(req);

    assert(req.randomize() with {req.HBURST==INCR8;req.HSIZE==BYTE4;req.HWRITE==1;});
	addr_queue.push_back(req.HADDR);
   `uvm_info(get_type_name(),"-------generated packet----------",UVM_LOW)
    req.print();

   finish_item(req);


   end

   #350;

   repeat(2)begin
   
   req = ahb2apb_transaction::type_id::create("req");
   start_item(req);
    //req.HWDATA.rand_mode(0);
    //req.data.constraint_mode(0);
    //req.beat1.constraint_mode(0);
    assert(req.randomize() with {req.HADDR==addr_queue[0];req.HBURST==INCR8;req.HSIZE==BYTE4;req.HWRITE==0;});
	addr_queue = addr_queue[1:$];
   `uvm_info(get_type_name(),"-------generated packet----------",UVM_LOW)
    req.print();

   finish_item(req);


   end 




  endtask

endclass

