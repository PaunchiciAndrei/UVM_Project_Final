// -----------------------------------------------------------------------------
// Module name: afvip_top
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Connect all the interfaces and the DUT so that the DUT can be tested
// Date       : July, 2023
// -----------------------------------------------------------------------------

module  afvip_top;
    // Import the UVM package and the Test_pkg package
    import uvm_pkg::*;
    import Test_pkg::*;
    
    // Include the UVM macros file
    `include "uvm_macros.svh"
    
    // Declare logic signals for the clock, reset, and interrupt
    logic clk               ;
    logic rst_n             ;
    logic afvip_intr        ;

    // Declare logic signals for the APB interface
    logic            psel   ;
    logic            penable;
    logic   [15:0]   paddr  ;
    logic            pwrite ;
    logic   [31:0]   pwdata ;
    logic            pready ;
    logic   [31:0]   prdata ;
    logic            pslverr;
    // Declare a string variable for the test name
    string           TEST_NAME;

// Assign the afvip_intr signal to the System interface
assign   System.afvip_intr = afvip_intr    ;
// Assign the APB interface signals to the corresponding signals
assign   psel              = APB.psel      ;
assign   penable           = APB.penable   ;
assign   paddr             = APB.paddr     ;
assign   pwrite            = APB.pwrite    ;
assign   pwdata            = APB.pwdata    ;
assign   APB.pready        = pready        ;
assign   APB.prdata        = prdata        ;
assign   APB.pslverr       = pslverr       ;
// Assign the TEST_NR signal to the APB interface
assign   APB.TEST_NR       = TEST_NR       ;  

    // Define an initial block to generate the clock signal
    initial begin
        // Initialize the clock signal to 0
        clk=0;
        // Repeat forever
        forever
            // Wait for 5 time units and toggle the clock signal
            #5 clk=!clk;
    end
    

    // Instantiate an APB_if object named APB and connect it to the clock and reset signals
    APB_if APB(

    .clk   (clk),
    .rst_n (rst_n)
);
     // Instantiate a System_if object named System and connect it to the clock and reset signals
     System_if System(
    .clk   (clk),
    .rst_n (rst_n)
);

     // Instantiate a System_if object named AFVIP and connect it to the clock and reset signals
     System_if AFVIP(
    .clk   (clk),
    .rst_n (rst_n)
);

     // Instantiate an afvip module named DUT and connect it to the APB interface, System interface, clock, reset, and interrupt signals
     afvip #(
     // Set the TP parameter to 1 
     .TP(1) 
)DUT(   
.psel  (psel),
.penable(penable),
.paddr(paddr),
.pwrite(pwrite),
.pwdata(pwdata),
.pready(pready),
.prdata(prdata),
.pslverr(pslverr),
.clk   (clk),
.rst_n (rst_n),
.afvip_intr (afvip_intr)

);

     // Declare a logic variable named TEST_NR to select the test desired to run on the DUT
     logic   [15:0]   TEST_NR=5;
     
     // Define an initial block to set up the test environment and run the test
     initial begin
         // Use a case statement to assign the test name based on the value of TEST_NR
         case(TEST_NR)
             0: TEST_NAME = "write_all_read_all"; 
             1: TEST_NAME = "read_write_all";
             2: TEST_NAME = "write_all_read_one";
             3: TEST_NAME = "write_one_read_all";
             4: TEST_NAME = "config_overlap";
             5: TEST_NAME = "Operation_test";
             6: TEST_NAME = "Reset_test";
             7: TEST_NAME = "Full_Coverage_Test";
         endcase

         // Set the configuration database for the virtual interfaces of the agents
         uvm_config_db #(virtual APB_if)    :: set(null, "*.m_APB_agent.*","APB_if", APB);
         uvm_config_db #(virtual System_if) :: set(null, "*.m_System_agent.*","System_if", System);
         uvm_config_db #(virtual System_if) :: set(null, "*.m_AFVIP_agent.*","System_if", System);

         // Run the test with the test name as the argument
         run_test(TEST_NAME);

     end  
     endmodule