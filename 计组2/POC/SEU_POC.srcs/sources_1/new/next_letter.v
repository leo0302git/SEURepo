module next_letter(
    input clk,          // 时钟信号
    input rst_n,        // 异步复位信号，低电平有效
    input trigger,      // 激励信号
    output reg [7:0] out_src  // 输出寄存器
);

always @(posedge trigger or negedge rst_n) begin
    if (!rst_n) begin
        out_src <= 0;  // 初始化为 'a' 的 ASCII 码
    end 
    else if (trigger) begin
        if (out_src == 0) begin
            out_src <= 8'd97;
        end
        else if (out_src == 8'd122) begin
            out_src <= 8'd97;  // 如果当前是 'z'，下一个字母是 'a'
        end 
        else begin
            out_src <= out_src + 1;  // 否则直接加 1
        end
    end
end

endmodule