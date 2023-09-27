// -----------------------------------------------------------------------------
// Module name: System_sequences
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Sequences library to test the DUT functionality with the reset
// Date       : July, 2023
// -----------------------------------------------------------------------------

class System_sequence extends uvm_sequence;

    // Register the class with the UVM factory
    `uvm_object_utils (System_sequence)

    // Define a constructor that takes a string argument for the name of the object
    function new (string name = "System_sequence");
        // Call the constructor of the parent class with the name argument
        super.new (name);
    endfunction

    // Define a virtual task named body that will be executed by the sequencer
    virtual task body ();
    // Leave the body empty as it will be overridden by the child classes
    endtask : body

endclass : System_sequence

// Declare a class named Start_test that extends System_sequence
class Start_test extends System_sequence;
    // Register the class with the UVM factory
    `uvm_object_utils (Start_test)

    // Define a constructor that takes a string argument for the name of the object
    function new (string name = "Start_test");
        // Call the constructor of the parent class with the name argument
        super.new (name);
    endfunction

    // Define a virtual task named body that will be executed by the sequencer
    virtual task body();
        
        // Declare System item 
        System_item item;
        // Create an object of type System_item and assign it to item
        item = System_item::type_id::create("item");

        // Start a transaction with item as the sequence item
        start_item(item);
        // Set the rst_n field of item to 0, which means reset is active
        item.rst_n=0;
        // Finish the transaction and send item to the driver
        finish_item(item);

        // Wait for 10 time units
        #10

        // Start another transaction with item as the sequence item
        start_item(item);
        // Set the rst_n field of item to 1, which means reset is inactive
        item.rst_n=1;
        // Finish the transaction and send item to the driver
        finish_item(item);

    // End the task definition
    endtask: body
// End the class definition
endclass: Start_test

// Declare a class named Reset_tester that extends System_sequence
class Reset_tester extends System_sequence;
    // Register the class with the UVM factory
    `uvm_object_utils (Reset_tester)

    // Define a constructor that takes a string argument for the name of the object
    function new (string name = "Reset_tester");
        // Call the constructor of the parent class with the name argument
        super.new (name);
    endfunction

    // Define a virtual task named body that will be executed by the sequencer
    virtual task body();

        // Declare a variable named item of type System_item
        System_item item;
        // Create an object of type System_item and assign it to item
        item = System_item::type_id::create("item");

                #1555318
        // Wait for ^ time units, which simulates a random reset event

        // Start a transaction with item as the sequence item
        start_item(item);
        // Set the rst_n field of item to 0, which means reset is active
        item.rst_n=0;
        // Finish the transaction and send item to the driver
        finish_item(item);
        
        // Wait for 1000 time units
        #1000

        // Start another transaction with item as the sequence item
        start_item(item);
        // Set the rst_n field of item to 1, which means reset is inactive
        item.rst_n=1;
        // Finish the transaction and send item to the driver
        finish_item(item);

    endtask: body
  
endclass: Reset_tester