`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/26 09:48:17
// Design Name: 
// Module Name: tb_Processor
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

module Processor_tb;
    reg clk, rst_n;
    reg [7:0] Dout;
    reg IRQ_n;
    wire ADDR0, RW0;
    wire ADDR1, RW1;
    wire [7:0] Din;
    wire [7:0] Din0;
    wire [7:0] Din1;


    wire clk_o0, clk_o1;
    parameter PERIOD = 20;
    parameter wait_cycle = 15;
    parameter wait_time = PERIOD * wait_cycle;
    parameter bus_wait = 5;
    parameter bus_wait_time = bus_wait * PERIOD;
    Processor #(
        .cnt_5ms(wait_cycle),
        .bus_wait(bus_wait)
        ) uut0 (
        .clk(clk),
        .rst_n(rst_n),
        .Dout(Dout),
        .IRQ_n(IRQ_n),
        .mode(0),

        .ADDR(ADDR0),
        .Din(Din0),
        .RW(RW0),
        .clk_o(clk_o0)
    );
    Processor #(
        .cnt_5ms(wait_cycle),
        .bus_wait(bus_wait)
        )
        uut1 (
        .clk(clk),
        .rst_n(rst_n),
        .Dout(Dout),
        .IRQ_n(IRQ_n),
        .mode(1),

        .ADDR(ADDR1),
        .Din(Din1),
        .RW(RW1),
        .clk_o(clk_o1)
    );
    
    initial begin
        clk = 0;
        forever #(PERIOD/2) clk = ~clk;
    end
    
    initial begin
        #(PERIOD/2);
        rst_n = 0;
        Dout = 0;
        IRQ_n = 1;
        #(2*PERIOD);
        rst_n = 1;
        output2POC;
        output2POC;
        output2POC_POCbusy;
        // 测试重置功能
        rst_n = 0;
        Dout = 0;
        IRQ_n = 1;
        #(2*PERIOD);
        rst_n = 1;
        output2POC;

        $finish;
    end
    task output2POC;
    begin
        #(5*PERIOD);
        IRQ_n = 0;      //理论上只对uut1有影响，uut1直接进入select BR
        #(1*PERIOD);
        IRQ_n = 1;
        Dout = 8'b0;
        #(10*PERIOD);
        Dout = 8'b10000000;
        #(bus_wait_time*1);
        // 模拟POC返回SR7=1
        // 此时uut0应该已经进入select_reg和readSR并在后者循环
        // uut1应该做完一套动作，回到idle等待下一次打印了
        // 此时uut0应该已经经过select BR 和 write BR,select SR2, write SR,在done中等待计时结束(uut0)
        #(bus_wait_time*4);
        #(wait_time+2*PERIOD);
        // 计时结束，uut0应该返回idle，out_src自增
    end
    endtask

    task output2POC_POCbusy;
    begin
        #(5*PERIOD);
        IRQ_n = 0;      //理论上只对uut1有影响，uut1直接进入select BR
        #(1*PERIOD);
        IRQ_n = 1;
        Dout = 8'b0;
        // 模拟POC返回SR7=0
        #(bus_wait_time*5);
        #(wait_time+2*PERIOD);
    end
    endtask
endmodule
/*
1. poll模式下，等待结束，proc主动查询SR7
2. SR7 = 1，说明POC空闲，CPU继续操作
3. 选中BR
4. 写BR，Din=‘a’，表示CPU想要给POC写入的字
5. 写SR，让SR7=0
6. 回到空闲状态，开始计时等待
7. 计时结束开始新一轮传输
8. 第三轮传输，但是发现SR7=0，所以无法继续进行
9. 复位
10. 第4轮传输，正常进行
*/

/*
对于中断模式的proc：
1.由IRQ_n=0驱动而不用等到wait_end。直接进入写BR状态
2.选中BR
3.将字母a写入BR
4.写SR，让POC处理当前BR内容
5.一套流程结束，回到idle
6.可以看到即使wait_end=1,也不会触发。该模式下CPU仅仅由IRQ_n驱动
7.开始新一轮传输
*/