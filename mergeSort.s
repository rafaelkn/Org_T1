#FUNÇÃO SPLIT
#a0 = lista,
#a1 = &frente,
#a2 = &tras, 
#a3 = lista->next, 
#a4 = atual, 
#a5 = meio,
#t0 = total, 
#t1 = 2, 
#t2 = i, 
#t3 = atual->next 
____________________________________________________________________

If:
  beq  a0, zero, If_continuacao
  lw a3, 4(a0)
  beq  a3, zero, If_continuacao
  li t0, 0
  mv a4 , a0

While:
  beq a4 , zero, Fim_while 
  addi t0, t0, 1 
  lw a4 , 4(a4 )
  j While

Fim_while:
  li t1, 2
  div  a5 , t0, t1
  mv a4 , a0


  
  li t2, 1
For:
  bge t2, a5 , Fim_for
  lw a4 , 4(a4 )
  addi t2, t2, 1
  j For

Fim_for:
  sw   a0, 0(a1)
  lw t3, 4(a4)
  sw t3, 0(a2)
  sw zero, 4(a4)
  j Fim_split

If_continuacao:
  sw a0, 0(a1)
  sw zero, 0(a2)

 Fim_split:
  jr ra 








#FUNÇÃO MERGE
#a0 = a,
#a1 = b, 
#s0 = resultado, 
#t0 = a->valor, 
#t1 = b->valor
____________________________________________________________________

  addi sp, sp, -8
  sw ra, 0(sp)
  sw s0, 4(sp)  

  mv s0, zero

If_A:
  bne a0, zero, If_B
  mv a0, a1    
  lw s0, 4(sp) 
  add sp, sp, 8
  jr ra

If_B:
  bne a1, zero, If_valor
  lw s0, 4(sp)
  add sp, sp, 8
  jr ra


If_valor:
  lw t0, 0(a0)
  lw t1, 0(a1)
  bgt t0, t1, Else
  mv s0, a0

  lw a0, 4(a0)
  jal merge
  sw a0,4(s0)
  mv a0, s0


Else:
  mv s0, a1
  lw a1, 4(a1)
  jal merge
  sw a0, 4(s0)
  mv a0, s0

Fim_merge:
  lw ra, 0(sp)
  lw s0, 4(sp)  
  addi sp, sp, 8
  jr ra







#FUNÇÃO MERGE_SORT 
#a0 = lista,
#a1 = endereço de frente, 
#a2 = endereço tras, 
#s0 = Valor frente, 
#s1 = Valor tras,  
#t0 = lista->next
____________________________________________________________________

  addi sp, sp ,-20
  sw ra, 0(sp)
  sw s0, 4(sp)
  sw s1, 8(sp)

  beq a0, zero , Retorne_lista
  lw t0, 4(a0)
  beq t0, zero , Retorne_lista

  j Split

Retorne_lista:
  j Fim


Split:
  addi a1, sp, 12 
  addi a2, sp, 16
  jal split
  lw s0, 12(sp)
  lw s1, 16(sp)


  mv a0, s0
  jal merge_sort
  mv s0, a0 

  mv a0, s1
  jal merge_sort
  mv s1, a0

  mv a0, s0
  mv a1, s1
  jal merge 


Fim: 
  lw ra, 0(sp)
  lw s0, 4(sp)
  lw s1, 8(sp)
  addi sp, sp, 20
  jr ra
