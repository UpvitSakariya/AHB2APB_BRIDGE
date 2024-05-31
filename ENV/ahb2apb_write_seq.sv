class ahb2apb_write_seq extends ahb2apb_base_seq;

  `uvm_object_utils(ahb2apb_write_seq)

  extern function new(string name = "ahb2apb_write_seq");

  extern task body();
  
endclass:ahb2apb_write_seq


  function ahb2apb_write_seq::new(string name = "ahb2apb_write_seq");
   super.new(name);
   `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
  endfunction


  task ahb2apb_write_seq::body();
   `uvm_info(get_type_name(),"inside body task",UVM_LOW)

   repeat(2)begin
   
   req = ahb2apb_transaction::type_id::create("req");
   start_item(req);

    assert(req.randomize() with {req.HBURST==WRAP4;req.HSIZE==BYTE4;req.HWRITE==1;});
   `uvm_info(get_type_name(),"-------generated packet----------",UVM_LOW)
    req.print();

   finish_item(req);

   end

  endtask


