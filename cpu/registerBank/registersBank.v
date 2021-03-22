/*

|Register Name | Symbolic Name| Description                          | Saved By |
| x0 	       | Zero 	      | Always zero 	                     |          |
| x1 	       | ra 	      | Return address 	                     |  Caller  |
| x2 	       | sp 	      | Stack pointer 	                     |  Callee  |
| x3 	       | gp 	      | Global pointer 	                     |    -     |
| x4 	       | tp 	      | Thread pointer 	                     |    -     |
| x5 	       | t0 	      | Temporary / alternate return address |  Caller  |
| x6–7         | t1–2 	      | Temporary 	                         |  Caller  |
| x8 	       | s0/fp 	      | Saved register / frame pointer 	     |  Callee  |
| x9 	       | s1 	      | Saved register 	                     |  Callee  |
| x10–11       | a0–1 	      | Function argument / return value 	 |  Caller  |

/*

The "zero register" or 'x0', cannot be modified and always stores the constant zero.
Before assign any value coming from dataIn, the 'if statement' (Line 46) checks if the register 'x0' has not been selected.

sauce: https://en.wikichip.org/wiki/risc-v/registers

*/


module registerBank (

    input  wire  clk,
    input  wire  reset, 
    output wire  [31:0]dataOut,  // 32-bit register
    input        [31:0]dataIn,   
    input        [3:0]select,    // Select 1 of 16 Registers
    input        write           // 0 = Disable | 1 = Enable

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

    if ((write == 1) && (select != 0)) begin

        registers[select] <= dataIn;

    end
    
end

assign dataOut = registers[select];

endmodule
