// -----------------------------------------------------------------------------
// Module name: System_agent
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: System agent (active) encapsulates a monitor, sequencer and driver for the reset signal in the System Interface.
// Date       : July, 2023
// -----------------------------------------------------------------------------

class System_agent extends uvm_agent;

    `uvm_component_utils (System_agent) // register the class with the factory using a macro

    function new (string name = "System_agent", uvm_component parent = null); // define a constructor with name and parent parameters
        super.new(name, parent); // call the base class constructor
    endfunction
    
    System_driver System_drv; // declare a driver component
    System_sequencer System_seq; // declare a sequencer component
    System_monitor System_mon; // declare a monitor component
    
    virtual function void build_phase(uvm_phase phase); // define a build_phase function
        if(get_is_active()) begin // check if the agent is active
            System_seq        = System_sequencer              ::type_id::create("System_seq",           this); // create an instance of the sequencer using the factory
            System_drv        = System_driver                 ::type_id::create("System_drv",           this); // create an instance of the driver using the factory
        end
    
        System_mon = System_monitor::type_id::create("System_mon", this); // create an instance of the monitor using the factory
    
    endfunction
    
    virtual function void connect_phase (uvm_phase phase); // define a connect_phase function
        if(get_is_active()) // check if the agent is active
        System_drv.seq_item_port.connect(System_seq.seq_item_export); // connect the driver and sequencer ports
    endfunction

endclass: System_agent