DATA SEGMENT ;定义数据段
D1 DB 08,04,03,03,05
D2 DB 09 ;这两个十进制数相乘，不超过6位
SUM DB 6 DUP(0) ;将存放最大值的变量初始化为0,预先不知道结果多长，
DATA ENDS
CODE SEGMENT 
ASSUME DS:DATA,CS:CODE ;说明代码段、数据段
GO: 
	MOV AX,DATA 
	MOV DS,AX ;给DS赋初值
	MOV SI,OFFSET D1 ;忘加offset
	MOV BL,[D2];;把乘数放入BL,开始时忘加方框
	MOV DI,OFFSET SUM ;目标存放地址放入DI
	MOV DX,0;因后续进位存放在DL，先清零
	MOV CX,5 ;做乘法的次数,设置为SUM单元的长度
NEXT:
	MOV AL,[SI] ;将被乘数从低位移入
INC SI
MUL BL
AAM;乘法的ASCII调整,AX中存放非压缩乘积，乘积的低位在AL，高位在AH
ADD AL,DL ;加上进位
AAA ;作加法的ASCII调整，把可能的进位加到AH上
MOV DL,AH;低位向高位的进位要留起来
MOV [DI],AL ;低位存入目的存储单元
INC DI
LOOP NEXT
	MOV [DI],AH
	MOV AH,4CH
	INT 21H
CODE 	ENDS
		END GO
