// -----------------------------------------------------------------------------
// Module name: System_monitor
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Monitors the reset signal from the driver
// Date       : July, 2023
// -----------------------------------------------------------------------------

class System_monitor extends uvm_monitor;

    `uvm_component_utils (System_monitor)

        function new(string name= "System_monitor", uvm_component parent= null);
    
            super.new(name, parent);
            
            endfunction
    
    // Declare a virtual interface handle to access the system signals
    virtual System_if System;
    
    // Declare an analysis port to broadcast the transactions to other components
    uvm_analysis_port #(System_item) mon_analysis_port;
    
    // Override the build_phase method to create the analysis port and get the interface handle from the configuration database
    virtual function void build_phase(uvm_phase phase);
        super.build_phase (phase);
    
        // Create the analysis port with a name and a parent
        mon_analysis_port = new("mon_analysis_port", this);
    
        // Get the interface handle from the configuration database using a scope, an instance name, and a variable name
        if(!uvm_config_db #(virtual System_if) ::get(this,"","System_if",System))
        begin
            // Report an error if the interface handle is null
            `uvm_error(get_type_name(), "Interface not found!")
        end
    endfunction
    
    // Override the run_phase task to monitor the transactions on the system interface
    virtual task run_phase(uvm_phase phase);
        // Create a System_item object
        System_item System_i = System_item::type_id::create("System_i", this);
        
        // Sample the reset signal from the interface using a clocking block
        System_i.rst_n= System.System_mon.rst_n;
        
        // Write the transaction to the analysis port
        mon_analysis_port.write(System_i);
    endtask
    
    // End of class definition
    endclass: System_monitor
    