// -----------------------------------------------------------------------------
// Module name: Test_enviroment
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Environment includes all the agents, the scoreboard and coverages
// Date       : July, 2023
// -----------------------------------------------------------------------------

class Test_enviroment extends uvm_env;
    `uvm_component_utils(Test_enviroment)

// Declare the components of the environment
APB_agent m_APB_agent;
AFVIP_agent m_AFVIP_agent;
System_agent m_System_agent;
Test_scoreboard Test_score;
Coverages_afvip coverages;

// Define the constructor of the class
function new(string name="Test_enviroment", uvm_component parent);
    // Call the constructor of the base class
    super.new(name, parent);
endfunction

// Define the build phase of the class
virtual function void build_phase(uvm_phase phase);
    // Call the build phase of the base class
    super.build_phase(phase);

   // Create an instance of APB_agent and assign it to m_APB_agent
   m_APB_agent = APB_agent::type_id::create("m_APB_agent",this);
   // Create an instance of AFVIP_agent and assign it to m_AFVIP_agent
   m_AFVIP_agent = AFVIP_agent::type_id::create("m_AFVIP_agent",this);
   // Set the is_active field of m_AFVIP_agent to UVM_PASSIVE
   m_AFVIP_agent.is_active = UVM_PASSIVE;
   // Create an instance of System_agent and assign it to m_System_agent
    m_System_agent = System_agent::type_id::create("m_System_agent",this);
    // Create an instance of Test_scoreboard and assign it to Test_score
    Test_score = Test_scoreboard::type_id::create("Test_score",this);
    // Create an instance of Coverages_afvip and assign it to coverages
    coverages = Coverages_afvip::type_id::create("coverages",this);

endfunction

// Define the connect phase of the class
virtual function void connect_phase (uvm_phase phase);
    // Call the connect phase of the base class
    super.connect_phase(phase);
    // Connect the analysis port of m_APB_agent.APB_mon to the analysis export of coverages
    m_APB_agent.APB_mon.mon_analysis_port.connect(coverages.analysis_export);
    // Connect the analysis port of m_APB_agent.APB_mon to the Test_imp_APB imp port of Test_score
    m_APB_agent.APB_mon.mon_analysis_port.connect(Test_score.Test_imp_APB);
    // Connect the analysis port of m_AFVIP_agent.AFVIP_mon to the Test_imp_AFVIP imp port of Test_score
    m_AFVIP_agent.AFVIP_mon.mon_analysis_port.connect(Test_score.Test_imp_AFVIP);
    // Connect the analysis port of m_System_agent.System_mon to the Test_imp_System imp port of Test_score
    m_System_agent.System_mon.mon_analysis_port.connect(Test_score.Test_imp_System);
endfunction
endclass: Test_enviroment