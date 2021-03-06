module controller(input logic clk, reset,
	input logic [5:0] opD, functD,
	input logic flushE, equalD,
	
	output logic memtoregE, memtoregM,
	output logic memtoregW, memwriteM,
	output logic pcsrcD, branchD, bneD, alusrcE,
	output logic [1:0] regdstE,
	output logic regwriteE, regwriteM, regwriteW, jumpD,
	output logic jalD, jalW, jrD, lbW, sbM,
	output logic multordivE, hlwriteE, hlwriteM, hlwriteW,
	output logic [1:0] mfhlW,
        output logic [3:0] alucontrolE);

logic [1:0] aluopD;
logic memtoregD, memwriteD, alusrcD;
logic [1:0] regdstD;
logic regwriteD;
logic [3:0] alucontrolD;
logic memwriteE;
logic lbD, lbE, lbM, sbD, sbE;
logic jalE, jalM;
logic multordivD, hlwriteD;
logic [1:0] mfhlD, mfhlE, mfhlM;

maindec md(opD, memtoregD, memwriteD, branchD, bneD,
	alusrcD, regdstD, regwriteD, jumpD, jalD, jrD, lbD, sbD,
	multordivD, hlwriteD, mfhlD, aluopD, functD);

aludec ad(functD, aluopD, alucontrolD);

assign pcsrcD = (branchD & equalD) | (bneD & ~equalD);

// pipeline registers
floprc #(17) regE(clk, reset, flushE,
{memtoregD, memwriteD, alusrcD, regdstD, regwriteD, alucontrolD, jalD, lbD, multordivD, hlwriteD, mfhlD, sbD},
{memtoregE, memwriteE, alusrcE, regdstE, regwriteE, alucontrolE, jalE, lbE, multordivE, hlwriteE, mfhlE, sbE}
);

flopr #(9) regM(clk, reset,
{memtoregE, memwriteE, regwriteE, jalE, lbE, hlwriteE, mfhlE, sbE},
{memtoregM, memwriteM, regwriteM, jalM, lbM, hlwriteM, mfhlM, sbM}
);

flopr #(7) regW(clk, reset,
{memtoregM, regwriteM, jalM, lbM, hlwriteM, mfhlM},
{memtoregW, regwriteW, jalW, lbW, hlwriteW, mfhlW}
);

endmodule
