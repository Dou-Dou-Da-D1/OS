
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
ffffffffc0200062:	119050ef          	jal	ffffffffc020597a <memset>
    cons_init(); // init the console
ffffffffc0200066:	4e6000ef          	jal	ffffffffc020054c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006a:	00006597          	auipc	a1,0x6
ffffffffc020006e:	93e58593          	addi	a1,a1,-1730 # ffffffffc02059a8 <etext+0x4>
ffffffffc0200072:	00006517          	auipc	a0,0x6
ffffffffc0200076:	95650513          	addi	a0,a0,-1706 # ffffffffc02059c8 <etext+0x24>
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
ffffffffc0200096:	1a0050ef          	jal	ffffffffc0205236 <sched_init>
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
ffffffffc02000be:	91650513          	addi	a0,a0,-1770 # ffffffffc02059d0 <etext+0x2c>
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
ffffffffc020018c:	3d4050ef          	jal	ffffffffc0205560 <vprintfmt>
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
ffffffffc02001c0:	3a0050ef          	jal	ffffffffc0205560 <vprintfmt>
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
ffffffffc020022c:	00005517          	auipc	a0,0x5
ffffffffc0200230:	7ac50513          	addi	a0,a0,1964 # ffffffffc02059d8 <etext+0x34>
void print_kerninfo(void) {
ffffffffc0200234:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200236:	f63ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020023a:	00000597          	auipc	a1,0x0
ffffffffc020023e:	e1058593          	addi	a1,a1,-496 # ffffffffc020004a <kern_init>
ffffffffc0200242:	00005517          	auipc	a0,0x5
ffffffffc0200246:	7b650513          	addi	a0,a0,1974 # ffffffffc02059f8 <etext+0x54>
ffffffffc020024a:	f4fff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020024e:	00005597          	auipc	a1,0x5
ffffffffc0200252:	75658593          	addi	a1,a1,1878 # ffffffffc02059a4 <etext>
ffffffffc0200256:	00005517          	auipc	a0,0x5
ffffffffc020025a:	7c250513          	addi	a0,a0,1986 # ffffffffc0205a18 <etext+0x74>
ffffffffc020025e:	f3bff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200262:	000b1597          	auipc	a1,0xb1
ffffffffc0200266:	f2658593          	addi	a1,a1,-218 # ffffffffc02b1188 <buf>
ffffffffc020026a:	00005517          	auipc	a0,0x5
ffffffffc020026e:	7ce50513          	addi	a0,a0,1998 # ffffffffc0205a38 <etext+0x94>
ffffffffc0200272:	f27ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200276:	000b5597          	auipc	a1,0xb5
ffffffffc020027a:	3fa58593          	addi	a1,a1,1018 # ffffffffc02b5670 <end>
ffffffffc020027e:	00005517          	auipc	a0,0x5
ffffffffc0200282:	7da50513          	addi	a0,a0,2010 # ffffffffc0205a58 <etext+0xb4>
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
ffffffffc02002aa:	00005517          	auipc	a0,0x5
ffffffffc02002ae:	7ce50513          	addi	a0,a0,1998 # ffffffffc0205a78 <etext+0xd4>
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
ffffffffc02002b8:	00005617          	auipc	a2,0x5
ffffffffc02002bc:	7f060613          	addi	a2,a2,2032 # ffffffffc0205aa8 <etext+0x104>
ffffffffc02002c0:	04d00593          	li	a1,77
ffffffffc02002c4:	00005517          	auipc	a0,0x5
ffffffffc02002c8:	7fc50513          	addi	a0,a0,2044 # ffffffffc0205ac0 <etext+0x11c>
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
ffffffffc02002da:	00007417          	auipc	s0,0x7
ffffffffc02002de:	44e40413          	addi	s0,s0,1102 # ffffffffc0207728 <commands>
ffffffffc02002e2:	00007497          	auipc	s1,0x7
ffffffffc02002e6:	48e48493          	addi	s1,s1,1166 # ffffffffc0207770 <commands+0x48>
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002ea:	6410                	ld	a2,8(s0)
ffffffffc02002ec:	600c                	ld	a1,0(s0)
ffffffffc02002ee:	00005517          	auipc	a0,0x5
ffffffffc02002f2:	7ea50513          	addi	a0,a0,2026 # ffffffffc0205ad8 <etext+0x134>
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
ffffffffc0200332:	00005517          	auipc	a0,0x5
ffffffffc0200336:	7b650513          	addi	a0,a0,1974 # ffffffffc0205ae8 <etext+0x144>
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
ffffffffc020034a:	00005517          	auipc	a0,0x5
ffffffffc020034e:	7c650513          	addi	a0,a0,1990 # ffffffffc0205b10 <etext+0x16c>
ffffffffc0200352:	e47ff0ef          	jal	ffffffffc0200198 <cprintf>
    if (tf != NULL) {
ffffffffc0200356:	000a0563          	beqz	s4,ffffffffc0200360 <kmonitor+0x34>
        print_trapframe(tf);
ffffffffc020035a:	8552                	mv	a0,s4
ffffffffc020035c:	79e000ef          	jal	ffffffffc0200afa <print_trapframe>
ffffffffc0200360:	00007a97          	auipc	s5,0x7
ffffffffc0200364:	3c8a8a93          	addi	s5,s5,968 # ffffffffc0207728 <commands>
        if (argc == MAXARGS - 1) {
ffffffffc0200368:	49bd                	li	s3,15
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020036a:	00005517          	auipc	a0,0x5
ffffffffc020036e:	7ce50513          	addi	a0,a0,1998 # ffffffffc0205b38 <etext+0x194>
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
ffffffffc0200388:	00007497          	auipc	s1,0x7
ffffffffc020038c:	3a048493          	addi	s1,s1,928 # ffffffffc0207728 <commands>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200390:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200392:	6582                	ld	a1,0(sp)
ffffffffc0200394:	6088                	ld	a0,0(s1)
ffffffffc0200396:	576050ef          	jal	ffffffffc020590c <strcmp>
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
ffffffffc02003a8:	00005517          	auipc	a0,0x5
ffffffffc02003ac:	7c050513          	addi	a0,a0,1984 # ffffffffc0205b68 <etext+0x1c4>
ffffffffc02003b0:	de9ff0ef          	jal	ffffffffc0200198 <cprintf>
    return 0;
ffffffffc02003b4:	bf5d                	j	ffffffffc020036a <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003b6:	00005517          	auipc	a0,0x5
ffffffffc02003ba:	78a50513          	addi	a0,a0,1930 # ffffffffc0205b40 <etext+0x19c>
ffffffffc02003be:	5aa050ef          	jal	ffffffffc0205968 <strchr>
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
ffffffffc02003f8:	00005517          	auipc	a0,0x5
ffffffffc02003fc:	74850513          	addi	a0,a0,1864 # ffffffffc0205b40 <etext+0x19c>
ffffffffc0200400:	568050ef          	jal	ffffffffc0205968 <strchr>
ffffffffc0200404:	d575                	beqz	a0,ffffffffc02003f0 <kmonitor+0xc4>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200406:	00044583          	lbu	a1,0(s0)
ffffffffc020040a:	dda5                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc020040c:	b76d                	j	ffffffffc02003b6 <kmonitor+0x8a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020040e:	45c1                	li	a1,16
ffffffffc0200410:	00005517          	auipc	a0,0x5
ffffffffc0200414:	73850513          	addi	a0,a0,1848 # ffffffffc0205b48 <etext+0x1a4>
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
ffffffffc0200470:	00005517          	auipc	a0,0x5
ffffffffc0200474:	7a050513          	addi	a0,a0,1952 # ffffffffc0205c10 <etext+0x26c>
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
ffffffffc020048e:	00005517          	auipc	a0,0x5
ffffffffc0200492:	7a250513          	addi	a0,a0,1954 # ffffffffc0205c30 <etext+0x28c>
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
ffffffffc02004d2:	00005517          	auipc	a0,0x5
ffffffffc02004d6:	76650513          	addi	a0,a0,1894 # ffffffffc0205c38 <etext+0x294>
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
ffffffffc02005c0:	00005517          	auipc	a0,0x5
ffffffffc02005c4:	69850513          	addi	a0,a0,1688 # ffffffffc0205c58 <etext+0x2b4>
void dtb_init(void) {
ffffffffc02005c8:	f406                	sd	ra,40(sp)
ffffffffc02005ca:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc02005cc:	bcdff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005d0:	0000c597          	auipc	a1,0xc
ffffffffc02005d4:	a305b583          	ld	a1,-1488(a1) # ffffffffc020c000 <boot_hartid>
ffffffffc02005d8:	00005517          	auipc	a0,0x5
ffffffffc02005dc:	69050513          	addi	a0,a0,1680 # ffffffffc0205c68 <etext+0x2c4>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005e0:	0000c417          	auipc	s0,0xc
ffffffffc02005e4:	a2840413          	addi	s0,s0,-1496 # ffffffffc020c008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005e8:	bb1ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005ec:	600c                	ld	a1,0(s0)
ffffffffc02005ee:	00005517          	auipc	a0,0x5
ffffffffc02005f2:	68a50513          	addi	a0,a0,1674 # ffffffffc0205c78 <etext+0x2d4>
ffffffffc02005f6:	ba3ff0ef          	jal	ffffffffc0200198 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc02005fa:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc02005fc:	00005517          	auipc	a0,0x5
ffffffffc0200600:	69450513          	addi	a0,a0,1684 # ffffffffc0205c90 <etext+0x2ec>
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
ffffffffc02006ee:	00005517          	auipc	a0,0x5
ffffffffc02006f2:	66a50513          	addi	a0,a0,1642 # ffffffffc0205d58 <etext+0x3b4>
ffffffffc02006f6:	aa3ff0ef          	jal	ffffffffc0200198 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02006fa:	64e2                	ld	s1,24(sp)
ffffffffc02006fc:	6942                	ld	s2,16(sp)
ffffffffc02006fe:	00005517          	auipc	a0,0x5
ffffffffc0200702:	69250513          	addi	a0,a0,1682 # ffffffffc0205d90 <etext+0x3ec>
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
ffffffffc0200712:	00005517          	auipc	a0,0x5
ffffffffc0200716:	59e50513          	addi	a0,a0,1438 # ffffffffc0205cb0 <etext+0x30c>
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
ffffffffc0200758:	16e050ef          	jal	ffffffffc02058c6 <strlen>
ffffffffc020075c:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020075e:	4619                	li	a2,6
ffffffffc0200760:	8522                	mv	a0,s0
ffffffffc0200762:	00005597          	auipc	a1,0x5
ffffffffc0200766:	57658593          	addi	a1,a1,1398 # ffffffffc0205cd8 <etext+0x334>
ffffffffc020076a:	1d6050ef          	jal	ffffffffc0205940 <strncmp>
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
ffffffffc020078e:	00005597          	auipc	a1,0x5
ffffffffc0200792:	55258593          	addi	a1,a1,1362 # ffffffffc0205ce0 <etext+0x33c>
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
ffffffffc02007c4:	148050ef          	jal	ffffffffc020590c <strcmp>
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
ffffffffc02007e4:	00005517          	auipc	a0,0x5
ffffffffc02007e8:	50450513          	addi	a0,a0,1284 # ffffffffc0205ce8 <etext+0x344>
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
ffffffffc02008ae:	00005517          	auipc	a0,0x5
ffffffffc02008b2:	45a50513          	addi	a0,a0,1114 # ffffffffc0205d08 <etext+0x364>
ffffffffc02008b6:	8e3ff0ef          	jal	ffffffffc0200198 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc02008ba:	01445613          	srli	a2,s0,0x14
ffffffffc02008be:	85a2                	mv	a1,s0
ffffffffc02008c0:	00005517          	auipc	a0,0x5
ffffffffc02008c4:	46050513          	addi	a0,a0,1120 # ffffffffc0205d20 <etext+0x37c>
ffffffffc02008c8:	8d1ff0ef          	jal	ffffffffc0200198 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02008cc:	009405b3          	add	a1,s0,s1
ffffffffc02008d0:	15fd                	addi	a1,a1,-1
ffffffffc02008d2:	00005517          	auipc	a0,0x5
ffffffffc02008d6:	46e50513          	addi	a0,a0,1134 # ffffffffc0205d40 <etext+0x39c>
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
ffffffffc0200934:	00005517          	auipc	a0,0x5
ffffffffc0200938:	47450513          	addi	a0,a0,1140 # ffffffffc0205da8 <etext+0x404>
{
ffffffffc020093c:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020093e:	85bff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200942:	640c                	ld	a1,8(s0)
ffffffffc0200944:	00005517          	auipc	a0,0x5
ffffffffc0200948:	47c50513          	addi	a0,a0,1148 # ffffffffc0205dc0 <etext+0x41c>
ffffffffc020094c:	84dff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc0200950:	680c                	ld	a1,16(s0)
ffffffffc0200952:	00005517          	auipc	a0,0x5
ffffffffc0200956:	48650513          	addi	a0,a0,1158 # ffffffffc0205dd8 <etext+0x434>
ffffffffc020095a:	83fff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc020095e:	6c0c                	ld	a1,24(s0)
ffffffffc0200960:	00005517          	auipc	a0,0x5
ffffffffc0200964:	49050513          	addi	a0,a0,1168 # ffffffffc0205df0 <etext+0x44c>
ffffffffc0200968:	831ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc020096c:	700c                	ld	a1,32(s0)
ffffffffc020096e:	00005517          	auipc	a0,0x5
ffffffffc0200972:	49a50513          	addi	a0,a0,1178 # ffffffffc0205e08 <etext+0x464>
ffffffffc0200976:	823ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc020097a:	740c                	ld	a1,40(s0)
ffffffffc020097c:	00005517          	auipc	a0,0x5
ffffffffc0200980:	4a450513          	addi	a0,a0,1188 # ffffffffc0205e20 <etext+0x47c>
ffffffffc0200984:	815ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200988:	780c                	ld	a1,48(s0)
ffffffffc020098a:	00005517          	auipc	a0,0x5
ffffffffc020098e:	4ae50513          	addi	a0,a0,1198 # ffffffffc0205e38 <etext+0x494>
ffffffffc0200992:	807ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200996:	7c0c                	ld	a1,56(s0)
ffffffffc0200998:	00005517          	auipc	a0,0x5
ffffffffc020099c:	4b850513          	addi	a0,a0,1208 # ffffffffc0205e50 <etext+0x4ac>
ffffffffc02009a0:	ff8ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02009a4:	602c                	ld	a1,64(s0)
ffffffffc02009a6:	00005517          	auipc	a0,0x5
ffffffffc02009aa:	4c250513          	addi	a0,a0,1218 # ffffffffc0205e68 <etext+0x4c4>
ffffffffc02009ae:	feaff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02009b2:	642c                	ld	a1,72(s0)
ffffffffc02009b4:	00005517          	auipc	a0,0x5
ffffffffc02009b8:	4cc50513          	addi	a0,a0,1228 # ffffffffc0205e80 <etext+0x4dc>
ffffffffc02009bc:	fdcff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02009c0:	682c                	ld	a1,80(s0)
ffffffffc02009c2:	00005517          	auipc	a0,0x5
ffffffffc02009c6:	4d650513          	addi	a0,a0,1238 # ffffffffc0205e98 <etext+0x4f4>
ffffffffc02009ca:	fceff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02009ce:	6c2c                	ld	a1,88(s0)
ffffffffc02009d0:	00005517          	auipc	a0,0x5
ffffffffc02009d4:	4e050513          	addi	a0,a0,1248 # ffffffffc0205eb0 <etext+0x50c>
ffffffffc02009d8:	fc0ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc02009dc:	702c                	ld	a1,96(s0)
ffffffffc02009de:	00005517          	auipc	a0,0x5
ffffffffc02009e2:	4ea50513          	addi	a0,a0,1258 # ffffffffc0205ec8 <etext+0x524>
ffffffffc02009e6:	fb2ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc02009ea:	742c                	ld	a1,104(s0)
ffffffffc02009ec:	00005517          	auipc	a0,0x5
ffffffffc02009f0:	4f450513          	addi	a0,a0,1268 # ffffffffc0205ee0 <etext+0x53c>
ffffffffc02009f4:	fa4ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc02009f8:	782c                	ld	a1,112(s0)
ffffffffc02009fa:	00005517          	auipc	a0,0x5
ffffffffc02009fe:	4fe50513          	addi	a0,a0,1278 # ffffffffc0205ef8 <etext+0x554>
ffffffffc0200a02:	f96ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200a06:	7c2c                	ld	a1,120(s0)
ffffffffc0200a08:	00005517          	auipc	a0,0x5
ffffffffc0200a0c:	50850513          	addi	a0,a0,1288 # ffffffffc0205f10 <etext+0x56c>
ffffffffc0200a10:	f88ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200a14:	604c                	ld	a1,128(s0)
ffffffffc0200a16:	00005517          	auipc	a0,0x5
ffffffffc0200a1a:	51250513          	addi	a0,a0,1298 # ffffffffc0205f28 <etext+0x584>
ffffffffc0200a1e:	f7aff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200a22:	644c                	ld	a1,136(s0)
ffffffffc0200a24:	00005517          	auipc	a0,0x5
ffffffffc0200a28:	51c50513          	addi	a0,a0,1308 # ffffffffc0205f40 <etext+0x59c>
ffffffffc0200a2c:	f6cff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200a30:	684c                	ld	a1,144(s0)
ffffffffc0200a32:	00005517          	auipc	a0,0x5
ffffffffc0200a36:	52650513          	addi	a0,a0,1318 # ffffffffc0205f58 <etext+0x5b4>
ffffffffc0200a3a:	f5eff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200a3e:	6c4c                	ld	a1,152(s0)
ffffffffc0200a40:	00005517          	auipc	a0,0x5
ffffffffc0200a44:	53050513          	addi	a0,a0,1328 # ffffffffc0205f70 <etext+0x5cc>
ffffffffc0200a48:	f50ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200a4c:	704c                	ld	a1,160(s0)
ffffffffc0200a4e:	00005517          	auipc	a0,0x5
ffffffffc0200a52:	53a50513          	addi	a0,a0,1338 # ffffffffc0205f88 <etext+0x5e4>
ffffffffc0200a56:	f42ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200a5a:	744c                	ld	a1,168(s0)
ffffffffc0200a5c:	00005517          	auipc	a0,0x5
ffffffffc0200a60:	54450513          	addi	a0,a0,1348 # ffffffffc0205fa0 <etext+0x5fc>
ffffffffc0200a64:	f34ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200a68:	784c                	ld	a1,176(s0)
ffffffffc0200a6a:	00005517          	auipc	a0,0x5
ffffffffc0200a6e:	54e50513          	addi	a0,a0,1358 # ffffffffc0205fb8 <etext+0x614>
ffffffffc0200a72:	f26ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200a76:	7c4c                	ld	a1,184(s0)
ffffffffc0200a78:	00005517          	auipc	a0,0x5
ffffffffc0200a7c:	55850513          	addi	a0,a0,1368 # ffffffffc0205fd0 <etext+0x62c>
ffffffffc0200a80:	f18ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200a84:	606c                	ld	a1,192(s0)
ffffffffc0200a86:	00005517          	auipc	a0,0x5
ffffffffc0200a8a:	56250513          	addi	a0,a0,1378 # ffffffffc0205fe8 <etext+0x644>
ffffffffc0200a8e:	f0aff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200a92:	646c                	ld	a1,200(s0)
ffffffffc0200a94:	00005517          	auipc	a0,0x5
ffffffffc0200a98:	56c50513          	addi	a0,a0,1388 # ffffffffc0206000 <etext+0x65c>
ffffffffc0200a9c:	efcff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200aa0:	686c                	ld	a1,208(s0)
ffffffffc0200aa2:	00005517          	auipc	a0,0x5
ffffffffc0200aa6:	57650513          	addi	a0,a0,1398 # ffffffffc0206018 <etext+0x674>
ffffffffc0200aaa:	eeeff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200aae:	6c6c                	ld	a1,216(s0)
ffffffffc0200ab0:	00005517          	auipc	a0,0x5
ffffffffc0200ab4:	58050513          	addi	a0,a0,1408 # ffffffffc0206030 <etext+0x68c>
ffffffffc0200ab8:	ee0ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200abc:	706c                	ld	a1,224(s0)
ffffffffc0200abe:	00005517          	auipc	a0,0x5
ffffffffc0200ac2:	58a50513          	addi	a0,a0,1418 # ffffffffc0206048 <etext+0x6a4>
ffffffffc0200ac6:	ed2ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200aca:	746c                	ld	a1,232(s0)
ffffffffc0200acc:	00005517          	auipc	a0,0x5
ffffffffc0200ad0:	59450513          	addi	a0,a0,1428 # ffffffffc0206060 <etext+0x6bc>
ffffffffc0200ad4:	ec4ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200ad8:	786c                	ld	a1,240(s0)
ffffffffc0200ada:	00005517          	auipc	a0,0x5
ffffffffc0200ade:	59e50513          	addi	a0,a0,1438 # ffffffffc0206078 <etext+0x6d4>
ffffffffc0200ae2:	eb6ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ae6:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200ae8:	6402                	ld	s0,0(sp)
ffffffffc0200aea:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200aec:	00005517          	auipc	a0,0x5
ffffffffc0200af0:	5a450513          	addi	a0,a0,1444 # ffffffffc0206090 <etext+0x6ec>
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
ffffffffc0200b02:	00005517          	auipc	a0,0x5
ffffffffc0200b06:	5a650513          	addi	a0,a0,1446 # ffffffffc02060a8 <etext+0x704>
{
ffffffffc0200b0a:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b0c:	e8cff0ef          	jal	ffffffffc0200198 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200b10:	8522                	mv	a0,s0
ffffffffc0200b12:	e1bff0ef          	jal	ffffffffc020092c <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200b16:	10043583          	ld	a1,256(s0)
ffffffffc0200b1a:	00005517          	auipc	a0,0x5
ffffffffc0200b1e:	5a650513          	addi	a0,a0,1446 # ffffffffc02060c0 <etext+0x71c>
ffffffffc0200b22:	e76ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200b26:	10843583          	ld	a1,264(s0)
ffffffffc0200b2a:	00005517          	auipc	a0,0x5
ffffffffc0200b2e:	5ae50513          	addi	a0,a0,1454 # ffffffffc02060d8 <etext+0x734>
ffffffffc0200b32:	e66ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200b36:	11043583          	ld	a1,272(s0)
ffffffffc0200b3a:	00005517          	auipc	a0,0x5
ffffffffc0200b3e:	5b650513          	addi	a0,a0,1462 # ffffffffc02060f0 <etext+0x74c>
ffffffffc0200b42:	e56ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b46:	11843583          	ld	a1,280(s0)
}
ffffffffc0200b4a:	6402                	ld	s0,0(sp)
ffffffffc0200b4c:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b4e:	00005517          	auipc	a0,0x5
ffffffffc0200b52:	5b250513          	addi	a0,a0,1458 # ffffffffc0206100 <etext+0x75c>
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
ffffffffc0200b6e:	c0670713          	addi	a4,a4,-1018 # ffffffffc0207770 <commands+0x48>
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
ffffffffc0200b7c:	00005517          	auipc	a0,0x5
ffffffffc0200b80:	5fc50513          	addi	a0,a0,1532 # ffffffffc0206178 <etext+0x7d4>
ffffffffc0200b84:	e14ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200b88:	00005517          	auipc	a0,0x5
ffffffffc0200b8c:	5d050513          	addi	a0,a0,1488 # ffffffffc0206158 <etext+0x7b4>
ffffffffc0200b90:	e08ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200b94:	00005517          	auipc	a0,0x5
ffffffffc0200b98:	58450513          	addi	a0,a0,1412 # ffffffffc0206118 <etext+0x774>
ffffffffc0200b9c:	dfcff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200ba0:	00005517          	auipc	a0,0x5
ffffffffc0200ba4:	59850513          	addi	a0,a0,1432 # ffffffffc0206138 <etext+0x794>
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
ffffffffc0200bde:	6340406f          	j	ffffffffc0205212 <sched_class_proc_tick>
        cprintf("Supervisor external interrupt\n");
ffffffffc0200be2:	00005517          	auipc	a0,0x5
ffffffffc0200be6:	60650513          	addi	a0,a0,1542 # ffffffffc02061e8 <etext+0x844>
ffffffffc0200bea:	daeff06f          	j	ffffffffc0200198 <cprintf>
        print_trapframe(tf);
ffffffffc0200bee:	b731                	j	ffffffffc0200afa <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200bf0:	6585                	lui	a1,0x1
ffffffffc0200bf2:	38858593          	addi	a1,a1,904 # 1388 <_binary_obj___user_softint_out_size-0x7ba0>
ffffffffc0200bf6:	00005517          	auipc	a0,0x5
ffffffffc0200bfa:	5a250513          	addi	a0,a0,1442 # ffffffffc0206198 <etext+0x7f4>
ffffffffc0200bfe:	d9aff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("End of Test.\n");
ffffffffc0200c02:	00005517          	auipc	a0,0x5
ffffffffc0200c06:	5a650513          	addi	a0,a0,1446 # ffffffffc02061a8 <etext+0x804>
ffffffffc0200c0a:	d8eff0ef          	jal	ffffffffc0200198 <cprintf>
    panic("EOT: kernel seems ok.");
ffffffffc0200c0e:	00005617          	auipc	a2,0x5
ffffffffc0200c12:	5aa60613          	addi	a2,a2,1450 # ffffffffc02061b8 <etext+0x814>
ffffffffc0200c16:	45ed                	li	a1,27
ffffffffc0200c18:	00005517          	auipc	a0,0x5
ffffffffc0200c1c:	5b850513          	addi	a0,a0,1464 # ffffffffc02061d0 <etext+0x82c>
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
ffffffffc0200c32:	b7270713          	addi	a4,a4,-1166 # ffffffffc02077a0 <commands+0x78>
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
ffffffffc0200c48:	00005517          	auipc	a0,0x5
ffffffffc0200c4c:	69050513          	addi	a0,a0,1680 # ffffffffc02062d8 <etext+0x934>
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
ffffffffc0200c64:	0030406f          	j	ffffffffc0205466 <syscall>
}
ffffffffc0200c68:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from H-mode\n");
ffffffffc0200c6a:	00005517          	auipc	a0,0x5
ffffffffc0200c6e:	68e50513          	addi	a0,a0,1678 # ffffffffc02062f8 <etext+0x954>
}
ffffffffc0200c72:	6105                	addi	sp,sp,32
        cprintf("Environment call from H-mode\n");
ffffffffc0200c74:	d24ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c78:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from M-mode\n");
ffffffffc0200c7a:	00005517          	auipc	a0,0x5
ffffffffc0200c7e:	69e50513          	addi	a0,a0,1694 # ffffffffc0206318 <etext+0x974>
}
ffffffffc0200c82:	6105                	addi	sp,sp,32
        cprintf("Environment call from M-mode\n");
ffffffffc0200c84:	d14ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c88:	60e2                	ld	ra,24(sp)
        cprintf("Instruction page fault\n");
ffffffffc0200c8a:	00005517          	auipc	a0,0x5
ffffffffc0200c8e:	6ae50513          	addi	a0,a0,1710 # ffffffffc0206338 <etext+0x994>
}
ffffffffc0200c92:	6105                	addi	sp,sp,32
        cprintf("Instruction page fault\n");
ffffffffc0200c94:	d04ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c98:	60e2                	ld	ra,24(sp)
        cprintf("Load page fault\n");
ffffffffc0200c9a:	00005517          	auipc	a0,0x5
ffffffffc0200c9e:	6b650513          	addi	a0,a0,1718 # ffffffffc0206350 <etext+0x9ac>
}
ffffffffc0200ca2:	6105                	addi	sp,sp,32
        cprintf("Load page fault\n");
ffffffffc0200ca4:	cf4ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200ca8:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO page fault\n");
ffffffffc0200caa:	00005517          	auipc	a0,0x5
ffffffffc0200cae:	6be50513          	addi	a0,a0,1726 # ffffffffc0206368 <etext+0x9c4>
}
ffffffffc0200cb2:	6105                	addi	sp,sp,32
        cprintf("Store/AMO page fault\n");
ffffffffc0200cb4:	ce4ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200cb8:	60e2                	ld	ra,24(sp)
        cprintf("Instruction address misaligned\n");
ffffffffc0200cba:	00005517          	auipc	a0,0x5
ffffffffc0200cbe:	54e50513          	addi	a0,a0,1358 # ffffffffc0206208 <etext+0x864>
}
ffffffffc0200cc2:	6105                	addi	sp,sp,32
        cprintf("Instruction address misaligned\n");
ffffffffc0200cc4:	cd4ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200cc8:	60e2                	ld	ra,24(sp)
        cprintf("Instruction access fault\n");
ffffffffc0200cca:	00005517          	auipc	a0,0x5
ffffffffc0200cce:	55e50513          	addi	a0,a0,1374 # ffffffffc0206228 <etext+0x884>
}
ffffffffc0200cd2:	6105                	addi	sp,sp,32
        cprintf("Instruction access fault\n");
ffffffffc0200cd4:	cc4ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200cd8:	60e2                	ld	ra,24(sp)
        cprintf("Illegal instruction\n");
ffffffffc0200cda:	00005517          	auipc	a0,0x5
ffffffffc0200cde:	56e50513          	addi	a0,a0,1390 # ffffffffc0206248 <etext+0x8a4>
}
ffffffffc0200ce2:	6105                	addi	sp,sp,32
        cprintf("Illegal instruction\n");
ffffffffc0200ce4:	cb4ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200ce8:	60e2                	ld	ra,24(sp)
        cprintf("Breakpoint\n");
ffffffffc0200cea:	00005517          	auipc	a0,0x5
ffffffffc0200cee:	57650513          	addi	a0,a0,1398 # ffffffffc0206260 <etext+0x8bc>
}
ffffffffc0200cf2:	6105                	addi	sp,sp,32
        cprintf("Breakpoint\n");
ffffffffc0200cf4:	ca4ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200cf8:	60e2                	ld	ra,24(sp)
        cprintf("Load address misaligned\n");
ffffffffc0200cfa:	00005517          	auipc	a0,0x5
ffffffffc0200cfe:	57650513          	addi	a0,a0,1398 # ffffffffc0206270 <etext+0x8cc>
}
ffffffffc0200d02:	6105                	addi	sp,sp,32
        cprintf("Load address misaligned\n");
ffffffffc0200d04:	c94ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200d08:	60e2                	ld	ra,24(sp)
        cprintf("Load access fault\n");
ffffffffc0200d0a:	00005517          	auipc	a0,0x5
ffffffffc0200d0e:	58650513          	addi	a0,a0,1414 # ffffffffc0206290 <etext+0x8ec>
}
ffffffffc0200d12:	6105                	addi	sp,sp,32
        cprintf("Load access fault\n");
ffffffffc0200d14:	c84ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200d18:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO access fault\n");
ffffffffc0200d1a:	00005517          	auipc	a0,0x5
ffffffffc0200d1e:	5a650513          	addi	a0,a0,1446 # ffffffffc02062c0 <etext+0x91c>
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
ffffffffc0200d2e:	00005617          	auipc	a2,0x5
ffffffffc0200d32:	57a60613          	addi	a2,a2,1402 # ffffffffc02062a8 <etext+0x904>
ffffffffc0200d36:	0c800593          	li	a1,200
ffffffffc0200d3a:	00005517          	auipc	a0,0x5
ffffffffc0200d3e:	49650513          	addi	a0,a0,1174 # ffffffffc02061d0 <etext+0x82c>
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
ffffffffc0200db8:	5780406f          	j	ffffffffc0205330 <schedule>
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
ffffffffc0200f60:	00007617          	auipc	a2,0x7
ffffffffc0200f64:	2d863603          	ld	a2,728(a2) # ffffffffc0208238 <nbase>
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
ffffffffc02011c8:	00005697          	auipc	a3,0x5
ffffffffc02011cc:	1b868693          	addi	a3,a3,440 # ffffffffc0206380 <etext+0x9dc>
ffffffffc02011d0:	00005617          	auipc	a2,0x5
ffffffffc02011d4:	1c060613          	addi	a2,a2,448 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02011d8:	11000593          	li	a1,272
ffffffffc02011dc:	00005517          	auipc	a0,0x5
ffffffffc02011e0:	1cc50513          	addi	a0,a0,460 # ffffffffc02063a8 <etext+0xa04>
ffffffffc02011e4:	a66ff0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02011e8:	00005697          	auipc	a3,0x5
ffffffffc02011ec:	28068693          	addi	a3,a3,640 # ffffffffc0206468 <etext+0xac4>
ffffffffc02011f0:	00005617          	auipc	a2,0x5
ffffffffc02011f4:	1a060613          	addi	a2,a2,416 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02011f8:	0dc00593          	li	a1,220
ffffffffc02011fc:	00005517          	auipc	a0,0x5
ffffffffc0201200:	1ac50513          	addi	a0,a0,428 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201204:	a46ff0ef          	jal	ffffffffc020044a <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201208:	00005697          	auipc	a3,0x5
ffffffffc020120c:	32868693          	addi	a3,a3,808 # ffffffffc0206530 <etext+0xb8c>
ffffffffc0201210:	00005617          	auipc	a2,0x5
ffffffffc0201214:	18060613          	addi	a2,a2,384 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201218:	0f700593          	li	a1,247
ffffffffc020121c:	00005517          	auipc	a0,0x5
ffffffffc0201220:	18c50513          	addi	a0,a0,396 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201224:	a26ff0ef          	jal	ffffffffc020044a <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201228:	00005697          	auipc	a3,0x5
ffffffffc020122c:	28068693          	addi	a3,a3,640 # ffffffffc02064a8 <etext+0xb04>
ffffffffc0201230:	00005617          	auipc	a2,0x5
ffffffffc0201234:	16060613          	addi	a2,a2,352 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201238:	0de00593          	li	a1,222
ffffffffc020123c:	00005517          	auipc	a0,0x5
ffffffffc0201240:	16c50513          	addi	a0,a0,364 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201244:	a06ff0ef          	jal	ffffffffc020044a <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201248:	00005697          	auipc	a3,0x5
ffffffffc020124c:	1f868693          	addi	a3,a3,504 # ffffffffc0206440 <etext+0xa9c>
ffffffffc0201250:	00005617          	auipc	a2,0x5
ffffffffc0201254:	14060613          	addi	a2,a2,320 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201258:	0db00593          	li	a1,219
ffffffffc020125c:	00005517          	auipc	a0,0x5
ffffffffc0201260:	14c50513          	addi	a0,a0,332 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201264:	9e6ff0ef          	jal	ffffffffc020044a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201268:	00005697          	auipc	a3,0x5
ffffffffc020126c:	17868693          	addi	a3,a3,376 # ffffffffc02063e0 <etext+0xa3c>
ffffffffc0201270:	00005617          	auipc	a2,0x5
ffffffffc0201274:	12060613          	addi	a2,a2,288 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201278:	0f000593          	li	a1,240
ffffffffc020127c:	00005517          	auipc	a0,0x5
ffffffffc0201280:	12c50513          	addi	a0,a0,300 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201284:	9c6ff0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_free == 3);
ffffffffc0201288:	00005697          	auipc	a3,0x5
ffffffffc020128c:	29868693          	addi	a3,a3,664 # ffffffffc0206520 <etext+0xb7c>
ffffffffc0201290:	00005617          	auipc	a2,0x5
ffffffffc0201294:	10060613          	addi	a2,a2,256 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201298:	0ee00593          	li	a1,238
ffffffffc020129c:	00005517          	auipc	a0,0x5
ffffffffc02012a0:	10c50513          	addi	a0,a0,268 # ffffffffc02063a8 <etext+0xa04>
ffffffffc02012a4:	9a6ff0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012a8:	00005697          	auipc	a3,0x5
ffffffffc02012ac:	26068693          	addi	a3,a3,608 # ffffffffc0206508 <etext+0xb64>
ffffffffc02012b0:	00005617          	auipc	a2,0x5
ffffffffc02012b4:	0e060613          	addi	a2,a2,224 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02012b8:	0e900593          	li	a1,233
ffffffffc02012bc:	00005517          	auipc	a0,0x5
ffffffffc02012c0:	0ec50513          	addi	a0,a0,236 # ffffffffc02063a8 <etext+0xa04>
ffffffffc02012c4:	986ff0ef          	jal	ffffffffc020044a <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02012c8:	00005697          	auipc	a3,0x5
ffffffffc02012cc:	22068693          	addi	a3,a3,544 # ffffffffc02064e8 <etext+0xb44>
ffffffffc02012d0:	00005617          	auipc	a2,0x5
ffffffffc02012d4:	0c060613          	addi	a2,a2,192 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02012d8:	0e000593          	li	a1,224
ffffffffc02012dc:	00005517          	auipc	a0,0x5
ffffffffc02012e0:	0cc50513          	addi	a0,a0,204 # ffffffffc02063a8 <etext+0xa04>
ffffffffc02012e4:	966ff0ef          	jal	ffffffffc020044a <__panic>
    assert(p0 != NULL);
ffffffffc02012e8:	00005697          	auipc	a3,0x5
ffffffffc02012ec:	29068693          	addi	a3,a3,656 # ffffffffc0206578 <etext+0xbd4>
ffffffffc02012f0:	00005617          	auipc	a2,0x5
ffffffffc02012f4:	0a060613          	addi	a2,a2,160 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02012f8:	11800593          	li	a1,280
ffffffffc02012fc:	00005517          	auipc	a0,0x5
ffffffffc0201300:	0ac50513          	addi	a0,a0,172 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201304:	946ff0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_free == 0);
ffffffffc0201308:	00005697          	auipc	a3,0x5
ffffffffc020130c:	26068693          	addi	a3,a3,608 # ffffffffc0206568 <etext+0xbc4>
ffffffffc0201310:	00005617          	auipc	a2,0x5
ffffffffc0201314:	08060613          	addi	a2,a2,128 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201318:	0fd00593          	li	a1,253
ffffffffc020131c:	00005517          	auipc	a0,0x5
ffffffffc0201320:	08c50513          	addi	a0,a0,140 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201324:	926ff0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201328:	00005697          	auipc	a3,0x5
ffffffffc020132c:	1e068693          	addi	a3,a3,480 # ffffffffc0206508 <etext+0xb64>
ffffffffc0201330:	00005617          	auipc	a2,0x5
ffffffffc0201334:	06060613          	addi	a2,a2,96 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201338:	0fb00593          	li	a1,251
ffffffffc020133c:	00005517          	auipc	a0,0x5
ffffffffc0201340:	06c50513          	addi	a0,a0,108 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201344:	906ff0ef          	jal	ffffffffc020044a <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201348:	00005697          	auipc	a3,0x5
ffffffffc020134c:	20068693          	addi	a3,a3,512 # ffffffffc0206548 <etext+0xba4>
ffffffffc0201350:	00005617          	auipc	a2,0x5
ffffffffc0201354:	04060613          	addi	a2,a2,64 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201358:	0fa00593          	li	a1,250
ffffffffc020135c:	00005517          	auipc	a0,0x5
ffffffffc0201360:	04c50513          	addi	a0,a0,76 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201364:	8e6ff0ef          	jal	ffffffffc020044a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201368:	00005697          	auipc	a3,0x5
ffffffffc020136c:	07868693          	addi	a3,a3,120 # ffffffffc02063e0 <etext+0xa3c>
ffffffffc0201370:	00005617          	auipc	a2,0x5
ffffffffc0201374:	02060613          	addi	a2,a2,32 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201378:	0d700593          	li	a1,215
ffffffffc020137c:	00005517          	auipc	a0,0x5
ffffffffc0201380:	02c50513          	addi	a0,a0,44 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201384:	8c6ff0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201388:	00005697          	auipc	a3,0x5
ffffffffc020138c:	18068693          	addi	a3,a3,384 # ffffffffc0206508 <etext+0xb64>
ffffffffc0201390:	00005617          	auipc	a2,0x5
ffffffffc0201394:	00060613          	mv	a2,a2
ffffffffc0201398:	0f400593          	li	a1,244
ffffffffc020139c:	00005517          	auipc	a0,0x5
ffffffffc02013a0:	00c50513          	addi	a0,a0,12 # ffffffffc02063a8 <etext+0xa04>
ffffffffc02013a4:	8a6ff0ef          	jal	ffffffffc020044a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02013a8:	00005697          	auipc	a3,0x5
ffffffffc02013ac:	07868693          	addi	a3,a3,120 # ffffffffc0206420 <etext+0xa7c>
ffffffffc02013b0:	00005617          	auipc	a2,0x5
ffffffffc02013b4:	fe060613          	addi	a2,a2,-32 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02013b8:	0f200593          	li	a1,242
ffffffffc02013bc:	00005517          	auipc	a0,0x5
ffffffffc02013c0:	fec50513          	addi	a0,a0,-20 # ffffffffc02063a8 <etext+0xa04>
ffffffffc02013c4:	886ff0ef          	jal	ffffffffc020044a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02013c8:	00005697          	auipc	a3,0x5
ffffffffc02013cc:	03868693          	addi	a3,a3,56 # ffffffffc0206400 <etext+0xa5c>
ffffffffc02013d0:	00005617          	auipc	a2,0x5
ffffffffc02013d4:	fc060613          	addi	a2,a2,-64 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02013d8:	0f100593          	li	a1,241
ffffffffc02013dc:	00005517          	auipc	a0,0x5
ffffffffc02013e0:	fcc50513          	addi	a0,a0,-52 # ffffffffc02063a8 <etext+0xa04>
ffffffffc02013e4:	866ff0ef          	jal	ffffffffc020044a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02013e8:	00005697          	auipc	a3,0x5
ffffffffc02013ec:	03868693          	addi	a3,a3,56 # ffffffffc0206420 <etext+0xa7c>
ffffffffc02013f0:	00005617          	auipc	a2,0x5
ffffffffc02013f4:	fa060613          	addi	a2,a2,-96 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02013f8:	0d900593          	li	a1,217
ffffffffc02013fc:	00005517          	auipc	a0,0x5
ffffffffc0201400:	fac50513          	addi	a0,a0,-84 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201404:	846ff0ef          	jal	ffffffffc020044a <__panic>
    assert(count == 0);
ffffffffc0201408:	00005697          	auipc	a3,0x5
ffffffffc020140c:	2c068693          	addi	a3,a3,704 # ffffffffc02066c8 <etext+0xd24>
ffffffffc0201410:	00005617          	auipc	a2,0x5
ffffffffc0201414:	f8060613          	addi	a2,a2,-128 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201418:	14600593          	li	a1,326
ffffffffc020141c:	00005517          	auipc	a0,0x5
ffffffffc0201420:	f8c50513          	addi	a0,a0,-116 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201424:	826ff0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_free == 0);
ffffffffc0201428:	00005697          	auipc	a3,0x5
ffffffffc020142c:	14068693          	addi	a3,a3,320 # ffffffffc0206568 <etext+0xbc4>
ffffffffc0201430:	00005617          	auipc	a2,0x5
ffffffffc0201434:	f6060613          	addi	a2,a2,-160 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201438:	13a00593          	li	a1,314
ffffffffc020143c:	00005517          	auipc	a0,0x5
ffffffffc0201440:	f6c50513          	addi	a0,a0,-148 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201444:	806ff0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201448:	00005697          	auipc	a3,0x5
ffffffffc020144c:	0c068693          	addi	a3,a3,192 # ffffffffc0206508 <etext+0xb64>
ffffffffc0201450:	00005617          	auipc	a2,0x5
ffffffffc0201454:	f4060613          	addi	a2,a2,-192 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201458:	13800593          	li	a1,312
ffffffffc020145c:	00005517          	auipc	a0,0x5
ffffffffc0201460:	f4c50513          	addi	a0,a0,-180 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201464:	fe7fe0ef          	jal	ffffffffc020044a <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201468:	00005697          	auipc	a3,0x5
ffffffffc020146c:	06068693          	addi	a3,a3,96 # ffffffffc02064c8 <etext+0xb24>
ffffffffc0201470:	00005617          	auipc	a2,0x5
ffffffffc0201474:	f2060613          	addi	a2,a2,-224 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201478:	0df00593          	li	a1,223
ffffffffc020147c:	00005517          	auipc	a0,0x5
ffffffffc0201480:	f2c50513          	addi	a0,a0,-212 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201484:	fc7fe0ef          	jal	ffffffffc020044a <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201488:	00005697          	auipc	a3,0x5
ffffffffc020148c:	20068693          	addi	a3,a3,512 # ffffffffc0206688 <etext+0xce4>
ffffffffc0201490:	00005617          	auipc	a2,0x5
ffffffffc0201494:	f0060613          	addi	a2,a2,-256 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201498:	13200593          	li	a1,306
ffffffffc020149c:	00005517          	auipc	a0,0x5
ffffffffc02014a0:	f0c50513          	addi	a0,a0,-244 # ffffffffc02063a8 <etext+0xa04>
ffffffffc02014a4:	fa7fe0ef          	jal	ffffffffc020044a <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02014a8:	00005697          	auipc	a3,0x5
ffffffffc02014ac:	1c068693          	addi	a3,a3,448 # ffffffffc0206668 <etext+0xcc4>
ffffffffc02014b0:	00005617          	auipc	a2,0x5
ffffffffc02014b4:	ee060613          	addi	a2,a2,-288 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02014b8:	13000593          	li	a1,304
ffffffffc02014bc:	00005517          	auipc	a0,0x5
ffffffffc02014c0:	eec50513          	addi	a0,a0,-276 # ffffffffc02063a8 <etext+0xa04>
ffffffffc02014c4:	f87fe0ef          	jal	ffffffffc020044a <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02014c8:	00005697          	auipc	a3,0x5
ffffffffc02014cc:	17868693          	addi	a3,a3,376 # ffffffffc0206640 <etext+0xc9c>
ffffffffc02014d0:	00005617          	auipc	a2,0x5
ffffffffc02014d4:	ec060613          	addi	a2,a2,-320 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02014d8:	12e00593          	li	a1,302
ffffffffc02014dc:	00005517          	auipc	a0,0x5
ffffffffc02014e0:	ecc50513          	addi	a0,a0,-308 # ffffffffc02063a8 <etext+0xa04>
ffffffffc02014e4:	f67fe0ef          	jal	ffffffffc020044a <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02014e8:	00005697          	auipc	a3,0x5
ffffffffc02014ec:	13068693          	addi	a3,a3,304 # ffffffffc0206618 <etext+0xc74>
ffffffffc02014f0:	00005617          	auipc	a2,0x5
ffffffffc02014f4:	ea060613          	addi	a2,a2,-352 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02014f8:	12d00593          	li	a1,301
ffffffffc02014fc:	00005517          	auipc	a0,0x5
ffffffffc0201500:	eac50513          	addi	a0,a0,-340 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201504:	f47fe0ef          	jal	ffffffffc020044a <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201508:	00005697          	auipc	a3,0x5
ffffffffc020150c:	10068693          	addi	a3,a3,256 # ffffffffc0206608 <etext+0xc64>
ffffffffc0201510:	00005617          	auipc	a2,0x5
ffffffffc0201514:	e8060613          	addi	a2,a2,-384 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201518:	12800593          	li	a1,296
ffffffffc020151c:	00005517          	auipc	a0,0x5
ffffffffc0201520:	e8c50513          	addi	a0,a0,-372 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201524:	f27fe0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201528:	00005697          	auipc	a3,0x5
ffffffffc020152c:	fe068693          	addi	a3,a3,-32 # ffffffffc0206508 <etext+0xb64>
ffffffffc0201530:	00005617          	auipc	a2,0x5
ffffffffc0201534:	e6060613          	addi	a2,a2,-416 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201538:	12700593          	li	a1,295
ffffffffc020153c:	00005517          	auipc	a0,0x5
ffffffffc0201540:	e6c50513          	addi	a0,a0,-404 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201544:	f07fe0ef          	jal	ffffffffc020044a <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201548:	00005697          	auipc	a3,0x5
ffffffffc020154c:	0a068693          	addi	a3,a3,160 # ffffffffc02065e8 <etext+0xc44>
ffffffffc0201550:	00005617          	auipc	a2,0x5
ffffffffc0201554:	e4060613          	addi	a2,a2,-448 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201558:	12600593          	li	a1,294
ffffffffc020155c:	00005517          	auipc	a0,0x5
ffffffffc0201560:	e4c50513          	addi	a0,a0,-436 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201564:	ee7fe0ef          	jal	ffffffffc020044a <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201568:	00005697          	auipc	a3,0x5
ffffffffc020156c:	05068693          	addi	a3,a3,80 # ffffffffc02065b8 <etext+0xc14>
ffffffffc0201570:	00005617          	auipc	a2,0x5
ffffffffc0201574:	e2060613          	addi	a2,a2,-480 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201578:	12500593          	li	a1,293
ffffffffc020157c:	00005517          	auipc	a0,0x5
ffffffffc0201580:	e2c50513          	addi	a0,a0,-468 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201584:	ec7fe0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201588:	00005697          	auipc	a3,0x5
ffffffffc020158c:	01868693          	addi	a3,a3,24 # ffffffffc02065a0 <etext+0xbfc>
ffffffffc0201590:	00005617          	auipc	a2,0x5
ffffffffc0201594:	e0060613          	addi	a2,a2,-512 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201598:	12400593          	li	a1,292
ffffffffc020159c:	00005517          	auipc	a0,0x5
ffffffffc02015a0:	e0c50513          	addi	a0,a0,-500 # ffffffffc02063a8 <etext+0xa04>
ffffffffc02015a4:	ea7fe0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02015a8:	00005697          	auipc	a3,0x5
ffffffffc02015ac:	f6068693          	addi	a3,a3,-160 # ffffffffc0206508 <etext+0xb64>
ffffffffc02015b0:	00005617          	auipc	a2,0x5
ffffffffc02015b4:	de060613          	addi	a2,a2,-544 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02015b8:	11e00593          	li	a1,286
ffffffffc02015bc:	00005517          	auipc	a0,0x5
ffffffffc02015c0:	dec50513          	addi	a0,a0,-532 # ffffffffc02063a8 <etext+0xa04>
ffffffffc02015c4:	e87fe0ef          	jal	ffffffffc020044a <__panic>
    assert(!PageProperty(p0));
ffffffffc02015c8:	00005697          	auipc	a3,0x5
ffffffffc02015cc:	fc068693          	addi	a3,a3,-64 # ffffffffc0206588 <etext+0xbe4>
ffffffffc02015d0:	00005617          	auipc	a2,0x5
ffffffffc02015d4:	dc060613          	addi	a2,a2,-576 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02015d8:	11900593          	li	a1,281
ffffffffc02015dc:	00005517          	auipc	a0,0x5
ffffffffc02015e0:	dcc50513          	addi	a0,a0,-564 # ffffffffc02063a8 <etext+0xa04>
ffffffffc02015e4:	e67fe0ef          	jal	ffffffffc020044a <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02015e8:	00005697          	auipc	a3,0x5
ffffffffc02015ec:	0c068693          	addi	a3,a3,192 # ffffffffc02066a8 <etext+0xd04>
ffffffffc02015f0:	00005617          	auipc	a2,0x5
ffffffffc02015f4:	da060613          	addi	a2,a2,-608 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02015f8:	13700593          	li	a1,311
ffffffffc02015fc:	00005517          	auipc	a0,0x5
ffffffffc0201600:	dac50513          	addi	a0,a0,-596 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201604:	e47fe0ef          	jal	ffffffffc020044a <__panic>
    assert(total == 0);
ffffffffc0201608:	00005697          	auipc	a3,0x5
ffffffffc020160c:	0d068693          	addi	a3,a3,208 # ffffffffc02066d8 <etext+0xd34>
ffffffffc0201610:	00005617          	auipc	a2,0x5
ffffffffc0201614:	d8060613          	addi	a2,a2,-640 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201618:	14700593          	li	a1,327
ffffffffc020161c:	00005517          	auipc	a0,0x5
ffffffffc0201620:	d8c50513          	addi	a0,a0,-628 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201624:	e27fe0ef          	jal	ffffffffc020044a <__panic>
    assert(total == nr_free_pages());
ffffffffc0201628:	00005697          	auipc	a3,0x5
ffffffffc020162c:	d9868693          	addi	a3,a3,-616 # ffffffffc02063c0 <etext+0xa1c>
ffffffffc0201630:	00005617          	auipc	a2,0x5
ffffffffc0201634:	d6060613          	addi	a2,a2,-672 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201638:	11300593          	li	a1,275
ffffffffc020163c:	00005517          	auipc	a0,0x5
ffffffffc0201640:	d6c50513          	addi	a0,a0,-660 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201644:	e07fe0ef          	jal	ffffffffc020044a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201648:	00005697          	auipc	a3,0x5
ffffffffc020164c:	db868693          	addi	a3,a3,-584 # ffffffffc0206400 <etext+0xa5c>
ffffffffc0201650:	00005617          	auipc	a2,0x5
ffffffffc0201654:	d4060613          	addi	a2,a2,-704 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201658:	0d800593          	li	a1,216
ffffffffc020165c:	00005517          	auipc	a0,0x5
ffffffffc0201660:	d4c50513          	addi	a0,a0,-692 # ffffffffc02063a8 <etext+0xa04>
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
ffffffffc0201798:	00005697          	auipc	a3,0x5
ffffffffc020179c:	f5868693          	addi	a3,a3,-168 # ffffffffc02066f0 <etext+0xd4c>
ffffffffc02017a0:	00005617          	auipc	a2,0x5
ffffffffc02017a4:	bf060613          	addi	a2,a2,-1040 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02017a8:	09400593          	li	a1,148
ffffffffc02017ac:	00005517          	auipc	a0,0x5
ffffffffc02017b0:	bfc50513          	addi	a0,a0,-1028 # ffffffffc02063a8 <etext+0xa04>
ffffffffc02017b4:	c97fe0ef          	jal	ffffffffc020044a <__panic>
    assert(n > 0);
ffffffffc02017b8:	00005697          	auipc	a3,0x5
ffffffffc02017bc:	f3068693          	addi	a3,a3,-208 # ffffffffc02066e8 <etext+0xd44>
ffffffffc02017c0:	00005617          	auipc	a2,0x5
ffffffffc02017c4:	bd060613          	addi	a2,a2,-1072 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02017c8:	09000593          	li	a1,144
ffffffffc02017cc:	00005517          	auipc	a0,0x5
ffffffffc02017d0:	bdc50513          	addi	a0,a0,-1060 # ffffffffc02063a8 <etext+0xa04>
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
ffffffffc0201872:	e7a68693          	addi	a3,a3,-390 # ffffffffc02066e8 <etext+0xd44>
ffffffffc0201876:	00005617          	auipc	a2,0x5
ffffffffc020187a:	b1a60613          	addi	a2,a2,-1254 # ffffffffc0206390 <etext+0x9ec>
ffffffffc020187e:	06c00593          	li	a1,108
ffffffffc0201882:	00005517          	auipc	a0,0x5
ffffffffc0201886:	b2650513          	addi	a0,a0,-1242 # ffffffffc02063a8 <etext+0xa04>
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
ffffffffc0201948:	dd468693          	addi	a3,a3,-556 # ffffffffc0206718 <etext+0xd74>
ffffffffc020194c:	00005617          	auipc	a2,0x5
ffffffffc0201950:	a4460613          	addi	a2,a2,-1468 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201954:	04b00593          	li	a1,75
ffffffffc0201958:	00005517          	auipc	a0,0x5
ffffffffc020195c:	a5050513          	addi	a0,a0,-1456 # ffffffffc02063a8 <etext+0xa04>
ffffffffc0201960:	aebfe0ef          	jal	ffffffffc020044a <__panic>
    assert(n > 0);
ffffffffc0201964:	00005697          	auipc	a3,0x5
ffffffffc0201968:	d8468693          	addi	a3,a3,-636 # ffffffffc02066e8 <etext+0xd44>
ffffffffc020196c:	00005617          	auipc	a2,0x5
ffffffffc0201970:	a2460613          	addi	a2,a2,-1500 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201974:	04700593          	li	a1,71
ffffffffc0201978:	00005517          	auipc	a0,0x5
ffffffffc020197c:	a3050513          	addi	a0,a0,-1488 # ffffffffc02063a8 <etext+0xa04>
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
ffffffffc0201aae:	00006797          	auipc	a5,0x6
ffffffffc0201ab2:	78a7b783          	ld	a5,1930(a5) # ffffffffc0208238 <nbase>
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
ffffffffc0201ae6:	c5e60613          	addi	a2,a2,-930 # ffffffffc0206740 <etext+0xd9c>
ffffffffc0201aea:	07100593          	li	a1,113
ffffffffc0201aee:	00005517          	auipc	a0,0x5
ffffffffc0201af2:	c7a50513          	addi	a0,a0,-902 # ffffffffc0206768 <etext+0xdc4>
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
ffffffffc0201bc8:	bb468693          	addi	a3,a3,-1100 # ffffffffc0206778 <etext+0xdd4>
ffffffffc0201bcc:	00004617          	auipc	a2,0x4
ffffffffc0201bd0:	7c460613          	addi	a2,a2,1988 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0201bd4:	06300593          	li	a1,99
ffffffffc0201bd8:	00005517          	auipc	a0,0x5
ffffffffc0201bdc:	bc050513          	addi	a0,a0,-1088 # ffffffffc0206798 <etext+0xdf4>
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
ffffffffc0201bea:	bca50513          	addi	a0,a0,-1078 # ffffffffc02067b0 <etext+0xe0c>
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
ffffffffc0201bfa:	bd250513          	addi	a0,a0,-1070 # ffffffffc02067c8 <etext+0xe24>
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
ffffffffc0201d0e:	00006617          	auipc	a2,0x6
ffffffffc0201d12:	52a63603          	ld	a2,1322(a2) # ffffffffc0208238 <nbase>
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
ffffffffc0201d80:	a9460613          	addi	a2,a2,-1388 # ffffffffc0206810 <etext+0xe6c>
ffffffffc0201d84:	06900593          	li	a1,105
ffffffffc0201d88:	00005517          	auipc	a0,0x5
ffffffffc0201d8c:	9e050513          	addi	a0,a0,-1568 # ffffffffc0206768 <etext+0xdc4>
ffffffffc0201d90:	ebafe0ef          	jal	ffffffffc020044a <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201d94:	86aa                	mv	a3,a0
ffffffffc0201d96:	00005617          	auipc	a2,0x5
ffffffffc0201d9a:	a5260613          	addi	a2,a2,-1454 # ffffffffc02067e8 <etext+0xe44>
ffffffffc0201d9e:	07700593          	li	a1,119
ffffffffc0201da2:	00005517          	auipc	a0,0x5
ffffffffc0201da6:	9c650513          	addi	a0,a0,-1594 # ffffffffc0206768 <etext+0xdc4>
ffffffffc0201daa:	ea0fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201dae <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201dae:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201db0:	00005617          	auipc	a2,0x5
ffffffffc0201db4:	a6060613          	addi	a2,a2,-1440 # ffffffffc0206810 <etext+0xe6c>
ffffffffc0201db8:	06900593          	li	a1,105
ffffffffc0201dbc:	00005517          	auipc	a0,0x5
ffffffffc0201dc0:	9ac50513          	addi	a0,a0,-1620 # ffffffffc0206768 <etext+0xdc4>
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
ffffffffc0201f08:	273030ef          	jal	ffffffffc020597a <memset>
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
ffffffffc0201fbe:	1bd030ef          	jal	ffffffffc020597a <memset>
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
ffffffffc020206e:	00004617          	auipc	a2,0x4
ffffffffc0202072:	6d260613          	addi	a2,a2,1746 # ffffffffc0206740 <etext+0xd9c>
ffffffffc0202076:	0fa00593          	li	a1,250
ffffffffc020207a:	00004517          	auipc	a0,0x4
ffffffffc020207e:	7b650513          	addi	a0,a0,1974 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202082:	bc8fe0ef          	jal	ffffffffc020044a <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202086:	00004617          	auipc	a2,0x4
ffffffffc020208a:	6ba60613          	addi	a2,a2,1722 # ffffffffc0206740 <etext+0xd9c>
ffffffffc020208e:	0ed00593          	li	a1,237
ffffffffc0202092:	00004517          	auipc	a0,0x4
ffffffffc0202096:	79e50513          	addi	a0,a0,1950 # ffffffffc0206830 <etext+0xe8c>
ffffffffc020209a:	bb0fe0ef          	jal	ffffffffc020044a <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020209e:	86aa                	mv	a3,a0
ffffffffc02020a0:	00004617          	auipc	a2,0x4
ffffffffc02020a4:	6a060613          	addi	a2,a2,1696 # ffffffffc0206740 <etext+0xd9c>
ffffffffc02020a8:	0e900593          	li	a1,233
ffffffffc02020ac:	00004517          	auipc	a0,0x4
ffffffffc02020b0:	78450513          	addi	a0,a0,1924 # ffffffffc0206830 <etext+0xe8c>
ffffffffc02020b4:	b96fe0ef          	jal	ffffffffc020044a <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02020b8:	00004617          	auipc	a2,0x4
ffffffffc02020bc:	68860613          	addi	a2,a2,1672 # ffffffffc0206740 <etext+0xd9c>
ffffffffc02020c0:	0f700593          	li	a1,247
ffffffffc02020c4:	00004517          	auipc	a0,0x4
ffffffffc02020c8:	76c50513          	addi	a0,a0,1900 # ffffffffc0206830 <etext+0xe8c>
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
ffffffffc0202214:	00004697          	auipc	a3,0x4
ffffffffc0202218:	62c68693          	addi	a3,a3,1580 # ffffffffc0206840 <etext+0xe9c>
ffffffffc020221c:	00004617          	auipc	a2,0x4
ffffffffc0202220:	17460613          	addi	a2,a2,372 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202224:	12200593          	li	a1,290
ffffffffc0202228:	00004517          	auipc	a0,0x4
ffffffffc020222c:	60850513          	addi	a0,a0,1544 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202230:	a1afe0ef          	jal	ffffffffc020044a <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0202234:	00004697          	auipc	a3,0x4
ffffffffc0202238:	63c68693          	addi	a3,a3,1596 # ffffffffc0206870 <etext+0xecc>
ffffffffc020223c:	00004617          	auipc	a2,0x4
ffffffffc0202240:	15460613          	addi	a2,a2,340 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202244:	12300593          	li	a1,291
ffffffffc0202248:	00004517          	auipc	a0,0x4
ffffffffc020224c:	5e850513          	addi	a0,a0,1512 # ffffffffc0206830 <etext+0xe8c>
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
ffffffffc0202496:	00004697          	auipc	a3,0x4
ffffffffc020249a:	3aa68693          	addi	a3,a3,938 # ffffffffc0206840 <etext+0xe9c>
ffffffffc020249e:	00004617          	auipc	a2,0x4
ffffffffc02024a2:	ef260613          	addi	a2,a2,-270 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02024a6:	13700593          	li	a1,311
ffffffffc02024aa:	00004517          	auipc	a0,0x4
ffffffffc02024ae:	38650513          	addi	a0,a0,902 # ffffffffc0206830 <etext+0xe8c>
ffffffffc02024b2:	f99fd0ef          	jal	ffffffffc020044a <__panic>
    return KADDR(page2pa(page));
ffffffffc02024b6:	00004617          	auipc	a2,0x4
ffffffffc02024ba:	28a60613          	addi	a2,a2,650 # ffffffffc0206740 <etext+0xd9c>
ffffffffc02024be:	07100593          	li	a1,113
ffffffffc02024c2:	00004517          	auipc	a0,0x4
ffffffffc02024c6:	2a650513          	addi	a0,a0,678 # ffffffffc0206768 <etext+0xdc4>
ffffffffc02024ca:	f81fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02024ce:	86f2                	mv	a3,t3
ffffffffc02024d0:	00004617          	auipc	a2,0x4
ffffffffc02024d4:	27060613          	addi	a2,a2,624 # ffffffffc0206740 <etext+0xd9c>
ffffffffc02024d8:	07100593          	li	a1,113
ffffffffc02024dc:	00004517          	auipc	a0,0x4
ffffffffc02024e0:	28c50513          	addi	a0,a0,652 # ffffffffc0206768 <etext+0xdc4>
ffffffffc02024e4:	f67fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02024e8:	8c7ff0ef          	jal	ffffffffc0201dae <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc02024ec:	00004697          	auipc	a3,0x4
ffffffffc02024f0:	38468693          	addi	a3,a3,900 # ffffffffc0206870 <etext+0xecc>
ffffffffc02024f4:	00004617          	auipc	a2,0x4
ffffffffc02024f8:	e9c60613          	addi	a2,a2,-356 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02024fc:	13800593          	li	a1,312
ffffffffc0202500:	00004517          	auipc	a0,0x4
ffffffffc0202504:	33050513          	addi	a0,a0,816 # ffffffffc0206830 <etext+0xe8c>
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
ffffffffc020269e:	00005797          	auipc	a5,0x5
ffffffffc02026a2:	14278793          	addi	a5,a5,322 # ffffffffc02077e0 <default_pmm_manager>
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
ffffffffc02026c8:	00004517          	auipc	a0,0x4
ffffffffc02026cc:	1c050513          	addi	a0,a0,448 # ffffffffc0206888 <etext+0xee4>
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
ffffffffc0202700:	00004517          	auipc	a0,0x4
ffffffffc0202704:	1c050513          	addi	a0,a0,448 # ffffffffc02068c0 <etext+0xf1c>
ffffffffc0202708:	a91fd0ef          	jal	ffffffffc0200198 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc020270c:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202710:	864a                	mv	a2,s2
ffffffffc0202712:	85a6                	mv	a1,s1
ffffffffc0202714:	fff40693          	addi	a3,s0,-1
ffffffffc0202718:	00004517          	auipc	a0,0x4
ffffffffc020271c:	1c050513          	addi	a0,a0,448 # ffffffffc02068d8 <etext+0xf34>
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
ffffffffc020279c:	00004517          	auipc	a0,0x4
ffffffffc02027a0:	16450513          	addi	a0,a0,356 # ffffffffc0206900 <etext+0xf5c>
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
ffffffffc02027b8:	00004517          	auipc	a0,0x4
ffffffffc02027bc:	16050513          	addi	a0,a0,352 # ffffffffc0206918 <etext+0xf74>
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
ffffffffc0202a6a:	00004517          	auipc	a0,0x4
ffffffffc0202a6e:	1fe50513          	addi	a0,a0,510 # ffffffffc0206c68 <etext+0x12c4>
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
ffffffffc0202b2a:	00004597          	auipc	a1,0x4
ffffffffc0202b2e:	28658593          	addi	a1,a1,646 # ffffffffc0206db0 <etext+0x140c>
ffffffffc0202b32:	10000513          	li	a0,256
ffffffffc0202b36:	5c5020ef          	jal	ffffffffc02058fa <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202b3a:	6585                	lui	a1,0x1
ffffffffc0202b3c:	10058593          	addi	a1,a1,256 # 1100 <_binary_obj___user_softint_out_size-0x7e28>
ffffffffc0202b40:	10000513          	li	a0,256
ffffffffc0202b44:	5c9020ef          	jal	ffffffffc020590c <strcmp>
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
ffffffffc0202b78:	54f020ef          	jal	ffffffffc02058c6 <strlen>
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
ffffffffc0202c3c:	00004517          	auipc	a0,0x4
ffffffffc0202c40:	1ec50513          	addi	a0,a0,492 # ffffffffc0206e28 <etext+0x1484>
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
ffffffffc0202da6:	99e60613          	addi	a2,a2,-1634 # ffffffffc0206740 <etext+0xd9c>
ffffffffc0202daa:	25100593          	li	a1,593
ffffffffc0202dae:	00004517          	auipc	a0,0x4
ffffffffc0202db2:	a8250513          	addi	a0,a0,-1406 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202db6:	e94fd0ef          	jal	ffffffffc020044a <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202dba:	00004697          	auipc	a3,0x4
ffffffffc0202dbe:	f0e68693          	addi	a3,a3,-242 # ffffffffc0206cc8 <etext+0x1324>
ffffffffc0202dc2:	00003617          	auipc	a2,0x3
ffffffffc0202dc6:	5ce60613          	addi	a2,a2,1486 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202dca:	25200593          	li	a1,594
ffffffffc0202dce:	00004517          	auipc	a0,0x4
ffffffffc0202dd2:	a6250513          	addi	a0,a0,-1438 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202dd6:	e74fd0ef          	jal	ffffffffc020044a <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202dda:	00004697          	auipc	a3,0x4
ffffffffc0202dde:	eae68693          	addi	a3,a3,-338 # ffffffffc0206c88 <etext+0x12e4>
ffffffffc0202de2:	00003617          	auipc	a2,0x3
ffffffffc0202de6:	5ae60613          	addi	a2,a2,1454 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202dea:	25100593          	li	a1,593
ffffffffc0202dee:	00004517          	auipc	a0,0x4
ffffffffc0202df2:	a4250513          	addi	a0,a0,-1470 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202df6:	e54fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202dfa:	fb5fe0ef          	jal	ffffffffc0201dae <pa2page.part.0>
        panic("pte2page called with invalid pte");
ffffffffc0202dfe:	00004617          	auipc	a2,0x4
ffffffffc0202e02:	c2a60613          	addi	a2,a2,-982 # ffffffffc0206a28 <etext+0x1084>
ffffffffc0202e06:	07f00593          	li	a1,127
ffffffffc0202e0a:	00004517          	auipc	a0,0x4
ffffffffc0202e0e:	95e50513          	addi	a0,a0,-1698 # ffffffffc0206768 <etext+0xdc4>
ffffffffc0202e12:	e38fd0ef          	jal	ffffffffc020044a <__panic>
        panic("DTB memory info not available");
ffffffffc0202e16:	00004617          	auipc	a2,0x4
ffffffffc0202e1a:	a8a60613          	addi	a2,a2,-1398 # ffffffffc02068a0 <etext+0xefc>
ffffffffc0202e1e:	06500593          	li	a1,101
ffffffffc0202e22:	00004517          	auipc	a0,0x4
ffffffffc0202e26:	a0e50513          	addi	a0,a0,-1522 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202e2a:	e20fd0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202e2e:	00004697          	auipc	a3,0x4
ffffffffc0202e32:	e1268693          	addi	a3,a3,-494 # ffffffffc0206c40 <etext+0x129c>
ffffffffc0202e36:	00003617          	auipc	a2,0x3
ffffffffc0202e3a:	55a60613          	addi	a2,a2,1370 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202e3e:	26c00593          	li	a1,620
ffffffffc0202e42:	00004517          	auipc	a0,0x4
ffffffffc0202e46:	9ee50513          	addi	a0,a0,-1554 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202e4a:	e00fd0ef          	jal	ffffffffc020044a <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202e4e:	00004697          	auipc	a3,0x4
ffffffffc0202e52:	b0a68693          	addi	a3,a3,-1270 # ffffffffc0206958 <etext+0xfb4>
ffffffffc0202e56:	00003617          	auipc	a2,0x3
ffffffffc0202e5a:	53a60613          	addi	a2,a2,1338 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202e5e:	21300593          	li	a1,531
ffffffffc0202e62:	00004517          	auipc	a0,0x4
ffffffffc0202e66:	9ce50513          	addi	a0,a0,-1586 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202e6a:	de0fd0ef          	jal	ffffffffc020044a <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202e6e:	00004697          	auipc	a3,0x4
ffffffffc0202e72:	aca68693          	addi	a3,a3,-1334 # ffffffffc0206938 <etext+0xf94>
ffffffffc0202e76:	00003617          	auipc	a2,0x3
ffffffffc0202e7a:	51a60613          	addi	a2,a2,1306 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202e7e:	21200593          	li	a1,530
ffffffffc0202e82:	00004517          	auipc	a0,0x4
ffffffffc0202e86:	9ae50513          	addi	a0,a0,-1618 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202e8a:	dc0fd0ef          	jal	ffffffffc020044a <__panic>
    return KADDR(page2pa(page));
ffffffffc0202e8e:	00004617          	auipc	a2,0x4
ffffffffc0202e92:	8b260613          	addi	a2,a2,-1870 # ffffffffc0206740 <etext+0xd9c>
ffffffffc0202e96:	07100593          	li	a1,113
ffffffffc0202e9a:	00004517          	auipc	a0,0x4
ffffffffc0202e9e:	8ce50513          	addi	a0,a0,-1842 # ffffffffc0206768 <etext+0xdc4>
ffffffffc0202ea2:	da8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202ea6:	00004697          	auipc	a3,0x4
ffffffffc0202eaa:	d6a68693          	addi	a3,a3,-662 # ffffffffc0206c10 <etext+0x126c>
ffffffffc0202eae:	00003617          	auipc	a2,0x3
ffffffffc0202eb2:	4e260613          	addi	a2,a2,1250 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202eb6:	23a00593          	li	a1,570
ffffffffc0202eba:	00004517          	auipc	a0,0x4
ffffffffc0202ebe:	97650513          	addi	a0,a0,-1674 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202ec2:	d88fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202ec6:	00004697          	auipc	a3,0x4
ffffffffc0202eca:	d0268693          	addi	a3,a3,-766 # ffffffffc0206bc8 <etext+0x1224>
ffffffffc0202ece:	00003617          	auipc	a2,0x3
ffffffffc0202ed2:	4c260613          	addi	a2,a2,1218 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202ed6:	23800593          	li	a1,568
ffffffffc0202eda:	00004517          	auipc	a0,0x4
ffffffffc0202ede:	95650513          	addi	a0,a0,-1706 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202ee2:	d68fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202ee6:	00004697          	auipc	a3,0x4
ffffffffc0202eea:	d1268693          	addi	a3,a3,-750 # ffffffffc0206bf8 <etext+0x1254>
ffffffffc0202eee:	00003617          	auipc	a2,0x3
ffffffffc0202ef2:	4a260613          	addi	a2,a2,1186 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202ef6:	23700593          	li	a1,567
ffffffffc0202efa:	00004517          	auipc	a0,0x4
ffffffffc0202efe:	93650513          	addi	a0,a0,-1738 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202f02:	d48fd0ef          	jal	ffffffffc020044a <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202f06:	00004697          	auipc	a3,0x4
ffffffffc0202f0a:	dda68693          	addi	a3,a3,-550 # ffffffffc0206ce0 <etext+0x133c>
ffffffffc0202f0e:	00003617          	auipc	a2,0x3
ffffffffc0202f12:	48260613          	addi	a2,a2,1154 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202f16:	25500593          	li	a1,597
ffffffffc0202f1a:	00004517          	auipc	a0,0x4
ffffffffc0202f1e:	91650513          	addi	a0,a0,-1770 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202f22:	d28fd0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202f26:	00004697          	auipc	a3,0x4
ffffffffc0202f2a:	d1a68693          	addi	a3,a3,-742 # ffffffffc0206c40 <etext+0x129c>
ffffffffc0202f2e:	00003617          	auipc	a2,0x3
ffffffffc0202f32:	46260613          	addi	a2,a2,1122 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202f36:	24200593          	li	a1,578
ffffffffc0202f3a:	00004517          	auipc	a0,0x4
ffffffffc0202f3e:	8f650513          	addi	a0,a0,-1802 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202f42:	d08fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202f46:	00004697          	auipc	a3,0x4
ffffffffc0202f4a:	df268693          	addi	a3,a3,-526 # ffffffffc0206d38 <etext+0x1394>
ffffffffc0202f4e:	00003617          	auipc	a2,0x3
ffffffffc0202f52:	44260613          	addi	a2,a2,1090 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202f56:	25a00593          	li	a1,602
ffffffffc0202f5a:	00004517          	auipc	a0,0x4
ffffffffc0202f5e:	8d650513          	addi	a0,a0,-1834 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202f62:	ce8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202f66:	00004697          	auipc	a3,0x4
ffffffffc0202f6a:	d9268693          	addi	a3,a3,-622 # ffffffffc0206cf8 <etext+0x1354>
ffffffffc0202f6e:	00003617          	auipc	a2,0x3
ffffffffc0202f72:	42260613          	addi	a2,a2,1058 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202f76:	25900593          	li	a1,601
ffffffffc0202f7a:	00004517          	auipc	a0,0x4
ffffffffc0202f7e:	8b650513          	addi	a0,a0,-1866 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202f82:	cc8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202f86:	00004697          	auipc	a3,0x4
ffffffffc0202f8a:	c4268693          	addi	a3,a3,-958 # ffffffffc0206bc8 <etext+0x1224>
ffffffffc0202f8e:	00003617          	auipc	a2,0x3
ffffffffc0202f92:	40260613          	addi	a2,a2,1026 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202f96:	23400593          	li	a1,564
ffffffffc0202f9a:	00004517          	auipc	a0,0x4
ffffffffc0202f9e:	89650513          	addi	a0,a0,-1898 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202fa2:	ca8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202fa6:	00004697          	auipc	a3,0x4
ffffffffc0202faa:	ac268693          	addi	a3,a3,-1342 # ffffffffc0206a68 <etext+0x10c4>
ffffffffc0202fae:	00003617          	auipc	a2,0x3
ffffffffc0202fb2:	3e260613          	addi	a2,a2,994 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202fb6:	23300593          	li	a1,563
ffffffffc0202fba:	00004517          	auipc	a0,0x4
ffffffffc0202fbe:	87650513          	addi	a0,a0,-1930 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202fc2:	c88fd0ef          	jal	ffffffffc020044a <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202fc6:	00004697          	auipc	a3,0x4
ffffffffc0202fca:	c1a68693          	addi	a3,a3,-998 # ffffffffc0206be0 <etext+0x123c>
ffffffffc0202fce:	00003617          	auipc	a2,0x3
ffffffffc0202fd2:	3c260613          	addi	a2,a2,962 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202fd6:	23000593          	li	a1,560
ffffffffc0202fda:	00004517          	auipc	a0,0x4
ffffffffc0202fde:	85650513          	addi	a0,a0,-1962 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0202fe2:	c68fd0ef          	jal	ffffffffc020044a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202fe6:	00004697          	auipc	a3,0x4
ffffffffc0202fea:	a6a68693          	addi	a3,a3,-1430 # ffffffffc0206a50 <etext+0x10ac>
ffffffffc0202fee:	00003617          	auipc	a2,0x3
ffffffffc0202ff2:	3a260613          	addi	a2,a2,930 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0202ff6:	22f00593          	li	a1,559
ffffffffc0202ffa:	00004517          	auipc	a0,0x4
ffffffffc0202ffe:	83650513          	addi	a0,a0,-1994 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0203002:	c48fd0ef          	jal	ffffffffc020044a <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203006:	00004697          	auipc	a3,0x4
ffffffffc020300a:	aea68693          	addi	a3,a3,-1302 # ffffffffc0206af0 <etext+0x114c>
ffffffffc020300e:	00003617          	auipc	a2,0x3
ffffffffc0203012:	38260613          	addi	a2,a2,898 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203016:	22e00593          	li	a1,558
ffffffffc020301a:	00004517          	auipc	a0,0x4
ffffffffc020301e:	81650513          	addi	a0,a0,-2026 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0203022:	c28fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203026:	00004697          	auipc	a3,0x4
ffffffffc020302a:	ba268693          	addi	a3,a3,-1118 # ffffffffc0206bc8 <etext+0x1224>
ffffffffc020302e:	00003617          	auipc	a2,0x3
ffffffffc0203032:	36260613          	addi	a2,a2,866 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203036:	22d00593          	li	a1,557
ffffffffc020303a:	00003517          	auipc	a0,0x3
ffffffffc020303e:	7f650513          	addi	a0,a0,2038 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0203042:	c08fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0203046:	00004697          	auipc	a3,0x4
ffffffffc020304a:	b6a68693          	addi	a3,a3,-1174 # ffffffffc0206bb0 <etext+0x120c>
ffffffffc020304e:	00003617          	auipc	a2,0x3
ffffffffc0203052:	34260613          	addi	a2,a2,834 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203056:	22c00593          	li	a1,556
ffffffffc020305a:	00003517          	auipc	a0,0x3
ffffffffc020305e:	7d650513          	addi	a0,a0,2006 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0203062:	be8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0203066:	00004697          	auipc	a3,0x4
ffffffffc020306a:	b1a68693          	addi	a3,a3,-1254 # ffffffffc0206b80 <etext+0x11dc>
ffffffffc020306e:	00003617          	auipc	a2,0x3
ffffffffc0203072:	32260613          	addi	a2,a2,802 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203076:	22b00593          	li	a1,555
ffffffffc020307a:	00003517          	auipc	a0,0x3
ffffffffc020307e:	7b650513          	addi	a0,a0,1974 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0203082:	bc8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0203086:	00004697          	auipc	a3,0x4
ffffffffc020308a:	ae268693          	addi	a3,a3,-1310 # ffffffffc0206b68 <etext+0x11c4>
ffffffffc020308e:	00003617          	auipc	a2,0x3
ffffffffc0203092:	30260613          	addi	a2,a2,770 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203096:	22900593          	li	a1,553
ffffffffc020309a:	00003517          	auipc	a0,0x3
ffffffffc020309e:	79650513          	addi	a0,a0,1942 # ffffffffc0206830 <etext+0xe8c>
ffffffffc02030a2:	ba8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02030a6:	00004697          	auipc	a3,0x4
ffffffffc02030aa:	aa268693          	addi	a3,a3,-1374 # ffffffffc0206b48 <etext+0x11a4>
ffffffffc02030ae:	00003617          	auipc	a2,0x3
ffffffffc02030b2:	2e260613          	addi	a2,a2,738 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02030b6:	22800593          	li	a1,552
ffffffffc02030ba:	00003517          	auipc	a0,0x3
ffffffffc02030be:	77650513          	addi	a0,a0,1910 # ffffffffc0206830 <etext+0xe8c>
ffffffffc02030c2:	b88fd0ef          	jal	ffffffffc020044a <__panic>
    assert(*ptep & PTE_W);
ffffffffc02030c6:	00004697          	auipc	a3,0x4
ffffffffc02030ca:	a7268693          	addi	a3,a3,-1422 # ffffffffc0206b38 <etext+0x1194>
ffffffffc02030ce:	00003617          	auipc	a2,0x3
ffffffffc02030d2:	2c260613          	addi	a2,a2,706 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02030d6:	22700593          	li	a1,551
ffffffffc02030da:	00003517          	auipc	a0,0x3
ffffffffc02030de:	75650513          	addi	a0,a0,1878 # ffffffffc0206830 <etext+0xe8c>
ffffffffc02030e2:	b68fd0ef          	jal	ffffffffc020044a <__panic>
    assert(*ptep & PTE_U);
ffffffffc02030e6:	00004697          	auipc	a3,0x4
ffffffffc02030ea:	a4268693          	addi	a3,a3,-1470 # ffffffffc0206b28 <etext+0x1184>
ffffffffc02030ee:	00003617          	auipc	a2,0x3
ffffffffc02030f2:	2a260613          	addi	a2,a2,674 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02030f6:	22600593          	li	a1,550
ffffffffc02030fa:	00003517          	auipc	a0,0x3
ffffffffc02030fe:	73650513          	addi	a0,a0,1846 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0203102:	b48fd0ef          	jal	ffffffffc020044a <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203106:	00003617          	auipc	a2,0x3
ffffffffc020310a:	6e260613          	addi	a2,a2,1762 # ffffffffc02067e8 <etext+0xe44>
ffffffffc020310e:	08100593          	li	a1,129
ffffffffc0203112:	00003517          	auipc	a0,0x3
ffffffffc0203116:	71e50513          	addi	a0,a0,1822 # ffffffffc0206830 <etext+0xe8c>
ffffffffc020311a:	b30fd0ef          	jal	ffffffffc020044a <__panic>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020311e:	00004697          	auipc	a3,0x4
ffffffffc0203122:	96268693          	addi	a3,a3,-1694 # ffffffffc0206a80 <etext+0x10dc>
ffffffffc0203126:	00003617          	auipc	a2,0x3
ffffffffc020312a:	26a60613          	addi	a2,a2,618 # ffffffffc0206390 <etext+0x9ec>
ffffffffc020312e:	22100593          	li	a1,545
ffffffffc0203132:	00003517          	auipc	a0,0x3
ffffffffc0203136:	6fe50513          	addi	a0,a0,1790 # ffffffffc0206830 <etext+0xe8c>
ffffffffc020313a:	b10fd0ef          	jal	ffffffffc020044a <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020313e:	00004697          	auipc	a3,0x4
ffffffffc0203142:	9b268693          	addi	a3,a3,-1614 # ffffffffc0206af0 <etext+0x114c>
ffffffffc0203146:	00003617          	auipc	a2,0x3
ffffffffc020314a:	24a60613          	addi	a2,a2,586 # ffffffffc0206390 <etext+0x9ec>
ffffffffc020314e:	22500593          	li	a1,549
ffffffffc0203152:	00003517          	auipc	a0,0x3
ffffffffc0203156:	6de50513          	addi	a0,a0,1758 # ffffffffc0206830 <etext+0xe8c>
ffffffffc020315a:	af0fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020315e:	00004697          	auipc	a3,0x4
ffffffffc0203162:	95268693          	addi	a3,a3,-1710 # ffffffffc0206ab0 <etext+0x110c>
ffffffffc0203166:	00003617          	auipc	a2,0x3
ffffffffc020316a:	22a60613          	addi	a2,a2,554 # ffffffffc0206390 <etext+0x9ec>
ffffffffc020316e:	22400593          	li	a1,548
ffffffffc0203172:	00003517          	auipc	a0,0x3
ffffffffc0203176:	6be50513          	addi	a0,a0,1726 # ffffffffc0206830 <etext+0xe8c>
ffffffffc020317a:	ad0fd0ef          	jal	ffffffffc020044a <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020317e:	86d6                	mv	a3,s5
ffffffffc0203180:	00003617          	auipc	a2,0x3
ffffffffc0203184:	5c060613          	addi	a2,a2,1472 # ffffffffc0206740 <etext+0xd9c>
ffffffffc0203188:	22000593          	li	a1,544
ffffffffc020318c:	00003517          	auipc	a0,0x3
ffffffffc0203190:	6a450513          	addi	a0,a0,1700 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0203194:	ab6fd0ef          	jal	ffffffffc020044a <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0203198:	00003617          	auipc	a2,0x3
ffffffffc020319c:	5a860613          	addi	a2,a2,1448 # ffffffffc0206740 <etext+0xd9c>
ffffffffc02031a0:	21f00593          	li	a1,543
ffffffffc02031a4:	00003517          	auipc	a0,0x3
ffffffffc02031a8:	68c50513          	addi	a0,a0,1676 # ffffffffc0206830 <etext+0xe8c>
ffffffffc02031ac:	a9efd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02031b0:	00004697          	auipc	a3,0x4
ffffffffc02031b4:	8b868693          	addi	a3,a3,-1864 # ffffffffc0206a68 <etext+0x10c4>
ffffffffc02031b8:	00003617          	auipc	a2,0x3
ffffffffc02031bc:	1d860613          	addi	a2,a2,472 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02031c0:	21d00593          	li	a1,541
ffffffffc02031c4:	00003517          	auipc	a0,0x3
ffffffffc02031c8:	66c50513          	addi	a0,a0,1644 # ffffffffc0206830 <etext+0xe8c>
ffffffffc02031cc:	a7efd0ef          	jal	ffffffffc020044a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02031d0:	00004697          	auipc	a3,0x4
ffffffffc02031d4:	88068693          	addi	a3,a3,-1920 # ffffffffc0206a50 <etext+0x10ac>
ffffffffc02031d8:	00003617          	auipc	a2,0x3
ffffffffc02031dc:	1b860613          	addi	a2,a2,440 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02031e0:	21c00593          	li	a1,540
ffffffffc02031e4:	00003517          	auipc	a0,0x3
ffffffffc02031e8:	64c50513          	addi	a0,a0,1612 # ffffffffc0206830 <etext+0xe8c>
ffffffffc02031ec:	a5efd0ef          	jal	ffffffffc020044a <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02031f0:	00004697          	auipc	a3,0x4
ffffffffc02031f4:	c1068693          	addi	a3,a3,-1008 # ffffffffc0206e00 <etext+0x145c>
ffffffffc02031f8:	00003617          	auipc	a2,0x3
ffffffffc02031fc:	19860613          	addi	a2,a2,408 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203200:	26300593          	li	a1,611
ffffffffc0203204:	00003517          	auipc	a0,0x3
ffffffffc0203208:	62c50513          	addi	a0,a0,1580 # ffffffffc0206830 <etext+0xe8c>
ffffffffc020320c:	a3efd0ef          	jal	ffffffffc020044a <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203210:	00004697          	auipc	a3,0x4
ffffffffc0203214:	bb868693          	addi	a3,a3,-1096 # ffffffffc0206dc8 <etext+0x1424>
ffffffffc0203218:	00003617          	auipc	a2,0x3
ffffffffc020321c:	17860613          	addi	a2,a2,376 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203220:	26000593          	li	a1,608
ffffffffc0203224:	00003517          	auipc	a0,0x3
ffffffffc0203228:	60c50513          	addi	a0,a0,1548 # ffffffffc0206830 <etext+0xe8c>
ffffffffc020322c:	a1efd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203230:	00004697          	auipc	a3,0x4
ffffffffc0203234:	b6868693          	addi	a3,a3,-1176 # ffffffffc0206d98 <etext+0x13f4>
ffffffffc0203238:	00003617          	auipc	a2,0x3
ffffffffc020323c:	15860613          	addi	a2,a2,344 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203240:	25c00593          	li	a1,604
ffffffffc0203244:	00003517          	auipc	a0,0x3
ffffffffc0203248:	5ec50513          	addi	a0,a0,1516 # ffffffffc0206830 <etext+0xe8c>
ffffffffc020324c:	9fefd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203250:	00004697          	auipc	a3,0x4
ffffffffc0203254:	b0068693          	addi	a3,a3,-1280 # ffffffffc0206d50 <etext+0x13ac>
ffffffffc0203258:	00003617          	auipc	a2,0x3
ffffffffc020325c:	13860613          	addi	a2,a2,312 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203260:	25b00593          	li	a1,603
ffffffffc0203264:	00003517          	auipc	a0,0x3
ffffffffc0203268:	5cc50513          	addi	a0,a0,1484 # ffffffffc0206830 <etext+0xe8c>
ffffffffc020326c:	9defd0ef          	jal	ffffffffc020044a <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0203270:	00003697          	auipc	a3,0x3
ffffffffc0203274:	72868693          	addi	a3,a3,1832 # ffffffffc0206998 <etext+0xff4>
ffffffffc0203278:	00003617          	auipc	a2,0x3
ffffffffc020327c:	11860613          	addi	a2,a2,280 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203280:	21400593          	li	a1,532
ffffffffc0203284:	00003517          	auipc	a0,0x3
ffffffffc0203288:	5ac50513          	addi	a0,a0,1452 # ffffffffc0206830 <etext+0xe8c>
ffffffffc020328c:	9befd0ef          	jal	ffffffffc020044a <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0203290:	00003617          	auipc	a2,0x3
ffffffffc0203294:	55860613          	addi	a2,a2,1368 # ffffffffc02067e8 <etext+0xe44>
ffffffffc0203298:	0c900593          	li	a1,201
ffffffffc020329c:	00003517          	auipc	a0,0x3
ffffffffc02032a0:	59450513          	addi	a0,a0,1428 # ffffffffc0206830 <etext+0xe8c>
ffffffffc02032a4:	9a6fd0ef          	jal	ffffffffc020044a <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02032a8:	00003697          	auipc	a3,0x3
ffffffffc02032ac:	75068693          	addi	a3,a3,1872 # ffffffffc02069f8 <etext+0x1054>
ffffffffc02032b0:	00003617          	auipc	a2,0x3
ffffffffc02032b4:	0e060613          	addi	a2,a2,224 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02032b8:	21b00593          	li	a1,539
ffffffffc02032bc:	00003517          	auipc	a0,0x3
ffffffffc02032c0:	57450513          	addi	a0,a0,1396 # ffffffffc0206830 <etext+0xe8c>
ffffffffc02032c4:	986fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02032c8:	00003697          	auipc	a3,0x3
ffffffffc02032cc:	70068693          	addi	a3,a3,1792 # ffffffffc02069c8 <etext+0x1024>
ffffffffc02032d0:	00003617          	auipc	a2,0x3
ffffffffc02032d4:	0c060613          	addi	a2,a2,192 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02032d8:	21800593          	li	a1,536
ffffffffc02032dc:	00003517          	auipc	a0,0x3
ffffffffc02032e0:	55450513          	addi	a0,a0,1364 # ffffffffc0206830 <etext+0xe8c>
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
ffffffffc0203420:	56c020ef          	jal	ffffffffc020598c <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc0203424:	01f9f693          	andi	a3,s3,31
ffffffffc0203428:	85ee                	mv	a1,s11
ffffffffc020342a:	8622                	mv	a2,s0
ffffffffc020342c:	855e                	mv	a0,s7
ffffffffc020342e:	97aff0ef          	jal	ffffffffc02025a8 <page_insert>
            assert(ret == 0);
ffffffffc0203432:	dd05                	beqz	a0,ffffffffc020336a <copy_range+0x82>
ffffffffc0203434:	00004697          	auipc	a3,0x4
ffffffffc0203438:	a3468693          	addi	a3,a3,-1484 # ffffffffc0206e68 <etext+0x14c4>
ffffffffc020343c:	00003617          	auipc	a2,0x3
ffffffffc0203440:	f5460613          	addi	a2,a2,-172 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203444:	1b000593          	li	a1,432
ffffffffc0203448:	00003517          	auipc	a0,0x3
ffffffffc020344c:	3e850513          	addi	a0,a0,1000 # ffffffffc0206830 <etext+0xe8c>
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
ffffffffc0203482:	00003617          	auipc	a2,0x3
ffffffffc0203486:	2be60613          	addi	a2,a2,702 # ffffffffc0206740 <etext+0xd9c>
ffffffffc020348a:	07100593          	li	a1,113
ffffffffc020348e:	00003517          	auipc	a0,0x3
ffffffffc0203492:	2da50513          	addi	a0,a0,730 # ffffffffc0206768 <etext+0xdc4>
ffffffffc0203496:	fb5fc0ef          	jal	ffffffffc020044a <__panic>
            assert(npage != NULL);
ffffffffc020349a:	00004697          	auipc	a3,0x4
ffffffffc020349e:	9be68693          	addi	a3,a3,-1602 # ffffffffc0206e58 <etext+0x14b4>
ffffffffc02034a2:	00003617          	auipc	a2,0x3
ffffffffc02034a6:	eee60613          	addi	a2,a2,-274 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02034aa:	19700593          	li	a1,407
ffffffffc02034ae:	00003517          	auipc	a0,0x3
ffffffffc02034b2:	38250513          	addi	a0,a0,898 # ffffffffc0206830 <etext+0xe8c>
ffffffffc02034b6:	f95fc0ef          	jal	ffffffffc020044a <__panic>
            assert(page != NULL);
ffffffffc02034ba:	00004697          	auipc	a3,0x4
ffffffffc02034be:	98e68693          	addi	a3,a3,-1650 # ffffffffc0206e48 <etext+0x14a4>
ffffffffc02034c2:	00003617          	auipc	a2,0x3
ffffffffc02034c6:	ece60613          	addi	a2,a2,-306 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02034ca:	19600593          	li	a1,406
ffffffffc02034ce:	00003517          	auipc	a0,0x3
ffffffffc02034d2:	36250513          	addi	a0,a0,866 # ffffffffc0206830 <etext+0xe8c>
ffffffffc02034d6:	f75fc0ef          	jal	ffffffffc020044a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02034da:	00003617          	auipc	a2,0x3
ffffffffc02034de:	33660613          	addi	a2,a2,822 # ffffffffc0206810 <etext+0xe6c>
ffffffffc02034e2:	06900593          	li	a1,105
ffffffffc02034e6:	00003517          	auipc	a0,0x3
ffffffffc02034ea:	28250513          	addi	a0,a0,642 # ffffffffc0206768 <etext+0xdc4>
ffffffffc02034ee:	f5dfc0ef          	jal	ffffffffc020044a <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02034f2:	00003617          	auipc	a2,0x3
ffffffffc02034f6:	53660613          	addi	a2,a2,1334 # ffffffffc0206a28 <etext+0x1084>
ffffffffc02034fa:	07f00593          	li	a1,127
ffffffffc02034fe:	00003517          	auipc	a0,0x3
ffffffffc0203502:	26a50513          	addi	a0,a0,618 # ffffffffc0206768 <etext+0xdc4>
ffffffffc0203506:	f45fc0ef          	jal	ffffffffc020044a <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020350a:	00003697          	auipc	a3,0x3
ffffffffc020350e:	36668693          	addi	a3,a3,870 # ffffffffc0206870 <etext+0xecc>
ffffffffc0203512:	00003617          	auipc	a2,0x3
ffffffffc0203516:	e7e60613          	addi	a2,a2,-386 # ffffffffc0206390 <etext+0x9ec>
ffffffffc020351a:	17e00593          	li	a1,382
ffffffffc020351e:	00003517          	auipc	a0,0x3
ffffffffc0203522:	31250513          	addi	a0,a0,786 # ffffffffc0206830 <etext+0xe8c>
ffffffffc0203526:	f25fc0ef          	jal	ffffffffc020044a <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020352a:	00003697          	auipc	a3,0x3
ffffffffc020352e:	31668693          	addi	a3,a3,790 # ffffffffc0206840 <etext+0xe9c>
ffffffffc0203532:	00003617          	auipc	a2,0x3
ffffffffc0203536:	e5e60613          	addi	a2,a2,-418 # ffffffffc0206390 <etext+0x9ec>
ffffffffc020353a:	17d00593          	li	a1,381
ffffffffc020353e:	00003517          	auipc	a0,0x3
ffffffffc0203542:	2f250513          	addi	a0,a0,754 # ffffffffc0206830 <etext+0xe8c>
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
ffffffffc0203596:	8e668693          	addi	a3,a3,-1818 # ffffffffc0206e78 <etext+0x14d4>
ffffffffc020359a:	00003617          	auipc	a2,0x3
ffffffffc020359e:	df660613          	addi	a2,a2,-522 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02035a2:	1f900593          	li	a1,505
ffffffffc02035a6:	00003517          	auipc	a0,0x3
ffffffffc02035aa:	28a50513          	addi	a0,a0,650 # ffffffffc0206830 <etext+0xe8c>
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
ffffffffc020360e:	88668693          	addi	a3,a3,-1914 # ffffffffc0206e90 <etext+0x14ec>
ffffffffc0203612:	00003617          	auipc	a2,0x3
ffffffffc0203616:	d7e60613          	addi	a2,a2,-642 # ffffffffc0206390 <etext+0x9ec>
ffffffffc020361a:	07400593          	li	a1,116
ffffffffc020361e:	00004517          	auipc	a0,0x4
ffffffffc0203622:	89250513          	addi	a0,a0,-1902 # ffffffffc0206eb0 <etext+0x150c>
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
ffffffffc020370a:	00003697          	auipc	a3,0x3
ffffffffc020370e:	7b668693          	addi	a3,a3,1974 # ffffffffc0206ec0 <etext+0x151c>
ffffffffc0203712:	00003617          	auipc	a2,0x3
ffffffffc0203716:	c7e60613          	addi	a2,a2,-898 # ffffffffc0206390 <etext+0x9ec>
ffffffffc020371a:	07a00593          	li	a1,122
ffffffffc020371e:	00003517          	auipc	a0,0x3
ffffffffc0203722:	79250513          	addi	a0,a0,1938 # ffffffffc0206eb0 <etext+0x150c>
ffffffffc0203726:	d25fc0ef          	jal	ffffffffc020044a <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020372a:	00003697          	auipc	a3,0x3
ffffffffc020372e:	7d668693          	addi	a3,a3,2006 # ffffffffc0206f00 <etext+0x155c>
ffffffffc0203732:	00003617          	auipc	a2,0x3
ffffffffc0203736:	c5e60613          	addi	a2,a2,-930 # ffffffffc0206390 <etext+0x9ec>
ffffffffc020373a:	07300593          	li	a1,115
ffffffffc020373e:	00003517          	auipc	a0,0x3
ffffffffc0203742:	77250513          	addi	a0,a0,1906 # ffffffffc0206eb0 <etext+0x150c>
ffffffffc0203746:	d05fc0ef          	jal	ffffffffc020044a <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc020374a:	00003697          	auipc	a3,0x3
ffffffffc020374e:	79668693          	addi	a3,a3,1942 # ffffffffc0206ee0 <etext+0x153c>
ffffffffc0203752:	00003617          	auipc	a2,0x3
ffffffffc0203756:	c3e60613          	addi	a2,a2,-962 # ffffffffc0206390 <etext+0x9ec>
ffffffffc020375a:	07200593          	li	a1,114
ffffffffc020375e:	00003517          	auipc	a0,0x3
ffffffffc0203762:	75250513          	addi	a0,a0,1874 # ffffffffc0206eb0 <etext+0x150c>
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
ffffffffc020379c:	00003697          	auipc	a3,0x3
ffffffffc02037a0:	78468693          	addi	a3,a3,1924 # ffffffffc0206f20 <etext+0x157c>
ffffffffc02037a4:	00003617          	auipc	a2,0x3
ffffffffc02037a8:	bec60613          	addi	a2,a2,-1044 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02037ac:	09e00593          	li	a1,158
ffffffffc02037b0:	00003517          	auipc	a0,0x3
ffffffffc02037b4:	70050513          	addi	a0,a0,1792 # ffffffffc0206eb0 <etext+0x150c>
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
ffffffffc0203868:	00003697          	auipc	a3,0x3
ffffffffc020386c:	6d068693          	addi	a3,a3,1744 # ffffffffc0206f38 <etext+0x1594>
ffffffffc0203870:	00003617          	auipc	a2,0x3
ffffffffc0203874:	b2060613          	addi	a2,a2,-1248 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203878:	0b300593          	li	a1,179
ffffffffc020387c:	00003517          	auipc	a0,0x3
ffffffffc0203880:	63450513          	addi	a0,a0,1588 # ffffffffc0206eb0 <etext+0x150c>
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
ffffffffc0203900:	00003697          	auipc	a3,0x3
ffffffffc0203904:	64868693          	addi	a3,a3,1608 # ffffffffc0206f48 <etext+0x15a4>
ffffffffc0203908:	00003617          	auipc	a2,0x3
ffffffffc020390c:	a8860613          	addi	a2,a2,-1400 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203910:	0cf00593          	li	a1,207
ffffffffc0203914:	00003517          	auipc	a0,0x3
ffffffffc0203918:	59c50513          	addi	a0,a0,1436 # ffffffffc0206eb0 <etext+0x150c>
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
ffffffffc0203976:	00003697          	auipc	a3,0x3
ffffffffc020397a:	5f268693          	addi	a3,a3,1522 # ffffffffc0206f68 <etext+0x15c4>
ffffffffc020397e:	00003617          	auipc	a2,0x3
ffffffffc0203982:	a1260613          	addi	a2,a2,-1518 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203986:	0e800593          	li	a1,232
ffffffffc020398a:	00003517          	auipc	a0,0x3
ffffffffc020398e:	52650513          	addi	a0,a0,1318 # ffffffffc0206eb0 <etext+0x150c>
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
ffffffffc0203ade:	00003517          	auipc	a0,0x3
ffffffffc0203ae2:	5fa50513          	addi	a0,a0,1530 # ffffffffc02070d8 <etext+0x1734>
ffffffffc0203ae6:	eb2fc0ef          	jal	ffffffffc0200198 <cprintf>
}
ffffffffc0203aea:	7402                	ld	s0,32(sp)
ffffffffc0203aec:	70a2                	ld	ra,40(sp)
ffffffffc0203aee:	64e2                	ld	s1,24(sp)
ffffffffc0203af0:	6942                	ld	s2,16(sp)
ffffffffc0203af2:	69a2                	ld	s3,8(sp)
ffffffffc0203af4:	6a02                	ld	s4,0(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203af6:	00003517          	auipc	a0,0x3
ffffffffc0203afa:	60250513          	addi	a0,a0,1538 # ffffffffc02070f8 <etext+0x1754>
}
ffffffffc0203afe:	6145                	addi	sp,sp,48
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203b00:	e98fc06f          	j	ffffffffc0200198 <cprintf>
        assert(vma != NULL);
ffffffffc0203b04:	00003697          	auipc	a3,0x3
ffffffffc0203b08:	48468693          	addi	a3,a3,1156 # ffffffffc0206f88 <etext+0x15e4>
ffffffffc0203b0c:	00003617          	auipc	a2,0x3
ffffffffc0203b10:	88460613          	addi	a2,a2,-1916 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203b14:	12c00593          	li	a1,300
ffffffffc0203b18:	00003517          	auipc	a0,0x3
ffffffffc0203b1c:	39850513          	addi	a0,a0,920 # ffffffffc0206eb0 <etext+0x150c>
ffffffffc0203b20:	92bfc0ef          	jal	ffffffffc020044a <__panic>
    assert(mm != NULL);
ffffffffc0203b24:	00003697          	auipc	a3,0x3
ffffffffc0203b28:	41468693          	addi	a3,a3,1044 # ffffffffc0206f38 <etext+0x1594>
ffffffffc0203b2c:	00003617          	auipc	a2,0x3
ffffffffc0203b30:	86460613          	addi	a2,a2,-1948 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203b34:	12400593          	li	a1,292
ffffffffc0203b38:	00003517          	auipc	a0,0x3
ffffffffc0203b3c:	37850513          	addi	a0,a0,888 # ffffffffc0206eb0 <etext+0x150c>
ffffffffc0203b40:	90bfc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma != NULL);
ffffffffc0203b44:	00003697          	auipc	a3,0x3
ffffffffc0203b48:	44468693          	addi	a3,a3,1092 # ffffffffc0206f88 <etext+0x15e4>
ffffffffc0203b4c:	00003617          	auipc	a2,0x3
ffffffffc0203b50:	84460613          	addi	a2,a2,-1980 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203b54:	13300593          	li	a1,307
ffffffffc0203b58:	00003517          	auipc	a0,0x3
ffffffffc0203b5c:	35850513          	addi	a0,a0,856 # ffffffffc0206eb0 <etext+0x150c>
ffffffffc0203b60:	8ebfc0ef          	jal	ffffffffc020044a <__panic>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203b64:	00003697          	auipc	a3,0x3
ffffffffc0203b68:	44c68693          	addi	a3,a3,1100 # ffffffffc0206fb0 <etext+0x160c>
ffffffffc0203b6c:	00003617          	auipc	a2,0x3
ffffffffc0203b70:	82460613          	addi	a2,a2,-2012 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203b74:	13d00593          	li	a1,317
ffffffffc0203b78:	00003517          	auipc	a0,0x3
ffffffffc0203b7c:	33850513          	addi	a0,a0,824 # ffffffffc0206eb0 <etext+0x150c>
ffffffffc0203b80:	8cbfc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203b84:	00003697          	auipc	a3,0x3
ffffffffc0203b88:	4e468693          	addi	a3,a3,1252 # ffffffffc0207068 <etext+0x16c4>
ffffffffc0203b8c:	00003617          	auipc	a2,0x3
ffffffffc0203b90:	80460613          	addi	a2,a2,-2044 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203b94:	14f00593          	li	a1,335
ffffffffc0203b98:	00003517          	auipc	a0,0x3
ffffffffc0203b9c:	31850513          	addi	a0,a0,792 # ffffffffc0206eb0 <etext+0x150c>
ffffffffc0203ba0:	8abfc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203ba4:	00003697          	auipc	a3,0x3
ffffffffc0203ba8:	49468693          	addi	a3,a3,1172 # ffffffffc0207038 <etext+0x1694>
ffffffffc0203bac:	00002617          	auipc	a2,0x2
ffffffffc0203bb0:	7e460613          	addi	a2,a2,2020 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203bb4:	14e00593          	li	a1,334
ffffffffc0203bb8:	00003517          	auipc	a0,0x3
ffffffffc0203bbc:	2f850513          	addi	a0,a0,760 # ffffffffc0206eb0 <etext+0x150c>
ffffffffc0203bc0:	88bfc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma5 == NULL);
ffffffffc0203bc4:	00003697          	auipc	a3,0x3
ffffffffc0203bc8:	46468693          	addi	a3,a3,1124 # ffffffffc0207028 <etext+0x1684>
ffffffffc0203bcc:	00002617          	auipc	a2,0x2
ffffffffc0203bd0:	7c460613          	addi	a2,a2,1988 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203bd4:	14c00593          	li	a1,332
ffffffffc0203bd8:	00003517          	auipc	a0,0x3
ffffffffc0203bdc:	2d850513          	addi	a0,a0,728 # ffffffffc0206eb0 <etext+0x150c>
ffffffffc0203be0:	86bfc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma4 == NULL);
ffffffffc0203be4:	00003697          	auipc	a3,0x3
ffffffffc0203be8:	43468693          	addi	a3,a3,1076 # ffffffffc0207018 <etext+0x1674>
ffffffffc0203bec:	00002617          	auipc	a2,0x2
ffffffffc0203bf0:	7a460613          	addi	a2,a2,1956 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203bf4:	14a00593          	li	a1,330
ffffffffc0203bf8:	00003517          	auipc	a0,0x3
ffffffffc0203bfc:	2b850513          	addi	a0,a0,696 # ffffffffc0206eb0 <etext+0x150c>
ffffffffc0203c00:	84bfc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma3 == NULL);
ffffffffc0203c04:	00003697          	auipc	a3,0x3
ffffffffc0203c08:	40468693          	addi	a3,a3,1028 # ffffffffc0207008 <etext+0x1664>
ffffffffc0203c0c:	00002617          	auipc	a2,0x2
ffffffffc0203c10:	78460613          	addi	a2,a2,1924 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203c14:	14800593          	li	a1,328
ffffffffc0203c18:	00003517          	auipc	a0,0x3
ffffffffc0203c1c:	29850513          	addi	a0,a0,664 # ffffffffc0206eb0 <etext+0x150c>
ffffffffc0203c20:	82bfc0ef          	jal	ffffffffc020044a <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203c24:	00003697          	auipc	a3,0x3
ffffffffc0203c28:	37468693          	addi	a3,a3,884 # ffffffffc0206f98 <etext+0x15f4>
ffffffffc0203c2c:	00002617          	auipc	a2,0x2
ffffffffc0203c30:	76460613          	addi	a2,a2,1892 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203c34:	13b00593          	li	a1,315
ffffffffc0203c38:	00003517          	auipc	a0,0x3
ffffffffc0203c3c:	27850513          	addi	a0,a0,632 # ffffffffc0206eb0 <etext+0x150c>
ffffffffc0203c40:	80bfc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma2 != NULL);
ffffffffc0203c44:	00003697          	auipc	a3,0x3
ffffffffc0203c48:	3b468693          	addi	a3,a3,948 # ffffffffc0206ff8 <etext+0x1654>
ffffffffc0203c4c:	00002617          	auipc	a2,0x2
ffffffffc0203c50:	74460613          	addi	a2,a2,1860 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203c54:	14600593          	li	a1,326
ffffffffc0203c58:	00003517          	auipc	a0,0x3
ffffffffc0203c5c:	25850513          	addi	a0,a0,600 # ffffffffc0206eb0 <etext+0x150c>
ffffffffc0203c60:	feafc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma1 != NULL);
ffffffffc0203c64:	00003697          	auipc	a3,0x3
ffffffffc0203c68:	38468693          	addi	a3,a3,900 # ffffffffc0206fe8 <etext+0x1644>
ffffffffc0203c6c:	00002617          	auipc	a2,0x2
ffffffffc0203c70:	72460613          	addi	a2,a2,1828 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203c74:	14400593          	li	a1,324
ffffffffc0203c78:	00003517          	auipc	a0,0x3
ffffffffc0203c7c:	23850513          	addi	a0,a0,568 # ffffffffc0206eb0 <etext+0x150c>
ffffffffc0203c80:	fcafc0ef          	jal	ffffffffc020044a <__panic>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203c84:	6914                	ld	a3,16(a0)
ffffffffc0203c86:	6510                	ld	a2,8(a0)
ffffffffc0203c88:	0004859b          	sext.w	a1,s1
ffffffffc0203c8c:	00003517          	auipc	a0,0x3
ffffffffc0203c90:	40c50513          	addi	a0,a0,1036 # ffffffffc0207098 <etext+0x16f4>
ffffffffc0203c94:	d04fc0ef          	jal	ffffffffc0200198 <cprintf>
        assert(vma_below_5 == NULL);
ffffffffc0203c98:	00003697          	auipc	a3,0x3
ffffffffc0203c9c:	42868693          	addi	a3,a3,1064 # ffffffffc02070c0 <etext+0x171c>
ffffffffc0203ca0:	00002617          	auipc	a2,0x2
ffffffffc0203ca4:	6f060613          	addi	a2,a2,1776 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0203ca8:	15900593          	li	a1,345
ffffffffc0203cac:	00003517          	auipc	a0,0x3
ffffffffc0203cb0:	20450513          	addi	a0,a0,516 # ffffffffc0206eb0 <etext+0x150c>
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
ffffffffc0203d9a:	3e1010ef          	jal	ffffffffc020597a <memset>
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
ffffffffc0203db8:	3c3010ef          	jal	ffffffffc020597a <memset>
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
ffffffffc0203e32:	00004797          	auipc	a5,0x4
ffffffffc0203e36:	4067b783          	ld	a5,1030(a5) # ffffffffc0208238 <nbase>
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
ffffffffc0203e56:	99660613          	addi	a2,a2,-1642 # ffffffffc02067e8 <etext+0xe44>
ffffffffc0203e5a:	07700593          	li	a1,119
ffffffffc0203e5e:	00003517          	auipc	a0,0x3
ffffffffc0203e62:	90a50513          	addi	a0,a0,-1782 # ffffffffc0206768 <etext+0xdc4>
ffffffffc0203e66:	de4fc0ef          	jal	ffffffffc020044a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203e6a:	00003617          	auipc	a2,0x3
ffffffffc0203e6e:	9a660613          	addi	a2,a2,-1626 # ffffffffc0206810 <etext+0xe6c>
ffffffffc0203e72:	06900593          	li	a1,105
ffffffffc0203e76:	00003517          	auipc	a0,0x3
ffffffffc0203e7a:	8f250513          	addi	a0,a0,-1806 # ffffffffc0206768 <etext+0xdc4>
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
ffffffffc0203f40:	00004a17          	auipc	s4,0x4
ffffffffc0203f44:	2f8a0a13          	addi	s4,s4,760 # ffffffffc0208238 <nbase>
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
ffffffffc02040ae:	436010ef          	jal	ffffffffc02054e4 <hash32>
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
ffffffffc020410c:	17e010ef          	jal	ffffffffc020528a <wakeup_proc>
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
ffffffffc020416c:	021010ef          	jal	ffffffffc020598c <memcpy>
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
ffffffffc0204188:	1a8010ef          	jal	ffffffffc0205330 <schedule>
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
ffffffffc020426c:	00002617          	auipc	a2,0x2
ffffffffc0204270:	5a460613          	addi	a2,a2,1444 # ffffffffc0206810 <etext+0xe6c>
ffffffffc0204274:	06900593          	li	a1,105
ffffffffc0204278:	00002517          	auipc	a0,0x2
ffffffffc020427c:	4f050513          	addi	a0,a0,1264 # ffffffffc0206768 <etext+0xdc4>
ffffffffc0204280:	9cafc0ef          	jal	ffffffffc020044a <__panic>
    return KADDR(page2pa(page));
ffffffffc0204284:	00002617          	auipc	a2,0x2
ffffffffc0204288:	4bc60613          	addi	a2,a2,1212 # ffffffffc0206740 <etext+0xd9c>
ffffffffc020428c:	07100593          	li	a1,113
ffffffffc0204290:	00002517          	auipc	a0,0x2
ffffffffc0204294:	4d850513          	addi	a0,a0,1240 # ffffffffc0206768 <etext+0xdc4>
ffffffffc0204298:	9b2fc0ef          	jal	ffffffffc020044a <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020429c:	86be                	mv	a3,a5
ffffffffc020429e:	00002617          	auipc	a2,0x2
ffffffffc02042a2:	54a60613          	addi	a2,a2,1354 # ffffffffc02067e8 <etext+0xe44>
ffffffffc02042a6:	19700593          	li	a1,407
ffffffffc02042aa:	00003517          	auipc	a0,0x3
ffffffffc02042ae:	e8650513          	addi	a0,a0,-378 # ffffffffc0207130 <etext+0x178c>
ffffffffc02042b2:	998fc0ef          	jal	ffffffffc020044a <__panic>
    return pa2page(PADDR(kva));
ffffffffc02042b6:	00002617          	auipc	a2,0x2
ffffffffc02042ba:	53260613          	addi	a2,a2,1330 # ffffffffc02067e8 <etext+0xe44>
ffffffffc02042be:	07700593          	li	a1,119
ffffffffc02042c2:	00002517          	auipc	a0,0x2
ffffffffc02042c6:	4a650513          	addi	a0,a0,1190 # ffffffffc0206768 <etext+0xdc4>
ffffffffc02042ca:	980fc0ef          	jal	ffffffffc020044a <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc02042ce:	00003617          	auipc	a2,0x3
ffffffffc02042d2:	e7a60613          	addi	a2,a2,-390 # ffffffffc0207148 <etext+0x17a4>
ffffffffc02042d6:	04000593          	li	a1,64
ffffffffc02042da:	00003517          	auipc	a0,0x3
ffffffffc02042de:	e7e50513          	addi	a0,a0,-386 # ffffffffc0207158 <etext+0x17b4>
ffffffffc02042e2:	968fc0ef          	jal	ffffffffc020044a <__panic>
    assert(current->wait_state == 0);
ffffffffc02042e6:	00003697          	auipc	a3,0x3
ffffffffc02042ea:	e2a68693          	addi	a3,a3,-470 # ffffffffc0207110 <etext+0x176c>
ffffffffc02042ee:	00002617          	auipc	a2,0x2
ffffffffc02042f2:	0a260613          	addi	a2,a2,162 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02042f6:	1d700593          	li	a1,471
ffffffffc02042fa:	00003517          	auipc	a0,0x3
ffffffffc02042fe:	e3650513          	addi	a0,a0,-458 # ffffffffc0207130 <etext+0x178c>
ffffffffc0204302:	fc4e                	sd	s3,56(sp)
ffffffffc0204304:	f852                	sd	s4,48(sp)
ffffffffc0204306:	f456                	sd	s5,40(sp)
ffffffffc0204308:	ec5e                	sd	s7,24(sp)
ffffffffc020430a:	e862                	sd	s8,16(sp)
ffffffffc020430c:	e466                	sd	s9,8(sp)
ffffffffc020430e:	93cfc0ef          	jal	ffffffffc020044a <__panic>
    return KADDR(page2pa(page));
ffffffffc0204312:	00002617          	auipc	a2,0x2
ffffffffc0204316:	42e60613          	addi	a2,a2,1070 # ffffffffc0206740 <etext+0xd9c>
ffffffffc020431a:	07100593          	li	a1,113
ffffffffc020431e:	00002517          	auipc	a0,0x2
ffffffffc0204322:	44a50513          	addi	a0,a0,1098 # ffffffffc0206768 <etext+0xdc4>
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
ffffffffc0204342:	638010ef          	jal	ffffffffc020597a <memset>
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
ffffffffc0204432:	659000ef          	jal	ffffffffc020528a <wakeup_proc>
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
ffffffffc0204444:	6ed000ef          	jal	ffffffffc0205330 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc0204448:	601c                	ld	a5,0(s0)
ffffffffc020444a:	00003617          	auipc	a2,0x3
ffffffffc020444e:	d4660613          	addi	a2,a2,-698 # ffffffffc0207190 <etext+0x17ec>
ffffffffc0204452:	24000593          	li	a1,576
ffffffffc0204456:	43d4                	lw	a3,4(a5)
ffffffffc0204458:	00003517          	auipc	a0,0x3
ffffffffc020445c:	cd850513          	addi	a0,a0,-808 # ffffffffc0207130 <etext+0x178c>
ffffffffc0204460:	febfb0ef          	jal	ffffffffc020044a <__panic>
        intr_enable();
ffffffffc0204464:	ca0fc0ef          	jal	ffffffffc0200904 <intr_enable>
ffffffffc0204468:	bff1                	j	ffffffffc0204444 <do_exit+0xca>
        panic("idleproc exit.\n");
ffffffffc020446a:	00003617          	auipc	a2,0x3
ffffffffc020446e:	d0660613          	addi	a2,a2,-762 # ffffffffc0207170 <etext+0x17cc>
ffffffffc0204472:	20c00593          	li	a1,524
ffffffffc0204476:	00003517          	auipc	a0,0x3
ffffffffc020447a:	cba50513          	addi	a0,a0,-838 # ffffffffc0207130 <etext+0x178c>
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
ffffffffc020449c:	ce860613          	addi	a2,a2,-792 # ffffffffc0207180 <etext+0x17dc>
ffffffffc02044a0:	21000593          	li	a1,528
ffffffffc02044a4:	00003517          	auipc	a0,0x3
ffffffffc02044a8:	c8c50513          	addi	a0,a0,-884 # ffffffffc0207130 <etext+0x178c>
ffffffffc02044ac:	f9ffb0ef          	jal	ffffffffc020044a <__panic>
        intr_disable();
ffffffffc02044b0:	c5afc0ef          	jal	ffffffffc020090a <intr_disable>
        return 1;
ffffffffc02044b4:	4905                	li	s2,1
ffffffffc02044b6:	b735                	j	ffffffffc02043e2 <do_exit+0x68>
            wakeup_proc(proc);
ffffffffc02044b8:	5d3000ef          	jal	ffffffffc020528a <wakeup_proc>
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
ffffffffc020459c:	ca07b783          	ld	a5,-864(a5) # ffffffffc0208238 <nbase>
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
ffffffffc02045f6:	53b000ef          	jal	ffffffffc0205330 <schedule>
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
ffffffffc020460e:	6d7000ef          	jal	ffffffffc02054e4 <hash32>
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
ffffffffc020465c:	b5860613          	addi	a2,a2,-1192 # ffffffffc02071b0 <etext+0x180c>
ffffffffc0204660:	36200593          	li	a1,866
ffffffffc0204664:	00003517          	auipc	a0,0x3
ffffffffc0204668:	acc50513          	addi	a0,a0,-1332 # ffffffffc0207130 <etext+0x178c>
ffffffffc020466c:	ddffb0ef          	jal	ffffffffc020044a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204670:	00002617          	auipc	a2,0x2
ffffffffc0204674:	1a060613          	addi	a2,a2,416 # ffffffffc0206810 <etext+0xe6c>
ffffffffc0204678:	06900593          	li	a1,105
ffffffffc020467c:	00002517          	auipc	a0,0x2
ffffffffc0204680:	0ec50513          	addi	a0,a0,236 # ffffffffc0206768 <etext+0xdc4>
ffffffffc0204684:	dc7fb0ef          	jal	ffffffffc020044a <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204688:	00002617          	auipc	a2,0x2
ffffffffc020468c:	16060613          	addi	a2,a2,352 # ffffffffc02067e8 <etext+0xe44>
ffffffffc0204690:	07700593          	li	a1,119
ffffffffc0204694:	00002517          	auipc	a0,0x2
ffffffffc0204698:	0d450513          	addi	a0,a0,212 # ffffffffc0206768 <etext+0xdc4>
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
ffffffffc02046c2:	46f000ef          	jal	ffffffffc0205330 <schedule>
    if (code_store != NULL)
ffffffffc02046c6:	4581                	li	a1,0
ffffffffc02046c8:	4501                	li	a0,0
ffffffffc02046ca:	df5ff0ef          	jal	ffffffffc02044be <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc02046ce:	d975                	beqz	a0,ffffffffc02046c2 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc02046d0:	00003517          	auipc	a0,0x3
ffffffffc02046d4:	b2050513          	addi	a0,a0,-1248 # ffffffffc02071f0 <etext+0x184c>
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
ffffffffc020471c:	bc050513          	addi	a0,a0,-1088 # ffffffffc02072d8 <etext+0x1934>
ffffffffc0204720:	a79fb0ef          	jal	ffffffffc0200198 <cprintf>
    return 0;
}
ffffffffc0204724:	60a2                	ld	ra,8(sp)
ffffffffc0204726:	4501                	li	a0,0
ffffffffc0204728:	0141                	addi	sp,sp,16
ffffffffc020472a:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc020472c:	00003697          	auipc	a3,0x3
ffffffffc0204730:	aec68693          	addi	a3,a3,-1300 # ffffffffc0207218 <etext+0x1874>
ffffffffc0204734:	00002617          	auipc	a2,0x2
ffffffffc0204738:	c5c60613          	addi	a2,a2,-932 # ffffffffc0206390 <etext+0x9ec>
ffffffffc020473c:	3ce00593          	li	a1,974
ffffffffc0204740:	00003517          	auipc	a0,0x3
ffffffffc0204744:	9f050513          	addi	a0,a0,-1552 # ffffffffc0207130 <etext+0x178c>
ffffffffc0204748:	d03fb0ef          	jal	ffffffffc020044a <__panic>
        panic("create user_main failed.\n");
ffffffffc020474c:	00003617          	auipc	a2,0x3
ffffffffc0204750:	a8460613          	addi	a2,a2,-1404 # ffffffffc02071d0 <etext+0x182c>
ffffffffc0204754:	3c500593          	li	a1,965
ffffffffc0204758:	00003517          	auipc	a0,0x3
ffffffffc020475c:	9d850513          	addi	a0,a0,-1576 # ffffffffc0207130 <etext+0x178c>
ffffffffc0204760:	cebfb0ef          	jal	ffffffffc020044a <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204764:	00003697          	auipc	a3,0x3
ffffffffc0204768:	b4468693          	addi	a3,a3,-1212 # ffffffffc02072a8 <etext+0x1904>
ffffffffc020476c:	00002617          	auipc	a2,0x2
ffffffffc0204770:	c2460613          	addi	a2,a2,-988 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0204774:	3d100593          	li	a1,977
ffffffffc0204778:	00003517          	auipc	a0,0x3
ffffffffc020477c:	9b850513          	addi	a0,a0,-1608 # ffffffffc0207130 <etext+0x178c>
ffffffffc0204780:	ccbfb0ef          	jal	ffffffffc020044a <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204784:	00003697          	auipc	a3,0x3
ffffffffc0204788:	af468693          	addi	a3,a3,-1292 # ffffffffc0207278 <etext+0x18d4>
ffffffffc020478c:	00002617          	auipc	a2,0x2
ffffffffc0204790:	c0460613          	addi	a2,a2,-1020 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0204794:	3d000593          	li	a1,976
ffffffffc0204798:	00003517          	auipc	a0,0x3
ffffffffc020479c:	99850513          	addi	a0,a0,-1640 # ffffffffc0207130 <etext+0x178c>
ffffffffc02047a0:	cabfb0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_process == 2);
ffffffffc02047a4:	00003697          	auipc	a3,0x3
ffffffffc02047a8:	ac468693          	addi	a3,a3,-1340 # ffffffffc0207268 <etext+0x18c4>
ffffffffc02047ac:	00002617          	auipc	a2,0x2
ffffffffc02047b0:	be460613          	addi	a2,a2,-1052 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02047b4:	3cf00593          	li	a1,975
ffffffffc02047b8:	00003517          	auipc	a0,0x3
ffffffffc02047bc:	97850513          	addi	a0,a0,-1672 # ffffffffc0207130 <etext+0x178c>
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
ffffffffc02047fc:	17e010ef          	jal	ffffffffc020597a <memset>
    if (len > PROC_NAME_LEN)
ffffffffc0204800:	47bd                	li	a5,15
ffffffffc0204802:	8626                	mv	a2,s1
ffffffffc0204804:	0e97ef63          	bltu	a5,s1,ffffffffc0204902 <do_execve+0x13e>
    memcpy(local_name, name, len);
ffffffffc0204808:	85ce                	mv	a1,s3
ffffffffc020480a:	1808                	addi	a0,sp,48
ffffffffc020480c:	180010ef          	jal	ffffffffc020598c <memcpy>
    if (mm != NULL)
ffffffffc0204810:	10090063          	beqz	s2,ffffffffc0204910 <do_execve+0x14c>
        cputs("mm != NULL");
ffffffffc0204814:	00002517          	auipc	a0,0x2
ffffffffc0204818:	72450513          	addi	a0,a0,1828 # ffffffffc0206f38 <etext+0x1594>
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
ffffffffc0204872:	9cabbb83          	ld	s7,-1590(s7) # ffffffffc0208238 <nbase>
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
ffffffffc02048bc:	0d0010ef          	jal	ffffffffc020598c <memcpy>
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
ffffffffc0204908:	084010ef          	jal	ffffffffc020598c <memcpy>
    if (mm != NULL)
ffffffffc020490c:	f00914e3          	bnez	s2,ffffffffc0204814 <do_execve+0x50>
    if (current->mm != NULL)
ffffffffc0204910:	000d3783          	ld	a5,0(s10)
ffffffffc0204914:	779c                	ld	a5,40(a5)
ffffffffc0204916:	db95                	beqz	a5,ffffffffc020484a <do_execve+0x86>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204918:	00003617          	auipc	a2,0x3
ffffffffc020491c:	9e060613          	addi	a2,a2,-1568 # ffffffffc02072f8 <etext+0x1954>
ffffffffc0204920:	24c00593          	li	a1,588
ffffffffc0204924:	00003517          	auipc	a0,0x3
ffffffffc0204928:	80c50513          	addi	a0,a0,-2036 # ffffffffc0207130 <etext+0x178c>
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
ffffffffc0204a18:	763000ef          	jal	ffffffffc020597a <memset>
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
ffffffffc0204a42:	739000ef          	jal	ffffffffc020597a <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204a46:	180c                	addi	a1,sp,48
ffffffffc0204a48:	0b498513          	addi	a0,s3,180
ffffffffc0204a4c:	463d                	li	a2,15
ffffffffc0204a4e:	73f000ef          	jal	ffffffffc020598c <memcpy>
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
ffffffffc0204b16:	677000ef          	jal	ffffffffc020598c <memcpy>
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
ffffffffc0204bb4:	5c7000ef          	jal	ffffffffc020597a <memset>
            start += size;
ffffffffc0204bb8:	9b4e                	add	s6,s6,s3
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204bba:	01b4b6b3          	sltu	a3,s1,s11
ffffffffc0204bbe:	01b4f463          	bgeu	s1,s11,ffffffffc0204bc6 <do_execve+0x402>
ffffffffc0204bc2:	db6484e3          	beq	s1,s6,ffffffffc020496a <do_execve+0x1a6>
ffffffffc0204bc6:	e299                	bnez	a3,ffffffffc0204bcc <do_execve+0x408>
ffffffffc0204bc8:	03bb0263          	beq	s6,s11,ffffffffc0204bec <do_execve+0x428>
ffffffffc0204bcc:	00002697          	auipc	a3,0x2
ffffffffc0204bd0:	75468693          	addi	a3,a3,1876 # ffffffffc0207320 <etext+0x197c>
ffffffffc0204bd4:	00001617          	auipc	a2,0x1
ffffffffc0204bd8:	7bc60613          	addi	a2,a2,1980 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0204bdc:	2b500593          	li	a1,693
ffffffffc0204be0:	00002517          	auipc	a0,0x2
ffffffffc0204be4:	55050513          	addi	a0,a0,1360 # ffffffffc0207130 <etext+0x178c>
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
ffffffffc0204c3c:	53f000ef          	jal	ffffffffc020597a <memset>
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
ffffffffc0204c8c:	ab860613          	addi	a2,a2,-1352 # ffffffffc0206740 <etext+0xd9c>
ffffffffc0204c90:	07100593          	li	a1,113
ffffffffc0204c94:	00002517          	auipc	a0,0x2
ffffffffc0204c98:	ad450513          	addi	a0,a0,-1324 # ffffffffc0206768 <etext+0xdc4>
ffffffffc0204c9c:	faefb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204ca0:	00002617          	auipc	a2,0x2
ffffffffc0204ca4:	aa060613          	addi	a2,a2,-1376 # ffffffffc0206740 <etext+0xd9c>
ffffffffc0204ca8:	07100593          	li	a1,113
ffffffffc0204cac:	00002517          	auipc	a0,0x2
ffffffffc0204cb0:	abc50513          	addi	a0,a0,-1348 # ffffffffc0206768 <etext+0xdc4>
ffffffffc0204cb4:	f122                	sd	s0,160(sp)
ffffffffc0204cb6:	e152                	sd	s4,128(sp)
ffffffffc0204cb8:	e4ee                	sd	s11,72(sp)
ffffffffc0204cba:	f90fb0ef          	jal	ffffffffc020044a <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204cbe:	00002617          	auipc	a2,0x2
ffffffffc0204cc2:	b2a60613          	addi	a2,a2,-1238 # ffffffffc02067e8 <etext+0xe44>
ffffffffc0204cc6:	2d400593          	li	a1,724
ffffffffc0204cca:	00002517          	auipc	a0,0x2
ffffffffc0204cce:	46650513          	addi	a0,a0,1126 # ffffffffc0207130 <etext+0x178c>
ffffffffc0204cd2:	e4ee                	sd	s11,72(sp)
ffffffffc0204cd4:	f76fb0ef          	jal	ffffffffc020044a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cd8:	00002697          	auipc	a3,0x2
ffffffffc0204cdc:	76068693          	addi	a3,a3,1888 # ffffffffc0207438 <etext+0x1a94>
ffffffffc0204ce0:	00001617          	auipc	a2,0x1
ffffffffc0204ce4:	6b060613          	addi	a2,a2,1712 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0204ce8:	2cf00593          	li	a1,719
ffffffffc0204cec:	00002517          	auipc	a0,0x2
ffffffffc0204cf0:	44450513          	addi	a0,a0,1092 # ffffffffc0207130 <etext+0x178c>
ffffffffc0204cf4:	e4ee                	sd	s11,72(sp)
ffffffffc0204cf6:	f54fb0ef          	jal	ffffffffc020044a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cfa:	00002697          	auipc	a3,0x2
ffffffffc0204cfe:	6f668693          	addi	a3,a3,1782 # ffffffffc02073f0 <etext+0x1a4c>
ffffffffc0204d02:	00001617          	auipc	a2,0x1
ffffffffc0204d06:	68e60613          	addi	a2,a2,1678 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0204d0a:	2ce00593          	li	a1,718
ffffffffc0204d0e:	00002517          	auipc	a0,0x2
ffffffffc0204d12:	42250513          	addi	a0,a0,1058 # ffffffffc0207130 <etext+0x178c>
ffffffffc0204d16:	e4ee                	sd	s11,72(sp)
ffffffffc0204d18:	f32fb0ef          	jal	ffffffffc020044a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204d1c:	00002697          	auipc	a3,0x2
ffffffffc0204d20:	68c68693          	addi	a3,a3,1676 # ffffffffc02073a8 <etext+0x1a04>
ffffffffc0204d24:	00001617          	auipc	a2,0x1
ffffffffc0204d28:	66c60613          	addi	a2,a2,1644 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0204d2c:	2cd00593          	li	a1,717
ffffffffc0204d30:	00002517          	auipc	a0,0x2
ffffffffc0204d34:	40050513          	addi	a0,a0,1024 # ffffffffc0207130 <etext+0x178c>
ffffffffc0204d38:	e4ee                	sd	s11,72(sp)
ffffffffc0204d3a:	f10fb0ef          	jal	ffffffffc020044a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204d3e:	00002697          	auipc	a3,0x2
ffffffffc0204d42:	62268693          	addi	a3,a3,1570 # ffffffffc0207360 <etext+0x19bc>
ffffffffc0204d46:	00001617          	auipc	a2,0x1
ffffffffc0204d4a:	64a60613          	addi	a2,a2,1610 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0204d4e:	2cc00593          	li	a1,716
ffffffffc0204d52:	00002517          	auipc	a0,0x2
ffffffffc0204d56:	3de50513          	addi	a0,a0,990 # ffffffffc0207130 <etext+0x178c>
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
ffffffffc0204d6e:	00002617          	auipc	a2,0x2
ffffffffc0204d72:	71260613          	addi	a2,a2,1810 # ffffffffc0207480 <etext+0x1adc>
ffffffffc0204d76:	00002517          	auipc	a0,0x2
ffffffffc0204d7a:	71a50513          	addi	a0,a0,1818 # ffffffffc0207490 <etext+0x1aec>
ffffffffc0204d7e:	43cc                	lw	a1,4(a5)
{
ffffffffc0204d80:	ec06                	sd	ra,24(sp)
ffffffffc0204d82:	e822                	sd	s0,16(sp)
ffffffffc0204d84:	e04a                	sd	s2,0(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204d86:	c12fb0ef          	jal	ffffffffc0200198 <cprintf>
    size_t len = strlen(name);
ffffffffc0204d8a:	00002517          	auipc	a0,0x2
ffffffffc0204d8e:	6f650513          	addi	a0,a0,1782 # ffffffffc0207480 <etext+0x1adc>
ffffffffc0204d92:	335000ef          	jal	ffffffffc02058c6 <strlen>
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
ffffffffc0204dac:	3e1000ef          	jal	ffffffffc020598c <memcpy>
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
ffffffffc0204dc6:	00002517          	auipc	a0,0x2
ffffffffc0204dca:	6ba50513          	addi	a0,a0,1722 # ffffffffc0207480 <etext+0x1adc>
ffffffffc0204dce:	9f7ff0ef          	jal	ffffffffc02047c4 <do_execve>
    asm volatile(
ffffffffc0204dd2:	8122                	mv	sp,s0
ffffffffc0204dd4:	868fc06f          	j	ffffffffc0200e3c <__trapret>
    panic("user_main execve failed.\n");
ffffffffc0204dd8:	00002617          	auipc	a2,0x2
ffffffffc0204ddc:	6e060613          	addi	a2,a2,1760 # ffffffffc02074b8 <etext+0x1b14>
ffffffffc0204de0:	3b800593          	li	a1,952
ffffffffc0204de4:	00002517          	auipc	a0,0x2
ffffffffc0204de8:	34c50513          	addi	a0,a0,844 # ffffffffc0207130 <etext+0x178c>
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
ffffffffc0204e4e:	696000ef          	jal	ffffffffc02054e4 <hash32>
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
ffffffffc0204ea4:	3e6000ef          	jal	ffffffffc020528a <wakeup_proc>
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
ffffffffc0204f14:	267000ef          	jal	ffffffffc020597a <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204f18:	8522                	mv	a0,s0
ffffffffc0204f1a:	463d                	li	a2,15
ffffffffc0204f1c:	00002597          	auipc	a1,0x2
ffffffffc0204f20:	5d458593          	addi	a1,a1,1492 # ffffffffc02074f0 <etext+0x1b4c>
ffffffffc0204f24:	269000ef          	jal	ffffffffc020598c <memcpy>
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
ffffffffc0204f6a:	57a000ef          	jal	ffffffffc02054e4 <hash32>
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
ffffffffc0204fa0:	1db000ef          	jal	ffffffffc020597a <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204fa4:	8522                	mv	a0,s0
ffffffffc0204fa6:	463d                	li	a2,15
ffffffffc0204fa8:	00002597          	auipc	a1,0x2
ffffffffc0204fac:	57058593          	addi	a1,a1,1392 # ffffffffc0207518 <etext+0x1b74>
ffffffffc0204fb0:	1dd000ef          	jal	ffffffffc020598c <memcpy>
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
ffffffffc0204fe2:	00002617          	auipc	a2,0x2
ffffffffc0204fe6:	51660613          	addi	a2,a2,1302 # ffffffffc02074f8 <etext+0x1b54>
ffffffffc0204fea:	3f400593          	li	a1,1012
ffffffffc0204fee:	00002517          	auipc	a0,0x2
ffffffffc0204ff2:	14250513          	addi	a0,a0,322 # ffffffffc0207130 <etext+0x178c>
ffffffffc0204ff6:	c54fb0ef          	jal	ffffffffc020044a <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0204ffa:	00002617          	auipc	a2,0x2
ffffffffc0204ffe:	4de60613          	addi	a2,a2,1246 # ffffffffc02074d8 <etext+0x1b34>
ffffffffc0205002:	3e500593          	li	a1,997
ffffffffc0205006:	00002517          	auipc	a0,0x2
ffffffffc020500a:	12a50513          	addi	a0,a0,298 # ffffffffc0207130 <etext+0x178c>
ffffffffc020500e:	c3cfb0ef          	jal	ffffffffc020044a <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205012:	00002697          	auipc	a3,0x2
ffffffffc0205016:	53668693          	addi	a3,a3,1334 # ffffffffc0207548 <etext+0x1ba4>
ffffffffc020501a:	00001617          	auipc	a2,0x1
ffffffffc020501e:	37660613          	addi	a2,a2,886 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0205022:	3fb00593          	li	a1,1019
ffffffffc0205026:	00002517          	auipc	a0,0x2
ffffffffc020502a:	10a50513          	addi	a0,a0,266 # ffffffffc0207130 <etext+0x178c>
ffffffffc020502e:	c1cfb0ef          	jal	ffffffffc020044a <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205032:	00002697          	auipc	a3,0x2
ffffffffc0205036:	4ee68693          	addi	a3,a3,1262 # ffffffffc0207520 <etext+0x1b7c>
ffffffffc020503a:	00001617          	auipc	a2,0x1
ffffffffc020503e:	35660613          	addi	a2,a2,854 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0205042:	3fa00593          	li	a1,1018
ffffffffc0205046:	00002517          	auipc	a0,0x2
ffffffffc020504a:	0ea50513          	addi	a0,a0,234 # ffffffffc0207130 <etext+0x178c>
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
ffffffffc0205066:	2ca000ef          	jal	ffffffffc0205330 <schedule>
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
ffffffffc0205086:	00002517          	auipc	a0,0x2
ffffffffc020508a:	4ea50513          	addi	a0,a0,1258 # ffffffffc0207570 <etext+0x1bcc>
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

ffffffffc0205120 <RR_init>:
    elm->prev = elm->next = elm;
ffffffffc0205120:	e508                	sd	a0,8(a0)
ffffffffc0205122:	e108                	sd	a0,0(a0)
 */
static void
RR_init(struct run_queue *rq)
{
    list_init(&rq->run_list);
    rq->proc_num = 0;
ffffffffc0205124:	00052823          	sw	zero,16(a0)
    /* ensure lab6 run pool cleared if present */
    rq->lab6_run_pool = NULL;
ffffffffc0205128:	00053c23          	sd	zero,24(a0)
}
ffffffffc020512c:	8082                	ret

ffffffffc020512e <RR_pick_next>:
    return list->next == list;
ffffffffc020512e:	651c                	ld	a5,8(a0)
/*
 */
static struct proc_struct *
RR_pick_next(struct run_queue *rq)
{
    if (list_empty(&rq->run_list)){
ffffffffc0205130:	00f50563          	beq	a0,a5,ffffffffc020513a <RR_pick_next+0xc>
        return idleproc;
    }
    list_entry_t *le = list_next(&rq->run_list);
    struct proc_struct *p = le2proc(le, run_link);
ffffffffc0205134:	ef078513          	addi	a0,a5,-272
// DEBUG:     if (p->pid >= 2 && p->pid <= 7) cprintf("RR_pick_next: picked pid=%d\n", p->pid);
    return p;
}
ffffffffc0205138:	8082                	ret
        return idleproc;
ffffffffc020513a:	000b0517          	auipc	a0,0xb0
ffffffffc020513e:	51e53503          	ld	a0,1310(a0) # ffffffffc02b5658 <idleproc>
ffffffffc0205142:	8082                	ret

ffffffffc0205144 <RR_proc_tick>:
/*
 */
static void
RR_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
    if (proc == idleproc || !proc) {
ffffffffc0205144:	000b0797          	auipc	a5,0xb0
ffffffffc0205148:	5147b783          	ld	a5,1300(a5) # ffffffffc02b5658 <idleproc>
ffffffffc020514c:	00b78d63          	beq	a5,a1,ffffffffc0205166 <RR_proc_tick+0x22>
ffffffffc0205150:	c999                	beqz	a1,ffffffffc0205166 <RR_proc_tick+0x22>
        return;
    }
    /* decrease time slice, trigger reschedule when exhausted */
    if (proc->time_slice > 0) {
ffffffffc0205152:	1205a783          	lw	a5,288(a1)
ffffffffc0205156:	00f05563          	blez	a5,ffffffffc0205160 <RR_proc_tick+0x1c>
        proc->time_slice--;
ffffffffc020515a:	37fd                	addiw	a5,a5,-1
ffffffffc020515c:	12f5a023          	sw	a5,288(a1)
    }
    if (proc->time_slice == 0) {
ffffffffc0205160:	e399                	bnez	a5,ffffffffc0205166 <RR_proc_tick+0x22>
        proc->need_resched = 1;
ffffffffc0205162:	4785                	li	a5,1
ffffffffc0205164:	ed9c                	sd	a5,24(a1)
    }
}
ffffffffc0205166:	8082                	ret

ffffffffc0205168 <RR_dequeue>:
    assert(proc && proc->rq == rq);
ffffffffc0205168:	c59d                	beqz	a1,ffffffffc0205196 <RR_dequeue+0x2e>
ffffffffc020516a:	1085b783          	ld	a5,264(a1)
ffffffffc020516e:	02a79463          	bne	a5,a0,ffffffffc0205196 <RR_dequeue+0x2e>
    __list_del(listelm->prev, listelm->next);
ffffffffc0205172:	1105b503          	ld	a0,272(a1)
ffffffffc0205176:	1185b603          	ld	a2,280(a1)
    rq->proc_num--;
ffffffffc020517a:	4b98                	lw	a4,16(a5)
    list_del_init(&proc->run_link);
ffffffffc020517c:	11058693          	addi	a3,a1,272
    prev->next = next;
ffffffffc0205180:	e510                	sd	a2,8(a0)
    next->prev = prev;
ffffffffc0205182:	e208                	sd	a0,0(a2)
    proc->rq = NULL;
ffffffffc0205184:	1005b423          	sd	zero,264(a1)
    rq->proc_num--;
ffffffffc0205188:	377d                	addiw	a4,a4,-1
    elm->prev = elm->next = elm;
ffffffffc020518a:	10d5bc23          	sd	a3,280(a1)
ffffffffc020518e:	10d5b823          	sd	a3,272(a1)
ffffffffc0205192:	cb98                	sw	a4,16(a5)
ffffffffc0205194:	8082                	ret
{
ffffffffc0205196:	1141                	addi	sp,sp,-16
    assert(proc && proc->rq == rq);
ffffffffc0205198:	00002697          	auipc	a3,0x2
ffffffffc020519c:	3f068693          	addi	a3,a3,1008 # ffffffffc0207588 <etext+0x1be4>
ffffffffc02051a0:	00001617          	auipc	a2,0x1
ffffffffc02051a4:	1f060613          	addi	a2,a2,496 # ffffffffc0206390 <etext+0x9ec>
ffffffffc02051a8:	03300593          	li	a1,51
ffffffffc02051ac:	00002517          	auipc	a0,0x2
ffffffffc02051b0:	3f450513          	addi	a0,a0,1012 # ffffffffc02075a0 <etext+0x1bfc>
{
ffffffffc02051b4:	e406                	sd	ra,8(sp)
    assert(proc && proc->rq == rq);
ffffffffc02051b6:	a94fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02051ba <RR_enqueue>:
    assert(proc);
ffffffffc02051ba:	c995                	beqz	a1,ffffffffc02051ee <RR_enqueue+0x34>
    __list_add(elm, listelm->prev, listelm);
ffffffffc02051bc:	6114                	ld	a3,0(a0)
    rq->proc_num++;
ffffffffc02051be:	4918                	lw	a4,16(a0)
    list_add_before(&rq->run_list, &proc->run_link);
ffffffffc02051c0:	11058793          	addi	a5,a1,272
    prev->next = next->prev = elm;
ffffffffc02051c4:	e11c                	sd	a5,0(a0)
ffffffffc02051c6:	e69c                	sd	a5,8(a3)
    if (proc != idleproc) {
ffffffffc02051c8:	000b0617          	auipc	a2,0xb0
ffffffffc02051cc:	49063603          	ld	a2,1168(a2) # ffffffffc02b5658 <idleproc>
    elm->prev = prev;
ffffffffc02051d0:	10d5b823          	sd	a3,272(a1)
    elm->next = next;
ffffffffc02051d4:	10a5bc23          	sd	a0,280(a1)
    proc->rq = rq;
ffffffffc02051d8:	10a5b423          	sd	a0,264(a1)
    rq->proc_num++;
ffffffffc02051dc:	0017079b          	addiw	a5,a4,1
ffffffffc02051e0:	c91c                	sw	a5,16(a0)
    if (proc != idleproc) {
ffffffffc02051e2:	00b60563          	beq	a2,a1,ffffffffc02051ec <RR_enqueue+0x32>
        proc->time_slice = rq->max_time_slice;
ffffffffc02051e6:	495c                	lw	a5,20(a0)
ffffffffc02051e8:	12f5a023          	sw	a5,288(a1)
ffffffffc02051ec:	8082                	ret
{
ffffffffc02051ee:	1141                	addi	sp,sp,-16
    assert(proc);
ffffffffc02051f0:	00002697          	auipc	a3,0x2
ffffffffc02051f4:	3d068693          	addi	a3,a3,976 # ffffffffc02075c0 <etext+0x1c1c>
ffffffffc02051f8:	00001617          	auipc	a2,0x1
ffffffffc02051fc:	19860613          	addi	a2,a2,408 # ffffffffc0206390 <etext+0x9ec>
ffffffffc0205200:	02200593          	li	a1,34
ffffffffc0205204:	00002517          	auipc	a0,0x2
ffffffffc0205208:	39c50513          	addi	a0,a0,924 # ffffffffc02075a0 <etext+0x1bfc>
{
ffffffffc020520c:	e406                	sd	ra,8(sp)
    assert(proc);
ffffffffc020520e:	a3cfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205212 <sched_class_proc_tick>:
    return sched_class->pick_next(rq);
}

void sched_class_proc_tick(struct proc_struct *proc)
{
    if (proc != idleproc) {
ffffffffc0205212:	000b0797          	auipc	a5,0xb0
ffffffffc0205216:	4467b783          	ld	a5,1094(a5) # ffffffffc02b5658 <idleproc>
{
ffffffffc020521a:	85aa                	mv	a1,a0
    if (proc != idleproc) {
ffffffffc020521c:	00a78c63          	beq	a5,a0,ffffffffc0205234 <sched_class_proc_tick+0x22>
        sched_class->proc_tick(rq, proc);
ffffffffc0205220:	000b0797          	auipc	a5,0xb0
ffffffffc0205224:	4487b783          	ld	a5,1096(a5) # ffffffffc02b5668 <sched_class>
ffffffffc0205228:	000b0517          	auipc	a0,0xb0
ffffffffc020522c:	43853503          	ld	a0,1080(a0) # ffffffffc02b5660 <rq>
ffffffffc0205230:	779c                	ld	a5,40(a5)
ffffffffc0205232:	8782                	jr	a5
    } else {
        /* idleproc: normally do nothing, but could reset accounting */
    }
}
ffffffffc0205234:	8082                	ret

ffffffffc0205236 <sched_init>:

void sched_init(void)
{
    list_init(&timer_list);

    sched_class = &default_sched_class;
ffffffffc0205236:	000ac797          	auipc	a5,0xac
ffffffffc020523a:	f1278793          	addi	a5,a5,-238 # ffffffffc02b1148 <default_sched_class>
{
ffffffffc020523e:	1141                	addi	sp,sp,-16

    rq = &__rq;
    rq->max_time_slice = MAX_TIME_SLICE;
    /* ensure run_queue fields initialized by class */
    sched_class->init(rq);
ffffffffc0205240:	6794                	ld	a3,8(a5)
    sched_class = &default_sched_class;
ffffffffc0205242:	000b0717          	auipc	a4,0xb0
ffffffffc0205246:	42f73323          	sd	a5,1062(a4) # ffffffffc02b5668 <sched_class>
{
ffffffffc020524a:	e406                	sd	ra,8(sp)
    elm->prev = elm->next = elm;
ffffffffc020524c:	000b0797          	auipc	a5,0xb0
ffffffffc0205250:	38478793          	addi	a5,a5,900 # ffffffffc02b55d0 <timer_list>
    rq = &__rq;
ffffffffc0205254:	000b0717          	auipc	a4,0xb0
ffffffffc0205258:	35c70713          	addi	a4,a4,860 # ffffffffc02b55b0 <__rq>
    rq->max_time_slice = MAX_TIME_SLICE;
ffffffffc020525c:	4615                	li	a2,5
ffffffffc020525e:	e79c                	sd	a5,8(a5)
ffffffffc0205260:	e39c                	sd	a5,0(a5)
    sched_class->init(rq);
ffffffffc0205262:	853a                	mv	a0,a4
    rq->max_time_slice = MAX_TIME_SLICE;
ffffffffc0205264:	cb50                	sw	a2,20(a4)
    rq = &__rq;
ffffffffc0205266:	000b0797          	auipc	a5,0xb0
ffffffffc020526a:	3ee7bd23          	sd	a4,1018(a5) # ffffffffc02b5660 <rq>
    sched_class->init(rq);
ffffffffc020526e:	9682                	jalr	a3

    
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205270:	000b0797          	auipc	a5,0xb0
ffffffffc0205274:	3f87b783          	ld	a5,1016(a5) # ffffffffc02b5668 <sched_class>
}
ffffffffc0205278:	60a2                	ld	ra,8(sp)
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc020527a:	00002517          	auipc	a0,0x2
ffffffffc020527e:	35e50513          	addi	a0,a0,862 # ffffffffc02075d8 <etext+0x1c34>
ffffffffc0205282:	638c                	ld	a1,0(a5)
}
ffffffffc0205284:	0141                	addi	sp,sp,16
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205286:	f13fa06f          	j	ffffffffc0200198 <cprintf>

ffffffffc020528a <wakeup_proc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020528a:	100027f3          	csrr	a5,sstatus
ffffffffc020528e:	8b89                	andi	a5,a5,2
ffffffffc0205290:	e7a9                	bnez	a5,ffffffffc02052da <wakeup_proc+0x50>
void wakeup_proc(struct proc_struct *proc)
{
    bool intr_flag;
    local_intr_save(intr_flag);

    if (proc->state != PROC_RUNNABLE) {
ffffffffc0205292:	4118                	lw	a4,0(a0)
ffffffffc0205294:	4789                	li	a5,2
ffffffffc0205296:	04f70163          	beq	a4,a5,ffffffffc02052d8 <wakeup_proc+0x4e>
// DEBUG:         cprintf("wakeup_proc: pid=%d state=%d\n", proc->pid, proc->state);
        proc->state = PROC_RUNNABLE;
        proc->wait_state = 0;
        /* only enqueue if it's not the current running thread */
        if (proc != current) {
ffffffffc020529a:	000b0717          	auipc	a4,0xb0
ffffffffc020529e:	3ae73703          	ld	a4,942(a4) # ffffffffc02b5648 <current>
        proc->wait_state = 0;
ffffffffc02052a2:	0e052623          	sw	zero,236(a0)
        proc->state = PROC_RUNNABLE;
ffffffffc02052a6:	c11c                	sw	a5,0(a0)
        if (proc != current) {
ffffffffc02052a8:	02e50663          	beq	a0,a4,ffffffffc02052d4 <wakeup_proc+0x4a>
    if (proc != idleproc) {
ffffffffc02052ac:	000b0797          	auipc	a5,0xb0
ffffffffc02052b0:	3ac7b783          	ld	a5,940(a5) # ffffffffc02b5658 <idleproc>
ffffffffc02052b4:	02f50163          	beq	a0,a5,ffffffffc02052d6 <wakeup_proc+0x4c>
        sched_class->enqueue(rq, proc);
ffffffffc02052b8:	000b0717          	auipc	a4,0xb0
ffffffffc02052bc:	3b073703          	ld	a4,944(a4) # ffffffffc02b5668 <sched_class>
        proc->rq = rq;
ffffffffc02052c0:	000b0797          	auipc	a5,0xb0
ffffffffc02052c4:	3a07b783          	ld	a5,928(a5) # ffffffffc02b5660 <rq>
        sched_class->enqueue(rq, proc);
ffffffffc02052c8:	85aa                	mv	a1,a0
ffffffffc02052ca:	6b18                	ld	a4,16(a4)
        proc->rq = rq;
ffffffffc02052cc:	10f53423          	sd	a5,264(a0)
        sched_class->enqueue(rq, proc);
ffffffffc02052d0:	853e                	mv	a0,a5
ffffffffc02052d2:	8702                	jr	a4
ffffffffc02052d4:	8082                	ret
ffffffffc02052d6:	8082                	ret
ffffffffc02052d8:	8082                	ret
{
ffffffffc02052da:	1101                	addi	sp,sp,-32
ffffffffc02052dc:	e42a                	sd	a0,8(sp)
ffffffffc02052de:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02052e0:	e2afb0ef          	jal	ffffffffc020090a <intr_disable>
    if (proc->state != PROC_RUNNABLE) {
ffffffffc02052e4:	6522                	ld	a0,8(sp)
ffffffffc02052e6:	4789                	li	a5,2
ffffffffc02052e8:	4118                	lw	a4,0(a0)
ffffffffc02052ea:	02f70f63          	beq	a4,a5,ffffffffc0205328 <wakeup_proc+0x9e>
        if (proc != current) {
ffffffffc02052ee:	000b0717          	auipc	a4,0xb0
ffffffffc02052f2:	35a73703          	ld	a4,858(a4) # ffffffffc02b5648 <current>
        proc->wait_state = 0;
ffffffffc02052f6:	0e052623          	sw	zero,236(a0)
        proc->state = PROC_RUNNABLE;
ffffffffc02052fa:	c11c                	sw	a5,0(a0)
        if (proc != current) {
ffffffffc02052fc:	02e50663          	beq	a0,a4,ffffffffc0205328 <wakeup_proc+0x9e>
    if (proc != idleproc) {
ffffffffc0205300:	000b0797          	auipc	a5,0xb0
ffffffffc0205304:	3587b783          	ld	a5,856(a5) # ffffffffc02b5658 <idleproc>
ffffffffc0205308:	02f50063          	beq	a0,a5,ffffffffc0205328 <wakeup_proc+0x9e>
        sched_class->enqueue(rq, proc);
ffffffffc020530c:	000b0717          	auipc	a4,0xb0
ffffffffc0205310:	35c73703          	ld	a4,860(a4) # ffffffffc02b5668 <sched_class>
        proc->rq = rq;
ffffffffc0205314:	000b0797          	auipc	a5,0xb0
ffffffffc0205318:	34c7b783          	ld	a5,844(a5) # ffffffffc02b5660 <rq>
        sched_class->enqueue(rq, proc);
ffffffffc020531c:	85aa                	mv	a1,a0
ffffffffc020531e:	6b18                	ld	a4,16(a4)
        proc->rq = rq;
ffffffffc0205320:	10f53423          	sd	a5,264(a0)
        sched_class->enqueue(rq, proc);
ffffffffc0205324:	853e                	mv	a0,a5
ffffffffc0205326:	9702                	jalr	a4
            sched_class_enqueue(proc);
        }
    }

    local_intr_restore(intr_flag);
}
ffffffffc0205328:	60e2                	ld	ra,24(sp)
ffffffffc020532a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020532c:	dd8fb06f          	j	ffffffffc0200904 <intr_enable>

ffffffffc0205330 <schedule>:

/* schedule: high level scheduling flow (enqueue current if runnable,
 * pick next, dequeue it and run) */
void schedule(void)
{
ffffffffc0205330:	7139                	addi	sp,sp,-64
ffffffffc0205332:	fc06                	sd	ra,56(sp)
ffffffffc0205334:	f822                	sd	s0,48(sp)
ffffffffc0205336:	f426                	sd	s1,40(sp)
ffffffffc0205338:	f04a                	sd	s2,32(sp)
ffffffffc020533a:	ec4e                	sd	s3,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020533c:	100027f3          	csrr	a5,sstatus
ffffffffc0205340:	8b89                	andi	a5,a5,2
ffffffffc0205342:	4981                	li	s3,0
ffffffffc0205344:	efd1                	bnez	a5,ffffffffc02053e0 <schedule+0xb0>
    bool intr_flag;
    local_intr_save(intr_flag);

    struct proc_struct *cur = current;
ffffffffc0205346:	000b0417          	auipc	s0,0xb0
ffffffffc020534a:	30243403          	ld	s0,770(s0) # ffffffffc02b5648 <current>

    /* clear resched flag for current; it will be set again if needed */
    cur->need_resched = 0;

    /* if current is still runnable, enqueue it */
    if (cur->state == PROC_RUNNABLE) {
ffffffffc020534e:	4789                	li	a5,2
ffffffffc0205350:	000b0497          	auipc	s1,0xb0
ffffffffc0205354:	31048493          	addi	s1,s1,784 # ffffffffc02b5660 <rq>
ffffffffc0205358:	4018                	lw	a4,0(s0)
    cur->need_resched = 0;
ffffffffc020535a:	00043c23          	sd	zero,24(s0)
    if (cur->state == PROC_RUNNABLE) {
ffffffffc020535e:	000b0917          	auipc	s2,0xb0
ffffffffc0205362:	30a90913          	addi	s2,s2,778 # ffffffffc02b5668 <sched_class>
ffffffffc0205366:	04f70e63          	beq	a4,a5,ffffffffc02053c2 <schedule+0x92>
    return sched_class->pick_next(rq);
ffffffffc020536a:	00093783          	ld	a5,0(s2)
ffffffffc020536e:	6088                	ld	a0,0(s1)
ffffffffc0205370:	739c                	ld	a5,32(a5)
ffffffffc0205372:	9782                	jalr	a5
ffffffffc0205374:	85aa                	mv	a1,a0
        sched_class_enqueue(cur);
    }

    /* pick next from scheduling class */
    next = sched_class_pick_next();
    if (!next) {
ffffffffc0205376:	c129                	beqz	a0,ffffffffc02053b8 <schedule+0x88>
    sched_class->dequeue(rq, proc);
ffffffffc0205378:	00093783          	ld	a5,0(s2)
ffffffffc020537c:	6088                	ld	a0,0(s1)
ffffffffc020537e:	e42e                	sd	a1,8(sp)
ffffffffc0205380:	6f9c                	ld	a5,24(a5)
ffffffffc0205382:	9782                	jalr	a5
ffffffffc0205384:	65a2                	ld	a1,8(sp)
        /* remove next from run-queue */
        sched_class_dequeue(next);
    }

    /* if next is the same as current, nothing to do */
    if (next == cur) {
ffffffffc0205386:	00858863          	beq	a1,s0,ffffffffc0205396 <schedule+0x66>
        return;
    }

    // DEBUG: if (next->pid >= 3 && next->pid <= 7) cprintf("schedule: switching to pid=%d\n", next->pid);
    /* accounting */
    next->runs++;
ffffffffc020538a:	459c                	lw	a5,8(a1)

    /* context switch */
    proc_run(next);
ffffffffc020538c:	852e                	mv	a0,a1
    next->runs++;
ffffffffc020538e:	2785                	addiw	a5,a5,1
ffffffffc0205390:	c59c                	sw	a5,8(a1)
    proc_run(next);
ffffffffc0205392:	af1fe0ef          	jal	ffffffffc0203e82 <proc_run>
    if (flag)
ffffffffc0205396:	00099963          	bnez	s3,ffffffffc02053a8 <schedule+0x78>

    /* proc_run should not return here in normal flow, but restore just in case */
    local_intr_restore(intr_flag);
ffffffffc020539a:	70e2                	ld	ra,56(sp)
ffffffffc020539c:	7442                	ld	s0,48(sp)
ffffffffc020539e:	74a2                	ld	s1,40(sp)
ffffffffc02053a0:	7902                	ld	s2,32(sp)
ffffffffc02053a2:	69e2                	ld	s3,24(sp)
ffffffffc02053a4:	6121                	addi	sp,sp,64
ffffffffc02053a6:	8082                	ret
ffffffffc02053a8:	7442                	ld	s0,48(sp)
ffffffffc02053aa:	70e2                	ld	ra,56(sp)
ffffffffc02053ac:	74a2                	ld	s1,40(sp)
ffffffffc02053ae:	7902                	ld	s2,32(sp)
ffffffffc02053b0:	69e2                	ld	s3,24(sp)
ffffffffc02053b2:	6121                	addi	sp,sp,64
        intr_enable();
ffffffffc02053b4:	d50fb06f          	j	ffffffffc0200904 <intr_enable>
        next = idleproc;
ffffffffc02053b8:	000b0597          	auipc	a1,0xb0
ffffffffc02053bc:	2a05b583          	ld	a1,672(a1) # ffffffffc02b5658 <idleproc>
ffffffffc02053c0:	b7d9                	j	ffffffffc0205386 <schedule+0x56>
    if (proc != idleproc) {
ffffffffc02053c2:	000b0797          	auipc	a5,0xb0
ffffffffc02053c6:	2967b783          	ld	a5,662(a5) # ffffffffc02b5658 <idleproc>
ffffffffc02053ca:	faf400e3          	beq	s0,a5,ffffffffc020536a <schedule+0x3a>
        sched_class->enqueue(rq, proc);
ffffffffc02053ce:	00093783          	ld	a5,0(s2)
        proc->rq = rq;
ffffffffc02053d2:	6088                	ld	a0,0(s1)
        sched_class->enqueue(rq, proc);
ffffffffc02053d4:	85a2                	mv	a1,s0
ffffffffc02053d6:	6b9c                	ld	a5,16(a5)
        proc->rq = rq;
ffffffffc02053d8:	10a43423          	sd	a0,264(s0)
        sched_class->enqueue(rq, proc);
ffffffffc02053dc:	9782                	jalr	a5
ffffffffc02053de:	b771                	j	ffffffffc020536a <schedule+0x3a>
        intr_disable();
ffffffffc02053e0:	d2afb0ef          	jal	ffffffffc020090a <intr_disable>
        return 1;
ffffffffc02053e4:	4985                	li	s3,1
ffffffffc02053e6:	b785                	j	ffffffffc0205346 <schedule+0x16>

ffffffffc02053e8 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc02053e8:	000b0797          	auipc	a5,0xb0
ffffffffc02053ec:	2607b783          	ld	a5,608(a5) # ffffffffc02b5648 <current>
}
ffffffffc02053f0:	43c8                	lw	a0,4(a5)
ffffffffc02053f2:	8082                	ret

ffffffffc02053f4 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc02053f4:	4501                	li	a0,0
ffffffffc02053f6:	8082                	ret

ffffffffc02053f8 <sys_gettime>:
static int sys_gettime(uint64_t arg[]){
    return (int)ticks*10;
ffffffffc02053f8:	000b0797          	auipc	a5,0xb0
ffffffffc02053fc:	1f07b783          	ld	a5,496(a5) # ffffffffc02b55e8 <ticks>
ffffffffc0205400:	0027951b          	slliw	a0,a5,0x2
ffffffffc0205404:	9d3d                	addw	a0,a0,a5
ffffffffc0205406:	0015151b          	slliw	a0,a0,0x1
}
ffffffffc020540a:	8082                	ret

ffffffffc020540c <sys_lab6_set_priority>:
static int sys_lab6_set_priority(uint64_t arg[]){
    uint64_t priority = (uint64_t)arg[0];
    lab6_set_priority(priority);
ffffffffc020540c:	4108                	lw	a0,0(a0)
static int sys_lab6_set_priority(uint64_t arg[]){
ffffffffc020540e:	1141                	addi	sp,sp,-16
ffffffffc0205410:	e406                	sd	ra,8(sp)
    lab6_set_priority(priority);
ffffffffc0205412:	c5bff0ef          	jal	ffffffffc020506c <lab6_set_priority>
    return 0;
}
ffffffffc0205416:	60a2                	ld	ra,8(sp)
ffffffffc0205418:	4501                	li	a0,0
ffffffffc020541a:	0141                	addi	sp,sp,16
ffffffffc020541c:	8082                	ret

ffffffffc020541e <sys_putc>:
    cputchar(c);
ffffffffc020541e:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205420:	1141                	addi	sp,sp,-16
ffffffffc0205422:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205424:	da9fa0ef          	jal	ffffffffc02001cc <cputchar>
}
ffffffffc0205428:	60a2                	ld	ra,8(sp)
ffffffffc020542a:	4501                	li	a0,0
ffffffffc020542c:	0141                	addi	sp,sp,16
ffffffffc020542e:	8082                	ret

ffffffffc0205430 <sys_kill>:
    return do_kill(pid);
ffffffffc0205430:	4108                	lw	a0,0(a0)
ffffffffc0205432:	a09ff06f          	j	ffffffffc0204e3a <do_kill>

ffffffffc0205436 <sys_yield>:
    return do_yield();
ffffffffc0205436:	9bbff06f          	j	ffffffffc0204df0 <do_yield>

ffffffffc020543a <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc020543a:	6d14                	ld	a3,24(a0)
ffffffffc020543c:	6910                	ld	a2,16(a0)
ffffffffc020543e:	650c                	ld	a1,8(a0)
ffffffffc0205440:	6108                	ld	a0,0(a0)
ffffffffc0205442:	b82ff06f          	j	ffffffffc02047c4 <do_execve>

ffffffffc0205446 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0205446:	650c                	ld	a1,8(a0)
ffffffffc0205448:	4108                	lw	a0,0(a0)
ffffffffc020544a:	9b7ff06f          	j	ffffffffc0204e00 <do_wait>

ffffffffc020544e <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc020544e:	000b0797          	auipc	a5,0xb0
ffffffffc0205452:	1fa7b783          	ld	a5,506(a5) # ffffffffc02b5648 <current>
    return do_fork(0, stack, tf);
ffffffffc0205456:	4501                	li	a0,0
    struct trapframe *tf = current->tf;
ffffffffc0205458:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc020545a:	6a0c                	ld	a1,16(a2)
ffffffffc020545c:	a89fe06f          	j	ffffffffc0203ee4 <do_fork>

ffffffffc0205460 <sys_exit>:
    return do_exit(error_code);
ffffffffc0205460:	4108                	lw	a0,0(a0)
ffffffffc0205462:	f19fe06f          	j	ffffffffc020437a <do_exit>

ffffffffc0205466 <syscall>:

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
    struct trapframe *tf = current->tf;
ffffffffc0205466:	000b0697          	auipc	a3,0xb0
ffffffffc020546a:	1e26b683          	ld	a3,482(a3) # ffffffffc02b5648 <current>
syscall(void) {
ffffffffc020546e:	715d                	addi	sp,sp,-80
ffffffffc0205470:	e0a2                	sd	s0,64(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205472:	72c0                	ld	s0,160(a3)
syscall(void) {
ffffffffc0205474:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205476:	0ff00793          	li	a5,255
    int num = tf->gpr.a0;
ffffffffc020547a:	4834                	lw	a3,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc020547c:	02d7ec63          	bltu	a5,a3,ffffffffc02054b4 <syscall+0x4e>
        if (syscalls[num] != NULL) {
ffffffffc0205480:	00002797          	auipc	a5,0x2
ffffffffc0205484:	39878793          	addi	a5,a5,920 # ffffffffc0207818 <syscalls>
ffffffffc0205488:	00369613          	slli	a2,a3,0x3
ffffffffc020548c:	97b2                	add	a5,a5,a2
ffffffffc020548e:	639c                	ld	a5,0(a5)
ffffffffc0205490:	c395                	beqz	a5,ffffffffc02054b4 <syscall+0x4e>
            arg[0] = tf->gpr.a1;
ffffffffc0205492:	7028                	ld	a0,96(s0)
ffffffffc0205494:	742c                	ld	a1,104(s0)
ffffffffc0205496:	7830                	ld	a2,112(s0)
ffffffffc0205498:	7c34                	ld	a3,120(s0)
ffffffffc020549a:	6c38                	ld	a4,88(s0)
ffffffffc020549c:	f02a                	sd	a0,32(sp)
ffffffffc020549e:	f42e                	sd	a1,40(sp)
ffffffffc02054a0:	f832                	sd	a2,48(sp)
ffffffffc02054a2:	fc36                	sd	a3,56(sp)
ffffffffc02054a4:	ec3a                	sd	a4,24(sp)
            arg[1] = tf->gpr.a2;
            arg[2] = tf->gpr.a3;
            arg[3] = tf->gpr.a4;
            arg[4] = tf->gpr.a5;
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02054a6:	0828                	addi	a0,sp,24
ffffffffc02054a8:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02054aa:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02054ac:	e828                	sd	a0,80(s0)
}
ffffffffc02054ae:	6406                	ld	s0,64(sp)
ffffffffc02054b0:	6161                	addi	sp,sp,80
ffffffffc02054b2:	8082                	ret
    print_trapframe(tf);
ffffffffc02054b4:	8522                	mv	a0,s0
ffffffffc02054b6:	e436                	sd	a3,8(sp)
ffffffffc02054b8:	e42fb0ef          	jal	ffffffffc0200afa <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc02054bc:	000b0797          	auipc	a5,0xb0
ffffffffc02054c0:	18c7b783          	ld	a5,396(a5) # ffffffffc02b5648 <current>
ffffffffc02054c4:	66a2                	ld	a3,8(sp)
ffffffffc02054c6:	00002617          	auipc	a2,0x2
ffffffffc02054ca:	12a60613          	addi	a2,a2,298 # ffffffffc02075f0 <etext+0x1c4c>
ffffffffc02054ce:	43d8                	lw	a4,4(a5)
ffffffffc02054d0:	06c00593          	li	a1,108
ffffffffc02054d4:	0b478793          	addi	a5,a5,180
ffffffffc02054d8:	00002517          	auipc	a0,0x2
ffffffffc02054dc:	14850513          	addi	a0,a0,328 # ffffffffc0207620 <etext+0x1c7c>
ffffffffc02054e0:	f6bfa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02054e4 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc02054e4:	9e3707b7          	lui	a5,0x9e370
ffffffffc02054e8:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <_binary_obj___user_matrix_out_size+0xffffffff9e364ad1>
ffffffffc02054ea:	02a787bb          	mulw	a5,a5,a0
    return (hash >> (32 - bits));
ffffffffc02054ee:	02000513          	li	a0,32
ffffffffc02054f2:	9d0d                	subw	a0,a0,a1
}
ffffffffc02054f4:	00a7d53b          	srlw	a0,a5,a0
ffffffffc02054f8:	8082                	ret

ffffffffc02054fa <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02054fa:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02054fc:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205500:	f022                	sd	s0,32(sp)
ffffffffc0205502:	ec26                	sd	s1,24(sp)
ffffffffc0205504:	e84a                	sd	s2,16(sp)
ffffffffc0205506:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205508:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020550c:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc020550e:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0205512:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205516:	84aa                	mv	s1,a0
ffffffffc0205518:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc020551a:	03067d63          	bgeu	a2,a6,ffffffffc0205554 <printnum+0x5a>
ffffffffc020551e:	e44e                	sd	s3,8(sp)
ffffffffc0205520:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0205522:	4785                	li	a5,1
ffffffffc0205524:	00e7d763          	bge	a5,a4,ffffffffc0205532 <printnum+0x38>
            putch(padc, putdat);
ffffffffc0205528:	85ca                	mv	a1,s2
ffffffffc020552a:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc020552c:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc020552e:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205530:	fc65                	bnez	s0,ffffffffc0205528 <printnum+0x2e>
ffffffffc0205532:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205534:	00002797          	auipc	a5,0x2
ffffffffc0205538:	10478793          	addi	a5,a5,260 # ffffffffc0207638 <etext+0x1c94>
ffffffffc020553c:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc020553e:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205540:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0205544:	70a2                	ld	ra,40(sp)
ffffffffc0205546:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205548:	85ca                	mv	a1,s2
ffffffffc020554a:	87a6                	mv	a5,s1
}
ffffffffc020554c:	6942                	ld	s2,16(sp)
ffffffffc020554e:	64e2                	ld	s1,24(sp)
ffffffffc0205550:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205552:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0205554:	03065633          	divu	a2,a2,a6
ffffffffc0205558:	8722                	mv	a4,s0
ffffffffc020555a:	fa1ff0ef          	jal	ffffffffc02054fa <printnum>
ffffffffc020555e:	bfd9                	j	ffffffffc0205534 <printnum+0x3a>

ffffffffc0205560 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0205560:	7119                	addi	sp,sp,-128
ffffffffc0205562:	f4a6                	sd	s1,104(sp)
ffffffffc0205564:	f0ca                	sd	s2,96(sp)
ffffffffc0205566:	ecce                	sd	s3,88(sp)
ffffffffc0205568:	e8d2                	sd	s4,80(sp)
ffffffffc020556a:	e4d6                	sd	s5,72(sp)
ffffffffc020556c:	e0da                	sd	s6,64(sp)
ffffffffc020556e:	f862                	sd	s8,48(sp)
ffffffffc0205570:	fc86                	sd	ra,120(sp)
ffffffffc0205572:	f8a2                	sd	s0,112(sp)
ffffffffc0205574:	fc5e                	sd	s7,56(sp)
ffffffffc0205576:	f466                	sd	s9,40(sp)
ffffffffc0205578:	f06a                	sd	s10,32(sp)
ffffffffc020557a:	ec6e                	sd	s11,24(sp)
ffffffffc020557c:	84aa                	mv	s1,a0
ffffffffc020557e:	8c32                	mv	s8,a2
ffffffffc0205580:	8a36                	mv	s4,a3
ffffffffc0205582:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205584:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205588:	05500b13          	li	s6,85
ffffffffc020558c:	00003a97          	auipc	s5,0x3
ffffffffc0205590:	a8ca8a93          	addi	s5,s5,-1396 # ffffffffc0208018 <syscalls+0x800>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205594:	000c4503          	lbu	a0,0(s8)
ffffffffc0205598:	001c0413          	addi	s0,s8,1
ffffffffc020559c:	01350a63          	beq	a0,s3,ffffffffc02055b0 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc02055a0:	cd0d                	beqz	a0,ffffffffc02055da <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc02055a2:	85ca                	mv	a1,s2
ffffffffc02055a4:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02055a6:	00044503          	lbu	a0,0(s0)
ffffffffc02055aa:	0405                	addi	s0,s0,1
ffffffffc02055ac:	ff351ae3          	bne	a0,s3,ffffffffc02055a0 <vprintfmt+0x40>
        width = precision = -1;
ffffffffc02055b0:	5cfd                	li	s9,-1
ffffffffc02055b2:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc02055b4:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc02055b8:	4b81                	li	s7,0
ffffffffc02055ba:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055bc:	00044683          	lbu	a3,0(s0)
ffffffffc02055c0:	00140c13          	addi	s8,s0,1
ffffffffc02055c4:	fdd6859b          	addiw	a1,a3,-35
ffffffffc02055c8:	0ff5f593          	zext.b	a1,a1
ffffffffc02055cc:	02bb6663          	bltu	s6,a1,ffffffffc02055f8 <vprintfmt+0x98>
ffffffffc02055d0:	058a                	slli	a1,a1,0x2
ffffffffc02055d2:	95d6                	add	a1,a1,s5
ffffffffc02055d4:	4198                	lw	a4,0(a1)
ffffffffc02055d6:	9756                	add	a4,a4,s5
ffffffffc02055d8:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02055da:	70e6                	ld	ra,120(sp)
ffffffffc02055dc:	7446                	ld	s0,112(sp)
ffffffffc02055de:	74a6                	ld	s1,104(sp)
ffffffffc02055e0:	7906                	ld	s2,96(sp)
ffffffffc02055e2:	69e6                	ld	s3,88(sp)
ffffffffc02055e4:	6a46                	ld	s4,80(sp)
ffffffffc02055e6:	6aa6                	ld	s5,72(sp)
ffffffffc02055e8:	6b06                	ld	s6,64(sp)
ffffffffc02055ea:	7be2                	ld	s7,56(sp)
ffffffffc02055ec:	7c42                	ld	s8,48(sp)
ffffffffc02055ee:	7ca2                	ld	s9,40(sp)
ffffffffc02055f0:	7d02                	ld	s10,32(sp)
ffffffffc02055f2:	6de2                	ld	s11,24(sp)
ffffffffc02055f4:	6109                	addi	sp,sp,128
ffffffffc02055f6:	8082                	ret
            putch('%', putdat);
ffffffffc02055f8:	85ca                	mv	a1,s2
ffffffffc02055fa:	02500513          	li	a0,37
ffffffffc02055fe:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205600:	fff44783          	lbu	a5,-1(s0)
ffffffffc0205604:	02500713          	li	a4,37
ffffffffc0205608:	8c22                	mv	s8,s0
ffffffffc020560a:	f8e785e3          	beq	a5,a4,ffffffffc0205594 <vprintfmt+0x34>
ffffffffc020560e:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0205612:	1c7d                	addi	s8,s8,-1
ffffffffc0205614:	fee79de3          	bne	a5,a4,ffffffffc020560e <vprintfmt+0xae>
ffffffffc0205618:	bfb5                	j	ffffffffc0205594 <vprintfmt+0x34>
                ch = *fmt;
ffffffffc020561a:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc020561e:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc0205620:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc0205624:	fd06071b          	addiw	a4,a2,-48
ffffffffc0205628:	24e56a63          	bltu	a0,a4,ffffffffc020587c <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc020562c:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020562e:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc0205630:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc0205634:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0205638:	0197073b          	addw	a4,a4,s9
ffffffffc020563c:	0017171b          	slliw	a4,a4,0x1
ffffffffc0205640:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc0205642:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0205646:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0205648:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc020564c:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc0205650:	feb570e3          	bgeu	a0,a1,ffffffffc0205630 <vprintfmt+0xd0>
            if (width < 0)
ffffffffc0205654:	f60d54e3          	bgez	s10,ffffffffc02055bc <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0205658:	8d66                	mv	s10,s9
ffffffffc020565a:	5cfd                	li	s9,-1
ffffffffc020565c:	b785                	j	ffffffffc02055bc <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020565e:	8db6                	mv	s11,a3
ffffffffc0205660:	8462                	mv	s0,s8
ffffffffc0205662:	bfa9                	j	ffffffffc02055bc <vprintfmt+0x5c>
ffffffffc0205664:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0205666:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0205668:	bf91                	j	ffffffffc02055bc <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc020566a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020566c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205670:	00f74463          	blt	a4,a5,ffffffffc0205678 <vprintfmt+0x118>
    else if (lflag) {
ffffffffc0205674:	1a078763          	beqz	a5,ffffffffc0205822 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0205678:	000a3603          	ld	a2,0(s4)
ffffffffc020567c:	46c1                	li	a3,16
ffffffffc020567e:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205680:	000d879b          	sext.w	a5,s11
ffffffffc0205684:	876a                	mv	a4,s10
ffffffffc0205686:	85ca                	mv	a1,s2
ffffffffc0205688:	8526                	mv	a0,s1
ffffffffc020568a:	e71ff0ef          	jal	ffffffffc02054fa <printnum>
            break;
ffffffffc020568e:	b719                	j	ffffffffc0205594 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0205690:	000a2503          	lw	a0,0(s4)
ffffffffc0205694:	85ca                	mv	a1,s2
ffffffffc0205696:	0a21                	addi	s4,s4,8
ffffffffc0205698:	9482                	jalr	s1
            break;
ffffffffc020569a:	bded                	j	ffffffffc0205594 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc020569c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020569e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02056a2:	00f74463          	blt	a4,a5,ffffffffc02056aa <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc02056a6:	16078963          	beqz	a5,ffffffffc0205818 <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc02056aa:	000a3603          	ld	a2,0(s4)
ffffffffc02056ae:	46a9                	li	a3,10
ffffffffc02056b0:	8a2e                	mv	s4,a1
ffffffffc02056b2:	b7f9                	j	ffffffffc0205680 <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc02056b4:	85ca                	mv	a1,s2
ffffffffc02056b6:	03000513          	li	a0,48
ffffffffc02056ba:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc02056bc:	85ca                	mv	a1,s2
ffffffffc02056be:	07800513          	li	a0,120
ffffffffc02056c2:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02056c4:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc02056c8:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02056ca:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02056cc:	bf55                	j	ffffffffc0205680 <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc02056ce:	85ca                	mv	a1,s2
ffffffffc02056d0:	02500513          	li	a0,37
ffffffffc02056d4:	9482                	jalr	s1
            break;
ffffffffc02056d6:	bd7d                	j	ffffffffc0205594 <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc02056d8:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056dc:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc02056de:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc02056e0:	bf95                	j	ffffffffc0205654 <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc02056e2:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02056e4:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02056e8:	00f74463          	blt	a4,a5,ffffffffc02056f0 <vprintfmt+0x190>
    else if (lflag) {
ffffffffc02056ec:	12078163          	beqz	a5,ffffffffc020580e <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc02056f0:	000a3603          	ld	a2,0(s4)
ffffffffc02056f4:	46a1                	li	a3,8
ffffffffc02056f6:	8a2e                	mv	s4,a1
ffffffffc02056f8:	b761                	j	ffffffffc0205680 <vprintfmt+0x120>
            if (width < 0)
ffffffffc02056fa:	876a                	mv	a4,s10
ffffffffc02056fc:	000d5363          	bgez	s10,ffffffffc0205702 <vprintfmt+0x1a2>
ffffffffc0205700:	4701                	li	a4,0
ffffffffc0205702:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205706:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0205708:	bd55                	j	ffffffffc02055bc <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc020570a:	000d841b          	sext.w	s0,s11
ffffffffc020570e:	fd340793          	addi	a5,s0,-45
ffffffffc0205712:	00f037b3          	snez	a5,a5
ffffffffc0205716:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020571a:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc020571e:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205720:	008a0793          	addi	a5,s4,8
ffffffffc0205724:	e43e                	sd	a5,8(sp)
ffffffffc0205726:	100d8c63          	beqz	s11,ffffffffc020583e <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc020572a:	12071363          	bnez	a4,ffffffffc0205850 <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020572e:	000dc783          	lbu	a5,0(s11)
ffffffffc0205732:	0007851b          	sext.w	a0,a5
ffffffffc0205736:	c78d                	beqz	a5,ffffffffc0205760 <vprintfmt+0x200>
ffffffffc0205738:	0d85                	addi	s11,s11,1
ffffffffc020573a:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020573c:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205740:	000cc563          	bltz	s9,ffffffffc020574a <vprintfmt+0x1ea>
ffffffffc0205744:	3cfd                	addiw	s9,s9,-1
ffffffffc0205746:	008c8d63          	beq	s9,s0,ffffffffc0205760 <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020574a:	020b9663          	bnez	s7,ffffffffc0205776 <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc020574e:	85ca                	mv	a1,s2
ffffffffc0205750:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205752:	000dc783          	lbu	a5,0(s11)
ffffffffc0205756:	0d85                	addi	s11,s11,1
ffffffffc0205758:	3d7d                	addiw	s10,s10,-1
ffffffffc020575a:	0007851b          	sext.w	a0,a5
ffffffffc020575e:	f3ed                	bnez	a5,ffffffffc0205740 <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc0205760:	01a05963          	blez	s10,ffffffffc0205772 <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc0205764:	85ca                	mv	a1,s2
ffffffffc0205766:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc020576a:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc020576c:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc020576e:	fe0d1be3          	bnez	s10,ffffffffc0205764 <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205772:	6a22                	ld	s4,8(sp)
ffffffffc0205774:	b505                	j	ffffffffc0205594 <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205776:	3781                	addiw	a5,a5,-32
ffffffffc0205778:	fcfa7be3          	bgeu	s4,a5,ffffffffc020574e <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc020577c:	03f00513          	li	a0,63
ffffffffc0205780:	85ca                	mv	a1,s2
ffffffffc0205782:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205784:	000dc783          	lbu	a5,0(s11)
ffffffffc0205788:	0d85                	addi	s11,s11,1
ffffffffc020578a:	3d7d                	addiw	s10,s10,-1
ffffffffc020578c:	0007851b          	sext.w	a0,a5
ffffffffc0205790:	dbe1                	beqz	a5,ffffffffc0205760 <vprintfmt+0x200>
ffffffffc0205792:	fa0cd9e3          	bgez	s9,ffffffffc0205744 <vprintfmt+0x1e4>
ffffffffc0205796:	b7c5                	j	ffffffffc0205776 <vprintfmt+0x216>
            if (err < 0) {
ffffffffc0205798:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020579c:	4661                	li	a2,24
            err = va_arg(ap, int);
ffffffffc020579e:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc02057a0:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc02057a4:	8fb9                	xor	a5,a5,a4
ffffffffc02057a6:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02057aa:	02d64563          	blt	a2,a3,ffffffffc02057d4 <vprintfmt+0x274>
ffffffffc02057ae:	00003797          	auipc	a5,0x3
ffffffffc02057b2:	9c278793          	addi	a5,a5,-1598 # ffffffffc0208170 <error_string>
ffffffffc02057b6:	00369713          	slli	a4,a3,0x3
ffffffffc02057ba:	97ba                	add	a5,a5,a4
ffffffffc02057bc:	639c                	ld	a5,0(a5)
ffffffffc02057be:	cb99                	beqz	a5,ffffffffc02057d4 <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc02057c0:	86be                	mv	a3,a5
ffffffffc02057c2:	00000617          	auipc	a2,0x0
ffffffffc02057c6:	20e60613          	addi	a2,a2,526 # ffffffffc02059d0 <etext+0x2c>
ffffffffc02057ca:	85ca                	mv	a1,s2
ffffffffc02057cc:	8526                	mv	a0,s1
ffffffffc02057ce:	0d8000ef          	jal	ffffffffc02058a6 <printfmt>
ffffffffc02057d2:	b3c9                	j	ffffffffc0205594 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02057d4:	00002617          	auipc	a2,0x2
ffffffffc02057d8:	e8460613          	addi	a2,a2,-380 # ffffffffc0207658 <etext+0x1cb4>
ffffffffc02057dc:	85ca                	mv	a1,s2
ffffffffc02057de:	8526                	mv	a0,s1
ffffffffc02057e0:	0c6000ef          	jal	ffffffffc02058a6 <printfmt>
ffffffffc02057e4:	bb45                	j	ffffffffc0205594 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc02057e6:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02057e8:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc02057ec:	00f74363          	blt	a4,a5,ffffffffc02057f2 <vprintfmt+0x292>
    else if (lflag) {
ffffffffc02057f0:	cf81                	beqz	a5,ffffffffc0205808 <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc02057f2:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02057f6:	02044b63          	bltz	s0,ffffffffc020582c <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc02057fa:	8622                	mv	a2,s0
ffffffffc02057fc:	8a5e                	mv	s4,s7
ffffffffc02057fe:	46a9                	li	a3,10
ffffffffc0205800:	b541                	j	ffffffffc0205680 <vprintfmt+0x120>
            lflag ++;
ffffffffc0205802:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205804:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0205806:	bb5d                	j	ffffffffc02055bc <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc0205808:	000a2403          	lw	s0,0(s4)
ffffffffc020580c:	b7ed                	j	ffffffffc02057f6 <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc020580e:	000a6603          	lwu	a2,0(s4)
ffffffffc0205812:	46a1                	li	a3,8
ffffffffc0205814:	8a2e                	mv	s4,a1
ffffffffc0205816:	b5ad                	j	ffffffffc0205680 <vprintfmt+0x120>
ffffffffc0205818:	000a6603          	lwu	a2,0(s4)
ffffffffc020581c:	46a9                	li	a3,10
ffffffffc020581e:	8a2e                	mv	s4,a1
ffffffffc0205820:	b585                	j	ffffffffc0205680 <vprintfmt+0x120>
ffffffffc0205822:	000a6603          	lwu	a2,0(s4)
ffffffffc0205826:	46c1                	li	a3,16
ffffffffc0205828:	8a2e                	mv	s4,a1
ffffffffc020582a:	bd99                	j	ffffffffc0205680 <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc020582c:	85ca                	mv	a1,s2
ffffffffc020582e:	02d00513          	li	a0,45
ffffffffc0205832:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc0205834:	40800633          	neg	a2,s0
ffffffffc0205838:	8a5e                	mv	s4,s7
ffffffffc020583a:	46a9                	li	a3,10
ffffffffc020583c:	b591                	j	ffffffffc0205680 <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc020583e:	e329                	bnez	a4,ffffffffc0205880 <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205840:	02800793          	li	a5,40
ffffffffc0205844:	853e                	mv	a0,a5
ffffffffc0205846:	00002d97          	auipc	s11,0x2
ffffffffc020584a:	e0bd8d93          	addi	s11,s11,-501 # ffffffffc0207651 <etext+0x1cad>
ffffffffc020584e:	b5f5                	j	ffffffffc020573a <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205850:	85e6                	mv	a1,s9
ffffffffc0205852:	856e                	mv	a0,s11
ffffffffc0205854:	08a000ef          	jal	ffffffffc02058de <strnlen>
ffffffffc0205858:	40ad0d3b          	subw	s10,s10,a0
ffffffffc020585c:	01a05863          	blez	s10,ffffffffc020586c <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc0205860:	85ca                	mv	a1,s2
ffffffffc0205862:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205864:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc0205866:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205868:	fe0d1ce3          	bnez	s10,ffffffffc0205860 <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020586c:	000dc783          	lbu	a5,0(s11)
ffffffffc0205870:	0007851b          	sext.w	a0,a5
ffffffffc0205874:	ec0792e3          	bnez	a5,ffffffffc0205738 <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205878:	6a22                	ld	s4,8(sp)
ffffffffc020587a:	bb29                	j	ffffffffc0205594 <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020587c:	8462                	mv	s0,s8
ffffffffc020587e:	bbd9                	j	ffffffffc0205654 <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205880:	85e6                	mv	a1,s9
ffffffffc0205882:	00002517          	auipc	a0,0x2
ffffffffc0205886:	dce50513          	addi	a0,a0,-562 # ffffffffc0207650 <etext+0x1cac>
ffffffffc020588a:	054000ef          	jal	ffffffffc02058de <strnlen>
ffffffffc020588e:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205892:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0205896:	00002d97          	auipc	s11,0x2
ffffffffc020589a:	dbad8d93          	addi	s11,s11,-582 # ffffffffc0207650 <etext+0x1cac>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020589e:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02058a0:	fda040e3          	bgtz	s10,ffffffffc0205860 <vprintfmt+0x300>
ffffffffc02058a4:	bd51                	j	ffffffffc0205738 <vprintfmt+0x1d8>

ffffffffc02058a6 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02058a6:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02058a8:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02058ac:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02058ae:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02058b0:	ec06                	sd	ra,24(sp)
ffffffffc02058b2:	f83a                	sd	a4,48(sp)
ffffffffc02058b4:	fc3e                	sd	a5,56(sp)
ffffffffc02058b6:	e0c2                	sd	a6,64(sp)
ffffffffc02058b8:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02058ba:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02058bc:	ca5ff0ef          	jal	ffffffffc0205560 <vprintfmt>
}
ffffffffc02058c0:	60e2                	ld	ra,24(sp)
ffffffffc02058c2:	6161                	addi	sp,sp,80
ffffffffc02058c4:	8082                	ret

ffffffffc02058c6 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02058c6:	00054783          	lbu	a5,0(a0)
ffffffffc02058ca:	cb81                	beqz	a5,ffffffffc02058da <strlen+0x14>
    size_t cnt = 0;
ffffffffc02058cc:	4781                	li	a5,0
        cnt ++;
ffffffffc02058ce:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc02058d0:	00f50733          	add	a4,a0,a5
ffffffffc02058d4:	00074703          	lbu	a4,0(a4)
ffffffffc02058d8:	fb7d                	bnez	a4,ffffffffc02058ce <strlen+0x8>
    }
    return cnt;
}
ffffffffc02058da:	853e                	mv	a0,a5
ffffffffc02058dc:	8082                	ret

ffffffffc02058de <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02058de:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02058e0:	e589                	bnez	a1,ffffffffc02058ea <strnlen+0xc>
ffffffffc02058e2:	a811                	j	ffffffffc02058f6 <strnlen+0x18>
        cnt ++;
ffffffffc02058e4:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02058e6:	00f58863          	beq	a1,a5,ffffffffc02058f6 <strnlen+0x18>
ffffffffc02058ea:	00f50733          	add	a4,a0,a5
ffffffffc02058ee:	00074703          	lbu	a4,0(a4)
ffffffffc02058f2:	fb6d                	bnez	a4,ffffffffc02058e4 <strnlen+0x6>
ffffffffc02058f4:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02058f6:	852e                	mv	a0,a1
ffffffffc02058f8:	8082                	ret

ffffffffc02058fa <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc02058fa:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc02058fc:	0005c703          	lbu	a4,0(a1)
ffffffffc0205900:	0585                	addi	a1,a1,1
ffffffffc0205902:	0785                	addi	a5,a5,1
ffffffffc0205904:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0205908:	fb75                	bnez	a4,ffffffffc02058fc <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc020590a:	8082                	ret

ffffffffc020590c <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020590c:	00054783          	lbu	a5,0(a0)
ffffffffc0205910:	e791                	bnez	a5,ffffffffc020591c <strcmp+0x10>
ffffffffc0205912:	a01d                	j	ffffffffc0205938 <strcmp+0x2c>
ffffffffc0205914:	00054783          	lbu	a5,0(a0)
ffffffffc0205918:	cb99                	beqz	a5,ffffffffc020592e <strcmp+0x22>
ffffffffc020591a:	0585                	addi	a1,a1,1
ffffffffc020591c:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0205920:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205922:	fef709e3          	beq	a4,a5,ffffffffc0205914 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205926:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc020592a:	9d19                	subw	a0,a0,a4
ffffffffc020592c:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020592e:	0015c703          	lbu	a4,1(a1)
ffffffffc0205932:	4501                	li	a0,0
}
ffffffffc0205934:	9d19                	subw	a0,a0,a4
ffffffffc0205936:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205938:	0005c703          	lbu	a4,0(a1)
ffffffffc020593c:	4501                	li	a0,0
ffffffffc020593e:	b7f5                	j	ffffffffc020592a <strcmp+0x1e>

ffffffffc0205940 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205940:	ce01                	beqz	a2,ffffffffc0205958 <strncmp+0x18>
ffffffffc0205942:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0205946:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205948:	cb91                	beqz	a5,ffffffffc020595c <strncmp+0x1c>
ffffffffc020594a:	0005c703          	lbu	a4,0(a1)
ffffffffc020594e:	00f71763          	bne	a4,a5,ffffffffc020595c <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc0205952:	0505                	addi	a0,a0,1
ffffffffc0205954:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205956:	f675                	bnez	a2,ffffffffc0205942 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205958:	4501                	li	a0,0
ffffffffc020595a:	8082                	ret
ffffffffc020595c:	00054503          	lbu	a0,0(a0)
ffffffffc0205960:	0005c783          	lbu	a5,0(a1)
ffffffffc0205964:	9d1d                	subw	a0,a0,a5
}
ffffffffc0205966:	8082                	ret

ffffffffc0205968 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0205968:	a021                	j	ffffffffc0205970 <strchr+0x8>
        if (*s == c) {
ffffffffc020596a:	00f58763          	beq	a1,a5,ffffffffc0205978 <strchr+0x10>
            return (char *)s;
        }
        s ++;
ffffffffc020596e:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0205970:	00054783          	lbu	a5,0(a0)
ffffffffc0205974:	fbfd                	bnez	a5,ffffffffc020596a <strchr+0x2>
    }
    return NULL;
ffffffffc0205976:	4501                	li	a0,0
}
ffffffffc0205978:	8082                	ret

ffffffffc020597a <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc020597a:	ca01                	beqz	a2,ffffffffc020598a <memset+0x10>
ffffffffc020597c:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc020597e:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0205980:	0785                	addi	a5,a5,1
ffffffffc0205982:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0205986:	fef61de3          	bne	a2,a5,ffffffffc0205980 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc020598a:	8082                	ret

ffffffffc020598c <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc020598c:	ca19                	beqz	a2,ffffffffc02059a2 <memcpy+0x16>
ffffffffc020598e:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0205990:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0205992:	0005c703          	lbu	a4,0(a1)
ffffffffc0205996:	0585                	addi	a1,a1,1
ffffffffc0205998:	0785                	addi	a5,a5,1
ffffffffc020599a:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc020599e:	feb61ae3          	bne	a2,a1,ffffffffc0205992 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc02059a2:	8082                	ret
