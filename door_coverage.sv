// Through coverage, we can see which situations (e.g., what types of transactions) have been generated in the simulation; this allows us to measure the progress of the verification.
class door_coverage;
  
  door_transaction trans_covered;
  
// To view the coverage value for each element, multiple coverage groups need to be created, or a custom display function should be implemented.
  covergroup transaction_cg;
// The line below is added because if there are multiple instances for which coverage is calculated, we want to know the value for each one separately.
    option.per_instance = 1;
    door_closed_cp: coverpoint trans_covered.door_closed;
    
  endgroup
// The coverage group is created; ATTENTION! Without the function below, the coverage group will never be able to sample data, as it has only been declared so far, not created.
  function new();
    transaction_cg = new();
  endfunction
  
  task sample(door_transaction trans_covered); // It is called every time there is a transaction in the monitor.
  	this.trans_covered = trans_covered; 
  	transaction_cg.sample(); 
  endtask:sample   
  
  function print_coverage();
    $display ("Close_door coverage = %.2f%%", transaction_cg.door_closed_cp.get_coverage());
    $display ("Overall coverage = %.2f%%", transaction_cg.get_coverage());
  endfunction
  
// Another way to end the declaration of a class is to write "endclass: class_name"; this is especially useful when multiple classes are declared in the same file. However, it is recommended that each file contain no more than one class declaration.
endclass: door_coverage

