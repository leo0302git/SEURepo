`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/26 11:41:34
// Design Name: 
// Module Name: tb_Counter_level
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module Counter_level_tb;
    reg clk, rst_n, start;
    reg [17:0] count_value;
    wire done;
    
    Counter_level uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .count_value(count_value),
        .done(done)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst_n = 0;
        start = 0;
        count_value = 18'd5; // 测试小计数值
        #20;
        rst_n = 1;
        #10;
        start = 1;
        #50
        start = 0;
        #10;
        start = 1;
        #500
        start = 0;
        #200;
        $finish;
    end
endmodule
