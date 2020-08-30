.global _start

.text

_start:
    mov $1,%r12
    mov $30,%rbx # contains a 
    mov $0,%rdx
    mov $16,%rcx # contains b
    mov %rbx,%rax
    mov $0,%rdx
    idiv %r12
    mov %rax,%r10  # shifting for division
    # r10 will contain the final answer initially set to the bigger value and then will be decreaseed.
    # r11 will store the gcd of the two numbers used.
_loop:
    mov $0,%rdx
    mov %rbx,%rax # put the bigger value in rax
    idiv %r10  # divide by the wannabe ans
    cmp $0,%rdx  # check if the remainder is zero
    je gcd   # if remainder is zero then check the gcd with the other number
 comeback:
    sub $1,%r10 # subtract one from the answer 
    
    jmp _loop  # repeat again

gcd:  # for gcd of wannabeans and chothi value r10 and rcx
    mov %rcx,%r11 # move the smaller number as initial number to be chekced for gcd
    check1:
    mov $0,%rdx
    mov %r10,%rax # mov the r10 value to rax for division
    idiv %r11
    cmp $0,%rdx # if  number divides the larger number jump to check for the smaller number 
    je check2   
    sub $1,%r11  # else subtract one and conitnue looking for gcd go to secind check
    jmp check1 
    check2:
    mov $0,%rdx  # check that the gcd is divdi0ng both the numbers. 
    mov %rcx,%rax #  rbx value by r11
    idiv %r11
    sub $1,%r11
    cmp $0,%rdx # if remainder is zero go to check that if it is one or not
    jne check1
    cmp $0,%r11  # if it is one then it is the ans otherwise go back to comeback and go through the whole process again
    je exit
    jmp comeback


exit:
    
    mov %r10,%rdx

    mov %r10,%rdx # to store the final answer in rdx again. 
    movq $60,%rax  # Exit 60 %rax
    xor %rdi,%rdi
    syscall






