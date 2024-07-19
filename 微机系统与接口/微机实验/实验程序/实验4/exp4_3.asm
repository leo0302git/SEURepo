;时钟实验
DATA SEGMENT
    TIME DB 9 
         DB ?
         DB 9 DUP(0)
    D2 DB 0DH,'$';0D是光标移到行首，0A是换行
    D3 DB 0AH,'$'
    ERRINFO1 DB 0AH,'WRONG INFO 1:INPUT NOT NUMBER OR COLON',0DH,0AH,'$'
    ERRINFO2 DB 0AH,'WRONG INFO 2:INPUT TIME UNREASONABLE',0DH,0AH,'$'
    RETYPEINFO DB 'INPUT AGAIN:',0DH,0AH,'$'
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
    MOV SI,OFFSET TIME 
    MOV AL,0
    MOV [SI+10],AL 
    CALL CHECK ;检查输入是否错误，提示错误信息，若错误，重新输入时间初值
NEXT:
    CALL ATOB
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

ATOB PROC 
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
    RET ;不加RET会继续执行下面的DELAY
    ATOB ENDP

DELAY PROC
    PUSH CX
    PUSH DX
    PUSH AX
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

CHECK PROC ;检查输入是否错误，提示错误信息，若错误，重新输入时间初值
    ;错误信息1：输入的时间不是数字或冒号
    ;错误信息2：输入的时间不符合实际
    ;SI已经指向TIME首址
    ;用ASCII码检查是不是数字或冒号
    PUSH CX
    PUSH AX
    PUSH DX
    PUSH BX
    MOV CX,8
    MOV BX,SI
    ADD BX,1
AGIN:
    MOV AX,SI
    ADD AX,4;AX用来指示冒号的位置
    INC BX;第一次循环开始时，BX(=SI+2)指到第一个字符,BX始终指向想要比较的字符
    CMP BX,AX;SI+4和SI+7指到冒号
    JZ CHECKCOLON
    ADD AX,3
    CMP BX,AX
    JZ CHECKCOLON   
    JMP CHECKNUM 
CHECKCOLON:
    CMP BYTE PTR [BX],':'
    JNZ WRONG1
    LOOP AGIN
CHECKNUM:
    ;AX不能用来存放偏移地址
    CMP BYTE PTR [BX],30H 
    JB WRONG1 
    CMP BYTE PTR [BX],39H
    JA WRONG1 
    LOOP AGIN 
    ;下面检查输入时间是否合理
    CALL ATOB ;时分秒信息已经转换为BCD放到CH,DH,DL
    CMP CH,23H
    JA WRONG2 
    CMP DH,60H
    JA WRONG2 
    CMP DL,60H
    JA WRONG2 
    JMP OVER ;不加这一句，无论如何都会执行WRONG1
WRONG1:
    MOV DX,OFFSET ERRINFO1
    MOV AH,9
    INT 21H
    JMP RETYPE
WRONG2:
    MOV DX,OFFSET ERRINFO2
    MOV AH,9
    INT 21H
    JMP RETYPE
RETYPE:
    MOV DX,OFFSET RETYPEINFO
    MOV AH,9
    INT 21H
    LEA DX,TIME;让用户输入时间XX:XX:XX
    MOV AH,0AH
    INT 21H
    CALL CHECK
OVER:
    POP BX
    POP DX
    POP AX
    POP CX 
    RET 
    CHECK ENDP
CODE ENDS
    END START 


