DATA SEGMENT
    TIME DB 00H
    SHOWTIME DB 00H
    OKSTR DB 'OK!ZJC',20H
    N EQU $-SHOWTIME
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
    MOV CX, 03FFFH
DL10MS:
    LOOP DL10MS
    DEC DX
    JNZ DL500
    POP DX
    POP CX    
    RET
DELAY ENDP

DELAY2 PROC         ; 延时程序2
    PUSH CX
    PUSH DX
    MOV DX,16H
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
    MOV AL,0FH    ; OFH一太阳图形的ASCII码
    MOV CX,1      ; 显示字符个数
    MOV AH,10     ; 写字符
    INT 10H
    CALL DELAY
    SUB AL,AL
    MOV AH,0      ; 清除原图形
    INT 10H
    INC DH        ; 行号+1
    ADD DL,2      ; 列号+2
    CMP DH,20     ; 判断是否到20行，不等继续显示太阳，相等返回
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
    MOV CX,N
NEXTC: 
    LODSB  ; 字符串在数据段中定义，AL<—[SI]
    MOV AH, 0EH   ; 写字符， 并移动光标
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
    IN AL,60H      ; 通过8255A的PA口(PA口地址为60H）读取键盘扫描码
  	MOV AH,AL
    IN AL,61H      ; 从8255APB口(PB口地址为61H）的PB7输出一个正脉冲（即PB7先输出高电平，再输出低电平）
    OR AL,80H      ; PB7置1
    OUT 61H,AL
    AND AL,7FH
    OUT 61H,AL     ; PB7清零
    TEST AH,80H    ; 相等时代表键被释放，开中断，显示字符
    JNE BACK         ; 不等，中断结束返回
    STI  
    INC TIME 
    MOV AL,0
    ADD AL,TIME 
    OR AL,30H
    MOV SI,OFFSET SHOWTIME   ; 初始化SI，在DISP2中不再对SI进行初始化
    MOV [SI],AL
    CALL DISP2
    JAE QUIT;达到预设的按键次数直接退出
QUIT:
    MOV AL,20H
    OUT 20H,AL
    POP DX
    POP BX
    POP AX
    IRET 
BACK:
    MOV AL,20H
    OUT 20H,AL
    POP DX
    POP BX
    POP AX
    IRET 
    KEYINT ENDP 
;INT 21H 25H号：设置中断向量，入口DS:DX=中断向量，AL=中断类型号
;INT 21H 35H号：取中断向量，入口AL=中断类型，出口ES:BX=中断向量
    

START:
    MOV AX,DATA 
    MOV DS,AX 
    MOV AX,STACK
    MOV SS,AX
    MOV AX,0
    MOV ES,AX
    MOV SI,OFFSET TIME
    MOV CX,1;CX用来记忆循环次数，最多循环25次，即太阳循环显示一遍
    MOV AX,ES:[24H]   ; 压入中断向量的偏移地址
    PUSH AX
    MOV AX,ES:[26H]   ;压入中断向量的段地址
    PUSH AX
    CLI
    MOV AX,SEG KEYINT 
    MOV ES:[26H],AX 
    MOV AX,OFFSET KEYINT
    MOV ES:[24H],AX
    STI
AGIN:
    CALL DISP1
    CMP TIME,NINE
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

