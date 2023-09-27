// -----------------------------------------------------------------------------
// Module name: AFVIP_item
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Declare the interrupt item and register it in the UVM
// Date       : July, 2023
// -----------------------------------------------------------------------------

class AFVIP_item extends uvm_sequence_item;

bit afvip_intr; // Interrupt signal

// Register the class with the UVM and enable automatic field access methods
`uvm_object_utils_begin(AFVIP_item)
  `uvm_field_int(afvip_intr,UVM_DEFAULT) // Register afvip_intr field with default access policy
`uvm_object_utils_end

function new (string name="");

super.new(name);

endfunction: new

endclass: AFVIP_item