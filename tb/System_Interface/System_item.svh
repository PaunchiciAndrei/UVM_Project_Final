// -----------------------------------------------------------------------------
// Module name: System_item
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Declare the reset item and register it in the UVM
// Date       : July, 2023
// -----------------------------------------------------------------------------

class System_item extends uvm_sequence_item;

rand bit rst_n; // reset signal

// Register the class with the UVM and enable automatic field access methods

`uvm_object_utils_begin (System_item)
  `uvm_field_int (rst_n, UVM_DEFAULT) // Register rst_n field with default access policy
`uvm_object_utils_end

function new (string name="");

super.new(name);

endfunction: new

endclass: System_item