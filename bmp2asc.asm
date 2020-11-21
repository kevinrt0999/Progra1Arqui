;----------------------------------------------------------------------------
pila segment

DB 1024 DUP(?)

pila ends
;----------------------------------------------------------------------------
datos segment 

;*****DEFINO VARIABLES*****

CAMBIO DB 13,10

A0 DB '1'
A1 DB '2'
A2 DB '3'
A3 DB '4'
A4 DB '5'
A5 DB '6'
A6 DB '7'
A7 DB '8'
A8 DB '9'
A9 DB '0'
A10 DB 'A'
A11 DB 'B'
A12 DB 'C'
A13 DB 'D'
A14 DB 'E'
A15 DB 'F'

ARCHIVO     db  15 DUP (?),'$'
ARCHIVO2 DB 'DOCU2.TXT',0
SALVE DB 116 DUP ( )

HANDLER DW ?
HANDLER2 DW ?
ANCHO DB 4 DUP ( )
ALTO DB 4 DUP ( )
PIXEL1 DB 0
PIXEL2 DB 0

TAMAÑO DB 4 DUP ( )

COLUMNA DW 50
FILA DW 100

ANCHO_NUM DW 0
ALTO_NUM DW 0
ALTO_NUM2 DW 0

RESETEO DW 0

CONTENIDO DB 320 DUP ( ) 

etilin db "--------------------------------------------------------------------------------","$"
ayuda1 db  '*************************BIENVENIDO AL CENTRO DE AYUDA*************************',10,13,'$'
ayuda2 db  'A CONTINUACION SE PRESENTA LA GUIA PARA USAR EL PROGRAMA: ',10,13,'$'
ayuda3 db  '****************************DESPLEGAR IMAGEN NORMAL****************************',10,13,'$'
ayuda4 db  'ESCRIBIR EL NOMBRE DEL PROGRAMA, SEGUIDO POR UN ESPACIO, Y DESPUES ESCRIBIR EL NOMBRE DE LA IMAGEN (EJ: BMP2ASC PICA.BMP)',10,13,'$'
ayuda5 db  '****************************DESPLEGAR IMAGEN INVERSA***************************',10,13,'$'
ayuda6 db  'ESCRIBIR EL NOMBRE DEL PROGRAMA, SEGUIDO POR UN ESPACIO, DESPUES ESCRIBIR EL',10,13,'$'
ayuda7 db  'NOMBRE DE LA IMAGEN, SEGUIDO POR UN ESPACIO, Y AL FINAL PONER /r (EJ: BMP2ASC PICA.BMP /r)',10,13,'$'
ayuda8 db  '****************************DESPLEGAR IMAGEN ASCII***************************',10,13,'$'
ayuda9 db  'ESCRIBIR EL NOMBRE DEL PROGRAMA, SEGUIDO POR UN ESPACIO, DESPUES ESCRIBIR EL',10,13,'$'
ayuda10 db  'NOMBRE DE LA IMAGEN, SEGUIDO POR UN ESPACIO, Y AL FINAL PONER /a (EJ: BMP2ASC PICA.BMP /a). EL ARCHIVO SE VA A LLAMAR DOCU2.TXT',10,13,'$'
ayuda11 db  '****************************CENTRO DE AYUDA***************************',10,13,'$'
ayuda12 db  'ESCRIBIR EL NOMBRE DEL PROGRAMA, SEGUIDO POR UN ESPACIO, DESPUES ESCRIBIR UN',10,13,'$'
ayuda13 db  '/?, O UN /H, O UN /h (EJ: BMP2ASC PICA.BMP /?)',10,13,'$'

texto db  'Mostrar txt con el arte ASCII',10,13,'$'
inversa db  'Modo inverso',10,13,'$'
izquierda   db  'Rotado a la izquierda',10,13,'$'
derecha   db  'Rotado a la derecha',10,13,'$'
nombrebmp   db  'Deberia ser el nombre de la imagen bmp...',10,13,'$'
guardabmp   db  'Se guardo el nombre del bmp!!!',10,13,'$'
archivos     db  15 DUP (?),'$'
bmp1    db      4 DUP (?)

datos ENDS
;----------------------------------------------------------------------------
codigo segment
assume cs:codigo,ds:datos,ss:pila
;----------------------------------------------------------------------------
 LIMPIAR PROC NEAR   
   MOV AX,0600H      ;AH = 06 (RECORRIDO), AL= 00 (PANTALLA COMPLETA)
   MOV BH,0AH        ;NEGRO =0 (FONDO), ROJO =2 (LETRAS)
   MOV CX,0000H      ;EMPEZAR DE ESQUINA SUPERIOR IZQUIERDA
   MOV DX,184FH      ;TERMINAR EN ESQUINA INFERIOR DERCHA
   INT 10H   
   RET
ENDP
;----------------------------------------------------------------------------
 VIDEO PROC NEAR   
   MOV AH,00H      ;PONER MODO GRAFICO
   MOV AL,12H      ;12Ch     = modo gr fico 640x480

   INT 10H   
   RET
ENDP
;----------------------------------------------------------------------------
 DIVIDE2 PROC NEAR
    PUSH BX
	PUSH DX
	                     ;divide el contenido de ancho num entre 2, esto xq
	MOV AX,[ANCHO_NUM]   ;cada lectura contiene 2 pixeles, por ende no se
	MOV BX,2             ;necesita leer 640 sino 320
	MOV DX,0
    DIV BX
	
	MOV [ANCHO_NUM],AX
	

	POP DX
	POP BX



   RET
ENDP
;----------------------------------------------------------------------------
 CURSOR PROC NEAR
   
   XOR CX,CX  ; EMPEZAR EN COLUMNA 0
   XOR BX,BX
   MOV SI,OFFSET CONTENIDO       ;APUNTA AL PRIMER CARCTER DEL CONTENIDO 
                                 ;CONTENIDO VA A TENER UNA LINEA DE CARACTERES QUE ES LA QUE SE VA A DESPLEGAR
@@CICLO2: 
  CALL IDENTIFICAR_PIXEL1
  INC CX
  CALL IDENTIFICAR_PIXEL2 
  CALL IDENTIFICAR_PIXEL2_X  
  INC CX
  INC BX
  INC SI
  CMP BX,[ANCHO_NUM]
  JBE @@CICLO2
  

   RET
ENDP
;----------------------------------------------------------------------------
 CONVIERTE2 PROC NEAR           ;DIVIDO ENTRE 16 PARA DESCOMPONER LOS PIXELES Y SEPARARLOS PARA PODER DESPLEGARLOS
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
 IDENTIFICAR_PIXEL1 PROC NEAR
   MOV AX,[SI]         ;la lectura presentada tomando como ejemplo un 08h es 
   CMP AH,0                     ;presentada en AX de la siguiente manera: 0800h
   JE @@SEGUIR
   
   MOV AL,AH          
   XOR AH,AH           ;por lo que intercambiamos AH con AL y borramos AH
   JMP @@SEGUIR2
   
 @@SEGUIR:                      ;para que AL = AX   
    MOV AL,AH  
	
@@SEGUIR2:	
    CMP AL,0
    JE @@NEGRO
	
   CALL CONVIERTE2        ;LLAMA A CONVIERTE PARA DIVIDIR EN 2 PIXELES DIFERENTES LOA 4 BYTES
    
    CMP AL,0
    JE @@NEGRO
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
   CMP AL,0EH
   JE @@AMARILLO  
   CMP AL,0DH   
   JE @@MAGENTAA   
   CMP AL,0FH
   JE @@BLANCO   
   JMP @@FIN

@@NEGRO: 
   CALL NEGRO
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
   
@@AMARILLO:  
   MOV AL,0Bh
   CALL DESPLEGAR   ;cambia con light cyan
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

@@BLANCO:  
   MOV AL,0Fh
   CALL DESPLEGAR   
   JMP @@FIN  
  
@@FIN:
   RET
ENDP
;----------------------------------------------------------------------------
 NEGRO PROC NEAR
   XOR AH,AH
   MOV [PIXEL1],AH      ;EN EL ESO CONVIERTE2 SE CARGAN LOS VALORES DE PIXEL1 Y PIXEL2
   MOV [PIXEL2],AH      ;SIN EMBARGO, SI TENEMOS COLOR NEGRO, NOS ESTAMOS BRINCANDO CONVIERTE2
   MOV AL,00h           ;POR LO QUE SE NECESITA ASIGNARLE VALOR A LAS VARIABLES MANUALMENTE
   CALL DESPLEGAR
   RET
ENDP
;----------------------------------------------------------------------------

 IDENTIFICAR_PIXEL2 PROC NEAR
    MOV AL,[PIXEL2]     ;DESPLEGAR EL PIXEL 2, YA VIENE EL AX DIVIDO DE IDENTIFICAR_PIXEL1

    CMP AL,0
    JE @@NEGRO2

   CMP AL,01H
   JE @@AZUL2
   CMP AL,02H
   JE @@VERDE2
   CMP AL,03H
   JE @@CYAN2
   CMP AL,04H
   JE @@ROJO2
   CMP AL,05H
   JE @@MAGENTA2
   CMP AL,06H
   JE @@CAFE2   
   CMP AL,07H
   JE @@GRIS2   
   CMP AL,08H
   JE @@GRISS2    
   
   JMP @@FIN2

@@NEGRO2:  
   MOV AL,00h
   CALL DESPLEGAR
   JMP @@FIN2
   
@@AZUL2:  
   MOV AL,04h
   CALL DESPLEGAR    ;azul cambia a rojo
   JMP @@FIN2
   
@@VERDE2:  
   MOV AL,02h
   CALL DESPLEGAR   
   JMP @@FIN2

@@CYAN2:  
   MOV AL,06h
   CALL DESPLEGAR   ;cambia con cafe
   JMP @@FIN2
   
 @@ROJO2:  
   MOV AL,01h
   CALL DESPLEGAR   ;cambia con azul
   JMP @@FIN2  
   
@@MAGENTA2:  
   MOV AL,05h
   CALL DESPLEGAR   
   JMP @@FIN2   
   
@@CAFE2:  
   MOV AL,03h
   CALL DESPLEGAR   ;cambia con cyan
   JMP @@FIN2   
   
@@GRIS2:  
   MOV AL,08h
   CALL DESPLEGAR   ;cambia con gris claro
   JMP @@FIN2 
 
@@GRISS2:  
   MOV AL,07h
   CALL DESPLEGAR   
   JMP @@FIN2 
  
@@FIN2:
   RET
ENDP
;----------------------------------------------------------------------------

 IDENTIFICAR_PIXEL2_X PROC NEAR
    MOV AL,[PIXEL2]

   CMP AL,09H 	
   JE @@AZULL2
   CMP AL,0AH
   JE @@VERDEE2
   CMP AL,0BH
   JE @@CYANN2
   CMP AL,0C0H
   JE @@ROJOO2
   CMP AL,0DH
   JE @@MAGENTAA2   
   CMP AL,0EH
   JE @@AMARILLO2     
   CMP AL,0FH
   JE @@BLANCO2   
   JMP @@FIN7


@@AZULL2:  
   MOV AL,0Ch
   CALL DESPLEGAR   ;CAMBIA CON ROJO CLARO
   JMP @@FIN7 
 
@@VERDEE2:  
   MOV AL,0Ah
   CALL DESPLEGAR   
   JMP @@FIN7 
 
@@CYANN2:  
   MOV AL,0Eh
   CALL DESPLEGAR   ;cambia con amarillo
   JMP @@FIN7 
 
 @@ROJOO2:  
   MOV AL,09h
   CALL DESPLEGAR   ;CAMBIA CON ROJO CLARO
   JMP @@FIN7  
   
@@MAGENTAA2:  
   MOV AL,0Dh
   CALL DESPLEGAR   
   JMP @@FIN7  

@@AMARILLO2:  
   MOV AL,0Bh
   CALL DESPLEGAR   ;cambia con light cyan
   JMP @@FIN7    

@@BLANCO2:  
   MOV AL,0Fh
   CALL DESPLEGAR   
   JMP @@FIN7  
  
@@FIN7:
   RET
ENDP
;----------------------------------------------------------------------------

 DESPLEGAR PROC NEAR
;INT 10 - Escribir pixel.
;
;Par metros: AH = 0Ch
;            AL = color (ver m s abajo las constantes de color)
;            BH = n£mero de p gina (0 si se desconoce la p gina actual)
;            CX = columna (depende del modo gr fico)
;            DX = fila (depende del modo gr fico)

   PUSH BX
   PUSH DX
   PUSH AX
   MOV AH,0CH
   XOR BH,BH
   INT 10H
   POP AX
   POP DX
   POP BX
   RET
ENDP
;----------------------------------------------------------------------------
 GotoXY PROC NEAR

      MOV  AH, 2                  ;Servicio para posicionar cursor.
      MOV  BH, 0                  ;BH = 0 : p gina de video.
      INT  10H                    ;Servicios de video del BIOS.

      RET
ENDP; GotoXY.

;----------------------------------------------------------------------------
 AbrirArchivo PROC NEAR

      MOV DX,OFFSET ARCHIVO
      MOV  AH, 3DH                ;Servicio para abrir archivo.
      MOV  AL, 2                  ;Modo de apertura: lectura/escritura.
      INT  21H                    ;Servicios del DOS.
      MOV  [ Handler ], AX        ;Retornado por la interrupcion.
      RET
ENDP; AbrirArchivo.
;----------------------------------------------------------------------------
 LEER PROC NEAR
   MOV DX,OFFSET SALVE        ;El byte 10 del header indica en que byte empieza el array de pixeles
   MOV CX,116                 ;este valor es fijo y se define que empiezan siempre a partir de este   
   MOV BX,[HANDLER]
   CALL LeerDeArchivo16Bits
                                         ;HASTA ACA ESTAMOS LEYENDO SOLO EL HEADER 
							  
   CALL TAMANO
   CALL TAMANO2
   CALL CONVERTIR
   CALL DIVIDE2 

   MOV DX,[ALTO_NUM] ;VALOR DE FILA 
@@CICLO:				                          ;CICLO DONDE VA A DESPLEGAR LAS 480 FILAS			
						 
   PUSH DX

   MOV DX,OFFSET CONTENIDO
   MOV CX,[ANCHO_NUM]
   MOV BX,[HANDLER]
   CALL LeerDeArchivo16Bits
   
   MOV DX,[ALTO_NUM] ;VALOR DE FILA                               ;LEEMOS EL HEADER MAS LA 1ERA FILA
   CALL CURSOR
   

   POP DX
   DEC DX
   MOV [ALTO_NUM],DX
   CMP DX,0
   JA @@CICLO
   
      RET
ENDP; .
;----------------------------------------------------------------------------
 LeerDeArchivo16Bits PROC NEAR
      PUSH DX
      PUSH BX
      MOV  AH, 3FH                ;Servicio para leer de archivo.
      INT  21H                    ;Servicios del DOS.
   
   POP BX
   POP DX
      RET
ENDP; LeerDeArchivo16Bits.
;----------------------------------------------------------------------------
 TAMANO PROC NEAR

;LEEMOS EL ANCHO DEL ARCHIVO

   MOV SI,OFFSET SALVE 
   MOV DI, OFFSET ANCHO
   ADD SI,21          ; 20 al 23 se lee ancho en la cabecera
   MOV CX,21

@@CICLO8:     
   MOV AL,[SI]
   MOV [DI],AL
   DEC SI
   INC DI
   DEC CX
   CMP CX,18
   JAE @@CICLO8
   
      RET
ENDP; .
;----------------------------------------------------------------------------
 TAMANO2 PROC NEAR

;LEEMOS EL ALTO DEL ARCHIVO

   MOV SI,OFFSET SALVE 
   MOV DI, OFFSET ALTO
   ADD SI,25
   MOV CX,25

@@CICLO3:     
   MOV AL,[SI]
   MOV [DI],AL
   DEC SI
   INC DI
   DEC CX
   CMP CX,22
   JAE @@CICLO3
   
      RET
ENDP; .
;----------------------------------------------------------------------------
 CONVERTIR PROC NEAR
    MOV SI,OFFSET ANCHO       ;LLAMAMOS A ALTO Y ANCHO PARA CONVERTIRLOS EN NUMERO
    MOV DI,OFFSET ANCHO_NUM        
	
	CALL CONVERTIR3
      
    MOV SI,OFFSET ALTO
    MOV DI,OFFSET ALTO_NUM        
	
	CALL CONVERTIR3


      RET
ENDP; .

;----------------------------------------------------------------------------
 CONVERTIR3 PROC NEAR

;CONVERTIMOS VALORES DEL ALTO Y ANCHO A NUMERO

      MOV  AL, [ SI + 2 ]                         
      MOV  AH, 0 
      MOV BX,256	  
      MUL BX              
      MOV  [ DI ], AX            
      MOV  AL, [ SI + 3 ]                         
               
      ADD [ DI ], AL         

      RET
ENDP; .
;----------------------------------------------------------------------------
 EscribirEnArchivo16Bits PROC NEAR
   PUSH BX
      MOV AH,40H
      MOV BX,[ Handler2 ]
      INT  21H                    ;Servicios del DOS.

    POP BX
      RET
ENDP; EscribirEnArchivo16Bits.
;----------------------------------------------------------------------------
 Cerrar PROC NEAR
      MOV  AH, 3EH                ;Servicio para cerrar archivo.
      MOV BX,[ Handler ]
      INT  21H                    ;Servicios del DOS.
      RET
ENDP

;----------------------------------------------------------------------------
 AbrirArchivo2 PROC NEAR

      MOV DX,OFFSET ARCHIVO2
      MOV  AH, 3DH                ;Servicio para abrir archivo.
      MOV  AL, 2                  ;Modo de apertura: lectura/escritura.
      INT  21H                    ;Servicios del DOS.
      MOV  [ Handler2 ], AX        ;Retornado por la interrupcion.
      RET
ENDP; AbrirArchivo.
;----------------------------------------------------------------------------
 Cerrar2 PROC NEAR
      MOV  AH, 3EH                ;Servicio para cerrar archivo.
      MOV BX,[ Handler2 ]         ;SE TUVO QUE CREAR OTRO PARA USAR OTRO HANDLER
      INT  21H                    ;Servicios del DOS.
      RET
ENDP

;----------------------------------------------------------------------------
 CrearArchivo PROC NEAR
 
      MOV  AH, 3CH                 ;Servicio para crear archivo.
      MOV DX, OFFSET ARCHIVO2    
      MOV  CX, 0000000000100000B  ;Atributos que tendr  el archivo creado.
      INT  21H                    ;Servicios del DOS.

      MOV  [ Handler2 ], AX        ;Retornado por la interrupcion.
      RET
ENDP; CrearArchivo.
;----------------------------------------------------------------------------
 CAMBIO_LINEA PROC NEAR
    PUSH BX
      MOV CL,2        
      MOV CH,0        
      MOV AH,40H
 
      INT  21H                    
    POP BX
      RET
ENDP
;----------------------------------------------------------------------------
 LEER2 PROC NEAR             ;PROC LEER2 PARA IMAGEN INVERSA
   MOV DX,OFFSET SALVE
   MOV CX,116
   MOV BX,[HANDLER]
   CALL LeerDeArchivo16Bits
                             ;HASTA ACA ESTAMOS LEYENDO SOLO EL HEADER 
							  
   CALL TAMANO
   CALL TAMANO2
   CALL CONVERTIR
   CALL DIVIDE2 
     

   XOR DX,DX ;VALOR DE FILA 
   MOV [RESETEO],DX          ;PARA EMPEZAR A DESPLEGAR EN 0 EN Y (DE ARRIBA HACIA ABAJO)    
@@CICLO4:							
						 

   PUSH CX
 
   MOV DX,OFFSET CONTENIDO
   MOV CX,[ANCHO_NUM]
   MOV BX,[HANDLER]   
   CALL LeerDeArchivo16Bits
   
    
   MOV DX,[RESETEO]            	;VALOR DE FILA                               ;LEEMOS EL HEADER MAS LA 1ERA FILA
   CALL CURSOR
   
   POP CX
   MOV DX,[RESETEO]
   INC DX
   MOV [RESETEO],DX

   CMP DX,[ALTO_NUM]
   JBE @@CICLO4


      RET
ENDP; .
;----------------------------------------------------------------------------
 LEER3 PROC NEAR                  ;LEER 3 PARA IMAGEN EN FORMATO ASCII EN EL TXT 

		 CALL CREARARCHIVO

		 XOR AL,AL
		 MOV BX,[HANDLER]
		 CALL SeekEnArchivo

         CALL HEADER

         MOV DX,[ALTO_NUM]        ;ALTO_NUM EMPIEZA EN 0 Y VA INCREMENTANDO POR CADA PASADA HACIA ABAJO PARA IR ESCRIBIENDO EN EL TXT
		 MOV [ALTO_NUM2],DX	          ;ALTO_NUM2 VIENE DE ABAJO HACIA ARRIBA, HASTA LLEGAR A ALTO_NUM, HASTA QUE ALTO_NUM SEA 0
		 
@@LOOP:

		 XOR AL,AL
		 MOV BX,[HANDLER]
		 CALL SeekEnArchivo
		 

         CALL HEADER
         
		 MOV DX,[ALTO_NUM2]
		 MOV [ALTO_NUM],DX
        
   CALL LEE_ULTIMA_LINEA
	
   CALL ESCRIBE_TXT
	 
         MOV DX,[ALTO_NUM2]
		 DEC DX
		 MOV [ALTO_NUM],DX
		 MOV [ALTO_NUM2],DX
		 CMP DX,0
		 JA @@LOOP
   RET
ENDP
;---------------------------------------------------------------------------- 
 ESCRIBE_TXT PROC NEAR              ;VAMOS A ESCRIBIR UNA LINEA EN EL ARCHIVO TXT

   XOR CX,CX  ; EMPEZAR EN COLUMNA 0
   XOR BX,BX
   MOV SI,OFFSET CONTENIDO
   
@@CICLO5: 

  MOV AL,1
  CALL SeekEnArchivo2               ;MOVERNOS A ALGUN LUGAR EN ESPECIFICO
  CALL IDENTIFICAR_PIXEL3
  MOV CL,1     
  MOV CH,0   
  CALL EscribirEnArchivo16Bits 
 
  MOV AL,1
  CALL SeekEnArchivo2
  CALL IDENTIFICAR_PIXEL4  
  MOV CL,1     
  MOV CH,0 
  CALL EscribirEnArchivo16Bits 
  
  INC BX
  INC SI
  CMP BX,[ANCHO_NUM]
  JBE @@CICLO5
  
  MOV AL,1
  CALL SeekEnArchivo2

  MOV DX,OFFSET CAMBIO
  MOV CL,1     
  MOV CH,0 
  CALL EscribirEnArchivo16Bits
  
  MOV AL,1
  CALL SeekEnArchivo2 

   RET
ENDP
;---------------------------------------------------------------------------- 
 LEE_ULTIMA_LINEA PROC NEAR

@@CICLO6:							

   MOV DX,OFFSET CONTENIDO
   MOV CX,[ANCHO_NUM]
   MOV BX,[HANDLER]
   CALL LeerDeArchivo16Bits
   
   MOV DX,[ALTO_NUM] ;VALOR DE FILA                               ;LEEMOS EL HEADER MAS LA 1ERA FILA
   
   DEC DX
   MOV [ALTO_NUM],DX                                              ;VAMOS A CREAR LAS 480 FILAS EN EL ARCHIVO TXT EN BLANCO
   CMP DX,0
   JA @@CICLO6

   RET
ENDP
;---------------------------------------------------------------------------- 
 HEADER PROC NEAR	            ;LEER EL HEADER CUANDO OCUPAMOS DESPLEGAR ASCII
   PUSH DX

   MOV DX,OFFSET SALVE
   MOV CX,116
   CALL LeerDeArchivo16Bits
                             ;HASTA ACA ESTAMOS LEYENDO SOLO EL HEADER 
							  
   CALL TAMANO
   CALL TAMANO2
   CALL CONVERTIR
 
   CALL DIVIDE2 

   POP DX
   
   RET
ENDP
;----------------------------------------------------------------------------
 IR_A_PRINCIPIO PROC NEAR                     ;NO SE USO
PUSH DX
@@CICLO7:							

   MOV DX,OFFSET CONTENIDO
   MOV CX,[ANCHO_NUM]
   CALL LeerDeArchivo16Bits
   
   MOV DX,[ALTO_NUM] ;VALOR DE FILA                               ;LEEMOS EL HEADER MAS LA 1ERA FILA
   
   DEC DX
   MOV [ALTO_NUM],DX
   CMP DX,0
   JA @@CICLO7
 POP DX  
      RET
ENDP; .
;----------------------------------------------------------------------------

 IDENTIFICAR_PIXEL3 PROC NEAR
   MOV AX,[SI]         ;la lectura presentada tomando como ejemplo un 08h es 
   CMP AH,0                     ;presentada en AX de la siguiente manera: 0800h
   JE @@SEGUIR3
   
   MOV AL,AH          
   XOR AH,AH           ;por lo que intercambiamos AH con AL y borramos AH
   JMP @@SEGUIR4
   
 @@SEGUIR3:                      ;para que AL = AX   
    MOV AL,AH  
	
@@SEGUIR4:	
    CMP AL,0
    JE @@NEGRO3
	
   CALL CONVIERTE2          ;VAMOS A CONVERTIR LOS 4 BYTES DEL AX EN LOS 2 PIXELES DISTINTOS
   
   CMP AL,0
   JE @@NEGRO3   
   CMP AL,01H
   JE @@AZUL3
   CMP AL,02H
   JE @@VERDE3
   CMP AL,03H
   JE @@CYAN3
   CMP AL,04H
   JE @@ROJO3
   CMP AL,05H
   JE @@MAGENTA3
   CMP AL,06H
   JE @@CAFE3   
   CMP AL,07H
   JE @@GRIS3   
   CMP AL,08H
   JE @@GRISS3    
   CMP AL,09H   
   JE @@AZULL3
   CMP AL,0AH
   JE @@VERDEE3
   CMP AL,0BH
   JE @@CYANN3
   CMP AL,0CH
   JE @@ROJOO3
   CMP AL,0DH
   JE @@MAGENTAA3   
   CMP AL,0EH
   JE @@AMARILLO3     
   CMP AL,0FH
   JE @@BLANCO3   
   JMP @@FIN3

@@NEGRO3:  
   MOV DX, OFFSET A0
   JMP @@FIN3
   
@@AZUL3:  
   MOV DX, OFFSET A1
   JMP @@FIN3
   
@@VERDE3:  
   MOV DX, OFFSET A2
   JMP @@FIN3

@@CYAN3:  
   MOV DX, OFFSET A3
   JMP @@FIN3
   
 @@ROJO3:  
   MOV DX, OFFSET A4
   JMP @@FIN3  
   
@@MAGENTA3:  
   MOV DX, OFFSET A5
   JMP @@FIN3   
   
@@CAFE3:  
   MOV DX, OFFSET A6
   JMP @@FIN3   
   
@@GRIS3:  
   MOV DX, OFFSET A7
   JMP @@FIN3 
 
@@GRISS3:  
   MOV DX, OFFSET A8
   JMP @@FIN3 

@@AZULL3:  
   MOV DX, OFFSET A9
   JMP @@FIN3 
 
@@VERDEE3:  
   MOV DX, OFFSET A10
   JMP @@FIN3 
 
@@CYANN3:  
   MOV DX, OFFSET A11
   JMP @@FIN3 
 
 @@ROJOO3:  
   MOV DX, OFFSET A12
   JMP @@FIN3  
   
@@MAGENTAA3:  
   MOV DX, OFFSET A13
  JMP @@FIN3  

@@AMARILLO3:  
   MOV DX, OFFSET A14
   JMP @@FIN3    

@@BLANCO3:  
   MOV DX, OFFSET A15
   JMP @@FIN3  
  
@@FIN3:
   RET
ENDP
;----------------------------------------------------------------------------

 IDENTIFICAR_PIXEL4 PROC NEAR         ;DESPLEGAR EL SEGUNDO PIXEL EN EL TXT
    MOV AH,[PIXEL2]   

    CMP AH,0
    JE @@NEGRO4

   CMP AH,01H
   JE @@AZUL4
   CMP AH,02H
   JE @@VERDE4
   CMP AH,03H
   JE @@CYAN4
   CMP AH,04H
   JE @@ROJO4
   CMP AH,05H
   JE @@MAGENTA4
   CMP AH,06H
   JE @@CAFE4   
   CMP AH,07H
   JE @@GRIS4   
   CMP AH,08H
   JE @@GRISS4    
   CMP AH,09H   
   JE @@AZULL4
   CMP AH,0AH
   JE @@VERDEE4
   CMP AH,0BH
   JE @@CYANN4
   CMP AH,0C0H
   JE @@ROJOO4
   CMP AH,0DH
   JE @@MAGENTAA4   
   CMP AH,0EH
   JE @@AMARILLO4     
   CMP AH,0FH
   JE @@BLANCO4   
   JMP @@FIN4

@@NEGRO4:  
   MOV DX, OFFSET A0
   JMP @@FIN4
   
@@AZUL4:  
   MOV DX, OFFSET A1
   JMP @@FIN4
   
@@VERDE4:  
   MOV DX, OFFSET A2
   JMP @@FIN4

@@CYAN4:  
   MOV DX, OFFSET A3
   JMP @@FIN4
   
 @@ROJO4:  
   MOV DX, OFFSET A4
   JMP @@FIN4  
   
@@MAGENTA4:  
   MOV DX, OFFSET A5
   JMP @@FIN4   
   
@@CAFE4:  
   MOV DX, OFFSET A6
   JMP @@FIN4   
   
@@GRIS4:  
   MOV DX, OFFSET A7
   JMP @@FIN4 
 
@@GRISS4:  
   MOV DX, OFFSET A8
   JMP @@FIN4 

@@AZULL4:  
   MOV DX, OFFSET A9
   JMP @@FIN4 
 
@@VERDEE4:  
   MOV DX, OFFSET A10
   JMP @@FIN4 
 
@@CYANN4:  
   MOV DX, OFFSET A11
   JMP @@FIN4 
 
 @@ROJOO4:  
   MOV DX, OFFSET A12
   JMP @@FIN4  
   
@@MAGENTAA4:  
   MOV DX, OFFSET A13
   JMP @@FIN4  

@@AMARILLO4:  
   MOV DX, OFFSET A14
   JMP @@FIN4    

@@BLANCO4:  
   MOV DX, OFFSET A15
  JMP @@FIN4  
  
@@FIN4:
   RET
ENDP
;----------------------------------------------------------------------------
 SeekEnArchivo PROC NEAR        ;IR AL PRINCIPIO SIEMPRE (AL ES 0 SIEMPRE)

      MOV  CX, 0                  
      MOV  DX, 0                           

      MOV  AH, 42H               
      INT  21H                    
      RET
ENDP; SeekEnArchivo.
;----------------------------------------------------------------------------
 SeekEnArchivo2 PROC NEAR       ;IR AL FINAL SIEMPRE (SIEMPRE AL ES 1)
      CMP  AL, 1
      JE   @@Final
      CMP  AL, 2
      JE   @@InicioDesplazamiento
      CMP  AL, 3
      JE   @@Desplazamiento
   @@Inicio:
      MOV  CX, 0                  
      MOV  DX, 0                  
      JMP  @@HacerElSeek
   @@Final:
      MOV  AL, 2                  
      MOV  CX, 0                  
      MOV  DX, 0                  
      JMP  @@HacerElSeek
   @@InicioDesplazamiento:
          
      JMP  @@HacerElSeek
   @@Desplazamiento:

   @@HacerElSeek:
      MOV  AH, 42H               
      INT  21H                    

      RET
ENDP; SeekEnArchivo.
;---------------------------------------------------------------------------- 

RetornaDOS Macro
    mov ax, 4c00h
    int 21h
EndM
;---------------------------------------------------------------------------- 
AYUDAR PROC FAR                                         ;ESTE PROC ES DONDE VA A DESPLEGAR TODAS LAS AYUDAS
        MOV AH, 09H ;imprime etiqueta de aviso
        LEA DX, ETILIN 
        INT 21H

        MOV AH, 09H
        LEA DX, AYUDA1
        INT 21H

        MOV AH, 09H ;imprime etiqueta de aviso
        LEA DX, ETILIN 
        INT 21H

        MOV AH, 09H
        LEA DX, AYUDA2
        INT 21H

        MOV AH, 09H ;imprime etiqueta de aviso
        LEA DX, ETILIN 
        INT 21H

        MOV AH, 09H
        LEA DX, AYUDA3
        INT 21H

        MOV AH, 09H
        LEA DX, AYUDA4
        INT 21H

        MOV AH, 09H ;imprime etiqueta de aviso
        LEA DX, ETILIN 
        INT 21H

        MOV AH, 09H
        LEA DX, AYUDA5
        INT 21H

        MOV AH, 09H
        LEA DX, AYUDA6
        INT 21H

        MOV AH, 09H
        LEA DX, AYUDA7
        INT 21H

        MOV AH, 09H ;imprime etiqueta de aviso
        LEA DX, ETILIN 
        INT 21H

        MOV AH, 09H
        LEA DX, AYUDA8
        INT 21H

        MOV AH, 09H
        LEA DX, AYUDA9
        INT 21H

        MOV AH, 09H
        LEA DX, AYUDA10
        INT 21H

        MOV AH, 09H ;imprime etiqueta de aviso
        LEA DX, ETILIN 
        INT 21H

        MOV AH, 09H
        LEA DX, AYUDA11
        INT 21H

        MOV AH, 09H
        LEA DX, AYUDA12
        INT 21H

        MOV AH, 09H
        LEA DX, AYUDA13
        INT 21H

        MOV AH, 09H ;imprime etiqueta de aviso
        LEA DX, ETILIN 
        INT 21H

        RET
EndP
;----------------------------------------------------------------------------
VALIDAR PROC FAR
        MOV SI, 80H ;apunta al inicio de la linea de comando

        INC SI ;quita el espacio blanco que sale de primero en linea de comando
        INC SI ;para revisar lo que hay despues del espacio en blanco

        MOV DI, OFFSET ARCHIVO
        


    NOMBRE:                         ;VA A IR MOVIENDO A ARCHIVO EL NOMBRE DE LA IMAGEN
        ;CMP DL, 0
        ;JE AYUDAS2
        MOV DL, BYTE PTR ES:[SI]
        MOV [DI], DL
        CMP DL, '.'
        JE NOMBRE2
        CMP DL, 0
        JE AYUDAS2
        INC DI
        INC SI 
        JMP NOMBRE

    NOMBRE2:                        ;VA A MOVER A ARCHIVO EL '.BMP' FINAL DE LA IMAGEN
        INC DI
        MOV DL, 62H
        MOV [DI], DL ;le mete una b
        INC DI
        MOV DL, 6DH
        MOV [DI], DL; ;le mete una m
        INC DI
        MOV DL, 70H
        MOV [DI], DL ;le mete una p

        INC SI                      ;INCREMENTA 3 PARA AVANZAR A VER LO QUE VIENE DESPUES DEL NOMBRE DE LA IMAGEN
        INC SI
        INC SI

        INC SI ;quita el espacio blanco que sale de primero en linea de comando
        INC SI ;para revisar lo que hay despues del espacio en blanco
        MOV DL, BYTE PTR ES:[SI]
        CMP DL, 2FH ;compara el caracter a ver si es un slash
        JE SLASH ;si no es igual a un slash 

        JMP IMAGEN                  ;BRINCAMOS A DESPLEGAR LA IMAGEN 

    AYUDAS2:

        CALL AYUDAR                 ;LLAMAMOS PARA DESPLEGAR LAS AYUDAS

        RetornaDOS

    SLASH:
        MOV AH, 09H
        LEA DX, ETILIN
        INT 21H

        INC SI ;para revisar que viene despues del slash
        MOV DL, BYTE PTR ES:[SI]
        CMP DL, 3FH ;a ver si es un signo de pregunta
        JE AYUDAS
        CMP DL, 48H ;a ver si es igual a H
        JE AYUDAS
        CMP DL, 68H ;a ver si es igual a h
        JE AYUDAS
        CMP DL, 41H ;a ver si es igual a una A
        JE ASCII
        CMP DL, 61H ;a ver si es igual a una a
        JE ASCII
        CMP DL, 72H ;a ver si es igual a una r
        JE INVERSO

    AYUDAS:
        
        CALL AYUDAR                 ;LLAMAMOS PARA DESPLEGAR LAS AYUDAS

        RetornaDOS

    ASCII:
        JMP TXT                     ;BRINCAMOS A DESPLEGAR LA IMAGEN EN TXT


    INVERSO:
        JMP INVERTIDA               ;BRINCAMOS A DESPLEGAR LA IMAGEN INVERTIDA

        RetornaDOS

ENDP

;---------------------------------------------------------------------------- 

INICIO:
         MOV AX,datos
         MOV DS,AX
         

        CALL VALIDAR

        IMAGEN:
          CALL VIDEO
		      CALL ABRIRARCHIVO
          CALL Leer

		      CALL CERRAR

		      JMP @@FIN5

        INVERTIDA:
          CALL VIDEO
		      CALL ABRIRARCHIVO
          CALL Leer2

		      CALL CERRAR

		      JMP @@FIN5

        TXT:
		      CALL ABRIRARCHIVO
          CALL Leer3

		      CALL CERRAR
		      CALL CERRAR2

		      JMP @@FIN5
          
        @@FIN5:

          MOV AH,4CH
          MOV AL,0
          INT 21H
         
codigo ENDS
END INICIO   