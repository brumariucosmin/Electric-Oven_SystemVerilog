
`ifndef __ref
`define __ref
typedef enum logic[2:0] {IDLE, COOKING, HEATING, PIZZA, DEFROSTING} oven_processes; // a new data type concerning the states that the DUT can reach is created

//se declara prefixele pe care le vor avea elementele folosite pentru    a prelua datele de la agentul de intrari, respectiv de la agentul de    semafoare
mailbox apb_mon2scb;
mailbox door_mon2scb;
mailbox led_mon2scb;


class scoreboard;

  oven_processes current_DUT_state, next_DUT_state;

  logic [7:0] reg_timer;
  logic [7:0] reg_config;

  bit predicted_led;
  
  led_transaction led_trans;
  
  door_transaction door_trans;
  
  apb_transaction apb_trans;
  
  logic door_opened;
  
  
  function new();
    predicted_led=0;
  endfunction

  task run();
 fork
   collect_led_transactions();
   collect_apb_transactions();
   collect_door_transactions();
   predict_led_output();
 join_none
  endtask
  
  task collect_door_transaction();
    forever begin
      door_mon2scb.get(door_trans); // blocking instruction
      $display("Received door transaction: %0d", led_trans.door_closed);
      door_opened = ~led_trans.door_closed; // the scoreboard stores the status of the door each clock cycle
    end;
  endtask;

  task collect_apb_transaction();
    forever begin
      apb_mon2scb.get(apb_trans);
      $display("Received LED transaction: %0d", led_trans.led);
      
      // see when an operating mode begins
      if (apb_trans.pwrite == 1 && apb_trans.paddr == 1)
        if(apb_trans.data[3] ==1) //if data[3] is 1, the oven starts its process
      
      // predict state of the DUT
      if (apb_trans.pwrite == 1 && apb_trans.paddr == 1) // if there is a write transaction over the APB interface to the operation_mode register (address = 1), the new state of the DUT is predicted
        case(apb_trans.data[2:0]): // this is req signal
          0: case(current_DUT_state):
            	IDLE: current_DUT_state = IDLE;
            	COOKING: current_DUT_state = IDLE;
            	HEATING: current_DUT_state = IDLE;
                PIZZA: current_DUT_state = IDLE;
                DEFROSTING: current_DUT_state = IDLE;
          endcase
         1: case(current_DUT_state):
            	IDLE: current_DUT_state = COOKING;
            	COOKING: current_DUT_state = COOKING;
            	HEATING: current_DUT_state = HEATING;
                PIZZA: current_DUT_state = PIZZA;
                DEFROSTING: current_DUT_state = DEFROSTING;
         endcase
     	 2: case(current_DUT_state):
            	IDLE: current_DUT_state = HEATING;
            	COOKING: current_DUT_state = COOKING;
            	HEATING: current_DUT_state = HEATING;
                PIZZA: current_DUT_state = PIZZA;
                DEFROSTING: current_DUT_state = DEFROSTING;
           endcase
         3: case(current_DUT_state):
            	IDLE: current_DUT_state = PIZZA;
            	COOKING: current_DUT_state = COOKING;
            	HEATING: current_DUT_state = HEATING;
                PIZZA: current_DUT_state = PIZZA;
                DEFROSTING: current_DUT_state = DEFROSTING;
           endcase
         4: case(current_DUT_state):
                IDLE: current_DUT_state = DEFROSTING;
                COOKING: current_DUT_state = COOKING;
                HEATING: current_DUT_state = HEATING;
                PIZZA: current_DUT_state = PIZZA;
                DEFROSTING: current_DUT_state = DEFROSTING;
     	   endcase
          default: ; // a value greater than 4 in reg field of the operation_mode register is ignored
        endcase
      
      
        // 
      if (apb_trans.pwrite == 1 && apb_trans.paddr == 0)
        current_temperature = apb_trans.data[2:0];
    end;
  endtask;

   task collect_led_transactions();
    forever begin
      led_mon2scb.get(led_trans);
      if (led_trans.led !== predicted_led) begin
        $error("Mismatch: DUT value: %0d; scoreboard value: %0d", led_trans.led, predicted_led);
      end
      else begin
        $display("Match: DUT value: %0d; scoreboard value: %0d", led_trans.led, predicted_led);
      end
    end
  endtask

  // Funcția care face predicția semnalului LED pe baza intrărilor
  task predict_led_output();
    forever begin
      // Algoritmul de predicție: trebuie să fie personalizat pe baza specificațiilor proiectului
      // Exemplu simplificat:
      if (reg_config == 8'h01) begin
        predicted_led = 1;
      end else begin
        predicted_led = 0;
      end
      @(posedge clk); // Așteaptă ceasul înainte de a face predicții noi
    end
  endtask

endclass

`endif
