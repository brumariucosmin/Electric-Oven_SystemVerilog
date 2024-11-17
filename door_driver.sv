// The driver takes data from the generator at an abstract level and sends it to the DUT according to the communication protocol on the respective interface
//Gets the packet from generator and drive the transaction paket items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT) 

// The DRIV_IF macro is declared, which will represent the interface through which the driver will send data to the DUT
`define DRIV_IF door_vif.DRIVER.driver_cb
class door_driver;
  
//Used to count the number of transactions
  int no_transactions;
  
//Creating virtual interface handle
  virtual door_interface door_vif;
  
// The port is created through which the driver receives data at an abstract level from the DUT
//Creating mailbox handle
  mailbox gen2driv;
  
//Constructor
  function new(virtual door_interface door_vif,mailbox gen2driv);
// When the driver is created, the interface through which it sends data is connected to the actual interface of the DUT
//Getting the interface
    this.door_vif = door_vif;
//Getting the mailbox handles from  environment 
    this.gen2driv = gen2driv;
  endfunction
  
//Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait(door_vif.reset);
    $display("--------- [DOOR DRIVER] Reset Started ---------");
    `DRIV_IF.door_closed <= 0;
        
    wait(!door_vif.reset);
    $display("--------- [DOOR DRIVER] Reset Ended ---------");
  endtask
  
//Drives the transaction items to interface signals
  task drive;
     door_transaction trans;
//If the driver does not have data from the generator, it will remain at the line below until it receives the respective data
      gen2driv.get(trans);
    $display("--------- [DOOR DRIVER-TRANSFER: %0d] ---------",no_transactions);
      @(posedge door_vif.DRIVER.clk);
        `DRIV_IF.door_closed <= trans.door_closed;
      
        $display("\door_closed = %0h",trans.door_closed);
        @(posedge door_vif.DRIVER.clk);
  
      
      $display("-----------------------------------------");
      no_transactions++;
  endtask
  
    
// The two threads of execution below run in parallel. Once the first one finishes, the second is automatically interrupted. If the reset is activated, no data is transmitted.
  task main;
    forever begin
      fork
        //Thread-1: Waiting for reset
        begin
          reset();
        end
        //Thread-2: Calling drive task
        begin
         // Data transmission is continuous but conditioned by receiving data from the monitor.
          forever
            drive();
        end
      join_any
      disable fork;
    end
  endtask
        
endclass