module alu (opa, opb, aluc, result, z);
//define the ports
input [31:0] opa, opb;
input [3:0] aluc;
output [31:0] result;
output z;

wire [31:0] r_and = opa & opb;
wire [31:0] r_or = opa | opb;
wire [31:0] r_xor = opa ^ opb;
wire [31:0] r_lui = {opb[15:0], 16'h0};
wire [31:0] r_and_or = aluc[2]? r_or: r_and;
wire [31:0] r_xor_lui = aluc[2]? r_lui: r_xor;
wire [31:0] r_add_sub = aluc[2]? (opa - opb): (opa + opb);
wire [31:0] r_shift = aluc[2]? (aluc[3]? ($signed(opb) >>> opa[4:0]): (opb >> opa[4:0]))
								: opb << opa[4:0];
mux4x32 alu_select (.op0(r_add_sub), .op1(r_and_or), .op2(r_xor_lui), .op3(r_shift), .select(aluc[1:0]), .result(result));
assign z = ~| result;	//negate after or by bit to judge whether the result equals 0 
endmodule	//alu


module regfile ();
endmodule	//regfile


module mux4x32 (op0, op1, op2, op3, select, result);
//define the ports
input [31:0] op0, op1, op2, op3;
input [1:0] select;
output [31:0] result;

assign result = select[1]? (select[0]? op3: op2)
				:(select[0]? op1: op0);
endmodule	//mux4x32

module mux2x32 (op0, op1, select, result);
input [31:0] op0, op1;
input select;
output [31:0] result;
assign result = select? op1: op0;
endmodule	//mux2x32

module mux2x5 (op0, op1, select, result);
input [5:0] op0, op1;
input select;
output [5:0] result;
assign result = select? op1: op0;
endmodule	//mux2x5
