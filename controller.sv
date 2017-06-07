module controller(input logic clk, reset,
	input logic [5:0] opD, functD,
	input logic flushE, equalD,
	
	output logic memtoregE, memtoregM,
	output logic memtoregW, memwriteM,
	output logic pcsrcD, branchD, bneD, alusrcE,
	output logic [1:0] regdstE,
	output logic regwriteE, regwriteM, regwriteW, jumpD, jalW, lbW,
	output logic multordivE, hlwriteE, hlwriteM, hlwriteW,
        output logic [3:0] alucontrolE);

logic [1:0] aluopD;
logic memtoregD, memwriteD, alusrcD;
logic [1:0] regdstD;
logic regwriteD;
logic [3:0] alucontrolD;
logic memwriteE;
logic lbD, lbE, lbM;
logic jalD, jalE, jalM;
logic multordivD, hlwriteD;

maindec md(opD, memtoregD, memwriteD, branchD, bneD,
	alusrcD, regdstD, regwriteD, jumpD, jalD, lbD,
	multordivD, hlwriteD, aluopD);

aludec ad(functD, aluopD, alucontrolD);

assign pcsrcD = (branchD & equalD) | (bneD & ~equalD);

// pipeline registers
floprc #(14) regE(clk, reset, flushE,
{memtoregD, memwriteD, alusrcD, regdstD, regwriteD, alucontrolD, jalD, lbD, multordivD, hlwriteD},
{memtoregE, memwriteE, alusrcE, regdstE, regwriteE, alucontrolE, jalE, lbE, multordivE, hlwriteE}
);

flopr #(6) regM(clk, reset,
{memtoregE, memwriteE, regwriteE, jalE, lbE, hlwriteE},
{memtoregM, memwriteM, regwriteM, jalM, lbM, hlwriteM}
);

flopr #(5) regW(clk, reset,
{memtoregM, regwriteM, jalM, lbM, hlwriteM},
{memtoregW, regwriteW, jalW, lbW, hlwriteW}
);

endmodule
