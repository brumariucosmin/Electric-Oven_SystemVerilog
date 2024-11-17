class door_generator;
  
//Declare two objects of type transaction
  rand door_transaction trans,tr;
  
//The number of transaction that will be generated
  int  repeat_count = 20;
  
//mailbox, to generate and send the packet to driver
  mailbox gen2driv;
  
//The event signaled at the end of data transmission
  event ended;
  
//Constructor
  function new(mailbox gen2driv,event ended);
//Getting the mailbox handle from env, in order to share the transaction packet between the generator and driver, the same mailbox is shared between both.
    this.gen2driv = gen2driv;
    this.ended    = ended;
    trans = new();
  endfunction
  
//Main task, generates(create and randomizes) the repeat_count number of transaction packets and puts into mailbox
  task main();
    $display("The main function of the door generator"); 
    $display("The value of repeat_count is %0d", repeat_count);
    repeat(repeat_count) begin
      $display("The value of repeat_count is %0d", repeat_count);
    	if( !trans.randomize() ) 
          $fatal("Gen:: trans randomization failed");      
    	tr = trans.do_copy();
    	gen2driv.put(tr);
      $display("%0t Data is being sent through the door", $time());
    end
// The end of data transmission by the generator is signaled
    -> ended; 
  endtask
  
endclass