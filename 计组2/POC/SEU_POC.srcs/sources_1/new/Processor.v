`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/24 15:00:50
// Design Name: 
// Module Name: Processor
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


module Processor#(
    parameter s_idle = 4'b0000,
    parameter s_select_reg = 4'b0001,
    parameter s_read_SR = 4'b0010,
    parameter s_select_BR = 4'b0011,
    parameter s_write_BR = 4'b0100,
    parameter s_select_SR_2 = 4'b0101,
    parameter s_write_SR = 4'b0110,
    parameter s_done = 4'b0111,
    parameter cnt_5ms = 18'd250000,  // 计数最大值（例如5ms，假设时钟频率为50MHz!!!）
    parameter bus_wait = 5    // 每当数据或命令上总线时，总要停留5个周期才结束
)
(
    input clk,
    input rst_n,
    input [7:0]Dout,
    input IRQ_n,
    input mode, //尝试将模式作为输入量而不是内置reg
    output reg ADDR,
    output reg [7:0]Din,
    output reg RW,
    output wire clk_o
);
reg [3:0]current_state = 4'b0;
reg [3:0]next_state = 4'b0;
// reg mode = 0;
reg wait_begin = 0;
wire wait_end;
wire [7:0]out_src;
reg next_letter; //用于指示out_src跳到下一个字母
assign clk_o = clk;

wire cnt_full;
reg [17:0]cycle_cnt = bus_wait;
reg enable = 0;
///////////////////////////////////////// 状态机
// 第一段状态机
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)begin
		current_state <= s_idle;				//复位初始状态
    end
	else
		current_state <= next_state;		//次态转移到现态
end

//第二段状态机
always @(*) begin
    case(current_state)
    s_idle: begin
        if (mode == 0 && wait_end == 1) begin
            next_state <= s_select_reg;
        end
        else if (mode == 1 && IRQ_n == 0) begin
            next_state <= s_select_BR;
        end
        else if (mode == 0 && wait_end == 0) begin
            next_state <= s_idle;
        end
        else begin
            next_state <= s_idle;
        end
    end
    // 1
    s_select_reg: begin
        if (cnt_full == 1)begin
            next_state <= s_read_SR;
        end
        else next_state<= s_select_reg;
    end
    // 2
    s_read_SR: begin
        if (Dout[7] == 1)
            next_state <= s_select_BR;
        else 
            next_state <= s_read_SR;
    end
    // 3
    s_select_BR: begin
        if (cnt_full == 1)begin
            next_state <= s_write_BR;
        end
        else next_state <= s_select_BR;
    end
    // 4
    s_write_BR: begin
        if (cnt_full == 1)begin
            next_state <= s_select_SR_2;
        end
        else next_state <= s_write_BR;
    end
    // 5
    s_select_SR_2: begin
        if (cnt_full == 1)begin
            next_state <= s_idle;
        end
        else next_state <= s_select_SR_2;
    end
    default: begin
        next_state <= s_idle;
    end
    endcase
end

// 第三段状态机
always @(posedge clk) begin
    if (!rst_n)begin
        current_state <= 0;
        next_state <= 0;
        wait_begin <= 0;
        RW <= 0;
        Din <= 0;
        ADDR <= 0;
        next_letter <= 0;
        enable <= 0;
    end
    case(current_state)
    s_idle: begin
        RW <= 0;
        ADDR <= 0;
        if (rst_n == 0) wait_begin <= 0;
        else wait_begin <= 1;
    end
    // 1
    s_select_reg: begin
        if (cnt_full == 1)begin
            enable <= 0;
        end
        else enable <= 1;
        wait_begin <= 0;
        ADDR <= 0;
        RW <= 0;
    end
    // 3 
    s_select_BR: begin
        if (cnt_full == 1)begin
            enable <= 0;
        end
        else enable <= 1;
        ADDR <= 1;
        RW <= 1;
        next_letter <= 1;
    end
    // 4
    s_write_BR: begin
        if (cnt_full == 1)begin
            enable <= 0;
        end
        else enable <= 1;
        Din <= out_src;
        next_letter <= 0;
    end
    // 5
    s_select_SR_2: begin  
        if (cnt_full == 1)begin
            enable <= 0;
        end
        else enable <= 1;  
        ADDR <= 0;
        RW <= 1;
        Din[7:1] <= 7'b0;
        Din[0] <= mode;
    end
    // s_done: begin
    //     if (wait_end == 1) begin
    //         wait_begin <= 0;
    //         //wait_end <= 0;
    //     end
    // end
    endcase
end

// 定义计数器相关信号
wire counter_done;  // 计数完成信号


// 计时器模块实例化
Counter_level #(
    .WIDTH(18)  // 定义计数器宽度，18位以支持5ms延时
) u_counter (
    .clk(clk),                    // 时钟信号
    .rst_n(rst_n),                // 复位信号
    .start(wait_begin),        // 启动信号
    .count_value(cnt_5ms),  // 计数值
    .done(wait_end)           // 计数完成信号,只会输出一个脉冲，所以不用手动将wait_end置零
);


Counter_level #(
    .WIDTH(18)  // 定义计数器宽度，18位以支持5ms延时
) u_counter2 (
    .clk(clk),                    // 时钟信号
    .rst_n(rst_n),                // 复位信号
    .start(enable),        // 启动信号
    .count_value(cycle_cnt),  // 计数值
    .done(cnt_full)           // 计数完成信号,只会输出一个脉冲，所以不用手动将wait_end置零
);

// 例化 next_letter 模块
next_letter u_next_letter (
    .clk(clk),          // 连接时钟信号
    .rst_n(rst_n),      // 连接复位信号
    .trigger(next_letter),  // 连接激励信号
    .out_src(out_src)   // 连接输出信号
);
endmodule
