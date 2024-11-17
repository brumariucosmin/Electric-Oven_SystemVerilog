// In the verification environment, all verification components are instantiated
//Transactions
`include "apb_transaction.sv"
`include "led_transaction.sv"
`include "door_transaction.sv"
//Drivers
`include "apb_driver.sv"
`include "door_driver.sv"

//Coverages
`include "apb_coverage.sv"
`include "door_coverage.sv"
`include "led_coverage.sv"
//Monitors
`include "apb_monitor.sv"
`include "led_monitor.sv"
`include "door_monitor.sv"
//Generators
`include "apb_generator.sv"
`include "door_generator.sv"

//Scoreboard
///`include "scoreboard.sv"

class environment;
  
// The verification components are declared
//Generator and driver instance
  
  apb_generator apb_gen;
  door_generator door_gen;
  apb_driver   apb_driv;
  door_driver  door_driv;
  apb_monitor  apb_mon;
  led_monitor  led_mon;
  door_monitor door_mon;
///  scoreboard   scb;
  
//Mailbox handle's
  mailbox apb_gen2driv;
  mailbox door_gen2driv;
  mailbox apb_mon2scb;
  mailbox led_mon2scb;
  mailbox door_mon2scb;
  
//Event for synchronization between generator and test
  event gen_ended;
  
//Virtual interface
  virtual apb_interface apb_vif;
  virtual door_interface door_vif;
  virtual led_interface led_vif;
  
//Constructor
  function new(virtual apb_interface apb_vif, virtual door_interface door_vif, virtual led_interface led_vif);
//Get the interface from test
    this.apb_vif = apb_vif;
    this.door_vif = door_vif;
    this.led_vif = led_vif; 
    
//Creating the mailbox (Same handle will be shared across generator and driver)
    apb_gen2driv = new();
    door_gen2driv = new();
    apb_mon2scb  = new();
    led_mon2scb  = new();
    door_mon2scb  = new();
    
// The verification components are created
//Creating generator and driver
    apb_gen  = new(apb_gen2driv,gen_ended);
    door_gen  = new(door_gen2driv,gen_ended);
    apb_driv = new(apb_vif,apb_gen2driv);
    door_driv = new(door_vif,door_gen2driv);
    apb_mon  = new(apb_vif,apb_mon2scb);
    door_mon  = new(door_vif,door_mon2scb);
    led_mon = new(led_vif,led_mon2scb);
///    scb  = new(mon2scb);
  endfunction
  
  task pre_test();
   // driv.reset();
  endtask
  
  task test();
    fork 
    // apb_gen.main();
      door_gen.main();
      apb_driv.main();
      door_driv.main();
      apb_mon.main();
      door_mon.main();
      led_mon.main();
///      scb.main();      
    join_none
  endtask
  
  task post_test();
    
   /* wait(gen_ended.triggered);
   
// It is ensured that all generated data is sent to the DUT and also reaches the scoreboard.
    wait(gen.repeat_count == driv.no_transactions);
    wait(gen.repeat_count == scb.no_transactions);*/
  endtask  
  
  function report();
///    scb.colector_coverage.print_coverage();
    apb_mon.coverage_collector.print_coverage();
  endfunction
  
//Run task
  task run;
    $display("11111111111111111");
    pre_test();
    $display("222222222222222222222");
    test();
    $display("3333333333333333333333333");
    post_test();
    $display("44444444444444444444444444");
    report();
    $display("55555555555555555555555");
// The line below is necessary for the simulation to end.
    #10000
    $finish;
  endtask
  
endclass

