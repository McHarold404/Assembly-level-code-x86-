.global _start

.text
#r 8 is a
#r 9 is b
# r10 is n
_start:
mov $2,%r14 #constant value
#mov $30,%r8 #a
#mov $51,%r9  #b
#mov $78,%r10  #n
mov $0,%rdx
mov $0,%rax
mov $1,%rcx  #acc



mov %r8,%rax
divq %r10	#division
mov %rdx,%r8 
mov $0,%rdx # reset remainder to 0
mov $0,%rax

loop:
mov $0,%r15
mov %r9,%rax
mov $0,%rdx
divq %r14
cmp $1,%rdx
jnz loop2

#mov $0,%rax
#mov $0,%rdx
imul %r8,%rcx
mov %rcx,%rax
mov $0,%rdx
divq %r10 	#division kari
#mov $0,%rax  #reset quotient
mov %rdx,%rcx  #store remainder in acc again


loop2:
mov %r9,%rax
mov $0,%rdx   #reset remainder
divq %r14         
mov %rax,%r9   #40-45 b=b/2
#mov $0,%rax
#mov $0,%rdx
imul %r8,%r8
mov %r8,%rax
mov $0,%rdx
divq %r10
mov %rdx,%r8
#mov $0,%rax
#mov $0,%rdx
mov %r9,%r15
cmp $0,%r15
jnz loop

mov %rcx,%rdi
exit:
mov     $60,%rax
xor     %rdx,%rdx
syscall










