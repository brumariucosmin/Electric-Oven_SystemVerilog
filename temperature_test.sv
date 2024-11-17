// The transactions in this context are generated completely randomly (the only constraint is in the transaction.sv file, ensuring the correct functionality of the DUT).
`include "environment.sv"
program test(apb_interface apb_intf, door_interface door_intf, led_interface led_intf);
  
//Declaring environment instance
  environment env;
  
  initial begin
//Creating environment
    env = new(apb_intf, door_intf, led_intf);
    
    
//Setting the repeat count of apb_generator as 4, means to apb_generate 4 packets
    env.apb_gen.write_reg_transaction(1, 'b011);//Pizza mode
    env.apb_gen.write_reg_transaction(2, 10);//Set time
    env.apb_gen.read_reg_transaction(2); //Read time register
    env.apb_gen.write_reg_transaction(1, 'b1010);//Pizza mode + start timer
    env.apb_gen.read_reg_transaction(1); //Read register with operating mode
    env.apb_gen.write_reg_transaction(0, 4);//Set temperature 200 degrees
    env.apb_gen.read_reg_transaction(0); //Read register with temperature
    env.apb_gen.write_reg_transaction(0, 3);//Set temperature 150 degrees
    env.apb_gen.read_reg_transaction(0); //Read register with temperature
    repeat(2)
      env.apb_gen.write_reg_transaction(0, 1);//Set temperature 50 degrees
    env.apb_gen.read_reg_transaction(0); //Read register with temperature
    
//Calling run of env, it interns calls apb_generator and driver main tasks.
    env.run();
  end
endprogram