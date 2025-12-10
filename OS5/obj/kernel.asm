
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
ffffffffc020004a:	00097517          	auipc	a0,0x97
ffffffffc020004e:	1c650513          	addi	a0,a0,454 # ffffffffc0297210 <buf>
ffffffffc0200052:	0009b617          	auipc	a2,0x9b
ffffffffc0200056:	66660613          	addi	a2,a2,1638 # ffffffffc029b6b8 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc0209ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	005050ef          	jal	ffffffffc0205866 <memset>
    dtb_init();
ffffffffc0200066:	552000ef          	jal	ffffffffc02005b8 <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	4dc000ef          	jal	ffffffffc0200546 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00006597          	auipc	a1,0x6
ffffffffc0200072:	82258593          	addi	a1,a1,-2014 # ffffffffc0205890 <etext>
ffffffffc0200076:	00006517          	auipc	a0,0x6
ffffffffc020007a:	83a50513          	addi	a0,a0,-1990 # ffffffffc02058b0 <etext+0x20>
ffffffffc020007e:	116000ef          	jal	ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	1a4000ef          	jal	ffffffffc0200226 <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	714020ef          	jal	ffffffffc020279a <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	081000ef          	jal	ffffffffc020090a <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	07f000ef          	jal	ffffffffc020090c <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	257030ef          	jal	ffffffffc0203ae8 <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	71b040ef          	jal	ffffffffc0204fb0 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	45a000ef          	jal	ffffffffc02004f4 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	061000ef          	jal	ffffffffc02008fe <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	0ae050ef          	jal	ffffffffc0205150 <cpu_idle>

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
ffffffffc02000ba:	80250513          	addi	a0,a0,-2046 # ffffffffc02058b8 <etext+0x28>
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
ffffffffc02000c6:	00097997          	auipc	s3,0x97
ffffffffc02000ca:	14a98993          	addi	s3,s3,330 # ffffffffc0297210 <buf>
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
ffffffffc0200140:	00097517          	auipc	a0,0x97
ffffffffc0200144:	0d050513          	addi	a0,a0,208 # ffffffffc0297210 <buf>
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
ffffffffc0200188:	2c4050ef          	jal	ffffffffc020544c <vprintfmt>
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
ffffffffc02001bc:	290050ef          	jal	ffffffffc020544c <vprintfmt>
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
ffffffffc0200228:	00005517          	auipc	a0,0x5
ffffffffc020022c:	69850513          	addi	a0,a0,1688 # ffffffffc02058c0 <etext+0x30>
{
ffffffffc0200230:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200232:	f63ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200236:	00000597          	auipc	a1,0x0
ffffffffc020023a:	e1458593          	addi	a1,a1,-492 # ffffffffc020004a <kern_init>
ffffffffc020023e:	00005517          	auipc	a0,0x5
ffffffffc0200242:	6a250513          	addi	a0,a0,1698 # ffffffffc02058e0 <etext+0x50>
ffffffffc0200246:	f4fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020024a:	00005597          	auipc	a1,0x5
ffffffffc020024e:	64658593          	addi	a1,a1,1606 # ffffffffc0205890 <etext>
ffffffffc0200252:	00005517          	auipc	a0,0x5
ffffffffc0200256:	6ae50513          	addi	a0,a0,1710 # ffffffffc0205900 <etext+0x70>
ffffffffc020025a:	f3bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc020025e:	00097597          	auipc	a1,0x97
ffffffffc0200262:	fb258593          	addi	a1,a1,-78 # ffffffffc0297210 <buf>
ffffffffc0200266:	00005517          	auipc	a0,0x5
ffffffffc020026a:	6ba50513          	addi	a0,a0,1722 # ffffffffc0205920 <etext+0x90>
ffffffffc020026e:	f27ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200272:	0009b597          	auipc	a1,0x9b
ffffffffc0200276:	44658593          	addi	a1,a1,1094 # ffffffffc029b6b8 <end>
ffffffffc020027a:	00005517          	auipc	a0,0x5
ffffffffc020027e:	6c650513          	addi	a0,a0,1734 # ffffffffc0205940 <etext+0xb0>
ffffffffc0200282:	f13ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200286:	00000717          	auipc	a4,0x0
ffffffffc020028a:	dc470713          	addi	a4,a4,-572 # ffffffffc020004a <kern_init>
ffffffffc020028e:	0009c797          	auipc	a5,0x9c
ffffffffc0200292:	82978793          	addi	a5,a5,-2007 # ffffffffc029bab7 <end+0x3ff>
ffffffffc0200296:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200298:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc020029c:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020029e:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002a2:	95be                	add	a1,a1,a5
ffffffffc02002a4:	85a9                	srai	a1,a1,0xa
ffffffffc02002a6:	00005517          	auipc	a0,0x5
ffffffffc02002aa:	6ba50513          	addi	a0,a0,1722 # ffffffffc0205960 <etext+0xd0>
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
ffffffffc02002b4:	00005617          	auipc	a2,0x5
ffffffffc02002b8:	6dc60613          	addi	a2,a2,1756 # ffffffffc0205990 <etext+0x100>
ffffffffc02002bc:	04f00593          	li	a1,79
ffffffffc02002c0:	00005517          	auipc	a0,0x5
ffffffffc02002c4:	6e850513          	addi	a0,a0,1768 # ffffffffc02059a8 <etext+0x118>
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
ffffffffc02002da:	30a40413          	addi	s0,s0,778 # ffffffffc02075e0 <commands>
ffffffffc02002de:	00007497          	auipc	s1,0x7
ffffffffc02002e2:	34a48493          	addi	s1,s1,842 # ffffffffc0207628 <commands+0x48>
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e6:	6410                	ld	a2,8(s0)
ffffffffc02002e8:	600c                	ld	a1,0(s0)
ffffffffc02002ea:	00005517          	auipc	a0,0x5
ffffffffc02002ee:	6d650513          	addi	a0,a0,1750 # ffffffffc02059c0 <etext+0x130>
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
ffffffffc020032e:	00005517          	auipc	a0,0x5
ffffffffc0200332:	6a250513          	addi	a0,a0,1698 # ffffffffc02059d0 <etext+0x140>
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
ffffffffc0200346:	00005517          	auipc	a0,0x5
ffffffffc020034a:	6b250513          	addi	a0,a0,1714 # ffffffffc02059f8 <etext+0x168>
ffffffffc020034e:	e47ff0ef          	jal	ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc0200352:	000a0563          	beqz	s4,ffffffffc020035c <kmonitor+0x34>
        print_trapframe(tf);
ffffffffc0200356:	8552                	mv	a0,s4
ffffffffc0200358:	79c000ef          	jal	ffffffffc0200af4 <print_trapframe>
ffffffffc020035c:	00007a97          	auipc	s5,0x7
ffffffffc0200360:	284a8a93          	addi	s5,s5,644 # ffffffffc02075e0 <commands>
        if (argc == MAXARGS - 1)
ffffffffc0200364:	49bd                	li	s3,15
        if ((buf = readline("K> ")) != NULL)
ffffffffc0200366:	00005517          	auipc	a0,0x5
ffffffffc020036a:	6ba50513          	addi	a0,a0,1722 # ffffffffc0205a20 <etext+0x190>
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
ffffffffc0200388:	25c48493          	addi	s1,s1,604 # ffffffffc02075e0 <commands>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc020038c:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc020038e:	6582                	ld	a1,0(sp)
ffffffffc0200390:	6088                	ld	a0,0(s1)
ffffffffc0200392:	466050ef          	jal	ffffffffc02057f8 <strcmp>
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
ffffffffc02003a4:	00005517          	auipc	a0,0x5
ffffffffc02003a8:	6ac50513          	addi	a0,a0,1708 # ffffffffc0205a50 <etext+0x1c0>
ffffffffc02003ac:	de9ff0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
ffffffffc02003b0:	bf5d                	j	ffffffffc0200366 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003b2:	00005517          	auipc	a0,0x5
ffffffffc02003b6:	67650513          	addi	a0,a0,1654 # ffffffffc0205a28 <etext+0x198>
ffffffffc02003ba:	49a050ef          	jal	ffffffffc0205854 <strchr>
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
ffffffffc02003f4:	00005517          	auipc	a0,0x5
ffffffffc02003f8:	63450513          	addi	a0,a0,1588 # ffffffffc0205a28 <etext+0x198>
ffffffffc02003fc:	458050ef          	jal	ffffffffc0205854 <strchr>
ffffffffc0200400:	d575                	beqz	a0,ffffffffc02003ec <kmonitor+0xc4>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200402:	00044583          	lbu	a1,0(s0)
ffffffffc0200406:	dda5                	beqz	a1,ffffffffc020037e <kmonitor+0x56>
ffffffffc0200408:	b76d                	j	ffffffffc02003b2 <kmonitor+0x8a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020040a:	45c1                	li	a1,16
ffffffffc020040c:	00005517          	auipc	a0,0x5
ffffffffc0200410:	62450513          	addi	a0,a0,1572 # ffffffffc0205a30 <etext+0x1a0>
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
ffffffffc0200446:	0009b317          	auipc	t1,0x9b
ffffffffc020044a:	1f233303          	ld	t1,498(t1) # ffffffffc029b638 <is_panic>
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
ffffffffc020046c:	00005517          	auipc	a0,0x5
ffffffffc0200470:	68c50513          	addi	a0,a0,1676 # ffffffffc0205af8 <etext+0x268>
    is_panic = 1;
ffffffffc0200474:	0009b697          	auipc	a3,0x9b
ffffffffc0200478:	1ce6b223          	sd	a4,452(a3) # ffffffffc029b638 <is_panic>
    va_start(ap, fmt);
ffffffffc020047c:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020047e:	d17ff0ef          	jal	ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200482:	65a2                	ld	a1,8(sp)
ffffffffc0200484:	8522                	mv	a0,s0
ffffffffc0200486:	cefff0ef          	jal	ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc020048a:	00005517          	auipc	a0,0x5
ffffffffc020048e:	68e50513          	addi	a0,a0,1678 # ffffffffc0205b18 <etext+0x288>
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
ffffffffc02004be:	00005517          	auipc	a0,0x5
ffffffffc02004c2:	66250513          	addi	a0,a0,1634 # ffffffffc0205b20 <etext+0x290>
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
ffffffffc02004e0:	00005517          	auipc	a0,0x5
ffffffffc02004e4:	63850513          	addi	a0,a0,1592 # ffffffffc0205b18 <etext+0x288>
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
ffffffffc02004fa:	0009b717          	auipc	a4,0x9b
ffffffffc02004fe:	14f73323          	sd	a5,326(a4) # ffffffffc029b640 <timebase>
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
ffffffffc020051a:	00005517          	auipc	a0,0x5
ffffffffc020051e:	62650513          	addi	a0,a0,1574 # ffffffffc0205b40 <etext+0x2b0>
    ticks = 0;
ffffffffc0200522:	0009b797          	auipc	a5,0x9b
ffffffffc0200526:	1207b323          	sd	zero,294(a5) # ffffffffc029b648 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020052a:	b1ad                	j	ffffffffc0200194 <cprintf>

ffffffffc020052c <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020052c:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200530:	0009b797          	auipc	a5,0x9b
ffffffffc0200534:	1107b783          	ld	a5,272(a5) # ffffffffc029b640 <timebase>
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
ffffffffc02005be:	5a650513          	addi	a0,a0,1446 # ffffffffc0205b60 <etext+0x2d0>
void dtb_init(void) {
ffffffffc02005c2:	f406                	sd	ra,40(sp)
ffffffffc02005c4:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc02005c6:	bcfff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005ca:	0000b597          	auipc	a1,0xb
ffffffffc02005ce:	a365b583          	ld	a1,-1482(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc02005d2:	00005517          	auipc	a0,0x5
ffffffffc02005d6:	59e50513          	addi	a0,a0,1438 # ffffffffc0205b70 <etext+0x2e0>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005da:	0000b417          	auipc	s0,0xb
ffffffffc02005de:	a2e40413          	addi	s0,s0,-1490 # ffffffffc020b008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005e2:	bb3ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005e6:	600c                	ld	a1,0(s0)
ffffffffc02005e8:	00005517          	auipc	a0,0x5
ffffffffc02005ec:	59850513          	addi	a0,a0,1432 # ffffffffc0205b80 <etext+0x2f0>
ffffffffc02005f0:	ba5ff0ef          	jal	ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc02005f4:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc02005f6:	00005517          	auipc	a0,0x5
ffffffffc02005fa:	5a250513          	addi	a0,a0,1442 # ffffffffc0205b98 <etext+0x308>
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
ffffffffc020060e:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfe44835>
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
ffffffffc02006ec:	57850513          	addi	a0,a0,1400 # ffffffffc0205c60 <etext+0x3d0>
ffffffffc02006f0:	aa5ff0ef          	jal	ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02006f4:	64e2                	ld	s1,24(sp)
ffffffffc02006f6:	6942                	ld	s2,16(sp)
ffffffffc02006f8:	00005517          	auipc	a0,0x5
ffffffffc02006fc:	5a050513          	addi	a0,a0,1440 # ffffffffc0205c98 <etext+0x408>
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
ffffffffc0200710:	4ac50513          	addi	a0,a0,1196 # ffffffffc0205bb8 <etext+0x328>
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
ffffffffc0200752:	060050ef          	jal	ffffffffc02057b2 <strlen>
ffffffffc0200756:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200758:	4619                	li	a2,6
ffffffffc020075a:	8522                	mv	a0,s0
ffffffffc020075c:	00005597          	auipc	a1,0x5
ffffffffc0200760:	48458593          	addi	a1,a1,1156 # ffffffffc0205be0 <etext+0x350>
ffffffffc0200764:	0c8050ef          	jal	ffffffffc020582c <strncmp>
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
ffffffffc020078c:	46058593          	addi	a1,a1,1120 # ffffffffc0205be8 <etext+0x358>
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
ffffffffc02007be:	03a050ef          	jal	ffffffffc02057f8 <strcmp>
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
ffffffffc02007e2:	41250513          	addi	a0,a0,1042 # ffffffffc0205bf0 <etext+0x360>
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
ffffffffc02008ac:	36850513          	addi	a0,a0,872 # ffffffffc0205c10 <etext+0x380>
ffffffffc02008b0:	8e5ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc02008b4:	01445613          	srli	a2,s0,0x14
ffffffffc02008b8:	85a2                	mv	a1,s0
ffffffffc02008ba:	00005517          	auipc	a0,0x5
ffffffffc02008be:	36e50513          	addi	a0,a0,878 # ffffffffc0205c28 <etext+0x398>
ffffffffc02008c2:	8d3ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02008c6:	009405b3          	add	a1,s0,s1
ffffffffc02008ca:	15fd                	addi	a1,a1,-1
ffffffffc02008cc:	00005517          	auipc	a0,0x5
ffffffffc02008d0:	37c50513          	addi	a0,a0,892 # ffffffffc0205c48 <etext+0x3b8>
ffffffffc02008d4:	8c1ff0ef          	jal	ffffffffc0200194 <cprintf>
        memory_base = mem_base;
ffffffffc02008d8:	0009b797          	auipc	a5,0x9b
ffffffffc02008dc:	d897b023          	sd	s1,-640(a5) # ffffffffc029b658 <memory_base>
        memory_size = mem_size;
ffffffffc02008e0:	0009b797          	auipc	a5,0x9b
ffffffffc02008e4:	d687b823          	sd	s0,-656(a5) # ffffffffc029b650 <memory_size>
ffffffffc02008e8:	b531                	j	ffffffffc02006f4 <dtb_init+0x13c>

ffffffffc02008ea <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02008ea:	0009b517          	auipc	a0,0x9b
ffffffffc02008ee:	d6e53503          	ld	a0,-658(a0) # ffffffffc029b658 <memory_base>
ffffffffc02008f2:	8082                	ret

ffffffffc02008f4 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02008f4:	0009b517          	auipc	a0,0x9b
ffffffffc02008f8:	d5c53503          	ld	a0,-676(a0) # ffffffffc029b650 <memory_size>
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
ffffffffc0200914:	51078793          	addi	a5,a5,1296 # ffffffffc0200e20 <__alltraps>
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
ffffffffc0200932:	38250513          	addi	a0,a0,898 # ffffffffc0205cb0 <etext+0x420>
{
ffffffffc0200936:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200938:	85dff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020093c:	640c                	ld	a1,8(s0)
ffffffffc020093e:	00005517          	auipc	a0,0x5
ffffffffc0200942:	38a50513          	addi	a0,a0,906 # ffffffffc0205cc8 <etext+0x438>
ffffffffc0200946:	84fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020094a:	680c                	ld	a1,16(s0)
ffffffffc020094c:	00005517          	auipc	a0,0x5
ffffffffc0200950:	39450513          	addi	a0,a0,916 # ffffffffc0205ce0 <etext+0x450>
ffffffffc0200954:	841ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200958:	6c0c                	ld	a1,24(s0)
ffffffffc020095a:	00005517          	auipc	a0,0x5
ffffffffc020095e:	39e50513          	addi	a0,a0,926 # ffffffffc0205cf8 <etext+0x468>
ffffffffc0200962:	833ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200966:	700c                	ld	a1,32(s0)
ffffffffc0200968:	00005517          	auipc	a0,0x5
ffffffffc020096c:	3a850513          	addi	a0,a0,936 # ffffffffc0205d10 <etext+0x480>
ffffffffc0200970:	825ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200974:	740c                	ld	a1,40(s0)
ffffffffc0200976:	00005517          	auipc	a0,0x5
ffffffffc020097a:	3b250513          	addi	a0,a0,946 # ffffffffc0205d28 <etext+0x498>
ffffffffc020097e:	817ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200982:	780c                	ld	a1,48(s0)
ffffffffc0200984:	00005517          	auipc	a0,0x5
ffffffffc0200988:	3bc50513          	addi	a0,a0,956 # ffffffffc0205d40 <etext+0x4b0>
ffffffffc020098c:	809ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200990:	7c0c                	ld	a1,56(s0)
ffffffffc0200992:	00005517          	auipc	a0,0x5
ffffffffc0200996:	3c650513          	addi	a0,a0,966 # ffffffffc0205d58 <etext+0x4c8>
ffffffffc020099a:	ffaff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc020099e:	602c                	ld	a1,64(s0)
ffffffffc02009a0:	00005517          	auipc	a0,0x5
ffffffffc02009a4:	3d050513          	addi	a0,a0,976 # ffffffffc0205d70 <etext+0x4e0>
ffffffffc02009a8:	fecff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02009ac:	642c                	ld	a1,72(s0)
ffffffffc02009ae:	00005517          	auipc	a0,0x5
ffffffffc02009b2:	3da50513          	addi	a0,a0,986 # ffffffffc0205d88 <etext+0x4f8>
ffffffffc02009b6:	fdeff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02009ba:	682c                	ld	a1,80(s0)
ffffffffc02009bc:	00005517          	auipc	a0,0x5
ffffffffc02009c0:	3e450513          	addi	a0,a0,996 # ffffffffc0205da0 <etext+0x510>
ffffffffc02009c4:	fd0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02009c8:	6c2c                	ld	a1,88(s0)
ffffffffc02009ca:	00005517          	auipc	a0,0x5
ffffffffc02009ce:	3ee50513          	addi	a0,a0,1006 # ffffffffc0205db8 <etext+0x528>
ffffffffc02009d2:	fc2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc02009d6:	702c                	ld	a1,96(s0)
ffffffffc02009d8:	00005517          	auipc	a0,0x5
ffffffffc02009dc:	3f850513          	addi	a0,a0,1016 # ffffffffc0205dd0 <etext+0x540>
ffffffffc02009e0:	fb4ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc02009e4:	742c                	ld	a1,104(s0)
ffffffffc02009e6:	00005517          	auipc	a0,0x5
ffffffffc02009ea:	40250513          	addi	a0,a0,1026 # ffffffffc0205de8 <etext+0x558>
ffffffffc02009ee:	fa6ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc02009f2:	782c                	ld	a1,112(s0)
ffffffffc02009f4:	00005517          	auipc	a0,0x5
ffffffffc02009f8:	40c50513          	addi	a0,a0,1036 # ffffffffc0205e00 <etext+0x570>
ffffffffc02009fc:	f98ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200a00:	7c2c                	ld	a1,120(s0)
ffffffffc0200a02:	00005517          	auipc	a0,0x5
ffffffffc0200a06:	41650513          	addi	a0,a0,1046 # ffffffffc0205e18 <etext+0x588>
ffffffffc0200a0a:	f8aff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200a0e:	604c                	ld	a1,128(s0)
ffffffffc0200a10:	00005517          	auipc	a0,0x5
ffffffffc0200a14:	42050513          	addi	a0,a0,1056 # ffffffffc0205e30 <etext+0x5a0>
ffffffffc0200a18:	f7cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200a1c:	644c                	ld	a1,136(s0)
ffffffffc0200a1e:	00005517          	auipc	a0,0x5
ffffffffc0200a22:	42a50513          	addi	a0,a0,1066 # ffffffffc0205e48 <etext+0x5b8>
ffffffffc0200a26:	f6eff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200a2a:	684c                	ld	a1,144(s0)
ffffffffc0200a2c:	00005517          	auipc	a0,0x5
ffffffffc0200a30:	43450513          	addi	a0,a0,1076 # ffffffffc0205e60 <etext+0x5d0>
ffffffffc0200a34:	f60ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200a38:	6c4c                	ld	a1,152(s0)
ffffffffc0200a3a:	00005517          	auipc	a0,0x5
ffffffffc0200a3e:	43e50513          	addi	a0,a0,1086 # ffffffffc0205e78 <etext+0x5e8>
ffffffffc0200a42:	f52ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200a46:	704c                	ld	a1,160(s0)
ffffffffc0200a48:	00005517          	auipc	a0,0x5
ffffffffc0200a4c:	44850513          	addi	a0,a0,1096 # ffffffffc0205e90 <etext+0x600>
ffffffffc0200a50:	f44ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200a54:	744c                	ld	a1,168(s0)
ffffffffc0200a56:	00005517          	auipc	a0,0x5
ffffffffc0200a5a:	45250513          	addi	a0,a0,1106 # ffffffffc0205ea8 <etext+0x618>
ffffffffc0200a5e:	f36ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200a62:	784c                	ld	a1,176(s0)
ffffffffc0200a64:	00005517          	auipc	a0,0x5
ffffffffc0200a68:	45c50513          	addi	a0,a0,1116 # ffffffffc0205ec0 <etext+0x630>
ffffffffc0200a6c:	f28ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200a70:	7c4c                	ld	a1,184(s0)
ffffffffc0200a72:	00005517          	auipc	a0,0x5
ffffffffc0200a76:	46650513          	addi	a0,a0,1126 # ffffffffc0205ed8 <etext+0x648>
ffffffffc0200a7a:	f1aff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200a7e:	606c                	ld	a1,192(s0)
ffffffffc0200a80:	00005517          	auipc	a0,0x5
ffffffffc0200a84:	47050513          	addi	a0,a0,1136 # ffffffffc0205ef0 <etext+0x660>
ffffffffc0200a88:	f0cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200a8c:	646c                	ld	a1,200(s0)
ffffffffc0200a8e:	00005517          	auipc	a0,0x5
ffffffffc0200a92:	47a50513          	addi	a0,a0,1146 # ffffffffc0205f08 <etext+0x678>
ffffffffc0200a96:	efeff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200a9a:	686c                	ld	a1,208(s0)
ffffffffc0200a9c:	00005517          	auipc	a0,0x5
ffffffffc0200aa0:	48450513          	addi	a0,a0,1156 # ffffffffc0205f20 <etext+0x690>
ffffffffc0200aa4:	ef0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200aa8:	6c6c                	ld	a1,216(s0)
ffffffffc0200aaa:	00005517          	auipc	a0,0x5
ffffffffc0200aae:	48e50513          	addi	a0,a0,1166 # ffffffffc0205f38 <etext+0x6a8>
ffffffffc0200ab2:	ee2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200ab6:	706c                	ld	a1,224(s0)
ffffffffc0200ab8:	00005517          	auipc	a0,0x5
ffffffffc0200abc:	49850513          	addi	a0,a0,1176 # ffffffffc0205f50 <etext+0x6c0>
ffffffffc0200ac0:	ed4ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200ac4:	746c                	ld	a1,232(s0)
ffffffffc0200ac6:	00005517          	auipc	a0,0x5
ffffffffc0200aca:	4a250513          	addi	a0,a0,1186 # ffffffffc0205f68 <etext+0x6d8>
ffffffffc0200ace:	ec6ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200ad2:	786c                	ld	a1,240(s0)
ffffffffc0200ad4:	00005517          	auipc	a0,0x5
ffffffffc0200ad8:	4ac50513          	addi	a0,a0,1196 # ffffffffc0205f80 <etext+0x6f0>
ffffffffc0200adc:	eb8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ae0:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200ae2:	6402                	ld	s0,0(sp)
ffffffffc0200ae4:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ae6:	00005517          	auipc	a0,0x5
ffffffffc0200aea:	4b250513          	addi	a0,a0,1202 # ffffffffc0205f98 <etext+0x708>
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
ffffffffc0200b00:	4b450513          	addi	a0,a0,1204 # ffffffffc0205fb0 <etext+0x720>
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
ffffffffc0200b18:	4b450513          	addi	a0,a0,1204 # ffffffffc0205fc8 <etext+0x738>
ffffffffc0200b1c:	e78ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200b20:	10843583          	ld	a1,264(s0)
ffffffffc0200b24:	00005517          	auipc	a0,0x5
ffffffffc0200b28:	4bc50513          	addi	a0,a0,1212 # ffffffffc0205fe0 <etext+0x750>
ffffffffc0200b2c:	e68ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200b30:	11043583          	ld	a1,272(s0)
ffffffffc0200b34:	00005517          	auipc	a0,0x5
ffffffffc0200b38:	4c450513          	addi	a0,a0,1220 # ffffffffc0205ff8 <etext+0x768>
ffffffffc0200b3c:	e58ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b40:	11843583          	ld	a1,280(s0)
}
ffffffffc0200b44:	6402                	ld	s0,0(sp)
ffffffffc0200b46:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b48:	00005517          	auipc	a0,0x5
ffffffffc0200b4c:	4c050513          	addi	a0,a0,1216 # ffffffffc0206008 <etext+0x778>
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
ffffffffc0200b68:	ac470713          	addi	a4,a4,-1340 # ffffffffc0207628 <commands+0x48>
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
ffffffffc0200b7a:	50a50513          	addi	a0,a0,1290 # ffffffffc0206080 <etext+0x7f0>
ffffffffc0200b7e:	e16ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200b82:	00005517          	auipc	a0,0x5
ffffffffc0200b86:	4de50513          	addi	a0,a0,1246 # ffffffffc0206060 <etext+0x7d0>
ffffffffc0200b8a:	e0aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200b8e:	00005517          	auipc	a0,0x5
ffffffffc0200b92:	49250513          	addi	a0,a0,1170 # ffffffffc0206020 <etext+0x790>
ffffffffc0200b96:	dfeff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200b9a:	00005517          	auipc	a0,0x5
ffffffffc0200b9e:	4a650513          	addi	a0,a0,1190 # ffffffffc0206040 <etext+0x7b0>
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
ffffffffc0200bae:	0009b697          	auipc	a3,0x9b
ffffffffc0200bb2:	a9a6b683          	ld	a3,-1382(a3) # ffffffffc029b648 <ticks>
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
ffffffffc0200bd8:	0009b717          	auipc	a4,0x9b
ffffffffc0200bdc:	a6d73823          	sd	a3,-1424(a4) # ffffffffc029b648 <ticks>
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
ffffffffc0200bf4:	4c050513          	addi	a0,a0,1216 # ffffffffc02060b0 <etext+0x820>
ffffffffc0200bf8:	d9cff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200bfc:	bde5                	j	ffffffffc0200af4 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200bfe:	00005517          	auipc	a0,0x5
ffffffffc0200c02:	4a250513          	addi	a0,a0,1186 # ffffffffc02060a0 <etext+0x810>
ffffffffc0200c06:	d8eff0ef          	jal	ffffffffc0200194 <cprintf>
            if (current) {
ffffffffc0200c0a:	0009b797          	auipc	a5,0x9b
ffffffffc0200c0e:	a967b783          	ld	a5,-1386(a5) # ffffffffc029b6a0 <current>
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
ffffffffc0200c1a:	11853783          	ld	a5,280(a0)
ffffffffc0200c1e:	473d                	li	a4,15
ffffffffc0200c20:	16f76c63          	bltu	a4,a5,ffffffffc0200d98 <exception_handler+0x17e>
ffffffffc0200c24:	00007717          	auipc	a4,0x7
ffffffffc0200c28:	a3470713          	addi	a4,a4,-1484 # ffffffffc0207658 <commands+0x78>
ffffffffc0200c2c:	078a                	slli	a5,a5,0x2
ffffffffc0200c2e:	97ba                	add	a5,a5,a4
ffffffffc0200c30:	439c                	lw	a5,0(a5)
{
ffffffffc0200c32:	1101                	addi	sp,sp,-32
ffffffffc0200c34:	ec06                	sd	ra,24(sp)
    switch (tf->cause)
ffffffffc0200c36:	97ba                	add	a5,a5,a4
ffffffffc0200c38:	86aa                	mv	a3,a0
ffffffffc0200c3a:	8782                	jr	a5
ffffffffc0200c3c:	e42a                	sd	a0,8(sp)
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200c3e:	00005517          	auipc	a0,0x5
ffffffffc0200c42:	56a50513          	addi	a0,a0,1386 # ffffffffc02061a8 <etext+0x918>
ffffffffc0200c46:	d4eff0ef          	jal	ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200c4a:	66a2                	ld	a3,8(sp)
ffffffffc0200c4c:	1086b783          	ld	a5,264(a3)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c50:	60e2                	ld	ra,24(sp)
        tf->epc += 4;
ffffffffc0200c52:	0791                	addi	a5,a5,4
ffffffffc0200c54:	10f6b423          	sd	a5,264(a3)
}
ffffffffc0200c58:	6105                	addi	sp,sp,32
        syscall();
ffffffffc0200c5a:	6fa0406f          	j	ffffffffc0205354 <syscall>
}
ffffffffc0200c5e:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from H-mode\n");
ffffffffc0200c60:	00005517          	auipc	a0,0x5
ffffffffc0200c64:	56850513          	addi	a0,a0,1384 # ffffffffc02061c8 <etext+0x938>
}
ffffffffc0200c68:	6105                	addi	sp,sp,32
        cprintf("Environment call from H-mode\n");
ffffffffc0200c6a:	d2aff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200c6e:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from M-mode\n");
ffffffffc0200c70:	00005517          	auipc	a0,0x5
ffffffffc0200c74:	57850513          	addi	a0,a0,1400 # ffffffffc02061e8 <etext+0x958>
}
ffffffffc0200c78:	6105                	addi	sp,sp,32
        cprintf("Environment call from M-mode\n");
ffffffffc0200c7a:	d1aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Instruction page fault\n");
ffffffffc0200c7e:	00005517          	auipc	a0,0x5
ffffffffc0200c82:	58a50513          	addi	a0,a0,1418 # ffffffffc0206208 <etext+0x978>
ffffffffc0200c86:	d0eff0ef          	jal	ffffffffc0200194 <cprintf>
        if (current != NULL) {
ffffffffc0200c8a:	0009b797          	auipc	a5,0x9b
ffffffffc0200c8e:	a167b783          	ld	a5,-1514(a5) # ffffffffc029b6a0 <current>
ffffffffc0200c92:	c38d                	beqz	a5,ffffffffc0200cb4 <exception_handler+0x9a>
}
ffffffffc0200c94:	60e2                	ld	ra,24(sp)
            do_exit(-E_KILLED);
ffffffffc0200c96:	555d                	li	a0,-9
}
ffffffffc0200c98:	6105                	addi	sp,sp,32
            do_exit(-E_KILLED);
ffffffffc0200c9a:	0890306f          	j	ffffffffc0204522 <do_exit>
        cprintf("Load page fault\n");
ffffffffc0200c9e:	00005517          	auipc	a0,0x5
ffffffffc0200ca2:	58250513          	addi	a0,a0,1410 # ffffffffc0206220 <etext+0x990>
ffffffffc0200ca6:	ceeff0ef          	jal	ffffffffc0200194 <cprintf>
        if (current != NULL) {
ffffffffc0200caa:	0009b797          	auipc	a5,0x9b
ffffffffc0200cae:	9f67b783          	ld	a5,-1546(a5) # ffffffffc029b6a0 <current>
ffffffffc0200cb2:	f3ed                	bnez	a5,ffffffffc0200c94 <exception_handler+0x7a>
}
ffffffffc0200cb4:	60e2                	ld	ra,24(sp)
ffffffffc0200cb6:	6105                	addi	sp,sp,32
ffffffffc0200cb8:	8082                	ret
        cprintf("Store/AMO page fault\n");
ffffffffc0200cba:	00005517          	auipc	a0,0x5
ffffffffc0200cbe:	57e50513          	addi	a0,a0,1406 # ffffffffc0206238 <etext+0x9a8>
ffffffffc0200cc2:	cd2ff0ef          	jal	ffffffffc0200194 <cprintf>
        if (current != NULL) {
ffffffffc0200cc6:	0009b797          	auipc	a5,0x9b
ffffffffc0200cca:	9da7b783          	ld	a5,-1574(a5) # ffffffffc029b6a0 <current>
ffffffffc0200cce:	f3f9                	bnez	a5,ffffffffc0200c94 <exception_handler+0x7a>
ffffffffc0200cd0:	b7d5                	j	ffffffffc0200cb4 <exception_handler+0x9a>
}
ffffffffc0200cd2:	60e2                	ld	ra,24(sp)
        cprintf("Instruction address misaligned\n");
ffffffffc0200cd4:	00005517          	auipc	a0,0x5
ffffffffc0200cd8:	3fc50513          	addi	a0,a0,1020 # ffffffffc02060d0 <etext+0x840>
}
ffffffffc0200cdc:	6105                	addi	sp,sp,32
        cprintf("Instruction address misaligned\n");
ffffffffc0200cde:	cb6ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200ce2:	60e2                	ld	ra,24(sp)
        cprintf("Instruction access fault\n");
ffffffffc0200ce4:	00005517          	auipc	a0,0x5
ffffffffc0200ce8:	40c50513          	addi	a0,a0,1036 # ffffffffc02060f0 <etext+0x860>
}
ffffffffc0200cec:	6105                	addi	sp,sp,32
        cprintf("Instruction access fault\n");
ffffffffc0200cee:	ca6ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cf2:	60e2                	ld	ra,24(sp)
        cprintf("Illegal instruction\n");
ffffffffc0200cf4:	00005517          	auipc	a0,0x5
ffffffffc0200cf8:	41c50513          	addi	a0,a0,1052 # ffffffffc0206110 <etext+0x880>
}
ffffffffc0200cfc:	6105                	addi	sp,sp,32
        cprintf("Illegal instruction\n");
ffffffffc0200cfe:	c96ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200d02:	e42a                	sd	a0,8(sp)
        cprintf("Breakpoint\n");
ffffffffc0200d04:	00005517          	auipc	a0,0x5
ffffffffc0200d08:	42450513          	addi	a0,a0,1060 # ffffffffc0206128 <etext+0x898>
ffffffffc0200d0c:	c88ff0ef          	jal	ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200d10:	66a2                	ld	a3,8(sp)
ffffffffc0200d12:	47a9                	li	a5,10
ffffffffc0200d14:	66d8                	ld	a4,136(a3)
ffffffffc0200d16:	f8f71fe3          	bne	a4,a5,ffffffffc0200cb4 <exception_handler+0x9a>
            tf->epc += 4;
ffffffffc0200d1a:	1086b783          	ld	a5,264(a3)
ffffffffc0200d1e:	0791                	addi	a5,a5,4
ffffffffc0200d20:	10f6b423          	sd	a5,264(a3)
            syscall();
ffffffffc0200d24:	630040ef          	jal	ffffffffc0205354 <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200d28:	0009b717          	auipc	a4,0x9b
ffffffffc0200d2c:	97873703          	ld	a4,-1672(a4) # ffffffffc029b6a0 <current>
ffffffffc0200d30:	6522                	ld	a0,8(sp)
}
ffffffffc0200d32:	60e2                	ld	ra,24(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200d34:	6b0c                	ld	a1,16(a4)
ffffffffc0200d36:	6789                	lui	a5,0x2
ffffffffc0200d38:	95be                	add	a1,a1,a5
}
ffffffffc0200d3a:	6105                	addi	sp,sp,32
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200d3c:	aa4d                	j	ffffffffc0200eee <kernel_execve_ret>
}
ffffffffc0200d3e:	60e2                	ld	ra,24(sp)
        cprintf("Load address misaligned\n");
ffffffffc0200d40:	00005517          	auipc	a0,0x5
ffffffffc0200d44:	3f850513          	addi	a0,a0,1016 # ffffffffc0206138 <etext+0x8a8>
}
ffffffffc0200d48:	6105                	addi	sp,sp,32
        cprintf("Load address misaligned\n");
ffffffffc0200d4a:	c4aff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d4e:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO address misaligned\n");
ffffffffc0200d50:	00005517          	auipc	a0,0x5
ffffffffc0200d54:	42050513          	addi	a0,a0,1056 # ffffffffc0206170 <etext+0x8e0>
}
ffffffffc0200d58:	6105                	addi	sp,sp,32
        cprintf("Store/AMO address misaligned\n");
ffffffffc0200d5a:	c3aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Store/AMO access fault\n");
ffffffffc0200d5e:	00005517          	auipc	a0,0x5
ffffffffc0200d62:	43250513          	addi	a0,a0,1074 # ffffffffc0206190 <etext+0x900>
ffffffffc0200d66:	c2eff0ef          	jal	ffffffffc0200194 <cprintf>
        if (current != NULL) {
ffffffffc0200d6a:	0009b797          	auipc	a5,0x9b
ffffffffc0200d6e:	9367b783          	ld	a5,-1738(a5) # ffffffffc029b6a0 <current>
ffffffffc0200d72:	f20791e3          	bnez	a5,ffffffffc0200c94 <exception_handler+0x7a>
ffffffffc0200d76:	bf3d                	j	ffffffffc0200cb4 <exception_handler+0x9a>
        cprintf("Load access fault\n");
ffffffffc0200d78:	00005517          	auipc	a0,0x5
ffffffffc0200d7c:	3e050513          	addi	a0,a0,992 # ffffffffc0206158 <etext+0x8c8>
ffffffffc0200d80:	c14ff0ef          	jal	ffffffffc0200194 <cprintf>
        if (current != NULL) {
ffffffffc0200d84:	0009b797          	auipc	a5,0x9b
ffffffffc0200d88:	91c7b783          	ld	a5,-1764(a5) # ffffffffc029b6a0 <current>
ffffffffc0200d8c:	f00794e3          	bnez	a5,ffffffffc0200c94 <exception_handler+0x7a>
ffffffffc0200d90:	b715                	j	ffffffffc0200cb4 <exception_handler+0x9a>
}
ffffffffc0200d92:	60e2                	ld	ra,24(sp)
ffffffffc0200d94:	6105                	addi	sp,sp,32
        print_trapframe(tf);
ffffffffc0200d96:	bbb9                	j	ffffffffc0200af4 <print_trapframe>
ffffffffc0200d98:	bbb1                	j	ffffffffc0200af4 <print_trapframe>

ffffffffc0200d9a <trap>:
 * */
void trap(struct trapframe *tf)
{
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200d9a:	0009b717          	auipc	a4,0x9b
ffffffffc0200d9e:	90673703          	ld	a4,-1786(a4) # ffffffffc029b6a0 <current>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200da2:	11853583          	ld	a1,280(a0)
    if (current == NULL)
ffffffffc0200da6:	cf21                	beqz	a4,ffffffffc0200dfe <trap+0x64>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200da8:	10053603          	ld	a2,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200dac:	0a073803          	ld	a6,160(a4)
{
ffffffffc0200db0:	1101                	addi	sp,sp,-32
ffffffffc0200db2:	ec06                	sd	ra,24(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200db4:	10067613          	andi	a2,a2,256
        current->tf = tf;
ffffffffc0200db8:	f348                	sd	a0,160(a4)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dba:	e432                	sd	a2,8(sp)
ffffffffc0200dbc:	e042                	sd	a6,0(sp)
ffffffffc0200dbe:	0205c763          	bltz	a1,ffffffffc0200dec <trap+0x52>
        exception_handler(tf);
ffffffffc0200dc2:	e59ff0ef          	jal	ffffffffc0200c1a <exception_handler>
ffffffffc0200dc6:	6622                	ld	a2,8(sp)
ffffffffc0200dc8:	6802                	ld	a6,0(sp)
ffffffffc0200dca:	0009b697          	auipc	a3,0x9b
ffffffffc0200dce:	8d668693          	addi	a3,a3,-1834 # ffffffffc029b6a0 <current>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200dd2:	6298                	ld	a4,0(a3)
ffffffffc0200dd4:	0b073023          	sd	a6,160(a4)
        if (!in_kernel)
ffffffffc0200dd8:	e619                	bnez	a2,ffffffffc0200de6 <trap+0x4c>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200dda:	0b072783          	lw	a5,176(a4)
ffffffffc0200dde:	8b85                	andi	a5,a5,1
ffffffffc0200de0:	e79d                	bnez	a5,ffffffffc0200e0e <trap+0x74>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200de2:	6f1c                	ld	a5,24(a4)
ffffffffc0200de4:	e38d                	bnez	a5,ffffffffc0200e06 <trap+0x6c>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200de6:	60e2                	ld	ra,24(sp)
ffffffffc0200de8:	6105                	addi	sp,sp,32
ffffffffc0200dea:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200dec:	d6bff0ef          	jal	ffffffffc0200b56 <interrupt_handler>
ffffffffc0200df0:	6802                	ld	a6,0(sp)
ffffffffc0200df2:	6622                	ld	a2,8(sp)
ffffffffc0200df4:	0009b697          	auipc	a3,0x9b
ffffffffc0200df8:	8ac68693          	addi	a3,a3,-1876 # ffffffffc029b6a0 <current>
ffffffffc0200dfc:	bfd9                	j	ffffffffc0200dd2 <trap+0x38>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dfe:	0005c363          	bltz	a1,ffffffffc0200e04 <trap+0x6a>
        exception_handler(tf);
ffffffffc0200e02:	bd21                	j	ffffffffc0200c1a <exception_handler>
        interrupt_handler(tf);
ffffffffc0200e04:	bb89                	j	ffffffffc0200b56 <interrupt_handler>
}
ffffffffc0200e06:	60e2                	ld	ra,24(sp)
ffffffffc0200e08:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200e0a:	45e0406f          	j	ffffffffc0205268 <schedule>
                do_exit(-E_KILLED);
ffffffffc0200e0e:	555d                	li	a0,-9
ffffffffc0200e10:	712030ef          	jal	ffffffffc0204522 <do_exit>
            if (current->need_resched)
ffffffffc0200e14:	0009b717          	auipc	a4,0x9b
ffffffffc0200e18:	88c73703          	ld	a4,-1908(a4) # ffffffffc029b6a0 <current>
ffffffffc0200e1c:	b7d9                	j	ffffffffc0200de2 <trap+0x48>
	...

ffffffffc0200e20 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200e20:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200e24:	00011463          	bnez	sp,ffffffffc0200e2c <__alltraps+0xc>
ffffffffc0200e28:	14002173          	csrr	sp,sscratch
ffffffffc0200e2c:	712d                	addi	sp,sp,-288
ffffffffc0200e2e:	e002                	sd	zero,0(sp)
ffffffffc0200e30:	e406                	sd	ra,8(sp)
ffffffffc0200e32:	ec0e                	sd	gp,24(sp)
ffffffffc0200e34:	f012                	sd	tp,32(sp)
ffffffffc0200e36:	f416                	sd	t0,40(sp)
ffffffffc0200e38:	f81a                	sd	t1,48(sp)
ffffffffc0200e3a:	fc1e                	sd	t2,56(sp)
ffffffffc0200e3c:	e0a2                	sd	s0,64(sp)
ffffffffc0200e3e:	e4a6                	sd	s1,72(sp)
ffffffffc0200e40:	e8aa                	sd	a0,80(sp)
ffffffffc0200e42:	ecae                	sd	a1,88(sp)
ffffffffc0200e44:	f0b2                	sd	a2,96(sp)
ffffffffc0200e46:	f4b6                	sd	a3,104(sp)
ffffffffc0200e48:	f8ba                	sd	a4,112(sp)
ffffffffc0200e4a:	fcbe                	sd	a5,120(sp)
ffffffffc0200e4c:	e142                	sd	a6,128(sp)
ffffffffc0200e4e:	e546                	sd	a7,136(sp)
ffffffffc0200e50:	e94a                	sd	s2,144(sp)
ffffffffc0200e52:	ed4e                	sd	s3,152(sp)
ffffffffc0200e54:	f152                	sd	s4,160(sp)
ffffffffc0200e56:	f556                	sd	s5,168(sp)
ffffffffc0200e58:	f95a                	sd	s6,176(sp)
ffffffffc0200e5a:	fd5e                	sd	s7,184(sp)
ffffffffc0200e5c:	e1e2                	sd	s8,192(sp)
ffffffffc0200e5e:	e5e6                	sd	s9,200(sp)
ffffffffc0200e60:	e9ea                	sd	s10,208(sp)
ffffffffc0200e62:	edee                	sd	s11,216(sp)
ffffffffc0200e64:	f1f2                	sd	t3,224(sp)
ffffffffc0200e66:	f5f6                	sd	t4,232(sp)
ffffffffc0200e68:	f9fa                	sd	t5,240(sp)
ffffffffc0200e6a:	fdfe                	sd	t6,248(sp)
ffffffffc0200e6c:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200e70:	100024f3          	csrr	s1,sstatus
ffffffffc0200e74:	14102973          	csrr	s2,sepc
ffffffffc0200e78:	143029f3          	csrr	s3,stval
ffffffffc0200e7c:	14202a73          	csrr	s4,scause
ffffffffc0200e80:	e822                	sd	s0,16(sp)
ffffffffc0200e82:	e226                	sd	s1,256(sp)
ffffffffc0200e84:	e64a                	sd	s2,264(sp)
ffffffffc0200e86:	ea4e                	sd	s3,272(sp)
ffffffffc0200e88:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200e8a:	850a                	mv	a0,sp
    jal trap
ffffffffc0200e8c:	f0fff0ef          	jal	ffffffffc0200d9a <trap>

ffffffffc0200e90 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200e90:	6492                	ld	s1,256(sp)
ffffffffc0200e92:	6932                	ld	s2,264(sp)
ffffffffc0200e94:	1004f413          	andi	s0,s1,256
ffffffffc0200e98:	e401                	bnez	s0,ffffffffc0200ea0 <__trapret+0x10>
ffffffffc0200e9a:	1200                	addi	s0,sp,288
ffffffffc0200e9c:	14041073          	csrw	sscratch,s0
ffffffffc0200ea0:	10049073          	csrw	sstatus,s1
ffffffffc0200ea4:	14191073          	csrw	sepc,s2
ffffffffc0200ea8:	60a2                	ld	ra,8(sp)
ffffffffc0200eaa:	61e2                	ld	gp,24(sp)
ffffffffc0200eac:	7202                	ld	tp,32(sp)
ffffffffc0200eae:	72a2                	ld	t0,40(sp)
ffffffffc0200eb0:	7342                	ld	t1,48(sp)
ffffffffc0200eb2:	73e2                	ld	t2,56(sp)
ffffffffc0200eb4:	6406                	ld	s0,64(sp)
ffffffffc0200eb6:	64a6                	ld	s1,72(sp)
ffffffffc0200eb8:	6546                	ld	a0,80(sp)
ffffffffc0200eba:	65e6                	ld	a1,88(sp)
ffffffffc0200ebc:	7606                	ld	a2,96(sp)
ffffffffc0200ebe:	76a6                	ld	a3,104(sp)
ffffffffc0200ec0:	7746                	ld	a4,112(sp)
ffffffffc0200ec2:	77e6                	ld	a5,120(sp)
ffffffffc0200ec4:	680a                	ld	a6,128(sp)
ffffffffc0200ec6:	68aa                	ld	a7,136(sp)
ffffffffc0200ec8:	694a                	ld	s2,144(sp)
ffffffffc0200eca:	69ea                	ld	s3,152(sp)
ffffffffc0200ecc:	7a0a                	ld	s4,160(sp)
ffffffffc0200ece:	7aaa                	ld	s5,168(sp)
ffffffffc0200ed0:	7b4a                	ld	s6,176(sp)
ffffffffc0200ed2:	7bea                	ld	s7,184(sp)
ffffffffc0200ed4:	6c0e                	ld	s8,192(sp)
ffffffffc0200ed6:	6cae                	ld	s9,200(sp)
ffffffffc0200ed8:	6d4e                	ld	s10,208(sp)
ffffffffc0200eda:	6dee                	ld	s11,216(sp)
ffffffffc0200edc:	7e0e                	ld	t3,224(sp)
ffffffffc0200ede:	7eae                	ld	t4,232(sp)
ffffffffc0200ee0:	7f4e                	ld	t5,240(sp)
ffffffffc0200ee2:	7fee                	ld	t6,248(sp)
ffffffffc0200ee4:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200ee6:	10200073          	sret

ffffffffc0200eea <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200eea:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200eec:	b755                	j	ffffffffc0200e90 <__trapret>

ffffffffc0200eee <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200eee:	ee058593          	addi	a1,a1,-288

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200ef2:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200ef6:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200efa:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200efe:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200f02:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200f06:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200f0a:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200f0e:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200f12:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200f14:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200f16:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200f18:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200f1a:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200f1c:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200f1e:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200f20:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200f22:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200f24:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200f26:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200f28:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200f2a:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0200f2c:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0200f2e:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0200f30:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0200f32:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0200f34:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0200f36:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0200f38:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0200f3a:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0200f3c:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0200f3e:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0200f40:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0200f42:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0200f44:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0200f46:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0200f48:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0200f4a:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0200f4c:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0200f4e:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0200f50:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0200f52:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0200f54:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0200f56:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0200f58:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0200f5a:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0200f5c:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0200f5e:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0200f60:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0200f62:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0200f64:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0200f66:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0200f68:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0200f6a:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0200f6c:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0200f6e:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0200f70:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0200f72:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0200f74:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0200f76:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0200f78:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0200f7a:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0200f7c:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0200f7e:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0200f80:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0200f82:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0200f84:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0200f86:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0200f88:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0200f8a:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0200f8c:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0200f8e:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0200f90:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0200f92:	812e                	mv	sp,a1
ffffffffc0200f94:	bdf5                	j	ffffffffc0200e90 <__trapret>

ffffffffc0200f96 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200f96:	00096797          	auipc	a5,0x96
ffffffffc0200f9a:	67a78793          	addi	a5,a5,1658 # ffffffffc0297610 <free_area>
ffffffffc0200f9e:	e79c                	sd	a5,8(a5)
ffffffffc0200fa0:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200fa2:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200fa6:	8082                	ret

ffffffffc0200fa8 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200fa8:	00096517          	auipc	a0,0x96
ffffffffc0200fac:	67856503          	lwu	a0,1656(a0) # ffffffffc0297620 <free_area+0x10>
ffffffffc0200fb0:	8082                	ret

ffffffffc0200fb2 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0200fb2:	711d                	addi	sp,sp,-96
ffffffffc0200fb4:	e0ca                	sd	s2,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200fb6:	00096917          	auipc	s2,0x96
ffffffffc0200fba:	65a90913          	addi	s2,s2,1626 # ffffffffc0297610 <free_area>
ffffffffc0200fbe:	00893783          	ld	a5,8(s2)
ffffffffc0200fc2:	ec86                	sd	ra,88(sp)
ffffffffc0200fc4:	e8a2                	sd	s0,80(sp)
ffffffffc0200fc6:	e4a6                	sd	s1,72(sp)
ffffffffc0200fc8:	fc4e                	sd	s3,56(sp)
ffffffffc0200fca:	f852                	sd	s4,48(sp)
ffffffffc0200fcc:	f456                	sd	s5,40(sp)
ffffffffc0200fce:	f05a                	sd	s6,32(sp)
ffffffffc0200fd0:	ec5e                	sd	s7,24(sp)
ffffffffc0200fd2:	e862                	sd	s8,16(sp)
ffffffffc0200fd4:	e466                	sd	s9,8(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0200fd6:	2f278363          	beq	a5,s2,ffffffffc02012bc <default_check+0x30a>
    int count = 0, total = 0;
ffffffffc0200fda:	4401                	li	s0,0
ffffffffc0200fdc:	4481                	li	s1,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200fde:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200fe2:	8b09                	andi	a4,a4,2
ffffffffc0200fe4:	2e070063          	beqz	a4,ffffffffc02012c4 <default_check+0x312>
        count++, total += p->property;
ffffffffc0200fe8:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200fec:	679c                	ld	a5,8(a5)
ffffffffc0200fee:	2485                	addiw	s1,s1,1
ffffffffc0200ff0:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0200ff2:	ff2796e3          	bne	a5,s2,ffffffffc0200fde <default_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc0200ff6:	89a2                	mv	s3,s0
ffffffffc0200ff8:	741000ef          	jal	ffffffffc0201f38 <nr_free_pages>
ffffffffc0200ffc:	73351463          	bne	a0,s3,ffffffffc0201724 <default_check+0x772>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201000:	4505                	li	a0,1
ffffffffc0201002:	6c5000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc0201006:	8a2a                	mv	s4,a0
ffffffffc0201008:	44050e63          	beqz	a0,ffffffffc0201464 <default_check+0x4b2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020100c:	4505                	li	a0,1
ffffffffc020100e:	6b9000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc0201012:	89aa                	mv	s3,a0
ffffffffc0201014:	72050863          	beqz	a0,ffffffffc0201744 <default_check+0x792>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201018:	4505                	li	a0,1
ffffffffc020101a:	6ad000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc020101e:	8aaa                	mv	s5,a0
ffffffffc0201020:	4c050263          	beqz	a0,ffffffffc02014e4 <default_check+0x532>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201024:	40a987b3          	sub	a5,s3,a0
ffffffffc0201028:	40aa0733          	sub	a4,s4,a0
ffffffffc020102c:	0017b793          	seqz	a5,a5
ffffffffc0201030:	00173713          	seqz	a4,a4
ffffffffc0201034:	8fd9                	or	a5,a5,a4
ffffffffc0201036:	30079763          	bnez	a5,ffffffffc0201344 <default_check+0x392>
ffffffffc020103a:	313a0563          	beq	s4,s3,ffffffffc0201344 <default_check+0x392>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020103e:	000a2783          	lw	a5,0(s4)
ffffffffc0201042:	2a079163          	bnez	a5,ffffffffc02012e4 <default_check+0x332>
ffffffffc0201046:	0009a783          	lw	a5,0(s3)
ffffffffc020104a:	28079d63          	bnez	a5,ffffffffc02012e4 <default_check+0x332>
ffffffffc020104e:	411c                	lw	a5,0(a0)
ffffffffc0201050:	28079a63          	bnez	a5,ffffffffc02012e4 <default_check+0x332>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0201054:	0009a797          	auipc	a5,0x9a
ffffffffc0201058:	63c7b783          	ld	a5,1596(a5) # ffffffffc029b690 <pages>
ffffffffc020105c:	00007617          	auipc	a2,0x7
ffffffffc0201060:	99463603          	ld	a2,-1644(a2) # ffffffffc02079f0 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201064:	0009a697          	auipc	a3,0x9a
ffffffffc0201068:	6246b683          	ld	a3,1572(a3) # ffffffffc029b688 <npage>
ffffffffc020106c:	40fa0733          	sub	a4,s4,a5
ffffffffc0201070:	8719                	srai	a4,a4,0x6
ffffffffc0201072:	9732                	add	a4,a4,a2
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0201074:	0732                	slli	a4,a4,0xc
ffffffffc0201076:	06b2                	slli	a3,a3,0xc
ffffffffc0201078:	2ad77663          	bgeu	a4,a3,ffffffffc0201324 <default_check+0x372>
    return page - pages + nbase;
ffffffffc020107c:	40f98733          	sub	a4,s3,a5
ffffffffc0201080:	8719                	srai	a4,a4,0x6
ffffffffc0201082:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201084:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201086:	4cd77f63          	bgeu	a4,a3,ffffffffc0201564 <default_check+0x5b2>
    return page - pages + nbase;
ffffffffc020108a:	40f507b3          	sub	a5,a0,a5
ffffffffc020108e:	8799                	srai	a5,a5,0x6
ffffffffc0201090:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201092:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201094:	32d7f863          	bgeu	a5,a3,ffffffffc02013c4 <default_check+0x412>
    assert(alloc_page() == NULL);
ffffffffc0201098:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020109a:	00093c03          	ld	s8,0(s2)
ffffffffc020109e:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc02010a2:	00096b17          	auipc	s6,0x96
ffffffffc02010a6:	57eb2b03          	lw	s6,1406(s6) # ffffffffc0297620 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc02010aa:	01293023          	sd	s2,0(s2)
ffffffffc02010ae:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc02010b2:	00096797          	auipc	a5,0x96
ffffffffc02010b6:	5607a723          	sw	zero,1390(a5) # ffffffffc0297620 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc02010ba:	60d000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc02010be:	2e051363          	bnez	a0,ffffffffc02013a4 <default_check+0x3f2>
    free_page(p0);
ffffffffc02010c2:	8552                	mv	a0,s4
ffffffffc02010c4:	4585                	li	a1,1
ffffffffc02010c6:	63b000ef          	jal	ffffffffc0201f00 <free_pages>
    free_page(p1);
ffffffffc02010ca:	854e                	mv	a0,s3
ffffffffc02010cc:	4585                	li	a1,1
ffffffffc02010ce:	633000ef          	jal	ffffffffc0201f00 <free_pages>
    free_page(p2);
ffffffffc02010d2:	8556                	mv	a0,s5
ffffffffc02010d4:	4585                	li	a1,1
ffffffffc02010d6:	62b000ef          	jal	ffffffffc0201f00 <free_pages>
    assert(nr_free == 3);
ffffffffc02010da:	00096717          	auipc	a4,0x96
ffffffffc02010de:	54672703          	lw	a4,1350(a4) # ffffffffc0297620 <free_area+0x10>
ffffffffc02010e2:	478d                	li	a5,3
ffffffffc02010e4:	2af71063          	bne	a4,a5,ffffffffc0201384 <default_check+0x3d2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02010e8:	4505                	li	a0,1
ffffffffc02010ea:	5dd000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc02010ee:	89aa                	mv	s3,a0
ffffffffc02010f0:	26050a63          	beqz	a0,ffffffffc0201364 <default_check+0x3b2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02010f4:	4505                	li	a0,1
ffffffffc02010f6:	5d1000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc02010fa:	8aaa                	mv	s5,a0
ffffffffc02010fc:	3c050463          	beqz	a0,ffffffffc02014c4 <default_check+0x512>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201100:	4505                	li	a0,1
ffffffffc0201102:	5c5000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc0201106:	8a2a                	mv	s4,a0
ffffffffc0201108:	38050e63          	beqz	a0,ffffffffc02014a4 <default_check+0x4f2>
    assert(alloc_page() == NULL);
ffffffffc020110c:	4505                	li	a0,1
ffffffffc020110e:	5b9000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc0201112:	36051963          	bnez	a0,ffffffffc0201484 <default_check+0x4d2>
    free_page(p0);
ffffffffc0201116:	4585                	li	a1,1
ffffffffc0201118:	854e                	mv	a0,s3
ffffffffc020111a:	5e7000ef          	jal	ffffffffc0201f00 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc020111e:	00893783          	ld	a5,8(s2)
ffffffffc0201122:	1f278163          	beq	a5,s2,ffffffffc0201304 <default_check+0x352>
    assert((p = alloc_page()) == p0);
ffffffffc0201126:	4505                	li	a0,1
ffffffffc0201128:	59f000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc020112c:	8caa                	mv	s9,a0
ffffffffc020112e:	30a99b63          	bne	s3,a0,ffffffffc0201444 <default_check+0x492>
    assert(alloc_page() == NULL);
ffffffffc0201132:	4505                	li	a0,1
ffffffffc0201134:	593000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc0201138:	2e051663          	bnez	a0,ffffffffc0201424 <default_check+0x472>
    assert(nr_free == 0);
ffffffffc020113c:	00096797          	auipc	a5,0x96
ffffffffc0201140:	4e47a783          	lw	a5,1252(a5) # ffffffffc0297620 <free_area+0x10>
ffffffffc0201144:	2c079063          	bnez	a5,ffffffffc0201404 <default_check+0x452>
    free_page(p);
ffffffffc0201148:	8566                	mv	a0,s9
ffffffffc020114a:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc020114c:	01893023          	sd	s8,0(s2)
ffffffffc0201150:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc0201154:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc0201158:	5a9000ef          	jal	ffffffffc0201f00 <free_pages>
    free_page(p1);
ffffffffc020115c:	8556                	mv	a0,s5
ffffffffc020115e:	4585                	li	a1,1
ffffffffc0201160:	5a1000ef          	jal	ffffffffc0201f00 <free_pages>
    free_page(p2);
ffffffffc0201164:	8552                	mv	a0,s4
ffffffffc0201166:	4585                	li	a1,1
ffffffffc0201168:	599000ef          	jal	ffffffffc0201f00 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc020116c:	4515                	li	a0,5
ffffffffc020116e:	559000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc0201172:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0201174:	26050863          	beqz	a0,ffffffffc02013e4 <default_check+0x432>
ffffffffc0201178:	651c                	ld	a5,8(a0)
    assert(!PageProperty(p0));
ffffffffc020117a:	8b89                	andi	a5,a5,2
ffffffffc020117c:	54079463          	bnez	a5,ffffffffc02016c4 <default_check+0x712>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201180:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201182:	00093b83          	ld	s7,0(s2)
ffffffffc0201186:	00893b03          	ld	s6,8(s2)
ffffffffc020118a:	01293023          	sd	s2,0(s2)
ffffffffc020118e:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc0201192:	535000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc0201196:	50051763          	bnez	a0,ffffffffc02016a4 <default_check+0x6f2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc020119a:	08098a13          	addi	s4,s3,128
ffffffffc020119e:	8552                	mv	a0,s4
ffffffffc02011a0:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc02011a2:	00096c17          	auipc	s8,0x96
ffffffffc02011a6:	47ec2c03          	lw	s8,1150(s8) # ffffffffc0297620 <free_area+0x10>
    nr_free = 0;
ffffffffc02011aa:	00096797          	auipc	a5,0x96
ffffffffc02011ae:	4607ab23          	sw	zero,1142(a5) # ffffffffc0297620 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc02011b2:	54f000ef          	jal	ffffffffc0201f00 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc02011b6:	4511                	li	a0,4
ffffffffc02011b8:	50f000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc02011bc:	4c051463          	bnez	a0,ffffffffc0201684 <default_check+0x6d2>
ffffffffc02011c0:	0889b783          	ld	a5,136(s3)
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02011c4:	8b89                	andi	a5,a5,2
ffffffffc02011c6:	48078f63          	beqz	a5,ffffffffc0201664 <default_check+0x6b2>
ffffffffc02011ca:	0909a503          	lw	a0,144(s3)
ffffffffc02011ce:	478d                	li	a5,3
ffffffffc02011d0:	48f51a63          	bne	a0,a5,ffffffffc0201664 <default_check+0x6b2>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02011d4:	4f3000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc02011d8:	8aaa                	mv	s5,a0
ffffffffc02011da:	46050563          	beqz	a0,ffffffffc0201644 <default_check+0x692>
    assert(alloc_page() == NULL);
ffffffffc02011de:	4505                	li	a0,1
ffffffffc02011e0:	4e7000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc02011e4:	44051063          	bnez	a0,ffffffffc0201624 <default_check+0x672>
    assert(p0 + 2 == p1);
ffffffffc02011e8:	415a1e63          	bne	s4,s5,ffffffffc0201604 <default_check+0x652>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02011ec:	4585                	li	a1,1
ffffffffc02011ee:	854e                	mv	a0,s3
ffffffffc02011f0:	511000ef          	jal	ffffffffc0201f00 <free_pages>
    free_pages(p1, 3);
ffffffffc02011f4:	8552                	mv	a0,s4
ffffffffc02011f6:	458d                	li	a1,3
ffffffffc02011f8:	509000ef          	jal	ffffffffc0201f00 <free_pages>
ffffffffc02011fc:	0089b783          	ld	a5,8(s3)
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201200:	8b89                	andi	a5,a5,2
ffffffffc0201202:	3e078163          	beqz	a5,ffffffffc02015e4 <default_check+0x632>
ffffffffc0201206:	0109aa83          	lw	s5,16(s3)
ffffffffc020120a:	4785                	li	a5,1
ffffffffc020120c:	3cfa9c63          	bne	s5,a5,ffffffffc02015e4 <default_check+0x632>
ffffffffc0201210:	008a3783          	ld	a5,8(s4)
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201214:	8b89                	andi	a5,a5,2
ffffffffc0201216:	3a078763          	beqz	a5,ffffffffc02015c4 <default_check+0x612>
ffffffffc020121a:	010a2703          	lw	a4,16(s4)
ffffffffc020121e:	478d                	li	a5,3
ffffffffc0201220:	3af71263          	bne	a4,a5,ffffffffc02015c4 <default_check+0x612>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201224:	8556                	mv	a0,s5
ffffffffc0201226:	4a1000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc020122a:	36a99d63          	bne	s3,a0,ffffffffc02015a4 <default_check+0x5f2>
    free_page(p0);
ffffffffc020122e:	85d6                	mv	a1,s5
ffffffffc0201230:	4d1000ef          	jal	ffffffffc0201f00 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201234:	4509                	li	a0,2
ffffffffc0201236:	491000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc020123a:	34aa1563          	bne	s4,a0,ffffffffc0201584 <default_check+0x5d2>

    free_pages(p0, 2);
ffffffffc020123e:	4589                	li	a1,2
ffffffffc0201240:	4c1000ef          	jal	ffffffffc0201f00 <free_pages>
    free_page(p2);
ffffffffc0201244:	04098513          	addi	a0,s3,64
ffffffffc0201248:	85d6                	mv	a1,s5
ffffffffc020124a:	4b7000ef          	jal	ffffffffc0201f00 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020124e:	4515                	li	a0,5
ffffffffc0201250:	477000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc0201254:	89aa                	mv	s3,a0
ffffffffc0201256:	48050763          	beqz	a0,ffffffffc02016e4 <default_check+0x732>
    assert(alloc_page() == NULL);
ffffffffc020125a:	8556                	mv	a0,s5
ffffffffc020125c:	46b000ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc0201260:	2e051263          	bnez	a0,ffffffffc0201544 <default_check+0x592>

    assert(nr_free == 0);
ffffffffc0201264:	00096797          	auipc	a5,0x96
ffffffffc0201268:	3bc7a783          	lw	a5,956(a5) # ffffffffc0297620 <free_area+0x10>
ffffffffc020126c:	2a079c63          	bnez	a5,ffffffffc0201524 <default_check+0x572>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201270:	854e                	mv	a0,s3
ffffffffc0201272:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc0201274:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc0201278:	01793023          	sd	s7,0(s2)
ffffffffc020127c:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc0201280:	481000ef          	jal	ffffffffc0201f00 <free_pages>
    return listelm->next;
ffffffffc0201284:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201288:	01278963          	beq	a5,s2,ffffffffc020129a <default_check+0x2e8>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc020128c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201290:	679c                	ld	a5,8(a5)
ffffffffc0201292:	34fd                	addiw	s1,s1,-1
ffffffffc0201294:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201296:	ff279be3          	bne	a5,s2,ffffffffc020128c <default_check+0x2da>
    }
    assert(count == 0);
ffffffffc020129a:	26049563          	bnez	s1,ffffffffc0201504 <default_check+0x552>
    assert(total == 0);
ffffffffc020129e:	46041363          	bnez	s0,ffffffffc0201704 <default_check+0x752>
}
ffffffffc02012a2:	60e6                	ld	ra,88(sp)
ffffffffc02012a4:	6446                	ld	s0,80(sp)
ffffffffc02012a6:	64a6                	ld	s1,72(sp)
ffffffffc02012a8:	6906                	ld	s2,64(sp)
ffffffffc02012aa:	79e2                	ld	s3,56(sp)
ffffffffc02012ac:	7a42                	ld	s4,48(sp)
ffffffffc02012ae:	7aa2                	ld	s5,40(sp)
ffffffffc02012b0:	7b02                	ld	s6,32(sp)
ffffffffc02012b2:	6be2                	ld	s7,24(sp)
ffffffffc02012b4:	6c42                	ld	s8,16(sp)
ffffffffc02012b6:	6ca2                	ld	s9,8(sp)
ffffffffc02012b8:	6125                	addi	sp,sp,96
ffffffffc02012ba:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc02012bc:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02012be:	4401                	li	s0,0
ffffffffc02012c0:	4481                	li	s1,0
ffffffffc02012c2:	bb1d                	j	ffffffffc0200ff8 <default_check+0x46>
        assert(PageProperty(p));
ffffffffc02012c4:	00005697          	auipc	a3,0x5
ffffffffc02012c8:	f8c68693          	addi	a3,a3,-116 # ffffffffc0206250 <etext+0x9c0>
ffffffffc02012cc:	00005617          	auipc	a2,0x5
ffffffffc02012d0:	f9460613          	addi	a2,a2,-108 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02012d4:	11000593          	li	a1,272
ffffffffc02012d8:	00005517          	auipc	a0,0x5
ffffffffc02012dc:	fa050513          	addi	a0,a0,-96 # ffffffffc0206278 <etext+0x9e8>
ffffffffc02012e0:	966ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02012e4:	00005697          	auipc	a3,0x5
ffffffffc02012e8:	05468693          	addi	a3,a3,84 # ffffffffc0206338 <etext+0xaa8>
ffffffffc02012ec:	00005617          	auipc	a2,0x5
ffffffffc02012f0:	f7460613          	addi	a2,a2,-140 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02012f4:	0dc00593          	li	a1,220
ffffffffc02012f8:	00005517          	auipc	a0,0x5
ffffffffc02012fc:	f8050513          	addi	a0,a0,-128 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201300:	946ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201304:	00005697          	auipc	a3,0x5
ffffffffc0201308:	0fc68693          	addi	a3,a3,252 # ffffffffc0206400 <etext+0xb70>
ffffffffc020130c:	00005617          	auipc	a2,0x5
ffffffffc0201310:	f5460613          	addi	a2,a2,-172 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201314:	0f700593          	li	a1,247
ffffffffc0201318:	00005517          	auipc	a0,0x5
ffffffffc020131c:	f6050513          	addi	a0,a0,-160 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201320:	926ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201324:	00005697          	auipc	a3,0x5
ffffffffc0201328:	05468693          	addi	a3,a3,84 # ffffffffc0206378 <etext+0xae8>
ffffffffc020132c:	00005617          	auipc	a2,0x5
ffffffffc0201330:	f3460613          	addi	a2,a2,-204 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201334:	0de00593          	li	a1,222
ffffffffc0201338:	00005517          	auipc	a0,0x5
ffffffffc020133c:	f4050513          	addi	a0,a0,-192 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201340:	906ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201344:	00005697          	auipc	a3,0x5
ffffffffc0201348:	fcc68693          	addi	a3,a3,-52 # ffffffffc0206310 <etext+0xa80>
ffffffffc020134c:	00005617          	auipc	a2,0x5
ffffffffc0201350:	f1460613          	addi	a2,a2,-236 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201354:	0db00593          	li	a1,219
ffffffffc0201358:	00005517          	auipc	a0,0x5
ffffffffc020135c:	f2050513          	addi	a0,a0,-224 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201360:	8e6ff0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201364:	00005697          	auipc	a3,0x5
ffffffffc0201368:	f4c68693          	addi	a3,a3,-180 # ffffffffc02062b0 <etext+0xa20>
ffffffffc020136c:	00005617          	auipc	a2,0x5
ffffffffc0201370:	ef460613          	addi	a2,a2,-268 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201374:	0f000593          	li	a1,240
ffffffffc0201378:	00005517          	auipc	a0,0x5
ffffffffc020137c:	f0050513          	addi	a0,a0,-256 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201380:	8c6ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free == 3);
ffffffffc0201384:	00005697          	auipc	a3,0x5
ffffffffc0201388:	06c68693          	addi	a3,a3,108 # ffffffffc02063f0 <etext+0xb60>
ffffffffc020138c:	00005617          	auipc	a2,0x5
ffffffffc0201390:	ed460613          	addi	a2,a2,-300 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201394:	0ee00593          	li	a1,238
ffffffffc0201398:	00005517          	auipc	a0,0x5
ffffffffc020139c:	ee050513          	addi	a0,a0,-288 # ffffffffc0206278 <etext+0x9e8>
ffffffffc02013a0:	8a6ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013a4:	00005697          	auipc	a3,0x5
ffffffffc02013a8:	03468693          	addi	a3,a3,52 # ffffffffc02063d8 <etext+0xb48>
ffffffffc02013ac:	00005617          	auipc	a2,0x5
ffffffffc02013b0:	eb460613          	addi	a2,a2,-332 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02013b4:	0e900593          	li	a1,233
ffffffffc02013b8:	00005517          	auipc	a0,0x5
ffffffffc02013bc:	ec050513          	addi	a0,a0,-320 # ffffffffc0206278 <etext+0x9e8>
ffffffffc02013c0:	886ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02013c4:	00005697          	auipc	a3,0x5
ffffffffc02013c8:	ff468693          	addi	a3,a3,-12 # ffffffffc02063b8 <etext+0xb28>
ffffffffc02013cc:	00005617          	auipc	a2,0x5
ffffffffc02013d0:	e9460613          	addi	a2,a2,-364 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02013d4:	0e000593          	li	a1,224
ffffffffc02013d8:	00005517          	auipc	a0,0x5
ffffffffc02013dc:	ea050513          	addi	a0,a0,-352 # ffffffffc0206278 <etext+0x9e8>
ffffffffc02013e0:	866ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(p0 != NULL);
ffffffffc02013e4:	00005697          	auipc	a3,0x5
ffffffffc02013e8:	06468693          	addi	a3,a3,100 # ffffffffc0206448 <etext+0xbb8>
ffffffffc02013ec:	00005617          	auipc	a2,0x5
ffffffffc02013f0:	e7460613          	addi	a2,a2,-396 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02013f4:	11800593          	li	a1,280
ffffffffc02013f8:	00005517          	auipc	a0,0x5
ffffffffc02013fc:	e8050513          	addi	a0,a0,-384 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201400:	846ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free == 0);
ffffffffc0201404:	00005697          	auipc	a3,0x5
ffffffffc0201408:	03468693          	addi	a3,a3,52 # ffffffffc0206438 <etext+0xba8>
ffffffffc020140c:	00005617          	auipc	a2,0x5
ffffffffc0201410:	e5460613          	addi	a2,a2,-428 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201414:	0fd00593          	li	a1,253
ffffffffc0201418:	00005517          	auipc	a0,0x5
ffffffffc020141c:	e6050513          	addi	a0,a0,-416 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201420:	826ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201424:	00005697          	auipc	a3,0x5
ffffffffc0201428:	fb468693          	addi	a3,a3,-76 # ffffffffc02063d8 <etext+0xb48>
ffffffffc020142c:	00005617          	auipc	a2,0x5
ffffffffc0201430:	e3460613          	addi	a2,a2,-460 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201434:	0fb00593          	li	a1,251
ffffffffc0201438:	00005517          	auipc	a0,0x5
ffffffffc020143c:	e4050513          	addi	a0,a0,-448 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201440:	806ff0ef          	jal	ffffffffc0200446 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201444:	00005697          	auipc	a3,0x5
ffffffffc0201448:	fd468693          	addi	a3,a3,-44 # ffffffffc0206418 <etext+0xb88>
ffffffffc020144c:	00005617          	auipc	a2,0x5
ffffffffc0201450:	e1460613          	addi	a2,a2,-492 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201454:	0fa00593          	li	a1,250
ffffffffc0201458:	00005517          	auipc	a0,0x5
ffffffffc020145c:	e2050513          	addi	a0,a0,-480 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201460:	fe7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201464:	00005697          	auipc	a3,0x5
ffffffffc0201468:	e4c68693          	addi	a3,a3,-436 # ffffffffc02062b0 <etext+0xa20>
ffffffffc020146c:	00005617          	auipc	a2,0x5
ffffffffc0201470:	df460613          	addi	a2,a2,-524 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201474:	0d700593          	li	a1,215
ffffffffc0201478:	00005517          	auipc	a0,0x5
ffffffffc020147c:	e0050513          	addi	a0,a0,-512 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201480:	fc7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201484:	00005697          	auipc	a3,0x5
ffffffffc0201488:	f5468693          	addi	a3,a3,-172 # ffffffffc02063d8 <etext+0xb48>
ffffffffc020148c:	00005617          	auipc	a2,0x5
ffffffffc0201490:	dd460613          	addi	a2,a2,-556 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201494:	0f400593          	li	a1,244
ffffffffc0201498:	00005517          	auipc	a0,0x5
ffffffffc020149c:	de050513          	addi	a0,a0,-544 # ffffffffc0206278 <etext+0x9e8>
ffffffffc02014a0:	fa7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014a4:	00005697          	auipc	a3,0x5
ffffffffc02014a8:	e4c68693          	addi	a3,a3,-436 # ffffffffc02062f0 <etext+0xa60>
ffffffffc02014ac:	00005617          	auipc	a2,0x5
ffffffffc02014b0:	db460613          	addi	a2,a2,-588 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02014b4:	0f200593          	li	a1,242
ffffffffc02014b8:	00005517          	auipc	a0,0x5
ffffffffc02014bc:	dc050513          	addi	a0,a0,-576 # ffffffffc0206278 <etext+0x9e8>
ffffffffc02014c0:	f87fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02014c4:	00005697          	auipc	a3,0x5
ffffffffc02014c8:	e0c68693          	addi	a3,a3,-500 # ffffffffc02062d0 <etext+0xa40>
ffffffffc02014cc:	00005617          	auipc	a2,0x5
ffffffffc02014d0:	d9460613          	addi	a2,a2,-620 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02014d4:	0f100593          	li	a1,241
ffffffffc02014d8:	00005517          	auipc	a0,0x5
ffffffffc02014dc:	da050513          	addi	a0,a0,-608 # ffffffffc0206278 <etext+0x9e8>
ffffffffc02014e0:	f67fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014e4:	00005697          	auipc	a3,0x5
ffffffffc02014e8:	e0c68693          	addi	a3,a3,-500 # ffffffffc02062f0 <etext+0xa60>
ffffffffc02014ec:	00005617          	auipc	a2,0x5
ffffffffc02014f0:	d7460613          	addi	a2,a2,-652 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02014f4:	0d900593          	li	a1,217
ffffffffc02014f8:	00005517          	auipc	a0,0x5
ffffffffc02014fc:	d8050513          	addi	a0,a0,-640 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201500:	f47fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(count == 0);
ffffffffc0201504:	00005697          	auipc	a3,0x5
ffffffffc0201508:	09468693          	addi	a3,a3,148 # ffffffffc0206598 <etext+0xd08>
ffffffffc020150c:	00005617          	auipc	a2,0x5
ffffffffc0201510:	d5460613          	addi	a2,a2,-684 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201514:	14600593          	li	a1,326
ffffffffc0201518:	00005517          	auipc	a0,0x5
ffffffffc020151c:	d6050513          	addi	a0,a0,-672 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201520:	f27fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free == 0);
ffffffffc0201524:	00005697          	auipc	a3,0x5
ffffffffc0201528:	f1468693          	addi	a3,a3,-236 # ffffffffc0206438 <etext+0xba8>
ffffffffc020152c:	00005617          	auipc	a2,0x5
ffffffffc0201530:	d3460613          	addi	a2,a2,-716 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201534:	13a00593          	li	a1,314
ffffffffc0201538:	00005517          	auipc	a0,0x5
ffffffffc020153c:	d4050513          	addi	a0,a0,-704 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201540:	f07fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201544:	00005697          	auipc	a3,0x5
ffffffffc0201548:	e9468693          	addi	a3,a3,-364 # ffffffffc02063d8 <etext+0xb48>
ffffffffc020154c:	00005617          	auipc	a2,0x5
ffffffffc0201550:	d1460613          	addi	a2,a2,-748 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201554:	13800593          	li	a1,312
ffffffffc0201558:	00005517          	auipc	a0,0x5
ffffffffc020155c:	d2050513          	addi	a0,a0,-736 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201560:	ee7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201564:	00005697          	auipc	a3,0x5
ffffffffc0201568:	e3468693          	addi	a3,a3,-460 # ffffffffc0206398 <etext+0xb08>
ffffffffc020156c:	00005617          	auipc	a2,0x5
ffffffffc0201570:	cf460613          	addi	a2,a2,-780 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201574:	0df00593          	li	a1,223
ffffffffc0201578:	00005517          	auipc	a0,0x5
ffffffffc020157c:	d0050513          	addi	a0,a0,-768 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201580:	ec7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201584:	00005697          	auipc	a3,0x5
ffffffffc0201588:	fd468693          	addi	a3,a3,-44 # ffffffffc0206558 <etext+0xcc8>
ffffffffc020158c:	00005617          	auipc	a2,0x5
ffffffffc0201590:	cd460613          	addi	a2,a2,-812 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201594:	13200593          	li	a1,306
ffffffffc0201598:	00005517          	auipc	a0,0x5
ffffffffc020159c:	ce050513          	addi	a0,a0,-800 # ffffffffc0206278 <etext+0x9e8>
ffffffffc02015a0:	ea7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02015a4:	00005697          	auipc	a3,0x5
ffffffffc02015a8:	f9468693          	addi	a3,a3,-108 # ffffffffc0206538 <etext+0xca8>
ffffffffc02015ac:	00005617          	auipc	a2,0x5
ffffffffc02015b0:	cb460613          	addi	a2,a2,-844 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02015b4:	13000593          	li	a1,304
ffffffffc02015b8:	00005517          	auipc	a0,0x5
ffffffffc02015bc:	cc050513          	addi	a0,a0,-832 # ffffffffc0206278 <etext+0x9e8>
ffffffffc02015c0:	e87fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02015c4:	00005697          	auipc	a3,0x5
ffffffffc02015c8:	f4c68693          	addi	a3,a3,-180 # ffffffffc0206510 <etext+0xc80>
ffffffffc02015cc:	00005617          	auipc	a2,0x5
ffffffffc02015d0:	c9460613          	addi	a2,a2,-876 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02015d4:	12e00593          	li	a1,302
ffffffffc02015d8:	00005517          	auipc	a0,0x5
ffffffffc02015dc:	ca050513          	addi	a0,a0,-864 # ffffffffc0206278 <etext+0x9e8>
ffffffffc02015e0:	e67fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02015e4:	00005697          	auipc	a3,0x5
ffffffffc02015e8:	f0468693          	addi	a3,a3,-252 # ffffffffc02064e8 <etext+0xc58>
ffffffffc02015ec:	00005617          	auipc	a2,0x5
ffffffffc02015f0:	c7460613          	addi	a2,a2,-908 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02015f4:	12d00593          	li	a1,301
ffffffffc02015f8:	00005517          	auipc	a0,0x5
ffffffffc02015fc:	c8050513          	addi	a0,a0,-896 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201600:	e47fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201604:	00005697          	auipc	a3,0x5
ffffffffc0201608:	ed468693          	addi	a3,a3,-300 # ffffffffc02064d8 <etext+0xc48>
ffffffffc020160c:	00005617          	auipc	a2,0x5
ffffffffc0201610:	c5460613          	addi	a2,a2,-940 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201614:	12800593          	li	a1,296
ffffffffc0201618:	00005517          	auipc	a0,0x5
ffffffffc020161c:	c6050513          	addi	a0,a0,-928 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201620:	e27fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201624:	00005697          	auipc	a3,0x5
ffffffffc0201628:	db468693          	addi	a3,a3,-588 # ffffffffc02063d8 <etext+0xb48>
ffffffffc020162c:	00005617          	auipc	a2,0x5
ffffffffc0201630:	c3460613          	addi	a2,a2,-972 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201634:	12700593          	li	a1,295
ffffffffc0201638:	00005517          	auipc	a0,0x5
ffffffffc020163c:	c4050513          	addi	a0,a0,-960 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201640:	e07fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201644:	00005697          	auipc	a3,0x5
ffffffffc0201648:	e7468693          	addi	a3,a3,-396 # ffffffffc02064b8 <etext+0xc28>
ffffffffc020164c:	00005617          	auipc	a2,0x5
ffffffffc0201650:	c1460613          	addi	a2,a2,-1004 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201654:	12600593          	li	a1,294
ffffffffc0201658:	00005517          	auipc	a0,0x5
ffffffffc020165c:	c2050513          	addi	a0,a0,-992 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201660:	de7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201664:	00005697          	auipc	a3,0x5
ffffffffc0201668:	e2468693          	addi	a3,a3,-476 # ffffffffc0206488 <etext+0xbf8>
ffffffffc020166c:	00005617          	auipc	a2,0x5
ffffffffc0201670:	bf460613          	addi	a2,a2,-1036 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201674:	12500593          	li	a1,293
ffffffffc0201678:	00005517          	auipc	a0,0x5
ffffffffc020167c:	c0050513          	addi	a0,a0,-1024 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201680:	dc7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201684:	00005697          	auipc	a3,0x5
ffffffffc0201688:	dec68693          	addi	a3,a3,-532 # ffffffffc0206470 <etext+0xbe0>
ffffffffc020168c:	00005617          	auipc	a2,0x5
ffffffffc0201690:	bd460613          	addi	a2,a2,-1068 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201694:	12400593          	li	a1,292
ffffffffc0201698:	00005517          	auipc	a0,0x5
ffffffffc020169c:	be050513          	addi	a0,a0,-1056 # ffffffffc0206278 <etext+0x9e8>
ffffffffc02016a0:	da7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02016a4:	00005697          	auipc	a3,0x5
ffffffffc02016a8:	d3468693          	addi	a3,a3,-716 # ffffffffc02063d8 <etext+0xb48>
ffffffffc02016ac:	00005617          	auipc	a2,0x5
ffffffffc02016b0:	bb460613          	addi	a2,a2,-1100 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02016b4:	11e00593          	li	a1,286
ffffffffc02016b8:	00005517          	auipc	a0,0x5
ffffffffc02016bc:	bc050513          	addi	a0,a0,-1088 # ffffffffc0206278 <etext+0x9e8>
ffffffffc02016c0:	d87fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(!PageProperty(p0));
ffffffffc02016c4:	00005697          	auipc	a3,0x5
ffffffffc02016c8:	d9468693          	addi	a3,a3,-620 # ffffffffc0206458 <etext+0xbc8>
ffffffffc02016cc:	00005617          	auipc	a2,0x5
ffffffffc02016d0:	b9460613          	addi	a2,a2,-1132 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02016d4:	11900593          	li	a1,281
ffffffffc02016d8:	00005517          	auipc	a0,0x5
ffffffffc02016dc:	ba050513          	addi	a0,a0,-1120 # ffffffffc0206278 <etext+0x9e8>
ffffffffc02016e0:	d67fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02016e4:	00005697          	auipc	a3,0x5
ffffffffc02016e8:	e9468693          	addi	a3,a3,-364 # ffffffffc0206578 <etext+0xce8>
ffffffffc02016ec:	00005617          	auipc	a2,0x5
ffffffffc02016f0:	b7460613          	addi	a2,a2,-1164 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02016f4:	13700593          	li	a1,311
ffffffffc02016f8:	00005517          	auipc	a0,0x5
ffffffffc02016fc:	b8050513          	addi	a0,a0,-1152 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201700:	d47fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(total == 0);
ffffffffc0201704:	00005697          	auipc	a3,0x5
ffffffffc0201708:	ea468693          	addi	a3,a3,-348 # ffffffffc02065a8 <etext+0xd18>
ffffffffc020170c:	00005617          	auipc	a2,0x5
ffffffffc0201710:	b5460613          	addi	a2,a2,-1196 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201714:	14700593          	li	a1,327
ffffffffc0201718:	00005517          	auipc	a0,0x5
ffffffffc020171c:	b6050513          	addi	a0,a0,-1184 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201720:	d27fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(total == nr_free_pages());
ffffffffc0201724:	00005697          	auipc	a3,0x5
ffffffffc0201728:	b6c68693          	addi	a3,a3,-1172 # ffffffffc0206290 <etext+0xa00>
ffffffffc020172c:	00005617          	auipc	a2,0x5
ffffffffc0201730:	b3460613          	addi	a2,a2,-1228 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201734:	11300593          	li	a1,275
ffffffffc0201738:	00005517          	auipc	a0,0x5
ffffffffc020173c:	b4050513          	addi	a0,a0,-1216 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201740:	d07fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201744:	00005697          	auipc	a3,0x5
ffffffffc0201748:	b8c68693          	addi	a3,a3,-1140 # ffffffffc02062d0 <etext+0xa40>
ffffffffc020174c:	00005617          	auipc	a2,0x5
ffffffffc0201750:	b1460613          	addi	a2,a2,-1260 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201754:	0d800593          	li	a1,216
ffffffffc0201758:	00005517          	auipc	a0,0x5
ffffffffc020175c:	b2050513          	addi	a0,a0,-1248 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201760:	ce7fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201764 <default_free_pages>:
{
ffffffffc0201764:	1141                	addi	sp,sp,-16
ffffffffc0201766:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201768:	14058663          	beqz	a1,ffffffffc02018b4 <default_free_pages+0x150>
    for (; p != base + n; p++)
ffffffffc020176c:	00659713          	slli	a4,a1,0x6
ffffffffc0201770:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201774:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc0201776:	c30d                	beqz	a4,ffffffffc0201798 <default_free_pages+0x34>
ffffffffc0201778:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020177a:	8b05                	andi	a4,a4,1
ffffffffc020177c:	10071c63          	bnez	a4,ffffffffc0201894 <default_free_pages+0x130>
ffffffffc0201780:	6798                	ld	a4,8(a5)
ffffffffc0201782:	8b09                	andi	a4,a4,2
ffffffffc0201784:	10071863          	bnez	a4,ffffffffc0201894 <default_free_pages+0x130>
        p->flags = 0;
ffffffffc0201788:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc020178c:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201790:	04078793          	addi	a5,a5,64
ffffffffc0201794:	fed792e3          	bne	a5,a3,ffffffffc0201778 <default_free_pages+0x14>
    base->property = n;
ffffffffc0201798:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc020179a:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020179e:	4789                	li	a5,2
ffffffffc02017a0:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02017a4:	00096717          	auipc	a4,0x96
ffffffffc02017a8:	e7c72703          	lw	a4,-388(a4) # ffffffffc0297620 <free_area+0x10>
ffffffffc02017ac:	00096697          	auipc	a3,0x96
ffffffffc02017b0:	e6468693          	addi	a3,a3,-412 # ffffffffc0297610 <free_area>
    return list->next == list;
ffffffffc02017b4:	669c                	ld	a5,8(a3)
ffffffffc02017b6:	9f2d                	addw	a4,a4,a1
ffffffffc02017b8:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc02017ba:	0ad78163          	beq	a5,a3,ffffffffc020185c <default_free_pages+0xf8>
            struct Page *page = le2page(le, page_link);
ffffffffc02017be:	fe878713          	addi	a4,a5,-24
ffffffffc02017c2:	4581                	li	a1,0
ffffffffc02017c4:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc02017c8:	00e56a63          	bltu	a0,a4,ffffffffc02017dc <default_free_pages+0x78>
    return listelm->next;
ffffffffc02017cc:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02017ce:	04d70c63          	beq	a4,a3,ffffffffc0201826 <default_free_pages+0xc2>
    struct Page *p = base;
ffffffffc02017d2:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02017d4:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02017d8:	fee57ae3          	bgeu	a0,a4,ffffffffc02017cc <default_free_pages+0x68>
ffffffffc02017dc:	c199                	beqz	a1,ffffffffc02017e2 <default_free_pages+0x7e>
ffffffffc02017de:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02017e2:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02017e4:	e390                	sd	a2,0(a5)
ffffffffc02017e6:	e710                	sd	a2,8(a4)
    elm->next = next;
    elm->prev = prev;
ffffffffc02017e8:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc02017ea:	f11c                	sd	a5,32(a0)
    if (le != &free_list)
ffffffffc02017ec:	00d70d63          	beq	a4,a3,ffffffffc0201806 <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc02017f0:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc02017f4:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc02017f8:	02059813          	slli	a6,a1,0x20
ffffffffc02017fc:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201800:	97b2                	add	a5,a5,a2
ffffffffc0201802:	02f50c63          	beq	a0,a5,ffffffffc020183a <default_free_pages+0xd6>
    return listelm->next;
ffffffffc0201806:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc0201808:	00d78c63          	beq	a5,a3,ffffffffc0201820 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc020180c:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc020180e:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0201812:	02061593          	slli	a1,a2,0x20
ffffffffc0201816:	01a5d713          	srli	a4,a1,0x1a
ffffffffc020181a:	972a                	add	a4,a4,a0
ffffffffc020181c:	04e68c63          	beq	a3,a4,ffffffffc0201874 <default_free_pages+0x110>
}
ffffffffc0201820:	60a2                	ld	ra,8(sp)
ffffffffc0201822:	0141                	addi	sp,sp,16
ffffffffc0201824:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201826:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201828:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020182a:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020182c:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc020182e:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc0201830:	02d70f63          	beq	a4,a3,ffffffffc020186e <default_free_pages+0x10a>
ffffffffc0201834:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc0201836:	87ba                	mv	a5,a4
ffffffffc0201838:	bf71                	j	ffffffffc02017d4 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc020183a:	491c                	lw	a5,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020183c:	5875                	li	a6,-3
ffffffffc020183e:	9fad                	addw	a5,a5,a1
ffffffffc0201840:	fef72c23          	sw	a5,-8(a4)
ffffffffc0201844:	6108b02f          	amoand.d	zero,a6,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201848:	01853803          	ld	a6,24(a0)
ffffffffc020184c:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc020184e:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201850:	00b83423          	sd	a1,8(a6) # ff0008 <_binary_obj___user_exit_out_size+0xfe5e48>
    return listelm->next;
ffffffffc0201854:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0201856:	0105b023          	sd	a6,0(a1)
ffffffffc020185a:	b77d                	j	ffffffffc0201808 <default_free_pages+0xa4>
}
ffffffffc020185c:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc020185e:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201862:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201864:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0201866:	e398                	sd	a4,0(a5)
ffffffffc0201868:	e798                	sd	a4,8(a5)
}
ffffffffc020186a:	0141                	addi	sp,sp,16
ffffffffc020186c:	8082                	ret
ffffffffc020186e:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc0201870:	873e                	mv	a4,a5
ffffffffc0201872:	bfad                	j	ffffffffc02017ec <default_free_pages+0x88>
            base->property += p->property;
ffffffffc0201874:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201878:	56f5                	li	a3,-3
ffffffffc020187a:	9f31                	addw	a4,a4,a2
ffffffffc020187c:	c918                	sw	a4,16(a0)
ffffffffc020187e:	ff078713          	addi	a4,a5,-16
ffffffffc0201882:	60d7302f          	amoand.d	zero,a3,(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201886:	6398                	ld	a4,0(a5)
ffffffffc0201888:	679c                	ld	a5,8(a5)
}
ffffffffc020188a:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020188c:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020188e:	e398                	sd	a4,0(a5)
ffffffffc0201890:	0141                	addi	sp,sp,16
ffffffffc0201892:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201894:	00005697          	auipc	a3,0x5
ffffffffc0201898:	d2c68693          	addi	a3,a3,-724 # ffffffffc02065c0 <etext+0xd30>
ffffffffc020189c:	00005617          	auipc	a2,0x5
ffffffffc02018a0:	9c460613          	addi	a2,a2,-1596 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02018a4:	09400593          	li	a1,148
ffffffffc02018a8:	00005517          	auipc	a0,0x5
ffffffffc02018ac:	9d050513          	addi	a0,a0,-1584 # ffffffffc0206278 <etext+0x9e8>
ffffffffc02018b0:	b97fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(n > 0);
ffffffffc02018b4:	00005697          	auipc	a3,0x5
ffffffffc02018b8:	d0468693          	addi	a3,a3,-764 # ffffffffc02065b8 <etext+0xd28>
ffffffffc02018bc:	00005617          	auipc	a2,0x5
ffffffffc02018c0:	9a460613          	addi	a2,a2,-1628 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02018c4:	09000593          	li	a1,144
ffffffffc02018c8:	00005517          	auipc	a0,0x5
ffffffffc02018cc:	9b050513          	addi	a0,a0,-1616 # ffffffffc0206278 <etext+0x9e8>
ffffffffc02018d0:	b77fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02018d4 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02018d4:	c951                	beqz	a0,ffffffffc0201968 <default_alloc_pages+0x94>
    if (n > nr_free)
ffffffffc02018d6:	00096597          	auipc	a1,0x96
ffffffffc02018da:	d4a5a583          	lw	a1,-694(a1) # ffffffffc0297620 <free_area+0x10>
ffffffffc02018de:	86aa                	mv	a3,a0
ffffffffc02018e0:	02059793          	slli	a5,a1,0x20
ffffffffc02018e4:	9381                	srli	a5,a5,0x20
ffffffffc02018e6:	00a7ef63          	bltu	a5,a0,ffffffffc0201904 <default_alloc_pages+0x30>
    list_entry_t *le = &free_list;
ffffffffc02018ea:	00096617          	auipc	a2,0x96
ffffffffc02018ee:	d2660613          	addi	a2,a2,-730 # ffffffffc0297610 <free_area>
ffffffffc02018f2:	87b2                	mv	a5,a2
ffffffffc02018f4:	a029                	j	ffffffffc02018fe <default_alloc_pages+0x2a>
        if (p->property >= n)
ffffffffc02018f6:	ff87e703          	lwu	a4,-8(a5)
ffffffffc02018fa:	00d77763          	bgeu	a4,a3,ffffffffc0201908 <default_alloc_pages+0x34>
    return listelm->next;
ffffffffc02018fe:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201900:	fec79be3          	bne	a5,a2,ffffffffc02018f6 <default_alloc_pages+0x22>
        return NULL;
ffffffffc0201904:	4501                	li	a0,0
}
ffffffffc0201906:	8082                	ret
        if (page->property > n)
ffffffffc0201908:	ff87a883          	lw	a7,-8(a5)
    return listelm->prev;
ffffffffc020190c:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201910:	6798                	ld	a4,8(a5)
ffffffffc0201912:	02089313          	slli	t1,a7,0x20
ffffffffc0201916:	02035313          	srli	t1,t1,0x20
    prev->next = next;
ffffffffc020191a:	00e83423          	sd	a4,8(a6)
    next->prev = prev;
ffffffffc020191e:	01073023          	sd	a6,0(a4)
        struct Page *p = le2page(le, page_link);
ffffffffc0201922:	fe878513          	addi	a0,a5,-24
        if (page->property > n)
ffffffffc0201926:	0266fa63          	bgeu	a3,t1,ffffffffc020195a <default_alloc_pages+0x86>
            struct Page *p = page + n;
ffffffffc020192a:	00669713          	slli	a4,a3,0x6
            p->property = page->property - n;
ffffffffc020192e:	40d888bb          	subw	a7,a7,a3
            struct Page *p = page + n;
ffffffffc0201932:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201934:	01172823          	sw	a7,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201938:	00870313          	addi	t1,a4,8
ffffffffc020193c:	4889                	li	a7,2
ffffffffc020193e:	4113302f          	amoor.d	zero,a7,(t1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201942:	00883883          	ld	a7,8(a6)
            list_add(prev, &(p->page_link));
ffffffffc0201946:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc020194a:	0068b023          	sd	t1,0(a7)
ffffffffc020194e:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc0201952:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc0201956:	01073c23          	sd	a6,24(a4)
        nr_free -= n;
ffffffffc020195a:	9d95                	subw	a1,a1,a3
ffffffffc020195c:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020195e:	5775                	li	a4,-3
ffffffffc0201960:	17c1                	addi	a5,a5,-16
ffffffffc0201962:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201966:	8082                	ret
{
ffffffffc0201968:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020196a:	00005697          	auipc	a3,0x5
ffffffffc020196e:	c4e68693          	addi	a3,a3,-946 # ffffffffc02065b8 <etext+0xd28>
ffffffffc0201972:	00005617          	auipc	a2,0x5
ffffffffc0201976:	8ee60613          	addi	a2,a2,-1810 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020197a:	06c00593          	li	a1,108
ffffffffc020197e:	00005517          	auipc	a0,0x5
ffffffffc0201982:	8fa50513          	addi	a0,a0,-1798 # ffffffffc0206278 <etext+0x9e8>
{
ffffffffc0201986:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201988:	abffe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020198c <default_init_memmap>:
{
ffffffffc020198c:	1141                	addi	sp,sp,-16
ffffffffc020198e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201990:	c9e1                	beqz	a1,ffffffffc0201a60 <default_init_memmap+0xd4>
    for (; p != base + n; p++)
ffffffffc0201992:	00659713          	slli	a4,a1,0x6
ffffffffc0201996:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc020199a:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc020199c:	cf11                	beqz	a4,ffffffffc02019b8 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020199e:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02019a0:	8b05                	andi	a4,a4,1
ffffffffc02019a2:	cf59                	beqz	a4,ffffffffc0201a40 <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc02019a4:	0007a823          	sw	zero,16(a5)
ffffffffc02019a8:	0007b423          	sd	zero,8(a5)
ffffffffc02019ac:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02019b0:	04078793          	addi	a5,a5,64
ffffffffc02019b4:	fed795e3          	bne	a5,a3,ffffffffc020199e <default_init_memmap+0x12>
    base->property = n;
ffffffffc02019b8:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02019ba:	4789                	li	a5,2
ffffffffc02019bc:	00850713          	addi	a4,a0,8
ffffffffc02019c0:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02019c4:	00096717          	auipc	a4,0x96
ffffffffc02019c8:	c5c72703          	lw	a4,-932(a4) # ffffffffc0297620 <free_area+0x10>
ffffffffc02019cc:	00096697          	auipc	a3,0x96
ffffffffc02019d0:	c4468693          	addi	a3,a3,-956 # ffffffffc0297610 <free_area>
    return list->next == list;
ffffffffc02019d4:	669c                	ld	a5,8(a3)
ffffffffc02019d6:	9f2d                	addw	a4,a4,a1
ffffffffc02019d8:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc02019da:	04d78663          	beq	a5,a3,ffffffffc0201a26 <default_init_memmap+0x9a>
            struct Page *page = le2page(le, page_link);
ffffffffc02019de:	fe878713          	addi	a4,a5,-24
ffffffffc02019e2:	4581                	li	a1,0
ffffffffc02019e4:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc02019e8:	00e56a63          	bltu	a0,a4,ffffffffc02019fc <default_init_memmap+0x70>
    return listelm->next;
ffffffffc02019ec:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02019ee:	02d70263          	beq	a4,a3,ffffffffc0201a12 <default_init_memmap+0x86>
    struct Page *p = base;
ffffffffc02019f2:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02019f4:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02019f8:	fee57ae3          	bgeu	a0,a4,ffffffffc02019ec <default_init_memmap+0x60>
ffffffffc02019fc:	c199                	beqz	a1,ffffffffc0201a02 <default_init_memmap+0x76>
ffffffffc02019fe:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201a02:	6398                	ld	a4,0(a5)
}
ffffffffc0201a04:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201a06:	e390                	sd	a2,0(a5)
ffffffffc0201a08:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc0201a0a:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0201a0c:	f11c                	sd	a5,32(a0)
ffffffffc0201a0e:	0141                	addi	sp,sp,16
ffffffffc0201a10:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201a12:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a14:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201a16:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201a18:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201a1a:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc0201a1c:	00d70e63          	beq	a4,a3,ffffffffc0201a38 <default_init_memmap+0xac>
ffffffffc0201a20:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc0201a22:	87ba                	mv	a5,a4
ffffffffc0201a24:	bfc1                	j	ffffffffc02019f4 <default_init_memmap+0x68>
}
ffffffffc0201a26:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201a28:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201a2c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a2e:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0201a30:	e398                	sd	a4,0(a5)
ffffffffc0201a32:	e798                	sd	a4,8(a5)
}
ffffffffc0201a34:	0141                	addi	sp,sp,16
ffffffffc0201a36:	8082                	ret
ffffffffc0201a38:	60a2                	ld	ra,8(sp)
ffffffffc0201a3a:	e290                	sd	a2,0(a3)
ffffffffc0201a3c:	0141                	addi	sp,sp,16
ffffffffc0201a3e:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201a40:	00005697          	auipc	a3,0x5
ffffffffc0201a44:	ba868693          	addi	a3,a3,-1112 # ffffffffc02065e8 <etext+0xd58>
ffffffffc0201a48:	00005617          	auipc	a2,0x5
ffffffffc0201a4c:	81860613          	addi	a2,a2,-2024 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201a50:	04b00593          	li	a1,75
ffffffffc0201a54:	00005517          	auipc	a0,0x5
ffffffffc0201a58:	82450513          	addi	a0,a0,-2012 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201a5c:	9ebfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(n > 0);
ffffffffc0201a60:	00005697          	auipc	a3,0x5
ffffffffc0201a64:	b5868693          	addi	a3,a3,-1192 # ffffffffc02065b8 <etext+0xd28>
ffffffffc0201a68:	00004617          	auipc	a2,0x4
ffffffffc0201a6c:	7f860613          	addi	a2,a2,2040 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201a70:	04700593          	li	a1,71
ffffffffc0201a74:	00005517          	auipc	a0,0x5
ffffffffc0201a78:	80450513          	addi	a0,a0,-2044 # ffffffffc0206278 <etext+0x9e8>
ffffffffc0201a7c:	9cbfe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201a80 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201a80:	c531                	beqz	a0,ffffffffc0201acc <slob_free+0x4c>
		return;

	if (size)
ffffffffc0201a82:	e9b9                	bnez	a1,ffffffffc0201ad8 <slob_free+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a84:	100027f3          	csrr	a5,sstatus
ffffffffc0201a88:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201a8a:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a8c:	efb1                	bnez	a5,ffffffffc0201ae8 <slob_free+0x68>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201a8e:	00095797          	auipc	a5,0x95
ffffffffc0201a92:	7727b783          	ld	a5,1906(a5) # ffffffffc0297200 <slobfree>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201a96:	873e                	mv	a4,a5
ffffffffc0201a98:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201a9a:	02a77a63          	bgeu	a4,a0,ffffffffc0201ace <slob_free+0x4e>
ffffffffc0201a9e:	00f56463          	bltu	a0,a5,ffffffffc0201aa6 <slob_free+0x26>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201aa2:	fef76ae3          	bltu	a4,a5,ffffffffc0201a96 <slob_free+0x16>
			break;

	if (b + b->units == cur->next)
ffffffffc0201aa6:	4110                	lw	a2,0(a0)
ffffffffc0201aa8:	00461693          	slli	a3,a2,0x4
ffffffffc0201aac:	96aa                	add	a3,a3,a0
ffffffffc0201aae:	0ad78463          	beq	a5,a3,ffffffffc0201b56 <slob_free+0xd6>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201ab2:	4310                	lw	a2,0(a4)
ffffffffc0201ab4:	e51c                	sd	a5,8(a0)
ffffffffc0201ab6:	00461693          	slli	a3,a2,0x4
ffffffffc0201aba:	96ba                	add	a3,a3,a4
ffffffffc0201abc:	08d50163          	beq	a0,a3,ffffffffc0201b3e <slob_free+0xbe>
ffffffffc0201ac0:	e708                	sd	a0,8(a4)
		cur->next = b->next;
	}
	else
		cur->next = b;

	slobfree = cur;
ffffffffc0201ac2:	00095797          	auipc	a5,0x95
ffffffffc0201ac6:	72e7bf23          	sd	a4,1854(a5) # ffffffffc0297200 <slobfree>
    if (flag)
ffffffffc0201aca:	e9a5                	bnez	a1,ffffffffc0201b3a <slob_free+0xba>
ffffffffc0201acc:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201ace:	fcf574e3          	bgeu	a0,a5,ffffffffc0201a96 <slob_free+0x16>
ffffffffc0201ad2:	fcf762e3          	bltu	a4,a5,ffffffffc0201a96 <slob_free+0x16>
ffffffffc0201ad6:	bfc1                	j	ffffffffc0201aa6 <slob_free+0x26>
		b->units = SLOB_UNITS(size);
ffffffffc0201ad8:	25bd                	addiw	a1,a1,15
ffffffffc0201ada:	8191                	srli	a1,a1,0x4
ffffffffc0201adc:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ade:	100027f3          	csrr	a5,sstatus
ffffffffc0201ae2:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201ae4:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ae6:	d7c5                	beqz	a5,ffffffffc0201a8e <slob_free+0xe>
{
ffffffffc0201ae8:	1101                	addi	sp,sp,-32
ffffffffc0201aea:	e42a                	sd	a0,8(sp)
ffffffffc0201aec:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201aee:	e17fe0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0201af2:	6522                	ld	a0,8(sp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201af4:	00095797          	auipc	a5,0x95
ffffffffc0201af8:	70c7b783          	ld	a5,1804(a5) # ffffffffc0297200 <slobfree>
ffffffffc0201afc:	4585                	li	a1,1
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201afe:	873e                	mv	a4,a5
ffffffffc0201b00:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201b02:	06a77663          	bgeu	a4,a0,ffffffffc0201b6e <slob_free+0xee>
ffffffffc0201b06:	00f56463          	bltu	a0,a5,ffffffffc0201b0e <slob_free+0x8e>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b0a:	fef76ae3          	bltu	a4,a5,ffffffffc0201afe <slob_free+0x7e>
	if (b + b->units == cur->next)
ffffffffc0201b0e:	4110                	lw	a2,0(a0)
ffffffffc0201b10:	00461693          	slli	a3,a2,0x4
ffffffffc0201b14:	96aa                	add	a3,a3,a0
ffffffffc0201b16:	06d78363          	beq	a5,a3,ffffffffc0201b7c <slob_free+0xfc>
	if (cur + cur->units == b)
ffffffffc0201b1a:	4310                	lw	a2,0(a4)
ffffffffc0201b1c:	e51c                	sd	a5,8(a0)
ffffffffc0201b1e:	00461693          	slli	a3,a2,0x4
ffffffffc0201b22:	96ba                	add	a3,a3,a4
ffffffffc0201b24:	06d50163          	beq	a0,a3,ffffffffc0201b86 <slob_free+0x106>
ffffffffc0201b28:	e708                	sd	a0,8(a4)
	slobfree = cur;
ffffffffc0201b2a:	00095797          	auipc	a5,0x95
ffffffffc0201b2e:	6ce7bb23          	sd	a4,1750(a5) # ffffffffc0297200 <slobfree>
    if (flag)
ffffffffc0201b32:	e1a9                	bnez	a1,ffffffffc0201b74 <slob_free+0xf4>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201b34:	60e2                	ld	ra,24(sp)
ffffffffc0201b36:	6105                	addi	sp,sp,32
ffffffffc0201b38:	8082                	ret
        intr_enable();
ffffffffc0201b3a:	dc5fe06f          	j	ffffffffc02008fe <intr_enable>
		cur->units += b->units;
ffffffffc0201b3e:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201b40:	853e                	mv	a0,a5
ffffffffc0201b42:	e708                	sd	a0,8(a4)
		cur->units += b->units;
ffffffffc0201b44:	00c687bb          	addw	a5,a3,a2
ffffffffc0201b48:	c31c                	sw	a5,0(a4)
	slobfree = cur;
ffffffffc0201b4a:	00095797          	auipc	a5,0x95
ffffffffc0201b4e:	6ae7bb23          	sd	a4,1718(a5) # ffffffffc0297200 <slobfree>
    if (flag)
ffffffffc0201b52:	ddad                	beqz	a1,ffffffffc0201acc <slob_free+0x4c>
ffffffffc0201b54:	b7dd                	j	ffffffffc0201b3a <slob_free+0xba>
		b->units += cur->next->units;
ffffffffc0201b56:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201b58:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201b5a:	9eb1                	addw	a3,a3,a2
ffffffffc0201b5c:	c114                	sw	a3,0(a0)
	if (cur + cur->units == b)
ffffffffc0201b5e:	4310                	lw	a2,0(a4)
ffffffffc0201b60:	e51c                	sd	a5,8(a0)
ffffffffc0201b62:	00461693          	slli	a3,a2,0x4
ffffffffc0201b66:	96ba                	add	a3,a3,a4
ffffffffc0201b68:	f4d51ce3          	bne	a0,a3,ffffffffc0201ac0 <slob_free+0x40>
ffffffffc0201b6c:	bfc9                	j	ffffffffc0201b3e <slob_free+0xbe>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b6e:	f8f56ee3          	bltu	a0,a5,ffffffffc0201b0a <slob_free+0x8a>
ffffffffc0201b72:	b771                	j	ffffffffc0201afe <slob_free+0x7e>
}
ffffffffc0201b74:	60e2                	ld	ra,24(sp)
ffffffffc0201b76:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201b78:	d87fe06f          	j	ffffffffc02008fe <intr_enable>
		b->units += cur->next->units;
ffffffffc0201b7c:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201b7e:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201b80:	9eb1                	addw	a3,a3,a2
ffffffffc0201b82:	c114                	sw	a3,0(a0)
		b->next = cur->next->next;
ffffffffc0201b84:	bf59                	j	ffffffffc0201b1a <slob_free+0x9a>
		cur->units += b->units;
ffffffffc0201b86:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201b88:	853e                	mv	a0,a5
		cur->units += b->units;
ffffffffc0201b8a:	00c687bb          	addw	a5,a3,a2
ffffffffc0201b8e:	c31c                	sw	a5,0(a4)
		cur->next = b->next;
ffffffffc0201b90:	bf61                	j	ffffffffc0201b28 <slob_free+0xa8>

ffffffffc0201b92 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b92:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201b94:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b96:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201b9a:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b9c:	32a000ef          	jal	ffffffffc0201ec6 <alloc_pages>
	if (!page)
ffffffffc0201ba0:	c91d                	beqz	a0,ffffffffc0201bd6 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201ba2:	0009a697          	auipc	a3,0x9a
ffffffffc0201ba6:	aee6b683          	ld	a3,-1298(a3) # ffffffffc029b690 <pages>
ffffffffc0201baa:	00006797          	auipc	a5,0x6
ffffffffc0201bae:	e467b783          	ld	a5,-442(a5) # ffffffffc02079f0 <nbase>
    return KADDR(page2pa(page));
ffffffffc0201bb2:	0009a717          	auipc	a4,0x9a
ffffffffc0201bb6:	ad673703          	ld	a4,-1322(a4) # ffffffffc029b688 <npage>
    return page - pages + nbase;
ffffffffc0201bba:	8d15                	sub	a0,a0,a3
ffffffffc0201bbc:	8519                	srai	a0,a0,0x6
ffffffffc0201bbe:	953e                	add	a0,a0,a5
    return KADDR(page2pa(page));
ffffffffc0201bc0:	00c51793          	slli	a5,a0,0xc
ffffffffc0201bc4:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201bc6:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201bc8:	00e7fa63          	bgeu	a5,a4,ffffffffc0201bdc <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201bcc:	0009a797          	auipc	a5,0x9a
ffffffffc0201bd0:	ab47b783          	ld	a5,-1356(a5) # ffffffffc029b680 <va_pa_offset>
ffffffffc0201bd4:	953e                	add	a0,a0,a5
}
ffffffffc0201bd6:	60a2                	ld	ra,8(sp)
ffffffffc0201bd8:	0141                	addi	sp,sp,16
ffffffffc0201bda:	8082                	ret
ffffffffc0201bdc:	86aa                	mv	a3,a0
ffffffffc0201bde:	00005617          	auipc	a2,0x5
ffffffffc0201be2:	a3260613          	addi	a2,a2,-1486 # ffffffffc0206610 <etext+0xd80>
ffffffffc0201be6:	07100593          	li	a1,113
ffffffffc0201bea:	00005517          	auipc	a0,0x5
ffffffffc0201bee:	a4e50513          	addi	a0,a0,-1458 # ffffffffc0206638 <etext+0xda8>
ffffffffc0201bf2:	855fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201bf6 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201bf6:	7179                	addi	sp,sp,-48
ffffffffc0201bf8:	f406                	sd	ra,40(sp)
ffffffffc0201bfa:	f022                	sd	s0,32(sp)
ffffffffc0201bfc:	ec26                	sd	s1,24(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201bfe:	01050713          	addi	a4,a0,16
ffffffffc0201c02:	6785                	lui	a5,0x1
ffffffffc0201c04:	0af77e63          	bgeu	a4,a5,ffffffffc0201cc0 <slob_alloc.constprop.0+0xca>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201c08:	00f50413          	addi	s0,a0,15
ffffffffc0201c0c:	8011                	srli	s0,s0,0x4
ffffffffc0201c0e:	2401                	sext.w	s0,s0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c10:	100025f3          	csrr	a1,sstatus
ffffffffc0201c14:	8989                	andi	a1,a1,2
ffffffffc0201c16:	edd1                	bnez	a1,ffffffffc0201cb2 <slob_alloc.constprop.0+0xbc>
	prev = slobfree;
ffffffffc0201c18:	00095497          	auipc	s1,0x95
ffffffffc0201c1c:	5e848493          	addi	s1,s1,1512 # ffffffffc0297200 <slobfree>
ffffffffc0201c20:	6090                	ld	a2,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c22:	6618                	ld	a4,8(a2)
		if (cur->units >= units + delta)
ffffffffc0201c24:	4314                	lw	a3,0(a4)
ffffffffc0201c26:	0886da63          	bge	a3,s0,ffffffffc0201cba <slob_alloc.constprop.0+0xc4>
		if (cur == slobfree)
ffffffffc0201c2a:	00e60a63          	beq	a2,a4,ffffffffc0201c3e <slob_alloc.constprop.0+0x48>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c2e:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201c30:	4394                	lw	a3,0(a5)
ffffffffc0201c32:	0286d863          	bge	a3,s0,ffffffffc0201c62 <slob_alloc.constprop.0+0x6c>
		if (cur == slobfree)
ffffffffc0201c36:	6090                	ld	a2,0(s1)
ffffffffc0201c38:	873e                	mv	a4,a5
ffffffffc0201c3a:	fee61ae3          	bne	a2,a4,ffffffffc0201c2e <slob_alloc.constprop.0+0x38>
    if (flag)
ffffffffc0201c3e:	e9b1                	bnez	a1,ffffffffc0201c92 <slob_alloc.constprop.0+0x9c>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201c40:	4501                	li	a0,0
ffffffffc0201c42:	f51ff0ef          	jal	ffffffffc0201b92 <__slob_get_free_pages.constprop.0>
ffffffffc0201c46:	87aa                	mv	a5,a0
			if (!cur)
ffffffffc0201c48:	c915                	beqz	a0,ffffffffc0201c7c <slob_alloc.constprop.0+0x86>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201c4a:	6585                	lui	a1,0x1
ffffffffc0201c4c:	e35ff0ef          	jal	ffffffffc0201a80 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c50:	100025f3          	csrr	a1,sstatus
ffffffffc0201c54:	8989                	andi	a1,a1,2
ffffffffc0201c56:	e98d                	bnez	a1,ffffffffc0201c88 <slob_alloc.constprop.0+0x92>
			cur = slobfree;
ffffffffc0201c58:	6098                	ld	a4,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c5a:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201c5c:	4394                	lw	a3,0(a5)
ffffffffc0201c5e:	fc86cce3          	blt	a3,s0,ffffffffc0201c36 <slob_alloc.constprop.0+0x40>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201c62:	04d40563          	beq	s0,a3,ffffffffc0201cac <slob_alloc.constprop.0+0xb6>
				prev->next = cur + units;
ffffffffc0201c66:	00441613          	slli	a2,s0,0x4
ffffffffc0201c6a:	963e                	add	a2,a2,a5
ffffffffc0201c6c:	e710                	sd	a2,8(a4)
				prev->next->next = cur->next;
ffffffffc0201c6e:	6788                	ld	a0,8(a5)
				prev->next->units = cur->units - units;
ffffffffc0201c70:	9e81                	subw	a3,a3,s0
ffffffffc0201c72:	c214                	sw	a3,0(a2)
				prev->next->next = cur->next;
ffffffffc0201c74:	e608                	sd	a0,8(a2)
				cur->units = units;
ffffffffc0201c76:	c380                	sw	s0,0(a5)
			slobfree = prev;
ffffffffc0201c78:	e098                	sd	a4,0(s1)
    if (flag)
ffffffffc0201c7a:	ed99                	bnez	a1,ffffffffc0201c98 <slob_alloc.constprop.0+0xa2>
}
ffffffffc0201c7c:	70a2                	ld	ra,40(sp)
ffffffffc0201c7e:	7402                	ld	s0,32(sp)
ffffffffc0201c80:	64e2                	ld	s1,24(sp)
ffffffffc0201c82:	853e                	mv	a0,a5
ffffffffc0201c84:	6145                	addi	sp,sp,48
ffffffffc0201c86:	8082                	ret
        intr_disable();
ffffffffc0201c88:	c7dfe0ef          	jal	ffffffffc0200904 <intr_disable>
			cur = slobfree;
ffffffffc0201c8c:	6098                	ld	a4,0(s1)
        return 1;
ffffffffc0201c8e:	4585                	li	a1,1
ffffffffc0201c90:	b7e9                	j	ffffffffc0201c5a <slob_alloc.constprop.0+0x64>
        intr_enable();
ffffffffc0201c92:	c6dfe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201c96:	b76d                	j	ffffffffc0201c40 <slob_alloc.constprop.0+0x4a>
ffffffffc0201c98:	e43e                	sd	a5,8(sp)
ffffffffc0201c9a:	c65fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201c9e:	67a2                	ld	a5,8(sp)
}
ffffffffc0201ca0:	70a2                	ld	ra,40(sp)
ffffffffc0201ca2:	7402                	ld	s0,32(sp)
ffffffffc0201ca4:	64e2                	ld	s1,24(sp)
ffffffffc0201ca6:	853e                	mv	a0,a5
ffffffffc0201ca8:	6145                	addi	sp,sp,48
ffffffffc0201caa:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201cac:	6794                	ld	a3,8(a5)
ffffffffc0201cae:	e714                	sd	a3,8(a4)
ffffffffc0201cb0:	b7e1                	j	ffffffffc0201c78 <slob_alloc.constprop.0+0x82>
        intr_disable();
ffffffffc0201cb2:	c53fe0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0201cb6:	4585                	li	a1,1
ffffffffc0201cb8:	b785                	j	ffffffffc0201c18 <slob_alloc.constprop.0+0x22>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201cba:	87ba                	mv	a5,a4
	prev = slobfree;
ffffffffc0201cbc:	8732                	mv	a4,a2
ffffffffc0201cbe:	b755                	j	ffffffffc0201c62 <slob_alloc.constprop.0+0x6c>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201cc0:	00005697          	auipc	a3,0x5
ffffffffc0201cc4:	98868693          	addi	a3,a3,-1656 # ffffffffc0206648 <etext+0xdb8>
ffffffffc0201cc8:	00004617          	auipc	a2,0x4
ffffffffc0201ccc:	59860613          	addi	a2,a2,1432 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0201cd0:	06300593          	li	a1,99
ffffffffc0201cd4:	00005517          	auipc	a0,0x5
ffffffffc0201cd8:	99450513          	addi	a0,a0,-1644 # ffffffffc0206668 <etext+0xdd8>
ffffffffc0201cdc:	f6afe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201ce0 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201ce0:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201ce2:	00005517          	auipc	a0,0x5
ffffffffc0201ce6:	99e50513          	addi	a0,a0,-1634 # ffffffffc0206680 <etext+0xdf0>
{
ffffffffc0201cea:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201cec:	ca8fe0ef          	jal	ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201cf0:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201cf2:	00005517          	auipc	a0,0x5
ffffffffc0201cf6:	9a650513          	addi	a0,a0,-1626 # ffffffffc0206698 <etext+0xe08>
}
ffffffffc0201cfa:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201cfc:	c98fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201d00 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201d00:	4501                	li	a0,0
ffffffffc0201d02:	8082                	ret

ffffffffc0201d04 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201d04:	1101                	addi	sp,sp,-32
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d06:	6685                	lui	a3,0x1
{
ffffffffc0201d08:	ec06                	sd	ra,24(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d0a:	16bd                	addi	a3,a3,-17 # fef <_binary_obj___user_softint_out_size-0x7bd9>
ffffffffc0201d0c:	04a6f963          	bgeu	a3,a0,ffffffffc0201d5e <kmalloc+0x5a>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201d10:	e42a                	sd	a0,8(sp)
ffffffffc0201d12:	4561                	li	a0,24
ffffffffc0201d14:	e822                	sd	s0,16(sp)
ffffffffc0201d16:	ee1ff0ef          	jal	ffffffffc0201bf6 <slob_alloc.constprop.0>
ffffffffc0201d1a:	842a                	mv	s0,a0
	if (!bb)
ffffffffc0201d1c:	c541                	beqz	a0,ffffffffc0201da4 <kmalloc+0xa0>
	bb->order = find_order(size);
ffffffffc0201d1e:	47a2                	lw	a5,8(sp)
	for (; size > 4096; size >>= 1)
ffffffffc0201d20:	6705                	lui	a4,0x1
	int order = 0;
ffffffffc0201d22:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201d24:	00f75763          	bge	a4,a5,ffffffffc0201d32 <kmalloc+0x2e>
ffffffffc0201d28:	4017d79b          	sraiw	a5,a5,0x1
		order++;
ffffffffc0201d2c:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201d2e:	fef74de3          	blt	a4,a5,ffffffffc0201d28 <kmalloc+0x24>
	bb->order = find_order(size);
ffffffffc0201d32:	c008                	sw	a0,0(s0)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201d34:	e5fff0ef          	jal	ffffffffc0201b92 <__slob_get_free_pages.constprop.0>
ffffffffc0201d38:	e408                	sd	a0,8(s0)
	if (bb->pages)
ffffffffc0201d3a:	cd31                	beqz	a0,ffffffffc0201d96 <kmalloc+0x92>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d3c:	100027f3          	csrr	a5,sstatus
ffffffffc0201d40:	8b89                	andi	a5,a5,2
ffffffffc0201d42:	eb85                	bnez	a5,ffffffffc0201d72 <kmalloc+0x6e>
		bb->next = bigblocks;
ffffffffc0201d44:	0009a797          	auipc	a5,0x9a
ffffffffc0201d48:	91c7b783          	ld	a5,-1764(a5) # ffffffffc029b660 <bigblocks>
		bigblocks = bb;
ffffffffc0201d4c:	0009a717          	auipc	a4,0x9a
ffffffffc0201d50:	90873a23          	sd	s0,-1772(a4) # ffffffffc029b660 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201d54:	e81c                	sd	a5,16(s0)
    if (flag)
ffffffffc0201d56:	6442                	ld	s0,16(sp)
	return __kmalloc(size, 0);
}
ffffffffc0201d58:	60e2                	ld	ra,24(sp)
ffffffffc0201d5a:	6105                	addi	sp,sp,32
ffffffffc0201d5c:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201d5e:	0541                	addi	a0,a0,16
ffffffffc0201d60:	e97ff0ef          	jal	ffffffffc0201bf6 <slob_alloc.constprop.0>
ffffffffc0201d64:	87aa                	mv	a5,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0201d66:	0541                	addi	a0,a0,16
ffffffffc0201d68:	fbe5                	bnez	a5,ffffffffc0201d58 <kmalloc+0x54>
		return 0;
ffffffffc0201d6a:	4501                	li	a0,0
}
ffffffffc0201d6c:	60e2                	ld	ra,24(sp)
ffffffffc0201d6e:	6105                	addi	sp,sp,32
ffffffffc0201d70:	8082                	ret
        intr_disable();
ffffffffc0201d72:	b93fe0ef          	jal	ffffffffc0200904 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201d76:	0009a797          	auipc	a5,0x9a
ffffffffc0201d7a:	8ea7b783          	ld	a5,-1814(a5) # ffffffffc029b660 <bigblocks>
		bigblocks = bb;
ffffffffc0201d7e:	0009a717          	auipc	a4,0x9a
ffffffffc0201d82:	8e873123          	sd	s0,-1822(a4) # ffffffffc029b660 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201d86:	e81c                	sd	a5,16(s0)
        intr_enable();
ffffffffc0201d88:	b77fe0ef          	jal	ffffffffc02008fe <intr_enable>
		return bb->pages;
ffffffffc0201d8c:	6408                	ld	a0,8(s0)
}
ffffffffc0201d8e:	60e2                	ld	ra,24(sp)
		return bb->pages;
ffffffffc0201d90:	6442                	ld	s0,16(sp)
}
ffffffffc0201d92:	6105                	addi	sp,sp,32
ffffffffc0201d94:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d96:	8522                	mv	a0,s0
ffffffffc0201d98:	45e1                	li	a1,24
ffffffffc0201d9a:	ce7ff0ef          	jal	ffffffffc0201a80 <slob_free>
		return 0;
ffffffffc0201d9e:	4501                	li	a0,0
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201da0:	6442                	ld	s0,16(sp)
ffffffffc0201da2:	b7e9                	j	ffffffffc0201d6c <kmalloc+0x68>
ffffffffc0201da4:	6442                	ld	s0,16(sp)
		return 0;
ffffffffc0201da6:	4501                	li	a0,0
ffffffffc0201da8:	b7d1                	j	ffffffffc0201d6c <kmalloc+0x68>

ffffffffc0201daa <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201daa:	c571                	beqz	a0,ffffffffc0201e76 <kfree+0xcc>
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201dac:	03451793          	slli	a5,a0,0x34
ffffffffc0201db0:	e3e1                	bnez	a5,ffffffffc0201e70 <kfree+0xc6>
{
ffffffffc0201db2:	1101                	addi	sp,sp,-32
ffffffffc0201db4:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201db6:	100027f3          	csrr	a5,sstatus
ffffffffc0201dba:	8b89                	andi	a5,a5,2
ffffffffc0201dbc:	e7c1                	bnez	a5,ffffffffc0201e44 <kfree+0x9a>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201dbe:	0009a797          	auipc	a5,0x9a
ffffffffc0201dc2:	8a27b783          	ld	a5,-1886(a5) # ffffffffc029b660 <bigblocks>
    return 0;
ffffffffc0201dc6:	4581                	li	a1,0
ffffffffc0201dc8:	cbad                	beqz	a5,ffffffffc0201e3a <kfree+0x90>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201dca:	0009a617          	auipc	a2,0x9a
ffffffffc0201dce:	89660613          	addi	a2,a2,-1898 # ffffffffc029b660 <bigblocks>
ffffffffc0201dd2:	a021                	j	ffffffffc0201dda <kfree+0x30>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201dd4:	01070613          	addi	a2,a4,16
ffffffffc0201dd8:	c3a5                	beqz	a5,ffffffffc0201e38 <kfree+0x8e>
		{
			if (bb->pages == block)
ffffffffc0201dda:	6794                	ld	a3,8(a5)
ffffffffc0201ddc:	873e                	mv	a4,a5
			{
				*last = bb->next;
ffffffffc0201dde:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201de0:	fea69ae3          	bne	a3,a0,ffffffffc0201dd4 <kfree+0x2a>
				*last = bb->next;
ffffffffc0201de4:	e21c                	sd	a5,0(a2)
    if (flag)
ffffffffc0201de6:	edb5                	bnez	a1,ffffffffc0201e62 <kfree+0xb8>
    return pa2page(PADDR(kva));
ffffffffc0201de8:	c02007b7          	lui	a5,0xc0200
ffffffffc0201dec:	0af56263          	bltu	a0,a5,ffffffffc0201e90 <kfree+0xe6>
ffffffffc0201df0:	0009a797          	auipc	a5,0x9a
ffffffffc0201df4:	8907b783          	ld	a5,-1904(a5) # ffffffffc029b680 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0201df8:	0009a697          	auipc	a3,0x9a
ffffffffc0201dfc:	8906b683          	ld	a3,-1904(a3) # ffffffffc029b688 <npage>
    return pa2page(PADDR(kva));
ffffffffc0201e00:	8d1d                	sub	a0,a0,a5
    if (PPN(pa) >= npage)
ffffffffc0201e02:	00c55793          	srli	a5,a0,0xc
ffffffffc0201e06:	06d7f963          	bgeu	a5,a3,ffffffffc0201e78 <kfree+0xce>
    return &pages[PPN(pa) - nbase];
ffffffffc0201e0a:	00006617          	auipc	a2,0x6
ffffffffc0201e0e:	be663603          	ld	a2,-1050(a2) # ffffffffc02079f0 <nbase>
ffffffffc0201e12:	0009a517          	auipc	a0,0x9a
ffffffffc0201e16:	87e53503          	ld	a0,-1922(a0) # ffffffffc029b690 <pages>
	free_pages(kva2page((void *)kva), 1 << order);
ffffffffc0201e1a:	4314                	lw	a3,0(a4)
ffffffffc0201e1c:	8f91                	sub	a5,a5,a2
ffffffffc0201e1e:	079a                	slli	a5,a5,0x6
ffffffffc0201e20:	4585                	li	a1,1
ffffffffc0201e22:	953e                	add	a0,a0,a5
ffffffffc0201e24:	00d595bb          	sllw	a1,a1,a3
ffffffffc0201e28:	e03a                	sd	a4,0(sp)
ffffffffc0201e2a:	0d6000ef          	jal	ffffffffc0201f00 <free_pages>
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e2e:	6502                	ld	a0,0(sp)
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201e30:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e32:	45e1                	li	a1,24
}
ffffffffc0201e34:	6105                	addi	sp,sp,32
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e36:	b1a9                	j	ffffffffc0201a80 <slob_free>
ffffffffc0201e38:	e185                	bnez	a1,ffffffffc0201e58 <kfree+0xae>
}
ffffffffc0201e3a:	60e2                	ld	ra,24(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e3c:	1541                	addi	a0,a0,-16
ffffffffc0201e3e:	4581                	li	a1,0
}
ffffffffc0201e40:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e42:	b93d                	j	ffffffffc0201a80 <slob_free>
        intr_disable();
ffffffffc0201e44:	e02a                	sd	a0,0(sp)
ffffffffc0201e46:	abffe0ef          	jal	ffffffffc0200904 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e4a:	0009a797          	auipc	a5,0x9a
ffffffffc0201e4e:	8167b783          	ld	a5,-2026(a5) # ffffffffc029b660 <bigblocks>
ffffffffc0201e52:	6502                	ld	a0,0(sp)
        return 1;
ffffffffc0201e54:	4585                	li	a1,1
ffffffffc0201e56:	fbb5                	bnez	a5,ffffffffc0201dca <kfree+0x20>
ffffffffc0201e58:	e02a                	sd	a0,0(sp)
        intr_enable();
ffffffffc0201e5a:	aa5fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201e5e:	6502                	ld	a0,0(sp)
ffffffffc0201e60:	bfe9                	j	ffffffffc0201e3a <kfree+0x90>
ffffffffc0201e62:	e42a                	sd	a0,8(sp)
ffffffffc0201e64:	e03a                	sd	a4,0(sp)
ffffffffc0201e66:	a99fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201e6a:	6522                	ld	a0,8(sp)
ffffffffc0201e6c:	6702                	ld	a4,0(sp)
ffffffffc0201e6e:	bfad                	j	ffffffffc0201de8 <kfree+0x3e>
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e70:	1541                	addi	a0,a0,-16
ffffffffc0201e72:	4581                	li	a1,0
ffffffffc0201e74:	b131                	j	ffffffffc0201a80 <slob_free>
ffffffffc0201e76:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201e78:	00005617          	auipc	a2,0x5
ffffffffc0201e7c:	86860613          	addi	a2,a2,-1944 # ffffffffc02066e0 <etext+0xe50>
ffffffffc0201e80:	06900593          	li	a1,105
ffffffffc0201e84:	00004517          	auipc	a0,0x4
ffffffffc0201e88:	7b450513          	addi	a0,a0,1972 # ffffffffc0206638 <etext+0xda8>
ffffffffc0201e8c:	dbafe0ef          	jal	ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201e90:	86aa                	mv	a3,a0
ffffffffc0201e92:	00005617          	auipc	a2,0x5
ffffffffc0201e96:	82660613          	addi	a2,a2,-2010 # ffffffffc02066b8 <etext+0xe28>
ffffffffc0201e9a:	07700593          	li	a1,119
ffffffffc0201e9e:	00004517          	auipc	a0,0x4
ffffffffc0201ea2:	79a50513          	addi	a0,a0,1946 # ffffffffc0206638 <etext+0xda8>
ffffffffc0201ea6:	da0fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201eaa <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201eaa:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201eac:	00005617          	auipc	a2,0x5
ffffffffc0201eb0:	83460613          	addi	a2,a2,-1996 # ffffffffc02066e0 <etext+0xe50>
ffffffffc0201eb4:	06900593          	li	a1,105
ffffffffc0201eb8:	00004517          	auipc	a0,0x4
ffffffffc0201ebc:	78050513          	addi	a0,a0,1920 # ffffffffc0206638 <etext+0xda8>
pa2page(uintptr_t pa)
ffffffffc0201ec0:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201ec2:	d84fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201ec6 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ec6:	100027f3          	csrr	a5,sstatus
ffffffffc0201eca:	8b89                	andi	a5,a5,2
ffffffffc0201ecc:	e799                	bnez	a5,ffffffffc0201eda <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ece:	00099797          	auipc	a5,0x99
ffffffffc0201ed2:	79a7b783          	ld	a5,1946(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc0201ed6:	6f9c                	ld	a5,24(a5)
ffffffffc0201ed8:	8782                	jr	a5
{
ffffffffc0201eda:	1101                	addi	sp,sp,-32
ffffffffc0201edc:	ec06                	sd	ra,24(sp)
ffffffffc0201ede:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201ee0:	a25fe0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ee4:	00099797          	auipc	a5,0x99
ffffffffc0201ee8:	7847b783          	ld	a5,1924(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc0201eec:	6522                	ld	a0,8(sp)
ffffffffc0201eee:	6f9c                	ld	a5,24(a5)
ffffffffc0201ef0:	9782                	jalr	a5
ffffffffc0201ef2:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201ef4:	a0bfe0ef          	jal	ffffffffc02008fe <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201ef8:	60e2                	ld	ra,24(sp)
ffffffffc0201efa:	6522                	ld	a0,8(sp)
ffffffffc0201efc:	6105                	addi	sp,sp,32
ffffffffc0201efe:	8082                	ret

ffffffffc0201f00 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f00:	100027f3          	csrr	a5,sstatus
ffffffffc0201f04:	8b89                	andi	a5,a5,2
ffffffffc0201f06:	e799                	bnez	a5,ffffffffc0201f14 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201f08:	00099797          	auipc	a5,0x99
ffffffffc0201f0c:	7607b783          	ld	a5,1888(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc0201f10:	739c                	ld	a5,32(a5)
ffffffffc0201f12:	8782                	jr	a5
{
ffffffffc0201f14:	1101                	addi	sp,sp,-32
ffffffffc0201f16:	ec06                	sd	ra,24(sp)
ffffffffc0201f18:	e42e                	sd	a1,8(sp)
ffffffffc0201f1a:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0201f1c:	9e9fe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201f20:	00099797          	auipc	a5,0x99
ffffffffc0201f24:	7487b783          	ld	a5,1864(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc0201f28:	65a2                	ld	a1,8(sp)
ffffffffc0201f2a:	6502                	ld	a0,0(sp)
ffffffffc0201f2c:	739c                	ld	a5,32(a5)
ffffffffc0201f2e:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201f30:	60e2                	ld	ra,24(sp)
ffffffffc0201f32:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201f34:	9cbfe06f          	j	ffffffffc02008fe <intr_enable>

ffffffffc0201f38 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f38:	100027f3          	csrr	a5,sstatus
ffffffffc0201f3c:	8b89                	andi	a5,a5,2
ffffffffc0201f3e:	e799                	bnez	a5,ffffffffc0201f4c <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f40:	00099797          	auipc	a5,0x99
ffffffffc0201f44:	7287b783          	ld	a5,1832(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc0201f48:	779c                	ld	a5,40(a5)
ffffffffc0201f4a:	8782                	jr	a5
{
ffffffffc0201f4c:	1101                	addi	sp,sp,-32
ffffffffc0201f4e:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201f50:	9b5fe0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f54:	00099797          	auipc	a5,0x99
ffffffffc0201f58:	7147b783          	ld	a5,1812(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc0201f5c:	779c                	ld	a5,40(a5)
ffffffffc0201f5e:	9782                	jalr	a5
ffffffffc0201f60:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201f62:	99dfe0ef          	jal	ffffffffc02008fe <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201f66:	60e2                	ld	ra,24(sp)
ffffffffc0201f68:	6522                	ld	a0,8(sp)
ffffffffc0201f6a:	6105                	addi	sp,sp,32
ffffffffc0201f6c:	8082                	ret

ffffffffc0201f6e <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f6e:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201f72:	1ff7f793          	andi	a5,a5,511
ffffffffc0201f76:	078e                	slli	a5,a5,0x3
ffffffffc0201f78:	00f50733          	add	a4,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201f7c:	6314                	ld	a3,0(a4)
{
ffffffffc0201f7e:	7139                	addi	sp,sp,-64
ffffffffc0201f80:	f822                	sd	s0,48(sp)
ffffffffc0201f82:	f426                	sd	s1,40(sp)
ffffffffc0201f84:	fc06                	sd	ra,56(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201f86:	0016f793          	andi	a5,a3,1
{
ffffffffc0201f8a:	842e                	mv	s0,a1
ffffffffc0201f8c:	8832                	mv	a6,a2
ffffffffc0201f8e:	00099497          	auipc	s1,0x99
ffffffffc0201f92:	6fa48493          	addi	s1,s1,1786 # ffffffffc029b688 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201f96:	ebd1                	bnez	a5,ffffffffc020202a <get_pte+0xbc>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f98:	16060d63          	beqz	a2,ffffffffc0202112 <get_pte+0x1a4>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f9c:	100027f3          	csrr	a5,sstatus
ffffffffc0201fa0:	8b89                	andi	a5,a5,2
ffffffffc0201fa2:	16079e63          	bnez	a5,ffffffffc020211e <get_pte+0x1b0>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201fa6:	00099797          	auipc	a5,0x99
ffffffffc0201faa:	6c27b783          	ld	a5,1730(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc0201fae:	4505                	li	a0,1
ffffffffc0201fb0:	e43a                	sd	a4,8(sp)
ffffffffc0201fb2:	6f9c                	ld	a5,24(a5)
ffffffffc0201fb4:	e832                	sd	a2,16(sp)
ffffffffc0201fb6:	9782                	jalr	a5
ffffffffc0201fb8:	6722                	ld	a4,8(sp)
ffffffffc0201fba:	6842                	ld	a6,16(sp)
ffffffffc0201fbc:	87aa                	mv	a5,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201fbe:	14078a63          	beqz	a5,ffffffffc0202112 <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0201fc2:	00099517          	auipc	a0,0x99
ffffffffc0201fc6:	6ce53503          	ld	a0,1742(a0) # ffffffffc029b690 <pages>
ffffffffc0201fca:	000808b7          	lui	a7,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201fce:	00099497          	auipc	s1,0x99
ffffffffc0201fd2:	6ba48493          	addi	s1,s1,1722 # ffffffffc029b688 <npage>
ffffffffc0201fd6:	40a78533          	sub	a0,a5,a0
ffffffffc0201fda:	8519                	srai	a0,a0,0x6
ffffffffc0201fdc:	9546                	add	a0,a0,a7
ffffffffc0201fde:	6090                	ld	a2,0(s1)
ffffffffc0201fe0:	00c51693          	slli	a3,a0,0xc
    page->ref = val;
ffffffffc0201fe4:	4585                	li	a1,1
ffffffffc0201fe6:	82b1                	srli	a3,a3,0xc
ffffffffc0201fe8:	c38c                	sw	a1,0(a5)
    return page2ppn(page) << PGSHIFT;
ffffffffc0201fea:	0532                	slli	a0,a0,0xc
ffffffffc0201fec:	1ac6f763          	bgeu	a3,a2,ffffffffc020219a <get_pte+0x22c>
ffffffffc0201ff0:	00099697          	auipc	a3,0x99
ffffffffc0201ff4:	6906b683          	ld	a3,1680(a3) # ffffffffc029b680 <va_pa_offset>
ffffffffc0201ff8:	6605                	lui	a2,0x1
ffffffffc0201ffa:	4581                	li	a1,0
ffffffffc0201ffc:	9536                	add	a0,a0,a3
ffffffffc0201ffe:	ec42                	sd	a6,24(sp)
ffffffffc0202000:	e83e                	sd	a5,16(sp)
ffffffffc0202002:	e43a                	sd	a4,8(sp)
ffffffffc0202004:	063030ef          	jal	ffffffffc0205866 <memset>
    return page - pages + nbase;
ffffffffc0202008:	00099697          	auipc	a3,0x99
ffffffffc020200c:	6886b683          	ld	a3,1672(a3) # ffffffffc029b690 <pages>
ffffffffc0202010:	67c2                	ld	a5,16(sp)
ffffffffc0202012:	000808b7          	lui	a7,0x80
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202016:	6722                	ld	a4,8(sp)
ffffffffc0202018:	40d786b3          	sub	a3,a5,a3
ffffffffc020201c:	8699                	srai	a3,a3,0x6
ffffffffc020201e:	96c6                	add	a3,a3,a7
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202020:	06aa                	slli	a3,a3,0xa
ffffffffc0202022:	6862                	ld	a6,24(sp)
ffffffffc0202024:	0116e693          	ori	a3,a3,17
ffffffffc0202028:	e314                	sd	a3,0(a4)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020202a:	c006f693          	andi	a3,a3,-1024
ffffffffc020202e:	6098                	ld	a4,0(s1)
ffffffffc0202030:	068a                	slli	a3,a3,0x2
ffffffffc0202032:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202036:	14e7f663          	bgeu	a5,a4,ffffffffc0202182 <get_pte+0x214>
ffffffffc020203a:	00099897          	auipc	a7,0x99
ffffffffc020203e:	64688893          	addi	a7,a7,1606 # ffffffffc029b680 <va_pa_offset>
ffffffffc0202042:	0008b603          	ld	a2,0(a7)
ffffffffc0202046:	01545793          	srli	a5,s0,0x15
ffffffffc020204a:	1ff7f793          	andi	a5,a5,511
ffffffffc020204e:	96b2                	add	a3,a3,a2
ffffffffc0202050:	078e                	slli	a5,a5,0x3
ffffffffc0202052:	97b6                	add	a5,a5,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0202054:	6394                	ld	a3,0(a5)
ffffffffc0202056:	0016f613          	andi	a2,a3,1
ffffffffc020205a:	e659                	bnez	a2,ffffffffc02020e8 <get_pte+0x17a>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020205c:	0a080b63          	beqz	a6,ffffffffc0202112 <get_pte+0x1a4>
ffffffffc0202060:	10002773          	csrr	a4,sstatus
ffffffffc0202064:	8b09                	andi	a4,a4,2
ffffffffc0202066:	ef71                	bnez	a4,ffffffffc0202142 <get_pte+0x1d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202068:	00099717          	auipc	a4,0x99
ffffffffc020206c:	60073703          	ld	a4,1536(a4) # ffffffffc029b668 <pmm_manager>
ffffffffc0202070:	4505                	li	a0,1
ffffffffc0202072:	e43e                	sd	a5,8(sp)
ffffffffc0202074:	6f18                	ld	a4,24(a4)
ffffffffc0202076:	9702                	jalr	a4
ffffffffc0202078:	67a2                	ld	a5,8(sp)
ffffffffc020207a:	872a                	mv	a4,a0
ffffffffc020207c:	00099897          	auipc	a7,0x99
ffffffffc0202080:	60488893          	addi	a7,a7,1540 # ffffffffc029b680 <va_pa_offset>
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202084:	c759                	beqz	a4,ffffffffc0202112 <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0202086:	00099697          	auipc	a3,0x99
ffffffffc020208a:	60a6b683          	ld	a3,1546(a3) # ffffffffc029b690 <pages>
ffffffffc020208e:	00080837          	lui	a6,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202092:	608c                	ld	a1,0(s1)
ffffffffc0202094:	40d706b3          	sub	a3,a4,a3
ffffffffc0202098:	8699                	srai	a3,a3,0x6
ffffffffc020209a:	96c2                	add	a3,a3,a6
ffffffffc020209c:	00c69613          	slli	a2,a3,0xc
    page->ref = val;
ffffffffc02020a0:	4505                	li	a0,1
ffffffffc02020a2:	8231                	srli	a2,a2,0xc
ffffffffc02020a4:	c308                	sw	a0,0(a4)
    return page2ppn(page) << PGSHIFT;
ffffffffc02020a6:	06b2                	slli	a3,a3,0xc
ffffffffc02020a8:	10b67663          	bgeu	a2,a1,ffffffffc02021b4 <get_pte+0x246>
ffffffffc02020ac:	0008b503          	ld	a0,0(a7)
ffffffffc02020b0:	6605                	lui	a2,0x1
ffffffffc02020b2:	4581                	li	a1,0
ffffffffc02020b4:	9536                	add	a0,a0,a3
ffffffffc02020b6:	e83a                	sd	a4,16(sp)
ffffffffc02020b8:	e43e                	sd	a5,8(sp)
ffffffffc02020ba:	7ac030ef          	jal	ffffffffc0205866 <memset>
    return page - pages + nbase;
ffffffffc02020be:	00099697          	auipc	a3,0x99
ffffffffc02020c2:	5d26b683          	ld	a3,1490(a3) # ffffffffc029b690 <pages>
ffffffffc02020c6:	6742                	ld	a4,16(sp)
ffffffffc02020c8:	00080837          	lui	a6,0x80
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02020cc:	67a2                	ld	a5,8(sp)
ffffffffc02020ce:	40d706b3          	sub	a3,a4,a3
ffffffffc02020d2:	8699                	srai	a3,a3,0x6
ffffffffc02020d4:	96c2                	add	a3,a3,a6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02020d6:	06aa                	slli	a3,a3,0xa
ffffffffc02020d8:	0116e693          	ori	a3,a3,17
ffffffffc02020dc:	e394                	sd	a3,0(a5)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02020de:	6098                	ld	a4,0(s1)
ffffffffc02020e0:	00099897          	auipc	a7,0x99
ffffffffc02020e4:	5a088893          	addi	a7,a7,1440 # ffffffffc029b680 <va_pa_offset>
ffffffffc02020e8:	c006f693          	andi	a3,a3,-1024
ffffffffc02020ec:	068a                	slli	a3,a3,0x2
ffffffffc02020ee:	00c6d793          	srli	a5,a3,0xc
ffffffffc02020f2:	06e7fc63          	bgeu	a5,a4,ffffffffc020216a <get_pte+0x1fc>
ffffffffc02020f6:	0008b783          	ld	a5,0(a7)
ffffffffc02020fa:	8031                	srli	s0,s0,0xc
ffffffffc02020fc:	1ff47413          	andi	s0,s0,511
ffffffffc0202100:	040e                	slli	s0,s0,0x3
ffffffffc0202102:	96be                	add	a3,a3,a5
}
ffffffffc0202104:	70e2                	ld	ra,56(sp)
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202106:	00868533          	add	a0,a3,s0
}
ffffffffc020210a:	7442                	ld	s0,48(sp)
ffffffffc020210c:	74a2                	ld	s1,40(sp)
ffffffffc020210e:	6121                	addi	sp,sp,64
ffffffffc0202110:	8082                	ret
ffffffffc0202112:	70e2                	ld	ra,56(sp)
ffffffffc0202114:	7442                	ld	s0,48(sp)
ffffffffc0202116:	74a2                	ld	s1,40(sp)
            return NULL;
ffffffffc0202118:	4501                	li	a0,0
}
ffffffffc020211a:	6121                	addi	sp,sp,64
ffffffffc020211c:	8082                	ret
        intr_disable();
ffffffffc020211e:	e83a                	sd	a4,16(sp)
ffffffffc0202120:	ec32                	sd	a2,24(sp)
ffffffffc0202122:	fe2fe0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202126:	00099797          	auipc	a5,0x99
ffffffffc020212a:	5427b783          	ld	a5,1346(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc020212e:	4505                	li	a0,1
ffffffffc0202130:	6f9c                	ld	a5,24(a5)
ffffffffc0202132:	9782                	jalr	a5
ffffffffc0202134:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0202136:	fc8fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020213a:	6862                	ld	a6,24(sp)
ffffffffc020213c:	6742                	ld	a4,16(sp)
ffffffffc020213e:	67a2                	ld	a5,8(sp)
ffffffffc0202140:	bdbd                	j	ffffffffc0201fbe <get_pte+0x50>
        intr_disable();
ffffffffc0202142:	e83e                	sd	a5,16(sp)
ffffffffc0202144:	fc0fe0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202148:	00099717          	auipc	a4,0x99
ffffffffc020214c:	52073703          	ld	a4,1312(a4) # ffffffffc029b668 <pmm_manager>
ffffffffc0202150:	4505                	li	a0,1
ffffffffc0202152:	6f18                	ld	a4,24(a4)
ffffffffc0202154:	9702                	jalr	a4
ffffffffc0202156:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0202158:	fa6fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020215c:	6722                	ld	a4,8(sp)
ffffffffc020215e:	67c2                	ld	a5,16(sp)
ffffffffc0202160:	00099897          	auipc	a7,0x99
ffffffffc0202164:	52088893          	addi	a7,a7,1312 # ffffffffc029b680 <va_pa_offset>
ffffffffc0202168:	bf31                	j	ffffffffc0202084 <get_pte+0x116>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020216a:	00004617          	auipc	a2,0x4
ffffffffc020216e:	4a660613          	addi	a2,a2,1190 # ffffffffc0206610 <etext+0xd80>
ffffffffc0202172:	0fa00593          	li	a1,250
ffffffffc0202176:	00004517          	auipc	a0,0x4
ffffffffc020217a:	58a50513          	addi	a0,a0,1418 # ffffffffc0206700 <etext+0xe70>
ffffffffc020217e:	ac8fe0ef          	jal	ffffffffc0200446 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202182:	00004617          	auipc	a2,0x4
ffffffffc0202186:	48e60613          	addi	a2,a2,1166 # ffffffffc0206610 <etext+0xd80>
ffffffffc020218a:	0ed00593          	li	a1,237
ffffffffc020218e:	00004517          	auipc	a0,0x4
ffffffffc0202192:	57250513          	addi	a0,a0,1394 # ffffffffc0206700 <etext+0xe70>
ffffffffc0202196:	ab0fe0ef          	jal	ffffffffc0200446 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020219a:	86aa                	mv	a3,a0
ffffffffc020219c:	00004617          	auipc	a2,0x4
ffffffffc02021a0:	47460613          	addi	a2,a2,1140 # ffffffffc0206610 <etext+0xd80>
ffffffffc02021a4:	0e900593          	li	a1,233
ffffffffc02021a8:	00004517          	auipc	a0,0x4
ffffffffc02021ac:	55850513          	addi	a0,a0,1368 # ffffffffc0206700 <etext+0xe70>
ffffffffc02021b0:	a96fe0ef          	jal	ffffffffc0200446 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02021b4:	00004617          	auipc	a2,0x4
ffffffffc02021b8:	45c60613          	addi	a2,a2,1116 # ffffffffc0206610 <etext+0xd80>
ffffffffc02021bc:	0f700593          	li	a1,247
ffffffffc02021c0:	00004517          	auipc	a0,0x4
ffffffffc02021c4:	54050513          	addi	a0,a0,1344 # ffffffffc0206700 <etext+0xe70>
ffffffffc02021c8:	a7efe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02021cc <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc02021cc:	1141                	addi	sp,sp,-16
ffffffffc02021ce:	e022                	sd	s0,0(sp)
ffffffffc02021d0:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02021d2:	4601                	li	a2,0
{
ffffffffc02021d4:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02021d6:	d99ff0ef          	jal	ffffffffc0201f6e <get_pte>
    if (ptep_store != NULL)
ffffffffc02021da:	c011                	beqz	s0,ffffffffc02021de <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc02021dc:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02021de:	c511                	beqz	a0,ffffffffc02021ea <get_page+0x1e>
ffffffffc02021e0:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc02021e2:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02021e4:	0017f713          	andi	a4,a5,1
ffffffffc02021e8:	e709                	bnez	a4,ffffffffc02021f2 <get_page+0x26>
}
ffffffffc02021ea:	60a2                	ld	ra,8(sp)
ffffffffc02021ec:	6402                	ld	s0,0(sp)
ffffffffc02021ee:	0141                	addi	sp,sp,16
ffffffffc02021f0:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc02021f2:	00099717          	auipc	a4,0x99
ffffffffc02021f6:	49673703          	ld	a4,1174(a4) # ffffffffc029b688 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc02021fa:	078a                	slli	a5,a5,0x2
ffffffffc02021fc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02021fe:	00e7ff63          	bgeu	a5,a4,ffffffffc020221c <get_page+0x50>
    return &pages[PPN(pa) - nbase];
ffffffffc0202202:	00099517          	auipc	a0,0x99
ffffffffc0202206:	48e53503          	ld	a0,1166(a0) # ffffffffc029b690 <pages>
ffffffffc020220a:	60a2                	ld	ra,8(sp)
ffffffffc020220c:	6402                	ld	s0,0(sp)
ffffffffc020220e:	079a                	slli	a5,a5,0x6
ffffffffc0202210:	fe000737          	lui	a4,0xfe000
ffffffffc0202214:	97ba                	add	a5,a5,a4
ffffffffc0202216:	953e                	add	a0,a0,a5
ffffffffc0202218:	0141                	addi	sp,sp,16
ffffffffc020221a:	8082                	ret
ffffffffc020221c:	c8fff0ef          	jal	ffffffffc0201eaa <pa2page.part.0>

ffffffffc0202220 <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc0202220:	715d                	addi	sp,sp,-80
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202222:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202226:	e486                	sd	ra,72(sp)
ffffffffc0202228:	e0a2                	sd	s0,64(sp)
ffffffffc020222a:	fc26                	sd	s1,56(sp)
ffffffffc020222c:	f84a                	sd	s2,48(sp)
ffffffffc020222e:	f44e                	sd	s3,40(sp)
ffffffffc0202230:	f052                	sd	s4,32(sp)
ffffffffc0202232:	ec56                	sd	s5,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202234:	03479713          	slli	a4,a5,0x34
ffffffffc0202238:	ef61                	bnez	a4,ffffffffc0202310 <unmap_range+0xf0>
    assert(USER_ACCESS(start, end));
ffffffffc020223a:	00200a37          	lui	s4,0x200
ffffffffc020223e:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc0202242:	0145b733          	sltu	a4,a1,s4
ffffffffc0202246:	0017b793          	seqz	a5,a5
ffffffffc020224a:	8fd9                	or	a5,a5,a4
ffffffffc020224c:	842e                	mv	s0,a1
ffffffffc020224e:	84b2                	mv	s1,a2
ffffffffc0202250:	e3e5                	bnez	a5,ffffffffc0202330 <unmap_range+0x110>
ffffffffc0202252:	4785                	li	a5,1
ffffffffc0202254:	07fe                	slli	a5,a5,0x1f
ffffffffc0202256:	0785                	addi	a5,a5,1
ffffffffc0202258:	892a                	mv	s2,a0
ffffffffc020225a:	6985                	lui	s3,0x1
    do
    {
        pte_t *ptep = get_pte(pgdir, start, 0);
        if (ptep == NULL)
        {
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc020225c:	ffe00ab7          	lui	s5,0xffe00
    assert(USER_ACCESS(start, end));
ffffffffc0202260:	0cf67863          	bgeu	a2,a5,ffffffffc0202330 <unmap_range+0x110>
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc0202264:	4601                	li	a2,0
ffffffffc0202266:	85a2                	mv	a1,s0
ffffffffc0202268:	854a                	mv	a0,s2
ffffffffc020226a:	d05ff0ef          	jal	ffffffffc0201f6e <get_pte>
ffffffffc020226e:	87aa                	mv	a5,a0
        if (ptep == NULL)
ffffffffc0202270:	cd31                	beqz	a0,ffffffffc02022cc <unmap_range+0xac>
            continue;
        }
        if (*ptep != 0)
ffffffffc0202272:	6118                	ld	a4,0(a0)
ffffffffc0202274:	ef11                	bnez	a4,ffffffffc0202290 <unmap_range+0x70>
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc0202276:	944e                	add	s0,s0,s3
    } while (start != 0 && start < end);
ffffffffc0202278:	c019                	beqz	s0,ffffffffc020227e <unmap_range+0x5e>
ffffffffc020227a:	fe9465e3          	bltu	s0,s1,ffffffffc0202264 <unmap_range+0x44>
}
ffffffffc020227e:	60a6                	ld	ra,72(sp)
ffffffffc0202280:	6406                	ld	s0,64(sp)
ffffffffc0202282:	74e2                	ld	s1,56(sp)
ffffffffc0202284:	7942                	ld	s2,48(sp)
ffffffffc0202286:	79a2                	ld	s3,40(sp)
ffffffffc0202288:	7a02                	ld	s4,32(sp)
ffffffffc020228a:	6ae2                	ld	s5,24(sp)
ffffffffc020228c:	6161                	addi	sp,sp,80
ffffffffc020228e:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc0202290:	00177693          	andi	a3,a4,1
ffffffffc0202294:	d2ed                	beqz	a3,ffffffffc0202276 <unmap_range+0x56>
    if (PPN(pa) >= npage)
ffffffffc0202296:	00099697          	auipc	a3,0x99
ffffffffc020229a:	3f26b683          	ld	a3,1010(a3) # ffffffffc029b688 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc020229e:	070a                	slli	a4,a4,0x2
ffffffffc02022a0:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc02022a2:	0ad77763          	bgeu	a4,a3,ffffffffc0202350 <unmap_range+0x130>
    return &pages[PPN(pa) - nbase];
ffffffffc02022a6:	00099517          	auipc	a0,0x99
ffffffffc02022aa:	3ea53503          	ld	a0,1002(a0) # ffffffffc029b690 <pages>
ffffffffc02022ae:	071a                	slli	a4,a4,0x6
ffffffffc02022b0:	fe0006b7          	lui	a3,0xfe000
ffffffffc02022b4:	9736                	add	a4,a4,a3
ffffffffc02022b6:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc02022b8:	4118                	lw	a4,0(a0)
ffffffffc02022ba:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3dd64947>
ffffffffc02022bc:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc02022be:	cb19                	beqz	a4,ffffffffc02022d4 <unmap_range+0xb4>
        *ptep = 0;
ffffffffc02022c0:	0007b023          	sd	zero,0(a5)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02022c4:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc02022c8:	944e                	add	s0,s0,s3
ffffffffc02022ca:	b77d                	j	ffffffffc0202278 <unmap_range+0x58>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02022cc:	9452                	add	s0,s0,s4
ffffffffc02022ce:	01547433          	and	s0,s0,s5
            continue;
ffffffffc02022d2:	b75d                	j	ffffffffc0202278 <unmap_range+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02022d4:	10002773          	csrr	a4,sstatus
ffffffffc02022d8:	8b09                	andi	a4,a4,2
ffffffffc02022da:	eb19                	bnez	a4,ffffffffc02022f0 <unmap_range+0xd0>
        pmm_manager->free_pages(base, n);
ffffffffc02022dc:	00099717          	auipc	a4,0x99
ffffffffc02022e0:	38c73703          	ld	a4,908(a4) # ffffffffc029b668 <pmm_manager>
ffffffffc02022e4:	4585                	li	a1,1
ffffffffc02022e6:	e03e                	sd	a5,0(sp)
ffffffffc02022e8:	7318                	ld	a4,32(a4)
ffffffffc02022ea:	9702                	jalr	a4
    if (flag)
ffffffffc02022ec:	6782                	ld	a5,0(sp)
ffffffffc02022ee:	bfc9                	j	ffffffffc02022c0 <unmap_range+0xa0>
        intr_disable();
ffffffffc02022f0:	e43e                	sd	a5,8(sp)
ffffffffc02022f2:	e02a                	sd	a0,0(sp)
ffffffffc02022f4:	e10fe0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc02022f8:	00099717          	auipc	a4,0x99
ffffffffc02022fc:	37073703          	ld	a4,880(a4) # ffffffffc029b668 <pmm_manager>
ffffffffc0202300:	6502                	ld	a0,0(sp)
ffffffffc0202302:	4585                	li	a1,1
ffffffffc0202304:	7318                	ld	a4,32(a4)
ffffffffc0202306:	9702                	jalr	a4
        intr_enable();
ffffffffc0202308:	df6fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020230c:	67a2                	ld	a5,8(sp)
ffffffffc020230e:	bf4d                	j	ffffffffc02022c0 <unmap_range+0xa0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202310:	00004697          	auipc	a3,0x4
ffffffffc0202314:	40068693          	addi	a3,a3,1024 # ffffffffc0206710 <etext+0xe80>
ffffffffc0202318:	00004617          	auipc	a2,0x4
ffffffffc020231c:	f4860613          	addi	a2,a2,-184 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0202320:	12000593          	li	a1,288
ffffffffc0202324:	00004517          	auipc	a0,0x4
ffffffffc0202328:	3dc50513          	addi	a0,a0,988 # ffffffffc0206700 <etext+0xe70>
ffffffffc020232c:	91afe0ef          	jal	ffffffffc0200446 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0202330:	00004697          	auipc	a3,0x4
ffffffffc0202334:	41068693          	addi	a3,a3,1040 # ffffffffc0206740 <etext+0xeb0>
ffffffffc0202338:	00004617          	auipc	a2,0x4
ffffffffc020233c:	f2860613          	addi	a2,a2,-216 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0202340:	12100593          	li	a1,289
ffffffffc0202344:	00004517          	auipc	a0,0x4
ffffffffc0202348:	3bc50513          	addi	a0,a0,956 # ffffffffc0206700 <etext+0xe70>
ffffffffc020234c:	8fafe0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0202350:	b5bff0ef          	jal	ffffffffc0201eaa <pa2page.part.0>

ffffffffc0202354 <exit_range>:
{
ffffffffc0202354:	7135                	addi	sp,sp,-160
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202356:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc020235a:	ed06                	sd	ra,152(sp)
ffffffffc020235c:	e922                	sd	s0,144(sp)
ffffffffc020235e:	e526                	sd	s1,136(sp)
ffffffffc0202360:	e14a                	sd	s2,128(sp)
ffffffffc0202362:	fcce                	sd	s3,120(sp)
ffffffffc0202364:	f8d2                	sd	s4,112(sp)
ffffffffc0202366:	f4d6                	sd	s5,104(sp)
ffffffffc0202368:	f0da                	sd	s6,96(sp)
ffffffffc020236a:	ecde                	sd	s7,88(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020236c:	17d2                	slli	a5,a5,0x34
ffffffffc020236e:	22079263          	bnez	a5,ffffffffc0202592 <exit_range+0x23e>
    assert(USER_ACCESS(start, end));
ffffffffc0202372:	00200937          	lui	s2,0x200
ffffffffc0202376:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc020237a:	0125b733          	sltu	a4,a1,s2
ffffffffc020237e:	0017b793          	seqz	a5,a5
ffffffffc0202382:	8fd9                	or	a5,a5,a4
ffffffffc0202384:	26079263          	bnez	a5,ffffffffc02025e8 <exit_range+0x294>
ffffffffc0202388:	4785                	li	a5,1
ffffffffc020238a:	07fe                	slli	a5,a5,0x1f
ffffffffc020238c:	0785                	addi	a5,a5,1
ffffffffc020238e:	24f67d63          	bgeu	a2,a5,ffffffffc02025e8 <exit_range+0x294>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc0202392:	c00004b7          	lui	s1,0xc0000
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202396:	ffe007b7          	lui	a5,0xffe00
ffffffffc020239a:	8a2a                	mv	s4,a0
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc020239c:	8ced                	and	s1,s1,a1
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc020239e:	00f5f833          	and	a6,a1,a5
    if (PPN(pa) >= npage)
ffffffffc02023a2:	00099a97          	auipc	s5,0x99
ffffffffc02023a6:	2e6a8a93          	addi	s5,s5,742 # ffffffffc029b688 <npage>
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02023aa:	400009b7          	lui	s3,0x40000
ffffffffc02023ae:	a809                	j	ffffffffc02023c0 <exit_range+0x6c>
        d1start += PDSIZE;
ffffffffc02023b0:	013487b3          	add	a5,s1,s3
ffffffffc02023b4:	400004b7          	lui	s1,0x40000
        d0start = d1start;
ffffffffc02023b8:	8826                	mv	a6,s1
    } while (d1start != 0 && d1start < end);
ffffffffc02023ba:	c3f1                	beqz	a5,ffffffffc020247e <exit_range+0x12a>
ffffffffc02023bc:	0cc7f163          	bgeu	a5,a2,ffffffffc020247e <exit_range+0x12a>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc02023c0:	01e4d413          	srli	s0,s1,0x1e
ffffffffc02023c4:	1ff47413          	andi	s0,s0,511
ffffffffc02023c8:	040e                	slli	s0,s0,0x3
ffffffffc02023ca:	9452                	add	s0,s0,s4
ffffffffc02023cc:	00043883          	ld	a7,0(s0)
        if (pde1 & PTE_V)
ffffffffc02023d0:	0018f793          	andi	a5,a7,1
ffffffffc02023d4:	dff1                	beqz	a5,ffffffffc02023b0 <exit_range+0x5c>
ffffffffc02023d6:	000ab783          	ld	a5,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc02023da:	088a                	slli	a7,a7,0x2
ffffffffc02023dc:	00c8d893          	srli	a7,a7,0xc
    if (PPN(pa) >= npage)
ffffffffc02023e0:	20f8f263          	bgeu	a7,a5,ffffffffc02025e4 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc02023e4:	fff802b7          	lui	t0,0xfff80
ffffffffc02023e8:	00588f33          	add	t5,a7,t0
    return page - pages + nbase;
ffffffffc02023ec:	000803b7          	lui	t2,0x80
ffffffffc02023f0:	007f0733          	add	a4,t5,t2
    return page2ppn(page) << PGSHIFT;
ffffffffc02023f4:	00c71e13          	slli	t3,a4,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc02023f8:	0f1a                	slli	t5,t5,0x6
    return KADDR(page2pa(page));
ffffffffc02023fa:	1cf77863          	bgeu	a4,a5,ffffffffc02025ca <exit_range+0x276>
ffffffffc02023fe:	00099f97          	auipc	t6,0x99
ffffffffc0202402:	282f8f93          	addi	t6,t6,642 # ffffffffc029b680 <va_pa_offset>
ffffffffc0202406:	000fb783          	ld	a5,0(t6)
            free_pd0 = 1;
ffffffffc020240a:	4e85                	li	t4,1
ffffffffc020240c:	6b05                	lui	s6,0x1
ffffffffc020240e:	9e3e                	add	t3,t3,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202410:	01348333          	add	t1,s1,s3
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202414:	01585713          	srli	a4,a6,0x15
ffffffffc0202418:	1ff77713          	andi	a4,a4,511
ffffffffc020241c:	070e                	slli	a4,a4,0x3
ffffffffc020241e:	9772                	add	a4,a4,t3
ffffffffc0202420:	631c                	ld	a5,0(a4)
                if (pde0 & PTE_V)
ffffffffc0202422:	0017f693          	andi	a3,a5,1
ffffffffc0202426:	e6bd                	bnez	a3,ffffffffc0202494 <exit_range+0x140>
                    free_pd0 = 0;
ffffffffc0202428:	4e81                	li	t4,0
                d0start += PTSIZE;
ffffffffc020242a:	984a                	add	a6,a6,s2
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc020242c:	00080863          	beqz	a6,ffffffffc020243c <exit_range+0xe8>
ffffffffc0202430:	879a                	mv	a5,t1
ffffffffc0202432:	00667363          	bgeu	a2,t1,ffffffffc0202438 <exit_range+0xe4>
ffffffffc0202436:	87b2                	mv	a5,a2
ffffffffc0202438:	fcf86ee3          	bltu	a6,a5,ffffffffc0202414 <exit_range+0xc0>
            if (free_pd0)
ffffffffc020243c:	f60e8ae3          	beqz	t4,ffffffffc02023b0 <exit_range+0x5c>
    if (PPN(pa) >= npage)
ffffffffc0202440:	000ab783          	ld	a5,0(s5)
ffffffffc0202444:	1af8f063          	bgeu	a7,a5,ffffffffc02025e4 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc0202448:	00099517          	auipc	a0,0x99
ffffffffc020244c:	24853503          	ld	a0,584(a0) # ffffffffc029b690 <pages>
ffffffffc0202450:	957a                	add	a0,a0,t5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202452:	100027f3          	csrr	a5,sstatus
ffffffffc0202456:	8b89                	andi	a5,a5,2
ffffffffc0202458:	10079b63          	bnez	a5,ffffffffc020256e <exit_range+0x21a>
        pmm_manager->free_pages(base, n);
ffffffffc020245c:	00099797          	auipc	a5,0x99
ffffffffc0202460:	20c7b783          	ld	a5,524(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc0202464:	4585                	li	a1,1
ffffffffc0202466:	e432                	sd	a2,8(sp)
ffffffffc0202468:	739c                	ld	a5,32(a5)
ffffffffc020246a:	9782                	jalr	a5
ffffffffc020246c:	6622                	ld	a2,8(sp)
                pgdir[PDX1(d1start)] = 0;
ffffffffc020246e:	00043023          	sd	zero,0(s0)
        d1start += PDSIZE;
ffffffffc0202472:	013487b3          	add	a5,s1,s3
ffffffffc0202476:	400004b7          	lui	s1,0x40000
        d0start = d1start;
ffffffffc020247a:	8826                	mv	a6,s1
    } while (d1start != 0 && d1start < end);
ffffffffc020247c:	f3a1                	bnez	a5,ffffffffc02023bc <exit_range+0x68>
}
ffffffffc020247e:	60ea                	ld	ra,152(sp)
ffffffffc0202480:	644a                	ld	s0,144(sp)
ffffffffc0202482:	64aa                	ld	s1,136(sp)
ffffffffc0202484:	690a                	ld	s2,128(sp)
ffffffffc0202486:	79e6                	ld	s3,120(sp)
ffffffffc0202488:	7a46                	ld	s4,112(sp)
ffffffffc020248a:	7aa6                	ld	s5,104(sp)
ffffffffc020248c:	7b06                	ld	s6,96(sp)
ffffffffc020248e:	6be6                	ld	s7,88(sp)
ffffffffc0202490:	610d                	addi	sp,sp,160
ffffffffc0202492:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0202494:	000ab503          	ld	a0,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202498:	078a                	slli	a5,a5,0x2
ffffffffc020249a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020249c:	14a7f463          	bgeu	a5,a0,ffffffffc02025e4 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc02024a0:	9796                	add	a5,a5,t0
    return page - pages + nbase;
ffffffffc02024a2:	00778bb3          	add	s7,a5,t2
    return &pages[PPN(pa) - nbase];
ffffffffc02024a6:	00679593          	slli	a1,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02024aa:	00cb9693          	slli	a3,s7,0xc
    return KADDR(page2pa(page));
ffffffffc02024ae:	10abf263          	bgeu	s7,a0,ffffffffc02025b2 <exit_range+0x25e>
ffffffffc02024b2:	000fb783          	ld	a5,0(t6)
ffffffffc02024b6:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02024b8:	01668533          	add	a0,a3,s6
                        if (pt[i] & PTE_V)
ffffffffc02024bc:	629c                	ld	a5,0(a3)
ffffffffc02024be:	8b85                	andi	a5,a5,1
ffffffffc02024c0:	f7ad                	bnez	a5,ffffffffc020242a <exit_range+0xd6>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02024c2:	06a1                	addi	a3,a3,8
ffffffffc02024c4:	fea69ce3          	bne	a3,a0,ffffffffc02024bc <exit_range+0x168>
    return &pages[PPN(pa) - nbase];
ffffffffc02024c8:	00099517          	auipc	a0,0x99
ffffffffc02024cc:	1c853503          	ld	a0,456(a0) # ffffffffc029b690 <pages>
ffffffffc02024d0:	952e                	add	a0,a0,a1
ffffffffc02024d2:	100027f3          	csrr	a5,sstatus
ffffffffc02024d6:	8b89                	andi	a5,a5,2
ffffffffc02024d8:	e3b9                	bnez	a5,ffffffffc020251e <exit_range+0x1ca>
        pmm_manager->free_pages(base, n);
ffffffffc02024da:	00099797          	auipc	a5,0x99
ffffffffc02024de:	18e7b783          	ld	a5,398(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc02024e2:	4585                	li	a1,1
ffffffffc02024e4:	e0b2                	sd	a2,64(sp)
ffffffffc02024e6:	739c                	ld	a5,32(a5)
ffffffffc02024e8:	fc1a                	sd	t1,56(sp)
ffffffffc02024ea:	f846                	sd	a7,48(sp)
ffffffffc02024ec:	f47a                	sd	t5,40(sp)
ffffffffc02024ee:	f072                	sd	t3,32(sp)
ffffffffc02024f0:	ec76                	sd	t4,24(sp)
ffffffffc02024f2:	e842                	sd	a6,16(sp)
ffffffffc02024f4:	e43a                	sd	a4,8(sp)
ffffffffc02024f6:	9782                	jalr	a5
    if (flag)
ffffffffc02024f8:	6722                	ld	a4,8(sp)
ffffffffc02024fa:	6842                	ld	a6,16(sp)
ffffffffc02024fc:	6ee2                	ld	t4,24(sp)
ffffffffc02024fe:	7e02                	ld	t3,32(sp)
ffffffffc0202500:	7f22                	ld	t5,40(sp)
ffffffffc0202502:	78c2                	ld	a7,48(sp)
ffffffffc0202504:	7362                	ld	t1,56(sp)
ffffffffc0202506:	6606                	ld	a2,64(sp)
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202508:	fff802b7          	lui	t0,0xfff80
ffffffffc020250c:	000803b7          	lui	t2,0x80
ffffffffc0202510:	00099f97          	auipc	t6,0x99
ffffffffc0202514:	170f8f93          	addi	t6,t6,368 # ffffffffc029b680 <va_pa_offset>
ffffffffc0202518:	00073023          	sd	zero,0(a4)
ffffffffc020251c:	b739                	j	ffffffffc020242a <exit_range+0xd6>
        intr_disable();
ffffffffc020251e:	e4b2                	sd	a2,72(sp)
ffffffffc0202520:	e09a                	sd	t1,64(sp)
ffffffffc0202522:	fc46                	sd	a7,56(sp)
ffffffffc0202524:	f47a                	sd	t5,40(sp)
ffffffffc0202526:	f072                	sd	t3,32(sp)
ffffffffc0202528:	ec76                	sd	t4,24(sp)
ffffffffc020252a:	e842                	sd	a6,16(sp)
ffffffffc020252c:	e43a                	sd	a4,8(sp)
ffffffffc020252e:	f82a                	sd	a0,48(sp)
ffffffffc0202530:	bd4fe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202534:	00099797          	auipc	a5,0x99
ffffffffc0202538:	1347b783          	ld	a5,308(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc020253c:	7542                	ld	a0,48(sp)
ffffffffc020253e:	4585                	li	a1,1
ffffffffc0202540:	739c                	ld	a5,32(a5)
ffffffffc0202542:	9782                	jalr	a5
        intr_enable();
ffffffffc0202544:	bbafe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202548:	6722                	ld	a4,8(sp)
ffffffffc020254a:	6626                	ld	a2,72(sp)
ffffffffc020254c:	6306                	ld	t1,64(sp)
ffffffffc020254e:	78e2                	ld	a7,56(sp)
ffffffffc0202550:	7f22                	ld	t5,40(sp)
ffffffffc0202552:	7e02                	ld	t3,32(sp)
ffffffffc0202554:	6ee2                	ld	t4,24(sp)
ffffffffc0202556:	6842                	ld	a6,16(sp)
ffffffffc0202558:	00099f97          	auipc	t6,0x99
ffffffffc020255c:	128f8f93          	addi	t6,t6,296 # ffffffffc029b680 <va_pa_offset>
ffffffffc0202560:	000803b7          	lui	t2,0x80
ffffffffc0202564:	fff802b7          	lui	t0,0xfff80
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202568:	00073023          	sd	zero,0(a4)
ffffffffc020256c:	bd7d                	j	ffffffffc020242a <exit_range+0xd6>
        intr_disable();
ffffffffc020256e:	e832                	sd	a2,16(sp)
ffffffffc0202570:	e42a                	sd	a0,8(sp)
ffffffffc0202572:	b92fe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202576:	00099797          	auipc	a5,0x99
ffffffffc020257a:	0f27b783          	ld	a5,242(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc020257e:	6522                	ld	a0,8(sp)
ffffffffc0202580:	4585                	li	a1,1
ffffffffc0202582:	739c                	ld	a5,32(a5)
ffffffffc0202584:	9782                	jalr	a5
        intr_enable();
ffffffffc0202586:	b78fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020258a:	6642                	ld	a2,16(sp)
                pgdir[PDX1(d1start)] = 0;
ffffffffc020258c:	00043023          	sd	zero,0(s0)
ffffffffc0202590:	b5cd                	j	ffffffffc0202472 <exit_range+0x11e>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202592:	00004697          	auipc	a3,0x4
ffffffffc0202596:	17e68693          	addi	a3,a3,382 # ffffffffc0206710 <etext+0xe80>
ffffffffc020259a:	00004617          	auipc	a2,0x4
ffffffffc020259e:	cc660613          	addi	a2,a2,-826 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02025a2:	13500593          	li	a1,309
ffffffffc02025a6:	00004517          	auipc	a0,0x4
ffffffffc02025aa:	15a50513          	addi	a0,a0,346 # ffffffffc0206700 <etext+0xe70>
ffffffffc02025ae:	e99fd0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc02025b2:	00004617          	auipc	a2,0x4
ffffffffc02025b6:	05e60613          	addi	a2,a2,94 # ffffffffc0206610 <etext+0xd80>
ffffffffc02025ba:	07100593          	li	a1,113
ffffffffc02025be:	00004517          	auipc	a0,0x4
ffffffffc02025c2:	07a50513          	addi	a0,a0,122 # ffffffffc0206638 <etext+0xda8>
ffffffffc02025c6:	e81fd0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc02025ca:	86f2                	mv	a3,t3
ffffffffc02025cc:	00004617          	auipc	a2,0x4
ffffffffc02025d0:	04460613          	addi	a2,a2,68 # ffffffffc0206610 <etext+0xd80>
ffffffffc02025d4:	07100593          	li	a1,113
ffffffffc02025d8:	00004517          	auipc	a0,0x4
ffffffffc02025dc:	06050513          	addi	a0,a0,96 # ffffffffc0206638 <etext+0xda8>
ffffffffc02025e0:	e67fd0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc02025e4:	8c7ff0ef          	jal	ffffffffc0201eaa <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc02025e8:	00004697          	auipc	a3,0x4
ffffffffc02025ec:	15868693          	addi	a3,a3,344 # ffffffffc0206740 <etext+0xeb0>
ffffffffc02025f0:	00004617          	auipc	a2,0x4
ffffffffc02025f4:	c7060613          	addi	a2,a2,-912 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02025f8:	13600593          	li	a1,310
ffffffffc02025fc:	00004517          	auipc	a0,0x4
ffffffffc0202600:	10450513          	addi	a0,a0,260 # ffffffffc0206700 <etext+0xe70>
ffffffffc0202604:	e43fd0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0202608 <page_remove>:
{
ffffffffc0202608:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020260a:	4601                	li	a2,0
{
ffffffffc020260c:	e822                	sd	s0,16(sp)
ffffffffc020260e:	ec06                	sd	ra,24(sp)
ffffffffc0202610:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202612:	95dff0ef          	jal	ffffffffc0201f6e <get_pte>
    if (ptep != NULL)
ffffffffc0202616:	c511                	beqz	a0,ffffffffc0202622 <page_remove+0x1a>
    if (*ptep & PTE_V)
ffffffffc0202618:	6118                	ld	a4,0(a0)
ffffffffc020261a:	87aa                	mv	a5,a0
ffffffffc020261c:	00177693          	andi	a3,a4,1
ffffffffc0202620:	e689                	bnez	a3,ffffffffc020262a <page_remove+0x22>
}
ffffffffc0202622:	60e2                	ld	ra,24(sp)
ffffffffc0202624:	6442                	ld	s0,16(sp)
ffffffffc0202626:	6105                	addi	sp,sp,32
ffffffffc0202628:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc020262a:	00099697          	auipc	a3,0x99
ffffffffc020262e:	05e6b683          	ld	a3,94(a3) # ffffffffc029b688 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0202632:	070a                	slli	a4,a4,0x2
ffffffffc0202634:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202636:	06d77563          	bgeu	a4,a3,ffffffffc02026a0 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc020263a:	00099517          	auipc	a0,0x99
ffffffffc020263e:	05653503          	ld	a0,86(a0) # ffffffffc029b690 <pages>
ffffffffc0202642:	071a                	slli	a4,a4,0x6
ffffffffc0202644:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202648:	9736                	add	a4,a4,a3
ffffffffc020264a:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc020264c:	4118                	lw	a4,0(a0)
ffffffffc020264e:	377d                	addiw	a4,a4,-1
ffffffffc0202650:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202652:	cb09                	beqz	a4,ffffffffc0202664 <page_remove+0x5c>
        *ptep = 0;
ffffffffc0202654:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202658:	12040073          	sfence.vma	s0
}
ffffffffc020265c:	60e2                	ld	ra,24(sp)
ffffffffc020265e:	6442                	ld	s0,16(sp)
ffffffffc0202660:	6105                	addi	sp,sp,32
ffffffffc0202662:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202664:	10002773          	csrr	a4,sstatus
ffffffffc0202668:	8b09                	andi	a4,a4,2
ffffffffc020266a:	eb19                	bnez	a4,ffffffffc0202680 <page_remove+0x78>
        pmm_manager->free_pages(base, n);
ffffffffc020266c:	00099717          	auipc	a4,0x99
ffffffffc0202670:	ffc73703          	ld	a4,-4(a4) # ffffffffc029b668 <pmm_manager>
ffffffffc0202674:	4585                	li	a1,1
ffffffffc0202676:	e03e                	sd	a5,0(sp)
ffffffffc0202678:	7318                	ld	a4,32(a4)
ffffffffc020267a:	9702                	jalr	a4
    if (flag)
ffffffffc020267c:	6782                	ld	a5,0(sp)
ffffffffc020267e:	bfd9                	j	ffffffffc0202654 <page_remove+0x4c>
        intr_disable();
ffffffffc0202680:	e43e                	sd	a5,8(sp)
ffffffffc0202682:	e02a                	sd	a0,0(sp)
ffffffffc0202684:	a80fe0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202688:	00099717          	auipc	a4,0x99
ffffffffc020268c:	fe073703          	ld	a4,-32(a4) # ffffffffc029b668 <pmm_manager>
ffffffffc0202690:	6502                	ld	a0,0(sp)
ffffffffc0202692:	4585                	li	a1,1
ffffffffc0202694:	7318                	ld	a4,32(a4)
ffffffffc0202696:	9702                	jalr	a4
        intr_enable();
ffffffffc0202698:	a66fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020269c:	67a2                	ld	a5,8(sp)
ffffffffc020269e:	bf5d                	j	ffffffffc0202654 <page_remove+0x4c>
ffffffffc02026a0:	80bff0ef          	jal	ffffffffc0201eaa <pa2page.part.0>

ffffffffc02026a4 <page_insert>:
{
ffffffffc02026a4:	7139                	addi	sp,sp,-64
ffffffffc02026a6:	f426                	sd	s1,40(sp)
ffffffffc02026a8:	84b2                	mv	s1,a2
ffffffffc02026aa:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02026ac:	4605                	li	a2,1
{
ffffffffc02026ae:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02026b0:	85a6                	mv	a1,s1
{
ffffffffc02026b2:	fc06                	sd	ra,56(sp)
ffffffffc02026b4:	e436                	sd	a3,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02026b6:	8b9ff0ef          	jal	ffffffffc0201f6e <get_pte>
    if (ptep == NULL)
ffffffffc02026ba:	cd61                	beqz	a0,ffffffffc0202792 <page_insert+0xee>
    page->ref += 1;
ffffffffc02026bc:	400c                	lw	a1,0(s0)
    if (*ptep & PTE_V)
ffffffffc02026be:	611c                	ld	a5,0(a0)
ffffffffc02026c0:	66a2                	ld	a3,8(sp)
ffffffffc02026c2:	0015861b          	addiw	a2,a1,1 # 1001 <_binary_obj___user_softint_out_size-0x7bc7>
ffffffffc02026c6:	c010                	sw	a2,0(s0)
ffffffffc02026c8:	0017f613          	andi	a2,a5,1
ffffffffc02026cc:	872a                	mv	a4,a0
ffffffffc02026ce:	e61d                	bnez	a2,ffffffffc02026fc <page_insert+0x58>
    return &pages[PPN(pa) - nbase];
ffffffffc02026d0:	00099617          	auipc	a2,0x99
ffffffffc02026d4:	fc063603          	ld	a2,-64(a2) # ffffffffc029b690 <pages>
    return page - pages + nbase;
ffffffffc02026d8:	8c11                	sub	s0,s0,a2
ffffffffc02026da:	8419                	srai	s0,s0,0x6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02026dc:	200007b7          	lui	a5,0x20000
ffffffffc02026e0:	042a                	slli	s0,s0,0xa
ffffffffc02026e2:	943e                	add	s0,s0,a5
ffffffffc02026e4:	8ec1                	or	a3,a3,s0
ffffffffc02026e6:	0016e693          	ori	a3,a3,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02026ea:	e314                	sd	a3,0(a4)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02026ec:	12048073          	sfence.vma	s1
    return 0;
ffffffffc02026f0:	4501                	li	a0,0
}
ffffffffc02026f2:	70e2                	ld	ra,56(sp)
ffffffffc02026f4:	7442                	ld	s0,48(sp)
ffffffffc02026f6:	74a2                	ld	s1,40(sp)
ffffffffc02026f8:	6121                	addi	sp,sp,64
ffffffffc02026fa:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc02026fc:	00099617          	auipc	a2,0x99
ffffffffc0202700:	f8c63603          	ld	a2,-116(a2) # ffffffffc029b688 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0202704:	078a                	slli	a5,a5,0x2
ffffffffc0202706:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202708:	08c7f763          	bgeu	a5,a2,ffffffffc0202796 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc020270c:	00099617          	auipc	a2,0x99
ffffffffc0202710:	f8463603          	ld	a2,-124(a2) # ffffffffc029b690 <pages>
ffffffffc0202714:	fe000537          	lui	a0,0xfe000
ffffffffc0202718:	079a                	slli	a5,a5,0x6
ffffffffc020271a:	97aa                	add	a5,a5,a0
ffffffffc020271c:	00f60533          	add	a0,a2,a5
        if (p == page)
ffffffffc0202720:	00a40963          	beq	s0,a0,ffffffffc0202732 <page_insert+0x8e>
    page->ref -= 1;
ffffffffc0202724:	411c                	lw	a5,0(a0)
ffffffffc0202726:	37fd                	addiw	a5,a5,-1 # 1fffffff <_binary_obj___user_exit_out_size+0x1fff5e3f>
ffffffffc0202728:	c11c                	sw	a5,0(a0)
        if (page_ref(page) == 0)
ffffffffc020272a:	c791                	beqz	a5,ffffffffc0202736 <page_insert+0x92>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020272c:	12048073          	sfence.vma	s1
}
ffffffffc0202730:	b765                	j	ffffffffc02026d8 <page_insert+0x34>
ffffffffc0202732:	c00c                	sw	a1,0(s0)
    return page->ref;
ffffffffc0202734:	b755                	j	ffffffffc02026d8 <page_insert+0x34>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202736:	100027f3          	csrr	a5,sstatus
ffffffffc020273a:	8b89                	andi	a5,a5,2
ffffffffc020273c:	e39d                	bnez	a5,ffffffffc0202762 <page_insert+0xbe>
        pmm_manager->free_pages(base, n);
ffffffffc020273e:	00099797          	auipc	a5,0x99
ffffffffc0202742:	f2a7b783          	ld	a5,-214(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc0202746:	4585                	li	a1,1
ffffffffc0202748:	e83a                	sd	a4,16(sp)
ffffffffc020274a:	739c                	ld	a5,32(a5)
ffffffffc020274c:	e436                	sd	a3,8(sp)
ffffffffc020274e:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202750:	00099617          	auipc	a2,0x99
ffffffffc0202754:	f4063603          	ld	a2,-192(a2) # ffffffffc029b690 <pages>
ffffffffc0202758:	66a2                	ld	a3,8(sp)
ffffffffc020275a:	6742                	ld	a4,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020275c:	12048073          	sfence.vma	s1
ffffffffc0202760:	bfa5                	j	ffffffffc02026d8 <page_insert+0x34>
        intr_disable();
ffffffffc0202762:	ec3a                	sd	a4,24(sp)
ffffffffc0202764:	e836                	sd	a3,16(sp)
ffffffffc0202766:	e42a                	sd	a0,8(sp)
ffffffffc0202768:	99cfe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020276c:	00099797          	auipc	a5,0x99
ffffffffc0202770:	efc7b783          	ld	a5,-260(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc0202774:	6522                	ld	a0,8(sp)
ffffffffc0202776:	4585                	li	a1,1
ffffffffc0202778:	739c                	ld	a5,32(a5)
ffffffffc020277a:	9782                	jalr	a5
        intr_enable();
ffffffffc020277c:	982fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202780:	00099617          	auipc	a2,0x99
ffffffffc0202784:	f1063603          	ld	a2,-240(a2) # ffffffffc029b690 <pages>
ffffffffc0202788:	6762                	ld	a4,24(sp)
ffffffffc020278a:	66c2                	ld	a3,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020278c:	12048073          	sfence.vma	s1
ffffffffc0202790:	b7a1                	j	ffffffffc02026d8 <page_insert+0x34>
        return -E_NO_MEM;
ffffffffc0202792:	5571                	li	a0,-4
ffffffffc0202794:	bfb9                	j	ffffffffc02026f2 <page_insert+0x4e>
ffffffffc0202796:	f14ff0ef          	jal	ffffffffc0201eaa <pa2page.part.0>

ffffffffc020279a <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc020279a:	00005797          	auipc	a5,0x5
ffffffffc020279e:	efe78793          	addi	a5,a5,-258 # ffffffffc0207698 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02027a2:	638c                	ld	a1,0(a5)
{
ffffffffc02027a4:	7159                	addi	sp,sp,-112
ffffffffc02027a6:	f486                	sd	ra,104(sp)
ffffffffc02027a8:	e8ca                	sd	s2,80(sp)
ffffffffc02027aa:	e4ce                	sd	s3,72(sp)
ffffffffc02027ac:	f85a                	sd	s6,48(sp)
ffffffffc02027ae:	f0a2                	sd	s0,96(sp)
ffffffffc02027b0:	eca6                	sd	s1,88(sp)
ffffffffc02027b2:	e0d2                	sd	s4,64(sp)
ffffffffc02027b4:	fc56                	sd	s5,56(sp)
ffffffffc02027b6:	f45e                	sd	s7,40(sp)
ffffffffc02027b8:	f062                	sd	s8,32(sp)
ffffffffc02027ba:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc02027bc:	00099b17          	auipc	s6,0x99
ffffffffc02027c0:	eacb0b13          	addi	s6,s6,-340 # ffffffffc029b668 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02027c4:	00004517          	auipc	a0,0x4
ffffffffc02027c8:	f9450513          	addi	a0,a0,-108 # ffffffffc0206758 <etext+0xec8>
    pmm_manager = &default_pmm_manager;
ffffffffc02027cc:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02027d0:	9c5fd0ef          	jal	ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc02027d4:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02027d8:	00099997          	auipc	s3,0x99
ffffffffc02027dc:	ea898993          	addi	s3,s3,-344 # ffffffffc029b680 <va_pa_offset>
    pmm_manager->init();
ffffffffc02027e0:	679c                	ld	a5,8(a5)
ffffffffc02027e2:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02027e4:	57f5                	li	a5,-3
ffffffffc02027e6:	07fa                	slli	a5,a5,0x1e
ffffffffc02027e8:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc02027ec:	8fefe0ef          	jal	ffffffffc02008ea <get_memory_base>
ffffffffc02027f0:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc02027f2:	902fe0ef          	jal	ffffffffc02008f4 <get_memory_size>
    if (mem_size == 0)
ffffffffc02027f6:	70050e63          	beqz	a0,ffffffffc0202f12 <pmm_init+0x778>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02027fa:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc02027fc:	00004517          	auipc	a0,0x4
ffffffffc0202800:	f9450513          	addi	a0,a0,-108 # ffffffffc0206790 <etext+0xf00>
ffffffffc0202804:	991fd0ef          	jal	ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202808:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc020280c:	864a                	mv	a2,s2
ffffffffc020280e:	85a6                	mv	a1,s1
ffffffffc0202810:	fff40693          	addi	a3,s0,-1
ffffffffc0202814:	00004517          	auipc	a0,0x4
ffffffffc0202818:	f9450513          	addi	a0,a0,-108 # ffffffffc02067a8 <etext+0xf18>
ffffffffc020281c:	979fd0ef          	jal	ffffffffc0200194 <cprintf>
    if (maxpa > KERNTOP)
ffffffffc0202820:	c80007b7          	lui	a5,0xc8000
ffffffffc0202824:	8522                	mv	a0,s0
ffffffffc0202826:	5287ed63          	bltu	a5,s0,ffffffffc0202d60 <pmm_init+0x5c6>
ffffffffc020282a:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020282c:	0009a617          	auipc	a2,0x9a
ffffffffc0202830:	e8b60613          	addi	a2,a2,-373 # ffffffffc029c6b7 <end+0xfff>
ffffffffc0202834:	8e7d                	and	a2,a2,a5
    npage = maxpa / PGSIZE;
ffffffffc0202836:	8131                	srli	a0,a0,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202838:	00099b97          	auipc	s7,0x99
ffffffffc020283c:	e58b8b93          	addi	s7,s7,-424 # ffffffffc029b690 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202840:	00099497          	auipc	s1,0x99
ffffffffc0202844:	e4848493          	addi	s1,s1,-440 # ffffffffc029b688 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202848:	00cbb023          	sd	a2,0(s7)
    npage = maxpa / PGSIZE;
ffffffffc020284c:	e088                	sd	a0,0(s1)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020284e:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202852:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202854:	02f50763          	beq	a0,a5,ffffffffc0202882 <pmm_init+0xe8>
ffffffffc0202858:	4701                	li	a4,0
ffffffffc020285a:	4585                	li	a1,1
ffffffffc020285c:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0202860:	00671793          	slli	a5,a4,0x6
ffffffffc0202864:	97b2                	add	a5,a5,a2
ffffffffc0202866:	07a1                	addi	a5,a5,8 # 80008 <_binary_obj___user_exit_out_size+0x75e48>
ffffffffc0202868:	40b7b02f          	amoor.d	zero,a1,(a5)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020286c:	6088                	ld	a0,0(s1)
ffffffffc020286e:	0705                	addi	a4,a4,1
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202870:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202874:	00d507b3          	add	a5,a0,a3
ffffffffc0202878:	fef764e3          	bltu	a4,a5,ffffffffc0202860 <pmm_init+0xc6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020287c:	079a                	slli	a5,a5,0x6
ffffffffc020287e:	00f606b3          	add	a3,a2,a5
ffffffffc0202882:	c02007b7          	lui	a5,0xc0200
ffffffffc0202886:	16f6eee3          	bltu	a3,a5,ffffffffc0203202 <pmm_init+0xa68>
ffffffffc020288a:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc020288e:	77fd                	lui	a5,0xfffff
ffffffffc0202890:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202892:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202894:	4e86ed63          	bltu	a3,s0,ffffffffc0202d8e <pmm_init+0x5f4>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202898:	00004517          	auipc	a0,0x4
ffffffffc020289c:	f3850513          	addi	a0,a0,-200 # ffffffffc02067d0 <etext+0xf40>
ffffffffc02028a0:	8f5fd0ef          	jal	ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc02028a4:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02028a8:	00099917          	auipc	s2,0x99
ffffffffc02028ac:	dd090913          	addi	s2,s2,-560 # ffffffffc029b678 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc02028b0:	7b9c                	ld	a5,48(a5)
ffffffffc02028b2:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02028b4:	00004517          	auipc	a0,0x4
ffffffffc02028b8:	f3450513          	addi	a0,a0,-204 # ffffffffc02067e8 <etext+0xf58>
ffffffffc02028bc:	8d9fd0ef          	jal	ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02028c0:	00007697          	auipc	a3,0x7
ffffffffc02028c4:	74068693          	addi	a3,a3,1856 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc02028c8:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02028cc:	c02007b7          	lui	a5,0xc0200
ffffffffc02028d0:	2af6eee3          	bltu	a3,a5,ffffffffc020338c <pmm_init+0xbf2>
ffffffffc02028d4:	0009b783          	ld	a5,0(s3)
ffffffffc02028d8:	8e9d                	sub	a3,a3,a5
ffffffffc02028da:	00099797          	auipc	a5,0x99
ffffffffc02028de:	d8d7bb23          	sd	a3,-618(a5) # ffffffffc029b670 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02028e2:	100027f3          	csrr	a5,sstatus
ffffffffc02028e6:	8b89                	andi	a5,a5,2
ffffffffc02028e8:	48079963          	bnez	a5,ffffffffc0202d7a <pmm_init+0x5e0>
        ret = pmm_manager->nr_free_pages();
ffffffffc02028ec:	000b3783          	ld	a5,0(s6)
ffffffffc02028f0:	779c                	ld	a5,40(a5)
ffffffffc02028f2:	9782                	jalr	a5
ffffffffc02028f4:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02028f6:	6098                	ld	a4,0(s1)
ffffffffc02028f8:	c80007b7          	lui	a5,0xc8000
ffffffffc02028fc:	83b1                	srli	a5,a5,0xc
ffffffffc02028fe:	66e7e663          	bltu	a5,a4,ffffffffc0202f6a <pmm_init+0x7d0>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202902:	00093503          	ld	a0,0(s2)
ffffffffc0202906:	64050263          	beqz	a0,ffffffffc0202f4a <pmm_init+0x7b0>
ffffffffc020290a:	03451793          	slli	a5,a0,0x34
ffffffffc020290e:	62079e63          	bnez	a5,ffffffffc0202f4a <pmm_init+0x7b0>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202912:	4601                	li	a2,0
ffffffffc0202914:	4581                	li	a1,0
ffffffffc0202916:	8b7ff0ef          	jal	ffffffffc02021cc <get_page>
ffffffffc020291a:	240519e3          	bnez	a0,ffffffffc020336c <pmm_init+0xbd2>
ffffffffc020291e:	100027f3          	csrr	a5,sstatus
ffffffffc0202922:	8b89                	andi	a5,a5,2
ffffffffc0202924:	44079063          	bnez	a5,ffffffffc0202d64 <pmm_init+0x5ca>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202928:	000b3783          	ld	a5,0(s6)
ffffffffc020292c:	4505                	li	a0,1
ffffffffc020292e:	6f9c                	ld	a5,24(a5)
ffffffffc0202930:	9782                	jalr	a5
ffffffffc0202932:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202934:	00093503          	ld	a0,0(s2)
ffffffffc0202938:	4681                	li	a3,0
ffffffffc020293a:	4601                	li	a2,0
ffffffffc020293c:	85d2                	mv	a1,s4
ffffffffc020293e:	d67ff0ef          	jal	ffffffffc02026a4 <page_insert>
ffffffffc0202942:	280511e3          	bnez	a0,ffffffffc02033c4 <pmm_init+0xc2a>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202946:	00093503          	ld	a0,0(s2)
ffffffffc020294a:	4601                	li	a2,0
ffffffffc020294c:	4581                	li	a1,0
ffffffffc020294e:	e20ff0ef          	jal	ffffffffc0201f6e <get_pte>
ffffffffc0202952:	240509e3          	beqz	a0,ffffffffc02033a4 <pmm_init+0xc0a>
    assert(pte2page(*ptep) == p1);
ffffffffc0202956:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202958:	0017f713          	andi	a4,a5,1
ffffffffc020295c:	58070f63          	beqz	a4,ffffffffc0202efa <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc0202960:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202962:	078a                	slli	a5,a5,0x2
ffffffffc0202964:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202966:	58e7f863          	bgeu	a5,a4,ffffffffc0202ef6 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc020296a:	000bb683          	ld	a3,0(s7)
ffffffffc020296e:	079a                	slli	a5,a5,0x6
ffffffffc0202970:	fe000637          	lui	a2,0xfe000
ffffffffc0202974:	97b2                	add	a5,a5,a2
ffffffffc0202976:	97b6                	add	a5,a5,a3
ffffffffc0202978:	14fa1ae3          	bne	s4,a5,ffffffffc02032cc <pmm_init+0xb32>
    assert(page_ref(p1) == 1);
ffffffffc020297c:	000a2683          	lw	a3,0(s4) # 200000 <_binary_obj___user_exit_out_size+0x1f5e40>
ffffffffc0202980:	4785                	li	a5,1
ffffffffc0202982:	12f695e3          	bne	a3,a5,ffffffffc02032ac <pmm_init+0xb12>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202986:	00093503          	ld	a0,0(s2)
ffffffffc020298a:	77fd                	lui	a5,0xfffff
ffffffffc020298c:	6114                	ld	a3,0(a0)
ffffffffc020298e:	068a                	slli	a3,a3,0x2
ffffffffc0202990:	8efd                	and	a3,a3,a5
ffffffffc0202992:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202996:	0ee67fe3          	bgeu	a2,a4,ffffffffc0203294 <pmm_init+0xafa>
ffffffffc020299a:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020299e:	96e2                	add	a3,a3,s8
ffffffffc02029a0:	0006ba83          	ld	s5,0(a3)
ffffffffc02029a4:	0a8a                	slli	s5,s5,0x2
ffffffffc02029a6:	00fafab3          	and	s5,s5,a5
ffffffffc02029aa:	00cad793          	srli	a5,s5,0xc
ffffffffc02029ae:	0ce7f6e3          	bgeu	a5,a4,ffffffffc020327a <pmm_init+0xae0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02029b2:	4601                	li	a2,0
ffffffffc02029b4:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02029b6:	9c56                	add	s8,s8,s5
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02029b8:	db6ff0ef          	jal	ffffffffc0201f6e <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02029bc:	0c21                	addi	s8,s8,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02029be:	05851ee3          	bne	a0,s8,ffffffffc020321a <pmm_init+0xa80>
ffffffffc02029c2:	100027f3          	csrr	a5,sstatus
ffffffffc02029c6:	8b89                	andi	a5,a5,2
ffffffffc02029c8:	3e079b63          	bnez	a5,ffffffffc0202dbe <pmm_init+0x624>
        page = pmm_manager->alloc_pages(n);
ffffffffc02029cc:	000b3783          	ld	a5,0(s6)
ffffffffc02029d0:	4505                	li	a0,1
ffffffffc02029d2:	6f9c                	ld	a5,24(a5)
ffffffffc02029d4:	9782                	jalr	a5
ffffffffc02029d6:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02029d8:	00093503          	ld	a0,0(s2)
ffffffffc02029dc:	46d1                	li	a3,20
ffffffffc02029de:	6605                	lui	a2,0x1
ffffffffc02029e0:	85e2                	mv	a1,s8
ffffffffc02029e2:	cc3ff0ef          	jal	ffffffffc02026a4 <page_insert>
ffffffffc02029e6:	06051ae3          	bnez	a0,ffffffffc020325a <pmm_init+0xac0>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02029ea:	00093503          	ld	a0,0(s2)
ffffffffc02029ee:	4601                	li	a2,0
ffffffffc02029f0:	6585                	lui	a1,0x1
ffffffffc02029f2:	d7cff0ef          	jal	ffffffffc0201f6e <get_pte>
ffffffffc02029f6:	040502e3          	beqz	a0,ffffffffc020323a <pmm_init+0xaa0>
    assert(*ptep & PTE_U);
ffffffffc02029fa:	611c                	ld	a5,0(a0)
ffffffffc02029fc:	0107f713          	andi	a4,a5,16
ffffffffc0202a00:	7e070163          	beqz	a4,ffffffffc02031e2 <pmm_init+0xa48>
    assert(*ptep & PTE_W);
ffffffffc0202a04:	8b91                	andi	a5,a5,4
ffffffffc0202a06:	7a078e63          	beqz	a5,ffffffffc02031c2 <pmm_init+0xa28>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202a0a:	00093503          	ld	a0,0(s2)
ffffffffc0202a0e:	611c                	ld	a5,0(a0)
ffffffffc0202a10:	8bc1                	andi	a5,a5,16
ffffffffc0202a12:	78078863          	beqz	a5,ffffffffc02031a2 <pmm_init+0xa08>
    assert(page_ref(p2) == 1);
ffffffffc0202a16:	000c2703          	lw	a4,0(s8)
ffffffffc0202a1a:	4785                	li	a5,1
ffffffffc0202a1c:	76f71363          	bne	a4,a5,ffffffffc0203182 <pmm_init+0x9e8>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202a20:	4681                	li	a3,0
ffffffffc0202a22:	6605                	lui	a2,0x1
ffffffffc0202a24:	85d2                	mv	a1,s4
ffffffffc0202a26:	c7fff0ef          	jal	ffffffffc02026a4 <page_insert>
ffffffffc0202a2a:	72051c63          	bnez	a0,ffffffffc0203162 <pmm_init+0x9c8>
    assert(page_ref(p1) == 2);
ffffffffc0202a2e:	000a2703          	lw	a4,0(s4)
ffffffffc0202a32:	4789                	li	a5,2
ffffffffc0202a34:	70f71763          	bne	a4,a5,ffffffffc0203142 <pmm_init+0x9a8>
    assert(page_ref(p2) == 0);
ffffffffc0202a38:	000c2783          	lw	a5,0(s8)
ffffffffc0202a3c:	6e079363          	bnez	a5,ffffffffc0203122 <pmm_init+0x988>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202a40:	00093503          	ld	a0,0(s2)
ffffffffc0202a44:	4601                	li	a2,0
ffffffffc0202a46:	6585                	lui	a1,0x1
ffffffffc0202a48:	d26ff0ef          	jal	ffffffffc0201f6e <get_pte>
ffffffffc0202a4c:	6a050b63          	beqz	a0,ffffffffc0203102 <pmm_init+0x968>
    assert(pte2page(*ptep) == p1);
ffffffffc0202a50:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202a52:	00177793          	andi	a5,a4,1
ffffffffc0202a56:	4a078263          	beqz	a5,ffffffffc0202efa <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc0202a5a:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202a5c:	00271793          	slli	a5,a4,0x2
ffffffffc0202a60:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a62:	48d7fa63          	bgeu	a5,a3,ffffffffc0202ef6 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a66:	000bb683          	ld	a3,0(s7)
ffffffffc0202a6a:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202a6e:	97d6                	add	a5,a5,s5
ffffffffc0202a70:	079a                	slli	a5,a5,0x6
ffffffffc0202a72:	97b6                	add	a5,a5,a3
ffffffffc0202a74:	66fa1763          	bne	s4,a5,ffffffffc02030e2 <pmm_init+0x948>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202a78:	8b41                	andi	a4,a4,16
ffffffffc0202a7a:	64071463          	bnez	a4,ffffffffc02030c2 <pmm_init+0x928>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202a7e:	00093503          	ld	a0,0(s2)
ffffffffc0202a82:	4581                	li	a1,0
ffffffffc0202a84:	b85ff0ef          	jal	ffffffffc0202608 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202a88:	000a2c83          	lw	s9,0(s4)
ffffffffc0202a8c:	4785                	li	a5,1
ffffffffc0202a8e:	60fc9a63          	bne	s9,a5,ffffffffc02030a2 <pmm_init+0x908>
    assert(page_ref(p2) == 0);
ffffffffc0202a92:	000c2783          	lw	a5,0(s8)
ffffffffc0202a96:	5e079663          	bnez	a5,ffffffffc0203082 <pmm_init+0x8e8>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202a9a:	00093503          	ld	a0,0(s2)
ffffffffc0202a9e:	6585                	lui	a1,0x1
ffffffffc0202aa0:	b69ff0ef          	jal	ffffffffc0202608 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202aa4:	000a2783          	lw	a5,0(s4)
ffffffffc0202aa8:	52079d63          	bnez	a5,ffffffffc0202fe2 <pmm_init+0x848>
    assert(page_ref(p2) == 0);
ffffffffc0202aac:	000c2783          	lw	a5,0(s8)
ffffffffc0202ab0:	50079963          	bnez	a5,ffffffffc0202fc2 <pmm_init+0x828>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202ab4:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202ab8:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202aba:	000a3783          	ld	a5,0(s4)
ffffffffc0202abe:	078a                	slli	a5,a5,0x2
ffffffffc0202ac0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ac2:	42e7fa63          	bgeu	a5,a4,ffffffffc0202ef6 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ac6:	000bb503          	ld	a0,0(s7)
ffffffffc0202aca:	97d6                	add	a5,a5,s5
ffffffffc0202acc:	079a                	slli	a5,a5,0x6
    return page->ref;
ffffffffc0202ace:	00f506b3          	add	a3,a0,a5
ffffffffc0202ad2:	4294                	lw	a3,0(a3)
ffffffffc0202ad4:	4d969763          	bne	a3,s9,ffffffffc0202fa2 <pmm_init+0x808>
    return page - pages + nbase;
ffffffffc0202ad8:	8799                	srai	a5,a5,0x6
ffffffffc0202ada:	00080637          	lui	a2,0x80
ffffffffc0202ade:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202ae0:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202ae4:	4ae7f363          	bgeu	a5,a4,ffffffffc0202f8a <pmm_init+0x7f0>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202ae8:	0009b783          	ld	a5,0(s3)
ffffffffc0202aec:	97b6                	add	a5,a5,a3
    return pa2page(PDE_ADDR(pde));
ffffffffc0202aee:	639c                	ld	a5,0(a5)
ffffffffc0202af0:	078a                	slli	a5,a5,0x2
ffffffffc0202af2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202af4:	40e7f163          	bgeu	a5,a4,ffffffffc0202ef6 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202af8:	8f91                	sub	a5,a5,a2
ffffffffc0202afa:	079a                	slli	a5,a5,0x6
ffffffffc0202afc:	953e                	add	a0,a0,a5
ffffffffc0202afe:	100027f3          	csrr	a5,sstatus
ffffffffc0202b02:	8b89                	andi	a5,a5,2
ffffffffc0202b04:	30079863          	bnez	a5,ffffffffc0202e14 <pmm_init+0x67a>
        pmm_manager->free_pages(base, n);
ffffffffc0202b08:	000b3783          	ld	a5,0(s6)
ffffffffc0202b0c:	4585                	li	a1,1
ffffffffc0202b0e:	739c                	ld	a5,32(a5)
ffffffffc0202b10:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b12:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202b16:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b18:	078a                	slli	a5,a5,0x2
ffffffffc0202b1a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b1c:	3ce7fd63          	bgeu	a5,a4,ffffffffc0202ef6 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b20:	000bb503          	ld	a0,0(s7)
ffffffffc0202b24:	fe000737          	lui	a4,0xfe000
ffffffffc0202b28:	079a                	slli	a5,a5,0x6
ffffffffc0202b2a:	97ba                	add	a5,a5,a4
ffffffffc0202b2c:	953e                	add	a0,a0,a5
ffffffffc0202b2e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b32:	8b89                	andi	a5,a5,2
ffffffffc0202b34:	2c079463          	bnez	a5,ffffffffc0202dfc <pmm_init+0x662>
ffffffffc0202b38:	000b3783          	ld	a5,0(s6)
ffffffffc0202b3c:	4585                	li	a1,1
ffffffffc0202b3e:	739c                	ld	a5,32(a5)
ffffffffc0202b40:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202b42:	00093783          	ld	a5,0(s2)
ffffffffc0202b46:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd63948>
    asm volatile("sfence.vma");
ffffffffc0202b4a:	12000073          	sfence.vma
ffffffffc0202b4e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b52:	8b89                	andi	a5,a5,2
ffffffffc0202b54:	28079a63          	bnez	a5,ffffffffc0202de8 <pmm_init+0x64e>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b58:	000b3783          	ld	a5,0(s6)
ffffffffc0202b5c:	779c                	ld	a5,40(a5)
ffffffffc0202b5e:	9782                	jalr	a5
ffffffffc0202b60:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202b62:	4d441063          	bne	s0,s4,ffffffffc0203022 <pmm_init+0x888>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202b66:	00004517          	auipc	a0,0x4
ffffffffc0202b6a:	fd250513          	addi	a0,a0,-46 # ffffffffc0206b38 <etext+0x12a8>
ffffffffc0202b6e:	e26fd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0202b72:	100027f3          	csrr	a5,sstatus
ffffffffc0202b76:	8b89                	andi	a5,a5,2
ffffffffc0202b78:	24079e63          	bnez	a5,ffffffffc0202dd4 <pmm_init+0x63a>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b7c:	000b3783          	ld	a5,0(s6)
ffffffffc0202b80:	779c                	ld	a5,40(a5)
ffffffffc0202b82:	9782                	jalr	a5
ffffffffc0202b84:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b86:	609c                	ld	a5,0(s1)
ffffffffc0202b88:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202b8c:	7a7d                	lui	s4,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b8e:	00c79713          	slli	a4,a5,0xc
ffffffffc0202b92:	6a85                	lui	s5,0x1
ffffffffc0202b94:	02e47c63          	bgeu	s0,a4,ffffffffc0202bcc <pmm_init+0x432>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202b98:	00c45713          	srli	a4,s0,0xc
ffffffffc0202b9c:	30f77063          	bgeu	a4,a5,ffffffffc0202e9c <pmm_init+0x702>
ffffffffc0202ba0:	0009b583          	ld	a1,0(s3)
ffffffffc0202ba4:	00093503          	ld	a0,0(s2)
ffffffffc0202ba8:	4601                	li	a2,0
ffffffffc0202baa:	95a2                	add	a1,a1,s0
ffffffffc0202bac:	bc2ff0ef          	jal	ffffffffc0201f6e <get_pte>
ffffffffc0202bb0:	32050363          	beqz	a0,ffffffffc0202ed6 <pmm_init+0x73c>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202bb4:	611c                	ld	a5,0(a0)
ffffffffc0202bb6:	078a                	slli	a5,a5,0x2
ffffffffc0202bb8:	0147f7b3          	and	a5,a5,s4
ffffffffc0202bbc:	2e879d63          	bne	a5,s0,ffffffffc0202eb6 <pmm_init+0x71c>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202bc0:	609c                	ld	a5,0(s1)
ffffffffc0202bc2:	9456                	add	s0,s0,s5
ffffffffc0202bc4:	00c79713          	slli	a4,a5,0xc
ffffffffc0202bc8:	fce468e3          	bltu	s0,a4,ffffffffc0202b98 <pmm_init+0x3fe>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202bcc:	00093783          	ld	a5,0(s2)
ffffffffc0202bd0:	639c                	ld	a5,0(a5)
ffffffffc0202bd2:	42079863          	bnez	a5,ffffffffc0203002 <pmm_init+0x868>
ffffffffc0202bd6:	100027f3          	csrr	a5,sstatus
ffffffffc0202bda:	8b89                	andi	a5,a5,2
ffffffffc0202bdc:	24079863          	bnez	a5,ffffffffc0202e2c <pmm_init+0x692>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202be0:	000b3783          	ld	a5,0(s6)
ffffffffc0202be4:	4505                	li	a0,1
ffffffffc0202be6:	6f9c                	ld	a5,24(a5)
ffffffffc0202be8:	9782                	jalr	a5
ffffffffc0202bea:	842a                	mv	s0,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202bec:	00093503          	ld	a0,0(s2)
ffffffffc0202bf0:	4699                	li	a3,6
ffffffffc0202bf2:	10000613          	li	a2,256
ffffffffc0202bf6:	85a2                	mv	a1,s0
ffffffffc0202bf8:	aadff0ef          	jal	ffffffffc02026a4 <page_insert>
ffffffffc0202bfc:	46051363          	bnez	a0,ffffffffc0203062 <pmm_init+0x8c8>
    assert(page_ref(p) == 1);
ffffffffc0202c00:	4018                	lw	a4,0(s0)
ffffffffc0202c02:	4785                	li	a5,1
ffffffffc0202c04:	42f71f63          	bne	a4,a5,ffffffffc0203042 <pmm_init+0x8a8>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202c08:	00093503          	ld	a0,0(s2)
ffffffffc0202c0c:	6605                	lui	a2,0x1
ffffffffc0202c0e:	10060613          	addi	a2,a2,256 # 1100 <_binary_obj___user_softint_out_size-0x7ac8>
ffffffffc0202c12:	4699                	li	a3,6
ffffffffc0202c14:	85a2                	mv	a1,s0
ffffffffc0202c16:	a8fff0ef          	jal	ffffffffc02026a4 <page_insert>
ffffffffc0202c1a:	72051963          	bnez	a0,ffffffffc020334c <pmm_init+0xbb2>
    assert(page_ref(p) == 2);
ffffffffc0202c1e:	4018                	lw	a4,0(s0)
ffffffffc0202c20:	4789                	li	a5,2
ffffffffc0202c22:	70f71563          	bne	a4,a5,ffffffffc020332c <pmm_init+0xb92>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202c26:	00004597          	auipc	a1,0x4
ffffffffc0202c2a:	05a58593          	addi	a1,a1,90 # ffffffffc0206c80 <etext+0x13f0>
ffffffffc0202c2e:	10000513          	li	a0,256
ffffffffc0202c32:	3b5020ef          	jal	ffffffffc02057e6 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202c36:	6585                	lui	a1,0x1
ffffffffc0202c38:	10058593          	addi	a1,a1,256 # 1100 <_binary_obj___user_softint_out_size-0x7ac8>
ffffffffc0202c3c:	10000513          	li	a0,256
ffffffffc0202c40:	3b9020ef          	jal	ffffffffc02057f8 <strcmp>
ffffffffc0202c44:	6c051463          	bnez	a0,ffffffffc020330c <pmm_init+0xb72>
    return page - pages + nbase;
ffffffffc0202c48:	000bb683          	ld	a3,0(s7)
ffffffffc0202c4c:	000807b7          	lui	a5,0x80
    return KADDR(page2pa(page));
ffffffffc0202c50:	6098                	ld	a4,0(s1)
    return page - pages + nbase;
ffffffffc0202c52:	40d406b3          	sub	a3,s0,a3
ffffffffc0202c56:	8699                	srai	a3,a3,0x6
ffffffffc0202c58:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0202c5a:	00c69793          	slli	a5,a3,0xc
ffffffffc0202c5e:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c60:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c62:	32e7f463          	bgeu	a5,a4,ffffffffc0202f8a <pmm_init+0x7f0>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202c66:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c6a:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202c6e:	97b6                	add	a5,a5,a3
ffffffffc0202c70:	10078023          	sb	zero,256(a5) # 80100 <_binary_obj___user_exit_out_size+0x75f40>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c74:	33f020ef          	jal	ffffffffc02057b2 <strlen>
ffffffffc0202c78:	66051a63          	bnez	a0,ffffffffc02032ec <pmm_init+0xb52>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202c7c:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202c80:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c82:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fd63948>
ffffffffc0202c86:	078a                	slli	a5,a5,0x2
ffffffffc0202c88:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c8a:	26e7f663          	bgeu	a5,a4,ffffffffc0202ef6 <pmm_init+0x75c>
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c8e:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202c92:	2ee7fc63          	bgeu	a5,a4,ffffffffc0202f8a <pmm_init+0x7f0>
ffffffffc0202c96:	0009b783          	ld	a5,0(s3)
ffffffffc0202c9a:	00f689b3          	add	s3,a3,a5
ffffffffc0202c9e:	100027f3          	csrr	a5,sstatus
ffffffffc0202ca2:	8b89                	andi	a5,a5,2
ffffffffc0202ca4:	1e079163          	bnez	a5,ffffffffc0202e86 <pmm_init+0x6ec>
        pmm_manager->free_pages(base, n);
ffffffffc0202ca8:	000b3783          	ld	a5,0(s6)
ffffffffc0202cac:	8522                	mv	a0,s0
ffffffffc0202cae:	4585                	li	a1,1
ffffffffc0202cb0:	739c                	ld	a5,32(a5)
ffffffffc0202cb2:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cb4:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage)
ffffffffc0202cb8:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cba:	078a                	slli	a5,a5,0x2
ffffffffc0202cbc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cbe:	22e7fc63          	bgeu	a5,a4,ffffffffc0202ef6 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202cc2:	000bb503          	ld	a0,0(s7)
ffffffffc0202cc6:	fe000737          	lui	a4,0xfe000
ffffffffc0202cca:	079a                	slli	a5,a5,0x6
ffffffffc0202ccc:	97ba                	add	a5,a5,a4
ffffffffc0202cce:	953e                	add	a0,a0,a5
ffffffffc0202cd0:	100027f3          	csrr	a5,sstatus
ffffffffc0202cd4:	8b89                	andi	a5,a5,2
ffffffffc0202cd6:	18079c63          	bnez	a5,ffffffffc0202e6e <pmm_init+0x6d4>
ffffffffc0202cda:	000b3783          	ld	a5,0(s6)
ffffffffc0202cde:	4585                	li	a1,1
ffffffffc0202ce0:	739c                	ld	a5,32(a5)
ffffffffc0202ce2:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ce4:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202ce8:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cea:	078a                	slli	a5,a5,0x2
ffffffffc0202cec:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cee:	20e7f463          	bgeu	a5,a4,ffffffffc0202ef6 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202cf2:	000bb503          	ld	a0,0(s7)
ffffffffc0202cf6:	fe000737          	lui	a4,0xfe000
ffffffffc0202cfa:	079a                	slli	a5,a5,0x6
ffffffffc0202cfc:	97ba                	add	a5,a5,a4
ffffffffc0202cfe:	953e                	add	a0,a0,a5
ffffffffc0202d00:	100027f3          	csrr	a5,sstatus
ffffffffc0202d04:	8b89                	andi	a5,a5,2
ffffffffc0202d06:	14079863          	bnez	a5,ffffffffc0202e56 <pmm_init+0x6bc>
ffffffffc0202d0a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d0e:	4585                	li	a1,1
ffffffffc0202d10:	739c                	ld	a5,32(a5)
ffffffffc0202d12:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202d14:	00093783          	ld	a5,0(s2)
ffffffffc0202d18:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202d1c:	12000073          	sfence.vma
ffffffffc0202d20:	100027f3          	csrr	a5,sstatus
ffffffffc0202d24:	8b89                	andi	a5,a5,2
ffffffffc0202d26:	10079e63          	bnez	a5,ffffffffc0202e42 <pmm_init+0x6a8>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d2a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d2e:	779c                	ld	a5,40(a5)
ffffffffc0202d30:	9782                	jalr	a5
ffffffffc0202d32:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202d34:	1e8c1b63          	bne	s8,s0,ffffffffc0202f2a <pmm_init+0x790>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202d38:	00004517          	auipc	a0,0x4
ffffffffc0202d3c:	fc050513          	addi	a0,a0,-64 # ffffffffc0206cf8 <etext+0x1468>
ffffffffc0202d40:	c54fd0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0202d44:	7406                	ld	s0,96(sp)
ffffffffc0202d46:	70a6                	ld	ra,104(sp)
ffffffffc0202d48:	64e6                	ld	s1,88(sp)
ffffffffc0202d4a:	6946                	ld	s2,80(sp)
ffffffffc0202d4c:	69a6                	ld	s3,72(sp)
ffffffffc0202d4e:	6a06                	ld	s4,64(sp)
ffffffffc0202d50:	7ae2                	ld	s5,56(sp)
ffffffffc0202d52:	7b42                	ld	s6,48(sp)
ffffffffc0202d54:	7ba2                	ld	s7,40(sp)
ffffffffc0202d56:	7c02                	ld	s8,32(sp)
ffffffffc0202d58:	6ce2                	ld	s9,24(sp)
ffffffffc0202d5a:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202d5c:	f85fe06f          	j	ffffffffc0201ce0 <kmalloc_init>
    if (maxpa > KERNTOP)
ffffffffc0202d60:	853e                	mv	a0,a5
ffffffffc0202d62:	b4e1                	j	ffffffffc020282a <pmm_init+0x90>
        intr_disable();
ffffffffc0202d64:	ba1fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202d68:	000b3783          	ld	a5,0(s6)
ffffffffc0202d6c:	4505                	li	a0,1
ffffffffc0202d6e:	6f9c                	ld	a5,24(a5)
ffffffffc0202d70:	9782                	jalr	a5
ffffffffc0202d72:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202d74:	b8bfd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202d78:	be75                	j	ffffffffc0202934 <pmm_init+0x19a>
        intr_disable();
ffffffffc0202d7a:	b8bfd0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d7e:	000b3783          	ld	a5,0(s6)
ffffffffc0202d82:	779c                	ld	a5,40(a5)
ffffffffc0202d84:	9782                	jalr	a5
ffffffffc0202d86:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202d88:	b77fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202d8c:	b6ad                	j	ffffffffc02028f6 <pmm_init+0x15c>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202d8e:	6705                	lui	a4,0x1
ffffffffc0202d90:	177d                	addi	a4,a4,-1 # fff <_binary_obj___user_softint_out_size-0x7bc9>
ffffffffc0202d92:	96ba                	add	a3,a3,a4
ffffffffc0202d94:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202d96:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202d9a:	14a77e63          	bgeu	a4,a0,ffffffffc0202ef6 <pmm_init+0x75c>
    pmm_manager->init_memmap(base, n);
ffffffffc0202d9e:	000b3683          	ld	a3,0(s6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202da2:	8c1d                	sub	s0,s0,a5
    return &pages[PPN(pa) - nbase];
ffffffffc0202da4:	071a                	slli	a4,a4,0x6
ffffffffc0202da6:	fe0007b7          	lui	a5,0xfe000
ffffffffc0202daa:	973e                	add	a4,a4,a5
    pmm_manager->init_memmap(base, n);
ffffffffc0202dac:	6a9c                	ld	a5,16(a3)
ffffffffc0202dae:	00c45593          	srli	a1,s0,0xc
ffffffffc0202db2:	00e60533          	add	a0,a2,a4
ffffffffc0202db6:	9782                	jalr	a5
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202db8:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202dbc:	bcf1                	j	ffffffffc0202898 <pmm_init+0xfe>
        intr_disable();
ffffffffc0202dbe:	b47fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202dc2:	000b3783          	ld	a5,0(s6)
ffffffffc0202dc6:	4505                	li	a0,1
ffffffffc0202dc8:	6f9c                	ld	a5,24(a5)
ffffffffc0202dca:	9782                	jalr	a5
ffffffffc0202dcc:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202dce:	b31fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202dd2:	b119                	j	ffffffffc02029d8 <pmm_init+0x23e>
        intr_disable();
ffffffffc0202dd4:	b31fd0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202dd8:	000b3783          	ld	a5,0(s6)
ffffffffc0202ddc:	779c                	ld	a5,40(a5)
ffffffffc0202dde:	9782                	jalr	a5
ffffffffc0202de0:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202de2:	b1dfd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202de6:	b345                	j	ffffffffc0202b86 <pmm_init+0x3ec>
        intr_disable();
ffffffffc0202de8:	b1dfd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202dec:	000b3783          	ld	a5,0(s6)
ffffffffc0202df0:	779c                	ld	a5,40(a5)
ffffffffc0202df2:	9782                	jalr	a5
ffffffffc0202df4:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202df6:	b09fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202dfa:	b3a5                	j	ffffffffc0202b62 <pmm_init+0x3c8>
ffffffffc0202dfc:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202dfe:	b07fd0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e02:	000b3783          	ld	a5,0(s6)
ffffffffc0202e06:	6522                	ld	a0,8(sp)
ffffffffc0202e08:	4585                	li	a1,1
ffffffffc0202e0a:	739c                	ld	a5,32(a5)
ffffffffc0202e0c:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e0e:	af1fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e12:	bb05                	j	ffffffffc0202b42 <pmm_init+0x3a8>
ffffffffc0202e14:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e16:	aeffd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202e1a:	000b3783          	ld	a5,0(s6)
ffffffffc0202e1e:	6522                	ld	a0,8(sp)
ffffffffc0202e20:	4585                	li	a1,1
ffffffffc0202e22:	739c                	ld	a5,32(a5)
ffffffffc0202e24:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e26:	ad9fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e2a:	b1e5                	j	ffffffffc0202b12 <pmm_init+0x378>
        intr_disable();
ffffffffc0202e2c:	ad9fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202e30:	000b3783          	ld	a5,0(s6)
ffffffffc0202e34:	4505                	li	a0,1
ffffffffc0202e36:	6f9c                	ld	a5,24(a5)
ffffffffc0202e38:	9782                	jalr	a5
ffffffffc0202e3a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202e3c:	ac3fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e40:	b375                	j	ffffffffc0202bec <pmm_init+0x452>
        intr_disable();
ffffffffc0202e42:	ac3fd0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202e46:	000b3783          	ld	a5,0(s6)
ffffffffc0202e4a:	779c                	ld	a5,40(a5)
ffffffffc0202e4c:	9782                	jalr	a5
ffffffffc0202e4e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202e50:	aaffd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e54:	b5c5                	j	ffffffffc0202d34 <pmm_init+0x59a>
ffffffffc0202e56:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e58:	aadfd0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e5c:	000b3783          	ld	a5,0(s6)
ffffffffc0202e60:	6522                	ld	a0,8(sp)
ffffffffc0202e62:	4585                	li	a1,1
ffffffffc0202e64:	739c                	ld	a5,32(a5)
ffffffffc0202e66:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e68:	a97fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e6c:	b565                	j	ffffffffc0202d14 <pmm_init+0x57a>
ffffffffc0202e6e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e70:	a95fd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202e74:	000b3783          	ld	a5,0(s6)
ffffffffc0202e78:	6522                	ld	a0,8(sp)
ffffffffc0202e7a:	4585                	li	a1,1
ffffffffc0202e7c:	739c                	ld	a5,32(a5)
ffffffffc0202e7e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e80:	a7ffd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e84:	b585                	j	ffffffffc0202ce4 <pmm_init+0x54a>
        intr_disable();
ffffffffc0202e86:	a7ffd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202e8a:	000b3783          	ld	a5,0(s6)
ffffffffc0202e8e:	8522                	mv	a0,s0
ffffffffc0202e90:	4585                	li	a1,1
ffffffffc0202e92:	739c                	ld	a5,32(a5)
ffffffffc0202e94:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e96:	a69fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e9a:	bd29                	j	ffffffffc0202cb4 <pmm_init+0x51a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202e9c:	86a2                	mv	a3,s0
ffffffffc0202e9e:	00003617          	auipc	a2,0x3
ffffffffc0202ea2:	77260613          	addi	a2,a2,1906 # ffffffffc0206610 <etext+0xd80>
ffffffffc0202ea6:	24c00593          	li	a1,588
ffffffffc0202eaa:	00004517          	auipc	a0,0x4
ffffffffc0202eae:	85650513          	addi	a0,a0,-1962 # ffffffffc0206700 <etext+0xe70>
ffffffffc0202eb2:	d94fd0ef          	jal	ffffffffc0200446 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202eb6:	00004697          	auipc	a3,0x4
ffffffffc0202eba:	ce268693          	addi	a3,a3,-798 # ffffffffc0206b98 <etext+0x1308>
ffffffffc0202ebe:	00003617          	auipc	a2,0x3
ffffffffc0202ec2:	3a260613          	addi	a2,a2,930 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0202ec6:	24d00593          	li	a1,589
ffffffffc0202eca:	00004517          	auipc	a0,0x4
ffffffffc0202ece:	83650513          	addi	a0,a0,-1994 # ffffffffc0206700 <etext+0xe70>
ffffffffc0202ed2:	d74fd0ef          	jal	ffffffffc0200446 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202ed6:	00004697          	auipc	a3,0x4
ffffffffc0202eda:	c8268693          	addi	a3,a3,-894 # ffffffffc0206b58 <etext+0x12c8>
ffffffffc0202ede:	00003617          	auipc	a2,0x3
ffffffffc0202ee2:	38260613          	addi	a2,a2,898 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0202ee6:	24c00593          	li	a1,588
ffffffffc0202eea:	00004517          	auipc	a0,0x4
ffffffffc0202eee:	81650513          	addi	a0,a0,-2026 # ffffffffc0206700 <etext+0xe70>
ffffffffc0202ef2:	d54fd0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0202ef6:	fb5fe0ef          	jal	ffffffffc0201eaa <pa2page.part.0>
        panic("pte2page called with invalid pte");
ffffffffc0202efa:	00004617          	auipc	a2,0x4
ffffffffc0202efe:	9fe60613          	addi	a2,a2,-1538 # ffffffffc02068f8 <etext+0x1068>
ffffffffc0202f02:	07f00593          	li	a1,127
ffffffffc0202f06:	00003517          	auipc	a0,0x3
ffffffffc0202f0a:	73250513          	addi	a0,a0,1842 # ffffffffc0206638 <etext+0xda8>
ffffffffc0202f0e:	d38fd0ef          	jal	ffffffffc0200446 <__panic>
        panic("DTB memory info not available");
ffffffffc0202f12:	00004617          	auipc	a2,0x4
ffffffffc0202f16:	85e60613          	addi	a2,a2,-1954 # ffffffffc0206770 <etext+0xee0>
ffffffffc0202f1a:	06500593          	li	a1,101
ffffffffc0202f1e:	00003517          	auipc	a0,0x3
ffffffffc0202f22:	7e250513          	addi	a0,a0,2018 # ffffffffc0206700 <etext+0xe70>
ffffffffc0202f26:	d20fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202f2a:	00004697          	auipc	a3,0x4
ffffffffc0202f2e:	be668693          	addi	a3,a3,-1050 # ffffffffc0206b10 <etext+0x1280>
ffffffffc0202f32:	00003617          	auipc	a2,0x3
ffffffffc0202f36:	32e60613          	addi	a2,a2,814 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0202f3a:	26700593          	li	a1,615
ffffffffc0202f3e:	00003517          	auipc	a0,0x3
ffffffffc0202f42:	7c250513          	addi	a0,a0,1986 # ffffffffc0206700 <etext+0xe70>
ffffffffc0202f46:	d00fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202f4a:	00004697          	auipc	a3,0x4
ffffffffc0202f4e:	8de68693          	addi	a3,a3,-1826 # ffffffffc0206828 <etext+0xf98>
ffffffffc0202f52:	00003617          	auipc	a2,0x3
ffffffffc0202f56:	30e60613          	addi	a2,a2,782 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0202f5a:	20e00593          	li	a1,526
ffffffffc0202f5e:	00003517          	auipc	a0,0x3
ffffffffc0202f62:	7a250513          	addi	a0,a0,1954 # ffffffffc0206700 <etext+0xe70>
ffffffffc0202f66:	ce0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202f6a:	00004697          	auipc	a3,0x4
ffffffffc0202f6e:	89e68693          	addi	a3,a3,-1890 # ffffffffc0206808 <etext+0xf78>
ffffffffc0202f72:	00003617          	auipc	a2,0x3
ffffffffc0202f76:	2ee60613          	addi	a2,a2,750 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0202f7a:	20d00593          	li	a1,525
ffffffffc0202f7e:	00003517          	auipc	a0,0x3
ffffffffc0202f82:	78250513          	addi	a0,a0,1922 # ffffffffc0206700 <etext+0xe70>
ffffffffc0202f86:	cc0fd0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202f8a:	00003617          	auipc	a2,0x3
ffffffffc0202f8e:	68660613          	addi	a2,a2,1670 # ffffffffc0206610 <etext+0xd80>
ffffffffc0202f92:	07100593          	li	a1,113
ffffffffc0202f96:	00003517          	auipc	a0,0x3
ffffffffc0202f9a:	6a250513          	addi	a0,a0,1698 # ffffffffc0206638 <etext+0xda8>
ffffffffc0202f9e:	ca8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202fa2:	00004697          	auipc	a3,0x4
ffffffffc0202fa6:	b3e68693          	addi	a3,a3,-1218 # ffffffffc0206ae0 <etext+0x1250>
ffffffffc0202faa:	00003617          	auipc	a2,0x3
ffffffffc0202fae:	2b660613          	addi	a2,a2,694 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0202fb2:	23500593          	li	a1,565
ffffffffc0202fb6:	00003517          	auipc	a0,0x3
ffffffffc0202fba:	74a50513          	addi	a0,a0,1866 # ffffffffc0206700 <etext+0xe70>
ffffffffc0202fbe:	c88fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202fc2:	00004697          	auipc	a3,0x4
ffffffffc0202fc6:	ad668693          	addi	a3,a3,-1322 # ffffffffc0206a98 <etext+0x1208>
ffffffffc0202fca:	00003617          	auipc	a2,0x3
ffffffffc0202fce:	29660613          	addi	a2,a2,662 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0202fd2:	23300593          	li	a1,563
ffffffffc0202fd6:	00003517          	auipc	a0,0x3
ffffffffc0202fda:	72a50513          	addi	a0,a0,1834 # ffffffffc0206700 <etext+0xe70>
ffffffffc0202fde:	c68fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202fe2:	00004697          	auipc	a3,0x4
ffffffffc0202fe6:	ae668693          	addi	a3,a3,-1306 # ffffffffc0206ac8 <etext+0x1238>
ffffffffc0202fea:	00003617          	auipc	a2,0x3
ffffffffc0202fee:	27660613          	addi	a2,a2,630 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0202ff2:	23200593          	li	a1,562
ffffffffc0202ff6:	00003517          	auipc	a0,0x3
ffffffffc0202ffa:	70a50513          	addi	a0,a0,1802 # ffffffffc0206700 <etext+0xe70>
ffffffffc0202ffe:	c48fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0203002:	00004697          	auipc	a3,0x4
ffffffffc0203006:	bae68693          	addi	a3,a3,-1106 # ffffffffc0206bb0 <etext+0x1320>
ffffffffc020300a:	00003617          	auipc	a2,0x3
ffffffffc020300e:	25660613          	addi	a2,a2,598 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203012:	25000593          	li	a1,592
ffffffffc0203016:	00003517          	auipc	a0,0x3
ffffffffc020301a:	6ea50513          	addi	a0,a0,1770 # ffffffffc0206700 <etext+0xe70>
ffffffffc020301e:	c28fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203022:	00004697          	auipc	a3,0x4
ffffffffc0203026:	aee68693          	addi	a3,a3,-1298 # ffffffffc0206b10 <etext+0x1280>
ffffffffc020302a:	00003617          	auipc	a2,0x3
ffffffffc020302e:	23660613          	addi	a2,a2,566 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203032:	23d00593          	li	a1,573
ffffffffc0203036:	00003517          	auipc	a0,0x3
ffffffffc020303a:	6ca50513          	addi	a0,a0,1738 # ffffffffc0206700 <etext+0xe70>
ffffffffc020303e:	c08fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p) == 1);
ffffffffc0203042:	00004697          	auipc	a3,0x4
ffffffffc0203046:	bc668693          	addi	a3,a3,-1082 # ffffffffc0206c08 <etext+0x1378>
ffffffffc020304a:	00003617          	auipc	a2,0x3
ffffffffc020304e:	21660613          	addi	a2,a2,534 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203052:	25500593          	li	a1,597
ffffffffc0203056:	00003517          	auipc	a0,0x3
ffffffffc020305a:	6aa50513          	addi	a0,a0,1706 # ffffffffc0206700 <etext+0xe70>
ffffffffc020305e:	be8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0203062:	00004697          	auipc	a3,0x4
ffffffffc0203066:	b6668693          	addi	a3,a3,-1178 # ffffffffc0206bc8 <etext+0x1338>
ffffffffc020306a:	00003617          	auipc	a2,0x3
ffffffffc020306e:	1f660613          	addi	a2,a2,502 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203072:	25400593          	li	a1,596
ffffffffc0203076:	00003517          	auipc	a0,0x3
ffffffffc020307a:	68a50513          	addi	a0,a0,1674 # ffffffffc0206700 <etext+0xe70>
ffffffffc020307e:	bc8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203082:	00004697          	auipc	a3,0x4
ffffffffc0203086:	a1668693          	addi	a3,a3,-1514 # ffffffffc0206a98 <etext+0x1208>
ffffffffc020308a:	00003617          	auipc	a2,0x3
ffffffffc020308e:	1d660613          	addi	a2,a2,470 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203092:	22f00593          	li	a1,559
ffffffffc0203096:	00003517          	auipc	a0,0x3
ffffffffc020309a:	66a50513          	addi	a0,a0,1642 # ffffffffc0206700 <etext+0xe70>
ffffffffc020309e:	ba8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02030a2:	00004697          	auipc	a3,0x4
ffffffffc02030a6:	89668693          	addi	a3,a3,-1898 # ffffffffc0206938 <etext+0x10a8>
ffffffffc02030aa:	00003617          	auipc	a2,0x3
ffffffffc02030ae:	1b660613          	addi	a2,a2,438 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02030b2:	22e00593          	li	a1,558
ffffffffc02030b6:	00003517          	auipc	a0,0x3
ffffffffc02030ba:	64a50513          	addi	a0,a0,1610 # ffffffffc0206700 <etext+0xe70>
ffffffffc02030be:	b88fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc02030c2:	00004697          	auipc	a3,0x4
ffffffffc02030c6:	9ee68693          	addi	a3,a3,-1554 # ffffffffc0206ab0 <etext+0x1220>
ffffffffc02030ca:	00003617          	auipc	a2,0x3
ffffffffc02030ce:	19660613          	addi	a2,a2,406 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02030d2:	22b00593          	li	a1,555
ffffffffc02030d6:	00003517          	auipc	a0,0x3
ffffffffc02030da:	62a50513          	addi	a0,a0,1578 # ffffffffc0206700 <etext+0xe70>
ffffffffc02030de:	b68fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02030e2:	00004697          	auipc	a3,0x4
ffffffffc02030e6:	83e68693          	addi	a3,a3,-1986 # ffffffffc0206920 <etext+0x1090>
ffffffffc02030ea:	00003617          	auipc	a2,0x3
ffffffffc02030ee:	17660613          	addi	a2,a2,374 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02030f2:	22a00593          	li	a1,554
ffffffffc02030f6:	00003517          	auipc	a0,0x3
ffffffffc02030fa:	60a50513          	addi	a0,a0,1546 # ffffffffc0206700 <etext+0xe70>
ffffffffc02030fe:	b48fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203102:	00004697          	auipc	a3,0x4
ffffffffc0203106:	8be68693          	addi	a3,a3,-1858 # ffffffffc02069c0 <etext+0x1130>
ffffffffc020310a:	00003617          	auipc	a2,0x3
ffffffffc020310e:	15660613          	addi	a2,a2,342 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203112:	22900593          	li	a1,553
ffffffffc0203116:	00003517          	auipc	a0,0x3
ffffffffc020311a:	5ea50513          	addi	a0,a0,1514 # ffffffffc0206700 <etext+0xe70>
ffffffffc020311e:	b28fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203122:	00004697          	auipc	a3,0x4
ffffffffc0203126:	97668693          	addi	a3,a3,-1674 # ffffffffc0206a98 <etext+0x1208>
ffffffffc020312a:	00003617          	auipc	a2,0x3
ffffffffc020312e:	13660613          	addi	a2,a2,310 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203132:	22800593          	li	a1,552
ffffffffc0203136:	00003517          	auipc	a0,0x3
ffffffffc020313a:	5ca50513          	addi	a0,a0,1482 # ffffffffc0206700 <etext+0xe70>
ffffffffc020313e:	b08fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0203142:	00004697          	auipc	a3,0x4
ffffffffc0203146:	93e68693          	addi	a3,a3,-1730 # ffffffffc0206a80 <etext+0x11f0>
ffffffffc020314a:	00003617          	auipc	a2,0x3
ffffffffc020314e:	11660613          	addi	a2,a2,278 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203152:	22700593          	li	a1,551
ffffffffc0203156:	00003517          	auipc	a0,0x3
ffffffffc020315a:	5aa50513          	addi	a0,a0,1450 # ffffffffc0206700 <etext+0xe70>
ffffffffc020315e:	ae8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0203162:	00004697          	auipc	a3,0x4
ffffffffc0203166:	8ee68693          	addi	a3,a3,-1810 # ffffffffc0206a50 <etext+0x11c0>
ffffffffc020316a:	00003617          	auipc	a2,0x3
ffffffffc020316e:	0f660613          	addi	a2,a2,246 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203172:	22600593          	li	a1,550
ffffffffc0203176:	00003517          	auipc	a0,0x3
ffffffffc020317a:	58a50513          	addi	a0,a0,1418 # ffffffffc0206700 <etext+0xe70>
ffffffffc020317e:	ac8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0203182:	00004697          	auipc	a3,0x4
ffffffffc0203186:	8b668693          	addi	a3,a3,-1866 # ffffffffc0206a38 <etext+0x11a8>
ffffffffc020318a:	00003617          	auipc	a2,0x3
ffffffffc020318e:	0d660613          	addi	a2,a2,214 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203192:	22400593          	li	a1,548
ffffffffc0203196:	00003517          	auipc	a0,0x3
ffffffffc020319a:	56a50513          	addi	a0,a0,1386 # ffffffffc0206700 <etext+0xe70>
ffffffffc020319e:	aa8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02031a2:	00004697          	auipc	a3,0x4
ffffffffc02031a6:	87668693          	addi	a3,a3,-1930 # ffffffffc0206a18 <etext+0x1188>
ffffffffc02031aa:	00003617          	auipc	a2,0x3
ffffffffc02031ae:	0b660613          	addi	a2,a2,182 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02031b2:	22300593          	li	a1,547
ffffffffc02031b6:	00003517          	auipc	a0,0x3
ffffffffc02031ba:	54a50513          	addi	a0,a0,1354 # ffffffffc0206700 <etext+0xe70>
ffffffffc02031be:	a88fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(*ptep & PTE_W);
ffffffffc02031c2:	00004697          	auipc	a3,0x4
ffffffffc02031c6:	84668693          	addi	a3,a3,-1978 # ffffffffc0206a08 <etext+0x1178>
ffffffffc02031ca:	00003617          	auipc	a2,0x3
ffffffffc02031ce:	09660613          	addi	a2,a2,150 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02031d2:	22200593          	li	a1,546
ffffffffc02031d6:	00003517          	auipc	a0,0x3
ffffffffc02031da:	52a50513          	addi	a0,a0,1322 # ffffffffc0206700 <etext+0xe70>
ffffffffc02031de:	a68fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(*ptep & PTE_U);
ffffffffc02031e2:	00004697          	auipc	a3,0x4
ffffffffc02031e6:	81668693          	addi	a3,a3,-2026 # ffffffffc02069f8 <etext+0x1168>
ffffffffc02031ea:	00003617          	auipc	a2,0x3
ffffffffc02031ee:	07660613          	addi	a2,a2,118 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02031f2:	22100593          	li	a1,545
ffffffffc02031f6:	00003517          	auipc	a0,0x3
ffffffffc02031fa:	50a50513          	addi	a0,a0,1290 # ffffffffc0206700 <etext+0xe70>
ffffffffc02031fe:	a48fd0ef          	jal	ffffffffc0200446 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203202:	00003617          	auipc	a2,0x3
ffffffffc0203206:	4b660613          	addi	a2,a2,1206 # ffffffffc02066b8 <etext+0xe28>
ffffffffc020320a:	08100593          	li	a1,129
ffffffffc020320e:	00003517          	auipc	a0,0x3
ffffffffc0203212:	4f250513          	addi	a0,a0,1266 # ffffffffc0206700 <etext+0xe70>
ffffffffc0203216:	a30fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020321a:	00003697          	auipc	a3,0x3
ffffffffc020321e:	73668693          	addi	a3,a3,1846 # ffffffffc0206950 <etext+0x10c0>
ffffffffc0203222:	00003617          	auipc	a2,0x3
ffffffffc0203226:	03e60613          	addi	a2,a2,62 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020322a:	21c00593          	li	a1,540
ffffffffc020322e:	00003517          	auipc	a0,0x3
ffffffffc0203232:	4d250513          	addi	a0,a0,1234 # ffffffffc0206700 <etext+0xe70>
ffffffffc0203236:	a10fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020323a:	00003697          	auipc	a3,0x3
ffffffffc020323e:	78668693          	addi	a3,a3,1926 # ffffffffc02069c0 <etext+0x1130>
ffffffffc0203242:	00003617          	auipc	a2,0x3
ffffffffc0203246:	01e60613          	addi	a2,a2,30 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020324a:	22000593          	li	a1,544
ffffffffc020324e:	00003517          	auipc	a0,0x3
ffffffffc0203252:	4b250513          	addi	a0,a0,1202 # ffffffffc0206700 <etext+0xe70>
ffffffffc0203256:	9f0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020325a:	00003697          	auipc	a3,0x3
ffffffffc020325e:	72668693          	addi	a3,a3,1830 # ffffffffc0206980 <etext+0x10f0>
ffffffffc0203262:	00003617          	auipc	a2,0x3
ffffffffc0203266:	ffe60613          	addi	a2,a2,-2 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020326a:	21f00593          	li	a1,543
ffffffffc020326e:	00003517          	auipc	a0,0x3
ffffffffc0203272:	49250513          	addi	a0,a0,1170 # ffffffffc0206700 <etext+0xe70>
ffffffffc0203276:	9d0fd0ef          	jal	ffffffffc0200446 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020327a:	86d6                	mv	a3,s5
ffffffffc020327c:	00003617          	auipc	a2,0x3
ffffffffc0203280:	39460613          	addi	a2,a2,916 # ffffffffc0206610 <etext+0xd80>
ffffffffc0203284:	21b00593          	li	a1,539
ffffffffc0203288:	00003517          	auipc	a0,0x3
ffffffffc020328c:	47850513          	addi	a0,a0,1144 # ffffffffc0206700 <etext+0xe70>
ffffffffc0203290:	9b6fd0ef          	jal	ffffffffc0200446 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0203294:	00003617          	auipc	a2,0x3
ffffffffc0203298:	37c60613          	addi	a2,a2,892 # ffffffffc0206610 <etext+0xd80>
ffffffffc020329c:	21a00593          	li	a1,538
ffffffffc02032a0:	00003517          	auipc	a0,0x3
ffffffffc02032a4:	46050513          	addi	a0,a0,1120 # ffffffffc0206700 <etext+0xe70>
ffffffffc02032a8:	99efd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02032ac:	00003697          	auipc	a3,0x3
ffffffffc02032b0:	68c68693          	addi	a3,a3,1676 # ffffffffc0206938 <etext+0x10a8>
ffffffffc02032b4:	00003617          	auipc	a2,0x3
ffffffffc02032b8:	fac60613          	addi	a2,a2,-84 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02032bc:	21800593          	li	a1,536
ffffffffc02032c0:	00003517          	auipc	a0,0x3
ffffffffc02032c4:	44050513          	addi	a0,a0,1088 # ffffffffc0206700 <etext+0xe70>
ffffffffc02032c8:	97efd0ef          	jal	ffffffffc0200446 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02032cc:	00003697          	auipc	a3,0x3
ffffffffc02032d0:	65468693          	addi	a3,a3,1620 # ffffffffc0206920 <etext+0x1090>
ffffffffc02032d4:	00003617          	auipc	a2,0x3
ffffffffc02032d8:	f8c60613          	addi	a2,a2,-116 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02032dc:	21700593          	li	a1,535
ffffffffc02032e0:	00003517          	auipc	a0,0x3
ffffffffc02032e4:	42050513          	addi	a0,a0,1056 # ffffffffc0206700 <etext+0xe70>
ffffffffc02032e8:	95efd0ef          	jal	ffffffffc0200446 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02032ec:	00004697          	auipc	a3,0x4
ffffffffc02032f0:	9e468693          	addi	a3,a3,-1564 # ffffffffc0206cd0 <etext+0x1440>
ffffffffc02032f4:	00003617          	auipc	a2,0x3
ffffffffc02032f8:	f6c60613          	addi	a2,a2,-148 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02032fc:	25e00593          	li	a1,606
ffffffffc0203300:	00003517          	auipc	a0,0x3
ffffffffc0203304:	40050513          	addi	a0,a0,1024 # ffffffffc0206700 <etext+0xe70>
ffffffffc0203308:	93efd0ef          	jal	ffffffffc0200446 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc020330c:	00004697          	auipc	a3,0x4
ffffffffc0203310:	98c68693          	addi	a3,a3,-1652 # ffffffffc0206c98 <etext+0x1408>
ffffffffc0203314:	00003617          	auipc	a2,0x3
ffffffffc0203318:	f4c60613          	addi	a2,a2,-180 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020331c:	25b00593          	li	a1,603
ffffffffc0203320:	00003517          	auipc	a0,0x3
ffffffffc0203324:	3e050513          	addi	a0,a0,992 # ffffffffc0206700 <etext+0xe70>
ffffffffc0203328:	91efd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p) == 2);
ffffffffc020332c:	00004697          	auipc	a3,0x4
ffffffffc0203330:	93c68693          	addi	a3,a3,-1732 # ffffffffc0206c68 <etext+0x13d8>
ffffffffc0203334:	00003617          	auipc	a2,0x3
ffffffffc0203338:	f2c60613          	addi	a2,a2,-212 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020333c:	25700593          	li	a1,599
ffffffffc0203340:	00003517          	auipc	a0,0x3
ffffffffc0203344:	3c050513          	addi	a0,a0,960 # ffffffffc0206700 <etext+0xe70>
ffffffffc0203348:	8fefd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc020334c:	00004697          	auipc	a3,0x4
ffffffffc0203350:	8d468693          	addi	a3,a3,-1836 # ffffffffc0206c20 <etext+0x1390>
ffffffffc0203354:	00003617          	auipc	a2,0x3
ffffffffc0203358:	f0c60613          	addi	a2,a2,-244 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020335c:	25600593          	li	a1,598
ffffffffc0203360:	00003517          	auipc	a0,0x3
ffffffffc0203364:	3a050513          	addi	a0,a0,928 # ffffffffc0206700 <etext+0xe70>
ffffffffc0203368:	8defd0ef          	jal	ffffffffc0200446 <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc020336c:	00003697          	auipc	a3,0x3
ffffffffc0203370:	4fc68693          	addi	a3,a3,1276 # ffffffffc0206868 <etext+0xfd8>
ffffffffc0203374:	00003617          	auipc	a2,0x3
ffffffffc0203378:	eec60613          	addi	a2,a2,-276 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020337c:	20f00593          	li	a1,527
ffffffffc0203380:	00003517          	auipc	a0,0x3
ffffffffc0203384:	38050513          	addi	a0,a0,896 # ffffffffc0206700 <etext+0xe70>
ffffffffc0203388:	8befd0ef          	jal	ffffffffc0200446 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020338c:	00003617          	auipc	a2,0x3
ffffffffc0203390:	32c60613          	addi	a2,a2,812 # ffffffffc02066b8 <etext+0xe28>
ffffffffc0203394:	0c900593          	li	a1,201
ffffffffc0203398:	00003517          	auipc	a0,0x3
ffffffffc020339c:	36850513          	addi	a0,a0,872 # ffffffffc0206700 <etext+0xe70>
ffffffffc02033a0:	8a6fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02033a4:	00003697          	auipc	a3,0x3
ffffffffc02033a8:	52468693          	addi	a3,a3,1316 # ffffffffc02068c8 <etext+0x1038>
ffffffffc02033ac:	00003617          	auipc	a2,0x3
ffffffffc02033b0:	eb460613          	addi	a2,a2,-332 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02033b4:	21600593          	li	a1,534
ffffffffc02033b8:	00003517          	auipc	a0,0x3
ffffffffc02033bc:	34850513          	addi	a0,a0,840 # ffffffffc0206700 <etext+0xe70>
ffffffffc02033c0:	886fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02033c4:	00003697          	auipc	a3,0x3
ffffffffc02033c8:	4d468693          	addi	a3,a3,1236 # ffffffffc0206898 <etext+0x1008>
ffffffffc02033cc:	00003617          	auipc	a2,0x3
ffffffffc02033d0:	e9460613          	addi	a2,a2,-364 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02033d4:	21300593          	li	a1,531
ffffffffc02033d8:	00003517          	auipc	a0,0x3
ffffffffc02033dc:	32850513          	addi	a0,a0,808 # ffffffffc0206700 <etext+0xe70>
ffffffffc02033e0:	866fd0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02033e4 <copy_range>:
{
ffffffffc02033e4:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02033e6:	00d667b3          	or	a5,a2,a3
{
ffffffffc02033ea:	f486                	sd	ra,104(sp)
ffffffffc02033ec:	f0a2                	sd	s0,96(sp)
ffffffffc02033ee:	eca6                	sd	s1,88(sp)
ffffffffc02033f0:	e8ca                	sd	s2,80(sp)
ffffffffc02033f2:	e4ce                	sd	s3,72(sp)
ffffffffc02033f4:	e0d2                	sd	s4,64(sp)
ffffffffc02033f6:	fc56                	sd	s5,56(sp)
ffffffffc02033f8:	f85a                	sd	s6,48(sp)
ffffffffc02033fa:	f45e                	sd	s7,40(sp)
ffffffffc02033fc:	f062                	sd	s8,32(sp)
ffffffffc02033fe:	ec66                	sd	s9,24(sp)
ffffffffc0203400:	e86a                	sd	s10,16(sp)
ffffffffc0203402:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203404:	03479713          	slli	a4,a5,0x34
ffffffffc0203408:	20071f63          	bnez	a4,ffffffffc0203626 <copy_range+0x242>
    assert(USER_ACCESS(start, end));
ffffffffc020340c:	002007b7          	lui	a5,0x200
ffffffffc0203410:	00d63733          	sltu	a4,a2,a3
ffffffffc0203414:	00f637b3          	sltu	a5,a2,a5
ffffffffc0203418:	00173713          	seqz	a4,a4
ffffffffc020341c:	8fd9                	or	a5,a5,a4
ffffffffc020341e:	8432                	mv	s0,a2
ffffffffc0203420:	8936                	mv	s2,a3
ffffffffc0203422:	1e079263          	bnez	a5,ffffffffc0203606 <copy_range+0x222>
ffffffffc0203426:	4785                	li	a5,1
ffffffffc0203428:	07fe                	slli	a5,a5,0x1f
ffffffffc020342a:	0785                	addi	a5,a5,1 # 200001 <_binary_obj___user_exit_out_size+0x1f5e41>
ffffffffc020342c:	1cf6fd63          	bgeu	a3,a5,ffffffffc0203606 <copy_range+0x222>
ffffffffc0203430:	5b7d                	li	s6,-1
ffffffffc0203432:	8baa                	mv	s7,a0
ffffffffc0203434:	8a2e                	mv	s4,a1
ffffffffc0203436:	6a85                	lui	s5,0x1
ffffffffc0203438:	00cb5b13          	srli	s6,s6,0xc
    if (PPN(pa) >= npage)
ffffffffc020343c:	00098c97          	auipc	s9,0x98
ffffffffc0203440:	24cc8c93          	addi	s9,s9,588 # ffffffffc029b688 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0203444:	00098c17          	auipc	s8,0x98
ffffffffc0203448:	24cc0c13          	addi	s8,s8,588 # ffffffffc029b690 <pages>
ffffffffc020344c:	fff80d37          	lui	s10,0xfff80
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc0203450:	4601                	li	a2,0
ffffffffc0203452:	85a2                	mv	a1,s0
ffffffffc0203454:	8552                	mv	a0,s4
ffffffffc0203456:	b19fe0ef          	jal	ffffffffc0201f6e <get_pte>
ffffffffc020345a:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc020345c:	0e050a63          	beqz	a0,ffffffffc0203550 <copy_range+0x16c>
        if (*ptep & PTE_V)
ffffffffc0203460:	611c                	ld	a5,0(a0)
ffffffffc0203462:	8b85                	andi	a5,a5,1
ffffffffc0203464:	e78d                	bnez	a5,ffffffffc020348e <copy_range+0xaa>
        start += PGSIZE;
ffffffffc0203466:	9456                	add	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc0203468:	c019                	beqz	s0,ffffffffc020346e <copy_range+0x8a>
ffffffffc020346a:	ff2463e3          	bltu	s0,s2,ffffffffc0203450 <copy_range+0x6c>
    return 0;
ffffffffc020346e:	4501                	li	a0,0
}
ffffffffc0203470:	70a6                	ld	ra,104(sp)
ffffffffc0203472:	7406                	ld	s0,96(sp)
ffffffffc0203474:	64e6                	ld	s1,88(sp)
ffffffffc0203476:	6946                	ld	s2,80(sp)
ffffffffc0203478:	69a6                	ld	s3,72(sp)
ffffffffc020347a:	6a06                	ld	s4,64(sp)
ffffffffc020347c:	7ae2                	ld	s5,56(sp)
ffffffffc020347e:	7b42                	ld	s6,48(sp)
ffffffffc0203480:	7ba2                	ld	s7,40(sp)
ffffffffc0203482:	7c02                	ld	s8,32(sp)
ffffffffc0203484:	6ce2                	ld	s9,24(sp)
ffffffffc0203486:	6d42                	ld	s10,16(sp)
ffffffffc0203488:	6da2                	ld	s11,8(sp)
ffffffffc020348a:	6165                	addi	sp,sp,112
ffffffffc020348c:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc020348e:	4605                	li	a2,1
ffffffffc0203490:	85a2                	mv	a1,s0
ffffffffc0203492:	855e                	mv	a0,s7
ffffffffc0203494:	adbfe0ef          	jal	ffffffffc0201f6e <get_pte>
ffffffffc0203498:	c165                	beqz	a0,ffffffffc0203578 <copy_range+0x194>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc020349a:	0004b983          	ld	s3,0(s1)
    if (!(pte & PTE_V))
ffffffffc020349e:	0019f793          	andi	a5,s3,1
ffffffffc02034a2:	14078663          	beqz	a5,ffffffffc02035ee <copy_range+0x20a>
    if (PPN(pa) >= npage)
ffffffffc02034a6:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc02034aa:	00299793          	slli	a5,s3,0x2
ffffffffc02034ae:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02034b0:	12e7f363          	bgeu	a5,a4,ffffffffc02035d6 <copy_range+0x1f2>
    return &pages[PPN(pa) - nbase];
ffffffffc02034b4:	000c3483          	ld	s1,0(s8)
ffffffffc02034b8:	97ea                	add	a5,a5,s10
ffffffffc02034ba:	079a                	slli	a5,a5,0x6
ffffffffc02034bc:	94be                	add	s1,s1,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02034be:	100027f3          	csrr	a5,sstatus
ffffffffc02034c2:	8b89                	andi	a5,a5,2
ffffffffc02034c4:	efc9                	bnez	a5,ffffffffc020355e <copy_range+0x17a>
        page = pmm_manager->alloc_pages(n);
ffffffffc02034c6:	00098797          	auipc	a5,0x98
ffffffffc02034ca:	1a27b783          	ld	a5,418(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc02034ce:	4505                	li	a0,1
ffffffffc02034d0:	6f9c                	ld	a5,24(a5)
ffffffffc02034d2:	9782                	jalr	a5
ffffffffc02034d4:	8daa                	mv	s11,a0
            assert(page != NULL);
ffffffffc02034d6:	c0e5                	beqz	s1,ffffffffc02035b6 <copy_range+0x1d2>
            assert(npage != NULL);
ffffffffc02034d8:	0a0d8f63          	beqz	s11,ffffffffc0203596 <copy_range+0x1b2>
    return page - pages + nbase;
ffffffffc02034dc:	000c3783          	ld	a5,0(s8)
ffffffffc02034e0:	00080637          	lui	a2,0x80
    return KADDR(page2pa(page));
ffffffffc02034e4:	000cb703          	ld	a4,0(s9)
    return page - pages + nbase;
ffffffffc02034e8:	40f486b3          	sub	a3,s1,a5
ffffffffc02034ec:	8699                	srai	a3,a3,0x6
ffffffffc02034ee:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02034f0:	0166f5b3          	and	a1,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc02034f4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02034f6:	08e5f463          	bgeu	a1,a4,ffffffffc020357e <copy_range+0x19a>
    return page - pages + nbase;
ffffffffc02034fa:	40fd87b3          	sub	a5,s11,a5
ffffffffc02034fe:	8799                	srai	a5,a5,0x6
ffffffffc0203500:	97b2                	add	a5,a5,a2
    return KADDR(page2pa(page));
ffffffffc0203502:	0167f633          	and	a2,a5,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0203506:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0203508:	06e67a63          	bgeu	a2,a4,ffffffffc020357c <copy_range+0x198>
ffffffffc020350c:	00098517          	auipc	a0,0x98
ffffffffc0203510:	17453503          	ld	a0,372(a0) # ffffffffc029b680 <va_pa_offset>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc0203514:	6605                	lui	a2,0x1
ffffffffc0203516:	00a685b3          	add	a1,a3,a0
ffffffffc020351a:	953e                	add	a0,a0,a5
ffffffffc020351c:	35c020ef          	jal	ffffffffc0205878 <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc0203520:	01f9f693          	andi	a3,s3,31
ffffffffc0203524:	85ee                	mv	a1,s11
ffffffffc0203526:	8622                	mv	a2,s0
ffffffffc0203528:	855e                	mv	a0,s7
ffffffffc020352a:	97aff0ef          	jal	ffffffffc02026a4 <page_insert>
            assert(ret == 0);
ffffffffc020352e:	dd05                	beqz	a0,ffffffffc0203466 <copy_range+0x82>
ffffffffc0203530:	00004697          	auipc	a3,0x4
ffffffffc0203534:	80868693          	addi	a3,a3,-2040 # ffffffffc0206d38 <etext+0x14a8>
ffffffffc0203538:	00003617          	auipc	a2,0x3
ffffffffc020353c:	d2860613          	addi	a2,a2,-728 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203540:	1ae00593          	li	a1,430
ffffffffc0203544:	00003517          	auipc	a0,0x3
ffffffffc0203548:	1bc50513          	addi	a0,a0,444 # ffffffffc0206700 <etext+0xe70>
ffffffffc020354c:	efbfc0ef          	jal	ffffffffc0200446 <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0203550:	002007b7          	lui	a5,0x200
ffffffffc0203554:	97a2                	add	a5,a5,s0
ffffffffc0203556:	ffe00437          	lui	s0,0xffe00
ffffffffc020355a:	8c7d                	and	s0,s0,a5
            continue;
ffffffffc020355c:	b731                	j	ffffffffc0203468 <copy_range+0x84>
        intr_disable();
ffffffffc020355e:	ba6fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203562:	00098797          	auipc	a5,0x98
ffffffffc0203566:	1067b783          	ld	a5,262(a5) # ffffffffc029b668 <pmm_manager>
ffffffffc020356a:	4505                	li	a0,1
ffffffffc020356c:	6f9c                	ld	a5,24(a5)
ffffffffc020356e:	9782                	jalr	a5
ffffffffc0203570:	8daa                	mv	s11,a0
        intr_enable();
ffffffffc0203572:	b8cfd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0203576:	b785                	j	ffffffffc02034d6 <copy_range+0xf2>
                return -E_NO_MEM;
ffffffffc0203578:	5571                	li	a0,-4
ffffffffc020357a:	bddd                	j	ffffffffc0203470 <copy_range+0x8c>
ffffffffc020357c:	86be                	mv	a3,a5
ffffffffc020357e:	00003617          	auipc	a2,0x3
ffffffffc0203582:	09260613          	addi	a2,a2,146 # ffffffffc0206610 <etext+0xd80>
ffffffffc0203586:	07100593          	li	a1,113
ffffffffc020358a:	00003517          	auipc	a0,0x3
ffffffffc020358e:	0ae50513          	addi	a0,a0,174 # ffffffffc0206638 <etext+0xda8>
ffffffffc0203592:	eb5fc0ef          	jal	ffffffffc0200446 <__panic>
            assert(npage != NULL);
ffffffffc0203596:	00003697          	auipc	a3,0x3
ffffffffc020359a:	79268693          	addi	a3,a3,1938 # ffffffffc0206d28 <etext+0x1498>
ffffffffc020359e:	00003617          	auipc	a2,0x3
ffffffffc02035a2:	cc260613          	addi	a2,a2,-830 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02035a6:	19500593          	li	a1,405
ffffffffc02035aa:	00003517          	auipc	a0,0x3
ffffffffc02035ae:	15650513          	addi	a0,a0,342 # ffffffffc0206700 <etext+0xe70>
ffffffffc02035b2:	e95fc0ef          	jal	ffffffffc0200446 <__panic>
            assert(page != NULL);
ffffffffc02035b6:	00003697          	auipc	a3,0x3
ffffffffc02035ba:	76268693          	addi	a3,a3,1890 # ffffffffc0206d18 <etext+0x1488>
ffffffffc02035be:	00003617          	auipc	a2,0x3
ffffffffc02035c2:	ca260613          	addi	a2,a2,-862 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02035c6:	19400593          	li	a1,404
ffffffffc02035ca:	00003517          	auipc	a0,0x3
ffffffffc02035ce:	13650513          	addi	a0,a0,310 # ffffffffc0206700 <etext+0xe70>
ffffffffc02035d2:	e75fc0ef          	jal	ffffffffc0200446 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02035d6:	00003617          	auipc	a2,0x3
ffffffffc02035da:	10a60613          	addi	a2,a2,266 # ffffffffc02066e0 <etext+0xe50>
ffffffffc02035de:	06900593          	li	a1,105
ffffffffc02035e2:	00003517          	auipc	a0,0x3
ffffffffc02035e6:	05650513          	addi	a0,a0,86 # ffffffffc0206638 <etext+0xda8>
ffffffffc02035ea:	e5dfc0ef          	jal	ffffffffc0200446 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02035ee:	00003617          	auipc	a2,0x3
ffffffffc02035f2:	30a60613          	addi	a2,a2,778 # ffffffffc02068f8 <etext+0x1068>
ffffffffc02035f6:	07f00593          	li	a1,127
ffffffffc02035fa:	00003517          	auipc	a0,0x3
ffffffffc02035fe:	03e50513          	addi	a0,a0,62 # ffffffffc0206638 <etext+0xda8>
ffffffffc0203602:	e45fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0203606:	00003697          	auipc	a3,0x3
ffffffffc020360a:	13a68693          	addi	a3,a3,314 # ffffffffc0206740 <etext+0xeb0>
ffffffffc020360e:	00003617          	auipc	a2,0x3
ffffffffc0203612:	c5260613          	addi	a2,a2,-942 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203616:	17c00593          	li	a1,380
ffffffffc020361a:	00003517          	auipc	a0,0x3
ffffffffc020361e:	0e650513          	addi	a0,a0,230 # ffffffffc0206700 <etext+0xe70>
ffffffffc0203622:	e25fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203626:	00003697          	auipc	a3,0x3
ffffffffc020362a:	0ea68693          	addi	a3,a3,234 # ffffffffc0206710 <etext+0xe80>
ffffffffc020362e:	00003617          	auipc	a2,0x3
ffffffffc0203632:	c3260613          	addi	a2,a2,-974 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203636:	17b00593          	li	a1,379
ffffffffc020363a:	00003517          	auipc	a0,0x3
ffffffffc020363e:	0c650513          	addi	a0,a0,198 # ffffffffc0206700 <etext+0xe70>
ffffffffc0203642:	e05fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203646 <pgdir_alloc_page>:
{
ffffffffc0203646:	7179                	addi	sp,sp,-48
ffffffffc0203648:	e84a                	sd	s2,16(sp)
ffffffffc020364a:	e44e                	sd	s3,8(sp)
ffffffffc020364c:	e052                	sd	s4,0(sp)
ffffffffc020364e:	f406                	sd	ra,40(sp)
ffffffffc0203650:	f022                	sd	s0,32(sp)
ffffffffc0203652:	ec26                	sd	s1,24(sp)
ffffffffc0203654:	89aa                	mv	s3,a0
ffffffffc0203656:	892e                	mv	s2,a1
ffffffffc0203658:	8a32                	mv	s4,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020365a:	100027f3          	csrr	a5,sstatus
ffffffffc020365e:	8b89                	andi	a5,a5,2
ffffffffc0203660:	ebc5                	bnez	a5,ffffffffc0203710 <pgdir_alloc_page+0xca>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203662:	00098497          	auipc	s1,0x98
ffffffffc0203666:	00648493          	addi	s1,s1,6 # ffffffffc029b668 <pmm_manager>
ffffffffc020366a:	609c                	ld	a5,0(s1)
ffffffffc020366c:	4505                	li	a0,1
ffffffffc020366e:	6f9c                	ld	a5,24(a5)
ffffffffc0203670:	9782                	jalr	a5
ffffffffc0203672:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc0203674:	c441                	beqz	s0,ffffffffc02036fc <pgdir_alloc_page+0xb6>
    return page - pages + nbase;
ffffffffc0203676:	00098517          	auipc	a0,0x98
ffffffffc020367a:	01a53503          	ld	a0,26(a0) # ffffffffc029b690 <pages>
ffffffffc020367e:	000807b7          	lui	a5,0x80
    return KADDR(page2pa(page));
ffffffffc0203682:	00098717          	auipc	a4,0x98
ffffffffc0203686:	00673703          	ld	a4,6(a4) # ffffffffc029b688 <npage>
    return page - pages + nbase;
ffffffffc020368a:	40a40533          	sub	a0,s0,a0
ffffffffc020368e:	8519                	srai	a0,a0,0x6
ffffffffc0203690:	953e                	add	a0,a0,a5
    return KADDR(page2pa(page));
ffffffffc0203692:	00c51793          	slli	a5,a0,0xc
ffffffffc0203696:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203698:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc020369a:	0ae7f363          	bgeu	a5,a4,ffffffffc0203740 <pgdir_alloc_page+0xfa>
ffffffffc020369e:	00098797          	auipc	a5,0x98
ffffffffc02036a2:	fe27b783          	ld	a5,-30(a5) # ffffffffc029b680 <va_pa_offset>
        memset(page2kva(page), 0, PGSIZE);
ffffffffc02036a6:	6605                	lui	a2,0x1
ffffffffc02036a8:	4581                	li	a1,0
ffffffffc02036aa:	953e                	add	a0,a0,a5
ffffffffc02036ac:	1ba020ef          	jal	ffffffffc0205866 <memset>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc02036b0:	86d2                	mv	a3,s4
ffffffffc02036b2:	864a                	mv	a2,s2
ffffffffc02036b4:	85a2                	mv	a1,s0
ffffffffc02036b6:	854e                	mv	a0,s3
ffffffffc02036b8:	fedfe0ef          	jal	ffffffffc02026a4 <page_insert>
ffffffffc02036bc:	e51d                	bnez	a0,ffffffffc02036ea <pgdir_alloc_page+0xa4>
        assert(page_ref(page) == 1);
ffffffffc02036be:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc02036c0:	03243c23          	sd	s2,56(s0) # ffffffffffe00038 <end+0x3fb64980>
        assert(page_ref(page) == 1);
ffffffffc02036c4:	4785                	li	a5,1
ffffffffc02036c6:	02f70c63          	beq	a4,a5,ffffffffc02036fe <pgdir_alloc_page+0xb8>
ffffffffc02036ca:	00003697          	auipc	a3,0x3
ffffffffc02036ce:	67e68693          	addi	a3,a3,1662 # ffffffffc0206d48 <etext+0x14b8>
ffffffffc02036d2:	00003617          	auipc	a2,0x3
ffffffffc02036d6:	b8e60613          	addi	a2,a2,-1138 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02036da:	1f800593          	li	a1,504
ffffffffc02036de:	00003517          	auipc	a0,0x3
ffffffffc02036e2:	02250513          	addi	a0,a0,34 # ffffffffc0206700 <etext+0xe70>
ffffffffc02036e6:	d61fc0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc02036ea:	100027f3          	csrr	a5,sstatus
ffffffffc02036ee:	8b89                	andi	a5,a5,2
ffffffffc02036f0:	ef95                	bnez	a5,ffffffffc020372c <pgdir_alloc_page+0xe6>
        pmm_manager->free_pages(base, n);
ffffffffc02036f2:	609c                	ld	a5,0(s1)
ffffffffc02036f4:	8522                	mv	a0,s0
ffffffffc02036f6:	4585                	li	a1,1
ffffffffc02036f8:	739c                	ld	a5,32(a5)
ffffffffc02036fa:	9782                	jalr	a5
            return NULL;
ffffffffc02036fc:	4401                	li	s0,0
}
ffffffffc02036fe:	70a2                	ld	ra,40(sp)
ffffffffc0203700:	8522                	mv	a0,s0
ffffffffc0203702:	7402                	ld	s0,32(sp)
ffffffffc0203704:	64e2                	ld	s1,24(sp)
ffffffffc0203706:	6942                	ld	s2,16(sp)
ffffffffc0203708:	69a2                	ld	s3,8(sp)
ffffffffc020370a:	6a02                	ld	s4,0(sp)
ffffffffc020370c:	6145                	addi	sp,sp,48
ffffffffc020370e:	8082                	ret
        intr_disable();
ffffffffc0203710:	9f4fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203714:	00098497          	auipc	s1,0x98
ffffffffc0203718:	f5448493          	addi	s1,s1,-172 # ffffffffc029b668 <pmm_manager>
ffffffffc020371c:	609c                	ld	a5,0(s1)
ffffffffc020371e:	4505                	li	a0,1
ffffffffc0203720:	6f9c                	ld	a5,24(a5)
ffffffffc0203722:	9782                	jalr	a5
ffffffffc0203724:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203726:	9d8fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020372a:	b7a9                	j	ffffffffc0203674 <pgdir_alloc_page+0x2e>
        intr_disable();
ffffffffc020372c:	9d8fd0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0203730:	609c                	ld	a5,0(s1)
ffffffffc0203732:	8522                	mv	a0,s0
ffffffffc0203734:	4585                	li	a1,1
ffffffffc0203736:	739c                	ld	a5,32(a5)
ffffffffc0203738:	9782                	jalr	a5
        intr_enable();
ffffffffc020373a:	9c4fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020373e:	bf7d                	j	ffffffffc02036fc <pgdir_alloc_page+0xb6>
ffffffffc0203740:	86aa                	mv	a3,a0
ffffffffc0203742:	00003617          	auipc	a2,0x3
ffffffffc0203746:	ece60613          	addi	a2,a2,-306 # ffffffffc0206610 <etext+0xd80>
ffffffffc020374a:	07100593          	li	a1,113
ffffffffc020374e:	00003517          	auipc	a0,0x3
ffffffffc0203752:	eea50513          	addi	a0,a0,-278 # ffffffffc0206638 <etext+0xda8>
ffffffffc0203756:	cf1fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020375a <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc020375a:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc020375c:	00003697          	auipc	a3,0x3
ffffffffc0203760:	60468693          	addi	a3,a3,1540 # ffffffffc0206d60 <etext+0x14d0>
ffffffffc0203764:	00003617          	auipc	a2,0x3
ffffffffc0203768:	afc60613          	addi	a2,a2,-1284 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020376c:	07400593          	li	a1,116
ffffffffc0203770:	00003517          	auipc	a0,0x3
ffffffffc0203774:	61050513          	addi	a0,a0,1552 # ffffffffc0206d80 <etext+0x14f0>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203778:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc020377a:	ccdfc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020377e <mm_create>:
{
ffffffffc020377e:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203780:	04000513          	li	a0,64
{
ffffffffc0203784:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203786:	d7efe0ef          	jal	ffffffffc0201d04 <kmalloc>
    if (mm != NULL)
ffffffffc020378a:	cd19                	beqz	a0,ffffffffc02037a8 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc020378c:	e508                	sd	a0,8(a0)
ffffffffc020378e:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203790:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203794:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203798:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc020379c:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc02037a0:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc02037a4:	02053c23          	sd	zero,56(a0)
}
ffffffffc02037a8:	60a2                	ld	ra,8(sp)
ffffffffc02037aa:	0141                	addi	sp,sp,16
ffffffffc02037ac:	8082                	ret

ffffffffc02037ae <find_vma>:
    if (mm != NULL)
ffffffffc02037ae:	c505                	beqz	a0,ffffffffc02037d6 <find_vma+0x28>
        vma = mm->mmap_cache;
ffffffffc02037b0:	691c                	ld	a5,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02037b2:	c781                	beqz	a5,ffffffffc02037ba <find_vma+0xc>
ffffffffc02037b4:	6798                	ld	a4,8(a5)
ffffffffc02037b6:	02e5f363          	bgeu	a1,a4,ffffffffc02037dc <find_vma+0x2e>
    return listelm->next;
ffffffffc02037ba:	651c                	ld	a5,8(a0)
            while ((le = list_next(le)) != list)
ffffffffc02037bc:	00f50d63          	beq	a0,a5,ffffffffc02037d6 <find_vma+0x28>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc02037c0:	fe87b703          	ld	a4,-24(a5)
ffffffffc02037c4:	00e5e663          	bltu	a1,a4,ffffffffc02037d0 <find_vma+0x22>
ffffffffc02037c8:	ff07b703          	ld	a4,-16(a5)
ffffffffc02037cc:	00e5ee63          	bltu	a1,a4,ffffffffc02037e8 <find_vma+0x3a>
ffffffffc02037d0:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc02037d2:	fef517e3          	bne	a0,a5,ffffffffc02037c0 <find_vma+0x12>
    struct vma_struct *vma = NULL;
ffffffffc02037d6:	4781                	li	a5,0
}
ffffffffc02037d8:	853e                	mv	a0,a5
ffffffffc02037da:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02037dc:	6b98                	ld	a4,16(a5)
ffffffffc02037de:	fce5fee3          	bgeu	a1,a4,ffffffffc02037ba <find_vma+0xc>
            mm->mmap_cache = vma;
ffffffffc02037e2:	e91c                	sd	a5,16(a0)
}
ffffffffc02037e4:	853e                	mv	a0,a5
ffffffffc02037e6:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc02037e8:	1781                	addi	a5,a5,-32
            mm->mmap_cache = vma;
ffffffffc02037ea:	e91c                	sd	a5,16(a0)
ffffffffc02037ec:	bfe5                	j	ffffffffc02037e4 <find_vma+0x36>

ffffffffc02037ee <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc02037ee:	6590                	ld	a2,8(a1)
ffffffffc02037f0:	0105b803          	ld	a6,16(a1)
{
ffffffffc02037f4:	1141                	addi	sp,sp,-16
ffffffffc02037f6:	e406                	sd	ra,8(sp)
ffffffffc02037f8:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc02037fa:	01066763          	bltu	a2,a6,ffffffffc0203808 <insert_vma_struct+0x1a>
ffffffffc02037fe:	a8b9                	j	ffffffffc020385c <insert_vma_struct+0x6e>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203800:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203804:	04e66763          	bltu	a2,a4,ffffffffc0203852 <insert_vma_struct+0x64>
ffffffffc0203808:	86be                	mv	a3,a5
ffffffffc020380a:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc020380c:	fef51ae3          	bne	a0,a5,ffffffffc0203800 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0203810:	02a68463          	beq	a3,a0,ffffffffc0203838 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203814:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203818:	fe86b883          	ld	a7,-24(a3)
ffffffffc020381c:	08e8f063          	bgeu	a7,a4,ffffffffc020389c <insert_vma_struct+0xae>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203820:	04e66e63          	bltu	a2,a4,ffffffffc020387c <insert_vma_struct+0x8e>
    }
    if (le_next != list)
ffffffffc0203824:	00f50a63          	beq	a0,a5,ffffffffc0203838 <insert_vma_struct+0x4a>
ffffffffc0203828:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc020382c:	05076863          	bltu	a4,a6,ffffffffc020387c <insert_vma_struct+0x8e>
    assert(next->vm_start < next->vm_end);
ffffffffc0203830:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203834:	02c77263          	bgeu	a4,a2,ffffffffc0203858 <insert_vma_struct+0x6a>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0203838:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc020383a:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc020383c:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0203840:	e390                	sd	a2,0(a5)
ffffffffc0203842:	e690                	sd	a2,8(a3)
}
ffffffffc0203844:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0203846:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0203848:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc020384a:	2705                	addiw	a4,a4,1
ffffffffc020384c:	d118                	sw	a4,32(a0)
}
ffffffffc020384e:	0141                	addi	sp,sp,16
ffffffffc0203850:	8082                	ret
    if (le_prev != list)
ffffffffc0203852:	fca691e3          	bne	a3,a0,ffffffffc0203814 <insert_vma_struct+0x26>
ffffffffc0203856:	bfd9                	j	ffffffffc020382c <insert_vma_struct+0x3e>
ffffffffc0203858:	f03ff0ef          	jal	ffffffffc020375a <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc020385c:	00003697          	auipc	a3,0x3
ffffffffc0203860:	53468693          	addi	a3,a3,1332 # ffffffffc0206d90 <etext+0x1500>
ffffffffc0203864:	00003617          	auipc	a2,0x3
ffffffffc0203868:	9fc60613          	addi	a2,a2,-1540 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020386c:	07a00593          	li	a1,122
ffffffffc0203870:	00003517          	auipc	a0,0x3
ffffffffc0203874:	51050513          	addi	a0,a0,1296 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203878:	bcffc0ef          	jal	ffffffffc0200446 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020387c:	00003697          	auipc	a3,0x3
ffffffffc0203880:	55468693          	addi	a3,a3,1364 # ffffffffc0206dd0 <etext+0x1540>
ffffffffc0203884:	00003617          	auipc	a2,0x3
ffffffffc0203888:	9dc60613          	addi	a2,a2,-1572 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020388c:	07300593          	li	a1,115
ffffffffc0203890:	00003517          	auipc	a0,0x3
ffffffffc0203894:	4f050513          	addi	a0,a0,1264 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203898:	baffc0ef          	jal	ffffffffc0200446 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc020389c:	00003697          	auipc	a3,0x3
ffffffffc02038a0:	51468693          	addi	a3,a3,1300 # ffffffffc0206db0 <etext+0x1520>
ffffffffc02038a4:	00003617          	auipc	a2,0x3
ffffffffc02038a8:	9bc60613          	addi	a2,a2,-1604 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02038ac:	07200593          	li	a1,114
ffffffffc02038b0:	00003517          	auipc	a0,0x3
ffffffffc02038b4:	4d050513          	addi	a0,a0,1232 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc02038b8:	b8ffc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02038bc <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc02038bc:	591c                	lw	a5,48(a0)
{
ffffffffc02038be:	1141                	addi	sp,sp,-16
ffffffffc02038c0:	e406                	sd	ra,8(sp)
ffffffffc02038c2:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc02038c4:	e78d                	bnez	a5,ffffffffc02038ee <mm_destroy+0x32>
ffffffffc02038c6:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc02038c8:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc02038ca:	00a40c63          	beq	s0,a0,ffffffffc02038e2 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc02038ce:	6118                	ld	a4,0(a0)
ffffffffc02038d0:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc02038d2:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc02038d4:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02038d6:	e398                	sd	a4,0(a5)
ffffffffc02038d8:	cd2fe0ef          	jal	ffffffffc0201daa <kfree>
    return listelm->next;
ffffffffc02038dc:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc02038de:	fea418e3          	bne	s0,a0,ffffffffc02038ce <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc02038e2:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc02038e4:	6402                	ld	s0,0(sp)
ffffffffc02038e6:	60a2                	ld	ra,8(sp)
ffffffffc02038e8:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc02038ea:	cc0fe06f          	j	ffffffffc0201daa <kfree>
    assert(mm_count(mm) == 0);
ffffffffc02038ee:	00003697          	auipc	a3,0x3
ffffffffc02038f2:	50268693          	addi	a3,a3,1282 # ffffffffc0206df0 <etext+0x1560>
ffffffffc02038f6:	00003617          	auipc	a2,0x3
ffffffffc02038fa:	96a60613          	addi	a2,a2,-1686 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02038fe:	09e00593          	li	a1,158
ffffffffc0203902:	00003517          	auipc	a0,0x3
ffffffffc0203906:	47e50513          	addi	a0,a0,1150 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc020390a:	b3dfc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020390e <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc020390e:	6785                	lui	a5,0x1
ffffffffc0203910:	17fd                	addi	a5,a5,-1 # fff <_binary_obj___user_softint_out_size-0x7bc9>
ffffffffc0203912:	963e                	add	a2,a2,a5
    if (!USER_ACCESS(start, end))
ffffffffc0203914:	4785                	li	a5,1
{
ffffffffc0203916:	7139                	addi	sp,sp,-64
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203918:	962e                	add	a2,a2,a1
ffffffffc020391a:	787d                	lui	a6,0xfffff
    if (!USER_ACCESS(start, end))
ffffffffc020391c:	07fe                	slli	a5,a5,0x1f
{
ffffffffc020391e:	f822                	sd	s0,48(sp)
ffffffffc0203920:	f426                	sd	s1,40(sp)
ffffffffc0203922:	01067433          	and	s0,a2,a6
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203926:	0105f4b3          	and	s1,a1,a6
    if (!USER_ACCESS(start, end))
ffffffffc020392a:	0785                	addi	a5,a5,1
ffffffffc020392c:	0084b633          	sltu	a2,s1,s0
ffffffffc0203930:	00f437b3          	sltu	a5,s0,a5
ffffffffc0203934:	00163613          	seqz	a2,a2
ffffffffc0203938:	0017b793          	seqz	a5,a5
{
ffffffffc020393c:	fc06                	sd	ra,56(sp)
    if (!USER_ACCESS(start, end))
ffffffffc020393e:	8fd1                	or	a5,a5,a2
ffffffffc0203940:	ebbd                	bnez	a5,ffffffffc02039b6 <mm_map+0xa8>
ffffffffc0203942:	002007b7          	lui	a5,0x200
ffffffffc0203946:	06f4e863          	bltu	s1,a5,ffffffffc02039b6 <mm_map+0xa8>
ffffffffc020394a:	f04a                	sd	s2,32(sp)
ffffffffc020394c:	ec4e                	sd	s3,24(sp)
ffffffffc020394e:	e852                	sd	s4,16(sp)
ffffffffc0203950:	892a                	mv	s2,a0
ffffffffc0203952:	89ba                	mv	s3,a4
ffffffffc0203954:	8a36                	mv	s4,a3
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203956:	c135                	beqz	a0,ffffffffc02039ba <mm_map+0xac>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203958:	85a6                	mv	a1,s1
ffffffffc020395a:	e55ff0ef          	jal	ffffffffc02037ae <find_vma>
ffffffffc020395e:	c501                	beqz	a0,ffffffffc0203966 <mm_map+0x58>
ffffffffc0203960:	651c                	ld	a5,8(a0)
ffffffffc0203962:	0487e763          	bltu	a5,s0,ffffffffc02039b0 <mm_map+0xa2>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203966:	03000513          	li	a0,48
ffffffffc020396a:	b9afe0ef          	jal	ffffffffc0201d04 <kmalloc>
ffffffffc020396e:	85aa                	mv	a1,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0203970:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203972:	c59d                	beqz	a1,ffffffffc02039a0 <mm_map+0x92>
        vma->vm_start = vm_start;
ffffffffc0203974:	e584                	sd	s1,8(a1)
        vma->vm_end = vm_end;
ffffffffc0203976:	e980                	sd	s0,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203978:	0145ac23          	sw	s4,24(a1)

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc020397c:	854a                	mv	a0,s2
ffffffffc020397e:	e42e                	sd	a1,8(sp)
ffffffffc0203980:	e6fff0ef          	jal	ffffffffc02037ee <insert_vma_struct>
    if (vma_store != NULL)
ffffffffc0203984:	65a2                	ld	a1,8(sp)
ffffffffc0203986:	00098463          	beqz	s3,ffffffffc020398e <mm_map+0x80>
    {
        *vma_store = vma;
ffffffffc020398a:	00b9b023          	sd	a1,0(s3)
ffffffffc020398e:	7902                	ld	s2,32(sp)
ffffffffc0203990:	69e2                	ld	s3,24(sp)
ffffffffc0203992:	6a42                	ld	s4,16(sp)
    }
    ret = 0;
ffffffffc0203994:	4501                	li	a0,0

out:
    return ret;
}
ffffffffc0203996:	70e2                	ld	ra,56(sp)
ffffffffc0203998:	7442                	ld	s0,48(sp)
ffffffffc020399a:	74a2                	ld	s1,40(sp)
ffffffffc020399c:	6121                	addi	sp,sp,64
ffffffffc020399e:	8082                	ret
ffffffffc02039a0:	70e2                	ld	ra,56(sp)
ffffffffc02039a2:	7442                	ld	s0,48(sp)
ffffffffc02039a4:	7902                	ld	s2,32(sp)
ffffffffc02039a6:	69e2                	ld	s3,24(sp)
ffffffffc02039a8:	6a42                	ld	s4,16(sp)
ffffffffc02039aa:	74a2                	ld	s1,40(sp)
ffffffffc02039ac:	6121                	addi	sp,sp,64
ffffffffc02039ae:	8082                	ret
ffffffffc02039b0:	7902                	ld	s2,32(sp)
ffffffffc02039b2:	69e2                	ld	s3,24(sp)
ffffffffc02039b4:	6a42                	ld	s4,16(sp)
        return -E_INVAL;
ffffffffc02039b6:	5575                	li	a0,-3
ffffffffc02039b8:	bff9                	j	ffffffffc0203996 <mm_map+0x88>
    assert(mm != NULL);
ffffffffc02039ba:	00003697          	auipc	a3,0x3
ffffffffc02039be:	44e68693          	addi	a3,a3,1102 # ffffffffc0206e08 <etext+0x1578>
ffffffffc02039c2:	00003617          	auipc	a2,0x3
ffffffffc02039c6:	89e60613          	addi	a2,a2,-1890 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02039ca:	0b300593          	li	a1,179
ffffffffc02039ce:	00003517          	auipc	a0,0x3
ffffffffc02039d2:	3b250513          	addi	a0,a0,946 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc02039d6:	a71fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02039da <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc02039da:	7139                	addi	sp,sp,-64
ffffffffc02039dc:	fc06                	sd	ra,56(sp)
ffffffffc02039de:	f822                	sd	s0,48(sp)
ffffffffc02039e0:	f426                	sd	s1,40(sp)
ffffffffc02039e2:	f04a                	sd	s2,32(sp)
ffffffffc02039e4:	ec4e                	sd	s3,24(sp)
ffffffffc02039e6:	e852                	sd	s4,16(sp)
ffffffffc02039e8:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc02039ea:	c525                	beqz	a0,ffffffffc0203a52 <dup_mmap+0x78>
ffffffffc02039ec:	892a                	mv	s2,a0
ffffffffc02039ee:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc02039f0:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc02039f2:	c1a5                	beqz	a1,ffffffffc0203a52 <dup_mmap+0x78>
    return listelm->prev;
ffffffffc02039f4:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc02039f6:	04848c63          	beq	s1,s0,ffffffffc0203a4e <dup_mmap+0x74>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02039fa:	03000513          	li	a0,48
    {
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc02039fe:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203a02:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203a06:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a0a:	afafe0ef          	jal	ffffffffc0201d04 <kmalloc>
    if (vma != NULL)
ffffffffc0203a0e:	c515                	beqz	a0,ffffffffc0203a3a <dup_mmap+0x60>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0203a10:	85aa                	mv	a1,a0
        vma->vm_start = vm_start;
ffffffffc0203a12:	01553423          	sd	s5,8(a0)
ffffffffc0203a16:	01453823          	sd	s4,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203a1a:	01352c23          	sw	s3,24(a0)
        insert_vma_struct(to, nvma);
ffffffffc0203a1e:	854a                	mv	a0,s2
ffffffffc0203a20:	dcfff0ef          	jal	ffffffffc02037ee <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203a24:	ff043683          	ld	a3,-16(s0)
ffffffffc0203a28:	fe843603          	ld	a2,-24(s0)
ffffffffc0203a2c:	6c8c                	ld	a1,24(s1)
ffffffffc0203a2e:	01893503          	ld	a0,24(s2)
ffffffffc0203a32:	4701                	li	a4,0
ffffffffc0203a34:	9b1ff0ef          	jal	ffffffffc02033e4 <copy_range>
ffffffffc0203a38:	dd55                	beqz	a0,ffffffffc02039f4 <dup_mmap+0x1a>
            return -E_NO_MEM;
ffffffffc0203a3a:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203a3c:	70e2                	ld	ra,56(sp)
ffffffffc0203a3e:	7442                	ld	s0,48(sp)
ffffffffc0203a40:	74a2                	ld	s1,40(sp)
ffffffffc0203a42:	7902                	ld	s2,32(sp)
ffffffffc0203a44:	69e2                	ld	s3,24(sp)
ffffffffc0203a46:	6a42                	ld	s4,16(sp)
ffffffffc0203a48:	6aa2                	ld	s5,8(sp)
ffffffffc0203a4a:	6121                	addi	sp,sp,64
ffffffffc0203a4c:	8082                	ret
    return 0;
ffffffffc0203a4e:	4501                	li	a0,0
ffffffffc0203a50:	b7f5                	j	ffffffffc0203a3c <dup_mmap+0x62>
    assert(to != NULL && from != NULL);
ffffffffc0203a52:	00003697          	auipc	a3,0x3
ffffffffc0203a56:	3c668693          	addi	a3,a3,966 # ffffffffc0206e18 <etext+0x1588>
ffffffffc0203a5a:	00003617          	auipc	a2,0x3
ffffffffc0203a5e:	80660613          	addi	a2,a2,-2042 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203a62:	0cf00593          	li	a1,207
ffffffffc0203a66:	00003517          	auipc	a0,0x3
ffffffffc0203a6a:	31a50513          	addi	a0,a0,794 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203a6e:	9d9fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203a72 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203a72:	1101                	addi	sp,sp,-32
ffffffffc0203a74:	ec06                	sd	ra,24(sp)
ffffffffc0203a76:	e822                	sd	s0,16(sp)
ffffffffc0203a78:	e426                	sd	s1,8(sp)
ffffffffc0203a7a:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203a7c:	c531                	beqz	a0,ffffffffc0203ac8 <exit_mmap+0x56>
ffffffffc0203a7e:	591c                	lw	a5,48(a0)
ffffffffc0203a80:	84aa                	mv	s1,a0
ffffffffc0203a82:	e3b9                	bnez	a5,ffffffffc0203ac8 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0203a84:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0203a86:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203a8a:	02850663          	beq	a0,s0,ffffffffc0203ab6 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203a8e:	ff043603          	ld	a2,-16(s0)
ffffffffc0203a92:	fe843583          	ld	a1,-24(s0)
ffffffffc0203a96:	854a                	mv	a0,s2
ffffffffc0203a98:	f88fe0ef          	jal	ffffffffc0202220 <unmap_range>
ffffffffc0203a9c:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203a9e:	fe8498e3          	bne	s1,s0,ffffffffc0203a8e <exit_mmap+0x1c>
ffffffffc0203aa2:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0203aa4:	00848c63          	beq	s1,s0,ffffffffc0203abc <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203aa8:	ff043603          	ld	a2,-16(s0)
ffffffffc0203aac:	fe843583          	ld	a1,-24(s0)
ffffffffc0203ab0:	854a                	mv	a0,s2
ffffffffc0203ab2:	8a3fe0ef          	jal	ffffffffc0202354 <exit_range>
ffffffffc0203ab6:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203ab8:	fe8498e3          	bne	s1,s0,ffffffffc0203aa8 <exit_mmap+0x36>
    }
}
ffffffffc0203abc:	60e2                	ld	ra,24(sp)
ffffffffc0203abe:	6442                	ld	s0,16(sp)
ffffffffc0203ac0:	64a2                	ld	s1,8(sp)
ffffffffc0203ac2:	6902                	ld	s2,0(sp)
ffffffffc0203ac4:	6105                	addi	sp,sp,32
ffffffffc0203ac6:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203ac8:	00003697          	auipc	a3,0x3
ffffffffc0203acc:	37068693          	addi	a3,a3,880 # ffffffffc0206e38 <etext+0x15a8>
ffffffffc0203ad0:	00002617          	auipc	a2,0x2
ffffffffc0203ad4:	79060613          	addi	a2,a2,1936 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203ad8:	0e800593          	li	a1,232
ffffffffc0203adc:	00003517          	auipc	a0,0x3
ffffffffc0203ae0:	2a450513          	addi	a0,a0,676 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203ae4:	963fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203ae8 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203ae8:	7179                	addi	sp,sp,-48
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203aea:	04000513          	li	a0,64
{
ffffffffc0203aee:	f406                	sd	ra,40(sp)
ffffffffc0203af0:	f022                	sd	s0,32(sp)
ffffffffc0203af2:	ec26                	sd	s1,24(sp)
ffffffffc0203af4:	e84a                	sd	s2,16(sp)
ffffffffc0203af6:	e44e                	sd	s3,8(sp)
ffffffffc0203af8:	e052                	sd	s4,0(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203afa:	a0afe0ef          	jal	ffffffffc0201d04 <kmalloc>
    if (mm != NULL)
ffffffffc0203afe:	16050c63          	beqz	a0,ffffffffc0203c76 <vmm_init+0x18e>
ffffffffc0203b02:	842a                	mv	s0,a0
    elm->prev = elm->next = elm;
ffffffffc0203b04:	e508                	sd	a0,8(a0)
ffffffffc0203b06:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203b08:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203b0c:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203b10:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203b14:	02053423          	sd	zero,40(a0)
ffffffffc0203b18:	02052823          	sw	zero,48(a0)
ffffffffc0203b1c:	02053c23          	sd	zero,56(a0)
ffffffffc0203b20:	03200493          	li	s1,50
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b24:	03000513          	li	a0,48
ffffffffc0203b28:	9dcfe0ef          	jal	ffffffffc0201d04 <kmalloc>
    if (vma != NULL)
ffffffffc0203b2c:	12050563          	beqz	a0,ffffffffc0203c56 <vmm_init+0x16e>
        vma->vm_end = vm_end;
ffffffffc0203b30:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0203b34:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203b36:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0203b3a:	e91c                	sd	a5,16(a0)
    int i;
    for (i = step1; i >= 1; i--)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203b3c:	85aa                	mv	a1,a0
    for (i = step1; i >= 1; i--)
ffffffffc0203b3e:	14ed                	addi	s1,s1,-5
        insert_vma_struct(mm, vma);
ffffffffc0203b40:	8522                	mv	a0,s0
ffffffffc0203b42:	cadff0ef          	jal	ffffffffc02037ee <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203b46:	fcf9                	bnez	s1,ffffffffc0203b24 <vmm_init+0x3c>
ffffffffc0203b48:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203b4c:	1f900913          	li	s2,505
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b50:	03000513          	li	a0,48
ffffffffc0203b54:	9b0fe0ef          	jal	ffffffffc0201d04 <kmalloc>
    if (vma != NULL)
ffffffffc0203b58:	12050f63          	beqz	a0,ffffffffc0203c96 <vmm_init+0x1ae>
        vma->vm_end = vm_end;
ffffffffc0203b5c:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0203b60:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203b62:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0203b66:	e91c                	sd	a5,16(a0)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203b68:	85aa                	mv	a1,a0
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203b6a:	0495                	addi	s1,s1,5
        insert_vma_struct(mm, vma);
ffffffffc0203b6c:	8522                	mv	a0,s0
ffffffffc0203b6e:	c81ff0ef          	jal	ffffffffc02037ee <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203b72:	fd249fe3          	bne	s1,s2,ffffffffc0203b50 <vmm_init+0x68>
    return listelm->next;
ffffffffc0203b76:	641c                	ld	a5,8(s0)
ffffffffc0203b78:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203b7a:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203b7e:	1ef40c63          	beq	s0,a5,ffffffffc0203d76 <vmm_init+0x28e>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203b82:	fe87b603          	ld	a2,-24(a5) # 1fffe8 <_binary_obj___user_exit_out_size+0x1f5e28>
ffffffffc0203b86:	ffe70693          	addi	a3,a4,-2
ffffffffc0203b8a:	12d61663          	bne	a2,a3,ffffffffc0203cb6 <vmm_init+0x1ce>
ffffffffc0203b8e:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203b92:	12e69263          	bne	a3,a4,ffffffffc0203cb6 <vmm_init+0x1ce>
    for (i = 1; i <= step2; i++)
ffffffffc0203b96:	0715                	addi	a4,a4,5
ffffffffc0203b98:	679c                	ld	a5,8(a5)
ffffffffc0203b9a:	feb712e3          	bne	a4,a1,ffffffffc0203b7e <vmm_init+0x96>
ffffffffc0203b9e:	491d                	li	s2,7
ffffffffc0203ba0:	4495                	li	s1,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203ba2:	85a6                	mv	a1,s1
ffffffffc0203ba4:	8522                	mv	a0,s0
ffffffffc0203ba6:	c09ff0ef          	jal	ffffffffc02037ae <find_vma>
ffffffffc0203baa:	8a2a                	mv	s4,a0
        assert(vma1 != NULL);
ffffffffc0203bac:	20050563          	beqz	a0,ffffffffc0203db6 <vmm_init+0x2ce>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203bb0:	00148593          	addi	a1,s1,1
ffffffffc0203bb4:	8522                	mv	a0,s0
ffffffffc0203bb6:	bf9ff0ef          	jal	ffffffffc02037ae <find_vma>
ffffffffc0203bba:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203bbc:	1c050d63          	beqz	a0,ffffffffc0203d96 <vmm_init+0x2ae>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203bc0:	85ca                	mv	a1,s2
ffffffffc0203bc2:	8522                	mv	a0,s0
ffffffffc0203bc4:	bebff0ef          	jal	ffffffffc02037ae <find_vma>
        assert(vma3 == NULL);
ffffffffc0203bc8:	18051763          	bnez	a0,ffffffffc0203d56 <vmm_init+0x26e>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203bcc:	00348593          	addi	a1,s1,3
ffffffffc0203bd0:	8522                	mv	a0,s0
ffffffffc0203bd2:	bddff0ef          	jal	ffffffffc02037ae <find_vma>
        assert(vma4 == NULL);
ffffffffc0203bd6:	16051063          	bnez	a0,ffffffffc0203d36 <vmm_init+0x24e>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203bda:	00448593          	addi	a1,s1,4
ffffffffc0203bde:	8522                	mv	a0,s0
ffffffffc0203be0:	bcfff0ef          	jal	ffffffffc02037ae <find_vma>
        assert(vma5 == NULL);
ffffffffc0203be4:	12051963          	bnez	a0,ffffffffc0203d16 <vmm_init+0x22e>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203be8:	008a3783          	ld	a5,8(s4)
ffffffffc0203bec:	10979563          	bne	a5,s1,ffffffffc0203cf6 <vmm_init+0x20e>
ffffffffc0203bf0:	010a3783          	ld	a5,16(s4)
ffffffffc0203bf4:	11279163          	bne	a5,s2,ffffffffc0203cf6 <vmm_init+0x20e>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203bf8:	0089b783          	ld	a5,8(s3)
ffffffffc0203bfc:	0c979d63          	bne	a5,s1,ffffffffc0203cd6 <vmm_init+0x1ee>
ffffffffc0203c00:	0109b783          	ld	a5,16(s3)
ffffffffc0203c04:	0d279963          	bne	a5,s2,ffffffffc0203cd6 <vmm_init+0x1ee>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203c08:	0495                	addi	s1,s1,5
ffffffffc0203c0a:	1f900793          	li	a5,505
ffffffffc0203c0e:	0915                	addi	s2,s2,5
ffffffffc0203c10:	f8f499e3          	bne	s1,a5,ffffffffc0203ba2 <vmm_init+0xba>
ffffffffc0203c14:	4491                	li	s1,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203c16:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203c18:	85a6                	mv	a1,s1
ffffffffc0203c1a:	8522                	mv	a0,s0
ffffffffc0203c1c:	b93ff0ef          	jal	ffffffffc02037ae <find_vma>
        if (vma_below_5 != NULL)
ffffffffc0203c20:	1a051b63          	bnez	a0,ffffffffc0203dd6 <vmm_init+0x2ee>
    for (i = 4; i >= 0; i--)
ffffffffc0203c24:	14fd                	addi	s1,s1,-1
ffffffffc0203c26:	ff2499e3          	bne	s1,s2,ffffffffc0203c18 <vmm_init+0x130>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
ffffffffc0203c2a:	8522                	mv	a0,s0
ffffffffc0203c2c:	c91ff0ef          	jal	ffffffffc02038bc <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203c30:	00003517          	auipc	a0,0x3
ffffffffc0203c34:	37850513          	addi	a0,a0,888 # ffffffffc0206fa8 <etext+0x1718>
ffffffffc0203c38:	d5cfc0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0203c3c:	7402                	ld	s0,32(sp)
ffffffffc0203c3e:	70a2                	ld	ra,40(sp)
ffffffffc0203c40:	64e2                	ld	s1,24(sp)
ffffffffc0203c42:	6942                	ld	s2,16(sp)
ffffffffc0203c44:	69a2                	ld	s3,8(sp)
ffffffffc0203c46:	6a02                	ld	s4,0(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203c48:	00003517          	auipc	a0,0x3
ffffffffc0203c4c:	38050513          	addi	a0,a0,896 # ffffffffc0206fc8 <etext+0x1738>
}
ffffffffc0203c50:	6145                	addi	sp,sp,48
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203c52:	d42fc06f          	j	ffffffffc0200194 <cprintf>
        assert(vma != NULL);
ffffffffc0203c56:	00003697          	auipc	a3,0x3
ffffffffc0203c5a:	20268693          	addi	a3,a3,514 # ffffffffc0206e58 <etext+0x15c8>
ffffffffc0203c5e:	00002617          	auipc	a2,0x2
ffffffffc0203c62:	60260613          	addi	a2,a2,1538 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203c66:	12c00593          	li	a1,300
ffffffffc0203c6a:	00003517          	auipc	a0,0x3
ffffffffc0203c6e:	11650513          	addi	a0,a0,278 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203c72:	fd4fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(mm != NULL);
ffffffffc0203c76:	00003697          	auipc	a3,0x3
ffffffffc0203c7a:	19268693          	addi	a3,a3,402 # ffffffffc0206e08 <etext+0x1578>
ffffffffc0203c7e:	00002617          	auipc	a2,0x2
ffffffffc0203c82:	5e260613          	addi	a2,a2,1506 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203c86:	12400593          	li	a1,292
ffffffffc0203c8a:	00003517          	auipc	a0,0x3
ffffffffc0203c8e:	0f650513          	addi	a0,a0,246 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203c92:	fb4fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma != NULL);
ffffffffc0203c96:	00003697          	auipc	a3,0x3
ffffffffc0203c9a:	1c268693          	addi	a3,a3,450 # ffffffffc0206e58 <etext+0x15c8>
ffffffffc0203c9e:	00002617          	auipc	a2,0x2
ffffffffc0203ca2:	5c260613          	addi	a2,a2,1474 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203ca6:	13300593          	li	a1,307
ffffffffc0203caa:	00003517          	auipc	a0,0x3
ffffffffc0203cae:	0d650513          	addi	a0,a0,214 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203cb2:	f94fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203cb6:	00003697          	auipc	a3,0x3
ffffffffc0203cba:	1ca68693          	addi	a3,a3,458 # ffffffffc0206e80 <etext+0x15f0>
ffffffffc0203cbe:	00002617          	auipc	a2,0x2
ffffffffc0203cc2:	5a260613          	addi	a2,a2,1442 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203cc6:	13d00593          	li	a1,317
ffffffffc0203cca:	00003517          	auipc	a0,0x3
ffffffffc0203cce:	0b650513          	addi	a0,a0,182 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203cd2:	f74fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203cd6:	00003697          	auipc	a3,0x3
ffffffffc0203cda:	26268693          	addi	a3,a3,610 # ffffffffc0206f38 <etext+0x16a8>
ffffffffc0203cde:	00002617          	auipc	a2,0x2
ffffffffc0203ce2:	58260613          	addi	a2,a2,1410 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203ce6:	14f00593          	li	a1,335
ffffffffc0203cea:	00003517          	auipc	a0,0x3
ffffffffc0203cee:	09650513          	addi	a0,a0,150 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203cf2:	f54fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203cf6:	00003697          	auipc	a3,0x3
ffffffffc0203cfa:	21268693          	addi	a3,a3,530 # ffffffffc0206f08 <etext+0x1678>
ffffffffc0203cfe:	00002617          	auipc	a2,0x2
ffffffffc0203d02:	56260613          	addi	a2,a2,1378 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203d06:	14e00593          	li	a1,334
ffffffffc0203d0a:	00003517          	auipc	a0,0x3
ffffffffc0203d0e:	07650513          	addi	a0,a0,118 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203d12:	f34fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma5 == NULL);
ffffffffc0203d16:	00003697          	auipc	a3,0x3
ffffffffc0203d1a:	1e268693          	addi	a3,a3,482 # ffffffffc0206ef8 <etext+0x1668>
ffffffffc0203d1e:	00002617          	auipc	a2,0x2
ffffffffc0203d22:	54260613          	addi	a2,a2,1346 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203d26:	14c00593          	li	a1,332
ffffffffc0203d2a:	00003517          	auipc	a0,0x3
ffffffffc0203d2e:	05650513          	addi	a0,a0,86 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203d32:	f14fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma4 == NULL);
ffffffffc0203d36:	00003697          	auipc	a3,0x3
ffffffffc0203d3a:	1b268693          	addi	a3,a3,434 # ffffffffc0206ee8 <etext+0x1658>
ffffffffc0203d3e:	00002617          	auipc	a2,0x2
ffffffffc0203d42:	52260613          	addi	a2,a2,1314 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203d46:	14a00593          	li	a1,330
ffffffffc0203d4a:	00003517          	auipc	a0,0x3
ffffffffc0203d4e:	03650513          	addi	a0,a0,54 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203d52:	ef4fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma3 == NULL);
ffffffffc0203d56:	00003697          	auipc	a3,0x3
ffffffffc0203d5a:	18268693          	addi	a3,a3,386 # ffffffffc0206ed8 <etext+0x1648>
ffffffffc0203d5e:	00002617          	auipc	a2,0x2
ffffffffc0203d62:	50260613          	addi	a2,a2,1282 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203d66:	14800593          	li	a1,328
ffffffffc0203d6a:	00003517          	auipc	a0,0x3
ffffffffc0203d6e:	01650513          	addi	a0,a0,22 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203d72:	ed4fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203d76:	00003697          	auipc	a3,0x3
ffffffffc0203d7a:	0f268693          	addi	a3,a3,242 # ffffffffc0206e68 <etext+0x15d8>
ffffffffc0203d7e:	00002617          	auipc	a2,0x2
ffffffffc0203d82:	4e260613          	addi	a2,a2,1250 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203d86:	13b00593          	li	a1,315
ffffffffc0203d8a:	00003517          	auipc	a0,0x3
ffffffffc0203d8e:	ff650513          	addi	a0,a0,-10 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203d92:	eb4fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma2 != NULL);
ffffffffc0203d96:	00003697          	auipc	a3,0x3
ffffffffc0203d9a:	13268693          	addi	a3,a3,306 # ffffffffc0206ec8 <etext+0x1638>
ffffffffc0203d9e:	00002617          	auipc	a2,0x2
ffffffffc0203da2:	4c260613          	addi	a2,a2,1218 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203da6:	14600593          	li	a1,326
ffffffffc0203daa:	00003517          	auipc	a0,0x3
ffffffffc0203dae:	fd650513          	addi	a0,a0,-42 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203db2:	e94fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma1 != NULL);
ffffffffc0203db6:	00003697          	auipc	a3,0x3
ffffffffc0203dba:	10268693          	addi	a3,a3,258 # ffffffffc0206eb8 <etext+0x1628>
ffffffffc0203dbe:	00002617          	auipc	a2,0x2
ffffffffc0203dc2:	4a260613          	addi	a2,a2,1186 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203dc6:	14400593          	li	a1,324
ffffffffc0203dca:	00003517          	auipc	a0,0x3
ffffffffc0203dce:	fb650513          	addi	a0,a0,-74 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203dd2:	e74fc0ef          	jal	ffffffffc0200446 <__panic>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203dd6:	6914                	ld	a3,16(a0)
ffffffffc0203dd8:	6510                	ld	a2,8(a0)
ffffffffc0203dda:	0004859b          	sext.w	a1,s1
ffffffffc0203dde:	00003517          	auipc	a0,0x3
ffffffffc0203de2:	18a50513          	addi	a0,a0,394 # ffffffffc0206f68 <etext+0x16d8>
ffffffffc0203de6:	baefc0ef          	jal	ffffffffc0200194 <cprintf>
        assert(vma_below_5 == NULL);
ffffffffc0203dea:	00003697          	auipc	a3,0x3
ffffffffc0203dee:	1a668693          	addi	a3,a3,422 # ffffffffc0206f90 <etext+0x1700>
ffffffffc0203df2:	00002617          	auipc	a2,0x2
ffffffffc0203df6:	46e60613          	addi	a2,a2,1134 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0203dfa:	15900593          	li	a1,345
ffffffffc0203dfe:	00003517          	auipc	a0,0x3
ffffffffc0203e02:	f8250513          	addi	a0,a0,-126 # ffffffffc0206d80 <etext+0x14f0>
ffffffffc0203e06:	e40fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203e0a <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203e0a:	7179                	addi	sp,sp,-48
ffffffffc0203e0c:	f022                	sd	s0,32(sp)
ffffffffc0203e0e:	f406                	sd	ra,40(sp)
ffffffffc0203e10:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203e12:	c52d                	beqz	a0,ffffffffc0203e7c <user_mem_check+0x72>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203e14:	002007b7          	lui	a5,0x200
ffffffffc0203e18:	04f5ed63          	bltu	a1,a5,ffffffffc0203e72 <user_mem_check+0x68>
ffffffffc0203e1c:	ec26                	sd	s1,24(sp)
ffffffffc0203e1e:	00c584b3          	add	s1,a1,a2
ffffffffc0203e22:	0695ff63          	bgeu	a1,s1,ffffffffc0203ea0 <user_mem_check+0x96>
ffffffffc0203e26:	4785                	li	a5,1
ffffffffc0203e28:	07fe                	slli	a5,a5,0x1f
ffffffffc0203e2a:	0785                	addi	a5,a5,1 # 200001 <_binary_obj___user_exit_out_size+0x1f5e41>
ffffffffc0203e2c:	06f4fa63          	bgeu	s1,a5,ffffffffc0203ea0 <user_mem_check+0x96>
ffffffffc0203e30:	e84a                	sd	s2,16(sp)
ffffffffc0203e32:	e44e                	sd	s3,8(sp)
ffffffffc0203e34:	8936                	mv	s2,a3
ffffffffc0203e36:	89aa                	mv	s3,a0
ffffffffc0203e38:	a829                	j	ffffffffc0203e52 <user_mem_check+0x48>
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203e3a:	6685                	lui	a3,0x1
ffffffffc0203e3c:	9736                	add	a4,a4,a3
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203e3e:	0027f693          	andi	a3,a5,2
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203e42:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203e44:	c685                	beqz	a3,ffffffffc0203e6c <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203e46:	c399                	beqz	a5,ffffffffc0203e4c <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203e48:	02e46263          	bltu	s0,a4,ffffffffc0203e6c <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203e4c:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203e4e:	04947b63          	bgeu	s0,s1,ffffffffc0203ea4 <user_mem_check+0x9a>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203e52:	85a2                	mv	a1,s0
ffffffffc0203e54:	854e                	mv	a0,s3
ffffffffc0203e56:	959ff0ef          	jal	ffffffffc02037ae <find_vma>
ffffffffc0203e5a:	c909                	beqz	a0,ffffffffc0203e6c <user_mem_check+0x62>
ffffffffc0203e5c:	6518                	ld	a4,8(a0)
ffffffffc0203e5e:	00e46763          	bltu	s0,a4,ffffffffc0203e6c <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203e62:	4d1c                	lw	a5,24(a0)
ffffffffc0203e64:	fc091be3          	bnez	s2,ffffffffc0203e3a <user_mem_check+0x30>
ffffffffc0203e68:	8b85                	andi	a5,a5,1
ffffffffc0203e6a:	f3ed                	bnez	a5,ffffffffc0203e4c <user_mem_check+0x42>
ffffffffc0203e6c:	64e2                	ld	s1,24(sp)
ffffffffc0203e6e:	6942                	ld	s2,16(sp)
ffffffffc0203e70:	69a2                	ld	s3,8(sp)
            return 0;
ffffffffc0203e72:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203e74:	70a2                	ld	ra,40(sp)
ffffffffc0203e76:	7402                	ld	s0,32(sp)
ffffffffc0203e78:	6145                	addi	sp,sp,48
ffffffffc0203e7a:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203e7c:	c02007b7          	lui	a5,0xc0200
ffffffffc0203e80:	fef5eae3          	bltu	a1,a5,ffffffffc0203e74 <user_mem_check+0x6a>
ffffffffc0203e84:	c80007b7          	lui	a5,0xc8000
ffffffffc0203e88:	962e                	add	a2,a2,a1
ffffffffc0203e8a:	0785                	addi	a5,a5,1 # ffffffffc8000001 <end+0x7d64949>
ffffffffc0203e8c:	00c5b433          	sltu	s0,a1,a2
ffffffffc0203e90:	00f63633          	sltu	a2,a2,a5
ffffffffc0203e94:	70a2                	ld	ra,40(sp)
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203e96:	00867533          	and	a0,a2,s0
ffffffffc0203e9a:	7402                	ld	s0,32(sp)
ffffffffc0203e9c:	6145                	addi	sp,sp,48
ffffffffc0203e9e:	8082                	ret
ffffffffc0203ea0:	64e2                	ld	s1,24(sp)
ffffffffc0203ea2:	bfc1                	j	ffffffffc0203e72 <user_mem_check+0x68>
ffffffffc0203ea4:	64e2                	ld	s1,24(sp)
ffffffffc0203ea6:	6942                	ld	s2,16(sp)
ffffffffc0203ea8:	69a2                	ld	s3,8(sp)
        return 1;
ffffffffc0203eaa:	4505                	li	a0,1
ffffffffc0203eac:	b7e1                	j	ffffffffc0203e74 <user_mem_check+0x6a>

ffffffffc0203eae <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203eae:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203eb0:	9402                	jalr	s0

	jal do_exit
ffffffffc0203eb2:	670000ef          	jal	ffffffffc0204522 <do_exit>

ffffffffc0203eb6 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203eb6:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203eb8:	10800513          	li	a0,264
{
ffffffffc0203ebc:	e022                	sd	s0,0(sp)
ffffffffc0203ebe:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203ec0:	e45fd0ef          	jal	ffffffffc0201d04 <kmalloc>
ffffffffc0203ec4:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203ec6:	cd21                	beqz	a0,ffffffffc0203f1e <alloc_proc+0x68>
         *       struct trapframe *tf;                       // Trap frame for current interrupt
         *       uintptr_t pgdir;                            // the base addr of Page Directroy Table(PDT)
         *       uint32_t flags;                             // Process flag
         *       char name[PROC_NAME_LEN + 1];               // Process name
         */
        proc->state = PROC_UNINIT;
ffffffffc0203ec8:	57fd                	li	a5,-1
ffffffffc0203eca:	1782                	slli	a5,a5,0x20
ffffffffc0203ecc:	e11c                	sd	a5,0(a0)
        proc->pid = -1;
        proc->runs = 0;
ffffffffc0203ece:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc0203ed2:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203ed6:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203eda:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0203ede:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203ee2:	07000613          	li	a2,112
ffffffffc0203ee6:	4581                	li	a1,0
ffffffffc0203ee8:	03050513          	addi	a0,a0,48
ffffffffc0203eec:	17b010ef          	jal	ffffffffc0205866 <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203ef0:	00097797          	auipc	a5,0x97
ffffffffc0203ef4:	7807b783          	ld	a5,1920(a5) # ffffffffc029b670 <boot_pgdir_pa>
        proc->tf = NULL;
ffffffffc0203ef8:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc0203efc:	0a042823          	sw	zero,176(s0)
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203f00:	f45c                	sd	a5,168(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1);
ffffffffc0203f02:	0b440513          	addi	a0,s0,180
ffffffffc0203f06:	4641                	li	a2,16
ffffffffc0203f08:	4581                	li	a1,0
ffffffffc0203f0a:	15d010ef          	jal	ffffffffc0205866 <memset>
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        proc->wait_state = 0;
        proc->cptr = proc->yptr = proc->optr = NULL;
        proc->exit_code = 0;
ffffffffc0203f0e:	0e043423          	sd	zero,232(s0)
        proc->cptr = proc->yptr = proc->optr = NULL;
ffffffffc0203f12:	0e043823          	sd	zero,240(s0)
ffffffffc0203f16:	0e043c23          	sd	zero,248(s0)
ffffffffc0203f1a:	10043023          	sd	zero,256(s0)
    }
    return proc;
}
ffffffffc0203f1e:	60a2                	ld	ra,8(sp)
ffffffffc0203f20:	8522                	mv	a0,s0
ffffffffc0203f22:	6402                	ld	s0,0(sp)
ffffffffc0203f24:	0141                	addi	sp,sp,16
ffffffffc0203f26:	8082                	ret

ffffffffc0203f28 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203f28:	00097797          	auipc	a5,0x97
ffffffffc0203f2c:	7787b783          	ld	a5,1912(a5) # ffffffffc029b6a0 <current>
ffffffffc0203f30:	73c8                	ld	a0,160(a5)
ffffffffc0203f32:	fb9fc06f          	j	ffffffffc0200eea <forkrets>

ffffffffc0203f36 <user_main>:
// user_main - kernel thread used to exec a user program
static int
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203f36:	00097797          	auipc	a5,0x97
ffffffffc0203f3a:	76a7b783          	ld	a5,1898(a5) # ffffffffc029b6a0 <current>
{
ffffffffc0203f3e:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203f40:	00003617          	auipc	a2,0x3
ffffffffc0203f44:	0a060613          	addi	a2,a2,160 # ffffffffc0206fe0 <etext+0x1750>
ffffffffc0203f48:	43cc                	lw	a1,4(a5)
ffffffffc0203f4a:	00003517          	auipc	a0,0x3
ffffffffc0203f4e:	0a650513          	addi	a0,a0,166 # ffffffffc0206ff0 <etext+0x1760>
{
ffffffffc0203f52:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203f54:	a40fc0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0203f58:	3fe06797          	auipc	a5,0x3fe06
ffffffffc0203f5c:	98078793          	addi	a5,a5,-1664 # 98d8 <_binary_obj___user_forktest_out_size>
ffffffffc0203f60:	e43e                	sd	a5,8(sp)
kernel_execve(const char *name, unsigned char *binary, size_t size)
ffffffffc0203f62:	00003517          	auipc	a0,0x3
ffffffffc0203f66:	07e50513          	addi	a0,a0,126 # ffffffffc0206fe0 <etext+0x1750>
ffffffffc0203f6a:	0003f797          	auipc	a5,0x3f
ffffffffc0203f6e:	6be78793          	addi	a5,a5,1726 # ffffffffc0243628 <_binary_obj___user_forktest_out_start>
ffffffffc0203f72:	f03e                	sd	a5,32(sp)
ffffffffc0203f74:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc0203f76:	e802                	sd	zero,16(sp)
ffffffffc0203f78:	03b010ef          	jal	ffffffffc02057b2 <strlen>
ffffffffc0203f7c:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0203f7e:	4511                	li	a0,4
ffffffffc0203f80:	55a2                	lw	a1,40(sp)
ffffffffc0203f82:	4662                	lw	a2,24(sp)
ffffffffc0203f84:	5682                	lw	a3,32(sp)
ffffffffc0203f86:	4722                	lw	a4,8(sp)
ffffffffc0203f88:	48a9                	li	a7,10
ffffffffc0203f8a:	9002                	ebreak
ffffffffc0203f8c:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0203f8e:	65c2                	ld	a1,16(sp)
ffffffffc0203f90:	00003517          	auipc	a0,0x3
ffffffffc0203f94:	08850513          	addi	a0,a0,136 # ffffffffc0207018 <etext+0x1788>
ffffffffc0203f98:	9fcfc0ef          	jal	ffffffffc0200194 <cprintf>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc0203f9c:	00003617          	auipc	a2,0x3
ffffffffc0203fa0:	08c60613          	addi	a2,a2,140 # ffffffffc0207028 <etext+0x1798>
ffffffffc0203fa4:	3a200593          	li	a1,930
ffffffffc0203fa8:	00003517          	auipc	a0,0x3
ffffffffc0203fac:	0a050513          	addi	a0,a0,160 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0203fb0:	c96fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203fb4 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0203fb4:	6d14                	ld	a3,24(a0)
{
ffffffffc0203fb6:	1141                	addi	sp,sp,-16
ffffffffc0203fb8:	e406                	sd	ra,8(sp)
ffffffffc0203fba:	c02007b7          	lui	a5,0xc0200
ffffffffc0203fbe:	02f6ee63          	bltu	a3,a5,ffffffffc0203ffa <put_pgdir+0x46>
ffffffffc0203fc2:	00097717          	auipc	a4,0x97
ffffffffc0203fc6:	6be73703          	ld	a4,1726(a4) # ffffffffc029b680 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0203fca:	00097797          	auipc	a5,0x97
ffffffffc0203fce:	6be7b783          	ld	a5,1726(a5) # ffffffffc029b688 <npage>
    return pa2page(PADDR(kva));
ffffffffc0203fd2:	8e99                	sub	a3,a3,a4
    if (PPN(pa) >= npage)
ffffffffc0203fd4:	82b1                	srli	a3,a3,0xc
ffffffffc0203fd6:	02f6fe63          	bgeu	a3,a5,ffffffffc0204012 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0203fda:	00004797          	auipc	a5,0x4
ffffffffc0203fde:	a167b783          	ld	a5,-1514(a5) # ffffffffc02079f0 <nbase>
ffffffffc0203fe2:	00097517          	auipc	a0,0x97
ffffffffc0203fe6:	6ae53503          	ld	a0,1710(a0) # ffffffffc029b690 <pages>
}
ffffffffc0203fea:	60a2                	ld	ra,8(sp)
ffffffffc0203fec:	8e9d                	sub	a3,a3,a5
ffffffffc0203fee:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0203ff0:	4585                	li	a1,1
ffffffffc0203ff2:	9536                	add	a0,a0,a3
}
ffffffffc0203ff4:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0203ff6:	f0bfd06f          	j	ffffffffc0201f00 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0203ffa:	00002617          	auipc	a2,0x2
ffffffffc0203ffe:	6be60613          	addi	a2,a2,1726 # ffffffffc02066b8 <etext+0xe28>
ffffffffc0204002:	07700593          	li	a1,119
ffffffffc0204006:	00002517          	auipc	a0,0x2
ffffffffc020400a:	63250513          	addi	a0,a0,1586 # ffffffffc0206638 <etext+0xda8>
ffffffffc020400e:	c38fc0ef          	jal	ffffffffc0200446 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204012:	00002617          	auipc	a2,0x2
ffffffffc0204016:	6ce60613          	addi	a2,a2,1742 # ffffffffc02066e0 <etext+0xe50>
ffffffffc020401a:	06900593          	li	a1,105
ffffffffc020401e:	00002517          	auipc	a0,0x2
ffffffffc0204022:	61a50513          	addi	a0,a0,1562 # ffffffffc0206638 <etext+0xda8>
ffffffffc0204026:	c20fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020402a <proc_run>:
    if (proc != current)
ffffffffc020402a:	00097697          	auipc	a3,0x97
ffffffffc020402e:	6766b683          	ld	a3,1654(a3) # ffffffffc029b6a0 <current>
ffffffffc0204032:	04a68463          	beq	a3,a0,ffffffffc020407a <proc_run+0x50>
{
ffffffffc0204036:	1101                	addi	sp,sp,-32
ffffffffc0204038:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020403a:	100027f3          	csrr	a5,sstatus
ffffffffc020403e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204040:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204042:	ef8d                	bnez	a5,ffffffffc020407c <proc_run+0x52>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0204044:	755c                	ld	a5,168(a0)
ffffffffc0204046:	577d                	li	a4,-1
ffffffffc0204048:	177e                	slli	a4,a4,0x3f
ffffffffc020404a:	83b1                	srli	a5,a5,0xc
ffffffffc020404c:	e032                	sd	a2,0(sp)
            current = proc;
ffffffffc020404e:	00097597          	auipc	a1,0x97
ffffffffc0204052:	64a5b923          	sd	a0,1618(a1) # ffffffffc029b6a0 <current>
ffffffffc0204056:	8fd9                	or	a5,a5,a4
ffffffffc0204058:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(proc->context));
ffffffffc020405c:	03050593          	addi	a1,a0,48
ffffffffc0204060:	03068513          	addi	a0,a3,48
ffffffffc0204064:	106010ef          	jal	ffffffffc020516a <switch_to>
    if (flag)
ffffffffc0204068:	6602                	ld	a2,0(sp)
ffffffffc020406a:	e601                	bnez	a2,ffffffffc0204072 <proc_run+0x48>
}
ffffffffc020406c:	60e2                	ld	ra,24(sp)
ffffffffc020406e:	6105                	addi	sp,sp,32
ffffffffc0204070:	8082                	ret
ffffffffc0204072:	60e2                	ld	ra,24(sp)
ffffffffc0204074:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0204076:	889fc06f          	j	ffffffffc02008fe <intr_enable>
ffffffffc020407a:	8082                	ret
ffffffffc020407c:	e42a                	sd	a0,8(sp)
ffffffffc020407e:	e036                	sd	a3,0(sp)
        intr_disable();
ffffffffc0204080:	885fc0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0204084:	6522                	ld	a0,8(sp)
ffffffffc0204086:	6682                	ld	a3,0(sp)
ffffffffc0204088:	4605                	li	a2,1
ffffffffc020408a:	bf6d                	j	ffffffffc0204044 <proc_run+0x1a>

ffffffffc020408c <do_fork>:
    if (nr_process >= MAX_PROCESS)
ffffffffc020408c:	00097717          	auipc	a4,0x97
ffffffffc0204090:	60c72703          	lw	a4,1548(a4) # ffffffffc029b698 <nr_process>
ffffffffc0204094:	6785                	lui	a5,0x1
ffffffffc0204096:	36f75d63          	bge	a4,a5,ffffffffc0204410 <do_fork+0x384>
{
ffffffffc020409a:	711d                	addi	sp,sp,-96
ffffffffc020409c:	e8a2                	sd	s0,80(sp)
ffffffffc020409e:	e4a6                	sd	s1,72(sp)
ffffffffc02040a0:	e0ca                	sd	s2,64(sp)
ffffffffc02040a2:	e06a                	sd	s10,0(sp)
ffffffffc02040a4:	ec86                	sd	ra,88(sp)
ffffffffc02040a6:	892e                	mv	s2,a1
ffffffffc02040a8:	84b2                	mv	s1,a2
ffffffffc02040aa:	8d2a                	mv	s10,a0
    if ((proc = alloc_proc()) == NULL) {
ffffffffc02040ac:	e0bff0ef          	jal	ffffffffc0203eb6 <alloc_proc>
ffffffffc02040b0:	842a                	mv	s0,a0
ffffffffc02040b2:	30050063          	beqz	a0,ffffffffc02043b2 <do_fork+0x326>
    proc->parent = current;
ffffffffc02040b6:	f05a                	sd	s6,32(sp)
ffffffffc02040b8:	00097b17          	auipc	s6,0x97
ffffffffc02040bc:	5e8b0b13          	addi	s6,s6,1512 # ffffffffc029b6a0 <current>
ffffffffc02040c0:	000b3783          	ld	a5,0(s6)
    assert(current->wait_state == 0);
ffffffffc02040c4:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_obj___user_softint_out_size-0x7adc>
    proc->parent = current;
ffffffffc02040c8:	f11c                	sd	a5,32(a0)
    assert(current->wait_state == 0);
ffffffffc02040ca:	3c071263          	bnez	a4,ffffffffc020448e <do_fork+0x402>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc02040ce:	4509                	li	a0,2
ffffffffc02040d0:	df7fd0ef          	jal	ffffffffc0201ec6 <alloc_pages>
    if (page != NULL)
ffffffffc02040d4:	2c050b63          	beqz	a0,ffffffffc02043aa <do_fork+0x31e>
ffffffffc02040d8:	fc4e                	sd	s3,56(sp)
    return page - pages + nbase;
ffffffffc02040da:	00097997          	auipc	s3,0x97
ffffffffc02040de:	5b698993          	addi	s3,s3,1462 # ffffffffc029b690 <pages>
ffffffffc02040e2:	0009b783          	ld	a5,0(s3)
ffffffffc02040e6:	f852                	sd	s4,48(sp)
ffffffffc02040e8:	00004a17          	auipc	s4,0x4
ffffffffc02040ec:	908a0a13          	addi	s4,s4,-1784 # ffffffffc02079f0 <nbase>
ffffffffc02040f0:	e466                	sd	s9,8(sp)
ffffffffc02040f2:	000a3c83          	ld	s9,0(s4)
ffffffffc02040f6:	40f506b3          	sub	a3,a0,a5
ffffffffc02040fa:	f456                	sd	s5,40(sp)
    return KADDR(page2pa(page));
ffffffffc02040fc:	00097a97          	auipc	s5,0x97
ffffffffc0204100:	58ca8a93          	addi	s5,s5,1420 # ffffffffc029b688 <npage>
ffffffffc0204104:	e862                	sd	s8,16(sp)
    return page - pages + nbase;
ffffffffc0204106:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204108:	5c7d                	li	s8,-1
ffffffffc020410a:	000ab783          	ld	a5,0(s5)
    return page - pages + nbase;
ffffffffc020410e:	96e6                	add	a3,a3,s9
    return KADDR(page2pa(page));
ffffffffc0204110:	00cc5c13          	srli	s8,s8,0xc
ffffffffc0204114:	0186f733          	and	a4,a3,s8
ffffffffc0204118:	ec5e                	sd	s7,24(sp)
    return page2ppn(page) << PGSHIFT;
ffffffffc020411a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020411c:	30f77863          	bgeu	a4,a5,ffffffffc020442c <do_fork+0x3a0>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204120:	000b3703          	ld	a4,0(s6)
ffffffffc0204124:	00097b17          	auipc	s6,0x97
ffffffffc0204128:	55cb0b13          	addi	s6,s6,1372 # ffffffffc029b680 <va_pa_offset>
ffffffffc020412c:	000b3783          	ld	a5,0(s6)
ffffffffc0204130:	02873b83          	ld	s7,40(a4)
ffffffffc0204134:	96be                	add	a3,a3,a5
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0204136:	e814                	sd	a3,16(s0)
    if (oldmm == NULL)
ffffffffc0204138:	020b8863          	beqz	s7,ffffffffc0204168 <do_fork+0xdc>
    if (clone_flags & CLONE_VM)
ffffffffc020413c:	100d7793          	andi	a5,s10,256
ffffffffc0204140:	18078b63          	beqz	a5,ffffffffc02042d6 <do_fork+0x24a>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc0204144:	030ba703          	lw	a4,48(s7)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204148:	018bb783          	ld	a5,24(s7)
ffffffffc020414c:	c02006b7          	lui	a3,0xc0200
ffffffffc0204150:	2705                	addiw	a4,a4,1
ffffffffc0204152:	02eba823          	sw	a4,48(s7)
    proc->mm = mm;
ffffffffc0204156:	03743423          	sd	s7,40(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020415a:	2ed7e563          	bltu	a5,a3,ffffffffc0204444 <do_fork+0x3b8>
ffffffffc020415e:	000b3703          	ld	a4,0(s6)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204162:	6814                	ld	a3,16(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204164:	8f99                	sub	a5,a5,a4
ffffffffc0204166:	f45c                	sd	a5,168(s0)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204168:	6789                	lui	a5,0x2
ffffffffc020416a:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_softint_out_size-0x6ce8>
ffffffffc020416e:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc0204170:	8626                	mv	a2,s1
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204172:	f054                	sd	a3,160(s0)
    *(proc->tf) = *tf;
ffffffffc0204174:	87b6                	mv	a5,a3
ffffffffc0204176:	12048713          	addi	a4,s1,288
ffffffffc020417a:	6a0c                	ld	a1,16(a2)
ffffffffc020417c:	00063803          	ld	a6,0(a2)
ffffffffc0204180:	6608                	ld	a0,8(a2)
ffffffffc0204182:	eb8c                	sd	a1,16(a5)
ffffffffc0204184:	0107b023          	sd	a6,0(a5)
ffffffffc0204188:	e788                	sd	a0,8(a5)
ffffffffc020418a:	6e0c                	ld	a1,24(a2)
ffffffffc020418c:	02060613          	addi	a2,a2,32
ffffffffc0204190:	02078793          	addi	a5,a5,32
ffffffffc0204194:	feb7bc23          	sd	a1,-8(a5)
ffffffffc0204198:	fee611e3          	bne	a2,a4,ffffffffc020417a <do_fork+0xee>
    proc->tf->gpr.a0 = 0;
ffffffffc020419c:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02041a0:	20090b63          	beqz	s2,ffffffffc02043b6 <do_fork+0x32a>
ffffffffc02041a4:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02041a8:	00000797          	auipc	a5,0x0
ffffffffc02041ac:	d8078793          	addi	a5,a5,-640 # ffffffffc0203f28 <forkret>
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02041b0:	fc14                	sd	a3,56(s0)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02041b2:	f81c                	sd	a5,48(s0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02041b4:	100027f3          	csrr	a5,sstatus
ffffffffc02041b8:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02041ba:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02041bc:	20079c63          	bnez	a5,ffffffffc02043d4 <do_fork+0x348>
    if (++last_pid >= MAX_PID)
ffffffffc02041c0:	00093517          	auipc	a0,0x93
ffffffffc02041c4:	04c52503          	lw	a0,76(a0) # ffffffffc029720c <last_pid.1>
ffffffffc02041c8:	6789                	lui	a5,0x2
ffffffffc02041ca:	2505                	addiw	a0,a0,1
ffffffffc02041cc:	00093717          	auipc	a4,0x93
ffffffffc02041d0:	04a72023          	sw	a0,64(a4) # ffffffffc029720c <last_pid.1>
ffffffffc02041d4:	20f55f63          	bge	a0,a5,ffffffffc02043f2 <do_fork+0x366>
    if (last_pid >= next_safe)
ffffffffc02041d8:	00093797          	auipc	a5,0x93
ffffffffc02041dc:	0307a783          	lw	a5,48(a5) # ffffffffc0297208 <next_safe.0>
ffffffffc02041e0:	00097497          	auipc	s1,0x97
ffffffffc02041e4:	44848493          	addi	s1,s1,1096 # ffffffffc029b628 <proc_list>
ffffffffc02041e8:	06f54563          	blt	a0,a5,ffffffffc0204252 <do_fork+0x1c6>
ffffffffc02041ec:	00097497          	auipc	s1,0x97
ffffffffc02041f0:	43c48493          	addi	s1,s1,1084 # ffffffffc029b628 <proc_list>
ffffffffc02041f4:	0084b883          	ld	a7,8(s1)
        next_safe = MAX_PID;
ffffffffc02041f8:	6789                	lui	a5,0x2
ffffffffc02041fa:	00093717          	auipc	a4,0x93
ffffffffc02041fe:	00f72723          	sw	a5,14(a4) # ffffffffc0297208 <next_safe.0>
ffffffffc0204202:	86aa                	mv	a3,a0
ffffffffc0204204:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc0204206:	04988063          	beq	a7,s1,ffffffffc0204246 <do_fork+0x1ba>
ffffffffc020420a:	882e                	mv	a6,a1
ffffffffc020420c:	87c6                	mv	a5,a7
ffffffffc020420e:	6609                	lui	a2,0x2
ffffffffc0204210:	a811                	j	ffffffffc0204224 <do_fork+0x198>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204212:	00e6d663          	bge	a3,a4,ffffffffc020421e <do_fork+0x192>
ffffffffc0204216:	00c75463          	bge	a4,a2,ffffffffc020421e <do_fork+0x192>
                next_safe = proc->pid;
ffffffffc020421a:	863a                	mv	a2,a4
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc020421c:	4805                	li	a6,1
ffffffffc020421e:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204220:	00978d63          	beq	a5,s1,ffffffffc020423a <do_fork+0x1ae>
            if (proc->pid == last_pid)
ffffffffc0204224:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_softint_out_size-0x6c8c>
ffffffffc0204228:	fed715e3          	bne	a4,a3,ffffffffc0204212 <do_fork+0x186>
                if (++last_pid >= next_safe)
ffffffffc020422c:	2685                	addiw	a3,a3,1
ffffffffc020422e:	1cc6db63          	bge	a3,a2,ffffffffc0204404 <do_fork+0x378>
ffffffffc0204232:	679c                	ld	a5,8(a5)
ffffffffc0204234:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc0204236:	fe9797e3          	bne	a5,s1,ffffffffc0204224 <do_fork+0x198>
ffffffffc020423a:	00080663          	beqz	a6,ffffffffc0204246 <do_fork+0x1ba>
ffffffffc020423e:	00093797          	auipc	a5,0x93
ffffffffc0204242:	fcc7a523          	sw	a2,-54(a5) # ffffffffc0297208 <next_safe.0>
ffffffffc0204246:	c591                	beqz	a1,ffffffffc0204252 <do_fork+0x1c6>
ffffffffc0204248:	00093797          	auipc	a5,0x93
ffffffffc020424c:	fcd7a223          	sw	a3,-60(a5) # ffffffffc029720c <last_pid.1>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204250:	8536                	mv	a0,a3
        proc->pid = get_pid();
ffffffffc0204252:	c048                	sw	a0,4(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204254:	45a9                	li	a1,10
ffffffffc0204256:	17a010ef          	jal	ffffffffc02053d0 <hash32>
ffffffffc020425a:	02051793          	slli	a5,a0,0x20
ffffffffc020425e:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204262:	00093797          	auipc	a5,0x93
ffffffffc0204266:	3c678793          	addi	a5,a5,966 # ffffffffc0297628 <hash_list>
ffffffffc020426a:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc020426c:	6518                	ld	a4,8(a0)
ffffffffc020426e:	0d840793          	addi	a5,s0,216
ffffffffc0204272:	6490                	ld	a2,8(s1)
    prev->next = next->prev = elm;
ffffffffc0204274:	e31c                	sd	a5,0(a4)
ffffffffc0204276:	e51c                	sd	a5,8(a0)
    elm->next = next;
ffffffffc0204278:	f078                	sd	a4,224(s0)
    list_add(&proc_list, &(proc->list_link));
ffffffffc020427a:	0c840793          	addi	a5,s0,200
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020427e:	7018                	ld	a4,32(s0)
    elm->prev = prev;
ffffffffc0204280:	ec68                	sd	a0,216(s0)
    prev->next = next->prev = elm;
ffffffffc0204282:	e21c                	sd	a5,0(a2)
    proc->yptr = NULL;
ffffffffc0204284:	0e043c23          	sd	zero,248(s0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204288:	7b74                	ld	a3,240(a4)
ffffffffc020428a:	e49c                	sd	a5,8(s1)
    elm->next = next;
ffffffffc020428c:	e870                	sd	a2,208(s0)
    elm->prev = prev;
ffffffffc020428e:	e464                	sd	s1,200(s0)
ffffffffc0204290:	10d43023          	sd	a3,256(s0)
ffffffffc0204294:	c299                	beqz	a3,ffffffffc020429a <do_fork+0x20e>
        proc->optr->yptr = proc;
ffffffffc0204296:	fee0                	sd	s0,248(a3)
    proc->parent->cptr = proc;
ffffffffc0204298:	7018                	ld	a4,32(s0)
    nr_process++;
ffffffffc020429a:	00097797          	auipc	a5,0x97
ffffffffc020429e:	3fe7a783          	lw	a5,1022(a5) # ffffffffc029b698 <nr_process>
    proc->parent->cptr = proc;
ffffffffc02042a2:	fb60                	sd	s0,240(a4)
    nr_process++;
ffffffffc02042a4:	2785                	addiw	a5,a5,1
ffffffffc02042a6:	00097717          	auipc	a4,0x97
ffffffffc02042aa:	3ef72923          	sw	a5,1010(a4) # ffffffffc029b698 <nr_process>
    if (flag)
ffffffffc02042ae:	14091863          	bnez	s2,ffffffffc02043fe <do_fork+0x372>
    wakeup_proc(proc);
ffffffffc02042b2:	8522                	mv	a0,s0
ffffffffc02042b4:	721000ef          	jal	ffffffffc02051d4 <wakeup_proc>
    ret = proc->pid;
ffffffffc02042b8:	4048                	lw	a0,4(s0)
ffffffffc02042ba:	79e2                	ld	s3,56(sp)
ffffffffc02042bc:	7a42                	ld	s4,48(sp)
ffffffffc02042be:	7aa2                	ld	s5,40(sp)
ffffffffc02042c0:	7b02                	ld	s6,32(sp)
ffffffffc02042c2:	6be2                	ld	s7,24(sp)
ffffffffc02042c4:	6c42                	ld	s8,16(sp)
ffffffffc02042c6:	6ca2                	ld	s9,8(sp)
}
ffffffffc02042c8:	60e6                	ld	ra,88(sp)
ffffffffc02042ca:	6446                	ld	s0,80(sp)
ffffffffc02042cc:	64a6                	ld	s1,72(sp)
ffffffffc02042ce:	6906                	ld	s2,64(sp)
ffffffffc02042d0:	6d02                	ld	s10,0(sp)
ffffffffc02042d2:	6125                	addi	sp,sp,96
ffffffffc02042d4:	8082                	ret
    if ((mm = mm_create()) == NULL)
ffffffffc02042d6:	ca8ff0ef          	jal	ffffffffc020377e <mm_create>
ffffffffc02042da:	8d2a                	mv	s10,a0
ffffffffc02042dc:	c949                	beqz	a0,ffffffffc020436e <do_fork+0x2e2>
    if ((page = alloc_page()) == NULL)
ffffffffc02042de:	4505                	li	a0,1
ffffffffc02042e0:	be7fd0ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc02042e4:	c151                	beqz	a0,ffffffffc0204368 <do_fork+0x2dc>
    return page - pages + nbase;
ffffffffc02042e6:	0009b703          	ld	a4,0(s3)
    return KADDR(page2pa(page));
ffffffffc02042ea:	000ab783          	ld	a5,0(s5)
    return page - pages + nbase;
ffffffffc02042ee:	40e506b3          	sub	a3,a0,a4
ffffffffc02042f2:	8699                	srai	a3,a3,0x6
ffffffffc02042f4:	96e6                	add	a3,a3,s9
    return KADDR(page2pa(page));
ffffffffc02042f6:	0186fc33          	and	s8,a3,s8
    return page2ppn(page) << PGSHIFT;
ffffffffc02042fa:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02042fc:	1afc7f63          	bgeu	s8,a5,ffffffffc02044ba <do_fork+0x42e>
ffffffffc0204300:	000b3783          	ld	a5,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204304:	00097597          	auipc	a1,0x97
ffffffffc0204308:	3745b583          	ld	a1,884(a1) # ffffffffc029b678 <boot_pgdir_va>
ffffffffc020430c:	6605                	lui	a2,0x1
ffffffffc020430e:	00f68c33          	add	s8,a3,a5
ffffffffc0204312:	8562                	mv	a0,s8
ffffffffc0204314:	564010ef          	jal	ffffffffc0205878 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc0204318:	038b8c93          	addi	s9,s7,56
    mm->pgdir = pgdir;
ffffffffc020431c:	018d3c23          	sd	s8,24(s10) # fffffffffff80018 <end+0x3fce4960>
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204320:	4c05                	li	s8,1
ffffffffc0204322:	418cb7af          	amoor.d	a5,s8,(s9)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc0204326:	03f79713          	slli	a4,a5,0x3f
ffffffffc020432a:	03f75793          	srli	a5,a4,0x3f
ffffffffc020432e:	cb91                	beqz	a5,ffffffffc0204342 <do_fork+0x2b6>
    {
        schedule();
ffffffffc0204330:	739000ef          	jal	ffffffffc0205268 <schedule>
ffffffffc0204334:	418cb7af          	amoor.d	a5,s8,(s9)
    while (!try_lock(lock))
ffffffffc0204338:	03f79713          	slli	a4,a5,0x3f
ffffffffc020433c:	03f75793          	srli	a5,a4,0x3f
ffffffffc0204340:	fbe5                	bnez	a5,ffffffffc0204330 <do_fork+0x2a4>
        ret = dup_mmap(mm, oldmm);
ffffffffc0204342:	85de                	mv	a1,s7
ffffffffc0204344:	856a                	mv	a0,s10
ffffffffc0204346:	e94ff0ef          	jal	ffffffffc02039da <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020434a:	57f9                	li	a5,-2
ffffffffc020434c:	60fcb7af          	amoand.d	a5,a5,(s9)
ffffffffc0204350:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc0204352:	12078263          	beqz	a5,ffffffffc0204476 <do_fork+0x3ea>
    if ((mm = mm_create()) == NULL)
ffffffffc0204356:	8bea                	mv	s7,s10
    if (ret != 0)
ffffffffc0204358:	de0506e3          	beqz	a0,ffffffffc0204144 <do_fork+0xb8>
    exit_mmap(mm);
ffffffffc020435c:	856a                	mv	a0,s10
ffffffffc020435e:	f14ff0ef          	jal	ffffffffc0203a72 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204362:	856a                	mv	a0,s10
ffffffffc0204364:	c51ff0ef          	jal	ffffffffc0203fb4 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204368:	856a                	mv	a0,s10
ffffffffc020436a:	d52ff0ef          	jal	ffffffffc02038bc <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc020436e:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc0204370:	c02007b7          	lui	a5,0xc0200
ffffffffc0204374:	0ef6e563          	bltu	a3,a5,ffffffffc020445e <do_fork+0x3d2>
ffffffffc0204378:	000b3783          	ld	a5,0(s6)
    if (PPN(pa) >= npage)
ffffffffc020437c:	000ab703          	ld	a4,0(s5)
    return pa2page(PADDR(kva));
ffffffffc0204380:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204384:	83b1                	srli	a5,a5,0xc
ffffffffc0204386:	08e7f763          	bgeu	a5,a4,ffffffffc0204414 <do_fork+0x388>
    return &pages[PPN(pa) - nbase];
ffffffffc020438a:	000a3703          	ld	a4,0(s4)
ffffffffc020438e:	0009b503          	ld	a0,0(s3)
ffffffffc0204392:	4589                	li	a1,2
ffffffffc0204394:	8f99                	sub	a5,a5,a4
ffffffffc0204396:	079a                	slli	a5,a5,0x6
ffffffffc0204398:	953e                	add	a0,a0,a5
ffffffffc020439a:	b67fd0ef          	jal	ffffffffc0201f00 <free_pages>
}
ffffffffc020439e:	79e2                	ld	s3,56(sp)
ffffffffc02043a0:	7a42                	ld	s4,48(sp)
ffffffffc02043a2:	7aa2                	ld	s5,40(sp)
ffffffffc02043a4:	6be2                	ld	s7,24(sp)
ffffffffc02043a6:	6c42                	ld	s8,16(sp)
ffffffffc02043a8:	6ca2                	ld	s9,8(sp)
    kfree(proc);
ffffffffc02043aa:	8522                	mv	a0,s0
ffffffffc02043ac:	9fffd0ef          	jal	ffffffffc0201daa <kfree>
ffffffffc02043b0:	7b02                	ld	s6,32(sp)
    ret = -E_NO_MEM;
ffffffffc02043b2:	5571                	li	a0,-4
    return ret;
ffffffffc02043b4:	bf11                	j	ffffffffc02042c8 <do_fork+0x23c>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02043b6:	8936                	mv	s2,a3
ffffffffc02043b8:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02043bc:	00000797          	auipc	a5,0x0
ffffffffc02043c0:	b6c78793          	addi	a5,a5,-1172 # ffffffffc0203f28 <forkret>
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02043c4:	fc14                	sd	a3,56(s0)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02043c6:	f81c                	sd	a5,48(s0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02043c8:	100027f3          	csrr	a5,sstatus
ffffffffc02043cc:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02043ce:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02043d0:	de0788e3          	beqz	a5,ffffffffc02041c0 <do_fork+0x134>
        intr_disable();
ffffffffc02043d4:	d30fc0ef          	jal	ffffffffc0200904 <intr_disable>
    if (++last_pid >= MAX_PID)
ffffffffc02043d8:	00093517          	auipc	a0,0x93
ffffffffc02043dc:	e3452503          	lw	a0,-460(a0) # ffffffffc029720c <last_pid.1>
ffffffffc02043e0:	6789                	lui	a5,0x2
        return 1;
ffffffffc02043e2:	4905                	li	s2,1
ffffffffc02043e4:	2505                	addiw	a0,a0,1
ffffffffc02043e6:	00093717          	auipc	a4,0x93
ffffffffc02043ea:	e2a72323          	sw	a0,-474(a4) # ffffffffc029720c <last_pid.1>
ffffffffc02043ee:	def545e3          	blt	a0,a5,ffffffffc02041d8 <do_fork+0x14c>
        last_pid = 1;
ffffffffc02043f2:	4505                	li	a0,1
ffffffffc02043f4:	00093797          	auipc	a5,0x93
ffffffffc02043f8:	e0a7ac23          	sw	a0,-488(a5) # ffffffffc029720c <last_pid.1>
        goto inside;
ffffffffc02043fc:	bbc5                	j	ffffffffc02041ec <do_fork+0x160>
        intr_enable();
ffffffffc02043fe:	d00fc0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0204402:	bd45                	j	ffffffffc02042b2 <do_fork+0x226>
                    if (last_pid >= MAX_PID)
ffffffffc0204404:	6789                	lui	a5,0x2
ffffffffc0204406:	00f6c363          	blt	a3,a5,ffffffffc020440c <do_fork+0x380>
                        last_pid = 1;
ffffffffc020440a:	4685                	li	a3,1
                    goto repeat;
ffffffffc020440c:	4585                	li	a1,1
ffffffffc020440e:	bbe5                	j	ffffffffc0204206 <do_fork+0x17a>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204410:	556d                	li	a0,-5
}
ffffffffc0204412:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0204414:	00002617          	auipc	a2,0x2
ffffffffc0204418:	2cc60613          	addi	a2,a2,716 # ffffffffc02066e0 <etext+0xe50>
ffffffffc020441c:	06900593          	li	a1,105
ffffffffc0204420:	00002517          	auipc	a0,0x2
ffffffffc0204424:	21850513          	addi	a0,a0,536 # ffffffffc0206638 <etext+0xda8>
ffffffffc0204428:	81efc0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc020442c:	00002617          	auipc	a2,0x2
ffffffffc0204430:	1e460613          	addi	a2,a2,484 # ffffffffc0206610 <etext+0xd80>
ffffffffc0204434:	07100593          	li	a1,113
ffffffffc0204438:	00002517          	auipc	a0,0x2
ffffffffc020443c:	20050513          	addi	a0,a0,512 # ffffffffc0206638 <etext+0xda8>
ffffffffc0204440:	806fc0ef          	jal	ffffffffc0200446 <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204444:	86be                	mv	a3,a5
ffffffffc0204446:	00002617          	auipc	a2,0x2
ffffffffc020444a:	27260613          	addi	a2,a2,626 # ffffffffc02066b8 <etext+0xe28>
ffffffffc020444e:	18400593          	li	a1,388
ffffffffc0204452:	00003517          	auipc	a0,0x3
ffffffffc0204456:	bf650513          	addi	a0,a0,-1034 # ffffffffc0207048 <etext+0x17b8>
ffffffffc020445a:	fedfb0ef          	jal	ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc020445e:	00002617          	auipc	a2,0x2
ffffffffc0204462:	25a60613          	addi	a2,a2,602 # ffffffffc02066b8 <etext+0xe28>
ffffffffc0204466:	07700593          	li	a1,119
ffffffffc020446a:	00002517          	auipc	a0,0x2
ffffffffc020446e:	1ce50513          	addi	a0,a0,462 # ffffffffc0206638 <etext+0xda8>
ffffffffc0204472:	fd5fb0ef          	jal	ffffffffc0200446 <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc0204476:	00003617          	auipc	a2,0x3
ffffffffc020447a:	c0a60613          	addi	a2,a2,-1014 # ffffffffc0207080 <etext+0x17f0>
ffffffffc020447e:	03f00593          	li	a1,63
ffffffffc0204482:	00003517          	auipc	a0,0x3
ffffffffc0204486:	c0e50513          	addi	a0,a0,-1010 # ffffffffc0207090 <etext+0x1800>
ffffffffc020448a:	fbdfb0ef          	jal	ffffffffc0200446 <__panic>
    assert(current->wait_state == 0);
ffffffffc020448e:	00003697          	auipc	a3,0x3
ffffffffc0204492:	bd268693          	addi	a3,a3,-1070 # ffffffffc0207060 <etext+0x17d0>
ffffffffc0204496:	00002617          	auipc	a2,0x2
ffffffffc020449a:	dca60613          	addi	a2,a2,-566 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020449e:	1c400593          	li	a1,452
ffffffffc02044a2:	00003517          	auipc	a0,0x3
ffffffffc02044a6:	ba650513          	addi	a0,a0,-1114 # ffffffffc0207048 <etext+0x17b8>
ffffffffc02044aa:	fc4e                	sd	s3,56(sp)
ffffffffc02044ac:	f852                	sd	s4,48(sp)
ffffffffc02044ae:	f456                	sd	s5,40(sp)
ffffffffc02044b0:	ec5e                	sd	s7,24(sp)
ffffffffc02044b2:	e862                	sd	s8,16(sp)
ffffffffc02044b4:	e466                	sd	s9,8(sp)
ffffffffc02044b6:	f91fb0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc02044ba:	00002617          	auipc	a2,0x2
ffffffffc02044be:	15660613          	addi	a2,a2,342 # ffffffffc0206610 <etext+0xd80>
ffffffffc02044c2:	07100593          	li	a1,113
ffffffffc02044c6:	00002517          	auipc	a0,0x2
ffffffffc02044ca:	17250513          	addi	a0,a0,370 # ffffffffc0206638 <etext+0xda8>
ffffffffc02044ce:	f79fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02044d2 <kernel_thread>:
{
ffffffffc02044d2:	7129                	addi	sp,sp,-320
ffffffffc02044d4:	fa22                	sd	s0,304(sp)
ffffffffc02044d6:	f626                	sd	s1,296(sp)
ffffffffc02044d8:	f24a                	sd	s2,288(sp)
ffffffffc02044da:	842a                	mv	s0,a0
ffffffffc02044dc:	84ae                	mv	s1,a1
ffffffffc02044de:	8932                	mv	s2,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02044e0:	850a                	mv	a0,sp
ffffffffc02044e2:	12000613          	li	a2,288
ffffffffc02044e6:	4581                	li	a1,0
{
ffffffffc02044e8:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02044ea:	37c010ef          	jal	ffffffffc0205866 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02044ee:	e0a2                	sd	s0,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02044f0:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02044f2:	100027f3          	csrr	a5,sstatus
ffffffffc02044f6:	edd7f793          	andi	a5,a5,-291
ffffffffc02044fa:	1207e793          	ori	a5,a5,288
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02044fe:	860a                	mv	a2,sp
ffffffffc0204500:	10096513          	ori	a0,s2,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204504:	00000717          	auipc	a4,0x0
ffffffffc0204508:	9aa70713          	addi	a4,a4,-1622 # ffffffffc0203eae <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020450c:	4581                	li	a1,0
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc020450e:	e23e                	sd	a5,256(sp)
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204510:	e63a                	sd	a4,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204512:	b7bff0ef          	jal	ffffffffc020408c <do_fork>
}
ffffffffc0204516:	70f2                	ld	ra,312(sp)
ffffffffc0204518:	7452                	ld	s0,304(sp)
ffffffffc020451a:	74b2                	ld	s1,296(sp)
ffffffffc020451c:	7912                	ld	s2,288(sp)
ffffffffc020451e:	6131                	addi	sp,sp,320
ffffffffc0204520:	8082                	ret

ffffffffc0204522 <do_exit>:
{
ffffffffc0204522:	7179                	addi	sp,sp,-48
ffffffffc0204524:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204526:	00097417          	auipc	s0,0x97
ffffffffc020452a:	17a40413          	addi	s0,s0,378 # ffffffffc029b6a0 <current>
ffffffffc020452e:	601c                	ld	a5,0(s0)
ffffffffc0204530:	00097717          	auipc	a4,0x97
ffffffffc0204534:	18073703          	ld	a4,384(a4) # ffffffffc029b6b0 <idleproc>
{
ffffffffc0204538:	f406                	sd	ra,40(sp)
ffffffffc020453a:	ec26                	sd	s1,24(sp)
    if (current == idleproc)
ffffffffc020453c:	0ce78b63          	beq	a5,a4,ffffffffc0204612 <do_exit+0xf0>
    if (current == initproc)
ffffffffc0204540:	00097497          	auipc	s1,0x97
ffffffffc0204544:	16848493          	addi	s1,s1,360 # ffffffffc029b6a8 <initproc>
ffffffffc0204548:	6098                	ld	a4,0(s1)
ffffffffc020454a:	e84a                	sd	s2,16(sp)
ffffffffc020454c:	0ee78a63          	beq	a5,a4,ffffffffc0204640 <do_exit+0x11e>
ffffffffc0204550:	892a                	mv	s2,a0
    struct mm_struct *mm = current->mm;
ffffffffc0204552:	7788                	ld	a0,40(a5)
    if (mm != NULL)
ffffffffc0204554:	c115                	beqz	a0,ffffffffc0204578 <do_exit+0x56>
ffffffffc0204556:	00097797          	auipc	a5,0x97
ffffffffc020455a:	11a7b783          	ld	a5,282(a5) # ffffffffc029b670 <boot_pgdir_pa>
ffffffffc020455e:	577d                	li	a4,-1
ffffffffc0204560:	177e                	slli	a4,a4,0x3f
ffffffffc0204562:	83b1                	srli	a5,a5,0xc
ffffffffc0204564:	8fd9                	or	a5,a5,a4
ffffffffc0204566:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc020456a:	591c                	lw	a5,48(a0)
ffffffffc020456c:	37fd                	addiw	a5,a5,-1
ffffffffc020456e:	d91c                	sw	a5,48(a0)
        if (mm_count_dec(mm) == 0)
ffffffffc0204570:	cfd5                	beqz	a5,ffffffffc020462c <do_exit+0x10a>
        current->mm = NULL;
ffffffffc0204572:	601c                	ld	a5,0(s0)
ffffffffc0204574:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0204578:	470d                	li	a4,3
    current->exit_code = error_code;
ffffffffc020457a:	0f27a423          	sw	s2,232(a5)
    current->state = PROC_ZOMBIE;
ffffffffc020457e:	c398                	sw	a4,0(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204580:	100027f3          	csrr	a5,sstatus
ffffffffc0204584:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204586:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204588:	ebe1                	bnez	a5,ffffffffc0204658 <do_exit+0x136>
        proc = current->parent;
ffffffffc020458a:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc020458c:	800007b7          	lui	a5,0x80000
ffffffffc0204590:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e41>
        proc = current->parent;
ffffffffc0204592:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204594:	0ec52703          	lw	a4,236(a0)
ffffffffc0204598:	0cf70463          	beq	a4,a5,ffffffffc0204660 <do_exit+0x13e>
        while (current->cptr != NULL)
ffffffffc020459c:	6018                	ld	a4,0(s0)
                if (initproc->wait_state == WT_CHILD)
ffffffffc020459e:	800005b7          	lui	a1,0x80000
ffffffffc02045a2:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e41>
        while (current->cptr != NULL)
ffffffffc02045a4:	7b7c                	ld	a5,240(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045a6:	460d                	li	a2,3
        while (current->cptr != NULL)
ffffffffc02045a8:	e789                	bnez	a5,ffffffffc02045b2 <do_exit+0x90>
ffffffffc02045aa:	a83d                	j	ffffffffc02045e8 <do_exit+0xc6>
ffffffffc02045ac:	6018                	ld	a4,0(s0)
ffffffffc02045ae:	7b7c                	ld	a5,240(a4)
ffffffffc02045b0:	cf85                	beqz	a5,ffffffffc02045e8 <do_exit+0xc6>
            current->cptr = proc->optr;
ffffffffc02045b2:	1007b683          	ld	a3,256(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02045b6:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc02045b8:	fb74                	sd	a3,240(a4)
            proc->yptr = NULL;
ffffffffc02045ba:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02045be:	7978                	ld	a4,240(a0)
ffffffffc02045c0:	10e7b023          	sd	a4,256(a5)
ffffffffc02045c4:	c311                	beqz	a4,ffffffffc02045c8 <do_exit+0xa6>
                initproc->cptr->yptr = proc;
ffffffffc02045c6:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045c8:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02045ca:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02045cc:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045ce:	fcc71fe3          	bne	a4,a2,ffffffffc02045ac <do_exit+0x8a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02045d2:	0ec52783          	lw	a5,236(a0)
ffffffffc02045d6:	fcb79be3          	bne	a5,a1,ffffffffc02045ac <do_exit+0x8a>
                    wakeup_proc(initproc);
ffffffffc02045da:	3fb000ef          	jal	ffffffffc02051d4 <wakeup_proc>
ffffffffc02045de:	800005b7          	lui	a1,0x80000
ffffffffc02045e2:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e41>
ffffffffc02045e4:	460d                	li	a2,3
ffffffffc02045e6:	b7d9                	j	ffffffffc02045ac <do_exit+0x8a>
    if (flag)
ffffffffc02045e8:	02091263          	bnez	s2,ffffffffc020460c <do_exit+0xea>
    schedule();
ffffffffc02045ec:	47d000ef          	jal	ffffffffc0205268 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc02045f0:	601c                	ld	a5,0(s0)
ffffffffc02045f2:	00003617          	auipc	a2,0x3
ffffffffc02045f6:	ad660613          	addi	a2,a2,-1322 # ffffffffc02070c8 <etext+0x1838>
ffffffffc02045fa:	22e00593          	li	a1,558
ffffffffc02045fe:	43d4                	lw	a3,4(a5)
ffffffffc0204600:	00003517          	auipc	a0,0x3
ffffffffc0204604:	a4850513          	addi	a0,a0,-1464 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0204608:	e3ffb0ef          	jal	ffffffffc0200446 <__panic>
        intr_enable();
ffffffffc020460c:	af2fc0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0204610:	bff1                	j	ffffffffc02045ec <do_exit+0xca>
        panic("idleproc exit.\n");
ffffffffc0204612:	00003617          	auipc	a2,0x3
ffffffffc0204616:	a9660613          	addi	a2,a2,-1386 # ffffffffc02070a8 <etext+0x1818>
ffffffffc020461a:	1fa00593          	li	a1,506
ffffffffc020461e:	00003517          	auipc	a0,0x3
ffffffffc0204622:	a2a50513          	addi	a0,a0,-1494 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0204626:	e84a                	sd	s2,16(sp)
ffffffffc0204628:	e1ffb0ef          	jal	ffffffffc0200446 <__panic>
            exit_mmap(mm);
ffffffffc020462c:	e42a                	sd	a0,8(sp)
ffffffffc020462e:	c44ff0ef          	jal	ffffffffc0203a72 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204632:	6522                	ld	a0,8(sp)
ffffffffc0204634:	981ff0ef          	jal	ffffffffc0203fb4 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204638:	6522                	ld	a0,8(sp)
ffffffffc020463a:	a82ff0ef          	jal	ffffffffc02038bc <mm_destroy>
ffffffffc020463e:	bf15                	j	ffffffffc0204572 <do_exit+0x50>
        panic("initproc exit.\n");
ffffffffc0204640:	00003617          	auipc	a2,0x3
ffffffffc0204644:	a7860613          	addi	a2,a2,-1416 # ffffffffc02070b8 <etext+0x1828>
ffffffffc0204648:	1fe00593          	li	a1,510
ffffffffc020464c:	00003517          	auipc	a0,0x3
ffffffffc0204650:	9fc50513          	addi	a0,a0,-1540 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0204654:	df3fb0ef          	jal	ffffffffc0200446 <__panic>
        intr_disable();
ffffffffc0204658:	aacfc0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc020465c:	4905                	li	s2,1
ffffffffc020465e:	b735                	j	ffffffffc020458a <do_exit+0x68>
            wakeup_proc(proc);
ffffffffc0204660:	375000ef          	jal	ffffffffc02051d4 <wakeup_proc>
ffffffffc0204664:	bf25                	j	ffffffffc020459c <do_exit+0x7a>

ffffffffc0204666 <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc0204666:	7179                	addi	sp,sp,-48
ffffffffc0204668:	ec26                	sd	s1,24(sp)
ffffffffc020466a:	e84a                	sd	s2,16(sp)
ffffffffc020466c:	e44e                	sd	s3,8(sp)
ffffffffc020466e:	f406                	sd	ra,40(sp)
ffffffffc0204670:	f022                	sd	s0,32(sp)
ffffffffc0204672:	84aa                	mv	s1,a0
ffffffffc0204674:	892e                	mv	s2,a1
ffffffffc0204676:	00097997          	auipc	s3,0x97
ffffffffc020467a:	02a98993          	addi	s3,s3,42 # ffffffffc029b6a0 <current>
    if (pid != 0)
ffffffffc020467e:	cd19                	beqz	a0,ffffffffc020469c <do_wait.part.0+0x36>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204680:	6789                	lui	a5,0x2
ffffffffc0204682:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6bca>
ffffffffc0204684:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204688:	12e7f563          	bgeu	a5,a4,ffffffffc02047b2 <do_wait.part.0+0x14c>
}
ffffffffc020468c:	70a2                	ld	ra,40(sp)
ffffffffc020468e:	7402                	ld	s0,32(sp)
ffffffffc0204690:	64e2                	ld	s1,24(sp)
ffffffffc0204692:	6942                	ld	s2,16(sp)
ffffffffc0204694:	69a2                	ld	s3,8(sp)
    return -E_BAD_PROC;
ffffffffc0204696:	5579                	li	a0,-2
}
ffffffffc0204698:	6145                	addi	sp,sp,48
ffffffffc020469a:	8082                	ret
        proc = current->cptr;
ffffffffc020469c:	0009b703          	ld	a4,0(s3)
ffffffffc02046a0:	7b60                	ld	s0,240(a4)
        for (; proc != NULL; proc = proc->optr)
ffffffffc02046a2:	d46d                	beqz	s0,ffffffffc020468c <do_wait.part.0+0x26>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02046a4:	468d                	li	a3,3
ffffffffc02046a6:	a021                	j	ffffffffc02046ae <do_wait.part.0+0x48>
        for (; proc != NULL; proc = proc->optr)
ffffffffc02046a8:	10043403          	ld	s0,256(s0)
ffffffffc02046ac:	c075                	beqz	s0,ffffffffc0204790 <do_wait.part.0+0x12a>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02046ae:	401c                	lw	a5,0(s0)
ffffffffc02046b0:	fed79ce3          	bne	a5,a3,ffffffffc02046a8 <do_wait.part.0+0x42>
    if (proc == idleproc || proc == initproc)
ffffffffc02046b4:	00097797          	auipc	a5,0x97
ffffffffc02046b8:	ffc7b783          	ld	a5,-4(a5) # ffffffffc029b6b0 <idleproc>
ffffffffc02046bc:	14878263          	beq	a5,s0,ffffffffc0204800 <do_wait.part.0+0x19a>
ffffffffc02046c0:	00097797          	auipc	a5,0x97
ffffffffc02046c4:	fe87b783          	ld	a5,-24(a5) # ffffffffc029b6a8 <initproc>
ffffffffc02046c8:	12f40c63          	beq	s0,a5,ffffffffc0204800 <do_wait.part.0+0x19a>
    if (code_store != NULL)
ffffffffc02046cc:	00090663          	beqz	s2,ffffffffc02046d8 <do_wait.part.0+0x72>
        *code_store = proc->exit_code;
ffffffffc02046d0:	0e842783          	lw	a5,232(s0)
ffffffffc02046d4:	00f92023          	sw	a5,0(s2)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02046d8:	100027f3          	csrr	a5,sstatus
ffffffffc02046dc:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02046de:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02046e0:	10079963          	bnez	a5,ffffffffc02047f2 <do_wait.part.0+0x18c>
    __list_del(listelm->prev, listelm->next);
ffffffffc02046e4:	6c74                	ld	a3,216(s0)
ffffffffc02046e6:	7078                	ld	a4,224(s0)
    if (proc->optr != NULL)
ffffffffc02046e8:	10043783          	ld	a5,256(s0)
    prev->next = next;
ffffffffc02046ec:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc02046ee:	e314                	sd	a3,0(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc02046f0:	6474                	ld	a3,200(s0)
ffffffffc02046f2:	6878                	ld	a4,208(s0)
    prev->next = next;
ffffffffc02046f4:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc02046f6:	e314                	sd	a3,0(a4)
ffffffffc02046f8:	c789                	beqz	a5,ffffffffc0204702 <do_wait.part.0+0x9c>
        proc->optr->yptr = proc->yptr;
ffffffffc02046fa:	7c78                	ld	a4,248(s0)
ffffffffc02046fc:	fff8                	sd	a4,248(a5)
        proc->yptr->optr = proc->optr;
ffffffffc02046fe:	10043783          	ld	a5,256(s0)
    if (proc->yptr != NULL)
ffffffffc0204702:	7c78                	ld	a4,248(s0)
ffffffffc0204704:	c36d                	beqz	a4,ffffffffc02047e6 <do_wait.part.0+0x180>
        proc->yptr->optr = proc->optr;
ffffffffc0204706:	10f73023          	sd	a5,256(a4)
    nr_process--;
ffffffffc020470a:	00097797          	auipc	a5,0x97
ffffffffc020470e:	f8e7a783          	lw	a5,-114(a5) # ffffffffc029b698 <nr_process>
ffffffffc0204712:	37fd                	addiw	a5,a5,-1
ffffffffc0204714:	00097717          	auipc	a4,0x97
ffffffffc0204718:	f8f72223          	sw	a5,-124(a4) # ffffffffc029b698 <nr_process>
    if (flag)
ffffffffc020471c:	e271                	bnez	a2,ffffffffc02047e0 <do_wait.part.0+0x17a>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc020471e:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc0204720:	c02007b7          	lui	a5,0xc0200
ffffffffc0204724:	10f6e663          	bltu	a3,a5,ffffffffc0204830 <do_wait.part.0+0x1ca>
ffffffffc0204728:	00097717          	auipc	a4,0x97
ffffffffc020472c:	f5873703          	ld	a4,-168(a4) # ffffffffc029b680 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0204730:	00097797          	auipc	a5,0x97
ffffffffc0204734:	f587b783          	ld	a5,-168(a5) # ffffffffc029b688 <npage>
    return pa2page(PADDR(kva));
ffffffffc0204738:	8e99                	sub	a3,a3,a4
    if (PPN(pa) >= npage)
ffffffffc020473a:	82b1                	srli	a3,a3,0xc
ffffffffc020473c:	0cf6fe63          	bgeu	a3,a5,ffffffffc0204818 <do_wait.part.0+0x1b2>
    return &pages[PPN(pa) - nbase];
ffffffffc0204740:	00003797          	auipc	a5,0x3
ffffffffc0204744:	2b07b783          	ld	a5,688(a5) # ffffffffc02079f0 <nbase>
ffffffffc0204748:	00097517          	auipc	a0,0x97
ffffffffc020474c:	f4853503          	ld	a0,-184(a0) # ffffffffc029b690 <pages>
ffffffffc0204750:	4589                	li	a1,2
ffffffffc0204752:	8e9d                	sub	a3,a3,a5
ffffffffc0204754:	069a                	slli	a3,a3,0x6
ffffffffc0204756:	9536                	add	a0,a0,a3
ffffffffc0204758:	fa8fd0ef          	jal	ffffffffc0201f00 <free_pages>
    kfree(proc);
ffffffffc020475c:	8522                	mv	a0,s0
ffffffffc020475e:	e4cfd0ef          	jal	ffffffffc0201daa <kfree>
}
ffffffffc0204762:	70a2                	ld	ra,40(sp)
ffffffffc0204764:	7402                	ld	s0,32(sp)
ffffffffc0204766:	64e2                	ld	s1,24(sp)
ffffffffc0204768:	6942                	ld	s2,16(sp)
ffffffffc020476a:	69a2                	ld	s3,8(sp)
    return 0;
ffffffffc020476c:	4501                	li	a0,0
}
ffffffffc020476e:	6145                	addi	sp,sp,48
ffffffffc0204770:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc0204772:	00097997          	auipc	s3,0x97
ffffffffc0204776:	f2e98993          	addi	s3,s3,-210 # ffffffffc029b6a0 <current>
ffffffffc020477a:	0009b703          	ld	a4,0(s3)
ffffffffc020477e:	f487b683          	ld	a3,-184(a5)
ffffffffc0204782:	f0e695e3          	bne	a3,a4,ffffffffc020468c <do_wait.part.0+0x26>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204786:	f287a603          	lw	a2,-216(a5)
ffffffffc020478a:	468d                	li	a3,3
ffffffffc020478c:	06d60063          	beq	a2,a3,ffffffffc02047ec <do_wait.part.0+0x186>
        current->wait_state = WT_CHILD;
ffffffffc0204790:	800007b7          	lui	a5,0x80000
ffffffffc0204794:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e41>
        current->state = PROC_SLEEPING;
ffffffffc0204796:	4685                	li	a3,1
        current->wait_state = WT_CHILD;
ffffffffc0204798:	0ef72623          	sw	a5,236(a4)
        current->state = PROC_SLEEPING;
ffffffffc020479c:	c314                	sw	a3,0(a4)
        schedule();
ffffffffc020479e:	2cb000ef          	jal	ffffffffc0205268 <schedule>
        if (current->flags & PF_EXITING)
ffffffffc02047a2:	0009b783          	ld	a5,0(s3)
ffffffffc02047a6:	0b07a783          	lw	a5,176(a5)
ffffffffc02047aa:	8b85                	andi	a5,a5,1
ffffffffc02047ac:	e7b9                	bnez	a5,ffffffffc02047fa <do_wait.part.0+0x194>
    if (pid != 0)
ffffffffc02047ae:	ee0487e3          	beqz	s1,ffffffffc020469c <do_wait.part.0+0x36>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02047b2:	45a9                	li	a1,10
ffffffffc02047b4:	8526                	mv	a0,s1
ffffffffc02047b6:	41b000ef          	jal	ffffffffc02053d0 <hash32>
ffffffffc02047ba:	02051793          	slli	a5,a0,0x20
ffffffffc02047be:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02047c2:	00093797          	auipc	a5,0x93
ffffffffc02047c6:	e6678793          	addi	a5,a5,-410 # ffffffffc0297628 <hash_list>
ffffffffc02047ca:	953e                	add	a0,a0,a5
ffffffffc02047cc:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc02047ce:	a029                	j	ffffffffc02047d8 <do_wait.part.0+0x172>
            if (proc->pid == pid)
ffffffffc02047d0:	f2c7a703          	lw	a4,-212(a5)
ffffffffc02047d4:	f8970fe3          	beq	a4,s1,ffffffffc0204772 <do_wait.part.0+0x10c>
    return listelm->next;
ffffffffc02047d8:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02047da:	fef51be3          	bne	a0,a5,ffffffffc02047d0 <do_wait.part.0+0x16a>
ffffffffc02047de:	b57d                	j	ffffffffc020468c <do_wait.part.0+0x26>
        intr_enable();
ffffffffc02047e0:	91efc0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02047e4:	bf2d                	j	ffffffffc020471e <do_wait.part.0+0xb8>
        proc->parent->cptr = proc->optr;
ffffffffc02047e6:	7018                	ld	a4,32(s0)
ffffffffc02047e8:	fb7c                	sd	a5,240(a4)
ffffffffc02047ea:	b705                	j	ffffffffc020470a <do_wait.part.0+0xa4>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02047ec:	f2878413          	addi	s0,a5,-216
ffffffffc02047f0:	b5d1                	j	ffffffffc02046b4 <do_wait.part.0+0x4e>
        intr_disable();
ffffffffc02047f2:	912fc0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc02047f6:	4605                	li	a2,1
ffffffffc02047f8:	b5f5                	j	ffffffffc02046e4 <do_wait.part.0+0x7e>
            do_exit(-E_KILLED);
ffffffffc02047fa:	555d                	li	a0,-9
ffffffffc02047fc:	d27ff0ef          	jal	ffffffffc0204522 <do_exit>
        panic("wait idleproc or initproc.\n");
ffffffffc0204800:	00003617          	auipc	a2,0x3
ffffffffc0204804:	8e860613          	addi	a2,a2,-1816 # ffffffffc02070e8 <etext+0x1858>
ffffffffc0204808:	34a00593          	li	a1,842
ffffffffc020480c:	00003517          	auipc	a0,0x3
ffffffffc0204810:	83c50513          	addi	a0,a0,-1988 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0204814:	c33fb0ef          	jal	ffffffffc0200446 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204818:	00002617          	auipc	a2,0x2
ffffffffc020481c:	ec860613          	addi	a2,a2,-312 # ffffffffc02066e0 <etext+0xe50>
ffffffffc0204820:	06900593          	li	a1,105
ffffffffc0204824:	00002517          	auipc	a0,0x2
ffffffffc0204828:	e1450513          	addi	a0,a0,-492 # ffffffffc0206638 <etext+0xda8>
ffffffffc020482c:	c1bfb0ef          	jal	ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204830:	00002617          	auipc	a2,0x2
ffffffffc0204834:	e8860613          	addi	a2,a2,-376 # ffffffffc02066b8 <etext+0xe28>
ffffffffc0204838:	07700593          	li	a1,119
ffffffffc020483c:	00002517          	auipc	a0,0x2
ffffffffc0204840:	dfc50513          	addi	a0,a0,-516 # ffffffffc0206638 <etext+0xda8>
ffffffffc0204844:	c03fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0204848 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc0204848:	1141                	addi	sp,sp,-16
ffffffffc020484a:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc020484c:	eecfd0ef          	jal	ffffffffc0201f38 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204850:	cb0fd0ef          	jal	ffffffffc0201d00 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0204854:	4601                	li	a2,0
ffffffffc0204856:	4581                	li	a1,0
ffffffffc0204858:	fffff517          	auipc	a0,0xfffff
ffffffffc020485c:	6de50513          	addi	a0,a0,1758 # ffffffffc0203f36 <user_main>
ffffffffc0204860:	c73ff0ef          	jal	ffffffffc02044d2 <kernel_thread>
    if (pid <= 0)
ffffffffc0204864:	00a04563          	bgtz	a0,ffffffffc020486e <init_main+0x26>
ffffffffc0204868:	a071                	j	ffffffffc02048f4 <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc020486a:	1ff000ef          	jal	ffffffffc0205268 <schedule>
    if (code_store != NULL)
ffffffffc020486e:	4581                	li	a1,0
ffffffffc0204870:	4501                	li	a0,0
ffffffffc0204872:	df5ff0ef          	jal	ffffffffc0204666 <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc0204876:	d975                	beqz	a0,ffffffffc020486a <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0204878:	00003517          	auipc	a0,0x3
ffffffffc020487c:	8b050513          	addi	a0,a0,-1872 # ffffffffc0207128 <etext+0x1898>
ffffffffc0204880:	915fb0ef          	jal	ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204884:	00097797          	auipc	a5,0x97
ffffffffc0204888:	e247b783          	ld	a5,-476(a5) # ffffffffc029b6a8 <initproc>
ffffffffc020488c:	7bf8                	ld	a4,240(a5)
ffffffffc020488e:	e339                	bnez	a4,ffffffffc02048d4 <init_main+0x8c>
ffffffffc0204890:	7ff8                	ld	a4,248(a5)
ffffffffc0204892:	e329                	bnez	a4,ffffffffc02048d4 <init_main+0x8c>
ffffffffc0204894:	1007b703          	ld	a4,256(a5)
ffffffffc0204898:	ef15                	bnez	a4,ffffffffc02048d4 <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc020489a:	00097697          	auipc	a3,0x97
ffffffffc020489e:	dfe6a683          	lw	a3,-514(a3) # ffffffffc029b698 <nr_process>
ffffffffc02048a2:	4709                	li	a4,2
ffffffffc02048a4:	0ae69463          	bne	a3,a4,ffffffffc020494c <init_main+0x104>
ffffffffc02048a8:	00097697          	auipc	a3,0x97
ffffffffc02048ac:	d8068693          	addi	a3,a3,-640 # ffffffffc029b628 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc02048b0:	6698                	ld	a4,8(a3)
ffffffffc02048b2:	0c878793          	addi	a5,a5,200
ffffffffc02048b6:	06f71b63          	bne	a4,a5,ffffffffc020492c <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02048ba:	629c                	ld	a5,0(a3)
ffffffffc02048bc:	04f71863          	bne	a4,a5,ffffffffc020490c <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc02048c0:	00003517          	auipc	a0,0x3
ffffffffc02048c4:	95050513          	addi	a0,a0,-1712 # ffffffffc0207210 <etext+0x1980>
ffffffffc02048c8:	8cdfb0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc02048cc:	60a2                	ld	ra,8(sp)
ffffffffc02048ce:	4501                	li	a0,0
ffffffffc02048d0:	0141                	addi	sp,sp,16
ffffffffc02048d2:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02048d4:	00003697          	auipc	a3,0x3
ffffffffc02048d8:	87c68693          	addi	a3,a3,-1924 # ffffffffc0207150 <etext+0x18c0>
ffffffffc02048dc:	00002617          	auipc	a2,0x2
ffffffffc02048e0:	98460613          	addi	a2,a2,-1660 # ffffffffc0206260 <etext+0x9d0>
ffffffffc02048e4:	3b800593          	li	a1,952
ffffffffc02048e8:	00002517          	auipc	a0,0x2
ffffffffc02048ec:	76050513          	addi	a0,a0,1888 # ffffffffc0207048 <etext+0x17b8>
ffffffffc02048f0:	b57fb0ef          	jal	ffffffffc0200446 <__panic>
        panic("create user_main failed.\n");
ffffffffc02048f4:	00003617          	auipc	a2,0x3
ffffffffc02048f8:	81460613          	addi	a2,a2,-2028 # ffffffffc0207108 <etext+0x1878>
ffffffffc02048fc:	3af00593          	li	a1,943
ffffffffc0204900:	00002517          	auipc	a0,0x2
ffffffffc0204904:	74850513          	addi	a0,a0,1864 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0204908:	b3ffb0ef          	jal	ffffffffc0200446 <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc020490c:	00003697          	auipc	a3,0x3
ffffffffc0204910:	8d468693          	addi	a3,a3,-1836 # ffffffffc02071e0 <etext+0x1950>
ffffffffc0204914:	00002617          	auipc	a2,0x2
ffffffffc0204918:	94c60613          	addi	a2,a2,-1716 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020491c:	3bb00593          	li	a1,955
ffffffffc0204920:	00002517          	auipc	a0,0x2
ffffffffc0204924:	72850513          	addi	a0,a0,1832 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0204928:	b1ffb0ef          	jal	ffffffffc0200446 <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc020492c:	00003697          	auipc	a3,0x3
ffffffffc0204930:	88468693          	addi	a3,a3,-1916 # ffffffffc02071b0 <etext+0x1920>
ffffffffc0204934:	00002617          	auipc	a2,0x2
ffffffffc0204938:	92c60613          	addi	a2,a2,-1748 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020493c:	3ba00593          	li	a1,954
ffffffffc0204940:	00002517          	auipc	a0,0x2
ffffffffc0204944:	70850513          	addi	a0,a0,1800 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0204948:	afffb0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_process == 2);
ffffffffc020494c:	00003697          	auipc	a3,0x3
ffffffffc0204950:	85468693          	addi	a3,a3,-1964 # ffffffffc02071a0 <etext+0x1910>
ffffffffc0204954:	00002617          	auipc	a2,0x2
ffffffffc0204958:	90c60613          	addi	a2,a2,-1780 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020495c:	3b900593          	li	a1,953
ffffffffc0204960:	00002517          	auipc	a0,0x2
ffffffffc0204964:	6e850513          	addi	a0,a0,1768 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0204968:	adffb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020496c <do_execve>:
{
ffffffffc020496c:	7171                	addi	sp,sp,-176
ffffffffc020496e:	e8ea                	sd	s10,80(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204970:	00097d17          	auipc	s10,0x97
ffffffffc0204974:	d30d0d13          	addi	s10,s10,-720 # ffffffffc029b6a0 <current>
ffffffffc0204978:	000d3783          	ld	a5,0(s10)
{
ffffffffc020497c:	ed26                	sd	s1,152(sp)
ffffffffc020497e:	f122                	sd	s0,160(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204980:	7784                	ld	s1,40(a5)
{
ffffffffc0204982:	842e                	mv	s0,a1
ffffffffc0204984:	e94a                	sd	s2,144(sp)
ffffffffc0204986:	ec32                	sd	a2,24(sp)
ffffffffc0204988:	892a                	mv	s2,a0
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc020498a:	85aa                	mv	a1,a0
ffffffffc020498c:	8622                	mv	a2,s0
ffffffffc020498e:	8526                	mv	a0,s1
ffffffffc0204990:	4681                	li	a3,0
{
ffffffffc0204992:	f506                	sd	ra,168(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204994:	c76ff0ef          	jal	ffffffffc0203e0a <user_mem_check>
ffffffffc0204998:	46050363          	beqz	a0,ffffffffc0204dfe <do_execve+0x492>
    memset(local_name, 0, sizeof(local_name));
ffffffffc020499c:	4641                	li	a2,16
ffffffffc020499e:	1808                	addi	a0,sp,48
ffffffffc02049a0:	4581                	li	a1,0
ffffffffc02049a2:	6c5000ef          	jal	ffffffffc0205866 <memset>
    if (len > PROC_NAME_LEN)
ffffffffc02049a6:	47bd                	li	a5,15
ffffffffc02049a8:	8622                	mv	a2,s0
ffffffffc02049aa:	0e87ec63          	bltu	a5,s0,ffffffffc0204aa2 <do_execve+0x136>
    memcpy(local_name, name, len);
ffffffffc02049ae:	85ca                	mv	a1,s2
ffffffffc02049b0:	1808                	addi	a0,sp,48
ffffffffc02049b2:	6c7000ef          	jal	ffffffffc0205878 <memcpy>
    if (mm != NULL)
ffffffffc02049b6:	0e048d63          	beqz	s1,ffffffffc0204ab0 <do_execve+0x144>
        cputs("mm != NULL");
ffffffffc02049ba:	00002517          	auipc	a0,0x2
ffffffffc02049be:	44e50513          	addi	a0,a0,1102 # ffffffffc0206e08 <etext+0x1578>
ffffffffc02049c2:	809fb0ef          	jal	ffffffffc02001ca <cputs>
ffffffffc02049c6:	00097797          	auipc	a5,0x97
ffffffffc02049ca:	caa7b783          	ld	a5,-854(a5) # ffffffffc029b670 <boot_pgdir_pa>
ffffffffc02049ce:	577d                	li	a4,-1
ffffffffc02049d0:	177e                	slli	a4,a4,0x3f
ffffffffc02049d2:	83b1                	srli	a5,a5,0xc
ffffffffc02049d4:	8fd9                	or	a5,a5,a4
ffffffffc02049d6:	18079073          	csrw	satp,a5
ffffffffc02049da:	589c                	lw	a5,48(s1)
ffffffffc02049dc:	37fd                	addiw	a5,a5,-1
ffffffffc02049de:	d89c                	sw	a5,48(s1)
        if (mm_count_dec(mm) == 0)
ffffffffc02049e0:	2e078c63          	beqz	a5,ffffffffc0204cd8 <do_execve+0x36c>
        current->mm = NULL;
ffffffffc02049e4:	000d3783          	ld	a5,0(s10)
ffffffffc02049e8:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc02049ec:	d93fe0ef          	jal	ffffffffc020377e <mm_create>
ffffffffc02049f0:	84aa                	mv	s1,a0
ffffffffc02049f2:	20050863          	beqz	a0,ffffffffc0204c02 <do_execve+0x296>
    if ((page = alloc_page()) == NULL)
ffffffffc02049f6:	4505                	li	a0,1
ffffffffc02049f8:	ccefd0ef          	jal	ffffffffc0201ec6 <alloc_pages>
ffffffffc02049fc:	40050663          	beqz	a0,ffffffffc0204e08 <do_execve+0x49c>
    return page - pages + nbase;
ffffffffc0204a00:	f4de                	sd	s7,104(sp)
ffffffffc0204a02:	00097b97          	auipc	s7,0x97
ffffffffc0204a06:	c8eb8b93          	addi	s7,s7,-882 # ffffffffc029b690 <pages>
ffffffffc0204a0a:	000bb783          	ld	a5,0(s7)
ffffffffc0204a0e:	f8da                	sd	s6,112(sp)
ffffffffc0204a10:	00003b17          	auipc	s6,0x3
ffffffffc0204a14:	fe0b3b03          	ld	s6,-32(s6) # ffffffffc02079f0 <nbase>
ffffffffc0204a18:	40f506b3          	sub	a3,a0,a5
ffffffffc0204a1c:	f0e2                	sd	s8,96(sp)
    return KADDR(page2pa(page));
ffffffffc0204a1e:	00097c17          	auipc	s8,0x97
ffffffffc0204a22:	c6ac0c13          	addi	s8,s8,-918 # ffffffffc029b688 <npage>
ffffffffc0204a26:	fcd6                	sd	s5,120(sp)
    return page - pages + nbase;
ffffffffc0204a28:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204a2a:	5afd                	li	s5,-1
ffffffffc0204a2c:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204a30:	96da                	add	a3,a3,s6
    return KADDR(page2pa(page));
ffffffffc0204a32:	00cad713          	srli	a4,s5,0xc
ffffffffc0204a36:	e83a                	sd	a4,16(sp)
ffffffffc0204a38:	e152                	sd	s4,128(sp)
ffffffffc0204a3a:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204a3c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204a3e:	3ef77863          	bgeu	a4,a5,ffffffffc0204e2e <do_execve+0x4c2>
ffffffffc0204a42:	00097a17          	auipc	s4,0x97
ffffffffc0204a46:	c3ea0a13          	addi	s4,s4,-962 # ffffffffc029b680 <va_pa_offset>
ffffffffc0204a4a:	000a3783          	ld	a5,0(s4)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204a4e:	00097597          	auipc	a1,0x97
ffffffffc0204a52:	c2a5b583          	ld	a1,-982(a1) # ffffffffc029b678 <boot_pgdir_va>
ffffffffc0204a56:	6605                	lui	a2,0x1
ffffffffc0204a58:	00f68433          	add	s0,a3,a5
ffffffffc0204a5c:	8522                	mv	a0,s0
ffffffffc0204a5e:	61b000ef          	jal	ffffffffc0205878 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204a62:	66e2                	ld	a3,24(sp)
ffffffffc0204a64:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204a68:	ec80                	sd	s0,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204a6a:	4298                	lw	a4,0(a3)
ffffffffc0204a6c:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464ba3bf>
ffffffffc0204a70:	06f70863          	beq	a4,a5,ffffffffc0204ae0 <do_execve+0x174>
        ret = -E_INVAL_ELF;
ffffffffc0204a74:	5461                	li	s0,-8
    put_pgdir(mm);
ffffffffc0204a76:	8526                	mv	a0,s1
ffffffffc0204a78:	d3cff0ef          	jal	ffffffffc0203fb4 <put_pgdir>
ffffffffc0204a7c:	6a0a                	ld	s4,128(sp)
ffffffffc0204a7e:	7ae6                	ld	s5,120(sp)
ffffffffc0204a80:	7b46                	ld	s6,112(sp)
ffffffffc0204a82:	7ba6                	ld	s7,104(sp)
ffffffffc0204a84:	7c06                	ld	s8,96(sp)
    mm_destroy(mm);
ffffffffc0204a86:	8526                	mv	a0,s1
ffffffffc0204a88:	e35fe0ef          	jal	ffffffffc02038bc <mm_destroy>
    do_exit(ret);
ffffffffc0204a8c:	8522                	mv	a0,s0
ffffffffc0204a8e:	e54e                	sd	s3,136(sp)
ffffffffc0204a90:	e152                	sd	s4,128(sp)
ffffffffc0204a92:	fcd6                	sd	s5,120(sp)
ffffffffc0204a94:	f8da                	sd	s6,112(sp)
ffffffffc0204a96:	f4de                	sd	s7,104(sp)
ffffffffc0204a98:	f0e2                	sd	s8,96(sp)
ffffffffc0204a9a:	ece6                	sd	s9,88(sp)
ffffffffc0204a9c:	e4ee                	sd	s11,72(sp)
ffffffffc0204a9e:	a85ff0ef          	jal	ffffffffc0204522 <do_exit>
    if (len > PROC_NAME_LEN)
ffffffffc0204aa2:	863e                	mv	a2,a5
    memcpy(local_name, name, len);
ffffffffc0204aa4:	85ca                	mv	a1,s2
ffffffffc0204aa6:	1808                	addi	a0,sp,48
ffffffffc0204aa8:	5d1000ef          	jal	ffffffffc0205878 <memcpy>
    if (mm != NULL)
ffffffffc0204aac:	f00497e3          	bnez	s1,ffffffffc02049ba <do_execve+0x4e>
    if (current->mm != NULL)
ffffffffc0204ab0:	000d3783          	ld	a5,0(s10)
ffffffffc0204ab4:	779c                	ld	a5,40(a5)
ffffffffc0204ab6:	db9d                	beqz	a5,ffffffffc02049ec <do_execve+0x80>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204ab8:	00002617          	auipc	a2,0x2
ffffffffc0204abc:	77860613          	addi	a2,a2,1912 # ffffffffc0207230 <etext+0x19a0>
ffffffffc0204ac0:	23a00593          	li	a1,570
ffffffffc0204ac4:	00002517          	auipc	a0,0x2
ffffffffc0204ac8:	58450513          	addi	a0,a0,1412 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0204acc:	e54e                	sd	s3,136(sp)
ffffffffc0204ace:	e152                	sd	s4,128(sp)
ffffffffc0204ad0:	fcd6                	sd	s5,120(sp)
ffffffffc0204ad2:	f8da                	sd	s6,112(sp)
ffffffffc0204ad4:	f4de                	sd	s7,104(sp)
ffffffffc0204ad6:	f0e2                	sd	s8,96(sp)
ffffffffc0204ad8:	ece6                	sd	s9,88(sp)
ffffffffc0204ada:	e4ee                	sd	s11,72(sp)
ffffffffc0204adc:	96bfb0ef          	jal	ffffffffc0200446 <__panic>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204ae0:	0386d703          	lhu	a4,56(a3)
ffffffffc0204ae4:	e54e                	sd	s3,136(sp)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204ae6:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204aea:	00371793          	slli	a5,a4,0x3
ffffffffc0204aee:	8f99                	sub	a5,a5,a4
ffffffffc0204af0:	078e                	slli	a5,a5,0x3
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204af2:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204af4:	97ce                	add	a5,a5,s3
ffffffffc0204af6:	ece6                	sd	s9,88(sp)
ffffffffc0204af8:	f43e                	sd	a5,40(sp)
    struct Page *page = NULL;
ffffffffc0204afa:	4c81                	li	s9,0
    for (; ph < ph_end; ph++)
ffffffffc0204afc:	00f9fe63          	bgeu	s3,a5,ffffffffc0204b18 <do_execve+0x1ac>
ffffffffc0204b00:	e4ee                	sd	s11,72(sp)
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204b02:	0009a783          	lw	a5,0(s3)
ffffffffc0204b06:	4705                	li	a4,1
ffffffffc0204b08:	0ee78f63          	beq	a5,a4,ffffffffc0204c06 <do_execve+0x29a>
    for (; ph < ph_end; ph++)
ffffffffc0204b0c:	77a2                	ld	a5,40(sp)
ffffffffc0204b0e:	03898993          	addi	s3,s3,56
ffffffffc0204b12:	fef9e8e3          	bltu	s3,a5,ffffffffc0204b02 <do_execve+0x196>
ffffffffc0204b16:	6da6                	ld	s11,72(sp)
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204b18:	4701                	li	a4,0
ffffffffc0204b1a:	46ad                	li	a3,11
ffffffffc0204b1c:	00100637          	lui	a2,0x100
ffffffffc0204b20:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204b24:	8526                	mv	a0,s1
ffffffffc0204b26:	de9fe0ef          	jal	ffffffffc020390e <mm_map>
ffffffffc0204b2a:	842a                	mv	s0,a0
ffffffffc0204b2c:	1a051063          	bnez	a0,ffffffffc0204ccc <do_execve+0x360>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204b30:	6c88                	ld	a0,24(s1)
ffffffffc0204b32:	467d                	li	a2,31
ffffffffc0204b34:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204b38:	b0ffe0ef          	jal	ffffffffc0203646 <pgdir_alloc_page>
ffffffffc0204b3c:	38050863          	beqz	a0,ffffffffc0204ecc <do_execve+0x560>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b40:	6c88                	ld	a0,24(s1)
ffffffffc0204b42:	467d                	li	a2,31
ffffffffc0204b44:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204b48:	afffe0ef          	jal	ffffffffc0203646 <pgdir_alloc_page>
ffffffffc0204b4c:	34050f63          	beqz	a0,ffffffffc0204eaa <do_execve+0x53e>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b50:	6c88                	ld	a0,24(s1)
ffffffffc0204b52:	467d                	li	a2,31
ffffffffc0204b54:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204b58:	aeffe0ef          	jal	ffffffffc0203646 <pgdir_alloc_page>
ffffffffc0204b5c:	32050663          	beqz	a0,ffffffffc0204e88 <do_execve+0x51c>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b60:	6c88                	ld	a0,24(s1)
ffffffffc0204b62:	467d                	li	a2,31
ffffffffc0204b64:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204b68:	adffe0ef          	jal	ffffffffc0203646 <pgdir_alloc_page>
ffffffffc0204b6c:	2e050d63          	beqz	a0,ffffffffc0204e66 <do_execve+0x4fa>
    mm->mm_count += 1;
ffffffffc0204b70:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204b72:	000d3603          	ld	a2,0(s10)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204b76:	6c94                	ld	a3,24(s1)
ffffffffc0204b78:	2785                	addiw	a5,a5,1
ffffffffc0204b7a:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0204b7c:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204b7e:	c02007b7          	lui	a5,0xc0200
ffffffffc0204b82:	2cf6e563          	bltu	a3,a5,ffffffffc0204e4c <do_execve+0x4e0>
ffffffffc0204b86:	000a3783          	ld	a5,0(s4)
ffffffffc0204b8a:	577d                	li	a4,-1
ffffffffc0204b8c:	177e                	slli	a4,a4,0x3f
ffffffffc0204b8e:	8e9d                	sub	a3,a3,a5
ffffffffc0204b90:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204b94:	f654                	sd	a3,168(a2)
ffffffffc0204b96:	8fd9                	or	a5,a5,a4
ffffffffc0204b98:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204b9c:	7244                	ld	s1,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204b9e:	4581                	li	a1,0
ffffffffc0204ba0:	12000613          	li	a2,288
ffffffffc0204ba4:	8526                	mv	a0,s1
    uintptr_t sstatus = tf->status;
ffffffffc0204ba6:	1004b903          	ld	s2,256(s1)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204baa:	4bd000ef          	jal	ffffffffc0205866 <memset>
    tf->epc = elf->e_entry;
ffffffffc0204bae:	67e2                	ld	a5,24(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204bb0:	000d3983          	ld	s3,0(s10)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204bb4:	edf97913          	andi	s2,s2,-289
    tf->epc = elf->e_entry;
ffffffffc0204bb8:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204bba:	4785                	li	a5,1
ffffffffc0204bbc:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204bbe:	02096913          	ori	s2,s2,32
    tf->epc = elf->e_entry;
ffffffffc0204bc2:	10e4b423          	sd	a4,264(s1)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204bc6:	e89c                	sd	a5,16(s1)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204bc8:	0b498513          	addi	a0,s3,180
ffffffffc0204bcc:	4641                	li	a2,16
ffffffffc0204bce:	4581                	li	a1,0
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204bd0:	1124b023          	sd	s2,256(s1)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204bd4:	493000ef          	jal	ffffffffc0205866 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204bd8:	0b498513          	addi	a0,s3,180
ffffffffc0204bdc:	180c                	addi	a1,sp,48
ffffffffc0204bde:	463d                	li	a2,15
ffffffffc0204be0:	499000ef          	jal	ffffffffc0205878 <memcpy>
ffffffffc0204be4:	69aa                	ld	s3,136(sp)
ffffffffc0204be6:	6a0a                	ld	s4,128(sp)
ffffffffc0204be8:	7ae6                	ld	s5,120(sp)
ffffffffc0204bea:	7b46                	ld	s6,112(sp)
ffffffffc0204bec:	7ba6                	ld	s7,104(sp)
ffffffffc0204bee:	7c06                	ld	s8,96(sp)
ffffffffc0204bf0:	6ce6                	ld	s9,88(sp)
}
ffffffffc0204bf2:	70aa                	ld	ra,168(sp)
ffffffffc0204bf4:	8522                	mv	a0,s0
ffffffffc0204bf6:	740a                	ld	s0,160(sp)
ffffffffc0204bf8:	64ea                	ld	s1,152(sp)
ffffffffc0204bfa:	694a                	ld	s2,144(sp)
ffffffffc0204bfc:	6d46                	ld	s10,80(sp)
ffffffffc0204bfe:	614d                	addi	sp,sp,176
ffffffffc0204c00:	8082                	ret
    int ret = -E_NO_MEM;
ffffffffc0204c02:	5471                	li	s0,-4
ffffffffc0204c04:	b561                	j	ffffffffc0204a8c <do_execve+0x120>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204c06:	0289b603          	ld	a2,40(s3)
ffffffffc0204c0a:	0209b783          	ld	a5,32(s3)
ffffffffc0204c0e:	20f66163          	bltu	a2,a5,ffffffffc0204e10 <do_execve+0x4a4>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204c12:	0049a783          	lw	a5,4(s3)
ffffffffc0204c16:	0027971b          	slliw	a4,a5,0x2
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204c1a:	0027f693          	andi	a3,a5,2
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204c1e:	8b11                	andi	a4,a4,4
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204c20:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204c22:	c6e9                	beqz	a3,ffffffffc0204cec <do_execve+0x380>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204c24:	1c079563          	bnez	a5,ffffffffc0204dee <do_execve+0x482>
            perm |= (PTE_W | PTE_R);
ffffffffc0204c28:	47dd                	li	a5,23
            vm_flags |= VM_WRITE;
ffffffffc0204c2a:	00276693          	ori	a3,a4,2
            perm |= (PTE_W | PTE_R);
ffffffffc0204c2e:	e43e                	sd	a5,8(sp)
        if (vm_flags & VM_EXEC)
ffffffffc0204c30:	c709                	beqz	a4,ffffffffc0204c3a <do_execve+0x2ce>
            perm |= PTE_X;
ffffffffc0204c32:	67a2                	ld	a5,8(sp)
ffffffffc0204c34:	0087e793          	ori	a5,a5,8
ffffffffc0204c38:	e43e                	sd	a5,8(sp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204c3a:	0109b583          	ld	a1,16(s3)
ffffffffc0204c3e:	4701                	li	a4,0
ffffffffc0204c40:	8526                	mv	a0,s1
ffffffffc0204c42:	ccdfe0ef          	jal	ffffffffc020390e <mm_map>
ffffffffc0204c46:	842a                	mv	s0,a0
ffffffffc0204c48:	1c051263          	bnez	a0,ffffffffc0204e0c <do_execve+0x4a0>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204c4c:	0109ba83          	ld	s5,16(s3)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204c50:	0209b403          	ld	s0,32(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204c54:	77fd                	lui	a5,0xfffff
ffffffffc0204c56:	00faf5b3          	and	a1,s5,a5
        end = ph->p_va + ph->p_filesz;
ffffffffc0204c5a:	9456                	add	s0,s0,s5
        while (start < end)
ffffffffc0204c5c:	1a8af363          	bgeu	s5,s0,ffffffffc0204e02 <do_execve+0x496>
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204c60:	0089b903          	ld	s2,8(s3)
ffffffffc0204c64:	67e2                	ld	a5,24(sp)
ffffffffc0204c66:	993e                	add	s2,s2,a5
ffffffffc0204c68:	a881                	j	ffffffffc0204cb8 <do_execve+0x34c>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204c6a:	6785                	lui	a5,0x1
ffffffffc0204c6c:	00f58db3          	add	s11,a1,a5
                size -= la - end;
ffffffffc0204c70:	41540633          	sub	a2,s0,s5
            if (end < la)
ffffffffc0204c74:	01b46463          	bltu	s0,s11,ffffffffc0204c7c <do_execve+0x310>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204c78:	415d8633          	sub	a2,s11,s5
    return page - pages + nbase;
ffffffffc0204c7c:	000bb683          	ld	a3,0(s7)
    return KADDR(page2pa(page));
ffffffffc0204c80:	67c2                	ld	a5,16(sp)
ffffffffc0204c82:	000c3503          	ld	a0,0(s8)
    return page - pages + nbase;
ffffffffc0204c86:	40dc86b3          	sub	a3,s9,a3
ffffffffc0204c8a:	8699                	srai	a3,a3,0x6
ffffffffc0204c8c:	96da                	add	a3,a3,s6
    return KADDR(page2pa(page));
ffffffffc0204c8e:	00f6f8b3          	and	a7,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c92:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c94:	18a8f163          	bgeu	a7,a0,ffffffffc0204e16 <do_execve+0x4aa>
ffffffffc0204c98:	000a3503          	ld	a0,0(s4)
ffffffffc0204c9c:	40ba85b3          	sub	a1,s5,a1
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204ca0:	e032                	sd	a2,0(sp)
ffffffffc0204ca2:	9536                	add	a0,a0,a3
ffffffffc0204ca4:	952e                	add	a0,a0,a1
ffffffffc0204ca6:	85ca                	mv	a1,s2
ffffffffc0204ca8:	3d1000ef          	jal	ffffffffc0205878 <memcpy>
            start += size, from += size;
ffffffffc0204cac:	6602                	ld	a2,0(sp)
ffffffffc0204cae:	9ab2                	add	s5,s5,a2
ffffffffc0204cb0:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204cb2:	048af463          	bgeu	s5,s0,ffffffffc0204cfa <do_execve+0x38e>
ffffffffc0204cb6:	85ee                	mv	a1,s11
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204cb8:	6c88                	ld	a0,24(s1)
ffffffffc0204cba:	6622                	ld	a2,8(sp)
ffffffffc0204cbc:	e02e                	sd	a1,0(sp)
ffffffffc0204cbe:	989fe0ef          	jal	ffffffffc0203646 <pgdir_alloc_page>
ffffffffc0204cc2:	6582                	ld	a1,0(sp)
ffffffffc0204cc4:	8caa                	mv	s9,a0
ffffffffc0204cc6:	f155                	bnez	a0,ffffffffc0204c6a <do_execve+0x2fe>
ffffffffc0204cc8:	6da6                	ld	s11,72(sp)
        ret = -E_NO_MEM;
ffffffffc0204cca:	5471                	li	s0,-4
    exit_mmap(mm);
ffffffffc0204ccc:	8526                	mv	a0,s1
ffffffffc0204cce:	da5fe0ef          	jal	ffffffffc0203a72 <exit_mmap>
ffffffffc0204cd2:	69aa                	ld	s3,136(sp)
ffffffffc0204cd4:	6ce6                	ld	s9,88(sp)
ffffffffc0204cd6:	b345                	j	ffffffffc0204a76 <do_execve+0x10a>
            exit_mmap(mm);
ffffffffc0204cd8:	8526                	mv	a0,s1
ffffffffc0204cda:	d99fe0ef          	jal	ffffffffc0203a72 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204cde:	8526                	mv	a0,s1
ffffffffc0204ce0:	ad4ff0ef          	jal	ffffffffc0203fb4 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204ce4:	8526                	mv	a0,s1
ffffffffc0204ce6:	bd7fe0ef          	jal	ffffffffc02038bc <mm_destroy>
ffffffffc0204cea:	b9ed                	j	ffffffffc02049e4 <do_execve+0x78>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204cec:	0e078d63          	beqz	a5,ffffffffc0204de6 <do_execve+0x47a>
            perm |= PTE_R;
ffffffffc0204cf0:	47cd                	li	a5,19
            vm_flags |= VM_READ;
ffffffffc0204cf2:	00176693          	ori	a3,a4,1
            perm |= PTE_R;
ffffffffc0204cf6:	e43e                	sd	a5,8(sp)
ffffffffc0204cf8:	bf25                	j	ffffffffc0204c30 <do_execve+0x2c4>
        end = ph->p_memsz + ph->p_va;
ffffffffc0204cfa:	0109b403          	ld	s0,16(s3)
ffffffffc0204cfe:	0289b683          	ld	a3,40(s3)
ffffffffc0204d02:	9436                	add	s0,s0,a3
        if (start < la) {
ffffffffc0204d04:	07bafc63          	bgeu	s5,s11,ffffffffc0204d7c <do_execve+0x410>
            if (start == end) {
ffffffffc0204d08:	e15402e3          	beq	s0,s5,ffffffffc0204b0c <do_execve+0x1a0>
                size -= la - end;
ffffffffc0204d0c:	41540933          	sub	s2,s0,s5
            if (end < la) {
ffffffffc0204d10:	0fb47463          	bgeu	s0,s11,ffffffffc0204df8 <do_execve+0x48c>
    return page - pages + nbase;
ffffffffc0204d14:	000bb683          	ld	a3,0(s7)
    return KADDR(page2pa(page));
ffffffffc0204d18:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204d1c:	40dc86b3          	sub	a3,s9,a3
ffffffffc0204d20:	8699                	srai	a3,a3,0x6
ffffffffc0204d22:	96da                	add	a3,a3,s6
    return KADDR(page2pa(page));
ffffffffc0204d24:	00c69613          	slli	a2,a3,0xc
ffffffffc0204d28:	8231                	srli	a2,a2,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0204d2a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204d2c:	0eb67563          	bgeu	a2,a1,ffffffffc0204e16 <do_execve+0x4aa>
ffffffffc0204d30:	000a3603          	ld	a2,0(s4)
            off = start - (la - PGSIZE);
ffffffffc0204d34:	6505                	lui	a0,0x1
ffffffffc0204d36:	9556                	add	a0,a0,s5
ffffffffc0204d38:	96b2                	add	a3,a3,a2
ffffffffc0204d3a:	41b50533          	sub	a0,a0,s11
            memset(page2kva(page) + off, 0, size);
ffffffffc0204d3e:	9536                	add	a0,a0,a3
ffffffffc0204d40:	864a                	mv	a2,s2
ffffffffc0204d42:	4581                	li	a1,0
ffffffffc0204d44:	323000ef          	jal	ffffffffc0205866 <memset>
            start += size;
ffffffffc0204d48:	9aca                	add	s5,s5,s2
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204d4a:	01b436b3          	sltu	a3,s0,s11
ffffffffc0204d4e:	01b47463          	bgeu	s0,s11,ffffffffc0204d56 <do_execve+0x3ea>
ffffffffc0204d52:	db540de3          	beq	s0,s5,ffffffffc0204b0c <do_execve+0x1a0>
ffffffffc0204d56:	e299                	bnez	a3,ffffffffc0204d5c <do_execve+0x3f0>
ffffffffc0204d58:	03ba8263          	beq	s5,s11,ffffffffc0204d7c <do_execve+0x410>
ffffffffc0204d5c:	00002697          	auipc	a3,0x2
ffffffffc0204d60:	4fc68693          	addi	a3,a3,1276 # ffffffffc0207258 <etext+0x19c8>
ffffffffc0204d64:	00001617          	auipc	a2,0x1
ffffffffc0204d68:	4fc60613          	addi	a2,a2,1276 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0204d6c:	2a100593          	li	a1,673
ffffffffc0204d70:	00002517          	auipc	a0,0x2
ffffffffc0204d74:	2d850513          	addi	a0,a0,728 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0204d78:	ecefb0ef          	jal	ffffffffc0200446 <__panic>
        while (start < end) {
ffffffffc0204d7c:	d88af8e3          	bgeu	s5,s0,ffffffffc0204b0c <do_execve+0x1a0>
ffffffffc0204d80:	56fd                	li	a3,-1
ffffffffc0204d82:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204d86:	f03e                	sd	a5,32(sp)
ffffffffc0204d88:	a0b9                	j	ffffffffc0204dd6 <do_execve+0x46a>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204d8a:	6785                	lui	a5,0x1
ffffffffc0204d8c:	00fd88b3          	add	a7,s11,a5
                size -= la - end;
ffffffffc0204d90:	41540933          	sub	s2,s0,s5
            if (end < la) {
ffffffffc0204d94:	01146463          	bltu	s0,a7,ffffffffc0204d9c <do_execve+0x430>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204d98:	41588933          	sub	s2,a7,s5
    return page - pages + nbase;
ffffffffc0204d9c:	000bb683          	ld	a3,0(s7)
    return KADDR(page2pa(page));
ffffffffc0204da0:	7782                	ld	a5,32(sp)
ffffffffc0204da2:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204da6:	40dc86b3          	sub	a3,s9,a3
ffffffffc0204daa:	8699                	srai	a3,a3,0x6
ffffffffc0204dac:	96da                	add	a3,a3,s6
    return KADDR(page2pa(page));
ffffffffc0204dae:	00f6f533          	and	a0,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204db2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204db4:	06b57163          	bgeu	a0,a1,ffffffffc0204e16 <do_execve+0x4aa>
ffffffffc0204db8:	000a3583          	ld	a1,0(s4)
ffffffffc0204dbc:	41ba8533          	sub	a0,s5,s11
            memset(page2kva(page) + off, 0, size);
ffffffffc0204dc0:	864a                	mv	a2,s2
ffffffffc0204dc2:	96ae                	add	a3,a3,a1
ffffffffc0204dc4:	9536                	add	a0,a0,a3
ffffffffc0204dc6:	4581                	li	a1,0
            start += size;
ffffffffc0204dc8:	9aca                	add	s5,s5,s2
ffffffffc0204dca:	e046                	sd	a7,0(sp)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204dcc:	29b000ef          	jal	ffffffffc0205866 <memset>
        while (start < end) {
ffffffffc0204dd0:	d28afee3          	bgeu	s5,s0,ffffffffc0204b0c <do_execve+0x1a0>
ffffffffc0204dd4:	6d82                	ld	s11,0(sp)
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
ffffffffc0204dd6:	6c88                	ld	a0,24(s1)
ffffffffc0204dd8:	6622                	ld	a2,8(sp)
ffffffffc0204dda:	85ee                	mv	a1,s11
ffffffffc0204ddc:	86bfe0ef          	jal	ffffffffc0203646 <pgdir_alloc_page>
ffffffffc0204de0:	8caa                	mv	s9,a0
ffffffffc0204de2:	f545                	bnez	a0,ffffffffc0204d8a <do_execve+0x41e>
ffffffffc0204de4:	b5d5                	j	ffffffffc0204cc8 <do_execve+0x35c>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204de6:	47c5                	li	a5,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204de8:	86ba                	mv	a3,a4
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204dea:	e43e                	sd	a5,8(sp)
ffffffffc0204dec:	b591                	j	ffffffffc0204c30 <do_execve+0x2c4>
            perm |= (PTE_W | PTE_R);
ffffffffc0204dee:	47dd                	li	a5,23
            vm_flags |= VM_READ;
ffffffffc0204df0:	00376693          	ori	a3,a4,3
            perm |= (PTE_W | PTE_R);
ffffffffc0204df4:	e43e                	sd	a5,8(sp)
ffffffffc0204df6:	bd2d                	j	ffffffffc0204c30 <do_execve+0x2c4>
            size = la - start;
ffffffffc0204df8:	415d8933          	sub	s2,s11,s5
ffffffffc0204dfc:	bf21                	j	ffffffffc0204d14 <do_execve+0x3a8>
        return -E_INVAL;
ffffffffc0204dfe:	5475                	li	s0,-3
ffffffffc0204e00:	bbcd                	j	ffffffffc0204bf2 <do_execve+0x286>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204e02:	8dae                	mv	s11,a1
        while (start < end)
ffffffffc0204e04:	8456                	mv	s0,s5
ffffffffc0204e06:	bde5                	j	ffffffffc0204cfe <do_execve+0x392>
    int ret = -E_NO_MEM;
ffffffffc0204e08:	5471                	li	s0,-4
ffffffffc0204e0a:	b9b5                	j	ffffffffc0204a86 <do_execve+0x11a>
ffffffffc0204e0c:	6da6                	ld	s11,72(sp)
ffffffffc0204e0e:	bd7d                	j	ffffffffc0204ccc <do_execve+0x360>
            ret = -E_INVAL_ELF;
ffffffffc0204e10:	6da6                	ld	s11,72(sp)
ffffffffc0204e12:	5461                	li	s0,-8
ffffffffc0204e14:	bd65                	j	ffffffffc0204ccc <do_execve+0x360>
ffffffffc0204e16:	00001617          	auipc	a2,0x1
ffffffffc0204e1a:	7fa60613          	addi	a2,a2,2042 # ffffffffc0206610 <etext+0xd80>
ffffffffc0204e1e:	07100593          	li	a1,113
ffffffffc0204e22:	00002517          	auipc	a0,0x2
ffffffffc0204e26:	81650513          	addi	a0,a0,-2026 # ffffffffc0206638 <etext+0xda8>
ffffffffc0204e2a:	e1cfb0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0204e2e:	00001617          	auipc	a2,0x1
ffffffffc0204e32:	7e260613          	addi	a2,a2,2018 # ffffffffc0206610 <etext+0xd80>
ffffffffc0204e36:	07100593          	li	a1,113
ffffffffc0204e3a:	00001517          	auipc	a0,0x1
ffffffffc0204e3e:	7fe50513          	addi	a0,a0,2046 # ffffffffc0206638 <etext+0xda8>
ffffffffc0204e42:	e54e                	sd	s3,136(sp)
ffffffffc0204e44:	ece6                	sd	s9,88(sp)
ffffffffc0204e46:	e4ee                	sd	s11,72(sp)
ffffffffc0204e48:	dfefb0ef          	jal	ffffffffc0200446 <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204e4c:	00002617          	auipc	a2,0x2
ffffffffc0204e50:	86c60613          	addi	a2,a2,-1940 # ffffffffc02066b8 <etext+0xe28>
ffffffffc0204e54:	2bd00593          	li	a1,701
ffffffffc0204e58:	00002517          	auipc	a0,0x2
ffffffffc0204e5c:	1f050513          	addi	a0,a0,496 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0204e60:	e4ee                	sd	s11,72(sp)
ffffffffc0204e62:	de4fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204e66:	00002697          	auipc	a3,0x2
ffffffffc0204e6a:	50a68693          	addi	a3,a3,1290 # ffffffffc0207370 <etext+0x1ae0>
ffffffffc0204e6e:	00001617          	auipc	a2,0x1
ffffffffc0204e72:	3f260613          	addi	a2,a2,1010 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0204e76:	2b800593          	li	a1,696
ffffffffc0204e7a:	00002517          	auipc	a0,0x2
ffffffffc0204e7e:	1ce50513          	addi	a0,a0,462 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0204e82:	e4ee                	sd	s11,72(sp)
ffffffffc0204e84:	dc2fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204e88:	00002697          	auipc	a3,0x2
ffffffffc0204e8c:	4a068693          	addi	a3,a3,1184 # ffffffffc0207328 <etext+0x1a98>
ffffffffc0204e90:	00001617          	auipc	a2,0x1
ffffffffc0204e94:	3d060613          	addi	a2,a2,976 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0204e98:	2b700593          	li	a1,695
ffffffffc0204e9c:	00002517          	auipc	a0,0x2
ffffffffc0204ea0:	1ac50513          	addi	a0,a0,428 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0204ea4:	e4ee                	sd	s11,72(sp)
ffffffffc0204ea6:	da0fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204eaa:	00002697          	auipc	a3,0x2
ffffffffc0204eae:	43668693          	addi	a3,a3,1078 # ffffffffc02072e0 <etext+0x1a50>
ffffffffc0204eb2:	00001617          	auipc	a2,0x1
ffffffffc0204eb6:	3ae60613          	addi	a2,a2,942 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0204eba:	2b600593          	li	a1,694
ffffffffc0204ebe:	00002517          	auipc	a0,0x2
ffffffffc0204ec2:	18a50513          	addi	a0,a0,394 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0204ec6:	e4ee                	sd	s11,72(sp)
ffffffffc0204ec8:	d7efb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204ecc:	00002697          	auipc	a3,0x2
ffffffffc0204ed0:	3cc68693          	addi	a3,a3,972 # ffffffffc0207298 <etext+0x1a08>
ffffffffc0204ed4:	00001617          	auipc	a2,0x1
ffffffffc0204ed8:	38c60613          	addi	a2,a2,908 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0204edc:	2b500593          	li	a1,693
ffffffffc0204ee0:	00002517          	auipc	a0,0x2
ffffffffc0204ee4:	16850513          	addi	a0,a0,360 # ffffffffc0207048 <etext+0x17b8>
ffffffffc0204ee8:	e4ee                	sd	s11,72(sp)
ffffffffc0204eea:	d5cfb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0204eee <do_yield>:
    current->need_resched = 1;
ffffffffc0204eee:	00096797          	auipc	a5,0x96
ffffffffc0204ef2:	7b27b783          	ld	a5,1970(a5) # ffffffffc029b6a0 <current>
ffffffffc0204ef6:	4705                	li	a4,1
}
ffffffffc0204ef8:	4501                	li	a0,0
    current->need_resched = 1;
ffffffffc0204efa:	ef98                	sd	a4,24(a5)
}
ffffffffc0204efc:	8082                	ret

ffffffffc0204efe <do_wait>:
    if (code_store != NULL)
ffffffffc0204efe:	c59d                	beqz	a1,ffffffffc0204f2c <do_wait+0x2e>
{
ffffffffc0204f00:	1101                	addi	sp,sp,-32
ffffffffc0204f02:	e02a                	sd	a0,0(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204f04:	00096517          	auipc	a0,0x96
ffffffffc0204f08:	79c53503          	ld	a0,1948(a0) # ffffffffc029b6a0 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204f0c:	4685                	li	a3,1
ffffffffc0204f0e:	4611                	li	a2,4
ffffffffc0204f10:	7508                	ld	a0,40(a0)
{
ffffffffc0204f12:	ec06                	sd	ra,24(sp)
ffffffffc0204f14:	e42e                	sd	a1,8(sp)
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204f16:	ef5fe0ef          	jal	ffffffffc0203e0a <user_mem_check>
ffffffffc0204f1a:	6702                	ld	a4,0(sp)
ffffffffc0204f1c:	67a2                	ld	a5,8(sp)
ffffffffc0204f1e:	c909                	beqz	a0,ffffffffc0204f30 <do_wait+0x32>
}
ffffffffc0204f20:	60e2                	ld	ra,24(sp)
ffffffffc0204f22:	85be                	mv	a1,a5
ffffffffc0204f24:	853a                	mv	a0,a4
ffffffffc0204f26:	6105                	addi	sp,sp,32
ffffffffc0204f28:	f3eff06f          	j	ffffffffc0204666 <do_wait.part.0>
ffffffffc0204f2c:	f3aff06f          	j	ffffffffc0204666 <do_wait.part.0>
ffffffffc0204f30:	60e2                	ld	ra,24(sp)
ffffffffc0204f32:	5575                	li	a0,-3
ffffffffc0204f34:	6105                	addi	sp,sp,32
ffffffffc0204f36:	8082                	ret

ffffffffc0204f38 <do_kill>:
    if (0 < pid && pid < MAX_PID)
ffffffffc0204f38:	6789                	lui	a5,0x2
ffffffffc0204f3a:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204f3e:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6bca>
ffffffffc0204f40:	06e7e463          	bltu	a5,a4,ffffffffc0204fa8 <do_kill+0x70>
{
ffffffffc0204f44:	1101                	addi	sp,sp,-32
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204f46:	45a9                	li	a1,10
{
ffffffffc0204f48:	ec06                	sd	ra,24(sp)
ffffffffc0204f4a:	e42a                	sd	a0,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204f4c:	484000ef          	jal	ffffffffc02053d0 <hash32>
ffffffffc0204f50:	02051793          	slli	a5,a0,0x20
ffffffffc0204f54:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204f58:	00092797          	auipc	a5,0x92
ffffffffc0204f5c:	6d078793          	addi	a5,a5,1744 # ffffffffc0297628 <hash_list>
ffffffffc0204f60:	96be                	add	a3,a3,a5
        while ((le = list_next(le)) != list)
ffffffffc0204f62:	6622                	ld	a2,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204f64:	8536                	mv	a0,a3
        while ((le = list_next(le)) != list)
ffffffffc0204f66:	a029                	j	ffffffffc0204f70 <do_kill+0x38>
            if (proc->pid == pid)
ffffffffc0204f68:	f2c52703          	lw	a4,-212(a0)
ffffffffc0204f6c:	00c70963          	beq	a4,a2,ffffffffc0204f7e <do_kill+0x46>
ffffffffc0204f70:	6508                	ld	a0,8(a0)
        while ((le = list_next(le)) != list)
ffffffffc0204f72:	fea69be3          	bne	a3,a0,ffffffffc0204f68 <do_kill+0x30>
}
ffffffffc0204f76:	60e2                	ld	ra,24(sp)
    return -E_INVAL;
ffffffffc0204f78:	5575                	li	a0,-3
}
ffffffffc0204f7a:	6105                	addi	sp,sp,32
ffffffffc0204f7c:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204f7e:	fd852703          	lw	a4,-40(a0)
ffffffffc0204f82:	00177693          	andi	a3,a4,1
ffffffffc0204f86:	e29d                	bnez	a3,ffffffffc0204fac <do_kill+0x74>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204f88:	4954                	lw	a3,20(a0)
            proc->flags |= PF_EXITING;
ffffffffc0204f8a:	00176713          	ori	a4,a4,1
ffffffffc0204f8e:	fce52c23          	sw	a4,-40(a0)
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204f92:	0006c663          	bltz	a3,ffffffffc0204f9e <do_kill+0x66>
            return 0;
ffffffffc0204f96:	4501                	li	a0,0
}
ffffffffc0204f98:	60e2                	ld	ra,24(sp)
ffffffffc0204f9a:	6105                	addi	sp,sp,32
ffffffffc0204f9c:	8082                	ret
                wakeup_proc(proc);
ffffffffc0204f9e:	f2850513          	addi	a0,a0,-216
ffffffffc0204fa2:	232000ef          	jal	ffffffffc02051d4 <wakeup_proc>
ffffffffc0204fa6:	bfc5                	j	ffffffffc0204f96 <do_kill+0x5e>
    return -E_INVAL;
ffffffffc0204fa8:	5575                	li	a0,-3
}
ffffffffc0204faa:	8082                	ret
        return -E_KILLED;
ffffffffc0204fac:	555d                	li	a0,-9
ffffffffc0204fae:	b7ed                	j	ffffffffc0204f98 <do_kill+0x60>

ffffffffc0204fb0 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204fb0:	1101                	addi	sp,sp,-32
ffffffffc0204fb2:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204fb4:	00096797          	auipc	a5,0x96
ffffffffc0204fb8:	67478793          	addi	a5,a5,1652 # ffffffffc029b628 <proc_list>
ffffffffc0204fbc:	ec06                	sd	ra,24(sp)
ffffffffc0204fbe:	e822                	sd	s0,16(sp)
ffffffffc0204fc0:	e04a                	sd	s2,0(sp)
ffffffffc0204fc2:	00092497          	auipc	s1,0x92
ffffffffc0204fc6:	66648493          	addi	s1,s1,1638 # ffffffffc0297628 <hash_list>
ffffffffc0204fca:	e79c                	sd	a5,8(a5)
ffffffffc0204fcc:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204fce:	00096717          	auipc	a4,0x96
ffffffffc0204fd2:	65a70713          	addi	a4,a4,1626 # ffffffffc029b628 <proc_list>
ffffffffc0204fd6:	87a6                	mv	a5,s1
ffffffffc0204fd8:	e79c                	sd	a5,8(a5)
ffffffffc0204fda:	e39c                	sd	a5,0(a5)
ffffffffc0204fdc:	07c1                	addi	a5,a5,16
ffffffffc0204fde:	fee79de3          	bne	a5,a4,ffffffffc0204fd8 <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0204fe2:	ed5fe0ef          	jal	ffffffffc0203eb6 <alloc_proc>
ffffffffc0204fe6:	00096917          	auipc	s2,0x96
ffffffffc0204fea:	6ca90913          	addi	s2,s2,1738 # ffffffffc029b6b0 <idleproc>
ffffffffc0204fee:	00a93023          	sd	a0,0(s2)
ffffffffc0204ff2:	10050363          	beqz	a0,ffffffffc02050f8 <proc_init+0x148>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204ff6:	4789                	li	a5,2
ffffffffc0204ff8:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204ffa:	00003797          	auipc	a5,0x3
ffffffffc0204ffe:	00678793          	addi	a5,a5,6 # ffffffffc0208000 <bootstack>
ffffffffc0205002:	e91c                	sd	a5,16(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205004:	0b450413          	addi	s0,a0,180
    idleproc->need_resched = 1;
ffffffffc0205008:	4785                	li	a5,1
ffffffffc020500a:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020500c:	4641                	li	a2,16
ffffffffc020500e:	8522                	mv	a0,s0
ffffffffc0205010:	4581                	li	a1,0
ffffffffc0205012:	055000ef          	jal	ffffffffc0205866 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205016:	8522                	mv	a0,s0
ffffffffc0205018:	463d                	li	a2,15
ffffffffc020501a:	00002597          	auipc	a1,0x2
ffffffffc020501e:	3b658593          	addi	a1,a1,950 # ffffffffc02073d0 <etext+0x1b40>
ffffffffc0205022:	057000ef          	jal	ffffffffc0205878 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0205026:	00096797          	auipc	a5,0x96
ffffffffc020502a:	6727a783          	lw	a5,1650(a5) # ffffffffc029b698 <nr_process>

    current = idleproc;
ffffffffc020502e:	00093703          	ld	a4,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205032:	4601                	li	a2,0
    nr_process++;
ffffffffc0205034:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205036:	4581                	li	a1,0
ffffffffc0205038:	00000517          	auipc	a0,0x0
ffffffffc020503c:	81050513          	addi	a0,a0,-2032 # ffffffffc0204848 <init_main>
    current = idleproc;
ffffffffc0205040:	00096697          	auipc	a3,0x96
ffffffffc0205044:	66e6b023          	sd	a4,1632(a3) # ffffffffc029b6a0 <current>
    nr_process++;
ffffffffc0205048:	00096717          	auipc	a4,0x96
ffffffffc020504c:	64f72823          	sw	a5,1616(a4) # ffffffffc029b698 <nr_process>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205050:	c82ff0ef          	jal	ffffffffc02044d2 <kernel_thread>
ffffffffc0205054:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0205056:	08a05563          	blez	a0,ffffffffc02050e0 <proc_init+0x130>
    if (0 < pid && pid < MAX_PID)
ffffffffc020505a:	6789                	lui	a5,0x2
ffffffffc020505c:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6bca>
ffffffffc020505e:	fff5071b          	addiw	a4,a0,-1
ffffffffc0205062:	02e7e463          	bltu	a5,a4,ffffffffc020508a <proc_init+0xda>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0205066:	45a9                	li	a1,10
ffffffffc0205068:	368000ef          	jal	ffffffffc02053d0 <hash32>
ffffffffc020506c:	02051713          	slli	a4,a0,0x20
ffffffffc0205070:	01c75793          	srli	a5,a4,0x1c
ffffffffc0205074:	00f486b3          	add	a3,s1,a5
ffffffffc0205078:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc020507a:	a029                	j	ffffffffc0205084 <proc_init+0xd4>
            if (proc->pid == pid)
ffffffffc020507c:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0205080:	04870d63          	beq	a4,s0,ffffffffc02050da <proc_init+0x12a>
    return listelm->next;
ffffffffc0205084:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0205086:	fef69be3          	bne	a3,a5,ffffffffc020507c <proc_init+0xcc>
    return NULL;
ffffffffc020508a:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020508c:	0b478413          	addi	s0,a5,180
ffffffffc0205090:	4641                	li	a2,16
ffffffffc0205092:	4581                	li	a1,0
ffffffffc0205094:	8522                	mv	a0,s0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0205096:	00096717          	auipc	a4,0x96
ffffffffc020509a:	60f73923          	sd	a5,1554(a4) # ffffffffc029b6a8 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020509e:	7c8000ef          	jal	ffffffffc0205866 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02050a2:	8522                	mv	a0,s0
ffffffffc02050a4:	463d                	li	a2,15
ffffffffc02050a6:	00002597          	auipc	a1,0x2
ffffffffc02050aa:	35258593          	addi	a1,a1,850 # ffffffffc02073f8 <etext+0x1b68>
ffffffffc02050ae:	7ca000ef          	jal	ffffffffc0205878 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02050b2:	00093783          	ld	a5,0(s2)
ffffffffc02050b6:	cfad                	beqz	a5,ffffffffc0205130 <proc_init+0x180>
ffffffffc02050b8:	43dc                	lw	a5,4(a5)
ffffffffc02050ba:	ebbd                	bnez	a5,ffffffffc0205130 <proc_init+0x180>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02050bc:	00096797          	auipc	a5,0x96
ffffffffc02050c0:	5ec7b783          	ld	a5,1516(a5) # ffffffffc029b6a8 <initproc>
ffffffffc02050c4:	c7b1                	beqz	a5,ffffffffc0205110 <proc_init+0x160>
ffffffffc02050c6:	43d8                	lw	a4,4(a5)
ffffffffc02050c8:	4785                	li	a5,1
ffffffffc02050ca:	04f71363          	bne	a4,a5,ffffffffc0205110 <proc_init+0x160>
}
ffffffffc02050ce:	60e2                	ld	ra,24(sp)
ffffffffc02050d0:	6442                	ld	s0,16(sp)
ffffffffc02050d2:	64a2                	ld	s1,8(sp)
ffffffffc02050d4:	6902                	ld	s2,0(sp)
ffffffffc02050d6:	6105                	addi	sp,sp,32
ffffffffc02050d8:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02050da:	f2878793          	addi	a5,a5,-216
ffffffffc02050de:	b77d                	j	ffffffffc020508c <proc_init+0xdc>
        panic("create init_main failed.\n");
ffffffffc02050e0:	00002617          	auipc	a2,0x2
ffffffffc02050e4:	2f860613          	addi	a2,a2,760 # ffffffffc02073d8 <etext+0x1b48>
ffffffffc02050e8:	3de00593          	li	a1,990
ffffffffc02050ec:	00002517          	auipc	a0,0x2
ffffffffc02050f0:	f5c50513          	addi	a0,a0,-164 # ffffffffc0207048 <etext+0x17b8>
ffffffffc02050f4:	b52fb0ef          	jal	ffffffffc0200446 <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc02050f8:	00002617          	auipc	a2,0x2
ffffffffc02050fc:	2c060613          	addi	a2,a2,704 # ffffffffc02073b8 <etext+0x1b28>
ffffffffc0205100:	3cf00593          	li	a1,975
ffffffffc0205104:	00002517          	auipc	a0,0x2
ffffffffc0205108:	f4450513          	addi	a0,a0,-188 # ffffffffc0207048 <etext+0x17b8>
ffffffffc020510c:	b3afb0ef          	jal	ffffffffc0200446 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205110:	00002697          	auipc	a3,0x2
ffffffffc0205114:	31868693          	addi	a3,a3,792 # ffffffffc0207428 <etext+0x1b98>
ffffffffc0205118:	00001617          	auipc	a2,0x1
ffffffffc020511c:	14860613          	addi	a2,a2,328 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0205120:	3e500593          	li	a1,997
ffffffffc0205124:	00002517          	auipc	a0,0x2
ffffffffc0205128:	f2450513          	addi	a0,a0,-220 # ffffffffc0207048 <etext+0x17b8>
ffffffffc020512c:	b1afb0ef          	jal	ffffffffc0200446 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205130:	00002697          	auipc	a3,0x2
ffffffffc0205134:	2d068693          	addi	a3,a3,720 # ffffffffc0207400 <etext+0x1b70>
ffffffffc0205138:	00001617          	auipc	a2,0x1
ffffffffc020513c:	12860613          	addi	a2,a2,296 # ffffffffc0206260 <etext+0x9d0>
ffffffffc0205140:	3e400593          	li	a1,996
ffffffffc0205144:	00002517          	auipc	a0,0x2
ffffffffc0205148:	f0450513          	addi	a0,a0,-252 # ffffffffc0207048 <etext+0x17b8>
ffffffffc020514c:	afafb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0205150 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0205150:	1141                	addi	sp,sp,-16
ffffffffc0205152:	e022                	sd	s0,0(sp)
ffffffffc0205154:	e406                	sd	ra,8(sp)
ffffffffc0205156:	00096417          	auipc	s0,0x96
ffffffffc020515a:	54a40413          	addi	s0,s0,1354 # ffffffffc029b6a0 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc020515e:	6018                	ld	a4,0(s0)
ffffffffc0205160:	6f1c                	ld	a5,24(a4)
ffffffffc0205162:	dffd                	beqz	a5,ffffffffc0205160 <cpu_idle+0x10>
        {
            schedule();
ffffffffc0205164:	104000ef          	jal	ffffffffc0205268 <schedule>
ffffffffc0205168:	bfdd                	j	ffffffffc020515e <cpu_idle+0xe>

ffffffffc020516a <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc020516a:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc020516e:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0205172:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0205174:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0205176:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc020517a:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc020517e:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0205182:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0205186:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc020518a:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc020518e:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0205192:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0205196:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc020519a:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc020519e:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc02051a2:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc02051a6:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc02051a8:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc02051aa:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc02051ae:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc02051b2:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc02051b6:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc02051ba:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc02051be:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc02051c2:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc02051c6:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc02051ca:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc02051ce:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc02051d2:	8082                	ret

ffffffffc02051d4 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02051d4:	4118                	lw	a4,0(a0)
{
ffffffffc02051d6:	1101                	addi	sp,sp,-32
ffffffffc02051d8:	ec06                	sd	ra,24(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02051da:	478d                	li	a5,3
ffffffffc02051dc:	06f70763          	beq	a4,a5,ffffffffc020524a <wakeup_proc+0x76>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02051e0:	100027f3          	csrr	a5,sstatus
ffffffffc02051e4:	8b89                	andi	a5,a5,2
ffffffffc02051e6:	eb91                	bnez	a5,ffffffffc02051fa <wakeup_proc+0x26>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc02051e8:	4789                	li	a5,2
ffffffffc02051ea:	02f70763          	beq	a4,a5,ffffffffc0205218 <wakeup_proc+0x44>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02051ee:	60e2                	ld	ra,24(sp)
            proc->state = PROC_RUNNABLE;
ffffffffc02051f0:	c11c                	sw	a5,0(a0)
            proc->wait_state = 0;
ffffffffc02051f2:	0e052623          	sw	zero,236(a0)
}
ffffffffc02051f6:	6105                	addi	sp,sp,32
ffffffffc02051f8:	8082                	ret
        intr_disable();
ffffffffc02051fa:	e42a                	sd	a0,8(sp)
ffffffffc02051fc:	f08fb0ef          	jal	ffffffffc0200904 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205200:	6522                	ld	a0,8(sp)
ffffffffc0205202:	4789                	li	a5,2
ffffffffc0205204:	4118                	lw	a4,0(a0)
ffffffffc0205206:	02f70663          	beq	a4,a5,ffffffffc0205232 <wakeup_proc+0x5e>
            proc->state = PROC_RUNNABLE;
ffffffffc020520a:	c11c                	sw	a5,0(a0)
            proc->wait_state = 0;
ffffffffc020520c:	0e052623          	sw	zero,236(a0)
}
ffffffffc0205210:	60e2                	ld	ra,24(sp)
ffffffffc0205212:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205214:	eeafb06f          	j	ffffffffc02008fe <intr_enable>
ffffffffc0205218:	60e2                	ld	ra,24(sp)
            warn("wakeup runnable process.\n");
ffffffffc020521a:	00002617          	auipc	a2,0x2
ffffffffc020521e:	26e60613          	addi	a2,a2,622 # ffffffffc0207488 <etext+0x1bf8>
ffffffffc0205222:	45d1                	li	a1,20
ffffffffc0205224:	00002517          	auipc	a0,0x2
ffffffffc0205228:	24c50513          	addi	a0,a0,588 # ffffffffc0207470 <etext+0x1be0>
}
ffffffffc020522c:	6105                	addi	sp,sp,32
            warn("wakeup runnable process.\n");
ffffffffc020522e:	a82fb06f          	j	ffffffffc02004b0 <__warn>
ffffffffc0205232:	00002617          	auipc	a2,0x2
ffffffffc0205236:	25660613          	addi	a2,a2,598 # ffffffffc0207488 <etext+0x1bf8>
ffffffffc020523a:	45d1                	li	a1,20
ffffffffc020523c:	00002517          	auipc	a0,0x2
ffffffffc0205240:	23450513          	addi	a0,a0,564 # ffffffffc0207470 <etext+0x1be0>
ffffffffc0205244:	a6cfb0ef          	jal	ffffffffc02004b0 <__warn>
    if (flag)
ffffffffc0205248:	b7e1                	j	ffffffffc0205210 <wakeup_proc+0x3c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020524a:	00002697          	auipc	a3,0x2
ffffffffc020524e:	20668693          	addi	a3,a3,518 # ffffffffc0207450 <etext+0x1bc0>
ffffffffc0205252:	00001617          	auipc	a2,0x1
ffffffffc0205256:	00e60613          	addi	a2,a2,14 # ffffffffc0206260 <etext+0x9d0>
ffffffffc020525a:	45a5                	li	a1,9
ffffffffc020525c:	00002517          	auipc	a0,0x2
ffffffffc0205260:	21450513          	addi	a0,a0,532 # ffffffffc0207470 <etext+0x1be0>
ffffffffc0205264:	9e2fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0205268 <schedule>:

void schedule(void)
{
ffffffffc0205268:	1101                	addi	sp,sp,-32
ffffffffc020526a:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020526c:	100027f3          	csrr	a5,sstatus
ffffffffc0205270:	8b89                	andi	a5,a5,2
ffffffffc0205272:	4301                	li	t1,0
ffffffffc0205274:	e3c1                	bnez	a5,ffffffffc02052f4 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0205276:	00096897          	auipc	a7,0x96
ffffffffc020527a:	42a8b883          	ld	a7,1066(a7) # ffffffffc029b6a0 <current>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020527e:	00096517          	auipc	a0,0x96
ffffffffc0205282:	43253503          	ld	a0,1074(a0) # ffffffffc029b6b0 <idleproc>
        current->need_resched = 0;
ffffffffc0205286:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020528a:	04a88f63          	beq	a7,a0,ffffffffc02052e8 <schedule+0x80>
ffffffffc020528e:	0c888693          	addi	a3,a7,200
ffffffffc0205292:	00096617          	auipc	a2,0x96
ffffffffc0205296:	39660613          	addi	a2,a2,918 # ffffffffc029b628 <proc_list>
        le = last;
ffffffffc020529a:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc020529c:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc020529e:	4809                	li	a6,2
ffffffffc02052a0:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc02052a2:	00c78863          	beq	a5,a2,ffffffffc02052b2 <schedule+0x4a>
                if (next->state == PROC_RUNNABLE)
ffffffffc02052a6:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc02052aa:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc02052ae:	03070363          	beq	a4,a6,ffffffffc02052d4 <schedule+0x6c>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc02052b2:	fef697e3          	bne	a3,a5,ffffffffc02052a0 <schedule+0x38>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02052b6:	ed99                	bnez	a1,ffffffffc02052d4 <schedule+0x6c>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc02052b8:	451c                	lw	a5,8(a0)
ffffffffc02052ba:	2785                	addiw	a5,a5,1
ffffffffc02052bc:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc02052be:	00a88663          	beq	a7,a0,ffffffffc02052ca <schedule+0x62>
ffffffffc02052c2:	e41a                	sd	t1,8(sp)
        {
            proc_run(next);
ffffffffc02052c4:	d67fe0ef          	jal	ffffffffc020402a <proc_run>
ffffffffc02052c8:	6322                	ld	t1,8(sp)
    if (flag)
ffffffffc02052ca:	00031b63          	bnez	t1,ffffffffc02052e0 <schedule+0x78>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02052ce:	60e2                	ld	ra,24(sp)
ffffffffc02052d0:	6105                	addi	sp,sp,32
ffffffffc02052d2:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02052d4:	4198                	lw	a4,0(a1)
ffffffffc02052d6:	4789                	li	a5,2
ffffffffc02052d8:	fef710e3          	bne	a4,a5,ffffffffc02052b8 <schedule+0x50>
ffffffffc02052dc:	852e                	mv	a0,a1
ffffffffc02052de:	bfe9                	j	ffffffffc02052b8 <schedule+0x50>
}
ffffffffc02052e0:	60e2                	ld	ra,24(sp)
ffffffffc02052e2:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02052e4:	e1afb06f          	j	ffffffffc02008fe <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02052e8:	00096617          	auipc	a2,0x96
ffffffffc02052ec:	34060613          	addi	a2,a2,832 # ffffffffc029b628 <proc_list>
ffffffffc02052f0:	86b2                	mv	a3,a2
ffffffffc02052f2:	b765                	j	ffffffffc020529a <schedule+0x32>
        intr_disable();
ffffffffc02052f4:	e10fb0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc02052f8:	4305                	li	t1,1
ffffffffc02052fa:	bfb5                	j	ffffffffc0205276 <schedule+0xe>

ffffffffc02052fc <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc02052fc:	00096797          	auipc	a5,0x96
ffffffffc0205300:	3a47b783          	ld	a5,932(a5) # ffffffffc029b6a0 <current>
}
ffffffffc0205304:	43c8                	lw	a0,4(a5)
ffffffffc0205306:	8082                	ret

ffffffffc0205308 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0205308:	4501                	li	a0,0
ffffffffc020530a:	8082                	ret

ffffffffc020530c <sys_putc>:
    cputchar(c);
ffffffffc020530c:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc020530e:	1141                	addi	sp,sp,-16
ffffffffc0205310:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205312:	eb7fa0ef          	jal	ffffffffc02001c8 <cputchar>
}
ffffffffc0205316:	60a2                	ld	ra,8(sp)
ffffffffc0205318:	4501                	li	a0,0
ffffffffc020531a:	0141                	addi	sp,sp,16
ffffffffc020531c:	8082                	ret

ffffffffc020531e <sys_kill>:
    return do_kill(pid);
ffffffffc020531e:	4108                	lw	a0,0(a0)
ffffffffc0205320:	c19ff06f          	j	ffffffffc0204f38 <do_kill>

ffffffffc0205324 <sys_yield>:
    return do_yield();
ffffffffc0205324:	bcbff06f          	j	ffffffffc0204eee <do_yield>

ffffffffc0205328 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0205328:	6d14                	ld	a3,24(a0)
ffffffffc020532a:	6910                	ld	a2,16(a0)
ffffffffc020532c:	650c                	ld	a1,8(a0)
ffffffffc020532e:	6108                	ld	a0,0(a0)
ffffffffc0205330:	e3cff06f          	j	ffffffffc020496c <do_execve>

ffffffffc0205334 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0205334:	650c                	ld	a1,8(a0)
ffffffffc0205336:	4108                	lw	a0,0(a0)
ffffffffc0205338:	bc7ff06f          	j	ffffffffc0204efe <do_wait>

ffffffffc020533c <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc020533c:	00096797          	auipc	a5,0x96
ffffffffc0205340:	3647b783          	ld	a5,868(a5) # ffffffffc029b6a0 <current>
    return do_fork(0, stack, tf);
ffffffffc0205344:	4501                	li	a0,0
    struct trapframe *tf = current->tf;
ffffffffc0205346:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc0205348:	6a0c                	ld	a1,16(a2)
ffffffffc020534a:	d43fe06f          	j	ffffffffc020408c <do_fork>

ffffffffc020534e <sys_exit>:
    return do_exit(error_code);
ffffffffc020534e:	4108                	lw	a0,0(a0)
ffffffffc0205350:	9d2ff06f          	j	ffffffffc0204522 <do_exit>

ffffffffc0205354 <syscall>:

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
    struct trapframe *tf = current->tf;
ffffffffc0205354:	00096697          	auipc	a3,0x96
ffffffffc0205358:	34c6b683          	ld	a3,844(a3) # ffffffffc029b6a0 <current>
syscall(void) {
ffffffffc020535c:	715d                	addi	sp,sp,-80
ffffffffc020535e:	e0a2                	sd	s0,64(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205360:	72c0                	ld	s0,160(a3)
syscall(void) {
ffffffffc0205362:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205364:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc0205366:	4834                	lw	a3,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205368:	02d7ec63          	bltu	a5,a3,ffffffffc02053a0 <syscall+0x4c>
        if (syscalls[num] != NULL) {
ffffffffc020536c:	00002797          	auipc	a5,0x2
ffffffffc0205370:	36478793          	addi	a5,a5,868 # ffffffffc02076d0 <syscalls>
ffffffffc0205374:	00369613          	slli	a2,a3,0x3
ffffffffc0205378:	97b2                	add	a5,a5,a2
ffffffffc020537a:	639c                	ld	a5,0(a5)
ffffffffc020537c:	c395                	beqz	a5,ffffffffc02053a0 <syscall+0x4c>
            arg[0] = tf->gpr.a1;
ffffffffc020537e:	7028                	ld	a0,96(s0)
ffffffffc0205380:	742c                	ld	a1,104(s0)
ffffffffc0205382:	7830                	ld	a2,112(s0)
ffffffffc0205384:	7c34                	ld	a3,120(s0)
ffffffffc0205386:	6c38                	ld	a4,88(s0)
ffffffffc0205388:	f02a                	sd	a0,32(sp)
ffffffffc020538a:	f42e                	sd	a1,40(sp)
ffffffffc020538c:	f832                	sd	a2,48(sp)
ffffffffc020538e:	fc36                	sd	a3,56(sp)
ffffffffc0205390:	ec3a                	sd	a4,24(sp)
            arg[1] = tf->gpr.a2;
            arg[2] = tf->gpr.a3;
            arg[3] = tf->gpr.a4;
            arg[4] = tf->gpr.a5;
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205392:	0828                	addi	a0,sp,24
ffffffffc0205394:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc0205396:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205398:	e828                	sd	a0,80(s0)
}
ffffffffc020539a:	6406                	ld	s0,64(sp)
ffffffffc020539c:	6161                	addi	sp,sp,80
ffffffffc020539e:	8082                	ret
    print_trapframe(tf);
ffffffffc02053a0:	8522                	mv	a0,s0
ffffffffc02053a2:	e436                	sd	a3,8(sp)
ffffffffc02053a4:	f50fb0ef          	jal	ffffffffc0200af4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc02053a8:	00096797          	auipc	a5,0x96
ffffffffc02053ac:	2f87b783          	ld	a5,760(a5) # ffffffffc029b6a0 <current>
ffffffffc02053b0:	66a2                	ld	a3,8(sp)
ffffffffc02053b2:	00002617          	auipc	a2,0x2
ffffffffc02053b6:	0f660613          	addi	a2,a2,246 # ffffffffc02074a8 <etext+0x1c18>
ffffffffc02053ba:	43d8                	lw	a4,4(a5)
ffffffffc02053bc:	06200593          	li	a1,98
ffffffffc02053c0:	0b478793          	addi	a5,a5,180
ffffffffc02053c4:	00002517          	auipc	a0,0x2
ffffffffc02053c8:	11450513          	addi	a0,a0,276 # ffffffffc02074d8 <etext+0x1c48>
ffffffffc02053cc:	87afb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02053d0 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc02053d0:	9e3707b7          	lui	a5,0x9e370
ffffffffc02053d4:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <_binary_obj___user_exit_out_size+0xffffffff9e365e41>
ffffffffc02053d6:	02a787bb          	mulw	a5,a5,a0
    return (hash >> (32 - bits));
ffffffffc02053da:	02000513          	li	a0,32
ffffffffc02053de:	9d0d                	subw	a0,a0,a1
}
ffffffffc02053e0:	00a7d53b          	srlw	a0,a5,a0
ffffffffc02053e4:	8082                	ret

ffffffffc02053e6 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02053e6:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02053e8:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02053ec:	f022                	sd	s0,32(sp)
ffffffffc02053ee:	ec26                	sd	s1,24(sp)
ffffffffc02053f0:	e84a                	sd	s2,16(sp)
ffffffffc02053f2:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02053f4:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02053f8:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc02053fa:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02053fe:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205402:	84aa                	mv	s1,a0
ffffffffc0205404:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc0205406:	03067d63          	bgeu	a2,a6,ffffffffc0205440 <printnum+0x5a>
ffffffffc020540a:	e44e                	sd	s3,8(sp)
ffffffffc020540c:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020540e:	4785                	li	a5,1
ffffffffc0205410:	00e7d763          	bge	a5,a4,ffffffffc020541e <printnum+0x38>
            putch(padc, putdat);
ffffffffc0205414:	85ca                	mv	a1,s2
ffffffffc0205416:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc0205418:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc020541a:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc020541c:	fc65                	bnez	s0,ffffffffc0205414 <printnum+0x2e>
ffffffffc020541e:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205420:	00002797          	auipc	a5,0x2
ffffffffc0205424:	0d078793          	addi	a5,a5,208 # ffffffffc02074f0 <etext+0x1c60>
ffffffffc0205428:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc020542a:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020542c:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0205430:	70a2                	ld	ra,40(sp)
ffffffffc0205432:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205434:	85ca                	mv	a1,s2
ffffffffc0205436:	87a6                	mv	a5,s1
}
ffffffffc0205438:	6942                	ld	s2,16(sp)
ffffffffc020543a:	64e2                	ld	s1,24(sp)
ffffffffc020543c:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020543e:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0205440:	03065633          	divu	a2,a2,a6
ffffffffc0205444:	8722                	mv	a4,s0
ffffffffc0205446:	fa1ff0ef          	jal	ffffffffc02053e6 <printnum>
ffffffffc020544a:	bfd9                	j	ffffffffc0205420 <printnum+0x3a>

ffffffffc020544c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc020544c:	7119                	addi	sp,sp,-128
ffffffffc020544e:	f4a6                	sd	s1,104(sp)
ffffffffc0205450:	f0ca                	sd	s2,96(sp)
ffffffffc0205452:	ecce                	sd	s3,88(sp)
ffffffffc0205454:	e8d2                	sd	s4,80(sp)
ffffffffc0205456:	e4d6                	sd	s5,72(sp)
ffffffffc0205458:	e0da                	sd	s6,64(sp)
ffffffffc020545a:	f862                	sd	s8,48(sp)
ffffffffc020545c:	fc86                	sd	ra,120(sp)
ffffffffc020545e:	f8a2                	sd	s0,112(sp)
ffffffffc0205460:	fc5e                	sd	s7,56(sp)
ffffffffc0205462:	f466                	sd	s9,40(sp)
ffffffffc0205464:	f06a                	sd	s10,32(sp)
ffffffffc0205466:	ec6e                	sd	s11,24(sp)
ffffffffc0205468:	84aa                	mv	s1,a0
ffffffffc020546a:	8c32                	mv	s8,a2
ffffffffc020546c:	8a36                	mv	s4,a3
ffffffffc020546e:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205470:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205474:	05500b13          	li	s6,85
ffffffffc0205478:	00002a97          	auipc	s5,0x2
ffffffffc020547c:	358a8a93          	addi	s5,s5,856 # ffffffffc02077d0 <syscalls+0x100>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205480:	000c4503          	lbu	a0,0(s8)
ffffffffc0205484:	001c0413          	addi	s0,s8,1
ffffffffc0205488:	01350a63          	beq	a0,s3,ffffffffc020549c <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc020548c:	cd0d                	beqz	a0,ffffffffc02054c6 <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc020548e:	85ca                	mv	a1,s2
ffffffffc0205490:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205492:	00044503          	lbu	a0,0(s0)
ffffffffc0205496:	0405                	addi	s0,s0,1
ffffffffc0205498:	ff351ae3          	bne	a0,s3,ffffffffc020548c <vprintfmt+0x40>
        width = precision = -1;
ffffffffc020549c:	5cfd                	li	s9,-1
ffffffffc020549e:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc02054a0:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc02054a4:	4b81                	li	s7,0
ffffffffc02054a6:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02054a8:	00044683          	lbu	a3,0(s0)
ffffffffc02054ac:	00140c13          	addi	s8,s0,1
ffffffffc02054b0:	fdd6859b          	addiw	a1,a3,-35
ffffffffc02054b4:	0ff5f593          	zext.b	a1,a1
ffffffffc02054b8:	02bb6663          	bltu	s6,a1,ffffffffc02054e4 <vprintfmt+0x98>
ffffffffc02054bc:	058a                	slli	a1,a1,0x2
ffffffffc02054be:	95d6                	add	a1,a1,s5
ffffffffc02054c0:	4198                	lw	a4,0(a1)
ffffffffc02054c2:	9756                	add	a4,a4,s5
ffffffffc02054c4:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02054c6:	70e6                	ld	ra,120(sp)
ffffffffc02054c8:	7446                	ld	s0,112(sp)
ffffffffc02054ca:	74a6                	ld	s1,104(sp)
ffffffffc02054cc:	7906                	ld	s2,96(sp)
ffffffffc02054ce:	69e6                	ld	s3,88(sp)
ffffffffc02054d0:	6a46                	ld	s4,80(sp)
ffffffffc02054d2:	6aa6                	ld	s5,72(sp)
ffffffffc02054d4:	6b06                	ld	s6,64(sp)
ffffffffc02054d6:	7be2                	ld	s7,56(sp)
ffffffffc02054d8:	7c42                	ld	s8,48(sp)
ffffffffc02054da:	7ca2                	ld	s9,40(sp)
ffffffffc02054dc:	7d02                	ld	s10,32(sp)
ffffffffc02054de:	6de2                	ld	s11,24(sp)
ffffffffc02054e0:	6109                	addi	sp,sp,128
ffffffffc02054e2:	8082                	ret
            putch('%', putdat);
ffffffffc02054e4:	85ca                	mv	a1,s2
ffffffffc02054e6:	02500513          	li	a0,37
ffffffffc02054ea:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02054ec:	fff44783          	lbu	a5,-1(s0)
ffffffffc02054f0:	02500713          	li	a4,37
ffffffffc02054f4:	8c22                	mv	s8,s0
ffffffffc02054f6:	f8e785e3          	beq	a5,a4,ffffffffc0205480 <vprintfmt+0x34>
ffffffffc02054fa:	ffec4783          	lbu	a5,-2(s8)
ffffffffc02054fe:	1c7d                	addi	s8,s8,-1
ffffffffc0205500:	fee79de3          	bne	a5,a4,ffffffffc02054fa <vprintfmt+0xae>
ffffffffc0205504:	bfb5                	j	ffffffffc0205480 <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0205506:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc020550a:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc020550c:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc0205510:	fd06071b          	addiw	a4,a2,-48
ffffffffc0205514:	24e56a63          	bltu	a0,a4,ffffffffc0205768 <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc0205518:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020551a:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc020551c:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc0205520:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0205524:	0197073b          	addw	a4,a4,s9
ffffffffc0205528:	0017171b          	slliw	a4,a4,0x1
ffffffffc020552c:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc020552e:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0205532:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0205534:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0205538:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc020553c:	feb570e3          	bgeu	a0,a1,ffffffffc020551c <vprintfmt+0xd0>
            if (width < 0)
ffffffffc0205540:	f60d54e3          	bgez	s10,ffffffffc02054a8 <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0205544:	8d66                	mv	s10,s9
ffffffffc0205546:	5cfd                	li	s9,-1
ffffffffc0205548:	b785                	j	ffffffffc02054a8 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020554a:	8db6                	mv	s11,a3
ffffffffc020554c:	8462                	mv	s0,s8
ffffffffc020554e:	bfa9                	j	ffffffffc02054a8 <vprintfmt+0x5c>
ffffffffc0205550:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0205552:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0205554:	bf91                	j	ffffffffc02054a8 <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0205556:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205558:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020555c:	00f74463          	blt	a4,a5,ffffffffc0205564 <vprintfmt+0x118>
    else if (lflag) {
ffffffffc0205560:	1a078763          	beqz	a5,ffffffffc020570e <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0205564:	000a3603          	ld	a2,0(s4)
ffffffffc0205568:	46c1                	li	a3,16
ffffffffc020556a:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc020556c:	000d879b          	sext.w	a5,s11
ffffffffc0205570:	876a                	mv	a4,s10
ffffffffc0205572:	85ca                	mv	a1,s2
ffffffffc0205574:	8526                	mv	a0,s1
ffffffffc0205576:	e71ff0ef          	jal	ffffffffc02053e6 <printnum>
            break;
ffffffffc020557a:	b719                	j	ffffffffc0205480 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc020557c:	000a2503          	lw	a0,0(s4)
ffffffffc0205580:	85ca                	mv	a1,s2
ffffffffc0205582:	0a21                	addi	s4,s4,8
ffffffffc0205584:	9482                	jalr	s1
            break;
ffffffffc0205586:	bded                	j	ffffffffc0205480 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0205588:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020558a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020558e:	00f74463          	blt	a4,a5,ffffffffc0205596 <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0205592:	16078963          	beqz	a5,ffffffffc0205704 <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc0205596:	000a3603          	ld	a2,0(s4)
ffffffffc020559a:	46a9                	li	a3,10
ffffffffc020559c:	8a2e                	mv	s4,a1
ffffffffc020559e:	b7f9                	j	ffffffffc020556c <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc02055a0:	85ca                	mv	a1,s2
ffffffffc02055a2:	03000513          	li	a0,48
ffffffffc02055a6:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc02055a8:	85ca                	mv	a1,s2
ffffffffc02055aa:	07800513          	li	a0,120
ffffffffc02055ae:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02055b0:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc02055b4:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02055b6:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02055b8:	bf55                	j	ffffffffc020556c <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc02055ba:	85ca                	mv	a1,s2
ffffffffc02055bc:	02500513          	li	a0,37
ffffffffc02055c0:	9482                	jalr	s1
            break;
ffffffffc02055c2:	bd7d                	j	ffffffffc0205480 <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc02055c4:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055c8:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc02055ca:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc02055cc:	bf95                	j	ffffffffc0205540 <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc02055ce:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02055d0:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02055d4:	00f74463          	blt	a4,a5,ffffffffc02055dc <vprintfmt+0x190>
    else if (lflag) {
ffffffffc02055d8:	12078163          	beqz	a5,ffffffffc02056fa <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc02055dc:	000a3603          	ld	a2,0(s4)
ffffffffc02055e0:	46a1                	li	a3,8
ffffffffc02055e2:	8a2e                	mv	s4,a1
ffffffffc02055e4:	b761                	j	ffffffffc020556c <vprintfmt+0x120>
            if (width < 0)
ffffffffc02055e6:	876a                	mv	a4,s10
ffffffffc02055e8:	000d5363          	bgez	s10,ffffffffc02055ee <vprintfmt+0x1a2>
ffffffffc02055ec:	4701                	li	a4,0
ffffffffc02055ee:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055f2:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc02055f4:	bd55                	j	ffffffffc02054a8 <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc02055f6:	000d841b          	sext.w	s0,s11
ffffffffc02055fa:	fd340793          	addi	a5,s0,-45
ffffffffc02055fe:	00f037b3          	snez	a5,a5
ffffffffc0205602:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205606:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc020560a:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020560c:	008a0793          	addi	a5,s4,8
ffffffffc0205610:	e43e                	sd	a5,8(sp)
ffffffffc0205612:	100d8c63          	beqz	s11,ffffffffc020572a <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0205616:	12071363          	bnez	a4,ffffffffc020573c <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020561a:	000dc783          	lbu	a5,0(s11)
ffffffffc020561e:	0007851b          	sext.w	a0,a5
ffffffffc0205622:	c78d                	beqz	a5,ffffffffc020564c <vprintfmt+0x200>
ffffffffc0205624:	0d85                	addi	s11,s11,1
ffffffffc0205626:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205628:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020562c:	000cc563          	bltz	s9,ffffffffc0205636 <vprintfmt+0x1ea>
ffffffffc0205630:	3cfd                	addiw	s9,s9,-1
ffffffffc0205632:	008c8d63          	beq	s9,s0,ffffffffc020564c <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205636:	020b9663          	bnez	s7,ffffffffc0205662 <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc020563a:	85ca                	mv	a1,s2
ffffffffc020563c:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020563e:	000dc783          	lbu	a5,0(s11)
ffffffffc0205642:	0d85                	addi	s11,s11,1
ffffffffc0205644:	3d7d                	addiw	s10,s10,-1
ffffffffc0205646:	0007851b          	sext.w	a0,a5
ffffffffc020564a:	f3ed                	bnez	a5,ffffffffc020562c <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc020564c:	01a05963          	blez	s10,ffffffffc020565e <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc0205650:	85ca                	mv	a1,s2
ffffffffc0205652:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0205656:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc0205658:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc020565a:	fe0d1be3          	bnez	s10,ffffffffc0205650 <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020565e:	6a22                	ld	s4,8(sp)
ffffffffc0205660:	b505                	j	ffffffffc0205480 <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205662:	3781                	addiw	a5,a5,-32
ffffffffc0205664:	fcfa7be3          	bgeu	s4,a5,ffffffffc020563a <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc0205668:	03f00513          	li	a0,63
ffffffffc020566c:	85ca                	mv	a1,s2
ffffffffc020566e:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205670:	000dc783          	lbu	a5,0(s11)
ffffffffc0205674:	0d85                	addi	s11,s11,1
ffffffffc0205676:	3d7d                	addiw	s10,s10,-1
ffffffffc0205678:	0007851b          	sext.w	a0,a5
ffffffffc020567c:	dbe1                	beqz	a5,ffffffffc020564c <vprintfmt+0x200>
ffffffffc020567e:	fa0cd9e3          	bgez	s9,ffffffffc0205630 <vprintfmt+0x1e4>
ffffffffc0205682:	b7c5                	j	ffffffffc0205662 <vprintfmt+0x216>
            if (err < 0) {
ffffffffc0205684:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205688:	4661                	li	a2,24
            err = va_arg(ap, int);
ffffffffc020568a:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020568c:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0205690:	8fb9                	xor	a5,a5,a4
ffffffffc0205692:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205696:	02d64563          	blt	a2,a3,ffffffffc02056c0 <vprintfmt+0x274>
ffffffffc020569a:	00002797          	auipc	a5,0x2
ffffffffc020569e:	28e78793          	addi	a5,a5,654 # ffffffffc0207928 <error_string>
ffffffffc02056a2:	00369713          	slli	a4,a3,0x3
ffffffffc02056a6:	97ba                	add	a5,a5,a4
ffffffffc02056a8:	639c                	ld	a5,0(a5)
ffffffffc02056aa:	cb99                	beqz	a5,ffffffffc02056c0 <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc02056ac:	86be                	mv	a3,a5
ffffffffc02056ae:	00000617          	auipc	a2,0x0
ffffffffc02056b2:	20a60613          	addi	a2,a2,522 # ffffffffc02058b8 <etext+0x28>
ffffffffc02056b6:	85ca                	mv	a1,s2
ffffffffc02056b8:	8526                	mv	a0,s1
ffffffffc02056ba:	0d8000ef          	jal	ffffffffc0205792 <printfmt>
ffffffffc02056be:	b3c9                	j	ffffffffc0205480 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02056c0:	00002617          	auipc	a2,0x2
ffffffffc02056c4:	e5060613          	addi	a2,a2,-432 # ffffffffc0207510 <etext+0x1c80>
ffffffffc02056c8:	85ca                	mv	a1,s2
ffffffffc02056ca:	8526                	mv	a0,s1
ffffffffc02056cc:	0c6000ef          	jal	ffffffffc0205792 <printfmt>
ffffffffc02056d0:	bb45                	j	ffffffffc0205480 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc02056d2:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02056d4:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc02056d8:	00f74363          	blt	a4,a5,ffffffffc02056de <vprintfmt+0x292>
    else if (lflag) {
ffffffffc02056dc:	cf81                	beqz	a5,ffffffffc02056f4 <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc02056de:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02056e2:	02044b63          	bltz	s0,ffffffffc0205718 <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc02056e6:	8622                	mv	a2,s0
ffffffffc02056e8:	8a5e                	mv	s4,s7
ffffffffc02056ea:	46a9                	li	a3,10
ffffffffc02056ec:	b541                	j	ffffffffc020556c <vprintfmt+0x120>
            lflag ++;
ffffffffc02056ee:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056f0:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc02056f2:	bb5d                	j	ffffffffc02054a8 <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc02056f4:	000a2403          	lw	s0,0(s4)
ffffffffc02056f8:	b7ed                	j	ffffffffc02056e2 <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc02056fa:	000a6603          	lwu	a2,0(s4)
ffffffffc02056fe:	46a1                	li	a3,8
ffffffffc0205700:	8a2e                	mv	s4,a1
ffffffffc0205702:	b5ad                	j	ffffffffc020556c <vprintfmt+0x120>
ffffffffc0205704:	000a6603          	lwu	a2,0(s4)
ffffffffc0205708:	46a9                	li	a3,10
ffffffffc020570a:	8a2e                	mv	s4,a1
ffffffffc020570c:	b585                	j	ffffffffc020556c <vprintfmt+0x120>
ffffffffc020570e:	000a6603          	lwu	a2,0(s4)
ffffffffc0205712:	46c1                	li	a3,16
ffffffffc0205714:	8a2e                	mv	s4,a1
ffffffffc0205716:	bd99                	j	ffffffffc020556c <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc0205718:	85ca                	mv	a1,s2
ffffffffc020571a:	02d00513          	li	a0,45
ffffffffc020571e:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc0205720:	40800633          	neg	a2,s0
ffffffffc0205724:	8a5e                	mv	s4,s7
ffffffffc0205726:	46a9                	li	a3,10
ffffffffc0205728:	b591                	j	ffffffffc020556c <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc020572a:	e329                	bnez	a4,ffffffffc020576c <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020572c:	02800793          	li	a5,40
ffffffffc0205730:	853e                	mv	a0,a5
ffffffffc0205732:	00002d97          	auipc	s11,0x2
ffffffffc0205736:	dd7d8d93          	addi	s11,s11,-553 # ffffffffc0207509 <etext+0x1c79>
ffffffffc020573a:	b5f5                	j	ffffffffc0205626 <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020573c:	85e6                	mv	a1,s9
ffffffffc020573e:	856e                	mv	a0,s11
ffffffffc0205740:	08a000ef          	jal	ffffffffc02057ca <strnlen>
ffffffffc0205744:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0205748:	01a05863          	blez	s10,ffffffffc0205758 <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc020574c:	85ca                	mv	a1,s2
ffffffffc020574e:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205750:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc0205752:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205754:	fe0d1ce3          	bnez	s10,ffffffffc020574c <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205758:	000dc783          	lbu	a5,0(s11)
ffffffffc020575c:	0007851b          	sext.w	a0,a5
ffffffffc0205760:	ec0792e3          	bnez	a5,ffffffffc0205624 <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205764:	6a22                	ld	s4,8(sp)
ffffffffc0205766:	bb29                	j	ffffffffc0205480 <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205768:	8462                	mv	s0,s8
ffffffffc020576a:	bbd9                	j	ffffffffc0205540 <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020576c:	85e6                	mv	a1,s9
ffffffffc020576e:	00002517          	auipc	a0,0x2
ffffffffc0205772:	d9a50513          	addi	a0,a0,-614 # ffffffffc0207508 <etext+0x1c78>
ffffffffc0205776:	054000ef          	jal	ffffffffc02057ca <strnlen>
ffffffffc020577a:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020577e:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0205782:	00002d97          	auipc	s11,0x2
ffffffffc0205786:	d86d8d93          	addi	s11,s11,-634 # ffffffffc0207508 <etext+0x1c78>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020578a:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020578c:	fda040e3          	bgtz	s10,ffffffffc020574c <vprintfmt+0x300>
ffffffffc0205790:	bd51                	j	ffffffffc0205624 <vprintfmt+0x1d8>

ffffffffc0205792 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205792:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0205794:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205798:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020579a:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020579c:	ec06                	sd	ra,24(sp)
ffffffffc020579e:	f83a                	sd	a4,48(sp)
ffffffffc02057a0:	fc3e                	sd	a5,56(sp)
ffffffffc02057a2:	e0c2                	sd	a6,64(sp)
ffffffffc02057a4:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02057a6:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02057a8:	ca5ff0ef          	jal	ffffffffc020544c <vprintfmt>
}
ffffffffc02057ac:	60e2                	ld	ra,24(sp)
ffffffffc02057ae:	6161                	addi	sp,sp,80
ffffffffc02057b0:	8082                	ret

ffffffffc02057b2 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02057b2:	00054783          	lbu	a5,0(a0)
ffffffffc02057b6:	cb81                	beqz	a5,ffffffffc02057c6 <strlen+0x14>
    size_t cnt = 0;
ffffffffc02057b8:	4781                	li	a5,0
        cnt ++;
ffffffffc02057ba:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc02057bc:	00f50733          	add	a4,a0,a5
ffffffffc02057c0:	00074703          	lbu	a4,0(a4)
ffffffffc02057c4:	fb7d                	bnez	a4,ffffffffc02057ba <strlen+0x8>
    }
    return cnt;
}
ffffffffc02057c6:	853e                	mv	a0,a5
ffffffffc02057c8:	8082                	ret

ffffffffc02057ca <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02057ca:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02057cc:	e589                	bnez	a1,ffffffffc02057d6 <strnlen+0xc>
ffffffffc02057ce:	a811                	j	ffffffffc02057e2 <strnlen+0x18>
        cnt ++;
ffffffffc02057d0:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02057d2:	00f58863          	beq	a1,a5,ffffffffc02057e2 <strnlen+0x18>
ffffffffc02057d6:	00f50733          	add	a4,a0,a5
ffffffffc02057da:	00074703          	lbu	a4,0(a4)
ffffffffc02057de:	fb6d                	bnez	a4,ffffffffc02057d0 <strnlen+0x6>
ffffffffc02057e0:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02057e2:	852e                	mv	a0,a1
ffffffffc02057e4:	8082                	ret

ffffffffc02057e6 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc02057e6:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc02057e8:	0005c703          	lbu	a4,0(a1)
ffffffffc02057ec:	0585                	addi	a1,a1,1
ffffffffc02057ee:	0785                	addi	a5,a5,1
ffffffffc02057f0:	fee78fa3          	sb	a4,-1(a5)
ffffffffc02057f4:	fb75                	bnez	a4,ffffffffc02057e8 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc02057f6:	8082                	ret

ffffffffc02057f8 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02057f8:	00054783          	lbu	a5,0(a0)
ffffffffc02057fc:	e791                	bnez	a5,ffffffffc0205808 <strcmp+0x10>
ffffffffc02057fe:	a01d                	j	ffffffffc0205824 <strcmp+0x2c>
ffffffffc0205800:	00054783          	lbu	a5,0(a0)
ffffffffc0205804:	cb99                	beqz	a5,ffffffffc020581a <strcmp+0x22>
ffffffffc0205806:	0585                	addi	a1,a1,1
ffffffffc0205808:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc020580c:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020580e:	fef709e3          	beq	a4,a5,ffffffffc0205800 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205812:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0205816:	9d19                	subw	a0,a0,a4
ffffffffc0205818:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020581a:	0015c703          	lbu	a4,1(a1)
ffffffffc020581e:	4501                	li	a0,0
}
ffffffffc0205820:	9d19                	subw	a0,a0,a4
ffffffffc0205822:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205824:	0005c703          	lbu	a4,0(a1)
ffffffffc0205828:	4501                	li	a0,0
ffffffffc020582a:	b7f5                	j	ffffffffc0205816 <strcmp+0x1e>

ffffffffc020582c <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020582c:	ce01                	beqz	a2,ffffffffc0205844 <strncmp+0x18>
ffffffffc020582e:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0205832:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205834:	cb91                	beqz	a5,ffffffffc0205848 <strncmp+0x1c>
ffffffffc0205836:	0005c703          	lbu	a4,0(a1)
ffffffffc020583a:	00f71763          	bne	a4,a5,ffffffffc0205848 <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc020583e:	0505                	addi	a0,a0,1
ffffffffc0205840:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205842:	f675                	bnez	a2,ffffffffc020582e <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205844:	4501                	li	a0,0
ffffffffc0205846:	8082                	ret
ffffffffc0205848:	00054503          	lbu	a0,0(a0)
ffffffffc020584c:	0005c783          	lbu	a5,0(a1)
ffffffffc0205850:	9d1d                	subw	a0,a0,a5
}
ffffffffc0205852:	8082                	ret

ffffffffc0205854 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0205854:	a021                	j	ffffffffc020585c <strchr+0x8>
        if (*s == c) {
ffffffffc0205856:	00f58763          	beq	a1,a5,ffffffffc0205864 <strchr+0x10>
            return (char *)s;
        }
        s ++;
ffffffffc020585a:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc020585c:	00054783          	lbu	a5,0(a0)
ffffffffc0205860:	fbfd                	bnez	a5,ffffffffc0205856 <strchr+0x2>
    }
    return NULL;
ffffffffc0205862:	4501                	li	a0,0
}
ffffffffc0205864:	8082                	ret

ffffffffc0205866 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0205866:	ca01                	beqz	a2,ffffffffc0205876 <memset+0x10>
ffffffffc0205868:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc020586a:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc020586c:	0785                	addi	a5,a5,1
ffffffffc020586e:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0205872:	fef61de3          	bne	a2,a5,ffffffffc020586c <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0205876:	8082                	ret

ffffffffc0205878 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0205878:	ca19                	beqz	a2,ffffffffc020588e <memcpy+0x16>
ffffffffc020587a:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc020587c:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc020587e:	0005c703          	lbu	a4,0(a1)
ffffffffc0205882:	0585                	addi	a1,a1,1
ffffffffc0205884:	0785                	addi	a5,a5,1
ffffffffc0205886:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc020588a:	feb61ae3          	bne	a2,a1,ffffffffc020587e <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc020588e:	8082                	ret
