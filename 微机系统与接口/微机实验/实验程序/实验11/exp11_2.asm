; INT 10H 不同功能号的作用
; https://www.itzhai.com/assembly-int-10h-description.html#:~:text=%E6%B1%87%E7%BC%96%E4%B8%AD%E7%9A%8410H%E4%B8%AD%E6%96%ADint%2010h%E8%AF%A6%E7%BB%86%E8%AF%B4%E6%98%8E%20%E5%8F%91%E5%B8%83%E4%BA%8E%202011-05-01%20%7C%20%E6%9B%B4%E6%96%B0%E4%BA%8E%202020-09-20%20%E6%B1%87%E7%BC%96%E8%AF%AD%E8%A8%80,5%20%E6%B1%87%E7%BC%96%E4%B8%AD%E7%9A%8410H%E4%B8%AD%E6%96%AD%E6%98%AF%E7%94%B1BIOS%E5%AF%B9%E6%98%BE%E7%A4%BA%E5%99%A8%E5%92%8C%E5%B1%8F%E5%B9%95%E6%89%80%E6%8F%90%E4%BE%9B%E7%9A%84%E6%9C%8D%E5%8A%A1%E7%A8%8B%E5%BA%8F%E3%80%82%20%E4%BD%BF%E7%94%A8int%2010h%E6%9C%8D%E5%8A%A1%E7%A8%8B%E5%BA%8F%E6%97%B6%EF%BC%8C%E5%BF%85%E9%A1%BB%E5%85%88%E6%8C%87%E5%AE%9Aah%E5%AF%84%E5%AD%98%E5%99%A8%E4%B8%BA%E4%BB%A5%E4%B8%8B%E6%98%BE%E7%A4%BA%E6%9C%8D%E5%8A%A1%E7%BC%96%E5%8F%B7%E4%B9%8B%E4%B8%80%EF%BC%8C%E4%BB%A5%E6%8C%87%E5%AE%9A%E9%9C%80%E8%A6%81%E8%B0%83%E7%94%A8%E7%9A%84%E5%8A%9F%E7%94%A8%E3%80%82%20%E6%98%BE%E7%A4%BA%E6%9C%8D%E5%8A%A1%20%28Video%20Service%EF%BC%9Aint%2010h%29
;颜色搭配表 https://blog.csdn.net/qq_40818798/article/details/83933827
;在第六次定时中断之后，太阳停留在左上角不动(主程序跳转逻辑不对)
;同一个段内的程序子段名不能一样(NEXT和NEXTC)
;在一个中断正在处理时，另一个中断不能进入
DATA SEGMENT
    TIMERTIME DB 00H
    SHOWTIMERTIME DB 00H,00H;SHOWTIMERTIME存放TIMERTIME对应的ASCII码
    STR1 DB 'TIMERINT!',20H
    N1 EQU $-SHOWTIMERTIME
    KEYTIME DB 00H
    SHOWKEYTIME DB 01H,00H;SHOWKEYTIME存放KEYTIME对应的ASCII码
    STR2 DB 'KEYINT!',20H
    N2 EQU $-SHOWKEYTIME
    COUNT1 DB N1;COUNT1用于记定时中断累计次数，便于直接中断而不用等本次太阳循环结束
    COUNT2 DB N2;COUNT2用于记键盘中断累计次数，便于直接中断而不用等本次太阳循环结束
    TWELVE EQU 12;定义数值常量便于调试
    FIFTY EQU 36;一秒调用18.2次定时中断，据此计算
    ;定时0.5秒=9次，1s=18次，2秒=36次
    COUNTER DB FIFTY
DATA ENDS
CODE SEGMENT 
    ASSUME CS:CODE,DS:DATA
DELAY PROC         ; 延时程序
    PUSH CX
    PUSH DX
    MOV DX,36H
DL500:
    MOV CX, 08FFFH
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
    MOV DX,1CH
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
    MOV AL,1
    MOV AH,0      ; 设置显示方式
    INT 10H
    MOV DX,0      ; 行号为0，列号为0
REPT: 
    MOV AH,2      ; 设置光标位置
    INT 10H  
    MOV AL,0FH    ; OFH是太阳图形的ASCII码
    MOV CX,1      ; 重复字符的次数
    MOV BL,0E4H    ;字符颜色信息为橙底红字加闪烁（b7控制字符是否闪烁，b6-b4为背景色，b3-b0为前景色）
    MOV AH,9       ; 写字符
    INT 10H
    CALL DELAY
    SUB AL,AL
    MOV AH,0      ; 清除原图形
    INT 10H
    CMP KEYTIME,TWELVE;当键盘中断次数达到设定值时，直接结束显示
    JAE QUIT1 
    CMP TIMERTIME,TWELVE;当定时中断次数达到设定值时，直接结束显示
    JAE QUIT1 
    INC DH        ; 行号+1
    ADD DL,2      ; 列号+2
    CMP DH,20     ; 判断是否到20行，不等则继续显示太阳，相等返回
    JNE REPT
QUIT1:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DISP1 ENDP

INT_DISP1 PROC FAR    ; 定时中断显示信息
    PUSH DX
    PUSH CX
    PUSH BX
    PUSH AX
    PUSH SI
    MOV COUNT1,N1;用待显示的字符串的长度更新COUNT1
NEXTC: 
    LODSB  ; 字符串在数据段中定义并已经由SI指向首址
    MOV BH,00H
    MOV AH,03H
    INT 10H 
    MOV AH,9   ;写字符
    MOV CX,1      ;重复一次
    MOV BL,35H    ;字符颜色信息为青底紫字（b7控制字符是否闪烁，b6-b4为背景色，b3-b0为前景色）
    INT 10H
    INC DL ;每打印1个字符，光标的列号+1
    MOV AH,2      ; 更新光标位置
    INT 10H 
    CALL DELAY2 
    DEC COUNT1  
    CMP COUNT1,0 ;当整个中断信息串都显示完，才退出循环
    JA NEXTC
    POP SI
    POP AX
    POP BX
    POP CX
    POP DX
    RET
INT_DISP1 ENDP

INT_DISP2 PROC FAR    ; 键盘中断显示信息
; INT 10H 中AH=03H读取光标信息。入口参数：BH＝显示页码
; 出口参数：CH＝光标的起始行 CL＝光标的终止行 DH＝行(Y坐标) DL＝列 (X坐标)
    PUSH DX
    PUSH CX
    PUSH BX
    PUSH AX
    PUSH SI
    MOV COUNT2,N2;用待显示的字符串的长度更新COUNT
NEXT: 
    LODSB  ; 字符串在数据段中定义并已经由SI指向首址
    MOV BH,00H
    MOV AH,03H
    INT 10H 
    MOV AH,9   ;写字符
    MOV CX,1      ;重复一次
    MOV BL,24H    ;字符颜色信息为绿底红字
    INT 10H
    INC DL ;每打印1个字符，光标的列号+1
    MOV AH,2      ; 更新光标位置
    INT 10H 
    CALL DELAY2 
    DEC COUNT2  
    CMP COUNT2,0 ;当整个中断信息串都显示完，才退出循环
    JA NEXT
    POP SI
    POP AX
    POP BX
    POP CX
    POP DX
    RET
INT_DISP2 ENDP

KEYINT PROC FAR 
    PUSH AX
    PUSH BX 
    PUSH DX 
    IN AL,60H      ; 通过8255A的PA口(PA口地址为60H)读取键盘扫描码
    MOV AH,AL
    IN AL,61H      ; 从8255APB口(PB口地址为61H)的PB7输出一个正脉冲（即PB7先输出高电平，再输出低电平）
    OR AL,80H      ; PB7置1
    OUT 61H,AL
    AND AL,7FH     ; PB7清零
    OUT 61H,AL     
    TEST AH,80H    ; 相等时代表键被释放，开中断，显示字符
    JNE BACK         
    STI  
    INC KEYTIME 
    MOV AX,0
    ADD AL,KEYTIME 
    AAA ;用于处理要显示的数字大于10的情况
    OR AX,3030H
    XCHG AL,AH
    MOV SI,OFFSET SHOWKEYTIME   ; 初始化SI,使其指向中断信息字符串首址
    MOV [SI],AX
    CLI 
    CALL INT_DISP2
    STI
BACK:
    MOV AL,20H
    OUT 20H,AL;结束中断
    POP DX
    POP BX
    POP AX
    IRET 
    KEYINT ENDP 

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
    MOV AX,FIFTY ;重置COUNTER
    MOV COUNTER,AX 
    INC TIMERTIME;TIMERTIME+1
    MOV AX,0
    ADD AL,TIMERTIME 
    AAA ;用于处理要显示的数字大于10的情况
    OR AX,3030H
    XCHG AL,AH
    MOV SI,OFFSET SHOWTIMERTIME   ; 初始化SI,使其指向中断信息字符串首址
    MOV [SI],AX
    CALL INT_DISP1
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
    ; MOV SI,OFFSET TIME
    MOV AH,35H ;INT 21H 35H号：取中断向量，入口AL=中断类型，出口ES:BX=中断向量
    MOV AL,9
    INT 21H 
    PUSH BX ;将原键盘中断处理程序的CS:IP压栈
    PUSH ES 
    MOV AH,35H 
    MOV AL,1CH
    INT 21H 
    PUSH BX ;将原定时中断处理程序的CS:IP压栈
    PUSH ES
    MOV AX,0 ;恢复ES!重要!
    MOV ES,AX
    PUSH DS ;保护DS与DX!重要!
    PUSH DX
    CLI
    MOV AX,SEG KEYINT ;将自定义键盘中断服务程序的地址放入原09号中断向量处
    MOV DS,AX
    MOV DX,OFFSET KEYINT
    MOV AL,9
    MOV AH,25H ;INT 21H 25H号：设置中断向量，入口DS:DX=中断向量，AL=中断类型号
    INT 21H
    MOV AX,SEG TIMERINT ;将自定义定时中断服务程序的地址放入原1CH号中断向量处
    MOV DS,AX
    MOV DX,OFFSET TIMERINT
    MOV AL,1CH
    MOV AH,25H 
    INT 21H
    STI
    POP DX 
    POP DS 
AGIN:
    CALL DISP1
    CMP TIMERTIME,TWELVE
    JAE EXIT
    CMP KEYTIME,TWELVE
    JAE EXIT 
    JMP AGIN
EXIT:
    CLI               ; 禁止下方程序中断发生，保护代码运行
    POP DS  ;恢复原1CH号中断向量
    POP DX
    MOV AL,1CH
    MOV AH,25H
    INT 21H
    POP DS  ;恢复原09号中断向量
    POP DX
    MOV AL,9
    MOV AH,25H
    INT 21H
    STI               ; 开中断
    MOV AH,4CH
    INT 21H
CODE ENDS
END START 

