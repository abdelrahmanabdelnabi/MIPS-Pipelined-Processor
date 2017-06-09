module hiandlo(input logic clk, we,
		input logic [31:0] wdhi, wdlo,
		output logic [31:0] rdhi, rdlo);

logic [31:0] hi, lo;
always
	begin
	if(clk)
	    if (we)
		begin
		hi <= wdhi;
		lo <= wdlo;
		end
	#5;
	assign rdhi = hi;
	assign rdlo = lo;
	end
endmodule