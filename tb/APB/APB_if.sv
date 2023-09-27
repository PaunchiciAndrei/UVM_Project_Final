// -----------------------------------------------------------------------------
// Module name: APB_if
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Connects the DUT with the verification components and holds the assertions
// Date       : July, 2023
// -----------------------------------------------------------------------------

interface APB_if
  (
      input      clk,    // Clock signal 
      input      rst_n   // Reset signal (active low)
  );
  
  import uvm_pkg::*; // Import the UVM package
  `include "uvm_macros.svh" // Include the UVM macros file
    
// Declare some wires for the APB_if interface
wire           psel   ; // Select signal for the peripheral
wire           penable; // Enable signal for the transfer
wire  [15:0]   paddr  ; // Address signal for the peripheral
wire           pwrite ; // Write signal for the transfer
wire  [31:0]   pwdata ; // Write data signal for the transfer
wire           pready ; // Ready signal from the peripheral
wire  [31:0]   prdata ; // Read data signal from the peripheral
wire           pslverr; // Slave error signal from the peripheral
wire  [15:0]   TEST_NR; // Test number for the transaction
wire           reset  ; // Reset signal
wire           opcode ; // Opcode for the instruction
wire           rs0    ; // Source register 0 for the instruction
wire           rs1    ; // Source register 1 for the instruction
wire           dst    ; // Destination register for the instruction
wire           imm    ; // Immediate value for the instruction

// Define a clocking block called APB_drv that is used by the driver component to drive signals on the bus    
  clocking APB_drv@(posedge clk);

  output    psel   ; // Output psel signal to the bus
  output    penable; // Output penable signal to the bus
  output    paddr  ; // Output paddr signal to the bus
  output    pwrite ; // Output pwrite signal to the bus
  output    pwdata ; // Output pwdata signal to the bus
  output    reset  ; // Output reset signal to the bus
  output    TEST_NR; // Output TEST_NR signal to the bus
  input     pready ; // Input pready signal from the bus
  input     prdata ; // Input prdata signal from the bus
  input     pslverr; // Input pslverr signal from the bus
  input     opcode ; // Input opcode signal from the bus
  input     rs0    ; // Input rs0 signal from the bus
  input     rs1    ; // Input rs1 signal from the bus
  input     dst    ; // Input dst signal from the bus
  input     imm    ; // Input imm signal from the bus
  
  endclocking
  
// Define a clocking block called APB_mon that is used by the monitor component to sample signals on the bus    
  clocking APB_mon@(posedge clk);

// Input all signals from the bus    
  input       psel   ;
  input       penable;
  input       paddr  ;
  input       pwrite ;
  input       pwdata ;
  input       pready ;
  input       prdata ;
  input       pslverr;
  input       TEST_NR;
  input       reset  ;
  input       opcode ;
  input       rs0    ;
  input       rs1    ;
  input       dst    ;
  input       imm    ;
  
endclocking

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////   ███████ ███████ ███████ ███████ ██████  ████████ ██  ██████  ███    ██ ███████   ///////////////////////// 
  /////////////////////////   ██   ██ ██      ██      ██      ██   ██    ██    ██ ██    ██ ████   ██ ██        ///////////////////////// 
  /////////////////////////   ███████ ███████ ███████ ██████  ██████     ██    ██ ██    ██ ██ ██  ██ ███████   ///////////////////////// 
  /////////////////////////   ██   ██      ██      ██ ██      ██   ██    ██    ██ ██    ██ ██  ██ ██      ██   ///////////////////////// 
  /////////////////////////   ██   ██ ███████ ███████ ███████ ██   ██    ██    ██  ██████  ██   ████ ███████   ///////////////////////// 

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                            
  
  /////////////////////////CHECK IF PENABLE RISES ACCORDINGLY//////////////////////////////////////////////////////////////////

    property penable_raise_condition;
			@(posedge psel) disable iff(!rst_n || pslverr)
				(psel) |=>($rose (penable));
		endproperty

    APB_PENABLE_HIGH_CONDITION: assert property (penable_raise_condition) else
			`uvm_error("APB_PENABLE_HIGH_CONDITION", $sformatf("[%0t] APB_PENABLE_HIGH_CONDITION : penable must be HIGH", $time))
    APB_PENABLE_HIGH_CONDITION_CP: cover property (penable_raise_condition);

  /////////////////////////CHECK IF PENABLE RISES ACCORDINGLY//////////////////////////////////////////////////////////////////

  /////////////////////////CHECK IF PENABLE FALLS ACCORDINGLY////////////////////////////////////////////////////////////////  

    property penable_fall_condition;
			@(posedge penable) disable iff(!rst_n || pslverr || psel)
				(pready) |=>($fell (penable));
		endproperty

    APB_PENABLE_LOW_CONDITION: assert property (penable_fall_condition) else
			`uvm_error("APB_PENABLE_LOW_CONDITION", $sformatf("[%0t] APB_PENABLE_LOW_CONDITION : penable must be LOW", $time))
    APB_PENABLE_LOW_CONDITION_CP: cover property (penable_fall_condition);
   
  /////////////////////////CHECK IF PENABLE FALLS ACCORDINGLY////////////////////////////////////////////////////////////////  

  /////////////////////////CHECK IF PRDATA TRANSFER IS DONE//////////////////////////////////////////////////////////////////  

    property prdata_transfer;
			@(posedge clk) disable iff(!rst_n || pslverr)
       (psel) && (penable) && (!pwrite) && (pready) && $changed (paddr) |-> $changed (prdata);
		endproperty

    APB_PRDATA_TRANSFER: assert property (prdata_transfer) else
			`uvm_error("APB_PRDATA_TRANSFER", $sformatf("[%0t] APB_PRDATA_TRANSFER : prdata TRANSFER MALFUNCTION!", $time))
    APB_PRDATA_TRANSFER_CP: cover property (prdata_transfer);
   
  /////////////////////////CHECK IF PRDATA TRANSFER IS DONE//////////////////////////////////////////////////////////////////  

  /////////////////////////CHECK IF PWDATA IS STABLE DURING WRITEING//////////////////////////////////////////////////////////////////  

    property pwdata_stability;
			@(posedge clk) disable iff(!rst_n || pslverr)
       (|psel) && (penable) && (pwrite) && (pready) |-> $stable (pwdata);
		endproperty

    APB_PWDATA_STABILITY: assert property (pwdata_stability) else
			`uvm_error("APB_PWDATA_STABILITY", $sformatf("[%0t] APB_PWDATA_STABILITY : pwdata UNSTABLE!", $time))
    APB_PWDATA_STABILITY_CP: cover property (pwdata_stability);
   
  /////////////////////////CHECK IF PWDATA IS STABLE DURING WRITEING////////////////////////////////////////////////////////////////// 
    
  /////////////////////////CHECK IF PRDATA IS STABLE DURING READING//////////////////////////////////////////////////////////////////  

    property prdata_stability;
			@(posedge clk) disable iff(!rst_n || pslverr)
       (psel) && (penable) && (!pwrite) && (pready) && $changed (paddr) && $changed (prdata) |-> $stable (prdata);
		endproperty

    APB_PRDATA_STABILITY: assert property (prdata_stability) else
			`uvm_error("APB_PRDATA_STABILITY", $sformatf("[%0t] APB_PRDATA_STABILITY : prdata UNSTABLE!", $time))
    APB_PRDATA_STABILITY_CP: cover property (prdata_stability);
   
  /////////////////////////CHECK IF PRDATA IS STABLE DURING READING//////////////////////////////////////////////////////////////////

  /////////////////////////RESET INTERACTION//////////////////////////////////////////////////////////////////  

    property reset_interaction_prdata_pslverr;
			@(posedge clk)
       (!rst_n) |=> $stable (prdata) && $stable (pslverr);
		endproperty

    APB_PRDATA_PSLVERR_RESET_INTERACTION: assert property (reset_interaction_prdata_pslverr) else
			`uvm_error("APB_PRDATA_PSLVERR_RESET_INTERACTION", $sformatf("[%0t] APB_PRDATA_PSLVERR_RESET_INTERACTION : PRDATA/ PSLVERR MALFUNCTION AT RESET 0!", $time))
    APB_PRDATA_PSLVERR_RESET_INTERACTION_CP: cover property (reset_interaction_prdata_pslverr);
   
  /////////////////////////RESET INTERACTION//////////////////////////////////////////////////////////////////
    
    endinterface: APB_if
    

