//------------------------------------------------
// topmulti.sv
// David_Harris@hmc.edu 9 November 2005
// Update to SystemVerilog 17 Nov 2010 DMH
// Top level system including multicycle MIPS 
// and unified memory
//------------------------------------------------

module top(input logic clk, reset,
	output logic [31:0] writedata, dataadr,
	output logic memwrite);

logic [31:0] pc, instr, readdata;
logic sb;

// instantiate processor and memories
mips mips(clk, reset, pc, instr, memwrite, sb, dataadr, writedata, readdata);

imem imem(pc[7:2], instr);

dmem dmem(clk, memwrite, sb, dataadr, writedata, readdata);
endmodule
