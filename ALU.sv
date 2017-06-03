module alu(input logic [31:0] A, B,
	input logic [3:0] F, // SRLV, XORI
	input logic [4:0] shamt, // SLL, SRL
	output logic [31:0] Y, output Zero);

logic [31:0] S, Bout;
assign Bout = F[3] ? ~B : B;
assign S = A + Bout + F[3];
always_comb
case (F[2:0])
	3'b000: Y <= A & Bout;
	3'b001: Y <= A | Bout;
	3'b010: Y <= S;
	3'b011: Y <= S[31];
	3'b100: Y <= S << shamt;
	3'b101: Y <= S >> shamt;
endcase
assign Zero = (Y == 32'b0);
endmodule