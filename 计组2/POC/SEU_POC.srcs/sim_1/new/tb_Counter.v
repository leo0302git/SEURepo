`timescale 1ns / 1ps

module Counter_tb;

    // 参数定义
    parameter WIDTH = 18;  // 计数器宽度
    parameter CLK_PERIOD = 10;  // 时钟周期为10ns

    // 信号定义
    reg clk;  // 时钟信号
    reg rst_n;  // 复位信号
    reg start;  // 开始计数的脉冲信号
    reg [WIDTH-1:0] count_value;  // 计数值
    wire done;  // 计数完成信号

    // 实例化Counter模块
    Counter #(
        .WIDTH(WIDTH)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .count_value(count_value),
        .done(done)
    );

    // 时钟信号生成
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // 测试序列
    initial begin
        // 初始化信号
        rst_n = 0;  // 先复位
        start = 0;
        count_value = 0;

        // 等待100ns稳定
        #(CLK_PERIOD/2);
        #100;
        rst_n = 1;  // 释放复位

        // 测试1：简单的计数测试
        count_value = 5;  // 设置计数值为5
        #20;
        start = 1;  // 发送start脉冲
        #CLK_PERIOD;
        start = 0;

        // 等待计数完成
        #100;

        // 测试2：更大的计数值
        count_value = 10;  // 设置计数值为10
        #20;
        start = 1;  // 发送start脉冲
        #CLK_PERIOD;
        start = 0;

        // 等待计数完成
        #150;

        // 测试3：连续启动测试（验证是否能正确处理连续的start脉冲）
        count_value = 3;  // 设置计数值为3
        #20;
        start = 1;  // 发送start脉冲
        #CLK_PERIOD;
        start = 0;
        #10;
        start = 1;  // 再次发送start脉冲
        #CLK_PERIOD;
        start = 0;

        // 等待计数完成
        #100;

        // 测试4：复位测试
        #20;
        rst_n = 0;  // 施加复位
        #CLK_PERIOD;
        rst_n = 1;  // 释放复位
        #20;
        count_value = 5;  // 设置计数值为5
        #20;
        start = 1;  // 发送start脉冲
        #CLK_PERIOD;
        start = 0;
        // 结束测试
        #100;
        $finish;
    end

    // 监控信号变化
    initial begin
        $monitor("Time = %t, clk = %b, rst_n = %b, start = %b, count_value = %d, done = %b",
                 $time, clk, rst_n, start, count_value, done);
    end

endmodule