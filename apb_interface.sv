interface apb_interface(input logic clk, reset);
//Signal declaration  
  logic [ADDR_WIDTH-1:0] paddr;
  logic psel;
  logic penable;
  logic pwrite;
  logic [DATA_WIDTH-1:0] pwdata;
  logic pready;
  logic [DATA_WIDTH-1:0] prdata;
  
//Driver
  clocking driver_cb @(posedge clk);
// Input signals are read one unit of time before the clock edge, and output signals are read one unit of time after the clock edge; this eliminates situations where writing and reading occur at the same time.   
    default input #1 output #1;
    output paddr;
    output psel;
    output penable;
    output pwrite;
    output pwdata;
    input pready;
    input prdata;
  endclocking
    
//Monitor
    clocking monitor_cb @(posedge clk);
// Input signals are read one unit of time before the clock edge, and output signals are read one unit of time after the clock edge; this eliminates situations where writing and reading occur simultaneously.
    default input #1 output #1;
      input paddr;
      input psel;
      input penable;
      input pwrite;
      input pwdata;
      input pready;
      input prdata;
    endclocking
  
// modport (used to define the direction of the signals)
  	  modport DRIVER	(clocking driver_cb, input clk, reset);
      modport MONITOR	(clocking monitor_cb, input clk, reset);
      
      property psel_and_penable_active;
        @(posedge clk) disable iff(reset)
        $rose(psel) |-> ##1 $rose(penable);
      endproperty
        assert property (psel_and_penable_active);
          
       property pready_after_psel_falls;
         @(posedge clk) disable iff(reset)
         $fell(psel) |-> $fell(pready);
       endproperty
          assert property (pready_after_psel_falls);
            
       property pwdata_activate_at_psel_and_pwrite;
         @(posedge clk) disable iff(reset)
         psel && pwrite |-> pwdata;
       endproperty
       assert property (pwdata_activate_at_psel_and_pwrite);
              
       property pready_ends;
         @(posedge clk) disable iff(reset)
         pready ##1 (!pready);
       endproperty
       assert property(pready_ends);
         
         property prdata_activate;
         @(posedge clk) disable iff(reset)
         psel && !penable |-> prdata;
       endproperty
         assert property(prdata_activate);
endinterface              