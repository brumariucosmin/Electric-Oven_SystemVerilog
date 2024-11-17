

//Interfaces
`include "apb_interface.sv"
`include "door_interface.sv"
`include "led_interface.sv"
//`include "random_test.sv"//
//`include "reg_test.sv"
`include "operation_mod_test.sv"
//`include "temperature_test.sv"
//`include "timp_reg_test.sv"
//`include "timp_modop_test.sv"

module cuptor_electric_top_tb;

 // Parameters
 localparam CLK_PERIOD = 20; // Clock periods in units of time
  
 // Input
 logic clk;
 logic reset;
 logic [7:0] timp_setat;
 logic door;
 logic start;
  
 // Outputs
 wire logic mod_ready;
 wire logic ready;
 wire logic temp_current;
 wire  timeout ;
 wire  timer_remain;
  
  apb_interface apb_intf(clk, reset);
  
  door_interface door_intf(clk, reset);
  
  led_interface led_intf(clk,reset);
 
// Instantiation of DUT
   cuptor_electric_top dut (
    .clk(clk),
    .reset(reset),
     .door(door_intf.door_closed),
     .paddr(apb_intf.paddr),
     .pwrite(apb_intf.pwrite),
     .psel(apb_intf.psel),
     .penable(apb_intf.penable),
     .pwdata(apb_intf.pwdata),
     .prdata(apb_intf.prdata),
     .pready(apb_intf.pready),
     .mod_ready(led_intf.led)
   
  );
 
  // Clock generator
 always #(CLK_PERIOD / 2) clk = ~clk;

 // Initialization for reset
 initial begin
  reset = 1;
  clk = 0;
  #50 reset = 0; //The reset is activated for a short time
  start <=1'b1;
  #100
  timp_setat <= 8'd2;
  

 end


  test t1(apb_intf, door_intf, led_intf);

  // Saving variables for waveform
  initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
end

endmodule