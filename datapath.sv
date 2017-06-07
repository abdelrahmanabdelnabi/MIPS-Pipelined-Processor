module datapath(input logic clk, reset,
input logic memtoregE, memtoregM, memtoregW,
input logic pcsrcD, branchD, bneD,
input logic alusrcE,
input logic [1:0] regdstE,
input logic regwriteE, regwriteM, regwriteW,
input logic jumpD, jalW, lbW,
input logic multordivE, hlwriteE, hlwriteM, hlwriteW,
input logic [3:0] alucontrolE,
output logic equalD,
output logic [31:0] pcF,
input logic [31:0] instrF,
output logic [31:0] aluoutM, writedataM,
input logic [31:0] readdataM,
output logic [5:0] opD, functD,
output logic flushE);

logic forwardaD, forwardbD;
logic [1:0] forwardaE, forwardbE;
logic stallF;
logic [4:0] rsD, rtD, rdD, rsE, rtE, rdE, shamtD, shamtE;
logic [4:0] writeregE, writeregM, writeregW;
logic flushD;
logic [31:0] pcnextFD, pcnextbrFD, pcplus4F, pcbranchD;
logic [31:0] signimmD, signimmE, signimmshD;
logic [31:0] srcaD, srca2D, srcaE, srca2E;
logic [31:0] srcbD, srcb2D, srcbE, srcb2E, srcb3E;
logic [31:0] pcplus4D, pcplus4E, pcplus4M, pcplus4W, instrD;
logic [31:0] aluoutE, aluoutW;
logic [31:0] readdataW, resultW;
logic zeroE;
logic [7:0] selectedbyteW;
logic [31:0] selectedbyteextW, selectedreaddataW;
logic [31:0] aluordata;
logic [31:0] hiE, loE, hiM, loM, hiW, loW;
logic [31:0] hireg, loreg;

// hazard detection
hazard h(rsD, rtD, rsE, rtE, writeregE, writeregM,
writeregW,regwriteE, regwriteM, regwriteW,
memtoregE, memtoregM, branchD, bneD,
forwardaD, forwardbD, forwardaE,
forwardbE, stallF, stallD, flushE
);

// next PC logic (operates in fetch and decode)
mux2 #(32) pcbrmux(pcplus4F, pcbranchD, pcsrcD, pcnextbrFD);
mux2 #(32) pcmux(pcnextbrFD,{pcplus4D[31:28], instrD[25:0], 2'b00}, jumpD, pcnextFD);

// register file (operates in decode and writeback)
regfile rf(clk, regwriteW, rsD, rtD, writeregW,
resultW, srcaD, srcbD);

// lo and hi registers (operates ini decode and writeback)
hiandlo regs(clk, hlwriteW, hiW, loW, hireg, loreg);

// Fetch stage logic
flopenr #(32) pcreg(clk, reset, ~stallF, pcnextFD, pcF);
adder pcadd1(pcF, 32'b100, pcplus4F);

// Decode stage
flopenr #(32) r1D(clk, reset, ~stallD, pcplus4F, pcplus4D);
flopenrc #(32) r2D(clk, reset, ~stallD, flushD, instrF, instrD);
signext se(instrD[15:0], signimmD);
sl2 immsh(signimmD, signimmshD);
adder pcadd2(pcplus4D, signimmshD, pcbranchD);
mux2 #(32) forwardadmux(srcaD, aluoutM, forwardaD, srca2D);
mux2 #(32) forwardbdmux(srcbD, aluoutM, forwardbD, srcb2D);
eqcmp comp(srca2D, srcb2D, equalD);
assign opD = instrD[31:26];
assign functD = instrD[5:0];
assign rsD = instrD[25:21];
assign rtD = instrD[20:16];
assign rdD = instrD[15:11];
assign shamtD = instrD[10:6];
assign flushD = pcsrcD | jumpD;

// Execute stage
floprc #(32) r1E(clk, reset, flushE, srcaD, srcaE);
floprc #(32) r2E(clk, reset, flushE, srcbD, srcbE);
floprc #(32) r3E(clk, reset, flushE, signimmD, signimmE);
floprc #(32) r7E(clk, reset, flushE, pcplus4D, pcplus4E);
floprc #(5) r4E(clk, reset, flushE, rsD, rsE);
floprc #(5) r5E(clk, reset, flushE, rtD, rtE);
floprc #(5) r6E(clk, reset, flushE, rdD, rdE);
floprc #(5) shamtreg(clk, reset, flushE, shamtD, shamtE);
mux3 #(32) forwardaemux(srcaE, resultW, aluoutM, forwardaE, srca2E);
mux3 #(32) forwardbemux(srcbE, resultW, aluoutM, forwardbE, srcb2E);
mux2 #(32) srcbmux(srcb2E, signimmE, alusrcE, srcb3E);
alu alu(srca2E, srcb3E, alucontrolE, shamtE, aluoutE, zeroE);
multdivunit multiplier(srca2E, srcb2E, multordivE, hiE, loE);
mux3 #(5) wrmux(rtE, rdE, 5'b11111, regdstE, writeregE);

// Memory stage
flopr #(32) r1M(clk, reset, srcb2E, writedataM);
flopr #(32) r2M(clk, reset, aluoutE, aluoutM);
flopr #(32) r4M(clk, reset, pcplus4E, pcplus4M);
flopr #(32) r5M(clk, reset, hiE, hiM);
flopr #(32) r6M(clk, reset, loE, loM);
flopr #(5) r3M(clk, reset, writeregE, writeregM);

// Writeback stage
flopr #(32) r1W(clk, reset, aluoutM, aluoutW);
flopr #(32) r2W(clk, reset, readdataM, readdataW);
flopr #(32) r4W(clk, reset, pcplus4M, pcplus4W);
flopr #(32) r5W(clk, reset, hiM, hiW);
flopr #(32) r6W(clk, reset, loM, loW);
flopr #(5) r3W(clk, reset, writeregM, writeregW);

// load byte logic
mux4 #(8) byteselector(readdataW[7:0], readdataW[15:8], readdataW[23:16],readdataW[31:24],
aluoutW[1:0], selectedbyteW);
signext8 se2(selectedbyteW, selectedbyteextW);
mux2 #(32) datamux(readdataW, selectedbyteextW, lbW, selectedreaddataW);

mux2 #(32) resmux(aluoutW, selectedreaddataW, memtoregW, aluordata);
mux2 #(32) resorpc(aluordata, pcplus4W, jalW, resultW);
endmodule
