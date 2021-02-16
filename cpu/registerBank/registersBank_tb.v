`timescale 1ns/1ns
`include "registersBank.v"


module registersTest;

    integer i;

    reg  clk = 0;
    reg  reset = 0;
    reg  [31:0] dataIn;
    wire [31:0] dataOut;
    reg  [16:0] select;
    reg  write;

    always #10 clk = ~clk;

    registerBank bank(.clk(clk), .reset(reset), .dataIn(dataIn), 
                        .dataOut(dataOut), .select(select), .write(write));

    initial begin
        
        $dumpfile("registersBank_tb.vcd");
        $dumpvars(0, registersTest);
        $display("[!] Testing registers bank...");
        
        reset = 1;
        dataIn = 0;
        select = 0;
        write = 0;

        if (dataOut != 0) begin
            
            $error("[-] Failed init dataOut as zero.");

        end 

        for (i = 1; i < 16; i++) begin
            
            if (bank.registers[i] != 0) begin
                
                $error("[-] Register [%d] was not set to zero during initialization.", i);

            end

        end

        reset = 0;
        dataIn = 32'hFFFFFFFF;  
        write = 1;

        for (i = 0; i < 17; i++) begin
            
            #20
            select = i;

        end

        write = 0;

        if (bank.registers[0] != 0) begin
            
            $error("[-] The value of register x0 was modified");

        end

        for (i = 1; i < 17; i++) begin

            if (bank.registers[i] != 32'hFFFFFFFF) begin
                
                $error("[-] Failed to load value into Register [%d] Got: [%d] Expected: [%d]", i, bank.registers[i], dataIn);

            end

        end

        #10 

        reset = 1;

        #10

        reset = 0;
        dataIn = 32'hFFFFFFFF;  
        write = 0;

        for (i = 0; i < 16; i++) begin
            
            #20
            select = i;

        end

        for (i = 1; i < 16; i++) begin

            if (bank.registers[i] != 0) begin
                
                $error("[-] Register [%d] 'Read-only' failed.", i);

            end

        end

        #5

        $finish;

    end

endmodule
