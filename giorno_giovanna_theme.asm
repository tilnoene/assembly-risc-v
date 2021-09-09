.eqv VOL_TRACK1 50	# volume das tracks
.eqv VOL_TRACK2 50
.eqv VOL_TRACK3 50

.eqv INSTR_TRACK1 0	# instrumento das tracks
.eqv INSTR_TRACK2 0
.eqv INSTR_TRACK3 0

.eqv NOTAS 41		# numero total de notas

.data
TRACK1: .word 78,750,74,750,74,104,76,0,76,104,77,0,77,375,76,0,76,375,74,0,74,250,73,0,73,375,74,0,74,375,76,0,76,250,78,0,78,500,83,250,83,500,71,250,71,250,73,0,73,250,74,0,74,375,76,0,76,375,74,0,74,250,73,0,73,375,81,0,81,375,79,0,79,250,78,0,78,500
TRACK2: .word 74,750,71,2959,71,500,74,3500,74,500
TRACK3: .word 71,750,71,7500,71,500

.text
MAIN:	li s8,0		# contador de notas = 0
	
	# endereco de cada track
	la s1,TRACK1
	la s2,TRACK2
	la s3,TRACK3
	
	# toca as primeiras notas
	csrr s5,3073	# ultimo tempo em que a nota s1 foi tocada (inicio = tempo atual)
	jal PLAY_TRACK1
	
	csrr s6,3073	# utilmo tempo em que a nota s2 foi tocada (inicio = tempo atual)
	jal PLAY_TRACK2
	
	csrr s7,3073	# utilmo tempo em que a nota s3 foi tocada (inicio = tempo atual)
	jal PLAY_TRACK3
	
LOOP:
	csrr t0,3073	# tempo atual
	lw t2,-4(s1)	# duracao da nota anterior (s1)
	sub t1,t0,s5	# tempo ultima nota - tempo atual 
	bge t1,t2,PLAY_TRACK1 # se for maior ou igual, toca a track1
	
	csrr t0,3073	# tempo atual
	lw t2,-4(s2)	# duracao da nota anterior (s2)
	sub t1,t0,s6	# tempo ultima nota - tempo atual 
	bge t1,t2,PLAY_TRACK2 # se for maior ou igual, toca a track2

	csrr t0,3073	# tempo atual
	lw t2,-4(s3)	# duracao da nota anterior (s3)
	sub t1,t0,s7	# tempo ultima nota - tempo atual 
	bge t1,t2,PLAY_TRACK3 # se for maior ou igual, toca a track3

	j LOOP

END:	li a7,10	# exit
	ecall

PLAY_TRACK1: 	# toca a nota e avanca
	li a7,31	# MidiOut
	lw a0,0(s1)	# nota da melodia principal
	lw a1,4(s1)	# duracao da primeira nota
	li a2,INSTR_TRACK1	# instrumento
	li a3,VOL_TRACK1	# volume
	ecall

	addi s1,s1,8	# proxima nota
	csrr s5,3073	# reinicia o tempo atual
	
	# como a track1 eh a maior, ela quem decide quando o loop acaba
	
	addi s8,s8,1	# contador += 1
	li t0,NOTAS	# numero de notas
	beq t0,s8,END	# verifica se contador == notas

	ret
	
PLAY_TRACK2:	# toca a nota e avanca
	li a7,31	# MidiOut
	lw a0,0(s2)	# nota da melodia principal
	lw a1,4(s2)	# duracao da primeira nota
	li a2,INSTR_TRACK2	# instrumento
	li a3,VOL_TRACK2	# volume
	ecall

	addi s2,s2,8	# proxima nota
	csrr s6,3073	# reinicia o tempo atual
	
	ret
	
PLAY_TRACK3: 		# toca a nota e avanca
	li a7,31	# MidiOut
	lw a0,0(s3)	# nota da melodia principal
	lw a1,4(s3)	# duracao da primeira nota
	li a2,INSTR_TRACK3	# instrumento
	li a3,VOL_TRACK3	# volume
	ecall

	addi s3,s3,8	# proxima nota
	csrr s7,3073	# reinicia o tempo atual
	
	ret
