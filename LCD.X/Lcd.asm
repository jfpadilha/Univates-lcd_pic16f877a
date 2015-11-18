    #include "p16f877a.inc"
    
    #define BANK_1 bsf STATUS, RP0 ;ir para banco 1 (setar rp0)
    #define BANK_0 bcf STATUS, RP0 ;ir para banco 1 (setar rp0)  

    ; CONFIG
    ; __config 0xFFBA
        __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _BOREN_OFF & _LVP_ON & _CPD_OFF & _WRT_OFF & _CP_OFF

     ;------| CONFIGURACAO DOS REGISTRADORES 
        CBLOCK 20h                      ;para criar registradores
        contador
        contador2
        ENDC                            ;fechar o CBLOCK

    ;--------| CONFIGURACAO 
        org 0
        BANK_1
        movlw 0                    ;ativar o TRISD como saida (valor literal)
        movwf TRISD                ;porta D agora é saida

        movlw b'11101100'          ;I: PINMODE=0 para porta D ser I/0 (o primeiro 0 pra nao colocar a porta D paralela)
        movwf TRISE                ;bit 0 a 1 da porta E sao saidas

        movlw b'00001110'          ;pinos configurados para sinal digital
        movwf ADCON1

    ;--------| MENSAGEM QUE SERA MOSTRADA NO LCD
        BANK_0
        call INICIA_LCD        
        movlw 'A'
        call ESCREVE_DADO_LCD        
        movlw 'B'
        call ESCREVE_DADO_LCD
        movlw 'C'
        call ESCREVE_DADO_LCD
        movlw 'D'
        call ESCREVE_DADO_LCD        
        goto $                       ;finalizar o programa (JMP)

    ;--------| COMANDOS PROCESSAMENTO LCD
    INICIA_LCD
        movlw 38h
        call ESCREVE_COMANDO_LCD        
        movlw 38h        
        call ESCREVE_COMANDO_LCD
        movlw 38h
        call ESCREVE_COMANDO_LCD         
        movlw 0Ch
        call ESCREVE_COMANDO_LCD
        movlw 06h
        call ESCREVE_COMANDO_LCD
        movlw 01h
        call ESCREVE_COMANDO_LCD
        call ATRASO_LCD
        return

    ESCREVE_COMANDO_LCD
        bcf PORTE, RE0              ; Define dado no LCD(RS=1)
        movwf PORTD
        bsf PORTE, RE1             ;ativa ENABLE do LCD
        bcf PORTE, RE1             ;desativa ENABLE LCD (disable)
        call ATRASO_LCD 
        return 
        
    ESCREVE_DADO_LCD
        bsf PORTE, RE0              ;Define dado no LCD(RS=1)
        movwf PORTD
        bsf PORTE, RE0             ;define dado no LCD
        bsf PORTE, RE1             ;ativa ENABLE do LCD
        bcf PORTE, RE1             ;desativa ENABLE LCD (disable)    
        call ATRASO_LCD
        return
        
    ATRASO_LCD                      ;Atraso de 40us para LCD
        movlw 26                    ;8 começa em 8 clocks o resto é 4
        movwf contador

    RET_ATRASO_LCD
        decfsz contador             ;8 clocks (porque fez salto)
        goto RET_ATRASO_LCD         ;4 clocks

    ATRASO_LIMPA_LCD
        movlw 40
        movwf contador2

    RET_ATRASO_LIMPA_LCD
        call ATRASO_LCD
        decfsz contador2             ;8 clocks (porque fez salto)
        goto RET_ATRASO_LIMPA_LCD       ;4 clocks
        return
        
    end


