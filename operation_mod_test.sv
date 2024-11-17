// The transactions in this context are generated completely randomly (the only constraint is in the transaction.sv file, ensuring the correct functionality of the DUT).
`include "environment.sv"
program test(apb_interface apb_intf, door_interface door_intf, led_interface led_intf);
  
//Declaring environment instance
  environment env;
  
  initial begin
//Creating environment
    env = new(apb_intf, door_intf, led_intf);
    
//Setting the repeat count of generator as 4, means to generate 4 packets      
    env.apb_gen.write_reg_transaction(1, 'b011);//Pizza mode
    env.apb_gen.write_reg_transaction(2, 50);//Set time
    env.apb_gen.read_reg_transaction(2); //Read time register
    env.apb_gen.write_reg_transaction(1, 'b0011);//Pizza mode + start timer
    env.apb_gen.read_reg_transaction(1); //Read register with operating mode
    env.apb_gen.write_reg_transaction(0, 3);//Set temperature (150 degree celsius)
    env.apb_gen.read_reg_transaction(0); //Read register with temperature
    env.apb_gen.write_reg_transaction(1, 'b100);//Defrosting mode + start timer
    env.apb_gen.read_reg_transaction(1); //Read register with operating mode
    env.apb_gen.write_reg_transaction(1, 'b001);//Mode cooking + start timer
    env.apb_gen.read_reg_transaction(1); //Read register with operating mode
    env.apb_gen.write_reg_transaction(1, 'b010);//Heating mode + start timer
    env.apb_gen.read_reg_transaction(1); //Read register with operating mode
    
 
//calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram