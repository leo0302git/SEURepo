`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/24 15:00:50
// Design Name: 
// Module Name: Printer
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


module Printer
#(
    parameter cnt_5ms = 18'd250000  // 计数最大值(时钟的个数)（例如5ms，假设时钟频率为50MHz!!!）
)
(
    input TR,
    input [7:0]PD,
    input rst_n,
    input clk,

    output reg RDY
);
// 定义状态
parameter s_idle = 3'b000;
parameter s_respond = 3'b001;
parameter s_receive = 3'b010;
parameter s_print = 3'b011;

// 定义寄存器
reg [2:0]current_state = 3'b0;
reg [2:0]next_state = 3'b0;
reg [7:0]buffer = 0;
reg print_flag = 0;

//第一段状态机
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
        if (TR == 1)begin
            next_state <= s_respond;
        end
        else begin
            next_state <= s_idle;
        end
    end
    s_respond: begin
        next_state <= s_receive;
    end
    s_receive:begin
        next_state <= s_print;
    end
    s_print: begin
        if (print_flag == 0) begin
            next_state <= s_idle;
        end
        else begin
            next_state <= s_print;
        end
    end
    default: next_state <= s_idle;
    endcase
end


//第三段状态机
always @(posedge clk) begin
    if (!rst_n)begin
        current_state <= 0;
        next_state <= 0;
        buffer <= 0;
        RDY <= 0;
    end
    case(current_state)
    s_idle: begin 
        if (rst_n != 0)begin
            RDY <= 1;
        end
        // print_flag <= 0;
    end
    s_respond: begin
        RDY <= 0;
        buffer <= PD;
    end
    s_receive: begin
        print_flag <= 1;
    end
    // s_print: begin
        
    // end
    endcase
end

// 定义计数器相关信号
wire counter_done;  // 计数完成信号
Counter_level #(
    .WIDTH(18)  // 定义计数器宽度，18位以支持5ms延时
) u_counter (
    .clk(clk),                    // 时钟信号
    .rst_n(rst_n),                // 复位信号
    .start(print_flag),        // 启动信号
    .count_value(cnt_5ms),  // 计数值
    .done(counter_done)           // 计数完成信号
);

always @(posedge clk) begin
    if (counter_done == 1) begin
        print_flag <= 0;
    end
end
endmodule

