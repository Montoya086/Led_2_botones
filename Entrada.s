/* -----------------------------------------------
* UNIVERSIDAD DEL VALLE DE GUATEMALA 
* Organización de computadoras y Assembler
* Ciclo 1 - 2022
* Diego Estuardo Lemus Lopez
* Eunice Mata
* Andres Estuardo Montoya Wilhelm
* Entrada.s
* Programa para encender y apagar un led por medio de dos botones
 ----------------------------------------------- */
 /*---- DATA ----*/
	.text
	.global main
	.extern printf
	.extern wiringPiSetup
	.extern delay
	.extern digitalWrite
	.extern digitalRead
	.extern pinMode
	
main:   
	push 	{ip, lr}
	bl	wiringPiSetupPhys		@@ libreria wiringpi fisica
	mov	r1,#-1					@@ mover -1 a r1
	cmp	r0, r1					@@ si el resultado no es -1
	bne	init					@@ mover a la subrutina init
	ldr	r0, =ErrMsg				@@ si el resultado es -1 mostrar error y terminar
	bl	printf					
	b	done					

@------- set pinMode
init:
	mov r0,#13					@@ pin13
	mov	r1, #INPUT				@@ Configurar como entrada
	bl	pinMode					
	
	mov r0,#15					@@ pin15
	mov	r1, #INPUT				@@ Configurar como entrada
	bl	pinMode					

    mov r0,#16					@@ pin16
	mov	r1, #OUTPUT				@@ Configurar como salida
	bl	pinMode					

/*---- Subrutina que espera al boton 1 ----- */
try1:
	mov r0,#13
	bl 	digitalRead				@@ lee la entrada del pin13
	cmp r0,#0					@@ si la entrada es 0
	beq try1					@@ regresa a la subrutina para volver a intentarlo
	mov r0,#16					@@ si el boton es precionado (lee señal 1)
	mov r1,#1					
	bl digitalWrite				@@ endiende el led por medio del pin 16

/*---- Subrutina que espera al boton 2 ----- */
try2:
	mov r0,#15
	bl 	digitalRead				@@ lee la entrada del pin15
	cmp r0,#0					@@ si la entrada es 0
	beq try2					@@ regresa a la subrutina para volver a intentarlo
	mov r0,#16					@@ si el boton es precionado (lee señal 1)
	mov r1,#0					
	bl digitalWrite				@@ apaga el led
	b try1						@@ regresa a esperar prender el led
done:	
    pop 	{ip, lr}			@@ salida segura

/*---- Data ----*/
.data
.balign 4	
/*---- Mensajes ----*/	 
ErrMsg:	 .asciz	"Setup didn't work... Aborting...\n"
/*---- MEmoria ----*/
delayMs: .int	250
INPUT	 =	0
OUTPUT	 =	1
