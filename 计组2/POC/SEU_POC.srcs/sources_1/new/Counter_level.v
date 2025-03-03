module Counter_level #(
    parameter WIDTH = 18 // 默认计数器宽度为18位（根据计数需求可调整）
)(
    input clk,            // 时钟信号
    input rst_n,          // 复位信号
    input start,          // 开始计数的信号
    input [WIDTH-1:0] count_value,  // 计数值,一个时钟跳一下，所以count_value是想要延时的时钟个数
    output reg done      // 计数完成信号
);
    reg [WIDTH-1:0] count;  // 计数器

    // 计数器逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;      // 复位时计数器归零
            done <= 0;       // 计数完成信号复位
        end 
        else if (start) begin
            if (count < count_value) begin
                count <= count + 1; // 计数加1
                done <= 0;           // 计数未完成
            end else begin
                done <= 1;           // 达到计数值，输出done信号
                count <= 0;
            end
        end
        else if (start == 0)begin
            done <= 0;
            count <= 0;
        end
    end
endmodule