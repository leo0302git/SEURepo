DATA SEGMENT ;�������ݶ�
D1 DB 08,04,03,03,05
D2 DB 09 ;������ʮ��������ˣ�������6λ
SUM DB 6 DUP(0) ;��������ֵ�ı�����ʼ��Ϊ0,Ԥ�Ȳ�֪������೤
OTHER DB 0DH,0AH,'$' ;Ϊ��ʹ���ַ������ָ����ϻس������к�$
;��һ�ζ����һ�����ţ������һ��00
DATA ENDS
CODE SEGMENT 
ASSUME DS:DATA,CS:CODE ;˵������Ρ����ݶ�
GO: 
	MOV AX,DATA 
	MOV DS,AX ;��DS����ֵ
	MOV SI,OFFSET D1 ;����offset
	MOV BL,[D2];�ѳ�������BL,��ʼʱ���ӷ���
	MOV DI,OFFSET OTHER ;Ŀ���ŵ�ַ����DI
DEC DI;ָ��SUM��Ԫ�����һλ����λ�ź��棬���ں����������
	MOV DX,0;�������λ�����DL��������
	MOV CX,5 ;���˷��Ĵ���
NEXT:
	MOV AL,[SI] ;���������ӵ�λ����
INC SI
MUL BL
AAM;�˷���ASCII����,AX�д�ŷ�ѹ���˻����˻��ĵ�λ��AL����λ��AH
ADD AL,DL ;���Ͻ�λ
AAA ;���ӷ���ASCII�������ѿ��ܵĽ�λ�ӵ�AH��
MOV DL,AH;��λ���λ�Ľ�λҪ������
ADD AL,30H;ASCII�����ַ��ķ�Χ��30H(0)~39H(9)
MOV [DI],AL ;��λ����Ŀ�Ĵ洢��Ԫ
DEC DI
LOOP NEXT
	ADD AH,30H;��ʱ���Ѿ������ĸ�λ�ˣ�Ҫ��30H���ӷ�ѹ��BCD��ת����ASCII��
	MOV [DI],AH;��ʱDI�Ѿ�ָ�����λ
	CMP AH,30H
	JNE LAST
	INC DI ;�����λΪ0.�Ӵθ�λ��ʼ��������Ҫô��5λҪô��6λ��
LAST:
	MOV DX,DI; �ַ�������ַ�ŵ�DX��׼�����
	MOV AH,9 ;��������ַ����Ĺ���
	INT 21H;����ַ���
	MOV AH,4CH
	INT 21H
CODE 	ENDS
		END GO

