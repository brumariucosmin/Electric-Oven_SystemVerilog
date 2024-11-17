class apb_generator;
  
// Declare two objects of type apb_transaction to store the generated transactions and a temporary transaction.
  rand apb_transaction trans,tr;
  
// The number of transactions that will be generated.
  int  repeat_count;
 
// The mailbox for sending the packets to the driver.
  mailbox gen2driv;
  
// The event signaled at the end of data transmission.
  event ended;
  
// The class constructor, initializes the mailbox and the event.
  function new(mailbox gen2driv,event ended);
    this.gen2driv = gen2driv;
    this.ended    = ended;
    trans = new(); // An initial transaction is created.
  endfunction
  
// Main task, generates the transactions and places them in the mailbox.
  task main();
    repeat(repeat_count) begin
      if( !trans.randomize() ) 
        $fatal("Gen:: trans randomization failed");      
      tr = trans.do_copy();
      gen2driv.put(tr);
    end
// Signals the end of data transmission.
    -> ended; 
  endtask
  
// Task for generating a write transaction to the specified register.
  task write_reg_transaction( bit [ADDR_WIDTH-1:0] paddr_arg, bit [DATA_WIDTH-1:0] data_arg);
    if( !trans.randomize() with {paddr == paddr_arg; data == data_arg; pwrite == 1;})
      $fatal("Gen:: trans randomization failed");
    tr = trans.do_copy();
    gen2driv.put(tr);
  endtask
  
// Task for generating a read transaction from the specified register.
  task read_reg_transaction ( bit [ADDR_WIDTH-1:0] paddr_arg);
    if( !trans.randomize() with {paddr == paddr_arg; pwrite == 0;})
      $fatal("Gen:: trans randomization failed");
    tr = trans.do_copy();
    gen2driv.put(tr);
  endtask
    
endclass