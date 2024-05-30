class ahb2apb_base_seq extends uvm_sequence#(ahb2apb_transaction);

   `uvm_object_utils(ahb2apb_base_seq)
    bit [31:0]addr_queue[$];
	int size_queue[$];;

   function new(string name = "ahb2apb_base_seq");
    super.new(name);
    `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
   endfunction

endclass


