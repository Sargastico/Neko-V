`timescale 1 ns/1 ns 
`include "programCounter.v"

/* 
    Setting manual clock, because the 'always' thing is messing up with timing
    and I'm f#ck1ng sick of trying to make this shi77y works lol.


    srry oniii-chan >.<

*/

module programCounterTest;

    integer i;

    reg           clk = 0;
    reg           reset = 0;
    reg   [31:0]  dataIn;
    wire  [31:0]  dataOut;
    reg           write;     // 1 => WRITE, 0 => READ
    reg           count;     // 1 => COUNT UP, 0 => STOPPED
    reg           writeAdd;  // 1 => Add to PC, 0 => Set to PC

    programCounter counter(.clk(clk), .reset(reset), .dataIn(dataIn), 
                            .dataOut(dataOut), .write(write),
                             .writeAdd(writeAdd), .count(count));

    initial begin

        $dumpfile("programCounter_tb.vcd");
        $dumpvars(0, programCounterTest);
        $display("[!] Testing Program Counter");
        
        // Set Reset conditions
        clk = 0;
        reset = 1;
        dataIn = 0;
        write = 0;
        count = 0;
        writeAdd = 0;

        #10
        clk = 1;
        #10
        clk = 0;

        // Test reset
        if (dataOut != 0) begin
            
            $error("[-] Test Reset: Expected dataOut to be [%d] but got [%d].", 0, dataOut);

        end

        if (counter.programCounter != 0) begin 
            
            $error("[-] Test Reset: Expected counter.programCounter to be [%d] but got [%d].", 0, counter.programCounter);

        end

        // Test Jump (Write-Set)
        dataIn = 32'hDEADBEEF;
        write = 1;
        reset = 0;

        #10
        clk = 1;
        #10
        clk = 0;

        dataIn = 0;

        if (dataOut != 32'hDEADBEEF) begin

            $error("[-] Test Jump Write-Set: Expected dataOut to be [%d] but got [%d].", 32'hDEADBEEF, dataOut);
            
        end

        if (counter.programCounter != 32'hDEADBEEF) begin 
           
            $error("[-] Test Jump Write-Set: Expected counter.programCounter to be [%d] but got [%d].", 32'hDEADBEEF, counter.programCounter);
        
        end

        // Test Jump (Write-Add)
        counter.programCounter = 32'hC;
        dataIn = 32'hFFFFFFFC; // -4
        write = 1;
        writeAdd = 1;
        reset = 0;

        #10
        clk = 1;
        #10
        clk = 0;

        dataIn = 0;

        if (dataOut != 32'h4) begin
            
            $error("[-] Test Jump Write-Add: Expected dataOut to be [%d] but got [%d].", 32'h4, dataOut);

        end 

        if (counter.programCounter != 32'h4) begin
            
            $error("[-] Test Jump Write-Add: Expected counter.programCounter to be [%d] but got [%d].", 32'h4, counter.programCounter);

        end 

        // Test Counter
        dataIn = 32'h00000004;
        write = 1;
        writeAdd = 0;

        #10
        clk = 1;
        #10
        clk = 0;

        write = 0;
        count = 1;

        for (i = 0; i < 16; i++)begin
            

            if (dataOut != dataIn + i * 4) begin
                
                $error("[-] Test Counter: Expected dataOut to be [%d] but got [%d].", dataIn + i * 4, dataOut);

            end 

            #10
            clk = 1;
            #10
            clk = 0;    
        

        end

        #100

        $finish;

    end

endmodule
