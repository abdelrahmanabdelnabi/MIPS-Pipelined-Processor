
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
regwriteM, regwriteW, jumpD,
alucontrolE
);

datapath dp(clk, reset, memtoregE, memtoregM, memtoregW, pcsrcD, branchD, bneD,
alusrcE, regdstE, regwriteE, regwriteM, regwriteW, jumpD, alucontrolE, equalD, pcF, instrF,
aluoutM, writedataM, readdataM, opD, functD, flushE
);
endmodule

module controller(input logic clk, reset,
	input logic [5:0] opD, functD,
	input logic flushE, equalD,
	output logic memtoregE, memtoregM,
output logic memtoregW, memwriteM,
output logic pcsrcD, branchD, alusrcE,
output logic regdstE, regwriteE,
output logic regwriteM, regwriteW,
output logic jumpD,
output logic [2:0] alucontrolE);

logic [1:0] aluopD;
logic memtoregD, memwriteD, alusrcD,
regdstD, regwriteD;
logic [2:0] alucontrolD;
logic memwriteE;

maindec md(opD, memtoregD, memwriteD, branchD, alusrcD, regdstD, regwriteD, jumpD, aluopD);

aludec ad(functD, aluopD, alucontrolD);

assign pcsrcD = branchD & equalD;

// pipeline registers
floprc #(8) regE(clk, reset, flushE,
{memtoregD, memwriteD, alusrcD, regdstD, regwriteD, alucontrolD},
{memtoregE, memwriteE, alusrcE, regdstE, regwriteE, alucontrolE});

flopr #(3) regM(clk, reset,
{memtoregE, memwriteE, regwriteE},
{memtoregM, memwriteM, regwriteM});

flopr #(2) regW(clk, reset,
{memtoregM, regwriteM},
{memtoregW, regwriteW});
endmodule
