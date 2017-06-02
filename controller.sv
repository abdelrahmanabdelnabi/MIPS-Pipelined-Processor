module controller(input logic clk, reset,
	input logic [5:0] opD, functD,
	input logic flushE, equalD,
	
	output logic memtoregE, memtoregM,
	output logic memtoregW, memwriteM,
	output logic pcsrcD, branchD, bneD, alusrcE,
	output logic regdstE,regwriteE, regwriteM, regwriteW, jumpD,
        output logic [2:0] alucontrolE);

logic [1:0] aluopD;
logic memtoregD, memwriteD, alusrcD,
regdstD, regwriteD;
logic [2:0] alucontrolD;
logic memwriteE;

maindec md(opD, memtoregD, memwriteD, branchD, bneD,
	alusrcD, regdstD, regwriteD, jumpD,
	aluopD);

aludec ad(functD, aluopD, alucontrolD);

assign pcsrcD = (branchD & equalD) | (bneD & ~equalD);

// pipeline registers
floprc #(8) regE(clk, reset, flushE,
{memtoregD, memwriteD, alusrcD, regdstD, regwriteD, alucontrolD},
{memtoregE, memwriteE, alusrcE, regdstE, regwriteE, alucontrolE}
);

flopr #(3) regM(clk, reset,
{memtoregE, memwriteE, regwriteE},
{memtoregM, memwriteM, regwriteM}
);

flopr #(2) regW(clk, reset,
{memtoregM, regwriteM},
{memtoregW, regwriteW}
);

endmodule
