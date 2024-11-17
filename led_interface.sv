interface led_interface(input logic clk, reset);
//Signal declaration
  logic led;
  
//Driver
  clocking driver_cb @(posedge clk);
// Input signals are read one unit of time before the clock edge, and output signals are read one unit of time after the clock edge; this eliminates situations where writing and reading occur at the same time.   
    default input #1 output #1;
    output led;
  endclocking
  
//Monitor
    clocking monitor_cb @(posedge clk);
// Input signals are read one unit of time before the clock edge, and output signals are read one unit of time after the clock edge; this eliminates situations where writing and reading occur simultaneously.
      default input #1 output #1;
        input led;
    endclocking
  
// modport (used to define the direction of the signals)
 	modport DRIVER	(clocking driver_cb, input clk, reset);
      modport MONITOR	(clocking monitor_cb, input clk, reset);
endinterface
  