# s0 = listta
# t0 = novo
# t1 = atual
# t2 = temporário
# a0 = argumento/retorno
# a1 = argumento


#################### Função de criar novo nó ####################
criar_no:
    # a0 = valor recebido
    mv t0 a0 # guarda o valor
    
    li a0 9 # syscall para preservar memória
    li a1 8 # tamanho da struct No
    
    ecall # reserva 8 bytes
    
    sw t0 0(a0) # novo->valor = valor
    sw zero 4(a0) # novo->next = 0
    
    ret # a0 = endereço do novo nó
    

############ Função de inserir novo nó ####################
inserir:
    # criando novo nó
    mv a0 a1
    jal criar_no
    
    mv t0 a0 # guarda o endereço do novo nó
    
    beq s0 zero lista_vazia
    
    mv t1 s0 # atual = primeiro nó da lista
   
percorrer:
    lw t2 4(t1) # t2 = atual->next
    
    beq t2 zero encontrou_fim
    
    mv t1 t2 # atual = atual->next
    j percorrer
    
encontrou_fim:
    sw t0 4(t1) # atual->next = novo
    ret
 
lista_vazia:
    mv s0 t0 # s0 = novo
    ret
    
################# Função de imprimir ######################
imprimir_lista:
    mv t0 s0 # atual = lista
    
loop_imprimir:
    beq t0 zero fim_imprimir
    
    lw t1 0(t0) # t1 = atual->valor
    
    #imprime interio
    mv a0 t1
    li a1 1
    ecall
    
    #imprime espaço
    li a0 32
    li a1 11
    ecall
    
    lw t0 4(t0) # atual = atual->next
    j loop_imprimir
    
fim_imprimir:
    # imprime '/n'
    li a0 10
    li a1 11
    ecall
    
    ret
