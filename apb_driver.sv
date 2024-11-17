// The driver takes data from the generator at an abstract level and sends it to the DUT according to the communication protocol on the respective interface
//Gets the packet from generator and drive the transaction paket items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT)

// The macro APB_DRIV_IF is declared, which will represent the interface through which the driver will send data to the DUT
`define APB_DRIV_IF apb_vif.DRIVER.driver_cb
class apb_driver;

//Used to count the number of transactions
int no_transactions;

//Creating virtual interface handle
virtual apb_interface apb_vif;

// The port is created through which the driver receives data at an abstract level from the DUT
//Creating mailbox handle
mailbox gen2driv;

//Constructor
function new(virtual apb_interface apb_vif,mailbox gen2driv);
// When the driver is created, the interface through which it sends data is connected to the actual interface of the DUT
//Getting the interface
this.apb_vif = apb_vif;
//Getting the mailbox handles from environment
this.gen2driv = gen2driv;
endfunction

//Reset task, Reset the Interface signals to default/initial values
task reset;
wait(apb_vif.reset);
$display("--------- [APB DRIVER] Reset Started ---------");
`APB_DRIV_IF.pwrite <= 0;
`APB_DRIV_IF.paddr <= 0;
`APB_DRIV_IF.pwdata <= 0;
`APB_DRIV_IF.psel <= 0;
`APB_DRIV_IF.penable <= 0;
$display("%0t--------- [APB DRIVER] Reset Ended ---------", $time());
@(posedge apb_vif.clk);
endtask

//Drives the transaction items to interface signals
task drive;
apb_transaction trans;
//If the driver does not have data from the generator, it will remain at the line below until it receives the respective data
  
gen2driv.get(trans);
$display("%0t--------- [APB DRIVER-TRANSFER: %0d] ---------",$time(), no_transactions);
@(posedge apb_vif.clk);
$display("dupa primul front de ceas");
`APB_DRIV_IF.paddr <= trans.paddr;
`APB_DRIV_IF.pwrite <= trans.pwrite;
  if(trans.pwrite == 1) begin // Write transaction
`APB_DRIV_IF.pwdata <= trans.data;
$display("\tADDR = %0h \tDATA = %0h",trans.paddr,trans.data);
end
`APB_DRIV_IF.psel <= 1;
`APB_DRIV_IF.penable <= 0;
@(posedge apb_vif.MONITOR.clk);
`APB_DRIV_IF.penable <= 1;
$display("Before waiting for the wait statement");
  @(posedge apb_vif.MONITOR.clk iff `APB_DRIV_IF.pready == 1);
  $display("After waiting for the wait statement");
`APB_DRIV_IF.paddr <= {ADDR_WIDTH{1'bx}};
`APB_DRIV_IF.pwrite <= 1'b0;
`APB_DRIV_IF.psel <= 0;
`APB_DRIV_IF.penable <= 1'b0;
`APB_DRIV_IF.pwdata <= {DATA_WIDTH{1'bx}};
$display("\tADDR = %0h \tRDATA = %0h",trans.paddr,`APB_DRIV_IF.prdata);
$display("-----------------------------------------");
no_transactions++;
endtask


// The two threads of execution below run in parallel. Once the first one finishes, the second is automatically interrupted. If the reset is activated, no data is transmitted.
task main;
forever begin
fork
//Thread-1: Waiting for reset
begin
reset();
end
//Thread-2: Calling drive task
begin
// Data transmission is continuous but conditioned by receiving data from the monitor.
forever begin
wait(apb_vif.reset===0);
drive();
end
end
join_any
disable fork;
end
endtask

endclass