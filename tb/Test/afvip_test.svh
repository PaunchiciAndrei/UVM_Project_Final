

class afvip_test extends uvm_test;

    `uvm_component_utils(afvip_test)

    function new (string name, uvm_component parent = null);
        super.new(name,parent);
    endfunction

    // Declare the environment
    Test_enviroment top_env;


    // Define a build phase function
    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        // Create a new instance of the Test_enviroment class with a name and a parent
        top_env = Test_enviroment::type_id::create("top_env",this);

    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
        // Call the super class start of simulation phase function with the same argument
        super.start_of_simulation_phase(phase);
    endfunction

    function void final_phase(uvm_phase phase);
        `uvm_info ("Scoreboard", $sformatf("\n
        \n                                                                                                                                                                                          
        \n  
        \nTTTTTTTTTTTTTTTTTTTTTTT                                       ttttttt               PPPPPPPPPPPPPPPPP                                                                                    d::::::d
        \nT:::::::::::::::::::::T                                       ttt:::t               P::::::::::::::::P                                                                                   d::::::d
        \nT:::::::::::::::::::::T                                       t:::::t               P::::::PPPPPP:::::P                                                                                  d::::::d
        \nT:::::TT:::::::TT:::::T                                       t:::::t               PP:::::P     P:::::P                                                                                 d::::::d 
        \n        T:::::T        eeeeeeeeeeee        ssssssssss   ttttttt:::::ttttttt           P::::P     P:::::Paaaaaaaaaaaaa      ssssssssss       ssssssssss       eeeeeeeeeeee        ddddddddd::::::d 
        \n        T:::::T      ee::::::::::::ee    ss::::::::::s  t:::::::::::::::::t           P::::P     P:::::Pa::::::::::::a   ss::::::::::s    ss::::::::::s    ee::::::::::::ee    dd:::::::::::::::d 
        \n        T:::::T     e::::::eeeee:::::eess:::::::::::::s t:::::::::::::::::t           P::::PPPPPP:::::P aaaaaaaaa:::::ass:::::::::::::s ss:::::::::::::s  e::::::eeeee:::::ee d:::::::::::::::::d 
        \n        T:::::T    e::::::e     e:::::es::::::ssss:::::stttttt:::::::tttttt           P:::::::::::::PP           a::::as::::::ssss:::::ss::::::ssss:::::se::::::e     e:::::ed:::::::ddddd::::::d 
        \n        T:::::T    e:::::::eeeee::::::e s:::::s  ssssss       t:::::t                 P::::PPPPPPPPP      aaaaaaa:::::a s:::::s  ssssss  s:::::s  ssssss e:::::::eeeee::::::ed::::::d    d::::::d 
        \n        T:::::T    e:::::::::::::::::e    s::::::s            t:::::t                 P::::P            aa::::::::::::a   s::::::s         s::::::s      e:::::::::::::::::e d:::::d     d::::::d 
        \n        T:::::T    e::::::eeeeeeeeeee        s::::::s         t:::::t                 P::::P           a::::aaaa::::::a      s::::::s         s::::::s   e::::::eeeeeeeeeee  d:::::d     d::::::d 
        \n        T:::::T    e:::::::e           ssssss   s:::::s       t:::::t    tttttt       P::::P          a::::a    a:::::assssss   s:::::s ssssss   s:::::s e:::::::e           d:::::d     d::::::d 
        \n      TT:::::::TT  e::::::::e          s:::::ssss::::::s      t::::::tttt:::::t     PP::::::PP        a::::a    a:::::as:::::ssss::::::ss:::::ssss::::::se::::::::e          d::::::ddddd::::::dd
        \n      T:::::::::T   e::::::::eeeeeeee  s::::::::::::::s       tt::::::::::::::t     P::::::::P        a:::::aaaa::::::as::::::::::::::s s::::::::::::::s  e::::::::eeeeeeee   d:::::::::::::::::d
        \n      T:::::::::T    ee:::::::::::::e   s:::::::::::ss          tt:::::::::::tt     P::::::::P         a::::::::::aa:::as:::::::::::ss   s:::::::::::ss    ee:::::::::::::e    d:::::::::ddd::::d
        \n      TTTTTTTTTTT      eeeeeeeeeeeeee    sssssssssss              ttttttttttt       PPPPPPPPPP          aaaaaaaaaa  aaaa sssssssssss      sssssssssss        eeeeeeeeeeeeee     ddddddddd   ddddd
        \n       
                
                
                
                
                
                
"), UVM_NONE)
    endfunction
endclass: afvip_test

class read_write_all extends afvip_test;

    `uvm_component_utils(read_write_all)

    function new (string name= "read_write_all", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    virtual task run_phase(uvm_phase phase);

        // Create new instances of the System_sequence, Start_test, APB_sequence and RW_test classes
        System_sequence s_seq = System_sequence::type_id::create("s_seq");
        Start_test starter = Start_test::type_id::create("starter");
        APB_sequence seq = APB_sequence::type_id::create("seq");
        RW_test rw = RW_test :: type_id :: create ("rw");
        
        // Raise an objection to prevent the phase from ending prematurely
        phase.raise_objection(this);
       // Start the starter sequence on the System sequencer of the System agent in the environment
       starter.start(top_env.m_System_agent.System_seq);
       // Start the rw sequence on the APB sequencer of the APB agent in the environment
        rw.start(top_env.m_APB_agent.APB_seq);
        // Drop the objection to allow the phase to end normally
        phase.drop_objection (this);
    endtask
    
endclass: read_write_all

class write_all_read_one extends afvip_test;

    `uvm_component_utils(write_all_read_one)

    function new (string name= "write_all_read_one", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    virtual task run_phase(uvm_phase phase);

        // Create new instances of the System_sequence, Start_test, APB_sequence and Read1_writeall classes
        System_sequence s_seq = System_sequence::type_id::create("s_seq");
        Start_test starter = Start_test::type_id::create("starter");
        APB_sequence seq = APB_sequence::type_id::create("seq");
        Read1_writeall rwt = Read1_writeall :: type_id :: create ("rwt");
        
        // Raise an objection to prevent the phase from ending prematurely
        phase.raise_objection(this);
       // Start the starter sequence on the System sequencer of the System agent in the environment 
       starter.start(top_env.m_System_agent.System_seq);

       // Start the rwt sequence on the APB sequencer of the APB agent in the environment 
        rwt.start(top_env.m_APB_agent.APB_seq);

       // Drop the objection to allow the phase to end normally
        phase.drop_objection (this);
    endtask
    
endclass: write_all_read_one

class write_one_read_all extends afvip_test;

    `uvm_component_utils(write_one_read_all)

    function new (string name= "write_one_read_all", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    virtual task run_phase(uvm_phase phase);

        // Create new instances of the System_sequence, Start_test, APB_sequence and Readall_write1 classes
        System_sequence s_seq = System_sequence::type_id::create("s_seq");
        Start_test starter = Start_test::type_id::create("starter");
        APB_sequence seq = APB_sequence::type_id::create("seq");
        Readall_write1 raw1 = Readall_write1 :: type_id :: create ("raw1");

        
        // Raise an objection to prevent the phase from ending prematurely
        phase.raise_objection(this);
       // Start the starter sequence on the System sequencer of the System agent in the environment 
       starter.start(top_env.m_System_agent.System_seq);
       // Start the raw1 sequence on the APB sequencer of the APB agent in the environment 
        raw1.start(top_env.m_APB_agent.APB_seq);

       // Drop the objection to allow the phase to end normally
        phase.drop_objection (this);
    endtask
    
endclass: write_one_read_all

class write_all_read_all extends afvip_test;

    `uvm_component_utils(write_all_read_all)

    function new (string name= "write_all_read_all", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    // Define a run phase task that takes a phase as an argument
    virtual task run_phase(uvm_phase phase);
        // Create new instances of the System_sequence, Start_test, APB_sequence and RW_test1 classes
        System_sequence s_seq = System_sequence::type_id::create("s_seq");
        Start_test starter = Start_test::type_id::create("starter");
        APB_sequence seq = APB_sequence::type_id::create("seq");
        RW_test1 rw1 = RW_test1 :: type_id :: create ("rw1");
        
        // Raise an objection to prevent the phase from ending prematurely
        phase.raise_objection(this);
       // Start the starter sequence on the System sequencer of the System agent in the environment 
       starter.start(top_env.m_System_agent.System_seq);
       // Start the rw1 sequence on the APB sequencer of the APB agent in the environment 
       rw1.start(top_env.m_APB_agent.APB_seq);

      // Drop the objection to allow the phase to end normally
        phase.drop_objection (this);
    endtask
    
endclass: write_all_read_all

class config_overlap extends afvip_test;

    `uvm_component_utils(config_overlap)

    function new (string name= "config_overlap", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    // Define a run phase task that takes a phase as an argument
    virtual task run_phase(uvm_phase phase);

        // Create new instances of the System_sequence, Start_test, APB_sequence and Config_test classes
        System_sequence s_seq = System_sequence::type_id::create("s_seq");
        Start_test starter = Start_test::type_id::create("starter");
        APB_sequence seq = APB_sequence::type_id::create("seq");
        Config_test cft = Config_test :: type_id :: create ("cft");
        
        // Raise an objection to prevent the phase from ending prematurely
        phase.raise_objection(this);
       // Start the starter sequence on the System sequencer of the System agent in the environment 
       starter.start(top_env.m_System_agent.System_seq);
       // Start the cft sequence on the APB sequencer of the APB agent in the environment 
       cft.start(top_env.m_APB_agent.APB_seq);
        // Drop the objection to allow the phase to end normally
        phase.drop_objection (this);
    endtask
    
endclass: config_overlap

class Operation_test extends afvip_test;

    `uvm_component_utils(Operation_test)

    function new (string name= "Operation_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    virtual task run_phase(uvm_phase phase);

        // Create new instances of the System_sequence, Start_test, APB_sequence and Operation_config_test classes
        System_sequence s_seq = System_sequence::type_id::create("s_seq");
        Start_test starter = Start_test::type_id::create("starter");
        APB_sequence seq = APB_sequence::type_id::create("seq");
        Operation_config_test oct = Operation_config_test :: type_id :: create ("oct");
        
        // Raise an objection to prevent the phase from ending prematurely
        phase.raise_objection(this);
        // Start the starter sequence on the System sequencer of the System agent in the environment 
        starter.start(top_env.m_System_agent.System_seq);
        // Start the oct sequence on the APB sequencer of the APB agent in the environment 
        oct.start(top_env.m_APB_agent.APB_seq);

        // Drop the objection to allow the phase to end normally
        phase.drop_objection (this);
    endtask
    
endclass: Operation_test

class Reset_test extends afvip_test;

    `uvm_component_utils(Reset_test)

    function new (string name= "Reset_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    virtual task run_phase(uvm_phase phase);

        // Create new instances of the System_sequence, Start_test, APB_sequence, Operation_config_test and Reset_tester classes
        System_sequence s_seq = System_sequence::type_id::create("s_seq");
        Start_test starter = Start_test::type_id::create("starter");
        APB_sequence seq = APB_sequence::type_id::create("seq");
        Operation_config_test oct = Operation_config_test :: type_id :: create ("oct");
        Reset_tester rstets = Reset_tester::type_id::create("rstets");
        
        // Raise an objection to prevent the phase from ending prematurely
        phase.raise_objection(this);
        
         // Start both sequences in parallel using fork-join construct 
         fork 
            // Start the rstets sequence on the System sequencer of the System agent in the environment 
            rstets.start(top_env.m_System_agent.System_seq);
            // Start the oct sequence on the APB sequencer of the APB agent in the environment 
            oct.start(top_env.m_APB_agent.APB_seq);
        join

        // Drop the objection to allow the phase to end normally
        phase.drop_objection (this);
    endtask
    
endclass: Reset_test

class Full_Coverage_Test extends afvip_test;

    `uvm_component_utils(Full_Coverage_Test)

    function new (string name= "Full_Coverage", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    virtual task run_phase(uvm_phase phase);

        // Create new instances of the System_sequence, Start_test, APB_sequence and Full_Coverage classes
        System_sequence s_seq = System_sequence::type_id::create("s_seq");
        Start_test starter = Start_test::type_id::create("starter");
        APB_sequence seq = APB_sequence::type_id::create("seq");
        Full_Coverage fct = Full_Coverage :: type_id :: create ("fct");
        
        // Raise an objection to prevent the phase from ending prematurely
        phase.raise_objection(this);
        
         // Start the starter sequence on the System sequencer of the System agent in the environment 
        starter.start(top_env.m_System_agent.System_seq);
        
         // Start the fct sequence on the APB sequencer of the APB agent in the environment 
        fct.start(top_env.m_APB_agent.APB_seq);

        // Drop the objection to allow the phase to end normally
        phase.drop_objection (this);
    endtask
    
endclass: Full_Coverage_Test