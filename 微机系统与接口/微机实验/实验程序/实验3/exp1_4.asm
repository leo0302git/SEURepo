DATA SEGMENT ;�������ݶ�
D1 DB 08,04,03,03,05
D2 DB 09 ;������ʮ��������ˣ�������6λ
SUM DB 6 DUP(0) ;��������ֵ�ı�����ʼ��Ϊ0,Ԥ�Ȳ�֪������೤��
DATA ENDS
CODE SEGMENT 
ASSUME DS:DATA,CS:CODE ;˵������Ρ����ݶ�
GO: 
	MOV AX,DATA 
	MOV DS,AX ;��DS����ֵ
	MOV SI,OFFSET D1 ;����offset
	MOV BL,[D2];;�ѳ�������BL,��ʼʱ���ӷ���
	MOV DI,OFFSET SUM ;Ŀ���ŵ�ַ����DI
	MOV DX,0;�������λ�����DL��������
	MOV CX,5 ;���˷��Ĵ���,����ΪSUM��Ԫ�ĳ���
NEXT:
	MOV AL,[SI] ;���������ӵ�λ����
INC SI
MUL BL
AAM;�˷���ASCII����,AX�д�ŷ�ѹ���˻����˻��ĵ�λ��AL����λ��AH
ADD AL,DL ;���Ͻ�λ
AAA ;���ӷ���ASCII�������ѿ��ܵĽ�λ�ӵ�AH��
MOV DL,AH;��λ���λ�Ľ�λҪ������
MOV [DI],AL ;��λ����Ŀ�Ĵ洢��Ԫ
INC DI
LOOP NEXT
	MOV [DI],AH
	MOV AH,4CH
	INT 21H
CODE 	ENDS
		END GO
