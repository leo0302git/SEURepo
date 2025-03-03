`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/26 09:48:17
// Design Name: 
// Module Name: tb_POC
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


module POC_tb;
    reg clk, rst_n, RW, RDY;
    reg [7:0] Din;
    reg ADDR;
    wire [7:0]Dout0;
    wire [7:0]Dout1;
    wire IRQ_n0, IRQ_n1, TR0, TR1;
    wire [7:0]PD0;
    wire [7:0]PD1;
    parameter PERIOD = 20;
    parameter print_cycle_cnt = 10;
    POC #(.mode(8'b0))
    uut0 (
        .clk(clk),
        .rst_n(rst_n),
        .RW(RW),
        .Din(Din),
        .ADDR(ADDR),
        .RDY(RDY),
        .IRQ_n(IRQ_n0),
        .Dout(Dout0),
        .TR(TR0),
        .PD(PD0)
    );
    POC #(.mode(8'b1))
    uut1 (
        .clk(clk),
        .rst_n(rst_n),
        .RW(RW),
        .Din(Din),
        .ADDR(ADDR),
        .RDY(RDY),
        .IRQ_n(IRQ_n1),
        .Dout(Dout1),
        .TR(TR1),
        .PD(PD1)
    );
    
    initial begin
        clk = 0;
        forever #(PERIOD/2) clk = ~clk;
    end
    
    initial begin
        #(PERIOD/2);
        rst_n = 0;
        RW = 0;
        ADDR = 0;
        Din = 0;
        RDY = 0;
        #(5*PERIOD);
        rst_n = 1;

        #(5*PERIOD);
        RW = 1;         //写
        ADDR = 1;       //选中BR
        Din = 8'h61; // processor写入BR
        
        #(5*PERIOD);
        RW = 1;         //写
        ADDR = 0;       //选中SR
        Din[7:1] = 7'b0; // processor写入SR,使得SR7=0等待POC处理，由于打印机没准备好，所以POC不予理会
        #(5*PERIOD);
        // 模拟打印机准备好了，给POC发出RDY=1
        
        RW = 0;         //proc读（这一步是必要的，否则之后SR被POC置为80h，一周期后跳转到idle又被proc置为00h了）
        #(5*PERIOD);
        RDY = 1;
        #(2*PERIOD);        
        //在这段时间内POC应该经历了两个阶段到达transfering
        RDY = 0;//两个周期之后，打印机给出反馈：RDY=0，表示printer busy
        #(100*PERIOD);

        // 传输第二次
        rst_n = 0;
        RW = 0;
        ADDR = 0;
        Din = 0;
        RDY = 0;
        #(5*PERIOD);
        rst_n = 1;

        #(5*PERIOD);
        RW = 1;         //写
        ADDR = 1;       //选中BR
        Din = 8'h62; // processor写入BR
        
        #(5*PERIOD);
        RW = 1;         //写
        ADDR = 0;       //选中SR
        Din[7:1] = 7'b0; // processor写入SR,使得SR7=0等待POC处理，由于打印机没准备好，所以POC不予理会
        #(5*PERIOD);
        // 模拟打印机准备好了，给POC发出RDY=1
        
        RW = 0;         //proc读（这一步是必要的，否则之后SR被POC置为80h，一周期后跳转到idle又被proc置为00h了）
        #(5*PERIOD);
        RDY = 1;
        #(2*PERIOD);        
        //在这段时间内POC应该经历了两个阶段到达transfering
        RDY = 0;//两个周期之后，打印机给出反馈：RDY=0，表示printer busy
        #(100*PERIOD);
        $finish;
    end

    /*
    1.模拟CPU将待打印内容（a）写入BR
    2.写入SR7=0，待POC响应。但是由于打印机没有给出RDY，所以POC无动作
    3.将proc调整到读状态，避免影响BR内容
    4.打印机传来RDY信号
    5.POC响应RDY信号，将BR内容传递给PD，同时TR拉高，将内容给printer。printer做出回应（RDY=0）后，TR也响应（TR=0）。同时中断模式下POC会发出IRQ_n=0告知proc，而poll模式下不会。
    6.检查复位功能是否完备
    7.进行第二次传输，正常结束
    */
endmodule
