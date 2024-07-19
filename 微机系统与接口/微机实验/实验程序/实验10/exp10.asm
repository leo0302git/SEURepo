DATA SEGMENT
    OKSTR DB 'OK!',0DH,0AH,'$'
    TIME DB 00H
    NINE EQU 9
DATA ENDS;TIME是按键次数
STACK  SEGMENT
	DW 200H DUP(?)
STACK ENDS
CODE SEGMENT 
    ASSUME CS:CODE,DS:DATA,SS:STACK
DELAY PROC         ; 延时程序
    PUSH CX
    PUSH DX
    MOV DX,36H
DL500:
    MOV CX, 0FFFFH
DL10MS:
    LOOP DL10MS
    DEC DX
    JNZ DL500
    POP DX
    POP CX    
    RET
DELAY ENDP

DELAY2 PROC         ; 延时程序2,用于显示OK时的延时，略短于1秒
    PUSH CX
    PUSH DX
    MOV DX,67H
DL5002:
    MOV CX, 01FFFH
DL10MS2:
    LOOP DL10MS2
    DEC DX
    JNZ DL5002
    POP DX
    POP CX    
    RET
DELAY2 ENDP
DISP1 PROC FAR     ; 显示太阳
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AH,15     ; 读当前显示状态
    INT 10H
    MOV AH,0      ; 设置显示方式
    INT 10H
    MOV DX,0      ; 行号为0，列号为0
REPT: 
    MOV AH,2      ; 设置光标位置
    INT 10H  
    MOV AL,0FH    ; OFH是太阳图形的ASCII码
    MOV CX,1      ; 重复字符的次数
    MOV AH,10     ; 写字符
    INT 10H
    CALL DELAY
    SUB AL,AL
    MOV AH,0      ; 清除原图形
    INT 10H
    INC DH        ; 行号+1
    ADD DL,2      ; 列号+2
    CMP DH,20     ; 判断是否到20行，不等继续显示太阳，相等返回，如果到25行再返回，会导致轨迹不是严格对角
    JNE REPT
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DISP1 ENDP
DISP2 PROC FAR    ; 显示OK
    PUSH CX
    PUSH BX
    PUSH AX
    MOV CX,3;待显示的字符数
NEXTC: 
    LODSB  ; 字符串"OK!"在数据段中定义，AL<—[SI]
    MOV AH, 0EH ; 用teletype格式写字符，并移动光标
    MOV BX,1
    INT 10H
    CALL DELAY2
    LOOP NEXTC
    POP AX
    POP BX
    POP CX
    RET
DISP2 ENDP

KEYINT PROC FAR 
    PUSH AX
    PUSH BX 
    PUSH DX 
    STI 
    IN AL,60H      ; 通过8255A的PA口(PA口地址为60H)读取键盘扫描码
    MOV AH,AL
    IN AL,61H      ; 从8255APB口(PB口地址为61H)的PB7输出一个正脉冲
    OR AL,80H      ; PB7置1
    OUT 61H,AL
    AND AL,7FH      ; PB7清零
    OUT 61H,AL     ;再输出一个负脉冲
    TEST AH,80H    ; 相等时代表键被释放，开中断，显示字符
    JNE BACK         ; 不等，中断结束返回
    STI  
    INC TIME 
    MOV SI,OFFSET OKSTR   ; 初始化SI，在DISP2中不再对SI进行初始化
    CALL DISP2
BACK:
    MOV AL,20H
    OUT 20H,AL
    POP DX
    POP BX
    POP AX
    IRET 
    KEYINT ENDP 
START:
    MOV AX,DATA 
    MOV DS,AX 
    MOV AX,STACK
    MOV SS,AX
    MOV AX,0
    MOV ES,AX
    MOV SI,OFFSET OKSTR
    MOV AX,ES:[24H]   ; 9*4=24H,压入中断向量的偏移地址
    PUSH AX
    MOV AX,ES:[26H]   ;压入中断向量的段地址
    PUSH AX
    CLI;关中断，载入自定义中断子程序地址时不允许中断
    MOV AX,SEG KEYINT 
    MOV ES:[26H],AX 
    MOV AX,OFFSET KEYINT
    MOV ES:[24H],AX
    STI
AGIN:
    CALL DISP1
    CMP TIME,10
    JB AGIN 
    CLI               ; 禁止下方程序中断发生，保护代码运行
    POP AX
    MOV ES:[26H],AX;弹出原中断向量的段地址
    POP AX
    MOV ES:[24H],AX;弹出原中断向量的偏移地址
    STI               ; 开中断
    MOV AH,4CH
    INT 21H
CODE ENDS
END START 

