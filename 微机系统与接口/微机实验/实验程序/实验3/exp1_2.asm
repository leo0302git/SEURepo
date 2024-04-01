DATA SEGMENT ;定义数据段
ARRAY DB 22,46,32,72,84,16,156 ;定义一串数据
MAXN1 DB 0 ;将存放最大值的变量初始化为0 
DATA ENDS
CODE SEGMENT 	;定义代码段
	  ASSUME DS:DATA,CS:CODE ;说明代码段、数据段
START: 
	MOV AX,DATA 
	MOV DS,AX ;给DS赋初值
	MOV CX,6 ;置循环控制数
	LEA DI,ARRAY ;将ARRAY表示的偏移地址送到DI
	MOV DL,[DI] ;将第一个操作数送到寄存器中
	JCXZ LAST 
AGIN:
	INC DI
	CMP DL,[DI]
	JGE NEXT ;DL>[DI]时跳转，跳过更新环节
	MOV DL,[DI]
NEXT:
	LOOP AGIN
LAST:
	MOV MAXN1,DL
	MOV AH,4CH
	INT 21H
CODE 	ENDS
		END START
; 刚开始用字作为单位存储，且INC只一次，显然不够。后来发现可以用字节存储
;HEX:16 2E 10 48 54 9C 只有最后一个数最小