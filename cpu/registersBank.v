module registerBank (

    input   clk,
    input   reset, 
    input   [31:0]dataIn,   // 32-bit register
    output  [31:0]dataOut,  
    input   [16:0]select,   // Select 1 of 16 Registers
    input   write           // 0 = Disable | 1 = Enable 

);

integer i;
reg [31:0] registers [0:15]; //16 registers of 32 bits

initial begin 


    for (i = 0; i < 16; i++) begin
        
        registers[i] <= 0;
    
    end

end 

always @(posedge clk ) begin

    if (reset) begin
        
        for (i = 0; i < 16; i++) begin
        
            registers[i] <= 0;

        end

    end

    /*

    The "zero register" or 'x0', cannot be modified and always stores the constant zero.
    Before assign any value coming from dataIn, the 'if statement' checks if the register 'x0' has not been selected.

    sauce: https://en.wikichip.org/wiki/risc-v/registers

    */
    else if (write && (select != 0))

        registerBank[select] <= dataIn;
    
end

assign dataOut = registers[select];


endmodule