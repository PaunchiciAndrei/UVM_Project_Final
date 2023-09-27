// -----------------------------------------------------------------------------
// Module name: APB_monitor
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Monitors the APB signals of the DUT and from the driver
// Date       : July, 2023
// -----------------------------------------------------------------------------

class APB_monitor extends uvm_monitor;

    `uvm_component_utils (APB_monitor)
    
    // Declare a virtual interface handle to access the APB bus signals
    virtual APB_if APB_int;
    
    // Declare an analysis port to broadcast the transactions to other components
    uvm_analysis_port #(APB_item) mon_analysis_port;
    
    // Define a constructor that takes a name and a parent as arguments and calls the super constructor
    function new(string name= "APB_monitor", uvm_component parent= null);
    
    super.new(name, parent);
    
    endfunction
    
    // Override the build_phase method to create the analysis port and get the interface handle from the configuration database
    virtual function void build_phase(uvm_phase phase);
        super.build_phase (phase);
    
        // Create the analysis port with a name and a parent
        mon_analysis_port = new("mon_analysis_port", this);
    
        // Get the interface handle from the configuration database using a scope, an instance name, and a variable name
        if(!uvm_config_db #(virtual APB_if) ::get(this,"","APB_if",APB_int))
        begin
            // Report an error if the interface handle is null
            `uvm_error(get_type_name(), "Interface not found!")
        end
    endfunction
    
    // Override the run_phase task to monitor the transactions on the APB bus
    virtual task run_phase(uvm_phase phase);
    
        // Create an APB_item object
        APB_item APB_itm = APB_item::type_id::create("APB_itm", this);
        forever begin
    
        // Sample the test number and reset signals from the interface
        APB_itm.TEST_NR  = APB_int.TEST_NR;
        APB_itm.reset  = APB_int.rst_n;
    
        // Wait for a valid transfer on the bus using a clocking block and an event expression
        @(APB_int.APB_mon iff APB_int.penable && APB_int.psel && APB_int.pready);
    
        // Sample the rest of the signals from the interface
        APB_itm.psel    = APB_int.psel;
        APB_itm.penable = APB_int.penable;
        APB_itm.paddr   = APB_int.paddr;
        APB_itm.pwrite  = APB_int.pwrite;
        APB_itm.pwdata  = APB_int.pwdata;
        APB_itm.prdata  = APB_int.prdata;
    
        // Extract some fields from the write data signal if the address is 16'h80
        if(APB_int.paddr == 16'h80) begin
        APB_itm.opcode  = APB_int.pwdata [2 :0] ; // Opcode for the instruction
        APB_itm.rs0     = APB_int.pwdata [7 :3] ; // Source register 0 for the instruction
        APB_itm.rs1     = APB_int.pwdata [12:8] ; // Source register 1 for the instruction
        APB_itm.dst     = APB_int.pwdata [20:16]; // Destination register for the instruction
        APB_itm.imm     = APB_int.pwdata [31:24]; // Immediate value for the instruction
        end
        
       // Print some information about the transaction using `uvm_info`
       `uvm_info("APB_monitor",$sformatf("APB_Monitor:%s", APB_itm.sprint()),UVM_NONE)
       
       // Write the transaction to the analysis port
       mon_analysis_port.write(APB_itm);
       
       end
    
    endtask

    endclass: APB_monitor