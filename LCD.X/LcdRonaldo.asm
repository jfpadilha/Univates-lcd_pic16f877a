; PIC16F877A Configuration Bit Settings

; ASM source line config statements

#include "p16f877a.inc"

; CONFIG
; __config 0xFFBA
 __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _BOREN_OFF & _LVP_ON & _CPD_OFF & _WRT_OFF & _CP_OFF

#define BANCO0   bcf STATUS, RP0
#define BANCO1   bsf STATUS, RP0


 CBLOCK 20h
 contador
 contador2
 endc

 org 0

    BANCO1

    movlw 0
    movwf TRISD         ; Porta D é saida

    movlw b'11101100'   ; PSPMODE=0 para porta D ser I/O
    movwf TRISE         ; Bits 0 e 1 da porta E sao saidas

    movlw b'00001110'   ; Pinos configurados como digitais
    movwf ADCON1

    BANCO0

    call  inicia_lcd

    movlw 'A'
    call  escreve_dado_lcd
    movlw 'B'
    call  escreve_dado_lcd
    movlw 'C'
    call  escreve_dado_lcd

    goto  $              ; Trava programa

inicia_lcd
    movlw 38h
    call  escreve_comando_lcd
    movlw 38h
    call  escreve_comando_lcd
    movlw 38h
    call  escreve_comando_lcd
    movlw 0Ch
    call  escreve_comando_lcd
    movlw 06h
    call  escreve_comando_lcd
    movlw 01h
    call  escreve_comando_lcd
    call  atraso_limpa_lcd
    return

escreve_comando_lcd
    bcf   PORTE, RE0    ; Define comando no LCD (RS=0)
    movwf PORTD
    bsf   PORTE, RE1     ; Ativa ENABLE do LCD
    bcf   PORTE, RE1     ; Desativa ENABLE do LCD
    call  atraso_lcd
    return

escreve_dado_lcd
    bsf   PORTE, RE0    ; Define dado no LCD (RS=1)
    movwf PORTD
    bsf   PORTE, RE1     ; Ativa ENABLE do LCD
    bcf   PORTE, RE1     ; Desativa ENABLE do LCD
    call  atraso_lcd
    return

atraso_lcd                 ; Atraso de 40us para LCD
    movlw 26               ; 8 clocks
    movwf contador         ; 4 clocks
ret_atraso_lcd
    decfsz contador        ; 8 clocks
    goto ret_atraso_lcd    ; 4 clocks
    return

atraso_limpa_lcd
    movlw 40
    movwf contador2
ret_atraso_limpa_lcd
    call atraso_lcd
    decfsz contador2
    goto ret_atraso_limpa_lcd
    return

 end



