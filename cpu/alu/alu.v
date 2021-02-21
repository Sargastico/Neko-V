/*

ALU insctruction - "Guia Prático RISC-V", Pg. 43

imm[11:0]  |         |  rs1 000 rd 0010011 |  I addi  |  Add Immediate.                    |  I-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] + seAt(immediate)
imm[11:0]  |         |  rs1 010 rd 0010011 |  I slti  |  Set if Less Than Immediate.       |  I-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] < s seAt(immediate)
imm[11:0]  |         |  rs1 011 rd 0010011 |  I sltiu |  Set if Less Than Immediate.       |  Unsign, RV32I and RV64I.   |  A[rd] = A[rs1] < u seAt(immediate)
imm[11:0]  |         |  rs1 100 rd 0010011 |  I Aori  |  EAclusive-OR Immediate.           |  I-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] ^ seAt(immediate)
imm[11:0]  |         |  rs1 110 rd 0010011 |  I ori   |  OR Immediate.                     |  I-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] | seAt(immediate)
imm[11:0]  |         |  rs1 111 rd 0010011 |  I andi  |  AND Immediate.                    |  I-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] & seAt(immediate)
0000000    |  shamt  |  rs1 001 rd 0010011 |  I slli  |  Shift Left Logical Immediate.     |  I-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] << shamt 
0000000    |  shamt  |  rs1 101 rd 0010011 |  I srli  |  Shift Right Logical Immediate.    |  I-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] >> u shamt
0100000    |  shamt  |  rs1 101 rd 0010011 |  I srai  |  Shift Right Arithmetic Immediate. |  I-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] >> s shamt
0000000    |   rs2   |  rs1 000 rd 0110011 |  R add   |  Add.                              |  R-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] + A[rs2]
0100000    |   rs2   |  rs1 000 rd 0110011 |  R sub   |  Subtract.                         |  R-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] - A[rs2]
0000000    |   rs2   |  rs1 001 rd 0110011 |  R sll   |  Shift Left Logical.               |  R-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] << A[rs2] 
0000000    |   rs2   |  rs1 010 rd 0110011 |  R slt   |  Set if Less Than.                 |  R-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] < s A[rs2] 
0000000    |   rs2   |  rs1 011 rd 0110011 |  R sltu  |  Set if Less Than, Unsigned.       |  R-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] < u A[rs2]
0000000    |   rs2   |  rs1 100 rd 0110011 |  R Aor   |  EAclusive-OR.                     |  R-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] ^ A[rs2] 
0000000    |   rs2   |  rs1 101 rd 0110011 |  R srl   |  Shift Right Logical.              |  R-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] >> u A[rs2]
0100000    |   rs2   |  rs1 101 rd 0110011 |  R sra   |  Shift Right Arithmetic.           |  R-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] >> s A[rs2] 
0000000    |   rs2   |  rs1 110 rd 0110011 |  R or    |  OR.                               |  R-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] | A[rs2] 
0000000    |   rs2   |  rs1 111 rd 0110011 |  R and   |  AND.                              |  R-tBpe, RV32I and RV64I.   |  A[rd] = A[rs1] & A[rs2] 

*/

module ALU (

  input     [3:0]   operation,
  input     [31:0]  A,
  input     [31:0]  B,
  output    [31:0]  Out

);

// ALU Operations
    parameter ADD = 4'h0;
    parameter SUB = 4'h1;
    parameter OR = 4'h2;
    parameter XOR = 4'h3;
    parameter AND = 4'h4;
    parameter LesserThanUnsigned = 4'h5;
    parameter LesserThanSigned = 4'h6;
    parameter ShiftRightUnsigned = 4'h7;
    parameter ShiftRightSigned = 4'h8;
    parameter ShiftLeftUnsigned = 4'h9;
    parameter ShiftLeftSigned = 4'hA;
    parameter GreaterThanOrEqualUnsigned = 4'hB;
    parameter GreaterThanOrEqualSigned = 4'hC;
    parameter Equal = 4'hD;
    parameter NotEqual = 4'hE;

    reg [31:0] result;

    integer i;

    always @(*) begin

        case (operation)

            ADD:  
                result = A + B;

            SUB: 
                result = A - B;

            OR: 
                result = A | B;

            XOR:
                result = A ^ B;

            AND:
                result = A & B;

            LesserThanUnsigned: 
                result = A < B;

            LesserThanSigned:
                result = $signed(A) < $signed(B);

            ShiftRightUnsigned:
                result = A >> (B % 32);
                                                        
            ShiftRightSigned:
                result = $signed(A) >>> (B % 32);         
            
            ShiftLeftUnsigned:          
                result = A << (B % 32);                             
            
            ShiftLeftSigned:
                result = $signed(A) <<< (B % 32);          
            
            GreaterThanOrEqualUnsigned:
                result = A >= B;

            GreaterThanOrEqualSigned:
                result = $signed(A) >= $signed(B);
            
            Equal:  
                result = A == B;

            NotEqual:                   
                result = A != B;

            default:       
                result = 0;

        endcase
    
    end

    assign O = result;

endmodule