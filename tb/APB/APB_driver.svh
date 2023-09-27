// -----------------------------------------------------------------------------
// Module name: APB_driver
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Drives signals to the DUT useing a virtual interface
// Date       : July, 2023
// -----------------------------------------------------------------------------

class APB_driver extends uvm_driver#(APB_item);

    `uvm_component_utils (APB_driver)

    virtual APB_if APB_verif; // Declare the APB interface

    function new(string name= "APB_driver", uvm_component parent = null);
        // Call the super class constructor with the same arguments
        super.new (name, parent);
    endfunction

    // Define a build phase function that takes a phase as an argument
    virtual function void build_phase(uvm_phase phase);
        // Call the super class build phase function with the same argument
        super.build_phase(phase);
        // Get the handle to the virtual interface from the configuration database
        if(!uvm_config_db #(virtual APB_if) :: get (this,"","APB_if",APB_verif))begin
        // If the handle is not found, report a fatal error with a message
        `uvm_fatal (get_type_name(), "Didn't get handle to virtual interface!")
        end
    endfunction

    // Define a run phase task that takes a phase as an argument
    virtual task run_phase (uvm_phase phase);
        // Declare the APB item
        APB_item APB_i;
        // Wait for the reset signal to be high
        @(posedge APB_verif.rst_n);
        // Repeat indefinitely
        forever begin
            // Print an informational message to indicate that the driver is writing to the bus
            `uvm_info(get_type_name(), $sformatf ("Writing..."), UVM_MEDIUM)
            // Get the next item from the sequencer using the seq_item_port port
            seq_item_port.get_next_item(req);
            // Clone the item and cast it to an APB_item type and assign it to APB_i
            $cast(APB_i,req.clone());
    
            // Drive the select, address, write data and write enable signals on the bus using the values from APB_i
            APB_verif.APB_drv.psel       <= 1;
            APB_verif.APB_drv.paddr   <= APB_i.paddr;
            APB_verif.APB_drv.pwdata  <= APB_i.pwdata;
            APB_verif.APB_drv.pwrite  <= APB_i.pwrite;
            
            // Wait for the select signal from the monitor to be high
            @(APB_verif.APB_drv iff APB_verif.APB_mon.psel);
            // Drive the enable signal high on the bus
            APB_verif.APB_drv.penable<=1;

            // Wait for the ready signal from the monitor to be high
            @(APB_verif.APB_drv iff APB_verif.APB_drv.pready);
            // Drive the enable and select signals low on the bus
            APB_verif.APB_drv.penable<=0;
            APB_verif.APB_drv.psel<=0;

           // repeat ($urandom_range(0,10)) 
            @(APB_verif.APB_drv);

           // APB_i.prdata  <= APB_verif.APB_mon.prdata;
           //  if(APB_verif.APB_mon.pwrite)
 
 
           //  @(APB_verif.APB_drv iff APB_verif.APB_drv.pready);
           //  Drive the select and address signals on the bus using the values from APBI 
           //  APB_verif.APB_drv.psel <= 1;
           //  APB_verif.APB_drv.paddr<= APBI .paddr;
 
           //  @(APBI _verif.APB _drv);
           //  Drive the enable and write data signals on the bus using the values from A PB _i 
           //  APB_verif.APB_drv.penable<=1;
           //  APB_verif.APB_drv.pwdata  <= APB_i .pwdata;
           //  @(APB_verif.APB_drv iff APB_verif.APB_drv.pready);
           //  Drive the enable and select signals low on the bus 
           //  APB_verif.APB_drv.penable<=0;
           //  APB_verif.APB_drv.psel<=0;            
   
           //  if(!APB_verif.APB_mon.pwrite)
 
           //  @(APB_verif.APB_drv iff APB_verif.APB_drv.pready);
           //  Drive the select and address signals on the bus using the values from APB_i 
           //  APB_verif.APB_drv.psel <= 1;
           //  APB_verif.APB_drv.paddr<= APB_i.paddr;
 
           //  @(APB_verif.APB_drv);
           //  Drive the enable signal high on the bus 
           //  APB_verif.APB_drv.penable<=1;
           //  @(APB_verif.APB_drv iff APB_verif.APB_drv.pready);
           //  Drive the enable and select signals low on the bus 
           //  APB_verif.APB_drv.penable<=0;
           //  APB_verif.APB_drv.psel<=0;   

            // Display the contents of APB_i using the sprint method
            $display("%s", APB_i.sprint());

            // Indicate that the item is done using the seq_item_port port
            seq_item_port.item_done();
        end
    endtask
    
endclass