# C function for the given question: 
# for( i = 0; i< n; i++ ){
#     while(stack.size() > 0 && stack.top() >= arr[i])
#         stack.pop()
#     if(stack.size() > 0)
#         ans[i] = stack.top()
#     else
#         ans[i] = -1
#     stack.push(arr[i])
# }
.global _start

.text

_start:
    movq $0, %r8                    # counter for loop === i
    movq $0, %r9                    # counter for stack size  === stack.size

L1:
    cmp %r8, %rbx                   # compare i and n
    jle exit                        # if i>=n, exit 

W1:
    movq $0, %r11
    cmp %r9, %r11                   # check size of stack
    je assign                       # if size == 0, go to assign
    popq %r11                       # put top of stack in r11
    pushq %r11                      # push back the top element
    cmp %r11, (%rcx, %r8, 8)        # compare stack.top and arr[i]
    jg assign                       # if stack.top<=arr[i], go to assign
    popq %r10                       # else pop
    dec %r9                         # decrease stack.size by 1
    jmp W1                          # and call the loop again

assign:
    movq $0, %r11                   
    cmp %r9, %r11                   # compare stack size with 0
    jl ans_top                      # if stack is not empty, ans[i] = stack.top
    movq $-1, (%rdx, %r8, 8)        # else ans[i] = -1
    jmp L1_recall                   # recall L1

ans_top:
    popq %r11                       # put stack.top in r11
    pushq %r11                      # put the top back in
    movq %r11, (%rdx, %r8, 8)       # assign ans[i]=stack.top

L1_recall:
    pushq (%rcx, %r8, 8)            # push the current element into the stack
    inc %r9                         # increase stack size by 1
    inc %r8                         # increase i by 1
    jmp L1                          # go back to L1

exit:
    xor %rdi, %rdi
    syscall
