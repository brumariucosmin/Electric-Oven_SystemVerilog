function void collect_apb_transactions();
    apb_trans_t apb_trans;  // Assuming apb_trans is a transaction object or struct
    forever begin
        apb_mon2scb.get(apb_trans);  // Get the APB transaction
        // Perform any operations to extract the relevant data from the APB transaction
        // e.g., storing data for further use or checking APB register values
    end
endfunction