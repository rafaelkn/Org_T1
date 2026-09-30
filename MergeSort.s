# ============================================================
# a0 = argumento/retorno
# a1 = argumento
# s0 = ponteiro da lista
# ============================================================


#FUNÇÃO CRIAR_NO
#a0 = valor,
#t0 = valor temporário,
#a7 = código da syscall (alocação de memória)
#retorno a0 = endereço do novo nó
#____________________________________________________________________

criar_no:
# a0 = valor recebido
  mv    t0 a0                    # guarda o valor

  li    a0 8                    # a0 = argumento (tamanho a alocar)
  li    a7 9                    # a7 = código da syscall 

  ecall                          # reserva 8 bytes

  sw    t0 0(a0)                 # novo->valor = valor
  sw    zero 4(a0)               # novo->next = 0

  jr    ra                       # retorna endereço do novo nó em a0


#FUNÇÃO INSERIR
#a0 = argumento/retorno,
#a1 = valor,
#s0 = lista,
#t0 = novo,
#t1 = atual,
#t2 = atual->next
#____________________________________________________________________

inserir:
# salva o endereço de retorno
  addi  sp sp -4
  sw    ra 0(sp)

# criando novo nó
  mv    a0 a1
  jal   criar_no

  mv    t0 a0                    # guarda o endereço do novo nó

  beq   s0 zero lista_vazia

  mv    t1 s0                    # atual = primeiro nó da lista

percorrer:
  lw    t2 4(t1)                 # t2 = atual->next

  beq   t2 zero encontrou_fim

  mv    t1 t2                    # atual = atual->next
  j     percorrer

encontrou_fim:
  sw    t0 4(t1)                 # atual->next = novo

# recupera ra
  lw    ra 0(sp)
  addi  sp sp 4

  jr    ra

lista_vazia:
  mv    s0 t0                    # s0 = novo

# recupera ra
  lw    ra 0(sp)
  addi  sp sp 4

  jr    ra


#FUNÇÃO IMPRIMIR_LISTA
#s0 = lista,
#t0 = atual,
#t1 = atual->valor,
#a0 = argumento da ecall,
#a7 = código da ecall
#____________________________________________________________________

imprimir_lista:
  mv    t0 s0                    # atual = lista

loop_imprimir:
  beq   t0 zero fim_imprimir

  lw    t1 0(t0)                 # t1 = atual->valor

# imprime inteiro
  mv    a0 t1
  li    a7 1
  ecall

# imprime espaço
  li    a0 32
  li    a7 11
  ecall

  lw    t0 4(t0)                 # atual = atual->next
  j     loop_imprimir

fim_imprimir:
# imprime '\n'
  li    a0 10
  li    a7 11
  ecall

  jr    ra


#____________________________________________________________________

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
#____________________________________________________________________

If:
  beq   a0, zero, If_continuacao          # se lista == NULL pula para o caso especial
  lw    a3, 4(a0)                         # a3 = lista->next
  beq   a3, zero, If_continuacao          # se lista->next == NULL pula para o caso especial também
  li    t0, 0                             # total = 0
  mv    a4 , a0                           # atual = lista


# Conta quantos nós tem e armazena na variável total
While:
  beq   a4 , zero, Fim_while              # se atual == NULL pula para o Fim do While
  addi  t0, t0, 1                         # total++
  lw    a4 , 4(a4 )                       # atual = atual->next
  j     While                             # repete o loop 

# Acha a posição do meio
Fim_while:
  li    t1, 2
  div   a5 , t0, t1                       # meio = total / 2

# Anda até essa posição
  mv    a4 , a0                           # atual = lista
  li    t2, 1
For:
  bge   t2, a5 , Fim_for                  # se o i >= meio, sai do for
  lw    a4 , 4(a4 )                       # atual = atual->next
  addi  t2, t2, 1                         # i = i +1
  j     For                               # reinicando o loop


Fim_for:
  sw    a0, 0(a1)                         # *frente = lista
  lw    t3, 4(a4)                         # t3 = atual->next
  sw    t3, 0(a2)                         # *tras = atual->next
  sw    zero, 4(a4)                       # atual->next = NULL
  j     Fim_split                         # pula o caso especial e vai direto para o fim

If_continuacao:
  sw    a0, 0(a1)                         # *frente = lista
  sw    zero, 0(a2)                       # *tras = NULL

Fim_split:
  jr    ra                                # retorna sem valor em a0








#FUNÇÃO MERGE
#a0 = a,
#a1 = b,
#s0 = resultado,
#t0 = a->valor,
#t1 = b->valor
#____________________________________________________________________

  addi  sp, sp, -8                   # reserva o espaço na stack
  sw    ra, 0(sp)                    # salva ra
  sw    s0, 4(sp)                    # salva s0

  mv    s0, zero                     # No *resultado = NULL;

If_A:
  bne   a0, zero, If_B              # se o a != NULL pula para o IF_B
  mv    a0, a1                      # a0 = b
  lw    s0, 4(sp)                   # restaura s0 original antes de sair porque ele foi sobreescrito com zero na função
  addi   sp, sp, 8                   # libera o espaço reservado na stack
  jr    ra                          # return b

If_B:
  bne   a1, zero, If_valor         # se o b != NULL pula para o If_valor
                                   # obs: como o a0 já chega valendo a, pra retornar a não precisa fazer nada
  lw    s0, 4(sp)                  # restaura s0 
  addi   sp, sp, 8                  # libera o espaço reservado na stack
  jr    ra                         # return a;


# Se ele chega até aqui é porque o a e o b não são nulos
If_valor:
  lw    t0, 0(a0)                  #a->valor
  lw    t1, 0(a1)                  #b->valor
  bgt   t0, t1, Else               # se o a->valor > b->valor pula para o Else
  mv    s0, a0                     # resultado = a

  lw    a0, 4(a0)                  # a = a->next
  jal   merge                      # chamada recursiva: merge(a->next, b)
  sw    a0,4(s0)                   # resultado->next = o retorno da função merge
  mv    a0, s0                     # prepara o valor de retorno a0 = resultado
  j     Fim_merge  


Else:
  mv    s0, a1                    #resultado = b;
  lw    a1, 4(a1)                 # b = b->next
  jal   merge                     # chamada recursiva: merge(a, b->next)
  sw    a0, 4(s0)                 # resultado->next = o retorno da função merge
  mv    a0, s0                    # prepara o valor de retorno a0 = resultado

Fim_merge:
  lw    ra, 0(sp)                 # restaura ra
  lw    s0, 4(sp)                 # restaura s0
  addi  sp, sp, 8                 # libera o espaço reservado na stack
  jr    ra                        # return resultado que ja está em a0







#FUNÇÃO MERGE_SORT
#a0 = lista,
#a1 = endereço de frente,
#a2 = endereço tras,
#s0 = Valor frente,
#s1 = Valor tras,
#t0 = lista->next
#____________________________________________________________________

  addi  sp, sp ,-20                                 #reserva 20 bytes (ra + s0 + s1 + espaço p/ frente + espaço p/ tras)
  sw    ra, 0(sp)                                   # salva ra 
  sw    s0, 4(sp)                                   # salva s0 usado para "frente"
  sw    s1, 8(sp)                                   # salva s1 usado para "tras"

  beq   a0, zero , Retorne_lista                    # lista == NULL pula para o Retorne_lista
  lw    t0, 4(a0)                                   # t0 = lista->next
  beq   t0, zero , Retorne_lista                    # se lista->next == NULL pula para o Retorne_lista

  j     Split

Retorne_lista:
  j     Fim


Split:
  addi  a1, sp, 12                                  # a1 = &frente (endereço = topo da pilha + offset 12)   
  addi  a2, sp, 16                                  # a2 = &tras   (endereço = topo da pilha + offset 16)
  jal   split                                       # split escreve os resultados em 12(sp)/16(sp)
  lw    s0, 12(sp)                                  # s0 = frente (traz o valor pra um registrador)
  lw    s1, 16(sp)                                  # s1 = tras


# frente = merge_sort(frente);
  mv    a0, s0
  jal   merge_sort
  mv    s0, a0

# tras = merge_sort(tras);
  mv    a0, s1
  jal   merge_sort
  mv    s1, a0

  mv    a0, s0
  mv    a1, s1
  jal   merge


Fim:
  lw    ra, 0(sp)                               # restaura ra
  lw    s0, 4(sp)                               # restaura s0
  lw    s1, 8(sp)                               # restaura s1
  addi  sp, sp, 20                              # libera o espaço reservado
  jr    ra                                      # retorna, a0 = lista ordenada
















#____________________________________________________________________


liberar_lista:
  mv    t0, a0                   # atual (t0) = lista

loop_liberar:
  beq   t0, zero, fim_liberar    #while lista != null

  lw    t1, 4(t0)                # t1 = lista->next
  mv    t0, t1                   # lista = lista->next
  j     loop_liberar

fim_liberar:
  jr    ra


#____________________________________________________________________

  .data
vetor:
  .word 5, 3, 8, 1, 9, 2, 9      #v[n] = {5,....., 9}
N:
  .word 7                        # n = 7 (tamanho do vetor)


#____________________________________________________________________



  .text
main:
  addi  sp, sp, -16
  sw    ra, 0(sp)
  sw    s0, 4(sp)
  sw    s1, 8(sp)
  sw    s2, 12(sp)

  mv    s0, zero                 # lista = NULL

  la    t2, vetor                # t2 = &vetor
  la    t3, N
  lw    s1, 0(t3)                # s1 = N

  li    s2, 0                    # i = 0

loop_leitura:
  bge   s2, s1, fim_leitura      # while (i < n)

  slli  t4, s2, 2                # t4 = i * 4
  add   t4, t2, t4               # t4 = &vetor[i]
  lw    a1, 0(t4)                # valor (a1) = vetor[i]

  jal   inserir                  # inserir(valor em a1) — s0 (lista) é atualizado internamente pela função
 

  addi  s2, s2, 1                #i++
  j     loop_leitura

fim_leitura:
  mv    a0, s0                   #a0 = lista
  jal   imprimir_lista           #imprime antes do merge

  mv    a0, s0                   #a0 = listq
  jal   merge_sort
  mv    s0, a0                   # lista = merge_sort(lista)

  mv    a0, s0
  jal   imprimir_lista           #imprime vetor depois do merge

  mv    a0, s0
  jal   liberar_lista            # liberar_lista(lista)

  lw    ra, 0(sp)
  lw    s0, 4(sp)
  lw    s1, 8(sp)
  lw    s2, 12(sp)
  addi  sp, sp, 16               #restaura os regs e desfaz a pilha

  li    a7, 10
  ecall                          # return 0