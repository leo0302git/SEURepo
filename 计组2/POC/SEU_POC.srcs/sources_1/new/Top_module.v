`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/24 15:00:50
// Design Name: 
// Module Name: Top_module
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


module Top_module
// #(
//     parameter u_seg_all_one_dis_t = 25'd1_000_00,
//     parameter u_LED_16_cnt_max4_blink = 32'd500_000_00,
//     parameter u_LED_16_min_s4breath = 32'd99,
//     parameter u_LED_16_T_10ms4breath = 32'd499999
// )
(
    input clk,
    input rst_n
);
// Processor and POC interconnect
wire addr;
wire [7:0]d_o;
wire [7:0]d_i;
wire read_write;
wire internal_clk;
wire irq;

// POC and Printer interconnect
wire rdy;
wire tr;
wire [7:0]pd;
// output wire clk_o;
// assign clk_o = clk; // 直接透传时钟

Processor u_processor(
    .ADDR(addr),
    .Dout(d_o),
    .Din(d_i),
    .RW(read_write),
    .clk(internal_clk),
    .IRQ_n(irq)
);

POC u_POC(
    .ADDR(addr),
    .Dout(d_o),
    .Din(d_i),
    .RW(read_write),
    .clk(internal_clk),
    .rst_n(rst_n),
    .IRQ_n(irq),
    .RDY(rdy),
    .TR(tr),
    .PD(pd)
);

Printer u_printer(
    .RDY(rdy),
    .TR(tr),
    .rst_n(rst_n),
    .clk(clk),
    .PD(pd)
);
endmodule
