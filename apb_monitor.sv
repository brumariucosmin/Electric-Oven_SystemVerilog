// The monitor observes the traffic on the DUT's interfaces, captures the verified data, and reassembles the transactions (using objects of the transaction class); in this implementation, the data captured from the interfaces is sent to the scoreboard for verification.
//Samples the interface signals, captures into transaction packet and send the packet to scoreboard.

// In the APB_MON_IF macro, the block of signals from which the monitor extracts data is stored.
`define APB_MON_IF apb_vif.MONITOR.monitor_cb
class apb_monitor;
  
//Creating virtual interface handle
  virtual apb_interface apb_vif;

  apb_coverage coverage_collector;
  
// The port is created through which the monitor sends the collected data from the DUT interface to the scoreboard in the form of transactions
//Creating mailbox handle
  mailbox mon2scb;
  
// When the monitor object is created (in the environment.sv file), the interface from which it collects data is connected to the actual interface of the DUT.
//Constructor
  function new(virtual apb_interface apb_vif,mailbox mon2scb);
//Getting the interface
    this.apb_vif = apb_vif;
//Getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
    
    coverage_collector = new();
  endfunction
  
//Samples the interface signal and send the sample packet to scoreboard
  task main;
    forever begin

// The transaction object is declared and created, which will contain the data collected from the interface.
      apb_transaction trans;
      trans = new();

// Data is read on the clock edge, and the information collected from the signals is stored in the transaction object.
      
//If pwrite == 1, then data is taken from pwdata; otherwise, from prdata
      @(posedge apb_vif.MONITOR.clk iff `APB_MON_IF.pready ==1);
     
      if(trans.pwrite == 1)
       trans.data = `APB_MON_IF.pwdata;
        else 
       trans.data = `APB_MON_IF.prdata;
      trans.paddr  = `APB_MON_IF.paddr;
      trans.pwrite = `APB_MON_IF.pwrite;
              
// After the transaction information has been recorded, the content of the trans object is sent to the scoreboard.
        mon2scb.put(trans);
      
      coverage_collector.sample(trans);
    end
  endtask
  
endclass