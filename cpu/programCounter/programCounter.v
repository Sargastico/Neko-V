module programCounter (

  input   wire          clk,
  input   wire          reset,
  input         [31:0]  dataIn,
  output  wire  [31:0]  dataOut,
  input                 writeEnable,    // 1 => WRITE, 0 => READ
  input                 writeAdd,       // 1 => Add dataIn to PC, 0 => Set dataIn to PC
  input                 countEnable     // 1 => COUNT UP, 0 => STOPPED

);

    reg [31:0] programCounter;

    always @(posedge clk) begin

        if (reset) begin
            programCounter <= 0;
        end

        else if (writeEnable) begin

            programCounter <= writeAdd ? programCounter + $signed(dataIn) - 4 : dataIn;

        end
        
        else if (countEnable) begin
            
            programCounter <= programCounter + 4;

        end

    end

    assign dataOut = programCounter;

endmodule
