// -----------------------------------------------------------------------------
// Module name: System_if
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Connects the DUT with the verification components and holds the assertions
// Date       : July, 2023
// -----------------------------------------------------------------------------

interface System_if
    (
        input      clk,    // Clock signal for the system
        input  reg rst_n   // Reset signal for the system (active low)
    );

   wire afvip_intr; // Declare a wire for the interrupt signal
   
    import uvm_pkg::*; // Import the UVM package

    
    // Define a clocking block called System_drv that is used by the driver component to drive signals on the system    
    clocking System_drv @(posedge clk);
    
        output     afvip_intr; // Output afvip_intr signal to the system
        output     rst_n;      // Output rst_n signal to the system
    
    endclocking
    
    // Define a clocking block called System_mon that is used by the monitor component to sample signals on the system    
    clocking System_mon @(posedge clk);
    
        input      afvip_intr; // Input afvip_intr signal from the system
        input      rst_n;      // Input rst_n signal from the system

    endclocking
    
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////   ███████ ███████ ███████ ███████ ██████  ████████ ██  ██████  ███    ██ ███████   ///////////////////////// 
  /////////////////////////   ██   ██ ██      ██      ██      ██   ██    ██    ██ ██    ██ ████   ██ ██        ///////////////////////// 
  /////////////////////////   ███████ ███████ ███████ ██████  ██████     ██    ██ ██    ██ ██ ██  ██ ███████   ///////////////////////// 
  /////////////////////////   ██   ██      ██      ██ ██      ██   ██    ██    ██ ██    ██ ██  ██ ██      ██   ///////////////////////// 
  /////////////////////////   ██   ██ ███████ ███████ ███████ ██   ██    ██    ██  ██████  ██   ████ ███████   ///////////////////////// 

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                            
  
  /////////////////////////CHECK IF INTERUPT SIGNAL DROPS AT A MAXIMUM 10 CYCLES//////////////////////////////////////////////////////////////////

//     property afvip_interrupt_high_condition;
//         @(posedge clk) disable iff(!rst_n)
//             (afvip_intr) |->( ##[1: 10] $fell (afvip_intr));
//     endproperty

// AFVIP_INTERRUPT_HIGH_CONDITION: assert property   (afvip_interrupt_high_condition) else
//         `uvm_error("AFVIP_INTERRUPT_HIGH_CONDITION", $sformatf("[%0t] AFVIP_INTERRUPT_HIGH_CONDITION : afvip_intr must be low after max. 10 tics", $time))
// AFVIP_INTERRUPT_HIGH_CONDITION_CP: cover property (afvip_interrupt_high_condition);

  /////////////////////////CHECK IF INTERUPT SIGNAL DROPS AT A MAXIMUM 10 CYCLES//////////////////////////////////////////////////////////////////

  /////////////////////////RESET INTERACTION//////////////////////////////////////////////////////////////////

    property afvip_interrupt_reset_interaction;
        @(posedge clk)
             (!rst_n) |-> (!afvip_intr) || $isunknown(afvip_intr);
    endproperty

AFVIP_INTERRUPT_RESET_INTERACTION: assert property   (afvip_interrupt_reset_interaction) else
    `uvm_error("AFVIP_INTERRUPT_RESET_INTERACTION", $sformatf("[%0t] AFVIP_INTERRUPT_RESET_INTERACTION : AFVIP_INTERRUPT DIN'T FELL AFTER RESET", $time))
AFVIP_INTERRUPT_RESET_INTERACTION_CP: cover property (afvip_interrupt_reset_interaction);

/////////////////////////RESET INTERACTION//////////////////////////////////////////////////////////////////

/////////////////////////RESET INTERACTION INTERRUPT STABILITY//////////////////////////////////////////////////////////////////

property afvip_interrupt_reset_stability;
    @(posedge clk)
         (!rst_n) && (!afvip_intr) |=> $stable(afvip_intr);
endproperty

AFVIP_INTERRUPT_RESET_STABILITY: assert property   (afvip_interrupt_reset_stability) else
`uvm_error("AFVIP_INTERRUPT_RESET_STABILITY", $sformatf("[%0t] AFVIP_INTERRUPT_RESET_STABILITY : INTERRUPT NOT STABLE DURIN RESET 0", $time))
AFVIP_INTERRUPT_RESET_STABILITY_CP: cover property (afvip_interrupt_reset_stability);

/////////////////////////RESET INTERACTION INTERRUPT STABILITY//////////////////////////////////////////////////////////////////

    endinterface: System_if