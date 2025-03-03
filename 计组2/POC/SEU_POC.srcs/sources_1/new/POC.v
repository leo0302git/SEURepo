`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/24 15:00:50
// Design Name: 
// Module Name: POC
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


module POC
#(
    parameter mode = 8'b0,
    parameter cnt_5ms = 18'd250000,  // 计数最大值（例如5ms，假设时钟频率为50MHz!!!）
    parameter bus_wait = 5    // 每当数据或命令上总线时，总要停留5个周期才结束
)
(
    input clk,
    input rst_n,
    input RW,
    input [7:0]Din,
    input ADDR,
    input RDY,

    output reg IRQ_n,
    output reg [7:0]Dout,
    output reg TR,
    output reg [7:0]PD
);
reg [2:0]current_state = 3'b0;
reg [2:0]next_state = 3'b0;
reg [7:0]SR = mode;
reg [7:0]BR = 8'b0;
wire cnt_full;
reg [17:0]cycle_cnt = bus_wait;
reg enable = 0;

parameter s_idle = 3'b000;
parameter s_load_data = 3'b001;
parameter s_transfering = 3'b010;
parameter s_done = 3'b011;

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
        if (RDY == 1 && SR[7] == 0) begin
            next_state <= s_load_data;
        end
        else next_state <= s_idle;
    end
    s_load_data: begin
        if (cnt_full == 1)begin
            next_state <= s_transfering;
        end
        else next_state<= s_load_data;
    end
    s_transfering: begin
        if (RDY == 1) begin
            next_state <= s_transfering;
        end
        else next_state <= s_done;
    end
    s_done: begin
        if (cnt_full == 1)begin
            next_state <= s_idle;
        end
        else next_state<= s_done;    
    end
    endcase
end
//第三段状态机
always @(posedge clk) begin
    if (!rst_n)begin
        current_state <= 0;
        next_state <= 0;
        SR[7] <= 0;
        //SR[3] <= 1;
        SR[0] <= mode;
        BR <= 0;
        TR <= 0;
        IRQ_n <= 1;
        Dout <= 8'b0;
        PD <= 0;
    end
    case(current_state)
    s_idle: begin
        IRQ_n <= 1;
        if (RW == 0 && ADDR == 0) Dout <= SR;
        else if (RW == 0 && ADDR == 1) Dout <= BR;
        else if (RW == 1 && ADDR == 0) SR[7:1] <= Din[7:1];
        else BR <= Din;
    end
    s_load_data: begin
        if (cnt_full == 1)begin
            enable <= 0;
        end
        else enable <= 1;
        PD <= BR;
        TR <= 1;
    end
    s_done: begin
        if (cnt_full == 1)begin
            enable <= 0;
        end
        else enable <= 1;
        SR[7] <= 1;
        TR <= 0;
        if (SR[0] == 1)begin
            IRQ_n <= 0;
        end
        else begin
            IRQ_n <= 1;
        end
    end
    endcase
end

Counter_level #(
    .WIDTH(18)  // 定义计数器宽度，18位以支持5ms延时
) u_counter2 (
    .clk(clk),                    // 时钟信号
    .rst_n(rst_n),                // 复位信号
    .start(enable),        // 启动信号
    .count_value(cycle_cnt),  // 计数值
    .done(cnt_full)           // 计数完成信号,只会输出一个脉冲，所以不用手动将wait_end置零
);
initial begin
    $display("Mode: %b", mode);
end
endmodule
