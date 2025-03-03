`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/26 09:48:17
// Design Name: 
// Module Name: tb_Top_module
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


module Top_module_tb;
    reg clk, rst_n;
    parameter PERIOD = 20;
    parameter wait_cycle = 20;
    parameter wait_time = PERIOD * wait_cycle;
    parameter bus_wait = 5;
    parameter bus_wait_time = bus_wait * PERIOD;
    parameter print_cycle_cnt = 35;
    parameter print_time = print_cycle_cnt * PERIOD;
    Top_module uut (
        .clk(clk),
        .rst_n(rst_n)
    );
    //wire [7:0]Dout;
    //wire IRQ_n;
    wire ADDR0,ADDR1,RW0,RW1,clk_o0,clk_o1,IRQ_n0,IRQ_n1,RDY0,RDY1,TR1,TR0;
    wire [7:0]Din0;
    wire [7:0]Din1;
    wire [7:0]Dout0;
    wire [7:0]Dout1;
    wire [7:0]PD0;
    wire [7:0]PD1;

    Processor #(
        .cnt_5ms(wait_cycle),
        .bus_wait(bus_wait)
        )   
    proc0 (
        .clk(clk),
        .rst_n(rst_n),
        .Dout(Dout0),
        .IRQ_n(IRQ_n0),
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
        proc1 (
        .clk(clk),
        .rst_n(rst_n),
        .Dout(Dout1),
        .IRQ_n(IRQ_n1),
        .mode(1),

        .ADDR(ADDR1),
        .Din(Din1),
        .RW(RW1),
        .clk_o(clk_o1)
    );
    POC #(.mode(8'b0))
    POC0 (
        .clk(clk_o0),
        .rst_n(rst_n),
        .RW(RW0),
        .Din(Din0),
        .ADDR(ADDR0),
        .RDY(RDY0),
        .IRQ_n(IRQ_n0),
        .Dout(Dout0),
        .TR(TR0),
        .PD(PD0)
    );
    POC #(.mode(8'b1))
    POC1 (
        .clk(clk_o1),
        .rst_n(rst_n),
        .RW(RW1),
        .Din(Din1),
        .ADDR(ADDR1),
        .RDY(RDY1),
        .IRQ_n(IRQ_n1),
        .Dout(Dout1),
        .TR(TR1),
        .PD(PD1)
    );
    Printer #(
        .cnt_5ms(print_time))   
    printer0 
    (
        .clk(clk),
        .rst_n(rst_n),
        .TR(TR0),
        .PD(PD0),
        .RDY(RDY0)
    );
    Printer #(
        .cnt_5ms(print_time))   
    printer1 
    (
        .clk(clk),
        .rst_n(rst_n),
        .TR(TR1),
        .PD(PD1),
        .RDY(RDY1)
    );
    initial begin
        clk = 0;
        forever #(PERIOD/2) clk = ~clk;
    end
    
    initial begin
        #(PERIOD/2);
        rst_n = 0;
        #(5*PERIOD);
        rst_n = 1;
        #(5*PERIOD); 
        $finish;
    end
endmodule

/*
总仿真文件逻辑
一、poll模式下的仿真
1. 例化mode=0的CPU和POC
2. CPU以每20个周期一次的轮询速度想打印字符
3. printer以35个周期/字的速度打印

仿真流程：
POC 的SR7=1表示POC就绪
CPU当时正在等待，所以没有立即开始传送
CPU 的wait end=1后，立即选中SR
CPU的RW和ADDR为00持续一段时间，表示选中SR
CPU的DOUT出现由POC的SR传来的数据
CPU知道POC空闲，于是选中BR并持续一段时间，同时out_src也出现了要打印的内容并保持
CPU正式向BR写数据，此时应该检查POC的BR寄存器是否更新
CPU选中SR并保持
CPU向SR写状态字使得高位为0，交由POC处理

假设POC收到数据之后想给printer传，但是printer没有处理完上一个任务，所以POC只能等待
printer的RDY=1开始
POC的PD出现数据并保持一段时间
POC的TR=1并一直保持
printer的RDY=0做出回应，一直保持
POC TR变低并保持，作为对RDY的回应。同时SR7=1表示POC已经可用
Printer延时一时间后，重新给出RDY
POC将SR7置一表示可用

二、中断模式下的仿真
POC的SR7=1表示POC就绪，中断模式下立即发送IRQ_n=0的信号
CPU接收到中断请求信号立即响应：
直接选中BR并保持
写BR并保持
选中SR并保持
写SR状态字使得高位为0让POC做处理

POC与printer握手流程同上

注意：POC的ready与否和printer的ready与否并不直接相关（是异步的），这也是POC存在的意义
*/

/*
top_tb1：poll模式
1.在某一时刻，processor等待结束，开始新一轮尝试传输。由于读到SR7=1，说明POC可以接收传输
2.生成需要传输的内容
3.写入了POC的BR
4.将SR7置为1
5.又等待结束，但是POC并没有处理好上一个字，所以CPU无法传输

top_tb2:
1.printer结束了上一个字的打印，发出RDY信号到POC
2.POC给出TR=1信号
3.printer将RDY=0同时buffer接收到了来自PD的内容
4.POC响应RDY置零信号，将TR置零，同时将SR7置一，表示CPU可以传给他下一个字了
5.POC将SR7内容送上Dout被CPU接收到SR7=1
6.CPU开始新一轮内容传输
7.产生了第二次待传输的内容'b'，并写到了BR
7.CPU等待结束，又想写新的字了，但是打印机那边还没处理好‘a’的打印，所以没给POC，RDY信号，POC的BR里存着'b'还没交给printer打印，所以不接受CPU的传输。等到printer结束上一个字的打印时，新一轮循环又可以开始了

top_tb3
是poll模式的总览。可以看到打印机循环打印a-z，由线1和线2可知，打印的内容始终比CPU想打印的内容延后一个byte，这是printer处理速度比较慢造成的

top_tb4 中断模式
1.printer打印好上一个内容，给出RDY=1
2. POC给出TR=1，请求传送
3. printer以RDY置零作为回应，同时buffer也用PD内容更新
4. printer开始打印buffer中的内容
5.TR置零，POC对CPU给出中断请求
6.CPU给出中断响应，开始传输新的内容给POC
7.CPU产生新的内容
8.写入POC的BR
9.CPU选中POC的sr7置零

top_tb5 总览，可以看到实现了循环打印a-z的功能

*/