;时钟实验
DATA SEGMENT
    TIME DB 9 
         DB ?
         DB 9 DUP(0)
    D2 DB 0DH,'$';0D是光标移到行首，0A是换行
    D3 DB 0AH,'$'
DATA ENDS
CODE SEGMENT
    ASSUME DS:DATA,CS:CODE 
START:
    MOV AX,DATA
    MOV DS,AX
    MOV AH,2;显示冒号
    MOV DL,':'
    INT 21H
    MOV DX,OFFSET D3 
    MOV AH,9
    INT 21H    
    LEA DX,TIME;让用户输入时间XX:XX:XX
    MOV AH,0AH
    INT 21H
    MOV SI,OFFSET TIME ;ASCII TO BCD
    MOV AL,0
    MOV [SI+10],AL 
NEXT:
    MOV CH,[SI+2];HOUR(ASCII)
    AND CH,0FH 
    MOV CL,4 
    SHL CH,CL 
    MOV BL,[SI+3]
    AND BL,0FH 
    ADD CH,BL 
    MOV DH,[SI+5];MINUTE(ASCII)
    AND DH,0FH 
    SHL DH,CL 
    MOV BL,[SI+6]
    AND BL,0FH 
    ADD DH,BL 
    MOV DL,[SI+8];SECEND(ASCII)
    AND DL,0FH 
    SHL DL,CL 
    MOV BL,[SI+9]
    AND BL,0FH 
    ADD DL,BL 
    CALL DELAY 
    MOV AL,DL ;秒增1!!!dl
    ADD AL,1
    DAA 
    MOV DL,AL
    CMP DL,60H
    JNZ SHOW 
    MOV DL,00H ;秒置零
    MOV AL,DH 
    ADD AL,1 ;分钟加一
    DAA 
    MOV DH,AL 
    CMP DH,60H
    JNZ SHOW 
    MOV DH,00H;分钟置零
    MOV AL,CH;小时+1
    ADD AL,1
    DAA 
    MOV CH,AL 
    CMP CH,24H 
    JNZ SHOW 
    MOV CH,00H
    JMP SHOW
SHOW:
    MOV CL,4
    MOV AX,0000H;小时从BCD转换为ASCII并存到缓冲区
    MOV AL,CH 
    SHL AX,CL 
    SHR AL,CL 
    OR AX,3030H
    XCHG AH,AL
    MOV [SI+2],AX 
    MOV AX,0000H;分钟从BCD转换为ASCII并存到缓冲区
    MOV AL,DH 
    SHL AX,CL 
    SHR AL,CL 
    OR AX,3030H
    XCHG AH,AL
    MOV [SI+5],AX 
    MOV AX,0000H;秒从BCD转换为ASCII并存到缓冲区
    MOV AL,DL 
    SHL AX,CL 
    SHR AL,CL 
    OR AX,3030H
    XCHG AH,AL
    MOV [SI+8],AX 
    MOV DX,OFFSET TIME;输出到屏幕
    ADD DX,2
    MOV AH,9
    INT 21H
    MOV AH,06;检查是否有键按下
    MOV DL,0FFH 
    INT 21H
    JNZ EXIT
    JMP NEXT
EXIT:
    MOV AH,4CH ;若有键按下，结束程序
    INT 21H

DELAY PROC
    PUSH CX
    PUSH DX
    PUSH AX
    MOV DX,0000
    MOV CX,0000
    MOV AH,2DH;设置时间为12:34:56 00ms
    INT 21H
    MOV AH,2CH;读取时间DH得到秒
    INT 21H
    MOV AL,DH 
    ADD AL,1;AL表示下一秒
READTIME:
    MOV AH,2CH;读取时间DH得到秒
    INT 21H
    CMP DH,AL
    JNZ READTIME;若不等于下一秒，则再读取时间;若相等，则结束延时
    POP AX
    POP DX
    POP CX
    RET
    DELAY ENDP
CODE ENDS
    END START 


