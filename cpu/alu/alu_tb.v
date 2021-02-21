`timescale 1 ns/1 ns 
`include "alu.v"

module ALUTest;

    localparam numIterations = 32;  
    integer i;

    reg   [3:0]   operation;
    reg   [31:0]  A;
    reg   [31:0]  B;
    wire  [31:0]  Out;

    ALU alu(.operation(operation), .A(A), .B(B), .Out(Out));

    initial begin
        
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, ALUTest);
        $display("[!] Testing ALU");


        operation = 0;
        A = 0;
        B = 0;

        // Test operation ADD
        operation = alu.ADD;

        for (i = 0; i < numIterations; i++) begin

            A = $random;
            B = $random;

            #10

            if (Out != (A + B)) begin
                
                $error("Expected o to be %d but got %d.", A + B, Out);

            end 

        end

        // Test operation SUB
        operation = alu.SUB;

        for (i = 0; i < numIterations; i++) begin

            A = $random;
            B = $random;

            #10

            if (Out != (A - B)) begin
                
                $error("Expected o to be %d but got %d.", A - B, Out);

            end   

        end

        // Test operation OR
        operation = alu.OR;

        for (i = 0; i < numIterations; i++) begin

            A = $random;
            B = $random;

            #10

            if (Out != (A | B)) begin

                $error("Expected o to be %d but got %d.", A | B, Out);
                
            end

        end

        // Test operation XOR
        operation = alu.XOR;

        for (i = 0; i < numIterations; i++) begin

            A = $random;
            B = $random;

            #10

            if (Out != (A ^ B)) begin

                $error("Expected o to be %d but got %d.", A ^ B, Out);

            end

        end

        // Test operation AND
        operation = alu.AND;

        for (i = 0; i < numIterations; i++) begin

            A = $random;
            B = $random;

            #10

            if (Out != (A & B)) begin
                
                $error("Expected o to be %d but got %d.", A & B, Out);

            end

        end

        // Test operation LesserThanUnsigned
        operation = alu.LesserThanUnsigned;

        for (i = 0; i < numIterations; i++) begin

            A = $random;
            B = $random;

            #10

            if (Out != (A < B)) begin
            
                $error("Expected o to be %d but got %d.", A < B, Out);

            end   

        end

        // Test operation LesserThanSigned
        operation = alu.LesserThanSigned;

        for (i = 0; i < numIterations; i++) begin

            A = $random;
            B = $random;
            
            #10

            if (Out != ($signed(A) < $signed(B))) begin
            
                $error("Expected o to be %d but got %d.", $signed(A) < $signed(B), Out);

            end

        end

        // Test operation ShiftRightUnsigned
        operation = alu.ShiftRightUnsigned;

        for (i = 0; i < numIterations; i++) begin

            A = $random;
            B = $random;

            #10

            if (Out != (A >> (B % 32))) begin

                $error("Expected o to be %d but got %d.", A >> (B % 32), Out); 

            end   


        end

        // Test operation ShiftLeftUnsigned
        operation = alu.ShiftLeftUnsigned;

        for (i = 0; i < numIterations; i++) begin

            A = $random;
            B = $random;

            #10

            if (Out != (A << (B % 32))) begin
            
                $error("Expected o to be %d but got %d.", A << (B % 32), Out);

            end

        end

        // Test operation ShiftRightSigned
        operation = alu.ShiftRightSigned;

        for (i = 0; i < numIterations; i++) begin

            A = $random;
            B = $random;
            
            #10

            if (Out != $unsigned($signed(A) >>> (B % 32))) begin

                $error("Expected o to be %d but got %d.", $signed(A) >>> (B % 32), Out);

            end

        end

        // Test operation ShiftLeftSigned
        operation = alu.ShiftLeftSigned;

        for (i = 0; i < numIterations; i++) begin

            A = $random;
            B = $random;

            #10

            if (Out != $unsigned($signed(A) <<< (B % 32))) begin
                
                $error("Expected o to be %d but got %d.", $signed(A) <<< (B % 32), Out);

            end 

        end

        // Test operation GreaterThanOrEqualUnsigned
        operation = alu.GreaterThanOrEqualUnsigned;

        for (i = 0; i < numIterations; i++) begin

            A = $random;
            B = $random;

            #10

            if (Out != (A >= B)) begin
                
                $error("Expected o to be %d but got %d.", A >= B, Out);

            end 

        end

        // Test operation GreaterThanOrEqualUnsigned
        operation = alu.GreaterThanOrEqualSigned;

        for (i = 0; i < numIterations; i++) begin

            A = $random;
            B = $random;

            #10

            if (Out != ($signed(A) >= $signed(B))) begin
                
                $error("Expected o to be %d but got %d.", $signed(A) >= $signed(B), Out);

            end 

        end

        // Test operation Equal
        operation = alu.Equal;

        for (i = 0; i < numIterations; i++) begin

            A = $random;
            B = $random;

            #10

            if (Out != (A == B)) begin
                
                $error("Expected o to be %d but got %d.", (A == B), Out);

            end

        end

        // Test operation NotEqual
        operation = alu.NotEqual;

        for (i = 0; i < numIterations; i++) begin

            A = $random;
            B = $random;

            #10

            if (Out != (A != B)) begin
                
                $error("Expected o to be %d but got %d.", (A != B), Out);

            end 

        end


        #100

        $finish;

    end

endmodule
