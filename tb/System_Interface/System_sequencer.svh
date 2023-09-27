// -----------------------------------------------------------------------------
// Module name: System_sequencer
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Generates data transactions and sends them to the driver to execute them
// Date       : July, 2023
// -----------------------------------------------------------------------------

class System_sequencer extends uvm_sequencer#(System_item);

`uvm_component_utils(System_sequencer)

function new(string name = "System_sequencer", uvm_component parent);
    super.new(name, parent);
endfunction

endclass: System_sequencer