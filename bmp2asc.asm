
include macro.krt

Datos Segment
	etilin db "--------------------------------------------------------------------------------","$"
	ayuda	db	'Usted ha entrado al centro de ayuda',10,13,'$'
	texto	db	'Mostrar txt con el arte ASCII',10,13,'$'
	inversa	db	'Modo inverso',10,13,'$'
	izquierda 	db 	'Rotado a la izquierda',10,13,'$'
	derecha 	db 	'Rotado a la derecha',10,13,'$'
	nombrebmp 	db 	'Deberia ser el nombre de la imagen bmp...',10,13,'$'
Datos EndS

pila segment stack 'stack'
  dw 256 dup(?)
pila endS

Codigo Segment
	Assume cs:codigo, ds:Datos, ss:pila

	main:

		IniciaSegDatos Datos 

		;Validamos etilin,ayuda,texto,inversa,izquierda,derecha,nombrebmp
		mov si, 80h ;apunta al inicio de la linea de comando

      	inc si ;quita el espacio blanco que sale de primero en linea de comando
      	inc si ;para revisar que no haya otro espacio en blanco, lo que llevaria a mandar un mensaje
      	mov dl, byte ptr es:[si]
      	cmp dl, 2Fh ;compara el caracter a ver si es un slash
        je Slash ;si no es igual a un slash 

        cmp dl, 20h ;a ver si es un espacio en blanco

        mov ah, 09h ;imprime etiqueta de aviso
        lea dx, etilin
        int 21h

        mov ah, 09h ;imprime etiqueta de aviso
        lea dx, nombrebmp
        int 21h

        RetornaDOS

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

        RetornaDOS

    Ascii:
        mov ah, 09h
        lea dx, texto
        int 21h


        mov ah, 09h ;imprime etiqueta de aviso
        lea dx, etilin
        int 21h

        RetornaDOS

    Inverso:
        mov ah, 09h
        lea dx, inversa
        int 21h


        mov ah, 09h ;imprime etiqueta de aviso
        lea dx, etilin
        int 21h

        RetornaDOS

    Izquierdo:
        mov ah, 09h
        lea dx, izquierda
        int 21h


        mov ah, 09h ;imprime etiqueta de aviso
        lea dx, etilin
        int 21h

        RetornaDOS

    Derecho:
        mov ah, 09h
        lea dx, derecha
        int 21h


        mov ah, 09h ;imprime etiqueta de aviso
        lea dx, etilin
        int 21h

        RetornaDOS

	;noSlash:
        ;cmp dl, 20h ;a ver si es un espacio en blanco

        ;mov ah, 09h ;imprime etiqueta de aviso
        ;lea dx, etilin
        ;int 21h

        ;mov ah, 09h ;imprime etiqueta de aviso
        ;lea dx, nombrebmp
        ;int 21h

        ;RetornaDOS

Codigo EndS
end main

