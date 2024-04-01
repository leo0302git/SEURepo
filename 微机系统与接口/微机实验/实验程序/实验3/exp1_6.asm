DATA SEGMENT ;定义数据段
D1 DB 08,04,03,03,05
D2 DB 09 ;这两个十进制数相乘，不超过6位
SUM DB 6 DUP(0) ;将存放最大值的变量初始化为0,预先不知道结果多长
OTHER DB 0DH,0AH,'$' ;为了使用字符串输出指令，加上回车、换行和$
;第一次多打了一个逗号，多出来一个00
DATA ENDS
CODE SEGMENT 
ASSUME DS:DATA,CS:CODE ;说明代码段、数据段
GO: 
	MOV AX,DATA 
	MOV DS,AX ;给DS赋初值
	MOV SI,OFFSET D1 ;忘加offset
	MOV BL,[D2];把乘数放入BL,开始时忘加方框
	MOV DI,OFFSET OTHER ;目标存放地址放入DI
DEC DI;指到SUM单元的最后一位，低位放后面，便于后续正序输出
	MOV DX,0;因后续进位存放在DL，先清零
	MOV CX,5 ;做乘法的次数
NEXT:
	MOV AL,[SI] ;将被乘数从低位移入
INC SI
MUL BL
AAM;乘法的ASCII调整,AX中存放非压缩乘积，乘积的低位在AL，高位在AH
ADD AL,DL ;加上进位
AAA ;作加法的ASCII调整，把可能的进位加到AH上
MOV DL,AH;低位向高位的进位要留起来
ADD AL,30H;ASCII数字字符的范围是30H(0)~39H(9)
MOV [DI],AL ;低位存入目的存储单元
DEC DI
LOOP NEXT
	ADD AH,30H;这时候已经是最后的高位了，要加30H来从非压缩BCD码转换到ASCII码
	MOV [DI],AH;此时DI已经指到最高位
	CMP AH,30H
	JNE LAST
	INC DI ;若最高位为0.从次高位开始输出（结果要么是5位要么是6位）
LAST:
	MOV DX,DI; 字符串的首址放到DX，准备输出
	MOV AH,9 ;调用输出字符串的功能
	INT 21H;输出字符串
	MOV AH,4CH
	INT 21H
CODE 	ENDS
		END GO

