module maindec(input logic [5:0] op,
	output logic memtoreg, memwrite,
	output logic branch, bne, alusrc,
	output logic regdst, regwrite,
	output logic jump,
	output logic [1:0] aluop);

logic [10:0] controls;

assign {regwrite, regdst, alusrc, branch, bne,
memwrite, memtoreg, jump, aluop} = controls;

always_comb
case(op)			
	6'b000000: controls <= 10'b1100_0000_10; //Rtype
	6'b100011: controls <= 10'b1010_0010_00; //LW
	6'b101011: controls <= 10'b0010_0100_00; //SW
	6'b000100: controls <= 10'b0001_0000_01; //BEQ
	6'b000101: controls <= 10'b0000_1000_01; //BNE
	6'b001000: controls <= 10'b1010_0000_00; //ADDI
	6'b000010: controls <= 10'b0000_0001_00; //J
	default: controls <= 10'bxxxxxxxxxx; //???
endcase
endmodule
