module controller(input logic clk, reset,
	input logic [5:0] opD, functD,
	input logic flushE, equalD,
	
	output logic memtoregE, memtoregM,
	output logic memtoregW, memwriteM,
	output logic pcsrcD, branchD, bneD, alusrcE,
	output logic regdstE,regwriteE, regwriteM, regwriteW, jumpD, lbW,
        output logic [3:0] alucontrolE);

logic [1:0] aluopD;
logic memtoregD, memwriteD, alusrcD,
regdstD, regwriteD;
logic [3:0] alucontrolD;
logic memwriteE;
logic lbD, lbE, lbM;

maindec md(opD, memtoregD, memwriteD, branchD, bneD,
	alusrcD, regdstD, regwriteD, jumpD, lbD,
	aluopD);

aludec ad(functD, aluopD, alucontrolD);

assign pcsrcD = (branchD & equalD) | (bneD & ~equalD);

// pipeline registers
floprc #(10) regE(clk, reset, flushE,
{memtoregD, memwriteD, alusrcD, regdstD, regwriteD, alucontrolD, lbD},
{memtoregE, memwriteE, alusrcE, regdstE, regwriteE, alucontrolE, lbE}
);

flopr #(4) regM(clk, reset,
{memtoregE, memwriteE, regwriteE, lbE},
{memtoregM, memwriteM, regwriteM, lbM}
);

flopr #(3) regW(clk, reset,
{memtoregM, regwriteM, lbM},
{memtoregW, regwriteW, lbW}
);

endmodule
