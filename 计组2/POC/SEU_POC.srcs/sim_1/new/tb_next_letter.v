`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/26 09:48:17
// Design Name: 
// Module Name: tb_next_letter
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


module next_letter_tb;
    reg clk, rst_n, trigger;
    wire [7:0] out_src;
    integer i;
    next_letter uut (
        .clk(clk),
        .rst_n(rst_n),
        .trigger(trigger),
        .out_src(out_src)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        
        rst_n = 0;
        trigger = 0;
        #20;
        rst_n = 1;
        get_a2z;
        get_letter;
        get_letter;
        // 检查重置功能
        rst_n = 0;
        trigger = 0;
        #20;
        rst_n = 1;
        get_letter;
        get_a2z;
        $finish;
    end

    task get_letter;
    begin
        trigger = 1;
        #10;
        trigger = 0;
        #100;
    end
    endtask
    task get_a2z;
        begin
            // 使用for循环测试不同的计数值
            for (i = 1; i <= 26; i = i + 1) begin
                get_letter;
            end
        end
    endtask
endmodule
