// -----------------------------------------------------------------------------
// Module name: APB_agent
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: APB agent (active) encapsulates a monitor, sequencer and driver for the APB signals in the APB Interface.
// Date       : July, 2023
// -----------------------------------------------------------------------------

class APB_agent extends uvm_agent;

    `uvm_component_utils (APB_agent) // register the class with the factory using a macro

    function new (string name = "APB_agent", uvm_component parent = null); // constructor
        super.new(name, parent); // call the base class constructor
    endfunction
    
    APB_driver APB_drv; // declare a driver component
    APB_sequencer APB_seq; // declare a sequencer component
    APB_monitor APB_mon; // declare a monitor component
    
    virtual function void build_phase(uvm_phase phase); // build phase
        if(get_is_active()) begin // check if the agent is active
            APB_seq     = APB_sequencer              ::type_id::create("APB_seq",        this); // create the sequencer using the factory
            APB_drv     = APB_driver                 ::type_id::create("APB_drv",        this); // create the driver using the factory
        end
    
        APB_mon = APB_monitor::type_id::create("APB_mon", this); // create the monitor using the factory
    
    endfunction
    
    virtual function void connect_phase (uvm_phase phase); // connect phase
        if(get_is_active()) // check if the agent is active
        APB_drv.seq_item_port.connect(APB_seq.seq_item_export); // connect the driver's port to the sequencer's export
    endfunction

endclass: APB_agent