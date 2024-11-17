// The transactions in this context are generated completely randomly (the only constraint is in the transaction.sv file, ensuring the correct functionality of the DUT).
`include "environment.sv"
program test(apb_interface apb_intf, door_interface door_intf, led_interface led_intf);
  
//Declaring environment instance
  environment env;
  
  initial begin
//Creating environment
    env = new(apb_intf, door_intf, led_intf);
    
    
//Setting the repeat count of apb_generator as 4, means to apb_generate 4 packets
    env.apb_gen.write_reg_transaction(1, 'b011);//Activate pizza mode
    env.apb_gen.write_reg_transaction(2, 125);//Set time
    env.apb_gen.read_reg_transaction(2); //Read time register
    env.apb_gen.write_reg_transaction(1, 'b1010);//Pizza mode + start timer
    env.apb_gen.read_reg_transaction(1); //Read register with operating mode
    
//Calling run of env, it interns calls apb_generator and driver main tasks.
    env.run();
  end
endprogram