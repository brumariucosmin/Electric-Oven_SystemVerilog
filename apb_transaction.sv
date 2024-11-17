//Here, the data type used to store the data transferred between the generator and the driver is declared; the monitor also captures the data from the interface, reassembles it using an object of this data type, and only then processes it.

class apb_transaction;
  
//The attributes of the class are declared.
//The fields declared with the keyword rand will receive random values when the randomize() function is applied.
  rand bit [ADDR_WIDTH-1:0] paddr;
  rand bit       pwrite;
  rand bit [DATA_WIDTH-1:0] data;
  rand int delay; //The clock cycles distance between two transactions on the APB interface
  
// Constraints represent a type of member of SystemVerilog classes, alongside attributes and methods
// This constraint specifies that either a write or a read operation is executed
// Constraints are applied by the compiler when the class attributes receive random values as a result of using the randomize() function
  
  constraint delay_c {delay <14 ; delay > 0; } 
  
// This function is called after the randomize() function is applied to the objects belonging to this class
// This function displays the randomized values of the class attributes
  
  function void post_randomize();
    $display("--------- [Trans] post_randomize ------");
    //$display("\t paddr  = %0h",paddr);
    $display("\t paddr  = %0h\t pwrite = %0h\t data = %0h\delay_c = %0h" ,paddr,pwrite,data,delay);
    $display("-----------------------------------------");
  endfunction
  
// Operator for copying one object into another (deep copy)
  function apb_transaction do_copy();
    apb_transaction trans;
    trans = new();
    trans.paddr  = this.paddr;
    trans.pwrite = this.pwrite;
    trans.data = this.data;
    trans.delay = this.delay;
    return trans;
  endfunction
endclass