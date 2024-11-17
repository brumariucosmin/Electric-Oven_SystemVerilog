interface door_interface(input logic clk, reset);
//Signal declaration 
  logic door_closed;

//Driver  
  clocking driver_cb @(posedge clk);
// An input signal is read one unit of time before the clock edge, and an output signal is read one unit of time after the clock edge; this eliminates situations where writing and reading occur at the same time.
    default input #1 output #1;
    output door_closed;
  endclocking
  
//Monitor
  clocking monitor_cb @(posedge clk);
// An input signal is read one unit of time before the clock edge, and an output signal is read one unit of time after the clock edge; this eliminates situations where writing and reading occur simultaneously.
    default input #1 output #1;
    input door_closed;
  endclocking
  
// modport (used to define the direction of the signals)
  modport DRIVER	(clocking driver_cb, input clk, reset);
    modport MONITOR	(clocking monitor_cb, input clk, reset);
  
endinterface