DATA SEGMENT ;�������ݶ�
ARRAY DB 22,46,32,72,84,16,156 ;����һ������
MAXN1 DB 0 ;��������ֵ�ı�����ʼ��Ϊ0 
DATA ENDS
CODE SEGMENT 	;��������
	  ASSUME DS:DATA,CS:CODE ;˵������Ρ����ݶ�
START: 
	MOV AX,DATA 
	MOV DS,AX ;��DS����ֵ
	MOV CX,6 ;��ѭ��������
	LEA DI,ARRAY ;��ARRAY��ʾ��ƫ�Ƶ�ַ�͵�DI
	MOV DL,[DI] ;����һ���������͵��Ĵ�����
	JCXZ LAST 
AGIN:
	INC DI
	CMP DL,[DI]
	JGE NEXT ;DL>[DI]ʱ��ת���������»���
	MOV DL,[DI]
NEXT:
	LOOP AGIN
LAST:
	MOV MAXN1,DL
	MOV AH,4CH
	INT 21H
CODE 	ENDS
		END START
; �տ�ʼ������Ϊ��λ�洢����INCֻһ�Σ���Ȼ�������������ֿ������ֽڴ洢
;HEX:16 2E 10 48 54 9C ֻ�����һ������С