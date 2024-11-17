function void collect_led_transactions();
    led_trans_t led_trans;  // Assuming led_trans is a transaction object or struct
    forever begin
        led_mon2scb.get(led_trans);  // Collect LED transaction from the mailbox
        // Store the collected transaction in the scoreboard (e.g., for comparison)
        // You might add it to a list of transactions or directly compare it
    end
endfunction