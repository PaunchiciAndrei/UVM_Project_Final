// -----------------------------------------------------------------------------
// Module name: APB_sequencer
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Generates data transactions and sends them to the driver to execute them
// Date       : July, 2023
// -----------------------------------------------------------------------------

class APB_sequencer extends uvm_sequencer#(APB_item);

`uvm_component_utils(APB_sequencer)

function new(string name = "APB_sequencer", uvm_component parent);
    super.new(name, parent);
endfunction

endclass: APB_sequencer