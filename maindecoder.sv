module maindec(input logic [5:0] op,
	output logic memtoreg, memwrite,
	output logic branch, bne, alusrc,
	output logic [1:0] regdst,
	output logic regwrite,
	output logic jump, jal, lb,
	output logic multordiv, hlwrite,
	output logic [1:0] aluop);

logic [14:0] controls;

assign {regwrite, regdst, alusrc, branch, bne,
	memwrite, memtoreg, jump, jal, lb,
	multordiv, hlrwite, aluop} = controls;

always_comb
case(op)			
	6'b000000: controls <= 15'b1_0100_0000_0000_10; //Rtype
	6'b100011: controls <= 15'b1_0010_0010_0000_00; //LW
	6'b101011: controls <= 15'b0_0010_0100_0000_00; //SW
	6'b000100: controls <= 15'b0_0001_0000_0000_01; //BEQ
	6'b000101: controls <= 15'b0_0000_1000_0000_01; //BNE
	6'b001000: controls <= 15'b1_0010_0000_0000_00; //ADDI
	6'b000010: controls <= 15'b0_0000_0001_0000_00; //J
	6'b100000: controls <= 15'b1_0010_0010_0100_00; //LB
	6'b000011: controls <= 15'b1_1000_0001_1000_00; //JAL
	default: controls <= 135'bxxxxxxxxxxxxxxx; //???
endcase
endmodule
