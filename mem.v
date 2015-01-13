/**********rom************/
module scinstmem(raddr, inst);
input [31:0] raddr;
output [31:0] inst;
reg [31:0] rom[1023:0];

initial
begin
	$readmemb("rom.vlog", rom);
	$display("\nLoad rom successfully!\n\n");
end
assign inst = rom[raddr[11:2]];
endmodule


/**********ram************/
module scdatamem(clk, wen, addr, win, rout);
input clk, wen;
input [31:0] addr, win;
output [31:0] rout;

initial
begin
	$readmemb("ram.vlog", ram);
	$display("\nLoad initial data successfully!\n\n");
end

reg [31:0] ram[1023:0];
assign rout = ram[addr[11:2]];

always @(posedge clk)
begin
	if (wen)
		ram[addr] <= win;
end
endmodule