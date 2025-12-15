
## 1
HOSTCFLAGS	:= -Wall -O0
cd OS5
make clean
make obj/__user_exit.out


## 2

b riscv_tr_translate_insn

b riscv_cpu_do_interrupt

b helper_sret

c



## 3
add-symbol-file obj/__user_exit.out

break user/libs/syscall.c:18

c

x/20i $pc

break kern/trap/trapentry.S:133

c