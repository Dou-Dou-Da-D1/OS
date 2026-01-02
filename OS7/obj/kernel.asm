
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000d297          	auipc	t0,0xd
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020d000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000d297          	auipc	t0,0xd
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020d008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020c2b7          	lui	t0,0xc020c
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
ffffffffc020003c:	c020c137          	lui	sp,0xc020c

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
ffffffffc020004a:	000c8517          	auipc	a0,0xc8
ffffffffc020004e:	c4e50513          	addi	a0,a0,-946 # ffffffffc02c7c98 <buf>
ffffffffc0200052:	000cc617          	auipc	a2,0xcc
ffffffffc0200056:	27660613          	addi	a2,a2,630 # ffffffffc02cc2c8 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc020bff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	2b8060ef          	jal	ffffffffc020631a <memset>
    cons_init(); // init the console
ffffffffc0200066:	496000ef          	jal	ffffffffc02004fc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006a:	00006597          	auipc	a1,0x6
ffffffffc020006e:	2de58593          	addi	a1,a1,734 # ffffffffc0206348 <etext+0x4>
ffffffffc0200072:	00006517          	auipc	a0,0x6
ffffffffc0200076:	2f650513          	addi	a0,a0,758 # ffffffffc0206368 <etext+0x24>
ffffffffc020007a:	11e000ef          	jal	ffffffffc0200198 <cprintf>

    print_kerninfo();
ffffffffc020007e:	1ac000ef          	jal	ffffffffc020022a <print_kerninfo>

    // grade_backtrace();

    dtb_init(); // init dtb
ffffffffc0200082:	4ec000ef          	jal	ffffffffc020056e <dtb_init>
    pmm_init(); // init physical memory management
ffffffffc0200086:	580020ef          	jal	ffffffffc0202606 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	037000ef          	jal	ffffffffc02008c0 <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	035000ef          	jal	ffffffffc02008c2 <idt_init>

    vmm_init(); // init virtual memory management
ffffffffc0200092:	07b030ef          	jal	ffffffffc020390c <vmm_init>
    sched_init();
ffffffffc0200096:	33b050ef          	jal	ffffffffc0205bd0 <sched_init>
    proc_init(); // init process table
ffffffffc020009a:	7bc050ef          	jal	ffffffffc0205856 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009e:	416000ef          	jal	ffffffffc02004b4 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc02000a2:	013000ef          	jal	ffffffffc02008b4 <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a6:	151050ef          	jal	ffffffffc02059f6 <cpu_idle>

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
ffffffffc02000be:	2b650513          	addi	a0,a0,694 # ffffffffc0206370 <etext+0x2c>
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
ffffffffc02000ca:	000c8997          	auipc	s3,0xc8
ffffffffc02000ce:	bce98993          	addi	s3,s3,-1074 # ffffffffc02c7c98 <buf>
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
ffffffffc0200144:	000c8517          	auipc	a0,0xc8
ffffffffc0200148:	b5450513          	addi	a0,a0,-1196 # ffffffffc02c7c98 <buf>
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
ffffffffc0200166:	398000ef          	jal	ffffffffc02004fe <cons_putc>
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
ffffffffc020018c:	575050ef          	jal	ffffffffc0205f00 <vprintfmt>
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
ffffffffc02001c0:	541050ef          	jal	ffffffffc0205f00 <vprintfmt>
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
ffffffffc02001cc:	ae0d                	j	ffffffffc02004fe <cons_putc>

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
ffffffffc02001e2:	31c000ef          	jal	ffffffffc02004fe <cons_putc>
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
ffffffffc02001fa:	304000ef          	jal	ffffffffc02004fe <cons_putc>
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
ffffffffc020020a:	2f4000ef          	jal	ffffffffc02004fe <cons_putc>
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
ffffffffc020021e:	314000ef          	jal	ffffffffc0200532 <cons_getc>
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
ffffffffc0200230:	14c50513          	addi	a0,a0,332 # ffffffffc0206378 <etext+0x34>
void print_kerninfo(void) {
ffffffffc0200234:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200236:	f63ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020023a:	00000597          	auipc	a1,0x0
ffffffffc020023e:	e1058593          	addi	a1,a1,-496 # ffffffffc020004a <kern_init>
ffffffffc0200242:	00006517          	auipc	a0,0x6
ffffffffc0200246:	15650513          	addi	a0,a0,342 # ffffffffc0206398 <etext+0x54>
ffffffffc020024a:	f4fff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020024e:	00006597          	auipc	a1,0x6
ffffffffc0200252:	0f658593          	addi	a1,a1,246 # ffffffffc0206344 <etext>
ffffffffc0200256:	00006517          	auipc	a0,0x6
ffffffffc020025a:	16250513          	addi	a0,a0,354 # ffffffffc02063b8 <etext+0x74>
ffffffffc020025e:	f3bff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200262:	000c8597          	auipc	a1,0xc8
ffffffffc0200266:	a3658593          	addi	a1,a1,-1482 # ffffffffc02c7c98 <buf>
ffffffffc020026a:	00006517          	auipc	a0,0x6
ffffffffc020026e:	16e50513          	addi	a0,a0,366 # ffffffffc02063d8 <etext+0x94>
ffffffffc0200272:	f27ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200276:	000cc597          	auipc	a1,0xcc
ffffffffc020027a:	05258593          	addi	a1,a1,82 # ffffffffc02cc2c8 <end>
ffffffffc020027e:	00006517          	auipc	a0,0x6
ffffffffc0200282:	17a50513          	addi	a0,a0,378 # ffffffffc02063f8 <etext+0xb4>
ffffffffc0200286:	f13ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020028a:	00000717          	auipc	a4,0x0
ffffffffc020028e:	dc070713          	addi	a4,a4,-576 # ffffffffc020004a <kern_init>
ffffffffc0200292:	000cc797          	auipc	a5,0xcc
ffffffffc0200296:	43578793          	addi	a5,a5,1077 # ffffffffc02cc6c7 <end+0x3ff>
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
ffffffffc02002ae:	16e50513          	addi	a0,a0,366 # ffffffffc0206418 <etext+0xd4>
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
ffffffffc02002bc:	19060613          	addi	a2,a2,400 # ffffffffc0206448 <etext+0x104>
ffffffffc02002c0:	04e00593          	li	a1,78
ffffffffc02002c4:	00006517          	auipc	a0,0x6
ffffffffc02002c8:	19c50513          	addi	a0,a0,412 # ffffffffc0206460 <etext+0x11c>
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
ffffffffc02002de:	2ae40413          	addi	s0,s0,686 # ffffffffc0208588 <commands>
ffffffffc02002e2:	00008497          	auipc	s1,0x8
ffffffffc02002e6:	2ee48493          	addi	s1,s1,750 # ffffffffc02085d0 <commands+0x48>
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002ea:	6410                	ld	a2,8(s0)
ffffffffc02002ec:	600c                	ld	a1,0(s0)
ffffffffc02002ee:	00006517          	auipc	a0,0x6
ffffffffc02002f2:	18a50513          	addi	a0,a0,394 # ffffffffc0206478 <etext+0x134>
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
ffffffffc0200336:	15650513          	addi	a0,a0,342 # ffffffffc0206488 <etext+0x144>
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
ffffffffc020034e:	16650513          	addi	a0,a0,358 # ffffffffc02064b0 <etext+0x16c>
ffffffffc0200352:	e47ff0ef          	jal	ffffffffc0200198 <cprintf>
    if (tf != NULL) {
ffffffffc0200356:	000a0563          	beqz	s4,ffffffffc0200360 <kmonitor+0x34>
        print_trapframe(tf);
ffffffffc020035a:	8552                	mv	a0,s4
ffffffffc020035c:	74e000ef          	jal	ffffffffc0200aaa <print_trapframe>
ffffffffc0200360:	00008a97          	auipc	s5,0x8
ffffffffc0200364:	228a8a93          	addi	s5,s5,552 # ffffffffc0208588 <commands>
        if (argc == MAXARGS - 1) {
ffffffffc0200368:	49bd                	li	s3,15
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020036a:	00006517          	auipc	a0,0x6
ffffffffc020036e:	16e50513          	addi	a0,a0,366 # ffffffffc02064d8 <etext+0x194>
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
ffffffffc020038c:	20048493          	addi	s1,s1,512 # ffffffffc0208588 <commands>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200390:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200392:	6582                	ld	a1,0(sp)
ffffffffc0200394:	6088                	ld	a0,0(s1)
ffffffffc0200396:	717050ef          	jal	ffffffffc02062ac <strcmp>
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
ffffffffc02003ac:	16050513          	addi	a0,a0,352 # ffffffffc0206508 <etext+0x1c4>
ffffffffc02003b0:	de9ff0ef          	jal	ffffffffc0200198 <cprintf>
    return 0;
ffffffffc02003b4:	bf5d                	j	ffffffffc020036a <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003b6:	00006517          	auipc	a0,0x6
ffffffffc02003ba:	12a50513          	addi	a0,a0,298 # ffffffffc02064e0 <etext+0x19c>
ffffffffc02003be:	74b050ef          	jal	ffffffffc0206308 <strchr>
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
ffffffffc02003fc:	0e850513          	addi	a0,a0,232 # ffffffffc02064e0 <etext+0x19c>
ffffffffc0200400:	709050ef          	jal	ffffffffc0206308 <strchr>
ffffffffc0200404:	d575                	beqz	a0,ffffffffc02003f0 <kmonitor+0xc4>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200406:	00044583          	lbu	a1,0(s0)
ffffffffc020040a:	dda5                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc020040c:	b76d                	j	ffffffffc02003b6 <kmonitor+0x8a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020040e:	45c1                	li	a1,16
ffffffffc0200410:	00006517          	auipc	a0,0x6
ffffffffc0200414:	0d850513          	addi	a0,a0,216 # ffffffffc02064e8 <etext+0x1a4>
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
ffffffffc020044a:	000cc317          	auipc	t1,0xcc
ffffffffc020044e:	df633303          	ld	t1,-522(t1) # ffffffffc02cc240 <is_panic>
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
ffffffffc0200474:	14050513          	addi	a0,a0,320 # ffffffffc02065b0 <etext+0x26c>
    is_panic = 1;
ffffffffc0200478:	000cc697          	auipc	a3,0xcc
ffffffffc020047c:	dce6b423          	sd	a4,-568(a3) # ffffffffc02cc240 <is_panic>
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
ffffffffc0200492:	14250513          	addi	a0,a0,322 # ffffffffc02065d0 <etext+0x28c>
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
ffffffffc02004a8:	412000ef          	jal	ffffffffc02008ba <intr_disable>
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
ffffffffc02004c2:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0xcfb8>
ffffffffc02004c6:	953e                	add	a0,a0,a5
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc02004c8:	4581                	li	a1,0
ffffffffc02004ca:	4601                	li	a2,0
ffffffffc02004cc:	4881                	li	a7,0
ffffffffc02004ce:	00000073          	ecall
    cprintf("++ setup timer interrupts\n");
ffffffffc02004d2:	00006517          	auipc	a0,0x6
ffffffffc02004d6:	10650513          	addi	a0,a0,262 # ffffffffc02065d8 <etext+0x294>
    ticks = 0;
ffffffffc02004da:	000cc797          	auipc	a5,0xcc
ffffffffc02004de:	d607b723          	sd	zero,-658(a5) # ffffffffc02cc248 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc02004e2:	b95d                	j	ffffffffc0200198 <cprintf>

ffffffffc02004e4 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02004e4:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02004e8:	67e1                	lui	a5,0x18
ffffffffc02004ea:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0xcfb8>
ffffffffc02004ee:	953e                	add	a0,a0,a5
ffffffffc02004f0:	4581                	li	a1,0
ffffffffc02004f2:	4601                	li	a2,0
ffffffffc02004f4:	4881                	li	a7,0
ffffffffc02004f6:	00000073          	ecall
ffffffffc02004fa:	8082                	ret

ffffffffc02004fc <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc02004fc:	8082                	ret

ffffffffc02004fe <cons_putc>:
#include <riscv.h>
#include <assert.h>
#include <atomic.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02004fe:	100027f3          	csrr	a5,sstatus
ffffffffc0200502:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200504:	0ff57513          	zext.b	a0,a0
ffffffffc0200508:	e799                	bnez	a5,ffffffffc0200516 <cons_putc+0x18>
ffffffffc020050a:	4581                	li	a1,0
ffffffffc020050c:	4601                	li	a2,0
ffffffffc020050e:	4885                	li	a7,1
ffffffffc0200510:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc0200514:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200516:	1101                	addi	sp,sp,-32
ffffffffc0200518:	ec06                	sd	ra,24(sp)
ffffffffc020051a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020051c:	39e000ef          	jal	ffffffffc02008ba <intr_disable>
ffffffffc0200520:	6522                	ld	a0,8(sp)
ffffffffc0200522:	4581                	li	a1,0
ffffffffc0200524:	4601                	li	a2,0
ffffffffc0200526:	4885                	li	a7,1
ffffffffc0200528:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc020052c:	60e2                	ld	ra,24(sp)
ffffffffc020052e:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0200530:	a651                	j	ffffffffc02008b4 <intr_enable>

ffffffffc0200532 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200532:	100027f3          	csrr	a5,sstatus
ffffffffc0200536:	8b89                	andi	a5,a5,2
ffffffffc0200538:	eb89                	bnez	a5,ffffffffc020054a <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc020053a:	4501                	li	a0,0
ffffffffc020053c:	4581                	li	a1,0
ffffffffc020053e:	4601                	li	a2,0
ffffffffc0200540:	4889                	li	a7,2
ffffffffc0200542:	00000073          	ecall
ffffffffc0200546:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc0200548:	8082                	ret
int cons_getc(void) {
ffffffffc020054a:	1101                	addi	sp,sp,-32
ffffffffc020054c:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc020054e:	36c000ef          	jal	ffffffffc02008ba <intr_disable>
ffffffffc0200552:	4501                	li	a0,0
ffffffffc0200554:	4581                	li	a1,0
ffffffffc0200556:	4601                	li	a2,0
ffffffffc0200558:	4889                	li	a7,2
ffffffffc020055a:	00000073          	ecall
ffffffffc020055e:	2501                	sext.w	a0,a0
ffffffffc0200560:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0200562:	352000ef          	jal	ffffffffc02008b4 <intr_enable>
}
ffffffffc0200566:	60e2                	ld	ra,24(sp)
ffffffffc0200568:	6522                	ld	a0,8(sp)
ffffffffc020056a:	6105                	addi	sp,sp,32
ffffffffc020056c:	8082                	ret

ffffffffc020056e <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc020056e:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc0200570:	00006517          	auipc	a0,0x6
ffffffffc0200574:	08850513          	addi	a0,a0,136 # ffffffffc02065f8 <etext+0x2b4>
void dtb_init(void) {
ffffffffc0200578:	f406                	sd	ra,40(sp)
ffffffffc020057a:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc020057c:	c1dff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200580:	0000d597          	auipc	a1,0xd
ffffffffc0200584:	a805b583          	ld	a1,-1408(a1) # ffffffffc020d000 <boot_hartid>
ffffffffc0200588:	00006517          	auipc	a0,0x6
ffffffffc020058c:	08050513          	addi	a0,a0,128 # ffffffffc0206608 <etext+0x2c4>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200590:	0000d417          	auipc	s0,0xd
ffffffffc0200594:	a7840413          	addi	s0,s0,-1416 # ffffffffc020d008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200598:	c01ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020059c:	600c                	ld	a1,0(s0)
ffffffffc020059e:	00006517          	auipc	a0,0x6
ffffffffc02005a2:	07a50513          	addi	a0,a0,122 # ffffffffc0206618 <etext+0x2d4>
ffffffffc02005a6:	bf3ff0ef          	jal	ffffffffc0200198 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc02005aa:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc02005ac:	00006517          	auipc	a0,0x6
ffffffffc02005b0:	08450513          	addi	a0,a0,132 # ffffffffc0206630 <etext+0x2ec>
    if (boot_dtb == 0) {
ffffffffc02005b4:	10070163          	beqz	a4,ffffffffc02006b6 <dtb_init+0x148>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc02005b8:	57f5                	li	a5,-3
ffffffffc02005ba:	07fa                	slli	a5,a5,0x1e
ffffffffc02005bc:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc02005be:	431c                	lw	a5,0(a4)
    if (magic != 0xd00dfeed) {
ffffffffc02005c0:	d00e06b7          	lui	a3,0xd00e0
ffffffffc02005c4:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfe13c25>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005c8:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02005cc:	0187961b          	slliw	a2,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005d0:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005d4:	0ff5f593          	zext.b	a1,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005d8:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005dc:	05c2                	slli	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005de:	8e49                	or	a2,a2,a0
ffffffffc02005e0:	0ff7f793          	zext.b	a5,a5
ffffffffc02005e4:	8dd1                	or	a1,a1,a2
ffffffffc02005e6:	07a2                	slli	a5,a5,0x8
ffffffffc02005e8:	8ddd                	or	a1,a1,a5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ea:	00ff0837          	lui	a6,0xff0
    if (magic != 0xd00dfeed) {
ffffffffc02005ee:	0cd59863          	bne	a1,a3,ffffffffc02006be <dtb_init+0x150>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02005f2:	4710                	lw	a2,8(a4)
ffffffffc02005f4:	4754                	lw	a3,12(a4)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02005f6:	e84a                	sd	s2,16(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005f8:	0086541b          	srliw	s0,a2,0x8
ffffffffc02005fc:	0086d79b          	srliw	a5,a3,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200600:	01865e1b          	srliw	t3,a2,0x18
ffffffffc0200604:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200608:	0186151b          	slliw	a0,a2,0x18
ffffffffc020060c:	0186959b          	slliw	a1,a3,0x18
ffffffffc0200610:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200614:	0106561b          	srliw	a2,a2,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200618:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020061c:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200620:	01c56533          	or	a0,a0,t3
ffffffffc0200624:	0115e5b3          	or	a1,a1,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200628:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020062c:	0ff67613          	zext.b	a2,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200630:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200634:	0ff6f693          	zext.b	a3,a3
ffffffffc0200638:	8c49                	or	s0,s0,a0
ffffffffc020063a:	0622                	slli	a2,a2,0x8
ffffffffc020063c:	8fcd                	or	a5,a5,a1
ffffffffc020063e:	06a2                	slli	a3,a3,0x8
ffffffffc0200640:	8c51                	or	s0,s0,a2
ffffffffc0200642:	8fd5                	or	a5,a5,a3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200644:	1402                	slli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200646:	1782                	slli	a5,a5,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200648:	9001                	srli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020064a:	9381                	srli	a5,a5,0x20
ffffffffc020064c:	ec26                	sd	s1,24(sp)
    int in_memory_node = 0;
ffffffffc020064e:	4301                	li	t1,0
        switch (token) {
ffffffffc0200650:	488d                	li	a7,3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200652:	943a                	add	s0,s0,a4
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200654:	00e78933          	add	s2,a5,a4
        switch (token) {
ffffffffc0200658:	4e05                	li	t3,1
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020065a:	4018                	lw	a4,0(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020065c:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200660:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200664:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200668:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020066c:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200670:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200674:	8ed1                	or	a3,a3,a2
ffffffffc0200676:	0ff77713          	zext.b	a4,a4
ffffffffc020067a:	8fd5                	or	a5,a5,a3
ffffffffc020067c:	0722                	slli	a4,a4,0x8
ffffffffc020067e:	8fd9                	or	a5,a5,a4
        switch (token) {
ffffffffc0200680:	05178763          	beq	a5,a7,ffffffffc02006ce <dtb_init+0x160>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200684:	0411                	addi	s0,s0,4
        switch (token) {
ffffffffc0200686:	00f8e963          	bltu	a7,a5,ffffffffc0200698 <dtb_init+0x12a>
ffffffffc020068a:	07c78d63          	beq	a5,t3,ffffffffc0200704 <dtb_init+0x196>
ffffffffc020068e:	4709                	li	a4,2
ffffffffc0200690:	00e79763          	bne	a5,a4,ffffffffc020069e <dtb_init+0x130>
ffffffffc0200694:	4301                	li	t1,0
ffffffffc0200696:	b7d1                	j	ffffffffc020065a <dtb_init+0xec>
ffffffffc0200698:	4711                	li	a4,4
ffffffffc020069a:	fce780e3          	beq	a5,a4,ffffffffc020065a <dtb_init+0xec>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc020069e:	00006517          	auipc	a0,0x6
ffffffffc02006a2:	05a50513          	addi	a0,a0,90 # ffffffffc02066f8 <etext+0x3b4>
ffffffffc02006a6:	af3ff0ef          	jal	ffffffffc0200198 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02006aa:	64e2                	ld	s1,24(sp)
ffffffffc02006ac:	6942                	ld	s2,16(sp)
ffffffffc02006ae:	00006517          	auipc	a0,0x6
ffffffffc02006b2:	08250513          	addi	a0,a0,130 # ffffffffc0206730 <etext+0x3ec>
}
ffffffffc02006b6:	7402                	ld	s0,32(sp)
ffffffffc02006b8:	70a2                	ld	ra,40(sp)
ffffffffc02006ba:	6145                	addi	sp,sp,48
    cprintf("DTB init completed\n");
ffffffffc02006bc:	bcf1                	j	ffffffffc0200198 <cprintf>
}
ffffffffc02006be:	7402                	ld	s0,32(sp)
ffffffffc02006c0:	70a2                	ld	ra,40(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02006c2:	00006517          	auipc	a0,0x6
ffffffffc02006c6:	f8e50513          	addi	a0,a0,-114 # ffffffffc0206650 <etext+0x30c>
}
ffffffffc02006ca:	6145                	addi	sp,sp,48
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02006cc:	b4f1                	j	ffffffffc0200198 <cprintf>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006ce:	4058                	lw	a4,4(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006d0:	0087579b          	srliw	a5,a4,0x8
ffffffffc02006d4:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006d8:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006dc:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006e0:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006e4:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006e8:	8ed1                	or	a3,a3,a2
ffffffffc02006ea:	0ff77713          	zext.b	a4,a4
ffffffffc02006ee:	8fd5                	or	a5,a5,a3
ffffffffc02006f0:	0722                	slli	a4,a4,0x8
ffffffffc02006f2:	8fd9                	or	a5,a5,a4
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006f4:	04031463          	bnez	t1,ffffffffc020073c <dtb_init+0x1ce>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02006f8:	1782                	slli	a5,a5,0x20
ffffffffc02006fa:	9381                	srli	a5,a5,0x20
ffffffffc02006fc:	043d                	addi	s0,s0,15
ffffffffc02006fe:	943e                	add	s0,s0,a5
ffffffffc0200700:	9871                	andi	s0,s0,-4
                break;
ffffffffc0200702:	bfa1                	j	ffffffffc020065a <dtb_init+0xec>
                int name_len = strlen(name);
ffffffffc0200704:	8522                	mv	a0,s0
ffffffffc0200706:	e01a                	sd	t1,0(sp)
ffffffffc0200708:	35f050ef          	jal	ffffffffc0206266 <strlen>
ffffffffc020070c:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020070e:	4619                	li	a2,6
ffffffffc0200710:	8522                	mv	a0,s0
ffffffffc0200712:	00006597          	auipc	a1,0x6
ffffffffc0200716:	f6658593          	addi	a1,a1,-154 # ffffffffc0206678 <etext+0x334>
ffffffffc020071a:	3c7050ef          	jal	ffffffffc02062e0 <strncmp>
ffffffffc020071e:	6302                	ld	t1,0(sp)
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200720:	0411                	addi	s0,s0,4
ffffffffc0200722:	0004879b          	sext.w	a5,s1
ffffffffc0200726:	943e                	add	s0,s0,a5
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200728:	00153513          	seqz	a0,a0
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc020072c:	9871                	andi	s0,s0,-4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020072e:	00a36333          	or	t1,t1,a0
                break;
ffffffffc0200732:	00ff0837          	lui	a6,0xff0
ffffffffc0200736:	488d                	li	a7,3
ffffffffc0200738:	4e05                	li	t3,1
ffffffffc020073a:	b705                	j	ffffffffc020065a <dtb_init+0xec>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020073c:	4418                	lw	a4,8(s0)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020073e:	00006597          	auipc	a1,0x6
ffffffffc0200742:	f4258593          	addi	a1,a1,-190 # ffffffffc0206680 <etext+0x33c>
ffffffffc0200746:	e43e                	sd	a5,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200748:	0087551b          	srliw	a0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020074c:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200750:	0187169b          	slliw	a3,a4,0x18
ffffffffc0200754:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200758:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020075c:	01057533          	and	a0,a0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200760:	8ed1                	or	a3,a3,a2
ffffffffc0200762:	0ff77713          	zext.b	a4,a4
ffffffffc0200766:	0722                	slli	a4,a4,0x8
ffffffffc0200768:	8d55                	or	a0,a0,a3
ffffffffc020076a:	8d59                	or	a0,a0,a4
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc020076c:	1502                	slli	a0,a0,0x20
ffffffffc020076e:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200770:	954a                	add	a0,a0,s2
ffffffffc0200772:	e01a                	sd	t1,0(sp)
ffffffffc0200774:	339050ef          	jal	ffffffffc02062ac <strcmp>
ffffffffc0200778:	67a2                	ld	a5,8(sp)
ffffffffc020077a:	473d                	li	a4,15
ffffffffc020077c:	6302                	ld	t1,0(sp)
ffffffffc020077e:	00ff0837          	lui	a6,0xff0
ffffffffc0200782:	488d                	li	a7,3
ffffffffc0200784:	4e05                	li	t3,1
ffffffffc0200786:	f6f779e3          	bgeu	a4,a5,ffffffffc02006f8 <dtb_init+0x18a>
ffffffffc020078a:	f53d                	bnez	a0,ffffffffc02006f8 <dtb_init+0x18a>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020078c:	00c43683          	ld	a3,12(s0)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc0200790:	01443703          	ld	a4,20(s0)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200794:	00006517          	auipc	a0,0x6
ffffffffc0200798:	ef450513          	addi	a0,a0,-268 # ffffffffc0206688 <etext+0x344>
           fdt32_to_cpu(x >> 32);
ffffffffc020079c:	4206d793          	srai	a5,a3,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007a0:	0087d31b          	srliw	t1,a5,0x8
ffffffffc02007a4:	00871f93          	slli	t6,a4,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02007a8:	42075893          	srai	a7,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007ac:	0187df1b          	srliw	t5,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007b0:	0187959b          	slliw	a1,a5,0x18
ffffffffc02007b4:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007b8:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007bc:	420fd613          	srai	a2,t6,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007c0:	0188de9b          	srliw	t4,a7,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007c4:	01037333          	and	t1,t1,a6
ffffffffc02007c8:	01889e1b          	slliw	t3,a7,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007cc:	01e5e5b3          	or	a1,a1,t5
ffffffffc02007d0:	0ff7f793          	zext.b	a5,a5
ffffffffc02007d4:	01de6e33          	or	t3,t3,t4
ffffffffc02007d8:	0065e5b3          	or	a1,a1,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007dc:	01067633          	and	a2,a2,a6
ffffffffc02007e0:	0086d31b          	srliw	t1,a3,0x8
ffffffffc02007e4:	0087541b          	srliw	s0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007e8:	07a2                	slli	a5,a5,0x8
ffffffffc02007ea:	0108d89b          	srliw	a7,a7,0x10
ffffffffc02007ee:	0186df1b          	srliw	t5,a3,0x18
ffffffffc02007f2:	01875e9b          	srliw	t4,a4,0x18
ffffffffc02007f6:	8ddd                	or	a1,a1,a5
ffffffffc02007f8:	01c66633          	or	a2,a2,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007fc:	0186979b          	slliw	a5,a3,0x18
ffffffffc0200800:	01871e1b          	slliw	t3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200804:	0ff8f893          	zext.b	a7,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200808:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020080c:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200810:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200814:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200818:	01037333          	and	t1,t1,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020081c:	08a2                	slli	a7,a7,0x8
ffffffffc020081e:	01e7e7b3          	or	a5,a5,t5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200822:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200826:	0ff6f693          	zext.b	a3,a3
ffffffffc020082a:	01de6833          	or	a6,t3,t4
ffffffffc020082e:	0ff77713          	zext.b	a4,a4
ffffffffc0200832:	01166633          	or	a2,a2,a7
ffffffffc0200836:	0067e7b3          	or	a5,a5,t1
ffffffffc020083a:	06a2                	slli	a3,a3,0x8
ffffffffc020083c:	01046433          	or	s0,s0,a6
ffffffffc0200840:	0722                	slli	a4,a4,0x8
ffffffffc0200842:	8fd5                	or	a5,a5,a3
ffffffffc0200844:	8c59                	or	s0,s0,a4
           fdt32_to_cpu(x >> 32);
ffffffffc0200846:	1582                	slli	a1,a1,0x20
ffffffffc0200848:	1602                	slli	a2,a2,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020084a:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020084c:	9201                	srli	a2,a2,0x20
ffffffffc020084e:	9181                	srli	a1,a1,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200850:	1402                	slli	s0,s0,0x20
ffffffffc0200852:	00b7e4b3          	or	s1,a5,a1
ffffffffc0200856:	8c51                	or	s0,s0,a2
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200858:	941ff0ef          	jal	ffffffffc0200198 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc020085c:	85a6                	mv	a1,s1
ffffffffc020085e:	00006517          	auipc	a0,0x6
ffffffffc0200862:	e4a50513          	addi	a0,a0,-438 # ffffffffc02066a8 <etext+0x364>
ffffffffc0200866:	933ff0ef          	jal	ffffffffc0200198 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020086a:	01445613          	srli	a2,s0,0x14
ffffffffc020086e:	85a2                	mv	a1,s0
ffffffffc0200870:	00006517          	auipc	a0,0x6
ffffffffc0200874:	e5050513          	addi	a0,a0,-432 # ffffffffc02066c0 <etext+0x37c>
ffffffffc0200878:	921ff0ef          	jal	ffffffffc0200198 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020087c:	009405b3          	add	a1,s0,s1
ffffffffc0200880:	15fd                	addi	a1,a1,-1
ffffffffc0200882:	00006517          	auipc	a0,0x6
ffffffffc0200886:	e5e50513          	addi	a0,a0,-418 # ffffffffc02066e0 <etext+0x39c>
ffffffffc020088a:	90fff0ef          	jal	ffffffffc0200198 <cprintf>
        memory_base = mem_base;
ffffffffc020088e:	000cc797          	auipc	a5,0xcc
ffffffffc0200892:	9c97b523          	sd	s1,-1590(a5) # ffffffffc02cc258 <memory_base>
        memory_size = mem_size;
ffffffffc0200896:	000cc797          	auipc	a5,0xcc
ffffffffc020089a:	9a87bd23          	sd	s0,-1606(a5) # ffffffffc02cc250 <memory_size>
ffffffffc020089e:	b531                	j	ffffffffc02006aa <dtb_init+0x13c>

ffffffffc02008a0 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02008a0:	000cc517          	auipc	a0,0xcc
ffffffffc02008a4:	9b853503          	ld	a0,-1608(a0) # ffffffffc02cc258 <memory_base>
ffffffffc02008a8:	8082                	ret

ffffffffc02008aa <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02008aa:	000cc517          	auipc	a0,0xcc
ffffffffc02008ae:	9a653503          	ld	a0,-1626(a0) # ffffffffc02cc250 <memory_size>
ffffffffc02008b2:	8082                	ret

ffffffffc02008b4 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02008b4:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02008b8:	8082                	ret

ffffffffc02008ba <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02008ba:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02008be:	8082                	ret

ffffffffc02008c0 <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02008c0:	8082                	ret

ffffffffc02008c2 <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02008c2:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02008c6:	00000797          	auipc	a5,0x0
ffffffffc02008ca:	46e78793          	addi	a5,a5,1134 # ffffffffc0200d34 <__alltraps>
ffffffffc02008ce:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02008d2:	000407b7          	lui	a5,0x40
ffffffffc02008d6:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02008da:	8082                	ret

ffffffffc02008dc <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02008dc:	610c                	ld	a1,0(a0)
{
ffffffffc02008de:	1141                	addi	sp,sp,-16
ffffffffc02008e0:	e022                	sd	s0,0(sp)
ffffffffc02008e2:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02008e4:	00006517          	auipc	a0,0x6
ffffffffc02008e8:	e6450513          	addi	a0,a0,-412 # ffffffffc0206748 <etext+0x404>
{
ffffffffc02008ec:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02008ee:	8abff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02008f2:	640c                	ld	a1,8(s0)
ffffffffc02008f4:	00006517          	auipc	a0,0x6
ffffffffc02008f8:	e6c50513          	addi	a0,a0,-404 # ffffffffc0206760 <etext+0x41c>
ffffffffc02008fc:	89dff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc0200900:	680c                	ld	a1,16(s0)
ffffffffc0200902:	00006517          	auipc	a0,0x6
ffffffffc0200906:	e7650513          	addi	a0,a0,-394 # ffffffffc0206778 <etext+0x434>
ffffffffc020090a:	88fff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc020090e:	6c0c                	ld	a1,24(s0)
ffffffffc0200910:	00006517          	auipc	a0,0x6
ffffffffc0200914:	e8050513          	addi	a0,a0,-384 # ffffffffc0206790 <etext+0x44c>
ffffffffc0200918:	881ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc020091c:	700c                	ld	a1,32(s0)
ffffffffc020091e:	00006517          	auipc	a0,0x6
ffffffffc0200922:	e8a50513          	addi	a0,a0,-374 # ffffffffc02067a8 <etext+0x464>
ffffffffc0200926:	873ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc020092a:	740c                	ld	a1,40(s0)
ffffffffc020092c:	00006517          	auipc	a0,0x6
ffffffffc0200930:	e9450513          	addi	a0,a0,-364 # ffffffffc02067c0 <etext+0x47c>
ffffffffc0200934:	865ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200938:	780c                	ld	a1,48(s0)
ffffffffc020093a:	00006517          	auipc	a0,0x6
ffffffffc020093e:	e9e50513          	addi	a0,a0,-354 # ffffffffc02067d8 <etext+0x494>
ffffffffc0200942:	857ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200946:	7c0c                	ld	a1,56(s0)
ffffffffc0200948:	00006517          	auipc	a0,0x6
ffffffffc020094c:	ea850513          	addi	a0,a0,-344 # ffffffffc02067f0 <etext+0x4ac>
ffffffffc0200950:	849ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200954:	602c                	ld	a1,64(s0)
ffffffffc0200956:	00006517          	auipc	a0,0x6
ffffffffc020095a:	eb250513          	addi	a0,a0,-334 # ffffffffc0206808 <etext+0x4c4>
ffffffffc020095e:	83bff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200962:	642c                	ld	a1,72(s0)
ffffffffc0200964:	00006517          	auipc	a0,0x6
ffffffffc0200968:	ebc50513          	addi	a0,a0,-324 # ffffffffc0206820 <etext+0x4dc>
ffffffffc020096c:	82dff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200970:	682c                	ld	a1,80(s0)
ffffffffc0200972:	00006517          	auipc	a0,0x6
ffffffffc0200976:	ec650513          	addi	a0,a0,-314 # ffffffffc0206838 <etext+0x4f4>
ffffffffc020097a:	81fff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc020097e:	6c2c                	ld	a1,88(s0)
ffffffffc0200980:	00006517          	auipc	a0,0x6
ffffffffc0200984:	ed050513          	addi	a0,a0,-304 # ffffffffc0206850 <etext+0x50c>
ffffffffc0200988:	811ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc020098c:	702c                	ld	a1,96(s0)
ffffffffc020098e:	00006517          	auipc	a0,0x6
ffffffffc0200992:	eda50513          	addi	a0,a0,-294 # ffffffffc0206868 <etext+0x524>
ffffffffc0200996:	803ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc020099a:	742c                	ld	a1,104(s0)
ffffffffc020099c:	00006517          	auipc	a0,0x6
ffffffffc02009a0:	ee450513          	addi	a0,a0,-284 # ffffffffc0206880 <etext+0x53c>
ffffffffc02009a4:	ff4ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc02009a8:	782c                	ld	a1,112(s0)
ffffffffc02009aa:	00006517          	auipc	a0,0x6
ffffffffc02009ae:	eee50513          	addi	a0,a0,-274 # ffffffffc0206898 <etext+0x554>
ffffffffc02009b2:	fe6ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc02009b6:	7c2c                	ld	a1,120(s0)
ffffffffc02009b8:	00006517          	auipc	a0,0x6
ffffffffc02009bc:	ef850513          	addi	a0,a0,-264 # ffffffffc02068b0 <etext+0x56c>
ffffffffc02009c0:	fd8ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc02009c4:	604c                	ld	a1,128(s0)
ffffffffc02009c6:	00006517          	auipc	a0,0x6
ffffffffc02009ca:	f0250513          	addi	a0,a0,-254 # ffffffffc02068c8 <etext+0x584>
ffffffffc02009ce:	fcaff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc02009d2:	644c                	ld	a1,136(s0)
ffffffffc02009d4:	00006517          	auipc	a0,0x6
ffffffffc02009d8:	f0c50513          	addi	a0,a0,-244 # ffffffffc02068e0 <etext+0x59c>
ffffffffc02009dc:	fbcff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc02009e0:	684c                	ld	a1,144(s0)
ffffffffc02009e2:	00006517          	auipc	a0,0x6
ffffffffc02009e6:	f1650513          	addi	a0,a0,-234 # ffffffffc02068f8 <etext+0x5b4>
ffffffffc02009ea:	faeff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc02009ee:	6c4c                	ld	a1,152(s0)
ffffffffc02009f0:	00006517          	auipc	a0,0x6
ffffffffc02009f4:	f2050513          	addi	a0,a0,-224 # ffffffffc0206910 <etext+0x5cc>
ffffffffc02009f8:	fa0ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc02009fc:	704c                	ld	a1,160(s0)
ffffffffc02009fe:	00006517          	auipc	a0,0x6
ffffffffc0200a02:	f2a50513          	addi	a0,a0,-214 # ffffffffc0206928 <etext+0x5e4>
ffffffffc0200a06:	f92ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200a0a:	744c                	ld	a1,168(s0)
ffffffffc0200a0c:	00006517          	auipc	a0,0x6
ffffffffc0200a10:	f3450513          	addi	a0,a0,-204 # ffffffffc0206940 <etext+0x5fc>
ffffffffc0200a14:	f84ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200a18:	784c                	ld	a1,176(s0)
ffffffffc0200a1a:	00006517          	auipc	a0,0x6
ffffffffc0200a1e:	f3e50513          	addi	a0,a0,-194 # ffffffffc0206958 <etext+0x614>
ffffffffc0200a22:	f76ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200a26:	7c4c                	ld	a1,184(s0)
ffffffffc0200a28:	00006517          	auipc	a0,0x6
ffffffffc0200a2c:	f4850513          	addi	a0,a0,-184 # ffffffffc0206970 <etext+0x62c>
ffffffffc0200a30:	f68ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200a34:	606c                	ld	a1,192(s0)
ffffffffc0200a36:	00006517          	auipc	a0,0x6
ffffffffc0200a3a:	f5250513          	addi	a0,a0,-174 # ffffffffc0206988 <etext+0x644>
ffffffffc0200a3e:	f5aff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200a42:	646c                	ld	a1,200(s0)
ffffffffc0200a44:	00006517          	auipc	a0,0x6
ffffffffc0200a48:	f5c50513          	addi	a0,a0,-164 # ffffffffc02069a0 <etext+0x65c>
ffffffffc0200a4c:	f4cff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200a50:	686c                	ld	a1,208(s0)
ffffffffc0200a52:	00006517          	auipc	a0,0x6
ffffffffc0200a56:	f6650513          	addi	a0,a0,-154 # ffffffffc02069b8 <etext+0x674>
ffffffffc0200a5a:	f3eff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200a5e:	6c6c                	ld	a1,216(s0)
ffffffffc0200a60:	00006517          	auipc	a0,0x6
ffffffffc0200a64:	f7050513          	addi	a0,a0,-144 # ffffffffc02069d0 <etext+0x68c>
ffffffffc0200a68:	f30ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200a6c:	706c                	ld	a1,224(s0)
ffffffffc0200a6e:	00006517          	auipc	a0,0x6
ffffffffc0200a72:	f7a50513          	addi	a0,a0,-134 # ffffffffc02069e8 <etext+0x6a4>
ffffffffc0200a76:	f22ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200a7a:	746c                	ld	a1,232(s0)
ffffffffc0200a7c:	00006517          	auipc	a0,0x6
ffffffffc0200a80:	f8450513          	addi	a0,a0,-124 # ffffffffc0206a00 <etext+0x6bc>
ffffffffc0200a84:	f14ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200a88:	786c                	ld	a1,240(s0)
ffffffffc0200a8a:	00006517          	auipc	a0,0x6
ffffffffc0200a8e:	f8e50513          	addi	a0,a0,-114 # ffffffffc0206a18 <etext+0x6d4>
ffffffffc0200a92:	f06ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a96:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200a98:	6402                	ld	s0,0(sp)
ffffffffc0200a9a:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a9c:	00006517          	auipc	a0,0x6
ffffffffc0200aa0:	f9450513          	addi	a0,a0,-108 # ffffffffc0206a30 <etext+0x6ec>
}
ffffffffc0200aa4:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200aa6:	ef2ff06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0200aaa <print_trapframe>:
{
ffffffffc0200aaa:	1141                	addi	sp,sp,-16
ffffffffc0200aac:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200aae:	85aa                	mv	a1,a0
{
ffffffffc0200ab0:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200ab2:	00006517          	auipc	a0,0x6
ffffffffc0200ab6:	f9650513          	addi	a0,a0,-106 # ffffffffc0206a48 <etext+0x704>
{
ffffffffc0200aba:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200abc:	edcff0ef          	jal	ffffffffc0200198 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200ac0:	8522                	mv	a0,s0
ffffffffc0200ac2:	e1bff0ef          	jal	ffffffffc02008dc <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200ac6:	10043583          	ld	a1,256(s0)
ffffffffc0200aca:	00006517          	auipc	a0,0x6
ffffffffc0200ace:	f9650513          	addi	a0,a0,-106 # ffffffffc0206a60 <etext+0x71c>
ffffffffc0200ad2:	ec6ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200ad6:	10843583          	ld	a1,264(s0)
ffffffffc0200ada:	00006517          	auipc	a0,0x6
ffffffffc0200ade:	f9e50513          	addi	a0,a0,-98 # ffffffffc0206a78 <etext+0x734>
ffffffffc0200ae2:	eb6ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200ae6:	11043583          	ld	a1,272(s0)
ffffffffc0200aea:	00006517          	auipc	a0,0x6
ffffffffc0200aee:	fa650513          	addi	a0,a0,-90 # ffffffffc0206a90 <etext+0x74c>
ffffffffc0200af2:	ea6ff0ef          	jal	ffffffffc0200198 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200af6:	11843583          	ld	a1,280(s0)
}
ffffffffc0200afa:	6402                	ld	s0,0(sp)
ffffffffc0200afc:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200afe:	00006517          	auipc	a0,0x6
ffffffffc0200b02:	fa250513          	addi	a0,a0,-94 # ffffffffc0206aa0 <etext+0x75c>
}
ffffffffc0200b06:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b08:	e90ff06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0200b0c <interrupt_handler>:
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause)
ffffffffc0200b0c:	11853783          	ld	a5,280(a0)
ffffffffc0200b10:	472d                	li	a4,11
ffffffffc0200b12:	0786                	slli	a5,a5,0x1
ffffffffc0200b14:	8385                	srli	a5,a5,0x1
ffffffffc0200b16:	06f76963          	bltu	a4,a5,ffffffffc0200b88 <interrupt_handler+0x7c>
ffffffffc0200b1a:	00008717          	auipc	a4,0x8
ffffffffc0200b1e:	ab670713          	addi	a4,a4,-1354 # ffffffffc02085d0 <commands+0x48>
ffffffffc0200b22:	078a                	slli	a5,a5,0x2
ffffffffc0200b24:	97ba                	add	a5,a5,a4
ffffffffc0200b26:	439c                	lw	a5,0(a5)
ffffffffc0200b28:	97ba                	add	a5,a5,a4
ffffffffc0200b2a:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200b2c:	00006517          	auipc	a0,0x6
ffffffffc0200b30:	fec50513          	addi	a0,a0,-20 # ffffffffc0206b18 <etext+0x7d4>
ffffffffc0200b34:	e64ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200b38:	00006517          	auipc	a0,0x6
ffffffffc0200b3c:	fc050513          	addi	a0,a0,-64 # ffffffffc0206af8 <etext+0x7b4>
ffffffffc0200b40:	e58ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200b44:	00006517          	auipc	a0,0x6
ffffffffc0200b48:	f7450513          	addi	a0,a0,-140 # ffffffffc0206ab8 <etext+0x774>
ffffffffc0200b4c:	e4cff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200b50:	00006517          	auipc	a0,0x6
ffffffffc0200b54:	f8850513          	addi	a0,a0,-120 # ffffffffc0206ad8 <etext+0x794>
ffffffffc0200b58:	e40ff06f          	j	ffffffffc0200198 <cprintf>
{
ffffffffc0200b5c:	1141                	addi	sp,sp,-16
ffffffffc0200b5e:	e406                	sd	ra,8(sp)
        // "All bits besides SSIP and USIP in the sip register are
        // read-only." -- privileged spec1.9.1, 4.1.4, p59
        // In fact, Call sbi_set_timer will clear STIP, or you can clear it
        // directly.
        // clear_csr(sip, SIP_STIP);
        clock_set_next_event();
ffffffffc0200b60:	985ff0ef          	jal	ffffffffc02004e4 <clock_set_next_event>
        ++ticks;
ffffffffc0200b64:	000cb797          	auipc	a5,0xcb
ffffffffc0200b68:	6e47b783          	ld	a5,1764(a5) # ffffffffc02cc248 <ticks>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200b6c:	60a2                	ld	ra,8(sp)
        ++ticks;
ffffffffc0200b6e:	0785                	addi	a5,a5,1
ffffffffc0200b70:	000cb717          	auipc	a4,0xcb
ffffffffc0200b74:	6cf73c23          	sd	a5,1752(a4) # ffffffffc02cc248 <ticks>
}
ffffffffc0200b78:	0141                	addi	sp,sp,16
ffffffffc0200b7a:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200b7c:	00006517          	auipc	a0,0x6
ffffffffc0200b80:	fbc50513          	addi	a0,a0,-68 # ffffffffc0206b38 <etext+0x7f4>
ffffffffc0200b84:	e14ff06f          	j	ffffffffc0200198 <cprintf>
        print_trapframe(tf);
ffffffffc0200b88:	b70d                	j	ffffffffc0200aaa <print_trapframe>

ffffffffc0200b8a <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200b8a:	11853783          	ld	a5,280(a0)
ffffffffc0200b8e:	473d                	li	a4,15
ffffffffc0200b90:	10f76e63          	bltu	a4,a5,ffffffffc0200cac <exception_handler+0x122>
ffffffffc0200b94:	00008717          	auipc	a4,0x8
ffffffffc0200b98:	a6c70713          	addi	a4,a4,-1428 # ffffffffc0208600 <commands+0x78>
ffffffffc0200b9c:	078a                	slli	a5,a5,0x2
ffffffffc0200b9e:	97ba                	add	a5,a5,a4
ffffffffc0200ba0:	439c                	lw	a5,0(a5)
{
ffffffffc0200ba2:	1101                	addi	sp,sp,-32
ffffffffc0200ba4:	ec06                	sd	ra,24(sp)
    switch (tf->cause)
ffffffffc0200ba6:	97ba                	add	a5,a5,a4
ffffffffc0200ba8:	86aa                	mv	a3,a0
ffffffffc0200baa:	8782                	jr	a5
ffffffffc0200bac:	e42a                	sd	a0,8(sp)
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200bae:	00006517          	auipc	a0,0x6
ffffffffc0200bb2:	09250513          	addi	a0,a0,146 # ffffffffc0206c40 <etext+0x8fc>
ffffffffc0200bb6:	de2ff0ef          	jal	ffffffffc0200198 <cprintf>
        tf->epc += 4;
ffffffffc0200bba:	66a2                	ld	a3,8(sp)
ffffffffc0200bbc:	1086b783          	ld	a5,264(a3)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200bc0:	60e2                	ld	ra,24(sp)
        tf->epc += 4;
ffffffffc0200bc2:	0791                	addi	a5,a5,4
ffffffffc0200bc4:	10f6b423          	sd	a5,264(a3)
}
ffffffffc0200bc8:	6105                	addi	sp,sp,32
        syscall();
ffffffffc0200bca:	23c0506f          	j	ffffffffc0205e06 <syscall>
}
ffffffffc0200bce:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from H-mode\n");
ffffffffc0200bd0:	00006517          	auipc	a0,0x6
ffffffffc0200bd4:	09050513          	addi	a0,a0,144 # ffffffffc0206c60 <etext+0x91c>
}
ffffffffc0200bd8:	6105                	addi	sp,sp,32
        cprintf("Environment call from H-mode\n");
ffffffffc0200bda:	dbeff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200bde:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from M-mode\n");
ffffffffc0200be0:	00006517          	auipc	a0,0x6
ffffffffc0200be4:	0a050513          	addi	a0,a0,160 # ffffffffc0206c80 <etext+0x93c>
}
ffffffffc0200be8:	6105                	addi	sp,sp,32
        cprintf("Environment call from M-mode\n");
ffffffffc0200bea:	daeff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200bee:	60e2                	ld	ra,24(sp)
        cprintf("Instruction page fault\n");
ffffffffc0200bf0:	00006517          	auipc	a0,0x6
ffffffffc0200bf4:	0b050513          	addi	a0,a0,176 # ffffffffc0206ca0 <etext+0x95c>
}
ffffffffc0200bf8:	6105                	addi	sp,sp,32
        cprintf("Instruction page fault\n");
ffffffffc0200bfa:	d9eff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200bfe:	60e2                	ld	ra,24(sp)
        cprintf("Load page fault\n");
ffffffffc0200c00:	00006517          	auipc	a0,0x6
ffffffffc0200c04:	0b850513          	addi	a0,a0,184 # ffffffffc0206cb8 <etext+0x974>
}
ffffffffc0200c08:	6105                	addi	sp,sp,32
        cprintf("Load page fault\n");
ffffffffc0200c0a:	d8eff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c0e:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO page fault\n");
ffffffffc0200c10:	00006517          	auipc	a0,0x6
ffffffffc0200c14:	0c050513          	addi	a0,a0,192 # ffffffffc0206cd0 <etext+0x98c>
}
ffffffffc0200c18:	6105                	addi	sp,sp,32
        cprintf("Store/AMO page fault\n");
ffffffffc0200c1a:	d7eff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c1e:	60e2                	ld	ra,24(sp)
        cprintf("Instruction address misaligned\n");
ffffffffc0200c20:	00006517          	auipc	a0,0x6
ffffffffc0200c24:	f3850513          	addi	a0,a0,-200 # ffffffffc0206b58 <etext+0x814>
}
ffffffffc0200c28:	6105                	addi	sp,sp,32
        cprintf("Instruction address misaligned\n");
ffffffffc0200c2a:	d6eff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c2e:	60e2                	ld	ra,24(sp)
        cprintf("Instruction access fault\n");
ffffffffc0200c30:	00006517          	auipc	a0,0x6
ffffffffc0200c34:	f4850513          	addi	a0,a0,-184 # ffffffffc0206b78 <etext+0x834>
}
ffffffffc0200c38:	6105                	addi	sp,sp,32
        cprintf("Instruction access fault\n");
ffffffffc0200c3a:	d5eff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c3e:	60e2                	ld	ra,24(sp)
        cprintf("Illegal instruction\n");
ffffffffc0200c40:	00006517          	auipc	a0,0x6
ffffffffc0200c44:	f5850513          	addi	a0,a0,-168 # ffffffffc0206b98 <etext+0x854>
}
ffffffffc0200c48:	6105                	addi	sp,sp,32
        cprintf("Illegal instruction\n");
ffffffffc0200c4a:	d4eff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c4e:	60e2                	ld	ra,24(sp)
        cprintf("Breakpoint\n");
ffffffffc0200c50:	00006517          	auipc	a0,0x6
ffffffffc0200c54:	f6050513          	addi	a0,a0,-160 # ffffffffc0206bb0 <etext+0x86c>
}
ffffffffc0200c58:	6105                	addi	sp,sp,32
        cprintf("Breakpoint\n");
ffffffffc0200c5a:	d3eff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c5e:	60e2                	ld	ra,24(sp)
        cprintf("Load address misaligned\n");
ffffffffc0200c60:	00006517          	auipc	a0,0x6
ffffffffc0200c64:	f6050513          	addi	a0,a0,-160 # ffffffffc0206bc0 <etext+0x87c>
}
ffffffffc0200c68:	6105                	addi	sp,sp,32
        cprintf("Load address misaligned\n");
ffffffffc0200c6a:	d2eff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c6e:	60e2                	ld	ra,24(sp)
        cprintf("Load access fault\n");
ffffffffc0200c70:	00006517          	auipc	a0,0x6
ffffffffc0200c74:	f7050513          	addi	a0,a0,-144 # ffffffffc0206be0 <etext+0x89c>
}
ffffffffc0200c78:	6105                	addi	sp,sp,32
        cprintf("Load access fault\n");
ffffffffc0200c7a:	d1eff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c7e:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO access fault\n");
ffffffffc0200c80:	00006517          	auipc	a0,0x6
ffffffffc0200c84:	fa850513          	addi	a0,a0,-88 # ffffffffc0206c28 <etext+0x8e4>
}
ffffffffc0200c88:	6105                	addi	sp,sp,32
        cprintf("Store/AMO access fault\n");
ffffffffc0200c8a:	d0eff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c8e:	60e2                	ld	ra,24(sp)
ffffffffc0200c90:	6105                	addi	sp,sp,32
        print_trapframe(tf);
ffffffffc0200c92:	bd21                	j	ffffffffc0200aaa <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200c94:	00006617          	auipc	a2,0x6
ffffffffc0200c98:	f6460613          	addi	a2,a2,-156 # ffffffffc0206bf8 <etext+0x8b4>
ffffffffc0200c9c:	0b000593          	li	a1,176
ffffffffc0200ca0:	00006517          	auipc	a0,0x6
ffffffffc0200ca4:	f7050513          	addi	a0,a0,-144 # ffffffffc0206c10 <etext+0x8cc>
ffffffffc0200ca8:	fa2ff0ef          	jal	ffffffffc020044a <__panic>
        print_trapframe(tf);
ffffffffc0200cac:	bbfd                	j	ffffffffc0200aaa <print_trapframe>

ffffffffc0200cae <trap>:
 * */
void trap(struct trapframe *tf)
{
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200cae:	000cb717          	auipc	a4,0xcb
ffffffffc0200cb2:	5f273703          	ld	a4,1522(a4) # ffffffffc02cc2a0 <current>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200cb6:	11853583          	ld	a1,280(a0)
    if (current == NULL)
ffffffffc0200cba:	cf21                	beqz	a4,ffffffffc0200d12 <trap+0x64>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200cbc:	10053603          	ld	a2,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200cc0:	0a073803          	ld	a6,160(a4)
{
ffffffffc0200cc4:	1101                	addi	sp,sp,-32
ffffffffc0200cc6:	ec06                	sd	ra,24(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200cc8:	10067613          	andi	a2,a2,256
        current->tf = tf;
ffffffffc0200ccc:	f348                	sd	a0,160(a4)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200cce:	e432                	sd	a2,8(sp)
ffffffffc0200cd0:	e042                	sd	a6,0(sp)
ffffffffc0200cd2:	0205c763          	bltz	a1,ffffffffc0200d00 <trap+0x52>
        exception_handler(tf);
ffffffffc0200cd6:	eb5ff0ef          	jal	ffffffffc0200b8a <exception_handler>
ffffffffc0200cda:	6622                	ld	a2,8(sp)
ffffffffc0200cdc:	6802                	ld	a6,0(sp)
ffffffffc0200cde:	000cb697          	auipc	a3,0xcb
ffffffffc0200ce2:	5c268693          	addi	a3,a3,1474 # ffffffffc02cc2a0 <current>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200ce6:	6298                	ld	a4,0(a3)
ffffffffc0200ce8:	0b073023          	sd	a6,160(a4)
        if (!in_kernel)
ffffffffc0200cec:	e619                	bnez	a2,ffffffffc0200cfa <trap+0x4c>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200cee:	0b072783          	lw	a5,176(a4)
ffffffffc0200cf2:	8b85                	andi	a5,a5,1
ffffffffc0200cf4:	e79d                	bnez	a5,ffffffffc0200d22 <trap+0x74>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200cf6:	6f1c                	ld	a5,24(a4)
ffffffffc0200cf8:	e38d                	bnez	a5,ffffffffc0200d1a <trap+0x6c>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200cfa:	60e2                	ld	ra,24(sp)
ffffffffc0200cfc:	6105                	addi	sp,sp,32
ffffffffc0200cfe:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200d00:	e0dff0ef          	jal	ffffffffc0200b0c <interrupt_handler>
ffffffffc0200d04:	6802                	ld	a6,0(sp)
ffffffffc0200d06:	6622                	ld	a2,8(sp)
ffffffffc0200d08:	000cb697          	auipc	a3,0xcb
ffffffffc0200d0c:	59868693          	addi	a3,a3,1432 # ffffffffc02cc2a0 <current>
ffffffffc0200d10:	bfd9                	j	ffffffffc0200ce6 <trap+0x38>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200d12:	0005c363          	bltz	a1,ffffffffc0200d18 <trap+0x6a>
        exception_handler(tf);
ffffffffc0200d16:	bd95                	j	ffffffffc0200b8a <exception_handler>
        interrupt_handler(tf);
ffffffffc0200d18:	bbd5                	j	ffffffffc0200b0c <interrupt_handler>
}
ffffffffc0200d1a:	60e2                	ld	ra,24(sp)
ffffffffc0200d1c:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200d1e:	7ad0406f          	j	ffffffffc0205cca <schedule>
                do_exit(-E_KILLED);
ffffffffc0200d22:	555d                	li	a0,-9
ffffffffc0200d24:	7ed030ef          	jal	ffffffffc0204d10 <do_exit>
            if (current->need_resched)
ffffffffc0200d28:	000cb717          	auipc	a4,0xcb
ffffffffc0200d2c:	57873703          	ld	a4,1400(a4) # ffffffffc02cc2a0 <current>
ffffffffc0200d30:	b7d9                	j	ffffffffc0200cf6 <trap+0x48>
	...

ffffffffc0200d34 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200d34:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200d38:	00011463          	bnez	sp,ffffffffc0200d40 <__alltraps+0xc>
ffffffffc0200d3c:	14002173          	csrr	sp,sscratch
ffffffffc0200d40:	712d                	addi	sp,sp,-288
ffffffffc0200d42:	e002                	sd	zero,0(sp)
ffffffffc0200d44:	e406                	sd	ra,8(sp)
ffffffffc0200d46:	ec0e                	sd	gp,24(sp)
ffffffffc0200d48:	f012                	sd	tp,32(sp)
ffffffffc0200d4a:	f416                	sd	t0,40(sp)
ffffffffc0200d4c:	f81a                	sd	t1,48(sp)
ffffffffc0200d4e:	fc1e                	sd	t2,56(sp)
ffffffffc0200d50:	e0a2                	sd	s0,64(sp)
ffffffffc0200d52:	e4a6                	sd	s1,72(sp)
ffffffffc0200d54:	e8aa                	sd	a0,80(sp)
ffffffffc0200d56:	ecae                	sd	a1,88(sp)
ffffffffc0200d58:	f0b2                	sd	a2,96(sp)
ffffffffc0200d5a:	f4b6                	sd	a3,104(sp)
ffffffffc0200d5c:	f8ba                	sd	a4,112(sp)
ffffffffc0200d5e:	fcbe                	sd	a5,120(sp)
ffffffffc0200d60:	e142                	sd	a6,128(sp)
ffffffffc0200d62:	e546                	sd	a7,136(sp)
ffffffffc0200d64:	e94a                	sd	s2,144(sp)
ffffffffc0200d66:	ed4e                	sd	s3,152(sp)
ffffffffc0200d68:	f152                	sd	s4,160(sp)
ffffffffc0200d6a:	f556                	sd	s5,168(sp)
ffffffffc0200d6c:	f95a                	sd	s6,176(sp)
ffffffffc0200d6e:	fd5e                	sd	s7,184(sp)
ffffffffc0200d70:	e1e2                	sd	s8,192(sp)
ffffffffc0200d72:	e5e6                	sd	s9,200(sp)
ffffffffc0200d74:	e9ea                	sd	s10,208(sp)
ffffffffc0200d76:	edee                	sd	s11,216(sp)
ffffffffc0200d78:	f1f2                	sd	t3,224(sp)
ffffffffc0200d7a:	f5f6                	sd	t4,232(sp)
ffffffffc0200d7c:	f9fa                	sd	t5,240(sp)
ffffffffc0200d7e:	fdfe                	sd	t6,248(sp)
ffffffffc0200d80:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200d84:	100024f3          	csrr	s1,sstatus
ffffffffc0200d88:	14102973          	csrr	s2,sepc
ffffffffc0200d8c:	143029f3          	csrr	s3,stval
ffffffffc0200d90:	14202a73          	csrr	s4,scause
ffffffffc0200d94:	e822                	sd	s0,16(sp)
ffffffffc0200d96:	e226                	sd	s1,256(sp)
ffffffffc0200d98:	e64a                	sd	s2,264(sp)
ffffffffc0200d9a:	ea4e                	sd	s3,272(sp)
ffffffffc0200d9c:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200d9e:	850a                	mv	a0,sp
    jal trap
ffffffffc0200da0:	f0fff0ef          	jal	ffffffffc0200cae <trap>

ffffffffc0200da4 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200da4:	6492                	ld	s1,256(sp)
ffffffffc0200da6:	6932                	ld	s2,264(sp)
ffffffffc0200da8:	1004f413          	andi	s0,s1,256
ffffffffc0200dac:	e401                	bnez	s0,ffffffffc0200db4 <__trapret+0x10>
ffffffffc0200dae:	1200                	addi	s0,sp,288
ffffffffc0200db0:	14041073          	csrw	sscratch,s0
ffffffffc0200db4:	10049073          	csrw	sstatus,s1
ffffffffc0200db8:	14191073          	csrw	sepc,s2
ffffffffc0200dbc:	60a2                	ld	ra,8(sp)
ffffffffc0200dbe:	61e2                	ld	gp,24(sp)
ffffffffc0200dc0:	7202                	ld	tp,32(sp)
ffffffffc0200dc2:	72a2                	ld	t0,40(sp)
ffffffffc0200dc4:	7342                	ld	t1,48(sp)
ffffffffc0200dc6:	73e2                	ld	t2,56(sp)
ffffffffc0200dc8:	6406                	ld	s0,64(sp)
ffffffffc0200dca:	64a6                	ld	s1,72(sp)
ffffffffc0200dcc:	6546                	ld	a0,80(sp)
ffffffffc0200dce:	65e6                	ld	a1,88(sp)
ffffffffc0200dd0:	7606                	ld	a2,96(sp)
ffffffffc0200dd2:	76a6                	ld	a3,104(sp)
ffffffffc0200dd4:	7746                	ld	a4,112(sp)
ffffffffc0200dd6:	77e6                	ld	a5,120(sp)
ffffffffc0200dd8:	680a                	ld	a6,128(sp)
ffffffffc0200dda:	68aa                	ld	a7,136(sp)
ffffffffc0200ddc:	694a                	ld	s2,144(sp)
ffffffffc0200dde:	69ea                	ld	s3,152(sp)
ffffffffc0200de0:	7a0a                	ld	s4,160(sp)
ffffffffc0200de2:	7aaa                	ld	s5,168(sp)
ffffffffc0200de4:	7b4a                	ld	s6,176(sp)
ffffffffc0200de6:	7bea                	ld	s7,184(sp)
ffffffffc0200de8:	6c0e                	ld	s8,192(sp)
ffffffffc0200dea:	6cae                	ld	s9,200(sp)
ffffffffc0200dec:	6d4e                	ld	s10,208(sp)
ffffffffc0200dee:	6dee                	ld	s11,216(sp)
ffffffffc0200df0:	7e0e                	ld	t3,224(sp)
ffffffffc0200df2:	7eae                	ld	t4,232(sp)
ffffffffc0200df4:	7f4e                	ld	t5,240(sp)
ffffffffc0200df6:	7fee                	ld	t6,248(sp)
ffffffffc0200df8:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200dfa:	10200073          	sret

ffffffffc0200dfe <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200dfe:	812a                	mv	sp,a0
ffffffffc0200e00:	b755                	j	ffffffffc0200da4 <__trapret>

ffffffffc0200e02 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200e02:	000c7797          	auipc	a5,0xc7
ffffffffc0200e06:	29678793          	addi	a5,a5,662 # ffffffffc02c8098 <free_area>
ffffffffc0200e0a:	e79c                	sd	a5,8(a5)
ffffffffc0200e0c:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200e0e:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200e12:	8082                	ret

ffffffffc0200e14 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200e14:	000c7517          	auipc	a0,0xc7
ffffffffc0200e18:	29456503          	lwu	a0,660(a0) # ffffffffc02c80a8 <free_area+0x10>
ffffffffc0200e1c:	8082                	ret

ffffffffc0200e1e <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200e1e:	711d                	addi	sp,sp,-96
ffffffffc0200e20:	e0ca                	sd	s2,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200e22:	000c7917          	auipc	s2,0xc7
ffffffffc0200e26:	27690913          	addi	s2,s2,630 # ffffffffc02c8098 <free_area>
ffffffffc0200e2a:	00893783          	ld	a5,8(s2)
ffffffffc0200e2e:	ec86                	sd	ra,88(sp)
ffffffffc0200e30:	e8a2                	sd	s0,80(sp)
ffffffffc0200e32:	e4a6                	sd	s1,72(sp)
ffffffffc0200e34:	fc4e                	sd	s3,56(sp)
ffffffffc0200e36:	f852                	sd	s4,48(sp)
ffffffffc0200e38:	f456                	sd	s5,40(sp)
ffffffffc0200e3a:	f05a                	sd	s6,32(sp)
ffffffffc0200e3c:	ec5e                	sd	s7,24(sp)
ffffffffc0200e3e:	e862                	sd	s8,16(sp)
ffffffffc0200e40:	e466                	sd	s9,8(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e42:	2f278363          	beq	a5,s2,ffffffffc0201128 <default_check+0x30a>
    int count = 0, total = 0;
ffffffffc0200e46:	4401                	li	s0,0
ffffffffc0200e48:	4481                	li	s1,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200e4a:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200e4e:	8b09                	andi	a4,a4,2
ffffffffc0200e50:	2e070063          	beqz	a4,ffffffffc0201130 <default_check+0x312>
        count ++, total += p->property;
ffffffffc0200e54:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200e58:	679c                	ld	a5,8(a5)
ffffffffc0200e5a:	2485                	addiw	s1,s1,1
ffffffffc0200e5c:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e5e:	ff2796e3          	bne	a5,s2,ffffffffc0200e4a <default_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc0200e62:	89a2                	mv	s3,s0
ffffffffc0200e64:	741000ef          	jal	ffffffffc0201da4 <nr_free_pages>
ffffffffc0200e68:	73351463          	bne	a0,s3,ffffffffc0201590 <default_check+0x772>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200e6c:	4505                	li	a0,1
ffffffffc0200e6e:	6c5000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0200e72:	8a2a                	mv	s4,a0
ffffffffc0200e74:	44050e63          	beqz	a0,ffffffffc02012d0 <default_check+0x4b2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200e78:	4505                	li	a0,1
ffffffffc0200e7a:	6b9000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0200e7e:	89aa                	mv	s3,a0
ffffffffc0200e80:	72050863          	beqz	a0,ffffffffc02015b0 <default_check+0x792>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200e84:	4505                	li	a0,1
ffffffffc0200e86:	6ad000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0200e8a:	8aaa                	mv	s5,a0
ffffffffc0200e8c:	4c050263          	beqz	a0,ffffffffc0201350 <default_check+0x532>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200e90:	40a987b3          	sub	a5,s3,a0
ffffffffc0200e94:	40aa0733          	sub	a4,s4,a0
ffffffffc0200e98:	0017b793          	seqz	a5,a5
ffffffffc0200e9c:	00173713          	seqz	a4,a4
ffffffffc0200ea0:	8fd9                	or	a5,a5,a4
ffffffffc0200ea2:	30079763          	bnez	a5,ffffffffc02011b0 <default_check+0x392>
ffffffffc0200ea6:	313a0563          	beq	s4,s3,ffffffffc02011b0 <default_check+0x392>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200eaa:	000a2783          	lw	a5,0(s4)
ffffffffc0200eae:	2a079163          	bnez	a5,ffffffffc0201150 <default_check+0x332>
ffffffffc0200eb2:	0009a783          	lw	a5,0(s3)
ffffffffc0200eb6:	28079d63          	bnez	a5,ffffffffc0201150 <default_check+0x332>
ffffffffc0200eba:	411c                	lw	a5,0(a0)
ffffffffc0200ebc:	28079a63          	bnez	a5,ffffffffc0201150 <default_check+0x332>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0200ec0:	000cb797          	auipc	a5,0xcb
ffffffffc0200ec4:	3d07b783          	ld	a5,976(a5) # ffffffffc02cc290 <pages>
ffffffffc0200ec8:	00008617          	auipc	a2,0x8
ffffffffc0200ecc:	1d063603          	ld	a2,464(a2) # ffffffffc0209098 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200ed0:	000cb697          	auipc	a3,0xcb
ffffffffc0200ed4:	3b86b683          	ld	a3,952(a3) # ffffffffc02cc288 <npage>
ffffffffc0200ed8:	40fa0733          	sub	a4,s4,a5
ffffffffc0200edc:	8719                	srai	a4,a4,0x6
ffffffffc0200ede:	9732                	add	a4,a4,a2
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0200ee0:	0732                	slli	a4,a4,0xc
ffffffffc0200ee2:	06b2                	slli	a3,a3,0xc
ffffffffc0200ee4:	2ad77663          	bgeu	a4,a3,ffffffffc0201190 <default_check+0x372>
    return page - pages + nbase;
ffffffffc0200ee8:	40f98733          	sub	a4,s3,a5
ffffffffc0200eec:	8719                	srai	a4,a4,0x6
ffffffffc0200eee:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200ef0:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200ef2:	4cd77f63          	bgeu	a4,a3,ffffffffc02013d0 <default_check+0x5b2>
    return page - pages + nbase;
ffffffffc0200ef6:	40f507b3          	sub	a5,a0,a5
ffffffffc0200efa:	8799                	srai	a5,a5,0x6
ffffffffc0200efc:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200efe:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200f00:	32d7f863          	bgeu	a5,a3,ffffffffc0201230 <default_check+0x412>
    assert(alloc_page() == NULL);
ffffffffc0200f04:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200f06:	00093c03          	ld	s8,0(s2)
ffffffffc0200f0a:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc0200f0e:	000c7b17          	auipc	s6,0xc7
ffffffffc0200f12:	19ab2b03          	lw	s6,410(s6) # ffffffffc02c80a8 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc0200f16:	01293023          	sd	s2,0(s2)
ffffffffc0200f1a:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc0200f1e:	000c7797          	auipc	a5,0xc7
ffffffffc0200f22:	1807a523          	sw	zero,394(a5) # ffffffffc02c80a8 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200f26:	60d000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0200f2a:	2e051363          	bnez	a0,ffffffffc0201210 <default_check+0x3f2>
    free_page(p0);
ffffffffc0200f2e:	8552                	mv	a0,s4
ffffffffc0200f30:	4585                	li	a1,1
ffffffffc0200f32:	63b000ef          	jal	ffffffffc0201d6c <free_pages>
    free_page(p1);
ffffffffc0200f36:	854e                	mv	a0,s3
ffffffffc0200f38:	4585                	li	a1,1
ffffffffc0200f3a:	633000ef          	jal	ffffffffc0201d6c <free_pages>
    free_page(p2);
ffffffffc0200f3e:	8556                	mv	a0,s5
ffffffffc0200f40:	4585                	li	a1,1
ffffffffc0200f42:	62b000ef          	jal	ffffffffc0201d6c <free_pages>
    assert(nr_free == 3);
ffffffffc0200f46:	000c7717          	auipc	a4,0xc7
ffffffffc0200f4a:	16272703          	lw	a4,354(a4) # ffffffffc02c80a8 <free_area+0x10>
ffffffffc0200f4e:	478d                	li	a5,3
ffffffffc0200f50:	2af71063          	bne	a4,a5,ffffffffc02011f0 <default_check+0x3d2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f54:	4505                	li	a0,1
ffffffffc0200f56:	5dd000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0200f5a:	89aa                	mv	s3,a0
ffffffffc0200f5c:	26050a63          	beqz	a0,ffffffffc02011d0 <default_check+0x3b2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200f60:	4505                	li	a0,1
ffffffffc0200f62:	5d1000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0200f66:	8aaa                	mv	s5,a0
ffffffffc0200f68:	3c050463          	beqz	a0,ffffffffc0201330 <default_check+0x512>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200f6c:	4505                	li	a0,1
ffffffffc0200f6e:	5c5000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0200f72:	8a2a                	mv	s4,a0
ffffffffc0200f74:	38050e63          	beqz	a0,ffffffffc0201310 <default_check+0x4f2>
    assert(alloc_page() == NULL);
ffffffffc0200f78:	4505                	li	a0,1
ffffffffc0200f7a:	5b9000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0200f7e:	36051963          	bnez	a0,ffffffffc02012f0 <default_check+0x4d2>
    free_page(p0);
ffffffffc0200f82:	4585                	li	a1,1
ffffffffc0200f84:	854e                	mv	a0,s3
ffffffffc0200f86:	5e7000ef          	jal	ffffffffc0201d6c <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200f8a:	00893783          	ld	a5,8(s2)
ffffffffc0200f8e:	1f278163          	beq	a5,s2,ffffffffc0201170 <default_check+0x352>
    assert((p = alloc_page()) == p0);
ffffffffc0200f92:	4505                	li	a0,1
ffffffffc0200f94:	59f000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0200f98:	8caa                	mv	s9,a0
ffffffffc0200f9a:	30a99b63          	bne	s3,a0,ffffffffc02012b0 <default_check+0x492>
    assert(alloc_page() == NULL);
ffffffffc0200f9e:	4505                	li	a0,1
ffffffffc0200fa0:	593000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0200fa4:	2e051663          	bnez	a0,ffffffffc0201290 <default_check+0x472>
    assert(nr_free == 0);
ffffffffc0200fa8:	000c7797          	auipc	a5,0xc7
ffffffffc0200fac:	1007a783          	lw	a5,256(a5) # ffffffffc02c80a8 <free_area+0x10>
ffffffffc0200fb0:	2c079063          	bnez	a5,ffffffffc0201270 <default_check+0x452>
    free_page(p);
ffffffffc0200fb4:	8566                	mv	a0,s9
ffffffffc0200fb6:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200fb8:	01893023          	sd	s8,0(s2)
ffffffffc0200fbc:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc0200fc0:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc0200fc4:	5a9000ef          	jal	ffffffffc0201d6c <free_pages>
    free_page(p1);
ffffffffc0200fc8:	8556                	mv	a0,s5
ffffffffc0200fca:	4585                	li	a1,1
ffffffffc0200fcc:	5a1000ef          	jal	ffffffffc0201d6c <free_pages>
    free_page(p2);
ffffffffc0200fd0:	8552                	mv	a0,s4
ffffffffc0200fd2:	4585                	li	a1,1
ffffffffc0200fd4:	599000ef          	jal	ffffffffc0201d6c <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200fd8:	4515                	li	a0,5
ffffffffc0200fda:	559000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0200fde:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200fe0:	26050863          	beqz	a0,ffffffffc0201250 <default_check+0x432>
ffffffffc0200fe4:	651c                	ld	a5,8(a0)
    assert(!PageProperty(p0));
ffffffffc0200fe6:	8b89                	andi	a5,a5,2
ffffffffc0200fe8:	54079463          	bnez	a5,ffffffffc0201530 <default_check+0x712>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200fec:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200fee:	00093b83          	ld	s7,0(s2)
ffffffffc0200ff2:	00893b03          	ld	s6,8(s2)
ffffffffc0200ff6:	01293023          	sd	s2,0(s2)
ffffffffc0200ffa:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc0200ffe:	535000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0201002:	50051763          	bnez	a0,ffffffffc0201510 <default_check+0x6f2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0201006:	08098a13          	addi	s4,s3,128
ffffffffc020100a:	8552                	mv	a0,s4
ffffffffc020100c:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc020100e:	000c7c17          	auipc	s8,0xc7
ffffffffc0201012:	09ac2c03          	lw	s8,154(s8) # ffffffffc02c80a8 <free_area+0x10>
    nr_free = 0;
ffffffffc0201016:	000c7797          	auipc	a5,0xc7
ffffffffc020101a:	0807a923          	sw	zero,146(a5) # ffffffffc02c80a8 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc020101e:	54f000ef          	jal	ffffffffc0201d6c <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201022:	4511                	li	a0,4
ffffffffc0201024:	50f000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0201028:	4c051463          	bnez	a0,ffffffffc02014f0 <default_check+0x6d2>
ffffffffc020102c:	0889b783          	ld	a5,136(s3)
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201030:	8b89                	andi	a5,a5,2
ffffffffc0201032:	48078f63          	beqz	a5,ffffffffc02014d0 <default_check+0x6b2>
ffffffffc0201036:	0909a503          	lw	a0,144(s3)
ffffffffc020103a:	478d                	li	a5,3
ffffffffc020103c:	48f51a63          	bne	a0,a5,ffffffffc02014d0 <default_check+0x6b2>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201040:	4f3000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0201044:	8aaa                	mv	s5,a0
ffffffffc0201046:	46050563          	beqz	a0,ffffffffc02014b0 <default_check+0x692>
    assert(alloc_page() == NULL);
ffffffffc020104a:	4505                	li	a0,1
ffffffffc020104c:	4e7000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0201050:	44051063          	bnez	a0,ffffffffc0201490 <default_check+0x672>
    assert(p0 + 2 == p1);
ffffffffc0201054:	415a1e63          	bne	s4,s5,ffffffffc0201470 <default_check+0x652>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201058:	4585                	li	a1,1
ffffffffc020105a:	854e                	mv	a0,s3
ffffffffc020105c:	511000ef          	jal	ffffffffc0201d6c <free_pages>
    free_pages(p1, 3);
ffffffffc0201060:	8552                	mv	a0,s4
ffffffffc0201062:	458d                	li	a1,3
ffffffffc0201064:	509000ef          	jal	ffffffffc0201d6c <free_pages>
ffffffffc0201068:	0089b783          	ld	a5,8(s3)
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc020106c:	8b89                	andi	a5,a5,2
ffffffffc020106e:	3e078163          	beqz	a5,ffffffffc0201450 <default_check+0x632>
ffffffffc0201072:	0109aa83          	lw	s5,16(s3)
ffffffffc0201076:	4785                	li	a5,1
ffffffffc0201078:	3cfa9c63          	bne	s5,a5,ffffffffc0201450 <default_check+0x632>
ffffffffc020107c:	008a3783          	ld	a5,8(s4)
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201080:	8b89                	andi	a5,a5,2
ffffffffc0201082:	3a078763          	beqz	a5,ffffffffc0201430 <default_check+0x612>
ffffffffc0201086:	010a2703          	lw	a4,16(s4)
ffffffffc020108a:	478d                	li	a5,3
ffffffffc020108c:	3af71263          	bne	a4,a5,ffffffffc0201430 <default_check+0x612>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201090:	8556                	mv	a0,s5
ffffffffc0201092:	4a1000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0201096:	36a99d63          	bne	s3,a0,ffffffffc0201410 <default_check+0x5f2>
    free_page(p0);
ffffffffc020109a:	85d6                	mv	a1,s5
ffffffffc020109c:	4d1000ef          	jal	ffffffffc0201d6c <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02010a0:	4509                	li	a0,2
ffffffffc02010a2:	491000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc02010a6:	34aa1563          	bne	s4,a0,ffffffffc02013f0 <default_check+0x5d2>

    free_pages(p0, 2);
ffffffffc02010aa:	4589                	li	a1,2
ffffffffc02010ac:	4c1000ef          	jal	ffffffffc0201d6c <free_pages>
    free_page(p2);
ffffffffc02010b0:	04098513          	addi	a0,s3,64
ffffffffc02010b4:	85d6                	mv	a1,s5
ffffffffc02010b6:	4b7000ef          	jal	ffffffffc0201d6c <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02010ba:	4515                	li	a0,5
ffffffffc02010bc:	477000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc02010c0:	89aa                	mv	s3,a0
ffffffffc02010c2:	48050763          	beqz	a0,ffffffffc0201550 <default_check+0x732>
    assert(alloc_page() == NULL);
ffffffffc02010c6:	8556                	mv	a0,s5
ffffffffc02010c8:	46b000ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc02010cc:	2e051263          	bnez	a0,ffffffffc02013b0 <default_check+0x592>

    assert(nr_free == 0);
ffffffffc02010d0:	000c7797          	auipc	a5,0xc7
ffffffffc02010d4:	fd87a783          	lw	a5,-40(a5) # ffffffffc02c80a8 <free_area+0x10>
ffffffffc02010d8:	2a079c63          	bnez	a5,ffffffffc0201390 <default_check+0x572>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc02010dc:	854e                	mv	a0,s3
ffffffffc02010de:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc02010e0:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc02010e4:	01793023          	sd	s7,0(s2)
ffffffffc02010e8:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc02010ec:	481000ef          	jal	ffffffffc0201d6c <free_pages>
    return listelm->next;
ffffffffc02010f0:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc02010f4:	01278963          	beq	a5,s2,ffffffffc0201106 <default_check+0x2e8>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc02010f8:	ff87a703          	lw	a4,-8(a5)
ffffffffc02010fc:	679c                	ld	a5,8(a5)
ffffffffc02010fe:	34fd                	addiw	s1,s1,-1
ffffffffc0201100:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201102:	ff279be3          	bne	a5,s2,ffffffffc02010f8 <default_check+0x2da>
    }
    assert(count == 0);
ffffffffc0201106:	26049563          	bnez	s1,ffffffffc0201370 <default_check+0x552>
    assert(total == 0);
ffffffffc020110a:	46041363          	bnez	s0,ffffffffc0201570 <default_check+0x752>
}
ffffffffc020110e:	60e6                	ld	ra,88(sp)
ffffffffc0201110:	6446                	ld	s0,80(sp)
ffffffffc0201112:	64a6                	ld	s1,72(sp)
ffffffffc0201114:	6906                	ld	s2,64(sp)
ffffffffc0201116:	79e2                	ld	s3,56(sp)
ffffffffc0201118:	7a42                	ld	s4,48(sp)
ffffffffc020111a:	7aa2                	ld	s5,40(sp)
ffffffffc020111c:	7b02                	ld	s6,32(sp)
ffffffffc020111e:	6be2                	ld	s7,24(sp)
ffffffffc0201120:	6c42                	ld	s8,16(sp)
ffffffffc0201122:	6ca2                	ld	s9,8(sp)
ffffffffc0201124:	6125                	addi	sp,sp,96
ffffffffc0201126:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201128:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc020112a:	4401                	li	s0,0
ffffffffc020112c:	4481                	li	s1,0
ffffffffc020112e:	bb1d                	j	ffffffffc0200e64 <default_check+0x46>
        assert(PageProperty(p));
ffffffffc0201130:	00006697          	auipc	a3,0x6
ffffffffc0201134:	bb868693          	addi	a3,a3,-1096 # ffffffffc0206ce8 <etext+0x9a4>
ffffffffc0201138:	00006617          	auipc	a2,0x6
ffffffffc020113c:	bc060613          	addi	a2,a2,-1088 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201140:	0ef00593          	li	a1,239
ffffffffc0201144:	00006517          	auipc	a0,0x6
ffffffffc0201148:	bcc50513          	addi	a0,a0,-1076 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020114c:	afeff0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201150:	00006697          	auipc	a3,0x6
ffffffffc0201154:	c8068693          	addi	a3,a3,-896 # ffffffffc0206dd0 <etext+0xa8c>
ffffffffc0201158:	00006617          	auipc	a2,0x6
ffffffffc020115c:	ba060613          	addi	a2,a2,-1120 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201160:	0bd00593          	li	a1,189
ffffffffc0201164:	00006517          	auipc	a0,0x6
ffffffffc0201168:	bac50513          	addi	a0,a0,-1108 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020116c:	adeff0ef          	jal	ffffffffc020044a <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201170:	00006697          	auipc	a3,0x6
ffffffffc0201174:	d2868693          	addi	a3,a3,-728 # ffffffffc0206e98 <etext+0xb54>
ffffffffc0201178:	00006617          	auipc	a2,0x6
ffffffffc020117c:	b8060613          	addi	a2,a2,-1152 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201180:	0d800593          	li	a1,216
ffffffffc0201184:	00006517          	auipc	a0,0x6
ffffffffc0201188:	b8c50513          	addi	a0,a0,-1140 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020118c:	abeff0ef          	jal	ffffffffc020044a <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201190:	00006697          	auipc	a3,0x6
ffffffffc0201194:	c8068693          	addi	a3,a3,-896 # ffffffffc0206e10 <etext+0xacc>
ffffffffc0201198:	00006617          	auipc	a2,0x6
ffffffffc020119c:	b6060613          	addi	a2,a2,-1184 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02011a0:	0bf00593          	li	a1,191
ffffffffc02011a4:	00006517          	auipc	a0,0x6
ffffffffc02011a8:	b6c50513          	addi	a0,a0,-1172 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02011ac:	a9eff0ef          	jal	ffffffffc020044a <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02011b0:	00006697          	auipc	a3,0x6
ffffffffc02011b4:	bf868693          	addi	a3,a3,-1032 # ffffffffc0206da8 <etext+0xa64>
ffffffffc02011b8:	00006617          	auipc	a2,0x6
ffffffffc02011bc:	b4060613          	addi	a2,a2,-1216 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02011c0:	0bc00593          	li	a1,188
ffffffffc02011c4:	00006517          	auipc	a0,0x6
ffffffffc02011c8:	b4c50513          	addi	a0,a0,-1204 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02011cc:	a7eff0ef          	jal	ffffffffc020044a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02011d0:	00006697          	auipc	a3,0x6
ffffffffc02011d4:	b7868693          	addi	a3,a3,-1160 # ffffffffc0206d48 <etext+0xa04>
ffffffffc02011d8:	00006617          	auipc	a2,0x6
ffffffffc02011dc:	b2060613          	addi	a2,a2,-1248 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02011e0:	0d100593          	li	a1,209
ffffffffc02011e4:	00006517          	auipc	a0,0x6
ffffffffc02011e8:	b2c50513          	addi	a0,a0,-1236 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02011ec:	a5eff0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_free == 3);
ffffffffc02011f0:	00006697          	auipc	a3,0x6
ffffffffc02011f4:	c9868693          	addi	a3,a3,-872 # ffffffffc0206e88 <etext+0xb44>
ffffffffc02011f8:	00006617          	auipc	a2,0x6
ffffffffc02011fc:	b0060613          	addi	a2,a2,-1280 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201200:	0cf00593          	li	a1,207
ffffffffc0201204:	00006517          	auipc	a0,0x6
ffffffffc0201208:	b0c50513          	addi	a0,a0,-1268 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020120c:	a3eff0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201210:	00006697          	auipc	a3,0x6
ffffffffc0201214:	c6068693          	addi	a3,a3,-928 # ffffffffc0206e70 <etext+0xb2c>
ffffffffc0201218:	00006617          	auipc	a2,0x6
ffffffffc020121c:	ae060613          	addi	a2,a2,-1312 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201220:	0ca00593          	li	a1,202
ffffffffc0201224:	00006517          	auipc	a0,0x6
ffffffffc0201228:	aec50513          	addi	a0,a0,-1300 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020122c:	a1eff0ef          	jal	ffffffffc020044a <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201230:	00006697          	auipc	a3,0x6
ffffffffc0201234:	c2068693          	addi	a3,a3,-992 # ffffffffc0206e50 <etext+0xb0c>
ffffffffc0201238:	00006617          	auipc	a2,0x6
ffffffffc020123c:	ac060613          	addi	a2,a2,-1344 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201240:	0c100593          	li	a1,193
ffffffffc0201244:	00006517          	auipc	a0,0x6
ffffffffc0201248:	acc50513          	addi	a0,a0,-1332 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020124c:	9feff0ef          	jal	ffffffffc020044a <__panic>
    assert(p0 != NULL);
ffffffffc0201250:	00006697          	auipc	a3,0x6
ffffffffc0201254:	c9068693          	addi	a3,a3,-880 # ffffffffc0206ee0 <etext+0xb9c>
ffffffffc0201258:	00006617          	auipc	a2,0x6
ffffffffc020125c:	aa060613          	addi	a2,a2,-1376 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201260:	0f700593          	li	a1,247
ffffffffc0201264:	00006517          	auipc	a0,0x6
ffffffffc0201268:	aac50513          	addi	a0,a0,-1364 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020126c:	9deff0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_free == 0);
ffffffffc0201270:	00006697          	auipc	a3,0x6
ffffffffc0201274:	c6068693          	addi	a3,a3,-928 # ffffffffc0206ed0 <etext+0xb8c>
ffffffffc0201278:	00006617          	auipc	a2,0x6
ffffffffc020127c:	a8060613          	addi	a2,a2,-1408 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201280:	0de00593          	li	a1,222
ffffffffc0201284:	00006517          	auipc	a0,0x6
ffffffffc0201288:	a8c50513          	addi	a0,a0,-1396 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020128c:	9beff0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201290:	00006697          	auipc	a3,0x6
ffffffffc0201294:	be068693          	addi	a3,a3,-1056 # ffffffffc0206e70 <etext+0xb2c>
ffffffffc0201298:	00006617          	auipc	a2,0x6
ffffffffc020129c:	a6060613          	addi	a2,a2,-1440 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02012a0:	0dc00593          	li	a1,220
ffffffffc02012a4:	00006517          	auipc	a0,0x6
ffffffffc02012a8:	a6c50513          	addi	a0,a0,-1428 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02012ac:	99eff0ef          	jal	ffffffffc020044a <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02012b0:	00006697          	auipc	a3,0x6
ffffffffc02012b4:	c0068693          	addi	a3,a3,-1024 # ffffffffc0206eb0 <etext+0xb6c>
ffffffffc02012b8:	00006617          	auipc	a2,0x6
ffffffffc02012bc:	a4060613          	addi	a2,a2,-1472 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02012c0:	0db00593          	li	a1,219
ffffffffc02012c4:	00006517          	auipc	a0,0x6
ffffffffc02012c8:	a4c50513          	addi	a0,a0,-1460 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02012cc:	97eff0ef          	jal	ffffffffc020044a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02012d0:	00006697          	auipc	a3,0x6
ffffffffc02012d4:	a7868693          	addi	a3,a3,-1416 # ffffffffc0206d48 <etext+0xa04>
ffffffffc02012d8:	00006617          	auipc	a2,0x6
ffffffffc02012dc:	a2060613          	addi	a2,a2,-1504 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02012e0:	0b800593          	li	a1,184
ffffffffc02012e4:	00006517          	auipc	a0,0x6
ffffffffc02012e8:	a2c50513          	addi	a0,a0,-1492 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02012ec:	95eff0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012f0:	00006697          	auipc	a3,0x6
ffffffffc02012f4:	b8068693          	addi	a3,a3,-1152 # ffffffffc0206e70 <etext+0xb2c>
ffffffffc02012f8:	00006617          	auipc	a2,0x6
ffffffffc02012fc:	a0060613          	addi	a2,a2,-1536 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201300:	0d500593          	li	a1,213
ffffffffc0201304:	00006517          	auipc	a0,0x6
ffffffffc0201308:	a0c50513          	addi	a0,a0,-1524 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020130c:	93eff0ef          	jal	ffffffffc020044a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201310:	00006697          	auipc	a3,0x6
ffffffffc0201314:	a7868693          	addi	a3,a3,-1416 # ffffffffc0206d88 <etext+0xa44>
ffffffffc0201318:	00006617          	auipc	a2,0x6
ffffffffc020131c:	9e060613          	addi	a2,a2,-1568 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201320:	0d300593          	li	a1,211
ffffffffc0201324:	00006517          	auipc	a0,0x6
ffffffffc0201328:	9ec50513          	addi	a0,a0,-1556 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020132c:	91eff0ef          	jal	ffffffffc020044a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201330:	00006697          	auipc	a3,0x6
ffffffffc0201334:	a3868693          	addi	a3,a3,-1480 # ffffffffc0206d68 <etext+0xa24>
ffffffffc0201338:	00006617          	auipc	a2,0x6
ffffffffc020133c:	9c060613          	addi	a2,a2,-1600 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201340:	0d200593          	li	a1,210
ffffffffc0201344:	00006517          	auipc	a0,0x6
ffffffffc0201348:	9cc50513          	addi	a0,a0,-1588 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020134c:	8feff0ef          	jal	ffffffffc020044a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201350:	00006697          	auipc	a3,0x6
ffffffffc0201354:	a3868693          	addi	a3,a3,-1480 # ffffffffc0206d88 <etext+0xa44>
ffffffffc0201358:	00006617          	auipc	a2,0x6
ffffffffc020135c:	9a060613          	addi	a2,a2,-1632 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201360:	0ba00593          	li	a1,186
ffffffffc0201364:	00006517          	auipc	a0,0x6
ffffffffc0201368:	9ac50513          	addi	a0,a0,-1620 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020136c:	8deff0ef          	jal	ffffffffc020044a <__panic>
    assert(count == 0);
ffffffffc0201370:	00006697          	auipc	a3,0x6
ffffffffc0201374:	cc068693          	addi	a3,a3,-832 # ffffffffc0207030 <etext+0xcec>
ffffffffc0201378:	00006617          	auipc	a2,0x6
ffffffffc020137c:	98060613          	addi	a2,a2,-1664 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201380:	12400593          	li	a1,292
ffffffffc0201384:	00006517          	auipc	a0,0x6
ffffffffc0201388:	98c50513          	addi	a0,a0,-1652 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020138c:	8beff0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_free == 0);
ffffffffc0201390:	00006697          	auipc	a3,0x6
ffffffffc0201394:	b4068693          	addi	a3,a3,-1216 # ffffffffc0206ed0 <etext+0xb8c>
ffffffffc0201398:	00006617          	auipc	a2,0x6
ffffffffc020139c:	96060613          	addi	a2,a2,-1696 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02013a0:	11900593          	li	a1,281
ffffffffc02013a4:	00006517          	auipc	a0,0x6
ffffffffc02013a8:	96c50513          	addi	a0,a0,-1684 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02013ac:	89eff0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013b0:	00006697          	auipc	a3,0x6
ffffffffc02013b4:	ac068693          	addi	a3,a3,-1344 # ffffffffc0206e70 <etext+0xb2c>
ffffffffc02013b8:	00006617          	auipc	a2,0x6
ffffffffc02013bc:	94060613          	addi	a2,a2,-1728 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02013c0:	11700593          	li	a1,279
ffffffffc02013c4:	00006517          	auipc	a0,0x6
ffffffffc02013c8:	94c50513          	addi	a0,a0,-1716 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02013cc:	87eff0ef          	jal	ffffffffc020044a <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02013d0:	00006697          	auipc	a3,0x6
ffffffffc02013d4:	a6068693          	addi	a3,a3,-1440 # ffffffffc0206e30 <etext+0xaec>
ffffffffc02013d8:	00006617          	auipc	a2,0x6
ffffffffc02013dc:	92060613          	addi	a2,a2,-1760 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02013e0:	0c000593          	li	a1,192
ffffffffc02013e4:	00006517          	auipc	a0,0x6
ffffffffc02013e8:	92c50513          	addi	a0,a0,-1748 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02013ec:	85eff0ef          	jal	ffffffffc020044a <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02013f0:	00006697          	auipc	a3,0x6
ffffffffc02013f4:	c0068693          	addi	a3,a3,-1024 # ffffffffc0206ff0 <etext+0xcac>
ffffffffc02013f8:	00006617          	auipc	a2,0x6
ffffffffc02013fc:	90060613          	addi	a2,a2,-1792 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201400:	11100593          	li	a1,273
ffffffffc0201404:	00006517          	auipc	a0,0x6
ffffffffc0201408:	90c50513          	addi	a0,a0,-1780 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020140c:	83eff0ef          	jal	ffffffffc020044a <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201410:	00006697          	auipc	a3,0x6
ffffffffc0201414:	bc068693          	addi	a3,a3,-1088 # ffffffffc0206fd0 <etext+0xc8c>
ffffffffc0201418:	00006617          	auipc	a2,0x6
ffffffffc020141c:	8e060613          	addi	a2,a2,-1824 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201420:	10f00593          	li	a1,271
ffffffffc0201424:	00006517          	auipc	a0,0x6
ffffffffc0201428:	8ec50513          	addi	a0,a0,-1812 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020142c:	81eff0ef          	jal	ffffffffc020044a <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201430:	00006697          	auipc	a3,0x6
ffffffffc0201434:	b7868693          	addi	a3,a3,-1160 # ffffffffc0206fa8 <etext+0xc64>
ffffffffc0201438:	00006617          	auipc	a2,0x6
ffffffffc020143c:	8c060613          	addi	a2,a2,-1856 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201440:	10d00593          	li	a1,269
ffffffffc0201444:	00006517          	auipc	a0,0x6
ffffffffc0201448:	8cc50513          	addi	a0,a0,-1844 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020144c:	ffffe0ef          	jal	ffffffffc020044a <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201450:	00006697          	auipc	a3,0x6
ffffffffc0201454:	b3068693          	addi	a3,a3,-1232 # ffffffffc0206f80 <etext+0xc3c>
ffffffffc0201458:	00006617          	auipc	a2,0x6
ffffffffc020145c:	8a060613          	addi	a2,a2,-1888 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201460:	10c00593          	li	a1,268
ffffffffc0201464:	00006517          	auipc	a0,0x6
ffffffffc0201468:	8ac50513          	addi	a0,a0,-1876 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020146c:	fdffe0ef          	jal	ffffffffc020044a <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201470:	00006697          	auipc	a3,0x6
ffffffffc0201474:	b0068693          	addi	a3,a3,-1280 # ffffffffc0206f70 <etext+0xc2c>
ffffffffc0201478:	00006617          	auipc	a2,0x6
ffffffffc020147c:	88060613          	addi	a2,a2,-1920 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201480:	10700593          	li	a1,263
ffffffffc0201484:	00006517          	auipc	a0,0x6
ffffffffc0201488:	88c50513          	addi	a0,a0,-1908 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020148c:	fbffe0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201490:	00006697          	auipc	a3,0x6
ffffffffc0201494:	9e068693          	addi	a3,a3,-1568 # ffffffffc0206e70 <etext+0xb2c>
ffffffffc0201498:	00006617          	auipc	a2,0x6
ffffffffc020149c:	86060613          	addi	a2,a2,-1952 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02014a0:	10600593          	li	a1,262
ffffffffc02014a4:	00006517          	auipc	a0,0x6
ffffffffc02014a8:	86c50513          	addi	a0,a0,-1940 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02014ac:	f9ffe0ef          	jal	ffffffffc020044a <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02014b0:	00006697          	auipc	a3,0x6
ffffffffc02014b4:	aa068693          	addi	a3,a3,-1376 # ffffffffc0206f50 <etext+0xc0c>
ffffffffc02014b8:	00006617          	auipc	a2,0x6
ffffffffc02014bc:	84060613          	addi	a2,a2,-1984 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02014c0:	10500593          	li	a1,261
ffffffffc02014c4:	00006517          	auipc	a0,0x6
ffffffffc02014c8:	84c50513          	addi	a0,a0,-1972 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02014cc:	f7ffe0ef          	jal	ffffffffc020044a <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02014d0:	00006697          	auipc	a3,0x6
ffffffffc02014d4:	a5068693          	addi	a3,a3,-1456 # ffffffffc0206f20 <etext+0xbdc>
ffffffffc02014d8:	00006617          	auipc	a2,0x6
ffffffffc02014dc:	82060613          	addi	a2,a2,-2016 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02014e0:	10400593          	li	a1,260
ffffffffc02014e4:	00006517          	auipc	a0,0x6
ffffffffc02014e8:	82c50513          	addi	a0,a0,-2004 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02014ec:	f5ffe0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02014f0:	00006697          	auipc	a3,0x6
ffffffffc02014f4:	a1868693          	addi	a3,a3,-1512 # ffffffffc0206f08 <etext+0xbc4>
ffffffffc02014f8:	00006617          	auipc	a2,0x6
ffffffffc02014fc:	80060613          	addi	a2,a2,-2048 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201500:	10300593          	li	a1,259
ffffffffc0201504:	00006517          	auipc	a0,0x6
ffffffffc0201508:	80c50513          	addi	a0,a0,-2036 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020150c:	f3ffe0ef          	jal	ffffffffc020044a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201510:	00006697          	auipc	a3,0x6
ffffffffc0201514:	96068693          	addi	a3,a3,-1696 # ffffffffc0206e70 <etext+0xb2c>
ffffffffc0201518:	00005617          	auipc	a2,0x5
ffffffffc020151c:	7e060613          	addi	a2,a2,2016 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201520:	0fd00593          	li	a1,253
ffffffffc0201524:	00005517          	auipc	a0,0x5
ffffffffc0201528:	7ec50513          	addi	a0,a0,2028 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020152c:	f1ffe0ef          	jal	ffffffffc020044a <__panic>
    assert(!PageProperty(p0));
ffffffffc0201530:	00006697          	auipc	a3,0x6
ffffffffc0201534:	9c068693          	addi	a3,a3,-1600 # ffffffffc0206ef0 <etext+0xbac>
ffffffffc0201538:	00005617          	auipc	a2,0x5
ffffffffc020153c:	7c060613          	addi	a2,a2,1984 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201540:	0f800593          	li	a1,248
ffffffffc0201544:	00005517          	auipc	a0,0x5
ffffffffc0201548:	7cc50513          	addi	a0,a0,1996 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020154c:	efffe0ef          	jal	ffffffffc020044a <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201550:	00006697          	auipc	a3,0x6
ffffffffc0201554:	ac068693          	addi	a3,a3,-1344 # ffffffffc0207010 <etext+0xccc>
ffffffffc0201558:	00005617          	auipc	a2,0x5
ffffffffc020155c:	7a060613          	addi	a2,a2,1952 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201560:	11600593          	li	a1,278
ffffffffc0201564:	00005517          	auipc	a0,0x5
ffffffffc0201568:	7ac50513          	addi	a0,a0,1964 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020156c:	edffe0ef          	jal	ffffffffc020044a <__panic>
    assert(total == 0);
ffffffffc0201570:	00006697          	auipc	a3,0x6
ffffffffc0201574:	ad068693          	addi	a3,a3,-1328 # ffffffffc0207040 <etext+0xcfc>
ffffffffc0201578:	00005617          	auipc	a2,0x5
ffffffffc020157c:	78060613          	addi	a2,a2,1920 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201580:	12500593          	li	a1,293
ffffffffc0201584:	00005517          	auipc	a0,0x5
ffffffffc0201588:	78c50513          	addi	a0,a0,1932 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020158c:	ebffe0ef          	jal	ffffffffc020044a <__panic>
    assert(total == nr_free_pages());
ffffffffc0201590:	00005697          	auipc	a3,0x5
ffffffffc0201594:	79868693          	addi	a3,a3,1944 # ffffffffc0206d28 <etext+0x9e4>
ffffffffc0201598:	00005617          	auipc	a2,0x5
ffffffffc020159c:	76060613          	addi	a2,a2,1888 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02015a0:	0f200593          	li	a1,242
ffffffffc02015a4:	00005517          	auipc	a0,0x5
ffffffffc02015a8:	76c50513          	addi	a0,a0,1900 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02015ac:	e9ffe0ef          	jal	ffffffffc020044a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02015b0:	00005697          	auipc	a3,0x5
ffffffffc02015b4:	7b868693          	addi	a3,a3,1976 # ffffffffc0206d68 <etext+0xa24>
ffffffffc02015b8:	00005617          	auipc	a2,0x5
ffffffffc02015bc:	74060613          	addi	a2,a2,1856 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02015c0:	0b900593          	li	a1,185
ffffffffc02015c4:	00005517          	auipc	a0,0x5
ffffffffc02015c8:	74c50513          	addi	a0,a0,1868 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02015cc:	e7ffe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02015d0 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc02015d0:	1141                	addi	sp,sp,-16
ffffffffc02015d2:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02015d4:	14058663          	beqz	a1,ffffffffc0201720 <default_free_pages+0x150>
    for (; p != base + n; p ++) {
ffffffffc02015d8:	00659713          	slli	a4,a1,0x6
ffffffffc02015dc:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc02015e0:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc02015e2:	c30d                	beqz	a4,ffffffffc0201604 <default_free_pages+0x34>
ffffffffc02015e4:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02015e6:	8b05                	andi	a4,a4,1
ffffffffc02015e8:	10071c63          	bnez	a4,ffffffffc0201700 <default_free_pages+0x130>
ffffffffc02015ec:	6798                	ld	a4,8(a5)
ffffffffc02015ee:	8b09                	andi	a4,a4,2
ffffffffc02015f0:	10071863          	bnez	a4,ffffffffc0201700 <default_free_pages+0x130>
        p->flags = 0;
ffffffffc02015f4:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc02015f8:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02015fc:	04078793          	addi	a5,a5,64
ffffffffc0201600:	fed792e3          	bne	a5,a3,ffffffffc02015e4 <default_free_pages+0x14>
    base->property = n;
ffffffffc0201604:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201606:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020160a:	4789                	li	a5,2
ffffffffc020160c:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201610:	000c7717          	auipc	a4,0xc7
ffffffffc0201614:	a9872703          	lw	a4,-1384(a4) # ffffffffc02c80a8 <free_area+0x10>
ffffffffc0201618:	000c7697          	auipc	a3,0xc7
ffffffffc020161c:	a8068693          	addi	a3,a3,-1408 # ffffffffc02c8098 <free_area>
    return list->next == list;
ffffffffc0201620:	669c                	ld	a5,8(a3)
ffffffffc0201622:	9f2d                	addw	a4,a4,a1
ffffffffc0201624:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201626:	0ad78163          	beq	a5,a3,ffffffffc02016c8 <default_free_pages+0xf8>
            struct Page* page = le2page(le, page_link);
ffffffffc020162a:	fe878713          	addi	a4,a5,-24
ffffffffc020162e:	4581                	li	a1,0
ffffffffc0201630:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0201634:	00e56a63          	bltu	a0,a4,ffffffffc0201648 <default_free_pages+0x78>
    return listelm->next;
ffffffffc0201638:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020163a:	04d70c63          	beq	a4,a3,ffffffffc0201692 <default_free_pages+0xc2>
    struct Page *p = base;
ffffffffc020163e:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201640:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201644:	fee57ae3          	bgeu	a0,a4,ffffffffc0201638 <default_free_pages+0x68>
ffffffffc0201648:	c199                	beqz	a1,ffffffffc020164e <default_free_pages+0x7e>
ffffffffc020164a:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020164e:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201650:	e390                	sd	a2,0(a5)
ffffffffc0201652:	e710                	sd	a2,8(a4)
    elm->next = next;
    elm->prev = prev;
ffffffffc0201654:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0201656:	f11c                	sd	a5,32(a0)
    if (le != &free_list) {
ffffffffc0201658:	00d70d63          	beq	a4,a3,ffffffffc0201672 <default_free_pages+0xa2>
        if (p + p->property == base) {
ffffffffc020165c:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201660:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base) {
ffffffffc0201664:	02059813          	slli	a6,a1,0x20
ffffffffc0201668:	01a85793          	srli	a5,a6,0x1a
ffffffffc020166c:	97b2                	add	a5,a5,a2
ffffffffc020166e:	02f50c63          	beq	a0,a5,ffffffffc02016a6 <default_free_pages+0xd6>
    return listelm->next;
ffffffffc0201672:	711c                	ld	a5,32(a0)
    if (le != &free_list) {
ffffffffc0201674:	00d78c63          	beq	a5,a3,ffffffffc020168c <default_free_pages+0xbc>
        if (base + base->property == p) {
ffffffffc0201678:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc020167a:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p) {
ffffffffc020167e:	02061593          	slli	a1,a2,0x20
ffffffffc0201682:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201686:	972a                	add	a4,a4,a0
ffffffffc0201688:	04e68c63          	beq	a3,a4,ffffffffc02016e0 <default_free_pages+0x110>
}
ffffffffc020168c:	60a2                	ld	ra,8(sp)
ffffffffc020168e:	0141                	addi	sp,sp,16
ffffffffc0201690:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201692:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201694:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201696:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201698:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc020169a:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc020169c:	02d70f63          	beq	a4,a3,ffffffffc02016da <default_free_pages+0x10a>
ffffffffc02016a0:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc02016a2:	87ba                	mv	a5,a4
ffffffffc02016a4:	bf71                	j	ffffffffc0201640 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc02016a6:	491c                	lw	a5,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02016a8:	5875                	li	a6,-3
ffffffffc02016aa:	9fad                	addw	a5,a5,a1
ffffffffc02016ac:	fef72c23          	sw	a5,-8(a4)
ffffffffc02016b0:	6108b02f          	amoand.d	zero,a6,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc02016b4:	01853803          	ld	a6,24(a0)
ffffffffc02016b8:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc02016ba:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02016bc:	00b83423          	sd	a1,8(a6) # ff0008 <_binary_obj___user_matrix_out_size+0xfe4920>
    return listelm->next;
ffffffffc02016c0:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc02016c2:	0105b023          	sd	a6,0(a1)
ffffffffc02016c6:	b77d                	j	ffffffffc0201674 <default_free_pages+0xa4>
}
ffffffffc02016c8:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc02016ca:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc02016ce:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02016d0:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc02016d2:	e398                	sd	a4,0(a5)
ffffffffc02016d4:	e798                	sd	a4,8(a5)
}
ffffffffc02016d6:	0141                	addi	sp,sp,16
ffffffffc02016d8:	8082                	ret
ffffffffc02016da:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc02016dc:	873e                	mv	a4,a5
ffffffffc02016de:	bfad                	j	ffffffffc0201658 <default_free_pages+0x88>
            base->property += p->property;
ffffffffc02016e0:	ff87a703          	lw	a4,-8(a5)
ffffffffc02016e4:	56f5                	li	a3,-3
ffffffffc02016e6:	9f31                	addw	a4,a4,a2
ffffffffc02016e8:	c918                	sw	a4,16(a0)
ffffffffc02016ea:	ff078713          	addi	a4,a5,-16
ffffffffc02016ee:	60d7302f          	amoand.d	zero,a3,(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc02016f2:	6398                	ld	a4,0(a5)
ffffffffc02016f4:	679c                	ld	a5,8(a5)
}
ffffffffc02016f6:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02016f8:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02016fa:	e398                	sd	a4,0(a5)
ffffffffc02016fc:	0141                	addi	sp,sp,16
ffffffffc02016fe:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201700:	00006697          	auipc	a3,0x6
ffffffffc0201704:	95868693          	addi	a3,a3,-1704 # ffffffffc0207058 <etext+0xd14>
ffffffffc0201708:	00005617          	auipc	a2,0x5
ffffffffc020170c:	5f060613          	addi	a2,a2,1520 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201710:	08200593          	li	a1,130
ffffffffc0201714:	00005517          	auipc	a0,0x5
ffffffffc0201718:	5fc50513          	addi	a0,a0,1532 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020171c:	d2ffe0ef          	jal	ffffffffc020044a <__panic>
    assert(n > 0);
ffffffffc0201720:	00006697          	auipc	a3,0x6
ffffffffc0201724:	93068693          	addi	a3,a3,-1744 # ffffffffc0207050 <etext+0xd0c>
ffffffffc0201728:	00005617          	auipc	a2,0x5
ffffffffc020172c:	5d060613          	addi	a2,a2,1488 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201730:	07f00593          	li	a1,127
ffffffffc0201734:	00005517          	auipc	a0,0x5
ffffffffc0201738:	5dc50513          	addi	a0,a0,1500 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc020173c:	d0ffe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201740 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201740:	c951                	beqz	a0,ffffffffc02017d4 <default_alloc_pages+0x94>
    if (n > nr_free) {
ffffffffc0201742:	000c7597          	auipc	a1,0xc7
ffffffffc0201746:	9665a583          	lw	a1,-1690(a1) # ffffffffc02c80a8 <free_area+0x10>
ffffffffc020174a:	86aa                	mv	a3,a0
ffffffffc020174c:	02059793          	slli	a5,a1,0x20
ffffffffc0201750:	9381                	srli	a5,a5,0x20
ffffffffc0201752:	00a7ef63          	bltu	a5,a0,ffffffffc0201770 <default_alloc_pages+0x30>
    list_entry_t *le = &free_list;
ffffffffc0201756:	000c7617          	auipc	a2,0xc7
ffffffffc020175a:	94260613          	addi	a2,a2,-1726 # ffffffffc02c8098 <free_area>
ffffffffc020175e:	87b2                	mv	a5,a2
ffffffffc0201760:	a029                	j	ffffffffc020176a <default_alloc_pages+0x2a>
        if (p->property >= n) {
ffffffffc0201762:	ff87e703          	lwu	a4,-8(a5)
ffffffffc0201766:	00d77763          	bgeu	a4,a3,ffffffffc0201774 <default_alloc_pages+0x34>
    return listelm->next;
ffffffffc020176a:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc020176c:	fec79be3          	bne	a5,a2,ffffffffc0201762 <default_alloc_pages+0x22>
        return NULL;
ffffffffc0201770:	4501                	li	a0,0
}
ffffffffc0201772:	8082                	ret
        if (page->property > n) {
ffffffffc0201774:	ff87a883          	lw	a7,-8(a5)
    return listelm->prev;
ffffffffc0201778:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc020177c:	6798                	ld	a4,8(a5)
ffffffffc020177e:	02089313          	slli	t1,a7,0x20
ffffffffc0201782:	02035313          	srli	t1,t1,0x20
    prev->next = next;
ffffffffc0201786:	00e83423          	sd	a4,8(a6)
    next->prev = prev;
ffffffffc020178a:	01073023          	sd	a6,0(a4)
        struct Page *p = le2page(le, page_link);
ffffffffc020178e:	fe878513          	addi	a0,a5,-24
        if (page->property > n) {
ffffffffc0201792:	0266fa63          	bgeu	a3,t1,ffffffffc02017c6 <default_alloc_pages+0x86>
            struct Page *p = page + n;
ffffffffc0201796:	00669713          	slli	a4,a3,0x6
            p->property = page->property - n;
ffffffffc020179a:	40d888bb          	subw	a7,a7,a3
            struct Page *p = page + n;
ffffffffc020179e:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc02017a0:	01172823          	sw	a7,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02017a4:	00870313          	addi	t1,a4,8
ffffffffc02017a8:	4889                	li	a7,2
ffffffffc02017aa:	4113302f          	amoor.d	zero,a7,(t1)
    __list_add(elm, listelm, listelm->next);
ffffffffc02017ae:	00883883          	ld	a7,8(a6)
            list_add(prev, &(p->page_link));
ffffffffc02017b2:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc02017b6:	0068b023          	sd	t1,0(a7)
ffffffffc02017ba:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc02017be:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc02017c2:	01073c23          	sd	a6,24(a4)
        nr_free -= n;
ffffffffc02017c6:	9d95                	subw	a1,a1,a3
ffffffffc02017c8:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02017ca:	5775                	li	a4,-3
ffffffffc02017cc:	17c1                	addi	a5,a5,-16
ffffffffc02017ce:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc02017d2:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc02017d4:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02017d6:	00006697          	auipc	a3,0x6
ffffffffc02017da:	87a68693          	addi	a3,a3,-1926 # ffffffffc0207050 <etext+0xd0c>
ffffffffc02017de:	00005617          	auipc	a2,0x5
ffffffffc02017e2:	51a60613          	addi	a2,a2,1306 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02017e6:	06100593          	li	a1,97
ffffffffc02017ea:	00005517          	auipc	a0,0x5
ffffffffc02017ee:	52650513          	addi	a0,a0,1318 # ffffffffc0206d10 <etext+0x9cc>
default_alloc_pages(size_t n) {
ffffffffc02017f2:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02017f4:	c57fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02017f8 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc02017f8:	1141                	addi	sp,sp,-16
ffffffffc02017fa:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02017fc:	c9e1                	beqz	a1,ffffffffc02018cc <default_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc02017fe:	00659713          	slli	a4,a1,0x6
ffffffffc0201802:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201806:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc0201808:	cf11                	beqz	a4,ffffffffc0201824 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020180a:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc020180c:	8b05                	andi	a4,a4,1
ffffffffc020180e:	cf59                	beqz	a4,ffffffffc02018ac <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc0201810:	0007a823          	sw	zero,16(a5)
ffffffffc0201814:	0007b423          	sd	zero,8(a5)
ffffffffc0201818:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc020181c:	04078793          	addi	a5,a5,64
ffffffffc0201820:	fed795e3          	bne	a5,a3,ffffffffc020180a <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201824:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201826:	4789                	li	a5,2
ffffffffc0201828:	00850713          	addi	a4,a0,8
ffffffffc020182c:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201830:	000c7717          	auipc	a4,0xc7
ffffffffc0201834:	87872703          	lw	a4,-1928(a4) # ffffffffc02c80a8 <free_area+0x10>
ffffffffc0201838:	000c7697          	auipc	a3,0xc7
ffffffffc020183c:	86068693          	addi	a3,a3,-1952 # ffffffffc02c8098 <free_area>
    return list->next == list;
ffffffffc0201840:	669c                	ld	a5,8(a3)
ffffffffc0201842:	9f2d                	addw	a4,a4,a1
ffffffffc0201844:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201846:	04d78663          	beq	a5,a3,ffffffffc0201892 <default_init_memmap+0x9a>
            struct Page* page = le2page(le, page_link);
ffffffffc020184a:	fe878713          	addi	a4,a5,-24
ffffffffc020184e:	4581                	li	a1,0
ffffffffc0201850:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0201854:	00e56a63          	bltu	a0,a4,ffffffffc0201868 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201858:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020185a:	02d70263          	beq	a4,a3,ffffffffc020187e <default_init_memmap+0x86>
    struct Page *p = base;
ffffffffc020185e:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201860:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201864:	fee57ae3          	bgeu	a0,a4,ffffffffc0201858 <default_init_memmap+0x60>
ffffffffc0201868:	c199                	beqz	a1,ffffffffc020186e <default_init_memmap+0x76>
ffffffffc020186a:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020186e:	6398                	ld	a4,0(a5)
}
ffffffffc0201870:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201872:	e390                	sd	a2,0(a5)
ffffffffc0201874:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc0201876:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0201878:	f11c                	sd	a5,32(a0)
ffffffffc020187a:	0141                	addi	sp,sp,16
ffffffffc020187c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020187e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201880:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201882:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201884:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201886:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201888:	00d70e63          	beq	a4,a3,ffffffffc02018a4 <default_init_memmap+0xac>
ffffffffc020188c:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc020188e:	87ba                	mv	a5,a4
ffffffffc0201890:	bfc1                	j	ffffffffc0201860 <default_init_memmap+0x68>
}
ffffffffc0201892:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201894:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201898:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020189a:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc020189c:	e398                	sd	a4,0(a5)
ffffffffc020189e:	e798                	sd	a4,8(a5)
}
ffffffffc02018a0:	0141                	addi	sp,sp,16
ffffffffc02018a2:	8082                	ret
ffffffffc02018a4:	60a2                	ld	ra,8(sp)
ffffffffc02018a6:	e290                	sd	a2,0(a3)
ffffffffc02018a8:	0141                	addi	sp,sp,16
ffffffffc02018aa:	8082                	ret
        assert(PageReserved(p));
ffffffffc02018ac:	00005697          	auipc	a3,0x5
ffffffffc02018b0:	7d468693          	addi	a3,a3,2004 # ffffffffc0207080 <etext+0xd3c>
ffffffffc02018b4:	00005617          	auipc	a2,0x5
ffffffffc02018b8:	44460613          	addi	a2,a2,1092 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02018bc:	04800593          	li	a1,72
ffffffffc02018c0:	00005517          	auipc	a0,0x5
ffffffffc02018c4:	45050513          	addi	a0,a0,1104 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02018c8:	b83fe0ef          	jal	ffffffffc020044a <__panic>
    assert(n > 0);
ffffffffc02018cc:	00005697          	auipc	a3,0x5
ffffffffc02018d0:	78468693          	addi	a3,a3,1924 # ffffffffc0207050 <etext+0xd0c>
ffffffffc02018d4:	00005617          	auipc	a2,0x5
ffffffffc02018d8:	42460613          	addi	a2,a2,1060 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02018dc:	04500593          	li	a1,69
ffffffffc02018e0:	00005517          	auipc	a0,0x5
ffffffffc02018e4:	43050513          	addi	a0,a0,1072 # ffffffffc0206d10 <etext+0x9cc>
ffffffffc02018e8:	b63fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02018ec <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc02018ec:	c531                	beqz	a0,ffffffffc0201938 <slob_free+0x4c>
		return;

	if (size)
ffffffffc02018ee:	e9b9                	bnez	a1,ffffffffc0201944 <slob_free+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02018f0:	100027f3          	csrr	a5,sstatus
ffffffffc02018f4:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02018f6:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02018f8:	efb1                	bnez	a5,ffffffffc0201954 <slob_free+0x68>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02018fa:	000c6797          	auipc	a5,0xc6
ffffffffc02018fe:	3867b783          	ld	a5,902(a5) # ffffffffc02c7c80 <slobfree>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201902:	873e                	mv	a4,a5
ffffffffc0201904:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201906:	02a77a63          	bgeu	a4,a0,ffffffffc020193a <slob_free+0x4e>
ffffffffc020190a:	00f56463          	bltu	a0,a5,ffffffffc0201912 <slob_free+0x26>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020190e:	fef76ae3          	bltu	a4,a5,ffffffffc0201902 <slob_free+0x16>
			break;

	if (b + b->units == cur->next)
ffffffffc0201912:	4110                	lw	a2,0(a0)
ffffffffc0201914:	00461693          	slli	a3,a2,0x4
ffffffffc0201918:	96aa                	add	a3,a3,a0
ffffffffc020191a:	0ad78463          	beq	a5,a3,ffffffffc02019c2 <slob_free+0xd6>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc020191e:	4310                	lw	a2,0(a4)
ffffffffc0201920:	e51c                	sd	a5,8(a0)
ffffffffc0201922:	00461693          	slli	a3,a2,0x4
ffffffffc0201926:	96ba                	add	a3,a3,a4
ffffffffc0201928:	08d50163          	beq	a0,a3,ffffffffc02019aa <slob_free+0xbe>
ffffffffc020192c:	e708                	sd	a0,8(a4)
		cur->next = b->next;
	}
	else
		cur->next = b;

	slobfree = cur;
ffffffffc020192e:	000c6797          	auipc	a5,0xc6
ffffffffc0201932:	34e7b923          	sd	a4,850(a5) # ffffffffc02c7c80 <slobfree>
    if (flag) {
ffffffffc0201936:	e9a5                	bnez	a1,ffffffffc02019a6 <slob_free+0xba>
ffffffffc0201938:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020193a:	fcf574e3          	bgeu	a0,a5,ffffffffc0201902 <slob_free+0x16>
ffffffffc020193e:	fcf762e3          	bltu	a4,a5,ffffffffc0201902 <slob_free+0x16>
ffffffffc0201942:	bfc1                	j	ffffffffc0201912 <slob_free+0x26>
		b->units = SLOB_UNITS(size);
ffffffffc0201944:	25bd                	addiw	a1,a1,15
ffffffffc0201946:	8191                	srli	a1,a1,0x4
ffffffffc0201948:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020194a:	100027f3          	csrr	a5,sstatus
ffffffffc020194e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201950:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201952:	d7c5                	beqz	a5,ffffffffc02018fa <slob_free+0xe>
{
ffffffffc0201954:	1101                	addi	sp,sp,-32
ffffffffc0201956:	e42a                	sd	a0,8(sp)
ffffffffc0201958:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc020195a:	f61fe0ef          	jal	ffffffffc02008ba <intr_disable>
        return 1;
ffffffffc020195e:	6522                	ld	a0,8(sp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201960:	000c6797          	auipc	a5,0xc6
ffffffffc0201964:	3207b783          	ld	a5,800(a5) # ffffffffc02c7c80 <slobfree>
ffffffffc0201968:	4585                	li	a1,1
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020196a:	873e                	mv	a4,a5
ffffffffc020196c:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020196e:	06a77663          	bgeu	a4,a0,ffffffffc02019da <slob_free+0xee>
ffffffffc0201972:	00f56463          	bltu	a0,a5,ffffffffc020197a <slob_free+0x8e>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201976:	fef76ae3          	bltu	a4,a5,ffffffffc020196a <slob_free+0x7e>
	if (b + b->units == cur->next)
ffffffffc020197a:	4110                	lw	a2,0(a0)
ffffffffc020197c:	00461693          	slli	a3,a2,0x4
ffffffffc0201980:	96aa                	add	a3,a3,a0
ffffffffc0201982:	06d78363          	beq	a5,a3,ffffffffc02019e8 <slob_free+0xfc>
	if (cur + cur->units == b)
ffffffffc0201986:	4310                	lw	a2,0(a4)
ffffffffc0201988:	e51c                	sd	a5,8(a0)
ffffffffc020198a:	00461693          	slli	a3,a2,0x4
ffffffffc020198e:	96ba                	add	a3,a3,a4
ffffffffc0201990:	06d50163          	beq	a0,a3,ffffffffc02019f2 <slob_free+0x106>
ffffffffc0201994:	e708                	sd	a0,8(a4)
	slobfree = cur;
ffffffffc0201996:	000c6797          	auipc	a5,0xc6
ffffffffc020199a:	2ee7b523          	sd	a4,746(a5) # ffffffffc02c7c80 <slobfree>
    if (flag) {
ffffffffc020199e:	e1a9                	bnez	a1,ffffffffc02019e0 <slob_free+0xf4>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc02019a0:	60e2                	ld	ra,24(sp)
ffffffffc02019a2:	6105                	addi	sp,sp,32
ffffffffc02019a4:	8082                	ret
        intr_enable();
ffffffffc02019a6:	f0ffe06f          	j	ffffffffc02008b4 <intr_enable>
		cur->units += b->units;
ffffffffc02019aa:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc02019ac:	853e                	mv	a0,a5
ffffffffc02019ae:	e708                	sd	a0,8(a4)
		cur->units += b->units;
ffffffffc02019b0:	00c687bb          	addw	a5,a3,a2
ffffffffc02019b4:	c31c                	sw	a5,0(a4)
	slobfree = cur;
ffffffffc02019b6:	000c6797          	auipc	a5,0xc6
ffffffffc02019ba:	2ce7b523          	sd	a4,714(a5) # ffffffffc02c7c80 <slobfree>
    if (flag) {
ffffffffc02019be:	ddad                	beqz	a1,ffffffffc0201938 <slob_free+0x4c>
ffffffffc02019c0:	b7dd                	j	ffffffffc02019a6 <slob_free+0xba>
		b->units += cur->next->units;
ffffffffc02019c2:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc02019c4:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc02019c6:	9eb1                	addw	a3,a3,a2
ffffffffc02019c8:	c114                	sw	a3,0(a0)
	if (cur + cur->units == b)
ffffffffc02019ca:	4310                	lw	a2,0(a4)
ffffffffc02019cc:	e51c                	sd	a5,8(a0)
ffffffffc02019ce:	00461693          	slli	a3,a2,0x4
ffffffffc02019d2:	96ba                	add	a3,a3,a4
ffffffffc02019d4:	f4d51ce3          	bne	a0,a3,ffffffffc020192c <slob_free+0x40>
ffffffffc02019d8:	bfc9                	j	ffffffffc02019aa <slob_free+0xbe>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02019da:	f8f56ee3          	bltu	a0,a5,ffffffffc0201976 <slob_free+0x8a>
ffffffffc02019de:	b771                	j	ffffffffc020196a <slob_free+0x7e>
}
ffffffffc02019e0:	60e2                	ld	ra,24(sp)
ffffffffc02019e2:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02019e4:	ed1fe06f          	j	ffffffffc02008b4 <intr_enable>
		b->units += cur->next->units;
ffffffffc02019e8:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc02019ea:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc02019ec:	9eb1                	addw	a3,a3,a2
ffffffffc02019ee:	c114                	sw	a3,0(a0)
		b->next = cur->next->next;
ffffffffc02019f0:	bf59                	j	ffffffffc0201986 <slob_free+0x9a>
		cur->units += b->units;
ffffffffc02019f2:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc02019f4:	853e                	mv	a0,a5
		cur->units += b->units;
ffffffffc02019f6:	00c687bb          	addw	a5,a3,a2
ffffffffc02019fa:	c31c                	sw	a5,0(a4)
		cur->next = b->next;
ffffffffc02019fc:	bf61                	j	ffffffffc0201994 <slob_free+0xa8>

ffffffffc02019fe <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc02019fe:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201a00:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a02:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201a06:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a08:	32a000ef          	jal	ffffffffc0201d32 <alloc_pages>
	if (!page)
ffffffffc0201a0c:	c91d                	beqz	a0,ffffffffc0201a42 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201a0e:	000cb697          	auipc	a3,0xcb
ffffffffc0201a12:	8826b683          	ld	a3,-1918(a3) # ffffffffc02cc290 <pages>
ffffffffc0201a16:	00007797          	auipc	a5,0x7
ffffffffc0201a1a:	6827b783          	ld	a5,1666(a5) # ffffffffc0209098 <nbase>
    return KADDR(page2pa(page));
ffffffffc0201a1e:	000cb717          	auipc	a4,0xcb
ffffffffc0201a22:	86a73703          	ld	a4,-1942(a4) # ffffffffc02cc288 <npage>
    return page - pages + nbase;
ffffffffc0201a26:	8d15                	sub	a0,a0,a3
ffffffffc0201a28:	8519                	srai	a0,a0,0x6
ffffffffc0201a2a:	953e                	add	a0,a0,a5
    return KADDR(page2pa(page));
ffffffffc0201a2c:	00c51793          	slli	a5,a0,0xc
ffffffffc0201a30:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201a32:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201a34:	00e7fa63          	bgeu	a5,a4,ffffffffc0201a48 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201a38:	000cb797          	auipc	a5,0xcb
ffffffffc0201a3c:	8487b783          	ld	a5,-1976(a5) # ffffffffc02cc280 <va_pa_offset>
ffffffffc0201a40:	953e                	add	a0,a0,a5
}
ffffffffc0201a42:	60a2                	ld	ra,8(sp)
ffffffffc0201a44:	0141                	addi	sp,sp,16
ffffffffc0201a46:	8082                	ret
ffffffffc0201a48:	86aa                	mv	a3,a0
ffffffffc0201a4a:	00005617          	auipc	a2,0x5
ffffffffc0201a4e:	65e60613          	addi	a2,a2,1630 # ffffffffc02070a8 <etext+0xd64>
ffffffffc0201a52:	07100593          	li	a1,113
ffffffffc0201a56:	00005517          	auipc	a0,0x5
ffffffffc0201a5a:	67a50513          	addi	a0,a0,1658 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc0201a5e:	9edfe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201a62 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201a62:	7179                	addi	sp,sp,-48
ffffffffc0201a64:	f406                	sd	ra,40(sp)
ffffffffc0201a66:	f022                	sd	s0,32(sp)
ffffffffc0201a68:	ec26                	sd	s1,24(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201a6a:	01050713          	addi	a4,a0,16
ffffffffc0201a6e:	6785                	lui	a5,0x1
ffffffffc0201a70:	0af77e63          	bgeu	a4,a5,ffffffffc0201b2c <slob_alloc.constprop.0+0xca>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201a74:	00f50413          	addi	s0,a0,15
ffffffffc0201a78:	8011                	srli	s0,s0,0x4
ffffffffc0201a7a:	2401                	sext.w	s0,s0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201a7c:	100025f3          	csrr	a1,sstatus
ffffffffc0201a80:	8989                	andi	a1,a1,2
ffffffffc0201a82:	edd1                	bnez	a1,ffffffffc0201b1e <slob_alloc.constprop.0+0xbc>
	prev = slobfree;
ffffffffc0201a84:	000c6497          	auipc	s1,0xc6
ffffffffc0201a88:	1fc48493          	addi	s1,s1,508 # ffffffffc02c7c80 <slobfree>
ffffffffc0201a8c:	6090                	ld	a2,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201a8e:	6618                	ld	a4,8(a2)
		if (cur->units >= units + delta)
ffffffffc0201a90:	4314                	lw	a3,0(a4)
ffffffffc0201a92:	0886da63          	bge	a3,s0,ffffffffc0201b26 <slob_alloc.constprop.0+0xc4>
		if (cur == slobfree)
ffffffffc0201a96:	00e60a63          	beq	a2,a4,ffffffffc0201aaa <slob_alloc.constprop.0+0x48>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201a9a:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201a9c:	4394                	lw	a3,0(a5)
ffffffffc0201a9e:	0286d863          	bge	a3,s0,ffffffffc0201ace <slob_alloc.constprop.0+0x6c>
		if (cur == slobfree)
ffffffffc0201aa2:	6090                	ld	a2,0(s1)
ffffffffc0201aa4:	873e                	mv	a4,a5
ffffffffc0201aa6:	fee61ae3          	bne	a2,a4,ffffffffc0201a9a <slob_alloc.constprop.0+0x38>
    if (flag) {
ffffffffc0201aaa:	e9b1                	bnez	a1,ffffffffc0201afe <slob_alloc.constprop.0+0x9c>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201aac:	4501                	li	a0,0
ffffffffc0201aae:	f51ff0ef          	jal	ffffffffc02019fe <__slob_get_free_pages.constprop.0>
ffffffffc0201ab2:	87aa                	mv	a5,a0
			if (!cur)
ffffffffc0201ab4:	c915                	beqz	a0,ffffffffc0201ae8 <slob_alloc.constprop.0+0x86>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201ab6:	6585                	lui	a1,0x1
ffffffffc0201ab8:	e35ff0ef          	jal	ffffffffc02018ec <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201abc:	100025f3          	csrr	a1,sstatus
ffffffffc0201ac0:	8989                	andi	a1,a1,2
ffffffffc0201ac2:	e98d                	bnez	a1,ffffffffc0201af4 <slob_alloc.constprop.0+0x92>
			cur = slobfree;
ffffffffc0201ac4:	6098                	ld	a4,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201ac6:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201ac8:	4394                	lw	a3,0(a5)
ffffffffc0201aca:	fc86cce3          	blt	a3,s0,ffffffffc0201aa2 <slob_alloc.constprop.0+0x40>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201ace:	04d40563          	beq	s0,a3,ffffffffc0201b18 <slob_alloc.constprop.0+0xb6>
				prev->next = cur + units;
ffffffffc0201ad2:	00441613          	slli	a2,s0,0x4
ffffffffc0201ad6:	963e                	add	a2,a2,a5
ffffffffc0201ad8:	e710                	sd	a2,8(a4)
				prev->next->next = cur->next;
ffffffffc0201ada:	6788                	ld	a0,8(a5)
				prev->next->units = cur->units - units;
ffffffffc0201adc:	9e81                	subw	a3,a3,s0
ffffffffc0201ade:	c214                	sw	a3,0(a2)
				prev->next->next = cur->next;
ffffffffc0201ae0:	e608                	sd	a0,8(a2)
				cur->units = units;
ffffffffc0201ae2:	c380                	sw	s0,0(a5)
			slobfree = prev;
ffffffffc0201ae4:	e098                	sd	a4,0(s1)
    if (flag) {
ffffffffc0201ae6:	ed99                	bnez	a1,ffffffffc0201b04 <slob_alloc.constprop.0+0xa2>
}
ffffffffc0201ae8:	70a2                	ld	ra,40(sp)
ffffffffc0201aea:	7402                	ld	s0,32(sp)
ffffffffc0201aec:	64e2                	ld	s1,24(sp)
ffffffffc0201aee:	853e                	mv	a0,a5
ffffffffc0201af0:	6145                	addi	sp,sp,48
ffffffffc0201af2:	8082                	ret
        intr_disable();
ffffffffc0201af4:	dc7fe0ef          	jal	ffffffffc02008ba <intr_disable>
			cur = slobfree;
ffffffffc0201af8:	6098                	ld	a4,0(s1)
        return 1;
ffffffffc0201afa:	4585                	li	a1,1
ffffffffc0201afc:	b7e9                	j	ffffffffc0201ac6 <slob_alloc.constprop.0+0x64>
        intr_enable();
ffffffffc0201afe:	db7fe0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0201b02:	b76d                	j	ffffffffc0201aac <slob_alloc.constprop.0+0x4a>
ffffffffc0201b04:	e43e                	sd	a5,8(sp)
ffffffffc0201b06:	daffe0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0201b0a:	67a2                	ld	a5,8(sp)
}
ffffffffc0201b0c:	70a2                	ld	ra,40(sp)
ffffffffc0201b0e:	7402                	ld	s0,32(sp)
ffffffffc0201b10:	64e2                	ld	s1,24(sp)
ffffffffc0201b12:	853e                	mv	a0,a5
ffffffffc0201b14:	6145                	addi	sp,sp,48
ffffffffc0201b16:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201b18:	6794                	ld	a3,8(a5)
ffffffffc0201b1a:	e714                	sd	a3,8(a4)
ffffffffc0201b1c:	b7e1                	j	ffffffffc0201ae4 <slob_alloc.constprop.0+0x82>
        intr_disable();
ffffffffc0201b1e:	d9dfe0ef          	jal	ffffffffc02008ba <intr_disable>
        return 1;
ffffffffc0201b22:	4585                	li	a1,1
ffffffffc0201b24:	b785                	j	ffffffffc0201a84 <slob_alloc.constprop.0+0x22>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201b26:	87ba                	mv	a5,a4
	prev = slobfree;
ffffffffc0201b28:	8732                	mv	a4,a2
ffffffffc0201b2a:	b755                	j	ffffffffc0201ace <slob_alloc.constprop.0+0x6c>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201b2c:	00005697          	auipc	a3,0x5
ffffffffc0201b30:	5b468693          	addi	a3,a3,1460 # ffffffffc02070e0 <etext+0xd9c>
ffffffffc0201b34:	00005617          	auipc	a2,0x5
ffffffffc0201b38:	1c460613          	addi	a2,a2,452 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0201b3c:	06300593          	li	a1,99
ffffffffc0201b40:	00005517          	auipc	a0,0x5
ffffffffc0201b44:	5c050513          	addi	a0,a0,1472 # ffffffffc0207100 <etext+0xdbc>
ffffffffc0201b48:	903fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201b4c <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201b4c:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201b4e:	00005517          	auipc	a0,0x5
ffffffffc0201b52:	5ca50513          	addi	a0,a0,1482 # ffffffffc0207118 <etext+0xdd4>
{
ffffffffc0201b56:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201b58:	e40fe0ef          	jal	ffffffffc0200198 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201b5c:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201b5e:	00005517          	auipc	a0,0x5
ffffffffc0201b62:	5d250513          	addi	a0,a0,1490 # ffffffffc0207130 <etext+0xdec>
}
ffffffffc0201b66:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201b68:	e30fe06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0201b6c <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201b6c:	4501                	li	a0,0
ffffffffc0201b6e:	8082                	ret

ffffffffc0201b70 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201b70:	1101                	addi	sp,sp,-32
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201b72:	6685                	lui	a3,0x1
{
ffffffffc0201b74:	ec06                	sd	ra,24(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201b76:	16bd                	addi	a3,a3,-17 # fef <_binary_obj___user_softint_out_size-0x80f1>
ffffffffc0201b78:	04a6f963          	bgeu	a3,a0,ffffffffc0201bca <kmalloc+0x5a>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201b7c:	e42a                	sd	a0,8(sp)
ffffffffc0201b7e:	4561                	li	a0,24
ffffffffc0201b80:	e822                	sd	s0,16(sp)
ffffffffc0201b82:	ee1ff0ef          	jal	ffffffffc0201a62 <slob_alloc.constprop.0>
ffffffffc0201b86:	842a                	mv	s0,a0
	if (!bb)
ffffffffc0201b88:	c541                	beqz	a0,ffffffffc0201c10 <kmalloc+0xa0>
	bb->order = find_order(size);
ffffffffc0201b8a:	47a2                	lw	a5,8(sp)
	for (; size > 4096; size >>= 1)
ffffffffc0201b8c:	6705                	lui	a4,0x1
	int order = 0;
ffffffffc0201b8e:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201b90:	00f75763          	bge	a4,a5,ffffffffc0201b9e <kmalloc+0x2e>
ffffffffc0201b94:	4017d79b          	sraiw	a5,a5,0x1
		order++;
ffffffffc0201b98:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201b9a:	fef74de3          	blt	a4,a5,ffffffffc0201b94 <kmalloc+0x24>
	bb->order = find_order(size);
ffffffffc0201b9e:	c008                	sw	a0,0(s0)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201ba0:	e5fff0ef          	jal	ffffffffc02019fe <__slob_get_free_pages.constprop.0>
ffffffffc0201ba4:	e408                	sd	a0,8(s0)
	if (bb->pages)
ffffffffc0201ba6:	cd31                	beqz	a0,ffffffffc0201c02 <kmalloc+0x92>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201ba8:	100027f3          	csrr	a5,sstatus
ffffffffc0201bac:	8b89                	andi	a5,a5,2
ffffffffc0201bae:	eb85                	bnez	a5,ffffffffc0201bde <kmalloc+0x6e>
		bb->next = bigblocks;
ffffffffc0201bb0:	000ca797          	auipc	a5,0xca
ffffffffc0201bb4:	6b07b783          	ld	a5,1712(a5) # ffffffffc02cc260 <bigblocks>
		bigblocks = bb;
ffffffffc0201bb8:	000ca717          	auipc	a4,0xca
ffffffffc0201bbc:	6a873423          	sd	s0,1704(a4) # ffffffffc02cc260 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201bc0:	e81c                	sd	a5,16(s0)
    if (flag) {
ffffffffc0201bc2:	6442                	ld	s0,16(sp)
	return __kmalloc(size, 0);
}
ffffffffc0201bc4:	60e2                	ld	ra,24(sp)
ffffffffc0201bc6:	6105                	addi	sp,sp,32
ffffffffc0201bc8:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201bca:	0541                	addi	a0,a0,16
ffffffffc0201bcc:	e97ff0ef          	jal	ffffffffc0201a62 <slob_alloc.constprop.0>
ffffffffc0201bd0:	87aa                	mv	a5,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0201bd2:	0541                	addi	a0,a0,16
ffffffffc0201bd4:	fbe5                	bnez	a5,ffffffffc0201bc4 <kmalloc+0x54>
		return 0;
ffffffffc0201bd6:	4501                	li	a0,0
}
ffffffffc0201bd8:	60e2                	ld	ra,24(sp)
ffffffffc0201bda:	6105                	addi	sp,sp,32
ffffffffc0201bdc:	8082                	ret
        intr_disable();
ffffffffc0201bde:	cddfe0ef          	jal	ffffffffc02008ba <intr_disable>
		bb->next = bigblocks;
ffffffffc0201be2:	000ca797          	auipc	a5,0xca
ffffffffc0201be6:	67e7b783          	ld	a5,1662(a5) # ffffffffc02cc260 <bigblocks>
		bigblocks = bb;
ffffffffc0201bea:	000ca717          	auipc	a4,0xca
ffffffffc0201bee:	66873b23          	sd	s0,1654(a4) # ffffffffc02cc260 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201bf2:	e81c                	sd	a5,16(s0)
        intr_enable();
ffffffffc0201bf4:	cc1fe0ef          	jal	ffffffffc02008b4 <intr_enable>
		return bb->pages;
ffffffffc0201bf8:	6408                	ld	a0,8(s0)
}
ffffffffc0201bfa:	60e2                	ld	ra,24(sp)
		return bb->pages;
ffffffffc0201bfc:	6442                	ld	s0,16(sp)
}
ffffffffc0201bfe:	6105                	addi	sp,sp,32
ffffffffc0201c00:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201c02:	8522                	mv	a0,s0
ffffffffc0201c04:	45e1                	li	a1,24
ffffffffc0201c06:	ce7ff0ef          	jal	ffffffffc02018ec <slob_free>
		return 0;
ffffffffc0201c0a:	4501                	li	a0,0
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201c0c:	6442                	ld	s0,16(sp)
ffffffffc0201c0e:	b7e9                	j	ffffffffc0201bd8 <kmalloc+0x68>
ffffffffc0201c10:	6442                	ld	s0,16(sp)
		return 0;
ffffffffc0201c12:	4501                	li	a0,0
ffffffffc0201c14:	b7d1                	j	ffffffffc0201bd8 <kmalloc+0x68>

ffffffffc0201c16 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201c16:	c571                	beqz	a0,ffffffffc0201ce2 <kfree+0xcc>
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201c18:	03451793          	slli	a5,a0,0x34
ffffffffc0201c1c:	e3e1                	bnez	a5,ffffffffc0201cdc <kfree+0xc6>
{
ffffffffc0201c1e:	1101                	addi	sp,sp,-32
ffffffffc0201c20:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201c22:	100027f3          	csrr	a5,sstatus
ffffffffc0201c26:	8b89                	andi	a5,a5,2
ffffffffc0201c28:	e7c1                	bnez	a5,ffffffffc0201cb0 <kfree+0x9a>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201c2a:	000ca797          	auipc	a5,0xca
ffffffffc0201c2e:	6367b783          	ld	a5,1590(a5) # ffffffffc02cc260 <bigblocks>
    return 0;
ffffffffc0201c32:	4581                	li	a1,0
ffffffffc0201c34:	cbad                	beqz	a5,ffffffffc0201ca6 <kfree+0x90>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201c36:	000ca617          	auipc	a2,0xca
ffffffffc0201c3a:	62a60613          	addi	a2,a2,1578 # ffffffffc02cc260 <bigblocks>
ffffffffc0201c3e:	a021                	j	ffffffffc0201c46 <kfree+0x30>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201c40:	01070613          	addi	a2,a4,16
ffffffffc0201c44:	c3a5                	beqz	a5,ffffffffc0201ca4 <kfree+0x8e>
		{
			if (bb->pages == block)
ffffffffc0201c46:	6794                	ld	a3,8(a5)
ffffffffc0201c48:	873e                	mv	a4,a5
			{
				*last = bb->next;
ffffffffc0201c4a:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201c4c:	fea69ae3          	bne	a3,a0,ffffffffc0201c40 <kfree+0x2a>
				*last = bb->next;
ffffffffc0201c50:	e21c                	sd	a5,0(a2)
    if (flag) {
ffffffffc0201c52:	edb5                	bnez	a1,ffffffffc0201cce <kfree+0xb8>
    return pa2page(PADDR(kva));
ffffffffc0201c54:	c02007b7          	lui	a5,0xc0200
ffffffffc0201c58:	0af56263          	bltu	a0,a5,ffffffffc0201cfc <kfree+0xe6>
ffffffffc0201c5c:	000ca797          	auipc	a5,0xca
ffffffffc0201c60:	6247b783          	ld	a5,1572(a5) # ffffffffc02cc280 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0201c64:	000ca697          	auipc	a3,0xca
ffffffffc0201c68:	6246b683          	ld	a3,1572(a3) # ffffffffc02cc288 <npage>
    return pa2page(PADDR(kva));
ffffffffc0201c6c:	8d1d                	sub	a0,a0,a5
    if (PPN(pa) >= npage)
ffffffffc0201c6e:	00c55793          	srli	a5,a0,0xc
ffffffffc0201c72:	06d7f963          	bgeu	a5,a3,ffffffffc0201ce4 <kfree+0xce>
    return &pages[PPN(pa) - nbase];
ffffffffc0201c76:	00007617          	auipc	a2,0x7
ffffffffc0201c7a:	42263603          	ld	a2,1058(a2) # ffffffffc0209098 <nbase>
ffffffffc0201c7e:	000ca517          	auipc	a0,0xca
ffffffffc0201c82:	61253503          	ld	a0,1554(a0) # ffffffffc02cc290 <pages>
	free_pages(kva2page((void *)kva), 1 << order);
ffffffffc0201c86:	4314                	lw	a3,0(a4)
ffffffffc0201c88:	8f91                	sub	a5,a5,a2
ffffffffc0201c8a:	079a                	slli	a5,a5,0x6
ffffffffc0201c8c:	4585                	li	a1,1
ffffffffc0201c8e:	953e                	add	a0,a0,a5
ffffffffc0201c90:	00d595bb          	sllw	a1,a1,a3
ffffffffc0201c94:	e03a                	sd	a4,0(sp)
ffffffffc0201c96:	0d6000ef          	jal	ffffffffc0201d6c <free_pages>
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201c9a:	6502                	ld	a0,0(sp)
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201c9c:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201c9e:	45e1                	li	a1,24
}
ffffffffc0201ca0:	6105                	addi	sp,sp,32
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201ca2:	b1a9                	j	ffffffffc02018ec <slob_free>
ffffffffc0201ca4:	e185                	bnez	a1,ffffffffc0201cc4 <kfree+0xae>
}
ffffffffc0201ca6:	60e2                	ld	ra,24(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201ca8:	1541                	addi	a0,a0,-16
ffffffffc0201caa:	4581                	li	a1,0
}
ffffffffc0201cac:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201cae:	b93d                	j	ffffffffc02018ec <slob_free>
        intr_disable();
ffffffffc0201cb0:	e02a                	sd	a0,0(sp)
ffffffffc0201cb2:	c09fe0ef          	jal	ffffffffc02008ba <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201cb6:	000ca797          	auipc	a5,0xca
ffffffffc0201cba:	5aa7b783          	ld	a5,1450(a5) # ffffffffc02cc260 <bigblocks>
ffffffffc0201cbe:	6502                	ld	a0,0(sp)
        return 1;
ffffffffc0201cc0:	4585                	li	a1,1
ffffffffc0201cc2:	fbb5                	bnez	a5,ffffffffc0201c36 <kfree+0x20>
ffffffffc0201cc4:	e02a                	sd	a0,0(sp)
        intr_enable();
ffffffffc0201cc6:	beffe0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0201cca:	6502                	ld	a0,0(sp)
ffffffffc0201ccc:	bfe9                	j	ffffffffc0201ca6 <kfree+0x90>
ffffffffc0201cce:	e42a                	sd	a0,8(sp)
ffffffffc0201cd0:	e03a                	sd	a4,0(sp)
ffffffffc0201cd2:	be3fe0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0201cd6:	6522                	ld	a0,8(sp)
ffffffffc0201cd8:	6702                	ld	a4,0(sp)
ffffffffc0201cda:	bfad                	j	ffffffffc0201c54 <kfree+0x3e>
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201cdc:	1541                	addi	a0,a0,-16
ffffffffc0201cde:	4581                	li	a1,0
ffffffffc0201ce0:	b131                	j	ffffffffc02018ec <slob_free>
ffffffffc0201ce2:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201ce4:	00005617          	auipc	a2,0x5
ffffffffc0201ce8:	49460613          	addi	a2,a2,1172 # ffffffffc0207178 <etext+0xe34>
ffffffffc0201cec:	06900593          	li	a1,105
ffffffffc0201cf0:	00005517          	auipc	a0,0x5
ffffffffc0201cf4:	3e050513          	addi	a0,a0,992 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc0201cf8:	f52fe0ef          	jal	ffffffffc020044a <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201cfc:	86aa                	mv	a3,a0
ffffffffc0201cfe:	00005617          	auipc	a2,0x5
ffffffffc0201d02:	45260613          	addi	a2,a2,1106 # ffffffffc0207150 <etext+0xe0c>
ffffffffc0201d06:	07700593          	li	a1,119
ffffffffc0201d0a:	00005517          	auipc	a0,0x5
ffffffffc0201d0e:	3c650513          	addi	a0,a0,966 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc0201d12:	f38fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201d16 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201d16:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201d18:	00005617          	auipc	a2,0x5
ffffffffc0201d1c:	46060613          	addi	a2,a2,1120 # ffffffffc0207178 <etext+0xe34>
ffffffffc0201d20:	06900593          	li	a1,105
ffffffffc0201d24:	00005517          	auipc	a0,0x5
ffffffffc0201d28:	3ac50513          	addi	a0,a0,940 # ffffffffc02070d0 <etext+0xd8c>
pa2page(uintptr_t pa)
ffffffffc0201d2c:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201d2e:	f1cfe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201d32 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201d32:	100027f3          	csrr	a5,sstatus
ffffffffc0201d36:	8b89                	andi	a5,a5,2
ffffffffc0201d38:	e799                	bnez	a5,ffffffffc0201d46 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201d3a:	000ca797          	auipc	a5,0xca
ffffffffc0201d3e:	52e7b783          	ld	a5,1326(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc0201d42:	6f9c                	ld	a5,24(a5)
ffffffffc0201d44:	8782                	jr	a5
{
ffffffffc0201d46:	1101                	addi	sp,sp,-32
ffffffffc0201d48:	ec06                	sd	ra,24(sp)
ffffffffc0201d4a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201d4c:	b6ffe0ef          	jal	ffffffffc02008ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201d50:	000ca797          	auipc	a5,0xca
ffffffffc0201d54:	5187b783          	ld	a5,1304(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc0201d58:	6522                	ld	a0,8(sp)
ffffffffc0201d5a:	6f9c                	ld	a5,24(a5)
ffffffffc0201d5c:	9782                	jalr	a5
ffffffffc0201d5e:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201d60:	b55fe0ef          	jal	ffffffffc02008b4 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201d64:	60e2                	ld	ra,24(sp)
ffffffffc0201d66:	6522                	ld	a0,8(sp)
ffffffffc0201d68:	6105                	addi	sp,sp,32
ffffffffc0201d6a:	8082                	ret

ffffffffc0201d6c <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201d6c:	100027f3          	csrr	a5,sstatus
ffffffffc0201d70:	8b89                	andi	a5,a5,2
ffffffffc0201d72:	e799                	bnez	a5,ffffffffc0201d80 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201d74:	000ca797          	auipc	a5,0xca
ffffffffc0201d78:	4f47b783          	ld	a5,1268(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc0201d7c:	739c                	ld	a5,32(a5)
ffffffffc0201d7e:	8782                	jr	a5
{
ffffffffc0201d80:	1101                	addi	sp,sp,-32
ffffffffc0201d82:	ec06                	sd	ra,24(sp)
ffffffffc0201d84:	e42e                	sd	a1,8(sp)
ffffffffc0201d86:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0201d88:	b33fe0ef          	jal	ffffffffc02008ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201d8c:	000ca797          	auipc	a5,0xca
ffffffffc0201d90:	4dc7b783          	ld	a5,1244(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc0201d94:	65a2                	ld	a1,8(sp)
ffffffffc0201d96:	6502                	ld	a0,0(sp)
ffffffffc0201d98:	739c                	ld	a5,32(a5)
ffffffffc0201d9a:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201d9c:	60e2                	ld	ra,24(sp)
ffffffffc0201d9e:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201da0:	b15fe06f          	j	ffffffffc02008b4 <intr_enable>

ffffffffc0201da4 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201da4:	100027f3          	csrr	a5,sstatus
ffffffffc0201da8:	8b89                	andi	a5,a5,2
ffffffffc0201daa:	e799                	bnez	a5,ffffffffc0201db8 <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201dac:	000ca797          	auipc	a5,0xca
ffffffffc0201db0:	4bc7b783          	ld	a5,1212(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc0201db4:	779c                	ld	a5,40(a5)
ffffffffc0201db6:	8782                	jr	a5
{
ffffffffc0201db8:	1101                	addi	sp,sp,-32
ffffffffc0201dba:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201dbc:	afffe0ef          	jal	ffffffffc02008ba <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201dc0:	000ca797          	auipc	a5,0xca
ffffffffc0201dc4:	4a87b783          	ld	a5,1192(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc0201dc8:	779c                	ld	a5,40(a5)
ffffffffc0201dca:	9782                	jalr	a5
ffffffffc0201dcc:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201dce:	ae7fe0ef          	jal	ffffffffc02008b4 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201dd2:	60e2                	ld	ra,24(sp)
ffffffffc0201dd4:	6522                	ld	a0,8(sp)
ffffffffc0201dd6:	6105                	addi	sp,sp,32
ffffffffc0201dd8:	8082                	ret

ffffffffc0201dda <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201dda:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201dde:	1ff7f793          	andi	a5,a5,511
ffffffffc0201de2:	078e                	slli	a5,a5,0x3
ffffffffc0201de4:	00f50733          	add	a4,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201de8:	6314                	ld	a3,0(a4)
{
ffffffffc0201dea:	7139                	addi	sp,sp,-64
ffffffffc0201dec:	f822                	sd	s0,48(sp)
ffffffffc0201dee:	f426                	sd	s1,40(sp)
ffffffffc0201df0:	fc06                	sd	ra,56(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201df2:	0016f793          	andi	a5,a3,1
{
ffffffffc0201df6:	842e                	mv	s0,a1
ffffffffc0201df8:	8832                	mv	a6,a2
ffffffffc0201dfa:	000ca497          	auipc	s1,0xca
ffffffffc0201dfe:	48e48493          	addi	s1,s1,1166 # ffffffffc02cc288 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201e02:	ebd1                	bnez	a5,ffffffffc0201e96 <get_pte+0xbc>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201e04:	16060d63          	beqz	a2,ffffffffc0201f7e <get_pte+0x1a4>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201e08:	100027f3          	csrr	a5,sstatus
ffffffffc0201e0c:	8b89                	andi	a5,a5,2
ffffffffc0201e0e:	16079e63          	bnez	a5,ffffffffc0201f8a <get_pte+0x1b0>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201e12:	000ca797          	auipc	a5,0xca
ffffffffc0201e16:	4567b783          	ld	a5,1110(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc0201e1a:	4505                	li	a0,1
ffffffffc0201e1c:	e43a                	sd	a4,8(sp)
ffffffffc0201e1e:	6f9c                	ld	a5,24(a5)
ffffffffc0201e20:	e832                	sd	a2,16(sp)
ffffffffc0201e22:	9782                	jalr	a5
ffffffffc0201e24:	6722                	ld	a4,8(sp)
ffffffffc0201e26:	6842                	ld	a6,16(sp)
ffffffffc0201e28:	87aa                	mv	a5,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201e2a:	14078a63          	beqz	a5,ffffffffc0201f7e <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0201e2e:	000ca517          	auipc	a0,0xca
ffffffffc0201e32:	46253503          	ld	a0,1122(a0) # ffffffffc02cc290 <pages>
ffffffffc0201e36:	000808b7          	lui	a7,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201e3a:	000ca497          	auipc	s1,0xca
ffffffffc0201e3e:	44e48493          	addi	s1,s1,1102 # ffffffffc02cc288 <npage>
ffffffffc0201e42:	40a78533          	sub	a0,a5,a0
ffffffffc0201e46:	8519                	srai	a0,a0,0x6
ffffffffc0201e48:	9546                	add	a0,a0,a7
ffffffffc0201e4a:	6090                	ld	a2,0(s1)
ffffffffc0201e4c:	00c51693          	slli	a3,a0,0xc
    page->ref = val;
ffffffffc0201e50:	4585                	li	a1,1
ffffffffc0201e52:	82b1                	srli	a3,a3,0xc
ffffffffc0201e54:	c38c                	sw	a1,0(a5)
    return page2ppn(page) << PGSHIFT;
ffffffffc0201e56:	0532                	slli	a0,a0,0xc
ffffffffc0201e58:	1ac6f763          	bgeu	a3,a2,ffffffffc0202006 <get_pte+0x22c>
ffffffffc0201e5c:	000ca697          	auipc	a3,0xca
ffffffffc0201e60:	4246b683          	ld	a3,1060(a3) # ffffffffc02cc280 <va_pa_offset>
ffffffffc0201e64:	6605                	lui	a2,0x1
ffffffffc0201e66:	4581                	li	a1,0
ffffffffc0201e68:	9536                	add	a0,a0,a3
ffffffffc0201e6a:	ec42                	sd	a6,24(sp)
ffffffffc0201e6c:	e83e                	sd	a5,16(sp)
ffffffffc0201e6e:	e43a                	sd	a4,8(sp)
ffffffffc0201e70:	4aa040ef          	jal	ffffffffc020631a <memset>
    return page - pages + nbase;
ffffffffc0201e74:	000ca697          	auipc	a3,0xca
ffffffffc0201e78:	41c6b683          	ld	a3,1052(a3) # ffffffffc02cc290 <pages>
ffffffffc0201e7c:	67c2                	ld	a5,16(sp)
ffffffffc0201e7e:	000808b7          	lui	a7,0x80
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201e82:	6722                	ld	a4,8(sp)
ffffffffc0201e84:	40d786b3          	sub	a3,a5,a3
ffffffffc0201e88:	8699                	srai	a3,a3,0x6
ffffffffc0201e8a:	96c6                	add	a3,a3,a7
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201e8c:	06aa                	slli	a3,a3,0xa
ffffffffc0201e8e:	6862                	ld	a6,24(sp)
ffffffffc0201e90:	0116e693          	ori	a3,a3,17
ffffffffc0201e94:	e314                	sd	a3,0(a4)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201e96:	c006f693          	andi	a3,a3,-1024
ffffffffc0201e9a:	6098                	ld	a4,0(s1)
ffffffffc0201e9c:	068a                	slli	a3,a3,0x2
ffffffffc0201e9e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201ea2:	14e7f663          	bgeu	a5,a4,ffffffffc0201fee <get_pte+0x214>
ffffffffc0201ea6:	000ca897          	auipc	a7,0xca
ffffffffc0201eaa:	3da88893          	addi	a7,a7,986 # ffffffffc02cc280 <va_pa_offset>
ffffffffc0201eae:	0008b603          	ld	a2,0(a7)
ffffffffc0201eb2:	01545793          	srli	a5,s0,0x15
ffffffffc0201eb6:	1ff7f793          	andi	a5,a5,511
ffffffffc0201eba:	96b2                	add	a3,a3,a2
ffffffffc0201ebc:	078e                	slli	a5,a5,0x3
ffffffffc0201ebe:	97b6                	add	a5,a5,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0201ec0:	6394                	ld	a3,0(a5)
ffffffffc0201ec2:	0016f613          	andi	a2,a3,1
ffffffffc0201ec6:	e659                	bnez	a2,ffffffffc0201f54 <get_pte+0x17a>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201ec8:	0a080b63          	beqz	a6,ffffffffc0201f7e <get_pte+0x1a4>
ffffffffc0201ecc:	10002773          	csrr	a4,sstatus
ffffffffc0201ed0:	8b09                	andi	a4,a4,2
ffffffffc0201ed2:	ef71                	bnez	a4,ffffffffc0201fae <get_pte+0x1d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ed4:	000ca717          	auipc	a4,0xca
ffffffffc0201ed8:	39473703          	ld	a4,916(a4) # ffffffffc02cc268 <pmm_manager>
ffffffffc0201edc:	4505                	li	a0,1
ffffffffc0201ede:	e43e                	sd	a5,8(sp)
ffffffffc0201ee0:	6f18                	ld	a4,24(a4)
ffffffffc0201ee2:	9702                	jalr	a4
ffffffffc0201ee4:	67a2                	ld	a5,8(sp)
ffffffffc0201ee6:	872a                	mv	a4,a0
ffffffffc0201ee8:	000ca897          	auipc	a7,0xca
ffffffffc0201eec:	39888893          	addi	a7,a7,920 # ffffffffc02cc280 <va_pa_offset>
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201ef0:	c759                	beqz	a4,ffffffffc0201f7e <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0201ef2:	000ca697          	auipc	a3,0xca
ffffffffc0201ef6:	39e6b683          	ld	a3,926(a3) # ffffffffc02cc290 <pages>
ffffffffc0201efa:	00080837          	lui	a6,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201efe:	608c                	ld	a1,0(s1)
ffffffffc0201f00:	40d706b3          	sub	a3,a4,a3
ffffffffc0201f04:	8699                	srai	a3,a3,0x6
ffffffffc0201f06:	96c2                	add	a3,a3,a6
ffffffffc0201f08:	00c69613          	slli	a2,a3,0xc
    page->ref = val;
ffffffffc0201f0c:	4505                	li	a0,1
ffffffffc0201f0e:	8231                	srli	a2,a2,0xc
ffffffffc0201f10:	c308                	sw	a0,0(a4)
    return page2ppn(page) << PGSHIFT;
ffffffffc0201f12:	06b2                	slli	a3,a3,0xc
ffffffffc0201f14:	10b67663          	bgeu	a2,a1,ffffffffc0202020 <get_pte+0x246>
ffffffffc0201f18:	0008b503          	ld	a0,0(a7)
ffffffffc0201f1c:	6605                	lui	a2,0x1
ffffffffc0201f1e:	4581                	li	a1,0
ffffffffc0201f20:	9536                	add	a0,a0,a3
ffffffffc0201f22:	e83a                	sd	a4,16(sp)
ffffffffc0201f24:	e43e                	sd	a5,8(sp)
ffffffffc0201f26:	3f4040ef          	jal	ffffffffc020631a <memset>
    return page - pages + nbase;
ffffffffc0201f2a:	000ca697          	auipc	a3,0xca
ffffffffc0201f2e:	3666b683          	ld	a3,870(a3) # ffffffffc02cc290 <pages>
ffffffffc0201f32:	6742                	ld	a4,16(sp)
ffffffffc0201f34:	00080837          	lui	a6,0x80
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201f38:	67a2                	ld	a5,8(sp)
ffffffffc0201f3a:	40d706b3          	sub	a3,a4,a3
ffffffffc0201f3e:	8699                	srai	a3,a3,0x6
ffffffffc0201f40:	96c2                	add	a3,a3,a6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201f42:	06aa                	slli	a3,a3,0xa
ffffffffc0201f44:	0116e693          	ori	a3,a3,17
ffffffffc0201f48:	e394                	sd	a3,0(a5)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f4a:	6098                	ld	a4,0(s1)
ffffffffc0201f4c:	000ca897          	auipc	a7,0xca
ffffffffc0201f50:	33488893          	addi	a7,a7,820 # ffffffffc02cc280 <va_pa_offset>
ffffffffc0201f54:	c006f693          	andi	a3,a3,-1024
ffffffffc0201f58:	068a                	slli	a3,a3,0x2
ffffffffc0201f5a:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201f5e:	06e7fc63          	bgeu	a5,a4,ffffffffc0201fd6 <get_pte+0x1fc>
ffffffffc0201f62:	0008b783          	ld	a5,0(a7)
ffffffffc0201f66:	8031                	srli	s0,s0,0xc
ffffffffc0201f68:	1ff47413          	andi	s0,s0,511
ffffffffc0201f6c:	040e                	slli	s0,s0,0x3
ffffffffc0201f6e:	96be                	add	a3,a3,a5
}
ffffffffc0201f70:	70e2                	ld	ra,56(sp)
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f72:	00868533          	add	a0,a3,s0
}
ffffffffc0201f76:	7442                	ld	s0,48(sp)
ffffffffc0201f78:	74a2                	ld	s1,40(sp)
ffffffffc0201f7a:	6121                	addi	sp,sp,64
ffffffffc0201f7c:	8082                	ret
ffffffffc0201f7e:	70e2                	ld	ra,56(sp)
ffffffffc0201f80:	7442                	ld	s0,48(sp)
ffffffffc0201f82:	74a2                	ld	s1,40(sp)
            return NULL;
ffffffffc0201f84:	4501                	li	a0,0
}
ffffffffc0201f86:	6121                	addi	sp,sp,64
ffffffffc0201f88:	8082                	ret
        intr_disable();
ffffffffc0201f8a:	e83a                	sd	a4,16(sp)
ffffffffc0201f8c:	ec32                	sd	a2,24(sp)
ffffffffc0201f8e:	92dfe0ef          	jal	ffffffffc02008ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f92:	000ca797          	auipc	a5,0xca
ffffffffc0201f96:	2d67b783          	ld	a5,726(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc0201f9a:	4505                	li	a0,1
ffffffffc0201f9c:	6f9c                	ld	a5,24(a5)
ffffffffc0201f9e:	9782                	jalr	a5
ffffffffc0201fa0:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201fa2:	913fe0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0201fa6:	6862                	ld	a6,24(sp)
ffffffffc0201fa8:	6742                	ld	a4,16(sp)
ffffffffc0201faa:	67a2                	ld	a5,8(sp)
ffffffffc0201fac:	bdbd                	j	ffffffffc0201e2a <get_pte+0x50>
        intr_disable();
ffffffffc0201fae:	e83e                	sd	a5,16(sp)
ffffffffc0201fb0:	90bfe0ef          	jal	ffffffffc02008ba <intr_disable>
ffffffffc0201fb4:	000ca717          	auipc	a4,0xca
ffffffffc0201fb8:	2b473703          	ld	a4,692(a4) # ffffffffc02cc268 <pmm_manager>
ffffffffc0201fbc:	4505                	li	a0,1
ffffffffc0201fbe:	6f18                	ld	a4,24(a4)
ffffffffc0201fc0:	9702                	jalr	a4
ffffffffc0201fc2:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201fc4:	8f1fe0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0201fc8:	6722                	ld	a4,8(sp)
ffffffffc0201fca:	67c2                	ld	a5,16(sp)
ffffffffc0201fcc:	000ca897          	auipc	a7,0xca
ffffffffc0201fd0:	2b488893          	addi	a7,a7,692 # ffffffffc02cc280 <va_pa_offset>
ffffffffc0201fd4:	bf31                	j	ffffffffc0201ef0 <get_pte+0x116>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201fd6:	00005617          	auipc	a2,0x5
ffffffffc0201fda:	0d260613          	addi	a2,a2,210 # ffffffffc02070a8 <etext+0xd64>
ffffffffc0201fde:	0f900593          	li	a1,249
ffffffffc0201fe2:	00005517          	auipc	a0,0x5
ffffffffc0201fe6:	1b650513          	addi	a0,a0,438 # ffffffffc0207198 <etext+0xe54>
ffffffffc0201fea:	c60fe0ef          	jal	ffffffffc020044a <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201fee:	00005617          	auipc	a2,0x5
ffffffffc0201ff2:	0ba60613          	addi	a2,a2,186 # ffffffffc02070a8 <etext+0xd64>
ffffffffc0201ff6:	0ec00593          	li	a1,236
ffffffffc0201ffa:	00005517          	auipc	a0,0x5
ffffffffc0201ffe:	19e50513          	addi	a0,a0,414 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202002:	c48fe0ef          	jal	ffffffffc020044a <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202006:	86aa                	mv	a3,a0
ffffffffc0202008:	00005617          	auipc	a2,0x5
ffffffffc020200c:	0a060613          	addi	a2,a2,160 # ffffffffc02070a8 <etext+0xd64>
ffffffffc0202010:	0e800593          	li	a1,232
ffffffffc0202014:	00005517          	auipc	a0,0x5
ffffffffc0202018:	18450513          	addi	a0,a0,388 # ffffffffc0207198 <etext+0xe54>
ffffffffc020201c:	c2efe0ef          	jal	ffffffffc020044a <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202020:	00005617          	auipc	a2,0x5
ffffffffc0202024:	08860613          	addi	a2,a2,136 # ffffffffc02070a8 <etext+0xd64>
ffffffffc0202028:	0f600593          	li	a1,246
ffffffffc020202c:	00005517          	auipc	a0,0x5
ffffffffc0202030:	16c50513          	addi	a0,a0,364 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202034:	c16fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0202038 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0202038:	1141                	addi	sp,sp,-16
ffffffffc020203a:	e022                	sd	s0,0(sp)
ffffffffc020203c:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020203e:	4601                	li	a2,0
{
ffffffffc0202040:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202042:	d99ff0ef          	jal	ffffffffc0201dda <get_pte>
    if (ptep_store != NULL)
ffffffffc0202046:	c011                	beqz	s0,ffffffffc020204a <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0202048:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020204a:	c511                	beqz	a0,ffffffffc0202056 <get_page+0x1e>
ffffffffc020204c:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc020204e:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202050:	0017f713          	andi	a4,a5,1
ffffffffc0202054:	e709                	bnez	a4,ffffffffc020205e <get_page+0x26>
}
ffffffffc0202056:	60a2                	ld	ra,8(sp)
ffffffffc0202058:	6402                	ld	s0,0(sp)
ffffffffc020205a:	0141                	addi	sp,sp,16
ffffffffc020205c:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc020205e:	000ca717          	auipc	a4,0xca
ffffffffc0202062:	22a73703          	ld	a4,554(a4) # ffffffffc02cc288 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0202066:	078a                	slli	a5,a5,0x2
ffffffffc0202068:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020206a:	00e7ff63          	bgeu	a5,a4,ffffffffc0202088 <get_page+0x50>
    return &pages[PPN(pa) - nbase];
ffffffffc020206e:	000ca517          	auipc	a0,0xca
ffffffffc0202072:	22253503          	ld	a0,546(a0) # ffffffffc02cc290 <pages>
ffffffffc0202076:	60a2                	ld	ra,8(sp)
ffffffffc0202078:	6402                	ld	s0,0(sp)
ffffffffc020207a:	079a                	slli	a5,a5,0x6
ffffffffc020207c:	fe000737          	lui	a4,0xfe000
ffffffffc0202080:	97ba                	add	a5,a5,a4
ffffffffc0202082:	953e                	add	a0,a0,a5
ffffffffc0202084:	0141                	addi	sp,sp,16
ffffffffc0202086:	8082                	ret
ffffffffc0202088:	c8fff0ef          	jal	ffffffffc0201d16 <pa2page.part.0>

ffffffffc020208c <unmap_range>:
        tlb_invalidate(pgdir, la); //(6) flush tlb
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc020208c:	715d                	addi	sp,sp,-80
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020208e:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202092:	e486                	sd	ra,72(sp)
ffffffffc0202094:	e0a2                	sd	s0,64(sp)
ffffffffc0202096:	fc26                	sd	s1,56(sp)
ffffffffc0202098:	f84a                	sd	s2,48(sp)
ffffffffc020209a:	f44e                	sd	s3,40(sp)
ffffffffc020209c:	f052                	sd	s4,32(sp)
ffffffffc020209e:	ec56                	sd	s5,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02020a0:	03479713          	slli	a4,a5,0x34
ffffffffc02020a4:	ef61                	bnez	a4,ffffffffc020217c <unmap_range+0xf0>
    assert(USER_ACCESS(start, end));
ffffffffc02020a6:	00200a37          	lui	s4,0x200
ffffffffc02020aa:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc02020ae:	0145b733          	sltu	a4,a1,s4
ffffffffc02020b2:	0017b793          	seqz	a5,a5
ffffffffc02020b6:	8fd9                	or	a5,a5,a4
ffffffffc02020b8:	842e                	mv	s0,a1
ffffffffc02020ba:	84b2                	mv	s1,a2
ffffffffc02020bc:	e3e5                	bnez	a5,ffffffffc020219c <unmap_range+0x110>
ffffffffc02020be:	4785                	li	a5,1
ffffffffc02020c0:	07fe                	slli	a5,a5,0x1f
ffffffffc02020c2:	0785                	addi	a5,a5,1
ffffffffc02020c4:	892a                	mv	s2,a0
ffffffffc02020c6:	6985                	lui	s3,0x1
    do
    {
        pte_t *ptep = get_pte(pgdir, start, 0);
        if (ptep == NULL)
        {
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02020c8:	ffe00ab7          	lui	s5,0xffe00
    assert(USER_ACCESS(start, end));
ffffffffc02020cc:	0cf67863          	bgeu	a2,a5,ffffffffc020219c <unmap_range+0x110>
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc02020d0:	4601                	li	a2,0
ffffffffc02020d2:	85a2                	mv	a1,s0
ffffffffc02020d4:	854a                	mv	a0,s2
ffffffffc02020d6:	d05ff0ef          	jal	ffffffffc0201dda <get_pte>
ffffffffc02020da:	87aa                	mv	a5,a0
        if (ptep == NULL)
ffffffffc02020dc:	cd31                	beqz	a0,ffffffffc0202138 <unmap_range+0xac>
            continue;
        }
        if (*ptep != 0)
ffffffffc02020de:	6118                	ld	a4,0(a0)
ffffffffc02020e0:	ef11                	bnez	a4,ffffffffc02020fc <unmap_range+0x70>
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc02020e2:	944e                	add	s0,s0,s3
    } while (start != 0 && start < end);
ffffffffc02020e4:	c019                	beqz	s0,ffffffffc02020ea <unmap_range+0x5e>
ffffffffc02020e6:	fe9465e3          	bltu	s0,s1,ffffffffc02020d0 <unmap_range+0x44>
}
ffffffffc02020ea:	60a6                	ld	ra,72(sp)
ffffffffc02020ec:	6406                	ld	s0,64(sp)
ffffffffc02020ee:	74e2                	ld	s1,56(sp)
ffffffffc02020f0:	7942                	ld	s2,48(sp)
ffffffffc02020f2:	79a2                	ld	s3,40(sp)
ffffffffc02020f4:	7a02                	ld	s4,32(sp)
ffffffffc02020f6:	6ae2                	ld	s5,24(sp)
ffffffffc02020f8:	6161                	addi	sp,sp,80
ffffffffc02020fa:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc02020fc:	00177693          	andi	a3,a4,1
ffffffffc0202100:	d2ed                	beqz	a3,ffffffffc02020e2 <unmap_range+0x56>
    if (PPN(pa) >= npage)
ffffffffc0202102:	000ca697          	auipc	a3,0xca
ffffffffc0202106:	1866b683          	ld	a3,390(a3) # ffffffffc02cc288 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc020210a:	070a                	slli	a4,a4,0x2
ffffffffc020210c:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc020210e:	0ad77763          	bgeu	a4,a3,ffffffffc02021bc <unmap_range+0x130>
    return &pages[PPN(pa) - nbase];
ffffffffc0202112:	000ca517          	auipc	a0,0xca
ffffffffc0202116:	17e53503          	ld	a0,382(a0) # ffffffffc02cc290 <pages>
ffffffffc020211a:	071a                	slli	a4,a4,0x6
ffffffffc020211c:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202120:	9736                	add	a4,a4,a3
ffffffffc0202122:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc0202124:	4118                	lw	a4,0(a0)
ffffffffc0202126:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3dd33d37>
ffffffffc0202128:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc020212a:	cb19                	beqz	a4,ffffffffc0202140 <unmap_range+0xb4>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc020212c:	0007b023          	sd	zero,0(a5)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202130:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202134:	944e                	add	s0,s0,s3
ffffffffc0202136:	b77d                	j	ffffffffc02020e4 <unmap_range+0x58>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202138:	9452                	add	s0,s0,s4
ffffffffc020213a:	01547433          	and	s0,s0,s5
            continue;
ffffffffc020213e:	b75d                	j	ffffffffc02020e4 <unmap_range+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202140:	10002773          	csrr	a4,sstatus
ffffffffc0202144:	8b09                	andi	a4,a4,2
ffffffffc0202146:	eb19                	bnez	a4,ffffffffc020215c <unmap_range+0xd0>
        pmm_manager->free_pages(base, n);
ffffffffc0202148:	000ca717          	auipc	a4,0xca
ffffffffc020214c:	12073703          	ld	a4,288(a4) # ffffffffc02cc268 <pmm_manager>
ffffffffc0202150:	4585                	li	a1,1
ffffffffc0202152:	e03e                	sd	a5,0(sp)
ffffffffc0202154:	7318                	ld	a4,32(a4)
ffffffffc0202156:	9702                	jalr	a4
    if (flag) {
ffffffffc0202158:	6782                	ld	a5,0(sp)
ffffffffc020215a:	bfc9                	j	ffffffffc020212c <unmap_range+0xa0>
        intr_disable();
ffffffffc020215c:	e43e                	sd	a5,8(sp)
ffffffffc020215e:	e02a                	sd	a0,0(sp)
ffffffffc0202160:	f5afe0ef          	jal	ffffffffc02008ba <intr_disable>
ffffffffc0202164:	000ca717          	auipc	a4,0xca
ffffffffc0202168:	10473703          	ld	a4,260(a4) # ffffffffc02cc268 <pmm_manager>
ffffffffc020216c:	6502                	ld	a0,0(sp)
ffffffffc020216e:	4585                	li	a1,1
ffffffffc0202170:	7318                	ld	a4,32(a4)
ffffffffc0202172:	9702                	jalr	a4
        intr_enable();
ffffffffc0202174:	f40fe0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0202178:	67a2                	ld	a5,8(sp)
ffffffffc020217a:	bf4d                	j	ffffffffc020212c <unmap_range+0xa0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020217c:	00005697          	auipc	a3,0x5
ffffffffc0202180:	02c68693          	addi	a3,a3,44 # ffffffffc02071a8 <etext+0xe64>
ffffffffc0202184:	00005617          	auipc	a2,0x5
ffffffffc0202188:	b7460613          	addi	a2,a2,-1164 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc020218c:	12100593          	li	a1,289
ffffffffc0202190:	00005517          	auipc	a0,0x5
ffffffffc0202194:	00850513          	addi	a0,a0,8 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202198:	ab2fe0ef          	jal	ffffffffc020044a <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020219c:	00005697          	auipc	a3,0x5
ffffffffc02021a0:	03c68693          	addi	a3,a3,60 # ffffffffc02071d8 <etext+0xe94>
ffffffffc02021a4:	00005617          	auipc	a2,0x5
ffffffffc02021a8:	b5460613          	addi	a2,a2,-1196 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02021ac:	12200593          	li	a1,290
ffffffffc02021b0:	00005517          	auipc	a0,0x5
ffffffffc02021b4:	fe850513          	addi	a0,a0,-24 # ffffffffc0207198 <etext+0xe54>
ffffffffc02021b8:	a92fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02021bc:	b5bff0ef          	jal	ffffffffc0201d16 <pa2page.part.0>

ffffffffc02021c0 <exit_range>:
{
ffffffffc02021c0:	7135                	addi	sp,sp,-160
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02021c2:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02021c6:	ed06                	sd	ra,152(sp)
ffffffffc02021c8:	e922                	sd	s0,144(sp)
ffffffffc02021ca:	e526                	sd	s1,136(sp)
ffffffffc02021cc:	e14a                	sd	s2,128(sp)
ffffffffc02021ce:	fcce                	sd	s3,120(sp)
ffffffffc02021d0:	f8d2                	sd	s4,112(sp)
ffffffffc02021d2:	f4d6                	sd	s5,104(sp)
ffffffffc02021d4:	f0da                	sd	s6,96(sp)
ffffffffc02021d6:	ecde                	sd	s7,88(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02021d8:	17d2                	slli	a5,a5,0x34
ffffffffc02021da:	22079263          	bnez	a5,ffffffffc02023fe <exit_range+0x23e>
    assert(USER_ACCESS(start, end));
ffffffffc02021de:	00200937          	lui	s2,0x200
ffffffffc02021e2:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc02021e6:	0125b733          	sltu	a4,a1,s2
ffffffffc02021ea:	0017b793          	seqz	a5,a5
ffffffffc02021ee:	8fd9                	or	a5,a5,a4
ffffffffc02021f0:	26079263          	bnez	a5,ffffffffc0202454 <exit_range+0x294>
ffffffffc02021f4:	4785                	li	a5,1
ffffffffc02021f6:	07fe                	slli	a5,a5,0x1f
ffffffffc02021f8:	0785                	addi	a5,a5,1
ffffffffc02021fa:	24f67d63          	bgeu	a2,a5,ffffffffc0202454 <exit_range+0x294>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc02021fe:	c00004b7          	lui	s1,0xc0000
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202202:	ffe007b7          	lui	a5,0xffe00
ffffffffc0202206:	8a2a                	mv	s4,a0
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc0202208:	8ced                	and	s1,s1,a1
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc020220a:	00f5f833          	and	a6,a1,a5
    if (PPN(pa) >= npage)
ffffffffc020220e:	000caa97          	auipc	s5,0xca
ffffffffc0202212:	07aa8a93          	addi	s5,s5,122 # ffffffffc02cc288 <npage>
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202216:	400009b7          	lui	s3,0x40000
ffffffffc020221a:	a809                	j	ffffffffc020222c <exit_range+0x6c>
        d1start += PDSIZE;
ffffffffc020221c:	013487b3          	add	a5,s1,s3
ffffffffc0202220:	400004b7          	lui	s1,0x40000
        d0start = d1start;
ffffffffc0202224:	8826                	mv	a6,s1
    } while (d1start != 0 && d1start < end);
ffffffffc0202226:	c3f1                	beqz	a5,ffffffffc02022ea <exit_range+0x12a>
ffffffffc0202228:	0cc7f163          	bgeu	a5,a2,ffffffffc02022ea <exit_range+0x12a>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc020222c:	01e4d413          	srli	s0,s1,0x1e
ffffffffc0202230:	1ff47413          	andi	s0,s0,511
ffffffffc0202234:	040e                	slli	s0,s0,0x3
ffffffffc0202236:	9452                	add	s0,s0,s4
ffffffffc0202238:	00043883          	ld	a7,0(s0)
        if (pde1 & PTE_V)
ffffffffc020223c:	0018f793          	andi	a5,a7,1
ffffffffc0202240:	dff1                	beqz	a5,ffffffffc020221c <exit_range+0x5c>
ffffffffc0202242:	000ab783          	ld	a5,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202246:	088a                	slli	a7,a7,0x2
ffffffffc0202248:	00c8d893          	srli	a7,a7,0xc
    if (PPN(pa) >= npage)
ffffffffc020224c:	20f8f263          	bgeu	a7,a5,ffffffffc0202450 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc0202250:	fff802b7          	lui	t0,0xfff80
ffffffffc0202254:	00588f33          	add	t5,a7,t0
    return page - pages + nbase;
ffffffffc0202258:	000803b7          	lui	t2,0x80
ffffffffc020225c:	007f0733          	add	a4,t5,t2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202260:	00c71e13          	slli	t3,a4,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202264:	0f1a                	slli	t5,t5,0x6
    return KADDR(page2pa(page));
ffffffffc0202266:	1cf77863          	bgeu	a4,a5,ffffffffc0202436 <exit_range+0x276>
ffffffffc020226a:	000caf97          	auipc	t6,0xca
ffffffffc020226e:	016f8f93          	addi	t6,t6,22 # ffffffffc02cc280 <va_pa_offset>
ffffffffc0202272:	000fb783          	ld	a5,0(t6)
            free_pd0 = 1;
ffffffffc0202276:	4e85                	li	t4,1
ffffffffc0202278:	6b05                	lui	s6,0x1
ffffffffc020227a:	9e3e                	add	t3,t3,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc020227c:	01348333          	add	t1,s1,s3
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202280:	01585713          	srli	a4,a6,0x15
ffffffffc0202284:	1ff77713          	andi	a4,a4,511
ffffffffc0202288:	070e                	slli	a4,a4,0x3
ffffffffc020228a:	9772                	add	a4,a4,t3
ffffffffc020228c:	631c                	ld	a5,0(a4)
                if (pde0 & PTE_V)
ffffffffc020228e:	0017f693          	andi	a3,a5,1
ffffffffc0202292:	e6bd                	bnez	a3,ffffffffc0202300 <exit_range+0x140>
                    free_pd0 = 0;
ffffffffc0202294:	4e81                	li	t4,0
                d0start += PTSIZE;
ffffffffc0202296:	984a                	add	a6,a6,s2
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202298:	00080863          	beqz	a6,ffffffffc02022a8 <exit_range+0xe8>
ffffffffc020229c:	879a                	mv	a5,t1
ffffffffc020229e:	00667363          	bgeu	a2,t1,ffffffffc02022a4 <exit_range+0xe4>
ffffffffc02022a2:	87b2                	mv	a5,a2
ffffffffc02022a4:	fcf86ee3          	bltu	a6,a5,ffffffffc0202280 <exit_range+0xc0>
            if (free_pd0)
ffffffffc02022a8:	f60e8ae3          	beqz	t4,ffffffffc020221c <exit_range+0x5c>
    if (PPN(pa) >= npage)
ffffffffc02022ac:	000ab783          	ld	a5,0(s5)
ffffffffc02022b0:	1af8f063          	bgeu	a7,a5,ffffffffc0202450 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc02022b4:	000ca517          	auipc	a0,0xca
ffffffffc02022b8:	fdc53503          	ld	a0,-36(a0) # ffffffffc02cc290 <pages>
ffffffffc02022bc:	957a                	add	a0,a0,t5
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02022be:	100027f3          	csrr	a5,sstatus
ffffffffc02022c2:	8b89                	andi	a5,a5,2
ffffffffc02022c4:	10079b63          	bnez	a5,ffffffffc02023da <exit_range+0x21a>
        pmm_manager->free_pages(base, n);
ffffffffc02022c8:	000ca797          	auipc	a5,0xca
ffffffffc02022cc:	fa07b783          	ld	a5,-96(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc02022d0:	4585                	li	a1,1
ffffffffc02022d2:	e432                	sd	a2,8(sp)
ffffffffc02022d4:	739c                	ld	a5,32(a5)
ffffffffc02022d6:	9782                	jalr	a5
ffffffffc02022d8:	6622                	ld	a2,8(sp)
                pgdir[PDX1(d1start)] = 0;
ffffffffc02022da:	00043023          	sd	zero,0(s0)
        d1start += PDSIZE;
ffffffffc02022de:	013487b3          	add	a5,s1,s3
ffffffffc02022e2:	400004b7          	lui	s1,0x40000
        d0start = d1start;
ffffffffc02022e6:	8826                	mv	a6,s1
    } while (d1start != 0 && d1start < end);
ffffffffc02022e8:	f3a1                	bnez	a5,ffffffffc0202228 <exit_range+0x68>
}
ffffffffc02022ea:	60ea                	ld	ra,152(sp)
ffffffffc02022ec:	644a                	ld	s0,144(sp)
ffffffffc02022ee:	64aa                	ld	s1,136(sp)
ffffffffc02022f0:	690a                	ld	s2,128(sp)
ffffffffc02022f2:	79e6                	ld	s3,120(sp)
ffffffffc02022f4:	7a46                	ld	s4,112(sp)
ffffffffc02022f6:	7aa6                	ld	s5,104(sp)
ffffffffc02022f8:	7b06                	ld	s6,96(sp)
ffffffffc02022fa:	6be6                	ld	s7,88(sp)
ffffffffc02022fc:	610d                	addi	sp,sp,160
ffffffffc02022fe:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0202300:	000ab503          	ld	a0,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202304:	078a                	slli	a5,a5,0x2
ffffffffc0202306:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202308:	14a7f463          	bgeu	a5,a0,ffffffffc0202450 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc020230c:	9796                	add	a5,a5,t0
    return page - pages + nbase;
ffffffffc020230e:	00778bb3          	add	s7,a5,t2
    return &pages[PPN(pa) - nbase];
ffffffffc0202312:	00679593          	slli	a1,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202316:	00cb9693          	slli	a3,s7,0xc
    return KADDR(page2pa(page));
ffffffffc020231a:	10abf263          	bgeu	s7,a0,ffffffffc020241e <exit_range+0x25e>
ffffffffc020231e:	000fb783          	ld	a5,0(t6)
ffffffffc0202322:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202324:	01668533          	add	a0,a3,s6
                        if (pt[i] & PTE_V)
ffffffffc0202328:	629c                	ld	a5,0(a3)
ffffffffc020232a:	8b85                	andi	a5,a5,1
ffffffffc020232c:	f7ad                	bnez	a5,ffffffffc0202296 <exit_range+0xd6>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc020232e:	06a1                	addi	a3,a3,8
ffffffffc0202330:	fea69ce3          	bne	a3,a0,ffffffffc0202328 <exit_range+0x168>
    return &pages[PPN(pa) - nbase];
ffffffffc0202334:	000ca517          	auipc	a0,0xca
ffffffffc0202338:	f5c53503          	ld	a0,-164(a0) # ffffffffc02cc290 <pages>
ffffffffc020233c:	952e                	add	a0,a0,a1
ffffffffc020233e:	100027f3          	csrr	a5,sstatus
ffffffffc0202342:	8b89                	andi	a5,a5,2
ffffffffc0202344:	e3b9                	bnez	a5,ffffffffc020238a <exit_range+0x1ca>
        pmm_manager->free_pages(base, n);
ffffffffc0202346:	000ca797          	auipc	a5,0xca
ffffffffc020234a:	f227b783          	ld	a5,-222(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc020234e:	4585                	li	a1,1
ffffffffc0202350:	e0b2                	sd	a2,64(sp)
ffffffffc0202352:	739c                	ld	a5,32(a5)
ffffffffc0202354:	fc1a                	sd	t1,56(sp)
ffffffffc0202356:	f846                	sd	a7,48(sp)
ffffffffc0202358:	f47a                	sd	t5,40(sp)
ffffffffc020235a:	f072                	sd	t3,32(sp)
ffffffffc020235c:	ec76                	sd	t4,24(sp)
ffffffffc020235e:	e842                	sd	a6,16(sp)
ffffffffc0202360:	e43a                	sd	a4,8(sp)
ffffffffc0202362:	9782                	jalr	a5
    if (flag) {
ffffffffc0202364:	6722                	ld	a4,8(sp)
ffffffffc0202366:	6842                	ld	a6,16(sp)
ffffffffc0202368:	6ee2                	ld	t4,24(sp)
ffffffffc020236a:	7e02                	ld	t3,32(sp)
ffffffffc020236c:	7f22                	ld	t5,40(sp)
ffffffffc020236e:	78c2                	ld	a7,48(sp)
ffffffffc0202370:	7362                	ld	t1,56(sp)
ffffffffc0202372:	6606                	ld	a2,64(sp)
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202374:	fff802b7          	lui	t0,0xfff80
ffffffffc0202378:	000803b7          	lui	t2,0x80
ffffffffc020237c:	000caf97          	auipc	t6,0xca
ffffffffc0202380:	f04f8f93          	addi	t6,t6,-252 # ffffffffc02cc280 <va_pa_offset>
ffffffffc0202384:	00073023          	sd	zero,0(a4)
ffffffffc0202388:	b739                	j	ffffffffc0202296 <exit_range+0xd6>
        intr_disable();
ffffffffc020238a:	e4b2                	sd	a2,72(sp)
ffffffffc020238c:	e09a                	sd	t1,64(sp)
ffffffffc020238e:	fc46                	sd	a7,56(sp)
ffffffffc0202390:	f47a                	sd	t5,40(sp)
ffffffffc0202392:	f072                	sd	t3,32(sp)
ffffffffc0202394:	ec76                	sd	t4,24(sp)
ffffffffc0202396:	e842                	sd	a6,16(sp)
ffffffffc0202398:	e43a                	sd	a4,8(sp)
ffffffffc020239a:	f82a                	sd	a0,48(sp)
ffffffffc020239c:	d1efe0ef          	jal	ffffffffc02008ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02023a0:	000ca797          	auipc	a5,0xca
ffffffffc02023a4:	ec87b783          	ld	a5,-312(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc02023a8:	7542                	ld	a0,48(sp)
ffffffffc02023aa:	4585                	li	a1,1
ffffffffc02023ac:	739c                	ld	a5,32(a5)
ffffffffc02023ae:	9782                	jalr	a5
        intr_enable();
ffffffffc02023b0:	d04fe0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc02023b4:	6722                	ld	a4,8(sp)
ffffffffc02023b6:	6626                	ld	a2,72(sp)
ffffffffc02023b8:	6306                	ld	t1,64(sp)
ffffffffc02023ba:	78e2                	ld	a7,56(sp)
ffffffffc02023bc:	7f22                	ld	t5,40(sp)
ffffffffc02023be:	7e02                	ld	t3,32(sp)
ffffffffc02023c0:	6ee2                	ld	t4,24(sp)
ffffffffc02023c2:	6842                	ld	a6,16(sp)
ffffffffc02023c4:	000caf97          	auipc	t6,0xca
ffffffffc02023c8:	ebcf8f93          	addi	t6,t6,-324 # ffffffffc02cc280 <va_pa_offset>
ffffffffc02023cc:	000803b7          	lui	t2,0x80
ffffffffc02023d0:	fff802b7          	lui	t0,0xfff80
                        pd0[PDX0(d0start)] = 0;
ffffffffc02023d4:	00073023          	sd	zero,0(a4)
ffffffffc02023d8:	bd7d                	j	ffffffffc0202296 <exit_range+0xd6>
        intr_disable();
ffffffffc02023da:	e832                	sd	a2,16(sp)
ffffffffc02023dc:	e42a                	sd	a0,8(sp)
ffffffffc02023de:	cdcfe0ef          	jal	ffffffffc02008ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02023e2:	000ca797          	auipc	a5,0xca
ffffffffc02023e6:	e867b783          	ld	a5,-378(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc02023ea:	6522                	ld	a0,8(sp)
ffffffffc02023ec:	4585                	li	a1,1
ffffffffc02023ee:	739c                	ld	a5,32(a5)
ffffffffc02023f0:	9782                	jalr	a5
        intr_enable();
ffffffffc02023f2:	cc2fe0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc02023f6:	6642                	ld	a2,16(sp)
                pgdir[PDX1(d1start)] = 0;
ffffffffc02023f8:	00043023          	sd	zero,0(s0)
ffffffffc02023fc:	b5cd                	j	ffffffffc02022de <exit_range+0x11e>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02023fe:	00005697          	auipc	a3,0x5
ffffffffc0202402:	daa68693          	addi	a3,a3,-598 # ffffffffc02071a8 <etext+0xe64>
ffffffffc0202406:	00005617          	auipc	a2,0x5
ffffffffc020240a:	8f260613          	addi	a2,a2,-1806 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc020240e:	13600593          	li	a1,310
ffffffffc0202412:	00005517          	auipc	a0,0x5
ffffffffc0202416:	d8650513          	addi	a0,a0,-634 # ffffffffc0207198 <etext+0xe54>
ffffffffc020241a:	830fe0ef          	jal	ffffffffc020044a <__panic>
    return KADDR(page2pa(page));
ffffffffc020241e:	00005617          	auipc	a2,0x5
ffffffffc0202422:	c8a60613          	addi	a2,a2,-886 # ffffffffc02070a8 <etext+0xd64>
ffffffffc0202426:	07100593          	li	a1,113
ffffffffc020242a:	00005517          	auipc	a0,0x5
ffffffffc020242e:	ca650513          	addi	a0,a0,-858 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc0202432:	818fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202436:	86f2                	mv	a3,t3
ffffffffc0202438:	00005617          	auipc	a2,0x5
ffffffffc020243c:	c7060613          	addi	a2,a2,-912 # ffffffffc02070a8 <etext+0xd64>
ffffffffc0202440:	07100593          	li	a1,113
ffffffffc0202444:	00005517          	auipc	a0,0x5
ffffffffc0202448:	c8c50513          	addi	a0,a0,-884 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc020244c:	ffffd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202450:	8c7ff0ef          	jal	ffffffffc0201d16 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202454:	00005697          	auipc	a3,0x5
ffffffffc0202458:	d8468693          	addi	a3,a3,-636 # ffffffffc02071d8 <etext+0xe94>
ffffffffc020245c:	00005617          	auipc	a2,0x5
ffffffffc0202460:	89c60613          	addi	a2,a2,-1892 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202464:	13700593          	li	a1,311
ffffffffc0202468:	00005517          	auipc	a0,0x5
ffffffffc020246c:	d3050513          	addi	a0,a0,-720 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202470:	fdbfd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0202474 <page_remove>:
{
ffffffffc0202474:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202476:	4601                	li	a2,0
{
ffffffffc0202478:	e822                	sd	s0,16(sp)
ffffffffc020247a:	ec06                	sd	ra,24(sp)
ffffffffc020247c:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020247e:	95dff0ef          	jal	ffffffffc0201dda <get_pte>
    if (ptep != NULL)
ffffffffc0202482:	c511                	beqz	a0,ffffffffc020248e <page_remove+0x1a>
    if (*ptep & PTE_V)
ffffffffc0202484:	6118                	ld	a4,0(a0)
ffffffffc0202486:	87aa                	mv	a5,a0
ffffffffc0202488:	00177693          	andi	a3,a4,1
ffffffffc020248c:	e689                	bnez	a3,ffffffffc0202496 <page_remove+0x22>
}
ffffffffc020248e:	60e2                	ld	ra,24(sp)
ffffffffc0202490:	6442                	ld	s0,16(sp)
ffffffffc0202492:	6105                	addi	sp,sp,32
ffffffffc0202494:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0202496:	000ca697          	auipc	a3,0xca
ffffffffc020249a:	df26b683          	ld	a3,-526(a3) # ffffffffc02cc288 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc020249e:	070a                	slli	a4,a4,0x2
ffffffffc02024a0:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc02024a2:	06d77563          	bgeu	a4,a3,ffffffffc020250c <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc02024a6:	000ca517          	auipc	a0,0xca
ffffffffc02024aa:	dea53503          	ld	a0,-534(a0) # ffffffffc02cc290 <pages>
ffffffffc02024ae:	071a                	slli	a4,a4,0x6
ffffffffc02024b0:	fe0006b7          	lui	a3,0xfe000
ffffffffc02024b4:	9736                	add	a4,a4,a3
ffffffffc02024b6:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc02024b8:	4118                	lw	a4,0(a0)
ffffffffc02024ba:	377d                	addiw	a4,a4,-1
ffffffffc02024bc:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc02024be:	cb09                	beqz	a4,ffffffffc02024d0 <page_remove+0x5c>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc02024c0:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02024c4:	12040073          	sfence.vma	s0
}
ffffffffc02024c8:	60e2                	ld	ra,24(sp)
ffffffffc02024ca:	6442                	ld	s0,16(sp)
ffffffffc02024cc:	6105                	addi	sp,sp,32
ffffffffc02024ce:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02024d0:	10002773          	csrr	a4,sstatus
ffffffffc02024d4:	8b09                	andi	a4,a4,2
ffffffffc02024d6:	eb19                	bnez	a4,ffffffffc02024ec <page_remove+0x78>
        pmm_manager->free_pages(base, n);
ffffffffc02024d8:	000ca717          	auipc	a4,0xca
ffffffffc02024dc:	d9073703          	ld	a4,-624(a4) # ffffffffc02cc268 <pmm_manager>
ffffffffc02024e0:	4585                	li	a1,1
ffffffffc02024e2:	e03e                	sd	a5,0(sp)
ffffffffc02024e4:	7318                	ld	a4,32(a4)
ffffffffc02024e6:	9702                	jalr	a4
    if (flag) {
ffffffffc02024e8:	6782                	ld	a5,0(sp)
ffffffffc02024ea:	bfd9                	j	ffffffffc02024c0 <page_remove+0x4c>
        intr_disable();
ffffffffc02024ec:	e43e                	sd	a5,8(sp)
ffffffffc02024ee:	e02a                	sd	a0,0(sp)
ffffffffc02024f0:	bcafe0ef          	jal	ffffffffc02008ba <intr_disable>
ffffffffc02024f4:	000ca717          	auipc	a4,0xca
ffffffffc02024f8:	d7473703          	ld	a4,-652(a4) # ffffffffc02cc268 <pmm_manager>
ffffffffc02024fc:	6502                	ld	a0,0(sp)
ffffffffc02024fe:	4585                	li	a1,1
ffffffffc0202500:	7318                	ld	a4,32(a4)
ffffffffc0202502:	9702                	jalr	a4
        intr_enable();
ffffffffc0202504:	bb0fe0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0202508:	67a2                	ld	a5,8(sp)
ffffffffc020250a:	bf5d                	j	ffffffffc02024c0 <page_remove+0x4c>
ffffffffc020250c:	80bff0ef          	jal	ffffffffc0201d16 <pa2page.part.0>

ffffffffc0202510 <page_insert>:
{
ffffffffc0202510:	7139                	addi	sp,sp,-64
ffffffffc0202512:	f426                	sd	s1,40(sp)
ffffffffc0202514:	84b2                	mv	s1,a2
ffffffffc0202516:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202518:	4605                	li	a2,1
{
ffffffffc020251a:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020251c:	85a6                	mv	a1,s1
{
ffffffffc020251e:	fc06                	sd	ra,56(sp)
ffffffffc0202520:	e436                	sd	a3,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202522:	8b9ff0ef          	jal	ffffffffc0201dda <get_pte>
    if (ptep == NULL)
ffffffffc0202526:	cd61                	beqz	a0,ffffffffc02025fe <page_insert+0xee>
    page->ref += 1;
ffffffffc0202528:	400c                	lw	a1,0(s0)
    if (*ptep & PTE_V)
ffffffffc020252a:	611c                	ld	a5,0(a0)
ffffffffc020252c:	66a2                	ld	a3,8(sp)
ffffffffc020252e:	0015861b          	addiw	a2,a1,1 # 1001 <_binary_obj___user_softint_out_size-0x80df>
ffffffffc0202532:	c010                	sw	a2,0(s0)
ffffffffc0202534:	0017f613          	andi	a2,a5,1
ffffffffc0202538:	872a                	mv	a4,a0
ffffffffc020253a:	e61d                	bnez	a2,ffffffffc0202568 <page_insert+0x58>
    return &pages[PPN(pa) - nbase];
ffffffffc020253c:	000ca617          	auipc	a2,0xca
ffffffffc0202540:	d5463603          	ld	a2,-684(a2) # ffffffffc02cc290 <pages>
    return page - pages + nbase;
ffffffffc0202544:	8c11                	sub	s0,s0,a2
ffffffffc0202546:	8419                	srai	s0,s0,0x6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202548:	200007b7          	lui	a5,0x20000
ffffffffc020254c:	042a                	slli	s0,s0,0xa
ffffffffc020254e:	943e                	add	s0,s0,a5
ffffffffc0202550:	8ec1                	or	a3,a3,s0
ffffffffc0202552:	0016e693          	ori	a3,a3,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202556:	e314                	sd	a3,0(a4)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202558:	12048073          	sfence.vma	s1
    return 0;
ffffffffc020255c:	4501                	li	a0,0
}
ffffffffc020255e:	70e2                	ld	ra,56(sp)
ffffffffc0202560:	7442                	ld	s0,48(sp)
ffffffffc0202562:	74a2                	ld	s1,40(sp)
ffffffffc0202564:	6121                	addi	sp,sp,64
ffffffffc0202566:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0202568:	000ca617          	auipc	a2,0xca
ffffffffc020256c:	d2063603          	ld	a2,-736(a2) # ffffffffc02cc288 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0202570:	078a                	slli	a5,a5,0x2
ffffffffc0202572:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202574:	08c7f763          	bgeu	a5,a2,ffffffffc0202602 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0202578:	000ca617          	auipc	a2,0xca
ffffffffc020257c:	d1863603          	ld	a2,-744(a2) # ffffffffc02cc290 <pages>
ffffffffc0202580:	fe000537          	lui	a0,0xfe000
ffffffffc0202584:	079a                	slli	a5,a5,0x6
ffffffffc0202586:	97aa                	add	a5,a5,a0
ffffffffc0202588:	00f60533          	add	a0,a2,a5
        if (p == page)
ffffffffc020258c:	00a40963          	beq	s0,a0,ffffffffc020259e <page_insert+0x8e>
    page->ref -= 1;
ffffffffc0202590:	411c                	lw	a5,0(a0)
ffffffffc0202592:	37fd                	addiw	a5,a5,-1 # 1fffffff <_binary_obj___user_matrix_out_size+0x1fff4917>
ffffffffc0202594:	c11c                	sw	a5,0(a0)
        if (page_ref(page) ==
ffffffffc0202596:	c791                	beqz	a5,ffffffffc02025a2 <page_insert+0x92>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202598:	12048073          	sfence.vma	s1
}
ffffffffc020259c:	b765                	j	ffffffffc0202544 <page_insert+0x34>
ffffffffc020259e:	c00c                	sw	a1,0(s0)
    return page->ref;
ffffffffc02025a0:	b755                	j	ffffffffc0202544 <page_insert+0x34>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02025a2:	100027f3          	csrr	a5,sstatus
ffffffffc02025a6:	8b89                	andi	a5,a5,2
ffffffffc02025a8:	e39d                	bnez	a5,ffffffffc02025ce <page_insert+0xbe>
        pmm_manager->free_pages(base, n);
ffffffffc02025aa:	000ca797          	auipc	a5,0xca
ffffffffc02025ae:	cbe7b783          	ld	a5,-834(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc02025b2:	4585                	li	a1,1
ffffffffc02025b4:	e83a                	sd	a4,16(sp)
ffffffffc02025b6:	739c                	ld	a5,32(a5)
ffffffffc02025b8:	e436                	sd	a3,8(sp)
ffffffffc02025ba:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc02025bc:	000ca617          	auipc	a2,0xca
ffffffffc02025c0:	cd463603          	ld	a2,-812(a2) # ffffffffc02cc290 <pages>
ffffffffc02025c4:	66a2                	ld	a3,8(sp)
ffffffffc02025c6:	6742                	ld	a4,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02025c8:	12048073          	sfence.vma	s1
ffffffffc02025cc:	bfa5                	j	ffffffffc0202544 <page_insert+0x34>
        intr_disable();
ffffffffc02025ce:	ec3a                	sd	a4,24(sp)
ffffffffc02025d0:	e836                	sd	a3,16(sp)
ffffffffc02025d2:	e42a                	sd	a0,8(sp)
ffffffffc02025d4:	ae6fe0ef          	jal	ffffffffc02008ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02025d8:	000ca797          	auipc	a5,0xca
ffffffffc02025dc:	c907b783          	ld	a5,-880(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc02025e0:	6522                	ld	a0,8(sp)
ffffffffc02025e2:	4585                	li	a1,1
ffffffffc02025e4:	739c                	ld	a5,32(a5)
ffffffffc02025e6:	9782                	jalr	a5
        intr_enable();
ffffffffc02025e8:	accfe0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc02025ec:	000ca617          	auipc	a2,0xca
ffffffffc02025f0:	ca463603          	ld	a2,-860(a2) # ffffffffc02cc290 <pages>
ffffffffc02025f4:	6762                	ld	a4,24(sp)
ffffffffc02025f6:	66c2                	ld	a3,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02025f8:	12048073          	sfence.vma	s1
ffffffffc02025fc:	b7a1                	j	ffffffffc0202544 <page_insert+0x34>
        return -E_NO_MEM;
ffffffffc02025fe:	5571                	li	a0,-4
ffffffffc0202600:	bfb9                	j	ffffffffc020255e <page_insert+0x4e>
ffffffffc0202602:	f14ff0ef          	jal	ffffffffc0201d16 <pa2page.part.0>

ffffffffc0202606 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202606:	00006797          	auipc	a5,0x6
ffffffffc020260a:	03a78793          	addi	a5,a5,58 # ffffffffc0208640 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020260e:	638c                	ld	a1,0(a5)
{
ffffffffc0202610:	7159                	addi	sp,sp,-112
ffffffffc0202612:	f486                	sd	ra,104(sp)
ffffffffc0202614:	e8ca                	sd	s2,80(sp)
ffffffffc0202616:	e4ce                	sd	s3,72(sp)
ffffffffc0202618:	f85a                	sd	s6,48(sp)
ffffffffc020261a:	f0a2                	sd	s0,96(sp)
ffffffffc020261c:	eca6                	sd	s1,88(sp)
ffffffffc020261e:	e0d2                	sd	s4,64(sp)
ffffffffc0202620:	fc56                	sd	s5,56(sp)
ffffffffc0202622:	f45e                	sd	s7,40(sp)
ffffffffc0202624:	f062                	sd	s8,32(sp)
ffffffffc0202626:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202628:	000cab17          	auipc	s6,0xca
ffffffffc020262c:	c40b0b13          	addi	s6,s6,-960 # ffffffffc02cc268 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202630:	00005517          	auipc	a0,0x5
ffffffffc0202634:	bc050513          	addi	a0,a0,-1088 # ffffffffc02071f0 <etext+0xeac>
    pmm_manager = &default_pmm_manager;
ffffffffc0202638:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020263c:	b5dfd0ef          	jal	ffffffffc0200198 <cprintf>
    pmm_manager->init();
ffffffffc0202640:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202644:	000ca997          	auipc	s3,0xca
ffffffffc0202648:	c3c98993          	addi	s3,s3,-964 # ffffffffc02cc280 <va_pa_offset>
    pmm_manager->init();
ffffffffc020264c:	679c                	ld	a5,8(a5)
ffffffffc020264e:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202650:	57f5                	li	a5,-3
ffffffffc0202652:	07fa                	slli	a5,a5,0x1e
ffffffffc0202654:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202658:	a48fe0ef          	jal	ffffffffc02008a0 <get_memory_base>
ffffffffc020265c:	892a                	mv	s2,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc020265e:	a4cfe0ef          	jal	ffffffffc02008aa <get_memory_size>
    if (mem_size == 0) {
ffffffffc0202662:	70050e63          	beqz	a0,ffffffffc0202d7e <pmm_init+0x778>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0202666:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202668:	00005517          	auipc	a0,0x5
ffffffffc020266c:	bc050513          	addi	a0,a0,-1088 # ffffffffc0207228 <etext+0xee4>
ffffffffc0202670:	b29fd0ef          	jal	ffffffffc0200198 <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0202674:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202678:	864a                	mv	a2,s2
ffffffffc020267a:	85a6                	mv	a1,s1
ffffffffc020267c:	fff40693          	addi	a3,s0,-1
ffffffffc0202680:	00005517          	auipc	a0,0x5
ffffffffc0202684:	bc050513          	addi	a0,a0,-1088 # ffffffffc0207240 <etext+0xefc>
ffffffffc0202688:	b11fd0ef          	jal	ffffffffc0200198 <cprintf>
    if (maxpa > KERNTOP)
ffffffffc020268c:	c80007b7          	lui	a5,0xc8000
ffffffffc0202690:	8522                	mv	a0,s0
ffffffffc0202692:	5287ed63          	bltu	a5,s0,ffffffffc0202bcc <pmm_init+0x5c6>
ffffffffc0202696:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202698:	000cb617          	auipc	a2,0xcb
ffffffffc020269c:	c2f60613          	addi	a2,a2,-977 # ffffffffc02cd2c7 <end+0xfff>
ffffffffc02026a0:	8e7d                	and	a2,a2,a5
    npage = maxpa / PGSIZE;
ffffffffc02026a2:	8131                	srli	a0,a0,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02026a4:	000cab97          	auipc	s7,0xca
ffffffffc02026a8:	becb8b93          	addi	s7,s7,-1044 # ffffffffc02cc290 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02026ac:	000ca497          	auipc	s1,0xca
ffffffffc02026b0:	bdc48493          	addi	s1,s1,-1060 # ffffffffc02cc288 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02026b4:	00cbb023          	sd	a2,0(s7)
    npage = maxpa / PGSIZE;
ffffffffc02026b8:	e088                	sd	a0,0(s1)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02026ba:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02026be:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02026c0:	02f50763          	beq	a0,a5,ffffffffc02026ee <pmm_init+0xe8>
ffffffffc02026c4:	4701                	li	a4,0
ffffffffc02026c6:	4585                	li	a1,1
ffffffffc02026c8:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc02026cc:	00671793          	slli	a5,a4,0x6
ffffffffc02026d0:	97b2                	add	a5,a5,a2
ffffffffc02026d2:	07a1                	addi	a5,a5,8 # 80008 <_binary_obj___user_matrix_out_size+0x74920>
ffffffffc02026d4:	40b7b02f          	amoor.d	zero,a1,(a5)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02026d8:	6088                	ld	a0,0(s1)
ffffffffc02026da:	0705                	addi	a4,a4,1
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02026dc:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02026e0:	00d507b3          	add	a5,a0,a3
ffffffffc02026e4:	fef764e3          	bltu	a4,a5,ffffffffc02026cc <pmm_init+0xc6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02026e8:	079a                	slli	a5,a5,0x6
ffffffffc02026ea:	00f606b3          	add	a3,a2,a5
ffffffffc02026ee:	c02007b7          	lui	a5,0xc0200
ffffffffc02026f2:	16f6eee3          	bltu	a3,a5,ffffffffc020306e <pmm_init+0xa68>
ffffffffc02026f6:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc02026fa:	77fd                	lui	a5,0xfffff
ffffffffc02026fc:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02026fe:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202700:	4e86ed63          	bltu	a3,s0,ffffffffc0202bfa <pmm_init+0x5f4>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202704:	00005517          	auipc	a0,0x5
ffffffffc0202708:	b6450513          	addi	a0,a0,-1180 # ffffffffc0207268 <etext+0xf24>
ffffffffc020270c:	a8dfd0ef          	jal	ffffffffc0200198 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202710:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202714:	000ca917          	auipc	s2,0xca
ffffffffc0202718:	b6490913          	addi	s2,s2,-1180 # ffffffffc02cc278 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc020271c:	7b9c                	ld	a5,48(a5)
ffffffffc020271e:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202720:	00005517          	auipc	a0,0x5
ffffffffc0202724:	b6050513          	addi	a0,a0,-1184 # ffffffffc0207280 <etext+0xf3c>
ffffffffc0202728:	a71fd0ef          	jal	ffffffffc0200198 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc020272c:	0000a697          	auipc	a3,0xa
ffffffffc0202730:	8d468693          	addi	a3,a3,-1836 # ffffffffc020c000 <boot_page_table_sv39>
ffffffffc0202734:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202738:	c02007b7          	lui	a5,0xc0200
ffffffffc020273c:	2af6eee3          	bltu	a3,a5,ffffffffc02031f8 <pmm_init+0xbf2>
ffffffffc0202740:	0009b783          	ld	a5,0(s3)
ffffffffc0202744:	8e9d                	sub	a3,a3,a5
ffffffffc0202746:	000ca797          	auipc	a5,0xca
ffffffffc020274a:	b2d7b523          	sd	a3,-1238(a5) # ffffffffc02cc270 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020274e:	100027f3          	csrr	a5,sstatus
ffffffffc0202752:	8b89                	andi	a5,a5,2
ffffffffc0202754:	48079963          	bnez	a5,ffffffffc0202be6 <pmm_init+0x5e0>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202758:	000b3783          	ld	a5,0(s6)
ffffffffc020275c:	779c                	ld	a5,40(a5)
ffffffffc020275e:	9782                	jalr	a5
ffffffffc0202760:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202762:	6098                	ld	a4,0(s1)
ffffffffc0202764:	c80007b7          	lui	a5,0xc8000
ffffffffc0202768:	83b1                	srli	a5,a5,0xc
ffffffffc020276a:	66e7e663          	bltu	a5,a4,ffffffffc0202dd6 <pmm_init+0x7d0>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc020276e:	00093503          	ld	a0,0(s2)
ffffffffc0202772:	64050263          	beqz	a0,ffffffffc0202db6 <pmm_init+0x7b0>
ffffffffc0202776:	03451793          	slli	a5,a0,0x34
ffffffffc020277a:	62079e63          	bnez	a5,ffffffffc0202db6 <pmm_init+0x7b0>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc020277e:	4601                	li	a2,0
ffffffffc0202780:	4581                	li	a1,0
ffffffffc0202782:	8b7ff0ef          	jal	ffffffffc0202038 <get_page>
ffffffffc0202786:	240519e3          	bnez	a0,ffffffffc02031d8 <pmm_init+0xbd2>
ffffffffc020278a:	100027f3          	csrr	a5,sstatus
ffffffffc020278e:	8b89                	andi	a5,a5,2
ffffffffc0202790:	44079063          	bnez	a5,ffffffffc0202bd0 <pmm_init+0x5ca>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202794:	000b3783          	ld	a5,0(s6)
ffffffffc0202798:	4505                	li	a0,1
ffffffffc020279a:	6f9c                	ld	a5,24(a5)
ffffffffc020279c:	9782                	jalr	a5
ffffffffc020279e:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02027a0:	00093503          	ld	a0,0(s2)
ffffffffc02027a4:	4681                	li	a3,0
ffffffffc02027a6:	4601                	li	a2,0
ffffffffc02027a8:	85d2                	mv	a1,s4
ffffffffc02027aa:	d67ff0ef          	jal	ffffffffc0202510 <page_insert>
ffffffffc02027ae:	280511e3          	bnez	a0,ffffffffc0203230 <pmm_init+0xc2a>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02027b2:	00093503          	ld	a0,0(s2)
ffffffffc02027b6:	4601                	li	a2,0
ffffffffc02027b8:	4581                	li	a1,0
ffffffffc02027ba:	e20ff0ef          	jal	ffffffffc0201dda <get_pte>
ffffffffc02027be:	240509e3          	beqz	a0,ffffffffc0203210 <pmm_init+0xc0a>
    assert(pte2page(*ptep) == p1);
ffffffffc02027c2:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc02027c4:	0017f713          	andi	a4,a5,1
ffffffffc02027c8:	58070f63          	beqz	a4,ffffffffc0202d66 <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc02027cc:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02027ce:	078a                	slli	a5,a5,0x2
ffffffffc02027d0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02027d2:	58e7f863          	bgeu	a5,a4,ffffffffc0202d62 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc02027d6:	000bb683          	ld	a3,0(s7)
ffffffffc02027da:	079a                	slli	a5,a5,0x6
ffffffffc02027dc:	fe000637          	lui	a2,0xfe000
ffffffffc02027e0:	97b2                	add	a5,a5,a2
ffffffffc02027e2:	97b6                	add	a5,a5,a3
ffffffffc02027e4:	14fa1ae3          	bne	s4,a5,ffffffffc0203138 <pmm_init+0xb32>
    assert(page_ref(p1) == 1);
ffffffffc02027e8:	000a2683          	lw	a3,0(s4) # 200000 <_binary_obj___user_matrix_out_size+0x1f4918>
ffffffffc02027ec:	4785                	li	a5,1
ffffffffc02027ee:	12f695e3          	bne	a3,a5,ffffffffc0203118 <pmm_init+0xb12>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc02027f2:	00093503          	ld	a0,0(s2)
ffffffffc02027f6:	77fd                	lui	a5,0xfffff
ffffffffc02027f8:	6114                	ld	a3,0(a0)
ffffffffc02027fa:	068a                	slli	a3,a3,0x2
ffffffffc02027fc:	8efd                	and	a3,a3,a5
ffffffffc02027fe:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202802:	0ee67fe3          	bgeu	a2,a4,ffffffffc0203100 <pmm_init+0xafa>
ffffffffc0202806:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020280a:	96e2                	add	a3,a3,s8
ffffffffc020280c:	0006ba83          	ld	s5,0(a3)
ffffffffc0202810:	0a8a                	slli	s5,s5,0x2
ffffffffc0202812:	00fafab3          	and	s5,s5,a5
ffffffffc0202816:	00cad793          	srli	a5,s5,0xc
ffffffffc020281a:	0ce7f6e3          	bgeu	a5,a4,ffffffffc02030e6 <pmm_init+0xae0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020281e:	4601                	li	a2,0
ffffffffc0202820:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202822:	9c56                	add	s8,s8,s5
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202824:	db6ff0ef          	jal	ffffffffc0201dda <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202828:	0c21                	addi	s8,s8,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020282a:	05851ee3          	bne	a0,s8,ffffffffc0203086 <pmm_init+0xa80>
ffffffffc020282e:	100027f3          	csrr	a5,sstatus
ffffffffc0202832:	8b89                	andi	a5,a5,2
ffffffffc0202834:	3e079b63          	bnez	a5,ffffffffc0202c2a <pmm_init+0x624>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202838:	000b3783          	ld	a5,0(s6)
ffffffffc020283c:	4505                	li	a0,1
ffffffffc020283e:	6f9c                	ld	a5,24(a5)
ffffffffc0202840:	9782                	jalr	a5
ffffffffc0202842:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202844:	00093503          	ld	a0,0(s2)
ffffffffc0202848:	46d1                	li	a3,20
ffffffffc020284a:	6605                	lui	a2,0x1
ffffffffc020284c:	85e2                	mv	a1,s8
ffffffffc020284e:	cc3ff0ef          	jal	ffffffffc0202510 <page_insert>
ffffffffc0202852:	06051ae3          	bnez	a0,ffffffffc02030c6 <pmm_init+0xac0>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202856:	00093503          	ld	a0,0(s2)
ffffffffc020285a:	4601                	li	a2,0
ffffffffc020285c:	6585                	lui	a1,0x1
ffffffffc020285e:	d7cff0ef          	jal	ffffffffc0201dda <get_pte>
ffffffffc0202862:	040502e3          	beqz	a0,ffffffffc02030a6 <pmm_init+0xaa0>
    assert(*ptep & PTE_U);
ffffffffc0202866:	611c                	ld	a5,0(a0)
ffffffffc0202868:	0107f713          	andi	a4,a5,16
ffffffffc020286c:	7e070163          	beqz	a4,ffffffffc020304e <pmm_init+0xa48>
    assert(*ptep & PTE_W);
ffffffffc0202870:	8b91                	andi	a5,a5,4
ffffffffc0202872:	7a078e63          	beqz	a5,ffffffffc020302e <pmm_init+0xa28>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202876:	00093503          	ld	a0,0(s2)
ffffffffc020287a:	611c                	ld	a5,0(a0)
ffffffffc020287c:	8bc1                	andi	a5,a5,16
ffffffffc020287e:	78078863          	beqz	a5,ffffffffc020300e <pmm_init+0xa08>
    assert(page_ref(p2) == 1);
ffffffffc0202882:	000c2703          	lw	a4,0(s8)
ffffffffc0202886:	4785                	li	a5,1
ffffffffc0202888:	76f71363          	bne	a4,a5,ffffffffc0202fee <pmm_init+0x9e8>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc020288c:	4681                	li	a3,0
ffffffffc020288e:	6605                	lui	a2,0x1
ffffffffc0202890:	85d2                	mv	a1,s4
ffffffffc0202892:	c7fff0ef          	jal	ffffffffc0202510 <page_insert>
ffffffffc0202896:	72051c63          	bnez	a0,ffffffffc0202fce <pmm_init+0x9c8>
    assert(page_ref(p1) == 2);
ffffffffc020289a:	000a2703          	lw	a4,0(s4)
ffffffffc020289e:	4789                	li	a5,2
ffffffffc02028a0:	70f71763          	bne	a4,a5,ffffffffc0202fae <pmm_init+0x9a8>
    assert(page_ref(p2) == 0);
ffffffffc02028a4:	000c2783          	lw	a5,0(s8)
ffffffffc02028a8:	6e079363          	bnez	a5,ffffffffc0202f8e <pmm_init+0x988>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02028ac:	00093503          	ld	a0,0(s2)
ffffffffc02028b0:	4601                	li	a2,0
ffffffffc02028b2:	6585                	lui	a1,0x1
ffffffffc02028b4:	d26ff0ef          	jal	ffffffffc0201dda <get_pte>
ffffffffc02028b8:	6a050b63          	beqz	a0,ffffffffc0202f6e <pmm_init+0x968>
    assert(pte2page(*ptep) == p1);
ffffffffc02028bc:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc02028be:	00177793          	andi	a5,a4,1
ffffffffc02028c2:	4a078263          	beqz	a5,ffffffffc0202d66 <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc02028c6:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02028c8:	00271793          	slli	a5,a4,0x2
ffffffffc02028cc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02028ce:	48d7fa63          	bgeu	a5,a3,ffffffffc0202d62 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc02028d2:	000bb683          	ld	a3,0(s7)
ffffffffc02028d6:	fff80ab7          	lui	s5,0xfff80
ffffffffc02028da:	97d6                	add	a5,a5,s5
ffffffffc02028dc:	079a                	slli	a5,a5,0x6
ffffffffc02028de:	97b6                	add	a5,a5,a3
ffffffffc02028e0:	66fa1763          	bne	s4,a5,ffffffffc0202f4e <pmm_init+0x948>
    assert((*ptep & PTE_U) == 0);
ffffffffc02028e4:	8b41                	andi	a4,a4,16
ffffffffc02028e6:	64071463          	bnez	a4,ffffffffc0202f2e <pmm_init+0x928>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc02028ea:	00093503          	ld	a0,0(s2)
ffffffffc02028ee:	4581                	li	a1,0
ffffffffc02028f0:	b85ff0ef          	jal	ffffffffc0202474 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc02028f4:	000a2c83          	lw	s9,0(s4)
ffffffffc02028f8:	4785                	li	a5,1
ffffffffc02028fa:	60fc9a63          	bne	s9,a5,ffffffffc0202f0e <pmm_init+0x908>
    assert(page_ref(p2) == 0);
ffffffffc02028fe:	000c2783          	lw	a5,0(s8)
ffffffffc0202902:	5e079663          	bnez	a5,ffffffffc0202eee <pmm_init+0x8e8>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202906:	00093503          	ld	a0,0(s2)
ffffffffc020290a:	6585                	lui	a1,0x1
ffffffffc020290c:	b69ff0ef          	jal	ffffffffc0202474 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202910:	000a2783          	lw	a5,0(s4)
ffffffffc0202914:	52079d63          	bnez	a5,ffffffffc0202e4e <pmm_init+0x848>
    assert(page_ref(p2) == 0);
ffffffffc0202918:	000c2783          	lw	a5,0(s8)
ffffffffc020291c:	50079963          	bnez	a5,ffffffffc0202e2e <pmm_init+0x828>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202920:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202924:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202926:	000a3783          	ld	a5,0(s4)
ffffffffc020292a:	078a                	slli	a5,a5,0x2
ffffffffc020292c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020292e:	42e7fa63          	bgeu	a5,a4,ffffffffc0202d62 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202932:	000bb503          	ld	a0,0(s7)
ffffffffc0202936:	97d6                	add	a5,a5,s5
ffffffffc0202938:	079a                	slli	a5,a5,0x6
    return page->ref;
ffffffffc020293a:	00f506b3          	add	a3,a0,a5
ffffffffc020293e:	4294                	lw	a3,0(a3)
ffffffffc0202940:	4d969763          	bne	a3,s9,ffffffffc0202e0e <pmm_init+0x808>
    return page - pages + nbase;
ffffffffc0202944:	8799                	srai	a5,a5,0x6
ffffffffc0202946:	00080637          	lui	a2,0x80
ffffffffc020294a:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020294c:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202950:	4ae7f363          	bgeu	a5,a4,ffffffffc0202df6 <pmm_init+0x7f0>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202954:	0009b783          	ld	a5,0(s3)
ffffffffc0202958:	97b6                	add	a5,a5,a3
    return pa2page(PDE_ADDR(pde));
ffffffffc020295a:	639c                	ld	a5,0(a5)
ffffffffc020295c:	078a                	slli	a5,a5,0x2
ffffffffc020295e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202960:	40e7f163          	bgeu	a5,a4,ffffffffc0202d62 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202964:	8f91                	sub	a5,a5,a2
ffffffffc0202966:	079a                	slli	a5,a5,0x6
ffffffffc0202968:	953e                	add	a0,a0,a5
ffffffffc020296a:	100027f3          	csrr	a5,sstatus
ffffffffc020296e:	8b89                	andi	a5,a5,2
ffffffffc0202970:	30079863          	bnez	a5,ffffffffc0202c80 <pmm_init+0x67a>
        pmm_manager->free_pages(base, n);
ffffffffc0202974:	000b3783          	ld	a5,0(s6)
ffffffffc0202978:	4585                	li	a1,1
ffffffffc020297a:	739c                	ld	a5,32(a5)
ffffffffc020297c:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020297e:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202982:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202984:	078a                	slli	a5,a5,0x2
ffffffffc0202986:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202988:	3ce7fd63          	bgeu	a5,a4,ffffffffc0202d62 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc020298c:	000bb503          	ld	a0,0(s7)
ffffffffc0202990:	fe000737          	lui	a4,0xfe000
ffffffffc0202994:	079a                	slli	a5,a5,0x6
ffffffffc0202996:	97ba                	add	a5,a5,a4
ffffffffc0202998:	953e                	add	a0,a0,a5
ffffffffc020299a:	100027f3          	csrr	a5,sstatus
ffffffffc020299e:	8b89                	andi	a5,a5,2
ffffffffc02029a0:	2c079463          	bnez	a5,ffffffffc0202c68 <pmm_init+0x662>
ffffffffc02029a4:	000b3783          	ld	a5,0(s6)
ffffffffc02029a8:	4585                	li	a1,1
ffffffffc02029aa:	739c                	ld	a5,32(a5)
ffffffffc02029ac:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc02029ae:	00093783          	ld	a5,0(s2)
ffffffffc02029b2:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd32d38>
    asm volatile("sfence.vma");
ffffffffc02029b6:	12000073          	sfence.vma
ffffffffc02029ba:	100027f3          	csrr	a5,sstatus
ffffffffc02029be:	8b89                	andi	a5,a5,2
ffffffffc02029c0:	28079a63          	bnez	a5,ffffffffc0202c54 <pmm_init+0x64e>
        ret = pmm_manager->nr_free_pages();
ffffffffc02029c4:	000b3783          	ld	a5,0(s6)
ffffffffc02029c8:	779c                	ld	a5,40(a5)
ffffffffc02029ca:	9782                	jalr	a5
ffffffffc02029cc:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc02029ce:	4d441063          	bne	s0,s4,ffffffffc0202e8e <pmm_init+0x888>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc02029d2:	00005517          	auipc	a0,0x5
ffffffffc02029d6:	bfe50513          	addi	a0,a0,-1026 # ffffffffc02075d0 <etext+0x128c>
ffffffffc02029da:	fbefd0ef          	jal	ffffffffc0200198 <cprintf>
ffffffffc02029de:	100027f3          	csrr	a5,sstatus
ffffffffc02029e2:	8b89                	andi	a5,a5,2
ffffffffc02029e4:	24079e63          	bnez	a5,ffffffffc0202c40 <pmm_init+0x63a>
        ret = pmm_manager->nr_free_pages();
ffffffffc02029e8:	000b3783          	ld	a5,0(s6)
ffffffffc02029ec:	779c                	ld	a5,40(a5)
ffffffffc02029ee:	9782                	jalr	a5
ffffffffc02029f0:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc02029f2:	609c                	ld	a5,0(s1)
ffffffffc02029f4:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02029f8:	7a7d                	lui	s4,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc02029fa:	00c79713          	slli	a4,a5,0xc
ffffffffc02029fe:	6a85                	lui	s5,0x1
ffffffffc0202a00:	02e47c63          	bgeu	s0,a4,ffffffffc0202a38 <pmm_init+0x432>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202a04:	00c45713          	srli	a4,s0,0xc
ffffffffc0202a08:	30f77063          	bgeu	a4,a5,ffffffffc0202d08 <pmm_init+0x702>
ffffffffc0202a0c:	0009b583          	ld	a1,0(s3)
ffffffffc0202a10:	00093503          	ld	a0,0(s2)
ffffffffc0202a14:	4601                	li	a2,0
ffffffffc0202a16:	95a2                	add	a1,a1,s0
ffffffffc0202a18:	bc2ff0ef          	jal	ffffffffc0201dda <get_pte>
ffffffffc0202a1c:	32050363          	beqz	a0,ffffffffc0202d42 <pmm_init+0x73c>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202a20:	611c                	ld	a5,0(a0)
ffffffffc0202a22:	078a                	slli	a5,a5,0x2
ffffffffc0202a24:	0147f7b3          	and	a5,a5,s4
ffffffffc0202a28:	2e879d63          	bne	a5,s0,ffffffffc0202d22 <pmm_init+0x71c>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202a2c:	609c                	ld	a5,0(s1)
ffffffffc0202a2e:	9456                	add	s0,s0,s5
ffffffffc0202a30:	00c79713          	slli	a4,a5,0xc
ffffffffc0202a34:	fce468e3          	bltu	s0,a4,ffffffffc0202a04 <pmm_init+0x3fe>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202a38:	00093783          	ld	a5,0(s2)
ffffffffc0202a3c:	639c                	ld	a5,0(a5)
ffffffffc0202a3e:	42079863          	bnez	a5,ffffffffc0202e6e <pmm_init+0x868>
ffffffffc0202a42:	100027f3          	csrr	a5,sstatus
ffffffffc0202a46:	8b89                	andi	a5,a5,2
ffffffffc0202a48:	24079863          	bnez	a5,ffffffffc0202c98 <pmm_init+0x692>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202a4c:	000b3783          	ld	a5,0(s6)
ffffffffc0202a50:	4505                	li	a0,1
ffffffffc0202a52:	6f9c                	ld	a5,24(a5)
ffffffffc0202a54:	9782                	jalr	a5
ffffffffc0202a56:	842a                	mv	s0,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202a58:	00093503          	ld	a0,0(s2)
ffffffffc0202a5c:	4699                	li	a3,6
ffffffffc0202a5e:	10000613          	li	a2,256
ffffffffc0202a62:	85a2                	mv	a1,s0
ffffffffc0202a64:	aadff0ef          	jal	ffffffffc0202510 <page_insert>
ffffffffc0202a68:	46051363          	bnez	a0,ffffffffc0202ece <pmm_init+0x8c8>
    assert(page_ref(p) == 1);
ffffffffc0202a6c:	4018                	lw	a4,0(s0)
ffffffffc0202a6e:	4785                	li	a5,1
ffffffffc0202a70:	42f71f63          	bne	a4,a5,ffffffffc0202eae <pmm_init+0x8a8>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202a74:	00093503          	ld	a0,0(s2)
ffffffffc0202a78:	6605                	lui	a2,0x1
ffffffffc0202a7a:	10060613          	addi	a2,a2,256 # 1100 <_binary_obj___user_softint_out_size-0x7fe0>
ffffffffc0202a7e:	4699                	li	a3,6
ffffffffc0202a80:	85a2                	mv	a1,s0
ffffffffc0202a82:	a8fff0ef          	jal	ffffffffc0202510 <page_insert>
ffffffffc0202a86:	72051963          	bnez	a0,ffffffffc02031b8 <pmm_init+0xbb2>
    assert(page_ref(p) == 2);
ffffffffc0202a8a:	4018                	lw	a4,0(s0)
ffffffffc0202a8c:	4789                	li	a5,2
ffffffffc0202a8e:	70f71563          	bne	a4,a5,ffffffffc0203198 <pmm_init+0xb92>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202a92:	00005597          	auipc	a1,0x5
ffffffffc0202a96:	c8658593          	addi	a1,a1,-890 # ffffffffc0207718 <etext+0x13d4>
ffffffffc0202a9a:	10000513          	li	a0,256
ffffffffc0202a9e:	7fc030ef          	jal	ffffffffc020629a <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202aa2:	6585                	lui	a1,0x1
ffffffffc0202aa4:	10058593          	addi	a1,a1,256 # 1100 <_binary_obj___user_softint_out_size-0x7fe0>
ffffffffc0202aa8:	10000513          	li	a0,256
ffffffffc0202aac:	001030ef          	jal	ffffffffc02062ac <strcmp>
ffffffffc0202ab0:	6c051463          	bnez	a0,ffffffffc0203178 <pmm_init+0xb72>
    return page - pages + nbase;
ffffffffc0202ab4:	000bb683          	ld	a3,0(s7)
ffffffffc0202ab8:	000807b7          	lui	a5,0x80
    return KADDR(page2pa(page));
ffffffffc0202abc:	6098                	ld	a4,0(s1)
    return page - pages + nbase;
ffffffffc0202abe:	40d406b3          	sub	a3,s0,a3
ffffffffc0202ac2:	8699                	srai	a3,a3,0x6
ffffffffc0202ac4:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0202ac6:	00c69793          	slli	a5,a3,0xc
ffffffffc0202aca:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202acc:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202ace:	32e7f463          	bgeu	a5,a4,ffffffffc0202df6 <pmm_init+0x7f0>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202ad2:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202ad6:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202ada:	97b6                	add	a5,a5,a3
ffffffffc0202adc:	10078023          	sb	zero,256(a5) # 80100 <_binary_obj___user_matrix_out_size+0x74a18>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202ae0:	786030ef          	jal	ffffffffc0206266 <strlen>
ffffffffc0202ae4:	66051a63          	bnez	a0,ffffffffc0203158 <pmm_init+0xb52>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202ae8:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202aec:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202aee:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fd32d38>
ffffffffc0202af2:	078a                	slli	a5,a5,0x2
ffffffffc0202af4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202af6:	26e7f663          	bgeu	a5,a4,ffffffffc0202d62 <pmm_init+0x75c>
    return page2ppn(page) << PGSHIFT;
ffffffffc0202afa:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202afe:	2ee7fc63          	bgeu	a5,a4,ffffffffc0202df6 <pmm_init+0x7f0>
ffffffffc0202b02:	0009b783          	ld	a5,0(s3)
ffffffffc0202b06:	00f689b3          	add	s3,a3,a5
ffffffffc0202b0a:	100027f3          	csrr	a5,sstatus
ffffffffc0202b0e:	8b89                	andi	a5,a5,2
ffffffffc0202b10:	1e079163          	bnez	a5,ffffffffc0202cf2 <pmm_init+0x6ec>
        pmm_manager->free_pages(base, n);
ffffffffc0202b14:	000b3783          	ld	a5,0(s6)
ffffffffc0202b18:	8522                	mv	a0,s0
ffffffffc0202b1a:	4585                	li	a1,1
ffffffffc0202b1c:	739c                	ld	a5,32(a5)
ffffffffc0202b1e:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b20:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage)
ffffffffc0202b24:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b26:	078a                	slli	a5,a5,0x2
ffffffffc0202b28:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b2a:	22e7fc63          	bgeu	a5,a4,ffffffffc0202d62 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b2e:	000bb503          	ld	a0,0(s7)
ffffffffc0202b32:	fe000737          	lui	a4,0xfe000
ffffffffc0202b36:	079a                	slli	a5,a5,0x6
ffffffffc0202b38:	97ba                	add	a5,a5,a4
ffffffffc0202b3a:	953e                	add	a0,a0,a5
ffffffffc0202b3c:	100027f3          	csrr	a5,sstatus
ffffffffc0202b40:	8b89                	andi	a5,a5,2
ffffffffc0202b42:	18079c63          	bnez	a5,ffffffffc0202cda <pmm_init+0x6d4>
ffffffffc0202b46:	000b3783          	ld	a5,0(s6)
ffffffffc0202b4a:	4585                	li	a1,1
ffffffffc0202b4c:	739c                	ld	a5,32(a5)
ffffffffc0202b4e:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b50:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202b54:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b56:	078a                	slli	a5,a5,0x2
ffffffffc0202b58:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b5a:	20e7f463          	bgeu	a5,a4,ffffffffc0202d62 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b5e:	000bb503          	ld	a0,0(s7)
ffffffffc0202b62:	fe000737          	lui	a4,0xfe000
ffffffffc0202b66:	079a                	slli	a5,a5,0x6
ffffffffc0202b68:	97ba                	add	a5,a5,a4
ffffffffc0202b6a:	953e                	add	a0,a0,a5
ffffffffc0202b6c:	100027f3          	csrr	a5,sstatus
ffffffffc0202b70:	8b89                	andi	a5,a5,2
ffffffffc0202b72:	14079863          	bnez	a5,ffffffffc0202cc2 <pmm_init+0x6bc>
ffffffffc0202b76:	000b3783          	ld	a5,0(s6)
ffffffffc0202b7a:	4585                	li	a1,1
ffffffffc0202b7c:	739c                	ld	a5,32(a5)
ffffffffc0202b7e:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202b80:	00093783          	ld	a5,0(s2)
ffffffffc0202b84:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202b88:	12000073          	sfence.vma
ffffffffc0202b8c:	100027f3          	csrr	a5,sstatus
ffffffffc0202b90:	8b89                	andi	a5,a5,2
ffffffffc0202b92:	10079e63          	bnez	a5,ffffffffc0202cae <pmm_init+0x6a8>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b96:	000b3783          	ld	a5,0(s6)
ffffffffc0202b9a:	779c                	ld	a5,40(a5)
ffffffffc0202b9c:	9782                	jalr	a5
ffffffffc0202b9e:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202ba0:	1e8c1b63          	bne	s8,s0,ffffffffc0202d96 <pmm_init+0x790>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202ba4:	00005517          	auipc	a0,0x5
ffffffffc0202ba8:	bec50513          	addi	a0,a0,-1044 # ffffffffc0207790 <etext+0x144c>
ffffffffc0202bac:	decfd0ef          	jal	ffffffffc0200198 <cprintf>
}
ffffffffc0202bb0:	7406                	ld	s0,96(sp)
ffffffffc0202bb2:	70a6                	ld	ra,104(sp)
ffffffffc0202bb4:	64e6                	ld	s1,88(sp)
ffffffffc0202bb6:	6946                	ld	s2,80(sp)
ffffffffc0202bb8:	69a6                	ld	s3,72(sp)
ffffffffc0202bba:	6a06                	ld	s4,64(sp)
ffffffffc0202bbc:	7ae2                	ld	s5,56(sp)
ffffffffc0202bbe:	7b42                	ld	s6,48(sp)
ffffffffc0202bc0:	7ba2                	ld	s7,40(sp)
ffffffffc0202bc2:	7c02                	ld	s8,32(sp)
ffffffffc0202bc4:	6ce2                	ld	s9,24(sp)
ffffffffc0202bc6:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202bc8:	f85fe06f          	j	ffffffffc0201b4c <kmalloc_init>
    if (maxpa > KERNTOP)
ffffffffc0202bcc:	853e                	mv	a0,a5
ffffffffc0202bce:	b4e1                	j	ffffffffc0202696 <pmm_init+0x90>
        intr_disable();
ffffffffc0202bd0:	cebfd0ef          	jal	ffffffffc02008ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202bd4:	000b3783          	ld	a5,0(s6)
ffffffffc0202bd8:	4505                	li	a0,1
ffffffffc0202bda:	6f9c                	ld	a5,24(a5)
ffffffffc0202bdc:	9782                	jalr	a5
ffffffffc0202bde:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202be0:	cd5fd0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0202be4:	be75                	j	ffffffffc02027a0 <pmm_init+0x19a>
        intr_disable();
ffffffffc0202be6:	cd5fd0ef          	jal	ffffffffc02008ba <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202bea:	000b3783          	ld	a5,0(s6)
ffffffffc0202bee:	779c                	ld	a5,40(a5)
ffffffffc0202bf0:	9782                	jalr	a5
ffffffffc0202bf2:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202bf4:	cc1fd0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0202bf8:	b6ad                	j	ffffffffc0202762 <pmm_init+0x15c>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202bfa:	6705                	lui	a4,0x1
ffffffffc0202bfc:	177d                	addi	a4,a4,-1 # fff <_binary_obj___user_softint_out_size-0x80e1>
ffffffffc0202bfe:	96ba                	add	a3,a3,a4
ffffffffc0202c00:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202c02:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202c06:	14a77e63          	bgeu	a4,a0,ffffffffc0202d62 <pmm_init+0x75c>
    pmm_manager->init_memmap(base, n);
ffffffffc0202c0a:	000b3683          	ld	a3,0(s6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202c0e:	8c1d                	sub	s0,s0,a5
    return &pages[PPN(pa) - nbase];
ffffffffc0202c10:	071a                	slli	a4,a4,0x6
ffffffffc0202c12:	fe0007b7          	lui	a5,0xfe000
ffffffffc0202c16:	973e                	add	a4,a4,a5
    pmm_manager->init_memmap(base, n);
ffffffffc0202c18:	6a9c                	ld	a5,16(a3)
ffffffffc0202c1a:	00c45593          	srli	a1,s0,0xc
ffffffffc0202c1e:	00e60533          	add	a0,a2,a4
ffffffffc0202c22:	9782                	jalr	a5
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202c24:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202c28:	bcf1                	j	ffffffffc0202704 <pmm_init+0xfe>
        intr_disable();
ffffffffc0202c2a:	c91fd0ef          	jal	ffffffffc02008ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202c2e:	000b3783          	ld	a5,0(s6)
ffffffffc0202c32:	4505                	li	a0,1
ffffffffc0202c34:	6f9c                	ld	a5,24(a5)
ffffffffc0202c36:	9782                	jalr	a5
ffffffffc0202c38:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202c3a:	c7bfd0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0202c3e:	b119                	j	ffffffffc0202844 <pmm_init+0x23e>
        intr_disable();
ffffffffc0202c40:	c7bfd0ef          	jal	ffffffffc02008ba <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c44:	000b3783          	ld	a5,0(s6)
ffffffffc0202c48:	779c                	ld	a5,40(a5)
ffffffffc0202c4a:	9782                	jalr	a5
ffffffffc0202c4c:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202c4e:	c67fd0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0202c52:	b345                	j	ffffffffc02029f2 <pmm_init+0x3ec>
        intr_disable();
ffffffffc0202c54:	c67fd0ef          	jal	ffffffffc02008ba <intr_disable>
ffffffffc0202c58:	000b3783          	ld	a5,0(s6)
ffffffffc0202c5c:	779c                	ld	a5,40(a5)
ffffffffc0202c5e:	9782                	jalr	a5
ffffffffc0202c60:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202c62:	c53fd0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0202c66:	b3a5                	j	ffffffffc02029ce <pmm_init+0x3c8>
ffffffffc0202c68:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202c6a:	c51fd0ef          	jal	ffffffffc02008ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202c6e:	000b3783          	ld	a5,0(s6)
ffffffffc0202c72:	6522                	ld	a0,8(sp)
ffffffffc0202c74:	4585                	li	a1,1
ffffffffc0202c76:	739c                	ld	a5,32(a5)
ffffffffc0202c78:	9782                	jalr	a5
        intr_enable();
ffffffffc0202c7a:	c3bfd0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0202c7e:	bb05                	j	ffffffffc02029ae <pmm_init+0x3a8>
ffffffffc0202c80:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202c82:	c39fd0ef          	jal	ffffffffc02008ba <intr_disable>
ffffffffc0202c86:	000b3783          	ld	a5,0(s6)
ffffffffc0202c8a:	6522                	ld	a0,8(sp)
ffffffffc0202c8c:	4585                	li	a1,1
ffffffffc0202c8e:	739c                	ld	a5,32(a5)
ffffffffc0202c90:	9782                	jalr	a5
        intr_enable();
ffffffffc0202c92:	c23fd0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0202c96:	b1e5                	j	ffffffffc020297e <pmm_init+0x378>
        intr_disable();
ffffffffc0202c98:	c23fd0ef          	jal	ffffffffc02008ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202c9c:	000b3783          	ld	a5,0(s6)
ffffffffc0202ca0:	4505                	li	a0,1
ffffffffc0202ca2:	6f9c                	ld	a5,24(a5)
ffffffffc0202ca4:	9782                	jalr	a5
ffffffffc0202ca6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202ca8:	c0dfd0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0202cac:	b375                	j	ffffffffc0202a58 <pmm_init+0x452>
        intr_disable();
ffffffffc0202cae:	c0dfd0ef          	jal	ffffffffc02008ba <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202cb2:	000b3783          	ld	a5,0(s6)
ffffffffc0202cb6:	779c                	ld	a5,40(a5)
ffffffffc0202cb8:	9782                	jalr	a5
ffffffffc0202cba:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202cbc:	bf9fd0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0202cc0:	b5c5                	j	ffffffffc0202ba0 <pmm_init+0x59a>
ffffffffc0202cc2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202cc4:	bf7fd0ef          	jal	ffffffffc02008ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202cc8:	000b3783          	ld	a5,0(s6)
ffffffffc0202ccc:	6522                	ld	a0,8(sp)
ffffffffc0202cce:	4585                	li	a1,1
ffffffffc0202cd0:	739c                	ld	a5,32(a5)
ffffffffc0202cd2:	9782                	jalr	a5
        intr_enable();
ffffffffc0202cd4:	be1fd0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0202cd8:	b565                	j	ffffffffc0202b80 <pmm_init+0x57a>
ffffffffc0202cda:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202cdc:	bdffd0ef          	jal	ffffffffc02008ba <intr_disable>
ffffffffc0202ce0:	000b3783          	ld	a5,0(s6)
ffffffffc0202ce4:	6522                	ld	a0,8(sp)
ffffffffc0202ce6:	4585                	li	a1,1
ffffffffc0202ce8:	739c                	ld	a5,32(a5)
ffffffffc0202cea:	9782                	jalr	a5
        intr_enable();
ffffffffc0202cec:	bc9fd0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0202cf0:	b585                	j	ffffffffc0202b50 <pmm_init+0x54a>
        intr_disable();
ffffffffc0202cf2:	bc9fd0ef          	jal	ffffffffc02008ba <intr_disable>
ffffffffc0202cf6:	000b3783          	ld	a5,0(s6)
ffffffffc0202cfa:	8522                	mv	a0,s0
ffffffffc0202cfc:	4585                	li	a1,1
ffffffffc0202cfe:	739c                	ld	a5,32(a5)
ffffffffc0202d00:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d02:	bb3fd0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0202d06:	bd29                	j	ffffffffc0202b20 <pmm_init+0x51a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202d08:	86a2                	mv	a3,s0
ffffffffc0202d0a:	00004617          	auipc	a2,0x4
ffffffffc0202d0e:	39e60613          	addi	a2,a2,926 # ffffffffc02070a8 <etext+0xd64>
ffffffffc0202d12:	25100593          	li	a1,593
ffffffffc0202d16:	00004517          	auipc	a0,0x4
ffffffffc0202d1a:	48250513          	addi	a0,a0,1154 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202d1e:	f2cfd0ef          	jal	ffffffffc020044a <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202d22:	00005697          	auipc	a3,0x5
ffffffffc0202d26:	90e68693          	addi	a3,a3,-1778 # ffffffffc0207630 <etext+0x12ec>
ffffffffc0202d2a:	00004617          	auipc	a2,0x4
ffffffffc0202d2e:	fce60613          	addi	a2,a2,-50 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202d32:	25200593          	li	a1,594
ffffffffc0202d36:	00004517          	auipc	a0,0x4
ffffffffc0202d3a:	46250513          	addi	a0,a0,1122 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202d3e:	f0cfd0ef          	jal	ffffffffc020044a <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202d42:	00005697          	auipc	a3,0x5
ffffffffc0202d46:	8ae68693          	addi	a3,a3,-1874 # ffffffffc02075f0 <etext+0x12ac>
ffffffffc0202d4a:	00004617          	auipc	a2,0x4
ffffffffc0202d4e:	fae60613          	addi	a2,a2,-82 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202d52:	25100593          	li	a1,593
ffffffffc0202d56:	00004517          	auipc	a0,0x4
ffffffffc0202d5a:	44250513          	addi	a0,a0,1090 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202d5e:	eecfd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202d62:	fb5fe0ef          	jal	ffffffffc0201d16 <pa2page.part.0>
        panic("pte2page called with invalid pte");
ffffffffc0202d66:	00004617          	auipc	a2,0x4
ffffffffc0202d6a:	62a60613          	addi	a2,a2,1578 # ffffffffc0207390 <etext+0x104c>
ffffffffc0202d6e:	07f00593          	li	a1,127
ffffffffc0202d72:	00004517          	auipc	a0,0x4
ffffffffc0202d76:	35e50513          	addi	a0,a0,862 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc0202d7a:	ed0fd0ef          	jal	ffffffffc020044a <__panic>
        panic("DTB memory info not available");
ffffffffc0202d7e:	00004617          	auipc	a2,0x4
ffffffffc0202d82:	48a60613          	addi	a2,a2,1162 # ffffffffc0207208 <etext+0xec4>
ffffffffc0202d86:	06400593          	li	a1,100
ffffffffc0202d8a:	00004517          	auipc	a0,0x4
ffffffffc0202d8e:	40e50513          	addi	a0,a0,1038 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202d92:	eb8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202d96:	00005697          	auipc	a3,0x5
ffffffffc0202d9a:	81268693          	addi	a3,a3,-2030 # ffffffffc02075a8 <etext+0x1264>
ffffffffc0202d9e:	00004617          	auipc	a2,0x4
ffffffffc0202da2:	f5a60613          	addi	a2,a2,-166 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202da6:	26c00593          	li	a1,620
ffffffffc0202daa:	00004517          	auipc	a0,0x4
ffffffffc0202dae:	3ee50513          	addi	a0,a0,1006 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202db2:	e98fd0ef          	jal	ffffffffc020044a <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202db6:	00004697          	auipc	a3,0x4
ffffffffc0202dba:	50a68693          	addi	a3,a3,1290 # ffffffffc02072c0 <etext+0xf7c>
ffffffffc0202dbe:	00004617          	auipc	a2,0x4
ffffffffc0202dc2:	f3a60613          	addi	a2,a2,-198 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202dc6:	21300593          	li	a1,531
ffffffffc0202dca:	00004517          	auipc	a0,0x4
ffffffffc0202dce:	3ce50513          	addi	a0,a0,974 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202dd2:	e78fd0ef          	jal	ffffffffc020044a <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202dd6:	00004697          	auipc	a3,0x4
ffffffffc0202dda:	4ca68693          	addi	a3,a3,1226 # ffffffffc02072a0 <etext+0xf5c>
ffffffffc0202dde:	00004617          	auipc	a2,0x4
ffffffffc0202de2:	f1a60613          	addi	a2,a2,-230 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202de6:	21200593          	li	a1,530
ffffffffc0202dea:	00004517          	auipc	a0,0x4
ffffffffc0202dee:	3ae50513          	addi	a0,a0,942 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202df2:	e58fd0ef          	jal	ffffffffc020044a <__panic>
    return KADDR(page2pa(page));
ffffffffc0202df6:	00004617          	auipc	a2,0x4
ffffffffc0202dfa:	2b260613          	addi	a2,a2,690 # ffffffffc02070a8 <etext+0xd64>
ffffffffc0202dfe:	07100593          	li	a1,113
ffffffffc0202e02:	00004517          	auipc	a0,0x4
ffffffffc0202e06:	2ce50513          	addi	a0,a0,718 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc0202e0a:	e40fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202e0e:	00004697          	auipc	a3,0x4
ffffffffc0202e12:	76a68693          	addi	a3,a3,1898 # ffffffffc0207578 <etext+0x1234>
ffffffffc0202e16:	00004617          	auipc	a2,0x4
ffffffffc0202e1a:	ee260613          	addi	a2,a2,-286 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202e1e:	23a00593          	li	a1,570
ffffffffc0202e22:	00004517          	auipc	a0,0x4
ffffffffc0202e26:	37650513          	addi	a0,a0,886 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202e2a:	e20fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202e2e:	00004697          	auipc	a3,0x4
ffffffffc0202e32:	70268693          	addi	a3,a3,1794 # ffffffffc0207530 <etext+0x11ec>
ffffffffc0202e36:	00004617          	auipc	a2,0x4
ffffffffc0202e3a:	ec260613          	addi	a2,a2,-318 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202e3e:	23800593          	li	a1,568
ffffffffc0202e42:	00004517          	auipc	a0,0x4
ffffffffc0202e46:	35650513          	addi	a0,a0,854 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202e4a:	e00fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202e4e:	00004697          	auipc	a3,0x4
ffffffffc0202e52:	71268693          	addi	a3,a3,1810 # ffffffffc0207560 <etext+0x121c>
ffffffffc0202e56:	00004617          	auipc	a2,0x4
ffffffffc0202e5a:	ea260613          	addi	a2,a2,-350 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202e5e:	23700593          	li	a1,567
ffffffffc0202e62:	00004517          	auipc	a0,0x4
ffffffffc0202e66:	33650513          	addi	a0,a0,822 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202e6a:	de0fd0ef          	jal	ffffffffc020044a <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202e6e:	00004697          	auipc	a3,0x4
ffffffffc0202e72:	7da68693          	addi	a3,a3,2010 # ffffffffc0207648 <etext+0x1304>
ffffffffc0202e76:	00004617          	auipc	a2,0x4
ffffffffc0202e7a:	e8260613          	addi	a2,a2,-382 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202e7e:	25500593          	li	a1,597
ffffffffc0202e82:	00004517          	auipc	a0,0x4
ffffffffc0202e86:	31650513          	addi	a0,a0,790 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202e8a:	dc0fd0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202e8e:	00004697          	auipc	a3,0x4
ffffffffc0202e92:	71a68693          	addi	a3,a3,1818 # ffffffffc02075a8 <etext+0x1264>
ffffffffc0202e96:	00004617          	auipc	a2,0x4
ffffffffc0202e9a:	e6260613          	addi	a2,a2,-414 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202e9e:	24200593          	li	a1,578
ffffffffc0202ea2:	00004517          	auipc	a0,0x4
ffffffffc0202ea6:	2f650513          	addi	a0,a0,758 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202eaa:	da0fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202eae:	00004697          	auipc	a3,0x4
ffffffffc0202eb2:	7f268693          	addi	a3,a3,2034 # ffffffffc02076a0 <etext+0x135c>
ffffffffc0202eb6:	00004617          	auipc	a2,0x4
ffffffffc0202eba:	e4260613          	addi	a2,a2,-446 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202ebe:	25a00593          	li	a1,602
ffffffffc0202ec2:	00004517          	auipc	a0,0x4
ffffffffc0202ec6:	2d650513          	addi	a0,a0,726 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202eca:	d80fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202ece:	00004697          	auipc	a3,0x4
ffffffffc0202ed2:	79268693          	addi	a3,a3,1938 # ffffffffc0207660 <etext+0x131c>
ffffffffc0202ed6:	00004617          	auipc	a2,0x4
ffffffffc0202eda:	e2260613          	addi	a2,a2,-478 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202ede:	25900593          	li	a1,601
ffffffffc0202ee2:	00004517          	auipc	a0,0x4
ffffffffc0202ee6:	2b650513          	addi	a0,a0,694 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202eea:	d60fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202eee:	00004697          	auipc	a3,0x4
ffffffffc0202ef2:	64268693          	addi	a3,a3,1602 # ffffffffc0207530 <etext+0x11ec>
ffffffffc0202ef6:	00004617          	auipc	a2,0x4
ffffffffc0202efa:	e0260613          	addi	a2,a2,-510 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202efe:	23400593          	li	a1,564
ffffffffc0202f02:	00004517          	auipc	a0,0x4
ffffffffc0202f06:	29650513          	addi	a0,a0,662 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202f0a:	d40fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202f0e:	00004697          	auipc	a3,0x4
ffffffffc0202f12:	4c268693          	addi	a3,a3,1218 # ffffffffc02073d0 <etext+0x108c>
ffffffffc0202f16:	00004617          	auipc	a2,0x4
ffffffffc0202f1a:	de260613          	addi	a2,a2,-542 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202f1e:	23300593          	li	a1,563
ffffffffc0202f22:	00004517          	auipc	a0,0x4
ffffffffc0202f26:	27650513          	addi	a0,a0,630 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202f2a:	d20fd0ef          	jal	ffffffffc020044a <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202f2e:	00004697          	auipc	a3,0x4
ffffffffc0202f32:	61a68693          	addi	a3,a3,1562 # ffffffffc0207548 <etext+0x1204>
ffffffffc0202f36:	00004617          	auipc	a2,0x4
ffffffffc0202f3a:	dc260613          	addi	a2,a2,-574 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202f3e:	23000593          	li	a1,560
ffffffffc0202f42:	00004517          	auipc	a0,0x4
ffffffffc0202f46:	25650513          	addi	a0,a0,598 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202f4a:	d00fd0ef          	jal	ffffffffc020044a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202f4e:	00004697          	auipc	a3,0x4
ffffffffc0202f52:	46a68693          	addi	a3,a3,1130 # ffffffffc02073b8 <etext+0x1074>
ffffffffc0202f56:	00004617          	auipc	a2,0x4
ffffffffc0202f5a:	da260613          	addi	a2,a2,-606 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202f5e:	22f00593          	li	a1,559
ffffffffc0202f62:	00004517          	auipc	a0,0x4
ffffffffc0202f66:	23650513          	addi	a0,a0,566 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202f6a:	ce0fd0ef          	jal	ffffffffc020044a <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202f6e:	00004697          	auipc	a3,0x4
ffffffffc0202f72:	4ea68693          	addi	a3,a3,1258 # ffffffffc0207458 <etext+0x1114>
ffffffffc0202f76:	00004617          	auipc	a2,0x4
ffffffffc0202f7a:	d8260613          	addi	a2,a2,-638 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202f7e:	22e00593          	li	a1,558
ffffffffc0202f82:	00004517          	auipc	a0,0x4
ffffffffc0202f86:	21650513          	addi	a0,a0,534 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202f8a:	cc0fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202f8e:	00004697          	auipc	a3,0x4
ffffffffc0202f92:	5a268693          	addi	a3,a3,1442 # ffffffffc0207530 <etext+0x11ec>
ffffffffc0202f96:	00004617          	auipc	a2,0x4
ffffffffc0202f9a:	d6260613          	addi	a2,a2,-670 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202f9e:	22d00593          	li	a1,557
ffffffffc0202fa2:	00004517          	auipc	a0,0x4
ffffffffc0202fa6:	1f650513          	addi	a0,a0,502 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202faa:	ca0fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0202fae:	00004697          	auipc	a3,0x4
ffffffffc0202fb2:	56a68693          	addi	a3,a3,1386 # ffffffffc0207518 <etext+0x11d4>
ffffffffc0202fb6:	00004617          	auipc	a2,0x4
ffffffffc0202fba:	d4260613          	addi	a2,a2,-702 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202fbe:	22c00593          	li	a1,556
ffffffffc0202fc2:	00004517          	auipc	a0,0x4
ffffffffc0202fc6:	1d650513          	addi	a0,a0,470 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202fca:	c80fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202fce:	00004697          	auipc	a3,0x4
ffffffffc0202fd2:	51a68693          	addi	a3,a3,1306 # ffffffffc02074e8 <etext+0x11a4>
ffffffffc0202fd6:	00004617          	auipc	a2,0x4
ffffffffc0202fda:	d2260613          	addi	a2,a2,-734 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202fde:	22b00593          	li	a1,555
ffffffffc0202fe2:	00004517          	auipc	a0,0x4
ffffffffc0202fe6:	1b650513          	addi	a0,a0,438 # ffffffffc0207198 <etext+0xe54>
ffffffffc0202fea:	c60fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0202fee:	00004697          	auipc	a3,0x4
ffffffffc0202ff2:	4e268693          	addi	a3,a3,1250 # ffffffffc02074d0 <etext+0x118c>
ffffffffc0202ff6:	00004617          	auipc	a2,0x4
ffffffffc0202ffa:	d0260613          	addi	a2,a2,-766 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0202ffe:	22900593          	li	a1,553
ffffffffc0203002:	00004517          	auipc	a0,0x4
ffffffffc0203006:	19650513          	addi	a0,a0,406 # ffffffffc0207198 <etext+0xe54>
ffffffffc020300a:	c40fd0ef          	jal	ffffffffc020044a <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc020300e:	00004697          	auipc	a3,0x4
ffffffffc0203012:	4a268693          	addi	a3,a3,1186 # ffffffffc02074b0 <etext+0x116c>
ffffffffc0203016:	00004617          	auipc	a2,0x4
ffffffffc020301a:	ce260613          	addi	a2,a2,-798 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc020301e:	22800593          	li	a1,552
ffffffffc0203022:	00004517          	auipc	a0,0x4
ffffffffc0203026:	17650513          	addi	a0,a0,374 # ffffffffc0207198 <etext+0xe54>
ffffffffc020302a:	c20fd0ef          	jal	ffffffffc020044a <__panic>
    assert(*ptep & PTE_W);
ffffffffc020302e:	00004697          	auipc	a3,0x4
ffffffffc0203032:	47268693          	addi	a3,a3,1138 # ffffffffc02074a0 <etext+0x115c>
ffffffffc0203036:	00004617          	auipc	a2,0x4
ffffffffc020303a:	cc260613          	addi	a2,a2,-830 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc020303e:	22700593          	li	a1,551
ffffffffc0203042:	00004517          	auipc	a0,0x4
ffffffffc0203046:	15650513          	addi	a0,a0,342 # ffffffffc0207198 <etext+0xe54>
ffffffffc020304a:	c00fd0ef          	jal	ffffffffc020044a <__panic>
    assert(*ptep & PTE_U);
ffffffffc020304e:	00004697          	auipc	a3,0x4
ffffffffc0203052:	44268693          	addi	a3,a3,1090 # ffffffffc0207490 <etext+0x114c>
ffffffffc0203056:	00004617          	auipc	a2,0x4
ffffffffc020305a:	ca260613          	addi	a2,a2,-862 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc020305e:	22600593          	li	a1,550
ffffffffc0203062:	00004517          	auipc	a0,0x4
ffffffffc0203066:	13650513          	addi	a0,a0,310 # ffffffffc0207198 <etext+0xe54>
ffffffffc020306a:	be0fd0ef          	jal	ffffffffc020044a <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020306e:	00004617          	auipc	a2,0x4
ffffffffc0203072:	0e260613          	addi	a2,a2,226 # ffffffffc0207150 <etext+0xe0c>
ffffffffc0203076:	08000593          	li	a1,128
ffffffffc020307a:	00004517          	auipc	a0,0x4
ffffffffc020307e:	11e50513          	addi	a0,a0,286 # ffffffffc0207198 <etext+0xe54>
ffffffffc0203082:	bc8fd0ef          	jal	ffffffffc020044a <__panic>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0203086:	00004697          	auipc	a3,0x4
ffffffffc020308a:	36268693          	addi	a3,a3,866 # ffffffffc02073e8 <etext+0x10a4>
ffffffffc020308e:	00004617          	auipc	a2,0x4
ffffffffc0203092:	c6a60613          	addi	a2,a2,-918 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203096:	22100593          	li	a1,545
ffffffffc020309a:	00004517          	auipc	a0,0x4
ffffffffc020309e:	0fe50513          	addi	a0,a0,254 # ffffffffc0207198 <etext+0xe54>
ffffffffc02030a2:	ba8fd0ef          	jal	ffffffffc020044a <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02030a6:	00004697          	auipc	a3,0x4
ffffffffc02030aa:	3b268693          	addi	a3,a3,946 # ffffffffc0207458 <etext+0x1114>
ffffffffc02030ae:	00004617          	auipc	a2,0x4
ffffffffc02030b2:	c4a60613          	addi	a2,a2,-950 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02030b6:	22500593          	li	a1,549
ffffffffc02030ba:	00004517          	auipc	a0,0x4
ffffffffc02030be:	0de50513          	addi	a0,a0,222 # ffffffffc0207198 <etext+0xe54>
ffffffffc02030c2:	b88fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02030c6:	00004697          	auipc	a3,0x4
ffffffffc02030ca:	35268693          	addi	a3,a3,850 # ffffffffc0207418 <etext+0x10d4>
ffffffffc02030ce:	00004617          	auipc	a2,0x4
ffffffffc02030d2:	c2a60613          	addi	a2,a2,-982 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02030d6:	22400593          	li	a1,548
ffffffffc02030da:	00004517          	auipc	a0,0x4
ffffffffc02030de:	0be50513          	addi	a0,a0,190 # ffffffffc0207198 <etext+0xe54>
ffffffffc02030e2:	b68fd0ef          	jal	ffffffffc020044a <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02030e6:	86d6                	mv	a3,s5
ffffffffc02030e8:	00004617          	auipc	a2,0x4
ffffffffc02030ec:	fc060613          	addi	a2,a2,-64 # ffffffffc02070a8 <etext+0xd64>
ffffffffc02030f0:	22000593          	li	a1,544
ffffffffc02030f4:	00004517          	auipc	a0,0x4
ffffffffc02030f8:	0a450513          	addi	a0,a0,164 # ffffffffc0207198 <etext+0xe54>
ffffffffc02030fc:	b4efd0ef          	jal	ffffffffc020044a <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0203100:	00004617          	auipc	a2,0x4
ffffffffc0203104:	fa860613          	addi	a2,a2,-88 # ffffffffc02070a8 <etext+0xd64>
ffffffffc0203108:	21f00593          	li	a1,543
ffffffffc020310c:	00004517          	auipc	a0,0x4
ffffffffc0203110:	08c50513          	addi	a0,a0,140 # ffffffffc0207198 <etext+0xe54>
ffffffffc0203114:	b36fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203118:	00004697          	auipc	a3,0x4
ffffffffc020311c:	2b868693          	addi	a3,a3,696 # ffffffffc02073d0 <etext+0x108c>
ffffffffc0203120:	00004617          	auipc	a2,0x4
ffffffffc0203124:	bd860613          	addi	a2,a2,-1064 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203128:	21d00593          	li	a1,541
ffffffffc020312c:	00004517          	auipc	a0,0x4
ffffffffc0203130:	06c50513          	addi	a0,a0,108 # ffffffffc0207198 <etext+0xe54>
ffffffffc0203134:	b16fd0ef          	jal	ffffffffc020044a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203138:	00004697          	auipc	a3,0x4
ffffffffc020313c:	28068693          	addi	a3,a3,640 # ffffffffc02073b8 <etext+0x1074>
ffffffffc0203140:	00004617          	auipc	a2,0x4
ffffffffc0203144:	bb860613          	addi	a2,a2,-1096 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203148:	21c00593          	li	a1,540
ffffffffc020314c:	00004517          	auipc	a0,0x4
ffffffffc0203150:	04c50513          	addi	a0,a0,76 # ffffffffc0207198 <etext+0xe54>
ffffffffc0203154:	af6fd0ef          	jal	ffffffffc020044a <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203158:	00004697          	auipc	a3,0x4
ffffffffc020315c:	61068693          	addi	a3,a3,1552 # ffffffffc0207768 <etext+0x1424>
ffffffffc0203160:	00004617          	auipc	a2,0x4
ffffffffc0203164:	b9860613          	addi	a2,a2,-1128 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203168:	26300593          	li	a1,611
ffffffffc020316c:	00004517          	auipc	a0,0x4
ffffffffc0203170:	02c50513          	addi	a0,a0,44 # ffffffffc0207198 <etext+0xe54>
ffffffffc0203174:	ad6fd0ef          	jal	ffffffffc020044a <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203178:	00004697          	auipc	a3,0x4
ffffffffc020317c:	5b868693          	addi	a3,a3,1464 # ffffffffc0207730 <etext+0x13ec>
ffffffffc0203180:	00004617          	auipc	a2,0x4
ffffffffc0203184:	b7860613          	addi	a2,a2,-1160 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203188:	26000593          	li	a1,608
ffffffffc020318c:	00004517          	auipc	a0,0x4
ffffffffc0203190:	00c50513          	addi	a0,a0,12 # ffffffffc0207198 <etext+0xe54>
ffffffffc0203194:	ab6fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203198:	00004697          	auipc	a3,0x4
ffffffffc020319c:	56868693          	addi	a3,a3,1384 # ffffffffc0207700 <etext+0x13bc>
ffffffffc02031a0:	00004617          	auipc	a2,0x4
ffffffffc02031a4:	b5860613          	addi	a2,a2,-1192 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02031a8:	25c00593          	li	a1,604
ffffffffc02031ac:	00004517          	auipc	a0,0x4
ffffffffc02031b0:	fec50513          	addi	a0,a0,-20 # ffffffffc0207198 <etext+0xe54>
ffffffffc02031b4:	a96fd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02031b8:	00004697          	auipc	a3,0x4
ffffffffc02031bc:	50068693          	addi	a3,a3,1280 # ffffffffc02076b8 <etext+0x1374>
ffffffffc02031c0:	00004617          	auipc	a2,0x4
ffffffffc02031c4:	b3860613          	addi	a2,a2,-1224 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02031c8:	25b00593          	li	a1,603
ffffffffc02031cc:	00004517          	auipc	a0,0x4
ffffffffc02031d0:	fcc50513          	addi	a0,a0,-52 # ffffffffc0207198 <etext+0xe54>
ffffffffc02031d4:	a76fd0ef          	jal	ffffffffc020044a <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02031d8:	00004697          	auipc	a3,0x4
ffffffffc02031dc:	12868693          	addi	a3,a3,296 # ffffffffc0207300 <etext+0xfbc>
ffffffffc02031e0:	00004617          	auipc	a2,0x4
ffffffffc02031e4:	b1860613          	addi	a2,a2,-1256 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02031e8:	21400593          	li	a1,532
ffffffffc02031ec:	00004517          	auipc	a0,0x4
ffffffffc02031f0:	fac50513          	addi	a0,a0,-84 # ffffffffc0207198 <etext+0xe54>
ffffffffc02031f4:	a56fd0ef          	jal	ffffffffc020044a <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02031f8:	00004617          	auipc	a2,0x4
ffffffffc02031fc:	f5860613          	addi	a2,a2,-168 # ffffffffc0207150 <etext+0xe0c>
ffffffffc0203200:	0c800593          	li	a1,200
ffffffffc0203204:	00004517          	auipc	a0,0x4
ffffffffc0203208:	f9450513          	addi	a0,a0,-108 # ffffffffc0207198 <etext+0xe54>
ffffffffc020320c:	a3efd0ef          	jal	ffffffffc020044a <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203210:	00004697          	auipc	a3,0x4
ffffffffc0203214:	15068693          	addi	a3,a3,336 # ffffffffc0207360 <etext+0x101c>
ffffffffc0203218:	00004617          	auipc	a2,0x4
ffffffffc020321c:	ae060613          	addi	a2,a2,-1312 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203220:	21b00593          	li	a1,539
ffffffffc0203224:	00004517          	auipc	a0,0x4
ffffffffc0203228:	f7450513          	addi	a0,a0,-140 # ffffffffc0207198 <etext+0xe54>
ffffffffc020322c:	a1efd0ef          	jal	ffffffffc020044a <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203230:	00004697          	auipc	a3,0x4
ffffffffc0203234:	10068693          	addi	a3,a3,256 # ffffffffc0207330 <etext+0xfec>
ffffffffc0203238:	00004617          	auipc	a2,0x4
ffffffffc020323c:	ac060613          	addi	a2,a2,-1344 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203240:	21800593          	li	a1,536
ffffffffc0203244:	00004517          	auipc	a0,0x4
ffffffffc0203248:	f5450513          	addi	a0,a0,-172 # ffffffffc0207198 <etext+0xe54>
ffffffffc020324c:	9fefd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203250 <copy_range>:
{
ffffffffc0203250:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203252:	00d667b3          	or	a5,a2,a3
{
ffffffffc0203256:	f486                	sd	ra,104(sp)
ffffffffc0203258:	f0a2                	sd	s0,96(sp)
ffffffffc020325a:	eca6                	sd	s1,88(sp)
ffffffffc020325c:	e8ca                	sd	s2,80(sp)
ffffffffc020325e:	e4ce                	sd	s3,72(sp)
ffffffffc0203260:	e0d2                	sd	s4,64(sp)
ffffffffc0203262:	fc56                	sd	s5,56(sp)
ffffffffc0203264:	f85a                	sd	s6,48(sp)
ffffffffc0203266:	f45e                	sd	s7,40(sp)
ffffffffc0203268:	f062                	sd	s8,32(sp)
ffffffffc020326a:	ec66                	sd	s9,24(sp)
ffffffffc020326c:	e86a                	sd	s10,16(sp)
ffffffffc020326e:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203270:	03479713          	slli	a4,a5,0x34
ffffffffc0203274:	20071f63          	bnez	a4,ffffffffc0203492 <copy_range+0x242>
    assert(USER_ACCESS(start, end));
ffffffffc0203278:	002007b7          	lui	a5,0x200
ffffffffc020327c:	00d63733          	sltu	a4,a2,a3
ffffffffc0203280:	00f637b3          	sltu	a5,a2,a5
ffffffffc0203284:	00173713          	seqz	a4,a4
ffffffffc0203288:	8fd9                	or	a5,a5,a4
ffffffffc020328a:	8432                	mv	s0,a2
ffffffffc020328c:	8936                	mv	s2,a3
ffffffffc020328e:	1e079263          	bnez	a5,ffffffffc0203472 <copy_range+0x222>
ffffffffc0203292:	4785                	li	a5,1
ffffffffc0203294:	07fe                	slli	a5,a5,0x1f
ffffffffc0203296:	0785                	addi	a5,a5,1 # 200001 <_binary_obj___user_matrix_out_size+0x1f4919>
ffffffffc0203298:	1cf6fd63          	bgeu	a3,a5,ffffffffc0203472 <copy_range+0x222>
ffffffffc020329c:	5b7d                	li	s6,-1
ffffffffc020329e:	8baa                	mv	s7,a0
ffffffffc02032a0:	8a2e                	mv	s4,a1
ffffffffc02032a2:	6a85                	lui	s5,0x1
ffffffffc02032a4:	00cb5b13          	srli	s6,s6,0xc
    if (PPN(pa) >= npage)
ffffffffc02032a8:	000c9c97          	auipc	s9,0xc9
ffffffffc02032ac:	fe0c8c93          	addi	s9,s9,-32 # ffffffffc02cc288 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02032b0:	000c9c17          	auipc	s8,0xc9
ffffffffc02032b4:	fe0c0c13          	addi	s8,s8,-32 # ffffffffc02cc290 <pages>
ffffffffc02032b8:	fff80d37          	lui	s10,0xfff80
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc02032bc:	4601                	li	a2,0
ffffffffc02032be:	85a2                	mv	a1,s0
ffffffffc02032c0:	8552                	mv	a0,s4
ffffffffc02032c2:	b19fe0ef          	jal	ffffffffc0201dda <get_pte>
ffffffffc02032c6:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc02032c8:	0e050a63          	beqz	a0,ffffffffc02033bc <copy_range+0x16c>
        if (*ptep & PTE_V)
ffffffffc02032cc:	611c                	ld	a5,0(a0)
ffffffffc02032ce:	8b85                	andi	a5,a5,1
ffffffffc02032d0:	e78d                	bnez	a5,ffffffffc02032fa <copy_range+0xaa>
        start += PGSIZE;
ffffffffc02032d2:	9456                	add	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc02032d4:	c019                	beqz	s0,ffffffffc02032da <copy_range+0x8a>
ffffffffc02032d6:	ff2463e3          	bltu	s0,s2,ffffffffc02032bc <copy_range+0x6c>
    return 0;
ffffffffc02032da:	4501                	li	a0,0
}
ffffffffc02032dc:	70a6                	ld	ra,104(sp)
ffffffffc02032de:	7406                	ld	s0,96(sp)
ffffffffc02032e0:	64e6                	ld	s1,88(sp)
ffffffffc02032e2:	6946                	ld	s2,80(sp)
ffffffffc02032e4:	69a6                	ld	s3,72(sp)
ffffffffc02032e6:	6a06                	ld	s4,64(sp)
ffffffffc02032e8:	7ae2                	ld	s5,56(sp)
ffffffffc02032ea:	7b42                	ld	s6,48(sp)
ffffffffc02032ec:	7ba2                	ld	s7,40(sp)
ffffffffc02032ee:	7c02                	ld	s8,32(sp)
ffffffffc02032f0:	6ce2                	ld	s9,24(sp)
ffffffffc02032f2:	6d42                	ld	s10,16(sp)
ffffffffc02032f4:	6da2                	ld	s11,8(sp)
ffffffffc02032f6:	6165                	addi	sp,sp,112
ffffffffc02032f8:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc02032fa:	4605                	li	a2,1
ffffffffc02032fc:	85a2                	mv	a1,s0
ffffffffc02032fe:	855e                	mv	a0,s7
ffffffffc0203300:	adbfe0ef          	jal	ffffffffc0201dda <get_pte>
ffffffffc0203304:	c165                	beqz	a0,ffffffffc02033e4 <copy_range+0x194>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc0203306:	0004b983          	ld	s3,0(s1)
    if (!(pte & PTE_V))
ffffffffc020330a:	0019f793          	andi	a5,s3,1
ffffffffc020330e:	14078663          	beqz	a5,ffffffffc020345a <copy_range+0x20a>
    if (PPN(pa) >= npage)
ffffffffc0203312:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203316:	00299793          	slli	a5,s3,0x2
ffffffffc020331a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020331c:	12e7f363          	bgeu	a5,a4,ffffffffc0203442 <copy_range+0x1f2>
    return &pages[PPN(pa) - nbase];
ffffffffc0203320:	000c3483          	ld	s1,0(s8)
ffffffffc0203324:	97ea                	add	a5,a5,s10
ffffffffc0203326:	079a                	slli	a5,a5,0x6
ffffffffc0203328:	94be                	add	s1,s1,a5
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020332a:	100027f3          	csrr	a5,sstatus
ffffffffc020332e:	8b89                	andi	a5,a5,2
ffffffffc0203330:	efc9                	bnez	a5,ffffffffc02033ca <copy_range+0x17a>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203332:	000c9797          	auipc	a5,0xc9
ffffffffc0203336:	f367b783          	ld	a5,-202(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc020333a:	4505                	li	a0,1
ffffffffc020333c:	6f9c                	ld	a5,24(a5)
ffffffffc020333e:	9782                	jalr	a5
ffffffffc0203340:	8daa                	mv	s11,a0
            assert(page != NULL);
ffffffffc0203342:	c0e5                	beqz	s1,ffffffffc0203422 <copy_range+0x1d2>
            assert(npage != NULL);
ffffffffc0203344:	0a0d8f63          	beqz	s11,ffffffffc0203402 <copy_range+0x1b2>
    return page - pages + nbase;
ffffffffc0203348:	000c3783          	ld	a5,0(s8)
ffffffffc020334c:	00080637          	lui	a2,0x80
    return KADDR(page2pa(page));
ffffffffc0203350:	000cb703          	ld	a4,0(s9)
    return page - pages + nbase;
ffffffffc0203354:	40f486b3          	sub	a3,s1,a5
ffffffffc0203358:	8699                	srai	a3,a3,0x6
ffffffffc020335a:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc020335c:	0166f5b3          	and	a1,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0203360:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203362:	08e5f463          	bgeu	a1,a4,ffffffffc02033ea <copy_range+0x19a>
    return page - pages + nbase;
ffffffffc0203366:	40fd87b3          	sub	a5,s11,a5
ffffffffc020336a:	8799                	srai	a5,a5,0x6
ffffffffc020336c:	97b2                	add	a5,a5,a2
    return KADDR(page2pa(page));
ffffffffc020336e:	0167f633          	and	a2,a5,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0203372:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0203374:	06e67a63          	bgeu	a2,a4,ffffffffc02033e8 <copy_range+0x198>
ffffffffc0203378:	000c9517          	auipc	a0,0xc9
ffffffffc020337c:	f0853503          	ld	a0,-248(a0) # ffffffffc02cc280 <va_pa_offset>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc0203380:	6605                	lui	a2,0x1
ffffffffc0203382:	00a685b3          	add	a1,a3,a0
ffffffffc0203386:	953e                	add	a0,a0,a5
ffffffffc0203388:	7a5020ef          	jal	ffffffffc020632c <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc020338c:	01f9f693          	andi	a3,s3,31
ffffffffc0203390:	85ee                	mv	a1,s11
ffffffffc0203392:	8622                	mv	a2,s0
ffffffffc0203394:	855e                	mv	a0,s7
ffffffffc0203396:	97aff0ef          	jal	ffffffffc0202510 <page_insert>
            assert(ret == 0);
ffffffffc020339a:	dd05                	beqz	a0,ffffffffc02032d2 <copy_range+0x82>
ffffffffc020339c:	00004697          	auipc	a3,0x4
ffffffffc02033a0:	43468693          	addi	a3,a3,1076 # ffffffffc02077d0 <etext+0x148c>
ffffffffc02033a4:	00004617          	auipc	a2,0x4
ffffffffc02033a8:	95460613          	addi	a2,a2,-1708 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02033ac:	1b000593          	li	a1,432
ffffffffc02033b0:	00004517          	auipc	a0,0x4
ffffffffc02033b4:	de850513          	addi	a0,a0,-536 # ffffffffc0207198 <etext+0xe54>
ffffffffc02033b8:	892fd0ef          	jal	ffffffffc020044a <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02033bc:	002007b7          	lui	a5,0x200
ffffffffc02033c0:	97a2                	add	a5,a5,s0
ffffffffc02033c2:	ffe00437          	lui	s0,0xffe00
ffffffffc02033c6:	8c7d                	and	s0,s0,a5
            continue;
ffffffffc02033c8:	b731                	j	ffffffffc02032d4 <copy_range+0x84>
        intr_disable();
ffffffffc02033ca:	cf0fd0ef          	jal	ffffffffc02008ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02033ce:	000c9797          	auipc	a5,0xc9
ffffffffc02033d2:	e9a7b783          	ld	a5,-358(a5) # ffffffffc02cc268 <pmm_manager>
ffffffffc02033d6:	4505                	li	a0,1
ffffffffc02033d8:	6f9c                	ld	a5,24(a5)
ffffffffc02033da:	9782                	jalr	a5
ffffffffc02033dc:	8daa                	mv	s11,a0
        intr_enable();
ffffffffc02033de:	cd6fd0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc02033e2:	b785                	j	ffffffffc0203342 <copy_range+0xf2>
                return -E_NO_MEM;
ffffffffc02033e4:	5571                	li	a0,-4
ffffffffc02033e6:	bddd                	j	ffffffffc02032dc <copy_range+0x8c>
ffffffffc02033e8:	86be                	mv	a3,a5
ffffffffc02033ea:	00004617          	auipc	a2,0x4
ffffffffc02033ee:	cbe60613          	addi	a2,a2,-834 # ffffffffc02070a8 <etext+0xd64>
ffffffffc02033f2:	07100593          	li	a1,113
ffffffffc02033f6:	00004517          	auipc	a0,0x4
ffffffffc02033fa:	cda50513          	addi	a0,a0,-806 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc02033fe:	84cfd0ef          	jal	ffffffffc020044a <__panic>
            assert(npage != NULL);
ffffffffc0203402:	00004697          	auipc	a3,0x4
ffffffffc0203406:	3be68693          	addi	a3,a3,958 # ffffffffc02077c0 <etext+0x147c>
ffffffffc020340a:	00004617          	auipc	a2,0x4
ffffffffc020340e:	8ee60613          	addi	a2,a2,-1810 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203412:	19600593          	li	a1,406
ffffffffc0203416:	00004517          	auipc	a0,0x4
ffffffffc020341a:	d8250513          	addi	a0,a0,-638 # ffffffffc0207198 <etext+0xe54>
ffffffffc020341e:	82cfd0ef          	jal	ffffffffc020044a <__panic>
            assert(page != NULL);
ffffffffc0203422:	00004697          	auipc	a3,0x4
ffffffffc0203426:	38e68693          	addi	a3,a3,910 # ffffffffc02077b0 <etext+0x146c>
ffffffffc020342a:	00004617          	auipc	a2,0x4
ffffffffc020342e:	8ce60613          	addi	a2,a2,-1842 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203432:	19500593          	li	a1,405
ffffffffc0203436:	00004517          	auipc	a0,0x4
ffffffffc020343a:	d6250513          	addi	a0,a0,-670 # ffffffffc0207198 <etext+0xe54>
ffffffffc020343e:	80cfd0ef          	jal	ffffffffc020044a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203442:	00004617          	auipc	a2,0x4
ffffffffc0203446:	d3660613          	addi	a2,a2,-714 # ffffffffc0207178 <etext+0xe34>
ffffffffc020344a:	06900593          	li	a1,105
ffffffffc020344e:	00004517          	auipc	a0,0x4
ffffffffc0203452:	c8250513          	addi	a0,a0,-894 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc0203456:	ff5fc0ef          	jal	ffffffffc020044a <__panic>
        panic("pte2page called with invalid pte");
ffffffffc020345a:	00004617          	auipc	a2,0x4
ffffffffc020345e:	f3660613          	addi	a2,a2,-202 # ffffffffc0207390 <etext+0x104c>
ffffffffc0203462:	07f00593          	li	a1,127
ffffffffc0203466:	00004517          	auipc	a0,0x4
ffffffffc020346a:	c6a50513          	addi	a0,a0,-918 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc020346e:	fddfc0ef          	jal	ffffffffc020044a <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0203472:	00004697          	auipc	a3,0x4
ffffffffc0203476:	d6668693          	addi	a3,a3,-666 # ffffffffc02071d8 <etext+0xe94>
ffffffffc020347a:	00004617          	auipc	a2,0x4
ffffffffc020347e:	87e60613          	addi	a2,a2,-1922 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203482:	17d00593          	li	a1,381
ffffffffc0203486:	00004517          	auipc	a0,0x4
ffffffffc020348a:	d1250513          	addi	a0,a0,-750 # ffffffffc0207198 <etext+0xe54>
ffffffffc020348e:	fbdfc0ef          	jal	ffffffffc020044a <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203492:	00004697          	auipc	a3,0x4
ffffffffc0203496:	d1668693          	addi	a3,a3,-746 # ffffffffc02071a8 <etext+0xe64>
ffffffffc020349a:	00004617          	auipc	a2,0x4
ffffffffc020349e:	85e60613          	addi	a2,a2,-1954 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02034a2:	17c00593          	li	a1,380
ffffffffc02034a6:	00004517          	auipc	a0,0x4
ffffffffc02034aa:	cf250513          	addi	a0,a0,-782 # ffffffffc0207198 <etext+0xe54>
ffffffffc02034ae:	f9dfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02034b2 <pgdir_alloc_page>:
{
ffffffffc02034b2:	7139                	addi	sp,sp,-64
ffffffffc02034b4:	f426                	sd	s1,40(sp)
ffffffffc02034b6:	f04a                	sd	s2,32(sp)
ffffffffc02034b8:	ec4e                	sd	s3,24(sp)
ffffffffc02034ba:	fc06                	sd	ra,56(sp)
ffffffffc02034bc:	f822                	sd	s0,48(sp)
ffffffffc02034be:	892a                	mv	s2,a0
ffffffffc02034c0:	84ae                	mv	s1,a1
ffffffffc02034c2:	89b2                	mv	s3,a2
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02034c4:	100027f3          	csrr	a5,sstatus
ffffffffc02034c8:	8b89                	andi	a5,a5,2
ffffffffc02034ca:	ebb5                	bnez	a5,ffffffffc020353e <pgdir_alloc_page+0x8c>
        page = pmm_manager->alloc_pages(n);
ffffffffc02034cc:	000c9417          	auipc	s0,0xc9
ffffffffc02034d0:	d9c40413          	addi	s0,s0,-612 # ffffffffc02cc268 <pmm_manager>
ffffffffc02034d4:	601c                	ld	a5,0(s0)
ffffffffc02034d6:	4505                	li	a0,1
ffffffffc02034d8:	6f9c                	ld	a5,24(a5)
ffffffffc02034da:	9782                	jalr	a5
ffffffffc02034dc:	85aa                	mv	a1,a0
    if (page != NULL)
ffffffffc02034de:	c5b9                	beqz	a1,ffffffffc020352c <pgdir_alloc_page+0x7a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc02034e0:	86ce                	mv	a3,s3
ffffffffc02034e2:	854a                	mv	a0,s2
ffffffffc02034e4:	8626                	mv	a2,s1
ffffffffc02034e6:	e42e                	sd	a1,8(sp)
ffffffffc02034e8:	828ff0ef          	jal	ffffffffc0202510 <page_insert>
ffffffffc02034ec:	65a2                	ld	a1,8(sp)
ffffffffc02034ee:	e515                	bnez	a0,ffffffffc020351a <pgdir_alloc_page+0x68>
        assert(page_ref(page) == 1);
ffffffffc02034f0:	4198                	lw	a4,0(a1)
        page->pra_vaddr = la;
ffffffffc02034f2:	fd84                	sd	s1,56(a1)
        assert(page_ref(page) == 1);
ffffffffc02034f4:	4785                	li	a5,1
ffffffffc02034f6:	02f70c63          	beq	a4,a5,ffffffffc020352e <pgdir_alloc_page+0x7c>
ffffffffc02034fa:	00004697          	auipc	a3,0x4
ffffffffc02034fe:	2e668693          	addi	a3,a3,742 # ffffffffc02077e0 <etext+0x149c>
ffffffffc0203502:	00003617          	auipc	a2,0x3
ffffffffc0203506:	7f660613          	addi	a2,a2,2038 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc020350a:	1f900593          	li	a1,505
ffffffffc020350e:	00004517          	auipc	a0,0x4
ffffffffc0203512:	c8a50513          	addi	a0,a0,-886 # ffffffffc0207198 <etext+0xe54>
ffffffffc0203516:	f35fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020351a:	100027f3          	csrr	a5,sstatus
ffffffffc020351e:	8b89                	andi	a5,a5,2
ffffffffc0203520:	ef95                	bnez	a5,ffffffffc020355c <pgdir_alloc_page+0xaa>
        pmm_manager->free_pages(base, n);
ffffffffc0203522:	601c                	ld	a5,0(s0)
ffffffffc0203524:	852e                	mv	a0,a1
ffffffffc0203526:	4585                	li	a1,1
ffffffffc0203528:	739c                	ld	a5,32(a5)
ffffffffc020352a:	9782                	jalr	a5
            return NULL;
ffffffffc020352c:	4581                	li	a1,0
}
ffffffffc020352e:	70e2                	ld	ra,56(sp)
ffffffffc0203530:	7442                	ld	s0,48(sp)
ffffffffc0203532:	74a2                	ld	s1,40(sp)
ffffffffc0203534:	7902                	ld	s2,32(sp)
ffffffffc0203536:	69e2                	ld	s3,24(sp)
ffffffffc0203538:	852e                	mv	a0,a1
ffffffffc020353a:	6121                	addi	sp,sp,64
ffffffffc020353c:	8082                	ret
        intr_disable();
ffffffffc020353e:	b7cfd0ef          	jal	ffffffffc02008ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203542:	000c9417          	auipc	s0,0xc9
ffffffffc0203546:	d2640413          	addi	s0,s0,-730 # ffffffffc02cc268 <pmm_manager>
ffffffffc020354a:	601c                	ld	a5,0(s0)
ffffffffc020354c:	4505                	li	a0,1
ffffffffc020354e:	6f9c                	ld	a5,24(a5)
ffffffffc0203550:	9782                	jalr	a5
ffffffffc0203552:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0203554:	b60fd0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0203558:	65a2                	ld	a1,8(sp)
ffffffffc020355a:	b751                	j	ffffffffc02034de <pgdir_alloc_page+0x2c>
        intr_disable();
ffffffffc020355c:	b5efd0ef          	jal	ffffffffc02008ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0203560:	601c                	ld	a5,0(s0)
ffffffffc0203562:	6522                	ld	a0,8(sp)
ffffffffc0203564:	4585                	li	a1,1
ffffffffc0203566:	739c                	ld	a5,32(a5)
ffffffffc0203568:	9782                	jalr	a5
        intr_enable();
ffffffffc020356a:	b4afd0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc020356e:	bf7d                	j	ffffffffc020352c <pgdir_alloc_page+0x7a>

ffffffffc0203570 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203570:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0203572:	00004697          	auipc	a3,0x4
ffffffffc0203576:	28668693          	addi	a3,a3,646 # ffffffffc02077f8 <etext+0x14b4>
ffffffffc020357a:	00003617          	auipc	a2,0x3
ffffffffc020357e:	77e60613          	addi	a2,a2,1918 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203582:	07400593          	li	a1,116
ffffffffc0203586:	00004517          	auipc	a0,0x4
ffffffffc020358a:	29250513          	addi	a0,a0,658 # ffffffffc0207818 <etext+0x14d4>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc020358e:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0203590:	ebbfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203594 <mm_create>:
{
ffffffffc0203594:	1101                	addi	sp,sp,-32
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203596:	05800513          	li	a0,88
{
ffffffffc020359a:	ec06                	sd	ra,24(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc020359c:	dd4fe0ef          	jal	ffffffffc0201b70 <kmalloc>
ffffffffc02035a0:	87aa                	mv	a5,a0
    if (mm != NULL)
ffffffffc02035a2:	c505                	beqz	a0,ffffffffc02035ca <mm_create+0x36>
    elm->prev = elm->next = elm;
ffffffffc02035a4:	e788                	sd	a0,8(a5)
ffffffffc02035a6:	e388                	sd	a0,0(a5)
        mm->mmap_cache = NULL;
ffffffffc02035a8:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02035ac:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02035b0:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02035b4:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc02035b8:	02052823          	sw	zero,48(a0)
        sem_init(&(mm->mm_sem), 1);
ffffffffc02035bc:	4585                	li	a1,1
ffffffffc02035be:	03850513          	addi	a0,a0,56
ffffffffc02035c2:	e43e                	sd	a5,8(sp)
ffffffffc02035c4:	78f000ef          	jal	ffffffffc0204552 <sem_init>
ffffffffc02035c8:	67a2                	ld	a5,8(sp)
}
ffffffffc02035ca:	60e2                	ld	ra,24(sp)
ffffffffc02035cc:	853e                	mv	a0,a5
ffffffffc02035ce:	6105                	addi	sp,sp,32
ffffffffc02035d0:	8082                	ret

ffffffffc02035d2 <find_vma>:
    if (mm != NULL)
ffffffffc02035d2:	c505                	beqz	a0,ffffffffc02035fa <find_vma+0x28>
        vma = mm->mmap_cache;
ffffffffc02035d4:	691c                	ld	a5,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02035d6:	c781                	beqz	a5,ffffffffc02035de <find_vma+0xc>
ffffffffc02035d8:	6798                	ld	a4,8(a5)
ffffffffc02035da:	02e5f363          	bgeu	a1,a4,ffffffffc0203600 <find_vma+0x2e>
    return listelm->next;
ffffffffc02035de:	651c                	ld	a5,8(a0)
            while ((le = list_next(le)) != list)
ffffffffc02035e0:	00f50d63          	beq	a0,a5,ffffffffc02035fa <find_vma+0x28>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc02035e4:	fe87b703          	ld	a4,-24(a5)
ffffffffc02035e8:	00e5e663          	bltu	a1,a4,ffffffffc02035f4 <find_vma+0x22>
ffffffffc02035ec:	ff07b703          	ld	a4,-16(a5)
ffffffffc02035f0:	00e5ee63          	bltu	a1,a4,ffffffffc020360c <find_vma+0x3a>
ffffffffc02035f4:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc02035f6:	fef517e3          	bne	a0,a5,ffffffffc02035e4 <find_vma+0x12>
    struct vma_struct *vma = NULL;
ffffffffc02035fa:	4781                	li	a5,0
}
ffffffffc02035fc:	853e                	mv	a0,a5
ffffffffc02035fe:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203600:	6b98                	ld	a4,16(a5)
ffffffffc0203602:	fce5fee3          	bgeu	a1,a4,ffffffffc02035de <find_vma+0xc>
            mm->mmap_cache = vma;
ffffffffc0203606:	e91c                	sd	a5,16(a0)
}
ffffffffc0203608:	853e                	mv	a0,a5
ffffffffc020360a:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc020360c:	1781                	addi	a5,a5,-32
            mm->mmap_cache = vma;
ffffffffc020360e:	e91c                	sd	a5,16(a0)
ffffffffc0203610:	bfe5                	j	ffffffffc0203608 <find_vma+0x36>

ffffffffc0203612 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203612:	6590                	ld	a2,8(a1)
ffffffffc0203614:	0105b803          	ld	a6,16(a1)
{
ffffffffc0203618:	1141                	addi	sp,sp,-16
ffffffffc020361a:	e406                	sd	ra,8(sp)
ffffffffc020361c:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc020361e:	01066763          	bltu	a2,a6,ffffffffc020362c <insert_vma_struct+0x1a>
ffffffffc0203622:	a8b9                	j	ffffffffc0203680 <insert_vma_struct+0x6e>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203624:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203628:	04e66763          	bltu	a2,a4,ffffffffc0203676 <insert_vma_struct+0x64>
ffffffffc020362c:	86be                	mv	a3,a5
ffffffffc020362e:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0203630:	fef51ae3          	bne	a0,a5,ffffffffc0203624 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0203634:	02a68463          	beq	a3,a0,ffffffffc020365c <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203638:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc020363c:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203640:	08e8f063          	bgeu	a7,a4,ffffffffc02036c0 <insert_vma_struct+0xae>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203644:	04e66e63          	bltu	a2,a4,ffffffffc02036a0 <insert_vma_struct+0x8e>
    }
    if (le_next != list)
ffffffffc0203648:	00f50a63          	beq	a0,a5,ffffffffc020365c <insert_vma_struct+0x4a>
ffffffffc020364c:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203650:	05076863          	bltu	a4,a6,ffffffffc02036a0 <insert_vma_struct+0x8e>
    assert(next->vm_start < next->vm_end);
ffffffffc0203654:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203658:	02c77263          	bgeu	a4,a2,ffffffffc020367c <insert_vma_struct+0x6a>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc020365c:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc020365e:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0203660:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0203664:	e390                	sd	a2,0(a5)
ffffffffc0203666:	e690                	sd	a2,8(a3)
}
ffffffffc0203668:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc020366a:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc020366c:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc020366e:	2705                	addiw	a4,a4,1
ffffffffc0203670:	d118                	sw	a4,32(a0)
}
ffffffffc0203672:	0141                	addi	sp,sp,16
ffffffffc0203674:	8082                	ret
    if (le_prev != list)
ffffffffc0203676:	fca691e3          	bne	a3,a0,ffffffffc0203638 <insert_vma_struct+0x26>
ffffffffc020367a:	bfd9                	j	ffffffffc0203650 <insert_vma_struct+0x3e>
ffffffffc020367c:	ef5ff0ef          	jal	ffffffffc0203570 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203680:	00004697          	auipc	a3,0x4
ffffffffc0203684:	1a868693          	addi	a3,a3,424 # ffffffffc0207828 <etext+0x14e4>
ffffffffc0203688:	00003617          	auipc	a2,0x3
ffffffffc020368c:	67060613          	addi	a2,a2,1648 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203690:	07a00593          	li	a1,122
ffffffffc0203694:	00004517          	auipc	a0,0x4
ffffffffc0203698:	18450513          	addi	a0,a0,388 # ffffffffc0207818 <etext+0x14d4>
ffffffffc020369c:	daffc0ef          	jal	ffffffffc020044a <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02036a0:	00004697          	auipc	a3,0x4
ffffffffc02036a4:	1c868693          	addi	a3,a3,456 # ffffffffc0207868 <etext+0x1524>
ffffffffc02036a8:	00003617          	auipc	a2,0x3
ffffffffc02036ac:	65060613          	addi	a2,a2,1616 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02036b0:	07300593          	li	a1,115
ffffffffc02036b4:	00004517          	auipc	a0,0x4
ffffffffc02036b8:	16450513          	addi	a0,a0,356 # ffffffffc0207818 <etext+0x14d4>
ffffffffc02036bc:	d8ffc0ef          	jal	ffffffffc020044a <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc02036c0:	00004697          	auipc	a3,0x4
ffffffffc02036c4:	18868693          	addi	a3,a3,392 # ffffffffc0207848 <etext+0x1504>
ffffffffc02036c8:	00003617          	auipc	a2,0x3
ffffffffc02036cc:	63060613          	addi	a2,a2,1584 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02036d0:	07200593          	li	a1,114
ffffffffc02036d4:	00004517          	auipc	a0,0x4
ffffffffc02036d8:	14450513          	addi	a0,a0,324 # ffffffffc0207818 <etext+0x14d4>
ffffffffc02036dc:	d6ffc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02036e0 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc02036e0:	591c                	lw	a5,48(a0)
{
ffffffffc02036e2:	1141                	addi	sp,sp,-16
ffffffffc02036e4:	e406                	sd	ra,8(sp)
ffffffffc02036e6:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc02036e8:	e78d                	bnez	a5,ffffffffc0203712 <mm_destroy+0x32>
ffffffffc02036ea:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc02036ec:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc02036ee:	00a40c63          	beq	s0,a0,ffffffffc0203706 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc02036f2:	6118                	ld	a4,0(a0)
ffffffffc02036f4:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc02036f6:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc02036f8:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02036fa:	e398                	sd	a4,0(a5)
ffffffffc02036fc:	d1afe0ef          	jal	ffffffffc0201c16 <kfree>
    return listelm->next;
ffffffffc0203700:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0203702:	fea418e3          	bne	s0,a0,ffffffffc02036f2 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203706:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203708:	6402                	ld	s0,0(sp)
ffffffffc020370a:	60a2                	ld	ra,8(sp)
ffffffffc020370c:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc020370e:	d08fe06f          	j	ffffffffc0201c16 <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0203712:	00004697          	auipc	a3,0x4
ffffffffc0203716:	17668693          	addi	a3,a3,374 # ffffffffc0207888 <etext+0x1544>
ffffffffc020371a:	00003617          	auipc	a2,0x3
ffffffffc020371e:	5de60613          	addi	a2,a2,1502 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203722:	09e00593          	li	a1,158
ffffffffc0203726:	00004517          	auipc	a0,0x4
ffffffffc020372a:	0f250513          	addi	a0,a0,242 # ffffffffc0207818 <etext+0x14d4>
ffffffffc020372e:	d1dfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203732 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203732:	6785                	lui	a5,0x1
ffffffffc0203734:	17fd                	addi	a5,a5,-1 # fff <_binary_obj___user_softint_out_size-0x80e1>
ffffffffc0203736:	963e                	add	a2,a2,a5
    if (!USER_ACCESS(start, end))
ffffffffc0203738:	4785                	li	a5,1
{
ffffffffc020373a:	7139                	addi	sp,sp,-64
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc020373c:	962e                	add	a2,a2,a1
ffffffffc020373e:	787d                	lui	a6,0xfffff
    if (!USER_ACCESS(start, end))
ffffffffc0203740:	07fe                	slli	a5,a5,0x1f
{
ffffffffc0203742:	f822                	sd	s0,48(sp)
ffffffffc0203744:	f426                	sd	s1,40(sp)
ffffffffc0203746:	01067433          	and	s0,a2,a6
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc020374a:	0105f4b3          	and	s1,a1,a6
    if (!USER_ACCESS(start, end))
ffffffffc020374e:	0785                	addi	a5,a5,1
ffffffffc0203750:	0084b633          	sltu	a2,s1,s0
ffffffffc0203754:	00f437b3          	sltu	a5,s0,a5
ffffffffc0203758:	00163613          	seqz	a2,a2
ffffffffc020375c:	0017b793          	seqz	a5,a5
{
ffffffffc0203760:	fc06                	sd	ra,56(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0203762:	8fd1                	or	a5,a5,a2
ffffffffc0203764:	ebbd                	bnez	a5,ffffffffc02037da <mm_map+0xa8>
ffffffffc0203766:	002007b7          	lui	a5,0x200
ffffffffc020376a:	06f4e863          	bltu	s1,a5,ffffffffc02037da <mm_map+0xa8>
ffffffffc020376e:	f04a                	sd	s2,32(sp)
ffffffffc0203770:	ec4e                	sd	s3,24(sp)
ffffffffc0203772:	e852                	sd	s4,16(sp)
ffffffffc0203774:	892a                	mv	s2,a0
ffffffffc0203776:	89ba                	mv	s3,a4
ffffffffc0203778:	8a36                	mv	s4,a3
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc020377a:	c135                	beqz	a0,ffffffffc02037de <mm_map+0xac>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc020377c:	85a6                	mv	a1,s1
ffffffffc020377e:	e55ff0ef          	jal	ffffffffc02035d2 <find_vma>
ffffffffc0203782:	c501                	beqz	a0,ffffffffc020378a <mm_map+0x58>
ffffffffc0203784:	651c                	ld	a5,8(a0)
ffffffffc0203786:	0487e763          	bltu	a5,s0,ffffffffc02037d4 <mm_map+0xa2>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020378a:	03000513          	li	a0,48
ffffffffc020378e:	be2fe0ef          	jal	ffffffffc0201b70 <kmalloc>
ffffffffc0203792:	85aa                	mv	a1,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0203794:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203796:	c59d                	beqz	a1,ffffffffc02037c4 <mm_map+0x92>
        vma->vm_start = vm_start;
ffffffffc0203798:	e584                	sd	s1,8(a1)
        vma->vm_end = vm_end;
ffffffffc020379a:	e980                	sd	s0,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc020379c:	0145ac23          	sw	s4,24(a1)

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc02037a0:	854a                	mv	a0,s2
ffffffffc02037a2:	e42e                	sd	a1,8(sp)
ffffffffc02037a4:	e6fff0ef          	jal	ffffffffc0203612 <insert_vma_struct>
    if (vma_store != NULL)
ffffffffc02037a8:	65a2                	ld	a1,8(sp)
ffffffffc02037aa:	00098463          	beqz	s3,ffffffffc02037b2 <mm_map+0x80>
    {
        *vma_store = vma;
ffffffffc02037ae:	00b9b023          	sd	a1,0(s3)
ffffffffc02037b2:	7902                	ld	s2,32(sp)
ffffffffc02037b4:	69e2                	ld	s3,24(sp)
ffffffffc02037b6:	6a42                	ld	s4,16(sp)
    }
    ret = 0;
ffffffffc02037b8:	4501                	li	a0,0

out:
    return ret;
}
ffffffffc02037ba:	70e2                	ld	ra,56(sp)
ffffffffc02037bc:	7442                	ld	s0,48(sp)
ffffffffc02037be:	74a2                	ld	s1,40(sp)
ffffffffc02037c0:	6121                	addi	sp,sp,64
ffffffffc02037c2:	8082                	ret
ffffffffc02037c4:	70e2                	ld	ra,56(sp)
ffffffffc02037c6:	7442                	ld	s0,48(sp)
ffffffffc02037c8:	7902                	ld	s2,32(sp)
ffffffffc02037ca:	69e2                	ld	s3,24(sp)
ffffffffc02037cc:	6a42                	ld	s4,16(sp)
ffffffffc02037ce:	74a2                	ld	s1,40(sp)
ffffffffc02037d0:	6121                	addi	sp,sp,64
ffffffffc02037d2:	8082                	ret
ffffffffc02037d4:	7902                	ld	s2,32(sp)
ffffffffc02037d6:	69e2                	ld	s3,24(sp)
ffffffffc02037d8:	6a42                	ld	s4,16(sp)
        return -E_INVAL;
ffffffffc02037da:	5575                	li	a0,-3
ffffffffc02037dc:	bff9                	j	ffffffffc02037ba <mm_map+0x88>
    assert(mm != NULL);
ffffffffc02037de:	00004697          	auipc	a3,0x4
ffffffffc02037e2:	0c268693          	addi	a3,a3,194 # ffffffffc02078a0 <etext+0x155c>
ffffffffc02037e6:	00003617          	auipc	a2,0x3
ffffffffc02037ea:	51260613          	addi	a2,a2,1298 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02037ee:	0b300593          	li	a1,179
ffffffffc02037f2:	00004517          	auipc	a0,0x4
ffffffffc02037f6:	02650513          	addi	a0,a0,38 # ffffffffc0207818 <etext+0x14d4>
ffffffffc02037fa:	c51fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02037fe <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc02037fe:	7139                	addi	sp,sp,-64
ffffffffc0203800:	fc06                	sd	ra,56(sp)
ffffffffc0203802:	f822                	sd	s0,48(sp)
ffffffffc0203804:	f426                	sd	s1,40(sp)
ffffffffc0203806:	f04a                	sd	s2,32(sp)
ffffffffc0203808:	ec4e                	sd	s3,24(sp)
ffffffffc020380a:	e852                	sd	s4,16(sp)
ffffffffc020380c:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc020380e:	c525                	beqz	a0,ffffffffc0203876 <dup_mmap+0x78>
ffffffffc0203810:	892a                	mv	s2,a0
ffffffffc0203812:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203814:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203816:	c1a5                	beqz	a1,ffffffffc0203876 <dup_mmap+0x78>
    return listelm->prev;
ffffffffc0203818:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc020381a:	04848c63          	beq	s1,s0,ffffffffc0203872 <dup_mmap+0x74>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020381e:	03000513          	li	a0,48
    {
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203822:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203826:	ff043a03          	ld	s4,-16(s0)
ffffffffc020382a:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020382e:	b42fe0ef          	jal	ffffffffc0201b70 <kmalloc>
    if (vma != NULL)
ffffffffc0203832:	c515                	beqz	a0,ffffffffc020385e <dup_mmap+0x60>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0203834:	85aa                	mv	a1,a0
        vma->vm_start = vm_start;
ffffffffc0203836:	01553423          	sd	s5,8(a0)
ffffffffc020383a:	01453823          	sd	s4,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc020383e:	01352c23          	sw	s3,24(a0)
        insert_vma_struct(to, nvma);
ffffffffc0203842:	854a                	mv	a0,s2
ffffffffc0203844:	dcfff0ef          	jal	ffffffffc0203612 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203848:	ff043683          	ld	a3,-16(s0)
ffffffffc020384c:	fe843603          	ld	a2,-24(s0)
ffffffffc0203850:	6c8c                	ld	a1,24(s1)
ffffffffc0203852:	01893503          	ld	a0,24(s2)
ffffffffc0203856:	4701                	li	a4,0
ffffffffc0203858:	9f9ff0ef          	jal	ffffffffc0203250 <copy_range>
ffffffffc020385c:	dd55                	beqz	a0,ffffffffc0203818 <dup_mmap+0x1a>
            return -E_NO_MEM;
ffffffffc020385e:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203860:	70e2                	ld	ra,56(sp)
ffffffffc0203862:	7442                	ld	s0,48(sp)
ffffffffc0203864:	74a2                	ld	s1,40(sp)
ffffffffc0203866:	7902                	ld	s2,32(sp)
ffffffffc0203868:	69e2                	ld	s3,24(sp)
ffffffffc020386a:	6a42                	ld	s4,16(sp)
ffffffffc020386c:	6aa2                	ld	s5,8(sp)
ffffffffc020386e:	6121                	addi	sp,sp,64
ffffffffc0203870:	8082                	ret
    return 0;
ffffffffc0203872:	4501                	li	a0,0
ffffffffc0203874:	b7f5                	j	ffffffffc0203860 <dup_mmap+0x62>
    assert(to != NULL && from != NULL);
ffffffffc0203876:	00004697          	auipc	a3,0x4
ffffffffc020387a:	03a68693          	addi	a3,a3,58 # ffffffffc02078b0 <etext+0x156c>
ffffffffc020387e:	00003617          	auipc	a2,0x3
ffffffffc0203882:	47a60613          	addi	a2,a2,1146 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203886:	0cf00593          	li	a1,207
ffffffffc020388a:	00004517          	auipc	a0,0x4
ffffffffc020388e:	f8e50513          	addi	a0,a0,-114 # ffffffffc0207818 <etext+0x14d4>
ffffffffc0203892:	bb9fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203896 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203896:	1101                	addi	sp,sp,-32
ffffffffc0203898:	ec06                	sd	ra,24(sp)
ffffffffc020389a:	e822                	sd	s0,16(sp)
ffffffffc020389c:	e426                	sd	s1,8(sp)
ffffffffc020389e:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02038a0:	c531                	beqz	a0,ffffffffc02038ec <exit_mmap+0x56>
ffffffffc02038a2:	591c                	lw	a5,48(a0)
ffffffffc02038a4:	84aa                	mv	s1,a0
ffffffffc02038a6:	e3b9                	bnez	a5,ffffffffc02038ec <exit_mmap+0x56>
    return listelm->next;
ffffffffc02038a8:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc02038aa:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc02038ae:	02850663          	beq	a0,s0,ffffffffc02038da <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02038b2:	ff043603          	ld	a2,-16(s0)
ffffffffc02038b6:	fe843583          	ld	a1,-24(s0)
ffffffffc02038ba:	854a                	mv	a0,s2
ffffffffc02038bc:	fd0fe0ef          	jal	ffffffffc020208c <unmap_range>
ffffffffc02038c0:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02038c2:	fe8498e3          	bne	s1,s0,ffffffffc02038b2 <exit_mmap+0x1c>
ffffffffc02038c6:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc02038c8:	00848c63          	beq	s1,s0,ffffffffc02038e0 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02038cc:	ff043603          	ld	a2,-16(s0)
ffffffffc02038d0:	fe843583          	ld	a1,-24(s0)
ffffffffc02038d4:	854a                	mv	a0,s2
ffffffffc02038d6:	8ebfe0ef          	jal	ffffffffc02021c0 <exit_range>
ffffffffc02038da:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02038dc:	fe8498e3          	bne	s1,s0,ffffffffc02038cc <exit_mmap+0x36>
    }
}
ffffffffc02038e0:	60e2                	ld	ra,24(sp)
ffffffffc02038e2:	6442                	ld	s0,16(sp)
ffffffffc02038e4:	64a2                	ld	s1,8(sp)
ffffffffc02038e6:	6902                	ld	s2,0(sp)
ffffffffc02038e8:	6105                	addi	sp,sp,32
ffffffffc02038ea:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02038ec:	00004697          	auipc	a3,0x4
ffffffffc02038f0:	fe468693          	addi	a3,a3,-28 # ffffffffc02078d0 <etext+0x158c>
ffffffffc02038f4:	00003617          	auipc	a2,0x3
ffffffffc02038f8:	40460613          	addi	a2,a2,1028 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02038fc:	0e800593          	li	a1,232
ffffffffc0203900:	00004517          	auipc	a0,0x4
ffffffffc0203904:	f1850513          	addi	a0,a0,-232 # ffffffffc0207818 <etext+0x14d4>
ffffffffc0203908:	b43fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020390c <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc020390c:	7179                	addi	sp,sp,-48
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc020390e:	05800513          	li	a0,88
{
ffffffffc0203912:	f406                	sd	ra,40(sp)
ffffffffc0203914:	f022                	sd	s0,32(sp)
ffffffffc0203916:	ec26                	sd	s1,24(sp)
ffffffffc0203918:	e84a                	sd	s2,16(sp)
ffffffffc020391a:	e44e                	sd	s3,8(sp)
ffffffffc020391c:	e052                	sd	s4,0(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc020391e:	a52fe0ef          	jal	ffffffffc0201b70 <kmalloc>
    if (mm != NULL)
ffffffffc0203922:	16050f63          	beqz	a0,ffffffffc0203aa0 <vmm_init+0x194>
    elm->prev = elm->next = elm;
ffffffffc0203926:	e508                	sd	a0,8(a0)
ffffffffc0203928:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc020392a:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc020392e:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203932:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203936:	02053423          	sd	zero,40(a0)
ffffffffc020393a:	02052823          	sw	zero,48(a0)
        sem_init(&(mm->mm_sem), 1);
ffffffffc020393e:	842a                	mv	s0,a0
ffffffffc0203940:	4585                	li	a1,1
ffffffffc0203942:	03850513          	addi	a0,a0,56
ffffffffc0203946:	40d000ef          	jal	ffffffffc0204552 <sem_init>
ffffffffc020394a:	03200493          	li	s1,50
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020394e:	03000513          	li	a0,48
ffffffffc0203952:	a1efe0ef          	jal	ffffffffc0201b70 <kmalloc>
    if (vma != NULL)
ffffffffc0203956:	12050563          	beqz	a0,ffffffffc0203a80 <vmm_init+0x174>
        vma->vm_end = vm_end;
ffffffffc020395a:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc020395e:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203960:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0203964:	e91c                	sd	a5,16(a0)
    int i;
    for (i = step1; i >= 1; i--)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203966:	85aa                	mv	a1,a0
    for (i = step1; i >= 1; i--)
ffffffffc0203968:	14ed                	addi	s1,s1,-5
        insert_vma_struct(mm, vma);
ffffffffc020396a:	8522                	mv	a0,s0
ffffffffc020396c:	ca7ff0ef          	jal	ffffffffc0203612 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203970:	fcf9                	bnez	s1,ffffffffc020394e <vmm_init+0x42>
ffffffffc0203972:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203976:	1f900913          	li	s2,505
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020397a:	03000513          	li	a0,48
ffffffffc020397e:	9f2fe0ef          	jal	ffffffffc0201b70 <kmalloc>
    if (vma != NULL)
ffffffffc0203982:	12050f63          	beqz	a0,ffffffffc0203ac0 <vmm_init+0x1b4>
        vma->vm_end = vm_end;
ffffffffc0203986:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc020398a:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc020398c:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0203990:	e91c                	sd	a5,16(a0)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203992:	85aa                	mv	a1,a0
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203994:	0495                	addi	s1,s1,5
        insert_vma_struct(mm, vma);
ffffffffc0203996:	8522                	mv	a0,s0
ffffffffc0203998:	c7bff0ef          	jal	ffffffffc0203612 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc020399c:	fd249fe3          	bne	s1,s2,ffffffffc020397a <vmm_init+0x6e>
    return listelm->next;
ffffffffc02039a0:	641c                	ld	a5,8(s0)
ffffffffc02039a2:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc02039a4:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc02039a8:	1ef40c63          	beq	s0,a5,ffffffffc0203ba0 <vmm_init+0x294>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc02039ac:	fe87b603          	ld	a2,-24(a5) # 1fffe8 <_binary_obj___user_matrix_out_size+0x1f4900>
ffffffffc02039b0:	ffe70693          	addi	a3,a4,-2
ffffffffc02039b4:	12d61663          	bne	a2,a3,ffffffffc0203ae0 <vmm_init+0x1d4>
ffffffffc02039b8:	ff07b683          	ld	a3,-16(a5)
ffffffffc02039bc:	12e69263          	bne	a3,a4,ffffffffc0203ae0 <vmm_init+0x1d4>
    for (i = 1; i <= step2; i++)
ffffffffc02039c0:	0715                	addi	a4,a4,5
ffffffffc02039c2:	679c                	ld	a5,8(a5)
ffffffffc02039c4:	feb712e3          	bne	a4,a1,ffffffffc02039a8 <vmm_init+0x9c>
ffffffffc02039c8:	491d                	li	s2,7
ffffffffc02039ca:	4495                	li	s1,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc02039cc:	85a6                	mv	a1,s1
ffffffffc02039ce:	8522                	mv	a0,s0
ffffffffc02039d0:	c03ff0ef          	jal	ffffffffc02035d2 <find_vma>
ffffffffc02039d4:	8a2a                	mv	s4,a0
        assert(vma1 != NULL);
ffffffffc02039d6:	20050563          	beqz	a0,ffffffffc0203be0 <vmm_init+0x2d4>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc02039da:	00148593          	addi	a1,s1,1
ffffffffc02039de:	8522                	mv	a0,s0
ffffffffc02039e0:	bf3ff0ef          	jal	ffffffffc02035d2 <find_vma>
ffffffffc02039e4:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc02039e6:	1c050d63          	beqz	a0,ffffffffc0203bc0 <vmm_init+0x2b4>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc02039ea:	85ca                	mv	a1,s2
ffffffffc02039ec:	8522                	mv	a0,s0
ffffffffc02039ee:	be5ff0ef          	jal	ffffffffc02035d2 <find_vma>
        assert(vma3 == NULL);
ffffffffc02039f2:	18051763          	bnez	a0,ffffffffc0203b80 <vmm_init+0x274>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc02039f6:	00348593          	addi	a1,s1,3
ffffffffc02039fa:	8522                	mv	a0,s0
ffffffffc02039fc:	bd7ff0ef          	jal	ffffffffc02035d2 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203a00:	16051063          	bnez	a0,ffffffffc0203b60 <vmm_init+0x254>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203a04:	00448593          	addi	a1,s1,4
ffffffffc0203a08:	8522                	mv	a0,s0
ffffffffc0203a0a:	bc9ff0ef          	jal	ffffffffc02035d2 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203a0e:	12051963          	bnez	a0,ffffffffc0203b40 <vmm_init+0x234>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203a12:	008a3783          	ld	a5,8(s4)
ffffffffc0203a16:	10979563          	bne	a5,s1,ffffffffc0203b20 <vmm_init+0x214>
ffffffffc0203a1a:	010a3783          	ld	a5,16(s4)
ffffffffc0203a1e:	11279163          	bne	a5,s2,ffffffffc0203b20 <vmm_init+0x214>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203a22:	0089b783          	ld	a5,8(s3)
ffffffffc0203a26:	0c979d63          	bne	a5,s1,ffffffffc0203b00 <vmm_init+0x1f4>
ffffffffc0203a2a:	0109b783          	ld	a5,16(s3)
ffffffffc0203a2e:	0d279963          	bne	a5,s2,ffffffffc0203b00 <vmm_init+0x1f4>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203a32:	0495                	addi	s1,s1,5
ffffffffc0203a34:	1f900793          	li	a5,505
ffffffffc0203a38:	0915                	addi	s2,s2,5
ffffffffc0203a3a:	f8f499e3          	bne	s1,a5,ffffffffc02039cc <vmm_init+0xc0>
ffffffffc0203a3e:	4491                	li	s1,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203a40:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203a42:	85a6                	mv	a1,s1
ffffffffc0203a44:	8522                	mv	a0,s0
ffffffffc0203a46:	b8dff0ef          	jal	ffffffffc02035d2 <find_vma>
        if (vma_below_5 != NULL)
ffffffffc0203a4a:	1a051b63          	bnez	a0,ffffffffc0203c00 <vmm_init+0x2f4>
    for (i = 4; i >= 0; i--)
ffffffffc0203a4e:	14fd                	addi	s1,s1,-1
ffffffffc0203a50:	ff2499e3          	bne	s1,s2,ffffffffc0203a42 <vmm_init+0x136>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
ffffffffc0203a54:	8522                	mv	a0,s0
ffffffffc0203a56:	c8bff0ef          	jal	ffffffffc02036e0 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203a5a:	00004517          	auipc	a0,0x4
ffffffffc0203a5e:	fe650513          	addi	a0,a0,-26 # ffffffffc0207a40 <etext+0x16fc>
ffffffffc0203a62:	f36fc0ef          	jal	ffffffffc0200198 <cprintf>
}
ffffffffc0203a66:	7402                	ld	s0,32(sp)
ffffffffc0203a68:	70a2                	ld	ra,40(sp)
ffffffffc0203a6a:	64e2                	ld	s1,24(sp)
ffffffffc0203a6c:	6942                	ld	s2,16(sp)
ffffffffc0203a6e:	69a2                	ld	s3,8(sp)
ffffffffc0203a70:	6a02                	ld	s4,0(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203a72:	00004517          	auipc	a0,0x4
ffffffffc0203a76:	fee50513          	addi	a0,a0,-18 # ffffffffc0207a60 <etext+0x171c>
}
ffffffffc0203a7a:	6145                	addi	sp,sp,48
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203a7c:	f1cfc06f          	j	ffffffffc0200198 <cprintf>
        assert(vma != NULL);
ffffffffc0203a80:	00004697          	auipc	a3,0x4
ffffffffc0203a84:	e7068693          	addi	a3,a3,-400 # ffffffffc02078f0 <etext+0x15ac>
ffffffffc0203a88:	00003617          	auipc	a2,0x3
ffffffffc0203a8c:	27060613          	addi	a2,a2,624 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203a90:	12c00593          	li	a1,300
ffffffffc0203a94:	00004517          	auipc	a0,0x4
ffffffffc0203a98:	d8450513          	addi	a0,a0,-636 # ffffffffc0207818 <etext+0x14d4>
ffffffffc0203a9c:	9affc0ef          	jal	ffffffffc020044a <__panic>
    assert(mm != NULL);
ffffffffc0203aa0:	00004697          	auipc	a3,0x4
ffffffffc0203aa4:	e0068693          	addi	a3,a3,-512 # ffffffffc02078a0 <etext+0x155c>
ffffffffc0203aa8:	00003617          	auipc	a2,0x3
ffffffffc0203aac:	25060613          	addi	a2,a2,592 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203ab0:	12400593          	li	a1,292
ffffffffc0203ab4:	00004517          	auipc	a0,0x4
ffffffffc0203ab8:	d6450513          	addi	a0,a0,-668 # ffffffffc0207818 <etext+0x14d4>
ffffffffc0203abc:	98ffc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma != NULL);
ffffffffc0203ac0:	00004697          	auipc	a3,0x4
ffffffffc0203ac4:	e3068693          	addi	a3,a3,-464 # ffffffffc02078f0 <etext+0x15ac>
ffffffffc0203ac8:	00003617          	auipc	a2,0x3
ffffffffc0203acc:	23060613          	addi	a2,a2,560 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203ad0:	13300593          	li	a1,307
ffffffffc0203ad4:	00004517          	auipc	a0,0x4
ffffffffc0203ad8:	d4450513          	addi	a0,a0,-700 # ffffffffc0207818 <etext+0x14d4>
ffffffffc0203adc:	96ffc0ef          	jal	ffffffffc020044a <__panic>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203ae0:	00004697          	auipc	a3,0x4
ffffffffc0203ae4:	e3868693          	addi	a3,a3,-456 # ffffffffc0207918 <etext+0x15d4>
ffffffffc0203ae8:	00003617          	auipc	a2,0x3
ffffffffc0203aec:	21060613          	addi	a2,a2,528 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203af0:	13d00593          	li	a1,317
ffffffffc0203af4:	00004517          	auipc	a0,0x4
ffffffffc0203af8:	d2450513          	addi	a0,a0,-732 # ffffffffc0207818 <etext+0x14d4>
ffffffffc0203afc:	94ffc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203b00:	00004697          	auipc	a3,0x4
ffffffffc0203b04:	ed068693          	addi	a3,a3,-304 # ffffffffc02079d0 <etext+0x168c>
ffffffffc0203b08:	00003617          	auipc	a2,0x3
ffffffffc0203b0c:	1f060613          	addi	a2,a2,496 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203b10:	14f00593          	li	a1,335
ffffffffc0203b14:	00004517          	auipc	a0,0x4
ffffffffc0203b18:	d0450513          	addi	a0,a0,-764 # ffffffffc0207818 <etext+0x14d4>
ffffffffc0203b1c:	92ffc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203b20:	00004697          	auipc	a3,0x4
ffffffffc0203b24:	e8068693          	addi	a3,a3,-384 # ffffffffc02079a0 <etext+0x165c>
ffffffffc0203b28:	00003617          	auipc	a2,0x3
ffffffffc0203b2c:	1d060613          	addi	a2,a2,464 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203b30:	14e00593          	li	a1,334
ffffffffc0203b34:	00004517          	auipc	a0,0x4
ffffffffc0203b38:	ce450513          	addi	a0,a0,-796 # ffffffffc0207818 <etext+0x14d4>
ffffffffc0203b3c:	90ffc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma5 == NULL);
ffffffffc0203b40:	00004697          	auipc	a3,0x4
ffffffffc0203b44:	e5068693          	addi	a3,a3,-432 # ffffffffc0207990 <etext+0x164c>
ffffffffc0203b48:	00003617          	auipc	a2,0x3
ffffffffc0203b4c:	1b060613          	addi	a2,a2,432 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203b50:	14c00593          	li	a1,332
ffffffffc0203b54:	00004517          	auipc	a0,0x4
ffffffffc0203b58:	cc450513          	addi	a0,a0,-828 # ffffffffc0207818 <etext+0x14d4>
ffffffffc0203b5c:	8effc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma4 == NULL);
ffffffffc0203b60:	00004697          	auipc	a3,0x4
ffffffffc0203b64:	e2068693          	addi	a3,a3,-480 # ffffffffc0207980 <etext+0x163c>
ffffffffc0203b68:	00003617          	auipc	a2,0x3
ffffffffc0203b6c:	19060613          	addi	a2,a2,400 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203b70:	14a00593          	li	a1,330
ffffffffc0203b74:	00004517          	auipc	a0,0x4
ffffffffc0203b78:	ca450513          	addi	a0,a0,-860 # ffffffffc0207818 <etext+0x14d4>
ffffffffc0203b7c:	8cffc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma3 == NULL);
ffffffffc0203b80:	00004697          	auipc	a3,0x4
ffffffffc0203b84:	df068693          	addi	a3,a3,-528 # ffffffffc0207970 <etext+0x162c>
ffffffffc0203b88:	00003617          	auipc	a2,0x3
ffffffffc0203b8c:	17060613          	addi	a2,a2,368 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203b90:	14800593          	li	a1,328
ffffffffc0203b94:	00004517          	auipc	a0,0x4
ffffffffc0203b98:	c8450513          	addi	a0,a0,-892 # ffffffffc0207818 <etext+0x14d4>
ffffffffc0203b9c:	8affc0ef          	jal	ffffffffc020044a <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203ba0:	00004697          	auipc	a3,0x4
ffffffffc0203ba4:	d6068693          	addi	a3,a3,-672 # ffffffffc0207900 <etext+0x15bc>
ffffffffc0203ba8:	00003617          	auipc	a2,0x3
ffffffffc0203bac:	15060613          	addi	a2,a2,336 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203bb0:	13b00593          	li	a1,315
ffffffffc0203bb4:	00004517          	auipc	a0,0x4
ffffffffc0203bb8:	c6450513          	addi	a0,a0,-924 # ffffffffc0207818 <etext+0x14d4>
ffffffffc0203bbc:	88ffc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma2 != NULL);
ffffffffc0203bc0:	00004697          	auipc	a3,0x4
ffffffffc0203bc4:	da068693          	addi	a3,a3,-608 # ffffffffc0207960 <etext+0x161c>
ffffffffc0203bc8:	00003617          	auipc	a2,0x3
ffffffffc0203bcc:	13060613          	addi	a2,a2,304 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203bd0:	14600593          	li	a1,326
ffffffffc0203bd4:	00004517          	auipc	a0,0x4
ffffffffc0203bd8:	c4450513          	addi	a0,a0,-956 # ffffffffc0207818 <etext+0x14d4>
ffffffffc0203bdc:	86ffc0ef          	jal	ffffffffc020044a <__panic>
        assert(vma1 != NULL);
ffffffffc0203be0:	00004697          	auipc	a3,0x4
ffffffffc0203be4:	d7068693          	addi	a3,a3,-656 # ffffffffc0207950 <etext+0x160c>
ffffffffc0203be8:	00003617          	auipc	a2,0x3
ffffffffc0203bec:	11060613          	addi	a2,a2,272 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203bf0:	14400593          	li	a1,324
ffffffffc0203bf4:	00004517          	auipc	a0,0x4
ffffffffc0203bf8:	c2450513          	addi	a0,a0,-988 # ffffffffc0207818 <etext+0x14d4>
ffffffffc0203bfc:	84ffc0ef          	jal	ffffffffc020044a <__panic>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203c00:	6914                	ld	a3,16(a0)
ffffffffc0203c02:	6510                	ld	a2,8(a0)
ffffffffc0203c04:	0004859b          	sext.w	a1,s1
ffffffffc0203c08:	00004517          	auipc	a0,0x4
ffffffffc0203c0c:	df850513          	addi	a0,a0,-520 # ffffffffc0207a00 <etext+0x16bc>
ffffffffc0203c10:	d88fc0ef          	jal	ffffffffc0200198 <cprintf>
        assert(vma_below_5 == NULL);
ffffffffc0203c14:	00004697          	auipc	a3,0x4
ffffffffc0203c18:	e1468693          	addi	a3,a3,-492 # ffffffffc0207a28 <etext+0x16e4>
ffffffffc0203c1c:	00003617          	auipc	a2,0x3
ffffffffc0203c20:	0dc60613          	addi	a2,a2,220 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0203c24:	15900593          	li	a1,345
ffffffffc0203c28:	00004517          	auipc	a0,0x4
ffffffffc0203c2c:	bf050513          	addi	a0,a0,-1040 # ffffffffc0207818 <etext+0x14d4>
ffffffffc0203c30:	81bfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203c34 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203c34:	7179                	addi	sp,sp,-48
ffffffffc0203c36:	f022                	sd	s0,32(sp)
ffffffffc0203c38:	f406                	sd	ra,40(sp)
ffffffffc0203c3a:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203c3c:	c52d                	beqz	a0,ffffffffc0203ca6 <user_mem_check+0x72>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203c3e:	002007b7          	lui	a5,0x200
ffffffffc0203c42:	04f5ed63          	bltu	a1,a5,ffffffffc0203c9c <user_mem_check+0x68>
ffffffffc0203c46:	ec26                	sd	s1,24(sp)
ffffffffc0203c48:	00c584b3          	add	s1,a1,a2
ffffffffc0203c4c:	0695ff63          	bgeu	a1,s1,ffffffffc0203cca <user_mem_check+0x96>
ffffffffc0203c50:	4785                	li	a5,1
ffffffffc0203c52:	07fe                	slli	a5,a5,0x1f
ffffffffc0203c54:	0785                	addi	a5,a5,1 # 200001 <_binary_obj___user_matrix_out_size+0x1f4919>
ffffffffc0203c56:	06f4fa63          	bgeu	s1,a5,ffffffffc0203cca <user_mem_check+0x96>
ffffffffc0203c5a:	e84a                	sd	s2,16(sp)
ffffffffc0203c5c:	e44e                	sd	s3,8(sp)
ffffffffc0203c5e:	8936                	mv	s2,a3
ffffffffc0203c60:	89aa                	mv	s3,a0
ffffffffc0203c62:	a829                	j	ffffffffc0203c7c <user_mem_check+0x48>
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203c64:	6685                	lui	a3,0x1
ffffffffc0203c66:	9736                	add	a4,a4,a3
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203c68:	0027f693          	andi	a3,a5,2
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203c6c:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203c6e:	c685                	beqz	a3,ffffffffc0203c96 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203c70:	c399                	beqz	a5,ffffffffc0203c76 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203c72:	02e46263          	bltu	s0,a4,ffffffffc0203c96 <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203c76:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203c78:	04947b63          	bgeu	s0,s1,ffffffffc0203cce <user_mem_check+0x9a>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203c7c:	85a2                	mv	a1,s0
ffffffffc0203c7e:	854e                	mv	a0,s3
ffffffffc0203c80:	953ff0ef          	jal	ffffffffc02035d2 <find_vma>
ffffffffc0203c84:	c909                	beqz	a0,ffffffffc0203c96 <user_mem_check+0x62>
ffffffffc0203c86:	6518                	ld	a4,8(a0)
ffffffffc0203c88:	00e46763          	bltu	s0,a4,ffffffffc0203c96 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203c8c:	4d1c                	lw	a5,24(a0)
ffffffffc0203c8e:	fc091be3          	bnez	s2,ffffffffc0203c64 <user_mem_check+0x30>
ffffffffc0203c92:	8b85                	andi	a5,a5,1
ffffffffc0203c94:	f3ed                	bnez	a5,ffffffffc0203c76 <user_mem_check+0x42>
ffffffffc0203c96:	64e2                	ld	s1,24(sp)
ffffffffc0203c98:	6942                	ld	s2,16(sp)
ffffffffc0203c9a:	69a2                	ld	s3,8(sp)
            return 0;
ffffffffc0203c9c:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc0203c9e:	70a2                	ld	ra,40(sp)
ffffffffc0203ca0:	7402                	ld	s0,32(sp)
ffffffffc0203ca2:	6145                	addi	sp,sp,48
ffffffffc0203ca4:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203ca6:	c02007b7          	lui	a5,0xc0200
ffffffffc0203caa:	fef5eae3          	bltu	a1,a5,ffffffffc0203c9e <user_mem_check+0x6a>
ffffffffc0203cae:	c80007b7          	lui	a5,0xc8000
ffffffffc0203cb2:	962e                	add	a2,a2,a1
ffffffffc0203cb4:	0785                	addi	a5,a5,1 # ffffffffc8000001 <end+0x7d33d39>
ffffffffc0203cb6:	00c5b433          	sltu	s0,a1,a2
ffffffffc0203cba:	00f63633          	sltu	a2,a2,a5
}
ffffffffc0203cbe:	70a2                	ld	ra,40(sp)
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203cc0:	00867533          	and	a0,a2,s0
}
ffffffffc0203cc4:	7402                	ld	s0,32(sp)
ffffffffc0203cc6:	6145                	addi	sp,sp,48
ffffffffc0203cc8:	8082                	ret
ffffffffc0203cca:	64e2                	ld	s1,24(sp)
ffffffffc0203ccc:	bfc1                	j	ffffffffc0203c9c <user_mem_check+0x68>
ffffffffc0203cce:	64e2                	ld	s1,24(sp)
ffffffffc0203cd0:	6942                	ld	s2,16(sp)
ffffffffc0203cd2:	69a2                	ld	s3,8(sp)
        return 1;
ffffffffc0203cd4:	4505                	li	a0,1
ffffffffc0203cd6:	b7e1                	j	ffffffffc0203c9e <user_mem_check+0x6a>

ffffffffc0203cd8 <phi_test_sema>:

struct proc_struct *philosopher_proc_sema[N];

void phi_test_sema(int i) /* i：哲学家号码从0到N-1 */
{ 
    if(state_sema[i]==HUNGRY&&state_sema[LEFT]!=EATING
ffffffffc0203cd8:	00251793          	slli	a5,a0,0x2
ffffffffc0203cdc:	000c4617          	auipc	a2,0xc4
ffffffffc0203ce0:	50c60613          	addi	a2,a2,1292 # ffffffffc02c81e8 <state_sema>
ffffffffc0203ce4:	97b2                	add	a5,a5,a2
ffffffffc0203ce6:	4394                	lw	a3,0(a5)
ffffffffc0203ce8:	4705                	li	a4,1
ffffffffc0203cea:	00e68363          	beq	a3,a4,ffffffffc0203cf0 <phi_test_sema+0x18>
            &&state_sema[RIGHT]!=EATING)
    {
        state_sema[i]=EATING;
        up(&s[i]);
    }
}
ffffffffc0203cee:	8082                	ret
    if(state_sema[i]==HUNGRY&&state_sema[LEFT]!=EATING
ffffffffc0203cf0:	666666b7          	lui	a3,0x66666
ffffffffc0203cf4:	0045071b          	addiw	a4,a0,4
ffffffffc0203cf8:	66768693          	addi	a3,a3,1639 # 66666667 <_binary_obj___user_matrix_out_size+0x6665af7f>
ffffffffc0203cfc:	02d705b3          	mul	a1,a4,a3
ffffffffc0203d00:	41f7581b          	sraiw	a6,a4,0x1f
ffffffffc0203d04:	4889                	li	a7,2
ffffffffc0203d06:	9585                	srai	a1,a1,0x21
ffffffffc0203d08:	410585bb          	subw	a1,a1,a6
ffffffffc0203d0c:	0025981b          	slliw	a6,a1,0x2
ffffffffc0203d10:	00b805bb          	addw	a1,a6,a1
ffffffffc0203d14:	9f0d                	subw	a4,a4,a1
ffffffffc0203d16:	070a                	slli	a4,a4,0x2
ffffffffc0203d18:	9732                	add	a4,a4,a2
ffffffffc0203d1a:	4318                	lw	a4,0(a4)
ffffffffc0203d1c:	fd1709e3          	beq	a4,a7,ffffffffc0203cee <phi_test_sema+0x16>
            &&state_sema[RIGHT]!=EATING)
ffffffffc0203d20:	0015071b          	addiw	a4,a0,1
ffffffffc0203d24:	02d706b3          	mul	a3,a4,a3
ffffffffc0203d28:	41f7559b          	sraiw	a1,a4,0x1f
ffffffffc0203d2c:	9685                	srai	a3,a3,0x21
ffffffffc0203d2e:	9e8d                	subw	a3,a3,a1
ffffffffc0203d30:	0026959b          	slliw	a1,a3,0x2
ffffffffc0203d34:	9ead                	addw	a3,a3,a1
ffffffffc0203d36:	9f15                	subw	a4,a4,a3
ffffffffc0203d38:	070a                	slli	a4,a4,0x2
ffffffffc0203d3a:	963a                	add	a2,a2,a4
ffffffffc0203d3c:	4218                	lw	a4,0(a2)
ffffffffc0203d3e:	fb1708e3          	beq	a4,a7,ffffffffc0203cee <phi_test_sema+0x16>
        up(&s[i]);
ffffffffc0203d42:	00151713          	slli	a4,a0,0x1
ffffffffc0203d46:	972a                	add	a4,a4,a0
ffffffffc0203d48:	070e                	slli	a4,a4,0x3
ffffffffc0203d4a:	000c4517          	auipc	a0,0xc4
ffffffffc0203d4e:	40e50513          	addi	a0,a0,1038 # ffffffffc02c8158 <s>
ffffffffc0203d52:	953a                	add	a0,a0,a4
        state_sema[i]=EATING;
ffffffffc0203d54:	0117a023          	sw	a7,0(a5)
        up(&s[i]);
ffffffffc0203d58:	0010006f          	j	ffffffffc0204558 <up>

ffffffffc0203d5c <philosopher_using_semaphore>:
        phi_test_sema(RIGHT); /* 看一下右邻居现在是否能进餐 */
        up(&mutex); /* 离开临界区 */
}

int philosopher_using_semaphore(void * arg) /* i：哲学家号码，从0到N-1 */
{
ffffffffc0203d5c:	715d                	addi	sp,sp,-80
ffffffffc0203d5e:	e0a2                	sd	s0,64(sp)
    int i, iter=0;
    i=(int)arg;
ffffffffc0203d60:	0005041b          	sext.w	s0,a0
    cprintf("I am No.%d philosopher_sema\n",i);
ffffffffc0203d64:	85a2                	mv	a1,s0
ffffffffc0203d66:	00004517          	auipc	a0,0x4
ffffffffc0203d6a:	d1250513          	addi	a0,a0,-750 # ffffffffc0207a78 <etext+0x1734>
{
ffffffffc0203d6e:	fc26                	sd	s1,56(sp)
ffffffffc0203d70:	f84a                	sd	s2,48(sp)
ffffffffc0203d72:	f44e                	sd	s3,40(sp)
ffffffffc0203d74:	f052                	sd	s4,32(sp)
ffffffffc0203d76:	ec56                	sd	s5,24(sp)
ffffffffc0203d78:	e85a                	sd	s6,16(sp)
ffffffffc0203d7a:	e45e                	sd	s7,8(sp)
ffffffffc0203d7c:	e486                	sd	ra,72(sp)
    cprintf("I am No.%d philosopher_sema\n",i);
ffffffffc0203d7e:	c1afc0ef          	jal	ffffffffc0200198 <cprintf>
        phi_test_sema(LEFT); /* 看一下左邻居现在是否能进餐 */
ffffffffc0203d82:	666667b7          	lui	a5,0x66666
ffffffffc0203d86:	00440a9b          	addiw	s5,s0,4
ffffffffc0203d8a:	66778793          	addi	a5,a5,1639 # 66666667 <_binary_obj___user_matrix_out_size+0x6665af7f>
ffffffffc0203d8e:	02fa8733          	mul	a4,s5,a5
        phi_test_sema(RIGHT); /* 看一下右邻居现在是否能进餐 */
ffffffffc0203d92:	00140a1b          	addiw	s4,s0,1
        phi_test_sema(LEFT); /* 看一下左邻居现在是否能进餐 */
ffffffffc0203d96:	41fad69b          	sraiw	a3,s5,0x1f
        phi_test_sema(RIGHT); /* 看一下右邻居现在是否能进餐 */
ffffffffc0203d9a:	41fa561b          	sraiw	a2,s4,0x1f
        down(&s[i]); /* 如果得不到叉子就阻塞 */
ffffffffc0203d9e:	00141993          	slli	s3,s0,0x1
ffffffffc0203da2:	99a2                	add	s3,s3,s0
ffffffffc0203da4:	098e                	slli	s3,s3,0x3
ffffffffc0203da6:	000c4517          	auipc	a0,0xc4
ffffffffc0203daa:	3b250513          	addi	a0,a0,946 # ffffffffc02c8158 <s>
ffffffffc0203dae:	00241593          	slli	a1,s0,0x2
ffffffffc0203db2:	000c4917          	auipc	s2,0xc4
ffffffffc0203db6:	43690913          	addi	s2,s2,1078 # ffffffffc02c81e8 <state_sema>
        phi_test_sema(RIGHT); /* 看一下右邻居现在是否能进餐 */
ffffffffc0203dba:	02fa07b3          	mul	a5,s4,a5
        phi_test_sema(LEFT); /* 看一下左邻居现在是否能进餐 */
ffffffffc0203dbe:	9705                	srai	a4,a4,0x21
ffffffffc0203dc0:	9f15                	subw	a4,a4,a3
ffffffffc0203dc2:	0027169b          	slliw	a3,a4,0x2
ffffffffc0203dc6:	9f35                	addw	a4,a4,a3
ffffffffc0203dc8:	40ea8abb          	subw	s5,s5,a4
    while(iter++<TIMES)
ffffffffc0203dcc:	4485                	li	s1,1
        down(&s[i]); /* 如果得不到叉子就阻塞 */
ffffffffc0203dce:	99aa                	add	s3,s3,a0
        state_sema[i]=HUNGRY; /* 记录下哲学家i饥饿的事实 */
ffffffffc0203dd0:	992e                	add	s2,s2,a1
ffffffffc0203dd2:	8ba6                	mv	s7,s1
        phi_test_sema(RIGHT); /* 看一下右邻居现在是否能进餐 */
ffffffffc0203dd4:	9785                	srai	a5,a5,0x21
ffffffffc0203dd6:	9f91                	subw	a5,a5,a2
ffffffffc0203dd8:	0027971b          	slliw	a4,a5,0x2
ffffffffc0203ddc:	9fb9                	addw	a5,a5,a4
    while(iter++<TIMES)
ffffffffc0203dde:	4b15                	li	s6,5
        phi_test_sema(RIGHT); /* 看一下右邻居现在是否能进餐 */
ffffffffc0203de0:	40fa0a3b          	subw	s4,s4,a5
    { /* 无限循环 */
        cprintf("Iter %d, No.%d philosopher_sema is thinking\n",iter,i); /* 哲学家正在思考 */
ffffffffc0203de4:	85a6                	mv	a1,s1
ffffffffc0203de6:	8622                	mv	a2,s0
ffffffffc0203de8:	00004517          	auipc	a0,0x4
ffffffffc0203dec:	cb050513          	addi	a0,a0,-848 # ffffffffc0207a98 <etext+0x1754>
ffffffffc0203df0:	ba8fc0ef          	jal	ffffffffc0200198 <cprintf>
        do_sleep(SLEEP_TIME);
ffffffffc0203df4:	4529                	li	a0,10
ffffffffc0203df6:	465010ef          	jal	ffffffffc0205a5a <do_sleep>
        down(&mutex); /* 进入临界区 */
ffffffffc0203dfa:	000c4517          	auipc	a0,0xc4
ffffffffc0203dfe:	3d650513          	addi	a0,a0,982 # ffffffffc02c81d0 <mutex>
ffffffffc0203e02:	75a000ef          	jal	ffffffffc020455c <down>
        phi_test_sema(i); /* 试图得到两只叉子 */
ffffffffc0203e06:	8522                	mv	a0,s0
        state_sema[i]=HUNGRY; /* 记录下哲学家i饥饿的事实 */
ffffffffc0203e08:	01792023          	sw	s7,0(s2)
        phi_test_sema(i); /* 试图得到两只叉子 */
ffffffffc0203e0c:	ecdff0ef          	jal	ffffffffc0203cd8 <phi_test_sema>
        up(&mutex); /* 离开临界区 */
ffffffffc0203e10:	000c4517          	auipc	a0,0xc4
ffffffffc0203e14:	3c050513          	addi	a0,a0,960 # ffffffffc02c81d0 <mutex>
ffffffffc0203e18:	740000ef          	jal	ffffffffc0204558 <up>
        down(&s[i]); /* 如果得不到叉子就阻塞 */
ffffffffc0203e1c:	854e                	mv	a0,s3
ffffffffc0203e1e:	73e000ef          	jal	ffffffffc020455c <down>
        phi_take_forks_sema(i); 
        /* 需要两只叉子，或者阻塞 */
        cprintf("Iter %d, No.%d philosopher_sema is eating\n",iter,i); /* 进餐 */
ffffffffc0203e22:	85a6                	mv	a1,s1
ffffffffc0203e24:	8622                	mv	a2,s0
ffffffffc0203e26:	00004517          	auipc	a0,0x4
ffffffffc0203e2a:	ca250513          	addi	a0,a0,-862 # ffffffffc0207ac8 <etext+0x1784>
ffffffffc0203e2e:	b6afc0ef          	jal	ffffffffc0200198 <cprintf>
        do_sleep(SLEEP_TIME);
ffffffffc0203e32:	4529                	li	a0,10
ffffffffc0203e34:	427010ef          	jal	ffffffffc0205a5a <do_sleep>
        down(&mutex); /* 进入临界区 */
ffffffffc0203e38:	000c4517          	auipc	a0,0xc4
ffffffffc0203e3c:	39850513          	addi	a0,a0,920 # ffffffffc02c81d0 <mutex>
ffffffffc0203e40:	71c000ef          	jal	ffffffffc020455c <down>
        phi_test_sema(LEFT); /* 看一下左邻居现在是否能进餐 */
ffffffffc0203e44:	8556                	mv	a0,s5
        state_sema[i]=THINKING; /* 哲学家进餐结束 */
ffffffffc0203e46:	00092023          	sw	zero,0(s2)
        phi_test_sema(LEFT); /* 看一下左邻居现在是否能进餐 */
ffffffffc0203e4a:	e8fff0ef          	jal	ffffffffc0203cd8 <phi_test_sema>
        phi_test_sema(RIGHT); /* 看一下右邻居现在是否能进餐 */
ffffffffc0203e4e:	8552                	mv	a0,s4
ffffffffc0203e50:	e89ff0ef          	jal	ffffffffc0203cd8 <phi_test_sema>
        up(&mutex); /* 离开临界区 */
ffffffffc0203e54:	000c4517          	auipc	a0,0xc4
ffffffffc0203e58:	37c50513          	addi	a0,a0,892 # ffffffffc02c81d0 <mutex>
    while(iter++<TIMES)
ffffffffc0203e5c:	2485                	addiw	s1,s1,1
        up(&mutex); /* 离开临界区 */
ffffffffc0203e5e:	6fa000ef          	jal	ffffffffc0204558 <up>
    while(iter++<TIMES)
ffffffffc0203e62:	f96491e3          	bne	s1,s6,ffffffffc0203de4 <philosopher_using_semaphore+0x88>
        phi_put_forks_sema(i); 
        /* 把两把叉子同时放回桌子 */
    }
    cprintf("No.%d philosopher_sema quit\n",i);
ffffffffc0203e66:	85a2                	mv	a1,s0
ffffffffc0203e68:	00004517          	auipc	a0,0x4
ffffffffc0203e6c:	c9050513          	addi	a0,a0,-880 # ffffffffc0207af8 <etext+0x17b4>
ffffffffc0203e70:	b28fc0ef          	jal	ffffffffc0200198 <cprintf>
    return 0;    
}
ffffffffc0203e74:	60a6                	ld	ra,72(sp)
ffffffffc0203e76:	6406                	ld	s0,64(sp)
ffffffffc0203e78:	74e2                	ld	s1,56(sp)
ffffffffc0203e7a:	7942                	ld	s2,48(sp)
ffffffffc0203e7c:	79a2                	ld	s3,40(sp)
ffffffffc0203e7e:	7a02                	ld	s4,32(sp)
ffffffffc0203e80:	6ae2                	ld	s5,24(sp)
ffffffffc0203e82:	6b42                	ld	s6,16(sp)
ffffffffc0203e84:	6ba2                	ld	s7,8(sp)
ffffffffc0203e86:	4501                	li	a0,0
ffffffffc0203e88:	6161                	addi	sp,sp,80
ffffffffc0203e8a:	8082                	ret

ffffffffc0203e8c <phi_test_condvar>:
struct proc_struct *philosopher_proc_condvar[N]; // N philosopher
int state_condvar[N];                            // the philosopher's state: EATING, HUNGARY, THINKING  
monitor_t mt, *mtp=&mt;                          // monitor

void phi_test_condvar (int i) { 
    if(state_condvar[i]==HUNGRY&&state_condvar[LEFT]!=EATING
ffffffffc0203e8c:	00251613          	slli	a2,a0,0x2
ffffffffc0203e90:	000c4697          	auipc	a3,0xc4
ffffffffc0203e94:	26068693          	addi	a3,a3,608 # ffffffffc02c80f0 <state_condvar>
ffffffffc0203e98:	00c68833          	add	a6,a3,a2
ffffffffc0203e9c:	00082703          	lw	a4,0(a6) # fffffffffffff000 <end+0x3fd32d38>
ffffffffc0203ea0:	4785                	li	a5,1
ffffffffc0203ea2:	00f70363          	beq	a4,a5,ffffffffc0203ea8 <phi_test_condvar+0x1c>
ffffffffc0203ea6:	8082                	ret
ffffffffc0203ea8:	66666737          	lui	a4,0x66666
ffffffffc0203eac:	0045079b          	addiw	a5,a0,4
ffffffffc0203eb0:	66770713          	addi	a4,a4,1639 # 66666667 <_binary_obj___user_matrix_out_size+0x6665af7f>
ffffffffc0203eb4:	02e785b3          	mul	a1,a5,a4
ffffffffc0203eb8:	41f7d89b          	sraiw	a7,a5,0x1f
ffffffffc0203ebc:	4309                	li	t1,2
ffffffffc0203ebe:	9585                	srai	a1,a1,0x21
ffffffffc0203ec0:	411585bb          	subw	a1,a1,a7
ffffffffc0203ec4:	0025989b          	slliw	a7,a1,0x2
ffffffffc0203ec8:	00b885bb          	addw	a1,a7,a1
ffffffffc0203ecc:	9f8d                	subw	a5,a5,a1
ffffffffc0203ece:	078a                	slli	a5,a5,0x2
ffffffffc0203ed0:	97b6                	add	a5,a5,a3
ffffffffc0203ed2:	439c                	lw	a5,0(a5)
ffffffffc0203ed4:	fc6789e3          	beq	a5,t1,ffffffffc0203ea6 <phi_test_condvar+0x1a>
            &&state_condvar[RIGHT]!=EATING) {
ffffffffc0203ed8:	0015079b          	addiw	a5,a0,1
ffffffffc0203edc:	02e78733          	mul	a4,a5,a4
ffffffffc0203ee0:	41f7d59b          	sraiw	a1,a5,0x1f
ffffffffc0203ee4:	9705                	srai	a4,a4,0x21
ffffffffc0203ee6:	9f0d                	subw	a4,a4,a1
ffffffffc0203ee8:	0027159b          	slliw	a1,a4,0x2
ffffffffc0203eec:	9f2d                	addw	a4,a4,a1
ffffffffc0203eee:	9f99                	subw	a5,a5,a4
ffffffffc0203ef0:	078a                	slli	a5,a5,0x2
ffffffffc0203ef2:	96be                	add	a3,a3,a5
ffffffffc0203ef4:	429c                	lw	a5,0(a3)
ffffffffc0203ef6:	fa6788e3          	beq	a5,t1,ffffffffc0203ea6 <phi_test_condvar+0x1a>
void phi_test_condvar (int i) { 
ffffffffc0203efa:	7179                	addi	sp,sp,-48
ffffffffc0203efc:	85aa                	mv	a1,a0
        cprintf("phi_test_condvar: state_condvar[%d] will eating\n",i);
ffffffffc0203efe:	e42a                	sd	a0,8(sp)
ffffffffc0203f00:	00004517          	auipc	a0,0x4
ffffffffc0203f04:	c1850513          	addi	a0,a0,-1000 # ffffffffc0207b18 <etext+0x17d4>
void phi_test_condvar (int i) { 
ffffffffc0203f08:	f406                	sd	ra,40(sp)
        cprintf("phi_test_condvar: state_condvar[%d] will eating\n",i);
ffffffffc0203f0a:	e832                	sd	a2,16(sp)
ffffffffc0203f0c:	ec42                	sd	a6,24(sp)
ffffffffc0203f0e:	a8afc0ef          	jal	ffffffffc0200198 <cprintf>
        state_condvar[i] = EATING ;
        cprintf("phi_test_condvar: signal self_cv[%d] \n",i);
ffffffffc0203f12:	65a2                	ld	a1,8(sp)
        state_condvar[i] = EATING ;
ffffffffc0203f14:	6862                	ld	a6,24(sp)
ffffffffc0203f16:	4309                	li	t1,2
        cprintf("phi_test_condvar: signal self_cv[%d] \n",i);
ffffffffc0203f18:	00004517          	auipc	a0,0x4
ffffffffc0203f1c:	c3850513          	addi	a0,a0,-968 # ffffffffc0207b50 <etext+0x180c>
        state_condvar[i] = EATING ;
ffffffffc0203f20:	00682023          	sw	t1,0(a6)
        cprintf("phi_test_condvar: signal self_cv[%d] \n",i);
ffffffffc0203f24:	a74fc0ef          	jal	ffffffffc0200198 <cprintf>
        cond_signal(&mtp->cv[i]) ;
ffffffffc0203f28:	000c4797          	auipc	a5,0xc4
ffffffffc0203f2c:	d607b783          	ld	a5,-672(a5) # ffffffffc02c7c88 <mtp>
ffffffffc0203f30:	65a2                	ld	a1,8(sp)
ffffffffc0203f32:	6642                	ld	a2,16(sp)
ffffffffc0203f34:	7f88                	ld	a0,56(a5)
    }
}
ffffffffc0203f36:	70a2                	ld	ra,40(sp)
        cond_signal(&mtp->cv[i]) ;
ffffffffc0203f38:	962e                	add	a2,a2,a1
ffffffffc0203f3a:	060e                	slli	a2,a2,0x3
ffffffffc0203f3c:	9532                	add	a0,a0,a2
}
ffffffffc0203f3e:	6145                	addi	sp,sp,48
        cond_signal(&mtp->cv[i]) ;
ffffffffc0203f40:	a12d                	j	ffffffffc020436a <cond_signal>

ffffffffc0203f42 <phi_take_forks_condvar>:


void phi_take_forks_condvar(int i) {
ffffffffc0203f42:	7179                	addi	sp,sp,-48
ffffffffc0203f44:	e052                	sd	s4,0(sp)
     down(&(mtp->mutex));
ffffffffc0203f46:	000c4a17          	auipc	s4,0xc4
ffffffffc0203f4a:	d42a0a13          	addi	s4,s4,-702 # ffffffffc02c7c88 <mtp>
void phi_take_forks_condvar(int i) {
ffffffffc0203f4e:	e44e                	sd	s3,8(sp)
ffffffffc0203f50:	89aa                	mv	s3,a0
     down(&(mtp->mutex));
ffffffffc0203f52:	000a3503          	ld	a0,0(s4)
void phi_take_forks_condvar(int i) {
ffffffffc0203f56:	f406                	sd	ra,40(sp)
ffffffffc0203f58:	f022                	sd	s0,32(sp)
ffffffffc0203f5a:	ec26                	sd	s1,24(sp)
ffffffffc0203f5c:	e84a                	sd	s2,16(sp)
//--------into routine in monitor--------------
     // LAB7 EXERCISE1: YOUR CODE
     // I am hungry
     // try to get fork
    
state_condvar[i] = HUNGRY;
ffffffffc0203f5e:	00299413          	slli	s0,s3,0x2
     down(&(mtp->mutex));
ffffffffc0203f62:	5fa000ef          	jal	ffffffffc020455c <down>
state_condvar[i] = HUNGRY;
ffffffffc0203f66:	000c4497          	auipc	s1,0xc4
ffffffffc0203f6a:	18a48493          	addi	s1,s1,394 # ffffffffc02c80f0 <state_condvar>
ffffffffc0203f6e:	008487b3          	add	a5,s1,s0
ffffffffc0203f72:	4905                	li	s2,1
     phi_test_condvar(i);
ffffffffc0203f74:	854e                	mv	a0,s3
state_condvar[i] = HUNGRY;
ffffffffc0203f76:	0127a023          	sw	s2,0(a5)
     phi_test_condvar(i);
ffffffffc0203f7a:	f13ff0ef          	jal	ffffffffc0203e8c <phi_test_condvar>
     // Test: force cond_wait on first call to demonstrate functionality
     static int test_done = 0;
     if (!test_done && i == 0 && state_condvar[i] == EATING) {
ffffffffc0203f7e:	000c8797          	auipc	a5,0xc8
ffffffffc0203f82:	31a7a783          	lw	a5,794(a5) # ffffffffc02cc298 <test_done.0>
ffffffffc0203f86:	00f9e7b3          	or	a5,s3,a5
ffffffffc0203f8a:	ebb1                	bnez	a5,ffffffffc0203fde <phi_take_forks_condvar+0x9c>
ffffffffc0203f8c:	000c4717          	auipc	a4,0xc4
ffffffffc0203f90:	16472703          	lw	a4,356(a4) # ffffffffc02c80f0 <state_condvar>
ffffffffc0203f94:	4789                	li	a5,2
ffffffffc0203f96:	02f70263          	beq	a4,a5,ffffffffc0203fba <phi_take_forks_condvar+0x78>
         state_condvar[i] = HUNGRY;  // Temporarily set to HUNGRY
         cprintf("phi_take_fork_condvar: %d test cond_wait\n", i);
         cond_wait(&mtp->cv[i]);
     }
     if (state_condvar[i] != EATING) {
         cprintf("phi_take_fork_condvar: %d didn't get fork and will wait\n", i);
ffffffffc0203f9a:	85ce                	mv	a1,s3
ffffffffc0203f9c:	00004517          	auipc	a0,0x4
ffffffffc0203fa0:	bdc50513          	addi	a0,a0,-1060 # ffffffffc0207b78 <etext+0x1834>
ffffffffc0203fa4:	9f4fc0ef          	jal	ffffffffc0200198 <cprintf>
         cond_wait(&mtp->cv[i]);
ffffffffc0203fa8:	000a3783          	ld	a5,0(s4)
ffffffffc0203fac:	944e                	add	s0,s0,s3
ffffffffc0203fae:	040e                	slli	s0,s0,0x3
ffffffffc0203fb0:	7f88                	ld	a0,56(a5)
ffffffffc0203fb2:	9522                	add	a0,a0,s0
ffffffffc0203fb4:	40c000ef          	jal	ffffffffc02043c0 <cond_wait>
ffffffffc0203fb8:	a805                	j	ffffffffc0203fe8 <phi_take_forks_condvar+0xa6>
         cprintf("phi_take_fork_condvar: %d test cond_wait\n", i);
ffffffffc0203fba:	4581                	li	a1,0
ffffffffc0203fbc:	00004517          	auipc	a0,0x4
ffffffffc0203fc0:	bfc50513          	addi	a0,a0,-1028 # ffffffffc0207bb8 <etext+0x1874>
         test_done = 1;
ffffffffc0203fc4:	000c8797          	auipc	a5,0xc8
ffffffffc0203fc8:	2d27aa23          	sw	s2,724(a5) # ffffffffc02cc298 <test_done.0>
         state_condvar[i] = HUNGRY;  // Temporarily set to HUNGRY
ffffffffc0203fcc:	0124a023          	sw	s2,0(s1)
         cprintf("phi_take_fork_condvar: %d test cond_wait\n", i);
ffffffffc0203fd0:	9c8fc0ef          	jal	ffffffffc0200198 <cprintf>
         cond_wait(&mtp->cv[i]);
ffffffffc0203fd4:	000a3783          	ld	a5,0(s4)
ffffffffc0203fd8:	7f88                	ld	a0,56(a5)
ffffffffc0203fda:	3e6000ef          	jal	ffffffffc02043c0 <cond_wait>
     if (state_condvar[i] != EATING) {
ffffffffc0203fde:	94a2                	add	s1,s1,s0
ffffffffc0203fe0:	4098                	lw	a4,0(s1)
ffffffffc0203fe2:	4789                	li	a5,2
ffffffffc0203fe4:	faf71be3          	bne	a4,a5,ffffffffc0203f9a <phi_take_forks_condvar+0x58>
     }
    //--------leave routine in monitor--------------
      if(mtp->next_count>0)
ffffffffc0203fe8:	000a3503          	ld	a0,0(s4)
ffffffffc0203fec:	591c                	lw	a5,48(a0)
ffffffffc0203fee:	00f05363          	blez	a5,ffffffffc0203ff4 <phi_take_forks_condvar+0xb2>
         up(&(mtp->next));
ffffffffc0203ff2:	0561                	addi	a0,a0,24
      else
         up(&(mtp->mutex));
}
ffffffffc0203ff4:	7402                	ld	s0,32(sp)
ffffffffc0203ff6:	70a2                	ld	ra,40(sp)
ffffffffc0203ff8:	64e2                	ld	s1,24(sp)
ffffffffc0203ffa:	6942                	ld	s2,16(sp)
ffffffffc0203ffc:	69a2                	ld	s3,8(sp)
ffffffffc0203ffe:	6a02                	ld	s4,0(sp)
ffffffffc0204000:	6145                	addi	sp,sp,48
         up(&(mtp->mutex));
ffffffffc0204002:	ab99                	j	ffffffffc0204558 <up>

ffffffffc0204004 <phi_put_forks_condvar>:

void phi_put_forks_condvar(int i) {
ffffffffc0204004:	1101                	addi	sp,sp,-32
ffffffffc0204006:	e04a                	sd	s2,0(sp)
     down(&(mtp->mutex));
ffffffffc0204008:	000c4917          	auipc	s2,0xc4
ffffffffc020400c:	c8090913          	addi	s2,s2,-896 # ffffffffc02c7c88 <mtp>
void phi_put_forks_condvar(int i) {
ffffffffc0204010:	e426                	sd	s1,8(sp)
ffffffffc0204012:	84aa                	mv	s1,a0
     down(&(mtp->mutex));
ffffffffc0204014:	00093503          	ld	a0,0(s2)
void phi_put_forks_condvar(int i) {
ffffffffc0204018:	ec06                	sd	ra,24(sp)
ffffffffc020401a:	e822                	sd	s0,16(sp)
     down(&(mtp->mutex));
ffffffffc020401c:	540000ef          	jal	ffffffffc020455c <down>
     // LAB7 EXERCISE1: YOUR CODE
     // I ate over
     // test left and right neighbors
    
state_condvar[i] = THINKING;
     phi_test_condvar(LEFT);
ffffffffc0204020:	66666437          	lui	s0,0x66666
ffffffffc0204024:	0044851b          	addiw	a0,s1,4
ffffffffc0204028:	66740413          	addi	s0,s0,1639 # 66666667 <_binary_obj___user_matrix_out_size+0x6665af7f>
ffffffffc020402c:	028507b3          	mul	a5,a0,s0
state_condvar[i] = THINKING;
ffffffffc0204030:	00249613          	slli	a2,s1,0x2
     phi_test_condvar(RIGHT);
ffffffffc0204034:	2485                	addiw	s1,s1,1
     phi_test_condvar(LEFT);
ffffffffc0204036:	41f5569b          	sraiw	a3,a0,0x1f
state_condvar[i] = THINKING;
ffffffffc020403a:	000c4717          	auipc	a4,0xc4
ffffffffc020403e:	0b670713          	addi	a4,a4,182 # ffffffffc02c80f0 <state_condvar>
ffffffffc0204042:	9732                	add	a4,a4,a2
ffffffffc0204044:	00072023          	sw	zero,0(a4)
     phi_test_condvar(RIGHT);
ffffffffc0204048:	02848433          	mul	s0,s1,s0
     phi_test_condvar(LEFT);
ffffffffc020404c:	9785                	srai	a5,a5,0x21
ffffffffc020404e:	9f95                	subw	a5,a5,a3
ffffffffc0204050:	0027971b          	slliw	a4,a5,0x2
ffffffffc0204054:	9fb9                	addw	a5,a5,a4
ffffffffc0204056:	9d1d                	subw	a0,a0,a5
ffffffffc0204058:	e35ff0ef          	jal	ffffffffc0203e8c <phi_test_condvar>
     phi_test_condvar(RIGHT);
ffffffffc020405c:	41f4d79b          	sraiw	a5,s1,0x1f
ffffffffc0204060:	9405                	srai	s0,s0,0x21
ffffffffc0204062:	9c1d                	subw	s0,s0,a5
ffffffffc0204064:	0024151b          	slliw	a0,s0,0x2
ffffffffc0204068:	9d21                	addw	a0,a0,s0
ffffffffc020406a:	40a4853b          	subw	a0,s1,a0
ffffffffc020406e:	e1fff0ef          	jal	ffffffffc0203e8c <phi_test_condvar>
    //--------leave routine in monitor--------------
     if(mtp->next_count>0)
ffffffffc0204072:	00093503          	ld	a0,0(s2)
ffffffffc0204076:	591c                	lw	a5,48(a0)
ffffffffc0204078:	00f05363          	blez	a5,ffffffffc020407e <phi_put_forks_condvar+0x7a>
        up(&(mtp->next));
ffffffffc020407c:	0561                	addi	a0,a0,24
     else
        up(&(mtp->mutex));
}
ffffffffc020407e:	6442                	ld	s0,16(sp)
ffffffffc0204080:	60e2                	ld	ra,24(sp)
ffffffffc0204082:	64a2                	ld	s1,8(sp)
ffffffffc0204084:	6902                	ld	s2,0(sp)
ffffffffc0204086:	6105                	addi	sp,sp,32
        up(&(mtp->mutex));
ffffffffc0204088:	a9c1                	j	ffffffffc0204558 <up>

ffffffffc020408a <philosopher_using_condvar>:

//---------- philosophers using monitor (condition variable) ----------------------
int philosopher_using_condvar(void * arg) { /* arg is the No. of philosopher 0~N-1*/
ffffffffc020408a:	1101                	addi	sp,sp,-32
ffffffffc020408c:	e822                	sd	s0,16(sp)
  
    int i, iter=0;
    i=(int)arg;
ffffffffc020408e:	0005041b          	sext.w	s0,a0
    cprintf("I am No.%d philosopher_condvar\n",i);
ffffffffc0204092:	85a2                	mv	a1,s0
ffffffffc0204094:	00004517          	auipc	a0,0x4
ffffffffc0204098:	b5450513          	addi	a0,a0,-1196 # ffffffffc0207be8 <etext+0x18a4>
int philosopher_using_condvar(void * arg) { /* arg is the No. of philosopher 0~N-1*/
ffffffffc020409c:	e426                	sd	s1,8(sp)
ffffffffc020409e:	e04a                	sd	s2,0(sp)
ffffffffc02040a0:	ec06                	sd	ra,24(sp)
    while(iter++<TIMES)
ffffffffc02040a2:	4485                	li	s1,1
    cprintf("I am No.%d philosopher_condvar\n",i);
ffffffffc02040a4:	8f4fc0ef          	jal	ffffffffc0200198 <cprintf>
    while(iter++<TIMES)
ffffffffc02040a8:	4915                	li	s2,5
    { /* iterate*/
        cprintf("Iter %d, No.%d philosopher_condvar is thinking\n",iter,i); /* thinking*/
ffffffffc02040aa:	8622                	mv	a2,s0
ffffffffc02040ac:	85a6                	mv	a1,s1
ffffffffc02040ae:	00004517          	auipc	a0,0x4
ffffffffc02040b2:	b5a50513          	addi	a0,a0,-1190 # ffffffffc0207c08 <etext+0x18c4>
ffffffffc02040b6:	8e2fc0ef          	jal	ffffffffc0200198 <cprintf>
        do_sleep(SLEEP_TIME);
ffffffffc02040ba:	4529                	li	a0,10
ffffffffc02040bc:	19f010ef          	jal	ffffffffc0205a5a <do_sleep>
        phi_take_forks_condvar(i); 
ffffffffc02040c0:	8522                	mv	a0,s0
ffffffffc02040c2:	e81ff0ef          	jal	ffffffffc0203f42 <phi_take_forks_condvar>
        /* need two forks, maybe blocked */
        cprintf("Iter %d, No.%d philosopher_condvar is eating\n",iter,i); /* eating*/
ffffffffc02040c6:	8622                	mv	a2,s0
ffffffffc02040c8:	85a6                	mv	a1,s1
ffffffffc02040ca:	00004517          	auipc	a0,0x4
ffffffffc02040ce:	b6e50513          	addi	a0,a0,-1170 # ffffffffc0207c38 <etext+0x18f4>
ffffffffc02040d2:	8c6fc0ef          	jal	ffffffffc0200198 <cprintf>
        // Make philosopher 0's first meal very long to force others to wait
        if (i == 0 && iter == 1) {
ffffffffc02040d6:	fff48793          	addi	a5,s1,-1
            do_sleep(SLEEP_TIME * 20);
ffffffffc02040da:	0c800513          	li	a0,200
        if (i == 0 && iter == 1) {
ffffffffc02040de:	eb89                	bnez	a5,ffffffffc02040f0 <philosopher_using_condvar+0x66>
ffffffffc02040e0:	e801                	bnez	s0,ffffffffc02040f0 <philosopher_using_condvar+0x66>
            do_sleep(SLEEP_TIME * 20);
ffffffffc02040e2:	179010ef          	jal	ffffffffc0205a5a <do_sleep>
        } else {
            do_sleep(SLEEP_TIME);
        }
        phi_put_forks_condvar(i); 
ffffffffc02040e6:	4501                	li	a0,0
ffffffffc02040e8:	f1dff0ef          	jal	ffffffffc0204004 <phi_put_forks_condvar>
    while(iter++<TIMES)
ffffffffc02040ec:	4489                	li	s1,2
ffffffffc02040ee:	bf75                	j	ffffffffc02040aa <philosopher_using_condvar+0x20>
            do_sleep(SLEEP_TIME);
ffffffffc02040f0:	4529                	li	a0,10
ffffffffc02040f2:	169010ef          	jal	ffffffffc0205a5a <do_sleep>
        phi_put_forks_condvar(i); 
ffffffffc02040f6:	8522                	mv	a0,s0
    while(iter++<TIMES)
ffffffffc02040f8:	2485                	addiw	s1,s1,1
        phi_put_forks_condvar(i); 
ffffffffc02040fa:	f0bff0ef          	jal	ffffffffc0204004 <phi_put_forks_condvar>
    while(iter++<TIMES)
ffffffffc02040fe:	fb2496e3          	bne	s1,s2,ffffffffc02040aa <philosopher_using_condvar+0x20>
        /* return two forks back*/
    }
    cprintf("No.%d philosopher_condvar quit\n",i);
ffffffffc0204102:	85a2                	mv	a1,s0
ffffffffc0204104:	00004517          	auipc	a0,0x4
ffffffffc0204108:	b6450513          	addi	a0,a0,-1180 # ffffffffc0207c68 <etext+0x1924>
ffffffffc020410c:	88cfc0ef          	jal	ffffffffc0200198 <cprintf>
    return 0;    
}
ffffffffc0204110:	60e2                	ld	ra,24(sp)
ffffffffc0204112:	6442                	ld	s0,16(sp)
ffffffffc0204114:	64a2                	ld	s1,8(sp)
ffffffffc0204116:	6902                	ld	s2,0(sp)
ffffffffc0204118:	4501                	li	a0,0
ffffffffc020411a:	6105                	addi	sp,sp,32
ffffffffc020411c:	8082                	ret

ffffffffc020411e <check_sync>:

void check_sync(void){
ffffffffc020411e:	711d                	addi	sp,sp,-96
ffffffffc0204120:	e4a6                	sd	s1,72(sp)

    int i, pids[N];

    //check semaphore
    sem_init(&mutex, 1);
ffffffffc0204122:	4585                	li	a1,1
ffffffffc0204124:	000c4517          	auipc	a0,0xc4
ffffffffc0204128:	0ac50513          	addi	a0,a0,172 # ffffffffc02c81d0 <mutex>
ffffffffc020412c:	0024                	addi	s1,sp,8
void check_sync(void){
ffffffffc020412e:	e8a2                	sd	s0,80(sp)
ffffffffc0204130:	e0ca                	sd	s2,64(sp)
ffffffffc0204132:	fc4e                	sd	s3,56(sp)
ffffffffc0204134:	f852                	sd	s4,48(sp)
ffffffffc0204136:	f456                	sd	s5,40(sp)
ffffffffc0204138:	ec86                	sd	ra,88(sp)
ffffffffc020413a:	f05a                	sd	s6,32(sp)
    sem_init(&mutex, 1);
ffffffffc020413c:	8a26                	mv	s4,s1
ffffffffc020413e:	414000ef          	jal	ffffffffc0204552 <sem_init>
    for(i=0;i<N;i++){
ffffffffc0204142:	000c4997          	auipc	s3,0xc4
ffffffffc0204146:	01698993          	addi	s3,s3,22 # ffffffffc02c8158 <s>
ffffffffc020414a:	000c4917          	auipc	s2,0xc4
ffffffffc020414e:	fe690913          	addi	s2,s2,-26 # ffffffffc02c8130 <philosopher_proc_sema>
    sem_init(&mutex, 1);
ffffffffc0204152:	4401                	li	s0,0
    for(i=0;i<N;i++){
ffffffffc0204154:	4a95                	li	s5,5
        sem_init(&s[i], 0);
ffffffffc0204156:	4581                	li	a1,0
ffffffffc0204158:	854e                	mv	a0,s3
ffffffffc020415a:	3f8000ef          	jal	ffffffffc0204552 <sem_init>
        int pid = kernel_thread(philosopher_using_semaphore, (void *)i, 0);
ffffffffc020415e:	85a2                	mv	a1,s0
ffffffffc0204160:	4601                	li	a2,0
ffffffffc0204162:	00000517          	auipc	a0,0x0
ffffffffc0204166:	bfa50513          	addi	a0,a0,-1030 # ffffffffc0203d5c <philosopher_using_semaphore>
ffffffffc020416a:	357000ef          	jal	ffffffffc0204cc0 <kernel_thread>
        if (pid <= 0) {
ffffffffc020416e:	0ca05d63          	blez	a0,ffffffffc0204248 <check_sync+0x12a>
            panic("create No.%d philosopher_using_semaphore failed.\n");
        }
        pids[i] = pid;
ffffffffc0204172:	00aa2023          	sw	a0,0(s4)
        philosopher_proc_sema[i] = find_proc(pid);
ffffffffc0204176:	6cc000ef          	jal	ffffffffc0204842 <find_proc>
ffffffffc020417a:	00a93023          	sd	a0,0(s2)
        set_proc_name(philosopher_proc_sema[i], "philosopher_sema_proc");
ffffffffc020417e:	00004597          	auipc	a1,0x4
ffffffffc0204182:	b5a58593          	addi	a1,a1,-1190 # ffffffffc0207cd8 <etext+0x1994>
    for(i=0;i<N;i++){
ffffffffc0204186:	0405                	addi	s0,s0,1
        set_proc_name(philosopher_proc_sema[i], "philosopher_sema_proc");
ffffffffc0204188:	62e000ef          	jal	ffffffffc02047b6 <set_proc_name>
    for(i=0;i<N;i++){
ffffffffc020418c:	09e1                	addi	s3,s3,24
ffffffffc020418e:	0a11                	addi	s4,s4,4
ffffffffc0204190:	0921                	addi	s2,s2,8
ffffffffc0204192:	fd5412e3          	bne	s0,s5,ffffffffc0204156 <check_sync+0x38>
ffffffffc0204196:	01448a93          	addi	s5,s1,20
ffffffffc020419a:	8426                	mv	s0,s1
    }
    for (i=0;i<N;i++)
        assert(do_wait(pids[i],NULL) == 0);
ffffffffc020419c:	4008                	lw	a0,0(s0)
ffffffffc020419e:	4581                	li	a1,0
ffffffffc02041a0:	604010ef          	jal	ffffffffc02057a4 <do_wait>
ffffffffc02041a4:	0e051a63          	bnez	a0,ffffffffc0204298 <check_sync+0x17a>
    for (i=0;i<N;i++)
ffffffffc02041a8:	0411                	addi	s0,s0,4
ffffffffc02041aa:	ff5419e3          	bne	s0,s5,ffffffffc020419c <check_sync+0x7e>

    //check condition variable
    monitor_init(&mt, N);
ffffffffc02041ae:	4595                	li	a1,5
ffffffffc02041b0:	000c4517          	auipc	a0,0xc4
ffffffffc02041b4:	f0050513          	addi	a0,a0,-256 # ffffffffc02c80b0 <mt>
ffffffffc02041b8:	100000ef          	jal	ffffffffc02042b8 <monitor_init>
ffffffffc02041bc:	8a26                	mv	s4,s1
ffffffffc02041be:	000c4997          	auipc	s3,0xc4
ffffffffc02041c2:	f3298993          	addi	s3,s3,-206 # ffffffffc02c80f0 <state_condvar>
ffffffffc02041c6:	000c4917          	auipc	s2,0xc4
ffffffffc02041ca:	f4290913          	addi	s2,s2,-190 # ffffffffc02c8108 <philosopher_proc_condvar>
ffffffffc02041ce:	4401                	li	s0,0
    for(i=0;i<N;i++){
ffffffffc02041d0:	4b15                	li	s6,5
        state_condvar[i]=THINKING;
        int pid = kernel_thread(philosopher_using_condvar, (void *)i, 0);
ffffffffc02041d2:	4601                	li	a2,0
ffffffffc02041d4:	85a2                	mv	a1,s0
ffffffffc02041d6:	00000517          	auipc	a0,0x0
ffffffffc02041da:	eb450513          	addi	a0,a0,-332 # ffffffffc020408a <philosopher_using_condvar>
        state_condvar[i]=THINKING;
ffffffffc02041de:	0009a023          	sw	zero,0(s3)
        int pid = kernel_thread(philosopher_using_condvar, (void *)i, 0);
ffffffffc02041e2:	2df000ef          	jal	ffffffffc0204cc0 <kernel_thread>
        if (pid <= 0) {
ffffffffc02041e6:	08a05d63          	blez	a0,ffffffffc0204280 <check_sync+0x162>
            panic("create No.%d philosopher_using_condvar failed.\n");
        }
        pids[i] = pid;
ffffffffc02041ea:	00aa2023          	sw	a0,0(s4)
        philosopher_proc_condvar[i] = find_proc(pid);
ffffffffc02041ee:	654000ef          	jal	ffffffffc0204842 <find_proc>
ffffffffc02041f2:	00a93023          	sd	a0,0(s2)
        set_proc_name(philosopher_proc_condvar[i], "philosopher_condvar_proc");
ffffffffc02041f6:	00004597          	auipc	a1,0x4
ffffffffc02041fa:	b4a58593          	addi	a1,a1,-1206 # ffffffffc0207d40 <etext+0x19fc>
    for(i=0;i<N;i++){
ffffffffc02041fe:	0405                	addi	s0,s0,1
        set_proc_name(philosopher_proc_condvar[i], "philosopher_condvar_proc");
ffffffffc0204200:	5b6000ef          	jal	ffffffffc02047b6 <set_proc_name>
    for(i=0;i<N;i++){
ffffffffc0204204:	0991                	addi	s3,s3,4
ffffffffc0204206:	0a11                	addi	s4,s4,4
ffffffffc0204208:	0921                	addi	s2,s2,8
ffffffffc020420a:	fd6414e3          	bne	s0,s6,ffffffffc02041d2 <check_sync+0xb4>
ffffffffc020420e:	06400413          	li	s0,100
    }
    // Give all philosophers a chance to start
    for (i = 0; i < 100; i++) {
ffffffffc0204212:	347d                	addiw	s0,s0,-1
        do_yield();
ffffffffc0204214:	580010ef          	jal	ffffffffc0205794 <do_yield>
    for (i = 0; i < 100; i++) {
ffffffffc0204218:	fc6d                	bnez	s0,ffffffffc0204212 <check_sync+0xf4>
    }
    for (i=0;i<N;i++)
        assert(do_wait(pids[i],NULL) == 0);
ffffffffc020421a:	4088                	lw	a0,0(s1)
ffffffffc020421c:	4581                	li	a1,0
ffffffffc020421e:	586010ef          	jal	ffffffffc02057a4 <do_wait>
ffffffffc0204222:	ed1d                	bnez	a0,ffffffffc0204260 <check_sync+0x142>
    for (i=0;i<N;i++)
ffffffffc0204224:	0491                	addi	s1,s1,4
ffffffffc0204226:	ff549ae3          	bne	s1,s5,ffffffffc020421a <check_sync+0xfc>
    monitor_free(&mt, N);
}
ffffffffc020422a:	6446                	ld	s0,80(sp)
ffffffffc020422c:	60e6                	ld	ra,88(sp)
ffffffffc020422e:	64a6                	ld	s1,72(sp)
ffffffffc0204230:	6906                	ld	s2,64(sp)
ffffffffc0204232:	79e2                	ld	s3,56(sp)
ffffffffc0204234:	7a42                	ld	s4,48(sp)
ffffffffc0204236:	7aa2                	ld	s5,40(sp)
ffffffffc0204238:	7b02                	ld	s6,32(sp)
    monitor_free(&mt, N);
ffffffffc020423a:	4595                	li	a1,5
ffffffffc020423c:	000c4517          	auipc	a0,0xc4
ffffffffc0204240:	e7450513          	addi	a0,a0,-396 # ffffffffc02c80b0 <mt>
}
ffffffffc0204244:	6125                	addi	sp,sp,96
    monitor_free(&mt, N);
ffffffffc0204246:	aa39                	j	ffffffffc0204364 <monitor_free>
            panic("create No.%d philosopher_using_semaphore failed.\n");
ffffffffc0204248:	00004617          	auipc	a2,0x4
ffffffffc020424c:	a4060613          	addi	a2,a2,-1472 # ffffffffc0207c88 <etext+0x1944>
ffffffffc0204250:	10700593          	li	a1,263
ffffffffc0204254:	00004517          	auipc	a0,0x4
ffffffffc0204258:	a6c50513          	addi	a0,a0,-1428 # ffffffffc0207cc0 <etext+0x197c>
ffffffffc020425c:	9eefc0ef          	jal	ffffffffc020044a <__panic>
        assert(do_wait(pids[i],NULL) == 0);
ffffffffc0204260:	00004697          	auipc	a3,0x4
ffffffffc0204264:	a9068693          	addi	a3,a3,-1392 # ffffffffc0207cf0 <etext+0x19ac>
ffffffffc0204268:	00003617          	auipc	a2,0x3
ffffffffc020426c:	a9060613          	addi	a2,a2,-1392 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0204270:	12100593          	li	a1,289
ffffffffc0204274:	00004517          	auipc	a0,0x4
ffffffffc0204278:	a4c50513          	addi	a0,a0,-1460 # ffffffffc0207cc0 <etext+0x197c>
ffffffffc020427c:	9cefc0ef          	jal	ffffffffc020044a <__panic>
            panic("create No.%d philosopher_using_condvar failed.\n");
ffffffffc0204280:	00004617          	auipc	a2,0x4
ffffffffc0204284:	a9060613          	addi	a2,a2,-1392 # ffffffffc0207d10 <etext+0x19cc>
ffffffffc0204288:	11600593          	li	a1,278
ffffffffc020428c:	00004517          	auipc	a0,0x4
ffffffffc0204290:	a3450513          	addi	a0,a0,-1484 # ffffffffc0207cc0 <etext+0x197c>
ffffffffc0204294:	9b6fc0ef          	jal	ffffffffc020044a <__panic>
        assert(do_wait(pids[i],NULL) == 0);
ffffffffc0204298:	00004697          	auipc	a3,0x4
ffffffffc020429c:	a5868693          	addi	a3,a3,-1448 # ffffffffc0207cf0 <etext+0x19ac>
ffffffffc02042a0:	00003617          	auipc	a2,0x3
ffffffffc02042a4:	a5860613          	addi	a2,a2,-1448 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02042a8:	10e00593          	li	a1,270
ffffffffc02042ac:	00004517          	auipc	a0,0x4
ffffffffc02042b0:	a1450513          	addi	a0,a0,-1516 # ffffffffc0207cc0 <etext+0x197c>
ffffffffc02042b4:	996fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02042b8 <monitor_init>:
#include <assert.h>


// Initialize monitor.
void     
monitor_init (monitor_t * mtp, size_t num_cv) {
ffffffffc02042b8:	7179                	addi	sp,sp,-48
ffffffffc02042ba:	f406                	sd	ra,40(sp)
ffffffffc02042bc:	f022                	sd	s0,32(sp)
ffffffffc02042be:	ec26                	sd	s1,24(sp)
ffffffffc02042c0:	e84a                	sd	s2,16(sp)
ffffffffc02042c2:	e44e                	sd	s3,8(sp)
    int i;
    assert(num_cv>0);
ffffffffc02042c4:	c1b5                	beqz	a1,ffffffffc0204328 <monitor_init+0x70>
    mtp->next_count = 0;
ffffffffc02042c6:	89ae                	mv	s3,a1
ffffffffc02042c8:	02052823          	sw	zero,48(a0)
    mtp->cv = NULL;
ffffffffc02042cc:	02053c23          	sd	zero,56(a0)
    sem_init(&(mtp->mutex), 1); //unlocked
ffffffffc02042d0:	4585                	li	a1,1
ffffffffc02042d2:	892a                	mv	s2,a0
ffffffffc02042d4:	27e000ef          	jal	ffffffffc0204552 <sem_init>
    sem_init(&(mtp->next), 0);
ffffffffc02042d8:	01890513          	addi	a0,s2,24
ffffffffc02042dc:	4581                	li	a1,0
ffffffffc02042de:	274000ef          	jal	ffffffffc0204552 <sem_init>
    mtp->cv =(condvar_t *) kmalloc(sizeof(condvar_t)*num_cv);
ffffffffc02042e2:	00299513          	slli	a0,s3,0x2
ffffffffc02042e6:	954e                	add	a0,a0,s3
ffffffffc02042e8:	050e                	slli	a0,a0,0x3
ffffffffc02042ea:	887fd0ef          	jal	ffffffffc0201b70 <kmalloc>
ffffffffc02042ee:	02a93c23          	sd	a0,56(s2)
    assert(mtp->cv!=NULL);
ffffffffc02042f2:	4401                	li	s0,0
ffffffffc02042f4:	4481                	li	s1,0
ffffffffc02042f6:	c921                	beqz	a0,ffffffffc0204346 <monitor_init+0x8e>
    for(i=0; i<num_cv; i++){
        mtp->cv[i].count=0;
ffffffffc02042f8:	9522                	add	a0,a0,s0
ffffffffc02042fa:	00052c23          	sw	zero,24(a0)
        sem_init(&(mtp->cv[i].sem),0);
ffffffffc02042fe:	4581                	li	a1,0
ffffffffc0204300:	252000ef          	jal	ffffffffc0204552 <sem_init>
        mtp->cv[i].owner=mtp;
ffffffffc0204304:	03893503          	ld	a0,56(s2)
    for(i=0; i<num_cv; i++){
ffffffffc0204308:	0485                	addi	s1,s1,1
        mtp->cv[i].owner=mtp;
ffffffffc020430a:	008507b3          	add	a5,a0,s0
ffffffffc020430e:	0327b023          	sd	s2,32(a5)
    for(i=0; i<num_cv; i++){
ffffffffc0204312:	02840413          	addi	s0,s0,40
ffffffffc0204316:	ff3491e3          	bne	s1,s3,ffffffffc02042f8 <monitor_init+0x40>
    }
}
ffffffffc020431a:	70a2                	ld	ra,40(sp)
ffffffffc020431c:	7402                	ld	s0,32(sp)
ffffffffc020431e:	64e2                	ld	s1,24(sp)
ffffffffc0204320:	6942                	ld	s2,16(sp)
ffffffffc0204322:	69a2                	ld	s3,8(sp)
ffffffffc0204324:	6145                	addi	sp,sp,48
ffffffffc0204326:	8082                	ret
    assert(num_cv>0);
ffffffffc0204328:	00004697          	auipc	a3,0x4
ffffffffc020432c:	a3868693          	addi	a3,a3,-1480 # ffffffffc0207d60 <etext+0x1a1c>
ffffffffc0204330:	00003617          	auipc	a2,0x3
ffffffffc0204334:	9c860613          	addi	a2,a2,-1592 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0204338:	45ad                	li	a1,11
ffffffffc020433a:	00004517          	auipc	a0,0x4
ffffffffc020433e:	a3650513          	addi	a0,a0,-1482 # ffffffffc0207d70 <etext+0x1a2c>
ffffffffc0204342:	908fc0ef          	jal	ffffffffc020044a <__panic>
    assert(mtp->cv!=NULL);
ffffffffc0204346:	00004697          	auipc	a3,0x4
ffffffffc020434a:	a4268693          	addi	a3,a3,-1470 # ffffffffc0207d88 <etext+0x1a44>
ffffffffc020434e:	00003617          	auipc	a2,0x3
ffffffffc0204352:	9aa60613          	addi	a2,a2,-1622 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0204356:	45c5                	li	a1,17
ffffffffc0204358:	00004517          	auipc	a0,0x4
ffffffffc020435c:	a1850513          	addi	a0,a0,-1512 # ffffffffc0207d70 <etext+0x1a2c>
ffffffffc0204360:	8eafc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204364 <monitor_free>:

// Free monitor.
void
monitor_free (monitor_t * mtp, size_t num_cv) {
    kfree(mtp->cv);
ffffffffc0204364:	7d08                	ld	a0,56(a0)
ffffffffc0204366:	8b1fd06f          	j	ffffffffc0201c16 <kfree>

ffffffffc020436a <cond_signal>:

// Unlock one of threads waiting on the condition variable. 
void 
cond_signal (condvar_t *cvp) {
   //LAB7 EXERCISE1: YOUR CODE
   cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc020436a:	711c                	ld	a5,32(a0)
ffffffffc020436c:	4d10                	lw	a2,24(a0)
cond_signal (condvar_t *cvp) {
ffffffffc020436e:	1141                	addi	sp,sp,-16
   cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc0204370:	5b94                	lw	a3,48(a5)
cond_signal (condvar_t *cvp) {
ffffffffc0204372:	e022                	sd	s0,0(sp)
   cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc0204374:	85aa                	mv	a1,a0
cond_signal (condvar_t *cvp) {
ffffffffc0204376:	842a                	mv	s0,a0
   cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc0204378:	00004517          	auipc	a0,0x4
ffffffffc020437c:	a2050513          	addi	a0,a0,-1504 # ffffffffc0207d98 <etext+0x1a54>
cond_signal (condvar_t *cvp) {
ffffffffc0204380:	e406                	sd	ra,8(sp)
   cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc0204382:	e17fb0ef          	jal	ffffffffc0200198 <cprintf>
   *             mt.next_count--;
   *          }
   *       }
   */
    if (cvp->count > 0) {
        cvp->owner->next_count++;
ffffffffc0204386:	701c                	ld	a5,32(s0)
    if (cvp->count > 0) {
ffffffffc0204388:	4c10                	lw	a2,24(s0)
        cvp->owner->next_count++;
ffffffffc020438a:	5b94                	lw	a3,48(a5)
    if (cvp->count > 0) {
ffffffffc020438c:	02c05063          	blez	a2,ffffffffc02043ac <cond_signal+0x42>
        cvp->owner->next_count++;
ffffffffc0204390:	2685                	addiw	a3,a3,1
ffffffffc0204392:	db94                	sw	a3,48(a5)
        up(&(cvp->sem));
ffffffffc0204394:	8522                	mv	a0,s0
ffffffffc0204396:	1c2000ef          	jal	ffffffffc0204558 <up>
        down(&(cvp->owner->next));
ffffffffc020439a:	7008                	ld	a0,32(s0)
ffffffffc020439c:	0561                	addi	a0,a0,24
ffffffffc020439e:	1be000ef          	jal	ffffffffc020455c <down>
        cvp->owner->next_count--;
ffffffffc02043a2:	701c                	ld	a5,32(s0)
    }
   cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02043a4:	4c10                	lw	a2,24(s0)
        cvp->owner->next_count--;
ffffffffc02043a6:	5b94                	lw	a3,48(a5)
ffffffffc02043a8:	36fd                	addiw	a3,a3,-1
ffffffffc02043aa:	db94                	sw	a3,48(a5)
   cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02043ac:	85a2                	mv	a1,s0
}
ffffffffc02043ae:	6402                	ld	s0,0(sp)
ffffffffc02043b0:	60a2                	ld	ra,8(sp)
   cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02043b2:	00004517          	auipc	a0,0x4
ffffffffc02043b6:	a2e50513          	addi	a0,a0,-1490 # ffffffffc0207de0 <etext+0x1a9c>
}
ffffffffc02043ba:	0141                	addi	sp,sp,16
   cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02043bc:	dddfb06f          	j	ffffffffc0200198 <cprintf>

ffffffffc02043c0 <cond_wait>:
// Suspend calling thread on a condition variable waiting for condition Atomically unlocks 
// mutex and suspends calling thread on conditional variable after waking up locks mutex. Notice: mp is mutex semaphore for monitor's procedures
void
cond_wait (condvar_t *cvp) {
    //LAB7 EXERCISE1: YOUR CODE
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02043c0:	711c                	ld	a5,32(a0)
ffffffffc02043c2:	4d10                	lw	a2,24(a0)
cond_wait (condvar_t *cvp) {
ffffffffc02043c4:	1141                	addi	sp,sp,-16
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02043c6:	5b94                	lw	a3,48(a5)
cond_wait (condvar_t *cvp) {
ffffffffc02043c8:	e022                	sd	s0,0(sp)
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02043ca:	85aa                	mv	a1,a0
cond_wait (condvar_t *cvp) {
ffffffffc02043cc:	842a                	mv	s0,a0
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02043ce:	00004517          	auipc	a0,0x4
ffffffffc02043d2:	a5a50513          	addi	a0,a0,-1446 # ffffffffc0207e28 <etext+0x1ae4>
cond_wait (condvar_t *cvp) {
ffffffffc02043d6:	e406                	sd	ra,8(sp)
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02043d8:	dc1fb0ef          	jal	ffffffffc0200198 <cprintf>
    *            signal(mt.mutex);
    *         wait(cv.sem);
    *         cv.count --;
    */
    cvp->count++;
    if (cvp->owner->next_count > 0) {
ffffffffc02043dc:	7008                	ld	a0,32(s0)
    cvp->count++;
ffffffffc02043de:	4c1c                	lw	a5,24(s0)
    if (cvp->owner->next_count > 0) {
ffffffffc02043e0:	5918                	lw	a4,48(a0)
    cvp->count++;
ffffffffc02043e2:	2785                	addiw	a5,a5,1
ffffffffc02043e4:	cc1c                	sw	a5,24(s0)
    if (cvp->owner->next_count > 0) {
ffffffffc02043e6:	02e05763          	blez	a4,ffffffffc0204414 <cond_wait+0x54>
        up(&(cvp->owner->next));
ffffffffc02043ea:	0561                	addi	a0,a0,24
ffffffffc02043ec:	16c000ef          	jal	ffffffffc0204558 <up>
    } else {
        up(&(cvp->owner->mutex));
    }
    down(&(cvp->sem));
ffffffffc02043f0:	8522                	mv	a0,s0
ffffffffc02043f2:	16a000ef          	jal	ffffffffc020455c <down>
    cvp->count--;
ffffffffc02043f6:	4c10                	lw	a2,24(s0)
    cprintf("cond_wait end:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02043f8:	701c                	ld	a5,32(s0)
ffffffffc02043fa:	85a2                	mv	a1,s0
    cvp->count--;
ffffffffc02043fc:	367d                	addiw	a2,a2,-1
    cprintf("cond_wait end:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02043fe:	5b94                	lw	a3,48(a5)
    cvp->count--;
ffffffffc0204400:	cc10                	sw	a2,24(s0)
}
ffffffffc0204402:	6402                	ld	s0,0(sp)
ffffffffc0204404:	60a2                	ld	ra,8(sp)
    cprintf("cond_wait end:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc0204406:	00004517          	auipc	a0,0x4
ffffffffc020440a:	a6a50513          	addi	a0,a0,-1430 # ffffffffc0207e70 <etext+0x1b2c>
}
ffffffffc020440e:	0141                	addi	sp,sp,16
    cprintf("cond_wait end:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc0204410:	d89fb06f          	j	ffffffffc0200198 <cprintf>
        up(&(cvp->owner->mutex));
ffffffffc0204414:	144000ef          	jal	ffffffffc0204558 <up>
ffffffffc0204418:	bfe1                	j	ffffffffc02043f0 <cond_wait+0x30>

ffffffffc020441a <__down.constprop.0>:
        }
    }
    local_intr_restore(intr_flag);
}

static __noinline uint32_t __down(semaphore_t *sem, uint32_t wait_state) {
ffffffffc020441a:	711d                	addi	sp,sp,-96
ffffffffc020441c:	ec86                	sd	ra,88(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020441e:	100027f3          	csrr	a5,sstatus
ffffffffc0204422:	8b89                	andi	a5,a5,2
ffffffffc0204424:	eba1                	bnez	a5,ffffffffc0204474 <__down.constprop.0+0x5a>
    bool intr_flag;
    local_intr_save(intr_flag);
    if (sem->value > 0) {
ffffffffc0204426:	411c                	lw	a5,0(a0)
ffffffffc0204428:	00f05863          	blez	a5,ffffffffc0204438 <__down.constprop.0+0x1e>
        sem->value --;
ffffffffc020442c:	37fd                	addiw	a5,a5,-1
ffffffffc020442e:	c11c                	sw	a5,0(a0)

    if (wait->wakeup_flags != wait_state) {
        return wait->wakeup_flags;
    }
    return 0;
}
ffffffffc0204430:	60e6                	ld	ra,88(sp)
        return 0;
ffffffffc0204432:	4501                	li	a0,0
}
ffffffffc0204434:	6125                	addi	sp,sp,96
ffffffffc0204436:	8082                	ret
    wait_current_set(&(sem->wait_queue), wait, wait_state);
ffffffffc0204438:	0521                	addi	a0,a0,8
ffffffffc020443a:	082c                	addi	a1,sp,24
ffffffffc020443c:	10000613          	li	a2,256
ffffffffc0204440:	e8a2                	sd	s0,80(sp)
ffffffffc0204442:	e4a6                	sd	s1,72(sp)
ffffffffc0204444:	0820                	addi	s0,sp,24
ffffffffc0204446:	84aa                	mv	s1,a0
ffffffffc0204448:	1f4000ef          	jal	ffffffffc020463c <wait_current_set>
    schedule();
ffffffffc020444c:	07f010ef          	jal	ffffffffc0205cca <schedule>
ffffffffc0204450:	100027f3          	csrr	a5,sstatus
ffffffffc0204454:	8b89                	andi	a5,a5,2
ffffffffc0204456:	efa9                	bnez	a5,ffffffffc02044b0 <__down.constprop.0+0x96>
    wait_current_del(&(sem->wait_queue), wait);
ffffffffc0204458:	8522                	mv	a0,s0
ffffffffc020445a:	186000ef          	jal	ffffffffc02045e0 <wait_in_queue>
ffffffffc020445e:	e521                	bnez	a0,ffffffffc02044a6 <__down.constprop.0+0x8c>
    if (wait->wakeup_flags != wait_state) {
ffffffffc0204460:	5502                	lw	a0,32(sp)
ffffffffc0204462:	10000793          	li	a5,256
ffffffffc0204466:	6446                	ld	s0,80(sp)
ffffffffc0204468:	64a6                	ld	s1,72(sp)
ffffffffc020446a:	fcf503e3          	beq	a0,a5,ffffffffc0204430 <__down.constprop.0+0x16>
}
ffffffffc020446e:	60e6                	ld	ra,88(sp)
ffffffffc0204470:	6125                	addi	sp,sp,96
ffffffffc0204472:	8082                	ret
ffffffffc0204474:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0204476:	c44fc0ef          	jal	ffffffffc02008ba <intr_disable>
    if (sem->value > 0) {
ffffffffc020447a:	6522                	ld	a0,8(sp)
ffffffffc020447c:	411c                	lw	a5,0(a0)
ffffffffc020447e:	00f05763          	blez	a5,ffffffffc020448c <__down.constprop.0+0x72>
        sem->value --;
ffffffffc0204482:	37fd                	addiw	a5,a5,-1
ffffffffc0204484:	c11c                	sw	a5,0(a0)
        intr_enable();
ffffffffc0204486:	c2efc0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc020448a:	b75d                	j	ffffffffc0204430 <__down.constprop.0+0x16>
    wait_current_set(&(sem->wait_queue), wait, wait_state);
ffffffffc020448c:	0521                	addi	a0,a0,8
ffffffffc020448e:	082c                	addi	a1,sp,24
ffffffffc0204490:	10000613          	li	a2,256
ffffffffc0204494:	e8a2                	sd	s0,80(sp)
ffffffffc0204496:	e4a6                	sd	s1,72(sp)
ffffffffc0204498:	0820                	addi	s0,sp,24
ffffffffc020449a:	84aa                	mv	s1,a0
ffffffffc020449c:	1a0000ef          	jal	ffffffffc020463c <wait_current_set>
ffffffffc02044a0:	c14fc0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc02044a4:	b765                	j	ffffffffc020444c <__down.constprop.0+0x32>
    wait_current_del(&(sem->wait_queue), wait);
ffffffffc02044a6:	85a2                	mv	a1,s0
ffffffffc02044a8:	8526                	mv	a0,s1
ffffffffc02044aa:	0e8000ef          	jal	ffffffffc0204592 <wait_queue_del>
    if (flag) {
ffffffffc02044ae:	bf4d                	j	ffffffffc0204460 <__down.constprop.0+0x46>
        intr_disable();
ffffffffc02044b0:	c0afc0ef          	jal	ffffffffc02008ba <intr_disable>
ffffffffc02044b4:	8522                	mv	a0,s0
ffffffffc02044b6:	12a000ef          	jal	ffffffffc02045e0 <wait_in_queue>
ffffffffc02044ba:	e501                	bnez	a0,ffffffffc02044c2 <__down.constprop.0+0xa8>
        intr_enable();
ffffffffc02044bc:	bf8fc0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc02044c0:	b745                	j	ffffffffc0204460 <__down.constprop.0+0x46>
ffffffffc02044c2:	85a2                	mv	a1,s0
ffffffffc02044c4:	8526                	mv	a0,s1
ffffffffc02044c6:	0cc000ef          	jal	ffffffffc0204592 <wait_queue_del>
    if (flag) {
ffffffffc02044ca:	bfcd                	j	ffffffffc02044bc <__down.constprop.0+0xa2>

ffffffffc02044cc <__up.constprop.0>:
static __noinline void __up(semaphore_t *sem, uint32_t wait_state) {
ffffffffc02044cc:	1101                	addi	sp,sp,-32
ffffffffc02044ce:	e426                	sd	s1,8(sp)
ffffffffc02044d0:	ec06                	sd	ra,24(sp)
ffffffffc02044d2:	e822                	sd	s0,16(sp)
ffffffffc02044d4:	e04a                	sd	s2,0(sp)
ffffffffc02044d6:	84aa                	mv	s1,a0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02044d8:	100027f3          	csrr	a5,sstatus
ffffffffc02044dc:	8b89                	andi	a5,a5,2
ffffffffc02044de:	4901                	li	s2,0
ffffffffc02044e0:	e7b1                	bnez	a5,ffffffffc020452c <__up.constprop.0+0x60>
        if ((wait = wait_queue_first(&(sem->wait_queue))) == NULL) {
ffffffffc02044e2:	00848413          	addi	s0,s1,8
ffffffffc02044e6:	8522                	mv	a0,s0
ffffffffc02044e8:	0e8000ef          	jal	ffffffffc02045d0 <wait_queue_first>
ffffffffc02044ec:	cd05                	beqz	a0,ffffffffc0204524 <__up.constprop.0+0x58>
            assert(wait->proc->wait_state == wait_state);
ffffffffc02044ee:	6118                	ld	a4,0(a0)
ffffffffc02044f0:	10000793          	li	a5,256
ffffffffc02044f4:	0ec72603          	lw	a2,236(a4)
ffffffffc02044f8:	02f61e63          	bne	a2,a5,ffffffffc0204534 <__up.constprop.0+0x68>
            wakeup_wait(&(sem->wait_queue), wait, wait_state, 1);
ffffffffc02044fc:	85aa                	mv	a1,a0
ffffffffc02044fe:	4685                	li	a3,1
ffffffffc0204500:	8522                	mv	a0,s0
ffffffffc0204502:	0ec000ef          	jal	ffffffffc02045ee <wakeup_wait>
    if (flag) {
ffffffffc0204506:	00091863          	bnez	s2,ffffffffc0204516 <__up.constprop.0+0x4a>
}
ffffffffc020450a:	60e2                	ld	ra,24(sp)
ffffffffc020450c:	6442                	ld	s0,16(sp)
ffffffffc020450e:	64a2                	ld	s1,8(sp)
ffffffffc0204510:	6902                	ld	s2,0(sp)
ffffffffc0204512:	6105                	addi	sp,sp,32
ffffffffc0204514:	8082                	ret
ffffffffc0204516:	6442                	ld	s0,16(sp)
ffffffffc0204518:	60e2                	ld	ra,24(sp)
ffffffffc020451a:	64a2                	ld	s1,8(sp)
ffffffffc020451c:	6902                	ld	s2,0(sp)
ffffffffc020451e:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0204520:	b94fc06f          	j	ffffffffc02008b4 <intr_enable>
            sem->value ++;
ffffffffc0204524:	409c                	lw	a5,0(s1)
ffffffffc0204526:	2785                	addiw	a5,a5,1
ffffffffc0204528:	c09c                	sw	a5,0(s1)
ffffffffc020452a:	bff1                	j	ffffffffc0204506 <__up.constprop.0+0x3a>
        intr_disable();
ffffffffc020452c:	b8efc0ef          	jal	ffffffffc02008ba <intr_disable>
        return 1;
ffffffffc0204530:	4905                	li	s2,1
ffffffffc0204532:	bf45                	j	ffffffffc02044e2 <__up.constprop.0+0x16>
            assert(wait->proc->wait_state == wait_state);
ffffffffc0204534:	00004697          	auipc	a3,0x4
ffffffffc0204538:	98468693          	addi	a3,a3,-1660 # ffffffffc0207eb8 <etext+0x1b74>
ffffffffc020453c:	00002617          	auipc	a2,0x2
ffffffffc0204540:	7bc60613          	addi	a2,a2,1980 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0204544:	45e5                	li	a1,25
ffffffffc0204546:	00004517          	auipc	a0,0x4
ffffffffc020454a:	99a50513          	addi	a0,a0,-1638 # ffffffffc0207ee0 <etext+0x1b9c>
ffffffffc020454e:	efdfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204552 <sem_init>:
    sem->value = value;
ffffffffc0204552:	c10c                	sw	a1,0(a0)
    wait_queue_init(&(sem->wait_queue));
ffffffffc0204554:	0521                	addi	a0,a0,8
ffffffffc0204556:	a81d                	j	ffffffffc020458c <wait_queue_init>

ffffffffc0204558 <up>:

void
up(semaphore_t *sem) {
    __up(sem, WT_KSEM);
ffffffffc0204558:	f75ff06f          	j	ffffffffc02044cc <__up.constprop.0>

ffffffffc020455c <down>:
}

void
down(semaphore_t *sem) {
ffffffffc020455c:	1141                	addi	sp,sp,-16
ffffffffc020455e:	e406                	sd	ra,8(sp)
    uint32_t flags = __down(sem, WT_KSEM);
ffffffffc0204560:	ebbff0ef          	jal	ffffffffc020441a <__down.constprop.0>
    assert(flags == 0);
ffffffffc0204564:	e501                	bnez	a0,ffffffffc020456c <down+0x10>
}
ffffffffc0204566:	60a2                	ld	ra,8(sp)
ffffffffc0204568:	0141                	addi	sp,sp,16
ffffffffc020456a:	8082                	ret
    assert(flags == 0);
ffffffffc020456c:	00004697          	auipc	a3,0x4
ffffffffc0204570:	98468693          	addi	a3,a3,-1660 # ffffffffc0207ef0 <etext+0x1bac>
ffffffffc0204574:	00002617          	auipc	a2,0x2
ffffffffc0204578:	78460613          	addi	a2,a2,1924 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc020457c:	04000593          	li	a1,64
ffffffffc0204580:	00004517          	auipc	a0,0x4
ffffffffc0204584:	96050513          	addi	a0,a0,-1696 # ffffffffc0207ee0 <etext+0x1b9c>
ffffffffc0204588:	ec3fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020458c <wait_queue_init>:
    elm->prev = elm->next = elm;
ffffffffc020458c:	e508                	sd	a0,8(a0)
ffffffffc020458e:	e108                	sd	a0,0(a0)
}

void
wait_queue_init(wait_queue_t *queue) {
    list_init(&(queue->wait_head));
}
ffffffffc0204590:	8082                	ret

ffffffffc0204592 <wait_queue_del>:
    return list->next == list;
ffffffffc0204592:	7198                	ld	a4,32(a1)
    list_add_before(&(queue->wait_head), &(wait->wait_link));
}

void
wait_queue_del(wait_queue_t *queue, wait_t *wait) {
    assert(!list_empty(&(wait->wait_link)) && wait->wait_queue == queue);
ffffffffc0204594:	01858793          	addi	a5,a1,24
ffffffffc0204598:	00e78b63          	beq	a5,a4,ffffffffc02045ae <wait_queue_del+0x1c>
ffffffffc020459c:	6994                	ld	a3,16(a1)
ffffffffc020459e:	00a69863          	bne	a3,a0,ffffffffc02045ae <wait_queue_del+0x1c>
    __list_del(listelm->prev, listelm->next);
ffffffffc02045a2:	6d94                	ld	a3,24(a1)
    prev->next = next;
ffffffffc02045a4:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc02045a6:	e314                	sd	a3,0(a4)
    elm->prev = elm->next = elm;
ffffffffc02045a8:	f19c                	sd	a5,32(a1)
ffffffffc02045aa:	ed9c                	sd	a5,24(a1)
ffffffffc02045ac:	8082                	ret
wait_queue_del(wait_queue_t *queue, wait_t *wait) {
ffffffffc02045ae:	1141                	addi	sp,sp,-16
    assert(!list_empty(&(wait->wait_link)) && wait->wait_queue == queue);
ffffffffc02045b0:	00004697          	auipc	a3,0x4
ffffffffc02045b4:	9a068693          	addi	a3,a3,-1632 # ffffffffc0207f50 <etext+0x1c0c>
ffffffffc02045b8:	00002617          	auipc	a2,0x2
ffffffffc02045bc:	74060613          	addi	a2,a2,1856 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02045c0:	45f1                	li	a1,28
ffffffffc02045c2:	00004517          	auipc	a0,0x4
ffffffffc02045c6:	97650513          	addi	a0,a0,-1674 # ffffffffc0207f38 <etext+0x1bf4>
wait_queue_del(wait_queue_t *queue, wait_t *wait) {
ffffffffc02045ca:	e406                	sd	ra,8(sp)
    assert(!list_empty(&(wait->wait_link)) && wait->wait_queue == queue);
ffffffffc02045cc:	e7ffb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02045d0 <wait_queue_first>:
    return listelm->next;
ffffffffc02045d0:	651c                	ld	a5,8(a0)
}

wait_t *
wait_queue_first(wait_queue_t *queue) {
    list_entry_t *le = list_next(&(queue->wait_head));
    if (le != &(queue->wait_head)) {
ffffffffc02045d2:	00f50563          	beq	a0,a5,ffffffffc02045dc <wait_queue_first+0xc>
        return le2wait(le, wait_link);
ffffffffc02045d6:	fe878513          	addi	a0,a5,-24
ffffffffc02045da:	8082                	ret
    }
    return NULL;
ffffffffc02045dc:	4501                	li	a0,0
}
ffffffffc02045de:	8082                	ret

ffffffffc02045e0 <wait_in_queue>:
    return list_empty(&(queue->wait_head));
}

bool
wait_in_queue(wait_t *wait) {
    return !list_empty(&(wait->wait_link));
ffffffffc02045e0:	711c                	ld	a5,32(a0)
ffffffffc02045e2:	0561                	addi	a0,a0,24
ffffffffc02045e4:	40a78533          	sub	a0,a5,a0
}
ffffffffc02045e8:	00a03533          	snez	a0,a0
ffffffffc02045ec:	8082                	ret

ffffffffc02045ee <wakeup_wait>:

void
wakeup_wait(wait_queue_t *queue, wait_t *wait, uint32_t wakeup_flags, bool del) {
    if (del) {
ffffffffc02045ee:	e689                	bnez	a3,ffffffffc02045f8 <wakeup_wait+0xa>
        wait_queue_del(queue, wait);
    }
    wait->wakeup_flags = wakeup_flags;
    wakeup_proc(wait->proc);
ffffffffc02045f0:	6188                	ld	a0,0(a1)
    wait->wakeup_flags = wakeup_flags;
ffffffffc02045f2:	c590                	sw	a2,8(a1)
    wakeup_proc(wait->proc);
ffffffffc02045f4:	6300106f          	j	ffffffffc0205c24 <wakeup_proc>
    return list->next == list;
ffffffffc02045f8:	7198                	ld	a4,32(a1)
    assert(!list_empty(&(wait->wait_link)) && wait->wait_queue == queue);
ffffffffc02045fa:	01858793          	addi	a5,a1,24
ffffffffc02045fe:	00e78e63          	beq	a5,a4,ffffffffc020461a <wakeup_wait+0x2c>
ffffffffc0204602:	6994                	ld	a3,16(a1)
ffffffffc0204604:	00d51b63          	bne	a0,a3,ffffffffc020461a <wakeup_wait+0x2c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204608:	6d94                	ld	a3,24(a1)
    wakeup_proc(wait->proc);
ffffffffc020460a:	6188                	ld	a0,0(a1)
    prev->next = next;
ffffffffc020460c:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc020460e:	e314                	sd	a3,0(a4)
    elm->prev = elm->next = elm;
ffffffffc0204610:	f19c                	sd	a5,32(a1)
ffffffffc0204612:	ed9c                	sd	a5,24(a1)
    wait->wakeup_flags = wakeup_flags;
ffffffffc0204614:	c590                	sw	a2,8(a1)
    wakeup_proc(wait->proc);
ffffffffc0204616:	60e0106f          	j	ffffffffc0205c24 <wakeup_proc>
wakeup_wait(wait_queue_t *queue, wait_t *wait, uint32_t wakeup_flags, bool del) {
ffffffffc020461a:	1141                	addi	sp,sp,-16
    assert(!list_empty(&(wait->wait_link)) && wait->wait_queue == queue);
ffffffffc020461c:	00004697          	auipc	a3,0x4
ffffffffc0204620:	93468693          	addi	a3,a3,-1740 # ffffffffc0207f50 <etext+0x1c0c>
ffffffffc0204624:	00002617          	auipc	a2,0x2
ffffffffc0204628:	6d460613          	addi	a2,a2,1748 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc020462c:	45f1                	li	a1,28
ffffffffc020462e:	00004517          	auipc	a0,0x4
ffffffffc0204632:	90a50513          	addi	a0,a0,-1782 # ffffffffc0207f38 <etext+0x1bf4>
wakeup_wait(wait_queue_t *queue, wait_t *wait, uint32_t wakeup_flags, bool del) {
ffffffffc0204636:	e406                	sd	ra,8(sp)
    assert(!list_empty(&(wait->wait_link)) && wait->wait_queue == queue);
ffffffffc0204638:	e13fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020463c <wait_current_set>:
    }
}

void
wait_current_set(wait_queue_t *queue, wait_t *wait, uint32_t wait_state) {
    assert(current != NULL);
ffffffffc020463c:	000c8797          	auipc	a5,0xc8
ffffffffc0204640:	c647b783          	ld	a5,-924(a5) # ffffffffc02cc2a0 <current>
ffffffffc0204644:	c39d                	beqz	a5,ffffffffc020466a <wait_current_set+0x2e>
    wait->wakeup_flags = WT_INTERRUPTED;
ffffffffc0204646:	80000737          	lui	a4,0x80000
ffffffffc020464a:	c598                	sw	a4,8(a1)
    list_init(&(wait->wait_link));
ffffffffc020464c:	01858713          	addi	a4,a1,24
ffffffffc0204650:	ed98                	sd	a4,24(a1)
    wait->proc = proc;
ffffffffc0204652:	e19c                	sd	a5,0(a1)
    wait_init(wait, current);
    current->state = PROC_SLEEPING;
    current->wait_state = wait_state;
ffffffffc0204654:	0ec7a623          	sw	a2,236(a5)
    current->state = PROC_SLEEPING;
ffffffffc0204658:	4605                	li	a2,1
    __list_add(elm, listelm->prev, listelm);
ffffffffc020465a:	6114                	ld	a3,0(a0)
ffffffffc020465c:	c390                	sw	a2,0(a5)
    wait->wait_queue = queue;
ffffffffc020465e:	e988                	sd	a0,16(a1)
    prev->next = next->prev = elm;
ffffffffc0204660:	e118                	sd	a4,0(a0)
ffffffffc0204662:	e698                	sd	a4,8(a3)
    elm->prev = prev;
ffffffffc0204664:	ed94                	sd	a3,24(a1)
    elm->next = next;
ffffffffc0204666:	f188                	sd	a0,32(a1)
ffffffffc0204668:	8082                	ret
wait_current_set(wait_queue_t *queue, wait_t *wait, uint32_t wait_state) {
ffffffffc020466a:	1141                	addi	sp,sp,-16
    assert(current != NULL);
ffffffffc020466c:	00004697          	auipc	a3,0x4
ffffffffc0204670:	92468693          	addi	a3,a3,-1756 # ffffffffc0207f90 <etext+0x1c4c>
ffffffffc0204674:	00002617          	auipc	a2,0x2
ffffffffc0204678:	68460613          	addi	a2,a2,1668 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc020467c:	07400593          	li	a1,116
ffffffffc0204680:	00004517          	auipc	a0,0x4
ffffffffc0204684:	8b850513          	addi	a0,a0,-1864 # ffffffffc0207f38 <etext+0x1bf4>
wait_current_set(wait_queue_t *queue, wait_t *wait, uint32_t wait_state) {
ffffffffc0204688:	e406                	sd	ra,8(sp)
    assert(current != NULL);
ffffffffc020468a:	dc1fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020468e <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc020468e:	8526                	mv	a0,s1
	jalr s0
ffffffffc0204690:	9402                	jalr	s0

	jal do_exit
ffffffffc0204692:	67e000ef          	jal	ffffffffc0204d10 <do_exit>

ffffffffc0204696 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0204696:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0204698:	14800513          	li	a0,328
{
ffffffffc020469c:	e022                	sd	s0,0(sp)
ffffffffc020469e:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02046a0:	cd0fd0ef          	jal	ffffffffc0201b70 <kmalloc>
ffffffffc02046a4:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc02046a6:	c141                	beqz	a0,ffffffffc0204726 <alloc_proc+0x90>
         *       struct trapframe *tf;                       // Trap frame for current interrupt
         *       uintptr_t pgdir;                            // the base addr of Page Directroy Table(PDT)
         *       uint32_t flags;                             // Process flag
         *       char name[PROC_NAME_LEN + 1];               // Process name
         */
        proc->state = PROC_UNINIT;
ffffffffc02046a8:	57fd                	li	a5,-1
ffffffffc02046aa:	1782                	slli	a5,a5,0x20
ffffffffc02046ac:	e11c                	sd	a5,0(a0)
        proc->pid = -1;
        proc->runs = 0;
ffffffffc02046ae:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc02046b2:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc02046b6:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc02046ba:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc02046be:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc02046c2:	07000613          	li	a2,112
ffffffffc02046c6:	4581                	li	a1,0
ffffffffc02046c8:	03050513          	addi	a0,a0,48
ffffffffc02046cc:	44f010ef          	jal	ffffffffc020631a <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc02046d0:	000c8797          	auipc	a5,0xc8
ffffffffc02046d4:	ba07b783          	ld	a5,-1120(a5) # ffffffffc02cc270 <boot_pgdir_pa>
        proc->tf = NULL;
ffffffffc02046d8:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc02046dc:	0a042823          	sw	zero,176(s0)
        proc->pgdir = boot_pgdir_pa;
ffffffffc02046e0:	f45c                	sd	a5,168(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1);
ffffffffc02046e2:	0b440513          	addi	a0,s0,180
ffffffffc02046e6:	4641                	li	a2,16
ffffffffc02046e8:	4581                	li	a1,0
ffffffffc02046ea:	431010ef          	jal	ffffffffc020631a <memset>
        list_init(&(proc->run_link));        // 初始化运行队列链表项
        proc->time_slice = 0;                // 初始化时间片为0
        proc->lab6_run_pool.parent = NULL;   // 初始化斜堆父指针
        proc->lab6_run_pool.left = NULL;     // 初始化斜堆左孩子
        proc->lab6_run_pool.right = NULL;    // 初始化斜堆右孩子
        proc->lab6_stride = 0;               // 初始化stride值为0
ffffffffc02046ee:	4785                	li	a5,1
        list_init(&(proc->run_link));        // 初始化运行队列链表项
ffffffffc02046f0:	11040713          	addi	a4,s0,272
        proc->lab6_stride = 0;               // 初始化stride值为0
ffffffffc02046f4:	1782                	slli	a5,a5,0x20
        proc->exit_code = 0;
ffffffffc02046f6:	0e043423          	sd	zero,232(s0)
        proc->cptr = proc->yptr = proc->optr = NULL;
ffffffffc02046fa:	0e043823          	sd	zero,240(s0)
ffffffffc02046fe:	0e043c23          	sd	zero,248(s0)
ffffffffc0204702:	10043023          	sd	zero,256(s0)
        proc->rq = NULL;                     // 初始化运行队列为空
ffffffffc0204706:	10043423          	sd	zero,264(s0)
        proc->time_slice = 0;                // 初始化时间片为0
ffffffffc020470a:	12042023          	sw	zero,288(s0)
        proc->lab6_run_pool.parent = NULL;   // 初始化斜堆父指针
ffffffffc020470e:	12043423          	sd	zero,296(s0)
        proc->lab6_run_pool.left = NULL;     // 初始化斜堆左孩子
ffffffffc0204712:	12043823          	sd	zero,304(s0)
        proc->lab6_run_pool.right = NULL;    // 初始化斜堆右孩子
ffffffffc0204716:	12043c23          	sd	zero,312(s0)
        proc->lab6_stride = 0;               // 初始化stride值为0
ffffffffc020471a:	14f43023          	sd	a5,320(s0)
    elm->prev = elm->next = elm;
ffffffffc020471e:	10e43c23          	sd	a4,280(s0)
ffffffffc0204722:	10e43823          	sd	a4,272(s0)
        proc->lab6_priority = 1;             // 初始化优先级为1（默认值）
    }
    return proc;
}
ffffffffc0204726:	60a2                	ld	ra,8(sp)
ffffffffc0204728:	8522                	mv	a0,s0
ffffffffc020472a:	6402                	ld	s0,0(sp)
ffffffffc020472c:	0141                	addi	sp,sp,16
ffffffffc020472e:	8082                	ret

ffffffffc0204730 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0204730:	000c8797          	auipc	a5,0xc8
ffffffffc0204734:	b707b783          	ld	a5,-1168(a5) # ffffffffc02cc2a0 <current>
ffffffffc0204738:	73c8                	ld	a0,160(a5)
ffffffffc020473a:	ec4fc06f          	j	ffffffffc0200dfe <forkrets>

ffffffffc020473e <put_pgdir.isra.0>:
    return 0;
}

// put_pgdir - free the memory space of PDT
static void
put_pgdir(struct mm_struct *mm)
ffffffffc020473e:	1141                	addi	sp,sp,-16
ffffffffc0204740:	e406                	sd	ra,8(sp)
    return pa2page(PADDR(kva));
ffffffffc0204742:	c02007b7          	lui	a5,0xc0200
ffffffffc0204746:	02f56f63          	bltu	a0,a5,ffffffffc0204784 <put_pgdir.isra.0+0x46>
ffffffffc020474a:	000c8797          	auipc	a5,0xc8
ffffffffc020474e:	b367b783          	ld	a5,-1226(a5) # ffffffffc02cc280 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0204752:	000c8717          	auipc	a4,0xc8
ffffffffc0204756:	b3673703          	ld	a4,-1226(a4) # ffffffffc02cc288 <npage>
    return pa2page(PADDR(kva));
ffffffffc020475a:	8d1d                	sub	a0,a0,a5
    if (PPN(pa) >= npage)
ffffffffc020475c:	00c55793          	srli	a5,a0,0xc
ffffffffc0204760:	02e7ff63          	bgeu	a5,a4,ffffffffc020479e <put_pgdir.isra.0+0x60>
    return &pages[PPN(pa) - nbase];
ffffffffc0204764:	00005717          	auipc	a4,0x5
ffffffffc0204768:	93473703          	ld	a4,-1740(a4) # ffffffffc0209098 <nbase>
ffffffffc020476c:	000c8517          	auipc	a0,0xc8
ffffffffc0204770:	b2453503          	ld	a0,-1244(a0) # ffffffffc02cc290 <pages>
{
    free_page(kva2page(mm->pgdir));
}
ffffffffc0204774:	60a2                	ld	ra,8(sp)
ffffffffc0204776:	8f99                	sub	a5,a5,a4
ffffffffc0204778:	079a                	slli	a5,a5,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc020477a:	4585                	li	a1,1
ffffffffc020477c:	953e                	add	a0,a0,a5
}
ffffffffc020477e:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0204780:	decfd06f          	j	ffffffffc0201d6c <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0204784:	86aa                	mv	a3,a0
ffffffffc0204786:	00003617          	auipc	a2,0x3
ffffffffc020478a:	9ca60613          	addi	a2,a2,-1590 # ffffffffc0207150 <etext+0xe0c>
ffffffffc020478e:	07700593          	li	a1,119
ffffffffc0204792:	00003517          	auipc	a0,0x3
ffffffffc0204796:	93e50513          	addi	a0,a0,-1730 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc020479a:	cb1fb0ef          	jal	ffffffffc020044a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020479e:	00003617          	auipc	a2,0x3
ffffffffc02047a2:	9da60613          	addi	a2,a2,-1574 # ffffffffc0207178 <etext+0xe34>
ffffffffc02047a6:	06900593          	li	a1,105
ffffffffc02047aa:	00003517          	auipc	a0,0x3
ffffffffc02047ae:	92650513          	addi	a0,a0,-1754 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc02047b2:	c99fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02047b6 <set_proc_name>:
{
ffffffffc02047b6:	1101                	addi	sp,sp,-32
ffffffffc02047b8:	e822                	sd	s0,16(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02047ba:	0b450413          	addi	s0,a0,180
{
ffffffffc02047be:	e426                	sd	s1,8(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02047c0:	8522                	mv	a0,s0
{
ffffffffc02047c2:	84ae                	mv	s1,a1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02047c4:	4641                	li	a2,16
ffffffffc02047c6:	4581                	li	a1,0
{
ffffffffc02047c8:	ec06                	sd	ra,24(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02047ca:	351010ef          	jal	ffffffffc020631a <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02047ce:	8522                	mv	a0,s0
}
ffffffffc02047d0:	6442                	ld	s0,16(sp)
ffffffffc02047d2:	60e2                	ld	ra,24(sp)
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02047d4:	85a6                	mv	a1,s1
}
ffffffffc02047d6:	64a2                	ld	s1,8(sp)
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02047d8:	463d                	li	a2,15
}
ffffffffc02047da:	6105                	addi	sp,sp,32
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02047dc:	3510106f          	j	ffffffffc020632c <memcpy>

ffffffffc02047e0 <proc_run>:
    if (proc != current)
ffffffffc02047e0:	000c8697          	auipc	a3,0xc8
ffffffffc02047e4:	ac06b683          	ld	a3,-1344(a3) # ffffffffc02cc2a0 <current>
ffffffffc02047e8:	04a68463          	beq	a3,a0,ffffffffc0204830 <proc_run+0x50>
{
ffffffffc02047ec:	1101                	addi	sp,sp,-32
ffffffffc02047ee:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02047f0:	100027f3          	csrr	a5,sstatus
ffffffffc02047f4:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02047f6:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02047f8:	ef8d                	bnez	a5,ffffffffc0204832 <proc_run+0x52>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc02047fa:	755c                	ld	a5,168(a0)
ffffffffc02047fc:	577d                	li	a4,-1
ffffffffc02047fe:	177e                	slli	a4,a4,0x3f
ffffffffc0204800:	83b1                	srli	a5,a5,0xc
ffffffffc0204802:	e032                	sd	a2,0(sp)
            current = proc;
ffffffffc0204804:	000c8597          	auipc	a1,0xc8
ffffffffc0204808:	a8a5be23          	sd	a0,-1380(a1) # ffffffffc02cc2a0 <current>
ffffffffc020480c:	8fd9                	or	a5,a5,a4
ffffffffc020480e:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(proc->context));
ffffffffc0204812:	03050593          	addi	a1,a0,48
ffffffffc0204816:	03068513          	addi	a0,a3,48
ffffffffc020481a:	25a010ef          	jal	ffffffffc0205a74 <switch_to>
    if (flag) {
ffffffffc020481e:	6602                	ld	a2,0(sp)
ffffffffc0204820:	e601                	bnez	a2,ffffffffc0204828 <proc_run+0x48>
}
ffffffffc0204822:	60e2                	ld	ra,24(sp)
ffffffffc0204824:	6105                	addi	sp,sp,32
ffffffffc0204826:	8082                	ret
ffffffffc0204828:	60e2                	ld	ra,24(sp)
ffffffffc020482a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020482c:	888fc06f          	j	ffffffffc02008b4 <intr_enable>
ffffffffc0204830:	8082                	ret
ffffffffc0204832:	e42a                	sd	a0,8(sp)
ffffffffc0204834:	e036                	sd	a3,0(sp)
        intr_disable();
ffffffffc0204836:	884fc0ef          	jal	ffffffffc02008ba <intr_disable>
        return 1;
ffffffffc020483a:	6522                	ld	a0,8(sp)
ffffffffc020483c:	6682                	ld	a3,0(sp)
ffffffffc020483e:	4605                	li	a2,1
ffffffffc0204840:	bf6d                	j	ffffffffc02047fa <proc_run+0x1a>

ffffffffc0204842 <find_proc>:
    if (0 < pid && pid < MAX_PID)
ffffffffc0204842:	6789                	lui	a5,0x2
ffffffffc0204844:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204848:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x70e2>
ffffffffc020484a:	02e7ef63          	bltu	a5,a4,ffffffffc0204888 <find_proc+0x46>
{
ffffffffc020484e:	1101                	addi	sp,sp,-32
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204850:	45a9                	li	a1,10
{
ffffffffc0204852:	ec06                	sd	ra,24(sp)
ffffffffc0204854:	e42a                	sd	a0,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204856:	62e010ef          	jal	ffffffffc0205e84 <hash32>
ffffffffc020485a:	02051793          	slli	a5,a0,0x20
ffffffffc020485e:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204862:	000c4797          	auipc	a5,0xc4
ffffffffc0204866:	99e78793          	addi	a5,a5,-1634 # ffffffffc02c8200 <hash_list>
ffffffffc020486a:	96be                	add	a3,a3,a5
        while ((le = list_next(le)) != list)
ffffffffc020486c:	6622                	ld	a2,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc020486e:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0204870:	a029                	j	ffffffffc020487a <find_proc+0x38>
            if (proc->pid == pid)
ffffffffc0204872:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204876:	00c70b63          	beq	a4,a2,ffffffffc020488c <find_proc+0x4a>
    return listelm->next;
ffffffffc020487a:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020487c:	fef69be3          	bne	a3,a5,ffffffffc0204872 <find_proc+0x30>
}
ffffffffc0204880:	60e2                	ld	ra,24(sp)
    return NULL;
ffffffffc0204882:	4501                	li	a0,0
}
ffffffffc0204884:	6105                	addi	sp,sp,32
ffffffffc0204886:	8082                	ret
    return NULL;
ffffffffc0204888:	4501                	li	a0,0
}
ffffffffc020488a:	8082                	ret
ffffffffc020488c:	60e2                	ld	ra,24(sp)
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc020488e:	f2878513          	addi	a0,a5,-216
}
ffffffffc0204892:	6105                	addi	sp,sp,32
ffffffffc0204894:	8082                	ret

ffffffffc0204896 <do_fork>:
 */
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf)
{
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS)
ffffffffc0204896:	000c8717          	auipc	a4,0xc8
ffffffffc020489a:	a0672703          	lw	a4,-1530(a4) # ffffffffc02cc29c <nr_process>
ffffffffc020489e:	6785                	lui	a5,0x1
ffffffffc02048a0:	36f75763          	bge	a4,a5,ffffffffc0204c0e <do_fork+0x378>
{
ffffffffc02048a4:	7159                	addi	sp,sp,-112
ffffffffc02048a6:	f0a2                	sd	s0,96(sp)
ffffffffc02048a8:	eca6                	sd	s1,88(sp)
ffffffffc02048aa:	e8ca                	sd	s2,80(sp)
ffffffffc02048ac:	ec66                	sd	s9,24(sp)
ffffffffc02048ae:	f486                	sd	ra,104(sp)
ffffffffc02048b0:	892e                	mv	s2,a1
ffffffffc02048b2:	84b2                	mv	s1,a2
ffffffffc02048b4:	8caa                	mv	s9,a0
     *   proc_list:    the process set's list
     *   nr_process:   the number of process set
     */

    //    1. call alloc_proc to allocate a proc_struct
    if ((proc = alloc_proc()) == NULL) {
ffffffffc02048b6:	de1ff0ef          	jal	ffffffffc0204696 <alloc_proc>
ffffffffc02048ba:	842a                	mv	s0,a0
ffffffffc02048bc:	34050163          	beqz	a0,ffffffffc0204bfe <do_fork+0x368>
        goto fork_out;
    }
    proc->parent = current;
ffffffffc02048c0:	fc56                	sd	s5,56(sp)
ffffffffc02048c2:	000c8a97          	auipc	s5,0xc8
ffffffffc02048c6:	9dea8a93          	addi	s5,s5,-1570 # ffffffffc02cc2a0 <current>
ffffffffc02048ca:	000ab783          	ld	a5,0(s5)
    assert(current->wait_state == 0);
ffffffffc02048ce:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_obj___user_softint_out_size-0x7ff4>
    proc->parent = current;
ffffffffc02048d2:	f11c                	sd	a5,32(a0)
    assert(current->wait_state == 0);
ffffffffc02048d4:	32071f63          	bnez	a4,ffffffffc0204c12 <do_fork+0x37c>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc02048d8:	4509                	li	a0,2
ffffffffc02048da:	c58fd0ef          	jal	ffffffffc0201d32 <alloc_pages>
    if (page != NULL)
ffffffffc02048de:	30050c63          	beqz	a0,ffffffffc0204bf6 <do_fork+0x360>
    return page - pages + nbase;
ffffffffc02048e2:	f85a                	sd	s6,48(sp)
ffffffffc02048e4:	000c8b17          	auipc	s6,0xc8
ffffffffc02048e8:	9acb0b13          	addi	s6,s6,-1620 # ffffffffc02cc290 <pages>
ffffffffc02048ec:	000b3783          	ld	a5,0(s6)
ffffffffc02048f0:	e4ce                	sd	s3,72(sp)
ffffffffc02048f2:	00004997          	auipc	s3,0x4
ffffffffc02048f6:	7a69b983          	ld	s3,1958(s3) # ffffffffc0209098 <nbase>
ffffffffc02048fa:	40f506b3          	sub	a3,a0,a5
ffffffffc02048fe:	f45e                	sd	s7,40(sp)
    return KADDR(page2pa(page));
ffffffffc0204900:	000c8b97          	auipc	s7,0xc8
ffffffffc0204904:	988b8b93          	addi	s7,s7,-1656 # ffffffffc02cc288 <npage>
    return page - pages + nbase;
ffffffffc0204908:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020490a:	57fd                	li	a5,-1
ffffffffc020490c:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204910:	96ce                	add	a3,a3,s3
    return KADDR(page2pa(page));
ffffffffc0204912:	83b1                	srli	a5,a5,0xc
ffffffffc0204914:	00f6f633          	and	a2,a3,a5
ffffffffc0204918:	e0d2                	sd	s4,64(sp)
ffffffffc020491a:	f062                	sd	s8,32(sp)
    return page2ppn(page) << PGSHIFT;
ffffffffc020491c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020491e:	34e67b63          	bgeu	a2,a4,ffffffffc0204c74 <do_fork+0x3de>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204922:	000ab603          	ld	a2,0(s5)
ffffffffc0204926:	000c8c17          	auipc	s8,0xc8
ffffffffc020492a:	95ac0c13          	addi	s8,s8,-1702 # ffffffffc02cc280 <va_pa_offset>
ffffffffc020492e:	000c3703          	ld	a4,0(s8)
ffffffffc0204932:	02863a03          	ld	s4,40(a2)
ffffffffc0204936:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0204938:	e814                	sd	a3,16(s0)
    if (oldmm == NULL)
ffffffffc020493a:	020a0863          	beqz	s4,ffffffffc020496a <do_fork+0xd4>
    if (clone_flags & CLONE_VM)
ffffffffc020493e:	100cf713          	andi	a4,s9,256
ffffffffc0204942:	18070a63          	beqz	a4,ffffffffc0204ad6 <do_fork+0x240>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc0204946:	030a2703          	lw	a4,48(s4)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020494a:	018a3783          	ld	a5,24(s4)
ffffffffc020494e:	c02006b7          	lui	a3,0xc0200
ffffffffc0204952:	2705                	addiw	a4,a4,1
ffffffffc0204954:	02ea2823          	sw	a4,48(s4)
    proc->mm = mm;
ffffffffc0204958:	03443423          	sd	s4,40(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020495c:	2ed7ee63          	bltu	a5,a3,ffffffffc0204c58 <do_fork+0x3c2>
ffffffffc0204960:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204964:	6814                	ld	a3,16(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204966:	8f99                	sub	a5,a5,a4
ffffffffc0204968:	f45c                	sd	a5,168(s0)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc020496a:	6789                	lui	a5,0x2
ffffffffc020496c:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_softint_out_size-0x7200>
ffffffffc0204970:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc0204972:	8626                	mv	a2,s1
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204974:	f054                	sd	a3,160(s0)
    *(proc->tf) = *tf;
ffffffffc0204976:	87b6                	mv	a5,a3
ffffffffc0204978:	12048713          	addi	a4,s1,288
ffffffffc020497c:	6a0c                	ld	a1,16(a2)
ffffffffc020497e:	00063803          	ld	a6,0(a2)
ffffffffc0204982:	6608                	ld	a0,8(a2)
ffffffffc0204984:	eb8c                	sd	a1,16(a5)
ffffffffc0204986:	0107b023          	sd	a6,0(a5)
ffffffffc020498a:	e788                	sd	a0,8(a5)
ffffffffc020498c:	6e0c                	ld	a1,24(a2)
ffffffffc020498e:	02060613          	addi	a2,a2,32
ffffffffc0204992:	02078793          	addi	a5,a5,32
ffffffffc0204996:	feb7bc23          	sd	a1,-8(a5)
ffffffffc020499a:	fee611e3          	bne	a2,a4,ffffffffc020497c <do_fork+0xe6>
    proc->tf->gpr.a0 = 0;
ffffffffc020499e:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02049a2:	1a090c63          	beqz	s2,ffffffffc0204b5a <do_fork+0x2c4>
ffffffffc02049a6:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02049aa:	00000797          	auipc	a5,0x0
ffffffffc02049ae:	d8678793          	addi	a5,a5,-634 # ffffffffc0204730 <forkret>
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02049b2:	fc14                	sd	a3,56(s0)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02049b4:	f81c                	sd	a5,48(s0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02049b6:	100027f3          	csrr	a5,sstatus
ffffffffc02049ba:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02049bc:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02049be:	1a079d63          	bnez	a5,ffffffffc0204b78 <do_fork+0x2e2>
    if (++last_pid >= MAX_PID)
ffffffffc02049c2:	000c3517          	auipc	a0,0xc3
ffffffffc02049c6:	2d252503          	lw	a0,722(a0) # ffffffffc02c7c94 <last_pid.1>
ffffffffc02049ca:	6789                	lui	a5,0x2
ffffffffc02049cc:	2505                	addiw	a0,a0,1
ffffffffc02049ce:	000c3717          	auipc	a4,0xc3
ffffffffc02049d2:	2ca72323          	sw	a0,710(a4) # ffffffffc02c7c94 <last_pid.1>
ffffffffc02049d6:	1cf55063          	bge	a0,a5,ffffffffc0204b96 <do_fork+0x300>
    if (last_pid >= next_safe)
ffffffffc02049da:	000c3797          	auipc	a5,0xc3
ffffffffc02049de:	2b67a783          	lw	a5,694(a5) # ffffffffc02c7c90 <next_safe.0>
ffffffffc02049e2:	000c8497          	auipc	s1,0xc8
ffffffffc02049e6:	81e48493          	addi	s1,s1,-2018 # ffffffffc02cc200 <proc_list>
ffffffffc02049ea:	06f54563          	blt	a0,a5,ffffffffc0204a54 <do_fork+0x1be>
ffffffffc02049ee:	000c8497          	auipc	s1,0xc8
ffffffffc02049f2:	81248493          	addi	s1,s1,-2030 # ffffffffc02cc200 <proc_list>
ffffffffc02049f6:	0084b883          	ld	a7,8(s1)
        next_safe = MAX_PID;
ffffffffc02049fa:	6789                	lui	a5,0x2
ffffffffc02049fc:	000c3717          	auipc	a4,0xc3
ffffffffc0204a00:	28f72a23          	sw	a5,660(a4) # ffffffffc02c7c90 <next_safe.0>
ffffffffc0204a04:	86aa                	mv	a3,a0
ffffffffc0204a06:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc0204a08:	04988063          	beq	a7,s1,ffffffffc0204a48 <do_fork+0x1b2>
ffffffffc0204a0c:	882e                	mv	a6,a1
ffffffffc0204a0e:	87c6                	mv	a5,a7
ffffffffc0204a10:	6609                	lui	a2,0x2
ffffffffc0204a12:	a811                	j	ffffffffc0204a26 <do_fork+0x190>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204a14:	00e6d663          	bge	a3,a4,ffffffffc0204a20 <do_fork+0x18a>
ffffffffc0204a18:	00c75463          	bge	a4,a2,ffffffffc0204a20 <do_fork+0x18a>
                next_safe = proc->pid;
ffffffffc0204a1c:	863a                	mv	a2,a4
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204a1e:	4805                	li	a6,1
ffffffffc0204a20:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204a22:	00978d63          	beq	a5,s1,ffffffffc0204a3c <do_fork+0x1a6>
            if (proc->pid == last_pid)
ffffffffc0204a26:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_softint_out_size-0x71a4>
ffffffffc0204a2a:	fee695e3          	bne	a3,a4,ffffffffc0204a14 <do_fork+0x17e>
                if (++last_pid >= next_safe)
ffffffffc0204a2e:	2685                	addiw	a3,a3,1
ffffffffc0204a30:	1cc6d963          	bge	a3,a2,ffffffffc0204c02 <do_fork+0x36c>
ffffffffc0204a34:	679c                	ld	a5,8(a5)
ffffffffc0204a36:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc0204a38:	fe9797e3          	bne	a5,s1,ffffffffc0204a26 <do_fork+0x190>
ffffffffc0204a3c:	00080663          	beqz	a6,ffffffffc0204a48 <do_fork+0x1b2>
ffffffffc0204a40:	000c3797          	auipc	a5,0xc3
ffffffffc0204a44:	24c7a823          	sw	a2,592(a5) # ffffffffc02c7c90 <next_safe.0>
ffffffffc0204a48:	c591                	beqz	a1,ffffffffc0204a54 <do_fork+0x1be>
ffffffffc0204a4a:	000c3797          	auipc	a5,0xc3
ffffffffc0204a4e:	24d7a523          	sw	a3,586(a5) # ffffffffc02c7c94 <last_pid.1>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204a52:	8536                	mv	a0,a3
    
    //    5. insert proc_struct into hash_list && proc_list
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        proc->pid = get_pid();
ffffffffc0204a54:	c048                	sw	a0,4(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204a56:	45a9                	li	a1,10
ffffffffc0204a58:	42c010ef          	jal	ffffffffc0205e84 <hash32>
ffffffffc0204a5c:	02051793          	slli	a5,a0,0x20
ffffffffc0204a60:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204a64:	000c3797          	auipc	a5,0xc3
ffffffffc0204a68:	79c78793          	addi	a5,a5,1948 # ffffffffc02c8200 <hash_list>
ffffffffc0204a6c:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0204a6e:	6518                	ld	a4,8(a0)
ffffffffc0204a70:	0d840793          	addi	a5,s0,216
ffffffffc0204a74:	6490                	ld	a2,8(s1)
    prev->next = next->prev = elm;
ffffffffc0204a76:	e31c                	sd	a5,0(a4)
ffffffffc0204a78:	e51c                	sd	a5,8(a0)
    elm->next = next;
ffffffffc0204a7a:	f078                	sd	a4,224(s0)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204a7c:	0c840793          	addi	a5,s0,200
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204a80:	7018                	ld	a4,32(s0)
    elm->prev = prev;
ffffffffc0204a82:	ec68                	sd	a0,216(s0)
    prev->next = next->prev = elm;
ffffffffc0204a84:	e21c                	sd	a5,0(a2)
    proc->yptr = NULL;
ffffffffc0204a86:	0e043c23          	sd	zero,248(s0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204a8a:	7b74                	ld	a3,240(a4)
ffffffffc0204a8c:	e49c                	sd	a5,8(s1)
    elm->next = next;
ffffffffc0204a8e:	e870                	sd	a2,208(s0)
    elm->prev = prev;
ffffffffc0204a90:	e464                	sd	s1,200(s0)
ffffffffc0204a92:	10d43023          	sd	a3,256(s0)
ffffffffc0204a96:	c299                	beqz	a3,ffffffffc0204a9c <do_fork+0x206>
        proc->optr->yptr = proc;
ffffffffc0204a98:	fee0                	sd	s0,248(a3)
    proc->parent->cptr = proc;
ffffffffc0204a9a:	7018                	ld	a4,32(s0)
    nr_process++;
ffffffffc0204a9c:	000c8797          	auipc	a5,0xc8
ffffffffc0204aa0:	8007a783          	lw	a5,-2048(a5) # ffffffffc02cc29c <nr_process>
    proc->parent->cptr = proc;
ffffffffc0204aa4:	fb60                	sd	s0,240(a4)
    nr_process++;
ffffffffc0204aa6:	2785                	addiw	a5,a5,1
ffffffffc0204aa8:	000c7717          	auipc	a4,0xc7
ffffffffc0204aac:	7ef72a23          	sw	a5,2036(a4) # ffffffffc02cc29c <nr_process>
    if (flag) {
ffffffffc0204ab0:	0e091963          	bnez	s2,ffffffffc0204ba2 <do_fork+0x30c>
        set_links(proc);
    }
    local_intr_restore(intr_flag);
    
    //    6. call wakeup_proc to make the new child process RUNNABLE
    wakeup_proc(proc);
ffffffffc0204ab4:	8522                	mv	a0,s0
ffffffffc0204ab6:	16e010ef          	jal	ffffffffc0205c24 <wakeup_proc>
    //    7. set ret vaule using child proc's pid
    ret = proc->pid;
ffffffffc0204aba:	4048                	lw	a0,4(s0)
ffffffffc0204abc:	69a6                	ld	s3,72(sp)
ffffffffc0204abe:	6a06                	ld	s4,64(sp)
ffffffffc0204ac0:	7ae2                	ld	s5,56(sp)
ffffffffc0204ac2:	7b42                	ld	s6,48(sp)
ffffffffc0204ac4:	7ba2                	ld	s7,40(sp)
ffffffffc0204ac6:	7c02                	ld	s8,32(sp)
bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
ffffffffc0204ac8:	70a6                	ld	ra,104(sp)
ffffffffc0204aca:	7406                	ld	s0,96(sp)
ffffffffc0204acc:	64e6                	ld	s1,88(sp)
ffffffffc0204ace:	6946                	ld	s2,80(sp)
ffffffffc0204ad0:	6ce2                	ld	s9,24(sp)
ffffffffc0204ad2:	6165                	addi	sp,sp,112
ffffffffc0204ad4:	8082                	ret
    if ((mm = mm_create()) == NULL)
ffffffffc0204ad6:	abffe0ef          	jal	ffffffffc0203594 <mm_create>
ffffffffc0204ada:	8caa                	mv	s9,a0
ffffffffc0204adc:	0e050163          	beqz	a0,ffffffffc0204bbe <do_fork+0x328>
    if ((page = alloc_page()) == NULL)
ffffffffc0204ae0:	4505                	li	a0,1
ffffffffc0204ae2:	a50fd0ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc0204ae6:	c969                	beqz	a0,ffffffffc0204bb8 <do_fork+0x322>
    return page - pages + nbase;
ffffffffc0204ae8:	000b3683          	ld	a3,0(s6)
    return KADDR(page2pa(page));
ffffffffc0204aec:	57fd                	li	a5,-1
ffffffffc0204aee:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204af2:	40d506b3          	sub	a3,a0,a3
ffffffffc0204af6:	8699                	srai	a3,a3,0x6
ffffffffc0204af8:	96ce                	add	a3,a3,s3
    return KADDR(page2pa(page));
ffffffffc0204afa:	83b1                	srli	a5,a5,0xc
ffffffffc0204afc:	8ff5                	and	a5,a5,a3
ffffffffc0204afe:	e86a                	sd	s10,16(sp)
    return page2ppn(page) << PGSHIFT;
ffffffffc0204b00:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b02:	1ae7f363          	bgeu	a5,a4,ffffffffc0204ca8 <do_fork+0x412>
ffffffffc0204b06:	000c3783          	ld	a5,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204b0a:	000c7597          	auipc	a1,0xc7
ffffffffc0204b0e:	76e5b583          	ld	a1,1902(a1) # ffffffffc02cc278 <boot_pgdir_va>
ffffffffc0204b12:	6605                	lui	a2,0x1
ffffffffc0204b14:	96be                	add	a3,a3,a5
ffffffffc0204b16:	8536                	mv	a0,a3
ffffffffc0204b18:	e436                	sd	a3,8(sp)
ffffffffc0204b1a:	013010ef          	jal	ffffffffc020632c <memcpy>
    mm->pgdir = pgdir;
ffffffffc0204b1e:	66a2                	ld	a3,8(sp)
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        down(&(mm->mm_sem));
ffffffffc0204b20:	038a0513          	addi	a0,s4,56
ffffffffc0204b24:	038a0d13          	addi	s10,s4,56
ffffffffc0204b28:	00dcbc23          	sd	a3,24(s9)
ffffffffc0204b2c:	a31ff0ef          	jal	ffffffffc020455c <down>
        if (current != NULL)
ffffffffc0204b30:	000ab783          	ld	a5,0(s5)
ffffffffc0204b34:	c781                	beqz	a5,ffffffffc0204b3c <do_fork+0x2a6>
        {
            mm->locked_by = current->pid;
ffffffffc0204b36:	43dc                	lw	a5,4(a5)
ffffffffc0204b38:	04fa2823          	sw	a5,80(s4)
        ret = dup_mmap(mm, oldmm);
ffffffffc0204b3c:	85d2                	mv	a1,s4
ffffffffc0204b3e:	8566                	mv	a0,s9
ffffffffc0204b40:	cbffe0ef          	jal	ffffffffc02037fe <dup_mmap>
ffffffffc0204b44:	8aaa                	mv	s5,a0
static inline void
unlock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        up(&(mm->mm_sem));
ffffffffc0204b46:	856a                	mv	a0,s10
ffffffffc0204b48:	a11ff0ef          	jal	ffffffffc0204558 <up>
        mm->locked_by = 0;
ffffffffc0204b4c:	040a2823          	sw	zero,80(s4)
    if ((mm = mm_create()) == NULL)
ffffffffc0204b50:	8a66                	mv	s4,s9
    if (ret != 0)
ffffffffc0204b52:	040a9b63          	bnez	s5,ffffffffc0204ba8 <do_fork+0x312>
ffffffffc0204b56:	6d42                	ld	s10,16(sp)
ffffffffc0204b58:	b3fd                	j	ffffffffc0204946 <do_fork+0xb0>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204b5a:	8936                	mv	s2,a3
ffffffffc0204b5c:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204b60:	00000797          	auipc	a5,0x0
ffffffffc0204b64:	bd078793          	addi	a5,a5,-1072 # ffffffffc0204730 <forkret>
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204b68:	fc14                	sd	a3,56(s0)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204b6a:	f81c                	sd	a5,48(s0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204b6c:	100027f3          	csrr	a5,sstatus
ffffffffc0204b70:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204b72:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204b74:	e40787e3          	beqz	a5,ffffffffc02049c2 <do_fork+0x12c>
        intr_disable();
ffffffffc0204b78:	d43fb0ef          	jal	ffffffffc02008ba <intr_disable>
    if (++last_pid >= MAX_PID)
ffffffffc0204b7c:	000c3517          	auipc	a0,0xc3
ffffffffc0204b80:	11852503          	lw	a0,280(a0) # ffffffffc02c7c94 <last_pid.1>
ffffffffc0204b84:	6789                	lui	a5,0x2
        return 1;
ffffffffc0204b86:	4905                	li	s2,1
ffffffffc0204b88:	2505                	addiw	a0,a0,1
ffffffffc0204b8a:	000c3717          	auipc	a4,0xc3
ffffffffc0204b8e:	10a72523          	sw	a0,266(a4) # ffffffffc02c7c94 <last_pid.1>
ffffffffc0204b92:	e4f544e3          	blt	a0,a5,ffffffffc02049da <do_fork+0x144>
        last_pid = 1;
ffffffffc0204b96:	4505                	li	a0,1
ffffffffc0204b98:	000c3797          	auipc	a5,0xc3
ffffffffc0204b9c:	0ea7ae23          	sw	a0,252(a5) # ffffffffc02c7c94 <last_pid.1>
        goto inside;
ffffffffc0204ba0:	b5b9                	j	ffffffffc02049ee <do_fork+0x158>
        intr_enable();
ffffffffc0204ba2:	d13fb0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0204ba6:	b739                	j	ffffffffc0204ab4 <do_fork+0x21e>
    exit_mmap(mm);
ffffffffc0204ba8:	8566                	mv	a0,s9
ffffffffc0204baa:	cedfe0ef          	jal	ffffffffc0203896 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204bae:	018cb503          	ld	a0,24(s9)
ffffffffc0204bb2:	b8dff0ef          	jal	ffffffffc020473e <put_pgdir.isra.0>
ffffffffc0204bb6:	6d42                	ld	s10,16(sp)
    mm_destroy(mm);
ffffffffc0204bb8:	8566                	mv	a0,s9
ffffffffc0204bba:	b27fe0ef          	jal	ffffffffc02036e0 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204bbe:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc0204bc0:	c02007b7          	lui	a5,0xc0200
ffffffffc0204bc4:	0cf6e563          	bltu	a3,a5,ffffffffc0204c8e <do_fork+0x3f8>
ffffffffc0204bc8:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc0204bcc:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc0204bd0:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204bd4:	83b1                	srli	a5,a5,0xc
ffffffffc0204bd6:	06e7f463          	bgeu	a5,a4,ffffffffc0204c3e <do_fork+0x3a8>
    return &pages[PPN(pa) - nbase];
ffffffffc0204bda:	000b3503          	ld	a0,0(s6)
ffffffffc0204bde:	413787b3          	sub	a5,a5,s3
ffffffffc0204be2:	079a                	slli	a5,a5,0x6
ffffffffc0204be4:	953e                	add	a0,a0,a5
ffffffffc0204be6:	4589                	li	a1,2
ffffffffc0204be8:	984fd0ef          	jal	ffffffffc0201d6c <free_pages>
}
ffffffffc0204bec:	69a6                	ld	s3,72(sp)
ffffffffc0204bee:	6a06                	ld	s4,64(sp)
ffffffffc0204bf0:	7b42                	ld	s6,48(sp)
ffffffffc0204bf2:	7ba2                	ld	s7,40(sp)
ffffffffc0204bf4:	7c02                	ld	s8,32(sp)
    kfree(proc);
ffffffffc0204bf6:	8522                	mv	a0,s0
ffffffffc0204bf8:	81efd0ef          	jal	ffffffffc0201c16 <kfree>
ffffffffc0204bfc:	7ae2                	ld	s5,56(sp)
    ret = -E_NO_MEM;
ffffffffc0204bfe:	5571                	li	a0,-4
    return ret;
ffffffffc0204c00:	b5e1                	j	ffffffffc0204ac8 <do_fork+0x232>
                    if (last_pid >= MAX_PID)
ffffffffc0204c02:	6789                	lui	a5,0x2
ffffffffc0204c04:	00f6c363          	blt	a3,a5,ffffffffc0204c0a <do_fork+0x374>
                        last_pid = 1;
ffffffffc0204c08:	4685                	li	a3,1
                    goto repeat;
ffffffffc0204c0a:	4585                	li	a1,1
ffffffffc0204c0c:	bbf5                	j	ffffffffc0204a08 <do_fork+0x172>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204c0e:	556d                	li	a0,-5
}
ffffffffc0204c10:	8082                	ret
    assert(current->wait_state == 0);
ffffffffc0204c12:	00003697          	auipc	a3,0x3
ffffffffc0204c16:	38e68693          	addi	a3,a3,910 # ffffffffc0207fa0 <etext+0x1c5c>
ffffffffc0204c1a:	00002617          	auipc	a2,0x2
ffffffffc0204c1e:	0de60613          	addi	a2,a2,222 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0204c22:	1d700593          	li	a1,471
ffffffffc0204c26:	00003517          	auipc	a0,0x3
ffffffffc0204c2a:	39a50513          	addi	a0,a0,922 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc0204c2e:	e4ce                	sd	s3,72(sp)
ffffffffc0204c30:	e0d2                	sd	s4,64(sp)
ffffffffc0204c32:	f85a                	sd	s6,48(sp)
ffffffffc0204c34:	f45e                	sd	s7,40(sp)
ffffffffc0204c36:	f062                	sd	s8,32(sp)
ffffffffc0204c38:	e86a                	sd	s10,16(sp)
ffffffffc0204c3a:	811fb0ef          	jal	ffffffffc020044a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204c3e:	00002617          	auipc	a2,0x2
ffffffffc0204c42:	53a60613          	addi	a2,a2,1338 # ffffffffc0207178 <etext+0xe34>
ffffffffc0204c46:	06900593          	li	a1,105
ffffffffc0204c4a:	00002517          	auipc	a0,0x2
ffffffffc0204c4e:	48650513          	addi	a0,a0,1158 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc0204c52:	e86a                	sd	s10,16(sp)
ffffffffc0204c54:	ff6fb0ef          	jal	ffffffffc020044a <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204c58:	86be                	mv	a3,a5
ffffffffc0204c5a:	00002617          	auipc	a2,0x2
ffffffffc0204c5e:	4f660613          	addi	a2,a2,1270 # ffffffffc0207150 <etext+0xe0c>
ffffffffc0204c62:	19700593          	li	a1,407
ffffffffc0204c66:	00003517          	auipc	a0,0x3
ffffffffc0204c6a:	35a50513          	addi	a0,a0,858 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc0204c6e:	e86a                	sd	s10,16(sp)
ffffffffc0204c70:	fdafb0ef          	jal	ffffffffc020044a <__panic>
    return KADDR(page2pa(page));
ffffffffc0204c74:	00002617          	auipc	a2,0x2
ffffffffc0204c78:	43460613          	addi	a2,a2,1076 # ffffffffc02070a8 <etext+0xd64>
ffffffffc0204c7c:	07100593          	li	a1,113
ffffffffc0204c80:	00002517          	auipc	a0,0x2
ffffffffc0204c84:	45050513          	addi	a0,a0,1104 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc0204c88:	e86a                	sd	s10,16(sp)
ffffffffc0204c8a:	fc0fb0ef          	jal	ffffffffc020044a <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204c8e:	00002617          	auipc	a2,0x2
ffffffffc0204c92:	4c260613          	addi	a2,a2,1218 # ffffffffc0207150 <etext+0xe0c>
ffffffffc0204c96:	07700593          	li	a1,119
ffffffffc0204c9a:	00002517          	auipc	a0,0x2
ffffffffc0204c9e:	43650513          	addi	a0,a0,1078 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc0204ca2:	e86a                	sd	s10,16(sp)
ffffffffc0204ca4:	fa6fb0ef          	jal	ffffffffc020044a <__panic>
    return KADDR(page2pa(page));
ffffffffc0204ca8:	00002617          	auipc	a2,0x2
ffffffffc0204cac:	40060613          	addi	a2,a2,1024 # ffffffffc02070a8 <etext+0xd64>
ffffffffc0204cb0:	07100593          	li	a1,113
ffffffffc0204cb4:	00002517          	auipc	a0,0x2
ffffffffc0204cb8:	41c50513          	addi	a0,a0,1052 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc0204cbc:	f8efb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204cc0 <kernel_thread>:
{
ffffffffc0204cc0:	7129                	addi	sp,sp,-320
ffffffffc0204cc2:	fa22                	sd	s0,304(sp)
ffffffffc0204cc4:	f626                	sd	s1,296(sp)
ffffffffc0204cc6:	f24a                	sd	s2,288(sp)
ffffffffc0204cc8:	842a                	mv	s0,a0
ffffffffc0204cca:	84ae                	mv	s1,a1
ffffffffc0204ccc:	8932                	mv	s2,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204cce:	850a                	mv	a0,sp
ffffffffc0204cd0:	12000613          	li	a2,288
ffffffffc0204cd4:	4581                	li	a1,0
{
ffffffffc0204cd6:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204cd8:	642010ef          	jal	ffffffffc020631a <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc0204cdc:	e0a2                	sd	s0,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc0204cde:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0204ce0:	100027f3          	csrr	a5,sstatus
ffffffffc0204ce4:	edd7f793          	andi	a5,a5,-291
ffffffffc0204ce8:	1207e793          	ori	a5,a5,288
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204cec:	860a                	mv	a2,sp
ffffffffc0204cee:	10096513          	ori	a0,s2,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204cf2:	00000717          	auipc	a4,0x0
ffffffffc0204cf6:	99c70713          	addi	a4,a4,-1636 # ffffffffc020468e <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204cfa:	4581                	li	a1,0
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0204cfc:	e23e                	sd	a5,256(sp)
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204cfe:	e63a                	sd	a4,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204d00:	b97ff0ef          	jal	ffffffffc0204896 <do_fork>
}
ffffffffc0204d04:	70f2                	ld	ra,312(sp)
ffffffffc0204d06:	7452                	ld	s0,304(sp)
ffffffffc0204d08:	74b2                	ld	s1,296(sp)
ffffffffc0204d0a:	7912                	ld	s2,288(sp)
ffffffffc0204d0c:	6131                	addi	sp,sp,320
ffffffffc0204d0e:	8082                	ret

ffffffffc0204d10 <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int do_exit(int error_code)
{
ffffffffc0204d10:	7179                	addi	sp,sp,-48
ffffffffc0204d12:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204d14:	000c7417          	auipc	s0,0xc7
ffffffffc0204d18:	58c40413          	addi	s0,s0,1420 # ffffffffc02cc2a0 <current>
ffffffffc0204d1c:	601c                	ld	a5,0(s0)
ffffffffc0204d1e:	000c7717          	auipc	a4,0xc7
ffffffffc0204d22:	59273703          	ld	a4,1426(a4) # ffffffffc02cc2b0 <idleproc>
{
ffffffffc0204d26:	f406                	sd	ra,40(sp)
ffffffffc0204d28:	ec26                	sd	s1,24(sp)
    if (current == idleproc)
ffffffffc0204d2a:	0ce78b63          	beq	a5,a4,ffffffffc0204e00 <do_exit+0xf0>
    {
        panic("idleproc exit.\n");
    }
    if (current == initproc)
ffffffffc0204d2e:	000c7497          	auipc	s1,0xc7
ffffffffc0204d32:	57a48493          	addi	s1,s1,1402 # ffffffffc02cc2a8 <initproc>
ffffffffc0204d36:	6098                	ld	a4,0(s1)
ffffffffc0204d38:	e84a                	sd	s2,16(sp)
ffffffffc0204d3a:	0ee78c63          	beq	a5,a4,ffffffffc0204e32 <do_exit+0x122>
    {
        panic("initproc exit.\n");
    }
    struct mm_struct *mm = current->mm;
ffffffffc0204d3e:	7798                	ld	a4,40(a5)
ffffffffc0204d40:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc0204d42:	c315                	beqz	a4,ffffffffc0204d66 <do_exit+0x56>
ffffffffc0204d44:	000c7797          	auipc	a5,0xc7
ffffffffc0204d48:	52c7b783          	ld	a5,1324(a5) # ffffffffc02cc270 <boot_pgdir_pa>
ffffffffc0204d4c:	56fd                	li	a3,-1
ffffffffc0204d4e:	16fe                	slli	a3,a3,0x3f
ffffffffc0204d50:	83b1                	srli	a5,a5,0xc
ffffffffc0204d52:	8fd5                	or	a5,a5,a3
ffffffffc0204d54:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc0204d58:	5b1c                	lw	a5,48(a4)
ffffffffc0204d5a:	37fd                	addiw	a5,a5,-1
ffffffffc0204d5c:	db1c                	sw	a5,48(a4)
    {
        lsatp(boot_pgdir_pa);
        if (mm_count_dec(mm) == 0)
ffffffffc0204d5e:	cfd5                	beqz	a5,ffffffffc0204e1a <do_exit+0x10a>
        {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        current->mm = NULL;
ffffffffc0204d60:	601c                	ld	a5,0(s0)
ffffffffc0204d62:	0207b423          	sd	zero,40(a5)
    }
    current->state = PROC_ZOMBIE;
ffffffffc0204d66:	470d                	li	a4,3
    current->exit_code = error_code;
ffffffffc0204d68:	0f27a423          	sw	s2,232(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0204d6c:	c398                	sw	a4,0(a5)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204d6e:	100027f3          	csrr	a5,sstatus
ffffffffc0204d72:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204d74:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204d76:	ebf1                	bnez	a5,ffffffffc0204e4a <do_exit+0x13a>
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
    {
        proc = current->parent;
ffffffffc0204d78:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204d7a:	800007b7          	lui	a5,0x80000
ffffffffc0204d7e:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_matrix_out_size+0xffffffff7fff4919>
        proc = current->parent;
ffffffffc0204d80:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204d82:	0ec52703          	lw	a4,236(a0)
ffffffffc0204d86:	0cf70663          	beq	a4,a5,ffffffffc0204e52 <do_exit+0x142>
        {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL)
ffffffffc0204d8a:	6018                	ld	a4,0(s0)
            }
            proc->parent = initproc;
            initproc->cptr = proc;
            if (proc->state == PROC_ZOMBIE)
            {
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204d8c:	800005b7          	lui	a1,0x80000
ffffffffc0204d90:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_obj___user_matrix_out_size+0xffffffff7fff4919>
        while (current->cptr != NULL)
ffffffffc0204d92:	7b7c                	ld	a5,240(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204d94:	460d                	li	a2,3
        while (current->cptr != NULL)
ffffffffc0204d96:	e789                	bnez	a5,ffffffffc0204da0 <do_exit+0x90>
ffffffffc0204d98:	a83d                	j	ffffffffc0204dd6 <do_exit+0xc6>
ffffffffc0204d9a:	6018                	ld	a4,0(s0)
ffffffffc0204d9c:	7b7c                	ld	a5,240(a4)
ffffffffc0204d9e:	cf85                	beqz	a5,ffffffffc0204dd6 <do_exit+0xc6>
            current->cptr = proc->optr;
ffffffffc0204da0:	1007b683          	ld	a3,256(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204da4:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc0204da6:	fb74                	sd	a3,240(a4)
            proc->yptr = NULL;
ffffffffc0204da8:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204dac:	7978                	ld	a4,240(a0)
ffffffffc0204dae:	10e7b023          	sd	a4,256(a5)
ffffffffc0204db2:	c311                	beqz	a4,ffffffffc0204db6 <do_exit+0xa6>
                initproc->cptr->yptr = proc;
ffffffffc0204db4:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204db6:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc0204db8:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc0204dba:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204dbc:	fcc71fe3          	bne	a4,a2,ffffffffc0204d9a <do_exit+0x8a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204dc0:	0ec52783          	lw	a5,236(a0)
ffffffffc0204dc4:	fcb79be3          	bne	a5,a1,ffffffffc0204d9a <do_exit+0x8a>
                {
                    wakeup_proc(initproc);
ffffffffc0204dc8:	65d000ef          	jal	ffffffffc0205c24 <wakeup_proc>
ffffffffc0204dcc:	800005b7          	lui	a1,0x80000
ffffffffc0204dd0:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_obj___user_matrix_out_size+0xffffffff7fff4919>
ffffffffc0204dd2:	460d                	li	a2,3
ffffffffc0204dd4:	b7d9                	j	ffffffffc0204d9a <do_exit+0x8a>
    if (flag) {
ffffffffc0204dd6:	02091263          	bnez	s2,ffffffffc0204dfa <do_exit+0xea>
                }
            }
        }
    }
    local_intr_restore(intr_flag);
    schedule();
ffffffffc0204dda:	6f1000ef          	jal	ffffffffc0205cca <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc0204dde:	601c                	ld	a5,0(s0)
ffffffffc0204de0:	00003617          	auipc	a2,0x3
ffffffffc0204de4:	21860613          	addi	a2,a2,536 # ffffffffc0207ff8 <etext+0x1cb4>
ffffffffc0204de8:	24000593          	li	a1,576
ffffffffc0204dec:	43d4                	lw	a3,4(a5)
ffffffffc0204dee:	00003517          	auipc	a0,0x3
ffffffffc0204df2:	1d250513          	addi	a0,a0,466 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc0204df6:	e54fb0ef          	jal	ffffffffc020044a <__panic>
        intr_enable();
ffffffffc0204dfa:	abbfb0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0204dfe:	bff1                	j	ffffffffc0204dda <do_exit+0xca>
        panic("idleproc exit.\n");
ffffffffc0204e00:	00003617          	auipc	a2,0x3
ffffffffc0204e04:	1d860613          	addi	a2,a2,472 # ffffffffc0207fd8 <etext+0x1c94>
ffffffffc0204e08:	20c00593          	li	a1,524
ffffffffc0204e0c:	00003517          	auipc	a0,0x3
ffffffffc0204e10:	1b450513          	addi	a0,a0,436 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc0204e14:	e84a                	sd	s2,16(sp)
ffffffffc0204e16:	e34fb0ef          	jal	ffffffffc020044a <__panic>
            exit_mmap(mm);
ffffffffc0204e1a:	853a                	mv	a0,a4
ffffffffc0204e1c:	e43a                	sd	a4,8(sp)
ffffffffc0204e1e:	a79fe0ef          	jal	ffffffffc0203896 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204e22:	6722                	ld	a4,8(sp)
ffffffffc0204e24:	6f08                	ld	a0,24(a4)
ffffffffc0204e26:	919ff0ef          	jal	ffffffffc020473e <put_pgdir.isra.0>
            mm_destroy(mm);
ffffffffc0204e2a:	6522                	ld	a0,8(sp)
ffffffffc0204e2c:	8b5fe0ef          	jal	ffffffffc02036e0 <mm_destroy>
ffffffffc0204e30:	bf05                	j	ffffffffc0204d60 <do_exit+0x50>
        panic("initproc exit.\n");
ffffffffc0204e32:	00003617          	auipc	a2,0x3
ffffffffc0204e36:	1b660613          	addi	a2,a2,438 # ffffffffc0207fe8 <etext+0x1ca4>
ffffffffc0204e3a:	21000593          	li	a1,528
ffffffffc0204e3e:	00003517          	auipc	a0,0x3
ffffffffc0204e42:	18250513          	addi	a0,a0,386 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc0204e46:	e04fb0ef          	jal	ffffffffc020044a <__panic>
        intr_disable();
ffffffffc0204e4a:	a71fb0ef          	jal	ffffffffc02008ba <intr_disable>
        return 1;
ffffffffc0204e4e:	4905                	li	s2,1
ffffffffc0204e50:	b725                	j	ffffffffc0204d78 <do_exit+0x68>
            wakeup_proc(proc);
ffffffffc0204e52:	5d3000ef          	jal	ffffffffc0205c24 <wakeup_proc>
ffffffffc0204e56:	bf15                	j	ffffffffc0204d8a <do_exit+0x7a>

ffffffffc0204e58 <do_wait.part.0>:
}

// do_wait - wait one OR any children with PROC_ZOMBIE state, and free memory space of kernel stack
//         - proc struct of this child.
// NOTE: only after do_wait function, all resources of the child proces are free.
int do_wait(int pid, int *code_store)
ffffffffc0204e58:	7179                	addi	sp,sp,-48
ffffffffc0204e5a:	ec26                	sd	s1,24(sp)
ffffffffc0204e5c:	e84a                	sd	s2,16(sp)
ffffffffc0204e5e:	e44e                	sd	s3,8(sp)
ffffffffc0204e60:	f406                	sd	ra,40(sp)
ffffffffc0204e62:	f022                	sd	s0,32(sp)
ffffffffc0204e64:	84aa                	mv	s1,a0
ffffffffc0204e66:	892e                	mv	s2,a1
ffffffffc0204e68:	000c7997          	auipc	s3,0xc7
ffffffffc0204e6c:	43898993          	addi	s3,s3,1080 # ffffffffc02cc2a0 <current>

    struct proc_struct *proc;
    bool intr_flag, haskid;
repeat:
    haskid = 0;
    if (pid != 0)
ffffffffc0204e70:	cd19                	beqz	a0,ffffffffc0204e8e <do_wait.part.0+0x36>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204e72:	6789                	lui	a5,0x2
ffffffffc0204e74:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x70e2>
ffffffffc0204e76:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204e7a:	12e7f563          	bgeu	a5,a4,ffffffffc0204fa4 <do_wait.part.0+0x14c>
    }
    local_intr_restore(intr_flag);
    put_kstack(proc);
    kfree(proc);
    return 0;
}
ffffffffc0204e7e:	70a2                	ld	ra,40(sp)
ffffffffc0204e80:	7402                	ld	s0,32(sp)
ffffffffc0204e82:	64e2                	ld	s1,24(sp)
ffffffffc0204e84:	6942                	ld	s2,16(sp)
ffffffffc0204e86:	69a2                	ld	s3,8(sp)
    return -E_BAD_PROC;
ffffffffc0204e88:	5579                	li	a0,-2
}
ffffffffc0204e8a:	6145                	addi	sp,sp,48
ffffffffc0204e8c:	8082                	ret
        proc = current->cptr;
ffffffffc0204e8e:	0009b703          	ld	a4,0(s3)
ffffffffc0204e92:	7b60                	ld	s0,240(a4)
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204e94:	d46d                	beqz	s0,ffffffffc0204e7e <do_wait.part.0+0x26>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204e96:	468d                	li	a3,3
ffffffffc0204e98:	a021                	j	ffffffffc0204ea0 <do_wait.part.0+0x48>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204e9a:	10043403          	ld	s0,256(s0)
ffffffffc0204e9e:	c075                	beqz	s0,ffffffffc0204f82 <do_wait.part.0+0x12a>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204ea0:	401c                	lw	a5,0(s0)
ffffffffc0204ea2:	fed79ce3          	bne	a5,a3,ffffffffc0204e9a <do_wait.part.0+0x42>
    if (proc == idleproc || proc == initproc)
ffffffffc0204ea6:	000c7797          	auipc	a5,0xc7
ffffffffc0204eaa:	40a7b783          	ld	a5,1034(a5) # ffffffffc02cc2b0 <idleproc>
ffffffffc0204eae:	14878263          	beq	a5,s0,ffffffffc0204ff2 <do_wait.part.0+0x19a>
ffffffffc0204eb2:	000c7797          	auipc	a5,0xc7
ffffffffc0204eb6:	3f67b783          	ld	a5,1014(a5) # ffffffffc02cc2a8 <initproc>
ffffffffc0204eba:	12f40c63          	beq	s0,a5,ffffffffc0204ff2 <do_wait.part.0+0x19a>
    if (code_store != NULL)
ffffffffc0204ebe:	00090663          	beqz	s2,ffffffffc0204eca <do_wait.part.0+0x72>
        *code_store = proc->exit_code;
ffffffffc0204ec2:	0e842783          	lw	a5,232(s0)
ffffffffc0204ec6:	00f92023          	sw	a5,0(s2)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204eca:	100027f3          	csrr	a5,sstatus
ffffffffc0204ece:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204ed0:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204ed2:	10079963          	bnez	a5,ffffffffc0204fe4 <do_wait.part.0+0x18c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204ed6:	6c74                	ld	a3,216(s0)
ffffffffc0204ed8:	7078                	ld	a4,224(s0)
    if (proc->optr != NULL)
ffffffffc0204eda:	10043783          	ld	a5,256(s0)
    prev->next = next;
ffffffffc0204ede:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0204ee0:	e314                	sd	a3,0(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204ee2:	6474                	ld	a3,200(s0)
ffffffffc0204ee4:	6878                	ld	a4,208(s0)
    prev->next = next;
ffffffffc0204ee6:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0204ee8:	e314                	sd	a3,0(a4)
ffffffffc0204eea:	c789                	beqz	a5,ffffffffc0204ef4 <do_wait.part.0+0x9c>
        proc->optr->yptr = proc->yptr;
ffffffffc0204eec:	7c78                	ld	a4,248(s0)
ffffffffc0204eee:	fff8                	sd	a4,248(a5)
        proc->yptr->optr = proc->optr;
ffffffffc0204ef0:	10043783          	ld	a5,256(s0)
    if (proc->yptr != NULL)
ffffffffc0204ef4:	7c78                	ld	a4,248(s0)
ffffffffc0204ef6:	c36d                	beqz	a4,ffffffffc0204fd8 <do_wait.part.0+0x180>
        proc->yptr->optr = proc->optr;
ffffffffc0204ef8:	10f73023          	sd	a5,256(a4)
    nr_process--;
ffffffffc0204efc:	000c7797          	auipc	a5,0xc7
ffffffffc0204f00:	3a07a783          	lw	a5,928(a5) # ffffffffc02cc29c <nr_process>
ffffffffc0204f04:	37fd                	addiw	a5,a5,-1
ffffffffc0204f06:	000c7717          	auipc	a4,0xc7
ffffffffc0204f0a:	38f72b23          	sw	a5,918(a4) # ffffffffc02cc29c <nr_process>
    if (flag) {
ffffffffc0204f0e:	e271                	bnez	a2,ffffffffc0204fd2 <do_wait.part.0+0x17a>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204f10:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc0204f12:	c02007b7          	lui	a5,0xc0200
ffffffffc0204f16:	10f6e663          	bltu	a3,a5,ffffffffc0205022 <do_wait.part.0+0x1ca>
ffffffffc0204f1a:	000c7717          	auipc	a4,0xc7
ffffffffc0204f1e:	36673703          	ld	a4,870(a4) # ffffffffc02cc280 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0204f22:	000c7797          	auipc	a5,0xc7
ffffffffc0204f26:	3667b783          	ld	a5,870(a5) # ffffffffc02cc288 <npage>
    return pa2page(PADDR(kva));
ffffffffc0204f2a:	8e99                	sub	a3,a3,a4
    if (PPN(pa) >= npage)
ffffffffc0204f2c:	82b1                	srli	a3,a3,0xc
ffffffffc0204f2e:	0cf6fe63          	bgeu	a3,a5,ffffffffc020500a <do_wait.part.0+0x1b2>
    return &pages[PPN(pa) - nbase];
ffffffffc0204f32:	00004797          	auipc	a5,0x4
ffffffffc0204f36:	1667b783          	ld	a5,358(a5) # ffffffffc0209098 <nbase>
ffffffffc0204f3a:	000c7517          	auipc	a0,0xc7
ffffffffc0204f3e:	35653503          	ld	a0,854(a0) # ffffffffc02cc290 <pages>
ffffffffc0204f42:	4589                	li	a1,2
ffffffffc0204f44:	8e9d                	sub	a3,a3,a5
ffffffffc0204f46:	069a                	slli	a3,a3,0x6
ffffffffc0204f48:	9536                	add	a0,a0,a3
ffffffffc0204f4a:	e23fc0ef          	jal	ffffffffc0201d6c <free_pages>
    kfree(proc);
ffffffffc0204f4e:	8522                	mv	a0,s0
ffffffffc0204f50:	cc7fc0ef          	jal	ffffffffc0201c16 <kfree>
}
ffffffffc0204f54:	70a2                	ld	ra,40(sp)
ffffffffc0204f56:	7402                	ld	s0,32(sp)
ffffffffc0204f58:	64e2                	ld	s1,24(sp)
ffffffffc0204f5a:	6942                	ld	s2,16(sp)
ffffffffc0204f5c:	69a2                	ld	s3,8(sp)
    return 0;
ffffffffc0204f5e:	4501                	li	a0,0
}
ffffffffc0204f60:	6145                	addi	sp,sp,48
ffffffffc0204f62:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc0204f64:	000c7997          	auipc	s3,0xc7
ffffffffc0204f68:	33c98993          	addi	s3,s3,828 # ffffffffc02cc2a0 <current>
ffffffffc0204f6c:	0009b703          	ld	a4,0(s3)
ffffffffc0204f70:	f487b683          	ld	a3,-184(a5)
ffffffffc0204f74:	f0e695e3          	bne	a3,a4,ffffffffc0204e7e <do_wait.part.0+0x26>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204f78:	f287a603          	lw	a2,-216(a5)
ffffffffc0204f7c:	468d                	li	a3,3
ffffffffc0204f7e:	06d60063          	beq	a2,a3,ffffffffc0204fde <do_wait.part.0+0x186>
        current->wait_state = WT_CHILD;
ffffffffc0204f82:	800007b7          	lui	a5,0x80000
ffffffffc0204f86:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_matrix_out_size+0xffffffff7fff4919>
        current->state = PROC_SLEEPING;
ffffffffc0204f88:	4685                	li	a3,1
        current->wait_state = WT_CHILD;
ffffffffc0204f8a:	0ef72623          	sw	a5,236(a4)
        current->state = PROC_SLEEPING;
ffffffffc0204f8e:	c314                	sw	a3,0(a4)
        schedule();
ffffffffc0204f90:	53b000ef          	jal	ffffffffc0205cca <schedule>
        if (current->flags & PF_EXITING)
ffffffffc0204f94:	0009b783          	ld	a5,0(s3)
ffffffffc0204f98:	0b07a783          	lw	a5,176(a5)
ffffffffc0204f9c:	8b85                	andi	a5,a5,1
ffffffffc0204f9e:	e7b9                	bnez	a5,ffffffffc0204fec <do_wait.part.0+0x194>
    if (pid != 0)
ffffffffc0204fa0:	ee0487e3          	beqz	s1,ffffffffc0204e8e <do_wait.part.0+0x36>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204fa4:	45a9                	li	a1,10
ffffffffc0204fa6:	8526                	mv	a0,s1
ffffffffc0204fa8:	6dd000ef          	jal	ffffffffc0205e84 <hash32>
ffffffffc0204fac:	02051793          	slli	a5,a0,0x20
ffffffffc0204fb0:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204fb4:	000c3797          	auipc	a5,0xc3
ffffffffc0204fb8:	24c78793          	addi	a5,a5,588 # ffffffffc02c8200 <hash_list>
ffffffffc0204fbc:	953e                	add	a0,a0,a5
ffffffffc0204fbe:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204fc0:	a029                	j	ffffffffc0204fca <do_wait.part.0+0x172>
            if (proc->pid == pid)
ffffffffc0204fc2:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204fc6:	f8970fe3          	beq	a4,s1,ffffffffc0204f64 <do_wait.part.0+0x10c>
    return listelm->next;
ffffffffc0204fca:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204fcc:	fef51be3          	bne	a0,a5,ffffffffc0204fc2 <do_wait.part.0+0x16a>
ffffffffc0204fd0:	b57d                	j	ffffffffc0204e7e <do_wait.part.0+0x26>
        intr_enable();
ffffffffc0204fd2:	8e3fb0ef          	jal	ffffffffc02008b4 <intr_enable>
ffffffffc0204fd6:	bf2d                	j	ffffffffc0204f10 <do_wait.part.0+0xb8>
        proc->parent->cptr = proc->optr;
ffffffffc0204fd8:	7018                	ld	a4,32(s0)
ffffffffc0204fda:	fb7c                	sd	a5,240(a4)
ffffffffc0204fdc:	b705                	j	ffffffffc0204efc <do_wait.part.0+0xa4>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204fde:	f2878413          	addi	s0,a5,-216
ffffffffc0204fe2:	b5d1                	j	ffffffffc0204ea6 <do_wait.part.0+0x4e>
        intr_disable();
ffffffffc0204fe4:	8d7fb0ef          	jal	ffffffffc02008ba <intr_disable>
        return 1;
ffffffffc0204fe8:	4605                	li	a2,1
ffffffffc0204fea:	b5f5                	j	ffffffffc0204ed6 <do_wait.part.0+0x7e>
            do_exit(-E_KILLED);
ffffffffc0204fec:	555d                	li	a0,-9
ffffffffc0204fee:	d23ff0ef          	jal	ffffffffc0204d10 <do_exit>
        panic("wait idleproc or initproc.\n");
ffffffffc0204ff2:	00003617          	auipc	a2,0x3
ffffffffc0204ff6:	02660613          	addi	a2,a2,38 # ffffffffc0208018 <etext+0x1cd4>
ffffffffc0204ffa:	36200593          	li	a1,866
ffffffffc0204ffe:	00003517          	auipc	a0,0x3
ffffffffc0205002:	fc250513          	addi	a0,a0,-62 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc0205006:	c44fb0ef          	jal	ffffffffc020044a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020500a:	00002617          	auipc	a2,0x2
ffffffffc020500e:	16e60613          	addi	a2,a2,366 # ffffffffc0207178 <etext+0xe34>
ffffffffc0205012:	06900593          	li	a1,105
ffffffffc0205016:	00002517          	auipc	a0,0x2
ffffffffc020501a:	0ba50513          	addi	a0,a0,186 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc020501e:	c2cfb0ef          	jal	ffffffffc020044a <__panic>
    return pa2page(PADDR(kva));
ffffffffc0205022:	00002617          	auipc	a2,0x2
ffffffffc0205026:	12e60613          	addi	a2,a2,302 # ffffffffc0207150 <etext+0xe0c>
ffffffffc020502a:	07700593          	li	a1,119
ffffffffc020502e:	00002517          	auipc	a0,0x2
ffffffffc0205032:	0a250513          	addi	a0,a0,162 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc0205036:	c14fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020503a <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc020503a:	1141                	addi	sp,sp,-16
ffffffffc020503c:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc020503e:	d67fc0ef          	jal	ffffffffc0201da4 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0205042:	b2bfc0ef          	jal	ffffffffc0201b6c <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0205046:	4601                	li	a2,0
ffffffffc0205048:	4581                	li	a1,0
ffffffffc020504a:	00000517          	auipc	a0,0x0
ffffffffc020504e:	6ba50513          	addi	a0,a0,1722 # ffffffffc0205704 <user_main>
ffffffffc0205052:	c6fff0ef          	jal	ffffffffc0204cc0 <kernel_thread>
    if (pid <= 0)
ffffffffc0205056:	00a04563          	bgtz	a0,ffffffffc0205060 <init_main+0x26>
ffffffffc020505a:	a841                	j	ffffffffc02050ea <init_main+0xb0>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc020505c:	46f000ef          	jal	ffffffffc0205cca <schedule>
    if (code_store != NULL)
ffffffffc0205060:	4581                	li	a1,0
ffffffffc0205062:	4501                	li	a0,0
ffffffffc0205064:	df5ff0ef          	jal	ffffffffc0204e58 <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc0205068:	d975                	beqz	a0,ffffffffc020505c <init_main+0x22>
    }


    extern void check_sync(void);
    check_sync();
ffffffffc020506a:	8b4ff0ef          	jal	ffffffffc020411e <check_sync>

    cprintf("all user-mode processes have quit.\n");
ffffffffc020506e:	00003517          	auipc	a0,0x3
ffffffffc0205072:	fea50513          	addi	a0,a0,-22 # ffffffffc0208058 <etext+0x1d14>
ffffffffc0205076:	922fb0ef          	jal	ffffffffc0200198 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc020507a:	000c7797          	auipc	a5,0xc7
ffffffffc020507e:	22e7b783          	ld	a5,558(a5) # ffffffffc02cc2a8 <initproc>
ffffffffc0205082:	7bf8                	ld	a4,240(a5)
ffffffffc0205084:	e339                	bnez	a4,ffffffffc02050ca <init_main+0x90>
ffffffffc0205086:	7ff8                	ld	a4,248(a5)
ffffffffc0205088:	e329                	bnez	a4,ffffffffc02050ca <init_main+0x90>
ffffffffc020508a:	1007b703          	ld	a4,256(a5)
ffffffffc020508e:	ef15                	bnez	a4,ffffffffc02050ca <init_main+0x90>
    assert(nr_process == 2);
ffffffffc0205090:	000c7697          	auipc	a3,0xc7
ffffffffc0205094:	20c6a683          	lw	a3,524(a3) # ffffffffc02cc29c <nr_process>
ffffffffc0205098:	4709                	li	a4,2
ffffffffc020509a:	0ae69463          	bne	a3,a4,ffffffffc0205142 <init_main+0x108>
ffffffffc020509e:	000c7697          	auipc	a3,0xc7
ffffffffc02050a2:	16268693          	addi	a3,a3,354 # ffffffffc02cc200 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc02050a6:	6698                	ld	a4,8(a3)
ffffffffc02050a8:	0c878793          	addi	a5,a5,200
ffffffffc02050ac:	06f71b63          	bne	a4,a5,ffffffffc0205122 <init_main+0xe8>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02050b0:	629c                	ld	a5,0(a3)
ffffffffc02050b2:	04f71863          	bne	a4,a5,ffffffffc0205102 <init_main+0xc8>

    cprintf("init check memory pass.\n");
ffffffffc02050b6:	00003517          	auipc	a0,0x3
ffffffffc02050ba:	08a50513          	addi	a0,a0,138 # ffffffffc0208140 <etext+0x1dfc>
ffffffffc02050be:	8dafb0ef          	jal	ffffffffc0200198 <cprintf>
    return 0;
}
ffffffffc02050c2:	60a2                	ld	ra,8(sp)
ffffffffc02050c4:	4501                	li	a0,0
ffffffffc02050c6:	0141                	addi	sp,sp,16
ffffffffc02050c8:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02050ca:	00003697          	auipc	a3,0x3
ffffffffc02050ce:	fb668693          	addi	a3,a3,-74 # ffffffffc0208080 <etext+0x1d3c>
ffffffffc02050d2:	00002617          	auipc	a2,0x2
ffffffffc02050d6:	c2660613          	addi	a2,a2,-986 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02050da:	3d200593          	li	a1,978
ffffffffc02050de:	00003517          	auipc	a0,0x3
ffffffffc02050e2:	ee250513          	addi	a0,a0,-286 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc02050e6:	b64fb0ef          	jal	ffffffffc020044a <__panic>
        panic("create user_main failed.\n");
ffffffffc02050ea:	00003617          	auipc	a2,0x3
ffffffffc02050ee:	f4e60613          	addi	a2,a2,-178 # ffffffffc0208038 <etext+0x1cf4>
ffffffffc02050f2:	3c500593          	li	a1,965
ffffffffc02050f6:	00003517          	auipc	a0,0x3
ffffffffc02050fa:	eca50513          	addi	a0,a0,-310 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc02050fe:	b4cfb0ef          	jal	ffffffffc020044a <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0205102:	00003697          	auipc	a3,0x3
ffffffffc0205106:	00e68693          	addi	a3,a3,14 # ffffffffc0208110 <etext+0x1dcc>
ffffffffc020510a:	00002617          	auipc	a2,0x2
ffffffffc020510e:	bee60613          	addi	a2,a2,-1042 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0205112:	3d500593          	li	a1,981
ffffffffc0205116:	00003517          	auipc	a0,0x3
ffffffffc020511a:	eaa50513          	addi	a0,a0,-342 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc020511e:	b2cfb0ef          	jal	ffffffffc020044a <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0205122:	00003697          	auipc	a3,0x3
ffffffffc0205126:	fbe68693          	addi	a3,a3,-66 # ffffffffc02080e0 <etext+0x1d9c>
ffffffffc020512a:	00002617          	auipc	a2,0x2
ffffffffc020512e:	bce60613          	addi	a2,a2,-1074 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0205132:	3d400593          	li	a1,980
ffffffffc0205136:	00003517          	auipc	a0,0x3
ffffffffc020513a:	e8a50513          	addi	a0,a0,-374 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc020513e:	b0cfb0ef          	jal	ffffffffc020044a <__panic>
    assert(nr_process == 2);
ffffffffc0205142:	00003697          	auipc	a3,0x3
ffffffffc0205146:	f8e68693          	addi	a3,a3,-114 # ffffffffc02080d0 <etext+0x1d8c>
ffffffffc020514a:	00002617          	auipc	a2,0x2
ffffffffc020514e:	bae60613          	addi	a2,a2,-1106 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0205152:	3d300593          	li	a1,979
ffffffffc0205156:	00003517          	auipc	a0,0x3
ffffffffc020515a:	e6a50513          	addi	a0,a0,-406 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc020515e:	aecfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205162 <do_execve>:
{
ffffffffc0205162:	7171                	addi	sp,sp,-176
ffffffffc0205164:	e8ea                	sd	s10,80(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0205166:	000c7d17          	auipc	s10,0xc7
ffffffffc020516a:	13ad0d13          	addi	s10,s10,314 # ffffffffc02cc2a0 <current>
ffffffffc020516e:	000d3783          	ld	a5,0(s10)
{
ffffffffc0205172:	e94a                	sd	s2,144(sp)
ffffffffc0205174:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0205176:	0287b903          	ld	s2,40(a5)
{
ffffffffc020517a:	84ae                	mv	s1,a1
ffffffffc020517c:	e54e                	sd	s3,136(sp)
ffffffffc020517e:	ec32                	sd	a2,24(sp)
ffffffffc0205180:	89aa                	mv	s3,a0
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0205182:	85aa                	mv	a1,a0
ffffffffc0205184:	8626                	mv	a2,s1
ffffffffc0205186:	854a                	mv	a0,s2
ffffffffc0205188:	4681                	li	a3,0
{
ffffffffc020518a:	f506                	sd	ra,168(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc020518c:	aa9fe0ef          	jal	ffffffffc0203c34 <user_mem_check>
ffffffffc0205190:	48050263          	beqz	a0,ffffffffc0205614 <do_execve+0x4b2>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0205194:	4641                	li	a2,16
ffffffffc0205196:	1808                	addi	a0,sp,48
ffffffffc0205198:	4581                	li	a1,0
ffffffffc020519a:	180010ef          	jal	ffffffffc020631a <memset>
    if (len > PROC_NAME_LEN)
ffffffffc020519e:	47bd                	li	a5,15
ffffffffc02051a0:	8626                	mv	a2,s1
ffffffffc02051a2:	0e97ef63          	bltu	a5,s1,ffffffffc02052a0 <do_execve+0x13e>
    memcpy(local_name, name, len);
ffffffffc02051a6:	85ce                	mv	a1,s3
ffffffffc02051a8:	1808                	addi	a0,sp,48
ffffffffc02051aa:	182010ef          	jal	ffffffffc020632c <memcpy>
    if (mm != NULL)
ffffffffc02051ae:	10090063          	beqz	s2,ffffffffc02052ae <do_execve+0x14c>
        cputs("mm != NULL");
ffffffffc02051b2:	00002517          	auipc	a0,0x2
ffffffffc02051b6:	6ee50513          	addi	a0,a0,1774 # ffffffffc02078a0 <etext+0x155c>
ffffffffc02051ba:	814fb0ef          	jal	ffffffffc02001ce <cputs>
ffffffffc02051be:	000c7797          	auipc	a5,0xc7
ffffffffc02051c2:	0b27b783          	ld	a5,178(a5) # ffffffffc02cc270 <boot_pgdir_pa>
ffffffffc02051c6:	577d                	li	a4,-1
ffffffffc02051c8:	177e                	slli	a4,a4,0x3f
ffffffffc02051ca:	83b1                	srli	a5,a5,0xc
ffffffffc02051cc:	8fd9                	or	a5,a5,a4
ffffffffc02051ce:	18079073          	csrw	satp,a5
ffffffffc02051d2:	03092783          	lw	a5,48(s2)
ffffffffc02051d6:	37fd                	addiw	a5,a5,-1
ffffffffc02051d8:	02f92823          	sw	a5,48(s2)
        if (mm_count_dec(mm) == 0)
ffffffffc02051dc:	30078763          	beqz	a5,ffffffffc02054ea <do_execve+0x388>
        current->mm = NULL;
ffffffffc02051e0:	000d3783          	ld	a5,0(s10)
ffffffffc02051e4:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc02051e8:	bacfe0ef          	jal	ffffffffc0203594 <mm_create>
ffffffffc02051ec:	89aa                	mv	s3,a0
ffffffffc02051ee:	22050063          	beqz	a0,ffffffffc020540e <do_execve+0x2ac>
    if ((page = alloc_page()) == NULL)
ffffffffc02051f2:	4505                	li	a0,1
ffffffffc02051f4:	b3ffc0ef          	jal	ffffffffc0201d32 <alloc_pages>
ffffffffc02051f8:	42050363          	beqz	a0,ffffffffc020561e <do_execve+0x4bc>
    return page - pages + nbase;
ffffffffc02051fc:	f0e2                	sd	s8,96(sp)
ffffffffc02051fe:	000c7c17          	auipc	s8,0xc7
ffffffffc0205202:	092c0c13          	addi	s8,s8,146 # ffffffffc02cc290 <pages>
ffffffffc0205206:	000c3783          	ld	a5,0(s8)
ffffffffc020520a:	f4de                	sd	s7,104(sp)
ffffffffc020520c:	00004b97          	auipc	s7,0x4
ffffffffc0205210:	e8cbbb83          	ld	s7,-372(s7) # ffffffffc0209098 <nbase>
ffffffffc0205214:	40f506b3          	sub	a3,a0,a5
ffffffffc0205218:	ece6                	sd	s9,88(sp)
    return KADDR(page2pa(page));
ffffffffc020521a:	000c7c97          	auipc	s9,0xc7
ffffffffc020521e:	06ec8c93          	addi	s9,s9,110 # ffffffffc02cc288 <npage>
ffffffffc0205222:	f8da                	sd	s6,112(sp)
    return page - pages + nbase;
ffffffffc0205224:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0205226:	5b7d                	li	s6,-1
ffffffffc0205228:	000cb783          	ld	a5,0(s9)
    return page - pages + nbase;
ffffffffc020522c:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc020522e:	00cb5713          	srli	a4,s6,0xc
ffffffffc0205232:	e83a                	sd	a4,16(sp)
ffffffffc0205234:	fcd6                	sd	s5,120(sp)
ffffffffc0205236:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0205238:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020523a:	40f77563          	bgeu	a4,a5,ffffffffc0205644 <do_execve+0x4e2>
ffffffffc020523e:	000c7a97          	auipc	s5,0xc7
ffffffffc0205242:	042a8a93          	addi	s5,s5,66 # ffffffffc02cc280 <va_pa_offset>
ffffffffc0205246:	000ab783          	ld	a5,0(s5)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc020524a:	000c7597          	auipc	a1,0xc7
ffffffffc020524e:	02e5b583          	ld	a1,46(a1) # ffffffffc02cc278 <boot_pgdir_va>
ffffffffc0205252:	6605                	lui	a2,0x1
ffffffffc0205254:	00f68933          	add	s2,a3,a5
ffffffffc0205258:	854a                	mv	a0,s2
ffffffffc020525a:	0d2010ef          	jal	ffffffffc020632c <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc020525e:	66e2                	ld	a3,24(sp)
ffffffffc0205260:	464c47b7          	lui	a5,0x464c4
ffffffffc0205264:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_matrix_out_size+0x464b8e97>
ffffffffc0205268:	4298                	lw	a4,0(a3)
    mm->pgdir = pgdir;
ffffffffc020526a:	0129bc23          	sd	s2,24(s3)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc020526e:	06f70863          	beq	a4,a5,ffffffffc02052de <do_execve+0x17c>
        ret = -E_INVAL_ELF;
ffffffffc0205272:	54e1                	li	s1,-8
    put_pgdir(mm);
ffffffffc0205274:	854a                	mv	a0,s2
ffffffffc0205276:	cc8ff0ef          	jal	ffffffffc020473e <put_pgdir.isra.0>
ffffffffc020527a:	7ae6                	ld	s5,120(sp)
ffffffffc020527c:	7b46                	ld	s6,112(sp)
ffffffffc020527e:	7ba6                	ld	s7,104(sp)
ffffffffc0205280:	7c06                	ld	s8,96(sp)
ffffffffc0205282:	6ce6                	ld	s9,88(sp)
    mm_destroy(mm);
ffffffffc0205284:	854e                	mv	a0,s3
ffffffffc0205286:	c5afe0ef          	jal	ffffffffc02036e0 <mm_destroy>
    do_exit(ret);
ffffffffc020528a:	8526                	mv	a0,s1
ffffffffc020528c:	f122                	sd	s0,160(sp)
ffffffffc020528e:	e152                	sd	s4,128(sp)
ffffffffc0205290:	fcd6                	sd	s5,120(sp)
ffffffffc0205292:	f8da                	sd	s6,112(sp)
ffffffffc0205294:	f4de                	sd	s7,104(sp)
ffffffffc0205296:	f0e2                	sd	s8,96(sp)
ffffffffc0205298:	ece6                	sd	s9,88(sp)
ffffffffc020529a:	e4ee                	sd	s11,72(sp)
ffffffffc020529c:	a75ff0ef          	jal	ffffffffc0204d10 <do_exit>
    if (len > PROC_NAME_LEN)
ffffffffc02052a0:	863e                	mv	a2,a5
    memcpy(local_name, name, len);
ffffffffc02052a2:	85ce                	mv	a1,s3
ffffffffc02052a4:	1808                	addi	a0,sp,48
ffffffffc02052a6:	086010ef          	jal	ffffffffc020632c <memcpy>
    if (mm != NULL)
ffffffffc02052aa:	f00914e3          	bnez	s2,ffffffffc02051b2 <do_execve+0x50>
    if (current->mm != NULL)
ffffffffc02052ae:	000d3783          	ld	a5,0(s10)
ffffffffc02052b2:	779c                	ld	a5,40(a5)
ffffffffc02052b4:	db95                	beqz	a5,ffffffffc02051e8 <do_execve+0x86>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc02052b6:	00003617          	auipc	a2,0x3
ffffffffc02052ba:	eaa60613          	addi	a2,a2,-342 # ffffffffc0208160 <etext+0x1e1c>
ffffffffc02052be:	24c00593          	li	a1,588
ffffffffc02052c2:	00003517          	auipc	a0,0x3
ffffffffc02052c6:	cfe50513          	addi	a0,a0,-770 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc02052ca:	f122                	sd	s0,160(sp)
ffffffffc02052cc:	e152                	sd	s4,128(sp)
ffffffffc02052ce:	fcd6                	sd	s5,120(sp)
ffffffffc02052d0:	f8da                	sd	s6,112(sp)
ffffffffc02052d2:	f4de                	sd	s7,104(sp)
ffffffffc02052d4:	f0e2                	sd	s8,96(sp)
ffffffffc02052d6:	ece6                	sd	s9,88(sp)
ffffffffc02052d8:	e4ee                	sd	s11,72(sp)
ffffffffc02052da:	970fb0ef          	jal	ffffffffc020044a <__panic>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc02052de:	0386d703          	lhu	a4,56(a3)
ffffffffc02052e2:	e152                	sd	s4,128(sp)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc02052e4:	0206ba03          	ld	s4,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc02052e8:	00371793          	slli	a5,a4,0x3
ffffffffc02052ec:	8f99                	sub	a5,a5,a4
ffffffffc02052ee:	078e                	slli	a5,a5,0x3
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc02052f0:	9a36                	add	s4,s4,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc02052f2:	97d2                	add	a5,a5,s4
ffffffffc02052f4:	f122                	sd	s0,160(sp)
ffffffffc02052f6:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc02052f8:	00fa7e63          	bgeu	s4,a5,ffffffffc0205314 <do_execve+0x1b2>
ffffffffc02052fc:	e4ee                	sd	s11,72(sp)
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc02052fe:	000a2783          	lw	a5,0(s4)
ffffffffc0205302:	4705                	li	a4,1
ffffffffc0205304:	10e78763          	beq	a5,a4,ffffffffc0205412 <do_execve+0x2b0>
    for (; ph < ph_end; ph++)
ffffffffc0205308:	77a2                	ld	a5,40(sp)
ffffffffc020530a:	038a0a13          	addi	s4,s4,56
ffffffffc020530e:	fefa68e3          	bltu	s4,a5,ffffffffc02052fe <do_execve+0x19c>
ffffffffc0205312:	6da6                	ld	s11,72(sp)
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0205314:	4701                	li	a4,0
ffffffffc0205316:	46ad                	li	a3,11
ffffffffc0205318:	00100637          	lui	a2,0x100
ffffffffc020531c:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0205320:	854e                	mv	a0,s3
ffffffffc0205322:	c10fe0ef          	jal	ffffffffc0203732 <mm_map>
ffffffffc0205326:	84aa                	mv	s1,a0
ffffffffc0205328:	1a051963          	bnez	a0,ffffffffc02054da <do_execve+0x378>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc020532c:	0189b503          	ld	a0,24(s3)
ffffffffc0205330:	467d                	li	a2,31
ffffffffc0205332:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0205336:	97cfe0ef          	jal	ffffffffc02034b2 <pgdir_alloc_page>
ffffffffc020533a:	3a050463          	beqz	a0,ffffffffc02056e2 <do_execve+0x580>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc020533e:	0189b503          	ld	a0,24(s3)
ffffffffc0205342:	467d                	li	a2,31
ffffffffc0205344:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0205348:	96afe0ef          	jal	ffffffffc02034b2 <pgdir_alloc_page>
ffffffffc020534c:	36050a63          	beqz	a0,ffffffffc02056c0 <do_execve+0x55e>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0205350:	0189b503          	ld	a0,24(s3)
ffffffffc0205354:	467d                	li	a2,31
ffffffffc0205356:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc020535a:	958fe0ef          	jal	ffffffffc02034b2 <pgdir_alloc_page>
ffffffffc020535e:	34050063          	beqz	a0,ffffffffc020569e <do_execve+0x53c>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0205362:	0189b503          	ld	a0,24(s3)
ffffffffc0205366:	467d                	li	a2,31
ffffffffc0205368:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc020536c:	946fe0ef          	jal	ffffffffc02034b2 <pgdir_alloc_page>
ffffffffc0205370:	30050663          	beqz	a0,ffffffffc020567c <do_execve+0x51a>
    mm->mm_count += 1;
ffffffffc0205374:	0309a783          	lw	a5,48(s3)
    current->mm = mm;
ffffffffc0205378:	000d3603          	ld	a2,0(s10)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc020537c:	0189b683          	ld	a3,24(s3)
ffffffffc0205380:	2785                	addiw	a5,a5,1
ffffffffc0205382:	02f9a823          	sw	a5,48(s3)
    current->mm = mm;
ffffffffc0205386:	03363423          	sd	s3,40(a2) # 100028 <_binary_obj___user_matrix_out_size+0xf4940>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc020538a:	c02007b7          	lui	a5,0xc0200
ffffffffc020538e:	2cf6ea63          	bltu	a3,a5,ffffffffc0205662 <do_execve+0x500>
ffffffffc0205392:	000ab783          	ld	a5,0(s5)
ffffffffc0205396:	577d                	li	a4,-1
ffffffffc0205398:	177e                	slli	a4,a4,0x3f
ffffffffc020539a:	8e9d                	sub	a3,a3,a5
ffffffffc020539c:	00c6d793          	srli	a5,a3,0xc
ffffffffc02053a0:	f654                	sd	a3,168(a2)
ffffffffc02053a2:	8fd9                	or	a5,a5,a4
ffffffffc02053a4:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc02053a8:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc02053aa:	4581                	li	a1,0
ffffffffc02053ac:	12000613          	li	a2,288
ffffffffc02053b0:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc02053b2:	10043903          	ld	s2,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc02053b6:	765000ef          	jal	ffffffffc020631a <memset>
    tf->epc = elf->e_entry;
ffffffffc02053ba:	67e2                	ld	a5,24(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02053bc:	000d3983          	ld	s3,0(s10)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc02053c0:	edf97913          	andi	s2,s2,-289
    tf->epc = elf->e_entry;
ffffffffc02053c4:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc02053c6:	4785                	li	a5,1
ffffffffc02053c8:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc02053ca:	02096913          	ori	s2,s2,32
    tf->epc = elf->e_entry;
ffffffffc02053ce:	10e43423          	sd	a4,264(s0)
    tf->gpr.sp = USTACKTOP;
ffffffffc02053d2:	e81c                	sd	a5,16(s0)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc02053d4:	11243023          	sd	s2,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02053d8:	4641                	li	a2,16
ffffffffc02053da:	4581                	li	a1,0
ffffffffc02053dc:	0b498513          	addi	a0,s3,180
ffffffffc02053e0:	73b000ef          	jal	ffffffffc020631a <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02053e4:	180c                	addi	a1,sp,48
ffffffffc02053e6:	0b498513          	addi	a0,s3,180
ffffffffc02053ea:	463d                	li	a2,15
ffffffffc02053ec:	741000ef          	jal	ffffffffc020632c <memcpy>
ffffffffc02053f0:	740a                	ld	s0,160(sp)
ffffffffc02053f2:	6a0a                	ld	s4,128(sp)
ffffffffc02053f4:	7ae6                	ld	s5,120(sp)
ffffffffc02053f6:	7b46                	ld	s6,112(sp)
ffffffffc02053f8:	7ba6                	ld	s7,104(sp)
ffffffffc02053fa:	7c06                	ld	s8,96(sp)
ffffffffc02053fc:	6ce6                	ld	s9,88(sp)
}
ffffffffc02053fe:	70aa                	ld	ra,168(sp)
ffffffffc0205400:	694a                	ld	s2,144(sp)
ffffffffc0205402:	69aa                	ld	s3,136(sp)
ffffffffc0205404:	6d46                	ld	s10,80(sp)
ffffffffc0205406:	8526                	mv	a0,s1
ffffffffc0205408:	64ea                	ld	s1,152(sp)
ffffffffc020540a:	614d                	addi	sp,sp,176
ffffffffc020540c:	8082                	ret
    int ret = -E_NO_MEM;
ffffffffc020540e:	54f1                	li	s1,-4
ffffffffc0205410:	bdad                	j	ffffffffc020528a <do_execve+0x128>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0205412:	028a3603          	ld	a2,40(s4)
ffffffffc0205416:	020a3783          	ld	a5,32(s4)
ffffffffc020541a:	20f66663          	bltu	a2,a5,ffffffffc0205626 <do_execve+0x4c4>
        if (ph->p_flags & ELF_PF_X)
ffffffffc020541e:	004a2783          	lw	a5,4(s4)
ffffffffc0205422:	0027971b          	slliw	a4,a5,0x2
        if (ph->p_flags & ELF_PF_W)
ffffffffc0205426:	0027f693          	andi	a3,a5,2
        if (ph->p_flags & ELF_PF_X)
ffffffffc020542a:	8b11                	andi	a4,a4,4
        if (ph->p_flags & ELF_PF_R)
ffffffffc020542c:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc020542e:	cae9                	beqz	a3,ffffffffc0205500 <do_execve+0x39e>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0205430:	1c079a63          	bnez	a5,ffffffffc0205604 <do_execve+0x4a2>
            perm |= (PTE_W | PTE_R);
ffffffffc0205434:	47dd                	li	a5,23
            vm_flags |= VM_WRITE;
ffffffffc0205436:	00276693          	ori	a3,a4,2
            perm |= (PTE_W | PTE_R);
ffffffffc020543a:	e43e                	sd	a5,8(sp)
        if (vm_flags & VM_EXEC)
ffffffffc020543c:	c709                	beqz	a4,ffffffffc0205446 <do_execve+0x2e4>
            perm |= PTE_X;
ffffffffc020543e:	67a2                	ld	a5,8(sp)
ffffffffc0205440:	0087e793          	ori	a5,a5,8
ffffffffc0205444:	e43e                	sd	a5,8(sp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0205446:	010a3583          	ld	a1,16(s4)
ffffffffc020544a:	4701                	li	a4,0
ffffffffc020544c:	854e                	mv	a0,s3
ffffffffc020544e:	ae4fe0ef          	jal	ffffffffc0203732 <mm_map>
ffffffffc0205452:	84aa                	mv	s1,a0
ffffffffc0205454:	1c051763          	bnez	a0,ffffffffc0205622 <do_execve+0x4c0>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0205458:	010a3b03          	ld	s6,16(s4)
        end = ph->p_va + ph->p_filesz;
ffffffffc020545c:	020a3483          	ld	s1,32(s4)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0205460:	77fd                	lui	a5,0xfffff
ffffffffc0205462:	00fb75b3          	and	a1,s6,a5
        end = ph->p_va + ph->p_filesz;
ffffffffc0205466:	94da                	add	s1,s1,s6
        while (start < end)
ffffffffc0205468:	1a9b7863          	bgeu	s6,s1,ffffffffc0205618 <do_execve+0x4b6>
        unsigned char *from = binary + ph->p_offset;
ffffffffc020546c:	008a3903          	ld	s2,8(s4)
ffffffffc0205470:	67e2                	ld	a5,24(sp)
ffffffffc0205472:	993e                	add	s2,s2,a5
ffffffffc0205474:	a881                	j	ffffffffc02054c4 <do_execve+0x362>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0205476:	6785                	lui	a5,0x1
ffffffffc0205478:	00f58db3          	add	s11,a1,a5
                size -= la - end;
ffffffffc020547c:	41648633          	sub	a2,s1,s6
            if (end < la)
ffffffffc0205480:	01b4e463          	bltu	s1,s11,ffffffffc0205488 <do_execve+0x326>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0205484:	416d8633          	sub	a2,s11,s6
    return page - pages + nbase;
ffffffffc0205488:	000c3683          	ld	a3,0(s8)
    return KADDR(page2pa(page));
ffffffffc020548c:	67c2                	ld	a5,16(sp)
ffffffffc020548e:	000cb503          	ld	a0,0(s9)
    return page - pages + nbase;
ffffffffc0205492:	40d406b3          	sub	a3,s0,a3
ffffffffc0205496:	8699                	srai	a3,a3,0x6
ffffffffc0205498:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc020549a:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc020549e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02054a0:	18a87663          	bgeu	a6,a0,ffffffffc020562c <do_execve+0x4ca>
ffffffffc02054a4:	000ab503          	ld	a0,0(s5)
ffffffffc02054a8:	40bb05b3          	sub	a1,s6,a1
            memcpy(page2kva(page) + off, from, size);
ffffffffc02054ac:	e032                	sd	a2,0(sp)
ffffffffc02054ae:	9536                	add	a0,a0,a3
ffffffffc02054b0:	952e                	add	a0,a0,a1
ffffffffc02054b2:	85ca                	mv	a1,s2
ffffffffc02054b4:	679000ef          	jal	ffffffffc020632c <memcpy>
            start += size, from += size;
ffffffffc02054b8:	6602                	ld	a2,0(sp)
ffffffffc02054ba:	9b32                	add	s6,s6,a2
ffffffffc02054bc:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc02054be:	049b7863          	bgeu	s6,s1,ffffffffc020550e <do_execve+0x3ac>
ffffffffc02054c2:	85ee                	mv	a1,s11
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc02054c4:	0189b503          	ld	a0,24(s3)
ffffffffc02054c8:	6622                	ld	a2,8(sp)
ffffffffc02054ca:	e02e                	sd	a1,0(sp)
ffffffffc02054cc:	fe7fd0ef          	jal	ffffffffc02034b2 <pgdir_alloc_page>
ffffffffc02054d0:	6582                	ld	a1,0(sp)
ffffffffc02054d2:	842a                	mv	s0,a0
ffffffffc02054d4:	f14d                	bnez	a0,ffffffffc0205476 <do_execve+0x314>
ffffffffc02054d6:	6da6                	ld	s11,72(sp)
        ret = -E_NO_MEM;
ffffffffc02054d8:	54f1                	li	s1,-4
    exit_mmap(mm);
ffffffffc02054da:	854e                	mv	a0,s3
ffffffffc02054dc:	bbafe0ef          	jal	ffffffffc0203896 <exit_mmap>
ffffffffc02054e0:	0189b903          	ld	s2,24(s3)
ffffffffc02054e4:	740a                	ld	s0,160(sp)
ffffffffc02054e6:	6a0a                	ld	s4,128(sp)
ffffffffc02054e8:	b371                	j	ffffffffc0205274 <do_execve+0x112>
            exit_mmap(mm);
ffffffffc02054ea:	854a                	mv	a0,s2
ffffffffc02054ec:	baafe0ef          	jal	ffffffffc0203896 <exit_mmap>
            put_pgdir(mm);
ffffffffc02054f0:	01893503          	ld	a0,24(s2)
ffffffffc02054f4:	a4aff0ef          	jal	ffffffffc020473e <put_pgdir.isra.0>
            mm_destroy(mm);
ffffffffc02054f8:	854a                	mv	a0,s2
ffffffffc02054fa:	9e6fe0ef          	jal	ffffffffc02036e0 <mm_destroy>
ffffffffc02054fe:	b1cd                	j	ffffffffc02051e0 <do_execve+0x7e>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0205500:	0e078e63          	beqz	a5,ffffffffc02055fc <do_execve+0x49a>
            perm |= PTE_R;
ffffffffc0205504:	47cd                	li	a5,19
            vm_flags |= VM_READ;
ffffffffc0205506:	00176693          	ori	a3,a4,1
            perm |= PTE_R;
ffffffffc020550a:	e43e                	sd	a5,8(sp)
ffffffffc020550c:	bf05                	j	ffffffffc020543c <do_execve+0x2da>
        end = ph->p_va + ph->p_memsz;
ffffffffc020550e:	010a3483          	ld	s1,16(s4)
ffffffffc0205512:	028a3683          	ld	a3,40(s4)
ffffffffc0205516:	94b6                	add	s1,s1,a3
        if (start < la)
ffffffffc0205518:	07bb7c63          	bgeu	s6,s11,ffffffffc0205590 <do_execve+0x42e>
            if (start == end)
ffffffffc020551c:	df6486e3          	beq	s1,s6,ffffffffc0205308 <do_execve+0x1a6>
                size -= la - end;
ffffffffc0205520:	41648933          	sub	s2,s1,s6
            if (end < la)
ffffffffc0205524:	0fb4f563          	bgeu	s1,s11,ffffffffc020560e <do_execve+0x4ac>
    return page - pages + nbase;
ffffffffc0205528:	000c3683          	ld	a3,0(s8)
    return KADDR(page2pa(page));
ffffffffc020552c:	000cb603          	ld	a2,0(s9)
    return page - pages + nbase;
ffffffffc0205530:	40d406b3          	sub	a3,s0,a3
ffffffffc0205534:	8699                	srai	a3,a3,0x6
ffffffffc0205536:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc0205538:	00c69593          	slli	a1,a3,0xc
ffffffffc020553c:	81b1                	srli	a1,a1,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020553e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0205540:	0ec5f663          	bgeu	a1,a2,ffffffffc020562c <do_execve+0x4ca>
ffffffffc0205544:	000ab603          	ld	a2,0(s5)
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0205548:	6505                	lui	a0,0x1
ffffffffc020554a:	955a                	add	a0,a0,s6
ffffffffc020554c:	96b2                	add	a3,a3,a2
ffffffffc020554e:	41b50533          	sub	a0,a0,s11
            memset(page2kva(page) + off, 0, size);
ffffffffc0205552:	9536                	add	a0,a0,a3
ffffffffc0205554:	864a                	mv	a2,s2
ffffffffc0205556:	4581                	li	a1,0
ffffffffc0205558:	5c3000ef          	jal	ffffffffc020631a <memset>
            start += size;
ffffffffc020555c:	9b4a                	add	s6,s6,s2
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc020555e:	01b4b6b3          	sltu	a3,s1,s11
ffffffffc0205562:	01b4f463          	bgeu	s1,s11,ffffffffc020556a <do_execve+0x408>
ffffffffc0205566:	db6481e3          	beq	s1,s6,ffffffffc0205308 <do_execve+0x1a6>
ffffffffc020556a:	e299                	bnez	a3,ffffffffc0205570 <do_execve+0x40e>
ffffffffc020556c:	03bb0263          	beq	s6,s11,ffffffffc0205590 <do_execve+0x42e>
ffffffffc0205570:	00003697          	auipc	a3,0x3
ffffffffc0205574:	c1868693          	addi	a3,a3,-1000 # ffffffffc0208188 <etext+0x1e44>
ffffffffc0205578:	00001617          	auipc	a2,0x1
ffffffffc020557c:	78060613          	addi	a2,a2,1920 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0205580:	2b500593          	li	a1,693
ffffffffc0205584:	00003517          	auipc	a0,0x3
ffffffffc0205588:	a3c50513          	addi	a0,a0,-1476 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc020558c:	ebffa0ef          	jal	ffffffffc020044a <__panic>
        while (start < end)
ffffffffc0205590:	d69b7ce3          	bgeu	s6,s1,ffffffffc0205308 <do_execve+0x1a6>
ffffffffc0205594:	56fd                	li	a3,-1
ffffffffc0205596:	00c6d793          	srli	a5,a3,0xc
ffffffffc020559a:	f03e                	sd	a5,32(sp)
ffffffffc020559c:	a0b9                	j	ffffffffc02055ea <do_execve+0x488>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc020559e:	6785                	lui	a5,0x1
ffffffffc02055a0:	00fd8833          	add	a6,s11,a5
                size -= la - end;
ffffffffc02055a4:	41648933          	sub	s2,s1,s6
            if (end < la)
ffffffffc02055a8:	0104e463          	bltu	s1,a6,ffffffffc02055b0 <do_execve+0x44e>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc02055ac:	41680933          	sub	s2,a6,s6
    return page - pages + nbase;
ffffffffc02055b0:	000c3683          	ld	a3,0(s8)
    return KADDR(page2pa(page));
ffffffffc02055b4:	7782                	ld	a5,32(sp)
ffffffffc02055b6:	000cb583          	ld	a1,0(s9)
    return page - pages + nbase;
ffffffffc02055ba:	40d406b3          	sub	a3,s0,a3
ffffffffc02055be:	8699                	srai	a3,a3,0x6
ffffffffc02055c0:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc02055c2:	00f6f533          	and	a0,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc02055c6:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02055c8:	06b57263          	bgeu	a0,a1,ffffffffc020562c <do_execve+0x4ca>
ffffffffc02055cc:	000ab583          	ld	a1,0(s5)
ffffffffc02055d0:	41bb0533          	sub	a0,s6,s11
            memset(page2kva(page) + off, 0, size);
ffffffffc02055d4:	864a                	mv	a2,s2
ffffffffc02055d6:	96ae                	add	a3,a3,a1
ffffffffc02055d8:	9536                	add	a0,a0,a3
ffffffffc02055da:	4581                	li	a1,0
            start += size;
ffffffffc02055dc:	9b4a                	add	s6,s6,s2
ffffffffc02055de:	e042                	sd	a6,0(sp)
            memset(page2kva(page) + off, 0, size);
ffffffffc02055e0:	53b000ef          	jal	ffffffffc020631a <memset>
        while (start < end)
ffffffffc02055e4:	d29b72e3          	bgeu	s6,s1,ffffffffc0205308 <do_execve+0x1a6>
ffffffffc02055e8:	6d82                	ld	s11,0(sp)
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc02055ea:	0189b503          	ld	a0,24(s3)
ffffffffc02055ee:	6622                	ld	a2,8(sp)
ffffffffc02055f0:	85ee                	mv	a1,s11
ffffffffc02055f2:	ec1fd0ef          	jal	ffffffffc02034b2 <pgdir_alloc_page>
ffffffffc02055f6:	842a                	mv	s0,a0
ffffffffc02055f8:	f15d                	bnez	a0,ffffffffc020559e <do_execve+0x43c>
ffffffffc02055fa:	bdf1                	j	ffffffffc02054d6 <do_execve+0x374>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc02055fc:	47c5                	li	a5,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc02055fe:	86ba                	mv	a3,a4
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0205600:	e43e                	sd	a5,8(sp)
ffffffffc0205602:	bd2d                	j	ffffffffc020543c <do_execve+0x2da>
            perm |= (PTE_W | PTE_R);
ffffffffc0205604:	47dd                	li	a5,23
            vm_flags |= VM_READ;
ffffffffc0205606:	00376693          	ori	a3,a4,3
            perm |= (PTE_W | PTE_R);
ffffffffc020560a:	e43e                	sd	a5,8(sp)
ffffffffc020560c:	bd05                	j	ffffffffc020543c <do_execve+0x2da>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc020560e:	416d8933          	sub	s2,s11,s6
ffffffffc0205612:	bf19                	j	ffffffffc0205528 <do_execve+0x3c6>
        return -E_INVAL;
ffffffffc0205614:	54f5                	li	s1,-3
ffffffffc0205616:	b3e5                	j	ffffffffc02053fe <do_execve+0x29c>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0205618:	8dae                	mv	s11,a1
        while (start < end)
ffffffffc020561a:	84da                	mv	s1,s6
ffffffffc020561c:	bddd                	j	ffffffffc0205512 <do_execve+0x3b0>
    int ret = -E_NO_MEM;
ffffffffc020561e:	54f1                	li	s1,-4
ffffffffc0205620:	b195                	j	ffffffffc0205284 <do_execve+0x122>
ffffffffc0205622:	6da6                	ld	s11,72(sp)
ffffffffc0205624:	bd5d                	j	ffffffffc02054da <do_execve+0x378>
            ret = -E_INVAL_ELF;
ffffffffc0205626:	6da6                	ld	s11,72(sp)
ffffffffc0205628:	54e1                	li	s1,-8
ffffffffc020562a:	bd45                	j	ffffffffc02054da <do_execve+0x378>
ffffffffc020562c:	00002617          	auipc	a2,0x2
ffffffffc0205630:	a7c60613          	addi	a2,a2,-1412 # ffffffffc02070a8 <etext+0xd64>
ffffffffc0205634:	07100593          	li	a1,113
ffffffffc0205638:	00002517          	auipc	a0,0x2
ffffffffc020563c:	a9850513          	addi	a0,a0,-1384 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc0205640:	e0bfa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205644:	00002617          	auipc	a2,0x2
ffffffffc0205648:	a6460613          	addi	a2,a2,-1436 # ffffffffc02070a8 <etext+0xd64>
ffffffffc020564c:	07100593          	li	a1,113
ffffffffc0205650:	00002517          	auipc	a0,0x2
ffffffffc0205654:	a8050513          	addi	a0,a0,-1408 # ffffffffc02070d0 <etext+0xd8c>
ffffffffc0205658:	f122                	sd	s0,160(sp)
ffffffffc020565a:	e152                	sd	s4,128(sp)
ffffffffc020565c:	e4ee                	sd	s11,72(sp)
ffffffffc020565e:	dedfa0ef          	jal	ffffffffc020044a <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0205662:	00002617          	auipc	a2,0x2
ffffffffc0205666:	aee60613          	addi	a2,a2,-1298 # ffffffffc0207150 <etext+0xe0c>
ffffffffc020566a:	2d400593          	li	a1,724
ffffffffc020566e:	00003517          	auipc	a0,0x3
ffffffffc0205672:	95250513          	addi	a0,a0,-1710 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc0205676:	e4ee                	sd	s11,72(sp)
ffffffffc0205678:	dd3fa0ef          	jal	ffffffffc020044a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc020567c:	00003697          	auipc	a3,0x3
ffffffffc0205680:	c2468693          	addi	a3,a3,-988 # ffffffffc02082a0 <etext+0x1f5c>
ffffffffc0205684:	00001617          	auipc	a2,0x1
ffffffffc0205688:	67460613          	addi	a2,a2,1652 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc020568c:	2cf00593          	li	a1,719
ffffffffc0205690:	00003517          	auipc	a0,0x3
ffffffffc0205694:	93050513          	addi	a0,a0,-1744 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc0205698:	e4ee                	sd	s11,72(sp)
ffffffffc020569a:	db1fa0ef          	jal	ffffffffc020044a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc020569e:	00003697          	auipc	a3,0x3
ffffffffc02056a2:	bba68693          	addi	a3,a3,-1094 # ffffffffc0208258 <etext+0x1f14>
ffffffffc02056a6:	00001617          	auipc	a2,0x1
ffffffffc02056aa:	65260613          	addi	a2,a2,1618 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02056ae:	2ce00593          	li	a1,718
ffffffffc02056b2:	00003517          	auipc	a0,0x3
ffffffffc02056b6:	90e50513          	addi	a0,a0,-1778 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc02056ba:	e4ee                	sd	s11,72(sp)
ffffffffc02056bc:	d8ffa0ef          	jal	ffffffffc020044a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc02056c0:	00003697          	auipc	a3,0x3
ffffffffc02056c4:	b5068693          	addi	a3,a3,-1200 # ffffffffc0208210 <etext+0x1ecc>
ffffffffc02056c8:	00001617          	auipc	a2,0x1
ffffffffc02056cc:	63060613          	addi	a2,a2,1584 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02056d0:	2cd00593          	li	a1,717
ffffffffc02056d4:	00003517          	auipc	a0,0x3
ffffffffc02056d8:	8ec50513          	addi	a0,a0,-1812 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc02056dc:	e4ee                	sd	s11,72(sp)
ffffffffc02056de:	d6dfa0ef          	jal	ffffffffc020044a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc02056e2:	00003697          	auipc	a3,0x3
ffffffffc02056e6:	ae668693          	addi	a3,a3,-1306 # ffffffffc02081c8 <etext+0x1e84>
ffffffffc02056ea:	00001617          	auipc	a2,0x1
ffffffffc02056ee:	60e60613          	addi	a2,a2,1550 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02056f2:	2cc00593          	li	a1,716
ffffffffc02056f6:	00003517          	auipc	a0,0x3
ffffffffc02056fa:	8ca50513          	addi	a0,a0,-1846 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc02056fe:	e4ee                	sd	s11,72(sp)
ffffffffc0205700:	d4bfa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205704 <user_main>:
{
ffffffffc0205704:	1101                	addi	sp,sp,-32
ffffffffc0205706:	e426                	sd	s1,8(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0205708:	000c7497          	auipc	s1,0xc7
ffffffffc020570c:	b9848493          	addi	s1,s1,-1128 # ffffffffc02cc2a0 <current>
ffffffffc0205710:	609c                	ld	a5,0(s1)
ffffffffc0205712:	00003617          	auipc	a2,0x3
ffffffffc0205716:	bd660613          	addi	a2,a2,-1066 # ffffffffc02082e8 <etext+0x1fa4>
ffffffffc020571a:	00003517          	auipc	a0,0x3
ffffffffc020571e:	bd650513          	addi	a0,a0,-1066 # ffffffffc02082f0 <etext+0x1fac>
ffffffffc0205722:	43cc                	lw	a1,4(a5)
{
ffffffffc0205724:	ec06                	sd	ra,24(sp)
ffffffffc0205726:	e822                	sd	s0,16(sp)
ffffffffc0205728:	e04a                	sd	s2,0(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc020572a:	a6ffa0ef          	jal	ffffffffc0200198 <cprintf>
    size_t len = strlen(name);
ffffffffc020572e:	00003517          	auipc	a0,0x3
ffffffffc0205732:	bba50513          	addi	a0,a0,-1094 # ffffffffc02082e8 <etext+0x1fa4>
ffffffffc0205736:	331000ef          	jal	ffffffffc0206266 <strlen>
    struct trapframe *old_tf = current->tf;
ffffffffc020573a:	6098                	ld	a4,0(s1)
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc020573c:	6789                	lui	a5,0x2
ffffffffc020573e:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_softint_out_size-0x7200>
ffffffffc0205742:	6b00                	ld	s0,16(a4)
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0205744:	734c                	ld	a1,160(a4)
    size_t len = strlen(name);
ffffffffc0205746:	892a                	mv	s2,a0
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0205748:	943e                	add	s0,s0,a5
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc020574a:	12000613          	li	a2,288
ffffffffc020574e:	8522                	mv	a0,s0
ffffffffc0205750:	3dd000ef          	jal	ffffffffc020632c <memcpy>
    current->tf = new_tf;
ffffffffc0205754:	609c                	ld	a5,0(s1)
    ret = do_execve(name, len, binary, size);
ffffffffc0205756:	85ca                	mv	a1,s2
ffffffffc0205758:	3fe06697          	auipc	a3,0x3fe06
ffffffffc020575c:	f9068693          	addi	a3,a3,-112 # b6e8 <_binary_obj___user_matrix_out_size>
    current->tf = new_tf;
ffffffffc0205760:	f3c0                	sd	s0,160(a5)
    ret = do_execve(name, len, binary, size);
ffffffffc0205762:	0005f617          	auipc	a2,0x5f
ffffffffc0205766:	abe60613          	addi	a2,a2,-1346 # ffffffffc0264220 <_binary_obj___user_matrix_out_start>
ffffffffc020576a:	00003517          	auipc	a0,0x3
ffffffffc020576e:	b7e50513          	addi	a0,a0,-1154 # ffffffffc02082e8 <etext+0x1fa4>
ffffffffc0205772:	9f1ff0ef          	jal	ffffffffc0205162 <do_execve>
    asm volatile(
ffffffffc0205776:	8122                	mv	sp,s0
ffffffffc0205778:	e2cfb06f          	j	ffffffffc0200da4 <__trapret>
    panic("user_main execve failed.\n");
ffffffffc020577c:	00003617          	auipc	a2,0x3
ffffffffc0205780:	b9c60613          	addi	a2,a2,-1124 # ffffffffc0208318 <etext+0x1fd4>
ffffffffc0205784:	3b800593          	li	a1,952
ffffffffc0205788:	00003517          	auipc	a0,0x3
ffffffffc020578c:	83850513          	addi	a0,a0,-1992 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc0205790:	cbbfa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205794 <do_yield>:
    current->need_resched = 1;
ffffffffc0205794:	000c7797          	auipc	a5,0xc7
ffffffffc0205798:	b0c7b783          	ld	a5,-1268(a5) # ffffffffc02cc2a0 <current>
ffffffffc020579c:	4705                	li	a4,1
}
ffffffffc020579e:	4501                	li	a0,0
    current->need_resched = 1;
ffffffffc02057a0:	ef98                	sd	a4,24(a5)
}
ffffffffc02057a2:	8082                	ret

ffffffffc02057a4 <do_wait>:
    if (code_store != NULL)
ffffffffc02057a4:	c59d                	beqz	a1,ffffffffc02057d2 <do_wait+0x2e>
{
ffffffffc02057a6:	1101                	addi	sp,sp,-32
ffffffffc02057a8:	e02a                	sd	a0,0(sp)
    struct mm_struct *mm = current->mm;
ffffffffc02057aa:	000c7517          	auipc	a0,0xc7
ffffffffc02057ae:	af653503          	ld	a0,-1290(a0) # ffffffffc02cc2a0 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc02057b2:	4685                	li	a3,1
ffffffffc02057b4:	4611                	li	a2,4
ffffffffc02057b6:	7508                	ld	a0,40(a0)
{
ffffffffc02057b8:	ec06                	sd	ra,24(sp)
ffffffffc02057ba:	e42e                	sd	a1,8(sp)
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc02057bc:	c78fe0ef          	jal	ffffffffc0203c34 <user_mem_check>
ffffffffc02057c0:	6702                	ld	a4,0(sp)
ffffffffc02057c2:	67a2                	ld	a5,8(sp)
ffffffffc02057c4:	c909                	beqz	a0,ffffffffc02057d6 <do_wait+0x32>
}
ffffffffc02057c6:	60e2                	ld	ra,24(sp)
ffffffffc02057c8:	85be                	mv	a1,a5
ffffffffc02057ca:	853a                	mv	a0,a4
ffffffffc02057cc:	6105                	addi	sp,sp,32
ffffffffc02057ce:	e8aff06f          	j	ffffffffc0204e58 <do_wait.part.0>
ffffffffc02057d2:	e86ff06f          	j	ffffffffc0204e58 <do_wait.part.0>
ffffffffc02057d6:	60e2                	ld	ra,24(sp)
ffffffffc02057d8:	5575                	li	a0,-3
ffffffffc02057da:	6105                	addi	sp,sp,32
ffffffffc02057dc:	8082                	ret

ffffffffc02057de <do_kill>:
    if (0 < pid && pid < MAX_PID)
ffffffffc02057de:	6789                	lui	a5,0x2
ffffffffc02057e0:	fff5071b          	addiw	a4,a0,-1
ffffffffc02057e4:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x70e2>
ffffffffc02057e6:	06e7e463          	bltu	a5,a4,ffffffffc020584e <do_kill+0x70>
{
ffffffffc02057ea:	1101                	addi	sp,sp,-32
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02057ec:	45a9                	li	a1,10
{
ffffffffc02057ee:	ec06                	sd	ra,24(sp)
ffffffffc02057f0:	e42a                	sd	a0,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02057f2:	692000ef          	jal	ffffffffc0205e84 <hash32>
ffffffffc02057f6:	02051793          	slli	a5,a0,0x20
ffffffffc02057fa:	01c7d693          	srli	a3,a5,0x1c
ffffffffc02057fe:	000c3797          	auipc	a5,0xc3
ffffffffc0205802:	a0278793          	addi	a5,a5,-1534 # ffffffffc02c8200 <hash_list>
ffffffffc0205806:	96be                	add	a3,a3,a5
        while ((le = list_next(le)) != list)
ffffffffc0205808:	6622                	ld	a2,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc020580a:	8536                	mv	a0,a3
        while ((le = list_next(le)) != list)
ffffffffc020580c:	a029                	j	ffffffffc0205816 <do_kill+0x38>
            if (proc->pid == pid)
ffffffffc020580e:	f2c52703          	lw	a4,-212(a0)
ffffffffc0205812:	00c70963          	beq	a4,a2,ffffffffc0205824 <do_kill+0x46>
ffffffffc0205816:	6508                	ld	a0,8(a0)
        while ((le = list_next(le)) != list)
ffffffffc0205818:	fea69be3          	bne	a3,a0,ffffffffc020580e <do_kill+0x30>
}
ffffffffc020581c:	60e2                	ld	ra,24(sp)
    return -E_INVAL;
ffffffffc020581e:	5575                	li	a0,-3
}
ffffffffc0205820:	6105                	addi	sp,sp,32
ffffffffc0205822:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0205824:	fd852703          	lw	a4,-40(a0)
ffffffffc0205828:	00177693          	andi	a3,a4,1
ffffffffc020582c:	e29d                	bnez	a3,ffffffffc0205852 <do_kill+0x74>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc020582e:	4954                	lw	a3,20(a0)
            proc->flags |= PF_EXITING;
ffffffffc0205830:	00176713          	ori	a4,a4,1
ffffffffc0205834:	fce52c23          	sw	a4,-40(a0)
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0205838:	0006c663          	bltz	a3,ffffffffc0205844 <do_kill+0x66>
            return 0;
ffffffffc020583c:	4501                	li	a0,0
}
ffffffffc020583e:	60e2                	ld	ra,24(sp)
ffffffffc0205840:	6105                	addi	sp,sp,32
ffffffffc0205842:	8082                	ret
                wakeup_proc(proc);
ffffffffc0205844:	f2850513          	addi	a0,a0,-216
ffffffffc0205848:	3dc000ef          	jal	ffffffffc0205c24 <wakeup_proc>
ffffffffc020584c:	bfc5                	j	ffffffffc020583c <do_kill+0x5e>
    return -E_INVAL;
ffffffffc020584e:	5575                	li	a0,-3
}
ffffffffc0205850:	8082                	ret
        return -E_KILLED;
ffffffffc0205852:	555d                	li	a0,-9
ffffffffc0205854:	b7ed                	j	ffffffffc020583e <do_kill+0x60>

ffffffffc0205856 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0205856:	1101                	addi	sp,sp,-32
ffffffffc0205858:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc020585a:	000c7797          	auipc	a5,0xc7
ffffffffc020585e:	9a678793          	addi	a5,a5,-1626 # ffffffffc02cc200 <proc_list>
ffffffffc0205862:	ec06                	sd	ra,24(sp)
ffffffffc0205864:	e822                	sd	s0,16(sp)
ffffffffc0205866:	e04a                	sd	s2,0(sp)
ffffffffc0205868:	000c3497          	auipc	s1,0xc3
ffffffffc020586c:	99848493          	addi	s1,s1,-1640 # ffffffffc02c8200 <hash_list>
ffffffffc0205870:	e79c                	sd	a5,8(a5)
ffffffffc0205872:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0205874:	000c7717          	auipc	a4,0xc7
ffffffffc0205878:	98c70713          	addi	a4,a4,-1652 # ffffffffc02cc200 <proc_list>
ffffffffc020587c:	87a6                	mv	a5,s1
ffffffffc020587e:	e79c                	sd	a5,8(a5)
ffffffffc0205880:	e39c                	sd	a5,0(a5)
ffffffffc0205882:	07c1                	addi	a5,a5,16
ffffffffc0205884:	fee79de3          	bne	a5,a4,ffffffffc020587e <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0205888:	e0ffe0ef          	jal	ffffffffc0204696 <alloc_proc>
ffffffffc020588c:	000c7917          	auipc	s2,0xc7
ffffffffc0205890:	a2490913          	addi	s2,s2,-1500 # ffffffffc02cc2b0 <idleproc>
ffffffffc0205894:	00a93023          	sd	a0,0(s2)
ffffffffc0205898:	10050363          	beqz	a0,ffffffffc020599e <proc_init+0x148>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc020589c:	4789                	li	a5,2
ffffffffc020589e:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02058a0:	00004797          	auipc	a5,0x4
ffffffffc02058a4:	76078793          	addi	a5,a5,1888 # ffffffffc020a000 <bootstack>
ffffffffc02058a8:	e91c                	sd	a5,16(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02058aa:	0b450413          	addi	s0,a0,180
    idleproc->need_resched = 1;
ffffffffc02058ae:	4785                	li	a5,1
ffffffffc02058b0:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02058b2:	4641                	li	a2,16
ffffffffc02058b4:	8522                	mv	a0,s0
ffffffffc02058b6:	4581                	li	a1,0
ffffffffc02058b8:	263000ef          	jal	ffffffffc020631a <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02058bc:	8522                	mv	a0,s0
ffffffffc02058be:	463d                	li	a2,15
ffffffffc02058c0:	00003597          	auipc	a1,0x3
ffffffffc02058c4:	a9058593          	addi	a1,a1,-1392 # ffffffffc0208350 <etext+0x200c>
ffffffffc02058c8:	265000ef          	jal	ffffffffc020632c <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc02058cc:	000c7797          	auipc	a5,0xc7
ffffffffc02058d0:	9d07a783          	lw	a5,-1584(a5) # ffffffffc02cc29c <nr_process>

    current = idleproc;
ffffffffc02058d4:	00093703          	ld	a4,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02058d8:	4601                	li	a2,0
    nr_process++;
ffffffffc02058da:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02058dc:	4581                	li	a1,0
ffffffffc02058de:	fffff517          	auipc	a0,0xfffff
ffffffffc02058e2:	75c50513          	addi	a0,a0,1884 # ffffffffc020503a <init_main>
    current = idleproc;
ffffffffc02058e6:	000c7697          	auipc	a3,0xc7
ffffffffc02058ea:	9ae6bd23          	sd	a4,-1606(a3) # ffffffffc02cc2a0 <current>
    nr_process++;
ffffffffc02058ee:	000c7717          	auipc	a4,0xc7
ffffffffc02058f2:	9af72723          	sw	a5,-1618(a4) # ffffffffc02cc29c <nr_process>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02058f6:	bcaff0ef          	jal	ffffffffc0204cc0 <kernel_thread>
ffffffffc02058fa:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc02058fc:	08a05563          	blez	a0,ffffffffc0205986 <proc_init+0x130>
    if (0 < pid && pid < MAX_PID)
ffffffffc0205900:	6789                	lui	a5,0x2
ffffffffc0205902:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x70e2>
ffffffffc0205904:	fff5071b          	addiw	a4,a0,-1
ffffffffc0205908:	02e7e463          	bltu	a5,a4,ffffffffc0205930 <proc_init+0xda>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc020590c:	45a9                	li	a1,10
ffffffffc020590e:	576000ef          	jal	ffffffffc0205e84 <hash32>
ffffffffc0205912:	02051713          	slli	a4,a0,0x20
ffffffffc0205916:	01c75793          	srli	a5,a4,0x1c
ffffffffc020591a:	00f486b3          	add	a3,s1,a5
ffffffffc020591e:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0205920:	a029                	j	ffffffffc020592a <proc_init+0xd4>
            if (proc->pid == pid)
ffffffffc0205922:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0205926:	04870d63          	beq	a4,s0,ffffffffc0205980 <proc_init+0x12a>
    return listelm->next;
ffffffffc020592a:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020592c:	fef69be3          	bne	a3,a5,ffffffffc0205922 <proc_init+0xcc>
    return NULL;
ffffffffc0205930:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205932:	0b478413          	addi	s0,a5,180
ffffffffc0205936:	4641                	li	a2,16
ffffffffc0205938:	4581                	li	a1,0
ffffffffc020593a:	8522                	mv	a0,s0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc020593c:	000c7717          	auipc	a4,0xc7
ffffffffc0205940:	96f73623          	sd	a5,-1684(a4) # ffffffffc02cc2a8 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205944:	1d7000ef          	jal	ffffffffc020631a <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205948:	8522                	mv	a0,s0
ffffffffc020594a:	463d                	li	a2,15
ffffffffc020594c:	00003597          	auipc	a1,0x3
ffffffffc0205950:	a2c58593          	addi	a1,a1,-1492 # ffffffffc0208378 <etext+0x2034>
ffffffffc0205954:	1d9000ef          	jal	ffffffffc020632c <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205958:	00093783          	ld	a5,0(s2)
ffffffffc020595c:	cfad                	beqz	a5,ffffffffc02059d6 <proc_init+0x180>
ffffffffc020595e:	43dc                	lw	a5,4(a5)
ffffffffc0205960:	ebbd                	bnez	a5,ffffffffc02059d6 <proc_init+0x180>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205962:	000c7797          	auipc	a5,0xc7
ffffffffc0205966:	9467b783          	ld	a5,-1722(a5) # ffffffffc02cc2a8 <initproc>
ffffffffc020596a:	c7b1                	beqz	a5,ffffffffc02059b6 <proc_init+0x160>
ffffffffc020596c:	43d8                	lw	a4,4(a5)
ffffffffc020596e:	4785                	li	a5,1
ffffffffc0205970:	04f71363          	bne	a4,a5,ffffffffc02059b6 <proc_init+0x160>
}
ffffffffc0205974:	60e2                	ld	ra,24(sp)
ffffffffc0205976:	6442                	ld	s0,16(sp)
ffffffffc0205978:	64a2                	ld	s1,8(sp)
ffffffffc020597a:	6902                	ld	s2,0(sp)
ffffffffc020597c:	6105                	addi	sp,sp,32
ffffffffc020597e:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0205980:	f2878793          	addi	a5,a5,-216
ffffffffc0205984:	b77d                	j	ffffffffc0205932 <proc_init+0xdc>
        panic("create init_main failed.\n");
ffffffffc0205986:	00003617          	auipc	a2,0x3
ffffffffc020598a:	9d260613          	addi	a2,a2,-1582 # ffffffffc0208358 <etext+0x2014>
ffffffffc020598e:	3f800593          	li	a1,1016
ffffffffc0205992:	00002517          	auipc	a0,0x2
ffffffffc0205996:	62e50513          	addi	a0,a0,1582 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc020599a:	ab1fa0ef          	jal	ffffffffc020044a <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc020599e:	00003617          	auipc	a2,0x3
ffffffffc02059a2:	99a60613          	addi	a2,a2,-1638 # ffffffffc0208338 <etext+0x1ff4>
ffffffffc02059a6:	3e900593          	li	a1,1001
ffffffffc02059aa:	00002517          	auipc	a0,0x2
ffffffffc02059ae:	61650513          	addi	a0,a0,1558 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc02059b2:	a99fa0ef          	jal	ffffffffc020044a <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02059b6:	00003697          	auipc	a3,0x3
ffffffffc02059ba:	9f268693          	addi	a3,a3,-1550 # ffffffffc02083a8 <etext+0x2064>
ffffffffc02059be:	00001617          	auipc	a2,0x1
ffffffffc02059c2:	33a60613          	addi	a2,a2,826 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02059c6:	3ff00593          	li	a1,1023
ffffffffc02059ca:	00002517          	auipc	a0,0x2
ffffffffc02059ce:	5f650513          	addi	a0,a0,1526 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc02059d2:	a79fa0ef          	jal	ffffffffc020044a <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02059d6:	00003697          	auipc	a3,0x3
ffffffffc02059da:	9aa68693          	addi	a3,a3,-1622 # ffffffffc0208380 <etext+0x203c>
ffffffffc02059de:	00001617          	auipc	a2,0x1
ffffffffc02059e2:	31a60613          	addi	a2,a2,794 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc02059e6:	3fe00593          	li	a1,1022
ffffffffc02059ea:	00002517          	auipc	a0,0x2
ffffffffc02059ee:	5d650513          	addi	a0,a0,1494 # ffffffffc0207fc0 <etext+0x1c7c>
ffffffffc02059f2:	a59fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02059f6 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc02059f6:	1141                	addi	sp,sp,-16
ffffffffc02059f8:	e022                	sd	s0,0(sp)
ffffffffc02059fa:	e406                	sd	ra,8(sp)
ffffffffc02059fc:	000c7417          	auipc	s0,0xc7
ffffffffc0205a00:	8a440413          	addi	s0,s0,-1884 # ffffffffc02cc2a0 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0205a04:	6018                	ld	a4,0(s0)
ffffffffc0205a06:	6f1c                	ld	a5,24(a4)
ffffffffc0205a08:	dffd                	beqz	a5,ffffffffc0205a06 <cpu_idle+0x10>
        {
            schedule();
ffffffffc0205a0a:	2c0000ef          	jal	ffffffffc0205cca <schedule>
ffffffffc0205a0e:	bfdd                	j	ffffffffc0205a04 <cpu_idle+0xe>

ffffffffc0205a10 <lab6_set_priority>:
    }
}
// FOR LAB6, set the process's priority (bigger value will get more CPU time)
void lab6_set_priority(uint32_t priority)
{
    if (priority <= 5) cprintf("set priority to %d\n", priority);
ffffffffc0205a10:	4795                	li	a5,5
{
ffffffffc0205a12:	85aa                	mv	a1,a0
    if (priority <= 5) cprintf("set priority to %d\n", priority);
ffffffffc0205a14:	00a7f963          	bgeu	a5,a0,ffffffffc0205a26 <lab6_set_priority+0x16>
    if (priority == 0)
        current->lab6_priority = 1;
    else
        current->lab6_priority = priority;
ffffffffc0205a18:	000c7797          	auipc	a5,0xc7
ffffffffc0205a1c:	8887b783          	ld	a5,-1912(a5) # ffffffffc02cc2a0 <current>
ffffffffc0205a20:	14a7a223          	sw	a0,324(a5)
ffffffffc0205a24:	8082                	ret
{
ffffffffc0205a26:	1101                	addi	sp,sp,-32
    if (priority <= 5) cprintf("set priority to %d\n", priority);
ffffffffc0205a28:	e42a                	sd	a0,8(sp)
ffffffffc0205a2a:	00003517          	auipc	a0,0x3
ffffffffc0205a2e:	9a650513          	addi	a0,a0,-1626 # ffffffffc02083d0 <etext+0x208c>
{
ffffffffc0205a32:	ec06                	sd	ra,24(sp)
    if (priority <= 5) cprintf("set priority to %d\n", priority);
ffffffffc0205a34:	f64fa0ef          	jal	ffffffffc0200198 <cprintf>
    if (priority == 0)
ffffffffc0205a38:	65a2                	ld	a1,8(sp)
        current->lab6_priority = 1;
ffffffffc0205a3a:	000c7797          	auipc	a5,0xc7
ffffffffc0205a3e:	8667b783          	ld	a5,-1946(a5) # ffffffffc02cc2a0 <current>
    if (priority == 0)
ffffffffc0205a42:	c591                	beqz	a1,ffffffffc0205a4e <lab6_set_priority+0x3e>
}
ffffffffc0205a44:	60e2                	ld	ra,24(sp)
        current->lab6_priority = priority;
ffffffffc0205a46:	14b7a223          	sw	a1,324(a5)
}
ffffffffc0205a4a:	6105                	addi	sp,sp,32
ffffffffc0205a4c:	8082                	ret
ffffffffc0205a4e:	60e2                	ld	ra,24(sp)
        current->lab6_priority = 1;
ffffffffc0205a50:	4705                	li	a4,1
ffffffffc0205a52:	14e7a223          	sw	a4,324(a5)
}
ffffffffc0205a56:	6105                	addi	sp,sp,32
ffffffffc0205a58:	8082                	ret

ffffffffc0205a5a <do_sleep>:

// do_sleep - simplified sleep implementation (yield multiple times)
int do_sleep(unsigned int time) {
    if (time == 0) {
ffffffffc0205a5a:	c919                	beqz	a0,ffffffffc0205a70 <do_sleep+0x16>
    current->need_resched = 1;
ffffffffc0205a5c:	000c7697          	auipc	a3,0xc7
ffffffffc0205a60:	8446b683          	ld	a3,-1980(a3) # ffffffffc02cc2a0 <current>
        return 0;
    }
    // Yield multiple times to allow other processes to run
    for (unsigned int i = 0; i < time; i++) {
ffffffffc0205a64:	4781                	li	a5,0
    current->need_resched = 1;
ffffffffc0205a66:	4705                	li	a4,1
ffffffffc0205a68:	ee98                	sd	a4,24(a3)
    for (unsigned int i = 0; i < time; i++) {
ffffffffc0205a6a:	2785                	addiw	a5,a5,1
ffffffffc0205a6c:	fef51ee3          	bne	a0,a5,ffffffffc0205a68 <do_sleep+0xe>
        do_yield();
    }
    return 0;
}
ffffffffc0205a70:	4501                	li	a0,0
ffffffffc0205a72:	8082                	ret

ffffffffc0205a74 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0205a74:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0205a78:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0205a7c:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0205a7e:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0205a80:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0205a84:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0205a88:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0205a8c:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0205a90:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0205a94:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0205a98:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0205a9c:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0205aa0:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0205aa4:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0205aa8:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0205aac:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0205ab0:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0205ab2:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0205ab4:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0205ab8:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0205abc:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0205ac0:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0205ac4:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0205ac8:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0205acc:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0205ad0:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0205ad4:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0205ad8:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0205adc:	8082                	ret

ffffffffc0205ade <RR_init>:
    elm->prev = elm->next = elm;
ffffffffc0205ade:	e508                	sd	a0,8(a0)
ffffffffc0205ae0:	e108                	sd	a0,0(a0)
 */
static void
RR_init(struct run_queue *rq)
{
    list_init(&rq->run_list);
    rq->proc_num = 0;
ffffffffc0205ae2:	00052823          	sw	zero,16(a0)
    /* ensure lab6 run pool cleared if present */
    rq->lab6_run_pool = NULL;
ffffffffc0205ae6:	00053c23          	sd	zero,24(a0)
}
ffffffffc0205aea:	8082                	ret

ffffffffc0205aec <RR_pick_next>:
    return list->next == list;
ffffffffc0205aec:	651c                	ld	a5,8(a0)
/*
 */
static struct proc_struct *
RR_pick_next(struct run_queue *rq)
{
    if (list_empty(&rq->run_list)){
ffffffffc0205aee:	00f50563          	beq	a0,a5,ffffffffc0205af8 <RR_pick_next+0xc>
        return idleproc;
    }
    list_entry_t *le = list_next(&rq->run_list);
    struct proc_struct *p = le2proc(le, run_link);
ffffffffc0205af2:	ef078513          	addi	a0,a5,-272
// DEBUG:     if (p->pid >= 2 && p->pid <= 7) cprintf("RR_pick_next: picked pid=%d\n", p->pid);
    return p;
}
ffffffffc0205af6:	8082                	ret
        return idleproc;
ffffffffc0205af8:	000c6517          	auipc	a0,0xc6
ffffffffc0205afc:	7b853503          	ld	a0,1976(a0) # ffffffffc02cc2b0 <idleproc>
ffffffffc0205b00:	8082                	ret

ffffffffc0205b02 <RR_proc_tick>:
/*
 */
static void
RR_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
    if (proc == idleproc || !proc) {
ffffffffc0205b02:	000c6797          	auipc	a5,0xc6
ffffffffc0205b06:	7ae7b783          	ld	a5,1966(a5) # ffffffffc02cc2b0 <idleproc>
ffffffffc0205b0a:	00b78d63          	beq	a5,a1,ffffffffc0205b24 <RR_proc_tick+0x22>
ffffffffc0205b0e:	c999                	beqz	a1,ffffffffc0205b24 <RR_proc_tick+0x22>
        return;
    }
    /* decrease time slice, trigger reschedule when exhausted */
    if (proc->time_slice > 0) {
ffffffffc0205b10:	1205a783          	lw	a5,288(a1)
ffffffffc0205b14:	00f05563          	blez	a5,ffffffffc0205b1e <RR_proc_tick+0x1c>
        proc->time_slice--;
ffffffffc0205b18:	37fd                	addiw	a5,a5,-1
ffffffffc0205b1a:	12f5a023          	sw	a5,288(a1)
    }
    if (proc->time_slice == 0) {
ffffffffc0205b1e:	e399                	bnez	a5,ffffffffc0205b24 <RR_proc_tick+0x22>
        proc->need_resched = 1;
ffffffffc0205b20:	4785                	li	a5,1
ffffffffc0205b22:	ed9c                	sd	a5,24(a1)
    }
}
ffffffffc0205b24:	8082                	ret

ffffffffc0205b26 <RR_dequeue>:
    assert(proc && proc->rq == rq);
ffffffffc0205b26:	c59d                	beqz	a1,ffffffffc0205b54 <RR_dequeue+0x2e>
ffffffffc0205b28:	1085b783          	ld	a5,264(a1)
ffffffffc0205b2c:	02a79463          	bne	a5,a0,ffffffffc0205b54 <RR_dequeue+0x2e>
    __list_del(listelm->prev, listelm->next);
ffffffffc0205b30:	1105b503          	ld	a0,272(a1)
ffffffffc0205b34:	1185b603          	ld	a2,280(a1)
    rq->proc_num--;
ffffffffc0205b38:	4b98                	lw	a4,16(a5)
    list_del_init(&proc->run_link);
ffffffffc0205b3a:	11058693          	addi	a3,a1,272
    prev->next = next;
ffffffffc0205b3e:	e510                	sd	a2,8(a0)
    next->prev = prev;
ffffffffc0205b40:	e208                	sd	a0,0(a2)
    proc->rq = NULL;
ffffffffc0205b42:	1005b423          	sd	zero,264(a1)
    rq->proc_num--;
ffffffffc0205b46:	377d                	addiw	a4,a4,-1
    elm->prev = elm->next = elm;
ffffffffc0205b48:	10d5bc23          	sd	a3,280(a1)
ffffffffc0205b4c:	10d5b823          	sd	a3,272(a1)
ffffffffc0205b50:	cb98                	sw	a4,16(a5)
ffffffffc0205b52:	8082                	ret
{
ffffffffc0205b54:	1141                	addi	sp,sp,-16
    assert(proc && proc->rq == rq);
ffffffffc0205b56:	00003697          	auipc	a3,0x3
ffffffffc0205b5a:	89268693          	addi	a3,a3,-1902 # ffffffffc02083e8 <etext+0x20a4>
ffffffffc0205b5e:	00001617          	auipc	a2,0x1
ffffffffc0205b62:	19a60613          	addi	a2,a2,410 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0205b66:	03300593          	li	a1,51
ffffffffc0205b6a:	00003517          	auipc	a0,0x3
ffffffffc0205b6e:	89650513          	addi	a0,a0,-1898 # ffffffffc0208400 <etext+0x20bc>
{
ffffffffc0205b72:	e406                	sd	ra,8(sp)
    assert(proc && proc->rq == rq);
ffffffffc0205b74:	8d7fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205b78 <RR_enqueue>:
    assert(proc);
ffffffffc0205b78:	c995                	beqz	a1,ffffffffc0205bac <RR_enqueue+0x34>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0205b7a:	6114                	ld	a3,0(a0)
    rq->proc_num++;
ffffffffc0205b7c:	4918                	lw	a4,16(a0)
    list_add_before(&rq->run_list, &proc->run_link);
ffffffffc0205b7e:	11058793          	addi	a5,a1,272
    prev->next = next->prev = elm;
ffffffffc0205b82:	e11c                	sd	a5,0(a0)
ffffffffc0205b84:	e69c                	sd	a5,8(a3)
    if (proc != idleproc) {
ffffffffc0205b86:	000c6617          	auipc	a2,0xc6
ffffffffc0205b8a:	72a63603          	ld	a2,1834(a2) # ffffffffc02cc2b0 <idleproc>
    elm->prev = prev;
ffffffffc0205b8e:	10d5b823          	sd	a3,272(a1)
    elm->next = next;
ffffffffc0205b92:	10a5bc23          	sd	a0,280(a1)
    proc->rq = rq;
ffffffffc0205b96:	10a5b423          	sd	a0,264(a1)
    rq->proc_num++;
ffffffffc0205b9a:	0017079b          	addiw	a5,a4,1
ffffffffc0205b9e:	c91c                	sw	a5,16(a0)
    if (proc != idleproc) {
ffffffffc0205ba0:	00b60563          	beq	a2,a1,ffffffffc0205baa <RR_enqueue+0x32>
        proc->time_slice = rq->max_time_slice;
ffffffffc0205ba4:	495c                	lw	a5,20(a0)
ffffffffc0205ba6:	12f5a023          	sw	a5,288(a1)
ffffffffc0205baa:	8082                	ret
{
ffffffffc0205bac:	1141                	addi	sp,sp,-16
    assert(proc);
ffffffffc0205bae:	00003697          	auipc	a3,0x3
ffffffffc0205bb2:	87268693          	addi	a3,a3,-1934 # ffffffffc0208420 <etext+0x20dc>
ffffffffc0205bb6:	00001617          	auipc	a2,0x1
ffffffffc0205bba:	14260613          	addi	a2,a2,322 # ffffffffc0206cf8 <etext+0x9b4>
ffffffffc0205bbe:	02200593          	li	a1,34
ffffffffc0205bc2:	00003517          	auipc	a0,0x3
ffffffffc0205bc6:	83e50513          	addi	a0,a0,-1986 # ffffffffc0208400 <etext+0x20bc>
{
ffffffffc0205bca:	e406                	sd	ra,8(sp)
    assert(proc);
ffffffffc0205bcc:	87ffa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205bd0 <sched_init>:

void sched_init(void)
{
    list_init(&timer_list);

    sched_class = &default_sched_class;
ffffffffc0205bd0:	000c2797          	auipc	a5,0xc2
ffffffffc0205bd4:	08078793          	addi	a5,a5,128 # ffffffffc02c7c50 <default_sched_class>
{
ffffffffc0205bd8:	1141                	addi	sp,sp,-16

    rq = &__rq;
    rq->max_time_slice = MAX_TIME_SLICE;
    /* ensure run_queue fields initialized by class */
    sched_class->init(rq);
ffffffffc0205bda:	6794                	ld	a3,8(a5)
    sched_class = &default_sched_class;
ffffffffc0205bdc:	000c6717          	auipc	a4,0xc6
ffffffffc0205be0:	6ef73223          	sd	a5,1764(a4) # ffffffffc02cc2c0 <sched_class>
{
ffffffffc0205be4:	e406                	sd	ra,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0205be6:	000c6797          	auipc	a5,0xc6
ffffffffc0205bea:	64a78793          	addi	a5,a5,1610 # ffffffffc02cc230 <timer_list>
    rq = &__rq;
ffffffffc0205bee:	000c6717          	auipc	a4,0xc6
ffffffffc0205bf2:	62270713          	addi	a4,a4,1570 # ffffffffc02cc210 <__rq>
    rq->max_time_slice = MAX_TIME_SLICE;
ffffffffc0205bf6:	4615                	li	a2,5
ffffffffc0205bf8:	e79c                	sd	a5,8(a5)
ffffffffc0205bfa:	e39c                	sd	a5,0(a5)
    sched_class->init(rq);
ffffffffc0205bfc:	853a                	mv	a0,a4
    rq->max_time_slice = MAX_TIME_SLICE;
ffffffffc0205bfe:	cb50                	sw	a2,20(a4)
    rq = &__rq;
ffffffffc0205c00:	000c6797          	auipc	a5,0xc6
ffffffffc0205c04:	6ae7bc23          	sd	a4,1720(a5) # ffffffffc02cc2b8 <rq>
    sched_class->init(rq);
ffffffffc0205c08:	9682                	jalr	a3

    
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205c0a:	000c6797          	auipc	a5,0xc6
ffffffffc0205c0e:	6b67b783          	ld	a5,1718(a5) # ffffffffc02cc2c0 <sched_class>
}
ffffffffc0205c12:	60a2                	ld	ra,8(sp)
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205c14:	00003517          	auipc	a0,0x3
ffffffffc0205c18:	82450513          	addi	a0,a0,-2012 # ffffffffc0208438 <etext+0x20f4>
ffffffffc0205c1c:	638c                	ld	a1,0(a5)
}
ffffffffc0205c1e:	0141                	addi	sp,sp,16
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205c20:	d78fa06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0205c24 <wakeup_proc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205c24:	100027f3          	csrr	a5,sstatus
ffffffffc0205c28:	8b89                	andi	a5,a5,2
ffffffffc0205c2a:	e7a9                	bnez	a5,ffffffffc0205c74 <wakeup_proc+0x50>
void wakeup_proc(struct proc_struct *proc)
{
    bool intr_flag;
    local_intr_save(intr_flag);

    if (proc->state != PROC_RUNNABLE) {
ffffffffc0205c2c:	4118                	lw	a4,0(a0)
ffffffffc0205c2e:	4789                	li	a5,2
ffffffffc0205c30:	04f70163          	beq	a4,a5,ffffffffc0205c72 <wakeup_proc+0x4e>
// DEBUG:         cprintf("wakeup_proc: pid=%d state=%d\n", proc->pid, proc->state);
        proc->state = PROC_RUNNABLE;
        proc->wait_state = 0;
        /* only enqueue if it's not the current running thread */
        if (proc != current) {
ffffffffc0205c34:	000c6717          	auipc	a4,0xc6
ffffffffc0205c38:	66c73703          	ld	a4,1644(a4) # ffffffffc02cc2a0 <current>
        proc->wait_state = 0;
ffffffffc0205c3c:	0e052623          	sw	zero,236(a0)
        proc->state = PROC_RUNNABLE;
ffffffffc0205c40:	c11c                	sw	a5,0(a0)
        if (proc != current) {
ffffffffc0205c42:	02e50663          	beq	a0,a4,ffffffffc0205c6e <wakeup_proc+0x4a>
    if (proc != idleproc) {
ffffffffc0205c46:	000c6797          	auipc	a5,0xc6
ffffffffc0205c4a:	66a7b783          	ld	a5,1642(a5) # ffffffffc02cc2b0 <idleproc>
ffffffffc0205c4e:	02f50163          	beq	a0,a5,ffffffffc0205c70 <wakeup_proc+0x4c>
        sched_class->enqueue(rq, proc);
ffffffffc0205c52:	000c6717          	auipc	a4,0xc6
ffffffffc0205c56:	66e73703          	ld	a4,1646(a4) # ffffffffc02cc2c0 <sched_class>
        proc->rq = rq;
ffffffffc0205c5a:	000c6797          	auipc	a5,0xc6
ffffffffc0205c5e:	65e7b783          	ld	a5,1630(a5) # ffffffffc02cc2b8 <rq>
        sched_class->enqueue(rq, proc);
ffffffffc0205c62:	85aa                	mv	a1,a0
ffffffffc0205c64:	6b18                	ld	a4,16(a4)
        proc->rq = rq;
ffffffffc0205c66:	10f53423          	sd	a5,264(a0)
        sched_class->enqueue(rq, proc);
ffffffffc0205c6a:	853e                	mv	a0,a5
ffffffffc0205c6c:	8702                	jr	a4
ffffffffc0205c6e:	8082                	ret
ffffffffc0205c70:	8082                	ret
ffffffffc0205c72:	8082                	ret
{
ffffffffc0205c74:	1101                	addi	sp,sp,-32
ffffffffc0205c76:	e42a                	sd	a0,8(sp)
ffffffffc0205c78:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0205c7a:	c41fa0ef          	jal	ffffffffc02008ba <intr_disable>
    if (proc->state != PROC_RUNNABLE) {
ffffffffc0205c7e:	6522                	ld	a0,8(sp)
ffffffffc0205c80:	4789                	li	a5,2
ffffffffc0205c82:	4118                	lw	a4,0(a0)
ffffffffc0205c84:	02f70f63          	beq	a4,a5,ffffffffc0205cc2 <wakeup_proc+0x9e>
        if (proc != current) {
ffffffffc0205c88:	000c6717          	auipc	a4,0xc6
ffffffffc0205c8c:	61873703          	ld	a4,1560(a4) # ffffffffc02cc2a0 <current>
        proc->wait_state = 0;
ffffffffc0205c90:	0e052623          	sw	zero,236(a0)
        proc->state = PROC_RUNNABLE;
ffffffffc0205c94:	c11c                	sw	a5,0(a0)
        if (proc != current) {
ffffffffc0205c96:	02e50663          	beq	a0,a4,ffffffffc0205cc2 <wakeup_proc+0x9e>
    if (proc != idleproc) {
ffffffffc0205c9a:	000c6797          	auipc	a5,0xc6
ffffffffc0205c9e:	6167b783          	ld	a5,1558(a5) # ffffffffc02cc2b0 <idleproc>
ffffffffc0205ca2:	02f50063          	beq	a0,a5,ffffffffc0205cc2 <wakeup_proc+0x9e>
        sched_class->enqueue(rq, proc);
ffffffffc0205ca6:	000c6717          	auipc	a4,0xc6
ffffffffc0205caa:	61a73703          	ld	a4,1562(a4) # ffffffffc02cc2c0 <sched_class>
        proc->rq = rq;
ffffffffc0205cae:	000c6797          	auipc	a5,0xc6
ffffffffc0205cb2:	60a7b783          	ld	a5,1546(a5) # ffffffffc02cc2b8 <rq>
        sched_class->enqueue(rq, proc);
ffffffffc0205cb6:	85aa                	mv	a1,a0
ffffffffc0205cb8:	6b18                	ld	a4,16(a4)
        proc->rq = rq;
ffffffffc0205cba:	10f53423          	sd	a5,264(a0)
        sched_class->enqueue(rq, proc);
ffffffffc0205cbe:	853e                	mv	a0,a5
ffffffffc0205cc0:	9702                	jalr	a4
            sched_class_enqueue(proc);
        }
    }

    local_intr_restore(intr_flag);
}
ffffffffc0205cc2:	60e2                	ld	ra,24(sp)
ffffffffc0205cc4:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205cc6:	beffa06f          	j	ffffffffc02008b4 <intr_enable>

ffffffffc0205cca <schedule>:

/* schedule: high level scheduling flow (enqueue current if runnable,
 * pick next, dequeue it and run) */
void schedule(void)
{
ffffffffc0205cca:	7139                	addi	sp,sp,-64
ffffffffc0205ccc:	fc06                	sd	ra,56(sp)
ffffffffc0205cce:	f822                	sd	s0,48(sp)
ffffffffc0205cd0:	f426                	sd	s1,40(sp)
ffffffffc0205cd2:	f04a                	sd	s2,32(sp)
ffffffffc0205cd4:	ec4e                	sd	s3,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205cd6:	100027f3          	csrr	a5,sstatus
ffffffffc0205cda:	8b89                	andi	a5,a5,2
ffffffffc0205cdc:	4981                	li	s3,0
ffffffffc0205cde:	efd1                	bnez	a5,ffffffffc0205d7a <schedule+0xb0>
    bool intr_flag;
    local_intr_save(intr_flag);

    struct proc_struct *cur = current;
ffffffffc0205ce0:	000c6417          	auipc	s0,0xc6
ffffffffc0205ce4:	5c043403          	ld	s0,1472(s0) # ffffffffc02cc2a0 <current>

    /* clear resched flag for current; it will be set again if needed */
    cur->need_resched = 0;

    /* if current is still runnable, enqueue it */
    if (cur->state == PROC_RUNNABLE) {
ffffffffc0205ce8:	4789                	li	a5,2
ffffffffc0205cea:	000c6497          	auipc	s1,0xc6
ffffffffc0205cee:	5ce48493          	addi	s1,s1,1486 # ffffffffc02cc2b8 <rq>
ffffffffc0205cf2:	4018                	lw	a4,0(s0)
    cur->need_resched = 0;
ffffffffc0205cf4:	00043c23          	sd	zero,24(s0)
    if (cur->state == PROC_RUNNABLE) {
ffffffffc0205cf8:	000c6917          	auipc	s2,0xc6
ffffffffc0205cfc:	5c890913          	addi	s2,s2,1480 # ffffffffc02cc2c0 <sched_class>
ffffffffc0205d00:	04f70e63          	beq	a4,a5,ffffffffc0205d5c <schedule+0x92>
    return sched_class->pick_next(rq);
ffffffffc0205d04:	00093783          	ld	a5,0(s2)
ffffffffc0205d08:	6088                	ld	a0,0(s1)
ffffffffc0205d0a:	739c                	ld	a5,32(a5)
ffffffffc0205d0c:	9782                	jalr	a5
ffffffffc0205d0e:	85aa                	mv	a1,a0
        sched_class_enqueue(cur);
    }

    /* pick next from scheduling class */
    next = sched_class_pick_next();
    if (!next) {
ffffffffc0205d10:	c129                	beqz	a0,ffffffffc0205d52 <schedule+0x88>
    sched_class->dequeue(rq, proc);
ffffffffc0205d12:	00093783          	ld	a5,0(s2)
ffffffffc0205d16:	6088                	ld	a0,0(s1)
ffffffffc0205d18:	e42e                	sd	a1,8(sp)
ffffffffc0205d1a:	6f9c                	ld	a5,24(a5)
ffffffffc0205d1c:	9782                	jalr	a5
ffffffffc0205d1e:	65a2                	ld	a1,8(sp)
        /* remove next from run-queue */
        sched_class_dequeue(next);
    }

    /* if next is the same as current, nothing to do */
    if (next == cur) {
ffffffffc0205d20:	00858863          	beq	a1,s0,ffffffffc0205d30 <schedule+0x66>
        return;
    }

    // DEBUG: if (next->pid >= 3 && next->pid <= 7) cprintf("schedule: switching to pid=%d\n", next->pid);
    /* accounting */
    next->runs++;
ffffffffc0205d24:	459c                	lw	a5,8(a1)

    /* context switch */
    proc_run(next);
ffffffffc0205d26:	852e                	mv	a0,a1
    next->runs++;
ffffffffc0205d28:	2785                	addiw	a5,a5,1
ffffffffc0205d2a:	c59c                	sw	a5,8(a1)
    proc_run(next);
ffffffffc0205d2c:	ab5fe0ef          	jal	ffffffffc02047e0 <proc_run>
    if (flag) {
ffffffffc0205d30:	00099963          	bnez	s3,ffffffffc0205d42 <schedule+0x78>

    /* proc_run should not return here in normal flow, but restore just in case */
    local_intr_restore(intr_flag);
ffffffffc0205d34:	70e2                	ld	ra,56(sp)
ffffffffc0205d36:	7442                	ld	s0,48(sp)
ffffffffc0205d38:	74a2                	ld	s1,40(sp)
ffffffffc0205d3a:	7902                	ld	s2,32(sp)
ffffffffc0205d3c:	69e2                	ld	s3,24(sp)
ffffffffc0205d3e:	6121                	addi	sp,sp,64
ffffffffc0205d40:	8082                	ret
ffffffffc0205d42:	7442                	ld	s0,48(sp)
ffffffffc0205d44:	70e2                	ld	ra,56(sp)
ffffffffc0205d46:	74a2                	ld	s1,40(sp)
ffffffffc0205d48:	7902                	ld	s2,32(sp)
ffffffffc0205d4a:	69e2                	ld	s3,24(sp)
ffffffffc0205d4c:	6121                	addi	sp,sp,64
        intr_enable();
ffffffffc0205d4e:	b67fa06f          	j	ffffffffc02008b4 <intr_enable>
        next = idleproc;
ffffffffc0205d52:	000c6597          	auipc	a1,0xc6
ffffffffc0205d56:	55e5b583          	ld	a1,1374(a1) # ffffffffc02cc2b0 <idleproc>
ffffffffc0205d5a:	b7d9                	j	ffffffffc0205d20 <schedule+0x56>
    if (proc != idleproc) {
ffffffffc0205d5c:	000c6797          	auipc	a5,0xc6
ffffffffc0205d60:	5547b783          	ld	a5,1364(a5) # ffffffffc02cc2b0 <idleproc>
ffffffffc0205d64:	faf400e3          	beq	s0,a5,ffffffffc0205d04 <schedule+0x3a>
        sched_class->enqueue(rq, proc);
ffffffffc0205d68:	00093783          	ld	a5,0(s2)
        proc->rq = rq;
ffffffffc0205d6c:	6088                	ld	a0,0(s1)
        sched_class->enqueue(rq, proc);
ffffffffc0205d6e:	85a2                	mv	a1,s0
ffffffffc0205d70:	6b9c                	ld	a5,16(a5)
        proc->rq = rq;
ffffffffc0205d72:	10a43423          	sd	a0,264(s0)
        sched_class->enqueue(rq, proc);
ffffffffc0205d76:	9782                	jalr	a5
ffffffffc0205d78:	b771                	j	ffffffffc0205d04 <schedule+0x3a>
        intr_disable();
ffffffffc0205d7a:	b41fa0ef          	jal	ffffffffc02008ba <intr_disable>
        return 1;
ffffffffc0205d7e:	4985                	li	s3,1
ffffffffc0205d80:	b785                	j	ffffffffc0205ce0 <schedule+0x16>

ffffffffc0205d82 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc0205d82:	000c6797          	auipc	a5,0xc6
ffffffffc0205d86:	51e7b783          	ld	a5,1310(a5) # ffffffffc02cc2a0 <current>
}
ffffffffc0205d8a:	43c8                	lw	a0,4(a5)
ffffffffc0205d8c:	8082                	ret

ffffffffc0205d8e <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0205d8e:	4501                	li	a0,0
ffffffffc0205d90:	8082                	ret

ffffffffc0205d92 <sys_gettime>:
static int sys_gettime(uint64_t arg[]){
    return (int)ticks*10;
ffffffffc0205d92:	000c6797          	auipc	a5,0xc6
ffffffffc0205d96:	4b67b783          	ld	a5,1206(a5) # ffffffffc02cc248 <ticks>
ffffffffc0205d9a:	0027951b          	slliw	a0,a5,0x2
ffffffffc0205d9e:	9d3d                	addw	a0,a0,a5
ffffffffc0205da0:	0015151b          	slliw	a0,a0,0x1
}
ffffffffc0205da4:	8082                	ret

ffffffffc0205da6 <sys_lab6_set_priority>:
static int sys_lab6_set_priority(uint64_t arg[]){
    uint64_t priority = (uint64_t)arg[0];
    lab6_set_priority(priority);
ffffffffc0205da6:	4108                	lw	a0,0(a0)
static int sys_lab6_set_priority(uint64_t arg[]){
ffffffffc0205da8:	1141                	addi	sp,sp,-16
ffffffffc0205daa:	e406                	sd	ra,8(sp)
    lab6_set_priority(priority);
ffffffffc0205dac:	c65ff0ef          	jal	ffffffffc0205a10 <lab6_set_priority>
    return 0;
}
ffffffffc0205db0:	60a2                	ld	ra,8(sp)
ffffffffc0205db2:	4501                	li	a0,0
ffffffffc0205db4:	0141                	addi	sp,sp,16
ffffffffc0205db6:	8082                	ret

ffffffffc0205db8 <sys_putc>:
    cputchar(c);
ffffffffc0205db8:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205dba:	1141                	addi	sp,sp,-16
ffffffffc0205dbc:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205dbe:	c0efa0ef          	jal	ffffffffc02001cc <cputchar>
}
ffffffffc0205dc2:	60a2                	ld	ra,8(sp)
ffffffffc0205dc4:	4501                	li	a0,0
ffffffffc0205dc6:	0141                	addi	sp,sp,16
ffffffffc0205dc8:	8082                	ret

ffffffffc0205dca <sys_kill>:
    return do_kill(pid);
ffffffffc0205dca:	4108                	lw	a0,0(a0)
ffffffffc0205dcc:	a13ff06f          	j	ffffffffc02057de <do_kill>

ffffffffc0205dd0 <sys_sleep>:
static int
sys_sleep(uint64_t arg[]) {
    unsigned int time = (unsigned int)arg[0];
    return do_sleep(time);
ffffffffc0205dd0:	4108                	lw	a0,0(a0)
ffffffffc0205dd2:	c89ff06f          	j	ffffffffc0205a5a <do_sleep>

ffffffffc0205dd6 <sys_yield>:
    return do_yield();
ffffffffc0205dd6:	9bfff06f          	j	ffffffffc0205794 <do_yield>

ffffffffc0205dda <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0205dda:	6d14                	ld	a3,24(a0)
ffffffffc0205ddc:	6910                	ld	a2,16(a0)
ffffffffc0205dde:	650c                	ld	a1,8(a0)
ffffffffc0205de0:	6108                	ld	a0,0(a0)
ffffffffc0205de2:	b80ff06f          	j	ffffffffc0205162 <do_execve>

ffffffffc0205de6 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0205de6:	650c                	ld	a1,8(a0)
ffffffffc0205de8:	4108                	lw	a0,0(a0)
ffffffffc0205dea:	9bbff06f          	j	ffffffffc02057a4 <do_wait>

ffffffffc0205dee <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0205dee:	000c6797          	auipc	a5,0xc6
ffffffffc0205df2:	4b27b783          	ld	a5,1202(a5) # ffffffffc02cc2a0 <current>
    return do_fork(0, stack, tf);
ffffffffc0205df6:	4501                	li	a0,0
    struct trapframe *tf = current->tf;
ffffffffc0205df8:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc0205dfa:	6a0c                	ld	a1,16(a2)
ffffffffc0205dfc:	a9bfe06f          	j	ffffffffc0204896 <do_fork>

ffffffffc0205e00 <sys_exit>:
    return do_exit(error_code);
ffffffffc0205e00:	4108                	lw	a0,0(a0)
ffffffffc0205e02:	f0ffe06f          	j	ffffffffc0204d10 <do_exit>

ffffffffc0205e06 <syscall>:

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
    struct trapframe *tf = current->tf;
ffffffffc0205e06:	000c6697          	auipc	a3,0xc6
ffffffffc0205e0a:	49a6b683          	ld	a3,1178(a3) # ffffffffc02cc2a0 <current>
syscall(void) {
ffffffffc0205e0e:	715d                	addi	sp,sp,-80
ffffffffc0205e10:	e0a2                	sd	s0,64(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205e12:	72c0                	ld	s0,160(a3)
syscall(void) {
ffffffffc0205e14:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205e16:	0ff00793          	li	a5,255
    int num = tf->gpr.a0;
ffffffffc0205e1a:	4834                	lw	a3,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205e1c:	02d7ec63          	bltu	a5,a3,ffffffffc0205e54 <syscall+0x4e>
        if (syscalls[num] != NULL) {
ffffffffc0205e20:	00003797          	auipc	a5,0x3
ffffffffc0205e24:	85878793          	addi	a5,a5,-1960 # ffffffffc0208678 <syscalls>
ffffffffc0205e28:	00369613          	slli	a2,a3,0x3
ffffffffc0205e2c:	97b2                	add	a5,a5,a2
ffffffffc0205e2e:	639c                	ld	a5,0(a5)
ffffffffc0205e30:	c395                	beqz	a5,ffffffffc0205e54 <syscall+0x4e>
            arg[0] = tf->gpr.a1;
ffffffffc0205e32:	7028                	ld	a0,96(s0)
ffffffffc0205e34:	742c                	ld	a1,104(s0)
ffffffffc0205e36:	7830                	ld	a2,112(s0)
ffffffffc0205e38:	7c34                	ld	a3,120(s0)
ffffffffc0205e3a:	6c38                	ld	a4,88(s0)
ffffffffc0205e3c:	f02a                	sd	a0,32(sp)
ffffffffc0205e3e:	f42e                	sd	a1,40(sp)
ffffffffc0205e40:	f832                	sd	a2,48(sp)
ffffffffc0205e42:	fc36                	sd	a3,56(sp)
ffffffffc0205e44:	ec3a                	sd	a4,24(sp)
            arg[1] = tf->gpr.a2;
            arg[2] = tf->gpr.a3;
            arg[3] = tf->gpr.a4;
            arg[4] = tf->gpr.a5;
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205e46:	0828                	addi	a0,sp,24
ffffffffc0205e48:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc0205e4a:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205e4c:	e828                	sd	a0,80(s0)
}
ffffffffc0205e4e:	6406                	ld	s0,64(sp)
ffffffffc0205e50:	6161                	addi	sp,sp,80
ffffffffc0205e52:	8082                	ret
    print_trapframe(tf);
ffffffffc0205e54:	8522                	mv	a0,s0
ffffffffc0205e56:	e436                	sd	a3,8(sp)
ffffffffc0205e58:	c53fa0ef          	jal	ffffffffc0200aaa <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc0205e5c:	000c6797          	auipc	a5,0xc6
ffffffffc0205e60:	4447b783          	ld	a5,1092(a5) # ffffffffc02cc2a0 <current>
ffffffffc0205e64:	66a2                	ld	a3,8(sp)
ffffffffc0205e66:	00002617          	auipc	a2,0x2
ffffffffc0205e6a:	5ea60613          	addi	a2,a2,1514 # ffffffffc0208450 <etext+0x210c>
ffffffffc0205e6e:	43d8                	lw	a4,4(a5)
ffffffffc0205e70:	07300593          	li	a1,115
ffffffffc0205e74:	0b478793          	addi	a5,a5,180
ffffffffc0205e78:	00002517          	auipc	a0,0x2
ffffffffc0205e7c:	60850513          	addi	a0,a0,1544 # ffffffffc0208480 <etext+0x213c>
ffffffffc0205e80:	dcafa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205e84 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0205e84:	9e3707b7          	lui	a5,0x9e370
ffffffffc0205e88:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <_binary_obj___user_matrix_out_size+0xffffffff9e364919>
ffffffffc0205e8a:	02a787bb          	mulw	a5,a5,a0
    return (hash >> (32 - bits));
ffffffffc0205e8e:	02000513          	li	a0,32
ffffffffc0205e92:	9d0d                	subw	a0,a0,a1
}
ffffffffc0205e94:	00a7d53b          	srlw	a0,a5,a0
ffffffffc0205e98:	8082                	ret

ffffffffc0205e9a <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205e9a:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205e9c:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205ea0:	f022                	sd	s0,32(sp)
ffffffffc0205ea2:	ec26                	sd	s1,24(sp)
ffffffffc0205ea4:	e84a                	sd	s2,16(sp)
ffffffffc0205ea6:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205ea8:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205eac:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205eae:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0205eb2:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205eb6:	84aa                	mv	s1,a0
ffffffffc0205eb8:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc0205eba:	03067d63          	bgeu	a2,a6,ffffffffc0205ef4 <printnum+0x5a>
ffffffffc0205ebe:	e44e                	sd	s3,8(sp)
ffffffffc0205ec0:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0205ec2:	4785                	li	a5,1
ffffffffc0205ec4:	00e7d763          	bge	a5,a4,ffffffffc0205ed2 <printnum+0x38>
            putch(padc, putdat);
ffffffffc0205ec8:	85ca                	mv	a1,s2
ffffffffc0205eca:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc0205ecc:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205ece:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205ed0:	fc65                	bnez	s0,ffffffffc0205ec8 <printnum+0x2e>
ffffffffc0205ed2:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205ed4:	00002797          	auipc	a5,0x2
ffffffffc0205ed8:	5c478793          	addi	a5,a5,1476 # ffffffffc0208498 <etext+0x2154>
ffffffffc0205edc:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc0205ede:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205ee0:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0205ee4:	70a2                	ld	ra,40(sp)
ffffffffc0205ee6:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205ee8:	85ca                	mv	a1,s2
ffffffffc0205eea:	87a6                	mv	a5,s1
}
ffffffffc0205eec:	6942                	ld	s2,16(sp)
ffffffffc0205eee:	64e2                	ld	s1,24(sp)
ffffffffc0205ef0:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205ef2:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0205ef4:	03065633          	divu	a2,a2,a6
ffffffffc0205ef8:	8722                	mv	a4,s0
ffffffffc0205efa:	fa1ff0ef          	jal	ffffffffc0205e9a <printnum>
ffffffffc0205efe:	bfd9                	j	ffffffffc0205ed4 <printnum+0x3a>

ffffffffc0205f00 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0205f00:	7119                	addi	sp,sp,-128
ffffffffc0205f02:	f4a6                	sd	s1,104(sp)
ffffffffc0205f04:	f0ca                	sd	s2,96(sp)
ffffffffc0205f06:	ecce                	sd	s3,88(sp)
ffffffffc0205f08:	e8d2                	sd	s4,80(sp)
ffffffffc0205f0a:	e4d6                	sd	s5,72(sp)
ffffffffc0205f0c:	e0da                	sd	s6,64(sp)
ffffffffc0205f0e:	f862                	sd	s8,48(sp)
ffffffffc0205f10:	fc86                	sd	ra,120(sp)
ffffffffc0205f12:	f8a2                	sd	s0,112(sp)
ffffffffc0205f14:	fc5e                	sd	s7,56(sp)
ffffffffc0205f16:	f466                	sd	s9,40(sp)
ffffffffc0205f18:	f06a                	sd	s10,32(sp)
ffffffffc0205f1a:	ec6e                	sd	s11,24(sp)
ffffffffc0205f1c:	84aa                	mv	s1,a0
ffffffffc0205f1e:	8c32                	mv	s8,a2
ffffffffc0205f20:	8a36                	mv	s4,a3
ffffffffc0205f22:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205f24:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205f28:	05500b13          	li	s6,85
ffffffffc0205f2c:	00003a97          	auipc	s5,0x3
ffffffffc0205f30:	f4ca8a93          	addi	s5,s5,-180 # ffffffffc0208e78 <syscalls+0x800>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205f34:	000c4503          	lbu	a0,0(s8)
ffffffffc0205f38:	001c0413          	addi	s0,s8,1
ffffffffc0205f3c:	01350a63          	beq	a0,s3,ffffffffc0205f50 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0205f40:	cd0d                	beqz	a0,ffffffffc0205f7a <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0205f42:	85ca                	mv	a1,s2
ffffffffc0205f44:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205f46:	00044503          	lbu	a0,0(s0)
ffffffffc0205f4a:	0405                	addi	s0,s0,1
ffffffffc0205f4c:	ff351ae3          	bne	a0,s3,ffffffffc0205f40 <vprintfmt+0x40>
        width = precision = -1;
ffffffffc0205f50:	5cfd                	li	s9,-1
ffffffffc0205f52:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc0205f54:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc0205f58:	4b81                	li	s7,0
ffffffffc0205f5a:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205f5c:	00044683          	lbu	a3,0(s0)
ffffffffc0205f60:	00140c13          	addi	s8,s0,1
ffffffffc0205f64:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0205f68:	0ff5f593          	zext.b	a1,a1
ffffffffc0205f6c:	02bb6663          	bltu	s6,a1,ffffffffc0205f98 <vprintfmt+0x98>
ffffffffc0205f70:	058a                	slli	a1,a1,0x2
ffffffffc0205f72:	95d6                	add	a1,a1,s5
ffffffffc0205f74:	4198                	lw	a4,0(a1)
ffffffffc0205f76:	9756                	add	a4,a4,s5
ffffffffc0205f78:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0205f7a:	70e6                	ld	ra,120(sp)
ffffffffc0205f7c:	7446                	ld	s0,112(sp)
ffffffffc0205f7e:	74a6                	ld	s1,104(sp)
ffffffffc0205f80:	7906                	ld	s2,96(sp)
ffffffffc0205f82:	69e6                	ld	s3,88(sp)
ffffffffc0205f84:	6a46                	ld	s4,80(sp)
ffffffffc0205f86:	6aa6                	ld	s5,72(sp)
ffffffffc0205f88:	6b06                	ld	s6,64(sp)
ffffffffc0205f8a:	7be2                	ld	s7,56(sp)
ffffffffc0205f8c:	7c42                	ld	s8,48(sp)
ffffffffc0205f8e:	7ca2                	ld	s9,40(sp)
ffffffffc0205f90:	7d02                	ld	s10,32(sp)
ffffffffc0205f92:	6de2                	ld	s11,24(sp)
ffffffffc0205f94:	6109                	addi	sp,sp,128
ffffffffc0205f96:	8082                	ret
            putch('%', putdat);
ffffffffc0205f98:	85ca                	mv	a1,s2
ffffffffc0205f9a:	02500513          	li	a0,37
ffffffffc0205f9e:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205fa0:	fff44783          	lbu	a5,-1(s0)
ffffffffc0205fa4:	02500713          	li	a4,37
ffffffffc0205fa8:	8c22                	mv	s8,s0
ffffffffc0205faa:	f8e785e3          	beq	a5,a4,ffffffffc0205f34 <vprintfmt+0x34>
ffffffffc0205fae:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0205fb2:	1c7d                	addi	s8,s8,-1
ffffffffc0205fb4:	fee79de3          	bne	a5,a4,ffffffffc0205fae <vprintfmt+0xae>
ffffffffc0205fb8:	bfb5                	j	ffffffffc0205f34 <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0205fba:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0205fbe:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc0205fc0:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc0205fc4:	fd06071b          	addiw	a4,a2,-48
ffffffffc0205fc8:	24e56a63          	bltu	a0,a4,ffffffffc020621c <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc0205fcc:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205fce:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc0205fd0:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc0205fd4:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0205fd8:	0197073b          	addw	a4,a4,s9
ffffffffc0205fdc:	0017171b          	slliw	a4,a4,0x1
ffffffffc0205fe0:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc0205fe2:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0205fe6:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0205fe8:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0205fec:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc0205ff0:	feb570e3          	bgeu	a0,a1,ffffffffc0205fd0 <vprintfmt+0xd0>
            if (width < 0)
ffffffffc0205ff4:	f60d54e3          	bgez	s10,ffffffffc0205f5c <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0205ff8:	8d66                	mv	s10,s9
ffffffffc0205ffa:	5cfd                	li	s9,-1
ffffffffc0205ffc:	b785                	j	ffffffffc0205f5c <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205ffe:	8db6                	mv	s11,a3
ffffffffc0206000:	8462                	mv	s0,s8
ffffffffc0206002:	bfa9                	j	ffffffffc0205f5c <vprintfmt+0x5c>
ffffffffc0206004:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0206006:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0206008:	bf91                	j	ffffffffc0205f5c <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc020600a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020600c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0206010:	00f74463          	blt	a4,a5,ffffffffc0206018 <vprintfmt+0x118>
    else if (lflag) {
ffffffffc0206014:	1a078763          	beqz	a5,ffffffffc02061c2 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0206018:	000a3603          	ld	a2,0(s4)
ffffffffc020601c:	46c1                	li	a3,16
ffffffffc020601e:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0206020:	000d879b          	sext.w	a5,s11
ffffffffc0206024:	876a                	mv	a4,s10
ffffffffc0206026:	85ca                	mv	a1,s2
ffffffffc0206028:	8526                	mv	a0,s1
ffffffffc020602a:	e71ff0ef          	jal	ffffffffc0205e9a <printnum>
            break;
ffffffffc020602e:	b719                	j	ffffffffc0205f34 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0206030:	000a2503          	lw	a0,0(s4)
ffffffffc0206034:	85ca                	mv	a1,s2
ffffffffc0206036:	0a21                	addi	s4,s4,8
ffffffffc0206038:	9482                	jalr	s1
            break;
ffffffffc020603a:	bded                	j	ffffffffc0205f34 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc020603c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020603e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0206042:	00f74463          	blt	a4,a5,ffffffffc020604a <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0206046:	16078963          	beqz	a5,ffffffffc02061b8 <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc020604a:	000a3603          	ld	a2,0(s4)
ffffffffc020604e:	46a9                	li	a3,10
ffffffffc0206050:	8a2e                	mv	s4,a1
ffffffffc0206052:	b7f9                	j	ffffffffc0206020 <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc0206054:	85ca                	mv	a1,s2
ffffffffc0206056:	03000513          	li	a0,48
ffffffffc020605a:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc020605c:	85ca                	mv	a1,s2
ffffffffc020605e:	07800513          	li	a0,120
ffffffffc0206062:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0206064:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc0206068:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020606a:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc020606c:	bf55                	j	ffffffffc0206020 <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc020606e:	85ca                	mv	a1,s2
ffffffffc0206070:	02500513          	li	a0,37
ffffffffc0206074:	9482                	jalr	s1
            break;
ffffffffc0206076:	bd7d                	j	ffffffffc0205f34 <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc0206078:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020607c:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc020607e:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc0206080:	bf95                	j	ffffffffc0205ff4 <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc0206082:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0206084:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0206088:	00f74463          	blt	a4,a5,ffffffffc0206090 <vprintfmt+0x190>
    else if (lflag) {
ffffffffc020608c:	12078163          	beqz	a5,ffffffffc02061ae <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc0206090:	000a3603          	ld	a2,0(s4)
ffffffffc0206094:	46a1                	li	a3,8
ffffffffc0206096:	8a2e                	mv	s4,a1
ffffffffc0206098:	b761                	j	ffffffffc0206020 <vprintfmt+0x120>
            if (width < 0)
ffffffffc020609a:	876a                	mv	a4,s10
ffffffffc020609c:	000d5363          	bgez	s10,ffffffffc02060a2 <vprintfmt+0x1a2>
ffffffffc02060a0:	4701                	li	a4,0
ffffffffc02060a2:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02060a6:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc02060a8:	bd55                	j	ffffffffc0205f5c <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc02060aa:	000d841b          	sext.w	s0,s11
ffffffffc02060ae:	fd340793          	addi	a5,s0,-45
ffffffffc02060b2:	00f037b3          	snez	a5,a5
ffffffffc02060b6:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02060ba:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc02060be:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02060c0:	008a0793          	addi	a5,s4,8
ffffffffc02060c4:	e43e                	sd	a5,8(sp)
ffffffffc02060c6:	100d8c63          	beqz	s11,ffffffffc02061de <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc02060ca:	12071363          	bnez	a4,ffffffffc02061f0 <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02060ce:	000dc783          	lbu	a5,0(s11)
ffffffffc02060d2:	0007851b          	sext.w	a0,a5
ffffffffc02060d6:	c78d                	beqz	a5,ffffffffc0206100 <vprintfmt+0x200>
ffffffffc02060d8:	0d85                	addi	s11,s11,1
ffffffffc02060da:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02060dc:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02060e0:	000cc563          	bltz	s9,ffffffffc02060ea <vprintfmt+0x1ea>
ffffffffc02060e4:	3cfd                	addiw	s9,s9,-1
ffffffffc02060e6:	008c8d63          	beq	s9,s0,ffffffffc0206100 <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02060ea:	020b9663          	bnez	s7,ffffffffc0206116 <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc02060ee:	85ca                	mv	a1,s2
ffffffffc02060f0:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02060f2:	000dc783          	lbu	a5,0(s11)
ffffffffc02060f6:	0d85                	addi	s11,s11,1
ffffffffc02060f8:	3d7d                	addiw	s10,s10,-1
ffffffffc02060fa:	0007851b          	sext.w	a0,a5
ffffffffc02060fe:	f3ed                	bnez	a5,ffffffffc02060e0 <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc0206100:	01a05963          	blez	s10,ffffffffc0206112 <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc0206104:	85ca                	mv	a1,s2
ffffffffc0206106:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc020610a:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc020610c:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc020610e:	fe0d1be3          	bnez	s10,ffffffffc0206104 <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0206112:	6a22                	ld	s4,8(sp)
ffffffffc0206114:	b505                	j	ffffffffc0205f34 <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0206116:	3781                	addiw	a5,a5,-32
ffffffffc0206118:	fcfa7be3          	bgeu	s4,a5,ffffffffc02060ee <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc020611c:	03f00513          	li	a0,63
ffffffffc0206120:	85ca                	mv	a1,s2
ffffffffc0206122:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0206124:	000dc783          	lbu	a5,0(s11)
ffffffffc0206128:	0d85                	addi	s11,s11,1
ffffffffc020612a:	3d7d                	addiw	s10,s10,-1
ffffffffc020612c:	0007851b          	sext.w	a0,a5
ffffffffc0206130:	dbe1                	beqz	a5,ffffffffc0206100 <vprintfmt+0x200>
ffffffffc0206132:	fa0cd9e3          	bgez	s9,ffffffffc02060e4 <vprintfmt+0x1e4>
ffffffffc0206136:	b7c5                	j	ffffffffc0206116 <vprintfmt+0x216>
            if (err < 0) {
ffffffffc0206138:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020613c:	4661                	li	a2,24
            err = va_arg(ap, int);
ffffffffc020613e:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0206140:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0206144:	8fb9                	xor	a5,a5,a4
ffffffffc0206146:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020614a:	02d64563          	blt	a2,a3,ffffffffc0206174 <vprintfmt+0x274>
ffffffffc020614e:	00003797          	auipc	a5,0x3
ffffffffc0206152:	e8278793          	addi	a5,a5,-382 # ffffffffc0208fd0 <error_string>
ffffffffc0206156:	00369713          	slli	a4,a3,0x3
ffffffffc020615a:	97ba                	add	a5,a5,a4
ffffffffc020615c:	639c                	ld	a5,0(a5)
ffffffffc020615e:	cb99                	beqz	a5,ffffffffc0206174 <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc0206160:	86be                	mv	a3,a5
ffffffffc0206162:	00000617          	auipc	a2,0x0
ffffffffc0206166:	20e60613          	addi	a2,a2,526 # ffffffffc0206370 <etext+0x2c>
ffffffffc020616a:	85ca                	mv	a1,s2
ffffffffc020616c:	8526                	mv	a0,s1
ffffffffc020616e:	0d8000ef          	jal	ffffffffc0206246 <printfmt>
ffffffffc0206172:	b3c9                	j	ffffffffc0205f34 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0206174:	00002617          	auipc	a2,0x2
ffffffffc0206178:	34460613          	addi	a2,a2,836 # ffffffffc02084b8 <etext+0x2174>
ffffffffc020617c:	85ca                	mv	a1,s2
ffffffffc020617e:	8526                	mv	a0,s1
ffffffffc0206180:	0c6000ef          	jal	ffffffffc0206246 <printfmt>
ffffffffc0206184:	bb45                	j	ffffffffc0205f34 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0206186:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0206188:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc020618c:	00f74363          	blt	a4,a5,ffffffffc0206192 <vprintfmt+0x292>
    else if (lflag) {
ffffffffc0206190:	cf81                	beqz	a5,ffffffffc02061a8 <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc0206192:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0206196:	02044b63          	bltz	s0,ffffffffc02061cc <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc020619a:	8622                	mv	a2,s0
ffffffffc020619c:	8a5e                	mv	s4,s7
ffffffffc020619e:	46a9                	li	a3,10
ffffffffc02061a0:	b541                	j	ffffffffc0206020 <vprintfmt+0x120>
            lflag ++;
ffffffffc02061a2:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02061a4:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc02061a6:	bb5d                	j	ffffffffc0205f5c <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc02061a8:	000a2403          	lw	s0,0(s4)
ffffffffc02061ac:	b7ed                	j	ffffffffc0206196 <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc02061ae:	000a6603          	lwu	a2,0(s4)
ffffffffc02061b2:	46a1                	li	a3,8
ffffffffc02061b4:	8a2e                	mv	s4,a1
ffffffffc02061b6:	b5ad                	j	ffffffffc0206020 <vprintfmt+0x120>
ffffffffc02061b8:	000a6603          	lwu	a2,0(s4)
ffffffffc02061bc:	46a9                	li	a3,10
ffffffffc02061be:	8a2e                	mv	s4,a1
ffffffffc02061c0:	b585                	j	ffffffffc0206020 <vprintfmt+0x120>
ffffffffc02061c2:	000a6603          	lwu	a2,0(s4)
ffffffffc02061c6:	46c1                	li	a3,16
ffffffffc02061c8:	8a2e                	mv	s4,a1
ffffffffc02061ca:	bd99                	j	ffffffffc0206020 <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc02061cc:	85ca                	mv	a1,s2
ffffffffc02061ce:	02d00513          	li	a0,45
ffffffffc02061d2:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc02061d4:	40800633          	neg	a2,s0
ffffffffc02061d8:	8a5e                	mv	s4,s7
ffffffffc02061da:	46a9                	li	a3,10
ffffffffc02061dc:	b591                	j	ffffffffc0206020 <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc02061de:	e329                	bnez	a4,ffffffffc0206220 <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02061e0:	02800793          	li	a5,40
ffffffffc02061e4:	853e                	mv	a0,a5
ffffffffc02061e6:	00002d97          	auipc	s11,0x2
ffffffffc02061ea:	2cbd8d93          	addi	s11,s11,715 # ffffffffc02084b1 <etext+0x216d>
ffffffffc02061ee:	b5f5                	j	ffffffffc02060da <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02061f0:	85e6                	mv	a1,s9
ffffffffc02061f2:	856e                	mv	a0,s11
ffffffffc02061f4:	08a000ef          	jal	ffffffffc020627e <strnlen>
ffffffffc02061f8:	40ad0d3b          	subw	s10,s10,a0
ffffffffc02061fc:	01a05863          	blez	s10,ffffffffc020620c <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc0206200:	85ca                	mv	a1,s2
ffffffffc0206202:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0206204:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc0206206:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0206208:	fe0d1ce3          	bnez	s10,ffffffffc0206200 <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020620c:	000dc783          	lbu	a5,0(s11)
ffffffffc0206210:	0007851b          	sext.w	a0,a5
ffffffffc0206214:	ec0792e3          	bnez	a5,ffffffffc02060d8 <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0206218:	6a22                	ld	s4,8(sp)
ffffffffc020621a:	bb29                	j	ffffffffc0205f34 <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020621c:	8462                	mv	s0,s8
ffffffffc020621e:	bbd9                	j	ffffffffc0205ff4 <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0206220:	85e6                	mv	a1,s9
ffffffffc0206222:	00002517          	auipc	a0,0x2
ffffffffc0206226:	28e50513          	addi	a0,a0,654 # ffffffffc02084b0 <etext+0x216c>
ffffffffc020622a:	054000ef          	jal	ffffffffc020627e <strnlen>
ffffffffc020622e:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0206232:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0206236:	00002d97          	auipc	s11,0x2
ffffffffc020623a:	27ad8d93          	addi	s11,s11,634 # ffffffffc02084b0 <etext+0x216c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020623e:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0206240:	fda040e3          	bgtz	s10,ffffffffc0206200 <vprintfmt+0x300>
ffffffffc0206244:	bd51                	j	ffffffffc02060d8 <vprintfmt+0x1d8>

ffffffffc0206246 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0206246:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0206248:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020624c:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020624e:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0206250:	ec06                	sd	ra,24(sp)
ffffffffc0206252:	f83a                	sd	a4,48(sp)
ffffffffc0206254:	fc3e                	sd	a5,56(sp)
ffffffffc0206256:	e0c2                	sd	a6,64(sp)
ffffffffc0206258:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc020625a:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020625c:	ca5ff0ef          	jal	ffffffffc0205f00 <vprintfmt>
}
ffffffffc0206260:	60e2                	ld	ra,24(sp)
ffffffffc0206262:	6161                	addi	sp,sp,80
ffffffffc0206264:	8082                	ret

ffffffffc0206266 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0206266:	00054783          	lbu	a5,0(a0)
ffffffffc020626a:	cb81                	beqz	a5,ffffffffc020627a <strlen+0x14>
    size_t cnt = 0;
ffffffffc020626c:	4781                	li	a5,0
        cnt ++;
ffffffffc020626e:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc0206270:	00f50733          	add	a4,a0,a5
ffffffffc0206274:	00074703          	lbu	a4,0(a4)
ffffffffc0206278:	fb7d                	bnez	a4,ffffffffc020626e <strlen+0x8>
    }
    return cnt;
}
ffffffffc020627a:	853e                	mv	a0,a5
ffffffffc020627c:	8082                	ret

ffffffffc020627e <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc020627e:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0206280:	e589                	bnez	a1,ffffffffc020628a <strnlen+0xc>
ffffffffc0206282:	a811                	j	ffffffffc0206296 <strnlen+0x18>
        cnt ++;
ffffffffc0206284:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0206286:	00f58863          	beq	a1,a5,ffffffffc0206296 <strnlen+0x18>
ffffffffc020628a:	00f50733          	add	a4,a0,a5
ffffffffc020628e:	00074703          	lbu	a4,0(a4)
ffffffffc0206292:	fb6d                	bnez	a4,ffffffffc0206284 <strnlen+0x6>
ffffffffc0206294:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0206296:	852e                	mv	a0,a1
ffffffffc0206298:	8082                	ret

ffffffffc020629a <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc020629a:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc020629c:	0005c703          	lbu	a4,0(a1)
ffffffffc02062a0:	0585                	addi	a1,a1,1
ffffffffc02062a2:	0785                	addi	a5,a5,1
ffffffffc02062a4:	fee78fa3          	sb	a4,-1(a5)
ffffffffc02062a8:	fb75                	bnez	a4,ffffffffc020629c <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc02062aa:	8082                	ret

ffffffffc02062ac <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02062ac:	00054783          	lbu	a5,0(a0)
ffffffffc02062b0:	e791                	bnez	a5,ffffffffc02062bc <strcmp+0x10>
ffffffffc02062b2:	a01d                	j	ffffffffc02062d8 <strcmp+0x2c>
ffffffffc02062b4:	00054783          	lbu	a5,0(a0)
ffffffffc02062b8:	cb99                	beqz	a5,ffffffffc02062ce <strcmp+0x22>
ffffffffc02062ba:	0585                	addi	a1,a1,1
ffffffffc02062bc:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc02062c0:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02062c2:	fef709e3          	beq	a4,a5,ffffffffc02062b4 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02062c6:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02062ca:	9d19                	subw	a0,a0,a4
ffffffffc02062cc:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02062ce:	0015c703          	lbu	a4,1(a1)
ffffffffc02062d2:	4501                	li	a0,0
}
ffffffffc02062d4:	9d19                	subw	a0,a0,a4
ffffffffc02062d6:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02062d8:	0005c703          	lbu	a4,0(a1)
ffffffffc02062dc:	4501                	li	a0,0
ffffffffc02062de:	b7f5                	j	ffffffffc02062ca <strcmp+0x1e>

ffffffffc02062e0 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02062e0:	ce01                	beqz	a2,ffffffffc02062f8 <strncmp+0x18>
ffffffffc02062e2:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc02062e6:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02062e8:	cb91                	beqz	a5,ffffffffc02062fc <strncmp+0x1c>
ffffffffc02062ea:	0005c703          	lbu	a4,0(a1)
ffffffffc02062ee:	00f71763          	bne	a4,a5,ffffffffc02062fc <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc02062f2:	0505                	addi	a0,a0,1
ffffffffc02062f4:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02062f6:	f675                	bnez	a2,ffffffffc02062e2 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02062f8:	4501                	li	a0,0
ffffffffc02062fa:	8082                	ret
ffffffffc02062fc:	00054503          	lbu	a0,0(a0)
ffffffffc0206300:	0005c783          	lbu	a5,0(a1)
ffffffffc0206304:	9d1d                	subw	a0,a0,a5
}
ffffffffc0206306:	8082                	ret

ffffffffc0206308 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0206308:	a021                	j	ffffffffc0206310 <strchr+0x8>
        if (*s == c) {
ffffffffc020630a:	00f58763          	beq	a1,a5,ffffffffc0206318 <strchr+0x10>
            return (char *)s;
        }
        s ++;
ffffffffc020630e:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0206310:	00054783          	lbu	a5,0(a0)
ffffffffc0206314:	fbfd                	bnez	a5,ffffffffc020630a <strchr+0x2>
    }
    return NULL;
ffffffffc0206316:	4501                	li	a0,0
}
ffffffffc0206318:	8082                	ret

ffffffffc020631a <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc020631a:	ca01                	beqz	a2,ffffffffc020632a <memset+0x10>
ffffffffc020631c:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc020631e:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0206320:	0785                	addi	a5,a5,1
ffffffffc0206322:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0206326:	fef61de3          	bne	a2,a5,ffffffffc0206320 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc020632a:	8082                	ret

ffffffffc020632c <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc020632c:	ca19                	beqz	a2,ffffffffc0206342 <memcpy+0x16>
ffffffffc020632e:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0206330:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0206332:	0005c703          	lbu	a4,0(a1)
ffffffffc0206336:	0585                	addi	a1,a1,1
ffffffffc0206338:	0785                	addi	a5,a5,1
ffffffffc020633a:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc020633e:	feb61ae3          	bne	a2,a1,ffffffffc0206332 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0206342:	8082                	ret
