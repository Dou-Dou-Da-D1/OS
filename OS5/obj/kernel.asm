
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000b297          	auipc	t0,0xb
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020b000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000b297          	auipc	t0,0xb
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020b008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020a2b7          	lui	t0,0xc020a
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
ffffffffc020003c:	c020a137          	lui	sp,0xc020a

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
ffffffffc020004a:	000a1517          	auipc	a0,0xa1
ffffffffc020004e:	af650513          	addi	a0,a0,-1290 # ffffffffc02a0b40 <buf>
ffffffffc0200052:	000a5617          	auipc	a2,0xa5
ffffffffc0200056:	f9660613          	addi	a2,a2,-106 # ffffffffc02a4fe8 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc0209ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	1e9050ef          	jal	ffffffffc0205a4a <memset>
    dtb_init();
ffffffffc0200066:	552000ef          	jal	ffffffffc02005b8 <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	4dc000ef          	jal	ffffffffc0200546 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00006597          	auipc	a1,0x6
ffffffffc0200072:	a0a58593          	addi	a1,a1,-1526 # ffffffffc0205a78 <etext+0x4>
ffffffffc0200076:	00006517          	auipc	a0,0x6
ffffffffc020007a:	a2250513          	addi	a0,a0,-1502 # ffffffffc0205a98 <etext+0x24>
ffffffffc020007e:	116000ef          	jal	ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	1a4000ef          	jal	ffffffffc0200226 <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	71c020ef          	jal	ffffffffc02027a2 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	081000ef          	jal	ffffffffc020090a <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	07f000ef          	jal	ffffffffc020090c <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	265030ef          	jal	ffffffffc0203af6 <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	0fe050ef          	jal	ffffffffc0205194 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	45a000ef          	jal	ffffffffc02004f4 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	061000ef          	jal	ffffffffc02008fe <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	292050ef          	jal	ffffffffc0205334 <cpu_idle>

ffffffffc02000a6 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000a6:	7179                	addi	sp,sp,-48
ffffffffc02000a8:	f406                	sd	ra,40(sp)
ffffffffc02000aa:	f022                	sd	s0,32(sp)
ffffffffc02000ac:	ec26                	sd	s1,24(sp)
ffffffffc02000ae:	e84a                	sd	s2,16(sp)
ffffffffc02000b0:	e44e                	sd	s3,8(sp)
    if (prompt != NULL) {
ffffffffc02000b2:	c901                	beqz	a0,ffffffffc02000c2 <readline+0x1c>
        cprintf("%s", prompt);
ffffffffc02000b4:	85aa                	mv	a1,a0
ffffffffc02000b6:	00006517          	auipc	a0,0x6
ffffffffc02000ba:	9ea50513          	addi	a0,a0,-1558 # ffffffffc0205aa0 <etext+0x2c>
ffffffffc02000be:	0d6000ef          	jal	ffffffffc0200194 <cprintf>
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cputchar(c);
            buf[i ++] = c;
ffffffffc02000c2:	4481                	li	s1,0
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000c4:	497d                	li	s2,31
            buf[i ++] = c;
ffffffffc02000c6:	000a1997          	auipc	s3,0xa1
ffffffffc02000ca:	a7a98993          	addi	s3,s3,-1414 # ffffffffc02a0b40 <buf>
        c = getchar();
ffffffffc02000ce:	148000ef          	jal	ffffffffc0200216 <getchar>
ffffffffc02000d2:	842a                	mv	s0,a0
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000d4:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000d8:	3ff4a713          	slti	a4,s1,1023
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000dc:	ff650693          	addi	a3,a0,-10
ffffffffc02000e0:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc02000e4:	02054963          	bltz	a0,ffffffffc0200116 <readline+0x70>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000e8:	02a95f63          	bge	s2,a0,ffffffffc0200126 <readline+0x80>
ffffffffc02000ec:	cf0d                	beqz	a4,ffffffffc0200126 <readline+0x80>
            cputchar(c);
ffffffffc02000ee:	0da000ef          	jal	ffffffffc02001c8 <cputchar>
            buf[i ++] = c;
ffffffffc02000f2:	009987b3          	add	a5,s3,s1
ffffffffc02000f6:	00878023          	sb	s0,0(a5)
ffffffffc02000fa:	2485                	addiw	s1,s1,1
        c = getchar();
ffffffffc02000fc:	11a000ef          	jal	ffffffffc0200216 <getchar>
ffffffffc0200100:	842a                	mv	s0,a0
        else if (c == '\b' && i > 0) {
ffffffffc0200102:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0200106:	3ff4a713          	slti	a4,s1,1023
        else if (c == '\n' || c == '\r') {
ffffffffc020010a:	ff650693          	addi	a3,a0,-10
ffffffffc020010e:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc0200112:	fc055be3          	bgez	a0,ffffffffc02000e8 <readline+0x42>
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
}
ffffffffc0200116:	70a2                	ld	ra,40(sp)
ffffffffc0200118:	7402                	ld	s0,32(sp)
ffffffffc020011a:	64e2                	ld	s1,24(sp)
ffffffffc020011c:	6942                	ld	s2,16(sp)
ffffffffc020011e:	69a2                	ld	s3,8(sp)
            return NULL;
ffffffffc0200120:	4501                	li	a0,0
}
ffffffffc0200122:	6145                	addi	sp,sp,48
ffffffffc0200124:	8082                	ret
        else if (c == '\b' && i > 0) {
ffffffffc0200126:	eb81                	bnez	a5,ffffffffc0200136 <readline+0x90>
            cputchar(c);
ffffffffc0200128:	4521                	li	a0,8
        else if (c == '\b' && i > 0) {
ffffffffc020012a:	00905663          	blez	s1,ffffffffc0200136 <readline+0x90>
            cputchar(c);
ffffffffc020012e:	09a000ef          	jal	ffffffffc02001c8 <cputchar>
            i --;
ffffffffc0200132:	34fd                	addiw	s1,s1,-1
ffffffffc0200134:	bf69                	j	ffffffffc02000ce <readline+0x28>
        else if (c == '\n' || c == '\r') {
ffffffffc0200136:	c291                	beqz	a3,ffffffffc020013a <readline+0x94>
ffffffffc0200138:	fa59                	bnez	a2,ffffffffc02000ce <readline+0x28>
            cputchar(c);
ffffffffc020013a:	8522                	mv	a0,s0
ffffffffc020013c:	08c000ef          	jal	ffffffffc02001c8 <cputchar>
            buf[i] = '\0';
ffffffffc0200140:	000a1517          	auipc	a0,0xa1
ffffffffc0200144:	a0050513          	addi	a0,a0,-1536 # ffffffffc02a0b40 <buf>
ffffffffc0200148:	94aa                	add	s1,s1,a0
ffffffffc020014a:	00048023          	sb	zero,0(s1)
}
ffffffffc020014e:	70a2                	ld	ra,40(sp)
ffffffffc0200150:	7402                	ld	s0,32(sp)
ffffffffc0200152:	64e2                	ld	s1,24(sp)
ffffffffc0200154:	6942                	ld	s2,16(sp)
ffffffffc0200156:	69a2                	ld	s3,8(sp)
ffffffffc0200158:	6145                	addi	sp,sp,48
ffffffffc020015a:	8082                	ret

ffffffffc020015c <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015c:	1101                	addi	sp,sp,-32
ffffffffc020015e:	ec06                	sd	ra,24(sp)
ffffffffc0200160:	e42e                	sd	a1,8(sp)
    cons_putc(c);
ffffffffc0200162:	3e6000ef          	jal	ffffffffc0200548 <cons_putc>
    (*cnt)++;
ffffffffc0200166:	65a2                	ld	a1,8(sp)
}
ffffffffc0200168:	60e2                	ld	ra,24(sp)
    (*cnt)++;
ffffffffc020016a:	419c                	lw	a5,0(a1)
ffffffffc020016c:	2785                	addiw	a5,a5,1
ffffffffc020016e:	c19c                	sw	a5,0(a1)
}
ffffffffc0200170:	6105                	addi	sp,sp,32
ffffffffc0200172:	8082                	ret

ffffffffc0200174 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc0200174:	1101                	addi	sp,sp,-32
ffffffffc0200176:	862a                	mv	a2,a0
ffffffffc0200178:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020017a:	00000517          	auipc	a0,0x0
ffffffffc020017e:	fe250513          	addi	a0,a0,-30 # ffffffffc020015c <cputch>
ffffffffc0200182:	006c                	addi	a1,sp,12
{
ffffffffc0200184:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200186:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc0200188:	4a8050ef          	jal	ffffffffc0205630 <vprintfmt>
    return cnt;
}
ffffffffc020018c:	60e2                	ld	ra,24(sp)
ffffffffc020018e:	4532                	lw	a0,12(sp)
ffffffffc0200190:	6105                	addi	sp,sp,32
ffffffffc0200192:	8082                	ret

ffffffffc0200194 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc0200194:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc0200196:	02810313          	addi	t1,sp,40
{
ffffffffc020019a:	f42e                	sd	a1,40(sp)
ffffffffc020019c:	f832                	sd	a2,48(sp)
ffffffffc020019e:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a0:	862a                	mv	a2,a0
ffffffffc02001a2:	004c                	addi	a1,sp,4
ffffffffc02001a4:	00000517          	auipc	a0,0x0
ffffffffc02001a8:	fb850513          	addi	a0,a0,-72 # ffffffffc020015c <cputch>
ffffffffc02001ac:	869a                	mv	a3,t1
{
ffffffffc02001ae:	ec06                	sd	ra,24(sp)
ffffffffc02001b0:	e0ba                	sd	a4,64(sp)
ffffffffc02001b2:	e4be                	sd	a5,72(sp)
ffffffffc02001b4:	e8c2                	sd	a6,80(sp)
ffffffffc02001b6:	ecc6                	sd	a7,88(sp)
    int cnt = 0;
ffffffffc02001b8:	c202                	sw	zero,4(sp)
    va_start(ap, fmt);
ffffffffc02001ba:	e41a                	sd	t1,8(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001bc:	474050ef          	jal	ffffffffc0205630 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c0:	60e2                	ld	ra,24(sp)
ffffffffc02001c2:	4512                	lw	a0,4(sp)
ffffffffc02001c4:	6125                	addi	sp,sp,96
ffffffffc02001c6:	8082                	ret

ffffffffc02001c8 <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001c8:	a641                	j	ffffffffc0200548 <cons_putc>

ffffffffc02001ca <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001ca:	1101                	addi	sp,sp,-32
ffffffffc02001cc:	e822                	sd	s0,16(sp)
ffffffffc02001ce:	ec06                	sd	ra,24(sp)
ffffffffc02001d0:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001d2:	00054503          	lbu	a0,0(a0)
ffffffffc02001d6:	c51d                	beqz	a0,ffffffffc0200204 <cputs+0x3a>
ffffffffc02001d8:	e426                	sd	s1,8(sp)
ffffffffc02001da:	0405                	addi	s0,s0,1
    int cnt = 0;
ffffffffc02001dc:	4481                	li	s1,0
    cons_putc(c);
ffffffffc02001de:	36a000ef          	jal	ffffffffc0200548 <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001e2:	00044503          	lbu	a0,0(s0)
ffffffffc02001e6:	0405                	addi	s0,s0,1
ffffffffc02001e8:	87a6                	mv	a5,s1
    (*cnt)++;
ffffffffc02001ea:	2485                	addiw	s1,s1,1
    while ((c = *str++) != '\0')
ffffffffc02001ec:	f96d                	bnez	a0,ffffffffc02001de <cputs+0x14>
    cons_putc(c);
ffffffffc02001ee:	4529                	li	a0,10
    (*cnt)++;
ffffffffc02001f0:	0027841b          	addiw	s0,a5,2
ffffffffc02001f4:	64a2                	ld	s1,8(sp)
    cons_putc(c);
ffffffffc02001f6:	352000ef          	jal	ffffffffc0200548 <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001fa:	60e2                	ld	ra,24(sp)
ffffffffc02001fc:	8522                	mv	a0,s0
ffffffffc02001fe:	6442                	ld	s0,16(sp)
ffffffffc0200200:	6105                	addi	sp,sp,32
ffffffffc0200202:	8082                	ret
    cons_putc(c);
ffffffffc0200204:	4529                	li	a0,10
ffffffffc0200206:	342000ef          	jal	ffffffffc0200548 <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc020020a:	4405                	li	s0,1
}
ffffffffc020020c:	60e2                	ld	ra,24(sp)
ffffffffc020020e:	8522                	mv	a0,s0
ffffffffc0200210:	6442                	ld	s0,16(sp)
ffffffffc0200212:	6105                	addi	sp,sp,32
ffffffffc0200214:	8082                	ret

ffffffffc0200216 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc0200216:	1141                	addi	sp,sp,-16
ffffffffc0200218:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020021a:	362000ef          	jal	ffffffffc020057c <cons_getc>
ffffffffc020021e:	dd75                	beqz	a0,ffffffffc020021a <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200220:	60a2                	ld	ra,8(sp)
ffffffffc0200222:	0141                	addi	sp,sp,16
ffffffffc0200224:	8082                	ret

ffffffffc0200226 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc0200226:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200228:	00006517          	auipc	a0,0x6
ffffffffc020022c:	88050513          	addi	a0,a0,-1920 # ffffffffc0205aa8 <etext+0x34>
{
ffffffffc0200230:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200232:	f63ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200236:	00000597          	auipc	a1,0x0
ffffffffc020023a:	e1458593          	addi	a1,a1,-492 # ffffffffc020004a <kern_init>
ffffffffc020023e:	00006517          	auipc	a0,0x6
ffffffffc0200242:	88a50513          	addi	a0,a0,-1910 # ffffffffc0205ac8 <etext+0x54>
ffffffffc0200246:	f4fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020024a:	00006597          	auipc	a1,0x6
ffffffffc020024e:	82a58593          	addi	a1,a1,-2006 # ffffffffc0205a74 <etext>
ffffffffc0200252:	00006517          	auipc	a0,0x6
ffffffffc0200256:	89650513          	addi	a0,a0,-1898 # ffffffffc0205ae8 <etext+0x74>
ffffffffc020025a:	f3bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc020025e:	000a1597          	auipc	a1,0xa1
ffffffffc0200262:	8e258593          	addi	a1,a1,-1822 # ffffffffc02a0b40 <buf>
ffffffffc0200266:	00006517          	auipc	a0,0x6
ffffffffc020026a:	8a250513          	addi	a0,a0,-1886 # ffffffffc0205b08 <etext+0x94>
ffffffffc020026e:	f27ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200272:	000a5597          	auipc	a1,0xa5
ffffffffc0200276:	d7658593          	addi	a1,a1,-650 # ffffffffc02a4fe8 <end>
ffffffffc020027a:	00006517          	auipc	a0,0x6
ffffffffc020027e:	8ae50513          	addi	a0,a0,-1874 # ffffffffc0205b28 <etext+0xb4>
ffffffffc0200282:	f13ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200286:	00000717          	auipc	a4,0x0
ffffffffc020028a:	dc470713          	addi	a4,a4,-572 # ffffffffc020004a <kern_init>
ffffffffc020028e:	000a5797          	auipc	a5,0xa5
ffffffffc0200292:	15978793          	addi	a5,a5,345 # ffffffffc02a53e7 <end+0x3ff>
ffffffffc0200296:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200298:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc020029c:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020029e:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002a2:	95be                	add	a1,a1,a5
ffffffffc02002a4:	85a9                	srai	a1,a1,0xa
ffffffffc02002a6:	00006517          	auipc	a0,0x6
ffffffffc02002aa:	8a250513          	addi	a0,a0,-1886 # ffffffffc0205b48 <etext+0xd4>
}
ffffffffc02002ae:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002b0:	b5d5                	j	ffffffffc0200194 <cprintf>

ffffffffc02002b2 <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc02002b2:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002b4:	00006617          	auipc	a2,0x6
ffffffffc02002b8:	8c460613          	addi	a2,a2,-1852 # ffffffffc0205b78 <etext+0x104>
ffffffffc02002bc:	04f00593          	li	a1,79
ffffffffc02002c0:	00006517          	auipc	a0,0x6
ffffffffc02002c4:	8d050513          	addi	a0,a0,-1840 # ffffffffc0205b90 <etext+0x11c>
{
ffffffffc02002c8:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002ca:	17c000ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02002ce <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02002ce:	1101                	addi	sp,sp,-32
ffffffffc02002d0:	e822                	sd	s0,16(sp)
ffffffffc02002d2:	e426                	sd	s1,8(sp)
ffffffffc02002d4:	ec06                	sd	ra,24(sp)
ffffffffc02002d6:	00007417          	auipc	s0,0x7
ffffffffc02002da:	54240413          	addi	s0,s0,1346 # ffffffffc0207818 <commands>
ffffffffc02002de:	00007497          	auipc	s1,0x7
ffffffffc02002e2:	58248493          	addi	s1,s1,1410 # ffffffffc0207860 <commands+0x48>
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e6:	6410                	ld	a2,8(s0)
ffffffffc02002e8:	600c                	ld	a1,0(s0)
ffffffffc02002ea:	00006517          	auipc	a0,0x6
ffffffffc02002ee:	8be50513          	addi	a0,a0,-1858 # ffffffffc0205ba8 <etext+0x134>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02002f2:	0461                	addi	s0,s0,24
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002f4:	ea1ff0ef          	jal	ffffffffc0200194 <cprintf>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02002f8:	fe9417e3          	bne	s0,s1,ffffffffc02002e6 <mon_help+0x18>
    }
    return 0;
}
ffffffffc02002fc:	60e2                	ld	ra,24(sp)
ffffffffc02002fe:	6442                	ld	s0,16(sp)
ffffffffc0200300:	64a2                	ld	s1,8(sp)
ffffffffc0200302:	4501                	li	a0,0
ffffffffc0200304:	6105                	addi	sp,sp,32
ffffffffc0200306:	8082                	ret

ffffffffc0200308 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200308:	1141                	addi	sp,sp,-16
ffffffffc020030a:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020030c:	f1bff0ef          	jal	ffffffffc0200226 <print_kerninfo>
    return 0;
}
ffffffffc0200310:	60a2                	ld	ra,8(sp)
ffffffffc0200312:	4501                	li	a0,0
ffffffffc0200314:	0141                	addi	sp,sp,16
ffffffffc0200316:	8082                	ret

ffffffffc0200318 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200318:	1141                	addi	sp,sp,-16
ffffffffc020031a:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020031c:	f97ff0ef          	jal	ffffffffc02002b2 <print_stackframe>
    return 0;
}
ffffffffc0200320:	60a2                	ld	ra,8(sp)
ffffffffc0200322:	4501                	li	a0,0
ffffffffc0200324:	0141                	addi	sp,sp,16
ffffffffc0200326:	8082                	ret

ffffffffc0200328 <kmonitor>:
{
ffffffffc0200328:	7131                	addi	sp,sp,-192
ffffffffc020032a:	e952                	sd	s4,144(sp)
ffffffffc020032c:	8a2a                	mv	s4,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020032e:	00006517          	auipc	a0,0x6
ffffffffc0200332:	88a50513          	addi	a0,a0,-1910 # ffffffffc0205bb8 <etext+0x144>
{
ffffffffc0200336:	fd06                	sd	ra,184(sp)
ffffffffc0200338:	f922                	sd	s0,176(sp)
ffffffffc020033a:	f526                	sd	s1,168(sp)
ffffffffc020033c:	ed4e                	sd	s3,152(sp)
ffffffffc020033e:	e556                	sd	s5,136(sp)
ffffffffc0200340:	e15a                	sd	s6,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200342:	e53ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200346:	00006517          	auipc	a0,0x6
ffffffffc020034a:	89a50513          	addi	a0,a0,-1894 # ffffffffc0205be0 <etext+0x16c>
ffffffffc020034e:	e47ff0ef          	jal	ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc0200352:	000a0563          	beqz	s4,ffffffffc020035c <kmonitor+0x34>
        print_trapframe(tf);
ffffffffc0200356:	8552                	mv	a0,s4
ffffffffc0200358:	79c000ef          	jal	ffffffffc0200af4 <print_trapframe>
ffffffffc020035c:	00007a97          	auipc	s5,0x7
ffffffffc0200360:	4bca8a93          	addi	s5,s5,1212 # ffffffffc0207818 <commands>
        if (argc == MAXARGS - 1)
ffffffffc0200364:	49bd                	li	s3,15
        if ((buf = readline("K> ")) != NULL)
ffffffffc0200366:	00006517          	auipc	a0,0x6
ffffffffc020036a:	8a250513          	addi	a0,a0,-1886 # ffffffffc0205c08 <etext+0x194>
ffffffffc020036e:	d39ff0ef          	jal	ffffffffc02000a6 <readline>
ffffffffc0200372:	842a                	mv	s0,a0
ffffffffc0200374:	d96d                	beqz	a0,ffffffffc0200366 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200376:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc020037a:	4481                	li	s1,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020037c:	e99d                	bnez	a1,ffffffffc02003b2 <kmonitor+0x8a>
    int argc = 0;
ffffffffc020037e:	8b26                	mv	s6,s1
    if (argc == 0)
ffffffffc0200380:	fe0b03e3          	beqz	s6,ffffffffc0200366 <kmonitor+0x3e>
ffffffffc0200384:	00007497          	auipc	s1,0x7
ffffffffc0200388:	49448493          	addi	s1,s1,1172 # ffffffffc0207818 <commands>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc020038c:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc020038e:	6582                	ld	a1,0(sp)
ffffffffc0200390:	6088                	ld	a0,0(s1)
ffffffffc0200392:	64a050ef          	jal	ffffffffc02059dc <strcmp>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc0200396:	478d                	li	a5,3
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc0200398:	c149                	beqz	a0,ffffffffc020041a <kmonitor+0xf2>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc020039a:	2405                	addiw	s0,s0,1
ffffffffc020039c:	04e1                	addi	s1,s1,24
ffffffffc020039e:	fef418e3          	bne	s0,a5,ffffffffc020038e <kmonitor+0x66>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003a2:	6582                	ld	a1,0(sp)
ffffffffc02003a4:	00006517          	auipc	a0,0x6
ffffffffc02003a8:	89450513          	addi	a0,a0,-1900 # ffffffffc0205c38 <etext+0x1c4>
ffffffffc02003ac:	de9ff0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
ffffffffc02003b0:	bf5d                	j	ffffffffc0200366 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003b2:	00006517          	auipc	a0,0x6
ffffffffc02003b6:	85e50513          	addi	a0,a0,-1954 # ffffffffc0205c10 <etext+0x19c>
ffffffffc02003ba:	67e050ef          	jal	ffffffffc0205a38 <strchr>
ffffffffc02003be:	c901                	beqz	a0,ffffffffc02003ce <kmonitor+0xa6>
ffffffffc02003c0:	00144583          	lbu	a1,1(s0)
            *buf++ = '\0';
ffffffffc02003c4:	00040023          	sb	zero,0(s0)
ffffffffc02003c8:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003ca:	d9d5                	beqz	a1,ffffffffc020037e <kmonitor+0x56>
ffffffffc02003cc:	b7dd                	j	ffffffffc02003b2 <kmonitor+0x8a>
        if (*buf == '\0')
ffffffffc02003ce:	00044783          	lbu	a5,0(s0)
ffffffffc02003d2:	d7d5                	beqz	a5,ffffffffc020037e <kmonitor+0x56>
        if (argc == MAXARGS - 1)
ffffffffc02003d4:	03348b63          	beq	s1,s3,ffffffffc020040a <kmonitor+0xe2>
        argv[argc++] = buf;
ffffffffc02003d8:	00349793          	slli	a5,s1,0x3
ffffffffc02003dc:	978a                	add	a5,a5,sp
ffffffffc02003de:	e380                	sd	s0,0(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc02003e0:	00044583          	lbu	a1,0(s0)
        argv[argc++] = buf;
ffffffffc02003e4:	2485                	addiw	s1,s1,1
ffffffffc02003e6:	8b26                	mv	s6,s1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc02003e8:	e591                	bnez	a1,ffffffffc02003f4 <kmonitor+0xcc>
ffffffffc02003ea:	bf59                	j	ffffffffc0200380 <kmonitor+0x58>
ffffffffc02003ec:	00144583          	lbu	a1,1(s0)
            buf++;
ffffffffc02003f0:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc02003f2:	d5d1                	beqz	a1,ffffffffc020037e <kmonitor+0x56>
ffffffffc02003f4:	00006517          	auipc	a0,0x6
ffffffffc02003f8:	81c50513          	addi	a0,a0,-2020 # ffffffffc0205c10 <etext+0x19c>
ffffffffc02003fc:	63c050ef          	jal	ffffffffc0205a38 <strchr>
ffffffffc0200400:	d575                	beqz	a0,ffffffffc02003ec <kmonitor+0xc4>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200402:	00044583          	lbu	a1,0(s0)
ffffffffc0200406:	dda5                	beqz	a1,ffffffffc020037e <kmonitor+0x56>
ffffffffc0200408:	b76d                	j	ffffffffc02003b2 <kmonitor+0x8a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020040a:	45c1                	li	a1,16
ffffffffc020040c:	00006517          	auipc	a0,0x6
ffffffffc0200410:	80c50513          	addi	a0,a0,-2036 # ffffffffc0205c18 <etext+0x1a4>
ffffffffc0200414:	d81ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200418:	b7c1                	j	ffffffffc02003d8 <kmonitor+0xb0>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc020041a:	00141793          	slli	a5,s0,0x1
ffffffffc020041e:	97a2                	add	a5,a5,s0
ffffffffc0200420:	078e                	slli	a5,a5,0x3
ffffffffc0200422:	97d6                	add	a5,a5,s5
ffffffffc0200424:	6b9c                	ld	a5,16(a5)
ffffffffc0200426:	fffb051b          	addiw	a0,s6,-1
ffffffffc020042a:	8652                	mv	a2,s4
ffffffffc020042c:	002c                	addi	a1,sp,8
ffffffffc020042e:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0)
ffffffffc0200430:	f2055be3          	bgez	a0,ffffffffc0200366 <kmonitor+0x3e>
}
ffffffffc0200434:	70ea                	ld	ra,184(sp)
ffffffffc0200436:	744a                	ld	s0,176(sp)
ffffffffc0200438:	74aa                	ld	s1,168(sp)
ffffffffc020043a:	69ea                	ld	s3,152(sp)
ffffffffc020043c:	6a4a                	ld	s4,144(sp)
ffffffffc020043e:	6aaa                	ld	s5,136(sp)
ffffffffc0200440:	6b0a                	ld	s6,128(sp)
ffffffffc0200442:	6129                	addi	sp,sp,192
ffffffffc0200444:	8082                	ret

ffffffffc0200446 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
ffffffffc0200446:	000a5317          	auipc	t1,0xa5
ffffffffc020044a:	b2233303          	ld	t1,-1246(t1) # ffffffffc02a4f68 <is_panic>
{
ffffffffc020044e:	715d                	addi	sp,sp,-80
ffffffffc0200450:	ec06                	sd	ra,24(sp)
ffffffffc0200452:	f436                	sd	a3,40(sp)
ffffffffc0200454:	f83a                	sd	a4,48(sp)
ffffffffc0200456:	fc3e                	sd	a5,56(sp)
ffffffffc0200458:	e0c2                	sd	a6,64(sp)
ffffffffc020045a:	e4c6                	sd	a7,72(sp)
    if (is_panic)
ffffffffc020045c:	02031e63          	bnez	t1,ffffffffc0200498 <__panic+0x52>
    {
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200460:	4705                	li	a4,1

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200462:	103c                	addi	a5,sp,40
ffffffffc0200464:	e822                	sd	s0,16(sp)
ffffffffc0200466:	8432                	mv	s0,a2
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200468:	862e                	mv	a2,a1
ffffffffc020046a:	85aa                	mv	a1,a0
ffffffffc020046c:	00006517          	auipc	a0,0x6
ffffffffc0200470:	87450513          	addi	a0,a0,-1932 # ffffffffc0205ce0 <etext+0x26c>
    is_panic = 1;
ffffffffc0200474:	000a5697          	auipc	a3,0xa5
ffffffffc0200478:	aee6ba23          	sd	a4,-1292(a3) # ffffffffc02a4f68 <is_panic>
    va_start(ap, fmt);
ffffffffc020047c:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020047e:	d17ff0ef          	jal	ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200482:	65a2                	ld	a1,8(sp)
ffffffffc0200484:	8522                	mv	a0,s0
ffffffffc0200486:	cefff0ef          	jal	ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc020048a:	00006517          	auipc	a0,0x6
ffffffffc020048e:	87650513          	addi	a0,a0,-1930 # ffffffffc0205d00 <etext+0x28c>
ffffffffc0200492:	d03ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200496:	6442                	ld	s0,16(sp)
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200498:	4501                	li	a0,0
ffffffffc020049a:	4581                	li	a1,0
ffffffffc020049c:	4601                	li	a2,0
ffffffffc020049e:	48a1                	li	a7,8
ffffffffc02004a0:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004a4:	460000ef          	jal	ffffffffc0200904 <intr_disable>
    while (1)
    {
        kmonitor(NULL);
ffffffffc02004a8:	4501                	li	a0,0
ffffffffc02004aa:	e7fff0ef          	jal	ffffffffc0200328 <kmonitor>
    while (1)
ffffffffc02004ae:	bfed                	j	ffffffffc02004a8 <__panic+0x62>

ffffffffc02004b0 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
ffffffffc02004b0:	715d                	addi	sp,sp,-80
ffffffffc02004b2:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004b4:	02810313          	addi	t1,sp,40
{
ffffffffc02004b8:	8432                	mv	s0,a2
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004ba:	862e                	mv	a2,a1
ffffffffc02004bc:	85aa                	mv	a1,a0
ffffffffc02004be:	00006517          	auipc	a0,0x6
ffffffffc02004c2:	84a50513          	addi	a0,a0,-1974 # ffffffffc0205d08 <etext+0x294>
{
ffffffffc02004c6:	ec06                	sd	ra,24(sp)
ffffffffc02004c8:	f436                	sd	a3,40(sp)
ffffffffc02004ca:	f83a                	sd	a4,48(sp)
ffffffffc02004cc:	fc3e                	sd	a5,56(sp)
ffffffffc02004ce:	e0c2                	sd	a6,64(sp)
ffffffffc02004d0:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02004d2:	e41a                	sd	t1,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004d4:	cc1ff0ef          	jal	ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004d8:	65a2                	ld	a1,8(sp)
ffffffffc02004da:	8522                	mv	a0,s0
ffffffffc02004dc:	c99ff0ef          	jal	ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc02004e0:	00006517          	auipc	a0,0x6
ffffffffc02004e4:	82050513          	addi	a0,a0,-2016 # ffffffffc0205d00 <etext+0x28c>
ffffffffc02004e8:	cadff0ef          	jal	ffffffffc0200194 <cprintf>
    va_end(ap);
}
ffffffffc02004ec:	60e2                	ld	ra,24(sp)
ffffffffc02004ee:	6442                	ld	s0,16(sp)
ffffffffc02004f0:	6161                	addi	sp,sp,80
ffffffffc02004f2:	8082                	ret

ffffffffc02004f4 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc02004f4:	67e1                	lui	a5,0x18
ffffffffc02004f6:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_exit_out_size+0xe4e0>
ffffffffc02004fa:	000a5717          	auipc	a4,0xa5
ffffffffc02004fe:	a6f73b23          	sd	a5,-1418(a4) # ffffffffc02a4f70 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200502:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200506:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200508:	953e                	add	a0,a0,a5
ffffffffc020050a:	4601                	li	a2,0
ffffffffc020050c:	4881                	li	a7,0
ffffffffc020050e:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200512:	02000793          	li	a5,32
ffffffffc0200516:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc020051a:	00006517          	auipc	a0,0x6
ffffffffc020051e:	80e50513          	addi	a0,a0,-2034 # ffffffffc0205d28 <etext+0x2b4>
    ticks = 0;
ffffffffc0200522:	000a5797          	auipc	a5,0xa5
ffffffffc0200526:	a407bb23          	sd	zero,-1450(a5) # ffffffffc02a4f78 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020052a:	b1ad                	j	ffffffffc0200194 <cprintf>

ffffffffc020052c <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020052c:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200530:	000a5797          	auipc	a5,0xa5
ffffffffc0200534:	a407b783          	ld	a5,-1472(a5) # ffffffffc02a4f70 <timebase>
ffffffffc0200538:	4581                	li	a1,0
ffffffffc020053a:	4601                	li	a2,0
ffffffffc020053c:	953e                	add	a0,a0,a5
ffffffffc020053e:	4881                	li	a7,0
ffffffffc0200540:	00000073          	ecall
ffffffffc0200544:	8082                	ret

ffffffffc0200546 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200546:	8082                	ret

ffffffffc0200548 <cons_putc>:
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0200548:	100027f3          	csrr	a5,sstatus
ffffffffc020054c:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc020054e:	0ff57513          	zext.b	a0,a0
ffffffffc0200552:	e799                	bnez	a5,ffffffffc0200560 <cons_putc+0x18>
ffffffffc0200554:	4581                	li	a1,0
ffffffffc0200556:	4601                	li	a2,0
ffffffffc0200558:	4885                	li	a7,1
ffffffffc020055a:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc020055e:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200560:	1101                	addi	sp,sp,-32
ffffffffc0200562:	ec06                	sd	ra,24(sp)
ffffffffc0200564:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0200566:	39e000ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc020056a:	6522                	ld	a0,8(sp)
ffffffffc020056c:	4581                	li	a1,0
ffffffffc020056e:	4601                	li	a2,0
ffffffffc0200570:	4885                	li	a7,1
ffffffffc0200572:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200576:	60e2                	ld	ra,24(sp)
ffffffffc0200578:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc020057a:	a651                	j	ffffffffc02008fe <intr_enable>

ffffffffc020057c <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020057c:	100027f3          	csrr	a5,sstatus
ffffffffc0200580:	8b89                	andi	a5,a5,2
ffffffffc0200582:	eb89                	bnez	a5,ffffffffc0200594 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc0200584:	4501                	li	a0,0
ffffffffc0200586:	4581                	li	a1,0
ffffffffc0200588:	4601                	li	a2,0
ffffffffc020058a:	4889                	li	a7,2
ffffffffc020058c:	00000073          	ecall
ffffffffc0200590:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc0200592:	8082                	ret
int cons_getc(void) {
ffffffffc0200594:	1101                	addi	sp,sp,-32
ffffffffc0200596:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0200598:	36c000ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc020059c:	4501                	li	a0,0
ffffffffc020059e:	4581                	li	a1,0
ffffffffc02005a0:	4601                	li	a2,0
ffffffffc02005a2:	4889                	li	a7,2
ffffffffc02005a4:	00000073          	ecall
ffffffffc02005a8:	2501                	sext.w	a0,a0
ffffffffc02005aa:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005ac:	352000ef          	jal	ffffffffc02008fe <intr_enable>
}
ffffffffc02005b0:	60e2                	ld	ra,24(sp)
ffffffffc02005b2:	6522                	ld	a0,8(sp)
ffffffffc02005b4:	6105                	addi	sp,sp,32
ffffffffc02005b6:	8082                	ret

ffffffffc02005b8 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005b8:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc02005ba:	00005517          	auipc	a0,0x5
ffffffffc02005be:	78e50513          	addi	a0,a0,1934 # ffffffffc0205d48 <etext+0x2d4>
void dtb_init(void) {
ffffffffc02005c2:	f406                	sd	ra,40(sp)
ffffffffc02005c4:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc02005c6:	bcfff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005ca:	0000b597          	auipc	a1,0xb
ffffffffc02005ce:	a365b583          	ld	a1,-1482(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc02005d2:	00005517          	auipc	a0,0x5
ffffffffc02005d6:	78650513          	addi	a0,a0,1926 # ffffffffc0205d58 <etext+0x2e4>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005da:	0000b417          	auipc	s0,0xb
ffffffffc02005de:	a2e40413          	addi	s0,s0,-1490 # ffffffffc020b008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005e2:	bb3ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005e6:	600c                	ld	a1,0(s0)
ffffffffc02005e8:	00005517          	auipc	a0,0x5
ffffffffc02005ec:	78050513          	addi	a0,a0,1920 # ffffffffc0205d68 <etext+0x2f4>
ffffffffc02005f0:	ba5ff0ef          	jal	ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc02005f4:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc02005f6:	00005517          	auipc	a0,0x5
ffffffffc02005fa:	78a50513          	addi	a0,a0,1930 # ffffffffc0205d80 <etext+0x30c>
    if (boot_dtb == 0) {
ffffffffc02005fe:	10070163          	beqz	a4,ffffffffc0200700 <dtb_init+0x148>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200602:	57f5                	li	a5,-3
ffffffffc0200604:	07fa                	slli	a5,a5,0x1e
ffffffffc0200606:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200608:	431c                	lw	a5,0(a4)
    if (magic != 0xd00dfeed) {
ffffffffc020060a:	d00e06b7          	lui	a3,0xd00e0
ffffffffc020060e:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfe3af05>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200612:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200616:	0187961b          	slliw	a2,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020061a:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020061e:	0ff5f593          	zext.b	a1,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200622:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200626:	05c2                	slli	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200628:	8e49                	or	a2,a2,a0
ffffffffc020062a:	0ff7f793          	zext.b	a5,a5
ffffffffc020062e:	8dd1                	or	a1,a1,a2
ffffffffc0200630:	07a2                	slli	a5,a5,0x8
ffffffffc0200632:	8ddd                	or	a1,a1,a5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200634:	00ff0837          	lui	a6,0xff0
    if (magic != 0xd00dfeed) {
ffffffffc0200638:	0cd59863          	bne	a1,a3,ffffffffc0200708 <dtb_init+0x150>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc020063c:	4710                	lw	a2,8(a4)
ffffffffc020063e:	4754                	lw	a3,12(a4)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200640:	e84a                	sd	s2,16(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200642:	0086541b          	srliw	s0,a2,0x8
ffffffffc0200646:	0086d79b          	srliw	a5,a3,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020064a:	01865e1b          	srliw	t3,a2,0x18
ffffffffc020064e:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200652:	0186151b          	slliw	a0,a2,0x18
ffffffffc0200656:	0186959b          	slliw	a1,a3,0x18
ffffffffc020065a:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020065e:	0106561b          	srliw	a2,a2,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200662:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200666:	0106d69b          	srliw	a3,a3,0x10
ffffffffc020066a:	01c56533          	or	a0,a0,t3
ffffffffc020066e:	0115e5b3          	or	a1,a1,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200672:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200676:	0ff67613          	zext.b	a2,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067a:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020067e:	0ff6f693          	zext.b	a3,a3
ffffffffc0200682:	8c49                	or	s0,s0,a0
ffffffffc0200684:	0622                	slli	a2,a2,0x8
ffffffffc0200686:	8fcd                	or	a5,a5,a1
ffffffffc0200688:	06a2                	slli	a3,a3,0x8
ffffffffc020068a:	8c51                	or	s0,s0,a2
ffffffffc020068c:	8fd5                	or	a5,a5,a3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020068e:	1402                	slli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200690:	1782                	slli	a5,a5,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200692:	9001                	srli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200694:	9381                	srli	a5,a5,0x20
ffffffffc0200696:	ec26                	sd	s1,24(sp)
    int in_memory_node = 0;
ffffffffc0200698:	4301                	li	t1,0
        switch (token) {
ffffffffc020069a:	488d                	li	a7,3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020069c:	943a                	add	s0,s0,a4
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020069e:	00e78933          	add	s2,a5,a4
        switch (token) {
ffffffffc02006a2:	4e05                	li	t3,1
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006a4:	4018                	lw	a4,0(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006a6:	0087579b          	srliw	a5,a4,0x8
ffffffffc02006aa:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ae:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006b2:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b6:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ba:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006be:	8ed1                	or	a3,a3,a2
ffffffffc02006c0:	0ff77713          	zext.b	a4,a4
ffffffffc02006c4:	8fd5                	or	a5,a5,a3
ffffffffc02006c6:	0722                	slli	a4,a4,0x8
ffffffffc02006c8:	8fd9                	or	a5,a5,a4
        switch (token) {
ffffffffc02006ca:	05178763          	beq	a5,a7,ffffffffc0200718 <dtb_init+0x160>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006ce:	0411                	addi	s0,s0,4
        switch (token) {
ffffffffc02006d0:	00f8e963          	bltu	a7,a5,ffffffffc02006e2 <dtb_init+0x12a>
ffffffffc02006d4:	07c78d63          	beq	a5,t3,ffffffffc020074e <dtb_init+0x196>
ffffffffc02006d8:	4709                	li	a4,2
ffffffffc02006da:	00e79763          	bne	a5,a4,ffffffffc02006e8 <dtb_init+0x130>
ffffffffc02006de:	4301                	li	t1,0
ffffffffc02006e0:	b7d1                	j	ffffffffc02006a4 <dtb_init+0xec>
ffffffffc02006e2:	4711                	li	a4,4
ffffffffc02006e4:	fce780e3          	beq	a5,a4,ffffffffc02006a4 <dtb_init+0xec>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc02006e8:	00005517          	auipc	a0,0x5
ffffffffc02006ec:	76050513          	addi	a0,a0,1888 # ffffffffc0205e48 <etext+0x3d4>
ffffffffc02006f0:	aa5ff0ef          	jal	ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02006f4:	64e2                	ld	s1,24(sp)
ffffffffc02006f6:	6942                	ld	s2,16(sp)
ffffffffc02006f8:	00005517          	auipc	a0,0x5
ffffffffc02006fc:	78850513          	addi	a0,a0,1928 # ffffffffc0205e80 <etext+0x40c>
}
ffffffffc0200700:	7402                	ld	s0,32(sp)
ffffffffc0200702:	70a2                	ld	ra,40(sp)
ffffffffc0200704:	6145                	addi	sp,sp,48
    cprintf("DTB init completed\n");
ffffffffc0200706:	b479                	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200708:	7402                	ld	s0,32(sp)
ffffffffc020070a:	70a2                	ld	ra,40(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc020070c:	00005517          	auipc	a0,0x5
ffffffffc0200710:	69450513          	addi	a0,a0,1684 # ffffffffc0205da0 <etext+0x32c>
}
ffffffffc0200714:	6145                	addi	sp,sp,48
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200716:	bcbd                	j	ffffffffc0200194 <cprintf>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200718:	4058                	lw	a4,4(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020071a:	0087579b          	srliw	a5,a4,0x8
ffffffffc020071e:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200722:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200726:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020072a:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020072e:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200732:	8ed1                	or	a3,a3,a2
ffffffffc0200734:	0ff77713          	zext.b	a4,a4
ffffffffc0200738:	8fd5                	or	a5,a5,a3
ffffffffc020073a:	0722                	slli	a4,a4,0x8
ffffffffc020073c:	8fd9                	or	a5,a5,a4
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020073e:	04031463          	bnez	t1,ffffffffc0200786 <dtb_init+0x1ce>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200742:	1782                	slli	a5,a5,0x20
ffffffffc0200744:	9381                	srli	a5,a5,0x20
ffffffffc0200746:	043d                	addi	s0,s0,15
ffffffffc0200748:	943e                	add	s0,s0,a5
ffffffffc020074a:	9871                	andi	s0,s0,-4
                break;
ffffffffc020074c:	bfa1                	j	ffffffffc02006a4 <dtb_init+0xec>
                int name_len = strlen(name);
ffffffffc020074e:	8522                	mv	a0,s0
ffffffffc0200750:	e01a                	sd	t1,0(sp)
ffffffffc0200752:	244050ef          	jal	ffffffffc0205996 <strlen>
ffffffffc0200756:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200758:	4619                	li	a2,6
ffffffffc020075a:	8522                	mv	a0,s0
ffffffffc020075c:	00005597          	auipc	a1,0x5
ffffffffc0200760:	66c58593          	addi	a1,a1,1644 # ffffffffc0205dc8 <etext+0x354>
ffffffffc0200764:	2ac050ef          	jal	ffffffffc0205a10 <strncmp>
ffffffffc0200768:	6302                	ld	t1,0(sp)
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc020076a:	0411                	addi	s0,s0,4
ffffffffc020076c:	0004879b          	sext.w	a5,s1
ffffffffc0200770:	943e                	add	s0,s0,a5
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200772:	00153513          	seqz	a0,a0
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200776:	9871                	andi	s0,s0,-4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200778:	00a36333          	or	t1,t1,a0
                break;
ffffffffc020077c:	00ff0837          	lui	a6,0xff0
ffffffffc0200780:	488d                	li	a7,3
ffffffffc0200782:	4e05                	li	t3,1
ffffffffc0200784:	b705                	j	ffffffffc02006a4 <dtb_init+0xec>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200786:	4418                	lw	a4,8(s0)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200788:	00005597          	auipc	a1,0x5
ffffffffc020078c:	64858593          	addi	a1,a1,1608 # ffffffffc0205dd0 <etext+0x35c>
ffffffffc0200790:	e43e                	sd	a5,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200792:	0087551b          	srliw	a0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200796:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020079a:	0187169b          	slliw	a3,a4,0x18
ffffffffc020079e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007a2:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007a6:	01057533          	and	a0,a0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007aa:	8ed1                	or	a3,a3,a2
ffffffffc02007ac:	0ff77713          	zext.b	a4,a4
ffffffffc02007b0:	0722                	slli	a4,a4,0x8
ffffffffc02007b2:	8d55                	or	a0,a0,a3
ffffffffc02007b4:	8d59                	or	a0,a0,a4
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc02007b6:	1502                	slli	a0,a0,0x20
ffffffffc02007b8:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02007ba:	954a                	add	a0,a0,s2
ffffffffc02007bc:	e01a                	sd	t1,0(sp)
ffffffffc02007be:	21e050ef          	jal	ffffffffc02059dc <strcmp>
ffffffffc02007c2:	67a2                	ld	a5,8(sp)
ffffffffc02007c4:	473d                	li	a4,15
ffffffffc02007c6:	6302                	ld	t1,0(sp)
ffffffffc02007c8:	00ff0837          	lui	a6,0xff0
ffffffffc02007cc:	488d                	li	a7,3
ffffffffc02007ce:	4e05                	li	t3,1
ffffffffc02007d0:	f6f779e3          	bgeu	a4,a5,ffffffffc0200742 <dtb_init+0x18a>
ffffffffc02007d4:	f53d                	bnez	a0,ffffffffc0200742 <dtb_init+0x18a>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02007d6:	00c43683          	ld	a3,12(s0)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02007da:	01443703          	ld	a4,20(s0)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02007de:	00005517          	auipc	a0,0x5
ffffffffc02007e2:	5fa50513          	addi	a0,a0,1530 # ffffffffc0205dd8 <etext+0x364>
           fdt32_to_cpu(x >> 32);
ffffffffc02007e6:	4206d793          	srai	a5,a3,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007ea:	0087d31b          	srliw	t1,a5,0x8
ffffffffc02007ee:	00871f93          	slli	t6,a4,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02007f2:	42075893          	srai	a7,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007f6:	0187df1b          	srliw	t5,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007fa:	0187959b          	slliw	a1,a5,0x18
ffffffffc02007fe:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200802:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200806:	420fd613          	srai	a2,t6,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020080a:	0188de9b          	srliw	t4,a7,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020080e:	01037333          	and	t1,t1,a6
ffffffffc0200812:	01889e1b          	slliw	t3,a7,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200816:	01e5e5b3          	or	a1,a1,t5
ffffffffc020081a:	0ff7f793          	zext.b	a5,a5
ffffffffc020081e:	01de6e33          	or	t3,t3,t4
ffffffffc0200822:	0065e5b3          	or	a1,a1,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200826:	01067633          	and	a2,a2,a6
ffffffffc020082a:	0086d31b          	srliw	t1,a3,0x8
ffffffffc020082e:	0087541b          	srliw	s0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200832:	07a2                	slli	a5,a5,0x8
ffffffffc0200834:	0108d89b          	srliw	a7,a7,0x10
ffffffffc0200838:	0186df1b          	srliw	t5,a3,0x18
ffffffffc020083c:	01875e9b          	srliw	t4,a4,0x18
ffffffffc0200840:	8ddd                	or	a1,a1,a5
ffffffffc0200842:	01c66633          	or	a2,a2,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200846:	0186979b          	slliw	a5,a3,0x18
ffffffffc020084a:	01871e1b          	slliw	t3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020084e:	0ff8f893          	zext.b	a7,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200852:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200856:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020085a:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020085e:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200862:	01037333          	and	t1,t1,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200866:	08a2                	slli	a7,a7,0x8
ffffffffc0200868:	01e7e7b3          	or	a5,a5,t5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020086c:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200870:	0ff6f693          	zext.b	a3,a3
ffffffffc0200874:	01de6833          	or	a6,t3,t4
ffffffffc0200878:	0ff77713          	zext.b	a4,a4
ffffffffc020087c:	01166633          	or	a2,a2,a7
ffffffffc0200880:	0067e7b3          	or	a5,a5,t1
ffffffffc0200884:	06a2                	slli	a3,a3,0x8
ffffffffc0200886:	01046433          	or	s0,s0,a6
ffffffffc020088a:	0722                	slli	a4,a4,0x8
ffffffffc020088c:	8fd5                	or	a5,a5,a3
ffffffffc020088e:	8c59                	or	s0,s0,a4
           fdt32_to_cpu(x >> 32);
ffffffffc0200890:	1582                	slli	a1,a1,0x20
ffffffffc0200892:	1602                	slli	a2,a2,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200894:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200896:	9201                	srli	a2,a2,0x20
ffffffffc0200898:	9181                	srli	a1,a1,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020089a:	1402                	slli	s0,s0,0x20
ffffffffc020089c:	00b7e4b3          	or	s1,a5,a1
ffffffffc02008a0:	8c51                	or	s0,s0,a2
        cprintf("Physical Memory from DTB:\n");
ffffffffc02008a2:	8f3ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc02008a6:	85a6                	mv	a1,s1
ffffffffc02008a8:	00005517          	auipc	a0,0x5
ffffffffc02008ac:	55050513          	addi	a0,a0,1360 # ffffffffc0205df8 <etext+0x384>
ffffffffc02008b0:	8e5ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc02008b4:	01445613          	srli	a2,s0,0x14
ffffffffc02008b8:	85a2                	mv	a1,s0
ffffffffc02008ba:	00005517          	auipc	a0,0x5
ffffffffc02008be:	55650513          	addi	a0,a0,1366 # ffffffffc0205e10 <etext+0x39c>
ffffffffc02008c2:	8d3ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02008c6:	009405b3          	add	a1,s0,s1
ffffffffc02008ca:	15fd                	addi	a1,a1,-1
ffffffffc02008cc:	00005517          	auipc	a0,0x5
ffffffffc02008d0:	56450513          	addi	a0,a0,1380 # ffffffffc0205e30 <etext+0x3bc>
ffffffffc02008d4:	8c1ff0ef          	jal	ffffffffc0200194 <cprintf>
        memory_base = mem_base;
ffffffffc02008d8:	000a4797          	auipc	a5,0xa4
ffffffffc02008dc:	6a97b823          	sd	s1,1712(a5) # ffffffffc02a4f88 <memory_base>
        memory_size = mem_size;
ffffffffc02008e0:	000a4797          	auipc	a5,0xa4
ffffffffc02008e4:	6a87b023          	sd	s0,1696(a5) # ffffffffc02a4f80 <memory_size>
ffffffffc02008e8:	b531                	j	ffffffffc02006f4 <dtb_init+0x13c>

ffffffffc02008ea <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02008ea:	000a4517          	auipc	a0,0xa4
ffffffffc02008ee:	69e53503          	ld	a0,1694(a0) # ffffffffc02a4f88 <memory_base>
ffffffffc02008f2:	8082                	ret

ffffffffc02008f4 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02008f4:	000a4517          	auipc	a0,0xa4
ffffffffc02008f8:	68c53503          	ld	a0,1676(a0) # ffffffffc02a4f80 <memory_size>
ffffffffc02008fc:	8082                	ret

ffffffffc02008fe <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02008fe:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200902:	8082                	ret

ffffffffc0200904 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200904:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200908:	8082                	ret

ffffffffc020090a <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc020090a:	8082                	ret

ffffffffc020090c <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc020090c:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200910:	00000797          	auipc	a5,0x0
ffffffffc0200914:	51878793          	addi	a5,a5,1304 # ffffffffc0200e28 <__alltraps>
ffffffffc0200918:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc020091c:	000407b7          	lui	a5,0x40
ffffffffc0200920:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc0200924:	8082                	ret

ffffffffc0200926 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200926:	610c                	ld	a1,0(a0)
{
ffffffffc0200928:	1141                	addi	sp,sp,-16
ffffffffc020092a:	e022                	sd	s0,0(sp)
ffffffffc020092c:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020092e:	00005517          	auipc	a0,0x5
ffffffffc0200932:	56a50513          	addi	a0,a0,1386 # ffffffffc0205e98 <etext+0x424>
{
ffffffffc0200936:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200938:	85dff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020093c:	640c                	ld	a1,8(s0)
ffffffffc020093e:	00005517          	auipc	a0,0x5
ffffffffc0200942:	57250513          	addi	a0,a0,1394 # ffffffffc0205eb0 <etext+0x43c>
ffffffffc0200946:	84fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020094a:	680c                	ld	a1,16(s0)
ffffffffc020094c:	00005517          	auipc	a0,0x5
ffffffffc0200950:	57c50513          	addi	a0,a0,1404 # ffffffffc0205ec8 <etext+0x454>
ffffffffc0200954:	841ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200958:	6c0c                	ld	a1,24(s0)
ffffffffc020095a:	00005517          	auipc	a0,0x5
ffffffffc020095e:	58650513          	addi	a0,a0,1414 # ffffffffc0205ee0 <etext+0x46c>
ffffffffc0200962:	833ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200966:	700c                	ld	a1,32(s0)
ffffffffc0200968:	00005517          	auipc	a0,0x5
ffffffffc020096c:	59050513          	addi	a0,a0,1424 # ffffffffc0205ef8 <etext+0x484>
ffffffffc0200970:	825ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200974:	740c                	ld	a1,40(s0)
ffffffffc0200976:	00005517          	auipc	a0,0x5
ffffffffc020097a:	59a50513          	addi	a0,a0,1434 # ffffffffc0205f10 <etext+0x49c>
ffffffffc020097e:	817ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200982:	780c                	ld	a1,48(s0)
ffffffffc0200984:	00005517          	auipc	a0,0x5
ffffffffc0200988:	5a450513          	addi	a0,a0,1444 # ffffffffc0205f28 <etext+0x4b4>
ffffffffc020098c:	809ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200990:	7c0c                	ld	a1,56(s0)
ffffffffc0200992:	00005517          	auipc	a0,0x5
ffffffffc0200996:	5ae50513          	addi	a0,a0,1454 # ffffffffc0205f40 <etext+0x4cc>
ffffffffc020099a:	ffaff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc020099e:	602c                	ld	a1,64(s0)
ffffffffc02009a0:	00005517          	auipc	a0,0x5
ffffffffc02009a4:	5b850513          	addi	a0,a0,1464 # ffffffffc0205f58 <etext+0x4e4>
ffffffffc02009a8:	fecff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02009ac:	642c                	ld	a1,72(s0)
ffffffffc02009ae:	00005517          	auipc	a0,0x5
ffffffffc02009b2:	5c250513          	addi	a0,a0,1474 # ffffffffc0205f70 <etext+0x4fc>
ffffffffc02009b6:	fdeff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02009ba:	682c                	ld	a1,80(s0)
ffffffffc02009bc:	00005517          	auipc	a0,0x5
ffffffffc02009c0:	5cc50513          	addi	a0,a0,1484 # ffffffffc0205f88 <etext+0x514>
ffffffffc02009c4:	fd0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02009c8:	6c2c                	ld	a1,88(s0)
ffffffffc02009ca:	00005517          	auipc	a0,0x5
ffffffffc02009ce:	5d650513          	addi	a0,a0,1494 # ffffffffc0205fa0 <etext+0x52c>
ffffffffc02009d2:	fc2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc02009d6:	702c                	ld	a1,96(s0)
ffffffffc02009d8:	00005517          	auipc	a0,0x5
ffffffffc02009dc:	5e050513          	addi	a0,a0,1504 # ffffffffc0205fb8 <etext+0x544>
ffffffffc02009e0:	fb4ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc02009e4:	742c                	ld	a1,104(s0)
ffffffffc02009e6:	00005517          	auipc	a0,0x5
ffffffffc02009ea:	5ea50513          	addi	a0,a0,1514 # ffffffffc0205fd0 <etext+0x55c>
ffffffffc02009ee:	fa6ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc02009f2:	782c                	ld	a1,112(s0)
ffffffffc02009f4:	00005517          	auipc	a0,0x5
ffffffffc02009f8:	5f450513          	addi	a0,a0,1524 # ffffffffc0205fe8 <etext+0x574>
ffffffffc02009fc:	f98ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200a00:	7c2c                	ld	a1,120(s0)
ffffffffc0200a02:	00005517          	auipc	a0,0x5
ffffffffc0200a06:	5fe50513          	addi	a0,a0,1534 # ffffffffc0206000 <etext+0x58c>
ffffffffc0200a0a:	f8aff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200a0e:	604c                	ld	a1,128(s0)
ffffffffc0200a10:	00005517          	auipc	a0,0x5
ffffffffc0200a14:	60850513          	addi	a0,a0,1544 # ffffffffc0206018 <etext+0x5a4>
ffffffffc0200a18:	f7cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200a1c:	644c                	ld	a1,136(s0)
ffffffffc0200a1e:	00005517          	auipc	a0,0x5
ffffffffc0200a22:	61250513          	addi	a0,a0,1554 # ffffffffc0206030 <etext+0x5bc>
ffffffffc0200a26:	f6eff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200a2a:	684c                	ld	a1,144(s0)
ffffffffc0200a2c:	00005517          	auipc	a0,0x5
ffffffffc0200a30:	61c50513          	addi	a0,a0,1564 # ffffffffc0206048 <etext+0x5d4>
ffffffffc0200a34:	f60ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200a38:	6c4c                	ld	a1,152(s0)
ffffffffc0200a3a:	00005517          	auipc	a0,0x5
ffffffffc0200a3e:	62650513          	addi	a0,a0,1574 # ffffffffc0206060 <etext+0x5ec>
ffffffffc0200a42:	f52ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200a46:	704c                	ld	a1,160(s0)
ffffffffc0200a48:	00005517          	auipc	a0,0x5
ffffffffc0200a4c:	63050513          	addi	a0,a0,1584 # ffffffffc0206078 <etext+0x604>
ffffffffc0200a50:	f44ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200a54:	744c                	ld	a1,168(s0)
ffffffffc0200a56:	00005517          	auipc	a0,0x5
ffffffffc0200a5a:	63a50513          	addi	a0,a0,1594 # ffffffffc0206090 <etext+0x61c>
ffffffffc0200a5e:	f36ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200a62:	784c                	ld	a1,176(s0)
ffffffffc0200a64:	00005517          	auipc	a0,0x5
ffffffffc0200a68:	64450513          	addi	a0,a0,1604 # ffffffffc02060a8 <etext+0x634>
ffffffffc0200a6c:	f28ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200a70:	7c4c                	ld	a1,184(s0)
ffffffffc0200a72:	00005517          	auipc	a0,0x5
ffffffffc0200a76:	64e50513          	addi	a0,a0,1614 # ffffffffc02060c0 <etext+0x64c>
ffffffffc0200a7a:	f1aff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200a7e:	606c                	ld	a1,192(s0)
ffffffffc0200a80:	00005517          	auipc	a0,0x5
ffffffffc0200a84:	65850513          	addi	a0,a0,1624 # ffffffffc02060d8 <etext+0x664>
ffffffffc0200a88:	f0cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200a8c:	646c                	ld	a1,200(s0)
ffffffffc0200a8e:	00005517          	auipc	a0,0x5
ffffffffc0200a92:	66250513          	addi	a0,a0,1634 # ffffffffc02060f0 <etext+0x67c>
ffffffffc0200a96:	efeff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200a9a:	686c                	ld	a1,208(s0)
ffffffffc0200a9c:	00005517          	auipc	a0,0x5
ffffffffc0200aa0:	66c50513          	addi	a0,a0,1644 # ffffffffc0206108 <etext+0x694>
ffffffffc0200aa4:	ef0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200aa8:	6c6c                	ld	a1,216(s0)
ffffffffc0200aaa:	00005517          	auipc	a0,0x5
ffffffffc0200aae:	67650513          	addi	a0,a0,1654 # ffffffffc0206120 <etext+0x6ac>
ffffffffc0200ab2:	ee2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200ab6:	706c                	ld	a1,224(s0)
ffffffffc0200ab8:	00005517          	auipc	a0,0x5
ffffffffc0200abc:	68050513          	addi	a0,a0,1664 # ffffffffc0206138 <etext+0x6c4>
ffffffffc0200ac0:	ed4ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200ac4:	746c                	ld	a1,232(s0)
ffffffffc0200ac6:	00005517          	auipc	a0,0x5
ffffffffc0200aca:	68a50513          	addi	a0,a0,1674 # ffffffffc0206150 <etext+0x6dc>
ffffffffc0200ace:	ec6ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200ad2:	786c                	ld	a1,240(s0)
ffffffffc0200ad4:	00005517          	auipc	a0,0x5
ffffffffc0200ad8:	69450513          	addi	a0,a0,1684 # ffffffffc0206168 <etext+0x6f4>
ffffffffc0200adc:	eb8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ae0:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200ae2:	6402                	ld	s0,0(sp)
ffffffffc0200ae4:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ae6:	00005517          	auipc	a0,0x5
ffffffffc0200aea:	69a50513          	addi	a0,a0,1690 # ffffffffc0206180 <etext+0x70c>
}
ffffffffc0200aee:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200af0:	ea4ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200af4 <print_trapframe>:
{
ffffffffc0200af4:	1141                	addi	sp,sp,-16
ffffffffc0200af6:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200af8:	85aa                	mv	a1,a0
{
ffffffffc0200afa:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200afc:	00005517          	auipc	a0,0x5
ffffffffc0200b00:	69c50513          	addi	a0,a0,1692 # ffffffffc0206198 <etext+0x724>
{
ffffffffc0200b04:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b06:	e8eff0ef          	jal	ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200b0a:	8522                	mv	a0,s0
ffffffffc0200b0c:	e1bff0ef          	jal	ffffffffc0200926 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200b10:	10043583          	ld	a1,256(s0)
ffffffffc0200b14:	00005517          	auipc	a0,0x5
ffffffffc0200b18:	69c50513          	addi	a0,a0,1692 # ffffffffc02061b0 <etext+0x73c>
ffffffffc0200b1c:	e78ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200b20:	10843583          	ld	a1,264(s0)
ffffffffc0200b24:	00005517          	auipc	a0,0x5
ffffffffc0200b28:	6a450513          	addi	a0,a0,1700 # ffffffffc02061c8 <etext+0x754>
ffffffffc0200b2c:	e68ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200b30:	11043583          	ld	a1,272(s0)
ffffffffc0200b34:	00005517          	auipc	a0,0x5
ffffffffc0200b38:	6ac50513          	addi	a0,a0,1708 # ffffffffc02061e0 <etext+0x76c>
ffffffffc0200b3c:	e58ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b40:	11843583          	ld	a1,280(s0)
}
ffffffffc0200b44:	6402                	ld	s0,0(sp)
ffffffffc0200b46:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b48:	00005517          	auipc	a0,0x5
ffffffffc0200b4c:	6a850513          	addi	a0,a0,1704 # ffffffffc02061f0 <etext+0x77c>
}
ffffffffc0200b50:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b52:	e42ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200b56 <interrupt_handler>:
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause)
ffffffffc0200b56:	11853783          	ld	a5,280(a0)
ffffffffc0200b5a:	472d                	li	a4,11
ffffffffc0200b5c:	0786                	slli	a5,a5,0x1
ffffffffc0200b5e:	8385                	srli	a5,a5,0x1
ffffffffc0200b60:	08f76e63          	bltu	a4,a5,ffffffffc0200bfc <interrupt_handler+0xa6>
ffffffffc0200b64:	00007717          	auipc	a4,0x7
ffffffffc0200b68:	cfc70713          	addi	a4,a4,-772 # ffffffffc0207860 <commands+0x48>
ffffffffc0200b6c:	078a                	slli	a5,a5,0x2
ffffffffc0200b6e:	97ba                	add	a5,a5,a4
ffffffffc0200b70:	439c                	lw	a5,0(a5)
ffffffffc0200b72:	97ba                	add	a5,a5,a4
ffffffffc0200b74:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200b76:	00005517          	auipc	a0,0x5
ffffffffc0200b7a:	6f250513          	addi	a0,a0,1778 # ffffffffc0206268 <etext+0x7f4>
ffffffffc0200b7e:	e16ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200b82:	00005517          	auipc	a0,0x5
ffffffffc0200b86:	6c650513          	addi	a0,a0,1734 # ffffffffc0206248 <etext+0x7d4>
ffffffffc0200b8a:	e0aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200b8e:	00005517          	auipc	a0,0x5
ffffffffc0200b92:	67a50513          	addi	a0,a0,1658 # ffffffffc0206208 <etext+0x794>
ffffffffc0200b96:	dfeff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200b9a:	00005517          	auipc	a0,0x5
ffffffffc0200b9e:	68e50513          	addi	a0,a0,1678 # ffffffffc0206228 <etext+0x7b4>
ffffffffc0200ba2:	df2ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200ba6:	1141                	addi	sp,sp,-16
ffffffffc0200ba8:	e406                	sd	ra,8(sp)
        /* 时间片轮转： 
        *(1) 设置下一次时钟中断（clock_set_next_event）
        *(2) ticks 计数器自增
        *(3) 每 TICK_NUM 次中断（如 100 次），进行判断当前是否有进程正在运行，如果有则标记该进程需要被重新调度（current->need_resched）
        */
        clock_set_next_event();
ffffffffc0200baa:	983ff0ef          	jal	ffffffffc020052c <clock_set_next_event>
        if (++ticks % TICK_NUM == 0) {
ffffffffc0200bae:	000a4697          	auipc	a3,0xa4
ffffffffc0200bb2:	3ca6b683          	ld	a3,970(a3) # ffffffffc02a4f78 <ticks>
ffffffffc0200bb6:	28f5c737          	lui	a4,0x28f5c
ffffffffc0200bba:	28f70713          	addi	a4,a4,655 # 28f5c28f <_binary_obj___user_exit_out_size+0x28f520cf>
ffffffffc0200bbe:	5c28f7b7          	lui	a5,0x5c28f
ffffffffc0200bc2:	5c378793          	addi	a5,a5,1475 # 5c28f5c3 <_binary_obj___user_exit_out_size+0x5c285403>
ffffffffc0200bc6:	0685                	addi	a3,a3,1
ffffffffc0200bc8:	1702                	slli	a4,a4,0x20
ffffffffc0200bca:	973e                	add	a4,a4,a5
ffffffffc0200bcc:	0026d793          	srli	a5,a3,0x2
ffffffffc0200bd0:	02e7b7b3          	mulhu	a5,a5,a4
ffffffffc0200bd4:	06400593          	li	a1,100
ffffffffc0200bd8:	000a4717          	auipc	a4,0xa4
ffffffffc0200bdc:	3ad73023          	sd	a3,928(a4) # ffffffffc02a4f78 <ticks>
ffffffffc0200be0:	8389                	srli	a5,a5,0x2
ffffffffc0200be2:	02b787b3          	mul	a5,a5,a1
ffffffffc0200be6:	00f68c63          	beq	a3,a5,ffffffffc0200bfe <interrupt_handler+0xa8>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200bea:	60a2                	ld	ra,8(sp)
ffffffffc0200bec:	0141                	addi	sp,sp,16
ffffffffc0200bee:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200bf0:	00005517          	auipc	a0,0x5
ffffffffc0200bf4:	6a850513          	addi	a0,a0,1704 # ffffffffc0206298 <etext+0x824>
ffffffffc0200bf8:	d9cff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200bfc:	bde5                	j	ffffffffc0200af4 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200bfe:	00005517          	auipc	a0,0x5
ffffffffc0200c02:	68a50513          	addi	a0,a0,1674 # ffffffffc0206288 <etext+0x814>
ffffffffc0200c06:	d8eff0ef          	jal	ffffffffc0200194 <cprintf>
            if (current) {
ffffffffc0200c0a:	000a4797          	auipc	a5,0xa4
ffffffffc0200c0e:	3c67b783          	ld	a5,966(a5) # ffffffffc02a4fd0 <current>
ffffffffc0200c12:	dfe1                	beqz	a5,ffffffffc0200bea <interrupt_handler+0x94>
                current->need_resched = 1;
ffffffffc0200c14:	4705                	li	a4,1
ffffffffc0200c16:	ef98                	sd	a4,24(a5)
ffffffffc0200c18:	bfc9                	j	ffffffffc0200bea <interrupt_handler+0x94>

ffffffffc0200c1a <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200c1a:	11853703          	ld	a4,280(a0)
ffffffffc0200c1e:	47bd                	li	a5,15
ffffffffc0200c20:	18e7e163          	bltu	a5,a4,ffffffffc0200da2 <exception_handler+0x188>
ffffffffc0200c24:	00007697          	auipc	a3,0x7
ffffffffc0200c28:	c6c68693          	addi	a3,a3,-916 # ffffffffc0207890 <commands+0x78>
ffffffffc0200c2c:	00271793          	slli	a5,a4,0x2
ffffffffc0200c30:	97b6                	add	a5,a5,a3
ffffffffc0200c32:	439c                	lw	a5,0(a5)
{
ffffffffc0200c34:	1101                	addi	sp,sp,-32
ffffffffc0200c36:	ec06                	sd	ra,24(sp)
    switch (tf->cause)
ffffffffc0200c38:	97b6                	add	a5,a5,a3
ffffffffc0200c3a:	862a                	mv	a2,a0
ffffffffc0200c3c:	8782                	jr	a5
            do_exit(-E_KILLED);
        }
        break;
    case CAUSE_LOAD_PAGE_FAULT:
    case CAUSE_STORE_PAGE_FAULT:
        if (current != NULL && current->mm != NULL) {
ffffffffc0200c3e:	000a4797          	auipc	a5,0xa4
ffffffffc0200c42:	3927b783          	ld	a5,914(a5) # ffffffffc02a4fd0 <current>
ffffffffc0200c46:	cf81                	beqz	a5,ffffffffc0200c5e <exception_handler+0x44>
ffffffffc0200c48:	7788                	ld	a0,40(a5)
ffffffffc0200c4a:	c911                	beqz	a0,ffffffffc0200c5e <exception_handler+0x44>
            // 尝试 COW 处理
            ret = do_pgfault(current->mm, tf->cause == CAUSE_STORE_PAGE_FAULT ? 2 : 0, tf->tval);
ffffffffc0200c4c:	1745                	addi	a4,a4,-15
ffffffffc0200c4e:	11063603          	ld	a2,272(a2)
ffffffffc0200c52:	00173593          	seqz	a1,a4
ffffffffc0200c56:	0586                	slli	a1,a1,0x1
ffffffffc0200c58:	264030ef          	jal	ffffffffc0203ebc <do_pgfault>
            if (ret == 0) {
ffffffffc0200c5c:	c551                	beqz	a0,ffffffffc0200ce8 <exception_handler+0xce>
                // 成功处理,返回
                return;
            }
        }
        // COW 处理失败,终止进程
        cprintf("Page fault\n");
ffffffffc0200c5e:	00005517          	auipc	a0,0x5
ffffffffc0200c62:	7aa50513          	addi	a0,a0,1962 # ffffffffc0206408 <etext+0x994>
ffffffffc0200c66:	d2eff0ef          	jal	ffffffffc0200194 <cprintf>
        if (current != NULL) {
ffffffffc0200c6a:	000a4797          	auipc	a5,0xa4
ffffffffc0200c6e:	3667b783          	ld	a5,870(a5) # ffffffffc02a4fd0 <current>
ffffffffc0200c72:	cbbd                	beqz	a5,ffffffffc0200ce8 <exception_handler+0xce>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c74:	60e2                	ld	ra,24(sp)
            do_exit(-E_KILLED);
ffffffffc0200c76:	555d                	li	a0,-9
}
ffffffffc0200c78:	6105                	addi	sp,sp,32
            do_exit(-E_KILLED);
ffffffffc0200c7a:	28d0306f          	j	ffffffffc0204706 <do_exit>
ffffffffc0200c7e:	e42a                	sd	a0,8(sp)
        cprintf("Environment call from S-mode\n");
ffffffffc0200c80:	00005517          	auipc	a0,0x5
ffffffffc0200c84:	71050513          	addi	a0,a0,1808 # ffffffffc0206390 <etext+0x91c>
ffffffffc0200c88:	d0cff0ef          	jal	ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200c8c:	6622                	ld	a2,8(sp)
ffffffffc0200c8e:	10863783          	ld	a5,264(a2)
}
ffffffffc0200c92:	60e2                	ld	ra,24(sp)
        tf->epc += 4;
ffffffffc0200c94:	0791                	addi	a5,a5,4
ffffffffc0200c96:	10f63423          	sd	a5,264(a2)
}
ffffffffc0200c9a:	6105                	addi	sp,sp,32
        syscall();
ffffffffc0200c9c:	09d0406f          	j	ffffffffc0205538 <syscall>
}
ffffffffc0200ca0:	60e2                	ld	ra,24(sp)
        cprintf("Instruction address misaligned\n");
ffffffffc0200ca2:	00005517          	auipc	a0,0x5
ffffffffc0200ca6:	61650513          	addi	a0,a0,1558 # ffffffffc02062b8 <etext+0x844>
}
ffffffffc0200caa:	6105                	addi	sp,sp,32
        cprintf("Instruction address misaligned\n");
ffffffffc0200cac:	ce8ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cb0:	60e2                	ld	ra,24(sp)
        cprintf("Instruction access fault\n");
ffffffffc0200cb2:	00005517          	auipc	a0,0x5
ffffffffc0200cb6:	62650513          	addi	a0,a0,1574 # ffffffffc02062d8 <etext+0x864>
}
ffffffffc0200cba:	6105                	addi	sp,sp,32
        cprintf("Instruction access fault\n");
ffffffffc0200cbc:	cd8ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cc0:	60e2                	ld	ra,24(sp)
        cprintf("Illegal instruction\n");
ffffffffc0200cc2:	00005517          	auipc	a0,0x5
ffffffffc0200cc6:	63650513          	addi	a0,a0,1590 # ffffffffc02062f8 <etext+0x884>
}
ffffffffc0200cca:	6105                	addi	sp,sp,32
        cprintf("Illegal instruction\n");
ffffffffc0200ccc:	cc8ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200cd0:	e42a                	sd	a0,8(sp)
        cprintf("Breakpoint\n");
ffffffffc0200cd2:	00005517          	auipc	a0,0x5
ffffffffc0200cd6:	63e50513          	addi	a0,a0,1598 # ffffffffc0206310 <etext+0x89c>
ffffffffc0200cda:	cbaff0ef          	jal	ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200cde:	6622                	ld	a2,8(sp)
ffffffffc0200ce0:	47a9                	li	a5,10
ffffffffc0200ce2:	6658                	ld	a4,136(a2)
ffffffffc0200ce4:	08f70d63          	beq	a4,a5,ffffffffc0200d7e <exception_handler+0x164>
}
ffffffffc0200ce8:	60e2                	ld	ra,24(sp)
ffffffffc0200cea:	6105                	addi	sp,sp,32
ffffffffc0200cec:	8082                	ret
ffffffffc0200cee:	60e2                	ld	ra,24(sp)
        cprintf("Load address misaligned\n");
ffffffffc0200cf0:	00005517          	auipc	a0,0x5
ffffffffc0200cf4:	63050513          	addi	a0,a0,1584 # ffffffffc0206320 <etext+0x8ac>
}
ffffffffc0200cf8:	6105                	addi	sp,sp,32
        cprintf("Load address misaligned\n");
ffffffffc0200cfa:	c9aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Load access fault\n");
ffffffffc0200cfe:	00005517          	auipc	a0,0x5
ffffffffc0200d02:	64250513          	addi	a0,a0,1602 # ffffffffc0206340 <etext+0x8cc>
ffffffffc0200d06:	c8eff0ef          	jal	ffffffffc0200194 <cprintf>
        if (current != NULL) {
ffffffffc0200d0a:	000a4797          	auipc	a5,0xa4
ffffffffc0200d0e:	2c67b783          	ld	a5,710(a5) # ffffffffc02a4fd0 <current>
ffffffffc0200d12:	f3ad                	bnez	a5,ffffffffc0200c74 <exception_handler+0x5a>
ffffffffc0200d14:	bfd1                	j	ffffffffc0200ce8 <exception_handler+0xce>
}
ffffffffc0200d16:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO address misaligned\n");
ffffffffc0200d18:	00005517          	auipc	a0,0x5
ffffffffc0200d1c:	64050513          	addi	a0,a0,1600 # ffffffffc0206358 <etext+0x8e4>
}
ffffffffc0200d20:	6105                	addi	sp,sp,32
        cprintf("Store/AMO address misaligned\n");
ffffffffc0200d22:	c72ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Store/AMO access fault\n");
ffffffffc0200d26:	00005517          	auipc	a0,0x5
ffffffffc0200d2a:	65250513          	addi	a0,a0,1618 # ffffffffc0206378 <etext+0x904>
ffffffffc0200d2e:	c66ff0ef          	jal	ffffffffc0200194 <cprintf>
        if (current != NULL) {
ffffffffc0200d32:	000a4797          	auipc	a5,0xa4
ffffffffc0200d36:	29e7b783          	ld	a5,670(a5) # ffffffffc02a4fd0 <current>
ffffffffc0200d3a:	ff8d                	bnez	a5,ffffffffc0200c74 <exception_handler+0x5a>
ffffffffc0200d3c:	b775                	j	ffffffffc0200ce8 <exception_handler+0xce>
        cprintf("Instruction page fault\n");
ffffffffc0200d3e:	00005517          	auipc	a0,0x5
ffffffffc0200d42:	6b250513          	addi	a0,a0,1714 # ffffffffc02063f0 <etext+0x97c>
ffffffffc0200d46:	c4eff0ef          	jal	ffffffffc0200194 <cprintf>
        if (current != NULL) {
ffffffffc0200d4a:	000a4797          	auipc	a5,0xa4
ffffffffc0200d4e:	2867b783          	ld	a5,646(a5) # ffffffffc02a4fd0 <current>
ffffffffc0200d52:	f20791e3          	bnez	a5,ffffffffc0200c74 <exception_handler+0x5a>
ffffffffc0200d56:	bf49                	j	ffffffffc0200ce8 <exception_handler+0xce>
}
ffffffffc0200d58:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from H-mode\n");
ffffffffc0200d5a:	00005517          	auipc	a0,0x5
ffffffffc0200d5e:	65650513          	addi	a0,a0,1622 # ffffffffc02063b0 <etext+0x93c>
}
ffffffffc0200d62:	6105                	addi	sp,sp,32
        cprintf("Environment call from H-mode\n");
ffffffffc0200d64:	c30ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d68:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from M-mode\n");
ffffffffc0200d6a:	00005517          	auipc	a0,0x5
ffffffffc0200d6e:	66650513          	addi	a0,a0,1638 # ffffffffc02063d0 <etext+0x95c>
}
ffffffffc0200d72:	6105                	addi	sp,sp,32
        cprintf("Environment call from M-mode\n");
ffffffffc0200d74:	c20ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d78:	60e2                	ld	ra,24(sp)
ffffffffc0200d7a:	6105                	addi	sp,sp,32
        print_trapframe(tf);
ffffffffc0200d7c:	bba5                	j	ffffffffc0200af4 <print_trapframe>
            tf->epc += 4;
ffffffffc0200d7e:	10863783          	ld	a5,264(a2)
ffffffffc0200d82:	0791                	addi	a5,a5,4
ffffffffc0200d84:	10f63423          	sd	a5,264(a2)
            syscall();
ffffffffc0200d88:	7b0040ef          	jal	ffffffffc0205538 <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200d8c:	000a4717          	auipc	a4,0xa4
ffffffffc0200d90:	24473703          	ld	a4,580(a4) # ffffffffc02a4fd0 <current>
ffffffffc0200d94:	6522                	ld	a0,8(sp)
}
ffffffffc0200d96:	60e2                	ld	ra,24(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200d98:	6b0c                	ld	a1,16(a4)
ffffffffc0200d9a:	6789                	lui	a5,0x2
ffffffffc0200d9c:	95be                	add	a1,a1,a5
}
ffffffffc0200d9e:	6105                	addi	sp,sp,32
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200da0:	aa99                	j	ffffffffc0200ef6 <kernel_execve_ret>
        print_trapframe(tf);
ffffffffc0200da2:	bb89                	j	ffffffffc0200af4 <print_trapframe>

ffffffffc0200da4 <trap>:
 * */
void trap(struct trapframe *tf)
{
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200da4:	000a4717          	auipc	a4,0xa4
ffffffffc0200da8:	22c73703          	ld	a4,556(a4) # ffffffffc02a4fd0 <current>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dac:	11853583          	ld	a1,280(a0)
    if (current == NULL)
ffffffffc0200db0:	cf21                	beqz	a4,ffffffffc0200e08 <trap+0x64>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200db2:	10053603          	ld	a2,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200db6:	0a073803          	ld	a6,160(a4)
{
ffffffffc0200dba:	1101                	addi	sp,sp,-32
ffffffffc0200dbc:	ec06                	sd	ra,24(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200dbe:	10067613          	andi	a2,a2,256
        current->tf = tf;
ffffffffc0200dc2:	f348                	sd	a0,160(a4)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dc4:	e432                	sd	a2,8(sp)
ffffffffc0200dc6:	e042                	sd	a6,0(sp)
ffffffffc0200dc8:	0205c763          	bltz	a1,ffffffffc0200df6 <trap+0x52>
        exception_handler(tf);
ffffffffc0200dcc:	e4fff0ef          	jal	ffffffffc0200c1a <exception_handler>
ffffffffc0200dd0:	6622                	ld	a2,8(sp)
ffffffffc0200dd2:	6802                	ld	a6,0(sp)
ffffffffc0200dd4:	000a4697          	auipc	a3,0xa4
ffffffffc0200dd8:	1fc68693          	addi	a3,a3,508 # ffffffffc02a4fd0 <current>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200ddc:	6298                	ld	a4,0(a3)
ffffffffc0200dde:	0b073023          	sd	a6,160(a4)
        if (!in_kernel)
ffffffffc0200de2:	e619                	bnez	a2,ffffffffc0200df0 <trap+0x4c>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200de4:	0b072783          	lw	a5,176(a4)
ffffffffc0200de8:	8b85                	andi	a5,a5,1
ffffffffc0200dea:	e79d                	bnez	a5,ffffffffc0200e18 <trap+0x74>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200dec:	6f1c                	ld	a5,24(a4)
ffffffffc0200dee:	e38d                	bnez	a5,ffffffffc0200e10 <trap+0x6c>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200df0:	60e2                	ld	ra,24(sp)
ffffffffc0200df2:	6105                	addi	sp,sp,32
ffffffffc0200df4:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200df6:	d61ff0ef          	jal	ffffffffc0200b56 <interrupt_handler>
ffffffffc0200dfa:	6802                	ld	a6,0(sp)
ffffffffc0200dfc:	6622                	ld	a2,8(sp)
ffffffffc0200dfe:	000a4697          	auipc	a3,0xa4
ffffffffc0200e02:	1d268693          	addi	a3,a3,466 # ffffffffc02a4fd0 <current>
ffffffffc0200e06:	bfd9                	j	ffffffffc0200ddc <trap+0x38>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e08:	0005c363          	bltz	a1,ffffffffc0200e0e <trap+0x6a>
        exception_handler(tf);
ffffffffc0200e0c:	b539                	j	ffffffffc0200c1a <exception_handler>
        interrupt_handler(tf);
ffffffffc0200e0e:	b3a1                	j	ffffffffc0200b56 <interrupt_handler>
}
ffffffffc0200e10:	60e2                	ld	ra,24(sp)
ffffffffc0200e12:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200e14:	6380406f          	j	ffffffffc020544c <schedule>
                do_exit(-E_KILLED);
ffffffffc0200e18:	555d                	li	a0,-9
ffffffffc0200e1a:	0ed030ef          	jal	ffffffffc0204706 <do_exit>
            if (current->need_resched)
ffffffffc0200e1e:	000a4717          	auipc	a4,0xa4
ffffffffc0200e22:	1b273703          	ld	a4,434(a4) # ffffffffc02a4fd0 <current>
ffffffffc0200e26:	b7d9                	j	ffffffffc0200dec <trap+0x48>

ffffffffc0200e28 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200e28:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200e2c:	00011463          	bnez	sp,ffffffffc0200e34 <__alltraps+0xc>
ffffffffc0200e30:	14002173          	csrr	sp,sscratch
ffffffffc0200e34:	712d                	addi	sp,sp,-288
ffffffffc0200e36:	e002                	sd	zero,0(sp)
ffffffffc0200e38:	e406                	sd	ra,8(sp)
ffffffffc0200e3a:	ec0e                	sd	gp,24(sp)
ffffffffc0200e3c:	f012                	sd	tp,32(sp)
ffffffffc0200e3e:	f416                	sd	t0,40(sp)
ffffffffc0200e40:	f81a                	sd	t1,48(sp)
ffffffffc0200e42:	fc1e                	sd	t2,56(sp)
ffffffffc0200e44:	e0a2                	sd	s0,64(sp)
ffffffffc0200e46:	e4a6                	sd	s1,72(sp)
ffffffffc0200e48:	e8aa                	sd	a0,80(sp)
ffffffffc0200e4a:	ecae                	sd	a1,88(sp)
ffffffffc0200e4c:	f0b2                	sd	a2,96(sp)
ffffffffc0200e4e:	f4b6                	sd	a3,104(sp)
ffffffffc0200e50:	f8ba                	sd	a4,112(sp)
ffffffffc0200e52:	fcbe                	sd	a5,120(sp)
ffffffffc0200e54:	e142                	sd	a6,128(sp)
ffffffffc0200e56:	e546                	sd	a7,136(sp)
ffffffffc0200e58:	e94a                	sd	s2,144(sp)
ffffffffc0200e5a:	ed4e                	sd	s3,152(sp)
ffffffffc0200e5c:	f152                	sd	s4,160(sp)
ffffffffc0200e5e:	f556                	sd	s5,168(sp)
ffffffffc0200e60:	f95a                	sd	s6,176(sp)
ffffffffc0200e62:	fd5e                	sd	s7,184(sp)
ffffffffc0200e64:	e1e2                	sd	s8,192(sp)
ffffffffc0200e66:	e5e6                	sd	s9,200(sp)
ffffffffc0200e68:	e9ea                	sd	s10,208(sp)
ffffffffc0200e6a:	edee                	sd	s11,216(sp)
ffffffffc0200e6c:	f1f2                	sd	t3,224(sp)
ffffffffc0200e6e:	f5f6                	sd	t4,232(sp)
ffffffffc0200e70:	f9fa                	sd	t5,240(sp)
ffffffffc0200e72:	fdfe                	sd	t6,248(sp)
ffffffffc0200e74:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200e78:	100024f3          	csrr	s1,sstatus
ffffffffc0200e7c:	14102973          	csrr	s2,sepc
ffffffffc0200e80:	143029f3          	csrr	s3,stval
ffffffffc0200e84:	14202a73          	csrr	s4,scause
ffffffffc0200e88:	e822                	sd	s0,16(sp)
ffffffffc0200e8a:	e226                	sd	s1,256(sp)
ffffffffc0200e8c:	e64a                	sd	s2,264(sp)
ffffffffc0200e8e:	ea4e                	sd	s3,272(sp)
ffffffffc0200e90:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200e92:	850a                	mv	a0,sp
    jal trap
ffffffffc0200e94:	f11ff0ef          	jal	ffffffffc0200da4 <trap>

ffffffffc0200e98 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200e98:	6492                	ld	s1,256(sp)
ffffffffc0200e9a:	6932                	ld	s2,264(sp)
ffffffffc0200e9c:	1004f413          	andi	s0,s1,256
ffffffffc0200ea0:	e401                	bnez	s0,ffffffffc0200ea8 <__trapret+0x10>
ffffffffc0200ea2:	1200                	addi	s0,sp,288
ffffffffc0200ea4:	14041073          	csrw	sscratch,s0
ffffffffc0200ea8:	10049073          	csrw	sstatus,s1
ffffffffc0200eac:	14191073          	csrw	sepc,s2
ffffffffc0200eb0:	60a2                	ld	ra,8(sp)
ffffffffc0200eb2:	61e2                	ld	gp,24(sp)
ffffffffc0200eb4:	7202                	ld	tp,32(sp)
ffffffffc0200eb6:	72a2                	ld	t0,40(sp)
ffffffffc0200eb8:	7342                	ld	t1,48(sp)
ffffffffc0200eba:	73e2                	ld	t2,56(sp)
ffffffffc0200ebc:	6406                	ld	s0,64(sp)
ffffffffc0200ebe:	64a6                	ld	s1,72(sp)
ffffffffc0200ec0:	6546                	ld	a0,80(sp)
ffffffffc0200ec2:	65e6                	ld	a1,88(sp)
ffffffffc0200ec4:	7606                	ld	a2,96(sp)
ffffffffc0200ec6:	76a6                	ld	a3,104(sp)
ffffffffc0200ec8:	7746                	ld	a4,112(sp)
ffffffffc0200eca:	77e6                	ld	a5,120(sp)
ffffffffc0200ecc:	680a                	ld	a6,128(sp)
ffffffffc0200ece:	68aa                	ld	a7,136(sp)
ffffffffc0200ed0:	694a                	ld	s2,144(sp)
ffffffffc0200ed2:	69ea                	ld	s3,152(sp)
ffffffffc0200ed4:	7a0a                	ld	s4,160(sp)
ffffffffc0200ed6:	7aaa                	ld	s5,168(sp)
ffffffffc0200ed8:	7b4a                	ld	s6,176(sp)
ffffffffc0200eda:	7bea                	ld	s7,184(sp)
ffffffffc0200edc:	6c0e                	ld	s8,192(sp)
ffffffffc0200ede:	6cae                	ld	s9,200(sp)
ffffffffc0200ee0:	6d4e                	ld	s10,208(sp)
ffffffffc0200ee2:	6dee                	ld	s11,216(sp)
ffffffffc0200ee4:	7e0e                	ld	t3,224(sp)
ffffffffc0200ee6:	7eae                	ld	t4,232(sp)
ffffffffc0200ee8:	7f4e                	ld	t5,240(sp)
ffffffffc0200eea:	7fee                	ld	t6,248(sp)
ffffffffc0200eec:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200eee:	10200073          	sret

ffffffffc0200ef2 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200ef2:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200ef4:	b755                	j	ffffffffc0200e98 <__trapret>

ffffffffc0200ef6 <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200ef6:	ee058593          	addi	a1,a1,-288

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200efa:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200efe:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200f02:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200f06:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200f0a:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200f0e:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200f12:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200f16:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200f1a:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200f1c:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200f1e:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200f20:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200f22:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200f24:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200f26:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200f28:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200f2a:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200f2c:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200f2e:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200f30:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200f32:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0200f34:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0200f36:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0200f38:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0200f3a:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0200f3c:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0200f3e:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0200f40:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0200f42:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0200f44:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0200f46:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0200f48:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0200f4a:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0200f4c:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0200f4e:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0200f50:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0200f52:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0200f54:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0200f56:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0200f58:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0200f5a:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0200f5c:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0200f5e:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0200f60:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0200f62:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0200f64:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0200f66:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0200f68:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0200f6a:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0200f6c:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0200f6e:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0200f70:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0200f72:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0200f74:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0200f76:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0200f78:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0200f7a:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0200f7c:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0200f7e:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0200f80:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0200f82:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0200f84:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0200f86:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0200f88:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0200f8a:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0200f8c:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0200f8e:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0200f90:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0200f92:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0200f94:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0200f96:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0200f98:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0200f9a:	812e                	mv	sp,a1
ffffffffc0200f9c:	bdf5                	j	ffffffffc0200e98 <__trapret>

ffffffffc0200f9e <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200f9e:	000a0797          	auipc	a5,0xa0
ffffffffc0200fa2:	fa278793          	addi	a5,a5,-94 # ffffffffc02a0f40 <free_area>
ffffffffc0200fa6:	e79c                	sd	a5,8(a5)
ffffffffc0200fa8:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200faa:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200fae:	8082                	ret

ffffffffc0200fb0 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200fb0:	000a0517          	auipc	a0,0xa0
ffffffffc0200fb4:	fa056503          	lwu	a0,-96(a0) # ffffffffc02a0f50 <free_area+0x10>
ffffffffc0200fb8:	8082                	ret

ffffffffc0200fba <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0200fba:	711d                	addi	sp,sp,-96
ffffffffc0200fbc:	e0ca                	sd	s2,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200fbe:	000a0917          	auipc	s2,0xa0
ffffffffc0200fc2:	f8290913          	addi	s2,s2,-126 # ffffffffc02a0f40 <free_area>
ffffffffc0200fc6:	00893783          	ld	a5,8(s2)
ffffffffc0200fca:	ec86                	sd	ra,88(sp)
ffffffffc0200fcc:	e8a2                	sd	s0,80(sp)
ffffffffc0200fce:	e4a6                	sd	s1,72(sp)
ffffffffc0200fd0:	fc4e                	sd	s3,56(sp)
ffffffffc0200fd2:	f852                	sd	s4,48(sp)
ffffffffc0200fd4:	f456                	sd	s5,40(sp)
ffffffffc0200fd6:	f05a                	sd	s6,32(sp)
ffffffffc0200fd8:	ec5e                	sd	s7,24(sp)
ffffffffc0200fda:	e862                	sd	s8,16(sp)
ffffffffc0200fdc:	e466                	sd	s9,8(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0200fde:	2f278363          	beq	a5,s2,ffffffffc02012c4 <default_check+0x30a>
    int count = 0, total = 0;
ffffffffc0200fe2:	4401                	li	s0,0
ffffffffc0200fe4:	4481                	li	s1,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200fe6:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200fea:	8b09                	andi	a4,a4,2
ffffffffc0200fec:	2e070063          	beqz	a4,ffffffffc02012cc <default_check+0x312>
        count++, total += p->property;
ffffffffc0200ff0:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200ff4:	679c                	ld	a5,8(a5)
ffffffffc0200ff6:	2485                	addiw	s1,s1,1
ffffffffc0200ff8:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0200ffa:	ff2796e3          	bne	a5,s2,ffffffffc0200fe6 <default_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc0200ffe:	89a2                	mv	s3,s0
ffffffffc0201000:	741000ef          	jal	ffffffffc0201f40 <nr_free_pages>
ffffffffc0201004:	73351463          	bne	a0,s3,ffffffffc020172c <default_check+0x772>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201008:	4505                	li	a0,1
ffffffffc020100a:	6c5000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc020100e:	8a2a                	mv	s4,a0
ffffffffc0201010:	44050e63          	beqz	a0,ffffffffc020146c <default_check+0x4b2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201014:	4505                	li	a0,1
ffffffffc0201016:	6b9000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc020101a:	89aa                	mv	s3,a0
ffffffffc020101c:	72050863          	beqz	a0,ffffffffc020174c <default_check+0x792>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201020:	4505                	li	a0,1
ffffffffc0201022:	6ad000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc0201026:	8aaa                	mv	s5,a0
ffffffffc0201028:	4c050263          	beqz	a0,ffffffffc02014ec <default_check+0x532>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020102c:	40a987b3          	sub	a5,s3,a0
ffffffffc0201030:	40aa0733          	sub	a4,s4,a0
ffffffffc0201034:	0017b793          	seqz	a5,a5
ffffffffc0201038:	00173713          	seqz	a4,a4
ffffffffc020103c:	8fd9                	or	a5,a5,a4
ffffffffc020103e:	30079763          	bnez	a5,ffffffffc020134c <default_check+0x392>
ffffffffc0201042:	313a0563          	beq	s4,s3,ffffffffc020134c <default_check+0x392>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201046:	000a2783          	lw	a5,0(s4)
ffffffffc020104a:	2a079163          	bnez	a5,ffffffffc02012ec <default_check+0x332>
ffffffffc020104e:	0009a783          	lw	a5,0(s3)
ffffffffc0201052:	28079d63          	bnez	a5,ffffffffc02012ec <default_check+0x332>
ffffffffc0201056:	411c                	lw	a5,0(a0)
ffffffffc0201058:	28079a63          	bnez	a5,ffffffffc02012ec <default_check+0x332>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc020105c:	000a4797          	auipc	a5,0xa4
ffffffffc0201060:	f647b783          	ld	a5,-156(a5) # ffffffffc02a4fc0 <pages>
ffffffffc0201064:	00007617          	auipc	a2,0x7
ffffffffc0201068:	bc463603          	ld	a2,-1084(a2) # ffffffffc0207c28 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020106c:	000a4697          	auipc	a3,0xa4
ffffffffc0201070:	f4c6b683          	ld	a3,-180(a3) # ffffffffc02a4fb8 <npage>
ffffffffc0201074:	40fa0733          	sub	a4,s4,a5
ffffffffc0201078:	8719                	srai	a4,a4,0x6
ffffffffc020107a:	9732                	add	a4,a4,a2
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc020107c:	0732                	slli	a4,a4,0xc
ffffffffc020107e:	06b2                	slli	a3,a3,0xc
ffffffffc0201080:	2ad77663          	bgeu	a4,a3,ffffffffc020132c <default_check+0x372>
    return page - pages + nbase;
ffffffffc0201084:	40f98733          	sub	a4,s3,a5
ffffffffc0201088:	8719                	srai	a4,a4,0x6
ffffffffc020108a:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020108c:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020108e:	4cd77f63          	bgeu	a4,a3,ffffffffc020156c <default_check+0x5b2>
    return page - pages + nbase;
ffffffffc0201092:	40f507b3          	sub	a5,a0,a5
ffffffffc0201096:	8799                	srai	a5,a5,0x6
ffffffffc0201098:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020109a:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc020109c:	32d7f863          	bgeu	a5,a3,ffffffffc02013cc <default_check+0x412>
    assert(alloc_page() == NULL);
ffffffffc02010a0:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02010a2:	00093c03          	ld	s8,0(s2)
ffffffffc02010a6:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc02010aa:	000a0b17          	auipc	s6,0xa0
ffffffffc02010ae:	ea6b2b03          	lw	s6,-346(s6) # ffffffffc02a0f50 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc02010b2:	01293023          	sd	s2,0(s2)
ffffffffc02010b6:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc02010ba:	000a0797          	auipc	a5,0xa0
ffffffffc02010be:	e807ab23          	sw	zero,-362(a5) # ffffffffc02a0f50 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc02010c2:	60d000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc02010c6:	2e051363          	bnez	a0,ffffffffc02013ac <default_check+0x3f2>
    free_page(p0);
ffffffffc02010ca:	8552                	mv	a0,s4
ffffffffc02010cc:	4585                	li	a1,1
ffffffffc02010ce:	63b000ef          	jal	ffffffffc0201f08 <free_pages>
    free_page(p1);
ffffffffc02010d2:	854e                	mv	a0,s3
ffffffffc02010d4:	4585                	li	a1,1
ffffffffc02010d6:	633000ef          	jal	ffffffffc0201f08 <free_pages>
    free_page(p2);
ffffffffc02010da:	8556                	mv	a0,s5
ffffffffc02010dc:	4585                	li	a1,1
ffffffffc02010de:	62b000ef          	jal	ffffffffc0201f08 <free_pages>
    assert(nr_free == 3);
ffffffffc02010e2:	000a0717          	auipc	a4,0xa0
ffffffffc02010e6:	e6e72703          	lw	a4,-402(a4) # ffffffffc02a0f50 <free_area+0x10>
ffffffffc02010ea:	478d                	li	a5,3
ffffffffc02010ec:	2af71063          	bne	a4,a5,ffffffffc020138c <default_check+0x3d2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02010f0:	4505                	li	a0,1
ffffffffc02010f2:	5dd000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc02010f6:	89aa                	mv	s3,a0
ffffffffc02010f8:	26050a63          	beqz	a0,ffffffffc020136c <default_check+0x3b2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02010fc:	4505                	li	a0,1
ffffffffc02010fe:	5d1000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc0201102:	8aaa                	mv	s5,a0
ffffffffc0201104:	3c050463          	beqz	a0,ffffffffc02014cc <default_check+0x512>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201108:	4505                	li	a0,1
ffffffffc020110a:	5c5000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc020110e:	8a2a                	mv	s4,a0
ffffffffc0201110:	38050e63          	beqz	a0,ffffffffc02014ac <default_check+0x4f2>
    assert(alloc_page() == NULL);
ffffffffc0201114:	4505                	li	a0,1
ffffffffc0201116:	5b9000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc020111a:	36051963          	bnez	a0,ffffffffc020148c <default_check+0x4d2>
    free_page(p0);
ffffffffc020111e:	4585                	li	a1,1
ffffffffc0201120:	854e                	mv	a0,s3
ffffffffc0201122:	5e7000ef          	jal	ffffffffc0201f08 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201126:	00893783          	ld	a5,8(s2)
ffffffffc020112a:	1f278163          	beq	a5,s2,ffffffffc020130c <default_check+0x352>
    assert((p = alloc_page()) == p0);
ffffffffc020112e:	4505                	li	a0,1
ffffffffc0201130:	59f000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc0201134:	8caa                	mv	s9,a0
ffffffffc0201136:	30a99b63          	bne	s3,a0,ffffffffc020144c <default_check+0x492>
    assert(alloc_page() == NULL);
ffffffffc020113a:	4505                	li	a0,1
ffffffffc020113c:	593000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc0201140:	2e051663          	bnez	a0,ffffffffc020142c <default_check+0x472>
    assert(nr_free == 0);
ffffffffc0201144:	000a0797          	auipc	a5,0xa0
ffffffffc0201148:	e0c7a783          	lw	a5,-500(a5) # ffffffffc02a0f50 <free_area+0x10>
ffffffffc020114c:	2c079063          	bnez	a5,ffffffffc020140c <default_check+0x452>
    free_page(p);
ffffffffc0201150:	8566                	mv	a0,s9
ffffffffc0201152:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201154:	01893023          	sd	s8,0(s2)
ffffffffc0201158:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc020115c:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc0201160:	5a9000ef          	jal	ffffffffc0201f08 <free_pages>
    free_page(p1);
ffffffffc0201164:	8556                	mv	a0,s5
ffffffffc0201166:	4585                	li	a1,1
ffffffffc0201168:	5a1000ef          	jal	ffffffffc0201f08 <free_pages>
    free_page(p2);
ffffffffc020116c:	8552                	mv	a0,s4
ffffffffc020116e:	4585                	li	a1,1
ffffffffc0201170:	599000ef          	jal	ffffffffc0201f08 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201174:	4515                	li	a0,5
ffffffffc0201176:	559000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc020117a:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc020117c:	26050863          	beqz	a0,ffffffffc02013ec <default_check+0x432>
ffffffffc0201180:	651c                	ld	a5,8(a0)
    assert(!PageProperty(p0));
ffffffffc0201182:	8b89                	andi	a5,a5,2
ffffffffc0201184:	54079463          	bnez	a5,ffffffffc02016cc <default_check+0x712>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201188:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020118a:	00093b83          	ld	s7,0(s2)
ffffffffc020118e:	00893b03          	ld	s6,8(s2)
ffffffffc0201192:	01293023          	sd	s2,0(s2)
ffffffffc0201196:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc020119a:	535000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc020119e:	50051763          	bnez	a0,ffffffffc02016ac <default_check+0x6f2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc02011a2:	08098a13          	addi	s4,s3,128
ffffffffc02011a6:	8552                	mv	a0,s4
ffffffffc02011a8:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc02011aa:	000a0c17          	auipc	s8,0xa0
ffffffffc02011ae:	da6c2c03          	lw	s8,-602(s8) # ffffffffc02a0f50 <free_area+0x10>
    nr_free = 0;
ffffffffc02011b2:	000a0797          	auipc	a5,0xa0
ffffffffc02011b6:	d807af23          	sw	zero,-610(a5) # ffffffffc02a0f50 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc02011ba:	54f000ef          	jal	ffffffffc0201f08 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc02011be:	4511                	li	a0,4
ffffffffc02011c0:	50f000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc02011c4:	4c051463          	bnez	a0,ffffffffc020168c <default_check+0x6d2>
ffffffffc02011c8:	0889b783          	ld	a5,136(s3)
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02011cc:	8b89                	andi	a5,a5,2
ffffffffc02011ce:	48078f63          	beqz	a5,ffffffffc020166c <default_check+0x6b2>
ffffffffc02011d2:	0909a503          	lw	a0,144(s3)
ffffffffc02011d6:	478d                	li	a5,3
ffffffffc02011d8:	48f51a63          	bne	a0,a5,ffffffffc020166c <default_check+0x6b2>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02011dc:	4f3000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc02011e0:	8aaa                	mv	s5,a0
ffffffffc02011e2:	46050563          	beqz	a0,ffffffffc020164c <default_check+0x692>
    assert(alloc_page() == NULL);
ffffffffc02011e6:	4505                	li	a0,1
ffffffffc02011e8:	4e7000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc02011ec:	44051063          	bnez	a0,ffffffffc020162c <default_check+0x672>
    assert(p0 + 2 == p1);
ffffffffc02011f0:	415a1e63          	bne	s4,s5,ffffffffc020160c <default_check+0x652>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02011f4:	4585                	li	a1,1
ffffffffc02011f6:	854e                	mv	a0,s3
ffffffffc02011f8:	511000ef          	jal	ffffffffc0201f08 <free_pages>
    free_pages(p1, 3);
ffffffffc02011fc:	8552                	mv	a0,s4
ffffffffc02011fe:	458d                	li	a1,3
ffffffffc0201200:	509000ef          	jal	ffffffffc0201f08 <free_pages>
ffffffffc0201204:	0089b783          	ld	a5,8(s3)
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201208:	8b89                	andi	a5,a5,2
ffffffffc020120a:	3e078163          	beqz	a5,ffffffffc02015ec <default_check+0x632>
ffffffffc020120e:	0109aa83          	lw	s5,16(s3)
ffffffffc0201212:	4785                	li	a5,1
ffffffffc0201214:	3cfa9c63          	bne	s5,a5,ffffffffc02015ec <default_check+0x632>
ffffffffc0201218:	008a3783          	ld	a5,8(s4)
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc020121c:	8b89                	andi	a5,a5,2
ffffffffc020121e:	3a078763          	beqz	a5,ffffffffc02015cc <default_check+0x612>
ffffffffc0201222:	010a2703          	lw	a4,16(s4)
ffffffffc0201226:	478d                	li	a5,3
ffffffffc0201228:	3af71263          	bne	a4,a5,ffffffffc02015cc <default_check+0x612>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc020122c:	8556                	mv	a0,s5
ffffffffc020122e:	4a1000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc0201232:	36a99d63          	bne	s3,a0,ffffffffc02015ac <default_check+0x5f2>
    free_page(p0);
ffffffffc0201236:	85d6                	mv	a1,s5
ffffffffc0201238:	4d1000ef          	jal	ffffffffc0201f08 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc020123c:	4509                	li	a0,2
ffffffffc020123e:	491000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc0201242:	34aa1563          	bne	s4,a0,ffffffffc020158c <default_check+0x5d2>

    free_pages(p0, 2);
ffffffffc0201246:	4589                	li	a1,2
ffffffffc0201248:	4c1000ef          	jal	ffffffffc0201f08 <free_pages>
    free_page(p2);
ffffffffc020124c:	04098513          	addi	a0,s3,64
ffffffffc0201250:	85d6                	mv	a1,s5
ffffffffc0201252:	4b7000ef          	jal	ffffffffc0201f08 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201256:	4515                	li	a0,5
ffffffffc0201258:	477000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc020125c:	89aa                	mv	s3,a0
ffffffffc020125e:	48050763          	beqz	a0,ffffffffc02016ec <default_check+0x732>
    assert(alloc_page() == NULL);
ffffffffc0201262:	8556                	mv	a0,s5
ffffffffc0201264:	46b000ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc0201268:	2e051263          	bnez	a0,ffffffffc020154c <default_check+0x592>

    assert(nr_free == 0);
ffffffffc020126c:	000a0797          	auipc	a5,0xa0
ffffffffc0201270:	ce47a783          	lw	a5,-796(a5) # ffffffffc02a0f50 <free_area+0x10>
ffffffffc0201274:	2a079c63          	bnez	a5,ffffffffc020152c <default_check+0x572>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201278:	854e                	mv	a0,s3
ffffffffc020127a:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc020127c:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc0201280:	01793023          	sd	s7,0(s2)
ffffffffc0201284:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc0201288:	481000ef          	jal	ffffffffc0201f08 <free_pages>
    return listelm->next;
ffffffffc020128c:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201290:	01278963          	beq	a5,s2,ffffffffc02012a2 <default_check+0x2e8>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc0201294:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201298:	679c                	ld	a5,8(a5)
ffffffffc020129a:	34fd                	addiw	s1,s1,-1
ffffffffc020129c:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc020129e:	ff279be3          	bne	a5,s2,ffffffffc0201294 <default_check+0x2da>
    }
    assert(count == 0);
ffffffffc02012a2:	26049563          	bnez	s1,ffffffffc020150c <default_check+0x552>
    assert(total == 0);
ffffffffc02012a6:	46041363          	bnez	s0,ffffffffc020170c <default_check+0x752>
}
ffffffffc02012aa:	60e6                	ld	ra,88(sp)
ffffffffc02012ac:	6446                	ld	s0,80(sp)
ffffffffc02012ae:	64a6                	ld	s1,72(sp)
ffffffffc02012b0:	6906                	ld	s2,64(sp)
ffffffffc02012b2:	79e2                	ld	s3,56(sp)
ffffffffc02012b4:	7a42                	ld	s4,48(sp)
ffffffffc02012b6:	7aa2                	ld	s5,40(sp)
ffffffffc02012b8:	7b02                	ld	s6,32(sp)
ffffffffc02012ba:	6be2                	ld	s7,24(sp)
ffffffffc02012bc:	6c42                	ld	s8,16(sp)
ffffffffc02012be:	6ca2                	ld	s9,8(sp)
ffffffffc02012c0:	6125                	addi	sp,sp,96
ffffffffc02012c2:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc02012c4:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02012c6:	4401                	li	s0,0
ffffffffc02012c8:	4481                	li	s1,0
ffffffffc02012ca:	bb1d                	j	ffffffffc0201000 <default_check+0x46>
        assert(PageProperty(p));
ffffffffc02012cc:	00005697          	auipc	a3,0x5
ffffffffc02012d0:	14c68693          	addi	a3,a3,332 # ffffffffc0206418 <etext+0x9a4>
ffffffffc02012d4:	00005617          	auipc	a2,0x5
ffffffffc02012d8:	15460613          	addi	a2,a2,340 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02012dc:	11000593          	li	a1,272
ffffffffc02012e0:	00005517          	auipc	a0,0x5
ffffffffc02012e4:	16050513          	addi	a0,a0,352 # ffffffffc0206440 <etext+0x9cc>
ffffffffc02012e8:	95eff0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02012ec:	00005697          	auipc	a3,0x5
ffffffffc02012f0:	21468693          	addi	a3,a3,532 # ffffffffc0206500 <etext+0xa8c>
ffffffffc02012f4:	00005617          	auipc	a2,0x5
ffffffffc02012f8:	13460613          	addi	a2,a2,308 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02012fc:	0dc00593          	li	a1,220
ffffffffc0201300:	00005517          	auipc	a0,0x5
ffffffffc0201304:	14050513          	addi	a0,a0,320 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201308:	93eff0ef          	jal	ffffffffc0200446 <__panic>
    assert(!list_empty(&free_list));
ffffffffc020130c:	00005697          	auipc	a3,0x5
ffffffffc0201310:	2bc68693          	addi	a3,a3,700 # ffffffffc02065c8 <etext+0xb54>
ffffffffc0201314:	00005617          	auipc	a2,0x5
ffffffffc0201318:	11460613          	addi	a2,a2,276 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020131c:	0f700593          	li	a1,247
ffffffffc0201320:	00005517          	auipc	a0,0x5
ffffffffc0201324:	12050513          	addi	a0,a0,288 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201328:	91eff0ef          	jal	ffffffffc0200446 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020132c:	00005697          	auipc	a3,0x5
ffffffffc0201330:	21468693          	addi	a3,a3,532 # ffffffffc0206540 <etext+0xacc>
ffffffffc0201334:	00005617          	auipc	a2,0x5
ffffffffc0201338:	0f460613          	addi	a2,a2,244 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020133c:	0de00593          	li	a1,222
ffffffffc0201340:	00005517          	auipc	a0,0x5
ffffffffc0201344:	10050513          	addi	a0,a0,256 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201348:	8feff0ef          	jal	ffffffffc0200446 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020134c:	00005697          	auipc	a3,0x5
ffffffffc0201350:	18c68693          	addi	a3,a3,396 # ffffffffc02064d8 <etext+0xa64>
ffffffffc0201354:	00005617          	auipc	a2,0x5
ffffffffc0201358:	0d460613          	addi	a2,a2,212 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020135c:	0db00593          	li	a1,219
ffffffffc0201360:	00005517          	auipc	a0,0x5
ffffffffc0201364:	0e050513          	addi	a0,a0,224 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201368:	8deff0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020136c:	00005697          	auipc	a3,0x5
ffffffffc0201370:	10c68693          	addi	a3,a3,268 # ffffffffc0206478 <etext+0xa04>
ffffffffc0201374:	00005617          	auipc	a2,0x5
ffffffffc0201378:	0b460613          	addi	a2,a2,180 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020137c:	0f000593          	li	a1,240
ffffffffc0201380:	00005517          	auipc	a0,0x5
ffffffffc0201384:	0c050513          	addi	a0,a0,192 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201388:	8beff0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free == 3);
ffffffffc020138c:	00005697          	auipc	a3,0x5
ffffffffc0201390:	22c68693          	addi	a3,a3,556 # ffffffffc02065b8 <etext+0xb44>
ffffffffc0201394:	00005617          	auipc	a2,0x5
ffffffffc0201398:	09460613          	addi	a2,a2,148 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020139c:	0ee00593          	li	a1,238
ffffffffc02013a0:	00005517          	auipc	a0,0x5
ffffffffc02013a4:	0a050513          	addi	a0,a0,160 # ffffffffc0206440 <etext+0x9cc>
ffffffffc02013a8:	89eff0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013ac:	00005697          	auipc	a3,0x5
ffffffffc02013b0:	1f468693          	addi	a3,a3,500 # ffffffffc02065a0 <etext+0xb2c>
ffffffffc02013b4:	00005617          	auipc	a2,0x5
ffffffffc02013b8:	07460613          	addi	a2,a2,116 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02013bc:	0e900593          	li	a1,233
ffffffffc02013c0:	00005517          	auipc	a0,0x5
ffffffffc02013c4:	08050513          	addi	a0,a0,128 # ffffffffc0206440 <etext+0x9cc>
ffffffffc02013c8:	87eff0ef          	jal	ffffffffc0200446 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02013cc:	00005697          	auipc	a3,0x5
ffffffffc02013d0:	1b468693          	addi	a3,a3,436 # ffffffffc0206580 <etext+0xb0c>
ffffffffc02013d4:	00005617          	auipc	a2,0x5
ffffffffc02013d8:	05460613          	addi	a2,a2,84 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02013dc:	0e000593          	li	a1,224
ffffffffc02013e0:	00005517          	auipc	a0,0x5
ffffffffc02013e4:	06050513          	addi	a0,a0,96 # ffffffffc0206440 <etext+0x9cc>
ffffffffc02013e8:	85eff0ef          	jal	ffffffffc0200446 <__panic>
    assert(p0 != NULL);
ffffffffc02013ec:	00005697          	auipc	a3,0x5
ffffffffc02013f0:	22468693          	addi	a3,a3,548 # ffffffffc0206610 <etext+0xb9c>
ffffffffc02013f4:	00005617          	auipc	a2,0x5
ffffffffc02013f8:	03460613          	addi	a2,a2,52 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02013fc:	11800593          	li	a1,280
ffffffffc0201400:	00005517          	auipc	a0,0x5
ffffffffc0201404:	04050513          	addi	a0,a0,64 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201408:	83eff0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free == 0);
ffffffffc020140c:	00005697          	auipc	a3,0x5
ffffffffc0201410:	1f468693          	addi	a3,a3,500 # ffffffffc0206600 <etext+0xb8c>
ffffffffc0201414:	00005617          	auipc	a2,0x5
ffffffffc0201418:	01460613          	addi	a2,a2,20 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020141c:	0fd00593          	li	a1,253
ffffffffc0201420:	00005517          	auipc	a0,0x5
ffffffffc0201424:	02050513          	addi	a0,a0,32 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201428:	81eff0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020142c:	00005697          	auipc	a3,0x5
ffffffffc0201430:	17468693          	addi	a3,a3,372 # ffffffffc02065a0 <etext+0xb2c>
ffffffffc0201434:	00005617          	auipc	a2,0x5
ffffffffc0201438:	ff460613          	addi	a2,a2,-12 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020143c:	0fb00593          	li	a1,251
ffffffffc0201440:	00005517          	auipc	a0,0x5
ffffffffc0201444:	00050513          	mv	a0,a0
ffffffffc0201448:	ffffe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc020144c:	00005697          	auipc	a3,0x5
ffffffffc0201450:	19468693          	addi	a3,a3,404 # ffffffffc02065e0 <etext+0xb6c>
ffffffffc0201454:	00005617          	auipc	a2,0x5
ffffffffc0201458:	fd460613          	addi	a2,a2,-44 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020145c:	0fa00593          	li	a1,250
ffffffffc0201460:	00005517          	auipc	a0,0x5
ffffffffc0201464:	fe050513          	addi	a0,a0,-32 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201468:	fdffe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020146c:	00005697          	auipc	a3,0x5
ffffffffc0201470:	00c68693          	addi	a3,a3,12 # ffffffffc0206478 <etext+0xa04>
ffffffffc0201474:	00005617          	auipc	a2,0x5
ffffffffc0201478:	fb460613          	addi	a2,a2,-76 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020147c:	0d700593          	li	a1,215
ffffffffc0201480:	00005517          	auipc	a0,0x5
ffffffffc0201484:	fc050513          	addi	a0,a0,-64 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201488:	fbffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020148c:	00005697          	auipc	a3,0x5
ffffffffc0201490:	11468693          	addi	a3,a3,276 # ffffffffc02065a0 <etext+0xb2c>
ffffffffc0201494:	00005617          	auipc	a2,0x5
ffffffffc0201498:	f9460613          	addi	a2,a2,-108 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020149c:	0f400593          	li	a1,244
ffffffffc02014a0:	00005517          	auipc	a0,0x5
ffffffffc02014a4:	fa050513          	addi	a0,a0,-96 # ffffffffc0206440 <etext+0x9cc>
ffffffffc02014a8:	f9ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014ac:	00005697          	auipc	a3,0x5
ffffffffc02014b0:	00c68693          	addi	a3,a3,12 # ffffffffc02064b8 <etext+0xa44>
ffffffffc02014b4:	00005617          	auipc	a2,0x5
ffffffffc02014b8:	f7460613          	addi	a2,a2,-140 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02014bc:	0f200593          	li	a1,242
ffffffffc02014c0:	00005517          	auipc	a0,0x5
ffffffffc02014c4:	f8050513          	addi	a0,a0,-128 # ffffffffc0206440 <etext+0x9cc>
ffffffffc02014c8:	f7ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02014cc:	00005697          	auipc	a3,0x5
ffffffffc02014d0:	fcc68693          	addi	a3,a3,-52 # ffffffffc0206498 <etext+0xa24>
ffffffffc02014d4:	00005617          	auipc	a2,0x5
ffffffffc02014d8:	f5460613          	addi	a2,a2,-172 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02014dc:	0f100593          	li	a1,241
ffffffffc02014e0:	00005517          	auipc	a0,0x5
ffffffffc02014e4:	f6050513          	addi	a0,a0,-160 # ffffffffc0206440 <etext+0x9cc>
ffffffffc02014e8:	f5ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014ec:	00005697          	auipc	a3,0x5
ffffffffc02014f0:	fcc68693          	addi	a3,a3,-52 # ffffffffc02064b8 <etext+0xa44>
ffffffffc02014f4:	00005617          	auipc	a2,0x5
ffffffffc02014f8:	f3460613          	addi	a2,a2,-204 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02014fc:	0d900593          	li	a1,217
ffffffffc0201500:	00005517          	auipc	a0,0x5
ffffffffc0201504:	f4050513          	addi	a0,a0,-192 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201508:	f3ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(count == 0);
ffffffffc020150c:	00005697          	auipc	a3,0x5
ffffffffc0201510:	25468693          	addi	a3,a3,596 # ffffffffc0206760 <etext+0xcec>
ffffffffc0201514:	00005617          	auipc	a2,0x5
ffffffffc0201518:	f1460613          	addi	a2,a2,-236 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020151c:	14600593          	li	a1,326
ffffffffc0201520:	00005517          	auipc	a0,0x5
ffffffffc0201524:	f2050513          	addi	a0,a0,-224 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201528:	f1ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free == 0);
ffffffffc020152c:	00005697          	auipc	a3,0x5
ffffffffc0201530:	0d468693          	addi	a3,a3,212 # ffffffffc0206600 <etext+0xb8c>
ffffffffc0201534:	00005617          	auipc	a2,0x5
ffffffffc0201538:	ef460613          	addi	a2,a2,-268 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020153c:	13a00593          	li	a1,314
ffffffffc0201540:	00005517          	auipc	a0,0x5
ffffffffc0201544:	f0050513          	addi	a0,a0,-256 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201548:	efffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020154c:	00005697          	auipc	a3,0x5
ffffffffc0201550:	05468693          	addi	a3,a3,84 # ffffffffc02065a0 <etext+0xb2c>
ffffffffc0201554:	00005617          	auipc	a2,0x5
ffffffffc0201558:	ed460613          	addi	a2,a2,-300 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020155c:	13800593          	li	a1,312
ffffffffc0201560:	00005517          	auipc	a0,0x5
ffffffffc0201564:	ee050513          	addi	a0,a0,-288 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201568:	edffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020156c:	00005697          	auipc	a3,0x5
ffffffffc0201570:	ff468693          	addi	a3,a3,-12 # ffffffffc0206560 <etext+0xaec>
ffffffffc0201574:	00005617          	auipc	a2,0x5
ffffffffc0201578:	eb460613          	addi	a2,a2,-332 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020157c:	0df00593          	li	a1,223
ffffffffc0201580:	00005517          	auipc	a0,0x5
ffffffffc0201584:	ec050513          	addi	a0,a0,-320 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201588:	ebffe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc020158c:	00005697          	auipc	a3,0x5
ffffffffc0201590:	19468693          	addi	a3,a3,404 # ffffffffc0206720 <etext+0xcac>
ffffffffc0201594:	00005617          	auipc	a2,0x5
ffffffffc0201598:	e9460613          	addi	a2,a2,-364 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020159c:	13200593          	li	a1,306
ffffffffc02015a0:	00005517          	auipc	a0,0x5
ffffffffc02015a4:	ea050513          	addi	a0,a0,-352 # ffffffffc0206440 <etext+0x9cc>
ffffffffc02015a8:	e9ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02015ac:	00005697          	auipc	a3,0x5
ffffffffc02015b0:	15468693          	addi	a3,a3,340 # ffffffffc0206700 <etext+0xc8c>
ffffffffc02015b4:	00005617          	auipc	a2,0x5
ffffffffc02015b8:	e7460613          	addi	a2,a2,-396 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02015bc:	13000593          	li	a1,304
ffffffffc02015c0:	00005517          	auipc	a0,0x5
ffffffffc02015c4:	e8050513          	addi	a0,a0,-384 # ffffffffc0206440 <etext+0x9cc>
ffffffffc02015c8:	e7ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02015cc:	00005697          	auipc	a3,0x5
ffffffffc02015d0:	10c68693          	addi	a3,a3,268 # ffffffffc02066d8 <etext+0xc64>
ffffffffc02015d4:	00005617          	auipc	a2,0x5
ffffffffc02015d8:	e5460613          	addi	a2,a2,-428 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02015dc:	12e00593          	li	a1,302
ffffffffc02015e0:	00005517          	auipc	a0,0x5
ffffffffc02015e4:	e6050513          	addi	a0,a0,-416 # ffffffffc0206440 <etext+0x9cc>
ffffffffc02015e8:	e5ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02015ec:	00005697          	auipc	a3,0x5
ffffffffc02015f0:	0c468693          	addi	a3,a3,196 # ffffffffc02066b0 <etext+0xc3c>
ffffffffc02015f4:	00005617          	auipc	a2,0x5
ffffffffc02015f8:	e3460613          	addi	a2,a2,-460 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02015fc:	12d00593          	li	a1,301
ffffffffc0201600:	00005517          	auipc	a0,0x5
ffffffffc0201604:	e4050513          	addi	a0,a0,-448 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201608:	e3ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(p0 + 2 == p1);
ffffffffc020160c:	00005697          	auipc	a3,0x5
ffffffffc0201610:	09468693          	addi	a3,a3,148 # ffffffffc02066a0 <etext+0xc2c>
ffffffffc0201614:	00005617          	auipc	a2,0x5
ffffffffc0201618:	e1460613          	addi	a2,a2,-492 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020161c:	12800593          	li	a1,296
ffffffffc0201620:	00005517          	auipc	a0,0x5
ffffffffc0201624:	e2050513          	addi	a0,a0,-480 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201628:	e1ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020162c:	00005697          	auipc	a3,0x5
ffffffffc0201630:	f7468693          	addi	a3,a3,-140 # ffffffffc02065a0 <etext+0xb2c>
ffffffffc0201634:	00005617          	auipc	a2,0x5
ffffffffc0201638:	df460613          	addi	a2,a2,-524 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020163c:	12700593          	li	a1,295
ffffffffc0201640:	00005517          	auipc	a0,0x5
ffffffffc0201644:	e0050513          	addi	a0,a0,-512 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201648:	dfffe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020164c:	00005697          	auipc	a3,0x5
ffffffffc0201650:	03468693          	addi	a3,a3,52 # ffffffffc0206680 <etext+0xc0c>
ffffffffc0201654:	00005617          	auipc	a2,0x5
ffffffffc0201658:	dd460613          	addi	a2,a2,-556 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020165c:	12600593          	li	a1,294
ffffffffc0201660:	00005517          	auipc	a0,0x5
ffffffffc0201664:	de050513          	addi	a0,a0,-544 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201668:	ddffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020166c:	00005697          	auipc	a3,0x5
ffffffffc0201670:	fe468693          	addi	a3,a3,-28 # ffffffffc0206650 <etext+0xbdc>
ffffffffc0201674:	00005617          	auipc	a2,0x5
ffffffffc0201678:	db460613          	addi	a2,a2,-588 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020167c:	12500593          	li	a1,293
ffffffffc0201680:	00005517          	auipc	a0,0x5
ffffffffc0201684:	dc050513          	addi	a0,a0,-576 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201688:	dbffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc020168c:	00005697          	auipc	a3,0x5
ffffffffc0201690:	fac68693          	addi	a3,a3,-84 # ffffffffc0206638 <etext+0xbc4>
ffffffffc0201694:	00005617          	auipc	a2,0x5
ffffffffc0201698:	d9460613          	addi	a2,a2,-620 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020169c:	12400593          	li	a1,292
ffffffffc02016a0:	00005517          	auipc	a0,0x5
ffffffffc02016a4:	da050513          	addi	a0,a0,-608 # ffffffffc0206440 <etext+0x9cc>
ffffffffc02016a8:	d9ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02016ac:	00005697          	auipc	a3,0x5
ffffffffc02016b0:	ef468693          	addi	a3,a3,-268 # ffffffffc02065a0 <etext+0xb2c>
ffffffffc02016b4:	00005617          	auipc	a2,0x5
ffffffffc02016b8:	d7460613          	addi	a2,a2,-652 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02016bc:	11e00593          	li	a1,286
ffffffffc02016c0:	00005517          	auipc	a0,0x5
ffffffffc02016c4:	d8050513          	addi	a0,a0,-640 # ffffffffc0206440 <etext+0x9cc>
ffffffffc02016c8:	d7ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(!PageProperty(p0));
ffffffffc02016cc:	00005697          	auipc	a3,0x5
ffffffffc02016d0:	f5468693          	addi	a3,a3,-172 # ffffffffc0206620 <etext+0xbac>
ffffffffc02016d4:	00005617          	auipc	a2,0x5
ffffffffc02016d8:	d5460613          	addi	a2,a2,-684 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02016dc:	11900593          	li	a1,281
ffffffffc02016e0:	00005517          	auipc	a0,0x5
ffffffffc02016e4:	d6050513          	addi	a0,a0,-672 # ffffffffc0206440 <etext+0x9cc>
ffffffffc02016e8:	d5ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02016ec:	00005697          	auipc	a3,0x5
ffffffffc02016f0:	05468693          	addi	a3,a3,84 # ffffffffc0206740 <etext+0xccc>
ffffffffc02016f4:	00005617          	auipc	a2,0x5
ffffffffc02016f8:	d3460613          	addi	a2,a2,-716 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02016fc:	13700593          	li	a1,311
ffffffffc0201700:	00005517          	auipc	a0,0x5
ffffffffc0201704:	d4050513          	addi	a0,a0,-704 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201708:	d3ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(total == 0);
ffffffffc020170c:	00005697          	auipc	a3,0x5
ffffffffc0201710:	06468693          	addi	a3,a3,100 # ffffffffc0206770 <etext+0xcfc>
ffffffffc0201714:	00005617          	auipc	a2,0x5
ffffffffc0201718:	d1460613          	addi	a2,a2,-748 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020171c:	14700593          	li	a1,327
ffffffffc0201720:	00005517          	auipc	a0,0x5
ffffffffc0201724:	d2050513          	addi	a0,a0,-736 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201728:	d1ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(total == nr_free_pages());
ffffffffc020172c:	00005697          	auipc	a3,0x5
ffffffffc0201730:	d2c68693          	addi	a3,a3,-724 # ffffffffc0206458 <etext+0x9e4>
ffffffffc0201734:	00005617          	auipc	a2,0x5
ffffffffc0201738:	cf460613          	addi	a2,a2,-780 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020173c:	11300593          	li	a1,275
ffffffffc0201740:	00005517          	auipc	a0,0x5
ffffffffc0201744:	d0050513          	addi	a0,a0,-768 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201748:	cfffe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020174c:	00005697          	auipc	a3,0x5
ffffffffc0201750:	d4c68693          	addi	a3,a3,-692 # ffffffffc0206498 <etext+0xa24>
ffffffffc0201754:	00005617          	auipc	a2,0x5
ffffffffc0201758:	cd460613          	addi	a2,a2,-812 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020175c:	0d800593          	li	a1,216
ffffffffc0201760:	00005517          	auipc	a0,0x5
ffffffffc0201764:	ce050513          	addi	a0,a0,-800 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201768:	cdffe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020176c <default_free_pages>:
{
ffffffffc020176c:	1141                	addi	sp,sp,-16
ffffffffc020176e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201770:	14058663          	beqz	a1,ffffffffc02018bc <default_free_pages+0x150>
    for (; p != base + n; p++)
ffffffffc0201774:	00659713          	slli	a4,a1,0x6
ffffffffc0201778:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc020177c:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc020177e:	c30d                	beqz	a4,ffffffffc02017a0 <default_free_pages+0x34>
ffffffffc0201780:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201782:	8b05                	andi	a4,a4,1
ffffffffc0201784:	10071c63          	bnez	a4,ffffffffc020189c <default_free_pages+0x130>
ffffffffc0201788:	6798                	ld	a4,8(a5)
ffffffffc020178a:	8b09                	andi	a4,a4,2
ffffffffc020178c:	10071863          	bnez	a4,ffffffffc020189c <default_free_pages+0x130>
        p->flags = 0;
ffffffffc0201790:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc0201794:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201798:	04078793          	addi	a5,a5,64
ffffffffc020179c:	fed792e3          	bne	a5,a3,ffffffffc0201780 <default_free_pages+0x14>
    base->property = n;
ffffffffc02017a0:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02017a2:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02017a6:	4789                	li	a5,2
ffffffffc02017a8:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02017ac:	0009f717          	auipc	a4,0x9f
ffffffffc02017b0:	7a472703          	lw	a4,1956(a4) # ffffffffc02a0f50 <free_area+0x10>
ffffffffc02017b4:	0009f697          	auipc	a3,0x9f
ffffffffc02017b8:	78c68693          	addi	a3,a3,1932 # ffffffffc02a0f40 <free_area>
    return list->next == list;
ffffffffc02017bc:	669c                	ld	a5,8(a3)
ffffffffc02017be:	9f2d                	addw	a4,a4,a1
ffffffffc02017c0:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc02017c2:	0ad78163          	beq	a5,a3,ffffffffc0201864 <default_free_pages+0xf8>
            struct Page *page = le2page(le, page_link);
ffffffffc02017c6:	fe878713          	addi	a4,a5,-24
ffffffffc02017ca:	4581                	li	a1,0
ffffffffc02017cc:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc02017d0:	00e56a63          	bltu	a0,a4,ffffffffc02017e4 <default_free_pages+0x78>
    return listelm->next;
ffffffffc02017d4:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02017d6:	04d70c63          	beq	a4,a3,ffffffffc020182e <default_free_pages+0xc2>
    struct Page *p = base;
ffffffffc02017da:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02017dc:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02017e0:	fee57ae3          	bgeu	a0,a4,ffffffffc02017d4 <default_free_pages+0x68>
ffffffffc02017e4:	c199                	beqz	a1,ffffffffc02017ea <default_free_pages+0x7e>
ffffffffc02017e6:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02017ea:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02017ec:	e390                	sd	a2,0(a5)
ffffffffc02017ee:	e710                	sd	a2,8(a4)
    elm->next = next;
    elm->prev = prev;
ffffffffc02017f0:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc02017f2:	f11c                	sd	a5,32(a0)
    if (le != &free_list)
ffffffffc02017f4:	00d70d63          	beq	a4,a3,ffffffffc020180e <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc02017f8:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc02017fc:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc0201800:	02059813          	slli	a6,a1,0x20
ffffffffc0201804:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201808:	97b2                	add	a5,a5,a2
ffffffffc020180a:	02f50c63          	beq	a0,a5,ffffffffc0201842 <default_free_pages+0xd6>
    return listelm->next;
ffffffffc020180e:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc0201810:	00d78c63          	beq	a5,a3,ffffffffc0201828 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc0201814:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201816:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc020181a:	02061593          	slli	a1,a2,0x20
ffffffffc020181e:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201822:	972a                	add	a4,a4,a0
ffffffffc0201824:	04e68c63          	beq	a3,a4,ffffffffc020187c <default_free_pages+0x110>
}
ffffffffc0201828:	60a2                	ld	ra,8(sp)
ffffffffc020182a:	0141                	addi	sp,sp,16
ffffffffc020182c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020182e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201830:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201832:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201834:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201836:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc0201838:	02d70f63          	beq	a4,a3,ffffffffc0201876 <default_free_pages+0x10a>
ffffffffc020183c:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc020183e:	87ba                	mv	a5,a4
ffffffffc0201840:	bf71                	j	ffffffffc02017dc <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0201842:	491c                	lw	a5,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201844:	5875                	li	a6,-3
ffffffffc0201846:	9fad                	addw	a5,a5,a1
ffffffffc0201848:	fef72c23          	sw	a5,-8(a4)
ffffffffc020184c:	6108b02f          	amoand.d	zero,a6,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201850:	01853803          	ld	a6,24(a0)
ffffffffc0201854:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201856:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201858:	00b83423          	sd	a1,8(a6) # ff0008 <_binary_obj___user_exit_out_size+0xfe5e48>
    return listelm->next;
ffffffffc020185c:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc020185e:	0105b023          	sd	a6,0(a1)
ffffffffc0201862:	b77d                	j	ffffffffc0201810 <default_free_pages+0xa4>
}
ffffffffc0201864:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201866:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc020186a:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020186c:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc020186e:	e398                	sd	a4,0(a5)
ffffffffc0201870:	e798                	sd	a4,8(a5)
}
ffffffffc0201872:	0141                	addi	sp,sp,16
ffffffffc0201874:	8082                	ret
ffffffffc0201876:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc0201878:	873e                	mv	a4,a5
ffffffffc020187a:	bfad                	j	ffffffffc02017f4 <default_free_pages+0x88>
            base->property += p->property;
ffffffffc020187c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201880:	56f5                	li	a3,-3
ffffffffc0201882:	9f31                	addw	a4,a4,a2
ffffffffc0201884:	c918                	sw	a4,16(a0)
ffffffffc0201886:	ff078713          	addi	a4,a5,-16
ffffffffc020188a:	60d7302f          	amoand.d	zero,a3,(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc020188e:	6398                	ld	a4,0(a5)
ffffffffc0201890:	679c                	ld	a5,8(a5)
}
ffffffffc0201892:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201894:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201896:	e398                	sd	a4,0(a5)
ffffffffc0201898:	0141                	addi	sp,sp,16
ffffffffc020189a:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020189c:	00005697          	auipc	a3,0x5
ffffffffc02018a0:	eec68693          	addi	a3,a3,-276 # ffffffffc0206788 <etext+0xd14>
ffffffffc02018a4:	00005617          	auipc	a2,0x5
ffffffffc02018a8:	b8460613          	addi	a2,a2,-1148 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02018ac:	09400593          	li	a1,148
ffffffffc02018b0:	00005517          	auipc	a0,0x5
ffffffffc02018b4:	b9050513          	addi	a0,a0,-1136 # ffffffffc0206440 <etext+0x9cc>
ffffffffc02018b8:	b8ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(n > 0);
ffffffffc02018bc:	00005697          	auipc	a3,0x5
ffffffffc02018c0:	ec468693          	addi	a3,a3,-316 # ffffffffc0206780 <etext+0xd0c>
ffffffffc02018c4:	00005617          	auipc	a2,0x5
ffffffffc02018c8:	b6460613          	addi	a2,a2,-1180 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02018cc:	09000593          	li	a1,144
ffffffffc02018d0:	00005517          	auipc	a0,0x5
ffffffffc02018d4:	b7050513          	addi	a0,a0,-1168 # ffffffffc0206440 <etext+0x9cc>
ffffffffc02018d8:	b6ffe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02018dc <default_alloc_pages>:
    assert(n > 0);
ffffffffc02018dc:	c951                	beqz	a0,ffffffffc0201970 <default_alloc_pages+0x94>
    if (n > nr_free)
ffffffffc02018de:	0009f597          	auipc	a1,0x9f
ffffffffc02018e2:	6725a583          	lw	a1,1650(a1) # ffffffffc02a0f50 <free_area+0x10>
ffffffffc02018e6:	86aa                	mv	a3,a0
ffffffffc02018e8:	02059793          	slli	a5,a1,0x20
ffffffffc02018ec:	9381                	srli	a5,a5,0x20
ffffffffc02018ee:	00a7ef63          	bltu	a5,a0,ffffffffc020190c <default_alloc_pages+0x30>
    list_entry_t *le = &free_list;
ffffffffc02018f2:	0009f617          	auipc	a2,0x9f
ffffffffc02018f6:	64e60613          	addi	a2,a2,1614 # ffffffffc02a0f40 <free_area>
ffffffffc02018fa:	87b2                	mv	a5,a2
ffffffffc02018fc:	a029                	j	ffffffffc0201906 <default_alloc_pages+0x2a>
        if (p->property >= n)
ffffffffc02018fe:	ff87e703          	lwu	a4,-8(a5)
ffffffffc0201902:	00d77763          	bgeu	a4,a3,ffffffffc0201910 <default_alloc_pages+0x34>
    return listelm->next;
ffffffffc0201906:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201908:	fec79be3          	bne	a5,a2,ffffffffc02018fe <default_alloc_pages+0x22>
        return NULL;
ffffffffc020190c:	4501                	li	a0,0
}
ffffffffc020190e:	8082                	ret
        if (page->property > n)
ffffffffc0201910:	ff87a883          	lw	a7,-8(a5)
    return listelm->prev;
ffffffffc0201914:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201918:	6798                	ld	a4,8(a5)
ffffffffc020191a:	02089313          	slli	t1,a7,0x20
ffffffffc020191e:	02035313          	srli	t1,t1,0x20
    prev->next = next;
ffffffffc0201922:	00e83423          	sd	a4,8(a6)
    next->prev = prev;
ffffffffc0201926:	01073023          	sd	a6,0(a4)
        struct Page *p = le2page(le, page_link);
ffffffffc020192a:	fe878513          	addi	a0,a5,-24
        if (page->property > n)
ffffffffc020192e:	0266fa63          	bgeu	a3,t1,ffffffffc0201962 <default_alloc_pages+0x86>
            struct Page *p = page + n;
ffffffffc0201932:	00669713          	slli	a4,a3,0x6
            p->property = page->property - n;
ffffffffc0201936:	40d888bb          	subw	a7,a7,a3
            struct Page *p = page + n;
ffffffffc020193a:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc020193c:	01172823          	sw	a7,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201940:	00870313          	addi	t1,a4,8
ffffffffc0201944:	4889                	li	a7,2
ffffffffc0201946:	4113302f          	amoor.d	zero,a7,(t1)
    __list_add(elm, listelm, listelm->next);
ffffffffc020194a:	00883883          	ld	a7,8(a6)
            list_add(prev, &(p->page_link));
ffffffffc020194e:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc0201952:	0068b023          	sd	t1,0(a7)
ffffffffc0201956:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc020195a:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc020195e:	01073c23          	sd	a6,24(a4)
        nr_free -= n;
ffffffffc0201962:	9d95                	subw	a1,a1,a3
ffffffffc0201964:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201966:	5775                	li	a4,-3
ffffffffc0201968:	17c1                	addi	a5,a5,-16
ffffffffc020196a:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc020196e:	8082                	ret
{
ffffffffc0201970:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201972:	00005697          	auipc	a3,0x5
ffffffffc0201976:	e0e68693          	addi	a3,a3,-498 # ffffffffc0206780 <etext+0xd0c>
ffffffffc020197a:	00005617          	auipc	a2,0x5
ffffffffc020197e:	aae60613          	addi	a2,a2,-1362 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0201982:	06c00593          	li	a1,108
ffffffffc0201986:	00005517          	auipc	a0,0x5
ffffffffc020198a:	aba50513          	addi	a0,a0,-1350 # ffffffffc0206440 <etext+0x9cc>
{
ffffffffc020198e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201990:	ab7fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201994 <default_init_memmap>:
{
ffffffffc0201994:	1141                	addi	sp,sp,-16
ffffffffc0201996:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201998:	c9e1                	beqz	a1,ffffffffc0201a68 <default_init_memmap+0xd4>
    for (; p != base + n; p++)
ffffffffc020199a:	00659713          	slli	a4,a1,0x6
ffffffffc020199e:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc02019a2:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc02019a4:	cf11                	beqz	a4,ffffffffc02019c0 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02019a6:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02019a8:	8b05                	andi	a4,a4,1
ffffffffc02019aa:	cf59                	beqz	a4,ffffffffc0201a48 <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc02019ac:	0007a823          	sw	zero,16(a5)
ffffffffc02019b0:	0007b423          	sd	zero,8(a5)
ffffffffc02019b4:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02019b8:	04078793          	addi	a5,a5,64
ffffffffc02019bc:	fed795e3          	bne	a5,a3,ffffffffc02019a6 <default_init_memmap+0x12>
    base->property = n;
ffffffffc02019c0:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02019c2:	4789                	li	a5,2
ffffffffc02019c4:	00850713          	addi	a4,a0,8
ffffffffc02019c8:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02019cc:	0009f717          	auipc	a4,0x9f
ffffffffc02019d0:	58472703          	lw	a4,1412(a4) # ffffffffc02a0f50 <free_area+0x10>
ffffffffc02019d4:	0009f697          	auipc	a3,0x9f
ffffffffc02019d8:	56c68693          	addi	a3,a3,1388 # ffffffffc02a0f40 <free_area>
    return list->next == list;
ffffffffc02019dc:	669c                	ld	a5,8(a3)
ffffffffc02019de:	9f2d                	addw	a4,a4,a1
ffffffffc02019e0:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc02019e2:	04d78663          	beq	a5,a3,ffffffffc0201a2e <default_init_memmap+0x9a>
            struct Page *page = le2page(le, page_link);
ffffffffc02019e6:	fe878713          	addi	a4,a5,-24
ffffffffc02019ea:	4581                	li	a1,0
ffffffffc02019ec:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc02019f0:	00e56a63          	bltu	a0,a4,ffffffffc0201a04 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc02019f4:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02019f6:	02d70263          	beq	a4,a3,ffffffffc0201a1a <default_init_memmap+0x86>
    struct Page *p = base;
ffffffffc02019fa:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02019fc:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201a00:	fee57ae3          	bgeu	a0,a4,ffffffffc02019f4 <default_init_memmap+0x60>
ffffffffc0201a04:	c199                	beqz	a1,ffffffffc0201a0a <default_init_memmap+0x76>
ffffffffc0201a06:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201a0a:	6398                	ld	a4,0(a5)
}
ffffffffc0201a0c:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201a0e:	e390                	sd	a2,0(a5)
ffffffffc0201a10:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc0201a12:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0201a14:	f11c                	sd	a5,32(a0)
ffffffffc0201a16:	0141                	addi	sp,sp,16
ffffffffc0201a18:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201a1a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a1c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201a1e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201a20:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201a22:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc0201a24:	00d70e63          	beq	a4,a3,ffffffffc0201a40 <default_init_memmap+0xac>
ffffffffc0201a28:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc0201a2a:	87ba                	mv	a5,a4
ffffffffc0201a2c:	bfc1                	j	ffffffffc02019fc <default_init_memmap+0x68>
}
ffffffffc0201a2e:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201a30:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201a34:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a36:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0201a38:	e398                	sd	a4,0(a5)
ffffffffc0201a3a:	e798                	sd	a4,8(a5)
}
ffffffffc0201a3c:	0141                	addi	sp,sp,16
ffffffffc0201a3e:	8082                	ret
ffffffffc0201a40:	60a2                	ld	ra,8(sp)
ffffffffc0201a42:	e290                	sd	a2,0(a3)
ffffffffc0201a44:	0141                	addi	sp,sp,16
ffffffffc0201a46:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201a48:	00005697          	auipc	a3,0x5
ffffffffc0201a4c:	d6868693          	addi	a3,a3,-664 # ffffffffc02067b0 <etext+0xd3c>
ffffffffc0201a50:	00005617          	auipc	a2,0x5
ffffffffc0201a54:	9d860613          	addi	a2,a2,-1576 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0201a58:	04b00593          	li	a1,75
ffffffffc0201a5c:	00005517          	auipc	a0,0x5
ffffffffc0201a60:	9e450513          	addi	a0,a0,-1564 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201a64:	9e3fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(n > 0);
ffffffffc0201a68:	00005697          	auipc	a3,0x5
ffffffffc0201a6c:	d1868693          	addi	a3,a3,-744 # ffffffffc0206780 <etext+0xd0c>
ffffffffc0201a70:	00005617          	auipc	a2,0x5
ffffffffc0201a74:	9b860613          	addi	a2,a2,-1608 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0201a78:	04700593          	li	a1,71
ffffffffc0201a7c:	00005517          	auipc	a0,0x5
ffffffffc0201a80:	9c450513          	addi	a0,a0,-1596 # ffffffffc0206440 <etext+0x9cc>
ffffffffc0201a84:	9c3fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201a88 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201a88:	c531                	beqz	a0,ffffffffc0201ad4 <slob_free+0x4c>
		return;

	if (size)
ffffffffc0201a8a:	e9b9                	bnez	a1,ffffffffc0201ae0 <slob_free+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a8c:	100027f3          	csrr	a5,sstatus
ffffffffc0201a90:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201a92:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a94:	efb1                	bnez	a5,ffffffffc0201af0 <slob_free+0x68>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201a96:	0009f797          	auipc	a5,0x9f
ffffffffc0201a9a:	09a7b783          	ld	a5,154(a5) # ffffffffc02a0b30 <slobfree>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201a9e:	873e                	mv	a4,a5
ffffffffc0201aa0:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201aa2:	02a77a63          	bgeu	a4,a0,ffffffffc0201ad6 <slob_free+0x4e>
ffffffffc0201aa6:	00f56463          	bltu	a0,a5,ffffffffc0201aae <slob_free+0x26>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201aaa:	fef76ae3          	bltu	a4,a5,ffffffffc0201a9e <slob_free+0x16>
			break;

	if (b + b->units == cur->next)
ffffffffc0201aae:	4110                	lw	a2,0(a0)
ffffffffc0201ab0:	00461693          	slli	a3,a2,0x4
ffffffffc0201ab4:	96aa                	add	a3,a3,a0
ffffffffc0201ab6:	0ad78463          	beq	a5,a3,ffffffffc0201b5e <slob_free+0xd6>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201aba:	4310                	lw	a2,0(a4)
ffffffffc0201abc:	e51c                	sd	a5,8(a0)
ffffffffc0201abe:	00461693          	slli	a3,a2,0x4
ffffffffc0201ac2:	96ba                	add	a3,a3,a4
ffffffffc0201ac4:	08d50163          	beq	a0,a3,ffffffffc0201b46 <slob_free+0xbe>
ffffffffc0201ac8:	e708                	sd	a0,8(a4)
		cur->next = b->next;
	}
	else
		cur->next = b;

	slobfree = cur;
ffffffffc0201aca:	0009f797          	auipc	a5,0x9f
ffffffffc0201ace:	06e7b323          	sd	a4,102(a5) # ffffffffc02a0b30 <slobfree>
    if (flag)
ffffffffc0201ad2:	e9a5                	bnez	a1,ffffffffc0201b42 <slob_free+0xba>
ffffffffc0201ad4:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201ad6:	fcf574e3          	bgeu	a0,a5,ffffffffc0201a9e <slob_free+0x16>
ffffffffc0201ada:	fcf762e3          	bltu	a4,a5,ffffffffc0201a9e <slob_free+0x16>
ffffffffc0201ade:	bfc1                	j	ffffffffc0201aae <slob_free+0x26>
		b->units = SLOB_UNITS(size);
ffffffffc0201ae0:	25bd                	addiw	a1,a1,15
ffffffffc0201ae2:	8191                	srli	a1,a1,0x4
ffffffffc0201ae4:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ae6:	100027f3          	csrr	a5,sstatus
ffffffffc0201aea:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201aec:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201aee:	d7c5                	beqz	a5,ffffffffc0201a96 <slob_free+0xe>
{
ffffffffc0201af0:	1101                	addi	sp,sp,-32
ffffffffc0201af2:	e42a                	sd	a0,8(sp)
ffffffffc0201af4:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201af6:	e0ffe0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0201afa:	6522                	ld	a0,8(sp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201afc:	0009f797          	auipc	a5,0x9f
ffffffffc0201b00:	0347b783          	ld	a5,52(a5) # ffffffffc02a0b30 <slobfree>
ffffffffc0201b04:	4585                	li	a1,1
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b06:	873e                	mv	a4,a5
ffffffffc0201b08:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201b0a:	06a77663          	bgeu	a4,a0,ffffffffc0201b76 <slob_free+0xee>
ffffffffc0201b0e:	00f56463          	bltu	a0,a5,ffffffffc0201b16 <slob_free+0x8e>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b12:	fef76ae3          	bltu	a4,a5,ffffffffc0201b06 <slob_free+0x7e>
	if (b + b->units == cur->next)
ffffffffc0201b16:	4110                	lw	a2,0(a0)
ffffffffc0201b18:	00461693          	slli	a3,a2,0x4
ffffffffc0201b1c:	96aa                	add	a3,a3,a0
ffffffffc0201b1e:	06d78363          	beq	a5,a3,ffffffffc0201b84 <slob_free+0xfc>
	if (cur + cur->units == b)
ffffffffc0201b22:	4310                	lw	a2,0(a4)
ffffffffc0201b24:	e51c                	sd	a5,8(a0)
ffffffffc0201b26:	00461693          	slli	a3,a2,0x4
ffffffffc0201b2a:	96ba                	add	a3,a3,a4
ffffffffc0201b2c:	06d50163          	beq	a0,a3,ffffffffc0201b8e <slob_free+0x106>
ffffffffc0201b30:	e708                	sd	a0,8(a4)
	slobfree = cur;
ffffffffc0201b32:	0009f797          	auipc	a5,0x9f
ffffffffc0201b36:	fee7bf23          	sd	a4,-2(a5) # ffffffffc02a0b30 <slobfree>
    if (flag)
ffffffffc0201b3a:	e1a9                	bnez	a1,ffffffffc0201b7c <slob_free+0xf4>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201b3c:	60e2                	ld	ra,24(sp)
ffffffffc0201b3e:	6105                	addi	sp,sp,32
ffffffffc0201b40:	8082                	ret
        intr_enable();
ffffffffc0201b42:	dbdfe06f          	j	ffffffffc02008fe <intr_enable>
		cur->units += b->units;
ffffffffc0201b46:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201b48:	853e                	mv	a0,a5
ffffffffc0201b4a:	e708                	sd	a0,8(a4)
		cur->units += b->units;
ffffffffc0201b4c:	00c687bb          	addw	a5,a3,a2
ffffffffc0201b50:	c31c                	sw	a5,0(a4)
	slobfree = cur;
ffffffffc0201b52:	0009f797          	auipc	a5,0x9f
ffffffffc0201b56:	fce7bf23          	sd	a4,-34(a5) # ffffffffc02a0b30 <slobfree>
    if (flag)
ffffffffc0201b5a:	ddad                	beqz	a1,ffffffffc0201ad4 <slob_free+0x4c>
ffffffffc0201b5c:	b7dd                	j	ffffffffc0201b42 <slob_free+0xba>
		b->units += cur->next->units;
ffffffffc0201b5e:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201b60:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201b62:	9eb1                	addw	a3,a3,a2
ffffffffc0201b64:	c114                	sw	a3,0(a0)
	if (cur + cur->units == b)
ffffffffc0201b66:	4310                	lw	a2,0(a4)
ffffffffc0201b68:	e51c                	sd	a5,8(a0)
ffffffffc0201b6a:	00461693          	slli	a3,a2,0x4
ffffffffc0201b6e:	96ba                	add	a3,a3,a4
ffffffffc0201b70:	f4d51ce3          	bne	a0,a3,ffffffffc0201ac8 <slob_free+0x40>
ffffffffc0201b74:	bfc9                	j	ffffffffc0201b46 <slob_free+0xbe>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b76:	f8f56ee3          	bltu	a0,a5,ffffffffc0201b12 <slob_free+0x8a>
ffffffffc0201b7a:	b771                	j	ffffffffc0201b06 <slob_free+0x7e>
}
ffffffffc0201b7c:	60e2                	ld	ra,24(sp)
ffffffffc0201b7e:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201b80:	d7ffe06f          	j	ffffffffc02008fe <intr_enable>
		b->units += cur->next->units;
ffffffffc0201b84:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201b86:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201b88:	9eb1                	addw	a3,a3,a2
ffffffffc0201b8a:	c114                	sw	a3,0(a0)
		b->next = cur->next->next;
ffffffffc0201b8c:	bf59                	j	ffffffffc0201b22 <slob_free+0x9a>
		cur->units += b->units;
ffffffffc0201b8e:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201b90:	853e                	mv	a0,a5
		cur->units += b->units;
ffffffffc0201b92:	00c687bb          	addw	a5,a3,a2
ffffffffc0201b96:	c31c                	sw	a5,0(a4)
		cur->next = b->next;
ffffffffc0201b98:	bf61                	j	ffffffffc0201b30 <slob_free+0xa8>

ffffffffc0201b9a <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b9a:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201b9c:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b9e:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201ba2:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201ba4:	32a000ef          	jal	ffffffffc0201ece <alloc_pages>
	if (!page)
ffffffffc0201ba8:	c91d                	beqz	a0,ffffffffc0201bde <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201baa:	000a3697          	auipc	a3,0xa3
ffffffffc0201bae:	4166b683          	ld	a3,1046(a3) # ffffffffc02a4fc0 <pages>
ffffffffc0201bb2:	00006797          	auipc	a5,0x6
ffffffffc0201bb6:	0767b783          	ld	a5,118(a5) # ffffffffc0207c28 <nbase>
    return KADDR(page2pa(page));
ffffffffc0201bba:	000a3717          	auipc	a4,0xa3
ffffffffc0201bbe:	3fe73703          	ld	a4,1022(a4) # ffffffffc02a4fb8 <npage>
    return page - pages + nbase;
ffffffffc0201bc2:	8d15                	sub	a0,a0,a3
ffffffffc0201bc4:	8519                	srai	a0,a0,0x6
ffffffffc0201bc6:	953e                	add	a0,a0,a5
    return KADDR(page2pa(page));
ffffffffc0201bc8:	00c51793          	slli	a5,a0,0xc
ffffffffc0201bcc:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201bce:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201bd0:	00e7fa63          	bgeu	a5,a4,ffffffffc0201be4 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201bd4:	000a3797          	auipc	a5,0xa3
ffffffffc0201bd8:	3dc7b783          	ld	a5,988(a5) # ffffffffc02a4fb0 <va_pa_offset>
ffffffffc0201bdc:	953e                	add	a0,a0,a5
}
ffffffffc0201bde:	60a2                	ld	ra,8(sp)
ffffffffc0201be0:	0141                	addi	sp,sp,16
ffffffffc0201be2:	8082                	ret
ffffffffc0201be4:	86aa                	mv	a3,a0
ffffffffc0201be6:	00005617          	auipc	a2,0x5
ffffffffc0201bea:	bf260613          	addi	a2,a2,-1038 # ffffffffc02067d8 <etext+0xd64>
ffffffffc0201bee:	07100593          	li	a1,113
ffffffffc0201bf2:	00005517          	auipc	a0,0x5
ffffffffc0201bf6:	c0e50513          	addi	a0,a0,-1010 # ffffffffc0206800 <etext+0xd8c>
ffffffffc0201bfa:	84dfe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201bfe <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201bfe:	7179                	addi	sp,sp,-48
ffffffffc0201c00:	f406                	sd	ra,40(sp)
ffffffffc0201c02:	f022                	sd	s0,32(sp)
ffffffffc0201c04:	ec26                	sd	s1,24(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201c06:	01050713          	addi	a4,a0,16
ffffffffc0201c0a:	6785                	lui	a5,0x1
ffffffffc0201c0c:	0af77e63          	bgeu	a4,a5,ffffffffc0201cc8 <slob_alloc.constprop.0+0xca>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201c10:	00f50413          	addi	s0,a0,15
ffffffffc0201c14:	8011                	srli	s0,s0,0x4
ffffffffc0201c16:	2401                	sext.w	s0,s0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c18:	100025f3          	csrr	a1,sstatus
ffffffffc0201c1c:	8989                	andi	a1,a1,2
ffffffffc0201c1e:	edd1                	bnez	a1,ffffffffc0201cba <slob_alloc.constprop.0+0xbc>
	prev = slobfree;
ffffffffc0201c20:	0009f497          	auipc	s1,0x9f
ffffffffc0201c24:	f1048493          	addi	s1,s1,-240 # ffffffffc02a0b30 <slobfree>
ffffffffc0201c28:	6090                	ld	a2,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c2a:	6618                	ld	a4,8(a2)
		if (cur->units >= units + delta)
ffffffffc0201c2c:	4314                	lw	a3,0(a4)
ffffffffc0201c2e:	0886da63          	bge	a3,s0,ffffffffc0201cc2 <slob_alloc.constprop.0+0xc4>
		if (cur == slobfree)
ffffffffc0201c32:	00e60a63          	beq	a2,a4,ffffffffc0201c46 <slob_alloc.constprop.0+0x48>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c36:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201c38:	4394                	lw	a3,0(a5)
ffffffffc0201c3a:	0286d863          	bge	a3,s0,ffffffffc0201c6a <slob_alloc.constprop.0+0x6c>
		if (cur == slobfree)
ffffffffc0201c3e:	6090                	ld	a2,0(s1)
ffffffffc0201c40:	873e                	mv	a4,a5
ffffffffc0201c42:	fee61ae3          	bne	a2,a4,ffffffffc0201c36 <slob_alloc.constprop.0+0x38>
    if (flag)
ffffffffc0201c46:	e9b1                	bnez	a1,ffffffffc0201c9a <slob_alloc.constprop.0+0x9c>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201c48:	4501                	li	a0,0
ffffffffc0201c4a:	f51ff0ef          	jal	ffffffffc0201b9a <__slob_get_free_pages.constprop.0>
ffffffffc0201c4e:	87aa                	mv	a5,a0
			if (!cur)
ffffffffc0201c50:	c915                	beqz	a0,ffffffffc0201c84 <slob_alloc.constprop.0+0x86>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201c52:	6585                	lui	a1,0x1
ffffffffc0201c54:	e35ff0ef          	jal	ffffffffc0201a88 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c58:	100025f3          	csrr	a1,sstatus
ffffffffc0201c5c:	8989                	andi	a1,a1,2
ffffffffc0201c5e:	e98d                	bnez	a1,ffffffffc0201c90 <slob_alloc.constprop.0+0x92>
			cur = slobfree;
ffffffffc0201c60:	6098                	ld	a4,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c62:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201c64:	4394                	lw	a3,0(a5)
ffffffffc0201c66:	fc86cce3          	blt	a3,s0,ffffffffc0201c3e <slob_alloc.constprop.0+0x40>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201c6a:	04d40563          	beq	s0,a3,ffffffffc0201cb4 <slob_alloc.constprop.0+0xb6>
				prev->next = cur + units;
ffffffffc0201c6e:	00441613          	slli	a2,s0,0x4
ffffffffc0201c72:	963e                	add	a2,a2,a5
ffffffffc0201c74:	e710                	sd	a2,8(a4)
				prev->next->next = cur->next;
ffffffffc0201c76:	6788                	ld	a0,8(a5)
				prev->next->units = cur->units - units;
ffffffffc0201c78:	9e81                	subw	a3,a3,s0
ffffffffc0201c7a:	c214                	sw	a3,0(a2)
				prev->next->next = cur->next;
ffffffffc0201c7c:	e608                	sd	a0,8(a2)
				cur->units = units;
ffffffffc0201c7e:	c380                	sw	s0,0(a5)
			slobfree = prev;
ffffffffc0201c80:	e098                	sd	a4,0(s1)
    if (flag)
ffffffffc0201c82:	ed99                	bnez	a1,ffffffffc0201ca0 <slob_alloc.constprop.0+0xa2>
}
ffffffffc0201c84:	70a2                	ld	ra,40(sp)
ffffffffc0201c86:	7402                	ld	s0,32(sp)
ffffffffc0201c88:	64e2                	ld	s1,24(sp)
ffffffffc0201c8a:	853e                	mv	a0,a5
ffffffffc0201c8c:	6145                	addi	sp,sp,48
ffffffffc0201c8e:	8082                	ret
        intr_disable();
ffffffffc0201c90:	c75fe0ef          	jal	ffffffffc0200904 <intr_disable>
			cur = slobfree;
ffffffffc0201c94:	6098                	ld	a4,0(s1)
        return 1;
ffffffffc0201c96:	4585                	li	a1,1
ffffffffc0201c98:	b7e9                	j	ffffffffc0201c62 <slob_alloc.constprop.0+0x64>
        intr_enable();
ffffffffc0201c9a:	c65fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201c9e:	b76d                	j	ffffffffc0201c48 <slob_alloc.constprop.0+0x4a>
ffffffffc0201ca0:	e43e                	sd	a5,8(sp)
ffffffffc0201ca2:	c5dfe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201ca6:	67a2                	ld	a5,8(sp)
}
ffffffffc0201ca8:	70a2                	ld	ra,40(sp)
ffffffffc0201caa:	7402                	ld	s0,32(sp)
ffffffffc0201cac:	64e2                	ld	s1,24(sp)
ffffffffc0201cae:	853e                	mv	a0,a5
ffffffffc0201cb0:	6145                	addi	sp,sp,48
ffffffffc0201cb2:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201cb4:	6794                	ld	a3,8(a5)
ffffffffc0201cb6:	e714                	sd	a3,8(a4)
ffffffffc0201cb8:	b7e1                	j	ffffffffc0201c80 <slob_alloc.constprop.0+0x82>
        intr_disable();
ffffffffc0201cba:	c4bfe0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0201cbe:	4585                	li	a1,1
ffffffffc0201cc0:	b785                	j	ffffffffc0201c20 <slob_alloc.constprop.0+0x22>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201cc2:	87ba                	mv	a5,a4
	prev = slobfree;
ffffffffc0201cc4:	8732                	mv	a4,a2
ffffffffc0201cc6:	b755                	j	ffffffffc0201c6a <slob_alloc.constprop.0+0x6c>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201cc8:	00005697          	auipc	a3,0x5
ffffffffc0201ccc:	b4868693          	addi	a3,a3,-1208 # ffffffffc0206810 <etext+0xd9c>
ffffffffc0201cd0:	00004617          	auipc	a2,0x4
ffffffffc0201cd4:	75860613          	addi	a2,a2,1880 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0201cd8:	06300593          	li	a1,99
ffffffffc0201cdc:	00005517          	auipc	a0,0x5
ffffffffc0201ce0:	b5450513          	addi	a0,a0,-1196 # ffffffffc0206830 <etext+0xdbc>
ffffffffc0201ce4:	f62fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201ce8 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201ce8:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201cea:	00005517          	auipc	a0,0x5
ffffffffc0201cee:	b5e50513          	addi	a0,a0,-1186 # ffffffffc0206848 <etext+0xdd4>
{
ffffffffc0201cf2:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201cf4:	ca0fe0ef          	jal	ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201cf8:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201cfa:	00005517          	auipc	a0,0x5
ffffffffc0201cfe:	b6650513          	addi	a0,a0,-1178 # ffffffffc0206860 <etext+0xdec>
}
ffffffffc0201d02:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201d04:	c90fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201d08 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201d08:	4501                	li	a0,0
ffffffffc0201d0a:	8082                	ret

ffffffffc0201d0c <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201d0c:	1101                	addi	sp,sp,-32
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d0e:	6685                	lui	a3,0x1
{
ffffffffc0201d10:	ec06                	sd	ra,24(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d12:	16bd                	addi	a3,a3,-17 # fef <_binary_obj___user_softint_out_size-0x7bd9>
ffffffffc0201d14:	04a6f963          	bgeu	a3,a0,ffffffffc0201d66 <kmalloc+0x5a>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201d18:	e42a                	sd	a0,8(sp)
ffffffffc0201d1a:	4561                	li	a0,24
ffffffffc0201d1c:	e822                	sd	s0,16(sp)
ffffffffc0201d1e:	ee1ff0ef          	jal	ffffffffc0201bfe <slob_alloc.constprop.0>
ffffffffc0201d22:	842a                	mv	s0,a0
	if (!bb)
ffffffffc0201d24:	c541                	beqz	a0,ffffffffc0201dac <kmalloc+0xa0>
	bb->order = find_order(size);
ffffffffc0201d26:	47a2                	lw	a5,8(sp)
	for (; size > 4096; size >>= 1)
ffffffffc0201d28:	6705                	lui	a4,0x1
	int order = 0;
ffffffffc0201d2a:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201d2c:	00f75763          	bge	a4,a5,ffffffffc0201d3a <kmalloc+0x2e>
ffffffffc0201d30:	4017d79b          	sraiw	a5,a5,0x1
		order++;
ffffffffc0201d34:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201d36:	fef74de3          	blt	a4,a5,ffffffffc0201d30 <kmalloc+0x24>
	bb->order = find_order(size);
ffffffffc0201d3a:	c008                	sw	a0,0(s0)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201d3c:	e5fff0ef          	jal	ffffffffc0201b9a <__slob_get_free_pages.constprop.0>
ffffffffc0201d40:	e408                	sd	a0,8(s0)
	if (bb->pages)
ffffffffc0201d42:	cd31                	beqz	a0,ffffffffc0201d9e <kmalloc+0x92>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d44:	100027f3          	csrr	a5,sstatus
ffffffffc0201d48:	8b89                	andi	a5,a5,2
ffffffffc0201d4a:	eb85                	bnez	a5,ffffffffc0201d7a <kmalloc+0x6e>
		bb->next = bigblocks;
ffffffffc0201d4c:	000a3797          	auipc	a5,0xa3
ffffffffc0201d50:	2447b783          	ld	a5,580(a5) # ffffffffc02a4f90 <bigblocks>
		bigblocks = bb;
ffffffffc0201d54:	000a3717          	auipc	a4,0xa3
ffffffffc0201d58:	22873e23          	sd	s0,572(a4) # ffffffffc02a4f90 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201d5c:	e81c                	sd	a5,16(s0)
    if (flag)
ffffffffc0201d5e:	6442                	ld	s0,16(sp)
	return __kmalloc(size, 0);
}
ffffffffc0201d60:	60e2                	ld	ra,24(sp)
ffffffffc0201d62:	6105                	addi	sp,sp,32
ffffffffc0201d64:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201d66:	0541                	addi	a0,a0,16
ffffffffc0201d68:	e97ff0ef          	jal	ffffffffc0201bfe <slob_alloc.constprop.0>
ffffffffc0201d6c:	87aa                	mv	a5,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0201d6e:	0541                	addi	a0,a0,16
ffffffffc0201d70:	fbe5                	bnez	a5,ffffffffc0201d60 <kmalloc+0x54>
		return 0;
ffffffffc0201d72:	4501                	li	a0,0
}
ffffffffc0201d74:	60e2                	ld	ra,24(sp)
ffffffffc0201d76:	6105                	addi	sp,sp,32
ffffffffc0201d78:	8082                	ret
        intr_disable();
ffffffffc0201d7a:	b8bfe0ef          	jal	ffffffffc0200904 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201d7e:	000a3797          	auipc	a5,0xa3
ffffffffc0201d82:	2127b783          	ld	a5,530(a5) # ffffffffc02a4f90 <bigblocks>
		bigblocks = bb;
ffffffffc0201d86:	000a3717          	auipc	a4,0xa3
ffffffffc0201d8a:	20873523          	sd	s0,522(a4) # ffffffffc02a4f90 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201d8e:	e81c                	sd	a5,16(s0)
        intr_enable();
ffffffffc0201d90:	b6ffe0ef          	jal	ffffffffc02008fe <intr_enable>
		return bb->pages;
ffffffffc0201d94:	6408                	ld	a0,8(s0)
}
ffffffffc0201d96:	60e2                	ld	ra,24(sp)
		return bb->pages;
ffffffffc0201d98:	6442                	ld	s0,16(sp)
}
ffffffffc0201d9a:	6105                	addi	sp,sp,32
ffffffffc0201d9c:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d9e:	8522                	mv	a0,s0
ffffffffc0201da0:	45e1                	li	a1,24
ffffffffc0201da2:	ce7ff0ef          	jal	ffffffffc0201a88 <slob_free>
		return 0;
ffffffffc0201da6:	4501                	li	a0,0
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201da8:	6442                	ld	s0,16(sp)
ffffffffc0201daa:	b7e9                	j	ffffffffc0201d74 <kmalloc+0x68>
ffffffffc0201dac:	6442                	ld	s0,16(sp)
		return 0;
ffffffffc0201dae:	4501                	li	a0,0
ffffffffc0201db0:	b7d1                	j	ffffffffc0201d74 <kmalloc+0x68>

ffffffffc0201db2 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201db2:	c571                	beqz	a0,ffffffffc0201e7e <kfree+0xcc>
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201db4:	03451793          	slli	a5,a0,0x34
ffffffffc0201db8:	e3e1                	bnez	a5,ffffffffc0201e78 <kfree+0xc6>
{
ffffffffc0201dba:	1101                	addi	sp,sp,-32
ffffffffc0201dbc:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201dbe:	100027f3          	csrr	a5,sstatus
ffffffffc0201dc2:	8b89                	andi	a5,a5,2
ffffffffc0201dc4:	e7c1                	bnez	a5,ffffffffc0201e4c <kfree+0x9a>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201dc6:	000a3797          	auipc	a5,0xa3
ffffffffc0201dca:	1ca7b783          	ld	a5,458(a5) # ffffffffc02a4f90 <bigblocks>
    return 0;
ffffffffc0201dce:	4581                	li	a1,0
ffffffffc0201dd0:	cbad                	beqz	a5,ffffffffc0201e42 <kfree+0x90>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201dd2:	000a3617          	auipc	a2,0xa3
ffffffffc0201dd6:	1be60613          	addi	a2,a2,446 # ffffffffc02a4f90 <bigblocks>
ffffffffc0201dda:	a021                	j	ffffffffc0201de2 <kfree+0x30>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201ddc:	01070613          	addi	a2,a4,16
ffffffffc0201de0:	c3a5                	beqz	a5,ffffffffc0201e40 <kfree+0x8e>
		{
			if (bb->pages == block)
ffffffffc0201de2:	6794                	ld	a3,8(a5)
ffffffffc0201de4:	873e                	mv	a4,a5
			{
				*last = bb->next;
ffffffffc0201de6:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201de8:	fea69ae3          	bne	a3,a0,ffffffffc0201ddc <kfree+0x2a>
				*last = bb->next;
ffffffffc0201dec:	e21c                	sd	a5,0(a2)
    if (flag)
ffffffffc0201dee:	edb5                	bnez	a1,ffffffffc0201e6a <kfree+0xb8>
    return pa2page(PADDR(kva));
ffffffffc0201df0:	c02007b7          	lui	a5,0xc0200
ffffffffc0201df4:	0af56263          	bltu	a0,a5,ffffffffc0201e98 <kfree+0xe6>
ffffffffc0201df8:	000a3797          	auipc	a5,0xa3
ffffffffc0201dfc:	1b87b783          	ld	a5,440(a5) # ffffffffc02a4fb0 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0201e00:	000a3697          	auipc	a3,0xa3
ffffffffc0201e04:	1b86b683          	ld	a3,440(a3) # ffffffffc02a4fb8 <npage>
    return pa2page(PADDR(kva));
ffffffffc0201e08:	8d1d                	sub	a0,a0,a5
    if (PPN(pa) >= npage)
ffffffffc0201e0a:	00c55793          	srli	a5,a0,0xc
ffffffffc0201e0e:	06d7f963          	bgeu	a5,a3,ffffffffc0201e80 <kfree+0xce>
    return &pages[PPN(pa) - nbase];
ffffffffc0201e12:	00006617          	auipc	a2,0x6
ffffffffc0201e16:	e1663603          	ld	a2,-490(a2) # ffffffffc0207c28 <nbase>
ffffffffc0201e1a:	000a3517          	auipc	a0,0xa3
ffffffffc0201e1e:	1a653503          	ld	a0,422(a0) # ffffffffc02a4fc0 <pages>
	free_pages(kva2page((void *)kva), 1 << order);
ffffffffc0201e22:	4314                	lw	a3,0(a4)
ffffffffc0201e24:	8f91                	sub	a5,a5,a2
ffffffffc0201e26:	079a                	slli	a5,a5,0x6
ffffffffc0201e28:	4585                	li	a1,1
ffffffffc0201e2a:	953e                	add	a0,a0,a5
ffffffffc0201e2c:	00d595bb          	sllw	a1,a1,a3
ffffffffc0201e30:	e03a                	sd	a4,0(sp)
ffffffffc0201e32:	0d6000ef          	jal	ffffffffc0201f08 <free_pages>
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e36:	6502                	ld	a0,0(sp)
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201e38:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e3a:	45e1                	li	a1,24
}
ffffffffc0201e3c:	6105                	addi	sp,sp,32
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e3e:	b1a9                	j	ffffffffc0201a88 <slob_free>
ffffffffc0201e40:	e185                	bnez	a1,ffffffffc0201e60 <kfree+0xae>
}
ffffffffc0201e42:	60e2                	ld	ra,24(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e44:	1541                	addi	a0,a0,-16
ffffffffc0201e46:	4581                	li	a1,0
}
ffffffffc0201e48:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e4a:	b93d                	j	ffffffffc0201a88 <slob_free>
        intr_disable();
ffffffffc0201e4c:	e02a                	sd	a0,0(sp)
ffffffffc0201e4e:	ab7fe0ef          	jal	ffffffffc0200904 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e52:	000a3797          	auipc	a5,0xa3
ffffffffc0201e56:	13e7b783          	ld	a5,318(a5) # ffffffffc02a4f90 <bigblocks>
ffffffffc0201e5a:	6502                	ld	a0,0(sp)
        return 1;
ffffffffc0201e5c:	4585                	li	a1,1
ffffffffc0201e5e:	fbb5                	bnez	a5,ffffffffc0201dd2 <kfree+0x20>
ffffffffc0201e60:	e02a                	sd	a0,0(sp)
        intr_enable();
ffffffffc0201e62:	a9dfe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201e66:	6502                	ld	a0,0(sp)
ffffffffc0201e68:	bfe9                	j	ffffffffc0201e42 <kfree+0x90>
ffffffffc0201e6a:	e42a                	sd	a0,8(sp)
ffffffffc0201e6c:	e03a                	sd	a4,0(sp)
ffffffffc0201e6e:	a91fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201e72:	6522                	ld	a0,8(sp)
ffffffffc0201e74:	6702                	ld	a4,0(sp)
ffffffffc0201e76:	bfad                	j	ffffffffc0201df0 <kfree+0x3e>
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e78:	1541                	addi	a0,a0,-16
ffffffffc0201e7a:	4581                	li	a1,0
ffffffffc0201e7c:	b131                	j	ffffffffc0201a88 <slob_free>
ffffffffc0201e7e:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201e80:	00005617          	auipc	a2,0x5
ffffffffc0201e84:	a2860613          	addi	a2,a2,-1496 # ffffffffc02068a8 <etext+0xe34>
ffffffffc0201e88:	06900593          	li	a1,105
ffffffffc0201e8c:	00005517          	auipc	a0,0x5
ffffffffc0201e90:	97450513          	addi	a0,a0,-1676 # ffffffffc0206800 <etext+0xd8c>
ffffffffc0201e94:	db2fe0ef          	jal	ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201e98:	86aa                	mv	a3,a0
ffffffffc0201e9a:	00005617          	auipc	a2,0x5
ffffffffc0201e9e:	9e660613          	addi	a2,a2,-1562 # ffffffffc0206880 <etext+0xe0c>
ffffffffc0201ea2:	07700593          	li	a1,119
ffffffffc0201ea6:	00005517          	auipc	a0,0x5
ffffffffc0201eaa:	95a50513          	addi	a0,a0,-1702 # ffffffffc0206800 <etext+0xd8c>
ffffffffc0201eae:	d98fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201eb2 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201eb2:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201eb4:	00005617          	auipc	a2,0x5
ffffffffc0201eb8:	9f460613          	addi	a2,a2,-1548 # ffffffffc02068a8 <etext+0xe34>
ffffffffc0201ebc:	06900593          	li	a1,105
ffffffffc0201ec0:	00005517          	auipc	a0,0x5
ffffffffc0201ec4:	94050513          	addi	a0,a0,-1728 # ffffffffc0206800 <etext+0xd8c>
pa2page(uintptr_t pa)
ffffffffc0201ec8:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201eca:	d7cfe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201ece <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ece:	100027f3          	csrr	a5,sstatus
ffffffffc0201ed2:	8b89                	andi	a5,a5,2
ffffffffc0201ed4:	e799                	bnez	a5,ffffffffc0201ee2 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ed6:	000a3797          	auipc	a5,0xa3
ffffffffc0201eda:	0c27b783          	ld	a5,194(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc0201ede:	6f9c                	ld	a5,24(a5)
ffffffffc0201ee0:	8782                	jr	a5
{
ffffffffc0201ee2:	1101                	addi	sp,sp,-32
ffffffffc0201ee4:	ec06                	sd	ra,24(sp)
ffffffffc0201ee6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201ee8:	a1dfe0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201eec:	000a3797          	auipc	a5,0xa3
ffffffffc0201ef0:	0ac7b783          	ld	a5,172(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc0201ef4:	6522                	ld	a0,8(sp)
ffffffffc0201ef6:	6f9c                	ld	a5,24(a5)
ffffffffc0201ef8:	9782                	jalr	a5
ffffffffc0201efa:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201efc:	a03fe0ef          	jal	ffffffffc02008fe <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201f00:	60e2                	ld	ra,24(sp)
ffffffffc0201f02:	6522                	ld	a0,8(sp)
ffffffffc0201f04:	6105                	addi	sp,sp,32
ffffffffc0201f06:	8082                	ret

ffffffffc0201f08 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f08:	100027f3          	csrr	a5,sstatus
ffffffffc0201f0c:	8b89                	andi	a5,a5,2
ffffffffc0201f0e:	e799                	bnez	a5,ffffffffc0201f1c <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201f10:	000a3797          	auipc	a5,0xa3
ffffffffc0201f14:	0887b783          	ld	a5,136(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc0201f18:	739c                	ld	a5,32(a5)
ffffffffc0201f1a:	8782                	jr	a5
{
ffffffffc0201f1c:	1101                	addi	sp,sp,-32
ffffffffc0201f1e:	ec06                	sd	ra,24(sp)
ffffffffc0201f20:	e42e                	sd	a1,8(sp)
ffffffffc0201f22:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0201f24:	9e1fe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201f28:	000a3797          	auipc	a5,0xa3
ffffffffc0201f2c:	0707b783          	ld	a5,112(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc0201f30:	65a2                	ld	a1,8(sp)
ffffffffc0201f32:	6502                	ld	a0,0(sp)
ffffffffc0201f34:	739c                	ld	a5,32(a5)
ffffffffc0201f36:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201f38:	60e2                	ld	ra,24(sp)
ffffffffc0201f3a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201f3c:	9c3fe06f          	j	ffffffffc02008fe <intr_enable>

ffffffffc0201f40 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f40:	100027f3          	csrr	a5,sstatus
ffffffffc0201f44:	8b89                	andi	a5,a5,2
ffffffffc0201f46:	e799                	bnez	a5,ffffffffc0201f54 <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f48:	000a3797          	auipc	a5,0xa3
ffffffffc0201f4c:	0507b783          	ld	a5,80(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc0201f50:	779c                	ld	a5,40(a5)
ffffffffc0201f52:	8782                	jr	a5
{
ffffffffc0201f54:	1101                	addi	sp,sp,-32
ffffffffc0201f56:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201f58:	9adfe0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f5c:	000a3797          	auipc	a5,0xa3
ffffffffc0201f60:	03c7b783          	ld	a5,60(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc0201f64:	779c                	ld	a5,40(a5)
ffffffffc0201f66:	9782                	jalr	a5
ffffffffc0201f68:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201f6a:	995fe0ef          	jal	ffffffffc02008fe <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201f6e:	60e2                	ld	ra,24(sp)
ffffffffc0201f70:	6522                	ld	a0,8(sp)
ffffffffc0201f72:	6105                	addi	sp,sp,32
ffffffffc0201f74:	8082                	ret

ffffffffc0201f76 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f76:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201f7a:	1ff7f793          	andi	a5,a5,511
ffffffffc0201f7e:	078e                	slli	a5,a5,0x3
ffffffffc0201f80:	00f50733          	add	a4,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201f84:	6314                	ld	a3,0(a4)
{
ffffffffc0201f86:	7139                	addi	sp,sp,-64
ffffffffc0201f88:	f822                	sd	s0,48(sp)
ffffffffc0201f8a:	f426                	sd	s1,40(sp)
ffffffffc0201f8c:	fc06                	sd	ra,56(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201f8e:	0016f793          	andi	a5,a3,1
{
ffffffffc0201f92:	842e                	mv	s0,a1
ffffffffc0201f94:	8832                	mv	a6,a2
ffffffffc0201f96:	000a3497          	auipc	s1,0xa3
ffffffffc0201f9a:	02248493          	addi	s1,s1,34 # ffffffffc02a4fb8 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201f9e:	ebd1                	bnez	a5,ffffffffc0202032 <get_pte+0xbc>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201fa0:	16060d63          	beqz	a2,ffffffffc020211a <get_pte+0x1a4>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201fa4:	100027f3          	csrr	a5,sstatus
ffffffffc0201fa8:	8b89                	andi	a5,a5,2
ffffffffc0201faa:	16079e63          	bnez	a5,ffffffffc0202126 <get_pte+0x1b0>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201fae:	000a3797          	auipc	a5,0xa3
ffffffffc0201fb2:	fea7b783          	ld	a5,-22(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc0201fb6:	4505                	li	a0,1
ffffffffc0201fb8:	e43a                	sd	a4,8(sp)
ffffffffc0201fba:	6f9c                	ld	a5,24(a5)
ffffffffc0201fbc:	e832                	sd	a2,16(sp)
ffffffffc0201fbe:	9782                	jalr	a5
ffffffffc0201fc0:	6722                	ld	a4,8(sp)
ffffffffc0201fc2:	6842                	ld	a6,16(sp)
ffffffffc0201fc4:	87aa                	mv	a5,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201fc6:	14078a63          	beqz	a5,ffffffffc020211a <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0201fca:	000a3517          	auipc	a0,0xa3
ffffffffc0201fce:	ff653503          	ld	a0,-10(a0) # ffffffffc02a4fc0 <pages>
ffffffffc0201fd2:	000808b7          	lui	a7,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201fd6:	000a3497          	auipc	s1,0xa3
ffffffffc0201fda:	fe248493          	addi	s1,s1,-30 # ffffffffc02a4fb8 <npage>
ffffffffc0201fde:	40a78533          	sub	a0,a5,a0
ffffffffc0201fe2:	8519                	srai	a0,a0,0x6
ffffffffc0201fe4:	9546                	add	a0,a0,a7
ffffffffc0201fe6:	6090                	ld	a2,0(s1)
ffffffffc0201fe8:	00c51693          	slli	a3,a0,0xc
    page->ref = val;
ffffffffc0201fec:	4585                	li	a1,1
ffffffffc0201fee:	82b1                	srli	a3,a3,0xc
ffffffffc0201ff0:	c38c                	sw	a1,0(a5)
    return page2ppn(page) << PGSHIFT;
ffffffffc0201ff2:	0532                	slli	a0,a0,0xc
ffffffffc0201ff4:	1ac6f763          	bgeu	a3,a2,ffffffffc02021a2 <get_pte+0x22c>
ffffffffc0201ff8:	000a3697          	auipc	a3,0xa3
ffffffffc0201ffc:	fb86b683          	ld	a3,-72(a3) # ffffffffc02a4fb0 <va_pa_offset>
ffffffffc0202000:	6605                	lui	a2,0x1
ffffffffc0202002:	4581                	li	a1,0
ffffffffc0202004:	9536                	add	a0,a0,a3
ffffffffc0202006:	ec42                	sd	a6,24(sp)
ffffffffc0202008:	e83e                	sd	a5,16(sp)
ffffffffc020200a:	e43a                	sd	a4,8(sp)
ffffffffc020200c:	23f030ef          	jal	ffffffffc0205a4a <memset>
    return page - pages + nbase;
ffffffffc0202010:	000a3697          	auipc	a3,0xa3
ffffffffc0202014:	fb06b683          	ld	a3,-80(a3) # ffffffffc02a4fc0 <pages>
ffffffffc0202018:	67c2                	ld	a5,16(sp)
ffffffffc020201a:	000808b7          	lui	a7,0x80
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020201e:	6722                	ld	a4,8(sp)
ffffffffc0202020:	40d786b3          	sub	a3,a5,a3
ffffffffc0202024:	8699                	srai	a3,a3,0x6
ffffffffc0202026:	96c6                	add	a3,a3,a7
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202028:	06aa                	slli	a3,a3,0xa
ffffffffc020202a:	6862                	ld	a6,24(sp)
ffffffffc020202c:	0116e693          	ori	a3,a3,17
ffffffffc0202030:	e314                	sd	a3,0(a4)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202032:	c006f693          	andi	a3,a3,-1024
ffffffffc0202036:	6098                	ld	a4,0(s1)
ffffffffc0202038:	068a                	slli	a3,a3,0x2
ffffffffc020203a:	00c6d793          	srli	a5,a3,0xc
ffffffffc020203e:	14e7f663          	bgeu	a5,a4,ffffffffc020218a <get_pte+0x214>
ffffffffc0202042:	000a3897          	auipc	a7,0xa3
ffffffffc0202046:	f6e88893          	addi	a7,a7,-146 # ffffffffc02a4fb0 <va_pa_offset>
ffffffffc020204a:	0008b603          	ld	a2,0(a7)
ffffffffc020204e:	01545793          	srli	a5,s0,0x15
ffffffffc0202052:	1ff7f793          	andi	a5,a5,511
ffffffffc0202056:	96b2                	add	a3,a3,a2
ffffffffc0202058:	078e                	slli	a5,a5,0x3
ffffffffc020205a:	97b6                	add	a5,a5,a3
    if (!(*pdep0 & PTE_V))
ffffffffc020205c:	6394                	ld	a3,0(a5)
ffffffffc020205e:	0016f613          	andi	a2,a3,1
ffffffffc0202062:	e659                	bnez	a2,ffffffffc02020f0 <get_pte+0x17a>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202064:	0a080b63          	beqz	a6,ffffffffc020211a <get_pte+0x1a4>
ffffffffc0202068:	10002773          	csrr	a4,sstatus
ffffffffc020206c:	8b09                	andi	a4,a4,2
ffffffffc020206e:	ef71                	bnez	a4,ffffffffc020214a <get_pte+0x1d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202070:	000a3717          	auipc	a4,0xa3
ffffffffc0202074:	f2873703          	ld	a4,-216(a4) # ffffffffc02a4f98 <pmm_manager>
ffffffffc0202078:	4505                	li	a0,1
ffffffffc020207a:	e43e                	sd	a5,8(sp)
ffffffffc020207c:	6f18                	ld	a4,24(a4)
ffffffffc020207e:	9702                	jalr	a4
ffffffffc0202080:	67a2                	ld	a5,8(sp)
ffffffffc0202082:	872a                	mv	a4,a0
ffffffffc0202084:	000a3897          	auipc	a7,0xa3
ffffffffc0202088:	f2c88893          	addi	a7,a7,-212 # ffffffffc02a4fb0 <va_pa_offset>
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020208c:	c759                	beqz	a4,ffffffffc020211a <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc020208e:	000a3697          	auipc	a3,0xa3
ffffffffc0202092:	f326b683          	ld	a3,-206(a3) # ffffffffc02a4fc0 <pages>
ffffffffc0202096:	00080837          	lui	a6,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020209a:	608c                	ld	a1,0(s1)
ffffffffc020209c:	40d706b3          	sub	a3,a4,a3
ffffffffc02020a0:	8699                	srai	a3,a3,0x6
ffffffffc02020a2:	96c2                	add	a3,a3,a6
ffffffffc02020a4:	00c69613          	slli	a2,a3,0xc
    page->ref = val;
ffffffffc02020a8:	4505                	li	a0,1
ffffffffc02020aa:	8231                	srli	a2,a2,0xc
ffffffffc02020ac:	c308                	sw	a0,0(a4)
    return page2ppn(page) << PGSHIFT;
ffffffffc02020ae:	06b2                	slli	a3,a3,0xc
ffffffffc02020b0:	10b67663          	bgeu	a2,a1,ffffffffc02021bc <get_pte+0x246>
ffffffffc02020b4:	0008b503          	ld	a0,0(a7)
ffffffffc02020b8:	6605                	lui	a2,0x1
ffffffffc02020ba:	4581                	li	a1,0
ffffffffc02020bc:	9536                	add	a0,a0,a3
ffffffffc02020be:	e83a                	sd	a4,16(sp)
ffffffffc02020c0:	e43e                	sd	a5,8(sp)
ffffffffc02020c2:	189030ef          	jal	ffffffffc0205a4a <memset>
    return page - pages + nbase;
ffffffffc02020c6:	000a3697          	auipc	a3,0xa3
ffffffffc02020ca:	efa6b683          	ld	a3,-262(a3) # ffffffffc02a4fc0 <pages>
ffffffffc02020ce:	6742                	ld	a4,16(sp)
ffffffffc02020d0:	00080837          	lui	a6,0x80
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02020d4:	67a2                	ld	a5,8(sp)
ffffffffc02020d6:	40d706b3          	sub	a3,a4,a3
ffffffffc02020da:	8699                	srai	a3,a3,0x6
ffffffffc02020dc:	96c2                	add	a3,a3,a6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02020de:	06aa                	slli	a3,a3,0xa
ffffffffc02020e0:	0116e693          	ori	a3,a3,17
ffffffffc02020e4:	e394                	sd	a3,0(a5)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02020e6:	6098                	ld	a4,0(s1)
ffffffffc02020e8:	000a3897          	auipc	a7,0xa3
ffffffffc02020ec:	ec888893          	addi	a7,a7,-312 # ffffffffc02a4fb0 <va_pa_offset>
ffffffffc02020f0:	c006f693          	andi	a3,a3,-1024
ffffffffc02020f4:	068a                	slli	a3,a3,0x2
ffffffffc02020f6:	00c6d793          	srli	a5,a3,0xc
ffffffffc02020fa:	06e7fc63          	bgeu	a5,a4,ffffffffc0202172 <get_pte+0x1fc>
ffffffffc02020fe:	0008b783          	ld	a5,0(a7)
ffffffffc0202102:	8031                	srli	s0,s0,0xc
ffffffffc0202104:	1ff47413          	andi	s0,s0,511
ffffffffc0202108:	040e                	slli	s0,s0,0x3
ffffffffc020210a:	96be                	add	a3,a3,a5
}
ffffffffc020210c:	70e2                	ld	ra,56(sp)
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020210e:	00868533          	add	a0,a3,s0
}
ffffffffc0202112:	7442                	ld	s0,48(sp)
ffffffffc0202114:	74a2                	ld	s1,40(sp)
ffffffffc0202116:	6121                	addi	sp,sp,64
ffffffffc0202118:	8082                	ret
ffffffffc020211a:	70e2                	ld	ra,56(sp)
ffffffffc020211c:	7442                	ld	s0,48(sp)
ffffffffc020211e:	74a2                	ld	s1,40(sp)
            return NULL;
ffffffffc0202120:	4501                	li	a0,0
}
ffffffffc0202122:	6121                	addi	sp,sp,64
ffffffffc0202124:	8082                	ret
        intr_disable();
ffffffffc0202126:	e83a                	sd	a4,16(sp)
ffffffffc0202128:	ec32                	sd	a2,24(sp)
ffffffffc020212a:	fdafe0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020212e:	000a3797          	auipc	a5,0xa3
ffffffffc0202132:	e6a7b783          	ld	a5,-406(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc0202136:	4505                	li	a0,1
ffffffffc0202138:	6f9c                	ld	a5,24(a5)
ffffffffc020213a:	9782                	jalr	a5
ffffffffc020213c:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc020213e:	fc0fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202142:	6862                	ld	a6,24(sp)
ffffffffc0202144:	6742                	ld	a4,16(sp)
ffffffffc0202146:	67a2                	ld	a5,8(sp)
ffffffffc0202148:	bdbd                	j	ffffffffc0201fc6 <get_pte+0x50>
        intr_disable();
ffffffffc020214a:	e83e                	sd	a5,16(sp)
ffffffffc020214c:	fb8fe0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202150:	000a3717          	auipc	a4,0xa3
ffffffffc0202154:	e4873703          	ld	a4,-440(a4) # ffffffffc02a4f98 <pmm_manager>
ffffffffc0202158:	4505                	li	a0,1
ffffffffc020215a:	6f18                	ld	a4,24(a4)
ffffffffc020215c:	9702                	jalr	a4
ffffffffc020215e:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0202160:	f9efe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202164:	6722                	ld	a4,8(sp)
ffffffffc0202166:	67c2                	ld	a5,16(sp)
ffffffffc0202168:	000a3897          	auipc	a7,0xa3
ffffffffc020216c:	e4888893          	addi	a7,a7,-440 # ffffffffc02a4fb0 <va_pa_offset>
ffffffffc0202170:	bf31                	j	ffffffffc020208c <get_pte+0x116>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202172:	00004617          	auipc	a2,0x4
ffffffffc0202176:	66660613          	addi	a2,a2,1638 # ffffffffc02067d8 <etext+0xd64>
ffffffffc020217a:	0fa00593          	li	a1,250
ffffffffc020217e:	00004517          	auipc	a0,0x4
ffffffffc0202182:	74a50513          	addi	a0,a0,1866 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0202186:	ac0fe0ef          	jal	ffffffffc0200446 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020218a:	00004617          	auipc	a2,0x4
ffffffffc020218e:	64e60613          	addi	a2,a2,1614 # ffffffffc02067d8 <etext+0xd64>
ffffffffc0202192:	0ed00593          	li	a1,237
ffffffffc0202196:	00004517          	auipc	a0,0x4
ffffffffc020219a:	73250513          	addi	a0,a0,1842 # ffffffffc02068c8 <etext+0xe54>
ffffffffc020219e:	aa8fe0ef          	jal	ffffffffc0200446 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02021a2:	86aa                	mv	a3,a0
ffffffffc02021a4:	00004617          	auipc	a2,0x4
ffffffffc02021a8:	63460613          	addi	a2,a2,1588 # ffffffffc02067d8 <etext+0xd64>
ffffffffc02021ac:	0e900593          	li	a1,233
ffffffffc02021b0:	00004517          	auipc	a0,0x4
ffffffffc02021b4:	71850513          	addi	a0,a0,1816 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02021b8:	a8efe0ef          	jal	ffffffffc0200446 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02021bc:	00004617          	auipc	a2,0x4
ffffffffc02021c0:	61c60613          	addi	a2,a2,1564 # ffffffffc02067d8 <etext+0xd64>
ffffffffc02021c4:	0f700593          	li	a1,247
ffffffffc02021c8:	00004517          	auipc	a0,0x4
ffffffffc02021cc:	70050513          	addi	a0,a0,1792 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02021d0:	a76fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02021d4 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc02021d4:	1141                	addi	sp,sp,-16
ffffffffc02021d6:	e022                	sd	s0,0(sp)
ffffffffc02021d8:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02021da:	4601                	li	a2,0
{
ffffffffc02021dc:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02021de:	d99ff0ef          	jal	ffffffffc0201f76 <get_pte>
    if (ptep_store != NULL)
ffffffffc02021e2:	c011                	beqz	s0,ffffffffc02021e6 <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc02021e4:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02021e6:	c511                	beqz	a0,ffffffffc02021f2 <get_page+0x1e>
ffffffffc02021e8:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc02021ea:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02021ec:	0017f713          	andi	a4,a5,1
ffffffffc02021f0:	e709                	bnez	a4,ffffffffc02021fa <get_page+0x26>
}
ffffffffc02021f2:	60a2                	ld	ra,8(sp)
ffffffffc02021f4:	6402                	ld	s0,0(sp)
ffffffffc02021f6:	0141                	addi	sp,sp,16
ffffffffc02021f8:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc02021fa:	000a3717          	auipc	a4,0xa3
ffffffffc02021fe:	dbe73703          	ld	a4,-578(a4) # ffffffffc02a4fb8 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0202202:	078a                	slli	a5,a5,0x2
ffffffffc0202204:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202206:	00e7ff63          	bgeu	a5,a4,ffffffffc0202224 <get_page+0x50>
    return &pages[PPN(pa) - nbase];
ffffffffc020220a:	000a3517          	auipc	a0,0xa3
ffffffffc020220e:	db653503          	ld	a0,-586(a0) # ffffffffc02a4fc0 <pages>
ffffffffc0202212:	60a2                	ld	ra,8(sp)
ffffffffc0202214:	6402                	ld	s0,0(sp)
ffffffffc0202216:	079a                	slli	a5,a5,0x6
ffffffffc0202218:	fe000737          	lui	a4,0xfe000
ffffffffc020221c:	97ba                	add	a5,a5,a4
ffffffffc020221e:	953e                	add	a0,a0,a5
ffffffffc0202220:	0141                	addi	sp,sp,16
ffffffffc0202222:	8082                	ret
ffffffffc0202224:	c8fff0ef          	jal	ffffffffc0201eb2 <pa2page.part.0>

ffffffffc0202228 <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc0202228:	715d                	addi	sp,sp,-80
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020222a:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc020222e:	e486                	sd	ra,72(sp)
ffffffffc0202230:	e0a2                	sd	s0,64(sp)
ffffffffc0202232:	fc26                	sd	s1,56(sp)
ffffffffc0202234:	f84a                	sd	s2,48(sp)
ffffffffc0202236:	f44e                	sd	s3,40(sp)
ffffffffc0202238:	f052                	sd	s4,32(sp)
ffffffffc020223a:	ec56                	sd	s5,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020223c:	03479713          	slli	a4,a5,0x34
ffffffffc0202240:	ef61                	bnez	a4,ffffffffc0202318 <unmap_range+0xf0>
    assert(USER_ACCESS(start, end));
ffffffffc0202242:	00200a37          	lui	s4,0x200
ffffffffc0202246:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc020224a:	0145b733          	sltu	a4,a1,s4
ffffffffc020224e:	0017b793          	seqz	a5,a5
ffffffffc0202252:	8fd9                	or	a5,a5,a4
ffffffffc0202254:	842e                	mv	s0,a1
ffffffffc0202256:	84b2                	mv	s1,a2
ffffffffc0202258:	e3e5                	bnez	a5,ffffffffc0202338 <unmap_range+0x110>
ffffffffc020225a:	4785                	li	a5,1
ffffffffc020225c:	07fe                	slli	a5,a5,0x1f
ffffffffc020225e:	0785                	addi	a5,a5,1
ffffffffc0202260:	892a                	mv	s2,a0
ffffffffc0202262:	6985                	lui	s3,0x1
    do
    {
        pte_t *ptep = get_pte(pgdir, start, 0);
        if (ptep == NULL)
        {
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202264:	ffe00ab7          	lui	s5,0xffe00
    assert(USER_ACCESS(start, end));
ffffffffc0202268:	0cf67863          	bgeu	a2,a5,ffffffffc0202338 <unmap_range+0x110>
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc020226c:	4601                	li	a2,0
ffffffffc020226e:	85a2                	mv	a1,s0
ffffffffc0202270:	854a                	mv	a0,s2
ffffffffc0202272:	d05ff0ef          	jal	ffffffffc0201f76 <get_pte>
ffffffffc0202276:	87aa                	mv	a5,a0
        if (ptep == NULL)
ffffffffc0202278:	cd31                	beqz	a0,ffffffffc02022d4 <unmap_range+0xac>
            continue;
        }
        if (*ptep != 0)
ffffffffc020227a:	6118                	ld	a4,0(a0)
ffffffffc020227c:	ef11                	bnez	a4,ffffffffc0202298 <unmap_range+0x70>
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc020227e:	944e                	add	s0,s0,s3
    } while (start != 0 && start < end);
ffffffffc0202280:	c019                	beqz	s0,ffffffffc0202286 <unmap_range+0x5e>
ffffffffc0202282:	fe9465e3          	bltu	s0,s1,ffffffffc020226c <unmap_range+0x44>
}
ffffffffc0202286:	60a6                	ld	ra,72(sp)
ffffffffc0202288:	6406                	ld	s0,64(sp)
ffffffffc020228a:	74e2                	ld	s1,56(sp)
ffffffffc020228c:	7942                	ld	s2,48(sp)
ffffffffc020228e:	79a2                	ld	s3,40(sp)
ffffffffc0202290:	7a02                	ld	s4,32(sp)
ffffffffc0202292:	6ae2                	ld	s5,24(sp)
ffffffffc0202294:	6161                	addi	sp,sp,80
ffffffffc0202296:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc0202298:	00177693          	andi	a3,a4,1
ffffffffc020229c:	d2ed                	beqz	a3,ffffffffc020227e <unmap_range+0x56>
    if (PPN(pa) >= npage)
ffffffffc020229e:	000a3697          	auipc	a3,0xa3
ffffffffc02022a2:	d1a6b683          	ld	a3,-742(a3) # ffffffffc02a4fb8 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc02022a6:	070a                	slli	a4,a4,0x2
ffffffffc02022a8:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc02022aa:	0ad77763          	bgeu	a4,a3,ffffffffc0202358 <unmap_range+0x130>
    return &pages[PPN(pa) - nbase];
ffffffffc02022ae:	000a3517          	auipc	a0,0xa3
ffffffffc02022b2:	d1253503          	ld	a0,-750(a0) # ffffffffc02a4fc0 <pages>
ffffffffc02022b6:	071a                	slli	a4,a4,0x6
ffffffffc02022b8:	fe0006b7          	lui	a3,0xfe000
ffffffffc02022bc:	9736                	add	a4,a4,a3
ffffffffc02022be:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc02022c0:	4118                	lw	a4,0(a0)
ffffffffc02022c2:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3dd5b017>
ffffffffc02022c4:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc02022c6:	cb19                	beqz	a4,ffffffffc02022dc <unmap_range+0xb4>
        *ptep = 0;
ffffffffc02022c8:	0007b023          	sd	zero,0(a5)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02022cc:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc02022d0:	944e                	add	s0,s0,s3
ffffffffc02022d2:	b77d                	j	ffffffffc0202280 <unmap_range+0x58>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02022d4:	9452                	add	s0,s0,s4
ffffffffc02022d6:	01547433          	and	s0,s0,s5
            continue;
ffffffffc02022da:	b75d                	j	ffffffffc0202280 <unmap_range+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02022dc:	10002773          	csrr	a4,sstatus
ffffffffc02022e0:	8b09                	andi	a4,a4,2
ffffffffc02022e2:	eb19                	bnez	a4,ffffffffc02022f8 <unmap_range+0xd0>
        pmm_manager->free_pages(base, n);
ffffffffc02022e4:	000a3717          	auipc	a4,0xa3
ffffffffc02022e8:	cb473703          	ld	a4,-844(a4) # ffffffffc02a4f98 <pmm_manager>
ffffffffc02022ec:	4585                	li	a1,1
ffffffffc02022ee:	e03e                	sd	a5,0(sp)
ffffffffc02022f0:	7318                	ld	a4,32(a4)
ffffffffc02022f2:	9702                	jalr	a4
    if (flag)
ffffffffc02022f4:	6782                	ld	a5,0(sp)
ffffffffc02022f6:	bfc9                	j	ffffffffc02022c8 <unmap_range+0xa0>
        intr_disable();
ffffffffc02022f8:	e43e                	sd	a5,8(sp)
ffffffffc02022fa:	e02a                	sd	a0,0(sp)
ffffffffc02022fc:	e08fe0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202300:	000a3717          	auipc	a4,0xa3
ffffffffc0202304:	c9873703          	ld	a4,-872(a4) # ffffffffc02a4f98 <pmm_manager>
ffffffffc0202308:	6502                	ld	a0,0(sp)
ffffffffc020230a:	4585                	li	a1,1
ffffffffc020230c:	7318                	ld	a4,32(a4)
ffffffffc020230e:	9702                	jalr	a4
        intr_enable();
ffffffffc0202310:	deefe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202314:	67a2                	ld	a5,8(sp)
ffffffffc0202316:	bf4d                	j	ffffffffc02022c8 <unmap_range+0xa0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202318:	00004697          	auipc	a3,0x4
ffffffffc020231c:	5c068693          	addi	a3,a3,1472 # ffffffffc02068d8 <etext+0xe64>
ffffffffc0202320:	00004617          	auipc	a2,0x4
ffffffffc0202324:	10860613          	addi	a2,a2,264 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0202328:	12000593          	li	a1,288
ffffffffc020232c:	00004517          	auipc	a0,0x4
ffffffffc0202330:	59c50513          	addi	a0,a0,1436 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0202334:	912fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0202338:	00004697          	auipc	a3,0x4
ffffffffc020233c:	5d068693          	addi	a3,a3,1488 # ffffffffc0206908 <etext+0xe94>
ffffffffc0202340:	00004617          	auipc	a2,0x4
ffffffffc0202344:	0e860613          	addi	a2,a2,232 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0202348:	12100593          	li	a1,289
ffffffffc020234c:	00004517          	auipc	a0,0x4
ffffffffc0202350:	57c50513          	addi	a0,a0,1404 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0202354:	8f2fe0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0202358:	b5bff0ef          	jal	ffffffffc0201eb2 <pa2page.part.0>

ffffffffc020235c <exit_range>:
{
ffffffffc020235c:	7135                	addi	sp,sp,-160
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020235e:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202362:	ed06                	sd	ra,152(sp)
ffffffffc0202364:	e922                	sd	s0,144(sp)
ffffffffc0202366:	e526                	sd	s1,136(sp)
ffffffffc0202368:	e14a                	sd	s2,128(sp)
ffffffffc020236a:	fcce                	sd	s3,120(sp)
ffffffffc020236c:	f8d2                	sd	s4,112(sp)
ffffffffc020236e:	f4d6                	sd	s5,104(sp)
ffffffffc0202370:	f0da                	sd	s6,96(sp)
ffffffffc0202372:	ecde                	sd	s7,88(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202374:	17d2                	slli	a5,a5,0x34
ffffffffc0202376:	22079263          	bnez	a5,ffffffffc020259a <exit_range+0x23e>
    assert(USER_ACCESS(start, end));
ffffffffc020237a:	00200937          	lui	s2,0x200
ffffffffc020237e:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc0202382:	0125b733          	sltu	a4,a1,s2
ffffffffc0202386:	0017b793          	seqz	a5,a5
ffffffffc020238a:	8fd9                	or	a5,a5,a4
ffffffffc020238c:	26079263          	bnez	a5,ffffffffc02025f0 <exit_range+0x294>
ffffffffc0202390:	4785                	li	a5,1
ffffffffc0202392:	07fe                	slli	a5,a5,0x1f
ffffffffc0202394:	0785                	addi	a5,a5,1
ffffffffc0202396:	24f67d63          	bgeu	a2,a5,ffffffffc02025f0 <exit_range+0x294>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc020239a:	c00004b7          	lui	s1,0xc0000
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc020239e:	ffe007b7          	lui	a5,0xffe00
ffffffffc02023a2:	8a2a                	mv	s4,a0
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc02023a4:	8ced                	and	s1,s1,a1
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc02023a6:	00f5f833          	and	a6,a1,a5
    if (PPN(pa) >= npage)
ffffffffc02023aa:	000a3a97          	auipc	s5,0xa3
ffffffffc02023ae:	c0ea8a93          	addi	s5,s5,-1010 # ffffffffc02a4fb8 <npage>
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02023b2:	400009b7          	lui	s3,0x40000
ffffffffc02023b6:	a809                	j	ffffffffc02023c8 <exit_range+0x6c>
        d1start += PDSIZE;
ffffffffc02023b8:	013487b3          	add	a5,s1,s3
ffffffffc02023bc:	400004b7          	lui	s1,0x40000
        d0start = d1start;
ffffffffc02023c0:	8826                	mv	a6,s1
    } while (d1start != 0 && d1start < end);
ffffffffc02023c2:	c3f1                	beqz	a5,ffffffffc0202486 <exit_range+0x12a>
ffffffffc02023c4:	0cc7f163          	bgeu	a5,a2,ffffffffc0202486 <exit_range+0x12a>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc02023c8:	01e4d413          	srli	s0,s1,0x1e
ffffffffc02023cc:	1ff47413          	andi	s0,s0,511
ffffffffc02023d0:	040e                	slli	s0,s0,0x3
ffffffffc02023d2:	9452                	add	s0,s0,s4
ffffffffc02023d4:	00043883          	ld	a7,0(s0)
        if (pde1 & PTE_V)
ffffffffc02023d8:	0018f793          	andi	a5,a7,1
ffffffffc02023dc:	dff1                	beqz	a5,ffffffffc02023b8 <exit_range+0x5c>
ffffffffc02023de:	000ab783          	ld	a5,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc02023e2:	088a                	slli	a7,a7,0x2
ffffffffc02023e4:	00c8d893          	srli	a7,a7,0xc
    if (PPN(pa) >= npage)
ffffffffc02023e8:	20f8f263          	bgeu	a7,a5,ffffffffc02025ec <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc02023ec:	fff802b7          	lui	t0,0xfff80
ffffffffc02023f0:	00588f33          	add	t5,a7,t0
    return page - pages + nbase;
ffffffffc02023f4:	000803b7          	lui	t2,0x80
ffffffffc02023f8:	007f0733          	add	a4,t5,t2
    return page2ppn(page) << PGSHIFT;
ffffffffc02023fc:	00c71e13          	slli	t3,a4,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202400:	0f1a                	slli	t5,t5,0x6
    return KADDR(page2pa(page));
ffffffffc0202402:	1cf77863          	bgeu	a4,a5,ffffffffc02025d2 <exit_range+0x276>
ffffffffc0202406:	000a3f97          	auipc	t6,0xa3
ffffffffc020240a:	baaf8f93          	addi	t6,t6,-1110 # ffffffffc02a4fb0 <va_pa_offset>
ffffffffc020240e:	000fb783          	ld	a5,0(t6)
            free_pd0 = 1;
ffffffffc0202412:	4e85                	li	t4,1
ffffffffc0202414:	6b05                	lui	s6,0x1
ffffffffc0202416:	9e3e                	add	t3,t3,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202418:	01348333          	add	t1,s1,s3
                pde0 = pd0[PDX0(d0start)];
ffffffffc020241c:	01585713          	srli	a4,a6,0x15
ffffffffc0202420:	1ff77713          	andi	a4,a4,511
ffffffffc0202424:	070e                	slli	a4,a4,0x3
ffffffffc0202426:	9772                	add	a4,a4,t3
ffffffffc0202428:	631c                	ld	a5,0(a4)
                if (pde0 & PTE_V)
ffffffffc020242a:	0017f693          	andi	a3,a5,1
ffffffffc020242e:	e6bd                	bnez	a3,ffffffffc020249c <exit_range+0x140>
                    free_pd0 = 0;
ffffffffc0202430:	4e81                	li	t4,0
                d0start += PTSIZE;
ffffffffc0202432:	984a                	add	a6,a6,s2
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202434:	00080863          	beqz	a6,ffffffffc0202444 <exit_range+0xe8>
ffffffffc0202438:	879a                	mv	a5,t1
ffffffffc020243a:	00667363          	bgeu	a2,t1,ffffffffc0202440 <exit_range+0xe4>
ffffffffc020243e:	87b2                	mv	a5,a2
ffffffffc0202440:	fcf86ee3          	bltu	a6,a5,ffffffffc020241c <exit_range+0xc0>
            if (free_pd0)
ffffffffc0202444:	f60e8ae3          	beqz	t4,ffffffffc02023b8 <exit_range+0x5c>
    if (PPN(pa) >= npage)
ffffffffc0202448:	000ab783          	ld	a5,0(s5)
ffffffffc020244c:	1af8f063          	bgeu	a7,a5,ffffffffc02025ec <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc0202450:	000a3517          	auipc	a0,0xa3
ffffffffc0202454:	b7053503          	ld	a0,-1168(a0) # ffffffffc02a4fc0 <pages>
ffffffffc0202458:	957a                	add	a0,a0,t5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020245a:	100027f3          	csrr	a5,sstatus
ffffffffc020245e:	8b89                	andi	a5,a5,2
ffffffffc0202460:	10079b63          	bnez	a5,ffffffffc0202576 <exit_range+0x21a>
        pmm_manager->free_pages(base, n);
ffffffffc0202464:	000a3797          	auipc	a5,0xa3
ffffffffc0202468:	b347b783          	ld	a5,-1228(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc020246c:	4585                	li	a1,1
ffffffffc020246e:	e432                	sd	a2,8(sp)
ffffffffc0202470:	739c                	ld	a5,32(a5)
ffffffffc0202472:	9782                	jalr	a5
ffffffffc0202474:	6622                	ld	a2,8(sp)
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202476:	00043023          	sd	zero,0(s0)
        d1start += PDSIZE;
ffffffffc020247a:	013487b3          	add	a5,s1,s3
ffffffffc020247e:	400004b7          	lui	s1,0x40000
        d0start = d1start;
ffffffffc0202482:	8826                	mv	a6,s1
    } while (d1start != 0 && d1start < end);
ffffffffc0202484:	f3a1                	bnez	a5,ffffffffc02023c4 <exit_range+0x68>
}
ffffffffc0202486:	60ea                	ld	ra,152(sp)
ffffffffc0202488:	644a                	ld	s0,144(sp)
ffffffffc020248a:	64aa                	ld	s1,136(sp)
ffffffffc020248c:	690a                	ld	s2,128(sp)
ffffffffc020248e:	79e6                	ld	s3,120(sp)
ffffffffc0202490:	7a46                	ld	s4,112(sp)
ffffffffc0202492:	7aa6                	ld	s5,104(sp)
ffffffffc0202494:	7b06                	ld	s6,96(sp)
ffffffffc0202496:	6be6                	ld	s7,88(sp)
ffffffffc0202498:	610d                	addi	sp,sp,160
ffffffffc020249a:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc020249c:	000ab503          	ld	a0,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc02024a0:	078a                	slli	a5,a5,0x2
ffffffffc02024a2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02024a4:	14a7f463          	bgeu	a5,a0,ffffffffc02025ec <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc02024a8:	9796                	add	a5,a5,t0
    return page - pages + nbase;
ffffffffc02024aa:	00778bb3          	add	s7,a5,t2
    return &pages[PPN(pa) - nbase];
ffffffffc02024ae:	00679593          	slli	a1,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02024b2:	00cb9693          	slli	a3,s7,0xc
    return KADDR(page2pa(page));
ffffffffc02024b6:	10abf263          	bgeu	s7,a0,ffffffffc02025ba <exit_range+0x25e>
ffffffffc02024ba:	000fb783          	ld	a5,0(t6)
ffffffffc02024be:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02024c0:	01668533          	add	a0,a3,s6
                        if (pt[i] & PTE_V)
ffffffffc02024c4:	629c                	ld	a5,0(a3)
ffffffffc02024c6:	8b85                	andi	a5,a5,1
ffffffffc02024c8:	f7ad                	bnez	a5,ffffffffc0202432 <exit_range+0xd6>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02024ca:	06a1                	addi	a3,a3,8
ffffffffc02024cc:	fea69ce3          	bne	a3,a0,ffffffffc02024c4 <exit_range+0x168>
    return &pages[PPN(pa) - nbase];
ffffffffc02024d0:	000a3517          	auipc	a0,0xa3
ffffffffc02024d4:	af053503          	ld	a0,-1296(a0) # ffffffffc02a4fc0 <pages>
ffffffffc02024d8:	952e                	add	a0,a0,a1
ffffffffc02024da:	100027f3          	csrr	a5,sstatus
ffffffffc02024de:	8b89                	andi	a5,a5,2
ffffffffc02024e0:	e3b9                	bnez	a5,ffffffffc0202526 <exit_range+0x1ca>
        pmm_manager->free_pages(base, n);
ffffffffc02024e2:	000a3797          	auipc	a5,0xa3
ffffffffc02024e6:	ab67b783          	ld	a5,-1354(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc02024ea:	4585                	li	a1,1
ffffffffc02024ec:	e0b2                	sd	a2,64(sp)
ffffffffc02024ee:	739c                	ld	a5,32(a5)
ffffffffc02024f0:	fc1a                	sd	t1,56(sp)
ffffffffc02024f2:	f846                	sd	a7,48(sp)
ffffffffc02024f4:	f47a                	sd	t5,40(sp)
ffffffffc02024f6:	f072                	sd	t3,32(sp)
ffffffffc02024f8:	ec76                	sd	t4,24(sp)
ffffffffc02024fa:	e842                	sd	a6,16(sp)
ffffffffc02024fc:	e43a                	sd	a4,8(sp)
ffffffffc02024fe:	9782                	jalr	a5
    if (flag)
ffffffffc0202500:	6722                	ld	a4,8(sp)
ffffffffc0202502:	6842                	ld	a6,16(sp)
ffffffffc0202504:	6ee2                	ld	t4,24(sp)
ffffffffc0202506:	7e02                	ld	t3,32(sp)
ffffffffc0202508:	7f22                	ld	t5,40(sp)
ffffffffc020250a:	78c2                	ld	a7,48(sp)
ffffffffc020250c:	7362                	ld	t1,56(sp)
ffffffffc020250e:	6606                	ld	a2,64(sp)
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202510:	fff802b7          	lui	t0,0xfff80
ffffffffc0202514:	000803b7          	lui	t2,0x80
ffffffffc0202518:	000a3f97          	auipc	t6,0xa3
ffffffffc020251c:	a98f8f93          	addi	t6,t6,-1384 # ffffffffc02a4fb0 <va_pa_offset>
ffffffffc0202520:	00073023          	sd	zero,0(a4)
ffffffffc0202524:	b739                	j	ffffffffc0202432 <exit_range+0xd6>
        intr_disable();
ffffffffc0202526:	e4b2                	sd	a2,72(sp)
ffffffffc0202528:	e09a                	sd	t1,64(sp)
ffffffffc020252a:	fc46                	sd	a7,56(sp)
ffffffffc020252c:	f47a                	sd	t5,40(sp)
ffffffffc020252e:	f072                	sd	t3,32(sp)
ffffffffc0202530:	ec76                	sd	t4,24(sp)
ffffffffc0202532:	e842                	sd	a6,16(sp)
ffffffffc0202534:	e43a                	sd	a4,8(sp)
ffffffffc0202536:	f82a                	sd	a0,48(sp)
ffffffffc0202538:	bccfe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020253c:	000a3797          	auipc	a5,0xa3
ffffffffc0202540:	a5c7b783          	ld	a5,-1444(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc0202544:	7542                	ld	a0,48(sp)
ffffffffc0202546:	4585                	li	a1,1
ffffffffc0202548:	739c                	ld	a5,32(a5)
ffffffffc020254a:	9782                	jalr	a5
        intr_enable();
ffffffffc020254c:	bb2fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202550:	6722                	ld	a4,8(sp)
ffffffffc0202552:	6626                	ld	a2,72(sp)
ffffffffc0202554:	6306                	ld	t1,64(sp)
ffffffffc0202556:	78e2                	ld	a7,56(sp)
ffffffffc0202558:	7f22                	ld	t5,40(sp)
ffffffffc020255a:	7e02                	ld	t3,32(sp)
ffffffffc020255c:	6ee2                	ld	t4,24(sp)
ffffffffc020255e:	6842                	ld	a6,16(sp)
ffffffffc0202560:	000a3f97          	auipc	t6,0xa3
ffffffffc0202564:	a50f8f93          	addi	t6,t6,-1456 # ffffffffc02a4fb0 <va_pa_offset>
ffffffffc0202568:	000803b7          	lui	t2,0x80
ffffffffc020256c:	fff802b7          	lui	t0,0xfff80
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202570:	00073023          	sd	zero,0(a4)
ffffffffc0202574:	bd7d                	j	ffffffffc0202432 <exit_range+0xd6>
        intr_disable();
ffffffffc0202576:	e832                	sd	a2,16(sp)
ffffffffc0202578:	e42a                	sd	a0,8(sp)
ffffffffc020257a:	b8afe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020257e:	000a3797          	auipc	a5,0xa3
ffffffffc0202582:	a1a7b783          	ld	a5,-1510(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc0202586:	6522                	ld	a0,8(sp)
ffffffffc0202588:	4585                	li	a1,1
ffffffffc020258a:	739c                	ld	a5,32(a5)
ffffffffc020258c:	9782                	jalr	a5
        intr_enable();
ffffffffc020258e:	b70fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202592:	6642                	ld	a2,16(sp)
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202594:	00043023          	sd	zero,0(s0)
ffffffffc0202598:	b5cd                	j	ffffffffc020247a <exit_range+0x11e>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020259a:	00004697          	auipc	a3,0x4
ffffffffc020259e:	33e68693          	addi	a3,a3,830 # ffffffffc02068d8 <etext+0xe64>
ffffffffc02025a2:	00004617          	auipc	a2,0x4
ffffffffc02025a6:	e8660613          	addi	a2,a2,-378 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02025aa:	13500593          	li	a1,309
ffffffffc02025ae:	00004517          	auipc	a0,0x4
ffffffffc02025b2:	31a50513          	addi	a0,a0,794 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02025b6:	e91fd0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc02025ba:	00004617          	auipc	a2,0x4
ffffffffc02025be:	21e60613          	addi	a2,a2,542 # ffffffffc02067d8 <etext+0xd64>
ffffffffc02025c2:	07100593          	li	a1,113
ffffffffc02025c6:	00004517          	auipc	a0,0x4
ffffffffc02025ca:	23a50513          	addi	a0,a0,570 # ffffffffc0206800 <etext+0xd8c>
ffffffffc02025ce:	e79fd0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc02025d2:	86f2                	mv	a3,t3
ffffffffc02025d4:	00004617          	auipc	a2,0x4
ffffffffc02025d8:	20460613          	addi	a2,a2,516 # ffffffffc02067d8 <etext+0xd64>
ffffffffc02025dc:	07100593          	li	a1,113
ffffffffc02025e0:	00004517          	auipc	a0,0x4
ffffffffc02025e4:	22050513          	addi	a0,a0,544 # ffffffffc0206800 <etext+0xd8c>
ffffffffc02025e8:	e5ffd0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc02025ec:	8c7ff0ef          	jal	ffffffffc0201eb2 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc02025f0:	00004697          	auipc	a3,0x4
ffffffffc02025f4:	31868693          	addi	a3,a3,792 # ffffffffc0206908 <etext+0xe94>
ffffffffc02025f8:	00004617          	auipc	a2,0x4
ffffffffc02025fc:	e3060613          	addi	a2,a2,-464 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0202600:	13600593          	li	a1,310
ffffffffc0202604:	00004517          	auipc	a0,0x4
ffffffffc0202608:	2c450513          	addi	a0,a0,708 # ffffffffc02068c8 <etext+0xe54>
ffffffffc020260c:	e3bfd0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0202610 <page_remove>:
{
ffffffffc0202610:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202612:	4601                	li	a2,0
{
ffffffffc0202614:	e822                	sd	s0,16(sp)
ffffffffc0202616:	ec06                	sd	ra,24(sp)
ffffffffc0202618:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020261a:	95dff0ef          	jal	ffffffffc0201f76 <get_pte>
    if (ptep != NULL)
ffffffffc020261e:	c511                	beqz	a0,ffffffffc020262a <page_remove+0x1a>
    if (*ptep & PTE_V)
ffffffffc0202620:	6118                	ld	a4,0(a0)
ffffffffc0202622:	87aa                	mv	a5,a0
ffffffffc0202624:	00177693          	andi	a3,a4,1
ffffffffc0202628:	e689                	bnez	a3,ffffffffc0202632 <page_remove+0x22>
}
ffffffffc020262a:	60e2                	ld	ra,24(sp)
ffffffffc020262c:	6442                	ld	s0,16(sp)
ffffffffc020262e:	6105                	addi	sp,sp,32
ffffffffc0202630:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0202632:	000a3697          	auipc	a3,0xa3
ffffffffc0202636:	9866b683          	ld	a3,-1658(a3) # ffffffffc02a4fb8 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc020263a:	070a                	slli	a4,a4,0x2
ffffffffc020263c:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc020263e:	06d77563          	bgeu	a4,a3,ffffffffc02026a8 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202642:	000a3517          	auipc	a0,0xa3
ffffffffc0202646:	97e53503          	ld	a0,-1666(a0) # ffffffffc02a4fc0 <pages>
ffffffffc020264a:	071a                	slli	a4,a4,0x6
ffffffffc020264c:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202650:	9736                	add	a4,a4,a3
ffffffffc0202652:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc0202654:	4118                	lw	a4,0(a0)
ffffffffc0202656:	377d                	addiw	a4,a4,-1
ffffffffc0202658:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc020265a:	cb09                	beqz	a4,ffffffffc020266c <page_remove+0x5c>
        *ptep = 0;
ffffffffc020265c:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202660:	12040073          	sfence.vma	s0
}
ffffffffc0202664:	60e2                	ld	ra,24(sp)
ffffffffc0202666:	6442                	ld	s0,16(sp)
ffffffffc0202668:	6105                	addi	sp,sp,32
ffffffffc020266a:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020266c:	10002773          	csrr	a4,sstatus
ffffffffc0202670:	8b09                	andi	a4,a4,2
ffffffffc0202672:	eb19                	bnez	a4,ffffffffc0202688 <page_remove+0x78>
        pmm_manager->free_pages(base, n);
ffffffffc0202674:	000a3717          	auipc	a4,0xa3
ffffffffc0202678:	92473703          	ld	a4,-1756(a4) # ffffffffc02a4f98 <pmm_manager>
ffffffffc020267c:	4585                	li	a1,1
ffffffffc020267e:	e03e                	sd	a5,0(sp)
ffffffffc0202680:	7318                	ld	a4,32(a4)
ffffffffc0202682:	9702                	jalr	a4
    if (flag)
ffffffffc0202684:	6782                	ld	a5,0(sp)
ffffffffc0202686:	bfd9                	j	ffffffffc020265c <page_remove+0x4c>
        intr_disable();
ffffffffc0202688:	e43e                	sd	a5,8(sp)
ffffffffc020268a:	e02a                	sd	a0,0(sp)
ffffffffc020268c:	a78fe0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202690:	000a3717          	auipc	a4,0xa3
ffffffffc0202694:	90873703          	ld	a4,-1784(a4) # ffffffffc02a4f98 <pmm_manager>
ffffffffc0202698:	6502                	ld	a0,0(sp)
ffffffffc020269a:	4585                	li	a1,1
ffffffffc020269c:	7318                	ld	a4,32(a4)
ffffffffc020269e:	9702                	jalr	a4
        intr_enable();
ffffffffc02026a0:	a5efe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02026a4:	67a2                	ld	a5,8(sp)
ffffffffc02026a6:	bf5d                	j	ffffffffc020265c <page_remove+0x4c>
ffffffffc02026a8:	80bff0ef          	jal	ffffffffc0201eb2 <pa2page.part.0>

ffffffffc02026ac <page_insert>:
{
ffffffffc02026ac:	7139                	addi	sp,sp,-64
ffffffffc02026ae:	f426                	sd	s1,40(sp)
ffffffffc02026b0:	84b2                	mv	s1,a2
ffffffffc02026b2:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02026b4:	4605                	li	a2,1
{
ffffffffc02026b6:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02026b8:	85a6                	mv	a1,s1
{
ffffffffc02026ba:	fc06                	sd	ra,56(sp)
ffffffffc02026bc:	e436                	sd	a3,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02026be:	8b9ff0ef          	jal	ffffffffc0201f76 <get_pte>
    if (ptep == NULL)
ffffffffc02026c2:	cd61                	beqz	a0,ffffffffc020279a <page_insert+0xee>
    page->ref += 1;
ffffffffc02026c4:	400c                	lw	a1,0(s0)
    if (*ptep & PTE_V)
ffffffffc02026c6:	611c                	ld	a5,0(a0)
ffffffffc02026c8:	66a2                	ld	a3,8(sp)
ffffffffc02026ca:	0015861b          	addiw	a2,a1,1 # 1001 <_binary_obj___user_softint_out_size-0x7bc7>
ffffffffc02026ce:	c010                	sw	a2,0(s0)
ffffffffc02026d0:	0017f613          	andi	a2,a5,1
ffffffffc02026d4:	872a                	mv	a4,a0
ffffffffc02026d6:	e61d                	bnez	a2,ffffffffc0202704 <page_insert+0x58>
    return &pages[PPN(pa) - nbase];
ffffffffc02026d8:	000a3617          	auipc	a2,0xa3
ffffffffc02026dc:	8e863603          	ld	a2,-1816(a2) # ffffffffc02a4fc0 <pages>
    return page - pages + nbase;
ffffffffc02026e0:	8c11                	sub	s0,s0,a2
ffffffffc02026e2:	8419                	srai	s0,s0,0x6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02026e4:	200007b7          	lui	a5,0x20000
ffffffffc02026e8:	042a                	slli	s0,s0,0xa
ffffffffc02026ea:	943e                	add	s0,s0,a5
ffffffffc02026ec:	8ec1                	or	a3,a3,s0
ffffffffc02026ee:	0016e693          	ori	a3,a3,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02026f2:	e314                	sd	a3,0(a4)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02026f4:	12048073          	sfence.vma	s1
    return 0;
ffffffffc02026f8:	4501                	li	a0,0
}
ffffffffc02026fa:	70e2                	ld	ra,56(sp)
ffffffffc02026fc:	7442                	ld	s0,48(sp)
ffffffffc02026fe:	74a2                	ld	s1,40(sp)
ffffffffc0202700:	6121                	addi	sp,sp,64
ffffffffc0202702:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0202704:	000a3617          	auipc	a2,0xa3
ffffffffc0202708:	8b463603          	ld	a2,-1868(a2) # ffffffffc02a4fb8 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc020270c:	078a                	slli	a5,a5,0x2
ffffffffc020270e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202710:	08c7f763          	bgeu	a5,a2,ffffffffc020279e <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0202714:	000a3617          	auipc	a2,0xa3
ffffffffc0202718:	8ac63603          	ld	a2,-1876(a2) # ffffffffc02a4fc0 <pages>
ffffffffc020271c:	fe000537          	lui	a0,0xfe000
ffffffffc0202720:	079a                	slli	a5,a5,0x6
ffffffffc0202722:	97aa                	add	a5,a5,a0
ffffffffc0202724:	00f60533          	add	a0,a2,a5
        if (p == page)
ffffffffc0202728:	00a40963          	beq	s0,a0,ffffffffc020273a <page_insert+0x8e>
    page->ref -= 1;
ffffffffc020272c:	411c                	lw	a5,0(a0)
ffffffffc020272e:	37fd                	addiw	a5,a5,-1 # 1fffffff <_binary_obj___user_exit_out_size+0x1fff5e3f>
ffffffffc0202730:	c11c                	sw	a5,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202732:	c791                	beqz	a5,ffffffffc020273e <page_insert+0x92>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202734:	12048073          	sfence.vma	s1
}
ffffffffc0202738:	b765                	j	ffffffffc02026e0 <page_insert+0x34>
ffffffffc020273a:	c00c                	sw	a1,0(s0)
    return page->ref;
ffffffffc020273c:	b755                	j	ffffffffc02026e0 <page_insert+0x34>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020273e:	100027f3          	csrr	a5,sstatus
ffffffffc0202742:	8b89                	andi	a5,a5,2
ffffffffc0202744:	e39d                	bnez	a5,ffffffffc020276a <page_insert+0xbe>
        pmm_manager->free_pages(base, n);
ffffffffc0202746:	000a3797          	auipc	a5,0xa3
ffffffffc020274a:	8527b783          	ld	a5,-1966(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc020274e:	4585                	li	a1,1
ffffffffc0202750:	e83a                	sd	a4,16(sp)
ffffffffc0202752:	739c                	ld	a5,32(a5)
ffffffffc0202754:	e436                	sd	a3,8(sp)
ffffffffc0202756:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202758:	000a3617          	auipc	a2,0xa3
ffffffffc020275c:	86863603          	ld	a2,-1944(a2) # ffffffffc02a4fc0 <pages>
ffffffffc0202760:	66a2                	ld	a3,8(sp)
ffffffffc0202762:	6742                	ld	a4,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202764:	12048073          	sfence.vma	s1
ffffffffc0202768:	bfa5                	j	ffffffffc02026e0 <page_insert+0x34>
        intr_disable();
ffffffffc020276a:	ec3a                	sd	a4,24(sp)
ffffffffc020276c:	e836                	sd	a3,16(sp)
ffffffffc020276e:	e42a                	sd	a0,8(sp)
ffffffffc0202770:	994fe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202774:	000a3797          	auipc	a5,0xa3
ffffffffc0202778:	8247b783          	ld	a5,-2012(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc020277c:	6522                	ld	a0,8(sp)
ffffffffc020277e:	4585                	li	a1,1
ffffffffc0202780:	739c                	ld	a5,32(a5)
ffffffffc0202782:	9782                	jalr	a5
        intr_enable();
ffffffffc0202784:	97afe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202788:	000a3617          	auipc	a2,0xa3
ffffffffc020278c:	83863603          	ld	a2,-1992(a2) # ffffffffc02a4fc0 <pages>
ffffffffc0202790:	6762                	ld	a4,24(sp)
ffffffffc0202792:	66c2                	ld	a3,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202794:	12048073          	sfence.vma	s1
ffffffffc0202798:	b7a1                	j	ffffffffc02026e0 <page_insert+0x34>
        return -E_NO_MEM;
ffffffffc020279a:	5571                	li	a0,-4
ffffffffc020279c:	bfb9                	j	ffffffffc02026fa <page_insert+0x4e>
ffffffffc020279e:	f14ff0ef          	jal	ffffffffc0201eb2 <pa2page.part.0>

ffffffffc02027a2 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc02027a2:	00005797          	auipc	a5,0x5
ffffffffc02027a6:	12e78793          	addi	a5,a5,302 # ffffffffc02078d0 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02027aa:	638c                	ld	a1,0(a5)
{
ffffffffc02027ac:	7159                	addi	sp,sp,-112
ffffffffc02027ae:	f486                	sd	ra,104(sp)
ffffffffc02027b0:	e8ca                	sd	s2,80(sp)
ffffffffc02027b2:	e4ce                	sd	s3,72(sp)
ffffffffc02027b4:	f85a                	sd	s6,48(sp)
ffffffffc02027b6:	f0a2                	sd	s0,96(sp)
ffffffffc02027b8:	eca6                	sd	s1,88(sp)
ffffffffc02027ba:	e0d2                	sd	s4,64(sp)
ffffffffc02027bc:	fc56                	sd	s5,56(sp)
ffffffffc02027be:	f45e                	sd	s7,40(sp)
ffffffffc02027c0:	f062                	sd	s8,32(sp)
ffffffffc02027c2:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc02027c4:	000a2b17          	auipc	s6,0xa2
ffffffffc02027c8:	7d4b0b13          	addi	s6,s6,2004 # ffffffffc02a4f98 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02027cc:	00004517          	auipc	a0,0x4
ffffffffc02027d0:	15450513          	addi	a0,a0,340 # ffffffffc0206920 <etext+0xeac>
    pmm_manager = &default_pmm_manager;
ffffffffc02027d4:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02027d8:	9bdfd0ef          	jal	ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc02027dc:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02027e0:	000a2997          	auipc	s3,0xa2
ffffffffc02027e4:	7d098993          	addi	s3,s3,2000 # ffffffffc02a4fb0 <va_pa_offset>
    pmm_manager->init();
ffffffffc02027e8:	679c                	ld	a5,8(a5)
ffffffffc02027ea:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02027ec:	57f5                	li	a5,-3
ffffffffc02027ee:	07fa                	slli	a5,a5,0x1e
ffffffffc02027f0:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc02027f4:	8f6fe0ef          	jal	ffffffffc02008ea <get_memory_base>
ffffffffc02027f8:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc02027fa:	8fafe0ef          	jal	ffffffffc02008f4 <get_memory_size>
    if (mem_size == 0)
ffffffffc02027fe:	70050e63          	beqz	a0,ffffffffc0202f1a <pmm_init+0x778>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202802:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202804:	00004517          	auipc	a0,0x4
ffffffffc0202808:	15450513          	addi	a0,a0,340 # ffffffffc0206958 <etext+0xee4>
ffffffffc020280c:	989fd0ef          	jal	ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202810:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202814:	864a                	mv	a2,s2
ffffffffc0202816:	85a6                	mv	a1,s1
ffffffffc0202818:	fff40693          	addi	a3,s0,-1
ffffffffc020281c:	00004517          	auipc	a0,0x4
ffffffffc0202820:	15450513          	addi	a0,a0,340 # ffffffffc0206970 <etext+0xefc>
ffffffffc0202824:	971fd0ef          	jal	ffffffffc0200194 <cprintf>
    if (maxpa > KERNTOP)
ffffffffc0202828:	c80007b7          	lui	a5,0xc8000
ffffffffc020282c:	8522                	mv	a0,s0
ffffffffc020282e:	5287ed63          	bltu	a5,s0,ffffffffc0202d68 <pmm_init+0x5c6>
ffffffffc0202832:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202834:	000a3617          	auipc	a2,0xa3
ffffffffc0202838:	7b360613          	addi	a2,a2,1971 # ffffffffc02a5fe7 <end+0xfff>
ffffffffc020283c:	8e7d                	and	a2,a2,a5
    npage = maxpa / PGSIZE;
ffffffffc020283e:	8131                	srli	a0,a0,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202840:	000a2b97          	auipc	s7,0xa2
ffffffffc0202844:	780b8b93          	addi	s7,s7,1920 # ffffffffc02a4fc0 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202848:	000a2497          	auipc	s1,0xa2
ffffffffc020284c:	77048493          	addi	s1,s1,1904 # ffffffffc02a4fb8 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202850:	00cbb023          	sd	a2,0(s7)
    npage = maxpa / PGSIZE;
ffffffffc0202854:	e088                	sd	a0,0(s1)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202856:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020285a:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020285c:	02f50763          	beq	a0,a5,ffffffffc020288a <pmm_init+0xe8>
ffffffffc0202860:	4701                	li	a4,0
ffffffffc0202862:	4585                	li	a1,1
ffffffffc0202864:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0202868:	00671793          	slli	a5,a4,0x6
ffffffffc020286c:	97b2                	add	a5,a5,a2
ffffffffc020286e:	07a1                	addi	a5,a5,8 # 80008 <_binary_obj___user_exit_out_size+0x75e48>
ffffffffc0202870:	40b7b02f          	amoor.d	zero,a1,(a5)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202874:	6088                	ld	a0,0(s1)
ffffffffc0202876:	0705                	addi	a4,a4,1
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202878:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020287c:	00d507b3          	add	a5,a0,a3
ffffffffc0202880:	fef764e3          	bltu	a4,a5,ffffffffc0202868 <pmm_init+0xc6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202884:	079a                	slli	a5,a5,0x6
ffffffffc0202886:	00f606b3          	add	a3,a2,a5
ffffffffc020288a:	c02007b7          	lui	a5,0xc0200
ffffffffc020288e:	16f6eee3          	bltu	a3,a5,ffffffffc020320a <pmm_init+0xa68>
ffffffffc0202892:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0202896:	77fd                	lui	a5,0xfffff
ffffffffc0202898:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020289a:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc020289c:	4e86ed63          	bltu	a3,s0,ffffffffc0202d96 <pmm_init+0x5f4>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc02028a0:	00004517          	auipc	a0,0x4
ffffffffc02028a4:	0f850513          	addi	a0,a0,248 # ffffffffc0206998 <etext+0xf24>
ffffffffc02028a8:	8edfd0ef          	jal	ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc02028ac:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02028b0:	000a2917          	auipc	s2,0xa2
ffffffffc02028b4:	6f890913          	addi	s2,s2,1784 # ffffffffc02a4fa8 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc02028b8:	7b9c                	ld	a5,48(a5)
ffffffffc02028ba:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02028bc:	00004517          	auipc	a0,0x4
ffffffffc02028c0:	0f450513          	addi	a0,a0,244 # ffffffffc02069b0 <etext+0xf3c>
ffffffffc02028c4:	8d1fd0ef          	jal	ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02028c8:	00007697          	auipc	a3,0x7
ffffffffc02028cc:	73868693          	addi	a3,a3,1848 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc02028d0:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02028d4:	c02007b7          	lui	a5,0xc0200
ffffffffc02028d8:	2af6eee3          	bltu	a3,a5,ffffffffc0203394 <pmm_init+0xbf2>
ffffffffc02028dc:	0009b783          	ld	a5,0(s3)
ffffffffc02028e0:	8e9d                	sub	a3,a3,a5
ffffffffc02028e2:	000a2797          	auipc	a5,0xa2
ffffffffc02028e6:	6ad7bf23          	sd	a3,1726(a5) # ffffffffc02a4fa0 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02028ea:	100027f3          	csrr	a5,sstatus
ffffffffc02028ee:	8b89                	andi	a5,a5,2
ffffffffc02028f0:	48079963          	bnez	a5,ffffffffc0202d82 <pmm_init+0x5e0>
        ret = pmm_manager->nr_free_pages();
ffffffffc02028f4:	000b3783          	ld	a5,0(s6)
ffffffffc02028f8:	779c                	ld	a5,40(a5)
ffffffffc02028fa:	9782                	jalr	a5
ffffffffc02028fc:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02028fe:	6098                	ld	a4,0(s1)
ffffffffc0202900:	c80007b7          	lui	a5,0xc8000
ffffffffc0202904:	83b1                	srli	a5,a5,0xc
ffffffffc0202906:	66e7e663          	bltu	a5,a4,ffffffffc0202f72 <pmm_init+0x7d0>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc020290a:	00093503          	ld	a0,0(s2)
ffffffffc020290e:	64050263          	beqz	a0,ffffffffc0202f52 <pmm_init+0x7b0>
ffffffffc0202912:	03451793          	slli	a5,a0,0x34
ffffffffc0202916:	62079e63          	bnez	a5,ffffffffc0202f52 <pmm_init+0x7b0>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc020291a:	4601                	li	a2,0
ffffffffc020291c:	4581                	li	a1,0
ffffffffc020291e:	8b7ff0ef          	jal	ffffffffc02021d4 <get_page>
ffffffffc0202922:	240519e3          	bnez	a0,ffffffffc0203374 <pmm_init+0xbd2>
ffffffffc0202926:	100027f3          	csrr	a5,sstatus
ffffffffc020292a:	8b89                	andi	a5,a5,2
ffffffffc020292c:	44079063          	bnez	a5,ffffffffc0202d6c <pmm_init+0x5ca>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202930:	000b3783          	ld	a5,0(s6)
ffffffffc0202934:	4505                	li	a0,1
ffffffffc0202936:	6f9c                	ld	a5,24(a5)
ffffffffc0202938:	9782                	jalr	a5
ffffffffc020293a:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc020293c:	00093503          	ld	a0,0(s2)
ffffffffc0202940:	4681                	li	a3,0
ffffffffc0202942:	4601                	li	a2,0
ffffffffc0202944:	85d2                	mv	a1,s4
ffffffffc0202946:	d67ff0ef          	jal	ffffffffc02026ac <page_insert>
ffffffffc020294a:	280511e3          	bnez	a0,ffffffffc02033cc <pmm_init+0xc2a>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc020294e:	00093503          	ld	a0,0(s2)
ffffffffc0202952:	4601                	li	a2,0
ffffffffc0202954:	4581                	li	a1,0
ffffffffc0202956:	e20ff0ef          	jal	ffffffffc0201f76 <get_pte>
ffffffffc020295a:	240509e3          	beqz	a0,ffffffffc02033ac <pmm_init+0xc0a>
    assert(pte2page(*ptep) == p1);
ffffffffc020295e:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202960:	0017f713          	andi	a4,a5,1
ffffffffc0202964:	58070f63          	beqz	a4,ffffffffc0202f02 <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc0202968:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc020296a:	078a                	slli	a5,a5,0x2
ffffffffc020296c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020296e:	58e7f863          	bgeu	a5,a4,ffffffffc0202efe <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202972:	000bb683          	ld	a3,0(s7)
ffffffffc0202976:	079a                	slli	a5,a5,0x6
ffffffffc0202978:	fe000637          	lui	a2,0xfe000
ffffffffc020297c:	97b2                	add	a5,a5,a2
ffffffffc020297e:	97b6                	add	a5,a5,a3
ffffffffc0202980:	14fa1ae3          	bne	s4,a5,ffffffffc02032d4 <pmm_init+0xb32>
    assert(page_ref(p1) == 1);
ffffffffc0202984:	000a2683          	lw	a3,0(s4) # 200000 <_binary_obj___user_exit_out_size+0x1f5e40>
ffffffffc0202988:	4785                	li	a5,1
ffffffffc020298a:	12f695e3          	bne	a3,a5,ffffffffc02032b4 <pmm_init+0xb12>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020298e:	00093503          	ld	a0,0(s2)
ffffffffc0202992:	77fd                	lui	a5,0xfffff
ffffffffc0202994:	6114                	ld	a3,0(a0)
ffffffffc0202996:	068a                	slli	a3,a3,0x2
ffffffffc0202998:	8efd                	and	a3,a3,a5
ffffffffc020299a:	00c6d613          	srli	a2,a3,0xc
ffffffffc020299e:	0ee67fe3          	bgeu	a2,a4,ffffffffc020329c <pmm_init+0xafa>
ffffffffc02029a2:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02029a6:	96e2                	add	a3,a3,s8
ffffffffc02029a8:	0006ba83          	ld	s5,0(a3)
ffffffffc02029ac:	0a8a                	slli	s5,s5,0x2
ffffffffc02029ae:	00fafab3          	and	s5,s5,a5
ffffffffc02029b2:	00cad793          	srli	a5,s5,0xc
ffffffffc02029b6:	0ce7f6e3          	bgeu	a5,a4,ffffffffc0203282 <pmm_init+0xae0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02029ba:	4601                	li	a2,0
ffffffffc02029bc:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02029be:	9c56                	add	s8,s8,s5
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02029c0:	db6ff0ef          	jal	ffffffffc0201f76 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02029c4:	0c21                	addi	s8,s8,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02029c6:	05851ee3          	bne	a0,s8,ffffffffc0203222 <pmm_init+0xa80>
ffffffffc02029ca:	100027f3          	csrr	a5,sstatus
ffffffffc02029ce:	8b89                	andi	a5,a5,2
ffffffffc02029d0:	3e079b63          	bnez	a5,ffffffffc0202dc6 <pmm_init+0x624>
        page = pmm_manager->alloc_pages(n);
ffffffffc02029d4:	000b3783          	ld	a5,0(s6)
ffffffffc02029d8:	4505                	li	a0,1
ffffffffc02029da:	6f9c                	ld	a5,24(a5)
ffffffffc02029dc:	9782                	jalr	a5
ffffffffc02029de:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02029e0:	00093503          	ld	a0,0(s2)
ffffffffc02029e4:	46d1                	li	a3,20
ffffffffc02029e6:	6605                	lui	a2,0x1
ffffffffc02029e8:	85e2                	mv	a1,s8
ffffffffc02029ea:	cc3ff0ef          	jal	ffffffffc02026ac <page_insert>
ffffffffc02029ee:	06051ae3          	bnez	a0,ffffffffc0203262 <pmm_init+0xac0>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02029f2:	00093503          	ld	a0,0(s2)
ffffffffc02029f6:	4601                	li	a2,0
ffffffffc02029f8:	6585                	lui	a1,0x1
ffffffffc02029fa:	d7cff0ef          	jal	ffffffffc0201f76 <get_pte>
ffffffffc02029fe:	040502e3          	beqz	a0,ffffffffc0203242 <pmm_init+0xaa0>
    assert(*ptep & PTE_U);
ffffffffc0202a02:	611c                	ld	a5,0(a0)
ffffffffc0202a04:	0107f713          	andi	a4,a5,16
ffffffffc0202a08:	7e070163          	beqz	a4,ffffffffc02031ea <pmm_init+0xa48>
    assert(*ptep & PTE_W);
ffffffffc0202a0c:	8b91                	andi	a5,a5,4
ffffffffc0202a0e:	7a078e63          	beqz	a5,ffffffffc02031ca <pmm_init+0xa28>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202a12:	00093503          	ld	a0,0(s2)
ffffffffc0202a16:	611c                	ld	a5,0(a0)
ffffffffc0202a18:	8bc1                	andi	a5,a5,16
ffffffffc0202a1a:	78078863          	beqz	a5,ffffffffc02031aa <pmm_init+0xa08>
    assert(page_ref(p2) == 1);
ffffffffc0202a1e:	000c2703          	lw	a4,0(s8)
ffffffffc0202a22:	4785                	li	a5,1
ffffffffc0202a24:	76f71363          	bne	a4,a5,ffffffffc020318a <pmm_init+0x9e8>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202a28:	4681                	li	a3,0
ffffffffc0202a2a:	6605                	lui	a2,0x1
ffffffffc0202a2c:	85d2                	mv	a1,s4
ffffffffc0202a2e:	c7fff0ef          	jal	ffffffffc02026ac <page_insert>
ffffffffc0202a32:	72051c63          	bnez	a0,ffffffffc020316a <pmm_init+0x9c8>
    assert(page_ref(p1) == 2);
ffffffffc0202a36:	000a2703          	lw	a4,0(s4)
ffffffffc0202a3a:	4789                	li	a5,2
ffffffffc0202a3c:	70f71763          	bne	a4,a5,ffffffffc020314a <pmm_init+0x9a8>
    assert(page_ref(p2) == 0);
ffffffffc0202a40:	000c2783          	lw	a5,0(s8)
ffffffffc0202a44:	6e079363          	bnez	a5,ffffffffc020312a <pmm_init+0x988>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202a48:	00093503          	ld	a0,0(s2)
ffffffffc0202a4c:	4601                	li	a2,0
ffffffffc0202a4e:	6585                	lui	a1,0x1
ffffffffc0202a50:	d26ff0ef          	jal	ffffffffc0201f76 <get_pte>
ffffffffc0202a54:	6a050b63          	beqz	a0,ffffffffc020310a <pmm_init+0x968>
    assert(pte2page(*ptep) == p1);
ffffffffc0202a58:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202a5a:	00177793          	andi	a5,a4,1
ffffffffc0202a5e:	4a078263          	beqz	a5,ffffffffc0202f02 <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc0202a62:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202a64:	00271793          	slli	a5,a4,0x2
ffffffffc0202a68:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a6a:	48d7fa63          	bgeu	a5,a3,ffffffffc0202efe <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a6e:	000bb683          	ld	a3,0(s7)
ffffffffc0202a72:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202a76:	97d6                	add	a5,a5,s5
ffffffffc0202a78:	079a                	slli	a5,a5,0x6
ffffffffc0202a7a:	97b6                	add	a5,a5,a3
ffffffffc0202a7c:	66fa1763          	bne	s4,a5,ffffffffc02030ea <pmm_init+0x948>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202a80:	8b41                	andi	a4,a4,16
ffffffffc0202a82:	64071463          	bnez	a4,ffffffffc02030ca <pmm_init+0x928>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202a86:	00093503          	ld	a0,0(s2)
ffffffffc0202a8a:	4581                	li	a1,0
ffffffffc0202a8c:	b85ff0ef          	jal	ffffffffc0202610 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202a90:	000a2c83          	lw	s9,0(s4)
ffffffffc0202a94:	4785                	li	a5,1
ffffffffc0202a96:	60fc9a63          	bne	s9,a5,ffffffffc02030aa <pmm_init+0x908>
    assert(page_ref(p2) == 0);
ffffffffc0202a9a:	000c2783          	lw	a5,0(s8)
ffffffffc0202a9e:	5e079663          	bnez	a5,ffffffffc020308a <pmm_init+0x8e8>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202aa2:	00093503          	ld	a0,0(s2)
ffffffffc0202aa6:	6585                	lui	a1,0x1
ffffffffc0202aa8:	b69ff0ef          	jal	ffffffffc0202610 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202aac:	000a2783          	lw	a5,0(s4)
ffffffffc0202ab0:	52079d63          	bnez	a5,ffffffffc0202fea <pmm_init+0x848>
    assert(page_ref(p2) == 0);
ffffffffc0202ab4:	000c2783          	lw	a5,0(s8)
ffffffffc0202ab8:	50079963          	bnez	a5,ffffffffc0202fca <pmm_init+0x828>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202abc:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202ac0:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ac2:	000a3783          	ld	a5,0(s4)
ffffffffc0202ac6:	078a                	slli	a5,a5,0x2
ffffffffc0202ac8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202aca:	42e7fa63          	bgeu	a5,a4,ffffffffc0202efe <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ace:	000bb503          	ld	a0,0(s7)
ffffffffc0202ad2:	97d6                	add	a5,a5,s5
ffffffffc0202ad4:	079a                	slli	a5,a5,0x6
    return page->ref;
ffffffffc0202ad6:	00f506b3          	add	a3,a0,a5
ffffffffc0202ada:	4294                	lw	a3,0(a3)
ffffffffc0202adc:	4d969763          	bne	a3,s9,ffffffffc0202faa <pmm_init+0x808>
    return page - pages + nbase;
ffffffffc0202ae0:	8799                	srai	a5,a5,0x6
ffffffffc0202ae2:	00080637          	lui	a2,0x80
ffffffffc0202ae6:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202ae8:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202aec:	4ae7f363          	bgeu	a5,a4,ffffffffc0202f92 <pmm_init+0x7f0>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202af0:	0009b783          	ld	a5,0(s3)
ffffffffc0202af4:	97b6                	add	a5,a5,a3
    return pa2page(PDE_ADDR(pde));
ffffffffc0202af6:	639c                	ld	a5,0(a5)
ffffffffc0202af8:	078a                	slli	a5,a5,0x2
ffffffffc0202afa:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202afc:	40e7f163          	bgeu	a5,a4,ffffffffc0202efe <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b00:	8f91                	sub	a5,a5,a2
ffffffffc0202b02:	079a                	slli	a5,a5,0x6
ffffffffc0202b04:	953e                	add	a0,a0,a5
ffffffffc0202b06:	100027f3          	csrr	a5,sstatus
ffffffffc0202b0a:	8b89                	andi	a5,a5,2
ffffffffc0202b0c:	30079863          	bnez	a5,ffffffffc0202e1c <pmm_init+0x67a>
        pmm_manager->free_pages(base, n);
ffffffffc0202b10:	000b3783          	ld	a5,0(s6)
ffffffffc0202b14:	4585                	li	a1,1
ffffffffc0202b16:	739c                	ld	a5,32(a5)
ffffffffc0202b18:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b1a:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202b1e:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b20:	078a                	slli	a5,a5,0x2
ffffffffc0202b22:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b24:	3ce7fd63          	bgeu	a5,a4,ffffffffc0202efe <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b28:	000bb503          	ld	a0,0(s7)
ffffffffc0202b2c:	fe000737          	lui	a4,0xfe000
ffffffffc0202b30:	079a                	slli	a5,a5,0x6
ffffffffc0202b32:	97ba                	add	a5,a5,a4
ffffffffc0202b34:	953e                	add	a0,a0,a5
ffffffffc0202b36:	100027f3          	csrr	a5,sstatus
ffffffffc0202b3a:	8b89                	andi	a5,a5,2
ffffffffc0202b3c:	2c079463          	bnez	a5,ffffffffc0202e04 <pmm_init+0x662>
ffffffffc0202b40:	000b3783          	ld	a5,0(s6)
ffffffffc0202b44:	4585                	li	a1,1
ffffffffc0202b46:	739c                	ld	a5,32(a5)
ffffffffc0202b48:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202b4a:	00093783          	ld	a5,0(s2)
ffffffffc0202b4e:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd5a018>
    asm volatile("sfence.vma");
ffffffffc0202b52:	12000073          	sfence.vma
ffffffffc0202b56:	100027f3          	csrr	a5,sstatus
ffffffffc0202b5a:	8b89                	andi	a5,a5,2
ffffffffc0202b5c:	28079a63          	bnez	a5,ffffffffc0202df0 <pmm_init+0x64e>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b60:	000b3783          	ld	a5,0(s6)
ffffffffc0202b64:	779c                	ld	a5,40(a5)
ffffffffc0202b66:	9782                	jalr	a5
ffffffffc0202b68:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202b6a:	4d441063          	bne	s0,s4,ffffffffc020302a <pmm_init+0x888>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202b6e:	00004517          	auipc	a0,0x4
ffffffffc0202b72:	19250513          	addi	a0,a0,402 # ffffffffc0206d00 <etext+0x128c>
ffffffffc0202b76:	e1efd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0202b7a:	100027f3          	csrr	a5,sstatus
ffffffffc0202b7e:	8b89                	andi	a5,a5,2
ffffffffc0202b80:	24079e63          	bnez	a5,ffffffffc0202ddc <pmm_init+0x63a>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b84:	000b3783          	ld	a5,0(s6)
ffffffffc0202b88:	779c                	ld	a5,40(a5)
ffffffffc0202b8a:	9782                	jalr	a5
ffffffffc0202b8c:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b8e:	609c                	ld	a5,0(s1)
ffffffffc0202b90:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202b94:	7a7d                	lui	s4,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b96:	00c79713          	slli	a4,a5,0xc
ffffffffc0202b9a:	6a85                	lui	s5,0x1
ffffffffc0202b9c:	02e47c63          	bgeu	s0,a4,ffffffffc0202bd4 <pmm_init+0x432>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202ba0:	00c45713          	srli	a4,s0,0xc
ffffffffc0202ba4:	30f77063          	bgeu	a4,a5,ffffffffc0202ea4 <pmm_init+0x702>
ffffffffc0202ba8:	0009b583          	ld	a1,0(s3)
ffffffffc0202bac:	00093503          	ld	a0,0(s2)
ffffffffc0202bb0:	4601                	li	a2,0
ffffffffc0202bb2:	95a2                	add	a1,a1,s0
ffffffffc0202bb4:	bc2ff0ef          	jal	ffffffffc0201f76 <get_pte>
ffffffffc0202bb8:	32050363          	beqz	a0,ffffffffc0202ede <pmm_init+0x73c>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202bbc:	611c                	ld	a5,0(a0)
ffffffffc0202bbe:	078a                	slli	a5,a5,0x2
ffffffffc0202bc0:	0147f7b3          	and	a5,a5,s4
ffffffffc0202bc4:	2e879d63          	bne	a5,s0,ffffffffc0202ebe <pmm_init+0x71c>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202bc8:	609c                	ld	a5,0(s1)
ffffffffc0202bca:	9456                	add	s0,s0,s5
ffffffffc0202bcc:	00c79713          	slli	a4,a5,0xc
ffffffffc0202bd0:	fce468e3          	bltu	s0,a4,ffffffffc0202ba0 <pmm_init+0x3fe>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202bd4:	00093783          	ld	a5,0(s2)
ffffffffc0202bd8:	639c                	ld	a5,0(a5)
ffffffffc0202bda:	42079863          	bnez	a5,ffffffffc020300a <pmm_init+0x868>
ffffffffc0202bde:	100027f3          	csrr	a5,sstatus
ffffffffc0202be2:	8b89                	andi	a5,a5,2
ffffffffc0202be4:	24079863          	bnez	a5,ffffffffc0202e34 <pmm_init+0x692>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202be8:	000b3783          	ld	a5,0(s6)
ffffffffc0202bec:	4505                	li	a0,1
ffffffffc0202bee:	6f9c                	ld	a5,24(a5)
ffffffffc0202bf0:	9782                	jalr	a5
ffffffffc0202bf2:	842a                	mv	s0,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202bf4:	00093503          	ld	a0,0(s2)
ffffffffc0202bf8:	4699                	li	a3,6
ffffffffc0202bfa:	10000613          	li	a2,256
ffffffffc0202bfe:	85a2                	mv	a1,s0
ffffffffc0202c00:	aadff0ef          	jal	ffffffffc02026ac <page_insert>
ffffffffc0202c04:	46051363          	bnez	a0,ffffffffc020306a <pmm_init+0x8c8>
    assert(page_ref(p) == 1);
ffffffffc0202c08:	4018                	lw	a4,0(s0)
ffffffffc0202c0a:	4785                	li	a5,1
ffffffffc0202c0c:	42f71f63          	bne	a4,a5,ffffffffc020304a <pmm_init+0x8a8>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202c10:	00093503          	ld	a0,0(s2)
ffffffffc0202c14:	6605                	lui	a2,0x1
ffffffffc0202c16:	10060613          	addi	a2,a2,256 # 1100 <_binary_obj___user_softint_out_size-0x7ac8>
ffffffffc0202c1a:	4699                	li	a3,6
ffffffffc0202c1c:	85a2                	mv	a1,s0
ffffffffc0202c1e:	a8fff0ef          	jal	ffffffffc02026ac <page_insert>
ffffffffc0202c22:	72051963          	bnez	a0,ffffffffc0203354 <pmm_init+0xbb2>
    assert(page_ref(p) == 2);
ffffffffc0202c26:	4018                	lw	a4,0(s0)
ffffffffc0202c28:	4789                	li	a5,2
ffffffffc0202c2a:	70f71563          	bne	a4,a5,ffffffffc0203334 <pmm_init+0xb92>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202c2e:	00004597          	auipc	a1,0x4
ffffffffc0202c32:	21a58593          	addi	a1,a1,538 # ffffffffc0206e48 <etext+0x13d4>
ffffffffc0202c36:	10000513          	li	a0,256
ffffffffc0202c3a:	591020ef          	jal	ffffffffc02059ca <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202c3e:	6585                	lui	a1,0x1
ffffffffc0202c40:	10058593          	addi	a1,a1,256 # 1100 <_binary_obj___user_softint_out_size-0x7ac8>
ffffffffc0202c44:	10000513          	li	a0,256
ffffffffc0202c48:	595020ef          	jal	ffffffffc02059dc <strcmp>
ffffffffc0202c4c:	6c051463          	bnez	a0,ffffffffc0203314 <pmm_init+0xb72>
    return page - pages + nbase;
ffffffffc0202c50:	000bb683          	ld	a3,0(s7)
ffffffffc0202c54:	000807b7          	lui	a5,0x80
    return KADDR(page2pa(page));
ffffffffc0202c58:	6098                	ld	a4,0(s1)
    return page - pages + nbase;
ffffffffc0202c5a:	40d406b3          	sub	a3,s0,a3
ffffffffc0202c5e:	8699                	srai	a3,a3,0x6
ffffffffc0202c60:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0202c62:	00c69793          	slli	a5,a3,0xc
ffffffffc0202c66:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c68:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c6a:	32e7f463          	bgeu	a5,a4,ffffffffc0202f92 <pmm_init+0x7f0>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202c6e:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c72:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202c76:	97b6                	add	a5,a5,a3
ffffffffc0202c78:	10078023          	sb	zero,256(a5) # 80100 <_binary_obj___user_exit_out_size+0x75f40>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c7c:	51b020ef          	jal	ffffffffc0205996 <strlen>
ffffffffc0202c80:	66051a63          	bnez	a0,ffffffffc02032f4 <pmm_init+0xb52>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202c84:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202c88:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c8a:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fd5a018>
ffffffffc0202c8e:	078a                	slli	a5,a5,0x2
ffffffffc0202c90:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c92:	26e7f663          	bgeu	a5,a4,ffffffffc0202efe <pmm_init+0x75c>
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c96:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202c9a:	2ee7fc63          	bgeu	a5,a4,ffffffffc0202f92 <pmm_init+0x7f0>
ffffffffc0202c9e:	0009b783          	ld	a5,0(s3)
ffffffffc0202ca2:	00f689b3          	add	s3,a3,a5
ffffffffc0202ca6:	100027f3          	csrr	a5,sstatus
ffffffffc0202caa:	8b89                	andi	a5,a5,2
ffffffffc0202cac:	1e079163          	bnez	a5,ffffffffc0202e8e <pmm_init+0x6ec>
        pmm_manager->free_pages(base, n);
ffffffffc0202cb0:	000b3783          	ld	a5,0(s6)
ffffffffc0202cb4:	8522                	mv	a0,s0
ffffffffc0202cb6:	4585                	li	a1,1
ffffffffc0202cb8:	739c                	ld	a5,32(a5)
ffffffffc0202cba:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cbc:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage)
ffffffffc0202cc0:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cc2:	078a                	slli	a5,a5,0x2
ffffffffc0202cc4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cc6:	22e7fc63          	bgeu	a5,a4,ffffffffc0202efe <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202cca:	000bb503          	ld	a0,0(s7)
ffffffffc0202cce:	fe000737          	lui	a4,0xfe000
ffffffffc0202cd2:	079a                	slli	a5,a5,0x6
ffffffffc0202cd4:	97ba                	add	a5,a5,a4
ffffffffc0202cd6:	953e                	add	a0,a0,a5
ffffffffc0202cd8:	100027f3          	csrr	a5,sstatus
ffffffffc0202cdc:	8b89                	andi	a5,a5,2
ffffffffc0202cde:	18079c63          	bnez	a5,ffffffffc0202e76 <pmm_init+0x6d4>
ffffffffc0202ce2:	000b3783          	ld	a5,0(s6)
ffffffffc0202ce6:	4585                	li	a1,1
ffffffffc0202ce8:	739c                	ld	a5,32(a5)
ffffffffc0202cea:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cec:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202cf0:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cf2:	078a                	slli	a5,a5,0x2
ffffffffc0202cf4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cf6:	20e7f463          	bgeu	a5,a4,ffffffffc0202efe <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202cfa:	000bb503          	ld	a0,0(s7)
ffffffffc0202cfe:	fe000737          	lui	a4,0xfe000
ffffffffc0202d02:	079a                	slli	a5,a5,0x6
ffffffffc0202d04:	97ba                	add	a5,a5,a4
ffffffffc0202d06:	953e                	add	a0,a0,a5
ffffffffc0202d08:	100027f3          	csrr	a5,sstatus
ffffffffc0202d0c:	8b89                	andi	a5,a5,2
ffffffffc0202d0e:	14079863          	bnez	a5,ffffffffc0202e5e <pmm_init+0x6bc>
ffffffffc0202d12:	000b3783          	ld	a5,0(s6)
ffffffffc0202d16:	4585                	li	a1,1
ffffffffc0202d18:	739c                	ld	a5,32(a5)
ffffffffc0202d1a:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202d1c:	00093783          	ld	a5,0(s2)
ffffffffc0202d20:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202d24:	12000073          	sfence.vma
ffffffffc0202d28:	100027f3          	csrr	a5,sstatus
ffffffffc0202d2c:	8b89                	andi	a5,a5,2
ffffffffc0202d2e:	10079e63          	bnez	a5,ffffffffc0202e4a <pmm_init+0x6a8>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d32:	000b3783          	ld	a5,0(s6)
ffffffffc0202d36:	779c                	ld	a5,40(a5)
ffffffffc0202d38:	9782                	jalr	a5
ffffffffc0202d3a:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202d3c:	1e8c1b63          	bne	s8,s0,ffffffffc0202f32 <pmm_init+0x790>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202d40:	00004517          	auipc	a0,0x4
ffffffffc0202d44:	18050513          	addi	a0,a0,384 # ffffffffc0206ec0 <etext+0x144c>
ffffffffc0202d48:	c4cfd0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0202d4c:	7406                	ld	s0,96(sp)
ffffffffc0202d4e:	70a6                	ld	ra,104(sp)
ffffffffc0202d50:	64e6                	ld	s1,88(sp)
ffffffffc0202d52:	6946                	ld	s2,80(sp)
ffffffffc0202d54:	69a6                	ld	s3,72(sp)
ffffffffc0202d56:	6a06                	ld	s4,64(sp)
ffffffffc0202d58:	7ae2                	ld	s5,56(sp)
ffffffffc0202d5a:	7b42                	ld	s6,48(sp)
ffffffffc0202d5c:	7ba2                	ld	s7,40(sp)
ffffffffc0202d5e:	7c02                	ld	s8,32(sp)
ffffffffc0202d60:	6ce2                	ld	s9,24(sp)
ffffffffc0202d62:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202d64:	f85fe06f          	j	ffffffffc0201ce8 <kmalloc_init>
    if (maxpa > KERNTOP)
ffffffffc0202d68:	853e                	mv	a0,a5
ffffffffc0202d6a:	b4e1                	j	ffffffffc0202832 <pmm_init+0x90>
        intr_disable();
ffffffffc0202d6c:	b99fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202d70:	000b3783          	ld	a5,0(s6)
ffffffffc0202d74:	4505                	li	a0,1
ffffffffc0202d76:	6f9c                	ld	a5,24(a5)
ffffffffc0202d78:	9782                	jalr	a5
ffffffffc0202d7a:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202d7c:	b83fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202d80:	be75                	j	ffffffffc020293c <pmm_init+0x19a>
        intr_disable();
ffffffffc0202d82:	b83fd0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d86:	000b3783          	ld	a5,0(s6)
ffffffffc0202d8a:	779c                	ld	a5,40(a5)
ffffffffc0202d8c:	9782                	jalr	a5
ffffffffc0202d8e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202d90:	b6ffd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202d94:	b6ad                	j	ffffffffc02028fe <pmm_init+0x15c>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202d96:	6705                	lui	a4,0x1
ffffffffc0202d98:	177d                	addi	a4,a4,-1 # fff <_binary_obj___user_softint_out_size-0x7bc9>
ffffffffc0202d9a:	96ba                	add	a3,a3,a4
ffffffffc0202d9c:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202d9e:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202da2:	14a77e63          	bgeu	a4,a0,ffffffffc0202efe <pmm_init+0x75c>
    pmm_manager->init_memmap(base, n);
ffffffffc0202da6:	000b3683          	ld	a3,0(s6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202daa:	8c1d                	sub	s0,s0,a5
    return &pages[PPN(pa) - nbase];
ffffffffc0202dac:	071a                	slli	a4,a4,0x6
ffffffffc0202dae:	fe0007b7          	lui	a5,0xfe000
ffffffffc0202db2:	973e                	add	a4,a4,a5
    pmm_manager->init_memmap(base, n);
ffffffffc0202db4:	6a9c                	ld	a5,16(a3)
ffffffffc0202db6:	00c45593          	srli	a1,s0,0xc
ffffffffc0202dba:	00e60533          	add	a0,a2,a4
ffffffffc0202dbe:	9782                	jalr	a5
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202dc0:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202dc4:	bcf1                	j	ffffffffc02028a0 <pmm_init+0xfe>
        intr_disable();
ffffffffc0202dc6:	b3ffd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202dca:	000b3783          	ld	a5,0(s6)
ffffffffc0202dce:	4505                	li	a0,1
ffffffffc0202dd0:	6f9c                	ld	a5,24(a5)
ffffffffc0202dd2:	9782                	jalr	a5
ffffffffc0202dd4:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202dd6:	b29fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202dda:	b119                	j	ffffffffc02029e0 <pmm_init+0x23e>
        intr_disable();
ffffffffc0202ddc:	b29fd0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202de0:	000b3783          	ld	a5,0(s6)
ffffffffc0202de4:	779c                	ld	a5,40(a5)
ffffffffc0202de6:	9782                	jalr	a5
ffffffffc0202de8:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202dea:	b15fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202dee:	b345                	j	ffffffffc0202b8e <pmm_init+0x3ec>
        intr_disable();
ffffffffc0202df0:	b15fd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202df4:	000b3783          	ld	a5,0(s6)
ffffffffc0202df8:	779c                	ld	a5,40(a5)
ffffffffc0202dfa:	9782                	jalr	a5
ffffffffc0202dfc:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202dfe:	b01fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e02:	b3a5                	j	ffffffffc0202b6a <pmm_init+0x3c8>
ffffffffc0202e04:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e06:	afffd0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e0a:	000b3783          	ld	a5,0(s6)
ffffffffc0202e0e:	6522                	ld	a0,8(sp)
ffffffffc0202e10:	4585                	li	a1,1
ffffffffc0202e12:	739c                	ld	a5,32(a5)
ffffffffc0202e14:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e16:	ae9fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e1a:	bb05                	j	ffffffffc0202b4a <pmm_init+0x3a8>
ffffffffc0202e1c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e1e:	ae7fd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202e22:	000b3783          	ld	a5,0(s6)
ffffffffc0202e26:	6522                	ld	a0,8(sp)
ffffffffc0202e28:	4585                	li	a1,1
ffffffffc0202e2a:	739c                	ld	a5,32(a5)
ffffffffc0202e2c:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e2e:	ad1fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e32:	b1e5                	j	ffffffffc0202b1a <pmm_init+0x378>
        intr_disable();
ffffffffc0202e34:	ad1fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202e38:	000b3783          	ld	a5,0(s6)
ffffffffc0202e3c:	4505                	li	a0,1
ffffffffc0202e3e:	6f9c                	ld	a5,24(a5)
ffffffffc0202e40:	9782                	jalr	a5
ffffffffc0202e42:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202e44:	abbfd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e48:	b375                	j	ffffffffc0202bf4 <pmm_init+0x452>
        intr_disable();
ffffffffc0202e4a:	abbfd0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202e4e:	000b3783          	ld	a5,0(s6)
ffffffffc0202e52:	779c                	ld	a5,40(a5)
ffffffffc0202e54:	9782                	jalr	a5
ffffffffc0202e56:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202e58:	aa7fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e5c:	b5c5                	j	ffffffffc0202d3c <pmm_init+0x59a>
ffffffffc0202e5e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e60:	aa5fd0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e64:	000b3783          	ld	a5,0(s6)
ffffffffc0202e68:	6522                	ld	a0,8(sp)
ffffffffc0202e6a:	4585                	li	a1,1
ffffffffc0202e6c:	739c                	ld	a5,32(a5)
ffffffffc0202e6e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e70:	a8ffd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e74:	b565                	j	ffffffffc0202d1c <pmm_init+0x57a>
ffffffffc0202e76:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e78:	a8dfd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202e7c:	000b3783          	ld	a5,0(s6)
ffffffffc0202e80:	6522                	ld	a0,8(sp)
ffffffffc0202e82:	4585                	li	a1,1
ffffffffc0202e84:	739c                	ld	a5,32(a5)
ffffffffc0202e86:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e88:	a77fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e8c:	b585                	j	ffffffffc0202cec <pmm_init+0x54a>
        intr_disable();
ffffffffc0202e8e:	a77fd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202e92:	000b3783          	ld	a5,0(s6)
ffffffffc0202e96:	8522                	mv	a0,s0
ffffffffc0202e98:	4585                	li	a1,1
ffffffffc0202e9a:	739c                	ld	a5,32(a5)
ffffffffc0202e9c:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e9e:	a61fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202ea2:	bd29                	j	ffffffffc0202cbc <pmm_init+0x51a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202ea4:	86a2                	mv	a3,s0
ffffffffc0202ea6:	00004617          	auipc	a2,0x4
ffffffffc0202eaa:	93260613          	addi	a2,a2,-1742 # ffffffffc02067d8 <etext+0xd64>
ffffffffc0202eae:	24b00593          	li	a1,587
ffffffffc0202eb2:	00004517          	auipc	a0,0x4
ffffffffc0202eb6:	a1650513          	addi	a0,a0,-1514 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0202eba:	d8cfd0ef          	jal	ffffffffc0200446 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202ebe:	00004697          	auipc	a3,0x4
ffffffffc0202ec2:	ea268693          	addi	a3,a3,-350 # ffffffffc0206d60 <etext+0x12ec>
ffffffffc0202ec6:	00003617          	auipc	a2,0x3
ffffffffc0202eca:	56260613          	addi	a2,a2,1378 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0202ece:	24c00593          	li	a1,588
ffffffffc0202ed2:	00004517          	auipc	a0,0x4
ffffffffc0202ed6:	9f650513          	addi	a0,a0,-1546 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0202eda:	d6cfd0ef          	jal	ffffffffc0200446 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202ede:	00004697          	auipc	a3,0x4
ffffffffc0202ee2:	e4268693          	addi	a3,a3,-446 # ffffffffc0206d20 <etext+0x12ac>
ffffffffc0202ee6:	00003617          	auipc	a2,0x3
ffffffffc0202eea:	54260613          	addi	a2,a2,1346 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0202eee:	24b00593          	li	a1,587
ffffffffc0202ef2:	00004517          	auipc	a0,0x4
ffffffffc0202ef6:	9d650513          	addi	a0,a0,-1578 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0202efa:	d4cfd0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0202efe:	fb5fe0ef          	jal	ffffffffc0201eb2 <pa2page.part.0>
        panic("pte2page called with invalid pte");
ffffffffc0202f02:	00004617          	auipc	a2,0x4
ffffffffc0202f06:	bbe60613          	addi	a2,a2,-1090 # ffffffffc0206ac0 <etext+0x104c>
ffffffffc0202f0a:	07f00593          	li	a1,127
ffffffffc0202f0e:	00004517          	auipc	a0,0x4
ffffffffc0202f12:	8f250513          	addi	a0,a0,-1806 # ffffffffc0206800 <etext+0xd8c>
ffffffffc0202f16:	d30fd0ef          	jal	ffffffffc0200446 <__panic>
        panic("DTB memory info not available");
ffffffffc0202f1a:	00004617          	auipc	a2,0x4
ffffffffc0202f1e:	a1e60613          	addi	a2,a2,-1506 # ffffffffc0206938 <etext+0xec4>
ffffffffc0202f22:	06500593          	li	a1,101
ffffffffc0202f26:	00004517          	auipc	a0,0x4
ffffffffc0202f2a:	9a250513          	addi	a0,a0,-1630 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0202f2e:	d18fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202f32:	00004697          	auipc	a3,0x4
ffffffffc0202f36:	da668693          	addi	a3,a3,-602 # ffffffffc0206cd8 <etext+0x1264>
ffffffffc0202f3a:	00003617          	auipc	a2,0x3
ffffffffc0202f3e:	4ee60613          	addi	a2,a2,1262 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0202f42:	26600593          	li	a1,614
ffffffffc0202f46:	00004517          	auipc	a0,0x4
ffffffffc0202f4a:	98250513          	addi	a0,a0,-1662 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0202f4e:	cf8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202f52:	00004697          	auipc	a3,0x4
ffffffffc0202f56:	a9e68693          	addi	a3,a3,-1378 # ffffffffc02069f0 <etext+0xf7c>
ffffffffc0202f5a:	00003617          	auipc	a2,0x3
ffffffffc0202f5e:	4ce60613          	addi	a2,a2,1230 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0202f62:	20d00593          	li	a1,525
ffffffffc0202f66:	00004517          	auipc	a0,0x4
ffffffffc0202f6a:	96250513          	addi	a0,a0,-1694 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0202f6e:	cd8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202f72:	00004697          	auipc	a3,0x4
ffffffffc0202f76:	a5e68693          	addi	a3,a3,-1442 # ffffffffc02069d0 <etext+0xf5c>
ffffffffc0202f7a:	00003617          	auipc	a2,0x3
ffffffffc0202f7e:	4ae60613          	addi	a2,a2,1198 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0202f82:	20c00593          	li	a1,524
ffffffffc0202f86:	00004517          	auipc	a0,0x4
ffffffffc0202f8a:	94250513          	addi	a0,a0,-1726 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0202f8e:	cb8fd0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202f92:	00004617          	auipc	a2,0x4
ffffffffc0202f96:	84660613          	addi	a2,a2,-1978 # ffffffffc02067d8 <etext+0xd64>
ffffffffc0202f9a:	07100593          	li	a1,113
ffffffffc0202f9e:	00004517          	auipc	a0,0x4
ffffffffc0202fa2:	86250513          	addi	a0,a0,-1950 # ffffffffc0206800 <etext+0xd8c>
ffffffffc0202fa6:	ca0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202faa:	00004697          	auipc	a3,0x4
ffffffffc0202fae:	cfe68693          	addi	a3,a3,-770 # ffffffffc0206ca8 <etext+0x1234>
ffffffffc0202fb2:	00003617          	auipc	a2,0x3
ffffffffc0202fb6:	47660613          	addi	a2,a2,1142 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0202fba:	23400593          	li	a1,564
ffffffffc0202fbe:	00004517          	auipc	a0,0x4
ffffffffc0202fc2:	90a50513          	addi	a0,a0,-1782 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0202fc6:	c80fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202fca:	00004697          	auipc	a3,0x4
ffffffffc0202fce:	c9668693          	addi	a3,a3,-874 # ffffffffc0206c60 <etext+0x11ec>
ffffffffc0202fd2:	00003617          	auipc	a2,0x3
ffffffffc0202fd6:	45660613          	addi	a2,a2,1110 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0202fda:	23200593          	li	a1,562
ffffffffc0202fde:	00004517          	auipc	a0,0x4
ffffffffc0202fe2:	8ea50513          	addi	a0,a0,-1814 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0202fe6:	c60fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202fea:	00004697          	auipc	a3,0x4
ffffffffc0202fee:	ca668693          	addi	a3,a3,-858 # ffffffffc0206c90 <etext+0x121c>
ffffffffc0202ff2:	00003617          	auipc	a2,0x3
ffffffffc0202ff6:	43660613          	addi	a2,a2,1078 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0202ffa:	23100593          	li	a1,561
ffffffffc0202ffe:	00004517          	auipc	a0,0x4
ffffffffc0203002:	8ca50513          	addi	a0,a0,-1846 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203006:	c40fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc020300a:	00004697          	auipc	a3,0x4
ffffffffc020300e:	d6e68693          	addi	a3,a3,-658 # ffffffffc0206d78 <etext+0x1304>
ffffffffc0203012:	00003617          	auipc	a2,0x3
ffffffffc0203016:	41660613          	addi	a2,a2,1046 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020301a:	24f00593          	li	a1,591
ffffffffc020301e:	00004517          	auipc	a0,0x4
ffffffffc0203022:	8aa50513          	addi	a0,a0,-1878 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203026:	c20fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc020302a:	00004697          	auipc	a3,0x4
ffffffffc020302e:	cae68693          	addi	a3,a3,-850 # ffffffffc0206cd8 <etext+0x1264>
ffffffffc0203032:	00003617          	auipc	a2,0x3
ffffffffc0203036:	3f660613          	addi	a2,a2,1014 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020303a:	23c00593          	li	a1,572
ffffffffc020303e:	00004517          	auipc	a0,0x4
ffffffffc0203042:	88a50513          	addi	a0,a0,-1910 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203046:	c00fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p) == 1);
ffffffffc020304a:	00004697          	auipc	a3,0x4
ffffffffc020304e:	d8668693          	addi	a3,a3,-634 # ffffffffc0206dd0 <etext+0x135c>
ffffffffc0203052:	00003617          	auipc	a2,0x3
ffffffffc0203056:	3d660613          	addi	a2,a2,982 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020305a:	25400593          	li	a1,596
ffffffffc020305e:	00004517          	auipc	a0,0x4
ffffffffc0203062:	86a50513          	addi	a0,a0,-1942 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203066:	be0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc020306a:	00004697          	auipc	a3,0x4
ffffffffc020306e:	d2668693          	addi	a3,a3,-730 # ffffffffc0206d90 <etext+0x131c>
ffffffffc0203072:	00003617          	auipc	a2,0x3
ffffffffc0203076:	3b660613          	addi	a2,a2,950 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020307a:	25300593          	li	a1,595
ffffffffc020307e:	00004517          	auipc	a0,0x4
ffffffffc0203082:	84a50513          	addi	a0,a0,-1974 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203086:	bc0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020308a:	00004697          	auipc	a3,0x4
ffffffffc020308e:	bd668693          	addi	a3,a3,-1066 # ffffffffc0206c60 <etext+0x11ec>
ffffffffc0203092:	00003617          	auipc	a2,0x3
ffffffffc0203096:	39660613          	addi	a2,a2,918 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020309a:	22e00593          	li	a1,558
ffffffffc020309e:	00004517          	auipc	a0,0x4
ffffffffc02030a2:	82a50513          	addi	a0,a0,-2006 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02030a6:	ba0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02030aa:	00004697          	auipc	a3,0x4
ffffffffc02030ae:	a5668693          	addi	a3,a3,-1450 # ffffffffc0206b00 <etext+0x108c>
ffffffffc02030b2:	00003617          	auipc	a2,0x3
ffffffffc02030b6:	37660613          	addi	a2,a2,886 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02030ba:	22d00593          	li	a1,557
ffffffffc02030be:	00004517          	auipc	a0,0x4
ffffffffc02030c2:	80a50513          	addi	a0,a0,-2038 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02030c6:	b80fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc02030ca:	00004697          	auipc	a3,0x4
ffffffffc02030ce:	bae68693          	addi	a3,a3,-1106 # ffffffffc0206c78 <etext+0x1204>
ffffffffc02030d2:	00003617          	auipc	a2,0x3
ffffffffc02030d6:	35660613          	addi	a2,a2,854 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02030da:	22a00593          	li	a1,554
ffffffffc02030de:	00003517          	auipc	a0,0x3
ffffffffc02030e2:	7ea50513          	addi	a0,a0,2026 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02030e6:	b60fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02030ea:	00004697          	auipc	a3,0x4
ffffffffc02030ee:	9fe68693          	addi	a3,a3,-1538 # ffffffffc0206ae8 <etext+0x1074>
ffffffffc02030f2:	00003617          	auipc	a2,0x3
ffffffffc02030f6:	33660613          	addi	a2,a2,822 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02030fa:	22900593          	li	a1,553
ffffffffc02030fe:	00003517          	auipc	a0,0x3
ffffffffc0203102:	7ca50513          	addi	a0,a0,1994 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203106:	b40fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020310a:	00004697          	auipc	a3,0x4
ffffffffc020310e:	a7e68693          	addi	a3,a3,-1410 # ffffffffc0206b88 <etext+0x1114>
ffffffffc0203112:	00003617          	auipc	a2,0x3
ffffffffc0203116:	31660613          	addi	a2,a2,790 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020311a:	22800593          	li	a1,552
ffffffffc020311e:	00003517          	auipc	a0,0x3
ffffffffc0203122:	7aa50513          	addi	a0,a0,1962 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203126:	b20fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020312a:	00004697          	auipc	a3,0x4
ffffffffc020312e:	b3668693          	addi	a3,a3,-1226 # ffffffffc0206c60 <etext+0x11ec>
ffffffffc0203132:	00003617          	auipc	a2,0x3
ffffffffc0203136:	2f660613          	addi	a2,a2,758 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020313a:	22700593          	li	a1,551
ffffffffc020313e:	00003517          	auipc	a0,0x3
ffffffffc0203142:	78a50513          	addi	a0,a0,1930 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203146:	b00fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc020314a:	00004697          	auipc	a3,0x4
ffffffffc020314e:	afe68693          	addi	a3,a3,-1282 # ffffffffc0206c48 <etext+0x11d4>
ffffffffc0203152:	00003617          	auipc	a2,0x3
ffffffffc0203156:	2d660613          	addi	a2,a2,726 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020315a:	22600593          	li	a1,550
ffffffffc020315e:	00003517          	auipc	a0,0x3
ffffffffc0203162:	76a50513          	addi	a0,a0,1898 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203166:	ae0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc020316a:	00004697          	auipc	a3,0x4
ffffffffc020316e:	aae68693          	addi	a3,a3,-1362 # ffffffffc0206c18 <etext+0x11a4>
ffffffffc0203172:	00003617          	auipc	a2,0x3
ffffffffc0203176:	2b660613          	addi	a2,a2,694 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020317a:	22500593          	li	a1,549
ffffffffc020317e:	00003517          	auipc	a0,0x3
ffffffffc0203182:	74a50513          	addi	a0,a0,1866 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203186:	ac0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc020318a:	00004697          	auipc	a3,0x4
ffffffffc020318e:	a7668693          	addi	a3,a3,-1418 # ffffffffc0206c00 <etext+0x118c>
ffffffffc0203192:	00003617          	auipc	a2,0x3
ffffffffc0203196:	29660613          	addi	a2,a2,662 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020319a:	22300593          	li	a1,547
ffffffffc020319e:	00003517          	auipc	a0,0x3
ffffffffc02031a2:	72a50513          	addi	a0,a0,1834 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02031a6:	aa0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02031aa:	00004697          	auipc	a3,0x4
ffffffffc02031ae:	a3668693          	addi	a3,a3,-1482 # ffffffffc0206be0 <etext+0x116c>
ffffffffc02031b2:	00003617          	auipc	a2,0x3
ffffffffc02031b6:	27660613          	addi	a2,a2,630 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02031ba:	22200593          	li	a1,546
ffffffffc02031be:	00003517          	auipc	a0,0x3
ffffffffc02031c2:	70a50513          	addi	a0,a0,1802 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02031c6:	a80fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(*ptep & PTE_W);
ffffffffc02031ca:	00004697          	auipc	a3,0x4
ffffffffc02031ce:	a0668693          	addi	a3,a3,-1530 # ffffffffc0206bd0 <etext+0x115c>
ffffffffc02031d2:	00003617          	auipc	a2,0x3
ffffffffc02031d6:	25660613          	addi	a2,a2,598 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02031da:	22100593          	li	a1,545
ffffffffc02031de:	00003517          	auipc	a0,0x3
ffffffffc02031e2:	6ea50513          	addi	a0,a0,1770 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02031e6:	a60fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(*ptep & PTE_U);
ffffffffc02031ea:	00004697          	auipc	a3,0x4
ffffffffc02031ee:	9d668693          	addi	a3,a3,-1578 # ffffffffc0206bc0 <etext+0x114c>
ffffffffc02031f2:	00003617          	auipc	a2,0x3
ffffffffc02031f6:	23660613          	addi	a2,a2,566 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02031fa:	22000593          	li	a1,544
ffffffffc02031fe:	00003517          	auipc	a0,0x3
ffffffffc0203202:	6ca50513          	addi	a0,a0,1738 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203206:	a40fd0ef          	jal	ffffffffc0200446 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020320a:	00003617          	auipc	a2,0x3
ffffffffc020320e:	67660613          	addi	a2,a2,1654 # ffffffffc0206880 <etext+0xe0c>
ffffffffc0203212:	08100593          	li	a1,129
ffffffffc0203216:	00003517          	auipc	a0,0x3
ffffffffc020321a:	6b250513          	addi	a0,a0,1714 # ffffffffc02068c8 <etext+0xe54>
ffffffffc020321e:	a28fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0203222:	00004697          	auipc	a3,0x4
ffffffffc0203226:	8f668693          	addi	a3,a3,-1802 # ffffffffc0206b18 <etext+0x10a4>
ffffffffc020322a:	00003617          	auipc	a2,0x3
ffffffffc020322e:	1fe60613          	addi	a2,a2,510 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203232:	21b00593          	li	a1,539
ffffffffc0203236:	00003517          	auipc	a0,0x3
ffffffffc020323a:	69250513          	addi	a0,a0,1682 # ffffffffc02068c8 <etext+0xe54>
ffffffffc020323e:	a08fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203242:	00004697          	auipc	a3,0x4
ffffffffc0203246:	94668693          	addi	a3,a3,-1722 # ffffffffc0206b88 <etext+0x1114>
ffffffffc020324a:	00003617          	auipc	a2,0x3
ffffffffc020324e:	1de60613          	addi	a2,a2,478 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203252:	21f00593          	li	a1,543
ffffffffc0203256:	00003517          	auipc	a0,0x3
ffffffffc020325a:	67250513          	addi	a0,a0,1650 # ffffffffc02068c8 <etext+0xe54>
ffffffffc020325e:	9e8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203262:	00004697          	auipc	a3,0x4
ffffffffc0203266:	8e668693          	addi	a3,a3,-1818 # ffffffffc0206b48 <etext+0x10d4>
ffffffffc020326a:	00003617          	auipc	a2,0x3
ffffffffc020326e:	1be60613          	addi	a2,a2,446 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203272:	21e00593          	li	a1,542
ffffffffc0203276:	00003517          	auipc	a0,0x3
ffffffffc020327a:	65250513          	addi	a0,a0,1618 # ffffffffc02068c8 <etext+0xe54>
ffffffffc020327e:	9c8fd0ef          	jal	ffffffffc0200446 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203282:	86d6                	mv	a3,s5
ffffffffc0203284:	00003617          	auipc	a2,0x3
ffffffffc0203288:	55460613          	addi	a2,a2,1364 # ffffffffc02067d8 <etext+0xd64>
ffffffffc020328c:	21a00593          	li	a1,538
ffffffffc0203290:	00003517          	auipc	a0,0x3
ffffffffc0203294:	63850513          	addi	a0,a0,1592 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203298:	9aefd0ef          	jal	ffffffffc0200446 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020329c:	00003617          	auipc	a2,0x3
ffffffffc02032a0:	53c60613          	addi	a2,a2,1340 # ffffffffc02067d8 <etext+0xd64>
ffffffffc02032a4:	21900593          	li	a1,537
ffffffffc02032a8:	00003517          	auipc	a0,0x3
ffffffffc02032ac:	62050513          	addi	a0,a0,1568 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02032b0:	996fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02032b4:	00004697          	auipc	a3,0x4
ffffffffc02032b8:	84c68693          	addi	a3,a3,-1972 # ffffffffc0206b00 <etext+0x108c>
ffffffffc02032bc:	00003617          	auipc	a2,0x3
ffffffffc02032c0:	16c60613          	addi	a2,a2,364 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02032c4:	21700593          	li	a1,535
ffffffffc02032c8:	00003517          	auipc	a0,0x3
ffffffffc02032cc:	60050513          	addi	a0,a0,1536 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02032d0:	976fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02032d4:	00004697          	auipc	a3,0x4
ffffffffc02032d8:	81468693          	addi	a3,a3,-2028 # ffffffffc0206ae8 <etext+0x1074>
ffffffffc02032dc:	00003617          	auipc	a2,0x3
ffffffffc02032e0:	14c60613          	addi	a2,a2,332 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02032e4:	21600593          	li	a1,534
ffffffffc02032e8:	00003517          	auipc	a0,0x3
ffffffffc02032ec:	5e050513          	addi	a0,a0,1504 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02032f0:	956fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02032f4:	00004697          	auipc	a3,0x4
ffffffffc02032f8:	ba468693          	addi	a3,a3,-1116 # ffffffffc0206e98 <etext+0x1424>
ffffffffc02032fc:	00003617          	auipc	a2,0x3
ffffffffc0203300:	12c60613          	addi	a2,a2,300 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203304:	25d00593          	li	a1,605
ffffffffc0203308:	00003517          	auipc	a0,0x3
ffffffffc020330c:	5c050513          	addi	a0,a0,1472 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203310:	936fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203314:	00004697          	auipc	a3,0x4
ffffffffc0203318:	b4c68693          	addi	a3,a3,-1204 # ffffffffc0206e60 <etext+0x13ec>
ffffffffc020331c:	00003617          	auipc	a2,0x3
ffffffffc0203320:	10c60613          	addi	a2,a2,268 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203324:	25a00593          	li	a1,602
ffffffffc0203328:	00003517          	auipc	a0,0x3
ffffffffc020332c:	5a050513          	addi	a0,a0,1440 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203330:	916fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203334:	00004697          	auipc	a3,0x4
ffffffffc0203338:	afc68693          	addi	a3,a3,-1284 # ffffffffc0206e30 <etext+0x13bc>
ffffffffc020333c:	00003617          	auipc	a2,0x3
ffffffffc0203340:	0ec60613          	addi	a2,a2,236 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203344:	25600593          	li	a1,598
ffffffffc0203348:	00003517          	auipc	a0,0x3
ffffffffc020334c:	58050513          	addi	a0,a0,1408 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203350:	8f6fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203354:	00004697          	auipc	a3,0x4
ffffffffc0203358:	a9468693          	addi	a3,a3,-1388 # ffffffffc0206de8 <etext+0x1374>
ffffffffc020335c:	00003617          	auipc	a2,0x3
ffffffffc0203360:	0cc60613          	addi	a2,a2,204 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203364:	25500593          	li	a1,597
ffffffffc0203368:	00003517          	auipc	a0,0x3
ffffffffc020336c:	56050513          	addi	a0,a0,1376 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203370:	8d6fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0203374:	00003697          	auipc	a3,0x3
ffffffffc0203378:	6bc68693          	addi	a3,a3,1724 # ffffffffc0206a30 <etext+0xfbc>
ffffffffc020337c:	00003617          	auipc	a2,0x3
ffffffffc0203380:	0ac60613          	addi	a2,a2,172 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203384:	20e00593          	li	a1,526
ffffffffc0203388:	00003517          	auipc	a0,0x3
ffffffffc020338c:	54050513          	addi	a0,a0,1344 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203390:	8b6fd0ef          	jal	ffffffffc0200446 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0203394:	00003617          	auipc	a2,0x3
ffffffffc0203398:	4ec60613          	addi	a2,a2,1260 # ffffffffc0206880 <etext+0xe0c>
ffffffffc020339c:	0c900593          	li	a1,201
ffffffffc02033a0:	00003517          	auipc	a0,0x3
ffffffffc02033a4:	52850513          	addi	a0,a0,1320 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02033a8:	89efd0ef          	jal	ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02033ac:	00003697          	auipc	a3,0x3
ffffffffc02033b0:	6e468693          	addi	a3,a3,1764 # ffffffffc0206a90 <etext+0x101c>
ffffffffc02033b4:	00003617          	auipc	a2,0x3
ffffffffc02033b8:	07460613          	addi	a2,a2,116 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02033bc:	21500593          	li	a1,533
ffffffffc02033c0:	00003517          	auipc	a0,0x3
ffffffffc02033c4:	50850513          	addi	a0,a0,1288 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02033c8:	87efd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02033cc:	00003697          	auipc	a3,0x3
ffffffffc02033d0:	69468693          	addi	a3,a3,1684 # ffffffffc0206a60 <etext+0xfec>
ffffffffc02033d4:	00003617          	auipc	a2,0x3
ffffffffc02033d8:	05460613          	addi	a2,a2,84 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02033dc:	21200593          	li	a1,530
ffffffffc02033e0:	00003517          	auipc	a0,0x3
ffffffffc02033e4:	4e850513          	addi	a0,a0,1256 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02033e8:	85efd0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02033ec <copy_range>:
{
ffffffffc02033ec:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02033ee:	00d667b3          	or	a5,a2,a3
{
ffffffffc02033f2:	f486                	sd	ra,104(sp)
ffffffffc02033f4:	f0a2                	sd	s0,96(sp)
ffffffffc02033f6:	eca6                	sd	s1,88(sp)
ffffffffc02033f8:	e8ca                	sd	s2,80(sp)
ffffffffc02033fa:	e4ce                	sd	s3,72(sp)
ffffffffc02033fc:	e0d2                	sd	s4,64(sp)
ffffffffc02033fe:	fc56                	sd	s5,56(sp)
ffffffffc0203400:	f85a                	sd	s6,48(sp)
ffffffffc0203402:	f45e                	sd	s7,40(sp)
ffffffffc0203404:	f062                	sd	s8,32(sp)
ffffffffc0203406:	ec66                	sd	s9,24(sp)
ffffffffc0203408:	e86a                	sd	s10,16(sp)
ffffffffc020340a:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020340c:	03479713          	slli	a4,a5,0x34
ffffffffc0203410:	20071f63          	bnez	a4,ffffffffc020362e <copy_range+0x242>
    assert(USER_ACCESS(start, end));
ffffffffc0203414:	002007b7          	lui	a5,0x200
ffffffffc0203418:	00d63733          	sltu	a4,a2,a3
ffffffffc020341c:	00f637b3          	sltu	a5,a2,a5
ffffffffc0203420:	00173713          	seqz	a4,a4
ffffffffc0203424:	8fd9                	or	a5,a5,a4
ffffffffc0203426:	8432                	mv	s0,a2
ffffffffc0203428:	8936                	mv	s2,a3
ffffffffc020342a:	1e079263          	bnez	a5,ffffffffc020360e <copy_range+0x222>
ffffffffc020342e:	4785                	li	a5,1
ffffffffc0203430:	07fe                	slli	a5,a5,0x1f
ffffffffc0203432:	0785                	addi	a5,a5,1 # 200001 <_binary_obj___user_exit_out_size+0x1f5e41>
ffffffffc0203434:	1cf6fd63          	bgeu	a3,a5,ffffffffc020360e <copy_range+0x222>
ffffffffc0203438:	5b7d                	li	s6,-1
ffffffffc020343a:	8baa                	mv	s7,a0
ffffffffc020343c:	8a2e                	mv	s4,a1
ffffffffc020343e:	6a85                	lui	s5,0x1
ffffffffc0203440:	00cb5b13          	srli	s6,s6,0xc
    if (PPN(pa) >= npage)
ffffffffc0203444:	000a2c97          	auipc	s9,0xa2
ffffffffc0203448:	b74c8c93          	addi	s9,s9,-1164 # ffffffffc02a4fb8 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc020344c:	000a2c17          	auipc	s8,0xa2
ffffffffc0203450:	b74c0c13          	addi	s8,s8,-1164 # ffffffffc02a4fc0 <pages>
ffffffffc0203454:	fff80d37          	lui	s10,0xfff80
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc0203458:	4601                	li	a2,0
ffffffffc020345a:	85a2                	mv	a1,s0
ffffffffc020345c:	8552                	mv	a0,s4
ffffffffc020345e:	b19fe0ef          	jal	ffffffffc0201f76 <get_pte>
ffffffffc0203462:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc0203464:	0e050a63          	beqz	a0,ffffffffc0203558 <copy_range+0x16c>
        if (*ptep & PTE_V)
ffffffffc0203468:	611c                	ld	a5,0(a0)
ffffffffc020346a:	8b85                	andi	a5,a5,1
ffffffffc020346c:	e78d                	bnez	a5,ffffffffc0203496 <copy_range+0xaa>
        start += PGSIZE;
ffffffffc020346e:	9456                	add	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc0203470:	c019                	beqz	s0,ffffffffc0203476 <copy_range+0x8a>
ffffffffc0203472:	ff2463e3          	bltu	s0,s2,ffffffffc0203458 <copy_range+0x6c>
    return 0;
ffffffffc0203476:	4501                	li	a0,0
}
ffffffffc0203478:	70a6                	ld	ra,104(sp)
ffffffffc020347a:	7406                	ld	s0,96(sp)
ffffffffc020347c:	64e6                	ld	s1,88(sp)
ffffffffc020347e:	6946                	ld	s2,80(sp)
ffffffffc0203480:	69a6                	ld	s3,72(sp)
ffffffffc0203482:	6a06                	ld	s4,64(sp)
ffffffffc0203484:	7ae2                	ld	s5,56(sp)
ffffffffc0203486:	7b42                	ld	s6,48(sp)
ffffffffc0203488:	7ba2                	ld	s7,40(sp)
ffffffffc020348a:	7c02                	ld	s8,32(sp)
ffffffffc020348c:	6ce2                	ld	s9,24(sp)
ffffffffc020348e:	6d42                	ld	s10,16(sp)
ffffffffc0203490:	6da2                	ld	s11,8(sp)
ffffffffc0203492:	6165                	addi	sp,sp,112
ffffffffc0203494:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc0203496:	4605                	li	a2,1
ffffffffc0203498:	85a2                	mv	a1,s0
ffffffffc020349a:	855e                	mv	a0,s7
ffffffffc020349c:	adbfe0ef          	jal	ffffffffc0201f76 <get_pte>
ffffffffc02034a0:	c165                	beqz	a0,ffffffffc0203580 <copy_range+0x194>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc02034a2:	0004b983          	ld	s3,0(s1)
    if (!(pte & PTE_V))
ffffffffc02034a6:	0019f793          	andi	a5,s3,1
ffffffffc02034aa:	14078663          	beqz	a5,ffffffffc02035f6 <copy_range+0x20a>
    if (PPN(pa) >= npage)
ffffffffc02034ae:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc02034b2:	00299793          	slli	a5,s3,0x2
ffffffffc02034b6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02034b8:	12e7f363          	bgeu	a5,a4,ffffffffc02035de <copy_range+0x1f2>
    return &pages[PPN(pa) - nbase];
ffffffffc02034bc:	000c3483          	ld	s1,0(s8)
ffffffffc02034c0:	97ea                	add	a5,a5,s10
ffffffffc02034c2:	079a                	slli	a5,a5,0x6
ffffffffc02034c4:	94be                	add	s1,s1,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02034c6:	100027f3          	csrr	a5,sstatus
ffffffffc02034ca:	8b89                	andi	a5,a5,2
ffffffffc02034cc:	efc9                	bnez	a5,ffffffffc0203566 <copy_range+0x17a>
        page = pmm_manager->alloc_pages(n);
ffffffffc02034ce:	000a2797          	auipc	a5,0xa2
ffffffffc02034d2:	aca7b783          	ld	a5,-1334(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc02034d6:	4505                	li	a0,1
ffffffffc02034d8:	6f9c                	ld	a5,24(a5)
ffffffffc02034da:	9782                	jalr	a5
ffffffffc02034dc:	8daa                	mv	s11,a0
            assert(page != NULL);
ffffffffc02034de:	c0e5                	beqz	s1,ffffffffc02035be <copy_range+0x1d2>
            assert(npage != NULL);
ffffffffc02034e0:	0a0d8f63          	beqz	s11,ffffffffc020359e <copy_range+0x1b2>
    return page - pages + nbase;
ffffffffc02034e4:	000c3783          	ld	a5,0(s8)
ffffffffc02034e8:	00080637          	lui	a2,0x80
    return KADDR(page2pa(page));
ffffffffc02034ec:	000cb703          	ld	a4,0(s9)
    return page - pages + nbase;
ffffffffc02034f0:	40f486b3          	sub	a3,s1,a5
ffffffffc02034f4:	8699                	srai	a3,a3,0x6
ffffffffc02034f6:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02034f8:	0166f5b3          	and	a1,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc02034fc:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02034fe:	08e5f463          	bgeu	a1,a4,ffffffffc0203586 <copy_range+0x19a>
    return page - pages + nbase;
ffffffffc0203502:	40fd87b3          	sub	a5,s11,a5
ffffffffc0203506:	8799                	srai	a5,a5,0x6
ffffffffc0203508:	97b2                	add	a5,a5,a2
    return KADDR(page2pa(page));
ffffffffc020350a:	0167f633          	and	a2,a5,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc020350e:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0203510:	06e67a63          	bgeu	a2,a4,ffffffffc0203584 <copy_range+0x198>
ffffffffc0203514:	000a2517          	auipc	a0,0xa2
ffffffffc0203518:	a9c53503          	ld	a0,-1380(a0) # ffffffffc02a4fb0 <va_pa_offset>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc020351c:	6605                	lui	a2,0x1
ffffffffc020351e:	00a685b3          	add	a1,a3,a0
ffffffffc0203522:	953e                	add	a0,a0,a5
ffffffffc0203524:	538020ef          	jal	ffffffffc0205a5c <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc0203528:	01f9f693          	andi	a3,s3,31
ffffffffc020352c:	85ee                	mv	a1,s11
ffffffffc020352e:	8622                	mv	a2,s0
ffffffffc0203530:	855e                	mv	a0,s7
ffffffffc0203532:	97aff0ef          	jal	ffffffffc02026ac <page_insert>
            assert(ret == 0);
ffffffffc0203536:	dd05                	beqz	a0,ffffffffc020346e <copy_range+0x82>
ffffffffc0203538:	00004697          	auipc	a3,0x4
ffffffffc020353c:	9c868693          	addi	a3,a3,-1592 # ffffffffc0206f00 <etext+0x148c>
ffffffffc0203540:	00003617          	auipc	a2,0x3
ffffffffc0203544:	ee860613          	addi	a2,a2,-280 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203548:	1ad00593          	li	a1,429
ffffffffc020354c:	00003517          	auipc	a0,0x3
ffffffffc0203550:	37c50513          	addi	a0,a0,892 # ffffffffc02068c8 <etext+0xe54>
ffffffffc0203554:	ef3fc0ef          	jal	ffffffffc0200446 <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0203558:	002007b7          	lui	a5,0x200
ffffffffc020355c:	97a2                	add	a5,a5,s0
ffffffffc020355e:	ffe00437          	lui	s0,0xffe00
ffffffffc0203562:	8c7d                	and	s0,s0,a5
            continue;
ffffffffc0203564:	b731                	j	ffffffffc0203470 <copy_range+0x84>
        intr_disable();
ffffffffc0203566:	b9efd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020356a:	000a2797          	auipc	a5,0xa2
ffffffffc020356e:	a2e7b783          	ld	a5,-1490(a5) # ffffffffc02a4f98 <pmm_manager>
ffffffffc0203572:	4505                	li	a0,1
ffffffffc0203574:	6f9c                	ld	a5,24(a5)
ffffffffc0203576:	9782                	jalr	a5
ffffffffc0203578:	8daa                	mv	s11,a0
        intr_enable();
ffffffffc020357a:	b84fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020357e:	b785                	j	ffffffffc02034de <copy_range+0xf2>
                return -E_NO_MEM;
ffffffffc0203580:	5571                	li	a0,-4
ffffffffc0203582:	bddd                	j	ffffffffc0203478 <copy_range+0x8c>
ffffffffc0203584:	86be                	mv	a3,a5
ffffffffc0203586:	00003617          	auipc	a2,0x3
ffffffffc020358a:	25260613          	addi	a2,a2,594 # ffffffffc02067d8 <etext+0xd64>
ffffffffc020358e:	07100593          	li	a1,113
ffffffffc0203592:	00003517          	auipc	a0,0x3
ffffffffc0203596:	26e50513          	addi	a0,a0,622 # ffffffffc0206800 <etext+0xd8c>
ffffffffc020359a:	eadfc0ef          	jal	ffffffffc0200446 <__panic>
            assert(npage != NULL);
ffffffffc020359e:	00004697          	auipc	a3,0x4
ffffffffc02035a2:	95268693          	addi	a3,a3,-1710 # ffffffffc0206ef0 <etext+0x147c>
ffffffffc02035a6:	00003617          	auipc	a2,0x3
ffffffffc02035aa:	e8260613          	addi	a2,a2,-382 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02035ae:	19400593          	li	a1,404
ffffffffc02035b2:	00003517          	auipc	a0,0x3
ffffffffc02035b6:	31650513          	addi	a0,a0,790 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02035ba:	e8dfc0ef          	jal	ffffffffc0200446 <__panic>
            assert(page != NULL);
ffffffffc02035be:	00004697          	auipc	a3,0x4
ffffffffc02035c2:	92268693          	addi	a3,a3,-1758 # ffffffffc0206ee0 <etext+0x146c>
ffffffffc02035c6:	00003617          	auipc	a2,0x3
ffffffffc02035ca:	e6260613          	addi	a2,a2,-414 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02035ce:	19300593          	li	a1,403
ffffffffc02035d2:	00003517          	auipc	a0,0x3
ffffffffc02035d6:	2f650513          	addi	a0,a0,758 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02035da:	e6dfc0ef          	jal	ffffffffc0200446 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02035de:	00003617          	auipc	a2,0x3
ffffffffc02035e2:	2ca60613          	addi	a2,a2,714 # ffffffffc02068a8 <etext+0xe34>
ffffffffc02035e6:	06900593          	li	a1,105
ffffffffc02035ea:	00003517          	auipc	a0,0x3
ffffffffc02035ee:	21650513          	addi	a0,a0,534 # ffffffffc0206800 <etext+0xd8c>
ffffffffc02035f2:	e55fc0ef          	jal	ffffffffc0200446 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02035f6:	00003617          	auipc	a2,0x3
ffffffffc02035fa:	4ca60613          	addi	a2,a2,1226 # ffffffffc0206ac0 <etext+0x104c>
ffffffffc02035fe:	07f00593          	li	a1,127
ffffffffc0203602:	00003517          	auipc	a0,0x3
ffffffffc0203606:	1fe50513          	addi	a0,a0,510 # ffffffffc0206800 <etext+0xd8c>
ffffffffc020360a:	e3dfc0ef          	jal	ffffffffc0200446 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020360e:	00003697          	auipc	a3,0x3
ffffffffc0203612:	2fa68693          	addi	a3,a3,762 # ffffffffc0206908 <etext+0xe94>
ffffffffc0203616:	00003617          	auipc	a2,0x3
ffffffffc020361a:	e1260613          	addi	a2,a2,-494 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020361e:	17c00593          	li	a1,380
ffffffffc0203622:	00003517          	auipc	a0,0x3
ffffffffc0203626:	2a650513          	addi	a0,a0,678 # ffffffffc02068c8 <etext+0xe54>
ffffffffc020362a:	e1dfc0ef          	jal	ffffffffc0200446 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020362e:	00003697          	auipc	a3,0x3
ffffffffc0203632:	2aa68693          	addi	a3,a3,682 # ffffffffc02068d8 <etext+0xe64>
ffffffffc0203636:	00003617          	auipc	a2,0x3
ffffffffc020363a:	df260613          	addi	a2,a2,-526 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020363e:	17b00593          	li	a1,379
ffffffffc0203642:	00003517          	auipc	a0,0x3
ffffffffc0203646:	28650513          	addi	a0,a0,646 # ffffffffc02068c8 <etext+0xe54>
ffffffffc020364a:	dfdfc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020364e <tlb_invalidate>:
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020364e:	12058073          	sfence.vma	a1
}
ffffffffc0203652:	8082                	ret

ffffffffc0203654 <pgdir_alloc_page>:
{
ffffffffc0203654:	7179                	addi	sp,sp,-48
ffffffffc0203656:	e84a                	sd	s2,16(sp)
ffffffffc0203658:	e44e                	sd	s3,8(sp)
ffffffffc020365a:	e052                	sd	s4,0(sp)
ffffffffc020365c:	f406                	sd	ra,40(sp)
ffffffffc020365e:	f022                	sd	s0,32(sp)
ffffffffc0203660:	ec26                	sd	s1,24(sp)
ffffffffc0203662:	89aa                	mv	s3,a0
ffffffffc0203664:	892e                	mv	s2,a1
ffffffffc0203666:	8a32                	mv	s4,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203668:	100027f3          	csrr	a5,sstatus
ffffffffc020366c:	8b89                	andi	a5,a5,2
ffffffffc020366e:	ebc5                	bnez	a5,ffffffffc020371e <pgdir_alloc_page+0xca>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203670:	000a2497          	auipc	s1,0xa2
ffffffffc0203674:	92848493          	addi	s1,s1,-1752 # ffffffffc02a4f98 <pmm_manager>
ffffffffc0203678:	609c                	ld	a5,0(s1)
ffffffffc020367a:	4505                	li	a0,1
ffffffffc020367c:	6f9c                	ld	a5,24(a5)
ffffffffc020367e:	9782                	jalr	a5
ffffffffc0203680:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc0203682:	c441                	beqz	s0,ffffffffc020370a <pgdir_alloc_page+0xb6>
    return page - pages + nbase;
ffffffffc0203684:	000a2517          	auipc	a0,0xa2
ffffffffc0203688:	93c53503          	ld	a0,-1732(a0) # ffffffffc02a4fc0 <pages>
ffffffffc020368c:	000807b7          	lui	a5,0x80
    return KADDR(page2pa(page));
ffffffffc0203690:	000a2717          	auipc	a4,0xa2
ffffffffc0203694:	92873703          	ld	a4,-1752(a4) # ffffffffc02a4fb8 <npage>
    return page - pages + nbase;
ffffffffc0203698:	40a40533          	sub	a0,s0,a0
ffffffffc020369c:	8519                	srai	a0,a0,0x6
ffffffffc020369e:	953e                	add	a0,a0,a5
    return KADDR(page2pa(page));
ffffffffc02036a0:	00c51793          	slli	a5,a0,0xc
ffffffffc02036a4:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02036a6:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc02036a8:	0ae7f363          	bgeu	a5,a4,ffffffffc020374e <pgdir_alloc_page+0xfa>
ffffffffc02036ac:	000a2797          	auipc	a5,0xa2
ffffffffc02036b0:	9047b783          	ld	a5,-1788(a5) # ffffffffc02a4fb0 <va_pa_offset>
        memset(page2kva(page), 0, PGSIZE);
ffffffffc02036b4:	6605                	lui	a2,0x1
ffffffffc02036b6:	4581                	li	a1,0
ffffffffc02036b8:	953e                	add	a0,a0,a5
ffffffffc02036ba:	390020ef          	jal	ffffffffc0205a4a <memset>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc02036be:	86d2                	mv	a3,s4
ffffffffc02036c0:	864a                	mv	a2,s2
ffffffffc02036c2:	85a2                	mv	a1,s0
ffffffffc02036c4:	854e                	mv	a0,s3
ffffffffc02036c6:	fe7fe0ef          	jal	ffffffffc02026ac <page_insert>
ffffffffc02036ca:	e51d                	bnez	a0,ffffffffc02036f8 <pgdir_alloc_page+0xa4>
        assert(page_ref(page) == 1);
ffffffffc02036cc:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc02036ce:	03243c23          	sd	s2,56(s0) # ffffffffffe00038 <end+0x3fb5b050>
        assert(page_ref(page) == 1);
ffffffffc02036d2:	4785                	li	a5,1
ffffffffc02036d4:	02f70c63          	beq	a4,a5,ffffffffc020370c <pgdir_alloc_page+0xb8>
ffffffffc02036d8:	00004697          	auipc	a3,0x4
ffffffffc02036dc:	83868693          	addi	a3,a3,-1992 # ffffffffc0206f10 <etext+0x149c>
ffffffffc02036e0:	00003617          	auipc	a2,0x3
ffffffffc02036e4:	d4860613          	addi	a2,a2,-696 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02036e8:	1f700593          	li	a1,503
ffffffffc02036ec:	00003517          	auipc	a0,0x3
ffffffffc02036f0:	1dc50513          	addi	a0,a0,476 # ffffffffc02068c8 <etext+0xe54>
ffffffffc02036f4:	d53fc0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc02036f8:	100027f3          	csrr	a5,sstatus
ffffffffc02036fc:	8b89                	andi	a5,a5,2
ffffffffc02036fe:	ef95                	bnez	a5,ffffffffc020373a <pgdir_alloc_page+0xe6>
        pmm_manager->free_pages(base, n);
ffffffffc0203700:	609c                	ld	a5,0(s1)
ffffffffc0203702:	8522                	mv	a0,s0
ffffffffc0203704:	4585                	li	a1,1
ffffffffc0203706:	739c                	ld	a5,32(a5)
ffffffffc0203708:	9782                	jalr	a5
            return NULL;
ffffffffc020370a:	4401                	li	s0,0
}
ffffffffc020370c:	70a2                	ld	ra,40(sp)
ffffffffc020370e:	8522                	mv	a0,s0
ffffffffc0203710:	7402                	ld	s0,32(sp)
ffffffffc0203712:	64e2                	ld	s1,24(sp)
ffffffffc0203714:	6942                	ld	s2,16(sp)
ffffffffc0203716:	69a2                	ld	s3,8(sp)
ffffffffc0203718:	6a02                	ld	s4,0(sp)
ffffffffc020371a:	6145                	addi	sp,sp,48
ffffffffc020371c:	8082                	ret
        intr_disable();
ffffffffc020371e:	9e6fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203722:	000a2497          	auipc	s1,0xa2
ffffffffc0203726:	87648493          	addi	s1,s1,-1930 # ffffffffc02a4f98 <pmm_manager>
ffffffffc020372a:	609c                	ld	a5,0(s1)
ffffffffc020372c:	4505                	li	a0,1
ffffffffc020372e:	6f9c                	ld	a5,24(a5)
ffffffffc0203730:	9782                	jalr	a5
ffffffffc0203732:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203734:	9cafd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0203738:	b7a9                	j	ffffffffc0203682 <pgdir_alloc_page+0x2e>
        intr_disable();
ffffffffc020373a:	9cafd0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020373e:	609c                	ld	a5,0(s1)
ffffffffc0203740:	8522                	mv	a0,s0
ffffffffc0203742:	4585                	li	a1,1
ffffffffc0203744:	739c                	ld	a5,32(a5)
ffffffffc0203746:	9782                	jalr	a5
        intr_enable();
ffffffffc0203748:	9b6fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020374c:	bf7d                	j	ffffffffc020370a <pgdir_alloc_page+0xb6>
ffffffffc020374e:	86aa                	mv	a3,a0
ffffffffc0203750:	00003617          	auipc	a2,0x3
ffffffffc0203754:	08860613          	addi	a2,a2,136 # ffffffffc02067d8 <etext+0xd64>
ffffffffc0203758:	07100593          	li	a1,113
ffffffffc020375c:	00003517          	auipc	a0,0x3
ffffffffc0203760:	0a450513          	addi	a0,a0,164 # ffffffffc0206800 <etext+0xd8c>
ffffffffc0203764:	ce3fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203768 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203768:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc020376a:	00003697          	auipc	a3,0x3
ffffffffc020376e:	7be68693          	addi	a3,a3,1982 # ffffffffc0206f28 <etext+0x14b4>
ffffffffc0203772:	00003617          	auipc	a2,0x3
ffffffffc0203776:	cb660613          	addi	a2,a2,-842 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020377a:	07400593          	li	a1,116
ffffffffc020377e:	00003517          	auipc	a0,0x3
ffffffffc0203782:	7ca50513          	addi	a0,a0,1994 # ffffffffc0206f48 <etext+0x14d4>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203786:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0203788:	cbffc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020378c <mm_create>:
{
ffffffffc020378c:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc020378e:	04000513          	li	a0,64
{
ffffffffc0203792:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203794:	d78fe0ef          	jal	ffffffffc0201d0c <kmalloc>
    if (mm != NULL)
ffffffffc0203798:	cd19                	beqz	a0,ffffffffc02037b6 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc020379a:	e508                	sd	a0,8(a0)
ffffffffc020379c:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc020379e:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02037a2:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02037a6:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02037aa:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc02037ae:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc02037b2:	02053c23          	sd	zero,56(a0)
}
ffffffffc02037b6:	60a2                	ld	ra,8(sp)
ffffffffc02037b8:	0141                	addi	sp,sp,16
ffffffffc02037ba:	8082                	ret

ffffffffc02037bc <find_vma>:
    if (mm != NULL)
ffffffffc02037bc:	c505                	beqz	a0,ffffffffc02037e4 <find_vma+0x28>
        vma = mm->mmap_cache;
ffffffffc02037be:	691c                	ld	a5,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02037c0:	c781                	beqz	a5,ffffffffc02037c8 <find_vma+0xc>
ffffffffc02037c2:	6798                	ld	a4,8(a5)
ffffffffc02037c4:	02e5f363          	bgeu	a1,a4,ffffffffc02037ea <find_vma+0x2e>
    return listelm->next;
ffffffffc02037c8:	651c                	ld	a5,8(a0)
            while ((le = list_next(le)) != list)
ffffffffc02037ca:	00f50d63          	beq	a0,a5,ffffffffc02037e4 <find_vma+0x28>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc02037ce:	fe87b703          	ld	a4,-24(a5)
ffffffffc02037d2:	00e5e663          	bltu	a1,a4,ffffffffc02037de <find_vma+0x22>
ffffffffc02037d6:	ff07b703          	ld	a4,-16(a5)
ffffffffc02037da:	00e5ee63          	bltu	a1,a4,ffffffffc02037f6 <find_vma+0x3a>
ffffffffc02037de:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc02037e0:	fef517e3          	bne	a0,a5,ffffffffc02037ce <find_vma+0x12>
    struct vma_struct *vma = NULL;
ffffffffc02037e4:	4781                	li	a5,0
}
ffffffffc02037e6:	853e                	mv	a0,a5
ffffffffc02037e8:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02037ea:	6b98                	ld	a4,16(a5)
ffffffffc02037ec:	fce5fee3          	bgeu	a1,a4,ffffffffc02037c8 <find_vma+0xc>
            mm->mmap_cache = vma;
ffffffffc02037f0:	e91c                	sd	a5,16(a0)
}
ffffffffc02037f2:	853e                	mv	a0,a5
ffffffffc02037f4:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc02037f6:	1781                	addi	a5,a5,-32
            mm->mmap_cache = vma;
ffffffffc02037f8:	e91c                	sd	a5,16(a0)
ffffffffc02037fa:	bfe5                	j	ffffffffc02037f2 <find_vma+0x36>

ffffffffc02037fc <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc02037fc:	6590                	ld	a2,8(a1)
ffffffffc02037fe:	0105b803          	ld	a6,16(a1)
{
ffffffffc0203802:	1141                	addi	sp,sp,-16
ffffffffc0203804:	e406                	sd	ra,8(sp)
ffffffffc0203806:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203808:	01066763          	bltu	a2,a6,ffffffffc0203816 <insert_vma_struct+0x1a>
ffffffffc020380c:	a8b9                	j	ffffffffc020386a <insert_vma_struct+0x6e>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc020380e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203812:	04e66763          	bltu	a2,a4,ffffffffc0203860 <insert_vma_struct+0x64>
ffffffffc0203816:	86be                	mv	a3,a5
ffffffffc0203818:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc020381a:	fef51ae3          	bne	a0,a5,ffffffffc020380e <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc020381e:	02a68463          	beq	a3,a0,ffffffffc0203846 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203822:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203826:	fe86b883          	ld	a7,-24(a3)
ffffffffc020382a:	08e8f063          	bgeu	a7,a4,ffffffffc02038aa <insert_vma_struct+0xae>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020382e:	04e66e63          	bltu	a2,a4,ffffffffc020388a <insert_vma_struct+0x8e>
    }
    if (le_next != list)
ffffffffc0203832:	00f50a63          	beq	a0,a5,ffffffffc0203846 <insert_vma_struct+0x4a>
ffffffffc0203836:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc020383a:	05076863          	bltu	a4,a6,ffffffffc020388a <insert_vma_struct+0x8e>
    assert(next->vm_start < next->vm_end);
ffffffffc020383e:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203842:	02c77263          	bgeu	a4,a2,ffffffffc0203866 <insert_vma_struct+0x6a>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0203846:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0203848:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc020384a:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc020384e:	e390                	sd	a2,0(a5)
ffffffffc0203850:	e690                	sd	a2,8(a3)
}
ffffffffc0203852:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0203854:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0203856:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0203858:	2705                	addiw	a4,a4,1
ffffffffc020385a:	d118                	sw	a4,32(a0)
}
ffffffffc020385c:	0141                	addi	sp,sp,16
ffffffffc020385e:	8082                	ret
    if (le_prev != list)
ffffffffc0203860:	fca691e3          	bne	a3,a0,ffffffffc0203822 <insert_vma_struct+0x26>
ffffffffc0203864:	bfd9                	j	ffffffffc020383a <insert_vma_struct+0x3e>
ffffffffc0203866:	f03ff0ef          	jal	ffffffffc0203768 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc020386a:	00003697          	auipc	a3,0x3
ffffffffc020386e:	6ee68693          	addi	a3,a3,1774 # ffffffffc0206f58 <etext+0x14e4>
ffffffffc0203872:	00003617          	auipc	a2,0x3
ffffffffc0203876:	bb660613          	addi	a2,a2,-1098 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020387a:	07a00593          	li	a1,122
ffffffffc020387e:	00003517          	auipc	a0,0x3
ffffffffc0203882:	6ca50513          	addi	a0,a0,1738 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203886:	bc1fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020388a:	00003697          	auipc	a3,0x3
ffffffffc020388e:	70e68693          	addi	a3,a3,1806 # ffffffffc0206f98 <etext+0x1524>
ffffffffc0203892:	00003617          	auipc	a2,0x3
ffffffffc0203896:	b9660613          	addi	a2,a2,-1130 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020389a:	07300593          	li	a1,115
ffffffffc020389e:	00003517          	auipc	a0,0x3
ffffffffc02038a2:	6aa50513          	addi	a0,a0,1706 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc02038a6:	ba1fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc02038aa:	00003697          	auipc	a3,0x3
ffffffffc02038ae:	6ce68693          	addi	a3,a3,1742 # ffffffffc0206f78 <etext+0x1504>
ffffffffc02038b2:	00003617          	auipc	a2,0x3
ffffffffc02038b6:	b7660613          	addi	a2,a2,-1162 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02038ba:	07200593          	li	a1,114
ffffffffc02038be:	00003517          	auipc	a0,0x3
ffffffffc02038c2:	68a50513          	addi	a0,a0,1674 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc02038c6:	b81fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02038ca <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc02038ca:	591c                	lw	a5,48(a0)
{
ffffffffc02038cc:	1141                	addi	sp,sp,-16
ffffffffc02038ce:	e406                	sd	ra,8(sp)
ffffffffc02038d0:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc02038d2:	e78d                	bnez	a5,ffffffffc02038fc <mm_destroy+0x32>
ffffffffc02038d4:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc02038d6:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc02038d8:	00a40c63          	beq	s0,a0,ffffffffc02038f0 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc02038dc:	6118                	ld	a4,0(a0)
ffffffffc02038de:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc02038e0:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc02038e2:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02038e4:	e398                	sd	a4,0(a5)
ffffffffc02038e6:	cccfe0ef          	jal	ffffffffc0201db2 <kfree>
    return listelm->next;
ffffffffc02038ea:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc02038ec:	fea418e3          	bne	s0,a0,ffffffffc02038dc <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc02038f0:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc02038f2:	6402                	ld	s0,0(sp)
ffffffffc02038f4:	60a2                	ld	ra,8(sp)
ffffffffc02038f6:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc02038f8:	cbafe06f          	j	ffffffffc0201db2 <kfree>
    assert(mm_count(mm) == 0);
ffffffffc02038fc:	00003697          	auipc	a3,0x3
ffffffffc0203900:	6bc68693          	addi	a3,a3,1724 # ffffffffc0206fb8 <etext+0x1544>
ffffffffc0203904:	00003617          	auipc	a2,0x3
ffffffffc0203908:	b2460613          	addi	a2,a2,-1244 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020390c:	09e00593          	li	a1,158
ffffffffc0203910:	00003517          	auipc	a0,0x3
ffffffffc0203914:	63850513          	addi	a0,a0,1592 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203918:	b2ffc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020391c <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc020391c:	6785                	lui	a5,0x1
ffffffffc020391e:	17fd                	addi	a5,a5,-1 # fff <_binary_obj___user_softint_out_size-0x7bc9>
ffffffffc0203920:	963e                	add	a2,a2,a5
    if (!USER_ACCESS(start, end))
ffffffffc0203922:	4785                	li	a5,1
{
ffffffffc0203924:	7139                	addi	sp,sp,-64
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203926:	962e                	add	a2,a2,a1
ffffffffc0203928:	787d                	lui	a6,0xfffff
    if (!USER_ACCESS(start, end))
ffffffffc020392a:	07fe                	slli	a5,a5,0x1f
{
ffffffffc020392c:	f822                	sd	s0,48(sp)
ffffffffc020392e:	f426                	sd	s1,40(sp)
ffffffffc0203930:	01067433          	and	s0,a2,a6
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203934:	0105f4b3          	and	s1,a1,a6
    if (!USER_ACCESS(start, end))
ffffffffc0203938:	0785                	addi	a5,a5,1
ffffffffc020393a:	0084b633          	sltu	a2,s1,s0
ffffffffc020393e:	00f437b3          	sltu	a5,s0,a5
ffffffffc0203942:	00163613          	seqz	a2,a2
ffffffffc0203946:	0017b793          	seqz	a5,a5
{
ffffffffc020394a:	fc06                	sd	ra,56(sp)
    if (!USER_ACCESS(start, end))
ffffffffc020394c:	8fd1                	or	a5,a5,a2
ffffffffc020394e:	ebbd                	bnez	a5,ffffffffc02039c4 <mm_map+0xa8>
ffffffffc0203950:	002007b7          	lui	a5,0x200
ffffffffc0203954:	06f4e863          	bltu	s1,a5,ffffffffc02039c4 <mm_map+0xa8>
ffffffffc0203958:	f04a                	sd	s2,32(sp)
ffffffffc020395a:	ec4e                	sd	s3,24(sp)
ffffffffc020395c:	e852                	sd	s4,16(sp)
ffffffffc020395e:	892a                	mv	s2,a0
ffffffffc0203960:	89ba                	mv	s3,a4
ffffffffc0203962:	8a36                	mv	s4,a3
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203964:	c135                	beqz	a0,ffffffffc02039c8 <mm_map+0xac>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203966:	85a6                	mv	a1,s1
ffffffffc0203968:	e55ff0ef          	jal	ffffffffc02037bc <find_vma>
ffffffffc020396c:	c501                	beqz	a0,ffffffffc0203974 <mm_map+0x58>
ffffffffc020396e:	651c                	ld	a5,8(a0)
ffffffffc0203970:	0487e763          	bltu	a5,s0,ffffffffc02039be <mm_map+0xa2>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203974:	03000513          	li	a0,48
ffffffffc0203978:	b94fe0ef          	jal	ffffffffc0201d0c <kmalloc>
ffffffffc020397c:	85aa                	mv	a1,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc020397e:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203980:	c59d                	beqz	a1,ffffffffc02039ae <mm_map+0x92>
        vma->vm_start = vm_start;
ffffffffc0203982:	e584                	sd	s1,8(a1)
        vma->vm_end = vm_end;
ffffffffc0203984:	e980                	sd	s0,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203986:	0145ac23          	sw	s4,24(a1)

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc020398a:	854a                	mv	a0,s2
ffffffffc020398c:	e42e                	sd	a1,8(sp)
ffffffffc020398e:	e6fff0ef          	jal	ffffffffc02037fc <insert_vma_struct>
    if (vma_store != NULL)
ffffffffc0203992:	65a2                	ld	a1,8(sp)
ffffffffc0203994:	00098463          	beqz	s3,ffffffffc020399c <mm_map+0x80>
    {
        *vma_store = vma;
ffffffffc0203998:	00b9b023          	sd	a1,0(s3)
ffffffffc020399c:	7902                	ld	s2,32(sp)
ffffffffc020399e:	69e2                	ld	s3,24(sp)
ffffffffc02039a0:	6a42                	ld	s4,16(sp)
    }
    ret = 0;
ffffffffc02039a2:	4501                	li	a0,0

out:
    return ret;
}
ffffffffc02039a4:	70e2                	ld	ra,56(sp)
ffffffffc02039a6:	7442                	ld	s0,48(sp)
ffffffffc02039a8:	74a2                	ld	s1,40(sp)
ffffffffc02039aa:	6121                	addi	sp,sp,64
ffffffffc02039ac:	8082                	ret
ffffffffc02039ae:	70e2                	ld	ra,56(sp)
ffffffffc02039b0:	7442                	ld	s0,48(sp)
ffffffffc02039b2:	7902                	ld	s2,32(sp)
ffffffffc02039b4:	69e2                	ld	s3,24(sp)
ffffffffc02039b6:	6a42                	ld	s4,16(sp)
ffffffffc02039b8:	74a2                	ld	s1,40(sp)
ffffffffc02039ba:	6121                	addi	sp,sp,64
ffffffffc02039bc:	8082                	ret
ffffffffc02039be:	7902                	ld	s2,32(sp)
ffffffffc02039c0:	69e2                	ld	s3,24(sp)
ffffffffc02039c2:	6a42                	ld	s4,16(sp)
        return -E_INVAL;
ffffffffc02039c4:	5575                	li	a0,-3
ffffffffc02039c6:	bff9                	j	ffffffffc02039a4 <mm_map+0x88>
    assert(mm != NULL);
ffffffffc02039c8:	00003697          	auipc	a3,0x3
ffffffffc02039cc:	60868693          	addi	a3,a3,1544 # ffffffffc0206fd0 <etext+0x155c>
ffffffffc02039d0:	00003617          	auipc	a2,0x3
ffffffffc02039d4:	a5860613          	addi	a2,a2,-1448 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02039d8:	0b300593          	li	a1,179
ffffffffc02039dc:	00003517          	auipc	a0,0x3
ffffffffc02039e0:	56c50513          	addi	a0,a0,1388 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc02039e4:	a63fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02039e8 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc02039e8:	7139                	addi	sp,sp,-64
ffffffffc02039ea:	fc06                	sd	ra,56(sp)
ffffffffc02039ec:	f822                	sd	s0,48(sp)
ffffffffc02039ee:	f426                	sd	s1,40(sp)
ffffffffc02039f0:	f04a                	sd	s2,32(sp)
ffffffffc02039f2:	ec4e                	sd	s3,24(sp)
ffffffffc02039f4:	e852                	sd	s4,16(sp)
ffffffffc02039f6:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc02039f8:	c525                	beqz	a0,ffffffffc0203a60 <dup_mmap+0x78>
ffffffffc02039fa:	892a                	mv	s2,a0
ffffffffc02039fc:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc02039fe:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203a00:	c1a5                	beqz	a1,ffffffffc0203a60 <dup_mmap+0x78>
    return listelm->prev;
ffffffffc0203a02:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203a04:	04848c63          	beq	s1,s0,ffffffffc0203a5c <dup_mmap+0x74>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a08:	03000513          	li	a0,48
    {
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203a0c:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203a10:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203a14:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a18:	af4fe0ef          	jal	ffffffffc0201d0c <kmalloc>
    if (vma != NULL)
ffffffffc0203a1c:	c515                	beqz	a0,ffffffffc0203a48 <dup_mmap+0x60>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0203a1e:	85aa                	mv	a1,a0
        vma->vm_start = vm_start;
ffffffffc0203a20:	01553423          	sd	s5,8(a0)
ffffffffc0203a24:	01453823          	sd	s4,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203a28:	01352c23          	sw	s3,24(a0)
        insert_vma_struct(to, nvma);
ffffffffc0203a2c:	854a                	mv	a0,s2
ffffffffc0203a2e:	dcfff0ef          	jal	ffffffffc02037fc <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203a32:	ff043683          	ld	a3,-16(s0)
ffffffffc0203a36:	fe843603          	ld	a2,-24(s0)
ffffffffc0203a3a:	6c8c                	ld	a1,24(s1)
ffffffffc0203a3c:	01893503          	ld	a0,24(s2)
ffffffffc0203a40:	4701                	li	a4,0
ffffffffc0203a42:	9abff0ef          	jal	ffffffffc02033ec <copy_range>
ffffffffc0203a46:	dd55                	beqz	a0,ffffffffc0203a02 <dup_mmap+0x1a>
            return -E_NO_MEM;
ffffffffc0203a48:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203a4a:	70e2                	ld	ra,56(sp)
ffffffffc0203a4c:	7442                	ld	s0,48(sp)
ffffffffc0203a4e:	74a2                	ld	s1,40(sp)
ffffffffc0203a50:	7902                	ld	s2,32(sp)
ffffffffc0203a52:	69e2                	ld	s3,24(sp)
ffffffffc0203a54:	6a42                	ld	s4,16(sp)
ffffffffc0203a56:	6aa2                	ld	s5,8(sp)
ffffffffc0203a58:	6121                	addi	sp,sp,64
ffffffffc0203a5a:	8082                	ret
    return 0;
ffffffffc0203a5c:	4501                	li	a0,0
ffffffffc0203a5e:	b7f5                	j	ffffffffc0203a4a <dup_mmap+0x62>
    assert(to != NULL && from != NULL);
ffffffffc0203a60:	00003697          	auipc	a3,0x3
ffffffffc0203a64:	58068693          	addi	a3,a3,1408 # ffffffffc0206fe0 <etext+0x156c>
ffffffffc0203a68:	00003617          	auipc	a2,0x3
ffffffffc0203a6c:	9c060613          	addi	a2,a2,-1600 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203a70:	0cf00593          	li	a1,207
ffffffffc0203a74:	00003517          	auipc	a0,0x3
ffffffffc0203a78:	4d450513          	addi	a0,a0,1236 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203a7c:	9cbfc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203a80 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203a80:	1101                	addi	sp,sp,-32
ffffffffc0203a82:	ec06                	sd	ra,24(sp)
ffffffffc0203a84:	e822                	sd	s0,16(sp)
ffffffffc0203a86:	e426                	sd	s1,8(sp)
ffffffffc0203a88:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203a8a:	c531                	beqz	a0,ffffffffc0203ad6 <exit_mmap+0x56>
ffffffffc0203a8c:	591c                	lw	a5,48(a0)
ffffffffc0203a8e:	84aa                	mv	s1,a0
ffffffffc0203a90:	e3b9                	bnez	a5,ffffffffc0203ad6 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0203a92:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0203a94:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203a98:	02850663          	beq	a0,s0,ffffffffc0203ac4 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203a9c:	ff043603          	ld	a2,-16(s0)
ffffffffc0203aa0:	fe843583          	ld	a1,-24(s0)
ffffffffc0203aa4:	854a                	mv	a0,s2
ffffffffc0203aa6:	f82fe0ef          	jal	ffffffffc0202228 <unmap_range>
ffffffffc0203aaa:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203aac:	fe8498e3          	bne	s1,s0,ffffffffc0203a9c <exit_mmap+0x1c>
ffffffffc0203ab0:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0203ab2:	00848c63          	beq	s1,s0,ffffffffc0203aca <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203ab6:	ff043603          	ld	a2,-16(s0)
ffffffffc0203aba:	fe843583          	ld	a1,-24(s0)
ffffffffc0203abe:	854a                	mv	a0,s2
ffffffffc0203ac0:	89dfe0ef          	jal	ffffffffc020235c <exit_range>
ffffffffc0203ac4:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203ac6:	fe8498e3          	bne	s1,s0,ffffffffc0203ab6 <exit_mmap+0x36>
    }
}
ffffffffc0203aca:	60e2                	ld	ra,24(sp)
ffffffffc0203acc:	6442                	ld	s0,16(sp)
ffffffffc0203ace:	64a2                	ld	s1,8(sp)
ffffffffc0203ad0:	6902                	ld	s2,0(sp)
ffffffffc0203ad2:	6105                	addi	sp,sp,32
ffffffffc0203ad4:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203ad6:	00003697          	auipc	a3,0x3
ffffffffc0203ada:	52a68693          	addi	a3,a3,1322 # ffffffffc0207000 <etext+0x158c>
ffffffffc0203ade:	00003617          	auipc	a2,0x3
ffffffffc0203ae2:	94a60613          	addi	a2,a2,-1718 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203ae6:	0e800593          	li	a1,232
ffffffffc0203aea:	00003517          	auipc	a0,0x3
ffffffffc0203aee:	45e50513          	addi	a0,a0,1118 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203af2:	955fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203af6 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203af6:	7179                	addi	sp,sp,-48
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203af8:	04000513          	li	a0,64
{
ffffffffc0203afc:	f406                	sd	ra,40(sp)
ffffffffc0203afe:	f022                	sd	s0,32(sp)
ffffffffc0203b00:	ec26                	sd	s1,24(sp)
ffffffffc0203b02:	e84a                	sd	s2,16(sp)
ffffffffc0203b04:	e44e                	sd	s3,8(sp)
ffffffffc0203b06:	e052                	sd	s4,0(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203b08:	a04fe0ef          	jal	ffffffffc0201d0c <kmalloc>
    if (mm != NULL)
ffffffffc0203b0c:	16050c63          	beqz	a0,ffffffffc0203c84 <vmm_init+0x18e>
ffffffffc0203b10:	842a                	mv	s0,a0
    elm->prev = elm->next = elm;
ffffffffc0203b12:	e508                	sd	a0,8(a0)
ffffffffc0203b14:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203b16:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203b1a:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203b1e:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203b22:	02053423          	sd	zero,40(a0)
ffffffffc0203b26:	02052823          	sw	zero,48(a0)
ffffffffc0203b2a:	02053c23          	sd	zero,56(a0)
ffffffffc0203b2e:	03200493          	li	s1,50
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b32:	03000513          	li	a0,48
ffffffffc0203b36:	9d6fe0ef          	jal	ffffffffc0201d0c <kmalloc>
    if (vma != NULL)
ffffffffc0203b3a:	12050563          	beqz	a0,ffffffffc0203c64 <vmm_init+0x16e>
        vma->vm_end = vm_end;
ffffffffc0203b3e:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0203b42:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203b44:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0203b48:	e91c                	sd	a5,16(a0)
    int i;
    for (i = step1; i >= 1; i--)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203b4a:	85aa                	mv	a1,a0
    for (i = step1; i >= 1; i--)
ffffffffc0203b4c:	14ed                	addi	s1,s1,-5
        insert_vma_struct(mm, vma);
ffffffffc0203b4e:	8522                	mv	a0,s0
ffffffffc0203b50:	cadff0ef          	jal	ffffffffc02037fc <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203b54:	fcf9                	bnez	s1,ffffffffc0203b32 <vmm_init+0x3c>
ffffffffc0203b56:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203b5a:	1f900913          	li	s2,505
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b5e:	03000513          	li	a0,48
ffffffffc0203b62:	9aafe0ef          	jal	ffffffffc0201d0c <kmalloc>
    if (vma != NULL)
ffffffffc0203b66:	12050f63          	beqz	a0,ffffffffc0203ca4 <vmm_init+0x1ae>
        vma->vm_end = vm_end;
ffffffffc0203b6a:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0203b6e:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203b70:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0203b74:	e91c                	sd	a5,16(a0)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203b76:	85aa                	mv	a1,a0
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203b78:	0495                	addi	s1,s1,5
        insert_vma_struct(mm, vma);
ffffffffc0203b7a:	8522                	mv	a0,s0
ffffffffc0203b7c:	c81ff0ef          	jal	ffffffffc02037fc <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203b80:	fd249fe3          	bne	s1,s2,ffffffffc0203b5e <vmm_init+0x68>
    return listelm->next;
ffffffffc0203b84:	641c                	ld	a5,8(s0)
ffffffffc0203b86:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203b88:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203b8c:	1ef40c63          	beq	s0,a5,ffffffffc0203d84 <vmm_init+0x28e>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203b90:	fe87b603          	ld	a2,-24(a5) # 1fffe8 <_binary_obj___user_exit_out_size+0x1f5e28>
ffffffffc0203b94:	ffe70693          	addi	a3,a4,-2
ffffffffc0203b98:	12d61663          	bne	a2,a3,ffffffffc0203cc4 <vmm_init+0x1ce>
ffffffffc0203b9c:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203ba0:	12e69263          	bne	a3,a4,ffffffffc0203cc4 <vmm_init+0x1ce>
    for (i = 1; i <= step2; i++)
ffffffffc0203ba4:	0715                	addi	a4,a4,5
ffffffffc0203ba6:	679c                	ld	a5,8(a5)
ffffffffc0203ba8:	feb712e3          	bne	a4,a1,ffffffffc0203b8c <vmm_init+0x96>
ffffffffc0203bac:	491d                	li	s2,7
ffffffffc0203bae:	4495                	li	s1,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203bb0:	85a6                	mv	a1,s1
ffffffffc0203bb2:	8522                	mv	a0,s0
ffffffffc0203bb4:	c09ff0ef          	jal	ffffffffc02037bc <find_vma>
ffffffffc0203bb8:	8a2a                	mv	s4,a0
        assert(vma1 != NULL);
ffffffffc0203bba:	20050563          	beqz	a0,ffffffffc0203dc4 <vmm_init+0x2ce>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203bbe:	00148593          	addi	a1,s1,1
ffffffffc0203bc2:	8522                	mv	a0,s0
ffffffffc0203bc4:	bf9ff0ef          	jal	ffffffffc02037bc <find_vma>
ffffffffc0203bc8:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203bca:	1c050d63          	beqz	a0,ffffffffc0203da4 <vmm_init+0x2ae>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203bce:	85ca                	mv	a1,s2
ffffffffc0203bd0:	8522                	mv	a0,s0
ffffffffc0203bd2:	bebff0ef          	jal	ffffffffc02037bc <find_vma>
        assert(vma3 == NULL);
ffffffffc0203bd6:	18051763          	bnez	a0,ffffffffc0203d64 <vmm_init+0x26e>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203bda:	00348593          	addi	a1,s1,3
ffffffffc0203bde:	8522                	mv	a0,s0
ffffffffc0203be0:	bddff0ef          	jal	ffffffffc02037bc <find_vma>
        assert(vma4 == NULL);
ffffffffc0203be4:	16051063          	bnez	a0,ffffffffc0203d44 <vmm_init+0x24e>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203be8:	00448593          	addi	a1,s1,4
ffffffffc0203bec:	8522                	mv	a0,s0
ffffffffc0203bee:	bcfff0ef          	jal	ffffffffc02037bc <find_vma>
        assert(vma5 == NULL);
ffffffffc0203bf2:	12051963          	bnez	a0,ffffffffc0203d24 <vmm_init+0x22e>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203bf6:	008a3783          	ld	a5,8(s4)
ffffffffc0203bfa:	10979563          	bne	a5,s1,ffffffffc0203d04 <vmm_init+0x20e>
ffffffffc0203bfe:	010a3783          	ld	a5,16(s4)
ffffffffc0203c02:	11279163          	bne	a5,s2,ffffffffc0203d04 <vmm_init+0x20e>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203c06:	0089b783          	ld	a5,8(s3)
ffffffffc0203c0a:	0c979d63          	bne	a5,s1,ffffffffc0203ce4 <vmm_init+0x1ee>
ffffffffc0203c0e:	0109b783          	ld	a5,16(s3)
ffffffffc0203c12:	0d279963          	bne	a5,s2,ffffffffc0203ce4 <vmm_init+0x1ee>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203c16:	0495                	addi	s1,s1,5
ffffffffc0203c18:	1f900793          	li	a5,505
ffffffffc0203c1c:	0915                	addi	s2,s2,5
ffffffffc0203c1e:	f8f499e3          	bne	s1,a5,ffffffffc0203bb0 <vmm_init+0xba>
ffffffffc0203c22:	4491                	li	s1,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203c24:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203c26:	85a6                	mv	a1,s1
ffffffffc0203c28:	8522                	mv	a0,s0
ffffffffc0203c2a:	b93ff0ef          	jal	ffffffffc02037bc <find_vma>
        if (vma_below_5 != NULL)
ffffffffc0203c2e:	1a051b63          	bnez	a0,ffffffffc0203de4 <vmm_init+0x2ee>
    for (i = 4; i >= 0; i--)
ffffffffc0203c32:	14fd                	addi	s1,s1,-1
ffffffffc0203c34:	ff2499e3          	bne	s1,s2,ffffffffc0203c26 <vmm_init+0x130>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
ffffffffc0203c38:	8522                	mv	a0,s0
ffffffffc0203c3a:	c91ff0ef          	jal	ffffffffc02038ca <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203c3e:	00003517          	auipc	a0,0x3
ffffffffc0203c42:	53250513          	addi	a0,a0,1330 # ffffffffc0207170 <etext+0x16fc>
ffffffffc0203c46:	d4efc0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0203c4a:	7402                	ld	s0,32(sp)
ffffffffc0203c4c:	70a2                	ld	ra,40(sp)
ffffffffc0203c4e:	64e2                	ld	s1,24(sp)
ffffffffc0203c50:	6942                	ld	s2,16(sp)
ffffffffc0203c52:	69a2                	ld	s3,8(sp)
ffffffffc0203c54:	6a02                	ld	s4,0(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203c56:	00003517          	auipc	a0,0x3
ffffffffc0203c5a:	53a50513          	addi	a0,a0,1338 # ffffffffc0207190 <etext+0x171c>
}
ffffffffc0203c5e:	6145                	addi	sp,sp,48
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203c60:	d34fc06f          	j	ffffffffc0200194 <cprintf>
        assert(vma != NULL);
ffffffffc0203c64:	00003697          	auipc	a3,0x3
ffffffffc0203c68:	3bc68693          	addi	a3,a3,956 # ffffffffc0207020 <etext+0x15ac>
ffffffffc0203c6c:	00002617          	auipc	a2,0x2
ffffffffc0203c70:	7bc60613          	addi	a2,a2,1980 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203c74:	12c00593          	li	a1,300
ffffffffc0203c78:	00003517          	auipc	a0,0x3
ffffffffc0203c7c:	2d050513          	addi	a0,a0,720 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203c80:	fc6fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(mm != NULL);
ffffffffc0203c84:	00003697          	auipc	a3,0x3
ffffffffc0203c88:	34c68693          	addi	a3,a3,844 # ffffffffc0206fd0 <etext+0x155c>
ffffffffc0203c8c:	00002617          	auipc	a2,0x2
ffffffffc0203c90:	79c60613          	addi	a2,a2,1948 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203c94:	12400593          	li	a1,292
ffffffffc0203c98:	00003517          	auipc	a0,0x3
ffffffffc0203c9c:	2b050513          	addi	a0,a0,688 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203ca0:	fa6fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma != NULL);
ffffffffc0203ca4:	00003697          	auipc	a3,0x3
ffffffffc0203ca8:	37c68693          	addi	a3,a3,892 # ffffffffc0207020 <etext+0x15ac>
ffffffffc0203cac:	00002617          	auipc	a2,0x2
ffffffffc0203cb0:	77c60613          	addi	a2,a2,1916 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203cb4:	13300593          	li	a1,307
ffffffffc0203cb8:	00003517          	auipc	a0,0x3
ffffffffc0203cbc:	29050513          	addi	a0,a0,656 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203cc0:	f86fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203cc4:	00003697          	auipc	a3,0x3
ffffffffc0203cc8:	38468693          	addi	a3,a3,900 # ffffffffc0207048 <etext+0x15d4>
ffffffffc0203ccc:	00002617          	auipc	a2,0x2
ffffffffc0203cd0:	75c60613          	addi	a2,a2,1884 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203cd4:	13d00593          	li	a1,317
ffffffffc0203cd8:	00003517          	auipc	a0,0x3
ffffffffc0203cdc:	27050513          	addi	a0,a0,624 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203ce0:	f66fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203ce4:	00003697          	auipc	a3,0x3
ffffffffc0203ce8:	41c68693          	addi	a3,a3,1052 # ffffffffc0207100 <etext+0x168c>
ffffffffc0203cec:	00002617          	auipc	a2,0x2
ffffffffc0203cf0:	73c60613          	addi	a2,a2,1852 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203cf4:	14f00593          	li	a1,335
ffffffffc0203cf8:	00003517          	auipc	a0,0x3
ffffffffc0203cfc:	25050513          	addi	a0,a0,592 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203d00:	f46fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203d04:	00003697          	auipc	a3,0x3
ffffffffc0203d08:	3cc68693          	addi	a3,a3,972 # ffffffffc02070d0 <etext+0x165c>
ffffffffc0203d0c:	00002617          	auipc	a2,0x2
ffffffffc0203d10:	71c60613          	addi	a2,a2,1820 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203d14:	14e00593          	li	a1,334
ffffffffc0203d18:	00003517          	auipc	a0,0x3
ffffffffc0203d1c:	23050513          	addi	a0,a0,560 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203d20:	f26fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma5 == NULL);
ffffffffc0203d24:	00003697          	auipc	a3,0x3
ffffffffc0203d28:	39c68693          	addi	a3,a3,924 # ffffffffc02070c0 <etext+0x164c>
ffffffffc0203d2c:	00002617          	auipc	a2,0x2
ffffffffc0203d30:	6fc60613          	addi	a2,a2,1788 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203d34:	14c00593          	li	a1,332
ffffffffc0203d38:	00003517          	auipc	a0,0x3
ffffffffc0203d3c:	21050513          	addi	a0,a0,528 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203d40:	f06fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma4 == NULL);
ffffffffc0203d44:	00003697          	auipc	a3,0x3
ffffffffc0203d48:	36c68693          	addi	a3,a3,876 # ffffffffc02070b0 <etext+0x163c>
ffffffffc0203d4c:	00002617          	auipc	a2,0x2
ffffffffc0203d50:	6dc60613          	addi	a2,a2,1756 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203d54:	14a00593          	li	a1,330
ffffffffc0203d58:	00003517          	auipc	a0,0x3
ffffffffc0203d5c:	1f050513          	addi	a0,a0,496 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203d60:	ee6fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma3 == NULL);
ffffffffc0203d64:	00003697          	auipc	a3,0x3
ffffffffc0203d68:	33c68693          	addi	a3,a3,828 # ffffffffc02070a0 <etext+0x162c>
ffffffffc0203d6c:	00002617          	auipc	a2,0x2
ffffffffc0203d70:	6bc60613          	addi	a2,a2,1724 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203d74:	14800593          	li	a1,328
ffffffffc0203d78:	00003517          	auipc	a0,0x3
ffffffffc0203d7c:	1d050513          	addi	a0,a0,464 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203d80:	ec6fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203d84:	00003697          	auipc	a3,0x3
ffffffffc0203d88:	2ac68693          	addi	a3,a3,684 # ffffffffc0207030 <etext+0x15bc>
ffffffffc0203d8c:	00002617          	auipc	a2,0x2
ffffffffc0203d90:	69c60613          	addi	a2,a2,1692 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203d94:	13b00593          	li	a1,315
ffffffffc0203d98:	00003517          	auipc	a0,0x3
ffffffffc0203d9c:	1b050513          	addi	a0,a0,432 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203da0:	ea6fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma2 != NULL);
ffffffffc0203da4:	00003697          	auipc	a3,0x3
ffffffffc0203da8:	2ec68693          	addi	a3,a3,748 # ffffffffc0207090 <etext+0x161c>
ffffffffc0203dac:	00002617          	auipc	a2,0x2
ffffffffc0203db0:	67c60613          	addi	a2,a2,1660 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203db4:	14600593          	li	a1,326
ffffffffc0203db8:	00003517          	auipc	a0,0x3
ffffffffc0203dbc:	19050513          	addi	a0,a0,400 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203dc0:	e86fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma1 != NULL);
ffffffffc0203dc4:	00003697          	auipc	a3,0x3
ffffffffc0203dc8:	2bc68693          	addi	a3,a3,700 # ffffffffc0207080 <etext+0x160c>
ffffffffc0203dcc:	00002617          	auipc	a2,0x2
ffffffffc0203dd0:	65c60613          	addi	a2,a2,1628 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203dd4:	14400593          	li	a1,324
ffffffffc0203dd8:	00003517          	auipc	a0,0x3
ffffffffc0203ddc:	17050513          	addi	a0,a0,368 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203de0:	e66fc0ef          	jal	ffffffffc0200446 <__panic>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203de4:	6914                	ld	a3,16(a0)
ffffffffc0203de6:	6510                	ld	a2,8(a0)
ffffffffc0203de8:	0004859b          	sext.w	a1,s1
ffffffffc0203dec:	00003517          	auipc	a0,0x3
ffffffffc0203df0:	34450513          	addi	a0,a0,836 # ffffffffc0207130 <etext+0x16bc>
ffffffffc0203df4:	ba0fc0ef          	jal	ffffffffc0200194 <cprintf>
        assert(vma_below_5 == NULL);
ffffffffc0203df8:	00003697          	auipc	a3,0x3
ffffffffc0203dfc:	36068693          	addi	a3,a3,864 # ffffffffc0207158 <etext+0x16e4>
ffffffffc0203e00:	00002617          	auipc	a2,0x2
ffffffffc0203e04:	62860613          	addi	a2,a2,1576 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0203e08:	15900593          	li	a1,345
ffffffffc0203e0c:	00003517          	auipc	a0,0x3
ffffffffc0203e10:	13c50513          	addi	a0,a0,316 # ffffffffc0206f48 <etext+0x14d4>
ffffffffc0203e14:	e32fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203e18 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203e18:	7179                	addi	sp,sp,-48
ffffffffc0203e1a:	f022                	sd	s0,32(sp)
ffffffffc0203e1c:	f406                	sd	ra,40(sp)
ffffffffc0203e1e:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203e20:	c52d                	beqz	a0,ffffffffc0203e8a <user_mem_check+0x72>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203e22:	002007b7          	lui	a5,0x200
ffffffffc0203e26:	04f5ed63          	bltu	a1,a5,ffffffffc0203e80 <user_mem_check+0x68>
ffffffffc0203e2a:	ec26                	sd	s1,24(sp)
ffffffffc0203e2c:	00c584b3          	add	s1,a1,a2
ffffffffc0203e30:	0695ff63          	bgeu	a1,s1,ffffffffc0203eae <user_mem_check+0x96>
ffffffffc0203e34:	4785                	li	a5,1
ffffffffc0203e36:	07fe                	slli	a5,a5,0x1f
ffffffffc0203e38:	0785                	addi	a5,a5,1 # 200001 <_binary_obj___user_exit_out_size+0x1f5e41>
ffffffffc0203e3a:	06f4fa63          	bgeu	s1,a5,ffffffffc0203eae <user_mem_check+0x96>
ffffffffc0203e3e:	e84a                	sd	s2,16(sp)
ffffffffc0203e40:	e44e                	sd	s3,8(sp)
ffffffffc0203e42:	8936                	mv	s2,a3
ffffffffc0203e44:	89aa                	mv	s3,a0
ffffffffc0203e46:	a829                	j	ffffffffc0203e60 <user_mem_check+0x48>
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203e48:	6685                	lui	a3,0x1
ffffffffc0203e4a:	9736                	add	a4,a4,a3
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203e4c:	0027f693          	andi	a3,a5,2
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203e50:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203e52:	c685                	beqz	a3,ffffffffc0203e7a <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203e54:	c399                	beqz	a5,ffffffffc0203e5a <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203e56:	02e46263          	bltu	s0,a4,ffffffffc0203e7a <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203e5a:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203e5c:	04947b63          	bgeu	s0,s1,ffffffffc0203eb2 <user_mem_check+0x9a>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203e60:	85a2                	mv	a1,s0
ffffffffc0203e62:	854e                	mv	a0,s3
ffffffffc0203e64:	959ff0ef          	jal	ffffffffc02037bc <find_vma>
ffffffffc0203e68:	c909                	beqz	a0,ffffffffc0203e7a <user_mem_check+0x62>
ffffffffc0203e6a:	6518                	ld	a4,8(a0)
ffffffffc0203e6c:	00e46763          	bltu	s0,a4,ffffffffc0203e7a <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203e70:	4d1c                	lw	a5,24(a0)
ffffffffc0203e72:	fc091be3          	bnez	s2,ffffffffc0203e48 <user_mem_check+0x30>
ffffffffc0203e76:	8b85                	andi	a5,a5,1
ffffffffc0203e78:	f3ed                	bnez	a5,ffffffffc0203e5a <user_mem_check+0x42>
ffffffffc0203e7a:	64e2                	ld	s1,24(sp)
ffffffffc0203e7c:	6942                	ld	s2,16(sp)
ffffffffc0203e7e:	69a2                	ld	s3,8(sp)
            return 0;
ffffffffc0203e80:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc0203e82:	70a2                	ld	ra,40(sp)
ffffffffc0203e84:	7402                	ld	s0,32(sp)
ffffffffc0203e86:	6145                	addi	sp,sp,48
ffffffffc0203e88:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203e8a:	c02007b7          	lui	a5,0xc0200
ffffffffc0203e8e:	fef5eae3          	bltu	a1,a5,ffffffffc0203e82 <user_mem_check+0x6a>
ffffffffc0203e92:	c80007b7          	lui	a5,0xc8000
ffffffffc0203e96:	962e                	add	a2,a2,a1
ffffffffc0203e98:	0785                	addi	a5,a5,1 # ffffffffc8000001 <end+0x7d5b019>
ffffffffc0203e9a:	00c5b433          	sltu	s0,a1,a2
ffffffffc0203e9e:	00f63633          	sltu	a2,a2,a5
}
ffffffffc0203ea2:	70a2                	ld	ra,40(sp)
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203ea4:	00867533          	and	a0,a2,s0
}
ffffffffc0203ea8:	7402                	ld	s0,32(sp)
ffffffffc0203eaa:	6145                	addi	sp,sp,48
ffffffffc0203eac:	8082                	ret
ffffffffc0203eae:	64e2                	ld	s1,24(sp)
ffffffffc0203eb0:	bfc1                	j	ffffffffc0203e80 <user_mem_check+0x68>
ffffffffc0203eb2:	64e2                	ld	s1,24(sp)
ffffffffc0203eb4:	6942                	ld	s2,16(sp)
ffffffffc0203eb6:	69a2                	ld	s3,8(sp)
        return 1;
ffffffffc0203eb8:	4505                	li	a0,1
ffffffffc0203eba:	b7e1                	j	ffffffffc0203e82 <user_mem_check+0x6a>

ffffffffc0203ebc <do_pgfault>:

int do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc0203ebc:	7139                	addi	sp,sp,-64
ffffffffc0203ebe:	e852                	sd	s4,16(sp)
ffffffffc0203ec0:	8a2e                	mv	s4,a1
    int ret = -E_INVAL;
    
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0203ec2:	85b2                	mv	a1,a2
int do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc0203ec4:	f426                	sd	s1,40(sp)
ffffffffc0203ec6:	f04a                	sd	s2,32(sp)
ffffffffc0203ec8:	fc06                	sd	ra,56(sp)
ffffffffc0203eca:	84b2                	mv	s1,a2
ffffffffc0203ecc:	892a                	mv	s2,a0
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0203ece:	8efff0ef          	jal	ffffffffc02037bc <find_vma>
    if (vma == NULL || vma->vm_start > addr) {
ffffffffc0203ed2:	12050e63          	beqz	a0,ffffffffc020400e <do_pgfault+0x152>
ffffffffc0203ed6:	651c                	ld	a5,8(a0)
ffffffffc0203ed8:	12f4eb63          	bltu	s1,a5,ffffffffc020400e <do_pgfault+0x152>
        cprintf("not valid addr %x, and can not find it in vma\n", addr);
        goto failed;
    }

    uint32_t perm = PTE_U | PTE_V;
    if (vma->vm_flags & VM_WRITE) {
ffffffffc0203edc:	f822                	sd	s0,48(sp)
ffffffffc0203ede:	4d00                	lw	s0,24(a0)
ffffffffc0203ee0:	ec4e                	sd	s3,24(sp)
        perm |= (PTE_R | PTE_W);
ffffffffc0203ee2:	49dd                	li	s3,23
    if (vma->vm_flags & VM_WRITE) {
ffffffffc0203ee4:	00247793          	andi	a5,s0,2
ffffffffc0203ee8:	10078863          	beqz	a5,ffffffffc0203ff8 <do_pgfault+0x13c>
    }
    if (vma->vm_flags & VM_READ) {
        perm |= PTE_R;
    }

    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0203eec:	77fd                	lui	a5,0xfffff
    
    pte_t *ptep = get_pte(mm->pgdir, addr, 1);
ffffffffc0203eee:	01893503          	ld	a0,24(s2)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0203ef2:	8cfd                	and	s1,s1,a5
    pte_t *ptep = get_pte(mm->pgdir, addr, 1);
ffffffffc0203ef4:	85a6                	mv	a1,s1
ffffffffc0203ef6:	4605                	li	a2,1
ffffffffc0203ef8:	87efe0ef          	jal	ffffffffc0201f76 <get_pte>
ffffffffc0203efc:	87aa                	mv	a5,a0
    if (ptep == NULL) {
ffffffffc0203efe:	12050163          	beqz	a0,ffffffffc0204020 <do_pgfault+0x164>
        cprintf("get_pte in do_pgfault failed\n");
        goto failed;
    }
    
    // COW 处理
    if (*ptep & PTE_V) {
ffffffffc0203f02:	6114                	ld	a3,0(a0)
    if (vma->vm_flags & VM_READ) {
ffffffffc0203f04:	8805                	andi	s0,s0,1
ffffffffc0203f06:	0014141b          	slliw	s0,s0,0x1
ffffffffc0203f0a:	01346433          	or	s0,s0,s3
    if (*ptep & PTE_V) {
ffffffffc0203f0e:	4705                	li	a4,1
ffffffffc0203f10:	0056f993          	andi	s3,a3,5
ffffffffc0203f14:	02e98363          	beq	s3,a4,ffffffffc0203f3a <do_pgfault+0x7e>
            return ret;
        }
    }
    
    // 原有的缺页处理逻辑
    if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc0203f18:	01893503          	ld	a0,24(s2)
ffffffffc0203f1c:	8622                	mv	a2,s0
ffffffffc0203f1e:	85a6                	mv	a1,s1
ffffffffc0203f20:	f34ff0ef          	jal	ffffffffc0203654 <pgdir_alloc_page>
ffffffffc0203f24:	10050863          	beqz	a0,ffffffffc0204034 <do_pgfault+0x178>
ffffffffc0203f28:	7442                	ld	s0,48(sp)
ffffffffc0203f2a:	69e2                	ld	s3,24(sp)
            return ret;
ffffffffc0203f2c:	4501                	li	a0,0
    }
    
    ret = 0;
failed:
    return ret;
ffffffffc0203f2e:	70e2                	ld	ra,56(sp)
ffffffffc0203f30:	74a2                	ld	s1,40(sp)
ffffffffc0203f32:	7902                	ld	s2,32(sp)
ffffffffc0203f34:	6a42                	ld	s4,16(sp)
ffffffffc0203f36:	6121                	addi	sp,sp,64
ffffffffc0203f38:	8082                	ret
        if ((error_code & 0x2) && !(*ptep & PTE_W)) {
ffffffffc0203f3a:	002a7713          	andi	a4,s4,2
ffffffffc0203f3e:	df69                	beqz	a4,ffffffffc0203f18 <do_pgfault+0x5c>
    if (PPN(pa) >= npage)
ffffffffc0203f40:	000a1617          	auipc	a2,0xa1
ffffffffc0203f44:	07863603          	ld	a2,120(a2) # ffffffffc02a4fb8 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0203f48:	00269713          	slli	a4,a3,0x2
ffffffffc0203f4c:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc0203f4e:	0ec77d63          	bgeu	a4,a2,ffffffffc0204048 <do_pgfault+0x18c>
    return &pages[PPN(pa) - nbase];
ffffffffc0203f52:	00004817          	auipc	a6,0x4
ffffffffc0203f56:	cd683803          	ld	a6,-810(a6) # ffffffffc0207c28 <nbase>
ffffffffc0203f5a:	000a1617          	auipc	a2,0xa1
ffffffffc0203f5e:	06663603          	ld	a2,102(a2) # ffffffffc02a4fc0 <pages>
ffffffffc0203f62:	41070733          	sub	a4,a4,a6
ffffffffc0203f66:	071a                	slli	a4,a4,0x6
ffffffffc0203f68:	9732                	add	a4,a4,a2
            if (page_ref(page) == 1) {
ffffffffc0203f6a:	4310                	lw	a2,0(a4)
ffffffffc0203f6c:	09360863          	beq	a2,s3,ffffffffc0203ffc <do_pgfault+0x140>
                struct Page *npage = alloc_page();
ffffffffc0203f70:	854e                	mv	a0,s3
ffffffffc0203f72:	e43a                	sd	a4,8(sp)
ffffffffc0203f74:	e042                	sd	a6,0(sp)
ffffffffc0203f76:	f59fd0ef          	jal	ffffffffc0201ece <alloc_pages>
                if (npage == NULL) {
ffffffffc0203f7a:	6802                	ld	a6,0(sp)
ffffffffc0203f7c:	6722                	ld	a4,8(sp)
                struct Page *npage = alloc_page();
ffffffffc0203f7e:	8a2a                	mv	s4,a0
                if (npage == NULL) {
ffffffffc0203f80:	c925                	beqz	a0,ffffffffc0203ff0 <do_pgfault+0x134>
    return page - pages + nbase;
ffffffffc0203f82:	000a1797          	auipc	a5,0xa1
ffffffffc0203f86:	03e7b783          	ld	a5,62(a5) # ffffffffc02a4fc0 <pages>
    return KADDR(page2pa(page));
ffffffffc0203f8a:	567d                	li	a2,-1
ffffffffc0203f8c:	000a1517          	auipc	a0,0xa1
ffffffffc0203f90:	02c53503          	ld	a0,44(a0) # ffffffffc02a4fb8 <npage>
    return page - pages + nbase;
ffffffffc0203f94:	40f706b3          	sub	a3,a4,a5
ffffffffc0203f98:	8699                	srai	a3,a3,0x6
ffffffffc0203f9a:	96c2                	add	a3,a3,a6
    return KADDR(page2pa(page));
ffffffffc0203f9c:	00c65713          	srli	a4,a2,0xc
ffffffffc0203fa0:	00e6f633          	and	a2,a3,a4
    return page2ppn(page) << PGSHIFT;
ffffffffc0203fa4:	00c69593          	slli	a1,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203fa8:	0ca67863          	bgeu	a2,a0,ffffffffc0204078 <do_pgfault+0x1bc>
    return page - pages + nbase;
ffffffffc0203fac:	40fa06b3          	sub	a3,s4,a5
ffffffffc0203fb0:	8699                	srai	a3,a3,0x6
ffffffffc0203fb2:	96c2                	add	a3,a3,a6
    return KADDR(page2pa(page));
ffffffffc0203fb4:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0203fb6:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203fb8:	0aa77463          	bgeu	a4,a0,ffffffffc0204060 <do_pgfault+0x1a4>
ffffffffc0203fbc:	000a1517          	auipc	a0,0xa1
ffffffffc0203fc0:	ff453503          	ld	a0,-12(a0) # ffffffffc02a4fb0 <va_pa_offset>
                memcpy(dst, src, PGSIZE);
ffffffffc0203fc4:	6605                	lui	a2,0x1
ffffffffc0203fc6:	95aa                	add	a1,a1,a0
ffffffffc0203fc8:	9536                	add	a0,a0,a3
ffffffffc0203fca:	293010ef          	jal	ffffffffc0205a5c <memcpy>
                page_remove(mm->pgdir, addr);
ffffffffc0203fce:	01893503          	ld	a0,24(s2)
ffffffffc0203fd2:	85a6                	mv	a1,s1
ffffffffc0203fd4:	e3cfe0ef          	jal	ffffffffc0202610 <page_remove>
                if (page_insert(mm->pgdir, npage, addr, perm) != 0) {
ffffffffc0203fd8:	01893503          	ld	a0,24(s2)
ffffffffc0203fdc:	86a2                	mv	a3,s0
ffffffffc0203fde:	8626                	mv	a2,s1
ffffffffc0203fe0:	85d2                	mv	a1,s4
ffffffffc0203fe2:	ecafe0ef          	jal	ffffffffc02026ac <page_insert>
ffffffffc0203fe6:	d129                	beqz	a0,ffffffffc0203f28 <do_pgfault+0x6c>
                    free_page(npage);
ffffffffc0203fe8:	85ce                	mv	a1,s3
ffffffffc0203fea:	8552                	mv	a0,s4
ffffffffc0203fec:	f1dfd0ef          	jal	ffffffffc0201f08 <free_pages>
                    goto failed;
ffffffffc0203ff0:	7442                	ld	s0,48(sp)
ffffffffc0203ff2:	69e2                	ld	s3,24(sp)
                    ret = -E_NO_MEM;
ffffffffc0203ff4:	5571                	li	a0,-4
ffffffffc0203ff6:	bf25                	j	ffffffffc0203f2e <do_pgfault+0x72>
    uint32_t perm = PTE_U | PTE_V;
ffffffffc0203ff8:	49c5                	li	s3,17
ffffffffc0203ffa:	bdcd                	j	ffffffffc0203eec <do_pgfault+0x30>
                tlb_invalidate(mm->pgdir, addr);
ffffffffc0203ffc:	01893503          	ld	a0,24(s2)
                *ptep |= PTE_W;
ffffffffc0204000:	0046e693          	ori	a3,a3,4
ffffffffc0204004:	e394                	sd	a3,0(a5)
                tlb_invalidate(mm->pgdir, addr);
ffffffffc0204006:	85a6                	mv	a1,s1
ffffffffc0204008:	e46ff0ef          	jal	ffffffffc020364e <tlb_invalidate>
ffffffffc020400c:	bf31                	j	ffffffffc0203f28 <do_pgfault+0x6c>
        cprintf("not valid addr %x, and can not find it in vma\n", addr);
ffffffffc020400e:	85a6                	mv	a1,s1
ffffffffc0204010:	00003517          	auipc	a0,0x3
ffffffffc0204014:	19850513          	addi	a0,a0,408 # ffffffffc02071a8 <etext+0x1734>
ffffffffc0204018:	97cfc0ef          	jal	ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc020401c:	5575                	li	a0,-3
ffffffffc020401e:	bf01                	j	ffffffffc0203f2e <do_pgfault+0x72>
        cprintf("get_pte in do_pgfault failed\n");
ffffffffc0204020:	00003517          	auipc	a0,0x3
ffffffffc0204024:	1b850513          	addi	a0,a0,440 # ffffffffc02071d8 <etext+0x1764>
ffffffffc0204028:	96cfc0ef          	jal	ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc020402c:	5575                	li	a0,-3
        goto failed;
ffffffffc020402e:	7442                	ld	s0,48(sp)
ffffffffc0204030:	69e2                	ld	s3,24(sp)
ffffffffc0204032:	bdf5                	j	ffffffffc0203f2e <do_pgfault+0x72>
        cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc0204034:	00003517          	auipc	a0,0x3
ffffffffc0204038:	1c450513          	addi	a0,a0,452 # ffffffffc02071f8 <etext+0x1784>
ffffffffc020403c:	958fc0ef          	jal	ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc0204040:	5575                	li	a0,-3
        cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc0204042:	7442                	ld	s0,48(sp)
ffffffffc0204044:	69e2                	ld	s3,24(sp)
ffffffffc0204046:	b5e5                	j	ffffffffc0203f2e <do_pgfault+0x72>
        panic("pa2page called with invalid pa");
ffffffffc0204048:	00003617          	auipc	a2,0x3
ffffffffc020404c:	86060613          	addi	a2,a2,-1952 # ffffffffc02068a8 <etext+0xe34>
ffffffffc0204050:	06900593          	li	a1,105
ffffffffc0204054:	00002517          	auipc	a0,0x2
ffffffffc0204058:	7ac50513          	addi	a0,a0,1964 # ffffffffc0206800 <etext+0xd8c>
ffffffffc020405c:	beafc0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc0204060:	00002617          	auipc	a2,0x2
ffffffffc0204064:	77860613          	addi	a2,a2,1912 # ffffffffc02067d8 <etext+0xd64>
ffffffffc0204068:	07100593          	li	a1,113
ffffffffc020406c:	00002517          	auipc	a0,0x2
ffffffffc0204070:	79450513          	addi	a0,a0,1940 # ffffffffc0206800 <etext+0xd8c>
ffffffffc0204074:	bd2fc0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0204078:	86ae                	mv	a3,a1
ffffffffc020407a:	00002617          	auipc	a2,0x2
ffffffffc020407e:	75e60613          	addi	a2,a2,1886 # ffffffffc02067d8 <etext+0xd64>
ffffffffc0204082:	07100593          	li	a1,113
ffffffffc0204086:	00002517          	auipc	a0,0x2
ffffffffc020408a:	77a50513          	addi	a0,a0,1914 # ffffffffc0206800 <etext+0xd8c>
ffffffffc020408e:	bb8fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0204092 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0204092:	8526                	mv	a0,s1
	jalr s0
ffffffffc0204094:	9402                	jalr	s0

	jal do_exit
ffffffffc0204096:	670000ef          	jal	ffffffffc0204706 <do_exit>

ffffffffc020409a <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc020409a:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc020409c:	10800513          	li	a0,264
{
ffffffffc02040a0:	e022                	sd	s0,0(sp)
ffffffffc02040a2:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02040a4:	c69fd0ef          	jal	ffffffffc0201d0c <kmalloc>
ffffffffc02040a8:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc02040aa:	cd21                	beqz	a0,ffffffffc0204102 <alloc_proc+0x68>
         *       struct trapframe *tf;                       // Trap frame for current interrupt
         *       uintptr_t pgdir;                            // the base addr of Page Directroy Table(PDT)
         *       uint32_t flags;                             // Process flag
         *       char name[PROC_NAME_LEN + 1];               // Process name
         */
        proc->state = PROC_UNINIT;
ffffffffc02040ac:	57fd                	li	a5,-1
ffffffffc02040ae:	1782                	slli	a5,a5,0x20
ffffffffc02040b0:	e11c                	sd	a5,0(a0)
        proc->pid = -1;
        proc->runs = 0;
ffffffffc02040b2:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc02040b6:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc02040ba:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc02040be:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc02040c2:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc02040c6:	07000613          	li	a2,112
ffffffffc02040ca:	4581                	li	a1,0
ffffffffc02040cc:	03050513          	addi	a0,a0,48
ffffffffc02040d0:	17b010ef          	jal	ffffffffc0205a4a <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc02040d4:	000a1797          	auipc	a5,0xa1
ffffffffc02040d8:	ecc7b783          	ld	a5,-308(a5) # ffffffffc02a4fa0 <boot_pgdir_pa>
        proc->tf = NULL;
ffffffffc02040dc:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc02040e0:	0a042823          	sw	zero,176(s0)
        proc->pgdir = boot_pgdir_pa;
ffffffffc02040e4:	f45c                	sd	a5,168(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1);
ffffffffc02040e6:	0b440513          	addi	a0,s0,180
ffffffffc02040ea:	4641                	li	a2,16
ffffffffc02040ec:	4581                	li	a1,0
ffffffffc02040ee:	15d010ef          	jal	ffffffffc0205a4a <memset>
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        proc->wait_state = 0;
        proc->cptr = proc->yptr = proc->optr = NULL;
        proc->exit_code = 0;
ffffffffc02040f2:	0e043423          	sd	zero,232(s0)
        proc->cptr = proc->yptr = proc->optr = NULL;
ffffffffc02040f6:	0e043823          	sd	zero,240(s0)
ffffffffc02040fa:	0e043c23          	sd	zero,248(s0)
ffffffffc02040fe:	10043023          	sd	zero,256(s0)
    }
    return proc;
}
ffffffffc0204102:	60a2                	ld	ra,8(sp)
ffffffffc0204104:	8522                	mv	a0,s0
ffffffffc0204106:	6402                	ld	s0,0(sp)
ffffffffc0204108:	0141                	addi	sp,sp,16
ffffffffc020410a:	8082                	ret

ffffffffc020410c <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc020410c:	000a1797          	auipc	a5,0xa1
ffffffffc0204110:	ec47b783          	ld	a5,-316(a5) # ffffffffc02a4fd0 <current>
ffffffffc0204114:	73c8                	ld	a0,160(a5)
ffffffffc0204116:	dddfc06f          	j	ffffffffc0200ef2 <forkrets>

ffffffffc020411a <user_main>:
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
#else
    KERNEL_EXECVE(exit);
ffffffffc020411a:	000a1797          	auipc	a5,0xa1
ffffffffc020411e:	eb67b783          	ld	a5,-330(a5) # ffffffffc02a4fd0 <current>
{
ffffffffc0204122:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE(exit);
ffffffffc0204124:	00003617          	auipc	a2,0x3
ffffffffc0204128:	0fc60613          	addi	a2,a2,252 # ffffffffc0207220 <etext+0x17ac>
ffffffffc020412c:	43cc                	lw	a1,4(a5)
ffffffffc020412e:	00003517          	auipc	a0,0x3
ffffffffc0204132:	0fa50513          	addi	a0,a0,250 # ffffffffc0207228 <etext+0x17b4>
{
ffffffffc0204136:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE(exit);
ffffffffc0204138:	85cfc0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc020413c:	3fe06797          	auipc	a5,0x3fe06
ffffffffc0204140:	08478793          	addi	a5,a5,132 # a1c0 <_binary_obj___user_exit_out_size>
ffffffffc0204144:	e43e                	sd	a5,8(sp)
kernel_execve(const char *name, unsigned char *binary, size_t size)
ffffffffc0204146:	00003517          	auipc	a0,0x3
ffffffffc020414a:	0da50513          	addi	a0,a0,218 # ffffffffc0207220 <etext+0x17ac>
ffffffffc020414e:	0002d797          	auipc	a5,0x2d
ffffffffc0204152:	be278793          	addi	a5,a5,-1054 # ffffffffc0230d30 <_binary_obj___user_exit_out_start>
ffffffffc0204156:	f03e                	sd	a5,32(sp)
ffffffffc0204158:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc020415a:	e802                	sd	zero,16(sp)
ffffffffc020415c:	03b010ef          	jal	ffffffffc0205996 <strlen>
ffffffffc0204160:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0204162:	4511                	li	a0,4
ffffffffc0204164:	55a2                	lw	a1,40(sp)
ffffffffc0204166:	4662                	lw	a2,24(sp)
ffffffffc0204168:	5682                	lw	a3,32(sp)
ffffffffc020416a:	4722                	lw	a4,8(sp)
ffffffffc020416c:	48a9                	li	a7,10
ffffffffc020416e:	9002                	ebreak
ffffffffc0204170:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0204172:	65c2                	ld	a1,16(sp)
ffffffffc0204174:	00003517          	auipc	a0,0x3
ffffffffc0204178:	0dc50513          	addi	a0,a0,220 # ffffffffc0207250 <etext+0x17dc>
ffffffffc020417c:	818fc0ef          	jal	ffffffffc0200194 <cprintf>
#endif
    panic("user_main execve failed.\n");
ffffffffc0204180:	00003617          	auipc	a2,0x3
ffffffffc0204184:	0e060613          	addi	a2,a2,224 # ffffffffc0207260 <etext+0x17ec>
ffffffffc0204188:	3a200593          	li	a1,930
ffffffffc020418c:	00003517          	auipc	a0,0x3
ffffffffc0204190:	0f450513          	addi	a0,a0,244 # ffffffffc0207280 <etext+0x180c>
ffffffffc0204194:	ab2fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0204198 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0204198:	6d14                	ld	a3,24(a0)
{
ffffffffc020419a:	1141                	addi	sp,sp,-16
ffffffffc020419c:	e406                	sd	ra,8(sp)
ffffffffc020419e:	c02007b7          	lui	a5,0xc0200
ffffffffc02041a2:	02f6ee63          	bltu	a3,a5,ffffffffc02041de <put_pgdir+0x46>
ffffffffc02041a6:	000a1717          	auipc	a4,0xa1
ffffffffc02041aa:	e0a73703          	ld	a4,-502(a4) # ffffffffc02a4fb0 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc02041ae:	000a1797          	auipc	a5,0xa1
ffffffffc02041b2:	e0a7b783          	ld	a5,-502(a5) # ffffffffc02a4fb8 <npage>
    return pa2page(PADDR(kva));
ffffffffc02041b6:	8e99                	sub	a3,a3,a4
    if (PPN(pa) >= npage)
ffffffffc02041b8:	82b1                	srli	a3,a3,0xc
ffffffffc02041ba:	02f6fe63          	bgeu	a3,a5,ffffffffc02041f6 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc02041be:	00004797          	auipc	a5,0x4
ffffffffc02041c2:	a6a7b783          	ld	a5,-1430(a5) # ffffffffc0207c28 <nbase>
ffffffffc02041c6:	000a1517          	auipc	a0,0xa1
ffffffffc02041ca:	dfa53503          	ld	a0,-518(a0) # ffffffffc02a4fc0 <pages>
}
ffffffffc02041ce:	60a2                	ld	ra,8(sp)
ffffffffc02041d0:	8e9d                	sub	a3,a3,a5
ffffffffc02041d2:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc02041d4:	4585                	li	a1,1
ffffffffc02041d6:	9536                	add	a0,a0,a3
}
ffffffffc02041d8:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc02041da:	d2ffd06f          	j	ffffffffc0201f08 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc02041de:	00002617          	auipc	a2,0x2
ffffffffc02041e2:	6a260613          	addi	a2,a2,1698 # ffffffffc0206880 <etext+0xe0c>
ffffffffc02041e6:	07700593          	li	a1,119
ffffffffc02041ea:	00002517          	auipc	a0,0x2
ffffffffc02041ee:	61650513          	addi	a0,a0,1558 # ffffffffc0206800 <etext+0xd8c>
ffffffffc02041f2:	a54fc0ef          	jal	ffffffffc0200446 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02041f6:	00002617          	auipc	a2,0x2
ffffffffc02041fa:	6b260613          	addi	a2,a2,1714 # ffffffffc02068a8 <etext+0xe34>
ffffffffc02041fe:	06900593          	li	a1,105
ffffffffc0204202:	00002517          	auipc	a0,0x2
ffffffffc0204206:	5fe50513          	addi	a0,a0,1534 # ffffffffc0206800 <etext+0xd8c>
ffffffffc020420a:	a3cfc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020420e <proc_run>:
    if (proc != current)
ffffffffc020420e:	000a1697          	auipc	a3,0xa1
ffffffffc0204212:	dc26b683          	ld	a3,-574(a3) # ffffffffc02a4fd0 <current>
ffffffffc0204216:	04a68463          	beq	a3,a0,ffffffffc020425e <proc_run+0x50>
{
ffffffffc020421a:	1101                	addi	sp,sp,-32
ffffffffc020421c:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020421e:	100027f3          	csrr	a5,sstatus
ffffffffc0204222:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204224:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204226:	ef8d                	bnez	a5,ffffffffc0204260 <proc_run+0x52>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0204228:	755c                	ld	a5,168(a0)
ffffffffc020422a:	577d                	li	a4,-1
ffffffffc020422c:	177e                	slli	a4,a4,0x3f
ffffffffc020422e:	83b1                	srli	a5,a5,0xc
ffffffffc0204230:	e032                	sd	a2,0(sp)
            current = proc;
ffffffffc0204232:	000a1597          	auipc	a1,0xa1
ffffffffc0204236:	d8a5bf23          	sd	a0,-610(a1) # ffffffffc02a4fd0 <current>
ffffffffc020423a:	8fd9                	or	a5,a5,a4
ffffffffc020423c:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(proc->context));
ffffffffc0204240:	03050593          	addi	a1,a0,48
ffffffffc0204244:	03068513          	addi	a0,a3,48
ffffffffc0204248:	106010ef          	jal	ffffffffc020534e <switch_to>
    if (flag)
ffffffffc020424c:	6602                	ld	a2,0(sp)
ffffffffc020424e:	e601                	bnez	a2,ffffffffc0204256 <proc_run+0x48>
}
ffffffffc0204250:	60e2                	ld	ra,24(sp)
ffffffffc0204252:	6105                	addi	sp,sp,32
ffffffffc0204254:	8082                	ret
ffffffffc0204256:	60e2                	ld	ra,24(sp)
ffffffffc0204258:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020425a:	ea4fc06f          	j	ffffffffc02008fe <intr_enable>
ffffffffc020425e:	8082                	ret
ffffffffc0204260:	e42a                	sd	a0,8(sp)
ffffffffc0204262:	e036                	sd	a3,0(sp)
        intr_disable();
ffffffffc0204264:	ea0fc0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0204268:	6522                	ld	a0,8(sp)
ffffffffc020426a:	6682                	ld	a3,0(sp)
ffffffffc020426c:	4605                	li	a2,1
ffffffffc020426e:	bf6d                	j	ffffffffc0204228 <proc_run+0x1a>

ffffffffc0204270 <do_fork>:
    if (nr_process >= MAX_PROCESS)
ffffffffc0204270:	000a1717          	auipc	a4,0xa1
ffffffffc0204274:	d5872703          	lw	a4,-680(a4) # ffffffffc02a4fc8 <nr_process>
ffffffffc0204278:	6785                	lui	a5,0x1
ffffffffc020427a:	36f75d63          	bge	a4,a5,ffffffffc02045f4 <do_fork+0x384>
{
ffffffffc020427e:	711d                	addi	sp,sp,-96
ffffffffc0204280:	e8a2                	sd	s0,80(sp)
ffffffffc0204282:	e4a6                	sd	s1,72(sp)
ffffffffc0204284:	e0ca                	sd	s2,64(sp)
ffffffffc0204286:	e06a                	sd	s10,0(sp)
ffffffffc0204288:	ec86                	sd	ra,88(sp)
ffffffffc020428a:	892e                	mv	s2,a1
ffffffffc020428c:	84b2                	mv	s1,a2
ffffffffc020428e:	8d2a                	mv	s10,a0
    if ((proc = alloc_proc()) == NULL) {
ffffffffc0204290:	e0bff0ef          	jal	ffffffffc020409a <alloc_proc>
ffffffffc0204294:	842a                	mv	s0,a0
ffffffffc0204296:	30050063          	beqz	a0,ffffffffc0204596 <do_fork+0x326>
    proc->parent = current;
ffffffffc020429a:	f05a                	sd	s6,32(sp)
ffffffffc020429c:	000a1b17          	auipc	s6,0xa1
ffffffffc02042a0:	d34b0b13          	addi	s6,s6,-716 # ffffffffc02a4fd0 <current>
ffffffffc02042a4:	000b3783          	ld	a5,0(s6)
    assert(current->wait_state == 0);
ffffffffc02042a8:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_obj___user_softint_out_size-0x7adc>
    proc->parent = current;
ffffffffc02042ac:	f11c                	sd	a5,32(a0)
    assert(current->wait_state == 0);
ffffffffc02042ae:	3c071263          	bnez	a4,ffffffffc0204672 <do_fork+0x402>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc02042b2:	4509                	li	a0,2
ffffffffc02042b4:	c1bfd0ef          	jal	ffffffffc0201ece <alloc_pages>
    if (page != NULL)
ffffffffc02042b8:	2c050b63          	beqz	a0,ffffffffc020458e <do_fork+0x31e>
ffffffffc02042bc:	fc4e                	sd	s3,56(sp)
    return page - pages + nbase;
ffffffffc02042be:	000a1997          	auipc	s3,0xa1
ffffffffc02042c2:	d0298993          	addi	s3,s3,-766 # ffffffffc02a4fc0 <pages>
ffffffffc02042c6:	0009b783          	ld	a5,0(s3)
ffffffffc02042ca:	f852                	sd	s4,48(sp)
ffffffffc02042cc:	00004a17          	auipc	s4,0x4
ffffffffc02042d0:	95ca0a13          	addi	s4,s4,-1700 # ffffffffc0207c28 <nbase>
ffffffffc02042d4:	e466                	sd	s9,8(sp)
ffffffffc02042d6:	000a3c83          	ld	s9,0(s4)
ffffffffc02042da:	40f506b3          	sub	a3,a0,a5
ffffffffc02042de:	f456                	sd	s5,40(sp)
    return KADDR(page2pa(page));
ffffffffc02042e0:	000a1a97          	auipc	s5,0xa1
ffffffffc02042e4:	cd8a8a93          	addi	s5,s5,-808 # ffffffffc02a4fb8 <npage>
ffffffffc02042e8:	e862                	sd	s8,16(sp)
    return page - pages + nbase;
ffffffffc02042ea:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc02042ec:	5c7d                	li	s8,-1
ffffffffc02042ee:	000ab783          	ld	a5,0(s5)
    return page - pages + nbase;
ffffffffc02042f2:	96e6                	add	a3,a3,s9
    return KADDR(page2pa(page));
ffffffffc02042f4:	00cc5c13          	srli	s8,s8,0xc
ffffffffc02042f8:	0186f733          	and	a4,a3,s8
ffffffffc02042fc:	ec5e                	sd	s7,24(sp)
    return page2ppn(page) << PGSHIFT;
ffffffffc02042fe:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204300:	30f77863          	bgeu	a4,a5,ffffffffc0204610 <do_fork+0x3a0>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204304:	000b3703          	ld	a4,0(s6)
ffffffffc0204308:	000a1b17          	auipc	s6,0xa1
ffffffffc020430c:	ca8b0b13          	addi	s6,s6,-856 # ffffffffc02a4fb0 <va_pa_offset>
ffffffffc0204310:	000b3783          	ld	a5,0(s6)
ffffffffc0204314:	02873b83          	ld	s7,40(a4)
ffffffffc0204318:	96be                	add	a3,a3,a5
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc020431a:	e814                	sd	a3,16(s0)
    if (oldmm == NULL)
ffffffffc020431c:	020b8863          	beqz	s7,ffffffffc020434c <do_fork+0xdc>
    if (clone_flags & CLONE_VM)
ffffffffc0204320:	100d7793          	andi	a5,s10,256
ffffffffc0204324:	18078b63          	beqz	a5,ffffffffc02044ba <do_fork+0x24a>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc0204328:	030ba703          	lw	a4,48(s7)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020432c:	018bb783          	ld	a5,24(s7)
ffffffffc0204330:	c02006b7          	lui	a3,0xc0200
ffffffffc0204334:	2705                	addiw	a4,a4,1
ffffffffc0204336:	02eba823          	sw	a4,48(s7)
    proc->mm = mm;
ffffffffc020433a:	03743423          	sd	s7,40(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020433e:	2ed7e563          	bltu	a5,a3,ffffffffc0204628 <do_fork+0x3b8>
ffffffffc0204342:	000b3703          	ld	a4,0(s6)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204346:	6814                	ld	a3,16(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204348:	8f99                	sub	a5,a5,a4
ffffffffc020434a:	f45c                	sd	a5,168(s0)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc020434c:	6789                	lui	a5,0x2
ffffffffc020434e:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_softint_out_size-0x6ce8>
ffffffffc0204352:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc0204354:	8626                	mv	a2,s1
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204356:	f054                	sd	a3,160(s0)
    *(proc->tf) = *tf;
ffffffffc0204358:	87b6                	mv	a5,a3
ffffffffc020435a:	12048713          	addi	a4,s1,288
ffffffffc020435e:	6a0c                	ld	a1,16(a2)
ffffffffc0204360:	00063803          	ld	a6,0(a2)
ffffffffc0204364:	6608                	ld	a0,8(a2)
ffffffffc0204366:	eb8c                	sd	a1,16(a5)
ffffffffc0204368:	0107b023          	sd	a6,0(a5)
ffffffffc020436c:	e788                	sd	a0,8(a5)
ffffffffc020436e:	6e0c                	ld	a1,24(a2)
ffffffffc0204370:	02060613          	addi	a2,a2,32
ffffffffc0204374:	02078793          	addi	a5,a5,32
ffffffffc0204378:	feb7bc23          	sd	a1,-8(a5)
ffffffffc020437c:	fee611e3          	bne	a2,a4,ffffffffc020435e <do_fork+0xee>
    proc->tf->gpr.a0 = 0;
ffffffffc0204380:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204384:	20090b63          	beqz	s2,ffffffffc020459a <do_fork+0x32a>
ffffffffc0204388:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020438c:	00000797          	auipc	a5,0x0
ffffffffc0204390:	d8078793          	addi	a5,a5,-640 # ffffffffc020410c <forkret>
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204394:	fc14                	sd	a3,56(s0)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204396:	f81c                	sd	a5,48(s0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204398:	100027f3          	csrr	a5,sstatus
ffffffffc020439c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020439e:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02043a0:	20079c63          	bnez	a5,ffffffffc02045b8 <do_fork+0x348>
    if (++last_pid >= MAX_PID)
ffffffffc02043a4:	0009c517          	auipc	a0,0x9c
ffffffffc02043a8:	79852503          	lw	a0,1944(a0) # ffffffffc02a0b3c <last_pid.1>
ffffffffc02043ac:	6789                	lui	a5,0x2
ffffffffc02043ae:	2505                	addiw	a0,a0,1
ffffffffc02043b0:	0009c717          	auipc	a4,0x9c
ffffffffc02043b4:	78a72623          	sw	a0,1932(a4) # ffffffffc02a0b3c <last_pid.1>
ffffffffc02043b8:	20f55f63          	bge	a0,a5,ffffffffc02045d6 <do_fork+0x366>
    if (last_pid >= next_safe)
ffffffffc02043bc:	0009c797          	auipc	a5,0x9c
ffffffffc02043c0:	77c7a783          	lw	a5,1916(a5) # ffffffffc02a0b38 <next_safe.0>
ffffffffc02043c4:	000a1497          	auipc	s1,0xa1
ffffffffc02043c8:	b9448493          	addi	s1,s1,-1132 # ffffffffc02a4f58 <proc_list>
ffffffffc02043cc:	06f54563          	blt	a0,a5,ffffffffc0204436 <do_fork+0x1c6>
ffffffffc02043d0:	000a1497          	auipc	s1,0xa1
ffffffffc02043d4:	b8848493          	addi	s1,s1,-1144 # ffffffffc02a4f58 <proc_list>
ffffffffc02043d8:	0084b883          	ld	a7,8(s1)
        next_safe = MAX_PID;
ffffffffc02043dc:	6789                	lui	a5,0x2
ffffffffc02043de:	0009c717          	auipc	a4,0x9c
ffffffffc02043e2:	74f72d23          	sw	a5,1882(a4) # ffffffffc02a0b38 <next_safe.0>
ffffffffc02043e6:	86aa                	mv	a3,a0
ffffffffc02043e8:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc02043ea:	04988063          	beq	a7,s1,ffffffffc020442a <do_fork+0x1ba>
ffffffffc02043ee:	882e                	mv	a6,a1
ffffffffc02043f0:	87c6                	mv	a5,a7
ffffffffc02043f2:	6609                	lui	a2,0x2
ffffffffc02043f4:	a811                	j	ffffffffc0204408 <do_fork+0x198>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02043f6:	00e6d663          	bge	a3,a4,ffffffffc0204402 <do_fork+0x192>
ffffffffc02043fa:	00c75463          	bge	a4,a2,ffffffffc0204402 <do_fork+0x192>
                next_safe = proc->pid;
ffffffffc02043fe:	863a                	mv	a2,a4
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204400:	4805                	li	a6,1
ffffffffc0204402:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204404:	00978d63          	beq	a5,s1,ffffffffc020441e <do_fork+0x1ae>
            if (proc->pid == last_pid)
ffffffffc0204408:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_softint_out_size-0x6c8c>
ffffffffc020440c:	fed715e3          	bne	a4,a3,ffffffffc02043f6 <do_fork+0x186>
                if (++last_pid >= next_safe)
ffffffffc0204410:	2685                	addiw	a3,a3,1
ffffffffc0204412:	1cc6db63          	bge	a3,a2,ffffffffc02045e8 <do_fork+0x378>
ffffffffc0204416:	679c                	ld	a5,8(a5)
ffffffffc0204418:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc020441a:	fe9797e3          	bne	a5,s1,ffffffffc0204408 <do_fork+0x198>
ffffffffc020441e:	00080663          	beqz	a6,ffffffffc020442a <do_fork+0x1ba>
ffffffffc0204422:	0009c797          	auipc	a5,0x9c
ffffffffc0204426:	70c7ab23          	sw	a2,1814(a5) # ffffffffc02a0b38 <next_safe.0>
ffffffffc020442a:	c591                	beqz	a1,ffffffffc0204436 <do_fork+0x1c6>
ffffffffc020442c:	0009c797          	auipc	a5,0x9c
ffffffffc0204430:	70d7a823          	sw	a3,1808(a5) # ffffffffc02a0b3c <last_pid.1>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204434:	8536                	mv	a0,a3
        proc->pid = get_pid();
ffffffffc0204436:	c048                	sw	a0,4(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204438:	45a9                	li	a1,10
ffffffffc020443a:	17a010ef          	jal	ffffffffc02055b4 <hash32>
ffffffffc020443e:	02051793          	slli	a5,a0,0x20
ffffffffc0204442:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204446:	0009d797          	auipc	a5,0x9d
ffffffffc020444a:	b1278793          	addi	a5,a5,-1262 # ffffffffc02a0f58 <hash_list>
ffffffffc020444e:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0204450:	6518                	ld	a4,8(a0)
ffffffffc0204452:	0d840793          	addi	a5,s0,216
ffffffffc0204456:	6490                	ld	a2,8(s1)
    prev->next = next->prev = elm;
ffffffffc0204458:	e31c                	sd	a5,0(a4)
ffffffffc020445a:	e51c                	sd	a5,8(a0)
    elm->next = next;
ffffffffc020445c:	f078                	sd	a4,224(s0)
    list_add(&proc_list, &(proc->list_link));
ffffffffc020445e:	0c840793          	addi	a5,s0,200
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204462:	7018                	ld	a4,32(s0)
    elm->prev = prev;
ffffffffc0204464:	ec68                	sd	a0,216(s0)
    prev->next = next->prev = elm;
ffffffffc0204466:	e21c                	sd	a5,0(a2)
    proc->yptr = NULL;
ffffffffc0204468:	0e043c23          	sd	zero,248(s0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020446c:	7b74                	ld	a3,240(a4)
ffffffffc020446e:	e49c                	sd	a5,8(s1)
    elm->next = next;
ffffffffc0204470:	e870                	sd	a2,208(s0)
    elm->prev = prev;
ffffffffc0204472:	e464                	sd	s1,200(s0)
ffffffffc0204474:	10d43023          	sd	a3,256(s0)
ffffffffc0204478:	c299                	beqz	a3,ffffffffc020447e <do_fork+0x20e>
        proc->optr->yptr = proc;
ffffffffc020447a:	fee0                	sd	s0,248(a3)
    proc->parent->cptr = proc;
ffffffffc020447c:	7018                	ld	a4,32(s0)
    nr_process++;
ffffffffc020447e:	000a1797          	auipc	a5,0xa1
ffffffffc0204482:	b4a7a783          	lw	a5,-1206(a5) # ffffffffc02a4fc8 <nr_process>
    proc->parent->cptr = proc;
ffffffffc0204486:	fb60                	sd	s0,240(a4)
    nr_process++;
ffffffffc0204488:	2785                	addiw	a5,a5,1
ffffffffc020448a:	000a1717          	auipc	a4,0xa1
ffffffffc020448e:	b2f72f23          	sw	a5,-1218(a4) # ffffffffc02a4fc8 <nr_process>
    if (flag)
ffffffffc0204492:	14091863          	bnez	s2,ffffffffc02045e2 <do_fork+0x372>
    wakeup_proc(proc);
ffffffffc0204496:	8522                	mv	a0,s0
ffffffffc0204498:	721000ef          	jal	ffffffffc02053b8 <wakeup_proc>
    ret = proc->pid;
ffffffffc020449c:	4048                	lw	a0,4(s0)
ffffffffc020449e:	79e2                	ld	s3,56(sp)
ffffffffc02044a0:	7a42                	ld	s4,48(sp)
ffffffffc02044a2:	7aa2                	ld	s5,40(sp)
ffffffffc02044a4:	7b02                	ld	s6,32(sp)
ffffffffc02044a6:	6be2                	ld	s7,24(sp)
ffffffffc02044a8:	6c42                	ld	s8,16(sp)
ffffffffc02044aa:	6ca2                	ld	s9,8(sp)
}
ffffffffc02044ac:	60e6                	ld	ra,88(sp)
ffffffffc02044ae:	6446                	ld	s0,80(sp)
ffffffffc02044b0:	64a6                	ld	s1,72(sp)
ffffffffc02044b2:	6906                	ld	s2,64(sp)
ffffffffc02044b4:	6d02                	ld	s10,0(sp)
ffffffffc02044b6:	6125                	addi	sp,sp,96
ffffffffc02044b8:	8082                	ret
    if ((mm = mm_create()) == NULL)
ffffffffc02044ba:	ad2ff0ef          	jal	ffffffffc020378c <mm_create>
ffffffffc02044be:	8d2a                	mv	s10,a0
ffffffffc02044c0:	c949                	beqz	a0,ffffffffc0204552 <do_fork+0x2e2>
    if ((page = alloc_page()) == NULL)
ffffffffc02044c2:	4505                	li	a0,1
ffffffffc02044c4:	a0bfd0ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc02044c8:	c151                	beqz	a0,ffffffffc020454c <do_fork+0x2dc>
    return page - pages + nbase;
ffffffffc02044ca:	0009b703          	ld	a4,0(s3)
    return KADDR(page2pa(page));
ffffffffc02044ce:	000ab783          	ld	a5,0(s5)
    return page - pages + nbase;
ffffffffc02044d2:	40e506b3          	sub	a3,a0,a4
ffffffffc02044d6:	8699                	srai	a3,a3,0x6
ffffffffc02044d8:	96e6                	add	a3,a3,s9
    return KADDR(page2pa(page));
ffffffffc02044da:	0186fc33          	and	s8,a3,s8
    return page2ppn(page) << PGSHIFT;
ffffffffc02044de:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02044e0:	1afc7f63          	bgeu	s8,a5,ffffffffc020469e <do_fork+0x42e>
ffffffffc02044e4:	000b3783          	ld	a5,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc02044e8:	000a1597          	auipc	a1,0xa1
ffffffffc02044ec:	ac05b583          	ld	a1,-1344(a1) # ffffffffc02a4fa8 <boot_pgdir_va>
ffffffffc02044f0:	6605                	lui	a2,0x1
ffffffffc02044f2:	00f68c33          	add	s8,a3,a5
ffffffffc02044f6:	8562                	mv	a0,s8
ffffffffc02044f8:	564010ef          	jal	ffffffffc0205a5c <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc02044fc:	038b8c93          	addi	s9,s7,56
    mm->pgdir = pgdir;
ffffffffc0204500:	018d3c23          	sd	s8,24(s10) # fffffffffff80018 <end+0x3fcdb030>
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204504:	4c05                	li	s8,1
ffffffffc0204506:	418cb7af          	amoor.d	a5,s8,(s9)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc020450a:	03f79713          	slli	a4,a5,0x3f
ffffffffc020450e:	03f75793          	srli	a5,a4,0x3f
ffffffffc0204512:	cb91                	beqz	a5,ffffffffc0204526 <do_fork+0x2b6>
    {
        schedule();
ffffffffc0204514:	739000ef          	jal	ffffffffc020544c <schedule>
ffffffffc0204518:	418cb7af          	amoor.d	a5,s8,(s9)
    while (!try_lock(lock))
ffffffffc020451c:	03f79713          	slli	a4,a5,0x3f
ffffffffc0204520:	03f75793          	srli	a5,a4,0x3f
ffffffffc0204524:	fbe5                	bnez	a5,ffffffffc0204514 <do_fork+0x2a4>
        ret = dup_mmap(mm, oldmm);
ffffffffc0204526:	85de                	mv	a1,s7
ffffffffc0204528:	856a                	mv	a0,s10
ffffffffc020452a:	cbeff0ef          	jal	ffffffffc02039e8 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020452e:	57f9                	li	a5,-2
ffffffffc0204530:	60fcb7af          	amoand.d	a5,a5,(s9)
ffffffffc0204534:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc0204536:	12078263          	beqz	a5,ffffffffc020465a <do_fork+0x3ea>
    if ((mm = mm_create()) == NULL)
ffffffffc020453a:	8bea                	mv	s7,s10
    if (ret != 0)
ffffffffc020453c:	de0506e3          	beqz	a0,ffffffffc0204328 <do_fork+0xb8>
    exit_mmap(mm);
ffffffffc0204540:	856a                	mv	a0,s10
ffffffffc0204542:	d3eff0ef          	jal	ffffffffc0203a80 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204546:	856a                	mv	a0,s10
ffffffffc0204548:	c51ff0ef          	jal	ffffffffc0204198 <put_pgdir>
    mm_destroy(mm);
ffffffffc020454c:	856a                	mv	a0,s10
ffffffffc020454e:	b7cff0ef          	jal	ffffffffc02038ca <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204552:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc0204554:	c02007b7          	lui	a5,0xc0200
ffffffffc0204558:	0ef6e563          	bltu	a3,a5,ffffffffc0204642 <do_fork+0x3d2>
ffffffffc020455c:	000b3783          	ld	a5,0(s6)
    if (PPN(pa) >= npage)
ffffffffc0204560:	000ab703          	ld	a4,0(s5)
    return pa2page(PADDR(kva));
ffffffffc0204564:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204568:	83b1                	srli	a5,a5,0xc
ffffffffc020456a:	08e7f763          	bgeu	a5,a4,ffffffffc02045f8 <do_fork+0x388>
    return &pages[PPN(pa) - nbase];
ffffffffc020456e:	000a3703          	ld	a4,0(s4)
ffffffffc0204572:	0009b503          	ld	a0,0(s3)
ffffffffc0204576:	4589                	li	a1,2
ffffffffc0204578:	8f99                	sub	a5,a5,a4
ffffffffc020457a:	079a                	slli	a5,a5,0x6
ffffffffc020457c:	953e                	add	a0,a0,a5
ffffffffc020457e:	98bfd0ef          	jal	ffffffffc0201f08 <free_pages>
}
ffffffffc0204582:	79e2                	ld	s3,56(sp)
ffffffffc0204584:	7a42                	ld	s4,48(sp)
ffffffffc0204586:	7aa2                	ld	s5,40(sp)
ffffffffc0204588:	6be2                	ld	s7,24(sp)
ffffffffc020458a:	6c42                	ld	s8,16(sp)
ffffffffc020458c:	6ca2                	ld	s9,8(sp)
    kfree(proc);
ffffffffc020458e:	8522                	mv	a0,s0
ffffffffc0204590:	823fd0ef          	jal	ffffffffc0201db2 <kfree>
ffffffffc0204594:	7b02                	ld	s6,32(sp)
    ret = -E_NO_MEM;
ffffffffc0204596:	5571                	li	a0,-4
    return ret;
ffffffffc0204598:	bf11                	j	ffffffffc02044ac <do_fork+0x23c>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020459a:	8936                	mv	s2,a3
ffffffffc020459c:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02045a0:	00000797          	auipc	a5,0x0
ffffffffc02045a4:	b6c78793          	addi	a5,a5,-1172 # ffffffffc020410c <forkret>
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02045a8:	fc14                	sd	a3,56(s0)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02045aa:	f81c                	sd	a5,48(s0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02045ac:	100027f3          	csrr	a5,sstatus
ffffffffc02045b0:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02045b2:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02045b4:	de0788e3          	beqz	a5,ffffffffc02043a4 <do_fork+0x134>
        intr_disable();
ffffffffc02045b8:	b4cfc0ef          	jal	ffffffffc0200904 <intr_disable>
    if (++last_pid >= MAX_PID)
ffffffffc02045bc:	0009c517          	auipc	a0,0x9c
ffffffffc02045c0:	58052503          	lw	a0,1408(a0) # ffffffffc02a0b3c <last_pid.1>
ffffffffc02045c4:	6789                	lui	a5,0x2
        return 1;
ffffffffc02045c6:	4905                	li	s2,1
ffffffffc02045c8:	2505                	addiw	a0,a0,1
ffffffffc02045ca:	0009c717          	auipc	a4,0x9c
ffffffffc02045ce:	56a72923          	sw	a0,1394(a4) # ffffffffc02a0b3c <last_pid.1>
ffffffffc02045d2:	def545e3          	blt	a0,a5,ffffffffc02043bc <do_fork+0x14c>
        last_pid = 1;
ffffffffc02045d6:	4505                	li	a0,1
ffffffffc02045d8:	0009c797          	auipc	a5,0x9c
ffffffffc02045dc:	56a7a223          	sw	a0,1380(a5) # ffffffffc02a0b3c <last_pid.1>
        goto inside;
ffffffffc02045e0:	bbc5                	j	ffffffffc02043d0 <do_fork+0x160>
        intr_enable();
ffffffffc02045e2:	b1cfc0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02045e6:	bd45                	j	ffffffffc0204496 <do_fork+0x226>
                    if (last_pid >= MAX_PID)
ffffffffc02045e8:	6789                	lui	a5,0x2
ffffffffc02045ea:	00f6c363          	blt	a3,a5,ffffffffc02045f0 <do_fork+0x380>
                        last_pid = 1;
ffffffffc02045ee:	4685                	li	a3,1
                    goto repeat;
ffffffffc02045f0:	4585                	li	a1,1
ffffffffc02045f2:	bbe5                	j	ffffffffc02043ea <do_fork+0x17a>
    int ret = -E_NO_FREE_PROC;
ffffffffc02045f4:	556d                	li	a0,-5
}
ffffffffc02045f6:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc02045f8:	00002617          	auipc	a2,0x2
ffffffffc02045fc:	2b060613          	addi	a2,a2,688 # ffffffffc02068a8 <etext+0xe34>
ffffffffc0204600:	06900593          	li	a1,105
ffffffffc0204604:	00002517          	auipc	a0,0x2
ffffffffc0204608:	1fc50513          	addi	a0,a0,508 # ffffffffc0206800 <etext+0xd8c>
ffffffffc020460c:	e3bfb0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc0204610:	00002617          	auipc	a2,0x2
ffffffffc0204614:	1c860613          	addi	a2,a2,456 # ffffffffc02067d8 <etext+0xd64>
ffffffffc0204618:	07100593          	li	a1,113
ffffffffc020461c:	00002517          	auipc	a0,0x2
ffffffffc0204620:	1e450513          	addi	a0,a0,484 # ffffffffc0206800 <etext+0xd8c>
ffffffffc0204624:	e23fb0ef          	jal	ffffffffc0200446 <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204628:	86be                	mv	a3,a5
ffffffffc020462a:	00002617          	auipc	a2,0x2
ffffffffc020462e:	25660613          	addi	a2,a2,598 # ffffffffc0206880 <etext+0xe0c>
ffffffffc0204632:	18400593          	li	a1,388
ffffffffc0204636:	00003517          	auipc	a0,0x3
ffffffffc020463a:	c4a50513          	addi	a0,a0,-950 # ffffffffc0207280 <etext+0x180c>
ffffffffc020463e:	e09fb0ef          	jal	ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204642:	00002617          	auipc	a2,0x2
ffffffffc0204646:	23e60613          	addi	a2,a2,574 # ffffffffc0206880 <etext+0xe0c>
ffffffffc020464a:	07700593          	li	a1,119
ffffffffc020464e:	00002517          	auipc	a0,0x2
ffffffffc0204652:	1b250513          	addi	a0,a0,434 # ffffffffc0206800 <etext+0xd8c>
ffffffffc0204656:	df1fb0ef          	jal	ffffffffc0200446 <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc020465a:	00003617          	auipc	a2,0x3
ffffffffc020465e:	c5e60613          	addi	a2,a2,-930 # ffffffffc02072b8 <etext+0x1844>
ffffffffc0204662:	03f00593          	li	a1,63
ffffffffc0204666:	00003517          	auipc	a0,0x3
ffffffffc020466a:	c6250513          	addi	a0,a0,-926 # ffffffffc02072c8 <etext+0x1854>
ffffffffc020466e:	dd9fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(current->wait_state == 0);
ffffffffc0204672:	00003697          	auipc	a3,0x3
ffffffffc0204676:	c2668693          	addi	a3,a3,-986 # ffffffffc0207298 <etext+0x1824>
ffffffffc020467a:	00002617          	auipc	a2,0x2
ffffffffc020467e:	dae60613          	addi	a2,a2,-594 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0204682:	1c400593          	li	a1,452
ffffffffc0204686:	00003517          	auipc	a0,0x3
ffffffffc020468a:	bfa50513          	addi	a0,a0,-1030 # ffffffffc0207280 <etext+0x180c>
ffffffffc020468e:	fc4e                	sd	s3,56(sp)
ffffffffc0204690:	f852                	sd	s4,48(sp)
ffffffffc0204692:	f456                	sd	s5,40(sp)
ffffffffc0204694:	ec5e                	sd	s7,24(sp)
ffffffffc0204696:	e862                	sd	s8,16(sp)
ffffffffc0204698:	e466                	sd	s9,8(sp)
ffffffffc020469a:	dadfb0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc020469e:	00002617          	auipc	a2,0x2
ffffffffc02046a2:	13a60613          	addi	a2,a2,314 # ffffffffc02067d8 <etext+0xd64>
ffffffffc02046a6:	07100593          	li	a1,113
ffffffffc02046aa:	00002517          	auipc	a0,0x2
ffffffffc02046ae:	15650513          	addi	a0,a0,342 # ffffffffc0206800 <etext+0xd8c>
ffffffffc02046b2:	d95fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02046b6 <kernel_thread>:
{
ffffffffc02046b6:	7129                	addi	sp,sp,-320
ffffffffc02046b8:	fa22                	sd	s0,304(sp)
ffffffffc02046ba:	f626                	sd	s1,296(sp)
ffffffffc02046bc:	f24a                	sd	s2,288(sp)
ffffffffc02046be:	842a                	mv	s0,a0
ffffffffc02046c0:	84ae                	mv	s1,a1
ffffffffc02046c2:	8932                	mv	s2,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02046c4:	850a                	mv	a0,sp
ffffffffc02046c6:	12000613          	li	a2,288
ffffffffc02046ca:	4581                	li	a1,0
{
ffffffffc02046cc:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02046ce:	37c010ef          	jal	ffffffffc0205a4a <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02046d2:	e0a2                	sd	s0,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02046d4:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02046d6:	100027f3          	csrr	a5,sstatus
ffffffffc02046da:	edd7f793          	andi	a5,a5,-291
ffffffffc02046de:	1207e793          	ori	a5,a5,288
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02046e2:	860a                	mv	a2,sp
ffffffffc02046e4:	10096513          	ori	a0,s2,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02046e8:	00000717          	auipc	a4,0x0
ffffffffc02046ec:	9aa70713          	addi	a4,a4,-1622 # ffffffffc0204092 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02046f0:	4581                	li	a1,0
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02046f2:	e23e                	sd	a5,256(sp)
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02046f4:	e63a                	sd	a4,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02046f6:	b7bff0ef          	jal	ffffffffc0204270 <do_fork>
}
ffffffffc02046fa:	70f2                	ld	ra,312(sp)
ffffffffc02046fc:	7452                	ld	s0,304(sp)
ffffffffc02046fe:	74b2                	ld	s1,296(sp)
ffffffffc0204700:	7912                	ld	s2,288(sp)
ffffffffc0204702:	6131                	addi	sp,sp,320
ffffffffc0204704:	8082                	ret

ffffffffc0204706 <do_exit>:
{
ffffffffc0204706:	7179                	addi	sp,sp,-48
ffffffffc0204708:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc020470a:	000a1417          	auipc	s0,0xa1
ffffffffc020470e:	8c640413          	addi	s0,s0,-1850 # ffffffffc02a4fd0 <current>
ffffffffc0204712:	601c                	ld	a5,0(s0)
ffffffffc0204714:	000a1717          	auipc	a4,0xa1
ffffffffc0204718:	8cc73703          	ld	a4,-1844(a4) # ffffffffc02a4fe0 <idleproc>
{
ffffffffc020471c:	f406                	sd	ra,40(sp)
ffffffffc020471e:	ec26                	sd	s1,24(sp)
    if (current == idleproc)
ffffffffc0204720:	0ce78b63          	beq	a5,a4,ffffffffc02047f6 <do_exit+0xf0>
    if (current == initproc)
ffffffffc0204724:	000a1497          	auipc	s1,0xa1
ffffffffc0204728:	8b448493          	addi	s1,s1,-1868 # ffffffffc02a4fd8 <initproc>
ffffffffc020472c:	6098                	ld	a4,0(s1)
ffffffffc020472e:	e84a                	sd	s2,16(sp)
ffffffffc0204730:	0ee78a63          	beq	a5,a4,ffffffffc0204824 <do_exit+0x11e>
ffffffffc0204734:	892a                	mv	s2,a0
    struct mm_struct *mm = current->mm;
ffffffffc0204736:	7788                	ld	a0,40(a5)
    if (mm != NULL)
ffffffffc0204738:	c115                	beqz	a0,ffffffffc020475c <do_exit+0x56>
ffffffffc020473a:	000a1797          	auipc	a5,0xa1
ffffffffc020473e:	8667b783          	ld	a5,-1946(a5) # ffffffffc02a4fa0 <boot_pgdir_pa>
ffffffffc0204742:	577d                	li	a4,-1
ffffffffc0204744:	177e                	slli	a4,a4,0x3f
ffffffffc0204746:	83b1                	srli	a5,a5,0xc
ffffffffc0204748:	8fd9                	or	a5,a5,a4
ffffffffc020474a:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc020474e:	591c                	lw	a5,48(a0)
ffffffffc0204750:	37fd                	addiw	a5,a5,-1
ffffffffc0204752:	d91c                	sw	a5,48(a0)
        if (mm_count_dec(mm) == 0)
ffffffffc0204754:	cfd5                	beqz	a5,ffffffffc0204810 <do_exit+0x10a>
        current->mm = NULL;
ffffffffc0204756:	601c                	ld	a5,0(s0)
ffffffffc0204758:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc020475c:	470d                	li	a4,3
    current->exit_code = error_code;
ffffffffc020475e:	0f27a423          	sw	s2,232(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0204762:	c398                	sw	a4,0(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204764:	100027f3          	csrr	a5,sstatus
ffffffffc0204768:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020476a:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020476c:	ebe1                	bnez	a5,ffffffffc020483c <do_exit+0x136>
        proc = current->parent;
ffffffffc020476e:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204770:	800007b7          	lui	a5,0x80000
ffffffffc0204774:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e41>
        proc = current->parent;
ffffffffc0204776:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204778:	0ec52703          	lw	a4,236(a0)
ffffffffc020477c:	0cf70463          	beq	a4,a5,ffffffffc0204844 <do_exit+0x13e>
        while (current->cptr != NULL)
ffffffffc0204780:	6018                	ld	a4,0(s0)
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204782:	800005b7          	lui	a1,0x80000
ffffffffc0204786:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e41>
        while (current->cptr != NULL)
ffffffffc0204788:	7b7c                	ld	a5,240(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc020478a:	460d                	li	a2,3
        while (current->cptr != NULL)
ffffffffc020478c:	e789                	bnez	a5,ffffffffc0204796 <do_exit+0x90>
ffffffffc020478e:	a83d                	j	ffffffffc02047cc <do_exit+0xc6>
ffffffffc0204790:	6018                	ld	a4,0(s0)
ffffffffc0204792:	7b7c                	ld	a5,240(a4)
ffffffffc0204794:	cf85                	beqz	a5,ffffffffc02047cc <do_exit+0xc6>
            current->cptr = proc->optr;
ffffffffc0204796:	1007b683          	ld	a3,256(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc020479a:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc020479c:	fb74                	sd	a3,240(a4)
            proc->yptr = NULL;
ffffffffc020479e:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02047a2:	7978                	ld	a4,240(a0)
ffffffffc02047a4:	10e7b023          	sd	a4,256(a5)
ffffffffc02047a8:	c311                	beqz	a4,ffffffffc02047ac <do_exit+0xa6>
                initproc->cptr->yptr = proc;
ffffffffc02047aa:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02047ac:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02047ae:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02047b0:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02047b2:	fcc71fe3          	bne	a4,a2,ffffffffc0204790 <do_exit+0x8a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02047b6:	0ec52783          	lw	a5,236(a0)
ffffffffc02047ba:	fcb79be3          	bne	a5,a1,ffffffffc0204790 <do_exit+0x8a>
                    wakeup_proc(initproc);
ffffffffc02047be:	3fb000ef          	jal	ffffffffc02053b8 <wakeup_proc>
ffffffffc02047c2:	800005b7          	lui	a1,0x80000
ffffffffc02047c6:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e41>
ffffffffc02047c8:	460d                	li	a2,3
ffffffffc02047ca:	b7d9                	j	ffffffffc0204790 <do_exit+0x8a>
    if (flag)
ffffffffc02047cc:	02091263          	bnez	s2,ffffffffc02047f0 <do_exit+0xea>
    schedule();
ffffffffc02047d0:	47d000ef          	jal	ffffffffc020544c <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc02047d4:	601c                	ld	a5,0(s0)
ffffffffc02047d6:	00003617          	auipc	a2,0x3
ffffffffc02047da:	b2a60613          	addi	a2,a2,-1238 # ffffffffc0207300 <etext+0x188c>
ffffffffc02047de:	22e00593          	li	a1,558
ffffffffc02047e2:	43d4                	lw	a3,4(a5)
ffffffffc02047e4:	00003517          	auipc	a0,0x3
ffffffffc02047e8:	a9c50513          	addi	a0,a0,-1380 # ffffffffc0207280 <etext+0x180c>
ffffffffc02047ec:	c5bfb0ef          	jal	ffffffffc0200446 <__panic>
        intr_enable();
ffffffffc02047f0:	90efc0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02047f4:	bff1                	j	ffffffffc02047d0 <do_exit+0xca>
        panic("idleproc exit.\n");
ffffffffc02047f6:	00003617          	auipc	a2,0x3
ffffffffc02047fa:	aea60613          	addi	a2,a2,-1302 # ffffffffc02072e0 <etext+0x186c>
ffffffffc02047fe:	1fa00593          	li	a1,506
ffffffffc0204802:	00003517          	auipc	a0,0x3
ffffffffc0204806:	a7e50513          	addi	a0,a0,-1410 # ffffffffc0207280 <etext+0x180c>
ffffffffc020480a:	e84a                	sd	s2,16(sp)
ffffffffc020480c:	c3bfb0ef          	jal	ffffffffc0200446 <__panic>
            exit_mmap(mm);
ffffffffc0204810:	e42a                	sd	a0,8(sp)
ffffffffc0204812:	a6eff0ef          	jal	ffffffffc0203a80 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204816:	6522                	ld	a0,8(sp)
ffffffffc0204818:	981ff0ef          	jal	ffffffffc0204198 <put_pgdir>
            mm_destroy(mm);
ffffffffc020481c:	6522                	ld	a0,8(sp)
ffffffffc020481e:	8acff0ef          	jal	ffffffffc02038ca <mm_destroy>
ffffffffc0204822:	bf15                	j	ffffffffc0204756 <do_exit+0x50>
        panic("initproc exit.\n");
ffffffffc0204824:	00003617          	auipc	a2,0x3
ffffffffc0204828:	acc60613          	addi	a2,a2,-1332 # ffffffffc02072f0 <etext+0x187c>
ffffffffc020482c:	1fe00593          	li	a1,510
ffffffffc0204830:	00003517          	auipc	a0,0x3
ffffffffc0204834:	a5050513          	addi	a0,a0,-1456 # ffffffffc0207280 <etext+0x180c>
ffffffffc0204838:	c0ffb0ef          	jal	ffffffffc0200446 <__panic>
        intr_disable();
ffffffffc020483c:	8c8fc0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0204840:	4905                	li	s2,1
ffffffffc0204842:	b735                	j	ffffffffc020476e <do_exit+0x68>
            wakeup_proc(proc);
ffffffffc0204844:	375000ef          	jal	ffffffffc02053b8 <wakeup_proc>
ffffffffc0204848:	bf25                	j	ffffffffc0204780 <do_exit+0x7a>

ffffffffc020484a <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc020484a:	7179                	addi	sp,sp,-48
ffffffffc020484c:	ec26                	sd	s1,24(sp)
ffffffffc020484e:	e84a                	sd	s2,16(sp)
ffffffffc0204850:	e44e                	sd	s3,8(sp)
ffffffffc0204852:	f406                	sd	ra,40(sp)
ffffffffc0204854:	f022                	sd	s0,32(sp)
ffffffffc0204856:	84aa                	mv	s1,a0
ffffffffc0204858:	892e                	mv	s2,a1
ffffffffc020485a:	000a0997          	auipc	s3,0xa0
ffffffffc020485e:	77698993          	addi	s3,s3,1910 # ffffffffc02a4fd0 <current>
    if (pid != 0)
ffffffffc0204862:	cd19                	beqz	a0,ffffffffc0204880 <do_wait.part.0+0x36>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204864:	6789                	lui	a5,0x2
ffffffffc0204866:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6bca>
ffffffffc0204868:	fff5071b          	addiw	a4,a0,-1
ffffffffc020486c:	12e7f563          	bgeu	a5,a4,ffffffffc0204996 <do_wait.part.0+0x14c>
}
ffffffffc0204870:	70a2                	ld	ra,40(sp)
ffffffffc0204872:	7402                	ld	s0,32(sp)
ffffffffc0204874:	64e2                	ld	s1,24(sp)
ffffffffc0204876:	6942                	ld	s2,16(sp)
ffffffffc0204878:	69a2                	ld	s3,8(sp)
    return -E_BAD_PROC;
ffffffffc020487a:	5579                	li	a0,-2
}
ffffffffc020487c:	6145                	addi	sp,sp,48
ffffffffc020487e:	8082                	ret
        proc = current->cptr;
ffffffffc0204880:	0009b703          	ld	a4,0(s3)
ffffffffc0204884:	7b60                	ld	s0,240(a4)
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204886:	d46d                	beqz	s0,ffffffffc0204870 <do_wait.part.0+0x26>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204888:	468d                	li	a3,3
ffffffffc020488a:	a021                	j	ffffffffc0204892 <do_wait.part.0+0x48>
        for (; proc != NULL; proc = proc->optr)
ffffffffc020488c:	10043403          	ld	s0,256(s0)
ffffffffc0204890:	c075                	beqz	s0,ffffffffc0204974 <do_wait.part.0+0x12a>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204892:	401c                	lw	a5,0(s0)
ffffffffc0204894:	fed79ce3          	bne	a5,a3,ffffffffc020488c <do_wait.part.0+0x42>
    if (proc == idleproc || proc == initproc)
ffffffffc0204898:	000a0797          	auipc	a5,0xa0
ffffffffc020489c:	7487b783          	ld	a5,1864(a5) # ffffffffc02a4fe0 <idleproc>
ffffffffc02048a0:	14878263          	beq	a5,s0,ffffffffc02049e4 <do_wait.part.0+0x19a>
ffffffffc02048a4:	000a0797          	auipc	a5,0xa0
ffffffffc02048a8:	7347b783          	ld	a5,1844(a5) # ffffffffc02a4fd8 <initproc>
ffffffffc02048ac:	12f40c63          	beq	s0,a5,ffffffffc02049e4 <do_wait.part.0+0x19a>
    if (code_store != NULL)
ffffffffc02048b0:	00090663          	beqz	s2,ffffffffc02048bc <do_wait.part.0+0x72>
        *code_store = proc->exit_code;
ffffffffc02048b4:	0e842783          	lw	a5,232(s0)
ffffffffc02048b8:	00f92023          	sw	a5,0(s2)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02048bc:	100027f3          	csrr	a5,sstatus
ffffffffc02048c0:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02048c2:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02048c4:	10079963          	bnez	a5,ffffffffc02049d6 <do_wait.part.0+0x18c>
    __list_del(listelm->prev, listelm->next);
ffffffffc02048c8:	6c74                	ld	a3,216(s0)
ffffffffc02048ca:	7078                	ld	a4,224(s0)
    if (proc->optr != NULL)
ffffffffc02048cc:	10043783          	ld	a5,256(s0)
    prev->next = next;
ffffffffc02048d0:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc02048d2:	e314                	sd	a3,0(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc02048d4:	6474                	ld	a3,200(s0)
ffffffffc02048d6:	6878                	ld	a4,208(s0)
    prev->next = next;
ffffffffc02048d8:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc02048da:	e314                	sd	a3,0(a4)
ffffffffc02048dc:	c789                	beqz	a5,ffffffffc02048e6 <do_wait.part.0+0x9c>
        proc->optr->yptr = proc->yptr;
ffffffffc02048de:	7c78                	ld	a4,248(s0)
ffffffffc02048e0:	fff8                	sd	a4,248(a5)
        proc->yptr->optr = proc->optr;
ffffffffc02048e2:	10043783          	ld	a5,256(s0)
    if (proc->yptr != NULL)
ffffffffc02048e6:	7c78                	ld	a4,248(s0)
ffffffffc02048e8:	c36d                	beqz	a4,ffffffffc02049ca <do_wait.part.0+0x180>
        proc->yptr->optr = proc->optr;
ffffffffc02048ea:	10f73023          	sd	a5,256(a4)
    nr_process--;
ffffffffc02048ee:	000a0797          	auipc	a5,0xa0
ffffffffc02048f2:	6da7a783          	lw	a5,1754(a5) # ffffffffc02a4fc8 <nr_process>
ffffffffc02048f6:	37fd                	addiw	a5,a5,-1
ffffffffc02048f8:	000a0717          	auipc	a4,0xa0
ffffffffc02048fc:	6cf72823          	sw	a5,1744(a4) # ffffffffc02a4fc8 <nr_process>
    if (flag)
ffffffffc0204900:	e271                	bnez	a2,ffffffffc02049c4 <do_wait.part.0+0x17a>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204902:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc0204904:	c02007b7          	lui	a5,0xc0200
ffffffffc0204908:	10f6e663          	bltu	a3,a5,ffffffffc0204a14 <do_wait.part.0+0x1ca>
ffffffffc020490c:	000a0717          	auipc	a4,0xa0
ffffffffc0204910:	6a473703          	ld	a4,1700(a4) # ffffffffc02a4fb0 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0204914:	000a0797          	auipc	a5,0xa0
ffffffffc0204918:	6a47b783          	ld	a5,1700(a5) # ffffffffc02a4fb8 <npage>
    return pa2page(PADDR(kva));
ffffffffc020491c:	8e99                	sub	a3,a3,a4
    if (PPN(pa) >= npage)
ffffffffc020491e:	82b1                	srli	a3,a3,0xc
ffffffffc0204920:	0cf6fe63          	bgeu	a3,a5,ffffffffc02049fc <do_wait.part.0+0x1b2>
    return &pages[PPN(pa) - nbase];
ffffffffc0204924:	00003797          	auipc	a5,0x3
ffffffffc0204928:	3047b783          	ld	a5,772(a5) # ffffffffc0207c28 <nbase>
ffffffffc020492c:	000a0517          	auipc	a0,0xa0
ffffffffc0204930:	69453503          	ld	a0,1684(a0) # ffffffffc02a4fc0 <pages>
ffffffffc0204934:	4589                	li	a1,2
ffffffffc0204936:	8e9d                	sub	a3,a3,a5
ffffffffc0204938:	069a                	slli	a3,a3,0x6
ffffffffc020493a:	9536                	add	a0,a0,a3
ffffffffc020493c:	dccfd0ef          	jal	ffffffffc0201f08 <free_pages>
    kfree(proc);
ffffffffc0204940:	8522                	mv	a0,s0
ffffffffc0204942:	c70fd0ef          	jal	ffffffffc0201db2 <kfree>
}
ffffffffc0204946:	70a2                	ld	ra,40(sp)
ffffffffc0204948:	7402                	ld	s0,32(sp)
ffffffffc020494a:	64e2                	ld	s1,24(sp)
ffffffffc020494c:	6942                	ld	s2,16(sp)
ffffffffc020494e:	69a2                	ld	s3,8(sp)
    return 0;
ffffffffc0204950:	4501                	li	a0,0
}
ffffffffc0204952:	6145                	addi	sp,sp,48
ffffffffc0204954:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc0204956:	000a0997          	auipc	s3,0xa0
ffffffffc020495a:	67a98993          	addi	s3,s3,1658 # ffffffffc02a4fd0 <current>
ffffffffc020495e:	0009b703          	ld	a4,0(s3)
ffffffffc0204962:	f487b683          	ld	a3,-184(a5)
ffffffffc0204966:	f0e695e3          	bne	a3,a4,ffffffffc0204870 <do_wait.part.0+0x26>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020496a:	f287a603          	lw	a2,-216(a5)
ffffffffc020496e:	468d                	li	a3,3
ffffffffc0204970:	06d60063          	beq	a2,a3,ffffffffc02049d0 <do_wait.part.0+0x186>
        current->wait_state = WT_CHILD;
ffffffffc0204974:	800007b7          	lui	a5,0x80000
ffffffffc0204978:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e41>
        current->state = PROC_SLEEPING;
ffffffffc020497a:	4685                	li	a3,1
        current->wait_state = WT_CHILD;
ffffffffc020497c:	0ef72623          	sw	a5,236(a4)
        current->state = PROC_SLEEPING;
ffffffffc0204980:	c314                	sw	a3,0(a4)
        schedule();
ffffffffc0204982:	2cb000ef          	jal	ffffffffc020544c <schedule>
        if (current->flags & PF_EXITING)
ffffffffc0204986:	0009b783          	ld	a5,0(s3)
ffffffffc020498a:	0b07a783          	lw	a5,176(a5)
ffffffffc020498e:	8b85                	andi	a5,a5,1
ffffffffc0204990:	e7b9                	bnez	a5,ffffffffc02049de <do_wait.part.0+0x194>
    if (pid != 0)
ffffffffc0204992:	ee0487e3          	beqz	s1,ffffffffc0204880 <do_wait.part.0+0x36>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204996:	45a9                	li	a1,10
ffffffffc0204998:	8526                	mv	a0,s1
ffffffffc020499a:	41b000ef          	jal	ffffffffc02055b4 <hash32>
ffffffffc020499e:	02051793          	slli	a5,a0,0x20
ffffffffc02049a2:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02049a6:	0009c797          	auipc	a5,0x9c
ffffffffc02049aa:	5b278793          	addi	a5,a5,1458 # ffffffffc02a0f58 <hash_list>
ffffffffc02049ae:	953e                	add	a0,a0,a5
ffffffffc02049b0:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc02049b2:	a029                	j	ffffffffc02049bc <do_wait.part.0+0x172>
            if (proc->pid == pid)
ffffffffc02049b4:	f2c7a703          	lw	a4,-212(a5)
ffffffffc02049b8:	f8970fe3          	beq	a4,s1,ffffffffc0204956 <do_wait.part.0+0x10c>
    return listelm->next;
ffffffffc02049bc:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02049be:	fef51be3          	bne	a0,a5,ffffffffc02049b4 <do_wait.part.0+0x16a>
ffffffffc02049c2:	b57d                	j	ffffffffc0204870 <do_wait.part.0+0x26>
        intr_enable();
ffffffffc02049c4:	f3bfb0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02049c8:	bf2d                	j	ffffffffc0204902 <do_wait.part.0+0xb8>
        proc->parent->cptr = proc->optr;
ffffffffc02049ca:	7018                	ld	a4,32(s0)
ffffffffc02049cc:	fb7c                	sd	a5,240(a4)
ffffffffc02049ce:	b705                	j	ffffffffc02048ee <do_wait.part.0+0xa4>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02049d0:	f2878413          	addi	s0,a5,-216
ffffffffc02049d4:	b5d1                	j	ffffffffc0204898 <do_wait.part.0+0x4e>
        intr_disable();
ffffffffc02049d6:	f2ffb0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc02049da:	4605                	li	a2,1
ffffffffc02049dc:	b5f5                	j	ffffffffc02048c8 <do_wait.part.0+0x7e>
            do_exit(-E_KILLED);
ffffffffc02049de:	555d                	li	a0,-9
ffffffffc02049e0:	d27ff0ef          	jal	ffffffffc0204706 <do_exit>
        panic("wait idleproc or initproc.\n");
ffffffffc02049e4:	00003617          	auipc	a2,0x3
ffffffffc02049e8:	93c60613          	addi	a2,a2,-1732 # ffffffffc0207320 <etext+0x18ac>
ffffffffc02049ec:	34a00593          	li	a1,842
ffffffffc02049f0:	00003517          	auipc	a0,0x3
ffffffffc02049f4:	89050513          	addi	a0,a0,-1904 # ffffffffc0207280 <etext+0x180c>
ffffffffc02049f8:	a4ffb0ef          	jal	ffffffffc0200446 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02049fc:	00002617          	auipc	a2,0x2
ffffffffc0204a00:	eac60613          	addi	a2,a2,-340 # ffffffffc02068a8 <etext+0xe34>
ffffffffc0204a04:	06900593          	li	a1,105
ffffffffc0204a08:	00002517          	auipc	a0,0x2
ffffffffc0204a0c:	df850513          	addi	a0,a0,-520 # ffffffffc0206800 <etext+0xd8c>
ffffffffc0204a10:	a37fb0ef          	jal	ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204a14:	00002617          	auipc	a2,0x2
ffffffffc0204a18:	e6c60613          	addi	a2,a2,-404 # ffffffffc0206880 <etext+0xe0c>
ffffffffc0204a1c:	07700593          	li	a1,119
ffffffffc0204a20:	00002517          	auipc	a0,0x2
ffffffffc0204a24:	de050513          	addi	a0,a0,-544 # ffffffffc0206800 <etext+0xd8c>
ffffffffc0204a28:	a1ffb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0204a2c <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc0204a2c:	1141                	addi	sp,sp,-16
ffffffffc0204a2e:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0204a30:	d10fd0ef          	jal	ffffffffc0201f40 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204a34:	ad4fd0ef          	jal	ffffffffc0201d08 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0204a38:	4601                	li	a2,0
ffffffffc0204a3a:	4581                	li	a1,0
ffffffffc0204a3c:	fffff517          	auipc	a0,0xfffff
ffffffffc0204a40:	6de50513          	addi	a0,a0,1758 # ffffffffc020411a <user_main>
ffffffffc0204a44:	c73ff0ef          	jal	ffffffffc02046b6 <kernel_thread>
    if (pid <= 0)
ffffffffc0204a48:	00a04563          	bgtz	a0,ffffffffc0204a52 <init_main+0x26>
ffffffffc0204a4c:	a071                	j	ffffffffc0204ad8 <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc0204a4e:	1ff000ef          	jal	ffffffffc020544c <schedule>
    if (code_store != NULL)
ffffffffc0204a52:	4581                	li	a1,0
ffffffffc0204a54:	4501                	li	a0,0
ffffffffc0204a56:	df5ff0ef          	jal	ffffffffc020484a <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc0204a5a:	d975                	beqz	a0,ffffffffc0204a4e <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0204a5c:	00003517          	auipc	a0,0x3
ffffffffc0204a60:	90450513          	addi	a0,a0,-1788 # ffffffffc0207360 <etext+0x18ec>
ffffffffc0204a64:	f30fb0ef          	jal	ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204a68:	000a0797          	auipc	a5,0xa0
ffffffffc0204a6c:	5707b783          	ld	a5,1392(a5) # ffffffffc02a4fd8 <initproc>
ffffffffc0204a70:	7bf8                	ld	a4,240(a5)
ffffffffc0204a72:	e339                	bnez	a4,ffffffffc0204ab8 <init_main+0x8c>
ffffffffc0204a74:	7ff8                	ld	a4,248(a5)
ffffffffc0204a76:	e329                	bnez	a4,ffffffffc0204ab8 <init_main+0x8c>
ffffffffc0204a78:	1007b703          	ld	a4,256(a5)
ffffffffc0204a7c:	ef15                	bnez	a4,ffffffffc0204ab8 <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc0204a7e:	000a0697          	auipc	a3,0xa0
ffffffffc0204a82:	54a6a683          	lw	a3,1354(a3) # ffffffffc02a4fc8 <nr_process>
ffffffffc0204a86:	4709                	li	a4,2
ffffffffc0204a88:	0ae69463          	bne	a3,a4,ffffffffc0204b30 <init_main+0x104>
ffffffffc0204a8c:	000a0697          	auipc	a3,0xa0
ffffffffc0204a90:	4cc68693          	addi	a3,a3,1228 # ffffffffc02a4f58 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204a94:	6698                	ld	a4,8(a3)
ffffffffc0204a96:	0c878793          	addi	a5,a5,200
ffffffffc0204a9a:	06f71b63          	bne	a4,a5,ffffffffc0204b10 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204a9e:	629c                	ld	a5,0(a3)
ffffffffc0204aa0:	04f71863          	bne	a4,a5,ffffffffc0204af0 <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc0204aa4:	00003517          	auipc	a0,0x3
ffffffffc0204aa8:	9a450513          	addi	a0,a0,-1628 # ffffffffc0207448 <etext+0x19d4>
ffffffffc0204aac:	ee8fb0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc0204ab0:	60a2                	ld	ra,8(sp)
ffffffffc0204ab2:	4501                	li	a0,0
ffffffffc0204ab4:	0141                	addi	sp,sp,16
ffffffffc0204ab6:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204ab8:	00003697          	auipc	a3,0x3
ffffffffc0204abc:	8d068693          	addi	a3,a3,-1840 # ffffffffc0207388 <etext+0x1914>
ffffffffc0204ac0:	00002617          	auipc	a2,0x2
ffffffffc0204ac4:	96860613          	addi	a2,a2,-1688 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0204ac8:	3b800593          	li	a1,952
ffffffffc0204acc:	00002517          	auipc	a0,0x2
ffffffffc0204ad0:	7b450513          	addi	a0,a0,1972 # ffffffffc0207280 <etext+0x180c>
ffffffffc0204ad4:	973fb0ef          	jal	ffffffffc0200446 <__panic>
        panic("create user_main failed.\n");
ffffffffc0204ad8:	00003617          	auipc	a2,0x3
ffffffffc0204adc:	86860613          	addi	a2,a2,-1944 # ffffffffc0207340 <etext+0x18cc>
ffffffffc0204ae0:	3af00593          	li	a1,943
ffffffffc0204ae4:	00002517          	auipc	a0,0x2
ffffffffc0204ae8:	79c50513          	addi	a0,a0,1948 # ffffffffc0207280 <etext+0x180c>
ffffffffc0204aec:	95bfb0ef          	jal	ffffffffc0200446 <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204af0:	00003697          	auipc	a3,0x3
ffffffffc0204af4:	92868693          	addi	a3,a3,-1752 # ffffffffc0207418 <etext+0x19a4>
ffffffffc0204af8:	00002617          	auipc	a2,0x2
ffffffffc0204afc:	93060613          	addi	a2,a2,-1744 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0204b00:	3bb00593          	li	a1,955
ffffffffc0204b04:	00002517          	auipc	a0,0x2
ffffffffc0204b08:	77c50513          	addi	a0,a0,1916 # ffffffffc0207280 <etext+0x180c>
ffffffffc0204b0c:	93bfb0ef          	jal	ffffffffc0200446 <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204b10:	00003697          	auipc	a3,0x3
ffffffffc0204b14:	8d868693          	addi	a3,a3,-1832 # ffffffffc02073e8 <etext+0x1974>
ffffffffc0204b18:	00002617          	auipc	a2,0x2
ffffffffc0204b1c:	91060613          	addi	a2,a2,-1776 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0204b20:	3ba00593          	li	a1,954
ffffffffc0204b24:	00002517          	auipc	a0,0x2
ffffffffc0204b28:	75c50513          	addi	a0,a0,1884 # ffffffffc0207280 <etext+0x180c>
ffffffffc0204b2c:	91bfb0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_process == 2);
ffffffffc0204b30:	00003697          	auipc	a3,0x3
ffffffffc0204b34:	8a868693          	addi	a3,a3,-1880 # ffffffffc02073d8 <etext+0x1964>
ffffffffc0204b38:	00002617          	auipc	a2,0x2
ffffffffc0204b3c:	8f060613          	addi	a2,a2,-1808 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0204b40:	3b900593          	li	a1,953
ffffffffc0204b44:	00002517          	auipc	a0,0x2
ffffffffc0204b48:	73c50513          	addi	a0,a0,1852 # ffffffffc0207280 <etext+0x180c>
ffffffffc0204b4c:	8fbfb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0204b50 <do_execve>:
{
ffffffffc0204b50:	7171                	addi	sp,sp,-176
ffffffffc0204b52:	e8ea                	sd	s10,80(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204b54:	000a0d17          	auipc	s10,0xa0
ffffffffc0204b58:	47cd0d13          	addi	s10,s10,1148 # ffffffffc02a4fd0 <current>
ffffffffc0204b5c:	000d3783          	ld	a5,0(s10)
{
ffffffffc0204b60:	ed26                	sd	s1,152(sp)
ffffffffc0204b62:	f122                	sd	s0,160(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204b64:	7784                	ld	s1,40(a5)
{
ffffffffc0204b66:	842e                	mv	s0,a1
ffffffffc0204b68:	e94a                	sd	s2,144(sp)
ffffffffc0204b6a:	ec32                	sd	a2,24(sp)
ffffffffc0204b6c:	892a                	mv	s2,a0
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204b6e:	85aa                	mv	a1,a0
ffffffffc0204b70:	8622                	mv	a2,s0
ffffffffc0204b72:	8526                	mv	a0,s1
ffffffffc0204b74:	4681                	li	a3,0
{
ffffffffc0204b76:	f506                	sd	ra,168(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204b78:	aa0ff0ef          	jal	ffffffffc0203e18 <user_mem_check>
ffffffffc0204b7c:	46050363          	beqz	a0,ffffffffc0204fe2 <do_execve+0x492>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204b80:	4641                	li	a2,16
ffffffffc0204b82:	1808                	addi	a0,sp,48
ffffffffc0204b84:	4581                	li	a1,0
ffffffffc0204b86:	6c5000ef          	jal	ffffffffc0205a4a <memset>
    if (len > PROC_NAME_LEN)
ffffffffc0204b8a:	47bd                	li	a5,15
ffffffffc0204b8c:	8622                	mv	a2,s0
ffffffffc0204b8e:	0e87ec63          	bltu	a5,s0,ffffffffc0204c86 <do_execve+0x136>
    memcpy(local_name, name, len);
ffffffffc0204b92:	85ca                	mv	a1,s2
ffffffffc0204b94:	1808                	addi	a0,sp,48
ffffffffc0204b96:	6c7000ef          	jal	ffffffffc0205a5c <memcpy>
    if (mm != NULL)
ffffffffc0204b9a:	0e048d63          	beqz	s1,ffffffffc0204c94 <do_execve+0x144>
        cputs("mm != NULL");
ffffffffc0204b9e:	00002517          	auipc	a0,0x2
ffffffffc0204ba2:	43250513          	addi	a0,a0,1074 # ffffffffc0206fd0 <etext+0x155c>
ffffffffc0204ba6:	e24fb0ef          	jal	ffffffffc02001ca <cputs>
ffffffffc0204baa:	000a0797          	auipc	a5,0xa0
ffffffffc0204bae:	3f67b783          	ld	a5,1014(a5) # ffffffffc02a4fa0 <boot_pgdir_pa>
ffffffffc0204bb2:	577d                	li	a4,-1
ffffffffc0204bb4:	177e                	slli	a4,a4,0x3f
ffffffffc0204bb6:	83b1                	srli	a5,a5,0xc
ffffffffc0204bb8:	8fd9                	or	a5,a5,a4
ffffffffc0204bba:	18079073          	csrw	satp,a5
ffffffffc0204bbe:	589c                	lw	a5,48(s1)
ffffffffc0204bc0:	37fd                	addiw	a5,a5,-1
ffffffffc0204bc2:	d89c                	sw	a5,48(s1)
        if (mm_count_dec(mm) == 0)
ffffffffc0204bc4:	2e078c63          	beqz	a5,ffffffffc0204ebc <do_execve+0x36c>
        current->mm = NULL;
ffffffffc0204bc8:	000d3783          	ld	a5,0(s10)
ffffffffc0204bcc:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc0204bd0:	bbdfe0ef          	jal	ffffffffc020378c <mm_create>
ffffffffc0204bd4:	84aa                	mv	s1,a0
ffffffffc0204bd6:	20050863          	beqz	a0,ffffffffc0204de6 <do_execve+0x296>
    if ((page = alloc_page()) == NULL)
ffffffffc0204bda:	4505                	li	a0,1
ffffffffc0204bdc:	af2fd0ef          	jal	ffffffffc0201ece <alloc_pages>
ffffffffc0204be0:	40050663          	beqz	a0,ffffffffc0204fec <do_execve+0x49c>
    return page - pages + nbase;
ffffffffc0204be4:	f4de                	sd	s7,104(sp)
ffffffffc0204be6:	000a0b97          	auipc	s7,0xa0
ffffffffc0204bea:	3dab8b93          	addi	s7,s7,986 # ffffffffc02a4fc0 <pages>
ffffffffc0204bee:	000bb783          	ld	a5,0(s7)
ffffffffc0204bf2:	f8da                	sd	s6,112(sp)
ffffffffc0204bf4:	00003b17          	auipc	s6,0x3
ffffffffc0204bf8:	034b3b03          	ld	s6,52(s6) # ffffffffc0207c28 <nbase>
ffffffffc0204bfc:	40f506b3          	sub	a3,a0,a5
ffffffffc0204c00:	f0e2                	sd	s8,96(sp)
    return KADDR(page2pa(page));
ffffffffc0204c02:	000a0c17          	auipc	s8,0xa0
ffffffffc0204c06:	3b6c0c13          	addi	s8,s8,950 # ffffffffc02a4fb8 <npage>
ffffffffc0204c0a:	fcd6                	sd	s5,120(sp)
    return page - pages + nbase;
ffffffffc0204c0c:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204c0e:	5afd                	li	s5,-1
ffffffffc0204c10:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204c14:	96da                	add	a3,a3,s6
    return KADDR(page2pa(page));
ffffffffc0204c16:	00cad713          	srli	a4,s5,0xc
ffffffffc0204c1a:	e83a                	sd	a4,16(sp)
ffffffffc0204c1c:	e152                	sd	s4,128(sp)
ffffffffc0204c1e:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c20:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c22:	3ef77863          	bgeu	a4,a5,ffffffffc0205012 <do_execve+0x4c2>
ffffffffc0204c26:	000a0a17          	auipc	s4,0xa0
ffffffffc0204c2a:	38aa0a13          	addi	s4,s4,906 # ffffffffc02a4fb0 <va_pa_offset>
ffffffffc0204c2e:	000a3783          	ld	a5,0(s4)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204c32:	000a0597          	auipc	a1,0xa0
ffffffffc0204c36:	3765b583          	ld	a1,886(a1) # ffffffffc02a4fa8 <boot_pgdir_va>
ffffffffc0204c3a:	6605                	lui	a2,0x1
ffffffffc0204c3c:	00f68433          	add	s0,a3,a5
ffffffffc0204c40:	8522                	mv	a0,s0
ffffffffc0204c42:	61b000ef          	jal	ffffffffc0205a5c <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204c46:	66e2                	ld	a3,24(sp)
ffffffffc0204c48:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204c4c:	ec80                	sd	s0,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204c4e:	4298                	lw	a4,0(a3)
ffffffffc0204c50:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464ba3bf>
ffffffffc0204c54:	06f70863          	beq	a4,a5,ffffffffc0204cc4 <do_execve+0x174>
        ret = -E_INVAL_ELF;
ffffffffc0204c58:	5461                	li	s0,-8
    put_pgdir(mm);
ffffffffc0204c5a:	8526                	mv	a0,s1
ffffffffc0204c5c:	d3cff0ef          	jal	ffffffffc0204198 <put_pgdir>
ffffffffc0204c60:	6a0a                	ld	s4,128(sp)
ffffffffc0204c62:	7ae6                	ld	s5,120(sp)
ffffffffc0204c64:	7b46                	ld	s6,112(sp)
ffffffffc0204c66:	7ba6                	ld	s7,104(sp)
ffffffffc0204c68:	7c06                	ld	s8,96(sp)
    mm_destroy(mm);
ffffffffc0204c6a:	8526                	mv	a0,s1
ffffffffc0204c6c:	c5ffe0ef          	jal	ffffffffc02038ca <mm_destroy>
    do_exit(ret);
ffffffffc0204c70:	8522                	mv	a0,s0
ffffffffc0204c72:	e54e                	sd	s3,136(sp)
ffffffffc0204c74:	e152                	sd	s4,128(sp)
ffffffffc0204c76:	fcd6                	sd	s5,120(sp)
ffffffffc0204c78:	f8da                	sd	s6,112(sp)
ffffffffc0204c7a:	f4de                	sd	s7,104(sp)
ffffffffc0204c7c:	f0e2                	sd	s8,96(sp)
ffffffffc0204c7e:	ece6                	sd	s9,88(sp)
ffffffffc0204c80:	e4ee                	sd	s11,72(sp)
ffffffffc0204c82:	a85ff0ef          	jal	ffffffffc0204706 <do_exit>
    if (len > PROC_NAME_LEN)
ffffffffc0204c86:	863e                	mv	a2,a5
    memcpy(local_name, name, len);
ffffffffc0204c88:	85ca                	mv	a1,s2
ffffffffc0204c8a:	1808                	addi	a0,sp,48
ffffffffc0204c8c:	5d1000ef          	jal	ffffffffc0205a5c <memcpy>
    if (mm != NULL)
ffffffffc0204c90:	f00497e3          	bnez	s1,ffffffffc0204b9e <do_execve+0x4e>
    if (current->mm != NULL)
ffffffffc0204c94:	000d3783          	ld	a5,0(s10)
ffffffffc0204c98:	779c                	ld	a5,40(a5)
ffffffffc0204c9a:	db9d                	beqz	a5,ffffffffc0204bd0 <do_execve+0x80>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204c9c:	00002617          	auipc	a2,0x2
ffffffffc0204ca0:	7cc60613          	addi	a2,a2,1996 # ffffffffc0207468 <etext+0x19f4>
ffffffffc0204ca4:	23a00593          	li	a1,570
ffffffffc0204ca8:	00002517          	auipc	a0,0x2
ffffffffc0204cac:	5d850513          	addi	a0,a0,1496 # ffffffffc0207280 <etext+0x180c>
ffffffffc0204cb0:	e54e                	sd	s3,136(sp)
ffffffffc0204cb2:	e152                	sd	s4,128(sp)
ffffffffc0204cb4:	fcd6                	sd	s5,120(sp)
ffffffffc0204cb6:	f8da                	sd	s6,112(sp)
ffffffffc0204cb8:	f4de                	sd	s7,104(sp)
ffffffffc0204cba:	f0e2                	sd	s8,96(sp)
ffffffffc0204cbc:	ece6                	sd	s9,88(sp)
ffffffffc0204cbe:	e4ee                	sd	s11,72(sp)
ffffffffc0204cc0:	f86fb0ef          	jal	ffffffffc0200446 <__panic>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204cc4:	0386d703          	lhu	a4,56(a3)
ffffffffc0204cc8:	e54e                	sd	s3,136(sp)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204cca:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204cce:	00371793          	slli	a5,a4,0x3
ffffffffc0204cd2:	8f99                	sub	a5,a5,a4
ffffffffc0204cd4:	078e                	slli	a5,a5,0x3
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204cd6:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204cd8:	97ce                	add	a5,a5,s3
ffffffffc0204cda:	ece6                	sd	s9,88(sp)
ffffffffc0204cdc:	f43e                	sd	a5,40(sp)
    struct Page *page = NULL;
ffffffffc0204cde:	4c81                	li	s9,0
    for (; ph < ph_end; ph++)
ffffffffc0204ce0:	00f9fe63          	bgeu	s3,a5,ffffffffc0204cfc <do_execve+0x1ac>
ffffffffc0204ce4:	e4ee                	sd	s11,72(sp)
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204ce6:	0009a783          	lw	a5,0(s3)
ffffffffc0204cea:	4705                	li	a4,1
ffffffffc0204cec:	0ee78f63          	beq	a5,a4,ffffffffc0204dea <do_execve+0x29a>
    for (; ph < ph_end; ph++)
ffffffffc0204cf0:	77a2                	ld	a5,40(sp)
ffffffffc0204cf2:	03898993          	addi	s3,s3,56
ffffffffc0204cf6:	fef9e8e3          	bltu	s3,a5,ffffffffc0204ce6 <do_execve+0x196>
ffffffffc0204cfa:	6da6                	ld	s11,72(sp)
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204cfc:	4701                	li	a4,0
ffffffffc0204cfe:	46ad                	li	a3,11
ffffffffc0204d00:	00100637          	lui	a2,0x100
ffffffffc0204d04:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204d08:	8526                	mv	a0,s1
ffffffffc0204d0a:	c13fe0ef          	jal	ffffffffc020391c <mm_map>
ffffffffc0204d0e:	842a                	mv	s0,a0
ffffffffc0204d10:	1a051063          	bnez	a0,ffffffffc0204eb0 <do_execve+0x360>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204d14:	6c88                	ld	a0,24(s1)
ffffffffc0204d16:	467d                	li	a2,31
ffffffffc0204d18:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204d1c:	939fe0ef          	jal	ffffffffc0203654 <pgdir_alloc_page>
ffffffffc0204d20:	38050863          	beqz	a0,ffffffffc02050b0 <do_execve+0x560>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204d24:	6c88                	ld	a0,24(s1)
ffffffffc0204d26:	467d                	li	a2,31
ffffffffc0204d28:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204d2c:	929fe0ef          	jal	ffffffffc0203654 <pgdir_alloc_page>
ffffffffc0204d30:	34050f63          	beqz	a0,ffffffffc020508e <do_execve+0x53e>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204d34:	6c88                	ld	a0,24(s1)
ffffffffc0204d36:	467d                	li	a2,31
ffffffffc0204d38:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204d3c:	919fe0ef          	jal	ffffffffc0203654 <pgdir_alloc_page>
ffffffffc0204d40:	32050663          	beqz	a0,ffffffffc020506c <do_execve+0x51c>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204d44:	6c88                	ld	a0,24(s1)
ffffffffc0204d46:	467d                	li	a2,31
ffffffffc0204d48:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204d4c:	909fe0ef          	jal	ffffffffc0203654 <pgdir_alloc_page>
ffffffffc0204d50:	2e050d63          	beqz	a0,ffffffffc020504a <do_execve+0x4fa>
    mm->mm_count += 1;
ffffffffc0204d54:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204d56:	000d3603          	ld	a2,0(s10)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204d5a:	6c94                	ld	a3,24(s1)
ffffffffc0204d5c:	2785                	addiw	a5,a5,1
ffffffffc0204d5e:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0204d60:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204d62:	c02007b7          	lui	a5,0xc0200
ffffffffc0204d66:	2cf6e563          	bltu	a3,a5,ffffffffc0205030 <do_execve+0x4e0>
ffffffffc0204d6a:	000a3783          	ld	a5,0(s4)
ffffffffc0204d6e:	577d                	li	a4,-1
ffffffffc0204d70:	177e                	slli	a4,a4,0x3f
ffffffffc0204d72:	8e9d                	sub	a3,a3,a5
ffffffffc0204d74:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204d78:	f654                	sd	a3,168(a2)
ffffffffc0204d7a:	8fd9                	or	a5,a5,a4
ffffffffc0204d7c:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204d80:	7244                	ld	s1,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204d82:	4581                	li	a1,0
ffffffffc0204d84:	12000613          	li	a2,288
ffffffffc0204d88:	8526                	mv	a0,s1
    uintptr_t sstatus = tf->status;
ffffffffc0204d8a:	1004b903          	ld	s2,256(s1)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204d8e:	4bd000ef          	jal	ffffffffc0205a4a <memset>
    tf->epc = elf->e_entry;
ffffffffc0204d92:	67e2                	ld	a5,24(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d94:	000d3983          	ld	s3,0(s10)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204d98:	edf97913          	andi	s2,s2,-289
    tf->epc = elf->e_entry;
ffffffffc0204d9c:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204d9e:	4785                	li	a5,1
ffffffffc0204da0:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204da2:	02096913          	ori	s2,s2,32
    tf->epc = elf->e_entry;
ffffffffc0204da6:	10e4b423          	sd	a4,264(s1)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204daa:	e89c                	sd	a5,16(s1)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204dac:	0b498513          	addi	a0,s3,180
ffffffffc0204db0:	4641                	li	a2,16
ffffffffc0204db2:	4581                	li	a1,0
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204db4:	1124b023          	sd	s2,256(s1)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204db8:	493000ef          	jal	ffffffffc0205a4a <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204dbc:	0b498513          	addi	a0,s3,180
ffffffffc0204dc0:	180c                	addi	a1,sp,48
ffffffffc0204dc2:	463d                	li	a2,15
ffffffffc0204dc4:	499000ef          	jal	ffffffffc0205a5c <memcpy>
ffffffffc0204dc8:	69aa                	ld	s3,136(sp)
ffffffffc0204dca:	6a0a                	ld	s4,128(sp)
ffffffffc0204dcc:	7ae6                	ld	s5,120(sp)
ffffffffc0204dce:	7b46                	ld	s6,112(sp)
ffffffffc0204dd0:	7ba6                	ld	s7,104(sp)
ffffffffc0204dd2:	7c06                	ld	s8,96(sp)
ffffffffc0204dd4:	6ce6                	ld	s9,88(sp)
}
ffffffffc0204dd6:	70aa                	ld	ra,168(sp)
ffffffffc0204dd8:	8522                	mv	a0,s0
ffffffffc0204dda:	740a                	ld	s0,160(sp)
ffffffffc0204ddc:	64ea                	ld	s1,152(sp)
ffffffffc0204dde:	694a                	ld	s2,144(sp)
ffffffffc0204de0:	6d46                	ld	s10,80(sp)
ffffffffc0204de2:	614d                	addi	sp,sp,176
ffffffffc0204de4:	8082                	ret
    int ret = -E_NO_MEM;
ffffffffc0204de6:	5471                	li	s0,-4
ffffffffc0204de8:	b561                	j	ffffffffc0204c70 <do_execve+0x120>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204dea:	0289b603          	ld	a2,40(s3)
ffffffffc0204dee:	0209b783          	ld	a5,32(s3)
ffffffffc0204df2:	20f66163          	bltu	a2,a5,ffffffffc0204ff4 <do_execve+0x4a4>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204df6:	0049a783          	lw	a5,4(s3)
ffffffffc0204dfa:	0027971b          	slliw	a4,a5,0x2
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204dfe:	0027f693          	andi	a3,a5,2
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204e02:	8b11                	andi	a4,a4,4
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204e04:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204e06:	c6e9                	beqz	a3,ffffffffc0204ed0 <do_execve+0x380>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204e08:	1c079563          	bnez	a5,ffffffffc0204fd2 <do_execve+0x482>
            perm |= (PTE_W | PTE_R);
ffffffffc0204e0c:	47dd                	li	a5,23
            vm_flags |= VM_WRITE;
ffffffffc0204e0e:	00276693          	ori	a3,a4,2
            perm |= (PTE_W | PTE_R);
ffffffffc0204e12:	e43e                	sd	a5,8(sp)
        if (vm_flags & VM_EXEC)
ffffffffc0204e14:	c709                	beqz	a4,ffffffffc0204e1e <do_execve+0x2ce>
            perm |= PTE_X;
ffffffffc0204e16:	67a2                	ld	a5,8(sp)
ffffffffc0204e18:	0087e793          	ori	a5,a5,8
ffffffffc0204e1c:	e43e                	sd	a5,8(sp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204e1e:	0109b583          	ld	a1,16(s3)
ffffffffc0204e22:	4701                	li	a4,0
ffffffffc0204e24:	8526                	mv	a0,s1
ffffffffc0204e26:	af7fe0ef          	jal	ffffffffc020391c <mm_map>
ffffffffc0204e2a:	842a                	mv	s0,a0
ffffffffc0204e2c:	1c051263          	bnez	a0,ffffffffc0204ff0 <do_execve+0x4a0>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204e30:	0109ba83          	ld	s5,16(s3)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204e34:	0209b403          	ld	s0,32(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204e38:	77fd                	lui	a5,0xfffff
ffffffffc0204e3a:	00faf5b3          	and	a1,s5,a5
        end = ph->p_va + ph->p_filesz;
ffffffffc0204e3e:	9456                	add	s0,s0,s5
        while (start < end)
ffffffffc0204e40:	1a8af363          	bgeu	s5,s0,ffffffffc0204fe6 <do_execve+0x496>
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204e44:	0089b903          	ld	s2,8(s3)
ffffffffc0204e48:	67e2                	ld	a5,24(sp)
ffffffffc0204e4a:	993e                	add	s2,s2,a5
ffffffffc0204e4c:	a881                	j	ffffffffc0204e9c <do_execve+0x34c>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204e4e:	6785                	lui	a5,0x1
ffffffffc0204e50:	00f58db3          	add	s11,a1,a5
                size -= la - end;
ffffffffc0204e54:	41540633          	sub	a2,s0,s5
            if (end < la)
ffffffffc0204e58:	01b46463          	bltu	s0,s11,ffffffffc0204e60 <do_execve+0x310>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204e5c:	415d8633          	sub	a2,s11,s5
    return page - pages + nbase;
ffffffffc0204e60:	000bb683          	ld	a3,0(s7)
    return KADDR(page2pa(page));
ffffffffc0204e64:	67c2                	ld	a5,16(sp)
ffffffffc0204e66:	000c3503          	ld	a0,0(s8)
    return page - pages + nbase;
ffffffffc0204e6a:	40dc86b3          	sub	a3,s9,a3
ffffffffc0204e6e:	8699                	srai	a3,a3,0x6
ffffffffc0204e70:	96da                	add	a3,a3,s6
    return KADDR(page2pa(page));
ffffffffc0204e72:	00f6f8b3          	and	a7,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204e76:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204e78:	18a8f163          	bgeu	a7,a0,ffffffffc0204ffa <do_execve+0x4aa>
ffffffffc0204e7c:	000a3503          	ld	a0,0(s4)
ffffffffc0204e80:	40ba85b3          	sub	a1,s5,a1
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204e84:	e032                	sd	a2,0(sp)
ffffffffc0204e86:	9536                	add	a0,a0,a3
ffffffffc0204e88:	952e                	add	a0,a0,a1
ffffffffc0204e8a:	85ca                	mv	a1,s2
ffffffffc0204e8c:	3d1000ef          	jal	ffffffffc0205a5c <memcpy>
            start += size, from += size;
ffffffffc0204e90:	6602                	ld	a2,0(sp)
ffffffffc0204e92:	9ab2                	add	s5,s5,a2
ffffffffc0204e94:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204e96:	048af463          	bgeu	s5,s0,ffffffffc0204ede <do_execve+0x38e>
ffffffffc0204e9a:	85ee                	mv	a1,s11
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204e9c:	6c88                	ld	a0,24(s1)
ffffffffc0204e9e:	6622                	ld	a2,8(sp)
ffffffffc0204ea0:	e02e                	sd	a1,0(sp)
ffffffffc0204ea2:	fb2fe0ef          	jal	ffffffffc0203654 <pgdir_alloc_page>
ffffffffc0204ea6:	6582                	ld	a1,0(sp)
ffffffffc0204ea8:	8caa                	mv	s9,a0
ffffffffc0204eaa:	f155                	bnez	a0,ffffffffc0204e4e <do_execve+0x2fe>
ffffffffc0204eac:	6da6                	ld	s11,72(sp)
        ret = -E_NO_MEM;
ffffffffc0204eae:	5471                	li	s0,-4
    exit_mmap(mm);
ffffffffc0204eb0:	8526                	mv	a0,s1
ffffffffc0204eb2:	bcffe0ef          	jal	ffffffffc0203a80 <exit_mmap>
ffffffffc0204eb6:	69aa                	ld	s3,136(sp)
ffffffffc0204eb8:	6ce6                	ld	s9,88(sp)
ffffffffc0204eba:	b345                	j	ffffffffc0204c5a <do_execve+0x10a>
            exit_mmap(mm);
ffffffffc0204ebc:	8526                	mv	a0,s1
ffffffffc0204ebe:	bc3fe0ef          	jal	ffffffffc0203a80 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204ec2:	8526                	mv	a0,s1
ffffffffc0204ec4:	ad4ff0ef          	jal	ffffffffc0204198 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204ec8:	8526                	mv	a0,s1
ffffffffc0204eca:	a01fe0ef          	jal	ffffffffc02038ca <mm_destroy>
ffffffffc0204ece:	b9ed                	j	ffffffffc0204bc8 <do_execve+0x78>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204ed0:	0e078d63          	beqz	a5,ffffffffc0204fca <do_execve+0x47a>
            perm |= PTE_R;
ffffffffc0204ed4:	47cd                	li	a5,19
            vm_flags |= VM_READ;
ffffffffc0204ed6:	00176693          	ori	a3,a4,1
            perm |= PTE_R;
ffffffffc0204eda:	e43e                	sd	a5,8(sp)
ffffffffc0204edc:	bf25                	j	ffffffffc0204e14 <do_execve+0x2c4>
        end = ph->p_memsz + ph->p_va;
ffffffffc0204ede:	0109b403          	ld	s0,16(s3)
ffffffffc0204ee2:	0289b683          	ld	a3,40(s3)
ffffffffc0204ee6:	9436                	add	s0,s0,a3
        if (start < la) {
ffffffffc0204ee8:	07bafc63          	bgeu	s5,s11,ffffffffc0204f60 <do_execve+0x410>
            if (start == end) {
ffffffffc0204eec:	e15402e3          	beq	s0,s5,ffffffffc0204cf0 <do_execve+0x1a0>
                size -= la - end;
ffffffffc0204ef0:	41540933          	sub	s2,s0,s5
            if (end < la) {
ffffffffc0204ef4:	0fb47463          	bgeu	s0,s11,ffffffffc0204fdc <do_execve+0x48c>
    return page - pages + nbase;
ffffffffc0204ef8:	000bb683          	ld	a3,0(s7)
    return KADDR(page2pa(page));
ffffffffc0204efc:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204f00:	40dc86b3          	sub	a3,s9,a3
ffffffffc0204f04:	8699                	srai	a3,a3,0x6
ffffffffc0204f06:	96da                	add	a3,a3,s6
    return KADDR(page2pa(page));
ffffffffc0204f08:	00c69613          	slli	a2,a3,0xc
ffffffffc0204f0c:	8231                	srli	a2,a2,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0204f0e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204f10:	0eb67563          	bgeu	a2,a1,ffffffffc0204ffa <do_execve+0x4aa>
ffffffffc0204f14:	000a3603          	ld	a2,0(s4)
            off = start - (la - PGSIZE);
ffffffffc0204f18:	6505                	lui	a0,0x1
ffffffffc0204f1a:	9556                	add	a0,a0,s5
ffffffffc0204f1c:	96b2                	add	a3,a3,a2
ffffffffc0204f1e:	41b50533          	sub	a0,a0,s11
            memset(page2kva(page) + off, 0, size);
ffffffffc0204f22:	9536                	add	a0,a0,a3
ffffffffc0204f24:	864a                	mv	a2,s2
ffffffffc0204f26:	4581                	li	a1,0
ffffffffc0204f28:	323000ef          	jal	ffffffffc0205a4a <memset>
            start += size;
ffffffffc0204f2c:	9aca                	add	s5,s5,s2
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204f2e:	01b436b3          	sltu	a3,s0,s11
ffffffffc0204f32:	01b47463          	bgeu	s0,s11,ffffffffc0204f3a <do_execve+0x3ea>
ffffffffc0204f36:	db540de3          	beq	s0,s5,ffffffffc0204cf0 <do_execve+0x1a0>
ffffffffc0204f3a:	e299                	bnez	a3,ffffffffc0204f40 <do_execve+0x3f0>
ffffffffc0204f3c:	03ba8263          	beq	s5,s11,ffffffffc0204f60 <do_execve+0x410>
ffffffffc0204f40:	00002697          	auipc	a3,0x2
ffffffffc0204f44:	55068693          	addi	a3,a3,1360 # ffffffffc0207490 <etext+0x1a1c>
ffffffffc0204f48:	00001617          	auipc	a2,0x1
ffffffffc0204f4c:	4e060613          	addi	a2,a2,1248 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0204f50:	2a100593          	li	a1,673
ffffffffc0204f54:	00002517          	auipc	a0,0x2
ffffffffc0204f58:	32c50513          	addi	a0,a0,812 # ffffffffc0207280 <etext+0x180c>
ffffffffc0204f5c:	ceafb0ef          	jal	ffffffffc0200446 <__panic>
        while (start < end) {
ffffffffc0204f60:	d88af8e3          	bgeu	s5,s0,ffffffffc0204cf0 <do_execve+0x1a0>
ffffffffc0204f64:	56fd                	li	a3,-1
ffffffffc0204f66:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204f6a:	f03e                	sd	a5,32(sp)
ffffffffc0204f6c:	a0b9                	j	ffffffffc0204fba <do_execve+0x46a>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204f6e:	6785                	lui	a5,0x1
ffffffffc0204f70:	00fd88b3          	add	a7,s11,a5
                size -= la - end;
ffffffffc0204f74:	41540933          	sub	s2,s0,s5
            if (end < la) {
ffffffffc0204f78:	01146463          	bltu	s0,a7,ffffffffc0204f80 <do_execve+0x430>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204f7c:	41588933          	sub	s2,a7,s5
    return page - pages + nbase;
ffffffffc0204f80:	000bb683          	ld	a3,0(s7)
    return KADDR(page2pa(page));
ffffffffc0204f84:	7782                	ld	a5,32(sp)
ffffffffc0204f86:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204f8a:	40dc86b3          	sub	a3,s9,a3
ffffffffc0204f8e:	8699                	srai	a3,a3,0x6
ffffffffc0204f90:	96da                	add	a3,a3,s6
    return KADDR(page2pa(page));
ffffffffc0204f92:	00f6f533          	and	a0,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204f96:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204f98:	06b57163          	bgeu	a0,a1,ffffffffc0204ffa <do_execve+0x4aa>
ffffffffc0204f9c:	000a3583          	ld	a1,0(s4)
ffffffffc0204fa0:	41ba8533          	sub	a0,s5,s11
            memset(page2kva(page) + off, 0, size);
ffffffffc0204fa4:	864a                	mv	a2,s2
ffffffffc0204fa6:	96ae                	add	a3,a3,a1
ffffffffc0204fa8:	9536                	add	a0,a0,a3
ffffffffc0204faa:	4581                	li	a1,0
            start += size;
ffffffffc0204fac:	9aca                	add	s5,s5,s2
ffffffffc0204fae:	e046                	sd	a7,0(sp)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204fb0:	29b000ef          	jal	ffffffffc0205a4a <memset>
        while (start < end) {
ffffffffc0204fb4:	d28afee3          	bgeu	s5,s0,ffffffffc0204cf0 <do_execve+0x1a0>
ffffffffc0204fb8:	6d82                	ld	s11,0(sp)
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
ffffffffc0204fba:	6c88                	ld	a0,24(s1)
ffffffffc0204fbc:	6622                	ld	a2,8(sp)
ffffffffc0204fbe:	85ee                	mv	a1,s11
ffffffffc0204fc0:	e94fe0ef          	jal	ffffffffc0203654 <pgdir_alloc_page>
ffffffffc0204fc4:	8caa                	mv	s9,a0
ffffffffc0204fc6:	f545                	bnez	a0,ffffffffc0204f6e <do_execve+0x41e>
ffffffffc0204fc8:	b5d5                	j	ffffffffc0204eac <do_execve+0x35c>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204fca:	47c5                	li	a5,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204fcc:	86ba                	mv	a3,a4
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204fce:	e43e                	sd	a5,8(sp)
ffffffffc0204fd0:	b591                	j	ffffffffc0204e14 <do_execve+0x2c4>
            perm |= (PTE_W | PTE_R);
ffffffffc0204fd2:	47dd                	li	a5,23
            vm_flags |= VM_READ;
ffffffffc0204fd4:	00376693          	ori	a3,a4,3
            perm |= (PTE_W | PTE_R);
ffffffffc0204fd8:	e43e                	sd	a5,8(sp)
ffffffffc0204fda:	bd2d                	j	ffffffffc0204e14 <do_execve+0x2c4>
            size = la - start;
ffffffffc0204fdc:	415d8933          	sub	s2,s11,s5
ffffffffc0204fe0:	bf21                	j	ffffffffc0204ef8 <do_execve+0x3a8>
        return -E_INVAL;
ffffffffc0204fe2:	5475                	li	s0,-3
ffffffffc0204fe4:	bbcd                	j	ffffffffc0204dd6 <do_execve+0x286>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204fe6:	8dae                	mv	s11,a1
        while (start < end)
ffffffffc0204fe8:	8456                	mv	s0,s5
ffffffffc0204fea:	bde5                	j	ffffffffc0204ee2 <do_execve+0x392>
    int ret = -E_NO_MEM;
ffffffffc0204fec:	5471                	li	s0,-4
ffffffffc0204fee:	b9b5                	j	ffffffffc0204c6a <do_execve+0x11a>
ffffffffc0204ff0:	6da6                	ld	s11,72(sp)
ffffffffc0204ff2:	bd7d                	j	ffffffffc0204eb0 <do_execve+0x360>
            ret = -E_INVAL_ELF;
ffffffffc0204ff4:	6da6                	ld	s11,72(sp)
ffffffffc0204ff6:	5461                	li	s0,-8
ffffffffc0204ff8:	bd65                	j	ffffffffc0204eb0 <do_execve+0x360>
ffffffffc0204ffa:	00001617          	auipc	a2,0x1
ffffffffc0204ffe:	7de60613          	addi	a2,a2,2014 # ffffffffc02067d8 <etext+0xd64>
ffffffffc0205002:	07100593          	li	a1,113
ffffffffc0205006:	00001517          	auipc	a0,0x1
ffffffffc020500a:	7fa50513          	addi	a0,a0,2042 # ffffffffc0206800 <etext+0xd8c>
ffffffffc020500e:	c38fb0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0205012:	00001617          	auipc	a2,0x1
ffffffffc0205016:	7c660613          	addi	a2,a2,1990 # ffffffffc02067d8 <etext+0xd64>
ffffffffc020501a:	07100593          	li	a1,113
ffffffffc020501e:	00001517          	auipc	a0,0x1
ffffffffc0205022:	7e250513          	addi	a0,a0,2018 # ffffffffc0206800 <etext+0xd8c>
ffffffffc0205026:	e54e                	sd	s3,136(sp)
ffffffffc0205028:	ece6                	sd	s9,88(sp)
ffffffffc020502a:	e4ee                	sd	s11,72(sp)
ffffffffc020502c:	c1afb0ef          	jal	ffffffffc0200446 <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0205030:	00002617          	auipc	a2,0x2
ffffffffc0205034:	85060613          	addi	a2,a2,-1968 # ffffffffc0206880 <etext+0xe0c>
ffffffffc0205038:	2bd00593          	li	a1,701
ffffffffc020503c:	00002517          	auipc	a0,0x2
ffffffffc0205040:	24450513          	addi	a0,a0,580 # ffffffffc0207280 <etext+0x180c>
ffffffffc0205044:	e4ee                	sd	s11,72(sp)
ffffffffc0205046:	c00fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc020504a:	00002697          	auipc	a3,0x2
ffffffffc020504e:	55e68693          	addi	a3,a3,1374 # ffffffffc02075a8 <etext+0x1b34>
ffffffffc0205052:	00001617          	auipc	a2,0x1
ffffffffc0205056:	3d660613          	addi	a2,a2,982 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020505a:	2b800593          	li	a1,696
ffffffffc020505e:	00002517          	auipc	a0,0x2
ffffffffc0205062:	22250513          	addi	a0,a0,546 # ffffffffc0207280 <etext+0x180c>
ffffffffc0205066:	e4ee                	sd	s11,72(sp)
ffffffffc0205068:	bdefb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc020506c:	00002697          	auipc	a3,0x2
ffffffffc0205070:	4f468693          	addi	a3,a3,1268 # ffffffffc0207560 <etext+0x1aec>
ffffffffc0205074:	00001617          	auipc	a2,0x1
ffffffffc0205078:	3b460613          	addi	a2,a2,948 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020507c:	2b700593          	li	a1,695
ffffffffc0205080:	00002517          	auipc	a0,0x2
ffffffffc0205084:	20050513          	addi	a0,a0,512 # ffffffffc0207280 <etext+0x180c>
ffffffffc0205088:	e4ee                	sd	s11,72(sp)
ffffffffc020508a:	bbcfb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc020508e:	00002697          	auipc	a3,0x2
ffffffffc0205092:	48a68693          	addi	a3,a3,1162 # ffffffffc0207518 <etext+0x1aa4>
ffffffffc0205096:	00001617          	auipc	a2,0x1
ffffffffc020509a:	39260613          	addi	a2,a2,914 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020509e:	2b600593          	li	a1,694
ffffffffc02050a2:	00002517          	auipc	a0,0x2
ffffffffc02050a6:	1de50513          	addi	a0,a0,478 # ffffffffc0207280 <etext+0x180c>
ffffffffc02050aa:	e4ee                	sd	s11,72(sp)
ffffffffc02050ac:	b9afb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc02050b0:	00002697          	auipc	a3,0x2
ffffffffc02050b4:	42068693          	addi	a3,a3,1056 # ffffffffc02074d0 <etext+0x1a5c>
ffffffffc02050b8:	00001617          	auipc	a2,0x1
ffffffffc02050bc:	37060613          	addi	a2,a2,880 # ffffffffc0206428 <etext+0x9b4>
ffffffffc02050c0:	2b500593          	li	a1,693
ffffffffc02050c4:	00002517          	auipc	a0,0x2
ffffffffc02050c8:	1bc50513          	addi	a0,a0,444 # ffffffffc0207280 <etext+0x180c>
ffffffffc02050cc:	e4ee                	sd	s11,72(sp)
ffffffffc02050ce:	b78fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02050d2 <do_yield>:
    current->need_resched = 1;
ffffffffc02050d2:	000a0797          	auipc	a5,0xa0
ffffffffc02050d6:	efe7b783          	ld	a5,-258(a5) # ffffffffc02a4fd0 <current>
ffffffffc02050da:	4705                	li	a4,1
}
ffffffffc02050dc:	4501                	li	a0,0
    current->need_resched = 1;
ffffffffc02050de:	ef98                	sd	a4,24(a5)
}
ffffffffc02050e0:	8082                	ret

ffffffffc02050e2 <do_wait>:
    if (code_store != NULL)
ffffffffc02050e2:	c59d                	beqz	a1,ffffffffc0205110 <do_wait+0x2e>
{
ffffffffc02050e4:	1101                	addi	sp,sp,-32
ffffffffc02050e6:	e02a                	sd	a0,0(sp)
    struct mm_struct *mm = current->mm;
ffffffffc02050e8:	000a0517          	auipc	a0,0xa0
ffffffffc02050ec:	ee853503          	ld	a0,-280(a0) # ffffffffc02a4fd0 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc02050f0:	4685                	li	a3,1
ffffffffc02050f2:	4611                	li	a2,4
ffffffffc02050f4:	7508                	ld	a0,40(a0)
{
ffffffffc02050f6:	ec06                	sd	ra,24(sp)
ffffffffc02050f8:	e42e                	sd	a1,8(sp)
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc02050fa:	d1ffe0ef          	jal	ffffffffc0203e18 <user_mem_check>
ffffffffc02050fe:	6702                	ld	a4,0(sp)
ffffffffc0205100:	67a2                	ld	a5,8(sp)
ffffffffc0205102:	c909                	beqz	a0,ffffffffc0205114 <do_wait+0x32>
}
ffffffffc0205104:	60e2                	ld	ra,24(sp)
ffffffffc0205106:	85be                	mv	a1,a5
ffffffffc0205108:	853a                	mv	a0,a4
ffffffffc020510a:	6105                	addi	sp,sp,32
ffffffffc020510c:	f3eff06f          	j	ffffffffc020484a <do_wait.part.0>
ffffffffc0205110:	f3aff06f          	j	ffffffffc020484a <do_wait.part.0>
ffffffffc0205114:	60e2                	ld	ra,24(sp)
ffffffffc0205116:	5575                	li	a0,-3
ffffffffc0205118:	6105                	addi	sp,sp,32
ffffffffc020511a:	8082                	ret

ffffffffc020511c <do_kill>:
    if (0 < pid && pid < MAX_PID)
ffffffffc020511c:	6789                	lui	a5,0x2
ffffffffc020511e:	fff5071b          	addiw	a4,a0,-1
ffffffffc0205122:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6bca>
ffffffffc0205124:	06e7e463          	bltu	a5,a4,ffffffffc020518c <do_kill+0x70>
{
ffffffffc0205128:	1101                	addi	sp,sp,-32
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc020512a:	45a9                	li	a1,10
{
ffffffffc020512c:	ec06                	sd	ra,24(sp)
ffffffffc020512e:	e42a                	sd	a0,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0205130:	484000ef          	jal	ffffffffc02055b4 <hash32>
ffffffffc0205134:	02051793          	slli	a5,a0,0x20
ffffffffc0205138:	01c7d693          	srli	a3,a5,0x1c
ffffffffc020513c:	0009c797          	auipc	a5,0x9c
ffffffffc0205140:	e1c78793          	addi	a5,a5,-484 # ffffffffc02a0f58 <hash_list>
ffffffffc0205144:	96be                	add	a3,a3,a5
        while ((le = list_next(le)) != list)
ffffffffc0205146:	6622                	ld	a2,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0205148:	8536                	mv	a0,a3
        while ((le = list_next(le)) != list)
ffffffffc020514a:	a029                	j	ffffffffc0205154 <do_kill+0x38>
            if (proc->pid == pid)
ffffffffc020514c:	f2c52703          	lw	a4,-212(a0)
ffffffffc0205150:	00c70963          	beq	a4,a2,ffffffffc0205162 <do_kill+0x46>
ffffffffc0205154:	6508                	ld	a0,8(a0)
        while ((le = list_next(le)) != list)
ffffffffc0205156:	fea69be3          	bne	a3,a0,ffffffffc020514c <do_kill+0x30>
}
ffffffffc020515a:	60e2                	ld	ra,24(sp)
    return -E_INVAL;
ffffffffc020515c:	5575                	li	a0,-3
}
ffffffffc020515e:	6105                	addi	sp,sp,32
ffffffffc0205160:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0205162:	fd852703          	lw	a4,-40(a0)
ffffffffc0205166:	00177693          	andi	a3,a4,1
ffffffffc020516a:	e29d                	bnez	a3,ffffffffc0205190 <do_kill+0x74>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc020516c:	4954                	lw	a3,20(a0)
            proc->flags |= PF_EXITING;
ffffffffc020516e:	00176713          	ori	a4,a4,1
ffffffffc0205172:	fce52c23          	sw	a4,-40(a0)
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0205176:	0006c663          	bltz	a3,ffffffffc0205182 <do_kill+0x66>
            return 0;
ffffffffc020517a:	4501                	li	a0,0
}
ffffffffc020517c:	60e2                	ld	ra,24(sp)
ffffffffc020517e:	6105                	addi	sp,sp,32
ffffffffc0205180:	8082                	ret
                wakeup_proc(proc);
ffffffffc0205182:	f2850513          	addi	a0,a0,-216
ffffffffc0205186:	232000ef          	jal	ffffffffc02053b8 <wakeup_proc>
ffffffffc020518a:	bfc5                	j	ffffffffc020517a <do_kill+0x5e>
    return -E_INVAL;
ffffffffc020518c:	5575                	li	a0,-3
}
ffffffffc020518e:	8082                	ret
        return -E_KILLED;
ffffffffc0205190:	555d                	li	a0,-9
ffffffffc0205192:	b7ed                	j	ffffffffc020517c <do_kill+0x60>

ffffffffc0205194 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0205194:	1101                	addi	sp,sp,-32
ffffffffc0205196:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0205198:	000a0797          	auipc	a5,0xa0
ffffffffc020519c:	dc078793          	addi	a5,a5,-576 # ffffffffc02a4f58 <proc_list>
ffffffffc02051a0:	ec06                	sd	ra,24(sp)
ffffffffc02051a2:	e822                	sd	s0,16(sp)
ffffffffc02051a4:	e04a                	sd	s2,0(sp)
ffffffffc02051a6:	0009c497          	auipc	s1,0x9c
ffffffffc02051aa:	db248493          	addi	s1,s1,-590 # ffffffffc02a0f58 <hash_list>
ffffffffc02051ae:	e79c                	sd	a5,8(a5)
ffffffffc02051b0:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc02051b2:	000a0717          	auipc	a4,0xa0
ffffffffc02051b6:	da670713          	addi	a4,a4,-602 # ffffffffc02a4f58 <proc_list>
ffffffffc02051ba:	87a6                	mv	a5,s1
ffffffffc02051bc:	e79c                	sd	a5,8(a5)
ffffffffc02051be:	e39c                	sd	a5,0(a5)
ffffffffc02051c0:	07c1                	addi	a5,a5,16
ffffffffc02051c2:	fee79de3          	bne	a5,a4,ffffffffc02051bc <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc02051c6:	ed5fe0ef          	jal	ffffffffc020409a <alloc_proc>
ffffffffc02051ca:	000a0917          	auipc	s2,0xa0
ffffffffc02051ce:	e1690913          	addi	s2,s2,-490 # ffffffffc02a4fe0 <idleproc>
ffffffffc02051d2:	00a93023          	sd	a0,0(s2)
ffffffffc02051d6:	10050363          	beqz	a0,ffffffffc02052dc <proc_init+0x148>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc02051da:	4789                	li	a5,2
ffffffffc02051dc:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02051de:	00003797          	auipc	a5,0x3
ffffffffc02051e2:	e2278793          	addi	a5,a5,-478 # ffffffffc0208000 <bootstack>
ffffffffc02051e6:	e91c                	sd	a5,16(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02051e8:	0b450413          	addi	s0,a0,180
    idleproc->need_resched = 1;
ffffffffc02051ec:	4785                	li	a5,1
ffffffffc02051ee:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02051f0:	4641                	li	a2,16
ffffffffc02051f2:	8522                	mv	a0,s0
ffffffffc02051f4:	4581                	li	a1,0
ffffffffc02051f6:	055000ef          	jal	ffffffffc0205a4a <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02051fa:	8522                	mv	a0,s0
ffffffffc02051fc:	463d                	li	a2,15
ffffffffc02051fe:	00002597          	auipc	a1,0x2
ffffffffc0205202:	40a58593          	addi	a1,a1,1034 # ffffffffc0207608 <etext+0x1b94>
ffffffffc0205206:	057000ef          	jal	ffffffffc0205a5c <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc020520a:	000a0797          	auipc	a5,0xa0
ffffffffc020520e:	dbe7a783          	lw	a5,-578(a5) # ffffffffc02a4fc8 <nr_process>

    current = idleproc;
ffffffffc0205212:	00093703          	ld	a4,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205216:	4601                	li	a2,0
    nr_process++;
ffffffffc0205218:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc020521a:	4581                	li	a1,0
ffffffffc020521c:	00000517          	auipc	a0,0x0
ffffffffc0205220:	81050513          	addi	a0,a0,-2032 # ffffffffc0204a2c <init_main>
    current = idleproc;
ffffffffc0205224:	000a0697          	auipc	a3,0xa0
ffffffffc0205228:	dae6b623          	sd	a4,-596(a3) # ffffffffc02a4fd0 <current>
    nr_process++;
ffffffffc020522c:	000a0717          	auipc	a4,0xa0
ffffffffc0205230:	d8f72e23          	sw	a5,-612(a4) # ffffffffc02a4fc8 <nr_process>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205234:	c82ff0ef          	jal	ffffffffc02046b6 <kernel_thread>
ffffffffc0205238:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc020523a:	08a05563          	blez	a0,ffffffffc02052c4 <proc_init+0x130>
    if (0 < pid && pid < MAX_PID)
ffffffffc020523e:	6789                	lui	a5,0x2
ffffffffc0205240:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6bca>
ffffffffc0205242:	fff5071b          	addiw	a4,a0,-1
ffffffffc0205246:	02e7e463          	bltu	a5,a4,ffffffffc020526e <proc_init+0xda>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc020524a:	45a9                	li	a1,10
ffffffffc020524c:	368000ef          	jal	ffffffffc02055b4 <hash32>
ffffffffc0205250:	02051713          	slli	a4,a0,0x20
ffffffffc0205254:	01c75793          	srli	a5,a4,0x1c
ffffffffc0205258:	00f486b3          	add	a3,s1,a5
ffffffffc020525c:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc020525e:	a029                	j	ffffffffc0205268 <proc_init+0xd4>
            if (proc->pid == pid)
ffffffffc0205260:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0205264:	04870d63          	beq	a4,s0,ffffffffc02052be <proc_init+0x12a>
    return listelm->next;
ffffffffc0205268:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020526a:	fef69be3          	bne	a3,a5,ffffffffc0205260 <proc_init+0xcc>
    return NULL;
ffffffffc020526e:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205270:	0b478413          	addi	s0,a5,180
ffffffffc0205274:	4641                	li	a2,16
ffffffffc0205276:	4581                	li	a1,0
ffffffffc0205278:	8522                	mv	a0,s0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc020527a:	000a0717          	auipc	a4,0xa0
ffffffffc020527e:	d4f73f23          	sd	a5,-674(a4) # ffffffffc02a4fd8 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205282:	7c8000ef          	jal	ffffffffc0205a4a <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205286:	8522                	mv	a0,s0
ffffffffc0205288:	463d                	li	a2,15
ffffffffc020528a:	00002597          	auipc	a1,0x2
ffffffffc020528e:	3a658593          	addi	a1,a1,934 # ffffffffc0207630 <etext+0x1bbc>
ffffffffc0205292:	7ca000ef          	jal	ffffffffc0205a5c <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205296:	00093783          	ld	a5,0(s2)
ffffffffc020529a:	cfad                	beqz	a5,ffffffffc0205314 <proc_init+0x180>
ffffffffc020529c:	43dc                	lw	a5,4(a5)
ffffffffc020529e:	ebbd                	bnez	a5,ffffffffc0205314 <proc_init+0x180>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02052a0:	000a0797          	auipc	a5,0xa0
ffffffffc02052a4:	d387b783          	ld	a5,-712(a5) # ffffffffc02a4fd8 <initproc>
ffffffffc02052a8:	c7b1                	beqz	a5,ffffffffc02052f4 <proc_init+0x160>
ffffffffc02052aa:	43d8                	lw	a4,4(a5)
ffffffffc02052ac:	4785                	li	a5,1
ffffffffc02052ae:	04f71363          	bne	a4,a5,ffffffffc02052f4 <proc_init+0x160>
}
ffffffffc02052b2:	60e2                	ld	ra,24(sp)
ffffffffc02052b4:	6442                	ld	s0,16(sp)
ffffffffc02052b6:	64a2                	ld	s1,8(sp)
ffffffffc02052b8:	6902                	ld	s2,0(sp)
ffffffffc02052ba:	6105                	addi	sp,sp,32
ffffffffc02052bc:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02052be:	f2878793          	addi	a5,a5,-216
ffffffffc02052c2:	b77d                	j	ffffffffc0205270 <proc_init+0xdc>
        panic("create init_main failed.\n");
ffffffffc02052c4:	00002617          	auipc	a2,0x2
ffffffffc02052c8:	34c60613          	addi	a2,a2,844 # ffffffffc0207610 <etext+0x1b9c>
ffffffffc02052cc:	3de00593          	li	a1,990
ffffffffc02052d0:	00002517          	auipc	a0,0x2
ffffffffc02052d4:	fb050513          	addi	a0,a0,-80 # ffffffffc0207280 <etext+0x180c>
ffffffffc02052d8:	96efb0ef          	jal	ffffffffc0200446 <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc02052dc:	00002617          	auipc	a2,0x2
ffffffffc02052e0:	31460613          	addi	a2,a2,788 # ffffffffc02075f0 <etext+0x1b7c>
ffffffffc02052e4:	3cf00593          	li	a1,975
ffffffffc02052e8:	00002517          	auipc	a0,0x2
ffffffffc02052ec:	f9850513          	addi	a0,a0,-104 # ffffffffc0207280 <etext+0x180c>
ffffffffc02052f0:	956fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02052f4:	00002697          	auipc	a3,0x2
ffffffffc02052f8:	36c68693          	addi	a3,a3,876 # ffffffffc0207660 <etext+0x1bec>
ffffffffc02052fc:	00001617          	auipc	a2,0x1
ffffffffc0205300:	12c60613          	addi	a2,a2,300 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0205304:	3e500593          	li	a1,997
ffffffffc0205308:	00002517          	auipc	a0,0x2
ffffffffc020530c:	f7850513          	addi	a0,a0,-136 # ffffffffc0207280 <etext+0x180c>
ffffffffc0205310:	936fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205314:	00002697          	auipc	a3,0x2
ffffffffc0205318:	32468693          	addi	a3,a3,804 # ffffffffc0207638 <etext+0x1bc4>
ffffffffc020531c:	00001617          	auipc	a2,0x1
ffffffffc0205320:	10c60613          	addi	a2,a2,268 # ffffffffc0206428 <etext+0x9b4>
ffffffffc0205324:	3e400593          	li	a1,996
ffffffffc0205328:	00002517          	auipc	a0,0x2
ffffffffc020532c:	f5850513          	addi	a0,a0,-168 # ffffffffc0207280 <etext+0x180c>
ffffffffc0205330:	916fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0205334 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0205334:	1141                	addi	sp,sp,-16
ffffffffc0205336:	e022                	sd	s0,0(sp)
ffffffffc0205338:	e406                	sd	ra,8(sp)
ffffffffc020533a:	000a0417          	auipc	s0,0xa0
ffffffffc020533e:	c9640413          	addi	s0,s0,-874 # ffffffffc02a4fd0 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0205342:	6018                	ld	a4,0(s0)
ffffffffc0205344:	6f1c                	ld	a5,24(a4)
ffffffffc0205346:	dffd                	beqz	a5,ffffffffc0205344 <cpu_idle+0x10>
        {
            schedule();
ffffffffc0205348:	104000ef          	jal	ffffffffc020544c <schedule>
ffffffffc020534c:	bfdd                	j	ffffffffc0205342 <cpu_idle+0xe>

ffffffffc020534e <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc020534e:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0205352:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0205356:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0205358:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc020535a:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc020535e:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0205362:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0205366:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc020536a:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc020536e:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0205372:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0205376:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc020537a:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc020537e:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0205382:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0205386:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc020538a:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc020538c:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc020538e:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0205392:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0205396:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc020539a:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc020539e:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc02053a2:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc02053a6:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc02053aa:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc02053ae:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc02053b2:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc02053b6:	8082                	ret

ffffffffc02053b8 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02053b8:	4118                	lw	a4,0(a0)
{
ffffffffc02053ba:	1101                	addi	sp,sp,-32
ffffffffc02053bc:	ec06                	sd	ra,24(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02053be:	478d                	li	a5,3
ffffffffc02053c0:	06f70763          	beq	a4,a5,ffffffffc020542e <wakeup_proc+0x76>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02053c4:	100027f3          	csrr	a5,sstatus
ffffffffc02053c8:	8b89                	andi	a5,a5,2
ffffffffc02053ca:	eb91                	bnez	a5,ffffffffc02053de <wakeup_proc+0x26>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc02053cc:	4789                	li	a5,2
ffffffffc02053ce:	02f70763          	beq	a4,a5,ffffffffc02053fc <wakeup_proc+0x44>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02053d2:	60e2                	ld	ra,24(sp)
            proc->state = PROC_RUNNABLE;
ffffffffc02053d4:	c11c                	sw	a5,0(a0)
            proc->wait_state = 0;
ffffffffc02053d6:	0e052623          	sw	zero,236(a0)
}
ffffffffc02053da:	6105                	addi	sp,sp,32
ffffffffc02053dc:	8082                	ret
        intr_disable();
ffffffffc02053de:	e42a                	sd	a0,8(sp)
ffffffffc02053e0:	d24fb0ef          	jal	ffffffffc0200904 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc02053e4:	6522                	ld	a0,8(sp)
ffffffffc02053e6:	4789                	li	a5,2
ffffffffc02053e8:	4118                	lw	a4,0(a0)
ffffffffc02053ea:	02f70663          	beq	a4,a5,ffffffffc0205416 <wakeup_proc+0x5e>
            proc->state = PROC_RUNNABLE;
ffffffffc02053ee:	c11c                	sw	a5,0(a0)
            proc->wait_state = 0;
ffffffffc02053f0:	0e052623          	sw	zero,236(a0)
}
ffffffffc02053f4:	60e2                	ld	ra,24(sp)
ffffffffc02053f6:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02053f8:	d06fb06f          	j	ffffffffc02008fe <intr_enable>
ffffffffc02053fc:	60e2                	ld	ra,24(sp)
            warn("wakeup runnable process.\n");
ffffffffc02053fe:	00002617          	auipc	a2,0x2
ffffffffc0205402:	2c260613          	addi	a2,a2,706 # ffffffffc02076c0 <etext+0x1c4c>
ffffffffc0205406:	45d1                	li	a1,20
ffffffffc0205408:	00002517          	auipc	a0,0x2
ffffffffc020540c:	2a050513          	addi	a0,a0,672 # ffffffffc02076a8 <etext+0x1c34>
}
ffffffffc0205410:	6105                	addi	sp,sp,32
            warn("wakeup runnable process.\n");
ffffffffc0205412:	89efb06f          	j	ffffffffc02004b0 <__warn>
ffffffffc0205416:	00002617          	auipc	a2,0x2
ffffffffc020541a:	2aa60613          	addi	a2,a2,682 # ffffffffc02076c0 <etext+0x1c4c>
ffffffffc020541e:	45d1                	li	a1,20
ffffffffc0205420:	00002517          	auipc	a0,0x2
ffffffffc0205424:	28850513          	addi	a0,a0,648 # ffffffffc02076a8 <etext+0x1c34>
ffffffffc0205428:	888fb0ef          	jal	ffffffffc02004b0 <__warn>
    if (flag)
ffffffffc020542c:	b7e1                	j	ffffffffc02053f4 <wakeup_proc+0x3c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020542e:	00002697          	auipc	a3,0x2
ffffffffc0205432:	25a68693          	addi	a3,a3,602 # ffffffffc0207688 <etext+0x1c14>
ffffffffc0205436:	00001617          	auipc	a2,0x1
ffffffffc020543a:	ff260613          	addi	a2,a2,-14 # ffffffffc0206428 <etext+0x9b4>
ffffffffc020543e:	45a5                	li	a1,9
ffffffffc0205440:	00002517          	auipc	a0,0x2
ffffffffc0205444:	26850513          	addi	a0,a0,616 # ffffffffc02076a8 <etext+0x1c34>
ffffffffc0205448:	ffffa0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020544c <schedule>:

void schedule(void)
{
ffffffffc020544c:	1101                	addi	sp,sp,-32
ffffffffc020544e:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205450:	100027f3          	csrr	a5,sstatus
ffffffffc0205454:	8b89                	andi	a5,a5,2
ffffffffc0205456:	4301                	li	t1,0
ffffffffc0205458:	e3c1                	bnez	a5,ffffffffc02054d8 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc020545a:	000a0897          	auipc	a7,0xa0
ffffffffc020545e:	b768b883          	ld	a7,-1162(a7) # ffffffffc02a4fd0 <current>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205462:	000a0517          	auipc	a0,0xa0
ffffffffc0205466:	b7e53503          	ld	a0,-1154(a0) # ffffffffc02a4fe0 <idleproc>
        current->need_resched = 0;
ffffffffc020546a:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020546e:	04a88f63          	beq	a7,a0,ffffffffc02054cc <schedule+0x80>
ffffffffc0205472:	0c888693          	addi	a3,a7,200
ffffffffc0205476:	000a0617          	auipc	a2,0xa0
ffffffffc020547a:	ae260613          	addi	a2,a2,-1310 # ffffffffc02a4f58 <proc_list>
        le = last;
ffffffffc020547e:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0205480:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc0205482:	4809                	li	a6,2
ffffffffc0205484:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc0205486:	00c78863          	beq	a5,a2,ffffffffc0205496 <schedule+0x4a>
                if (next->state == PROC_RUNNABLE)
ffffffffc020548a:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc020548e:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc0205492:	03070363          	beq	a4,a6,ffffffffc02054b8 <schedule+0x6c>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc0205496:	fef697e3          	bne	a3,a5,ffffffffc0205484 <schedule+0x38>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc020549a:	ed99                	bnez	a1,ffffffffc02054b8 <schedule+0x6c>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc020549c:	451c                	lw	a5,8(a0)
ffffffffc020549e:	2785                	addiw	a5,a5,1
ffffffffc02054a0:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc02054a2:	00a88663          	beq	a7,a0,ffffffffc02054ae <schedule+0x62>
ffffffffc02054a6:	e41a                	sd	t1,8(sp)
        {
            proc_run(next);
ffffffffc02054a8:	d67fe0ef          	jal	ffffffffc020420e <proc_run>
ffffffffc02054ac:	6322                	ld	t1,8(sp)
    if (flag)
ffffffffc02054ae:	00031b63          	bnez	t1,ffffffffc02054c4 <schedule+0x78>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02054b2:	60e2                	ld	ra,24(sp)
ffffffffc02054b4:	6105                	addi	sp,sp,32
ffffffffc02054b6:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02054b8:	4198                	lw	a4,0(a1)
ffffffffc02054ba:	4789                	li	a5,2
ffffffffc02054bc:	fef710e3          	bne	a4,a5,ffffffffc020549c <schedule+0x50>
ffffffffc02054c0:	852e                	mv	a0,a1
ffffffffc02054c2:	bfe9                	j	ffffffffc020549c <schedule+0x50>
}
ffffffffc02054c4:	60e2                	ld	ra,24(sp)
ffffffffc02054c6:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02054c8:	c36fb06f          	j	ffffffffc02008fe <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02054cc:	000a0617          	auipc	a2,0xa0
ffffffffc02054d0:	a8c60613          	addi	a2,a2,-1396 # ffffffffc02a4f58 <proc_list>
ffffffffc02054d4:	86b2                	mv	a3,a2
ffffffffc02054d6:	b765                	j	ffffffffc020547e <schedule+0x32>
        intr_disable();
ffffffffc02054d8:	c2cfb0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc02054dc:	4305                	li	t1,1
ffffffffc02054de:	bfb5                	j	ffffffffc020545a <schedule+0xe>

ffffffffc02054e0 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc02054e0:	000a0797          	auipc	a5,0xa0
ffffffffc02054e4:	af07b783          	ld	a5,-1296(a5) # ffffffffc02a4fd0 <current>
}
ffffffffc02054e8:	43c8                	lw	a0,4(a5)
ffffffffc02054ea:	8082                	ret

ffffffffc02054ec <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc02054ec:	4501                	li	a0,0
ffffffffc02054ee:	8082                	ret

ffffffffc02054f0 <sys_putc>:
    cputchar(c);
ffffffffc02054f0:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc02054f2:	1141                	addi	sp,sp,-16
ffffffffc02054f4:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc02054f6:	cd3fa0ef          	jal	ffffffffc02001c8 <cputchar>
}
ffffffffc02054fa:	60a2                	ld	ra,8(sp)
ffffffffc02054fc:	4501                	li	a0,0
ffffffffc02054fe:	0141                	addi	sp,sp,16
ffffffffc0205500:	8082                	ret

ffffffffc0205502 <sys_kill>:
    return do_kill(pid);
ffffffffc0205502:	4108                	lw	a0,0(a0)
ffffffffc0205504:	c19ff06f          	j	ffffffffc020511c <do_kill>

ffffffffc0205508 <sys_yield>:
    return do_yield();
ffffffffc0205508:	bcbff06f          	j	ffffffffc02050d2 <do_yield>

ffffffffc020550c <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc020550c:	6d14                	ld	a3,24(a0)
ffffffffc020550e:	6910                	ld	a2,16(a0)
ffffffffc0205510:	650c                	ld	a1,8(a0)
ffffffffc0205512:	6108                	ld	a0,0(a0)
ffffffffc0205514:	e3cff06f          	j	ffffffffc0204b50 <do_execve>

ffffffffc0205518 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0205518:	650c                	ld	a1,8(a0)
ffffffffc020551a:	4108                	lw	a0,0(a0)
ffffffffc020551c:	bc7ff06f          	j	ffffffffc02050e2 <do_wait>

ffffffffc0205520 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0205520:	000a0797          	auipc	a5,0xa0
ffffffffc0205524:	ab07b783          	ld	a5,-1360(a5) # ffffffffc02a4fd0 <current>
    return do_fork(0, stack, tf);
ffffffffc0205528:	4501                	li	a0,0
    struct trapframe *tf = current->tf;
ffffffffc020552a:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc020552c:	6a0c                	ld	a1,16(a2)
ffffffffc020552e:	d43fe06f          	j	ffffffffc0204270 <do_fork>

ffffffffc0205532 <sys_exit>:
    return do_exit(error_code);
ffffffffc0205532:	4108                	lw	a0,0(a0)
ffffffffc0205534:	9d2ff06f          	j	ffffffffc0204706 <do_exit>

ffffffffc0205538 <syscall>:

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
    struct trapframe *tf = current->tf;
ffffffffc0205538:	000a0697          	auipc	a3,0xa0
ffffffffc020553c:	a986b683          	ld	a3,-1384(a3) # ffffffffc02a4fd0 <current>
syscall(void) {
ffffffffc0205540:	715d                	addi	sp,sp,-80
ffffffffc0205542:	e0a2                	sd	s0,64(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205544:	72c0                	ld	s0,160(a3)
syscall(void) {
ffffffffc0205546:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205548:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc020554a:	4834                	lw	a3,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc020554c:	02d7ec63          	bltu	a5,a3,ffffffffc0205584 <syscall+0x4c>
        if (syscalls[num] != NULL) {
ffffffffc0205550:	00002797          	auipc	a5,0x2
ffffffffc0205554:	3b878793          	addi	a5,a5,952 # ffffffffc0207908 <syscalls>
ffffffffc0205558:	00369613          	slli	a2,a3,0x3
ffffffffc020555c:	97b2                	add	a5,a5,a2
ffffffffc020555e:	639c                	ld	a5,0(a5)
ffffffffc0205560:	c395                	beqz	a5,ffffffffc0205584 <syscall+0x4c>
            arg[0] = tf->gpr.a1;
ffffffffc0205562:	7028                	ld	a0,96(s0)
ffffffffc0205564:	742c                	ld	a1,104(s0)
ffffffffc0205566:	7830                	ld	a2,112(s0)
ffffffffc0205568:	7c34                	ld	a3,120(s0)
ffffffffc020556a:	6c38                	ld	a4,88(s0)
ffffffffc020556c:	f02a                	sd	a0,32(sp)
ffffffffc020556e:	f42e                	sd	a1,40(sp)
ffffffffc0205570:	f832                	sd	a2,48(sp)
ffffffffc0205572:	fc36                	sd	a3,56(sp)
ffffffffc0205574:	ec3a                	sd	a4,24(sp)
            arg[1] = tf->gpr.a2;
            arg[2] = tf->gpr.a3;
            arg[3] = tf->gpr.a4;
            arg[4] = tf->gpr.a5;
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205576:	0828                	addi	a0,sp,24
ffffffffc0205578:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc020557a:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc020557c:	e828                	sd	a0,80(s0)
}
ffffffffc020557e:	6406                	ld	s0,64(sp)
ffffffffc0205580:	6161                	addi	sp,sp,80
ffffffffc0205582:	8082                	ret
    print_trapframe(tf);
ffffffffc0205584:	8522                	mv	a0,s0
ffffffffc0205586:	e436                	sd	a3,8(sp)
ffffffffc0205588:	d6cfb0ef          	jal	ffffffffc0200af4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc020558c:	000a0797          	auipc	a5,0xa0
ffffffffc0205590:	a447b783          	ld	a5,-1468(a5) # ffffffffc02a4fd0 <current>
ffffffffc0205594:	66a2                	ld	a3,8(sp)
ffffffffc0205596:	00002617          	auipc	a2,0x2
ffffffffc020559a:	14a60613          	addi	a2,a2,330 # ffffffffc02076e0 <etext+0x1c6c>
ffffffffc020559e:	43d8                	lw	a4,4(a5)
ffffffffc02055a0:	06200593          	li	a1,98
ffffffffc02055a4:	0b478793          	addi	a5,a5,180
ffffffffc02055a8:	00002517          	auipc	a0,0x2
ffffffffc02055ac:	16850513          	addi	a0,a0,360 # ffffffffc0207710 <etext+0x1c9c>
ffffffffc02055b0:	e97fa0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02055b4 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc02055b4:	9e3707b7          	lui	a5,0x9e370
ffffffffc02055b8:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <_binary_obj___user_exit_out_size+0xffffffff9e365e41>
ffffffffc02055ba:	02a787bb          	mulw	a5,a5,a0
    return (hash >> (32 - bits));
ffffffffc02055be:	02000513          	li	a0,32
ffffffffc02055c2:	9d0d                	subw	a0,a0,a1
}
ffffffffc02055c4:	00a7d53b          	srlw	a0,a5,a0
ffffffffc02055c8:	8082                	ret

ffffffffc02055ca <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02055ca:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02055cc:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02055d0:	f022                	sd	s0,32(sp)
ffffffffc02055d2:	ec26                	sd	s1,24(sp)
ffffffffc02055d4:	e84a                	sd	s2,16(sp)
ffffffffc02055d6:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02055d8:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02055dc:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc02055de:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02055e2:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02055e6:	84aa                	mv	s1,a0
ffffffffc02055e8:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc02055ea:	03067d63          	bgeu	a2,a6,ffffffffc0205624 <printnum+0x5a>
ffffffffc02055ee:	e44e                	sd	s3,8(sp)
ffffffffc02055f0:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02055f2:	4785                	li	a5,1
ffffffffc02055f4:	00e7d763          	bge	a5,a4,ffffffffc0205602 <printnum+0x38>
            putch(padc, putdat);
ffffffffc02055f8:	85ca                	mv	a1,s2
ffffffffc02055fa:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc02055fc:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02055fe:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205600:	fc65                	bnez	s0,ffffffffc02055f8 <printnum+0x2e>
ffffffffc0205602:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205604:	00002797          	auipc	a5,0x2
ffffffffc0205608:	12478793          	addi	a5,a5,292 # ffffffffc0207728 <etext+0x1cb4>
ffffffffc020560c:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc020560e:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205610:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0205614:	70a2                	ld	ra,40(sp)
ffffffffc0205616:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205618:	85ca                	mv	a1,s2
ffffffffc020561a:	87a6                	mv	a5,s1
}
ffffffffc020561c:	6942                	ld	s2,16(sp)
ffffffffc020561e:	64e2                	ld	s1,24(sp)
ffffffffc0205620:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205622:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0205624:	03065633          	divu	a2,a2,a6
ffffffffc0205628:	8722                	mv	a4,s0
ffffffffc020562a:	fa1ff0ef          	jal	ffffffffc02055ca <printnum>
ffffffffc020562e:	bfd9                	j	ffffffffc0205604 <printnum+0x3a>

ffffffffc0205630 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0205630:	7119                	addi	sp,sp,-128
ffffffffc0205632:	f4a6                	sd	s1,104(sp)
ffffffffc0205634:	f0ca                	sd	s2,96(sp)
ffffffffc0205636:	ecce                	sd	s3,88(sp)
ffffffffc0205638:	e8d2                	sd	s4,80(sp)
ffffffffc020563a:	e4d6                	sd	s5,72(sp)
ffffffffc020563c:	e0da                	sd	s6,64(sp)
ffffffffc020563e:	f862                	sd	s8,48(sp)
ffffffffc0205640:	fc86                	sd	ra,120(sp)
ffffffffc0205642:	f8a2                	sd	s0,112(sp)
ffffffffc0205644:	fc5e                	sd	s7,56(sp)
ffffffffc0205646:	f466                	sd	s9,40(sp)
ffffffffc0205648:	f06a                	sd	s10,32(sp)
ffffffffc020564a:	ec6e                	sd	s11,24(sp)
ffffffffc020564c:	84aa                	mv	s1,a0
ffffffffc020564e:	8c32                	mv	s8,a2
ffffffffc0205650:	8a36                	mv	s4,a3
ffffffffc0205652:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205654:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205658:	05500b13          	li	s6,85
ffffffffc020565c:	00002a97          	auipc	s5,0x2
ffffffffc0205660:	3aca8a93          	addi	s5,s5,940 # ffffffffc0207a08 <syscalls+0x100>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205664:	000c4503          	lbu	a0,0(s8)
ffffffffc0205668:	001c0413          	addi	s0,s8,1
ffffffffc020566c:	01350a63          	beq	a0,s3,ffffffffc0205680 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0205670:	cd0d                	beqz	a0,ffffffffc02056aa <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0205672:	85ca                	mv	a1,s2
ffffffffc0205674:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205676:	00044503          	lbu	a0,0(s0)
ffffffffc020567a:	0405                	addi	s0,s0,1
ffffffffc020567c:	ff351ae3          	bne	a0,s3,ffffffffc0205670 <vprintfmt+0x40>
        width = precision = -1;
ffffffffc0205680:	5cfd                	li	s9,-1
ffffffffc0205682:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc0205684:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc0205688:	4b81                	li	s7,0
ffffffffc020568a:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020568c:	00044683          	lbu	a3,0(s0)
ffffffffc0205690:	00140c13          	addi	s8,s0,1
ffffffffc0205694:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0205698:	0ff5f593          	zext.b	a1,a1
ffffffffc020569c:	02bb6663          	bltu	s6,a1,ffffffffc02056c8 <vprintfmt+0x98>
ffffffffc02056a0:	058a                	slli	a1,a1,0x2
ffffffffc02056a2:	95d6                	add	a1,a1,s5
ffffffffc02056a4:	4198                	lw	a4,0(a1)
ffffffffc02056a6:	9756                	add	a4,a4,s5
ffffffffc02056a8:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02056aa:	70e6                	ld	ra,120(sp)
ffffffffc02056ac:	7446                	ld	s0,112(sp)
ffffffffc02056ae:	74a6                	ld	s1,104(sp)
ffffffffc02056b0:	7906                	ld	s2,96(sp)
ffffffffc02056b2:	69e6                	ld	s3,88(sp)
ffffffffc02056b4:	6a46                	ld	s4,80(sp)
ffffffffc02056b6:	6aa6                	ld	s5,72(sp)
ffffffffc02056b8:	6b06                	ld	s6,64(sp)
ffffffffc02056ba:	7be2                	ld	s7,56(sp)
ffffffffc02056bc:	7c42                	ld	s8,48(sp)
ffffffffc02056be:	7ca2                	ld	s9,40(sp)
ffffffffc02056c0:	7d02                	ld	s10,32(sp)
ffffffffc02056c2:	6de2                	ld	s11,24(sp)
ffffffffc02056c4:	6109                	addi	sp,sp,128
ffffffffc02056c6:	8082                	ret
            putch('%', putdat);
ffffffffc02056c8:	85ca                	mv	a1,s2
ffffffffc02056ca:	02500513          	li	a0,37
ffffffffc02056ce:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02056d0:	fff44783          	lbu	a5,-1(s0)
ffffffffc02056d4:	02500713          	li	a4,37
ffffffffc02056d8:	8c22                	mv	s8,s0
ffffffffc02056da:	f8e785e3          	beq	a5,a4,ffffffffc0205664 <vprintfmt+0x34>
ffffffffc02056de:	ffec4783          	lbu	a5,-2(s8)
ffffffffc02056e2:	1c7d                	addi	s8,s8,-1
ffffffffc02056e4:	fee79de3          	bne	a5,a4,ffffffffc02056de <vprintfmt+0xae>
ffffffffc02056e8:	bfb5                	j	ffffffffc0205664 <vprintfmt+0x34>
                ch = *fmt;
ffffffffc02056ea:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc02056ee:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc02056f0:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc02056f4:	fd06071b          	addiw	a4,a2,-48
ffffffffc02056f8:	24e56a63          	bltu	a0,a4,ffffffffc020594c <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc02056fc:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056fe:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc0205700:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc0205704:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0205708:	0197073b          	addw	a4,a4,s9
ffffffffc020570c:	0017171b          	slliw	a4,a4,0x1
ffffffffc0205710:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc0205712:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0205716:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0205718:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc020571c:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc0205720:	feb570e3          	bgeu	a0,a1,ffffffffc0205700 <vprintfmt+0xd0>
            if (width < 0)
ffffffffc0205724:	f60d54e3          	bgez	s10,ffffffffc020568c <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0205728:	8d66                	mv	s10,s9
ffffffffc020572a:	5cfd                	li	s9,-1
ffffffffc020572c:	b785                	j	ffffffffc020568c <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020572e:	8db6                	mv	s11,a3
ffffffffc0205730:	8462                	mv	s0,s8
ffffffffc0205732:	bfa9                	j	ffffffffc020568c <vprintfmt+0x5c>
ffffffffc0205734:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0205736:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0205738:	bf91                	j	ffffffffc020568c <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc020573a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020573c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205740:	00f74463          	blt	a4,a5,ffffffffc0205748 <vprintfmt+0x118>
    else if (lflag) {
ffffffffc0205744:	1a078763          	beqz	a5,ffffffffc02058f2 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0205748:	000a3603          	ld	a2,0(s4)
ffffffffc020574c:	46c1                	li	a3,16
ffffffffc020574e:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205750:	000d879b          	sext.w	a5,s11
ffffffffc0205754:	876a                	mv	a4,s10
ffffffffc0205756:	85ca                	mv	a1,s2
ffffffffc0205758:	8526                	mv	a0,s1
ffffffffc020575a:	e71ff0ef          	jal	ffffffffc02055ca <printnum>
            break;
ffffffffc020575e:	b719                	j	ffffffffc0205664 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0205760:	000a2503          	lw	a0,0(s4)
ffffffffc0205764:	85ca                	mv	a1,s2
ffffffffc0205766:	0a21                	addi	s4,s4,8
ffffffffc0205768:	9482                	jalr	s1
            break;
ffffffffc020576a:	bded                	j	ffffffffc0205664 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc020576c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020576e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205772:	00f74463          	blt	a4,a5,ffffffffc020577a <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0205776:	16078963          	beqz	a5,ffffffffc02058e8 <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc020577a:	000a3603          	ld	a2,0(s4)
ffffffffc020577e:	46a9                	li	a3,10
ffffffffc0205780:	8a2e                	mv	s4,a1
ffffffffc0205782:	b7f9                	j	ffffffffc0205750 <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc0205784:	85ca                	mv	a1,s2
ffffffffc0205786:	03000513          	li	a0,48
ffffffffc020578a:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc020578c:	85ca                	mv	a1,s2
ffffffffc020578e:	07800513          	li	a0,120
ffffffffc0205792:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205794:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc0205798:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020579a:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc020579c:	bf55                	j	ffffffffc0205750 <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc020579e:	85ca                	mv	a1,s2
ffffffffc02057a0:	02500513          	li	a0,37
ffffffffc02057a4:	9482                	jalr	s1
            break;
ffffffffc02057a6:	bd7d                	j	ffffffffc0205664 <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc02057a8:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02057ac:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc02057ae:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc02057b0:	bf95                	j	ffffffffc0205724 <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc02057b2:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02057b4:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02057b8:	00f74463          	blt	a4,a5,ffffffffc02057c0 <vprintfmt+0x190>
    else if (lflag) {
ffffffffc02057bc:	12078163          	beqz	a5,ffffffffc02058de <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc02057c0:	000a3603          	ld	a2,0(s4)
ffffffffc02057c4:	46a1                	li	a3,8
ffffffffc02057c6:	8a2e                	mv	s4,a1
ffffffffc02057c8:	b761                	j	ffffffffc0205750 <vprintfmt+0x120>
            if (width < 0)
ffffffffc02057ca:	876a                	mv	a4,s10
ffffffffc02057cc:	000d5363          	bgez	s10,ffffffffc02057d2 <vprintfmt+0x1a2>
ffffffffc02057d0:	4701                	li	a4,0
ffffffffc02057d2:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02057d6:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc02057d8:	bd55                	j	ffffffffc020568c <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc02057da:	000d841b          	sext.w	s0,s11
ffffffffc02057de:	fd340793          	addi	a5,s0,-45
ffffffffc02057e2:	00f037b3          	snez	a5,a5
ffffffffc02057e6:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02057ea:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc02057ee:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02057f0:	008a0793          	addi	a5,s4,8
ffffffffc02057f4:	e43e                	sd	a5,8(sp)
ffffffffc02057f6:	100d8c63          	beqz	s11,ffffffffc020590e <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc02057fa:	12071363          	bnez	a4,ffffffffc0205920 <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057fe:	000dc783          	lbu	a5,0(s11)
ffffffffc0205802:	0007851b          	sext.w	a0,a5
ffffffffc0205806:	c78d                	beqz	a5,ffffffffc0205830 <vprintfmt+0x200>
ffffffffc0205808:	0d85                	addi	s11,s11,1
ffffffffc020580a:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020580c:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205810:	000cc563          	bltz	s9,ffffffffc020581a <vprintfmt+0x1ea>
ffffffffc0205814:	3cfd                	addiw	s9,s9,-1
ffffffffc0205816:	008c8d63          	beq	s9,s0,ffffffffc0205830 <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020581a:	020b9663          	bnez	s7,ffffffffc0205846 <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc020581e:	85ca                	mv	a1,s2
ffffffffc0205820:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205822:	000dc783          	lbu	a5,0(s11)
ffffffffc0205826:	0d85                	addi	s11,s11,1
ffffffffc0205828:	3d7d                	addiw	s10,s10,-1
ffffffffc020582a:	0007851b          	sext.w	a0,a5
ffffffffc020582e:	f3ed                	bnez	a5,ffffffffc0205810 <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc0205830:	01a05963          	blez	s10,ffffffffc0205842 <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc0205834:	85ca                	mv	a1,s2
ffffffffc0205836:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc020583a:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc020583c:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc020583e:	fe0d1be3          	bnez	s10,ffffffffc0205834 <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205842:	6a22                	ld	s4,8(sp)
ffffffffc0205844:	b505                	j	ffffffffc0205664 <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205846:	3781                	addiw	a5,a5,-32
ffffffffc0205848:	fcfa7be3          	bgeu	s4,a5,ffffffffc020581e <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc020584c:	03f00513          	li	a0,63
ffffffffc0205850:	85ca                	mv	a1,s2
ffffffffc0205852:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205854:	000dc783          	lbu	a5,0(s11)
ffffffffc0205858:	0d85                	addi	s11,s11,1
ffffffffc020585a:	3d7d                	addiw	s10,s10,-1
ffffffffc020585c:	0007851b          	sext.w	a0,a5
ffffffffc0205860:	dbe1                	beqz	a5,ffffffffc0205830 <vprintfmt+0x200>
ffffffffc0205862:	fa0cd9e3          	bgez	s9,ffffffffc0205814 <vprintfmt+0x1e4>
ffffffffc0205866:	b7c5                	j	ffffffffc0205846 <vprintfmt+0x216>
            if (err < 0) {
ffffffffc0205868:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020586c:	4661                	li	a2,24
            err = va_arg(ap, int);
ffffffffc020586e:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0205870:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0205874:	8fb9                	xor	a5,a5,a4
ffffffffc0205876:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020587a:	02d64563          	blt	a2,a3,ffffffffc02058a4 <vprintfmt+0x274>
ffffffffc020587e:	00002797          	auipc	a5,0x2
ffffffffc0205882:	2e278793          	addi	a5,a5,738 # ffffffffc0207b60 <error_string>
ffffffffc0205886:	00369713          	slli	a4,a3,0x3
ffffffffc020588a:	97ba                	add	a5,a5,a4
ffffffffc020588c:	639c                	ld	a5,0(a5)
ffffffffc020588e:	cb99                	beqz	a5,ffffffffc02058a4 <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc0205890:	86be                	mv	a3,a5
ffffffffc0205892:	00000617          	auipc	a2,0x0
ffffffffc0205896:	20e60613          	addi	a2,a2,526 # ffffffffc0205aa0 <etext+0x2c>
ffffffffc020589a:	85ca                	mv	a1,s2
ffffffffc020589c:	8526                	mv	a0,s1
ffffffffc020589e:	0d8000ef          	jal	ffffffffc0205976 <printfmt>
ffffffffc02058a2:	b3c9                	j	ffffffffc0205664 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02058a4:	00002617          	auipc	a2,0x2
ffffffffc02058a8:	ea460613          	addi	a2,a2,-348 # ffffffffc0207748 <etext+0x1cd4>
ffffffffc02058ac:	85ca                	mv	a1,s2
ffffffffc02058ae:	8526                	mv	a0,s1
ffffffffc02058b0:	0c6000ef          	jal	ffffffffc0205976 <printfmt>
ffffffffc02058b4:	bb45                	j	ffffffffc0205664 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc02058b6:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02058b8:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc02058bc:	00f74363          	blt	a4,a5,ffffffffc02058c2 <vprintfmt+0x292>
    else if (lflag) {
ffffffffc02058c0:	cf81                	beqz	a5,ffffffffc02058d8 <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc02058c2:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02058c6:	02044b63          	bltz	s0,ffffffffc02058fc <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc02058ca:	8622                	mv	a2,s0
ffffffffc02058cc:	8a5e                	mv	s4,s7
ffffffffc02058ce:	46a9                	li	a3,10
ffffffffc02058d0:	b541                	j	ffffffffc0205750 <vprintfmt+0x120>
            lflag ++;
ffffffffc02058d2:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02058d4:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc02058d6:	bb5d                	j	ffffffffc020568c <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc02058d8:	000a2403          	lw	s0,0(s4)
ffffffffc02058dc:	b7ed                	j	ffffffffc02058c6 <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc02058de:	000a6603          	lwu	a2,0(s4)
ffffffffc02058e2:	46a1                	li	a3,8
ffffffffc02058e4:	8a2e                	mv	s4,a1
ffffffffc02058e6:	b5ad                	j	ffffffffc0205750 <vprintfmt+0x120>
ffffffffc02058e8:	000a6603          	lwu	a2,0(s4)
ffffffffc02058ec:	46a9                	li	a3,10
ffffffffc02058ee:	8a2e                	mv	s4,a1
ffffffffc02058f0:	b585                	j	ffffffffc0205750 <vprintfmt+0x120>
ffffffffc02058f2:	000a6603          	lwu	a2,0(s4)
ffffffffc02058f6:	46c1                	li	a3,16
ffffffffc02058f8:	8a2e                	mv	s4,a1
ffffffffc02058fa:	bd99                	j	ffffffffc0205750 <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc02058fc:	85ca                	mv	a1,s2
ffffffffc02058fe:	02d00513          	li	a0,45
ffffffffc0205902:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc0205904:	40800633          	neg	a2,s0
ffffffffc0205908:	8a5e                	mv	s4,s7
ffffffffc020590a:	46a9                	li	a3,10
ffffffffc020590c:	b591                	j	ffffffffc0205750 <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc020590e:	e329                	bnez	a4,ffffffffc0205950 <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205910:	02800793          	li	a5,40
ffffffffc0205914:	853e                	mv	a0,a5
ffffffffc0205916:	00002d97          	auipc	s11,0x2
ffffffffc020591a:	e2bd8d93          	addi	s11,s11,-469 # ffffffffc0207741 <etext+0x1ccd>
ffffffffc020591e:	b5f5                	j	ffffffffc020580a <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205920:	85e6                	mv	a1,s9
ffffffffc0205922:	856e                	mv	a0,s11
ffffffffc0205924:	08a000ef          	jal	ffffffffc02059ae <strnlen>
ffffffffc0205928:	40ad0d3b          	subw	s10,s10,a0
ffffffffc020592c:	01a05863          	blez	s10,ffffffffc020593c <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc0205930:	85ca                	mv	a1,s2
ffffffffc0205932:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205934:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc0205936:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205938:	fe0d1ce3          	bnez	s10,ffffffffc0205930 <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020593c:	000dc783          	lbu	a5,0(s11)
ffffffffc0205940:	0007851b          	sext.w	a0,a5
ffffffffc0205944:	ec0792e3          	bnez	a5,ffffffffc0205808 <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205948:	6a22                	ld	s4,8(sp)
ffffffffc020594a:	bb29                	j	ffffffffc0205664 <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020594c:	8462                	mv	s0,s8
ffffffffc020594e:	bbd9                	j	ffffffffc0205724 <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205950:	85e6                	mv	a1,s9
ffffffffc0205952:	00002517          	auipc	a0,0x2
ffffffffc0205956:	dee50513          	addi	a0,a0,-530 # ffffffffc0207740 <etext+0x1ccc>
ffffffffc020595a:	054000ef          	jal	ffffffffc02059ae <strnlen>
ffffffffc020595e:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205962:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0205966:	00002d97          	auipc	s11,0x2
ffffffffc020596a:	ddad8d93          	addi	s11,s11,-550 # ffffffffc0207740 <etext+0x1ccc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020596e:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205970:	fda040e3          	bgtz	s10,ffffffffc0205930 <vprintfmt+0x300>
ffffffffc0205974:	bd51                	j	ffffffffc0205808 <vprintfmt+0x1d8>

ffffffffc0205976 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205976:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0205978:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020597c:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020597e:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205980:	ec06                	sd	ra,24(sp)
ffffffffc0205982:	f83a                	sd	a4,48(sp)
ffffffffc0205984:	fc3e                	sd	a5,56(sp)
ffffffffc0205986:	e0c2                	sd	a6,64(sp)
ffffffffc0205988:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc020598a:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020598c:	ca5ff0ef          	jal	ffffffffc0205630 <vprintfmt>
}
ffffffffc0205990:	60e2                	ld	ra,24(sp)
ffffffffc0205992:	6161                	addi	sp,sp,80
ffffffffc0205994:	8082                	ret

ffffffffc0205996 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0205996:	00054783          	lbu	a5,0(a0)
ffffffffc020599a:	cb81                	beqz	a5,ffffffffc02059aa <strlen+0x14>
    size_t cnt = 0;
ffffffffc020599c:	4781                	li	a5,0
        cnt ++;
ffffffffc020599e:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc02059a0:	00f50733          	add	a4,a0,a5
ffffffffc02059a4:	00074703          	lbu	a4,0(a4)
ffffffffc02059a8:	fb7d                	bnez	a4,ffffffffc020599e <strlen+0x8>
    }
    return cnt;
}
ffffffffc02059aa:	853e                	mv	a0,a5
ffffffffc02059ac:	8082                	ret

ffffffffc02059ae <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02059ae:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02059b0:	e589                	bnez	a1,ffffffffc02059ba <strnlen+0xc>
ffffffffc02059b2:	a811                	j	ffffffffc02059c6 <strnlen+0x18>
        cnt ++;
ffffffffc02059b4:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02059b6:	00f58863          	beq	a1,a5,ffffffffc02059c6 <strnlen+0x18>
ffffffffc02059ba:	00f50733          	add	a4,a0,a5
ffffffffc02059be:	00074703          	lbu	a4,0(a4)
ffffffffc02059c2:	fb6d                	bnez	a4,ffffffffc02059b4 <strnlen+0x6>
ffffffffc02059c4:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02059c6:	852e                	mv	a0,a1
ffffffffc02059c8:	8082                	ret

ffffffffc02059ca <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc02059ca:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc02059cc:	0005c703          	lbu	a4,0(a1)
ffffffffc02059d0:	0585                	addi	a1,a1,1
ffffffffc02059d2:	0785                	addi	a5,a5,1
ffffffffc02059d4:	fee78fa3          	sb	a4,-1(a5)
ffffffffc02059d8:	fb75                	bnez	a4,ffffffffc02059cc <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc02059da:	8082                	ret

ffffffffc02059dc <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02059dc:	00054783          	lbu	a5,0(a0)
ffffffffc02059e0:	e791                	bnez	a5,ffffffffc02059ec <strcmp+0x10>
ffffffffc02059e2:	a01d                	j	ffffffffc0205a08 <strcmp+0x2c>
ffffffffc02059e4:	00054783          	lbu	a5,0(a0)
ffffffffc02059e8:	cb99                	beqz	a5,ffffffffc02059fe <strcmp+0x22>
ffffffffc02059ea:	0585                	addi	a1,a1,1
ffffffffc02059ec:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc02059f0:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02059f2:	fef709e3          	beq	a4,a5,ffffffffc02059e4 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02059f6:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02059fa:	9d19                	subw	a0,a0,a4
ffffffffc02059fc:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02059fe:	0015c703          	lbu	a4,1(a1)
ffffffffc0205a02:	4501                	li	a0,0
}
ffffffffc0205a04:	9d19                	subw	a0,a0,a4
ffffffffc0205a06:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205a08:	0005c703          	lbu	a4,0(a1)
ffffffffc0205a0c:	4501                	li	a0,0
ffffffffc0205a0e:	b7f5                	j	ffffffffc02059fa <strcmp+0x1e>

ffffffffc0205a10 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205a10:	ce01                	beqz	a2,ffffffffc0205a28 <strncmp+0x18>
ffffffffc0205a12:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0205a16:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205a18:	cb91                	beqz	a5,ffffffffc0205a2c <strncmp+0x1c>
ffffffffc0205a1a:	0005c703          	lbu	a4,0(a1)
ffffffffc0205a1e:	00f71763          	bne	a4,a5,ffffffffc0205a2c <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc0205a22:	0505                	addi	a0,a0,1
ffffffffc0205a24:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205a26:	f675                	bnez	a2,ffffffffc0205a12 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205a28:	4501                	li	a0,0
ffffffffc0205a2a:	8082                	ret
ffffffffc0205a2c:	00054503          	lbu	a0,0(a0)
ffffffffc0205a30:	0005c783          	lbu	a5,0(a1)
ffffffffc0205a34:	9d1d                	subw	a0,a0,a5
}
ffffffffc0205a36:	8082                	ret

ffffffffc0205a38 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0205a38:	a021                	j	ffffffffc0205a40 <strchr+0x8>
        if (*s == c) {
ffffffffc0205a3a:	00f58763          	beq	a1,a5,ffffffffc0205a48 <strchr+0x10>
            return (char *)s;
        }
        s ++;
ffffffffc0205a3e:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0205a40:	00054783          	lbu	a5,0(a0)
ffffffffc0205a44:	fbfd                	bnez	a5,ffffffffc0205a3a <strchr+0x2>
    }
    return NULL;
ffffffffc0205a46:	4501                	li	a0,0
}
ffffffffc0205a48:	8082                	ret

ffffffffc0205a4a <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0205a4a:	ca01                	beqz	a2,ffffffffc0205a5a <memset+0x10>
ffffffffc0205a4c:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0205a4e:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0205a50:	0785                	addi	a5,a5,1
ffffffffc0205a52:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0205a56:	fef61de3          	bne	a2,a5,ffffffffc0205a50 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0205a5a:	8082                	ret

ffffffffc0205a5c <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0205a5c:	ca19                	beqz	a2,ffffffffc0205a72 <memcpy+0x16>
ffffffffc0205a5e:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0205a60:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0205a62:	0005c703          	lbu	a4,0(a1)
ffffffffc0205a66:	0585                	addi	a1,a1,1
ffffffffc0205a68:	0785                	addi	a5,a5,1
ffffffffc0205a6a:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0205a6e:	feb61ae3          	bne	a2,a1,ffffffffc0205a62 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0205a72:	8082                	ret
