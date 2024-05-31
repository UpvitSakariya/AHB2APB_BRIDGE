class ahb2apb_wrap16_seq extends ahb2apb_base_seq;

  `uvm_object_utils(ahb2apb_wrap16_seq)


  function new(string name = "ahb2apb_wrap16_seq");
   super.new(name);
   `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
  endfunction


  task body();
   `uvm_info(get_type_name(),"inside body task",UVM_LOW)

   repeat(1)begin
   
   req = ahb2apb_transaction::type_id::create("req");
   start_item(req);

    assert(req.randomize() with {req.HBURST==WRAP16;req.HSIZE==BYTE4;req.HWRITE==1;});
   `uvm_info(get_type_name(),"-------generated packet----------",UVM_LOW)
    req.print();

   finish_item(req);

   end


  endtask

endclass

