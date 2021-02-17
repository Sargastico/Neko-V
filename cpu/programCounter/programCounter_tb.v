`timescale 1 ns/1 ns 
`include "programCounter.v"

module programCounterTest;

    integer i;

    reg           clk = 0;
    reg           reset = 0;
    reg   [31:0]  dataIn;
    wire  [31:0]  dataOut;
    reg           writeEnable;     // 1 => WRITE, 0 => READ
    reg           countEnable;     // 1 => COUNT UP, 0 => STOPPED
    reg           writeAdd;        // 1 => Add to PC, 0 => Set to PC

    always #10 clk = ~clk;

    programCounter counter(.clk(clk), .reset(reset), .dataIn(dataIn), 
                            .dataOut(dataOut), .writeEnable(writeEnable),
                             .writeAdd(writeAdd), .countEnable(countEnable));

    initial begin

        $dumpfile("programCounter_tb.vcd");
        $dumpvars(0, programCounterTest);
        $display("[!] Testing Program Counter");
        
        // Set Reset conditions
        reset = 1;
        dataIn = 0;
        writeEnable = 0;
        countEnable = 0;
        writeAdd = 0;

        #10

        // Test reset
        if (dataOut != 0) begin
            
            $error("Expected dataOut to be [%d] but got [%d].", 0, dataOut);

        end

        if (counter.programCounter != 0) begin 
            
            $error("Expected counter.programCounter to be [%d] but got [%d].", 0, counter.programCounter);

        end

        // Test Jump (Write-Set)
        dataIn = 32'hDEADBEEF;
        writeEnable = 1;
        reset = 0;

        #10

        dataIn = 0;

        if (dataOut != 32'hDEADBEEF) begin

            $error("Expected dataOut to be [%d] but got [%d].", 32'hDEADBEEF, dataOut);
            
        end

        if (counter.programCounter != 32'hDEADBEEF) begin 
           
            $error("Expected counter.programCounter to be [%d] but got [%d].", 32'hDEADBEEF, counter.programCounter);
        
        end

        // Test Jump (Write-Add)
        counter.programCounter = 32'hC;
        dataIn = 32'hFFFFFFFC; // -4
        writeEnable = 1;
        writeAdd = 1;
        reset = 0;

        #10

        dataIn = 0;

        if (dataOut != 32'h4) begin
            
            $error("Expected dataOut to be [%d] but got [%d].", 32'h4, dataOut);

        end 

        if (counter.programCounter != 32'h4) begin
            
            $error("Expected counter.programCounter to be [%d] but got [%d].", 32'h4, counter.programCounter);

        end 

        // Test Counter
        dataIn = 32'h00000004;
        writeEnable = 1;
        writeAdd = 0;

        #10

        writeEnable = 0;
        countEnable = 1;

        for (i = 0; i < 16; i++)begin

            #10
            if (dataOut != dataIn + i * 4) begin
                
                $error("Expected dataOut to be [%d] but got [%d].", dataIn + i * 4, dataOut);

            end 

        end

        #10

        $finish;

    end

endmodule
