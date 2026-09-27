liberar_lista:
  mv    t0, a0                # atual (t0) = lista

loop_liberar:
  beq   t0, zero, fim_liberar #while lista != null

  lw    t1, 4(t0)             # t1 = lista->next
  mv    t0, t1                # lista = lista->next
  j     loop_liberar

fim_liberar:
  jr    ra



  .data
vetor:
  .word 5, 3, 8, 1, 9, 2, 7   #v[n] = {......}
N:
  .word 7                     # n = 7 (tamanho do vetor)

  .text
main:
  addi  sp, sp, -16
  sw    ra, 0(sp)
  sw    s0, 4(sp)
  sw    s1, 8(sp)
  sw    s2, 12(sp)

  mv    s0, zero              # lista = NULL

  la    t2, vetor             # t2 = &vetor
  la    t3, N
  lw    s1, 0(t3)             # s1 = N

  li    s2, 0                 # i = 0

loop_leitura:
  bge   s2, s1, fim_leitura   # while (i < n)

  slli  t4, s2, 2             # t4 = i * 4
  add   t4, t2, t4            # t4 = &vetor[i]
  lw    a1, 0(t4)             # valor (a1) = vetor[i]

  mv    a0, s0                # a0 = lista
  jal   inserir               # inserir(lista (a0), valor (a1))
  mv    s0, a0                # lista = inserir(lista, valor)

  addi  s2, s2, 1             #i++
  j     loop_leitura

fim_leitura:
  mv    a0, s0                #a0 = lista
  jal   imprimir_lista        #imprime antes do merge

  mv    a0, s0                #a0 = listq
  jal   merge_sort
  mv    s0, a0                # lista = merge_sort(lista)

  mv    a0, s0
  jal   imprimir_lista        #imprime vetor depois do merge

  mv    a0, s0
  jal   liberar_lista         # liberar_lista(lista)

  lw    ra, 0(sp)
  lw    s0, 4(sp)
  lw    s1, 8(sp)
  lw    s2, 12(sp)
  addi  sp, sp, 16            #restaura os regs e desfaz a pilha

  li    a7, 10
  ecall                       # return 0