
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000c297          	auipc	t0,0xc
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020c000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000c297          	auipc	t0,0xc
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020c008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020b2b7          	lui	t0,0xc020b
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
ffffffffc020003c:	c020b137          	lui	sp,0xc020b

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
void grade_backtrace(void);

int kern_init(void)
{
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc020004a:	000b1517          	auipc	a0,0xb1
ffffffffc020004e:	13e50513          	addi	a0,a0,318 # ffffffffc02b1188 <buf>
ffffffffc0200052:	000b5617          	auipc	a2,0xb5
ffffffffc0200056:	61e60613          	addi	a2,a2,1566 # ffffffffc02b5670 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc020aff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	1e2060ef          	jal	ffffffffc0206244 <memset>
    cons_init(); // init the console
ffffffffc0200066:	4e6000ef          	jal	ffffffffc020054c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006a:	00006597          	auipc	a1,0x6
ffffffffc020006e:	20658593          	addi	a1,a1,518 # ffffffffc0206270 <etext+0x2>
ffffffffc0200072:	00006517          	auipc	a0,0x6
ffffffffc0200076:	21e50513          	addi	a0,a0,542 # ffffffffc0206290 <etext+0x22>
ffffffffc020007a:	11e000ef          	jal	ffffffffc0200198 <cprintf>

    print_kerninfo();
ffffffffc020007e:	1ac000ef          	jal	ffffffffc020022a <print_kerninfo>

    // grade_backtrace();

    dtb_init(); // init dtb
ffffffffc0200082:	53c000ef          	jal	ffffffffc02005be <dtb_init>

    pmm_init(); // init physical memory management
ffffffffc0200086:	618020ef          	jal	ffffffffc020269e <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	087000ef          	jal	ffffffffc0200910 <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	085000ef          	jal	ffffffffc0200912 <idt_init>

    vmm_init(); // init virtual memory management
ffffffffc0200092:	105030ef          	jal	ffffffffc0203996 <vmm_init>
    sched_init();
ffffffffc0200096:	26b050ef          	jal	ffffffffc0205b00 <sched_init>
    proc_init(); // init process table
ffffffffc020009a:	619040ef          	jal	ffffffffc0204eb2 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009e:	416000ef          	jal	ffffffffc02004b4 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc02000a2:	063000ef          	jal	ffffffffc0200904 <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a6:	7ad040ef          	jal	ffffffffc0205052 <cpu_idle>

ffffffffc02000aa <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000aa:	7179                	addi	sp,sp,-48
ffffffffc02000ac:	f406                	sd	ra,40(sp)
ffffffffc02000ae:	f022                	sd	s0,32(sp)
ffffffffc02000b0:	ec26                	sd	s1,24(sp)
ffffffffc02000b2:	e84a                	sd	s2,16(sp)
ffffffffc02000b4:	e44e                	sd	s3,8(sp)
    if (prompt != NULL) {
ffffffffc02000b6:	c901                	beqz	a0,ffffffffc02000c6 <readline+0x1c>
        cprintf("%s", prompt);
ffffffffc02000b8:	85aa                	mv	a1,a0
ffffffffc02000ba:	00006517          	auipc	a0,0x6
ffffffffc02000be:	1de50513          	addi	a0,a0,478 # ffffffffc0206298 <etext+0x2a>
ffffffffc02000c2:	0d6000ef          	jal	ffffffffc0200198 <cprintf>
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cputchar(c);
            buf[i ++] = c;
ffffffffc02000c6:	4481                	li	s1,0
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000c8:	497d                	li	s2,31
            buf[i ++] = c;
ffffffffc02000ca:	000b1997          	auipc	s3,0xb1
ffffffffc02000ce:	0be98993          	addi	s3,s3,190 # ffffffffc02b1188 <buf>
        c = getchar();
ffffffffc02000d2:	148000ef          	jal	ffffffffc020021a <getchar>
ffffffffc02000d6:	842a                	mv	s0,a0
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000d8:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000dc:	3ff4a713          	slti	a4,s1,1023
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000e0:	ff650693          	addi	a3,a0,-10
ffffffffc02000e4:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc02000e8:	02054963          	bltz	a0,ffffffffc020011a <readline+0x70>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ec:	02a95f63          	bge	s2,a0,ffffffffc020012a <readline+0x80>
ffffffffc02000f0:	cf0d                	beqz	a4,ffffffffc020012a <readline+0x80>
            cputchar(c);
ffffffffc02000f2:	0da000ef          	jal	ffffffffc02001cc <cputchar>
            buf[i ++] = c;
ffffffffc02000f6:	009987b3          	add	a5,s3,s1
ffffffffc02000fa:	00878023          	sb	s0,0(a5)
ffffffffc02000fe:	2485                	addiw	s1,s1,1
        c = getchar();
ffffffffc0200100:	11a000ef          	jal	ffffffffc020021a <getchar>
ffffffffc0200104:	842a                	mv	s0,a0
        else if (c == '\b' && i > 0) {
ffffffffc0200106:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020010a:	3ff4a713          	slti	a4,s1,1023
        else if (c == '\n' || c == '\r') {
ffffffffc020010e:	ff650693          	addi	a3,a0,-10
ffffffffc0200112:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc0200116:	fc055be3          	bgez	a0,ffffffffc02000ec <readline+0x42>
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
}
ffffffffc020011a:	70a2                	ld	ra,40(sp)
ffffffffc020011c:	7402                	ld	s0,32(sp)
ffffffffc020011e:	64e2                	ld	s1,24(sp)
ffffffffc0200120:	6942                	ld	s2,16(sp)
ffffffffc0200122:	69a2                	ld	s3,8(sp)
            return NULL;
ffffffffc0200124:	4501                	li	a0,0
}
ffffffffc0200126:	6145                	addi	sp,sp,48
ffffffffc0200128:	8082                	ret
        else if (c == '\b' && i > 0) {
ffffffffc020012a:	eb81                	bnez	a5,ffffffffc020013a <readline+0x90>
            cputchar(c);
ffffffffc020012c:	4521                	li	a0,8
        else if (c == '\b' && i > 0) {
ffffffffc020012e:	00905663          	blez	s1,ffffffffc020013a <readline+0x90>
            cputchar(c);
ffffffffc0200132:	09a000ef          	jal	ffffffffc02001cc <cputchar>
            i --;
ffffffffc0200136:	34fd                	addiw	s1,s1,-1
ffffffffc0200138:	bf69                	j	ffffffffc02000d2 <readline+0x28>
        else if (c == '\n' || c == '\r') {
ffffffffc020013a:	c291                	beqz	a3,ffffffffc020013e <readline+0x94>
ffffffffc020013c:	fa59                	bnez	a2,ffffffffc02000d2 <readline+0x28>
            cputchar(c);
ffffffffc020013e:	8522                	mv	a0,s0
ffffffffc0200140:	08c000ef          	jal	ffffffffc02001cc <cputchar>
            buf[i] = '\0';
ffffffffc0200144:	000b1517          	auipc	a0,0xb1
ffffffffc0200148:	04450513          	addi	a0,a0,68 # ffffffffc02b1188 <buf>
ffffffffc020014c:	94aa                	add	s1,s1,a0
ffffffffc020014e:	00048023          	sb	zero,0(s1)
}
ffffffffc0200152:	70a2                	ld	ra,40(sp)
ffffffffc0200154:	7402                	ld	s0,32(sp)
ffffffffc0200156:	64e2                	ld	s1,24(sp)
ffffffffc0200158:	6942                	ld	s2,16(sp)
ffffffffc020015a:	69a2                	ld	s3,8(sp)
ffffffffc020015c:	6145                	addi	sp,sp,48
ffffffffc020015e:	8082                	ret

ffffffffc0200160 <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc0200160:	1101                	addi	sp,sp,-32
ffffffffc0200162:	ec06                	sd	ra,24(sp)
ffffffffc0200164:	e42e                	sd	a1,8(sp)
    cons_putc(c);
ffffffffc0200166:	3e8000ef          	jal	ffffffffc020054e <cons_putc>
    (*cnt)++;
ffffffffc020016a:	65a2                	ld	a1,8(sp)
}
ffffffffc020016c:	60e2                	ld	ra,24(sp)
    (*cnt)++;
ffffffffc020016e:	419c                	lw	a5,0(a1)
ffffffffc0200170:	2785                	addiw	a5,a5,1
ffffffffc0200172:	c19c                	sw	a5,0(a1)
}
ffffffffc0200174:	6105                	addi	sp,sp,32
ffffffffc0200176:	8082                	ret

ffffffffc0200178 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc0200178:	1101                	addi	sp,sp,-32
ffffffffc020017a:	862a                	mv	a2,a0
ffffffffc020017c:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020017e:	00000517          	auipc	a0,0x0
ffffffffc0200182:	fe250513          	addi	a0,a0,-30 # ffffffffc0200160 <cputch>
ffffffffc0200186:	006c                	addi	a1,sp,12
{
ffffffffc0200188:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020018a:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020018c:	49f050ef          	jal	ffffffffc0205e2a <vprintfmt>
    return cnt;
}
ffffffffc0200190:	60e2                	ld	ra,24(sp)
ffffffffc0200192:	4532                	lw	a0,12(sp)
ffffffffc0200194:	6105                	addi	sp,sp,32
ffffffffc0200196:	8082                	ret

ffffffffc0200198 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc0200198:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020019a:	02810313          	addi	t1,sp,40
{
ffffffffc020019e:	f42e                	sd	a1,40(sp)
ffffffffc02001a0:	f832                	sd	a2,48(sp)
ffffffffc02001a2:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a4:	862a                	mv	a2,a0
ffffffffc02001a6:	004c                	addi	a1,sp,4
ffffffffc02001a8:	00000517          	auipc	a0,0x0
ffffffffc02001ac:	fb850513          	addi	a0,a0,-72 # ffffffffc0200160 <cputch>
ffffffffc02001b0:	869a                	mv	a3,t1
{
ffffffffc02001b2:	ec06                	sd	ra,24(sp)
ffffffffc02001b4:	e0ba                	sd	a4,64(sp)
ffffffffc02001b6:	e4be                	sd	a5,72(sp)
ffffffffc02001b8:	e8c2                	sd	a6,80(sp)
ffffffffc02001ba:	ecc6                	sd	a7,88(sp)
    int cnt = 0;
ffffffffc02001bc:	c202                	sw	zero,4(sp)
    va_start(ap, fmt);
ffffffffc02001be:	e41a                	sd	t1,8(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001c0:	46b050ef          	jal	ffffffffc0205e2a <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c4:	60e2                	ld	ra,24(sp)
ffffffffc02001c6:	4512                	lw	a0,4(sp)
ffffffffc02001c8:	6125                	addi	sp,sp,96
ffffffffc02001ca:	8082                	ret

ffffffffc02001cc <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001cc:	a649                	j	ffffffffc020054e <cons_putc>

ffffffffc02001ce <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001ce:	1101                	addi	sp,sp,-32
ffffffffc02001d0:	e822                	sd	s0,16(sp)
ffffffffc02001d2:	ec06                	sd	ra,24(sp)
ffffffffc02001d4:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001d6:	00054503          	lbu	a0,0(a0)
ffffffffc02001da:	c51d                	beqz	a0,ffffffffc0200208 <cputs+0x3a>
ffffffffc02001dc:	e426                	sd	s1,8(sp)
ffffffffc02001de:	0405                	addi	s0,s0,1
    int cnt = 0;
ffffffffc02001e0:	4481                	li	s1,0
    cons_putc(c);
ffffffffc02001e2:	36c000ef          	jal	ffffffffc020054e <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001e6:	00044503          	lbu	a0,0(s0)
ffffffffc02001ea:	0405                	addi	s0,s0,1
ffffffffc02001ec:	87a6                	mv	a5,s1
    (*cnt)++;
ffffffffc02001ee:	2485                	addiw	s1,s1,1
    while ((c = *str++) != '\0')
ffffffffc02001f0:	f96d                	bnez	a0,ffffffffc02001e2 <cputs+0x14>
    cons_putc(c);
ffffffffc02001f2:	4529                	li	a0,10
    (*cnt)++;
ffffffffc02001f4:	0027841b          	addiw	s0,a5,2
ffffffffc02001f8:	64a2                	ld	s1,8(sp)
    cons_putc(c);
ffffffffc02001fa:	354000ef          	jal	ffffffffc020054e <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001fe:	60e2                	ld	ra,24(sp)
ffffffffc0200200:	8522                	mv	a0,s0
ffffffffc0200202:	6442                	ld	s0,16(sp)
ffffffffc0200204:	6105                	addi	sp,sp,32
ffffffffc0200206:	8082                	ret
    cons_putc(c);
ffffffffc0200208:	4529                	li	a0,10
ffffffffc020020a:	344000ef          	jal	ffffffffc020054e <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc020020e:	4405                	li	s0,1
}
ffffffffc0200210:	60e2                	ld	ra,24(sp)
ffffffffc0200212:	8522                	mv	a0,s0
ffffffffc0200214:	6442                	ld	s0,16(sp)
ffffffffc0200216:	6105                	addi	sp,sp,32
ffffffffc0200218:	8082                	ret

ffffffffc020021a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc020021a:	1141                	addi	sp,sp,-16
ffffffffc020021c:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020021e:	364000ef          	jal	ffffffffc0200582 <cons_getc>
ffffffffc0200222:	dd75                	beqz	a0,ffffffffc020021e <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200224:	60a2                	ld	ra,8(sp)
ffffffffc0200226:	0141                	addi	sp,sp,16
ffffffffc0200228:	8082                	ret

ffffffffc020022a <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020022a:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020022c:	00006517          	auipc	a0,0x6
ffffffffc0200230:	07450513          	addi	a0,a0,116 # ffffffffc02062a0 <etext+0x32>
void print_kerninfo(void) {
ffffffffc0200234:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200236:	f63ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020023a:	00000597          	auipc	a1,0x0
ffffffffc020023e:	e1058593          	addi	a1,a1,-496 # ffffffffc020004a <kern_init>
ffffffffc0200242:	00006517          	auipc	a0,0x6
ffffffffc0200246:	07e50513          	addi	a0,a0,126 # ffffffffc02062c0 <etext+0x52>
ffffffffc020024a:	f4fff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020024e:	00006597          	auipc	a1,0x6
ffffffffc0200252:	02058593          	addi	a1,a1,32 # ffffffffc020626e <etext>
ffffffffc0200256:	00006517          	auipc	a0,0x6
ffffffffc020025a:	08a50513          	addi	a0,a0,138 # ffffffffc02062e0 <etext+0x72>
ffffffffc020025e:	f3bff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200262:	000b1597          	auipc	a1,0xb1
ffffffffc0200266:	f2658593          	addi	a1,a1,-218 # ffffffffc02b1188 <buf>
ffffffffc020026a:	00006517          	auipc	a0,0x6
ffffffffc020026e:	09650513          	addi	a0,a0,150 # ffffffffc0206300 <etext+0x92>
ffffffffc0200272:	f27ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200276:	000b5597          	auipc	a1,0xb5
ffffffffc020027a:	3fa58593          	addi	a1,a1,1018 # ffffffffc02b5670 <end>
ffffffffc020027e:	00006517          	auipc	a0,0x6
ffffffffc0200282:	0a250513          	addi	a0,a0,162 # ffffffffc0206320 <etext+0xb2>
ffffffffc0200286:	f13ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020028a:	00000717          	auipc	a4,0x0
ffffffffc020028e:	dc070713          	addi	a4,a4,-576 # ffffffffc020004a <kern_init>
ffffffffc0200292:	000b5797          	auipc	a5,0xb5
ffffffffc0200296:	7dd78793          	addi	a5,a5,2013 # ffffffffc02b5a6f <end+0x3ff>
ffffffffc020029a:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020029c:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02002a0:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002a2:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002a6:	95be                	add	a1,a1,a5
ffffffffc02002a8:	85a9                	srai	a1,a1,0xa
ffffffffc02002aa:	00006517          	auipc	a0,0x6
ffffffffc02002ae:	09650513          	addi	a0,a0,150 # ffffffffc0206340 <etext+0xd2>
}
ffffffffc02002b2:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002b4:	b5d5                	j	ffffffffc0200198 <cprintf>

ffffffffc02002b6 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc02002b6:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002b8:	00006617          	auipc	a2,0x6
ffffffffc02002bc:	0b860613          	addi	a2,a2,184 # ffffffffc0206370 <etext+0x102>
ffffffffc02002c0:	04d00593          	li	a1,77
ffffffffc02002c4:	00006517          	auipc	a0,0x6
ffffffffc02002c8:	0c450513          	addi	a0,a0,196 # ffffffffc0206388 <etext+0x11a>
void print_stackframe(void) {
ffffffffc02002cc:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002ce:	17c000ef          	jal	ffffffffc020044a <__panic>

ffffffffc02002d2 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002d2:	1101                	addi	sp,sp,-32
ffffffffc02002d4:	e822                	sd	s0,16(sp)
ffffffffc02002d6:	e426                	sd	s1,8(sp)
ffffffffc02002d8:	ec06                	sd	ra,24(sp)
ffffffffc02002da:	00008417          	auipc	s0,0x8
ffffffffc02002de:	d1640413          	addi	s0,s0,-746 # ffffffffc0207ff0 <commands>
ffffffffc02002e2:	00008497          	auipc	s1,0x8
ffffffffc02002e6:	d5648493          	addi	s1,s1,-682 # ffffffffc0208038 <commands+0x48>
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002ea:	6410                	ld	a2,8(s0)
ffffffffc02002ec:	600c                	ld	a1,0(s0)
ffffffffc02002ee:	00006517          	auipc	a0,0x6
ffffffffc02002f2:	0b250513          	addi	a0,a0,178 # ffffffffc02063a0 <etext+0x132>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002f6:	0461                	addi	s0,s0,24
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002f8:	ea1ff0ef          	jal	ffffffffc0200198 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002fc:	fe9417e3          	bne	s0,s1,ffffffffc02002ea <mon_help+0x18>
    }
    return 0;
}
ffffffffc0200300:	60e2                	ld	ra,24(sp)
ffffffffc0200302:	6442                	ld	s0,16(sp)
ffffffffc0200304:	64a2                	ld	s1,8(sp)
ffffffffc0200306:	4501                	li	a0,0
ffffffffc0200308:	6105                	addi	sp,sp,32
ffffffffc020030a:	8082                	ret

ffffffffc020030c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc020030c:	1141                	addi	sp,sp,-16
ffffffffc020030e:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc0200310:	f1bff0ef          	jal	ffffffffc020022a <print_kerninfo>
    return 0;
}
ffffffffc0200314:	60a2                	ld	ra,8(sp)
ffffffffc0200316:	4501                	li	a0,0
ffffffffc0200318:	0141                	addi	sp,sp,16
ffffffffc020031a:	8082                	ret

ffffffffc020031c <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc020031c:	1141                	addi	sp,sp,-16
ffffffffc020031e:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc0200320:	f97ff0ef          	jal	ffffffffc02002b6 <print_stackframe>
    return 0;
}
ffffffffc0200324:	60a2                	ld	ra,8(sp)
ffffffffc0200326:	4501                	li	a0,0
ffffffffc0200328:	0141                	addi	sp,sp,16
ffffffffc020032a:	8082                	ret

ffffffffc020032c <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc020032c:	7131                	addi	sp,sp,-192
ffffffffc020032e:	e952                	sd	s4,144(sp)
ffffffffc0200330:	8a2a                	mv	s4,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200332:	00006517          	auipc	a0,0x6
ffffffffc0200336:	07e50513          	addi	a0,a0,126 # ffffffffc02063b0 <etext+0x142>
kmonitor(struct trapframe *tf) {
ffffffffc020033a:	fd06                	sd	ra,184(sp)
ffffffffc020033c:	f922                	sd	s0,176(sp)
ffffffffc020033e:	f526                	sd	s1,168(sp)
ffffffffc0200340:	ed4e                	sd	s3,152(sp)
ffffffffc0200342:	e556                	sd	s5,136(sp)
ffffffffc0200344:	e15a                	sd	s6,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200346:	e53ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020034a:	00006517          	auipc	a0,0x6
ffffffffc020034e:	08e50513          	addi	a0,a0,142 # ffffffffc02063d8 <etext+0x16a>
ffffffffc0200352:	e47ff0ef          	jal	ffffffffc0200198 <cprintf>
    if (tf != NULL) {
ffffffffc0200356:	000a0563          	beqz	s4,ffffffffc0200360 <kmonitor+0x34>
        print_trapframe(tf);
ffffffffc020035a:	8552                	mv	a0,s4
ffffffffc020035c:	79e000ef          	jal	ffffffffc0200afa <print_trapframe>
ffffffffc0200360:	00008a97          	auipc	s5,0x8
ffffffffc0200364:	c90a8a93          	addi	s5,s5,-880 # ffffffffc0207ff0 <commands>
        if (argc == MAXARGS - 1) {
ffffffffc0200368:	49bd                	li	s3,15
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020036a:	00006517          	auipc	a0,0x6
ffffffffc020036e:	09650513          	addi	a0,a0,150 # ffffffffc0206400 <etext+0x192>
ffffffffc0200372:	d39ff0ef          	jal	ffffffffc02000aa <readline>
ffffffffc0200376:	842a                	mv	s0,a0
ffffffffc0200378:	d96d                	beqz	a0,ffffffffc020036a <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020037a:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc020037e:	4481                	li	s1,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200380:	e99d                	bnez	a1,ffffffffc02003b6 <kmonitor+0x8a>
    int argc = 0;
ffffffffc0200382:	8b26                	mv	s6,s1
    if (argc == 0) {
ffffffffc0200384:	fe0b03e3          	beqz	s6,ffffffffc020036a <kmonitor+0x3e>
ffffffffc0200388:	00008497          	auipc	s1,0x8
ffffffffc020038c:	c6848493          	addi	s1,s1,-920 # ffffffffc0207ff0 <commands>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200390:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200392:	6582                	ld	a1,0(sp)
ffffffffc0200394:	6088                	ld	a0,0(s1)
ffffffffc0200396:	641050ef          	jal	ffffffffc02061d6 <strcmp>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020039a:	478d                	li	a5,3
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020039c:	c149                	beqz	a0,ffffffffc020041e <kmonitor+0xf2>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020039e:	2405                	addiw	s0,s0,1
ffffffffc02003a0:	04e1                	addi	s1,s1,24
ffffffffc02003a2:	fef418e3          	bne	s0,a5,ffffffffc0200392 <kmonitor+0x66>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003a6:	6582                	ld	a1,0(sp)
ffffffffc02003a8:	00006517          	auipc	a0,0x6
ffffffffc02003ac:	08850513          	addi	a0,a0,136 # ffffffffc0206430 <etext+0x1c2>
ffffffffc02003b0:	de9ff0ef          	jal	ffffffffc0200198 <cprintf>
    return 0;
ffffffffc02003b4:	bf5d                	j	ffffffffc020036a <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003b6:	00006517          	auipc	a0,0x6
ffffffffc02003ba:	05250513          	addi	a0,a0,82 # ffffffffc0206408 <etext+0x19a>
ffffffffc02003be:	675050ef          	jal	ffffffffc0206232 <strchr>
ffffffffc02003c2:	c901                	beqz	a0,ffffffffc02003d2 <kmonitor+0xa6>
ffffffffc02003c4:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc02003c8:	00040023          	sb	zero,0(s0)
ffffffffc02003cc:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003ce:	d9d5                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc02003d0:	b7dd                	j	ffffffffc02003b6 <kmonitor+0x8a>
        if (*buf == '\0') {
ffffffffc02003d2:	00044783          	lbu	a5,0(s0)
ffffffffc02003d6:	d7d5                	beqz	a5,ffffffffc0200382 <kmonitor+0x56>
        if (argc == MAXARGS - 1) {
ffffffffc02003d8:	03348b63          	beq	s1,s3,ffffffffc020040e <kmonitor+0xe2>
        argv[argc ++] = buf;
ffffffffc02003dc:	00349793          	slli	a5,s1,0x3
ffffffffc02003e0:	978a                	add	a5,a5,sp
ffffffffc02003e2:	e380                	sd	s0,0(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003e4:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc02003e8:	2485                	addiw	s1,s1,1
ffffffffc02003ea:	8b26                	mv	s6,s1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003ec:	e591                	bnez	a1,ffffffffc02003f8 <kmonitor+0xcc>
ffffffffc02003ee:	bf59                	j	ffffffffc0200384 <kmonitor+0x58>
ffffffffc02003f0:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc02003f4:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003f6:	d5d1                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc02003f8:	00006517          	auipc	a0,0x6
ffffffffc02003fc:	01050513          	addi	a0,a0,16 # ffffffffc0206408 <etext+0x19a>
ffffffffc0200400:	633050ef          	jal	ffffffffc0206232 <strchr>
ffffffffc0200404:	d575                	beqz	a0,ffffffffc02003f0 <kmonitor+0xc4>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200406:	00044583          	lbu	a1,0(s0)
ffffffffc020040a:	dda5                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc020040c:	b76d                	j	ffffffffc02003b6 <kmonitor+0x8a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020040e:	45c1                	li	a1,16
ffffffffc0200410:	00006517          	auipc	a0,0x6
ffffffffc0200414:	00050513          	mv	a0,a0
ffffffffc0200418:	d81ff0ef          	jal	ffffffffc0200198 <cprintf>
ffffffffc020041c:	b7c1                	j	ffffffffc02003dc <kmonitor+0xb0>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc020041e:	00141793          	slli	a5,s0,0x1
ffffffffc0200422:	97a2                	add	a5,a5,s0
ffffffffc0200424:	078e                	slli	a5,a5,0x3
ffffffffc0200426:	97d6                	add	a5,a5,s5
ffffffffc0200428:	6b9c                	ld	a5,16(a5)
ffffffffc020042a:	fffb051b          	addiw	a0,s6,-1
ffffffffc020042e:	8652                	mv	a2,s4
ffffffffc0200430:	002c                	addi	a1,sp,8
ffffffffc0200432:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc0200434:	f2055be3          	bgez	a0,ffffffffc020036a <kmonitor+0x3e>
}
ffffffffc0200438:	70ea                	ld	ra,184(sp)
ffffffffc020043a:	744a                	ld	s0,176(sp)
ffffffffc020043c:	74aa                	ld	s1,168(sp)
ffffffffc020043e:	69ea                	ld	s3,152(sp)
ffffffffc0200440:	6a4a                	ld	s4,144(sp)
ffffffffc0200442:	6aaa                	ld	s5,136(sp)
ffffffffc0200444:	6b0a                	ld	s6,128(sp)
ffffffffc0200446:	6129                	addi	sp,sp,192
ffffffffc0200448:	8082                	ret

ffffffffc020044a <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc020044a:	000b5317          	auipc	t1,0xb5
ffffffffc020044e:	19633303          	ld	t1,406(t1) # ffffffffc02b55e0 <is_panic>
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200452:	715d                	addi	sp,sp,-80
ffffffffc0200454:	ec06                	sd	ra,24(sp)
ffffffffc0200456:	f436                	sd	a3,40(sp)
ffffffffc0200458:	f83a                	sd	a4,48(sp)
ffffffffc020045a:	fc3e                	sd	a5,56(sp)
ffffffffc020045c:	e0c2                	sd	a6,64(sp)
ffffffffc020045e:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200460:	02031e63          	bnez	t1,ffffffffc020049c <__panic+0x52>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200464:	4705                	li	a4,1

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200466:	103c                	addi	a5,sp,40
ffffffffc0200468:	e822                	sd	s0,16(sp)
ffffffffc020046a:	8432                	mv	s0,a2
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020046c:	862e                	mv	a2,a1
ffffffffc020046e:	85aa                	mv	a1,a0
ffffffffc0200470:	00006517          	auipc	a0,0x6
ffffffffc0200474:	06850513          	addi	a0,a0,104 # ffffffffc02064d8 <etext+0x26a>
    is_panic = 1;
ffffffffc0200478:	000b5697          	auipc	a3,0xb5
ffffffffc020047c:	16e6b423          	sd	a4,360(a3) # ffffffffc02b55e0 <is_panic>
    va_start(ap, fmt);
ffffffffc0200480:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200482:	d17ff0ef          	jal	ffffffffc0200198 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200486:	65a2                	ld	a1,8(sp)
ffffffffc0200488:	8522                	mv	a0,s0
ffffffffc020048a:	cefff0ef          	jal	ffffffffc0200178 <vcprintf>
    cprintf("\n");
ffffffffc020048e:	00006517          	auipc	a0,0x6
ffffffffc0200492:	06a50513          	addi	a0,a0,106 # ffffffffc02064f8 <etext+0x28a>
ffffffffc0200496:	d03ff0ef          	jal	ffffffffc0200198 <cprintf>
ffffffffc020049a:	6442                	ld	s0,16(sp)
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc020049c:	4501                	li	a0,0
ffffffffc020049e:	4581                	li	a1,0
ffffffffc02004a0:	4601                	li	a2,0
ffffffffc02004a2:	48a1                	li	a7,8
ffffffffc02004a4:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004a8:	462000ef          	jal	ffffffffc020090a <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc02004ac:	4501                	li	a0,0
ffffffffc02004ae:	e7fff0ef          	jal	ffffffffc020032c <kmonitor>
    while (1) {
ffffffffc02004b2:	bfed                	j	ffffffffc02004ac <__panic+0x62>

ffffffffc02004b4 <clock_init>:
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void)
{
    set_csr(sie, MIP_STIP);
ffffffffc02004b4:	02000793          	li	a5,32
ffffffffc02004b8:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02004bc:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02004c0:	67e1                	lui	a5,0x18
ffffffffc02004c2:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0xd170>
ffffffffc02004c6:	953e                	add	a0,a0,a5
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc02004c8:	4581                	li	a1,0
ffffffffc02004ca:	4601                	li	a2,0
ffffffffc02004cc:	4881                	li	a7,0
ffffffffc02004ce:	00000073          	ecall
    cprintf("++ setup timer interrupts\n");
ffffffffc02004d2:	00006517          	auipc	a0,0x6
ffffffffc02004d6:	02e50513          	addi	a0,a0,46 # ffffffffc0206500 <etext+0x292>
    ticks = 0;
ffffffffc02004da:	000b5797          	auipc	a5,0xb5
ffffffffc02004de:	1007b723          	sd	zero,270(a5) # ffffffffc02b55e8 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc02004e2:	b95d                	j	ffffffffc0200198 <cprintf>

ffffffffc02004e4 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02004e4:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02004e8:	67e1                	lui	a5,0x18
ffffffffc02004ea:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0xd170>
ffffffffc02004ee:	953e                	add	a0,a0,a5
ffffffffc02004f0:	4581                	li	a1,0
ffffffffc02004f2:	4601                	li	a2,0
ffffffffc02004f4:	4881                	li	a7,0
ffffffffc02004f6:	00000073          	ecall
ffffffffc02004fa:	8082                	ret

ffffffffc02004fc <clock_intr>:

/* 时钟中断处理函数 */
void clock_intr(void) {
    ticks++;  // 全局时钟计数递增
ffffffffc02004fc:	000b5717          	auipc	a4,0xb5
ffffffffc0200500:	0ec70713          	addi	a4,a4,236 # ffffffffc02b55e8 <ticks>
ffffffffc0200504:	631c                	ld	a5,0(a4)
ffffffffc0200506:	0785                	addi	a5,a5,1
ffffffffc0200508:	e31c                	sd	a5,0(a4)
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020050a:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020050e:	67e1                	lui	a5,0x18
ffffffffc0200510:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0xd170>
ffffffffc0200514:	953e                	add	a0,a0,a5
ffffffffc0200516:	4581                	li	a1,0
ffffffffc0200518:	4601                	li	a2,0
ffffffffc020051a:	4881                	li	a7,0
ffffffffc020051c:	00000073          	ecall

    // 设置下一次时钟中断
    clock_set_next_event();

    // 如果当前有运行的进程，更新其时间片
    if (current != NULL) {
ffffffffc0200520:	000b5797          	auipc	a5,0xb5
ffffffffc0200524:	1287b783          	ld	a5,296(a5) # ffffffffc02b5648 <current>
ffffffffc0200528:	cf91                	beqz	a5,ffffffffc0200544 <clock_intr+0x48>
        if (current->pid >= 2 && current->pid <= 7 && ticks % 10 == 0) {
ffffffffc020052a:	43d4                	lw	a3,4(a5)
ffffffffc020052c:	4615                	li	a2,5
ffffffffc020052e:	36f9                	addiw	a3,a3,-2
ffffffffc0200530:	00d66363          	bltu	a2,a3,ffffffffc0200536 <clock_intr+0x3a>
ffffffffc0200534:	6318                	ld	a4,0(a4)
// DEBUG:             cprintf("clock_intr: pid=%d, time_slice=%d\n", current->pid, current->time_slice);
        }
        current->time_slice--;  // 减少当前进程时间片
ffffffffc0200536:	1207a703          	lw	a4,288(a5)
ffffffffc020053a:	377d                	addiw	a4,a4,-1
ffffffffc020053c:	12e7a023          	sw	a4,288(a5)
        
        // 时间片用完，需要重新调度
        if (current->time_slice <= 0) {
ffffffffc0200540:	00e05363          	blez	a4,ffffffffc0200546 <clock_intr+0x4a>
// DEBUG:                 cprintf("clock_intr: pid=%d time_slice expired, set need_resched\n", current->pid);
            }
            current->need_resched = 1;  // 设置调度标志
        }
    }
}
ffffffffc0200544:	8082                	ret
            current->need_resched = 1;  // 设置调度标志
ffffffffc0200546:	4705                	li	a4,1
ffffffffc0200548:	ef98                	sd	a4,24(a5)
}
ffffffffc020054a:	8082                	ret

ffffffffc020054c <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020054c:	8082                	ret

ffffffffc020054e <cons_putc>:
#include <assert.h>
#include <atomic.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020054e:	100027f3          	csrr	a5,sstatus
ffffffffc0200552:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200554:	0ff57513          	zext.b	a0,a0
ffffffffc0200558:	e799                	bnez	a5,ffffffffc0200566 <cons_putc+0x18>
ffffffffc020055a:	4581                	li	a1,0
ffffffffc020055c:	4601                	li	a2,0
ffffffffc020055e:	4885                	li	a7,1
ffffffffc0200560:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc0200564:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200566:	1101                	addi	sp,sp,-32
ffffffffc0200568:	ec06                	sd	ra,24(sp)
ffffffffc020056a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020056c:	39e000ef          	jal	ffffffffc020090a <intr_disable>
ffffffffc0200570:	6522                	ld	a0,8(sp)
ffffffffc0200572:	4581                	li	a1,0
ffffffffc0200574:	4601                	li	a2,0
ffffffffc0200576:	4885                	li	a7,1
ffffffffc0200578:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc020057c:	60e2                	ld	ra,24(sp)
ffffffffc020057e:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc0200580:	a651                	j	ffffffffc0200904 <intr_enable>

ffffffffc0200582 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0200582:	100027f3          	csrr	a5,sstatus
ffffffffc0200586:	8b89                	andi	a5,a5,2
ffffffffc0200588:	eb89                	bnez	a5,ffffffffc020059a <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc020058a:	4501                	li	a0,0
ffffffffc020058c:	4581                	li	a1,0
ffffffffc020058e:	4601                	li	a2,0
ffffffffc0200590:	4889                	li	a7,2
ffffffffc0200592:	00000073          	ecall
ffffffffc0200596:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc0200598:	8082                	ret
int cons_getc(void) {
ffffffffc020059a:	1101                	addi	sp,sp,-32
ffffffffc020059c:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc020059e:	36c000ef          	jal	ffffffffc020090a <intr_disable>
ffffffffc02005a2:	4501                	li	a0,0
ffffffffc02005a4:	4581                	li	a1,0
ffffffffc02005a6:	4601                	li	a2,0
ffffffffc02005a8:	4889                	li	a7,2
ffffffffc02005aa:	00000073          	ecall
ffffffffc02005ae:	2501                	sext.w	a0,a0
ffffffffc02005b0:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005b2:	352000ef          	jal	ffffffffc0200904 <intr_enable>
}
ffffffffc02005b6:	60e2                	ld	ra,24(sp)
ffffffffc02005b8:	6522                	ld	a0,8(sp)
ffffffffc02005ba:	6105                	addi	sp,sp,32
ffffffffc02005bc:	8082                	ret

ffffffffc02005be <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005be:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc02005c0:	00006517          	auipc	a0,0x6
ffffffffc02005c4:	f6050513          	addi	a0,a0,-160 # ffffffffc0206520 <etext+0x2b2>
void dtb_init(void) {
ffffffffc02005c8:	f406                	sd	ra,40(sp)
ffffffffc02005ca:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc02005cc:	bcdff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005d0:	0000c597          	auipc	a1,0xc
ffffffffc02005d4:	a305b583          	ld	a1,-1488(a1) # ffffffffc020c000 <boot_hartid>
ffffffffc02005d8:	00006517          	auipc	a0,0x6
ffffffffc02005dc:	f5850513          	addi	a0,a0,-168 # ffffffffc0206530 <etext+0x2c2>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005e0:	0000c417          	auipc	s0,0xc
ffffffffc02005e4:	a2840413          	addi	s0,s0,-1496 # ffffffffc020c008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005e8:	bb1ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005ec:	600c                	ld	a1,0(s0)
ffffffffc02005ee:	00006517          	auipc	a0,0x6
ffffffffc02005f2:	f5250513          	addi	a0,a0,-174 # ffffffffc0206540 <etext+0x2d2>
ffffffffc02005f6:	ba3ff0ef          	jal	ffffffffc0200198 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc02005fa:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc02005fc:	00006517          	auipc	a0,0x6
ffffffffc0200600:	f5c50513          	addi	a0,a0,-164 # ffffffffc0206558 <etext+0x2ea>
    if (boot_dtb == 0) {
ffffffffc0200604:	10070163          	beqz	a4,ffffffffc0200706 <dtb_init+0x148>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200608:	57f5                	li	a5,-3
ffffffffc020060a:	07fa                	slli	a5,a5,0x1e
ffffffffc020060c:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc020060e:	431c                	lw	a5,0(a4)
    if (magic != 0xd00dfeed) {
ffffffffc0200610:	d00e06b7          	lui	a3,0xd00e0
ffffffffc0200614:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfe2a87d>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200618:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020061c:	0187961b          	slliw	a2,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200620:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200624:	0ff5f593          	zext.b	a1,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200628:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020062c:	05c2                	slli	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020062e:	8e49                	or	a2,a2,a0
ffffffffc0200630:	0ff7f793          	zext.b	a5,a5
ffffffffc0200634:	8dd1                	or	a1,a1,a2
ffffffffc0200636:	07a2                	slli	a5,a5,0x8
ffffffffc0200638:	8ddd                	or	a1,a1,a5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020063a:	00ff0837          	lui	a6,0xff0
    if (magic != 0xd00dfeed) {
ffffffffc020063e:	0cd59863          	bne	a1,a3,ffffffffc020070e <dtb_init+0x150>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc0200642:	4710                	lw	a2,8(a4)
ffffffffc0200644:	4754                	lw	a3,12(a4)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200646:	e84a                	sd	s2,16(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200648:	0086541b          	srliw	s0,a2,0x8
ffffffffc020064c:	0086d79b          	srliw	a5,a3,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200650:	01865e1b          	srliw	t3,a2,0x18
ffffffffc0200654:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200658:	0186151b          	slliw	a0,a2,0x18
ffffffffc020065c:	0186959b          	slliw	a1,a3,0x18
ffffffffc0200660:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200664:	0106561b          	srliw	a2,a2,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200668:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020066c:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200670:	01c56533          	or	a0,a0,t3
ffffffffc0200674:	0115e5b3          	or	a1,a1,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200678:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020067c:	0ff67613          	zext.b	a2,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200680:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200684:	0ff6f693          	zext.b	a3,a3
ffffffffc0200688:	8c49                	or	s0,s0,a0
ffffffffc020068a:	0622                	slli	a2,a2,0x8
ffffffffc020068c:	8fcd                	or	a5,a5,a1
ffffffffc020068e:	06a2                	slli	a3,a3,0x8
ffffffffc0200690:	8c51                	or	s0,s0,a2
ffffffffc0200692:	8fd5                	or	a5,a5,a3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200694:	1402                	slli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200696:	1782                	slli	a5,a5,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200698:	9001                	srli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020069a:	9381                	srli	a5,a5,0x20
ffffffffc020069c:	ec26                	sd	s1,24(sp)
    int in_memory_node = 0;
ffffffffc020069e:	4301                	li	t1,0
        switch (token) {
ffffffffc02006a0:	488d                	li	a7,3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006a2:	943a                	add	s0,s0,a4
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006a4:	00e78933          	add	s2,a5,a4
        switch (token) {
ffffffffc02006a8:	4e05                	li	t3,1
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006aa:	4018                	lw	a4,0(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ac:	0087579b          	srliw	a5,a4,0x8
ffffffffc02006b0:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b4:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006b8:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006bc:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c0:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c4:	8ed1                	or	a3,a3,a2
ffffffffc02006c6:	0ff77713          	zext.b	a4,a4
ffffffffc02006ca:	8fd5                	or	a5,a5,a3
ffffffffc02006cc:	0722                	slli	a4,a4,0x8
ffffffffc02006ce:	8fd9                	or	a5,a5,a4
        switch (token) {
ffffffffc02006d0:	05178763          	beq	a5,a7,ffffffffc020071e <dtb_init+0x160>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006d4:	0411                	addi	s0,s0,4
        switch (token) {
ffffffffc02006d6:	00f8e963          	bltu	a7,a5,ffffffffc02006e8 <dtb_init+0x12a>
ffffffffc02006da:	07c78d63          	beq	a5,t3,ffffffffc0200754 <dtb_init+0x196>
ffffffffc02006de:	4709                	li	a4,2
ffffffffc02006e0:	00e79763          	bne	a5,a4,ffffffffc02006ee <dtb_init+0x130>
ffffffffc02006e4:	4301                	li	t1,0
ffffffffc02006e6:	b7d1                	j	ffffffffc02006aa <dtb_init+0xec>
ffffffffc02006e8:	4711                	li	a4,4
ffffffffc02006ea:	fce780e3          	beq	a5,a4,ffffffffc02006aa <dtb_init+0xec>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc02006ee:	00006517          	auipc	a0,0x6
ffffffffc02006f2:	f3250513          	addi	a0,a0,-206 # ffffffffc0206620 <etext+0x3b2>
ffffffffc02006f6:	aa3ff0ef          	jal	ffffffffc0200198 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02006fa:	64e2                	ld	s1,24(sp)
ffffffffc02006fc:	6942                	ld	s2,16(sp)
ffffffffc02006fe:	00006517          	auipc	a0,0x6
ffffffffc0200702:	f5a50513          	addi	a0,a0,-166 # ffffffffc0206658 <etext+0x3ea>
}
ffffffffc0200706:	7402                	ld	s0,32(sp)
ffffffffc0200708:	70a2                	ld	ra,40(sp)
ffffffffc020070a:	6145                	addi	sp,sp,48
    cprintf("DTB init completed\n");
ffffffffc020070c:	b471                	j	ffffffffc0200198 <cprintf>
}
ffffffffc020070e:	7402                	ld	s0,32(sp)
ffffffffc0200710:	70a2                	ld	ra,40(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200712:	00006517          	auipc	a0,0x6
ffffffffc0200716:	e6650513          	addi	a0,a0,-410 # ffffffffc0206578 <etext+0x30a>
}
ffffffffc020071a:	6145                	addi	sp,sp,48
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc020071c:	bcb5                	j	ffffffffc0200198 <cprintf>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc020071e:	4058                	lw	a4,4(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200720:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200724:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200728:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020072c:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200730:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200734:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200738:	8ed1                	or	a3,a3,a2
ffffffffc020073a:	0ff77713          	zext.b	a4,a4
ffffffffc020073e:	8fd5                	or	a5,a5,a3
ffffffffc0200740:	0722                	slli	a4,a4,0x8
ffffffffc0200742:	8fd9                	or	a5,a5,a4
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200744:	04031463          	bnez	t1,ffffffffc020078c <dtb_init+0x1ce>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200748:	1782                	slli	a5,a5,0x20
ffffffffc020074a:	9381                	srli	a5,a5,0x20
ffffffffc020074c:	043d                	addi	s0,s0,15
ffffffffc020074e:	943e                	add	s0,s0,a5
ffffffffc0200750:	9871                	andi	s0,s0,-4
                break;
ffffffffc0200752:	bfa1                	j	ffffffffc02006aa <dtb_init+0xec>
                int name_len = strlen(name);
ffffffffc0200754:	8522                	mv	a0,s0
ffffffffc0200756:	e01a                	sd	t1,0(sp)
ffffffffc0200758:	239050ef          	jal	ffffffffc0206190 <strlen>
ffffffffc020075c:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020075e:	4619                	li	a2,6
ffffffffc0200760:	8522                	mv	a0,s0
ffffffffc0200762:	00006597          	auipc	a1,0x6
ffffffffc0200766:	e3e58593          	addi	a1,a1,-450 # ffffffffc02065a0 <etext+0x332>
ffffffffc020076a:	2a1050ef          	jal	ffffffffc020620a <strncmp>
ffffffffc020076e:	6302                	ld	t1,0(sp)
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200770:	0411                	addi	s0,s0,4
ffffffffc0200772:	0004879b          	sext.w	a5,s1
ffffffffc0200776:	943e                	add	s0,s0,a5
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200778:	00153513          	seqz	a0,a0
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc020077c:	9871                	andi	s0,s0,-4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020077e:	00a36333          	or	t1,t1,a0
                break;
ffffffffc0200782:	00ff0837          	lui	a6,0xff0
ffffffffc0200786:	488d                	li	a7,3
ffffffffc0200788:	4e05                	li	t3,1
ffffffffc020078a:	b705                	j	ffffffffc02006aa <dtb_init+0xec>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020078c:	4418                	lw	a4,8(s0)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020078e:	00006597          	auipc	a1,0x6
ffffffffc0200792:	e1a58593          	addi	a1,a1,-486 # ffffffffc02065a8 <etext+0x33a>
ffffffffc0200796:	e43e                	sd	a5,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200798:	0087551b          	srliw	a0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020079c:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007a0:	0187169b          	slliw	a3,a4,0x18
ffffffffc02007a4:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007a8:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007ac:	01057533          	and	a0,a0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007b0:	8ed1                	or	a3,a3,a2
ffffffffc02007b2:	0ff77713          	zext.b	a4,a4
ffffffffc02007b6:	0722                	slli	a4,a4,0x8
ffffffffc02007b8:	8d55                	or	a0,a0,a3
ffffffffc02007ba:	8d59                	or	a0,a0,a4
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc02007bc:	1502                	slli	a0,a0,0x20
ffffffffc02007be:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02007c0:	954a                	add	a0,a0,s2
ffffffffc02007c2:	e01a                	sd	t1,0(sp)
ffffffffc02007c4:	213050ef          	jal	ffffffffc02061d6 <strcmp>
ffffffffc02007c8:	67a2                	ld	a5,8(sp)
ffffffffc02007ca:	473d                	li	a4,15
ffffffffc02007cc:	6302                	ld	t1,0(sp)
ffffffffc02007ce:	00ff0837          	lui	a6,0xff0
ffffffffc02007d2:	488d                	li	a7,3
ffffffffc02007d4:	4e05                	li	t3,1
ffffffffc02007d6:	f6f779e3          	bgeu	a4,a5,ffffffffc0200748 <dtb_init+0x18a>
ffffffffc02007da:	f53d                	bnez	a0,ffffffffc0200748 <dtb_init+0x18a>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02007dc:	00c43683          	ld	a3,12(s0)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02007e0:	01443703          	ld	a4,20(s0)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02007e4:	00006517          	auipc	a0,0x6
ffffffffc02007e8:	dcc50513          	addi	a0,a0,-564 # ffffffffc02065b0 <etext+0x342>
           fdt32_to_cpu(x >> 32);
ffffffffc02007ec:	4206d793          	srai	a5,a3,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007f0:	0087d31b          	srliw	t1,a5,0x8
ffffffffc02007f4:	00871f93          	slli	t6,a4,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02007f8:	42075893          	srai	a7,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007fc:	0187df1b          	srliw	t5,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200800:	0187959b          	slliw	a1,a5,0x18
ffffffffc0200804:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200808:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020080c:	420fd613          	srai	a2,t6,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200810:	0188de9b          	srliw	t4,a7,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200814:	01037333          	and	t1,t1,a6
ffffffffc0200818:	01889e1b          	slliw	t3,a7,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020081c:	01e5e5b3          	or	a1,a1,t5
ffffffffc0200820:	0ff7f793          	zext.b	a5,a5
ffffffffc0200824:	01de6e33          	or	t3,t3,t4
ffffffffc0200828:	0065e5b3          	or	a1,a1,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020082c:	01067633          	and	a2,a2,a6
ffffffffc0200830:	0086d31b          	srliw	t1,a3,0x8
ffffffffc0200834:	0087541b          	srliw	s0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200838:	07a2                	slli	a5,a5,0x8
ffffffffc020083a:	0108d89b          	srliw	a7,a7,0x10
ffffffffc020083e:	0186df1b          	srliw	t5,a3,0x18
ffffffffc0200842:	01875e9b          	srliw	t4,a4,0x18
ffffffffc0200846:	8ddd                	or	a1,a1,a5
ffffffffc0200848:	01c66633          	or	a2,a2,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020084c:	0186979b          	slliw	a5,a3,0x18
ffffffffc0200850:	01871e1b          	slliw	t3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200854:	0ff8f893          	zext.b	a7,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200858:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020085c:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200860:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200864:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200868:	01037333          	and	t1,t1,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020086c:	08a2                	slli	a7,a7,0x8
ffffffffc020086e:	01e7e7b3          	or	a5,a5,t5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200872:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200876:	0ff6f693          	zext.b	a3,a3
ffffffffc020087a:	01de6833          	or	a6,t3,t4
ffffffffc020087e:	0ff77713          	zext.b	a4,a4
ffffffffc0200882:	01166633          	or	a2,a2,a7
ffffffffc0200886:	0067e7b3          	or	a5,a5,t1
ffffffffc020088a:	06a2                	slli	a3,a3,0x8
ffffffffc020088c:	01046433          	or	s0,s0,a6
ffffffffc0200890:	0722                	slli	a4,a4,0x8
ffffffffc0200892:	8fd5                	or	a5,a5,a3
ffffffffc0200894:	8c59                	or	s0,s0,a4
           fdt32_to_cpu(x >> 32);
ffffffffc0200896:	1582                	slli	a1,a1,0x20
ffffffffc0200898:	1602                	slli	a2,a2,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020089a:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020089c:	9201                	srli	a2,a2,0x20
ffffffffc020089e:	9181                	srli	a1,a1,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02008a0:	1402                	slli	s0,s0,0x20
ffffffffc02008a2:	00b7e4b3          	or	s1,a5,a1
ffffffffc02008a6:	8c51                	or	s0,s0,a2
        cprintf("Physical Memory from DTB:\n");
ffffffffc02008a8:	8f1ff0ef          	jal	ffffffffc0200198 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc02008ac:	85a6                	mv	a1,s1
ffffffffc02008ae:	00006517          	auipc	a0,0x6
ffffffffc02008b2:	d2250513          	addi	a0,a0,-734 # ffffffffc02065d0 <etext+0x362>
ffffffffc02008b6:	8e3ff0ef          	jal	ffffffffc0200198 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc02008ba:	01445613          	srli	a2,s0,0x14
ffffffffc02008be:	85a2                	mv	a1,s0
ffffffffc02008c0:	00006517          	auipc	a0,0x6
ffffffffc02008c4:	d2850513          	addi	a0,a0,-728 # ffffffffc02065e8 <etext+0x37a>
ffffffffc02008c8:	8d1ff0ef          	jal	ffffffffc0200198 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02008cc:	009405b3          	add	a1,s0,s1
ffffffffc02008d0:	15fd                	addi	a1,a1,-1
ffffffffc02008d2:	00006517          	auipc	a0,0x6
ffffffffc02008d6:	d3650513          	addi	a0,a0,-714 # ffffffffc0206608 <etext+0x39a>
ffffffffc02008da:	8bfff0ef          	jal	ffffffffc0200198 <cprintf>
        memory_base = mem_base;
ffffffffc02008de:	000b5797          	auipc	a5,0xb5
ffffffffc02008e2:	d097bd23          	sd	s1,-742(a5) # ffffffffc02b55f8 <memory_base>
        memory_size = mem_size;
ffffffffc02008e6:	000b5797          	auipc	a5,0xb5
ffffffffc02008ea:	d087b523          	sd	s0,-758(a5) # ffffffffc02b55f0 <memory_size>
ffffffffc02008ee:	b531                	j	ffffffffc02006fa <dtb_init+0x13c>

ffffffffc02008f0 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02008f0:	000b5517          	auipc	a0,0xb5
ffffffffc02008f4:	d0853503          	ld	a0,-760(a0) # ffffffffc02b55f8 <memory_base>
ffffffffc02008f8:	8082                	ret

ffffffffc02008fa <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02008fa:	000b5517          	auipc	a0,0xb5
ffffffffc02008fe:	cf653503          	ld	a0,-778(a0) # ffffffffc02b55f0 <memory_size>
ffffffffc0200902:	8082                	ret

ffffffffc0200904 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200904:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200908:	8082                	ret

ffffffffc020090a <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc020090a:	100177f3          	csrrci	a5,sstatus,2
ffffffffc020090e:	8082                	ret

ffffffffc0200910 <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc0200910:	8082                	ret

ffffffffc0200912 <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc0200912:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200916:	00000797          	auipc	a5,0x0
ffffffffc020091a:	4b678793          	addi	a5,a5,1206 # ffffffffc0200dcc <__alltraps>
ffffffffc020091e:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc0200922:	000407b7          	lui	a5,0x40
ffffffffc0200926:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc020092a:	8082                	ret

ffffffffc020092c <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020092c:	610c                	ld	a1,0(a0)
{
ffffffffc020092e:	1141                	addi	sp,sp,-16
ffffffffc0200930:	e022                	sd	s0,0(sp)
ffffffffc0200932:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200934:	00006517          	auipc	a0,0x6
ffffffffc0200938:	d3c50513          	addi	a0,a0,-708 # ffffffffc0206670 <etext+0x402>
{
ffffffffc020093c:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020093e:	85bff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200942:	640c                	ld	a1,8(s0)
ffffffffc0200944:	00006517          	auipc	a0,0x6
ffffffffc0200948:	d4450513          	addi	a0,a0,-700 # ffffffffc0206688 <etext+0x41a>
ffffffffc020094c:	84dff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc0200950:	680c                	ld	a1,16(s0)
ffffffffc0200952:	00006517          	auipc	a0,0x6
ffffffffc0200956:	d4e50513          	addi	a0,a0,-690 # ffffffffc02066a0 <etext+0x432>
ffffffffc020095a:	83fff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc020095e:	6c0c                	ld	a1,24(s0)
ffffffffc0200960:	00006517          	auipc	a0,0x6
ffffffffc0200964:	d5850513          	addi	a0,a0,-680 # ffffffffc02066b8 <etext+0x44a>
ffffffffc0200968:	831ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc020096c:	700c                	ld	a1,32(s0)
ffffffffc020096e:	00006517          	auipc	a0,0x6
ffffffffc0200972:	d6250513          	addi	a0,a0,-670 # ffffffffc02066d0 <etext+0x462>
ffffffffc0200976:	823ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc020097a:	740c                	ld	a1,40(s0)
ffffffffc020097c:	00006517          	auipc	a0,0x6
ffffffffc0200980:	d6c50513          	addi	a0,a0,-660 # ffffffffc02066e8 <etext+0x47a>
ffffffffc0200984:	815ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200988:	780c                	ld	a1,48(s0)
ffffffffc020098a:	00006517          	auipc	a0,0x6
ffffffffc020098e:	d7650513          	addi	a0,a0,-650 # ffffffffc0206700 <etext+0x492>
ffffffffc0200992:	807ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200996:	7c0c                	ld	a1,56(s0)
ffffffffc0200998:	00006517          	auipc	a0,0x6
ffffffffc020099c:	d8050513          	addi	a0,a0,-640 # ffffffffc0206718 <etext+0x4aa>
ffffffffc02009a0:	ff8ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02009a4:	602c                	ld	a1,64(s0)
ffffffffc02009a6:	00006517          	auipc	a0,0x6
ffffffffc02009aa:	d8a50513          	addi	a0,a0,-630 # ffffffffc0206730 <etext+0x4c2>
ffffffffc02009ae:	feaff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02009b2:	642c                	ld	a1,72(s0)
ffffffffc02009b4:	00006517          	auipc	a0,0x6
ffffffffc02009b8:	d9450513          	addi	a0,a0,-620 # ffffffffc0206748 <etext+0x4da>
ffffffffc02009bc:	fdcff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02009c0:	682c                	ld	a1,80(s0)
ffffffffc02009c2:	00006517          	auipc	a0,0x6
ffffffffc02009c6:	d9e50513          	addi	a0,a0,-610 # ffffffffc0206760 <etext+0x4f2>
ffffffffc02009ca:	fceff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02009ce:	6c2c                	ld	a1,88(s0)
ffffffffc02009d0:	00006517          	auipc	a0,0x6
ffffffffc02009d4:	da850513          	addi	a0,a0,-600 # ffffffffc0206778 <etext+0x50a>
ffffffffc02009d8:	fc0ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc02009dc:	702c                	ld	a1,96(s0)
ffffffffc02009de:	00006517          	auipc	a0,0x6
ffffffffc02009e2:	db250513          	addi	a0,a0,-590 # ffffffffc0206790 <etext+0x522>
ffffffffc02009e6:	fb2ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc02009ea:	742c                	ld	a1,104(s0)
ffffffffc02009ec:	00006517          	auipc	a0,0x6
ffffffffc02009f0:	dbc50513          	addi	a0,a0,-580 # ffffffffc02067a8 <etext+0x53a>
ffffffffc02009f4:	fa4ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc02009f8:	782c                	ld	a1,112(s0)
ffffffffc02009fa:	00006517          	auipc	a0,0x6
ffffffffc02009fe:	dc650513          	addi	a0,a0,-570 # ffffffffc02067c0 <etext+0x552>
ffffffffc0200a02:	f96ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200a06:	7c2c                	ld	a1,120(s0)
ffffffffc0200a08:	00006517          	auipc	a0,0x6
ffffffffc0200a0c:	dd050513          	addi	a0,a0,-560 # ffffffffc02067d8 <etext+0x56a>
ffffffffc0200a10:	f88ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200a14:	604c                	ld	a1,128(s0)
ffffffffc0200a16:	00006517          	auipc	a0,0x6
ffffffffc0200a1a:	dda50513          	addi	a0,a0,-550 # ffffffffc02067f0 <etext+0x582>
ffffffffc0200a1e:	f7aff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200a22:	644c                	ld	a1,136(s0)
ffffffffc0200a24:	00006517          	auipc	a0,0x6
ffffffffc0200a28:	de450513          	addi	a0,a0,-540 # ffffffffc0206808 <etext+0x59a>
ffffffffc0200a2c:	f6cff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200a30:	684c                	ld	a1,144(s0)
ffffffffc0200a32:	00006517          	auipc	a0,0x6
ffffffffc0200a36:	dee50513          	addi	a0,a0,-530 # ffffffffc0206820 <etext+0x5b2>
ffffffffc0200a3a:	f5eff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200a3e:	6c4c                	ld	a1,152(s0)
ffffffffc0200a40:	00006517          	auipc	a0,0x6
ffffffffc0200a44:	df850513          	addi	a0,a0,-520 # ffffffffc0206838 <etext+0x5ca>
ffffffffc0200a48:	f50ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200a4c:	704c                	ld	a1,160(s0)
ffffffffc0200a4e:	00006517          	auipc	a0,0x6
ffffffffc0200a52:	e0250513          	addi	a0,a0,-510 # ffffffffc0206850 <etext+0x5e2>
ffffffffc0200a56:	f42ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200a5a:	744c                	ld	a1,168(s0)
ffffffffc0200a5c:	00006517          	auipc	a0,0x6
ffffffffc0200a60:	e0c50513          	addi	a0,a0,-500 # ffffffffc0206868 <etext+0x5fa>
ffffffffc0200a64:	f34ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200a68:	784c                	ld	a1,176(s0)
ffffffffc0200a6a:	00006517          	auipc	a0,0x6
ffffffffc0200a6e:	e1650513          	addi	a0,a0,-490 # ffffffffc0206880 <etext+0x612>
ffffffffc0200a72:	f26ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200a76:	7c4c                	ld	a1,184(s0)
ffffffffc0200a78:	00006517          	auipc	a0,0x6
ffffffffc0200a7c:	e2050513          	addi	a0,a0,-480 # ffffffffc0206898 <etext+0x62a>
ffffffffc0200a80:	f18ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200a84:	606c                	ld	a1,192(s0)
ffffffffc0200a86:	00006517          	auipc	a0,0x6
ffffffffc0200a8a:	e2a50513          	addi	a0,a0,-470 # ffffffffc02068b0 <etext+0x642>
ffffffffc0200a8e:	f0aff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200a92:	646c                	ld	a1,200(s0)
ffffffffc0200a94:	00006517          	auipc	a0,0x6
ffffffffc0200a98:	e3450513          	addi	a0,a0,-460 # ffffffffc02068c8 <etext+0x65a>
ffffffffc0200a9c:	efcff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200aa0:	686c                	ld	a1,208(s0)
ffffffffc0200aa2:	00006517          	auipc	a0,0x6
ffffffffc0200aa6:	e3e50513          	addi	a0,a0,-450 # ffffffffc02068e0 <etext+0x672>
ffffffffc0200aaa:	eeeff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200aae:	6c6c                	ld	a1,216(s0)
ffffffffc0200ab0:	00006517          	auipc	a0,0x6
ffffffffc0200ab4:	e4850513          	addi	a0,a0,-440 # ffffffffc02068f8 <etext+0x68a>
ffffffffc0200ab8:	ee0ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200abc:	706c                	ld	a1,224(s0)
ffffffffc0200abe:	00006517          	auipc	a0,0x6
ffffffffc0200ac2:	e5250513          	addi	a0,a0,-430 # ffffffffc0206910 <etext+0x6a2>
ffffffffc0200ac6:	ed2ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200aca:	746c                	ld	a1,232(s0)
ffffffffc0200acc:	00006517          	auipc	a0,0x6
ffffffffc0200ad0:	e5c50513          	addi	a0,a0,-420 # ffffffffc0206928 <etext+0x6ba>
ffffffffc0200ad4:	ec4ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200ad8:	786c                	ld	a1,240(s0)
ffffffffc0200ada:	00006517          	auipc	a0,0x6
ffffffffc0200ade:	e6650513          	addi	a0,a0,-410 # ffffffffc0206940 <etext+0x6d2>
ffffffffc0200ae2:	eb6ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ae6:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200ae8:	6402                	ld	s0,0(sp)
ffffffffc0200aea:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200aec:	00006517          	auipc	a0,0x6
ffffffffc0200af0:	e6c50513          	addi	a0,a0,-404 # ffffffffc0206958 <etext+0x6ea>
}
ffffffffc0200af4:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200af6:	ea2ff06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0200afa <print_trapframe>:
{
ffffffffc0200afa:	1141                	addi	sp,sp,-16
ffffffffc0200afc:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200afe:	85aa                	mv	a1,a0
{
ffffffffc0200b00:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b02:	00006517          	auipc	a0,0x6
ffffffffc0200b06:	e6e50513          	addi	a0,a0,-402 # ffffffffc0206970 <etext+0x702>
{
ffffffffc0200b0a:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b0c:	e8cff0ef          	jal	ffffffffc0200198 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200b10:	8522                	mv	a0,s0
ffffffffc0200b12:	e1bff0ef          	jal	ffffffffc020092c <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200b16:	10043583          	ld	a1,256(s0)
ffffffffc0200b1a:	00006517          	auipc	a0,0x6
ffffffffc0200b1e:	e6e50513          	addi	a0,a0,-402 # ffffffffc0206988 <etext+0x71a>
ffffffffc0200b22:	e76ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200b26:	10843583          	ld	a1,264(s0)
ffffffffc0200b2a:	00006517          	auipc	a0,0x6
ffffffffc0200b2e:	e7650513          	addi	a0,a0,-394 # ffffffffc02069a0 <etext+0x732>
ffffffffc0200b32:	e66ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200b36:	11043583          	ld	a1,272(s0)
ffffffffc0200b3a:	00006517          	auipc	a0,0x6
ffffffffc0200b3e:	e7e50513          	addi	a0,a0,-386 # ffffffffc02069b8 <etext+0x74a>
ffffffffc0200b42:	e56ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b46:	11843583          	ld	a1,280(s0)
}
ffffffffc0200b4a:	6402                	ld	s0,0(sp)
ffffffffc0200b4c:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b4e:	00006517          	auipc	a0,0x6
ffffffffc0200b52:	e7a50513          	addi	a0,a0,-390 # ffffffffc02069c8 <etext+0x75a>
}
ffffffffc0200b56:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b58:	e40ff06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0200b5c <interrupt_handler>:
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause)
ffffffffc0200b5c:	11853783          	ld	a5,280(a0)
ffffffffc0200b60:	472d                	li	a4,11
ffffffffc0200b62:	0786                	slli	a5,a5,0x1
ffffffffc0200b64:	8385                	srli	a5,a5,0x1
ffffffffc0200b66:	08f76463          	bltu	a4,a5,ffffffffc0200bee <interrupt_handler+0x92>
ffffffffc0200b6a:	00007717          	auipc	a4,0x7
ffffffffc0200b6e:	4ce70713          	addi	a4,a4,1230 # ffffffffc0208038 <commands+0x48>
ffffffffc0200b72:	078a                	slli	a5,a5,0x2
ffffffffc0200b74:	97ba                	add	a5,a5,a4
ffffffffc0200b76:	439c                	lw	a5,0(a5)
ffffffffc0200b78:	97ba                	add	a5,a5,a4
ffffffffc0200b7a:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200b7c:	00006517          	auipc	a0,0x6
ffffffffc0200b80:	ec450513          	addi	a0,a0,-316 # ffffffffc0206a40 <etext+0x7d2>
ffffffffc0200b84:	e14ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200b88:	00006517          	auipc	a0,0x6
ffffffffc0200b8c:	e9850513          	addi	a0,a0,-360 # ffffffffc0206a20 <etext+0x7b2>
ffffffffc0200b90:	e08ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200b94:	00006517          	auipc	a0,0x6
ffffffffc0200b98:	e4c50513          	addi	a0,a0,-436 # ffffffffc02069e0 <etext+0x772>
ffffffffc0200b9c:	dfcff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200ba0:	00006517          	auipc	a0,0x6
ffffffffc0200ba4:	e6050513          	addi	a0,a0,-416 # ffffffffc0206a00 <etext+0x792>
ffffffffc0200ba8:	df0ff06f          	j	ffffffffc0200198 <cprintf>
{
ffffffffc0200bac:	1141                	addi	sp,sp,-16
ffffffffc0200bae:	e406                	sd	ra,8(sp)
         * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
         */
        {
            static int ticks = 0;
            static int num = 0;
            clock_set_next_event();
ffffffffc0200bb0:	935ff0ef          	jal	ffffffffc02004e4 <clock_set_next_event>
            ticks++;
ffffffffc0200bb4:	000b5797          	auipc	a5,0xb5
ffffffffc0200bb8:	a4c7a783          	lw	a5,-1460(a5) # ffffffffc02b5600 <ticks.1>
            if (ticks == 500) {
ffffffffc0200bbc:	1f400713          	li	a4,500
            ticks++;
ffffffffc0200bc0:	2785                	addiw	a5,a5,1
ffffffffc0200bc2:	000b5697          	auipc	a3,0xb5
ffffffffc0200bc6:	a2f6af23          	sw	a5,-1474(a3) # ffffffffc02b5600 <ticks.1>
            if (ticks == 500) {
ffffffffc0200bca:	02e78363          	beq	a5,a4,ffffffffc0200bf0 <interrupt_handler+0x94>
            }
        }

        // lab6: YOUR CODE  (update LAB3 steps)
        //  在时钟中断时调用调度器的 sched_class_proc_tick 函数
        clock_intr();
ffffffffc0200bce:	92fff0ef          	jal	ffffffffc02004fc <clock_intr>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200bd2:	60a2                	ld	ra,8(sp)
        sched_class_proc_tick(current);
ffffffffc0200bd4:	000b5517          	auipc	a0,0xb5
ffffffffc0200bd8:	a7453503          	ld	a0,-1420(a0) # ffffffffc02b5648 <current>
}
ffffffffc0200bdc:	0141                	addi	sp,sp,16
        sched_class_proc_tick(current);
ffffffffc0200bde:	6ff0406f          	j	ffffffffc0205adc <sched_class_proc_tick>
        cprintf("Supervisor external interrupt\n");
ffffffffc0200be2:	00006517          	auipc	a0,0x6
ffffffffc0200be6:	ece50513          	addi	a0,a0,-306 # ffffffffc0206ab0 <etext+0x842>
ffffffffc0200bea:	daeff06f          	j	ffffffffc0200198 <cprintf>
        print_trapframe(tf);
ffffffffc0200bee:	b731                	j	ffffffffc0200afa <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200bf0:	6585                	lui	a1,0x1
ffffffffc0200bf2:	38858593          	addi	a1,a1,904 # 1388 <_binary_obj___user_softint_out_size-0x7ba0>
ffffffffc0200bf6:	00006517          	auipc	a0,0x6
ffffffffc0200bfa:	e6a50513          	addi	a0,a0,-406 # ffffffffc0206a60 <etext+0x7f2>
ffffffffc0200bfe:	d9aff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("End of Test.\n");
ffffffffc0200c02:	00006517          	auipc	a0,0x6
ffffffffc0200c06:	e6e50513          	addi	a0,a0,-402 # ffffffffc0206a70 <etext+0x802>
ffffffffc0200c0a:	d8eff0ef          	jal	ffffffffc0200198 <cprintf>
    panic("EOT: kernel seems ok.");
ffffffffc0200c0e:	00006617          	auipc	a2,0x6
ffffffffc0200c12:	e7260613          	addi	a2,a2,-398 # ffffffffc0206a80 <etext+0x812>
ffffffffc0200c16:	45ed                	li	a1,27
ffffffffc0200c18:	00006517          	auipc	a0,0x6
ffffffffc0200c1c:	e8050513          	addi	a0,a0,-384 # ffffffffc0206a98 <etext+0x82a>
ffffffffc0200c20:	82bff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200c24 <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200c24:	11853783          	ld	a5,280(a0)
ffffffffc0200c28:	473d                	li	a4,15
ffffffffc0200c2a:	10f76e63          	bltu	a4,a5,ffffffffc0200d46 <exception_handler+0x122>
ffffffffc0200c2e:	00007717          	auipc	a4,0x7
ffffffffc0200c32:	43a70713          	addi	a4,a4,1082 # ffffffffc0208068 <commands+0x78>
ffffffffc0200c36:	078a                	slli	a5,a5,0x2
ffffffffc0200c38:	97ba                	add	a5,a5,a4
ffffffffc0200c3a:	439c                	lw	a5,0(a5)
{
ffffffffc0200c3c:	1101                	addi	sp,sp,-32
ffffffffc0200c3e:	ec06                	sd	ra,24(sp)
    switch (tf->cause)
ffffffffc0200c40:	97ba                	add	a5,a5,a4
ffffffffc0200c42:	86aa                	mv	a3,a0
ffffffffc0200c44:	8782                	jr	a5
ffffffffc0200c46:	e42a                	sd	a0,8(sp)
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200c48:	00006517          	auipc	a0,0x6
ffffffffc0200c4c:	f5850513          	addi	a0,a0,-168 # ffffffffc0206ba0 <etext+0x932>
ffffffffc0200c50:	d48ff0ef          	jal	ffffffffc0200198 <cprintf>
        tf->epc += 4;
ffffffffc0200c54:	66a2                	ld	a3,8(sp)
ffffffffc0200c56:	1086b783          	ld	a5,264(a3)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c5a:	60e2                	ld	ra,24(sp)
        tf->epc += 4;
ffffffffc0200c5c:	0791                	addi	a5,a5,4
ffffffffc0200c5e:	10f6b423          	sd	a5,264(a3)
}
ffffffffc0200c62:	6105                	addi	sp,sp,32
        syscall();
ffffffffc0200c64:	0cc0506f          	j	ffffffffc0205d30 <syscall>
}
ffffffffc0200c68:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from H-mode\n");
ffffffffc0200c6a:	00006517          	auipc	a0,0x6
ffffffffc0200c6e:	f5650513          	addi	a0,a0,-170 # ffffffffc0206bc0 <etext+0x952>
}
ffffffffc0200c72:	6105                	addi	sp,sp,32
        cprintf("Environment call from H-mode\n");
ffffffffc0200c74:	d24ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c78:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from M-mode\n");
ffffffffc0200c7a:	00006517          	auipc	a0,0x6
ffffffffc0200c7e:	f6650513          	addi	a0,a0,-154 # ffffffffc0206be0 <etext+0x972>
}
ffffffffc0200c82:	6105                	addi	sp,sp,32
        cprintf("Environment call from M-mode\n");
ffffffffc0200c84:	d14ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c88:	60e2                	ld	ra,24(sp)
        cprintf("Instruction page fault\n");
ffffffffc0200c8a:	00006517          	auipc	a0,0x6
ffffffffc0200c8e:	f7650513          	addi	a0,a0,-138 # ffffffffc0206c00 <etext+0x992>
}
ffffffffc0200c92:	6105                	addi	sp,sp,32
        cprintf("Instruction page fault\n");
ffffffffc0200c94:	d04ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c98:	60e2                	ld	ra,24(sp)
        cprintf("Load page fault\n");
ffffffffc0200c9a:	00006517          	auipc	a0,0x6
ffffffffc0200c9e:	f7e50513          	addi	a0,a0,-130 # ffffffffc0206c18 <etext+0x9aa>
}
ffffffffc0200ca2:	6105                	addi	sp,sp,32
        cprintf("Load page fault\n");
ffffffffc0200ca4:	cf4ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200ca8:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO page fault\n");
ffffffffc0200caa:	00006517          	auipc	a0,0x6
ffffffffc0200cae:	f8650513          	addi	a0,a0,-122 # ffffffffc0206c30 <etext+0x9c2>
}
ffffffffc0200cb2:	6105                	addi	sp,sp,32
        cprintf("Store/AMO page fault\n");
ffffffffc0200cb4:	ce4ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200cb8:	60e2                	ld	ra,24(sp)
        cprintf("Instruction address misaligned\n");
ffffffffc0200cba:	00006517          	auipc	a0,0x6
ffffffffc0200cbe:	e1650513          	addi	a0,a0,-490 # ffffffffc0206ad0 <etext+0x862>
}
ffffffffc0200cc2:	6105                	addi	sp,sp,32
        cprintf("Instruction address misaligned\n");
ffffffffc0200cc4:	cd4ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200cc8:	60e2                	ld	ra,24(sp)
        cprintf("Instruction access fault\n");
ffffffffc0200cca:	00006517          	auipc	a0,0x6
ffffffffc0200cce:	e2650513          	addi	a0,a0,-474 # ffffffffc0206af0 <etext+0x882>
}
ffffffffc0200cd2:	6105                	addi	sp,sp,32
        cprintf("Instruction access fault\n");
ffffffffc0200cd4:	cc4ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200cd8:	60e2                	ld	ra,24(sp)
        cprintf("Illegal instruction\n");
ffffffffc0200cda:	00006517          	auipc	a0,0x6
ffffffffc0200cde:	e3650513          	addi	a0,a0,-458 # ffffffffc0206b10 <etext+0x8a2>
}
ffffffffc0200ce2:	6105                	addi	sp,sp,32
        cprintf("Illegal instruction\n");
ffffffffc0200ce4:	cb4ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200ce8:	60e2                	ld	ra,24(sp)
        cprintf("Breakpoint\n");
ffffffffc0200cea:	00006517          	auipc	a0,0x6
ffffffffc0200cee:	e3e50513          	addi	a0,a0,-450 # ffffffffc0206b28 <etext+0x8ba>
}
ffffffffc0200cf2:	6105                	addi	sp,sp,32
        cprintf("Breakpoint\n");
ffffffffc0200cf4:	ca4ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200cf8:	60e2                	ld	ra,24(sp)
        cprintf("Load address misaligned\n");
ffffffffc0200cfa:	00006517          	auipc	a0,0x6
ffffffffc0200cfe:	e3e50513          	addi	a0,a0,-450 # ffffffffc0206b38 <etext+0x8ca>
}
ffffffffc0200d02:	6105                	addi	sp,sp,32
        cprintf("Load address misaligned\n");
ffffffffc0200d04:	c94ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200d08:	60e2                	ld	ra,24(sp)
        cprintf("Load access fault\n");
ffffffffc0200d0a:	00006517          	auipc	a0,0x6
ffffffffc0200d0e:	e4e50513          	addi	a0,a0,-434 # ffffffffc0206b58 <etext+0x8ea>
}
ffffffffc0200d12:	6105                	addi	sp,sp,32
        cprintf("Load access fault\n");
ffffffffc0200d14:	c84ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200d18:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO access fault\n");
ffffffffc0200d1a:	00006517          	auipc	a0,0x6
ffffffffc0200d1e:	e6e50513          	addi	a0,a0,-402 # ffffffffc0206b88 <etext+0x91a>
}
ffffffffc0200d22:	6105                	addi	sp,sp,32
        cprintf("Store/AMO access fault\n");
ffffffffc0200d24:	c74ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200d28:	60e2                	ld	ra,24(sp)
ffffffffc0200d2a:	6105                	addi	sp,sp,32
        print_trapframe(tf);
ffffffffc0200d2c:	b3f9                	j	ffffffffc0200afa <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200d2e:	00006617          	auipc	a2,0x6
ffffffffc0200d32:	e4260613          	addi	a2,a2,-446 # ffffffffc0206b70 <etext+0x902>
ffffffffc0200d36:	0c800593          	li	a1,200
ffffffffc0200d3a:	00006517          	auipc	a0,0x6
ffffffffc0200d3e:	d5e50513          	addi	a0,a0,-674 # ffffffffc0206a98 <etext+0x82a>
ffffffffc0200d42:	f08ff0ef          	jal	ffffffffc020044a <__panic>
        print_trapframe(tf);
ffffffffc0200d46:	bb55                	j	ffffffffc0200afa <print_trapframe>

ffffffffc0200d48 <trap>:
 * */
void trap(struct trapframe *tf)
{
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200d48:	000b5717          	auipc	a4,0xb5
ffffffffc0200d4c:	90073703          	ld	a4,-1792(a4) # ffffffffc02b5648 <current>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200d50:	11853583          	ld	a1,280(a0)
    if (current == NULL)
ffffffffc0200d54:	cf21                	beqz	a4,ffffffffc0200dac <trap+0x64>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200d56:	10053603          	ld	a2,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200d5a:	0a073803          	ld	a6,160(a4)
{
ffffffffc0200d5e:	1101                	addi	sp,sp,-32
ffffffffc0200d60:	ec06                	sd	ra,24(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200d62:	10067613          	andi	a2,a2,256
        current->tf = tf;
ffffffffc0200d66:	f348                	sd	a0,160(a4)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200d68:	e432                	sd	a2,8(sp)
ffffffffc0200d6a:	e042                	sd	a6,0(sp)
ffffffffc0200d6c:	0205c763          	bltz	a1,ffffffffc0200d9a <trap+0x52>
        exception_handler(tf);
ffffffffc0200d70:	eb5ff0ef          	jal	ffffffffc0200c24 <exception_handler>
ffffffffc0200d74:	6622                	ld	a2,8(sp)
ffffffffc0200d76:	6802                	ld	a6,0(sp)
ffffffffc0200d78:	000b5697          	auipc	a3,0xb5
ffffffffc0200d7c:	8d068693          	addi	a3,a3,-1840 # ffffffffc02b5648 <current>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200d80:	6298                	ld	a4,0(a3)
ffffffffc0200d82:	0b073023          	sd	a6,160(a4)
        if (!in_kernel)
ffffffffc0200d86:	e619                	bnez	a2,ffffffffc0200d94 <trap+0x4c>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200d88:	0b072783          	lw	a5,176(a4)
ffffffffc0200d8c:	8b85                	andi	a5,a5,1
ffffffffc0200d8e:	e79d                	bnez	a5,ffffffffc0200dbc <trap+0x74>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200d90:	6f1c                	ld	a5,24(a4)
ffffffffc0200d92:	e38d                	bnez	a5,ffffffffc0200db4 <trap+0x6c>
// DEBUG:                 if (current->pid >= 2 && current->pid <= 7) cprintf("trap: scheduling pid=%d\n", current->pid);
                schedule();
            }
        }
    }
}
ffffffffc0200d94:	60e2                	ld	ra,24(sp)
ffffffffc0200d96:	6105                	addi	sp,sp,32
ffffffffc0200d98:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200d9a:	dc3ff0ef          	jal	ffffffffc0200b5c <interrupt_handler>
ffffffffc0200d9e:	6802                	ld	a6,0(sp)
ffffffffc0200da0:	6622                	ld	a2,8(sp)
ffffffffc0200da2:	000b5697          	auipc	a3,0xb5
ffffffffc0200da6:	8a668693          	addi	a3,a3,-1882 # ffffffffc02b5648 <current>
ffffffffc0200daa:	bfd9                	j	ffffffffc0200d80 <trap+0x38>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dac:	0005c363          	bltz	a1,ffffffffc0200db2 <trap+0x6a>
        exception_handler(tf);
ffffffffc0200db0:	bd95                	j	ffffffffc0200c24 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200db2:	b36d                	j	ffffffffc0200b5c <interrupt_handler>
}
ffffffffc0200db4:	60e2                	ld	ra,24(sp)
ffffffffc0200db6:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200db8:	6430406f          	j	ffffffffc0205bfa <schedule>
                do_exit(-E_KILLED);
ffffffffc0200dbc:	555d                	li	a0,-9
ffffffffc0200dbe:	5bc030ef          	jal	ffffffffc020437a <do_exit>
            if (current->need_resched)
ffffffffc0200dc2:	000b5717          	auipc	a4,0xb5
ffffffffc0200dc6:	88673703          	ld	a4,-1914(a4) # ffffffffc02b5648 <current>
ffffffffc0200dca:	b7d9                	j	ffffffffc0200d90 <trap+0x48>

ffffffffc0200dcc <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200dcc:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200dd0:	00011463          	bnez	sp,ffffffffc0200dd8 <__alltraps+0xc>
ffffffffc0200dd4:	14002173          	csrr	sp,sscratch
ffffffffc0200dd8:	712d                	addi	sp,sp,-288
ffffffffc0200dda:	e002                	sd	zero,0(sp)
ffffffffc0200ddc:	e406                	sd	ra,8(sp)
ffffffffc0200dde:	ec0e                	sd	gp,24(sp)
ffffffffc0200de0:	f012                	sd	tp,32(sp)
ffffffffc0200de2:	f416                	sd	t0,40(sp)
ffffffffc0200de4:	f81a                	sd	t1,48(sp)
ffffffffc0200de6:	fc1e                	sd	t2,56(sp)
ffffffffc0200de8:	e0a2                	sd	s0,64(sp)
ffffffffc0200dea:	e4a6                	sd	s1,72(sp)
ffffffffc0200dec:	e8aa                	sd	a0,80(sp)
ffffffffc0200dee:	ecae                	sd	a1,88(sp)
ffffffffc0200df0:	f0b2                	sd	a2,96(sp)
ffffffffc0200df2:	f4b6                	sd	a3,104(sp)
ffffffffc0200df4:	f8ba                	sd	a4,112(sp)
ffffffffc0200df6:	fcbe                	sd	a5,120(sp)
ffffffffc0200df8:	e142                	sd	a6,128(sp)
ffffffffc0200dfa:	e546                	sd	a7,136(sp)
ffffffffc0200dfc:	e94a                	sd	s2,144(sp)
ffffffffc0200dfe:	ed4e                	sd	s3,152(sp)
ffffffffc0200e00:	f152                	sd	s4,160(sp)
ffffffffc0200e02:	f556                	sd	s5,168(sp)
ffffffffc0200e04:	f95a                	sd	s6,176(sp)
ffffffffc0200e06:	fd5e                	sd	s7,184(sp)
ffffffffc0200e08:	e1e2                	sd	s8,192(sp)
ffffffffc0200e0a:	e5e6                	sd	s9,200(sp)
ffffffffc0200e0c:	e9ea                	sd	s10,208(sp)
ffffffffc0200e0e:	edee                	sd	s11,216(sp)
ffffffffc0200e10:	f1f2                	sd	t3,224(sp)
ffffffffc0200e12:	f5f6                	sd	t4,232(sp)
ffffffffc0200e14:	f9fa                	sd	t5,240(sp)
ffffffffc0200e16:	fdfe                	sd	t6,248(sp)
ffffffffc0200e18:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200e1c:	100024f3          	csrr	s1,sstatus
ffffffffc0200e20:	14102973          	csrr	s2,sepc
ffffffffc0200e24:	143029f3          	csrr	s3,stval
ffffffffc0200e28:	14202a73          	csrr	s4,scause
ffffffffc0200e2c:	e822                	sd	s0,16(sp)
ffffffffc0200e2e:	e226                	sd	s1,256(sp)
ffffffffc0200e30:	e64a                	sd	s2,264(sp)
ffffffffc0200e32:	ea4e                	sd	s3,272(sp)
ffffffffc0200e34:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200e36:	850a                	mv	a0,sp
    jal trap
ffffffffc0200e38:	f11ff0ef          	jal	ffffffffc0200d48 <trap>

ffffffffc0200e3c <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200e3c:	6492                	ld	s1,256(sp)
ffffffffc0200e3e:	6932                	ld	s2,264(sp)
ffffffffc0200e40:	1004f413          	andi	s0,s1,256
ffffffffc0200e44:	e401                	bnez	s0,ffffffffc0200e4c <__trapret+0x10>
ffffffffc0200e46:	1200                	addi	s0,sp,288
ffffffffc0200e48:	14041073          	csrw	sscratch,s0
ffffffffc0200e4c:	10049073          	csrw	sstatus,s1
ffffffffc0200e50:	14191073          	csrw	sepc,s2
ffffffffc0200e54:	60a2                	ld	ra,8(sp)
ffffffffc0200e56:	61e2                	ld	gp,24(sp)
ffffffffc0200e58:	7202                	ld	tp,32(sp)
ffffffffc0200e5a:	72a2                	ld	t0,40(sp)
ffffffffc0200e5c:	7342                	ld	t1,48(sp)
ffffffffc0200e5e:	73e2                	ld	t2,56(sp)
ffffffffc0200e60:	6406                	ld	s0,64(sp)
ffffffffc0200e62:	64a6                	ld	s1,72(sp)
ffffffffc0200e64:	6546                	ld	a0,80(sp)
ffffffffc0200e66:	65e6                	ld	a1,88(sp)
ffffffffc0200e68:	7606                	ld	a2,96(sp)
ffffffffc0200e6a:	76a6                	ld	a3,104(sp)
ffffffffc0200e6c:	7746                	ld	a4,112(sp)
ffffffffc0200e6e:	77e6                	ld	a5,120(sp)
ffffffffc0200e70:	680a                	ld	a6,128(sp)
ffffffffc0200e72:	68aa                	ld	a7,136(sp)
ffffffffc0200e74:	694a                	ld	s2,144(sp)
ffffffffc0200e76:	69ea                	ld	s3,152(sp)
ffffffffc0200e78:	7a0a                	ld	s4,160(sp)
ffffffffc0200e7a:	7aaa                	ld	s5,168(sp)
ffffffffc0200e7c:	7b4a                	ld	s6,176(sp)
ffffffffc0200e7e:	7bea                	ld	s7,184(sp)
ffffffffc0200e80:	6c0e                	ld	s8,192(sp)
ffffffffc0200e82:	6cae                	ld	s9,200(sp)
ffffffffc0200e84:	6d4e                	ld	s10,208(sp)
ffffffffc0200e86:	6dee                	ld	s11,216(sp)
ffffffffc0200e88:	7e0e                	ld	t3,224(sp)
ffffffffc0200e8a:	7eae                	ld	t4,232(sp)
ffffffffc0200e8c:	7f4e                	ld	t5,240(sp)
ffffffffc0200e8e:	7fee                	ld	t6,248(sp)
ffffffffc0200e90:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200e92:	10200073          	sret

ffffffffc0200e96 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200e96:	812a                	mv	sp,a0
ffffffffc0200e98:	b755                	j	ffffffffc0200e3c <__trapret>

ffffffffc0200e9a <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200e9a:	000b0797          	auipc	a5,0xb0
ffffffffc0200e9e:	6ee78793          	addi	a5,a5,1774 # ffffffffc02b1588 <free_area>
ffffffffc0200ea2:	e79c                	sd	a5,8(a5)
ffffffffc0200ea4:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200ea6:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200eaa:	8082                	ret

ffffffffc0200eac <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200eac:	000b0517          	auipc	a0,0xb0
ffffffffc0200eb0:	6ec56503          	lwu	a0,1772(a0) # ffffffffc02b1598 <free_area+0x10>
ffffffffc0200eb4:	8082                	ret

ffffffffc0200eb6 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0200eb6:	711d                	addi	sp,sp,-96
ffffffffc0200eb8:	e0ca                	sd	s2,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200eba:	000b0917          	auipc	s2,0xb0
ffffffffc0200ebe:	6ce90913          	addi	s2,s2,1742 # ffffffffc02b1588 <free_area>
ffffffffc0200ec2:	00893783          	ld	a5,8(s2)
ffffffffc0200ec6:	ec86                	sd	ra,88(sp)
ffffffffc0200ec8:	e8a2                	sd	s0,80(sp)
ffffffffc0200eca:	e4a6                	sd	s1,72(sp)
ffffffffc0200ecc:	fc4e                	sd	s3,56(sp)
ffffffffc0200ece:	f852                	sd	s4,48(sp)
ffffffffc0200ed0:	f456                	sd	s5,40(sp)
ffffffffc0200ed2:	f05a                	sd	s6,32(sp)
ffffffffc0200ed4:	ec5e                	sd	s7,24(sp)
ffffffffc0200ed6:	e862                	sd	s8,16(sp)
ffffffffc0200ed8:	e466                	sd	s9,8(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0200eda:	2f278363          	beq	a5,s2,ffffffffc02011c0 <default_check+0x30a>
    int count = 0, total = 0;
ffffffffc0200ede:	4401                	li	s0,0
ffffffffc0200ee0:	4481                	li	s1,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200ee2:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200ee6:	8b09                	andi	a4,a4,2
ffffffffc0200ee8:	2e070063          	beqz	a4,ffffffffc02011c8 <default_check+0x312>
        count++, total += p->property;
ffffffffc0200eec:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200ef0:	679c                	ld	a5,8(a5)
ffffffffc0200ef2:	2485                	addiw	s1,s1,1
ffffffffc0200ef4:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0200ef6:	ff2796e3          	bne	a5,s2,ffffffffc0200ee2 <default_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc0200efa:	89a2                	mv	s3,s0
ffffffffc0200efc:	741000ef          	jal	ffffffffc0201e3c <nr_free_pages>
ffffffffc0200f00:	73351463          	bne	a0,s3,ffffffffc0201628 <default_check+0x772>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f04:	4505                	li	a0,1
ffffffffc0200f06:	6c5000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc0200f0a:	8a2a                	mv	s4,a0
ffffffffc0200f0c:	44050e63          	beqz	a0,ffffffffc0201368 <default_check+0x4b2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200f10:	4505                	li	a0,1
ffffffffc0200f12:	6b9000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc0200f16:	89aa                	mv	s3,a0
ffffffffc0200f18:	72050863          	beqz	a0,ffffffffc0201648 <default_check+0x792>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200f1c:	4505                	li	a0,1
ffffffffc0200f1e:	6ad000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc0200f22:	8aaa                	mv	s5,a0
ffffffffc0200f24:	4c050263          	beqz	a0,ffffffffc02013e8 <default_check+0x532>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200f28:	40a987b3          	sub	a5,s3,a0
ffffffffc0200f2c:	40aa0733          	sub	a4,s4,a0
ffffffffc0200f30:	0017b793          	seqz	a5,a5
ffffffffc0200f34:	00173713          	seqz	a4,a4
ffffffffc0200f38:	8fd9                	or	a5,a5,a4
ffffffffc0200f3a:	30079763          	bnez	a5,ffffffffc0201248 <default_check+0x392>
ffffffffc0200f3e:	313a0563          	beq	s4,s3,ffffffffc0201248 <default_check+0x392>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200f42:	000a2783          	lw	a5,0(s4)
ffffffffc0200f46:	2a079163          	bnez	a5,ffffffffc02011e8 <default_check+0x332>
ffffffffc0200f4a:	0009a783          	lw	a5,0(s3)
ffffffffc0200f4e:	28079d63          	bnez	a5,ffffffffc02011e8 <default_check+0x332>
ffffffffc0200f52:	411c                	lw	a5,0(a0)
ffffffffc0200f54:	28079a63          	bnez	a5,ffffffffc02011e8 <default_check+0x332>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0200f58:	000b4797          	auipc	a5,0xb4
ffffffffc0200f5c:	6e07b783          	ld	a5,1760(a5) # ffffffffc02b5638 <pages>
ffffffffc0200f60:	00008617          	auipc	a2,0x8
ffffffffc0200f64:	ba063603          	ld	a2,-1120(a2) # ffffffffc0208b00 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200f68:	000b4697          	auipc	a3,0xb4
ffffffffc0200f6c:	6c86b683          	ld	a3,1736(a3) # ffffffffc02b5630 <npage>
ffffffffc0200f70:	40fa0733          	sub	a4,s4,a5
ffffffffc0200f74:	8719                	srai	a4,a4,0x6
ffffffffc0200f76:	9732                	add	a4,a4,a2
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0200f78:	0732                	slli	a4,a4,0xc
ffffffffc0200f7a:	06b2                	slli	a3,a3,0xc
ffffffffc0200f7c:	2ad77663          	bgeu	a4,a3,ffffffffc0201228 <default_check+0x372>
    return page - pages + nbase;
ffffffffc0200f80:	40f98733          	sub	a4,s3,a5
ffffffffc0200f84:	8719                	srai	a4,a4,0x6
ffffffffc0200f86:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200f88:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200f8a:	4cd77f63          	bgeu	a4,a3,ffffffffc0201468 <default_check+0x5b2>
    return page - pages + nbase;
ffffffffc0200f8e:	40f507b3          	sub	a5,a0,a5
ffffffffc0200f92:	8799                	srai	a5,a5,0x6
ffffffffc0200f94:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200f96:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200f98:	32d7f863          	bgeu	a5,a3,ffffffffc02012c8 <default_check+0x412>
    assert(alloc_page() == NULL);
ffffffffc0200f9c:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200f9e:	00093c03          	ld	s8,0(s2)
ffffffffc0200fa2:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc0200fa6:	000b0b17          	auipc	s6,0xb0
ffffffffc0200faa:	5f2b2b03          	lw	s6,1522(s6) # ffffffffc02b1598 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc0200fae:	01293023          	sd	s2,0(s2)
ffffffffc0200fb2:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc0200fb6:	000b0797          	auipc	a5,0xb0
ffffffffc0200fba:	5e07a123          	sw	zero,1506(a5) # ffffffffc02b1598 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200fbe:	60d000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc0200fc2:	2e051363          	bnez	a0,ffffffffc02012a8 <default_check+0x3f2>
    free_page(p0);
ffffffffc0200fc6:	8552                	mv	a0,s4
ffffffffc0200fc8:	4585                	li	a1,1
ffffffffc0200fca:	63b000ef          	jal	ffffffffc0201e04 <free_pages>
    free_page(p1);
ffffffffc0200fce:	854e                	mv	a0,s3
ffffffffc0200fd0:	4585                	li	a1,1
ffffffffc0200fd2:	633000ef          	jal	ffffffffc0201e04 <free_pages>
    free_page(p2);
ffffffffc0200fd6:	8556                	mv	a0,s5
ffffffffc0200fd8:	4585                	li	a1,1
ffffffffc0200fda:	62b000ef          	jal	ffffffffc0201e04 <free_pages>
    assert(nr_free == 3);
ffffffffc0200fde:	000b0717          	auipc	a4,0xb0
ffffffffc0200fe2:	5ba72703          	lw	a4,1466(a4) # ffffffffc02b1598 <free_area+0x10>
ffffffffc0200fe6:	478d                	li	a5,3
ffffffffc0200fe8:	2af71063          	bne	a4,a5,ffffffffc0201288 <default_check+0x3d2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200fec:	4505                	li	a0,1
ffffffffc0200fee:	5dd000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc0200ff2:	89aa                	mv	s3,a0
ffffffffc0200ff4:	26050a63          	beqz	a0,ffffffffc0201268 <default_check+0x3b2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200ff8:	4505                	li	a0,1
ffffffffc0200ffa:	5d1000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc0200ffe:	8aaa                	mv	s5,a0
ffffffffc0201000:	3c050463          	beqz	a0,ffffffffc02013c8 <default_check+0x512>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201004:	4505                	li	a0,1
ffffffffc0201006:	5c5000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc020100a:	8a2a                	mv	s4,a0
ffffffffc020100c:	38050e63          	beqz	a0,ffffffffc02013a8 <default_check+0x4f2>
    assert(alloc_page() == NULL);
ffffffffc0201010:	4505                	li	a0,1
ffffffffc0201012:	5b9000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc0201016:	36051963          	bnez	a0,ffffffffc0201388 <default_check+0x4d2>
    free_page(p0);
ffffffffc020101a:	4585                	li	a1,1
ffffffffc020101c:	854e                	mv	a0,s3
ffffffffc020101e:	5e7000ef          	jal	ffffffffc0201e04 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201022:	00893783          	ld	a5,8(s2)
ffffffffc0201026:	1f278163          	beq	a5,s2,ffffffffc0201208 <default_check+0x352>
    assert((p = alloc_page()) == p0);
ffffffffc020102a:	4505                	li	a0,1
ffffffffc020102c:	59f000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc0201030:	8caa                	mv	s9,a0
ffffffffc0201032:	30a99b63          	bne	s3,a0,ffffffffc0201348 <default_check+0x492>
    assert(alloc_page() == NULL);
ffffffffc0201036:	4505                	li	a0,1
ffffffffc0201038:	593000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc020103c:	2e051663          	bnez	a0,ffffffffc0201328 <default_check+0x472>
    assert(nr_free == 0);
ffffffffc0201040:	000b0797          	auipc	a5,0xb0
ffffffffc0201044:	5587a783          	lw	a5,1368(a5) # ffffffffc02b1598 <free_area+0x10>
ffffffffc0201048:	2c079063          	bnez	a5,ffffffffc0201308 <default_check+0x452>
    free_page(p);
ffffffffc020104c:	8566                	mv	a0,s9
ffffffffc020104e:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201050:	01893023          	sd	s8,0(s2)
ffffffffc0201054:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc0201058:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc020105c:	5a9000ef          	jal	ffffffffc0201e04 <free_pages>
    free_page(p1);
ffffffffc0201060:	8556                	mv	a0,s5
ffffffffc0201062:	4585                	li	a1,1
ffffffffc0201064:	5a1000ef          	jal	ffffffffc0201e04 <free_pages>
    free_page(p2);
ffffffffc0201068:	8552                	mv	a0,s4
ffffffffc020106a:	4585                	li	a1,1
ffffffffc020106c:	599000ef          	jal	ffffffffc0201e04 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201070:	4515                	li	a0,5
ffffffffc0201072:	559000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc0201076:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0201078:	26050863          	beqz	a0,ffffffffc02012e8 <default_check+0x432>
ffffffffc020107c:	651c                	ld	a5,8(a0)
    assert(!PageProperty(p0));
ffffffffc020107e:	8b89                	andi	a5,a5,2
ffffffffc0201080:	54079463          	bnez	a5,ffffffffc02015c8 <default_check+0x712>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201084:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201086:	00093b83          	ld	s7,0(s2)
ffffffffc020108a:	00893b03          	ld	s6,8(s2)
ffffffffc020108e:	01293023          	sd	s2,0(s2)
ffffffffc0201092:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc0201096:	535000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc020109a:	50051763          	bnez	a0,ffffffffc02015a8 <default_check+0x6f2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc020109e:	08098a13          	addi	s4,s3,128
ffffffffc02010a2:	8552                	mv	a0,s4
ffffffffc02010a4:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc02010a6:	000b0c17          	auipc	s8,0xb0
ffffffffc02010aa:	4f2c2c03          	lw	s8,1266(s8) # ffffffffc02b1598 <free_area+0x10>
    nr_free = 0;
ffffffffc02010ae:	000b0797          	auipc	a5,0xb0
ffffffffc02010b2:	4e07a523          	sw	zero,1258(a5) # ffffffffc02b1598 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc02010b6:	54f000ef          	jal	ffffffffc0201e04 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc02010ba:	4511                	li	a0,4
ffffffffc02010bc:	50f000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc02010c0:	4c051463          	bnez	a0,ffffffffc0201588 <default_check+0x6d2>
ffffffffc02010c4:	0889b783          	ld	a5,136(s3)
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02010c8:	8b89                	andi	a5,a5,2
ffffffffc02010ca:	48078f63          	beqz	a5,ffffffffc0201568 <default_check+0x6b2>
ffffffffc02010ce:	0909a503          	lw	a0,144(s3)
ffffffffc02010d2:	478d                	li	a5,3
ffffffffc02010d4:	48f51a63          	bne	a0,a5,ffffffffc0201568 <default_check+0x6b2>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02010d8:	4f3000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc02010dc:	8aaa                	mv	s5,a0
ffffffffc02010de:	46050563          	beqz	a0,ffffffffc0201548 <default_check+0x692>
    assert(alloc_page() == NULL);
ffffffffc02010e2:	4505                	li	a0,1
ffffffffc02010e4:	4e7000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc02010e8:	44051063          	bnez	a0,ffffffffc0201528 <default_check+0x672>
    assert(p0 + 2 == p1);
ffffffffc02010ec:	415a1e63          	bne	s4,s5,ffffffffc0201508 <default_check+0x652>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02010f0:	4585                	li	a1,1
ffffffffc02010f2:	854e                	mv	a0,s3
ffffffffc02010f4:	511000ef          	jal	ffffffffc0201e04 <free_pages>
    free_pages(p1, 3);
ffffffffc02010f8:	8552                	mv	a0,s4
ffffffffc02010fa:	458d                	li	a1,3
ffffffffc02010fc:	509000ef          	jal	ffffffffc0201e04 <free_pages>
ffffffffc0201100:	0089b783          	ld	a5,8(s3)
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201104:	8b89                	andi	a5,a5,2
ffffffffc0201106:	3e078163          	beqz	a5,ffffffffc02014e8 <default_check+0x632>
ffffffffc020110a:	0109aa83          	lw	s5,16(s3)
ffffffffc020110e:	4785                	li	a5,1
ffffffffc0201110:	3cfa9c63          	bne	s5,a5,ffffffffc02014e8 <default_check+0x632>
ffffffffc0201114:	008a3783          	ld	a5,8(s4)
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201118:	8b89                	andi	a5,a5,2
ffffffffc020111a:	3a078763          	beqz	a5,ffffffffc02014c8 <default_check+0x612>
ffffffffc020111e:	010a2703          	lw	a4,16(s4)
ffffffffc0201122:	478d                	li	a5,3
ffffffffc0201124:	3af71263          	bne	a4,a5,ffffffffc02014c8 <default_check+0x612>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201128:	8556                	mv	a0,s5
ffffffffc020112a:	4a1000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc020112e:	36a99d63          	bne	s3,a0,ffffffffc02014a8 <default_check+0x5f2>
    free_page(p0);
ffffffffc0201132:	85d6                	mv	a1,s5
ffffffffc0201134:	4d1000ef          	jal	ffffffffc0201e04 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201138:	4509                	li	a0,2
ffffffffc020113a:	491000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc020113e:	34aa1563          	bne	s4,a0,ffffffffc0201488 <default_check+0x5d2>

    free_pages(p0, 2);
ffffffffc0201142:	4589                	li	a1,2
ffffffffc0201144:	4c1000ef          	jal	ffffffffc0201e04 <free_pages>
    free_page(p2);
ffffffffc0201148:	04098513          	addi	a0,s3,64
ffffffffc020114c:	85d6                	mv	a1,s5
ffffffffc020114e:	4b7000ef          	jal	ffffffffc0201e04 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201152:	4515                	li	a0,5
ffffffffc0201154:	477000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc0201158:	89aa                	mv	s3,a0
ffffffffc020115a:	48050763          	beqz	a0,ffffffffc02015e8 <default_check+0x732>
    assert(alloc_page() == NULL);
ffffffffc020115e:	8556                	mv	a0,s5
ffffffffc0201160:	46b000ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc0201164:	2e051263          	bnez	a0,ffffffffc0201448 <default_check+0x592>

    assert(nr_free == 0);
ffffffffc0201168:	000b0797          	auipc	a5,0xb0
ffffffffc020116c:	4307a783          	lw	a5,1072(a5) # ffffffffc02b1598 <free_area+0x10>
ffffffffc0201170:	2a079c63          	bnez	a5,ffffffffc0201428 <default_check+0x572>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201174:	854e                	mv	a0,s3
ffffffffc0201176:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc0201178:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc020117c:	01793023          	sd	s7,0(s2)
ffffffffc0201180:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc0201184:	481000ef          	jal	ffffffffc0201e04 <free_pages>
    return listelm->next;
ffffffffc0201188:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc020118c:	01278963          	beq	a5,s2,ffffffffc020119e <default_check+0x2e8>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc0201190:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201194:	679c                	ld	a5,8(a5)
ffffffffc0201196:	34fd                	addiw	s1,s1,-1
ffffffffc0201198:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc020119a:	ff279be3          	bne	a5,s2,ffffffffc0201190 <default_check+0x2da>
    }
    assert(count == 0);
ffffffffc020119e:	26049563          	bnez	s1,ffffffffc0201408 <default_check+0x552>
    assert(total == 0);
ffffffffc02011a2:	46041363          	bnez	s0,ffffffffc0201608 <default_check+0x752>
}
ffffffffc02011a6:	60e6                	ld	ra,88(sp)
ffffffffc02011a8:	6446                	ld	s0,80(sp)
ffffffffc02011aa:	64a6                	ld	s1,72(sp)
ffffffffc02011ac:	6906                	ld	s2,64(sp)
ffffffffc02011ae:	79e2                	ld	s3,56(sp)
ffffffffc02011b0:	7a42                	ld	s4,48(sp)
ffffffffc02011b2:	7aa2                	ld	s5,40(sp)
ffffffffc02011b4:	7b02                	ld	s6,32(sp)
ffffffffc02011b6:	6be2                	ld	s7,24(sp)
ffffffffc02011b8:	6c42                	ld	s8,16(sp)
ffffffffc02011ba:	6ca2                	ld	s9,8(sp)
ffffffffc02011bc:	6125                	addi	sp,sp,96
ffffffffc02011be:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc02011c0:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02011c2:	4401                	li	s0,0
ffffffffc02011c4:	4481                	li	s1,0
ffffffffc02011c6:	bb1d                	j	ffffffffc0200efc <default_check+0x46>
        assert(PageProperty(p));
ffffffffc02011c8:	00006697          	auipc	a3,0x6
ffffffffc02011cc:	a8068693          	addi	a3,a3,-1408 # ffffffffc0206c48 <etext+0x9da>
ffffffffc02011d0:	00006617          	auipc	a2,0x6
ffffffffc02011d4:	a8860613          	addi	a2,a2,-1400 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02011d8:	11000593          	li	a1,272
ffffffffc02011dc:	00006517          	auipc	a0,0x6
ffffffffc02011e0:	a9450513          	addi	a0,a0,-1388 # ffffffffc0206c70 <etext+0xa02>
ffffffffc02011e4:	a66ff0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02011e8:	00006697          	auipc	a3,0x6
ffffffffc02011ec:	b4868693          	addi	a3,a3,-1208 # ffffffffc0206d30 <etext+0xac2>
ffffffffc02011f0:	00006617          	auipc	a2,0x6
ffffffffc02011f4:	a6860613          	addi	a2,a2,-1432 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02011f8:	0dc00593          	li	a1,220
ffffffffc02011fc:	00006517          	auipc	a0,0x6
ffffffffc0201200:	a7450513          	addi	a0,a0,-1420 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201204:	a46ff0ef          	jal	ffffffffc020044a <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201208:	00006697          	auipc	a3,0x6
ffffffffc020120c:	bf068693          	addi	a3,a3,-1040 # ffffffffc0206df8 <etext+0xb8a>
ffffffffc0201210:	00006617          	auipc	a2,0x6
ffffffffc0201214:	a4860613          	addi	a2,a2,-1464 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201218:	0f700593          	li	a1,247
ffffffffc020121c:	00006517          	auipc	a0,0x6
ffffffffc0201220:	a5450513          	addi	a0,a0,-1452 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201224:	a26ff0ef          	jal	ffffffffc020044a <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201228:	00006697          	auipc	a3,0x6
ffffffffc020122c:	b4868693          	addi	a3,a3,-1208 # ffffffffc0206d70 <etext+0xb02>
ffffffffc0201230:	00006617          	auipc	a2,0x6
ffffffffc0201234:	a2860613          	addi	a2,a2,-1496 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201238:	0de00593          	li	a1,222
ffffffffc020123c:	00006517          	auipc	a0,0x6
ffffffffc0201240:	a3450513          	addi	a0,a0,-1484 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201244:	a06ff0ef          	jal	ffffffffc020044a <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201248:	00006697          	auipc	a3,0x6
ffffffffc020124c:	ac068693          	addi	a3,a3,-1344 # ffffffffc0206d08 <etext+0xa9a>
ffffffffc0201250:	00006617          	auipc	a2,0x6
ffffffffc0201254:	a0860613          	addi	a2,a2,-1528 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201258:	0db00593          	li	a1,219
ffffffffc020125c:	00006517          	auipc	a0,0x6
ffffffffc0201260:	a1450513          	addi	a0,a0,-1516 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201264:	9e6ff0ef          	jal	ffffffffc020044a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201268:	00006697          	auipc	a3,0x6
ffffffffc020126c:	a4068693          	addi	a3,a3,-1472 # ffffffffc0206ca8 <etext+0xa3a>
ffffffffc0201270:	00006617          	auipc	a2,0x6
ffffffffc0201274:	9e860613          	addi	a2,a2,-1560 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201278:	0f000593          	li	a1,240
ffffffffc020127c:	00006517          	auipc	a0,0x6
ffffffffc0201280:	9f450513          	addi	a0,a0,-1548 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201284:	9c6ff0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_free == 3);
ffffffffc0201288:	00006697          	auipc	a3,0x6
ffffffffc020128c:	b6068693          	addi	a3,a3,-1184 # ffffffffc0206de8 <etext+0xb7a>
ffffffffc0201290:	00006617          	auipc	a2,0x6
ffffffffc0201294:	9c860613          	addi	a2,a2,-1592 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201298:	0ee00593          	li	a1,238
ffffffffc020129c:	00006517          	auipc	a0,0x6
ffffffffc02012a0:	9d450513          	addi	a0,a0,-1580 # ffffffffc0206c70 <etext+0xa02>
ffffffffc02012a4:	9a6ff0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012a8:	00006697          	auipc	a3,0x6
ffffffffc02012ac:	b2868693          	addi	a3,a3,-1240 # ffffffffc0206dd0 <etext+0xb62>
ffffffffc02012b0:	00006617          	auipc	a2,0x6
ffffffffc02012b4:	9a860613          	addi	a2,a2,-1624 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02012b8:	0e900593          	li	a1,233
ffffffffc02012bc:	00006517          	auipc	a0,0x6
ffffffffc02012c0:	9b450513          	addi	a0,a0,-1612 # ffffffffc0206c70 <etext+0xa02>
ffffffffc02012c4:	986ff0ef          	jal	ffffffffc020044a <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02012c8:	00006697          	auipc	a3,0x6
ffffffffc02012cc:	ae868693          	addi	a3,a3,-1304 # ffffffffc0206db0 <etext+0xb42>
ffffffffc02012d0:	00006617          	auipc	a2,0x6
ffffffffc02012d4:	98860613          	addi	a2,a2,-1656 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02012d8:	0e000593          	li	a1,224
ffffffffc02012dc:	00006517          	auipc	a0,0x6
ffffffffc02012e0:	99450513          	addi	a0,a0,-1644 # ffffffffc0206c70 <etext+0xa02>
ffffffffc02012e4:	966ff0ef          	jal	ffffffffc020044a <__panic>
    assert(p0 != NULL);
ffffffffc02012e8:	00006697          	auipc	a3,0x6
ffffffffc02012ec:	b5868693          	addi	a3,a3,-1192 # ffffffffc0206e40 <etext+0xbd2>
ffffffffc02012f0:	00006617          	auipc	a2,0x6
ffffffffc02012f4:	96860613          	addi	a2,a2,-1688 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02012f8:	11800593          	li	a1,280
ffffffffc02012fc:	00006517          	auipc	a0,0x6
ffffffffc0201300:	97450513          	addi	a0,a0,-1676 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201304:	946ff0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_free == 0);
ffffffffc0201308:	00006697          	auipc	a3,0x6
ffffffffc020130c:	b2868693          	addi	a3,a3,-1240 # ffffffffc0206e30 <etext+0xbc2>
ffffffffc0201310:	00006617          	auipc	a2,0x6
ffffffffc0201314:	94860613          	addi	a2,a2,-1720 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201318:	0fd00593          	li	a1,253
ffffffffc020131c:	00006517          	auipc	a0,0x6
ffffffffc0201320:	95450513          	addi	a0,a0,-1708 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201324:	926ff0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201328:	00006697          	auipc	a3,0x6
ffffffffc020132c:	aa868693          	addi	a3,a3,-1368 # ffffffffc0206dd0 <etext+0xb62>
ffffffffc0201330:	00006617          	auipc	a2,0x6
ffffffffc0201334:	92860613          	addi	a2,a2,-1752 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201338:	0fb00593          	li	a1,251
ffffffffc020133c:	00006517          	auipc	a0,0x6
ffffffffc0201340:	93450513          	addi	a0,a0,-1740 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201344:	906ff0ef          	jal	ffffffffc020044a <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201348:	00006697          	auipc	a3,0x6
ffffffffc020134c:	ac868693          	addi	a3,a3,-1336 # ffffffffc0206e10 <etext+0xba2>
ffffffffc0201350:	00006617          	auipc	a2,0x6
ffffffffc0201354:	90860613          	addi	a2,a2,-1784 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201358:	0fa00593          	li	a1,250
ffffffffc020135c:	00006517          	auipc	a0,0x6
ffffffffc0201360:	91450513          	addi	a0,a0,-1772 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201364:	8e6ff0ef          	jal	ffffffffc020044a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201368:	00006697          	auipc	a3,0x6
ffffffffc020136c:	94068693          	addi	a3,a3,-1728 # ffffffffc0206ca8 <etext+0xa3a>
ffffffffc0201370:	00006617          	auipc	a2,0x6
ffffffffc0201374:	8e860613          	addi	a2,a2,-1816 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201378:	0d700593          	li	a1,215
ffffffffc020137c:	00006517          	auipc	a0,0x6
ffffffffc0201380:	8f450513          	addi	a0,a0,-1804 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201384:	8c6ff0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201388:	00006697          	auipc	a3,0x6
ffffffffc020138c:	a4868693          	addi	a3,a3,-1464 # ffffffffc0206dd0 <etext+0xb62>
ffffffffc0201390:	00006617          	auipc	a2,0x6
ffffffffc0201394:	8c860613          	addi	a2,a2,-1848 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201398:	0f400593          	li	a1,244
ffffffffc020139c:	00006517          	auipc	a0,0x6
ffffffffc02013a0:	8d450513          	addi	a0,a0,-1836 # ffffffffc0206c70 <etext+0xa02>
ffffffffc02013a4:	8a6ff0ef          	jal	ffffffffc020044a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02013a8:	00006697          	auipc	a3,0x6
ffffffffc02013ac:	94068693          	addi	a3,a3,-1728 # ffffffffc0206ce8 <etext+0xa7a>
ffffffffc02013b0:	00006617          	auipc	a2,0x6
ffffffffc02013b4:	8a860613          	addi	a2,a2,-1880 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02013b8:	0f200593          	li	a1,242
ffffffffc02013bc:	00006517          	auipc	a0,0x6
ffffffffc02013c0:	8b450513          	addi	a0,a0,-1868 # ffffffffc0206c70 <etext+0xa02>
ffffffffc02013c4:	886ff0ef          	jal	ffffffffc020044a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02013c8:	00006697          	auipc	a3,0x6
ffffffffc02013cc:	90068693          	addi	a3,a3,-1792 # ffffffffc0206cc8 <etext+0xa5a>
ffffffffc02013d0:	00006617          	auipc	a2,0x6
ffffffffc02013d4:	88860613          	addi	a2,a2,-1912 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02013d8:	0f100593          	li	a1,241
ffffffffc02013dc:	00006517          	auipc	a0,0x6
ffffffffc02013e0:	89450513          	addi	a0,a0,-1900 # ffffffffc0206c70 <etext+0xa02>
ffffffffc02013e4:	866ff0ef          	jal	ffffffffc020044a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02013e8:	00006697          	auipc	a3,0x6
ffffffffc02013ec:	90068693          	addi	a3,a3,-1792 # ffffffffc0206ce8 <etext+0xa7a>
ffffffffc02013f0:	00006617          	auipc	a2,0x6
ffffffffc02013f4:	86860613          	addi	a2,a2,-1944 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02013f8:	0d900593          	li	a1,217
ffffffffc02013fc:	00006517          	auipc	a0,0x6
ffffffffc0201400:	87450513          	addi	a0,a0,-1932 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201404:	846ff0ef          	jal	ffffffffc020044a <__panic>
    assert(count == 0);
ffffffffc0201408:	00006697          	auipc	a3,0x6
ffffffffc020140c:	b8868693          	addi	a3,a3,-1144 # ffffffffc0206f90 <etext+0xd22>
ffffffffc0201410:	00006617          	auipc	a2,0x6
ffffffffc0201414:	84860613          	addi	a2,a2,-1976 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201418:	14600593          	li	a1,326
ffffffffc020141c:	00006517          	auipc	a0,0x6
ffffffffc0201420:	85450513          	addi	a0,a0,-1964 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201424:	826ff0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_free == 0);
ffffffffc0201428:	00006697          	auipc	a3,0x6
ffffffffc020142c:	a0868693          	addi	a3,a3,-1528 # ffffffffc0206e30 <etext+0xbc2>
ffffffffc0201430:	00006617          	auipc	a2,0x6
ffffffffc0201434:	82860613          	addi	a2,a2,-2008 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201438:	13a00593          	li	a1,314
ffffffffc020143c:	00006517          	auipc	a0,0x6
ffffffffc0201440:	83450513          	addi	a0,a0,-1996 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201444:	806ff0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201448:	00006697          	auipc	a3,0x6
ffffffffc020144c:	98868693          	addi	a3,a3,-1656 # ffffffffc0206dd0 <etext+0xb62>
ffffffffc0201450:	00006617          	auipc	a2,0x6
ffffffffc0201454:	80860613          	addi	a2,a2,-2040 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201458:	13800593          	li	a1,312
ffffffffc020145c:	00006517          	auipc	a0,0x6
ffffffffc0201460:	81450513          	addi	a0,a0,-2028 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201464:	fe7fe0ef          	jal	ffffffffc020044a <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201468:	00006697          	auipc	a3,0x6
ffffffffc020146c:	92868693          	addi	a3,a3,-1752 # ffffffffc0206d90 <etext+0xb22>
ffffffffc0201470:	00005617          	auipc	a2,0x5
ffffffffc0201474:	7e860613          	addi	a2,a2,2024 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201478:	0df00593          	li	a1,223
ffffffffc020147c:	00005517          	auipc	a0,0x5
ffffffffc0201480:	7f450513          	addi	a0,a0,2036 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201484:	fc7fe0ef          	jal	ffffffffc020044a <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201488:	00006697          	auipc	a3,0x6
ffffffffc020148c:	ac868693          	addi	a3,a3,-1336 # ffffffffc0206f50 <etext+0xce2>
ffffffffc0201490:	00005617          	auipc	a2,0x5
ffffffffc0201494:	7c860613          	addi	a2,a2,1992 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201498:	13200593          	li	a1,306
ffffffffc020149c:	00005517          	auipc	a0,0x5
ffffffffc02014a0:	7d450513          	addi	a0,a0,2004 # ffffffffc0206c70 <etext+0xa02>
ffffffffc02014a4:	fa7fe0ef          	jal	ffffffffc020044a <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02014a8:	00006697          	auipc	a3,0x6
ffffffffc02014ac:	a8868693          	addi	a3,a3,-1400 # ffffffffc0206f30 <etext+0xcc2>
ffffffffc02014b0:	00005617          	auipc	a2,0x5
ffffffffc02014b4:	7a860613          	addi	a2,a2,1960 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02014b8:	13000593          	li	a1,304
ffffffffc02014bc:	00005517          	auipc	a0,0x5
ffffffffc02014c0:	7b450513          	addi	a0,a0,1972 # ffffffffc0206c70 <etext+0xa02>
ffffffffc02014c4:	f87fe0ef          	jal	ffffffffc020044a <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02014c8:	00006697          	auipc	a3,0x6
ffffffffc02014cc:	a4068693          	addi	a3,a3,-1472 # ffffffffc0206f08 <etext+0xc9a>
ffffffffc02014d0:	00005617          	auipc	a2,0x5
ffffffffc02014d4:	78860613          	addi	a2,a2,1928 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02014d8:	12e00593          	li	a1,302
ffffffffc02014dc:	00005517          	auipc	a0,0x5
ffffffffc02014e0:	79450513          	addi	a0,a0,1940 # ffffffffc0206c70 <etext+0xa02>
ffffffffc02014e4:	f67fe0ef          	jal	ffffffffc020044a <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02014e8:	00006697          	auipc	a3,0x6
ffffffffc02014ec:	9f868693          	addi	a3,a3,-1544 # ffffffffc0206ee0 <etext+0xc72>
ffffffffc02014f0:	00005617          	auipc	a2,0x5
ffffffffc02014f4:	76860613          	addi	a2,a2,1896 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02014f8:	12d00593          	li	a1,301
ffffffffc02014fc:	00005517          	auipc	a0,0x5
ffffffffc0201500:	77450513          	addi	a0,a0,1908 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201504:	f47fe0ef          	jal	ffffffffc020044a <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201508:	00006697          	auipc	a3,0x6
ffffffffc020150c:	9c868693          	addi	a3,a3,-1592 # ffffffffc0206ed0 <etext+0xc62>
ffffffffc0201510:	00005617          	auipc	a2,0x5
ffffffffc0201514:	74860613          	addi	a2,a2,1864 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201518:	12800593          	li	a1,296
ffffffffc020151c:	00005517          	auipc	a0,0x5
ffffffffc0201520:	75450513          	addi	a0,a0,1876 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201524:	f27fe0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201528:	00006697          	auipc	a3,0x6
ffffffffc020152c:	8a868693          	addi	a3,a3,-1880 # ffffffffc0206dd0 <etext+0xb62>
ffffffffc0201530:	00005617          	auipc	a2,0x5
ffffffffc0201534:	72860613          	addi	a2,a2,1832 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201538:	12700593          	li	a1,295
ffffffffc020153c:	00005517          	auipc	a0,0x5
ffffffffc0201540:	73450513          	addi	a0,a0,1844 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201544:	f07fe0ef          	jal	ffffffffc020044a <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201548:	00006697          	auipc	a3,0x6
ffffffffc020154c:	96868693          	addi	a3,a3,-1688 # ffffffffc0206eb0 <etext+0xc42>
ffffffffc0201550:	00005617          	auipc	a2,0x5
ffffffffc0201554:	70860613          	addi	a2,a2,1800 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201558:	12600593          	li	a1,294
ffffffffc020155c:	00005517          	auipc	a0,0x5
ffffffffc0201560:	71450513          	addi	a0,a0,1812 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201564:	ee7fe0ef          	jal	ffffffffc020044a <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201568:	00006697          	auipc	a3,0x6
ffffffffc020156c:	91868693          	addi	a3,a3,-1768 # ffffffffc0206e80 <etext+0xc12>
ffffffffc0201570:	00005617          	auipc	a2,0x5
ffffffffc0201574:	6e860613          	addi	a2,a2,1768 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201578:	12500593          	li	a1,293
ffffffffc020157c:	00005517          	auipc	a0,0x5
ffffffffc0201580:	6f450513          	addi	a0,a0,1780 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201584:	ec7fe0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201588:	00006697          	auipc	a3,0x6
ffffffffc020158c:	8e068693          	addi	a3,a3,-1824 # ffffffffc0206e68 <etext+0xbfa>
ffffffffc0201590:	00005617          	auipc	a2,0x5
ffffffffc0201594:	6c860613          	addi	a2,a2,1736 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201598:	12400593          	li	a1,292
ffffffffc020159c:	00005517          	auipc	a0,0x5
ffffffffc02015a0:	6d450513          	addi	a0,a0,1748 # ffffffffc0206c70 <etext+0xa02>
ffffffffc02015a4:	ea7fe0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02015a8:	00006697          	auipc	a3,0x6
ffffffffc02015ac:	82868693          	addi	a3,a3,-2008 # ffffffffc0206dd0 <etext+0xb62>
ffffffffc02015b0:	00005617          	auipc	a2,0x5
ffffffffc02015b4:	6a860613          	addi	a2,a2,1704 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02015b8:	11e00593          	li	a1,286
ffffffffc02015bc:	00005517          	auipc	a0,0x5
ffffffffc02015c0:	6b450513          	addi	a0,a0,1716 # ffffffffc0206c70 <etext+0xa02>
ffffffffc02015c4:	e87fe0ef          	jal	ffffffffc020044a <__panic>
    assert(!PageProperty(p0));
ffffffffc02015c8:	00006697          	auipc	a3,0x6
ffffffffc02015cc:	88868693          	addi	a3,a3,-1912 # ffffffffc0206e50 <etext+0xbe2>
ffffffffc02015d0:	00005617          	auipc	a2,0x5
ffffffffc02015d4:	68860613          	addi	a2,a2,1672 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02015d8:	11900593          	li	a1,281
ffffffffc02015dc:	00005517          	auipc	a0,0x5
ffffffffc02015e0:	69450513          	addi	a0,a0,1684 # ffffffffc0206c70 <etext+0xa02>
ffffffffc02015e4:	e67fe0ef          	jal	ffffffffc020044a <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02015e8:	00006697          	auipc	a3,0x6
ffffffffc02015ec:	98868693          	addi	a3,a3,-1656 # ffffffffc0206f70 <etext+0xd02>
ffffffffc02015f0:	00005617          	auipc	a2,0x5
ffffffffc02015f4:	66860613          	addi	a2,a2,1640 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02015f8:	13700593          	li	a1,311
ffffffffc02015fc:	00005517          	auipc	a0,0x5
ffffffffc0201600:	67450513          	addi	a0,a0,1652 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201604:	e47fe0ef          	jal	ffffffffc020044a <__panic>
    assert(total == 0);
ffffffffc0201608:	00006697          	auipc	a3,0x6
ffffffffc020160c:	99868693          	addi	a3,a3,-1640 # ffffffffc0206fa0 <etext+0xd32>
ffffffffc0201610:	00005617          	auipc	a2,0x5
ffffffffc0201614:	64860613          	addi	a2,a2,1608 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201618:	14700593          	li	a1,327
ffffffffc020161c:	00005517          	auipc	a0,0x5
ffffffffc0201620:	65450513          	addi	a0,a0,1620 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201624:	e27fe0ef          	jal	ffffffffc020044a <__panic>
    assert(total == nr_free_pages());
ffffffffc0201628:	00005697          	auipc	a3,0x5
ffffffffc020162c:	66068693          	addi	a3,a3,1632 # ffffffffc0206c88 <etext+0xa1a>
ffffffffc0201630:	00005617          	auipc	a2,0x5
ffffffffc0201634:	62860613          	addi	a2,a2,1576 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201638:	11300593          	li	a1,275
ffffffffc020163c:	00005517          	auipc	a0,0x5
ffffffffc0201640:	63450513          	addi	a0,a0,1588 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201644:	e07fe0ef          	jal	ffffffffc020044a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201648:	00005697          	auipc	a3,0x5
ffffffffc020164c:	68068693          	addi	a3,a3,1664 # ffffffffc0206cc8 <etext+0xa5a>
ffffffffc0201650:	00005617          	auipc	a2,0x5
ffffffffc0201654:	60860613          	addi	a2,a2,1544 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201658:	0d800593          	li	a1,216
ffffffffc020165c:	00005517          	auipc	a0,0x5
ffffffffc0201660:	61450513          	addi	a0,a0,1556 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201664:	de7fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201668 <default_free_pages>:
{
ffffffffc0201668:	1141                	addi	sp,sp,-16
ffffffffc020166a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020166c:	14058663          	beqz	a1,ffffffffc02017b8 <default_free_pages+0x150>
    for (; p != base + n; p++)
ffffffffc0201670:	00659713          	slli	a4,a1,0x6
ffffffffc0201674:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201678:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc020167a:	c30d                	beqz	a4,ffffffffc020169c <default_free_pages+0x34>
ffffffffc020167c:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020167e:	8b05                	andi	a4,a4,1
ffffffffc0201680:	10071c63          	bnez	a4,ffffffffc0201798 <default_free_pages+0x130>
ffffffffc0201684:	6798                	ld	a4,8(a5)
ffffffffc0201686:	8b09                	andi	a4,a4,2
ffffffffc0201688:	10071863          	bnez	a4,ffffffffc0201798 <default_free_pages+0x130>
        p->flags = 0;
ffffffffc020168c:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc0201690:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201694:	04078793          	addi	a5,a5,64
ffffffffc0201698:	fed792e3          	bne	a5,a3,ffffffffc020167c <default_free_pages+0x14>
    base->property = n;
ffffffffc020169c:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc020169e:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02016a2:	4789                	li	a5,2
ffffffffc02016a4:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02016a8:	000b0717          	auipc	a4,0xb0
ffffffffc02016ac:	ef072703          	lw	a4,-272(a4) # ffffffffc02b1598 <free_area+0x10>
ffffffffc02016b0:	000b0697          	auipc	a3,0xb0
ffffffffc02016b4:	ed868693          	addi	a3,a3,-296 # ffffffffc02b1588 <free_area>
    return list->next == list;
ffffffffc02016b8:	669c                	ld	a5,8(a3)
ffffffffc02016ba:	9f2d                	addw	a4,a4,a1
ffffffffc02016bc:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc02016be:	0ad78163          	beq	a5,a3,ffffffffc0201760 <default_free_pages+0xf8>
            struct Page *page = le2page(le, page_link);
ffffffffc02016c2:	fe878713          	addi	a4,a5,-24
ffffffffc02016c6:	4581                	li	a1,0
ffffffffc02016c8:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc02016cc:	00e56a63          	bltu	a0,a4,ffffffffc02016e0 <default_free_pages+0x78>
    return listelm->next;
ffffffffc02016d0:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02016d2:	04d70c63          	beq	a4,a3,ffffffffc020172a <default_free_pages+0xc2>
    struct Page *p = base;
ffffffffc02016d6:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02016d8:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02016dc:	fee57ae3          	bgeu	a0,a4,ffffffffc02016d0 <default_free_pages+0x68>
ffffffffc02016e0:	c199                	beqz	a1,ffffffffc02016e6 <default_free_pages+0x7e>
ffffffffc02016e2:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02016e6:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02016e8:	e390                	sd	a2,0(a5)
ffffffffc02016ea:	e710                	sd	a2,8(a4)
    elm->next = next;
    elm->prev = prev;
ffffffffc02016ec:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc02016ee:	f11c                	sd	a5,32(a0)
    if (le != &free_list)
ffffffffc02016f0:	00d70d63          	beq	a4,a3,ffffffffc020170a <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc02016f4:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc02016f8:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc02016fc:	02059813          	slli	a6,a1,0x20
ffffffffc0201700:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201704:	97b2                	add	a5,a5,a2
ffffffffc0201706:	02f50c63          	beq	a0,a5,ffffffffc020173e <default_free_pages+0xd6>
    return listelm->next;
ffffffffc020170a:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc020170c:	00d78c63          	beq	a5,a3,ffffffffc0201724 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc0201710:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201712:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0201716:	02061593          	slli	a1,a2,0x20
ffffffffc020171a:	01a5d713          	srli	a4,a1,0x1a
ffffffffc020171e:	972a                	add	a4,a4,a0
ffffffffc0201720:	04e68c63          	beq	a3,a4,ffffffffc0201778 <default_free_pages+0x110>
}
ffffffffc0201724:	60a2                	ld	ra,8(sp)
ffffffffc0201726:	0141                	addi	sp,sp,16
ffffffffc0201728:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020172a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020172c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020172e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201730:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201732:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc0201734:	02d70f63          	beq	a4,a3,ffffffffc0201772 <default_free_pages+0x10a>
ffffffffc0201738:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc020173a:	87ba                	mv	a5,a4
ffffffffc020173c:	bf71                	j	ffffffffc02016d8 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc020173e:	491c                	lw	a5,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201740:	5875                	li	a6,-3
ffffffffc0201742:	9fad                	addw	a5,a5,a1
ffffffffc0201744:	fef72c23          	sw	a5,-8(a4)
ffffffffc0201748:	6108b02f          	amoand.d	zero,a6,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020174c:	01853803          	ld	a6,24(a0)
ffffffffc0201750:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201752:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201754:	00b83423          	sd	a1,8(a6) # ff0008 <_binary_obj___user_matrix_out_size+0xfe4ad8>
    return listelm->next;
ffffffffc0201758:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc020175a:	0105b023          	sd	a6,0(a1)
ffffffffc020175e:	b77d                	j	ffffffffc020170c <default_free_pages+0xa4>
}
ffffffffc0201760:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201762:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201766:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201768:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc020176a:	e398                	sd	a4,0(a5)
ffffffffc020176c:	e798                	sd	a4,8(a5)
}
ffffffffc020176e:	0141                	addi	sp,sp,16
ffffffffc0201770:	8082                	ret
ffffffffc0201772:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc0201774:	873e                	mv	a4,a5
ffffffffc0201776:	bfad                	j	ffffffffc02016f0 <default_free_pages+0x88>
            base->property += p->property;
ffffffffc0201778:	ff87a703          	lw	a4,-8(a5)
ffffffffc020177c:	56f5                	li	a3,-3
ffffffffc020177e:	9f31                	addw	a4,a4,a2
ffffffffc0201780:	c918                	sw	a4,16(a0)
ffffffffc0201782:	ff078713          	addi	a4,a5,-16
ffffffffc0201786:	60d7302f          	amoand.d	zero,a3,(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc020178a:	6398                	ld	a4,0(a5)
ffffffffc020178c:	679c                	ld	a5,8(a5)
}
ffffffffc020178e:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201790:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201792:	e398                	sd	a4,0(a5)
ffffffffc0201794:	0141                	addi	sp,sp,16
ffffffffc0201796:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201798:	00006697          	auipc	a3,0x6
ffffffffc020179c:	82068693          	addi	a3,a3,-2016 # ffffffffc0206fb8 <etext+0xd4a>
ffffffffc02017a0:	00005617          	auipc	a2,0x5
ffffffffc02017a4:	4b860613          	addi	a2,a2,1208 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02017a8:	09400593          	li	a1,148
ffffffffc02017ac:	00005517          	auipc	a0,0x5
ffffffffc02017b0:	4c450513          	addi	a0,a0,1220 # ffffffffc0206c70 <etext+0xa02>
ffffffffc02017b4:	c97fe0ef          	jal	ffffffffc020044a <__panic>
    assert(n > 0);
ffffffffc02017b8:	00005697          	auipc	a3,0x5
ffffffffc02017bc:	7f868693          	addi	a3,a3,2040 # ffffffffc0206fb0 <etext+0xd42>
ffffffffc02017c0:	00005617          	auipc	a2,0x5
ffffffffc02017c4:	49860613          	addi	a2,a2,1176 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02017c8:	09000593          	li	a1,144
ffffffffc02017cc:	00005517          	auipc	a0,0x5
ffffffffc02017d0:	4a450513          	addi	a0,a0,1188 # ffffffffc0206c70 <etext+0xa02>
ffffffffc02017d4:	c77fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02017d8 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02017d8:	c951                	beqz	a0,ffffffffc020186c <default_alloc_pages+0x94>
    if (n > nr_free)
ffffffffc02017da:	000b0597          	auipc	a1,0xb0
ffffffffc02017de:	dbe5a583          	lw	a1,-578(a1) # ffffffffc02b1598 <free_area+0x10>
ffffffffc02017e2:	86aa                	mv	a3,a0
ffffffffc02017e4:	02059793          	slli	a5,a1,0x20
ffffffffc02017e8:	9381                	srli	a5,a5,0x20
ffffffffc02017ea:	00a7ef63          	bltu	a5,a0,ffffffffc0201808 <default_alloc_pages+0x30>
    list_entry_t *le = &free_list;
ffffffffc02017ee:	000b0617          	auipc	a2,0xb0
ffffffffc02017f2:	d9a60613          	addi	a2,a2,-614 # ffffffffc02b1588 <free_area>
ffffffffc02017f6:	87b2                	mv	a5,a2
ffffffffc02017f8:	a029                	j	ffffffffc0201802 <default_alloc_pages+0x2a>
        if (p->property >= n)
ffffffffc02017fa:	ff87e703          	lwu	a4,-8(a5)
ffffffffc02017fe:	00d77763          	bgeu	a4,a3,ffffffffc020180c <default_alloc_pages+0x34>
    return listelm->next;
ffffffffc0201802:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201804:	fec79be3          	bne	a5,a2,ffffffffc02017fa <default_alloc_pages+0x22>
        return NULL;
ffffffffc0201808:	4501                	li	a0,0
}
ffffffffc020180a:	8082                	ret
        if (page->property > n)
ffffffffc020180c:	ff87a883          	lw	a7,-8(a5)
    return listelm->prev;
ffffffffc0201810:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201814:	6798                	ld	a4,8(a5)
ffffffffc0201816:	02089313          	slli	t1,a7,0x20
ffffffffc020181a:	02035313          	srli	t1,t1,0x20
    prev->next = next;
ffffffffc020181e:	00e83423          	sd	a4,8(a6)
    next->prev = prev;
ffffffffc0201822:	01073023          	sd	a6,0(a4)
        struct Page *p = le2page(le, page_link);
ffffffffc0201826:	fe878513          	addi	a0,a5,-24
        if (page->property > n)
ffffffffc020182a:	0266fa63          	bgeu	a3,t1,ffffffffc020185e <default_alloc_pages+0x86>
            struct Page *p = page + n;
ffffffffc020182e:	00669713          	slli	a4,a3,0x6
            p->property = page->property - n;
ffffffffc0201832:	40d888bb          	subw	a7,a7,a3
            struct Page *p = page + n;
ffffffffc0201836:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201838:	01172823          	sw	a7,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020183c:	00870313          	addi	t1,a4,8
ffffffffc0201840:	4889                	li	a7,2
ffffffffc0201842:	4113302f          	amoor.d	zero,a7,(t1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201846:	00883883          	ld	a7,8(a6)
            list_add(prev, &(p->page_link));
ffffffffc020184a:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc020184e:	0068b023          	sd	t1,0(a7)
ffffffffc0201852:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc0201856:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc020185a:	01073c23          	sd	a6,24(a4)
        nr_free -= n;
ffffffffc020185e:	9d95                	subw	a1,a1,a3
ffffffffc0201860:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201862:	5775                	li	a4,-3
ffffffffc0201864:	17c1                	addi	a5,a5,-16
ffffffffc0201866:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc020186a:	8082                	ret
{
ffffffffc020186c:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020186e:	00005697          	auipc	a3,0x5
ffffffffc0201872:	74268693          	addi	a3,a3,1858 # ffffffffc0206fb0 <etext+0xd42>
ffffffffc0201876:	00005617          	auipc	a2,0x5
ffffffffc020187a:	3e260613          	addi	a2,a2,994 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc020187e:	06c00593          	li	a1,108
ffffffffc0201882:	00005517          	auipc	a0,0x5
ffffffffc0201886:	3ee50513          	addi	a0,a0,1006 # ffffffffc0206c70 <etext+0xa02>
{
ffffffffc020188a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020188c:	bbffe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201890 <default_init_memmap>:
{
ffffffffc0201890:	1141                	addi	sp,sp,-16
ffffffffc0201892:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201894:	c9e1                	beqz	a1,ffffffffc0201964 <default_init_memmap+0xd4>
    for (; p != base + n; p++)
ffffffffc0201896:	00659713          	slli	a4,a1,0x6
ffffffffc020189a:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc020189e:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc02018a0:	cf11                	beqz	a4,ffffffffc02018bc <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02018a2:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02018a4:	8b05                	andi	a4,a4,1
ffffffffc02018a6:	cf59                	beqz	a4,ffffffffc0201944 <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc02018a8:	0007a823          	sw	zero,16(a5)
ffffffffc02018ac:	0007b423          	sd	zero,8(a5)
ffffffffc02018b0:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02018b4:	04078793          	addi	a5,a5,64
ffffffffc02018b8:	fed795e3          	bne	a5,a3,ffffffffc02018a2 <default_init_memmap+0x12>
    base->property = n;
ffffffffc02018bc:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02018be:	4789                	li	a5,2
ffffffffc02018c0:	00850713          	addi	a4,a0,8
ffffffffc02018c4:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02018c8:	000b0717          	auipc	a4,0xb0
ffffffffc02018cc:	cd072703          	lw	a4,-816(a4) # ffffffffc02b1598 <free_area+0x10>
ffffffffc02018d0:	000b0697          	auipc	a3,0xb0
ffffffffc02018d4:	cb868693          	addi	a3,a3,-840 # ffffffffc02b1588 <free_area>
    return list->next == list;
ffffffffc02018d8:	669c                	ld	a5,8(a3)
ffffffffc02018da:	9f2d                	addw	a4,a4,a1
ffffffffc02018dc:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc02018de:	04d78663          	beq	a5,a3,ffffffffc020192a <default_init_memmap+0x9a>
            struct Page *page = le2page(le, page_link);
ffffffffc02018e2:	fe878713          	addi	a4,a5,-24
ffffffffc02018e6:	4581                	li	a1,0
ffffffffc02018e8:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc02018ec:	00e56a63          	bltu	a0,a4,ffffffffc0201900 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc02018f0:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02018f2:	02d70263          	beq	a4,a3,ffffffffc0201916 <default_init_memmap+0x86>
    struct Page *p = base;
ffffffffc02018f6:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02018f8:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02018fc:	fee57ae3          	bgeu	a0,a4,ffffffffc02018f0 <default_init_memmap+0x60>
ffffffffc0201900:	c199                	beqz	a1,ffffffffc0201906 <default_init_memmap+0x76>
ffffffffc0201902:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201906:	6398                	ld	a4,0(a5)
}
ffffffffc0201908:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020190a:	e390                	sd	a2,0(a5)
ffffffffc020190c:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc020190e:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0201910:	f11c                	sd	a5,32(a0)
ffffffffc0201912:	0141                	addi	sp,sp,16
ffffffffc0201914:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201916:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201918:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020191a:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020191c:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc020191e:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc0201920:	00d70e63          	beq	a4,a3,ffffffffc020193c <default_init_memmap+0xac>
ffffffffc0201924:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc0201926:	87ba                	mv	a5,a4
ffffffffc0201928:	bfc1                	j	ffffffffc02018f8 <default_init_memmap+0x68>
}
ffffffffc020192a:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc020192c:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201930:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201932:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0201934:	e398                	sd	a4,0(a5)
ffffffffc0201936:	e798                	sd	a4,8(a5)
}
ffffffffc0201938:	0141                	addi	sp,sp,16
ffffffffc020193a:	8082                	ret
ffffffffc020193c:	60a2                	ld	ra,8(sp)
ffffffffc020193e:	e290                	sd	a2,0(a3)
ffffffffc0201940:	0141                	addi	sp,sp,16
ffffffffc0201942:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201944:	00005697          	auipc	a3,0x5
ffffffffc0201948:	69c68693          	addi	a3,a3,1692 # ffffffffc0206fe0 <etext+0xd72>
ffffffffc020194c:	00005617          	auipc	a2,0x5
ffffffffc0201950:	30c60613          	addi	a2,a2,780 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201954:	04b00593          	li	a1,75
ffffffffc0201958:	00005517          	auipc	a0,0x5
ffffffffc020195c:	31850513          	addi	a0,a0,792 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201960:	aebfe0ef          	jal	ffffffffc020044a <__panic>
    assert(n > 0);
ffffffffc0201964:	00005697          	auipc	a3,0x5
ffffffffc0201968:	64c68693          	addi	a3,a3,1612 # ffffffffc0206fb0 <etext+0xd42>
ffffffffc020196c:	00005617          	auipc	a2,0x5
ffffffffc0201970:	2ec60613          	addi	a2,a2,748 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201974:	04700593          	li	a1,71
ffffffffc0201978:	00005517          	auipc	a0,0x5
ffffffffc020197c:	2f850513          	addi	a0,a0,760 # ffffffffc0206c70 <etext+0xa02>
ffffffffc0201980:	acbfe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201984 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201984:	c531                	beqz	a0,ffffffffc02019d0 <slob_free+0x4c>
		return;

	if (size)
ffffffffc0201986:	e9b9                	bnez	a1,ffffffffc02019dc <slob_free+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201988:	100027f3          	csrr	a5,sstatus
ffffffffc020198c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020198e:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201990:	efb1                	bnez	a5,ffffffffc02019ec <slob_free+0x68>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201992:	000af797          	auipc	a5,0xaf
ffffffffc0201996:	7e67b783          	ld	a5,2022(a5) # ffffffffc02b1178 <slobfree>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020199a:	873e                	mv	a4,a5
ffffffffc020199c:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020199e:	02a77a63          	bgeu	a4,a0,ffffffffc02019d2 <slob_free+0x4e>
ffffffffc02019a2:	00f56463          	bltu	a0,a5,ffffffffc02019aa <slob_free+0x26>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02019a6:	fef76ae3          	bltu	a4,a5,ffffffffc020199a <slob_free+0x16>
			break;

	if (b + b->units == cur->next)
ffffffffc02019aa:	4110                	lw	a2,0(a0)
ffffffffc02019ac:	00461693          	slli	a3,a2,0x4
ffffffffc02019b0:	96aa                	add	a3,a3,a0
ffffffffc02019b2:	0ad78463          	beq	a5,a3,ffffffffc0201a5a <slob_free+0xd6>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc02019b6:	4310                	lw	a2,0(a4)
ffffffffc02019b8:	e51c                	sd	a5,8(a0)
ffffffffc02019ba:	00461693          	slli	a3,a2,0x4
ffffffffc02019be:	96ba                	add	a3,a3,a4
ffffffffc02019c0:	08d50163          	beq	a0,a3,ffffffffc0201a42 <slob_free+0xbe>
ffffffffc02019c4:	e708                	sd	a0,8(a4)
		cur->next = b->next;
	}
	else
		cur->next = b;

	slobfree = cur;
ffffffffc02019c6:	000af797          	auipc	a5,0xaf
ffffffffc02019ca:	7ae7b923          	sd	a4,1970(a5) # ffffffffc02b1178 <slobfree>
    if (flag)
ffffffffc02019ce:	e9a5                	bnez	a1,ffffffffc0201a3e <slob_free+0xba>
ffffffffc02019d0:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02019d2:	fcf574e3          	bgeu	a0,a5,ffffffffc020199a <slob_free+0x16>
ffffffffc02019d6:	fcf762e3          	bltu	a4,a5,ffffffffc020199a <slob_free+0x16>
ffffffffc02019da:	bfc1                	j	ffffffffc02019aa <slob_free+0x26>
		b->units = SLOB_UNITS(size);
ffffffffc02019dc:	25bd                	addiw	a1,a1,15
ffffffffc02019de:	8191                	srli	a1,a1,0x4
ffffffffc02019e0:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02019e2:	100027f3          	csrr	a5,sstatus
ffffffffc02019e6:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02019e8:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02019ea:	d7c5                	beqz	a5,ffffffffc0201992 <slob_free+0xe>
{
ffffffffc02019ec:	1101                	addi	sp,sp,-32
ffffffffc02019ee:	e42a                	sd	a0,8(sp)
ffffffffc02019f0:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02019f2:	f19fe0ef          	jal	ffffffffc020090a <intr_disable>
        return 1;
ffffffffc02019f6:	6522                	ld	a0,8(sp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02019f8:	000af797          	auipc	a5,0xaf
ffffffffc02019fc:	7807b783          	ld	a5,1920(a5) # ffffffffc02b1178 <slobfree>
ffffffffc0201a00:	4585                	li	a1,1
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201a02:	873e                	mv	a4,a5
ffffffffc0201a04:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201a06:	06a77663          	bgeu	a4,a0,ffffffffc0201a72 <slob_free+0xee>
ffffffffc0201a0a:	00f56463          	bltu	a0,a5,ffffffffc0201a12 <slob_free+0x8e>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201a0e:	fef76ae3          	bltu	a4,a5,ffffffffc0201a02 <slob_free+0x7e>
	if (b + b->units == cur->next)
ffffffffc0201a12:	4110                	lw	a2,0(a0)
ffffffffc0201a14:	00461693          	slli	a3,a2,0x4
ffffffffc0201a18:	96aa                	add	a3,a3,a0
ffffffffc0201a1a:	06d78363          	beq	a5,a3,ffffffffc0201a80 <slob_free+0xfc>
	if (cur + cur->units == b)
ffffffffc0201a1e:	4310                	lw	a2,0(a4)
ffffffffc0201a20:	e51c                	sd	a5,8(a0)
ffffffffc0201a22:	00461693          	slli	a3,a2,0x4
ffffffffc0201a26:	96ba                	add	a3,a3,a4
ffffffffc0201a28:	06d50163          	beq	a0,a3,ffffffffc0201a8a <slob_free+0x106>
ffffffffc0201a2c:	e708                	sd	a0,8(a4)
	slobfree = cur;
ffffffffc0201a2e:	000af797          	auipc	a5,0xaf
ffffffffc0201a32:	74e7b523          	sd	a4,1866(a5) # ffffffffc02b1178 <slobfree>
    if (flag)
ffffffffc0201a36:	e1a9                	bnez	a1,ffffffffc0201a78 <slob_free+0xf4>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201a38:	60e2                	ld	ra,24(sp)
ffffffffc0201a3a:	6105                	addi	sp,sp,32
ffffffffc0201a3c:	8082                	ret
        intr_enable();
ffffffffc0201a3e:	ec7fe06f          	j	ffffffffc0200904 <intr_enable>
		cur->units += b->units;
ffffffffc0201a42:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201a44:	853e                	mv	a0,a5
ffffffffc0201a46:	e708                	sd	a0,8(a4)
		cur->units += b->units;
ffffffffc0201a48:	00c687bb          	addw	a5,a3,a2
ffffffffc0201a4c:	c31c                	sw	a5,0(a4)
	slobfree = cur;
ffffffffc0201a4e:	000af797          	auipc	a5,0xaf
ffffffffc0201a52:	72e7b523          	sd	a4,1834(a5) # ffffffffc02b1178 <slobfree>
    if (flag)
ffffffffc0201a56:	ddad                	beqz	a1,ffffffffc02019d0 <slob_free+0x4c>
ffffffffc0201a58:	b7dd                	j	ffffffffc0201a3e <slob_free+0xba>
		b->units += cur->next->units;
ffffffffc0201a5a:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201a5c:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201a5e:	9eb1                	addw	a3,a3,a2
ffffffffc0201a60:	c114                	sw	a3,0(a0)
	if (cur + cur->units == b)
ffffffffc0201a62:	4310                	lw	a2,0(a4)
ffffffffc0201a64:	e51c                	sd	a5,8(a0)
ffffffffc0201a66:	00461693          	slli	a3,a2,0x4
ffffffffc0201a6a:	96ba                	add	a3,a3,a4
ffffffffc0201a6c:	f4d51ce3          	bne	a0,a3,ffffffffc02019c4 <slob_free+0x40>
ffffffffc0201a70:	bfc9                	j	ffffffffc0201a42 <slob_free+0xbe>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201a72:	f8f56ee3          	bltu	a0,a5,ffffffffc0201a0e <slob_free+0x8a>
ffffffffc0201a76:	b771                	j	ffffffffc0201a02 <slob_free+0x7e>
}
ffffffffc0201a78:	60e2                	ld	ra,24(sp)
ffffffffc0201a7a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201a7c:	e89fe06f          	j	ffffffffc0200904 <intr_enable>
		b->units += cur->next->units;
ffffffffc0201a80:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201a82:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201a84:	9eb1                	addw	a3,a3,a2
ffffffffc0201a86:	c114                	sw	a3,0(a0)
		b->next = cur->next->next;
ffffffffc0201a88:	bf59                	j	ffffffffc0201a1e <slob_free+0x9a>
		cur->units += b->units;
ffffffffc0201a8a:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201a8c:	853e                	mv	a0,a5
		cur->units += b->units;
ffffffffc0201a8e:	00c687bb          	addw	a5,a3,a2
ffffffffc0201a92:	c31c                	sw	a5,0(a4)
		cur->next = b->next;
ffffffffc0201a94:	bf61                	j	ffffffffc0201a2c <slob_free+0xa8>

ffffffffc0201a96 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a96:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201a98:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a9a:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201a9e:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201aa0:	32a000ef          	jal	ffffffffc0201dca <alloc_pages>
	if (!page)
ffffffffc0201aa4:	c91d                	beqz	a0,ffffffffc0201ada <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201aa6:	000b4697          	auipc	a3,0xb4
ffffffffc0201aaa:	b926b683          	ld	a3,-1134(a3) # ffffffffc02b5638 <pages>
ffffffffc0201aae:	00007797          	auipc	a5,0x7
ffffffffc0201ab2:	0527b783          	ld	a5,82(a5) # ffffffffc0208b00 <nbase>
    return KADDR(page2pa(page));
ffffffffc0201ab6:	000b4717          	auipc	a4,0xb4
ffffffffc0201aba:	b7a73703          	ld	a4,-1158(a4) # ffffffffc02b5630 <npage>
    return page - pages + nbase;
ffffffffc0201abe:	8d15                	sub	a0,a0,a3
ffffffffc0201ac0:	8519                	srai	a0,a0,0x6
ffffffffc0201ac2:	953e                	add	a0,a0,a5
    return KADDR(page2pa(page));
ffffffffc0201ac4:	00c51793          	slli	a5,a0,0xc
ffffffffc0201ac8:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201aca:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201acc:	00e7fa63          	bgeu	a5,a4,ffffffffc0201ae0 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201ad0:	000b4797          	auipc	a5,0xb4
ffffffffc0201ad4:	b587b783          	ld	a5,-1192(a5) # ffffffffc02b5628 <va_pa_offset>
ffffffffc0201ad8:	953e                	add	a0,a0,a5
}
ffffffffc0201ada:	60a2                	ld	ra,8(sp)
ffffffffc0201adc:	0141                	addi	sp,sp,16
ffffffffc0201ade:	8082                	ret
ffffffffc0201ae0:	86aa                	mv	a3,a0
ffffffffc0201ae2:	00005617          	auipc	a2,0x5
ffffffffc0201ae6:	52660613          	addi	a2,a2,1318 # ffffffffc0207008 <etext+0xd9a>
ffffffffc0201aea:	07100593          	li	a1,113
ffffffffc0201aee:	00005517          	auipc	a0,0x5
ffffffffc0201af2:	54250513          	addi	a0,a0,1346 # ffffffffc0207030 <etext+0xdc2>
ffffffffc0201af6:	955fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201afa <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201afa:	7179                	addi	sp,sp,-48
ffffffffc0201afc:	f406                	sd	ra,40(sp)
ffffffffc0201afe:	f022                	sd	s0,32(sp)
ffffffffc0201b00:	ec26                	sd	s1,24(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201b02:	01050713          	addi	a4,a0,16
ffffffffc0201b06:	6785                	lui	a5,0x1
ffffffffc0201b08:	0af77e63          	bgeu	a4,a5,ffffffffc0201bc4 <slob_alloc.constprop.0+0xca>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201b0c:	00f50413          	addi	s0,a0,15
ffffffffc0201b10:	8011                	srli	s0,s0,0x4
ffffffffc0201b12:	2401                	sext.w	s0,s0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b14:	100025f3          	csrr	a1,sstatus
ffffffffc0201b18:	8989                	andi	a1,a1,2
ffffffffc0201b1a:	edd1                	bnez	a1,ffffffffc0201bb6 <slob_alloc.constprop.0+0xbc>
	prev = slobfree;
ffffffffc0201b1c:	000af497          	auipc	s1,0xaf
ffffffffc0201b20:	65c48493          	addi	s1,s1,1628 # ffffffffc02b1178 <slobfree>
ffffffffc0201b24:	6090                	ld	a2,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201b26:	6618                	ld	a4,8(a2)
		if (cur->units >= units + delta)
ffffffffc0201b28:	4314                	lw	a3,0(a4)
ffffffffc0201b2a:	0886da63          	bge	a3,s0,ffffffffc0201bbe <slob_alloc.constprop.0+0xc4>
		if (cur == slobfree)
ffffffffc0201b2e:	00e60a63          	beq	a2,a4,ffffffffc0201b42 <slob_alloc.constprop.0+0x48>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201b32:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201b34:	4394                	lw	a3,0(a5)
ffffffffc0201b36:	0286d863          	bge	a3,s0,ffffffffc0201b66 <slob_alloc.constprop.0+0x6c>
		if (cur == slobfree)
ffffffffc0201b3a:	6090                	ld	a2,0(s1)
ffffffffc0201b3c:	873e                	mv	a4,a5
ffffffffc0201b3e:	fee61ae3          	bne	a2,a4,ffffffffc0201b32 <slob_alloc.constprop.0+0x38>
    if (flag)
ffffffffc0201b42:	e9b1                	bnez	a1,ffffffffc0201b96 <slob_alloc.constprop.0+0x9c>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201b44:	4501                	li	a0,0
ffffffffc0201b46:	f51ff0ef          	jal	ffffffffc0201a96 <__slob_get_free_pages.constprop.0>
ffffffffc0201b4a:	87aa                	mv	a5,a0
			if (!cur)
ffffffffc0201b4c:	c915                	beqz	a0,ffffffffc0201b80 <slob_alloc.constprop.0+0x86>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201b4e:	6585                	lui	a1,0x1
ffffffffc0201b50:	e35ff0ef          	jal	ffffffffc0201984 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b54:	100025f3          	csrr	a1,sstatus
ffffffffc0201b58:	8989                	andi	a1,a1,2
ffffffffc0201b5a:	e98d                	bnez	a1,ffffffffc0201b8c <slob_alloc.constprop.0+0x92>
			cur = slobfree;
ffffffffc0201b5c:	6098                	ld	a4,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201b5e:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201b60:	4394                	lw	a3,0(a5)
ffffffffc0201b62:	fc86cce3          	blt	a3,s0,ffffffffc0201b3a <slob_alloc.constprop.0+0x40>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201b66:	04d40563          	beq	s0,a3,ffffffffc0201bb0 <slob_alloc.constprop.0+0xb6>
				prev->next = cur + units;
ffffffffc0201b6a:	00441613          	slli	a2,s0,0x4
ffffffffc0201b6e:	963e                	add	a2,a2,a5
ffffffffc0201b70:	e710                	sd	a2,8(a4)
				prev->next->next = cur->next;
ffffffffc0201b72:	6788                	ld	a0,8(a5)
				prev->next->units = cur->units - units;
ffffffffc0201b74:	9e81                	subw	a3,a3,s0
ffffffffc0201b76:	c214                	sw	a3,0(a2)
				prev->next->next = cur->next;
ffffffffc0201b78:	e608                	sd	a0,8(a2)
				cur->units = units;
ffffffffc0201b7a:	c380                	sw	s0,0(a5)
			slobfree = prev;
ffffffffc0201b7c:	e098                	sd	a4,0(s1)
    if (flag)
ffffffffc0201b7e:	ed99                	bnez	a1,ffffffffc0201b9c <slob_alloc.constprop.0+0xa2>
}
ffffffffc0201b80:	70a2                	ld	ra,40(sp)
ffffffffc0201b82:	7402                	ld	s0,32(sp)
ffffffffc0201b84:	64e2                	ld	s1,24(sp)
ffffffffc0201b86:	853e                	mv	a0,a5
ffffffffc0201b88:	6145                	addi	sp,sp,48
ffffffffc0201b8a:	8082                	ret
        intr_disable();
ffffffffc0201b8c:	d7ffe0ef          	jal	ffffffffc020090a <intr_disable>
			cur = slobfree;
ffffffffc0201b90:	6098                	ld	a4,0(s1)
        return 1;
ffffffffc0201b92:	4585                	li	a1,1
ffffffffc0201b94:	b7e9                	j	ffffffffc0201b5e <slob_alloc.constprop.0+0x64>
        intr_enable();
ffffffffc0201b96:	d6ffe0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0201b9a:	b76d                	j	ffffffffc0201b44 <slob_alloc.constprop.0+0x4a>
ffffffffc0201b9c:	e43e                	sd	a5,8(sp)
ffffffffc0201b9e:	d67fe0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0201ba2:	67a2                	ld	a5,8(sp)
}
ffffffffc0201ba4:	70a2                	ld	ra,40(sp)
ffffffffc0201ba6:	7402                	ld	s0,32(sp)
ffffffffc0201ba8:	64e2                	ld	s1,24(sp)
ffffffffc0201baa:	853e                	mv	a0,a5
ffffffffc0201bac:	6145                	addi	sp,sp,48
ffffffffc0201bae:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201bb0:	6794                	ld	a3,8(a5)
ffffffffc0201bb2:	e714                	sd	a3,8(a4)
ffffffffc0201bb4:	b7e1                	j	ffffffffc0201b7c <slob_alloc.constprop.0+0x82>
        intr_disable();
ffffffffc0201bb6:	d55fe0ef          	jal	ffffffffc020090a <intr_disable>
        return 1;
ffffffffc0201bba:	4585                	li	a1,1
ffffffffc0201bbc:	b785                	j	ffffffffc0201b1c <slob_alloc.constprop.0+0x22>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201bbe:	87ba                	mv	a5,a4
	prev = slobfree;
ffffffffc0201bc0:	8732                	mv	a4,a2
ffffffffc0201bc2:	b755                	j	ffffffffc0201b66 <slob_alloc.constprop.0+0x6c>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201bc4:	00005697          	auipc	a3,0x5
ffffffffc0201bc8:	47c68693          	addi	a3,a3,1148 # ffffffffc0207040 <etext+0xdd2>
ffffffffc0201bcc:	00005617          	auipc	a2,0x5
ffffffffc0201bd0:	08c60613          	addi	a2,a2,140 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0201bd4:	06300593          	li	a1,99
ffffffffc0201bd8:	00005517          	auipc	a0,0x5
ffffffffc0201bdc:	48850513          	addi	a0,a0,1160 # ffffffffc0207060 <etext+0xdf2>
ffffffffc0201be0:	86bfe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201be4 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201be4:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201be6:	00005517          	auipc	a0,0x5
ffffffffc0201bea:	49250513          	addi	a0,a0,1170 # ffffffffc0207078 <etext+0xe0a>
{
ffffffffc0201bee:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201bf0:	da8fe0ef          	jal	ffffffffc0200198 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201bf4:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201bf6:	00005517          	auipc	a0,0x5
ffffffffc0201bfa:	49a50513          	addi	a0,a0,1178 # ffffffffc0207090 <etext+0xe22>
}
ffffffffc0201bfe:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201c00:	d98fe06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0201c04 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201c04:	4501                	li	a0,0
ffffffffc0201c06:	8082                	ret

ffffffffc0201c08 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201c08:	1101                	addi	sp,sp,-32
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201c0a:	6685                	lui	a3,0x1
{
ffffffffc0201c0c:	ec06                	sd	ra,24(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201c0e:	16bd                	addi	a3,a3,-17 # fef <_binary_obj___user_softint_out_size-0x7f39>
ffffffffc0201c10:	04a6f963          	bgeu	a3,a0,ffffffffc0201c62 <kmalloc+0x5a>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201c14:	e42a                	sd	a0,8(sp)
ffffffffc0201c16:	4561                	li	a0,24
ffffffffc0201c18:	e822                	sd	s0,16(sp)
ffffffffc0201c1a:	ee1ff0ef          	jal	ffffffffc0201afa <slob_alloc.constprop.0>
ffffffffc0201c1e:	842a                	mv	s0,a0
	if (!bb)
ffffffffc0201c20:	c541                	beqz	a0,ffffffffc0201ca8 <kmalloc+0xa0>
	bb->order = find_order(size);
ffffffffc0201c22:	47a2                	lw	a5,8(sp)
	for (; size > 4096; size >>= 1)
ffffffffc0201c24:	6705                	lui	a4,0x1
	int order = 0;
ffffffffc0201c26:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201c28:	00f75763          	bge	a4,a5,ffffffffc0201c36 <kmalloc+0x2e>
ffffffffc0201c2c:	4017d79b          	sraiw	a5,a5,0x1
		order++;
ffffffffc0201c30:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201c32:	fef74de3          	blt	a4,a5,ffffffffc0201c2c <kmalloc+0x24>
	bb->order = find_order(size);
ffffffffc0201c36:	c008                	sw	a0,0(s0)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201c38:	e5fff0ef          	jal	ffffffffc0201a96 <__slob_get_free_pages.constprop.0>
ffffffffc0201c3c:	e408                	sd	a0,8(s0)
	if (bb->pages)
ffffffffc0201c3e:	cd31                	beqz	a0,ffffffffc0201c9a <kmalloc+0x92>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c40:	100027f3          	csrr	a5,sstatus
ffffffffc0201c44:	8b89                	andi	a5,a5,2
ffffffffc0201c46:	eb85                	bnez	a5,ffffffffc0201c76 <kmalloc+0x6e>
		bb->next = bigblocks;
ffffffffc0201c48:	000b4797          	auipc	a5,0xb4
ffffffffc0201c4c:	9c07b783          	ld	a5,-1600(a5) # ffffffffc02b5608 <bigblocks>
		bigblocks = bb;
ffffffffc0201c50:	000b4717          	auipc	a4,0xb4
ffffffffc0201c54:	9a873c23          	sd	s0,-1608(a4) # ffffffffc02b5608 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201c58:	e81c                	sd	a5,16(s0)
    if (flag)
ffffffffc0201c5a:	6442                	ld	s0,16(sp)
	return __kmalloc(size, 0);
}
ffffffffc0201c5c:	60e2                	ld	ra,24(sp)
ffffffffc0201c5e:	6105                	addi	sp,sp,32
ffffffffc0201c60:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201c62:	0541                	addi	a0,a0,16
ffffffffc0201c64:	e97ff0ef          	jal	ffffffffc0201afa <slob_alloc.constprop.0>
ffffffffc0201c68:	87aa                	mv	a5,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0201c6a:	0541                	addi	a0,a0,16
ffffffffc0201c6c:	fbe5                	bnez	a5,ffffffffc0201c5c <kmalloc+0x54>
		return 0;
ffffffffc0201c6e:	4501                	li	a0,0
}
ffffffffc0201c70:	60e2                	ld	ra,24(sp)
ffffffffc0201c72:	6105                	addi	sp,sp,32
ffffffffc0201c74:	8082                	ret
        intr_disable();
ffffffffc0201c76:	c95fe0ef          	jal	ffffffffc020090a <intr_disable>
		bb->next = bigblocks;
ffffffffc0201c7a:	000b4797          	auipc	a5,0xb4
ffffffffc0201c7e:	98e7b783          	ld	a5,-1650(a5) # ffffffffc02b5608 <bigblocks>
		bigblocks = bb;
ffffffffc0201c82:	000b4717          	auipc	a4,0xb4
ffffffffc0201c86:	98873323          	sd	s0,-1658(a4) # ffffffffc02b5608 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201c8a:	e81c                	sd	a5,16(s0)
        intr_enable();
ffffffffc0201c8c:	c79fe0ef          	jal	ffffffffc0200904 <intr_enable>
		return bb->pages;
ffffffffc0201c90:	6408                	ld	a0,8(s0)
}
ffffffffc0201c92:	60e2                	ld	ra,24(sp)
		return bb->pages;
ffffffffc0201c94:	6442                	ld	s0,16(sp)
}
ffffffffc0201c96:	6105                	addi	sp,sp,32
ffffffffc0201c98:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201c9a:	8522                	mv	a0,s0
ffffffffc0201c9c:	45e1                	li	a1,24
ffffffffc0201c9e:	ce7ff0ef          	jal	ffffffffc0201984 <slob_free>
		return 0;
ffffffffc0201ca2:	4501                	li	a0,0
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201ca4:	6442                	ld	s0,16(sp)
ffffffffc0201ca6:	b7e9                	j	ffffffffc0201c70 <kmalloc+0x68>
ffffffffc0201ca8:	6442                	ld	s0,16(sp)
		return 0;
ffffffffc0201caa:	4501                	li	a0,0
ffffffffc0201cac:	b7d1                	j	ffffffffc0201c70 <kmalloc+0x68>

ffffffffc0201cae <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201cae:	c571                	beqz	a0,ffffffffc0201d7a <kfree+0xcc>
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201cb0:	03451793          	slli	a5,a0,0x34
ffffffffc0201cb4:	e3e1                	bnez	a5,ffffffffc0201d74 <kfree+0xc6>
{
ffffffffc0201cb6:	1101                	addi	sp,sp,-32
ffffffffc0201cb8:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201cba:	100027f3          	csrr	a5,sstatus
ffffffffc0201cbe:	8b89                	andi	a5,a5,2
ffffffffc0201cc0:	e7c1                	bnez	a5,ffffffffc0201d48 <kfree+0x9a>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201cc2:	000b4797          	auipc	a5,0xb4
ffffffffc0201cc6:	9467b783          	ld	a5,-1722(a5) # ffffffffc02b5608 <bigblocks>
    return 0;
ffffffffc0201cca:	4581                	li	a1,0
ffffffffc0201ccc:	cbad                	beqz	a5,ffffffffc0201d3e <kfree+0x90>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201cce:	000b4617          	auipc	a2,0xb4
ffffffffc0201cd2:	93a60613          	addi	a2,a2,-1734 # ffffffffc02b5608 <bigblocks>
ffffffffc0201cd6:	a021                	j	ffffffffc0201cde <kfree+0x30>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201cd8:	01070613          	addi	a2,a4,16
ffffffffc0201cdc:	c3a5                	beqz	a5,ffffffffc0201d3c <kfree+0x8e>
		{
			if (bb->pages == block)
ffffffffc0201cde:	6794                	ld	a3,8(a5)
ffffffffc0201ce0:	873e                	mv	a4,a5
			{
				*last = bb->next;
ffffffffc0201ce2:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201ce4:	fea69ae3          	bne	a3,a0,ffffffffc0201cd8 <kfree+0x2a>
				*last = bb->next;
ffffffffc0201ce8:	e21c                	sd	a5,0(a2)
    if (flag)
ffffffffc0201cea:	edb5                	bnez	a1,ffffffffc0201d66 <kfree+0xb8>
    return pa2page(PADDR(kva));
ffffffffc0201cec:	c02007b7          	lui	a5,0xc0200
ffffffffc0201cf0:	0af56263          	bltu	a0,a5,ffffffffc0201d94 <kfree+0xe6>
ffffffffc0201cf4:	000b4797          	auipc	a5,0xb4
ffffffffc0201cf8:	9347b783          	ld	a5,-1740(a5) # ffffffffc02b5628 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0201cfc:	000b4697          	auipc	a3,0xb4
ffffffffc0201d00:	9346b683          	ld	a3,-1740(a3) # ffffffffc02b5630 <npage>
    return pa2page(PADDR(kva));
ffffffffc0201d04:	8d1d                	sub	a0,a0,a5
    if (PPN(pa) >= npage)
ffffffffc0201d06:	00c55793          	srli	a5,a0,0xc
ffffffffc0201d0a:	06d7f963          	bgeu	a5,a3,ffffffffc0201d7c <kfree+0xce>
    return &pages[PPN(pa) - nbase];
ffffffffc0201d0e:	00007617          	auipc	a2,0x7
ffffffffc0201d12:	df263603          	ld	a2,-526(a2) # ffffffffc0208b00 <nbase>
ffffffffc0201d16:	000b4517          	auipc	a0,0xb4
ffffffffc0201d1a:	92253503          	ld	a0,-1758(a0) # ffffffffc02b5638 <pages>
	free_pages(kva2page((void *)kva), 1 << order);
ffffffffc0201d1e:	4314                	lw	a3,0(a4)
ffffffffc0201d20:	8f91                	sub	a5,a5,a2
ffffffffc0201d22:	079a                	slli	a5,a5,0x6
ffffffffc0201d24:	4585                	li	a1,1
ffffffffc0201d26:	953e                	add	a0,a0,a5
ffffffffc0201d28:	00d595bb          	sllw	a1,a1,a3
ffffffffc0201d2c:	e03a                	sd	a4,0(sp)
ffffffffc0201d2e:	0d6000ef          	jal	ffffffffc0201e04 <free_pages>
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d32:	6502                	ld	a0,0(sp)
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201d34:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d36:	45e1                	li	a1,24
}
ffffffffc0201d38:	6105                	addi	sp,sp,32
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d3a:	b1a9                	j	ffffffffc0201984 <slob_free>
ffffffffc0201d3c:	e185                	bnez	a1,ffffffffc0201d5c <kfree+0xae>
}
ffffffffc0201d3e:	60e2                	ld	ra,24(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201d40:	1541                	addi	a0,a0,-16
ffffffffc0201d42:	4581                	li	a1,0
}
ffffffffc0201d44:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201d46:	b93d                	j	ffffffffc0201984 <slob_free>
        intr_disable();
ffffffffc0201d48:	e02a                	sd	a0,0(sp)
ffffffffc0201d4a:	bc1fe0ef          	jal	ffffffffc020090a <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201d4e:	000b4797          	auipc	a5,0xb4
ffffffffc0201d52:	8ba7b783          	ld	a5,-1862(a5) # ffffffffc02b5608 <bigblocks>
ffffffffc0201d56:	6502                	ld	a0,0(sp)
        return 1;
ffffffffc0201d58:	4585                	li	a1,1
ffffffffc0201d5a:	fbb5                	bnez	a5,ffffffffc0201cce <kfree+0x20>
ffffffffc0201d5c:	e02a                	sd	a0,0(sp)
        intr_enable();
ffffffffc0201d5e:	ba7fe0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0201d62:	6502                	ld	a0,0(sp)
ffffffffc0201d64:	bfe9                	j	ffffffffc0201d3e <kfree+0x90>
ffffffffc0201d66:	e42a                	sd	a0,8(sp)
ffffffffc0201d68:	e03a                	sd	a4,0(sp)
ffffffffc0201d6a:	b9bfe0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0201d6e:	6522                	ld	a0,8(sp)
ffffffffc0201d70:	6702                	ld	a4,0(sp)
ffffffffc0201d72:	bfad                	j	ffffffffc0201cec <kfree+0x3e>
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201d74:	1541                	addi	a0,a0,-16
ffffffffc0201d76:	4581                	li	a1,0
ffffffffc0201d78:	b131                	j	ffffffffc0201984 <slob_free>
ffffffffc0201d7a:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201d7c:	00005617          	auipc	a2,0x5
ffffffffc0201d80:	35c60613          	addi	a2,a2,860 # ffffffffc02070d8 <etext+0xe6a>
ffffffffc0201d84:	06900593          	li	a1,105
ffffffffc0201d88:	00005517          	auipc	a0,0x5
ffffffffc0201d8c:	2a850513          	addi	a0,a0,680 # ffffffffc0207030 <etext+0xdc2>
ffffffffc0201d90:	ebafe0ef          	jal	ffffffffc020044a <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201d94:	86aa                	mv	a3,a0
ffffffffc0201d96:	00005617          	auipc	a2,0x5
ffffffffc0201d9a:	31a60613          	addi	a2,a2,794 # ffffffffc02070b0 <etext+0xe42>
ffffffffc0201d9e:	07700593          	li	a1,119
ffffffffc0201da2:	00005517          	auipc	a0,0x5
ffffffffc0201da6:	28e50513          	addi	a0,a0,654 # ffffffffc0207030 <etext+0xdc2>
ffffffffc0201daa:	ea0fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201dae <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201dae:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201db0:	00005617          	auipc	a2,0x5
ffffffffc0201db4:	32860613          	addi	a2,a2,808 # ffffffffc02070d8 <etext+0xe6a>
ffffffffc0201db8:	06900593          	li	a1,105
ffffffffc0201dbc:	00005517          	auipc	a0,0x5
ffffffffc0201dc0:	27450513          	addi	a0,a0,628 # ffffffffc0207030 <etext+0xdc2>
pa2page(uintptr_t pa)
ffffffffc0201dc4:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201dc6:	e84fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201dca <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201dca:	100027f3          	csrr	a5,sstatus
ffffffffc0201dce:	8b89                	andi	a5,a5,2
ffffffffc0201dd0:	e799                	bnez	a5,ffffffffc0201dde <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201dd2:	000b4797          	auipc	a5,0xb4
ffffffffc0201dd6:	83e7b783          	ld	a5,-1986(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc0201dda:	6f9c                	ld	a5,24(a5)
ffffffffc0201ddc:	8782                	jr	a5
{
ffffffffc0201dde:	1101                	addi	sp,sp,-32
ffffffffc0201de0:	ec06                	sd	ra,24(sp)
ffffffffc0201de2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201de4:	b27fe0ef          	jal	ffffffffc020090a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201de8:	000b4797          	auipc	a5,0xb4
ffffffffc0201dec:	8287b783          	ld	a5,-2008(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc0201df0:	6522                	ld	a0,8(sp)
ffffffffc0201df2:	6f9c                	ld	a5,24(a5)
ffffffffc0201df4:	9782                	jalr	a5
ffffffffc0201df6:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201df8:	b0dfe0ef          	jal	ffffffffc0200904 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201dfc:	60e2                	ld	ra,24(sp)
ffffffffc0201dfe:	6522                	ld	a0,8(sp)
ffffffffc0201e00:	6105                	addi	sp,sp,32
ffffffffc0201e02:	8082                	ret

ffffffffc0201e04 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e04:	100027f3          	csrr	a5,sstatus
ffffffffc0201e08:	8b89                	andi	a5,a5,2
ffffffffc0201e0a:	e799                	bnez	a5,ffffffffc0201e18 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201e0c:	000b4797          	auipc	a5,0xb4
ffffffffc0201e10:	8047b783          	ld	a5,-2044(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc0201e14:	739c                	ld	a5,32(a5)
ffffffffc0201e16:	8782                	jr	a5
{
ffffffffc0201e18:	1101                	addi	sp,sp,-32
ffffffffc0201e1a:	ec06                	sd	ra,24(sp)
ffffffffc0201e1c:	e42e                	sd	a1,8(sp)
ffffffffc0201e1e:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0201e20:	aebfe0ef          	jal	ffffffffc020090a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201e24:	000b3797          	auipc	a5,0xb3
ffffffffc0201e28:	7ec7b783          	ld	a5,2028(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc0201e2c:	65a2                	ld	a1,8(sp)
ffffffffc0201e2e:	6502                	ld	a0,0(sp)
ffffffffc0201e30:	739c                	ld	a5,32(a5)
ffffffffc0201e32:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201e34:	60e2                	ld	ra,24(sp)
ffffffffc0201e36:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201e38:	acdfe06f          	j	ffffffffc0200904 <intr_enable>

ffffffffc0201e3c <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e3c:	100027f3          	csrr	a5,sstatus
ffffffffc0201e40:	8b89                	andi	a5,a5,2
ffffffffc0201e42:	e799                	bnez	a5,ffffffffc0201e50 <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201e44:	000b3797          	auipc	a5,0xb3
ffffffffc0201e48:	7cc7b783          	ld	a5,1996(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc0201e4c:	779c                	ld	a5,40(a5)
ffffffffc0201e4e:	8782                	jr	a5
{
ffffffffc0201e50:	1101                	addi	sp,sp,-32
ffffffffc0201e52:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201e54:	ab7fe0ef          	jal	ffffffffc020090a <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201e58:	000b3797          	auipc	a5,0xb3
ffffffffc0201e5c:	7b87b783          	ld	a5,1976(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc0201e60:	779c                	ld	a5,40(a5)
ffffffffc0201e62:	9782                	jalr	a5
ffffffffc0201e64:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201e66:	a9ffe0ef          	jal	ffffffffc0200904 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201e6a:	60e2                	ld	ra,24(sp)
ffffffffc0201e6c:	6522                	ld	a0,8(sp)
ffffffffc0201e6e:	6105                	addi	sp,sp,32
ffffffffc0201e70:	8082                	ret

ffffffffc0201e72 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201e72:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201e76:	1ff7f793          	andi	a5,a5,511
ffffffffc0201e7a:	078e                	slli	a5,a5,0x3
ffffffffc0201e7c:	00f50733          	add	a4,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201e80:	6314                	ld	a3,0(a4)
{
ffffffffc0201e82:	7139                	addi	sp,sp,-64
ffffffffc0201e84:	f822                	sd	s0,48(sp)
ffffffffc0201e86:	f426                	sd	s1,40(sp)
ffffffffc0201e88:	fc06                	sd	ra,56(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201e8a:	0016f793          	andi	a5,a3,1
{
ffffffffc0201e8e:	842e                	mv	s0,a1
ffffffffc0201e90:	8832                	mv	a6,a2
ffffffffc0201e92:	000b3497          	auipc	s1,0xb3
ffffffffc0201e96:	79e48493          	addi	s1,s1,1950 # ffffffffc02b5630 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201e9a:	ebd1                	bnez	a5,ffffffffc0201f2e <get_pte+0xbc>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201e9c:	16060d63          	beqz	a2,ffffffffc0202016 <get_pte+0x1a4>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ea0:	100027f3          	csrr	a5,sstatus
ffffffffc0201ea4:	8b89                	andi	a5,a5,2
ffffffffc0201ea6:	16079e63          	bnez	a5,ffffffffc0202022 <get_pte+0x1b0>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201eaa:	000b3797          	auipc	a5,0xb3
ffffffffc0201eae:	7667b783          	ld	a5,1894(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc0201eb2:	4505                	li	a0,1
ffffffffc0201eb4:	e43a                	sd	a4,8(sp)
ffffffffc0201eb6:	6f9c                	ld	a5,24(a5)
ffffffffc0201eb8:	e832                	sd	a2,16(sp)
ffffffffc0201eba:	9782                	jalr	a5
ffffffffc0201ebc:	6722                	ld	a4,8(sp)
ffffffffc0201ebe:	6842                	ld	a6,16(sp)
ffffffffc0201ec0:	87aa                	mv	a5,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201ec2:	14078a63          	beqz	a5,ffffffffc0202016 <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0201ec6:	000b3517          	auipc	a0,0xb3
ffffffffc0201eca:	77253503          	ld	a0,1906(a0) # ffffffffc02b5638 <pages>
ffffffffc0201ece:	000808b7          	lui	a7,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201ed2:	000b3497          	auipc	s1,0xb3
ffffffffc0201ed6:	75e48493          	addi	s1,s1,1886 # ffffffffc02b5630 <npage>
ffffffffc0201eda:	40a78533          	sub	a0,a5,a0
ffffffffc0201ede:	8519                	srai	a0,a0,0x6
ffffffffc0201ee0:	9546                	add	a0,a0,a7
ffffffffc0201ee2:	6090                	ld	a2,0(s1)
ffffffffc0201ee4:	00c51693          	slli	a3,a0,0xc
    page->ref = val;
ffffffffc0201ee8:	4585                	li	a1,1
ffffffffc0201eea:	82b1                	srli	a3,a3,0xc
ffffffffc0201eec:	c38c                	sw	a1,0(a5)
    return page2ppn(page) << PGSHIFT;
ffffffffc0201eee:	0532                	slli	a0,a0,0xc
ffffffffc0201ef0:	1ac6f763          	bgeu	a3,a2,ffffffffc020209e <get_pte+0x22c>
ffffffffc0201ef4:	000b3697          	auipc	a3,0xb3
ffffffffc0201ef8:	7346b683          	ld	a3,1844(a3) # ffffffffc02b5628 <va_pa_offset>
ffffffffc0201efc:	6605                	lui	a2,0x1
ffffffffc0201efe:	4581                	li	a1,0
ffffffffc0201f00:	9536                	add	a0,a0,a3
ffffffffc0201f02:	ec42                	sd	a6,24(sp)
ffffffffc0201f04:	e83e                	sd	a5,16(sp)
ffffffffc0201f06:	e43a                	sd	a4,8(sp)
ffffffffc0201f08:	33c040ef          	jal	ffffffffc0206244 <memset>
    return page - pages + nbase;
ffffffffc0201f0c:	000b3697          	auipc	a3,0xb3
ffffffffc0201f10:	72c6b683          	ld	a3,1836(a3) # ffffffffc02b5638 <pages>
ffffffffc0201f14:	67c2                	ld	a5,16(sp)
ffffffffc0201f16:	000808b7          	lui	a7,0x80
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201f1a:	6722                	ld	a4,8(sp)
ffffffffc0201f1c:	40d786b3          	sub	a3,a5,a3
ffffffffc0201f20:	8699                	srai	a3,a3,0x6
ffffffffc0201f22:	96c6                	add	a3,a3,a7
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201f24:	06aa                	slli	a3,a3,0xa
ffffffffc0201f26:	6862                	ld	a6,24(sp)
ffffffffc0201f28:	0116e693          	ori	a3,a3,17
ffffffffc0201f2c:	e314                	sd	a3,0(a4)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201f2e:	c006f693          	andi	a3,a3,-1024
ffffffffc0201f32:	6098                	ld	a4,0(s1)
ffffffffc0201f34:	068a                	slli	a3,a3,0x2
ffffffffc0201f36:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201f3a:	14e7f663          	bgeu	a5,a4,ffffffffc0202086 <get_pte+0x214>
ffffffffc0201f3e:	000b3897          	auipc	a7,0xb3
ffffffffc0201f42:	6ea88893          	addi	a7,a7,1770 # ffffffffc02b5628 <va_pa_offset>
ffffffffc0201f46:	0008b603          	ld	a2,0(a7)
ffffffffc0201f4a:	01545793          	srli	a5,s0,0x15
ffffffffc0201f4e:	1ff7f793          	andi	a5,a5,511
ffffffffc0201f52:	96b2                	add	a3,a3,a2
ffffffffc0201f54:	078e                	slli	a5,a5,0x3
ffffffffc0201f56:	97b6                	add	a5,a5,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0201f58:	6394                	ld	a3,0(a5)
ffffffffc0201f5a:	0016f613          	andi	a2,a3,1
ffffffffc0201f5e:	e659                	bnez	a2,ffffffffc0201fec <get_pte+0x17a>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f60:	0a080b63          	beqz	a6,ffffffffc0202016 <get_pte+0x1a4>
ffffffffc0201f64:	10002773          	csrr	a4,sstatus
ffffffffc0201f68:	8b09                	andi	a4,a4,2
ffffffffc0201f6a:	ef71                	bnez	a4,ffffffffc0202046 <get_pte+0x1d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f6c:	000b3717          	auipc	a4,0xb3
ffffffffc0201f70:	6a473703          	ld	a4,1700(a4) # ffffffffc02b5610 <pmm_manager>
ffffffffc0201f74:	4505                	li	a0,1
ffffffffc0201f76:	e43e                	sd	a5,8(sp)
ffffffffc0201f78:	6f18                	ld	a4,24(a4)
ffffffffc0201f7a:	9702                	jalr	a4
ffffffffc0201f7c:	67a2                	ld	a5,8(sp)
ffffffffc0201f7e:	872a                	mv	a4,a0
ffffffffc0201f80:	000b3897          	auipc	a7,0xb3
ffffffffc0201f84:	6a888893          	addi	a7,a7,1704 # ffffffffc02b5628 <va_pa_offset>
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f88:	c759                	beqz	a4,ffffffffc0202016 <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0201f8a:	000b3697          	auipc	a3,0xb3
ffffffffc0201f8e:	6ae6b683          	ld	a3,1710(a3) # ffffffffc02b5638 <pages>
ffffffffc0201f92:	00080837          	lui	a6,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f96:	608c                	ld	a1,0(s1)
ffffffffc0201f98:	40d706b3          	sub	a3,a4,a3
ffffffffc0201f9c:	8699                	srai	a3,a3,0x6
ffffffffc0201f9e:	96c2                	add	a3,a3,a6
ffffffffc0201fa0:	00c69613          	slli	a2,a3,0xc
    page->ref = val;
ffffffffc0201fa4:	4505                	li	a0,1
ffffffffc0201fa6:	8231                	srli	a2,a2,0xc
ffffffffc0201fa8:	c308                	sw	a0,0(a4)
    return page2ppn(page) << PGSHIFT;
ffffffffc0201faa:	06b2                	slli	a3,a3,0xc
ffffffffc0201fac:	10b67663          	bgeu	a2,a1,ffffffffc02020b8 <get_pte+0x246>
ffffffffc0201fb0:	0008b503          	ld	a0,0(a7)
ffffffffc0201fb4:	6605                	lui	a2,0x1
ffffffffc0201fb6:	4581                	li	a1,0
ffffffffc0201fb8:	9536                	add	a0,a0,a3
ffffffffc0201fba:	e83a                	sd	a4,16(sp)
ffffffffc0201fbc:	e43e                	sd	a5,8(sp)
ffffffffc0201fbe:	286040ef          	jal	ffffffffc0206244 <memset>
    return page - pages + nbase;
ffffffffc0201fc2:	000b3697          	auipc	a3,0xb3
ffffffffc0201fc6:	6766b683          	ld	a3,1654(a3) # ffffffffc02b5638 <pages>
ffffffffc0201fca:	6742                	ld	a4,16(sp)
ffffffffc0201fcc:	00080837          	lui	a6,0x80
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201fd0:	67a2                	ld	a5,8(sp)
ffffffffc0201fd2:	40d706b3          	sub	a3,a4,a3
ffffffffc0201fd6:	8699                	srai	a3,a3,0x6
ffffffffc0201fd8:	96c2                	add	a3,a3,a6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201fda:	06aa                	slli	a3,a3,0xa
ffffffffc0201fdc:	0116e693          	ori	a3,a3,17
ffffffffc0201fe0:	e394                	sd	a3,0(a5)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201fe2:	6098                	ld	a4,0(s1)
ffffffffc0201fe4:	000b3897          	auipc	a7,0xb3
ffffffffc0201fe8:	64488893          	addi	a7,a7,1604 # ffffffffc02b5628 <va_pa_offset>
ffffffffc0201fec:	c006f693          	andi	a3,a3,-1024
ffffffffc0201ff0:	068a                	slli	a3,a3,0x2
ffffffffc0201ff2:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201ff6:	06e7fc63          	bgeu	a5,a4,ffffffffc020206e <get_pte+0x1fc>
ffffffffc0201ffa:	0008b783          	ld	a5,0(a7)
ffffffffc0201ffe:	8031                	srli	s0,s0,0xc
ffffffffc0202000:	1ff47413          	andi	s0,s0,511
ffffffffc0202004:	040e                	slli	s0,s0,0x3
ffffffffc0202006:	96be                	add	a3,a3,a5
}
ffffffffc0202008:	70e2                	ld	ra,56(sp)
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020200a:	00868533          	add	a0,a3,s0
}
ffffffffc020200e:	7442                	ld	s0,48(sp)
ffffffffc0202010:	74a2                	ld	s1,40(sp)
ffffffffc0202012:	6121                	addi	sp,sp,64
ffffffffc0202014:	8082                	ret
ffffffffc0202016:	70e2                	ld	ra,56(sp)
ffffffffc0202018:	7442                	ld	s0,48(sp)
ffffffffc020201a:	74a2                	ld	s1,40(sp)
            return NULL;
ffffffffc020201c:	4501                	li	a0,0
}
ffffffffc020201e:	6121                	addi	sp,sp,64
ffffffffc0202020:	8082                	ret
        intr_disable();
ffffffffc0202022:	e83a                	sd	a4,16(sp)
ffffffffc0202024:	ec32                	sd	a2,24(sp)
ffffffffc0202026:	8e5fe0ef          	jal	ffffffffc020090a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020202a:	000b3797          	auipc	a5,0xb3
ffffffffc020202e:	5e67b783          	ld	a5,1510(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc0202032:	4505                	li	a0,1
ffffffffc0202034:	6f9c                	ld	a5,24(a5)
ffffffffc0202036:	9782                	jalr	a5
ffffffffc0202038:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc020203a:	8cbfe0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc020203e:	6862                	ld	a6,24(sp)
ffffffffc0202040:	6742                	ld	a4,16(sp)
ffffffffc0202042:	67a2                	ld	a5,8(sp)
ffffffffc0202044:	bdbd                	j	ffffffffc0201ec2 <get_pte+0x50>
        intr_disable();
ffffffffc0202046:	e83e                	sd	a5,16(sp)
ffffffffc0202048:	8c3fe0ef          	jal	ffffffffc020090a <intr_disable>
ffffffffc020204c:	000b3717          	auipc	a4,0xb3
ffffffffc0202050:	5c473703          	ld	a4,1476(a4) # ffffffffc02b5610 <pmm_manager>
ffffffffc0202054:	4505                	li	a0,1
ffffffffc0202056:	6f18                	ld	a4,24(a4)
ffffffffc0202058:	9702                	jalr	a4
ffffffffc020205a:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc020205c:	8a9fe0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0202060:	6722                	ld	a4,8(sp)
ffffffffc0202062:	67c2                	ld	a5,16(sp)
ffffffffc0202064:	000b3897          	auipc	a7,0xb3
ffffffffc0202068:	5c488893          	addi	a7,a7,1476 # ffffffffc02b5628 <va_pa_offset>
ffffffffc020206c:	bf31                	j	ffffffffc0201f88 <get_pte+0x116>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020206e:	00005617          	auipc	a2,0x5
ffffffffc0202072:	f9a60613          	addi	a2,a2,-102 # ffffffffc0207008 <etext+0xd9a>
ffffffffc0202076:	0fa00593          	li	a1,250
ffffffffc020207a:	00005517          	auipc	a0,0x5
ffffffffc020207e:	07e50513          	addi	a0,a0,126 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202082:	bc8fe0ef          	jal	ffffffffc020044a <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202086:	00005617          	auipc	a2,0x5
ffffffffc020208a:	f8260613          	addi	a2,a2,-126 # ffffffffc0207008 <etext+0xd9a>
ffffffffc020208e:	0ed00593          	li	a1,237
ffffffffc0202092:	00005517          	auipc	a0,0x5
ffffffffc0202096:	06650513          	addi	a0,a0,102 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc020209a:	bb0fe0ef          	jal	ffffffffc020044a <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020209e:	86aa                	mv	a3,a0
ffffffffc02020a0:	00005617          	auipc	a2,0x5
ffffffffc02020a4:	f6860613          	addi	a2,a2,-152 # ffffffffc0207008 <etext+0xd9a>
ffffffffc02020a8:	0e900593          	li	a1,233
ffffffffc02020ac:	00005517          	auipc	a0,0x5
ffffffffc02020b0:	04c50513          	addi	a0,a0,76 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc02020b4:	b96fe0ef          	jal	ffffffffc020044a <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02020b8:	00005617          	auipc	a2,0x5
ffffffffc02020bc:	f5060613          	addi	a2,a2,-176 # ffffffffc0207008 <etext+0xd9a>
ffffffffc02020c0:	0f700593          	li	a1,247
ffffffffc02020c4:	00005517          	auipc	a0,0x5
ffffffffc02020c8:	03450513          	addi	a0,a0,52 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc02020cc:	b7efe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02020d0 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc02020d0:	1141                	addi	sp,sp,-16
ffffffffc02020d2:	e022                	sd	s0,0(sp)
ffffffffc02020d4:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02020d6:	4601                	li	a2,0
{
ffffffffc02020d8:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02020da:	d99ff0ef          	jal	ffffffffc0201e72 <get_pte>
    if (ptep_store != NULL)
ffffffffc02020de:	c011                	beqz	s0,ffffffffc02020e2 <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc02020e0:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02020e2:	c511                	beqz	a0,ffffffffc02020ee <get_page+0x1e>
ffffffffc02020e4:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc02020e6:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02020e8:	0017f713          	andi	a4,a5,1
ffffffffc02020ec:	e709                	bnez	a4,ffffffffc02020f6 <get_page+0x26>
}
ffffffffc02020ee:	60a2                	ld	ra,8(sp)
ffffffffc02020f0:	6402                	ld	s0,0(sp)
ffffffffc02020f2:	0141                	addi	sp,sp,16
ffffffffc02020f4:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc02020f6:	000b3717          	auipc	a4,0xb3
ffffffffc02020fa:	53a73703          	ld	a4,1338(a4) # ffffffffc02b5630 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc02020fe:	078a                	slli	a5,a5,0x2
ffffffffc0202100:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202102:	00e7ff63          	bgeu	a5,a4,ffffffffc0202120 <get_page+0x50>
    return &pages[PPN(pa) - nbase];
ffffffffc0202106:	000b3517          	auipc	a0,0xb3
ffffffffc020210a:	53253503          	ld	a0,1330(a0) # ffffffffc02b5638 <pages>
ffffffffc020210e:	60a2                	ld	ra,8(sp)
ffffffffc0202110:	6402                	ld	s0,0(sp)
ffffffffc0202112:	079a                	slli	a5,a5,0x6
ffffffffc0202114:	fe000737          	lui	a4,0xfe000
ffffffffc0202118:	97ba                	add	a5,a5,a4
ffffffffc020211a:	953e                	add	a0,a0,a5
ffffffffc020211c:	0141                	addi	sp,sp,16
ffffffffc020211e:	8082                	ret
ffffffffc0202120:	c8fff0ef          	jal	ffffffffc0201dae <pa2page.part.0>

ffffffffc0202124 <unmap_range>:
        tlb_invalidate(pgdir, la); //(6) flush tlb
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc0202124:	715d                	addi	sp,sp,-80
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202126:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc020212a:	e486                	sd	ra,72(sp)
ffffffffc020212c:	e0a2                	sd	s0,64(sp)
ffffffffc020212e:	fc26                	sd	s1,56(sp)
ffffffffc0202130:	f84a                	sd	s2,48(sp)
ffffffffc0202132:	f44e                	sd	s3,40(sp)
ffffffffc0202134:	f052                	sd	s4,32(sp)
ffffffffc0202136:	ec56                	sd	s5,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202138:	03479713          	slli	a4,a5,0x34
ffffffffc020213c:	ef61                	bnez	a4,ffffffffc0202214 <unmap_range+0xf0>
    assert(USER_ACCESS(start, end));
ffffffffc020213e:	00200a37          	lui	s4,0x200
ffffffffc0202142:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc0202146:	0145b733          	sltu	a4,a1,s4
ffffffffc020214a:	0017b793          	seqz	a5,a5
ffffffffc020214e:	8fd9                	or	a5,a5,a4
ffffffffc0202150:	842e                	mv	s0,a1
ffffffffc0202152:	84b2                	mv	s1,a2
ffffffffc0202154:	e3e5                	bnez	a5,ffffffffc0202234 <unmap_range+0x110>
ffffffffc0202156:	4785                	li	a5,1
ffffffffc0202158:	07fe                	slli	a5,a5,0x1f
ffffffffc020215a:	0785                	addi	a5,a5,1
ffffffffc020215c:	892a                	mv	s2,a0
ffffffffc020215e:	6985                	lui	s3,0x1
    do
    {
        pte_t *ptep = get_pte(pgdir, start, 0);
        if (ptep == NULL)
        {
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202160:	ffe00ab7          	lui	s5,0xffe00
    assert(USER_ACCESS(start, end));
ffffffffc0202164:	0cf67863          	bgeu	a2,a5,ffffffffc0202234 <unmap_range+0x110>
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc0202168:	4601                	li	a2,0
ffffffffc020216a:	85a2                	mv	a1,s0
ffffffffc020216c:	854a                	mv	a0,s2
ffffffffc020216e:	d05ff0ef          	jal	ffffffffc0201e72 <get_pte>
ffffffffc0202172:	87aa                	mv	a5,a0
        if (ptep == NULL)
ffffffffc0202174:	cd31                	beqz	a0,ffffffffc02021d0 <unmap_range+0xac>
            continue;
        }
        if (*ptep != 0)
ffffffffc0202176:	6118                	ld	a4,0(a0)
ffffffffc0202178:	ef11                	bnez	a4,ffffffffc0202194 <unmap_range+0x70>
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc020217a:	944e                	add	s0,s0,s3
    } while (start != 0 && start < end);
ffffffffc020217c:	c019                	beqz	s0,ffffffffc0202182 <unmap_range+0x5e>
ffffffffc020217e:	fe9465e3          	bltu	s0,s1,ffffffffc0202168 <unmap_range+0x44>
}
ffffffffc0202182:	60a6                	ld	ra,72(sp)
ffffffffc0202184:	6406                	ld	s0,64(sp)
ffffffffc0202186:	74e2                	ld	s1,56(sp)
ffffffffc0202188:	7942                	ld	s2,48(sp)
ffffffffc020218a:	79a2                	ld	s3,40(sp)
ffffffffc020218c:	7a02                	ld	s4,32(sp)
ffffffffc020218e:	6ae2                	ld	s5,24(sp)
ffffffffc0202190:	6161                	addi	sp,sp,80
ffffffffc0202192:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc0202194:	00177693          	andi	a3,a4,1
ffffffffc0202198:	d2ed                	beqz	a3,ffffffffc020217a <unmap_range+0x56>
    if (PPN(pa) >= npage)
ffffffffc020219a:	000b3697          	auipc	a3,0xb3
ffffffffc020219e:	4966b683          	ld	a3,1174(a3) # ffffffffc02b5630 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc02021a2:	070a                	slli	a4,a4,0x2
ffffffffc02021a4:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc02021a6:	0ad77763          	bgeu	a4,a3,ffffffffc0202254 <unmap_range+0x130>
    return &pages[PPN(pa) - nbase];
ffffffffc02021aa:	000b3517          	auipc	a0,0xb3
ffffffffc02021ae:	48e53503          	ld	a0,1166(a0) # ffffffffc02b5638 <pages>
ffffffffc02021b2:	071a                	slli	a4,a4,0x6
ffffffffc02021b4:	fe0006b7          	lui	a3,0xfe000
ffffffffc02021b8:	9736                	add	a4,a4,a3
ffffffffc02021ba:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc02021bc:	4118                	lw	a4,0(a0)
ffffffffc02021be:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3dd4a98f>
ffffffffc02021c0:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc02021c2:	cb19                	beqz	a4,ffffffffc02021d8 <unmap_range+0xb4>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc02021c4:	0007b023          	sd	zero,0(a5)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02021c8:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc02021cc:	944e                	add	s0,s0,s3
ffffffffc02021ce:	b77d                	j	ffffffffc020217c <unmap_range+0x58>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02021d0:	9452                	add	s0,s0,s4
ffffffffc02021d2:	01547433          	and	s0,s0,s5
            continue;
ffffffffc02021d6:	b75d                	j	ffffffffc020217c <unmap_range+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02021d8:	10002773          	csrr	a4,sstatus
ffffffffc02021dc:	8b09                	andi	a4,a4,2
ffffffffc02021de:	eb19                	bnez	a4,ffffffffc02021f4 <unmap_range+0xd0>
        pmm_manager->free_pages(base, n);
ffffffffc02021e0:	000b3717          	auipc	a4,0xb3
ffffffffc02021e4:	43073703          	ld	a4,1072(a4) # ffffffffc02b5610 <pmm_manager>
ffffffffc02021e8:	4585                	li	a1,1
ffffffffc02021ea:	e03e                	sd	a5,0(sp)
ffffffffc02021ec:	7318                	ld	a4,32(a4)
ffffffffc02021ee:	9702                	jalr	a4
    if (flag)
ffffffffc02021f0:	6782                	ld	a5,0(sp)
ffffffffc02021f2:	bfc9                	j	ffffffffc02021c4 <unmap_range+0xa0>
        intr_disable();
ffffffffc02021f4:	e43e                	sd	a5,8(sp)
ffffffffc02021f6:	e02a                	sd	a0,0(sp)
ffffffffc02021f8:	f12fe0ef          	jal	ffffffffc020090a <intr_disable>
ffffffffc02021fc:	000b3717          	auipc	a4,0xb3
ffffffffc0202200:	41473703          	ld	a4,1044(a4) # ffffffffc02b5610 <pmm_manager>
ffffffffc0202204:	6502                	ld	a0,0(sp)
ffffffffc0202206:	4585                	li	a1,1
ffffffffc0202208:	7318                	ld	a4,32(a4)
ffffffffc020220a:	9702                	jalr	a4
        intr_enable();
ffffffffc020220c:	ef8fe0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0202210:	67a2                	ld	a5,8(sp)
ffffffffc0202212:	bf4d                	j	ffffffffc02021c4 <unmap_range+0xa0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202214:	00005697          	auipc	a3,0x5
ffffffffc0202218:	ef468693          	addi	a3,a3,-268 # ffffffffc0207108 <etext+0xe9a>
ffffffffc020221c:	00005617          	auipc	a2,0x5
ffffffffc0202220:	a3c60613          	addi	a2,a2,-1476 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202224:	12200593          	li	a1,290
ffffffffc0202228:	00005517          	auipc	a0,0x5
ffffffffc020222c:	ed050513          	addi	a0,a0,-304 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202230:	a1afe0ef          	jal	ffffffffc020044a <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0202234:	00005697          	auipc	a3,0x5
ffffffffc0202238:	f0468693          	addi	a3,a3,-252 # ffffffffc0207138 <etext+0xeca>
ffffffffc020223c:	00005617          	auipc	a2,0x5
ffffffffc0202240:	a1c60613          	addi	a2,a2,-1508 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202244:	12300593          	li	a1,291
ffffffffc0202248:	00005517          	auipc	a0,0x5
ffffffffc020224c:	eb050513          	addi	a0,a0,-336 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202250:	9fafe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202254:	b5bff0ef          	jal	ffffffffc0201dae <pa2page.part.0>

ffffffffc0202258 <exit_range>:
{
ffffffffc0202258:	7135                	addi	sp,sp,-160
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020225a:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc020225e:	ed06                	sd	ra,152(sp)
ffffffffc0202260:	e922                	sd	s0,144(sp)
ffffffffc0202262:	e526                	sd	s1,136(sp)
ffffffffc0202264:	e14a                	sd	s2,128(sp)
ffffffffc0202266:	fcce                	sd	s3,120(sp)
ffffffffc0202268:	f8d2                	sd	s4,112(sp)
ffffffffc020226a:	f4d6                	sd	s5,104(sp)
ffffffffc020226c:	f0da                	sd	s6,96(sp)
ffffffffc020226e:	ecde                	sd	s7,88(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202270:	17d2                	slli	a5,a5,0x34
ffffffffc0202272:	22079263          	bnez	a5,ffffffffc0202496 <exit_range+0x23e>
    assert(USER_ACCESS(start, end));
ffffffffc0202276:	00200937          	lui	s2,0x200
ffffffffc020227a:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc020227e:	0125b733          	sltu	a4,a1,s2
ffffffffc0202282:	0017b793          	seqz	a5,a5
ffffffffc0202286:	8fd9                	or	a5,a5,a4
ffffffffc0202288:	26079263          	bnez	a5,ffffffffc02024ec <exit_range+0x294>
ffffffffc020228c:	4785                	li	a5,1
ffffffffc020228e:	07fe                	slli	a5,a5,0x1f
ffffffffc0202290:	0785                	addi	a5,a5,1
ffffffffc0202292:	24f67d63          	bgeu	a2,a5,ffffffffc02024ec <exit_range+0x294>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc0202296:	c00004b7          	lui	s1,0xc0000
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc020229a:	ffe007b7          	lui	a5,0xffe00
ffffffffc020229e:	8a2a                	mv	s4,a0
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc02022a0:	8ced                	and	s1,s1,a1
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc02022a2:	00f5f833          	and	a6,a1,a5
    if (PPN(pa) >= npage)
ffffffffc02022a6:	000b3a97          	auipc	s5,0xb3
ffffffffc02022aa:	38aa8a93          	addi	s5,s5,906 # ffffffffc02b5630 <npage>
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02022ae:	400009b7          	lui	s3,0x40000
ffffffffc02022b2:	a809                	j	ffffffffc02022c4 <exit_range+0x6c>
        d1start += PDSIZE;
ffffffffc02022b4:	013487b3          	add	a5,s1,s3
ffffffffc02022b8:	400004b7          	lui	s1,0x40000
        d0start = d1start;
ffffffffc02022bc:	8826                	mv	a6,s1
    } while (d1start != 0 && d1start < end);
ffffffffc02022be:	c3f1                	beqz	a5,ffffffffc0202382 <exit_range+0x12a>
ffffffffc02022c0:	0cc7f163          	bgeu	a5,a2,ffffffffc0202382 <exit_range+0x12a>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc02022c4:	01e4d413          	srli	s0,s1,0x1e
ffffffffc02022c8:	1ff47413          	andi	s0,s0,511
ffffffffc02022cc:	040e                	slli	s0,s0,0x3
ffffffffc02022ce:	9452                	add	s0,s0,s4
ffffffffc02022d0:	00043883          	ld	a7,0(s0)
        if (pde1 & PTE_V)
ffffffffc02022d4:	0018f793          	andi	a5,a7,1
ffffffffc02022d8:	dff1                	beqz	a5,ffffffffc02022b4 <exit_range+0x5c>
ffffffffc02022da:	000ab783          	ld	a5,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc02022de:	088a                	slli	a7,a7,0x2
ffffffffc02022e0:	00c8d893          	srli	a7,a7,0xc
    if (PPN(pa) >= npage)
ffffffffc02022e4:	20f8f263          	bgeu	a7,a5,ffffffffc02024e8 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc02022e8:	fff802b7          	lui	t0,0xfff80
ffffffffc02022ec:	00588f33          	add	t5,a7,t0
    return page - pages + nbase;
ffffffffc02022f0:	000803b7          	lui	t2,0x80
ffffffffc02022f4:	007f0733          	add	a4,t5,t2
    return page2ppn(page) << PGSHIFT;
ffffffffc02022f8:	00c71e13          	slli	t3,a4,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc02022fc:	0f1a                	slli	t5,t5,0x6
    return KADDR(page2pa(page));
ffffffffc02022fe:	1cf77863          	bgeu	a4,a5,ffffffffc02024ce <exit_range+0x276>
ffffffffc0202302:	000b3f97          	auipc	t6,0xb3
ffffffffc0202306:	326f8f93          	addi	t6,t6,806 # ffffffffc02b5628 <va_pa_offset>
ffffffffc020230a:	000fb783          	ld	a5,0(t6)
            free_pd0 = 1;
ffffffffc020230e:	4e85                	li	t4,1
ffffffffc0202310:	6b05                	lui	s6,0x1
ffffffffc0202312:	9e3e                	add	t3,t3,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202314:	01348333          	add	t1,s1,s3
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202318:	01585713          	srli	a4,a6,0x15
ffffffffc020231c:	1ff77713          	andi	a4,a4,511
ffffffffc0202320:	070e                	slli	a4,a4,0x3
ffffffffc0202322:	9772                	add	a4,a4,t3
ffffffffc0202324:	631c                	ld	a5,0(a4)
                if (pde0 & PTE_V)
ffffffffc0202326:	0017f693          	andi	a3,a5,1
ffffffffc020232a:	e6bd                	bnez	a3,ffffffffc0202398 <exit_range+0x140>
                    free_pd0 = 0;
ffffffffc020232c:	4e81                	li	t4,0
                d0start += PTSIZE;
ffffffffc020232e:	984a                	add	a6,a6,s2
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202330:	00080863          	beqz	a6,ffffffffc0202340 <exit_range+0xe8>
ffffffffc0202334:	879a                	mv	a5,t1
ffffffffc0202336:	00667363          	bgeu	a2,t1,ffffffffc020233c <exit_range+0xe4>
ffffffffc020233a:	87b2                	mv	a5,a2
ffffffffc020233c:	fcf86ee3          	bltu	a6,a5,ffffffffc0202318 <exit_range+0xc0>
            if (free_pd0)
ffffffffc0202340:	f60e8ae3          	beqz	t4,ffffffffc02022b4 <exit_range+0x5c>
    if (PPN(pa) >= npage)
ffffffffc0202344:	000ab783          	ld	a5,0(s5)
ffffffffc0202348:	1af8f063          	bgeu	a7,a5,ffffffffc02024e8 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc020234c:	000b3517          	auipc	a0,0xb3
ffffffffc0202350:	2ec53503          	ld	a0,748(a0) # ffffffffc02b5638 <pages>
ffffffffc0202354:	957a                	add	a0,a0,t5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202356:	100027f3          	csrr	a5,sstatus
ffffffffc020235a:	8b89                	andi	a5,a5,2
ffffffffc020235c:	10079b63          	bnez	a5,ffffffffc0202472 <exit_range+0x21a>
        pmm_manager->free_pages(base, n);
ffffffffc0202360:	000b3797          	auipc	a5,0xb3
ffffffffc0202364:	2b07b783          	ld	a5,688(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc0202368:	4585                	li	a1,1
ffffffffc020236a:	e432                	sd	a2,8(sp)
ffffffffc020236c:	739c                	ld	a5,32(a5)
ffffffffc020236e:	9782                	jalr	a5
ffffffffc0202370:	6622                	ld	a2,8(sp)
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202372:	00043023          	sd	zero,0(s0)
        d1start += PDSIZE;
ffffffffc0202376:	013487b3          	add	a5,s1,s3
ffffffffc020237a:	400004b7          	lui	s1,0x40000
        d0start = d1start;
ffffffffc020237e:	8826                	mv	a6,s1
    } while (d1start != 0 && d1start < end);
ffffffffc0202380:	f3a1                	bnez	a5,ffffffffc02022c0 <exit_range+0x68>
}
ffffffffc0202382:	60ea                	ld	ra,152(sp)
ffffffffc0202384:	644a                	ld	s0,144(sp)
ffffffffc0202386:	64aa                	ld	s1,136(sp)
ffffffffc0202388:	690a                	ld	s2,128(sp)
ffffffffc020238a:	79e6                	ld	s3,120(sp)
ffffffffc020238c:	7a46                	ld	s4,112(sp)
ffffffffc020238e:	7aa6                	ld	s5,104(sp)
ffffffffc0202390:	7b06                	ld	s6,96(sp)
ffffffffc0202392:	6be6                	ld	s7,88(sp)
ffffffffc0202394:	610d                	addi	sp,sp,160
ffffffffc0202396:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0202398:	000ab503          	ld	a0,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc020239c:	078a                	slli	a5,a5,0x2
ffffffffc020239e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02023a0:	14a7f463          	bgeu	a5,a0,ffffffffc02024e8 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc02023a4:	9796                	add	a5,a5,t0
    return page - pages + nbase;
ffffffffc02023a6:	00778bb3          	add	s7,a5,t2
    return &pages[PPN(pa) - nbase];
ffffffffc02023aa:	00679593          	slli	a1,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02023ae:	00cb9693          	slli	a3,s7,0xc
    return KADDR(page2pa(page));
ffffffffc02023b2:	10abf263          	bgeu	s7,a0,ffffffffc02024b6 <exit_range+0x25e>
ffffffffc02023b6:	000fb783          	ld	a5,0(t6)
ffffffffc02023ba:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02023bc:	01668533          	add	a0,a3,s6
                        if (pt[i] & PTE_V)
ffffffffc02023c0:	629c                	ld	a5,0(a3)
ffffffffc02023c2:	8b85                	andi	a5,a5,1
ffffffffc02023c4:	f7ad                	bnez	a5,ffffffffc020232e <exit_range+0xd6>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02023c6:	06a1                	addi	a3,a3,8
ffffffffc02023c8:	fea69ce3          	bne	a3,a0,ffffffffc02023c0 <exit_range+0x168>
    return &pages[PPN(pa) - nbase];
ffffffffc02023cc:	000b3517          	auipc	a0,0xb3
ffffffffc02023d0:	26c53503          	ld	a0,620(a0) # ffffffffc02b5638 <pages>
ffffffffc02023d4:	952e                	add	a0,a0,a1
ffffffffc02023d6:	100027f3          	csrr	a5,sstatus
ffffffffc02023da:	8b89                	andi	a5,a5,2
ffffffffc02023dc:	e3b9                	bnez	a5,ffffffffc0202422 <exit_range+0x1ca>
        pmm_manager->free_pages(base, n);
ffffffffc02023de:	000b3797          	auipc	a5,0xb3
ffffffffc02023e2:	2327b783          	ld	a5,562(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc02023e6:	4585                	li	a1,1
ffffffffc02023e8:	e0b2                	sd	a2,64(sp)
ffffffffc02023ea:	739c                	ld	a5,32(a5)
ffffffffc02023ec:	fc1a                	sd	t1,56(sp)
ffffffffc02023ee:	f846                	sd	a7,48(sp)
ffffffffc02023f0:	f47a                	sd	t5,40(sp)
ffffffffc02023f2:	f072                	sd	t3,32(sp)
ffffffffc02023f4:	ec76                	sd	t4,24(sp)
ffffffffc02023f6:	e842                	sd	a6,16(sp)
ffffffffc02023f8:	e43a                	sd	a4,8(sp)
ffffffffc02023fa:	9782                	jalr	a5
    if (flag)
ffffffffc02023fc:	6722                	ld	a4,8(sp)
ffffffffc02023fe:	6842                	ld	a6,16(sp)
ffffffffc0202400:	6ee2                	ld	t4,24(sp)
ffffffffc0202402:	7e02                	ld	t3,32(sp)
ffffffffc0202404:	7f22                	ld	t5,40(sp)
ffffffffc0202406:	78c2                	ld	a7,48(sp)
ffffffffc0202408:	7362                	ld	t1,56(sp)
ffffffffc020240a:	6606                	ld	a2,64(sp)
                        pd0[PDX0(d0start)] = 0;
ffffffffc020240c:	fff802b7          	lui	t0,0xfff80
ffffffffc0202410:	000803b7          	lui	t2,0x80
ffffffffc0202414:	000b3f97          	auipc	t6,0xb3
ffffffffc0202418:	214f8f93          	addi	t6,t6,532 # ffffffffc02b5628 <va_pa_offset>
ffffffffc020241c:	00073023          	sd	zero,0(a4)
ffffffffc0202420:	b739                	j	ffffffffc020232e <exit_range+0xd6>
        intr_disable();
ffffffffc0202422:	e4b2                	sd	a2,72(sp)
ffffffffc0202424:	e09a                	sd	t1,64(sp)
ffffffffc0202426:	fc46                	sd	a7,56(sp)
ffffffffc0202428:	f47a                	sd	t5,40(sp)
ffffffffc020242a:	f072                	sd	t3,32(sp)
ffffffffc020242c:	ec76                	sd	t4,24(sp)
ffffffffc020242e:	e842                	sd	a6,16(sp)
ffffffffc0202430:	e43a                	sd	a4,8(sp)
ffffffffc0202432:	f82a                	sd	a0,48(sp)
ffffffffc0202434:	cd6fe0ef          	jal	ffffffffc020090a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202438:	000b3797          	auipc	a5,0xb3
ffffffffc020243c:	1d87b783          	ld	a5,472(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc0202440:	7542                	ld	a0,48(sp)
ffffffffc0202442:	4585                	li	a1,1
ffffffffc0202444:	739c                	ld	a5,32(a5)
ffffffffc0202446:	9782                	jalr	a5
        intr_enable();
ffffffffc0202448:	cbcfe0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc020244c:	6722                	ld	a4,8(sp)
ffffffffc020244e:	6626                	ld	a2,72(sp)
ffffffffc0202450:	6306                	ld	t1,64(sp)
ffffffffc0202452:	78e2                	ld	a7,56(sp)
ffffffffc0202454:	7f22                	ld	t5,40(sp)
ffffffffc0202456:	7e02                	ld	t3,32(sp)
ffffffffc0202458:	6ee2                	ld	t4,24(sp)
ffffffffc020245a:	6842                	ld	a6,16(sp)
ffffffffc020245c:	000b3f97          	auipc	t6,0xb3
ffffffffc0202460:	1ccf8f93          	addi	t6,t6,460 # ffffffffc02b5628 <va_pa_offset>
ffffffffc0202464:	000803b7          	lui	t2,0x80
ffffffffc0202468:	fff802b7          	lui	t0,0xfff80
                        pd0[PDX0(d0start)] = 0;
ffffffffc020246c:	00073023          	sd	zero,0(a4)
ffffffffc0202470:	bd7d                	j	ffffffffc020232e <exit_range+0xd6>
        intr_disable();
ffffffffc0202472:	e832                	sd	a2,16(sp)
ffffffffc0202474:	e42a                	sd	a0,8(sp)
ffffffffc0202476:	c94fe0ef          	jal	ffffffffc020090a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020247a:	000b3797          	auipc	a5,0xb3
ffffffffc020247e:	1967b783          	ld	a5,406(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc0202482:	6522                	ld	a0,8(sp)
ffffffffc0202484:	4585                	li	a1,1
ffffffffc0202486:	739c                	ld	a5,32(a5)
ffffffffc0202488:	9782                	jalr	a5
        intr_enable();
ffffffffc020248a:	c7afe0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc020248e:	6642                	ld	a2,16(sp)
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202490:	00043023          	sd	zero,0(s0)
ffffffffc0202494:	b5cd                	j	ffffffffc0202376 <exit_range+0x11e>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202496:	00005697          	auipc	a3,0x5
ffffffffc020249a:	c7268693          	addi	a3,a3,-910 # ffffffffc0207108 <etext+0xe9a>
ffffffffc020249e:	00004617          	auipc	a2,0x4
ffffffffc02024a2:	7ba60613          	addi	a2,a2,1978 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02024a6:	13700593          	li	a1,311
ffffffffc02024aa:	00005517          	auipc	a0,0x5
ffffffffc02024ae:	c4e50513          	addi	a0,a0,-946 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc02024b2:	f99fd0ef          	jal	ffffffffc020044a <__panic>
    return KADDR(page2pa(page));
ffffffffc02024b6:	00005617          	auipc	a2,0x5
ffffffffc02024ba:	b5260613          	addi	a2,a2,-1198 # ffffffffc0207008 <etext+0xd9a>
ffffffffc02024be:	07100593          	li	a1,113
ffffffffc02024c2:	00005517          	auipc	a0,0x5
ffffffffc02024c6:	b6e50513          	addi	a0,a0,-1170 # ffffffffc0207030 <etext+0xdc2>
ffffffffc02024ca:	f81fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02024ce:	86f2                	mv	a3,t3
ffffffffc02024d0:	00005617          	auipc	a2,0x5
ffffffffc02024d4:	b3860613          	addi	a2,a2,-1224 # ffffffffc0207008 <etext+0xd9a>
ffffffffc02024d8:	07100593          	li	a1,113
ffffffffc02024dc:	00005517          	auipc	a0,0x5
ffffffffc02024e0:	b5450513          	addi	a0,a0,-1196 # ffffffffc0207030 <etext+0xdc2>
ffffffffc02024e4:	f67fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02024e8:	8c7ff0ef          	jal	ffffffffc0201dae <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc02024ec:	00005697          	auipc	a3,0x5
ffffffffc02024f0:	c4c68693          	addi	a3,a3,-948 # ffffffffc0207138 <etext+0xeca>
ffffffffc02024f4:	00004617          	auipc	a2,0x4
ffffffffc02024f8:	76460613          	addi	a2,a2,1892 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02024fc:	13800593          	li	a1,312
ffffffffc0202500:	00005517          	auipc	a0,0x5
ffffffffc0202504:	bf850513          	addi	a0,a0,-1032 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202508:	f43fd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020250c <page_remove>:
{
ffffffffc020250c:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020250e:	4601                	li	a2,0
{
ffffffffc0202510:	e822                	sd	s0,16(sp)
ffffffffc0202512:	ec06                	sd	ra,24(sp)
ffffffffc0202514:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202516:	95dff0ef          	jal	ffffffffc0201e72 <get_pte>
    if (ptep != NULL)
ffffffffc020251a:	c511                	beqz	a0,ffffffffc0202526 <page_remove+0x1a>
    if (*ptep & PTE_V)
ffffffffc020251c:	6118                	ld	a4,0(a0)
ffffffffc020251e:	87aa                	mv	a5,a0
ffffffffc0202520:	00177693          	andi	a3,a4,1
ffffffffc0202524:	e689                	bnez	a3,ffffffffc020252e <page_remove+0x22>
}
ffffffffc0202526:	60e2                	ld	ra,24(sp)
ffffffffc0202528:	6442                	ld	s0,16(sp)
ffffffffc020252a:	6105                	addi	sp,sp,32
ffffffffc020252c:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc020252e:	000b3697          	auipc	a3,0xb3
ffffffffc0202532:	1026b683          	ld	a3,258(a3) # ffffffffc02b5630 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0202536:	070a                	slli	a4,a4,0x2
ffffffffc0202538:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc020253a:	06d77563          	bgeu	a4,a3,ffffffffc02025a4 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc020253e:	000b3517          	auipc	a0,0xb3
ffffffffc0202542:	0fa53503          	ld	a0,250(a0) # ffffffffc02b5638 <pages>
ffffffffc0202546:	071a                	slli	a4,a4,0x6
ffffffffc0202548:	fe0006b7          	lui	a3,0xfe000
ffffffffc020254c:	9736                	add	a4,a4,a3
ffffffffc020254e:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc0202550:	4118                	lw	a4,0(a0)
ffffffffc0202552:	377d                	addiw	a4,a4,-1
ffffffffc0202554:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202556:	cb09                	beqz	a4,ffffffffc0202568 <page_remove+0x5c>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc0202558:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020255c:	12040073          	sfence.vma	s0
}
ffffffffc0202560:	60e2                	ld	ra,24(sp)
ffffffffc0202562:	6442                	ld	s0,16(sp)
ffffffffc0202564:	6105                	addi	sp,sp,32
ffffffffc0202566:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202568:	10002773          	csrr	a4,sstatus
ffffffffc020256c:	8b09                	andi	a4,a4,2
ffffffffc020256e:	eb19                	bnez	a4,ffffffffc0202584 <page_remove+0x78>
        pmm_manager->free_pages(base, n);
ffffffffc0202570:	000b3717          	auipc	a4,0xb3
ffffffffc0202574:	0a073703          	ld	a4,160(a4) # ffffffffc02b5610 <pmm_manager>
ffffffffc0202578:	4585                	li	a1,1
ffffffffc020257a:	e03e                	sd	a5,0(sp)
ffffffffc020257c:	7318                	ld	a4,32(a4)
ffffffffc020257e:	9702                	jalr	a4
    if (flag)
ffffffffc0202580:	6782                	ld	a5,0(sp)
ffffffffc0202582:	bfd9                	j	ffffffffc0202558 <page_remove+0x4c>
        intr_disable();
ffffffffc0202584:	e43e                	sd	a5,8(sp)
ffffffffc0202586:	e02a                	sd	a0,0(sp)
ffffffffc0202588:	b82fe0ef          	jal	ffffffffc020090a <intr_disable>
ffffffffc020258c:	000b3717          	auipc	a4,0xb3
ffffffffc0202590:	08473703          	ld	a4,132(a4) # ffffffffc02b5610 <pmm_manager>
ffffffffc0202594:	6502                	ld	a0,0(sp)
ffffffffc0202596:	4585                	li	a1,1
ffffffffc0202598:	7318                	ld	a4,32(a4)
ffffffffc020259a:	9702                	jalr	a4
        intr_enable();
ffffffffc020259c:	b68fe0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc02025a0:	67a2                	ld	a5,8(sp)
ffffffffc02025a2:	bf5d                	j	ffffffffc0202558 <page_remove+0x4c>
ffffffffc02025a4:	80bff0ef          	jal	ffffffffc0201dae <pa2page.part.0>

ffffffffc02025a8 <page_insert>:
{
ffffffffc02025a8:	7139                	addi	sp,sp,-64
ffffffffc02025aa:	f426                	sd	s1,40(sp)
ffffffffc02025ac:	84b2                	mv	s1,a2
ffffffffc02025ae:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02025b0:	4605                	li	a2,1
{
ffffffffc02025b2:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02025b4:	85a6                	mv	a1,s1
{
ffffffffc02025b6:	fc06                	sd	ra,56(sp)
ffffffffc02025b8:	e436                	sd	a3,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02025ba:	8b9ff0ef          	jal	ffffffffc0201e72 <get_pte>
    if (ptep == NULL)
ffffffffc02025be:	cd61                	beqz	a0,ffffffffc0202696 <page_insert+0xee>
    page->ref += 1;
ffffffffc02025c0:	400c                	lw	a1,0(s0)
    if (*ptep & PTE_V)
ffffffffc02025c2:	611c                	ld	a5,0(a0)
ffffffffc02025c4:	66a2                	ld	a3,8(sp)
ffffffffc02025c6:	0015861b          	addiw	a2,a1,1 # 1001 <_binary_obj___user_softint_out_size-0x7f27>
ffffffffc02025ca:	c010                	sw	a2,0(s0)
ffffffffc02025cc:	0017f613          	andi	a2,a5,1
ffffffffc02025d0:	872a                	mv	a4,a0
ffffffffc02025d2:	e61d                	bnez	a2,ffffffffc0202600 <page_insert+0x58>
    return &pages[PPN(pa) - nbase];
ffffffffc02025d4:	000b3617          	auipc	a2,0xb3
ffffffffc02025d8:	06463603          	ld	a2,100(a2) # ffffffffc02b5638 <pages>
    return page - pages + nbase;
ffffffffc02025dc:	8c11                	sub	s0,s0,a2
ffffffffc02025de:	8419                	srai	s0,s0,0x6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02025e0:	200007b7          	lui	a5,0x20000
ffffffffc02025e4:	042a                	slli	s0,s0,0xa
ffffffffc02025e6:	943e                	add	s0,s0,a5
ffffffffc02025e8:	8ec1                	or	a3,a3,s0
ffffffffc02025ea:	0016e693          	ori	a3,a3,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02025ee:	e314                	sd	a3,0(a4)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02025f0:	12048073          	sfence.vma	s1
    return 0;
ffffffffc02025f4:	4501                	li	a0,0
}
ffffffffc02025f6:	70e2                	ld	ra,56(sp)
ffffffffc02025f8:	7442                	ld	s0,48(sp)
ffffffffc02025fa:	74a2                	ld	s1,40(sp)
ffffffffc02025fc:	6121                	addi	sp,sp,64
ffffffffc02025fe:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0202600:	000b3617          	auipc	a2,0xb3
ffffffffc0202604:	03063603          	ld	a2,48(a2) # ffffffffc02b5630 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0202608:	078a                	slli	a5,a5,0x2
ffffffffc020260a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020260c:	08c7f763          	bgeu	a5,a2,ffffffffc020269a <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0202610:	000b3617          	auipc	a2,0xb3
ffffffffc0202614:	02863603          	ld	a2,40(a2) # ffffffffc02b5638 <pages>
ffffffffc0202618:	fe000537          	lui	a0,0xfe000
ffffffffc020261c:	079a                	slli	a5,a5,0x6
ffffffffc020261e:	97aa                	add	a5,a5,a0
ffffffffc0202620:	00f60533          	add	a0,a2,a5
        if (p == page)
ffffffffc0202624:	00a40963          	beq	s0,a0,ffffffffc0202636 <page_insert+0x8e>
    page->ref -= 1;
ffffffffc0202628:	411c                	lw	a5,0(a0)
ffffffffc020262a:	37fd                	addiw	a5,a5,-1 # 1fffffff <_binary_obj___user_matrix_out_size+0x1fff4acf>
ffffffffc020262c:	c11c                	sw	a5,0(a0)
        if (page_ref(page) ==
ffffffffc020262e:	c791                	beqz	a5,ffffffffc020263a <page_insert+0x92>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202630:	12048073          	sfence.vma	s1
}
ffffffffc0202634:	b765                	j	ffffffffc02025dc <page_insert+0x34>
ffffffffc0202636:	c00c                	sw	a1,0(s0)
    return page->ref;
ffffffffc0202638:	b755                	j	ffffffffc02025dc <page_insert+0x34>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020263a:	100027f3          	csrr	a5,sstatus
ffffffffc020263e:	8b89                	andi	a5,a5,2
ffffffffc0202640:	e39d                	bnez	a5,ffffffffc0202666 <page_insert+0xbe>
        pmm_manager->free_pages(base, n);
ffffffffc0202642:	000b3797          	auipc	a5,0xb3
ffffffffc0202646:	fce7b783          	ld	a5,-50(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc020264a:	4585                	li	a1,1
ffffffffc020264c:	e83a                	sd	a4,16(sp)
ffffffffc020264e:	739c                	ld	a5,32(a5)
ffffffffc0202650:	e436                	sd	a3,8(sp)
ffffffffc0202652:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202654:	000b3617          	auipc	a2,0xb3
ffffffffc0202658:	fe463603          	ld	a2,-28(a2) # ffffffffc02b5638 <pages>
ffffffffc020265c:	66a2                	ld	a3,8(sp)
ffffffffc020265e:	6742                	ld	a4,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202660:	12048073          	sfence.vma	s1
ffffffffc0202664:	bfa5                	j	ffffffffc02025dc <page_insert+0x34>
        intr_disable();
ffffffffc0202666:	ec3a                	sd	a4,24(sp)
ffffffffc0202668:	e836                	sd	a3,16(sp)
ffffffffc020266a:	e42a                	sd	a0,8(sp)
ffffffffc020266c:	a9efe0ef          	jal	ffffffffc020090a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202670:	000b3797          	auipc	a5,0xb3
ffffffffc0202674:	fa07b783          	ld	a5,-96(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc0202678:	6522                	ld	a0,8(sp)
ffffffffc020267a:	4585                	li	a1,1
ffffffffc020267c:	739c                	ld	a5,32(a5)
ffffffffc020267e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202680:	a84fe0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0202684:	000b3617          	auipc	a2,0xb3
ffffffffc0202688:	fb463603          	ld	a2,-76(a2) # ffffffffc02b5638 <pages>
ffffffffc020268c:	6762                	ld	a4,24(sp)
ffffffffc020268e:	66c2                	ld	a3,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202690:	12048073          	sfence.vma	s1
ffffffffc0202694:	b7a1                	j	ffffffffc02025dc <page_insert+0x34>
        return -E_NO_MEM;
ffffffffc0202696:	5571                	li	a0,-4
ffffffffc0202698:	bfb9                	j	ffffffffc02025f6 <page_insert+0x4e>
ffffffffc020269a:	f14ff0ef          	jal	ffffffffc0201dae <pa2page.part.0>

ffffffffc020269e <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc020269e:	00006797          	auipc	a5,0x6
ffffffffc02026a2:	a0a78793          	addi	a5,a5,-1526 # ffffffffc02080a8 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02026a6:	638c                	ld	a1,0(a5)
{
ffffffffc02026a8:	7159                	addi	sp,sp,-112
ffffffffc02026aa:	f486                	sd	ra,104(sp)
ffffffffc02026ac:	e8ca                	sd	s2,80(sp)
ffffffffc02026ae:	e4ce                	sd	s3,72(sp)
ffffffffc02026b0:	f85a                	sd	s6,48(sp)
ffffffffc02026b2:	f0a2                	sd	s0,96(sp)
ffffffffc02026b4:	eca6                	sd	s1,88(sp)
ffffffffc02026b6:	e0d2                	sd	s4,64(sp)
ffffffffc02026b8:	fc56                	sd	s5,56(sp)
ffffffffc02026ba:	f45e                	sd	s7,40(sp)
ffffffffc02026bc:	f062                	sd	s8,32(sp)
ffffffffc02026be:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc02026c0:	000b3b17          	auipc	s6,0xb3
ffffffffc02026c4:	f50b0b13          	addi	s6,s6,-176 # ffffffffc02b5610 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02026c8:	00005517          	auipc	a0,0x5
ffffffffc02026cc:	a8850513          	addi	a0,a0,-1400 # ffffffffc0207150 <etext+0xee2>
    pmm_manager = &default_pmm_manager;
ffffffffc02026d0:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02026d4:	ac5fd0ef          	jal	ffffffffc0200198 <cprintf>
    pmm_manager->init();
ffffffffc02026d8:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02026dc:	000b3997          	auipc	s3,0xb3
ffffffffc02026e0:	f4c98993          	addi	s3,s3,-180 # ffffffffc02b5628 <va_pa_offset>
    pmm_manager->init();
ffffffffc02026e4:	679c                	ld	a5,8(a5)
ffffffffc02026e6:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02026e8:	57f5                	li	a5,-3
ffffffffc02026ea:	07fa                	slli	a5,a5,0x1e
ffffffffc02026ec:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc02026f0:	a00fe0ef          	jal	ffffffffc02008f0 <get_memory_base>
ffffffffc02026f4:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc02026f6:	a04fe0ef          	jal	ffffffffc02008fa <get_memory_size>
    if (mem_size == 0)
ffffffffc02026fa:	70050e63          	beqz	a0,ffffffffc0202e16 <pmm_init+0x778>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02026fe:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202700:	00005517          	auipc	a0,0x5
ffffffffc0202704:	a8850513          	addi	a0,a0,-1400 # ffffffffc0207188 <etext+0xf1a>
ffffffffc0202708:	a91fd0ef          	jal	ffffffffc0200198 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc020270c:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202710:	864a                	mv	a2,s2
ffffffffc0202712:	85a6                	mv	a1,s1
ffffffffc0202714:	fff40693          	addi	a3,s0,-1
ffffffffc0202718:	00005517          	auipc	a0,0x5
ffffffffc020271c:	a8850513          	addi	a0,a0,-1400 # ffffffffc02071a0 <etext+0xf32>
ffffffffc0202720:	a79fd0ef          	jal	ffffffffc0200198 <cprintf>
    if (maxpa > KERNTOP)
ffffffffc0202724:	c80007b7          	lui	a5,0xc8000
ffffffffc0202728:	8522                	mv	a0,s0
ffffffffc020272a:	5287ed63          	bltu	a5,s0,ffffffffc0202c64 <pmm_init+0x5c6>
ffffffffc020272e:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202730:	000b4617          	auipc	a2,0xb4
ffffffffc0202734:	f3f60613          	addi	a2,a2,-193 # ffffffffc02b666f <end+0xfff>
ffffffffc0202738:	8e7d                	and	a2,a2,a5
    npage = maxpa / PGSIZE;
ffffffffc020273a:	8131                	srli	a0,a0,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020273c:	000b3b97          	auipc	s7,0xb3
ffffffffc0202740:	efcb8b93          	addi	s7,s7,-260 # ffffffffc02b5638 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202744:	000b3497          	auipc	s1,0xb3
ffffffffc0202748:	eec48493          	addi	s1,s1,-276 # ffffffffc02b5630 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020274c:	00cbb023          	sd	a2,0(s7)
    npage = maxpa / PGSIZE;
ffffffffc0202750:	e088                	sd	a0,0(s1)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202752:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202756:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202758:	02f50763          	beq	a0,a5,ffffffffc0202786 <pmm_init+0xe8>
ffffffffc020275c:	4701                	li	a4,0
ffffffffc020275e:	4585                	li	a1,1
ffffffffc0202760:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0202764:	00671793          	slli	a5,a4,0x6
ffffffffc0202768:	97b2                	add	a5,a5,a2
ffffffffc020276a:	07a1                	addi	a5,a5,8 # 80008 <_binary_obj___user_matrix_out_size+0x74ad8>
ffffffffc020276c:	40b7b02f          	amoor.d	zero,a1,(a5)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202770:	6088                	ld	a0,0(s1)
ffffffffc0202772:	0705                	addi	a4,a4,1
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202774:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202778:	00d507b3          	add	a5,a0,a3
ffffffffc020277c:	fef764e3          	bltu	a4,a5,ffffffffc0202764 <pmm_init+0xc6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202780:	079a                	slli	a5,a5,0x6
ffffffffc0202782:	00f606b3          	add	a3,a2,a5
ffffffffc0202786:	c02007b7          	lui	a5,0xc0200
ffffffffc020278a:	16f6eee3          	bltu	a3,a5,ffffffffc0203106 <pmm_init+0xa68>
ffffffffc020278e:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0202792:	77fd                	lui	a5,0xfffff
ffffffffc0202794:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202796:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202798:	4e86ed63          	bltu	a3,s0,ffffffffc0202c92 <pmm_init+0x5f4>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc020279c:	00005517          	auipc	a0,0x5
ffffffffc02027a0:	a2c50513          	addi	a0,a0,-1492 # ffffffffc02071c8 <etext+0xf5a>
ffffffffc02027a4:	9f5fd0ef          	jal	ffffffffc0200198 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc02027a8:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02027ac:	000b3917          	auipc	s2,0xb3
ffffffffc02027b0:	e7490913          	addi	s2,s2,-396 # ffffffffc02b5620 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc02027b4:	7b9c                	ld	a5,48(a5)
ffffffffc02027b6:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02027b8:	00005517          	auipc	a0,0x5
ffffffffc02027bc:	a2850513          	addi	a0,a0,-1496 # ffffffffc02071e0 <etext+0xf72>
ffffffffc02027c0:	9d9fd0ef          	jal	ffffffffc0200198 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02027c4:	00009697          	auipc	a3,0x9
ffffffffc02027c8:	83c68693          	addi	a3,a3,-1988 # ffffffffc020b000 <boot_page_table_sv39>
ffffffffc02027cc:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02027d0:	c02007b7          	lui	a5,0xc0200
ffffffffc02027d4:	2af6eee3          	bltu	a3,a5,ffffffffc0203290 <pmm_init+0xbf2>
ffffffffc02027d8:	0009b783          	ld	a5,0(s3)
ffffffffc02027dc:	8e9d                	sub	a3,a3,a5
ffffffffc02027de:	000b3797          	auipc	a5,0xb3
ffffffffc02027e2:	e2d7bd23          	sd	a3,-454(a5) # ffffffffc02b5618 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02027e6:	100027f3          	csrr	a5,sstatus
ffffffffc02027ea:	8b89                	andi	a5,a5,2
ffffffffc02027ec:	48079963          	bnez	a5,ffffffffc0202c7e <pmm_init+0x5e0>
        ret = pmm_manager->nr_free_pages();
ffffffffc02027f0:	000b3783          	ld	a5,0(s6)
ffffffffc02027f4:	779c                	ld	a5,40(a5)
ffffffffc02027f6:	9782                	jalr	a5
ffffffffc02027f8:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02027fa:	6098                	ld	a4,0(s1)
ffffffffc02027fc:	c80007b7          	lui	a5,0xc8000
ffffffffc0202800:	83b1                	srli	a5,a5,0xc
ffffffffc0202802:	66e7e663          	bltu	a5,a4,ffffffffc0202e6e <pmm_init+0x7d0>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202806:	00093503          	ld	a0,0(s2)
ffffffffc020280a:	64050263          	beqz	a0,ffffffffc0202e4e <pmm_init+0x7b0>
ffffffffc020280e:	03451793          	slli	a5,a0,0x34
ffffffffc0202812:	62079e63          	bnez	a5,ffffffffc0202e4e <pmm_init+0x7b0>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202816:	4601                	li	a2,0
ffffffffc0202818:	4581                	li	a1,0
ffffffffc020281a:	8b7ff0ef          	jal	ffffffffc02020d0 <get_page>
ffffffffc020281e:	240519e3          	bnez	a0,ffffffffc0203270 <pmm_init+0xbd2>
ffffffffc0202822:	100027f3          	csrr	a5,sstatus
ffffffffc0202826:	8b89                	andi	a5,a5,2
ffffffffc0202828:	44079063          	bnez	a5,ffffffffc0202c68 <pmm_init+0x5ca>
        page = pmm_manager->alloc_pages(n);
ffffffffc020282c:	000b3783          	ld	a5,0(s6)
ffffffffc0202830:	4505                	li	a0,1
ffffffffc0202832:	6f9c                	ld	a5,24(a5)
ffffffffc0202834:	9782                	jalr	a5
ffffffffc0202836:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202838:	00093503          	ld	a0,0(s2)
ffffffffc020283c:	4681                	li	a3,0
ffffffffc020283e:	4601                	li	a2,0
ffffffffc0202840:	85d2                	mv	a1,s4
ffffffffc0202842:	d67ff0ef          	jal	ffffffffc02025a8 <page_insert>
ffffffffc0202846:	280511e3          	bnez	a0,ffffffffc02032c8 <pmm_init+0xc2a>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc020284a:	00093503          	ld	a0,0(s2)
ffffffffc020284e:	4601                	li	a2,0
ffffffffc0202850:	4581                	li	a1,0
ffffffffc0202852:	e20ff0ef          	jal	ffffffffc0201e72 <get_pte>
ffffffffc0202856:	240509e3          	beqz	a0,ffffffffc02032a8 <pmm_init+0xc0a>
    assert(pte2page(*ptep) == p1);
ffffffffc020285a:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc020285c:	0017f713          	andi	a4,a5,1
ffffffffc0202860:	58070f63          	beqz	a4,ffffffffc0202dfe <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc0202864:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202866:	078a                	slli	a5,a5,0x2
ffffffffc0202868:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020286a:	58e7f863          	bgeu	a5,a4,ffffffffc0202dfa <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc020286e:	000bb683          	ld	a3,0(s7)
ffffffffc0202872:	079a                	slli	a5,a5,0x6
ffffffffc0202874:	fe000637          	lui	a2,0xfe000
ffffffffc0202878:	97b2                	add	a5,a5,a2
ffffffffc020287a:	97b6                	add	a5,a5,a3
ffffffffc020287c:	14fa1ae3          	bne	s4,a5,ffffffffc02031d0 <pmm_init+0xb32>
    assert(page_ref(p1) == 1);
ffffffffc0202880:	000a2683          	lw	a3,0(s4) # 200000 <_binary_obj___user_matrix_out_size+0x1f4ad0>
ffffffffc0202884:	4785                	li	a5,1
ffffffffc0202886:	12f695e3          	bne	a3,a5,ffffffffc02031b0 <pmm_init+0xb12>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020288a:	00093503          	ld	a0,0(s2)
ffffffffc020288e:	77fd                	lui	a5,0xfffff
ffffffffc0202890:	6114                	ld	a3,0(a0)
ffffffffc0202892:	068a                	slli	a3,a3,0x2
ffffffffc0202894:	8efd                	and	a3,a3,a5
ffffffffc0202896:	00c6d613          	srli	a2,a3,0xc
ffffffffc020289a:	0ee67fe3          	bgeu	a2,a4,ffffffffc0203198 <pmm_init+0xafa>
ffffffffc020289e:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02028a2:	96e2                	add	a3,a3,s8
ffffffffc02028a4:	0006ba83          	ld	s5,0(a3)
ffffffffc02028a8:	0a8a                	slli	s5,s5,0x2
ffffffffc02028aa:	00fafab3          	and	s5,s5,a5
ffffffffc02028ae:	00cad793          	srli	a5,s5,0xc
ffffffffc02028b2:	0ce7f6e3          	bgeu	a5,a4,ffffffffc020317e <pmm_init+0xae0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02028b6:	4601                	li	a2,0
ffffffffc02028b8:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02028ba:	9c56                	add	s8,s8,s5
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02028bc:	db6ff0ef          	jal	ffffffffc0201e72 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02028c0:	0c21                	addi	s8,s8,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02028c2:	05851ee3          	bne	a0,s8,ffffffffc020311e <pmm_init+0xa80>
ffffffffc02028c6:	100027f3          	csrr	a5,sstatus
ffffffffc02028ca:	8b89                	andi	a5,a5,2
ffffffffc02028cc:	3e079b63          	bnez	a5,ffffffffc0202cc2 <pmm_init+0x624>
        page = pmm_manager->alloc_pages(n);
ffffffffc02028d0:	000b3783          	ld	a5,0(s6)
ffffffffc02028d4:	4505                	li	a0,1
ffffffffc02028d6:	6f9c                	ld	a5,24(a5)
ffffffffc02028d8:	9782                	jalr	a5
ffffffffc02028da:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02028dc:	00093503          	ld	a0,0(s2)
ffffffffc02028e0:	46d1                	li	a3,20
ffffffffc02028e2:	6605                	lui	a2,0x1
ffffffffc02028e4:	85e2                	mv	a1,s8
ffffffffc02028e6:	cc3ff0ef          	jal	ffffffffc02025a8 <page_insert>
ffffffffc02028ea:	06051ae3          	bnez	a0,ffffffffc020315e <pmm_init+0xac0>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02028ee:	00093503          	ld	a0,0(s2)
ffffffffc02028f2:	4601                	li	a2,0
ffffffffc02028f4:	6585                	lui	a1,0x1
ffffffffc02028f6:	d7cff0ef          	jal	ffffffffc0201e72 <get_pte>
ffffffffc02028fa:	040502e3          	beqz	a0,ffffffffc020313e <pmm_init+0xaa0>
    assert(*ptep & PTE_U);
ffffffffc02028fe:	611c                	ld	a5,0(a0)
ffffffffc0202900:	0107f713          	andi	a4,a5,16
ffffffffc0202904:	7e070163          	beqz	a4,ffffffffc02030e6 <pmm_init+0xa48>
    assert(*ptep & PTE_W);
ffffffffc0202908:	8b91                	andi	a5,a5,4
ffffffffc020290a:	7a078e63          	beqz	a5,ffffffffc02030c6 <pmm_init+0xa28>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc020290e:	00093503          	ld	a0,0(s2)
ffffffffc0202912:	611c                	ld	a5,0(a0)
ffffffffc0202914:	8bc1                	andi	a5,a5,16
ffffffffc0202916:	78078863          	beqz	a5,ffffffffc02030a6 <pmm_init+0xa08>
    assert(page_ref(p2) == 1);
ffffffffc020291a:	000c2703          	lw	a4,0(s8)
ffffffffc020291e:	4785                	li	a5,1
ffffffffc0202920:	76f71363          	bne	a4,a5,ffffffffc0203086 <pmm_init+0x9e8>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202924:	4681                	li	a3,0
ffffffffc0202926:	6605                	lui	a2,0x1
ffffffffc0202928:	85d2                	mv	a1,s4
ffffffffc020292a:	c7fff0ef          	jal	ffffffffc02025a8 <page_insert>
ffffffffc020292e:	72051c63          	bnez	a0,ffffffffc0203066 <pmm_init+0x9c8>
    assert(page_ref(p1) == 2);
ffffffffc0202932:	000a2703          	lw	a4,0(s4)
ffffffffc0202936:	4789                	li	a5,2
ffffffffc0202938:	70f71763          	bne	a4,a5,ffffffffc0203046 <pmm_init+0x9a8>
    assert(page_ref(p2) == 0);
ffffffffc020293c:	000c2783          	lw	a5,0(s8)
ffffffffc0202940:	6e079363          	bnez	a5,ffffffffc0203026 <pmm_init+0x988>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202944:	00093503          	ld	a0,0(s2)
ffffffffc0202948:	4601                	li	a2,0
ffffffffc020294a:	6585                	lui	a1,0x1
ffffffffc020294c:	d26ff0ef          	jal	ffffffffc0201e72 <get_pte>
ffffffffc0202950:	6a050b63          	beqz	a0,ffffffffc0203006 <pmm_init+0x968>
    assert(pte2page(*ptep) == p1);
ffffffffc0202954:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202956:	00177793          	andi	a5,a4,1
ffffffffc020295a:	4a078263          	beqz	a5,ffffffffc0202dfe <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc020295e:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202960:	00271793          	slli	a5,a4,0x2
ffffffffc0202964:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202966:	48d7fa63          	bgeu	a5,a3,ffffffffc0202dfa <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc020296a:	000bb683          	ld	a3,0(s7)
ffffffffc020296e:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202972:	97d6                	add	a5,a5,s5
ffffffffc0202974:	079a                	slli	a5,a5,0x6
ffffffffc0202976:	97b6                	add	a5,a5,a3
ffffffffc0202978:	66fa1763          	bne	s4,a5,ffffffffc0202fe6 <pmm_init+0x948>
    assert((*ptep & PTE_U) == 0);
ffffffffc020297c:	8b41                	andi	a4,a4,16
ffffffffc020297e:	64071463          	bnez	a4,ffffffffc0202fc6 <pmm_init+0x928>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202982:	00093503          	ld	a0,0(s2)
ffffffffc0202986:	4581                	li	a1,0
ffffffffc0202988:	b85ff0ef          	jal	ffffffffc020250c <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc020298c:	000a2c83          	lw	s9,0(s4)
ffffffffc0202990:	4785                	li	a5,1
ffffffffc0202992:	60fc9a63          	bne	s9,a5,ffffffffc0202fa6 <pmm_init+0x908>
    assert(page_ref(p2) == 0);
ffffffffc0202996:	000c2783          	lw	a5,0(s8)
ffffffffc020299a:	5e079663          	bnez	a5,ffffffffc0202f86 <pmm_init+0x8e8>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc020299e:	00093503          	ld	a0,0(s2)
ffffffffc02029a2:	6585                	lui	a1,0x1
ffffffffc02029a4:	b69ff0ef          	jal	ffffffffc020250c <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc02029a8:	000a2783          	lw	a5,0(s4)
ffffffffc02029ac:	52079d63          	bnez	a5,ffffffffc0202ee6 <pmm_init+0x848>
    assert(page_ref(p2) == 0);
ffffffffc02029b0:	000c2783          	lw	a5,0(s8)
ffffffffc02029b4:	50079963          	bnez	a5,ffffffffc0202ec6 <pmm_init+0x828>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc02029b8:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc02029bc:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02029be:	000a3783          	ld	a5,0(s4)
ffffffffc02029c2:	078a                	slli	a5,a5,0x2
ffffffffc02029c4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02029c6:	42e7fa63          	bgeu	a5,a4,ffffffffc0202dfa <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc02029ca:	000bb503          	ld	a0,0(s7)
ffffffffc02029ce:	97d6                	add	a5,a5,s5
ffffffffc02029d0:	079a                	slli	a5,a5,0x6
    return page->ref;
ffffffffc02029d2:	00f506b3          	add	a3,a0,a5
ffffffffc02029d6:	4294                	lw	a3,0(a3)
ffffffffc02029d8:	4d969763          	bne	a3,s9,ffffffffc0202ea6 <pmm_init+0x808>
    return page - pages + nbase;
ffffffffc02029dc:	8799                	srai	a5,a5,0x6
ffffffffc02029de:	00080637          	lui	a2,0x80
ffffffffc02029e2:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02029e4:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc02029e8:	4ae7f363          	bgeu	a5,a4,ffffffffc0202e8e <pmm_init+0x7f0>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc02029ec:	0009b783          	ld	a5,0(s3)
ffffffffc02029f0:	97b6                	add	a5,a5,a3
    return pa2page(PDE_ADDR(pde));
ffffffffc02029f2:	639c                	ld	a5,0(a5)
ffffffffc02029f4:	078a                	slli	a5,a5,0x2
ffffffffc02029f6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02029f8:	40e7f163          	bgeu	a5,a4,ffffffffc0202dfa <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc02029fc:	8f91                	sub	a5,a5,a2
ffffffffc02029fe:	079a                	slli	a5,a5,0x6
ffffffffc0202a00:	953e                	add	a0,a0,a5
ffffffffc0202a02:	100027f3          	csrr	a5,sstatus
ffffffffc0202a06:	8b89                	andi	a5,a5,2
ffffffffc0202a08:	30079863          	bnez	a5,ffffffffc0202d18 <pmm_init+0x67a>
        pmm_manager->free_pages(base, n);
ffffffffc0202a0c:	000b3783          	ld	a5,0(s6)
ffffffffc0202a10:	4585                	li	a1,1
ffffffffc0202a12:	739c                	ld	a5,32(a5)
ffffffffc0202a14:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a16:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202a1a:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a1c:	078a                	slli	a5,a5,0x2
ffffffffc0202a1e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a20:	3ce7fd63          	bgeu	a5,a4,ffffffffc0202dfa <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a24:	000bb503          	ld	a0,0(s7)
ffffffffc0202a28:	fe000737          	lui	a4,0xfe000
ffffffffc0202a2c:	079a                	slli	a5,a5,0x6
ffffffffc0202a2e:	97ba                	add	a5,a5,a4
ffffffffc0202a30:	953e                	add	a0,a0,a5
ffffffffc0202a32:	100027f3          	csrr	a5,sstatus
ffffffffc0202a36:	8b89                	andi	a5,a5,2
ffffffffc0202a38:	2c079463          	bnez	a5,ffffffffc0202d00 <pmm_init+0x662>
ffffffffc0202a3c:	000b3783          	ld	a5,0(s6)
ffffffffc0202a40:	4585                	li	a1,1
ffffffffc0202a42:	739c                	ld	a5,32(a5)
ffffffffc0202a44:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202a46:	00093783          	ld	a5,0(s2)
ffffffffc0202a4a:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd49990>
    asm volatile("sfence.vma");
ffffffffc0202a4e:	12000073          	sfence.vma
ffffffffc0202a52:	100027f3          	csrr	a5,sstatus
ffffffffc0202a56:	8b89                	andi	a5,a5,2
ffffffffc0202a58:	28079a63          	bnez	a5,ffffffffc0202cec <pmm_init+0x64e>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202a5c:	000b3783          	ld	a5,0(s6)
ffffffffc0202a60:	779c                	ld	a5,40(a5)
ffffffffc0202a62:	9782                	jalr	a5
ffffffffc0202a64:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202a66:	4d441063          	bne	s0,s4,ffffffffc0202f26 <pmm_init+0x888>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202a6a:	00005517          	auipc	a0,0x5
ffffffffc0202a6e:	ac650513          	addi	a0,a0,-1338 # ffffffffc0207530 <etext+0x12c2>
ffffffffc0202a72:	f26fd0ef          	jal	ffffffffc0200198 <cprintf>
ffffffffc0202a76:	100027f3          	csrr	a5,sstatus
ffffffffc0202a7a:	8b89                	andi	a5,a5,2
ffffffffc0202a7c:	24079e63          	bnez	a5,ffffffffc0202cd8 <pmm_init+0x63a>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202a80:	000b3783          	ld	a5,0(s6)
ffffffffc0202a84:	779c                	ld	a5,40(a5)
ffffffffc0202a86:	9782                	jalr	a5
ffffffffc0202a88:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202a8a:	609c                	ld	a5,0(s1)
ffffffffc0202a8c:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202a90:	7a7d                	lui	s4,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202a92:	00c79713          	slli	a4,a5,0xc
ffffffffc0202a96:	6a85                	lui	s5,0x1
ffffffffc0202a98:	02e47c63          	bgeu	s0,a4,ffffffffc0202ad0 <pmm_init+0x432>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202a9c:	00c45713          	srli	a4,s0,0xc
ffffffffc0202aa0:	30f77063          	bgeu	a4,a5,ffffffffc0202da0 <pmm_init+0x702>
ffffffffc0202aa4:	0009b583          	ld	a1,0(s3)
ffffffffc0202aa8:	00093503          	ld	a0,0(s2)
ffffffffc0202aac:	4601                	li	a2,0
ffffffffc0202aae:	95a2                	add	a1,a1,s0
ffffffffc0202ab0:	bc2ff0ef          	jal	ffffffffc0201e72 <get_pte>
ffffffffc0202ab4:	32050363          	beqz	a0,ffffffffc0202dda <pmm_init+0x73c>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202ab8:	611c                	ld	a5,0(a0)
ffffffffc0202aba:	078a                	slli	a5,a5,0x2
ffffffffc0202abc:	0147f7b3          	and	a5,a5,s4
ffffffffc0202ac0:	2e879d63          	bne	a5,s0,ffffffffc0202dba <pmm_init+0x71c>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202ac4:	609c                	ld	a5,0(s1)
ffffffffc0202ac6:	9456                	add	s0,s0,s5
ffffffffc0202ac8:	00c79713          	slli	a4,a5,0xc
ffffffffc0202acc:	fce468e3          	bltu	s0,a4,ffffffffc0202a9c <pmm_init+0x3fe>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202ad0:	00093783          	ld	a5,0(s2)
ffffffffc0202ad4:	639c                	ld	a5,0(a5)
ffffffffc0202ad6:	42079863          	bnez	a5,ffffffffc0202f06 <pmm_init+0x868>
ffffffffc0202ada:	100027f3          	csrr	a5,sstatus
ffffffffc0202ade:	8b89                	andi	a5,a5,2
ffffffffc0202ae0:	24079863          	bnez	a5,ffffffffc0202d30 <pmm_init+0x692>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202ae4:	000b3783          	ld	a5,0(s6)
ffffffffc0202ae8:	4505                	li	a0,1
ffffffffc0202aea:	6f9c                	ld	a5,24(a5)
ffffffffc0202aec:	9782                	jalr	a5
ffffffffc0202aee:	842a                	mv	s0,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202af0:	00093503          	ld	a0,0(s2)
ffffffffc0202af4:	4699                	li	a3,6
ffffffffc0202af6:	10000613          	li	a2,256
ffffffffc0202afa:	85a2                	mv	a1,s0
ffffffffc0202afc:	aadff0ef          	jal	ffffffffc02025a8 <page_insert>
ffffffffc0202b00:	46051363          	bnez	a0,ffffffffc0202f66 <pmm_init+0x8c8>
    assert(page_ref(p) == 1);
ffffffffc0202b04:	4018                	lw	a4,0(s0)
ffffffffc0202b06:	4785                	li	a5,1
ffffffffc0202b08:	42f71f63          	bne	a4,a5,ffffffffc0202f46 <pmm_init+0x8a8>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202b0c:	00093503          	ld	a0,0(s2)
ffffffffc0202b10:	6605                	lui	a2,0x1
ffffffffc0202b12:	10060613          	addi	a2,a2,256 # 1100 <_binary_obj___user_softint_out_size-0x7e28>
ffffffffc0202b16:	4699                	li	a3,6
ffffffffc0202b18:	85a2                	mv	a1,s0
ffffffffc0202b1a:	a8fff0ef          	jal	ffffffffc02025a8 <page_insert>
ffffffffc0202b1e:	72051963          	bnez	a0,ffffffffc0203250 <pmm_init+0xbb2>
    assert(page_ref(p) == 2);
ffffffffc0202b22:	4018                	lw	a4,0(s0)
ffffffffc0202b24:	4789                	li	a5,2
ffffffffc0202b26:	70f71563          	bne	a4,a5,ffffffffc0203230 <pmm_init+0xb92>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202b2a:	00005597          	auipc	a1,0x5
ffffffffc0202b2e:	b4e58593          	addi	a1,a1,-1202 # ffffffffc0207678 <etext+0x140a>
ffffffffc0202b32:	10000513          	li	a0,256
ffffffffc0202b36:	68e030ef          	jal	ffffffffc02061c4 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202b3a:	6585                	lui	a1,0x1
ffffffffc0202b3c:	10058593          	addi	a1,a1,256 # 1100 <_binary_obj___user_softint_out_size-0x7e28>
ffffffffc0202b40:	10000513          	li	a0,256
ffffffffc0202b44:	692030ef          	jal	ffffffffc02061d6 <strcmp>
ffffffffc0202b48:	6c051463          	bnez	a0,ffffffffc0203210 <pmm_init+0xb72>
    return page - pages + nbase;
ffffffffc0202b4c:	000bb683          	ld	a3,0(s7)
ffffffffc0202b50:	000807b7          	lui	a5,0x80
    return KADDR(page2pa(page));
ffffffffc0202b54:	6098                	ld	a4,0(s1)
    return page - pages + nbase;
ffffffffc0202b56:	40d406b3          	sub	a3,s0,a3
ffffffffc0202b5a:	8699                	srai	a3,a3,0x6
ffffffffc0202b5c:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0202b5e:	00c69793          	slli	a5,a3,0xc
ffffffffc0202b62:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202b64:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202b66:	32e7f463          	bgeu	a5,a4,ffffffffc0202e8e <pmm_init+0x7f0>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202b6a:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202b6e:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202b72:	97b6                	add	a5,a5,a3
ffffffffc0202b74:	10078023          	sb	zero,256(a5) # 80100 <_binary_obj___user_matrix_out_size+0x74bd0>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202b78:	618030ef          	jal	ffffffffc0206190 <strlen>
ffffffffc0202b7c:	66051a63          	bnez	a0,ffffffffc02031f0 <pmm_init+0xb52>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202b80:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202b84:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b86:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fd49990>
ffffffffc0202b8a:	078a                	slli	a5,a5,0x2
ffffffffc0202b8c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b8e:	26e7f663          	bgeu	a5,a4,ffffffffc0202dfa <pmm_init+0x75c>
    return page2ppn(page) << PGSHIFT;
ffffffffc0202b92:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202b96:	2ee7fc63          	bgeu	a5,a4,ffffffffc0202e8e <pmm_init+0x7f0>
ffffffffc0202b9a:	0009b783          	ld	a5,0(s3)
ffffffffc0202b9e:	00f689b3          	add	s3,a3,a5
ffffffffc0202ba2:	100027f3          	csrr	a5,sstatus
ffffffffc0202ba6:	8b89                	andi	a5,a5,2
ffffffffc0202ba8:	1e079163          	bnez	a5,ffffffffc0202d8a <pmm_init+0x6ec>
        pmm_manager->free_pages(base, n);
ffffffffc0202bac:	000b3783          	ld	a5,0(s6)
ffffffffc0202bb0:	8522                	mv	a0,s0
ffffffffc0202bb2:	4585                	li	a1,1
ffffffffc0202bb4:	739c                	ld	a5,32(a5)
ffffffffc0202bb6:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202bb8:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage)
ffffffffc0202bbc:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202bbe:	078a                	slli	a5,a5,0x2
ffffffffc0202bc0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202bc2:	22e7fc63          	bgeu	a5,a4,ffffffffc0202dfa <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202bc6:	000bb503          	ld	a0,0(s7)
ffffffffc0202bca:	fe000737          	lui	a4,0xfe000
ffffffffc0202bce:	079a                	slli	a5,a5,0x6
ffffffffc0202bd0:	97ba                	add	a5,a5,a4
ffffffffc0202bd2:	953e                	add	a0,a0,a5
ffffffffc0202bd4:	100027f3          	csrr	a5,sstatus
ffffffffc0202bd8:	8b89                	andi	a5,a5,2
ffffffffc0202bda:	18079c63          	bnez	a5,ffffffffc0202d72 <pmm_init+0x6d4>
ffffffffc0202bde:	000b3783          	ld	a5,0(s6)
ffffffffc0202be2:	4585                	li	a1,1
ffffffffc0202be4:	739c                	ld	a5,32(a5)
ffffffffc0202be6:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202be8:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202bec:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202bee:	078a                	slli	a5,a5,0x2
ffffffffc0202bf0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202bf2:	20e7f463          	bgeu	a5,a4,ffffffffc0202dfa <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202bf6:	000bb503          	ld	a0,0(s7)
ffffffffc0202bfa:	fe000737          	lui	a4,0xfe000
ffffffffc0202bfe:	079a                	slli	a5,a5,0x6
ffffffffc0202c00:	97ba                	add	a5,a5,a4
ffffffffc0202c02:	953e                	add	a0,a0,a5
ffffffffc0202c04:	100027f3          	csrr	a5,sstatus
ffffffffc0202c08:	8b89                	andi	a5,a5,2
ffffffffc0202c0a:	14079863          	bnez	a5,ffffffffc0202d5a <pmm_init+0x6bc>
ffffffffc0202c0e:	000b3783          	ld	a5,0(s6)
ffffffffc0202c12:	4585                	li	a1,1
ffffffffc0202c14:	739c                	ld	a5,32(a5)
ffffffffc0202c16:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202c18:	00093783          	ld	a5,0(s2)
ffffffffc0202c1c:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202c20:	12000073          	sfence.vma
ffffffffc0202c24:	100027f3          	csrr	a5,sstatus
ffffffffc0202c28:	8b89                	andi	a5,a5,2
ffffffffc0202c2a:	10079e63          	bnez	a5,ffffffffc0202d46 <pmm_init+0x6a8>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c2e:	000b3783          	ld	a5,0(s6)
ffffffffc0202c32:	779c                	ld	a5,40(a5)
ffffffffc0202c34:	9782                	jalr	a5
ffffffffc0202c36:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202c38:	1e8c1b63          	bne	s8,s0,ffffffffc0202e2e <pmm_init+0x790>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202c3c:	00005517          	auipc	a0,0x5
ffffffffc0202c40:	ab450513          	addi	a0,a0,-1356 # ffffffffc02076f0 <etext+0x1482>
ffffffffc0202c44:	d54fd0ef          	jal	ffffffffc0200198 <cprintf>
}
ffffffffc0202c48:	7406                	ld	s0,96(sp)
ffffffffc0202c4a:	70a6                	ld	ra,104(sp)
ffffffffc0202c4c:	64e6                	ld	s1,88(sp)
ffffffffc0202c4e:	6946                	ld	s2,80(sp)
ffffffffc0202c50:	69a6                	ld	s3,72(sp)
ffffffffc0202c52:	6a06                	ld	s4,64(sp)
ffffffffc0202c54:	7ae2                	ld	s5,56(sp)
ffffffffc0202c56:	7b42                	ld	s6,48(sp)
ffffffffc0202c58:	7ba2                	ld	s7,40(sp)
ffffffffc0202c5a:	7c02                	ld	s8,32(sp)
ffffffffc0202c5c:	6ce2                	ld	s9,24(sp)
ffffffffc0202c5e:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202c60:	f85fe06f          	j	ffffffffc0201be4 <kmalloc_init>
    if (maxpa > KERNTOP)
ffffffffc0202c64:	853e                	mv	a0,a5
ffffffffc0202c66:	b4e1                	j	ffffffffc020272e <pmm_init+0x90>
        intr_disable();
ffffffffc0202c68:	ca3fd0ef          	jal	ffffffffc020090a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202c6c:	000b3783          	ld	a5,0(s6)
ffffffffc0202c70:	4505                	li	a0,1
ffffffffc0202c72:	6f9c                	ld	a5,24(a5)
ffffffffc0202c74:	9782                	jalr	a5
ffffffffc0202c76:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202c78:	c8dfd0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0202c7c:	be75                	j	ffffffffc0202838 <pmm_init+0x19a>
        intr_disable();
ffffffffc0202c7e:	c8dfd0ef          	jal	ffffffffc020090a <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c82:	000b3783          	ld	a5,0(s6)
ffffffffc0202c86:	779c                	ld	a5,40(a5)
ffffffffc0202c88:	9782                	jalr	a5
ffffffffc0202c8a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202c8c:	c79fd0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0202c90:	b6ad                	j	ffffffffc02027fa <pmm_init+0x15c>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202c92:	6705                	lui	a4,0x1
ffffffffc0202c94:	177d                	addi	a4,a4,-1 # fff <_binary_obj___user_softint_out_size-0x7f29>
ffffffffc0202c96:	96ba                	add	a3,a3,a4
ffffffffc0202c98:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202c9a:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202c9e:	14a77e63          	bgeu	a4,a0,ffffffffc0202dfa <pmm_init+0x75c>
    pmm_manager->init_memmap(base, n);
ffffffffc0202ca2:	000b3683          	ld	a3,0(s6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202ca6:	8c1d                	sub	s0,s0,a5
    return &pages[PPN(pa) - nbase];
ffffffffc0202ca8:	071a                	slli	a4,a4,0x6
ffffffffc0202caa:	fe0007b7          	lui	a5,0xfe000
ffffffffc0202cae:	973e                	add	a4,a4,a5
    pmm_manager->init_memmap(base, n);
ffffffffc0202cb0:	6a9c                	ld	a5,16(a3)
ffffffffc0202cb2:	00c45593          	srli	a1,s0,0xc
ffffffffc0202cb6:	00e60533          	add	a0,a2,a4
ffffffffc0202cba:	9782                	jalr	a5
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202cbc:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202cc0:	bcf1                	j	ffffffffc020279c <pmm_init+0xfe>
        intr_disable();
ffffffffc0202cc2:	c49fd0ef          	jal	ffffffffc020090a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202cc6:	000b3783          	ld	a5,0(s6)
ffffffffc0202cca:	4505                	li	a0,1
ffffffffc0202ccc:	6f9c                	ld	a5,24(a5)
ffffffffc0202cce:	9782                	jalr	a5
ffffffffc0202cd0:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202cd2:	c33fd0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0202cd6:	b119                	j	ffffffffc02028dc <pmm_init+0x23e>
        intr_disable();
ffffffffc0202cd8:	c33fd0ef          	jal	ffffffffc020090a <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202cdc:	000b3783          	ld	a5,0(s6)
ffffffffc0202ce0:	779c                	ld	a5,40(a5)
ffffffffc0202ce2:	9782                	jalr	a5
ffffffffc0202ce4:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202ce6:	c1ffd0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0202cea:	b345                	j	ffffffffc0202a8a <pmm_init+0x3ec>
        intr_disable();
ffffffffc0202cec:	c1ffd0ef          	jal	ffffffffc020090a <intr_disable>
ffffffffc0202cf0:	000b3783          	ld	a5,0(s6)
ffffffffc0202cf4:	779c                	ld	a5,40(a5)
ffffffffc0202cf6:	9782                	jalr	a5
ffffffffc0202cf8:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202cfa:	c0bfd0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0202cfe:	b3a5                	j	ffffffffc0202a66 <pmm_init+0x3c8>
ffffffffc0202d00:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202d02:	c09fd0ef          	jal	ffffffffc020090a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202d06:	000b3783          	ld	a5,0(s6)
ffffffffc0202d0a:	6522                	ld	a0,8(sp)
ffffffffc0202d0c:	4585                	li	a1,1
ffffffffc0202d0e:	739c                	ld	a5,32(a5)
ffffffffc0202d10:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d12:	bf3fd0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0202d16:	bb05                	j	ffffffffc0202a46 <pmm_init+0x3a8>
ffffffffc0202d18:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202d1a:	bf1fd0ef          	jal	ffffffffc020090a <intr_disable>
ffffffffc0202d1e:	000b3783          	ld	a5,0(s6)
ffffffffc0202d22:	6522                	ld	a0,8(sp)
ffffffffc0202d24:	4585                	li	a1,1
ffffffffc0202d26:	739c                	ld	a5,32(a5)
ffffffffc0202d28:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d2a:	bdbfd0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0202d2e:	b1e5                	j	ffffffffc0202a16 <pmm_init+0x378>
        intr_disable();
ffffffffc0202d30:	bdbfd0ef          	jal	ffffffffc020090a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202d34:	000b3783          	ld	a5,0(s6)
ffffffffc0202d38:	4505                	li	a0,1
ffffffffc0202d3a:	6f9c                	ld	a5,24(a5)
ffffffffc0202d3c:	9782                	jalr	a5
ffffffffc0202d3e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202d40:	bc5fd0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0202d44:	b375                	j	ffffffffc0202af0 <pmm_init+0x452>
        intr_disable();
ffffffffc0202d46:	bc5fd0ef          	jal	ffffffffc020090a <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d4a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d4e:	779c                	ld	a5,40(a5)
ffffffffc0202d50:	9782                	jalr	a5
ffffffffc0202d52:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202d54:	bb1fd0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0202d58:	b5c5                	j	ffffffffc0202c38 <pmm_init+0x59a>
ffffffffc0202d5a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202d5c:	baffd0ef          	jal	ffffffffc020090a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202d60:	000b3783          	ld	a5,0(s6)
ffffffffc0202d64:	6522                	ld	a0,8(sp)
ffffffffc0202d66:	4585                	li	a1,1
ffffffffc0202d68:	739c                	ld	a5,32(a5)
ffffffffc0202d6a:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d6c:	b99fd0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0202d70:	b565                	j	ffffffffc0202c18 <pmm_init+0x57a>
ffffffffc0202d72:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202d74:	b97fd0ef          	jal	ffffffffc020090a <intr_disable>
ffffffffc0202d78:	000b3783          	ld	a5,0(s6)
ffffffffc0202d7c:	6522                	ld	a0,8(sp)
ffffffffc0202d7e:	4585                	li	a1,1
ffffffffc0202d80:	739c                	ld	a5,32(a5)
ffffffffc0202d82:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d84:	b81fd0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0202d88:	b585                	j	ffffffffc0202be8 <pmm_init+0x54a>
        intr_disable();
ffffffffc0202d8a:	b81fd0ef          	jal	ffffffffc020090a <intr_disable>
ffffffffc0202d8e:	000b3783          	ld	a5,0(s6)
ffffffffc0202d92:	8522                	mv	a0,s0
ffffffffc0202d94:	4585                	li	a1,1
ffffffffc0202d96:	739c                	ld	a5,32(a5)
ffffffffc0202d98:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d9a:	b6bfd0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0202d9e:	bd29                	j	ffffffffc0202bb8 <pmm_init+0x51a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202da0:	86a2                	mv	a3,s0
ffffffffc0202da2:	00004617          	auipc	a2,0x4
ffffffffc0202da6:	26660613          	addi	a2,a2,614 # ffffffffc0207008 <etext+0xd9a>
ffffffffc0202daa:	25100593          	li	a1,593
ffffffffc0202dae:	00004517          	auipc	a0,0x4
ffffffffc0202db2:	34a50513          	addi	a0,a0,842 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202db6:	e94fd0ef          	jal	ffffffffc020044a <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202dba:	00004697          	auipc	a3,0x4
ffffffffc0202dbe:	7d668693          	addi	a3,a3,2006 # ffffffffc0207590 <etext+0x1322>
ffffffffc0202dc2:	00004617          	auipc	a2,0x4
ffffffffc0202dc6:	e9660613          	addi	a2,a2,-362 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202dca:	25200593          	li	a1,594
ffffffffc0202dce:	00004517          	auipc	a0,0x4
ffffffffc0202dd2:	32a50513          	addi	a0,a0,810 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202dd6:	e74fd0ef          	jal	ffffffffc020044a <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202dda:	00004697          	auipc	a3,0x4
ffffffffc0202dde:	77668693          	addi	a3,a3,1910 # ffffffffc0207550 <etext+0x12e2>
ffffffffc0202de2:	00004617          	auipc	a2,0x4
ffffffffc0202de6:	e7660613          	addi	a2,a2,-394 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202dea:	25100593          	li	a1,593
ffffffffc0202dee:	00004517          	auipc	a0,0x4
ffffffffc0202df2:	30a50513          	addi	a0,a0,778 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202df6:	e54fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202dfa:	fb5fe0ef          	jal	ffffffffc0201dae <pa2page.part.0>
        panic("pte2page called with invalid pte");
ffffffffc0202dfe:	00004617          	auipc	a2,0x4
ffffffffc0202e02:	4f260613          	addi	a2,a2,1266 # ffffffffc02072f0 <etext+0x1082>
ffffffffc0202e06:	07f00593          	li	a1,127
ffffffffc0202e0a:	00004517          	auipc	a0,0x4
ffffffffc0202e0e:	22650513          	addi	a0,a0,550 # ffffffffc0207030 <etext+0xdc2>
ffffffffc0202e12:	e38fd0ef          	jal	ffffffffc020044a <__panic>
        panic("DTB memory info not available");
ffffffffc0202e16:	00004617          	auipc	a2,0x4
ffffffffc0202e1a:	35260613          	addi	a2,a2,850 # ffffffffc0207168 <etext+0xefa>
ffffffffc0202e1e:	06500593          	li	a1,101
ffffffffc0202e22:	00004517          	auipc	a0,0x4
ffffffffc0202e26:	2d650513          	addi	a0,a0,726 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202e2a:	e20fd0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202e2e:	00004697          	auipc	a3,0x4
ffffffffc0202e32:	6da68693          	addi	a3,a3,1754 # ffffffffc0207508 <etext+0x129a>
ffffffffc0202e36:	00004617          	auipc	a2,0x4
ffffffffc0202e3a:	e2260613          	addi	a2,a2,-478 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202e3e:	26c00593          	li	a1,620
ffffffffc0202e42:	00004517          	auipc	a0,0x4
ffffffffc0202e46:	2b650513          	addi	a0,a0,694 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202e4a:	e00fd0ef          	jal	ffffffffc020044a <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202e4e:	00004697          	auipc	a3,0x4
ffffffffc0202e52:	3d268693          	addi	a3,a3,978 # ffffffffc0207220 <etext+0xfb2>
ffffffffc0202e56:	00004617          	auipc	a2,0x4
ffffffffc0202e5a:	e0260613          	addi	a2,a2,-510 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202e5e:	21300593          	li	a1,531
ffffffffc0202e62:	00004517          	auipc	a0,0x4
ffffffffc0202e66:	29650513          	addi	a0,a0,662 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202e6a:	de0fd0ef          	jal	ffffffffc020044a <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202e6e:	00004697          	auipc	a3,0x4
ffffffffc0202e72:	39268693          	addi	a3,a3,914 # ffffffffc0207200 <etext+0xf92>
ffffffffc0202e76:	00004617          	auipc	a2,0x4
ffffffffc0202e7a:	de260613          	addi	a2,a2,-542 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202e7e:	21200593          	li	a1,530
ffffffffc0202e82:	00004517          	auipc	a0,0x4
ffffffffc0202e86:	27650513          	addi	a0,a0,630 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202e8a:	dc0fd0ef          	jal	ffffffffc020044a <__panic>
    return KADDR(page2pa(page));
ffffffffc0202e8e:	00004617          	auipc	a2,0x4
ffffffffc0202e92:	17a60613          	addi	a2,a2,378 # ffffffffc0207008 <etext+0xd9a>
ffffffffc0202e96:	07100593          	li	a1,113
ffffffffc0202e9a:	00004517          	auipc	a0,0x4
ffffffffc0202e9e:	19650513          	addi	a0,a0,406 # ffffffffc0207030 <etext+0xdc2>
ffffffffc0202ea2:	da8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202ea6:	00004697          	auipc	a3,0x4
ffffffffc0202eaa:	63268693          	addi	a3,a3,1586 # ffffffffc02074d8 <etext+0x126a>
ffffffffc0202eae:	00004617          	auipc	a2,0x4
ffffffffc0202eb2:	daa60613          	addi	a2,a2,-598 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202eb6:	23a00593          	li	a1,570
ffffffffc0202eba:	00004517          	auipc	a0,0x4
ffffffffc0202ebe:	23e50513          	addi	a0,a0,574 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202ec2:	d88fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202ec6:	00004697          	auipc	a3,0x4
ffffffffc0202eca:	5ca68693          	addi	a3,a3,1482 # ffffffffc0207490 <etext+0x1222>
ffffffffc0202ece:	00004617          	auipc	a2,0x4
ffffffffc0202ed2:	d8a60613          	addi	a2,a2,-630 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202ed6:	23800593          	li	a1,568
ffffffffc0202eda:	00004517          	auipc	a0,0x4
ffffffffc0202ede:	21e50513          	addi	a0,a0,542 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202ee2:	d68fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202ee6:	00004697          	auipc	a3,0x4
ffffffffc0202eea:	5da68693          	addi	a3,a3,1498 # ffffffffc02074c0 <etext+0x1252>
ffffffffc0202eee:	00004617          	auipc	a2,0x4
ffffffffc0202ef2:	d6a60613          	addi	a2,a2,-662 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202ef6:	23700593          	li	a1,567
ffffffffc0202efa:	00004517          	auipc	a0,0x4
ffffffffc0202efe:	1fe50513          	addi	a0,a0,510 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202f02:	d48fd0ef          	jal	ffffffffc020044a <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202f06:	00004697          	auipc	a3,0x4
ffffffffc0202f0a:	6a268693          	addi	a3,a3,1698 # ffffffffc02075a8 <etext+0x133a>
ffffffffc0202f0e:	00004617          	auipc	a2,0x4
ffffffffc0202f12:	d4a60613          	addi	a2,a2,-694 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202f16:	25500593          	li	a1,597
ffffffffc0202f1a:	00004517          	auipc	a0,0x4
ffffffffc0202f1e:	1de50513          	addi	a0,a0,478 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202f22:	d28fd0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202f26:	00004697          	auipc	a3,0x4
ffffffffc0202f2a:	5e268693          	addi	a3,a3,1506 # ffffffffc0207508 <etext+0x129a>
ffffffffc0202f2e:	00004617          	auipc	a2,0x4
ffffffffc0202f32:	d2a60613          	addi	a2,a2,-726 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202f36:	24200593          	li	a1,578
ffffffffc0202f3a:	00004517          	auipc	a0,0x4
ffffffffc0202f3e:	1be50513          	addi	a0,a0,446 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202f42:	d08fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202f46:	00004697          	auipc	a3,0x4
ffffffffc0202f4a:	6ba68693          	addi	a3,a3,1722 # ffffffffc0207600 <etext+0x1392>
ffffffffc0202f4e:	00004617          	auipc	a2,0x4
ffffffffc0202f52:	d0a60613          	addi	a2,a2,-758 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202f56:	25a00593          	li	a1,602
ffffffffc0202f5a:	00004517          	auipc	a0,0x4
ffffffffc0202f5e:	19e50513          	addi	a0,a0,414 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202f62:	ce8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202f66:	00004697          	auipc	a3,0x4
ffffffffc0202f6a:	65a68693          	addi	a3,a3,1626 # ffffffffc02075c0 <etext+0x1352>
ffffffffc0202f6e:	00004617          	auipc	a2,0x4
ffffffffc0202f72:	cea60613          	addi	a2,a2,-790 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202f76:	25900593          	li	a1,601
ffffffffc0202f7a:	00004517          	auipc	a0,0x4
ffffffffc0202f7e:	17e50513          	addi	a0,a0,382 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202f82:	cc8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202f86:	00004697          	auipc	a3,0x4
ffffffffc0202f8a:	50a68693          	addi	a3,a3,1290 # ffffffffc0207490 <etext+0x1222>
ffffffffc0202f8e:	00004617          	auipc	a2,0x4
ffffffffc0202f92:	cca60613          	addi	a2,a2,-822 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202f96:	23400593          	li	a1,564
ffffffffc0202f9a:	00004517          	auipc	a0,0x4
ffffffffc0202f9e:	15e50513          	addi	a0,a0,350 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202fa2:	ca8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202fa6:	00004697          	auipc	a3,0x4
ffffffffc0202faa:	38a68693          	addi	a3,a3,906 # ffffffffc0207330 <etext+0x10c2>
ffffffffc0202fae:	00004617          	auipc	a2,0x4
ffffffffc0202fb2:	caa60613          	addi	a2,a2,-854 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202fb6:	23300593          	li	a1,563
ffffffffc0202fba:	00004517          	auipc	a0,0x4
ffffffffc0202fbe:	13e50513          	addi	a0,a0,318 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202fc2:	c88fd0ef          	jal	ffffffffc020044a <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202fc6:	00004697          	auipc	a3,0x4
ffffffffc0202fca:	4e268693          	addi	a3,a3,1250 # ffffffffc02074a8 <etext+0x123a>
ffffffffc0202fce:	00004617          	auipc	a2,0x4
ffffffffc0202fd2:	c8a60613          	addi	a2,a2,-886 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202fd6:	23000593          	li	a1,560
ffffffffc0202fda:	00004517          	auipc	a0,0x4
ffffffffc0202fde:	11e50513          	addi	a0,a0,286 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0202fe2:	c68fd0ef          	jal	ffffffffc020044a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202fe6:	00004697          	auipc	a3,0x4
ffffffffc0202fea:	33268693          	addi	a3,a3,818 # ffffffffc0207318 <etext+0x10aa>
ffffffffc0202fee:	00004617          	auipc	a2,0x4
ffffffffc0202ff2:	c6a60613          	addi	a2,a2,-918 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0202ff6:	22f00593          	li	a1,559
ffffffffc0202ffa:	00004517          	auipc	a0,0x4
ffffffffc0202ffe:	0fe50513          	addi	a0,a0,254 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0203002:	c48fd0ef          	jal	ffffffffc020044a <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203006:	00004697          	auipc	a3,0x4
ffffffffc020300a:	3b268693          	addi	a3,a3,946 # ffffffffc02073b8 <etext+0x114a>
ffffffffc020300e:	00004617          	auipc	a2,0x4
ffffffffc0203012:	c4a60613          	addi	a2,a2,-950 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203016:	22e00593          	li	a1,558
ffffffffc020301a:	00004517          	auipc	a0,0x4
ffffffffc020301e:	0de50513          	addi	a0,a0,222 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0203022:	c28fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203026:	00004697          	auipc	a3,0x4
ffffffffc020302a:	46a68693          	addi	a3,a3,1130 # ffffffffc0207490 <etext+0x1222>
ffffffffc020302e:	00004617          	auipc	a2,0x4
ffffffffc0203032:	c2a60613          	addi	a2,a2,-982 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203036:	22d00593          	li	a1,557
ffffffffc020303a:	00004517          	auipc	a0,0x4
ffffffffc020303e:	0be50513          	addi	a0,a0,190 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0203042:	c08fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0203046:	00004697          	auipc	a3,0x4
ffffffffc020304a:	43268693          	addi	a3,a3,1074 # ffffffffc0207478 <etext+0x120a>
ffffffffc020304e:	00004617          	auipc	a2,0x4
ffffffffc0203052:	c0a60613          	addi	a2,a2,-1014 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203056:	22c00593          	li	a1,556
ffffffffc020305a:	00004517          	auipc	a0,0x4
ffffffffc020305e:	09e50513          	addi	a0,a0,158 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0203062:	be8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0203066:	00004697          	auipc	a3,0x4
ffffffffc020306a:	3e268693          	addi	a3,a3,994 # ffffffffc0207448 <etext+0x11da>
ffffffffc020306e:	00004617          	auipc	a2,0x4
ffffffffc0203072:	bea60613          	addi	a2,a2,-1046 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203076:	22b00593          	li	a1,555
ffffffffc020307a:	00004517          	auipc	a0,0x4
ffffffffc020307e:	07e50513          	addi	a0,a0,126 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0203082:	bc8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0203086:	00004697          	auipc	a3,0x4
ffffffffc020308a:	3aa68693          	addi	a3,a3,938 # ffffffffc0207430 <etext+0x11c2>
ffffffffc020308e:	00004617          	auipc	a2,0x4
ffffffffc0203092:	bca60613          	addi	a2,a2,-1078 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203096:	22900593          	li	a1,553
ffffffffc020309a:	00004517          	auipc	a0,0x4
ffffffffc020309e:	05e50513          	addi	a0,a0,94 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc02030a2:	ba8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02030a6:	00004697          	auipc	a3,0x4
ffffffffc02030aa:	36a68693          	addi	a3,a3,874 # ffffffffc0207410 <etext+0x11a2>
ffffffffc02030ae:	00004617          	auipc	a2,0x4
ffffffffc02030b2:	baa60613          	addi	a2,a2,-1110 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02030b6:	22800593          	li	a1,552
ffffffffc02030ba:	00004517          	auipc	a0,0x4
ffffffffc02030be:	03e50513          	addi	a0,a0,62 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc02030c2:	b88fd0ef          	jal	ffffffffc020044a <__panic>
    assert(*ptep & PTE_W);
ffffffffc02030c6:	00004697          	auipc	a3,0x4
ffffffffc02030ca:	33a68693          	addi	a3,a3,826 # ffffffffc0207400 <etext+0x1192>
ffffffffc02030ce:	00004617          	auipc	a2,0x4
ffffffffc02030d2:	b8a60613          	addi	a2,a2,-1142 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02030d6:	22700593          	li	a1,551
ffffffffc02030da:	00004517          	auipc	a0,0x4
ffffffffc02030de:	01e50513          	addi	a0,a0,30 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc02030e2:	b68fd0ef          	jal	ffffffffc020044a <__panic>
    assert(*ptep & PTE_U);
ffffffffc02030e6:	00004697          	auipc	a3,0x4
ffffffffc02030ea:	30a68693          	addi	a3,a3,778 # ffffffffc02073f0 <etext+0x1182>
ffffffffc02030ee:	00004617          	auipc	a2,0x4
ffffffffc02030f2:	b6a60613          	addi	a2,a2,-1174 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02030f6:	22600593          	li	a1,550
ffffffffc02030fa:	00004517          	auipc	a0,0x4
ffffffffc02030fe:	ffe50513          	addi	a0,a0,-2 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0203102:	b48fd0ef          	jal	ffffffffc020044a <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203106:	00004617          	auipc	a2,0x4
ffffffffc020310a:	faa60613          	addi	a2,a2,-86 # ffffffffc02070b0 <etext+0xe42>
ffffffffc020310e:	08100593          	li	a1,129
ffffffffc0203112:	00004517          	auipc	a0,0x4
ffffffffc0203116:	fe650513          	addi	a0,a0,-26 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc020311a:	b30fd0ef          	jal	ffffffffc020044a <__panic>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020311e:	00004697          	auipc	a3,0x4
ffffffffc0203122:	22a68693          	addi	a3,a3,554 # ffffffffc0207348 <etext+0x10da>
ffffffffc0203126:	00004617          	auipc	a2,0x4
ffffffffc020312a:	b3260613          	addi	a2,a2,-1230 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc020312e:	22100593          	li	a1,545
ffffffffc0203132:	00004517          	auipc	a0,0x4
ffffffffc0203136:	fc650513          	addi	a0,a0,-58 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc020313a:	b10fd0ef          	jal	ffffffffc020044a <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020313e:	00004697          	auipc	a3,0x4
ffffffffc0203142:	27a68693          	addi	a3,a3,634 # ffffffffc02073b8 <etext+0x114a>
ffffffffc0203146:	00004617          	auipc	a2,0x4
ffffffffc020314a:	b1260613          	addi	a2,a2,-1262 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc020314e:	22500593          	li	a1,549
ffffffffc0203152:	00004517          	auipc	a0,0x4
ffffffffc0203156:	fa650513          	addi	a0,a0,-90 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc020315a:	af0fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020315e:	00004697          	auipc	a3,0x4
ffffffffc0203162:	21a68693          	addi	a3,a3,538 # ffffffffc0207378 <etext+0x110a>
ffffffffc0203166:	00004617          	auipc	a2,0x4
ffffffffc020316a:	af260613          	addi	a2,a2,-1294 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc020316e:	22400593          	li	a1,548
ffffffffc0203172:	00004517          	auipc	a0,0x4
ffffffffc0203176:	f8650513          	addi	a0,a0,-122 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc020317a:	ad0fd0ef          	jal	ffffffffc020044a <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020317e:	86d6                	mv	a3,s5
ffffffffc0203180:	00004617          	auipc	a2,0x4
ffffffffc0203184:	e8860613          	addi	a2,a2,-376 # ffffffffc0207008 <etext+0xd9a>
ffffffffc0203188:	22000593          	li	a1,544
ffffffffc020318c:	00004517          	auipc	a0,0x4
ffffffffc0203190:	f6c50513          	addi	a0,a0,-148 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0203194:	ab6fd0ef          	jal	ffffffffc020044a <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0203198:	00004617          	auipc	a2,0x4
ffffffffc020319c:	e7060613          	addi	a2,a2,-400 # ffffffffc0207008 <etext+0xd9a>
ffffffffc02031a0:	21f00593          	li	a1,543
ffffffffc02031a4:	00004517          	auipc	a0,0x4
ffffffffc02031a8:	f5450513          	addi	a0,a0,-172 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc02031ac:	a9efd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02031b0:	00004697          	auipc	a3,0x4
ffffffffc02031b4:	18068693          	addi	a3,a3,384 # ffffffffc0207330 <etext+0x10c2>
ffffffffc02031b8:	00004617          	auipc	a2,0x4
ffffffffc02031bc:	aa060613          	addi	a2,a2,-1376 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02031c0:	21d00593          	li	a1,541
ffffffffc02031c4:	00004517          	auipc	a0,0x4
ffffffffc02031c8:	f3450513          	addi	a0,a0,-204 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc02031cc:	a7efd0ef          	jal	ffffffffc020044a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02031d0:	00004697          	auipc	a3,0x4
ffffffffc02031d4:	14868693          	addi	a3,a3,328 # ffffffffc0207318 <etext+0x10aa>
ffffffffc02031d8:	00004617          	auipc	a2,0x4
ffffffffc02031dc:	a8060613          	addi	a2,a2,-1408 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02031e0:	21c00593          	li	a1,540
ffffffffc02031e4:	00004517          	auipc	a0,0x4
ffffffffc02031e8:	f1450513          	addi	a0,a0,-236 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc02031ec:	a5efd0ef          	jal	ffffffffc020044a <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02031f0:	00004697          	auipc	a3,0x4
ffffffffc02031f4:	4d868693          	addi	a3,a3,1240 # ffffffffc02076c8 <etext+0x145a>
ffffffffc02031f8:	00004617          	auipc	a2,0x4
ffffffffc02031fc:	a6060613          	addi	a2,a2,-1440 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203200:	26300593          	li	a1,611
ffffffffc0203204:	00004517          	auipc	a0,0x4
ffffffffc0203208:	ef450513          	addi	a0,a0,-268 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc020320c:	a3efd0ef          	jal	ffffffffc020044a <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203210:	00004697          	auipc	a3,0x4
ffffffffc0203214:	48068693          	addi	a3,a3,1152 # ffffffffc0207690 <etext+0x1422>
ffffffffc0203218:	00004617          	auipc	a2,0x4
ffffffffc020321c:	a4060613          	addi	a2,a2,-1472 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203220:	26000593          	li	a1,608
ffffffffc0203224:	00004517          	auipc	a0,0x4
ffffffffc0203228:	ed450513          	addi	a0,a0,-300 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc020322c:	a1efd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203230:	00004697          	auipc	a3,0x4
ffffffffc0203234:	43068693          	addi	a3,a3,1072 # ffffffffc0207660 <etext+0x13f2>
ffffffffc0203238:	00004617          	auipc	a2,0x4
ffffffffc020323c:	a2060613          	addi	a2,a2,-1504 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203240:	25c00593          	li	a1,604
ffffffffc0203244:	00004517          	auipc	a0,0x4
ffffffffc0203248:	eb450513          	addi	a0,a0,-332 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc020324c:	9fefd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203250:	00004697          	auipc	a3,0x4
ffffffffc0203254:	3c868693          	addi	a3,a3,968 # ffffffffc0207618 <etext+0x13aa>
ffffffffc0203258:	00004617          	auipc	a2,0x4
ffffffffc020325c:	a0060613          	addi	a2,a2,-1536 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203260:	25b00593          	li	a1,603
ffffffffc0203264:	00004517          	auipc	a0,0x4
ffffffffc0203268:	e9450513          	addi	a0,a0,-364 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc020326c:	9defd0ef          	jal	ffffffffc020044a <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0203270:	00004697          	auipc	a3,0x4
ffffffffc0203274:	ff068693          	addi	a3,a3,-16 # ffffffffc0207260 <etext+0xff2>
ffffffffc0203278:	00004617          	auipc	a2,0x4
ffffffffc020327c:	9e060613          	addi	a2,a2,-1568 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203280:	21400593          	li	a1,532
ffffffffc0203284:	00004517          	auipc	a0,0x4
ffffffffc0203288:	e7450513          	addi	a0,a0,-396 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc020328c:	9befd0ef          	jal	ffffffffc020044a <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0203290:	00004617          	auipc	a2,0x4
ffffffffc0203294:	e2060613          	addi	a2,a2,-480 # ffffffffc02070b0 <etext+0xe42>
ffffffffc0203298:	0c900593          	li	a1,201
ffffffffc020329c:	00004517          	auipc	a0,0x4
ffffffffc02032a0:	e5c50513          	addi	a0,a0,-420 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc02032a4:	9a6fd0ef          	jal	ffffffffc020044a <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02032a8:	00004697          	auipc	a3,0x4
ffffffffc02032ac:	01868693          	addi	a3,a3,24 # ffffffffc02072c0 <etext+0x1052>
ffffffffc02032b0:	00004617          	auipc	a2,0x4
ffffffffc02032b4:	9a860613          	addi	a2,a2,-1624 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02032b8:	21b00593          	li	a1,539
ffffffffc02032bc:	00004517          	auipc	a0,0x4
ffffffffc02032c0:	e3c50513          	addi	a0,a0,-452 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc02032c4:	986fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02032c8:	00004697          	auipc	a3,0x4
ffffffffc02032cc:	fc868693          	addi	a3,a3,-56 # ffffffffc0207290 <etext+0x1022>
ffffffffc02032d0:	00004617          	auipc	a2,0x4
ffffffffc02032d4:	98860613          	addi	a2,a2,-1656 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02032d8:	21800593          	li	a1,536
ffffffffc02032dc:	00004517          	auipc	a0,0x4
ffffffffc02032e0:	e1c50513          	addi	a0,a0,-484 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc02032e4:	966fd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02032e8 <copy_range>:
{
ffffffffc02032e8:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02032ea:	00d667b3          	or	a5,a2,a3
{
ffffffffc02032ee:	f486                	sd	ra,104(sp)
ffffffffc02032f0:	f0a2                	sd	s0,96(sp)
ffffffffc02032f2:	eca6                	sd	s1,88(sp)
ffffffffc02032f4:	e8ca                	sd	s2,80(sp)
ffffffffc02032f6:	e4ce                	sd	s3,72(sp)
ffffffffc02032f8:	e0d2                	sd	s4,64(sp)
ffffffffc02032fa:	fc56                	sd	s5,56(sp)
ffffffffc02032fc:	f85a                	sd	s6,48(sp)
ffffffffc02032fe:	f45e                	sd	s7,40(sp)
ffffffffc0203300:	f062                	sd	s8,32(sp)
ffffffffc0203302:	ec66                	sd	s9,24(sp)
ffffffffc0203304:	e86a                	sd	s10,16(sp)
ffffffffc0203306:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203308:	03479713          	slli	a4,a5,0x34
ffffffffc020330c:	20071f63          	bnez	a4,ffffffffc020352a <copy_range+0x242>
    assert(USER_ACCESS(start, end));
ffffffffc0203310:	002007b7          	lui	a5,0x200
ffffffffc0203314:	00d63733          	sltu	a4,a2,a3
ffffffffc0203318:	00f637b3          	sltu	a5,a2,a5
ffffffffc020331c:	00173713          	seqz	a4,a4
ffffffffc0203320:	8fd9                	or	a5,a5,a4
ffffffffc0203322:	8432                	mv	s0,a2
ffffffffc0203324:	8936                	mv	s2,a3
ffffffffc0203326:	1e079263          	bnez	a5,ffffffffc020350a <copy_range+0x222>
ffffffffc020332a:	4785                	li	a5,1
ffffffffc020332c:	07fe                	slli	a5,a5,0x1f
ffffffffc020332e:	0785                	addi	a5,a5,1 # 200001 <_binary_obj___user_matrix_out_size+0x1f4ad1>
ffffffffc0203330:	1cf6fd63          	bgeu	a3,a5,ffffffffc020350a <copy_range+0x222>
ffffffffc0203334:	5b7d                	li	s6,-1
ffffffffc0203336:	8baa                	mv	s7,a0
ffffffffc0203338:	8a2e                	mv	s4,a1
ffffffffc020333a:	6a85                	lui	s5,0x1
ffffffffc020333c:	00cb5b13          	srli	s6,s6,0xc
    if (PPN(pa) >= npage)
ffffffffc0203340:	000b2c97          	auipc	s9,0xb2
ffffffffc0203344:	2f0c8c93          	addi	s9,s9,752 # ffffffffc02b5630 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0203348:	000b2c17          	auipc	s8,0xb2
ffffffffc020334c:	2f0c0c13          	addi	s8,s8,752 # ffffffffc02b5638 <pages>
ffffffffc0203350:	fff80d37          	lui	s10,0xfff80
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc0203354:	4601                	li	a2,0
ffffffffc0203356:	85a2                	mv	a1,s0
ffffffffc0203358:	8552                	mv	a0,s4
ffffffffc020335a:	b19fe0ef          	jal	ffffffffc0201e72 <get_pte>
ffffffffc020335e:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc0203360:	0e050a63          	beqz	a0,ffffffffc0203454 <copy_range+0x16c>
        if (*ptep & PTE_V)
ffffffffc0203364:	611c                	ld	a5,0(a0)
ffffffffc0203366:	8b85                	andi	a5,a5,1
ffffffffc0203368:	e78d                	bnez	a5,ffffffffc0203392 <copy_range+0xaa>
        start += PGSIZE;
ffffffffc020336a:	9456                	add	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc020336c:	c019                	beqz	s0,ffffffffc0203372 <copy_range+0x8a>
ffffffffc020336e:	ff2463e3          	bltu	s0,s2,ffffffffc0203354 <copy_range+0x6c>
    return 0;
ffffffffc0203372:	4501                	li	a0,0
}
ffffffffc0203374:	70a6                	ld	ra,104(sp)
ffffffffc0203376:	7406                	ld	s0,96(sp)
ffffffffc0203378:	64e6                	ld	s1,88(sp)
ffffffffc020337a:	6946                	ld	s2,80(sp)
ffffffffc020337c:	69a6                	ld	s3,72(sp)
ffffffffc020337e:	6a06                	ld	s4,64(sp)
ffffffffc0203380:	7ae2                	ld	s5,56(sp)
ffffffffc0203382:	7b42                	ld	s6,48(sp)
ffffffffc0203384:	7ba2                	ld	s7,40(sp)
ffffffffc0203386:	7c02                	ld	s8,32(sp)
ffffffffc0203388:	6ce2                	ld	s9,24(sp)
ffffffffc020338a:	6d42                	ld	s10,16(sp)
ffffffffc020338c:	6da2                	ld	s11,8(sp)
ffffffffc020338e:	6165                	addi	sp,sp,112
ffffffffc0203390:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc0203392:	4605                	li	a2,1
ffffffffc0203394:	85a2                	mv	a1,s0
ffffffffc0203396:	855e                	mv	a0,s7
ffffffffc0203398:	adbfe0ef          	jal	ffffffffc0201e72 <get_pte>
ffffffffc020339c:	c165                	beqz	a0,ffffffffc020347c <copy_range+0x194>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc020339e:	0004b983          	ld	s3,0(s1)
    if (!(pte & PTE_V))
ffffffffc02033a2:	0019f793          	andi	a5,s3,1
ffffffffc02033a6:	14078663          	beqz	a5,ffffffffc02034f2 <copy_range+0x20a>
    if (PPN(pa) >= npage)
ffffffffc02033aa:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc02033ae:	00299793          	slli	a5,s3,0x2
ffffffffc02033b2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02033b4:	12e7f363          	bgeu	a5,a4,ffffffffc02034da <copy_range+0x1f2>
    return &pages[PPN(pa) - nbase];
ffffffffc02033b8:	000c3483          	ld	s1,0(s8)
ffffffffc02033bc:	97ea                	add	a5,a5,s10
ffffffffc02033be:	079a                	slli	a5,a5,0x6
ffffffffc02033c0:	94be                	add	s1,s1,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02033c2:	100027f3          	csrr	a5,sstatus
ffffffffc02033c6:	8b89                	andi	a5,a5,2
ffffffffc02033c8:	efc9                	bnez	a5,ffffffffc0203462 <copy_range+0x17a>
        page = pmm_manager->alloc_pages(n);
ffffffffc02033ca:	000b2797          	auipc	a5,0xb2
ffffffffc02033ce:	2467b783          	ld	a5,582(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc02033d2:	4505                	li	a0,1
ffffffffc02033d4:	6f9c                	ld	a5,24(a5)
ffffffffc02033d6:	9782                	jalr	a5
ffffffffc02033d8:	8daa                	mv	s11,a0
            assert(page != NULL);
ffffffffc02033da:	c0e5                	beqz	s1,ffffffffc02034ba <copy_range+0x1d2>
            assert(npage != NULL);
ffffffffc02033dc:	0a0d8f63          	beqz	s11,ffffffffc020349a <copy_range+0x1b2>
    return page - pages + nbase;
ffffffffc02033e0:	000c3783          	ld	a5,0(s8)
ffffffffc02033e4:	00080637          	lui	a2,0x80
    return KADDR(page2pa(page));
ffffffffc02033e8:	000cb703          	ld	a4,0(s9)
    return page - pages + nbase;
ffffffffc02033ec:	40f486b3          	sub	a3,s1,a5
ffffffffc02033f0:	8699                	srai	a3,a3,0x6
ffffffffc02033f2:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02033f4:	0166f5b3          	and	a1,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc02033f8:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02033fa:	08e5f463          	bgeu	a1,a4,ffffffffc0203482 <copy_range+0x19a>
    return page - pages + nbase;
ffffffffc02033fe:	40fd87b3          	sub	a5,s11,a5
ffffffffc0203402:	8799                	srai	a5,a5,0x6
ffffffffc0203404:	97b2                	add	a5,a5,a2
    return KADDR(page2pa(page));
ffffffffc0203406:	0167f633          	and	a2,a5,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc020340a:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc020340c:	06e67a63          	bgeu	a2,a4,ffffffffc0203480 <copy_range+0x198>
ffffffffc0203410:	000b2517          	auipc	a0,0xb2
ffffffffc0203414:	21853503          	ld	a0,536(a0) # ffffffffc02b5628 <va_pa_offset>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc0203418:	6605                	lui	a2,0x1
ffffffffc020341a:	00a685b3          	add	a1,a3,a0
ffffffffc020341e:	953e                	add	a0,a0,a5
ffffffffc0203420:	637020ef          	jal	ffffffffc0206256 <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc0203424:	01f9f693          	andi	a3,s3,31
ffffffffc0203428:	85ee                	mv	a1,s11
ffffffffc020342a:	8622                	mv	a2,s0
ffffffffc020342c:	855e                	mv	a0,s7
ffffffffc020342e:	97aff0ef          	jal	ffffffffc02025a8 <page_insert>
            assert(ret == 0);
ffffffffc0203432:	dd05                	beqz	a0,ffffffffc020336a <copy_range+0x82>
ffffffffc0203434:	00004697          	auipc	a3,0x4
ffffffffc0203438:	2fc68693          	addi	a3,a3,764 # ffffffffc0207730 <etext+0x14c2>
ffffffffc020343c:	00004617          	auipc	a2,0x4
ffffffffc0203440:	81c60613          	addi	a2,a2,-2020 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203444:	1b000593          	li	a1,432
ffffffffc0203448:	00004517          	auipc	a0,0x4
ffffffffc020344c:	cb050513          	addi	a0,a0,-848 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0203450:	ffbfc0ef          	jal	ffffffffc020044a <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0203454:	002007b7          	lui	a5,0x200
ffffffffc0203458:	97a2                	add	a5,a5,s0
ffffffffc020345a:	ffe00437          	lui	s0,0xffe00
ffffffffc020345e:	8c7d                	and	s0,s0,a5
            continue;
ffffffffc0203460:	b731                	j	ffffffffc020336c <copy_range+0x84>
        intr_disable();
ffffffffc0203462:	ca8fd0ef          	jal	ffffffffc020090a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203466:	000b2797          	auipc	a5,0xb2
ffffffffc020346a:	1aa7b783          	ld	a5,426(a5) # ffffffffc02b5610 <pmm_manager>
ffffffffc020346e:	4505                	li	a0,1
ffffffffc0203470:	6f9c                	ld	a5,24(a5)
ffffffffc0203472:	9782                	jalr	a5
ffffffffc0203474:	8daa                	mv	s11,a0
        intr_enable();
ffffffffc0203476:	c8efd0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc020347a:	b785                	j	ffffffffc02033da <copy_range+0xf2>
                return -E_NO_MEM;
ffffffffc020347c:	5571                	li	a0,-4
ffffffffc020347e:	bddd                	j	ffffffffc0203374 <copy_range+0x8c>
ffffffffc0203480:	86be                	mv	a3,a5
ffffffffc0203482:	00004617          	auipc	a2,0x4
ffffffffc0203486:	b8660613          	addi	a2,a2,-1146 # ffffffffc0207008 <etext+0xd9a>
ffffffffc020348a:	07100593          	li	a1,113
ffffffffc020348e:	00004517          	auipc	a0,0x4
ffffffffc0203492:	ba250513          	addi	a0,a0,-1118 # ffffffffc0207030 <etext+0xdc2>
ffffffffc0203496:	fb5fc0ef          	jal	ffffffffc020044a <__panic>
            assert(npage != NULL);
ffffffffc020349a:	00004697          	auipc	a3,0x4
ffffffffc020349e:	28668693          	addi	a3,a3,646 # ffffffffc0207720 <etext+0x14b2>
ffffffffc02034a2:	00003617          	auipc	a2,0x3
ffffffffc02034a6:	7b660613          	addi	a2,a2,1974 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02034aa:	19700593          	li	a1,407
ffffffffc02034ae:	00004517          	auipc	a0,0x4
ffffffffc02034b2:	c4a50513          	addi	a0,a0,-950 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc02034b6:	f95fc0ef          	jal	ffffffffc020044a <__panic>
            assert(page != NULL);
ffffffffc02034ba:	00004697          	auipc	a3,0x4
ffffffffc02034be:	25668693          	addi	a3,a3,598 # ffffffffc0207710 <etext+0x14a2>
ffffffffc02034c2:	00003617          	auipc	a2,0x3
ffffffffc02034c6:	79660613          	addi	a2,a2,1942 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02034ca:	19600593          	li	a1,406
ffffffffc02034ce:	00004517          	auipc	a0,0x4
ffffffffc02034d2:	c2a50513          	addi	a0,a0,-982 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc02034d6:	f75fc0ef          	jal	ffffffffc020044a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02034da:	00004617          	auipc	a2,0x4
ffffffffc02034de:	bfe60613          	addi	a2,a2,-1026 # ffffffffc02070d8 <etext+0xe6a>
ffffffffc02034e2:	06900593          	li	a1,105
ffffffffc02034e6:	00004517          	auipc	a0,0x4
ffffffffc02034ea:	b4a50513          	addi	a0,a0,-1206 # ffffffffc0207030 <etext+0xdc2>
ffffffffc02034ee:	f5dfc0ef          	jal	ffffffffc020044a <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02034f2:	00004617          	auipc	a2,0x4
ffffffffc02034f6:	dfe60613          	addi	a2,a2,-514 # ffffffffc02072f0 <etext+0x1082>
ffffffffc02034fa:	07f00593          	li	a1,127
ffffffffc02034fe:	00004517          	auipc	a0,0x4
ffffffffc0203502:	b3250513          	addi	a0,a0,-1230 # ffffffffc0207030 <etext+0xdc2>
ffffffffc0203506:	f45fc0ef          	jal	ffffffffc020044a <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020350a:	00004697          	auipc	a3,0x4
ffffffffc020350e:	c2e68693          	addi	a3,a3,-978 # ffffffffc0207138 <etext+0xeca>
ffffffffc0203512:	00003617          	auipc	a2,0x3
ffffffffc0203516:	74660613          	addi	a2,a2,1862 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc020351a:	17e00593          	li	a1,382
ffffffffc020351e:	00004517          	auipc	a0,0x4
ffffffffc0203522:	bda50513          	addi	a0,a0,-1062 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0203526:	f25fc0ef          	jal	ffffffffc020044a <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020352a:	00004697          	auipc	a3,0x4
ffffffffc020352e:	bde68693          	addi	a3,a3,-1058 # ffffffffc0207108 <etext+0xe9a>
ffffffffc0203532:	00003617          	auipc	a2,0x3
ffffffffc0203536:	72660613          	addi	a2,a2,1830 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc020353a:	17d00593          	li	a1,381
ffffffffc020353e:	00004517          	auipc	a0,0x4
ffffffffc0203542:	bba50513          	addi	a0,a0,-1094 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc0203546:	f05fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020354a <pgdir_alloc_page>:
{
ffffffffc020354a:	7139                	addi	sp,sp,-64
ffffffffc020354c:	f426                	sd	s1,40(sp)
ffffffffc020354e:	f04a                	sd	s2,32(sp)
ffffffffc0203550:	ec4e                	sd	s3,24(sp)
ffffffffc0203552:	fc06                	sd	ra,56(sp)
ffffffffc0203554:	f822                	sd	s0,48(sp)
ffffffffc0203556:	892a                	mv	s2,a0
ffffffffc0203558:	84ae                	mv	s1,a1
ffffffffc020355a:	89b2                	mv	s3,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020355c:	100027f3          	csrr	a5,sstatus
ffffffffc0203560:	8b89                	andi	a5,a5,2
ffffffffc0203562:	ebb5                	bnez	a5,ffffffffc02035d6 <pgdir_alloc_page+0x8c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203564:	000b2417          	auipc	s0,0xb2
ffffffffc0203568:	0ac40413          	addi	s0,s0,172 # ffffffffc02b5610 <pmm_manager>
ffffffffc020356c:	601c                	ld	a5,0(s0)
ffffffffc020356e:	4505                	li	a0,1
ffffffffc0203570:	6f9c                	ld	a5,24(a5)
ffffffffc0203572:	9782                	jalr	a5
ffffffffc0203574:	85aa                	mv	a1,a0
    if (page != NULL)
ffffffffc0203576:	c5b9                	beqz	a1,ffffffffc02035c4 <pgdir_alloc_page+0x7a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc0203578:	86ce                	mv	a3,s3
ffffffffc020357a:	854a                	mv	a0,s2
ffffffffc020357c:	8626                	mv	a2,s1
ffffffffc020357e:	e42e                	sd	a1,8(sp)
ffffffffc0203580:	828ff0ef          	jal	ffffffffc02025a8 <page_insert>
ffffffffc0203584:	65a2                	ld	a1,8(sp)
ffffffffc0203586:	e515                	bnez	a0,ffffffffc02035b2 <pgdir_alloc_page+0x68>
        assert(page_ref(page) == 1);
ffffffffc0203588:	4198                	lw	a4,0(a1)
        page->pra_vaddr = la;
ffffffffc020358a:	fd84                	sd	s1,56(a1)
        assert(page_ref(page) == 1);
ffffffffc020358c:	4785                	li	a5,1
ffffffffc020358e:	02f70c63          	beq	a4,a5,ffffffffc02035c6 <pgdir_alloc_page+0x7c>
ffffffffc0203592:	00004697          	auipc	a3,0x4
ffffffffc0203596:	1ae68693          	addi	a3,a3,430 # ffffffffc0207740 <etext+0x14d2>
ffffffffc020359a:	00003617          	auipc	a2,0x3
ffffffffc020359e:	6be60613          	addi	a2,a2,1726 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02035a2:	1f900593          	li	a1,505
ffffffffc02035a6:	00004517          	auipc	a0,0x4
ffffffffc02035aa:	b5250513          	addi	a0,a0,-1198 # ffffffffc02070f8 <etext+0xe8a>
ffffffffc02035ae:	e9dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035b2:	100027f3          	csrr	a5,sstatus
ffffffffc02035b6:	8b89                	andi	a5,a5,2
ffffffffc02035b8:	ef95                	bnez	a5,ffffffffc02035f4 <pgdir_alloc_page+0xaa>
        pmm_manager->free_pages(base, n);
ffffffffc02035ba:	601c                	ld	a5,0(s0)
ffffffffc02035bc:	852e                	mv	a0,a1
ffffffffc02035be:	4585                	li	a1,1
ffffffffc02035c0:	739c                	ld	a5,32(a5)
ffffffffc02035c2:	9782                	jalr	a5
            return NULL;
ffffffffc02035c4:	4581                	li	a1,0
}
ffffffffc02035c6:	70e2                	ld	ra,56(sp)
ffffffffc02035c8:	7442                	ld	s0,48(sp)
ffffffffc02035ca:	74a2                	ld	s1,40(sp)
ffffffffc02035cc:	7902                	ld	s2,32(sp)
ffffffffc02035ce:	69e2                	ld	s3,24(sp)
ffffffffc02035d0:	852e                	mv	a0,a1
ffffffffc02035d2:	6121                	addi	sp,sp,64
ffffffffc02035d4:	8082                	ret
        intr_disable();
ffffffffc02035d6:	b34fd0ef          	jal	ffffffffc020090a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02035da:	000b2417          	auipc	s0,0xb2
ffffffffc02035de:	03640413          	addi	s0,s0,54 # ffffffffc02b5610 <pmm_manager>
ffffffffc02035e2:	601c                	ld	a5,0(s0)
ffffffffc02035e4:	4505                	li	a0,1
ffffffffc02035e6:	6f9c                	ld	a5,24(a5)
ffffffffc02035e8:	9782                	jalr	a5
ffffffffc02035ea:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02035ec:	b18fd0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc02035f0:	65a2                	ld	a1,8(sp)
ffffffffc02035f2:	b751                	j	ffffffffc0203576 <pgdir_alloc_page+0x2c>
        intr_disable();
ffffffffc02035f4:	b16fd0ef          	jal	ffffffffc020090a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02035f8:	601c                	ld	a5,0(s0)
ffffffffc02035fa:	6522                	ld	a0,8(sp)
ffffffffc02035fc:	4585                	li	a1,1
ffffffffc02035fe:	739c                	ld	a5,32(a5)
ffffffffc0203600:	9782                	jalr	a5
        intr_enable();
ffffffffc0203602:	b02fd0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0203606:	bf7d                	j	ffffffffc02035c4 <pgdir_alloc_page+0x7a>

ffffffffc0203608 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203608:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc020360a:	00004697          	auipc	a3,0x4
ffffffffc020360e:	14e68693          	addi	a3,a3,334 # ffffffffc0207758 <etext+0x14ea>
ffffffffc0203612:	00003617          	auipc	a2,0x3
ffffffffc0203616:	64660613          	addi	a2,a2,1606 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc020361a:	07400593          	li	a1,116
ffffffffc020361e:	00004517          	auipc	a0,0x4
ffffffffc0203622:	15a50513          	addi	a0,a0,346 # ffffffffc0207778 <etext+0x150a>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203626:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0203628:	e23fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020362c <mm_create>:
{
ffffffffc020362c:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc020362e:	04000513          	li	a0,64
{
ffffffffc0203632:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203634:	dd4fe0ef          	jal	ffffffffc0201c08 <kmalloc>
    if (mm != NULL)
ffffffffc0203638:	cd19                	beqz	a0,ffffffffc0203656 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc020363a:	e508                	sd	a0,8(a0)
ffffffffc020363c:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc020363e:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203642:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203646:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc020364a:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc020364e:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc0203652:	02053c23          	sd	zero,56(a0)
}
ffffffffc0203656:	60a2                	ld	ra,8(sp)
ffffffffc0203658:	0141                	addi	sp,sp,16
ffffffffc020365a:	8082                	ret

ffffffffc020365c <find_vma>:
    if (mm != NULL)
ffffffffc020365c:	c505                	beqz	a0,ffffffffc0203684 <find_vma+0x28>
        vma = mm->mmap_cache;
ffffffffc020365e:	691c                	ld	a5,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203660:	c781                	beqz	a5,ffffffffc0203668 <find_vma+0xc>
ffffffffc0203662:	6798                	ld	a4,8(a5)
ffffffffc0203664:	02e5f363          	bgeu	a1,a4,ffffffffc020368a <find_vma+0x2e>
    return listelm->next;
ffffffffc0203668:	651c                	ld	a5,8(a0)
            while ((le = list_next(le)) != list)
ffffffffc020366a:	00f50d63          	beq	a0,a5,ffffffffc0203684 <find_vma+0x28>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc020366e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203672:	00e5e663          	bltu	a1,a4,ffffffffc020367e <find_vma+0x22>
ffffffffc0203676:	ff07b703          	ld	a4,-16(a5)
ffffffffc020367a:	00e5ee63          	bltu	a1,a4,ffffffffc0203696 <find_vma+0x3a>
ffffffffc020367e:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0203680:	fef517e3          	bne	a0,a5,ffffffffc020366e <find_vma+0x12>
    struct vma_struct *vma = NULL;
ffffffffc0203684:	4781                	li	a5,0
}
ffffffffc0203686:	853e                	mv	a0,a5
ffffffffc0203688:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc020368a:	6b98                	ld	a4,16(a5)
ffffffffc020368c:	fce5fee3          	bgeu	a1,a4,ffffffffc0203668 <find_vma+0xc>
            mm->mmap_cache = vma;
ffffffffc0203690:	e91c                	sd	a5,16(a0)
}
ffffffffc0203692:	853e                	mv	a0,a5
ffffffffc0203694:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0203696:	1781                	addi	a5,a5,-32
            mm->mmap_cache = vma;
ffffffffc0203698:	e91c                	sd	a5,16(a0)
ffffffffc020369a:	bfe5                	j	ffffffffc0203692 <find_vma+0x36>

ffffffffc020369c <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc020369c:	6590                	ld	a2,8(a1)
ffffffffc020369e:	0105b803          	ld	a6,16(a1)
{
ffffffffc02036a2:	1141                	addi	sp,sp,-16
ffffffffc02036a4:	e406                	sd	ra,8(sp)
ffffffffc02036a6:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc02036a8:	01066763          	bltu	a2,a6,ffffffffc02036b6 <insert_vma_struct+0x1a>
ffffffffc02036ac:	a8b9                	j	ffffffffc020370a <insert_vma_struct+0x6e>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc02036ae:	fe87b703          	ld	a4,-24(a5)
ffffffffc02036b2:	04e66763          	bltu	a2,a4,ffffffffc0203700 <insert_vma_struct+0x64>
ffffffffc02036b6:	86be                	mv	a3,a5
ffffffffc02036b8:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc02036ba:	fef51ae3          	bne	a0,a5,ffffffffc02036ae <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc02036be:	02a68463          	beq	a3,a0,ffffffffc02036e6 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc02036c2:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc02036c6:	fe86b883          	ld	a7,-24(a3)
ffffffffc02036ca:	08e8f063          	bgeu	a7,a4,ffffffffc020374a <insert_vma_struct+0xae>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02036ce:	04e66e63          	bltu	a2,a4,ffffffffc020372a <insert_vma_struct+0x8e>
    }
    if (le_next != list)
ffffffffc02036d2:	00f50a63          	beq	a0,a5,ffffffffc02036e6 <insert_vma_struct+0x4a>
ffffffffc02036d6:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc02036da:	05076863          	bltu	a4,a6,ffffffffc020372a <insert_vma_struct+0x8e>
    assert(next->vm_start < next->vm_end);
ffffffffc02036de:	ff07b603          	ld	a2,-16(a5)
ffffffffc02036e2:	02c77263          	bgeu	a4,a2,ffffffffc0203706 <insert_vma_struct+0x6a>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc02036e6:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc02036e8:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc02036ea:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc02036ee:	e390                	sd	a2,0(a5)
ffffffffc02036f0:	e690                	sd	a2,8(a3)
}
ffffffffc02036f2:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc02036f4:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc02036f6:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc02036f8:	2705                	addiw	a4,a4,1
ffffffffc02036fa:	d118                	sw	a4,32(a0)
}
ffffffffc02036fc:	0141                	addi	sp,sp,16
ffffffffc02036fe:	8082                	ret
    if (le_prev != list)
ffffffffc0203700:	fca691e3          	bne	a3,a0,ffffffffc02036c2 <insert_vma_struct+0x26>
ffffffffc0203704:	bfd9                	j	ffffffffc02036da <insert_vma_struct+0x3e>
ffffffffc0203706:	f03ff0ef          	jal	ffffffffc0203608 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc020370a:	00004697          	auipc	a3,0x4
ffffffffc020370e:	07e68693          	addi	a3,a3,126 # ffffffffc0207788 <etext+0x151a>
ffffffffc0203712:	00003617          	auipc	a2,0x3
ffffffffc0203716:	54660613          	addi	a2,a2,1350 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc020371a:	07a00593          	li	a1,122
ffffffffc020371e:	00004517          	auipc	a0,0x4
ffffffffc0203722:	05a50513          	addi	a0,a0,90 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203726:	d25fc0ef          	jal	ffffffffc020044a <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020372a:	00004697          	auipc	a3,0x4
ffffffffc020372e:	09e68693          	addi	a3,a3,158 # ffffffffc02077c8 <etext+0x155a>
ffffffffc0203732:	00003617          	auipc	a2,0x3
ffffffffc0203736:	52660613          	addi	a2,a2,1318 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc020373a:	07300593          	li	a1,115
ffffffffc020373e:	00004517          	auipc	a0,0x4
ffffffffc0203742:	03a50513          	addi	a0,a0,58 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203746:	d05fc0ef          	jal	ffffffffc020044a <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc020374a:	00004697          	auipc	a3,0x4
ffffffffc020374e:	05e68693          	addi	a3,a3,94 # ffffffffc02077a8 <etext+0x153a>
ffffffffc0203752:	00003617          	auipc	a2,0x3
ffffffffc0203756:	50660613          	addi	a2,a2,1286 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc020375a:	07200593          	li	a1,114
ffffffffc020375e:	00004517          	auipc	a0,0x4
ffffffffc0203762:	01a50513          	addi	a0,a0,26 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203766:	ce5fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020376a <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc020376a:	591c                	lw	a5,48(a0)
{
ffffffffc020376c:	1141                	addi	sp,sp,-16
ffffffffc020376e:	e406                	sd	ra,8(sp)
ffffffffc0203770:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0203772:	e78d                	bnez	a5,ffffffffc020379c <mm_destroy+0x32>
ffffffffc0203774:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0203776:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc0203778:	00a40c63          	beq	s0,a0,ffffffffc0203790 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc020377c:	6118                	ld	a4,0(a0)
ffffffffc020377e:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203780:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203782:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203784:	e398                	sd	a4,0(a5)
ffffffffc0203786:	d28fe0ef          	jal	ffffffffc0201cae <kfree>
    return listelm->next;
ffffffffc020378a:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc020378c:	fea418e3          	bne	s0,a0,ffffffffc020377c <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203790:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203792:	6402                	ld	s0,0(sp)
ffffffffc0203794:	60a2                	ld	ra,8(sp)
ffffffffc0203796:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc0203798:	d16fe06f          	j	ffffffffc0201cae <kfree>
    assert(mm_count(mm) == 0);
ffffffffc020379c:	00004697          	auipc	a3,0x4
ffffffffc02037a0:	04c68693          	addi	a3,a3,76 # ffffffffc02077e8 <etext+0x157a>
ffffffffc02037a4:	00003617          	auipc	a2,0x3
ffffffffc02037a8:	4b460613          	addi	a2,a2,1204 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02037ac:	09e00593          	li	a1,158
ffffffffc02037b0:	00004517          	auipc	a0,0x4
ffffffffc02037b4:	fc850513          	addi	a0,a0,-56 # ffffffffc0207778 <etext+0x150a>
ffffffffc02037b8:	c93fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02037bc <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc02037bc:	6785                	lui	a5,0x1
ffffffffc02037be:	17fd                	addi	a5,a5,-1 # fff <_binary_obj___user_softint_out_size-0x7f29>
ffffffffc02037c0:	963e                	add	a2,a2,a5
    if (!USER_ACCESS(start, end))
ffffffffc02037c2:	4785                	li	a5,1
{
ffffffffc02037c4:	7139                	addi	sp,sp,-64
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc02037c6:	962e                	add	a2,a2,a1
ffffffffc02037c8:	787d                	lui	a6,0xfffff
    if (!USER_ACCESS(start, end))
ffffffffc02037ca:	07fe                	slli	a5,a5,0x1f
{
ffffffffc02037cc:	f822                	sd	s0,48(sp)
ffffffffc02037ce:	f426                	sd	s1,40(sp)
ffffffffc02037d0:	01067433          	and	s0,a2,a6
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc02037d4:	0105f4b3          	and	s1,a1,a6
    if (!USER_ACCESS(start, end))
ffffffffc02037d8:	0785                	addi	a5,a5,1
ffffffffc02037da:	0084b633          	sltu	a2,s1,s0
ffffffffc02037de:	00f437b3          	sltu	a5,s0,a5
ffffffffc02037e2:	00163613          	seqz	a2,a2
ffffffffc02037e6:	0017b793          	seqz	a5,a5
{
ffffffffc02037ea:	fc06                	sd	ra,56(sp)
    if (!USER_ACCESS(start, end))
ffffffffc02037ec:	8fd1                	or	a5,a5,a2
ffffffffc02037ee:	ebbd                	bnez	a5,ffffffffc0203864 <mm_map+0xa8>
ffffffffc02037f0:	002007b7          	lui	a5,0x200
ffffffffc02037f4:	06f4e863          	bltu	s1,a5,ffffffffc0203864 <mm_map+0xa8>
ffffffffc02037f8:	f04a                	sd	s2,32(sp)
ffffffffc02037fa:	ec4e                	sd	s3,24(sp)
ffffffffc02037fc:	e852                	sd	s4,16(sp)
ffffffffc02037fe:	892a                	mv	s2,a0
ffffffffc0203800:	89ba                	mv	s3,a4
ffffffffc0203802:	8a36                	mv	s4,a3
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203804:	c135                	beqz	a0,ffffffffc0203868 <mm_map+0xac>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203806:	85a6                	mv	a1,s1
ffffffffc0203808:	e55ff0ef          	jal	ffffffffc020365c <find_vma>
ffffffffc020380c:	c501                	beqz	a0,ffffffffc0203814 <mm_map+0x58>
ffffffffc020380e:	651c                	ld	a5,8(a0)
ffffffffc0203810:	0487e763          	bltu	a5,s0,ffffffffc020385e <mm_map+0xa2>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203814:	03000513          	li	a0,48
ffffffffc0203818:	bf0fe0ef          	jal	ffffffffc0201c08 <kmalloc>
ffffffffc020381c:	85aa                	mv	a1,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc020381e:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203820:	c59d                	beqz	a1,ffffffffc020384e <mm_map+0x92>
        vma->vm_start = vm_start;
ffffffffc0203822:	e584                	sd	s1,8(a1)
        vma->vm_end = vm_end;
ffffffffc0203824:	e980                	sd	s0,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203826:	0145ac23          	sw	s4,24(a1)

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc020382a:	854a                	mv	a0,s2
ffffffffc020382c:	e42e                	sd	a1,8(sp)
ffffffffc020382e:	e6fff0ef          	jal	ffffffffc020369c <insert_vma_struct>
    if (vma_store != NULL)
ffffffffc0203832:	65a2                	ld	a1,8(sp)
ffffffffc0203834:	00098463          	beqz	s3,ffffffffc020383c <mm_map+0x80>
    {
        *vma_store = vma;
ffffffffc0203838:	00b9b023          	sd	a1,0(s3)
ffffffffc020383c:	7902                	ld	s2,32(sp)
ffffffffc020383e:	69e2                	ld	s3,24(sp)
ffffffffc0203840:	6a42                	ld	s4,16(sp)
    }
    ret = 0;
ffffffffc0203842:	4501                	li	a0,0

out:
    return ret;
}
ffffffffc0203844:	70e2                	ld	ra,56(sp)
ffffffffc0203846:	7442                	ld	s0,48(sp)
ffffffffc0203848:	74a2                	ld	s1,40(sp)
ffffffffc020384a:	6121                	addi	sp,sp,64
ffffffffc020384c:	8082                	ret
ffffffffc020384e:	70e2                	ld	ra,56(sp)
ffffffffc0203850:	7442                	ld	s0,48(sp)
ffffffffc0203852:	7902                	ld	s2,32(sp)
ffffffffc0203854:	69e2                	ld	s3,24(sp)
ffffffffc0203856:	6a42                	ld	s4,16(sp)
ffffffffc0203858:	74a2                	ld	s1,40(sp)
ffffffffc020385a:	6121                	addi	sp,sp,64
ffffffffc020385c:	8082                	ret
ffffffffc020385e:	7902                	ld	s2,32(sp)
ffffffffc0203860:	69e2                	ld	s3,24(sp)
ffffffffc0203862:	6a42                	ld	s4,16(sp)
        return -E_INVAL;
ffffffffc0203864:	5575                	li	a0,-3
ffffffffc0203866:	bff9                	j	ffffffffc0203844 <mm_map+0x88>
    assert(mm != NULL);
ffffffffc0203868:	00004697          	auipc	a3,0x4
ffffffffc020386c:	f9868693          	addi	a3,a3,-104 # ffffffffc0207800 <etext+0x1592>
ffffffffc0203870:	00003617          	auipc	a2,0x3
ffffffffc0203874:	3e860613          	addi	a2,a2,1000 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203878:	0b300593          	li	a1,179
ffffffffc020387c:	00004517          	auipc	a0,0x4
ffffffffc0203880:	efc50513          	addi	a0,a0,-260 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203884:	bc7fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203888 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0203888:	7139                	addi	sp,sp,-64
ffffffffc020388a:	fc06                	sd	ra,56(sp)
ffffffffc020388c:	f822                	sd	s0,48(sp)
ffffffffc020388e:	f426                	sd	s1,40(sp)
ffffffffc0203890:	f04a                	sd	s2,32(sp)
ffffffffc0203892:	ec4e                	sd	s3,24(sp)
ffffffffc0203894:	e852                	sd	s4,16(sp)
ffffffffc0203896:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0203898:	c525                	beqz	a0,ffffffffc0203900 <dup_mmap+0x78>
ffffffffc020389a:	892a                	mv	s2,a0
ffffffffc020389c:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc020389e:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc02038a0:	c1a5                	beqz	a1,ffffffffc0203900 <dup_mmap+0x78>
    return listelm->prev;
ffffffffc02038a2:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc02038a4:	04848c63          	beq	s1,s0,ffffffffc02038fc <dup_mmap+0x74>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02038a8:	03000513          	li	a0,48
    {
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc02038ac:	fe843a83          	ld	s5,-24(s0)
ffffffffc02038b0:	ff043a03          	ld	s4,-16(s0)
ffffffffc02038b4:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02038b8:	b50fe0ef          	jal	ffffffffc0201c08 <kmalloc>
    if (vma != NULL)
ffffffffc02038bc:	c515                	beqz	a0,ffffffffc02038e8 <dup_mmap+0x60>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc02038be:	85aa                	mv	a1,a0
        vma->vm_start = vm_start;
ffffffffc02038c0:	01553423          	sd	s5,8(a0)
ffffffffc02038c4:	01453823          	sd	s4,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc02038c8:	01352c23          	sw	s3,24(a0)
        insert_vma_struct(to, nvma);
ffffffffc02038cc:	854a                	mv	a0,s2
ffffffffc02038ce:	dcfff0ef          	jal	ffffffffc020369c <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc02038d2:	ff043683          	ld	a3,-16(s0)
ffffffffc02038d6:	fe843603          	ld	a2,-24(s0)
ffffffffc02038da:	6c8c                	ld	a1,24(s1)
ffffffffc02038dc:	01893503          	ld	a0,24(s2)
ffffffffc02038e0:	4701                	li	a4,0
ffffffffc02038e2:	a07ff0ef          	jal	ffffffffc02032e8 <copy_range>
ffffffffc02038e6:	dd55                	beqz	a0,ffffffffc02038a2 <dup_mmap+0x1a>
            return -E_NO_MEM;
ffffffffc02038e8:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc02038ea:	70e2                	ld	ra,56(sp)
ffffffffc02038ec:	7442                	ld	s0,48(sp)
ffffffffc02038ee:	74a2                	ld	s1,40(sp)
ffffffffc02038f0:	7902                	ld	s2,32(sp)
ffffffffc02038f2:	69e2                	ld	s3,24(sp)
ffffffffc02038f4:	6a42                	ld	s4,16(sp)
ffffffffc02038f6:	6aa2                	ld	s5,8(sp)
ffffffffc02038f8:	6121                	addi	sp,sp,64
ffffffffc02038fa:	8082                	ret
    return 0;
ffffffffc02038fc:	4501                	li	a0,0
ffffffffc02038fe:	b7f5                	j	ffffffffc02038ea <dup_mmap+0x62>
    assert(to != NULL && from != NULL);
ffffffffc0203900:	00004697          	auipc	a3,0x4
ffffffffc0203904:	f1068693          	addi	a3,a3,-240 # ffffffffc0207810 <etext+0x15a2>
ffffffffc0203908:	00003617          	auipc	a2,0x3
ffffffffc020390c:	35060613          	addi	a2,a2,848 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203910:	0cf00593          	li	a1,207
ffffffffc0203914:	00004517          	auipc	a0,0x4
ffffffffc0203918:	e6450513          	addi	a0,a0,-412 # ffffffffc0207778 <etext+0x150a>
ffffffffc020391c:	b2ffc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203920 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203920:	1101                	addi	sp,sp,-32
ffffffffc0203922:	ec06                	sd	ra,24(sp)
ffffffffc0203924:	e822                	sd	s0,16(sp)
ffffffffc0203926:	e426                	sd	s1,8(sp)
ffffffffc0203928:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc020392a:	c531                	beqz	a0,ffffffffc0203976 <exit_mmap+0x56>
ffffffffc020392c:	591c                	lw	a5,48(a0)
ffffffffc020392e:	84aa                	mv	s1,a0
ffffffffc0203930:	e3b9                	bnez	a5,ffffffffc0203976 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0203932:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0203934:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203938:	02850663          	beq	a0,s0,ffffffffc0203964 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc020393c:	ff043603          	ld	a2,-16(s0)
ffffffffc0203940:	fe843583          	ld	a1,-24(s0)
ffffffffc0203944:	854a                	mv	a0,s2
ffffffffc0203946:	fdefe0ef          	jal	ffffffffc0202124 <unmap_range>
ffffffffc020394a:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc020394c:	fe8498e3          	bne	s1,s0,ffffffffc020393c <exit_mmap+0x1c>
ffffffffc0203950:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0203952:	00848c63          	beq	s1,s0,ffffffffc020396a <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203956:	ff043603          	ld	a2,-16(s0)
ffffffffc020395a:	fe843583          	ld	a1,-24(s0)
ffffffffc020395e:	854a                	mv	a0,s2
ffffffffc0203960:	8f9fe0ef          	jal	ffffffffc0202258 <exit_range>
ffffffffc0203964:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203966:	fe8498e3          	bne	s1,s0,ffffffffc0203956 <exit_mmap+0x36>
    }
}
ffffffffc020396a:	60e2                	ld	ra,24(sp)
ffffffffc020396c:	6442                	ld	s0,16(sp)
ffffffffc020396e:	64a2                	ld	s1,8(sp)
ffffffffc0203970:	6902                	ld	s2,0(sp)
ffffffffc0203972:	6105                	addi	sp,sp,32
ffffffffc0203974:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203976:	00004697          	auipc	a3,0x4
ffffffffc020397a:	eba68693          	addi	a3,a3,-326 # ffffffffc0207830 <etext+0x15c2>
ffffffffc020397e:	00003617          	auipc	a2,0x3
ffffffffc0203982:	2da60613          	addi	a2,a2,730 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203986:	0e800593          	li	a1,232
ffffffffc020398a:	00004517          	auipc	a0,0x4
ffffffffc020398e:	dee50513          	addi	a0,a0,-530 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203992:	ab9fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203996 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203996:	7179                	addi	sp,sp,-48
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203998:	04000513          	li	a0,64
{
ffffffffc020399c:	f406                	sd	ra,40(sp)
ffffffffc020399e:	f022                	sd	s0,32(sp)
ffffffffc02039a0:	ec26                	sd	s1,24(sp)
ffffffffc02039a2:	e84a                	sd	s2,16(sp)
ffffffffc02039a4:	e44e                	sd	s3,8(sp)
ffffffffc02039a6:	e052                	sd	s4,0(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02039a8:	a60fe0ef          	jal	ffffffffc0201c08 <kmalloc>
    if (mm != NULL)
ffffffffc02039ac:	16050c63          	beqz	a0,ffffffffc0203b24 <vmm_init+0x18e>
ffffffffc02039b0:	842a                	mv	s0,a0
    elm->prev = elm->next = elm;
ffffffffc02039b2:	e508                	sd	a0,8(a0)
ffffffffc02039b4:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02039b6:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02039ba:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02039be:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02039c2:	02053423          	sd	zero,40(a0)
ffffffffc02039c6:	02052823          	sw	zero,48(a0)
ffffffffc02039ca:	02053c23          	sd	zero,56(a0)
ffffffffc02039ce:	03200493          	li	s1,50
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02039d2:	03000513          	li	a0,48
ffffffffc02039d6:	a32fe0ef          	jal	ffffffffc0201c08 <kmalloc>
    if (vma != NULL)
ffffffffc02039da:	12050563          	beqz	a0,ffffffffc0203b04 <vmm_init+0x16e>
        vma->vm_end = vm_end;
ffffffffc02039de:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc02039e2:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc02039e4:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc02039e8:	e91c                	sd	a5,16(a0)
    int i;
    for (i = step1; i >= 1; i--)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc02039ea:	85aa                	mv	a1,a0
    for (i = step1; i >= 1; i--)
ffffffffc02039ec:	14ed                	addi	s1,s1,-5
        insert_vma_struct(mm, vma);
ffffffffc02039ee:	8522                	mv	a0,s0
ffffffffc02039f0:	cadff0ef          	jal	ffffffffc020369c <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc02039f4:	fcf9                	bnez	s1,ffffffffc02039d2 <vmm_init+0x3c>
ffffffffc02039f6:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc02039fa:	1f900913          	li	s2,505
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02039fe:	03000513          	li	a0,48
ffffffffc0203a02:	a06fe0ef          	jal	ffffffffc0201c08 <kmalloc>
    if (vma != NULL)
ffffffffc0203a06:	12050f63          	beqz	a0,ffffffffc0203b44 <vmm_init+0x1ae>
        vma->vm_end = vm_end;
ffffffffc0203a0a:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0203a0e:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203a10:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0203a14:	e91c                	sd	a5,16(a0)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203a16:	85aa                	mv	a1,a0
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203a18:	0495                	addi	s1,s1,5
        insert_vma_struct(mm, vma);
ffffffffc0203a1a:	8522                	mv	a0,s0
ffffffffc0203a1c:	c81ff0ef          	jal	ffffffffc020369c <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203a20:	fd249fe3          	bne	s1,s2,ffffffffc02039fe <vmm_init+0x68>
    return listelm->next;
ffffffffc0203a24:	641c                	ld	a5,8(s0)
ffffffffc0203a26:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203a28:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203a2c:	1ef40c63          	beq	s0,a5,ffffffffc0203c24 <vmm_init+0x28e>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203a30:	fe87b603          	ld	a2,-24(a5) # 1fffe8 <_binary_obj___user_matrix_out_size+0x1f4ab8>
ffffffffc0203a34:	ffe70693          	addi	a3,a4,-2
ffffffffc0203a38:	12d61663          	bne	a2,a3,ffffffffc0203b64 <vmm_init+0x1ce>
ffffffffc0203a3c:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203a40:	12e69263          	bne	a3,a4,ffffffffc0203b64 <vmm_init+0x1ce>
    for (i = 1; i <= step2; i++)
ffffffffc0203a44:	0715                	addi	a4,a4,5
ffffffffc0203a46:	679c                	ld	a5,8(a5)
ffffffffc0203a48:	feb712e3          	bne	a4,a1,ffffffffc0203a2c <vmm_init+0x96>
ffffffffc0203a4c:	491d                	li	s2,7
ffffffffc0203a4e:	4495                	li	s1,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203a50:	85a6                	mv	a1,s1
ffffffffc0203a52:	8522                	mv	a0,s0
ffffffffc0203a54:	c09ff0ef          	jal	ffffffffc020365c <find_vma>
ffffffffc0203a58:	8a2a                	mv	s4,a0
        assert(vma1 != NULL);
ffffffffc0203a5a:	20050563          	beqz	a0,ffffffffc0203c64 <vmm_init+0x2ce>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203a5e:	00148593          	addi	a1,s1,1
ffffffffc0203a62:	8522                	mv	a0,s0
ffffffffc0203a64:	bf9ff0ef          	jal	ffffffffc020365c <find_vma>
ffffffffc0203a68:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203a6a:	1c050d63          	beqz	a0,ffffffffc0203c44 <vmm_init+0x2ae>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203a6e:	85ca                	mv	a1,s2
ffffffffc0203a70:	8522                	mv	a0,s0
ffffffffc0203a72:	bebff0ef          	jal	ffffffffc020365c <find_vma>
        assert(vma3 == NULL);
ffffffffc0203a76:	18051763          	bnez	a0,ffffffffc0203c04 <vmm_init+0x26e>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203a7a:	00348593          	addi	a1,s1,3
ffffffffc0203a7e:	8522                	mv	a0,s0
ffffffffc0203a80:	bddff0ef          	jal	ffffffffc020365c <find_vma>
        assert(vma4 == NULL);
ffffffffc0203a84:	16051063          	bnez	a0,ffffffffc0203be4 <vmm_init+0x24e>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203a88:	00448593          	addi	a1,s1,4
ffffffffc0203a8c:	8522                	mv	a0,s0
ffffffffc0203a8e:	bcfff0ef          	jal	ffffffffc020365c <find_vma>
        assert(vma5 == NULL);
ffffffffc0203a92:	12051963          	bnez	a0,ffffffffc0203bc4 <vmm_init+0x22e>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203a96:	008a3783          	ld	a5,8(s4)
ffffffffc0203a9a:	10979563          	bne	a5,s1,ffffffffc0203ba4 <vmm_init+0x20e>
ffffffffc0203a9e:	010a3783          	ld	a5,16(s4)
ffffffffc0203aa2:	11279163          	bne	a5,s2,ffffffffc0203ba4 <vmm_init+0x20e>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203aa6:	0089b783          	ld	a5,8(s3)
ffffffffc0203aaa:	0c979d63          	bne	a5,s1,ffffffffc0203b84 <vmm_init+0x1ee>
ffffffffc0203aae:	0109b783          	ld	a5,16(s3)
ffffffffc0203ab2:	0d279963          	bne	a5,s2,ffffffffc0203b84 <vmm_init+0x1ee>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203ab6:	0495                	addi	s1,s1,5
ffffffffc0203ab8:	1f900793          	li	a5,505
ffffffffc0203abc:	0915                	addi	s2,s2,5
ffffffffc0203abe:	f8f499e3          	bne	s1,a5,ffffffffc0203a50 <vmm_init+0xba>
ffffffffc0203ac2:	4491                	li	s1,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203ac4:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203ac6:	85a6                	mv	a1,s1
ffffffffc0203ac8:	8522                	mv	a0,s0
ffffffffc0203aca:	b93ff0ef          	jal	ffffffffc020365c <find_vma>
        if (vma_below_5 != NULL)
ffffffffc0203ace:	1a051b63          	bnez	a0,ffffffffc0203c84 <vmm_init+0x2ee>
    for (i = 4; i >= 0; i--)
ffffffffc0203ad2:	14fd                	addi	s1,s1,-1
ffffffffc0203ad4:	ff2499e3          	bne	s1,s2,ffffffffc0203ac6 <vmm_init+0x130>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
ffffffffc0203ad8:	8522                	mv	a0,s0
ffffffffc0203ada:	c91ff0ef          	jal	ffffffffc020376a <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203ade:	00004517          	auipc	a0,0x4
ffffffffc0203ae2:	ec250513          	addi	a0,a0,-318 # ffffffffc02079a0 <etext+0x1732>
ffffffffc0203ae6:	eb2fc0ef          	jal	ffffffffc0200198 <cprintf>
}
ffffffffc0203aea:	7402                	ld	s0,32(sp)
ffffffffc0203aec:	70a2                	ld	ra,40(sp)
ffffffffc0203aee:	64e2                	ld	s1,24(sp)
ffffffffc0203af0:	6942                	ld	s2,16(sp)
ffffffffc0203af2:	69a2                	ld	s3,8(sp)
ffffffffc0203af4:	6a02                	ld	s4,0(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203af6:	00004517          	auipc	a0,0x4
ffffffffc0203afa:	eca50513          	addi	a0,a0,-310 # ffffffffc02079c0 <etext+0x1752>
}
ffffffffc0203afe:	6145                	addi	sp,sp,48
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203b00:	e98fc06f          	j	ffffffffc0200198 <cprintf>
        assert(vma != NULL);
ffffffffc0203b04:	00004697          	auipc	a3,0x4
ffffffffc0203b08:	d4c68693          	addi	a3,a3,-692 # ffffffffc0207850 <etext+0x15e2>
ffffffffc0203b0c:	00003617          	auipc	a2,0x3
ffffffffc0203b10:	14c60613          	addi	a2,a2,332 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203b14:	12c00593          	li	a1,300
ffffffffc0203b18:	00004517          	auipc	a0,0x4
ffffffffc0203b1c:	c6050513          	addi	a0,a0,-928 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203b20:	92bfc0ef          	jal	ffffffffc020044a <__panic>
    assert(mm != NULL);
ffffffffc0203b24:	00004697          	auipc	a3,0x4
ffffffffc0203b28:	cdc68693          	addi	a3,a3,-804 # ffffffffc0207800 <etext+0x1592>
ffffffffc0203b2c:	00003617          	auipc	a2,0x3
ffffffffc0203b30:	12c60613          	addi	a2,a2,300 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203b34:	12400593          	li	a1,292
ffffffffc0203b38:	00004517          	auipc	a0,0x4
ffffffffc0203b3c:	c4050513          	addi	a0,a0,-960 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203b40:	90bfc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma != NULL);
ffffffffc0203b44:	00004697          	auipc	a3,0x4
ffffffffc0203b48:	d0c68693          	addi	a3,a3,-756 # ffffffffc0207850 <etext+0x15e2>
ffffffffc0203b4c:	00003617          	auipc	a2,0x3
ffffffffc0203b50:	10c60613          	addi	a2,a2,268 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203b54:	13300593          	li	a1,307
ffffffffc0203b58:	00004517          	auipc	a0,0x4
ffffffffc0203b5c:	c2050513          	addi	a0,a0,-992 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203b60:	8ebfc0ef          	jal	ffffffffc020044a <__panic>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203b64:	00004697          	auipc	a3,0x4
ffffffffc0203b68:	d1468693          	addi	a3,a3,-748 # ffffffffc0207878 <etext+0x160a>
ffffffffc0203b6c:	00003617          	auipc	a2,0x3
ffffffffc0203b70:	0ec60613          	addi	a2,a2,236 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203b74:	13d00593          	li	a1,317
ffffffffc0203b78:	00004517          	auipc	a0,0x4
ffffffffc0203b7c:	c0050513          	addi	a0,a0,-1024 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203b80:	8cbfc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203b84:	00004697          	auipc	a3,0x4
ffffffffc0203b88:	dac68693          	addi	a3,a3,-596 # ffffffffc0207930 <etext+0x16c2>
ffffffffc0203b8c:	00003617          	auipc	a2,0x3
ffffffffc0203b90:	0cc60613          	addi	a2,a2,204 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203b94:	14f00593          	li	a1,335
ffffffffc0203b98:	00004517          	auipc	a0,0x4
ffffffffc0203b9c:	be050513          	addi	a0,a0,-1056 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203ba0:	8abfc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203ba4:	00004697          	auipc	a3,0x4
ffffffffc0203ba8:	d5c68693          	addi	a3,a3,-676 # ffffffffc0207900 <etext+0x1692>
ffffffffc0203bac:	00003617          	auipc	a2,0x3
ffffffffc0203bb0:	0ac60613          	addi	a2,a2,172 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203bb4:	14e00593          	li	a1,334
ffffffffc0203bb8:	00004517          	auipc	a0,0x4
ffffffffc0203bbc:	bc050513          	addi	a0,a0,-1088 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203bc0:	88bfc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma5 == NULL);
ffffffffc0203bc4:	00004697          	auipc	a3,0x4
ffffffffc0203bc8:	d2c68693          	addi	a3,a3,-724 # ffffffffc02078f0 <etext+0x1682>
ffffffffc0203bcc:	00003617          	auipc	a2,0x3
ffffffffc0203bd0:	08c60613          	addi	a2,a2,140 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203bd4:	14c00593          	li	a1,332
ffffffffc0203bd8:	00004517          	auipc	a0,0x4
ffffffffc0203bdc:	ba050513          	addi	a0,a0,-1120 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203be0:	86bfc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma4 == NULL);
ffffffffc0203be4:	00004697          	auipc	a3,0x4
ffffffffc0203be8:	cfc68693          	addi	a3,a3,-772 # ffffffffc02078e0 <etext+0x1672>
ffffffffc0203bec:	00003617          	auipc	a2,0x3
ffffffffc0203bf0:	06c60613          	addi	a2,a2,108 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203bf4:	14a00593          	li	a1,330
ffffffffc0203bf8:	00004517          	auipc	a0,0x4
ffffffffc0203bfc:	b8050513          	addi	a0,a0,-1152 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203c00:	84bfc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma3 == NULL);
ffffffffc0203c04:	00004697          	auipc	a3,0x4
ffffffffc0203c08:	ccc68693          	addi	a3,a3,-820 # ffffffffc02078d0 <etext+0x1662>
ffffffffc0203c0c:	00003617          	auipc	a2,0x3
ffffffffc0203c10:	04c60613          	addi	a2,a2,76 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203c14:	14800593          	li	a1,328
ffffffffc0203c18:	00004517          	auipc	a0,0x4
ffffffffc0203c1c:	b6050513          	addi	a0,a0,-1184 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203c20:	82bfc0ef          	jal	ffffffffc020044a <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203c24:	00004697          	auipc	a3,0x4
ffffffffc0203c28:	c3c68693          	addi	a3,a3,-964 # ffffffffc0207860 <etext+0x15f2>
ffffffffc0203c2c:	00003617          	auipc	a2,0x3
ffffffffc0203c30:	02c60613          	addi	a2,a2,44 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203c34:	13b00593          	li	a1,315
ffffffffc0203c38:	00004517          	auipc	a0,0x4
ffffffffc0203c3c:	b4050513          	addi	a0,a0,-1216 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203c40:	80bfc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma2 != NULL);
ffffffffc0203c44:	00004697          	auipc	a3,0x4
ffffffffc0203c48:	c7c68693          	addi	a3,a3,-900 # ffffffffc02078c0 <etext+0x1652>
ffffffffc0203c4c:	00003617          	auipc	a2,0x3
ffffffffc0203c50:	00c60613          	addi	a2,a2,12 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203c54:	14600593          	li	a1,326
ffffffffc0203c58:	00004517          	auipc	a0,0x4
ffffffffc0203c5c:	b2050513          	addi	a0,a0,-1248 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203c60:	feafc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma1 != NULL);
ffffffffc0203c64:	00004697          	auipc	a3,0x4
ffffffffc0203c68:	c4c68693          	addi	a3,a3,-948 # ffffffffc02078b0 <etext+0x1642>
ffffffffc0203c6c:	00003617          	auipc	a2,0x3
ffffffffc0203c70:	fec60613          	addi	a2,a2,-20 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203c74:	14400593          	li	a1,324
ffffffffc0203c78:	00004517          	auipc	a0,0x4
ffffffffc0203c7c:	b0050513          	addi	a0,a0,-1280 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203c80:	fcafc0ef          	jal	ffffffffc020044a <__panic>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203c84:	6914                	ld	a3,16(a0)
ffffffffc0203c86:	6510                	ld	a2,8(a0)
ffffffffc0203c88:	0004859b          	sext.w	a1,s1
ffffffffc0203c8c:	00004517          	auipc	a0,0x4
ffffffffc0203c90:	cd450513          	addi	a0,a0,-812 # ffffffffc0207960 <etext+0x16f2>
ffffffffc0203c94:	d04fc0ef          	jal	ffffffffc0200198 <cprintf>
        assert(vma_below_5 == NULL);
ffffffffc0203c98:	00004697          	auipc	a3,0x4
ffffffffc0203c9c:	cf068693          	addi	a3,a3,-784 # ffffffffc0207988 <etext+0x171a>
ffffffffc0203ca0:	00003617          	auipc	a2,0x3
ffffffffc0203ca4:	fb860613          	addi	a2,a2,-72 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0203ca8:	15900593          	li	a1,345
ffffffffc0203cac:	00004517          	auipc	a0,0x4
ffffffffc0203cb0:	acc50513          	addi	a0,a0,-1332 # ffffffffc0207778 <etext+0x150a>
ffffffffc0203cb4:	f96fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203cb8 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203cb8:	7179                	addi	sp,sp,-48
ffffffffc0203cba:	f022                	sd	s0,32(sp)
ffffffffc0203cbc:	f406                	sd	ra,40(sp)
ffffffffc0203cbe:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203cc0:	c52d                	beqz	a0,ffffffffc0203d2a <user_mem_check+0x72>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203cc2:	002007b7          	lui	a5,0x200
ffffffffc0203cc6:	04f5ed63          	bltu	a1,a5,ffffffffc0203d20 <user_mem_check+0x68>
ffffffffc0203cca:	ec26                	sd	s1,24(sp)
ffffffffc0203ccc:	00c584b3          	add	s1,a1,a2
ffffffffc0203cd0:	0695ff63          	bgeu	a1,s1,ffffffffc0203d4e <user_mem_check+0x96>
ffffffffc0203cd4:	4785                	li	a5,1
ffffffffc0203cd6:	07fe                	slli	a5,a5,0x1f
ffffffffc0203cd8:	0785                	addi	a5,a5,1 # 200001 <_binary_obj___user_matrix_out_size+0x1f4ad1>
ffffffffc0203cda:	06f4fa63          	bgeu	s1,a5,ffffffffc0203d4e <user_mem_check+0x96>
ffffffffc0203cde:	e84a                	sd	s2,16(sp)
ffffffffc0203ce0:	e44e                	sd	s3,8(sp)
ffffffffc0203ce2:	8936                	mv	s2,a3
ffffffffc0203ce4:	89aa                	mv	s3,a0
ffffffffc0203ce6:	a829                	j	ffffffffc0203d00 <user_mem_check+0x48>
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203ce8:	6685                	lui	a3,0x1
ffffffffc0203cea:	9736                	add	a4,a4,a3
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203cec:	0027f693          	andi	a3,a5,2
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203cf0:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203cf2:	c685                	beqz	a3,ffffffffc0203d1a <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203cf4:	c399                	beqz	a5,ffffffffc0203cfa <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203cf6:	02e46263          	bltu	s0,a4,ffffffffc0203d1a <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203cfa:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203cfc:	04947b63          	bgeu	s0,s1,ffffffffc0203d52 <user_mem_check+0x9a>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203d00:	85a2                	mv	a1,s0
ffffffffc0203d02:	854e                	mv	a0,s3
ffffffffc0203d04:	959ff0ef          	jal	ffffffffc020365c <find_vma>
ffffffffc0203d08:	c909                	beqz	a0,ffffffffc0203d1a <user_mem_check+0x62>
ffffffffc0203d0a:	6518                	ld	a4,8(a0)
ffffffffc0203d0c:	00e46763          	bltu	s0,a4,ffffffffc0203d1a <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d10:	4d1c                	lw	a5,24(a0)
ffffffffc0203d12:	fc091be3          	bnez	s2,ffffffffc0203ce8 <user_mem_check+0x30>
ffffffffc0203d16:	8b85                	andi	a5,a5,1
ffffffffc0203d18:	f3ed                	bnez	a5,ffffffffc0203cfa <user_mem_check+0x42>
ffffffffc0203d1a:	64e2                	ld	s1,24(sp)
ffffffffc0203d1c:	6942                	ld	s2,16(sp)
ffffffffc0203d1e:	69a2                	ld	s3,8(sp)
            return 0;
ffffffffc0203d20:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc0203d22:	70a2                	ld	ra,40(sp)
ffffffffc0203d24:	7402                	ld	s0,32(sp)
ffffffffc0203d26:	6145                	addi	sp,sp,48
ffffffffc0203d28:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203d2a:	c02007b7          	lui	a5,0xc0200
ffffffffc0203d2e:	fef5eae3          	bltu	a1,a5,ffffffffc0203d22 <user_mem_check+0x6a>
ffffffffc0203d32:	c80007b7          	lui	a5,0xc8000
ffffffffc0203d36:	962e                	add	a2,a2,a1
ffffffffc0203d38:	0785                	addi	a5,a5,1 # ffffffffc8000001 <end+0x7d4a991>
ffffffffc0203d3a:	00c5b433          	sltu	s0,a1,a2
ffffffffc0203d3e:	00f63633          	sltu	a2,a2,a5
}
ffffffffc0203d42:	70a2                	ld	ra,40(sp)
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203d44:	00867533          	and	a0,a2,s0
}
ffffffffc0203d48:	7402                	ld	s0,32(sp)
ffffffffc0203d4a:	6145                	addi	sp,sp,48
ffffffffc0203d4c:	8082                	ret
ffffffffc0203d4e:	64e2                	ld	s1,24(sp)
ffffffffc0203d50:	bfc1                	j	ffffffffc0203d20 <user_mem_check+0x68>
ffffffffc0203d52:	64e2                	ld	s1,24(sp)
ffffffffc0203d54:	6942                	ld	s2,16(sp)
ffffffffc0203d56:	69a2                	ld	s3,8(sp)
        return 1;
ffffffffc0203d58:	4505                	li	a0,1
ffffffffc0203d5a:	b7e1                	j	ffffffffc0203d22 <user_mem_check+0x6a>

ffffffffc0203d5c <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203d5c:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203d5e:	9402                	jalr	s0

	jal do_exit
ffffffffc0203d60:	61a000ef          	jal	ffffffffc020437a <do_exit>

ffffffffc0203d64 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203d64:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203d66:	14800513          	li	a0,328
{
ffffffffc0203d6a:	e022                	sd	s0,0(sp)
ffffffffc0203d6c:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203d6e:	e9bfd0ef          	jal	ffffffffc0201c08 <kmalloc>
ffffffffc0203d72:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203d74:	c141                	beqz	a0,ffffffffc0203df4 <alloc_proc+0x90>
         *       struct trapframe *tf;                       // Trap frame for current interrupt
         *       uintptr_t pgdir;                            // the base addr of Page Directroy Table(PDT)
         *       uint32_t flags;                             // Process flag
         *       char name[PROC_NAME_LEN + 1];               // Process name
         */
        proc->state = PROC_UNINIT;
ffffffffc0203d76:	57fd                	li	a5,-1
ffffffffc0203d78:	1782                	slli	a5,a5,0x20
ffffffffc0203d7a:	e11c                	sd	a5,0(a0)
        proc->pid = -1;
        proc->runs = 0;
ffffffffc0203d7c:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc0203d80:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203d84:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203d88:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0203d8c:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203d90:	07000613          	li	a2,112
ffffffffc0203d94:	4581                	li	a1,0
ffffffffc0203d96:	03050513          	addi	a0,a0,48
ffffffffc0203d9a:	4aa020ef          	jal	ffffffffc0206244 <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203d9e:	000b2797          	auipc	a5,0xb2
ffffffffc0203da2:	87a7b783          	ld	a5,-1926(a5) # ffffffffc02b5618 <boot_pgdir_pa>
        proc->tf = NULL;
ffffffffc0203da6:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc0203daa:	0a042823          	sw	zero,176(s0)
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203dae:	f45c                	sd	a5,168(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1);
ffffffffc0203db0:	0b440513          	addi	a0,s0,180
ffffffffc0203db4:	4641                	li	a2,16
ffffffffc0203db6:	4581                	li	a1,0
ffffffffc0203db8:	48c020ef          	jal	ffffffffc0206244 <memset>
        list_init(&(proc->run_link));        // 初始化运行队列链表项
        proc->time_slice = 0;                // 初始化时间片为0
        proc->lab6_run_pool.parent = NULL;   // 初始化斜堆父指针
        proc->lab6_run_pool.left = NULL;     // 初始化斜堆左孩子
        proc->lab6_run_pool.right = NULL;    // 初始化斜堆右孩子
        proc->lab6_stride = 0;               // 初始化stride值为0
ffffffffc0203dbc:	4785                	li	a5,1
        list_init(&(proc->run_link));        // 初始化运行队列链表项
ffffffffc0203dbe:	11040713          	addi	a4,s0,272
        proc->lab6_stride = 0;               // 初始化stride值为0
ffffffffc0203dc2:	1782                	slli	a5,a5,0x20
        proc->exit_code = 0;
ffffffffc0203dc4:	0e043423          	sd	zero,232(s0)
        proc->cptr = proc->yptr = proc->optr = NULL;
ffffffffc0203dc8:	0e043823          	sd	zero,240(s0)
ffffffffc0203dcc:	0e043c23          	sd	zero,248(s0)
ffffffffc0203dd0:	10043023          	sd	zero,256(s0)
        proc->rq = NULL;                     // 初始化运行队列为空
ffffffffc0203dd4:	10043423          	sd	zero,264(s0)
        proc->time_slice = 0;                // 初始化时间片为0
ffffffffc0203dd8:	12042023          	sw	zero,288(s0)
        proc->lab6_run_pool.parent = NULL;   // 初始化斜堆父指针
ffffffffc0203ddc:	12043423          	sd	zero,296(s0)
        proc->lab6_run_pool.left = NULL;     // 初始化斜堆左孩子
ffffffffc0203de0:	12043823          	sd	zero,304(s0)
        proc->lab6_run_pool.right = NULL;    // 初始化斜堆右孩子
ffffffffc0203de4:	12043c23          	sd	zero,312(s0)
        proc->lab6_stride = 0;               // 初始化stride值为0
ffffffffc0203de8:	14f43023          	sd	a5,320(s0)
    elm->prev = elm->next = elm;
ffffffffc0203dec:	10e43c23          	sd	a4,280(s0)
ffffffffc0203df0:	10e43823          	sd	a4,272(s0)
        proc->lab6_priority = 1;             // 初始化优先级为1（默认值）
    }
    return proc;
}
ffffffffc0203df4:	60a2                	ld	ra,8(sp)
ffffffffc0203df6:	8522                	mv	a0,s0
ffffffffc0203df8:	6402                	ld	s0,0(sp)
ffffffffc0203dfa:	0141                	addi	sp,sp,16
ffffffffc0203dfc:	8082                	ret

ffffffffc0203dfe <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203dfe:	000b2797          	auipc	a5,0xb2
ffffffffc0203e02:	84a7b783          	ld	a5,-1974(a5) # ffffffffc02b5648 <current>
ffffffffc0203e06:	73c8                	ld	a0,160(a5)
ffffffffc0203e08:	88efd06f          	j	ffffffffc0200e96 <forkrets>

ffffffffc0203e0c <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0203e0c:	6d14                	ld	a3,24(a0)
}

// put_pgdir - free the memory space of PDT
static void
put_pgdir(struct mm_struct *mm)
{
ffffffffc0203e0e:	1141                	addi	sp,sp,-16
ffffffffc0203e10:	e406                	sd	ra,8(sp)
ffffffffc0203e12:	c02007b7          	lui	a5,0xc0200
ffffffffc0203e16:	02f6ee63          	bltu	a3,a5,ffffffffc0203e52 <put_pgdir+0x46>
ffffffffc0203e1a:	000b2717          	auipc	a4,0xb2
ffffffffc0203e1e:	80e73703          	ld	a4,-2034(a4) # ffffffffc02b5628 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0203e22:	000b2797          	auipc	a5,0xb2
ffffffffc0203e26:	80e7b783          	ld	a5,-2034(a5) # ffffffffc02b5630 <npage>
    return pa2page(PADDR(kva));
ffffffffc0203e2a:	8e99                	sub	a3,a3,a4
    if (PPN(pa) >= npage)
ffffffffc0203e2c:	82b1                	srli	a3,a3,0xc
ffffffffc0203e2e:	02f6fe63          	bgeu	a3,a5,ffffffffc0203e6a <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0203e32:	00005797          	auipc	a5,0x5
ffffffffc0203e36:	cce7b783          	ld	a5,-818(a5) # ffffffffc0208b00 <nbase>
ffffffffc0203e3a:	000b1517          	auipc	a0,0xb1
ffffffffc0203e3e:	7fe53503          	ld	a0,2046(a0) # ffffffffc02b5638 <pages>
    free_page(kva2page(mm->pgdir));
}
ffffffffc0203e42:	60a2                	ld	ra,8(sp)
ffffffffc0203e44:	8e9d                	sub	a3,a3,a5
ffffffffc0203e46:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0203e48:	4585                	li	a1,1
ffffffffc0203e4a:	9536                	add	a0,a0,a3
}
ffffffffc0203e4c:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0203e4e:	fb7fd06f          	j	ffffffffc0201e04 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0203e52:	00003617          	auipc	a2,0x3
ffffffffc0203e56:	25e60613          	addi	a2,a2,606 # ffffffffc02070b0 <etext+0xe42>
ffffffffc0203e5a:	07700593          	li	a1,119
ffffffffc0203e5e:	00003517          	auipc	a0,0x3
ffffffffc0203e62:	1d250513          	addi	a0,a0,466 # ffffffffc0207030 <etext+0xdc2>
ffffffffc0203e66:	de4fc0ef          	jal	ffffffffc020044a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203e6a:	00003617          	auipc	a2,0x3
ffffffffc0203e6e:	26e60613          	addi	a2,a2,622 # ffffffffc02070d8 <etext+0xe6a>
ffffffffc0203e72:	06900593          	li	a1,105
ffffffffc0203e76:	00003517          	auipc	a0,0x3
ffffffffc0203e7a:	1ba50513          	addi	a0,a0,442 # ffffffffc0207030 <etext+0xdc2>
ffffffffc0203e7e:	dccfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203e82 <proc_run>:
    if (proc != current)
ffffffffc0203e82:	000b1697          	auipc	a3,0xb1
ffffffffc0203e86:	7c66b683          	ld	a3,1990(a3) # ffffffffc02b5648 <current>
ffffffffc0203e8a:	04a68463          	beq	a3,a0,ffffffffc0203ed2 <proc_run+0x50>
{
ffffffffc0203e8e:	1101                	addi	sp,sp,-32
ffffffffc0203e90:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203e92:	100027f3          	csrr	a5,sstatus
ffffffffc0203e96:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203e98:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203e9a:	ef8d                	bnez	a5,ffffffffc0203ed4 <proc_run+0x52>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0203e9c:	755c                	ld	a5,168(a0)
ffffffffc0203e9e:	577d                	li	a4,-1
ffffffffc0203ea0:	177e                	slli	a4,a4,0x3f
ffffffffc0203ea2:	83b1                	srli	a5,a5,0xc
ffffffffc0203ea4:	e032                	sd	a2,0(sp)
            current = proc;
ffffffffc0203ea6:	000b1597          	auipc	a1,0xb1
ffffffffc0203eaa:	7aa5b123          	sd	a0,1954(a1) # ffffffffc02b5648 <current>
ffffffffc0203eae:	8fd9                	or	a5,a5,a4
ffffffffc0203eb0:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(proc->context));
ffffffffc0203eb4:	03050593          	addi	a1,a0,48
ffffffffc0203eb8:	03068513          	addi	a0,a3,48
ffffffffc0203ebc:	1fa010ef          	jal	ffffffffc02050b6 <switch_to>
    if (flag)
ffffffffc0203ec0:	6602                	ld	a2,0(sp)
ffffffffc0203ec2:	e601                	bnez	a2,ffffffffc0203eca <proc_run+0x48>
}
ffffffffc0203ec4:	60e2                	ld	ra,24(sp)
ffffffffc0203ec6:	6105                	addi	sp,sp,32
ffffffffc0203ec8:	8082                	ret
ffffffffc0203eca:	60e2                	ld	ra,24(sp)
ffffffffc0203ecc:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0203ece:	a37fc06f          	j	ffffffffc0200904 <intr_enable>
ffffffffc0203ed2:	8082                	ret
ffffffffc0203ed4:	e42a                	sd	a0,8(sp)
ffffffffc0203ed6:	e036                	sd	a3,0(sp)
        intr_disable();
ffffffffc0203ed8:	a33fc0ef          	jal	ffffffffc020090a <intr_disable>
        return 1;
ffffffffc0203edc:	6522                	ld	a0,8(sp)
ffffffffc0203ede:	6682                	ld	a3,0(sp)
ffffffffc0203ee0:	4605                	li	a2,1
ffffffffc0203ee2:	bf6d                	j	ffffffffc0203e9c <proc_run+0x1a>

ffffffffc0203ee4 <do_fork>:
 */
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf)
{
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS)
ffffffffc0203ee4:	000b1717          	auipc	a4,0xb1
ffffffffc0203ee8:	75c72703          	lw	a4,1884(a4) # ffffffffc02b5640 <nr_process>
ffffffffc0203eec:	6785                	lui	a5,0x1
ffffffffc0203eee:	36f75d63          	bge	a4,a5,ffffffffc0204268 <do_fork+0x384>
{
ffffffffc0203ef2:	711d                	addi	sp,sp,-96
ffffffffc0203ef4:	e8a2                	sd	s0,80(sp)
ffffffffc0203ef6:	e4a6                	sd	s1,72(sp)
ffffffffc0203ef8:	e0ca                	sd	s2,64(sp)
ffffffffc0203efa:	e06a                	sd	s10,0(sp)
ffffffffc0203efc:	ec86                	sd	ra,88(sp)
ffffffffc0203efe:	892e                	mv	s2,a1
ffffffffc0203f00:	84b2                	mv	s1,a2
ffffffffc0203f02:	8d2a                	mv	s10,a0
     *   proc_list:    the process set's list
     *   nr_process:   the number of process set
     */

    //    1. call alloc_proc to allocate a proc_struct
    if ((proc = alloc_proc()) == NULL) {
ffffffffc0203f04:	e61ff0ef          	jal	ffffffffc0203d64 <alloc_proc>
ffffffffc0203f08:	842a                	mv	s0,a0
ffffffffc0203f0a:	30050063          	beqz	a0,ffffffffc020420a <do_fork+0x326>
        goto fork_out;
    }
    proc->parent = current;
ffffffffc0203f0e:	f05a                	sd	s6,32(sp)
ffffffffc0203f10:	000b1b17          	auipc	s6,0xb1
ffffffffc0203f14:	738b0b13          	addi	s6,s6,1848 # ffffffffc02b5648 <current>
ffffffffc0203f18:	000b3783          	ld	a5,0(s6)
    assert(current->wait_state == 0);
ffffffffc0203f1c:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_obj___user_softint_out_size-0x7e3c>
    proc->parent = current;
ffffffffc0203f20:	f11c                	sd	a5,32(a0)
    assert(current->wait_state == 0);
ffffffffc0203f22:	3c071263          	bnez	a4,ffffffffc02042e6 <do_fork+0x402>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203f26:	4509                	li	a0,2
ffffffffc0203f28:	ea3fd0ef          	jal	ffffffffc0201dca <alloc_pages>
    if (page != NULL)
ffffffffc0203f2c:	2c050b63          	beqz	a0,ffffffffc0204202 <do_fork+0x31e>
ffffffffc0203f30:	fc4e                	sd	s3,56(sp)
    return page - pages + nbase;
ffffffffc0203f32:	000b1997          	auipc	s3,0xb1
ffffffffc0203f36:	70698993          	addi	s3,s3,1798 # ffffffffc02b5638 <pages>
ffffffffc0203f3a:	0009b783          	ld	a5,0(s3)
ffffffffc0203f3e:	f852                	sd	s4,48(sp)
ffffffffc0203f40:	00005a17          	auipc	s4,0x5
ffffffffc0203f44:	bc0a0a13          	addi	s4,s4,-1088 # ffffffffc0208b00 <nbase>
ffffffffc0203f48:	e466                	sd	s9,8(sp)
ffffffffc0203f4a:	000a3c83          	ld	s9,0(s4)
ffffffffc0203f4e:	40f506b3          	sub	a3,a0,a5
ffffffffc0203f52:	f456                	sd	s5,40(sp)
    return KADDR(page2pa(page));
ffffffffc0203f54:	000b1a97          	auipc	s5,0xb1
ffffffffc0203f58:	6dca8a93          	addi	s5,s5,1756 # ffffffffc02b5630 <npage>
ffffffffc0203f5c:	e862                	sd	s8,16(sp)
    return page - pages + nbase;
ffffffffc0203f5e:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0203f60:	5c7d                	li	s8,-1
ffffffffc0203f62:	000ab783          	ld	a5,0(s5)
    return page - pages + nbase;
ffffffffc0203f66:	96e6                	add	a3,a3,s9
    return KADDR(page2pa(page));
ffffffffc0203f68:	00cc5c13          	srli	s8,s8,0xc
ffffffffc0203f6c:	0186f733          	and	a4,a3,s8
ffffffffc0203f70:	ec5e                	sd	s7,24(sp)
    return page2ppn(page) << PGSHIFT;
ffffffffc0203f72:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203f74:	30f77863          	bgeu	a4,a5,ffffffffc0204284 <do_fork+0x3a0>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0203f78:	000b3703          	ld	a4,0(s6)
ffffffffc0203f7c:	000b1b17          	auipc	s6,0xb1
ffffffffc0203f80:	6acb0b13          	addi	s6,s6,1708 # ffffffffc02b5628 <va_pa_offset>
ffffffffc0203f84:	000b3783          	ld	a5,0(s6)
ffffffffc0203f88:	02873b83          	ld	s7,40(a4)
ffffffffc0203f8c:	96be                	add	a3,a3,a5
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0203f8e:	e814                	sd	a3,16(s0)
    if (oldmm == NULL)
ffffffffc0203f90:	020b8863          	beqz	s7,ffffffffc0203fc0 <do_fork+0xdc>
    if (clone_flags & CLONE_VM)
ffffffffc0203f94:	100d7793          	andi	a5,s10,256
ffffffffc0203f98:	18078b63          	beqz	a5,ffffffffc020412e <do_fork+0x24a>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc0203f9c:	030ba703          	lw	a4,48(s7)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0203fa0:	018bb783          	ld	a5,24(s7)
ffffffffc0203fa4:	c02006b7          	lui	a3,0xc0200
ffffffffc0203fa8:	2705                	addiw	a4,a4,1
ffffffffc0203faa:	02eba823          	sw	a4,48(s7)
    proc->mm = mm;
ffffffffc0203fae:	03743423          	sd	s7,40(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0203fb2:	2ed7e563          	bltu	a5,a3,ffffffffc020429c <do_fork+0x3b8>
ffffffffc0203fb6:	000b3703          	ld	a4,0(s6)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0203fba:	6814                	ld	a3,16(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0203fbc:	8f99                	sub	a5,a5,a4
ffffffffc0203fbe:	f45c                	sd	a5,168(s0)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0203fc0:	6789                	lui	a5,0x2
ffffffffc0203fc2:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_softint_out_size-0x7048>
ffffffffc0203fc6:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc0203fc8:	8626                	mv	a2,s1
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0203fca:	f054                	sd	a3,160(s0)
    *(proc->tf) = *tf;
ffffffffc0203fcc:	87b6                	mv	a5,a3
ffffffffc0203fce:	12048713          	addi	a4,s1,288
ffffffffc0203fd2:	6a0c                	ld	a1,16(a2)
ffffffffc0203fd4:	00063803          	ld	a6,0(a2)
ffffffffc0203fd8:	6608                	ld	a0,8(a2)
ffffffffc0203fda:	eb8c                	sd	a1,16(a5)
ffffffffc0203fdc:	0107b023          	sd	a6,0(a5)
ffffffffc0203fe0:	e788                	sd	a0,8(a5)
ffffffffc0203fe2:	6e0c                	ld	a1,24(a2)
ffffffffc0203fe4:	02060613          	addi	a2,a2,32
ffffffffc0203fe8:	02078793          	addi	a5,a5,32
ffffffffc0203fec:	feb7bc23          	sd	a1,-8(a5)
ffffffffc0203ff0:	fee611e3          	bne	a2,a4,ffffffffc0203fd2 <do_fork+0xee>
    proc->tf->gpr.a0 = 0;
ffffffffc0203ff4:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0203ff8:	20090b63          	beqz	s2,ffffffffc020420e <do_fork+0x32a>
ffffffffc0203ffc:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204000:	00000797          	auipc	a5,0x0
ffffffffc0204004:	dfe78793          	addi	a5,a5,-514 # ffffffffc0203dfe <forkret>
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204008:	fc14                	sd	a3,56(s0)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020400a:	f81c                	sd	a5,48(s0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020400c:	100027f3          	csrr	a5,sstatus
ffffffffc0204010:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204012:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204014:	20079c63          	bnez	a5,ffffffffc020422c <do_fork+0x348>
    if (++last_pid >= MAX_PID)
ffffffffc0204018:	000ad517          	auipc	a0,0xad
ffffffffc020401c:	16c52503          	lw	a0,364(a0) # ffffffffc02b1184 <last_pid.1>
ffffffffc0204020:	6789                	lui	a5,0x2
ffffffffc0204022:	2505                	addiw	a0,a0,1
ffffffffc0204024:	000ad717          	auipc	a4,0xad
ffffffffc0204028:	16a72023          	sw	a0,352(a4) # ffffffffc02b1184 <last_pid.1>
ffffffffc020402c:	20f55f63          	bge	a0,a5,ffffffffc020424a <do_fork+0x366>
    if (last_pid >= next_safe)
ffffffffc0204030:	000ad797          	auipc	a5,0xad
ffffffffc0204034:	1507a783          	lw	a5,336(a5) # ffffffffc02b1180 <next_safe.0>
ffffffffc0204038:	000b1497          	auipc	s1,0xb1
ffffffffc020403c:	56848493          	addi	s1,s1,1384 # ffffffffc02b55a0 <proc_list>
ffffffffc0204040:	06f54563          	blt	a0,a5,ffffffffc02040aa <do_fork+0x1c6>
    return listelm->next;
ffffffffc0204044:	000b1497          	auipc	s1,0xb1
ffffffffc0204048:	55c48493          	addi	s1,s1,1372 # ffffffffc02b55a0 <proc_list>
ffffffffc020404c:	0084b883          	ld	a7,8(s1)
        next_safe = MAX_PID;
ffffffffc0204050:	6789                	lui	a5,0x2
ffffffffc0204052:	000ad717          	auipc	a4,0xad
ffffffffc0204056:	12f72723          	sw	a5,302(a4) # ffffffffc02b1180 <next_safe.0>
ffffffffc020405a:	86aa                	mv	a3,a0
ffffffffc020405c:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc020405e:	04988063          	beq	a7,s1,ffffffffc020409e <do_fork+0x1ba>
ffffffffc0204062:	882e                	mv	a6,a1
ffffffffc0204064:	87c6                	mv	a5,a7
ffffffffc0204066:	6609                	lui	a2,0x2
ffffffffc0204068:	a811                	j	ffffffffc020407c <do_fork+0x198>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc020406a:	00e6d663          	bge	a3,a4,ffffffffc0204076 <do_fork+0x192>
ffffffffc020406e:	00c75463          	bge	a4,a2,ffffffffc0204076 <do_fork+0x192>
                next_safe = proc->pid;
ffffffffc0204072:	863a                	mv	a2,a4
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204074:	4805                	li	a6,1
ffffffffc0204076:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204078:	00978d63          	beq	a5,s1,ffffffffc0204092 <do_fork+0x1ae>
            if (proc->pid == last_pid)
ffffffffc020407c:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_softint_out_size-0x6fec>
ffffffffc0204080:	fed715e3          	bne	a4,a3,ffffffffc020406a <do_fork+0x186>
                if (++last_pid >= next_safe)
ffffffffc0204084:	2685                	addiw	a3,a3,1
ffffffffc0204086:	1cc6db63          	bge	a3,a2,ffffffffc020425c <do_fork+0x378>
ffffffffc020408a:	679c                	ld	a5,8(a5)
ffffffffc020408c:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc020408e:	fe9797e3          	bne	a5,s1,ffffffffc020407c <do_fork+0x198>
ffffffffc0204092:	00080663          	beqz	a6,ffffffffc020409e <do_fork+0x1ba>
ffffffffc0204096:	000ad797          	auipc	a5,0xad
ffffffffc020409a:	0ec7a523          	sw	a2,234(a5) # ffffffffc02b1180 <next_safe.0>
ffffffffc020409e:	c591                	beqz	a1,ffffffffc02040aa <do_fork+0x1c6>
ffffffffc02040a0:	000ad797          	auipc	a5,0xad
ffffffffc02040a4:	0ed7a223          	sw	a3,228(a5) # ffffffffc02b1184 <last_pid.1>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02040a8:	8536                	mv	a0,a3
    
    //    5. insert proc_struct into hash_list && proc_list
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        proc->pid = get_pid();
ffffffffc02040aa:	c048                	sw	a0,4(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc02040ac:	45a9                	li	a1,10
ffffffffc02040ae:	501010ef          	jal	ffffffffc0205dae <hash32>
ffffffffc02040b2:	02051793          	slli	a5,a0,0x20
ffffffffc02040b6:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02040ba:	000ad797          	auipc	a5,0xad
ffffffffc02040be:	4e678793          	addi	a5,a5,1254 # ffffffffc02b15a0 <hash_list>
ffffffffc02040c2:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc02040c4:	6518                	ld	a4,8(a0)
ffffffffc02040c6:	0d840793          	addi	a5,s0,216
ffffffffc02040ca:	6490                	ld	a2,8(s1)
    prev->next = next->prev = elm;
ffffffffc02040cc:	e31c                	sd	a5,0(a4)
ffffffffc02040ce:	e51c                	sd	a5,8(a0)
    elm->next = next;
ffffffffc02040d0:	f078                	sd	a4,224(s0)
    list_add(&proc_list, &(proc->list_link));
ffffffffc02040d2:	0c840793          	addi	a5,s0,200
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc02040d6:	7018                	ld	a4,32(s0)
    elm->prev = prev;
ffffffffc02040d8:	ec68                	sd	a0,216(s0)
    prev->next = next->prev = elm;
ffffffffc02040da:	e21c                	sd	a5,0(a2)
    proc->yptr = NULL;
ffffffffc02040dc:	0e043c23          	sd	zero,248(s0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc02040e0:	7b74                	ld	a3,240(a4)
ffffffffc02040e2:	e49c                	sd	a5,8(s1)
    elm->next = next;
ffffffffc02040e4:	e870                	sd	a2,208(s0)
    elm->prev = prev;
ffffffffc02040e6:	e464                	sd	s1,200(s0)
ffffffffc02040e8:	10d43023          	sd	a3,256(s0)
ffffffffc02040ec:	c299                	beqz	a3,ffffffffc02040f2 <do_fork+0x20e>
        proc->optr->yptr = proc;
ffffffffc02040ee:	fee0                	sd	s0,248(a3)
    proc->parent->cptr = proc;
ffffffffc02040f0:	7018                	ld	a4,32(s0)
    nr_process++;
ffffffffc02040f2:	000b1797          	auipc	a5,0xb1
ffffffffc02040f6:	54e7a783          	lw	a5,1358(a5) # ffffffffc02b5640 <nr_process>
    proc->parent->cptr = proc;
ffffffffc02040fa:	fb60                	sd	s0,240(a4)
    nr_process++;
ffffffffc02040fc:	2785                	addiw	a5,a5,1
ffffffffc02040fe:	000b1717          	auipc	a4,0xb1
ffffffffc0204102:	54f72123          	sw	a5,1346(a4) # ffffffffc02b5640 <nr_process>
    if (flag)
ffffffffc0204106:	14091863          	bnez	s2,ffffffffc0204256 <do_fork+0x372>
        set_links(proc);
    }
    local_intr_restore(intr_flag);
    
    //    6. call wakeup_proc to make the new child process RUNNABLE
    wakeup_proc(proc);
ffffffffc020410a:	8522                	mv	a0,s0
ffffffffc020410c:	249010ef          	jal	ffffffffc0205b54 <wakeup_proc>
    //    7. set ret vaule using child proc's pid
    ret = proc->pid;
ffffffffc0204110:	4048                	lw	a0,4(s0)
ffffffffc0204112:	79e2                	ld	s3,56(sp)
ffffffffc0204114:	7a42                	ld	s4,48(sp)
ffffffffc0204116:	7aa2                	ld	s5,40(sp)
ffffffffc0204118:	7b02                	ld	s6,32(sp)
ffffffffc020411a:	6be2                	ld	s7,24(sp)
ffffffffc020411c:	6c42                	ld	s8,16(sp)
ffffffffc020411e:	6ca2                	ld	s9,8(sp)
bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
ffffffffc0204120:	60e6                	ld	ra,88(sp)
ffffffffc0204122:	6446                	ld	s0,80(sp)
ffffffffc0204124:	64a6                	ld	s1,72(sp)
ffffffffc0204126:	6906                	ld	s2,64(sp)
ffffffffc0204128:	6d02                	ld	s10,0(sp)
ffffffffc020412a:	6125                	addi	sp,sp,96
ffffffffc020412c:	8082                	ret
    if ((mm = mm_create()) == NULL)
ffffffffc020412e:	cfeff0ef          	jal	ffffffffc020362c <mm_create>
ffffffffc0204132:	8d2a                	mv	s10,a0
ffffffffc0204134:	c949                	beqz	a0,ffffffffc02041c6 <do_fork+0x2e2>
    if ((page = alloc_page()) == NULL)
ffffffffc0204136:	4505                	li	a0,1
ffffffffc0204138:	c93fd0ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc020413c:	c151                	beqz	a0,ffffffffc02041c0 <do_fork+0x2dc>
    return page - pages + nbase;
ffffffffc020413e:	0009b703          	ld	a4,0(s3)
    return KADDR(page2pa(page));
ffffffffc0204142:	000ab783          	ld	a5,0(s5)
    return page - pages + nbase;
ffffffffc0204146:	40e506b3          	sub	a3,a0,a4
ffffffffc020414a:	8699                	srai	a3,a3,0x6
ffffffffc020414c:	96e6                	add	a3,a3,s9
    return KADDR(page2pa(page));
ffffffffc020414e:	0186fc33          	and	s8,a3,s8
    return page2ppn(page) << PGSHIFT;
ffffffffc0204152:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204154:	1afc7f63          	bgeu	s8,a5,ffffffffc0204312 <do_fork+0x42e>
ffffffffc0204158:	000b3783          	ld	a5,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc020415c:	000b1597          	auipc	a1,0xb1
ffffffffc0204160:	4c45b583          	ld	a1,1220(a1) # ffffffffc02b5620 <boot_pgdir_va>
ffffffffc0204164:	6605                	lui	a2,0x1
ffffffffc0204166:	00f68c33          	add	s8,a3,a5
ffffffffc020416a:	8562                	mv	a0,s8
ffffffffc020416c:	0ea020ef          	jal	ffffffffc0206256 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc0204170:	038b8c93          	addi	s9,s7,56
    mm->pgdir = pgdir;
ffffffffc0204174:	018d3c23          	sd	s8,24(s10) # fffffffffff80018 <end+0x3fcca9a8>
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204178:	4c05                	li	s8,1
ffffffffc020417a:	418cb7af          	amoor.d	a5,s8,(s9)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc020417e:	03f79713          	slli	a4,a5,0x3f
ffffffffc0204182:	03f75793          	srli	a5,a4,0x3f
ffffffffc0204186:	cb91                	beqz	a5,ffffffffc020419a <do_fork+0x2b6>
    {
        schedule();
ffffffffc0204188:	273010ef          	jal	ffffffffc0205bfa <schedule>
ffffffffc020418c:	418cb7af          	amoor.d	a5,s8,(s9)
    while (!try_lock(lock))
ffffffffc0204190:	03f79713          	slli	a4,a5,0x3f
ffffffffc0204194:	03f75793          	srli	a5,a4,0x3f
ffffffffc0204198:	fbe5                	bnez	a5,ffffffffc0204188 <do_fork+0x2a4>
        ret = dup_mmap(mm, oldmm);
ffffffffc020419a:	85de                	mv	a1,s7
ffffffffc020419c:	856a                	mv	a0,s10
ffffffffc020419e:	eeaff0ef          	jal	ffffffffc0203888 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02041a2:	57f9                	li	a5,-2
ffffffffc02041a4:	60fcb7af          	amoand.d	a5,a5,(s9)
ffffffffc02041a8:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc02041aa:	12078263          	beqz	a5,ffffffffc02042ce <do_fork+0x3ea>
    if ((mm = mm_create()) == NULL)
ffffffffc02041ae:	8bea                	mv	s7,s10
    if (ret != 0)
ffffffffc02041b0:	de0506e3          	beqz	a0,ffffffffc0203f9c <do_fork+0xb8>
    exit_mmap(mm);
ffffffffc02041b4:	856a                	mv	a0,s10
ffffffffc02041b6:	f6aff0ef          	jal	ffffffffc0203920 <exit_mmap>
    put_pgdir(mm);
ffffffffc02041ba:	856a                	mv	a0,s10
ffffffffc02041bc:	c51ff0ef          	jal	ffffffffc0203e0c <put_pgdir>
    mm_destroy(mm);
ffffffffc02041c0:	856a                	mv	a0,s10
ffffffffc02041c2:	da8ff0ef          	jal	ffffffffc020376a <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02041c6:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc02041c8:	c02007b7          	lui	a5,0xc0200
ffffffffc02041cc:	0ef6e563          	bltu	a3,a5,ffffffffc02042b6 <do_fork+0x3d2>
ffffffffc02041d0:	000b3783          	ld	a5,0(s6)
    if (PPN(pa) >= npage)
ffffffffc02041d4:	000ab703          	ld	a4,0(s5)
    return pa2page(PADDR(kva));
ffffffffc02041d8:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02041dc:	83b1                	srli	a5,a5,0xc
ffffffffc02041de:	08e7f763          	bgeu	a5,a4,ffffffffc020426c <do_fork+0x388>
    return &pages[PPN(pa) - nbase];
ffffffffc02041e2:	000a3703          	ld	a4,0(s4)
ffffffffc02041e6:	0009b503          	ld	a0,0(s3)
ffffffffc02041ea:	4589                	li	a1,2
ffffffffc02041ec:	8f99                	sub	a5,a5,a4
ffffffffc02041ee:	079a                	slli	a5,a5,0x6
ffffffffc02041f0:	953e                	add	a0,a0,a5
ffffffffc02041f2:	c13fd0ef          	jal	ffffffffc0201e04 <free_pages>
}
ffffffffc02041f6:	79e2                	ld	s3,56(sp)
ffffffffc02041f8:	7a42                	ld	s4,48(sp)
ffffffffc02041fa:	7aa2                	ld	s5,40(sp)
ffffffffc02041fc:	6be2                	ld	s7,24(sp)
ffffffffc02041fe:	6c42                	ld	s8,16(sp)
ffffffffc0204200:	6ca2                	ld	s9,8(sp)
    kfree(proc);
ffffffffc0204202:	8522                	mv	a0,s0
ffffffffc0204204:	aabfd0ef          	jal	ffffffffc0201cae <kfree>
ffffffffc0204208:	7b02                	ld	s6,32(sp)
    ret = -E_NO_MEM;
ffffffffc020420a:	5571                	li	a0,-4
    return ret;
ffffffffc020420c:	bf11                	j	ffffffffc0204120 <do_fork+0x23c>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020420e:	8936                	mv	s2,a3
ffffffffc0204210:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204214:	00000797          	auipc	a5,0x0
ffffffffc0204218:	bea78793          	addi	a5,a5,-1046 # ffffffffc0203dfe <forkret>
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc020421c:	fc14                	sd	a3,56(s0)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020421e:	f81c                	sd	a5,48(s0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204220:	100027f3          	csrr	a5,sstatus
ffffffffc0204224:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204226:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204228:	de0788e3          	beqz	a5,ffffffffc0204018 <do_fork+0x134>
        intr_disable();
ffffffffc020422c:	edefc0ef          	jal	ffffffffc020090a <intr_disable>
    if (++last_pid >= MAX_PID)
ffffffffc0204230:	000ad517          	auipc	a0,0xad
ffffffffc0204234:	f5452503          	lw	a0,-172(a0) # ffffffffc02b1184 <last_pid.1>
ffffffffc0204238:	6789                	lui	a5,0x2
        return 1;
ffffffffc020423a:	4905                	li	s2,1
ffffffffc020423c:	2505                	addiw	a0,a0,1
ffffffffc020423e:	000ad717          	auipc	a4,0xad
ffffffffc0204242:	f4a72323          	sw	a0,-186(a4) # ffffffffc02b1184 <last_pid.1>
ffffffffc0204246:	def545e3          	blt	a0,a5,ffffffffc0204030 <do_fork+0x14c>
        last_pid = 1;
ffffffffc020424a:	4505                	li	a0,1
ffffffffc020424c:	000ad797          	auipc	a5,0xad
ffffffffc0204250:	f2a7ac23          	sw	a0,-200(a5) # ffffffffc02b1184 <last_pid.1>
        goto inside;
ffffffffc0204254:	bbc5                	j	ffffffffc0204044 <do_fork+0x160>
        intr_enable();
ffffffffc0204256:	eaefc0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc020425a:	bd45                	j	ffffffffc020410a <do_fork+0x226>
                    if (last_pid >= MAX_PID)
ffffffffc020425c:	6789                	lui	a5,0x2
ffffffffc020425e:	00f6c363          	blt	a3,a5,ffffffffc0204264 <do_fork+0x380>
                        last_pid = 1;
ffffffffc0204262:	4685                	li	a3,1
                    goto repeat;
ffffffffc0204264:	4585                	li	a1,1
ffffffffc0204266:	bbe5                	j	ffffffffc020405e <do_fork+0x17a>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204268:	556d                	li	a0,-5
}
ffffffffc020426a:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc020426c:	00003617          	auipc	a2,0x3
ffffffffc0204270:	e6c60613          	addi	a2,a2,-404 # ffffffffc02070d8 <etext+0xe6a>
ffffffffc0204274:	06900593          	li	a1,105
ffffffffc0204278:	00003517          	auipc	a0,0x3
ffffffffc020427c:	db850513          	addi	a0,a0,-584 # ffffffffc0207030 <etext+0xdc2>
ffffffffc0204280:	9cafc0ef          	jal	ffffffffc020044a <__panic>
    return KADDR(page2pa(page));
ffffffffc0204284:	00003617          	auipc	a2,0x3
ffffffffc0204288:	d8460613          	addi	a2,a2,-636 # ffffffffc0207008 <etext+0xd9a>
ffffffffc020428c:	07100593          	li	a1,113
ffffffffc0204290:	00003517          	auipc	a0,0x3
ffffffffc0204294:	da050513          	addi	a0,a0,-608 # ffffffffc0207030 <etext+0xdc2>
ffffffffc0204298:	9b2fc0ef          	jal	ffffffffc020044a <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020429c:	86be                	mv	a3,a5
ffffffffc020429e:	00003617          	auipc	a2,0x3
ffffffffc02042a2:	e1260613          	addi	a2,a2,-494 # ffffffffc02070b0 <etext+0xe42>
ffffffffc02042a6:	19700593          	li	a1,407
ffffffffc02042aa:	00003517          	auipc	a0,0x3
ffffffffc02042ae:	74e50513          	addi	a0,a0,1870 # ffffffffc02079f8 <etext+0x178a>
ffffffffc02042b2:	998fc0ef          	jal	ffffffffc020044a <__panic>
    return pa2page(PADDR(kva));
ffffffffc02042b6:	00003617          	auipc	a2,0x3
ffffffffc02042ba:	dfa60613          	addi	a2,a2,-518 # ffffffffc02070b0 <etext+0xe42>
ffffffffc02042be:	07700593          	li	a1,119
ffffffffc02042c2:	00003517          	auipc	a0,0x3
ffffffffc02042c6:	d6e50513          	addi	a0,a0,-658 # ffffffffc0207030 <etext+0xdc2>
ffffffffc02042ca:	980fc0ef          	jal	ffffffffc020044a <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc02042ce:	00003617          	auipc	a2,0x3
ffffffffc02042d2:	74260613          	addi	a2,a2,1858 # ffffffffc0207a10 <etext+0x17a2>
ffffffffc02042d6:	04000593          	li	a1,64
ffffffffc02042da:	00003517          	auipc	a0,0x3
ffffffffc02042de:	74650513          	addi	a0,a0,1862 # ffffffffc0207a20 <etext+0x17b2>
ffffffffc02042e2:	968fc0ef          	jal	ffffffffc020044a <__panic>
    assert(current->wait_state == 0);
ffffffffc02042e6:	00003697          	auipc	a3,0x3
ffffffffc02042ea:	6f268693          	addi	a3,a3,1778 # ffffffffc02079d8 <etext+0x176a>
ffffffffc02042ee:	00003617          	auipc	a2,0x3
ffffffffc02042f2:	96a60613          	addi	a2,a2,-1686 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02042f6:	1d700593          	li	a1,471
ffffffffc02042fa:	00003517          	auipc	a0,0x3
ffffffffc02042fe:	6fe50513          	addi	a0,a0,1790 # ffffffffc02079f8 <etext+0x178a>
ffffffffc0204302:	fc4e                	sd	s3,56(sp)
ffffffffc0204304:	f852                	sd	s4,48(sp)
ffffffffc0204306:	f456                	sd	s5,40(sp)
ffffffffc0204308:	ec5e                	sd	s7,24(sp)
ffffffffc020430a:	e862                	sd	s8,16(sp)
ffffffffc020430c:	e466                	sd	s9,8(sp)
ffffffffc020430e:	93cfc0ef          	jal	ffffffffc020044a <__panic>
    return KADDR(page2pa(page));
ffffffffc0204312:	00003617          	auipc	a2,0x3
ffffffffc0204316:	cf660613          	addi	a2,a2,-778 # ffffffffc0207008 <etext+0xd9a>
ffffffffc020431a:	07100593          	li	a1,113
ffffffffc020431e:	00003517          	auipc	a0,0x3
ffffffffc0204322:	d1250513          	addi	a0,a0,-750 # ffffffffc0207030 <etext+0xdc2>
ffffffffc0204326:	924fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020432a <kernel_thread>:
{
ffffffffc020432a:	7129                	addi	sp,sp,-320
ffffffffc020432c:	fa22                	sd	s0,304(sp)
ffffffffc020432e:	f626                	sd	s1,296(sp)
ffffffffc0204330:	f24a                	sd	s2,288(sp)
ffffffffc0204332:	842a                	mv	s0,a0
ffffffffc0204334:	84ae                	mv	s1,a1
ffffffffc0204336:	8932                	mv	s2,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204338:	850a                	mv	a0,sp
ffffffffc020433a:	12000613          	li	a2,288
ffffffffc020433e:	4581                	li	a1,0
{
ffffffffc0204340:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204342:	703010ef          	jal	ffffffffc0206244 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc0204346:	e0a2                	sd	s0,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc0204348:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc020434a:	100027f3          	csrr	a5,sstatus
ffffffffc020434e:	edd7f793          	andi	a5,a5,-291
ffffffffc0204352:	1207e793          	ori	a5,a5,288
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204356:	860a                	mv	a2,sp
ffffffffc0204358:	10096513          	ori	a0,s2,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020435c:	00000717          	auipc	a4,0x0
ffffffffc0204360:	a0070713          	addi	a4,a4,-1536 # ffffffffc0203d5c <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204364:	4581                	li	a1,0
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0204366:	e23e                	sd	a5,256(sp)
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204368:	e63a                	sd	a4,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020436a:	b7bff0ef          	jal	ffffffffc0203ee4 <do_fork>
}
ffffffffc020436e:	70f2                	ld	ra,312(sp)
ffffffffc0204370:	7452                	ld	s0,304(sp)
ffffffffc0204372:	74b2                	ld	s1,296(sp)
ffffffffc0204374:	7912                	ld	s2,288(sp)
ffffffffc0204376:	6131                	addi	sp,sp,320
ffffffffc0204378:	8082                	ret

ffffffffc020437a <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int do_exit(int error_code)
{
ffffffffc020437a:	7179                	addi	sp,sp,-48
ffffffffc020437c:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc020437e:	000b1417          	auipc	s0,0xb1
ffffffffc0204382:	2ca40413          	addi	s0,s0,714 # ffffffffc02b5648 <current>
ffffffffc0204386:	601c                	ld	a5,0(s0)
ffffffffc0204388:	000b1717          	auipc	a4,0xb1
ffffffffc020438c:	2d073703          	ld	a4,720(a4) # ffffffffc02b5658 <idleproc>
{
ffffffffc0204390:	f406                	sd	ra,40(sp)
ffffffffc0204392:	ec26                	sd	s1,24(sp)
    if (current == idleproc)
ffffffffc0204394:	0ce78b63          	beq	a5,a4,ffffffffc020446a <do_exit+0xf0>
    {
        panic("idleproc exit.\n");
    }
    if (current == initproc)
ffffffffc0204398:	000b1497          	auipc	s1,0xb1
ffffffffc020439c:	2b848493          	addi	s1,s1,696 # ffffffffc02b5650 <initproc>
ffffffffc02043a0:	6098                	ld	a4,0(s1)
ffffffffc02043a2:	e84a                	sd	s2,16(sp)
ffffffffc02043a4:	0ee78a63          	beq	a5,a4,ffffffffc0204498 <do_exit+0x11e>
ffffffffc02043a8:	892a                	mv	s2,a0
    {
        panic("initproc exit.\n");
    }
    struct mm_struct *mm = current->mm;
ffffffffc02043aa:	7788                	ld	a0,40(a5)
    if (mm != NULL)
ffffffffc02043ac:	c115                	beqz	a0,ffffffffc02043d0 <do_exit+0x56>
ffffffffc02043ae:	000b1797          	auipc	a5,0xb1
ffffffffc02043b2:	26a7b783          	ld	a5,618(a5) # ffffffffc02b5618 <boot_pgdir_pa>
ffffffffc02043b6:	577d                	li	a4,-1
ffffffffc02043b8:	177e                	slli	a4,a4,0x3f
ffffffffc02043ba:	83b1                	srli	a5,a5,0xc
ffffffffc02043bc:	8fd9                	or	a5,a5,a4
ffffffffc02043be:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc02043c2:	591c                	lw	a5,48(a0)
ffffffffc02043c4:	37fd                	addiw	a5,a5,-1
ffffffffc02043c6:	d91c                	sw	a5,48(a0)
    {
        lsatp(boot_pgdir_pa);
        if (mm_count_dec(mm) == 0)
ffffffffc02043c8:	cfd5                	beqz	a5,ffffffffc0204484 <do_exit+0x10a>
        {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        current->mm = NULL;
ffffffffc02043ca:	601c                	ld	a5,0(s0)
ffffffffc02043cc:	0207b423          	sd	zero,40(a5)
    }
    current->state = PROC_ZOMBIE;
ffffffffc02043d0:	470d                	li	a4,3
    current->exit_code = error_code;
ffffffffc02043d2:	0f27a423          	sw	s2,232(a5)
    current->state = PROC_ZOMBIE;
ffffffffc02043d6:	c398                	sw	a4,0(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02043d8:	100027f3          	csrr	a5,sstatus
ffffffffc02043dc:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02043de:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02043e0:	ebe1                	bnez	a5,ffffffffc02044b0 <do_exit+0x136>
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
    {
        proc = current->parent;
ffffffffc02043e2:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc02043e4:	800007b7          	lui	a5,0x80000
ffffffffc02043e8:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_matrix_out_size+0xffffffff7fff4ad1>
        proc = current->parent;
ffffffffc02043ea:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc02043ec:	0ec52703          	lw	a4,236(a0)
ffffffffc02043f0:	0cf70463          	beq	a4,a5,ffffffffc02044b8 <do_exit+0x13e>
        {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL)
ffffffffc02043f4:	6018                	ld	a4,0(s0)
            }
            proc->parent = initproc;
            initproc->cptr = proc;
            if (proc->state == PROC_ZOMBIE)
            {
                if (initproc->wait_state == WT_CHILD)
ffffffffc02043f6:	800005b7          	lui	a1,0x80000
ffffffffc02043fa:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_obj___user_matrix_out_size+0xffffffff7fff4ad1>
        while (current->cptr != NULL)
ffffffffc02043fc:	7b7c                	ld	a5,240(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02043fe:	460d                	li	a2,3
        while (current->cptr != NULL)
ffffffffc0204400:	e789                	bnez	a5,ffffffffc020440a <do_exit+0x90>
ffffffffc0204402:	a83d                	j	ffffffffc0204440 <do_exit+0xc6>
ffffffffc0204404:	6018                	ld	a4,0(s0)
ffffffffc0204406:	7b7c                	ld	a5,240(a4)
ffffffffc0204408:	cf85                	beqz	a5,ffffffffc0204440 <do_exit+0xc6>
            current->cptr = proc->optr;
ffffffffc020440a:	1007b683          	ld	a3,256(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc020440e:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc0204410:	fb74                	sd	a3,240(a4)
            proc->yptr = NULL;
ffffffffc0204412:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204416:	7978                	ld	a4,240(a0)
ffffffffc0204418:	10e7b023          	sd	a4,256(a5)
ffffffffc020441c:	c311                	beqz	a4,ffffffffc0204420 <do_exit+0xa6>
                initproc->cptr->yptr = proc;
ffffffffc020441e:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204420:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc0204422:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc0204424:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204426:	fcc71fe3          	bne	a4,a2,ffffffffc0204404 <do_exit+0x8a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc020442a:	0ec52783          	lw	a5,236(a0)
ffffffffc020442e:	fcb79be3          	bne	a5,a1,ffffffffc0204404 <do_exit+0x8a>
                {
                    wakeup_proc(initproc);
ffffffffc0204432:	722010ef          	jal	ffffffffc0205b54 <wakeup_proc>
ffffffffc0204436:	800005b7          	lui	a1,0x80000
ffffffffc020443a:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_obj___user_matrix_out_size+0xffffffff7fff4ad1>
ffffffffc020443c:	460d                	li	a2,3
ffffffffc020443e:	b7d9                	j	ffffffffc0204404 <do_exit+0x8a>
    if (flag)
ffffffffc0204440:	02091263          	bnez	s2,ffffffffc0204464 <do_exit+0xea>
                }
            }
        }
    }
    local_intr_restore(intr_flag);
    schedule();
ffffffffc0204444:	7b6010ef          	jal	ffffffffc0205bfa <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc0204448:	601c                	ld	a5,0(s0)
ffffffffc020444a:	00003617          	auipc	a2,0x3
ffffffffc020444e:	60e60613          	addi	a2,a2,1550 # ffffffffc0207a58 <etext+0x17ea>
ffffffffc0204452:	24000593          	li	a1,576
ffffffffc0204456:	43d4                	lw	a3,4(a5)
ffffffffc0204458:	00003517          	auipc	a0,0x3
ffffffffc020445c:	5a050513          	addi	a0,a0,1440 # ffffffffc02079f8 <etext+0x178a>
ffffffffc0204460:	febfb0ef          	jal	ffffffffc020044a <__panic>
        intr_enable();
ffffffffc0204464:	ca0fc0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0204468:	bff1                	j	ffffffffc0204444 <do_exit+0xca>
        panic("idleproc exit.\n");
ffffffffc020446a:	00003617          	auipc	a2,0x3
ffffffffc020446e:	5ce60613          	addi	a2,a2,1486 # ffffffffc0207a38 <etext+0x17ca>
ffffffffc0204472:	20c00593          	li	a1,524
ffffffffc0204476:	00003517          	auipc	a0,0x3
ffffffffc020447a:	58250513          	addi	a0,a0,1410 # ffffffffc02079f8 <etext+0x178a>
ffffffffc020447e:	e84a                	sd	s2,16(sp)
ffffffffc0204480:	fcbfb0ef          	jal	ffffffffc020044a <__panic>
            exit_mmap(mm);
ffffffffc0204484:	e42a                	sd	a0,8(sp)
ffffffffc0204486:	c9aff0ef          	jal	ffffffffc0203920 <exit_mmap>
            put_pgdir(mm);
ffffffffc020448a:	6522                	ld	a0,8(sp)
ffffffffc020448c:	981ff0ef          	jal	ffffffffc0203e0c <put_pgdir>
            mm_destroy(mm);
ffffffffc0204490:	6522                	ld	a0,8(sp)
ffffffffc0204492:	ad8ff0ef          	jal	ffffffffc020376a <mm_destroy>
ffffffffc0204496:	bf15                	j	ffffffffc02043ca <do_exit+0x50>
        panic("initproc exit.\n");
ffffffffc0204498:	00003617          	auipc	a2,0x3
ffffffffc020449c:	5b060613          	addi	a2,a2,1456 # ffffffffc0207a48 <etext+0x17da>
ffffffffc02044a0:	21000593          	li	a1,528
ffffffffc02044a4:	00003517          	auipc	a0,0x3
ffffffffc02044a8:	55450513          	addi	a0,a0,1364 # ffffffffc02079f8 <etext+0x178a>
ffffffffc02044ac:	f9ffb0ef          	jal	ffffffffc020044a <__panic>
        intr_disable();
ffffffffc02044b0:	c5afc0ef          	jal	ffffffffc020090a <intr_disable>
        return 1;
ffffffffc02044b4:	4905                	li	s2,1
ffffffffc02044b6:	b735                	j	ffffffffc02043e2 <do_exit+0x68>
            wakeup_proc(proc);
ffffffffc02044b8:	69c010ef          	jal	ffffffffc0205b54 <wakeup_proc>
ffffffffc02044bc:	bf25                	j	ffffffffc02043f4 <do_exit+0x7a>

ffffffffc02044be <do_wait.part.0>:
}

// do_wait - wait one OR any children with PROC_ZOMBIE state, and free memory space of kernel stack
//         - proc struct of this child.
// NOTE: only after do_wait function, all resources of the child proces are free.
int do_wait(int pid, int *code_store)
ffffffffc02044be:	7179                	addi	sp,sp,-48
ffffffffc02044c0:	ec26                	sd	s1,24(sp)
ffffffffc02044c2:	e84a                	sd	s2,16(sp)
ffffffffc02044c4:	e44e                	sd	s3,8(sp)
ffffffffc02044c6:	f406                	sd	ra,40(sp)
ffffffffc02044c8:	f022                	sd	s0,32(sp)
ffffffffc02044ca:	84aa                	mv	s1,a0
ffffffffc02044cc:	892e                	mv	s2,a1
ffffffffc02044ce:	000b1997          	auipc	s3,0xb1
ffffffffc02044d2:	17a98993          	addi	s3,s3,378 # ffffffffc02b5648 <current>

    struct proc_struct *proc;
    bool intr_flag, haskid;
repeat:
    haskid = 0;
    if (pid != 0)
ffffffffc02044d6:	cd19                	beqz	a0,ffffffffc02044f4 <do_wait.part.0+0x36>
    if (0 < pid && pid < MAX_PID)
ffffffffc02044d8:	6789                	lui	a5,0x2
ffffffffc02044da:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6f2a>
ffffffffc02044dc:	fff5071b          	addiw	a4,a0,-1
ffffffffc02044e0:	12e7f563          	bgeu	a5,a4,ffffffffc020460a <do_wait.part.0+0x14c>
    }
    local_intr_restore(intr_flag);
    put_kstack(proc);
    kfree(proc);
    return 0;
}
ffffffffc02044e4:	70a2                	ld	ra,40(sp)
ffffffffc02044e6:	7402                	ld	s0,32(sp)
ffffffffc02044e8:	64e2                	ld	s1,24(sp)
ffffffffc02044ea:	6942                	ld	s2,16(sp)
ffffffffc02044ec:	69a2                	ld	s3,8(sp)
    return -E_BAD_PROC;
ffffffffc02044ee:	5579                	li	a0,-2
}
ffffffffc02044f0:	6145                	addi	sp,sp,48
ffffffffc02044f2:	8082                	ret
        proc = current->cptr;
ffffffffc02044f4:	0009b703          	ld	a4,0(s3)
ffffffffc02044f8:	7b60                	ld	s0,240(a4)
        for (; proc != NULL; proc = proc->optr)
ffffffffc02044fa:	d46d                	beqz	s0,ffffffffc02044e4 <do_wait.part.0+0x26>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02044fc:	468d                	li	a3,3
ffffffffc02044fe:	a021                	j	ffffffffc0204506 <do_wait.part.0+0x48>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204500:	10043403          	ld	s0,256(s0)
ffffffffc0204504:	c075                	beqz	s0,ffffffffc02045e8 <do_wait.part.0+0x12a>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204506:	401c                	lw	a5,0(s0)
ffffffffc0204508:	fed79ce3          	bne	a5,a3,ffffffffc0204500 <do_wait.part.0+0x42>
    if (proc == idleproc || proc == initproc)
ffffffffc020450c:	000b1797          	auipc	a5,0xb1
ffffffffc0204510:	14c7b783          	ld	a5,332(a5) # ffffffffc02b5658 <idleproc>
ffffffffc0204514:	14878263          	beq	a5,s0,ffffffffc0204658 <do_wait.part.0+0x19a>
ffffffffc0204518:	000b1797          	auipc	a5,0xb1
ffffffffc020451c:	1387b783          	ld	a5,312(a5) # ffffffffc02b5650 <initproc>
ffffffffc0204520:	12f40c63          	beq	s0,a5,ffffffffc0204658 <do_wait.part.0+0x19a>
    if (code_store != NULL)
ffffffffc0204524:	00090663          	beqz	s2,ffffffffc0204530 <do_wait.part.0+0x72>
        *code_store = proc->exit_code;
ffffffffc0204528:	0e842783          	lw	a5,232(s0)
ffffffffc020452c:	00f92023          	sw	a5,0(s2)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204530:	100027f3          	csrr	a5,sstatus
ffffffffc0204534:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204536:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204538:	10079963          	bnez	a5,ffffffffc020464a <do_wait.part.0+0x18c>
    __list_del(listelm->prev, listelm->next);
ffffffffc020453c:	6c74                	ld	a3,216(s0)
ffffffffc020453e:	7078                	ld	a4,224(s0)
    if (proc->optr != NULL)
ffffffffc0204540:	10043783          	ld	a5,256(s0)
    prev->next = next;
ffffffffc0204544:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0204546:	e314                	sd	a3,0(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204548:	6474                	ld	a3,200(s0)
ffffffffc020454a:	6878                	ld	a4,208(s0)
    prev->next = next;
ffffffffc020454c:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc020454e:	e314                	sd	a3,0(a4)
ffffffffc0204550:	c789                	beqz	a5,ffffffffc020455a <do_wait.part.0+0x9c>
        proc->optr->yptr = proc->yptr;
ffffffffc0204552:	7c78                	ld	a4,248(s0)
ffffffffc0204554:	fff8                	sd	a4,248(a5)
        proc->yptr->optr = proc->optr;
ffffffffc0204556:	10043783          	ld	a5,256(s0)
    if (proc->yptr != NULL)
ffffffffc020455a:	7c78                	ld	a4,248(s0)
ffffffffc020455c:	c36d                	beqz	a4,ffffffffc020463e <do_wait.part.0+0x180>
        proc->yptr->optr = proc->optr;
ffffffffc020455e:	10f73023          	sd	a5,256(a4)
    nr_process--;
ffffffffc0204562:	000b1797          	auipc	a5,0xb1
ffffffffc0204566:	0de7a783          	lw	a5,222(a5) # ffffffffc02b5640 <nr_process>
ffffffffc020456a:	37fd                	addiw	a5,a5,-1
ffffffffc020456c:	000b1717          	auipc	a4,0xb1
ffffffffc0204570:	0cf72a23          	sw	a5,212(a4) # ffffffffc02b5640 <nr_process>
    if (flag)
ffffffffc0204574:	e271                	bnez	a2,ffffffffc0204638 <do_wait.part.0+0x17a>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204576:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc0204578:	c02007b7          	lui	a5,0xc0200
ffffffffc020457c:	10f6e663          	bltu	a3,a5,ffffffffc0204688 <do_wait.part.0+0x1ca>
ffffffffc0204580:	000b1717          	auipc	a4,0xb1
ffffffffc0204584:	0a873703          	ld	a4,168(a4) # ffffffffc02b5628 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0204588:	000b1797          	auipc	a5,0xb1
ffffffffc020458c:	0a87b783          	ld	a5,168(a5) # ffffffffc02b5630 <npage>
    return pa2page(PADDR(kva));
ffffffffc0204590:	8e99                	sub	a3,a3,a4
    if (PPN(pa) >= npage)
ffffffffc0204592:	82b1                	srli	a3,a3,0xc
ffffffffc0204594:	0cf6fe63          	bgeu	a3,a5,ffffffffc0204670 <do_wait.part.0+0x1b2>
    return &pages[PPN(pa) - nbase];
ffffffffc0204598:	00004797          	auipc	a5,0x4
ffffffffc020459c:	5687b783          	ld	a5,1384(a5) # ffffffffc0208b00 <nbase>
ffffffffc02045a0:	000b1517          	auipc	a0,0xb1
ffffffffc02045a4:	09853503          	ld	a0,152(a0) # ffffffffc02b5638 <pages>
ffffffffc02045a8:	4589                	li	a1,2
ffffffffc02045aa:	8e9d                	sub	a3,a3,a5
ffffffffc02045ac:	069a                	slli	a3,a3,0x6
ffffffffc02045ae:	9536                	add	a0,a0,a3
ffffffffc02045b0:	855fd0ef          	jal	ffffffffc0201e04 <free_pages>
    kfree(proc);
ffffffffc02045b4:	8522                	mv	a0,s0
ffffffffc02045b6:	ef8fd0ef          	jal	ffffffffc0201cae <kfree>
}
ffffffffc02045ba:	70a2                	ld	ra,40(sp)
ffffffffc02045bc:	7402                	ld	s0,32(sp)
ffffffffc02045be:	64e2                	ld	s1,24(sp)
ffffffffc02045c0:	6942                	ld	s2,16(sp)
ffffffffc02045c2:	69a2                	ld	s3,8(sp)
    return 0;
ffffffffc02045c4:	4501                	li	a0,0
}
ffffffffc02045c6:	6145                	addi	sp,sp,48
ffffffffc02045c8:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02045ca:	000b1997          	auipc	s3,0xb1
ffffffffc02045ce:	07e98993          	addi	s3,s3,126 # ffffffffc02b5648 <current>
ffffffffc02045d2:	0009b703          	ld	a4,0(s3)
ffffffffc02045d6:	f487b683          	ld	a3,-184(a5)
ffffffffc02045da:	f0e695e3          	bne	a3,a4,ffffffffc02044e4 <do_wait.part.0+0x26>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045de:	f287a603          	lw	a2,-216(a5)
ffffffffc02045e2:	468d                	li	a3,3
ffffffffc02045e4:	06d60063          	beq	a2,a3,ffffffffc0204644 <do_wait.part.0+0x186>
        current->wait_state = WT_CHILD;
ffffffffc02045e8:	800007b7          	lui	a5,0x80000
ffffffffc02045ec:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_matrix_out_size+0xffffffff7fff4ad1>
        current->state = PROC_SLEEPING;
ffffffffc02045ee:	4685                	li	a3,1
        current->wait_state = WT_CHILD;
ffffffffc02045f0:	0ef72623          	sw	a5,236(a4)
        current->state = PROC_SLEEPING;
ffffffffc02045f4:	c314                	sw	a3,0(a4)
        schedule();
ffffffffc02045f6:	604010ef          	jal	ffffffffc0205bfa <schedule>
        if (current->flags & PF_EXITING)
ffffffffc02045fa:	0009b783          	ld	a5,0(s3)
ffffffffc02045fe:	0b07a783          	lw	a5,176(a5)
ffffffffc0204602:	8b85                	andi	a5,a5,1
ffffffffc0204604:	e7b9                	bnez	a5,ffffffffc0204652 <do_wait.part.0+0x194>
    if (pid != 0)
ffffffffc0204606:	ee0487e3          	beqz	s1,ffffffffc02044f4 <do_wait.part.0+0x36>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc020460a:	45a9                	li	a1,10
ffffffffc020460c:	8526                	mv	a0,s1
ffffffffc020460e:	7a0010ef          	jal	ffffffffc0205dae <hash32>
ffffffffc0204612:	02051793          	slli	a5,a0,0x20
ffffffffc0204616:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020461a:	000ad797          	auipc	a5,0xad
ffffffffc020461e:	f8678793          	addi	a5,a5,-122 # ffffffffc02b15a0 <hash_list>
ffffffffc0204622:	953e                	add	a0,a0,a5
ffffffffc0204624:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204626:	a029                	j	ffffffffc0204630 <do_wait.part.0+0x172>
            if (proc->pid == pid)
ffffffffc0204628:	f2c7a703          	lw	a4,-212(a5)
ffffffffc020462c:	f8970fe3          	beq	a4,s1,ffffffffc02045ca <do_wait.part.0+0x10c>
    return listelm->next;
ffffffffc0204630:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204632:	fef51be3          	bne	a0,a5,ffffffffc0204628 <do_wait.part.0+0x16a>
ffffffffc0204636:	b57d                	j	ffffffffc02044e4 <do_wait.part.0+0x26>
        intr_enable();
ffffffffc0204638:	accfc0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc020463c:	bf2d                	j	ffffffffc0204576 <do_wait.part.0+0xb8>
        proc->parent->cptr = proc->optr;
ffffffffc020463e:	7018                	ld	a4,32(s0)
ffffffffc0204640:	fb7c                	sd	a5,240(a4)
ffffffffc0204642:	b705                	j	ffffffffc0204562 <do_wait.part.0+0xa4>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204644:	f2878413          	addi	s0,a5,-216
ffffffffc0204648:	b5d1                	j	ffffffffc020450c <do_wait.part.0+0x4e>
        intr_disable();
ffffffffc020464a:	ac0fc0ef          	jal	ffffffffc020090a <intr_disable>
        return 1;
ffffffffc020464e:	4605                	li	a2,1
ffffffffc0204650:	b5f5                	j	ffffffffc020453c <do_wait.part.0+0x7e>
            do_exit(-E_KILLED);
ffffffffc0204652:	555d                	li	a0,-9
ffffffffc0204654:	d27ff0ef          	jal	ffffffffc020437a <do_exit>
        panic("wait idleproc or initproc.\n");
ffffffffc0204658:	00003617          	auipc	a2,0x3
ffffffffc020465c:	42060613          	addi	a2,a2,1056 # ffffffffc0207a78 <etext+0x180a>
ffffffffc0204660:	36200593          	li	a1,866
ffffffffc0204664:	00003517          	auipc	a0,0x3
ffffffffc0204668:	39450513          	addi	a0,a0,916 # ffffffffc02079f8 <etext+0x178a>
ffffffffc020466c:	ddffb0ef          	jal	ffffffffc020044a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204670:	00003617          	auipc	a2,0x3
ffffffffc0204674:	a6860613          	addi	a2,a2,-1432 # ffffffffc02070d8 <etext+0xe6a>
ffffffffc0204678:	06900593          	li	a1,105
ffffffffc020467c:	00003517          	auipc	a0,0x3
ffffffffc0204680:	9b450513          	addi	a0,a0,-1612 # ffffffffc0207030 <etext+0xdc2>
ffffffffc0204684:	dc7fb0ef          	jal	ffffffffc020044a <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204688:	00003617          	auipc	a2,0x3
ffffffffc020468c:	a2860613          	addi	a2,a2,-1496 # ffffffffc02070b0 <etext+0xe42>
ffffffffc0204690:	07700593          	li	a1,119
ffffffffc0204694:	00003517          	auipc	a0,0x3
ffffffffc0204698:	99c50513          	addi	a0,a0,-1636 # ffffffffc0207030 <etext+0xdc2>
ffffffffc020469c:	daffb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02046a0 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc02046a0:	1141                	addi	sp,sp,-16
ffffffffc02046a2:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc02046a4:	f98fd0ef          	jal	ffffffffc0201e3c <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc02046a8:	d5cfd0ef          	jal	ffffffffc0201c04 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc02046ac:	4601                	li	a2,0
ffffffffc02046ae:	4581                	li	a1,0
ffffffffc02046b0:	00000517          	auipc	a0,0x0
ffffffffc02046b4:	6b050513          	addi	a0,a0,1712 # ffffffffc0204d60 <user_main>
ffffffffc02046b8:	c73ff0ef          	jal	ffffffffc020432a <kernel_thread>
    if (pid <= 0)
ffffffffc02046bc:	00a04563          	bgtz	a0,ffffffffc02046c6 <init_main+0x26>
ffffffffc02046c0:	a071                	j	ffffffffc020474c <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc02046c2:	538010ef          	jal	ffffffffc0205bfa <schedule>
    if (code_store != NULL)
ffffffffc02046c6:	4581                	li	a1,0
ffffffffc02046c8:	4501                	li	a0,0
ffffffffc02046ca:	df5ff0ef          	jal	ffffffffc02044be <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc02046ce:	d975                	beqz	a0,ffffffffc02046c2 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc02046d0:	00003517          	auipc	a0,0x3
ffffffffc02046d4:	3e850513          	addi	a0,a0,1000 # ffffffffc0207ab8 <etext+0x184a>
ffffffffc02046d8:	ac1fb0ef          	jal	ffffffffc0200198 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02046dc:	000b1797          	auipc	a5,0xb1
ffffffffc02046e0:	f747b783          	ld	a5,-140(a5) # ffffffffc02b5650 <initproc>
ffffffffc02046e4:	7bf8                	ld	a4,240(a5)
ffffffffc02046e6:	e339                	bnez	a4,ffffffffc020472c <init_main+0x8c>
ffffffffc02046e8:	7ff8                	ld	a4,248(a5)
ffffffffc02046ea:	e329                	bnez	a4,ffffffffc020472c <init_main+0x8c>
ffffffffc02046ec:	1007b703          	ld	a4,256(a5)
ffffffffc02046f0:	ef15                	bnez	a4,ffffffffc020472c <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc02046f2:	000b1697          	auipc	a3,0xb1
ffffffffc02046f6:	f4e6a683          	lw	a3,-178(a3) # ffffffffc02b5640 <nr_process>
ffffffffc02046fa:	4709                	li	a4,2
ffffffffc02046fc:	0ae69463          	bne	a3,a4,ffffffffc02047a4 <init_main+0x104>
ffffffffc0204700:	000b1697          	auipc	a3,0xb1
ffffffffc0204704:	ea068693          	addi	a3,a3,-352 # ffffffffc02b55a0 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204708:	6698                	ld	a4,8(a3)
ffffffffc020470a:	0c878793          	addi	a5,a5,200
ffffffffc020470e:	06f71b63          	bne	a4,a5,ffffffffc0204784 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204712:	629c                	ld	a5,0(a3)
ffffffffc0204714:	04f71863          	bne	a4,a5,ffffffffc0204764 <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc0204718:	00003517          	auipc	a0,0x3
ffffffffc020471c:	48850513          	addi	a0,a0,1160 # ffffffffc0207ba0 <etext+0x1932>
ffffffffc0204720:	a79fb0ef          	jal	ffffffffc0200198 <cprintf>
    return 0;
}
ffffffffc0204724:	60a2                	ld	ra,8(sp)
ffffffffc0204726:	4501                	li	a0,0
ffffffffc0204728:	0141                	addi	sp,sp,16
ffffffffc020472a:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc020472c:	00003697          	auipc	a3,0x3
ffffffffc0204730:	3b468693          	addi	a3,a3,948 # ffffffffc0207ae0 <etext+0x1872>
ffffffffc0204734:	00002617          	auipc	a2,0x2
ffffffffc0204738:	52460613          	addi	a2,a2,1316 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc020473c:	3ce00593          	li	a1,974
ffffffffc0204740:	00003517          	auipc	a0,0x3
ffffffffc0204744:	2b850513          	addi	a0,a0,696 # ffffffffc02079f8 <etext+0x178a>
ffffffffc0204748:	d03fb0ef          	jal	ffffffffc020044a <__panic>
        panic("create user_main failed.\n");
ffffffffc020474c:	00003617          	auipc	a2,0x3
ffffffffc0204750:	34c60613          	addi	a2,a2,844 # ffffffffc0207a98 <etext+0x182a>
ffffffffc0204754:	3c500593          	li	a1,965
ffffffffc0204758:	00003517          	auipc	a0,0x3
ffffffffc020475c:	2a050513          	addi	a0,a0,672 # ffffffffc02079f8 <etext+0x178a>
ffffffffc0204760:	cebfb0ef          	jal	ffffffffc020044a <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204764:	00003697          	auipc	a3,0x3
ffffffffc0204768:	40c68693          	addi	a3,a3,1036 # ffffffffc0207b70 <etext+0x1902>
ffffffffc020476c:	00002617          	auipc	a2,0x2
ffffffffc0204770:	4ec60613          	addi	a2,a2,1260 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0204774:	3d100593          	li	a1,977
ffffffffc0204778:	00003517          	auipc	a0,0x3
ffffffffc020477c:	28050513          	addi	a0,a0,640 # ffffffffc02079f8 <etext+0x178a>
ffffffffc0204780:	ccbfb0ef          	jal	ffffffffc020044a <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204784:	00003697          	auipc	a3,0x3
ffffffffc0204788:	3bc68693          	addi	a3,a3,956 # ffffffffc0207b40 <etext+0x18d2>
ffffffffc020478c:	00002617          	auipc	a2,0x2
ffffffffc0204790:	4cc60613          	addi	a2,a2,1228 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0204794:	3d000593          	li	a1,976
ffffffffc0204798:	00003517          	auipc	a0,0x3
ffffffffc020479c:	26050513          	addi	a0,a0,608 # ffffffffc02079f8 <etext+0x178a>
ffffffffc02047a0:	cabfb0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_process == 2);
ffffffffc02047a4:	00003697          	auipc	a3,0x3
ffffffffc02047a8:	38c68693          	addi	a3,a3,908 # ffffffffc0207b30 <etext+0x18c2>
ffffffffc02047ac:	00002617          	auipc	a2,0x2
ffffffffc02047b0:	4ac60613          	addi	a2,a2,1196 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02047b4:	3cf00593          	li	a1,975
ffffffffc02047b8:	00003517          	auipc	a0,0x3
ffffffffc02047bc:	24050513          	addi	a0,a0,576 # ffffffffc02079f8 <etext+0x178a>
ffffffffc02047c0:	c8bfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02047c4 <do_execve>:
{
ffffffffc02047c4:	7171                	addi	sp,sp,-176
ffffffffc02047c6:	e8ea                	sd	s10,80(sp)
    struct mm_struct *mm = current->mm;
ffffffffc02047c8:	000b1d17          	auipc	s10,0xb1
ffffffffc02047cc:	e80d0d13          	addi	s10,s10,-384 # ffffffffc02b5648 <current>
ffffffffc02047d0:	000d3783          	ld	a5,0(s10)
{
ffffffffc02047d4:	e94a                	sd	s2,144(sp)
ffffffffc02047d6:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc02047d8:	0287b903          	ld	s2,40(a5)
{
ffffffffc02047dc:	84ae                	mv	s1,a1
ffffffffc02047de:	e54e                	sd	s3,136(sp)
ffffffffc02047e0:	ec32                	sd	a2,24(sp)
ffffffffc02047e2:	89aa                	mv	s3,a0
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc02047e4:	85aa                	mv	a1,a0
ffffffffc02047e6:	8626                	mv	a2,s1
ffffffffc02047e8:	854a                	mv	a0,s2
ffffffffc02047ea:	4681                	li	a3,0
{
ffffffffc02047ec:	f506                	sd	ra,168(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc02047ee:	ccaff0ef          	jal	ffffffffc0203cb8 <user_mem_check>
ffffffffc02047f2:	46050f63          	beqz	a0,ffffffffc0204c70 <do_execve+0x4ac>
    memset(local_name, 0, sizeof(local_name));
ffffffffc02047f6:	4641                	li	a2,16
ffffffffc02047f8:	1808                	addi	a0,sp,48
ffffffffc02047fa:	4581                	li	a1,0
ffffffffc02047fc:	249010ef          	jal	ffffffffc0206244 <memset>
    if (len > PROC_NAME_LEN)
ffffffffc0204800:	47bd                	li	a5,15
ffffffffc0204802:	8626                	mv	a2,s1
ffffffffc0204804:	0e97ef63          	bltu	a5,s1,ffffffffc0204902 <do_execve+0x13e>
    memcpy(local_name, name, len);
ffffffffc0204808:	85ce                	mv	a1,s3
ffffffffc020480a:	1808                	addi	a0,sp,48
ffffffffc020480c:	24b010ef          	jal	ffffffffc0206256 <memcpy>
    if (mm != NULL)
ffffffffc0204810:	10090063          	beqz	s2,ffffffffc0204910 <do_execve+0x14c>
        cputs("mm != NULL");
ffffffffc0204814:	00003517          	auipc	a0,0x3
ffffffffc0204818:	fec50513          	addi	a0,a0,-20 # ffffffffc0207800 <etext+0x1592>
ffffffffc020481c:	9b3fb0ef          	jal	ffffffffc02001ce <cputs>
ffffffffc0204820:	000b1797          	auipc	a5,0xb1
ffffffffc0204824:	df87b783          	ld	a5,-520(a5) # ffffffffc02b5618 <boot_pgdir_pa>
ffffffffc0204828:	577d                	li	a4,-1
ffffffffc020482a:	177e                	slli	a4,a4,0x3f
ffffffffc020482c:	83b1                	srli	a5,a5,0xc
ffffffffc020482e:	8fd9                	or	a5,a5,a4
ffffffffc0204830:	18079073          	csrw	satp,a5
ffffffffc0204834:	03092783          	lw	a5,48(s2)
ffffffffc0204838:	37fd                	addiw	a5,a5,-1
ffffffffc020483a:	02f92823          	sw	a5,48(s2)
        if (mm_count_dec(mm) == 0)
ffffffffc020483e:	30078563          	beqz	a5,ffffffffc0204b48 <do_execve+0x384>
        current->mm = NULL;
ffffffffc0204842:	000d3783          	ld	a5,0(s10)
ffffffffc0204846:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc020484a:	de3fe0ef          	jal	ffffffffc020362c <mm_create>
ffffffffc020484e:	892a                	mv	s2,a0
ffffffffc0204850:	22050063          	beqz	a0,ffffffffc0204a70 <do_execve+0x2ac>
    if ((page = alloc_page()) == NULL)
ffffffffc0204854:	4505                	li	a0,1
ffffffffc0204856:	d74fd0ef          	jal	ffffffffc0201dca <alloc_pages>
ffffffffc020485a:	42050063          	beqz	a0,ffffffffc0204c7a <do_execve+0x4b6>
    return page - pages + nbase;
ffffffffc020485e:	f0e2                	sd	s8,96(sp)
ffffffffc0204860:	000b1c17          	auipc	s8,0xb1
ffffffffc0204864:	dd8c0c13          	addi	s8,s8,-552 # ffffffffc02b5638 <pages>
ffffffffc0204868:	000c3783          	ld	a5,0(s8)
ffffffffc020486c:	f4de                	sd	s7,104(sp)
ffffffffc020486e:	00004b97          	auipc	s7,0x4
ffffffffc0204872:	292bbb83          	ld	s7,658(s7) # ffffffffc0208b00 <nbase>
ffffffffc0204876:	40f506b3          	sub	a3,a0,a5
ffffffffc020487a:	ece6                	sd	s9,88(sp)
    return KADDR(page2pa(page));
ffffffffc020487c:	000b1c97          	auipc	s9,0xb1
ffffffffc0204880:	db4c8c93          	addi	s9,s9,-588 # ffffffffc02b5630 <npage>
ffffffffc0204884:	f8da                	sd	s6,112(sp)
    return page - pages + nbase;
ffffffffc0204886:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204888:	5b7d                	li	s6,-1
ffffffffc020488a:	000cb783          	ld	a5,0(s9)
    return page - pages + nbase;
ffffffffc020488e:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc0204890:	00cb5713          	srli	a4,s6,0xc
ffffffffc0204894:	e83a                	sd	a4,16(sp)
ffffffffc0204896:	fcd6                	sd	s5,120(sp)
ffffffffc0204898:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc020489a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020489c:	40f77263          	bgeu	a4,a5,ffffffffc0204ca0 <do_execve+0x4dc>
ffffffffc02048a0:	000b1a97          	auipc	s5,0xb1
ffffffffc02048a4:	d88a8a93          	addi	s5,s5,-632 # ffffffffc02b5628 <va_pa_offset>
ffffffffc02048a8:	000ab783          	ld	a5,0(s5)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc02048ac:	000b1597          	auipc	a1,0xb1
ffffffffc02048b0:	d745b583          	ld	a1,-652(a1) # ffffffffc02b5620 <boot_pgdir_va>
ffffffffc02048b4:	6605                	lui	a2,0x1
ffffffffc02048b6:	00f684b3          	add	s1,a3,a5
ffffffffc02048ba:	8526                	mv	a0,s1
ffffffffc02048bc:	19b010ef          	jal	ffffffffc0206256 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc02048c0:	66e2                	ld	a3,24(sp)
ffffffffc02048c2:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc02048c6:	00993c23          	sd	s1,24(s2)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc02048ca:	4298                	lw	a4,0(a3)
ffffffffc02048cc:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_matrix_out_size+0x464b904f>
ffffffffc02048d0:	06f70863          	beq	a4,a5,ffffffffc0204940 <do_execve+0x17c>
        ret = -E_INVAL_ELF;
ffffffffc02048d4:	54e1                	li	s1,-8
    put_pgdir(mm);
ffffffffc02048d6:	854a                	mv	a0,s2
ffffffffc02048d8:	d34ff0ef          	jal	ffffffffc0203e0c <put_pgdir>
ffffffffc02048dc:	7ae6                	ld	s5,120(sp)
ffffffffc02048de:	7b46                	ld	s6,112(sp)
ffffffffc02048e0:	7ba6                	ld	s7,104(sp)
ffffffffc02048e2:	7c06                	ld	s8,96(sp)
ffffffffc02048e4:	6ce6                	ld	s9,88(sp)
    mm_destroy(mm);
ffffffffc02048e6:	854a                	mv	a0,s2
ffffffffc02048e8:	e83fe0ef          	jal	ffffffffc020376a <mm_destroy>
    do_exit(ret);
ffffffffc02048ec:	8526                	mv	a0,s1
ffffffffc02048ee:	f122                	sd	s0,160(sp)
ffffffffc02048f0:	e152                	sd	s4,128(sp)
ffffffffc02048f2:	fcd6                	sd	s5,120(sp)
ffffffffc02048f4:	f8da                	sd	s6,112(sp)
ffffffffc02048f6:	f4de                	sd	s7,104(sp)
ffffffffc02048f8:	f0e2                	sd	s8,96(sp)
ffffffffc02048fa:	ece6                	sd	s9,88(sp)
ffffffffc02048fc:	e4ee                	sd	s11,72(sp)
ffffffffc02048fe:	a7dff0ef          	jal	ffffffffc020437a <do_exit>
    if (len > PROC_NAME_LEN)
ffffffffc0204902:	863e                	mv	a2,a5
    memcpy(local_name, name, len);
ffffffffc0204904:	85ce                	mv	a1,s3
ffffffffc0204906:	1808                	addi	a0,sp,48
ffffffffc0204908:	14f010ef          	jal	ffffffffc0206256 <memcpy>
    if (mm != NULL)
ffffffffc020490c:	f00914e3          	bnez	s2,ffffffffc0204814 <do_execve+0x50>
    if (current->mm != NULL)
ffffffffc0204910:	000d3783          	ld	a5,0(s10)
ffffffffc0204914:	779c                	ld	a5,40(a5)
ffffffffc0204916:	db95                	beqz	a5,ffffffffc020484a <do_execve+0x86>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204918:	00003617          	auipc	a2,0x3
ffffffffc020491c:	2a860613          	addi	a2,a2,680 # ffffffffc0207bc0 <etext+0x1952>
ffffffffc0204920:	24c00593          	li	a1,588
ffffffffc0204924:	00003517          	auipc	a0,0x3
ffffffffc0204928:	0d450513          	addi	a0,a0,212 # ffffffffc02079f8 <etext+0x178a>
ffffffffc020492c:	f122                	sd	s0,160(sp)
ffffffffc020492e:	e152                	sd	s4,128(sp)
ffffffffc0204930:	fcd6                	sd	s5,120(sp)
ffffffffc0204932:	f8da                	sd	s6,112(sp)
ffffffffc0204934:	f4de                	sd	s7,104(sp)
ffffffffc0204936:	f0e2                	sd	s8,96(sp)
ffffffffc0204938:	ece6                	sd	s9,88(sp)
ffffffffc020493a:	e4ee                	sd	s11,72(sp)
ffffffffc020493c:	b0ffb0ef          	jal	ffffffffc020044a <__panic>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204940:	0386d703          	lhu	a4,56(a3)
ffffffffc0204944:	e152                	sd	s4,128(sp)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204946:	0206ba03          	ld	s4,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc020494a:	00371793          	slli	a5,a4,0x3
ffffffffc020494e:	8f99                	sub	a5,a5,a4
ffffffffc0204950:	078e                	slli	a5,a5,0x3
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204952:	9a36                	add	s4,s4,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204954:	97d2                	add	a5,a5,s4
ffffffffc0204956:	f122                	sd	s0,160(sp)
ffffffffc0204958:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc020495a:	00fa7e63          	bgeu	s4,a5,ffffffffc0204976 <do_execve+0x1b2>
ffffffffc020495e:	e4ee                	sd	s11,72(sp)
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204960:	000a2783          	lw	a5,0(s4)
ffffffffc0204964:	4705                	li	a4,1
ffffffffc0204966:	10e78763          	beq	a5,a4,ffffffffc0204a74 <do_execve+0x2b0>
    for (; ph < ph_end; ph++)
ffffffffc020496a:	77a2                	ld	a5,40(sp)
ffffffffc020496c:	038a0a13          	addi	s4,s4,56
ffffffffc0204970:	fefa68e3          	bltu	s4,a5,ffffffffc0204960 <do_execve+0x19c>
ffffffffc0204974:	6da6                	ld	s11,72(sp)
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204976:	4701                	li	a4,0
ffffffffc0204978:	46ad                	li	a3,11
ffffffffc020497a:	00100637          	lui	a2,0x100
ffffffffc020497e:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204982:	854a                	mv	a0,s2
ffffffffc0204984:	e39fe0ef          	jal	ffffffffc02037bc <mm_map>
ffffffffc0204988:	84aa                	mv	s1,a0
ffffffffc020498a:	1a051963          	bnez	a0,ffffffffc0204b3c <do_execve+0x378>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc020498e:	01893503          	ld	a0,24(s2)
ffffffffc0204992:	467d                	li	a2,31
ffffffffc0204994:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204998:	bb3fe0ef          	jal	ffffffffc020354a <pgdir_alloc_page>
ffffffffc020499c:	3a050163          	beqz	a0,ffffffffc0204d3e <do_execve+0x57a>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049a0:	01893503          	ld	a0,24(s2)
ffffffffc02049a4:	467d                	li	a2,31
ffffffffc02049a6:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc02049aa:	ba1fe0ef          	jal	ffffffffc020354a <pgdir_alloc_page>
ffffffffc02049ae:	36050763          	beqz	a0,ffffffffc0204d1c <do_execve+0x558>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049b2:	01893503          	ld	a0,24(s2)
ffffffffc02049b6:	467d                	li	a2,31
ffffffffc02049b8:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc02049bc:	b8ffe0ef          	jal	ffffffffc020354a <pgdir_alloc_page>
ffffffffc02049c0:	32050d63          	beqz	a0,ffffffffc0204cfa <do_execve+0x536>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049c4:	01893503          	ld	a0,24(s2)
ffffffffc02049c8:	467d                	li	a2,31
ffffffffc02049ca:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc02049ce:	b7dfe0ef          	jal	ffffffffc020354a <pgdir_alloc_page>
ffffffffc02049d2:	30050363          	beqz	a0,ffffffffc0204cd8 <do_execve+0x514>
    mm->mm_count += 1;
ffffffffc02049d6:	03092783          	lw	a5,48(s2)
    current->mm = mm;
ffffffffc02049da:	000d3603          	ld	a2,0(s10)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc02049de:	01893683          	ld	a3,24(s2)
ffffffffc02049e2:	2785                	addiw	a5,a5,1
ffffffffc02049e4:	02f92823          	sw	a5,48(s2)
    current->mm = mm;
ffffffffc02049e8:	03263423          	sd	s2,40(a2) # 100028 <_binary_obj___user_matrix_out_size+0xf4af8>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc02049ec:	c02007b7          	lui	a5,0xc0200
ffffffffc02049f0:	2cf6e763          	bltu	a3,a5,ffffffffc0204cbe <do_execve+0x4fa>
ffffffffc02049f4:	000ab783          	ld	a5,0(s5)
ffffffffc02049f8:	577d                	li	a4,-1
ffffffffc02049fa:	177e                	slli	a4,a4,0x3f
ffffffffc02049fc:	8e9d                	sub	a3,a3,a5
ffffffffc02049fe:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204a02:	f654                	sd	a3,168(a2)
ffffffffc0204a04:	8fd9                	or	a5,a5,a4
ffffffffc0204a06:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204a0a:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204a0c:	4581                	li	a1,0
ffffffffc0204a0e:	12000613          	li	a2,288
ffffffffc0204a12:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204a14:	10043903          	ld	s2,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204a18:	02d010ef          	jal	ffffffffc0206244 <memset>
    tf->epc = elf->e_entry;
ffffffffc0204a1c:	67e2                	ld	a5,24(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a1e:	000d3983          	ld	s3,0(s10)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204a22:	edf97913          	andi	s2,s2,-289
    tf->epc = elf->e_entry;
ffffffffc0204a26:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a28:	4785                	li	a5,1
ffffffffc0204a2a:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204a2c:	02096913          	ori	s2,s2,32
    tf->epc = elf->e_entry;
ffffffffc0204a30:	10e43423          	sd	a4,264(s0)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a34:	e81c                	sd	a5,16(s0)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204a36:	11243023          	sd	s2,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a3a:	4641                	li	a2,16
ffffffffc0204a3c:	4581                	li	a1,0
ffffffffc0204a3e:	0b498513          	addi	a0,s3,180
ffffffffc0204a42:	003010ef          	jal	ffffffffc0206244 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204a46:	180c                	addi	a1,sp,48
ffffffffc0204a48:	0b498513          	addi	a0,s3,180
ffffffffc0204a4c:	463d                	li	a2,15
ffffffffc0204a4e:	009010ef          	jal	ffffffffc0206256 <memcpy>
ffffffffc0204a52:	740a                	ld	s0,160(sp)
ffffffffc0204a54:	6a0a                	ld	s4,128(sp)
ffffffffc0204a56:	7ae6                	ld	s5,120(sp)
ffffffffc0204a58:	7b46                	ld	s6,112(sp)
ffffffffc0204a5a:	7ba6                	ld	s7,104(sp)
ffffffffc0204a5c:	7c06                	ld	s8,96(sp)
ffffffffc0204a5e:	6ce6                	ld	s9,88(sp)
}
ffffffffc0204a60:	70aa                	ld	ra,168(sp)
ffffffffc0204a62:	694a                	ld	s2,144(sp)
ffffffffc0204a64:	69aa                	ld	s3,136(sp)
ffffffffc0204a66:	6d46                	ld	s10,80(sp)
ffffffffc0204a68:	8526                	mv	a0,s1
ffffffffc0204a6a:	64ea                	ld	s1,152(sp)
ffffffffc0204a6c:	614d                	addi	sp,sp,176
ffffffffc0204a6e:	8082                	ret
    int ret = -E_NO_MEM;
ffffffffc0204a70:	54f1                	li	s1,-4
ffffffffc0204a72:	bdad                	j	ffffffffc02048ec <do_execve+0x128>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204a74:	028a3603          	ld	a2,40(s4)
ffffffffc0204a78:	020a3783          	ld	a5,32(s4)
ffffffffc0204a7c:	20f66363          	bltu	a2,a5,ffffffffc0204c82 <do_execve+0x4be>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204a80:	004a2783          	lw	a5,4(s4)
ffffffffc0204a84:	0027971b          	slliw	a4,a5,0x2
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204a88:	0027f693          	andi	a3,a5,2
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204a8c:	8b11                	andi	a4,a4,4
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204a8e:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204a90:	c6f1                	beqz	a3,ffffffffc0204b5c <do_execve+0x398>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204a92:	1c079763          	bnez	a5,ffffffffc0204c60 <do_execve+0x49c>
            perm |= (PTE_W | PTE_R);
ffffffffc0204a96:	47dd                	li	a5,23
            vm_flags |= VM_WRITE;
ffffffffc0204a98:	00276693          	ori	a3,a4,2
            perm |= (PTE_W | PTE_R);
ffffffffc0204a9c:	e43e                	sd	a5,8(sp)
        if (vm_flags & VM_EXEC)
ffffffffc0204a9e:	c709                	beqz	a4,ffffffffc0204aa8 <do_execve+0x2e4>
            perm |= PTE_X;
ffffffffc0204aa0:	67a2                	ld	a5,8(sp)
ffffffffc0204aa2:	0087e793          	ori	a5,a5,8
ffffffffc0204aa6:	e43e                	sd	a5,8(sp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204aa8:	010a3583          	ld	a1,16(s4)
ffffffffc0204aac:	4701                	li	a4,0
ffffffffc0204aae:	854a                	mv	a0,s2
ffffffffc0204ab0:	d0dfe0ef          	jal	ffffffffc02037bc <mm_map>
ffffffffc0204ab4:	84aa                	mv	s1,a0
ffffffffc0204ab6:	1c051463          	bnez	a0,ffffffffc0204c7e <do_execve+0x4ba>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204aba:	010a3b03          	ld	s6,16(s4)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204abe:	020a3483          	ld	s1,32(s4)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204ac2:	77fd                	lui	a5,0xfffff
ffffffffc0204ac4:	00fb75b3          	and	a1,s6,a5
        end = ph->p_va + ph->p_filesz;
ffffffffc0204ac8:	94da                	add	s1,s1,s6
        while (start < end)
ffffffffc0204aca:	1a9b7563          	bgeu	s6,s1,ffffffffc0204c74 <do_execve+0x4b0>
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204ace:	008a3983          	ld	s3,8(s4)
ffffffffc0204ad2:	67e2                	ld	a5,24(sp)
ffffffffc0204ad4:	99be                	add	s3,s3,a5
ffffffffc0204ad6:	a881                	j	ffffffffc0204b26 <do_execve+0x362>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204ad8:	6785                	lui	a5,0x1
ffffffffc0204ada:	00f58db3          	add	s11,a1,a5
                size -= la - end;
ffffffffc0204ade:	41648633          	sub	a2,s1,s6
            if (end < la)
ffffffffc0204ae2:	01b4e463          	bltu	s1,s11,ffffffffc0204aea <do_execve+0x326>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204ae6:	416d8633          	sub	a2,s11,s6
    return page - pages + nbase;
ffffffffc0204aea:	000c3683          	ld	a3,0(s8)
    return KADDR(page2pa(page));
ffffffffc0204aee:	67c2                	ld	a5,16(sp)
ffffffffc0204af0:	000cb503          	ld	a0,0(s9)
    return page - pages + nbase;
ffffffffc0204af4:	40d406b3          	sub	a3,s0,a3
ffffffffc0204af8:	8699                	srai	a3,a3,0x6
ffffffffc0204afa:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc0204afc:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204b00:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b02:	18a87363          	bgeu	a6,a0,ffffffffc0204c88 <do_execve+0x4c4>
ffffffffc0204b06:	000ab503          	ld	a0,0(s5)
ffffffffc0204b0a:	40bb05b3          	sub	a1,s6,a1
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b0e:	e032                	sd	a2,0(sp)
ffffffffc0204b10:	9536                	add	a0,a0,a3
ffffffffc0204b12:	952e                	add	a0,a0,a1
ffffffffc0204b14:	85ce                	mv	a1,s3
ffffffffc0204b16:	740010ef          	jal	ffffffffc0206256 <memcpy>
            start += size, from += size;
ffffffffc0204b1a:	6602                	ld	a2,0(sp)
ffffffffc0204b1c:	9b32                	add	s6,s6,a2
ffffffffc0204b1e:	99b2                	add	s3,s3,a2
        while (start < end)
ffffffffc0204b20:	049b7563          	bgeu	s6,s1,ffffffffc0204b6a <do_execve+0x3a6>
ffffffffc0204b24:	85ee                	mv	a1,s11
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204b26:	01893503          	ld	a0,24(s2)
ffffffffc0204b2a:	6622                	ld	a2,8(sp)
ffffffffc0204b2c:	e02e                	sd	a1,0(sp)
ffffffffc0204b2e:	a1dfe0ef          	jal	ffffffffc020354a <pgdir_alloc_page>
ffffffffc0204b32:	6582                	ld	a1,0(sp)
ffffffffc0204b34:	842a                	mv	s0,a0
ffffffffc0204b36:	f14d                	bnez	a0,ffffffffc0204ad8 <do_execve+0x314>
ffffffffc0204b38:	6da6                	ld	s11,72(sp)
        ret = -E_NO_MEM;
ffffffffc0204b3a:	54f1                	li	s1,-4
    exit_mmap(mm);
ffffffffc0204b3c:	854a                	mv	a0,s2
ffffffffc0204b3e:	de3fe0ef          	jal	ffffffffc0203920 <exit_mmap>
ffffffffc0204b42:	740a                	ld	s0,160(sp)
ffffffffc0204b44:	6a0a                	ld	s4,128(sp)
ffffffffc0204b46:	bb41                	j	ffffffffc02048d6 <do_execve+0x112>
            exit_mmap(mm);
ffffffffc0204b48:	854a                	mv	a0,s2
ffffffffc0204b4a:	dd7fe0ef          	jal	ffffffffc0203920 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204b4e:	854a                	mv	a0,s2
ffffffffc0204b50:	abcff0ef          	jal	ffffffffc0203e0c <put_pgdir>
            mm_destroy(mm);
ffffffffc0204b54:	854a                	mv	a0,s2
ffffffffc0204b56:	c15fe0ef          	jal	ffffffffc020376a <mm_destroy>
ffffffffc0204b5a:	b1e5                	j	ffffffffc0204842 <do_execve+0x7e>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204b5c:	0e078e63          	beqz	a5,ffffffffc0204c58 <do_execve+0x494>
            perm |= PTE_R;
ffffffffc0204b60:	47cd                	li	a5,19
            vm_flags |= VM_READ;
ffffffffc0204b62:	00176693          	ori	a3,a4,1
            perm |= PTE_R;
ffffffffc0204b66:	e43e                	sd	a5,8(sp)
ffffffffc0204b68:	bf1d                	j	ffffffffc0204a9e <do_execve+0x2da>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204b6a:	010a3483          	ld	s1,16(s4)
ffffffffc0204b6e:	028a3683          	ld	a3,40(s4)
ffffffffc0204b72:	94b6                	add	s1,s1,a3
        if (start < la)
ffffffffc0204b74:	07bb7c63          	bgeu	s6,s11,ffffffffc0204bec <do_execve+0x428>
            if (start == end)
ffffffffc0204b78:	df6489e3          	beq	s1,s6,ffffffffc020496a <do_execve+0x1a6>
                size -= la - end;
ffffffffc0204b7c:	416489b3          	sub	s3,s1,s6
            if (end < la)
ffffffffc0204b80:	0fb4f563          	bgeu	s1,s11,ffffffffc0204c6a <do_execve+0x4a6>
    return page - pages + nbase;
ffffffffc0204b84:	000c3683          	ld	a3,0(s8)
    return KADDR(page2pa(page));
ffffffffc0204b88:	000cb603          	ld	a2,0(s9)
    return page - pages + nbase;
ffffffffc0204b8c:	40d406b3          	sub	a3,s0,a3
ffffffffc0204b90:	8699                	srai	a3,a3,0x6
ffffffffc0204b92:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc0204b94:	00c69593          	slli	a1,a3,0xc
ffffffffc0204b98:	81b1                	srli	a1,a1,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0204b9a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b9c:	0ec5f663          	bgeu	a1,a2,ffffffffc0204c88 <do_execve+0x4c4>
ffffffffc0204ba0:	000ab603          	ld	a2,0(s5)
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204ba4:	6505                	lui	a0,0x1
ffffffffc0204ba6:	955a                	add	a0,a0,s6
ffffffffc0204ba8:	96b2                	add	a3,a3,a2
ffffffffc0204baa:	41b50533          	sub	a0,a0,s11
            memset(page2kva(page) + off, 0, size);
ffffffffc0204bae:	9536                	add	a0,a0,a3
ffffffffc0204bb0:	864e                	mv	a2,s3
ffffffffc0204bb2:	4581                	li	a1,0
ffffffffc0204bb4:	690010ef          	jal	ffffffffc0206244 <memset>
            start += size;
ffffffffc0204bb8:	9b4e                	add	s6,s6,s3
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204bba:	01b4b6b3          	sltu	a3,s1,s11
ffffffffc0204bbe:	01b4f463          	bgeu	s1,s11,ffffffffc0204bc6 <do_execve+0x402>
ffffffffc0204bc2:	db6484e3          	beq	s1,s6,ffffffffc020496a <do_execve+0x1a6>
ffffffffc0204bc6:	e299                	bnez	a3,ffffffffc0204bcc <do_execve+0x408>
ffffffffc0204bc8:	03bb0263          	beq	s6,s11,ffffffffc0204bec <do_execve+0x428>
ffffffffc0204bcc:	00003697          	auipc	a3,0x3
ffffffffc0204bd0:	01c68693          	addi	a3,a3,28 # ffffffffc0207be8 <etext+0x197a>
ffffffffc0204bd4:	00002617          	auipc	a2,0x2
ffffffffc0204bd8:	08460613          	addi	a2,a2,132 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0204bdc:	2b500593          	li	a1,693
ffffffffc0204be0:	00003517          	auipc	a0,0x3
ffffffffc0204be4:	e1850513          	addi	a0,a0,-488 # ffffffffc02079f8 <etext+0x178a>
ffffffffc0204be8:	863fb0ef          	jal	ffffffffc020044a <__panic>
        while (start < end)
ffffffffc0204bec:	d69b7fe3          	bgeu	s6,s1,ffffffffc020496a <do_execve+0x1a6>
ffffffffc0204bf0:	56fd                	li	a3,-1
ffffffffc0204bf2:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204bf6:	f03e                	sd	a5,32(sp)
ffffffffc0204bf8:	a0b9                	j	ffffffffc0204c46 <do_execve+0x482>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204bfa:	6785                	lui	a5,0x1
ffffffffc0204bfc:	00fd8833          	add	a6,s11,a5
                size -= la - end;
ffffffffc0204c00:	416489b3          	sub	s3,s1,s6
            if (end < la)
ffffffffc0204c04:	0104e463          	bltu	s1,a6,ffffffffc0204c0c <do_execve+0x448>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204c08:	416809b3          	sub	s3,a6,s6
    return page - pages + nbase;
ffffffffc0204c0c:	000c3683          	ld	a3,0(s8)
    return KADDR(page2pa(page));
ffffffffc0204c10:	7782                	ld	a5,32(sp)
ffffffffc0204c12:	000cb583          	ld	a1,0(s9)
    return page - pages + nbase;
ffffffffc0204c16:	40d406b3          	sub	a3,s0,a3
ffffffffc0204c1a:	8699                	srai	a3,a3,0x6
ffffffffc0204c1c:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc0204c1e:	00f6f533          	and	a0,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c22:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c24:	06b57263          	bgeu	a0,a1,ffffffffc0204c88 <do_execve+0x4c4>
ffffffffc0204c28:	000ab583          	ld	a1,0(s5)
ffffffffc0204c2c:	41bb0533          	sub	a0,s6,s11
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c30:	864e                	mv	a2,s3
ffffffffc0204c32:	96ae                	add	a3,a3,a1
ffffffffc0204c34:	9536                	add	a0,a0,a3
ffffffffc0204c36:	4581                	li	a1,0
            start += size;
ffffffffc0204c38:	9b4e                	add	s6,s6,s3
ffffffffc0204c3a:	e042                	sd	a6,0(sp)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c3c:	608010ef          	jal	ffffffffc0206244 <memset>
        while (start < end)
ffffffffc0204c40:	d29b75e3          	bgeu	s6,s1,ffffffffc020496a <do_execve+0x1a6>
ffffffffc0204c44:	6d82                	ld	s11,0(sp)
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204c46:	01893503          	ld	a0,24(s2)
ffffffffc0204c4a:	6622                	ld	a2,8(sp)
ffffffffc0204c4c:	85ee                	mv	a1,s11
ffffffffc0204c4e:	8fdfe0ef          	jal	ffffffffc020354a <pgdir_alloc_page>
ffffffffc0204c52:	842a                	mv	s0,a0
ffffffffc0204c54:	f15d                	bnez	a0,ffffffffc0204bfa <do_execve+0x436>
ffffffffc0204c56:	b5cd                	j	ffffffffc0204b38 <do_execve+0x374>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204c58:	47c5                	li	a5,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204c5a:	86ba                	mv	a3,a4
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204c5c:	e43e                	sd	a5,8(sp)
ffffffffc0204c5e:	b581                	j	ffffffffc0204a9e <do_execve+0x2da>
            perm |= (PTE_W | PTE_R);
ffffffffc0204c60:	47dd                	li	a5,23
            vm_flags |= VM_READ;
ffffffffc0204c62:	00376693          	ori	a3,a4,3
            perm |= (PTE_W | PTE_R);
ffffffffc0204c66:	e43e                	sd	a5,8(sp)
ffffffffc0204c68:	bd1d                	j	ffffffffc0204a9e <do_execve+0x2da>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204c6a:	416d89b3          	sub	s3,s11,s6
ffffffffc0204c6e:	bf19                	j	ffffffffc0204b84 <do_execve+0x3c0>
        return -E_INVAL;
ffffffffc0204c70:	54f5                	li	s1,-3
ffffffffc0204c72:	b3fd                	j	ffffffffc0204a60 <do_execve+0x29c>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204c74:	8dae                	mv	s11,a1
        while (start < end)
ffffffffc0204c76:	84da                	mv	s1,s6
ffffffffc0204c78:	bddd                	j	ffffffffc0204b6e <do_execve+0x3aa>
    int ret = -E_NO_MEM;
ffffffffc0204c7a:	54f1                	li	s1,-4
ffffffffc0204c7c:	b1ad                	j	ffffffffc02048e6 <do_execve+0x122>
ffffffffc0204c7e:	6da6                	ld	s11,72(sp)
ffffffffc0204c80:	bd75                	j	ffffffffc0204b3c <do_execve+0x378>
            ret = -E_INVAL_ELF;
ffffffffc0204c82:	6da6                	ld	s11,72(sp)
ffffffffc0204c84:	54e1                	li	s1,-8
ffffffffc0204c86:	bd5d                	j	ffffffffc0204b3c <do_execve+0x378>
ffffffffc0204c88:	00002617          	auipc	a2,0x2
ffffffffc0204c8c:	38060613          	addi	a2,a2,896 # ffffffffc0207008 <etext+0xd9a>
ffffffffc0204c90:	07100593          	li	a1,113
ffffffffc0204c94:	00002517          	auipc	a0,0x2
ffffffffc0204c98:	39c50513          	addi	a0,a0,924 # ffffffffc0207030 <etext+0xdc2>
ffffffffc0204c9c:	faefb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204ca0:	00002617          	auipc	a2,0x2
ffffffffc0204ca4:	36860613          	addi	a2,a2,872 # ffffffffc0207008 <etext+0xd9a>
ffffffffc0204ca8:	07100593          	li	a1,113
ffffffffc0204cac:	00002517          	auipc	a0,0x2
ffffffffc0204cb0:	38450513          	addi	a0,a0,900 # ffffffffc0207030 <etext+0xdc2>
ffffffffc0204cb4:	f122                	sd	s0,160(sp)
ffffffffc0204cb6:	e152                	sd	s4,128(sp)
ffffffffc0204cb8:	e4ee                	sd	s11,72(sp)
ffffffffc0204cba:	f90fb0ef          	jal	ffffffffc020044a <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204cbe:	00002617          	auipc	a2,0x2
ffffffffc0204cc2:	3f260613          	addi	a2,a2,1010 # ffffffffc02070b0 <etext+0xe42>
ffffffffc0204cc6:	2d400593          	li	a1,724
ffffffffc0204cca:	00003517          	auipc	a0,0x3
ffffffffc0204cce:	d2e50513          	addi	a0,a0,-722 # ffffffffc02079f8 <etext+0x178a>
ffffffffc0204cd2:	e4ee                	sd	s11,72(sp)
ffffffffc0204cd4:	f76fb0ef          	jal	ffffffffc020044a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cd8:	00003697          	auipc	a3,0x3
ffffffffc0204cdc:	02868693          	addi	a3,a3,40 # ffffffffc0207d00 <etext+0x1a92>
ffffffffc0204ce0:	00002617          	auipc	a2,0x2
ffffffffc0204ce4:	f7860613          	addi	a2,a2,-136 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0204ce8:	2cf00593          	li	a1,719
ffffffffc0204cec:	00003517          	auipc	a0,0x3
ffffffffc0204cf0:	d0c50513          	addi	a0,a0,-756 # ffffffffc02079f8 <etext+0x178a>
ffffffffc0204cf4:	e4ee                	sd	s11,72(sp)
ffffffffc0204cf6:	f54fb0ef          	jal	ffffffffc020044a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cfa:	00003697          	auipc	a3,0x3
ffffffffc0204cfe:	fbe68693          	addi	a3,a3,-66 # ffffffffc0207cb8 <etext+0x1a4a>
ffffffffc0204d02:	00002617          	auipc	a2,0x2
ffffffffc0204d06:	f5660613          	addi	a2,a2,-170 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0204d0a:	2ce00593          	li	a1,718
ffffffffc0204d0e:	00003517          	auipc	a0,0x3
ffffffffc0204d12:	cea50513          	addi	a0,a0,-790 # ffffffffc02079f8 <etext+0x178a>
ffffffffc0204d16:	e4ee                	sd	s11,72(sp)
ffffffffc0204d18:	f32fb0ef          	jal	ffffffffc020044a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204d1c:	00003697          	auipc	a3,0x3
ffffffffc0204d20:	f5468693          	addi	a3,a3,-172 # ffffffffc0207c70 <etext+0x1a02>
ffffffffc0204d24:	00002617          	auipc	a2,0x2
ffffffffc0204d28:	f3460613          	addi	a2,a2,-204 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0204d2c:	2cd00593          	li	a1,717
ffffffffc0204d30:	00003517          	auipc	a0,0x3
ffffffffc0204d34:	cc850513          	addi	a0,a0,-824 # ffffffffc02079f8 <etext+0x178a>
ffffffffc0204d38:	e4ee                	sd	s11,72(sp)
ffffffffc0204d3a:	f10fb0ef          	jal	ffffffffc020044a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204d3e:	00003697          	auipc	a3,0x3
ffffffffc0204d42:	eea68693          	addi	a3,a3,-278 # ffffffffc0207c28 <etext+0x19ba>
ffffffffc0204d46:	00002617          	auipc	a2,0x2
ffffffffc0204d4a:	f1260613          	addi	a2,a2,-238 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0204d4e:	2cc00593          	li	a1,716
ffffffffc0204d52:	00003517          	auipc	a0,0x3
ffffffffc0204d56:	ca650513          	addi	a0,a0,-858 # ffffffffc02079f8 <etext+0x178a>
ffffffffc0204d5a:	e4ee                	sd	s11,72(sp)
ffffffffc0204d5c:	eeefb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204d60 <user_main>:
{
ffffffffc0204d60:	1101                	addi	sp,sp,-32
ffffffffc0204d62:	e426                	sd	s1,8(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204d64:	000b1497          	auipc	s1,0xb1
ffffffffc0204d68:	8e448493          	addi	s1,s1,-1820 # ffffffffc02b5648 <current>
ffffffffc0204d6c:	609c                	ld	a5,0(s1)
ffffffffc0204d6e:	00003617          	auipc	a2,0x3
ffffffffc0204d72:	fda60613          	addi	a2,a2,-38 # ffffffffc0207d48 <etext+0x1ada>
ffffffffc0204d76:	00003517          	auipc	a0,0x3
ffffffffc0204d7a:	fe250513          	addi	a0,a0,-30 # ffffffffc0207d58 <etext+0x1aea>
ffffffffc0204d7e:	43cc                	lw	a1,4(a5)
{
ffffffffc0204d80:	ec06                	sd	ra,24(sp)
ffffffffc0204d82:	e822                	sd	s0,16(sp)
ffffffffc0204d84:	e04a                	sd	s2,0(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204d86:	c12fb0ef          	jal	ffffffffc0200198 <cprintf>
    size_t len = strlen(name);
ffffffffc0204d8a:	00003517          	auipc	a0,0x3
ffffffffc0204d8e:	fbe50513          	addi	a0,a0,-66 # ffffffffc0207d48 <etext+0x1ada>
ffffffffc0204d92:	3fe010ef          	jal	ffffffffc0206190 <strlen>
    struct trapframe *old_tf = current->tf;
ffffffffc0204d96:	6098                	ld	a4,0(s1)
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0204d98:	6789                	lui	a5,0x2
ffffffffc0204d9a:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_softint_out_size-0x7048>
ffffffffc0204d9e:	6b00                	ld	s0,16(a4)
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0204da0:	734c                	ld	a1,160(a4)
    size_t len = strlen(name);
ffffffffc0204da2:	892a                	mv	s2,a0
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0204da4:	943e                	add	s0,s0,a5
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0204da6:	12000613          	li	a2,288
ffffffffc0204daa:	8522                	mv	a0,s0
ffffffffc0204dac:	4aa010ef          	jal	ffffffffc0206256 <memcpy>
    current->tf = new_tf;
ffffffffc0204db0:	609c                	ld	a5,0(s1)
    ret = do_execve(name, len, binary, size);
ffffffffc0204db2:	85ca                	mv	a1,s2
ffffffffc0204db4:	3fe06697          	auipc	a3,0x3fe06
ffffffffc0204db8:	96468693          	addi	a3,a3,-1692 # a718 <_binary_obj___user_priority_out_size>
    current->tf = new_tf;
ffffffffc0204dbc:	f3c0                	sd	s0,160(a5)
    ret = do_execve(name, len, binary, size);
ffffffffc0204dbe:	00072617          	auipc	a2,0x72
ffffffffc0204dc2:	b8a60613          	addi	a2,a2,-1142 # ffffffffc0276948 <_binary_obj___user_priority_out_start>
ffffffffc0204dc6:	00003517          	auipc	a0,0x3
ffffffffc0204dca:	f8250513          	addi	a0,a0,-126 # ffffffffc0207d48 <etext+0x1ada>
ffffffffc0204dce:	9f7ff0ef          	jal	ffffffffc02047c4 <do_execve>
    asm volatile(
ffffffffc0204dd2:	8122                	mv	sp,s0
ffffffffc0204dd4:	868fc06f          	j	ffffffffc0200e3c <__trapret>
    panic("user_main execve failed.\n");
ffffffffc0204dd8:	00003617          	auipc	a2,0x3
ffffffffc0204ddc:	fa860613          	addi	a2,a2,-88 # ffffffffc0207d80 <etext+0x1b12>
ffffffffc0204de0:	3b800593          	li	a1,952
ffffffffc0204de4:	00003517          	auipc	a0,0x3
ffffffffc0204de8:	c1450513          	addi	a0,a0,-1004 # ffffffffc02079f8 <etext+0x178a>
ffffffffc0204dec:	e5efb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204df0 <do_yield>:
    current->need_resched = 1;
ffffffffc0204df0:	000b1797          	auipc	a5,0xb1
ffffffffc0204df4:	8587b783          	ld	a5,-1960(a5) # ffffffffc02b5648 <current>
ffffffffc0204df8:	4705                	li	a4,1
}
ffffffffc0204dfa:	4501                	li	a0,0
    current->need_resched = 1;
ffffffffc0204dfc:	ef98                	sd	a4,24(a5)
}
ffffffffc0204dfe:	8082                	ret

ffffffffc0204e00 <do_wait>:
    if (code_store != NULL)
ffffffffc0204e00:	c59d                	beqz	a1,ffffffffc0204e2e <do_wait+0x2e>
{
ffffffffc0204e02:	1101                	addi	sp,sp,-32
ffffffffc0204e04:	e02a                	sd	a0,0(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204e06:	000b1517          	auipc	a0,0xb1
ffffffffc0204e0a:	84253503          	ld	a0,-1982(a0) # ffffffffc02b5648 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204e0e:	4685                	li	a3,1
ffffffffc0204e10:	4611                	li	a2,4
ffffffffc0204e12:	7508                	ld	a0,40(a0)
{
ffffffffc0204e14:	ec06                	sd	ra,24(sp)
ffffffffc0204e16:	e42e                	sd	a1,8(sp)
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204e18:	ea1fe0ef          	jal	ffffffffc0203cb8 <user_mem_check>
ffffffffc0204e1c:	6702                	ld	a4,0(sp)
ffffffffc0204e1e:	67a2                	ld	a5,8(sp)
ffffffffc0204e20:	c909                	beqz	a0,ffffffffc0204e32 <do_wait+0x32>
}
ffffffffc0204e22:	60e2                	ld	ra,24(sp)
ffffffffc0204e24:	85be                	mv	a1,a5
ffffffffc0204e26:	853a                	mv	a0,a4
ffffffffc0204e28:	6105                	addi	sp,sp,32
ffffffffc0204e2a:	e94ff06f          	j	ffffffffc02044be <do_wait.part.0>
ffffffffc0204e2e:	e90ff06f          	j	ffffffffc02044be <do_wait.part.0>
ffffffffc0204e32:	60e2                	ld	ra,24(sp)
ffffffffc0204e34:	5575                	li	a0,-3
ffffffffc0204e36:	6105                	addi	sp,sp,32
ffffffffc0204e38:	8082                	ret

ffffffffc0204e3a <do_kill>:
    if (0 < pid && pid < MAX_PID)
ffffffffc0204e3a:	6789                	lui	a5,0x2
ffffffffc0204e3c:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204e40:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6f2a>
ffffffffc0204e42:	06e7e463          	bltu	a5,a4,ffffffffc0204eaa <do_kill+0x70>
{
ffffffffc0204e46:	1101                	addi	sp,sp,-32
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204e48:	45a9                	li	a1,10
{
ffffffffc0204e4a:	ec06                	sd	ra,24(sp)
ffffffffc0204e4c:	e42a                	sd	a0,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204e4e:	761000ef          	jal	ffffffffc0205dae <hash32>
ffffffffc0204e52:	02051793          	slli	a5,a0,0x20
ffffffffc0204e56:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204e5a:	000ac797          	auipc	a5,0xac
ffffffffc0204e5e:	74678793          	addi	a5,a5,1862 # ffffffffc02b15a0 <hash_list>
ffffffffc0204e62:	96be                	add	a3,a3,a5
        while ((le = list_next(le)) != list)
ffffffffc0204e64:	6622                	ld	a2,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204e66:	8536                	mv	a0,a3
        while ((le = list_next(le)) != list)
ffffffffc0204e68:	a029                	j	ffffffffc0204e72 <do_kill+0x38>
            if (proc->pid == pid)
ffffffffc0204e6a:	f2c52703          	lw	a4,-212(a0)
ffffffffc0204e6e:	00c70963          	beq	a4,a2,ffffffffc0204e80 <do_kill+0x46>
ffffffffc0204e72:	6508                	ld	a0,8(a0)
        while ((le = list_next(le)) != list)
ffffffffc0204e74:	fea69be3          	bne	a3,a0,ffffffffc0204e6a <do_kill+0x30>
}
ffffffffc0204e78:	60e2                	ld	ra,24(sp)
    return -E_INVAL;
ffffffffc0204e7a:	5575                	li	a0,-3
}
ffffffffc0204e7c:	6105                	addi	sp,sp,32
ffffffffc0204e7e:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204e80:	fd852703          	lw	a4,-40(a0)
ffffffffc0204e84:	00177693          	andi	a3,a4,1
ffffffffc0204e88:	e29d                	bnez	a3,ffffffffc0204eae <do_kill+0x74>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204e8a:	4954                	lw	a3,20(a0)
            proc->flags |= PF_EXITING;
ffffffffc0204e8c:	00176713          	ori	a4,a4,1
ffffffffc0204e90:	fce52c23          	sw	a4,-40(a0)
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204e94:	0006c663          	bltz	a3,ffffffffc0204ea0 <do_kill+0x66>
            return 0;
ffffffffc0204e98:	4501                	li	a0,0
}
ffffffffc0204e9a:	60e2                	ld	ra,24(sp)
ffffffffc0204e9c:	6105                	addi	sp,sp,32
ffffffffc0204e9e:	8082                	ret
                wakeup_proc(proc);
ffffffffc0204ea0:	f2850513          	addi	a0,a0,-216
ffffffffc0204ea4:	4b1000ef          	jal	ffffffffc0205b54 <wakeup_proc>
ffffffffc0204ea8:	bfc5                	j	ffffffffc0204e98 <do_kill+0x5e>
    return -E_INVAL;
ffffffffc0204eaa:	5575                	li	a0,-3
}
ffffffffc0204eac:	8082                	ret
        return -E_KILLED;
ffffffffc0204eae:	555d                	li	a0,-9
ffffffffc0204eb0:	b7ed                	j	ffffffffc0204e9a <do_kill+0x60>

ffffffffc0204eb2 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204eb2:	1101                	addi	sp,sp,-32
ffffffffc0204eb4:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204eb6:	000b0797          	auipc	a5,0xb0
ffffffffc0204eba:	6ea78793          	addi	a5,a5,1770 # ffffffffc02b55a0 <proc_list>
ffffffffc0204ebe:	ec06                	sd	ra,24(sp)
ffffffffc0204ec0:	e822                	sd	s0,16(sp)
ffffffffc0204ec2:	e04a                	sd	s2,0(sp)
ffffffffc0204ec4:	000ac497          	auipc	s1,0xac
ffffffffc0204ec8:	6dc48493          	addi	s1,s1,1756 # ffffffffc02b15a0 <hash_list>
ffffffffc0204ecc:	e79c                	sd	a5,8(a5)
ffffffffc0204ece:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204ed0:	000b0717          	auipc	a4,0xb0
ffffffffc0204ed4:	6d070713          	addi	a4,a4,1744 # ffffffffc02b55a0 <proc_list>
ffffffffc0204ed8:	87a6                	mv	a5,s1
ffffffffc0204eda:	e79c                	sd	a5,8(a5)
ffffffffc0204edc:	e39c                	sd	a5,0(a5)
ffffffffc0204ede:	07c1                	addi	a5,a5,16
ffffffffc0204ee0:	fee79de3          	bne	a5,a4,ffffffffc0204eda <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0204ee4:	e81fe0ef          	jal	ffffffffc0203d64 <alloc_proc>
ffffffffc0204ee8:	000b0917          	auipc	s2,0xb0
ffffffffc0204eec:	77090913          	addi	s2,s2,1904 # ffffffffc02b5658 <idleproc>
ffffffffc0204ef0:	00a93023          	sd	a0,0(s2)
ffffffffc0204ef4:	10050363          	beqz	a0,ffffffffc0204ffa <proc_init+0x148>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204ef8:	4789                	li	a5,2
ffffffffc0204efa:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204efc:	00004797          	auipc	a5,0x4
ffffffffc0204f00:	10478793          	addi	a5,a5,260 # ffffffffc0209000 <bootstack>
ffffffffc0204f04:	e91c                	sd	a5,16(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f06:	0b450413          	addi	s0,a0,180
    idleproc->need_resched = 1;
ffffffffc0204f0a:	4785                	li	a5,1
ffffffffc0204f0c:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f0e:	4641                	li	a2,16
ffffffffc0204f10:	8522                	mv	a0,s0
ffffffffc0204f12:	4581                	li	a1,0
ffffffffc0204f14:	330010ef          	jal	ffffffffc0206244 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204f18:	8522                	mv	a0,s0
ffffffffc0204f1a:	463d                	li	a2,15
ffffffffc0204f1c:	00003597          	auipc	a1,0x3
ffffffffc0204f20:	e9c58593          	addi	a1,a1,-356 # ffffffffc0207db8 <etext+0x1b4a>
ffffffffc0204f24:	332010ef          	jal	ffffffffc0206256 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0204f28:	000b0797          	auipc	a5,0xb0
ffffffffc0204f2c:	7187a783          	lw	a5,1816(a5) # ffffffffc02b5640 <nr_process>

    current = idleproc;
ffffffffc0204f30:	00093703          	ld	a4,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204f34:	4601                	li	a2,0
    nr_process++;
ffffffffc0204f36:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204f38:	4581                	li	a1,0
ffffffffc0204f3a:	fffff517          	auipc	a0,0xfffff
ffffffffc0204f3e:	76650513          	addi	a0,a0,1894 # ffffffffc02046a0 <init_main>
    current = idleproc;
ffffffffc0204f42:	000b0697          	auipc	a3,0xb0
ffffffffc0204f46:	70e6b323          	sd	a4,1798(a3) # ffffffffc02b5648 <current>
    nr_process++;
ffffffffc0204f4a:	000b0717          	auipc	a4,0xb0
ffffffffc0204f4e:	6ef72b23          	sw	a5,1782(a4) # ffffffffc02b5640 <nr_process>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204f52:	bd8ff0ef          	jal	ffffffffc020432a <kernel_thread>
ffffffffc0204f56:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0204f58:	08a05563          	blez	a0,ffffffffc0204fe2 <proc_init+0x130>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204f5c:	6789                	lui	a5,0x2
ffffffffc0204f5e:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6f2a>
ffffffffc0204f60:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204f64:	02e7e463          	bltu	a5,a4,ffffffffc0204f8c <proc_init+0xda>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204f68:	45a9                	li	a1,10
ffffffffc0204f6a:	645000ef          	jal	ffffffffc0205dae <hash32>
ffffffffc0204f6e:	02051713          	slli	a4,a0,0x20
ffffffffc0204f72:	01c75793          	srli	a5,a4,0x1c
ffffffffc0204f76:	00f486b3          	add	a3,s1,a5
ffffffffc0204f7a:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0204f7c:	a029                	j	ffffffffc0204f86 <proc_init+0xd4>
            if (proc->pid == pid)
ffffffffc0204f7e:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204f82:	04870d63          	beq	a4,s0,ffffffffc0204fdc <proc_init+0x12a>
    return listelm->next;
ffffffffc0204f86:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204f88:	fef69be3          	bne	a3,a5,ffffffffc0204f7e <proc_init+0xcc>
    return NULL;
ffffffffc0204f8c:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f8e:	0b478413          	addi	s0,a5,180
ffffffffc0204f92:	4641                	li	a2,16
ffffffffc0204f94:	4581                	li	a1,0
ffffffffc0204f96:	8522                	mv	a0,s0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0204f98:	000b0717          	auipc	a4,0xb0
ffffffffc0204f9c:	6af73c23          	sd	a5,1720(a4) # ffffffffc02b5650 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204fa0:	2a4010ef          	jal	ffffffffc0206244 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204fa4:	8522                	mv	a0,s0
ffffffffc0204fa6:	463d                	li	a2,15
ffffffffc0204fa8:	00003597          	auipc	a1,0x3
ffffffffc0204fac:	e3858593          	addi	a1,a1,-456 # ffffffffc0207de0 <etext+0x1b72>
ffffffffc0204fb0:	2a6010ef          	jal	ffffffffc0206256 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204fb4:	00093783          	ld	a5,0(s2)
ffffffffc0204fb8:	cfad                	beqz	a5,ffffffffc0205032 <proc_init+0x180>
ffffffffc0204fba:	43dc                	lw	a5,4(a5)
ffffffffc0204fbc:	ebbd                	bnez	a5,ffffffffc0205032 <proc_init+0x180>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204fbe:	000b0797          	auipc	a5,0xb0
ffffffffc0204fc2:	6927b783          	ld	a5,1682(a5) # ffffffffc02b5650 <initproc>
ffffffffc0204fc6:	c7b1                	beqz	a5,ffffffffc0205012 <proc_init+0x160>
ffffffffc0204fc8:	43d8                	lw	a4,4(a5)
ffffffffc0204fca:	4785                	li	a5,1
ffffffffc0204fcc:	04f71363          	bne	a4,a5,ffffffffc0205012 <proc_init+0x160>
}
ffffffffc0204fd0:	60e2                	ld	ra,24(sp)
ffffffffc0204fd2:	6442                	ld	s0,16(sp)
ffffffffc0204fd4:	64a2                	ld	s1,8(sp)
ffffffffc0204fd6:	6902                	ld	s2,0(sp)
ffffffffc0204fd8:	6105                	addi	sp,sp,32
ffffffffc0204fda:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204fdc:	f2878793          	addi	a5,a5,-216
ffffffffc0204fe0:	b77d                	j	ffffffffc0204f8e <proc_init+0xdc>
        panic("create init_main failed.\n");
ffffffffc0204fe2:	00003617          	auipc	a2,0x3
ffffffffc0204fe6:	dde60613          	addi	a2,a2,-546 # ffffffffc0207dc0 <etext+0x1b52>
ffffffffc0204fea:	3f400593          	li	a1,1012
ffffffffc0204fee:	00003517          	auipc	a0,0x3
ffffffffc0204ff2:	a0a50513          	addi	a0,a0,-1526 # ffffffffc02079f8 <etext+0x178a>
ffffffffc0204ff6:	c54fb0ef          	jal	ffffffffc020044a <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0204ffa:	00003617          	auipc	a2,0x3
ffffffffc0204ffe:	da660613          	addi	a2,a2,-602 # ffffffffc0207da0 <etext+0x1b32>
ffffffffc0205002:	3e500593          	li	a1,997
ffffffffc0205006:	00003517          	auipc	a0,0x3
ffffffffc020500a:	9f250513          	addi	a0,a0,-1550 # ffffffffc02079f8 <etext+0x178a>
ffffffffc020500e:	c3cfb0ef          	jal	ffffffffc020044a <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205012:	00003697          	auipc	a3,0x3
ffffffffc0205016:	dfe68693          	addi	a3,a3,-514 # ffffffffc0207e10 <etext+0x1ba2>
ffffffffc020501a:	00002617          	auipc	a2,0x2
ffffffffc020501e:	c3e60613          	addi	a2,a2,-962 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0205022:	3fb00593          	li	a1,1019
ffffffffc0205026:	00003517          	auipc	a0,0x3
ffffffffc020502a:	9d250513          	addi	a0,a0,-1582 # ffffffffc02079f8 <etext+0x178a>
ffffffffc020502e:	c1cfb0ef          	jal	ffffffffc020044a <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205032:	00003697          	auipc	a3,0x3
ffffffffc0205036:	db668693          	addi	a3,a3,-586 # ffffffffc0207de8 <etext+0x1b7a>
ffffffffc020503a:	00002617          	auipc	a2,0x2
ffffffffc020503e:	c1e60613          	addi	a2,a2,-994 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0205042:	3fa00593          	li	a1,1018
ffffffffc0205046:	00003517          	auipc	a0,0x3
ffffffffc020504a:	9b250513          	addi	a0,a0,-1614 # ffffffffc02079f8 <etext+0x178a>
ffffffffc020504e:	bfcfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205052 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0205052:	1141                	addi	sp,sp,-16
ffffffffc0205054:	e022                	sd	s0,0(sp)
ffffffffc0205056:	e406                	sd	ra,8(sp)
ffffffffc0205058:	000b0417          	auipc	s0,0xb0
ffffffffc020505c:	5f040413          	addi	s0,s0,1520 # ffffffffc02b5648 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0205060:	6018                	ld	a4,0(s0)
ffffffffc0205062:	6f1c                	ld	a5,24(a4)
ffffffffc0205064:	dffd                	beqz	a5,ffffffffc0205062 <cpu_idle+0x10>
        {
            schedule();
ffffffffc0205066:	395000ef          	jal	ffffffffc0205bfa <schedule>
ffffffffc020506a:	bfdd                	j	ffffffffc0205060 <cpu_idle+0xe>

ffffffffc020506c <lab6_set_priority>:
    }
}
// FOR LAB6, set the process's priority (bigger value will get more CPU time)
void lab6_set_priority(uint32_t priority)
{
    if (priority <= 5) cprintf("set priority to %d\n", priority);
ffffffffc020506c:	4795                	li	a5,5
{
ffffffffc020506e:	85aa                	mv	a1,a0
    if (priority <= 5) cprintf("set priority to %d\n", priority);
ffffffffc0205070:	00a7f963          	bgeu	a5,a0,ffffffffc0205082 <lab6_set_priority+0x16>
    if (priority == 0)
        current->lab6_priority = 1;
    else
        current->lab6_priority = priority;
ffffffffc0205074:	000b0797          	auipc	a5,0xb0
ffffffffc0205078:	5d47b783          	ld	a5,1492(a5) # ffffffffc02b5648 <current>
ffffffffc020507c:	14a7a223          	sw	a0,324(a5)
ffffffffc0205080:	8082                	ret
{
ffffffffc0205082:	1101                	addi	sp,sp,-32
    if (priority <= 5) cprintf("set priority to %d\n", priority);
ffffffffc0205084:	e42a                	sd	a0,8(sp)
ffffffffc0205086:	00003517          	auipc	a0,0x3
ffffffffc020508a:	db250513          	addi	a0,a0,-590 # ffffffffc0207e38 <etext+0x1bca>
{
ffffffffc020508e:	ec06                	sd	ra,24(sp)
    if (priority <= 5) cprintf("set priority to %d\n", priority);
ffffffffc0205090:	908fb0ef          	jal	ffffffffc0200198 <cprintf>
    if (priority == 0)
ffffffffc0205094:	65a2                	ld	a1,8(sp)
        current->lab6_priority = 1;
ffffffffc0205096:	000b0797          	auipc	a5,0xb0
ffffffffc020509a:	5b27b783          	ld	a5,1458(a5) # ffffffffc02b5648 <current>
    if (priority == 0)
ffffffffc020509e:	c591                	beqz	a1,ffffffffc02050aa <lab6_set_priority+0x3e>
}
ffffffffc02050a0:	60e2                	ld	ra,24(sp)
        current->lab6_priority = priority;
ffffffffc02050a2:	14b7a223          	sw	a1,324(a5)
}
ffffffffc02050a6:	6105                	addi	sp,sp,32
ffffffffc02050a8:	8082                	ret
ffffffffc02050aa:	60e2                	ld	ra,24(sp)
        current->lab6_priority = 1;
ffffffffc02050ac:	4705                	li	a4,1
ffffffffc02050ae:	14e7a223          	sw	a4,324(a5)
}
ffffffffc02050b2:	6105                	addi	sp,sp,32
ffffffffc02050b4:	8082                	ret

ffffffffc02050b6 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc02050b6:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc02050ba:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc02050be:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc02050c0:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc02050c2:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc02050c6:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc02050ca:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc02050ce:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc02050d2:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc02050d6:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc02050da:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc02050de:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc02050e2:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc02050e6:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc02050ea:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc02050ee:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc02050f2:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc02050f4:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc02050f6:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc02050fa:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc02050fe:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0205102:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0205106:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc020510a:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc020510e:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0205112:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0205116:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc020511a:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc020511e:	8082                	ret

ffffffffc0205120 <stride_init>:
    elm->prev = elm->next = elm;
ffffffffc0205120:	e508                	sd	a0,8(a0)
ffffffffc0205122:	e108                	sd	a0,0(a0)
      * (1) init the ready process list: rq->run_list
      * (2) init the run pool: rq->lab6_run_pool
      * (3) set number of process: rq->proc_num to 0
      */
     list_init(&rq->run_list);    // 初始化链表（兼容旧逻辑）
     rq->lab6_run_pool = NULL;    // 初始化斜堆（stride核心）
ffffffffc0205124:	00053c23          	sd	zero,24(a0)
     rq->proc_num = 0;            // 就绪进程数置0
ffffffffc0205128:	00052823          	sw	zero,16(a0)
}
ffffffffc020512c:	8082                	ret

ffffffffc020512e <stride_proc_tick>:
 */
static void
stride_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
     /* LAB6 CHALLENGE 1: 2311828 2313540 */
     if (proc == idleproc || !proc) {
ffffffffc020512e:	000b0797          	auipc	a5,0xb0
ffffffffc0205132:	52a7b783          	ld	a5,1322(a5) # ffffffffc02b5658 <idleproc>
ffffffffc0205136:	00b78d63          	beq	a5,a1,ffffffffc0205150 <stride_proc_tick+0x22>
ffffffffc020513a:	c999                	beqz	a1,ffffffffc0205150 <stride_proc_tick+0x22>
         return;
     }
     // 1. 时间片递减（同RR调度）
     if (proc->time_slice > 0) {
ffffffffc020513c:	1205a783          	lw	a5,288(a1)
ffffffffc0205140:	00f05563          	blez	a5,ffffffffc020514a <stride_proc_tick+0x1c>
         proc->time_slice--;
ffffffffc0205144:	37fd                	addiw	a5,a5,-1
ffffffffc0205146:	12f5a023          	sw	a5,288(a1)
     }
     // 2. 时间片耗尽，标记需要重新调度
     if (proc->time_slice == 0) {
ffffffffc020514a:	e399                	bnez	a5,ffffffffc0205150 <stride_proc_tick+0x22>
         proc->need_resched = 1;
ffffffffc020514c:	4785                	li	a5,1
ffffffffc020514e:	ed9c                	sd	a5,24(a1)
     }
}
ffffffffc0205150:	8082                	ret

ffffffffc0205152 <skew_heap_merge.constprop.0>:
{
     a->left = a->right = a->parent = NULL;
}

static inline skew_heap_entry_t *
skew_heap_merge(skew_heap_entry_t *a, skew_heap_entry_t *b,
ffffffffc0205152:	87ae                	mv	a5,a1
                compare_f comp)
{
     if (a == NULL) return b;
ffffffffc0205154:	1c050963          	beqz	a0,ffffffffc0205326 <skew_heap_merge.constprop.0+0x1d4>
ffffffffc0205158:	862a                	mv	a2,a0
     else if (b == NULL) return a;
ffffffffc020515a:	1c058863          	beqz	a1,ffffffffc020532a <skew_heap_merge.constprop.0+0x1d8>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc020515e:	4d14                	lw	a3,24(a0)
ffffffffc0205160:	4d98                	lw	a4,24(a1)
skew_heap_merge(skew_heap_entry_t *a, skew_heap_entry_t *b,
ffffffffc0205162:	7139                	addi	sp,sp,-64
ffffffffc0205164:	fc06                	sd	ra,56(sp)
ffffffffc0205166:	40e6883b          	subw	a6,a3,a4
     else if (c == 0)
ffffffffc020516a:	06084d63          	bltz	a6,ffffffffc02051e4 <skew_heap_merge.constprop.0+0x92>
          return a;
     }
     else
     {
          r = b->left;
          l = skew_heap_merge(a, b->right, comp);
ffffffffc020516e:	6998                	ld	a4,16(a1)
          r = b->left;
ffffffffc0205170:	0085b883          	ld	a7,8(a1)
     else if (b == NULL) return a;
ffffffffc0205174:	10070d63          	beqz	a4,ffffffffc020528e <skew_heap_merge.constprop.0+0x13c>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc0205178:	4f0c                	lw	a1,24(a4)
ffffffffc020517a:	40b6883b          	subw	a6,a3,a1
     else if (c == 0)
ffffffffc020517e:	0c084663          	bltz	a6,ffffffffc020524a <skew_heap_merge.constprop.0+0xf8>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205182:	01073803          	ld	a6,16(a4)
          r = b->left;
ffffffffc0205186:	00873303          	ld	t1,8(a4)
     else if (b == NULL) return a;
ffffffffc020518a:	04080163          	beqz	a6,ffffffffc02051cc <skew_heap_merge.constprop.0+0x7a>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc020518e:	01882583          	lw	a1,24(a6) # fffffffffffff018 <end+0x3fd499a8>
ffffffffc0205192:	f43e                	sd	a5,40(sp)
ffffffffc0205194:	f01a                	sd	t1,32(sp)
ffffffffc0205196:	9e8d                	subw	a3,a3,a1
ffffffffc0205198:	ec3a                	sd	a4,24(sp)
ffffffffc020519a:	e846                	sd	a7,16(sp)
     else if (c == 0)
ffffffffc020519c:	1606c263          	bltz	a3,ffffffffc0205300 <skew_heap_merge.constprop.0+0x1ae>
          r = b->left;
ffffffffc02051a0:	00883683          	ld	a3,8(a6)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc02051a4:	01083583          	ld	a1,16(a6)
          r = b->left;
ffffffffc02051a8:	e442                	sd	a6,8(sp)
ffffffffc02051aa:	e036                	sd	a3,0(sp)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc02051ac:	fa7ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          
          b->left = l;
          b->right = r;
ffffffffc02051b0:	6822                	ld	a6,8(sp)
ffffffffc02051b2:	6682                	ld	a3,0(sp)
          if (l) l->parent = b;
ffffffffc02051b4:	68c2                	ld	a7,16(sp)
          b->left = l;
ffffffffc02051b6:	00a83423          	sd	a0,8(a6)
          b->right = r;
ffffffffc02051ba:	00d83823          	sd	a3,16(a6)
          if (l) l->parent = b;
ffffffffc02051be:	6762                	ld	a4,24(sp)
ffffffffc02051c0:	7302                	ld	t1,32(sp)
ffffffffc02051c2:	77a2                	ld	a5,40(sp)
ffffffffc02051c4:	c119                	beqz	a0,ffffffffc02051ca <skew_heap_merge.constprop.0+0x78>
ffffffffc02051c6:	01053023          	sd	a6,0(a0)
     if (a == NULL) return b;
ffffffffc02051ca:	8642                	mv	a2,a6
          b->left = l;
ffffffffc02051cc:	e710                	sd	a2,8(a4)
          b->right = r;
ffffffffc02051ce:	00673823          	sd	t1,16(a4)
          if (l) l->parent = b;
ffffffffc02051d2:	e218                	sd	a4,0(a2)

          return b;
     }
}
ffffffffc02051d4:	70e2                	ld	ra,56(sp)
          b->left = l;
ffffffffc02051d6:	e798                	sd	a4,8(a5)
          b->right = r;
ffffffffc02051d8:	0117b823          	sd	a7,16(a5)
          if (l) l->parent = b;
ffffffffc02051dc:	e31c                	sd	a5,0(a4)
     if (a == NULL) return b;
ffffffffc02051de:	853e                	mv	a0,a5
}
ffffffffc02051e0:	6121                	addi	sp,sp,64
ffffffffc02051e2:	8082                	ret
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02051e4:	6914                	ld	a3,16(a0)
          r = a->left;
ffffffffc02051e6:	00853803          	ld	a6,8(a0)
     if (a == NULL) return b;
ffffffffc02051ea:	caa1                	beqz	a3,ffffffffc020523a <skew_heap_merge.constprop.0+0xe8>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc02051ec:	4e88                	lw	a0,24(a3)
ffffffffc02051ee:	40e5073b          	subw	a4,a0,a4
     else if (c == 0)
ffffffffc02051f2:	0a074063          	bltz	a4,ffffffffc0205292 <skew_heap_merge.constprop.0+0x140>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc02051f6:	6998                	ld	a4,16(a1)
          r = b->left;
ffffffffc02051f8:	0085b883          	ld	a7,8(a1)
     else if (b == NULL) return a;
ffffffffc02051fc:	cb1d                	beqz	a4,ffffffffc0205232 <skew_heap_merge.constprop.0+0xe0>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc02051fe:	4f0c                	lw	a1,24(a4)
ffffffffc0205200:	f43e                	sd	a5,40(sp)
ffffffffc0205202:	f032                	sd	a2,32(sp)
ffffffffc0205204:	9d0d                	subw	a0,a0,a1
ffffffffc0205206:	ec46                	sd	a7,24(sp)
ffffffffc0205208:	e842                	sd	a6,16(sp)
     else if (c == 0)
ffffffffc020520a:	0c054963          	bltz	a0,ffffffffc02052dc <skew_heap_merge.constprop.0+0x18a>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc020520e:	6b0c                	ld	a1,16(a4)
ffffffffc0205210:	8536                	mv	a0,a3
          r = b->left;
ffffffffc0205212:	6714                	ld	a3,8(a4)
ffffffffc0205214:	e43a                	sd	a4,8(sp)
ffffffffc0205216:	e036                	sd	a3,0(sp)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205218:	f3bff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          b->right = r;
ffffffffc020521c:	6722                	ld	a4,8(sp)
ffffffffc020521e:	6682                	ld	a3,0(sp)
          if (l) l->parent = b;
ffffffffc0205220:	6842                	ld	a6,16(sp)
          b->left = l;
ffffffffc0205222:	e708                	sd	a0,8(a4)
          b->right = r;
ffffffffc0205224:	eb14                	sd	a3,16(a4)
          if (l) l->parent = b;
ffffffffc0205226:	68e2                	ld	a7,24(sp)
ffffffffc0205228:	7602                	ld	a2,32(sp)
ffffffffc020522a:	77a2                	ld	a5,40(sp)
ffffffffc020522c:	c111                	beqz	a0,ffffffffc0205230 <skew_heap_merge.constprop.0+0xde>
ffffffffc020522e:	e118                	sd	a4,0(a0)
     if (a == NULL) return b;
ffffffffc0205230:	86ba                	mv	a3,a4
          b->left = l;
ffffffffc0205232:	e794                	sd	a3,8(a5)
          b->right = r;
ffffffffc0205234:	0117b823          	sd	a7,16(a5)
          if (l) l->parent = b;
ffffffffc0205238:	e29c                	sd	a5,0(a3)
}
ffffffffc020523a:	70e2                	ld	ra,56(sp)
          a->left = l;
ffffffffc020523c:	e61c                	sd	a5,8(a2)
          a->right = r;
ffffffffc020523e:	01063823          	sd	a6,16(a2)
          if (l) l->parent = a;
ffffffffc0205242:	e390                	sd	a2,0(a5)
     else if (b == NULL) return a;
ffffffffc0205244:	8532                	mv	a0,a2
}
ffffffffc0205246:	6121                	addi	sp,sp,64
ffffffffc0205248:	8082                	ret
          l = skew_heap_merge(a->right, b, comp);
ffffffffc020524a:	6914                	ld	a3,16(a0)
          r = a->left;
ffffffffc020524c:	00853803          	ld	a6,8(a0)
     if (a == NULL) return b;
ffffffffc0205250:	ca9d                	beqz	a3,ffffffffc0205286 <skew_heap_merge.constprop.0+0x134>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc0205252:	4e88                	lw	a0,24(a3)
ffffffffc0205254:	f43e                	sd	a5,40(sp)
ffffffffc0205256:	f032                	sd	a2,32(sp)
ffffffffc0205258:	40b505bb          	subw	a1,a0,a1
ffffffffc020525c:	ec42                	sd	a6,24(sp)
ffffffffc020525e:	e846                	sd	a7,16(sp)
     else if (c == 0)
ffffffffc0205260:	0405cb63          	bltz	a1,ffffffffc02052b6 <skew_heap_merge.constprop.0+0x164>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205264:	6b0c                	ld	a1,16(a4)
ffffffffc0205266:	8536                	mv	a0,a3
          r = b->left;
ffffffffc0205268:	6714                	ld	a3,8(a4)
ffffffffc020526a:	e43a                	sd	a4,8(sp)
ffffffffc020526c:	e036                	sd	a3,0(sp)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc020526e:	ee5ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          b->right = r;
ffffffffc0205272:	6722                	ld	a4,8(sp)
ffffffffc0205274:	6682                	ld	a3,0(sp)
          if (l) l->parent = b;
ffffffffc0205276:	68c2                	ld	a7,16(sp)
          b->left = l;
ffffffffc0205278:	e708                	sd	a0,8(a4)
          b->right = r;
ffffffffc020527a:	eb14                	sd	a3,16(a4)
          if (l) l->parent = b;
ffffffffc020527c:	6862                	ld	a6,24(sp)
ffffffffc020527e:	7602                	ld	a2,32(sp)
ffffffffc0205280:	77a2                	ld	a5,40(sp)
ffffffffc0205282:	c111                	beqz	a0,ffffffffc0205286 <skew_heap_merge.constprop.0+0x134>
ffffffffc0205284:	e118                	sd	a4,0(a0)
          a->left = l;
ffffffffc0205286:	e618                	sd	a4,8(a2)
          a->right = r;
ffffffffc0205288:	01063823          	sd	a6,16(a2)
          if (l) l->parent = a;
ffffffffc020528c:	e310                	sd	a2,0(a4)
     else if (b == NULL) return a;
ffffffffc020528e:	8732                	mv	a4,a2
ffffffffc0205290:	b791                	j	ffffffffc02051d4 <skew_heap_merge.constprop.0+0x82>
          r = a->left;
ffffffffc0205292:	669c                	ld	a5,8(a3)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205294:	6a88                	ld	a0,16(a3)
ffffffffc0205296:	ec32                	sd	a2,24(sp)
ffffffffc0205298:	e842                	sd	a6,16(sp)
          r = a->left;
ffffffffc020529a:	e436                	sd	a3,8(sp)
ffffffffc020529c:	e03e                	sd	a5,0(sp)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc020529e:	eb5ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          a->right = r;
ffffffffc02052a2:	66a2                	ld	a3,8(sp)
ffffffffc02052a4:	6782                	ld	a5,0(sp)
          if (l) l->parent = a;
ffffffffc02052a6:	6842                	ld	a6,16(sp)
          a->left = l;
ffffffffc02052a8:	e688                	sd	a0,8(a3)
          a->right = r;
ffffffffc02052aa:	ea9c                	sd	a5,16(a3)
          if (l) l->parent = a;
ffffffffc02052ac:	6662                	ld	a2,24(sp)
ffffffffc02052ae:	c111                	beqz	a0,ffffffffc02052b2 <skew_heap_merge.constprop.0+0x160>
ffffffffc02052b0:	e114                	sd	a3,0(a0)
     else if (b == NULL) return a;
ffffffffc02052b2:	87b6                	mv	a5,a3
ffffffffc02052b4:	b759                	j	ffffffffc020523a <skew_heap_merge.constprop.0+0xe8>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02052b6:	6a88                	ld	a0,16(a3)
ffffffffc02052b8:	85ba                	mv	a1,a4
          r = a->left;
ffffffffc02052ba:	6698                	ld	a4,8(a3)
ffffffffc02052bc:	e436                	sd	a3,8(sp)
ffffffffc02052be:	e03a                	sd	a4,0(sp)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02052c0:	e93ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          a->right = r;
ffffffffc02052c4:	66a2                	ld	a3,8(sp)
ffffffffc02052c6:	6702                	ld	a4,0(sp)
          if (l) l->parent = a;
ffffffffc02052c8:	68c2                	ld	a7,16(sp)
          a->left = l;
ffffffffc02052ca:	e688                	sd	a0,8(a3)
          a->right = r;
ffffffffc02052cc:	ea98                	sd	a4,16(a3)
          if (l) l->parent = a;
ffffffffc02052ce:	6862                	ld	a6,24(sp)
ffffffffc02052d0:	7602                	ld	a2,32(sp)
ffffffffc02052d2:	77a2                	ld	a5,40(sp)
ffffffffc02052d4:	c111                	beqz	a0,ffffffffc02052d8 <skew_heap_merge.constprop.0+0x186>
ffffffffc02052d6:	e114                	sd	a3,0(a0)
     else if (b == NULL) return a;
ffffffffc02052d8:	8736                	mv	a4,a3
ffffffffc02052da:	b775                	j	ffffffffc0205286 <skew_heap_merge.constprop.0+0x134>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02052dc:	6a88                	ld	a0,16(a3)
ffffffffc02052de:	85ba                	mv	a1,a4
          r = a->left;
ffffffffc02052e0:	6698                	ld	a4,8(a3)
ffffffffc02052e2:	e436                	sd	a3,8(sp)
ffffffffc02052e4:	e03a                	sd	a4,0(sp)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02052e6:	e6dff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          a->right = r;
ffffffffc02052ea:	66a2                	ld	a3,8(sp)
ffffffffc02052ec:	6702                	ld	a4,0(sp)
          if (l) l->parent = a;
ffffffffc02052ee:	6842                	ld	a6,16(sp)
          a->left = l;
ffffffffc02052f0:	e688                	sd	a0,8(a3)
          a->right = r;
ffffffffc02052f2:	ea98                	sd	a4,16(a3)
          if (l) l->parent = a;
ffffffffc02052f4:	68e2                	ld	a7,24(sp)
ffffffffc02052f6:	7602                	ld	a2,32(sp)
ffffffffc02052f8:	77a2                	ld	a5,40(sp)
ffffffffc02052fa:	dd05                	beqz	a0,ffffffffc0205232 <skew_heap_merge.constprop.0+0xe0>
ffffffffc02052fc:	e114                	sd	a3,0(a0)
          if (l) l->parent = b;
ffffffffc02052fe:	bf15                	j	ffffffffc0205232 <skew_heap_merge.constprop.0+0xe0>
          r = a->left;
ffffffffc0205300:	6614                	ld	a3,8(a2)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205302:	6908                	ld	a0,16(a0)
ffffffffc0205304:	85c2                	mv	a1,a6
          r = a->left;
ffffffffc0205306:	e432                	sd	a2,8(sp)
ffffffffc0205308:	e036                	sd	a3,0(sp)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc020530a:	e49ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          a->right = r;
ffffffffc020530e:	6622                	ld	a2,8(sp)
ffffffffc0205310:	6682                	ld	a3,0(sp)
          if (l) l->parent = a;
ffffffffc0205312:	68c2                	ld	a7,16(sp)
          a->left = l;
ffffffffc0205314:	e608                	sd	a0,8(a2)
          a->right = r;
ffffffffc0205316:	ea14                	sd	a3,16(a2)
          if (l) l->parent = a;
ffffffffc0205318:	6762                	ld	a4,24(sp)
ffffffffc020531a:	7302                	ld	t1,32(sp)
ffffffffc020531c:	77a2                	ld	a5,40(sp)
ffffffffc020531e:	ea0507e3          	beqz	a0,ffffffffc02051cc <skew_heap_merge.constprop.0+0x7a>
ffffffffc0205322:	e110                	sd	a2,0(a0)
          if (l) l->parent = b;
ffffffffc0205324:	b565                	j	ffffffffc02051cc <skew_heap_merge.constprop.0+0x7a>
     if (a == NULL) return b;
ffffffffc0205326:	852e                	mv	a0,a1
}
ffffffffc0205328:	8082                	ret
ffffffffc020532a:	8082                	ret

ffffffffc020532c <stride_pick_next>:
     if (rq->lab6_run_pool == NULL) {
ffffffffc020532c:	6d18                	ld	a4,24(a0)
ffffffffc020532e:	1e070a63          	beqz	a4,ffffffffc0205522 <stride_pick_next+0x1f6>
     uint32_t priority = (p->lab6_priority == 0) ? 1 : p->lab6_priority;
ffffffffc0205332:	4f54                	lw	a3,28(a4)
     struct proc_struct *p = le2proc(rq->lab6_run_pool, lab6_run_pool);
ffffffffc0205334:	ed870793          	addi	a5,a4,-296
     uint32_t priority = (p->lab6_priority == 0) ? 1 : p->lab6_priority;
ffffffffc0205338:	8636                	mv	a2,a3
ffffffffc020533a:	c29d                	beqz	a3,ffffffffc0205360 <stride_pick_next+0x34>
     if (p->lab6_stride > STRIDE_OVERFLOW_THRESHOLD) {
ffffffffc020533c:	01872e03          	lw	t3,24(a4)
     uint32_t stride_inc = BIG_STRIDE / priority;
ffffffffc0205340:	800006b7          	lui	a3,0x80000
ffffffffc0205344:	36fd                	addiw	a3,a3,-1 # 7fffffff <_binary_obj___user_matrix_out_size+0x7fff4acf>
     if (p->lab6_stride > STRIDE_OVERFLOW_THRESHOLD) {
ffffffffc0205346:	800005b7          	lui	a1,0x80000
     uint32_t stride_inc = BIG_STRIDE / priority;
ffffffffc020534a:	02c6d6bb          	divuw	a3,a3,a2
     if (p->lab6_stride > STRIDE_OVERFLOW_THRESHOLD) {
ffffffffc020534e:	03c5e563          	bltu	a1,t3,ffffffffc0205378 <stride_pick_next+0x4c>
     p->lab6_stride += stride_inc;
ffffffffc0205352:	1407a703          	lw	a4,320(a5)
}
ffffffffc0205356:	853e                	mv	a0,a5
     p->lab6_stride += stride_inc;
ffffffffc0205358:	9f35                	addw	a4,a4,a3
ffffffffc020535a:	14e7a023          	sw	a4,320(a5)
}
ffffffffc020535e:	8082                	ret
     if (p->lab6_stride > STRIDE_OVERFLOW_THRESHOLD) {
ffffffffc0205360:	01872e03          	lw	t3,24(a4)
     uint32_t stride_inc = BIG_STRIDE / priority;
ffffffffc0205364:	800006b7          	lui	a3,0x80000
     uint32_t priority = (p->lab6_priority == 0) ? 1 : p->lab6_priority;
ffffffffc0205368:	4605                	li	a2,1
     uint32_t stride_inc = BIG_STRIDE / priority;
ffffffffc020536a:	36fd                	addiw	a3,a3,-1 # 7fffffff <_binary_obj___user_matrix_out_size+0x7fff4acf>
     if (p->lab6_stride > STRIDE_OVERFLOW_THRESHOLD) {
ffffffffc020536c:	800005b7          	lui	a1,0x80000
     uint32_t stride_inc = BIG_STRIDE / priority;
ffffffffc0205370:	02c6d6bb          	divuw	a3,a3,a2
     if (p->lab6_stride > STRIDE_OVERFLOW_THRESHOLD) {
ffffffffc0205374:	fdc5ffe3          	bgeu	a1,t3,ffffffffc0205352 <stride_pick_next+0x26>
    if (rq->lab6_run_pool == NULL || rq->proc_num == 0) {
ffffffffc0205378:	4910                	lw	a2,16(a0)
ffffffffc020537a:	de61                	beqz	a2,ffffffffc0205352 <stride_pick_next+0x26>
{
ffffffffc020537c:	7119                	addi	sp,sp,-128
ffffffffc020537e:	06010e93          	addi	t4,sp,96
ffffffffc0205382:	00073803          	ld	a6,0(a4)
ffffffffc0205386:	fc86                	sd	ra,120(sp)
ffffffffc0205388:	f8a2                	sd	s0,112(sp)
ffffffffc020538a:	88aa                	mv	a7,a0
ffffffffc020538c:	f0f6                	sd	t4,96(sp)
ffffffffc020538e:	8f76                	mv	t5,t4
ffffffffc0205390:	fe870f93          	addi	t6,a4,-24
static inline skew_heap_entry_t *
skew_heap_remove(skew_heap_entry_t *a, skew_heap_entry_t *b,
                 compare_f comp)
{
     skew_heap_entry_t *p   = b->parent;
     skew_heap_entry_t *rep = skew_heap_merge(b->left, b->right, comp);
ffffffffc0205394:	6710                	ld	a2,8(a4)
ffffffffc0205396:	6b14                	ld	a3,16(a4)
     skew_heap_entry_t *p   = b->parent;
ffffffffc0205398:	87c2                	mv	a5,a6
     if (a == NULL) return b;
ffffffffc020539a:	c26d                	beqz	a2,ffffffffc020547c <stride_pick_next+0x150>
     else if (b == NULL) return a;
ffffffffc020539c:	1e068b63          	beqz	a3,ffffffffc0205592 <stride_pick_next+0x266>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc02053a0:	4e0c                	lw	a1,24(a2)
ffffffffc02053a2:	4e88                	lw	a0,24(a3)
ffffffffc02053a4:	40a5833b          	subw	t1,a1,a0
     else if (c == 0)
ffffffffc02053a8:	18034363          	bltz	t1,ffffffffc020552e <stride_pick_next+0x202>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc02053ac:	0106b303          	ld	t1,16(a3)
          r = b->left;
ffffffffc02053b0:	0086b383          	ld	t2,8(a3)
     else if (b == NULL) return a;
ffffffffc02053b4:	2a030063          	beqz	t1,ffffffffc0205654 <stride_pick_next+0x328>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc02053b8:	01832503          	lw	a0,24(t1)
ffffffffc02053bc:	40a5853b          	subw	a0,a1,a0
     else if (c == 0)
ffffffffc02053c0:	24054763          	bltz	a0,ffffffffc020560e <stride_pick_next+0x2e2>
          r = b->left;
ffffffffc02053c4:	00833503          	ld	a0,8(t1)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc02053c8:	01033283          	ld	t0,16(t1)
          r = b->left;
ffffffffc02053cc:	842a                	mv	s0,a0
     else if (b == NULL) return a;
ffffffffc02053ce:	06028063          	beqz	t0,ffffffffc020542e <stride_pick_next+0x102>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc02053d2:	0182a503          	lw	a0,24(t0) # fffffffffff80018 <end+0x3fcca9a8>
ffffffffc02053d6:	ecc6                	sd	a7,88(sp)
ffffffffc02053d8:	e8fe                	sd	t6,80(sp)
ffffffffc02053da:	9d89                	subw	a1,a1,a0
ffffffffc02053dc:	e4c2                	sd	a6,72(sp)
ffffffffc02053de:	e0c2                	sd	a6,64(sp)
ffffffffc02053e0:	fc7a                	sd	t5,56(sp)
ffffffffc02053e2:	f836                	sd	a3,48(sp)
ffffffffc02053e4:	f41e                	sd	t2,40(sp)
ffffffffc02053e6:	f01a                	sd	t1,32(sp)
ffffffffc02053e8:	ec3a                	sd	a4,24(sp)
ffffffffc02053ea:	e872                	sd	t3,16(sp)
     else if (c == 0)
ffffffffc02053ec:	2c05cb63          	bltz	a1,ffffffffc02056c2 <stride_pick_next+0x396>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc02053f0:	0102b583          	ld	a1,16(t0)
ffffffffc02053f4:	8532                	mv	a0,a2
          r = b->left;
ffffffffc02053f6:	0082b603          	ld	a2,8(t0)
ffffffffc02053fa:	e416                	sd	t0,8(sp)
ffffffffc02053fc:	e032                	sd	a2,0(sp)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc02053fe:	d55ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          b->right = r;
ffffffffc0205402:	62a2                	ld	t0,8(sp)
ffffffffc0205404:	6602                	ld	a2,0(sp)
          if (l) l->parent = b;
ffffffffc0205406:	6e42                	ld	t3,16(sp)
          b->left = l;
ffffffffc0205408:	00a2b423          	sd	a0,8(t0)
          b->right = r;
ffffffffc020540c:	00c2b823          	sd	a2,16(t0)
          if (l) l->parent = b;
ffffffffc0205410:	6762                	ld	a4,24(sp)
ffffffffc0205412:	7302                	ld	t1,32(sp)
ffffffffc0205414:	73a2                	ld	t2,40(sp)
ffffffffc0205416:	76c2                	ld	a3,48(sp)
ffffffffc0205418:	7f62                	ld	t5,56(sp)
ffffffffc020541a:	6786                	ld	a5,64(sp)
ffffffffc020541c:	6826                	ld	a6,72(sp)
ffffffffc020541e:	6fc6                	ld	t6,80(sp)
ffffffffc0205420:	68e6                	ld	a7,88(sp)
ffffffffc0205422:	06010e93          	addi	t4,sp,96
ffffffffc0205426:	c119                	beqz	a0,ffffffffc020542c <stride_pick_next+0x100>
ffffffffc0205428:	00553023          	sd	t0,0(a0)
     if (a == NULL) return b;
ffffffffc020542c:	8616                	mv	a2,t0
          b->left = l;
ffffffffc020542e:	00c33423          	sd	a2,8(t1)
          b->right = r;
ffffffffc0205432:	00833823          	sd	s0,16(t1)
          if (l) l->parent = b;
ffffffffc0205436:	00663023          	sd	t1,0(a2)
          b->left = l;
ffffffffc020543a:	0066b423          	sd	t1,8(a3)
          b->right = r;
ffffffffc020543e:	0076b823          	sd	t2,16(a3)
          if (l) l->parent = b;
ffffffffc0205442:	00d33023          	sd	a3,0(t1)
     if (rep) rep->parent = p;
ffffffffc0205446:	0106b023          	sd	a6,0(a3)
     
     if (p)
ffffffffc020544a:	14081963          	bnez	a6,ffffffffc020559c <stride_pick_next+0x270>
        proc->lab6_stride -= min_stride;  // Normalize: subtract minimum
ffffffffc020544e:	4f1c                	lw	a5,24(a4)
        rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
ffffffffc0205450:	00d8bc23          	sd	a3,24(a7)
        proc->lab6_stride -= min_stride;  // Normalize: subtract minimum
ffffffffc0205454:	0006b803          	ld	a6,0(a3)
ffffffffc0205458:	41c787bb          	subw	a5,a5,t3
ffffffffc020545c:	cf1c                	sw	a5,24(a4)
    prev->next = next->prev = elm;
ffffffffc020545e:	01ff3023          	sd	t6,0(t5)
ffffffffc0205462:	f4fe                	sd	t6,104(sp)
    elm->next = next;
ffffffffc0205464:	ffe73823          	sd	t5,-16(a4)
    elm->prev = prev;
ffffffffc0205468:	ffd73423          	sd	t4,-24(a4)
          if (p->left == b)
               p->left = rep;
          else p->right = rep;
          return a;
     }
     else return rep;
ffffffffc020546c:	8736                	mv	a4,a3
     skew_heap_entry_t *rep = skew_heap_merge(b->left, b->right, comp);
ffffffffc020546e:	6710                	ld	a2,8(a4)
ffffffffc0205470:	fe868f93          	addi	t6,a3,-24
    return list->next == list;
ffffffffc0205474:	7f26                	ld	t5,104(sp)
ffffffffc0205476:	6b14                	ld	a3,16(a4)
     skew_heap_entry_t *p   = b->parent;
ffffffffc0205478:	87c2                	mv	a5,a6
     if (a == NULL) return b;
ffffffffc020547a:	f20d                	bnez	a2,ffffffffc020539c <stride_pick_next+0x70>
     if (rep) rep->parent = p;
ffffffffc020547c:	10069c63          	bnez	a3,ffffffffc0205594 <stride_pick_next+0x268>
     if (p)
ffffffffc0205480:	12081063          	bnez	a6,ffffffffc02055a0 <stride_pick_next+0x274>
ffffffffc0205484:	4f14                	lw	a3,24(a4)
        rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
ffffffffc0205486:	0008bc23          	sd	zero,24(a7)
        proc->lab6_stride -= min_stride;  // Normalize: subtract minimum
ffffffffc020548a:	41c686bb          	subw	a3,a3,t3
ffffffffc020548e:	cf14                	sw	a3,24(a4)
    prev->next = next->prev = elm;
ffffffffc0205490:	01ff3023          	sd	t6,0(t5)
ffffffffc0205494:	f4fe                	sd	t6,104(sp)
    elm->next = next;
ffffffffc0205496:	ffe73823          	sd	t5,-16(a4)
    return list->next == list;
ffffffffc020549a:	76a6                	ld	a3,104(sp)
    elm->prev = prev;
ffffffffc020549c:	ffd73423          	sd	t4,-24(a4)
    while (!list_empty(&temp_list)) {
ffffffffc02054a0:	05d68c63          	beq	a3,t4,ffffffffc02054f8 <stride_pick_next+0x1cc>
    __list_del(listelm->prev, listelm->next);
ffffffffc02054a4:	6290                	ld	a2,0(a3)
ffffffffc02054a6:	6698                	ld	a4,8(a3)
        rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
ffffffffc02054a8:	01868793          	addi	a5,a3,24
    prev->next = next;
ffffffffc02054ac:	e618                	sd	a4,8(a2)
    next->prev = prev;
ffffffffc02054ae:	e310                	sd	a2,0(a4)
     a->left = a->right = a->parent = NULL;
ffffffffc02054b0:	0006bc23          	sd	zero,24(a3)
ffffffffc02054b4:	0206b423          	sd	zero,40(a3)
ffffffffc02054b8:	0206b023          	sd	zero,32(a3)
    return list->next == list;
ffffffffc02054bc:	7726                	ld	a4,104(sp)
ffffffffc02054be:	00f8bc23          	sd	a5,24(a7)
    while (!list_empty(&temp_list)) {
ffffffffc02054c2:	03d70b63          	beq	a4,t4,ffffffffc02054f8 <stride_pick_next+0x1cc>
    __list_del(listelm->prev, listelm->next);
ffffffffc02054c6:	6710                	ld	a2,8(a4)
ffffffffc02054c8:	630c                	ld	a1,0(a4)
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc02054ca:	4f94                	lw	a3,24(a5)
ffffffffc02054cc:	5b08                	lw	a0,48(a4)
    prev->next = next;
ffffffffc02054ce:	e590                	sd	a2,8(a1)
    next->prev = prev;
ffffffffc02054d0:	e20c                	sd	a1,0(a2)
ffffffffc02054d2:	00073c23          	sd	zero,24(a4)
ffffffffc02054d6:	02073423          	sd	zero,40(a4)
ffffffffc02054da:	02073023          	sd	zero,32(a4)
ffffffffc02054de:	9e89                	subw	a3,a3,a0
        rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
ffffffffc02054e0:	01870613          	addi	a2,a4,24
     else if (c == 0)
ffffffffc02054e4:	0e06c363          	bltz	a3,ffffffffc02055ca <stride_pick_next+0x29e>
          b->left = l;
ffffffffc02054e8:	f31c                	sd	a5,32(a4)
    return list->next == list;
ffffffffc02054ea:	7726                	ld	a4,104(sp)
          if (l) l->parent = b;
ffffffffc02054ec:	e390                	sd	a2,0(a5)
          return b;
ffffffffc02054ee:	87b2                	mv	a5,a2
        rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
ffffffffc02054f0:	00f8bc23          	sd	a5,24(a7)
    while (!list_empty(&temp_list)) {
ffffffffc02054f4:	fdd719e3          	bne	a4,t4,ffffffffc02054c6 <stride_pick_next+0x19a>
         priority = (p->lab6_priority == 0) ? 1 : p->lab6_priority;
ffffffffc02054f8:	4fd8                	lw	a4,28(a5)
         p = le2proc(rq->lab6_run_pool, lab6_run_pool);
ffffffffc02054fa:	ed878793          	addi	a5,a5,-296
         priority = (p->lab6_priority == 0) ? 1 : p->lab6_priority;
ffffffffc02054fe:	863a                	mv	a2,a4
ffffffffc0205500:	14070c63          	beqz	a4,ffffffffc0205658 <stride_pick_next+0x32c>
         stride_inc = BIG_STRIDE / priority;
ffffffffc0205504:	800006b7          	lui	a3,0x80000
ffffffffc0205508:	36fd                	addiw	a3,a3,-1 # 7fffffff <_binary_obj___user_matrix_out_size+0x7fff4acf>
ffffffffc020550a:	02c6d6bb          	divuw	a3,a3,a2
     p->lab6_stride += stride_inc;
ffffffffc020550e:	1407a703          	lw	a4,320(a5)
}
ffffffffc0205512:	70e6                	ld	ra,120(sp)
ffffffffc0205514:	7446                	ld	s0,112(sp)
ffffffffc0205516:	853e                	mv	a0,a5
     p->lab6_stride += stride_inc;
ffffffffc0205518:	9f35                	addw	a4,a4,a3
ffffffffc020551a:	14e7a023          	sw	a4,320(a5)
}
ffffffffc020551e:	6109                	addi	sp,sp,128
ffffffffc0205520:	8082                	ret
         return idleproc;  // 无就绪进程，返回空闲进程
ffffffffc0205522:	000b0797          	auipc	a5,0xb0
ffffffffc0205526:	1367b783          	ld	a5,310(a5) # ffffffffc02b5658 <idleproc>
}
ffffffffc020552a:	853e                	mv	a0,a5
ffffffffc020552c:	8082                	ret
          l = skew_heap_merge(a->right, b, comp);
ffffffffc020552e:	01063303          	ld	t1,16(a2)
          r = a->left;
ffffffffc0205532:	00863283          	ld	t0,8(a2)
     if (a == NULL) return b;
ffffffffc0205536:	04030a63          	beqz	t1,ffffffffc020558a <stride_pick_next+0x25e>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc020553a:	01832583          	lw	a1,24(t1)
ffffffffc020553e:	e8c6                	sd	a7,80(sp)
ffffffffc0205540:	e4fe                	sd	t6,72(sp)
ffffffffc0205542:	9d89                	subw	a1,a1,a0
ffffffffc0205544:	e0c2                	sd	a6,64(sp)
ffffffffc0205546:	fc42                	sd	a6,56(sp)
ffffffffc0205548:	f87a                	sd	t5,48(sp)
ffffffffc020554a:	f416                	sd	t0,40(sp)
ffffffffc020554c:	f03a                	sd	a4,32(sp)
ffffffffc020554e:	ec32                	sd	a2,24(sp)
ffffffffc0205550:	e872                	sd	t3,16(sp)
     else if (c == 0)
ffffffffc0205552:	1005c563          	bltz	a1,ffffffffc020565c <stride_pick_next+0x330>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205556:	6a8c                	ld	a1,16(a3)
ffffffffc0205558:	851a                	mv	a0,t1
          r = b->left;
ffffffffc020555a:	0086b303          	ld	t1,8(a3)
ffffffffc020555e:	e436                	sd	a3,8(sp)
ffffffffc0205560:	e01a                	sd	t1,0(sp)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205562:	bf1ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          b->right = r;
ffffffffc0205566:	66a2                	ld	a3,8(sp)
ffffffffc0205568:	6302                	ld	t1,0(sp)
          if (l) l->parent = b;
ffffffffc020556a:	6e42                	ld	t3,16(sp)
          b->left = l;
ffffffffc020556c:	e688                	sd	a0,8(a3)
          b->right = r;
ffffffffc020556e:	0066b823          	sd	t1,16(a3)
          if (l) l->parent = b;
ffffffffc0205572:	6662                	ld	a2,24(sp)
ffffffffc0205574:	7702                	ld	a4,32(sp)
ffffffffc0205576:	72a2                	ld	t0,40(sp)
ffffffffc0205578:	7f42                	ld	t5,48(sp)
ffffffffc020557a:	77e2                	ld	a5,56(sp)
ffffffffc020557c:	6806                	ld	a6,64(sp)
ffffffffc020557e:	6fa6                	ld	t6,72(sp)
ffffffffc0205580:	68c6                	ld	a7,80(sp)
ffffffffc0205582:	06010e93          	addi	t4,sp,96
ffffffffc0205586:	c111                	beqz	a0,ffffffffc020558a <stride_pick_next+0x25e>
ffffffffc0205588:	e114                	sd	a3,0(a0)
          a->left = l;
ffffffffc020558a:	e614                	sd	a3,8(a2)
          a->right = r;
ffffffffc020558c:	00563823          	sd	t0,16(a2)
          if (l) l->parent = a;
ffffffffc0205590:	e290                	sd	a2,0(a3)
     else if (b == NULL) return a;
ffffffffc0205592:	86b2                	mv	a3,a2
     if (rep) rep->parent = p;
ffffffffc0205594:	0106b023          	sd	a6,0(a3)
     if (p)
ffffffffc0205598:	ea080be3          	beqz	a6,ffffffffc020544e <stride_pick_next+0x122>
ffffffffc020559c:	00073803          	ld	a6,0(a4)
          if (p->left == b)
ffffffffc02055a0:	6790                	ld	a2,8(a5)
ffffffffc02055a2:	02e60263          	beq	a2,a4,ffffffffc02055c6 <stride_pick_next+0x29a>
          else p->right = rep;
ffffffffc02055a6:	eb94                	sd	a3,16(a5)
        proc->lab6_stride -= min_stride;  // Normalize: subtract minimum
ffffffffc02055a8:	4f1c                	lw	a5,24(a4)
        rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
ffffffffc02055aa:	00e8bc23          	sd	a4,24(a7)
        proc->lab6_stride -= min_stride;  // Normalize: subtract minimum
ffffffffc02055ae:	41c787bb          	subw	a5,a5,t3
ffffffffc02055b2:	cf1c                	sw	a5,24(a4)
    prev->next = next->prev = elm;
ffffffffc02055b4:	01ff3023          	sd	t6,0(t5)
ffffffffc02055b8:	f4fe                	sd	t6,104(sp)
    elm->next = next;
ffffffffc02055ba:	ffe73823          	sd	t5,-16(a4)
    return list->next == list;
ffffffffc02055be:	7f26                	ld	t5,104(sp)
    elm->prev = prev;
ffffffffc02055c0:	ffd73423          	sd	t4,-24(a4)
    while (rq->lab6_run_pool != NULL) {
ffffffffc02055c4:	bbc1                	j	ffffffffc0205394 <stride_pick_next+0x68>
               p->left = rep;
ffffffffc02055c6:	e794                	sd	a3,8(a5)
ffffffffc02055c8:	b7c5                	j	ffffffffc02055a8 <stride_pick_next+0x27c>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02055ca:	6b94                	ld	a3,16(a5)
          r = a->left;
ffffffffc02055cc:	0087b803          	ld	a6,8(a5)
     if (a == NULL) return b;
ffffffffc02055d0:	ca95                	beqz	a3,ffffffffc0205604 <stride_pick_next+0x2d8>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc02055d2:	4e8c                	lw	a1,24(a3)
ffffffffc02055d4:	f046                	sd	a7,32(sp)
ffffffffc02055d6:	ec3e                	sd	a5,24(sp)
ffffffffc02055d8:	9d89                	subw	a1,a1,a0
ffffffffc02055da:	e842                	sd	a6,16(sp)
     else if (c == 0)
ffffffffc02055dc:	0a05cf63          	bltz	a1,ffffffffc020569a <stride_pick_next+0x36e>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc02055e0:	8536                	mv	a0,a3
ffffffffc02055e2:	4581                	li	a1,0
ffffffffc02055e4:	e432                	sd	a2,8(sp)
ffffffffc02055e6:	e03a                	sd	a4,0(sp)
ffffffffc02055e8:	b6bff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          b->right = r;
ffffffffc02055ec:	6702                	ld	a4,0(sp)
          if (l) l->parent = b;
ffffffffc02055ee:	6622                	ld	a2,8(sp)
ffffffffc02055f0:	6842                	ld	a6,16(sp)
          b->right = r;
ffffffffc02055f2:	02073423          	sd	zero,40(a4)
          b->left = l;
ffffffffc02055f6:	f308                	sd	a0,32(a4)
          if (l) l->parent = b;
ffffffffc02055f8:	67e2                	ld	a5,24(sp)
ffffffffc02055fa:	7882                	ld	a7,32(sp)
ffffffffc02055fc:	06010e93          	addi	t4,sp,96
ffffffffc0205600:	c111                	beqz	a0,ffffffffc0205604 <stride_pick_next+0x2d8>
ffffffffc0205602:	e110                	sd	a2,0(a0)
          a->left = l;
ffffffffc0205604:	e790                	sd	a2,8(a5)
          a->right = r;
ffffffffc0205606:	0107b823          	sd	a6,16(a5)
          if (l) l->parent = a;
ffffffffc020560a:	e21c                	sd	a5,0(a2)
ffffffffc020560c:	bd45                	j	ffffffffc02054bc <stride_pick_next+0x190>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc020560e:	6a08                	ld	a0,16(a2)
ffffffffc0205610:	859a                	mv	a1,t1
          r = a->left;
ffffffffc0205612:	00863303          	ld	t1,8(a2)
ffffffffc0205616:	e8c6                	sd	a7,80(sp)
ffffffffc0205618:	e4fe                	sd	t6,72(sp)
ffffffffc020561a:	e0c2                	sd	a6,64(sp)
ffffffffc020561c:	fc42                	sd	a6,56(sp)
ffffffffc020561e:	f87a                	sd	t5,48(sp)
ffffffffc0205620:	f436                	sd	a3,40(sp)
ffffffffc0205622:	f01e                	sd	t2,32(sp)
ffffffffc0205624:	ec3a                	sd	a4,24(sp)
ffffffffc0205626:	e872                	sd	t3,16(sp)
ffffffffc0205628:	e432                	sd	a2,8(sp)
ffffffffc020562a:	e01a                	sd	t1,0(sp)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc020562c:	b27ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          a->right = r;
ffffffffc0205630:	6622                	ld	a2,8(sp)
ffffffffc0205632:	6302                	ld	t1,0(sp)
          if (l) l->parent = a;
ffffffffc0205634:	6e42                	ld	t3,16(sp)
          a->left = l;
ffffffffc0205636:	e608                	sd	a0,8(a2)
          a->right = r;
ffffffffc0205638:	00663823          	sd	t1,16(a2)
          if (l) l->parent = a;
ffffffffc020563c:	6762                	ld	a4,24(sp)
ffffffffc020563e:	7382                	ld	t2,32(sp)
ffffffffc0205640:	76a2                	ld	a3,40(sp)
ffffffffc0205642:	7f42                	ld	t5,48(sp)
ffffffffc0205644:	77e2                	ld	a5,56(sp)
ffffffffc0205646:	6806                	ld	a6,64(sp)
ffffffffc0205648:	6fa6                	ld	t6,72(sp)
ffffffffc020564a:	68c6                	ld	a7,80(sp)
ffffffffc020564c:	06010e93          	addi	t4,sp,96
ffffffffc0205650:	c111                	beqz	a0,ffffffffc0205654 <stride_pick_next+0x328>
ffffffffc0205652:	e110                	sd	a2,0(a0)
     else if (b == NULL) return a;
ffffffffc0205654:	8332                	mv	t1,a2
ffffffffc0205656:	b3d5                	j	ffffffffc020543a <stride_pick_next+0x10e>
         priority = (p->lab6_priority == 0) ? 1 : p->lab6_priority;
ffffffffc0205658:	4605                	li	a2,1
ffffffffc020565a:	b56d                	j	ffffffffc0205504 <stride_pick_next+0x1d8>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc020565c:	01033503          	ld	a0,16(t1)
ffffffffc0205660:	85b6                	mv	a1,a3
          r = a->left;
ffffffffc0205662:	00833683          	ld	a3,8(t1)
ffffffffc0205666:	e41a                	sd	t1,8(sp)
ffffffffc0205668:	e036                	sd	a3,0(sp)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc020566a:	ae9ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          a->right = r;
ffffffffc020566e:	6322                	ld	t1,8(sp)
ffffffffc0205670:	6682                	ld	a3,0(sp)
          if (l) l->parent = a;
ffffffffc0205672:	6e42                	ld	t3,16(sp)
          a->left = l;
ffffffffc0205674:	00a33423          	sd	a0,8(t1)
          a->right = r;
ffffffffc0205678:	00d33823          	sd	a3,16(t1)
          if (l) l->parent = a;
ffffffffc020567c:	6662                	ld	a2,24(sp)
ffffffffc020567e:	7702                	ld	a4,32(sp)
ffffffffc0205680:	72a2                	ld	t0,40(sp)
ffffffffc0205682:	7f42                	ld	t5,48(sp)
ffffffffc0205684:	77e2                	ld	a5,56(sp)
ffffffffc0205686:	6806                	ld	a6,64(sp)
ffffffffc0205688:	6fa6                	ld	t6,72(sp)
ffffffffc020568a:	68c6                	ld	a7,80(sp)
ffffffffc020568c:	06010e93          	addi	t4,sp,96
ffffffffc0205690:	c119                	beqz	a0,ffffffffc0205696 <stride_pick_next+0x36a>
ffffffffc0205692:	00653023          	sd	t1,0(a0)
     else if (b == NULL) return a;
ffffffffc0205696:	869a                	mv	a3,t1
ffffffffc0205698:	bdcd                	j	ffffffffc020558a <stride_pick_next+0x25e>
          r = a->left;
ffffffffc020569a:	6698                	ld	a4,8(a3)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc020569c:	6a88                	ld	a0,16(a3)
ffffffffc020569e:	85b2                	mv	a1,a2
          r = a->left;
ffffffffc02056a0:	e436                	sd	a3,8(sp)
ffffffffc02056a2:	e03a                	sd	a4,0(sp)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02056a4:	aafff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          a->right = r;
ffffffffc02056a8:	66a2                	ld	a3,8(sp)
ffffffffc02056aa:	6702                	ld	a4,0(sp)
          if (l) l->parent = a;
ffffffffc02056ac:	6842                	ld	a6,16(sp)
          a->left = l;
ffffffffc02056ae:	e688                	sd	a0,8(a3)
          a->right = r;
ffffffffc02056b0:	ea98                	sd	a4,16(a3)
          if (l) l->parent = a;
ffffffffc02056b2:	67e2                	ld	a5,24(sp)
ffffffffc02056b4:	7882                	ld	a7,32(sp)
ffffffffc02056b6:	06010e93          	addi	t4,sp,96
ffffffffc02056ba:	c111                	beqz	a0,ffffffffc02056be <stride_pick_next+0x392>
ffffffffc02056bc:	e114                	sd	a3,0(a0)
     else if (b == NULL) return a;
ffffffffc02056be:	8636                	mv	a2,a3
ffffffffc02056c0:	b791                	j	ffffffffc0205604 <stride_pick_next+0x2d8>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02056c2:	6a08                	ld	a0,16(a2)
ffffffffc02056c4:	8596                	mv	a1,t0
          r = a->left;
ffffffffc02056c6:	00863283          	ld	t0,8(a2)
ffffffffc02056ca:	e432                	sd	a2,8(sp)
ffffffffc02056cc:	e016                	sd	t0,0(sp)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02056ce:	a85ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          a->right = r;
ffffffffc02056d2:	6622                	ld	a2,8(sp)
ffffffffc02056d4:	6282                	ld	t0,0(sp)
          if (l) l->parent = a;
ffffffffc02056d6:	6e42                	ld	t3,16(sp)
          a->left = l;
ffffffffc02056d8:	e608                	sd	a0,8(a2)
          a->right = r;
ffffffffc02056da:	00563823          	sd	t0,16(a2)
          if (l) l->parent = a;
ffffffffc02056de:	6762                	ld	a4,24(sp)
ffffffffc02056e0:	7302                	ld	t1,32(sp)
ffffffffc02056e2:	73a2                	ld	t2,40(sp)
ffffffffc02056e4:	76c2                	ld	a3,48(sp)
ffffffffc02056e6:	7f62                	ld	t5,56(sp)
ffffffffc02056e8:	6786                	ld	a5,64(sp)
ffffffffc02056ea:	6826                	ld	a6,72(sp)
ffffffffc02056ec:	6fc6                	ld	t6,80(sp)
ffffffffc02056ee:	68e6                	ld	a7,88(sp)
ffffffffc02056f0:	06010e93          	addi	t4,sp,96
ffffffffc02056f4:	d2050de3          	beqz	a0,ffffffffc020542e <stride_pick_next+0x102>
ffffffffc02056f8:	e110                	sd	a2,0(a0)
          if (l) l->parent = b;
ffffffffc02056fa:	bb15                	j	ffffffffc020542e <stride_pick_next+0x102>

ffffffffc02056fc <stride_dequeue>:
{
ffffffffc02056fc:	711d                	addi	sp,sp,-96
ffffffffc02056fe:	ec86                	sd	ra,88(sp)
     assert(proc && rq);
ffffffffc0205700:	2c058a63          	beqz	a1,ffffffffc02059d4 <stride_dequeue+0x2d8>
ffffffffc0205704:	86aa                	mv	a3,a0
ffffffffc0205706:	2c050763          	beqz	a0,ffffffffc02059d4 <stride_dequeue+0x2d8>
     skew_heap_entry_t *rep = skew_heap_merge(b->left, b->right, comp);
ffffffffc020570a:	1305b603          	ld	a2,304(a1) # ffffffff80000130 <_binary_obj___user_matrix_out_size+0xffffffff7fff4c00>
     rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
ffffffffc020570e:	01853303          	ld	t1,24(a0)
     skew_heap_entry_t *p   = b->parent;
ffffffffc0205712:	1285b803          	ld	a6,296(a1)
     skew_heap_entry_t *rep = skew_heap_merge(b->left, b->right, comp);
ffffffffc0205716:	1385b783          	ld	a5,312(a1)
ffffffffc020571a:	872e                	mv	a4,a1
     if (a == NULL) return b;
ffffffffc020571c:	16060263          	beqz	a2,ffffffffc0205880 <stride_dequeue+0x184>
     else if (b == NULL) return a;
ffffffffc0205720:	14078963          	beqz	a5,ffffffffc0205872 <stride_dequeue+0x176>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc0205724:	4e0c                	lw	a1,24(a2)
ffffffffc0205726:	4f88                	lw	a0,24(a5)
ffffffffc0205728:	40a588bb          	subw	a7,a1,a0
     else if (c == 0)
ffffffffc020572c:	0a08cf63          	bltz	a7,ffffffffc02057ea <stride_dequeue+0xee>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205730:	0107b883          	ld	a7,16(a5)
          r = b->left;
ffffffffc0205734:	0087be83          	ld	t4,8(a5)
     else if (b == NULL) return a;
ffffffffc0205738:	1a088b63          	beqz	a7,ffffffffc02058ee <stride_dequeue+0x1f2>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc020573c:	0188a503          	lw	a0,24(a7)
ffffffffc0205740:	40a58e3b          	subw	t3,a1,a0
     else if (c == 0)
ffffffffc0205744:	140e4263          	bltz	t3,ffffffffc0205888 <stride_dequeue+0x18c>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205748:	0108be03          	ld	t3,16(a7)
          r = b->left;
ffffffffc020574c:	0088bf03          	ld	t5,8(a7)
     else if (b == NULL) return a;
ffffffffc0205750:	040e0a63          	beqz	t3,ffffffffc02057a4 <stride_dequeue+0xa8>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc0205754:	018e2503          	lw	a0,24(t3)
ffffffffc0205758:	e4ba                	sd	a4,72(sp)
ffffffffc020575a:	e0b6                	sd	a3,64(sp)
ffffffffc020575c:	9d89                	subw	a1,a1,a0
ffffffffc020575e:	fc3e                	sd	a5,56(sp)
ffffffffc0205760:	f87a                	sd	t5,48(sp)
ffffffffc0205762:	f446                	sd	a7,40(sp)
ffffffffc0205764:	f076                	sd	t4,32(sp)
ffffffffc0205766:	ec42                	sd	a6,24(sp)
ffffffffc0205768:	e81a                	sd	t1,16(sp)
     else if (c == 0)
ffffffffc020576a:	2205cc63          	bltz	a1,ffffffffc02059a2 <stride_dequeue+0x2a6>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc020576e:	010e3583          	ld	a1,16(t3)
ffffffffc0205772:	8532                	mv	a0,a2
          r = b->left;
ffffffffc0205774:	008e3603          	ld	a2,8(t3)
ffffffffc0205778:	e472                	sd	t3,8(sp)
ffffffffc020577a:	e032                	sd	a2,0(sp)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc020577c:	9d7ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          b->right = r;
ffffffffc0205780:	6e22                	ld	t3,8(sp)
ffffffffc0205782:	6602                	ld	a2,0(sp)
          if (l) l->parent = b;
ffffffffc0205784:	6342                	ld	t1,16(sp)
          b->left = l;
ffffffffc0205786:	00ae3423          	sd	a0,8(t3)
          b->right = r;
ffffffffc020578a:	00ce3823          	sd	a2,16(t3)
          if (l) l->parent = b;
ffffffffc020578e:	6862                	ld	a6,24(sp)
ffffffffc0205790:	7e82                	ld	t4,32(sp)
ffffffffc0205792:	78a2                	ld	a7,40(sp)
ffffffffc0205794:	7f42                	ld	t5,48(sp)
ffffffffc0205796:	77e2                	ld	a5,56(sp)
ffffffffc0205798:	6686                	ld	a3,64(sp)
ffffffffc020579a:	6726                	ld	a4,72(sp)
ffffffffc020579c:	c119                	beqz	a0,ffffffffc02057a2 <stride_dequeue+0xa6>
ffffffffc020579e:	01c53023          	sd	t3,0(a0)
     if (a == NULL) return b;
ffffffffc02057a2:	8672                	mv	a2,t3
          b->left = l;
ffffffffc02057a4:	00c8b423          	sd	a2,8(a7)
          b->right = r;
ffffffffc02057a8:	01e8b823          	sd	t5,16(a7)
          if (l) l->parent = b;
ffffffffc02057ac:	01163023          	sd	a7,0(a2)
          b->left = l;
ffffffffc02057b0:	0117b423          	sd	a7,8(a5)
          b->right = r;
ffffffffc02057b4:	01d7b823          	sd	t4,16(a5)
          if (l) l->parent = b;
ffffffffc02057b8:	00f8b023          	sd	a5,0(a7)
     if (rep) rep->parent = p;
ffffffffc02057bc:	0107b023          	sd	a6,0(a5)
     if (p)
ffffffffc02057c0:	00080b63          	beqz	a6,ffffffffc02057d6 <stride_dequeue+0xda>
          if (p->left == b)
ffffffffc02057c4:	00883583          	ld	a1,8(a6)
     rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
ffffffffc02057c8:	12870613          	addi	a2,a4,296
ffffffffc02057cc:	0ac58763          	beq	a1,a2,ffffffffc020587a <stride_dequeue+0x17e>
          else p->right = rep;
ffffffffc02057d0:	00f83823          	sd	a5,16(a6)
          return a;
ffffffffc02057d4:	879a                	mv	a5,t1
     rq->proc_num--;
ffffffffc02057d6:	4a90                	lw	a2,16(a3)
     rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
ffffffffc02057d8:	ee9c                	sd	a5,24(a3)
}
ffffffffc02057da:	60e6                	ld	ra,88(sp)
     proc->rq = NULL;
ffffffffc02057dc:	10073423          	sd	zero,264(a4)
     rq->proc_num--;
ffffffffc02057e0:	fff6079b          	addiw	a5,a2,-1
ffffffffc02057e4:	ca9c                	sw	a5,16(a3)
}
ffffffffc02057e6:	6125                	addi	sp,sp,96
ffffffffc02057e8:	8082                	ret
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02057ea:	01063883          	ld	a7,16(a2)
          r = a->left;
ffffffffc02057ee:	00863e83          	ld	t4,8(a2)
     if (a == NULL) return b;
ffffffffc02057f2:	06088c63          	beqz	a7,ffffffffc020586a <stride_dequeue+0x16e>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc02057f6:	0188a583          	lw	a1,24(a7)
ffffffffc02057fa:	40a5853b          	subw	a0,a1,a0
     else if (c == 0)
ffffffffc02057fe:	0e054a63          	bltz	a0,ffffffffc02058f2 <stride_dequeue+0x1f6>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205802:	0107be03          	ld	t3,16(a5)
          r = b->left;
ffffffffc0205806:	0087bf03          	ld	t5,8(a5)
     else if (b == NULL) return a;
ffffffffc020580a:	040e0a63          	beqz	t3,ffffffffc020585e <stride_dequeue+0x162>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc020580e:	018e2503          	lw	a0,24(t3)
ffffffffc0205812:	e4ba                	sd	a4,72(sp)
ffffffffc0205814:	e0b6                	sd	a3,64(sp)
ffffffffc0205816:	9d89                	subw	a1,a1,a0
ffffffffc0205818:	fc3e                	sd	a5,56(sp)
ffffffffc020581a:	f87a                	sd	t5,48(sp)
ffffffffc020581c:	f476                	sd	t4,40(sp)
ffffffffc020581e:	f032                	sd	a2,32(sp)
ffffffffc0205820:	ec42                	sd	a6,24(sp)
ffffffffc0205822:	e81a                	sd	t1,16(sp)
     else if (c == 0)
ffffffffc0205824:	1405c363          	bltz	a1,ffffffffc020596a <stride_dequeue+0x26e>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205828:	010e3583          	ld	a1,16(t3)
ffffffffc020582c:	8546                	mv	a0,a7
          r = b->left;
ffffffffc020582e:	008e3883          	ld	a7,8(t3)
ffffffffc0205832:	e472                	sd	t3,8(sp)
ffffffffc0205834:	e046                	sd	a7,0(sp)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205836:	91dff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          b->right = r;
ffffffffc020583a:	6e22                	ld	t3,8(sp)
ffffffffc020583c:	6882                	ld	a7,0(sp)
          if (l) l->parent = b;
ffffffffc020583e:	6342                	ld	t1,16(sp)
          b->left = l;
ffffffffc0205840:	00ae3423          	sd	a0,8(t3)
          b->right = r;
ffffffffc0205844:	011e3823          	sd	a7,16(t3)
          if (l) l->parent = b;
ffffffffc0205848:	6862                	ld	a6,24(sp)
ffffffffc020584a:	7602                	ld	a2,32(sp)
ffffffffc020584c:	7ea2                	ld	t4,40(sp)
ffffffffc020584e:	7f42                	ld	t5,48(sp)
ffffffffc0205850:	77e2                	ld	a5,56(sp)
ffffffffc0205852:	6686                	ld	a3,64(sp)
ffffffffc0205854:	6726                	ld	a4,72(sp)
ffffffffc0205856:	c119                	beqz	a0,ffffffffc020585c <stride_dequeue+0x160>
ffffffffc0205858:	01c53023          	sd	t3,0(a0)
     if (a == NULL) return b;
ffffffffc020585c:	88f2                	mv	a7,t3
          b->left = l;
ffffffffc020585e:	0117b423          	sd	a7,8(a5)
          b->right = r;
ffffffffc0205862:	01e7b823          	sd	t5,16(a5)
          if (l) l->parent = b;
ffffffffc0205866:	00f8b023          	sd	a5,0(a7)
          a->left = l;
ffffffffc020586a:	e61c                	sd	a5,8(a2)
          a->right = r;
ffffffffc020586c:	01d63823          	sd	t4,16(a2)
          if (l) l->parent = a;
ffffffffc0205870:	e390                	sd	a2,0(a5)
     else if (b == NULL) return a;
ffffffffc0205872:	87b2                	mv	a5,a2
     if (rep) rep->parent = p;
ffffffffc0205874:	0107b023          	sd	a6,0(a5)
ffffffffc0205878:	b7a1                	j	ffffffffc02057c0 <stride_dequeue+0xc4>
               p->left = rep;
ffffffffc020587a:	00f83423          	sd	a5,8(a6)
ffffffffc020587e:	bf99                	j	ffffffffc02057d4 <stride_dequeue+0xd8>
     if (rep) rep->parent = p;
ffffffffc0205880:	d3a1                	beqz	a5,ffffffffc02057c0 <stride_dequeue+0xc4>
ffffffffc0205882:	0107b023          	sd	a6,0(a5)
ffffffffc0205886:	bf2d                	j	ffffffffc02057c0 <stride_dequeue+0xc4>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205888:	01063e03          	ld	t3,16(a2)
          r = a->left;
ffffffffc020588c:	00863f03          	ld	t5,8(a2)
     if (a == NULL) return b;
ffffffffc0205890:	040e0963          	beqz	t3,ffffffffc02058e2 <stride_dequeue+0x1e6>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc0205894:	018e2583          	lw	a1,24(t3)
ffffffffc0205898:	e4ba                	sd	a4,72(sp)
ffffffffc020589a:	e0b6                	sd	a3,64(sp)
ffffffffc020589c:	9d89                	subw	a1,a1,a0
ffffffffc020589e:	fc3e                	sd	a5,56(sp)
ffffffffc02058a0:	f87a                	sd	t5,48(sp)
ffffffffc02058a2:	f476                	sd	t4,40(sp)
ffffffffc02058a4:	f032                	sd	a2,32(sp)
ffffffffc02058a6:	ec42                	sd	a6,24(sp)
ffffffffc02058a8:	e81a                	sd	t1,16(sp)
     else if (c == 0)
ffffffffc02058aa:	0805c463          	bltz	a1,ffffffffc0205932 <stride_dequeue+0x236>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc02058ae:	0108b583          	ld	a1,16(a7)
ffffffffc02058b2:	8572                	mv	a0,t3
          r = b->left;
ffffffffc02058b4:	0088be03          	ld	t3,8(a7)
ffffffffc02058b8:	e446                	sd	a7,8(sp)
ffffffffc02058ba:	e072                	sd	t3,0(sp)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc02058bc:	897ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          b->right = r;
ffffffffc02058c0:	68a2                	ld	a7,8(sp)
ffffffffc02058c2:	6e02                	ld	t3,0(sp)
          if (l) l->parent = b;
ffffffffc02058c4:	6342                	ld	t1,16(sp)
          b->left = l;
ffffffffc02058c6:	00a8b423          	sd	a0,8(a7)
          b->right = r;
ffffffffc02058ca:	01c8b823          	sd	t3,16(a7)
          if (l) l->parent = b;
ffffffffc02058ce:	6862                	ld	a6,24(sp)
ffffffffc02058d0:	7602                	ld	a2,32(sp)
ffffffffc02058d2:	7ea2                	ld	t4,40(sp)
ffffffffc02058d4:	7f42                	ld	t5,48(sp)
ffffffffc02058d6:	77e2                	ld	a5,56(sp)
ffffffffc02058d8:	6686                	ld	a3,64(sp)
ffffffffc02058da:	6726                	ld	a4,72(sp)
ffffffffc02058dc:	c119                	beqz	a0,ffffffffc02058e2 <stride_dequeue+0x1e6>
ffffffffc02058de:	01153023          	sd	a7,0(a0)
          a->left = l;
ffffffffc02058e2:	01163423          	sd	a7,8(a2)
          a->right = r;
ffffffffc02058e6:	01e63823          	sd	t5,16(a2)
          if (l) l->parent = a;
ffffffffc02058ea:	00c8b023          	sd	a2,0(a7)
     else if (b == NULL) return a;
ffffffffc02058ee:	88b2                	mv	a7,a2
ffffffffc02058f0:	b5c1                	j	ffffffffc02057b0 <stride_dequeue+0xb4>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02058f2:	0108b503          	ld	a0,16(a7)
ffffffffc02058f6:	85be                	mv	a1,a5
          r = a->left;
ffffffffc02058f8:	0088b783          	ld	a5,8(a7)
ffffffffc02058fc:	fc3a                	sd	a4,56(sp)
ffffffffc02058fe:	f836                	sd	a3,48(sp)
ffffffffc0205900:	f476                	sd	t4,40(sp)
ffffffffc0205902:	f032                	sd	a2,32(sp)
ffffffffc0205904:	ec42                	sd	a6,24(sp)
ffffffffc0205906:	e81a                	sd	t1,16(sp)
ffffffffc0205908:	e446                	sd	a7,8(sp)
ffffffffc020590a:	e03e                	sd	a5,0(sp)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc020590c:	847ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          a->right = r;
ffffffffc0205910:	68a2                	ld	a7,8(sp)
ffffffffc0205912:	6782                	ld	a5,0(sp)
          if (l) l->parent = a;
ffffffffc0205914:	6342                	ld	t1,16(sp)
          a->left = l;
ffffffffc0205916:	00a8b423          	sd	a0,8(a7)
          a->right = r;
ffffffffc020591a:	00f8b823          	sd	a5,16(a7)
          if (l) l->parent = a;
ffffffffc020591e:	6862                	ld	a6,24(sp)
ffffffffc0205920:	7602                	ld	a2,32(sp)
ffffffffc0205922:	7ea2                	ld	t4,40(sp)
ffffffffc0205924:	76c2                	ld	a3,48(sp)
ffffffffc0205926:	7762                	ld	a4,56(sp)
ffffffffc0205928:	c119                	beqz	a0,ffffffffc020592e <stride_dequeue+0x232>
ffffffffc020592a:	01153023          	sd	a7,0(a0)
     else if (b == NULL) return a;
ffffffffc020592e:	87c6                	mv	a5,a7
ffffffffc0205930:	bf2d                	j	ffffffffc020586a <stride_dequeue+0x16e>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205932:	010e3503          	ld	a0,16(t3)
ffffffffc0205936:	85c6                	mv	a1,a7
          r = a->left;
ffffffffc0205938:	008e3883          	ld	a7,8(t3)
ffffffffc020593c:	e472                	sd	t3,8(sp)
ffffffffc020593e:	e046                	sd	a7,0(sp)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205940:	813ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          a->right = r;
ffffffffc0205944:	6e22                	ld	t3,8(sp)
ffffffffc0205946:	6882                	ld	a7,0(sp)
          if (l) l->parent = a;
ffffffffc0205948:	6342                	ld	t1,16(sp)
          a->left = l;
ffffffffc020594a:	00ae3423          	sd	a0,8(t3)
          a->right = r;
ffffffffc020594e:	011e3823          	sd	a7,16(t3)
          if (l) l->parent = a;
ffffffffc0205952:	6862                	ld	a6,24(sp)
ffffffffc0205954:	7602                	ld	a2,32(sp)
ffffffffc0205956:	7ea2                	ld	t4,40(sp)
ffffffffc0205958:	7f42                	ld	t5,48(sp)
ffffffffc020595a:	77e2                	ld	a5,56(sp)
ffffffffc020595c:	6686                	ld	a3,64(sp)
ffffffffc020595e:	6726                	ld	a4,72(sp)
ffffffffc0205960:	c119                	beqz	a0,ffffffffc0205966 <stride_dequeue+0x26a>
ffffffffc0205962:	01c53023          	sd	t3,0(a0)
     else if (b == NULL) return a;
ffffffffc0205966:	88f2                	mv	a7,t3
ffffffffc0205968:	bfad                	j	ffffffffc02058e2 <stride_dequeue+0x1e6>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc020596a:	0108b503          	ld	a0,16(a7)
ffffffffc020596e:	85f2                	mv	a1,t3
          r = a->left;
ffffffffc0205970:	0088be03          	ld	t3,8(a7)
ffffffffc0205974:	e446                	sd	a7,8(sp)
ffffffffc0205976:	e072                	sd	t3,0(sp)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205978:	fdaff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          a->right = r;
ffffffffc020597c:	68a2                	ld	a7,8(sp)
ffffffffc020597e:	6e02                	ld	t3,0(sp)
          if (l) l->parent = a;
ffffffffc0205980:	6342                	ld	t1,16(sp)
          a->left = l;
ffffffffc0205982:	00a8b423          	sd	a0,8(a7)
          a->right = r;
ffffffffc0205986:	01c8b823          	sd	t3,16(a7)
          if (l) l->parent = a;
ffffffffc020598a:	6862                	ld	a6,24(sp)
ffffffffc020598c:	7602                	ld	a2,32(sp)
ffffffffc020598e:	7ea2                	ld	t4,40(sp)
ffffffffc0205990:	7f42                	ld	t5,48(sp)
ffffffffc0205992:	77e2                	ld	a5,56(sp)
ffffffffc0205994:	6686                	ld	a3,64(sp)
ffffffffc0205996:	6726                	ld	a4,72(sp)
ffffffffc0205998:	ec0503e3          	beqz	a0,ffffffffc020585e <stride_dequeue+0x162>
ffffffffc020599c:	01153023          	sd	a7,0(a0)
          if (l) l->parent = b;
ffffffffc02059a0:	bd7d                	j	ffffffffc020585e <stride_dequeue+0x162>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02059a2:	6a08                	ld	a0,16(a2)
ffffffffc02059a4:	85f2                	mv	a1,t3
          r = a->left;
ffffffffc02059a6:	00863e03          	ld	t3,8(a2)
ffffffffc02059aa:	e432                	sd	a2,8(sp)
ffffffffc02059ac:	e072                	sd	t3,0(sp)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02059ae:	fa4ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          a->right = r;
ffffffffc02059b2:	6622                	ld	a2,8(sp)
ffffffffc02059b4:	6e02                	ld	t3,0(sp)
          if (l) l->parent = a;
ffffffffc02059b6:	6342                	ld	t1,16(sp)
          a->left = l;
ffffffffc02059b8:	e608                	sd	a0,8(a2)
          a->right = r;
ffffffffc02059ba:	01c63823          	sd	t3,16(a2)
          if (l) l->parent = a;
ffffffffc02059be:	6862                	ld	a6,24(sp)
ffffffffc02059c0:	7e82                	ld	t4,32(sp)
ffffffffc02059c2:	78a2                	ld	a7,40(sp)
ffffffffc02059c4:	7f42                	ld	t5,48(sp)
ffffffffc02059c6:	77e2                	ld	a5,56(sp)
ffffffffc02059c8:	6686                	ld	a3,64(sp)
ffffffffc02059ca:	6726                	ld	a4,72(sp)
ffffffffc02059cc:	dc050ce3          	beqz	a0,ffffffffc02057a4 <stride_dequeue+0xa8>
ffffffffc02059d0:	e110                	sd	a2,0(a0)
          if (l) l->parent = b;
ffffffffc02059d2:	bbc9                	j	ffffffffc02057a4 <stride_dequeue+0xa8>
     assert(proc && rq);
ffffffffc02059d4:	00002697          	auipc	a3,0x2
ffffffffc02059d8:	47c68693          	addi	a3,a3,1148 # ffffffffc0207e50 <etext+0x1be2>
ffffffffc02059dc:	00001617          	auipc	a2,0x1
ffffffffc02059e0:	27c60613          	addi	a2,a2,636 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc02059e4:	0b100593          	li	a1,177
ffffffffc02059e8:	00002517          	auipc	a0,0x2
ffffffffc02059ec:	47850513          	addi	a0,a0,1144 # ffffffffc0207e60 <etext+0x1bf2>
ffffffffc02059f0:	a5bfa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02059f4 <stride_enqueue>:
{
ffffffffc02059f4:	715d                	addi	sp,sp,-80
ffffffffc02059f6:	e486                	sd	ra,72(sp)
     assert(proc && rq);
ffffffffc02059f8:	c1f1                	beqz	a1,ffffffffc0205abc <stride_enqueue+0xc8>
ffffffffc02059fa:	872a                	mv	a4,a0
ffffffffc02059fc:	c161                	beqz	a0,ffffffffc0205abc <stride_enqueue+0xc8>
     rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
ffffffffc02059fe:	6d14                	ld	a3,24(a0)
ffffffffc0205a00:	87ae                	mv	a5,a1
     a->left = a->right = a->parent = NULL;
ffffffffc0205a02:	1205b423          	sd	zero,296(a1)
ffffffffc0205a06:	1205bc23          	sd	zero,312(a1)
ffffffffc0205a0a:	1205b823          	sd	zero,304(a1)
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc0205a0e:	1407a803          	lw	a6,320(a5)
     rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
ffffffffc0205a12:	12858593          	addi	a1,a1,296
     if (a == NULL) return b;
ffffffffc0205a16:	ca89                	beqz	a3,ffffffffc0205a28 <stride_enqueue+0x34>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc0205a18:	4e90                	lw	a2,24(a3)
ffffffffc0205a1a:	4106063b          	subw	a2,a2,a6
     else if (c == 0)
ffffffffc0205a1e:	04064463          	bltz	a2,ffffffffc0205a66 <stride_enqueue+0x72>
          b->left = l;
ffffffffc0205a22:	12d7b823          	sd	a3,304(a5)
          if (l) l->parent = b;
ffffffffc0205a26:	e28c                	sd	a1,0(a3)
     if (a == NULL) return b;
ffffffffc0205a28:	86ae                	mv	a3,a1
     if (proc != idleproc) {
ffffffffc0205a2a:	000b0617          	auipc	a2,0xb0
ffffffffc0205a2e:	c2e63603          	ld	a2,-978(a2) # ffffffffc02b5658 <idleproc>
     rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
ffffffffc0205a32:	ef14                	sd	a3,24(a4)
     if (proc != idleproc) {
ffffffffc0205a34:	00f60563          	beq	a2,a5,ffffffffc0205a3e <stride_enqueue+0x4a>
         proc->time_slice = rq->max_time_slice;
ffffffffc0205a38:	4b50                	lw	a2,20(a4)
ffffffffc0205a3a:	12c7a023          	sw	a2,288(a5)
     if (proc->lab6_priority == 0) {
ffffffffc0205a3e:	1447a603          	lw	a2,324(a5)
ffffffffc0205a42:	e601                	bnez	a2,ffffffffc0205a4a <stride_enqueue+0x56>
         proc->lab6_priority = 1;  // 默认优先级
ffffffffc0205a44:	4605                	li	a2,1
ffffffffc0205a46:	14c7a223          	sw	a2,324(a5)
     if (proc->lab6_stride == 0 && rq->lab6_run_pool != NULL) {
ffffffffc0205a4a:	00081563          	bnez	a6,ffffffffc0205a54 <stride_enqueue+0x60>
         proc->lab6_stride = p->lab6_stride;
ffffffffc0205a4e:	4e94                	lw	a3,24(a3)
ffffffffc0205a50:	14d7a023          	sw	a3,320(a5)
     rq->proc_num++;
ffffffffc0205a54:	4b14                	lw	a3,16(a4)
}
ffffffffc0205a56:	60a6                	ld	ra,72(sp)
     proc->rq = rq;
ffffffffc0205a58:	10e7b423          	sd	a4,264(a5)
     rq->proc_num++;
ffffffffc0205a5c:	0016879b          	addiw	a5,a3,1
ffffffffc0205a60:	cb1c                	sw	a5,16(a4)
}
ffffffffc0205a62:	6161                	addi	sp,sp,80
ffffffffc0205a64:	8082                	ret
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205a66:	6a90                	ld	a2,16(a3)
          r = a->left;
ffffffffc0205a68:	0086b883          	ld	a7,8(a3)
     if (a == NULL) return b;
ffffffffc0205a6c:	ca09                	beqz	a2,ffffffffc0205a7e <stride_enqueue+0x8a>
     int32_t c = p->lab6_stride - q->lab6_stride;
ffffffffc0205a6e:	4e08                	lw	a0,24(a2)
ffffffffc0205a70:	4105053b          	subw	a0,a0,a6
     else if (c == 0)
ffffffffc0205a74:	00054b63          	bltz	a0,ffffffffc0205a8a <stride_enqueue+0x96>
          b->left = l;
ffffffffc0205a78:	12c7b823          	sd	a2,304(a5)
          if (l) l->parent = b;
ffffffffc0205a7c:	e20c                	sd	a1,0(a2)
     if (a == NULL) return b;
ffffffffc0205a7e:	862e                	mv	a2,a1
          a->left = l;
ffffffffc0205a80:	e690                	sd	a2,8(a3)
          a->right = r;
ffffffffc0205a82:	0116b823          	sd	a7,16(a3)
          if (l) l->parent = a;
ffffffffc0205a86:	e214                	sd	a3,0(a2)
ffffffffc0205a88:	b74d                	j	ffffffffc0205a2a <stride_enqueue+0x36>
          r = a->left;
ffffffffc0205a8a:	00863303          	ld	t1,8(a2)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205a8e:	6a08                	ld	a0,16(a2)
ffffffffc0205a90:	fc3e                	sd	a5,56(sp)
ffffffffc0205a92:	f83a                	sd	a4,48(sp)
ffffffffc0205a94:	f442                	sd	a6,40(sp)
ffffffffc0205a96:	f046                	sd	a7,32(sp)
ffffffffc0205a98:	ec36                	sd	a3,24(sp)
          r = a->left;
ffffffffc0205a9a:	e832                	sd	a2,16(sp)
ffffffffc0205a9c:	e41a                	sd	t1,8(sp)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205a9e:	eb4ff0ef          	jal	ffffffffc0205152 <skew_heap_merge.constprop.0>
          a->right = r;
ffffffffc0205aa2:	6642                	ld	a2,16(sp)
ffffffffc0205aa4:	6322                	ld	t1,8(sp)
          if (l) l->parent = a;
ffffffffc0205aa6:	66e2                	ld	a3,24(sp)
          a->left = l;
ffffffffc0205aa8:	e608                	sd	a0,8(a2)
          a->right = r;
ffffffffc0205aaa:	00663823          	sd	t1,16(a2)
          if (l) l->parent = a;
ffffffffc0205aae:	7882                	ld	a7,32(sp)
ffffffffc0205ab0:	7822                	ld	a6,40(sp)
ffffffffc0205ab2:	7742                	ld	a4,48(sp)
ffffffffc0205ab4:	77e2                	ld	a5,56(sp)
ffffffffc0205ab6:	d569                	beqz	a0,ffffffffc0205a80 <stride_enqueue+0x8c>
ffffffffc0205ab8:	e110                	sd	a2,0(a0)
ffffffffc0205aba:	b7d9                	j	ffffffffc0205a80 <stride_enqueue+0x8c>
     assert(proc && rq);
ffffffffc0205abc:	00002697          	auipc	a3,0x2
ffffffffc0205ac0:	39468693          	addi	a3,a3,916 # ffffffffc0207e50 <etext+0x1be2>
ffffffffc0205ac4:	00001617          	auipc	a2,0x1
ffffffffc0205ac8:	19460613          	addi	a2,a2,404 # ffffffffc0206c58 <etext+0x9ea>
ffffffffc0205acc:	08a00593          	li	a1,138
ffffffffc0205ad0:	00002517          	auipc	a0,0x2
ffffffffc0205ad4:	39050513          	addi	a0,a0,912 # ffffffffc0207e60 <etext+0x1bf2>
ffffffffc0205ad8:	973fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205adc <sched_class_proc_tick>:
    return sched_class->pick_next(rq);
}

void sched_class_proc_tick(struct proc_struct *proc)
{
    if (proc != idleproc) {
ffffffffc0205adc:	000b0797          	auipc	a5,0xb0
ffffffffc0205ae0:	b7c7b783          	ld	a5,-1156(a5) # ffffffffc02b5658 <idleproc>
{
ffffffffc0205ae4:	85aa                	mv	a1,a0
    if (proc != idleproc) {
ffffffffc0205ae6:	00a78c63          	beq	a5,a0,ffffffffc0205afe <sched_class_proc_tick+0x22>
        sched_class->proc_tick(rq, proc);
ffffffffc0205aea:	000b0797          	auipc	a5,0xb0
ffffffffc0205aee:	b7e7b783          	ld	a5,-1154(a5) # ffffffffc02b5668 <sched_class>
ffffffffc0205af2:	000b0517          	auipc	a0,0xb0
ffffffffc0205af6:	b6e53503          	ld	a0,-1170(a0) # ffffffffc02b5660 <rq>
ffffffffc0205afa:	779c                	ld	a5,40(a5)
ffffffffc0205afc:	8782                	jr	a5
    } else {
        /* idleproc: normally do nothing, but could reset accounting */
    }
}
ffffffffc0205afe:	8082                	ret

ffffffffc0205b00 <sched_init>:

void sched_init(void)
{
    list_init(&timer_list);

    sched_class = &stride_sched_class;
ffffffffc0205b00:	000ab797          	auipc	a5,0xab
ffffffffc0205b04:	64878793          	addi	a5,a5,1608 # ffffffffc02b1148 <stride_sched_class>
{
ffffffffc0205b08:	1141                	addi	sp,sp,-16

    rq = &__rq;
    rq->max_time_slice = MAX_TIME_SLICE;
    /* ensure run_queue fields initialized by class */
    sched_class->init(rq);
ffffffffc0205b0a:	6794                	ld	a3,8(a5)
    sched_class = &stride_sched_class;
ffffffffc0205b0c:	000b0717          	auipc	a4,0xb0
ffffffffc0205b10:	b4f73e23          	sd	a5,-1188(a4) # ffffffffc02b5668 <sched_class>
{
ffffffffc0205b14:	e406                	sd	ra,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0205b16:	000b0797          	auipc	a5,0xb0
ffffffffc0205b1a:	aba78793          	addi	a5,a5,-1350 # ffffffffc02b55d0 <timer_list>
    rq = &__rq;
ffffffffc0205b1e:	000b0717          	auipc	a4,0xb0
ffffffffc0205b22:	a9270713          	addi	a4,a4,-1390 # ffffffffc02b55b0 <__rq>
    rq->max_time_slice = MAX_TIME_SLICE;
ffffffffc0205b26:	4615                	li	a2,5
ffffffffc0205b28:	e79c                	sd	a5,8(a5)
ffffffffc0205b2a:	e39c                	sd	a5,0(a5)
    sched_class->init(rq);
ffffffffc0205b2c:	853a                	mv	a0,a4
    rq->max_time_slice = MAX_TIME_SLICE;
ffffffffc0205b2e:	cb50                	sw	a2,20(a4)
    rq = &__rq;
ffffffffc0205b30:	000b0797          	auipc	a5,0xb0
ffffffffc0205b34:	b2e7b823          	sd	a4,-1232(a5) # ffffffffc02b5660 <rq>
    sched_class->init(rq);
ffffffffc0205b38:	9682                	jalr	a3

    
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205b3a:	000b0797          	auipc	a5,0xb0
ffffffffc0205b3e:	b2e7b783          	ld	a5,-1234(a5) # ffffffffc02b5668 <sched_class>
}
ffffffffc0205b42:	60a2                	ld	ra,8(sp)
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205b44:	00002517          	auipc	a0,0x2
ffffffffc0205b48:	35c50513          	addi	a0,a0,860 # ffffffffc0207ea0 <etext+0x1c32>
ffffffffc0205b4c:	638c                	ld	a1,0(a5)
}
ffffffffc0205b4e:	0141                	addi	sp,sp,16
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205b50:	e48fa06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0205b54 <wakeup_proc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205b54:	100027f3          	csrr	a5,sstatus
ffffffffc0205b58:	8b89                	andi	a5,a5,2
ffffffffc0205b5a:	e7a9                	bnez	a5,ffffffffc0205ba4 <wakeup_proc+0x50>
void wakeup_proc(struct proc_struct *proc)
{
    bool intr_flag;
    local_intr_save(intr_flag);

    if (proc->state != PROC_RUNNABLE) {
ffffffffc0205b5c:	4118                	lw	a4,0(a0)
ffffffffc0205b5e:	4789                	li	a5,2
ffffffffc0205b60:	04f70163          	beq	a4,a5,ffffffffc0205ba2 <wakeup_proc+0x4e>
// DEBUG:         cprintf("wakeup_proc: pid=%d state=%d\n", proc->pid, proc->state);
        proc->state = PROC_RUNNABLE;
        proc->wait_state = 0;
        /* only enqueue if it's not the current running thread */
        if (proc != current) {
ffffffffc0205b64:	000b0717          	auipc	a4,0xb0
ffffffffc0205b68:	ae473703          	ld	a4,-1308(a4) # ffffffffc02b5648 <current>
        proc->wait_state = 0;
ffffffffc0205b6c:	0e052623          	sw	zero,236(a0)
        proc->state = PROC_RUNNABLE;
ffffffffc0205b70:	c11c                	sw	a5,0(a0)
        if (proc != current) {
ffffffffc0205b72:	02e50663          	beq	a0,a4,ffffffffc0205b9e <wakeup_proc+0x4a>
    if (proc != idleproc) {
ffffffffc0205b76:	000b0797          	auipc	a5,0xb0
ffffffffc0205b7a:	ae27b783          	ld	a5,-1310(a5) # ffffffffc02b5658 <idleproc>
ffffffffc0205b7e:	02f50163          	beq	a0,a5,ffffffffc0205ba0 <wakeup_proc+0x4c>
        sched_class->enqueue(rq, proc);
ffffffffc0205b82:	000b0717          	auipc	a4,0xb0
ffffffffc0205b86:	ae673703          	ld	a4,-1306(a4) # ffffffffc02b5668 <sched_class>
        proc->rq = rq;
ffffffffc0205b8a:	000b0797          	auipc	a5,0xb0
ffffffffc0205b8e:	ad67b783          	ld	a5,-1322(a5) # ffffffffc02b5660 <rq>
        sched_class->enqueue(rq, proc);
ffffffffc0205b92:	85aa                	mv	a1,a0
ffffffffc0205b94:	6b18                	ld	a4,16(a4)
        proc->rq = rq;
ffffffffc0205b96:	10f53423          	sd	a5,264(a0)
        sched_class->enqueue(rq, proc);
ffffffffc0205b9a:	853e                	mv	a0,a5
ffffffffc0205b9c:	8702                	jr	a4
ffffffffc0205b9e:	8082                	ret
ffffffffc0205ba0:	8082                	ret
ffffffffc0205ba2:	8082                	ret
{
ffffffffc0205ba4:	1101                	addi	sp,sp,-32
ffffffffc0205ba6:	e42a                	sd	a0,8(sp)
ffffffffc0205ba8:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0205baa:	d61fa0ef          	jal	ffffffffc020090a <intr_disable>
    if (proc->state != PROC_RUNNABLE) {
ffffffffc0205bae:	6522                	ld	a0,8(sp)
ffffffffc0205bb0:	4789                	li	a5,2
ffffffffc0205bb2:	4118                	lw	a4,0(a0)
ffffffffc0205bb4:	02f70f63          	beq	a4,a5,ffffffffc0205bf2 <wakeup_proc+0x9e>
        if (proc != current) {
ffffffffc0205bb8:	000b0717          	auipc	a4,0xb0
ffffffffc0205bbc:	a9073703          	ld	a4,-1392(a4) # ffffffffc02b5648 <current>
        proc->wait_state = 0;
ffffffffc0205bc0:	0e052623          	sw	zero,236(a0)
        proc->state = PROC_RUNNABLE;
ffffffffc0205bc4:	c11c                	sw	a5,0(a0)
        if (proc != current) {
ffffffffc0205bc6:	02e50663          	beq	a0,a4,ffffffffc0205bf2 <wakeup_proc+0x9e>
    if (proc != idleproc) {
ffffffffc0205bca:	000b0797          	auipc	a5,0xb0
ffffffffc0205bce:	a8e7b783          	ld	a5,-1394(a5) # ffffffffc02b5658 <idleproc>
ffffffffc0205bd2:	02f50063          	beq	a0,a5,ffffffffc0205bf2 <wakeup_proc+0x9e>
        sched_class->enqueue(rq, proc);
ffffffffc0205bd6:	000b0717          	auipc	a4,0xb0
ffffffffc0205bda:	a9273703          	ld	a4,-1390(a4) # ffffffffc02b5668 <sched_class>
        proc->rq = rq;
ffffffffc0205bde:	000b0797          	auipc	a5,0xb0
ffffffffc0205be2:	a827b783          	ld	a5,-1406(a5) # ffffffffc02b5660 <rq>
        sched_class->enqueue(rq, proc);
ffffffffc0205be6:	85aa                	mv	a1,a0
ffffffffc0205be8:	6b18                	ld	a4,16(a4)
        proc->rq = rq;
ffffffffc0205bea:	10f53423          	sd	a5,264(a0)
        sched_class->enqueue(rq, proc);
ffffffffc0205bee:	853e                	mv	a0,a5
ffffffffc0205bf0:	9702                	jalr	a4
            sched_class_enqueue(proc);
        }
    }

    local_intr_restore(intr_flag);
}
ffffffffc0205bf2:	60e2                	ld	ra,24(sp)
ffffffffc0205bf4:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205bf6:	d0ffa06f          	j	ffffffffc0200904 <intr_enable>

ffffffffc0205bfa <schedule>:

/* schedule: high level scheduling flow (enqueue current if runnable,
 * pick next, dequeue it and run) */
void schedule(void)
{
ffffffffc0205bfa:	7139                	addi	sp,sp,-64
ffffffffc0205bfc:	fc06                	sd	ra,56(sp)
ffffffffc0205bfe:	f822                	sd	s0,48(sp)
ffffffffc0205c00:	f426                	sd	s1,40(sp)
ffffffffc0205c02:	f04a                	sd	s2,32(sp)
ffffffffc0205c04:	ec4e                	sd	s3,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205c06:	100027f3          	csrr	a5,sstatus
ffffffffc0205c0a:	8b89                	andi	a5,a5,2
ffffffffc0205c0c:	4981                	li	s3,0
ffffffffc0205c0e:	efd1                	bnez	a5,ffffffffc0205caa <schedule+0xb0>
    bool intr_flag;
    local_intr_save(intr_flag);

    struct proc_struct *cur = current;
ffffffffc0205c10:	000b0417          	auipc	s0,0xb0
ffffffffc0205c14:	a3843403          	ld	s0,-1480(s0) # ffffffffc02b5648 <current>

    /* clear resched flag for current; it will be set again if needed */
    cur->need_resched = 0;

    /* if current is still runnable, enqueue it */
    if (cur->state == PROC_RUNNABLE) {
ffffffffc0205c18:	4789                	li	a5,2
ffffffffc0205c1a:	000b0497          	auipc	s1,0xb0
ffffffffc0205c1e:	a4648493          	addi	s1,s1,-1466 # ffffffffc02b5660 <rq>
ffffffffc0205c22:	4018                	lw	a4,0(s0)
    cur->need_resched = 0;
ffffffffc0205c24:	00043c23          	sd	zero,24(s0)
    if (cur->state == PROC_RUNNABLE) {
ffffffffc0205c28:	000b0917          	auipc	s2,0xb0
ffffffffc0205c2c:	a4090913          	addi	s2,s2,-1472 # ffffffffc02b5668 <sched_class>
ffffffffc0205c30:	04f70e63          	beq	a4,a5,ffffffffc0205c8c <schedule+0x92>
    return sched_class->pick_next(rq);
ffffffffc0205c34:	00093783          	ld	a5,0(s2)
ffffffffc0205c38:	6088                	ld	a0,0(s1)
ffffffffc0205c3a:	739c                	ld	a5,32(a5)
ffffffffc0205c3c:	9782                	jalr	a5
ffffffffc0205c3e:	85aa                	mv	a1,a0
        sched_class_enqueue(cur);
    }

    /* pick next from scheduling class */
    next = sched_class_pick_next();
    if (!next) {
ffffffffc0205c40:	c129                	beqz	a0,ffffffffc0205c82 <schedule+0x88>
    sched_class->dequeue(rq, proc);
ffffffffc0205c42:	00093783          	ld	a5,0(s2)
ffffffffc0205c46:	6088                	ld	a0,0(s1)
ffffffffc0205c48:	e42e                	sd	a1,8(sp)
ffffffffc0205c4a:	6f9c                	ld	a5,24(a5)
ffffffffc0205c4c:	9782                	jalr	a5
ffffffffc0205c4e:	65a2                	ld	a1,8(sp)
        /* remove next from run-queue */
        sched_class_dequeue(next);
    }

    /* if next is the same as current, nothing to do */
    if (next == cur) {
ffffffffc0205c50:	00858863          	beq	a1,s0,ffffffffc0205c60 <schedule+0x66>
        return;
    }

    // DEBUG: if (next->pid >= 3 && next->pid <= 7) cprintf("schedule: switching to pid=%d\n", next->pid);
    /* accounting */
    next->runs++;
ffffffffc0205c54:	459c                	lw	a5,8(a1)

    /* context switch */
    proc_run(next);
ffffffffc0205c56:	852e                	mv	a0,a1
    next->runs++;
ffffffffc0205c58:	2785                	addiw	a5,a5,1
ffffffffc0205c5a:	c59c                	sw	a5,8(a1)
    proc_run(next);
ffffffffc0205c5c:	a26fe0ef          	jal	ffffffffc0203e82 <proc_run>
    if (flag)
ffffffffc0205c60:	00099963          	bnez	s3,ffffffffc0205c72 <schedule+0x78>

    /* proc_run should not return here in normal flow, but restore just in case */
    local_intr_restore(intr_flag);
ffffffffc0205c64:	70e2                	ld	ra,56(sp)
ffffffffc0205c66:	7442                	ld	s0,48(sp)
ffffffffc0205c68:	74a2                	ld	s1,40(sp)
ffffffffc0205c6a:	7902                	ld	s2,32(sp)
ffffffffc0205c6c:	69e2                	ld	s3,24(sp)
ffffffffc0205c6e:	6121                	addi	sp,sp,64
ffffffffc0205c70:	8082                	ret
ffffffffc0205c72:	7442                	ld	s0,48(sp)
ffffffffc0205c74:	70e2                	ld	ra,56(sp)
ffffffffc0205c76:	74a2                	ld	s1,40(sp)
ffffffffc0205c78:	7902                	ld	s2,32(sp)
ffffffffc0205c7a:	69e2                	ld	s3,24(sp)
ffffffffc0205c7c:	6121                	addi	sp,sp,64
        intr_enable();
ffffffffc0205c7e:	c87fa06f          	j	ffffffffc0200904 <intr_enable>
        next = idleproc;
ffffffffc0205c82:	000b0597          	auipc	a1,0xb0
ffffffffc0205c86:	9d65b583          	ld	a1,-1578(a1) # ffffffffc02b5658 <idleproc>
ffffffffc0205c8a:	b7d9                	j	ffffffffc0205c50 <schedule+0x56>
    if (proc != idleproc) {
ffffffffc0205c8c:	000b0797          	auipc	a5,0xb0
ffffffffc0205c90:	9cc7b783          	ld	a5,-1588(a5) # ffffffffc02b5658 <idleproc>
ffffffffc0205c94:	faf400e3          	beq	s0,a5,ffffffffc0205c34 <schedule+0x3a>
        sched_class->enqueue(rq, proc);
ffffffffc0205c98:	00093783          	ld	a5,0(s2)
        proc->rq = rq;
ffffffffc0205c9c:	6088                	ld	a0,0(s1)
        sched_class->enqueue(rq, proc);
ffffffffc0205c9e:	85a2                	mv	a1,s0
ffffffffc0205ca0:	6b9c                	ld	a5,16(a5)
        proc->rq = rq;
ffffffffc0205ca2:	10a43423          	sd	a0,264(s0)
        sched_class->enqueue(rq, proc);
ffffffffc0205ca6:	9782                	jalr	a5
ffffffffc0205ca8:	b771                	j	ffffffffc0205c34 <schedule+0x3a>
        intr_disable();
ffffffffc0205caa:	c61fa0ef          	jal	ffffffffc020090a <intr_disable>
        return 1;
ffffffffc0205cae:	4985                	li	s3,1
ffffffffc0205cb0:	b785                	j	ffffffffc0205c10 <schedule+0x16>

ffffffffc0205cb2 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc0205cb2:	000b0797          	auipc	a5,0xb0
ffffffffc0205cb6:	9967b783          	ld	a5,-1642(a5) # ffffffffc02b5648 <current>
}
ffffffffc0205cba:	43c8                	lw	a0,4(a5)
ffffffffc0205cbc:	8082                	ret

ffffffffc0205cbe <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0205cbe:	4501                	li	a0,0
ffffffffc0205cc0:	8082                	ret

ffffffffc0205cc2 <sys_gettime>:
static int sys_gettime(uint64_t arg[]){
    return (int)ticks*10;
ffffffffc0205cc2:	000b0797          	auipc	a5,0xb0
ffffffffc0205cc6:	9267b783          	ld	a5,-1754(a5) # ffffffffc02b55e8 <ticks>
ffffffffc0205cca:	0027951b          	slliw	a0,a5,0x2
ffffffffc0205cce:	9d3d                	addw	a0,a0,a5
ffffffffc0205cd0:	0015151b          	slliw	a0,a0,0x1
}
ffffffffc0205cd4:	8082                	ret

ffffffffc0205cd6 <sys_lab6_set_priority>:
static int sys_lab6_set_priority(uint64_t arg[]){
    uint64_t priority = (uint64_t)arg[0];
    lab6_set_priority(priority);
ffffffffc0205cd6:	4108                	lw	a0,0(a0)
static int sys_lab6_set_priority(uint64_t arg[]){
ffffffffc0205cd8:	1141                	addi	sp,sp,-16
ffffffffc0205cda:	e406                	sd	ra,8(sp)
    lab6_set_priority(priority);
ffffffffc0205cdc:	b90ff0ef          	jal	ffffffffc020506c <lab6_set_priority>
    return 0;
}
ffffffffc0205ce0:	60a2                	ld	ra,8(sp)
ffffffffc0205ce2:	4501                	li	a0,0
ffffffffc0205ce4:	0141                	addi	sp,sp,16
ffffffffc0205ce6:	8082                	ret

ffffffffc0205ce8 <sys_putc>:
    cputchar(c);
ffffffffc0205ce8:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205cea:	1141                	addi	sp,sp,-16
ffffffffc0205cec:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205cee:	cdefa0ef          	jal	ffffffffc02001cc <cputchar>
}
ffffffffc0205cf2:	60a2                	ld	ra,8(sp)
ffffffffc0205cf4:	4501                	li	a0,0
ffffffffc0205cf6:	0141                	addi	sp,sp,16
ffffffffc0205cf8:	8082                	ret

ffffffffc0205cfa <sys_kill>:
    return do_kill(pid);
ffffffffc0205cfa:	4108                	lw	a0,0(a0)
ffffffffc0205cfc:	93eff06f          	j	ffffffffc0204e3a <do_kill>

ffffffffc0205d00 <sys_yield>:
    return do_yield();
ffffffffc0205d00:	8f0ff06f          	j	ffffffffc0204df0 <do_yield>

ffffffffc0205d04 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0205d04:	6d14                	ld	a3,24(a0)
ffffffffc0205d06:	6910                	ld	a2,16(a0)
ffffffffc0205d08:	650c                	ld	a1,8(a0)
ffffffffc0205d0a:	6108                	ld	a0,0(a0)
ffffffffc0205d0c:	ab9fe06f          	j	ffffffffc02047c4 <do_execve>

ffffffffc0205d10 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0205d10:	650c                	ld	a1,8(a0)
ffffffffc0205d12:	4108                	lw	a0,0(a0)
ffffffffc0205d14:	8ecff06f          	j	ffffffffc0204e00 <do_wait>

ffffffffc0205d18 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0205d18:	000b0797          	auipc	a5,0xb0
ffffffffc0205d1c:	9307b783          	ld	a5,-1744(a5) # ffffffffc02b5648 <current>
    return do_fork(0, stack, tf);
ffffffffc0205d20:	4501                	li	a0,0
    struct trapframe *tf = current->tf;
ffffffffc0205d22:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc0205d24:	6a0c                	ld	a1,16(a2)
ffffffffc0205d26:	9befe06f          	j	ffffffffc0203ee4 <do_fork>

ffffffffc0205d2a <sys_exit>:
    return do_exit(error_code);
ffffffffc0205d2a:	4108                	lw	a0,0(a0)
ffffffffc0205d2c:	e4efe06f          	j	ffffffffc020437a <do_exit>

ffffffffc0205d30 <syscall>:

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
    struct trapframe *tf = current->tf;
ffffffffc0205d30:	000b0697          	auipc	a3,0xb0
ffffffffc0205d34:	9186b683          	ld	a3,-1768(a3) # ffffffffc02b5648 <current>
syscall(void) {
ffffffffc0205d38:	715d                	addi	sp,sp,-80
ffffffffc0205d3a:	e0a2                	sd	s0,64(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205d3c:	72c0                	ld	s0,160(a3)
syscall(void) {
ffffffffc0205d3e:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205d40:	0ff00793          	li	a5,255
    int num = tf->gpr.a0;
ffffffffc0205d44:	4834                	lw	a3,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205d46:	02d7ec63          	bltu	a5,a3,ffffffffc0205d7e <syscall+0x4e>
        if (syscalls[num] != NULL) {
ffffffffc0205d4a:	00002797          	auipc	a5,0x2
ffffffffc0205d4e:	39678793          	addi	a5,a5,918 # ffffffffc02080e0 <syscalls>
ffffffffc0205d52:	00369613          	slli	a2,a3,0x3
ffffffffc0205d56:	97b2                	add	a5,a5,a2
ffffffffc0205d58:	639c                	ld	a5,0(a5)
ffffffffc0205d5a:	c395                	beqz	a5,ffffffffc0205d7e <syscall+0x4e>
            arg[0] = tf->gpr.a1;
ffffffffc0205d5c:	7028                	ld	a0,96(s0)
ffffffffc0205d5e:	742c                	ld	a1,104(s0)
ffffffffc0205d60:	7830                	ld	a2,112(s0)
ffffffffc0205d62:	7c34                	ld	a3,120(s0)
ffffffffc0205d64:	6c38                	ld	a4,88(s0)
ffffffffc0205d66:	f02a                	sd	a0,32(sp)
ffffffffc0205d68:	f42e                	sd	a1,40(sp)
ffffffffc0205d6a:	f832                	sd	a2,48(sp)
ffffffffc0205d6c:	fc36                	sd	a3,56(sp)
ffffffffc0205d6e:	ec3a                	sd	a4,24(sp)
            arg[1] = tf->gpr.a2;
            arg[2] = tf->gpr.a3;
            arg[3] = tf->gpr.a4;
            arg[4] = tf->gpr.a5;
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205d70:	0828                	addi	a0,sp,24
ffffffffc0205d72:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc0205d74:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205d76:	e828                	sd	a0,80(s0)
}
ffffffffc0205d78:	6406                	ld	s0,64(sp)
ffffffffc0205d7a:	6161                	addi	sp,sp,80
ffffffffc0205d7c:	8082                	ret
    print_trapframe(tf);
ffffffffc0205d7e:	8522                	mv	a0,s0
ffffffffc0205d80:	e436                	sd	a3,8(sp)
ffffffffc0205d82:	d79fa0ef          	jal	ffffffffc0200afa <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc0205d86:	000b0797          	auipc	a5,0xb0
ffffffffc0205d8a:	8c27b783          	ld	a5,-1854(a5) # ffffffffc02b5648 <current>
ffffffffc0205d8e:	66a2                	ld	a3,8(sp)
ffffffffc0205d90:	00002617          	auipc	a2,0x2
ffffffffc0205d94:	12860613          	addi	a2,a2,296 # ffffffffc0207eb8 <etext+0x1c4a>
ffffffffc0205d98:	43d8                	lw	a4,4(a5)
ffffffffc0205d9a:	06c00593          	li	a1,108
ffffffffc0205d9e:	0b478793          	addi	a5,a5,180
ffffffffc0205da2:	00002517          	auipc	a0,0x2
ffffffffc0205da6:	14650513          	addi	a0,a0,326 # ffffffffc0207ee8 <etext+0x1c7a>
ffffffffc0205daa:	ea0fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205dae <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0205dae:	9e3707b7          	lui	a5,0x9e370
ffffffffc0205db2:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <_binary_obj___user_matrix_out_size+0xffffffff9e364ad1>
ffffffffc0205db4:	02a787bb          	mulw	a5,a5,a0
    return (hash >> (32 - bits));
ffffffffc0205db8:	02000513          	li	a0,32
ffffffffc0205dbc:	9d0d                	subw	a0,a0,a1
}
ffffffffc0205dbe:	00a7d53b          	srlw	a0,a5,a0
ffffffffc0205dc2:	8082                	ret

ffffffffc0205dc4 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205dc4:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205dc6:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205dca:	f022                	sd	s0,32(sp)
ffffffffc0205dcc:	ec26                	sd	s1,24(sp)
ffffffffc0205dce:	e84a                	sd	s2,16(sp)
ffffffffc0205dd0:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205dd2:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205dd6:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205dd8:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0205ddc:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205de0:	84aa                	mv	s1,a0
ffffffffc0205de2:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc0205de4:	03067d63          	bgeu	a2,a6,ffffffffc0205e1e <printnum+0x5a>
ffffffffc0205de8:	e44e                	sd	s3,8(sp)
ffffffffc0205dea:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0205dec:	4785                	li	a5,1
ffffffffc0205dee:	00e7d763          	bge	a5,a4,ffffffffc0205dfc <printnum+0x38>
            putch(padc, putdat);
ffffffffc0205df2:	85ca                	mv	a1,s2
ffffffffc0205df4:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc0205df6:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205df8:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205dfa:	fc65                	bnez	s0,ffffffffc0205df2 <printnum+0x2e>
ffffffffc0205dfc:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205dfe:	00002797          	auipc	a5,0x2
ffffffffc0205e02:	10278793          	addi	a5,a5,258 # ffffffffc0207f00 <etext+0x1c92>
ffffffffc0205e06:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc0205e08:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205e0a:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0205e0e:	70a2                	ld	ra,40(sp)
ffffffffc0205e10:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205e12:	85ca                	mv	a1,s2
ffffffffc0205e14:	87a6                	mv	a5,s1
}
ffffffffc0205e16:	6942                	ld	s2,16(sp)
ffffffffc0205e18:	64e2                	ld	s1,24(sp)
ffffffffc0205e1a:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205e1c:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0205e1e:	03065633          	divu	a2,a2,a6
ffffffffc0205e22:	8722                	mv	a4,s0
ffffffffc0205e24:	fa1ff0ef          	jal	ffffffffc0205dc4 <printnum>
ffffffffc0205e28:	bfd9                	j	ffffffffc0205dfe <printnum+0x3a>

ffffffffc0205e2a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0205e2a:	7119                	addi	sp,sp,-128
ffffffffc0205e2c:	f4a6                	sd	s1,104(sp)
ffffffffc0205e2e:	f0ca                	sd	s2,96(sp)
ffffffffc0205e30:	ecce                	sd	s3,88(sp)
ffffffffc0205e32:	e8d2                	sd	s4,80(sp)
ffffffffc0205e34:	e4d6                	sd	s5,72(sp)
ffffffffc0205e36:	e0da                	sd	s6,64(sp)
ffffffffc0205e38:	f862                	sd	s8,48(sp)
ffffffffc0205e3a:	fc86                	sd	ra,120(sp)
ffffffffc0205e3c:	f8a2                	sd	s0,112(sp)
ffffffffc0205e3e:	fc5e                	sd	s7,56(sp)
ffffffffc0205e40:	f466                	sd	s9,40(sp)
ffffffffc0205e42:	f06a                	sd	s10,32(sp)
ffffffffc0205e44:	ec6e                	sd	s11,24(sp)
ffffffffc0205e46:	84aa                	mv	s1,a0
ffffffffc0205e48:	8c32                	mv	s8,a2
ffffffffc0205e4a:	8a36                	mv	s4,a3
ffffffffc0205e4c:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205e4e:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205e52:	05500b13          	li	s6,85
ffffffffc0205e56:	00003a97          	auipc	s5,0x3
ffffffffc0205e5a:	a8aa8a93          	addi	s5,s5,-1398 # ffffffffc02088e0 <syscalls+0x800>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205e5e:	000c4503          	lbu	a0,0(s8)
ffffffffc0205e62:	001c0413          	addi	s0,s8,1
ffffffffc0205e66:	01350a63          	beq	a0,s3,ffffffffc0205e7a <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0205e6a:	cd0d                	beqz	a0,ffffffffc0205ea4 <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0205e6c:	85ca                	mv	a1,s2
ffffffffc0205e6e:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205e70:	00044503          	lbu	a0,0(s0)
ffffffffc0205e74:	0405                	addi	s0,s0,1
ffffffffc0205e76:	ff351ae3          	bne	a0,s3,ffffffffc0205e6a <vprintfmt+0x40>
        width = precision = -1;
ffffffffc0205e7a:	5cfd                	li	s9,-1
ffffffffc0205e7c:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc0205e7e:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc0205e82:	4b81                	li	s7,0
ffffffffc0205e84:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205e86:	00044683          	lbu	a3,0(s0)
ffffffffc0205e8a:	00140c13          	addi	s8,s0,1
ffffffffc0205e8e:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0205e92:	0ff5f593          	zext.b	a1,a1
ffffffffc0205e96:	02bb6663          	bltu	s6,a1,ffffffffc0205ec2 <vprintfmt+0x98>
ffffffffc0205e9a:	058a                	slli	a1,a1,0x2
ffffffffc0205e9c:	95d6                	add	a1,a1,s5
ffffffffc0205e9e:	4198                	lw	a4,0(a1)
ffffffffc0205ea0:	9756                	add	a4,a4,s5
ffffffffc0205ea2:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0205ea4:	70e6                	ld	ra,120(sp)
ffffffffc0205ea6:	7446                	ld	s0,112(sp)
ffffffffc0205ea8:	74a6                	ld	s1,104(sp)
ffffffffc0205eaa:	7906                	ld	s2,96(sp)
ffffffffc0205eac:	69e6                	ld	s3,88(sp)
ffffffffc0205eae:	6a46                	ld	s4,80(sp)
ffffffffc0205eb0:	6aa6                	ld	s5,72(sp)
ffffffffc0205eb2:	6b06                	ld	s6,64(sp)
ffffffffc0205eb4:	7be2                	ld	s7,56(sp)
ffffffffc0205eb6:	7c42                	ld	s8,48(sp)
ffffffffc0205eb8:	7ca2                	ld	s9,40(sp)
ffffffffc0205eba:	7d02                	ld	s10,32(sp)
ffffffffc0205ebc:	6de2                	ld	s11,24(sp)
ffffffffc0205ebe:	6109                	addi	sp,sp,128
ffffffffc0205ec0:	8082                	ret
            putch('%', putdat);
ffffffffc0205ec2:	85ca                	mv	a1,s2
ffffffffc0205ec4:	02500513          	li	a0,37
ffffffffc0205ec8:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205eca:	fff44783          	lbu	a5,-1(s0)
ffffffffc0205ece:	02500713          	li	a4,37
ffffffffc0205ed2:	8c22                	mv	s8,s0
ffffffffc0205ed4:	f8e785e3          	beq	a5,a4,ffffffffc0205e5e <vprintfmt+0x34>
ffffffffc0205ed8:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0205edc:	1c7d                	addi	s8,s8,-1
ffffffffc0205ede:	fee79de3          	bne	a5,a4,ffffffffc0205ed8 <vprintfmt+0xae>
ffffffffc0205ee2:	bfb5                	j	ffffffffc0205e5e <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0205ee4:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0205ee8:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc0205eea:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc0205eee:	fd06071b          	addiw	a4,a2,-48
ffffffffc0205ef2:	24e56a63          	bltu	a0,a4,ffffffffc0206146 <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc0205ef6:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205ef8:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc0205efa:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc0205efe:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0205f02:	0197073b          	addw	a4,a4,s9
ffffffffc0205f06:	0017171b          	slliw	a4,a4,0x1
ffffffffc0205f0a:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc0205f0c:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0205f10:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0205f12:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0205f16:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc0205f1a:	feb570e3          	bgeu	a0,a1,ffffffffc0205efa <vprintfmt+0xd0>
            if (width < 0)
ffffffffc0205f1e:	f60d54e3          	bgez	s10,ffffffffc0205e86 <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0205f22:	8d66                	mv	s10,s9
ffffffffc0205f24:	5cfd                	li	s9,-1
ffffffffc0205f26:	b785                	j	ffffffffc0205e86 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205f28:	8db6                	mv	s11,a3
ffffffffc0205f2a:	8462                	mv	s0,s8
ffffffffc0205f2c:	bfa9                	j	ffffffffc0205e86 <vprintfmt+0x5c>
ffffffffc0205f2e:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0205f30:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0205f32:	bf91                	j	ffffffffc0205e86 <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0205f34:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205f36:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205f3a:	00f74463          	blt	a4,a5,ffffffffc0205f42 <vprintfmt+0x118>
    else if (lflag) {
ffffffffc0205f3e:	1a078763          	beqz	a5,ffffffffc02060ec <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0205f42:	000a3603          	ld	a2,0(s4)
ffffffffc0205f46:	46c1                	li	a3,16
ffffffffc0205f48:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205f4a:	000d879b          	sext.w	a5,s11
ffffffffc0205f4e:	876a                	mv	a4,s10
ffffffffc0205f50:	85ca                	mv	a1,s2
ffffffffc0205f52:	8526                	mv	a0,s1
ffffffffc0205f54:	e71ff0ef          	jal	ffffffffc0205dc4 <printnum>
            break;
ffffffffc0205f58:	b719                	j	ffffffffc0205e5e <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0205f5a:	000a2503          	lw	a0,0(s4)
ffffffffc0205f5e:	85ca                	mv	a1,s2
ffffffffc0205f60:	0a21                	addi	s4,s4,8
ffffffffc0205f62:	9482                	jalr	s1
            break;
ffffffffc0205f64:	bded                	j	ffffffffc0205e5e <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0205f66:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205f68:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205f6c:	00f74463          	blt	a4,a5,ffffffffc0205f74 <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0205f70:	16078963          	beqz	a5,ffffffffc02060e2 <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc0205f74:	000a3603          	ld	a2,0(s4)
ffffffffc0205f78:	46a9                	li	a3,10
ffffffffc0205f7a:	8a2e                	mv	s4,a1
ffffffffc0205f7c:	b7f9                	j	ffffffffc0205f4a <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc0205f7e:	85ca                	mv	a1,s2
ffffffffc0205f80:	03000513          	li	a0,48
ffffffffc0205f84:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc0205f86:	85ca                	mv	a1,s2
ffffffffc0205f88:	07800513          	li	a0,120
ffffffffc0205f8c:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205f8e:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc0205f92:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205f94:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0205f96:	bf55                	j	ffffffffc0205f4a <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc0205f98:	85ca                	mv	a1,s2
ffffffffc0205f9a:	02500513          	li	a0,37
ffffffffc0205f9e:	9482                	jalr	s1
            break;
ffffffffc0205fa0:	bd7d                	j	ffffffffc0205e5e <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc0205fa2:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205fa6:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc0205fa8:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc0205faa:	bf95                	j	ffffffffc0205f1e <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc0205fac:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205fae:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205fb2:	00f74463          	blt	a4,a5,ffffffffc0205fba <vprintfmt+0x190>
    else if (lflag) {
ffffffffc0205fb6:	12078163          	beqz	a5,ffffffffc02060d8 <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc0205fba:	000a3603          	ld	a2,0(s4)
ffffffffc0205fbe:	46a1                	li	a3,8
ffffffffc0205fc0:	8a2e                	mv	s4,a1
ffffffffc0205fc2:	b761                	j	ffffffffc0205f4a <vprintfmt+0x120>
            if (width < 0)
ffffffffc0205fc4:	876a                	mv	a4,s10
ffffffffc0205fc6:	000d5363          	bgez	s10,ffffffffc0205fcc <vprintfmt+0x1a2>
ffffffffc0205fca:	4701                	li	a4,0
ffffffffc0205fcc:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205fd0:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0205fd2:	bd55                	j	ffffffffc0205e86 <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc0205fd4:	000d841b          	sext.w	s0,s11
ffffffffc0205fd8:	fd340793          	addi	a5,s0,-45
ffffffffc0205fdc:	00f037b3          	snez	a5,a5
ffffffffc0205fe0:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205fe4:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc0205fe8:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205fea:	008a0793          	addi	a5,s4,8
ffffffffc0205fee:	e43e                	sd	a5,8(sp)
ffffffffc0205ff0:	100d8c63          	beqz	s11,ffffffffc0206108 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0205ff4:	12071363          	bnez	a4,ffffffffc020611a <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205ff8:	000dc783          	lbu	a5,0(s11)
ffffffffc0205ffc:	0007851b          	sext.w	a0,a5
ffffffffc0206000:	c78d                	beqz	a5,ffffffffc020602a <vprintfmt+0x200>
ffffffffc0206002:	0d85                	addi	s11,s11,1
ffffffffc0206004:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0206006:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020600a:	000cc563          	bltz	s9,ffffffffc0206014 <vprintfmt+0x1ea>
ffffffffc020600e:	3cfd                	addiw	s9,s9,-1
ffffffffc0206010:	008c8d63          	beq	s9,s0,ffffffffc020602a <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0206014:	020b9663          	bnez	s7,ffffffffc0206040 <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc0206018:	85ca                	mv	a1,s2
ffffffffc020601a:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020601c:	000dc783          	lbu	a5,0(s11)
ffffffffc0206020:	0d85                	addi	s11,s11,1
ffffffffc0206022:	3d7d                	addiw	s10,s10,-1
ffffffffc0206024:	0007851b          	sext.w	a0,a5
ffffffffc0206028:	f3ed                	bnez	a5,ffffffffc020600a <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc020602a:	01a05963          	blez	s10,ffffffffc020603c <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc020602e:	85ca                	mv	a1,s2
ffffffffc0206030:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0206034:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc0206036:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc0206038:	fe0d1be3          	bnez	s10,ffffffffc020602e <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020603c:	6a22                	ld	s4,8(sp)
ffffffffc020603e:	b505                	j	ffffffffc0205e5e <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0206040:	3781                	addiw	a5,a5,-32
ffffffffc0206042:	fcfa7be3          	bgeu	s4,a5,ffffffffc0206018 <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc0206046:	03f00513          	li	a0,63
ffffffffc020604a:	85ca                	mv	a1,s2
ffffffffc020604c:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020604e:	000dc783          	lbu	a5,0(s11)
ffffffffc0206052:	0d85                	addi	s11,s11,1
ffffffffc0206054:	3d7d                	addiw	s10,s10,-1
ffffffffc0206056:	0007851b          	sext.w	a0,a5
ffffffffc020605a:	dbe1                	beqz	a5,ffffffffc020602a <vprintfmt+0x200>
ffffffffc020605c:	fa0cd9e3          	bgez	s9,ffffffffc020600e <vprintfmt+0x1e4>
ffffffffc0206060:	b7c5                	j	ffffffffc0206040 <vprintfmt+0x216>
            if (err < 0) {
ffffffffc0206062:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0206066:	4661                	li	a2,24
            err = va_arg(ap, int);
ffffffffc0206068:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020606a:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020606e:	8fb9                	xor	a5,a5,a4
ffffffffc0206070:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0206074:	02d64563          	blt	a2,a3,ffffffffc020609e <vprintfmt+0x274>
ffffffffc0206078:	00003797          	auipc	a5,0x3
ffffffffc020607c:	9c078793          	addi	a5,a5,-1600 # ffffffffc0208a38 <error_string>
ffffffffc0206080:	00369713          	slli	a4,a3,0x3
ffffffffc0206084:	97ba                	add	a5,a5,a4
ffffffffc0206086:	639c                	ld	a5,0(a5)
ffffffffc0206088:	cb99                	beqz	a5,ffffffffc020609e <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc020608a:	86be                	mv	a3,a5
ffffffffc020608c:	00000617          	auipc	a2,0x0
ffffffffc0206090:	20c60613          	addi	a2,a2,524 # ffffffffc0206298 <etext+0x2a>
ffffffffc0206094:	85ca                	mv	a1,s2
ffffffffc0206096:	8526                	mv	a0,s1
ffffffffc0206098:	0d8000ef          	jal	ffffffffc0206170 <printfmt>
ffffffffc020609c:	b3c9                	j	ffffffffc0205e5e <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc020609e:	00002617          	auipc	a2,0x2
ffffffffc02060a2:	e8260613          	addi	a2,a2,-382 # ffffffffc0207f20 <etext+0x1cb2>
ffffffffc02060a6:	85ca                	mv	a1,s2
ffffffffc02060a8:	8526                	mv	a0,s1
ffffffffc02060aa:	0c6000ef          	jal	ffffffffc0206170 <printfmt>
ffffffffc02060ae:	bb45                	j	ffffffffc0205e5e <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc02060b0:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02060b2:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc02060b6:	00f74363          	blt	a4,a5,ffffffffc02060bc <vprintfmt+0x292>
    else if (lflag) {
ffffffffc02060ba:	cf81                	beqz	a5,ffffffffc02060d2 <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc02060bc:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02060c0:	02044b63          	bltz	s0,ffffffffc02060f6 <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc02060c4:	8622                	mv	a2,s0
ffffffffc02060c6:	8a5e                	mv	s4,s7
ffffffffc02060c8:	46a9                	li	a3,10
ffffffffc02060ca:	b541                	j	ffffffffc0205f4a <vprintfmt+0x120>
            lflag ++;
ffffffffc02060cc:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02060ce:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc02060d0:	bb5d                	j	ffffffffc0205e86 <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc02060d2:	000a2403          	lw	s0,0(s4)
ffffffffc02060d6:	b7ed                	j	ffffffffc02060c0 <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc02060d8:	000a6603          	lwu	a2,0(s4)
ffffffffc02060dc:	46a1                	li	a3,8
ffffffffc02060de:	8a2e                	mv	s4,a1
ffffffffc02060e0:	b5ad                	j	ffffffffc0205f4a <vprintfmt+0x120>
ffffffffc02060e2:	000a6603          	lwu	a2,0(s4)
ffffffffc02060e6:	46a9                	li	a3,10
ffffffffc02060e8:	8a2e                	mv	s4,a1
ffffffffc02060ea:	b585                	j	ffffffffc0205f4a <vprintfmt+0x120>
ffffffffc02060ec:	000a6603          	lwu	a2,0(s4)
ffffffffc02060f0:	46c1                	li	a3,16
ffffffffc02060f2:	8a2e                	mv	s4,a1
ffffffffc02060f4:	bd99                	j	ffffffffc0205f4a <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc02060f6:	85ca                	mv	a1,s2
ffffffffc02060f8:	02d00513          	li	a0,45
ffffffffc02060fc:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc02060fe:	40800633          	neg	a2,s0
ffffffffc0206102:	8a5e                	mv	s4,s7
ffffffffc0206104:	46a9                	li	a3,10
ffffffffc0206106:	b591                	j	ffffffffc0205f4a <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc0206108:	e329                	bnez	a4,ffffffffc020614a <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020610a:	02800793          	li	a5,40
ffffffffc020610e:	853e                	mv	a0,a5
ffffffffc0206110:	00002d97          	auipc	s11,0x2
ffffffffc0206114:	e09d8d93          	addi	s11,s11,-503 # ffffffffc0207f19 <etext+0x1cab>
ffffffffc0206118:	b5f5                	j	ffffffffc0206004 <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020611a:	85e6                	mv	a1,s9
ffffffffc020611c:	856e                	mv	a0,s11
ffffffffc020611e:	08a000ef          	jal	ffffffffc02061a8 <strnlen>
ffffffffc0206122:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0206126:	01a05863          	blez	s10,ffffffffc0206136 <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc020612a:	85ca                	mv	a1,s2
ffffffffc020612c:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020612e:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc0206130:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0206132:	fe0d1ce3          	bnez	s10,ffffffffc020612a <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0206136:	000dc783          	lbu	a5,0(s11)
ffffffffc020613a:	0007851b          	sext.w	a0,a5
ffffffffc020613e:	ec0792e3          	bnez	a5,ffffffffc0206002 <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0206142:	6a22                	ld	s4,8(sp)
ffffffffc0206144:	bb29                	j	ffffffffc0205e5e <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0206146:	8462                	mv	s0,s8
ffffffffc0206148:	bbd9                	j	ffffffffc0205f1e <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020614a:	85e6                	mv	a1,s9
ffffffffc020614c:	00002517          	auipc	a0,0x2
ffffffffc0206150:	dcc50513          	addi	a0,a0,-564 # ffffffffc0207f18 <etext+0x1caa>
ffffffffc0206154:	054000ef          	jal	ffffffffc02061a8 <strnlen>
ffffffffc0206158:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020615c:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0206160:	00002d97          	auipc	s11,0x2
ffffffffc0206164:	db8d8d93          	addi	s11,s11,-584 # ffffffffc0207f18 <etext+0x1caa>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0206168:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020616a:	fda040e3          	bgtz	s10,ffffffffc020612a <vprintfmt+0x300>
ffffffffc020616e:	bd51                	j	ffffffffc0206002 <vprintfmt+0x1d8>

ffffffffc0206170 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0206170:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0206172:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0206176:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0206178:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020617a:	ec06                	sd	ra,24(sp)
ffffffffc020617c:	f83a                	sd	a4,48(sp)
ffffffffc020617e:	fc3e                	sd	a5,56(sp)
ffffffffc0206180:	e0c2                	sd	a6,64(sp)
ffffffffc0206182:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0206184:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0206186:	ca5ff0ef          	jal	ffffffffc0205e2a <vprintfmt>
}
ffffffffc020618a:	60e2                	ld	ra,24(sp)
ffffffffc020618c:	6161                	addi	sp,sp,80
ffffffffc020618e:	8082                	ret

ffffffffc0206190 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0206190:	00054783          	lbu	a5,0(a0)
ffffffffc0206194:	cb81                	beqz	a5,ffffffffc02061a4 <strlen+0x14>
    size_t cnt = 0;
ffffffffc0206196:	4781                	li	a5,0
        cnt ++;
ffffffffc0206198:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc020619a:	00f50733          	add	a4,a0,a5
ffffffffc020619e:	00074703          	lbu	a4,0(a4)
ffffffffc02061a2:	fb7d                	bnez	a4,ffffffffc0206198 <strlen+0x8>
    }
    return cnt;
}
ffffffffc02061a4:	853e                	mv	a0,a5
ffffffffc02061a6:	8082                	ret

ffffffffc02061a8 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02061a8:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02061aa:	e589                	bnez	a1,ffffffffc02061b4 <strnlen+0xc>
ffffffffc02061ac:	a811                	j	ffffffffc02061c0 <strnlen+0x18>
        cnt ++;
ffffffffc02061ae:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02061b0:	00f58863          	beq	a1,a5,ffffffffc02061c0 <strnlen+0x18>
ffffffffc02061b4:	00f50733          	add	a4,a0,a5
ffffffffc02061b8:	00074703          	lbu	a4,0(a4)
ffffffffc02061bc:	fb6d                	bnez	a4,ffffffffc02061ae <strnlen+0x6>
ffffffffc02061be:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02061c0:	852e                	mv	a0,a1
ffffffffc02061c2:	8082                	ret

ffffffffc02061c4 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc02061c4:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc02061c6:	0005c703          	lbu	a4,0(a1)
ffffffffc02061ca:	0585                	addi	a1,a1,1
ffffffffc02061cc:	0785                	addi	a5,a5,1
ffffffffc02061ce:	fee78fa3          	sb	a4,-1(a5)
ffffffffc02061d2:	fb75                	bnez	a4,ffffffffc02061c6 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc02061d4:	8082                	ret

ffffffffc02061d6 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02061d6:	00054783          	lbu	a5,0(a0)
ffffffffc02061da:	e791                	bnez	a5,ffffffffc02061e6 <strcmp+0x10>
ffffffffc02061dc:	a01d                	j	ffffffffc0206202 <strcmp+0x2c>
ffffffffc02061de:	00054783          	lbu	a5,0(a0)
ffffffffc02061e2:	cb99                	beqz	a5,ffffffffc02061f8 <strcmp+0x22>
ffffffffc02061e4:	0585                	addi	a1,a1,1
ffffffffc02061e6:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc02061ea:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02061ec:	fef709e3          	beq	a4,a5,ffffffffc02061de <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02061f0:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02061f4:	9d19                	subw	a0,a0,a4
ffffffffc02061f6:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02061f8:	0015c703          	lbu	a4,1(a1)
ffffffffc02061fc:	4501                	li	a0,0
}
ffffffffc02061fe:	9d19                	subw	a0,a0,a4
ffffffffc0206200:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0206202:	0005c703          	lbu	a4,0(a1)
ffffffffc0206206:	4501                	li	a0,0
ffffffffc0206208:	b7f5                	j	ffffffffc02061f4 <strcmp+0x1e>

ffffffffc020620a <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020620a:	ce01                	beqz	a2,ffffffffc0206222 <strncmp+0x18>
ffffffffc020620c:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0206210:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0206212:	cb91                	beqz	a5,ffffffffc0206226 <strncmp+0x1c>
ffffffffc0206214:	0005c703          	lbu	a4,0(a1)
ffffffffc0206218:	00f71763          	bne	a4,a5,ffffffffc0206226 <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc020621c:	0505                	addi	a0,a0,1
ffffffffc020621e:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0206220:	f675                	bnez	a2,ffffffffc020620c <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0206222:	4501                	li	a0,0
ffffffffc0206224:	8082                	ret
ffffffffc0206226:	00054503          	lbu	a0,0(a0)
ffffffffc020622a:	0005c783          	lbu	a5,0(a1)
ffffffffc020622e:	9d1d                	subw	a0,a0,a5
}
ffffffffc0206230:	8082                	ret

ffffffffc0206232 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0206232:	a021                	j	ffffffffc020623a <strchr+0x8>
        if (*s == c) {
ffffffffc0206234:	00f58763          	beq	a1,a5,ffffffffc0206242 <strchr+0x10>
            return (char *)s;
        }
        s ++;
ffffffffc0206238:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc020623a:	00054783          	lbu	a5,0(a0)
ffffffffc020623e:	fbfd                	bnez	a5,ffffffffc0206234 <strchr+0x2>
    }
    return NULL;
ffffffffc0206240:	4501                	li	a0,0
}
ffffffffc0206242:	8082                	ret

ffffffffc0206244 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0206244:	ca01                	beqz	a2,ffffffffc0206254 <memset+0x10>
ffffffffc0206246:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0206248:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc020624a:	0785                	addi	a5,a5,1
ffffffffc020624c:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0206250:	fef61de3          	bne	a2,a5,ffffffffc020624a <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0206254:	8082                	ret

ffffffffc0206256 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0206256:	ca19                	beqz	a2,ffffffffc020626c <memcpy+0x16>
ffffffffc0206258:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc020625a:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc020625c:	0005c703          	lbu	a4,0(a1)
ffffffffc0206260:	0585                	addi	a1,a1,1
ffffffffc0206262:	0785                	addi	a5,a5,1
ffffffffc0206264:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0206268:	feb61ae3          	bne	a2,a1,ffffffffc020625c <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc020626c:	8082                	ret
