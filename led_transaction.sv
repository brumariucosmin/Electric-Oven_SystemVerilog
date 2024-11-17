//Here, the data type used to store the data transferred between the generator and the driver is declared; the monitor also captures the data from the interface, reassembles it using an object of this data type, and only then processes it.
class led_transaction;
//The attributes of the class are declared.
//The fields declared with the keyword rand will receive random values when the randomize() function is applied.
  
  rand bit led;

// Constraints represent a type of member of SystemVerilog classes, alongside attributes and methods
// This constraint specifies that either a write or a read operation is executed
// Constraints are applied by the compiler when the class attributes receive random values as a result of using the randomize() function
  
  
// This function is called after the randomize() function is applied to the objects belonging to this class
// This function displays the randomized values of the class attributes
  
  function void post_randomize();
    $display("--------- [Trans] post_randomize ------");
    $display("\t Led  = %0h",led);
    $display("-----------------------------------------");
  endfunction
  
// Operator for copying one object into another (deep copy)
  function led_transaction do_copy();
    led_transaction trans;
    trans = new();
    trans.led  = this.led;
    return trans;
  endfunction
endclass