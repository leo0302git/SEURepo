DATA SEGMENT ;�������ݶ�
ARRAY DW 58,25,45,73,64,43 ;����һ������
SUM DW 0 ;��������ֵ�ı�����ʼ��Ϊ0 
DATA ENDS
CODE SEGMENT 
ASSUME DS:DATA,CS:CODE ;˵������Ρ����ݶ�
START: 
	MOV AX,DATA 
	MOV DS,AX ;��DS����ֵ
	MOV AX,0;
	MOV CX,6
;����must be associated with data
	LEA DI,ARRAY ;��ARRAY��ʾ��ƫ�Ƶ�ַ�͵�DI
AGIN:
	ADD AX,[DI];�տ�ʼû�ӷ���
	INC DI
INC DI
	LOOP AGIN ;����ָ��ִ�к�CX�Զ�-1���ֶ�д��������
LAST:
	MOV SUM,AX
	MOV AH,4CH
	INT 21H
CODE 	ENDS
		END START

;����CX=1״̬����LOOPʱ��LOOP�������ѭ�������ǽ�CX-1Ȼ������ѭ��