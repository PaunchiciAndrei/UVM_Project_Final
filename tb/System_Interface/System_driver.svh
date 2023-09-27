// -----------------------------------------------------------------------------
// Module name: System_driver
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Drives signals to the DUT useing a virtual interface
// Date       : July, 2023
// -----------------------------------------------------------------------------

class System_driver extends uvm_driver#(System_item);

    `uvm_component_utils (System_driver)

    function new(string name= "System_driver", uvm_component parent = null);
        // Call the super class constructor with the same arguments
        super.new (name, parent);
    endfunction

    // Declare the System interface
    virtual System_if System;

    // Define a build phase function that takes a phase as an argument
    virtual function void build_phase(uvm_phase phase);
        // Call the super class build phase function with the same argument
        super.build_phase(phase);
        // Get the handle to the virtual interface from the configuration database
        if(!uvm_config_db #(virtual System_if) :: get (this,"","System_if",System))begin
        // If the handle is not found, report a fatal error with a message
        `uvm_fatal (get_type_name(), "Didn't get handle to virtual interface!")
        end
    endfunction

    // Define a run phase task that takes a phase as an argument
    virtual task run_phase (uvm_phase phase);
        // Declare System items
        System_item System_i;

        // Repeat indefinitely
        forever begin
            // Print an informational message to indicate that the driver is writing to the bus
            `uvm_info(get_type_name(), $sformatf ("Writeing..."), UVM_MEDIUM)
            // Get the next item from the sequencer using the seq_item_port port
            seq_item_port.get_next_item(System_i);
             // Drive the reset signal on the bus using the value from System_i
            System.rst_n<=System_i.rst_n;
            // Indicate that the item is done using the seq_item_port port
            seq_item_port.item_done();
        end
    endtask
endclass