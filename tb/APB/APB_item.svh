// -----------------------------------------------------------------------------
// Module name: APB_item
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Declare the items for the APB and register them in the UVM
// Date       : July, 2023
// -----------------------------------------------------------------------------

class APB_item extends uvm_sequence_item;

// Declare fields for the APB_item class
  rand bit        psel;    // Select signal for the peripheral
  rand bit        penable; // Enable signal for the transfer
  rand bit [15:0] paddr;   // Address signal for the peripheral
  rand bit        pwrite;  // Write signal for the transfer
  rand bit [31:0] pwdata;  // Write data signal for the transfer
  bit      [31:0] prdata;  // Read data signal for the transfer
  logic    [15:0] TEST_NR; // Test number for the transaction
  bit             reset;   // Reset signal for the bus
  logic    [4:0]  rs0;     // Source register 0 for the instruction
  logic    [4:0]  rs1;     // Source register 1 for the instruction
  logic    [7:0]  imm;     // Immediate value for the instruction
  logic    [4:0]  dst;     // Destination register for the instruction
  logic    [2:0]  opcode;  // Opcode for the instruction
  
  // Register the class with the UVM and enable automatic field access methods
  `uvm_object_utils_begin (APB_item)
    `uvm_field_int (psel,    UVM_DEFAULT) // Register psel field with default access policy
    `uvm_field_int (penable, UVM_DEFAULT) // Register penable field with default access policy
    `uvm_field_int (pwrite,  UVM_DEFAULT) // Register pwrite field with default access policy
    `uvm_field_int (pwdata,  UVM_DEFAULT) // Register pwdata field with default access policy
    `uvm_field_int (prdata,  UVM_DEFAULT) // Register prdata field with default access policy
    `uvm_field_int (paddr,   UVM_DEFAULT) // Register paddr field with default access policy
    `uvm_field_int (TEST_NR, UVM_DEFAULT) // Register TEST_NR field with default access policy
    `uvm_field_int (reset,   UVM_DEFAULT) // Register reset field with default access policy
    `uvm_field_int (rs0,     UVM_DEFAULT) // Register rs0 field with default access policy
    `uvm_field_int (rs1,     UVM_DEFAULT) // Register rs1 field with default access policy
    `uvm_field_int (imm,     UVM_DEFAULT) // Register imm field with default access policy
    `uvm_field_int (dst,     UVM_DEFAULT) // Register dst field with default access policy
    `uvm_field_int (opcode,  UVM_DEFAULT) // Register opcode field with default access policy
  `uvm_object_utils_end
  
  function new (string name="");
  
  super.new(name);
  
  endfunction: new

  endclass: APB_item
