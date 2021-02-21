/*

ALU insctruction - "Guia Prático RISC-V", Pg. 43

imm[11:0]  |         |  rs1 000 rd 0010011 |  I addi  |  Add Immediate.                    |  I-type, RV32I and RV64I.   |  x[rd] = x[rs1] + sext(immediate)
imm[11:0]  |         |  rs1 010 rd 0010011 |  I slti  |  Set if Less Than Immediate.       |  I-type, RV32I and RV64I.   |  x[rd] = x[rs1] < s sext(immediate)
imm[11:0]  |         |  rs1 011 rd 0010011 |  I sltiu |  Set if Less Than Immediate.       |  Unsign, RV32I and RV64I.   |  x[rd] = x[rs1] < u sext(immediate)
imm[11:0]  |         |  rs1 100 rd 0010011 |  I xori  |  Exclusive-OR Immediate.           |  I-type, RV32I and RV64I.   |  x[rd] = x[rs1] ^ sext(immediate)
imm[11:0]  |         |  rs1 110 rd 0010011 |  I ori   |  OR Immediate.                     |  I-type, RV32I and RV64I.   |  x[rd] = x[rs1] | sext(immediate)
imm[11:0]  |         |  rs1 111 rd 0010011 |  I andi  |  AND Immediate.                    |  I-type, RV32I and RV64I.   |  x[rd] = x[rs1] & sext(immediate)
0000000    |  shamt  |  rs1 001 rd 0010011 |  I slli  |  Shift Left Logical Immediate.     |  I-type, RV32I and RV64I.   |  x[rd] = x[rs1] << shamt 
0000000    |  shamt  |  rs1 101 rd 0010011 |  I srli  |  Shift Right Logical Immediate.    |  I-type, RV32I and RV64I.   |  x[rd] = x[rs1] >> u shamt
0100000    |  shamt  |  rs1 101 rd 0010011 |  I srai  |  Shift Right Arithmetic Immediate. |  I-type, RV32I and RV64I.   |  x[rd] = x[rs1] >> s shamt
0000000    |   rs2   |  rs1 000 rd 0110011 |  R add   |  Add.                              |  R-type, RV32I and RV64I.   |  x[rd] = x[rs1] + x[rs2]
0100000    |   rs2   |  rs1 000 rd 0110011 |  R sub   |  Subtract.                         |  R-type, RV32I and RV64I.   |  x[rd] = x[rs1] - x[rs2]
0000000    |   rs2   |  rs1 001 rd 0110011 |  R sll   |  Shift Left Logical.               |  R-type, RV32I and RV64I.   |  x[rd] = x[rs1] << x[rs2] 
0000000    |   rs2   |  rs1 010 rd 0110011 |  R slt   |  Set if Less Than.                 |  R-type, RV32I and RV64I.   |  x[rd] = x[rs1] < s x[rs2] 
0000000    |   rs2   |  rs1 011 rd 0110011 |  R sltu  |  Set if Less Than, Unsigned.       |  R-type, RV32I and RV64I.   |  x[rd] = x[rs1] < u x[rs2]
0000000    |   rs2   |  rs1 100 rd 0110011 |  R xor   |  Exclusive-OR.                     |  R-type, RV32I and RV64I.   |  x[rd] = x[rs1] ^ x[rs2] 
0000000    |   rs2   |  rs1 101 rd 0110011 |  R srl   |  Shift Right Logical.              |  R-type, RV32I and RV64I.   |  x[rd] = x[rs1] >> u x[rs2]
0100000    |   rs2   |  rs1 101 rd 0110011 |  R sra   |  Shift Right Arithmetic.           |  R-type, RV32I and RV64I.   |  x[rd] = x[rs1] >> s x[rs2] 
0000000    |   rs2   |  rs1 110 rd 0110011 |  R or    |  OR.                               |  R-type, RV32I and RV64I.   |  x[rd] = x[rs1] | x[rs2] 
0000000    |   rs2   |  rs1 111 rd 0110011 |  R and   |  AND.                              |  R-type, RV32I and RV64I.   |  x[rd] = x[rs1] & x[rs2] 

*/