//Here, the data type used to store the data transferred between the generator and the driver is declared; the monitor also captures the data from the interface, reassembles it using an object of this data type, and only then processes it.
class door_transaction;
//The attributes of the class are declared.
//The fields declared with the keyword rand will receive random values when the randomize() function is applied.
  rand bit  door_closed;
  constraint door_closed_c {door_closed dist{1:=9, 0:=1};}

// Constraints represent a type of member of SystemVerilog classes, alongside attributes and methods
// This constraint specifies that either a write or a read operation is executed
// Constraints are applied by the compiler when the class attributes receive random values as a result of using the randomize() function
  
// This function is called after the randomize() function is applied to the objects belonging to this class
// This function displays the randomized values of the class attributes
  function void post_randomize();
    $display("--------- [Trans] post_randomize ------");
    //$display("\t addr  = %0h",addr);
    $display("door_closed = %0h" ,door_closed);
    $display("-----------------------------------------");
  endfunction
  
// Operator for copying one object into another (deep copy)
  function door_transaction do_copy();
    door_transaction trans;
    trans = new();
    trans.door_closed = this.door_closed;
    return trans;
  endfunction
endclass