IDEAL
P386
;----------------------------------------------------------------------------
SEGMENT pila STACK 'STACK'
DB 1024 DUP(?)
ENDS
;----------------------------------------------------------------------------
SEGMENT datos USE32
ARCHIVO DB 15 DUP(?),'$' ;PICA2.BMP',0
ARCHIVO2 DB 'DOCU2.TXT',0
SALVE db 119 DUP (?),'$'
HANDLER DW ?
HANDLER2 DW ?
ANCHO DB 4 DUP (?)
ALTO DB 4 DUP (?)
PIXEL1 DB 0
PIXEL2 DB 0

TAMAÑO DB 4 DUP (?)

COLUMNA DW 50
FILA DW 100

ANCHO_NUM DW 0
ALTO_NUM DW 0

CONTENIDO DB 640 DUP (?) 

A0 DB '_','$'
A1 DB '@','$'
A2 DB '!','$'
A3 DB '#','$'
A4 DB '%','$'
A5 DB '&','$'
A6 DB '/','$'
A7 DB '?','$'
A8 DB '*','$'
A9 DB '+','$'
A10 DB '[','$'
A11 DB 'º','$'
A12 DB 'ª','$'
A13 DB '=','$'
A14 DB 'ç','$'
A15 DB '-','$'

CAMBIO DB 13,10,'$'

   etilin db "--------------------------------------------------------------------------------","$"
   ayuda db 'Usted ha entrado al centro de ayuda',10,13,'$'
   texto db 'Mostrar txt con el arte ASCII',10,13,'$'
   inversa  db 'Modo inverso',10,13,'$'
   izquierda   db    'Rotado a la izquierda',10,13,'$'
   derecha  db    'Rotado a la derecha',10,13,'$'
   nombrebmp   db    'Deberia ser el nombre de la imagen bmp...',10,13,'$'
    guardabmp   db  'Se guardo el nombre del bmp!!!',10,13,'$'
    ;archivo     db  15 DUP (?),'$'
    bmp1    db      4 DUP (?)

ENDS
;----------------------------------------------------------------------------
SEGMENT codigo USE16
ASSUME CS:CODIGO,DS:DATOS
;----------------------------------------------------------------------------
PROC RETORNADOS NEAR
      MOV AH,4CH
      MOV AL,0
      INT 21H
ENDP
;----------------------------------------------------------------------------
PROC LIMPIAR NEAR   
   MOV AX,0600H      ;AH = 06 (RECORRIDO), AL= 00 (PANTALLA COMPLETA)
   MOV BH,0AH        ;NEGRO =0 (FONDO), ROJO =2 (LETRAS)
   MOV CX,0000H      ;EMPEZAR DE ESQUINA SUPERIOR IZQUIERDA
   MOV DX,184FH      ;TERMINAR EN ESQUINA INFERIOR DERCHA
   INT 10H   
   RET
ENDP
;----------------------------------------------------------------------------
PROC VIDEO NEAR   
   MOV AH,00H      ;
   MOV AL,12H        ;0Ch     = modo gr fico 640x480

   INT 10H   
   RET
ENDP
;----------------------------------------------------------------------------
PROC DIVIDE2 NEAR
    PUSH BX
	PUSH DX
	
	MOV AX,[ANCHO_NUM]
	MOV BX,2
	MOV DX,0
    DIV BX
	MOV [ANCHO_NUM],AX
	

	POP DX
	POP BX



   RET
ENDP
;----------------------------------------------------------------------------
PROC CURSOR NEAR
   
   XOR CX,CX  ; EMPEZAR EN COLUMNA 0
   XOR BX,BX
   MOV SI,OFFSET CONTENIDO

@@CICLO2: 
  CALL IDENTIFICAR_PIXEL1
  CALL IDENTIFICAR_PIXEL2  
  INC CX
  INC BX
  INC SI
  CMP BX,[ANCHO_NUM]
  JBE @@CICLO2
  

@@FIN:
   RET
ENDP
;----------------------------------------------------------------------------
PROC CONVIERTE2 NEAR
    PUSH BX
	PUSH DX
	
	MOV BL,16
    DIV BL
	
	MOV [PIXEL1],AL
	MOV [PIXEL2],AH	
	
	POP DX
	POP BX
	  
	  
   RET
ENDP	  
;----------------------------------------------------------------------------
PROC IDENTIFICAR_PIXEL1 NEAR
   MOV AX,[SI]
   MOV AL,AH
   XOR AH,AH
   
   
    CMP AX,0
    JE @@NEGRO

	
   CALL CONVIERTE2
   
   CMP AL,01H
   JE @@AZUL
   CMP AL,02H
   JE @@VERDE
   CMP AL,03H
   JE @@CYAN
   CMP AL,04H
   JE @@ROJO
   CMP AL,05H
   JE @@MAGENTA
   CMP AL,06H
   JE @@CAFE   
   CMP AL,07H
   JE @@GRIS   
   CMP AL,08H
   JE @@GRISS    
   CMP AL,09H   
   JE @@AZULL
   CMP AL,0AH
   JE @@VERDEE
   CMP AL,0BH
   JE @@CYANN
   CMP AL,0CH
   JE @@ROJOO
   CMP AL,0DH
   JE @@MAGENTAA   
   CMP AL,0EH
   JE @@AMARILLO     
   CMP AL,0FH
   JE @@BLANCO   
   JMP @@FIN

@@NEGRO:  
   MOV AL,00h
   CALL DESPLEGAR
   JMP @@FIN
   
@@AZUL:  
   MOV AL,04h
   CALL DESPLEGAR   ;azul cambia a rojo
   JMP @@FIN
   
@@VERDE:  
   MOV AL,02h
   CALL DESPLEGAR
   JMP @@FIN

@@CYAN:  
   MOV AL,06h
   CALL DESPLEGAR   ;cambia con cafe
   JMP @@FIN
   
 @@ROJO:  
   MOV AL,01h
   CALL DESPLEGAR   
   JMP @@FIN  
   
@@MAGENTA:  
   MOV AL,05h
   CALL DESPLEGAR   
   JMP @@FIN   
   
@@CAFE:  
   MOV AL,03h
   CALL DESPLEGAR   ;cambia con cyan
   JMP @@FIN   
   
@@GRIS:  
   MOV AL,08h
   CALL DESPLEGAR   ;cambia con gris claro
   JMP @@FIN 
 
@@GRISS:  
   MOV AL,07h 
   CALL DESPLEGAR   ;cambia con gris 
   JMP @@FIN 

@@AZULL:  
   MOV AL,0Ch
   CALL DESPLEGAR   ;CAMBIA CON ROJO CLARO
   JMP @@FIN 
 
@@VERDEE:  
   MOV AL,0Ah
   CALL DESPLEGAR   
   JMP @@FIN 
 
@@CYANN:  
   MOV AL,0Eh
   CALL DESPLEGAR   ;cambia con amarillo
   JMP @@FIN 
 
 @@ROJOO:  
   MOV AL,09h
   CALL DESPLEGAR   ;CAMBIA CON AZUL CLARO
   JMP @@FIN  
   
@@MAGENTAA:  
   MOV AL,0Dh
   CALL DESPLEGAR   
   JMP @@FIN  

@@AMARILLO:  
   MOV AL,0Bh
   CALL DESPLEGAR   ;cambia con light cyan
   JMP @@FIN    

@@BLANCO:  
   MOV AL,0Fh
   CALL DESPLEGAR   
   JMP @@FIN  
  
@@FIN:
   RET
ENDP
;----------------------------------------------------------------------------
PROC IDENTIFICAR_PIXEL2 NEAR
   MOV AX,[SI]
   MOV AL,AH
   XOR AH,AH
   
   
    CMP AX,0
    JE @@NEGRO

  
   CMP AH,01H
   JE @@AZUL
   CMP AH,02H
   JE @@VERDE
   CMP AH,03H
   JE @@CYAN
   CMP AH,04H
   JE @@ROJO
   CMP AH,05H
   JE @@MAGENTA
   CMP AH,06H
   JE @@CAFE   
   CMP AH,07H
   JE @@GRIS   
   CMP AH,08H
   JE @@GRISS    
   CMP AH,09H   
   JE @@AZULL
   CMP AH,0AH
   JE @@VERDEE
   CMP AH,0BH
   JE @@CYANN
   CMP AH,0C0H
   JE @@ROJOO
   CMP AH,0DH
   JE @@MAGENTAA   
   CMP AH,0EH
   JE @@AMARILLO     
   CMP AH,0FH
   JE @@BLANCO   
   JMP @@FIN

@@NEGRO:  
   MOV AL,00h
   CALL DESPLEGAR
   JMP @@FIN
   
@@AZUL:  
   MOV AL,04h
   CALL DESPLEGAR    ;azul cambia a rojo
   JMP @@FIN
   
@@VERDE:  
   MOV AL,02h
   CALL DESPLEGAR   
   JMP @@FIN

@@CYAN:  
   MOV AL,06h
   CALL DESPLEGAR   ;cambia con cafe
   JMP @@FIN
   
 @@ROJO:  
   MOV AL,01h
   CALL DESPLEGAR   ;cambia con azul
   JMP @@FIN  
   
@@MAGENTA:  
   MOV AL,05h
   CALL DESPLEGAR   
   JMP @@FIN   
   
@@CAFE:  
   MOV AL,03h
   CALL DESPLEGAR   ;cambia con cyan
   JMP @@FIN   
   
@@GRIS:  
   MOV AL,08h
   CALL DESPLEGAR   ;cambia con gris claro
   JMP @@FIN 
 
@@GRISS:  
   MOV AL,07h
   CALL DESPLEGAR   
   JMP @@FIN 

@@AZULL:  
   MOV AL,0Ch
   CALL DESPLEGAR   ;CAMBIA CON ROJO CLARO
   JMP @@FIN 
 
@@VERDEE:  
   MOV AL,0Ah
   CALL DESPLEGAR   
   JMP @@FIN 
 
@@CYANN:  
   MOV AL,0Eh
   CALL DESPLEGAR   ;cambia con amarillo
   JMP @@FIN 
 
 @@ROJOO:  
   MOV AL,09h
   CALL DESPLEGAR   ;CAMBIA CON ROJO CLARO
   JMP @@FIN  
   
@@MAGENTAA:  
   MOV AL,0Dh
   CALL DESPLEGAR   
   JMP @@FIN  

@@AMARILLO:  
   MOV AL,0Bh
   CALL DESPLEGAR   ;cambia con light cyan
   JMP @@FIN    

@@BLANCO:  
   MOV AL,0Fh
   CALL DESPLEGAR   
   JMP @@FIN  
  
@@FIN:
   RET
ENDP
;----------------------------------------------------------------------------
PROC DESPLEGAR NEAR
;INT 10 - Escribir pixel.
;
;Par metros: AH = 0Ch
;            AL = color (ver m s abajo las constantes de color)
;            BH = n£mero de p gina (0 si se desconoce la p gina actual)
;            CX = columna (depende del modo gr fico)
;            DX = fila (depende del modo gr fico)

   PUSH BX
   PUSH DX
   MOV AH,0CH
   XOR BH,BH
   INT 10H
   POP DX
   POP BX
   RET
ENDP
;----------------------------------------------------------------------------
PROC GotoXY NEAR

      MOV  AH, 2                  ;Servicio para posicionar cursor.
      MOV  BH, 0                  ;BH = 0 : p gina de video.
      INT  10H                    ;Servicios de video del BIOS.
   @@Fin:
      RET
ENDP; GotoXY.

;----------------------------------------------------------------------------
PROC AbrirArchivo NEAR

      MOV DX,OFFSET ARCHIVO
      MOV  AH, 3DH                ;Servicio para abrir archivo.
      MOV  AL, 2                  ;Modo de apertura: lectura/escritura.
      INT  21H                    ;Servicios del DOS.
   @@Fin:
      MOV  [ Handler ], AX        ;Retornado por la interrupcion.
      RET
ENDP; AbrirArchivo.
;----------------------------------------------------------------------------
PROC LEER NEAR
   MOV DX,OFFSET SALVE+2
   MOV CX,117
   CALL LeerDeArchivo16Bits
                             ;HASTA ACA ESTAMOS LEYENDO SOLO EL HEADER 
							  
   CALL TAMANO
   CALL TAMANO2
   CALL CONVERTIR
   CALL DIVIDE2 
     

   MOV DX,[ALTO_NUM] ;VALOR DE FILA 
@@CICLO:							
						 
   PUSH DX
   
   MOV DX,OFFSET CONTENIDO+2
   MOV CX,[ANCHO_NUM]
   CALL LeerDeArchivo16Bits
   
   MOV DX,[ALTO_NUM] ;VALOR DE FILA                               ;LEEMOS EL HEADER MAS LA 1ERA FILA
   CALL CURSOR
   
   POP DX
   DEC DX
   mov [ALTO_NUM],DX
   CMP DX,0
   JA @@CICLO
   
      RET
ENDP; .
;----------------------------------------------------------------------------
PROC LeerDeArchivo16Bits NEAR
      PUSH DX

      MOV  AH, 3FH                ;Servicio para leer de archivo.
      MOV BX,[HANDLER]
      INT  21H                    ;Servicios del DOS.
   @@Fin:
   
   POP DX
      RET
ENDP; LeerDeArchivo16Bits.
;----------------------------------------------------------------------------
PROC TAMANO NEAR

;PROCESO QUE LEE EL ANCHO DEL ARCHIVO

   MOV ESI,OFFSET SALVE 
   MOV EDI, OFFSET ANCHO
   ADD ESI,23
   MOV CX,23

@@CICLO:     
   MOV AL,[ESI]
   MOV [EDI],AL
   DEC ESI
   INC EDI
   DEC CX
   CMP CX,20
   JAE @@CICLO
   
      RET
ENDP; .
;----------------------------------------------------------------------------
PROC TAMANO2 NEAR

;PROCESO QUE LEE EL ALTO DEL ARCHIVO

   MOV ESI,OFFSET SALVE 
   MOV EDI, OFFSET ALTO
   ADD ESI,27
   MOV CX,27

@@CICLO:     
   MOV AL,[ESI]
   MOV [EDI],AL
   DEC ESI
   INC EDI
   DEC CX
   CMP CX,23
   JAE @@CICLO
   
      RET
ENDP; .
;----------------------------------------------------------------------------
PROC CONVERTIR NEAR
    MOV ESI,OFFSET ANCHO
    MOV EDI,OFFSET ANCHO_NUM        
	
	CALL CONVERTIR3
      
    MOV ESI,OFFSET ALTO
    MOV EDI,OFFSET ALTO_NUM        
	
	CALL CONVERTIR3


      RET
ENDP; .

;----------------------------------------------------------------------------
PROC CONVERTIR3 NEAR

      MOV  AL, [ ESI + 2 ]                         
      MOV  AH, 0                  
      IMUL AX, 256               
      MOV  [ EDI ], AX            
      MOV  AL, [ ESI + 3 ]                         
               
      ADD [ EDI ], AL         

      RET
ENDP; .
;----------------------------------------------------------------------------
PROC EscribirEnArchivo16Bits NEAR
   PUSH BX
      MOV AH,40H
      MOV BX,[ Handler2 ]
;      MOV DX,OFFSET FRASE+2
      INT  21H                    ;Servicios del DOS.
   ;Verificar si los datos fueron guardados.
      CMP AX,CX
      JE  @@Fin
   ;Mensaje de error.
   ;   MOV  DX, OFFSET MSJError
    ;  CALL Cout
    
@@Fin:
 ;     MOV DX,OFFSET MSJ2  ;Se cargo con exito, y espera una tecla para
 ;     CALL COUT           ;salir.
  ;    MOV AH,01H
 ;     INT 21H
    POP BX
      RET
ENDP; EscribirEnArchivo16Bits.
;----------------------------------------------------------------------------
PROC Cerrar NEAR
      MOV  AH, 3EH                ;Servicio para cerrar archivo.
      MOV BX,[ Handler ]
      INT  21H                    ;Servicios del DOS.
      RET
ENDP

;----------------------------------------------------------------------------
PROC AbrirArchivo2 NEAR

      MOV DX,OFFSET ARCHIVO2
      MOV  AH, 3DH                ;Servicio para abrir archivo.
      MOV  AL, 2                  ;Modo de apertura: lectura/escritura.
      INT  21H                    ;Servicios del DOS.
   @@Fin:
      MOV  [ Handler2 ], AX        ;Retornado por la interrupcion.
      RET
ENDP; AbrirArchivo.
;----------------------------------------------------------------------------
PROC LEER2 NEAR
   MOV DX,OFFSET SALVE+2
   MOV CX,117
   CALL LeerDeArchivo16Bits
                             ;HASTA ACA ESTAMOS LEYENDO SOLO EL HEADER 
							  
   CALL TAMANO
   CALL TAMANO2
   CALL CONVERTIR
   CALL DIVIDE2 
     

   MOV DX,[ALTO_NUM] ;VALOR DE FILA 
@@CICLO:							
						 
   PUSH DX
   
   MOV DX,OFFSET CONTENIDO+2
   MOV CX,[ANCHO_NUM]
   CALL LeerDeArchivo16Bits
   
   MOV DX,[ALTO_NUM] ;VALOR DE FILA                               ;LEEMOS EL HEADER MAS LA 1ERA FILA
   CALL CURSOR2
   
   POP DX
   DEC DX
   mov [ALTO_NUM],DX
   CMP DX,0
   JA @@CICLO
   
      RET
ENDP; .
;----------------------------------------------------------------------------
PROC CURSOR2 NEAR
   
   XOR CX,CX  ; EMPEZAR EN COLUMNA 0
   XOR BX,BX
   MOV SI,OFFSET CONTENIDO


   MOV DX,OFFSET CAMBIO   
   MOV BX,[ Handler2]                        
   CALL CAMBIO_LINEA 

@@CICLO2: 
  CALL IDENTIFICAR_PIXEL3
  CALL IDENTIFICAR_PIXEL4  
  INC CX
  INC BX
  INC SI
;  CALL SEEK
  CMP BX,[ANCHO_NUM]
  JBE @@CICLO2
  

@@FIN:
   RET
ENDP
;----------------------------------------------------------------------------
PROC IDENTIFICAR_PIXEL3 NEAR
   MOV AX,[SI]
   MOV AL,AH
   XOR AH,AH
   
   
    CMP AX,0
    JE @@NEGRO

	
   CALL CONVIERTE2
   
   CMP AL,01H
   JE @@AZUL
   CMP AL,02H
   JE @@VERDE
   CMP AL,03H
   JE @@CYAN
   CMP AL,04H
   JE @@ROJO
   CMP AL,05H
   JE @@MAGENTA
   CMP AL,06H
   JE @@CAFE   
   CMP AL,07H
   JE @@GRIS   
   CMP AL,08H
   JE @@GRISS    
   CMP AL,09H   
   JE @@AZULL
   CMP AL,0AH
   JE @@VERDEE
   CMP AL,0BH
   JE @@CYANN
   CMP AL,0CH
   JE @@ROJOO
   CMP AL,0DH
   JE @@MAGENTAA   
   CMP AL,0EH
   JE @@AMARILLO     
   CMP AL,0FH
   JE @@BLANCO   
   JMP @@FIN

@@NEGRO:  
   MOV DX, OFFSET A0
   CALL EscribirEnArchivo16Bits
   JMP @@FIN
   
@@AZUL:  
   MOV DX, OFFSET A1
   CALL EscribirEnArchivo16Bits
   JMP @@FIN
   
@@VERDE:  
   MOV DX, OFFSET A2
   CALL EscribirEnArchivo16Bits
   JMP @@FIN

@@CYAN:  
   MOV DX, OFFSET A3
   CALL EscribirEnArchivo16Bits
   JMP @@FIN
   
 @@ROJO:  
   MOV DX, OFFSET A4
   CALL EscribirEnArchivo16Bits
   JMP @@FIN  
   
@@MAGENTA:  
   MOV DX, OFFSET A5
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN   
   
@@CAFE:  
   MOV DX, OFFSET A6
   CALL EscribirEnArchivo16Bits
   JMP @@FIN   
   
@@GRIS:  
   MOV DX, OFFSET A7
   CALL EscribirEnArchivo16Bits
   JMP @@FIN 
 
@@GRISS:  
   MOV DX, OFFSET A8
   CALL EscribirEnArchivo16Bits
   JMP @@FIN 

@@AZULL:  
   MOV DX, OFFSET A9
   CALL EscribirEnArchivo16Bits
   JMP @@FIN 
 
@@VERDEE:  
   MOV DX, OFFSET A10
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN 
 
@@CYANN:  
   MOV DX, OFFSET A11
   CALL EscribirEnArchivo16Bits
   JMP @@FIN 
 
 @@ROJOO:  
   MOV DX, OFFSET A12
   CALL EscribirEnArchivo16Bits
   JMP @@FIN  
   
@@MAGENTAA:  
   MOV DX, OFFSET A13
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN  

@@AMARILLO:  
   MOV DX, OFFSET A14
   CALL EscribirEnArchivo16Bits
   JMP @@FIN    

@@BLANCO:  
   MOV DX, OFFSET A15
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN  
  
@@FIN:
   RET
ENDP
;----------------------------------------------------------------------------
PROC IDENTIFICAR_PIXEL4 NEAR
   MOV AX,[SI]
   MOV AL,AH
   XOR AH,AH
   
   
    CMP AX,0
    JE @@NEGRO

  
   CMP AH,01H
   JE @@AZUL
   CMP AH,02H
   JE @@VERDE
   CMP AH,03H
   JE @@CYAN
   CMP AH,04H
   JE @@ROJO
   CMP AH,05H
   JE @@MAGENTA
   CMP AH,06H
   JE @@CAFE   
   CMP AH,07H
   JE @@GRIS   
   CMP AH,08H
   JE @@GRISS    
   CMP AH,09H   
   JE @@AZULL
   CMP AH,0AH
   JE @@VERDEE
   CMP AH,0BH
   JE @@CYANN
   CMP AH,0C0H
   JE @@ROJOO
   CMP AH,0DH
   JE @@MAGENTAA   
   CMP AH,0EH
   JE @@AMARILLO     
   CMP AH,0FH
   JE @@BLANCO   
   JMP @@FIN

@@NEGRO:  
   MOV DX, OFFSET A0
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN
   
@@AZUL:  
   MOV DX, OFFSET A1
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN
   
@@VERDE:  
   MOV DX, OFFSET A2
   CALL EscribirEnArchivo16Bits   
   JMP @@FIN

@@CYAN:  
   MOV DX, OFFSET A3
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN
   
 @@ROJO:  
   MOV DX, OFFSET A4
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN  
   
@@MAGENTA:  
   MOV DX, OFFSET A5
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN   
   
@@CAFE:  
   MOV DX, OFFSET A6
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN   
   
@@GRIS:  
   MOV DX, OFFSET A7
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN 
 
@@GRISS:  
   MOV DX, OFFSET A8
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN 

@@AZULL:  
   MOV DX, OFFSET A9
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN 
 
@@VERDEE:  
   MOV DX, OFFSET A10
   CALL EscribirEnArchivo16Bits   
   JMP @@FIN 
 
@@CYANN:  
   MOV DX, OFFSET A11
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN 
 
 @@ROJOO:  
   MOV DX, OFFSET A12
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN  
   
@@MAGENTAA:  
   MOV DX, OFFSET A3
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN  

@@AMARILLO:  
   MOV DX, OFFSET A14
   CALL EscribirEnArchivo16Bits 
   JMP @@FIN    

@@BLANCO:  
   MOV DX, OFFSET A15
   CALL EscribirEnArchivo16Bits   
   JMP @@FIN  
  
@@FIN:
   RET
ENDP
;----------------------------------------------------------------------------

;þ DESCRIPCION: Mueve el apuntador interno del archivo: al inicio, al final,
;               al inicio + un desplazamiento, o a un desplazamiento a partir
;               de la posici¢n actual.
;þ PARAMETROS: BX  = handler del archivo.
;              AL  = 0: moverse al inicio del archivo.
;                  = 1: moverse al final  del archivo.
;                  = 2: moverse al inicio + un desplazamiento.
;                  = 3: moverse un desplazamiento a partir de posici¢n actual.
;              EDX = desplazamiento ( s¢lo para AL = 2 ¢ 3 ).
;þ SALIDA: CF = 0 : apuntador exitosamente movido.
;          CF = 1 : AX = c¢digo de error.
;þ REGISTROS MODIFICADOS: AX, ECX, DX.

PROC Seek NEAR
      MOV EDX,1
      MOV  AL, 1                  ;Subservicio para moverse a pos.actual+desp.
      MOV  ECX, EDX               ;El servicio recibe el desplazamiento en
      SHR  ECX, 16                ;CX:DX, as¡ q el word alto de EDX va en CX.
   @@HacerElSeek:
      MOV  AH, 42H                ;Servicio para realizar SEEK.
      INT  21H                    ;Servicios del DOS.
   @@Fin:
      RET
ENDP; Seek
;----------------------------------------------------------------------------

PROC Cerrar2 NEAR
      MOV  AH, 3EH                ;Servicio para cerrar archivo.
      MOV BX,[ Handler2 ]
      INT  21H                    ;Servicios del DOS.
      RET
ENDP

;----------------------------------------------------------------------------
PROC CrearArchivo NEAR
 
      MOV  AH, 3CH                 ;Servicio para crear archivo.
      MOV DX, OFFSET ARCHIVO2    
      MOV  CX, 0000000000100000B  ;Atributos que tendr  el archivo creado.
      INT  21H                    ;Servicios del DOS.
   ;Verificar si el archivo fue creado.
      JNC  @@Fin
   @@Fin:
      MOV  [ Handler2 ], AX        ;Retornado por la interrupcion.
      RET
ENDP; CrearArchivo.
;----------------------------------------------------------------------------
PROC CAMBIO_LINEA NEAR
    PUSH BX
      MOV CL,2        
      MOV CH,0        
      MOV AH,40H
 
      INT  21H                    
    POP BX
      RET
ENDP
;----------------------------------------------------------------------------
PROC VALIDAR FAR
        mov si, 80h ;apunta al inicio de la linea de comando

        inc si ;quita el espacio blanco que sale de primero en linea de comando
        inc si ;para revisar que no haya otro espacio en blanco, lo que llevaria a mandar un mensaje
        mov dl, byte ptr es:[si]
        cmp dl, 2Fh ;compara el caracter a ver si es un slash
        je Slash ;si no es igual a un slash 

        cmp dl, 20h ;a ver si es un espacio en blanco
        je Nada

        mov di, offset archivo
    Nombre:
        mov dl, byte ptr es:[si]
        mov [di], dl
        cmp dl, '.'
        je Nombre2
        inc di
        inc si 
        jmp Nombre

    Nombre2:
        inc di
        mov [di], 62h ;le mete una b
        inc di
        mov [di], 6Dh ;le mete una m
        inc di
        mov [di], 70h ;le mete una p
        jmp Fin



    Nada:  
        mov ah, 09h ;imprime etiqueta de aviso
        lea dx, etilin
        int 21h

        mov ah, 09h ;imprime etiqueta de aviso
        lea dx, nombrebmp
        int 21h

        CALL RETORNADOS

    Slash:
        mov ah, 09h ;imprime etiqueta de aviso
        lea dx, etilin
        int 21h

        inc si ;para revisar que viene despues del slash
        mov dl, byte ptr es:[si]
        cmp dl, 3Fh ;a ver si es un signo de pregunta
        je Ayudas
        cmp dl, 48h ;a ver si es igual a H
        je Ayudas
        cmp dl, 68h ;a ver si es igual a h
        je ayudas
        cmp dl, 41h ;a ver si es igual a una A
        je Ascii
        cmp dl, 61h ;a ver si es igual a una a
        je Ascii
        cmp dl, 72h ;a ver si es igual a una r
        je Inverso
        cmp dl, 69h ;a ver si es igual a una i
        je Izquierdo
        cmp dl, 64h ;a ver si es igual a una d
        je Derecho

    Ayudas:
        mov ah, 09h
        lea dx, ayuda
        int 21h


        mov ah, 09h ;imprime etiqueta de aviso
        lea dx, etilin
        int 21h

        CALL RETORNADOS

    Ascii:
        mov ah, 09h
        lea dx, texto
        int 21h


        mov ah, 09h ;imprime etiqueta de aviso
        lea dx, etilin
        int 21h

       CALL RETORNADOS

    Inverso:
        mov ah, 09h
        lea dx, inversa
        int 21h


        mov ah, 09h ;imprime etiqueta de aviso
        lea dx, etilin
        int 21h

        CALL RETORNADOS

    Izquierdo:
        mov ah, 09h
        lea dx, izquierda
        int 21h


        mov ah, 09h ;imprime etiqueta de aviso
        lea dx, etilin
        int 21h

        CALL RETORNADOS

    Derecho:
        mov ah, 09h
        lea dx, derecha
        int 21h


        mov ah, 09h ;imprime etiqueta de aviso
        lea dx, etilin
        int 21h

        CALL RETORNADOS

   Fin:
      RET

ENDP
;----------------------------------------------------------------------------

INICIO:
         MOV AX,DATOS
         MOV DS,AX
         
		 CALL VALIDAR
       CALL VIDEO
		 CALL ABRIRARCHIVO
         CALL Leer


		 ;CALL ABRIRARCHIVO2
		 ;CALL CREARARCHIVO
		 
		 ;CALL LEER2
		 CALL CERRAR
		 ;CALL CERRAR2		 

         MOV AH,4CH
         MOV AL,0
         INT 21H
         
ENDS
END INICIO   