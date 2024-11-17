// The transactions in this context are generated completely randomly (the only constraint is in the transaction.sv file, ensuring the correct functionality of the DUT).
`include "environment.sv"
program test(apb_interface apb_intf, door_interface door_intf, led_interface led_intf);
  
//Declaring environment instance
  environment env;
  
  initial begin
//Creating environment
    env = new(apb_intf, door_intf, led_intf);
    
    
//setting the repeat count of apb_generator as 4, means to apb_generate 4 packets
    
    //Aici
    env.apb_gen.read_reg_transaction(0); 
    env.apb_gen.read_reg_transaction(1); 
    env.apb_gen.read_reg_transaction(2); 
    env.apb_gen.write_reg_transaction(0,$random());// Register with 0x55
    env.apb_gen.read_reg_transaction(0); 
    env.apb_gen.write_reg_transaction(1,$random());//Register with 0x55
    env.apb_gen.read_reg_transaction(1); 
    env.apb_gen.write_reg_transaction(2,$random());//Register with  0x55
    env.apb_gen.read_reg_transaction(2); 
    
    env.apb_gen.write_reg_transaction(0,8'b01010101);//Register with 0x55
    env.apb_gen.read_reg_transaction(0); 
    env.apb_gen.write_reg_transaction(1,8'b01010101);//Register with 0x55
    env.apb_gen.read_reg_transaction(1); 
    env.apb_gen.write_reg_transaction(2,8'b01010101);//Register with 0x55
    env.apb_gen.read_reg_transaction(2); 
    
 
    env.apb_gen.write_reg_transaction(0,8'b10101010);//Register with 0x55
    env.apb_gen.read_reg_transaction(0); 
    env.apb_gen.write_reg_transaction(1,8'b10101010);//Register with 0x55
    env.apb_gen.read_reg_transaction(1); 
    env.apb_gen.write_reg_transaction(2,8'b10101010);//Register with 0x55
    env.apb_gen.read_reg_transaction(2); 
    
    
//calling run of env, it interns calls apb_generator and driver main tasks.
    env.run();
  end
endprogram