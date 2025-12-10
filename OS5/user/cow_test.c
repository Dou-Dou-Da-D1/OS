#include <stdio.h>
#include <ulib.h>
#include <unistd.h>

int global_data = 100;

int main(void) {
    cprintf("COW Test Start\n");
    cprintf("Before fork: global_data = %d at %x\n", global_data, &global_data);
    
    int pid = fork();
    
    if (pid == 0) {
        // 子进程
        cprintf("Child: global_data = %d at %x\n", global_data, &global_data);
        global_data = 200;  // 触发 COW
        cprintf("Child: after write, global_data = %d at %x\n", global_data, &global_data);
        exit(0);
    } else if (pid > 0) {
        // 父进程
        cprintf("Parent: global_data = %d at %x\n", global_data, &global_data);
        // ucore 的 wait() 不接受参数
        wait();
        cprintf("Parent: after child exit, global_data = %d at %x\n", global_data, &global_data);
        
        if (global_data == 100) {
            cprintf("COW Test PASS!\n");
        } else {
            cprintf("COW Test FAIL!\n");
        }
    } else {
        cprintf("Fork failed!\n");
    }
    
    return 0;
}
