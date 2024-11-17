// We define a monitor class to track the state of the LED
class led_monitor;
  
// We declare a virtual interface to access the LED signals
  virtual led_interface led_vif;
  led_coverage coverage_collector;
// We declare a mailbox to send the monitored data to the scoreboard
  mailbox mon2scb;

// The class constructor
  function new(virtual led_interface led_vif, mailbox mon2scb);
    this.led_vif = led_vif;
    this.mon2scb = mon2scb;
    coverage_collector = new();
  endfunction

// The main task of the monitor
  task main;
    forever begin

// If the LED has been updated, send a transaction to the scoreboard
        led_transaction trans = new();
      
// Wait on the clock edge to capture the data
      @(posedge led_vif.MONITOR.clk);
  trans.led = led_vif.MONITOR.monitor_cb.led;
       
// Send the transaction to the scoreboard
        mon2scb.put(trans);
      coverage_collector.sample(trans);
    end
  endtask
endclass