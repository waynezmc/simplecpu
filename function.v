/************alu module *************/
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

/************regfile module*************/
module regfile (raddra, raddrb, win, waddr, wen, clk, clrn, routa, routb);
input [4:0] raddra, raddrb, waddr;	//2 read ports and 1 write port;
input [31:0] win;					//data for write
input wen, clk, clrn;				//wen: enable write
output [31:0] routa, routb;
reg [31:0] register [31:0];

//2 read ports
assign routa = register[raddra];
assign routb = register[raddrb];

//1 write port
always @(posedge clk or negedge clrn)
begin
	if (clrn == 0)
	begin
		reg [4:0] i;
		for (i = 0; i < 32; i = i + 1)
			register[i] <= 32h'0;
	end
	else if ((waddr != 0) && wen)
		register[waddr] <= win; 
end
endmodule	//regfile

/************mux4x32 module*************/
module mux4x32 (op0, op1, op2, op3, select, result);
//define the ports
input [31:0] op0, op1, op2, op3;
input [1:0] select;
output [31:0] result;

assign result = select[1]? (select[0]? op3: op2)
				:(select[0]? op1: op0);
endmodule	//mux4x32

/************mux2x32 module*************/
module mux2x32 (op0, op1, select, result);
input [31:0] op0, op1;
input select;
output [31:0] result;
assign result = select? op1: op0;
endmodule	//mux2x32

/************mux2x5 module*************/
module mux2x5 (op0, op1, select, result);
input [5:0] op0, op1;
input select;
output [5:0] result;
assign result = select? op1: op0;
endmodule	//mux2x5

/************dffe32 module*************/
module dffe32 (d, clk, clrn, en, q);
input [31:0] d;
input clk, clrn, en;
output reg [31:0] q;

always @(posedge clk or negedge clrn)
begin
	if (clrn == 0)
		q <= 0;
	else if (en)
		q <= d;
end
endmodule	//dffe32
