// -----------------------------------------------------------------------------
// Module name: APB_sequences
// HDL        : System Verilog
// Author     : Paunchici Andrei
// Description: Sequences library used to test the DUT functionality
// Date       : July, 2023
// -----------------------------------------------------------------------------

class APB_sequence extends uvm_sequence;

    // Register the class with the UVM factory
    `uvm_object_utils (APB_sequence)

    // Define a constructor that takes a string argument for the name of the object
    function new (string name = "APB_sequence");
        // Call the constructor of the parent class with the name argument
        super.new (name);
    endfunction

    // Define a virtual task named body that will be executed by the sequencer
    virtual task body ();
    // Leave the body empty as it will be overridden by the child classes
    endtask : body
// End the class definition
endclass : APB_sequence

      ////////////////////////////////////////////////////////TEST READ ALL WRITE ALL//////////////////////////////////////////////////////

// Declare a class named RW_test1 that extends APB_sequence
class RW_test1 extends APB_sequence;
    // Register the class with the UVM factory
    `uvm_object_utils (RW_test1)

    // Define a constructor that takes a string argument for the name of the object
    function new (string name = "RW_test1");
        // Call the constructor of the parent class with the name argument
        super.new (name);
    endfunction

    // Define a virtual task named body that will be executed by the sequencer
    virtual task body();
        
        //Declare the APB items
        APB_item item;
        // Create an object of type APB_item and assign it to item
        item = APB_item::type_id::create("item");

        // Loop from 0 to 31 with i as the loop variable
        for(int i=0;i<32;i++)begin
            // Start a transaction with item as the sequence item
            start_item(item);
            // Randomize the fields of item with some constraints
            if(!(item.randomize() with{
                paddr==4*i; // The address is 4 times i
                pwrite == 1; // The write enable is 1, which means write operation
                pwdata == i+1;})) // The write data is i+1
            // If randomization fails, report an error with the class name and a message
            `uvm_error(get_type_name(), "Rand error!")
            // Finish the transaction and send item to the driver 
            finish_item(item); 
        end

        // Loop from 0 to 31 with i as the loop variable
        for(int i=0;i<32;i++)begin
            // Start a transaction with item as the sequence item
            start_item(item);
            // Randomize the fields of item with some constraints
            if(!(item.randomize() with{
                paddr  == 4*i; // The address is 4 times i 
                pwrite == 0;   // The write enable is 0, which means read operation
                pwdata == i+1;})) // The write data is i+1, but it is not used in read operation
            // If randomization fails, report an error with the class name and a message    
            `uvm_error(get_type_name(), "Rand error!")
            // Finish the transaction and send item to the driver 
            finish_item(item); 
        end
  
    endtask: body
   
endclass: RW_test1

      ////////////////////////////////////////////////////////TEST READ WRITE ALL//////////////////////////////////////////////////////

// Declare a class named RW_test that extends APB_sequence      
class RW_test extends APB_sequence;
    // Register the class with the UVM factory    
    `uvm_object_utils (RW_test)

    // Define a constructor that takes a string argument for the name of the object    
    function new (string name = "RW_test");
        // Call the constructor of the parent class with the name argument        
        super.new (name);
    endfunction

    // Define a virtual task named body that will be executed by the sequencer    
    virtual task body();
        
        //Declare the APB items        
        APB_item item;
        // Create an object of type APB_item and assign it to item        
        item = APB_item::type_id::create("item");

        // Loop from 0 to 31 with i as the loop variable        
        for(int i=0;i<32;i++)begin
            // Start a transaction with item as the sequence item            
            start_item(item);
            // Randomize the fields of item with some constraints            
            if(!(item.randomize() with{
                paddr==4*i;  // The address is 4 times i                
                pwrite == 1; // The write enable is 1, which means write operation                
                pwdata == i+1;})) // The write data is i+1
            // If randomization fails, report an error with the class name and a message                
            `uvm_error(get_type_name(), "Rand error!")
            // Finish the transaction and send item to the driver             
            finish_item(item); 

            // Start another transaction with item as the sequence item            
            start_item(item);
            // Set the write enable of item to 0, which means read operation            
            item.pwrite = 0;
            // Finish the transaction and send item to the driver             
            finish_item(item);
        end
      
    endtask: body
   
endclass: RW_test

 ////////////////////////////////////////////////////////TEST WRITE ALL READ ONE//////////////////////////////////////////////////////


// Declare a class named Read1_writeall that extends APB_sequence
class Read1_writeall extends APB_sequence;
    // Register the class with the UVM factory
    `uvm_object_utils (Read1_writeall)

    // Define a constructor that takes a string argument for the name of the object
    function new (string name = "Read1_writeall");
        // Call the constructor of the parent class with the name argument
        super.new (name);
    endfunction

    // Define a virtual task named body that will be executed by the sequencer
    virtual task body();
        //Declare the APB items
        APB_item item;
        // Create an object of type APB_item and assign it to item
        item = APB_item::type_id::create("item");

        // Loop from 0 to 31 with i as the loop variable
        for(int i=0;i<32;i++)begin
            // Start a transaction with item as the sequence item
            start_item(item);
            // Randomize the fields of item with some constraints
            if(!(item.randomize() with{
                paddr==4*i;  // The address is 4 times i
                paddr inside {[0:16'h8C]}; // The address is within [0,140] in hexadecimal
                pwrite == 1; // The write enable is 1, which means write operation
                pwdata == i+1; // The write data is i+1
            }))
            // If randomization fails, report an error with the class name and a message
            `uvm_error(get_type_name(), "Rand error!")
            // Finish the transaction and send item to the driver 
            finish_item(item); 
            
            // Start another transaction with item as the sequence item
            start_item(item);
            // If the address of item is 8 in hexadecimal, which means 128 in decimal
            if(item.paddr == 16'h8)begin
                // Set the write enable of item to 0, which means read operation 
                item.pwrite = 0; end
            // Finish the transaction and send item to the driver 
            finish_item(item);

        end
  
    endtask: body
   
endclass: Read1_writeall

////////////////////////////////////////////////////////TEST WRITE ONE READ ALL//////////////////////////////////////////////////////


// Declare a class named Readall_write1 that extends APB_sequence
class Readall_write1 extends APB_sequence;
    // Register the class with the UVM factory    
    `uvm_object_utils (Readall_write1)

    // Define a constructor that takes a string argument for the name of the object    
    function new (string name = "Readall_write1");
        // Call the constructor of the parent class with the name argument        
        super.new (name);
    endfunction

    // Define a virtual task named body that will be executed by the sequencer    
    virtual task body();
        //Declare the APB items        
        APB_item item;
        // Create an object of type APB_item and assign it to item        
        item = APB_item::type_id::create("item");
           
        // Start a transaction with item as the sequence item        
        start_item(item);
        item.paddr = 16'h8;
        item.pwrite = 1;
        item.pwdata = 2;
        finish_item(item);
 for(int i=0;i<32;i++)begin


        start_item(item);
        // if(!(item.randomize() with{paddr[1:0]==0; paddr inside {[0:16'h8C]}; pwrite inside {[0:1]}; pwdata == (i+4);}))
        if(!(item.randomize() with{
            paddr==4*i; 
            paddr inside {[0:16'h8C]}; 
            //pwrite inside {[0:1]}; 
            pwrite == 0;
            pwdata == i+1;
        }))
        `uvm_error(get_type_name(), "Rand error!")
        finish_item(item); 
 

    end
    endtask: body
endclass: Readall_write1


////////////////////////////////////////////////////////TEST FUNCTIONAL CONFIG//////////////////////////////////////////////////////


class Config_test extends APB_sequence;
    `uvm_object_utils (Config_test)

    function new (string name = "Config_test");
        super.new (name);
    endfunction

    virtual task body();
        APB_item item;
        item = APB_item::type_id::create("item");

        start_item(item);
        item.paddr = 0;
        item.pwrite = 1;
        item.pwdata = $urandom_range(32'hFFFFFF00,32'hFFFFFFFF);
        finish_item(item);

        start_item(item);
        item.paddr = 4;
        item.pwrite = 1;
        item.pwdata = $urandom_range(3,18);
        finish_item(item);

for(int i=0;i<30;i++)begin

        start_item(item);
        item.paddr = 16'h80;
        item.pwrite = 1;
        item.pwdata [2 :0] = 3; //OPCODE
        item.pwdata [7 :3] = 5'd0; //rs0
        item.pwdata [12:8] = 5'd1; //rs1
        item.pwdata [20:16]= i+2; //DESTINATION
        item.pwdata [31:24]= 8; //IMM

        finish_item(item); 

        start_item(item);
        item.paddr = 16'h8C;
        item.pwrite = 1;
        item.pwdata = 1; //EV_CTRL_START
        finish_item(item); 

        start_item(item);
        item.paddr = 16'h84;
        item.pwrite = 0; //EV_CTRL_STATUS
        finish_item(item); 

        start_item(item);
        item.paddr = 16'h88;
        item.pwrite = 1;
        item.pwdata = 2; //EV_CTRL_FINISH
        finish_item(item); 

        start_item(item);
        item.paddr = (i+2)*4;
        item.pwrite = 0;
        finish_item(item); 
    end

    for(int i=0;i<30;i++)begin

        start_item(item);
        item.paddr = 16'h80;
        item.pwrite = 1;
        item.pwdata [2:0]= 4; //OPCODE
        item.pwdata [7:3]= 5'd0; //rs0
        item.pwdata [12:8]= 5'd1; //rs1
        item.pwdata [20:16]= i+2;
        item.pwdata [31:24]= 8; //IMM

        finish_item(item); 

        start_item(item);
        item.paddr = 16'h8C;
        item.pwrite = 1;
        item.pwdata = 1; //EV_CTRL_START
        finish_item(item); 

        start_item(item);
        item.paddr = 16'h84;
        item.pwrite = 0; //EV_CTRL_STATUS
        finish_item(item); 

        start_item(item);
        item.paddr = 16'h88;
        item.pwrite = 1;
        item.pwdata = 2; //EV_CTRL_FINISH
        finish_item(item); 

        start_item(item);
        item.paddr = (i+2)*4;
        item.pwrite = 0;
        finish_item(item); 
    end

    for(int i=0;i<30;i++)begin

        start_item(item);
        item.paddr = 16'h80;
        item.pwrite = 1;
        item.pwdata [2:0]= 2; //OPCODE
        item.pwdata [7:3]= 5'd0; //rs0
        item.pwdata [12:8]= 5'd1; //rs1
        item.pwdata [20:16]= i+2;
        item.pwdata [31:24]= 8; //IMM

        finish_item(item); 

        start_item(item);
        item.paddr = 16'h8C;
        item.pwrite = 1;
        item.pwdata = 1; //EV_CTRL_START
        finish_item(item); 

        start_item(item);
        item.paddr = 16'h84;
        item.pwrite = 0; //EV_CTRL_STATUS
        finish_item(item); 

        start_item(item);
        item.paddr = 16'h88;
        item.pwrite = 1;
        item.pwdata = 2; //EV_CTRL_FINISH
        finish_item(item); 

        start_item(item);
        item.paddr = (i+2)*4;
        item.pwrite = 0;
        finish_item(item); 
    end

    for(int i=0;i<30;i++)begin

        start_item(item);
        item.paddr = 16'h80;
        item.pwrite = 1;
        item.pwdata [2:0]= 0; //OPCODE
        item.pwdata [7:3]= 5'd0; //rs0
        item.pwdata [12:8]= 5'd1; //rs1
        item.pwdata [20:16]= i+2;
        item.pwdata [31:24]= 8; //IMM

        finish_item(item); 

        start_item(item);
        item.paddr = 16'h8C;
        item.pwrite = 1;
        item.pwdata = 1; //EV_CTRL_START
        finish_item(item); 

        start_item(item);
        item.paddr = 16'h84;
        item.pwrite = 0; //EV_CTRL_STATUS
        finish_item(item); 

        start_item(item);
        item.paddr = 16'h88;
        item.pwrite = 1;
        item.pwdata = 2; //EV_CTRL_FINISH
        finish_item(item); 

        start_item(item);
        item.paddr = (i+2)*4;
        item.pwrite = 0;
        finish_item(item); 
    end

    for(int i=0;i<30;i++)begin

        start_item(item);
        item.paddr = 16'h80;
        item.pwrite = 1;
        item.pwdata [2:0]= 1; //OPCODE
        item.pwdata [7:3]= 5'd0; //rs0
        item.pwdata [12:8]= 5'd1; //rs1
        item.pwdata [20:16]= i+2;
        item.pwdata [31:24]= 8; //IMM

        finish_item(item); 

        start_item(item);
        item.paddr = 16'h8C;
        item.pwrite = 1;
        item.pwdata = 1; //EV_CTRL_START
        finish_item(item); 

        start_item(item);
        item.paddr = 16'h84;
        item.pwrite = 0; //EV_CTRL_STATUS
        finish_item(item); 

        start_item(item);
        item.paddr = 16'h88;
        item.pwrite = 1;
        item.pwdata = 2; //EV_CTRL_FINISH
        finish_item(item); 

        start_item(item);
        item.paddr = (i+2)*4;
        item.pwrite = 0;
        finish_item(item); 
    end

    endtask: body
endclass: Config_test

////////////////////////////////////////////////////////TEST OPERATIONAL CONFIG//////////////////////////////////////////////////////

class Operation_config_test extends APB_sequence;
    `uvm_object_utils (Operation_config_test)

    function new (string name = "Operation_config_test");
        super.new (name);
    endfunction

    virtual task body();
        APB_item item;
        item = APB_item::type_id::create("item");

for(int i=0;i<50000;i++)begin

    start_item(item);
    item.paddr = $urandom_range(5'd0,5'd31) *4;
    item.pwrite = 1;
    item.pwdata = i;
    finish_item(item);

    start_item(item);
    item.paddr = $urandom_range(5'd0,5'd31) *4;
    item.pwrite = 1;
    item.pwdata = $urandom_range(32'hFFFFFF00,32'hFFFFFFFF);
    finish_item(item);

        start_item(item);
        item.paddr = 16'h80;
        item.pwrite = 1;
        item.pwdata [2 :0] = $urandom_range(3'd0,3'd4); //OPCODE
        item.pwdata [7 :3] = $urandom_range(5'd0,5'd31); //rs0
        item.pwdata [12:8] = $urandom_range(5'd0,5'd31); //rs1
        item.pwdata [20:16]= $urandom_range(5'd0,5'd31); //DESTINATION
        item.pwdata [31:24]= $urandom_range(8'd0,8'd255); //IMM

        finish_item(item); 

        start_item(item);
        item.paddr = 16'h8C;
        item.pwrite = 1;
        item.pwdata = 1; //EV_CTRL_START
        finish_item(item); 

        start_item(item);
        item.paddr = 16'h84;
        item.pwrite = 0; //EV_CTRL_STATUS
        finish_item(item); 

        start_item(item);
        item.paddr = 16'h88;
        item.pwrite = 1;
        item.pwdata = 2; //EV_CTRL_FINISH
        finish_item(item); 

        start_item(item);
        item.paddr = $urandom_range(5'd0,5'd31) *4;
        item.pwrite = 0;
        finish_item(item); 
    end


    endtask: body
endclass: Operation_config_test

////////////////////////////////////////////////////////TEST FULL COVERAGE//////////////////////////////////////////////////////

class Full_Coverage extends APB_sequence;
    `uvm_object_utils (Full_Coverage)

    function new (string name = "Full_Coverage");
        super.new (name);
    endfunction

    virtual task body();
        APB_item item;
        item = APB_item::type_id::create("item");

for(int i=0;i<100;i++)begin

    start_item(item);
    item.paddr  = $urandom_range(5'd0,5'd31) *4;
    item.pwrite = 1;
    item.pwdata = i*i;
    finish_item(item);

    start_item(item);
    item.paddr = $urandom_range(5'd0,5'd31) *4;
    item.pwrite = 1;
    item.pwdata = i*i;
    finish_item(item);

        start_item(item);
        item.paddr = 16'h80;
        item.pwrite = 1;
        item.pwdata [2 :0] = $urandom_range(3'd0,3'd4); //OPCODE
        item.pwdata [7 :3] = $urandom_range(5'd0,5'd31); //rs0
        item.pwdata [12:8] = $urandom_range(5'd0,5'd31); //rs1
        item.pwdata [20:16]= $urandom_range(5'd0,5'd31); //DESTINATION
        if(i<256)begin
            item.pwdata [31:24]= i; //IMM
        end
else begin
        item.pwdata [31:24]= $urandom_range(0,255); //IMM
end
        finish_item(item); 

        start_item(item);
        item.paddr = 16'h8C;
        item.pwrite = 1;
        item.pwdata = 1; //EV_CTRL_START
        finish_item(item); 

        start_item(item);
        item.paddr = 16'h84;
        item.pwrite = 0; //EV_CTRL_STATUS
        finish_item(item); 

        start_item(item);
        item.paddr = 16'h88;
        item.pwrite = 1;
        item.pwdata = 2; //EV_CTRL_FINISH
        finish_item(item); 

        start_item(item);
        item.paddr = $urandom_range(5'd0,5'd31) *4;
        item.pwrite = 0;
        finish_item(item); 
    end


    endtask: body
endclass: Full_Coverage