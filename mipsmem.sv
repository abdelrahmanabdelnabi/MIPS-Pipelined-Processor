module imem(input logic [5:0] a,
	output logic [31:0] rd);
	logic [31:0] RAM[63:0];
initial
begin
	$readmemh("memfile.dat",RAM);
end

assign rd = RAM[a]; // word aligned
endmodule

module dmem(input logic clk, we,
	input logic [31:0] a, wd,
	output logic [31:0] rd);

reg [31:0] RAM[63:0];
initial
begin
	$readmemh("memfile.dat",RAM);
end

assign rd = RAM[a[31:2]]; // word aligned
always @(posedge clk)
if (we)
RAM[a[31:2]] <= wd;
endmodule
