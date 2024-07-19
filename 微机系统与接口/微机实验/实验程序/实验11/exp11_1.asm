;首次出错：忘记在每次显示SUN之后将TIME+1，导致每次太阳显示一轮之后就结束
;忘记重置SI，导致第2次及以后输出乱码而不是SUN
DATA SEGMENT
    STR DB 'SUN',0DH,0AH,'$'
    TIME DB 00H
    TEN EQU 10
    FIFTY EQU 50
    COUNTER DB 50
DATA ENDS;TIME是按键次数
CODE SEGMENT 
    ASSUME CS:CODE,DS:DATA
DELAY PROC         ; 延时程序
    PUSH CX
    PUSH DX
    MOV DX,16H
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

DELAY2 PROC         ; 延时程序2,用于显示SUN时的延时，略短于1秒
    PUSH CX
    PUSH DX
    MOV DX,27H
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

DISP1 PROC FAR     ; 显示太阳图标
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

DISP2 PROC FAR    ; 显示SUN
    PUSH CX
    PUSH BX
    PUSH AX
    MOV CX,3    ;待显示的字符数
NEXTC: 
    LODSB  ; 字符串"SUN"在数据段中定义，AL<—[SI]
    MOV AH, 0EH ; 用teletype格式写字符，并移动光标
    MOV BX,1
    INT 10H
    CALL DELAY2
    LOOP NEXTC
    MOV SI,OFFSET STR   ; 重置SI
    POP AX
    POP BX
    POP CX
    RET
DISP2 ENDP

TIMERINT PROC FAR 
    PUSH AX		 ;保存寄存器
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DS    
    STI                  ;开中断
    DEC COUNTER
    CMP COUNTER,0
    JNZ QUIT ;不等于0，则直接退出；等于零，则:显示SUN,重置COUNTER,TIME+1
    INC TIME
    MOV AX,FIFTY
    MOV COUNTER,AX 
    CALL DISP2 
QUIT:
    CLI                  ;关中断
    POP	DS
	POP	DX
	POP	CX
	POP	BX
    POP	AX		      ;恢复寄存器  
    IRET	              ;中断返回
TIMERINT ENDP
START:
    MOV AX,DATA 
    MOV DS,AX 
    MOV AX,STACK
    MOV SS,AX
    MOV AX,0
    MOV ES,AX
    MOV SI,OFFSET STR
    MOV AH,35H ;INT 21H 35H号：取中断向量，入口AL=中断类型，出口ES:BX=中断向量
    MOV AL,1CH
    INT 21H 
    PUSH BX ;将原中断处理程序的CS:IP压栈
    PUSH ES 
    MOV AX,0 ;恢复ES!重要!
    MOV ES,AX
    PUSH DS ;保护DS与DX!重要!
    PUSH DX
    CLI
    MOV AX,SEG TIMERINT ;将自定义中断服务程序的地址放入原1C号中断向量处
    MOV DS,AX
    MOV DX,OFFSET TIMERINT
    MOV AL,1CH
    MOV AH,25H ;INT 21H 25H号：设置中断向量，入口DS:DX=中断向量，AL=中断类型号
    INT 21H
    STI
    POP DX 
    POP DS 
AGIN:
    CALL DISP1
    CMP TIME,TEN
    JB AGIN 
    CLI               ; 禁止下方程序中断发生，保护代码运行
    POP DS  ;恢复原1C号中断向量
    POP DX
    MOV AL,1CH
    MOV AH,25H
    INT 21H
    STI               ; 开中断
    MOV AH,4CH
    INT 21H
CODE ENDS
END START 



