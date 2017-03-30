	;* PROJETO DE AC 
	;********************************************************

;***********GRUPO: 
; DIOGO MESQUITA, 	nº 81968
; JOÃO FREITAS, 	nº 81950
; JOSÉ GOMES, 		nº 82015

;**************************************************************************
;*************************** CONSTANTES ***********************************
;**************************************************************************
	
	;******* JOGO ********
	LIMITE_SUP EQU 0			; limite superior de movimento dos objetos no ecra 
	LIMITE_INF EQU 30			; limite inferior de movimento dos objetos no ecra
	LIMITE_ESQ EQU 0			; limite esquerdo de movimento dos objetos no ecra
	LIMITE_DIR EQU 30			; limite direito de movimento dos objetos no ecra
	ISOLA_4 EQU 28				; valor do shift para isolar os primeiros ou ultimos 4 bits 
	PONTUACAO_NIVEL2 EQU 2		; pontuacao necessaria para passar de nivel 
	PONTUACAO_WIN EQU 3			; pontuacao necessaria para ganhar o jogo 


	;******* ECRA ********
	SCREEN EQU 08000H	; endereco do periferico de saida (ecra)
	COLUNA_MEIO EQU 0AH 

	;******* DISPLAYS *******
	DISP_SCORE EQU 0A000H		; display da pontuacao
	DISP_BALAS EQU 06000H		; display do numero de balas disponiveis

	;****** TECLADO ******
	TECLA_POS EQU 1000H     ; endereco onde se guarda a tecla
	TECLA_INATIVA EQU 7		; valor que indica que uma tecla esta inativa
	TECLA_REINICIA EQU 2	; valor que indica que tecla serve para reiniciar jogo
	TECLA_TERMINA EQU 3		; valor que indica que tecla serve para terminar o jogo
	TECLA_DISPARA EQU 4		; vslor que indica que tecla serve para disparar
	POUT2 EQU 0C000H		; endereco do periferico de saida do teclado 
	PIN EQU 0E000H			; endereço do periferico de entrada	    
	FIRST EQU 1H	        ; primeira linha a testar do teclado
	LAST EQU 10H			; ultima linha a testar do teclado

	;****** AVIOES *****
	N_AV_MAX EQU 4			; numero de avioes maximo em cada momento no ecra
	N_CART_MAX EQU 1		; numero de cartuchos maximos num dado momento
	AV_LIN_INIT_1 EQU 1		; linha 1 inicial de um aviao
	AV_LIN_INIT_2 EQU 7		; linha 2 inicial de um aviao 
	AV_COL_INIT EQU 27		; coluna inicial de um aviao
	METE_AVIAO_1 EQU 7		; numero de interrupcoes ate por um novo aviao no nivel 1
	METE_AVIAO_2 EQU 5		; numero de interrupcoes ate por um novo aviao no nivel 2
	VALOR_CARTUCHO_1 EQU 5	; numero de municoes que cada cartucho contem no nivel 1
	VALOR_CARTUCHO_2 EQU 3	; numero de municoes que cada cartucho contem no nivel 2
	N_AV_PASSAR EQU 2	    ; numero de avioes que se o jogador deixar passar perde 

	;***** CANHAO *****
	CANHAO_COL_INIT EQU 14		; coluna inicial do canhao
	CANHAO_LIN_INIT EQU 29		; linha inicial do canhao
	LIMITE_SUP_CANHAO EQU 16	; limite superior de movimento do canhao no ecra 
	
	;***** BALAS *****
	N_BALAS_MAX EQU 8		; numero de balas maximo num dado momento no ecra 
	BALAS_COL_INIT EQU 1	; coluna inicial da bala no ecra em relacao ao canhao (somar) 
	BALAS_LINHA_INIT EQU 1	; linha inicial da bala em relação ao canhao (subtrair)
	MUNICAO_INIT EQU 9	    ; municao inicial permitida ao jogador (na verdade fica o valor em hexa.
							; caso este valor nao seja valido em decimal, é somado 6 ao hexa) 

	;***** COLISOES *****
	N_EXPLO_MAX EQU 3 			; numero maximo de explosoes possiveis

	;***** ECRAS BONITOS *****

	; game over
	LINHA_GAME EQU 9
	COLUNA_G EQU 5
	COLUNA_A EQU 10
	COLUNA_M EQU 16
	COLUNA_E_1 EQU 21 

	LINHA_OVER EQU 18
	COLUNA_O EQU 5
	COLUNA_V EQU 11
	COLUNA_E_2 EQU 16
	COLUNA_R EQU 21 

	;lvls
	LVL_LINHA EQU 6
	L_COLUNA EQU 6
	V_COLUNA EQU 11
	LX_COLUNA EQU 17

	; n avioes que podem passar
	CAVEIRA_LIN EQU 19
	CAVEIRA_COL EQU 22
	AVIAO_COL EQU 12
	IGUAL_COL EQU 17
	MAIOR_COL EQU 1
	NUMERO_COL EQU 6 

	; ecra de vitoria
	WIN_LIN EQU 24
	W_COL EQU 8
	I_COL EQU 13
	N_COL EQU 18
	TACA_LIN1 EQU 11
	TACA_LIN2 EQU 19
	TACA_COL1 EQU 9
	TACA_COL2 EQU 17
	TACA_COL3 EQU 13

	;*******************************
	;* STACK
	;*******************************
	PLACE 2000H
pilha:	TABLE 200H			; stack reservada para pilha
end:						; stack pointer inicialmente aponta para aqui

TAB_I: 						; tabela das interrupcoes
		WORD aviao_int0   	; interrupcao que faz mover o aviao
		WORD bala_int0		; interrupcao que faz mover as balas 
		

	;*******************************
	;* DADOS
	;*******************************

; coisas para os ecras bonitos
g_obj:	STRING	5, 0FH, 8, 0BH, 9, 0FH 		
a_obj:  STRING  5, 0FH, 9, 0FH, 9, 9    	
m_obj:	STRING	5, 11H, 1BH, 15H, 11H, 11H 	
e_obj:	STRING  5, 0FH, 8, 0FH, 8, 0FH 		
o_obj:	STRING	5, 0FH, 9, 9, 9, 0FH 		
v_obj:  STRING  5, 11H, 11H, 0AH, 0AH, 4	
r_obj:  STRING  5, 0FH, 9, 0FH, 0AH, 9 		

l_obj:  	STRING 5, 8, 8, 8, 8, 0FH 		
l1:	STRING	8, 82H, 86H, 82H, 82H, 0F7H, 0, 0, 0		;linha 6, coluna 17
l2:	STRING	8, 87H, 81H, 87H, 84H, 0F7H, 0, 0, 0		;linha 6, coluna 17

obj_1:	STRING	5, 2H, 6H, 2H, 2H, 7H			;linha 19, coluna 6
obj_2:	STRING	5, 7H, 1H, 7H, 4H, 7H			;linha 19, coluna 6
obj_3:	STRING	5, 6H, 1H, 6H, 1H, 6H			;linha 19, coluna 6
obj_4:	STRING	5, 5H, 5H, 7H, 1H, 1H			;linha 19, coluna 6
obj_5:	STRING	5, 7H, 4H, 7H, 1H, 7H			;linha 19, coluna 6


caveira: STRING 5, 0EH, 15H, 1FH, 0EH, 0AH 
igual: STRING 4, 0, 7, 0, 7


maior:	STRING	5, 18H, 6H, 1H, 6H, 18H		;linha 19, coluna 1

taca_1: STRING 8, 3FH, 7FH, 0BFH, 0BFH, 5FH, 0FH, 2, 2
taca_2: STRING 6, 38H, 3CH, 3AH, 3AH, 34H, 20H
taca_3:	STRING 5, 4, 4, 1FH, 0, 0	

w:		STRING	5, 11H, 15H, 15H, 15H, 0AH	;linha 24, coluna 8
i:		STRING	5, 0EH, 4H, 4H, 4H, 0EH		;linha 24, coluna 13
n:		STRING	5, 11H, 19H, 15H, 13H, 11H	;linha 24, coluna 18

; modo do teclado (ON - 1; OFF - 0)
teclado_mode: WORD 1

; numero do gerador
n_gerador: WORD 0
atraso_aviao: WORD 0

; numero de interrupcoes base ate por um novo aviao 
mete_aviao: WORD METE_AVIAO_1				; comeca com o valor do nivel 1

; formas dos objetos
aviao_obj:	STRING 5, 3, 0EH, 1FH, 0EH, 3	; forma das figuras a desenhar
canhao_obj:	STRING 3, 2, 7, 7
bala_obj: STRING 1, 1
explo_obj: STRING 4, 9, 6, 6, 9
cart_obj: STRING 4, 0, 0, 15, 15
quadrado_obj: STRING 6, 0, 0, 0, 0, 0, 0
aviao_obj_2: STRING 4, 3, 0EH, 0EH, 3		; tamanho deste aviao tem de ser mais pequeno
											; que o tamanho do aviao 1
aviao_temp:	STRING 5, 3, 0EH, 1FH, 0EH, 3	; guarda sempre o aviao do primeiro nivel 

; local da memória onde ficam guardadas as posicoes dos objetos em cada momento,
; começando com certas posicoes iniciais

avioes_pos: WORD -1				; aviao 1						
			WORD -1

			WORD -1				; aviao 2
			WORD -1

			WORD -1				; aviao 3
			WORD -1

			WORD -1				; aviao 4						
			WORD -1


balas_pos: WORD -1				; bala 1
			WORD -1

			WORD -1				; bala 2
			WORD -1

			WORD -1				; bala 3
			WORD -1

			WORD -1				; bala 4
			WORD -1

			WORD -1				; bala 5
			WORD -1

			WORD -1				; bala 6
			WORD -1

			WORD -1				; bala 7
			WORD -1

			WORD -1				; bala 8
			WORD -1

explo_pos:	WORD -1				; explosao 1
			WORD -1

			WORD -1				; explosao 2
			WORD -1

			WORD -1				; explosao 3
			WORD -1





canhao_pos: WORD CANHAO_LIN_INIT
			WORD CANHAO_COL_INIT

cart_pos: WORD 0				; indica qual é o endereco do cartucho na memoria 


; flags que indicam se houve interrupcoes
move_aviao: WORD 0
move_bala: WORD 0

; flag para indicar quando por mais um aviao 
acrescenta_aviao: WORD 0

; local para guardar numero de balas e avioes em cada momento
n_avioes_atual: WORD 0
n_balas_atual: WORD 0
n_cartuchos_atual: WORD 0
n_explo_atual: WORD 0
n_av_atual_passar: WORD N_AV_PASSAR 	; endereco que guardo o numero de avioes que
										; o jogador ainda pode deixar passar

; guarda a pontuacao do jogador
score:	WORD 0

; guarda a pontuacao necessaria para o proximo nivel
nivel_seguinte: WORD PONTUACAO_NIVEL2

; guarda a municao do jogador
municao: WORD MUNICAO_INIT

; guarda o valor de cada carucho 
valor_cartucho: WORD VALOR_CARTUCHO_1

; tabela de mascaras para o ecra para isolar 1 bit 
tab_N:  STRING 80H, 40H, 20H, 10H 		; tabela de mascaras indexada pelo N (posicao
		STRING 8H, 4H, 2H, 1H 			; do pixel que queremos acender no byte)

; valores associados a cada tecla
teclas: 
		WORD -1							; tecla 0 - andar na diagonal para cima esquerda
		WORD -1
		
		WORD -1							; tecla 1 - andar para cima a direito
		WORD 0

		WORD -1							; tecla 2 - diagonal cima direita
		WORD 1

		WORD TECLA_INATIVA				; tecla 3 - nao faz nada
		WORD TECLA_INATIVA

		WORD 0							; tecla 4 - anda para a esquerda a direito
		WORD -1	

		WORD TECLA_DISPARA				; tecla 5 - disparar
		WORD TECLA_INATIVA

		WORD 0							; tecla 6 - andar para a direita
		WORD 1

		WORD TECLA_INATIVA				; tecla 7 nao faz nada
		WORD TECLA_INATIVA				

		WORD 1							; tecla 8 - diagonal baixo esquerda 
		WORD -1

		WORD 1							; tecla 9 - anda para baixo
		WORD 0

		WORD 1							; tecla A - diagonal baixo direita
		WORD 1

		WORD TECLA_INATIVA				; tecla B - nada
		WORD TECLA_INATIVA				

		WORD TECLA_INATIVA				; tecla C - nada
		WORD TECLA_INATIVA

		WORD TECLA_INATIVA				; tecla D - nada
		WORD TECLA_INATIVA			

		WORD TECLA_REINICIA				; tecla E - reiniciar o jogo
		WORD TECLA_INATIVA

		WORD TECLA_TERMINA				; tecla F - terminar o jogo 
		WORD TECLA_INATIVA


	;*******************************
	;* CODIGO
	;*******************************
	PLACE 0000H
begin:	
	; Inicializacao de variaveis gerais
	MOV SP, end             	; iniciar o registo do SP
	MOV BTE, TAB_I				; iniciar BTE

	EI0							; permite interrupcoes do tipo 0 (avioes)
	EI1							; permite interrupcoes do tipo 1 (balas)
	EI 							; permite interrupcoes em geral

	CALL apaga_ecra 
	CALL nivel1					; mete imagem do nivel 1
	CALL apaga_ecra
	CALL repoe_canhao			; escreve canhao na posicao inicial
	CALL repoe_display 			; poe os valores iniciais respetivos no display

reinicia_stack:
	MOV SP, end

repi: 
	CALL teclado 				; varre o teclado e guarda a tecla se alguma foi pressionada
	CALL canhao 				; faz tudo relacionado com o canhao (exceto balas) e teclas especiais
	CALL bala 					; tudo relacionado com as balas 
	CALL colisao
	CALL aviao 					; faz tudo relacionado com os avioes (movimento, etc)

	CALL gerador
	
	JMP repi

fim:	JMP fim
	

	;*******************************
	;* ROTINAS
	;*******************************

;**************************************************************************
;********************************* GENÉRICO *******************************
;**************************************************************************
;* -- nivel1 --------------------------------------					
	;*
	;* Descricao: mete a imagem do nivel 1 e espera que a tecla seja premida 
	;*
	;* Parametros: -- 
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
nivel1:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R6
	
	MOV R6, 1		; vou estar sempre a escrever

	MOV R0, LVL_LINHA			; a linha onde escrevo LVL1

	MOV R1, L_COLUNA			; a coluna do L			
	MOV R4, l_obj				 
	CALL escreve_objeto			; escrevo L no ecra

	MOV R1, V_COLUNA			; a coluna do V			
	MOV R4, v_obj 					 
	CALL escreve_objeto			; escrevo V no ecra 

	MOV R1, LX_COLUNA			; a coluna do L1			
	MOV R4, l1 					 
	CALL escreve_objeto			; escrevo L1 no ecra

	CALL escreve_avioes_passar	; escreve o numero de avioes que se passarem o jogador perde

	CALL espera_por_reinicia	; espera que a tecla reinicia seja pressionada	

	POP R6
	POP R4
	POP R2
	POP R1
	POP R0

	RET

;* -- escreve_avioes_passar --------------------------------------					
	;*
	;* Descricao: escreve mais na parte de baixo o numero de avioes que se o 
	;*			  jogador ddeixar passar perde.   
	;*
	;* Parametros: --
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: Se o numero de avioes for maior que 5, não específica o valor  
escreve_avioes_passar:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R6

	MOV R6, 1						; vou estar sempre a escrever

	MOV R2, n_av_atual_passar			
	MOV R2, [R2]					; R2 com o numero a escrever
	CMP R2, 5
	JLE comp_1 				; se num avioes que podem passar for menor ou igual
								; a cinco não escrevo o maior, salto
	; escrevo o maior
	MOV R4, maior
	MOV R0, CAVEIRA_LIN
	MOV R1, MAIOR_COL
	CALL escreve_objeto

; vejo se é o 1
comp_1:
	MOV R0, CAVEIRA_LIN
	MOV R1, NUMERO_COL

	CMP R2, 1
	JNZ comp_2

	; escrevo o 1
	MOV R4, obj_1
	JMP escreve_numero

;vejo se é o 2
comp_2:
	CMP R2, 2
	JNZ comp_3

	; escrevo o 2
	MOV R4, obj_2
	JMP escreve_numero

; vejo se é o 3
comp_3:
	CMP R2, 3
	JNZ comp_4

	; escrevo o 3
	MOV R4, obj_3
	JMP escreve_numero

;vejo se é o 4
comp_4:
	CMP R2, 4
	JNZ comp_5

	; escrevo o 4
	MOV R4, obj_4
	JMP escreve_numero

; vejo se é o 5	
comp_5:
	; escrevo o 5
	MOV R4, obj_5

escreve_numero:
	CALL escreve_objeto

; vou escrever o aviao
MOV R4, aviao_obj
MOV R1, AVIAO_COL
CALL escreve_objeto

; vou escrever o igual
MOV R4, igual
MOV R1, IGUAL_COL
CALL escreve_objeto

; vou escrever a caveira
MOV R4, caveira
MOV R1, CAVEIRA_COL
CALL escreve_objeto
 

	POP R6
	POP R4
	POP R2
	POP R1
	POP R0

	RET

;* -- win --------------------------------------					
	;*
	;* Descricao: apaga o ecra e escreve o ecra de vitoria
	;*
	;* Parametros: -- 
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
win: 

	CALL apaga_ecra 

	; escrevo WIN no ecra 
	MOV R6, 1			; quero estar sempre a escrever
	MOV R0, WIN_LIN		; R0 com a linha em que fica o WIN 

	MOV R1, W_COL		; R1 com a coluna do w
	MOV R4, w
	CALL escreve_objeto	; escrevo o W

	MOV R1, I_COL		; R1 com a coluna do i
	MOV R4, i 
	CALL escreve_objeto	; escrevo o I

	MOV R1, N_COL		; R1 com a coluna do n
	MOV R4, n
	CALL escreve_objeto	; escrevo o N

	; escrevo a taca no ecra 
	MOV R0, TACA_LIN1	; linha da parte de cima da taca

	MOV R1, TACA_COL1	; coluna da primeira parte da taca
	MOV R4, taca_1		; forma da primeira parte da taca
	CALL escreve_objeto	; escrevo a primeira parte da taca

	MOV R1, TACA_COL2	; coluna da segunda parte da taca
	MOV R4, taca_2		; forma da segunda parte da taca
	CALL escreve_objeto	; escrevo a segunda parte da taca

	MOV R0, TACA_LIN2 	; linha da parte de baixo da taca
	MOV R1, TACA_COL3	; coluna da parte de baixo da taca
	MOV R4, taca_3		; forma da parte de baixo da taca
	CALL escreve_objeto	; escrevo a parte de baixo da taca

	CALL espera_por_reinicia

	; reinicio totalmente
	MOV R0, 1
	CALL reinicia 

	JMP begin 

	RET  

;* -- muda_nivel --------------------------------------					
	;*
	;* Descricao: muda de nivel para o nivel adequado
	;*
	;* Parametros: -- 
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: assume que a pontuacao de algum nivel foi atingida 
muda_nivel:
	PUSH R0
	PUSH R1

	MOV R0, nivel_seguinte
	MOV R0, [R0]			; R0 com a pontuacao do nivel seguinte
	
	MOV R1, PONTUACAO_NIVEL2

	CMP R0, R1
	JZ nivel_2				; se a pontuacao do nivel seguinte e a do nivel 2, salta

	CALL win
	; aqui sei que o jogador venceu, visto que só há dois niveis 
nivel_2:
	CALL nivel2 

go_out:
	POP R1
	POP R0

	RET 

;* -- game_over --------------------------------------					
	;*
	;* Descricao: apaga o ecra e escreve game over no ecra. Espera ate a tecla
	;*			  de reinicio do jogo volte a ser premida 
	;*
	;* Parametros: -- 
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
game_over:

	CALL apaga_ecra				; apaga o ecra

	MOV R6, 1					; vou estar sempre a escrever

	MOV R0, LINHA_GAME			; a linha onde escrevo GAME no R0

	MOV R1, COLUNA_G			
	MOV R4, g_obj					 
	CALL escreve_objeto			; escrevo G no ecra

	MOV R1, COLUNA_A			
	MOV R4, a_obj					 
	CALL escreve_objeto			; escrevo A no ecra

	MOV R1, COLUNA_M			
	MOV R4, m_obj				 
	CALL escreve_objeto			; escrevo M no ecra

	MOV R1, COLUNA_E_1			
	MOV R4, e_obj					 
	CALL escreve_objeto			; escrevo E no ecra

	MOV R0, LINHA_OVER			; a linha onde escrevo OVER no R0

	MOV R1, COLUNA_O			
	MOV R4, o_obj					 
	CALL escreve_objeto			; escrevo o no ecra

	MOV R1, COLUNA_V			
	MOV R4, v_obj					 
	CALL escreve_objeto			; escrevo V no ecra

	MOV R1, COLUNA_E_2			
	MOV R4, e_obj					 
	CALL escreve_objeto			; escrevo E no ecra

	MOV R1, COLUNA_R			
	MOV R4, r_obj					 
	CALL escreve_objeto			; escrevo R no ecra

	CALL espera_por_reinicia 

; se a tecla reinicia foi pressionada, reinicio o jogo totalmente 
	MOV R0, 1			; com o modo 1 do reinicia
	CALL reinicia

	JMP begin 

	RET

;* -- espera_por_reinicia --------------------------------------					
	;*
	;* Descricao: espera que a tecla reincia seja premida 
	;*
	;* Parametros: -- 
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: apenas aguenta o programa ate que a tecla reinicia seja premida 
espera_por_reinicia:
	PUSH R3

infinito:						; loop infinito a espera da tecla
	CALL teclado 				; leio o teclado

	MOV R3, TECLA_POS			; R3 com a posicao da tecla pressionada
	MOV R3, [R3]				; R3 com a tecla pressionada

	CALL getMovimento 			; R3 com o significado da tecla premida 

	CMP R3, TECLA_REINICIA							
	JNZ infinito				; continuo no ciclo, se nao é para reiniciar

	POP R3

	RET

;* -- reinicia --------------------------------------					
	;*
	;* Descricao: limpa o ecra, todas as posicoes de memoria relacionadas com 
	;*			  o canhao, avioes, balas e gerador. Se for com o modo de 
	;*			  reiniciar o jogo, tambem reinicia a pontuacao, as municoes
	;*			  e o numero de avioes que podem passar ate perder. Caso
	;*			  contrário, se quiser mudar de nível, estas ultimas inicializacoes
	;*			  não são efetuadas 
	;*
	;* Parametros: R0 - modo que se quer. Se for para reiniciar o jogo este valor
	;*				    deve ser 1. Se for apenas para mudar de nivel este valor
	;*					deve ser 0. 
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
reinicia:
	CALL apaga_ecra				; apaga o ecra para comecar novo jogo
 	
 	; repõe a posicao inicial de todos os objetos na memoria
	CALL repoe_canhao		
	CALL repoe_aviao
	CALL repoe_balas
	CALL repoe_gerador

	; a partir se for para apagar tudo, apago, se nao salto
	CMP R0, 0
	JZ n_altera

	; se for para reiniciar o jogo, então executa as seguintes
	CALL repoe_pontuacao
	CALL repoe_display


n_altera:

	RET 


;* -- getMovimento --------------------------------------					
	;*
	;* Descricao: de acordo com a tecla pressionada, devolve aquilo que essa
	;*              tecla siginifica (por exemplo anda para cima, para baixo, 
	;* 				reiniciar, terminar o jogo, etc)
	;*     
	;* Parametros: R3 - tecla que foi premida
	;*
	;* Retorna: R3 - valor da linha a mover ou significado especial das teclas especiais
	;*          R5 - valor da coluna a mover
	;*
	;* Destroi: R3, R5
	;* Notas: --
getMovimento:
	PUSH R0

	MOV R0, teclas 		; R0 com o endereco onde se encontra os valores associados a cada tecla
	MOV R5, 4			; R5 apenas a segurar o valor para multiplicar
	MUL R3, R5			; R3 com a posicao da tecla premida na tabela das teclas
	ADD R0, R3			; R0 com o endereco do valor a que corresponde a tecla premida
	MOV R3, [R0]		; R3 com o valor da linha associado a tecla premida
	ADD R0, 2
	MOV R5, [R0]			; R5 com o valor da coluna associado a tecla premida

	POP R0
	RET

;* -- hexa_to_dec --------------------------------------					
	;*
	;* Descricao: implementa um truque para passar de hexadecimal para decimal
	;*			  de forma que não se note nos displays
	;*     
	;* Parametros: R4 - numero a converter
	;*			   R5 - se quero somar (R5 = 1) ou subtrair (R5 = 0)
	;*
	;* Retorna: R4 - valor mudado
	;*
	;* Destroi: R4
	;* Notas: --
hexa_to_dec:
	PUSH R0
	PUSH R1
	PUSH R3

	MOV R0, 9			; R0 com o numero maximo de representar em decimal
	MOV R1, R4			; vou alterar o valor de entrada, por isso mantenho 
						; o original no R4
	MOV R3, 0FH			; mascara para isolar os primeiros 4 bits 
	AND R1, R3			; isolo os primeiros 4 bits 

	CMP R0, R1
	JGE ok				; se os primeiros 4 bits forem menor que 9 saio

	; primeiros 4 bits maiores que nove
	MOV R1, 6			; diferenca entra hexa e decimal 
	CMP R5, 0			
	JZ subtracao		; se R5 for 0, subtraio 

	; se é 1, somo
	ADD R4, R1
	JMP ok

subtracao:
	SUB R4, R1

ok:
	POP R3
	POP R1
	POP R0

	RET


;* -- get_objeto_livre --------------------------------------					
	;*
	;* Descricao: retorna o endereço do primeiro objeto livre,
	;*            ou seja, que não está escrito no ecrã (o seu valor é -1).
	;*
	;* Parametros: R3 - endereco da tabela do objeto que se quer encontrar 
	;*
	;* Retorna: R3 - endereço do objeto livre na memória
	;* Destroi: R3
	;* Notas: assume que há pelo menos um objeto livre!
get_objeto_livre:
	PUSH R2

repe: 
	MOV R2, [R3]			; coloco em R2 o valor que o objeto tem (a sua posicao 
							; ou -1 se estiver inativa)
	ADD R3, 4				; avanco R3 para o endereco do objeto seguinte 

	CMP R2, -1	
	JNZ repe 				; se já encontrei um objeto livre acabo, se não vejo o próxima

	SUB R3, 4				; tinha avançado o endereço demais, por isso agora recuo 

	POP R2

	RET

;* -- atualiza_objeto --------------------------------------					
	;*
	;* Descricao: atualiza a posicao de um objeto na memoria. 
	;*
	;* Parametros: R0 - linha do objeto a escrever na memoria
	;* 			   R1 - coluna do objeto a escrever na memória
	;*			   R3 - endereco do objeto na memoria  
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
atualiza_objeto:
	PUSH R3

	MOV [R3], R0			; escrevo a linha na bala correspondente
	ADD R3, 2				; R2 com o endereco da coluna da bala que quero alterar
	MOV [R3], R1			; escrevo a coluna na bala correspondente

	POP R3

	RET

;* -- ativa_objeto --------------------------------------					
	;*
	;* Descricao: ativa um objeto na memória - coloca na sua posicao de memoria
	;* 			  as suas novas coordenadas e incrementa o numero de objetos ativos
	;*
	;* Parametros: R0 - linha do novo objeto
	;* 			   R1 - coluna do novo objeto 
	;*			   R3 - endereco do objeto na memoria
	;*			   R8 - endereco que contem o numero de objetos ativos   
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
ativa_objeto:
	PUSH R0

	CALL atualiza_objeto		; atualizo a posicao do objeto na memoria

	MOV R0, [R8]				; R0 com o numero de objetos ativos
	ADD R0, 1					; incremento o numero de objetos ativos
	MOV [R8], R0				; atualizo esse numero na memoria 

	POP R0

	RET

;* -- nivel2 --------------------------------------					
	;*
	;* Descricao: mete a imagem do nivel 2 e espera que a tecla seja premida.
	;*			  Também troca os aviões, mete o cartucho a dar menos balas e
	;*			  diminui o tempo que os aviões demoram a entrar e muda a 
	;* 			  pontuacao necessaria para o proximo nivel. 
	;*
	;* Parametros: -- 
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
nivel2:
	
	CALL apaga_ecra

	MOV R5, 1	
	CALL troca_aviao 			; meto o aviao do segundo nivel

	; diminuir o numero de municoes de cada cartucho 
	MOV R0, valor_cartucho 	; R6 com o endereco que tem quanto cada cartuche vale
	MOV R1, VALOR_CARTUCHO_2	; R1 com o valor dos cartuchos para o segundo nivel
	MOV [R0], R1 				; faco essa mudanca na memoria 

	; aumentar a frequencia com que aparecem avioes 
	MOV R0, mete_aviao 			; R0 com o endereco do valor do atraso dos avioes 
	MOV R1, METE_AVIAO_2
	MOV [R0], R1				; meto o atraso do nivel 2 (mais curto)

	; atualiza a pontuacao necessaria para alcancar o proximo nivel 
	MOV R0, nivel_seguinte
	MOV R1, PONTUACAO_WIN		; atualiza a pontuacao para o proximo nivel 
	MOV [R0], R1				 

	; escreve a pagina do nivel 2
	MOV R6, 1					; vou estar sempre a escrever

	MOV R0, LVL_LINHA			; a linha onde escrevo LVL2

	MOV R1, L_COLUNA			; a coluna do L			
	MOV R4, l_obj				 
	CALL escreve_objeto			; escrevo L no ecra

	MOV R1, V_COLUNA			; a coluna do V			
	MOV R4, v_obj 					 
	CALL escreve_objeto			; escrevo V no ecra 

	MOV R1, LX_COLUNA			; a coluna do L2			
	MOV R4, l2 					 
	CALL escreve_objeto			; escrevo L2 no ecra

	CALL escreve_avioes_passar	; escreve o numero de avioes que se passarem o jogador perde

	CALL espera_por_reinicia	; espera que a tecla reinicia seja pressionada

	MOV R0, 0				; aqui quero o modo 0, porque quero manter a pontucao
	CALL reinicia

	JMP reinicia_stack 

	RET

;* -- inativa_objeto --------------------------------------					
	;*
	;* Descricao: inativa um objeto na memória - coloca -1 nas suas posicoes - 
	;*			  e decrementa o numero de objetos ativos. 
	;*
	;* Parametros: R3 - endereco do objeto na memoria
	;*			   R8 - endereco que contem o numero de objetos ativos   
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: apenas altera o valor das posicoes do objeto na memoria para -1 e 
	;*		  decrementa o numero de objetos ativos na memoria
inativa_objeto:	
	PUSH R0
	PUSH R1

	MOV R0, -1				; coloco -1 nos valores da linha e coluna para 
	MOV R1, -1				; assignalar quer o objeto é inativo

	CALL atualiza_objeto	; atualizo o objeto na memória

	MOV R0, [R8]			; R0 com o numero de objetos ativos desatualizado
	SUB R0, 1				; decrementamos esse numero, visto que desativamos um objeto
	MOV [R8], R0			; atualizamos esse numero na memoria  

	POP R1
	POP R0

	RET

;* -- inativa_todos --------------------------------------					
	;*
	;* Descricao: repoe posicao inicial de todos os objetos ativos numa
	;*			  determinada tabela de objetos. Ou seja, poe todos os
	;* 			  elementos dessa tabela com o valor de inativo (-1)
	;*     
	;* Parametros: R3 - o endereco da tabela
	;*			   R8 - o endereco do numero de objetos ativos 
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
inativa_todos:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3

	MOV R2, [R8]		; R2 com numero de objetos ativos
	MOV R1, -1			; R1 com o valor de teste e que simboliza inativo

go_around:
	CMP R2, 0
	JZ done 			; se o numero de objetos ativos é zero terminei

	MOV R0, [R3]		; R0 com a linha do objeto
	CMP R0, R1			
	JZ jump				; se objeto ja esta inativo, passo ao proximo 

	; se objeto esta ativo 
	CALL inativa_objeto		; ponho na memoria que esta inativo e atualizo o numero
						; de objetos ativos na memoria 

	SUB R2, 1			; decremento o contador

jump:
	ADD R3, 4			; R1 com endereco do proximo objeto
	JMP go_around	

done:
	POP R3
	POP R2
	POP R1
	POP R0

	RET

;* -- mete_display --------------------------------------					
	;*
	;* Descricao: coloca num display o valor pretendido
	;*     
	;* Parametros: R4 - valor que pretende que seja colocado
	;*			   R2 - endereco do display 
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
mete_display:
	
	MOVB [R2], R4				; escrevo no display
	RET

;* -- repoe_display --------------------------------------					
	;*
	;* Descricao: reinicia o valor dos displays. O display da pontuacao a 0 e
	;*			  o display das balas com o numero inicial definido
	;*     
	;* Parametros: -- 
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
repoe_display:
	PUSH R4
	PUSH R2
	PUSH R5

	MOV R4, 0				; valor inicial da pontuacao
	MOV R2, DISP_SCORE
	CALL mete_display		; mete 0 no display da pontuacao

	MOV R4, MUNICAO_INIT	; R4 com municao inicial
	MOV R5, 1
	MOV R2, DISP_BALAS

	CALL hexa_to_dec		; transformo o numero em decimal 
	CALL mete_display		; mete a municao inicial no display

	POP R5
	POP R2
	POP R4

	RET

;* -- repoe_pontuacao --------------------------------------					
	;*
	;* Descricao: repoe a pontuacao, o numero de avioes que se o jogador deixa
	;*   		  passar perde, a municao, a pontuacao necessaria para o nivel
	;*            seguinte, o valor do atraso dos avioes e o numero de balas que
	;*			  cada cartucho dá para os seus valores iniciais. 
	;*			  Tambem repoe o aviao incial. 
	;*     
	;* Parametros: --
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
repoe_pontuacao:
	PUSH R3
	PUSH R8
	PUSH R5

	; reponho o numero de balas de um cartucho 
	MOV R3, valor_cartucho 	; R3 com o endereco que tem quanto cada cartuche vale
	MOV R5, VALOR_CARTUCHO_1	; R5 com o valor dos cartuchos para o primeiro nivel 
	MOV [R3], R5 				; faco essa mudanca na memoria 

	; reponho o atraso de um aviao 
	MOV R3, mete_aviao
	MOV R5, METE_AVIAO_1
	MOV [R3], R5

	; reponho municao 
	MOV R3, municao			; R3 com a municao
	MOV R8, MUNICAO_INIT	; R8 com a municao inicial
	MOV [R3], R8			; reponho a municao inicial na memoria

	;reponho o numero de avioes que podem passar
	MOV R3, n_av_atual_passar 	;R3 com o endereco dos avioes que se o jogador
								; deixa passar perde			 
	MOV R8, N_AV_PASSAR		; R8 com o numero inicial de avioes que pode deixar passar
							; mais um (so pode deixar passar N_AV_PASSAR - 1)
	MOV [R3], R8			; reinicio esse valor na memoria 

	; reponho a pontuacao
	MOV R3, score 			; R3 com o endereco que guarda o score
	MOV R8, 0
	MOV [R3], R8			; coloco 0 no score, para inciciar

	; reponho a pontuacao nivel seguinte 
	MOV R3, nivel_seguinte	
	MOV R8, PONTUACAO_NIVEL2	; R8 com o valor inicial da pontuacao para a primeira
								; subida de nivel
	MOV [R3], R8				; inicializo esse valor

	MOV R5, 0
	CALL troca_aviao		; meto o aviao do primeiro nivel no aviao_obj  

	POP R5
	POP R8
	POP R3

	RET


;**************************************************************************
;********************************* COLISOES *******************************
;**************************************************************************

;* -- colisao --------------------------------------					
	;*
	;* Descricao: verifica se ocorreu alguma colisão e se sim, faz as mudanças 
	;*			  necessárias na memória e atualiza tudo e mete uma explosao
	;*			  no ecrã
	;*
	;* Parametros: --
	;*
	;* Retorna: -- 
	;* Destroi: --
	;* Notas: --
colisao:
	
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R5
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10

	; antes de mais apago alguma explosao, se houver (sempre que ocorre interrup do aviao)
	MOV R0, move_aviao			
	MOV R1, [R0]				; R1 com a flag que indica se houve ou nao interrupcao
	CMP R1, 0
	JZ verifica_colisao			; se nao houve interrupcao, salto e nao apago

	; se houve interrupcao, apago uma explosao se houver		
	CALL apaga_colisao			; antes de mais apago alguma colisao que possa haver

verifica_colisao:
	MOV R3, balas_pos			; R3 com o endereco da tabela de balas
	MOV R5, LIMITE_SUP_CANHAO	; R5 com o limite onde nao andam avioes
	MOV R7, 0					; vai ser o contador - diz me quando terminei
	MOV R8, n_balas_atual		; R8 com o endereco do numero de balas ativas
	MOV R9, [R8]				; R9 com o numero de balas ativas
	MOV R10, -1					; R10 com o valor de inatividade do objeto  

cicl_balas:
	CMP R7, R9
	JGE good_to_go				; se já vi todas as balas bazo

	MOV R0, [R3]				; R0 com a linha da bala a testar
	CMP R0, R10
	JZ seguinte 				; se a bala esta inativa passo a bala seguinte 

	ADD R7, 1					; a bala está ativa, por isso atualizo contador

	CMP R0, R5
	JGE seguinte 				; se a linha ainda nao chega aos avioes passo
								; a proxima bala
	ADD R3, 2					; vou buscar o endereco da coluna da bala
	MOV R1, [R3]				; R1 com a coluna da bala 

	SUB R3, 2					; volto ao endereco da bala

	CALL teste_colisao			; retorna em R2 1 se houve explosão e 0 se não houve 

	CMP R0, R10
	JNZ houve_explo				; se R0 nao for -1, houve explosao, logo salto

seguinte:
	ADD R3, 4					; R3 com endereco da proxima bala
	JMP cicl_balas

houve_explo:
	CALL inativa_objeto			; inativo a bala em questão
	JMP seguinte 				; vou ver so houve mais colisoes com outras balas 

good_to_go:
	POP R10
	POP R9
	POP R8
	POP R7
	POP R5
	POP R3
	POP R2
	POP R1
	POP R0

	RET 

;* -- colisao --------------------------------------					
	;*
	;* Descricao: verifica se ocorreu alguma colisão entre uma bala específica e um qualquer avião
	;*
	;* Parametros: R0 - linha em que a bala a testar se encontra
	;* 			   R1 - coluna em que a bala a testar se encontra  
	;*
	;* Retorna: R0 - linha do aviao que embateu, caso tenha havido colisao. Se 
	;*			     não houve colisao retorna em R0 -1
	;*
	;* Destroi: R0
	;* Notas: atualiza na memoria tuddo relacionado com o aviao caso tenha havido colisao 
teste_colisao:
	PUSH R10
	PUSH R9
	PUSH R8
	PUSH R7
	PUSH R6
	PUSH R5
	PUSH R4
	PUSH R3
	PUSH R2
	PUSH R1

	MOV R2, 0				; R2 sera o contador que diz quando terminei
	MOV R3, avioes_pos		; R3 com o endereco da tabela dos avioes 
	MOV R8, n_avioes_atual	; R8 com o endereço do numero de avioes atual 
	MOV R5, [R8]			; R5 com o numero de avioes atual (ativos)
	MOV R10, -1				; R10 valor que significa inatividade 
	MOV R4, aviao_obj		; R4 com a tabela que especifica a forma do aviao
	MOVB R4, [R4]			; R4 com a dimensao que um aviao ocupa em numero de 
							; pixeis

	MOV R6, R0				; R6 fica com a linha da bala a testar
	MOV R7, R1				; R7 fica com a coluna da bala

loop_aviao:
	CMP R2, R5
	JGE nada				; se já vi todos os aviões, salto (não houve colisão)

	MOV R0, [R3]			; R0 com a linha do aviao
	CMP R0, R10
	JZ fim_loop				; se o aviao esta inativo vou para o proximo

	; aqui sei que o aviao esta ativo 
	ADD R3, 2				; R3 com o endereco da coluna do aviao
	MOV R1, [R3]			; R1 com a coluna do aviao 

	SUB R3, 2				; volto a por R3 a apontar para o aviao 
	ADD R2, 1				; adiciono 1 ao contador 

	; testes de colisao 
	MOV R9, R0				
	ADD R9, R4				; R9 com linha mais em baixo que o aviao ocupa

	CMP R0, R6			
	JP fim_loop			; se bala esta por cima do aviao, não há colisão

	CMP R6, R9
	JP fim_loop			; se a bala esta por baixo, não há colisão 

	MOV R9, R1
	ADD R9, R4				; R9 com a coluna mais a direita que o aviao ocupa

	CMP R1, R7
	JP fim_loop 			; se a bala a esquerda, não há colisão

	CMP R7, R9
	JP fim_loop				; se a bala esta a direita, não há colisão

	;chegados aqui houve colisao!
	MOV R5, cart_pos
	MOV R5, [R5]			; R5 com o endereco do cartucho na memoria
	MOV R9, score  			; R9 com o endereço da pontuaçao atual
	MOV R10, [R9]			; R10 com a pontuação total 

	CALL inativa_objeto		; inativo o aviao que embateu

	CMP R3, R5
	JNZ escreve_explo		; se não forem iguais, é porque não foi um cartucho,
							; logo salto esta parte
	; aqui foi um cartucho, logo tenho que o desativar e atualizar o numero de municoes 
	CALL inativa_cartucho

	MOV R5, municao 		; R5 com o endereco das municoes do jogador
	MOV R4, [R5]			; R4 com as municoes do jogador

	MOV R6, valor_cartucho 	; R6 com o endereco que tem quanto cada cartuche vale 
	MOV R6, [R6]			; R6 com quantas municoes um cartucho contem 

	ADD R4, R6	; adiciono valor_cartucho ao numero de municoes
	MOV R2, DISP_BALAS		; R2 com o endereco do display das balas 

	MOV R5, 1				; modo do hexa_to_dec é somar
	CALL hexa_to_dec		

	MOV R5, municao
	MOV [R5], R4			; atualizo o valor na memoria 

	CALL mete_display		; atualizo o display das balas 

	SUB R10, 1				; decremento a pontuacao total, porque acertei num cartucho
							; quero que ela se mantenha (aseguir ela é incrementada)	

escreve_explo:
	MOV R4, quadrado_obj
	MOV R6, 1
	CALL escreve_objeto		; apago as cenas todas naquela regiao 

	MOV R4, explo_obj
	CALL escreve_objeto		; escrevo uma explosao no ecra

	MOV R3, explo_pos		; R3 com o endereco da tabela de explosoes 
	CALL get_objeto_livre	; vamos buscar o endereco de uma explosao inativa

	MOV R8, n_explo_atual	; R8 com o endereco do numero de explosoes atual
	CALL ativa_objeto		; ativo a explosao na memoria e incremento o 
							; o numero de explosoes ativas

	ADD R10, 1				; atualizo a pontuacao
	MOV [R9], R10			; atualizo a pontuacao na memoria 

	MOV R4, R10				; argumentos de entrada da mete_display
	MOV R2, DISP_SCORE		

	MOV R5, 1
	CALL hexa_to_dec		; transformo o valor em hexa para "decimal", para aparecer no display
	CALL mete_display		; coloco a pontuacao atualizada no display

	MOV R0, nivel_seguinte	; R0 com o endereco que tem a pontuacao necessaria para o prox nivel
	MOV R0, [R0]			; R0 com a pontuacao necessaria para o proximo nivel

	CMP R10, R0
	JN teste_feito			; se a pontuacao ainda nao chegou ao nivel seguinte, saio

	; aqui sei que já  atingi a pontuacao necessaria para o proximo nivel
	CALL muda_nivel  

	JMP teste_feito

fim_loop:
	ADD R3, 4				; R3 com o endereco do proximo aviao 
	JMP loop_aviao

nada: 
	MOV R0, R10				; se estou aqui, é porque não houve colisão
							; logo ponho -1 no R0 

teste_feito:
	POP R1
	POP R2
	POP R3
	POP R4
	POP R5
	POP R6
	POP R7
	POP R8
	POP R9
	POP R10

	RET

;* -- apaga_colisao --------------------------------------					
	;*
	;* Descricao: apaga uma colisao 
	;*
	;* Parametros: --  
	;*
	;* Retorna: --
	;*
	;* Destroi: R0
	;* Notas: faz todas as atualizacoes necessarias depois de apagar a colisao 
apaga_colisao:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R8

	MOV R3, explo_pos		; R3 com o endereco da tabela de explosoes
	MOV R8, n_explo_atual	; R8 com o endereco do numero de explosoes ativas
	MOV R5, N_EXPLO_MAX		; R5 com o numero maximo de explosoes possiveis
	MOV R2, 0				; se nenhuma explosao ativa, R2 diz quando ja vi todas
	MOV R4, -1				; R4 com a flag que indica se esta inativo
	;ciclo para encontrar explosao ativa 
cicl_explo:
	CMP R2, R5
	JGE get_out				; se já vi todas as explosoes saio

	ADD R2, 1				; se não vi todas, atualizo contador e vejo a proxima

	MOV R0, [R3]			; R0 com a linha da explosao
	CMP R0, R4
	JZ cicl_end				; se explosao esta inativa, passo a proxima

	; aqui sei que esta ativa, por isso apago-a, atualizo na memoria e saio
	ADD R3, 2				; R3 com o endereco da coluna da explosao
	MOV R1, [R3]			; R1 com a coluna da explosao

	SUB R3, 2				; ponho R3 a apontar novamente para a explosao 

	MOV R4, explo_obj
	MOV R6, 0
	CALL escreve_objeto		; apago a explosao

	CALL inativa_objeto		; ponho esta explosao inativa 

	JMP get_out 			; terminei

cicl_end:
	ADD R3, 4				; R3 com o endereco da proxima explosao
	JMP cicl_explo 

get_out:
	POP R8
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0

	RET

;**************************************************************************
;********************************* GERADOR ********************************
;**************************************************************************
;* -- gerador --------------------------------------					
	;*
	;* Descricao: incrementa o valor do gerador na memória  
	;*
	;* Parametros: --
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
gerador:
	PUSH R0
	PUSH R1

	MOV R0, n_gerador		; R0 com o endereco que guarda o numero do gerador
	MOV R1, [R0]			; R1 com o numero que esta no gerador 
	ADD R1, 1				; incrementa-se o numero
	MOV [R0], R1 			; atualiza-se o numero na memoria 

	POP R1
	POP R0
	RET

;* -- repoe_gerador --------------------------------------					
	;*
	;* Descricao: repoe valor inicial do gerador  
	;*
	;* Parametros: --
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
repoe_gerador:
	PUSH R0
	PUSH R1

	MOV R0, n_gerador		
	MOV R1, 0
	MOV [R0], R1

	POP R1
	POP R0
	RET

;* -- gera_aleatorio --------------------------------------					
	;*
	;* Descricao: gera um numero aleatorio entre 0 e 3
	;*
	;* Parametros: R6 - indica o modo que se quer e só há duas opções: 0 ou 1.
	;*			        Se for 0, então a função retorna um número aleatório 
	;*					entre 0 e 1; se for 1 a função retorna um valor aleatório
	;*					entre 0 e 3.
	;*
	;* Retorna: R6 - numero aleatorio ou entre 0 e 1 ou entre 0 e 3, dependendo do input
	;* Destroi: --
	;* Notas: assume que R6 é 0 ou 1
gera_aleatorio:
	PUSH R0

	CMP R6, 0
	JNZ quatro 				; se for 1 salta

	;se for 0 a máscara será 1, para isolar o primeiro bit do numero do gerador
	MOV R6, 1
	JMP gera

quatro: 					; se for 1, a mascara será 3
	MOV R6, 3				; R6 com a mascara para isolar os dois primeiros bits
							; de um determinado numero aplicando um AND
gera:
	MOV R0, n_gerador		; R0 com o endereco do numero do gerador
	MOV R0, [R0]			; R0 com o numero do gerador 

	AND R6, R0				; aplico a mascara no gerador, guardando o valor em R6
	
	POP R0
	RET


;**************************************************************************
;********************************* AVIAO **********************************
;**************************************************************************

;* -- aviao --------------------------------------					
	;*
	;* Descricao: move o aviao caso tenha havido uma interrupcao e atualiza
	;*				a sua posicao na memoria
	;*
	;* Parametros: --
	;*
	;* Retorna: --
	;*
	;* Destroi: --
	;* Notas: --

aviao:
	PUSH R6
	PUSH R0
	PUSH R1
	PUSH R4
	PUSH R2
	PUSH R3
	PUSH R5
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10

	MOV R0, move_aviao 		; R0 com o endereco de memoria que diz se é para
								; mover os avioes ou nao
	MOV R1, [R0]			; R1 com a flag (1 se ocorreu interrupcao e 0 se não)

	CMP R1, 0				; se não ocorreu interrupcao sai
	JZ  en

	MOV R1, 0				; se ocorreu, repor flag a 0, mover aviao e escrever aviao
	MOV [R0], R1

	CALL novo_aviao 		; escrevo um novo aviao

	MOV R2, 0				; contador, diz quando terminei de ver todos os avioes
	MOV R3, avioes_pos  	; R3 com o endereço onde estão as pos dos avioes
	MOV R4, aviao_obj		; R4 com a forma do aviao
	MOV R8, n_avioes_atual	; R8 com o endereco do numero de avioes ativos
	MOV R7, [R8]			; R7 com o numero de avioes que terao de ser atualizados
	MOV R5, -1				; R5 com a flag que indica se um aviao esta inativo
	MOV R9, LIMITE_ESQ		; R9 com o limite esquerdo ate ao qual os avioes podem ir
	MOV R10, cart_pos		; R10 com o endereco do endereco da posicao do cartucho na memoria 
	MOV R10, [R10]			; R10 com o endereco da posicao do cartucho na memoria 

cicl_aviao:
	CMP R2, R7
	JGE en 					; se ja vi todos os avioes, sai

	MOV R0, [R3]			; R0 com a linha do aviao 
	CMP R0, R5
	JZ conti 				; se este aviao esta inativo, repito ciclo com o proximo

	ADD R3, 2				; vou buscar o endereco da coluna deste aviao
	MOV R1, [R3]			; coloco a coluna do aviao no R1 

	ADD R2, 1				; atualizo contador
	SUB R3, 2				; volto ao endereco que aponta para o aviao em causa

	MOV R6, 0
	CALL escreve_objeto		; apago o aviao

	CMP R3, R10
	JNZ normal				; se a posicao atual não é um cartucho, continuo

	;se é um cartucho, tenho de escrever um cartucho
	MOV R4, cart_obj

normal:
	SUB R1, 1				; atualizo a coluna 
	CMP R1, R9 
	JN aviao_inativo		; se aviao chegou ao fim do ecra, salto para essa parte 

	;se não chegou ao fim, escrevo-o na nova posicao e atualizo a sua posicao na memoria
	MOV R6, 1
	CALL escreve_objeto

	CALL atualiza_objeto
	JMP conti 

aviao_inativo:
	CMP R3, R10
	JNZ normal2				; se a posicao atual não é um cartucho, salto

	;se é um cartucho, tenho que indicar que este desapareceu
	CALL inativa_cartucho
	JMP normal2_cont

normal2:
	CALL atualiza_avioes_passaram		; decrementa o numero de avioes que o 
										; jogador pode deixar passar e testa se gameover 
normal2_cont:
	CALL inativa_objeto
	
conti:
	MOV R4, aviao_obj		; certifico me que R4 tem sempre o aviao 
	ADD R3, 4				; R3 com endereco do proximo aviao
	JMP cicl_aviao 

en:	
	POP R10 
	POP R9
	POP R8
	POP R7
	POP R5
	POP R3
	POP R2
	POP R4
	POP R1
	POP R0
	POP R6

	RET

;* -- novo_aviao --------------------------------------					
	;*
	;* Descricao: escreve um novo aviao no ecra, caso ainda nao tenha sido
	;* 			  alcançado o limite 
	;*
	;* Parametros: --
	;*
	;* Retorna: --
	;*
	;* Destroi: --
	;* Notas: --
novo_aviao:
	PUSH R3
	PUSH R0
	PUSH R1
	PUSH R8
	PUSH R6
	PUSH R4
	PUSH R2
	PUSH R5

	MOV R2, mete_aviao			
	MOV R2, [R2]				; R2 com o valor necessario de interrupcoes para
								; por novo aviao
	MOV R1, acrescenta_aviao	; R1 com o endereco do numero de interrupcoes que 
								; já passaram desde o ultimo aviao 
	MOV R8, [R1]				; R8 com o numero de interrupcoes que passaram

	CMP R8, R2					
	JGE segue					; teste para ver se já posso escrever novo aviao

atualiza_interrup:
	;aqui ainda nao posso ecsrever, por isso atualizo o valor na memoria e saio
	ADD R8, 1
	MOV [R1], R8
	JMP exit

segue:
	; se cheguei aqui é porque passaram interrupcoes suficientes, logo tenho de gerar 
	; um numero aleatorio (se ainda nao tiver sido gerado) para determinar o atraso
	MOV R0, atraso_aviao		; R0 com o endereco do atraso gerado
	MOV R4, R8
	SUB R4, R2					; R4 fica com o numero de interrupcoes que passaram desde que
								; o numero foi gerado
	CMP R4, 0
	JP teste					; se já foi gerado, salto

	;se ainda não foi gerado, gero um novo numero
	MOV R6, 1					; R6 com o input para o gera_aleatorio
	CALL gera_aleatorio			; retorna em R6 um numero aleatorio de 0 a 3
	MOV [R0], R6				; atualizo o atraso gerado com o novo valor

; testo se o valor aleatorio gerado ja foi alcancado 
teste:
	MOV R6, [R0]				; R6 com o atraso gerado 
	CMP R4, R6
	JGE escreve_aviao			; se o numero aleatorio gerado ja foi alcancado salta

	; se ainda nao alcancei o atraso gerado, saio
	JMP atualiza_interrup

escreve_aviao:
	MOV R0, 0					; aqui ja vou escrever um novo aviao, logo ponho
	MOV [R1], R0				; 0 nas interrupcoes que passaram desde esse momento					

	MOV R8, n_avioes_atual		; R8 com o endereco do numero de avioes ativos 
	MOV R0, [R8]				; R0 com o numero de avioes ativos
	MOV R3, N_AV_MAX			; R3 com o numero de avioes maximo
	CMP R0, R3
	JZ exit						; se já tenho o numero de avioes no ecra que é o 
								; máximo, saio e não escrevo nada

	; se ainda tenho espaço, escrevo um novo aviao

	MOV R3, avioes_pos			; R3 com o endereco da tabela de avioes
	MOV R4, aviao_obj 			; R4 com a forma do aviao

	MOV R6, 0					; R6 com o input para o gera_aleatorio
	CALL gera_aleatorio			; retorna em R6 um numero aleatorio entre 0 e 1
	CMP R6, 0
	JNZ segunda_posicao			; se R6 for 1, escrevo o aviao na segunda linha de entrada 

	; se R6 for zero escrevo na primeira linha
	MOV R0, AV_LIN_INIT_1		; R0 com a linha 1 de entrada do aviao
	JMP escolhe_aviao

segunda_posicao:
	MOV R0, AV_LIN_INIT_2		; R0 com a linha 2 de entrada do aviao

escolhe_aviao:
	MOV R1, AV_COL_INIT			; R1 com a coluna inicial do aviao

	MOV R6, 1					; R6 com o input para o gera aleatorio
	
	; se o numero gerado for 0, escrevemos um cartuchos, caso contrario um aviao
	CALL gera_aleatorio
	CMP R6, 0
	JNZ escreve_aviao_cont		; se R6 nao for zero, escrevo o aviao.

	; R6 era zero, logo tento escrever cartucho 
escreve_cartucho:
	MOV R6, 1					; R6 vai servir de flag, se realmente escreve um cartucho
								; mudo para 0
	MOV R5, N_CART_MAX			; R5 com o numero maximo de cartuchos ativos
	MOV R2, n_cartuchos_atual	
	MOV R2, [R2]				; R2 com o numero de cartuchos ativos
	CMP R2, R5
	JGE escreve_aviao_cont		; se o numero maximo de cartuchos ja foi alcancado, escrevo um aviao

	; limite nao ultrapassado, logo vou escrever um novo 
	MOV R6, 0
	MOV R4, cart_obj			; se foi zero, escrevo o cartucho (municao)
	MOV R2, n_cartuchos_atual
	MOV R5, [R2]				; R5 com o numero de cartuchos ativos
	ADD R5, 1					; adiciono um ao numeor de cartuchos ativos
	MOV [R2], R5				; atualizo esse valor na memoria

escreve_aviao_cont:
	MOV R2, R6					; R2 diz me se escrevi um cartucho ou nao (R2 = 0 => cartucho) 
	MOV R6, 1
	CALL escreve_objeto			; escrevo o novo aviao no inicio 

	CALL get_objeto_livre		; retorna em R3 o endereco de um aviao livre na memoria
	CALL ativa_objeto			; incrementa o numero de avioes ativos e atualiza
								; a posicao do novo aviao na memoria

	CMP R2, 0					
	JNZ exit					; se foi um aviao, ja terminei, sai

	; se for cartucho, decoro a posicao da memoria dele 
	MOV R0, cart_pos			; R0 com a posicao de memoria do cartucho
	MOV [R0], R3				; coloco la o endereco do cartucho 

exit:
	POP R5
	POP R2
	POP R4
	POP R6
	POP R8
	POP R1
	POP R0
	POP R3

	RET

;* -- repoe_aviao --------------------------------------					
	;*
	;* Descricao: repoe tudo relacionado com os avioes, incluindo a pontuacao
	;*     
	;* Parametros: --
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
repoe_aviao:
	PUSH R3
	PUSH R8

	MOV R3, avioes_pos		; R3 com o endereco para a tabela dos avioes
	MOV R8, n_avioes_atual	; R8 com o numero de avioes ativos
	CALL inativa_todos		; coloca todos os avioes inativos

	MOV R3, atraso_aviao	; R3 com o endereco do atraso que tem de ser inicializado
	MOV R8, 0				; R8 com o valor que indica estado inicial
	MOV [R3], R8			; inicializacao do valor do atraso

	CALL inativa_cartucho

	MOV R3, explo_pos		; R3 com o endereco para a tabela das explosoes
	MOV R8, n_explo_atual	; R8 com o numero de explosoes ativas
	CALL inativa_todos		; coloca todas as explosoes inativos

	POP R8
	POP R3	

	RET

;* -- inativa_cartucho --------------------------------------					
	;*
	;* Descricao: inativa um cartucho na memória 
	;*
	;* Parametros: --   
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: apenas coloca 0 na posicao de memoria cart_pos e decrementa o numero
	;*		  de cartuchos ativos
inativa_cartucho:
	PUSH R0
	PUSH R1

	MOV R0, cart_pos
	MOV R1, 0
	MOV [R0], R1

	MOV R0, n_cartuchos_atual
	MOV R1, [R0]			; R1 com o numero de cartuchos ativos
	CMP R1, 0
	JZ exito				; se o numero de cartuchos for zero saio 

	; se houver cartuchos decresco esse numero 
	SUB R1, 1				; decremento o numero de cartuchos ativos 
	MOV [R0], R1			; atualizo na memoria 

exito:
	POP R1
	POP R0
	RET

;* -- atualiza_avioes_passaram --------------------------------------					
	;*
	;* Descricao: decrementa o numero de avioes que o jogador ainda pode deixar passar
	;* 			  Também testa se o jogador já perdeu por deixar passar muitos avioes.
	;*
	;* Parametros: -- 
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
atualiza_avioes_passaram:
	PUSH R0
	PUSH R1
	PUSH R2

	MOV R0, n_av_atual_passar	; R0 com o endereco do numero de avioes que pode deixar
	MOV R1, [R0]				; R1 com o numero de avioes que pode deixar passar
	SUB R1, 1					; decremento esse numero
	MOV [R0], R1 				; atualizo esse valor na memoria 

	CMP R1, 0
	JNZ tudo_feito				; se jogador ainda nao perdeu, saio

	; se jogador perdeu, faco gameover
	CALL game_over 				

tudo_feito:
	POP R2
	POP R1
	POP R0

	RET

;* -- troca_aviao --------------------------------------					
	;*
	;* Descricao: troca a forma do aviao a desenhar 
	;*
	;* Parametros: R5 - diz que aviao coloco no aviao objeto. Se for 0 coloco
	;*					o aviao do primeiro nivel. Se for 1, o do segundo nivel
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: o novo aviao tem de estar na memoria, no aviao_obj_2
troca_aviao:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4

	MOV R2, 0					; R2 diz me quando terminei
	MOV R3, aviao_obj 			; R3 com o endereco do aviao anterior
	CMP R5, 0
	JZ primeiro_nivel

	MOV R0, aviao_obj_2			; R0 com o endereco do novo aviao
	MOVB R1, [R0]				; R1 com o tamanho do novo aviao
	JMP muda

primeiro_nivel:
	MOV R0, aviao_temp		; R0 com o endereco do novo aviao
	MOVB R1, [R0]

muda:
	CMP R2, R1
	JP finito					; se já mudei todas as posicoes, saio

	MOVB R4, [R0] 				; R4 com o valor de um byte do novo aviao
	MOVB [R3], R4				; coloco esse valor no aviao que é escrito

	ADD R3, 1
	ADD R0, 1					; avanco as posicoes de memoria 
	ADD R2, 1					; atualizo contador 
	JMP muda 

finito:
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0

	RET

;* -- Rotina de Serviço de Interrupção 0: aviao_int0 -------------------------------------------
	;* 
	;* Description: trata interrupções relacionadas com o aviao. Sempre que se dá,
	;* 				coloca essa indicação na memória, para que o avião se mova
	;*
	;* Parameters: 	--
	;* Return: 	--  
	;* Destroy: none
	;* Notes: --
aviao_int0:	
		PUSH R0
		PUSH R1

		MOV R1, 1
		MOV R0, move_aviao		; R0 com o endereco da flag que indica se houve interrup
		MOV [R0], R1			; colocar flag a 1

		POP R1
		POP R0

		RFE

;**************************************************************************
;********************************* CANHAO *********************************
;**************************************************************************

;* -- canhao --------------------------------------					
	;*
	;* Descricao: move o canhao caso alguma tecla tenha sido premida e atualiza
	;*            a sua posicao na memoria. Também verifica se as teclas de reiniciar
	;*			  , terminar ou disparar foram premidas e se foram atua de acordo.
	;*
	;* Parametros: --
	;* Retorna: --
	;* Destroi: --
	;* Notas: --

canhao:
		PUSH R0
		PUSH R1
		PUSH R4
		PUSH R6
		PUSH R2
		PUSH R3
		PUSH R5
		PUSH R7
		PUSH R8

		MOV R3, TECLA_POS
		MOV R3, [R3]				; R3 com a tecla que foi premida, se é que foi
		MOV R7, -1

		CMP R3, R7					; se nenhuma tecla foi premida pode ir embora
		JZ fin

		MOV R2, canhao_pos			; R2 com o endereco da posicao do canhao
		MOV R0, [R2]				; R0 com a linha atual do canhao
		ADD R2, 2 
		MOV R1, [R2]				; R1 com a coluna do canhao

		CALL getMovimento			; vai buscar os valores para mover o canhao.
									; o movimento nas linhas no R3 e colunas R5

		CMP R3, TECLA_INATIVA		; se nenhuma tecla importante foi clicada, sai
		JZ fin

		CMP R3, TECLA_REINICIA		; se foi premida a tecla reinicia, reinicia o jogo
		JZ call_reinicia

		CMP R3, TECLA_TERMINA
		JZ call_termina				; se foi premida a tecla game_over, termina o jogo

		CMP R3, TECLA_DISPARA       ; se foi premida a tecla dispara, sai
		JZ fin

		MOV R6, 0					; R6 com o modo 0 para apagar o canhao
		MOV R4, canhao_obj
		CALL escreve_objeto			; 

		MOV R6, 1					; R6 com o modo 1 para escrever o canhao
		ADD R0, R3					; a linha e a coluna sao atualizadas de acordo com o 
		ADD R1, R5					; movimento feito pelo utilizador 

		MOV R8, LIMITE_SUP_CANHAO
		CMP R0, R8					; testar se canhao esta a sair dos limites onde pode andar
		JLE reverte

		MOV R8, LIMITE_INF
		CMP R0, R8
		JGE reverte

		MOV R8, LIMITE_ESQ
		CMP R1, R8
		JN reverte

		MOV R8, LIMITE_DIR
		CMP R1, R8
		JN atualiz

reverte:
		SUB R0, R3					; se estiver a sair, escreve-o no mesmo 
		SUB R1, R5					; lugar onde estava antes.

atualiz:
		CALL escreve_objeto			; escrevo o canhao na nova posicao ou na mesma, depende

		MOV R3, R2					; argin do atualiza objeto tem no R3 o endereco 
		SUB R3, 2					; do objeto a atualizar	
		CALL atualiza_objeto 
		JMP fin

call_reinicia: 
		MOV R0, 1				; quero reiniciar o jogo, por isso modo 1
		CALL reinicia
		JMP begin

call_termina:
		CALL game_over 					

fin: 	
		POP R8
		POP R7
		POP R5
		POP R3
		POP R2
		POP R6
		POP R4
		POP R1
		POP R0

		RET

;* -- repoe_canhao --------------------------------------					
	;*
	;* Descricao: repoe posicao inicial de canhao na memoria
	;*     
	;* Parametros: --
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
repoe_canhao:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R6

	MOV R2, canhao_pos			; R2 com endereco da posicao do canhao

	MOV R0, CANHAO_LIN_INIT		; R0 com linha inicial do canhao
	MOV [R2], R0				; atualiza linha na memoria

	ADD R2, 2					; R2 com o endereco da coluna do CANHAO_LIN_INIT
	MOV R1, CANHAO_COL_INIT		; R1 com a coluna inicial do CANHAO_LIN_INIT
	MOV [R2], R1				; atualiza coluna na memoria

	MOV R4, canhao_obj 
	MOV R6, 1
	CALL escreve_objeto			; escreve canhao na posicao inicial

	POP R6
	POP R4
	POP R2
	POP R1
	POP R0
	RET

;**************************************************************************
;********************************* BALA ***********************************
;**************************************************************************

;* -- bala --------------------------------------					
	;*
	;* Descricao: trata do movimento das balas, dos disparos e verifica se jogo
	;*            já terminou ou não 
	;*
	;* Parametros: --
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
bala:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9

	MOV R3, TECLA_POS 		; R0 com o endereco da tecla premida
	MOV R3, [R3]			; R0 com a tecla premida

	MOV R0, -1				; R0 com valor de nenhuma tecla premida
	CMP R3, R0
	JZ 	next				; se nenhuma tecla premida, vai ver do movimento das balas

	CALL getMovimento		; vejo o que a tecla premida significa 
	CMP R3, TECLA_DISPARA	
	JNZ next				; se não foi premida tecla dos disparos, salta

	CALL nova_bala			; se foi, escreve nova bala, caso seja válido

next:
	MOV R0, move_bala		; R0 com o endereco da indicação de interrupção
	MOV R8, [R0]			; R8 com a indicacao se a interrupcao ocorreu ou nao
	CMP R8, 0
	JZ out					; se não ocorreu, saio

	MOV R8, 0
	MOV [R0], R8			; se ocorreu, ponho já lá um zero, para estar pronta para a próxima

	; mover as balas 
	MOV R5, -1				; R5 com indicador de bala inativa
	MOV R8, n_balas_atual	; R8 com o endereco que diz quantas balas estao ativas
	MOV R7, [R8]			; R7 com o numero de balas no ecra
	MOV R2, 0				; R2 é o contador que diz quando terminei
	MOV R3, balas_pos 		; R3 com o endereco da tabela de balas
	MOV R4, bala_obj		; R4 com a forma das balas  
	MOV R9, LIMITE_SUP 		; R9 com o limite superior da bala 

repeat:
	CMP R2, R7 				; se numero de balas movimentadas é igual ao numero
	JGE out 				; de balas no ecra, terminei

	MOV R0, [R3]			; R0 com a linha da bala 
	CMP R0, R5				
	JZ cont 				; se a bala está inativa passo à proxima bala 

	ADD R3, 2				; R3 com o endereco da coluna
	MOV R1, [R3]			; R1 com a coluna da bala

	SUB R3, 2				; atualizo R3, porque tinha andado demais 

	ADD R2, 1				; atualizo contador

	MOV R6, 0				; R6 com o modo apagar 
	CALL escreve_objeto		; apago a bala 

	SUB R0, 1				; atualizo a linha (movimento da bala é para cima)
	CMP R0, R9
	JGE contt 				; se bala ainda nao chegou ao fim, salto

	; se bala chegou ao fim
	CALL inativa_objeto		; torna a bala inativa 

	JMP cont 
	
contt:
	MOV R6, 1				; R6 com modo escrever
	CALL escreve_objeto		; escrevo a bala na nova posicao

	CALL atualiza_objeto	; atualizo a posicao da bala na memoria 

cont:
	ADD R3, 4				; R3 com endereco da proxima bala
	JMP repeat 


out:
	POP R9	
	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0

	RET


;* -- nova_bala --------------------------------------					
	;*
	;* Descricao: escreve uma nova bala no ecra caso o limite de balas ainda nao 
	;*            tenha sido alcancado e caso o utilizador ainda tenha munições
	;*
	;* Parametros: 
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
nova_bala:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R6
	PUSH R5
	PUSH R7
	PUSH R8

	MOV R8, n_balas_atual		; R8 com o endereco do numero de balas no ecra 
	MOV R7, [R8]				; R7 com o numero de balas no ecra
	MOV R5, N_BALAS_MAX			; R5 com o numero de balas maximo permitido

	CMP R7, R5					
	JZ leave					; caso limite ja tenha sido alcancado, sai 

	MOV R5, municao				; R5 com o endereco da municao disponivel
	MOV R2, [R5]				; R2 com a municao disponivel pelo jogador
	CMP R2, 0					
	JNZ mete_bala				; se ainda tiver munição, salta

	; aqui não tem munição. Se o número de balas ativas for 0, game over.
	; Caso contrário, sai.
	CMP R7, 0
	JNZ leave

	CALL game_over

mete_bala:
	MOV R1, canhao_pos			; R1 com o endereco da posicao do canhao 
	MOV R0, [R1]				; R0 com a linha do canhao 
	ADD R1, 2					; R1 com o endereco da coluna do canhao 
	MOV R1, [R1]				; R1 com a coluna do canhao

	SUB R0, BALAS_LINHA_INIT	; R0 com a linha onde escrever bala
	ADD R1, BALAS_COL_INIT		; R1 com a coluna onde escrever bala 
	MOV R4, bala_obj			; R4 com as caracteristicas da bala
	MOV R6, 1					; R6 com modo escrever, para chamar funcao escreve
	CALL escreve_objeto			; escreve bala

	SUB R2, 1					; R2 com a municao atualizada
	MOV [R5], R2				; atualizar a municao disponivel na memoria

	MOV R4, R2					; simplesmente colocar os valores nos argin da mete_display
	MOV R2, DISP_BALAS		

	MOV R5, 0
	CALL hexa_to_dec			; transformo hexa para "decimal"
	CALL mete_display			; coloca a nova municao no display

	MOV R3, balas_pos			; R3 com o endereco da tabela de balas
	CALL get_objeto_livre		; vou buscar a primeira bala livre na memoria

	CALL ativa_objeto			; atualizo a bala na memoria para as suas novas coordenadas

leave:
	POP R8
	POP R7
	POP R5
	POP R6
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0

	RET

;* -- repoe_balas --------------------------------------					
	;*
	;* Descricao: repoe tudo relacionado com as balas
	;*     
	;* Parametros: --
	;*
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
repoe_balas:
	PUSH R3
	PUSH R8

	MOV R3, balas_pos		; R1 com o endereco para a tabela das balas
	MOV R8, n_balas_atual	; R8 com o numero de balas inativas 
	CALL inativa_todos		; coloca todas as balas inativas 

	POP R8
	POP R3	

	RET

;* -- Rotina de Serviço de Interrupção 0: bala_int0 -------------------------------------------
	;* 
	;* Description: trata interrupções relacionadas com as balas. Sempre que se dá,
	;* 				coloca essa indicação na memória, para que as balas se movam
	;*
	;* Parameters: 	--
	;* Return: 	--  
	;* Destroy: none
	;* Notes: --
bala_int0:	
		PUSH R0
		PUSH R1

		MOV R1, 1
		MOV R0, move_bala		; R0 com o endereco da flag que indica se houve interrup
		MOV [R0], R1			; colocar flag a 1

		POP R1
		POP R0

		RFE





;**************************************************************************
;********************************* ECRA ***********************************
;**************************************************************************

;* -- mapeia_ecra --------------------------------------					
	;*
	;* Descricao: pega na linha e coluna de uma matriz 32X32 (indexada a
	;*            partir do 0) - correspondentes a coordenada de um pixel -
	;*            e mapeia para o endereco e N correspondentes na memoria
	;*
	;*            endereco = SREEN + 4*linha + coluna/8
	;*                   N = MOD coluna/8
	;*
	;* Parametros: R0 - numero da linha
	;*             R1 - numero da coluna
	;*
	;* Retorna: R2 - endereco do byte onde se encontra o  pixel
	;*          R3 - N (0-7) corespondente a posicao do pixel no byte
	;*
	;* Destroi: R2, R3
	;* Notas: --
	
mapeia_ecra:
	PUSH R0
	PUSH R1
	PUSH R4
	PUSH R5

	MOV R4, 4		; vai servir para multiplicar a linha por 4
	MOV R5, 8		; vai servir para fazer as divisoes
	MOV R2, SCREEN		; R2 com o endereco do ecra na memoria
	MOV R3, R1		; R3 com a coluna
	
	MUL R0, R4		; linha * 4
	DIV R1, R5		; coluna / 8
	MOD R3, R5		; R3 com o valor de N
	ADD R2, R0		; R2 com o valor SCREEN + 4*linha
	ADD R2, R1		; R2 com o endereco final

	POP R5
	POP R4
	POP R1
	POP R0

	RET

;* -- escreve_pixel  --------------------------------------
	;*
	;* Descricao: acende ou desliga um determinado pixel de um ecra 32X32
	;*
	;* Parametros: R0 - numero da linha
	;*             R1 - numero da coluna
	;*             R7 - modo (0 - desligar; 1 - ligar)
	;*
	;* Retorna: --
	;* 
	;* Destroi: --
	;* Notas: --

escreve_pixel:
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	
	MOV R6, tab_N		; R6 com o endereco da tabela de mascaras

	CALL mapeia_ecra	; descobrir o endereco e a posicao do bit
						; correspondentes as coordenadas dadas
	ADD R3, R6			; R3 com endereco da mascara (endereco ao byte)
	MOVB R4, [R3]		; ir buscar a mascara certa (conforme N)
	MOVB R5, [R2]		; R5 com byte do ecra (para alterar o N bit)
	AND R7, R7			; verificar se e para apagar ou ligar o pixel
	JZ apagar
	
	OR R5, R4			; se for para ligar faco o OR 
	JMP escreve

apagar:	NOT R4			; para desligar, R4 com complemento da mascara
	AND R5, R4			; apago o bit
	
escreve:
	MOVB [R2], R5		; mandar para o ecra

	POP R6
	POP R5
	POP R4
	POP R3
	POP R2

	RET

;* -- escreve_linha  --------------------------------------
	;*
	;* Descricao: acende e desliga um determinado numero de pixeis de uma
	;*            linha do ecra 
	;*
	;* Parametros: R0 - numero da linha
	;*             R1 - numero da coluna onde comeca
	;*             R2 - numero que descreve a linha
	;*             R3 - numero de colunas que a linha a alterar tem
	;*
	;* Retorna: --
	;* 
	;* Destroi: --
	;* Notas: R3 tem de ser o numero minimo de bits necessarios
	;*        para escrever R2. Se for maior escreve-se o R2 encostado a
	;*        direita

escreve_linha:

	PUSH R1
	PUSH R3
	PUSH R5
	PUSH R7
	
	SUB R3, 1					; R3 com a posicao do primeiro bit a ser escrita
	CALL devolve_mascara		; coloca em R5 a mascara

loop:	AND R5, R5				; se R5 for zero termino
		JZ ret1
		MOV R7, R2				; R7 vai ter os bits a escrever
		AND R7, R5				; R7 com o primeiro bit a escrever 
		CALL escreve_pixel		; escrevo o pixel
		SHR R5, 1 				; atualizo a mascara
	
		ADD R1, 1				; adiciono 1 a coluna
		JMP loop

ret1:	
		POP R7
		POP R5
		POP R3
		POP R1
		RET

;* -- devolve_mascara  --------------------------------------
	;*
	;* Descricao: devolve uma mascara com tudo a zeros execepto um bit, que vem a um.
	;*            Este bit vem na posicao indicada por R3 - comeca a contar do zero.
	;*            
	;*
	;* Parametros: R3 - posicao do bit a 1 na mascara (comeca a contar do zero)
	;*
	;* Retorna: R5 - mascara com bit da posicao R3 a 1
	;* 
	;* Destroi: R5
	;* Notas: --

devolve_mascara:
	PUSH R3				; guarda R3 na stack

	MOV R5, 1 			; R7 comeca com o bit zero a 1

repete:	AND R3, R3		; verifica se ja terminou
	JZ finale			; vai para o fim se ja terminou
	SHL R5, 1			; faz SHR de um bit
	SUB R3, 1			; atualiza numero de vezes que faltam
	JMP repete			; volta a fazer ate terminar

finale:	POP R3
	RET					; retorna 

;* -- escreve_objeto  --------------------------------------
	;*
	;* Descricao: escreve um objeto no ecra
	;*            
	;*
	;* Parametros: R0 - linha onde comecar (canto superior esquerdo do obj)
	;*             R1 - coluna onde comecar (canto superior esquerdo)
	;*             R4 - endereco das caracteristicas do objeto
	;* 			   R6 - com o modo. Se for 0 é para apagar se for 1 é para escrever 
	;*
	;* Retorna: --
	;* 
	;* Destroi: --
	;* Notas: no endereco do objeto devem estar as seguintes informacoes por
	;*        ordem e uma por byte - tamanho da matriz quadrada; para cada
	;*        linha o numero que se quer escrever

escreve_objeto:
	PUSH R4
	PUSH R5
	PUSH R3
	PUSH R2
	PUSH R0

	MOVB R3, [R4]		; R3 com o tamanho da matriz (#lin = #col = R3)
	MOV R5, R3			; R5 vai me dizer quantas vezes escrever

refrao:	AND R5, R5		; check se ja terminei
	JZ fi				; vou para o fim se sim
	SUB R5, 1			; atualizo contador
	ADD R4, 1			; R4 com endereco da prox caracteristica do obj

	AND R6, R6			
	JZ apaga 			; escreve um 0, se estiver no modo apagar
	MOVB R2, [R4]		; R2 com o numero a escrever na linha (caso modo seja escrever)
	JMP escr
apaga:
	MOV R2, 0
escr:
	CALL escreve_linha	; escrevo o numero na linha

	ADD R0, 1			; R0 com a proxima linha onde escrever
	JMP refrao

fi:	POP R0
	POP R2
	POP R3
	POP R5
	POP R4

	RET

	
;* -- apaga_ecra  --------------------------------------
	;*
	;* Descricao: apaga ecra
	;*            
	;*
	;* Parametros: --
	;*
	;* Retorna: --
	;* 
	;* Destroi: --
	;* Notas:

apaga_ecra:
	PUSH R0
	PUSH R1
	PUSH R2

	MOV R0, SCREEN		; R0 com o endereco do ecra
	MOV R1, 0H			; R1 com valor a escrever no ecra, 0 para apagar
	MOV R2, 64			; R2 com o numero de vezes que tem de escrever
						; 0 - corresponde ao numero de palavras do ecra

iter:	
	AND R2, R2		; teste para ver se terminei
	JZ acaba			; vai para o fim se sim
	MOV [R0], R1		; apago o que esta na palavra enderecada por R0
	ADD R0, 2			; atualizo R0 (proximos dois bytes do ecra)
	SUB R2, 1			; atualizo contador
	JMP iter			; repete ate preencher tudo

acaba:	
	POP R2
	POP R1
	POP R0

	RET


; *****************************************************************************
; ********************************** TECLADO **********************************
; *****************************************************************************

;* -- teclado --------------------------------------
	;*
	;* Descricao: verifica se alguma tecla foi pressionada e se foi guarda-a na memoria.			
	;*
	;* Parametros: --
	;* Retorna: --
	;* Destroi: --
	;* Notas: --
teclado:	
	;* Inicializacao de variaveis gerais
	PUSH R7
	PUSH R5
	PUSH R8
	PUSH R4
	PUSH R3
	PUSH R1
	PUSH R0
	PUSH R2

	MOV R3, FIRST			; R3 com o bit correspondente da linha a testar
	MOV R4, LAST			; R4 guarda o bit da ultima linha a testar
	MOV R0, -1				; se nenhuma tecla for clicada, o valor guardado sera -1
	MOV R2, teclado_mode	; R2 com o modo do teclado (1 - ON; 0 - OFF)
	
	;* Corpo do programa
ciclo:	
	CMP R3, R4				; verifica se ja chegou ao fim
	JZ pre_fini					; se chegou, sai

	CALL testa_linha

	SHL R3, 1	       	 	; atualiza a linha a testar
	AND R5, R5				; ver se alguma tecla foi premida
	JZ ciclo				; se nao foi, repete

	SHR R3, 1	       	 	; se foi, repoe a linha que foi testada

	MOV R4, [R2]			; R4 com o modo do teclado (ON ou OFF)
	CMP R4, 0
	JZ fini 				; se modo OFF, como tecla foi clicada, modo continua OFF

	MOV R1, R3				; coloco a linha no argin do binToHex
	CALL mapeia_fila		; converto a linha em binario para hexa
	MOV R3, R7				; coloco a linha em hexa no R3

	MOV R1, R5				; coloco a coluna no argin do binToHex
	CALL mapeia_fila		; converto a coluna em binario para hexa
	MOV R5, R7				; coloco a coluna em hexa no R5

	MOV R1, R3				; coloco os argins do to tecla
	MOV R7, R5
	CALL toTecla			; converto linha e coluna na tecla correspondente

	MOV R1, 0
	MOV [R2], R1			; modo estava ON, mudo para OFF
	JMP fini

pre_fini:	
	MOV R1, 1		
	MOV [R2], R1			; se nenhuma tecla foi premida, ponho teclado ON 
	JMP fini	
	
fini:
	MOV R8, TECLA_POS		; R8 com endereco onde fica guardada a tecla
	MOV [R8], R0			; guardo a tecla retornada na memoria

	POP R2 
	POP R0
	POP R1
	POP R3
	POP R4
	POP R8
	POP R5
	POP R7

	RET

;* -- testa_linha --------------------------------------
	;*
	;* Descricao: testa uma determinada linha do teclado par determinar se 
	;* 			  alguma tecla foi ou não pressionada
	;*
	;* Parametros: R3 - linha a testar (1, 2, 4 ou 8)
	;* Retorna: R5, coluna da tecla clicada (1, 2, 4 ou 8) ou 0 se nenhuma foi pressionada
	;* Destroi: R5
	;* Notas: --
testa_linha:
	PUSH R2
	PUSH R6
	PUSH R9

	MOV R6, PIN				; R6 guarda o endereco do periferico de entrada
	MOV R2, POUT2			; R2 guarda o endereco do periferico de saida
	MOV R9, 0FH				; R9 será a máscara para isolar os primeiros bits do PIN

	MOVB [R2], R3			; escrever no porto de saida
	MOVB R5, [R6]			; ler do porto de entrada
	AND R5, R9				; isolar os primeiros 4 bits do PIN

	POP R9
	POP R6
	POP R2

	RET

;* -- mapeia_fila --------------------------------------
	;*
	;* Descricao: pega na linha ou coluna em binario - 1, 2, 4 ou 8 -
	;*            e converte no numero da fila 0, 1, 2 ou 3 respetivamente.
	;*
	;* Parametros: R1 - numero 1, 2, 4 ou 8 em binario 
	;* Retorna: R7 - numero convertido para a fila do teclado correspondente
	;* Destroi: R7
	;* Notas: --
mapeia_fila:	
	PUSH R2			; guardar o R2 na stack
	MOV R2, FIRST	; R2 sera as hipoteses possiveis a testar (1, 2, 4 e 8)
	MOV R7, 0		; R7 guarda o valor da hipotese em hexa
	
cicle:	CMP R1, R2 	; verificar se R2 ja corresponde ao valor correto
	JZ reto			; se sim, terminou e retorno o R7
	ADD R7, 1		; atualizo o valor do R7
	SHL R2, 1		; atualizo o R2 para a proxima hipotese
	JMP cicle
	
reto:	POP R2
	RET
	
;* -- toTecla ----------------------------------------
	;*
	;* Descricao: transforma a linha e coluna de um teclado 4X4 (indexado
	;*            a partir do zero) no valor correspondente.
	;* 	      Aplica a formula: 4*linha + coluna
	;*
	;* Parametros: R1 - linha de um teclado 4X4
	;*             R7 - coluna de um teclado 4X4 
	;* Retorna: R0
	;* Destroi: R0
	;* Notas: --

toTecla:
	PUSH R2			; guardar R2 na stack

	MOV R2, 4		; R2 com o 4 para multiplicar
	MOV R0, R1		; R0 com a linha

	MUL R0, R2		; 4 * linha no R0 
	ADD R0, R7		; R0 com o valor do teclado

	POP R2

	RET
	
	
	
	
	

	

