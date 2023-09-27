// -----------------------------------------------------------------------------
// Module name: Coverages_afvip
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Coverage percentage information and database storage.
// Date       : July, 2023
// -----------------------------------------------------------------------------
class Coverages_afvip extends uvm_subscriber #(APB_item);
    `uvm_component_utils (Coverages_afvip)
    // Constructor
    function new (string name = "Coverages_afvip", uvm_component parent);
        super.new (name, parent);
        addr    = new();
        pw_data = new();
        op_code = new();
        rs0     = new();
        rs1     = new();
        dst     = new();
        imm     = new();
      endfunction
    // Local storage variable declaration
    real ep_addr;
    real ep_pwdata;
    real ep_rs0;
    real ep_rs1;
    real ep_dst;
    real ep_imm;
    real ep_op_code;
    // APB item handle
    APB_item cov_APB_item;
    // Address covergroup
    covergroup addr;
        PADDR: coverpoint cov_APB_item.paddr/4 {

               bins adrese[32] ={[0:31]};
           // bins a[] = {[0:124]} with (cov_APB_item.paddr % 4 == 0);
        }
    endgroup : addr

    covergroup pw_data;
        PWDATA: coverpoint cov_APB_item.pwdata{

            bins b0  = {[32'b00000000000000000000000000000000 : 32'b00000000000000000000000000000001]};
            bins b1  = {[32'b00000000000000000000000000000001 : 32'b00000000000000000000000000000010]};
            bins b2  = {[32'b00000000000000000000000000000010 : 32'b00000000000000000000000000000100]};
            bins b3  = {[32'b00000000000000000000000000000100 : 32'b00000000000000000000000000001000]};
            bins b4  = {[32'b00000000000000000000000000001000 : 32'b00000000000000000000000000010000]};
            bins b5  = {[32'b00000000000000000000000000010000 : 32'b00000000000000000000000000100000]};
            bins b6  = {[32'b00000000000000000000000000100000 : 32'b00000000000000000000000001000000]};
            bins b7  = {[32'b00000000000000000000000001000000 : 32'b00000000000000000000000010000000]};
            bins b8  = {[32'b00000000000000000000000010000000 : 32'b00000000000000000000000100000000]};
            bins b9  = {[32'b00000000000000000000000100000000 : 32'b00000000000000000000001000000000]};
            bins b10 = {[32'b00000000000000000000001000000000 : 32'b00000000000000000000010000000000]};
            bins b11 = {[32'b00000000000000000000010000000000 : 32'b00000000000000000000100000000000]};
            bins b12 = {[32'b00000000000000000000100000000000 : 32'b00000000000000000001000000000000]};
            bins b13 = {[32'b00000000000000000001000000000000 : 32'b00000000000000000010000000000000]};
            bins b14 = {[32'b00000000000000000010000000000000 : 32'b00000000000000000100000000000000]};
            bins b15 = {[32'b00000000000000000100000000000000 : 32'b00000000000000001000000000000000]};
            bins b16 = {[32'b00000000000000001000000000000000 : 32'b00000000000000010000000000000000]};
            bins b17 = {[32'b00000000000000010000000000000000 : 32'b00000000000000100000000000000000]};
            bins b18 = {[32'b00000000000000100000000000000000 : 32'b00000000000001000000000000000000]};
            bins b19 = {[32'b00000000000001000000000000000000 : 32'b00000000000010000000000000000000]};
            bins b20 = {[32'b00000000000010000000000000000000 : 32'b00000000000100000000000000000000]};
            bins b21 = {[32'b00000000000100000000000000000000 : 32'b00000000001000000000000000000000]};
            bins b22 = {[32'b00000000001000000000000000000000 : 32'b00000000010000000000000000000000]};
            bins b23 = {[32'b00000000010000000000000000000000 : 32'b00000000100000000000000000000000]};
            bins b24 = {[32'b00000000100000000000000000000000 : 32'b00000001000000000000000000000000]};
            bins b25 = {[32'b00000001000000000000000000000000 : 32'b00000010000000000000000000000000]};
            bins b26 = {[32'b00000010000000000000000000000000 : 32'b00000100000000000000000000000000]};
            bins b27 = {[32'b00000100000000000000000000000000 : 32'b00001000000000000000000000000000]};
            bins b28 = {[32'b00001000000000000000000000000000 : 32'b00010000000000000000000000000000]};
            bins b29 = {[32'b00010000000000000000000000000000 : 32'b00100000000000000000000000000000]};
            bins b30 = {[32'b00100000000000000000000000000000 : 32'b01000000000000000000000000000000]};
            bins b31 = {[32'b01000000000000000000000000000000 : 32'b10000000000000000000000000000000]};
            bins b32 = {[32'b10000000000000000000000000000000 : 32'b11000000000000000000000000000000]};
        }
    endgroup: pw_data

    covergroup op_code;
        OPCODE: coverpoint cov_APB_item.opcode{
            bins oo [5] = {[0 : 4]};
        }
    endgroup: op_code

    covergroup rs0;

        RS0: coverpoint cov_APB_item.rs0{

            bins rs0_0 [32] = {[0: 31]};
        }
    endgroup: rs0;

    covergroup rs1;

        RS1: coverpoint cov_APB_item.rs1{

            bins rs1_0 [32] = {[0: 31]};

        }
    endgroup: rs1;

    covergroup dst;
        DESTINATION: coverpoint cov_APB_item.dst{

            bins destination_addresss [32] =  {[0: 31]};

        }
    endgroup: dst

    covergroup imm;
        IMM: coverpoint cov_APB_item.imm{

            bins b0 [] = {[8'b00000000 : 8'b11111111]};
        }
    endgroup: imm
    function void write (APB_item t);
        cov_APB_item = t;
        addr.sample ();
        pw_data.sample ();
        rs0.sample();
        rs1.sample();
        dst.sample();
        imm.sample();
        op_code.sample();

    endfunction : write
    
    function void extract_phase (uvm_phase phase);
        super.extract_phase (phase);
        ep_addr = addr.get_coverage ();
        ep_pwdata = pw_data.get_coverage ();
        ep_rs0 = rs0.get_coverage();
        ep_rs1 = rs1.get_coverage();
        ep_dst = dst.get_coverage();
        ep_imm = imm.get_coverage();
        ep_op_code = op_code.get_coverage();
    endfunction : extract_phase
    
    function void report_phase (uvm_phase phase);
        super.report_phase (phase);
        `uvm_info ("[Address Coverage]", $sformatf ("Coverage is %f", ep_addr), UVM_MEDIUM)
        `uvm_info ("[Pwdata Coverage]", $sformatf ("Coverage is %f", ep_pwdata), UVM_MEDIUM)
        `uvm_info ("[Register 0 Coverage]", $sformatf ("Coverage is %f", ep_rs0), UVM_MEDIUM)
        `uvm_info ("[Register 1 Coverage]", $sformatf ("Coverage is %f", ep_rs1), UVM_MEDIUM)
        `uvm_info ("[Destination addr Coverage]", $sformatf ("Coverage is %f", ep_dst), UVM_MEDIUM)
        `uvm_info ("[IMM Coverage]", $sformatf ("Coverage is %f", ep_imm), UVM_MEDIUM)
        `uvm_info ("[Opcode Coverage]", $sformatf ("Coverage is %f", ep_op_code), UVM_MEDIUM)
    endfunction : report_phase
    
endclass : Coverages_afvip