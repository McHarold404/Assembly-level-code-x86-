.global _start

.text

_start:
mov $1,%r10  	
mov	$2,%rbx
mov	$2,%rcx #take loaded value of the register and put it in rcx.
mov $0,%rdx
mov $0,%r11  

loop:
mov $0,%r11
imulq %rbx,%r10
inc	%rbx
mov %r10,%rax
divq %rcx
mov %rdx,%r11
mov $0,%rdx
cmp $0,%r11
jne loop

sub $1,%rbx
mov %rbx,%r11

exit:
mov     $60,%rax
xor     %rdx,%rdx
syscall

