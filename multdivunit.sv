module multdivunit(input logic [31:0] a, b,
		input logic multordiv,
		output logic [31:0] hi, lo);

always_comb
if (multordiv)
	assign {hi, lo} = a * b;
else
	begin
	assign lo = a / b;
	assign hi = a % b;
	end

endmodule
