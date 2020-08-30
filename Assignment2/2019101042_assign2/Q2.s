.global _start


.text

_start:
    mov $100,%rbx # rbx contains the n
    mov $100,%rcx # rcx contains the mod 
    mov $1,%r8  # used for finding fibancci iterator 1
    mov $1,%r9  # used for finding fibonacci iterator 2
    mov $0,%r12 # will contain the answer
_loop:
    mov %r9,%r10 # r10 is the temporary register for calculating fibonacci
    add %r8,%r9  # go to the next fibonacci number 
    cmp %rbx,%r9 # check if its less than n if yes then jump 
    jle factorial
    jmp last1 # otherwise exit
label2:
    mov %r10,%r8
    jmp _loop

factorial:
    mov %r9,%r13 # r13 is the counter and r9 ka factorial nikalna hai
    mov $1,%r14 # r14 will be the value of the factorial.
factorial2:
    imul %r13,%r14 # factorial multiplied with current n
    mov %r14,%rax
    mov $0,%rdx
    idiv %rcx # divide to take mod
    mov %rdx,%r14 # store the mod back in r14
    sub $1,%r13
    cmp $1,%r13 # check if counter is more than 1 them jump back
    jge factorial2
    add %r14,%r12 # add factorial to final answer
    mov %r12 ,%rax # mov for division
    mov $0,%rdx
    idiv %rcx # take mod
    mov %rdx,%r12 # store the mod back and go back 
    jmp label2


last1:
    add $1,%r12 # as one will not be added before
    mov %r12,%rax # move for div
    mov $0,%rdx # clear rdx
    idiv %rcx 
    mov %rdx,%r12 # store the final value back 


exit:

    mov %rax,%r10  #FINAL ANSWER IS IN r10
    movq $60,%rax  #Exit 60 %rax
    xor %rdi,%rdi
    syscall
