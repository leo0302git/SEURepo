DATA SEGMENT ;�������ݶ�
STR1 DB 'HELLO12345'
RESULT1 DB 0
RESULT2 DB 0
DATA ENDS
EXTRA SEGMENT;���帽�Ӷ�
STR2 DB 'HELLO1&345' ;��������ȫ��ͬ
EXTRA ENDS
CODE SEGMENT 
ASSUME DS:DATA,CS:CODE,ES:EXTRA ;˵������Ρ����ݶ�
GO: 
	MOV CX,10;��һ�������ô���
	MOV AX,DATA 
	MOV DS,AX ;��DS����ֵ
	MOV AX,EXTRA
	MOV ES,AX;��ES����ֵ
	MOV SI,OFFSET STR1;
	MOV DI,OFFSET STR2
	REPE CMPSB
	JZ EQQ;������ȫһ�����Ͳ���ת
	DEC SI;�ָ�����һ���ĵط�
	MOV BX,SI;���Ͳ�һ�����ֽڵ�ַ
	MOV [RESULT1],BL ;ֻ�б����ſ�����LOWָ��
	MOV AL,[SI]
	MOV [RESULT2],AL
	JMP LAST
EQQ: 
	MOV [RESULT1],0;����ȫ��ͬ��RESULT1��0
LAST:
	MOV AH,4CH
	INT 21H
CODE 	ENDS
		END GO
