`timescale 1 ns/1 ns
`include "cpu.v"

module CPUTest;

    localparam ms = 1e6;
    localparam us = 1e3;
    localparam memorySize = 131072;
    localparam timeoutClocks = 2000;

    integer i, j;

    reg           clk = 0;
    reg           reset = 0;
    reg   [31:0]  dataIn;
    wire  [31:0]  dataOut;
    wire  [31:0]  address;
    wire          busWriteEnable;     // 1 => WRITE, 0 => READ

    reg   [31:0]  memory [0:memorySize-1];

    // Our device under test
    CPU cpu(.clk(clk), .reset(reset), .dataIn(dataIn), .dataOut(dataOut), .address(address), .busWriteEnable(busWriteEnable));

    always @(posedge clk) begin

        if (address[1:0] != 0) begin
            
            $error("[-] unaligned memory access at [%08x]", address);

        end

        if (busWriteEnable) begin

            memory[address[31:2]] <= dataOut;
            dataIn <= dataOut;

        end

        else begin

            dataIn <= memory[address[31:2]];

        end

        if (address == cpu.decoder.ExceptionHandlerAddress) begin

            $error("[-] Exception handler reached (%08x) at [%08x]", address, cpu.registers.registers[1]);
            $finish;

        end

    end

    initial begin

        $dumpfile("cpu_test.vcd");
        $dumpvars(0, CPUTest);
        $display("[!] Testing cpu...");

        for (i = 0; i < memorySize; i=i+1) begin

            memory[i] = 32'b0;

        end

        // Test ALU
        $readmemh("test/alu.mem", memory);

        // Reset
        reset = 1;
        dataIn = 0;

        repeat(4) begin

            #10
            clk = 1;
            #10
            clk = 0;

        end

        reset = 0;
        $info("[!] Testing ADDI");

        j = 0;
        while (address != 32'h3C) begin // End of ADDI

            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;

            if (j > timeoutClocks) begin

                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (cpu.registers.registers[0] != 32'h000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 0, 32'h000, cpu.registers.registers[0]);
        if (cpu.registers.registers[1] != 32'h3E8) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 1, 32'h3E8, cpu.registers.registers[1]);
        if (cpu.registers.registers[2] != 32'hBB8) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 2, 32'hBB8, cpu.registers.registers[2]);
        if (cpu.registers.registers[3] != 32'h7D0) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 3, 32'h7D0, cpu.registers.registers[3]);
        if (cpu.registers.registers[4] != 32'h000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 4, 32'h000, cpu.registers.registers[4]);
        if (cpu.registers.registers[5] != 32'h3E8) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 5, 32'h3E8, cpu.registers.registers[5]);
        if (cpu.registers.registers[6] != 32'hBB8) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 6, 32'hBB8, cpu.registers.registers[6]);
        if (cpu.registers.registers[7] != 32'h7D0) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 7, 32'h7D0, cpu.registers.registers[7]);
        if (cpu.registers.registers[8] != 32'h000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 8, 32'h000, cpu.registers.registers[8]);
        if (cpu.registers.registers[9] != 32'h3E8) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 9, 32'h3E8, cpu.registers.registers[9]);
        if (cpu.registers.registers[10] != 32'hBB8) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 10, 32'hBB8, cpu.registers.registers[10]);
        if (cpu.registers.registers[11] != 32'h7D0) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 11, 32'h7D0, cpu.registers.registers[11]);
        if (cpu.registers.registers[12] != 32'h000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 12, 32'h000, cpu.registers.registers[12]);
        if (cpu.registers.registers[13] != 32'h3E8) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 13, 32'h3E8, cpu.registers.registers[13]);
        if (cpu.registers.registers[14] != 32'hBB8) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 14, 32'hBB8, cpu.registers.registers[14]);
        if (cpu.registers.registers[15] != 32'h7D0) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 15, 32'h7D0, cpu.registers.registers[15]);

        $info("[!] Testing SLTI/SLTIU");
        j = 0;

        while (address != 32'h58) begin // End of slti / sltiu
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin

                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (cpu.registers.registers[10] != 32'h0) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 10, 32'h0, cpu.registers.registers[10]);
        if (cpu.registers.registers[11] != 32'h1) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 11, 32'h1, cpu.registers.registers[11]);
        if (cpu.registers.registers[12] != 32'h1) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 12, 32'h1, cpu.registers.registers[12]);
        if (cpu.registers.registers[13] != 32'h0) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 13, 32'h0, cpu.registers.registers[13]);
        if (cpu.registers.registers[14] != 32'h0) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 14, 32'h0, cpu.registers.registers[14]);
        if (cpu.registers.registers[15] != 32'h1) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 15, 32'h1, cpu.registers.registers[15]);

        $info("[!] Testing XORI");

        j = 0;
        while (address != 32'h70) begin // End of xori
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin

                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (cpu.registers.registers[13] != 32'hFFFFFF0F) $error("[-] Expected [X%02d] to be %08x but got [%08x]", 13, 32'hFFFFFF0F, cpu.registers.registers[13]);
        if (cpu.registers.registers[14] != 32'hFFFFF8F0) $error("[-] Expected [X%02d] to be %08x but got [%08x]", 14, 32'hFFFFF8F0, cpu.registers.registers[14]);
        if (cpu.registers.registers[15] != 32'hFFFFF800) $error("[-] Expected [X%02d] to be %08x but got [%08x]", 15, 32'hFFFFF800, cpu.registers.registers[15]);

        $info("[!] Testing ORI");

        j = 0;
        while (address != 32'h94) begin // End of ori

            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin

                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (cpu.registers.registers[10] != 32'h000000F0) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 10, 32'h000000F0, cpu.registers.registers[10]);
        if (cpu.registers.registers[11] != 32'h0000070F) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 11, 32'h0000070F, cpu.registers.registers[11]);
        if (cpu.registers.registers[12] != 32'h000007FF) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 12, 32'h000007FF, cpu.registers.registers[12]);
        if (cpu.registers.registers[13] != 32'hFFFFFFFF) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 13, 32'hFFFFFFFF, cpu.registers.registers[13]);
        if (cpu.registers.registers[14] != 32'hFFFFFFFF) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 14, 32'hFFFFFFFF, cpu.registers.registers[14]);
        if (cpu.registers.registers[15] != 32'hFFFFFFFF) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 15, 32'hFFFFFFFF, cpu.registers.registers[15]);

        $info("[!] Testing ANDI");

        j = 0;
        while (address != 32'hb8) begin // End of andi
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin

                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (cpu.registers.registers[10] != 32'h00000050) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 10, 32'h00000050, cpu.registers.registers[10]);
        if (cpu.registers.registers[11] != 32'h00000105) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 11, 32'h00000105, cpu.registers.registers[11]);
        if (cpu.registers.registers[12] != 32'h00000155) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 12, 32'h00000155, cpu.registers.registers[12]);
        if (cpu.registers.registers[13] != 32'h000000F0) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 13, 32'h000000F0, cpu.registers.registers[13]);
        if (cpu.registers.registers[14] != 32'h0000070F) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 14, 32'h0000070F, cpu.registers.registers[14]);
        if (cpu.registers.registers[15] != 32'h000007FF) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 15, 32'h000007FF, cpu.registers.registers[15]);

        $info("[!] Testing SLLI");

        j = 0;
        while (address != 32'hd8) begin // End of slli
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin
            
                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (cpu.registers.registers[9] != 32'hFF000000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]",  9, 32'h00000050, cpu.registers.registers[9]);
        if (cpu.registers.registers[10] != 32'h07FF0000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 10, 32'h00000050, cpu.registers.registers[10]);
        if (cpu.registers.registers[11] != 32'h0007FF00) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 11, 32'h00000105, cpu.registers.registers[11]);
        if (cpu.registers.registers[12] != 32'h00003FF8) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 12, 32'h00000155, cpu.registers.registers[12]);
        if (cpu.registers.registers[13] != 32'h00001FFC) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 13, 32'h000000F0, cpu.registers.registers[13]);
        if (cpu.registers.registers[14] != 32'h00000FFE) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 14, 32'h0000070F, cpu.registers.registers[14]);
        if (cpu.registers.registers[15] != 32'h000007FF) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 15, 32'h000007FF, cpu.registers.registers[15]);

        $info("[!] Testing SRLI");

        j = 0;

        while (address != 32'hfc) begin // End of srli
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin
            
                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (cpu.registers.registers[9] != 32'h000000FF) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 9, 32'h00000050, cpu.registers.registers[9]);
        if (cpu.registers.registers[10] != 32'h0000FF00) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 10, 32'h00000050, cpu.registers.registers[10]);
        if (cpu.registers.registers[11] != 32'h00FF0000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 11, 32'h00000105, cpu.registers.registers[11]);
        if (cpu.registers.registers[12] != 32'h1FE00000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 12, 32'h00000155, cpu.registers.registers[12]);
        if (cpu.registers.registers[13] != 32'h3FC00000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 13, 32'h000000F0, cpu.registers.registers[13]);
        if (cpu.registers.registers[14] != 32'h7F800000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 14, 32'h0000070F, cpu.registers.registers[14]);
        if (cpu.registers.registers[15] != 32'hFF000000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 15, 32'h000007FF, cpu.registers.registers[15]);

        $info("[!] Testing SRAI");

        j = 0;
        while (address != 32'h11c) begin // End of srai
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin
            
                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (cpu.registers.registers[9] != 32'hFFFFFFFF) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 9, 32'hFFFFFFFF, cpu.registers.registers[9]);
        if (cpu.registers.registers[10] != 32'hFFFFFF00) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 10, 32'hFFFFFF00, cpu.registers.registers[10]);
        if (cpu.registers.registers[11] != 32'hFFFF0000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 11, 32'hFFFF0000, cpu.registers.registers[11]);
        if (cpu.registers.registers[12] != 32'hFFE00000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 12, 32'hFFE00000, cpu.registers.registers[12]);
        if (cpu.registers.registers[13] != 32'hFFC00000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 13, 32'hFFC00000, cpu.registers.registers[13]);
        if (cpu.registers.registers[14] != 32'hFF800000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 14, 32'hFF800000, cpu.registers.registers[14]);
        if (cpu.registers.registers[15] != 32'hFF000000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 15, 32'hFF000000, cpu.registers.registers[15]);

        $info("[!] Testing ADD");

        j = 0;
        while (address != 32'h12c) begin // End of ADD
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin
            
                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (cpu.registers.registers[13] != 32'hFF000000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 13, 32'hFF000000, cpu.registers.registers[13]);
        if (cpu.registers.registers[14] != 32'hFEFFFFFF) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 14, 32'hFEFFFFFF, cpu.registers.registers[14]);
        if (cpu.registers.registers[15] != 32'hFE000000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 15, 32'hFE000000, cpu.registers.registers[15]);

        $info("[!] Testing SUB");

        j = 0;
        while (address != 32'h13c) begin // End of SUB
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin
            
                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (cpu.registers.registers[13] != 32'h01000000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 13, 32'h01000000, cpu.registers.registers[13]);
        if (cpu.registers.registers[14] != 32'hFF000001) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 14, 32'hFF000001, cpu.registers.registers[14]);
        if (cpu.registers.registers[15] != 32'h00000000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 15, 32'h00000000, cpu.registers.registers[15]);

        // [Test] Jmps
        for (i = 0; i < memorySize; i = i + 1) begin
        
            memory[i] = 32'b0;

        end

        // Test Jmps
        $readmemh("test/jmps.mem", memory);

        // Reset
        reset = 1;
        dataIn = 0;

        repeat(4) begin

            #10
            clk = 1;
            #10
            clk = 0;

        end

        reset = 0;

        $info("[!] Testing BEQ");

        j = 0;
        while (address != 32'h34) begin // End of BEQ
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin
            
                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);
        $info("[!] Testing BNE");
        
        j = 0;
        while (address != 32'h4C) begin // End of BNE
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin
            
                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);
        $info("[!] Testing BLT");

        j = 0;
        while (address != 32'h7C) begin // End of BLT
    
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin

                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);
        $info("[!] Testing BGE");

        j = 0;
        while (address != 32'hB8) begin // End of BGE

            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin
            
                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);
        $info("[!] Testing BLTU");

        j = 0;
        while (address != 32'hD0) begin // End of BLTU
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin

                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);
        $info("[!] Testing BGEU");

        j = 0;
        while (address != 32'hE4) begin // End of BGEU
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin
            
                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        for (i = 0; i < memorySize; i = i + 1) begin
        
            memory[i] = 32'b0;

        end

        // Test Jmps
        $readmemh("test/luiauipc.mem", memory);

        // Reset
        reset = 1;
        dataIn = 0;

        repeat(4) begin
        
            #10
            clk = 1;
            #10
            clk = 0;

        end

        reset = 0;
        $info("[!] Testing LUI/AUIPC");

        j = 0;
        while (address != 32'h24) begin // End of LUI / AUIPC
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin
            
                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (cpu.registers.registers[1] != 32'hFFFFF000) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 1, 32'hFFFFF000, cpu.registers.registers[1]);
        if (cpu.registers.registers[2] != 32'hFFFFF018) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 2, 32'hFFFFF018, cpu.registers.registers[2]);

        for (i = 0; i < memorySize; i=i+1) begin
        
            memory[i] = 32'b0;

        end

        // Test Jmps
        $readmemh("test/jaljalr.mem", memory);

        // Reset
        reset = 1;
        dataIn = 0;

        repeat(4) begin
        
            #10
            clk = 1;
            #10
            clk = 0;

        end

        reset = 0;

        $info("[!] Testing JAL/JALR");

        j = 0;
        while (address != 32'h1c) begin // End of JAL/JALR
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin
            
                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (cpu.registers.registers[1] != 32'h18) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 1, 32'h18, cpu.registers.registers[1]);
        if (cpu.registers.registers[2] != 32'h30) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 2, 32'h30, cpu.registers.registers[2]);


        for (i = 0; i < memorySize; i=i+1) begin
        
           memory[i] = 32'b0;

        end

        // Test Jmps
        $readmemh("test/loadstore.mem", memory);

        // Reset
        reset = 1;
        dataIn = 0;

        repeat(4) begin
        
            #10
            clk = 1;
            #10
            clk = 0;

        end

        reset = 0;
        $info("[!] Testing LOAD");

        j = 0;
        while (address != 32'h2c) begin // End of LOAD
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin
            
                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (cpu.registers.registers[8] != 32'h000000DE) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 8, 32'h000000DE, cpu.registers.registers[8]);
        if (cpu.registers.registers[9] != 32'h000000AD) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 9, 32'h000000AD, cpu.registers.registers[9]);
        if (cpu.registers.registers[10] != 32'h000000BE) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 10, 32'h000000BE, cpu.registers.registers[10]);
        if (cpu.registers.registers[11] != 32'h000000EF) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 11, 32'h000000EF, cpu.registers.registers[11]);
        if (cpu.registers.registers[12] != 32'h0000DEAD) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 12, 32'h0000DEAD, cpu.registers.registers[12]);
        if (cpu.registers.registers[13] != 32'h0000ADBE) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 13, 32'h0000ADBE, cpu.registers.registers[13]);
        if (cpu.registers.registers[14] != 32'h0000BEEF) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 14, 32'h0000BEEF, cpu.registers.registers[14]);
        if (cpu.registers.registers[15] != 32'hDEADBEEF) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 15, 32'hDEADBEEF, cpu.registers.registers[15]);

        $info("[!] Testing LOAD Sign Extended");

        j = 0;
        while (address != 32'h54) begin// End of LOAD Sign Extended
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin
            
                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (cpu.registers.registers[9] != 32'hFFFFFF84) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]",  9, 32'hFFFFFF84, cpu.registers.registers[9]);
        if (cpu.registers.registers[10] != 32'hFFFFFF83) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 10, 32'hFFFFFF83, cpu.registers.registers[10]);
        if (cpu.registers.registers[11] != 32'hFFFFFF82) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 11, 32'hFFFFFF82, cpu.registers.registers[11]);
        if (cpu.registers.registers[12] != 32'hFFFFFF81) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 12, 32'hFFFFFF81, cpu.registers.registers[12]);
        if (cpu.registers.registers[13] != 32'hFFFF8483) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 13, 32'hFFFF8483, cpu.registers.registers[13]);
        if (cpu.registers.registers[14] != 32'hFFFF8382) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 14, 32'hFFFF8382, cpu.registers.registers[14]);
        if (cpu.registers.registers[15] != 32'hFFFF8281) $error("[-] Expected [X%02d] to be [%08x] but got [%08x]", 15, 32'hFFFF8281, cpu.registers.registers[15]);

        $info("[!] Testing Aligned Store");

        j = 0;
        while (address != 32'h74) begin // End of Aligned Store
        
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin
            
                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (memory[32'h10000 >> 2] != 32'h81) $error("[-] Expected Memory [0x%08x] to be [%08x] but got [%08x]", 32'h10000, 32'h81, memory[32'h10000 >> 2]);
        if (memory[32'h10004 >> 2] != 32'h8281) $error("[-] Expected Memory [0x%08x] to be [%08x] but got [%08x]", 32'h10004, 32'h8281, memory[32'h10004 >> 2]);
        if (memory[32'h10008 >> 2] != 32'h84838281) $error("[-] Expected Memory [0x%08x] to be [%08x] but got [%08x]", 32'h10008, 32'h84838281, memory[32'h10008 >> 2]);

        $info("[!] Testing Unaligned Store");

        j = 0;
        while (address != 32'hb8) begin // End of Unaligned Store
            
            #10
            clk = 1;
            #10
            clk = 0;

            j = j + 1;
            if (j > timeoutClocks) begin
            
                $error("[-] Timeout processing tests");
                $finish;

            end

        end

        $info("[!] Took [%d] clocks", j);

        if (memory[32'h10000 >> 2] != 32'h00000081) $error("[-] Expected Memory [0x%08x] to be [%08x] but got [%08x]",  32'h10000, 32'h00000081, memory[32'h10000 >> 2]);
        if (memory[32'h10004 >> 2] != 32'h00008100) $error("[-] Expected Memory [0x%08x] to be [%08x] but got [%08x]",  32'h10004, 32'h00008100, memory[32'h10004 >> 2]);
        if (memory[32'h10008 >> 2] != 32'h00810000) $error("[-] Expected Memory [0x%08x] to be [%08x] but got [%08x]",  32'h10008, 32'h00810000, memory[32'h10008 >> 2]);
        if (memory[32'h1000C >> 2] != 32'h81000000) $error("[-] Expected Memory [0x%08x] to be [%08x] but got [%08x]",  32'h1000C, 32'h81000000, memory[32'h1000C >> 2]);
        if (memory[32'h10010 >> 2] != 32'h00008281) $error("[-] Expected Memory [0x%08x] to be [%08x] but got [%08x]",  32'h10000, 32'h00008281, memory[32'h1000F >> 2]);
        if (memory[32'h10014 >> 2] != 32'h00828100) $error("[-] Expected Memory [0x%08x] to be [%08x] but got [%08x]",  32'h10004, 32'h00828100, memory[32'h10010 >> 2]);
        if (memory[32'h10018 >> 2] != 32'h82810000) $error("[-] Expected Memory [0x%08x] to be [%08x] but got [%08x]",  32'h10008, 32'h82810000, memory[32'h10014 >> 2]);

        #100

        $finish;

    end

endmodule