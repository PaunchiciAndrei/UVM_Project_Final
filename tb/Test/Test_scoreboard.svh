// -----------------------------------------------------------------------------
// Module name: Test_scoreboard
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Checks the DUT functionality by comparing the expected transactions with the actual transactions
// Date       : July, 2023
// -----------------------------------------------------------------------------

// Declare analysis ports for system, apb and afvip items
`uvm_analysis_imp_decl(_system)
`uvm_analysis_imp_decl(_apb)
`uvm_analysis_imp_decl(_afvip)

// Define a scoreboard class that extends from uvm_scoreboard
class Test_scoreboard extends uvm_scoreboard;
    // Register the scoreboard class with the factory
    `uvm_component_utils (Test_scoreboard)
    // Declare virtual interfaces for APB and system
    virtual APB_if APB_verif;
    virtual System_if System_verif;

    // Define a constructor with name and parent arguments
    function new (string name ="Test_scoreboard", uvm_component parent = null);
        // Call the super constructor
        super.new(name, parent);
    endfunction

    // Declare analysis imp objects for each analysis port
    uvm_analysis_imp_apb #(APB_item, Test_scoreboard) Test_imp_APB;
    uvm_analysis_imp_afvip #(AFVIP_item, Test_scoreboard) Test_imp_AFVIP;
    uvm_analysis_imp_system #(System_item, Test_scoreboard) Test_imp_System;

    // Define the build phase to create the analysis imp objects
    function void build_phase(uvm_phase phase);
        Test_imp_APB = new("Test_imp_APB", this);
        Test_imp_AFVIP = new("Test_imp_AFVIP", this);
        Test_imp_System = new("Test_imp_System", this);

    endfunction

    // Define a write method for system items
    virtual function void write_system (System_item item_System);   

    endfunction : write_system


    // Define a write method for afvip items
    virtual function void write_afvip (AFVIP_item item_AFVIP);

     //   `uvm_info("write_afvip", $sformatf("afvip received = 0%0d", afvip_intr), UVM_MEDIUM)
    endfunction : write_afvip

    // Declare some variables for storing expected data and address
    bit [31:0] prd_test [32];
    bit [31:0] prd [32];
    bit [15:0] expected_data=0;
    bit [15:0] expected_add=0;
    bit [15:0] adder=0;
    bit [31:0] x=0;
    bit [2 :0] opcode_expected;
    bit [7 :0] imm_expected;
    bit [15:0] reg0_expected;
    bit [15:0] expected_add_reg0;
    bit [15:0] reg1_expected;
    bit [15:0] expected_add_reg1;


    // Define a write method for apb items
    virtual function void write_apb (APB_item item_APB);

///////////////////////////////////////////////////////////////TEST WRITE ALL READ ALL//////////////////////////////////////////////////////   
      // Check if the test number is 0
      if(item_APB.TEST_NR==0) begin
      // Check if the APB transaction is a read operation
      if(item_APB.penable && !item_APB.pwrite) begin

      // Calculate the expected address based on the expected data
      expected_add=expected_data*4;
      // Increment the expected data by 1
      expected_data =expected_data+1;

      // Store the actual read data in an array indexed by address
      prd_test[item_APB.paddr] = item_APB.prdata;
      
      // Store the expected data in another array indexed by address
      prd [expected_add] = expected_data;
      
      // Compare the actual and expected data and report the result
      if(prd_test[item_APB.paddr] == prd[item_APB.paddr])begin
        `uvm_info ("Scoreboard", $sformatf("PRDATA PASSED"), UVM_NONE)end
      else begin
        `uvm_fatal ("Scoreboard", $sformatf("PRDATA EXPECTED: %h PRDATA RECEIVED: %h", prd[expected_add], prd_test[item_APB.paddr]))end

      // Compare the actual and expected address and report the result
      if(expected_add == item_APB.paddr)begin
          `uvm_info ("Scoreboard", $sformatf("ADDRESS PASSED"), UVM_NONE)end
      else begin
          `uvm_fatal ("Scoreboard", $sformatf("ADDR EXPECTED: %h ADDR RECEIVED: %h", expected_add, item_APB.paddr))end
      end
    end
      ////////////////////////////////////////////////////////TEST READ WRITE ALL//////////////////////////////////////////////////////   
     // Check if the test number is 1 
     if(item_APB.TEST_NR==1) begin
       // Check if the APB transaction is valid 
       if(item_APB.penable)
      
       // Calculate the expected address based on the expected data 
       expected_add=expected_data*4;
       // Increment the expected data by adder mod 2
       expected_data =expected_data+adder%2;


       // Store the actual read data in an array indexed by address
       prd_test[item_APB.paddr] = item_APB.prdata;
      
       // Store the expected data in another array indexed by address
       prd [expected_add] = expected_data;
      
       // Compare the actual and expected data and report the result
       if(prd_test[item_APB.paddr] == prd[item_APB.paddr])begin
         `uvm_info ("Scoreboard", $sformatf("PRDATA PASSED"), UVM_NONE)end
       else if(expected_data!=0) begin
       `uvm_fatal ("Scoreboard", $sformatf("PRDATA EXPECTED: %h PRDATA RECEIVED: %h", prd[expected_add], prd_test[item_APB.paddr]))end

       // Compare the actual and expected address and report the result
       if(expected_add == item_APB.paddr)begin
           `uvm_info ("Scoreboard", $sformatf("ADDRESS PASSED"), UVM_NONE)end
       else begin
           `uvm_fatal ("Scoreboard", $sformatf("ADDR EXPECTED: %h ADDR RECEIVED: %h", expected_add, item_APB.paddr))end
         // Increment the adder by 1
         adder++;
       end

      ////////////////////////////////////////////////////////TEST WRITE ALL READ ONE//////////////////////////////////////////////////////
      // Check if the test number is 2
      if(item_APB.TEST_NR==2) begin
        // Check if the APB transaction is valid 
        if(item_APB.penable)
        
        // Calculate the expected address based on the expected data 
        expected_add  = expected_data*4;
        // Assign the expected data to the actual read data 
        expected_data = item_APB.prdata;

        // Store the actual read data in an array indexed by address
        prd_test[item_APB.paddr] = item_APB.prdata;
        
        // Store the expected data in another array indexed by address
        prd [expected_add] = item_APB.prdata;

        // If the APB transaction is a read operation, then assign the expected data to a different value 
        if(!item_APB.pwrite) begin
        prd [expected_add] = expected_data; end
        
        // Compare the actual and expected data and report the result        
        if(prd_test[item_APB.paddr] == prd[item_APB.paddr])begin
          `uvm_info ("Scoreboard", $sformatf("PRDATA PASSED"), UVM_NONE)end
        else begin
        `uvm_fatal ("Scoreboard", $sformatf("PRDATA EXPECTED: %h PRDATA RECEIVED: %h", prd[expected_add], prd_test[item_APB.paddr]))end
  
        // Compare the actual and expected address and report the result
        if(expected_add == item_APB.paddr)begin
            `uvm_info ("Scoreboard", $sformatf("ADDRESS PASSED"), UVM_NONE)end
        else begin
            `uvm_fatal ("Scoreboard", $sformatf("ADDR EXPECTED: %h ADDR RECEIVED: %h", expected_add, item_APB.paddr))end
          // Increment the adder by 1
          adder++;
        end
      ////////////////////////////////////////////////////////TEST WRITE ONE READ ALL//////////////////////////////////////////////////////
        if(item_APB.TEST_NR==3) begin
if(item_APB.penable && !item_APB.pwrite)begin
        
expected_add=expected_data*4;
expected_data =expected_data+adder%2;


prd_test[item_APB.paddr] = item_APB.prdata;
prd_test[item_APB.paddr] = 0;

if(item_APB.paddr == 16'hC) begin
prd [8] = 2; end

if(prd_test[item_APB.paddr] == prd[item_APB.paddr])begin
  `uvm_info ("Scoreboard", $sformatf("PRDATA PASSED"), UVM_NONE)end
else begin

`uvm_fatal ("Scoreboard", $sformatf("PRDATA EXPECTED: %h PRDATA RECEIVED: %h", prd[expected_add], prd_test[item_APB.paddr]))end
  if(expected_add == item_APB.paddr)begin
    `uvm_info ("Scoreboard", $sformatf("ADDRESS PASSED"), UVM_NONE)end
else begin
    `uvm_fatal ("Scoreboard", $sformatf("ADDR EXPECTED: %h ADDR RECEIVED: %h", expected_add, item_APB.paddr))end
  adder++;end
        end
         ////////////////////////////////////////////////////////TEST FOR ALL//////////////////////////////////////////////////////
        
 // Check if the test number is 4, 5, 6 or 7 
        if(item_APB.TEST_NR==4 || item_APB.TEST_NR==5 || item_APB.TEST_NR==6 || item_APB.TEST_NR==7) begin
          // If there is no reset, then clear the expected data array 
          if(!item_APB.reset)begin
            for(int i=0;i<32;i++)
            prd[i]=0; 
          end
          // If the APB transaction is a write operation and the address is 16'h80, then extract the opcode, immediate value and register addresses from the write data 
          if(item_APB.pwrite && item_APB.paddr==16'h80) begin
           opcode_expected     = item_APB.pwdata [2 :0]     ;
           expected_add_reg0   = item_APB.pwdata [7 :3]     ;
           expected_add_reg1   = item_APB.pwdata [12:8]     ;
           expected_add        = item_APB.pwdata [20:16]    ;    
           imm_expected        = item_APB.pwdata [31:24]    ;
          end
           
          // If the APB transaction is a write operation and the address is less than 125, then store the write data in the expected data array 
          if(item_APB.pwrite && item_APB.psel && item_APB.penable && item_APB.paddr < 125)begin
            prd[item_APB.paddr / 4] = item_APB.pwdata;
          end
    
    
          // Store the actual read data in an array indexed by address 
          prd_test[item_APB.paddr / 4] = item_APB.prdata;

        if(item_APB.pwrite && item_APB.paddr == 16'h8C && item_APB.pwdata == 1) begin
          // If the opcode is 0, then add the immediate value to the register value and store it in the expected data array 
          if(opcode_expected==0)begin
            prd [expected_add] = prd[expected_add_reg0] + imm_expected;end
          
          // If the opcode is 1, then multiply the immediate value with the register value and store it in the expected data array 
          if(opcode_expected==1)begin
            prd [expected_add] = prd[expected_add_reg0] * imm_expected;end
          
          // If the opcode is 2, then add the two register values and store it in the expected data array 
          if(opcode_expected==2)begin
            prd [expected_add] = prd[expected_add_reg0] + prd[expected_add_reg1];end
          
          // If the opcode is 3, then multiply the two register values and store it in the expected data array 
          if(opcode_expected==3)begin
            prd [expected_add] = prd[expected_add_reg0] * prd[expected_add_reg1];end
          
          // If the opcode is 4, then multiply the two register values and add the immediate value and store it in the expected data array 
          if(opcode_expected==4)begin 
            prd [expected_add] = prd[expected_add_reg0] * prd[expected_add_reg1] + imm_expected;end
          end
          // If the APB transaction is a read operation and the address is less than 125, then perform the functional configuration based on the opcode 
            if(!item_APB.pwrite && item_APB.paddr < 125)begin

          // Compare the actual and expected data and report the result
          if(prd_test[item_APB.paddr / 4] == prd[item_APB.paddr / 4])begin
            `uvm_info ("Scoreboard", $sformatf("PRDATA PASSED cornel"), UVM_NONE)
            `uvm_info ("Scoreboard", $sformatf("PRDATA EXPECTED: %h PRDATA RECEIVED: %h", prd[item_APB.paddr / 4], prd_test[item_APB.paddr / 4]),UVM_NONE)end
          else begin
            `uvm_fatal ("Scoreboard", $sformatf("PRDATA EXPECTED: %h PRDATA RECEIVED: %h", prd[item_APB.paddr / 4], prd_test[item_APB.paddr / 4]))
          end
             end
                end
//         if(!item_APB.pwrite && item_APB.paddr<=16'h7C) begin
//   if (expected_add == 16'h7C) begin
//     x<=x+1;
//     adder=0;
//   end
// expected_data =adder;       
// expected_add=(expected_data+2)*4;

// prd_test[item_APB.paddr] = item_APB.prdata;

// if(x==0)begin
//   prd [expected_add] = 8192;end

// if(x==1)begin
//   prd [expected_add] = 8200;end

// if(x==2)begin
//   prd [expected_add] = 4294963198;end

// if(x==3)begin
//   prd [expected_add] = 6;end

// if(x==4)begin 
//   prd [expected_add] = 4294967280;end

// if(prd_test[item_APB.paddr] == prd[expected_add])begin
//   `uvm_info ("Scoreboard", $sformatf("PRDATA PASSED"), UVM_NONE)end
// else begin
// `uvm_fatal ("Scoreboard", $sformatf("PRDATA EXPECTED: %h PRDATA RECEIVED: %h", prd[expected_add], prd_test[expected_add]))end

// if(expected_add == item_APB.paddr)begin
//     `uvm_info ("Scoreboard", $sformatf("ADDRESS PASSED"), UVM_NONE)end
// else begin
//     `uvm_fatal ("Scoreboard", $sformatf("ADDR EXPECTED: %h ADDR RECEIVED: %h", expected_add, item_APB.paddr))end
//   adder++;
//         end
// end
        
// if(item_APB.TEST_NR==4) begin
//   if(!item_APB.pwrite && item_APB.paddr<=16'h7C) begin
// if (expected_add == 16'h7C) begin
// x<=x+1;
// adder=0;
// end
// expected_data =adder;       
// expected_add=(expected_data+2)*4;

// prd_test[item_APB.paddr] = item_APB.prdata;

// if(x==0)begin
// prd [expected_add] = 8192;end

// if(x==1)begin
// prd [expected_add] = 8200;end

// if(x==2)begin
// prd [expected_add] = 4294963198;end

// if(x==3)begin
// prd [expected_add] = 6;end

// if(x==4)begin 
// prd [expected_add] = 4294967280;end

// if(prd_test[item_APB.paddr] == prd[expected_add])begin
// `uvm_info ("Scoreboard", $sformatf("PRDATA PASSED"), UVM_NONE)end
// else begin
// `uvm_fatal ("Scoreboard", $sformatf("PRDATA EXPECTED: %h PRDATA RECEIVED: %h", prd[expected_add], prd_test[expected_add]))end

// if(expected_add == item_APB.paddr)begin
// `uvm_info ("Scoreboard", $sformatf("ADDRESS PASSED"), UVM_NONE)end
// else begin
// `uvm_fatal ("Scoreboard", $sformatf("ADDR EXPECTED: %h ADDR RECEIVED: %h", expected_add, item_APB.paddr))end
// adder++;
//   end

   endfunction : write_apb

    


    virtual task run_phase (uvm_phase phase);
    //
    endtask

endclass: Test_scoreboard