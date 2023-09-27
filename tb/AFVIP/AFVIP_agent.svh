// -----------------------------------------------------------------------------
// Module name: AFVIP_agent
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Interrupt agent (passive) encapsulates a monitor for the interrupt signal in the System Interface.
// Date       : July, 2023
// -----------------------------------------------------------------------------

class AFVIP_agent extends uvm_agent;

    `uvm_component_utils (AFVIP_agent) // register the class with the factory using a macro

    function new (string name = "AFVIP_agent", uvm_component parent = null); // define a constructor with name and parent parameters
        super.new(name, parent); // call the base class constructor
    endfunction

    AFVIP_monitor AFVIP_mon; // declare a monitor component

    virtual function void build_phase(uvm_phase phase); // define a build_phase function
        AFVIP_mon = AFVIP_monitor::type_id::create("AFVIP_mon", this); // create an instance of the monitor using the factory
    endfunction

    virtual function void connect_phase (uvm_phase phase); // define a connect_phase function
     //   AFVIP_drv.seq_item_port.connect(AFVIP_seq.seq_item_export);
    endfunction

endclass: AFVIP_agent