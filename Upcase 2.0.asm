.text
.globl __start
__start:
    # Mostrar cadena original
    la $a0, prm1
    li $v0, 4
    syscall
    la $a0, orig
    li $v0, 4
    syscall

    # Inicialización
    la $s0, orig          # Dirección de la cadena
    li $t0, 0             # Contador de posición
    li $t2, 1             # Flag: 1 = próximo carácter debe verificarse (primer carácter o después de espacio)
    li $t6, 0x20          # ASCII space
    li $t7, 0x61          # ASCII 'a'
    li $t8, 0x7a          # ASCII 'z'
    add $t0, $t0, $s0     # Posición actual en cadena

loop:
    lb $t1, 0($t0)        # Cargar byte actual
    beq $t1, $zero, endLoop # Fin si carácter nulo
    
    # Verificar si es primer carácter o después de espacio
    beq $t2, $zero, check_space
    
    # Verificar si es minúscula (a-z)
    slt $t3, $t1, $t7     # t3=1 si t1 < 'a'
    slt $t4, $t8, $t1      # t4=1 si t1 > 'z'
    or $t3, $t3, $t4       # t3=1 si fuera de a-z
    bne $t3, $zero, not_lower
    
    # Convertir a mayúscula
    addi $t1, $t1, -32    # Diferencia ASCII entre may/min
    sb $t1, 0($t0)        # Guardar carácter modificado
    
not_lower:
    li $t2, 0             # Resetear flag
    
check_space:
    # Verificar si es espacio para marcar próximo carácter
    bne $t1, $t6, not_space
    li $t2, 1             # Marcar que próximo carácter debe verificarse
    
not_space:
    addi $t0, $t0, 1      # Siguiente carácter
    j loop

endLoop:
    # Mostrar resultado
    la $a0, prm2
    li $v0, 4
    syscall
    la $a0, orig
    li $v0, 4
    syscall
    
    # Terminar programa
    li $v0, 10
    syscall

.data
orig: .asciiz "la cadena original con letras todas minusculas"
prm1: .asciiz "Original: "
prm2: .asciiz "\nUpcased : "