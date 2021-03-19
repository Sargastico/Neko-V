`include "programCounter.v"
`include "registersBank.v"
`include "instructionDecoder.v"
`include "alu.v"

module CPU (

    input   wire          clk,
    input   wire          reset,

    // BUS
    input         [31:0]  dataIn,
    output  wire  [31:0]  dataOut,
    output  wire  [31:0]  address,
    output                busWriteEnable     // 1 => WRITE, 0 => READ
    
);

// Program Counter
wire  [31:0]   pcDataOut;
wire  [31:0]   pcDataIn;
wire           pcWriteEnable;
wire           pcWriteAdd;
wire           pcCountEnable;

programCounter PC(.clk(clk), .reset(reset), .dataIn(pcDataIn), .dataOut(pcDataOut), .write(pcWriteEnable), .writeAdd(pcWriteAdd), .count(pcCountEnable));

// Register Bank
wire  [31:0]  regIn;
wire  [31:0]  regOut;
wire  [3:0]   regNum;
wire          regWriteEnable;

registerBank registers(.clk(clk), .reset(reset), .dataIn(regIn), .dataOut(regOut), .select(regNum), .write(regWriteEnable));

// ALU
wire  [3:0]   aluOp;
wire  [31:0]  aluX;
wire  [31:0]  aluY;
wire  [31:0]  aluO;

ALU alu(.operation(aluOp), .A(aluX), .B(aluY), .Out(aluO));

// Instruction Decoder
InstructionDecoder decoder(

    // Global Control
    .clk(clk),
    .reset(reset),

    // BUS
    .dataIn(dataIn),
    .dataOut(dataOut),
    .address(address),
    .busWriteEnable(busWriteEnable),

    // PC Control
    .pcDataOut(pcDataOut),
    .pcWriteEnable(pcWriteEnable),
    .pcWriteAdd(pcWriteAdd),
    .pcCountEnable(pcCountEnable),
    .pcDataIn(pcDataIn),

    // Register Bank Control
    .regIn(regIn),
    .regOut(regOut),
    .regNum(regNum),
    .regWriteEnable(regWriteEnable),

    // ALU Control
    .aluO(aluO),
    .aluOp(aluOp),
    .aluX(aluX),
    .aluY(aluY)
);

endmodule