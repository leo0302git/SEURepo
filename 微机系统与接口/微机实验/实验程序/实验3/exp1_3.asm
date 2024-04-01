DATA SEGMENT ;定义数据段
ARRAY DW 58,25,45,73,64,43 ;定义一串数据
SUM DW 0 ;将存放最大值的变量初始化为0 
DATA ENDS
CODE SEGMENT 
ASSUME DS:DATA,CS:CODE ;说明代码段、数据段
START: 
	MOV AX,DATA 
	MOV DS,AX ;给DS赋初值
	MOV AX,0;
	MOV CX,6
;报错：must be associated with data
	LEA DI,ARRAY ;将ARRAY表示的偏移地址送到DI
AGIN:
	ADD AX,[DI];刚开始没加方框
	INC DI
INC DI
	LOOP AGIN ;该条指令执行后CX自动-1，手动写反而出错
LAST:
	MOV SUM,AX
	MOV AH,4CH
	INT 21H
CODE 	ENDS
		END START

;当以CX=1状态来到LOOP时，LOOP不会继续循环，而是将CX-1然后跳出循环