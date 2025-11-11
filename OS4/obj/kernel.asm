
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00009297          	auipc	t0,0x9
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0209000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00009297          	auipc	t0,0x9
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0209008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02082b7          	lui	t0,0xc0208
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
ffffffffc020003c:	c0208137          	lui	sp,0xc0208

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
ffffffffc020004a:	00009517          	auipc	a0,0x9
ffffffffc020004e:	fe650513          	addi	a0,a0,-26 # ffffffffc0209030 <buf>
ffffffffc0200052:	0000d617          	auipc	a2,0xd
ffffffffc0200056:	4a660613          	addi	a2,a2,1190 # ffffffffc020d4f8 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc0207ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	599030ef          	jal	ffffffffc0203dfa <memset>
    dtb_init();
ffffffffc0200066:	4c2000ef          	jal	ffffffffc0200528 <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	44c000ef          	jal	ffffffffc02004b6 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00004597          	auipc	a1,0x4
ffffffffc0200072:	dda58593          	addi	a1,a1,-550 # ffffffffc0203e48 <etext>
ffffffffc0200076:	00004517          	auipc	a0,0x4
ffffffffc020007a:	df250513          	addi	a0,a0,-526 # ffffffffc0203e68 <etext+0x20>
ffffffffc020007e:	116000ef          	jal	ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	158000ef          	jal	ffffffffc02001da <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	0b4020ef          	jal	ffffffffc020213a <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	7f0000ef          	jal	ffffffffc020087a <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	7ee000ef          	jal	ffffffffc020087c <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	625020ef          	jal	ffffffffc0202eb6 <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	52c030ef          	jal	ffffffffc02035c2 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	3ca000ef          	jal	ffffffffc0200464 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	7d0000ef          	jal	ffffffffc020086e <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	778030ef          	jal	ffffffffc020381a <cpu_idle>

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
ffffffffc02000b6:	00004517          	auipc	a0,0x4
ffffffffc02000ba:	dba50513          	addi	a0,a0,-582 # ffffffffc0203e70 <etext+0x28>
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
ffffffffc02000c6:	00009997          	auipc	s3,0x9
ffffffffc02000ca:	f6a98993          	addi	s3,s3,-150 # ffffffffc0209030 <buf>
        c = getchar();
ffffffffc02000ce:	0fc000ef          	jal	ffffffffc02001ca <getchar>
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
ffffffffc02000fc:	0ce000ef          	jal	ffffffffc02001ca <getchar>
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
ffffffffc0200140:	00009517          	auipc	a0,0x9
ffffffffc0200144:	ef050513          	addi	a0,a0,-272 # ffffffffc0209030 <buf>
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
ffffffffc0200162:	356000ef          	jal	ffffffffc02004b8 <cons_putc>
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
ffffffffc0200188:	059030ef          	jal	ffffffffc02039e0 <vprintfmt>
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
ffffffffc02001bc:	025030ef          	jal	ffffffffc02039e0 <vprintfmt>
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
ffffffffc02001c8:	acc5                	j	ffffffffc02004b8 <cons_putc>

ffffffffc02001ca <getchar>:
}

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc02001ca:	1141                	addi	sp,sp,-16
ffffffffc02001cc:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc02001ce:	31e000ef          	jal	ffffffffc02004ec <cons_getc>
ffffffffc02001d2:	dd75                	beqz	a0,ffffffffc02001ce <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc02001d4:	60a2                	ld	ra,8(sp)
ffffffffc02001d6:	0141                	addi	sp,sp,16
ffffffffc02001d8:	8082                	ret

ffffffffc02001da <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc02001da:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc02001dc:	00004517          	auipc	a0,0x4
ffffffffc02001e0:	c9c50513          	addi	a0,a0,-868 # ffffffffc0203e78 <etext+0x30>
{
ffffffffc02001e4:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02001e6:	fafff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc02001ea:	00000597          	auipc	a1,0x0
ffffffffc02001ee:	e6058593          	addi	a1,a1,-416 # ffffffffc020004a <kern_init>
ffffffffc02001f2:	00004517          	auipc	a0,0x4
ffffffffc02001f6:	ca650513          	addi	a0,a0,-858 # ffffffffc0203e98 <etext+0x50>
ffffffffc02001fa:	f9bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc02001fe:	00004597          	auipc	a1,0x4
ffffffffc0200202:	c4a58593          	addi	a1,a1,-950 # ffffffffc0203e48 <etext>
ffffffffc0200206:	00004517          	auipc	a0,0x4
ffffffffc020020a:	cb250513          	addi	a0,a0,-846 # ffffffffc0203eb8 <etext+0x70>
ffffffffc020020e:	f87ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200212:	00009597          	auipc	a1,0x9
ffffffffc0200216:	e1e58593          	addi	a1,a1,-482 # ffffffffc0209030 <buf>
ffffffffc020021a:	00004517          	auipc	a0,0x4
ffffffffc020021e:	cbe50513          	addi	a0,a0,-834 # ffffffffc0203ed8 <etext+0x90>
ffffffffc0200222:	f73ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200226:	0000d597          	auipc	a1,0xd
ffffffffc020022a:	2d258593          	addi	a1,a1,722 # ffffffffc020d4f8 <end>
ffffffffc020022e:	00004517          	auipc	a0,0x4
ffffffffc0200232:	cca50513          	addi	a0,a0,-822 # ffffffffc0203ef8 <etext+0xb0>
ffffffffc0200236:	f5fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020023a:	00000717          	auipc	a4,0x0
ffffffffc020023e:	e1070713          	addi	a4,a4,-496 # ffffffffc020004a <kern_init>
ffffffffc0200242:	0000d797          	auipc	a5,0xd
ffffffffc0200246:	6b578793          	addi	a5,a5,1717 # ffffffffc020d8f7 <end+0x3ff>
ffffffffc020024a:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020024c:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200250:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200252:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200256:	95be                	add	a1,a1,a5
ffffffffc0200258:	85a9                	srai	a1,a1,0xa
ffffffffc020025a:	00004517          	auipc	a0,0x4
ffffffffc020025e:	cbe50513          	addi	a0,a0,-834 # ffffffffc0203f18 <etext+0xd0>
}
ffffffffc0200262:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200264:	bf05                	j	ffffffffc0200194 <cprintf>

ffffffffc0200266 <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc0200266:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc0200268:	00004617          	auipc	a2,0x4
ffffffffc020026c:	ce060613          	addi	a2,a2,-800 # ffffffffc0203f48 <etext+0x100>
ffffffffc0200270:	04900593          	li	a1,73
ffffffffc0200274:	00004517          	auipc	a0,0x4
ffffffffc0200278:	cec50513          	addi	a0,a0,-788 # ffffffffc0203f60 <etext+0x118>
{
ffffffffc020027c:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc020027e:	188000ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0200282 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200282:	1101                	addi	sp,sp,-32
ffffffffc0200284:	e822                	sd	s0,16(sp)
ffffffffc0200286:	e426                	sd	s1,8(sp)
ffffffffc0200288:	ec06                	sd	ra,24(sp)
ffffffffc020028a:	00005417          	auipc	s0,0x5
ffffffffc020028e:	39e40413          	addi	s0,s0,926 # ffffffffc0205628 <commands>
ffffffffc0200292:	00005497          	auipc	s1,0x5
ffffffffc0200296:	3de48493          	addi	s1,s1,990 # ffffffffc0205670 <commands+0x48>
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020029a:	6410                	ld	a2,8(s0)
ffffffffc020029c:	600c                	ld	a1,0(s0)
ffffffffc020029e:	00004517          	auipc	a0,0x4
ffffffffc02002a2:	cda50513          	addi	a0,a0,-806 # ffffffffc0203f78 <etext+0x130>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002a6:	0461                	addi	s0,s0,24
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002a8:	eedff0ef          	jal	ffffffffc0200194 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002ac:	fe9417e3          	bne	s0,s1,ffffffffc020029a <mon_help+0x18>
    }
    return 0;
}
ffffffffc02002b0:	60e2                	ld	ra,24(sp)
ffffffffc02002b2:	6442                	ld	s0,16(sp)
ffffffffc02002b4:	64a2                	ld	s1,8(sp)
ffffffffc02002b6:	4501                	li	a0,0
ffffffffc02002b8:	6105                	addi	sp,sp,32
ffffffffc02002ba:	8082                	ret

ffffffffc02002bc <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002bc:	1141                	addi	sp,sp,-16
ffffffffc02002be:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02002c0:	f1bff0ef          	jal	ffffffffc02001da <print_kerninfo>
    return 0;
}
ffffffffc02002c4:	60a2                	ld	ra,8(sp)
ffffffffc02002c6:	4501                	li	a0,0
ffffffffc02002c8:	0141                	addi	sp,sp,16
ffffffffc02002ca:	8082                	ret

ffffffffc02002cc <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002cc:	1141                	addi	sp,sp,-16
ffffffffc02002ce:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02002d0:	f97ff0ef          	jal	ffffffffc0200266 <print_stackframe>
    return 0;
}
ffffffffc02002d4:	60a2                	ld	ra,8(sp)
ffffffffc02002d6:	4501                	li	a0,0
ffffffffc02002d8:	0141                	addi	sp,sp,16
ffffffffc02002da:	8082                	ret

ffffffffc02002dc <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc02002dc:	7131                	addi	sp,sp,-192
ffffffffc02002de:	e952                	sd	s4,144(sp)
ffffffffc02002e0:	8a2a                	mv	s4,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002e2:	00004517          	auipc	a0,0x4
ffffffffc02002e6:	ca650513          	addi	a0,a0,-858 # ffffffffc0203f88 <etext+0x140>
kmonitor(struct trapframe *tf) {
ffffffffc02002ea:	fd06                	sd	ra,184(sp)
ffffffffc02002ec:	f922                	sd	s0,176(sp)
ffffffffc02002ee:	f526                	sd	s1,168(sp)
ffffffffc02002f0:	f14a                	sd	s2,160(sp)
ffffffffc02002f2:	e556                	sd	s5,136(sp)
ffffffffc02002f4:	e15a                	sd	s6,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002f6:	e9fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc02002fa:	00004517          	auipc	a0,0x4
ffffffffc02002fe:	cb650513          	addi	a0,a0,-842 # ffffffffc0203fb0 <etext+0x168>
ffffffffc0200302:	e93ff0ef          	jal	ffffffffc0200194 <cprintf>
    if (tf != NULL) {
ffffffffc0200306:	000a0563          	beqz	s4,ffffffffc0200310 <kmonitor+0x34>
        print_trapframe(tf);
ffffffffc020030a:	8552                	mv	a0,s4
ffffffffc020030c:	768000ef          	jal	ffffffffc0200a74 <print_trapframe>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200310:	4501                	li	a0,0
ffffffffc0200312:	4581                	li	a1,0
ffffffffc0200314:	4601                	li	a2,0
ffffffffc0200316:	48a1                	li	a7,8
ffffffffc0200318:	00000073          	ecall
ffffffffc020031c:	00005a97          	auipc	s5,0x5
ffffffffc0200320:	30ca8a93          	addi	s5,s5,780 # ffffffffc0205628 <commands>
        if (argc == MAXARGS - 1) {
ffffffffc0200324:	493d                	li	s2,15
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200326:	00004517          	auipc	a0,0x4
ffffffffc020032a:	cb250513          	addi	a0,a0,-846 # ffffffffc0203fd8 <etext+0x190>
ffffffffc020032e:	d79ff0ef          	jal	ffffffffc02000a6 <readline>
ffffffffc0200332:	842a                	mv	s0,a0
ffffffffc0200334:	d96d                	beqz	a0,ffffffffc0200326 <kmonitor+0x4a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200336:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc020033a:	4481                	li	s1,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020033c:	e99d                	bnez	a1,ffffffffc0200372 <kmonitor+0x96>
    int argc = 0;
ffffffffc020033e:	8b26                	mv	s6,s1
    if (argc == 0) {
ffffffffc0200340:	fe0b03e3          	beqz	s6,ffffffffc0200326 <kmonitor+0x4a>
ffffffffc0200344:	00005497          	auipc	s1,0x5
ffffffffc0200348:	2e448493          	addi	s1,s1,740 # ffffffffc0205628 <commands>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020034c:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020034e:	6582                	ld	a1,0(sp)
ffffffffc0200350:	6088                	ld	a0,0(s1)
ffffffffc0200352:	23b030ef          	jal	ffffffffc0203d8c <strcmp>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200356:	478d                	li	a5,3
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200358:	c149                	beqz	a0,ffffffffc02003da <kmonitor+0xfe>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020035a:	2405                	addiw	s0,s0,1
ffffffffc020035c:	04e1                	addi	s1,s1,24
ffffffffc020035e:	fef418e3          	bne	s0,a5,ffffffffc020034e <kmonitor+0x72>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200362:	6582                	ld	a1,0(sp)
ffffffffc0200364:	00004517          	auipc	a0,0x4
ffffffffc0200368:	ca450513          	addi	a0,a0,-860 # ffffffffc0204008 <etext+0x1c0>
ffffffffc020036c:	e29ff0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
ffffffffc0200370:	bf5d                	j	ffffffffc0200326 <kmonitor+0x4a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200372:	00004517          	auipc	a0,0x4
ffffffffc0200376:	c6e50513          	addi	a0,a0,-914 # ffffffffc0203fe0 <etext+0x198>
ffffffffc020037a:	26f030ef          	jal	ffffffffc0203de8 <strchr>
ffffffffc020037e:	c901                	beqz	a0,ffffffffc020038e <kmonitor+0xb2>
ffffffffc0200380:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200384:	00040023          	sb	zero,0(s0)
ffffffffc0200388:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020038a:	d9d5                	beqz	a1,ffffffffc020033e <kmonitor+0x62>
ffffffffc020038c:	b7dd                	j	ffffffffc0200372 <kmonitor+0x96>
        if (*buf == '\0') {
ffffffffc020038e:	00044783          	lbu	a5,0(s0)
ffffffffc0200392:	d7d5                	beqz	a5,ffffffffc020033e <kmonitor+0x62>
        if (argc == MAXARGS - 1) {
ffffffffc0200394:	03248b63          	beq	s1,s2,ffffffffc02003ca <kmonitor+0xee>
        argv[argc ++] = buf;
ffffffffc0200398:	00349793          	slli	a5,s1,0x3
ffffffffc020039c:	978a                	add	a5,a5,sp
ffffffffc020039e:	e380                	sd	s0,0(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003a0:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc02003a4:	2485                	addiw	s1,s1,1
ffffffffc02003a6:	8b26                	mv	s6,s1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003a8:	e591                	bnez	a1,ffffffffc02003b4 <kmonitor+0xd8>
ffffffffc02003aa:	bf59                	j	ffffffffc0200340 <kmonitor+0x64>
ffffffffc02003ac:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc02003b0:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003b2:	d5d1                	beqz	a1,ffffffffc020033e <kmonitor+0x62>
ffffffffc02003b4:	00004517          	auipc	a0,0x4
ffffffffc02003b8:	c2c50513          	addi	a0,a0,-980 # ffffffffc0203fe0 <etext+0x198>
ffffffffc02003bc:	22d030ef          	jal	ffffffffc0203de8 <strchr>
ffffffffc02003c0:	d575                	beqz	a0,ffffffffc02003ac <kmonitor+0xd0>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003c2:	00044583          	lbu	a1,0(s0)
ffffffffc02003c6:	dda5                	beqz	a1,ffffffffc020033e <kmonitor+0x62>
ffffffffc02003c8:	b76d                	j	ffffffffc0200372 <kmonitor+0x96>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003ca:	45c1                	li	a1,16
ffffffffc02003cc:	00004517          	auipc	a0,0x4
ffffffffc02003d0:	c1c50513          	addi	a0,a0,-996 # ffffffffc0203fe8 <etext+0x1a0>
ffffffffc02003d4:	dc1ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02003d8:	b7c1                	j	ffffffffc0200398 <kmonitor+0xbc>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003da:	00141793          	slli	a5,s0,0x1
ffffffffc02003de:	97a2                	add	a5,a5,s0
ffffffffc02003e0:	078e                	slli	a5,a5,0x3
ffffffffc02003e2:	97d6                	add	a5,a5,s5
ffffffffc02003e4:	6b9c                	ld	a5,16(a5)
ffffffffc02003e6:	fffb051b          	addiw	a0,s6,-1
ffffffffc02003ea:	8652                	mv	a2,s4
ffffffffc02003ec:	002c                	addi	a1,sp,8
ffffffffc02003ee:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc02003f0:	f2055be3          	bgez	a0,ffffffffc0200326 <kmonitor+0x4a>
}
ffffffffc02003f4:	70ea                	ld	ra,184(sp)
ffffffffc02003f6:	744a                	ld	s0,176(sp)
ffffffffc02003f8:	74aa                	ld	s1,168(sp)
ffffffffc02003fa:	790a                	ld	s2,160(sp)
ffffffffc02003fc:	6a4a                	ld	s4,144(sp)
ffffffffc02003fe:	6aaa                	ld	s5,136(sp)
ffffffffc0200400:	6b0a                	ld	s6,128(sp)
ffffffffc0200402:	6129                	addi	sp,sp,192
ffffffffc0200404:	8082                	ret

ffffffffc0200406 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200406:	0000d317          	auipc	t1,0xd
ffffffffc020040a:	06232303          	lw	t1,98(t1) # ffffffffc020d468 <is_panic>
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc020040e:	715d                	addi	sp,sp,-80
ffffffffc0200410:	ec06                	sd	ra,24(sp)
ffffffffc0200412:	f436                	sd	a3,40(sp)
ffffffffc0200414:	f83a                	sd	a4,48(sp)
ffffffffc0200416:	fc3e                	sd	a5,56(sp)
ffffffffc0200418:	e0c2                	sd	a6,64(sp)
ffffffffc020041a:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc020041c:	02031e63          	bnez	t1,ffffffffc0200458 <__panic+0x52>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200420:	4705                	li	a4,1

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200422:	103c                	addi	a5,sp,40
ffffffffc0200424:	e822                	sd	s0,16(sp)
ffffffffc0200426:	8432                	mv	s0,a2
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200428:	862e                	mv	a2,a1
ffffffffc020042a:	85aa                	mv	a1,a0
ffffffffc020042c:	00004517          	auipc	a0,0x4
ffffffffc0200430:	c8450513          	addi	a0,a0,-892 # ffffffffc02040b0 <etext+0x268>
    is_panic = 1;
ffffffffc0200434:	0000d697          	auipc	a3,0xd
ffffffffc0200438:	02e6aa23          	sw	a4,52(a3) # ffffffffc020d468 <is_panic>
    va_start(ap, fmt);
ffffffffc020043c:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020043e:	d57ff0ef          	jal	ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200442:	65a2                	ld	a1,8(sp)
ffffffffc0200444:	8522                	mv	a0,s0
ffffffffc0200446:	d2fff0ef          	jal	ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc020044a:	00004517          	auipc	a0,0x4
ffffffffc020044e:	c8650513          	addi	a0,a0,-890 # ffffffffc02040d0 <etext+0x288>
ffffffffc0200452:	d43ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200456:	6442                	ld	s0,16(sp)
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc0200458:	41c000ef          	jal	ffffffffc0200874 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc020045c:	4501                	li	a0,0
ffffffffc020045e:	e7fff0ef          	jal	ffffffffc02002dc <kmonitor>
    while (1) {
ffffffffc0200462:	bfed                	j	ffffffffc020045c <__panic+0x56>

ffffffffc0200464 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc0200464:	67e1                	lui	a5,0x18
ffffffffc0200466:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020046a:	0000d717          	auipc	a4,0xd
ffffffffc020046e:	00f73323          	sd	a5,6(a4) # ffffffffc020d470 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200472:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200476:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200478:	953e                	add	a0,a0,a5
ffffffffc020047a:	4601                	li	a2,0
ffffffffc020047c:	4881                	li	a7,0
ffffffffc020047e:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200482:	02000793          	li	a5,32
ffffffffc0200486:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc020048a:	00004517          	auipc	a0,0x4
ffffffffc020048e:	c4e50513          	addi	a0,a0,-946 # ffffffffc02040d8 <etext+0x290>
    ticks = 0;
ffffffffc0200492:	0000d797          	auipc	a5,0xd
ffffffffc0200496:	fe07b323          	sd	zero,-26(a5) # ffffffffc020d478 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020049a:	b9ed                	j	ffffffffc0200194 <cprintf>

ffffffffc020049c <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020049c:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02004a0:	0000d797          	auipc	a5,0xd
ffffffffc02004a4:	fd07b783          	ld	a5,-48(a5) # ffffffffc020d470 <timebase>
ffffffffc02004a8:	4581                	li	a1,0
ffffffffc02004aa:	4601                	li	a2,0
ffffffffc02004ac:	953e                	add	a0,a0,a5
ffffffffc02004ae:	4881                	li	a7,0
ffffffffc02004b0:	00000073          	ecall
ffffffffc02004b4:	8082                	ret

ffffffffc02004b6 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc02004b6:	8082                	ret

ffffffffc02004b8 <cons_putc>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02004b8:	100027f3          	csrr	a5,sstatus
ffffffffc02004bc:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc02004be:	0ff57513          	zext.b	a0,a0
ffffffffc02004c2:	e799                	bnez	a5,ffffffffc02004d0 <cons_putc+0x18>
ffffffffc02004c4:	4581                	li	a1,0
ffffffffc02004c6:	4601                	li	a2,0
ffffffffc02004c8:	4885                	li	a7,1
ffffffffc02004ca:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc02004ce:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02004d0:	1101                	addi	sp,sp,-32
ffffffffc02004d2:	ec06                	sd	ra,24(sp)
ffffffffc02004d4:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02004d6:	39e000ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02004da:	6522                	ld	a0,8(sp)
ffffffffc02004dc:	4581                	li	a1,0
ffffffffc02004de:	4601                	li	a2,0
ffffffffc02004e0:	4885                	li	a7,1
ffffffffc02004e2:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02004e6:	60e2                	ld	ra,24(sp)
ffffffffc02004e8:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02004ea:	a651                	j	ffffffffc020086e <intr_enable>

ffffffffc02004ec <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02004ec:	100027f3          	csrr	a5,sstatus
ffffffffc02004f0:	8b89                	andi	a5,a5,2
ffffffffc02004f2:	eb89                	bnez	a5,ffffffffc0200504 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02004f4:	4501                	li	a0,0
ffffffffc02004f6:	4581                	li	a1,0
ffffffffc02004f8:	4601                	li	a2,0
ffffffffc02004fa:	4889                	li	a7,2
ffffffffc02004fc:	00000073          	ecall
ffffffffc0200500:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc0200502:	8082                	ret
int cons_getc(void) {
ffffffffc0200504:	1101                	addi	sp,sp,-32
ffffffffc0200506:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0200508:	36c000ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc020050c:	4501                	li	a0,0
ffffffffc020050e:	4581                	li	a1,0
ffffffffc0200510:	4601                	li	a2,0
ffffffffc0200512:	4889                	li	a7,2
ffffffffc0200514:	00000073          	ecall
ffffffffc0200518:	2501                	sext.w	a0,a0
ffffffffc020051a:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc020051c:	352000ef          	jal	ffffffffc020086e <intr_enable>
}
ffffffffc0200520:	60e2                	ld	ra,24(sp)
ffffffffc0200522:	6522                	ld	a0,8(sp)
ffffffffc0200524:	6105                	addi	sp,sp,32
ffffffffc0200526:	8082                	ret

ffffffffc0200528 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200528:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc020052a:	00004517          	auipc	a0,0x4
ffffffffc020052e:	bce50513          	addi	a0,a0,-1074 # ffffffffc02040f8 <etext+0x2b0>
void dtb_init(void) {
ffffffffc0200532:	f406                	sd	ra,40(sp)
ffffffffc0200534:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc0200536:	c5fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc020053a:	00009597          	auipc	a1,0x9
ffffffffc020053e:	ac65b583          	ld	a1,-1338(a1) # ffffffffc0209000 <boot_hartid>
ffffffffc0200542:	00004517          	auipc	a0,0x4
ffffffffc0200546:	bc650513          	addi	a0,a0,-1082 # ffffffffc0204108 <etext+0x2c0>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020054a:	00009417          	auipc	s0,0x9
ffffffffc020054e:	abe40413          	addi	s0,s0,-1346 # ffffffffc0209008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200552:	c43ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200556:	600c                	ld	a1,0(s0)
ffffffffc0200558:	00004517          	auipc	a0,0x4
ffffffffc020055c:	bc050513          	addi	a0,a0,-1088 # ffffffffc0204118 <etext+0x2d0>
ffffffffc0200560:	c35ff0ef          	jal	ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200564:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200566:	00004517          	auipc	a0,0x4
ffffffffc020056a:	bca50513          	addi	a0,a0,-1078 # ffffffffc0204130 <etext+0x2e8>
    if (boot_dtb == 0) {
ffffffffc020056e:	10070163          	beqz	a4,ffffffffc0200670 <dtb_init+0x148>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200572:	57f5                	li	a5,-3
ffffffffc0200574:	07fa                	slli	a5,a5,0x1e
ffffffffc0200576:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200578:	431c                	lw	a5,0(a4)
    if (magic != 0xd00dfeed) {
ffffffffc020057a:	d00e06b7          	lui	a3,0xd00e0
ffffffffc020057e:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfed29f5>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200582:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200586:	0187961b          	slliw	a2,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020058a:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020058e:	0ff5f593          	zext.b	a1,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200592:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200596:	05c2                	slli	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200598:	8e49                	or	a2,a2,a0
ffffffffc020059a:	0ff7f793          	zext.b	a5,a5
ffffffffc020059e:	8dd1                	or	a1,a1,a2
ffffffffc02005a0:	07a2                	slli	a5,a5,0x8
ffffffffc02005a2:	8ddd                	or	a1,a1,a5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005a4:	00ff0837          	lui	a6,0xff0
    if (magic != 0xd00dfeed) {
ffffffffc02005a8:	0cd59863          	bne	a1,a3,ffffffffc0200678 <dtb_init+0x150>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02005ac:	4710                	lw	a2,8(a4)
ffffffffc02005ae:	4754                	lw	a3,12(a4)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02005b0:	e84a                	sd	s2,16(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005b2:	0086541b          	srliw	s0,a2,0x8
ffffffffc02005b6:	0086d79b          	srliw	a5,a3,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ba:	01865e1b          	srliw	t3,a2,0x18
ffffffffc02005be:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005c2:	0186151b          	slliw	a0,a2,0x18
ffffffffc02005c6:	0186959b          	slliw	a1,a3,0x18
ffffffffc02005ca:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ce:	0106561b          	srliw	a2,a2,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005d2:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005d6:	0106d69b          	srliw	a3,a3,0x10
ffffffffc02005da:	01c56533          	or	a0,a0,t3
ffffffffc02005de:	0115e5b3          	or	a1,a1,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005e2:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005e6:	0ff67613          	zext.b	a2,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ea:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ee:	0ff6f693          	zext.b	a3,a3
ffffffffc02005f2:	8c49                	or	s0,s0,a0
ffffffffc02005f4:	0622                	slli	a2,a2,0x8
ffffffffc02005f6:	8fcd                	or	a5,a5,a1
ffffffffc02005f8:	06a2                	slli	a3,a3,0x8
ffffffffc02005fa:	8c51                	or	s0,s0,a2
ffffffffc02005fc:	8fd5                	or	a5,a5,a3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02005fe:	1402                	slli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200600:	1782                	slli	a5,a5,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200602:	9001                	srli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200604:	9381                	srli	a5,a5,0x20
ffffffffc0200606:	ec26                	sd	s1,24(sp)
    int in_memory_node = 0;
ffffffffc0200608:	4301                	li	t1,0
        switch (token) {
ffffffffc020060a:	488d                	li	a7,3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020060c:	943a                	add	s0,s0,a4
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020060e:	00e78933          	add	s2,a5,a4
        switch (token) {
ffffffffc0200612:	4e05                	li	t3,1
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200614:	4018                	lw	a4,0(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200616:	0087579b          	srliw	a5,a4,0x8
ffffffffc020061a:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020061e:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200622:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200626:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020062a:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020062e:	8ed1                	or	a3,a3,a2
ffffffffc0200630:	0ff77713          	zext.b	a4,a4
ffffffffc0200634:	8fd5                	or	a5,a5,a3
ffffffffc0200636:	0722                	slli	a4,a4,0x8
ffffffffc0200638:	8fd9                	or	a5,a5,a4
        switch (token) {
ffffffffc020063a:	05178763          	beq	a5,a7,ffffffffc0200688 <dtb_init+0x160>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020063e:	0411                	addi	s0,s0,4
        switch (token) {
ffffffffc0200640:	00f8e963          	bltu	a7,a5,ffffffffc0200652 <dtb_init+0x12a>
ffffffffc0200644:	07c78d63          	beq	a5,t3,ffffffffc02006be <dtb_init+0x196>
ffffffffc0200648:	4709                	li	a4,2
ffffffffc020064a:	00e79763          	bne	a5,a4,ffffffffc0200658 <dtb_init+0x130>
ffffffffc020064e:	4301                	li	t1,0
ffffffffc0200650:	b7d1                	j	ffffffffc0200614 <dtb_init+0xec>
ffffffffc0200652:	4711                	li	a4,4
ffffffffc0200654:	fce780e3          	beq	a5,a4,ffffffffc0200614 <dtb_init+0xec>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200658:	00004517          	auipc	a0,0x4
ffffffffc020065c:	ba050513          	addi	a0,a0,-1120 # ffffffffc02041f8 <etext+0x3b0>
ffffffffc0200660:	b35ff0ef          	jal	ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200664:	64e2                	ld	s1,24(sp)
ffffffffc0200666:	6942                	ld	s2,16(sp)
ffffffffc0200668:	00004517          	auipc	a0,0x4
ffffffffc020066c:	bc850513          	addi	a0,a0,-1080 # ffffffffc0204230 <etext+0x3e8>
}
ffffffffc0200670:	7402                	ld	s0,32(sp)
ffffffffc0200672:	70a2                	ld	ra,40(sp)
ffffffffc0200674:	6145                	addi	sp,sp,48
    cprintf("DTB init completed\n");
ffffffffc0200676:	be39                	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200678:	7402                	ld	s0,32(sp)
ffffffffc020067a:	70a2                	ld	ra,40(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc020067c:	00004517          	auipc	a0,0x4
ffffffffc0200680:	ad450513          	addi	a0,a0,-1324 # ffffffffc0204150 <etext+0x308>
}
ffffffffc0200684:	6145                	addi	sp,sp,48
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200686:	b639                	j	ffffffffc0200194 <cprintf>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200688:	4058                	lw	a4,4(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020068a:	0087579b          	srliw	a5,a4,0x8
ffffffffc020068e:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200692:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200696:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020069a:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020069e:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006a2:	8ed1                	or	a3,a3,a2
ffffffffc02006a4:	0ff77713          	zext.b	a4,a4
ffffffffc02006a8:	8fd5                	or	a5,a5,a3
ffffffffc02006aa:	0722                	slli	a4,a4,0x8
ffffffffc02006ac:	8fd9                	or	a5,a5,a4
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006ae:	04031463          	bnez	t1,ffffffffc02006f6 <dtb_init+0x1ce>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02006b2:	1782                	slli	a5,a5,0x20
ffffffffc02006b4:	9381                	srli	a5,a5,0x20
ffffffffc02006b6:	043d                	addi	s0,s0,15
ffffffffc02006b8:	943e                	add	s0,s0,a5
ffffffffc02006ba:	9871                	andi	s0,s0,-4
                break;
ffffffffc02006bc:	bfa1                	j	ffffffffc0200614 <dtb_init+0xec>
                int name_len = strlen(name);
ffffffffc02006be:	8522                	mv	a0,s0
ffffffffc02006c0:	e01a                	sd	t1,0(sp)
ffffffffc02006c2:	684030ef          	jal	ffffffffc0203d46 <strlen>
ffffffffc02006c6:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02006c8:	4619                	li	a2,6
ffffffffc02006ca:	8522                	mv	a0,s0
ffffffffc02006cc:	00004597          	auipc	a1,0x4
ffffffffc02006d0:	aac58593          	addi	a1,a1,-1364 # ffffffffc0204178 <etext+0x330>
ffffffffc02006d4:	6ec030ef          	jal	ffffffffc0203dc0 <strncmp>
ffffffffc02006d8:	6302                	ld	t1,0(sp)
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02006da:	0411                	addi	s0,s0,4
ffffffffc02006dc:	0004879b          	sext.w	a5,s1
ffffffffc02006e0:	943e                	add	s0,s0,a5
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02006e2:	00153513          	seqz	a0,a0
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02006e6:	9871                	andi	s0,s0,-4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02006e8:	00a36333          	or	t1,t1,a0
                break;
ffffffffc02006ec:	00ff0837          	lui	a6,0xff0
ffffffffc02006f0:	488d                	li	a7,3
ffffffffc02006f2:	4e05                	li	t3,1
ffffffffc02006f4:	b705                	j	ffffffffc0200614 <dtb_init+0xec>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006f6:	4418                	lw	a4,8(s0)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006f8:	00004597          	auipc	a1,0x4
ffffffffc02006fc:	a8858593          	addi	a1,a1,-1400 # ffffffffc0204180 <etext+0x338>
ffffffffc0200700:	e43e                	sd	a5,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200702:	0087551b          	srliw	a0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200706:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020070a:	0187169b          	slliw	a3,a4,0x18
ffffffffc020070e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200712:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200716:	01057533          	and	a0,a0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020071a:	8ed1                	or	a3,a3,a2
ffffffffc020071c:	0ff77713          	zext.b	a4,a4
ffffffffc0200720:	0722                	slli	a4,a4,0x8
ffffffffc0200722:	8d55                	or	a0,a0,a3
ffffffffc0200724:	8d59                	or	a0,a0,a4
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200726:	1502                	slli	a0,a0,0x20
ffffffffc0200728:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020072a:	954a                	add	a0,a0,s2
ffffffffc020072c:	e01a                	sd	t1,0(sp)
ffffffffc020072e:	65e030ef          	jal	ffffffffc0203d8c <strcmp>
ffffffffc0200732:	67a2                	ld	a5,8(sp)
ffffffffc0200734:	473d                	li	a4,15
ffffffffc0200736:	6302                	ld	t1,0(sp)
ffffffffc0200738:	00ff0837          	lui	a6,0xff0
ffffffffc020073c:	488d                	li	a7,3
ffffffffc020073e:	4e05                	li	t3,1
ffffffffc0200740:	f6f779e3          	bgeu	a4,a5,ffffffffc02006b2 <dtb_init+0x18a>
ffffffffc0200744:	f53d                	bnez	a0,ffffffffc02006b2 <dtb_init+0x18a>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200746:	00c43683          	ld	a3,12(s0)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020074a:	01443703          	ld	a4,20(s0)
        cprintf("Physical Memory from DTB:\n");
ffffffffc020074e:	00004517          	auipc	a0,0x4
ffffffffc0200752:	a3a50513          	addi	a0,a0,-1478 # ffffffffc0204188 <etext+0x340>
           fdt32_to_cpu(x >> 32);
ffffffffc0200756:	4206d793          	srai	a5,a3,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020075a:	0087d31b          	srliw	t1,a5,0x8
ffffffffc020075e:	00871f93          	slli	t6,a4,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc0200762:	42075893          	srai	a7,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200766:	0187df1b          	srliw	t5,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020076a:	0187959b          	slliw	a1,a5,0x18
ffffffffc020076e:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200772:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200776:	420fd613          	srai	a2,t6,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020077a:	0188de9b          	srliw	t4,a7,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020077e:	01037333          	and	t1,t1,a6
ffffffffc0200782:	01889e1b          	slliw	t3,a7,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200786:	01e5e5b3          	or	a1,a1,t5
ffffffffc020078a:	0ff7f793          	zext.b	a5,a5
ffffffffc020078e:	01de6e33          	or	t3,t3,t4
ffffffffc0200792:	0065e5b3          	or	a1,a1,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200796:	01067633          	and	a2,a2,a6
ffffffffc020079a:	0086d31b          	srliw	t1,a3,0x8
ffffffffc020079e:	0087541b          	srliw	s0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007a2:	07a2                	slli	a5,a5,0x8
ffffffffc02007a4:	0108d89b          	srliw	a7,a7,0x10
ffffffffc02007a8:	0186df1b          	srliw	t5,a3,0x18
ffffffffc02007ac:	01875e9b          	srliw	t4,a4,0x18
ffffffffc02007b0:	8ddd                	or	a1,a1,a5
ffffffffc02007b2:	01c66633          	or	a2,a2,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007b6:	0186979b          	slliw	a5,a3,0x18
ffffffffc02007ba:	01871e1b          	slliw	t3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007be:	0ff8f893          	zext.b	a7,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007c2:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007c6:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007ca:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007ce:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007d2:	01037333          	and	t1,t1,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007d6:	08a2                	slli	a7,a7,0x8
ffffffffc02007d8:	01e7e7b3          	or	a5,a5,t5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007dc:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007e0:	0ff6f693          	zext.b	a3,a3
ffffffffc02007e4:	01de6833          	or	a6,t3,t4
ffffffffc02007e8:	0ff77713          	zext.b	a4,a4
ffffffffc02007ec:	01166633          	or	a2,a2,a7
ffffffffc02007f0:	0067e7b3          	or	a5,a5,t1
ffffffffc02007f4:	06a2                	slli	a3,a3,0x8
ffffffffc02007f6:	01046433          	or	s0,s0,a6
ffffffffc02007fa:	0722                	slli	a4,a4,0x8
ffffffffc02007fc:	8fd5                	or	a5,a5,a3
ffffffffc02007fe:	8c59                	or	s0,s0,a4
           fdt32_to_cpu(x >> 32);
ffffffffc0200800:	1582                	slli	a1,a1,0x20
ffffffffc0200802:	1602                	slli	a2,a2,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200804:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200806:	9201                	srli	a2,a2,0x20
ffffffffc0200808:	9181                	srli	a1,a1,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020080a:	1402                	slli	s0,s0,0x20
ffffffffc020080c:	00b7e4b3          	or	s1,a5,a1
ffffffffc0200810:	8c51                	or	s0,s0,a2
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200812:	983ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200816:	85a6                	mv	a1,s1
ffffffffc0200818:	00004517          	auipc	a0,0x4
ffffffffc020081c:	99050513          	addi	a0,a0,-1648 # ffffffffc02041a8 <etext+0x360>
ffffffffc0200820:	975ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200824:	01445613          	srli	a2,s0,0x14
ffffffffc0200828:	85a2                	mv	a1,s0
ffffffffc020082a:	00004517          	auipc	a0,0x4
ffffffffc020082e:	99650513          	addi	a0,a0,-1642 # ffffffffc02041c0 <etext+0x378>
ffffffffc0200832:	963ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200836:	009405b3          	add	a1,s0,s1
ffffffffc020083a:	15fd                	addi	a1,a1,-1
ffffffffc020083c:	00004517          	auipc	a0,0x4
ffffffffc0200840:	9a450513          	addi	a0,a0,-1628 # ffffffffc02041e0 <etext+0x398>
ffffffffc0200844:	951ff0ef          	jal	ffffffffc0200194 <cprintf>
        memory_base = mem_base;
ffffffffc0200848:	0000d797          	auipc	a5,0xd
ffffffffc020084c:	c497b023          	sd	s1,-960(a5) # ffffffffc020d488 <memory_base>
        memory_size = mem_size;
ffffffffc0200850:	0000d797          	auipc	a5,0xd
ffffffffc0200854:	c287b823          	sd	s0,-976(a5) # ffffffffc020d480 <memory_size>
ffffffffc0200858:	b531                	j	ffffffffc0200664 <dtb_init+0x13c>

ffffffffc020085a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020085a:	0000d517          	auipc	a0,0xd
ffffffffc020085e:	c2e53503          	ld	a0,-978(a0) # ffffffffc020d488 <memory_base>
ffffffffc0200862:	8082                	ret

ffffffffc0200864 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc0200864:	0000d517          	auipc	a0,0xd
ffffffffc0200868:	c1c53503          	ld	a0,-996(a0) # ffffffffc020d480 <memory_size>
ffffffffc020086c:	8082                	ret

ffffffffc020086e <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc020086e:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200872:	8082                	ret

ffffffffc0200874 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200874:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200878:	8082                	ret

ffffffffc020087a <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc020087a:	8082                	ret

ffffffffc020087c <idt_init>:
     */

    extern void __alltraps(void);
    /* Set sup0 scratch register to 0, indicating to exception vector
       that we are presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc020087c:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200880:	00000797          	auipc	a5,0x0
ffffffffc0200884:	3e078793          	addi	a5,a5,992 # ffffffffc0200c60 <__alltraps>
ffffffffc0200888:	10579073          	csrw	stvec,a5
#endif
}

static void trigger_exceptions(void) {
    static int done = 0;
    if (done) return;
ffffffffc020088c:	0000d797          	auipc	a5,0xd
ffffffffc0200890:	c0c7a783          	lw	a5,-1012(a5) # ffffffffc020d498 <done.2>
ffffffffc0200894:	eb81                	bnez	a5,ffffffffc02008a4 <idt_init+0x28>
    done = 1;
ffffffffc0200896:	4785                	li	a5,1
ffffffffc0200898:	0000d717          	auipc	a4,0xd
ffffffffc020089c:	c0f72023          	sw	a5,-1024(a4) # ffffffffc020d498 <done.2>
    asm volatile("ebreak");          // 触发 breakpoint 异常
ffffffffc02008a0:	9002                	ebreak
    asm volatile(".2byte 0x0000");   // 非法压缩指令编码，触发 Illegal instruction
ffffffffc02008a2:	0000                	.short	0x0000
}
ffffffffc02008a4:	8082                	ret

ffffffffc02008a6 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02008a6:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc02008a8:	1141                	addi	sp,sp,-16
ffffffffc02008aa:	e022                	sd	s0,0(sp)
ffffffffc02008ac:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02008ae:	00004517          	auipc	a0,0x4
ffffffffc02008b2:	99a50513          	addi	a0,a0,-1638 # ffffffffc0204248 <etext+0x400>
void print_regs(struct pushregs *gpr) {
ffffffffc02008b6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02008b8:	8ddff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02008bc:	640c                	ld	a1,8(s0)
ffffffffc02008be:	00004517          	auipc	a0,0x4
ffffffffc02008c2:	9a250513          	addi	a0,a0,-1630 # ffffffffc0204260 <etext+0x418>
ffffffffc02008c6:	8cfff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02008ca:	680c                	ld	a1,16(s0)
ffffffffc02008cc:	00004517          	auipc	a0,0x4
ffffffffc02008d0:	9ac50513          	addi	a0,a0,-1620 # ffffffffc0204278 <etext+0x430>
ffffffffc02008d4:	8c1ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02008d8:	6c0c                	ld	a1,24(s0)
ffffffffc02008da:	00004517          	auipc	a0,0x4
ffffffffc02008de:	9b650513          	addi	a0,a0,-1610 # ffffffffc0204290 <etext+0x448>
ffffffffc02008e2:	8b3ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02008e6:	700c                	ld	a1,32(s0)
ffffffffc02008e8:	00004517          	auipc	a0,0x4
ffffffffc02008ec:	9c050513          	addi	a0,a0,-1600 # ffffffffc02042a8 <etext+0x460>
ffffffffc02008f0:	8a5ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02008f4:	740c                	ld	a1,40(s0)
ffffffffc02008f6:	00004517          	auipc	a0,0x4
ffffffffc02008fa:	9ca50513          	addi	a0,a0,-1590 # ffffffffc02042c0 <etext+0x478>
ffffffffc02008fe:	897ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200902:	780c                	ld	a1,48(s0)
ffffffffc0200904:	00004517          	auipc	a0,0x4
ffffffffc0200908:	9d450513          	addi	a0,a0,-1580 # ffffffffc02042d8 <etext+0x490>
ffffffffc020090c:	889ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200910:	7c0c                	ld	a1,56(s0)
ffffffffc0200912:	00004517          	auipc	a0,0x4
ffffffffc0200916:	9de50513          	addi	a0,a0,-1570 # ffffffffc02042f0 <etext+0x4a8>
ffffffffc020091a:	87bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc020091e:	602c                	ld	a1,64(s0)
ffffffffc0200920:	00004517          	auipc	a0,0x4
ffffffffc0200924:	9e850513          	addi	a0,a0,-1560 # ffffffffc0204308 <etext+0x4c0>
ffffffffc0200928:	86dff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc020092c:	642c                	ld	a1,72(s0)
ffffffffc020092e:	00004517          	auipc	a0,0x4
ffffffffc0200932:	9f250513          	addi	a0,a0,-1550 # ffffffffc0204320 <etext+0x4d8>
ffffffffc0200936:	85fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc020093a:	682c                	ld	a1,80(s0)
ffffffffc020093c:	00004517          	auipc	a0,0x4
ffffffffc0200940:	9fc50513          	addi	a0,a0,-1540 # ffffffffc0204338 <etext+0x4f0>
ffffffffc0200944:	851ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200948:	6c2c                	ld	a1,88(s0)
ffffffffc020094a:	00004517          	auipc	a0,0x4
ffffffffc020094e:	a0650513          	addi	a0,a0,-1530 # ffffffffc0204350 <etext+0x508>
ffffffffc0200952:	843ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200956:	702c                	ld	a1,96(s0)
ffffffffc0200958:	00004517          	auipc	a0,0x4
ffffffffc020095c:	a1050513          	addi	a0,a0,-1520 # ffffffffc0204368 <etext+0x520>
ffffffffc0200960:	835ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200964:	742c                	ld	a1,104(s0)
ffffffffc0200966:	00004517          	auipc	a0,0x4
ffffffffc020096a:	a1a50513          	addi	a0,a0,-1510 # ffffffffc0204380 <etext+0x538>
ffffffffc020096e:	827ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200972:	782c                	ld	a1,112(s0)
ffffffffc0200974:	00004517          	auipc	a0,0x4
ffffffffc0200978:	a2450513          	addi	a0,a0,-1500 # ffffffffc0204398 <etext+0x550>
ffffffffc020097c:	819ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200980:	7c2c                	ld	a1,120(s0)
ffffffffc0200982:	00004517          	auipc	a0,0x4
ffffffffc0200986:	a2e50513          	addi	a0,a0,-1490 # ffffffffc02043b0 <etext+0x568>
ffffffffc020098a:	80bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc020098e:	604c                	ld	a1,128(s0)
ffffffffc0200990:	00004517          	auipc	a0,0x4
ffffffffc0200994:	a3850513          	addi	a0,a0,-1480 # ffffffffc02043c8 <etext+0x580>
ffffffffc0200998:	ffcff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc020099c:	644c                	ld	a1,136(s0)
ffffffffc020099e:	00004517          	auipc	a0,0x4
ffffffffc02009a2:	a4250513          	addi	a0,a0,-1470 # ffffffffc02043e0 <etext+0x598>
ffffffffc02009a6:	feeff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc02009aa:	684c                	ld	a1,144(s0)
ffffffffc02009ac:	00004517          	auipc	a0,0x4
ffffffffc02009b0:	a4c50513          	addi	a0,a0,-1460 # ffffffffc02043f8 <etext+0x5b0>
ffffffffc02009b4:	fe0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc02009b8:	6c4c                	ld	a1,152(s0)
ffffffffc02009ba:	00004517          	auipc	a0,0x4
ffffffffc02009be:	a5650513          	addi	a0,a0,-1450 # ffffffffc0204410 <etext+0x5c8>
ffffffffc02009c2:	fd2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc02009c6:	704c                	ld	a1,160(s0)
ffffffffc02009c8:	00004517          	auipc	a0,0x4
ffffffffc02009cc:	a6050513          	addi	a0,a0,-1440 # ffffffffc0204428 <etext+0x5e0>
ffffffffc02009d0:	fc4ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02009d4:	744c                	ld	a1,168(s0)
ffffffffc02009d6:	00004517          	auipc	a0,0x4
ffffffffc02009da:	a6a50513          	addi	a0,a0,-1430 # ffffffffc0204440 <etext+0x5f8>
ffffffffc02009de:	fb6ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02009e2:	784c                	ld	a1,176(s0)
ffffffffc02009e4:	00004517          	auipc	a0,0x4
ffffffffc02009e8:	a7450513          	addi	a0,a0,-1420 # ffffffffc0204458 <etext+0x610>
ffffffffc02009ec:	fa8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02009f0:	7c4c                	ld	a1,184(s0)
ffffffffc02009f2:	00004517          	auipc	a0,0x4
ffffffffc02009f6:	a7e50513          	addi	a0,a0,-1410 # ffffffffc0204470 <etext+0x628>
ffffffffc02009fa:	f9aff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02009fe:	606c                	ld	a1,192(s0)
ffffffffc0200a00:	00004517          	auipc	a0,0x4
ffffffffc0200a04:	a8850513          	addi	a0,a0,-1400 # ffffffffc0204488 <etext+0x640>
ffffffffc0200a08:	f8cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200a0c:	646c                	ld	a1,200(s0)
ffffffffc0200a0e:	00004517          	auipc	a0,0x4
ffffffffc0200a12:	a9250513          	addi	a0,a0,-1390 # ffffffffc02044a0 <etext+0x658>
ffffffffc0200a16:	f7eff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200a1a:	686c                	ld	a1,208(s0)
ffffffffc0200a1c:	00004517          	auipc	a0,0x4
ffffffffc0200a20:	a9c50513          	addi	a0,a0,-1380 # ffffffffc02044b8 <etext+0x670>
ffffffffc0200a24:	f70ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200a28:	6c6c                	ld	a1,216(s0)
ffffffffc0200a2a:	00004517          	auipc	a0,0x4
ffffffffc0200a2e:	aa650513          	addi	a0,a0,-1370 # ffffffffc02044d0 <etext+0x688>
ffffffffc0200a32:	f62ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200a36:	706c                	ld	a1,224(s0)
ffffffffc0200a38:	00004517          	auipc	a0,0x4
ffffffffc0200a3c:	ab050513          	addi	a0,a0,-1360 # ffffffffc02044e8 <etext+0x6a0>
ffffffffc0200a40:	f54ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200a44:	746c                	ld	a1,232(s0)
ffffffffc0200a46:	00004517          	auipc	a0,0x4
ffffffffc0200a4a:	aba50513          	addi	a0,a0,-1350 # ffffffffc0204500 <etext+0x6b8>
ffffffffc0200a4e:	f46ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200a52:	786c                	ld	a1,240(s0)
ffffffffc0200a54:	00004517          	auipc	a0,0x4
ffffffffc0200a58:	ac450513          	addi	a0,a0,-1340 # ffffffffc0204518 <etext+0x6d0>
ffffffffc0200a5c:	f38ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a60:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200a62:	6402                	ld	s0,0(sp)
ffffffffc0200a64:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a66:	00004517          	auipc	a0,0x4
ffffffffc0200a6a:	aca50513          	addi	a0,a0,-1334 # ffffffffc0204530 <etext+0x6e8>
}
ffffffffc0200a6e:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a70:	f24ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200a74 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc0200a74:	1141                	addi	sp,sp,-16
ffffffffc0200a76:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a78:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc0200a7a:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a7c:	00004517          	auipc	a0,0x4
ffffffffc0200a80:	acc50513          	addi	a0,a0,-1332 # ffffffffc0204548 <etext+0x700>
void print_trapframe(struct trapframe *tf) {
ffffffffc0200a84:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a86:	f0eff0ef          	jal	ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200a8a:	8522                	mv	a0,s0
ffffffffc0200a8c:	e1bff0ef          	jal	ffffffffc02008a6 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200a90:	10043583          	ld	a1,256(s0)
ffffffffc0200a94:	00004517          	auipc	a0,0x4
ffffffffc0200a98:	acc50513          	addi	a0,a0,-1332 # ffffffffc0204560 <etext+0x718>
ffffffffc0200a9c:	ef8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200aa0:	10843583          	ld	a1,264(s0)
ffffffffc0200aa4:	00004517          	auipc	a0,0x4
ffffffffc0200aa8:	ad450513          	addi	a0,a0,-1324 # ffffffffc0204578 <etext+0x730>
ffffffffc0200aac:	ee8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200ab0:	11043583          	ld	a1,272(s0)
ffffffffc0200ab4:	00004517          	auipc	a0,0x4
ffffffffc0200ab8:	adc50513          	addi	a0,a0,-1316 # ffffffffc0204590 <etext+0x748>
ffffffffc0200abc:	ed8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200ac0:	11843583          	ld	a1,280(s0)
}
ffffffffc0200ac4:	6402                	ld	s0,0(sp)
ffffffffc0200ac6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200ac8:	00004517          	auipc	a0,0x4
ffffffffc0200acc:	ae050513          	addi	a0,a0,-1312 # ffffffffc02045a8 <etext+0x760>
}
ffffffffc0200ad0:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200ad2:	ec2ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200ad6 <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause) {
ffffffffc0200ad6:	11853783          	ld	a5,280(a0)
ffffffffc0200ada:	472d                	li	a4,11
ffffffffc0200adc:	0786                	slli	a5,a5,0x1
ffffffffc0200ade:	8385                	srli	a5,a5,0x1
ffffffffc0200ae0:	08f76363          	bltu	a4,a5,ffffffffc0200b66 <interrupt_handler+0x90>
ffffffffc0200ae4:	00005717          	auipc	a4,0x5
ffffffffc0200ae8:	b8c70713          	addi	a4,a4,-1140 # ffffffffc0205670 <commands+0x48>
ffffffffc0200aec:	078a                	slli	a5,a5,0x2
ffffffffc0200aee:	97ba                	add	a5,a5,a4
ffffffffc0200af0:	439c                	lw	a5,0(a5)
ffffffffc0200af2:	97ba                	add	a5,a5,a4
ffffffffc0200af4:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc0200af6:	00004517          	auipc	a0,0x4
ffffffffc0200afa:	b2a50513          	addi	a0,a0,-1238 # ffffffffc0204620 <etext+0x7d8>
ffffffffc0200afe:	e96ff06f          	j	ffffffffc0200194 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc0200b02:	00004517          	auipc	a0,0x4
ffffffffc0200b06:	afe50513          	addi	a0,a0,-1282 # ffffffffc0204600 <etext+0x7b8>
ffffffffc0200b0a:	e8aff06f          	j	ffffffffc0200194 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc0200b0e:	00004517          	auipc	a0,0x4
ffffffffc0200b12:	ab250513          	addi	a0,a0,-1358 # ffffffffc02045c0 <etext+0x778>
ffffffffc0200b16:	e7eff06f          	j	ffffffffc0200194 <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc0200b1a:	00004517          	auipc	a0,0x4
ffffffffc0200b1e:	b2650513          	addi	a0,a0,-1242 # ffffffffc0204640 <etext+0x7f8>
ffffffffc0200b22:	e72ff06f          	j	ffffffffc0200194 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc0200b26:	1141                	addi	sp,sp,-16
ffffffffc0200b28:	e406                	sd	ra,8(sp)
            * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
            */
            {
                static int ticks = 0;
                static int num = 0;
                clock_set_next_event();
ffffffffc0200b2a:	973ff0ef          	jal	ffffffffc020049c <clock_set_next_event>
                ticks++;
ffffffffc0200b2e:	0000d597          	auipc	a1,0xd
ffffffffc0200b32:	9665a583          	lw	a1,-1690(a1) # ffffffffc020d494 <ticks.1>
                if (ticks == 100) {
ffffffffc0200b36:	06400793          	li	a5,100
                ticks++;
ffffffffc0200b3a:	2585                	addiw	a1,a1,1
ffffffffc0200b3c:	0000d717          	auipc	a4,0xd
ffffffffc0200b40:	94b72c23          	sw	a1,-1704(a4) # ffffffffc020d494 <ticks.1>
                if (ticks == 100) {
ffffffffc0200b44:	02f58263          	beq	a1,a5,ffffffffc0200b68 <interrupt_handler+0x92>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200b48:	60a2                	ld	ra,8(sp)
ffffffffc0200b4a:	0141                	addi	sp,sp,16
ffffffffc0200b4c:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc0200b4e:	00004517          	auipc	a0,0x4
ffffffffc0200b52:	b1a50513          	addi	a0,a0,-1254 # ffffffffc0204668 <etext+0x820>
ffffffffc0200b56:	e3eff06f          	j	ffffffffc0200194 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200b5a:	00004517          	auipc	a0,0x4
ffffffffc0200b5e:	a8650513          	addi	a0,a0,-1402 # ffffffffc02045e0 <etext+0x798>
ffffffffc0200b62:	e32ff06f          	j	ffffffffc0200194 <cprintf>
            print_trapframe(tf);
ffffffffc0200b66:	b739                	j	ffffffffc0200a74 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200b68:	00004517          	auipc	a0,0x4
ffffffffc0200b6c:	af050513          	addi	a0,a0,-1296 # ffffffffc0204658 <etext+0x810>
ffffffffc0200b70:	e24ff0ef          	jal	ffffffffc0200194 <cprintf>
                    num++;
ffffffffc0200b74:	0000d797          	auipc	a5,0xd
ffffffffc0200b78:	91c7a783          	lw	a5,-1764(a5) # ffffffffc020d490 <num.0>
                    ticks = 0;
ffffffffc0200b7c:	0000d717          	auipc	a4,0xd
ffffffffc0200b80:	90072c23          	sw	zero,-1768(a4) # ffffffffc020d494 <ticks.1>
                    if (num == 10) {
ffffffffc0200b84:	4729                	li	a4,10
                    num++;
ffffffffc0200b86:	2785                	addiw	a5,a5,1
ffffffffc0200b88:	0000d697          	auipc	a3,0xd
ffffffffc0200b8c:	90f6a423          	sw	a5,-1784(a3) # ffffffffc020d490 <num.0>
                    if (num == 10) {
ffffffffc0200b90:	fae79ce3          	bne	a5,a4,ffffffffc0200b48 <interrupt_handler+0x72>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200b94:	4501                	li	a0,0
ffffffffc0200b96:	4581                	li	a1,0
ffffffffc0200b98:	4601                	li	a2,0
ffffffffc0200b9a:	48a1                	li	a7,8
ffffffffc0200b9c:	00000073          	ecall
}
ffffffffc0200ba0:	b765                	j	ffffffffc0200b48 <interrupt_handler+0x72>

ffffffffc0200ba2 <exception_handler>:

void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
ffffffffc0200ba2:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc0200ba6:	1101                	addi	sp,sp,-32
ffffffffc0200ba8:	e822                	sd	s0,16(sp)
ffffffffc0200baa:	ec06                	sd	ra,24(sp)
    switch (tf->cause) {
ffffffffc0200bac:	470d                	li	a4,3
void exception_handler(struct trapframe *tf) {
ffffffffc0200bae:	842a                	mv	s0,a0
    switch (tf->cause) {
ffffffffc0200bb0:	04e78e63          	beq	a5,a4,ffffffffc0200c0c <exception_handler+0x6a>
ffffffffc0200bb4:	04f76463          	bltu	a4,a5,ffffffffc0200bfc <exception_handler+0x5a>
ffffffffc0200bb8:	4689                	li	a3,2
ffffffffc0200bba:	02d79d63          	bne	a5,a3,ffffffffc0200bf4 <exception_handler+0x52>
            /*(1)输出指令异常类型（ Illegal instruction）
             *(2)输出异常指令地址
             *(3)更新 tf->epc寄存器
            */
            {
                cprintf("Exception type:Illegal instruction\n");
ffffffffc0200bbe:	00004517          	auipc	a0,0x4
ffffffffc0200bc2:	aca50513          	addi	a0,a0,-1334 # ffffffffc0204688 <etext+0x840>
ffffffffc0200bc6:	e43e                	sd	a5,8(sp)
ffffffffc0200bc8:	dccff0ef          	jal	ffffffffc0200194 <cprintf>
                cprintf("Illegal instruction caught at 0x%08lx\n", (unsigned long)tf->epc);
ffffffffc0200bcc:	10843583          	ld	a1,264(s0)
ffffffffc0200bd0:	00004517          	auipc	a0,0x4
ffffffffc0200bd4:	ae050513          	addi	a0,a0,-1312 # ffffffffc02046b0 <etext+0x868>
ffffffffc0200bd8:	dbcff0ef          	jal	ffffffffc0200194 <cprintf>
                tf->epc += instr_len(tf->epc);
ffffffffc0200bdc:	10843683          	ld	a3,264(s0)
    return ((inst16 & 0x3) == 0x3) ? 4 : 2;
ffffffffc0200be0:	470d                	li	a4,3
ffffffffc0200be2:	67a2                	ld	a5,8(sp)
ffffffffc0200be4:	0006d603          	lhu	a2,0(a3)
ffffffffc0200be8:	8a0d                	andi	a2,a2,3
ffffffffc0200bea:	06e60263          	beq	a2,a4,ffffffffc0200c4e <exception_handler+0xac>
                tf->epc += instr_len(tf->epc);
ffffffffc0200bee:	96be                	add	a3,a3,a5
ffffffffc0200bf0:	10d43423          	sd	a3,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200bf4:	60e2                	ld	ra,24(sp)
ffffffffc0200bf6:	6442                	ld	s0,16(sp)
ffffffffc0200bf8:	6105                	addi	sp,sp,32
ffffffffc0200bfa:	8082                	ret
    switch (tf->cause) {
ffffffffc0200bfc:	17f1                	addi	a5,a5,-4
ffffffffc0200bfe:	471d                	li	a4,7
ffffffffc0200c00:	fef77ae3          	bgeu	a4,a5,ffffffffc0200bf4 <exception_handler+0x52>
}
ffffffffc0200c04:	6442                	ld	s0,16(sp)
ffffffffc0200c06:	60e2                	ld	ra,24(sp)
ffffffffc0200c08:	6105                	addi	sp,sp,32
            print_trapframe(tf);
ffffffffc0200c0a:	b5ad                	j	ffffffffc0200a74 <print_trapframe>
                cprintf("Exception type: breakpoint\n");
ffffffffc0200c0c:	00004517          	auipc	a0,0x4
ffffffffc0200c10:	acc50513          	addi	a0,a0,-1332 # ffffffffc02046d8 <etext+0x890>
ffffffffc0200c14:	e43e                	sd	a5,8(sp)
ffffffffc0200c16:	d7eff0ef          	jal	ffffffffc0200194 <cprintf>
                cprintf("ebreak caught at 0x%08lx\n", (unsigned long)tf->epc);
ffffffffc0200c1a:	10843583          	ld	a1,264(s0)
ffffffffc0200c1e:	00004517          	auipc	a0,0x4
ffffffffc0200c22:	ada50513          	addi	a0,a0,-1318 # ffffffffc02046f8 <etext+0x8b0>
ffffffffc0200c26:	d6eff0ef          	jal	ffffffffc0200194 <cprintf>
                tf->epc += instr_len(tf->epc);
ffffffffc0200c2a:	10843703          	ld	a4,264(s0)
    return ((inst16 & 0x3) == 0x3) ? 4 : 2;
ffffffffc0200c2e:	67a2                	ld	a5,8(sp)
ffffffffc0200c30:	4609                	li	a2,2
ffffffffc0200c32:	00075683          	lhu	a3,0(a4)
ffffffffc0200c36:	8a8d                	andi	a3,a3,3
ffffffffc0200c38:	00f68963          	beq	a3,a5,ffffffffc0200c4a <exception_handler+0xa8>
                tf->epc += instr_len(tf->epc);
ffffffffc0200c3c:	9732                	add	a4,a4,a2
}
ffffffffc0200c3e:	60e2                	ld	ra,24(sp)
                tf->epc += instr_len(tf->epc);
ffffffffc0200c40:	10e43423          	sd	a4,264(s0)
}
ffffffffc0200c44:	6442                	ld	s0,16(sp)
ffffffffc0200c46:	6105                	addi	sp,sp,32
ffffffffc0200c48:	8082                	ret
    return ((inst16 & 0x3) == 0x3) ? 4 : 2;
ffffffffc0200c4a:	4611                	li	a2,4
ffffffffc0200c4c:	bfc5                	j	ffffffffc0200c3c <exception_handler+0x9a>
ffffffffc0200c4e:	4791                	li	a5,4
ffffffffc0200c50:	bf79                	j	ffffffffc0200bee <exception_handler+0x4c>

ffffffffc0200c52 <trap>:

static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200c52:	11853783          	ld	a5,280(a0)
ffffffffc0200c56:	0007c363          	bltz	a5,ffffffffc0200c5c <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc0200c5a:	b7a1                	j	ffffffffc0200ba2 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200c5c:	bdad                	j	ffffffffc0200ad6 <interrupt_handler>
	...

ffffffffc0200c60 <__alltraps>:
    LOAD  x2,2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200c60:	14011073          	csrw	sscratch,sp
ffffffffc0200c64:	712d                	addi	sp,sp,-288
ffffffffc0200c66:	e406                	sd	ra,8(sp)
ffffffffc0200c68:	ec0e                	sd	gp,24(sp)
ffffffffc0200c6a:	f012                	sd	tp,32(sp)
ffffffffc0200c6c:	f416                	sd	t0,40(sp)
ffffffffc0200c6e:	f81a                	sd	t1,48(sp)
ffffffffc0200c70:	fc1e                	sd	t2,56(sp)
ffffffffc0200c72:	e0a2                	sd	s0,64(sp)
ffffffffc0200c74:	e4a6                	sd	s1,72(sp)
ffffffffc0200c76:	e8aa                	sd	a0,80(sp)
ffffffffc0200c78:	ecae                	sd	a1,88(sp)
ffffffffc0200c7a:	f0b2                	sd	a2,96(sp)
ffffffffc0200c7c:	f4b6                	sd	a3,104(sp)
ffffffffc0200c7e:	f8ba                	sd	a4,112(sp)
ffffffffc0200c80:	fcbe                	sd	a5,120(sp)
ffffffffc0200c82:	e142                	sd	a6,128(sp)
ffffffffc0200c84:	e546                	sd	a7,136(sp)
ffffffffc0200c86:	e94a                	sd	s2,144(sp)
ffffffffc0200c88:	ed4e                	sd	s3,152(sp)
ffffffffc0200c8a:	f152                	sd	s4,160(sp)
ffffffffc0200c8c:	f556                	sd	s5,168(sp)
ffffffffc0200c8e:	f95a                	sd	s6,176(sp)
ffffffffc0200c90:	fd5e                	sd	s7,184(sp)
ffffffffc0200c92:	e1e2                	sd	s8,192(sp)
ffffffffc0200c94:	e5e6                	sd	s9,200(sp)
ffffffffc0200c96:	e9ea                	sd	s10,208(sp)
ffffffffc0200c98:	edee                	sd	s11,216(sp)
ffffffffc0200c9a:	f1f2                	sd	t3,224(sp)
ffffffffc0200c9c:	f5f6                	sd	t4,232(sp)
ffffffffc0200c9e:	f9fa                	sd	t5,240(sp)
ffffffffc0200ca0:	fdfe                	sd	t6,248(sp)
ffffffffc0200ca2:	14002473          	csrr	s0,sscratch
ffffffffc0200ca6:	100024f3          	csrr	s1,sstatus
ffffffffc0200caa:	14102973          	csrr	s2,sepc
ffffffffc0200cae:	143029f3          	csrr	s3,stval
ffffffffc0200cb2:	14202a73          	csrr	s4,scause
ffffffffc0200cb6:	e822                	sd	s0,16(sp)
ffffffffc0200cb8:	e226                	sd	s1,256(sp)
ffffffffc0200cba:	e64a                	sd	s2,264(sp)
ffffffffc0200cbc:	ea4e                	sd	s3,272(sp)
ffffffffc0200cbe:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200cc0:	850a                	mv	a0,sp
    jal trap
ffffffffc0200cc2:	f91ff0ef          	jal	ffffffffc0200c52 <trap>

ffffffffc0200cc6 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200cc6:	6492                	ld	s1,256(sp)
ffffffffc0200cc8:	6932                	ld	s2,264(sp)
ffffffffc0200cca:	10049073          	csrw	sstatus,s1
ffffffffc0200cce:	14191073          	csrw	sepc,s2
ffffffffc0200cd2:	60a2                	ld	ra,8(sp)
ffffffffc0200cd4:	61e2                	ld	gp,24(sp)
ffffffffc0200cd6:	7202                	ld	tp,32(sp)
ffffffffc0200cd8:	72a2                	ld	t0,40(sp)
ffffffffc0200cda:	7342                	ld	t1,48(sp)
ffffffffc0200cdc:	73e2                	ld	t2,56(sp)
ffffffffc0200cde:	6406                	ld	s0,64(sp)
ffffffffc0200ce0:	64a6                	ld	s1,72(sp)
ffffffffc0200ce2:	6546                	ld	a0,80(sp)
ffffffffc0200ce4:	65e6                	ld	a1,88(sp)
ffffffffc0200ce6:	7606                	ld	a2,96(sp)
ffffffffc0200ce8:	76a6                	ld	a3,104(sp)
ffffffffc0200cea:	7746                	ld	a4,112(sp)
ffffffffc0200cec:	77e6                	ld	a5,120(sp)
ffffffffc0200cee:	680a                	ld	a6,128(sp)
ffffffffc0200cf0:	68aa                	ld	a7,136(sp)
ffffffffc0200cf2:	694a                	ld	s2,144(sp)
ffffffffc0200cf4:	69ea                	ld	s3,152(sp)
ffffffffc0200cf6:	7a0a                	ld	s4,160(sp)
ffffffffc0200cf8:	7aaa                	ld	s5,168(sp)
ffffffffc0200cfa:	7b4a                	ld	s6,176(sp)
ffffffffc0200cfc:	7bea                	ld	s7,184(sp)
ffffffffc0200cfe:	6c0e                	ld	s8,192(sp)
ffffffffc0200d00:	6cae                	ld	s9,200(sp)
ffffffffc0200d02:	6d4e                	ld	s10,208(sp)
ffffffffc0200d04:	6dee                	ld	s11,216(sp)
ffffffffc0200d06:	7e0e                	ld	t3,224(sp)
ffffffffc0200d08:	7eae                	ld	t4,232(sp)
ffffffffc0200d0a:	7f4e                	ld	t5,240(sp)
ffffffffc0200d0c:	7fee                	ld	t6,248(sp)
ffffffffc0200d0e:	6142                	ld	sp,16(sp)
    # go back from supervisor call
    sret
ffffffffc0200d10:	10200073          	sret

ffffffffc0200d14 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200d14:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200d16:	bf45                	j	ffffffffc0200cc6 <__trapret>
ffffffffc0200d18:	0001                	nop

ffffffffc0200d1a <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200d1a:	00008797          	auipc	a5,0x8
ffffffffc0200d1e:	71678793          	addi	a5,a5,1814 # ffffffffc0209430 <free_area>
ffffffffc0200d22:	e79c                	sd	a5,8(a5)
ffffffffc0200d24:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200d26:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200d2a:	8082                	ret

ffffffffc0200d2c <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200d2c:	00008517          	auipc	a0,0x8
ffffffffc0200d30:	71456503          	lwu	a0,1812(a0) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200d34:	8082                	ret

ffffffffc0200d36 <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200d36:	711d                	addi	sp,sp,-96
ffffffffc0200d38:	e0ca                	sd	s2,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200d3a:	00008917          	auipc	s2,0x8
ffffffffc0200d3e:	6f690913          	addi	s2,s2,1782 # ffffffffc0209430 <free_area>
ffffffffc0200d42:	00893783          	ld	a5,8(s2)
ffffffffc0200d46:	ec86                	sd	ra,88(sp)
ffffffffc0200d48:	e8a2                	sd	s0,80(sp)
ffffffffc0200d4a:	e4a6                	sd	s1,72(sp)
ffffffffc0200d4c:	fc4e                	sd	s3,56(sp)
ffffffffc0200d4e:	f852                	sd	s4,48(sp)
ffffffffc0200d50:	f456                	sd	s5,40(sp)
ffffffffc0200d52:	f05a                	sd	s6,32(sp)
ffffffffc0200d54:	ec5e                	sd	s7,24(sp)
ffffffffc0200d56:	e862                	sd	s8,16(sp)
ffffffffc0200d58:	e466                	sd	s9,8(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200d5a:	2f278763          	beq	a5,s2,ffffffffc0201048 <default_check+0x312>
    int count = 0, total = 0;
ffffffffc0200d5e:	4401                	li	s0,0
ffffffffc0200d60:	4481                	li	s1,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200d62:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200d66:	8b09                	andi	a4,a4,2
ffffffffc0200d68:	2e070463          	beqz	a4,ffffffffc0201050 <default_check+0x31a>
        count ++, total += p->property;
ffffffffc0200d6c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200d70:	679c                	ld	a5,8(a5)
ffffffffc0200d72:	2485                	addiw	s1,s1,1
ffffffffc0200d74:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200d76:	ff2796e3          	bne	a5,s2,ffffffffc0200d62 <default_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc0200d7a:	89a2                	mv	s3,s0
ffffffffc0200d7c:	745000ef          	jal	ffffffffc0201cc0 <nr_free_pages>
ffffffffc0200d80:	73351863          	bne	a0,s3,ffffffffc02014b0 <default_check+0x77a>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200d84:	4505                	li	a0,1
ffffffffc0200d86:	6c9000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200d8a:	8a2a                	mv	s4,a0
ffffffffc0200d8c:	46050263          	beqz	a0,ffffffffc02011f0 <default_check+0x4ba>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200d90:	4505                	li	a0,1
ffffffffc0200d92:	6bd000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200d96:	89aa                	mv	s3,a0
ffffffffc0200d98:	72050c63          	beqz	a0,ffffffffc02014d0 <default_check+0x79a>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200d9c:	4505                	li	a0,1
ffffffffc0200d9e:	6b1000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200da2:	8aaa                	mv	s5,a0
ffffffffc0200da4:	4c050663          	beqz	a0,ffffffffc0201270 <default_check+0x53a>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200da8:	40aa07b3          	sub	a5,s4,a0
ffffffffc0200dac:	40a98733          	sub	a4,s3,a0
ffffffffc0200db0:	0017b793          	seqz	a5,a5
ffffffffc0200db4:	00173713          	seqz	a4,a4
ffffffffc0200db8:	8fd9                	or	a5,a5,a4
ffffffffc0200dba:	30079b63          	bnez	a5,ffffffffc02010d0 <default_check+0x39a>
ffffffffc0200dbe:	313a0963          	beq	s4,s3,ffffffffc02010d0 <default_check+0x39a>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200dc2:	000a2783          	lw	a5,0(s4)
ffffffffc0200dc6:	2a079563          	bnez	a5,ffffffffc0201070 <default_check+0x33a>
ffffffffc0200dca:	0009a783          	lw	a5,0(s3)
ffffffffc0200dce:	2a079163          	bnez	a5,ffffffffc0201070 <default_check+0x33a>
ffffffffc0200dd2:	411c                	lw	a5,0(a0)
ffffffffc0200dd4:	28079e63          	bnez	a5,ffffffffc0201070 <default_check+0x33a>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0200dd8:	0000c797          	auipc	a5,0xc
ffffffffc0200ddc:	6f87b783          	ld	a5,1784(a5) # ffffffffc020d4d0 <pages>
ffffffffc0200de0:	00005617          	auipc	a2,0x5
ffffffffc0200de4:	a8863603          	ld	a2,-1400(a2) # ffffffffc0205868 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200de8:	0000c697          	auipc	a3,0xc
ffffffffc0200dec:	6e06b683          	ld	a3,1760(a3) # ffffffffc020d4c8 <npage>
ffffffffc0200df0:	40fa0733          	sub	a4,s4,a5
ffffffffc0200df4:	8719                	srai	a4,a4,0x6
ffffffffc0200df6:	9732                	add	a4,a4,a2
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0200df8:	0732                	slli	a4,a4,0xc
ffffffffc0200dfa:	06b2                	slli	a3,a3,0xc
ffffffffc0200dfc:	2ad77a63          	bgeu	a4,a3,ffffffffc02010b0 <default_check+0x37a>
    return page - pages + nbase;
ffffffffc0200e00:	40f98733          	sub	a4,s3,a5
ffffffffc0200e04:	8719                	srai	a4,a4,0x6
ffffffffc0200e06:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200e08:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200e0a:	4ed77363          	bgeu	a4,a3,ffffffffc02012f0 <default_check+0x5ba>
    return page - pages + nbase;
ffffffffc0200e0e:	40f507b3          	sub	a5,a0,a5
ffffffffc0200e12:	8799                	srai	a5,a5,0x6
ffffffffc0200e14:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200e16:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200e18:	32d7fc63          	bgeu	a5,a3,ffffffffc0201150 <default_check+0x41a>
    assert(alloc_page() == NULL);
ffffffffc0200e1c:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200e1e:	00093c03          	ld	s8,0(s2)
ffffffffc0200e22:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc0200e26:	00008b17          	auipc	s6,0x8
ffffffffc0200e2a:	61ab2b03          	lw	s6,1562(s6) # ffffffffc0209440 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc0200e2e:	01293023          	sd	s2,0(s2)
ffffffffc0200e32:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc0200e36:	00008797          	auipc	a5,0x8
ffffffffc0200e3a:	6007a523          	sw	zero,1546(a5) # ffffffffc0209440 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200e3e:	611000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200e42:	2e051763          	bnez	a0,ffffffffc0201130 <default_check+0x3fa>
    free_page(p0);
ffffffffc0200e46:	8552                	mv	a0,s4
ffffffffc0200e48:	4585                	li	a1,1
ffffffffc0200e4a:	63f000ef          	jal	ffffffffc0201c88 <free_pages>
    free_page(p1);
ffffffffc0200e4e:	854e                	mv	a0,s3
ffffffffc0200e50:	4585                	li	a1,1
ffffffffc0200e52:	637000ef          	jal	ffffffffc0201c88 <free_pages>
    free_page(p2);
ffffffffc0200e56:	8556                	mv	a0,s5
ffffffffc0200e58:	4585                	li	a1,1
ffffffffc0200e5a:	62f000ef          	jal	ffffffffc0201c88 <free_pages>
    assert(nr_free == 3);
ffffffffc0200e5e:	00008717          	auipc	a4,0x8
ffffffffc0200e62:	5e272703          	lw	a4,1506(a4) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200e66:	478d                	li	a5,3
ffffffffc0200e68:	2af71463          	bne	a4,a5,ffffffffc0201110 <default_check+0x3da>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200e6c:	4505                	li	a0,1
ffffffffc0200e6e:	5e1000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200e72:	89aa                	mv	s3,a0
ffffffffc0200e74:	26050e63          	beqz	a0,ffffffffc02010f0 <default_check+0x3ba>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200e78:	4505                	li	a0,1
ffffffffc0200e7a:	5d5000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200e7e:	8aaa                	mv	s5,a0
ffffffffc0200e80:	3c050863          	beqz	a0,ffffffffc0201250 <default_check+0x51a>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200e84:	4505                	li	a0,1
ffffffffc0200e86:	5c9000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200e8a:	8a2a                	mv	s4,a0
ffffffffc0200e8c:	3a050263          	beqz	a0,ffffffffc0201230 <default_check+0x4fa>
    assert(alloc_page() == NULL);
ffffffffc0200e90:	4505                	li	a0,1
ffffffffc0200e92:	5bd000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200e96:	36051d63          	bnez	a0,ffffffffc0201210 <default_check+0x4da>
    free_page(p0);
ffffffffc0200e9a:	4585                	li	a1,1
ffffffffc0200e9c:	854e                	mv	a0,s3
ffffffffc0200e9e:	5eb000ef          	jal	ffffffffc0201c88 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200ea2:	00893783          	ld	a5,8(s2)
ffffffffc0200ea6:	1f278563          	beq	a5,s2,ffffffffc0201090 <default_check+0x35a>
    assert((p = alloc_page()) == p0);
ffffffffc0200eaa:	4505                	li	a0,1
ffffffffc0200eac:	5a3000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200eb0:	8caa                	mv	s9,a0
ffffffffc0200eb2:	30a99f63          	bne	s3,a0,ffffffffc02011d0 <default_check+0x49a>
    assert(alloc_page() == NULL);
ffffffffc0200eb6:	4505                	li	a0,1
ffffffffc0200eb8:	597000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200ebc:	2e051a63          	bnez	a0,ffffffffc02011b0 <default_check+0x47a>
    assert(nr_free == 0);
ffffffffc0200ec0:	00008797          	auipc	a5,0x8
ffffffffc0200ec4:	5807a783          	lw	a5,1408(a5) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200ec8:	2c079463          	bnez	a5,ffffffffc0201190 <default_check+0x45a>
    free_page(p);
ffffffffc0200ecc:	8566                	mv	a0,s9
ffffffffc0200ece:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200ed0:	01893023          	sd	s8,0(s2)
ffffffffc0200ed4:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc0200ed8:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc0200edc:	5ad000ef          	jal	ffffffffc0201c88 <free_pages>
    free_page(p1);
ffffffffc0200ee0:	8556                	mv	a0,s5
ffffffffc0200ee2:	4585                	li	a1,1
ffffffffc0200ee4:	5a5000ef          	jal	ffffffffc0201c88 <free_pages>
    free_page(p2);
ffffffffc0200ee8:	8552                	mv	a0,s4
ffffffffc0200eea:	4585                	li	a1,1
ffffffffc0200eec:	59d000ef          	jal	ffffffffc0201c88 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200ef0:	4515                	li	a0,5
ffffffffc0200ef2:	55d000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200ef6:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200ef8:	26050c63          	beqz	a0,ffffffffc0201170 <default_check+0x43a>
ffffffffc0200efc:	651c                	ld	a5,8(a0)
ffffffffc0200efe:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200f00:	8b85                	andi	a5,a5,1
ffffffffc0200f02:	54079763          	bnez	a5,ffffffffc0201450 <default_check+0x71a>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200f06:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200f08:	00093b83          	ld	s7,0(s2)
ffffffffc0200f0c:	00893b03          	ld	s6,8(s2)
ffffffffc0200f10:	01293023          	sd	s2,0(s2)
ffffffffc0200f14:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc0200f18:	537000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200f1c:	50051a63          	bnez	a0,ffffffffc0201430 <default_check+0x6fa>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0200f20:	08098a13          	addi	s4,s3,128
ffffffffc0200f24:	8552                	mv	a0,s4
ffffffffc0200f26:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0200f28:	00008c17          	auipc	s8,0x8
ffffffffc0200f2c:	518c2c03          	lw	s8,1304(s8) # ffffffffc0209440 <free_area+0x10>
    nr_free = 0;
ffffffffc0200f30:	00008797          	auipc	a5,0x8
ffffffffc0200f34:	5007a823          	sw	zero,1296(a5) # ffffffffc0209440 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0200f38:	551000ef          	jal	ffffffffc0201c88 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200f3c:	4511                	li	a0,4
ffffffffc0200f3e:	511000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200f42:	4c051763          	bnez	a0,ffffffffc0201410 <default_check+0x6da>
ffffffffc0200f46:	0889b783          	ld	a5,136(s3)
ffffffffc0200f4a:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0200f4c:	8b85                	andi	a5,a5,1
ffffffffc0200f4e:	4a078163          	beqz	a5,ffffffffc02013f0 <default_check+0x6ba>
ffffffffc0200f52:	0909a503          	lw	a0,144(s3)
ffffffffc0200f56:	478d                	li	a5,3
ffffffffc0200f58:	48f51c63          	bne	a0,a5,ffffffffc02013f0 <default_check+0x6ba>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0200f5c:	4f3000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200f60:	8aaa                	mv	s5,a0
ffffffffc0200f62:	46050763          	beqz	a0,ffffffffc02013d0 <default_check+0x69a>
    assert(alloc_page() == NULL);
ffffffffc0200f66:	4505                	li	a0,1
ffffffffc0200f68:	4e7000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200f6c:	44051263          	bnez	a0,ffffffffc02013b0 <default_check+0x67a>
    assert(p0 + 2 == p1);
ffffffffc0200f70:	435a1063          	bne	s4,s5,ffffffffc0201390 <default_check+0x65a>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0200f74:	4585                	li	a1,1
ffffffffc0200f76:	854e                	mv	a0,s3
ffffffffc0200f78:	511000ef          	jal	ffffffffc0201c88 <free_pages>
    free_pages(p1, 3);
ffffffffc0200f7c:	8552                	mv	a0,s4
ffffffffc0200f7e:	458d                	li	a1,3
ffffffffc0200f80:	509000ef          	jal	ffffffffc0201c88 <free_pages>
ffffffffc0200f84:	0089b783          	ld	a5,8(s3)
ffffffffc0200f88:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0200f8a:	8b85                	andi	a5,a5,1
ffffffffc0200f8c:	3e078263          	beqz	a5,ffffffffc0201370 <default_check+0x63a>
ffffffffc0200f90:	0109aa83          	lw	s5,16(s3)
ffffffffc0200f94:	4785                	li	a5,1
ffffffffc0200f96:	3cfa9d63          	bne	s5,a5,ffffffffc0201370 <default_check+0x63a>
ffffffffc0200f9a:	008a3783          	ld	a5,8(s4)
ffffffffc0200f9e:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0200fa0:	8b85                	andi	a5,a5,1
ffffffffc0200fa2:	3a078763          	beqz	a5,ffffffffc0201350 <default_check+0x61a>
ffffffffc0200fa6:	010a2703          	lw	a4,16(s4)
ffffffffc0200faa:	478d                	li	a5,3
ffffffffc0200fac:	3af71263          	bne	a4,a5,ffffffffc0201350 <default_check+0x61a>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0200fb0:	8556                	mv	a0,s5
ffffffffc0200fb2:	49d000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200fb6:	36a99d63          	bne	s3,a0,ffffffffc0201330 <default_check+0x5fa>
    free_page(p0);
ffffffffc0200fba:	85d6                	mv	a1,s5
ffffffffc0200fbc:	4cd000ef          	jal	ffffffffc0201c88 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0200fc0:	4509                	li	a0,2
ffffffffc0200fc2:	48d000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200fc6:	34aa1563          	bne	s4,a0,ffffffffc0201310 <default_check+0x5da>

    free_pages(p0, 2);
ffffffffc0200fca:	4589                	li	a1,2
ffffffffc0200fcc:	4bd000ef          	jal	ffffffffc0201c88 <free_pages>
    free_page(p2);
ffffffffc0200fd0:	04098513          	addi	a0,s3,64
ffffffffc0200fd4:	85d6                	mv	a1,s5
ffffffffc0200fd6:	4b3000ef          	jal	ffffffffc0201c88 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200fda:	4515                	li	a0,5
ffffffffc0200fdc:	473000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200fe0:	89aa                	mv	s3,a0
ffffffffc0200fe2:	48050763          	beqz	a0,ffffffffc0201470 <default_check+0x73a>
    assert(alloc_page() == NULL);
ffffffffc0200fe6:	8556                	mv	a0,s5
ffffffffc0200fe8:	467000ef          	jal	ffffffffc0201c4e <alloc_pages>
ffffffffc0200fec:	2e051263          	bnez	a0,ffffffffc02012d0 <default_check+0x59a>

    assert(nr_free == 0);
ffffffffc0200ff0:	00008797          	auipc	a5,0x8
ffffffffc0200ff4:	4507a783          	lw	a5,1104(a5) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200ff8:	2a079c63          	bnez	a5,ffffffffc02012b0 <default_check+0x57a>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200ffc:	854e                	mv	a0,s3
ffffffffc0200ffe:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc0201000:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc0201004:	01793023          	sd	s7,0(s2)
ffffffffc0201008:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc020100c:	47d000ef          	jal	ffffffffc0201c88 <free_pages>
    return listelm->next;
ffffffffc0201010:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201014:	01278963          	beq	a5,s2,ffffffffc0201026 <default_check+0x2f0>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0201018:	ff87a703          	lw	a4,-8(a5)
ffffffffc020101c:	679c                	ld	a5,8(a5)
ffffffffc020101e:	34fd                	addiw	s1,s1,-1
ffffffffc0201020:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201022:	ff279be3          	bne	a5,s2,ffffffffc0201018 <default_check+0x2e2>
    }
    assert(count == 0);
ffffffffc0201026:	26049563          	bnez	s1,ffffffffc0201290 <default_check+0x55a>
    assert(total == 0);
ffffffffc020102a:	46041363          	bnez	s0,ffffffffc0201490 <default_check+0x75a>
}
ffffffffc020102e:	60e6                	ld	ra,88(sp)
ffffffffc0201030:	6446                	ld	s0,80(sp)
ffffffffc0201032:	64a6                	ld	s1,72(sp)
ffffffffc0201034:	6906                	ld	s2,64(sp)
ffffffffc0201036:	79e2                	ld	s3,56(sp)
ffffffffc0201038:	7a42                	ld	s4,48(sp)
ffffffffc020103a:	7aa2                	ld	s5,40(sp)
ffffffffc020103c:	7b02                	ld	s6,32(sp)
ffffffffc020103e:	6be2                	ld	s7,24(sp)
ffffffffc0201040:	6c42                	ld	s8,16(sp)
ffffffffc0201042:	6ca2                	ld	s9,8(sp)
ffffffffc0201044:	6125                	addi	sp,sp,96
ffffffffc0201046:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201048:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc020104a:	4401                	li	s0,0
ffffffffc020104c:	4481                	li	s1,0
ffffffffc020104e:	b33d                	j	ffffffffc0200d7c <default_check+0x46>
        assert(PageProperty(p));
ffffffffc0201050:	00003697          	auipc	a3,0x3
ffffffffc0201054:	6c868693          	addi	a3,a3,1736 # ffffffffc0204718 <etext+0x8d0>
ffffffffc0201058:	00003617          	auipc	a2,0x3
ffffffffc020105c:	6d060613          	addi	a2,a2,1744 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201060:	0f000593          	li	a1,240
ffffffffc0201064:	00003517          	auipc	a0,0x3
ffffffffc0201068:	6dc50513          	addi	a0,a0,1756 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020106c:	b9aff0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201070:	00003697          	auipc	a3,0x3
ffffffffc0201074:	79068693          	addi	a3,a3,1936 # ffffffffc0204800 <etext+0x9b8>
ffffffffc0201078:	00003617          	auipc	a2,0x3
ffffffffc020107c:	6b060613          	addi	a2,a2,1712 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201080:	0be00593          	li	a1,190
ffffffffc0201084:	00003517          	auipc	a0,0x3
ffffffffc0201088:	6bc50513          	addi	a0,a0,1724 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020108c:	b7aff0ef          	jal	ffffffffc0200406 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201090:	00004697          	auipc	a3,0x4
ffffffffc0201094:	83868693          	addi	a3,a3,-1992 # ffffffffc02048c8 <etext+0xa80>
ffffffffc0201098:	00003617          	auipc	a2,0x3
ffffffffc020109c:	69060613          	addi	a2,a2,1680 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02010a0:	0d900593          	li	a1,217
ffffffffc02010a4:	00003517          	auipc	a0,0x3
ffffffffc02010a8:	69c50513          	addi	a0,a0,1692 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02010ac:	b5aff0ef          	jal	ffffffffc0200406 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02010b0:	00003697          	auipc	a3,0x3
ffffffffc02010b4:	79068693          	addi	a3,a3,1936 # ffffffffc0204840 <etext+0x9f8>
ffffffffc02010b8:	00003617          	auipc	a2,0x3
ffffffffc02010bc:	67060613          	addi	a2,a2,1648 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02010c0:	0c000593          	li	a1,192
ffffffffc02010c4:	00003517          	auipc	a0,0x3
ffffffffc02010c8:	67c50513          	addi	a0,a0,1660 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02010cc:	b3aff0ef          	jal	ffffffffc0200406 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02010d0:	00003697          	auipc	a3,0x3
ffffffffc02010d4:	70868693          	addi	a3,a3,1800 # ffffffffc02047d8 <etext+0x990>
ffffffffc02010d8:	00003617          	auipc	a2,0x3
ffffffffc02010dc:	65060613          	addi	a2,a2,1616 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02010e0:	0bd00593          	li	a1,189
ffffffffc02010e4:	00003517          	auipc	a0,0x3
ffffffffc02010e8:	65c50513          	addi	a0,a0,1628 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02010ec:	b1aff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02010f0:	00003697          	auipc	a3,0x3
ffffffffc02010f4:	68868693          	addi	a3,a3,1672 # ffffffffc0204778 <etext+0x930>
ffffffffc02010f8:	00003617          	auipc	a2,0x3
ffffffffc02010fc:	63060613          	addi	a2,a2,1584 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201100:	0d200593          	li	a1,210
ffffffffc0201104:	00003517          	auipc	a0,0x3
ffffffffc0201108:	63c50513          	addi	a0,a0,1596 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020110c:	afaff0ef          	jal	ffffffffc0200406 <__panic>
    assert(nr_free == 3);
ffffffffc0201110:	00003697          	auipc	a3,0x3
ffffffffc0201114:	7a868693          	addi	a3,a3,1960 # ffffffffc02048b8 <etext+0xa70>
ffffffffc0201118:	00003617          	auipc	a2,0x3
ffffffffc020111c:	61060613          	addi	a2,a2,1552 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201120:	0d000593          	li	a1,208
ffffffffc0201124:	00003517          	auipc	a0,0x3
ffffffffc0201128:	61c50513          	addi	a0,a0,1564 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020112c:	adaff0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201130:	00003697          	auipc	a3,0x3
ffffffffc0201134:	77068693          	addi	a3,a3,1904 # ffffffffc02048a0 <etext+0xa58>
ffffffffc0201138:	00003617          	auipc	a2,0x3
ffffffffc020113c:	5f060613          	addi	a2,a2,1520 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201140:	0cb00593          	li	a1,203
ffffffffc0201144:	00003517          	auipc	a0,0x3
ffffffffc0201148:	5fc50513          	addi	a0,a0,1532 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020114c:	abaff0ef          	jal	ffffffffc0200406 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201150:	00003697          	auipc	a3,0x3
ffffffffc0201154:	73068693          	addi	a3,a3,1840 # ffffffffc0204880 <etext+0xa38>
ffffffffc0201158:	00003617          	auipc	a2,0x3
ffffffffc020115c:	5d060613          	addi	a2,a2,1488 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201160:	0c200593          	li	a1,194
ffffffffc0201164:	00003517          	auipc	a0,0x3
ffffffffc0201168:	5dc50513          	addi	a0,a0,1500 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020116c:	a9aff0ef          	jal	ffffffffc0200406 <__panic>
    assert(p0 != NULL);
ffffffffc0201170:	00003697          	auipc	a3,0x3
ffffffffc0201174:	7a068693          	addi	a3,a3,1952 # ffffffffc0204910 <etext+0xac8>
ffffffffc0201178:	00003617          	auipc	a2,0x3
ffffffffc020117c:	5b060613          	addi	a2,a2,1456 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201180:	0f800593          	li	a1,248
ffffffffc0201184:	00003517          	auipc	a0,0x3
ffffffffc0201188:	5bc50513          	addi	a0,a0,1468 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020118c:	a7aff0ef          	jal	ffffffffc0200406 <__panic>
    assert(nr_free == 0);
ffffffffc0201190:	00003697          	auipc	a3,0x3
ffffffffc0201194:	77068693          	addi	a3,a3,1904 # ffffffffc0204900 <etext+0xab8>
ffffffffc0201198:	00003617          	auipc	a2,0x3
ffffffffc020119c:	59060613          	addi	a2,a2,1424 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02011a0:	0df00593          	li	a1,223
ffffffffc02011a4:	00003517          	auipc	a0,0x3
ffffffffc02011a8:	59c50513          	addi	a0,a0,1436 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02011ac:	a5aff0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011b0:	00003697          	auipc	a3,0x3
ffffffffc02011b4:	6f068693          	addi	a3,a3,1776 # ffffffffc02048a0 <etext+0xa58>
ffffffffc02011b8:	00003617          	auipc	a2,0x3
ffffffffc02011bc:	57060613          	addi	a2,a2,1392 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02011c0:	0dd00593          	li	a1,221
ffffffffc02011c4:	00003517          	auipc	a0,0x3
ffffffffc02011c8:	57c50513          	addi	a0,a0,1404 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02011cc:	a3aff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02011d0:	00003697          	auipc	a3,0x3
ffffffffc02011d4:	71068693          	addi	a3,a3,1808 # ffffffffc02048e0 <etext+0xa98>
ffffffffc02011d8:	00003617          	auipc	a2,0x3
ffffffffc02011dc:	55060613          	addi	a2,a2,1360 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02011e0:	0dc00593          	li	a1,220
ffffffffc02011e4:	00003517          	auipc	a0,0x3
ffffffffc02011e8:	55c50513          	addi	a0,a0,1372 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02011ec:	a1aff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02011f0:	00003697          	auipc	a3,0x3
ffffffffc02011f4:	58868693          	addi	a3,a3,1416 # ffffffffc0204778 <etext+0x930>
ffffffffc02011f8:	00003617          	auipc	a2,0x3
ffffffffc02011fc:	53060613          	addi	a2,a2,1328 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201200:	0b900593          	li	a1,185
ffffffffc0201204:	00003517          	auipc	a0,0x3
ffffffffc0201208:	53c50513          	addi	a0,a0,1340 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020120c:	9faff0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201210:	00003697          	auipc	a3,0x3
ffffffffc0201214:	69068693          	addi	a3,a3,1680 # ffffffffc02048a0 <etext+0xa58>
ffffffffc0201218:	00003617          	auipc	a2,0x3
ffffffffc020121c:	51060613          	addi	a2,a2,1296 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201220:	0d600593          	li	a1,214
ffffffffc0201224:	00003517          	auipc	a0,0x3
ffffffffc0201228:	51c50513          	addi	a0,a0,1308 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020122c:	9daff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201230:	00003697          	auipc	a3,0x3
ffffffffc0201234:	58868693          	addi	a3,a3,1416 # ffffffffc02047b8 <etext+0x970>
ffffffffc0201238:	00003617          	auipc	a2,0x3
ffffffffc020123c:	4f060613          	addi	a2,a2,1264 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201240:	0d400593          	li	a1,212
ffffffffc0201244:	00003517          	auipc	a0,0x3
ffffffffc0201248:	4fc50513          	addi	a0,a0,1276 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020124c:	9baff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201250:	00003697          	auipc	a3,0x3
ffffffffc0201254:	54868693          	addi	a3,a3,1352 # ffffffffc0204798 <etext+0x950>
ffffffffc0201258:	00003617          	auipc	a2,0x3
ffffffffc020125c:	4d060613          	addi	a2,a2,1232 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201260:	0d300593          	li	a1,211
ffffffffc0201264:	00003517          	auipc	a0,0x3
ffffffffc0201268:	4dc50513          	addi	a0,a0,1244 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020126c:	99aff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201270:	00003697          	auipc	a3,0x3
ffffffffc0201274:	54868693          	addi	a3,a3,1352 # ffffffffc02047b8 <etext+0x970>
ffffffffc0201278:	00003617          	auipc	a2,0x3
ffffffffc020127c:	4b060613          	addi	a2,a2,1200 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201280:	0bb00593          	li	a1,187
ffffffffc0201284:	00003517          	auipc	a0,0x3
ffffffffc0201288:	4bc50513          	addi	a0,a0,1212 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020128c:	97aff0ef          	jal	ffffffffc0200406 <__panic>
    assert(count == 0);
ffffffffc0201290:	00003697          	auipc	a3,0x3
ffffffffc0201294:	7d068693          	addi	a3,a3,2000 # ffffffffc0204a60 <etext+0xc18>
ffffffffc0201298:	00003617          	auipc	a2,0x3
ffffffffc020129c:	49060613          	addi	a2,a2,1168 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02012a0:	12500593          	li	a1,293
ffffffffc02012a4:	00003517          	auipc	a0,0x3
ffffffffc02012a8:	49c50513          	addi	a0,a0,1180 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02012ac:	95aff0ef          	jal	ffffffffc0200406 <__panic>
    assert(nr_free == 0);
ffffffffc02012b0:	00003697          	auipc	a3,0x3
ffffffffc02012b4:	65068693          	addi	a3,a3,1616 # ffffffffc0204900 <etext+0xab8>
ffffffffc02012b8:	00003617          	auipc	a2,0x3
ffffffffc02012bc:	47060613          	addi	a2,a2,1136 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02012c0:	11a00593          	li	a1,282
ffffffffc02012c4:	00003517          	auipc	a0,0x3
ffffffffc02012c8:	47c50513          	addi	a0,a0,1148 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02012cc:	93aff0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012d0:	00003697          	auipc	a3,0x3
ffffffffc02012d4:	5d068693          	addi	a3,a3,1488 # ffffffffc02048a0 <etext+0xa58>
ffffffffc02012d8:	00003617          	auipc	a2,0x3
ffffffffc02012dc:	45060613          	addi	a2,a2,1104 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02012e0:	11800593          	li	a1,280
ffffffffc02012e4:	00003517          	auipc	a0,0x3
ffffffffc02012e8:	45c50513          	addi	a0,a0,1116 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02012ec:	91aff0ef          	jal	ffffffffc0200406 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02012f0:	00003697          	auipc	a3,0x3
ffffffffc02012f4:	57068693          	addi	a3,a3,1392 # ffffffffc0204860 <etext+0xa18>
ffffffffc02012f8:	00003617          	auipc	a2,0x3
ffffffffc02012fc:	43060613          	addi	a2,a2,1072 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201300:	0c100593          	li	a1,193
ffffffffc0201304:	00003517          	auipc	a0,0x3
ffffffffc0201308:	43c50513          	addi	a0,a0,1084 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020130c:	8faff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201310:	00003697          	auipc	a3,0x3
ffffffffc0201314:	71068693          	addi	a3,a3,1808 # ffffffffc0204a20 <etext+0xbd8>
ffffffffc0201318:	00003617          	auipc	a2,0x3
ffffffffc020131c:	41060613          	addi	a2,a2,1040 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201320:	11200593          	li	a1,274
ffffffffc0201324:	00003517          	auipc	a0,0x3
ffffffffc0201328:	41c50513          	addi	a0,a0,1052 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020132c:	8daff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201330:	00003697          	auipc	a3,0x3
ffffffffc0201334:	6d068693          	addi	a3,a3,1744 # ffffffffc0204a00 <etext+0xbb8>
ffffffffc0201338:	00003617          	auipc	a2,0x3
ffffffffc020133c:	3f060613          	addi	a2,a2,1008 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201340:	11000593          	li	a1,272
ffffffffc0201344:	00003517          	auipc	a0,0x3
ffffffffc0201348:	3fc50513          	addi	a0,a0,1020 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020134c:	8baff0ef          	jal	ffffffffc0200406 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201350:	00003697          	auipc	a3,0x3
ffffffffc0201354:	68868693          	addi	a3,a3,1672 # ffffffffc02049d8 <etext+0xb90>
ffffffffc0201358:	00003617          	auipc	a2,0x3
ffffffffc020135c:	3d060613          	addi	a2,a2,976 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201360:	10e00593          	li	a1,270
ffffffffc0201364:	00003517          	auipc	a0,0x3
ffffffffc0201368:	3dc50513          	addi	a0,a0,988 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020136c:	89aff0ef          	jal	ffffffffc0200406 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201370:	00003697          	auipc	a3,0x3
ffffffffc0201374:	64068693          	addi	a3,a3,1600 # ffffffffc02049b0 <etext+0xb68>
ffffffffc0201378:	00003617          	auipc	a2,0x3
ffffffffc020137c:	3b060613          	addi	a2,a2,944 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201380:	10d00593          	li	a1,269
ffffffffc0201384:	00003517          	auipc	a0,0x3
ffffffffc0201388:	3bc50513          	addi	a0,a0,956 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020138c:	87aff0ef          	jal	ffffffffc0200406 <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201390:	00003697          	auipc	a3,0x3
ffffffffc0201394:	61068693          	addi	a3,a3,1552 # ffffffffc02049a0 <etext+0xb58>
ffffffffc0201398:	00003617          	auipc	a2,0x3
ffffffffc020139c:	39060613          	addi	a2,a2,912 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02013a0:	10800593          	li	a1,264
ffffffffc02013a4:	00003517          	auipc	a0,0x3
ffffffffc02013a8:	39c50513          	addi	a0,a0,924 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02013ac:	85aff0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013b0:	00003697          	auipc	a3,0x3
ffffffffc02013b4:	4f068693          	addi	a3,a3,1264 # ffffffffc02048a0 <etext+0xa58>
ffffffffc02013b8:	00003617          	auipc	a2,0x3
ffffffffc02013bc:	37060613          	addi	a2,a2,880 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02013c0:	10700593          	li	a1,263
ffffffffc02013c4:	00003517          	auipc	a0,0x3
ffffffffc02013c8:	37c50513          	addi	a0,a0,892 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02013cc:	83aff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02013d0:	00003697          	auipc	a3,0x3
ffffffffc02013d4:	5b068693          	addi	a3,a3,1456 # ffffffffc0204980 <etext+0xb38>
ffffffffc02013d8:	00003617          	auipc	a2,0x3
ffffffffc02013dc:	35060613          	addi	a2,a2,848 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02013e0:	10600593          	li	a1,262
ffffffffc02013e4:	00003517          	auipc	a0,0x3
ffffffffc02013e8:	35c50513          	addi	a0,a0,860 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02013ec:	81aff0ef          	jal	ffffffffc0200406 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02013f0:	00003697          	auipc	a3,0x3
ffffffffc02013f4:	56068693          	addi	a3,a3,1376 # ffffffffc0204950 <etext+0xb08>
ffffffffc02013f8:	00003617          	auipc	a2,0x3
ffffffffc02013fc:	33060613          	addi	a2,a2,816 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201400:	10500593          	li	a1,261
ffffffffc0201404:	00003517          	auipc	a0,0x3
ffffffffc0201408:	33c50513          	addi	a0,a0,828 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020140c:	ffbfe0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201410:	00003697          	auipc	a3,0x3
ffffffffc0201414:	52868693          	addi	a3,a3,1320 # ffffffffc0204938 <etext+0xaf0>
ffffffffc0201418:	00003617          	auipc	a2,0x3
ffffffffc020141c:	31060613          	addi	a2,a2,784 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201420:	10400593          	li	a1,260
ffffffffc0201424:	00003517          	auipc	a0,0x3
ffffffffc0201428:	31c50513          	addi	a0,a0,796 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020142c:	fdbfe0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201430:	00003697          	auipc	a3,0x3
ffffffffc0201434:	47068693          	addi	a3,a3,1136 # ffffffffc02048a0 <etext+0xa58>
ffffffffc0201438:	00003617          	auipc	a2,0x3
ffffffffc020143c:	2f060613          	addi	a2,a2,752 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201440:	0fe00593          	li	a1,254
ffffffffc0201444:	00003517          	auipc	a0,0x3
ffffffffc0201448:	2fc50513          	addi	a0,a0,764 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020144c:	fbbfe0ef          	jal	ffffffffc0200406 <__panic>
    assert(!PageProperty(p0));
ffffffffc0201450:	00003697          	auipc	a3,0x3
ffffffffc0201454:	4d068693          	addi	a3,a3,1232 # ffffffffc0204920 <etext+0xad8>
ffffffffc0201458:	00003617          	auipc	a2,0x3
ffffffffc020145c:	2d060613          	addi	a2,a2,720 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201460:	0f900593          	li	a1,249
ffffffffc0201464:	00003517          	auipc	a0,0x3
ffffffffc0201468:	2dc50513          	addi	a0,a0,732 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020146c:	f9bfe0ef          	jal	ffffffffc0200406 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201470:	00003697          	auipc	a3,0x3
ffffffffc0201474:	5d068693          	addi	a3,a3,1488 # ffffffffc0204a40 <etext+0xbf8>
ffffffffc0201478:	00003617          	auipc	a2,0x3
ffffffffc020147c:	2b060613          	addi	a2,a2,688 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201480:	11700593          	li	a1,279
ffffffffc0201484:	00003517          	auipc	a0,0x3
ffffffffc0201488:	2bc50513          	addi	a0,a0,700 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020148c:	f7bfe0ef          	jal	ffffffffc0200406 <__panic>
    assert(total == 0);
ffffffffc0201490:	00003697          	auipc	a3,0x3
ffffffffc0201494:	5e068693          	addi	a3,a3,1504 # ffffffffc0204a70 <etext+0xc28>
ffffffffc0201498:	00003617          	auipc	a2,0x3
ffffffffc020149c:	29060613          	addi	a2,a2,656 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02014a0:	12600593          	li	a1,294
ffffffffc02014a4:	00003517          	auipc	a0,0x3
ffffffffc02014a8:	29c50513          	addi	a0,a0,668 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02014ac:	f5bfe0ef          	jal	ffffffffc0200406 <__panic>
    assert(total == nr_free_pages());
ffffffffc02014b0:	00003697          	auipc	a3,0x3
ffffffffc02014b4:	2a868693          	addi	a3,a3,680 # ffffffffc0204758 <etext+0x910>
ffffffffc02014b8:	00003617          	auipc	a2,0x3
ffffffffc02014bc:	27060613          	addi	a2,a2,624 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02014c0:	0f300593          	li	a1,243
ffffffffc02014c4:	00003517          	auipc	a0,0x3
ffffffffc02014c8:	27c50513          	addi	a0,a0,636 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02014cc:	f3bfe0ef          	jal	ffffffffc0200406 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02014d0:	00003697          	auipc	a3,0x3
ffffffffc02014d4:	2c868693          	addi	a3,a3,712 # ffffffffc0204798 <etext+0x950>
ffffffffc02014d8:	00003617          	auipc	a2,0x3
ffffffffc02014dc:	25060613          	addi	a2,a2,592 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02014e0:	0ba00593          	li	a1,186
ffffffffc02014e4:	00003517          	auipc	a0,0x3
ffffffffc02014e8:	25c50513          	addi	a0,a0,604 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02014ec:	f1bfe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc02014f0 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc02014f0:	1141                	addi	sp,sp,-16
ffffffffc02014f2:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02014f4:	14058663          	beqz	a1,ffffffffc0201640 <default_free_pages+0x150>
    for (; p != base + n; p ++) {
ffffffffc02014f8:	00659713          	slli	a4,a1,0x6
ffffffffc02014fc:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201500:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc0201502:	c30d                	beqz	a4,ffffffffc0201524 <default_free_pages+0x34>
ffffffffc0201504:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201506:	8b05                	andi	a4,a4,1
ffffffffc0201508:	10071c63          	bnez	a4,ffffffffc0201620 <default_free_pages+0x130>
ffffffffc020150c:	6798                	ld	a4,8(a5)
ffffffffc020150e:	8b09                	andi	a4,a4,2
ffffffffc0201510:	10071863          	bnez	a4,ffffffffc0201620 <default_free_pages+0x130>
        p->flags = 0;
ffffffffc0201514:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc0201518:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc020151c:	04078793          	addi	a5,a5,64
ffffffffc0201520:	fed792e3          	bne	a5,a3,ffffffffc0201504 <default_free_pages+0x14>
    base->property = n;
ffffffffc0201524:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201526:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020152a:	4789                	li	a5,2
ffffffffc020152c:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201530:	00008717          	auipc	a4,0x8
ffffffffc0201534:	f1072703          	lw	a4,-240(a4) # ffffffffc0209440 <free_area+0x10>
ffffffffc0201538:	00008697          	auipc	a3,0x8
ffffffffc020153c:	ef868693          	addi	a3,a3,-264 # ffffffffc0209430 <free_area>
    return list->next == list;
ffffffffc0201540:	669c                	ld	a5,8(a3)
ffffffffc0201542:	9f2d                	addw	a4,a4,a1
ffffffffc0201544:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201546:	0ad78163          	beq	a5,a3,ffffffffc02015e8 <default_free_pages+0xf8>
            struct Page* page = le2page(le, page_link);
ffffffffc020154a:	fe878713          	addi	a4,a5,-24
ffffffffc020154e:	4581                	li	a1,0
ffffffffc0201550:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0201554:	00e56a63          	bltu	a0,a4,ffffffffc0201568 <default_free_pages+0x78>
    return listelm->next;
ffffffffc0201558:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020155a:	04d70c63          	beq	a4,a3,ffffffffc02015b2 <default_free_pages+0xc2>
    struct Page *p = base;
ffffffffc020155e:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201560:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201564:	fee57ae3          	bgeu	a0,a4,ffffffffc0201558 <default_free_pages+0x68>
ffffffffc0201568:	c199                	beqz	a1,ffffffffc020156e <default_free_pages+0x7e>
ffffffffc020156a:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020156e:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201570:	e390                	sd	a2,0(a5)
ffffffffc0201572:	e710                	sd	a2,8(a4)
    elm->next = next;
    elm->prev = prev;
ffffffffc0201574:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0201576:	f11c                	sd	a5,32(a0)
    if (le != &free_list) {
ffffffffc0201578:	00d70d63          	beq	a4,a3,ffffffffc0201592 <default_free_pages+0xa2>
        if (p + p->property == base) {
ffffffffc020157c:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201580:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base) {
ffffffffc0201584:	02059813          	slli	a6,a1,0x20
ffffffffc0201588:	01a85793          	srli	a5,a6,0x1a
ffffffffc020158c:	97b2                	add	a5,a5,a2
ffffffffc020158e:	02f50c63          	beq	a0,a5,ffffffffc02015c6 <default_free_pages+0xd6>
    return listelm->next;
ffffffffc0201592:	711c                	ld	a5,32(a0)
    if (le != &free_list) {
ffffffffc0201594:	00d78c63          	beq	a5,a3,ffffffffc02015ac <default_free_pages+0xbc>
        if (base + base->property == p) {
ffffffffc0201598:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc020159a:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p) {
ffffffffc020159e:	02061593          	slli	a1,a2,0x20
ffffffffc02015a2:	01a5d713          	srli	a4,a1,0x1a
ffffffffc02015a6:	972a                	add	a4,a4,a0
ffffffffc02015a8:	04e68c63          	beq	a3,a4,ffffffffc0201600 <default_free_pages+0x110>
}
ffffffffc02015ac:	60a2                	ld	ra,8(sp)
ffffffffc02015ae:	0141                	addi	sp,sp,16
ffffffffc02015b0:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02015b2:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02015b4:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02015b6:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02015b8:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc02015ba:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc02015bc:	02d70f63          	beq	a4,a3,ffffffffc02015fa <default_free_pages+0x10a>
ffffffffc02015c0:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc02015c2:	87ba                	mv	a5,a4
ffffffffc02015c4:	bf71                	j	ffffffffc0201560 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc02015c6:	491c                	lw	a5,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02015c8:	5875                	li	a6,-3
ffffffffc02015ca:	9fad                	addw	a5,a5,a1
ffffffffc02015cc:	fef72c23          	sw	a5,-8(a4)
ffffffffc02015d0:	6108b02f          	amoand.d	zero,a6,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc02015d4:	01853803          	ld	a6,24(a0)
ffffffffc02015d8:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc02015da:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02015dc:	00b83423          	sd	a1,8(a6) # ff0008 <kern_entry-0xffffffffbf20fff8>
    return listelm->next;
ffffffffc02015e0:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc02015e2:	0105b023          	sd	a6,0(a1)
ffffffffc02015e6:	b77d                	j	ffffffffc0201594 <default_free_pages+0xa4>
}
ffffffffc02015e8:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc02015ea:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc02015ee:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02015f0:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc02015f2:	e398                	sd	a4,0(a5)
ffffffffc02015f4:	e798                	sd	a4,8(a5)
}
ffffffffc02015f6:	0141                	addi	sp,sp,16
ffffffffc02015f8:	8082                	ret
ffffffffc02015fa:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc02015fc:	873e                	mv	a4,a5
ffffffffc02015fe:	bfad                	j	ffffffffc0201578 <default_free_pages+0x88>
            base->property += p->property;
ffffffffc0201600:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201604:	56f5                	li	a3,-3
ffffffffc0201606:	9f31                	addw	a4,a4,a2
ffffffffc0201608:	c918                	sw	a4,16(a0)
ffffffffc020160a:	ff078713          	addi	a4,a5,-16
ffffffffc020160e:	60d7302f          	amoand.d	zero,a3,(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201612:	6398                	ld	a4,0(a5)
ffffffffc0201614:	679c                	ld	a5,8(a5)
}
ffffffffc0201616:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201618:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020161a:	e398                	sd	a4,0(a5)
ffffffffc020161c:	0141                	addi	sp,sp,16
ffffffffc020161e:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201620:	00003697          	auipc	a3,0x3
ffffffffc0201624:	46868693          	addi	a3,a3,1128 # ffffffffc0204a88 <etext+0xc40>
ffffffffc0201628:	00003617          	auipc	a2,0x3
ffffffffc020162c:	10060613          	addi	a2,a2,256 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201630:	08300593          	li	a1,131
ffffffffc0201634:	00003517          	auipc	a0,0x3
ffffffffc0201638:	10c50513          	addi	a0,a0,268 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020163c:	dcbfe0ef          	jal	ffffffffc0200406 <__panic>
    assert(n > 0);
ffffffffc0201640:	00003697          	auipc	a3,0x3
ffffffffc0201644:	44068693          	addi	a3,a3,1088 # ffffffffc0204a80 <etext+0xc38>
ffffffffc0201648:	00003617          	auipc	a2,0x3
ffffffffc020164c:	0e060613          	addi	a2,a2,224 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201650:	08000593          	li	a1,128
ffffffffc0201654:	00003517          	auipc	a0,0x3
ffffffffc0201658:	0ec50513          	addi	a0,a0,236 # ffffffffc0204740 <etext+0x8f8>
ffffffffc020165c:	dabfe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201660 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201660:	c951                	beqz	a0,ffffffffc02016f4 <default_alloc_pages+0x94>
    if (n > nr_free) {
ffffffffc0201662:	00008597          	auipc	a1,0x8
ffffffffc0201666:	dde5a583          	lw	a1,-546(a1) # ffffffffc0209440 <free_area+0x10>
ffffffffc020166a:	86aa                	mv	a3,a0
ffffffffc020166c:	02059793          	slli	a5,a1,0x20
ffffffffc0201670:	9381                	srli	a5,a5,0x20
ffffffffc0201672:	00a7ef63          	bltu	a5,a0,ffffffffc0201690 <default_alloc_pages+0x30>
    list_entry_t *le = &free_list;
ffffffffc0201676:	00008617          	auipc	a2,0x8
ffffffffc020167a:	dba60613          	addi	a2,a2,-582 # ffffffffc0209430 <free_area>
ffffffffc020167e:	87b2                	mv	a5,a2
ffffffffc0201680:	a029                	j	ffffffffc020168a <default_alloc_pages+0x2a>
        if (p->property >= n) {
ffffffffc0201682:	ff87e703          	lwu	a4,-8(a5)
ffffffffc0201686:	00d77763          	bgeu	a4,a3,ffffffffc0201694 <default_alloc_pages+0x34>
    return listelm->next;
ffffffffc020168a:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc020168c:	fec79be3          	bne	a5,a2,ffffffffc0201682 <default_alloc_pages+0x22>
        return NULL;
ffffffffc0201690:	4501                	li	a0,0
}
ffffffffc0201692:	8082                	ret
        if (page->property > n) {
ffffffffc0201694:	ff87a883          	lw	a7,-8(a5)
    return listelm->prev;
ffffffffc0201698:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc020169c:	6798                	ld	a4,8(a5)
ffffffffc020169e:	02089313          	slli	t1,a7,0x20
ffffffffc02016a2:	02035313          	srli	t1,t1,0x20
    prev->next = next;
ffffffffc02016a6:	00e83423          	sd	a4,8(a6)
    next->prev = prev;
ffffffffc02016aa:	01073023          	sd	a6,0(a4)
        struct Page *p = le2page(le, page_link);
ffffffffc02016ae:	fe878513          	addi	a0,a5,-24
        if (page->property > n) {
ffffffffc02016b2:	0266fa63          	bgeu	a3,t1,ffffffffc02016e6 <default_alloc_pages+0x86>
            struct Page *p = page + n;
ffffffffc02016b6:	00669713          	slli	a4,a3,0x6
            p->property = page->property - n;
ffffffffc02016ba:	40d888bb          	subw	a7,a7,a3
            struct Page *p = page + n;
ffffffffc02016be:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc02016c0:	01172823          	sw	a7,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02016c4:	00870313          	addi	t1,a4,8
ffffffffc02016c8:	4889                	li	a7,2
ffffffffc02016ca:	4113302f          	amoor.d	zero,a7,(t1)
    __list_add(elm, listelm, listelm->next);
ffffffffc02016ce:	00883883          	ld	a7,8(a6)
            list_add(prev, &(p->page_link));
ffffffffc02016d2:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc02016d6:	0068b023          	sd	t1,0(a7)
ffffffffc02016da:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc02016de:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc02016e2:	01073c23          	sd	a6,24(a4)
        nr_free -= n;
ffffffffc02016e6:	9d95                	subw	a1,a1,a3
ffffffffc02016e8:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02016ea:	5775                	li	a4,-3
ffffffffc02016ec:	17c1                	addi	a5,a5,-16
ffffffffc02016ee:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc02016f2:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc02016f4:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02016f6:	00003697          	auipc	a3,0x3
ffffffffc02016fa:	38a68693          	addi	a3,a3,906 # ffffffffc0204a80 <etext+0xc38>
ffffffffc02016fe:	00003617          	auipc	a2,0x3
ffffffffc0201702:	02a60613          	addi	a2,a2,42 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201706:	06200593          	li	a1,98
ffffffffc020170a:	00003517          	auipc	a0,0x3
ffffffffc020170e:	03650513          	addi	a0,a0,54 # ffffffffc0204740 <etext+0x8f8>
default_alloc_pages(size_t n) {
ffffffffc0201712:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201714:	cf3fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201718 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc0201718:	1141                	addi	sp,sp,-16
ffffffffc020171a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020171c:	c9e1                	beqz	a1,ffffffffc02017ec <default_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc020171e:	00659713          	slli	a4,a1,0x6
ffffffffc0201722:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201726:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc0201728:	cf11                	beqz	a4,ffffffffc0201744 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020172a:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc020172c:	8b05                	andi	a4,a4,1
ffffffffc020172e:	cf59                	beqz	a4,ffffffffc02017cc <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc0201730:	0007a823          	sw	zero,16(a5)
ffffffffc0201734:	0007b423          	sd	zero,8(a5)
ffffffffc0201738:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc020173c:	04078793          	addi	a5,a5,64
ffffffffc0201740:	fed795e3          	bne	a5,a3,ffffffffc020172a <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201744:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201746:	4789                	li	a5,2
ffffffffc0201748:	00850713          	addi	a4,a0,8
ffffffffc020174c:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201750:	00008717          	auipc	a4,0x8
ffffffffc0201754:	cf072703          	lw	a4,-784(a4) # ffffffffc0209440 <free_area+0x10>
ffffffffc0201758:	00008697          	auipc	a3,0x8
ffffffffc020175c:	cd868693          	addi	a3,a3,-808 # ffffffffc0209430 <free_area>
    return list->next == list;
ffffffffc0201760:	669c                	ld	a5,8(a3)
ffffffffc0201762:	9f2d                	addw	a4,a4,a1
ffffffffc0201764:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201766:	04d78663          	beq	a5,a3,ffffffffc02017b2 <default_init_memmap+0x9a>
            struct Page* page = le2page(le, page_link);
ffffffffc020176a:	fe878713          	addi	a4,a5,-24
ffffffffc020176e:	4581                	li	a1,0
ffffffffc0201770:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0201774:	00e56a63          	bltu	a0,a4,ffffffffc0201788 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201778:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020177a:	02d70263          	beq	a4,a3,ffffffffc020179e <default_init_memmap+0x86>
    struct Page *p = base;
ffffffffc020177e:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201780:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201784:	fee57ae3          	bgeu	a0,a4,ffffffffc0201778 <default_init_memmap+0x60>
ffffffffc0201788:	c199                	beqz	a1,ffffffffc020178e <default_init_memmap+0x76>
ffffffffc020178a:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020178e:	6398                	ld	a4,0(a5)
}
ffffffffc0201790:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201792:	e390                	sd	a2,0(a5)
ffffffffc0201794:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc0201796:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0201798:	f11c                	sd	a5,32(a0)
ffffffffc020179a:	0141                	addi	sp,sp,16
ffffffffc020179c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020179e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02017a0:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02017a2:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02017a4:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc02017a6:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc02017a8:	00d70e63          	beq	a4,a3,ffffffffc02017c4 <default_init_memmap+0xac>
ffffffffc02017ac:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc02017ae:	87ba                	mv	a5,a4
ffffffffc02017b0:	bfc1                	j	ffffffffc0201780 <default_init_memmap+0x68>
}
ffffffffc02017b2:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc02017b4:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc02017b8:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02017ba:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc02017bc:	e398                	sd	a4,0(a5)
ffffffffc02017be:	e798                	sd	a4,8(a5)
}
ffffffffc02017c0:	0141                	addi	sp,sp,16
ffffffffc02017c2:	8082                	ret
ffffffffc02017c4:	60a2                	ld	ra,8(sp)
ffffffffc02017c6:	e290                	sd	a2,0(a3)
ffffffffc02017c8:	0141                	addi	sp,sp,16
ffffffffc02017ca:	8082                	ret
        assert(PageReserved(p));
ffffffffc02017cc:	00003697          	auipc	a3,0x3
ffffffffc02017d0:	2e468693          	addi	a3,a3,740 # ffffffffc0204ab0 <etext+0xc68>
ffffffffc02017d4:	00003617          	auipc	a2,0x3
ffffffffc02017d8:	f5460613          	addi	a2,a2,-172 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02017dc:	04900593          	li	a1,73
ffffffffc02017e0:	00003517          	auipc	a0,0x3
ffffffffc02017e4:	f6050513          	addi	a0,a0,-160 # ffffffffc0204740 <etext+0x8f8>
ffffffffc02017e8:	c1ffe0ef          	jal	ffffffffc0200406 <__panic>
    assert(n > 0);
ffffffffc02017ec:	00003697          	auipc	a3,0x3
ffffffffc02017f0:	29468693          	addi	a3,a3,660 # ffffffffc0204a80 <etext+0xc38>
ffffffffc02017f4:	00003617          	auipc	a2,0x3
ffffffffc02017f8:	f3460613          	addi	a2,a2,-204 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02017fc:	04600593          	li	a1,70
ffffffffc0201800:	00003517          	auipc	a0,0x3
ffffffffc0201804:	f4050513          	addi	a0,a0,-192 # ffffffffc0204740 <etext+0x8f8>
ffffffffc0201808:	bfffe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc020180c <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc020180c:	c531                	beqz	a0,ffffffffc0201858 <slob_free+0x4c>
		return;

	if (size)
ffffffffc020180e:	e9b9                	bnez	a1,ffffffffc0201864 <slob_free+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201810:	100027f3          	csrr	a5,sstatus
ffffffffc0201814:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201816:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201818:	efb1                	bnez	a5,ffffffffc0201874 <slob_free+0x68>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020181a:	00008797          	auipc	a5,0x8
ffffffffc020181e:	8067b783          	ld	a5,-2042(a5) # ffffffffc0209020 <slobfree>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201822:	873e                	mv	a4,a5
ffffffffc0201824:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201826:	02a77a63          	bgeu	a4,a0,ffffffffc020185a <slob_free+0x4e>
ffffffffc020182a:	00f56463          	bltu	a0,a5,ffffffffc0201832 <slob_free+0x26>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020182e:	fef76ae3          	bltu	a4,a5,ffffffffc0201822 <slob_free+0x16>
			break;

	if (b + b->units == cur->next)
ffffffffc0201832:	4110                	lw	a2,0(a0)
ffffffffc0201834:	00461693          	slli	a3,a2,0x4
ffffffffc0201838:	96aa                	add	a3,a3,a0
ffffffffc020183a:	0ad78463          	beq	a5,a3,ffffffffc02018e2 <slob_free+0xd6>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc020183e:	4310                	lw	a2,0(a4)
ffffffffc0201840:	e51c                	sd	a5,8(a0)
ffffffffc0201842:	00461693          	slli	a3,a2,0x4
ffffffffc0201846:	96ba                	add	a3,a3,a4
ffffffffc0201848:	08d50163          	beq	a0,a3,ffffffffc02018ca <slob_free+0xbe>
ffffffffc020184c:	e708                	sd	a0,8(a4)
		cur->next = b->next;
	}
	else
		cur->next = b;

	slobfree = cur;
ffffffffc020184e:	00007797          	auipc	a5,0x7
ffffffffc0201852:	7ce7b923          	sd	a4,2002(a5) # ffffffffc0209020 <slobfree>
    if (flag) {
ffffffffc0201856:	e9a5                	bnez	a1,ffffffffc02018c6 <slob_free+0xba>
ffffffffc0201858:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020185a:	fcf574e3          	bgeu	a0,a5,ffffffffc0201822 <slob_free+0x16>
ffffffffc020185e:	fcf762e3          	bltu	a4,a5,ffffffffc0201822 <slob_free+0x16>
ffffffffc0201862:	bfc1                	j	ffffffffc0201832 <slob_free+0x26>
		b->units = SLOB_UNITS(size);
ffffffffc0201864:	25bd                	addiw	a1,a1,15
ffffffffc0201866:	8191                	srli	a1,a1,0x4
ffffffffc0201868:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020186a:	100027f3          	csrr	a5,sstatus
ffffffffc020186e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201870:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201872:	d7c5                	beqz	a5,ffffffffc020181a <slob_free+0xe>
{
ffffffffc0201874:	1101                	addi	sp,sp,-32
ffffffffc0201876:	e42a                	sd	a0,8(sp)
ffffffffc0201878:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc020187a:	ffbfe0ef          	jal	ffffffffc0200874 <intr_disable>
        return 1;
ffffffffc020187e:	6522                	ld	a0,8(sp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201880:	00007797          	auipc	a5,0x7
ffffffffc0201884:	7a07b783          	ld	a5,1952(a5) # ffffffffc0209020 <slobfree>
ffffffffc0201888:	4585                	li	a1,1
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020188a:	873e                	mv	a4,a5
ffffffffc020188c:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020188e:	06a77663          	bgeu	a4,a0,ffffffffc02018fa <slob_free+0xee>
ffffffffc0201892:	00f56463          	bltu	a0,a5,ffffffffc020189a <slob_free+0x8e>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201896:	fef76ae3          	bltu	a4,a5,ffffffffc020188a <slob_free+0x7e>
	if (b + b->units == cur->next)
ffffffffc020189a:	4110                	lw	a2,0(a0)
ffffffffc020189c:	00461693          	slli	a3,a2,0x4
ffffffffc02018a0:	96aa                	add	a3,a3,a0
ffffffffc02018a2:	06d78363          	beq	a5,a3,ffffffffc0201908 <slob_free+0xfc>
	if (cur + cur->units == b)
ffffffffc02018a6:	4310                	lw	a2,0(a4)
ffffffffc02018a8:	e51c                	sd	a5,8(a0)
ffffffffc02018aa:	00461693          	slli	a3,a2,0x4
ffffffffc02018ae:	96ba                	add	a3,a3,a4
ffffffffc02018b0:	06d50163          	beq	a0,a3,ffffffffc0201912 <slob_free+0x106>
ffffffffc02018b4:	e708                	sd	a0,8(a4)
	slobfree = cur;
ffffffffc02018b6:	00007797          	auipc	a5,0x7
ffffffffc02018ba:	76e7b523          	sd	a4,1898(a5) # ffffffffc0209020 <slobfree>
    if (flag) {
ffffffffc02018be:	e1a9                	bnez	a1,ffffffffc0201900 <slob_free+0xf4>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc02018c0:	60e2                	ld	ra,24(sp)
ffffffffc02018c2:	6105                	addi	sp,sp,32
ffffffffc02018c4:	8082                	ret
        intr_enable();
ffffffffc02018c6:	fa9fe06f          	j	ffffffffc020086e <intr_enable>
		cur->units += b->units;
ffffffffc02018ca:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc02018cc:	853e                	mv	a0,a5
ffffffffc02018ce:	e708                	sd	a0,8(a4)
		cur->units += b->units;
ffffffffc02018d0:	00c687bb          	addw	a5,a3,a2
ffffffffc02018d4:	c31c                	sw	a5,0(a4)
	slobfree = cur;
ffffffffc02018d6:	00007797          	auipc	a5,0x7
ffffffffc02018da:	74e7b523          	sd	a4,1866(a5) # ffffffffc0209020 <slobfree>
    if (flag) {
ffffffffc02018de:	ddad                	beqz	a1,ffffffffc0201858 <slob_free+0x4c>
ffffffffc02018e0:	b7dd                	j	ffffffffc02018c6 <slob_free+0xba>
		b->units += cur->next->units;
ffffffffc02018e2:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc02018e4:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc02018e6:	9eb1                	addw	a3,a3,a2
ffffffffc02018e8:	c114                	sw	a3,0(a0)
	if (cur + cur->units == b)
ffffffffc02018ea:	4310                	lw	a2,0(a4)
ffffffffc02018ec:	e51c                	sd	a5,8(a0)
ffffffffc02018ee:	00461693          	slli	a3,a2,0x4
ffffffffc02018f2:	96ba                	add	a3,a3,a4
ffffffffc02018f4:	f4d51ce3          	bne	a0,a3,ffffffffc020184c <slob_free+0x40>
ffffffffc02018f8:	bfc9                	j	ffffffffc02018ca <slob_free+0xbe>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02018fa:	f8f56ee3          	bltu	a0,a5,ffffffffc0201896 <slob_free+0x8a>
ffffffffc02018fe:	b771                	j	ffffffffc020188a <slob_free+0x7e>
}
ffffffffc0201900:	60e2                	ld	ra,24(sp)
ffffffffc0201902:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201904:	f6bfe06f          	j	ffffffffc020086e <intr_enable>
		b->units += cur->next->units;
ffffffffc0201908:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc020190a:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc020190c:	9eb1                	addw	a3,a3,a2
ffffffffc020190e:	c114                	sw	a3,0(a0)
		b->next = cur->next->next;
ffffffffc0201910:	bf59                	j	ffffffffc02018a6 <slob_free+0x9a>
		cur->units += b->units;
ffffffffc0201912:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201914:	853e                	mv	a0,a5
		cur->units += b->units;
ffffffffc0201916:	00c687bb          	addw	a5,a3,a2
ffffffffc020191a:	c31c                	sw	a5,0(a4)
		cur->next = b->next;
ffffffffc020191c:	bf61                	j	ffffffffc02018b4 <slob_free+0xa8>

ffffffffc020191e <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc020191e:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201920:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201922:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201926:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201928:	326000ef          	jal	ffffffffc0201c4e <alloc_pages>
	if (!page)
ffffffffc020192c:	c91d                	beqz	a0,ffffffffc0201962 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc020192e:	0000c697          	auipc	a3,0xc
ffffffffc0201932:	ba26b683          	ld	a3,-1118(a3) # ffffffffc020d4d0 <pages>
ffffffffc0201936:	00004797          	auipc	a5,0x4
ffffffffc020193a:	f327b783          	ld	a5,-206(a5) # ffffffffc0205868 <nbase>
    return KADDR(page2pa(page));
ffffffffc020193e:	0000c717          	auipc	a4,0xc
ffffffffc0201942:	b8a73703          	ld	a4,-1142(a4) # ffffffffc020d4c8 <npage>
    return page - pages + nbase;
ffffffffc0201946:	8d15                	sub	a0,a0,a3
ffffffffc0201948:	8519                	srai	a0,a0,0x6
ffffffffc020194a:	953e                	add	a0,a0,a5
    return KADDR(page2pa(page));
ffffffffc020194c:	00c51793          	slli	a5,a0,0xc
ffffffffc0201950:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201952:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201954:	00e7fa63          	bgeu	a5,a4,ffffffffc0201968 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201958:	0000c797          	auipc	a5,0xc
ffffffffc020195c:	b687b783          	ld	a5,-1176(a5) # ffffffffc020d4c0 <va_pa_offset>
ffffffffc0201960:	953e                	add	a0,a0,a5
}
ffffffffc0201962:	60a2                	ld	ra,8(sp)
ffffffffc0201964:	0141                	addi	sp,sp,16
ffffffffc0201966:	8082                	ret
ffffffffc0201968:	86aa                	mv	a3,a0
ffffffffc020196a:	00003617          	auipc	a2,0x3
ffffffffc020196e:	16e60613          	addi	a2,a2,366 # ffffffffc0204ad8 <etext+0xc90>
ffffffffc0201972:	07100593          	li	a1,113
ffffffffc0201976:	00003517          	auipc	a0,0x3
ffffffffc020197a:	18a50513          	addi	a0,a0,394 # ffffffffc0204b00 <etext+0xcb8>
ffffffffc020197e:	a89fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201982 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201982:	7179                	addi	sp,sp,-48
ffffffffc0201984:	f406                	sd	ra,40(sp)
ffffffffc0201986:	f022                	sd	s0,32(sp)
ffffffffc0201988:	ec26                	sd	s1,24(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc020198a:	01050713          	addi	a4,a0,16
ffffffffc020198e:	6785                	lui	a5,0x1
ffffffffc0201990:	0af77e63          	bgeu	a4,a5,ffffffffc0201a4c <slob_alloc.constprop.0+0xca>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201994:	00f50413          	addi	s0,a0,15
ffffffffc0201998:	8011                	srli	s0,s0,0x4
ffffffffc020199a:	2401                	sext.w	s0,s0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020199c:	100025f3          	csrr	a1,sstatus
ffffffffc02019a0:	8989                	andi	a1,a1,2
ffffffffc02019a2:	edd1                	bnez	a1,ffffffffc0201a3e <slob_alloc.constprop.0+0xbc>
	prev = slobfree;
ffffffffc02019a4:	00007497          	auipc	s1,0x7
ffffffffc02019a8:	67c48493          	addi	s1,s1,1660 # ffffffffc0209020 <slobfree>
ffffffffc02019ac:	6090                	ld	a2,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc02019ae:	6618                	ld	a4,8(a2)
		if (cur->units >= units + delta)
ffffffffc02019b0:	4314                	lw	a3,0(a4)
ffffffffc02019b2:	0886da63          	bge	a3,s0,ffffffffc0201a46 <slob_alloc.constprop.0+0xc4>
		if (cur == slobfree)
ffffffffc02019b6:	00e60a63          	beq	a2,a4,ffffffffc02019ca <slob_alloc.constprop.0+0x48>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc02019ba:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc02019bc:	4394                	lw	a3,0(a5)
ffffffffc02019be:	0286d863          	bge	a3,s0,ffffffffc02019ee <slob_alloc.constprop.0+0x6c>
		if (cur == slobfree)
ffffffffc02019c2:	6090                	ld	a2,0(s1)
ffffffffc02019c4:	873e                	mv	a4,a5
ffffffffc02019c6:	fee61ae3          	bne	a2,a4,ffffffffc02019ba <slob_alloc.constprop.0+0x38>
    if (flag) {
ffffffffc02019ca:	e9b1                	bnez	a1,ffffffffc0201a1e <slob_alloc.constprop.0+0x9c>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc02019cc:	4501                	li	a0,0
ffffffffc02019ce:	f51ff0ef          	jal	ffffffffc020191e <__slob_get_free_pages.constprop.0>
ffffffffc02019d2:	87aa                	mv	a5,a0
			if (!cur)
ffffffffc02019d4:	c915                	beqz	a0,ffffffffc0201a08 <slob_alloc.constprop.0+0x86>
			slob_free(cur, PAGE_SIZE);
ffffffffc02019d6:	6585                	lui	a1,0x1
ffffffffc02019d8:	e35ff0ef          	jal	ffffffffc020180c <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02019dc:	100025f3          	csrr	a1,sstatus
ffffffffc02019e0:	8989                	andi	a1,a1,2
ffffffffc02019e2:	e98d                	bnez	a1,ffffffffc0201a14 <slob_alloc.constprop.0+0x92>
			cur = slobfree;
ffffffffc02019e4:	6098                	ld	a4,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc02019e6:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc02019e8:	4394                	lw	a3,0(a5)
ffffffffc02019ea:	fc86cce3          	blt	a3,s0,ffffffffc02019c2 <slob_alloc.constprop.0+0x40>
			if (cur->units == units)	/* exact fit? */
ffffffffc02019ee:	04d40563          	beq	s0,a3,ffffffffc0201a38 <slob_alloc.constprop.0+0xb6>
				prev->next = cur + units;
ffffffffc02019f2:	00441613          	slli	a2,s0,0x4
ffffffffc02019f6:	963e                	add	a2,a2,a5
ffffffffc02019f8:	e710                	sd	a2,8(a4)
				prev->next->next = cur->next;
ffffffffc02019fa:	6788                	ld	a0,8(a5)
				prev->next->units = cur->units - units;
ffffffffc02019fc:	9e81                	subw	a3,a3,s0
ffffffffc02019fe:	c214                	sw	a3,0(a2)
				prev->next->next = cur->next;
ffffffffc0201a00:	e608                	sd	a0,8(a2)
				cur->units = units;
ffffffffc0201a02:	c380                	sw	s0,0(a5)
			slobfree = prev;
ffffffffc0201a04:	e098                	sd	a4,0(s1)
    if (flag) {
ffffffffc0201a06:	ed99                	bnez	a1,ffffffffc0201a24 <slob_alloc.constprop.0+0xa2>
}
ffffffffc0201a08:	70a2                	ld	ra,40(sp)
ffffffffc0201a0a:	7402                	ld	s0,32(sp)
ffffffffc0201a0c:	64e2                	ld	s1,24(sp)
ffffffffc0201a0e:	853e                	mv	a0,a5
ffffffffc0201a10:	6145                	addi	sp,sp,48
ffffffffc0201a12:	8082                	ret
        intr_disable();
ffffffffc0201a14:	e61fe0ef          	jal	ffffffffc0200874 <intr_disable>
			cur = slobfree;
ffffffffc0201a18:	6098                	ld	a4,0(s1)
        return 1;
ffffffffc0201a1a:	4585                	li	a1,1
ffffffffc0201a1c:	b7e9                	j	ffffffffc02019e6 <slob_alloc.constprop.0+0x64>
        intr_enable();
ffffffffc0201a1e:	e51fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201a22:	b76d                	j	ffffffffc02019cc <slob_alloc.constprop.0+0x4a>
ffffffffc0201a24:	e43e                	sd	a5,8(sp)
ffffffffc0201a26:	e49fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201a2a:	67a2                	ld	a5,8(sp)
}
ffffffffc0201a2c:	70a2                	ld	ra,40(sp)
ffffffffc0201a2e:	7402                	ld	s0,32(sp)
ffffffffc0201a30:	64e2                	ld	s1,24(sp)
ffffffffc0201a32:	853e                	mv	a0,a5
ffffffffc0201a34:	6145                	addi	sp,sp,48
ffffffffc0201a36:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201a38:	6794                	ld	a3,8(a5)
ffffffffc0201a3a:	e714                	sd	a3,8(a4)
ffffffffc0201a3c:	b7e1                	j	ffffffffc0201a04 <slob_alloc.constprop.0+0x82>
        intr_disable();
ffffffffc0201a3e:	e37fe0ef          	jal	ffffffffc0200874 <intr_disable>
        return 1;
ffffffffc0201a42:	4585                	li	a1,1
ffffffffc0201a44:	b785                	j	ffffffffc02019a4 <slob_alloc.constprop.0+0x22>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201a46:	87ba                	mv	a5,a4
	prev = slobfree;
ffffffffc0201a48:	8732                	mv	a4,a2
ffffffffc0201a4a:	b755                	j	ffffffffc02019ee <slob_alloc.constprop.0+0x6c>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201a4c:	00003697          	auipc	a3,0x3
ffffffffc0201a50:	0c468693          	addi	a3,a3,196 # ffffffffc0204b10 <etext+0xcc8>
ffffffffc0201a54:	00003617          	auipc	a2,0x3
ffffffffc0201a58:	cd460613          	addi	a2,a2,-812 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0201a5c:	06300593          	li	a1,99
ffffffffc0201a60:	00003517          	auipc	a0,0x3
ffffffffc0201a64:	0d050513          	addi	a0,a0,208 # ffffffffc0204b30 <etext+0xce8>
ffffffffc0201a68:	99ffe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201a6c <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201a6c:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201a6e:	00003517          	auipc	a0,0x3
ffffffffc0201a72:	0da50513          	addi	a0,a0,218 # ffffffffc0204b48 <etext+0xd00>
{
ffffffffc0201a76:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201a78:	f1cfe0ef          	jal	ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201a7c:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201a7e:	00003517          	auipc	a0,0x3
ffffffffc0201a82:	0e250513          	addi	a0,a0,226 # ffffffffc0204b60 <etext+0xd18>
}
ffffffffc0201a86:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201a88:	f0cfe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201a8c <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201a8c:	1101                	addi	sp,sp,-32
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201a8e:	6685                	lui	a3,0x1
{
ffffffffc0201a90:	ec06                	sd	ra,24(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201a92:	16bd                	addi	a3,a3,-17 # fef <kern_entry-0xffffffffc01ff011>
ffffffffc0201a94:	04a6f963          	bgeu	a3,a0,ffffffffc0201ae6 <kmalloc+0x5a>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201a98:	e42a                	sd	a0,8(sp)
ffffffffc0201a9a:	4561                	li	a0,24
ffffffffc0201a9c:	e822                	sd	s0,16(sp)
ffffffffc0201a9e:	ee5ff0ef          	jal	ffffffffc0201982 <slob_alloc.constprop.0>
ffffffffc0201aa2:	842a                	mv	s0,a0
	if (!bb)
ffffffffc0201aa4:	c541                	beqz	a0,ffffffffc0201b2c <kmalloc+0xa0>
	bb->order = find_order(size);
ffffffffc0201aa6:	47a2                	lw	a5,8(sp)
	for (; size > 4096; size >>= 1)
ffffffffc0201aa8:	6705                	lui	a4,0x1
	int order = 0;
ffffffffc0201aaa:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201aac:	00f75763          	bge	a4,a5,ffffffffc0201aba <kmalloc+0x2e>
ffffffffc0201ab0:	4017d79b          	sraiw	a5,a5,0x1
		order++;
ffffffffc0201ab4:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201ab6:	fef74de3          	blt	a4,a5,ffffffffc0201ab0 <kmalloc+0x24>
	bb->order = find_order(size);
ffffffffc0201aba:	c008                	sw	a0,0(s0)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201abc:	e63ff0ef          	jal	ffffffffc020191e <__slob_get_free_pages.constprop.0>
ffffffffc0201ac0:	e408                	sd	a0,8(s0)
	if (bb->pages)
ffffffffc0201ac2:	cd31                	beqz	a0,ffffffffc0201b1e <kmalloc+0x92>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201ac4:	100027f3          	csrr	a5,sstatus
ffffffffc0201ac8:	8b89                	andi	a5,a5,2
ffffffffc0201aca:	eb85                	bnez	a5,ffffffffc0201afa <kmalloc+0x6e>
		bb->next = bigblocks;
ffffffffc0201acc:	0000c797          	auipc	a5,0xc
ffffffffc0201ad0:	9d47b783          	ld	a5,-1580(a5) # ffffffffc020d4a0 <bigblocks>
		bigblocks = bb;
ffffffffc0201ad4:	0000c717          	auipc	a4,0xc
ffffffffc0201ad8:	9c873623          	sd	s0,-1588(a4) # ffffffffc020d4a0 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201adc:	e81c                	sd	a5,16(s0)
    if (flag) {
ffffffffc0201ade:	6442                	ld	s0,16(sp)
	return __kmalloc(size, 0);
}
ffffffffc0201ae0:	60e2                	ld	ra,24(sp)
ffffffffc0201ae2:	6105                	addi	sp,sp,32
ffffffffc0201ae4:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201ae6:	0541                	addi	a0,a0,16
ffffffffc0201ae8:	e9bff0ef          	jal	ffffffffc0201982 <slob_alloc.constprop.0>
ffffffffc0201aec:	87aa                	mv	a5,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0201aee:	0541                	addi	a0,a0,16
ffffffffc0201af0:	fbe5                	bnez	a5,ffffffffc0201ae0 <kmalloc+0x54>
		return 0;
ffffffffc0201af2:	4501                	li	a0,0
}
ffffffffc0201af4:	60e2                	ld	ra,24(sp)
ffffffffc0201af6:	6105                	addi	sp,sp,32
ffffffffc0201af8:	8082                	ret
        intr_disable();
ffffffffc0201afa:	d7bfe0ef          	jal	ffffffffc0200874 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201afe:	0000c797          	auipc	a5,0xc
ffffffffc0201b02:	9a27b783          	ld	a5,-1630(a5) # ffffffffc020d4a0 <bigblocks>
		bigblocks = bb;
ffffffffc0201b06:	0000c717          	auipc	a4,0xc
ffffffffc0201b0a:	98873d23          	sd	s0,-1638(a4) # ffffffffc020d4a0 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201b0e:	e81c                	sd	a5,16(s0)
        intr_enable();
ffffffffc0201b10:	d5ffe0ef          	jal	ffffffffc020086e <intr_enable>
		return bb->pages;
ffffffffc0201b14:	6408                	ld	a0,8(s0)
}
ffffffffc0201b16:	60e2                	ld	ra,24(sp)
		return bb->pages;
ffffffffc0201b18:	6442                	ld	s0,16(sp)
}
ffffffffc0201b1a:	6105                	addi	sp,sp,32
ffffffffc0201b1c:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201b1e:	8522                	mv	a0,s0
ffffffffc0201b20:	45e1                	li	a1,24
ffffffffc0201b22:	cebff0ef          	jal	ffffffffc020180c <slob_free>
		return 0;
ffffffffc0201b26:	4501                	li	a0,0
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201b28:	6442                	ld	s0,16(sp)
ffffffffc0201b2a:	b7e9                	j	ffffffffc0201af4 <kmalloc+0x68>
ffffffffc0201b2c:	6442                	ld	s0,16(sp)
		return 0;
ffffffffc0201b2e:	4501                	li	a0,0
ffffffffc0201b30:	b7d1                	j	ffffffffc0201af4 <kmalloc+0x68>

ffffffffc0201b32 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201b32:	c571                	beqz	a0,ffffffffc0201bfe <kfree+0xcc>
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201b34:	03451793          	slli	a5,a0,0x34
ffffffffc0201b38:	e3e1                	bnez	a5,ffffffffc0201bf8 <kfree+0xc6>
{
ffffffffc0201b3a:	1101                	addi	sp,sp,-32
ffffffffc0201b3c:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201b3e:	100027f3          	csrr	a5,sstatus
ffffffffc0201b42:	8b89                	andi	a5,a5,2
ffffffffc0201b44:	e7c1                	bnez	a5,ffffffffc0201bcc <kfree+0x9a>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201b46:	0000c797          	auipc	a5,0xc
ffffffffc0201b4a:	95a7b783          	ld	a5,-1702(a5) # ffffffffc020d4a0 <bigblocks>
    return 0;
ffffffffc0201b4e:	4581                	li	a1,0
ffffffffc0201b50:	cbad                	beqz	a5,ffffffffc0201bc2 <kfree+0x90>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201b52:	0000c617          	auipc	a2,0xc
ffffffffc0201b56:	94e60613          	addi	a2,a2,-1714 # ffffffffc020d4a0 <bigblocks>
ffffffffc0201b5a:	a021                	j	ffffffffc0201b62 <kfree+0x30>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201b5c:	01070613          	addi	a2,a4,16
ffffffffc0201b60:	c3a5                	beqz	a5,ffffffffc0201bc0 <kfree+0x8e>
		{
			if (bb->pages == block)
ffffffffc0201b62:	6794                	ld	a3,8(a5)
ffffffffc0201b64:	873e                	mv	a4,a5
			{
				*last = bb->next;
ffffffffc0201b66:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201b68:	fea69ae3          	bne	a3,a0,ffffffffc0201b5c <kfree+0x2a>
				*last = bb->next;
ffffffffc0201b6c:	e21c                	sd	a5,0(a2)
    if (flag) {
ffffffffc0201b6e:	edb5                	bnez	a1,ffffffffc0201bea <kfree+0xb8>
    return pa2page(PADDR(kva));
ffffffffc0201b70:	c02007b7          	lui	a5,0xc0200
ffffffffc0201b74:	0af56263          	bltu	a0,a5,ffffffffc0201c18 <kfree+0xe6>
ffffffffc0201b78:	0000c797          	auipc	a5,0xc
ffffffffc0201b7c:	9487b783          	ld	a5,-1720(a5) # ffffffffc020d4c0 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0201b80:	0000c697          	auipc	a3,0xc
ffffffffc0201b84:	9486b683          	ld	a3,-1720(a3) # ffffffffc020d4c8 <npage>
    return pa2page(PADDR(kva));
ffffffffc0201b88:	8d1d                	sub	a0,a0,a5
    if (PPN(pa) >= npage)
ffffffffc0201b8a:	00c55793          	srli	a5,a0,0xc
ffffffffc0201b8e:	06d7f963          	bgeu	a5,a3,ffffffffc0201c00 <kfree+0xce>
    return &pages[PPN(pa) - nbase];
ffffffffc0201b92:	00004617          	auipc	a2,0x4
ffffffffc0201b96:	cd663603          	ld	a2,-810(a2) # ffffffffc0205868 <nbase>
ffffffffc0201b9a:	0000c517          	auipc	a0,0xc
ffffffffc0201b9e:	93653503          	ld	a0,-1738(a0) # ffffffffc020d4d0 <pages>
	free_pages(kva2page((void *)kva), 1 << order);
ffffffffc0201ba2:	4314                	lw	a3,0(a4)
ffffffffc0201ba4:	8f91                	sub	a5,a5,a2
ffffffffc0201ba6:	079a                	slli	a5,a5,0x6
ffffffffc0201ba8:	4585                	li	a1,1
ffffffffc0201baa:	953e                	add	a0,a0,a5
ffffffffc0201bac:	00d595bb          	sllw	a1,a1,a3
ffffffffc0201bb0:	e03a                	sd	a4,0(sp)
ffffffffc0201bb2:	0d6000ef          	jal	ffffffffc0201c88 <free_pages>
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201bb6:	6502                	ld	a0,0(sp)
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201bb8:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201bba:	45e1                	li	a1,24
}
ffffffffc0201bbc:	6105                	addi	sp,sp,32
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201bbe:	b1b9                	j	ffffffffc020180c <slob_free>
ffffffffc0201bc0:	e185                	bnez	a1,ffffffffc0201be0 <kfree+0xae>
}
ffffffffc0201bc2:	60e2                	ld	ra,24(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201bc4:	1541                	addi	a0,a0,-16
ffffffffc0201bc6:	4581                	li	a1,0
}
ffffffffc0201bc8:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201bca:	b189                	j	ffffffffc020180c <slob_free>
        intr_disable();
ffffffffc0201bcc:	e02a                	sd	a0,0(sp)
ffffffffc0201bce:	ca7fe0ef          	jal	ffffffffc0200874 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201bd2:	0000c797          	auipc	a5,0xc
ffffffffc0201bd6:	8ce7b783          	ld	a5,-1842(a5) # ffffffffc020d4a0 <bigblocks>
ffffffffc0201bda:	6502                	ld	a0,0(sp)
        return 1;
ffffffffc0201bdc:	4585                	li	a1,1
ffffffffc0201bde:	fbb5                	bnez	a5,ffffffffc0201b52 <kfree+0x20>
ffffffffc0201be0:	e02a                	sd	a0,0(sp)
        intr_enable();
ffffffffc0201be2:	c8dfe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201be6:	6502                	ld	a0,0(sp)
ffffffffc0201be8:	bfe9                	j	ffffffffc0201bc2 <kfree+0x90>
ffffffffc0201bea:	e42a                	sd	a0,8(sp)
ffffffffc0201bec:	e03a                	sd	a4,0(sp)
ffffffffc0201bee:	c81fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201bf2:	6522                	ld	a0,8(sp)
ffffffffc0201bf4:	6702                	ld	a4,0(sp)
ffffffffc0201bf6:	bfad                	j	ffffffffc0201b70 <kfree+0x3e>
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201bf8:	1541                	addi	a0,a0,-16
ffffffffc0201bfa:	4581                	li	a1,0
ffffffffc0201bfc:	b901                	j	ffffffffc020180c <slob_free>
ffffffffc0201bfe:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201c00:	00003617          	auipc	a2,0x3
ffffffffc0201c04:	fa860613          	addi	a2,a2,-88 # ffffffffc0204ba8 <etext+0xd60>
ffffffffc0201c08:	06900593          	li	a1,105
ffffffffc0201c0c:	00003517          	auipc	a0,0x3
ffffffffc0201c10:	ef450513          	addi	a0,a0,-268 # ffffffffc0204b00 <etext+0xcb8>
ffffffffc0201c14:	ff2fe0ef          	jal	ffffffffc0200406 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201c18:	86aa                	mv	a3,a0
ffffffffc0201c1a:	00003617          	auipc	a2,0x3
ffffffffc0201c1e:	f6660613          	addi	a2,a2,-154 # ffffffffc0204b80 <etext+0xd38>
ffffffffc0201c22:	07700593          	li	a1,119
ffffffffc0201c26:	00003517          	auipc	a0,0x3
ffffffffc0201c2a:	eda50513          	addi	a0,a0,-294 # ffffffffc0204b00 <etext+0xcb8>
ffffffffc0201c2e:	fd8fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201c32 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201c32:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201c34:	00003617          	auipc	a2,0x3
ffffffffc0201c38:	f7460613          	addi	a2,a2,-140 # ffffffffc0204ba8 <etext+0xd60>
ffffffffc0201c3c:	06900593          	li	a1,105
ffffffffc0201c40:	00003517          	auipc	a0,0x3
ffffffffc0201c44:	ec050513          	addi	a0,a0,-320 # ffffffffc0204b00 <etext+0xcb8>
pa2page(uintptr_t pa)
ffffffffc0201c48:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201c4a:	fbcfe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201c4e <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201c4e:	100027f3          	csrr	a5,sstatus
ffffffffc0201c52:	8b89                	andi	a5,a5,2
ffffffffc0201c54:	e799                	bnez	a5,ffffffffc0201c62 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201c56:	0000c797          	auipc	a5,0xc
ffffffffc0201c5a:	8527b783          	ld	a5,-1966(a5) # ffffffffc020d4a8 <pmm_manager>
ffffffffc0201c5e:	6f9c                	ld	a5,24(a5)
ffffffffc0201c60:	8782                	jr	a5
{
ffffffffc0201c62:	1101                	addi	sp,sp,-32
ffffffffc0201c64:	ec06                	sd	ra,24(sp)
ffffffffc0201c66:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201c68:	c0dfe0ef          	jal	ffffffffc0200874 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201c6c:	0000c797          	auipc	a5,0xc
ffffffffc0201c70:	83c7b783          	ld	a5,-1988(a5) # ffffffffc020d4a8 <pmm_manager>
ffffffffc0201c74:	6522                	ld	a0,8(sp)
ffffffffc0201c76:	6f9c                	ld	a5,24(a5)
ffffffffc0201c78:	9782                	jalr	a5
ffffffffc0201c7a:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201c7c:	bf3fe0ef          	jal	ffffffffc020086e <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201c80:	60e2                	ld	ra,24(sp)
ffffffffc0201c82:	6522                	ld	a0,8(sp)
ffffffffc0201c84:	6105                	addi	sp,sp,32
ffffffffc0201c86:	8082                	ret

ffffffffc0201c88 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201c88:	100027f3          	csrr	a5,sstatus
ffffffffc0201c8c:	8b89                	andi	a5,a5,2
ffffffffc0201c8e:	e799                	bnez	a5,ffffffffc0201c9c <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201c90:	0000c797          	auipc	a5,0xc
ffffffffc0201c94:	8187b783          	ld	a5,-2024(a5) # ffffffffc020d4a8 <pmm_manager>
ffffffffc0201c98:	739c                	ld	a5,32(a5)
ffffffffc0201c9a:	8782                	jr	a5
{
ffffffffc0201c9c:	1101                	addi	sp,sp,-32
ffffffffc0201c9e:	ec06                	sd	ra,24(sp)
ffffffffc0201ca0:	e42e                	sd	a1,8(sp)
ffffffffc0201ca2:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0201ca4:	bd1fe0ef          	jal	ffffffffc0200874 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201ca8:	0000c797          	auipc	a5,0xc
ffffffffc0201cac:	8007b783          	ld	a5,-2048(a5) # ffffffffc020d4a8 <pmm_manager>
ffffffffc0201cb0:	65a2                	ld	a1,8(sp)
ffffffffc0201cb2:	6502                	ld	a0,0(sp)
ffffffffc0201cb4:	739c                	ld	a5,32(a5)
ffffffffc0201cb6:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201cb8:	60e2                	ld	ra,24(sp)
ffffffffc0201cba:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201cbc:	bb3fe06f          	j	ffffffffc020086e <intr_enable>

ffffffffc0201cc0 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201cc0:	100027f3          	csrr	a5,sstatus
ffffffffc0201cc4:	8b89                	andi	a5,a5,2
ffffffffc0201cc6:	e799                	bnez	a5,ffffffffc0201cd4 <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201cc8:	0000b797          	auipc	a5,0xb
ffffffffc0201ccc:	7e07b783          	ld	a5,2016(a5) # ffffffffc020d4a8 <pmm_manager>
ffffffffc0201cd0:	779c                	ld	a5,40(a5)
ffffffffc0201cd2:	8782                	jr	a5
{
ffffffffc0201cd4:	1101                	addi	sp,sp,-32
ffffffffc0201cd6:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201cd8:	b9dfe0ef          	jal	ffffffffc0200874 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201cdc:	0000b797          	auipc	a5,0xb
ffffffffc0201ce0:	7cc7b783          	ld	a5,1996(a5) # ffffffffc020d4a8 <pmm_manager>
ffffffffc0201ce4:	779c                	ld	a5,40(a5)
ffffffffc0201ce6:	9782                	jalr	a5
ffffffffc0201ce8:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201cea:	b85fe0ef          	jal	ffffffffc020086e <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201cee:	60e2                	ld	ra,24(sp)
ffffffffc0201cf0:	6522                	ld	a0,8(sp)
ffffffffc0201cf2:	6105                	addi	sp,sp,32
ffffffffc0201cf4:	8082                	ret

ffffffffc0201cf6 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201cf6:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201cfa:	1ff7f793          	andi	a5,a5,511
ffffffffc0201cfe:	078e                	slli	a5,a5,0x3
ffffffffc0201d00:	00f50733          	add	a4,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201d04:	6314                	ld	a3,0(a4)
{
ffffffffc0201d06:	7139                	addi	sp,sp,-64
ffffffffc0201d08:	f822                	sd	s0,48(sp)
ffffffffc0201d0a:	f426                	sd	s1,40(sp)
ffffffffc0201d0c:	fc06                	sd	ra,56(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201d0e:	0016f793          	andi	a5,a3,1
{
ffffffffc0201d12:	842e                	mv	s0,a1
ffffffffc0201d14:	8832                	mv	a6,a2
ffffffffc0201d16:	0000b497          	auipc	s1,0xb
ffffffffc0201d1a:	7b248493          	addi	s1,s1,1970 # ffffffffc020d4c8 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201d1e:	ebd1                	bnez	a5,ffffffffc0201db2 <get_pte+0xbc>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201d20:	16060d63          	beqz	a2,ffffffffc0201e9a <get_pte+0x1a4>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201d24:	100027f3          	csrr	a5,sstatus
ffffffffc0201d28:	8b89                	andi	a5,a5,2
ffffffffc0201d2a:	16079e63          	bnez	a5,ffffffffc0201ea6 <get_pte+0x1b0>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201d2e:	0000b797          	auipc	a5,0xb
ffffffffc0201d32:	77a7b783          	ld	a5,1914(a5) # ffffffffc020d4a8 <pmm_manager>
ffffffffc0201d36:	4505                	li	a0,1
ffffffffc0201d38:	e43a                	sd	a4,8(sp)
ffffffffc0201d3a:	6f9c                	ld	a5,24(a5)
ffffffffc0201d3c:	e832                	sd	a2,16(sp)
ffffffffc0201d3e:	9782                	jalr	a5
ffffffffc0201d40:	6722                	ld	a4,8(sp)
ffffffffc0201d42:	6842                	ld	a6,16(sp)
ffffffffc0201d44:	87aa                	mv	a5,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201d46:	14078a63          	beqz	a5,ffffffffc0201e9a <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0201d4a:	0000b517          	auipc	a0,0xb
ffffffffc0201d4e:	78653503          	ld	a0,1926(a0) # ffffffffc020d4d0 <pages>
ffffffffc0201d52:	000808b7          	lui	a7,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201d56:	0000b497          	auipc	s1,0xb
ffffffffc0201d5a:	77248493          	addi	s1,s1,1906 # ffffffffc020d4c8 <npage>
ffffffffc0201d5e:	40a78533          	sub	a0,a5,a0
ffffffffc0201d62:	8519                	srai	a0,a0,0x6
ffffffffc0201d64:	9546                	add	a0,a0,a7
ffffffffc0201d66:	6090                	ld	a2,0(s1)
ffffffffc0201d68:	00c51693          	slli	a3,a0,0xc
    page->ref = val;
ffffffffc0201d6c:	4585                	li	a1,1
ffffffffc0201d6e:	82b1                	srli	a3,a3,0xc
ffffffffc0201d70:	c38c                	sw	a1,0(a5)
    return page2ppn(page) << PGSHIFT;
ffffffffc0201d72:	0532                	slli	a0,a0,0xc
ffffffffc0201d74:	1ac6f763          	bgeu	a3,a2,ffffffffc0201f22 <get_pte+0x22c>
ffffffffc0201d78:	0000b697          	auipc	a3,0xb
ffffffffc0201d7c:	7486b683          	ld	a3,1864(a3) # ffffffffc020d4c0 <va_pa_offset>
ffffffffc0201d80:	6605                	lui	a2,0x1
ffffffffc0201d82:	4581                	li	a1,0
ffffffffc0201d84:	9536                	add	a0,a0,a3
ffffffffc0201d86:	ec42                	sd	a6,24(sp)
ffffffffc0201d88:	e83e                	sd	a5,16(sp)
ffffffffc0201d8a:	e43a                	sd	a4,8(sp)
ffffffffc0201d8c:	06e020ef          	jal	ffffffffc0203dfa <memset>
    return page - pages + nbase;
ffffffffc0201d90:	0000b697          	auipc	a3,0xb
ffffffffc0201d94:	7406b683          	ld	a3,1856(a3) # ffffffffc020d4d0 <pages>
ffffffffc0201d98:	67c2                	ld	a5,16(sp)
ffffffffc0201d9a:	000808b7          	lui	a7,0x80
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201d9e:	6722                	ld	a4,8(sp)
ffffffffc0201da0:	40d786b3          	sub	a3,a5,a3
ffffffffc0201da4:	8699                	srai	a3,a3,0x6
ffffffffc0201da6:	96c6                	add	a3,a3,a7
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201da8:	06aa                	slli	a3,a3,0xa
ffffffffc0201daa:	6862                	ld	a6,24(sp)
ffffffffc0201dac:	0116e693          	ori	a3,a3,17
ffffffffc0201db0:	e314                	sd	a3,0(a4)
    }
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201db2:	c006f693          	andi	a3,a3,-1024
ffffffffc0201db6:	6098                	ld	a4,0(s1)
ffffffffc0201db8:	068a                	slli	a3,a3,0x2
ffffffffc0201dba:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201dbe:	14e7f663          	bgeu	a5,a4,ffffffffc0201f0a <get_pte+0x214>
ffffffffc0201dc2:	0000b897          	auipc	a7,0xb
ffffffffc0201dc6:	6fe88893          	addi	a7,a7,1790 # ffffffffc020d4c0 <va_pa_offset>
ffffffffc0201dca:	0008b603          	ld	a2,0(a7)
ffffffffc0201dce:	01545793          	srli	a5,s0,0x15
ffffffffc0201dd2:	1ff7f793          	andi	a5,a5,511
ffffffffc0201dd6:	96b2                	add	a3,a3,a2
ffffffffc0201dd8:	078e                	slli	a5,a5,0x3
ffffffffc0201dda:	97b6                	add	a5,a5,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0201ddc:	6394                	ld	a3,0(a5)
ffffffffc0201dde:	0016f613          	andi	a2,a3,1
ffffffffc0201de2:	e659                	bnez	a2,ffffffffc0201e70 <get_pte+0x17a>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201de4:	0a080b63          	beqz	a6,ffffffffc0201e9a <get_pte+0x1a4>
ffffffffc0201de8:	10002773          	csrr	a4,sstatus
ffffffffc0201dec:	8b09                	andi	a4,a4,2
ffffffffc0201dee:	ef71                	bnez	a4,ffffffffc0201eca <get_pte+0x1d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201df0:	0000b717          	auipc	a4,0xb
ffffffffc0201df4:	6b873703          	ld	a4,1720(a4) # ffffffffc020d4a8 <pmm_manager>
ffffffffc0201df8:	4505                	li	a0,1
ffffffffc0201dfa:	e43e                	sd	a5,8(sp)
ffffffffc0201dfc:	6f18                	ld	a4,24(a4)
ffffffffc0201dfe:	9702                	jalr	a4
ffffffffc0201e00:	67a2                	ld	a5,8(sp)
ffffffffc0201e02:	872a                	mv	a4,a0
ffffffffc0201e04:	0000b897          	auipc	a7,0xb
ffffffffc0201e08:	6bc88893          	addi	a7,a7,1724 # ffffffffc020d4c0 <va_pa_offset>
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201e0c:	c759                	beqz	a4,ffffffffc0201e9a <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0201e0e:	0000b697          	auipc	a3,0xb
ffffffffc0201e12:	6c26b683          	ld	a3,1730(a3) # ffffffffc020d4d0 <pages>
ffffffffc0201e16:	00080837          	lui	a6,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201e1a:	608c                	ld	a1,0(s1)
ffffffffc0201e1c:	40d706b3          	sub	a3,a4,a3
ffffffffc0201e20:	8699                	srai	a3,a3,0x6
ffffffffc0201e22:	96c2                	add	a3,a3,a6
ffffffffc0201e24:	00c69613          	slli	a2,a3,0xc
    page->ref = val;
ffffffffc0201e28:	4505                	li	a0,1
ffffffffc0201e2a:	8231                	srli	a2,a2,0xc
ffffffffc0201e2c:	c308                	sw	a0,0(a4)
    return page2ppn(page) << PGSHIFT;
ffffffffc0201e2e:	06b2                	slli	a3,a3,0xc
ffffffffc0201e30:	10b67663          	bgeu	a2,a1,ffffffffc0201f3c <get_pte+0x246>
ffffffffc0201e34:	0008b503          	ld	a0,0(a7)
ffffffffc0201e38:	6605                	lui	a2,0x1
ffffffffc0201e3a:	4581                	li	a1,0
ffffffffc0201e3c:	9536                	add	a0,a0,a3
ffffffffc0201e3e:	e83a                	sd	a4,16(sp)
ffffffffc0201e40:	e43e                	sd	a5,8(sp)
ffffffffc0201e42:	7b9010ef          	jal	ffffffffc0203dfa <memset>
    return page - pages + nbase;
ffffffffc0201e46:	0000b697          	auipc	a3,0xb
ffffffffc0201e4a:	68a6b683          	ld	a3,1674(a3) # ffffffffc020d4d0 <pages>
ffffffffc0201e4e:	6742                	ld	a4,16(sp)
ffffffffc0201e50:	00080837          	lui	a6,0x80
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201e54:	67a2                	ld	a5,8(sp)
ffffffffc0201e56:	40d706b3          	sub	a3,a4,a3
ffffffffc0201e5a:	8699                	srai	a3,a3,0x6
ffffffffc0201e5c:	96c2                	add	a3,a3,a6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201e5e:	06aa                	slli	a3,a3,0xa
ffffffffc0201e60:	0116e693          	ori	a3,a3,17
ffffffffc0201e64:	e394                	sd	a3,0(a5)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201e66:	6098                	ld	a4,0(s1)
ffffffffc0201e68:	0000b897          	auipc	a7,0xb
ffffffffc0201e6c:	65888893          	addi	a7,a7,1624 # ffffffffc020d4c0 <va_pa_offset>
ffffffffc0201e70:	c006f693          	andi	a3,a3,-1024
ffffffffc0201e74:	068a                	slli	a3,a3,0x2
ffffffffc0201e76:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201e7a:	06e7fc63          	bgeu	a5,a4,ffffffffc0201ef2 <get_pte+0x1fc>
ffffffffc0201e7e:	0008b783          	ld	a5,0(a7)
ffffffffc0201e82:	8031                	srli	s0,s0,0xc
ffffffffc0201e84:	1ff47413          	andi	s0,s0,511
ffffffffc0201e88:	040e                	slli	s0,s0,0x3
ffffffffc0201e8a:	96be                	add	a3,a3,a5
}
ffffffffc0201e8c:	70e2                	ld	ra,56(sp)
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201e8e:	00868533          	add	a0,a3,s0
}
ffffffffc0201e92:	7442                	ld	s0,48(sp)
ffffffffc0201e94:	74a2                	ld	s1,40(sp)
ffffffffc0201e96:	6121                	addi	sp,sp,64
ffffffffc0201e98:	8082                	ret
ffffffffc0201e9a:	70e2                	ld	ra,56(sp)
ffffffffc0201e9c:	7442                	ld	s0,48(sp)
ffffffffc0201e9e:	74a2                	ld	s1,40(sp)
            return NULL;
ffffffffc0201ea0:	4501                	li	a0,0
}
ffffffffc0201ea2:	6121                	addi	sp,sp,64
ffffffffc0201ea4:	8082                	ret
        intr_disable();
ffffffffc0201ea6:	e83a                	sd	a4,16(sp)
ffffffffc0201ea8:	ec32                	sd	a2,24(sp)
ffffffffc0201eaa:	9cbfe0ef          	jal	ffffffffc0200874 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201eae:	0000b797          	auipc	a5,0xb
ffffffffc0201eb2:	5fa7b783          	ld	a5,1530(a5) # ffffffffc020d4a8 <pmm_manager>
ffffffffc0201eb6:	4505                	li	a0,1
ffffffffc0201eb8:	6f9c                	ld	a5,24(a5)
ffffffffc0201eba:	9782                	jalr	a5
ffffffffc0201ebc:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201ebe:	9b1fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201ec2:	6862                	ld	a6,24(sp)
ffffffffc0201ec4:	6742                	ld	a4,16(sp)
ffffffffc0201ec6:	67a2                	ld	a5,8(sp)
ffffffffc0201ec8:	bdbd                	j	ffffffffc0201d46 <get_pte+0x50>
        intr_disable();
ffffffffc0201eca:	e83e                	sd	a5,16(sp)
ffffffffc0201ecc:	9a9fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0201ed0:	0000b717          	auipc	a4,0xb
ffffffffc0201ed4:	5d873703          	ld	a4,1496(a4) # ffffffffc020d4a8 <pmm_manager>
ffffffffc0201ed8:	4505                	li	a0,1
ffffffffc0201eda:	6f18                	ld	a4,24(a4)
ffffffffc0201edc:	9702                	jalr	a4
ffffffffc0201ede:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201ee0:	98ffe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201ee4:	6722                	ld	a4,8(sp)
ffffffffc0201ee6:	67c2                	ld	a5,16(sp)
ffffffffc0201ee8:	0000b897          	auipc	a7,0xb
ffffffffc0201eec:	5d888893          	addi	a7,a7,1496 # ffffffffc020d4c0 <va_pa_offset>
ffffffffc0201ef0:	bf31                	j	ffffffffc0201e0c <get_pte+0x116>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201ef2:	00003617          	auipc	a2,0x3
ffffffffc0201ef6:	be660613          	addi	a2,a2,-1050 # ffffffffc0204ad8 <etext+0xc90>
ffffffffc0201efa:	0fb00593          	li	a1,251
ffffffffc0201efe:	00003517          	auipc	a0,0x3
ffffffffc0201f02:	cca50513          	addi	a0,a0,-822 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0201f06:	d00fe0ef          	jal	ffffffffc0200406 <__panic>
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201f0a:	00003617          	auipc	a2,0x3
ffffffffc0201f0e:	bce60613          	addi	a2,a2,-1074 # ffffffffc0204ad8 <etext+0xc90>
ffffffffc0201f12:	0ee00593          	li	a1,238
ffffffffc0201f16:	00003517          	auipc	a0,0x3
ffffffffc0201f1a:	cb250513          	addi	a0,a0,-846 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0201f1e:	ce8fe0ef          	jal	ffffffffc0200406 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f22:	86aa                	mv	a3,a0
ffffffffc0201f24:	00003617          	auipc	a2,0x3
ffffffffc0201f28:	bb460613          	addi	a2,a2,-1100 # ffffffffc0204ad8 <etext+0xc90>
ffffffffc0201f2c:	0eb00593          	li	a1,235
ffffffffc0201f30:	00003517          	auipc	a0,0x3
ffffffffc0201f34:	c9850513          	addi	a0,a0,-872 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0201f38:	ccefe0ef          	jal	ffffffffc0200406 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f3c:	00003617          	auipc	a2,0x3
ffffffffc0201f40:	b9c60613          	addi	a2,a2,-1124 # ffffffffc0204ad8 <etext+0xc90>
ffffffffc0201f44:	0f800593          	li	a1,248
ffffffffc0201f48:	00003517          	auipc	a0,0x3
ffffffffc0201f4c:	c8050513          	addi	a0,a0,-896 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0201f50:	cb6fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201f54 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0201f54:	1141                	addi	sp,sp,-16
ffffffffc0201f56:	e022                	sd	s0,0(sp)
ffffffffc0201f58:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201f5a:	4601                	li	a2,0
{
ffffffffc0201f5c:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201f5e:	d99ff0ef          	jal	ffffffffc0201cf6 <get_pte>
    if (ptep_store != NULL)
ffffffffc0201f62:	c011                	beqz	s0,ffffffffc0201f66 <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0201f64:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0201f66:	c511                	beqz	a0,ffffffffc0201f72 <get_page+0x1e>
ffffffffc0201f68:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0201f6a:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0201f6c:	0017f713          	andi	a4,a5,1
ffffffffc0201f70:	e709                	bnez	a4,ffffffffc0201f7a <get_page+0x26>
}
ffffffffc0201f72:	60a2                	ld	ra,8(sp)
ffffffffc0201f74:	6402                	ld	s0,0(sp)
ffffffffc0201f76:	0141                	addi	sp,sp,16
ffffffffc0201f78:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0201f7a:	0000b717          	auipc	a4,0xb
ffffffffc0201f7e:	54e73703          	ld	a4,1358(a4) # ffffffffc020d4c8 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0201f82:	078a                	slli	a5,a5,0x2
ffffffffc0201f84:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201f86:	00e7ff63          	bgeu	a5,a4,ffffffffc0201fa4 <get_page+0x50>
    return &pages[PPN(pa) - nbase];
ffffffffc0201f8a:	0000b517          	auipc	a0,0xb
ffffffffc0201f8e:	54653503          	ld	a0,1350(a0) # ffffffffc020d4d0 <pages>
ffffffffc0201f92:	60a2                	ld	ra,8(sp)
ffffffffc0201f94:	6402                	ld	s0,0(sp)
ffffffffc0201f96:	079a                	slli	a5,a5,0x6
ffffffffc0201f98:	fe000737          	lui	a4,0xfe000
ffffffffc0201f9c:	97ba                	add	a5,a5,a4
ffffffffc0201f9e:	953e                	add	a0,a0,a5
ffffffffc0201fa0:	0141                	addi	sp,sp,16
ffffffffc0201fa2:	8082                	ret
ffffffffc0201fa4:	c8fff0ef          	jal	ffffffffc0201c32 <pa2page.part.0>

ffffffffc0201fa8 <page_remove>:
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
ffffffffc0201fa8:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201faa:	4601                	li	a2,0
{
ffffffffc0201fac:	e822                	sd	s0,16(sp)
ffffffffc0201fae:	ec06                	sd	ra,24(sp)
ffffffffc0201fb0:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201fb2:	d45ff0ef          	jal	ffffffffc0201cf6 <get_pte>
    if (ptep != NULL)
ffffffffc0201fb6:	c511                	beqz	a0,ffffffffc0201fc2 <page_remove+0x1a>
    if (*ptep & PTE_V)
ffffffffc0201fb8:	6118                	ld	a4,0(a0)
ffffffffc0201fba:	87aa                	mv	a5,a0
ffffffffc0201fbc:	00177693          	andi	a3,a4,1
ffffffffc0201fc0:	e689                	bnez	a3,ffffffffc0201fca <page_remove+0x22>
    {
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc0201fc2:	60e2                	ld	ra,24(sp)
ffffffffc0201fc4:	6442                	ld	s0,16(sp)
ffffffffc0201fc6:	6105                	addi	sp,sp,32
ffffffffc0201fc8:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0201fca:	0000b697          	auipc	a3,0xb
ffffffffc0201fce:	4fe6b683          	ld	a3,1278(a3) # ffffffffc020d4c8 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0201fd2:	070a                	slli	a4,a4,0x2
ffffffffc0201fd4:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc0201fd6:	06d77563          	bgeu	a4,a3,ffffffffc0202040 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0201fda:	0000b517          	auipc	a0,0xb
ffffffffc0201fde:	4f653503          	ld	a0,1270(a0) # ffffffffc020d4d0 <pages>
ffffffffc0201fe2:	071a                	slli	a4,a4,0x6
ffffffffc0201fe4:	fe0006b7          	lui	a3,0xfe000
ffffffffc0201fe8:	9736                	add	a4,a4,a3
ffffffffc0201fea:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc0201fec:	4118                	lw	a4,0(a0)
ffffffffc0201fee:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3ddf2b07>
ffffffffc0201ff0:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0201ff2:	cb09                	beqz	a4,ffffffffc0202004 <page_remove+0x5c>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc0201ff4:	0007b023          	sd	zero,0(a5)
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    // flush_tlb();
    // The flush_tlb flush the entire TLB, is there any better way?
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201ff8:	12040073          	sfence.vma	s0
}
ffffffffc0201ffc:	60e2                	ld	ra,24(sp)
ffffffffc0201ffe:	6442                	ld	s0,16(sp)
ffffffffc0202000:	6105                	addi	sp,sp,32
ffffffffc0202002:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202004:	10002773          	csrr	a4,sstatus
ffffffffc0202008:	8b09                	andi	a4,a4,2
ffffffffc020200a:	eb19                	bnez	a4,ffffffffc0202020 <page_remove+0x78>
        pmm_manager->free_pages(base, n);
ffffffffc020200c:	0000b717          	auipc	a4,0xb
ffffffffc0202010:	49c73703          	ld	a4,1180(a4) # ffffffffc020d4a8 <pmm_manager>
ffffffffc0202014:	4585                	li	a1,1
ffffffffc0202016:	e03e                	sd	a5,0(sp)
ffffffffc0202018:	7318                	ld	a4,32(a4)
ffffffffc020201a:	9702                	jalr	a4
    if (flag) {
ffffffffc020201c:	6782                	ld	a5,0(sp)
ffffffffc020201e:	bfd9                	j	ffffffffc0201ff4 <page_remove+0x4c>
        intr_disable();
ffffffffc0202020:	e43e                	sd	a5,8(sp)
ffffffffc0202022:	e02a                	sd	a0,0(sp)
ffffffffc0202024:	851fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0202028:	0000b717          	auipc	a4,0xb
ffffffffc020202c:	48073703          	ld	a4,1152(a4) # ffffffffc020d4a8 <pmm_manager>
ffffffffc0202030:	6502                	ld	a0,0(sp)
ffffffffc0202032:	4585                	li	a1,1
ffffffffc0202034:	7318                	ld	a4,32(a4)
ffffffffc0202036:	9702                	jalr	a4
        intr_enable();
ffffffffc0202038:	837fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc020203c:	67a2                	ld	a5,8(sp)
ffffffffc020203e:	bf5d                	j	ffffffffc0201ff4 <page_remove+0x4c>
ffffffffc0202040:	bf3ff0ef          	jal	ffffffffc0201c32 <pa2page.part.0>

ffffffffc0202044 <page_insert>:
{
ffffffffc0202044:	7139                	addi	sp,sp,-64
ffffffffc0202046:	f426                	sd	s1,40(sp)
ffffffffc0202048:	84b2                	mv	s1,a2
ffffffffc020204a:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020204c:	4605                	li	a2,1
{
ffffffffc020204e:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202050:	85a6                	mv	a1,s1
{
ffffffffc0202052:	fc06                	sd	ra,56(sp)
ffffffffc0202054:	e436                	sd	a3,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202056:	ca1ff0ef          	jal	ffffffffc0201cf6 <get_pte>
    if (ptep == NULL)
ffffffffc020205a:	cd61                	beqz	a0,ffffffffc0202132 <page_insert+0xee>
    page->ref += 1;
ffffffffc020205c:	400c                	lw	a1,0(s0)
    if (*ptep & PTE_V)
ffffffffc020205e:	611c                	ld	a5,0(a0)
ffffffffc0202060:	66a2                	ld	a3,8(sp)
ffffffffc0202062:	0015861b          	addiw	a2,a1,1 # 1001 <kern_entry-0xffffffffc01fefff>
ffffffffc0202066:	c010                	sw	a2,0(s0)
ffffffffc0202068:	0017f613          	andi	a2,a5,1
ffffffffc020206c:	872a                	mv	a4,a0
ffffffffc020206e:	e61d                	bnez	a2,ffffffffc020209c <page_insert+0x58>
    return &pages[PPN(pa) - nbase];
ffffffffc0202070:	0000b617          	auipc	a2,0xb
ffffffffc0202074:	46063603          	ld	a2,1120(a2) # ffffffffc020d4d0 <pages>
    return page - pages + nbase;
ffffffffc0202078:	8c11                	sub	s0,s0,a2
ffffffffc020207a:	8419                	srai	s0,s0,0x6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020207c:	200007b7          	lui	a5,0x20000
ffffffffc0202080:	042a                	slli	s0,s0,0xa
ffffffffc0202082:	943e                	add	s0,s0,a5
ffffffffc0202084:	8ec1                	or	a3,a3,s0
ffffffffc0202086:	0016e693          	ori	a3,a3,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc020208a:	e314                	sd	a3,0(a4)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020208c:	12048073          	sfence.vma	s1
    return 0;
ffffffffc0202090:	4501                	li	a0,0
}
ffffffffc0202092:	70e2                	ld	ra,56(sp)
ffffffffc0202094:	7442                	ld	s0,48(sp)
ffffffffc0202096:	74a2                	ld	s1,40(sp)
ffffffffc0202098:	6121                	addi	sp,sp,64
ffffffffc020209a:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc020209c:	0000b617          	auipc	a2,0xb
ffffffffc02020a0:	42c63603          	ld	a2,1068(a2) # ffffffffc020d4c8 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc02020a4:	078a                	slli	a5,a5,0x2
ffffffffc02020a6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02020a8:	08c7f763          	bgeu	a5,a2,ffffffffc0202136 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc02020ac:	0000b617          	auipc	a2,0xb
ffffffffc02020b0:	42463603          	ld	a2,1060(a2) # ffffffffc020d4d0 <pages>
ffffffffc02020b4:	fe000537          	lui	a0,0xfe000
ffffffffc02020b8:	079a                	slli	a5,a5,0x6
ffffffffc02020ba:	97aa                	add	a5,a5,a0
ffffffffc02020bc:	00f60533          	add	a0,a2,a5
        if (p == page)
ffffffffc02020c0:	00a40963          	beq	s0,a0,ffffffffc02020d2 <page_insert+0x8e>
    page->ref -= 1;
ffffffffc02020c4:	411c                	lw	a5,0(a0)
ffffffffc02020c6:	37fd                	addiw	a5,a5,-1 # 1fffffff <kern_entry-0xffffffffa0200001>
ffffffffc02020c8:	c11c                	sw	a5,0(a0)
        if (page_ref(page) ==
ffffffffc02020ca:	c791                	beqz	a5,ffffffffc02020d6 <page_insert+0x92>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02020cc:	12048073          	sfence.vma	s1
}
ffffffffc02020d0:	b765                	j	ffffffffc0202078 <page_insert+0x34>
ffffffffc02020d2:	c00c                	sw	a1,0(s0)
    return page->ref;
ffffffffc02020d4:	b755                	j	ffffffffc0202078 <page_insert+0x34>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02020d6:	100027f3          	csrr	a5,sstatus
ffffffffc02020da:	8b89                	andi	a5,a5,2
ffffffffc02020dc:	e39d                	bnez	a5,ffffffffc0202102 <page_insert+0xbe>
        pmm_manager->free_pages(base, n);
ffffffffc02020de:	0000b797          	auipc	a5,0xb
ffffffffc02020e2:	3ca7b783          	ld	a5,970(a5) # ffffffffc020d4a8 <pmm_manager>
ffffffffc02020e6:	4585                	li	a1,1
ffffffffc02020e8:	e83a                	sd	a4,16(sp)
ffffffffc02020ea:	739c                	ld	a5,32(a5)
ffffffffc02020ec:	e436                	sd	a3,8(sp)
ffffffffc02020ee:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc02020f0:	0000b617          	auipc	a2,0xb
ffffffffc02020f4:	3e063603          	ld	a2,992(a2) # ffffffffc020d4d0 <pages>
ffffffffc02020f8:	66a2                	ld	a3,8(sp)
ffffffffc02020fa:	6742                	ld	a4,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02020fc:	12048073          	sfence.vma	s1
ffffffffc0202100:	bfa5                	j	ffffffffc0202078 <page_insert+0x34>
        intr_disable();
ffffffffc0202102:	ec3a                	sd	a4,24(sp)
ffffffffc0202104:	e836                	sd	a3,16(sp)
ffffffffc0202106:	e42a                	sd	a0,8(sp)
ffffffffc0202108:	f6cfe0ef          	jal	ffffffffc0200874 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020210c:	0000b797          	auipc	a5,0xb
ffffffffc0202110:	39c7b783          	ld	a5,924(a5) # ffffffffc020d4a8 <pmm_manager>
ffffffffc0202114:	6522                	ld	a0,8(sp)
ffffffffc0202116:	4585                	li	a1,1
ffffffffc0202118:	739c                	ld	a5,32(a5)
ffffffffc020211a:	9782                	jalr	a5
        intr_enable();
ffffffffc020211c:	f52fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202120:	0000b617          	auipc	a2,0xb
ffffffffc0202124:	3b063603          	ld	a2,944(a2) # ffffffffc020d4d0 <pages>
ffffffffc0202128:	6762                	ld	a4,24(sp)
ffffffffc020212a:	66c2                	ld	a3,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020212c:	12048073          	sfence.vma	s1
ffffffffc0202130:	b7a1                	j	ffffffffc0202078 <page_insert+0x34>
        return -E_NO_MEM;
ffffffffc0202132:	5571                	li	a0,-4
ffffffffc0202134:	bfb9                	j	ffffffffc0202092 <page_insert+0x4e>
ffffffffc0202136:	afdff0ef          	jal	ffffffffc0201c32 <pa2page.part.0>

ffffffffc020213a <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc020213a:	00003797          	auipc	a5,0x3
ffffffffc020213e:	56678793          	addi	a5,a5,1382 # ffffffffc02056a0 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202142:	638c                	ld	a1,0(a5)
{
ffffffffc0202144:	7159                	addi	sp,sp,-112
ffffffffc0202146:	f486                	sd	ra,104(sp)
ffffffffc0202148:	e8ca                	sd	s2,80(sp)
ffffffffc020214a:	e4ce                	sd	s3,72(sp)
ffffffffc020214c:	f85a                	sd	s6,48(sp)
ffffffffc020214e:	f0a2                	sd	s0,96(sp)
ffffffffc0202150:	eca6                	sd	s1,88(sp)
ffffffffc0202152:	e0d2                	sd	s4,64(sp)
ffffffffc0202154:	fc56                	sd	s5,56(sp)
ffffffffc0202156:	f45e                	sd	s7,40(sp)
ffffffffc0202158:	f062                	sd	s8,32(sp)
ffffffffc020215a:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc020215c:	0000bb17          	auipc	s6,0xb
ffffffffc0202160:	34cb0b13          	addi	s6,s6,844 # ffffffffc020d4a8 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202164:	00003517          	auipc	a0,0x3
ffffffffc0202168:	a7450513          	addi	a0,a0,-1420 # ffffffffc0204bd8 <etext+0xd90>
    pmm_manager = &default_pmm_manager;
ffffffffc020216c:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202170:	824fe0ef          	jal	ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc0202174:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202178:	0000b997          	auipc	s3,0xb
ffffffffc020217c:	34898993          	addi	s3,s3,840 # ffffffffc020d4c0 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202180:	679c                	ld	a5,8(a5)
ffffffffc0202182:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202184:	57f5                	li	a5,-3
ffffffffc0202186:	07fa                	slli	a5,a5,0x1e
ffffffffc0202188:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc020218c:	ecefe0ef          	jal	ffffffffc020085a <get_memory_base>
ffffffffc0202190:	892a                	mv	s2,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0202192:	ed2fe0ef          	jal	ffffffffc0200864 <get_memory_size>
    if (mem_size == 0) {
ffffffffc0202196:	70050e63          	beqz	a0,ffffffffc02028b2 <pmm_init+0x778>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc020219a:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc020219c:	00003517          	auipc	a0,0x3
ffffffffc02021a0:	a7450513          	addi	a0,a0,-1420 # ffffffffc0204c10 <etext+0xdc8>
ffffffffc02021a4:	ff1fd0ef          	jal	ffffffffc0200194 <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02021a8:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc02021ac:	864a                	mv	a2,s2
ffffffffc02021ae:	85a6                	mv	a1,s1
ffffffffc02021b0:	fff40693          	addi	a3,s0,-1
ffffffffc02021b4:	00003517          	auipc	a0,0x3
ffffffffc02021b8:	a7450513          	addi	a0,a0,-1420 # ffffffffc0204c28 <etext+0xde0>
ffffffffc02021bc:	fd9fd0ef          	jal	ffffffffc0200194 <cprintf>
    if (maxpa > KERNTOP)
ffffffffc02021c0:	c80007b7          	lui	a5,0xc8000
ffffffffc02021c4:	8522                	mv	a0,s0
ffffffffc02021c6:	5287ed63          	bltu	a5,s0,ffffffffc0202700 <pmm_init+0x5c6>
ffffffffc02021ca:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02021cc:	0000c617          	auipc	a2,0xc
ffffffffc02021d0:	32b60613          	addi	a2,a2,811 # ffffffffc020e4f7 <end+0xfff>
ffffffffc02021d4:	8e7d                	and	a2,a2,a5
    npage = maxpa / PGSIZE;
ffffffffc02021d6:	8131                	srli	a0,a0,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02021d8:	0000bb97          	auipc	s7,0xb
ffffffffc02021dc:	2f8b8b93          	addi	s7,s7,760 # ffffffffc020d4d0 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02021e0:	0000b497          	auipc	s1,0xb
ffffffffc02021e4:	2e848493          	addi	s1,s1,744 # ffffffffc020d4c8 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02021e8:	00cbb023          	sd	a2,0(s7)
    npage = maxpa / PGSIZE;
ffffffffc02021ec:	e088                	sd	a0,0(s1)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02021ee:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02021f2:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02021f4:	02f50763          	beq	a0,a5,ffffffffc0202222 <pmm_init+0xe8>
ffffffffc02021f8:	4701                	li	a4,0
ffffffffc02021fa:	4585                	li	a1,1
ffffffffc02021fc:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0202200:	00671793          	slli	a5,a4,0x6
ffffffffc0202204:	97b2                	add	a5,a5,a2
ffffffffc0202206:	07a1                	addi	a5,a5,8 # 80008 <kern_entry-0xffffffffc017fff8>
ffffffffc0202208:	40b7b02f          	amoor.d	zero,a1,(a5)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020220c:	6088                	ld	a0,0(s1)
ffffffffc020220e:	0705                	addi	a4,a4,1
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202210:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202214:	00d507b3          	add	a5,a0,a3
ffffffffc0202218:	fef764e3          	bltu	a4,a5,ffffffffc0202200 <pmm_init+0xc6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020221c:	079a                	slli	a5,a5,0x6
ffffffffc020221e:	00f606b3          	add	a3,a2,a5
ffffffffc0202222:	c02007b7          	lui	a5,0xc0200
ffffffffc0202226:	16f6eee3          	bltu	a3,a5,ffffffffc0202ba2 <pmm_init+0xa68>
ffffffffc020222a:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc020222e:	77fd                	lui	a5,0xfffff
ffffffffc0202230:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202232:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202234:	4e86ed63          	bltu	a3,s0,ffffffffc020272e <pmm_init+0x5f4>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202238:	00003517          	auipc	a0,0x3
ffffffffc020223c:	a1850513          	addi	a0,a0,-1512 # ffffffffc0204c50 <etext+0xe08>
ffffffffc0202240:	f55fd0ef          	jal	ffffffffc0200194 <cprintf>
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202244:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202248:	0000b917          	auipc	s2,0xb
ffffffffc020224c:	27090913          	addi	s2,s2,624 # ffffffffc020d4b8 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202250:	7b9c                	ld	a5,48(a5)
ffffffffc0202252:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202254:	00003517          	auipc	a0,0x3
ffffffffc0202258:	a1450513          	addi	a0,a0,-1516 # ffffffffc0204c68 <etext+0xe20>
ffffffffc020225c:	f39fd0ef          	jal	ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202260:	00006697          	auipc	a3,0x6
ffffffffc0202264:	da068693          	addi	a3,a3,-608 # ffffffffc0208000 <boot_page_table_sv39>
ffffffffc0202268:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020226c:	c02007b7          	lui	a5,0xc0200
ffffffffc0202270:	2af6eee3          	bltu	a3,a5,ffffffffc0202d2c <pmm_init+0xbf2>
ffffffffc0202274:	0009b783          	ld	a5,0(s3)
ffffffffc0202278:	8e9d                	sub	a3,a3,a5
ffffffffc020227a:	0000b797          	auipc	a5,0xb
ffffffffc020227e:	22d7bb23          	sd	a3,566(a5) # ffffffffc020d4b0 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202282:	100027f3          	csrr	a5,sstatus
ffffffffc0202286:	8b89                	andi	a5,a5,2
ffffffffc0202288:	48079963          	bnez	a5,ffffffffc020271a <pmm_init+0x5e0>
        ret = pmm_manager->nr_free_pages();
ffffffffc020228c:	000b3783          	ld	a5,0(s6)
ffffffffc0202290:	779c                	ld	a5,40(a5)
ffffffffc0202292:	9782                	jalr	a5
ffffffffc0202294:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202296:	6098                	ld	a4,0(s1)
ffffffffc0202298:	c80007b7          	lui	a5,0xc8000
ffffffffc020229c:	83b1                	srli	a5,a5,0xc
ffffffffc020229e:	66e7e663          	bltu	a5,a4,ffffffffc020290a <pmm_init+0x7d0>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02022a2:	00093503          	ld	a0,0(s2)
ffffffffc02022a6:	64050263          	beqz	a0,ffffffffc02028ea <pmm_init+0x7b0>
ffffffffc02022aa:	03451793          	slli	a5,a0,0x34
ffffffffc02022ae:	62079e63          	bnez	a5,ffffffffc02028ea <pmm_init+0x7b0>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02022b2:	4601                	li	a2,0
ffffffffc02022b4:	4581                	li	a1,0
ffffffffc02022b6:	c9fff0ef          	jal	ffffffffc0201f54 <get_page>
ffffffffc02022ba:	240519e3          	bnez	a0,ffffffffc0202d0c <pmm_init+0xbd2>
ffffffffc02022be:	100027f3          	csrr	a5,sstatus
ffffffffc02022c2:	8b89                	andi	a5,a5,2
ffffffffc02022c4:	44079063          	bnez	a5,ffffffffc0202704 <pmm_init+0x5ca>
        page = pmm_manager->alloc_pages(n);
ffffffffc02022c8:	000b3783          	ld	a5,0(s6)
ffffffffc02022cc:	4505                	li	a0,1
ffffffffc02022ce:	6f9c                	ld	a5,24(a5)
ffffffffc02022d0:	9782                	jalr	a5
ffffffffc02022d2:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02022d4:	00093503          	ld	a0,0(s2)
ffffffffc02022d8:	4681                	li	a3,0
ffffffffc02022da:	4601                	li	a2,0
ffffffffc02022dc:	85d2                	mv	a1,s4
ffffffffc02022de:	d67ff0ef          	jal	ffffffffc0202044 <page_insert>
ffffffffc02022e2:	280511e3          	bnez	a0,ffffffffc0202d64 <pmm_init+0xc2a>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02022e6:	00093503          	ld	a0,0(s2)
ffffffffc02022ea:	4601                	li	a2,0
ffffffffc02022ec:	4581                	li	a1,0
ffffffffc02022ee:	a09ff0ef          	jal	ffffffffc0201cf6 <get_pte>
ffffffffc02022f2:	240509e3          	beqz	a0,ffffffffc0202d44 <pmm_init+0xc0a>
    assert(pte2page(*ptep) == p1);
ffffffffc02022f6:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc02022f8:	0017f713          	andi	a4,a5,1
ffffffffc02022fc:	58070f63          	beqz	a4,ffffffffc020289a <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc0202300:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202302:	078a                	slli	a5,a5,0x2
ffffffffc0202304:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202306:	58e7f863          	bgeu	a5,a4,ffffffffc0202896 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc020230a:	000bb683          	ld	a3,0(s7)
ffffffffc020230e:	079a                	slli	a5,a5,0x6
ffffffffc0202310:	fe000637          	lui	a2,0xfe000
ffffffffc0202314:	97b2                	add	a5,a5,a2
ffffffffc0202316:	97b6                	add	a5,a5,a3
ffffffffc0202318:	14fa1ae3          	bne	s4,a5,ffffffffc0202c6c <pmm_init+0xb32>
    assert(page_ref(p1) == 1);
ffffffffc020231c:	000a2683          	lw	a3,0(s4)
ffffffffc0202320:	4785                	li	a5,1
ffffffffc0202322:	12f695e3          	bne	a3,a5,ffffffffc0202c4c <pmm_init+0xb12>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202326:	00093503          	ld	a0,0(s2)
ffffffffc020232a:	77fd                	lui	a5,0xfffff
ffffffffc020232c:	6114                	ld	a3,0(a0)
ffffffffc020232e:	068a                	slli	a3,a3,0x2
ffffffffc0202330:	8efd                	and	a3,a3,a5
ffffffffc0202332:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202336:	0ee67fe3          	bgeu	a2,a4,ffffffffc0202c34 <pmm_init+0xafa>
ffffffffc020233a:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020233e:	96e2                	add	a3,a3,s8
ffffffffc0202340:	0006ba83          	ld	s5,0(a3)
ffffffffc0202344:	0a8a                	slli	s5,s5,0x2
ffffffffc0202346:	00fafab3          	and	s5,s5,a5
ffffffffc020234a:	00cad793          	srli	a5,s5,0xc
ffffffffc020234e:	0ce7f6e3          	bgeu	a5,a4,ffffffffc0202c1a <pmm_init+0xae0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202352:	4601                	li	a2,0
ffffffffc0202354:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202356:	9c56                	add	s8,s8,s5
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202358:	99fff0ef          	jal	ffffffffc0201cf6 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020235c:	0c21                	addi	s8,s8,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020235e:	05851ee3          	bne	a0,s8,ffffffffc0202bba <pmm_init+0xa80>
ffffffffc0202362:	100027f3          	csrr	a5,sstatus
ffffffffc0202366:	8b89                	andi	a5,a5,2
ffffffffc0202368:	3e079b63          	bnez	a5,ffffffffc020275e <pmm_init+0x624>
        page = pmm_manager->alloc_pages(n);
ffffffffc020236c:	000b3783          	ld	a5,0(s6)
ffffffffc0202370:	4505                	li	a0,1
ffffffffc0202372:	6f9c                	ld	a5,24(a5)
ffffffffc0202374:	9782                	jalr	a5
ffffffffc0202376:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202378:	00093503          	ld	a0,0(s2)
ffffffffc020237c:	46d1                	li	a3,20
ffffffffc020237e:	6605                	lui	a2,0x1
ffffffffc0202380:	85e2                	mv	a1,s8
ffffffffc0202382:	cc3ff0ef          	jal	ffffffffc0202044 <page_insert>
ffffffffc0202386:	06051ae3          	bnez	a0,ffffffffc0202bfa <pmm_init+0xac0>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020238a:	00093503          	ld	a0,0(s2)
ffffffffc020238e:	4601                	li	a2,0
ffffffffc0202390:	6585                	lui	a1,0x1
ffffffffc0202392:	965ff0ef          	jal	ffffffffc0201cf6 <get_pte>
ffffffffc0202396:	040502e3          	beqz	a0,ffffffffc0202bda <pmm_init+0xaa0>
    assert(*ptep & PTE_U);
ffffffffc020239a:	611c                	ld	a5,0(a0)
ffffffffc020239c:	0107f713          	andi	a4,a5,16
ffffffffc02023a0:	7e070163          	beqz	a4,ffffffffc0202b82 <pmm_init+0xa48>
    assert(*ptep & PTE_W);
ffffffffc02023a4:	8b91                	andi	a5,a5,4
ffffffffc02023a6:	7a078e63          	beqz	a5,ffffffffc0202b62 <pmm_init+0xa28>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02023aa:	00093503          	ld	a0,0(s2)
ffffffffc02023ae:	611c                	ld	a5,0(a0)
ffffffffc02023b0:	8bc1                	andi	a5,a5,16
ffffffffc02023b2:	78078863          	beqz	a5,ffffffffc0202b42 <pmm_init+0xa08>
    assert(page_ref(p2) == 1);
ffffffffc02023b6:	000c2703          	lw	a4,0(s8)
ffffffffc02023ba:	4785                	li	a5,1
ffffffffc02023bc:	76f71363          	bne	a4,a5,ffffffffc0202b22 <pmm_init+0x9e8>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02023c0:	4681                	li	a3,0
ffffffffc02023c2:	6605                	lui	a2,0x1
ffffffffc02023c4:	85d2                	mv	a1,s4
ffffffffc02023c6:	c7fff0ef          	jal	ffffffffc0202044 <page_insert>
ffffffffc02023ca:	72051c63          	bnez	a0,ffffffffc0202b02 <pmm_init+0x9c8>
    assert(page_ref(p1) == 2);
ffffffffc02023ce:	000a2703          	lw	a4,0(s4)
ffffffffc02023d2:	4789                	li	a5,2
ffffffffc02023d4:	70f71763          	bne	a4,a5,ffffffffc0202ae2 <pmm_init+0x9a8>
    assert(page_ref(p2) == 0);
ffffffffc02023d8:	000c2783          	lw	a5,0(s8)
ffffffffc02023dc:	6e079363          	bnez	a5,ffffffffc0202ac2 <pmm_init+0x988>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02023e0:	00093503          	ld	a0,0(s2)
ffffffffc02023e4:	4601                	li	a2,0
ffffffffc02023e6:	6585                	lui	a1,0x1
ffffffffc02023e8:	90fff0ef          	jal	ffffffffc0201cf6 <get_pte>
ffffffffc02023ec:	6a050b63          	beqz	a0,ffffffffc0202aa2 <pmm_init+0x968>
    assert(pte2page(*ptep) == p1);
ffffffffc02023f0:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc02023f2:	00177793          	andi	a5,a4,1
ffffffffc02023f6:	4a078263          	beqz	a5,ffffffffc020289a <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc02023fa:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02023fc:	00271793          	slli	a5,a4,0x2
ffffffffc0202400:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202402:	48d7fa63          	bgeu	a5,a3,ffffffffc0202896 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202406:	000bb683          	ld	a3,0(s7)
ffffffffc020240a:	fff80ab7          	lui	s5,0xfff80
ffffffffc020240e:	97d6                	add	a5,a5,s5
ffffffffc0202410:	079a                	slli	a5,a5,0x6
ffffffffc0202412:	97b6                	add	a5,a5,a3
ffffffffc0202414:	66fa1763          	bne	s4,a5,ffffffffc0202a82 <pmm_init+0x948>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202418:	8b41                	andi	a4,a4,16
ffffffffc020241a:	64071463          	bnez	a4,ffffffffc0202a62 <pmm_init+0x928>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc020241e:	00093503          	ld	a0,0(s2)
ffffffffc0202422:	4581                	li	a1,0
ffffffffc0202424:	b85ff0ef          	jal	ffffffffc0201fa8 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202428:	000a2c83          	lw	s9,0(s4)
ffffffffc020242c:	4785                	li	a5,1
ffffffffc020242e:	60fc9a63          	bne	s9,a5,ffffffffc0202a42 <pmm_init+0x908>
    assert(page_ref(p2) == 0);
ffffffffc0202432:	000c2783          	lw	a5,0(s8)
ffffffffc0202436:	5e079663          	bnez	a5,ffffffffc0202a22 <pmm_init+0x8e8>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc020243a:	00093503          	ld	a0,0(s2)
ffffffffc020243e:	6585                	lui	a1,0x1
ffffffffc0202440:	b69ff0ef          	jal	ffffffffc0201fa8 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202444:	000a2783          	lw	a5,0(s4)
ffffffffc0202448:	52079d63          	bnez	a5,ffffffffc0202982 <pmm_init+0x848>
    assert(page_ref(p2) == 0);
ffffffffc020244c:	000c2783          	lw	a5,0(s8)
ffffffffc0202450:	50079963          	bnez	a5,ffffffffc0202962 <pmm_init+0x828>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202454:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202458:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020245a:	000a3783          	ld	a5,0(s4)
ffffffffc020245e:	078a                	slli	a5,a5,0x2
ffffffffc0202460:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202462:	42e7fa63          	bgeu	a5,a4,ffffffffc0202896 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202466:	000bb503          	ld	a0,0(s7)
ffffffffc020246a:	97d6                	add	a5,a5,s5
ffffffffc020246c:	079a                	slli	a5,a5,0x6
    return page->ref;
ffffffffc020246e:	00f506b3          	add	a3,a0,a5
ffffffffc0202472:	4294                	lw	a3,0(a3)
ffffffffc0202474:	4d969763          	bne	a3,s9,ffffffffc0202942 <pmm_init+0x808>
    return page - pages + nbase;
ffffffffc0202478:	8799                	srai	a5,a5,0x6
ffffffffc020247a:	00080637          	lui	a2,0x80
ffffffffc020247e:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202480:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202484:	4ae7f363          	bgeu	a5,a4,ffffffffc020292a <pmm_init+0x7f0>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202488:	0009b783          	ld	a5,0(s3)
ffffffffc020248c:	97b6                	add	a5,a5,a3
    return pa2page(PDE_ADDR(pde));
ffffffffc020248e:	639c                	ld	a5,0(a5)
ffffffffc0202490:	078a                	slli	a5,a5,0x2
ffffffffc0202492:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202494:	40e7f163          	bgeu	a5,a4,ffffffffc0202896 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202498:	8f91                	sub	a5,a5,a2
ffffffffc020249a:	079a                	slli	a5,a5,0x6
ffffffffc020249c:	953e                	add	a0,a0,a5
ffffffffc020249e:	100027f3          	csrr	a5,sstatus
ffffffffc02024a2:	8b89                	andi	a5,a5,2
ffffffffc02024a4:	30079863          	bnez	a5,ffffffffc02027b4 <pmm_init+0x67a>
        pmm_manager->free_pages(base, n);
ffffffffc02024a8:	000b3783          	ld	a5,0(s6)
ffffffffc02024ac:	4585                	li	a1,1
ffffffffc02024ae:	739c                	ld	a5,32(a5)
ffffffffc02024b0:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02024b2:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc02024b6:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02024b8:	078a                	slli	a5,a5,0x2
ffffffffc02024ba:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02024bc:	3ce7fd63          	bgeu	a5,a4,ffffffffc0202896 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc02024c0:	000bb503          	ld	a0,0(s7)
ffffffffc02024c4:	fe000737          	lui	a4,0xfe000
ffffffffc02024c8:	079a                	slli	a5,a5,0x6
ffffffffc02024ca:	97ba                	add	a5,a5,a4
ffffffffc02024cc:	953e                	add	a0,a0,a5
ffffffffc02024ce:	100027f3          	csrr	a5,sstatus
ffffffffc02024d2:	8b89                	andi	a5,a5,2
ffffffffc02024d4:	2c079463          	bnez	a5,ffffffffc020279c <pmm_init+0x662>
ffffffffc02024d8:	000b3783          	ld	a5,0(s6)
ffffffffc02024dc:	4585                	li	a1,1
ffffffffc02024de:	739c                	ld	a5,32(a5)
ffffffffc02024e0:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc02024e2:	00093783          	ld	a5,0(s2)
ffffffffc02024e6:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fdf1b08>
    asm volatile("sfence.vma");
ffffffffc02024ea:	12000073          	sfence.vma
ffffffffc02024ee:	100027f3          	csrr	a5,sstatus
ffffffffc02024f2:	8b89                	andi	a5,a5,2
ffffffffc02024f4:	28079a63          	bnez	a5,ffffffffc0202788 <pmm_init+0x64e>
        ret = pmm_manager->nr_free_pages();
ffffffffc02024f8:	000b3783          	ld	a5,0(s6)
ffffffffc02024fc:	779c                	ld	a5,40(a5)
ffffffffc02024fe:	9782                	jalr	a5
ffffffffc0202500:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202502:	4d441063          	bne	s0,s4,ffffffffc02029c2 <pmm_init+0x888>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202506:	00003517          	auipc	a0,0x3
ffffffffc020250a:	ab250513          	addi	a0,a0,-1358 # ffffffffc0204fb8 <etext+0x1170>
ffffffffc020250e:	c87fd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0202512:	100027f3          	csrr	a5,sstatus
ffffffffc0202516:	8b89                	andi	a5,a5,2
ffffffffc0202518:	24079e63          	bnez	a5,ffffffffc0202774 <pmm_init+0x63a>
        ret = pmm_manager->nr_free_pages();
ffffffffc020251c:	000b3783          	ld	a5,0(s6)
ffffffffc0202520:	779c                	ld	a5,40(a5)
ffffffffc0202522:	9782                	jalr	a5
ffffffffc0202524:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202526:	609c                	ld	a5,0(s1)
ffffffffc0202528:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc020252c:	7a7d                	lui	s4,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc020252e:	00c79713          	slli	a4,a5,0xc
ffffffffc0202532:	6a85                	lui	s5,0x1
ffffffffc0202534:	02e47c63          	bgeu	s0,a4,ffffffffc020256c <pmm_init+0x432>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202538:	00c45713          	srli	a4,s0,0xc
ffffffffc020253c:	30f77063          	bgeu	a4,a5,ffffffffc020283c <pmm_init+0x702>
ffffffffc0202540:	0009b583          	ld	a1,0(s3)
ffffffffc0202544:	00093503          	ld	a0,0(s2)
ffffffffc0202548:	4601                	li	a2,0
ffffffffc020254a:	95a2                	add	a1,a1,s0
ffffffffc020254c:	faaff0ef          	jal	ffffffffc0201cf6 <get_pte>
ffffffffc0202550:	32050363          	beqz	a0,ffffffffc0202876 <pmm_init+0x73c>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202554:	611c                	ld	a5,0(a0)
ffffffffc0202556:	078a                	slli	a5,a5,0x2
ffffffffc0202558:	0147f7b3          	and	a5,a5,s4
ffffffffc020255c:	2e879d63          	bne	a5,s0,ffffffffc0202856 <pmm_init+0x71c>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202560:	609c                	ld	a5,0(s1)
ffffffffc0202562:	9456                	add	s0,s0,s5
ffffffffc0202564:	00c79713          	slli	a4,a5,0xc
ffffffffc0202568:	fce468e3          	bltu	s0,a4,ffffffffc0202538 <pmm_init+0x3fe>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc020256c:	00093783          	ld	a5,0(s2)
ffffffffc0202570:	639c                	ld	a5,0(a5)
ffffffffc0202572:	42079863          	bnez	a5,ffffffffc02029a2 <pmm_init+0x868>
ffffffffc0202576:	100027f3          	csrr	a5,sstatus
ffffffffc020257a:	8b89                	andi	a5,a5,2
ffffffffc020257c:	24079863          	bnez	a5,ffffffffc02027cc <pmm_init+0x692>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202580:	000b3783          	ld	a5,0(s6)
ffffffffc0202584:	4505                	li	a0,1
ffffffffc0202586:	6f9c                	ld	a5,24(a5)
ffffffffc0202588:	9782                	jalr	a5
ffffffffc020258a:	842a                	mv	s0,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc020258c:	00093503          	ld	a0,0(s2)
ffffffffc0202590:	4699                	li	a3,6
ffffffffc0202592:	10000613          	li	a2,256
ffffffffc0202596:	85a2                	mv	a1,s0
ffffffffc0202598:	aadff0ef          	jal	ffffffffc0202044 <page_insert>
ffffffffc020259c:	46051363          	bnez	a0,ffffffffc0202a02 <pmm_init+0x8c8>
    assert(page_ref(p) == 1);
ffffffffc02025a0:	4018                	lw	a4,0(s0)
ffffffffc02025a2:	4785                	li	a5,1
ffffffffc02025a4:	42f71f63          	bne	a4,a5,ffffffffc02029e2 <pmm_init+0x8a8>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02025a8:	00093503          	ld	a0,0(s2)
ffffffffc02025ac:	6605                	lui	a2,0x1
ffffffffc02025ae:	10060613          	addi	a2,a2,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc02025b2:	4699                	li	a3,6
ffffffffc02025b4:	85a2                	mv	a1,s0
ffffffffc02025b6:	a8fff0ef          	jal	ffffffffc0202044 <page_insert>
ffffffffc02025ba:	72051963          	bnez	a0,ffffffffc0202cec <pmm_init+0xbb2>
    assert(page_ref(p) == 2);
ffffffffc02025be:	4018                	lw	a4,0(s0)
ffffffffc02025c0:	4789                	li	a5,2
ffffffffc02025c2:	70f71563          	bne	a4,a5,ffffffffc0202ccc <pmm_init+0xb92>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc02025c6:	00003597          	auipc	a1,0x3
ffffffffc02025ca:	b3a58593          	addi	a1,a1,-1222 # ffffffffc0205100 <etext+0x12b8>
ffffffffc02025ce:	10000513          	li	a0,256
ffffffffc02025d2:	7a8010ef          	jal	ffffffffc0203d7a <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02025d6:	6585                	lui	a1,0x1
ffffffffc02025d8:	10058593          	addi	a1,a1,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc02025dc:	10000513          	li	a0,256
ffffffffc02025e0:	7ac010ef          	jal	ffffffffc0203d8c <strcmp>
ffffffffc02025e4:	6c051463          	bnez	a0,ffffffffc0202cac <pmm_init+0xb72>
    return page - pages + nbase;
ffffffffc02025e8:	000bb683          	ld	a3,0(s7)
ffffffffc02025ec:	000807b7          	lui	a5,0x80
    return KADDR(page2pa(page));
ffffffffc02025f0:	6098                	ld	a4,0(s1)
    return page - pages + nbase;
ffffffffc02025f2:	40d406b3          	sub	a3,s0,a3
ffffffffc02025f6:	8699                	srai	a3,a3,0x6
ffffffffc02025f8:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc02025fa:	00c69793          	slli	a5,a3,0xc
ffffffffc02025fe:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202600:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202602:	32e7f463          	bgeu	a5,a4,ffffffffc020292a <pmm_init+0x7f0>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202606:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc020260a:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc020260e:	97b6                	add	a5,a5,a3
ffffffffc0202610:	10078023          	sb	zero,256(a5) # 80100 <kern_entry-0xffffffffc017ff00>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202614:	732010ef          	jal	ffffffffc0203d46 <strlen>
ffffffffc0202618:	66051a63          	bnez	a0,ffffffffc0202c8c <pmm_init+0xb52>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc020261c:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202620:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202622:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fdf1b08>
ffffffffc0202626:	078a                	slli	a5,a5,0x2
ffffffffc0202628:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020262a:	26e7f663          	bgeu	a5,a4,ffffffffc0202896 <pmm_init+0x75c>
    return page2ppn(page) << PGSHIFT;
ffffffffc020262e:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202632:	2ee7fc63          	bgeu	a5,a4,ffffffffc020292a <pmm_init+0x7f0>
ffffffffc0202636:	0009b783          	ld	a5,0(s3)
ffffffffc020263a:	00f689b3          	add	s3,a3,a5
ffffffffc020263e:	100027f3          	csrr	a5,sstatus
ffffffffc0202642:	8b89                	andi	a5,a5,2
ffffffffc0202644:	1e079163          	bnez	a5,ffffffffc0202826 <pmm_init+0x6ec>
        pmm_manager->free_pages(base, n);
ffffffffc0202648:	000b3783          	ld	a5,0(s6)
ffffffffc020264c:	8522                	mv	a0,s0
ffffffffc020264e:	4585                	li	a1,1
ffffffffc0202650:	739c                	ld	a5,32(a5)
ffffffffc0202652:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202654:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage)
ffffffffc0202658:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020265a:	078a                	slli	a5,a5,0x2
ffffffffc020265c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020265e:	22e7fc63          	bgeu	a5,a4,ffffffffc0202896 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202662:	000bb503          	ld	a0,0(s7)
ffffffffc0202666:	fe000737          	lui	a4,0xfe000
ffffffffc020266a:	079a                	slli	a5,a5,0x6
ffffffffc020266c:	97ba                	add	a5,a5,a4
ffffffffc020266e:	953e                	add	a0,a0,a5
ffffffffc0202670:	100027f3          	csrr	a5,sstatus
ffffffffc0202674:	8b89                	andi	a5,a5,2
ffffffffc0202676:	18079c63          	bnez	a5,ffffffffc020280e <pmm_init+0x6d4>
ffffffffc020267a:	000b3783          	ld	a5,0(s6)
ffffffffc020267e:	4585                	li	a1,1
ffffffffc0202680:	739c                	ld	a5,32(a5)
ffffffffc0202682:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202684:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202688:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020268a:	078a                	slli	a5,a5,0x2
ffffffffc020268c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020268e:	20e7f463          	bgeu	a5,a4,ffffffffc0202896 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202692:	000bb503          	ld	a0,0(s7)
ffffffffc0202696:	fe000737          	lui	a4,0xfe000
ffffffffc020269a:	079a                	slli	a5,a5,0x6
ffffffffc020269c:	97ba                	add	a5,a5,a4
ffffffffc020269e:	953e                	add	a0,a0,a5
ffffffffc02026a0:	100027f3          	csrr	a5,sstatus
ffffffffc02026a4:	8b89                	andi	a5,a5,2
ffffffffc02026a6:	14079863          	bnez	a5,ffffffffc02027f6 <pmm_init+0x6bc>
ffffffffc02026aa:	000b3783          	ld	a5,0(s6)
ffffffffc02026ae:	4585                	li	a1,1
ffffffffc02026b0:	739c                	ld	a5,32(a5)
ffffffffc02026b2:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc02026b4:	00093783          	ld	a5,0(s2)
ffffffffc02026b8:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc02026bc:	12000073          	sfence.vma
ffffffffc02026c0:	100027f3          	csrr	a5,sstatus
ffffffffc02026c4:	8b89                	andi	a5,a5,2
ffffffffc02026c6:	10079e63          	bnez	a5,ffffffffc02027e2 <pmm_init+0x6a8>
        ret = pmm_manager->nr_free_pages();
ffffffffc02026ca:	000b3783          	ld	a5,0(s6)
ffffffffc02026ce:	779c                	ld	a5,40(a5)
ffffffffc02026d0:	9782                	jalr	a5
ffffffffc02026d2:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc02026d4:	1e8c1b63          	bne	s8,s0,ffffffffc02028ca <pmm_init+0x790>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc02026d8:	00003517          	auipc	a0,0x3
ffffffffc02026dc:	aa050513          	addi	a0,a0,-1376 # ffffffffc0205178 <etext+0x1330>
ffffffffc02026e0:	ab5fd0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc02026e4:	7406                	ld	s0,96(sp)
ffffffffc02026e6:	70a6                	ld	ra,104(sp)
ffffffffc02026e8:	64e6                	ld	s1,88(sp)
ffffffffc02026ea:	6946                	ld	s2,80(sp)
ffffffffc02026ec:	69a6                	ld	s3,72(sp)
ffffffffc02026ee:	6a06                	ld	s4,64(sp)
ffffffffc02026f0:	7ae2                	ld	s5,56(sp)
ffffffffc02026f2:	7b42                	ld	s6,48(sp)
ffffffffc02026f4:	7ba2                	ld	s7,40(sp)
ffffffffc02026f6:	7c02                	ld	s8,32(sp)
ffffffffc02026f8:	6ce2                	ld	s9,24(sp)
ffffffffc02026fa:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc02026fc:	b70ff06f          	j	ffffffffc0201a6c <kmalloc_init>
    if (maxpa > KERNTOP)
ffffffffc0202700:	853e                	mv	a0,a5
ffffffffc0202702:	b4e1                	j	ffffffffc02021ca <pmm_init+0x90>
        intr_disable();
ffffffffc0202704:	970fe0ef          	jal	ffffffffc0200874 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202708:	000b3783          	ld	a5,0(s6)
ffffffffc020270c:	4505                	li	a0,1
ffffffffc020270e:	6f9c                	ld	a5,24(a5)
ffffffffc0202710:	9782                	jalr	a5
ffffffffc0202712:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202714:	95afe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202718:	be75                	j	ffffffffc02022d4 <pmm_init+0x19a>
        intr_disable();
ffffffffc020271a:	95afe0ef          	jal	ffffffffc0200874 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020271e:	000b3783          	ld	a5,0(s6)
ffffffffc0202722:	779c                	ld	a5,40(a5)
ffffffffc0202724:	9782                	jalr	a5
ffffffffc0202726:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202728:	946fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc020272c:	b6ad                	j	ffffffffc0202296 <pmm_init+0x15c>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc020272e:	6705                	lui	a4,0x1
ffffffffc0202730:	177d                	addi	a4,a4,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc0202732:	96ba                	add	a3,a3,a4
ffffffffc0202734:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202736:	00c7d713          	srli	a4,a5,0xc
ffffffffc020273a:	14a77e63          	bgeu	a4,a0,ffffffffc0202896 <pmm_init+0x75c>
    pmm_manager->init_memmap(base, n);
ffffffffc020273e:	000b3683          	ld	a3,0(s6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202742:	8c1d                	sub	s0,s0,a5
    return &pages[PPN(pa) - nbase];
ffffffffc0202744:	071a                	slli	a4,a4,0x6
ffffffffc0202746:	fe0007b7          	lui	a5,0xfe000
ffffffffc020274a:	973e                	add	a4,a4,a5
    pmm_manager->init_memmap(base, n);
ffffffffc020274c:	6a9c                	ld	a5,16(a3)
ffffffffc020274e:	00c45593          	srli	a1,s0,0xc
ffffffffc0202752:	00e60533          	add	a0,a2,a4
ffffffffc0202756:	9782                	jalr	a5
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202758:	0009b583          	ld	a1,0(s3)
}
ffffffffc020275c:	bcf1                	j	ffffffffc0202238 <pmm_init+0xfe>
        intr_disable();
ffffffffc020275e:	916fe0ef          	jal	ffffffffc0200874 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202762:	000b3783          	ld	a5,0(s6)
ffffffffc0202766:	4505                	li	a0,1
ffffffffc0202768:	6f9c                	ld	a5,24(a5)
ffffffffc020276a:	9782                	jalr	a5
ffffffffc020276c:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc020276e:	900fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202772:	b119                	j	ffffffffc0202378 <pmm_init+0x23e>
        intr_disable();
ffffffffc0202774:	900fe0ef          	jal	ffffffffc0200874 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202778:	000b3783          	ld	a5,0(s6)
ffffffffc020277c:	779c                	ld	a5,40(a5)
ffffffffc020277e:	9782                	jalr	a5
ffffffffc0202780:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202782:	8ecfe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202786:	b345                	j	ffffffffc0202526 <pmm_init+0x3ec>
        intr_disable();
ffffffffc0202788:	8ecfe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc020278c:	000b3783          	ld	a5,0(s6)
ffffffffc0202790:	779c                	ld	a5,40(a5)
ffffffffc0202792:	9782                	jalr	a5
ffffffffc0202794:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202796:	8d8fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc020279a:	b3a5                	j	ffffffffc0202502 <pmm_init+0x3c8>
ffffffffc020279c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020279e:	8d6fe0ef          	jal	ffffffffc0200874 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02027a2:	000b3783          	ld	a5,0(s6)
ffffffffc02027a6:	6522                	ld	a0,8(sp)
ffffffffc02027a8:	4585                	li	a1,1
ffffffffc02027aa:	739c                	ld	a5,32(a5)
ffffffffc02027ac:	9782                	jalr	a5
        intr_enable();
ffffffffc02027ae:	8c0fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02027b2:	bb05                	j	ffffffffc02024e2 <pmm_init+0x3a8>
ffffffffc02027b4:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02027b6:	8befe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02027ba:	000b3783          	ld	a5,0(s6)
ffffffffc02027be:	6522                	ld	a0,8(sp)
ffffffffc02027c0:	4585                	li	a1,1
ffffffffc02027c2:	739c                	ld	a5,32(a5)
ffffffffc02027c4:	9782                	jalr	a5
        intr_enable();
ffffffffc02027c6:	8a8fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02027ca:	b1e5                	j	ffffffffc02024b2 <pmm_init+0x378>
        intr_disable();
ffffffffc02027cc:	8a8fe0ef          	jal	ffffffffc0200874 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02027d0:	000b3783          	ld	a5,0(s6)
ffffffffc02027d4:	4505                	li	a0,1
ffffffffc02027d6:	6f9c                	ld	a5,24(a5)
ffffffffc02027d8:	9782                	jalr	a5
ffffffffc02027da:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02027dc:	892fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02027e0:	b375                	j	ffffffffc020258c <pmm_init+0x452>
        intr_disable();
ffffffffc02027e2:	892fe0ef          	jal	ffffffffc0200874 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02027e6:	000b3783          	ld	a5,0(s6)
ffffffffc02027ea:	779c                	ld	a5,40(a5)
ffffffffc02027ec:	9782                	jalr	a5
ffffffffc02027ee:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02027f0:	87efe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02027f4:	b5c5                	j	ffffffffc02026d4 <pmm_init+0x59a>
ffffffffc02027f6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02027f8:	87cfe0ef          	jal	ffffffffc0200874 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02027fc:	000b3783          	ld	a5,0(s6)
ffffffffc0202800:	6522                	ld	a0,8(sp)
ffffffffc0202802:	4585                	li	a1,1
ffffffffc0202804:	739c                	ld	a5,32(a5)
ffffffffc0202806:	9782                	jalr	a5
        intr_enable();
ffffffffc0202808:	866fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc020280c:	b565                	j	ffffffffc02026b4 <pmm_init+0x57a>
ffffffffc020280e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202810:	864fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0202814:	000b3783          	ld	a5,0(s6)
ffffffffc0202818:	6522                	ld	a0,8(sp)
ffffffffc020281a:	4585                	li	a1,1
ffffffffc020281c:	739c                	ld	a5,32(a5)
ffffffffc020281e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202820:	84efe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202824:	b585                	j	ffffffffc0202684 <pmm_init+0x54a>
        intr_disable();
ffffffffc0202826:	84efe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc020282a:	000b3783          	ld	a5,0(s6)
ffffffffc020282e:	8522                	mv	a0,s0
ffffffffc0202830:	4585                	li	a1,1
ffffffffc0202832:	739c                	ld	a5,32(a5)
ffffffffc0202834:	9782                	jalr	a5
        intr_enable();
ffffffffc0202836:	838fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc020283a:	bd29                	j	ffffffffc0202654 <pmm_init+0x51a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020283c:	86a2                	mv	a3,s0
ffffffffc020283e:	00002617          	auipc	a2,0x2
ffffffffc0202842:	29a60613          	addi	a2,a2,666 # ffffffffc0204ad8 <etext+0xc90>
ffffffffc0202846:	1a400593          	li	a1,420
ffffffffc020284a:	00002517          	auipc	a0,0x2
ffffffffc020284e:	37e50513          	addi	a0,a0,894 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202852:	bb5fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202856:	00002697          	auipc	a3,0x2
ffffffffc020285a:	7c268693          	addi	a3,a3,1986 # ffffffffc0205018 <etext+0x11d0>
ffffffffc020285e:	00002617          	auipc	a2,0x2
ffffffffc0202862:	eca60613          	addi	a2,a2,-310 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202866:	1a500593          	li	a1,421
ffffffffc020286a:	00002517          	auipc	a0,0x2
ffffffffc020286e:	35e50513          	addi	a0,a0,862 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202872:	b95fd0ef          	jal	ffffffffc0200406 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202876:	00002697          	auipc	a3,0x2
ffffffffc020287a:	76268693          	addi	a3,a3,1890 # ffffffffc0204fd8 <etext+0x1190>
ffffffffc020287e:	00002617          	auipc	a2,0x2
ffffffffc0202882:	eaa60613          	addi	a2,a2,-342 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202886:	1a400593          	li	a1,420
ffffffffc020288a:	00002517          	auipc	a0,0x2
ffffffffc020288e:	33e50513          	addi	a0,a0,830 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202892:	b75fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202896:	b9cff0ef          	jal	ffffffffc0201c32 <pa2page.part.0>
        panic("pte2page called with invalid pte");
ffffffffc020289a:	00002617          	auipc	a2,0x2
ffffffffc020289e:	4de60613          	addi	a2,a2,1246 # ffffffffc0204d78 <etext+0xf30>
ffffffffc02028a2:	07f00593          	li	a1,127
ffffffffc02028a6:	00002517          	auipc	a0,0x2
ffffffffc02028aa:	25a50513          	addi	a0,a0,602 # ffffffffc0204b00 <etext+0xcb8>
ffffffffc02028ae:	b59fd0ef          	jal	ffffffffc0200406 <__panic>
        panic("DTB memory info not available");
ffffffffc02028b2:	00002617          	auipc	a2,0x2
ffffffffc02028b6:	33e60613          	addi	a2,a2,830 # ffffffffc0204bf0 <etext+0xda8>
ffffffffc02028ba:	06400593          	li	a1,100
ffffffffc02028be:	00002517          	auipc	a0,0x2
ffffffffc02028c2:	30a50513          	addi	a0,a0,778 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc02028c6:	b41fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02028ca:	00002697          	auipc	a3,0x2
ffffffffc02028ce:	6c668693          	addi	a3,a3,1734 # ffffffffc0204f90 <etext+0x1148>
ffffffffc02028d2:	00002617          	auipc	a2,0x2
ffffffffc02028d6:	e5660613          	addi	a2,a2,-426 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02028da:	1bf00593          	li	a1,447
ffffffffc02028de:	00002517          	auipc	a0,0x2
ffffffffc02028e2:	2ea50513          	addi	a0,a0,746 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc02028e6:	b21fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02028ea:	00002697          	auipc	a3,0x2
ffffffffc02028ee:	3be68693          	addi	a3,a3,958 # ffffffffc0204ca8 <etext+0xe60>
ffffffffc02028f2:	00002617          	auipc	a2,0x2
ffffffffc02028f6:	e3660613          	addi	a2,a2,-458 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02028fa:	16600593          	li	a1,358
ffffffffc02028fe:	00002517          	auipc	a0,0x2
ffffffffc0202902:	2ca50513          	addi	a0,a0,714 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202906:	b01fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc020290a:	00002697          	auipc	a3,0x2
ffffffffc020290e:	37e68693          	addi	a3,a3,894 # ffffffffc0204c88 <etext+0xe40>
ffffffffc0202912:	00002617          	auipc	a2,0x2
ffffffffc0202916:	e1660613          	addi	a2,a2,-490 # ffffffffc0204728 <etext+0x8e0>
ffffffffc020291a:	16500593          	li	a1,357
ffffffffc020291e:	00002517          	auipc	a0,0x2
ffffffffc0202922:	2aa50513          	addi	a0,a0,682 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202926:	ae1fd0ef          	jal	ffffffffc0200406 <__panic>
    return KADDR(page2pa(page));
ffffffffc020292a:	00002617          	auipc	a2,0x2
ffffffffc020292e:	1ae60613          	addi	a2,a2,430 # ffffffffc0204ad8 <etext+0xc90>
ffffffffc0202932:	07100593          	li	a1,113
ffffffffc0202936:	00002517          	auipc	a0,0x2
ffffffffc020293a:	1ca50513          	addi	a0,a0,458 # ffffffffc0204b00 <etext+0xcb8>
ffffffffc020293e:	ac9fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202942:	00002697          	auipc	a3,0x2
ffffffffc0202946:	61e68693          	addi	a3,a3,1566 # ffffffffc0204f60 <etext+0x1118>
ffffffffc020294a:	00002617          	auipc	a2,0x2
ffffffffc020294e:	dde60613          	addi	a2,a2,-546 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202952:	18d00593          	li	a1,397
ffffffffc0202956:	00002517          	auipc	a0,0x2
ffffffffc020295a:	27250513          	addi	a0,a0,626 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc020295e:	aa9fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202962:	00002697          	auipc	a3,0x2
ffffffffc0202966:	5b668693          	addi	a3,a3,1462 # ffffffffc0204f18 <etext+0x10d0>
ffffffffc020296a:	00002617          	auipc	a2,0x2
ffffffffc020296e:	dbe60613          	addi	a2,a2,-578 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202972:	18b00593          	li	a1,395
ffffffffc0202976:	00002517          	auipc	a0,0x2
ffffffffc020297a:	25250513          	addi	a0,a0,594 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc020297e:	a89fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202982:	00002697          	auipc	a3,0x2
ffffffffc0202986:	5c668693          	addi	a3,a3,1478 # ffffffffc0204f48 <etext+0x1100>
ffffffffc020298a:	00002617          	auipc	a2,0x2
ffffffffc020298e:	d9e60613          	addi	a2,a2,-610 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202992:	18a00593          	li	a1,394
ffffffffc0202996:	00002517          	auipc	a0,0x2
ffffffffc020299a:	23250513          	addi	a0,a0,562 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc020299e:	a69fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc02029a2:	00002697          	auipc	a3,0x2
ffffffffc02029a6:	68e68693          	addi	a3,a3,1678 # ffffffffc0205030 <etext+0x11e8>
ffffffffc02029aa:	00002617          	auipc	a2,0x2
ffffffffc02029ae:	d7e60613          	addi	a2,a2,-642 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02029b2:	1a800593          	li	a1,424
ffffffffc02029b6:	00002517          	auipc	a0,0x2
ffffffffc02029ba:	21250513          	addi	a0,a0,530 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc02029be:	a49fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02029c2:	00002697          	auipc	a3,0x2
ffffffffc02029c6:	5ce68693          	addi	a3,a3,1486 # ffffffffc0204f90 <etext+0x1148>
ffffffffc02029ca:	00002617          	auipc	a2,0x2
ffffffffc02029ce:	d5e60613          	addi	a2,a2,-674 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02029d2:	19500593          	li	a1,405
ffffffffc02029d6:	00002517          	auipc	a0,0x2
ffffffffc02029da:	1f250513          	addi	a0,a0,498 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc02029de:	a29fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p) == 1);
ffffffffc02029e2:	00002697          	auipc	a3,0x2
ffffffffc02029e6:	6a668693          	addi	a3,a3,1702 # ffffffffc0205088 <etext+0x1240>
ffffffffc02029ea:	00002617          	auipc	a2,0x2
ffffffffc02029ee:	d3e60613          	addi	a2,a2,-706 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02029f2:	1ad00593          	li	a1,429
ffffffffc02029f6:	00002517          	auipc	a0,0x2
ffffffffc02029fa:	1d250513          	addi	a0,a0,466 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc02029fe:	a09fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202a02:	00002697          	auipc	a3,0x2
ffffffffc0202a06:	64668693          	addi	a3,a3,1606 # ffffffffc0205048 <etext+0x1200>
ffffffffc0202a0a:	00002617          	auipc	a2,0x2
ffffffffc0202a0e:	d1e60613          	addi	a2,a2,-738 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202a12:	1ac00593          	li	a1,428
ffffffffc0202a16:	00002517          	auipc	a0,0x2
ffffffffc0202a1a:	1b250513          	addi	a0,a0,434 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202a1e:	9e9fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202a22:	00002697          	auipc	a3,0x2
ffffffffc0202a26:	4f668693          	addi	a3,a3,1270 # ffffffffc0204f18 <etext+0x10d0>
ffffffffc0202a2a:	00002617          	auipc	a2,0x2
ffffffffc0202a2e:	cfe60613          	addi	a2,a2,-770 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202a32:	18700593          	li	a1,391
ffffffffc0202a36:	00002517          	auipc	a0,0x2
ffffffffc0202a3a:	19250513          	addi	a0,a0,402 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202a3e:	9c9fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202a42:	00002697          	auipc	a3,0x2
ffffffffc0202a46:	37668693          	addi	a3,a3,886 # ffffffffc0204db8 <etext+0xf70>
ffffffffc0202a4a:	00002617          	auipc	a2,0x2
ffffffffc0202a4e:	cde60613          	addi	a2,a2,-802 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202a52:	18600593          	li	a1,390
ffffffffc0202a56:	00002517          	auipc	a0,0x2
ffffffffc0202a5a:	17250513          	addi	a0,a0,370 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202a5e:	9a9fd0ef          	jal	ffffffffc0200406 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202a62:	00002697          	auipc	a3,0x2
ffffffffc0202a66:	4ce68693          	addi	a3,a3,1230 # ffffffffc0204f30 <etext+0x10e8>
ffffffffc0202a6a:	00002617          	auipc	a2,0x2
ffffffffc0202a6e:	cbe60613          	addi	a2,a2,-834 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202a72:	18300593          	li	a1,387
ffffffffc0202a76:	00002517          	auipc	a0,0x2
ffffffffc0202a7a:	15250513          	addi	a0,a0,338 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202a7e:	989fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202a82:	00002697          	auipc	a3,0x2
ffffffffc0202a86:	31e68693          	addi	a3,a3,798 # ffffffffc0204da0 <etext+0xf58>
ffffffffc0202a8a:	00002617          	auipc	a2,0x2
ffffffffc0202a8e:	c9e60613          	addi	a2,a2,-866 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202a92:	18200593          	li	a1,386
ffffffffc0202a96:	00002517          	auipc	a0,0x2
ffffffffc0202a9a:	13250513          	addi	a0,a0,306 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202a9e:	969fd0ef          	jal	ffffffffc0200406 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202aa2:	00002697          	auipc	a3,0x2
ffffffffc0202aa6:	39e68693          	addi	a3,a3,926 # ffffffffc0204e40 <etext+0xff8>
ffffffffc0202aaa:	00002617          	auipc	a2,0x2
ffffffffc0202aae:	c7e60613          	addi	a2,a2,-898 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202ab2:	18100593          	li	a1,385
ffffffffc0202ab6:	00002517          	auipc	a0,0x2
ffffffffc0202aba:	11250513          	addi	a0,a0,274 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202abe:	949fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202ac2:	00002697          	auipc	a3,0x2
ffffffffc0202ac6:	45668693          	addi	a3,a3,1110 # ffffffffc0204f18 <etext+0x10d0>
ffffffffc0202aca:	00002617          	auipc	a2,0x2
ffffffffc0202ace:	c5e60613          	addi	a2,a2,-930 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202ad2:	18000593          	li	a1,384
ffffffffc0202ad6:	00002517          	auipc	a0,0x2
ffffffffc0202ada:	0f250513          	addi	a0,a0,242 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202ade:	929fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0202ae2:	00002697          	auipc	a3,0x2
ffffffffc0202ae6:	41e68693          	addi	a3,a3,1054 # ffffffffc0204f00 <etext+0x10b8>
ffffffffc0202aea:	00002617          	auipc	a2,0x2
ffffffffc0202aee:	c3e60613          	addi	a2,a2,-962 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202af2:	17f00593          	li	a1,383
ffffffffc0202af6:	00002517          	auipc	a0,0x2
ffffffffc0202afa:	0d250513          	addi	a0,a0,210 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202afe:	909fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202b02:	00002697          	auipc	a3,0x2
ffffffffc0202b06:	3ce68693          	addi	a3,a3,974 # ffffffffc0204ed0 <etext+0x1088>
ffffffffc0202b0a:	00002617          	auipc	a2,0x2
ffffffffc0202b0e:	c1e60613          	addi	a2,a2,-994 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202b12:	17e00593          	li	a1,382
ffffffffc0202b16:	00002517          	auipc	a0,0x2
ffffffffc0202b1a:	0b250513          	addi	a0,a0,178 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202b1e:	8e9fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0202b22:	00002697          	auipc	a3,0x2
ffffffffc0202b26:	39668693          	addi	a3,a3,918 # ffffffffc0204eb8 <etext+0x1070>
ffffffffc0202b2a:	00002617          	auipc	a2,0x2
ffffffffc0202b2e:	bfe60613          	addi	a2,a2,-1026 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202b32:	17c00593          	li	a1,380
ffffffffc0202b36:	00002517          	auipc	a0,0x2
ffffffffc0202b3a:	09250513          	addi	a0,a0,146 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202b3e:	8c9fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202b42:	00002697          	auipc	a3,0x2
ffffffffc0202b46:	35668693          	addi	a3,a3,854 # ffffffffc0204e98 <etext+0x1050>
ffffffffc0202b4a:	00002617          	auipc	a2,0x2
ffffffffc0202b4e:	bde60613          	addi	a2,a2,-1058 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202b52:	17b00593          	li	a1,379
ffffffffc0202b56:	00002517          	auipc	a0,0x2
ffffffffc0202b5a:	07250513          	addi	a0,a0,114 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202b5e:	8a9fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(*ptep & PTE_W);
ffffffffc0202b62:	00002697          	auipc	a3,0x2
ffffffffc0202b66:	32668693          	addi	a3,a3,806 # ffffffffc0204e88 <etext+0x1040>
ffffffffc0202b6a:	00002617          	auipc	a2,0x2
ffffffffc0202b6e:	bbe60613          	addi	a2,a2,-1090 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202b72:	17a00593          	li	a1,378
ffffffffc0202b76:	00002517          	auipc	a0,0x2
ffffffffc0202b7a:	05250513          	addi	a0,a0,82 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202b7e:	889fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(*ptep & PTE_U);
ffffffffc0202b82:	00002697          	auipc	a3,0x2
ffffffffc0202b86:	2f668693          	addi	a3,a3,758 # ffffffffc0204e78 <etext+0x1030>
ffffffffc0202b8a:	00002617          	auipc	a2,0x2
ffffffffc0202b8e:	b9e60613          	addi	a2,a2,-1122 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202b92:	17900593          	li	a1,377
ffffffffc0202b96:	00002517          	auipc	a0,0x2
ffffffffc0202b9a:	03250513          	addi	a0,a0,50 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202b9e:	869fd0ef          	jal	ffffffffc0200406 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202ba2:	00002617          	auipc	a2,0x2
ffffffffc0202ba6:	fde60613          	addi	a2,a2,-34 # ffffffffc0204b80 <etext+0xd38>
ffffffffc0202baa:	08000593          	li	a1,128
ffffffffc0202bae:	00002517          	auipc	a0,0x2
ffffffffc0202bb2:	01a50513          	addi	a0,a0,26 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202bb6:	851fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202bba:	00002697          	auipc	a3,0x2
ffffffffc0202bbe:	21668693          	addi	a3,a3,534 # ffffffffc0204dd0 <etext+0xf88>
ffffffffc0202bc2:	00002617          	auipc	a2,0x2
ffffffffc0202bc6:	b6660613          	addi	a2,a2,-1178 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202bca:	17400593          	li	a1,372
ffffffffc0202bce:	00002517          	auipc	a0,0x2
ffffffffc0202bd2:	ffa50513          	addi	a0,a0,-6 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202bd6:	831fd0ef          	jal	ffffffffc0200406 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202bda:	00002697          	auipc	a3,0x2
ffffffffc0202bde:	26668693          	addi	a3,a3,614 # ffffffffc0204e40 <etext+0xff8>
ffffffffc0202be2:	00002617          	auipc	a2,0x2
ffffffffc0202be6:	b4660613          	addi	a2,a2,-1210 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202bea:	17800593          	li	a1,376
ffffffffc0202bee:	00002517          	auipc	a0,0x2
ffffffffc0202bf2:	fda50513          	addi	a0,a0,-38 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202bf6:	811fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202bfa:	00002697          	auipc	a3,0x2
ffffffffc0202bfe:	20668693          	addi	a3,a3,518 # ffffffffc0204e00 <etext+0xfb8>
ffffffffc0202c02:	00002617          	auipc	a2,0x2
ffffffffc0202c06:	b2660613          	addi	a2,a2,-1242 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202c0a:	17700593          	li	a1,375
ffffffffc0202c0e:	00002517          	auipc	a0,0x2
ffffffffc0202c12:	fba50513          	addi	a0,a0,-70 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202c16:	ff0fd0ef          	jal	ffffffffc0200406 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202c1a:	86d6                	mv	a3,s5
ffffffffc0202c1c:	00002617          	auipc	a2,0x2
ffffffffc0202c20:	ebc60613          	addi	a2,a2,-324 # ffffffffc0204ad8 <etext+0xc90>
ffffffffc0202c24:	17300593          	li	a1,371
ffffffffc0202c28:	00002517          	auipc	a0,0x2
ffffffffc0202c2c:	fa050513          	addi	a0,a0,-96 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202c30:	fd6fd0ef          	jal	ffffffffc0200406 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202c34:	00002617          	auipc	a2,0x2
ffffffffc0202c38:	ea460613          	addi	a2,a2,-348 # ffffffffc0204ad8 <etext+0xc90>
ffffffffc0202c3c:	17200593          	li	a1,370
ffffffffc0202c40:	00002517          	auipc	a0,0x2
ffffffffc0202c44:	f8850513          	addi	a0,a0,-120 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202c48:	fbefd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202c4c:	00002697          	auipc	a3,0x2
ffffffffc0202c50:	16c68693          	addi	a3,a3,364 # ffffffffc0204db8 <etext+0xf70>
ffffffffc0202c54:	00002617          	auipc	a2,0x2
ffffffffc0202c58:	ad460613          	addi	a2,a2,-1324 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202c5c:	17000593          	li	a1,368
ffffffffc0202c60:	00002517          	auipc	a0,0x2
ffffffffc0202c64:	f6850513          	addi	a0,a0,-152 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202c68:	f9efd0ef          	jal	ffffffffc0200406 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202c6c:	00002697          	auipc	a3,0x2
ffffffffc0202c70:	13468693          	addi	a3,a3,308 # ffffffffc0204da0 <etext+0xf58>
ffffffffc0202c74:	00002617          	auipc	a2,0x2
ffffffffc0202c78:	ab460613          	addi	a2,a2,-1356 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202c7c:	16f00593          	li	a1,367
ffffffffc0202c80:	00002517          	auipc	a0,0x2
ffffffffc0202c84:	f4850513          	addi	a0,a0,-184 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202c88:	f7efd0ef          	jal	ffffffffc0200406 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c8c:	00002697          	auipc	a3,0x2
ffffffffc0202c90:	4c468693          	addi	a3,a3,1220 # ffffffffc0205150 <etext+0x1308>
ffffffffc0202c94:	00002617          	auipc	a2,0x2
ffffffffc0202c98:	a9460613          	addi	a2,a2,-1388 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202c9c:	1b600593          	li	a1,438
ffffffffc0202ca0:	00002517          	auipc	a0,0x2
ffffffffc0202ca4:	f2850513          	addi	a0,a0,-216 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202ca8:	f5efd0ef          	jal	ffffffffc0200406 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202cac:	00002697          	auipc	a3,0x2
ffffffffc0202cb0:	46c68693          	addi	a3,a3,1132 # ffffffffc0205118 <etext+0x12d0>
ffffffffc0202cb4:	00002617          	auipc	a2,0x2
ffffffffc0202cb8:	a7460613          	addi	a2,a2,-1420 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202cbc:	1b300593          	li	a1,435
ffffffffc0202cc0:	00002517          	auipc	a0,0x2
ffffffffc0202cc4:	f0850513          	addi	a0,a0,-248 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202cc8:	f3efd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p) == 2);
ffffffffc0202ccc:	00002697          	auipc	a3,0x2
ffffffffc0202cd0:	41c68693          	addi	a3,a3,1052 # ffffffffc02050e8 <etext+0x12a0>
ffffffffc0202cd4:	00002617          	auipc	a2,0x2
ffffffffc0202cd8:	a5460613          	addi	a2,a2,-1452 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202cdc:	1af00593          	li	a1,431
ffffffffc0202ce0:	00002517          	auipc	a0,0x2
ffffffffc0202ce4:	ee850513          	addi	a0,a0,-280 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202ce8:	f1efd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202cec:	00002697          	auipc	a3,0x2
ffffffffc0202cf0:	3b468693          	addi	a3,a3,948 # ffffffffc02050a0 <etext+0x1258>
ffffffffc0202cf4:	00002617          	auipc	a2,0x2
ffffffffc0202cf8:	a3460613          	addi	a2,a2,-1484 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202cfc:	1ae00593          	li	a1,430
ffffffffc0202d00:	00002517          	auipc	a0,0x2
ffffffffc0202d04:	ec850513          	addi	a0,a0,-312 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202d08:	efefd0ef          	jal	ffffffffc0200406 <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202d0c:	00002697          	auipc	a3,0x2
ffffffffc0202d10:	fdc68693          	addi	a3,a3,-36 # ffffffffc0204ce8 <etext+0xea0>
ffffffffc0202d14:	00002617          	auipc	a2,0x2
ffffffffc0202d18:	a1460613          	addi	a2,a2,-1516 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202d1c:	16700593          	li	a1,359
ffffffffc0202d20:	00002517          	auipc	a0,0x2
ffffffffc0202d24:	ea850513          	addi	a0,a0,-344 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202d28:	edefd0ef          	jal	ffffffffc0200406 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202d2c:	00002617          	auipc	a2,0x2
ffffffffc0202d30:	e5460613          	addi	a2,a2,-428 # ffffffffc0204b80 <etext+0xd38>
ffffffffc0202d34:	0cb00593          	li	a1,203
ffffffffc0202d38:	00002517          	auipc	a0,0x2
ffffffffc0202d3c:	e9050513          	addi	a0,a0,-368 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202d40:	ec6fd0ef          	jal	ffffffffc0200406 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202d44:	00002697          	auipc	a3,0x2
ffffffffc0202d48:	00468693          	addi	a3,a3,4 # ffffffffc0204d48 <etext+0xf00>
ffffffffc0202d4c:	00002617          	auipc	a2,0x2
ffffffffc0202d50:	9dc60613          	addi	a2,a2,-1572 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202d54:	16e00593          	li	a1,366
ffffffffc0202d58:	00002517          	auipc	a0,0x2
ffffffffc0202d5c:	e7050513          	addi	a0,a0,-400 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202d60:	ea6fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202d64:	00002697          	auipc	a3,0x2
ffffffffc0202d68:	fb468693          	addi	a3,a3,-76 # ffffffffc0204d18 <etext+0xed0>
ffffffffc0202d6c:	00002617          	auipc	a2,0x2
ffffffffc0202d70:	9bc60613          	addi	a2,a2,-1604 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202d74:	16b00593          	li	a1,363
ffffffffc0202d78:	00002517          	auipc	a0,0x2
ffffffffc0202d7c:	e5050513          	addi	a0,a0,-432 # ffffffffc0204bc8 <etext+0xd80>
ffffffffc0202d80:	e86fd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0202d84 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0202d84:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0202d86:	00002697          	auipc	a3,0x2
ffffffffc0202d8a:	41268693          	addi	a3,a3,1042 # ffffffffc0205198 <etext+0x1350>
ffffffffc0202d8e:	00002617          	auipc	a2,0x2
ffffffffc0202d92:	99a60613          	addi	a2,a2,-1638 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202d96:	08800593          	li	a1,136
ffffffffc0202d9a:	00002517          	auipc	a0,0x2
ffffffffc0202d9e:	41e50513          	addi	a0,a0,1054 # ffffffffc02051b8 <etext+0x1370>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0202da2:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0202da4:	e62fd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0202da8 <find_vma>:
    if (mm != NULL)
ffffffffc0202da8:	c505                	beqz	a0,ffffffffc0202dd0 <find_vma+0x28>
        vma = mm->mmap_cache;
ffffffffc0202daa:	691c                	ld	a5,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0202dac:	c781                	beqz	a5,ffffffffc0202db4 <find_vma+0xc>
ffffffffc0202dae:	6798                	ld	a4,8(a5)
ffffffffc0202db0:	02e5f363          	bgeu	a1,a4,ffffffffc0202dd6 <find_vma+0x2e>
    return listelm->next;
ffffffffc0202db4:	651c                	ld	a5,8(a0)
            while ((le = list_next(le)) != list)
ffffffffc0202db6:	00f50d63          	beq	a0,a5,ffffffffc0202dd0 <find_vma+0x28>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0202dba:	fe87b703          	ld	a4,-24(a5) # fffffffffdffffe8 <end+0x3ddf2af0>
ffffffffc0202dbe:	00e5e663          	bltu	a1,a4,ffffffffc0202dca <find_vma+0x22>
ffffffffc0202dc2:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202dc6:	00e5ee63          	bltu	a1,a4,ffffffffc0202de2 <find_vma+0x3a>
ffffffffc0202dca:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0202dcc:	fef517e3          	bne	a0,a5,ffffffffc0202dba <find_vma+0x12>
    struct vma_struct *vma = NULL;
ffffffffc0202dd0:	4781                	li	a5,0
}
ffffffffc0202dd2:	853e                	mv	a0,a5
ffffffffc0202dd4:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0202dd6:	6b98                	ld	a4,16(a5)
ffffffffc0202dd8:	fce5fee3          	bgeu	a1,a4,ffffffffc0202db4 <find_vma+0xc>
            mm->mmap_cache = vma;
ffffffffc0202ddc:	e91c                	sd	a5,16(a0)
}
ffffffffc0202dde:	853e                	mv	a0,a5
ffffffffc0202de0:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0202de2:	1781                	addi	a5,a5,-32
            mm->mmap_cache = vma;
ffffffffc0202de4:	e91c                	sd	a5,16(a0)
ffffffffc0202de6:	bfe5                	j	ffffffffc0202dde <find_vma+0x36>

ffffffffc0202de8 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202de8:	6590                	ld	a2,8(a1)
ffffffffc0202dea:	0105b803          	ld	a6,16(a1)
{
ffffffffc0202dee:	1141                	addi	sp,sp,-16
ffffffffc0202df0:	e406                	sd	ra,8(sp)
ffffffffc0202df2:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202df4:	01066763          	bltu	a2,a6,ffffffffc0202e02 <insert_vma_struct+0x1a>
ffffffffc0202df8:	a8b9                	j	ffffffffc0202e56 <insert_vma_struct+0x6e>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0202dfa:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202dfe:	04e66763          	bltu	a2,a4,ffffffffc0202e4c <insert_vma_struct+0x64>
ffffffffc0202e02:	86be                	mv	a3,a5
ffffffffc0202e04:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0202e06:	fef51ae3          	bne	a0,a5,ffffffffc0202dfa <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0202e0a:	02a68463          	beq	a3,a0,ffffffffc0202e32 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0202e0e:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202e12:	fe86b883          	ld	a7,-24(a3)
ffffffffc0202e16:	08e8f063          	bgeu	a7,a4,ffffffffc0202e96 <insert_vma_struct+0xae>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202e1a:	04e66e63          	bltu	a2,a4,ffffffffc0202e76 <insert_vma_struct+0x8e>
    }
    if (le_next != list)
ffffffffc0202e1e:	00f50a63          	beq	a0,a5,ffffffffc0202e32 <insert_vma_struct+0x4a>
ffffffffc0202e22:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202e26:	05076863          	bltu	a4,a6,ffffffffc0202e76 <insert_vma_struct+0x8e>
    assert(next->vm_start < next->vm_end);
ffffffffc0202e2a:	ff07b603          	ld	a2,-16(a5)
ffffffffc0202e2e:	02c77263          	bgeu	a4,a2,ffffffffc0202e52 <insert_vma_struct+0x6a>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0202e32:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0202e34:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0202e36:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0202e3a:	e390                	sd	a2,0(a5)
ffffffffc0202e3c:	e690                	sd	a2,8(a3)
}
ffffffffc0202e3e:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0202e40:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0202e42:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0202e44:	2705                	addiw	a4,a4,1
ffffffffc0202e46:	d118                	sw	a4,32(a0)
}
ffffffffc0202e48:	0141                	addi	sp,sp,16
ffffffffc0202e4a:	8082                	ret
    if (le_prev != list)
ffffffffc0202e4c:	fca691e3          	bne	a3,a0,ffffffffc0202e0e <insert_vma_struct+0x26>
ffffffffc0202e50:	bfd9                	j	ffffffffc0202e26 <insert_vma_struct+0x3e>
ffffffffc0202e52:	f33ff0ef          	jal	ffffffffc0202d84 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202e56:	00002697          	auipc	a3,0x2
ffffffffc0202e5a:	37268693          	addi	a3,a3,882 # ffffffffc02051c8 <etext+0x1380>
ffffffffc0202e5e:	00002617          	auipc	a2,0x2
ffffffffc0202e62:	8ca60613          	addi	a2,a2,-1846 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202e66:	08e00593          	li	a1,142
ffffffffc0202e6a:	00002517          	auipc	a0,0x2
ffffffffc0202e6e:	34e50513          	addi	a0,a0,846 # ffffffffc02051b8 <etext+0x1370>
ffffffffc0202e72:	d94fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202e76:	00002697          	auipc	a3,0x2
ffffffffc0202e7a:	39268693          	addi	a3,a3,914 # ffffffffc0205208 <etext+0x13c0>
ffffffffc0202e7e:	00002617          	auipc	a2,0x2
ffffffffc0202e82:	8aa60613          	addi	a2,a2,-1878 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202e86:	08700593          	li	a1,135
ffffffffc0202e8a:	00002517          	auipc	a0,0x2
ffffffffc0202e8e:	32e50513          	addi	a0,a0,814 # ffffffffc02051b8 <etext+0x1370>
ffffffffc0202e92:	d74fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202e96:	00002697          	auipc	a3,0x2
ffffffffc0202e9a:	35268693          	addi	a3,a3,850 # ffffffffc02051e8 <etext+0x13a0>
ffffffffc0202e9e:	00002617          	auipc	a2,0x2
ffffffffc0202ea2:	88a60613          	addi	a2,a2,-1910 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0202ea6:	08600593          	li	a1,134
ffffffffc0202eaa:	00002517          	auipc	a0,0x2
ffffffffc0202eae:	30e50513          	addi	a0,a0,782 # ffffffffc02051b8 <etext+0x1370>
ffffffffc0202eb2:	d54fd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0202eb6 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0202eb6:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202eb8:	03000513          	li	a0,48
{
ffffffffc0202ebc:	fc06                	sd	ra,56(sp)
ffffffffc0202ebe:	f822                	sd	s0,48(sp)
ffffffffc0202ec0:	f426                	sd	s1,40(sp)
ffffffffc0202ec2:	f04a                	sd	s2,32(sp)
ffffffffc0202ec4:	ec4e                	sd	s3,24(sp)
ffffffffc0202ec6:	e852                	sd	s4,16(sp)
ffffffffc0202ec8:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202eca:	bc3fe0ef          	jal	ffffffffc0201a8c <kmalloc>
    if (mm != NULL)
ffffffffc0202ece:	18050a63          	beqz	a0,ffffffffc0203062 <vmm_init+0x1ac>
ffffffffc0202ed2:	842a                	mv	s0,a0
    elm->prev = elm->next = elm;
ffffffffc0202ed4:	e508                	sd	a0,8(a0)
ffffffffc0202ed6:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0202ed8:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0202edc:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0202ee0:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0202ee4:	02053423          	sd	zero,40(a0)
ffffffffc0202ee8:	03200493          	li	s1,50
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202eec:	03000513          	li	a0,48
ffffffffc0202ef0:	b9dfe0ef          	jal	ffffffffc0201a8c <kmalloc>
    if (vma != NULL)
ffffffffc0202ef4:	14050763          	beqz	a0,ffffffffc0203042 <vmm_init+0x18c>
        vma->vm_end = vm_end;
ffffffffc0202ef8:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0202efc:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202efe:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0202f02:	e91c                	sd	a5,16(a0)
    int i;
    for (i = step1; i >= 1; i--)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202f04:	85aa                	mv	a1,a0
    for (i = step1; i >= 1; i--)
ffffffffc0202f06:	14ed                	addi	s1,s1,-5
        insert_vma_struct(mm, vma);
ffffffffc0202f08:	8522                	mv	a0,s0
ffffffffc0202f0a:	edfff0ef          	jal	ffffffffc0202de8 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0202f0e:	fcf9                	bnez	s1,ffffffffc0202eec <vmm_init+0x36>
ffffffffc0202f10:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0202f14:	1f900913          	li	s2,505
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202f18:	03000513          	li	a0,48
ffffffffc0202f1c:	b71fe0ef          	jal	ffffffffc0201a8c <kmalloc>
    if (vma != NULL)
ffffffffc0202f20:	16050163          	beqz	a0,ffffffffc0203082 <vmm_init+0x1cc>
        vma->vm_end = vm_end;
ffffffffc0202f24:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0202f28:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202f2a:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0202f2e:	e91c                	sd	a5,16(a0)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202f30:	85aa                	mv	a1,a0
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0202f32:	0495                	addi	s1,s1,5
        insert_vma_struct(mm, vma);
ffffffffc0202f34:	8522                	mv	a0,s0
ffffffffc0202f36:	eb3ff0ef          	jal	ffffffffc0202de8 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0202f3a:	fd249fe3          	bne	s1,s2,ffffffffc0202f18 <vmm_init+0x62>
    return listelm->next;
ffffffffc0202f3e:	641c                	ld	a5,8(s0)
ffffffffc0202f40:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0202f42:	1fb00593          	li	a1,507
ffffffffc0202f46:	8abe                	mv	s5,a5
    {
        assert(le != &(mm->mmap_list));
ffffffffc0202f48:	20f40d63          	beq	s0,a5,ffffffffc0203162 <vmm_init+0x2ac>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0202f4c:	fe87b603          	ld	a2,-24(a5)
ffffffffc0202f50:	ffe70693          	addi	a3,a4,-2
ffffffffc0202f54:	14d61763          	bne	a2,a3,ffffffffc02030a2 <vmm_init+0x1ec>
ffffffffc0202f58:	ff07b683          	ld	a3,-16(a5)
ffffffffc0202f5c:	14e69363          	bne	a3,a4,ffffffffc02030a2 <vmm_init+0x1ec>
    for (i = 1; i <= step2; i++)
ffffffffc0202f60:	0715                	addi	a4,a4,5
ffffffffc0202f62:	679c                	ld	a5,8(a5)
ffffffffc0202f64:	feb712e3          	bne	a4,a1,ffffffffc0202f48 <vmm_init+0x92>
ffffffffc0202f68:	491d                	li	s2,7
ffffffffc0202f6a:	4495                	li	s1,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0202f6c:	85a6                	mv	a1,s1
ffffffffc0202f6e:	8522                	mv	a0,s0
ffffffffc0202f70:	e39ff0ef          	jal	ffffffffc0202da8 <find_vma>
ffffffffc0202f74:	8a2a                	mv	s4,a0
        assert(vma1 != NULL);
ffffffffc0202f76:	22050663          	beqz	a0,ffffffffc02031a2 <vmm_init+0x2ec>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0202f7a:	00148593          	addi	a1,s1,1
ffffffffc0202f7e:	8522                	mv	a0,s0
ffffffffc0202f80:	e29ff0ef          	jal	ffffffffc0202da8 <find_vma>
ffffffffc0202f84:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0202f86:	1e050e63          	beqz	a0,ffffffffc0203182 <vmm_init+0x2cc>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0202f8a:	85ca                	mv	a1,s2
ffffffffc0202f8c:	8522                	mv	a0,s0
ffffffffc0202f8e:	e1bff0ef          	jal	ffffffffc0202da8 <find_vma>
        assert(vma3 == NULL);
ffffffffc0202f92:	1a051863          	bnez	a0,ffffffffc0203142 <vmm_init+0x28c>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0202f96:	00348593          	addi	a1,s1,3
ffffffffc0202f9a:	8522                	mv	a0,s0
ffffffffc0202f9c:	e0dff0ef          	jal	ffffffffc0202da8 <find_vma>
        assert(vma4 == NULL);
ffffffffc0202fa0:	18051163          	bnez	a0,ffffffffc0203122 <vmm_init+0x26c>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0202fa4:	00448593          	addi	a1,s1,4
ffffffffc0202fa8:	8522                	mv	a0,s0
ffffffffc0202faa:	dffff0ef          	jal	ffffffffc0202da8 <find_vma>
        assert(vma5 == NULL);
ffffffffc0202fae:	14051a63          	bnez	a0,ffffffffc0203102 <vmm_init+0x24c>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0202fb2:	008a3783          	ld	a5,8(s4)
ffffffffc0202fb6:	12979663          	bne	a5,s1,ffffffffc02030e2 <vmm_init+0x22c>
ffffffffc0202fba:	010a3783          	ld	a5,16(s4)
ffffffffc0202fbe:	13279263          	bne	a5,s2,ffffffffc02030e2 <vmm_init+0x22c>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0202fc2:	0089b783          	ld	a5,8(s3)
ffffffffc0202fc6:	0e979e63          	bne	a5,s1,ffffffffc02030c2 <vmm_init+0x20c>
ffffffffc0202fca:	0109b783          	ld	a5,16(s3)
ffffffffc0202fce:	0f279a63          	bne	a5,s2,ffffffffc02030c2 <vmm_init+0x20c>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0202fd2:	0495                	addi	s1,s1,5
ffffffffc0202fd4:	1f900793          	li	a5,505
ffffffffc0202fd8:	0915                	addi	s2,s2,5
ffffffffc0202fda:	f8f499e3          	bne	s1,a5,ffffffffc0202f6c <vmm_init+0xb6>
ffffffffc0202fde:	4491                	li	s1,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0202fe0:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0202fe2:	85a6                	mv	a1,s1
ffffffffc0202fe4:	8522                	mv	a0,s0
ffffffffc0202fe6:	dc3ff0ef          	jal	ffffffffc0202da8 <find_vma>
        if (vma_below_5 != NULL)
ffffffffc0202fea:	1c051c63          	bnez	a0,ffffffffc02031c2 <vmm_init+0x30c>
    for (i = 4; i >= 0; i--)
ffffffffc0202fee:	14fd                	addi	s1,s1,-1
ffffffffc0202ff0:	ff2499e3          	bne	s1,s2,ffffffffc0202fe2 <vmm_init+0x12c>
    while ((le = list_next(list)) != list)
ffffffffc0202ff4:	028a8063          	beq	s5,s0,ffffffffc0203014 <vmm_init+0x15e>
    __list_del(listelm->prev, listelm->next);
ffffffffc0202ff8:	008ab783          	ld	a5,8(s5) # 1008 <kern_entry-0xffffffffc01feff8>
ffffffffc0202ffc:	000ab703          	ld	a4,0(s5)
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203000:	fe0a8513          	addi	a0,s5,-32
    prev->next = next;
ffffffffc0203004:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203006:	e398                	sd	a4,0(a5)
ffffffffc0203008:	b2bfe0ef          	jal	ffffffffc0201b32 <kfree>
    return listelm->next;
ffffffffc020300c:	641c                	ld	a5,8(s0)
ffffffffc020300e:	8abe                	mv	s5,a5
    while ((le = list_next(list)) != list)
ffffffffc0203010:	fef414e3          	bne	s0,a5,ffffffffc0202ff8 <vmm_init+0x142>
    kfree(mm); // kfree mm
ffffffffc0203014:	8522                	mv	a0,s0
ffffffffc0203016:	b1dfe0ef          	jal	ffffffffc0201b32 <kfree>
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc020301a:	00002517          	auipc	a0,0x2
ffffffffc020301e:	36e50513          	addi	a0,a0,878 # ffffffffc0205388 <etext+0x1540>
ffffffffc0203022:	972fd0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0203026:	7442                	ld	s0,48(sp)
ffffffffc0203028:	70e2                	ld	ra,56(sp)
ffffffffc020302a:	74a2                	ld	s1,40(sp)
ffffffffc020302c:	7902                	ld	s2,32(sp)
ffffffffc020302e:	69e2                	ld	s3,24(sp)
ffffffffc0203030:	6a42                	ld	s4,16(sp)
ffffffffc0203032:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203034:	00002517          	auipc	a0,0x2
ffffffffc0203038:	37450513          	addi	a0,a0,884 # ffffffffc02053a8 <etext+0x1560>
}
ffffffffc020303c:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc020303e:	956fd06f          	j	ffffffffc0200194 <cprintf>
        assert(vma != NULL);
ffffffffc0203042:	00002697          	auipc	a3,0x2
ffffffffc0203046:	1f668693          	addi	a3,a3,502 # ffffffffc0205238 <etext+0x13f0>
ffffffffc020304a:	00001617          	auipc	a2,0x1
ffffffffc020304e:	6de60613          	addi	a2,a2,1758 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0203052:	0da00593          	li	a1,218
ffffffffc0203056:	00002517          	auipc	a0,0x2
ffffffffc020305a:	16250513          	addi	a0,a0,354 # ffffffffc02051b8 <etext+0x1370>
ffffffffc020305e:	ba8fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(mm != NULL);
ffffffffc0203062:	00002697          	auipc	a3,0x2
ffffffffc0203066:	1c668693          	addi	a3,a3,454 # ffffffffc0205228 <etext+0x13e0>
ffffffffc020306a:	00001617          	auipc	a2,0x1
ffffffffc020306e:	6be60613          	addi	a2,a2,1726 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0203072:	0d200593          	li	a1,210
ffffffffc0203076:	00002517          	auipc	a0,0x2
ffffffffc020307a:	14250513          	addi	a0,a0,322 # ffffffffc02051b8 <etext+0x1370>
ffffffffc020307e:	b88fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma != NULL);
ffffffffc0203082:	00002697          	auipc	a3,0x2
ffffffffc0203086:	1b668693          	addi	a3,a3,438 # ffffffffc0205238 <etext+0x13f0>
ffffffffc020308a:	00001617          	auipc	a2,0x1
ffffffffc020308e:	69e60613          	addi	a2,a2,1694 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0203092:	0e100593          	li	a1,225
ffffffffc0203096:	00002517          	auipc	a0,0x2
ffffffffc020309a:	12250513          	addi	a0,a0,290 # ffffffffc02051b8 <etext+0x1370>
ffffffffc020309e:	b68fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc02030a2:	00002697          	auipc	a3,0x2
ffffffffc02030a6:	1be68693          	addi	a3,a3,446 # ffffffffc0205260 <etext+0x1418>
ffffffffc02030aa:	00001617          	auipc	a2,0x1
ffffffffc02030ae:	67e60613          	addi	a2,a2,1662 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02030b2:	0eb00593          	li	a1,235
ffffffffc02030b6:	00002517          	auipc	a0,0x2
ffffffffc02030ba:	10250513          	addi	a0,a0,258 # ffffffffc02051b8 <etext+0x1370>
ffffffffc02030be:	b48fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc02030c2:	00002697          	auipc	a3,0x2
ffffffffc02030c6:	25668693          	addi	a3,a3,598 # ffffffffc0205318 <etext+0x14d0>
ffffffffc02030ca:	00001617          	auipc	a2,0x1
ffffffffc02030ce:	65e60613          	addi	a2,a2,1630 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02030d2:	0fd00593          	li	a1,253
ffffffffc02030d6:	00002517          	auipc	a0,0x2
ffffffffc02030da:	0e250513          	addi	a0,a0,226 # ffffffffc02051b8 <etext+0x1370>
ffffffffc02030de:	b28fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc02030e2:	00002697          	auipc	a3,0x2
ffffffffc02030e6:	20668693          	addi	a3,a3,518 # ffffffffc02052e8 <etext+0x14a0>
ffffffffc02030ea:	00001617          	auipc	a2,0x1
ffffffffc02030ee:	63e60613          	addi	a2,a2,1598 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02030f2:	0fc00593          	li	a1,252
ffffffffc02030f6:	00002517          	auipc	a0,0x2
ffffffffc02030fa:	0c250513          	addi	a0,a0,194 # ffffffffc02051b8 <etext+0x1370>
ffffffffc02030fe:	b08fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma5 == NULL);
ffffffffc0203102:	00002697          	auipc	a3,0x2
ffffffffc0203106:	1d668693          	addi	a3,a3,470 # ffffffffc02052d8 <etext+0x1490>
ffffffffc020310a:	00001617          	auipc	a2,0x1
ffffffffc020310e:	61e60613          	addi	a2,a2,1566 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0203112:	0fa00593          	li	a1,250
ffffffffc0203116:	00002517          	auipc	a0,0x2
ffffffffc020311a:	0a250513          	addi	a0,a0,162 # ffffffffc02051b8 <etext+0x1370>
ffffffffc020311e:	ae8fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma4 == NULL);
ffffffffc0203122:	00002697          	auipc	a3,0x2
ffffffffc0203126:	1a668693          	addi	a3,a3,422 # ffffffffc02052c8 <etext+0x1480>
ffffffffc020312a:	00001617          	auipc	a2,0x1
ffffffffc020312e:	5fe60613          	addi	a2,a2,1534 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0203132:	0f800593          	li	a1,248
ffffffffc0203136:	00002517          	auipc	a0,0x2
ffffffffc020313a:	08250513          	addi	a0,a0,130 # ffffffffc02051b8 <etext+0x1370>
ffffffffc020313e:	ac8fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma3 == NULL);
ffffffffc0203142:	00002697          	auipc	a3,0x2
ffffffffc0203146:	17668693          	addi	a3,a3,374 # ffffffffc02052b8 <etext+0x1470>
ffffffffc020314a:	00001617          	auipc	a2,0x1
ffffffffc020314e:	5de60613          	addi	a2,a2,1502 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0203152:	0f600593          	li	a1,246
ffffffffc0203156:	00002517          	auipc	a0,0x2
ffffffffc020315a:	06250513          	addi	a0,a0,98 # ffffffffc02051b8 <etext+0x1370>
ffffffffc020315e:	aa8fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203162:	00002697          	auipc	a3,0x2
ffffffffc0203166:	0e668693          	addi	a3,a3,230 # ffffffffc0205248 <etext+0x1400>
ffffffffc020316a:	00001617          	auipc	a2,0x1
ffffffffc020316e:	5be60613          	addi	a2,a2,1470 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0203172:	0e900593          	li	a1,233
ffffffffc0203176:	00002517          	auipc	a0,0x2
ffffffffc020317a:	04250513          	addi	a0,a0,66 # ffffffffc02051b8 <etext+0x1370>
ffffffffc020317e:	a88fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma2 != NULL);
ffffffffc0203182:	00002697          	auipc	a3,0x2
ffffffffc0203186:	12668693          	addi	a3,a3,294 # ffffffffc02052a8 <etext+0x1460>
ffffffffc020318a:	00001617          	auipc	a2,0x1
ffffffffc020318e:	59e60613          	addi	a2,a2,1438 # ffffffffc0204728 <etext+0x8e0>
ffffffffc0203192:	0f400593          	li	a1,244
ffffffffc0203196:	00002517          	auipc	a0,0x2
ffffffffc020319a:	02250513          	addi	a0,a0,34 # ffffffffc02051b8 <etext+0x1370>
ffffffffc020319e:	a68fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma1 != NULL);
ffffffffc02031a2:	00002697          	auipc	a3,0x2
ffffffffc02031a6:	0f668693          	addi	a3,a3,246 # ffffffffc0205298 <etext+0x1450>
ffffffffc02031aa:	00001617          	auipc	a2,0x1
ffffffffc02031ae:	57e60613          	addi	a2,a2,1406 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02031b2:	0f200593          	li	a1,242
ffffffffc02031b6:	00002517          	auipc	a0,0x2
ffffffffc02031ba:	00250513          	addi	a0,a0,2 # ffffffffc02051b8 <etext+0x1370>
ffffffffc02031be:	a48fd0ef          	jal	ffffffffc0200406 <__panic>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc02031c2:	6914                	ld	a3,16(a0)
ffffffffc02031c4:	6510                	ld	a2,8(a0)
ffffffffc02031c6:	0004859b          	sext.w	a1,s1
ffffffffc02031ca:	00002517          	auipc	a0,0x2
ffffffffc02031ce:	17e50513          	addi	a0,a0,382 # ffffffffc0205348 <etext+0x1500>
ffffffffc02031d2:	fc3fc0ef          	jal	ffffffffc0200194 <cprintf>
        assert(vma_below_5 == NULL);
ffffffffc02031d6:	00002697          	auipc	a3,0x2
ffffffffc02031da:	19a68693          	addi	a3,a3,410 # ffffffffc0205370 <etext+0x1528>
ffffffffc02031de:	00001617          	auipc	a2,0x1
ffffffffc02031e2:	54a60613          	addi	a2,a2,1354 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02031e6:	10700593          	li	a1,263
ffffffffc02031ea:	00002517          	auipc	a0,0x2
ffffffffc02031ee:	fce50513          	addi	a0,a0,-50 # ffffffffc02051b8 <etext+0x1370>
ffffffffc02031f2:	a14fd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc02031f6 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc02031f6:	8526                	mv	a0,s1
	jalr s0
ffffffffc02031f8:	9402                	jalr	s0

	jal do_exit
ffffffffc02031fa:	3ac000ef          	jal	ffffffffc02035a6 <do_exit>

ffffffffc02031fe <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc02031fe:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203200:	0e800513          	li	a0,232
{
ffffffffc0203204:	e022                	sd	s0,0(sp)
ffffffffc0203206:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203208:	885fe0ef          	jal	ffffffffc0201a8c <kmalloc>
ffffffffc020320c:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc020320e:	c521                	beqz	a0,ffffffffc0203256 <alloc_proc+0x58>
         *       struct trapframe *tf;                       // Trap frame for current interrupt
         *       uintptr_t pgdir;                            // the base addr of Page Directroy Table(PDT)
         *       uint32_t flags;                             // Process flag
         *       char name[PROC_NAME_LEN + 1];               // Process name
         */
        proc->state = PROC_UNINIT;
ffffffffc0203210:	57fd                	li	a5,-1
ffffffffc0203212:	1782                	slli	a5,a5,0x20
ffffffffc0203214:	e11c                	sd	a5,0(a0)
        proc->pid = -1;
        proc->runs = 0;
ffffffffc0203216:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc020321a:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc020321e:	00052c23          	sw	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203222:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0203226:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc020322a:	07000613          	li	a2,112
ffffffffc020322e:	4581                	li	a1,0
ffffffffc0203230:	03050513          	addi	a0,a0,48
ffffffffc0203234:	3c7000ef          	jal	ffffffffc0203dfa <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203238:	0000a797          	auipc	a5,0xa
ffffffffc020323c:	2787b783          	ld	a5,632(a5) # ffffffffc020d4b0 <boot_pgdir_pa>
        proc->tf = NULL;
ffffffffc0203240:	0a043023          	sd	zero,160(s0) # ffffffffc02000a0 <kern_init+0x56>
        proc->flags = 0;
ffffffffc0203244:	0a042823          	sw	zero,176(s0)
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203248:	f45c                	sd	a5,168(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1);
ffffffffc020324a:	0b440513          	addi	a0,s0,180
ffffffffc020324e:	4641                	li	a2,16
ffffffffc0203250:	4581                	li	a1,0
ffffffffc0203252:	3a9000ef          	jal	ffffffffc0203dfa <memset>
    }
    return proc;
}
ffffffffc0203256:	60a2                	ld	ra,8(sp)
ffffffffc0203258:	8522                	mv	a0,s0
ffffffffc020325a:	6402                	ld	s0,0(sp)
ffffffffc020325c:	0141                	addi	sp,sp,16
ffffffffc020325e:	8082                	ret

ffffffffc0203260 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203260:	0000a797          	auipc	a5,0xa
ffffffffc0203264:	2807b783          	ld	a5,640(a5) # ffffffffc020d4e0 <current>
ffffffffc0203268:	73c8                	ld	a0,160(a5)
ffffffffc020326a:	aabfd06f          	j	ffffffffc0200d14 <forkrets>

ffffffffc020326e <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc020326e:	1101                	addi	sp,sp,-32
ffffffffc0203270:	e822                	sd	s0,16(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0203272:	0000a417          	auipc	s0,0xa
ffffffffc0203276:	26e43403          	ld	s0,622(s0) # ffffffffc020d4e0 <current>
{
ffffffffc020327a:	e04a                	sd	s2,0(sp)
    memset(name, 0, sizeof(name));
ffffffffc020327c:	4641                	li	a2,16
{
ffffffffc020327e:	892a                	mv	s2,a0
    memset(name, 0, sizeof(name));
ffffffffc0203280:	4581                	li	a1,0
ffffffffc0203282:	00006517          	auipc	a0,0x6
ffffffffc0203286:	1c650513          	addi	a0,a0,454 # ffffffffc0209448 <name.2>
{
ffffffffc020328a:	ec06                	sd	ra,24(sp)
ffffffffc020328c:	e426                	sd	s1,8(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc020328e:	4044                	lw	s1,4(s0)
    memset(name, 0, sizeof(name));
ffffffffc0203290:	36b000ef          	jal	ffffffffc0203dfa <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
ffffffffc0203294:	0b440593          	addi	a1,s0,180
ffffffffc0203298:	463d                	li	a2,15
ffffffffc020329a:	00006517          	auipc	a0,0x6
ffffffffc020329e:	1ae50513          	addi	a0,a0,430 # ffffffffc0209448 <name.2>
ffffffffc02032a2:	36b000ef          	jal	ffffffffc0203e0c <memcpy>
ffffffffc02032a6:	862a                	mv	a2,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc02032a8:	85a6                	mv	a1,s1
ffffffffc02032aa:	00002517          	auipc	a0,0x2
ffffffffc02032ae:	11650513          	addi	a0,a0,278 # ffffffffc02053c0 <etext+0x1578>
ffffffffc02032b2:	ee3fc0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
ffffffffc02032b6:	85ca                	mv	a1,s2
ffffffffc02032b8:	00002517          	auipc	a0,0x2
ffffffffc02032bc:	13050513          	addi	a0,a0,304 # ffffffffc02053e8 <etext+0x15a0>
ffffffffc02032c0:	ed5fc0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
ffffffffc02032c4:	00002517          	auipc	a0,0x2
ffffffffc02032c8:	13450513          	addi	a0,a0,308 # ffffffffc02053f8 <etext+0x15b0>
ffffffffc02032cc:	ec9fc0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc02032d0:	60e2                	ld	ra,24(sp)
ffffffffc02032d2:	6442                	ld	s0,16(sp)
ffffffffc02032d4:	64a2                	ld	s1,8(sp)
ffffffffc02032d6:	6902                	ld	s2,0(sp)
ffffffffc02032d8:	4501                	li	a0,0
ffffffffc02032da:	6105                	addi	sp,sp,32
ffffffffc02032dc:	8082                	ret

ffffffffc02032de <proc_run>:
    if (proc != current)
ffffffffc02032de:	0000a697          	auipc	a3,0xa
ffffffffc02032e2:	2026b683          	ld	a3,514(a3) # ffffffffc020d4e0 <current>
ffffffffc02032e6:	04a68663          	beq	a3,a0,ffffffffc0203332 <proc_run+0x54>
ffffffffc02032ea:	87aa                	mv	a5,a0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02032ec:	10002773          	csrr	a4,sstatus
ffffffffc02032f0:	8b09                	andi	a4,a4,2
ffffffffc02032f2:	eb11                	bnez	a4,ffffffffc0203306 <proc_run+0x28>
            switch_to(&(prev->context), &(proc->context));
ffffffffc02032f4:	03068513          	addi	a0,a3,48
ffffffffc02032f8:	03078593          	addi	a1,a5,48
            current = proc;
ffffffffc02032fc:	0000a717          	auipc	a4,0xa
ffffffffc0203300:	1ef73223          	sd	a5,484(a4) # ffffffffc020d4e0 <current>
            switch_to(&(prev->context), &(proc->context));
ffffffffc0203304:	ab05                	j	ffffffffc0203834 <switch_to>
{
ffffffffc0203306:	1101                	addi	sp,sp,-32
ffffffffc0203308:	ec06                	sd	ra,24(sp)
ffffffffc020330a:	e436                	sd	a3,8(sp)
ffffffffc020330c:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc020330e:	d66fd0ef          	jal	ffffffffc0200874 <intr_disable>
            switch_to(&(prev->context), &(proc->context));
ffffffffc0203312:	6782                	ld	a5,0(sp)
ffffffffc0203314:	66a2                	ld	a3,8(sp)
ffffffffc0203316:	03078593          	addi	a1,a5,48
ffffffffc020331a:	03068513          	addi	a0,a3,48
            current = proc;
ffffffffc020331e:	0000a717          	auipc	a4,0xa
ffffffffc0203322:	1cf73123          	sd	a5,450(a4) # ffffffffc020d4e0 <current>
            switch_to(&(prev->context), &(proc->context));
ffffffffc0203326:	50e000ef          	jal	ffffffffc0203834 <switch_to>
}
ffffffffc020332a:	60e2                	ld	ra,24(sp)
ffffffffc020332c:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020332e:	d40fd06f          	j	ffffffffc020086e <intr_enable>
ffffffffc0203332:	8082                	ret

ffffffffc0203334 <do_fork>:
    if (nr_process >= MAX_PROCESS)
ffffffffc0203334:	0000a717          	auipc	a4,0xa
ffffffffc0203338:	1a472703          	lw	a4,420(a4) # ffffffffc020d4d8 <nr_process>
ffffffffc020333c:	6785                	lui	a5,0x1
ffffffffc020333e:	1cf75e63          	bge	a4,a5,ffffffffc020351a <do_fork+0x1e6>
{
ffffffffc0203342:	7179                	addi	sp,sp,-48
ffffffffc0203344:	f022                	sd	s0,32(sp)
ffffffffc0203346:	ec26                	sd	s1,24(sp)
ffffffffc0203348:	e84a                	sd	s2,16(sp)
ffffffffc020334a:	f406                	sd	ra,40(sp)
ffffffffc020334c:	892e                	mv	s2,a1
ffffffffc020334e:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc0203350:	eafff0ef          	jal	ffffffffc02031fe <alloc_proc>
ffffffffc0203354:	84aa                	mv	s1,a0
ffffffffc0203356:	1c050063          	beqz	a0,ffffffffc0203516 <do_fork+0x1e2>
ffffffffc020335a:	e44e                	sd	s3,8(sp)
    proc->parent = current;
ffffffffc020335c:	0000a997          	auipc	s3,0xa
ffffffffc0203360:	18498993          	addi	s3,s3,388 # ffffffffc020d4e0 <current>
ffffffffc0203364:	0009b783          	ld	a5,0(s3)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203368:	4509                	li	a0,2
    proc->parent = current;
ffffffffc020336a:	f09c                	sd	a5,32(s1)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020336c:	8e3fe0ef          	jal	ffffffffc0201c4e <alloc_pages>
    if (page != NULL)
ffffffffc0203370:	18050f63          	beqz	a0,ffffffffc020350e <do_fork+0x1da>
    return page - pages + nbase;
ffffffffc0203374:	0000a697          	auipc	a3,0xa
ffffffffc0203378:	15c6b683          	ld	a3,348(a3) # ffffffffc020d4d0 <pages>
ffffffffc020337c:	00002797          	auipc	a5,0x2
ffffffffc0203380:	4ec7b783          	ld	a5,1260(a5) # ffffffffc0205868 <nbase>
    return KADDR(page2pa(page));
ffffffffc0203384:	0000a717          	auipc	a4,0xa
ffffffffc0203388:	14473703          	ld	a4,324(a4) # ffffffffc020d4c8 <npage>
    return page - pages + nbase;
ffffffffc020338c:	40d506b3          	sub	a3,a0,a3
ffffffffc0203390:	8699                	srai	a3,a3,0x6
ffffffffc0203392:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0203394:	00c69793          	slli	a5,a3,0xc
ffffffffc0203398:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020339a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020339c:	1ae7f163          	bgeu	a5,a4,ffffffffc020353e <do_fork+0x20a>
    assert(current->mm == NULL);
ffffffffc02033a0:	0009b783          	ld	a5,0(s3)
ffffffffc02033a4:	0000a717          	auipc	a4,0xa
ffffffffc02033a8:	11c73703          	ld	a4,284(a4) # ffffffffc020d4c0 <va_pa_offset>
ffffffffc02033ac:	779c                	ld	a5,40(a5)
ffffffffc02033ae:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc02033b0:	e894                	sd	a3,16(s1)
    assert(current->mm == NULL);
ffffffffc02033b2:	16079663          	bnez	a5,ffffffffc020351e <do_fork+0x1ea>
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc02033b6:	6789                	lui	a5,0x2
ffffffffc02033b8:	ee078793          	addi	a5,a5,-288 # 1ee0 <kern_entry-0xffffffffc01fe120>
ffffffffc02033bc:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02033be:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc02033c0:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc02033c2:	87b6                	mv	a5,a3
ffffffffc02033c4:	12040713          	addi	a4,s0,288
ffffffffc02033c8:	6a0c                	ld	a1,16(a2)
ffffffffc02033ca:	00063803          	ld	a6,0(a2)
ffffffffc02033ce:	6608                	ld	a0,8(a2)
ffffffffc02033d0:	eb8c                	sd	a1,16(a5)
ffffffffc02033d2:	0107b023          	sd	a6,0(a5)
ffffffffc02033d6:	e788                	sd	a0,8(a5)
ffffffffc02033d8:	6e0c                	ld	a1,24(a2)
ffffffffc02033da:	02060613          	addi	a2,a2,32
ffffffffc02033de:	02078793          	addi	a5,a5,32
ffffffffc02033e2:	feb7bc23          	sd	a1,-8(a5)
ffffffffc02033e6:	fee611e3          	bne	a2,a4,ffffffffc02033c8 <do_fork+0x94>
    proc->tf->gpr.a0 = 0;
ffffffffc02033ea:	0406b823          	sd	zero,80(a3)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02033ee:	10090263          	beqz	s2,ffffffffc02034f2 <do_fork+0x1be>
    if (++last_pid >= MAX_PID)
ffffffffc02033f2:	00006517          	auipc	a0,0x6
ffffffffc02033f6:	c3a52503          	lw	a0,-966(a0) # ffffffffc020902c <last_pid.1>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02033fa:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02033fe:	00000797          	auipc	a5,0x0
ffffffffc0203402:	e6278793          	addi	a5,a5,-414 # ffffffffc0203260 <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc0203406:	2505                	addiw	a0,a0,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0203408:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc020340a:	fc94                	sd	a3,56(s1)
    if (++last_pid >= MAX_PID)
ffffffffc020340c:	00006717          	auipc	a4,0x6
ffffffffc0203410:	c2a72023          	sw	a0,-992(a4) # ffffffffc020902c <last_pid.1>
ffffffffc0203414:	6789                	lui	a5,0x2
ffffffffc0203416:	0ef55063          	bge	a0,a5,ffffffffc02034f6 <do_fork+0x1c2>
    if (last_pid >= next_safe)
ffffffffc020341a:	00006797          	auipc	a5,0x6
ffffffffc020341e:	c0e7a783          	lw	a5,-1010(a5) # ffffffffc0209028 <next_safe.0>
ffffffffc0203422:	0000a417          	auipc	s0,0xa
ffffffffc0203426:	03640413          	addi	s0,s0,54 # ffffffffc020d458 <proc_list>
ffffffffc020342a:	06f54563          	blt	a0,a5,ffffffffc0203494 <do_fork+0x160>
ffffffffc020342e:	0000a417          	auipc	s0,0xa
ffffffffc0203432:	02a40413          	addi	s0,s0,42 # ffffffffc020d458 <proc_list>
ffffffffc0203436:	00843883          	ld	a7,8(s0)
        next_safe = MAX_PID;
ffffffffc020343a:	6789                	lui	a5,0x2
ffffffffc020343c:	00006717          	auipc	a4,0x6
ffffffffc0203440:	bef72623          	sw	a5,-1044(a4) # ffffffffc0209028 <next_safe.0>
ffffffffc0203444:	86aa                	mv	a3,a0
ffffffffc0203446:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc0203448:	04888063          	beq	a7,s0,ffffffffc0203488 <do_fork+0x154>
ffffffffc020344c:	882e                	mv	a6,a1
ffffffffc020344e:	87c6                	mv	a5,a7
ffffffffc0203450:	6609                	lui	a2,0x2
ffffffffc0203452:	a811                	j	ffffffffc0203466 <do_fork+0x132>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0203454:	00e6d663          	bge	a3,a4,ffffffffc0203460 <do_fork+0x12c>
ffffffffc0203458:	00c75463          	bge	a4,a2,ffffffffc0203460 <do_fork+0x12c>
                next_safe = proc->pid;
ffffffffc020345c:	863a                	mv	a2,a4
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc020345e:	4805                	li	a6,1
ffffffffc0203460:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0203462:	00878d63          	beq	a5,s0,ffffffffc020347c <do_fork+0x148>
            if (proc->pid == last_pid)
ffffffffc0203466:	f3c7a703          	lw	a4,-196(a5) # 1f3c <kern_entry-0xffffffffc01fe0c4>
ffffffffc020346a:	fed715e3          	bne	a4,a3,ffffffffc0203454 <do_fork+0x120>
                if (++last_pid >= next_safe)
ffffffffc020346e:	2685                	addiw	a3,a3,1
ffffffffc0203470:	08c6d963          	bge	a3,a2,ffffffffc0203502 <do_fork+0x1ce>
ffffffffc0203474:	679c                	ld	a5,8(a5)
ffffffffc0203476:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc0203478:	fe8797e3          	bne	a5,s0,ffffffffc0203466 <do_fork+0x132>
ffffffffc020347c:	00080663          	beqz	a6,ffffffffc0203488 <do_fork+0x154>
ffffffffc0203480:	00006797          	auipc	a5,0x6
ffffffffc0203484:	bac7a423          	sw	a2,-1112(a5) # ffffffffc0209028 <next_safe.0>
ffffffffc0203488:	c591                	beqz	a1,ffffffffc0203494 <do_fork+0x160>
ffffffffc020348a:	00006797          	auipc	a5,0x6
ffffffffc020348e:	bad7a123          	sw	a3,-1118(a5) # ffffffffc020902c <last_pid.1>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0203492:	8536                	mv	a0,a3
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0203494:	45a9                	li	a1,10
    proc->pid = get_pid();
ffffffffc0203496:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0203498:	4cc000ef          	jal	ffffffffc0203964 <hash32>
ffffffffc020349c:	02051793          	slli	a5,a0,0x20
ffffffffc02034a0:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02034a4:	00006797          	auipc	a5,0x6
ffffffffc02034a8:	fb478793          	addi	a5,a5,-76 # ffffffffc0209458 <hash_list>
ffffffffc02034ac:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc02034ae:	6518                	ld	a4,8(a0)
ffffffffc02034b0:	0d848793          	addi	a5,s1,216
ffffffffc02034b4:	6414                	ld	a3,8(s0)
    prev->next = next->prev = elm;
ffffffffc02034b6:	e31c                	sd	a5,0(a4)
ffffffffc02034b8:	e51c                	sd	a5,8(a0)
    nr_process++;
ffffffffc02034ba:	0000a797          	auipc	a5,0xa
ffffffffc02034be:	01e7a783          	lw	a5,30(a5) # ffffffffc020d4d8 <nr_process>
    elm->next = next;
ffffffffc02034c2:	f0f8                	sd	a4,224(s1)
    elm->prev = prev;
ffffffffc02034c4:	ece8                	sd	a0,216(s1)
    list_add(&proc_list, &(proc->list_link));
ffffffffc02034c6:	0c848713          	addi	a4,s1,200
    prev->next = next->prev = elm;
ffffffffc02034ca:	e298                	sd	a4,0(a3)
    wakeup_proc(proc);
ffffffffc02034cc:	8526                	mv	a0,s1
    nr_process++;
ffffffffc02034ce:	2785                	addiw	a5,a5,1
    elm->next = next;
ffffffffc02034d0:	e8f4                	sd	a3,208(s1)
    elm->prev = prev;
ffffffffc02034d2:	e4e0                	sd	s0,200(s1)
    prev->next = next->prev = elm;
ffffffffc02034d4:	e418                	sd	a4,8(s0)
ffffffffc02034d6:	0000a717          	auipc	a4,0xa
ffffffffc02034da:	00f72123          	sw	a5,2(a4) # ffffffffc020d4d8 <nr_process>
    wakeup_proc(proc);
ffffffffc02034de:	3c0000ef          	jal	ffffffffc020389e <wakeup_proc>
    ret = proc->pid;
ffffffffc02034e2:	40c8                	lw	a0,4(s1)
ffffffffc02034e4:	69a2                	ld	s3,8(sp)
}
ffffffffc02034e6:	70a2                	ld	ra,40(sp)
ffffffffc02034e8:	7402                	ld	s0,32(sp)
ffffffffc02034ea:	64e2                	ld	s1,24(sp)
ffffffffc02034ec:	6942                	ld	s2,16(sp)
ffffffffc02034ee:	6145                	addi	sp,sp,48
ffffffffc02034f0:	8082                	ret
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02034f2:	8936                	mv	s2,a3
ffffffffc02034f4:	bdfd                	j	ffffffffc02033f2 <do_fork+0xbe>
        last_pid = 1;
ffffffffc02034f6:	4505                	li	a0,1
ffffffffc02034f8:	00006797          	auipc	a5,0x6
ffffffffc02034fc:	b2a7aa23          	sw	a0,-1228(a5) # ffffffffc020902c <last_pid.1>
        goto inside;
ffffffffc0203500:	b73d                	j	ffffffffc020342e <do_fork+0xfa>
                    if (last_pid >= MAX_PID)
ffffffffc0203502:	6789                	lui	a5,0x2
ffffffffc0203504:	00f6c363          	blt	a3,a5,ffffffffc020350a <do_fork+0x1d6>
                        last_pid = 1;
ffffffffc0203508:	4685                	li	a3,1
                    goto repeat;
ffffffffc020350a:	4585                	li	a1,1
ffffffffc020350c:	bf35                	j	ffffffffc0203448 <do_fork+0x114>
    kfree(proc);
ffffffffc020350e:	8526                	mv	a0,s1
ffffffffc0203510:	e22fe0ef          	jal	ffffffffc0201b32 <kfree>
ffffffffc0203514:	69a2                	ld	s3,8(sp)
    ret = -E_NO_MEM;
ffffffffc0203516:	5571                	li	a0,-4
ffffffffc0203518:	b7f9                	j	ffffffffc02034e6 <do_fork+0x1b2>
    int ret = -E_NO_FREE_PROC;
ffffffffc020351a:	556d                	li	a0,-5
}
ffffffffc020351c:	8082                	ret
    assert(current->mm == NULL);
ffffffffc020351e:	00002697          	auipc	a3,0x2
ffffffffc0203522:	efa68693          	addi	a3,a3,-262 # ffffffffc0205418 <etext+0x15d0>
ffffffffc0203526:	00001617          	auipc	a2,0x1
ffffffffc020352a:	20260613          	addi	a2,a2,514 # ffffffffc0204728 <etext+0x8e0>
ffffffffc020352e:	11b00593          	li	a1,283
ffffffffc0203532:	00002517          	auipc	a0,0x2
ffffffffc0203536:	efe50513          	addi	a0,a0,-258 # ffffffffc0205430 <etext+0x15e8>
ffffffffc020353a:	ecdfc0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020353e:	00001617          	auipc	a2,0x1
ffffffffc0203542:	59a60613          	addi	a2,a2,1434 # ffffffffc0204ad8 <etext+0xc90>
ffffffffc0203546:	07100593          	li	a1,113
ffffffffc020354a:	00001517          	auipc	a0,0x1
ffffffffc020354e:	5b650513          	addi	a0,a0,1462 # ffffffffc0204b00 <etext+0xcb8>
ffffffffc0203552:	eb5fc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0203556 <kernel_thread>:
{
ffffffffc0203556:	7129                	addi	sp,sp,-320
ffffffffc0203558:	fa22                	sd	s0,304(sp)
ffffffffc020355a:	f626                	sd	s1,296(sp)
ffffffffc020355c:	f24a                	sd	s2,288(sp)
ffffffffc020355e:	842a                	mv	s0,a0
ffffffffc0203560:	84ae                	mv	s1,a1
ffffffffc0203562:	8932                	mv	s2,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0203564:	850a                	mv	a0,sp
ffffffffc0203566:	12000613          	li	a2,288
ffffffffc020356a:	4581                	li	a1,0
{
ffffffffc020356c:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020356e:	08d000ef          	jal	ffffffffc0203dfa <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc0203572:	e0a2                	sd	s0,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc0203574:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0203576:	100027f3          	csrr	a5,sstatus
ffffffffc020357a:	edd7f793          	andi	a5,a5,-291
ffffffffc020357e:	1207e793          	ori	a5,a5,288
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0203582:	860a                	mv	a2,sp
ffffffffc0203584:	10096513          	ori	a0,s2,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0203588:	00000717          	auipc	a4,0x0
ffffffffc020358c:	c6e70713          	addi	a4,a4,-914 # ffffffffc02031f6 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0203590:	4581                	li	a1,0
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0203592:	e23e                	sd	a5,256(sp)
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0203594:	e63a                	sd	a4,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0203596:	d9fff0ef          	jal	ffffffffc0203334 <do_fork>
}
ffffffffc020359a:	70f2                	ld	ra,312(sp)
ffffffffc020359c:	7452                	ld	s0,304(sp)
ffffffffc020359e:	74b2                	ld	s1,296(sp)
ffffffffc02035a0:	7912                	ld	s2,288(sp)
ffffffffc02035a2:	6131                	addi	sp,sp,320
ffffffffc02035a4:	8082                	ret

ffffffffc02035a6 <do_exit>:
{
ffffffffc02035a6:	1141                	addi	sp,sp,-16
    panic("process exit!!.\n");
ffffffffc02035a8:	00002617          	auipc	a2,0x2
ffffffffc02035ac:	ea060613          	addi	a2,a2,-352 # ffffffffc0205448 <etext+0x1600>
ffffffffc02035b0:	17900593          	li	a1,377
ffffffffc02035b4:	00002517          	auipc	a0,0x2
ffffffffc02035b8:	e7c50513          	addi	a0,a0,-388 # ffffffffc0205430 <etext+0x15e8>
{
ffffffffc02035bc:	e406                	sd	ra,8(sp)
    panic("process exit!!.\n");
ffffffffc02035be:	e49fc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc02035c2 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc02035c2:	7179                	addi	sp,sp,-48
ffffffffc02035c4:	ec26                	sd	s1,24(sp)
    elm->prev = elm->next = elm;
ffffffffc02035c6:	0000a797          	auipc	a5,0xa
ffffffffc02035ca:	e9278793          	addi	a5,a5,-366 # ffffffffc020d458 <proc_list>
ffffffffc02035ce:	f406                	sd	ra,40(sp)
ffffffffc02035d0:	f022                	sd	s0,32(sp)
ffffffffc02035d2:	e84a                	sd	s2,16(sp)
ffffffffc02035d4:	e44e                	sd	s3,8(sp)
ffffffffc02035d6:	00006497          	auipc	s1,0x6
ffffffffc02035da:	e8248493          	addi	s1,s1,-382 # ffffffffc0209458 <hash_list>
ffffffffc02035de:	e79c                	sd	a5,8(a5)
ffffffffc02035e0:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc02035e2:	0000a717          	auipc	a4,0xa
ffffffffc02035e6:	e7670713          	addi	a4,a4,-394 # ffffffffc020d458 <proc_list>
ffffffffc02035ea:	87a6                	mv	a5,s1
ffffffffc02035ec:	e79c                	sd	a5,8(a5)
ffffffffc02035ee:	e39c                	sd	a5,0(a5)
ffffffffc02035f0:	07c1                	addi	a5,a5,16
ffffffffc02035f2:	fee79de3          	bne	a5,a4,ffffffffc02035ec <proc_init+0x2a>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc02035f6:	c09ff0ef          	jal	ffffffffc02031fe <alloc_proc>
ffffffffc02035fa:	0000a917          	auipc	s2,0xa
ffffffffc02035fe:	ef690913          	addi	s2,s2,-266 # ffffffffc020d4f0 <idleproc>
ffffffffc0203602:	00a93023          	sd	a0,0(s2)
ffffffffc0203606:	1a050263          	beqz	a0,ffffffffc02037aa <proc_init+0x1e8>
    {
        panic("cannot alloc idleproc.\n");
    }

    // check the proc structure
    int *context_mem = (int *)kmalloc(sizeof(struct context));
ffffffffc020360a:	07000513          	li	a0,112
ffffffffc020360e:	c7efe0ef          	jal	ffffffffc0201a8c <kmalloc>
    memset(context_mem, 0, sizeof(struct context));
ffffffffc0203612:	07000613          	li	a2,112
ffffffffc0203616:	4581                	li	a1,0
    int *context_mem = (int *)kmalloc(sizeof(struct context));
ffffffffc0203618:	842a                	mv	s0,a0
    memset(context_mem, 0, sizeof(struct context));
ffffffffc020361a:	7e0000ef          	jal	ffffffffc0203dfa <memset>
    int context_init_flag = memcmp(&(idleproc->context), context_mem, sizeof(struct context));
ffffffffc020361e:	00093503          	ld	a0,0(s2)
ffffffffc0203622:	85a2                	mv	a1,s0
ffffffffc0203624:	07000613          	li	a2,112
ffffffffc0203628:	03050513          	addi	a0,a0,48
ffffffffc020362c:	7f8000ef          	jal	ffffffffc0203e24 <memcmp>
ffffffffc0203630:	89aa                	mv	s3,a0

    int *proc_name_mem = (int *)kmalloc(PROC_NAME_LEN);
ffffffffc0203632:	453d                	li	a0,15
ffffffffc0203634:	c58fe0ef          	jal	ffffffffc0201a8c <kmalloc>
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc0203638:	463d                	li	a2,15
ffffffffc020363a:	4581                	li	a1,0
    int *proc_name_mem = (int *)kmalloc(PROC_NAME_LEN);
ffffffffc020363c:	842a                	mv	s0,a0
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc020363e:	7bc000ef          	jal	ffffffffc0203dfa <memset>
    int proc_name_flag = memcmp(&(idleproc->name), proc_name_mem, PROC_NAME_LEN);
ffffffffc0203642:	00093503          	ld	a0,0(s2)
ffffffffc0203646:	85a2                	mv	a1,s0
ffffffffc0203648:	463d                	li	a2,15
ffffffffc020364a:	0b450513          	addi	a0,a0,180
ffffffffc020364e:	7d6000ef          	jal	ffffffffc0203e24 <memcmp>

    if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && !context_init_flag && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0 && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag)
ffffffffc0203652:	00093783          	ld	a5,0(s2)
ffffffffc0203656:	0000a717          	auipc	a4,0xa
ffffffffc020365a:	e5a73703          	ld	a4,-422(a4) # ffffffffc020d4b0 <boot_pgdir_pa>
ffffffffc020365e:	77d4                	ld	a3,168(a5)
ffffffffc0203660:	0ee68863          	beq	a3,a4,ffffffffc0203750 <proc_init+0x18e>
    {
        cprintf("alloc_proc() correct!\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0203664:	4709                	li	a4,2
ffffffffc0203666:	e398                	sd	a4,0(a5)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0203668:	00003717          	auipc	a4,0x3
ffffffffc020366c:	99870713          	addi	a4,a4,-1640 # ffffffffc0206000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203670:	0b478413          	addi	s0,a5,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0203674:	eb98                	sd	a4,16(a5)
    idleproc->need_resched = 1;
ffffffffc0203676:	4705                	li	a4,1
ffffffffc0203678:	cf98                	sw	a4,24(a5)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020367a:	8522                	mv	a0,s0
ffffffffc020367c:	4641                	li	a2,16
ffffffffc020367e:	4581                	li	a1,0
ffffffffc0203680:	77a000ef          	jal	ffffffffc0203dfa <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0203684:	8522                	mv	a0,s0
ffffffffc0203686:	463d                	li	a2,15
ffffffffc0203688:	00002597          	auipc	a1,0x2
ffffffffc020368c:	e0858593          	addi	a1,a1,-504 # ffffffffc0205490 <etext+0x1648>
ffffffffc0203690:	77c000ef          	jal	ffffffffc0203e0c <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0203694:	0000a797          	auipc	a5,0xa
ffffffffc0203698:	e447a783          	lw	a5,-444(a5) # ffffffffc020d4d8 <nr_process>

    current = idleproc;
ffffffffc020369c:	00093703          	ld	a4,0(s2)

    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02036a0:	4601                	li	a2,0
    nr_process++;
ffffffffc02036a2:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02036a4:	00002597          	auipc	a1,0x2
ffffffffc02036a8:	df458593          	addi	a1,a1,-524 # ffffffffc0205498 <etext+0x1650>
ffffffffc02036ac:	00000517          	auipc	a0,0x0
ffffffffc02036b0:	bc250513          	addi	a0,a0,-1086 # ffffffffc020326e <init_main>
    current = idleproc;
ffffffffc02036b4:	0000a697          	auipc	a3,0xa
ffffffffc02036b8:	e2e6b623          	sd	a4,-468(a3) # ffffffffc020d4e0 <current>
    nr_process++;
ffffffffc02036bc:	0000a717          	auipc	a4,0xa
ffffffffc02036c0:	e0f72e23          	sw	a5,-484(a4) # ffffffffc020d4d8 <nr_process>
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02036c4:	e93ff0ef          	jal	ffffffffc0203556 <kernel_thread>
ffffffffc02036c8:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc02036ca:	0ea05c63          	blez	a0,ffffffffc02037c2 <proc_init+0x200>
    if (0 < pid && pid < MAX_PID)
ffffffffc02036ce:	6789                	lui	a5,0x2
ffffffffc02036d0:	17f9                	addi	a5,a5,-2 # 1ffe <kern_entry-0xffffffffc01fe002>
ffffffffc02036d2:	fff5071b          	addiw	a4,a0,-1
ffffffffc02036d6:	02e7e463          	bltu	a5,a4,ffffffffc02036fe <proc_init+0x13c>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02036da:	45a9                	li	a1,10
ffffffffc02036dc:	288000ef          	jal	ffffffffc0203964 <hash32>
ffffffffc02036e0:	02051713          	slli	a4,a0,0x20
ffffffffc02036e4:	01c75793          	srli	a5,a4,0x1c
ffffffffc02036e8:	00f486b3          	add	a3,s1,a5
ffffffffc02036ec:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc02036ee:	a029                	j	ffffffffc02036f8 <proc_init+0x136>
            if (proc->pid == pid)
ffffffffc02036f0:	f2c7a703          	lw	a4,-212(a5)
ffffffffc02036f4:	0a870863          	beq	a4,s0,ffffffffc02037a4 <proc_init+0x1e2>
    return listelm->next;
ffffffffc02036f8:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02036fa:	fef69be3          	bne	a3,a5,ffffffffc02036f0 <proc_init+0x12e>
    return NULL;
ffffffffc02036fe:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203700:	0b478413          	addi	s0,a5,180
ffffffffc0203704:	4641                	li	a2,16
ffffffffc0203706:	4581                	li	a1,0
ffffffffc0203708:	8522                	mv	a0,s0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc020370a:	0000a717          	auipc	a4,0xa
ffffffffc020370e:	dcf73f23          	sd	a5,-546(a4) # ffffffffc020d4e8 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203712:	6e8000ef          	jal	ffffffffc0203dfa <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0203716:	8522                	mv	a0,s0
ffffffffc0203718:	463d                	li	a2,15
ffffffffc020371a:	00002597          	auipc	a1,0x2
ffffffffc020371e:	dae58593          	addi	a1,a1,-594 # ffffffffc02054c8 <etext+0x1680>
ffffffffc0203722:	6ea000ef          	jal	ffffffffc0203e0c <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0203726:	00093783          	ld	a5,0(s2)
ffffffffc020372a:	cbe1                	beqz	a5,ffffffffc02037fa <proc_init+0x238>
ffffffffc020372c:	43dc                	lw	a5,4(a5)
ffffffffc020372e:	e7f1                	bnez	a5,ffffffffc02037fa <proc_init+0x238>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0203730:	0000a797          	auipc	a5,0xa
ffffffffc0203734:	db87b783          	ld	a5,-584(a5) # ffffffffc020d4e8 <initproc>
ffffffffc0203738:	c3cd                	beqz	a5,ffffffffc02037da <proc_init+0x218>
ffffffffc020373a:	43d8                	lw	a4,4(a5)
ffffffffc020373c:	4785                	li	a5,1
ffffffffc020373e:	08f71e63          	bne	a4,a5,ffffffffc02037da <proc_init+0x218>
}
ffffffffc0203742:	70a2                	ld	ra,40(sp)
ffffffffc0203744:	7402                	ld	s0,32(sp)
ffffffffc0203746:	64e2                	ld	s1,24(sp)
ffffffffc0203748:	6942                	ld	s2,16(sp)
ffffffffc020374a:	69a2                	ld	s3,8(sp)
ffffffffc020374c:	6145                	addi	sp,sp,48
ffffffffc020374e:	8082                	ret
    if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && !context_init_flag && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0 && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag)
ffffffffc0203750:	73d8                	ld	a4,160(a5)
ffffffffc0203752:	f00719e3          	bnez	a4,ffffffffc0203664 <proc_init+0xa2>
ffffffffc0203756:	f00997e3          	bnez	s3,ffffffffc0203664 <proc_init+0xa2>
ffffffffc020375a:	4398                	lw	a4,0(a5)
ffffffffc020375c:	f00714e3          	bnez	a4,ffffffffc0203664 <proc_init+0xa2>
ffffffffc0203760:	43d4                	lw	a3,4(a5)
ffffffffc0203762:	577d                	li	a4,-1
ffffffffc0203764:	f0e690e3          	bne	a3,a4,ffffffffc0203664 <proc_init+0xa2>
ffffffffc0203768:	4798                	lw	a4,8(a5)
ffffffffc020376a:	ee071de3          	bnez	a4,ffffffffc0203664 <proc_init+0xa2>
ffffffffc020376e:	6b98                	ld	a4,16(a5)
ffffffffc0203770:	ee071ae3          	bnez	a4,ffffffffc0203664 <proc_init+0xa2>
ffffffffc0203774:	4f98                	lw	a4,24(a5)
ffffffffc0203776:	ee0717e3          	bnez	a4,ffffffffc0203664 <proc_init+0xa2>
ffffffffc020377a:	7398                	ld	a4,32(a5)
ffffffffc020377c:	ee0714e3          	bnez	a4,ffffffffc0203664 <proc_init+0xa2>
ffffffffc0203780:	7798                	ld	a4,40(a5)
ffffffffc0203782:	ee0711e3          	bnez	a4,ffffffffc0203664 <proc_init+0xa2>
ffffffffc0203786:	0b07a703          	lw	a4,176(a5)
ffffffffc020378a:	8f49                	or	a4,a4,a0
ffffffffc020378c:	2701                	sext.w	a4,a4
ffffffffc020378e:	ec071be3          	bnez	a4,ffffffffc0203664 <proc_init+0xa2>
        cprintf("alloc_proc() correct!\n");
ffffffffc0203792:	00002517          	auipc	a0,0x2
ffffffffc0203796:	ce650513          	addi	a0,a0,-794 # ffffffffc0205478 <etext+0x1630>
ffffffffc020379a:	9fbfc0ef          	jal	ffffffffc0200194 <cprintf>
    idleproc->pid = 0;
ffffffffc020379e:	00093783          	ld	a5,0(s2)
ffffffffc02037a2:	b5c9                	j	ffffffffc0203664 <proc_init+0xa2>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02037a4:	f2878793          	addi	a5,a5,-216
ffffffffc02037a8:	bfa1                	j	ffffffffc0203700 <proc_init+0x13e>
        panic("cannot alloc idleproc.\n");
ffffffffc02037aa:	00002617          	auipc	a2,0x2
ffffffffc02037ae:	cb660613          	addi	a2,a2,-842 # ffffffffc0205460 <etext+0x1618>
ffffffffc02037b2:	19400593          	li	a1,404
ffffffffc02037b6:	00002517          	auipc	a0,0x2
ffffffffc02037ba:	c7a50513          	addi	a0,a0,-902 # ffffffffc0205430 <etext+0x15e8>
ffffffffc02037be:	c49fc0ef          	jal	ffffffffc0200406 <__panic>
        panic("create init_main failed.\n");
ffffffffc02037c2:	00002617          	auipc	a2,0x2
ffffffffc02037c6:	ce660613          	addi	a2,a2,-794 # ffffffffc02054a8 <etext+0x1660>
ffffffffc02037ca:	1b100593          	li	a1,433
ffffffffc02037ce:	00002517          	auipc	a0,0x2
ffffffffc02037d2:	c6250513          	addi	a0,a0,-926 # ffffffffc0205430 <etext+0x15e8>
ffffffffc02037d6:	c31fc0ef          	jal	ffffffffc0200406 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02037da:	00002697          	auipc	a3,0x2
ffffffffc02037de:	d1e68693          	addi	a3,a3,-738 # ffffffffc02054f8 <etext+0x16b0>
ffffffffc02037e2:	00001617          	auipc	a2,0x1
ffffffffc02037e6:	f4660613          	addi	a2,a2,-186 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02037ea:	1b800593          	li	a1,440
ffffffffc02037ee:	00002517          	auipc	a0,0x2
ffffffffc02037f2:	c4250513          	addi	a0,a0,-958 # ffffffffc0205430 <etext+0x15e8>
ffffffffc02037f6:	c11fc0ef          	jal	ffffffffc0200406 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02037fa:	00002697          	auipc	a3,0x2
ffffffffc02037fe:	cd668693          	addi	a3,a3,-810 # ffffffffc02054d0 <etext+0x1688>
ffffffffc0203802:	00001617          	auipc	a2,0x1
ffffffffc0203806:	f2660613          	addi	a2,a2,-218 # ffffffffc0204728 <etext+0x8e0>
ffffffffc020380a:	1b700593          	li	a1,439
ffffffffc020380e:	00002517          	auipc	a0,0x2
ffffffffc0203812:	c2250513          	addi	a0,a0,-990 # ffffffffc0205430 <etext+0x15e8>
ffffffffc0203816:	bf1fc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc020381a <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc020381a:	1141                	addi	sp,sp,-16
ffffffffc020381c:	e022                	sd	s0,0(sp)
ffffffffc020381e:	e406                	sd	ra,8(sp)
ffffffffc0203820:	0000a417          	auipc	s0,0xa
ffffffffc0203824:	cc040413          	addi	s0,s0,-832 # ffffffffc020d4e0 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0203828:	6018                	ld	a4,0(s0)
ffffffffc020382a:	4f1c                	lw	a5,24(a4)
ffffffffc020382c:	dffd                	beqz	a5,ffffffffc020382a <cpu_idle+0x10>
        {
            schedule();
ffffffffc020382e:	0a2000ef          	jal	ffffffffc02038d0 <schedule>
ffffffffc0203832:	bfdd                	j	ffffffffc0203828 <cpu_idle+0xe>

ffffffffc0203834 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0203834:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0203838:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc020383c:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc020383e:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0203840:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0203844:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0203848:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc020384c:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0203850:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0203854:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0203858:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc020385c:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0203860:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0203864:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0203868:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc020386c:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0203870:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0203872:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0203874:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0203878:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc020387c:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0203880:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0203884:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0203888:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc020388c:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0203890:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0203894:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0203898:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc020389c:	8082                	ret

ffffffffc020389e <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc020389e:	411c                	lw	a5,0(a0)
ffffffffc02038a0:	4705                	li	a4,1
ffffffffc02038a2:	37f9                	addiw	a5,a5,-2
ffffffffc02038a4:	00f77563          	bgeu	a4,a5,ffffffffc02038ae <wakeup_proc+0x10>
    proc->state = PROC_RUNNABLE;
ffffffffc02038a8:	4789                	li	a5,2
ffffffffc02038aa:	c11c                	sw	a5,0(a0)
ffffffffc02038ac:	8082                	ret
wakeup_proc(struct proc_struct *proc) {
ffffffffc02038ae:	1141                	addi	sp,sp,-16
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc02038b0:	00002697          	auipc	a3,0x2
ffffffffc02038b4:	c7068693          	addi	a3,a3,-912 # ffffffffc0205520 <etext+0x16d8>
ffffffffc02038b8:	00001617          	auipc	a2,0x1
ffffffffc02038bc:	e7060613          	addi	a2,a2,-400 # ffffffffc0204728 <etext+0x8e0>
ffffffffc02038c0:	45a5                	li	a1,9
ffffffffc02038c2:	00002517          	auipc	a0,0x2
ffffffffc02038c6:	c9e50513          	addi	a0,a0,-866 # ffffffffc0205560 <etext+0x1718>
wakeup_proc(struct proc_struct *proc) {
ffffffffc02038ca:	e406                	sd	ra,8(sp)
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc02038cc:	b3bfc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc02038d0 <schedule>:
}

void
schedule(void) {
ffffffffc02038d0:	1101                	addi	sp,sp,-32
ffffffffc02038d2:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02038d4:	100027f3          	csrr	a5,sstatus
ffffffffc02038d8:	8b89                	andi	a5,a5,2
ffffffffc02038da:	4301                	li	t1,0
ffffffffc02038dc:	e3c1                	bnez	a5,ffffffffc020395c <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc02038de:	0000a897          	auipc	a7,0xa
ffffffffc02038e2:	c028b883          	ld	a7,-1022(a7) # ffffffffc020d4e0 <current>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02038e6:	0000a517          	auipc	a0,0xa
ffffffffc02038ea:	c0a53503          	ld	a0,-1014(a0) # ffffffffc020d4f0 <idleproc>
        current->need_resched = 0;
ffffffffc02038ee:	0008ac23          	sw	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02038f2:	04a88f63          	beq	a7,a0,ffffffffc0203950 <schedule+0x80>
ffffffffc02038f6:	0c888693          	addi	a3,a7,200
ffffffffc02038fa:	0000a617          	auipc	a2,0xa
ffffffffc02038fe:	b5e60613          	addi	a2,a2,-1186 # ffffffffc020d458 <proc_list>
        le = last;
ffffffffc0203902:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0203904:	4581                	li	a1,0
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
ffffffffc0203906:	4809                	li	a6,2
ffffffffc0203908:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list) {
ffffffffc020390a:	00c78863          	beq	a5,a2,ffffffffc020391a <schedule+0x4a>
                if (next->state == PROC_RUNNABLE) {
ffffffffc020390e:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc0203912:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE) {
ffffffffc0203916:	03070363          	beq	a4,a6,ffffffffc020393c <schedule+0x6c>
                    break;
                }
            }
        } while (le != last);
ffffffffc020391a:	fef697e3          	bne	a3,a5,ffffffffc0203908 <schedule+0x38>
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc020391e:	ed99                	bnez	a1,ffffffffc020393c <schedule+0x6c>
            next = idleproc;
        }
        next->runs ++;
ffffffffc0203920:	451c                	lw	a5,8(a0)
ffffffffc0203922:	2785                	addiw	a5,a5,1
ffffffffc0203924:	c51c                	sw	a5,8(a0)
        if (next != current) {
ffffffffc0203926:	00a88663          	beq	a7,a0,ffffffffc0203932 <schedule+0x62>
ffffffffc020392a:	e41a                	sd	t1,8(sp)
            proc_run(next);
ffffffffc020392c:	9b3ff0ef          	jal	ffffffffc02032de <proc_run>
ffffffffc0203930:	6322                	ld	t1,8(sp)
    if (flag) {
ffffffffc0203932:	00031b63          	bnez	t1,ffffffffc0203948 <schedule+0x78>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0203936:	60e2                	ld	ra,24(sp)
ffffffffc0203938:	6105                	addi	sp,sp,32
ffffffffc020393a:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc020393c:	4198                	lw	a4,0(a1)
ffffffffc020393e:	4789                	li	a5,2
ffffffffc0203940:	fef710e3          	bne	a4,a5,ffffffffc0203920 <schedule+0x50>
ffffffffc0203944:	852e                	mv	a0,a1
ffffffffc0203946:	bfe9                	j	ffffffffc0203920 <schedule+0x50>
}
ffffffffc0203948:	60e2                	ld	ra,24(sp)
ffffffffc020394a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020394c:	f23fc06f          	j	ffffffffc020086e <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0203950:	0000a617          	auipc	a2,0xa
ffffffffc0203954:	b0860613          	addi	a2,a2,-1272 # ffffffffc020d458 <proc_list>
ffffffffc0203958:	86b2                	mv	a3,a2
ffffffffc020395a:	b765                	j	ffffffffc0203902 <schedule+0x32>
        intr_disable();
ffffffffc020395c:	f19fc0ef          	jal	ffffffffc0200874 <intr_disable>
        return 1;
ffffffffc0203960:	4305                	li	t1,1
ffffffffc0203962:	bfb5                	j	ffffffffc02038de <schedule+0xe>

ffffffffc0203964 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0203964:	9e3707b7          	lui	a5,0x9e370
ffffffffc0203968:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <kern_entry-0x21e8ffff>
ffffffffc020396a:	02a787bb          	mulw	a5,a5,a0
    return (hash >> (32 - bits));
ffffffffc020396e:	02000513          	li	a0,32
ffffffffc0203972:	9d0d                	subw	a0,a0,a1
}
ffffffffc0203974:	00a7d53b          	srlw	a0,a5,a0
ffffffffc0203978:	8082                	ret

ffffffffc020397a <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020397a:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020397c:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203980:	f022                	sd	s0,32(sp)
ffffffffc0203982:	ec26                	sd	s1,24(sp)
ffffffffc0203984:	e84a                	sd	s2,16(sp)
ffffffffc0203986:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0203988:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020398c:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc020398e:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0203992:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203996:	84aa                	mv	s1,a0
ffffffffc0203998:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc020399a:	03067d63          	bgeu	a2,a6,ffffffffc02039d4 <printnum+0x5a>
ffffffffc020399e:	e44e                	sd	s3,8(sp)
ffffffffc02039a0:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02039a2:	4785                	li	a5,1
ffffffffc02039a4:	00e7d763          	bge	a5,a4,ffffffffc02039b2 <printnum+0x38>
            putch(padc, putdat);
ffffffffc02039a8:	85ca                	mv	a1,s2
ffffffffc02039aa:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc02039ac:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02039ae:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02039b0:	fc65                	bnez	s0,ffffffffc02039a8 <printnum+0x2e>
ffffffffc02039b2:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02039b4:	00002797          	auipc	a5,0x2
ffffffffc02039b8:	bc478793          	addi	a5,a5,-1084 # ffffffffc0205578 <etext+0x1730>
ffffffffc02039bc:	97d2                	add	a5,a5,s4
}
ffffffffc02039be:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02039c0:	0007c503          	lbu	a0,0(a5)
}
ffffffffc02039c4:	70a2                	ld	ra,40(sp)
ffffffffc02039c6:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02039c8:	85ca                	mv	a1,s2
ffffffffc02039ca:	87a6                	mv	a5,s1
}
ffffffffc02039cc:	6942                	ld	s2,16(sp)
ffffffffc02039ce:	64e2                	ld	s1,24(sp)
ffffffffc02039d0:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02039d2:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02039d4:	03065633          	divu	a2,a2,a6
ffffffffc02039d8:	8722                	mv	a4,s0
ffffffffc02039da:	fa1ff0ef          	jal	ffffffffc020397a <printnum>
ffffffffc02039de:	bfd9                	j	ffffffffc02039b4 <printnum+0x3a>

ffffffffc02039e0 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02039e0:	7119                	addi	sp,sp,-128
ffffffffc02039e2:	f4a6                	sd	s1,104(sp)
ffffffffc02039e4:	f0ca                	sd	s2,96(sp)
ffffffffc02039e6:	ecce                	sd	s3,88(sp)
ffffffffc02039e8:	e8d2                	sd	s4,80(sp)
ffffffffc02039ea:	e4d6                	sd	s5,72(sp)
ffffffffc02039ec:	e0da                	sd	s6,64(sp)
ffffffffc02039ee:	f862                	sd	s8,48(sp)
ffffffffc02039f0:	fc86                	sd	ra,120(sp)
ffffffffc02039f2:	f8a2                	sd	s0,112(sp)
ffffffffc02039f4:	fc5e                	sd	s7,56(sp)
ffffffffc02039f6:	f466                	sd	s9,40(sp)
ffffffffc02039f8:	f06a                	sd	s10,32(sp)
ffffffffc02039fa:	ec6e                	sd	s11,24(sp)
ffffffffc02039fc:	84aa                	mv	s1,a0
ffffffffc02039fe:	8c32                	mv	s8,a2
ffffffffc0203a00:	8a36                	mv	s4,a3
ffffffffc0203a02:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203a04:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203a08:	05500b13          	li	s6,85
ffffffffc0203a0c:	00002a97          	auipc	s5,0x2
ffffffffc0203a10:	ccca8a93          	addi	s5,s5,-820 # ffffffffc02056d8 <default_pmm_manager+0x38>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203a14:	000c4503          	lbu	a0,0(s8)
ffffffffc0203a18:	001c0413          	addi	s0,s8,1
ffffffffc0203a1c:	01350a63          	beq	a0,s3,ffffffffc0203a30 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0203a20:	cd0d                	beqz	a0,ffffffffc0203a5a <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0203a22:	85ca                	mv	a1,s2
ffffffffc0203a24:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203a26:	00044503          	lbu	a0,0(s0)
ffffffffc0203a2a:	0405                	addi	s0,s0,1
ffffffffc0203a2c:	ff351ae3          	bne	a0,s3,ffffffffc0203a20 <vprintfmt+0x40>
        width = precision = -1;
ffffffffc0203a30:	5cfd                	li	s9,-1
ffffffffc0203a32:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc0203a34:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc0203a38:	4b81                	li	s7,0
ffffffffc0203a3a:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203a3c:	00044683          	lbu	a3,0(s0)
ffffffffc0203a40:	00140c13          	addi	s8,s0,1
ffffffffc0203a44:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0203a48:	0ff5f593          	zext.b	a1,a1
ffffffffc0203a4c:	02bb6663          	bltu	s6,a1,ffffffffc0203a78 <vprintfmt+0x98>
ffffffffc0203a50:	058a                	slli	a1,a1,0x2
ffffffffc0203a52:	95d6                	add	a1,a1,s5
ffffffffc0203a54:	4198                	lw	a4,0(a1)
ffffffffc0203a56:	9756                	add	a4,a4,s5
ffffffffc0203a58:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0203a5a:	70e6                	ld	ra,120(sp)
ffffffffc0203a5c:	7446                	ld	s0,112(sp)
ffffffffc0203a5e:	74a6                	ld	s1,104(sp)
ffffffffc0203a60:	7906                	ld	s2,96(sp)
ffffffffc0203a62:	69e6                	ld	s3,88(sp)
ffffffffc0203a64:	6a46                	ld	s4,80(sp)
ffffffffc0203a66:	6aa6                	ld	s5,72(sp)
ffffffffc0203a68:	6b06                	ld	s6,64(sp)
ffffffffc0203a6a:	7be2                	ld	s7,56(sp)
ffffffffc0203a6c:	7c42                	ld	s8,48(sp)
ffffffffc0203a6e:	7ca2                	ld	s9,40(sp)
ffffffffc0203a70:	7d02                	ld	s10,32(sp)
ffffffffc0203a72:	6de2                	ld	s11,24(sp)
ffffffffc0203a74:	6109                	addi	sp,sp,128
ffffffffc0203a76:	8082                	ret
            putch('%', putdat);
ffffffffc0203a78:	85ca                	mv	a1,s2
ffffffffc0203a7a:	02500513          	li	a0,37
ffffffffc0203a7e:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0203a80:	fff44783          	lbu	a5,-1(s0)
ffffffffc0203a84:	02500713          	li	a4,37
ffffffffc0203a88:	8c22                	mv	s8,s0
ffffffffc0203a8a:	f8e785e3          	beq	a5,a4,ffffffffc0203a14 <vprintfmt+0x34>
ffffffffc0203a8e:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0203a92:	1c7d                	addi	s8,s8,-1
ffffffffc0203a94:	fee79de3          	bne	a5,a4,ffffffffc0203a8e <vprintfmt+0xae>
ffffffffc0203a98:	bfb5                	j	ffffffffc0203a14 <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0203a9a:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0203a9e:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc0203aa0:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc0203aa4:	fd06071b          	addiw	a4,a2,-48
ffffffffc0203aa8:	24e56a63          	bltu	a0,a4,ffffffffc0203cfc <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc0203aac:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203aae:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc0203ab0:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc0203ab4:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0203ab8:	0197073b          	addw	a4,a4,s9
ffffffffc0203abc:	0017171b          	slliw	a4,a4,0x1
ffffffffc0203ac0:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc0203ac2:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0203ac6:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0203ac8:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0203acc:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc0203ad0:	feb570e3          	bgeu	a0,a1,ffffffffc0203ab0 <vprintfmt+0xd0>
            if (width < 0)
ffffffffc0203ad4:	f60d54e3          	bgez	s10,ffffffffc0203a3c <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0203ad8:	8d66                	mv	s10,s9
ffffffffc0203ada:	5cfd                	li	s9,-1
ffffffffc0203adc:	b785                	j	ffffffffc0203a3c <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203ade:	8db6                	mv	s11,a3
ffffffffc0203ae0:	8462                	mv	s0,s8
ffffffffc0203ae2:	bfa9                	j	ffffffffc0203a3c <vprintfmt+0x5c>
ffffffffc0203ae4:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0203ae6:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0203ae8:	bf91                	j	ffffffffc0203a3c <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0203aea:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203aec:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203af0:	00f74463          	blt	a4,a5,ffffffffc0203af8 <vprintfmt+0x118>
    else if (lflag) {
ffffffffc0203af4:	1a078763          	beqz	a5,ffffffffc0203ca2 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0203af8:	000a3603          	ld	a2,0(s4)
ffffffffc0203afc:	46c1                	li	a3,16
ffffffffc0203afe:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0203b00:	000d879b          	sext.w	a5,s11
ffffffffc0203b04:	876a                	mv	a4,s10
ffffffffc0203b06:	85ca                	mv	a1,s2
ffffffffc0203b08:	8526                	mv	a0,s1
ffffffffc0203b0a:	e71ff0ef          	jal	ffffffffc020397a <printnum>
            break;
ffffffffc0203b0e:	b719                	j	ffffffffc0203a14 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0203b10:	000a2503          	lw	a0,0(s4)
ffffffffc0203b14:	85ca                	mv	a1,s2
ffffffffc0203b16:	0a21                	addi	s4,s4,8
ffffffffc0203b18:	9482                	jalr	s1
            break;
ffffffffc0203b1a:	bded                	j	ffffffffc0203a14 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0203b1c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203b1e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203b22:	00f74463          	blt	a4,a5,ffffffffc0203b2a <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0203b26:	16078963          	beqz	a5,ffffffffc0203c98 <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc0203b2a:	000a3603          	ld	a2,0(s4)
ffffffffc0203b2e:	46a9                	li	a3,10
ffffffffc0203b30:	8a2e                	mv	s4,a1
ffffffffc0203b32:	b7f9                	j	ffffffffc0203b00 <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc0203b34:	85ca                	mv	a1,s2
ffffffffc0203b36:	03000513          	li	a0,48
ffffffffc0203b3a:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc0203b3c:	85ca                	mv	a1,s2
ffffffffc0203b3e:	07800513          	li	a0,120
ffffffffc0203b42:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203b44:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc0203b48:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203b4a:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0203b4c:	bf55                	j	ffffffffc0203b00 <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc0203b4e:	85ca                	mv	a1,s2
ffffffffc0203b50:	02500513          	li	a0,37
ffffffffc0203b54:	9482                	jalr	s1
            break;
ffffffffc0203b56:	bd7d                	j	ffffffffc0203a14 <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc0203b58:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b5c:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc0203b5e:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc0203b60:	bf95                	j	ffffffffc0203ad4 <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc0203b62:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203b64:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203b68:	00f74463          	blt	a4,a5,ffffffffc0203b70 <vprintfmt+0x190>
    else if (lflag) {
ffffffffc0203b6c:	12078163          	beqz	a5,ffffffffc0203c8e <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc0203b70:	000a3603          	ld	a2,0(s4)
ffffffffc0203b74:	46a1                	li	a3,8
ffffffffc0203b76:	8a2e                	mv	s4,a1
ffffffffc0203b78:	b761                	j	ffffffffc0203b00 <vprintfmt+0x120>
            if (width < 0)
ffffffffc0203b7a:	876a                	mv	a4,s10
ffffffffc0203b7c:	000d5363          	bgez	s10,ffffffffc0203b82 <vprintfmt+0x1a2>
ffffffffc0203b80:	4701                	li	a4,0
ffffffffc0203b82:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b86:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0203b88:	bd55                	j	ffffffffc0203a3c <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc0203b8a:	000d841b          	sext.w	s0,s11
ffffffffc0203b8e:	fd340793          	addi	a5,s0,-45
ffffffffc0203b92:	00f037b3          	snez	a5,a5
ffffffffc0203b96:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203b9a:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc0203b9e:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203ba0:	008a0793          	addi	a5,s4,8
ffffffffc0203ba4:	e43e                	sd	a5,8(sp)
ffffffffc0203ba6:	100d8c63          	beqz	s11,ffffffffc0203cbe <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0203baa:	12071363          	bnez	a4,ffffffffc0203cd0 <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203bae:	000dc783          	lbu	a5,0(s11)
ffffffffc0203bb2:	0007851b          	sext.w	a0,a5
ffffffffc0203bb6:	c78d                	beqz	a5,ffffffffc0203be0 <vprintfmt+0x200>
ffffffffc0203bb8:	0d85                	addi	s11,s11,1
ffffffffc0203bba:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203bbc:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203bc0:	000cc563          	bltz	s9,ffffffffc0203bca <vprintfmt+0x1ea>
ffffffffc0203bc4:	3cfd                	addiw	s9,s9,-1
ffffffffc0203bc6:	008c8d63          	beq	s9,s0,ffffffffc0203be0 <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203bca:	020b9663          	bnez	s7,ffffffffc0203bf6 <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc0203bce:	85ca                	mv	a1,s2
ffffffffc0203bd0:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203bd2:	000dc783          	lbu	a5,0(s11)
ffffffffc0203bd6:	0d85                	addi	s11,s11,1
ffffffffc0203bd8:	3d7d                	addiw	s10,s10,-1
ffffffffc0203bda:	0007851b          	sext.w	a0,a5
ffffffffc0203bde:	f3ed                	bnez	a5,ffffffffc0203bc0 <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc0203be0:	01a05963          	blez	s10,ffffffffc0203bf2 <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc0203be4:	85ca                	mv	a1,s2
ffffffffc0203be6:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0203bea:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc0203bec:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc0203bee:	fe0d1be3          	bnez	s10,ffffffffc0203be4 <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203bf2:	6a22                	ld	s4,8(sp)
ffffffffc0203bf4:	b505                	j	ffffffffc0203a14 <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203bf6:	3781                	addiw	a5,a5,-32
ffffffffc0203bf8:	fcfa7be3          	bgeu	s4,a5,ffffffffc0203bce <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc0203bfc:	03f00513          	li	a0,63
ffffffffc0203c00:	85ca                	mv	a1,s2
ffffffffc0203c02:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203c04:	000dc783          	lbu	a5,0(s11)
ffffffffc0203c08:	0d85                	addi	s11,s11,1
ffffffffc0203c0a:	3d7d                	addiw	s10,s10,-1
ffffffffc0203c0c:	0007851b          	sext.w	a0,a5
ffffffffc0203c10:	dbe1                	beqz	a5,ffffffffc0203be0 <vprintfmt+0x200>
ffffffffc0203c12:	fa0cd9e3          	bgez	s9,ffffffffc0203bc4 <vprintfmt+0x1e4>
ffffffffc0203c16:	b7c5                	j	ffffffffc0203bf6 <vprintfmt+0x216>
            if (err < 0) {
ffffffffc0203c18:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203c1c:	4619                	li	a2,6
            err = va_arg(ap, int);
ffffffffc0203c1e:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0203c20:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0203c24:	8fb9                	xor	a5,a5,a4
ffffffffc0203c26:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203c2a:	02d64563          	blt	a2,a3,ffffffffc0203c54 <vprintfmt+0x274>
ffffffffc0203c2e:	00002797          	auipc	a5,0x2
ffffffffc0203c32:	c0278793          	addi	a5,a5,-1022 # ffffffffc0205830 <error_string>
ffffffffc0203c36:	00369713          	slli	a4,a3,0x3
ffffffffc0203c3a:	97ba                	add	a5,a5,a4
ffffffffc0203c3c:	639c                	ld	a5,0(a5)
ffffffffc0203c3e:	cb99                	beqz	a5,ffffffffc0203c54 <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc0203c40:	86be                	mv	a3,a5
ffffffffc0203c42:	00000617          	auipc	a2,0x0
ffffffffc0203c46:	22e60613          	addi	a2,a2,558 # ffffffffc0203e70 <etext+0x28>
ffffffffc0203c4a:	85ca                	mv	a1,s2
ffffffffc0203c4c:	8526                	mv	a0,s1
ffffffffc0203c4e:	0d8000ef          	jal	ffffffffc0203d26 <printfmt>
ffffffffc0203c52:	b3c9                	j	ffffffffc0203a14 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0203c54:	00002617          	auipc	a2,0x2
ffffffffc0203c58:	94460613          	addi	a2,a2,-1724 # ffffffffc0205598 <etext+0x1750>
ffffffffc0203c5c:	85ca                	mv	a1,s2
ffffffffc0203c5e:	8526                	mv	a0,s1
ffffffffc0203c60:	0c6000ef          	jal	ffffffffc0203d26 <printfmt>
ffffffffc0203c64:	bb45                	j	ffffffffc0203a14 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0203c66:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203c68:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc0203c6c:	00f74363          	blt	a4,a5,ffffffffc0203c72 <vprintfmt+0x292>
    else if (lflag) {
ffffffffc0203c70:	cf81                	beqz	a5,ffffffffc0203c88 <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc0203c72:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0203c76:	02044b63          	bltz	s0,ffffffffc0203cac <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc0203c7a:	8622                	mv	a2,s0
ffffffffc0203c7c:	8a5e                	mv	s4,s7
ffffffffc0203c7e:	46a9                	li	a3,10
ffffffffc0203c80:	b541                	j	ffffffffc0203b00 <vprintfmt+0x120>
            lflag ++;
ffffffffc0203c82:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c84:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0203c86:	bb5d                	j	ffffffffc0203a3c <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc0203c88:	000a2403          	lw	s0,0(s4)
ffffffffc0203c8c:	b7ed                	j	ffffffffc0203c76 <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc0203c8e:	000a6603          	lwu	a2,0(s4)
ffffffffc0203c92:	46a1                	li	a3,8
ffffffffc0203c94:	8a2e                	mv	s4,a1
ffffffffc0203c96:	b5ad                	j	ffffffffc0203b00 <vprintfmt+0x120>
ffffffffc0203c98:	000a6603          	lwu	a2,0(s4)
ffffffffc0203c9c:	46a9                	li	a3,10
ffffffffc0203c9e:	8a2e                	mv	s4,a1
ffffffffc0203ca0:	b585                	j	ffffffffc0203b00 <vprintfmt+0x120>
ffffffffc0203ca2:	000a6603          	lwu	a2,0(s4)
ffffffffc0203ca6:	46c1                	li	a3,16
ffffffffc0203ca8:	8a2e                	mv	s4,a1
ffffffffc0203caa:	bd99                	j	ffffffffc0203b00 <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc0203cac:	85ca                	mv	a1,s2
ffffffffc0203cae:	02d00513          	li	a0,45
ffffffffc0203cb2:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc0203cb4:	40800633          	neg	a2,s0
ffffffffc0203cb8:	8a5e                	mv	s4,s7
ffffffffc0203cba:	46a9                	li	a3,10
ffffffffc0203cbc:	b591                	j	ffffffffc0203b00 <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc0203cbe:	e329                	bnez	a4,ffffffffc0203d00 <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203cc0:	02800793          	li	a5,40
ffffffffc0203cc4:	853e                	mv	a0,a5
ffffffffc0203cc6:	00002d97          	auipc	s11,0x2
ffffffffc0203cca:	8cbd8d93          	addi	s11,s11,-1845 # ffffffffc0205591 <etext+0x1749>
ffffffffc0203cce:	b5f5                	j	ffffffffc0203bba <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203cd0:	85e6                	mv	a1,s9
ffffffffc0203cd2:	856e                	mv	a0,s11
ffffffffc0203cd4:	08a000ef          	jal	ffffffffc0203d5e <strnlen>
ffffffffc0203cd8:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0203cdc:	01a05863          	blez	s10,ffffffffc0203cec <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc0203ce0:	85ca                	mv	a1,s2
ffffffffc0203ce2:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203ce4:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc0203ce6:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203ce8:	fe0d1ce3          	bnez	s10,ffffffffc0203ce0 <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203cec:	000dc783          	lbu	a5,0(s11)
ffffffffc0203cf0:	0007851b          	sext.w	a0,a5
ffffffffc0203cf4:	ec0792e3          	bnez	a5,ffffffffc0203bb8 <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203cf8:	6a22                	ld	s4,8(sp)
ffffffffc0203cfa:	bb29                	j	ffffffffc0203a14 <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203cfc:	8462                	mv	s0,s8
ffffffffc0203cfe:	bbd9                	j	ffffffffc0203ad4 <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203d00:	85e6                	mv	a1,s9
ffffffffc0203d02:	00002517          	auipc	a0,0x2
ffffffffc0203d06:	88e50513          	addi	a0,a0,-1906 # ffffffffc0205590 <etext+0x1748>
ffffffffc0203d0a:	054000ef          	jal	ffffffffc0203d5e <strnlen>
ffffffffc0203d0e:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203d12:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0203d16:	00002d97          	auipc	s11,0x2
ffffffffc0203d1a:	87ad8d93          	addi	s11,s11,-1926 # ffffffffc0205590 <etext+0x1748>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203d1e:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203d20:	fda040e3          	bgtz	s10,ffffffffc0203ce0 <vprintfmt+0x300>
ffffffffc0203d24:	bd51                	j	ffffffffc0203bb8 <vprintfmt+0x1d8>

ffffffffc0203d26 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203d26:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0203d28:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203d2c:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0203d2e:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203d30:	ec06                	sd	ra,24(sp)
ffffffffc0203d32:	f83a                	sd	a4,48(sp)
ffffffffc0203d34:	fc3e                	sd	a5,56(sp)
ffffffffc0203d36:	e0c2                	sd	a6,64(sp)
ffffffffc0203d38:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0203d3a:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0203d3c:	ca5ff0ef          	jal	ffffffffc02039e0 <vprintfmt>
}
ffffffffc0203d40:	60e2                	ld	ra,24(sp)
ffffffffc0203d42:	6161                	addi	sp,sp,80
ffffffffc0203d44:	8082                	ret

ffffffffc0203d46 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0203d46:	00054783          	lbu	a5,0(a0)
ffffffffc0203d4a:	cb81                	beqz	a5,ffffffffc0203d5a <strlen+0x14>
    size_t cnt = 0;
ffffffffc0203d4c:	4781                	li	a5,0
        cnt ++;
ffffffffc0203d4e:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc0203d50:	00f50733          	add	a4,a0,a5
ffffffffc0203d54:	00074703          	lbu	a4,0(a4)
ffffffffc0203d58:	fb7d                	bnez	a4,ffffffffc0203d4e <strlen+0x8>
    }
    return cnt;
}
ffffffffc0203d5a:	853e                	mv	a0,a5
ffffffffc0203d5c:	8082                	ret

ffffffffc0203d5e <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0203d5e:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203d60:	e589                	bnez	a1,ffffffffc0203d6a <strnlen+0xc>
ffffffffc0203d62:	a811                	j	ffffffffc0203d76 <strnlen+0x18>
        cnt ++;
ffffffffc0203d64:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203d66:	00f58863          	beq	a1,a5,ffffffffc0203d76 <strnlen+0x18>
ffffffffc0203d6a:	00f50733          	add	a4,a0,a5
ffffffffc0203d6e:	00074703          	lbu	a4,0(a4)
ffffffffc0203d72:	fb6d                	bnez	a4,ffffffffc0203d64 <strnlen+0x6>
ffffffffc0203d74:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0203d76:	852e                	mv	a0,a1
ffffffffc0203d78:	8082                	ret

ffffffffc0203d7a <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0203d7a:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0203d7c:	0005c703          	lbu	a4,0(a1)
ffffffffc0203d80:	0585                	addi	a1,a1,1
ffffffffc0203d82:	0785                	addi	a5,a5,1
ffffffffc0203d84:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0203d88:	fb75                	bnez	a4,ffffffffc0203d7c <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0203d8a:	8082                	ret

ffffffffc0203d8c <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203d8c:	00054783          	lbu	a5,0(a0)
ffffffffc0203d90:	e791                	bnez	a5,ffffffffc0203d9c <strcmp+0x10>
ffffffffc0203d92:	a01d                	j	ffffffffc0203db8 <strcmp+0x2c>
ffffffffc0203d94:	00054783          	lbu	a5,0(a0)
ffffffffc0203d98:	cb99                	beqz	a5,ffffffffc0203dae <strcmp+0x22>
ffffffffc0203d9a:	0585                	addi	a1,a1,1
ffffffffc0203d9c:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0203da0:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203da2:	fef709e3          	beq	a4,a5,ffffffffc0203d94 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203da6:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0203daa:	9d19                	subw	a0,a0,a4
ffffffffc0203dac:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203dae:	0015c703          	lbu	a4,1(a1)
ffffffffc0203db2:	4501                	li	a0,0
}
ffffffffc0203db4:	9d19                	subw	a0,a0,a4
ffffffffc0203db6:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203db8:	0005c703          	lbu	a4,0(a1)
ffffffffc0203dbc:	4501                	li	a0,0
ffffffffc0203dbe:	b7f5                	j	ffffffffc0203daa <strcmp+0x1e>

ffffffffc0203dc0 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203dc0:	ce01                	beqz	a2,ffffffffc0203dd8 <strncmp+0x18>
ffffffffc0203dc2:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0203dc6:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203dc8:	cb91                	beqz	a5,ffffffffc0203ddc <strncmp+0x1c>
ffffffffc0203dca:	0005c703          	lbu	a4,0(a1)
ffffffffc0203dce:	00f71763          	bne	a4,a5,ffffffffc0203ddc <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc0203dd2:	0505                	addi	a0,a0,1
ffffffffc0203dd4:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203dd6:	f675                	bnez	a2,ffffffffc0203dc2 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203dd8:	4501                	li	a0,0
ffffffffc0203dda:	8082                	ret
ffffffffc0203ddc:	00054503          	lbu	a0,0(a0)
ffffffffc0203de0:	0005c783          	lbu	a5,0(a1)
ffffffffc0203de4:	9d1d                	subw	a0,a0,a5
}
ffffffffc0203de6:	8082                	ret

ffffffffc0203de8 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0203de8:	a021                	j	ffffffffc0203df0 <strchr+0x8>
        if (*s == c) {
ffffffffc0203dea:	00f58763          	beq	a1,a5,ffffffffc0203df8 <strchr+0x10>
            return (char *)s;
        }
        s ++;
ffffffffc0203dee:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0203df0:	00054783          	lbu	a5,0(a0)
ffffffffc0203df4:	fbfd                	bnez	a5,ffffffffc0203dea <strchr+0x2>
    }
    return NULL;
ffffffffc0203df6:	4501                	li	a0,0
}
ffffffffc0203df8:	8082                	ret

ffffffffc0203dfa <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0203dfa:	ca01                	beqz	a2,ffffffffc0203e0a <memset+0x10>
ffffffffc0203dfc:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0203dfe:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0203e00:	0785                	addi	a5,a5,1
ffffffffc0203e02:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0203e06:	fef61de3          	bne	a2,a5,ffffffffc0203e00 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0203e0a:	8082                	ret

ffffffffc0203e0c <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0203e0c:	ca19                	beqz	a2,ffffffffc0203e22 <memcpy+0x16>
ffffffffc0203e0e:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0203e10:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0203e12:	0005c703          	lbu	a4,0(a1)
ffffffffc0203e16:	0585                	addi	a1,a1,1
ffffffffc0203e18:	0785                	addi	a5,a5,1
ffffffffc0203e1a:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0203e1e:	feb61ae3          	bne	a2,a1,ffffffffc0203e12 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0203e22:	8082                	ret

ffffffffc0203e24 <memcmp>:
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
ffffffffc0203e24:	c205                	beqz	a2,ffffffffc0203e44 <memcmp+0x20>
ffffffffc0203e26:	962a                	add	a2,a2,a0
ffffffffc0203e28:	a019                	j	ffffffffc0203e2e <memcmp+0xa>
ffffffffc0203e2a:	00c50d63          	beq	a0,a2,ffffffffc0203e44 <memcmp+0x20>
        if (*s1 != *s2) {
ffffffffc0203e2e:	00054783          	lbu	a5,0(a0)
ffffffffc0203e32:	0005c703          	lbu	a4,0(a1)
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
ffffffffc0203e36:	0505                	addi	a0,a0,1
ffffffffc0203e38:	0585                	addi	a1,a1,1
        if (*s1 != *s2) {
ffffffffc0203e3a:	fee788e3          	beq	a5,a4,ffffffffc0203e2a <memcmp+0x6>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203e3e:	40e7853b          	subw	a0,a5,a4
ffffffffc0203e42:	8082                	ret
    }
    return 0;
ffffffffc0203e44:	4501                	li	a0,0
}
ffffffffc0203e46:	8082                	ret
