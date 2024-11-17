// The transactions in this context are generated completely randomly (the only constraint is in the transaction.sv file, ensuring the correct functionality of the DUT).
`include "environment.sv"
program test(apb_interface apb_intf, door_interface door_intf, led_interface led_intf);
  
//Declaring environment instance
  environment env;
  
  initial begin
//Creating environment
    env = new(apb_intf, door_intf, ready_intf);
    
    
//Setting the repeat count of generator as 4, means to generate 4 packets
    env.apb_gen.write_reg_transaction(0,1);//Set 50 degree celsius 
    env.apb_gen.write_reg_transaction(0,3);//Set 150 degree celsius
    env.apb_gen.write_reg_transaction(1,'b011);//Pizza mode
    
    
//Calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram