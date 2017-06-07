module maindec(input logic [5:0] op,
	output logic memtoreg, memwrite,
	output logic branch, bne, alusrc,
	output logic [1:0] regdst,
	output logic regwrite,
	output logic jump, jal, lb,
	output logic [1:0] aluop);

logic [12:0] controls;

assign {regwrite, regdst, alusrc, branch, bne,
memwrite, memtoreg, jump, jal, lb, aluop} = controls;

always_comb
case(op)			
	6'b000000: controls <= 13'b101_0000_0000_10; //Rtype
	6'b100011: controls <= 13'b100_1000_1000_00; //LW
	6'b101011: controls <= 13'b000_1001_0000_00; //SW
	6'b000100: controls <= 13'b000_0100_0000_01; //BEQ
	6'b000101: controls <= 13'b000_0010_0000_01; //BNE
	6'b001000: controls <= 13'b100_1000_0000_00; //ADDI
	6'b000010: controls <= 13'b000_0000_0100_00; //J
	6'b100000: controls <= 13'b100_1000_1001_00; //LB
	default: controls <= 13'bxxxxxxxxxxxxx; //???
endcase
endmodule
