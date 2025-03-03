module Counter #(
    parameter WIDTH = 18 // 默认计数器宽度为18位
)(
    input clk,            // 时钟信号
    input rst_n,          // 复位信号
    input start,          // 开始计数的脉冲信号
    input [WIDTH-1:0] count_value,  // 计数值
    output reg done       // 计数完成信号（持续一个时钟周期）
);
    reg [WIDTH-1:0] count;  // 计数器
    reg start_detected;     // 用于检测start脉冲
    reg done_pulse;         // 辅助寄存器，用于生成脉冲信号

    // 检测start脉冲
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            start_detected <= 0;
        end 
        else if (start == 1)begin
            start_detected <= start; // 捕获start脉冲
        end
        else if (done == 1)
            start_detected <= 0;
    end

    // 计数器逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;      // 复位时计数器归零
            done <= 0;       // 计数完成信号复位
            done_pulse <= 0; // 辅助寄存器复位
        end 
        else if (start_detected) begin
            if (count < count_value) begin
                count <= count + 1; // 计数加1
            end 
            else begin
                count <= 0;         // 计数完成后重置计数器
                done <= 1;
            end
        end 
        else begin
            count <= 0;             // 如果未启动计数，重置计数器
            done <= 0;        // 复位辅助寄存器
        end
    end

    // 生成持续一个时钟周期的脉冲信号
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 0;
        end 
        else begin
            if (count == 0)
            done <= 0;
        end
    end
endmodule