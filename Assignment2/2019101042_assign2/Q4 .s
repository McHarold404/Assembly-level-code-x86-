  .globl _start

  .data
space:   .ascii " "
newline:   .ascii "\n"

  .text

f1:                             # Clear 64 bytes starting from rdi
  xor %rax, %rax                # Clear return value
  movl $64, %ecx                # Set 64 bytes to 0 starting from rsp
  rep stosb
  ret


f2:                             # void top(*tower)
  mov (%rdi),%ecx
  cmp $0, %ecx                  # Check if stack is empty
  jz .peek_empty                # If empty return large number
  dec %ecx
  movq 4(%rdi, %rcx, 4), %rax   # Return top
  ret
.peek_empty:
  mov $100000, %eax
  ret

f3:                             # void pop(*tower_1)
  movl (%rdi),%ebx
  dec %ebx
  movl 4(%rdi, %rbx, 4), %eax
  movl $0, 4(%rdi, %rbx, 4)
  mov %ebx, (%rdi)
  ret

f4:                             # void push(*tower, int x)
  movl (%rdi),%ecx
  mov %rsi, 4(%rdi, %rcx, 4)
  inc %ecx
  mov %ecx, (%rdi)
  ret

pt:
  mov %rdi, %rsi
  movl $1, %eax
  movl %eax, %edi
  movl %eax, %edx
  syscall
  ret

pt2:                            # Print a space
  push %rcx
  call pt
  mov $space, %rdi
  call pt
  pop %rcx
  ret

pt3:                            # Print new line
  mov $newline, %rdi
  call pt
  ret
pt4:                            # void pt4(int *tower)
  movl (%rdi), %ecx             # Store number of disks in the tower
  cmpl $0, %ecx
  jz pt6                        # If there are no disks print a newline
  add $4, %rdi                  # Data is stored from here
  sub $8, %rsp                  # Create space on stack
pt5:
  movl (%rdi), %eax             # Store number
  addl $'0', %eax               # Convert to ascii
  mov %rax, (%rsp)
  mov %rdi, %rbx
  mov %rsp, %rdi
  call pt2                      # Prints space
  add $4, %rbx
  mov %rbx, %rdi
  loop pt5
  add $8, %rsp
pt6:
  call pt3                      # Prints newline
  ret

pt7:                            # void pt7(), prints all the current state
  mov (%rbp), %rax              # This has the number of disks
  andl $1, %eax                 # Check if number of disks are even
  jz pt8                        # If n is even interchange destination and source pole
  lea -64(%rbp), %rdi
  call pt4                      # Prints first tower
  lea -128(%rbp), %rdi
  call pt4                      # Prints second tower
  lea -192(%rbp), %rdi
  call pt4                      # Prints third tower
  call pt3                      # Prints newline
  ret
pt8:
  lea -64(%rbp), %rdi
  call pt4                      # Prints fist tower
  lea -196(%rbp), %rdi           
  call pt4                      # Prints second tower
  lea -128(%rbp), %rdi
  call pt4                      # Prints third tower
  call pt3                      # Prints newline
  ret

f5:                             # void move(*tower_1, *tower_2)
  mov %rdi, %r9                 # Store rdi temporarily
  call f2                       # Check top of tower_1
  mov %rax, %r10                # Store value in r10
  mov %rsi, %rdi
  call f2                       # Check top of tower_2
  mov %r9, %rdi
  cmp %rax, %r10                # Compare which one is smaller
  jl .less_branch               # FIX: jg should be jl
.greater_branch:
  mov %rdi, %rax                # Swap rdi and rsi
  mov %rsi, %rdi                # Swap rdi and rsi
  mov %rax, %rsi                # Swap rdi and rsi
.less_branch:
  call f3                       # Move from rdi to rsi
  push %rdi                     # Store caller save registers
  push %rsi                     # Store caller save registers
  mov %rsi, %rdi
  mov %rax, %rsi
  call f4                       # Push disk to destination
  pop %rsi
  pop %rdi
  jmp pt7                       # Print current state

solve:                          # void solve(int x)
  push %rdi                     # stk.push(x), x is the number of rings
  mov %rsp, %rbp                # FIX: rbp wasn't updated

  sub $64, %rsp                 # Space for 8 variables on stack
  mov %rsp, %rdi                # rsp is first argument
  call f1                       # Set local variables to 0

  sub $64, %rsp                 # Space for 8 variables on stack
  mov %rsp, %rdi                # rsp is first argument
  call f1                       # Set local variables to 0

  sub $64, %rsp                 # Space for 8 variables on stack
  mov %rsp, %rdi                # rsp is first argument
  call f1                       # Set local variables to 0

  lea -64(%rbp), %rax
  mov (%rbp),%rcx
  mov %rcx, (%rax)
  add $4, %rax

.init_s:                        # Initialize the first tower
  mov %rcx, (%rax)
  add $4, %rax
  loop .init_s

  call pt7                      # Prints current state

  mov (%rbp), %cl               # Calculate number of moves needed
  mov $1, %r14
  shl %cl, %r14
  dec %r14                      # Number of move = 2^x - 1
  xor %r15,%r15                 # Counter variable

f7:
  lea -64(%rbp), %rdi           # S tower
  lea -192(%rbp), %rsi          # D tower
  call f5                       # Move

  inc %r15                      # i++
  cmp %r14, %r15                # if(i >= 2^x - 1)
  jge f8                        #   break

  lea -64(%rbp), %rdi           # S tower
  lea -128(%rbp), %rsi          # A tower
  call f5                       # Move

  inc %r15                      # i++
  cmp %r14, %r15                # if(i >= 2^x - 1)
  jge f8                        #   break

  lea -192(%rbp), %rdi          # D tower
  lea -128(%rbp), %rsi          # A tower
  call f5                       # Move

  inc %r15                      # i++
  cmp %r14, %r15                # if(i >= 2^x - 1)
  jge f8                        #   break
  jmp f7

f8:
  lea 8(%rbp), %rsp
  ret

_start:
  mov $3, %edi
  cmpl $1, (%rsp)               # stack pointer stores the number of cmdline arguments
  jle .solve                    # If no argument is given default is 3
  mov 16(%rsp), %rax            # Get number of discs
  movsbl (%rax), %edi
  sub $'0', %edi                # Convert from ascii to int
.solve:
  call solve

exit:
  mov $60, %rax
  xor %rdi, %rdi
  syscall
