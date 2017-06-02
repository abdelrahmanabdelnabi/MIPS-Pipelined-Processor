
// pipelined MIPS processor
module mips(input logic clk, reset,
	output logic [31:0] pcF,
	input logic [31:0] instrF,
	output logic memwriteM,
	output logic [31:0] aluoutM, writedataM,
	input logic [31:0] readdataM);
logic [5:0] opD, functD;
logic regdstE, alusrcE, pcsrcD, memtoregE, memtoregM, memtoregW, regwriteE, regwriteM, regwriteW;
logic [2:0] alucontrolE;
logic flushE, equalD;

controller c(clk, reset, opD, functD, flushE,
equalD,memtoregE, memtoregM,
memtoregW, memwriteM, pcsrcD,
branchD, bneD, alusrcE, regdstE, regwriteE,
regwriteM, regwriteW, jumpD, lbW,
alucontrolE
);

datapath dp(clk, reset, memtoregE, memtoregM, memtoregW, pcsrcD, branchD, bneD,
alusrcE, regdstE, regwriteE, regwriteM, regwriteW, jumpD, lbW, alucontrolE, equalD, pcF, instrF,
aluoutM, writedataM, readdataM, opD, functD, flushE
);
endmodule

