
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00007297          	auipc	t0,0x7
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0207000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00007297          	auipc	t0,0x7
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0207008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02062b7          	lui	t0,0xc0206
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc0200034:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200038:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc020003c:	c0206137          	lui	sp,0xc0206

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 1. 使用临时寄存器 t1 计算栈顶的精确地址
    lui t1, %hi(bootstacktop)
ffffffffc0200040:	c0206337          	lui	t1,0xc0206
    addi t1, t1, %lo(bootstacktop)
ffffffffc0200044:	00030313          	mv	t1,t1
    # 2. 将精确地址一次性地、安全地传给 sp
    mv sp, t1
ffffffffc0200048:	811a                	mv	sp,t1
    # 现在栈指针已经完美设置，可以安全地调用任何C函数了
    # 然后跳转到 kern_init (不再返回)
    lui t0, %hi(kern_init)
ffffffffc020004a:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc020004e:	05428293          	addi	t0,t0,84 # ffffffffc0200054 <kern_init>
    jr t0
ffffffffc0200052:	8282                	jr	t0

ffffffffc0200054 <kern_init>:
void grade_backtrace(void);

int kern_init(void) {
    extern char edata[], end[];
    // 先清零 BSS，再读取并保存 DTB 的内存信息，避免被清零覆盖（为了解释变化 正式上传时我觉得应该删去这句话）
    memset(edata, 0, end - edata);
ffffffffc0200054:	00007517          	auipc	a0,0x7
ffffffffc0200058:	fd450513          	addi	a0,a0,-44 # ffffffffc0207028 <free_area>
ffffffffc020005c:	00007617          	auipc	a2,0x7
ffffffffc0200060:	44c60613          	addi	a2,a2,1100 # ffffffffc02074a8 <end>
int kern_init(void) {
ffffffffc0200064:	1141                	addi	sp,sp,-16 # ffffffffc0205ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc0200066:	8e09                	sub	a2,a2,a0
ffffffffc0200068:	4581                	li	a1,0
int kern_init(void) {
ffffffffc020006a:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020006c:	6ef010ef          	jal	ffffffffc0201f5a <memset>
    dtb_init();
ffffffffc0200070:	3c6000ef          	jal	ffffffffc0200436 <dtb_init>
    cons_init();  // init the console
ffffffffc0200074:	3b4000ef          	jal	ffffffffc0200428 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200078:	00002517          	auipc	a0,0x2
ffffffffc020007c:	ef850513          	addi	a0,a0,-264 # ffffffffc0201f70 <etext+0x4>
ffffffffc0200080:	08c000ef          	jal	ffffffffc020010c <cputs>

    print_kerninfo();
ffffffffc0200084:	0e4000ef          	jal	ffffffffc0200168 <print_kerninfo>

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table
ffffffffc0200088:	700000ef          	jal	ffffffffc0200788 <idt_init>

    pmm_init();  // init physical memory management
ffffffffc020008c:	764010ef          	jal	ffffffffc02017f0 <pmm_init>

    idt_init();  // init interrupt descriptor table
ffffffffc0200090:	6f8000ef          	jal	ffffffffc0200788 <idt_init>

    clock_init();   // init clock interrupt
ffffffffc0200094:	352000ef          	jal	ffffffffc02003e6 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200098:	6e4000ef          	jal	ffffffffc020077c <intr_enable>

    /* do nothing */
    while (1)
ffffffffc020009c:	a001                	j	ffffffffc020009c <kern_init+0x48>

ffffffffc020009e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc020009e:	1101                	addi	sp,sp,-32
ffffffffc02000a0:	ec06                	sd	ra,24(sp)
ffffffffc02000a2:	e42e                	sd	a1,8(sp)
    cons_putc(c);
ffffffffc02000a4:	386000ef          	jal	ffffffffc020042a <cons_putc>
    (*cnt) ++;
ffffffffc02000a8:	65a2                	ld	a1,8(sp)
}
ffffffffc02000aa:	60e2                	ld	ra,24(sp)
    (*cnt) ++;
ffffffffc02000ac:	419c                	lw	a5,0(a1)
ffffffffc02000ae:	2785                	addiw	a5,a5,1
ffffffffc02000b0:	c19c                	sw	a5,0(a1)
}
ffffffffc02000b2:	6105                	addi	sp,sp,32
ffffffffc02000b4:	8082                	ret

ffffffffc02000b6 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000b6:	1101                	addi	sp,sp,-32
ffffffffc02000b8:	862a                	mv	a2,a0
ffffffffc02000ba:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000bc:	00000517          	auipc	a0,0x0
ffffffffc02000c0:	fe250513          	addi	a0,a0,-30 # ffffffffc020009e <cputch>
ffffffffc02000c4:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000c6:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000c8:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000ca:	169010ef          	jal	ffffffffc0201a32 <vprintfmt>
    return cnt;
}
ffffffffc02000ce:	60e2                	ld	ra,24(sp)
ffffffffc02000d0:	4532                	lw	a0,12(sp)
ffffffffc02000d2:	6105                	addi	sp,sp,32
ffffffffc02000d4:	8082                	ret

ffffffffc02000d6 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000d6:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000d8:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
ffffffffc02000dc:	f42e                	sd	a1,40(sp)
ffffffffc02000de:	f832                	sd	a2,48(sp)
ffffffffc02000e0:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000e2:	862a                	mv	a2,a0
ffffffffc02000e4:	004c                	addi	a1,sp,4
ffffffffc02000e6:	00000517          	auipc	a0,0x0
ffffffffc02000ea:	fb850513          	addi	a0,a0,-72 # ffffffffc020009e <cputch>
ffffffffc02000ee:	869a                	mv	a3,t1
cprintf(const char *fmt, ...) {
ffffffffc02000f0:	ec06                	sd	ra,24(sp)
ffffffffc02000f2:	e0ba                	sd	a4,64(sp)
ffffffffc02000f4:	e4be                	sd	a5,72(sp)
ffffffffc02000f6:	e8c2                	sd	a6,80(sp)
ffffffffc02000f8:	ecc6                	sd	a7,88(sp)
    int cnt = 0;
ffffffffc02000fa:	c202                	sw	zero,4(sp)
    va_start(ap, fmt);
ffffffffc02000fc:	e41a                	sd	t1,8(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000fe:	135010ef          	jal	ffffffffc0201a32 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc0200102:	60e2                	ld	ra,24(sp)
ffffffffc0200104:	4512                	lw	a0,4(sp)
ffffffffc0200106:	6125                	addi	sp,sp,96
ffffffffc0200108:	8082                	ret

ffffffffc020010a <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc020010a:	a605                	j	ffffffffc020042a <cons_putc>

ffffffffc020010c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc020010c:	1101                	addi	sp,sp,-32
ffffffffc020010e:	e822                	sd	s0,16(sp)
ffffffffc0200110:	ec06                	sd	ra,24(sp)
ffffffffc0200112:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc0200114:	00054503          	lbu	a0,0(a0)
ffffffffc0200118:	c51d                	beqz	a0,ffffffffc0200146 <cputs+0x3a>
ffffffffc020011a:	e426                	sd	s1,8(sp)
ffffffffc020011c:	0405                	addi	s0,s0,1
    int cnt = 0;
ffffffffc020011e:	4481                	li	s1,0
    cons_putc(c);
ffffffffc0200120:	30a000ef          	jal	ffffffffc020042a <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc0200124:	00044503          	lbu	a0,0(s0)
ffffffffc0200128:	0405                	addi	s0,s0,1
ffffffffc020012a:	87a6                	mv	a5,s1
    (*cnt) ++;
ffffffffc020012c:	2485                	addiw	s1,s1,1
    while ((c = *str ++) != '\0') {
ffffffffc020012e:	f96d                	bnez	a0,ffffffffc0200120 <cputs+0x14>
    cons_putc(c);
ffffffffc0200130:	4529                	li	a0,10
    (*cnt) ++;
ffffffffc0200132:	0027841b          	addiw	s0,a5,2
ffffffffc0200136:	64a2                	ld	s1,8(sp)
    cons_putc(c);
ffffffffc0200138:	2f2000ef          	jal	ffffffffc020042a <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc020013c:	60e2                	ld	ra,24(sp)
ffffffffc020013e:	8522                	mv	a0,s0
ffffffffc0200140:	6442                	ld	s0,16(sp)
ffffffffc0200142:	6105                	addi	sp,sp,32
ffffffffc0200144:	8082                	ret
    cons_putc(c);
ffffffffc0200146:	4529                	li	a0,10
ffffffffc0200148:	2e2000ef          	jal	ffffffffc020042a <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc020014c:	4405                	li	s0,1
}
ffffffffc020014e:	60e2                	ld	ra,24(sp)
ffffffffc0200150:	8522                	mv	a0,s0
ffffffffc0200152:	6442                	ld	s0,16(sp)
ffffffffc0200154:	6105                	addi	sp,sp,32
ffffffffc0200156:	8082                	ret

ffffffffc0200158 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc0200158:	1141                	addi	sp,sp,-16
ffffffffc020015a:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020015c:	2d6000ef          	jal	ffffffffc0200432 <cons_getc>
ffffffffc0200160:	dd75                	beqz	a0,ffffffffc020015c <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200162:	60a2                	ld	ra,8(sp)
ffffffffc0200164:	0141                	addi	sp,sp,16
ffffffffc0200166:	8082                	ret

ffffffffc0200168 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200168:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020016a:	00002517          	auipc	a0,0x2
ffffffffc020016e:	e2650513          	addi	a0,a0,-474 # ffffffffc0201f90 <etext+0x24>
void print_kerninfo(void) {
ffffffffc0200172:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200174:	f63ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc0200178:	00000597          	auipc	a1,0x0
ffffffffc020017c:	edc58593          	addi	a1,a1,-292 # ffffffffc0200054 <kern_init>
ffffffffc0200180:	00002517          	auipc	a0,0x2
ffffffffc0200184:	e3050513          	addi	a0,a0,-464 # ffffffffc0201fb0 <etext+0x44>
ffffffffc0200188:	f4fff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc020018c:	00002597          	auipc	a1,0x2
ffffffffc0200190:	de058593          	addi	a1,a1,-544 # ffffffffc0201f6c <etext>
ffffffffc0200194:	00002517          	auipc	a0,0x2
ffffffffc0200198:	e3c50513          	addi	a0,a0,-452 # ffffffffc0201fd0 <etext+0x64>
ffffffffc020019c:	f3bff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc02001a0:	00007597          	auipc	a1,0x7
ffffffffc02001a4:	e8858593          	addi	a1,a1,-376 # ffffffffc0207028 <free_area>
ffffffffc02001a8:	00002517          	auipc	a0,0x2
ffffffffc02001ac:	e4850513          	addi	a0,a0,-440 # ffffffffc0201ff0 <etext+0x84>
ffffffffc02001b0:	f27ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc02001b4:	00007597          	auipc	a1,0x7
ffffffffc02001b8:	2f458593          	addi	a1,a1,756 # ffffffffc02074a8 <end>
ffffffffc02001bc:	00002517          	auipc	a0,0x2
ffffffffc02001c0:	e5450513          	addi	a0,a0,-428 # ffffffffc0202010 <etext+0xa4>
ffffffffc02001c4:	f13ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001c8:	00000717          	auipc	a4,0x0
ffffffffc02001cc:	e8c70713          	addi	a4,a4,-372 # ffffffffc0200054 <kern_init>
ffffffffc02001d0:	00007797          	auipc	a5,0x7
ffffffffc02001d4:	6d778793          	addi	a5,a5,1751 # ffffffffc02078a7 <end+0x3ff>
ffffffffc02001d8:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001da:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02001de:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001e0:	3ff5f593          	andi	a1,a1,1023
ffffffffc02001e4:	95be                	add	a1,a1,a5
ffffffffc02001e6:	85a9                	srai	a1,a1,0xa
ffffffffc02001e8:	00002517          	auipc	a0,0x2
ffffffffc02001ec:	e4850513          	addi	a0,a0,-440 # ffffffffc0202030 <etext+0xc4>
}
ffffffffc02001f0:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001f2:	b5d5                	j	ffffffffc02000d6 <cprintf>

ffffffffc02001f4 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc02001f4:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02001f6:	00002617          	auipc	a2,0x2
ffffffffc02001fa:	e6a60613          	addi	a2,a2,-406 # ffffffffc0202060 <etext+0xf4>
ffffffffc02001fe:	04d00593          	li	a1,77
ffffffffc0200202:	00002517          	auipc	a0,0x2
ffffffffc0200206:	e7650513          	addi	a0,a0,-394 # ffffffffc0202078 <etext+0x10c>
void print_stackframe(void) {
ffffffffc020020a:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc020020c:	17c000ef          	jal	ffffffffc0200388 <__panic>

ffffffffc0200210 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200210:	1101                	addi	sp,sp,-32
ffffffffc0200212:	e822                	sd	s0,16(sp)
ffffffffc0200214:	e426                	sd	s1,8(sp)
ffffffffc0200216:	ec06                	sd	ra,24(sp)
ffffffffc0200218:	00003417          	auipc	s0,0x3
ffffffffc020021c:	bd840413          	addi	s0,s0,-1064 # ffffffffc0202df0 <commands>
ffffffffc0200220:	00003497          	auipc	s1,0x3
ffffffffc0200224:	c1848493          	addi	s1,s1,-1000 # ffffffffc0202e38 <commands+0x48>
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200228:	6410                	ld	a2,8(s0)
ffffffffc020022a:	600c                	ld	a1,0(s0)
ffffffffc020022c:	00002517          	auipc	a0,0x2
ffffffffc0200230:	e6450513          	addi	a0,a0,-412 # ffffffffc0202090 <etext+0x124>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200234:	0461                	addi	s0,s0,24
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200236:	ea1ff0ef          	jal	ffffffffc02000d6 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020023a:	fe9417e3          	bne	s0,s1,ffffffffc0200228 <mon_help+0x18>
    }
    return 0;
}
ffffffffc020023e:	60e2                	ld	ra,24(sp)
ffffffffc0200240:	6442                	ld	s0,16(sp)
ffffffffc0200242:	64a2                	ld	s1,8(sp)
ffffffffc0200244:	4501                	li	a0,0
ffffffffc0200246:	6105                	addi	sp,sp,32
ffffffffc0200248:	8082                	ret

ffffffffc020024a <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc020024a:	1141                	addi	sp,sp,-16
ffffffffc020024c:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020024e:	f1bff0ef          	jal	ffffffffc0200168 <print_kerninfo>
    return 0;
}
ffffffffc0200252:	60a2                	ld	ra,8(sp)
ffffffffc0200254:	4501                	li	a0,0
ffffffffc0200256:	0141                	addi	sp,sp,16
ffffffffc0200258:	8082                	ret

ffffffffc020025a <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc020025a:	1141                	addi	sp,sp,-16
ffffffffc020025c:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020025e:	f97ff0ef          	jal	ffffffffc02001f4 <print_stackframe>
    return 0;
}
ffffffffc0200262:	60a2                	ld	ra,8(sp)
ffffffffc0200264:	4501                	li	a0,0
ffffffffc0200266:	0141                	addi	sp,sp,16
ffffffffc0200268:	8082                	ret

ffffffffc020026a <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc020026a:	7131                	addi	sp,sp,-192
ffffffffc020026c:	e952                	sd	s4,144(sp)
ffffffffc020026e:	8a2a                	mv	s4,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200270:	00002517          	auipc	a0,0x2
ffffffffc0200274:	e3050513          	addi	a0,a0,-464 # ffffffffc02020a0 <etext+0x134>
kmonitor(struct trapframe *tf) {
ffffffffc0200278:	fd06                	sd	ra,184(sp)
ffffffffc020027a:	f922                	sd	s0,176(sp)
ffffffffc020027c:	f526                	sd	s1,168(sp)
ffffffffc020027e:	ed4e                	sd	s3,152(sp)
ffffffffc0200280:	e556                	sd	s5,136(sp)
ffffffffc0200282:	e15a                	sd	s6,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200284:	e53ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200288:	00002517          	auipc	a0,0x2
ffffffffc020028c:	e4050513          	addi	a0,a0,-448 # ffffffffc02020c8 <etext+0x15c>
ffffffffc0200290:	e47ff0ef          	jal	ffffffffc02000d6 <cprintf>
    if (tf != NULL) {
ffffffffc0200294:	000a0563          	beqz	s4,ffffffffc020029e <kmonitor+0x34>
        print_trapframe(tf);
ffffffffc0200298:	8552                	mv	a0,s4
ffffffffc020029a:	6e6000ef          	jal	ffffffffc0200980 <print_trapframe>
ffffffffc020029e:	00003a97          	auipc	s5,0x3
ffffffffc02002a2:	b52a8a93          	addi	s5,s5,-1198 # ffffffffc0202df0 <commands>
        if (argc == MAXARGS - 1) {
ffffffffc02002a6:	49bd                	li	s3,15
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02002a8:	00002517          	auipc	a0,0x2
ffffffffc02002ac:	e4850513          	addi	a0,a0,-440 # ffffffffc02020f0 <etext+0x184>
ffffffffc02002b0:	2e9010ef          	jal	ffffffffc0201d98 <readline>
ffffffffc02002b4:	842a                	mv	s0,a0
ffffffffc02002b6:	d96d                	beqz	a0,ffffffffc02002a8 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002b8:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02002bc:	4481                	li	s1,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002be:	e99d                	bnez	a1,ffffffffc02002f4 <kmonitor+0x8a>
    int argc = 0;
ffffffffc02002c0:	8b26                	mv	s6,s1
    if (argc == 0) {
ffffffffc02002c2:	fe0b03e3          	beqz	s6,ffffffffc02002a8 <kmonitor+0x3e>
ffffffffc02002c6:	00003497          	auipc	s1,0x3
ffffffffc02002ca:	b2a48493          	addi	s1,s1,-1238 # ffffffffc0202df0 <commands>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002ce:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02002d0:	6582                	ld	a1,0(sp)
ffffffffc02002d2:	6088                	ld	a0,0(s1)
ffffffffc02002d4:	419010ef          	jal	ffffffffc0201eec <strcmp>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002d8:	478d                	li	a5,3
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02002da:	c149                	beqz	a0,ffffffffc020035c <kmonitor+0xf2>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002dc:	2405                	addiw	s0,s0,1
ffffffffc02002de:	04e1                	addi	s1,s1,24
ffffffffc02002e0:	fef418e3          	bne	s0,a5,ffffffffc02002d0 <kmonitor+0x66>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02002e4:	6582                	ld	a1,0(sp)
ffffffffc02002e6:	00002517          	auipc	a0,0x2
ffffffffc02002ea:	e3a50513          	addi	a0,a0,-454 # ffffffffc0202120 <etext+0x1b4>
ffffffffc02002ee:	de9ff0ef          	jal	ffffffffc02000d6 <cprintf>
    return 0;
ffffffffc02002f2:	bf5d                	j	ffffffffc02002a8 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002f4:	00002517          	auipc	a0,0x2
ffffffffc02002f8:	e0450513          	addi	a0,a0,-508 # ffffffffc02020f8 <etext+0x18c>
ffffffffc02002fc:	44d010ef          	jal	ffffffffc0201f48 <strchr>
ffffffffc0200300:	c901                	beqz	a0,ffffffffc0200310 <kmonitor+0xa6>
ffffffffc0200302:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200306:	00040023          	sb	zero,0(s0)
ffffffffc020030a:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020030c:	d9d5                	beqz	a1,ffffffffc02002c0 <kmonitor+0x56>
ffffffffc020030e:	b7dd                	j	ffffffffc02002f4 <kmonitor+0x8a>
        if (*buf == '\0') {
ffffffffc0200310:	00044783          	lbu	a5,0(s0)
ffffffffc0200314:	d7d5                	beqz	a5,ffffffffc02002c0 <kmonitor+0x56>
        if (argc == MAXARGS - 1) {
ffffffffc0200316:	03348b63          	beq	s1,s3,ffffffffc020034c <kmonitor+0xe2>
        argv[argc ++] = buf;
ffffffffc020031a:	00349793          	slli	a5,s1,0x3
ffffffffc020031e:	978a                	add	a5,a5,sp
ffffffffc0200320:	e380                	sd	s0,0(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200322:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc0200326:	2485                	addiw	s1,s1,1
ffffffffc0200328:	8b26                	mv	s6,s1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020032a:	e591                	bnez	a1,ffffffffc0200336 <kmonitor+0xcc>
ffffffffc020032c:	bf59                	j	ffffffffc02002c2 <kmonitor+0x58>
ffffffffc020032e:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc0200332:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200334:	d5d1                	beqz	a1,ffffffffc02002c0 <kmonitor+0x56>
ffffffffc0200336:	00002517          	auipc	a0,0x2
ffffffffc020033a:	dc250513          	addi	a0,a0,-574 # ffffffffc02020f8 <etext+0x18c>
ffffffffc020033e:	40b010ef          	jal	ffffffffc0201f48 <strchr>
ffffffffc0200342:	d575                	beqz	a0,ffffffffc020032e <kmonitor+0xc4>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200344:	00044583          	lbu	a1,0(s0)
ffffffffc0200348:	dda5                	beqz	a1,ffffffffc02002c0 <kmonitor+0x56>
ffffffffc020034a:	b76d                	j	ffffffffc02002f4 <kmonitor+0x8a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020034c:	45c1                	li	a1,16
ffffffffc020034e:	00002517          	auipc	a0,0x2
ffffffffc0200352:	db250513          	addi	a0,a0,-590 # ffffffffc0202100 <etext+0x194>
ffffffffc0200356:	d81ff0ef          	jal	ffffffffc02000d6 <cprintf>
ffffffffc020035a:	b7c1                	j	ffffffffc020031a <kmonitor+0xb0>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc020035c:	00141793          	slli	a5,s0,0x1
ffffffffc0200360:	97a2                	add	a5,a5,s0
ffffffffc0200362:	078e                	slli	a5,a5,0x3
ffffffffc0200364:	97d6                	add	a5,a5,s5
ffffffffc0200366:	6b9c                	ld	a5,16(a5)
ffffffffc0200368:	fffb051b          	addiw	a0,s6,-1
ffffffffc020036c:	8652                	mv	a2,s4
ffffffffc020036e:	002c                	addi	a1,sp,8
ffffffffc0200370:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc0200372:	f2055be3          	bgez	a0,ffffffffc02002a8 <kmonitor+0x3e>
}
ffffffffc0200376:	70ea                	ld	ra,184(sp)
ffffffffc0200378:	744a                	ld	s0,176(sp)
ffffffffc020037a:	74aa                	ld	s1,168(sp)
ffffffffc020037c:	69ea                	ld	s3,152(sp)
ffffffffc020037e:	6a4a                	ld	s4,144(sp)
ffffffffc0200380:	6aaa                	ld	s5,136(sp)
ffffffffc0200382:	6b0a                	ld	s6,128(sp)
ffffffffc0200384:	6129                	addi	sp,sp,192
ffffffffc0200386:	8082                	ret

ffffffffc0200388 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200388:	00007317          	auipc	t1,0x7
ffffffffc020038c:	0b832303          	lw	t1,184(t1) # ffffffffc0207440 <is_panic>
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200390:	715d                	addi	sp,sp,-80
ffffffffc0200392:	ec06                	sd	ra,24(sp)
ffffffffc0200394:	f436                	sd	a3,40(sp)
ffffffffc0200396:	f83a                	sd	a4,48(sp)
ffffffffc0200398:	fc3e                	sd	a5,56(sp)
ffffffffc020039a:	e0c2                	sd	a6,64(sp)
ffffffffc020039c:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc020039e:	02031e63          	bnez	t1,ffffffffc02003da <__panic+0x52>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02003a2:	4705                	li	a4,1

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02003a4:	103c                	addi	a5,sp,40
ffffffffc02003a6:	e822                	sd	s0,16(sp)
ffffffffc02003a8:	8432                	mv	s0,a2
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02003aa:	862e                	mv	a2,a1
ffffffffc02003ac:	85aa                	mv	a1,a0
ffffffffc02003ae:	00002517          	auipc	a0,0x2
ffffffffc02003b2:	e1a50513          	addi	a0,a0,-486 # ffffffffc02021c8 <etext+0x25c>
    is_panic = 1;
ffffffffc02003b6:	00007697          	auipc	a3,0x7
ffffffffc02003ba:	08e6a523          	sw	a4,138(a3) # ffffffffc0207440 <is_panic>
    va_start(ap, fmt);
ffffffffc02003be:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02003c0:	d17ff0ef          	jal	ffffffffc02000d6 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02003c4:	65a2                	ld	a1,8(sp)
ffffffffc02003c6:	8522                	mv	a0,s0
ffffffffc02003c8:	cefff0ef          	jal	ffffffffc02000b6 <vcprintf>
    cprintf("\n");
ffffffffc02003cc:	00002517          	auipc	a0,0x2
ffffffffc02003d0:	e1c50513          	addi	a0,a0,-484 # ffffffffc02021e8 <etext+0x27c>
ffffffffc02003d4:	d03ff0ef          	jal	ffffffffc02000d6 <cprintf>
ffffffffc02003d8:	6442                	ld	s0,16(sp)
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc02003da:	3a8000ef          	jal	ffffffffc0200782 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc02003de:	4501                	li	a0,0
ffffffffc02003e0:	e8bff0ef          	jal	ffffffffc020026a <kmonitor>
    while (1) {
ffffffffc02003e4:	bfed                	j	ffffffffc02003de <__panic+0x56>

ffffffffc02003e6 <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
ffffffffc02003e6:	1141                	addi	sp,sp,-16
ffffffffc02003e8:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
ffffffffc02003ea:	02000793          	li	a5,32
ffffffffc02003ee:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02003f2:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02003f6:	67e1                	lui	a5,0x18
ffffffffc02003f8:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc02003fc:	953e                	add	a0,a0,a5
ffffffffc02003fe:	26b010ef          	jal	ffffffffc0201e68 <sbi_set_timer>
}
ffffffffc0200402:	60a2                	ld	ra,8(sp)
    ticks = 0;
ffffffffc0200404:	00007797          	auipc	a5,0x7
ffffffffc0200408:	0407b223          	sd	zero,68(a5) # ffffffffc0207448 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020040c:	00002517          	auipc	a0,0x2
ffffffffc0200410:	de450513          	addi	a0,a0,-540 # ffffffffc02021f0 <etext+0x284>
}
ffffffffc0200414:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
ffffffffc0200416:	b1c1                	j	ffffffffc02000d6 <cprintf>

ffffffffc0200418 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200418:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020041c:	67e1                	lui	a5,0x18
ffffffffc020041e:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200422:	953e                	add	a0,a0,a5
ffffffffc0200424:	2450106f          	j	ffffffffc0201e68 <sbi_set_timer>

ffffffffc0200428 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200428:	8082                	ret

ffffffffc020042a <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc020042a:	0ff57513          	zext.b	a0,a0
ffffffffc020042e:	2210106f          	j	ffffffffc0201e4e <sbi_console_putchar>

ffffffffc0200432 <cons_getc>:
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
ffffffffc0200432:	2510106f          	j	ffffffffc0201e82 <sbi_console_getchar>

ffffffffc0200436 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200436:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc0200438:	00002517          	auipc	a0,0x2
ffffffffc020043c:	dd850513          	addi	a0,a0,-552 # ffffffffc0202210 <etext+0x2a4>
void dtb_init(void) {
ffffffffc0200440:	f406                	sd	ra,40(sp)
ffffffffc0200442:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc0200444:	c93ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200448:	00007597          	auipc	a1,0x7
ffffffffc020044c:	bb85b583          	ld	a1,-1096(a1) # ffffffffc0207000 <boot_hartid>
ffffffffc0200450:	00002517          	auipc	a0,0x2
ffffffffc0200454:	dd050513          	addi	a0,a0,-560 # ffffffffc0202220 <etext+0x2b4>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200458:	00007417          	auipc	s0,0x7
ffffffffc020045c:	bb040413          	addi	s0,s0,-1104 # ffffffffc0207008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200460:	c77ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200464:	600c                	ld	a1,0(s0)
ffffffffc0200466:	00002517          	auipc	a0,0x2
ffffffffc020046a:	dca50513          	addi	a0,a0,-566 # ffffffffc0202230 <etext+0x2c4>
ffffffffc020046e:	c69ff0ef          	jal	ffffffffc02000d6 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200472:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200474:	00002517          	auipc	a0,0x2
ffffffffc0200478:	dd450513          	addi	a0,a0,-556 # ffffffffc0202248 <etext+0x2dc>
    if (boot_dtb == 0) {
ffffffffc020047c:	10070163          	beqz	a4,ffffffffc020057e <dtb_init+0x148>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200480:	57f5                	li	a5,-3
ffffffffc0200482:	07fa                	slli	a5,a5,0x1e
ffffffffc0200484:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200486:	431c                	lw	a5,0(a4)
    if (magic != 0xd00dfeed) {
ffffffffc0200488:	d00e06b7          	lui	a3,0xd00e0
ffffffffc020048c:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfed8a45>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200490:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200494:	0187961b          	slliw	a2,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200498:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020049c:	0ff5f593          	zext.b	a1,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004a0:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004a4:	05c2                	slli	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004a6:	8e49                	or	a2,a2,a0
ffffffffc02004a8:	0ff7f793          	zext.b	a5,a5
ffffffffc02004ac:	8dd1                	or	a1,a1,a2
ffffffffc02004ae:	07a2                	slli	a5,a5,0x8
ffffffffc02004b0:	8ddd                	or	a1,a1,a5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004b2:	00ff0837          	lui	a6,0xff0
    if (magic != 0xd00dfeed) {
ffffffffc02004b6:	0cd59863          	bne	a1,a3,ffffffffc0200586 <dtb_init+0x150>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02004ba:	4710                	lw	a2,8(a4)
ffffffffc02004bc:	4754                	lw	a3,12(a4)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02004be:	e84a                	sd	s2,16(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c0:	0086541b          	srliw	s0,a2,0x8
ffffffffc02004c4:	0086d79b          	srliw	a5,a3,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004c8:	01865e1b          	srliw	t3,a2,0x18
ffffffffc02004cc:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004d0:	0186151b          	slliw	a0,a2,0x18
ffffffffc02004d4:	0186959b          	slliw	a1,a3,0x18
ffffffffc02004d8:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004dc:	0106561b          	srliw	a2,a2,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004e0:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004e4:	0106d69b          	srliw	a3,a3,0x10
ffffffffc02004e8:	01c56533          	or	a0,a0,t3
ffffffffc02004ec:	0115e5b3          	or	a1,a1,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004f0:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004f4:	0ff67613          	zext.b	a2,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004f8:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004fc:	0ff6f693          	zext.b	a3,a3
ffffffffc0200500:	8c49                	or	s0,s0,a0
ffffffffc0200502:	0622                	slli	a2,a2,0x8
ffffffffc0200504:	8fcd                	or	a5,a5,a1
ffffffffc0200506:	06a2                	slli	a3,a3,0x8
ffffffffc0200508:	8c51                	or	s0,s0,a2
ffffffffc020050a:	8fd5                	or	a5,a5,a3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020050c:	1402                	slli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020050e:	1782                	slli	a5,a5,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200510:	9001                	srli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200512:	9381                	srli	a5,a5,0x20
ffffffffc0200514:	ec26                	sd	s1,24(sp)
    int in_memory_node = 0;
ffffffffc0200516:	4301                	li	t1,0
        switch (token) {
ffffffffc0200518:	488d                	li	a7,3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020051a:	943a                	add	s0,s0,a4
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020051c:	00e78933          	add	s2,a5,a4
        switch (token) {
ffffffffc0200520:	4e05                	li	t3,1
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200522:	4018                	lw	a4,0(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200524:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200528:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020052c:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200530:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200534:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200538:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020053c:	8ed1                	or	a3,a3,a2
ffffffffc020053e:	0ff77713          	zext.b	a4,a4
ffffffffc0200542:	8fd5                	or	a5,a5,a3
ffffffffc0200544:	0722                	slli	a4,a4,0x8
ffffffffc0200546:	8fd9                	or	a5,a5,a4
        switch (token) {
ffffffffc0200548:	05178763          	beq	a5,a7,ffffffffc0200596 <dtb_init+0x160>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020054c:	0411                	addi	s0,s0,4
        switch (token) {
ffffffffc020054e:	00f8e963          	bltu	a7,a5,ffffffffc0200560 <dtb_init+0x12a>
ffffffffc0200552:	07c78d63          	beq	a5,t3,ffffffffc02005cc <dtb_init+0x196>
ffffffffc0200556:	4709                	li	a4,2
ffffffffc0200558:	00e79763          	bne	a5,a4,ffffffffc0200566 <dtb_init+0x130>
ffffffffc020055c:	4301                	li	t1,0
ffffffffc020055e:	b7d1                	j	ffffffffc0200522 <dtb_init+0xec>
ffffffffc0200560:	4711                	li	a4,4
ffffffffc0200562:	fce780e3          	beq	a5,a4,ffffffffc0200522 <dtb_init+0xec>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200566:	00002517          	auipc	a0,0x2
ffffffffc020056a:	daa50513          	addi	a0,a0,-598 # ffffffffc0202310 <etext+0x3a4>
ffffffffc020056e:	b69ff0ef          	jal	ffffffffc02000d6 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200572:	64e2                	ld	s1,24(sp)
ffffffffc0200574:	6942                	ld	s2,16(sp)
ffffffffc0200576:	00002517          	auipc	a0,0x2
ffffffffc020057a:	dd250513          	addi	a0,a0,-558 # ffffffffc0202348 <etext+0x3dc>
}
ffffffffc020057e:	7402                	ld	s0,32(sp)
ffffffffc0200580:	70a2                	ld	ra,40(sp)
ffffffffc0200582:	6145                	addi	sp,sp,48
    cprintf("DTB init completed\n");
ffffffffc0200584:	be89                	j	ffffffffc02000d6 <cprintf>
}
ffffffffc0200586:	7402                	ld	s0,32(sp)
ffffffffc0200588:	70a2                	ld	ra,40(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc020058a:	00002517          	auipc	a0,0x2
ffffffffc020058e:	cde50513          	addi	a0,a0,-802 # ffffffffc0202268 <etext+0x2fc>
}
ffffffffc0200592:	6145                	addi	sp,sp,48
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200594:	b689                	j	ffffffffc02000d6 <cprintf>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200596:	4058                	lw	a4,4(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200598:	0087579b          	srliw	a5,a4,0x8
ffffffffc020059c:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005a0:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005a4:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005a8:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ac:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005b0:	8ed1                	or	a3,a3,a2
ffffffffc02005b2:	0ff77713          	zext.b	a4,a4
ffffffffc02005b6:	8fd5                	or	a5,a5,a3
ffffffffc02005b8:	0722                	slli	a4,a4,0x8
ffffffffc02005ba:	8fd9                	or	a5,a5,a4
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02005bc:	04031463          	bnez	t1,ffffffffc0200604 <dtb_init+0x1ce>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02005c0:	1782                	slli	a5,a5,0x20
ffffffffc02005c2:	9381                	srli	a5,a5,0x20
ffffffffc02005c4:	043d                	addi	s0,s0,15
ffffffffc02005c6:	943e                	add	s0,s0,a5
ffffffffc02005c8:	9871                	andi	s0,s0,-4
                break;
ffffffffc02005ca:	bfa1                	j	ffffffffc0200522 <dtb_init+0xec>
                int name_len = strlen(name);
ffffffffc02005cc:	8522                	mv	a0,s0
ffffffffc02005ce:	e01a                	sd	t1,0(sp)
ffffffffc02005d0:	0e9010ef          	jal	ffffffffc0201eb8 <strlen>
ffffffffc02005d4:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02005d6:	4619                	li	a2,6
ffffffffc02005d8:	8522                	mv	a0,s0
ffffffffc02005da:	00002597          	auipc	a1,0x2
ffffffffc02005de:	cb658593          	addi	a1,a1,-842 # ffffffffc0202290 <etext+0x324>
ffffffffc02005e2:	13f010ef          	jal	ffffffffc0201f20 <strncmp>
ffffffffc02005e6:	6302                	ld	t1,0(sp)
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02005e8:	0411                	addi	s0,s0,4
ffffffffc02005ea:	0004879b          	sext.w	a5,s1
ffffffffc02005ee:	943e                	add	s0,s0,a5
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02005f0:	00153513          	seqz	a0,a0
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02005f4:	9871                	andi	s0,s0,-4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02005f6:	00a36333          	or	t1,t1,a0
                break;
ffffffffc02005fa:	00ff0837          	lui	a6,0xff0
ffffffffc02005fe:	488d                	li	a7,3
ffffffffc0200600:	4e05                	li	t3,1
ffffffffc0200602:	b705                	j	ffffffffc0200522 <dtb_init+0xec>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200604:	4418                	lw	a4,8(s0)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200606:	00002597          	auipc	a1,0x2
ffffffffc020060a:	c9258593          	addi	a1,a1,-878 # ffffffffc0202298 <etext+0x32c>
ffffffffc020060e:	e43e                	sd	a5,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200610:	0087551b          	srliw	a0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200614:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200618:	0187169b          	slliw	a3,a4,0x18
ffffffffc020061c:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200620:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200624:	01057533          	and	a0,a0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200628:	8ed1                	or	a3,a3,a2
ffffffffc020062a:	0ff77713          	zext.b	a4,a4
ffffffffc020062e:	0722                	slli	a4,a4,0x8
ffffffffc0200630:	8d55                	or	a0,a0,a3
ffffffffc0200632:	8d59                	or	a0,a0,a4
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200634:	1502                	slli	a0,a0,0x20
ffffffffc0200636:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200638:	954a                	add	a0,a0,s2
ffffffffc020063a:	e01a                	sd	t1,0(sp)
ffffffffc020063c:	0b1010ef          	jal	ffffffffc0201eec <strcmp>
ffffffffc0200640:	67a2                	ld	a5,8(sp)
ffffffffc0200642:	473d                	li	a4,15
ffffffffc0200644:	6302                	ld	t1,0(sp)
ffffffffc0200646:	00ff0837          	lui	a6,0xff0
ffffffffc020064a:	488d                	li	a7,3
ffffffffc020064c:	4e05                	li	t3,1
ffffffffc020064e:	f6f779e3          	bgeu	a4,a5,ffffffffc02005c0 <dtb_init+0x18a>
ffffffffc0200652:	f53d                	bnez	a0,ffffffffc02005c0 <dtb_init+0x18a>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200654:	00c43683          	ld	a3,12(s0)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc0200658:	01443703          	ld	a4,20(s0)
        cprintf("Physical Memory from DTB:\n");
ffffffffc020065c:	00002517          	auipc	a0,0x2
ffffffffc0200660:	c4450513          	addi	a0,a0,-956 # ffffffffc02022a0 <etext+0x334>
           fdt32_to_cpu(x >> 32);
ffffffffc0200664:	4206d793          	srai	a5,a3,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200668:	0087d31b          	srliw	t1,a5,0x8
ffffffffc020066c:	00871f93          	slli	t6,a4,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc0200670:	42075893          	srai	a7,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200674:	0187df1b          	srliw	t5,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200678:	0187959b          	slliw	a1,a5,0x18
ffffffffc020067c:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200680:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200684:	420fd613          	srai	a2,t6,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200688:	0188de9b          	srliw	t4,a7,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020068c:	01037333          	and	t1,t1,a6
ffffffffc0200690:	01889e1b          	slliw	t3,a7,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200694:	01e5e5b3          	or	a1,a1,t5
ffffffffc0200698:	0ff7f793          	zext.b	a5,a5
ffffffffc020069c:	01de6e33          	or	t3,t3,t4
ffffffffc02006a0:	0065e5b3          	or	a1,a1,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006a4:	01067633          	and	a2,a2,a6
ffffffffc02006a8:	0086d31b          	srliw	t1,a3,0x8
ffffffffc02006ac:	0087541b          	srliw	s0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b0:	07a2                	slli	a5,a5,0x8
ffffffffc02006b2:	0108d89b          	srliw	a7,a7,0x10
ffffffffc02006b6:	0186df1b          	srliw	t5,a3,0x18
ffffffffc02006ba:	01875e9b          	srliw	t4,a4,0x18
ffffffffc02006be:	8ddd                	or	a1,a1,a5
ffffffffc02006c0:	01c66633          	or	a2,a2,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c4:	0186979b          	slliw	a5,a3,0x18
ffffffffc02006c8:	01871e1b          	slliw	t3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006cc:	0ff8f893          	zext.b	a7,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006d0:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006d4:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006d8:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006dc:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006e0:	01037333          	and	t1,t1,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006e4:	08a2                	slli	a7,a7,0x8
ffffffffc02006e6:	01e7e7b3          	or	a5,a5,t5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ea:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ee:	0ff6f693          	zext.b	a3,a3
ffffffffc02006f2:	01de6833          	or	a6,t3,t4
ffffffffc02006f6:	0ff77713          	zext.b	a4,a4
ffffffffc02006fa:	01166633          	or	a2,a2,a7
ffffffffc02006fe:	0067e7b3          	or	a5,a5,t1
ffffffffc0200702:	06a2                	slli	a3,a3,0x8
ffffffffc0200704:	01046433          	or	s0,s0,a6
ffffffffc0200708:	0722                	slli	a4,a4,0x8
ffffffffc020070a:	8fd5                	or	a5,a5,a3
ffffffffc020070c:	8c59                	or	s0,s0,a4
           fdt32_to_cpu(x >> 32);
ffffffffc020070e:	1582                	slli	a1,a1,0x20
ffffffffc0200710:	1602                	slli	a2,a2,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200712:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200714:	9201                	srli	a2,a2,0x20
ffffffffc0200716:	9181                	srli	a1,a1,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200718:	1402                	slli	s0,s0,0x20
ffffffffc020071a:	00b7e4b3          	or	s1,a5,a1
ffffffffc020071e:	8c51                	or	s0,s0,a2
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200720:	9b7ff0ef          	jal	ffffffffc02000d6 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200724:	85a6                	mv	a1,s1
ffffffffc0200726:	00002517          	auipc	a0,0x2
ffffffffc020072a:	b9a50513          	addi	a0,a0,-1126 # ffffffffc02022c0 <etext+0x354>
ffffffffc020072e:	9a9ff0ef          	jal	ffffffffc02000d6 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200732:	01445613          	srli	a2,s0,0x14
ffffffffc0200736:	85a2                	mv	a1,s0
ffffffffc0200738:	00002517          	auipc	a0,0x2
ffffffffc020073c:	ba050513          	addi	a0,a0,-1120 # ffffffffc02022d8 <etext+0x36c>
ffffffffc0200740:	997ff0ef          	jal	ffffffffc02000d6 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200744:	009405b3          	add	a1,s0,s1
ffffffffc0200748:	15fd                	addi	a1,a1,-1
ffffffffc020074a:	00002517          	auipc	a0,0x2
ffffffffc020074e:	bae50513          	addi	a0,a0,-1106 # ffffffffc02022f8 <etext+0x38c>
ffffffffc0200752:	985ff0ef          	jal	ffffffffc02000d6 <cprintf>
        memory_base = mem_base;
ffffffffc0200756:	00007797          	auipc	a5,0x7
ffffffffc020075a:	d097b123          	sd	s1,-766(a5) # ffffffffc0207458 <memory_base>
        memory_size = mem_size;
ffffffffc020075e:	00007797          	auipc	a5,0x7
ffffffffc0200762:	ce87b923          	sd	s0,-782(a5) # ffffffffc0207450 <memory_size>
ffffffffc0200766:	b531                	j	ffffffffc0200572 <dtb_init+0x13c>

ffffffffc0200768 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200768:	00007517          	auipc	a0,0x7
ffffffffc020076c:	cf053503          	ld	a0,-784(a0) # ffffffffc0207458 <memory_base>
ffffffffc0200770:	8082                	ret

ffffffffc0200772 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc0200772:	00007517          	auipc	a0,0x7
ffffffffc0200776:	cde53503          	ld	a0,-802(a0) # ffffffffc0207450 <memory_size>
ffffffffc020077a:	8082                	ret

ffffffffc020077c <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc020077c:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200780:	8082                	ret

ffffffffc0200782 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200782:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200786:	8082                	ret

ffffffffc0200788 <idt_init>:
     */

    extern void __alltraps(void);
    /* Set sup0 scratch register to 0, indicating to exception vector
       that we are presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc0200788:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc020078c:	00000797          	auipc	a5,0x0
ffffffffc0200790:	3d878793          	addi	a5,a5,984 # ffffffffc0200b64 <__alltraps>
ffffffffc0200794:	10579073          	csrw	stvec,a5
#endif
}

static void trigger_exceptions(void) {
    static int done = 0;
    if (done) return;
ffffffffc0200798:	00007797          	auipc	a5,0x7
ffffffffc020079c:	cd07a783          	lw	a5,-816(a5) # ffffffffc0207468 <done.2>
ffffffffc02007a0:	eb81                	bnez	a5,ffffffffc02007b0 <idt_init+0x28>
    done = 1;
ffffffffc02007a2:	4785                	li	a5,1
ffffffffc02007a4:	00007717          	auipc	a4,0x7
ffffffffc02007a8:	ccf72223          	sw	a5,-828(a4) # ffffffffc0207468 <done.2>
    asm volatile("ebreak");          // 触发 breakpoint 异常
ffffffffc02007ac:	9002                	ebreak
    asm volatile(".2byte 0x0000");   // 非法压缩指令编码，触发 Illegal instruction
ffffffffc02007ae:	0000                	.short	0x0000
}
ffffffffc02007b0:	8082                	ret

ffffffffc02007b2 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02007b2:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc02007b4:	1141                	addi	sp,sp,-16
ffffffffc02007b6:	e022                	sd	s0,0(sp)
ffffffffc02007b8:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02007ba:	00002517          	auipc	a0,0x2
ffffffffc02007be:	ba650513          	addi	a0,a0,-1114 # ffffffffc0202360 <etext+0x3f4>
void print_regs(struct pushregs *gpr) {
ffffffffc02007c2:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02007c4:	913ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02007c8:	640c                	ld	a1,8(s0)
ffffffffc02007ca:	00002517          	auipc	a0,0x2
ffffffffc02007ce:	bae50513          	addi	a0,a0,-1106 # ffffffffc0202378 <etext+0x40c>
ffffffffc02007d2:	905ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02007d6:	680c                	ld	a1,16(s0)
ffffffffc02007d8:	00002517          	auipc	a0,0x2
ffffffffc02007dc:	bb850513          	addi	a0,a0,-1096 # ffffffffc0202390 <etext+0x424>
ffffffffc02007e0:	8f7ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02007e4:	6c0c                	ld	a1,24(s0)
ffffffffc02007e6:	00002517          	auipc	a0,0x2
ffffffffc02007ea:	bc250513          	addi	a0,a0,-1086 # ffffffffc02023a8 <etext+0x43c>
ffffffffc02007ee:	8e9ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02007f2:	700c                	ld	a1,32(s0)
ffffffffc02007f4:	00002517          	auipc	a0,0x2
ffffffffc02007f8:	bcc50513          	addi	a0,a0,-1076 # ffffffffc02023c0 <etext+0x454>
ffffffffc02007fc:	8dbff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200800:	740c                	ld	a1,40(s0)
ffffffffc0200802:	00002517          	auipc	a0,0x2
ffffffffc0200806:	bd650513          	addi	a0,a0,-1066 # ffffffffc02023d8 <etext+0x46c>
ffffffffc020080a:	8cdff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc020080e:	780c                	ld	a1,48(s0)
ffffffffc0200810:	00002517          	auipc	a0,0x2
ffffffffc0200814:	be050513          	addi	a0,a0,-1056 # ffffffffc02023f0 <etext+0x484>
ffffffffc0200818:	8bfff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc020081c:	7c0c                	ld	a1,56(s0)
ffffffffc020081e:	00002517          	auipc	a0,0x2
ffffffffc0200822:	bea50513          	addi	a0,a0,-1046 # ffffffffc0202408 <etext+0x49c>
ffffffffc0200826:	8b1ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc020082a:	602c                	ld	a1,64(s0)
ffffffffc020082c:	00002517          	auipc	a0,0x2
ffffffffc0200830:	bf450513          	addi	a0,a0,-1036 # ffffffffc0202420 <etext+0x4b4>
ffffffffc0200834:	8a3ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200838:	642c                	ld	a1,72(s0)
ffffffffc020083a:	00002517          	auipc	a0,0x2
ffffffffc020083e:	bfe50513          	addi	a0,a0,-1026 # ffffffffc0202438 <etext+0x4cc>
ffffffffc0200842:	895ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200846:	682c                	ld	a1,80(s0)
ffffffffc0200848:	00002517          	auipc	a0,0x2
ffffffffc020084c:	c0850513          	addi	a0,a0,-1016 # ffffffffc0202450 <etext+0x4e4>
ffffffffc0200850:	887ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200854:	6c2c                	ld	a1,88(s0)
ffffffffc0200856:	00002517          	auipc	a0,0x2
ffffffffc020085a:	c1250513          	addi	a0,a0,-1006 # ffffffffc0202468 <etext+0x4fc>
ffffffffc020085e:	879ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200862:	702c                	ld	a1,96(s0)
ffffffffc0200864:	00002517          	auipc	a0,0x2
ffffffffc0200868:	c1c50513          	addi	a0,a0,-996 # ffffffffc0202480 <etext+0x514>
ffffffffc020086c:	86bff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200870:	742c                	ld	a1,104(s0)
ffffffffc0200872:	00002517          	auipc	a0,0x2
ffffffffc0200876:	c2650513          	addi	a0,a0,-986 # ffffffffc0202498 <etext+0x52c>
ffffffffc020087a:	85dff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc020087e:	782c                	ld	a1,112(s0)
ffffffffc0200880:	00002517          	auipc	a0,0x2
ffffffffc0200884:	c3050513          	addi	a0,a0,-976 # ffffffffc02024b0 <etext+0x544>
ffffffffc0200888:	84fff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc020088c:	7c2c                	ld	a1,120(s0)
ffffffffc020088e:	00002517          	auipc	a0,0x2
ffffffffc0200892:	c3a50513          	addi	a0,a0,-966 # ffffffffc02024c8 <etext+0x55c>
ffffffffc0200896:	841ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc020089a:	604c                	ld	a1,128(s0)
ffffffffc020089c:	00002517          	auipc	a0,0x2
ffffffffc02008a0:	c4450513          	addi	a0,a0,-956 # ffffffffc02024e0 <etext+0x574>
ffffffffc02008a4:	833ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc02008a8:	644c                	ld	a1,136(s0)
ffffffffc02008aa:	00002517          	auipc	a0,0x2
ffffffffc02008ae:	c4e50513          	addi	a0,a0,-946 # ffffffffc02024f8 <etext+0x58c>
ffffffffc02008b2:	825ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc02008b6:	684c                	ld	a1,144(s0)
ffffffffc02008b8:	00002517          	auipc	a0,0x2
ffffffffc02008bc:	c5850513          	addi	a0,a0,-936 # ffffffffc0202510 <etext+0x5a4>
ffffffffc02008c0:	817ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc02008c4:	6c4c                	ld	a1,152(s0)
ffffffffc02008c6:	00002517          	auipc	a0,0x2
ffffffffc02008ca:	c6250513          	addi	a0,a0,-926 # ffffffffc0202528 <etext+0x5bc>
ffffffffc02008ce:	809ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc02008d2:	704c                	ld	a1,160(s0)
ffffffffc02008d4:	00002517          	auipc	a0,0x2
ffffffffc02008d8:	c6c50513          	addi	a0,a0,-916 # ffffffffc0202540 <etext+0x5d4>
ffffffffc02008dc:	ffaff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02008e0:	744c                	ld	a1,168(s0)
ffffffffc02008e2:	00002517          	auipc	a0,0x2
ffffffffc02008e6:	c7650513          	addi	a0,a0,-906 # ffffffffc0202558 <etext+0x5ec>
ffffffffc02008ea:	fecff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02008ee:	784c                	ld	a1,176(s0)
ffffffffc02008f0:	00002517          	auipc	a0,0x2
ffffffffc02008f4:	c8050513          	addi	a0,a0,-896 # ffffffffc0202570 <etext+0x604>
ffffffffc02008f8:	fdeff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02008fc:	7c4c                	ld	a1,184(s0)
ffffffffc02008fe:	00002517          	auipc	a0,0x2
ffffffffc0200902:	c8a50513          	addi	a0,a0,-886 # ffffffffc0202588 <etext+0x61c>
ffffffffc0200906:	fd0ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc020090a:	606c                	ld	a1,192(s0)
ffffffffc020090c:	00002517          	auipc	a0,0x2
ffffffffc0200910:	c9450513          	addi	a0,a0,-876 # ffffffffc02025a0 <etext+0x634>
ffffffffc0200914:	fc2ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200918:	646c                	ld	a1,200(s0)
ffffffffc020091a:	00002517          	auipc	a0,0x2
ffffffffc020091e:	c9e50513          	addi	a0,a0,-866 # ffffffffc02025b8 <etext+0x64c>
ffffffffc0200922:	fb4ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200926:	686c                	ld	a1,208(s0)
ffffffffc0200928:	00002517          	auipc	a0,0x2
ffffffffc020092c:	ca850513          	addi	a0,a0,-856 # ffffffffc02025d0 <etext+0x664>
ffffffffc0200930:	fa6ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200934:	6c6c                	ld	a1,216(s0)
ffffffffc0200936:	00002517          	auipc	a0,0x2
ffffffffc020093a:	cb250513          	addi	a0,a0,-846 # ffffffffc02025e8 <etext+0x67c>
ffffffffc020093e:	f98ff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200942:	706c                	ld	a1,224(s0)
ffffffffc0200944:	00002517          	auipc	a0,0x2
ffffffffc0200948:	cbc50513          	addi	a0,a0,-836 # ffffffffc0202600 <etext+0x694>
ffffffffc020094c:	f8aff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200950:	746c                	ld	a1,232(s0)
ffffffffc0200952:	00002517          	auipc	a0,0x2
ffffffffc0200956:	cc650513          	addi	a0,a0,-826 # ffffffffc0202618 <etext+0x6ac>
ffffffffc020095a:	f7cff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc020095e:	786c                	ld	a1,240(s0)
ffffffffc0200960:	00002517          	auipc	a0,0x2
ffffffffc0200964:	cd050513          	addi	a0,a0,-816 # ffffffffc0202630 <etext+0x6c4>
ffffffffc0200968:	f6eff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc020096c:	7c6c                	ld	a1,248(s0)
}
ffffffffc020096e:	6402                	ld	s0,0(sp)
ffffffffc0200970:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200972:	00002517          	auipc	a0,0x2
ffffffffc0200976:	cd650513          	addi	a0,a0,-810 # ffffffffc0202648 <etext+0x6dc>
}
ffffffffc020097a:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc020097c:	f5aff06f          	j	ffffffffc02000d6 <cprintf>

ffffffffc0200980 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc0200980:	1141                	addi	sp,sp,-16
ffffffffc0200982:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200984:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc0200986:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200988:	00002517          	auipc	a0,0x2
ffffffffc020098c:	cd850513          	addi	a0,a0,-808 # ffffffffc0202660 <etext+0x6f4>
void print_trapframe(struct trapframe *tf) {
ffffffffc0200990:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200992:	f44ff0ef          	jal	ffffffffc02000d6 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200996:	8522                	mv	a0,s0
ffffffffc0200998:	e1bff0ef          	jal	ffffffffc02007b2 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc020099c:	10043583          	ld	a1,256(s0)
ffffffffc02009a0:	00002517          	auipc	a0,0x2
ffffffffc02009a4:	cd850513          	addi	a0,a0,-808 # ffffffffc0202678 <etext+0x70c>
ffffffffc02009a8:	f2eff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc02009ac:	10843583          	ld	a1,264(s0)
ffffffffc02009b0:	00002517          	auipc	a0,0x2
ffffffffc02009b4:	ce050513          	addi	a0,a0,-800 # ffffffffc0202690 <etext+0x724>
ffffffffc02009b8:	f1eff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc02009bc:	11043583          	ld	a1,272(s0)
ffffffffc02009c0:	00002517          	auipc	a0,0x2
ffffffffc02009c4:	ce850513          	addi	a0,a0,-792 # ffffffffc02026a8 <etext+0x73c>
ffffffffc02009c8:	f0eff0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02009cc:	11843583          	ld	a1,280(s0)
}
ffffffffc02009d0:	6402                	ld	s0,0(sp)
ffffffffc02009d2:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02009d4:	00002517          	auipc	a0,0x2
ffffffffc02009d8:	cec50513          	addi	a0,a0,-788 # ffffffffc02026c0 <etext+0x754>
}
ffffffffc02009dc:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02009de:	ef8ff06f          	j	ffffffffc02000d6 <cprintf>

ffffffffc02009e2 <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause) {
ffffffffc02009e2:	11853783          	ld	a5,280(a0)
ffffffffc02009e6:	472d                	li	a4,11
ffffffffc02009e8:	0786                	slli	a5,a5,0x1
ffffffffc02009ea:	8385                	srli	a5,a5,0x1
ffffffffc02009ec:	08f76363          	bltu	a4,a5,ffffffffc0200a72 <interrupt_handler+0x90>
ffffffffc02009f0:	00002717          	auipc	a4,0x2
ffffffffc02009f4:	44870713          	addi	a4,a4,1096 # ffffffffc0202e38 <commands+0x48>
ffffffffc02009f8:	078a                	slli	a5,a5,0x2
ffffffffc02009fa:	97ba                	add	a5,a5,a4
ffffffffc02009fc:	439c                	lw	a5,0(a5)
ffffffffc02009fe:	97ba                	add	a5,a5,a4
ffffffffc0200a00:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc0200a02:	00002517          	auipc	a0,0x2
ffffffffc0200a06:	d3650513          	addi	a0,a0,-714 # ffffffffc0202738 <etext+0x7cc>
ffffffffc0200a0a:	eccff06f          	j	ffffffffc02000d6 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc0200a0e:	00002517          	auipc	a0,0x2
ffffffffc0200a12:	d0a50513          	addi	a0,a0,-758 # ffffffffc0202718 <etext+0x7ac>
ffffffffc0200a16:	ec0ff06f          	j	ffffffffc02000d6 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc0200a1a:	00002517          	auipc	a0,0x2
ffffffffc0200a1e:	cbe50513          	addi	a0,a0,-834 # ffffffffc02026d8 <etext+0x76c>
ffffffffc0200a22:	eb4ff06f          	j	ffffffffc02000d6 <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc0200a26:	00002517          	auipc	a0,0x2
ffffffffc0200a2a:	d3250513          	addi	a0,a0,-718 # ffffffffc0202758 <etext+0x7ec>
ffffffffc0200a2e:	ea8ff06f          	j	ffffffffc02000d6 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc0200a32:	1141                	addi	sp,sp,-16
ffffffffc0200a34:	e406                	sd	ra,8(sp)
            * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
            */
            {
                static int ticks = 0;
                static int num = 0;
                clock_set_next_event();
ffffffffc0200a36:	9e3ff0ef          	jal	ffffffffc0200418 <clock_set_next_event>
                ticks++;
ffffffffc0200a3a:	00007597          	auipc	a1,0x7
ffffffffc0200a3e:	a2a5a583          	lw	a1,-1494(a1) # ffffffffc0207464 <ticks.1>
                if (ticks == 100) {
ffffffffc0200a42:	06400793          	li	a5,100
                ticks++;
ffffffffc0200a46:	2585                	addiw	a1,a1,1
ffffffffc0200a48:	00007717          	auipc	a4,0x7
ffffffffc0200a4c:	a0b72e23          	sw	a1,-1508(a4) # ffffffffc0207464 <ticks.1>
                if (ticks == 100) {
ffffffffc0200a50:	02f58263          	beq	a1,a5,ffffffffc0200a74 <interrupt_handler+0x92>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200a54:	60a2                	ld	ra,8(sp)
ffffffffc0200a56:	0141                	addi	sp,sp,16
ffffffffc0200a58:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc0200a5a:	00002517          	auipc	a0,0x2
ffffffffc0200a5e:	d2650513          	addi	a0,a0,-730 # ffffffffc0202780 <etext+0x814>
ffffffffc0200a62:	e74ff06f          	j	ffffffffc02000d6 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200a66:	00002517          	auipc	a0,0x2
ffffffffc0200a6a:	c9250513          	addi	a0,a0,-878 # ffffffffc02026f8 <etext+0x78c>
ffffffffc0200a6e:	e68ff06f          	j	ffffffffc02000d6 <cprintf>
            print_trapframe(tf);
ffffffffc0200a72:	b739                	j	ffffffffc0200980 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200a74:	00002517          	auipc	a0,0x2
ffffffffc0200a78:	cfc50513          	addi	a0,a0,-772 # ffffffffc0202770 <etext+0x804>
ffffffffc0200a7c:	e5aff0ef          	jal	ffffffffc02000d6 <cprintf>
                    num++;
ffffffffc0200a80:	00007797          	auipc	a5,0x7
ffffffffc0200a84:	9e07a783          	lw	a5,-1568(a5) # ffffffffc0207460 <num.0>
                    ticks = 0;
ffffffffc0200a88:	00007717          	auipc	a4,0x7
ffffffffc0200a8c:	9c072e23          	sw	zero,-1572(a4) # ffffffffc0207464 <ticks.1>
                    if (num == 10) {
ffffffffc0200a90:	4729                	li	a4,10
                    num++;
ffffffffc0200a92:	2785                	addiw	a5,a5,1
ffffffffc0200a94:	00007697          	auipc	a3,0x7
ffffffffc0200a98:	9cf6a623          	sw	a5,-1588(a3) # ffffffffc0207460 <num.0>
                    if (num == 10) {
ffffffffc0200a9c:	fae79ce3          	bne	a5,a4,ffffffffc0200a54 <interrupt_handler+0x72>
}
ffffffffc0200aa0:	60a2                	ld	ra,8(sp)
ffffffffc0200aa2:	0141                	addi	sp,sp,16
                        sbi_shutdown();
ffffffffc0200aa4:	3fa0106f          	j	ffffffffc0201e9e <sbi_shutdown>

ffffffffc0200aa8 <exception_handler>:

void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
ffffffffc0200aa8:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc0200aac:	1101                	addi	sp,sp,-32
ffffffffc0200aae:	e822                	sd	s0,16(sp)
ffffffffc0200ab0:	ec06                	sd	ra,24(sp)
    switch (tf->cause) {
ffffffffc0200ab2:	470d                	li	a4,3
void exception_handler(struct trapframe *tf) {
ffffffffc0200ab4:	842a                	mv	s0,a0
    switch (tf->cause) {
ffffffffc0200ab6:	04e78e63          	beq	a5,a4,ffffffffc0200b12 <exception_handler+0x6a>
ffffffffc0200aba:	04f76463          	bltu	a4,a5,ffffffffc0200b02 <exception_handler+0x5a>
ffffffffc0200abe:	4689                	li	a3,2
ffffffffc0200ac0:	02d79d63          	bne	a5,a3,ffffffffc0200afa <exception_handler+0x52>
            /*(1)输出指令异常类型（ Illegal instruction）
             *(2)输出异常指令地址
             *(3)更新 tf->epc寄存器
            */
            {
                cprintf("Exception type:Illegal instruction\n");
ffffffffc0200ac4:	00002517          	auipc	a0,0x2
ffffffffc0200ac8:	cdc50513          	addi	a0,a0,-804 # ffffffffc02027a0 <etext+0x834>
ffffffffc0200acc:	e43e                	sd	a5,8(sp)
ffffffffc0200ace:	e08ff0ef          	jal	ffffffffc02000d6 <cprintf>
                cprintf("Illegal instruction caught at 0x%08lx\n", (unsigned long)tf->epc);
ffffffffc0200ad2:	10843583          	ld	a1,264(s0)
ffffffffc0200ad6:	00002517          	auipc	a0,0x2
ffffffffc0200ada:	cf250513          	addi	a0,a0,-782 # ffffffffc02027c8 <etext+0x85c>
ffffffffc0200ade:	df8ff0ef          	jal	ffffffffc02000d6 <cprintf>
                tf->epc += instr_len(tf->epc);
ffffffffc0200ae2:	10843683          	ld	a3,264(s0)
    return ((inst16 & 0x3) == 0x3) ? 4 : 2;
ffffffffc0200ae6:	470d                	li	a4,3
ffffffffc0200ae8:	67a2                	ld	a5,8(sp)
ffffffffc0200aea:	0006d603          	lhu	a2,0(a3)
ffffffffc0200aee:	8a0d                	andi	a2,a2,3
ffffffffc0200af0:	06e60263          	beq	a2,a4,ffffffffc0200b54 <exception_handler+0xac>
                tf->epc += instr_len(tf->epc);
ffffffffc0200af4:	96be                	add	a3,a3,a5
ffffffffc0200af6:	10d43423          	sd	a3,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200afa:	60e2                	ld	ra,24(sp)
ffffffffc0200afc:	6442                	ld	s0,16(sp)
ffffffffc0200afe:	6105                	addi	sp,sp,32
ffffffffc0200b00:	8082                	ret
    switch (tf->cause) {
ffffffffc0200b02:	17f1                	addi	a5,a5,-4
ffffffffc0200b04:	471d                	li	a4,7
ffffffffc0200b06:	fef77ae3          	bgeu	a4,a5,ffffffffc0200afa <exception_handler+0x52>
}
ffffffffc0200b0a:	6442                	ld	s0,16(sp)
ffffffffc0200b0c:	60e2                	ld	ra,24(sp)
ffffffffc0200b0e:	6105                	addi	sp,sp,32
            print_trapframe(tf);
ffffffffc0200b10:	bd85                	j	ffffffffc0200980 <print_trapframe>
                cprintf("Exception type: breakpoint\n");
ffffffffc0200b12:	00002517          	auipc	a0,0x2
ffffffffc0200b16:	cde50513          	addi	a0,a0,-802 # ffffffffc02027f0 <etext+0x884>
ffffffffc0200b1a:	e43e                	sd	a5,8(sp)
ffffffffc0200b1c:	dbaff0ef          	jal	ffffffffc02000d6 <cprintf>
                cprintf("ebreak caught at 0x%08lx\n", (unsigned long)tf->epc);
ffffffffc0200b20:	10843583          	ld	a1,264(s0)
ffffffffc0200b24:	00002517          	auipc	a0,0x2
ffffffffc0200b28:	cec50513          	addi	a0,a0,-788 # ffffffffc0202810 <etext+0x8a4>
ffffffffc0200b2c:	daaff0ef          	jal	ffffffffc02000d6 <cprintf>
                tf->epc += instr_len(tf->epc);
ffffffffc0200b30:	10843703          	ld	a4,264(s0)
    return ((inst16 & 0x3) == 0x3) ? 4 : 2;
ffffffffc0200b34:	67a2                	ld	a5,8(sp)
ffffffffc0200b36:	4609                	li	a2,2
ffffffffc0200b38:	00075683          	lhu	a3,0(a4)
ffffffffc0200b3c:	8a8d                	andi	a3,a3,3
ffffffffc0200b3e:	00f68963          	beq	a3,a5,ffffffffc0200b50 <exception_handler+0xa8>
                tf->epc += instr_len(tf->epc);
ffffffffc0200b42:	9732                	add	a4,a4,a2
}
ffffffffc0200b44:	60e2                	ld	ra,24(sp)
                tf->epc += instr_len(tf->epc);
ffffffffc0200b46:	10e43423          	sd	a4,264(s0)
}
ffffffffc0200b4a:	6442                	ld	s0,16(sp)
ffffffffc0200b4c:	6105                	addi	sp,sp,32
ffffffffc0200b4e:	8082                	ret
    return ((inst16 & 0x3) == 0x3) ? 4 : 2;
ffffffffc0200b50:	4611                	li	a2,4
ffffffffc0200b52:	bfc5                	j	ffffffffc0200b42 <exception_handler+0x9a>
ffffffffc0200b54:	4791                	li	a5,4
ffffffffc0200b56:	bf79                	j	ffffffffc0200af4 <exception_handler+0x4c>

ffffffffc0200b58 <trap>:

static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200b58:	11853783          	ld	a5,280(a0)
ffffffffc0200b5c:	0007c363          	bltz	a5,ffffffffc0200b62 <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc0200b60:	b7a1                	j	ffffffffc0200aa8 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200b62:	b541                	j	ffffffffc02009e2 <interrupt_handler>

ffffffffc0200b64 <__alltraps>:
    .endm

    .globl __alltraps
    .align(2)
__alltraps:
    SAVE_ALL
ffffffffc0200b64:	14011073          	csrw	sscratch,sp
ffffffffc0200b68:	712d                	addi	sp,sp,-288
ffffffffc0200b6a:	e002                	sd	zero,0(sp)
ffffffffc0200b6c:	e406                	sd	ra,8(sp)
ffffffffc0200b6e:	ec0e                	sd	gp,24(sp)
ffffffffc0200b70:	f012                	sd	tp,32(sp)
ffffffffc0200b72:	f416                	sd	t0,40(sp)
ffffffffc0200b74:	f81a                	sd	t1,48(sp)
ffffffffc0200b76:	fc1e                	sd	t2,56(sp)
ffffffffc0200b78:	e0a2                	sd	s0,64(sp)
ffffffffc0200b7a:	e4a6                	sd	s1,72(sp)
ffffffffc0200b7c:	e8aa                	sd	a0,80(sp)
ffffffffc0200b7e:	ecae                	sd	a1,88(sp)
ffffffffc0200b80:	f0b2                	sd	a2,96(sp)
ffffffffc0200b82:	f4b6                	sd	a3,104(sp)
ffffffffc0200b84:	f8ba                	sd	a4,112(sp)
ffffffffc0200b86:	fcbe                	sd	a5,120(sp)
ffffffffc0200b88:	e142                	sd	a6,128(sp)
ffffffffc0200b8a:	e546                	sd	a7,136(sp)
ffffffffc0200b8c:	e94a                	sd	s2,144(sp)
ffffffffc0200b8e:	ed4e                	sd	s3,152(sp)
ffffffffc0200b90:	f152                	sd	s4,160(sp)
ffffffffc0200b92:	f556                	sd	s5,168(sp)
ffffffffc0200b94:	f95a                	sd	s6,176(sp)
ffffffffc0200b96:	fd5e                	sd	s7,184(sp)
ffffffffc0200b98:	e1e2                	sd	s8,192(sp)
ffffffffc0200b9a:	e5e6                	sd	s9,200(sp)
ffffffffc0200b9c:	e9ea                	sd	s10,208(sp)
ffffffffc0200b9e:	edee                	sd	s11,216(sp)
ffffffffc0200ba0:	f1f2                	sd	t3,224(sp)
ffffffffc0200ba2:	f5f6                	sd	t4,232(sp)
ffffffffc0200ba4:	f9fa                	sd	t5,240(sp)
ffffffffc0200ba6:	fdfe                	sd	t6,248(sp)
ffffffffc0200ba8:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200bac:	100024f3          	csrr	s1,sstatus
ffffffffc0200bb0:	14102973          	csrr	s2,sepc
ffffffffc0200bb4:	143029f3          	csrr	s3,stval
ffffffffc0200bb8:	14202a73          	csrr	s4,scause
ffffffffc0200bbc:	e822                	sd	s0,16(sp)
ffffffffc0200bbe:	e226                	sd	s1,256(sp)
ffffffffc0200bc0:	e64a                	sd	s2,264(sp)
ffffffffc0200bc2:	ea4e                	sd	s3,272(sp)
ffffffffc0200bc4:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200bc6:	850a                	mv	a0,sp
    jal trap
ffffffffc0200bc8:	f91ff0ef          	jal	ffffffffc0200b58 <trap>

ffffffffc0200bcc <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200bcc:	6492                	ld	s1,256(sp)
ffffffffc0200bce:	6932                	ld	s2,264(sp)
ffffffffc0200bd0:	10049073          	csrw	sstatus,s1
ffffffffc0200bd4:	14191073          	csrw	sepc,s2
ffffffffc0200bd8:	60a2                	ld	ra,8(sp)
ffffffffc0200bda:	61e2                	ld	gp,24(sp)
ffffffffc0200bdc:	7202                	ld	tp,32(sp)
ffffffffc0200bde:	72a2                	ld	t0,40(sp)
ffffffffc0200be0:	7342                	ld	t1,48(sp)
ffffffffc0200be2:	73e2                	ld	t2,56(sp)
ffffffffc0200be4:	6406                	ld	s0,64(sp)
ffffffffc0200be6:	64a6                	ld	s1,72(sp)
ffffffffc0200be8:	6546                	ld	a0,80(sp)
ffffffffc0200bea:	65e6                	ld	a1,88(sp)
ffffffffc0200bec:	7606                	ld	a2,96(sp)
ffffffffc0200bee:	76a6                	ld	a3,104(sp)
ffffffffc0200bf0:	7746                	ld	a4,112(sp)
ffffffffc0200bf2:	77e6                	ld	a5,120(sp)
ffffffffc0200bf4:	680a                	ld	a6,128(sp)
ffffffffc0200bf6:	68aa                	ld	a7,136(sp)
ffffffffc0200bf8:	694a                	ld	s2,144(sp)
ffffffffc0200bfa:	69ea                	ld	s3,152(sp)
ffffffffc0200bfc:	7a0a                	ld	s4,160(sp)
ffffffffc0200bfe:	7aaa                	ld	s5,168(sp)
ffffffffc0200c00:	7b4a                	ld	s6,176(sp)
ffffffffc0200c02:	7bea                	ld	s7,184(sp)
ffffffffc0200c04:	6c0e                	ld	s8,192(sp)
ffffffffc0200c06:	6cae                	ld	s9,200(sp)
ffffffffc0200c08:	6d4e                	ld	s10,208(sp)
ffffffffc0200c0a:	6dee                	ld	s11,216(sp)
ffffffffc0200c0c:	7e0e                	ld	t3,224(sp)
ffffffffc0200c0e:	7eae                	ld	t4,232(sp)
ffffffffc0200c10:	7f4e                	ld	t5,240(sp)
ffffffffc0200c12:	7fee                	ld	t6,248(sp)
ffffffffc0200c14:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200c16:	10200073          	sret

ffffffffc0200c1a <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200c1a:	00006797          	auipc	a5,0x6
ffffffffc0200c1e:	40e78793          	addi	a5,a5,1038 # ffffffffc0207028 <free_area>
ffffffffc0200c22:	e79c                	sd	a5,8(a5)
ffffffffc0200c24:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200c26:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200c2a:	8082                	ret

ffffffffc0200c2c <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200c2c:	00006517          	auipc	a0,0x6
ffffffffc0200c30:	40c56503          	lwu	a0,1036(a0) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200c34:	8082                	ret

ffffffffc0200c36 <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200c36:	711d                	addi	sp,sp,-96
ffffffffc0200c38:	e0ca                	sd	s2,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200c3a:	00006917          	auipc	s2,0x6
ffffffffc0200c3e:	3ee90913          	addi	s2,s2,1006 # ffffffffc0207028 <free_area>
ffffffffc0200c42:	00893783          	ld	a5,8(s2)
ffffffffc0200c46:	ec86                	sd	ra,88(sp)
ffffffffc0200c48:	e8a2                	sd	s0,80(sp)
ffffffffc0200c4a:	e4a6                	sd	s1,72(sp)
ffffffffc0200c4c:	fc4e                	sd	s3,56(sp)
ffffffffc0200c4e:	f852                	sd	s4,48(sp)
ffffffffc0200c50:	f456                	sd	s5,40(sp)
ffffffffc0200c52:	f05a                	sd	s6,32(sp)
ffffffffc0200c54:	ec5e                	sd	s7,24(sp)
ffffffffc0200c56:	e862                	sd	s8,16(sp)
ffffffffc0200c58:	e466                	sd	s9,8(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200c5a:	31278b63          	beq	a5,s2,ffffffffc0200f70 <default_check+0x33a>
    int count = 0, total = 0;
ffffffffc0200c5e:	4401                	li	s0,0
ffffffffc0200c60:	4481                	li	s1,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200c62:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200c66:	8b09                	andi	a4,a4,2
ffffffffc0200c68:	30070863          	beqz	a4,ffffffffc0200f78 <default_check+0x342>
        count ++, total += p->property;
ffffffffc0200c6c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200c70:	679c                	ld	a5,8(a5)
ffffffffc0200c72:	2485                	addiw	s1,s1,1
ffffffffc0200c74:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200c76:	ff2796e3          	bne	a5,s2,ffffffffc0200c62 <default_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc0200c7a:	89a2                	mv	s3,s0
ffffffffc0200c7c:	33f000ef          	jal	ffffffffc02017ba <nr_free_pages>
ffffffffc0200c80:	75351c63          	bne	a0,s3,ffffffffc02013d8 <default_check+0x7a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200c84:	4505                	li	a0,1
ffffffffc0200c86:	2c3000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200c8a:	8aaa                	mv	s5,a0
ffffffffc0200c8c:	48050663          	beqz	a0,ffffffffc0201118 <default_check+0x4e2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200c90:	4505                	li	a0,1
ffffffffc0200c92:	2b7000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200c96:	89aa                	mv	s3,a0
ffffffffc0200c98:	76050063          	beqz	a0,ffffffffc02013f8 <default_check+0x7c2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200c9c:	4505                	li	a0,1
ffffffffc0200c9e:	2ab000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200ca2:	8a2a                	mv	s4,a0
ffffffffc0200ca4:	4e050a63          	beqz	a0,ffffffffc0201198 <default_check+0x562>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200ca8:	40aa87b3          	sub	a5,s5,a0
ffffffffc0200cac:	40a98733          	sub	a4,s3,a0
ffffffffc0200cb0:	0017b793          	seqz	a5,a5
ffffffffc0200cb4:	00173713          	seqz	a4,a4
ffffffffc0200cb8:	8fd9                	or	a5,a5,a4
ffffffffc0200cba:	32079f63          	bnez	a5,ffffffffc0200ff8 <default_check+0x3c2>
ffffffffc0200cbe:	333a8d63          	beq	s5,s3,ffffffffc0200ff8 <default_check+0x3c2>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200cc2:	000aa783          	lw	a5,0(s5)
ffffffffc0200cc6:	2c079963          	bnez	a5,ffffffffc0200f98 <default_check+0x362>
ffffffffc0200cca:	0009a783          	lw	a5,0(s3)
ffffffffc0200cce:	2c079563          	bnez	a5,ffffffffc0200f98 <default_check+0x362>
ffffffffc0200cd2:	411c                	lw	a5,0(a0)
ffffffffc0200cd4:	2c079263          	bnez	a5,ffffffffc0200f98 <default_check+0x362>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200cd8:	00006797          	auipc	a5,0x6
ffffffffc0200cdc:	7c07b783          	ld	a5,1984(a5) # ffffffffc0207498 <pages>
ffffffffc0200ce0:	ccccd737          	lui	a4,0xccccd
ffffffffc0200ce4:	ccd70713          	addi	a4,a4,-819 # ffffffffcccccccd <end+0xcac5825>
ffffffffc0200ce8:	02071693          	slli	a3,a4,0x20
ffffffffc0200cec:	96ba                	add	a3,a3,a4
ffffffffc0200cee:	40fa8733          	sub	a4,s5,a5
ffffffffc0200cf2:	870d                	srai	a4,a4,0x3
ffffffffc0200cf4:	02d70733          	mul	a4,a4,a3
ffffffffc0200cf8:	00002517          	auipc	a0,0x2
ffffffffc0200cfc:	33853503          	ld	a0,824(a0) # ffffffffc0203030 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200d00:	00006697          	auipc	a3,0x6
ffffffffc0200d04:	7906b683          	ld	a3,1936(a3) # ffffffffc0207490 <npage>
ffffffffc0200d08:	06b2                	slli	a3,a3,0xc
ffffffffc0200d0a:	972a                	add	a4,a4,a0

static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200d0c:	0732                	slli	a4,a4,0xc
ffffffffc0200d0e:	2cd77563          	bgeu	a4,a3,ffffffffc0200fd8 <default_check+0x3a2>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d12:	ccccd5b7          	lui	a1,0xccccd
ffffffffc0200d16:	ccd58593          	addi	a1,a1,-819 # ffffffffcccccccd <end+0xcac5825>
ffffffffc0200d1a:	02059613          	slli	a2,a1,0x20
ffffffffc0200d1e:	40f98733          	sub	a4,s3,a5
ffffffffc0200d22:	962e                	add	a2,a2,a1
ffffffffc0200d24:	870d                	srai	a4,a4,0x3
ffffffffc0200d26:	02c70733          	mul	a4,a4,a2
ffffffffc0200d2a:	972a                	add	a4,a4,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200d2c:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200d2e:	4ed77563          	bgeu	a4,a3,ffffffffc0201218 <default_check+0x5e2>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d32:	40fa07b3          	sub	a5,s4,a5
ffffffffc0200d36:	878d                	srai	a5,a5,0x3
ffffffffc0200d38:	02c787b3          	mul	a5,a5,a2
ffffffffc0200d3c:	97aa                	add	a5,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200d3e:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200d40:	32d7fc63          	bgeu	a5,a3,ffffffffc0201078 <default_check+0x442>
    assert(alloc_page() == NULL);
ffffffffc0200d44:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200d46:	00093c03          	ld	s8,0(s2)
ffffffffc0200d4a:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc0200d4e:	00006b17          	auipc	s6,0x6
ffffffffc0200d52:	2eab2b03          	lw	s6,746(s6) # ffffffffc0207038 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc0200d56:	01293023          	sd	s2,0(s2)
ffffffffc0200d5a:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc0200d5e:	00006797          	auipc	a5,0x6
ffffffffc0200d62:	2c07ad23          	sw	zero,730(a5) # ffffffffc0207038 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200d66:	1e3000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200d6a:	2e051763          	bnez	a0,ffffffffc0201058 <default_check+0x422>
    free_page(p0);
ffffffffc0200d6e:	8556                	mv	a0,s5
ffffffffc0200d70:	4585                	li	a1,1
ffffffffc0200d72:	211000ef          	jal	ffffffffc0201782 <free_pages>
    free_page(p1);
ffffffffc0200d76:	854e                	mv	a0,s3
ffffffffc0200d78:	4585                	li	a1,1
ffffffffc0200d7a:	209000ef          	jal	ffffffffc0201782 <free_pages>
    free_page(p2);
ffffffffc0200d7e:	8552                	mv	a0,s4
ffffffffc0200d80:	4585                	li	a1,1
ffffffffc0200d82:	201000ef          	jal	ffffffffc0201782 <free_pages>
    assert(nr_free == 3);
ffffffffc0200d86:	00006717          	auipc	a4,0x6
ffffffffc0200d8a:	2b272703          	lw	a4,690(a4) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200d8e:	478d                	li	a5,3
ffffffffc0200d90:	2af71463          	bne	a4,a5,ffffffffc0201038 <default_check+0x402>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200d94:	4505                	li	a0,1
ffffffffc0200d96:	1b3000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200d9a:	89aa                	mv	s3,a0
ffffffffc0200d9c:	26050e63          	beqz	a0,ffffffffc0201018 <default_check+0x3e2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200da0:	4505                	li	a0,1
ffffffffc0200da2:	1a7000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200da6:	8aaa                	mv	s5,a0
ffffffffc0200da8:	3c050863          	beqz	a0,ffffffffc0201178 <default_check+0x542>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200dac:	4505                	li	a0,1
ffffffffc0200dae:	19b000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200db2:	8a2a                	mv	s4,a0
ffffffffc0200db4:	3a050263          	beqz	a0,ffffffffc0201158 <default_check+0x522>
    assert(alloc_page() == NULL);
ffffffffc0200db8:	4505                	li	a0,1
ffffffffc0200dba:	18f000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200dbe:	36051d63          	bnez	a0,ffffffffc0201138 <default_check+0x502>
    free_page(p0);
ffffffffc0200dc2:	4585                	li	a1,1
ffffffffc0200dc4:	854e                	mv	a0,s3
ffffffffc0200dc6:	1bd000ef          	jal	ffffffffc0201782 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200dca:	00893783          	ld	a5,8(s2)
ffffffffc0200dce:	1f278563          	beq	a5,s2,ffffffffc0200fb8 <default_check+0x382>
    assert((p = alloc_page()) == p0);
ffffffffc0200dd2:	4505                	li	a0,1
ffffffffc0200dd4:	175000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200dd8:	8caa                	mv	s9,a0
ffffffffc0200dda:	30a99f63          	bne	s3,a0,ffffffffc02010f8 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0200dde:	4505                	li	a0,1
ffffffffc0200de0:	169000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200de4:	2e051a63          	bnez	a0,ffffffffc02010d8 <default_check+0x4a2>
    assert(nr_free == 0);
ffffffffc0200de8:	00006797          	auipc	a5,0x6
ffffffffc0200dec:	2507a783          	lw	a5,592(a5) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200df0:	2c079463          	bnez	a5,ffffffffc02010b8 <default_check+0x482>
    free_page(p);
ffffffffc0200df4:	8566                	mv	a0,s9
ffffffffc0200df6:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200df8:	01893023          	sd	s8,0(s2)
ffffffffc0200dfc:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc0200e00:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc0200e04:	17f000ef          	jal	ffffffffc0201782 <free_pages>
    free_page(p1);
ffffffffc0200e08:	8556                	mv	a0,s5
ffffffffc0200e0a:	4585                	li	a1,1
ffffffffc0200e0c:	177000ef          	jal	ffffffffc0201782 <free_pages>
    free_page(p2);
ffffffffc0200e10:	8552                	mv	a0,s4
ffffffffc0200e12:	4585                	li	a1,1
ffffffffc0200e14:	16f000ef          	jal	ffffffffc0201782 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200e18:	4515                	li	a0,5
ffffffffc0200e1a:	12f000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200e1e:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200e20:	26050c63          	beqz	a0,ffffffffc0201098 <default_check+0x462>
ffffffffc0200e24:	651c                	ld	a5,8(a0)
ffffffffc0200e26:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200e28:	8b85                	andi	a5,a5,1
ffffffffc0200e2a:	54079763          	bnez	a5,ffffffffc0201378 <default_check+0x742>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200e2e:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200e30:	00093b83          	ld	s7,0(s2)
ffffffffc0200e34:	00893b03          	ld	s6,8(s2)
ffffffffc0200e38:	01293023          	sd	s2,0(s2)
ffffffffc0200e3c:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc0200e40:	109000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200e44:	50051a63          	bnez	a0,ffffffffc0201358 <default_check+0x722>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0200e48:	05098a13          	addi	s4,s3,80
ffffffffc0200e4c:	8552                	mv	a0,s4
ffffffffc0200e4e:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0200e50:	00006c17          	auipc	s8,0x6
ffffffffc0200e54:	1e8c2c03          	lw	s8,488(s8) # ffffffffc0207038 <free_area+0x10>
    nr_free = 0;
ffffffffc0200e58:	00006797          	auipc	a5,0x6
ffffffffc0200e5c:	1e07a023          	sw	zero,480(a5) # ffffffffc0207038 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0200e60:	123000ef          	jal	ffffffffc0201782 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200e64:	4511                	li	a0,4
ffffffffc0200e66:	0e3000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200e6a:	4c051763          	bnez	a0,ffffffffc0201338 <default_check+0x702>
ffffffffc0200e6e:	0589b783          	ld	a5,88(s3)
ffffffffc0200e72:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0200e74:	8b85                	andi	a5,a5,1
ffffffffc0200e76:	4a078163          	beqz	a5,ffffffffc0201318 <default_check+0x6e2>
ffffffffc0200e7a:	0609a503          	lw	a0,96(s3)
ffffffffc0200e7e:	478d                	li	a5,3
ffffffffc0200e80:	48f51c63          	bne	a0,a5,ffffffffc0201318 <default_check+0x6e2>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0200e84:	0c5000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200e88:	8aaa                	mv	s5,a0
ffffffffc0200e8a:	46050763          	beqz	a0,ffffffffc02012f8 <default_check+0x6c2>
    assert(alloc_page() == NULL);
ffffffffc0200e8e:	4505                	li	a0,1
ffffffffc0200e90:	0b9000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200e94:	44051263          	bnez	a0,ffffffffc02012d8 <default_check+0x6a2>
    assert(p0 + 2 == p1);
ffffffffc0200e98:	435a1063          	bne	s4,s5,ffffffffc02012b8 <default_check+0x682>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0200e9c:	4585                	li	a1,1
ffffffffc0200e9e:	854e                	mv	a0,s3
ffffffffc0200ea0:	0e3000ef          	jal	ffffffffc0201782 <free_pages>
    free_pages(p1, 3);
ffffffffc0200ea4:	8552                	mv	a0,s4
ffffffffc0200ea6:	458d                	li	a1,3
ffffffffc0200ea8:	0db000ef          	jal	ffffffffc0201782 <free_pages>
ffffffffc0200eac:	0089b783          	ld	a5,8(s3)
ffffffffc0200eb0:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0200eb2:	8b85                	andi	a5,a5,1
ffffffffc0200eb4:	3e078263          	beqz	a5,ffffffffc0201298 <default_check+0x662>
ffffffffc0200eb8:	0109aa83          	lw	s5,16(s3)
ffffffffc0200ebc:	4785                	li	a5,1
ffffffffc0200ebe:	3cfa9d63          	bne	s5,a5,ffffffffc0201298 <default_check+0x662>
ffffffffc0200ec2:	008a3783          	ld	a5,8(s4)
ffffffffc0200ec6:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0200ec8:	8b85                	andi	a5,a5,1
ffffffffc0200eca:	3a078763          	beqz	a5,ffffffffc0201278 <default_check+0x642>
ffffffffc0200ece:	010a2703          	lw	a4,16(s4)
ffffffffc0200ed2:	478d                	li	a5,3
ffffffffc0200ed4:	3af71263          	bne	a4,a5,ffffffffc0201278 <default_check+0x642>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0200ed8:	8556                	mv	a0,s5
ffffffffc0200eda:	06f000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200ede:	36a99d63          	bne	s3,a0,ffffffffc0201258 <default_check+0x622>
    free_page(p0);
ffffffffc0200ee2:	85d6                	mv	a1,s5
ffffffffc0200ee4:	09f000ef          	jal	ffffffffc0201782 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0200ee8:	4509                	li	a0,2
ffffffffc0200eea:	05f000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200eee:	34aa1563          	bne	s4,a0,ffffffffc0201238 <default_check+0x602>

    free_pages(p0, 2);
ffffffffc0200ef2:	4589                	li	a1,2
ffffffffc0200ef4:	08f000ef          	jal	ffffffffc0201782 <free_pages>
    free_page(p2);
ffffffffc0200ef8:	02898513          	addi	a0,s3,40
ffffffffc0200efc:	85d6                	mv	a1,s5
ffffffffc0200efe:	085000ef          	jal	ffffffffc0201782 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200f02:	4515                	li	a0,5
ffffffffc0200f04:	045000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200f08:	89aa                	mv	s3,a0
ffffffffc0200f0a:	48050763          	beqz	a0,ffffffffc0201398 <default_check+0x762>
    assert(alloc_page() == NULL);
ffffffffc0200f0e:	8556                	mv	a0,s5
ffffffffc0200f10:	039000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200f14:	2e051263          	bnez	a0,ffffffffc02011f8 <default_check+0x5c2>

    assert(nr_free == 0);
ffffffffc0200f18:	00006797          	auipc	a5,0x6
ffffffffc0200f1c:	1207a783          	lw	a5,288(a5) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200f20:	2a079c63          	bnez	a5,ffffffffc02011d8 <default_check+0x5a2>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200f24:	854e                	mv	a0,s3
ffffffffc0200f26:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc0200f28:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc0200f2c:	01793023          	sd	s7,0(s2)
ffffffffc0200f30:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc0200f34:	04f000ef          	jal	ffffffffc0201782 <free_pages>
    return listelm->next;
ffffffffc0200f38:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200f3c:	01278963          	beq	a5,s2,ffffffffc0200f4e <default_check+0x318>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200f40:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200f44:	679c                	ld	a5,8(a5)
ffffffffc0200f46:	34fd                	addiw	s1,s1,-1
ffffffffc0200f48:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200f4a:	ff279be3          	bne	a5,s2,ffffffffc0200f40 <default_check+0x30a>
    }
    assert(count == 0);
ffffffffc0200f4e:	26049563          	bnez	s1,ffffffffc02011b8 <default_check+0x582>
    assert(total == 0);
ffffffffc0200f52:	46041363          	bnez	s0,ffffffffc02013b8 <default_check+0x782>
}
ffffffffc0200f56:	60e6                	ld	ra,88(sp)
ffffffffc0200f58:	6446                	ld	s0,80(sp)
ffffffffc0200f5a:	64a6                	ld	s1,72(sp)
ffffffffc0200f5c:	6906                	ld	s2,64(sp)
ffffffffc0200f5e:	79e2                	ld	s3,56(sp)
ffffffffc0200f60:	7a42                	ld	s4,48(sp)
ffffffffc0200f62:	7aa2                	ld	s5,40(sp)
ffffffffc0200f64:	7b02                	ld	s6,32(sp)
ffffffffc0200f66:	6be2                	ld	s7,24(sp)
ffffffffc0200f68:	6c42                	ld	s8,16(sp)
ffffffffc0200f6a:	6ca2                	ld	s9,8(sp)
ffffffffc0200f6c:	6125                	addi	sp,sp,96
ffffffffc0200f6e:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200f70:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200f72:	4401                	li	s0,0
ffffffffc0200f74:	4481                	li	s1,0
ffffffffc0200f76:	b319                	j	ffffffffc0200c7c <default_check+0x46>
        assert(PageProperty(p));
ffffffffc0200f78:	00002697          	auipc	a3,0x2
ffffffffc0200f7c:	8b868693          	addi	a3,a3,-1864 # ffffffffc0202830 <etext+0x8c4>
ffffffffc0200f80:	00002617          	auipc	a2,0x2
ffffffffc0200f84:	8c060613          	addi	a2,a2,-1856 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0200f88:	0f000593          	li	a1,240
ffffffffc0200f8c:	00002517          	auipc	a0,0x2
ffffffffc0200f90:	8cc50513          	addi	a0,a0,-1844 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0200f94:	bf4ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200f98:	00002697          	auipc	a3,0x2
ffffffffc0200f9c:	98068693          	addi	a3,a3,-1664 # ffffffffc0202918 <etext+0x9ac>
ffffffffc0200fa0:	00002617          	auipc	a2,0x2
ffffffffc0200fa4:	8a060613          	addi	a2,a2,-1888 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0200fa8:	0be00593          	li	a1,190
ffffffffc0200fac:	00002517          	auipc	a0,0x2
ffffffffc0200fb0:	8ac50513          	addi	a0,a0,-1876 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0200fb4:	bd4ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0200fb8:	00002697          	auipc	a3,0x2
ffffffffc0200fbc:	a2868693          	addi	a3,a3,-1496 # ffffffffc02029e0 <etext+0xa74>
ffffffffc0200fc0:	00002617          	auipc	a2,0x2
ffffffffc0200fc4:	88060613          	addi	a2,a2,-1920 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0200fc8:	0d900593          	li	a1,217
ffffffffc0200fcc:	00002517          	auipc	a0,0x2
ffffffffc0200fd0:	88c50513          	addi	a0,a0,-1908 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0200fd4:	bb4ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200fd8:	00002697          	auipc	a3,0x2
ffffffffc0200fdc:	98068693          	addi	a3,a3,-1664 # ffffffffc0202958 <etext+0x9ec>
ffffffffc0200fe0:	00002617          	auipc	a2,0x2
ffffffffc0200fe4:	86060613          	addi	a2,a2,-1952 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0200fe8:	0c000593          	li	a1,192
ffffffffc0200fec:	00002517          	auipc	a0,0x2
ffffffffc0200ff0:	86c50513          	addi	a0,a0,-1940 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0200ff4:	b94ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200ff8:	00002697          	auipc	a3,0x2
ffffffffc0200ffc:	8f868693          	addi	a3,a3,-1800 # ffffffffc02028f0 <etext+0x984>
ffffffffc0201000:	00002617          	auipc	a2,0x2
ffffffffc0201004:	84060613          	addi	a2,a2,-1984 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201008:	0bd00593          	li	a1,189
ffffffffc020100c:	00002517          	auipc	a0,0x2
ffffffffc0201010:	84c50513          	addi	a0,a0,-1972 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201014:	b74ff0ef          	jal	ffffffffc0200388 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201018:	00002697          	auipc	a3,0x2
ffffffffc020101c:	87868693          	addi	a3,a3,-1928 # ffffffffc0202890 <etext+0x924>
ffffffffc0201020:	00002617          	auipc	a2,0x2
ffffffffc0201024:	82060613          	addi	a2,a2,-2016 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201028:	0d200593          	li	a1,210
ffffffffc020102c:	00002517          	auipc	a0,0x2
ffffffffc0201030:	82c50513          	addi	a0,a0,-2004 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201034:	b54ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(nr_free == 3);
ffffffffc0201038:	00002697          	auipc	a3,0x2
ffffffffc020103c:	99868693          	addi	a3,a3,-1640 # ffffffffc02029d0 <etext+0xa64>
ffffffffc0201040:	00002617          	auipc	a2,0x2
ffffffffc0201044:	80060613          	addi	a2,a2,-2048 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201048:	0d000593          	li	a1,208
ffffffffc020104c:	00002517          	auipc	a0,0x2
ffffffffc0201050:	80c50513          	addi	a0,a0,-2036 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201054:	b34ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201058:	00002697          	auipc	a3,0x2
ffffffffc020105c:	96068693          	addi	a3,a3,-1696 # ffffffffc02029b8 <etext+0xa4c>
ffffffffc0201060:	00001617          	auipc	a2,0x1
ffffffffc0201064:	7e060613          	addi	a2,a2,2016 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201068:	0cb00593          	li	a1,203
ffffffffc020106c:	00001517          	auipc	a0,0x1
ffffffffc0201070:	7ec50513          	addi	a0,a0,2028 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201074:	b14ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201078:	00002697          	auipc	a3,0x2
ffffffffc020107c:	92068693          	addi	a3,a3,-1760 # ffffffffc0202998 <etext+0xa2c>
ffffffffc0201080:	00001617          	auipc	a2,0x1
ffffffffc0201084:	7c060613          	addi	a2,a2,1984 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201088:	0c200593          	li	a1,194
ffffffffc020108c:	00001517          	auipc	a0,0x1
ffffffffc0201090:	7cc50513          	addi	a0,a0,1996 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201094:	af4ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(p0 != NULL);
ffffffffc0201098:	00002697          	auipc	a3,0x2
ffffffffc020109c:	99068693          	addi	a3,a3,-1648 # ffffffffc0202a28 <etext+0xabc>
ffffffffc02010a0:	00001617          	auipc	a2,0x1
ffffffffc02010a4:	7a060613          	addi	a2,a2,1952 # ffffffffc0202840 <etext+0x8d4>
ffffffffc02010a8:	0f800593          	li	a1,248
ffffffffc02010ac:	00001517          	auipc	a0,0x1
ffffffffc02010b0:	7ac50513          	addi	a0,a0,1964 # ffffffffc0202858 <etext+0x8ec>
ffffffffc02010b4:	ad4ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(nr_free == 0);
ffffffffc02010b8:	00002697          	auipc	a3,0x2
ffffffffc02010bc:	96068693          	addi	a3,a3,-1696 # ffffffffc0202a18 <etext+0xaac>
ffffffffc02010c0:	00001617          	auipc	a2,0x1
ffffffffc02010c4:	78060613          	addi	a2,a2,1920 # ffffffffc0202840 <etext+0x8d4>
ffffffffc02010c8:	0df00593          	li	a1,223
ffffffffc02010cc:	00001517          	auipc	a0,0x1
ffffffffc02010d0:	78c50513          	addi	a0,a0,1932 # ffffffffc0202858 <etext+0x8ec>
ffffffffc02010d4:	ab4ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02010d8:	00002697          	auipc	a3,0x2
ffffffffc02010dc:	8e068693          	addi	a3,a3,-1824 # ffffffffc02029b8 <etext+0xa4c>
ffffffffc02010e0:	00001617          	auipc	a2,0x1
ffffffffc02010e4:	76060613          	addi	a2,a2,1888 # ffffffffc0202840 <etext+0x8d4>
ffffffffc02010e8:	0dd00593          	li	a1,221
ffffffffc02010ec:	00001517          	auipc	a0,0x1
ffffffffc02010f0:	76c50513          	addi	a0,a0,1900 # ffffffffc0202858 <etext+0x8ec>
ffffffffc02010f4:	a94ff0ef          	jal	ffffffffc0200388 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02010f8:	00002697          	auipc	a3,0x2
ffffffffc02010fc:	90068693          	addi	a3,a3,-1792 # ffffffffc02029f8 <etext+0xa8c>
ffffffffc0201100:	00001617          	auipc	a2,0x1
ffffffffc0201104:	74060613          	addi	a2,a2,1856 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201108:	0dc00593          	li	a1,220
ffffffffc020110c:	00001517          	auipc	a0,0x1
ffffffffc0201110:	74c50513          	addi	a0,a0,1868 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201114:	a74ff0ef          	jal	ffffffffc0200388 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201118:	00001697          	auipc	a3,0x1
ffffffffc020111c:	77868693          	addi	a3,a3,1912 # ffffffffc0202890 <etext+0x924>
ffffffffc0201120:	00001617          	auipc	a2,0x1
ffffffffc0201124:	72060613          	addi	a2,a2,1824 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201128:	0b900593          	li	a1,185
ffffffffc020112c:	00001517          	auipc	a0,0x1
ffffffffc0201130:	72c50513          	addi	a0,a0,1836 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201134:	a54ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201138:	00002697          	auipc	a3,0x2
ffffffffc020113c:	88068693          	addi	a3,a3,-1920 # ffffffffc02029b8 <etext+0xa4c>
ffffffffc0201140:	00001617          	auipc	a2,0x1
ffffffffc0201144:	70060613          	addi	a2,a2,1792 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201148:	0d600593          	li	a1,214
ffffffffc020114c:	00001517          	auipc	a0,0x1
ffffffffc0201150:	70c50513          	addi	a0,a0,1804 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201154:	a34ff0ef          	jal	ffffffffc0200388 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201158:	00001697          	auipc	a3,0x1
ffffffffc020115c:	77868693          	addi	a3,a3,1912 # ffffffffc02028d0 <etext+0x964>
ffffffffc0201160:	00001617          	auipc	a2,0x1
ffffffffc0201164:	6e060613          	addi	a2,a2,1760 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201168:	0d400593          	li	a1,212
ffffffffc020116c:	00001517          	auipc	a0,0x1
ffffffffc0201170:	6ec50513          	addi	a0,a0,1772 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201174:	a14ff0ef          	jal	ffffffffc0200388 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201178:	00001697          	auipc	a3,0x1
ffffffffc020117c:	73868693          	addi	a3,a3,1848 # ffffffffc02028b0 <etext+0x944>
ffffffffc0201180:	00001617          	auipc	a2,0x1
ffffffffc0201184:	6c060613          	addi	a2,a2,1728 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201188:	0d300593          	li	a1,211
ffffffffc020118c:	00001517          	auipc	a0,0x1
ffffffffc0201190:	6cc50513          	addi	a0,a0,1740 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201194:	9f4ff0ef          	jal	ffffffffc0200388 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201198:	00001697          	auipc	a3,0x1
ffffffffc020119c:	73868693          	addi	a3,a3,1848 # ffffffffc02028d0 <etext+0x964>
ffffffffc02011a0:	00001617          	auipc	a2,0x1
ffffffffc02011a4:	6a060613          	addi	a2,a2,1696 # ffffffffc0202840 <etext+0x8d4>
ffffffffc02011a8:	0bb00593          	li	a1,187
ffffffffc02011ac:	00001517          	auipc	a0,0x1
ffffffffc02011b0:	6ac50513          	addi	a0,a0,1708 # ffffffffc0202858 <etext+0x8ec>
ffffffffc02011b4:	9d4ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(count == 0);
ffffffffc02011b8:	00002697          	auipc	a3,0x2
ffffffffc02011bc:	9c068693          	addi	a3,a3,-1600 # ffffffffc0202b78 <etext+0xc0c>
ffffffffc02011c0:	00001617          	auipc	a2,0x1
ffffffffc02011c4:	68060613          	addi	a2,a2,1664 # ffffffffc0202840 <etext+0x8d4>
ffffffffc02011c8:	12500593          	li	a1,293
ffffffffc02011cc:	00001517          	auipc	a0,0x1
ffffffffc02011d0:	68c50513          	addi	a0,a0,1676 # ffffffffc0202858 <etext+0x8ec>
ffffffffc02011d4:	9b4ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(nr_free == 0);
ffffffffc02011d8:	00002697          	auipc	a3,0x2
ffffffffc02011dc:	84068693          	addi	a3,a3,-1984 # ffffffffc0202a18 <etext+0xaac>
ffffffffc02011e0:	00001617          	auipc	a2,0x1
ffffffffc02011e4:	66060613          	addi	a2,a2,1632 # ffffffffc0202840 <etext+0x8d4>
ffffffffc02011e8:	11a00593          	li	a1,282
ffffffffc02011ec:	00001517          	auipc	a0,0x1
ffffffffc02011f0:	66c50513          	addi	a0,a0,1644 # ffffffffc0202858 <etext+0x8ec>
ffffffffc02011f4:	994ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011f8:	00001697          	auipc	a3,0x1
ffffffffc02011fc:	7c068693          	addi	a3,a3,1984 # ffffffffc02029b8 <etext+0xa4c>
ffffffffc0201200:	00001617          	auipc	a2,0x1
ffffffffc0201204:	64060613          	addi	a2,a2,1600 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201208:	11800593          	li	a1,280
ffffffffc020120c:	00001517          	auipc	a0,0x1
ffffffffc0201210:	64c50513          	addi	a0,a0,1612 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201214:	974ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201218:	00001697          	auipc	a3,0x1
ffffffffc020121c:	76068693          	addi	a3,a3,1888 # ffffffffc0202978 <etext+0xa0c>
ffffffffc0201220:	00001617          	auipc	a2,0x1
ffffffffc0201224:	62060613          	addi	a2,a2,1568 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201228:	0c100593          	li	a1,193
ffffffffc020122c:	00001517          	auipc	a0,0x1
ffffffffc0201230:	62c50513          	addi	a0,a0,1580 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201234:	954ff0ef          	jal	ffffffffc0200388 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201238:	00002697          	auipc	a3,0x2
ffffffffc020123c:	90068693          	addi	a3,a3,-1792 # ffffffffc0202b38 <etext+0xbcc>
ffffffffc0201240:	00001617          	auipc	a2,0x1
ffffffffc0201244:	60060613          	addi	a2,a2,1536 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201248:	11200593          	li	a1,274
ffffffffc020124c:	00001517          	auipc	a0,0x1
ffffffffc0201250:	60c50513          	addi	a0,a0,1548 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201254:	934ff0ef          	jal	ffffffffc0200388 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201258:	00002697          	auipc	a3,0x2
ffffffffc020125c:	8c068693          	addi	a3,a3,-1856 # ffffffffc0202b18 <etext+0xbac>
ffffffffc0201260:	00001617          	auipc	a2,0x1
ffffffffc0201264:	5e060613          	addi	a2,a2,1504 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201268:	11000593          	li	a1,272
ffffffffc020126c:	00001517          	auipc	a0,0x1
ffffffffc0201270:	5ec50513          	addi	a0,a0,1516 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201274:	914ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201278:	00002697          	auipc	a3,0x2
ffffffffc020127c:	87868693          	addi	a3,a3,-1928 # ffffffffc0202af0 <etext+0xb84>
ffffffffc0201280:	00001617          	auipc	a2,0x1
ffffffffc0201284:	5c060613          	addi	a2,a2,1472 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201288:	10e00593          	li	a1,270
ffffffffc020128c:	00001517          	auipc	a0,0x1
ffffffffc0201290:	5cc50513          	addi	a0,a0,1484 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201294:	8f4ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201298:	00002697          	auipc	a3,0x2
ffffffffc020129c:	83068693          	addi	a3,a3,-2000 # ffffffffc0202ac8 <etext+0xb5c>
ffffffffc02012a0:	00001617          	auipc	a2,0x1
ffffffffc02012a4:	5a060613          	addi	a2,a2,1440 # ffffffffc0202840 <etext+0x8d4>
ffffffffc02012a8:	10d00593          	li	a1,269
ffffffffc02012ac:	00001517          	auipc	a0,0x1
ffffffffc02012b0:	5ac50513          	addi	a0,a0,1452 # ffffffffc0202858 <etext+0x8ec>
ffffffffc02012b4:	8d4ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(p0 + 2 == p1);
ffffffffc02012b8:	00002697          	auipc	a3,0x2
ffffffffc02012bc:	80068693          	addi	a3,a3,-2048 # ffffffffc0202ab8 <etext+0xb4c>
ffffffffc02012c0:	00001617          	auipc	a2,0x1
ffffffffc02012c4:	58060613          	addi	a2,a2,1408 # ffffffffc0202840 <etext+0x8d4>
ffffffffc02012c8:	10800593          	li	a1,264
ffffffffc02012cc:	00001517          	auipc	a0,0x1
ffffffffc02012d0:	58c50513          	addi	a0,a0,1420 # ffffffffc0202858 <etext+0x8ec>
ffffffffc02012d4:	8b4ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012d8:	00001697          	auipc	a3,0x1
ffffffffc02012dc:	6e068693          	addi	a3,a3,1760 # ffffffffc02029b8 <etext+0xa4c>
ffffffffc02012e0:	00001617          	auipc	a2,0x1
ffffffffc02012e4:	56060613          	addi	a2,a2,1376 # ffffffffc0202840 <etext+0x8d4>
ffffffffc02012e8:	10700593          	li	a1,263
ffffffffc02012ec:	00001517          	auipc	a0,0x1
ffffffffc02012f0:	56c50513          	addi	a0,a0,1388 # ffffffffc0202858 <etext+0x8ec>
ffffffffc02012f4:	894ff0ef          	jal	ffffffffc0200388 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02012f8:	00001697          	auipc	a3,0x1
ffffffffc02012fc:	7a068693          	addi	a3,a3,1952 # ffffffffc0202a98 <etext+0xb2c>
ffffffffc0201300:	00001617          	auipc	a2,0x1
ffffffffc0201304:	54060613          	addi	a2,a2,1344 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201308:	10600593          	li	a1,262
ffffffffc020130c:	00001517          	auipc	a0,0x1
ffffffffc0201310:	54c50513          	addi	a0,a0,1356 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201314:	874ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201318:	00001697          	auipc	a3,0x1
ffffffffc020131c:	75068693          	addi	a3,a3,1872 # ffffffffc0202a68 <etext+0xafc>
ffffffffc0201320:	00001617          	auipc	a2,0x1
ffffffffc0201324:	52060613          	addi	a2,a2,1312 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201328:	10500593          	li	a1,261
ffffffffc020132c:	00001517          	auipc	a0,0x1
ffffffffc0201330:	52c50513          	addi	a0,a0,1324 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201334:	854ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201338:	00001697          	auipc	a3,0x1
ffffffffc020133c:	71868693          	addi	a3,a3,1816 # ffffffffc0202a50 <etext+0xae4>
ffffffffc0201340:	00001617          	auipc	a2,0x1
ffffffffc0201344:	50060613          	addi	a2,a2,1280 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201348:	10400593          	li	a1,260
ffffffffc020134c:	00001517          	auipc	a0,0x1
ffffffffc0201350:	50c50513          	addi	a0,a0,1292 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201354:	834ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201358:	00001697          	auipc	a3,0x1
ffffffffc020135c:	66068693          	addi	a3,a3,1632 # ffffffffc02029b8 <etext+0xa4c>
ffffffffc0201360:	00001617          	auipc	a2,0x1
ffffffffc0201364:	4e060613          	addi	a2,a2,1248 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201368:	0fe00593          	li	a1,254
ffffffffc020136c:	00001517          	auipc	a0,0x1
ffffffffc0201370:	4ec50513          	addi	a0,a0,1260 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201374:	814ff0ef          	jal	ffffffffc0200388 <__panic>
    assert(!PageProperty(p0));
ffffffffc0201378:	00001697          	auipc	a3,0x1
ffffffffc020137c:	6c068693          	addi	a3,a3,1728 # ffffffffc0202a38 <etext+0xacc>
ffffffffc0201380:	00001617          	auipc	a2,0x1
ffffffffc0201384:	4c060613          	addi	a2,a2,1216 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201388:	0f900593          	li	a1,249
ffffffffc020138c:	00001517          	auipc	a0,0x1
ffffffffc0201390:	4cc50513          	addi	a0,a0,1228 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201394:	ff5fe0ef          	jal	ffffffffc0200388 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201398:	00001697          	auipc	a3,0x1
ffffffffc020139c:	7c068693          	addi	a3,a3,1984 # ffffffffc0202b58 <etext+0xbec>
ffffffffc02013a0:	00001617          	auipc	a2,0x1
ffffffffc02013a4:	4a060613          	addi	a2,a2,1184 # ffffffffc0202840 <etext+0x8d4>
ffffffffc02013a8:	11700593          	li	a1,279
ffffffffc02013ac:	00001517          	auipc	a0,0x1
ffffffffc02013b0:	4ac50513          	addi	a0,a0,1196 # ffffffffc0202858 <etext+0x8ec>
ffffffffc02013b4:	fd5fe0ef          	jal	ffffffffc0200388 <__panic>
    assert(total == 0);
ffffffffc02013b8:	00001697          	auipc	a3,0x1
ffffffffc02013bc:	7d068693          	addi	a3,a3,2000 # ffffffffc0202b88 <etext+0xc1c>
ffffffffc02013c0:	00001617          	auipc	a2,0x1
ffffffffc02013c4:	48060613          	addi	a2,a2,1152 # ffffffffc0202840 <etext+0x8d4>
ffffffffc02013c8:	12600593          	li	a1,294
ffffffffc02013cc:	00001517          	auipc	a0,0x1
ffffffffc02013d0:	48c50513          	addi	a0,a0,1164 # ffffffffc0202858 <etext+0x8ec>
ffffffffc02013d4:	fb5fe0ef          	jal	ffffffffc0200388 <__panic>
    assert(total == nr_free_pages());
ffffffffc02013d8:	00001697          	auipc	a3,0x1
ffffffffc02013dc:	49868693          	addi	a3,a3,1176 # ffffffffc0202870 <etext+0x904>
ffffffffc02013e0:	00001617          	auipc	a2,0x1
ffffffffc02013e4:	46060613          	addi	a2,a2,1120 # ffffffffc0202840 <etext+0x8d4>
ffffffffc02013e8:	0f300593          	li	a1,243
ffffffffc02013ec:	00001517          	auipc	a0,0x1
ffffffffc02013f0:	46c50513          	addi	a0,a0,1132 # ffffffffc0202858 <etext+0x8ec>
ffffffffc02013f4:	f95fe0ef          	jal	ffffffffc0200388 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02013f8:	00001697          	auipc	a3,0x1
ffffffffc02013fc:	4b868693          	addi	a3,a3,1208 # ffffffffc02028b0 <etext+0x944>
ffffffffc0201400:	00001617          	auipc	a2,0x1
ffffffffc0201404:	44060613          	addi	a2,a2,1088 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201408:	0ba00593          	li	a1,186
ffffffffc020140c:	00001517          	auipc	a0,0x1
ffffffffc0201410:	44c50513          	addi	a0,a0,1100 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201414:	f75fe0ef          	jal	ffffffffc0200388 <__panic>

ffffffffc0201418 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc0201418:	1141                	addi	sp,sp,-16
ffffffffc020141a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020141c:	14058c63          	beqz	a1,ffffffffc0201574 <default_free_pages+0x15c>
    for (; p != base + n; p ++) {
ffffffffc0201420:	00259713          	slli	a4,a1,0x2
ffffffffc0201424:	972e                	add	a4,a4,a1
ffffffffc0201426:	070e                	slli	a4,a4,0x3
ffffffffc0201428:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc020142c:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc020142e:	c30d                	beqz	a4,ffffffffc0201450 <default_free_pages+0x38>
ffffffffc0201430:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201432:	8b05                	andi	a4,a4,1
ffffffffc0201434:	12071063          	bnez	a4,ffffffffc0201554 <default_free_pages+0x13c>
ffffffffc0201438:	6798                	ld	a4,8(a5)
ffffffffc020143a:	8b09                	andi	a4,a4,2
ffffffffc020143c:	10071c63          	bnez	a4,ffffffffc0201554 <default_free_pages+0x13c>
        p->flags = 0;
ffffffffc0201440:	0007b423          	sd	zero,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0201444:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201448:	02878793          	addi	a5,a5,40
ffffffffc020144c:	fed792e3          	bne	a5,a3,ffffffffc0201430 <default_free_pages+0x18>
    base->property = n;
ffffffffc0201450:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201452:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201456:	4789                	li	a5,2
ffffffffc0201458:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc020145c:	00006717          	auipc	a4,0x6
ffffffffc0201460:	bdc72703          	lw	a4,-1060(a4) # ffffffffc0207038 <free_area+0x10>
ffffffffc0201464:	00006697          	auipc	a3,0x6
ffffffffc0201468:	bc468693          	addi	a3,a3,-1084 # ffffffffc0207028 <free_area>
    return list->next == list;
ffffffffc020146c:	669c                	ld	a5,8(a3)
ffffffffc020146e:	9f2d                	addw	a4,a4,a1
ffffffffc0201470:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201472:	0ad78563          	beq	a5,a3,ffffffffc020151c <default_free_pages+0x104>
            struct Page* page = le2page(le, page_link);
ffffffffc0201476:	fe878713          	addi	a4,a5,-24
ffffffffc020147a:	4581                	li	a1,0
ffffffffc020147c:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0201480:	00e56a63          	bltu	a0,a4,ffffffffc0201494 <default_free_pages+0x7c>
    return listelm->next;
ffffffffc0201484:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201486:	06d70263          	beq	a4,a3,ffffffffc02014ea <default_free_pages+0xd2>
    struct Page *p = base;
ffffffffc020148a:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020148c:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201490:	fee57ae3          	bgeu	a0,a4,ffffffffc0201484 <default_free_pages+0x6c>
ffffffffc0201494:	c199                	beqz	a1,ffffffffc020149a <default_free_pages+0x82>
ffffffffc0201496:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020149a:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc020149c:	e390                	sd	a2,0(a5)
ffffffffc020149e:	e710                	sd	a2,8(a4)
    elm->next = next;
    elm->prev = prev;
ffffffffc02014a0:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc02014a2:	f11c                	sd	a5,32(a0)
    if (le != &free_list) {
ffffffffc02014a4:	02d70063          	beq	a4,a3,ffffffffc02014c4 <default_free_pages+0xac>
        if (p + p->property == base) {
ffffffffc02014a8:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc02014ac:	fe870593          	addi	a1,a4,-24
        if (p + p->property == base) {
ffffffffc02014b0:	02081613          	slli	a2,a6,0x20
ffffffffc02014b4:	9201                	srli	a2,a2,0x20
ffffffffc02014b6:	00261793          	slli	a5,a2,0x2
ffffffffc02014ba:	97b2                	add	a5,a5,a2
ffffffffc02014bc:	078e                	slli	a5,a5,0x3
ffffffffc02014be:	97ae                	add	a5,a5,a1
ffffffffc02014c0:	02f50f63          	beq	a0,a5,ffffffffc02014fe <default_free_pages+0xe6>
    return listelm->next;
ffffffffc02014c4:	7118                	ld	a4,32(a0)
    if (le != &free_list) {
ffffffffc02014c6:	00d70f63          	beq	a4,a3,ffffffffc02014e4 <default_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc02014ca:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc02014cc:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc02014d0:	02059613          	slli	a2,a1,0x20
ffffffffc02014d4:	9201                	srli	a2,a2,0x20
ffffffffc02014d6:	00261793          	slli	a5,a2,0x2
ffffffffc02014da:	97b2                	add	a5,a5,a2
ffffffffc02014dc:	078e                	slli	a5,a5,0x3
ffffffffc02014de:	97aa                	add	a5,a5,a0
ffffffffc02014e0:	04f68a63          	beq	a3,a5,ffffffffc0201534 <default_free_pages+0x11c>
}
ffffffffc02014e4:	60a2                	ld	ra,8(sp)
ffffffffc02014e6:	0141                	addi	sp,sp,16
ffffffffc02014e8:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02014ea:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02014ec:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02014ee:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02014f0:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc02014f2:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc02014f4:	02d70d63          	beq	a4,a3,ffffffffc020152e <default_free_pages+0x116>
ffffffffc02014f8:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc02014fa:	87ba                	mv	a5,a4
ffffffffc02014fc:	bf41                	j	ffffffffc020148c <default_free_pages+0x74>
            p->property += base->property;
ffffffffc02014fe:	491c                	lw	a5,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201500:	5675                	li	a2,-3
ffffffffc0201502:	010787bb          	addw	a5,a5,a6
ffffffffc0201506:	fef72c23          	sw	a5,-8(a4)
ffffffffc020150a:	60c8b02f          	amoand.d	zero,a2,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020150e:	6d10                	ld	a2,24(a0)
ffffffffc0201510:	711c                	ld	a5,32(a0)
            base = p;
ffffffffc0201512:	852e                	mv	a0,a1
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201514:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc0201516:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc0201518:	e390                	sd	a2,0(a5)
ffffffffc020151a:	b775                	j	ffffffffc02014c6 <default_free_pages+0xae>
}
ffffffffc020151c:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc020151e:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201522:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201524:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0201526:	e398                	sd	a4,0(a5)
ffffffffc0201528:	e798                	sd	a4,8(a5)
}
ffffffffc020152a:	0141                	addi	sp,sp,16
ffffffffc020152c:	8082                	ret
ffffffffc020152e:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc0201530:	873e                	mv	a4,a5
ffffffffc0201532:	bf8d                	j	ffffffffc02014a4 <default_free_pages+0x8c>
            base->property += p->property;
ffffffffc0201534:	ff872783          	lw	a5,-8(a4)
ffffffffc0201538:	56f5                	li	a3,-3
ffffffffc020153a:	9fad                	addw	a5,a5,a1
ffffffffc020153c:	c91c                	sw	a5,16(a0)
ffffffffc020153e:	ff070793          	addi	a5,a4,-16
ffffffffc0201542:	60d7b02f          	amoand.d	zero,a3,(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201546:	6314                	ld	a3,0(a4)
ffffffffc0201548:	671c                	ld	a5,8(a4)
}
ffffffffc020154a:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020154c:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc020154e:	e394                	sd	a3,0(a5)
ffffffffc0201550:	0141                	addi	sp,sp,16
ffffffffc0201552:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201554:	00001697          	auipc	a3,0x1
ffffffffc0201558:	64c68693          	addi	a3,a3,1612 # ffffffffc0202ba0 <etext+0xc34>
ffffffffc020155c:	00001617          	auipc	a2,0x1
ffffffffc0201560:	2e460613          	addi	a2,a2,740 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201564:	08300593          	li	a1,131
ffffffffc0201568:	00001517          	auipc	a0,0x1
ffffffffc020156c:	2f050513          	addi	a0,a0,752 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201570:	e19fe0ef          	jal	ffffffffc0200388 <__panic>
    assert(n > 0);
ffffffffc0201574:	00001697          	auipc	a3,0x1
ffffffffc0201578:	62468693          	addi	a3,a3,1572 # ffffffffc0202b98 <etext+0xc2c>
ffffffffc020157c:	00001617          	auipc	a2,0x1
ffffffffc0201580:	2c460613          	addi	a2,a2,708 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201584:	08000593          	li	a1,128
ffffffffc0201588:	00001517          	auipc	a0,0x1
ffffffffc020158c:	2d050513          	addi	a0,a0,720 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201590:	df9fe0ef          	jal	ffffffffc0200388 <__panic>

ffffffffc0201594 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201594:	cd41                	beqz	a0,ffffffffc020162c <default_alloc_pages+0x98>
    if (n > nr_free) {
ffffffffc0201596:	00006597          	auipc	a1,0x6
ffffffffc020159a:	aa25a583          	lw	a1,-1374(a1) # ffffffffc0207038 <free_area+0x10>
ffffffffc020159e:	86aa                	mv	a3,a0
ffffffffc02015a0:	02059793          	slli	a5,a1,0x20
ffffffffc02015a4:	9381                	srli	a5,a5,0x20
ffffffffc02015a6:	00a7ef63          	bltu	a5,a0,ffffffffc02015c4 <default_alloc_pages+0x30>
    list_entry_t *le = &free_list;
ffffffffc02015aa:	00006617          	auipc	a2,0x6
ffffffffc02015ae:	a7e60613          	addi	a2,a2,-1410 # ffffffffc0207028 <free_area>
ffffffffc02015b2:	87b2                	mv	a5,a2
ffffffffc02015b4:	a029                	j	ffffffffc02015be <default_alloc_pages+0x2a>
        if (p->property >= n) {
ffffffffc02015b6:	ff87e703          	lwu	a4,-8(a5)
ffffffffc02015ba:	00d77763          	bgeu	a4,a3,ffffffffc02015c8 <default_alloc_pages+0x34>
    return listelm->next;
ffffffffc02015be:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02015c0:	fec79be3          	bne	a5,a2,ffffffffc02015b6 <default_alloc_pages+0x22>
        return NULL;
ffffffffc02015c4:	4501                	li	a0,0
}
ffffffffc02015c6:	8082                	ret
        if (page->property > n) {
ffffffffc02015c8:	ff87a883          	lw	a7,-8(a5)
    return listelm->prev;
ffffffffc02015cc:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02015d0:	6798                	ld	a4,8(a5)
ffffffffc02015d2:	02089313          	slli	t1,a7,0x20
ffffffffc02015d6:	02035313          	srli	t1,t1,0x20
    prev->next = next;
ffffffffc02015da:	00e83423          	sd	a4,8(a6) # ff0008 <kern_entry-0xffffffffbf20fff8>
    next->prev = prev;
ffffffffc02015de:	01073023          	sd	a6,0(a4)
        struct Page *p = le2page(le, page_link);
ffffffffc02015e2:	fe878513          	addi	a0,a5,-24
        if (page->property > n) {
ffffffffc02015e6:	0266fc63          	bgeu	a3,t1,ffffffffc020161e <default_alloc_pages+0x8a>
            struct Page *p = page + n;
ffffffffc02015ea:	00269713          	slli	a4,a3,0x2
ffffffffc02015ee:	9736                	add	a4,a4,a3
ffffffffc02015f0:	070e                	slli	a4,a4,0x3
            p->property = page->property - n;
ffffffffc02015f2:	40d888bb          	subw	a7,a7,a3
            struct Page *p = page + n;
ffffffffc02015f6:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc02015f8:	01172823          	sw	a7,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02015fc:	00870313          	addi	t1,a4,8
ffffffffc0201600:	4889                	li	a7,2
ffffffffc0201602:	4113302f          	amoor.d	zero,a7,(t1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201606:	00883883          	ld	a7,8(a6)
            list_add(prev, &(p->page_link));
ffffffffc020160a:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc020160e:	0068b023          	sd	t1,0(a7)
ffffffffc0201612:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc0201616:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc020161a:	01073c23          	sd	a6,24(a4)
        nr_free -= n;
ffffffffc020161e:	9d95                	subw	a1,a1,a3
ffffffffc0201620:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201622:	5775                	li	a4,-3
ffffffffc0201624:	17c1                	addi	a5,a5,-16
ffffffffc0201626:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc020162a:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc020162c:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020162e:	00001697          	auipc	a3,0x1
ffffffffc0201632:	56a68693          	addi	a3,a3,1386 # ffffffffc0202b98 <etext+0xc2c>
ffffffffc0201636:	00001617          	auipc	a2,0x1
ffffffffc020163a:	20a60613          	addi	a2,a2,522 # ffffffffc0202840 <etext+0x8d4>
ffffffffc020163e:	06200593          	li	a1,98
ffffffffc0201642:	00001517          	auipc	a0,0x1
ffffffffc0201646:	21650513          	addi	a0,a0,534 # ffffffffc0202858 <etext+0x8ec>
default_alloc_pages(size_t n) {
ffffffffc020164a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020164c:	d3dfe0ef          	jal	ffffffffc0200388 <__panic>

ffffffffc0201650 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc0201650:	1141                	addi	sp,sp,-16
ffffffffc0201652:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201654:	c9f1                	beqz	a1,ffffffffc0201728 <default_init_memmap+0xd8>
    for (; p != base + n; p ++) {
ffffffffc0201656:	00259713          	slli	a4,a1,0x2
ffffffffc020165a:	972e                	add	a4,a4,a1
ffffffffc020165c:	070e                	slli	a4,a4,0x3
ffffffffc020165e:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201662:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc0201664:	cf11                	beqz	a4,ffffffffc0201680 <default_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201666:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0201668:	8b05                	andi	a4,a4,1
ffffffffc020166a:	cf59                	beqz	a4,ffffffffc0201708 <default_init_memmap+0xb8>
        p->flags = p->property = 0;
ffffffffc020166c:	0007a823          	sw	zero,16(a5)
ffffffffc0201670:	0007b423          	sd	zero,8(a5)
ffffffffc0201674:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201678:	02878793          	addi	a5,a5,40
ffffffffc020167c:	fed795e3          	bne	a5,a3,ffffffffc0201666 <default_init_memmap+0x16>
    base->property = n;
ffffffffc0201680:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201682:	4789                	li	a5,2
ffffffffc0201684:	00850713          	addi	a4,a0,8
ffffffffc0201688:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc020168c:	00006717          	auipc	a4,0x6
ffffffffc0201690:	9ac72703          	lw	a4,-1620(a4) # ffffffffc0207038 <free_area+0x10>
ffffffffc0201694:	00006697          	auipc	a3,0x6
ffffffffc0201698:	99468693          	addi	a3,a3,-1644 # ffffffffc0207028 <free_area>
    return list->next == list;
ffffffffc020169c:	669c                	ld	a5,8(a3)
ffffffffc020169e:	9f2d                	addw	a4,a4,a1
ffffffffc02016a0:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02016a2:	04d78663          	beq	a5,a3,ffffffffc02016ee <default_init_memmap+0x9e>
            struct Page* page = le2page(le, page_link);
ffffffffc02016a6:	fe878713          	addi	a4,a5,-24
ffffffffc02016aa:	4581                	li	a1,0
ffffffffc02016ac:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc02016b0:	00e56a63          	bltu	a0,a4,ffffffffc02016c4 <default_init_memmap+0x74>
    return listelm->next;
ffffffffc02016b4:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02016b6:	02d70263          	beq	a4,a3,ffffffffc02016da <default_init_memmap+0x8a>
    struct Page *p = base;
ffffffffc02016ba:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02016bc:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02016c0:	fee57ae3          	bgeu	a0,a4,ffffffffc02016b4 <default_init_memmap+0x64>
ffffffffc02016c4:	c199                	beqz	a1,ffffffffc02016ca <default_init_memmap+0x7a>
ffffffffc02016c6:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02016ca:	6398                	ld	a4,0(a5)
}
ffffffffc02016cc:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02016ce:	e390                	sd	a2,0(a5)
ffffffffc02016d0:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc02016d2:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc02016d4:	f11c                	sd	a5,32(a0)
ffffffffc02016d6:	0141                	addi	sp,sp,16
ffffffffc02016d8:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02016da:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02016dc:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02016de:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02016e0:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc02016e2:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc02016e4:	00d70e63          	beq	a4,a3,ffffffffc0201700 <default_init_memmap+0xb0>
ffffffffc02016e8:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc02016ea:	87ba                	mv	a5,a4
ffffffffc02016ec:	bfc1                	j	ffffffffc02016bc <default_init_memmap+0x6c>
}
ffffffffc02016ee:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc02016f0:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc02016f4:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02016f6:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc02016f8:	e398                	sd	a4,0(a5)
ffffffffc02016fa:	e798                	sd	a4,8(a5)
}
ffffffffc02016fc:	0141                	addi	sp,sp,16
ffffffffc02016fe:	8082                	ret
ffffffffc0201700:	60a2                	ld	ra,8(sp)
ffffffffc0201702:	e290                	sd	a2,0(a3)
ffffffffc0201704:	0141                	addi	sp,sp,16
ffffffffc0201706:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201708:	00001697          	auipc	a3,0x1
ffffffffc020170c:	4c068693          	addi	a3,a3,1216 # ffffffffc0202bc8 <etext+0xc5c>
ffffffffc0201710:	00001617          	auipc	a2,0x1
ffffffffc0201714:	13060613          	addi	a2,a2,304 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201718:	04900593          	li	a1,73
ffffffffc020171c:	00001517          	auipc	a0,0x1
ffffffffc0201720:	13c50513          	addi	a0,a0,316 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201724:	c65fe0ef          	jal	ffffffffc0200388 <__panic>
    assert(n > 0);
ffffffffc0201728:	00001697          	auipc	a3,0x1
ffffffffc020172c:	47068693          	addi	a3,a3,1136 # ffffffffc0202b98 <etext+0xc2c>
ffffffffc0201730:	00001617          	auipc	a2,0x1
ffffffffc0201734:	11060613          	addi	a2,a2,272 # ffffffffc0202840 <etext+0x8d4>
ffffffffc0201738:	04600593          	li	a1,70
ffffffffc020173c:	00001517          	auipc	a0,0x1
ffffffffc0201740:	11c50513          	addi	a0,a0,284 # ffffffffc0202858 <etext+0x8ec>
ffffffffc0201744:	c45fe0ef          	jal	ffffffffc0200388 <__panic>

ffffffffc0201748 <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201748:	100027f3          	csrr	a5,sstatus
ffffffffc020174c:	8b89                	andi	a5,a5,2
ffffffffc020174e:	e799                	bnez	a5,ffffffffc020175c <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201750:	00006797          	auipc	a5,0x6
ffffffffc0201754:	d207b783          	ld	a5,-736(a5) # ffffffffc0207470 <pmm_manager>
ffffffffc0201758:	6f9c                	ld	a5,24(a5)
ffffffffc020175a:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc020175c:	1101                	addi	sp,sp,-32
ffffffffc020175e:	ec06                	sd	ra,24(sp)
ffffffffc0201760:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201762:	820ff0ef          	jal	ffffffffc0200782 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201766:	00006797          	auipc	a5,0x6
ffffffffc020176a:	d0a7b783          	ld	a5,-758(a5) # ffffffffc0207470 <pmm_manager>
ffffffffc020176e:	6522                	ld	a0,8(sp)
ffffffffc0201770:	6f9c                	ld	a5,24(a5)
ffffffffc0201772:	9782                	jalr	a5
ffffffffc0201774:	e42a                	sd	a0,8(sp)
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc0201776:	806ff0ef          	jal	ffffffffc020077c <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc020177a:	60e2                	ld	ra,24(sp)
ffffffffc020177c:	6522                	ld	a0,8(sp)
ffffffffc020177e:	6105                	addi	sp,sp,32
ffffffffc0201780:	8082                	ret

ffffffffc0201782 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201782:	100027f3          	csrr	a5,sstatus
ffffffffc0201786:	8b89                	andi	a5,a5,2
ffffffffc0201788:	e799                	bnez	a5,ffffffffc0201796 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc020178a:	00006797          	auipc	a5,0x6
ffffffffc020178e:	ce67b783          	ld	a5,-794(a5) # ffffffffc0207470 <pmm_manager>
ffffffffc0201792:	739c                	ld	a5,32(a5)
ffffffffc0201794:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0201796:	1101                	addi	sp,sp,-32
ffffffffc0201798:	ec06                	sd	ra,24(sp)
ffffffffc020179a:	e42e                	sd	a1,8(sp)
ffffffffc020179c:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc020179e:	fe5fe0ef          	jal	ffffffffc0200782 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02017a2:	00006797          	auipc	a5,0x6
ffffffffc02017a6:	cce7b783          	ld	a5,-818(a5) # ffffffffc0207470 <pmm_manager>
ffffffffc02017aa:	65a2                	ld	a1,8(sp)
ffffffffc02017ac:	6502                	ld	a0,0(sp)
ffffffffc02017ae:	739c                	ld	a5,32(a5)
ffffffffc02017b0:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc02017b2:	60e2                	ld	ra,24(sp)
ffffffffc02017b4:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02017b6:	fc7fe06f          	j	ffffffffc020077c <intr_enable>

ffffffffc02017ba <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02017ba:	100027f3          	csrr	a5,sstatus
ffffffffc02017be:	8b89                	andi	a5,a5,2
ffffffffc02017c0:	e799                	bnez	a5,ffffffffc02017ce <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc02017c2:	00006797          	auipc	a5,0x6
ffffffffc02017c6:	cae7b783          	ld	a5,-850(a5) # ffffffffc0207470 <pmm_manager>
ffffffffc02017ca:	779c                	ld	a5,40(a5)
ffffffffc02017cc:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc02017ce:	1101                	addi	sp,sp,-32
ffffffffc02017d0:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02017d2:	fb1fe0ef          	jal	ffffffffc0200782 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02017d6:	00006797          	auipc	a5,0x6
ffffffffc02017da:	c9a7b783          	ld	a5,-870(a5) # ffffffffc0207470 <pmm_manager>
ffffffffc02017de:	779c                	ld	a5,40(a5)
ffffffffc02017e0:	9782                	jalr	a5
ffffffffc02017e2:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02017e4:	f99fe0ef          	jal	ffffffffc020077c <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc02017e8:	60e2                	ld	ra,24(sp)
ffffffffc02017ea:	6522                	ld	a0,8(sp)
ffffffffc02017ec:	6105                	addi	sp,sp,32
ffffffffc02017ee:	8082                	ret

ffffffffc02017f0 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc02017f0:	00001797          	auipc	a5,0x1
ffffffffc02017f4:	67878793          	addi	a5,a5,1656 # ffffffffc0202e68 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02017f8:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc02017fa:	7139                	addi	sp,sp,-64
ffffffffc02017fc:	fc06                	sd	ra,56(sp)
ffffffffc02017fe:	f822                	sd	s0,48(sp)
ffffffffc0201800:	f426                	sd	s1,40(sp)
ffffffffc0201802:	ec4e                	sd	s3,24(sp)
ffffffffc0201804:	f04a                	sd	s2,32(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0201806:	00006417          	auipc	s0,0x6
ffffffffc020180a:	c6a40413          	addi	s0,s0,-918 # ffffffffc0207470 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020180e:	00001517          	auipc	a0,0x1
ffffffffc0201812:	3e250513          	addi	a0,a0,994 # ffffffffc0202bf0 <etext+0xc84>
    pmm_manager = &default_pmm_manager;
ffffffffc0201816:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201818:	8bffe0ef          	jal	ffffffffc02000d6 <cprintf>
    pmm_manager->init();
ffffffffc020181c:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020181e:	00006497          	auipc	s1,0x6
ffffffffc0201822:	c6a48493          	addi	s1,s1,-918 # ffffffffc0207488 <va_pa_offset>
    pmm_manager->init();
ffffffffc0201826:	679c                	ld	a5,8(a5)
ffffffffc0201828:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020182a:	57f5                	li	a5,-3
ffffffffc020182c:	07fa                	slli	a5,a5,0x1e
ffffffffc020182e:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc0201830:	f39fe0ef          	jal	ffffffffc0200768 <get_memory_base>
ffffffffc0201834:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0201836:	f3dfe0ef          	jal	ffffffffc0200772 <get_memory_size>
    if (mem_size == 0) {
ffffffffc020183a:	16050063          	beqz	a0,ffffffffc020199a <pmm_init+0x1aa>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc020183e:	00a98933          	add	s2,s3,a0
ffffffffc0201842:	e42a                	sd	a0,8(sp)
    cprintf("physcial memory map:\n");
ffffffffc0201844:	00001517          	auipc	a0,0x1
ffffffffc0201848:	3f450513          	addi	a0,a0,1012 # ffffffffc0202c38 <etext+0xccc>
ffffffffc020184c:	88bfe0ef          	jal	ffffffffc02000d6 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0201850:	65a2                	ld	a1,8(sp)
ffffffffc0201852:	864e                	mv	a2,s3
ffffffffc0201854:	fff90693          	addi	a3,s2,-1
ffffffffc0201858:	00001517          	auipc	a0,0x1
ffffffffc020185c:	3f850513          	addi	a0,a0,1016 # ffffffffc0202c50 <etext+0xce4>
ffffffffc0201860:	877fe0ef          	jal	ffffffffc02000d6 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc0201864:	c80007b7          	lui	a5,0xc8000
ffffffffc0201868:	864a                	mv	a2,s2
ffffffffc020186a:	0d27e563          	bltu	a5,s2,ffffffffc0201934 <pmm_init+0x144>
ffffffffc020186e:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201870:	00007697          	auipc	a3,0x7
ffffffffc0201874:	c3768693          	addi	a3,a3,-969 # ffffffffc02084a7 <end+0xfff>
ffffffffc0201878:	8efd                	and	a3,a3,a5
    npage = maxpa / PGSIZE;
ffffffffc020187a:	8231                	srli	a2,a2,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020187c:	00006817          	auipc	a6,0x6
ffffffffc0201880:	c1c80813          	addi	a6,a6,-996 # ffffffffc0207498 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0201884:	00006517          	auipc	a0,0x6
ffffffffc0201888:	c0c50513          	addi	a0,a0,-1012 # ffffffffc0207490 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020188c:	00d83023          	sd	a3,0(a6)
    npage = maxpa / PGSIZE;
ffffffffc0201890:	e110                	sd	a2,0(a0)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201892:	00080737          	lui	a4,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201896:	87b6                	mv	a5,a3
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201898:	02e60a63          	beq	a2,a4,ffffffffc02018cc <pmm_init+0xdc>
ffffffffc020189c:	4701                	li	a4,0
ffffffffc020189e:	4781                	li	a5,0
ffffffffc02018a0:	4305                	li	t1,1
ffffffffc02018a2:	fff808b7          	lui	a7,0xfff80
        SetPageReserved(pages + i);
ffffffffc02018a6:	96ba                	add	a3,a3,a4
ffffffffc02018a8:	06a1                	addi	a3,a3,8
ffffffffc02018aa:	4066b02f          	amoor.d	zero,t1,(a3)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02018ae:	6110                	ld	a2,0(a0)
ffffffffc02018b0:	0785                	addi	a5,a5,1 # fffffffffffff001 <end+0x3fdf7b59>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02018b2:	00083683          	ld	a3,0(a6)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02018b6:	011605b3          	add	a1,a2,a7
ffffffffc02018ba:	02870713          	addi	a4,a4,40 # 80028 <kern_entry-0xffffffffc017ffd8>
ffffffffc02018be:	feb7e4e3          	bltu	a5,a1,ffffffffc02018a6 <pmm_init+0xb6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02018c2:	00259793          	slli	a5,a1,0x2
ffffffffc02018c6:	97ae                	add	a5,a5,a1
ffffffffc02018c8:	078e                	slli	a5,a5,0x3
ffffffffc02018ca:	97b6                	add	a5,a5,a3
ffffffffc02018cc:	c0200737          	lui	a4,0xc0200
ffffffffc02018d0:	0ae7e863          	bltu	a5,a4,ffffffffc0201980 <pmm_init+0x190>
ffffffffc02018d4:	608c                	ld	a1,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc02018d6:	777d                	lui	a4,0xfffff
ffffffffc02018d8:	00e97933          	and	s2,s2,a4
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02018dc:	8f8d                	sub	a5,a5,a1
    if (freemem < mem_end) {
ffffffffc02018de:	0527ed63          	bltu	a5,s2,ffffffffc0201938 <pmm_init+0x148>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc02018e2:	601c                	ld	a5,0(s0)
ffffffffc02018e4:	7b9c                	ld	a5,48(a5)
ffffffffc02018e6:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02018e8:	00001517          	auipc	a0,0x1
ffffffffc02018ec:	3f050513          	addi	a0,a0,1008 # ffffffffc0202cd8 <etext+0xd6c>
ffffffffc02018f0:	fe6fe0ef          	jal	ffffffffc02000d6 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc02018f4:	00004597          	auipc	a1,0x4
ffffffffc02018f8:	70c58593          	addi	a1,a1,1804 # ffffffffc0206000 <boot_page_table_sv39>
ffffffffc02018fc:	00006797          	auipc	a5,0x6
ffffffffc0201900:	b8b7b223          	sd	a1,-1148(a5) # ffffffffc0207480 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201904:	c02007b7          	lui	a5,0xc0200
ffffffffc0201908:	0af5e563          	bltu	a1,a5,ffffffffc02019b2 <pmm_init+0x1c2>
ffffffffc020190c:	609c                	ld	a5,0(s1)
}
ffffffffc020190e:	7442                	ld	s0,48(sp)
ffffffffc0201910:	70e2                	ld	ra,56(sp)
ffffffffc0201912:	74a2                	ld	s1,40(sp)
ffffffffc0201914:	7902                	ld	s2,32(sp)
ffffffffc0201916:	69e2                	ld	s3,24(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0201918:	40f586b3          	sub	a3,a1,a5
ffffffffc020191c:	00006797          	auipc	a5,0x6
ffffffffc0201920:	b4d7be23          	sd	a3,-1188(a5) # ffffffffc0207478 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201924:	00001517          	auipc	a0,0x1
ffffffffc0201928:	3d450513          	addi	a0,a0,980 # ffffffffc0202cf8 <etext+0xd8c>
ffffffffc020192c:	8636                	mv	a2,a3
}
ffffffffc020192e:	6121                	addi	sp,sp,64
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201930:	fa6fe06f          	j	ffffffffc02000d6 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc0201934:	863e                	mv	a2,a5
ffffffffc0201936:	bf25                	j	ffffffffc020186e <pmm_init+0x7e>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0201938:	6585                	lui	a1,0x1
ffffffffc020193a:	15fd                	addi	a1,a1,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc020193c:	97ae                	add	a5,a5,a1
ffffffffc020193e:	8ff9                	and	a5,a5,a4
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0201940:	00c7d713          	srli	a4,a5,0xc
ffffffffc0201944:	02c77263          	bgeu	a4,a2,ffffffffc0201968 <pmm_init+0x178>
    pmm_manager->init_memmap(base, n);
ffffffffc0201948:	6010                	ld	a2,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc020194a:	fff805b7          	lui	a1,0xfff80
ffffffffc020194e:	972e                	add	a4,a4,a1
ffffffffc0201950:	00271513          	slli	a0,a4,0x2
ffffffffc0201954:	953a                	add	a0,a0,a4
ffffffffc0201956:	6a18                	ld	a4,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0201958:	40f90933          	sub	s2,s2,a5
ffffffffc020195c:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc020195e:	00c95593          	srli	a1,s2,0xc
ffffffffc0201962:	9536                	add	a0,a0,a3
ffffffffc0201964:	9702                	jalr	a4
}
ffffffffc0201966:	bfb5                	j	ffffffffc02018e2 <pmm_init+0xf2>
        panic("pa2page called with invalid pa");
ffffffffc0201968:	00001617          	auipc	a2,0x1
ffffffffc020196c:	34060613          	addi	a2,a2,832 # ffffffffc0202ca8 <etext+0xd3c>
ffffffffc0201970:	06b00593          	li	a1,107
ffffffffc0201974:	00001517          	auipc	a0,0x1
ffffffffc0201978:	35450513          	addi	a0,a0,852 # ffffffffc0202cc8 <etext+0xd5c>
ffffffffc020197c:	a0dfe0ef          	jal	ffffffffc0200388 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201980:	86be                	mv	a3,a5
ffffffffc0201982:	00001617          	auipc	a2,0x1
ffffffffc0201986:	2fe60613          	addi	a2,a2,766 # ffffffffc0202c80 <etext+0xd14>
ffffffffc020198a:	07100593          	li	a1,113
ffffffffc020198e:	00001517          	auipc	a0,0x1
ffffffffc0201992:	29a50513          	addi	a0,a0,666 # ffffffffc0202c28 <etext+0xcbc>
ffffffffc0201996:	9f3fe0ef          	jal	ffffffffc0200388 <__panic>
        panic("DTB memory info not available");
ffffffffc020199a:	00001617          	auipc	a2,0x1
ffffffffc020199e:	26e60613          	addi	a2,a2,622 # ffffffffc0202c08 <etext+0xc9c>
ffffffffc02019a2:	05a00593          	li	a1,90
ffffffffc02019a6:	00001517          	auipc	a0,0x1
ffffffffc02019aa:	28250513          	addi	a0,a0,642 # ffffffffc0202c28 <etext+0xcbc>
ffffffffc02019ae:	9dbfe0ef          	jal	ffffffffc0200388 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc02019b2:	86ae                	mv	a3,a1
ffffffffc02019b4:	00001617          	auipc	a2,0x1
ffffffffc02019b8:	2cc60613          	addi	a2,a2,716 # ffffffffc0202c80 <etext+0xd14>
ffffffffc02019bc:	08c00593          	li	a1,140
ffffffffc02019c0:	00001517          	auipc	a0,0x1
ffffffffc02019c4:	26850513          	addi	a0,a0,616 # ffffffffc0202c28 <etext+0xcbc>
ffffffffc02019c8:	9c1fe0ef          	jal	ffffffffc0200388 <__panic>

ffffffffc02019cc <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02019cc:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02019ce:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02019d2:	f022                	sd	s0,32(sp)
ffffffffc02019d4:	ec26                	sd	s1,24(sp)
ffffffffc02019d6:	e84a                	sd	s2,16(sp)
ffffffffc02019d8:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02019da:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02019de:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc02019e0:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02019e4:	fff7041b          	addiw	s0,a4,-1 # ffffffffffffefff <end+0x3fdf7b57>
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02019e8:	84aa                	mv	s1,a0
ffffffffc02019ea:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc02019ec:	03067d63          	bgeu	a2,a6,ffffffffc0201a26 <printnum+0x5a>
ffffffffc02019f0:	e44e                	sd	s3,8(sp)
ffffffffc02019f2:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02019f4:	4785                	li	a5,1
ffffffffc02019f6:	00e7d763          	bge	a5,a4,ffffffffc0201a04 <printnum+0x38>
            putch(padc, putdat);
ffffffffc02019fa:	85ca                	mv	a1,s2
ffffffffc02019fc:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc02019fe:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201a00:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0201a02:	fc65                	bnez	s0,ffffffffc02019fa <printnum+0x2e>
ffffffffc0201a04:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a06:	00001797          	auipc	a5,0x1
ffffffffc0201a0a:	33278793          	addi	a5,a5,818 # ffffffffc0202d38 <etext+0xdcc>
ffffffffc0201a0e:	97d2                	add	a5,a5,s4
}
ffffffffc0201a10:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a12:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0201a16:	70a2                	ld	ra,40(sp)
ffffffffc0201a18:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a1a:	85ca                	mv	a1,s2
ffffffffc0201a1c:	87a6                	mv	a5,s1
}
ffffffffc0201a1e:	6942                	ld	s2,16(sp)
ffffffffc0201a20:	64e2                	ld	s1,24(sp)
ffffffffc0201a22:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a24:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0201a26:	03065633          	divu	a2,a2,a6
ffffffffc0201a2a:	8722                	mv	a4,s0
ffffffffc0201a2c:	fa1ff0ef          	jal	ffffffffc02019cc <printnum>
ffffffffc0201a30:	bfd9                	j	ffffffffc0201a06 <printnum+0x3a>

ffffffffc0201a32 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201a32:	7119                	addi	sp,sp,-128
ffffffffc0201a34:	f4a6                	sd	s1,104(sp)
ffffffffc0201a36:	f0ca                	sd	s2,96(sp)
ffffffffc0201a38:	ecce                	sd	s3,88(sp)
ffffffffc0201a3a:	e8d2                	sd	s4,80(sp)
ffffffffc0201a3c:	e4d6                	sd	s5,72(sp)
ffffffffc0201a3e:	e0da                	sd	s6,64(sp)
ffffffffc0201a40:	f862                	sd	s8,48(sp)
ffffffffc0201a42:	fc86                	sd	ra,120(sp)
ffffffffc0201a44:	f8a2                	sd	s0,112(sp)
ffffffffc0201a46:	fc5e                	sd	s7,56(sp)
ffffffffc0201a48:	f466                	sd	s9,40(sp)
ffffffffc0201a4a:	f06a                	sd	s10,32(sp)
ffffffffc0201a4c:	ec6e                	sd	s11,24(sp)
ffffffffc0201a4e:	84aa                	mv	s1,a0
ffffffffc0201a50:	8c32                	mv	s8,a2
ffffffffc0201a52:	8a36                	mv	s4,a3
ffffffffc0201a54:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201a56:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a5a:	05500b13          	li	s6,85
ffffffffc0201a5e:	00001a97          	auipc	s5,0x1
ffffffffc0201a62:	442a8a93          	addi	s5,s5,1090 # ffffffffc0202ea0 <default_pmm_manager+0x38>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201a66:	000c4503          	lbu	a0,0(s8)
ffffffffc0201a6a:	001c0413          	addi	s0,s8,1
ffffffffc0201a6e:	01350a63          	beq	a0,s3,ffffffffc0201a82 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0201a72:	cd0d                	beqz	a0,ffffffffc0201aac <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0201a74:	85ca                	mv	a1,s2
ffffffffc0201a76:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201a78:	00044503          	lbu	a0,0(s0)
ffffffffc0201a7c:	0405                	addi	s0,s0,1
ffffffffc0201a7e:	ff351ae3          	bne	a0,s3,ffffffffc0201a72 <vprintfmt+0x40>
        width = precision = -1;
ffffffffc0201a82:	5cfd                	li	s9,-1
ffffffffc0201a84:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc0201a86:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc0201a8a:	4b81                	li	s7,0
ffffffffc0201a8c:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a8e:	00044683          	lbu	a3,0(s0)
ffffffffc0201a92:	00140c13          	addi	s8,s0,1
ffffffffc0201a96:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0201a9a:	0ff5f593          	zext.b	a1,a1
ffffffffc0201a9e:	02bb6663          	bltu	s6,a1,ffffffffc0201aca <vprintfmt+0x98>
ffffffffc0201aa2:	058a                	slli	a1,a1,0x2
ffffffffc0201aa4:	95d6                	add	a1,a1,s5
ffffffffc0201aa6:	4198                	lw	a4,0(a1)
ffffffffc0201aa8:	9756                	add	a4,a4,s5
ffffffffc0201aaa:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0201aac:	70e6                	ld	ra,120(sp)
ffffffffc0201aae:	7446                	ld	s0,112(sp)
ffffffffc0201ab0:	74a6                	ld	s1,104(sp)
ffffffffc0201ab2:	7906                	ld	s2,96(sp)
ffffffffc0201ab4:	69e6                	ld	s3,88(sp)
ffffffffc0201ab6:	6a46                	ld	s4,80(sp)
ffffffffc0201ab8:	6aa6                	ld	s5,72(sp)
ffffffffc0201aba:	6b06                	ld	s6,64(sp)
ffffffffc0201abc:	7be2                	ld	s7,56(sp)
ffffffffc0201abe:	7c42                	ld	s8,48(sp)
ffffffffc0201ac0:	7ca2                	ld	s9,40(sp)
ffffffffc0201ac2:	7d02                	ld	s10,32(sp)
ffffffffc0201ac4:	6de2                	ld	s11,24(sp)
ffffffffc0201ac6:	6109                	addi	sp,sp,128
ffffffffc0201ac8:	8082                	ret
            putch('%', putdat);
ffffffffc0201aca:	85ca                	mv	a1,s2
ffffffffc0201acc:	02500513          	li	a0,37
ffffffffc0201ad0:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201ad2:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201ad6:	02500713          	li	a4,37
ffffffffc0201ada:	8c22                	mv	s8,s0
ffffffffc0201adc:	f8e785e3          	beq	a5,a4,ffffffffc0201a66 <vprintfmt+0x34>
ffffffffc0201ae0:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0201ae4:	1c7d                	addi	s8,s8,-1
ffffffffc0201ae6:	fee79de3          	bne	a5,a4,ffffffffc0201ae0 <vprintfmt+0xae>
ffffffffc0201aea:	bfb5                	j	ffffffffc0201a66 <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0201aec:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0201af0:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc0201af2:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc0201af6:	fd06071b          	addiw	a4,a2,-48
ffffffffc0201afa:	24e56a63          	bltu	a0,a4,ffffffffc0201d4e <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc0201afe:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b00:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc0201b02:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc0201b06:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201b0a:	0197073b          	addw	a4,a4,s9
ffffffffc0201b0e:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201b12:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201b14:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201b18:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201b1a:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0201b1e:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc0201b22:	feb570e3          	bgeu	a0,a1,ffffffffc0201b02 <vprintfmt+0xd0>
            if (width < 0)
ffffffffc0201b26:	f60d54e3          	bgez	s10,ffffffffc0201a8e <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0201b2a:	8d66                	mv	s10,s9
ffffffffc0201b2c:	5cfd                	li	s9,-1
ffffffffc0201b2e:	b785                	j	ffffffffc0201a8e <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b30:	8db6                	mv	s11,a3
ffffffffc0201b32:	8462                	mv	s0,s8
ffffffffc0201b34:	bfa9                	j	ffffffffc0201a8e <vprintfmt+0x5c>
ffffffffc0201b36:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0201b38:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0201b3a:	bf91                	j	ffffffffc0201a8e <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0201b3c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201b3e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201b42:	00f74463          	blt	a4,a5,ffffffffc0201b4a <vprintfmt+0x118>
    else if (lflag) {
ffffffffc0201b46:	1a078763          	beqz	a5,ffffffffc0201cf4 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0201b4a:	000a3603          	ld	a2,0(s4)
ffffffffc0201b4e:	46c1                	li	a3,16
ffffffffc0201b50:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201b52:	000d879b          	sext.w	a5,s11
ffffffffc0201b56:	876a                	mv	a4,s10
ffffffffc0201b58:	85ca                	mv	a1,s2
ffffffffc0201b5a:	8526                	mv	a0,s1
ffffffffc0201b5c:	e71ff0ef          	jal	ffffffffc02019cc <printnum>
            break;
ffffffffc0201b60:	b719                	j	ffffffffc0201a66 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0201b62:	000a2503          	lw	a0,0(s4)
ffffffffc0201b66:	85ca                	mv	a1,s2
ffffffffc0201b68:	0a21                	addi	s4,s4,8
ffffffffc0201b6a:	9482                	jalr	s1
            break;
ffffffffc0201b6c:	bded                	j	ffffffffc0201a66 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0201b6e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201b70:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201b74:	00f74463          	blt	a4,a5,ffffffffc0201b7c <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0201b78:	16078963          	beqz	a5,ffffffffc0201cea <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc0201b7c:	000a3603          	ld	a2,0(s4)
ffffffffc0201b80:	46a9                	li	a3,10
ffffffffc0201b82:	8a2e                	mv	s4,a1
ffffffffc0201b84:	b7f9                	j	ffffffffc0201b52 <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc0201b86:	85ca                	mv	a1,s2
ffffffffc0201b88:	03000513          	li	a0,48
ffffffffc0201b8c:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc0201b8e:	85ca                	mv	a1,s2
ffffffffc0201b90:	07800513          	li	a0,120
ffffffffc0201b94:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201b96:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc0201b9a:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201b9c:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0201b9e:	bf55                	j	ffffffffc0201b52 <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc0201ba0:	85ca                	mv	a1,s2
ffffffffc0201ba2:	02500513          	li	a0,37
ffffffffc0201ba6:	9482                	jalr	s1
            break;
ffffffffc0201ba8:	bd7d                	j	ffffffffc0201a66 <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc0201baa:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201bae:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc0201bb0:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc0201bb2:	bf95                	j	ffffffffc0201b26 <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc0201bb4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201bb6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201bba:	00f74463          	blt	a4,a5,ffffffffc0201bc2 <vprintfmt+0x190>
    else if (lflag) {
ffffffffc0201bbe:	12078163          	beqz	a5,ffffffffc0201ce0 <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc0201bc2:	000a3603          	ld	a2,0(s4)
ffffffffc0201bc6:	46a1                	li	a3,8
ffffffffc0201bc8:	8a2e                	mv	s4,a1
ffffffffc0201bca:	b761                	j	ffffffffc0201b52 <vprintfmt+0x120>
            if (width < 0)
ffffffffc0201bcc:	876a                	mv	a4,s10
ffffffffc0201bce:	000d5363          	bgez	s10,ffffffffc0201bd4 <vprintfmt+0x1a2>
ffffffffc0201bd2:	4701                	li	a4,0
ffffffffc0201bd4:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201bd8:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0201bda:	bd55                	j	ffffffffc0201a8e <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc0201bdc:	000d841b          	sext.w	s0,s11
ffffffffc0201be0:	fd340793          	addi	a5,s0,-45
ffffffffc0201be4:	00f037b3          	snez	a5,a5
ffffffffc0201be8:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201bec:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc0201bf0:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201bf2:	008a0793          	addi	a5,s4,8
ffffffffc0201bf6:	e43e                	sd	a5,8(sp)
ffffffffc0201bf8:	100d8c63          	beqz	s11,ffffffffc0201d10 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0201bfc:	12071363          	bnez	a4,ffffffffc0201d22 <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c00:	000dc783          	lbu	a5,0(s11)
ffffffffc0201c04:	0007851b          	sext.w	a0,a5
ffffffffc0201c08:	c78d                	beqz	a5,ffffffffc0201c32 <vprintfmt+0x200>
ffffffffc0201c0a:	0d85                	addi	s11,s11,1
ffffffffc0201c0c:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201c0e:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c12:	000cc563          	bltz	s9,ffffffffc0201c1c <vprintfmt+0x1ea>
ffffffffc0201c16:	3cfd                	addiw	s9,s9,-1
ffffffffc0201c18:	008c8d63          	beq	s9,s0,ffffffffc0201c32 <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201c1c:	020b9663          	bnez	s7,ffffffffc0201c48 <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc0201c20:	85ca                	mv	a1,s2
ffffffffc0201c22:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c24:	000dc783          	lbu	a5,0(s11)
ffffffffc0201c28:	0d85                	addi	s11,s11,1
ffffffffc0201c2a:	3d7d                	addiw	s10,s10,-1
ffffffffc0201c2c:	0007851b          	sext.w	a0,a5
ffffffffc0201c30:	f3ed                	bnez	a5,ffffffffc0201c12 <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc0201c32:	01a05963          	blez	s10,ffffffffc0201c44 <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc0201c36:	85ca                	mv	a1,s2
ffffffffc0201c38:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0201c3c:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc0201c3e:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc0201c40:	fe0d1be3          	bnez	s10,ffffffffc0201c36 <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201c44:	6a22                	ld	s4,8(sp)
ffffffffc0201c46:	b505                	j	ffffffffc0201a66 <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201c48:	3781                	addiw	a5,a5,-32
ffffffffc0201c4a:	fcfa7be3          	bgeu	s4,a5,ffffffffc0201c20 <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc0201c4e:	03f00513          	li	a0,63
ffffffffc0201c52:	85ca                	mv	a1,s2
ffffffffc0201c54:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c56:	000dc783          	lbu	a5,0(s11)
ffffffffc0201c5a:	0d85                	addi	s11,s11,1
ffffffffc0201c5c:	3d7d                	addiw	s10,s10,-1
ffffffffc0201c5e:	0007851b          	sext.w	a0,a5
ffffffffc0201c62:	dbe1                	beqz	a5,ffffffffc0201c32 <vprintfmt+0x200>
ffffffffc0201c64:	fa0cd9e3          	bgez	s9,ffffffffc0201c16 <vprintfmt+0x1e4>
ffffffffc0201c68:	b7c5                	j	ffffffffc0201c48 <vprintfmt+0x216>
            if (err < 0) {
ffffffffc0201c6a:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201c6e:	4619                	li	a2,6
            err = va_arg(ap, int);
ffffffffc0201c70:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0201c72:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0201c76:	8fb9                	xor	a5,a5,a4
ffffffffc0201c78:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201c7c:	02d64563          	blt	a2,a3,ffffffffc0201ca6 <vprintfmt+0x274>
ffffffffc0201c80:	00001797          	auipc	a5,0x1
ffffffffc0201c84:	37878793          	addi	a5,a5,888 # ffffffffc0202ff8 <error_string>
ffffffffc0201c88:	00369713          	slli	a4,a3,0x3
ffffffffc0201c8c:	97ba                	add	a5,a5,a4
ffffffffc0201c8e:	639c                	ld	a5,0(a5)
ffffffffc0201c90:	cb99                	beqz	a5,ffffffffc0201ca6 <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc0201c92:	86be                	mv	a3,a5
ffffffffc0201c94:	00001617          	auipc	a2,0x1
ffffffffc0201c98:	0d460613          	addi	a2,a2,212 # ffffffffc0202d68 <etext+0xdfc>
ffffffffc0201c9c:	85ca                	mv	a1,s2
ffffffffc0201c9e:	8526                	mv	a0,s1
ffffffffc0201ca0:	0d8000ef          	jal	ffffffffc0201d78 <printfmt>
ffffffffc0201ca4:	b3c9                	j	ffffffffc0201a66 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201ca6:	00001617          	auipc	a2,0x1
ffffffffc0201caa:	0b260613          	addi	a2,a2,178 # ffffffffc0202d58 <etext+0xdec>
ffffffffc0201cae:	85ca                	mv	a1,s2
ffffffffc0201cb0:	8526                	mv	a0,s1
ffffffffc0201cb2:	0c6000ef          	jal	ffffffffc0201d78 <printfmt>
ffffffffc0201cb6:	bb45                	j	ffffffffc0201a66 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0201cb8:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201cba:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc0201cbe:	00f74363          	blt	a4,a5,ffffffffc0201cc4 <vprintfmt+0x292>
    else if (lflag) {
ffffffffc0201cc2:	cf81                	beqz	a5,ffffffffc0201cda <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc0201cc4:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201cc8:	02044b63          	bltz	s0,ffffffffc0201cfe <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc0201ccc:	8622                	mv	a2,s0
ffffffffc0201cce:	8a5e                	mv	s4,s7
ffffffffc0201cd0:	46a9                	li	a3,10
ffffffffc0201cd2:	b541                	j	ffffffffc0201b52 <vprintfmt+0x120>
            lflag ++;
ffffffffc0201cd4:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201cd6:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0201cd8:	bb5d                	j	ffffffffc0201a8e <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc0201cda:	000a2403          	lw	s0,0(s4)
ffffffffc0201cde:	b7ed                	j	ffffffffc0201cc8 <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc0201ce0:	000a6603          	lwu	a2,0(s4)
ffffffffc0201ce4:	46a1                	li	a3,8
ffffffffc0201ce6:	8a2e                	mv	s4,a1
ffffffffc0201ce8:	b5ad                	j	ffffffffc0201b52 <vprintfmt+0x120>
ffffffffc0201cea:	000a6603          	lwu	a2,0(s4)
ffffffffc0201cee:	46a9                	li	a3,10
ffffffffc0201cf0:	8a2e                	mv	s4,a1
ffffffffc0201cf2:	b585                	j	ffffffffc0201b52 <vprintfmt+0x120>
ffffffffc0201cf4:	000a6603          	lwu	a2,0(s4)
ffffffffc0201cf8:	46c1                	li	a3,16
ffffffffc0201cfa:	8a2e                	mv	s4,a1
ffffffffc0201cfc:	bd99                	j	ffffffffc0201b52 <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc0201cfe:	85ca                	mv	a1,s2
ffffffffc0201d00:	02d00513          	li	a0,45
ffffffffc0201d04:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc0201d06:	40800633          	neg	a2,s0
ffffffffc0201d0a:	8a5e                	mv	s4,s7
ffffffffc0201d0c:	46a9                	li	a3,10
ffffffffc0201d0e:	b591                	j	ffffffffc0201b52 <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc0201d10:	e329                	bnez	a4,ffffffffc0201d52 <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d12:	02800793          	li	a5,40
ffffffffc0201d16:	853e                	mv	a0,a5
ffffffffc0201d18:	00001d97          	auipc	s11,0x1
ffffffffc0201d1c:	039d8d93          	addi	s11,s11,57 # ffffffffc0202d51 <etext+0xde5>
ffffffffc0201d20:	b5f5                	j	ffffffffc0201c0c <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d22:	85e6                	mv	a1,s9
ffffffffc0201d24:	856e                	mv	a0,s11
ffffffffc0201d26:	1aa000ef          	jal	ffffffffc0201ed0 <strnlen>
ffffffffc0201d2a:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0201d2e:	01a05863          	blez	s10,ffffffffc0201d3e <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc0201d32:	85ca                	mv	a1,s2
ffffffffc0201d34:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d36:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc0201d38:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d3a:	fe0d1ce3          	bnez	s10,ffffffffc0201d32 <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d3e:	000dc783          	lbu	a5,0(s11)
ffffffffc0201d42:	0007851b          	sext.w	a0,a5
ffffffffc0201d46:	ec0792e3          	bnez	a5,ffffffffc0201c0a <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201d4a:	6a22                	ld	s4,8(sp)
ffffffffc0201d4c:	bb29                	j	ffffffffc0201a66 <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201d4e:	8462                	mv	s0,s8
ffffffffc0201d50:	bbd9                	j	ffffffffc0201b26 <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d52:	85e6                	mv	a1,s9
ffffffffc0201d54:	00001517          	auipc	a0,0x1
ffffffffc0201d58:	ffc50513          	addi	a0,a0,-4 # ffffffffc0202d50 <etext+0xde4>
ffffffffc0201d5c:	174000ef          	jal	ffffffffc0201ed0 <strnlen>
ffffffffc0201d60:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d64:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0201d68:	00001d97          	auipc	s11,0x1
ffffffffc0201d6c:	fe8d8d93          	addi	s11,s11,-24 # ffffffffc0202d50 <etext+0xde4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d70:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d72:	fda040e3          	bgtz	s10,ffffffffc0201d32 <vprintfmt+0x300>
ffffffffc0201d76:	bd51                	j	ffffffffc0201c0a <vprintfmt+0x1d8>

ffffffffc0201d78 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201d78:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201d7a:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201d7e:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201d80:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201d82:	ec06                	sd	ra,24(sp)
ffffffffc0201d84:	f83a                	sd	a4,48(sp)
ffffffffc0201d86:	fc3e                	sd	a5,56(sp)
ffffffffc0201d88:	e0c2                	sd	a6,64(sp)
ffffffffc0201d8a:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0201d8c:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201d8e:	ca5ff0ef          	jal	ffffffffc0201a32 <vprintfmt>
}
ffffffffc0201d92:	60e2                	ld	ra,24(sp)
ffffffffc0201d94:	6161                	addi	sp,sp,80
ffffffffc0201d96:	8082                	ret

ffffffffc0201d98 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0201d98:	7179                	addi	sp,sp,-48
ffffffffc0201d9a:	f406                	sd	ra,40(sp)
ffffffffc0201d9c:	f022                	sd	s0,32(sp)
ffffffffc0201d9e:	ec26                	sd	s1,24(sp)
ffffffffc0201da0:	e84a                	sd	s2,16(sp)
ffffffffc0201da2:	e44e                	sd	s3,8(sp)
    if (prompt != NULL) {
ffffffffc0201da4:	c901                	beqz	a0,ffffffffc0201db4 <readline+0x1c>
        cprintf("%s", prompt);
ffffffffc0201da6:	85aa                	mv	a1,a0
ffffffffc0201da8:	00001517          	auipc	a0,0x1
ffffffffc0201dac:	fc050513          	addi	a0,a0,-64 # ffffffffc0202d68 <etext+0xdfc>
ffffffffc0201db0:	b26fe0ef          	jal	ffffffffc02000d6 <cprintf>
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cputchar(c);
            buf[i ++] = c;
ffffffffc0201db4:	4481                	li	s1,0
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201db6:	497d                	li	s2,31
            buf[i ++] = c;
ffffffffc0201db8:	00005997          	auipc	s3,0x5
ffffffffc0201dbc:	28898993          	addi	s3,s3,648 # ffffffffc0207040 <buf>
        c = getchar();
ffffffffc0201dc0:	b98fe0ef          	jal	ffffffffc0200158 <getchar>
ffffffffc0201dc4:	842a                	mv	s0,a0
        }
        else if (c == '\b' && i > 0) {
ffffffffc0201dc6:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201dca:	3ff4a713          	slti	a4,s1,1023
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0201dce:	ff650693          	addi	a3,a0,-10
ffffffffc0201dd2:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc0201dd6:	02054963          	bltz	a0,ffffffffc0201e08 <readline+0x70>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201dda:	02a95f63          	bge	s2,a0,ffffffffc0201e18 <readline+0x80>
ffffffffc0201dde:	cf0d                	beqz	a4,ffffffffc0201e18 <readline+0x80>
            cputchar(c);
ffffffffc0201de0:	b2afe0ef          	jal	ffffffffc020010a <cputchar>
            buf[i ++] = c;
ffffffffc0201de4:	009987b3          	add	a5,s3,s1
ffffffffc0201de8:	00878023          	sb	s0,0(a5)
ffffffffc0201dec:	2485                	addiw	s1,s1,1
        c = getchar();
ffffffffc0201dee:	b6afe0ef          	jal	ffffffffc0200158 <getchar>
ffffffffc0201df2:	842a                	mv	s0,a0
        else if (c == '\b' && i > 0) {
ffffffffc0201df4:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201df8:	3ff4a713          	slti	a4,s1,1023
        else if (c == '\n' || c == '\r') {
ffffffffc0201dfc:	ff650693          	addi	a3,a0,-10
ffffffffc0201e00:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc0201e04:	fc055be3          	bgez	a0,ffffffffc0201dda <readline+0x42>
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
}
ffffffffc0201e08:	70a2                	ld	ra,40(sp)
ffffffffc0201e0a:	7402                	ld	s0,32(sp)
ffffffffc0201e0c:	64e2                	ld	s1,24(sp)
ffffffffc0201e0e:	6942                	ld	s2,16(sp)
ffffffffc0201e10:	69a2                	ld	s3,8(sp)
            return NULL;
ffffffffc0201e12:	4501                	li	a0,0
}
ffffffffc0201e14:	6145                	addi	sp,sp,48
ffffffffc0201e16:	8082                	ret
        else if (c == '\b' && i > 0) {
ffffffffc0201e18:	eb81                	bnez	a5,ffffffffc0201e28 <readline+0x90>
            cputchar(c);
ffffffffc0201e1a:	4521                	li	a0,8
        else if (c == '\b' && i > 0) {
ffffffffc0201e1c:	00905663          	blez	s1,ffffffffc0201e28 <readline+0x90>
            cputchar(c);
ffffffffc0201e20:	aeafe0ef          	jal	ffffffffc020010a <cputchar>
            i --;
ffffffffc0201e24:	34fd                	addiw	s1,s1,-1
ffffffffc0201e26:	bf69                	j	ffffffffc0201dc0 <readline+0x28>
        else if (c == '\n' || c == '\r') {
ffffffffc0201e28:	c291                	beqz	a3,ffffffffc0201e2c <readline+0x94>
ffffffffc0201e2a:	fa59                	bnez	a2,ffffffffc0201dc0 <readline+0x28>
            cputchar(c);
ffffffffc0201e2c:	8522                	mv	a0,s0
ffffffffc0201e2e:	adcfe0ef          	jal	ffffffffc020010a <cputchar>
            buf[i] = '\0';
ffffffffc0201e32:	00005517          	auipc	a0,0x5
ffffffffc0201e36:	20e50513          	addi	a0,a0,526 # ffffffffc0207040 <buf>
ffffffffc0201e3a:	94aa                	add	s1,s1,a0
ffffffffc0201e3c:	00048023          	sb	zero,0(s1)
}
ffffffffc0201e40:	70a2                	ld	ra,40(sp)
ffffffffc0201e42:	7402                	ld	s0,32(sp)
ffffffffc0201e44:	64e2                	ld	s1,24(sp)
ffffffffc0201e46:	6942                	ld	s2,16(sp)
ffffffffc0201e48:	69a2                	ld	s3,8(sp)
ffffffffc0201e4a:	6145                	addi	sp,sp,48
ffffffffc0201e4c:	8082                	ret

ffffffffc0201e4e <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201e4e:	00005717          	auipc	a4,0x5
ffffffffc0201e52:	1d273703          	ld	a4,466(a4) # ffffffffc0207020 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201e56:	4781                	li	a5,0
ffffffffc0201e58:	88ba                	mv	a7,a4
ffffffffc0201e5a:	852a                	mv	a0,a0
ffffffffc0201e5c:	85be                	mv	a1,a5
ffffffffc0201e5e:	863e                	mv	a2,a5
ffffffffc0201e60:	00000073          	ecall
ffffffffc0201e64:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc0201e66:	8082                	ret

ffffffffc0201e68 <sbi_set_timer>:
    __asm__ volatile (
ffffffffc0201e68:	00005717          	auipc	a4,0x5
ffffffffc0201e6c:	63873703          	ld	a4,1592(a4) # ffffffffc02074a0 <SBI_SET_TIMER>
ffffffffc0201e70:	4781                	li	a5,0
ffffffffc0201e72:	88ba                	mv	a7,a4
ffffffffc0201e74:	852a                	mv	a0,a0
ffffffffc0201e76:	85be                	mv	a1,a5
ffffffffc0201e78:	863e                	mv	a2,a5
ffffffffc0201e7a:	00000073          	ecall
ffffffffc0201e7e:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
ffffffffc0201e80:	8082                	ret

ffffffffc0201e82 <sbi_console_getchar>:
    __asm__ volatile (
ffffffffc0201e82:	00005797          	auipc	a5,0x5
ffffffffc0201e86:	1967b783          	ld	a5,406(a5) # ffffffffc0207018 <SBI_CONSOLE_GETCHAR>
ffffffffc0201e8a:	4501                	li	a0,0
ffffffffc0201e8c:	88be                	mv	a7,a5
ffffffffc0201e8e:	852a                	mv	a0,a0
ffffffffc0201e90:	85aa                	mv	a1,a0
ffffffffc0201e92:	862a                	mv	a2,a0
ffffffffc0201e94:	00000073          	ecall
ffffffffc0201e98:	852a                	mv	a0,a0

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
ffffffffc0201e9a:	2501                	sext.w	a0,a0
ffffffffc0201e9c:	8082                	ret

ffffffffc0201e9e <sbi_shutdown>:
    __asm__ volatile (
ffffffffc0201e9e:	00005717          	auipc	a4,0x5
ffffffffc0201ea2:	17273703          	ld	a4,370(a4) # ffffffffc0207010 <SBI_SHUTDOWN>
ffffffffc0201ea6:	4781                	li	a5,0
ffffffffc0201ea8:	88ba                	mv	a7,a4
ffffffffc0201eaa:	853e                	mv	a0,a5
ffffffffc0201eac:	85be                	mv	a1,a5
ffffffffc0201eae:	863e                	mv	a2,a5
ffffffffc0201eb0:	00000073          	ecall
ffffffffc0201eb4:	87aa                	mv	a5,a0

void sbi_shutdown(void)
{
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
ffffffffc0201eb6:	8082                	ret

ffffffffc0201eb8 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0201eb8:	00054783          	lbu	a5,0(a0)
ffffffffc0201ebc:	cb81                	beqz	a5,ffffffffc0201ecc <strlen+0x14>
    size_t cnt = 0;
ffffffffc0201ebe:	4781                	li	a5,0
        cnt ++;
ffffffffc0201ec0:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc0201ec2:	00f50733          	add	a4,a0,a5
ffffffffc0201ec6:	00074703          	lbu	a4,0(a4)
ffffffffc0201eca:	fb7d                	bnez	a4,ffffffffc0201ec0 <strlen+0x8>
    }
    return cnt;
}
ffffffffc0201ecc:	853e                	mv	a0,a5
ffffffffc0201ece:	8082                	ret

ffffffffc0201ed0 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201ed0:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201ed2:	e589                	bnez	a1,ffffffffc0201edc <strnlen+0xc>
ffffffffc0201ed4:	a811                	j	ffffffffc0201ee8 <strnlen+0x18>
        cnt ++;
ffffffffc0201ed6:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201ed8:	00f58863          	beq	a1,a5,ffffffffc0201ee8 <strnlen+0x18>
ffffffffc0201edc:	00f50733          	add	a4,a0,a5
ffffffffc0201ee0:	00074703          	lbu	a4,0(a4)
ffffffffc0201ee4:	fb6d                	bnez	a4,ffffffffc0201ed6 <strnlen+0x6>
ffffffffc0201ee6:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201ee8:	852e                	mv	a0,a1
ffffffffc0201eea:	8082                	ret

ffffffffc0201eec <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201eec:	00054783          	lbu	a5,0(a0)
ffffffffc0201ef0:	e791                	bnez	a5,ffffffffc0201efc <strcmp+0x10>
ffffffffc0201ef2:	a01d                	j	ffffffffc0201f18 <strcmp+0x2c>
ffffffffc0201ef4:	00054783          	lbu	a5,0(a0)
ffffffffc0201ef8:	cb99                	beqz	a5,ffffffffc0201f0e <strcmp+0x22>
ffffffffc0201efa:	0585                	addi	a1,a1,1 # fffffffffff80001 <end+0x3fd78b59>
ffffffffc0201efc:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0201f00:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201f02:	fef709e3          	beq	a4,a5,ffffffffc0201ef4 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201f06:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0201f0a:	9d19                	subw	a0,a0,a4
ffffffffc0201f0c:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201f0e:	0015c703          	lbu	a4,1(a1)
ffffffffc0201f12:	4501                	li	a0,0
}
ffffffffc0201f14:	9d19                	subw	a0,a0,a4
ffffffffc0201f16:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201f18:	0005c703          	lbu	a4,0(a1)
ffffffffc0201f1c:	4501                	li	a0,0
ffffffffc0201f1e:	b7f5                	j	ffffffffc0201f0a <strcmp+0x1e>

ffffffffc0201f20 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201f20:	ce01                	beqz	a2,ffffffffc0201f38 <strncmp+0x18>
ffffffffc0201f22:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201f26:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201f28:	cb91                	beqz	a5,ffffffffc0201f3c <strncmp+0x1c>
ffffffffc0201f2a:	0005c703          	lbu	a4,0(a1)
ffffffffc0201f2e:	00f71763          	bne	a4,a5,ffffffffc0201f3c <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc0201f32:	0505                	addi	a0,a0,1
ffffffffc0201f34:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201f36:	f675                	bnez	a2,ffffffffc0201f22 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201f38:	4501                	li	a0,0
ffffffffc0201f3a:	8082                	ret
ffffffffc0201f3c:	00054503          	lbu	a0,0(a0)
ffffffffc0201f40:	0005c783          	lbu	a5,0(a1)
ffffffffc0201f44:	9d1d                	subw	a0,a0,a5
}
ffffffffc0201f46:	8082                	ret

ffffffffc0201f48 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0201f48:	a021                	j	ffffffffc0201f50 <strchr+0x8>
        if (*s == c) {
ffffffffc0201f4a:	00f58763          	beq	a1,a5,ffffffffc0201f58 <strchr+0x10>
            return (char *)s;
        }
        s ++;
ffffffffc0201f4e:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0201f50:	00054783          	lbu	a5,0(a0)
ffffffffc0201f54:	fbfd                	bnez	a5,ffffffffc0201f4a <strchr+0x2>
    }
    return NULL;
ffffffffc0201f56:	4501                	li	a0,0
}
ffffffffc0201f58:	8082                	ret

ffffffffc0201f5a <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201f5a:	ca01                	beqz	a2,ffffffffc0201f6a <memset+0x10>
ffffffffc0201f5c:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0201f5e:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0201f60:	0785                	addi	a5,a5,1
ffffffffc0201f62:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201f66:	fef61de3          	bne	a2,a5,ffffffffc0201f60 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201f6a:	8082                	ret
