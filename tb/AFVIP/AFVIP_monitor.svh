// -----------------------------------------------------------------------------
// Module name: AFVIP_monitor
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Monitors the interrupt signal
// Date       : July, 2023
// -----------------------------------------------------------------------------

class AFVIP_monitor extends uvm_monitor;

    `uvm_component_utils (AFVIP_monitor)
    
    // Declare the System interface
    virtual System_if AFVIP;
    
    // Declare an analysis port of type AFVIP_item named mon_analysis_port
    uvm_analysis_port #(AFVIP_item) mon_analysis_port;
    
    // Define a constructor function that takes a name and a parent as arguments
    function new(string name= "AFVIP_monitor", uvm_component parent= null);
    
    // Call the super class constructor with the same arguments
    super.new(name, parent);
    
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase (phase);
    
        // Create a new instance of the analysis port with a name and a parent
        mon_analysis_port = new("mon_analysis_port", this);
    
        // Get the handle to the virtual interface from the configuration database
        if(!uvm_config_db #(virtual System_if) ::get(this,"","System_if",AFVIP))
        begin
            // If the handle is not found, report an error with a message
            `uvm_error(get_type_name(), "Interface not found!")
        end
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        // Create a new instance of the AFVIP_item
        AFVIP_item AFVIP = AFVIP_item::type_id::create("AFVIP", this);
    endtask
    
    endclass: AFVIP_monitor