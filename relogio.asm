                             data segment         
   
    ENTRY_SEGUNDOS DB Digite os segundos $,0

    LINHA  DB 
    COLUNA DB 
    DIGITO DB                
    DIGITO_UNI DB 
    DIGITO_DEZ DB 
    MINUTOS DB 
    SEGUNDOS DB      
    ENTRY_MINUTOS DB Digite os minutos $,0

    



ZERO   DB     ____   ,10
       DB     __   ,10
       DB        ,10
       DB   _    ,10 
       DB  ____    ,0
   
UM     DB    ___     ,10
       DB          ,10
       DB          ,10 
       DB          ,10  
       DB _        , 0
   

DOIS   DB    ___     ,10    
       DB   __     ,10
       DB   __     ,10
       DB   __     ,10 
       DB ____     ,0  
       
TRES   DB    _____   ,10
       DB   __     ,10
       DB   _      ,10 
       DB  ___     ,10 
       DB ____     ,0  
       
   
QUATRO DB     __ __  , 10
       DB        , 10
       DB     _  , 10
       DB  __  __  , 10
       DB    _     , 0
       
   
CINCO  DB    ______  , 10
       DB    ____  , 10
       DB  ___     , 10
       DB  ____    , 10
       DB _____    , 0 
       
   
SEIS  DB     _____   , 10
      DB     ___   , 10
      DB    __     , 10
      DB   _     , 10
      DB  ____     , 0
   
SETE  DB    ___      , 10
      DB   _       , 10
      DB           , 10
      DB           , 10
      DB  _        , 0
   
OITO  DB   _ _       , 10
      DB  ( _ )      , 10
      DB   _       , 10
      DB  (_)      , 10
      DB  ___      , 0   
       
   
NOVE  DB    ____     , 10
      DB    __     , 10
      DB   _     , 10
      DB  __,      , 10
      DB ____      , 0

PONTOS  DB           , 10
        DB         , 10
        DB           , 10
        DB         , 10
        DB           , 0
ENDS             
ENDS             
                 
stack SEGMENT
    dw   128  dup(0)
ENDS

code SEGMENT
start

    MOV AX, data
    MOV DS, AX
    MOV DS, AX
    
    
    LEA SI,ENTRY_MINUTOS  
    CALL IMPRIMINDO
            
     ; Pega dezena do minuto
    MOV AH,08H 
    INT 21H 
   
    ADD AL, -30h
    MOV MINUTOS, AL

    MOV AL, MINUTOS
    MOV DL, 10
    MUL DL
    MOV MINUTOS, AL
   
    MOV AH,08H 
    INT 21H 
   
    ADD AL, -30h
    ADD AL, MINUTOS
    MOV MINUTOS, AL
    
     
    LEA SI,ENTRY_SEGUNDOS
  
    MOV AH,09H 
    INT 21H
    ; Pega dezena do segundo
    MOV AH,08H 
    INT 21H 
   
    ADD AL, -30h
    MOV SEGUNDOS, AL

    MOV SEGUNDOS, AL
    MOV AL, SEGUNDOS
    MOV DL, 10
    MUL DL
    MOV SEGUNDOS, AL
   
    MOV AH,08H 
    INT 21H 
   
    ADD AL, -30h
    ADD AL, SEGUNDOS
    MOV SEGUNDOS, AL
    
    
    
    INT 10H
    ;DESLIGA CURSOR
   

MOSTRANDO
    CALL MINHA_INTERRUPCAO
    
   ;IMPRIME DEZ SS
    MOV AH,0
    MOV AL,SEGUNDOS 
    MOV BL,10
    DIV BL
    MOV DIGITO_DEZ, AL
    MOV DIGITO_UNI, AH

    MOV AL,DIGITO_DEZ
    MOV DIGITO,AL
    MOV LINHA,  5
    MOV COLUNA, 35
    CALL IMPRIME_DIGITO                             
               
   ;IMPRIME UNID SS           
    MOV AL,DIGITO_UNI
    MOV DIGITO,AL
    MOV LINHA,  5
    MOV COLUNA, 45
    CALL IMPRIME_DIGITO                          
                  
                  
    MOV LINHA,  5
    MOV COLUNA, 25
    CALL MOVER_DOIS_PONTOS

   ;CL TEM SEGUNDOS             
    MOV AH,0
    MOV AL, MINUTOS 
    MOV BL,10
    DIV BL
    MOV DIGITO_DEZ, AL
    MOV DIGITO_UNI, AH
                  
   ;IMPRIME DEZ MM
    MOV AL,DIGITO_DEZ
    MOV DIGITO,AL
    MOV LINHA,  5
    MOV COLUNA, 5
    CALL IMPRIME_DIGITO                             
               
   ;IMPRIME UNID MM           
    MOV AL,DIGITO_UNI
    MOV DIGITO,AL
    MOV LINHA,  5
    MOV COLUNA, 15
    CALL IMPRIME_DIGITO

                                 
    CALL DELAY
    JMP MOSTRANDO
   
    MOV AX, 4c00h
    INT 21h   

IMPRIME_DIGITO
    CMP DIGITO,0
    JE MOVER_ZERO
    CMP DIGITO,1
    JE MOVER_UM
    CMP DIGITO,2
    JE MOVER_DOIS
    CMP DIGITO,3
    JE MOVER_TRES
    CMP DIGITO,4
    JE MOVER_QUATRO
    CMP DIGITO,5
    JE MOVER_CINCO
    CMP DIGITO,6
    JE MOVER_SEIS
    CMP DIGITO,7
    JE MOVER_SETE
    CMP DIGITO,8
    JE MOVER_OITO
    CMP DIGITO,9
    JE MOVER_NOVE


DELAY   
  MOV CX, 7      
  MOV DX, 0A120h
  MOV AH, 86h
  INT 15h
  RET

CLRSCR    
    PUSHF
    PUSH SI 
    PUSH AX
    PUSH BX
    PUSH DX
    MOV SI,0 ; APONTA PARA OFFSET 0
CLRSCR_APAGANDO
    MOV ES[SI], 
    MOV ES[SI+1],0FH
    ADD SI,2
    CMP SI,25160    ; 25 LINHAS POR 280 COLUNAS 
    JE  SAI_CLRSCR
    JMP CLRSCR_APAGANDO
SAI_CLRSCR
;AH=02h	BH = Page Number, DH = Row, DL = Column
    MOV AH,2 ; POSICIONA CURSOR
    MOV BH,0
    MOV DH,0 ; LINHA
    MOV DL,0 ; COLUNA          
    INT 10H
    POP DX
    POP BX
    POP AX
    POP SI
    POPF
    RET

MINHA_INTERRUPCAO
	PUSHF
	INC SEGUNDOS ; INCREMENTA SEGUNDOS
	CMP SEGUNDOS,60 ; CHEGOU EM 60 SEGUNDOS
	JNE SAI_MINHA_INTERRUPCAO ; JMP IF NOT EQUAL
	MOV SEGUNDOS,0;  SIM, CHEGOU, ENTAO ZERO SSS
	INC MINUTOS; INCREMENTA MINUTOS
	CMP MINUTOS,60; CHEGAMOS EM 60 MINUTOS
	JNE SAI_MINHA_INTERRUPCAO
	MOV MINUTOS,0; ZERE MINUTOS
	JNE SAI_MINHA_INTERRUPCAO
SAI_MINHA_INTERRUPCAO
		POPF
		RET

MOVER_DOIS_PONTOS
    LEA SI, PONTOS
    JMP IMPRIMINDO

MOVER_ZERO
    LEA SI, ZERO
    JMP IMPRIMINDO
MOVER_UM
    LEA SI, UM
    JMP IMPRIMINDO
MOVER_DOIS
    LEA SI, DOIS
    JMP IMPRIMINDO
MOVER_TRES
    LEA SI, TRES
    JMP IMPRIMINDO
MOVER_QUATRO
    LEA SI, QUATRO
    JMP IMPRIMINDO
MOVER_CINCO
    LEA SI, CINCO
    JMP IMPRIMINDO
MOVER_SEIS
    LEA SI, SEIS
    JMP IMPRIMINDO
MOVER_SETE
    LEA SI, SETE
    JMP IMPRIMINDO                  
MOVER_OITO
    LEA SI, OITO
    JMP IMPRIMINDO
MOVER_NOVE
    LEA SI, NOVE
    JMP IMPRIMINDO

IMPRIMINDO
    ; POSICIONA CURSOR
    MOV AH,2
    MOV BH,0
    MOV DH, LINHA
    MOV DL, COLUNA   
    INT 10H     

PROCURA_FIM
    MOV DL,ds[SI]
    CMP DL,0
    JE FIM_IMPRESSAO
    CMP DL,10
    JE PULA_LINHA
    MOV AH,2     
    INT 21h       
    INC SI
    JMP PROCURA_FIM
   
PULA_LINHA
   
    INC byte ptr linha
    INC SI
    JMP IMPRIMINDO
                   
FIM_IMPRESSAO
    RET                   
                   
ENDS

end start