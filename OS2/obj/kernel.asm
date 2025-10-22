
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00006297          	auipc	t0,0x6
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0206000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00006297          	auipc	t0,0x6
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0206008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02052b7          	lui	t0,0xc0205
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
ffffffffc020003c:	c0205137          	lui	sp,0xc0205

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	0d628293          	addi	t0,t0,214 # ffffffffc02000d6 <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020004a:	1141                	addi	sp,sp,-16 # ffffffffc0204ff0 <bootstack+0x1ff0>
    extern char etext[], edata[], end[];
    cprintf("Special kernel symbols:\n");
ffffffffc020004c:	00002517          	auipc	a0,0x2
ffffffffc0200050:	bfc50513          	addi	a0,a0,-1028 # ffffffffc0201c48 <etext+0x6>
void print_kerninfo(void) {
ffffffffc0200054:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200056:	0f2000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", (uintptr_t)kern_init);
ffffffffc020005a:	00000597          	auipc	a1,0x0
ffffffffc020005e:	07c58593          	addi	a1,a1,124 # ffffffffc02000d6 <kern_init>
ffffffffc0200062:	00002517          	auipc	a0,0x2
ffffffffc0200066:	c0650513          	addi	a0,a0,-1018 # ffffffffc0201c68 <etext+0x26>
ffffffffc020006a:	0de000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc020006e:	00002597          	auipc	a1,0x2
ffffffffc0200072:	bd458593          	addi	a1,a1,-1068 # ffffffffc0201c42 <etext>
ffffffffc0200076:	00002517          	auipc	a0,0x2
ffffffffc020007a:	c1250513          	addi	a0,a0,-1006 # ffffffffc0201c88 <etext+0x46>
ffffffffc020007e:	0ca000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc0200082:	00006597          	auipc	a1,0x6
ffffffffc0200086:	f9658593          	addi	a1,a1,-106 # ffffffffc0206018 <cache_set>
ffffffffc020008a:	00002517          	auipc	a0,0x2
ffffffffc020008e:	c1e50513          	addi	a0,a0,-994 # ffffffffc0201ca8 <etext+0x66>
ffffffffc0200092:	0b6000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc0200096:	00006597          	auipc	a1,0x6
ffffffffc020009a:	04a58593          	addi	a1,a1,74 # ffffffffc02060e0 <end>
ffffffffc020009e:	00002517          	auipc	a0,0x2
ffffffffc02000a2:	c2a50513          	addi	a0,a0,-982 # ffffffffc0201cc8 <etext+0x86>
ffffffffc02000a6:	0a2000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - (char*)kern_init + 1023) / 1024);
ffffffffc02000aa:	00000717          	auipc	a4,0x0
ffffffffc02000ae:	02c70713          	addi	a4,a4,44 # ffffffffc02000d6 <kern_init>
ffffffffc02000b2:	00006797          	auipc	a5,0x6
ffffffffc02000b6:	42d78793          	addi	a5,a5,1069 # ffffffffc02064df <end+0x3ff>
ffffffffc02000ba:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000bc:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02000c0:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000c2:	3ff5f593          	andi	a1,a1,1023
ffffffffc02000c6:	95be                	add	a1,a1,a5
ffffffffc02000c8:	85a9                	srai	a1,a1,0xa
ffffffffc02000ca:	00002517          	auipc	a0,0x2
ffffffffc02000ce:	c1e50513          	addi	a0,a0,-994 # ffffffffc0201ce8 <etext+0xa6>
}
ffffffffc02000d2:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000d4:	a895                	j	ffffffffc0200148 <cprintf>

ffffffffc02000d6 <kern_init>:

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc02000d6:	00006517          	auipc	a0,0x6
ffffffffc02000da:	f4250513          	addi	a0,a0,-190 # ffffffffc0206018 <cache_set>
ffffffffc02000de:	00006617          	auipc	a2,0x6
ffffffffc02000e2:	00260613          	addi	a2,a2,2 # ffffffffc02060e0 <end>
int kern_init(void) {
ffffffffc02000e6:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc02000e8:	8e09                	sub	a2,a2,a0
ffffffffc02000ea:	4581                	li	a1,0
int kern_init(void) {
ffffffffc02000ec:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc02000ee:	343010ef          	jal	ffffffffc0201c30 <memset>
    dtb_init();
ffffffffc02000f2:	136000ef          	jal	ffffffffc0200228 <dtb_init>
    cons_init();  // init the console
ffffffffc02000f6:	128000ef          	jal	ffffffffc020021e <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc02000fa:	00002517          	auipc	a0,0x2
ffffffffc02000fe:	63650513          	addi	a0,a0,1590 # ffffffffc0202730 <etext+0xaee>
ffffffffc0200102:	07a000ef          	jal	ffffffffc020017c <cputs>

    print_kerninfo();
ffffffffc0200106:	f45ff0ef          	jal	ffffffffc020004a <print_kerninfo>

    // grade_backtrace();
    pmm_init();  // init physical memory management
ffffffffc020010a:	464000ef          	jal	ffffffffc020056e <pmm_init>

    /* do nothing */
    while (1)
ffffffffc020010e:	a001                	j	ffffffffc020010e <kern_init+0x38>

ffffffffc0200110 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200110:	1101                	addi	sp,sp,-32
ffffffffc0200112:	ec06                	sd	ra,24(sp)
ffffffffc0200114:	e42e                	sd	a1,8(sp)
    cons_putc(c);
ffffffffc0200116:	10a000ef          	jal	ffffffffc0200220 <cons_putc>
    (*cnt) ++;
ffffffffc020011a:	65a2                	ld	a1,8(sp)
}
ffffffffc020011c:	60e2                	ld	ra,24(sp)
    (*cnt) ++;
ffffffffc020011e:	419c                	lw	a5,0(a1)
ffffffffc0200120:	2785                	addiw	a5,a5,1
ffffffffc0200122:	c19c                	sw	a5,0(a1)
}
ffffffffc0200124:	6105                	addi	sp,sp,32
ffffffffc0200126:	8082                	ret

ffffffffc0200128 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200128:	1101                	addi	sp,sp,-32
ffffffffc020012a:	862a                	mv	a2,a0
ffffffffc020012c:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020012e:	00000517          	auipc	a0,0x0
ffffffffc0200132:	fe250513          	addi	a0,a0,-30 # ffffffffc0200110 <cputch>
ffffffffc0200136:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200138:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020013a:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020013c:	6e4010ef          	jal	ffffffffc0201820 <vprintfmt>
    return cnt;
}
ffffffffc0200140:	60e2                	ld	ra,24(sp)
ffffffffc0200142:	4532                	lw	a0,12(sp)
ffffffffc0200144:	6105                	addi	sp,sp,32
ffffffffc0200146:	8082                	ret

ffffffffc0200148 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc0200148:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020014a:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
ffffffffc020014e:	f42e                	sd	a1,40(sp)
ffffffffc0200150:	f832                	sd	a2,48(sp)
ffffffffc0200152:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200154:	862a                	mv	a2,a0
ffffffffc0200156:	004c                	addi	a1,sp,4
ffffffffc0200158:	00000517          	auipc	a0,0x0
ffffffffc020015c:	fb850513          	addi	a0,a0,-72 # ffffffffc0200110 <cputch>
ffffffffc0200160:	869a                	mv	a3,t1
cprintf(const char *fmt, ...) {
ffffffffc0200162:	ec06                	sd	ra,24(sp)
ffffffffc0200164:	e0ba                	sd	a4,64(sp)
ffffffffc0200166:	e4be                	sd	a5,72(sp)
ffffffffc0200168:	e8c2                	sd	a6,80(sp)
ffffffffc020016a:	ecc6                	sd	a7,88(sp)
    int cnt = 0;
ffffffffc020016c:	c202                	sw	zero,4(sp)
    va_start(ap, fmt);
ffffffffc020016e:	e41a                	sd	t1,8(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200170:	6b0010ef          	jal	ffffffffc0201820 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc0200174:	60e2                	ld	ra,24(sp)
ffffffffc0200176:	4512                	lw	a0,4(sp)
ffffffffc0200178:	6125                	addi	sp,sp,96
ffffffffc020017a:	8082                	ret

ffffffffc020017c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc020017c:	1101                	addi	sp,sp,-32
ffffffffc020017e:	e822                	sd	s0,16(sp)
ffffffffc0200180:	ec06                	sd	ra,24(sp)
ffffffffc0200182:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc0200184:	00054503          	lbu	a0,0(a0)
ffffffffc0200188:	c51d                	beqz	a0,ffffffffc02001b6 <cputs+0x3a>
ffffffffc020018a:	e426                	sd	s1,8(sp)
ffffffffc020018c:	0405                	addi	s0,s0,1
    int cnt = 0;
ffffffffc020018e:	4481                	li	s1,0
    cons_putc(c);
ffffffffc0200190:	090000ef          	jal	ffffffffc0200220 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc0200194:	00044503          	lbu	a0,0(s0)
ffffffffc0200198:	0405                	addi	s0,s0,1
ffffffffc020019a:	87a6                	mv	a5,s1
    (*cnt) ++;
ffffffffc020019c:	2485                	addiw	s1,s1,1
    while ((c = *str ++) != '\0') {
ffffffffc020019e:	f96d                	bnez	a0,ffffffffc0200190 <cputs+0x14>
    cons_putc(c);
ffffffffc02001a0:	4529                	li	a0,10
    (*cnt) ++;
ffffffffc02001a2:	0027841b          	addiw	s0,a5,2
ffffffffc02001a6:	64a2                	ld	s1,8(sp)
    cons_putc(c);
ffffffffc02001a8:	078000ef          	jal	ffffffffc0200220 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001ac:	60e2                	ld	ra,24(sp)
ffffffffc02001ae:	8522                	mv	a0,s0
ffffffffc02001b0:	6442                	ld	s0,16(sp)
ffffffffc02001b2:	6105                	addi	sp,sp,32
ffffffffc02001b4:	8082                	ret
    cons_putc(c);
ffffffffc02001b6:	4529                	li	a0,10
ffffffffc02001b8:	068000ef          	jal	ffffffffc0200220 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc02001bc:	4405                	li	s0,1
}
ffffffffc02001be:	60e2                	ld	ra,24(sp)
ffffffffc02001c0:	8522                	mv	a0,s0
ffffffffc02001c2:	6442                	ld	s0,16(sp)
ffffffffc02001c4:	6105                	addi	sp,sp,32
ffffffffc02001c6:	8082                	ret

ffffffffc02001c8 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02001c8:	00006317          	auipc	t1,0x6
ffffffffc02001cc:	ec832303          	lw	t1,-312(t1) # ffffffffc0206090 <is_panic>
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02001d0:	715d                	addi	sp,sp,-80
ffffffffc02001d2:	ec06                	sd	ra,24(sp)
ffffffffc02001d4:	f436                	sd	a3,40(sp)
ffffffffc02001d6:	f83a                	sd	a4,48(sp)
ffffffffc02001d8:	fc3e                	sd	a5,56(sp)
ffffffffc02001da:	e0c2                	sd	a6,64(sp)
ffffffffc02001dc:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02001de:	00030363          	beqz	t1,ffffffffc02001e4 <__panic+0x1c>
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    while (1) {
ffffffffc02001e2:	a001                	j	ffffffffc02001e2 <__panic+0x1a>
    is_panic = 1;
ffffffffc02001e4:	4705                	li	a4,1
    va_start(ap, fmt);
ffffffffc02001e6:	103c                	addi	a5,sp,40
ffffffffc02001e8:	e822                	sd	s0,16(sp)
ffffffffc02001ea:	8432                	mv	s0,a2
ffffffffc02001ec:	862e                	mv	a2,a1
ffffffffc02001ee:	85aa                	mv	a1,a0
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02001f0:	00002517          	auipc	a0,0x2
ffffffffc02001f4:	b2850513          	addi	a0,a0,-1240 # ffffffffc0201d18 <etext+0xd6>
    is_panic = 1;
ffffffffc02001f8:	00006697          	auipc	a3,0x6
ffffffffc02001fc:	e8e6ac23          	sw	a4,-360(a3) # ffffffffc0206090 <is_panic>
    va_start(ap, fmt);
ffffffffc0200200:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200202:	f47ff0ef          	jal	ffffffffc0200148 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200206:	65a2                	ld	a1,8(sp)
ffffffffc0200208:	8522                	mv	a0,s0
ffffffffc020020a:	f1fff0ef          	jal	ffffffffc0200128 <vcprintf>
    cprintf("\n");
ffffffffc020020e:	00002517          	auipc	a0,0x2
ffffffffc0200212:	b2a50513          	addi	a0,a0,-1238 # ffffffffc0201d38 <etext+0xf6>
ffffffffc0200216:	f33ff0ef          	jal	ffffffffc0200148 <cprintf>
ffffffffc020021a:	6442                	ld	s0,16(sp)
ffffffffc020021c:	b7d9                	j	ffffffffc02001e2 <__panic+0x1a>

ffffffffc020021e <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020021e:	8082                	ret

ffffffffc0200220 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc0200220:	0ff57513          	zext.b	a0,a0
ffffffffc0200224:	1630106f          	j	ffffffffc0201b86 <sbi_console_putchar>

ffffffffc0200228 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200228:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc020022a:	00002517          	auipc	a0,0x2
ffffffffc020022e:	b1650513          	addi	a0,a0,-1258 # ffffffffc0201d40 <etext+0xfe>
void dtb_init(void) {
ffffffffc0200232:	f406                	sd	ra,40(sp)
ffffffffc0200234:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc0200236:	f13ff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc020023a:	00006597          	auipc	a1,0x6
ffffffffc020023e:	dc65b583          	ld	a1,-570(a1) # ffffffffc0206000 <boot_hartid>
ffffffffc0200242:	00002517          	auipc	a0,0x2
ffffffffc0200246:	b0e50513          	addi	a0,a0,-1266 # ffffffffc0201d50 <etext+0x10e>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020024a:	00006417          	auipc	s0,0x6
ffffffffc020024e:	dbe40413          	addi	s0,s0,-578 # ffffffffc0206008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200252:	ef7ff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200256:	600c                	ld	a1,0(s0)
ffffffffc0200258:	00002517          	auipc	a0,0x2
ffffffffc020025c:	b0850513          	addi	a0,a0,-1272 # ffffffffc0201d60 <etext+0x11e>
ffffffffc0200260:	ee9ff0ef          	jal	ffffffffc0200148 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200264:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200266:	00002517          	auipc	a0,0x2
ffffffffc020026a:	b1250513          	addi	a0,a0,-1262 # ffffffffc0201d78 <etext+0x136>
    if (boot_dtb == 0) {
ffffffffc020026e:	10070163          	beqz	a4,ffffffffc0200370 <dtb_init+0x148>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200272:	57f5                	li	a5,-3
ffffffffc0200274:	07fa                	slli	a5,a5,0x1e
ffffffffc0200276:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200278:	431c                	lw	a5,0(a4)
    if (magic != 0xd00dfeed) {
ffffffffc020027a:	d00e06b7          	lui	a3,0xd00e0
ffffffffc020027e:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfed9e0d>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200282:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200286:	0187961b          	slliw	a2,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020028a:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020028e:	0ff5f593          	zext.b	a1,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200292:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200296:	05c2                	slli	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200298:	8e49                	or	a2,a2,a0
ffffffffc020029a:	0ff7f793          	zext.b	a5,a5
ffffffffc020029e:	8dd1                	or	a1,a1,a2
ffffffffc02002a0:	07a2                	slli	a5,a5,0x8
ffffffffc02002a2:	8ddd                	or	a1,a1,a5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002a4:	00ff0837          	lui	a6,0xff0
    if (magic != 0xd00dfeed) {
ffffffffc02002a8:	0cd59863          	bne	a1,a3,ffffffffc0200378 <dtb_init+0x150>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02002ac:	4710                	lw	a2,8(a4)
ffffffffc02002ae:	4754                	lw	a3,12(a4)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02002b0:	e84a                	sd	s2,16(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002b2:	0086541b          	srliw	s0,a2,0x8
ffffffffc02002b6:	0086d79b          	srliw	a5,a3,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002ba:	01865e1b          	srliw	t3,a2,0x18
ffffffffc02002be:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002c2:	0186151b          	slliw	a0,a2,0x18
ffffffffc02002c6:	0186959b          	slliw	a1,a3,0x18
ffffffffc02002ca:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002ce:	0106561b          	srliw	a2,a2,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002d2:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002d6:	0106d69b          	srliw	a3,a3,0x10
ffffffffc02002da:	01c56533          	or	a0,a0,t3
ffffffffc02002de:	0115e5b3          	or	a1,a1,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002e2:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002e6:	0ff67613          	zext.b	a2,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002ea:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002ee:	0ff6f693          	zext.b	a3,a3
ffffffffc02002f2:	8c49                	or	s0,s0,a0
ffffffffc02002f4:	0622                	slli	a2,a2,0x8
ffffffffc02002f6:	8fcd                	or	a5,a5,a1
ffffffffc02002f8:	06a2                	slli	a3,a3,0x8
ffffffffc02002fa:	8c51                	or	s0,s0,a2
ffffffffc02002fc:	8fd5                	or	a5,a5,a3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02002fe:	1402                	slli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200300:	1782                	slli	a5,a5,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200302:	9001                	srli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200304:	9381                	srli	a5,a5,0x20
ffffffffc0200306:	ec26                	sd	s1,24(sp)
    int in_memory_node = 0;
ffffffffc0200308:	4301                	li	t1,0
        switch (token) {
ffffffffc020030a:	488d                	li	a7,3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020030c:	943a                	add	s0,s0,a4
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020030e:	00e78933          	add	s2,a5,a4
        switch (token) {
ffffffffc0200312:	4e05                	li	t3,1
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200314:	4018                	lw	a4,0(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200316:	0087579b          	srliw	a5,a4,0x8
ffffffffc020031a:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020031e:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200322:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200326:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020032a:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020032e:	8ed1                	or	a3,a3,a2
ffffffffc0200330:	0ff77713          	zext.b	a4,a4
ffffffffc0200334:	8fd5                	or	a5,a5,a3
ffffffffc0200336:	0722                	slli	a4,a4,0x8
ffffffffc0200338:	8fd9                	or	a5,a5,a4
        switch (token) {
ffffffffc020033a:	05178763          	beq	a5,a7,ffffffffc0200388 <dtb_init+0x160>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020033e:	0411                	addi	s0,s0,4
        switch (token) {
ffffffffc0200340:	00f8e963          	bltu	a7,a5,ffffffffc0200352 <dtb_init+0x12a>
ffffffffc0200344:	07c78d63          	beq	a5,t3,ffffffffc02003be <dtb_init+0x196>
ffffffffc0200348:	4709                	li	a4,2
ffffffffc020034a:	00e79763          	bne	a5,a4,ffffffffc0200358 <dtb_init+0x130>
ffffffffc020034e:	4301                	li	t1,0
ffffffffc0200350:	b7d1                	j	ffffffffc0200314 <dtb_init+0xec>
ffffffffc0200352:	4711                	li	a4,4
ffffffffc0200354:	fce780e3          	beq	a5,a4,ffffffffc0200314 <dtb_init+0xec>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200358:	00002517          	auipc	a0,0x2
ffffffffc020035c:	ae850513          	addi	a0,a0,-1304 # ffffffffc0201e40 <etext+0x1fe>
ffffffffc0200360:	de9ff0ef          	jal	ffffffffc0200148 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200364:	64e2                	ld	s1,24(sp)
ffffffffc0200366:	6942                	ld	s2,16(sp)
ffffffffc0200368:	00002517          	auipc	a0,0x2
ffffffffc020036c:	b1050513          	addi	a0,a0,-1264 # ffffffffc0201e78 <etext+0x236>
}
ffffffffc0200370:	7402                	ld	s0,32(sp)
ffffffffc0200372:	70a2                	ld	ra,40(sp)
ffffffffc0200374:	6145                	addi	sp,sp,48
    cprintf("DTB init completed\n");
ffffffffc0200376:	bbc9                	j	ffffffffc0200148 <cprintf>
}
ffffffffc0200378:	7402                	ld	s0,32(sp)
ffffffffc020037a:	70a2                	ld	ra,40(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc020037c:	00002517          	auipc	a0,0x2
ffffffffc0200380:	a1c50513          	addi	a0,a0,-1508 # ffffffffc0201d98 <etext+0x156>
}
ffffffffc0200384:	6145                	addi	sp,sp,48
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200386:	b3c9                	j	ffffffffc0200148 <cprintf>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200388:	4058                	lw	a4,4(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020038a:	0087579b          	srliw	a5,a4,0x8
ffffffffc020038e:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200392:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200396:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020039a:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020039e:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02003a2:	8ed1                	or	a3,a3,a2
ffffffffc02003a4:	0ff77713          	zext.b	a4,a4
ffffffffc02003a8:	8fd5                	or	a5,a5,a3
ffffffffc02003aa:	0722                	slli	a4,a4,0x8
ffffffffc02003ac:	8fd9                	or	a5,a5,a4
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02003ae:	04031463          	bnez	t1,ffffffffc02003f6 <dtb_init+0x1ce>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02003b2:	1782                	slli	a5,a5,0x20
ffffffffc02003b4:	9381                	srli	a5,a5,0x20
ffffffffc02003b6:	043d                	addi	s0,s0,15
ffffffffc02003b8:	943e                	add	s0,s0,a5
ffffffffc02003ba:	9871                	andi	s0,s0,-4
                break;
ffffffffc02003bc:	bfa1                	j	ffffffffc0200314 <dtb_init+0xec>
                int name_len = strlen(name);
ffffffffc02003be:	8522                	mv	a0,s0
ffffffffc02003c0:	e01a                	sd	t1,0(sp)
ffffffffc02003c2:	7de010ef          	jal	ffffffffc0201ba0 <strlen>
ffffffffc02003c6:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003c8:	4619                	li	a2,6
ffffffffc02003ca:	8522                	mv	a0,s0
ffffffffc02003cc:	00002597          	auipc	a1,0x2
ffffffffc02003d0:	9f458593          	addi	a1,a1,-1548 # ffffffffc0201dc0 <etext+0x17e>
ffffffffc02003d4:	035010ef          	jal	ffffffffc0201c08 <strncmp>
ffffffffc02003d8:	6302                	ld	t1,0(sp)
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02003da:	0411                	addi	s0,s0,4
ffffffffc02003dc:	0004879b          	sext.w	a5,s1
ffffffffc02003e0:	943e                	add	s0,s0,a5
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003e2:	00153513          	seqz	a0,a0
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02003e6:	9871                	andi	s0,s0,-4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003e8:	00a36333          	or	t1,t1,a0
                break;
ffffffffc02003ec:	00ff0837          	lui	a6,0xff0
ffffffffc02003f0:	488d                	li	a7,3
ffffffffc02003f2:	4e05                	li	t3,1
ffffffffc02003f4:	b705                	j	ffffffffc0200314 <dtb_init+0xec>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02003f6:	4418                	lw	a4,8(s0)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02003f8:	00002597          	auipc	a1,0x2
ffffffffc02003fc:	9d058593          	addi	a1,a1,-1584 # ffffffffc0201dc8 <etext+0x186>
ffffffffc0200400:	e43e                	sd	a5,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200402:	0087551b          	srliw	a0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200406:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020040a:	0187169b          	slliw	a3,a4,0x18
ffffffffc020040e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200412:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200416:	01057533          	and	a0,a0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020041a:	8ed1                	or	a3,a3,a2
ffffffffc020041c:	0ff77713          	zext.b	a4,a4
ffffffffc0200420:	0722                	slli	a4,a4,0x8
ffffffffc0200422:	8d55                	or	a0,a0,a3
ffffffffc0200424:	8d59                	or	a0,a0,a4
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200426:	1502                	slli	a0,a0,0x20
ffffffffc0200428:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020042a:	954a                	add	a0,a0,s2
ffffffffc020042c:	e01a                	sd	t1,0(sp)
ffffffffc020042e:	7a6010ef          	jal	ffffffffc0201bd4 <strcmp>
ffffffffc0200432:	67a2                	ld	a5,8(sp)
ffffffffc0200434:	473d                	li	a4,15
ffffffffc0200436:	6302                	ld	t1,0(sp)
ffffffffc0200438:	00ff0837          	lui	a6,0xff0
ffffffffc020043c:	488d                	li	a7,3
ffffffffc020043e:	4e05                	li	t3,1
ffffffffc0200440:	f6f779e3          	bgeu	a4,a5,ffffffffc02003b2 <dtb_init+0x18a>
ffffffffc0200444:	f53d                	bnez	a0,ffffffffc02003b2 <dtb_init+0x18a>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200446:	00c43683          	ld	a3,12(s0)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020044a:	01443703          	ld	a4,20(s0)
        cprintf("Physical Memory from DTB:\n");
ffffffffc020044e:	00002517          	auipc	a0,0x2
ffffffffc0200452:	98250513          	addi	a0,a0,-1662 # ffffffffc0201dd0 <etext+0x18e>
           fdt32_to_cpu(x >> 32);
ffffffffc0200456:	4206d793          	srai	a5,a3,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020045a:	0087d31b          	srliw	t1,a5,0x8
ffffffffc020045e:	00871f93          	slli	t6,a4,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc0200462:	42075893          	srai	a7,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200466:	0187df1b          	srliw	t5,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020046a:	0187959b          	slliw	a1,a5,0x18
ffffffffc020046e:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200472:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200476:	420fd613          	srai	a2,t6,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020047a:	0188de9b          	srliw	t4,a7,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020047e:	01037333          	and	t1,t1,a6
ffffffffc0200482:	01889e1b          	slliw	t3,a7,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200486:	01e5e5b3          	or	a1,a1,t5
ffffffffc020048a:	0ff7f793          	zext.b	a5,a5
ffffffffc020048e:	01de6e33          	or	t3,t3,t4
ffffffffc0200492:	0065e5b3          	or	a1,a1,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200496:	01067633          	and	a2,a2,a6
ffffffffc020049a:	0086d31b          	srliw	t1,a3,0x8
ffffffffc020049e:	0087541b          	srliw	s0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004a2:	07a2                	slli	a5,a5,0x8
ffffffffc02004a4:	0108d89b          	srliw	a7,a7,0x10
ffffffffc02004a8:	0186df1b          	srliw	t5,a3,0x18
ffffffffc02004ac:	01875e9b          	srliw	t4,a4,0x18
ffffffffc02004b0:	8ddd                	or	a1,a1,a5
ffffffffc02004b2:	01c66633          	or	a2,a2,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004b6:	0186979b          	slliw	a5,a3,0x18
ffffffffc02004ba:	01871e1b          	slliw	t3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004be:	0ff8f893          	zext.b	a7,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c2:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004c6:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004ca:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004ce:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004d2:	01037333          	and	t1,t1,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004d6:	08a2                	slli	a7,a7,0x8
ffffffffc02004d8:	01e7e7b3          	or	a5,a5,t5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004dc:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004e0:	0ff6f693          	zext.b	a3,a3
ffffffffc02004e4:	01de6833          	or	a6,t3,t4
ffffffffc02004e8:	0ff77713          	zext.b	a4,a4
ffffffffc02004ec:	01166633          	or	a2,a2,a7
ffffffffc02004f0:	0067e7b3          	or	a5,a5,t1
ffffffffc02004f4:	06a2                	slli	a3,a3,0x8
ffffffffc02004f6:	01046433          	or	s0,s0,a6
ffffffffc02004fa:	0722                	slli	a4,a4,0x8
ffffffffc02004fc:	8fd5                	or	a5,a5,a3
ffffffffc02004fe:	8c59                	or	s0,s0,a4
           fdt32_to_cpu(x >> 32);
ffffffffc0200500:	1582                	slli	a1,a1,0x20
ffffffffc0200502:	1602                	slli	a2,a2,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200504:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200506:	9201                	srli	a2,a2,0x20
ffffffffc0200508:	9181                	srli	a1,a1,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020050a:	1402                	slli	s0,s0,0x20
ffffffffc020050c:	00b7e4b3          	or	s1,a5,a1
ffffffffc0200510:	8c51                	or	s0,s0,a2
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200512:	c37ff0ef          	jal	ffffffffc0200148 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200516:	85a6                	mv	a1,s1
ffffffffc0200518:	00002517          	auipc	a0,0x2
ffffffffc020051c:	8d850513          	addi	a0,a0,-1832 # ffffffffc0201df0 <etext+0x1ae>
ffffffffc0200520:	c29ff0ef          	jal	ffffffffc0200148 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200524:	01445613          	srli	a2,s0,0x14
ffffffffc0200528:	85a2                	mv	a1,s0
ffffffffc020052a:	00002517          	auipc	a0,0x2
ffffffffc020052e:	8de50513          	addi	a0,a0,-1826 # ffffffffc0201e08 <etext+0x1c6>
ffffffffc0200532:	c17ff0ef          	jal	ffffffffc0200148 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200536:	009405b3          	add	a1,s0,s1
ffffffffc020053a:	15fd                	addi	a1,a1,-1
ffffffffc020053c:	00002517          	auipc	a0,0x2
ffffffffc0200540:	8ec50513          	addi	a0,a0,-1812 # ffffffffc0201e28 <etext+0x1e6>
ffffffffc0200544:	c05ff0ef          	jal	ffffffffc0200148 <cprintf>
        memory_base = mem_base;
ffffffffc0200548:	00006797          	auipc	a5,0x6
ffffffffc020054c:	b497bc23          	sd	s1,-1192(a5) # ffffffffc02060a0 <memory_base>
        memory_size = mem_size;
ffffffffc0200550:	00006797          	auipc	a5,0x6
ffffffffc0200554:	b487b423          	sd	s0,-1208(a5) # ffffffffc0206098 <memory_size>
ffffffffc0200558:	b531                	j	ffffffffc0200364 <dtb_init+0x13c>

ffffffffc020055a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020055a:	00006517          	auipc	a0,0x6
ffffffffc020055e:	b4653503          	ld	a0,-1210(a0) # ffffffffc02060a0 <memory_base>
ffffffffc0200562:	8082                	ret

ffffffffc0200564 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc0200564:	00006517          	auipc	a0,0x6
ffffffffc0200568:	b3453503          	ld	a0,-1228(a0) # ffffffffc0206098 <memory_size>
ffffffffc020056c:	8082                	ret

ffffffffc020056e <pmm_init>:

static void check_alloc_page(void);

// init_pmm_manager - initialize a pmm_manager instance
static void init_pmm_manager(void) {
    pmm_manager = &slub_pmm_manager;
ffffffffc020056e:	00002797          	auipc	a5,0x2
ffffffffc0200572:	1e278793          	addi	a5,a5,482 # ffffffffc0202750 <slub_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200576:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc0200578:	7139                	addi	sp,sp,-64
ffffffffc020057a:	fc06                	sd	ra,56(sp)
ffffffffc020057c:	f822                	sd	s0,48(sp)
ffffffffc020057e:	f426                	sd	s1,40(sp)
ffffffffc0200580:	ec4e                	sd	s3,24(sp)
ffffffffc0200582:	f04a                	sd	s2,32(sp)
    pmm_manager = &slub_pmm_manager;
ffffffffc0200584:	00006417          	auipc	s0,0x6
ffffffffc0200588:	b2440413          	addi	s0,s0,-1244 # ffffffffc02060a8 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020058c:	00002517          	auipc	a0,0x2
ffffffffc0200590:	90450513          	addi	a0,a0,-1788 # ffffffffc0201e90 <etext+0x24e>
    pmm_manager = &slub_pmm_manager;
ffffffffc0200594:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200596:	bb3ff0ef          	jal	ffffffffc0200148 <cprintf>
    pmm_manager->init();
ffffffffc020059a:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020059c:	00006497          	auipc	s1,0x6
ffffffffc02005a0:	b2448493          	addi	s1,s1,-1244 # ffffffffc02060c0 <va_pa_offset>
    pmm_manager->init();
ffffffffc02005a4:	679c                	ld	a5,8(a5)
ffffffffc02005a6:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02005a8:	57f5                	li	a5,-3
ffffffffc02005aa:	07fa                	slli	a5,a5,0x1e
ffffffffc02005ac:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc02005ae:	fadff0ef          	jal	ffffffffc020055a <get_memory_base>
ffffffffc02005b2:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc02005b4:	fb1ff0ef          	jal	ffffffffc0200564 <get_memory_size>
    if (mem_size == 0) {
ffffffffc02005b8:	14050b63          	beqz	a0,ffffffffc020070e <pmm_init+0x1a0>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02005bc:	00a98933          	add	s2,s3,a0
ffffffffc02005c0:	e42a                	sd	a0,8(sp)
    cprintf("physcial memory map:\n");
ffffffffc02005c2:	00002517          	auipc	a0,0x2
ffffffffc02005c6:	91650513          	addi	a0,a0,-1770 # ffffffffc0201ed8 <etext+0x296>
ffffffffc02005ca:	b7fff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc02005ce:	65a2                	ld	a1,8(sp)
ffffffffc02005d0:	864e                	mv	a2,s3
ffffffffc02005d2:	fff90693          	addi	a3,s2,-1
ffffffffc02005d6:	00002517          	auipc	a0,0x2
ffffffffc02005da:	91a50513          	addi	a0,a0,-1766 # ffffffffc0201ef0 <etext+0x2ae>
ffffffffc02005de:	b6bff0ef          	jal	ffffffffc0200148 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc02005e2:	c80007b7          	lui	a5,0xc8000
ffffffffc02005e6:	85ca                	mv	a1,s2
ffffffffc02005e8:	0d27e163          	bltu	a5,s2,ffffffffc02006aa <pmm_init+0x13c>
ffffffffc02005ec:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02005ee:	00007697          	auipc	a3,0x7
ffffffffc02005f2:	af168693          	addi	a3,a3,-1295 # ffffffffc02070df <end+0xfff>
ffffffffc02005f6:	8efd                	and	a3,a3,a5
    npage = maxpa / PGSIZE;
ffffffffc02005f8:	81b1                	srli	a1,a1,0xc
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02005fa:	fff80837          	lui	a6,0xfff80
    npage = maxpa / PGSIZE;
ffffffffc02005fe:	00006797          	auipc	a5,0x6
ffffffffc0200602:	acb7b523          	sd	a1,-1334(a5) # ffffffffc02060c8 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200606:	00006797          	auipc	a5,0x6
ffffffffc020060a:	acd7b523          	sd	a3,-1334(a5) # ffffffffc02060d0 <pages>
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020060e:	982e                	add	a6,a6,a1
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200610:	88b6                	mv	a7,a3
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200612:	02080963          	beqz	a6,ffffffffc0200644 <pmm_init+0xd6>
ffffffffc0200616:	00259613          	slli	a2,a1,0x2
ffffffffc020061a:	962e                	add	a2,a2,a1
ffffffffc020061c:	fec007b7          	lui	a5,0xfec00
ffffffffc0200620:	97b6                	add	a5,a5,a3
ffffffffc0200622:	060e                	slli	a2,a2,0x3
ffffffffc0200624:	963e                	add	a2,a2,a5
ffffffffc0200626:	87b6                	mv	a5,a3
        SetPageReserved(pages + i);
ffffffffc0200628:	6798                	ld	a4,8(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020062a:	02878793          	addi	a5,a5,40 # fffffffffec00028 <end+0x3e9f9f48>
        SetPageReserved(pages + i);
ffffffffc020062e:	00176713          	ori	a4,a4,1
ffffffffc0200632:	fee7b023          	sd	a4,-32(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200636:	fec799e3          	bne	a5,a2,ffffffffc0200628 <pmm_init+0xba>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020063a:	00281793          	slli	a5,a6,0x2
ffffffffc020063e:	97c2                	add	a5,a5,a6
ffffffffc0200640:	078e                	slli	a5,a5,0x3
ffffffffc0200642:	96be                	add	a3,a3,a5
ffffffffc0200644:	c02007b7          	lui	a5,0xc0200
ffffffffc0200648:	0af6e763          	bltu	a3,a5,ffffffffc02006f6 <pmm_init+0x188>
ffffffffc020064c:	6098                	ld	a4,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc020064e:	77fd                	lui	a5,0xfffff
ffffffffc0200650:	00f97933          	and	s2,s2,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200654:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0200656:	0526ec63          	bltu	a3,s2,ffffffffc02006ae <pmm_init+0x140>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc020065a:	601c                	ld	a5,0(s0)
ffffffffc020065c:	7b9c                	ld	a5,48(a5)
ffffffffc020065e:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0200660:	00002517          	auipc	a0,0x2
ffffffffc0200664:	91850513          	addi	a0,a0,-1768 # ffffffffc0201f78 <etext+0x336>
ffffffffc0200668:	ae1ff0ef          	jal	ffffffffc0200148 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc020066c:	00005597          	auipc	a1,0x5
ffffffffc0200670:	99458593          	addi	a1,a1,-1644 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc0200674:	00006797          	auipc	a5,0x6
ffffffffc0200678:	a4b7b223          	sd	a1,-1468(a5) # ffffffffc02060b8 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc020067c:	c02007b7          	lui	a5,0xc0200
ffffffffc0200680:	0af5e363          	bltu	a1,a5,ffffffffc0200726 <pmm_init+0x1b8>
ffffffffc0200684:	609c                	ld	a5,0(s1)
}
ffffffffc0200686:	7442                	ld	s0,48(sp)
ffffffffc0200688:	70e2                	ld	ra,56(sp)
ffffffffc020068a:	74a2                	ld	s1,40(sp)
ffffffffc020068c:	7902                	ld	s2,32(sp)
ffffffffc020068e:	69e2                	ld	s3,24(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0200690:	40f586b3          	sub	a3,a1,a5
ffffffffc0200694:	00006797          	auipc	a5,0x6
ffffffffc0200698:	a0d7be23          	sd	a3,-1508(a5) # ffffffffc02060b0 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc020069c:	00002517          	auipc	a0,0x2
ffffffffc02006a0:	8fc50513          	addi	a0,a0,-1796 # ffffffffc0201f98 <etext+0x356>
ffffffffc02006a4:	8636                	mv	a2,a3
}
ffffffffc02006a6:	6121                	addi	sp,sp,64
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02006a8:	b445                	j	ffffffffc0200148 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc02006aa:	85be                	mv	a1,a5
ffffffffc02006ac:	b781                	j	ffffffffc02005ec <pmm_init+0x7e>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02006ae:	6705                	lui	a4,0x1
ffffffffc02006b0:	177d                	addi	a4,a4,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc02006b2:	96ba                	add	a3,a3,a4
ffffffffc02006b4:	8efd                	and	a3,a3,a5
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc02006b6:	00c6d793          	srli	a5,a3,0xc
ffffffffc02006ba:	02b7f263          	bgeu	a5,a1,ffffffffc02006de <pmm_init+0x170>
    pmm_manager->init_memmap(base, n);
ffffffffc02006be:	6018                	ld	a4,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc02006c0:	fff80637          	lui	a2,0xfff80
ffffffffc02006c4:	97b2                	add	a5,a5,a2
ffffffffc02006c6:	00279513          	slli	a0,a5,0x2
ffffffffc02006ca:	953e                	add	a0,a0,a5
ffffffffc02006cc:	6b1c                	ld	a5,16(a4)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02006ce:	40d90933          	sub	s2,s2,a3
ffffffffc02006d2:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc02006d4:	00c95593          	srli	a1,s2,0xc
ffffffffc02006d8:	9546                	add	a0,a0,a7
ffffffffc02006da:	9782                	jalr	a5
}
ffffffffc02006dc:	bfbd                	j	ffffffffc020065a <pmm_init+0xec>
        panic("pa2page called with invalid pa");
ffffffffc02006de:	00002617          	auipc	a2,0x2
ffffffffc02006e2:	86a60613          	addi	a2,a2,-1942 # ffffffffc0201f48 <etext+0x306>
ffffffffc02006e6:	06a00593          	li	a1,106
ffffffffc02006ea:	00002517          	auipc	a0,0x2
ffffffffc02006ee:	87e50513          	addi	a0,a0,-1922 # ffffffffc0201f68 <etext+0x326>
ffffffffc02006f2:	ad7ff0ef          	jal	ffffffffc02001c8 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02006f6:	00002617          	auipc	a2,0x2
ffffffffc02006fa:	82a60613          	addi	a2,a2,-2006 # ffffffffc0201f20 <etext+0x2de>
ffffffffc02006fe:	06000593          	li	a1,96
ffffffffc0200702:	00001517          	auipc	a0,0x1
ffffffffc0200706:	7c650513          	addi	a0,a0,1990 # ffffffffc0201ec8 <etext+0x286>
ffffffffc020070a:	abfff0ef          	jal	ffffffffc02001c8 <__panic>
        panic("DTB memory info not available");
ffffffffc020070e:	00001617          	auipc	a2,0x1
ffffffffc0200712:	79a60613          	addi	a2,a2,1946 # ffffffffc0201ea8 <etext+0x266>
ffffffffc0200716:	04800593          	li	a1,72
ffffffffc020071a:	00001517          	auipc	a0,0x1
ffffffffc020071e:	7ae50513          	addi	a0,a0,1966 # ffffffffc0201ec8 <etext+0x286>
ffffffffc0200722:	aa7ff0ef          	jal	ffffffffc02001c8 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200726:	86ae                	mv	a3,a1
ffffffffc0200728:	00001617          	auipc	a2,0x1
ffffffffc020072c:	7f860613          	addi	a2,a2,2040 # ffffffffc0201f20 <etext+0x2de>
ffffffffc0200730:	07b00593          	li	a1,123
ffffffffc0200734:	00001517          	auipc	a0,0x1
ffffffffc0200738:	79450513          	addi	a0,a0,1940 # ffffffffc0201ec8 <etext+0x286>
ffffffffc020073c:	a8dff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200740 <slub_init>:
    size_t max = ((PGSIZE - slab_sz) / (sz + 0.125));
    return max == 0 ? 1 : max;
}

static void init_cache_set(void) {
    cache_num = 3;
ffffffffc0200740:	470d                	li	a4,3
static void init_base(void) {
    list_init(&free_links);
    free_total = 0;
}

static void slub_init(void) {
ffffffffc0200742:	1101                	addi	sp,sp,-32
ffffffffc0200744:	00002797          	auipc	a5,0x2
ffffffffc0200748:	1dc7b687          	fld	fa3,476(a5) # ffffffffc0202920 <nbase+0x8>
    cache_num = 3;
ffffffffc020074c:	00006697          	auipc	a3,0x6
ffffffffc0200750:	98e6b623          	sd	a4,-1652(a3) # ffffffffc02060d8 <cache_num>
ffffffffc0200754:	00002797          	auipc	a5,0x2
ffffffffc0200758:	1d47b707          	fld	fa4,468(a5) # ffffffffc0202928 <nbase+0x10>
    size_t sizes[3] = {32, 64, 128};
ffffffffc020075c:	02000713          	li	a4,32
ffffffffc0200760:	e43a                	sd	a4,8(sp)
ffffffffc0200762:	04000713          	li	a4,64
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200766:	00006797          	auipc	a5,0x6
ffffffffc020076a:	91278793          	addi	a5,a5,-1774 # ffffffffc0206078 <mem_pool>
ffffffffc020076e:	e83a                	sd	a4,16(sp)
ffffffffc0200770:	08000713          	li	a4,128
ffffffffc0200774:	ec3a                	sd	a4,24(sp)
ffffffffc0200776:	e79c                	sd	a5,8(a5)
ffffffffc0200778:	e39c                	sd	a5,0(a5)
    free_total = 0;
ffffffffc020077a:	00006717          	auipc	a4,0x6
ffffffffc020077e:	90072723          	sw	zero,-1778(a4) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc0200782:	0034                	addi	a3,sp,8
ffffffffc0200784:	00006797          	auipc	a5,0x6
ffffffffc0200788:	89478793          	addi	a5,a5,-1900 # ffffffffc0206018 <cache_set>
ffffffffc020078c:	00006617          	auipc	a2,0x6
ffffffffc0200790:	8ec60613          	addi	a2,a2,-1812 # ffffffffc0206078 <mem_pool>
        cache_set[i].obj_sz = sizes[i];
ffffffffc0200794:	6298                	ld	a4,0(a3)
    for (int i = 0; i < cache_num; i++) {
ffffffffc0200796:	06a1                	addi	a3,a3,8
    size_t max = ((PGSIZE - slab_sz) / (sz + 0.125));
ffffffffc0200798:	d23777d3          	fcvt.d.lu	fa5,a4
        cache_set[i].obj_sz = sizes[i];
ffffffffc020079c:	eb98                	sd	a4,16(a5)
    size_t max = ((PGSIZE - slab_sz) / (sz + 0.125));
ffffffffc020079e:	02d7f7d3          	fadd.d	fa5,fa5,fa3
ffffffffc02007a2:	1af777d3          	fdiv.d	fa5,fa4,fa5
ffffffffc02007a6:	c2379753          	fcvt.lu.d	a4,fa5,rtz
ffffffffc02007aa:	ef98                	sd	a4,24(a5)
    return max == 0 ? 1 : max;
ffffffffc02007ac:	e311                	bnez	a4,ffffffffc02007b0 <slub_init+0x70>
ffffffffc02007ae:	4705                	li	a4,1
        cache_set[i].obj_cnt = get_obj_count(sizes[i]);
ffffffffc02007b0:	ef98                	sd	a4,24(a5)
ffffffffc02007b2:	e79c                	sd	a5,8(a5)
ffffffffc02007b4:	e39c                	sd	a5,0(a5)
    for (int i = 0; i < cache_num; i++) {
ffffffffc02007b6:	02078793          	addi	a5,a5,32
ffffffffc02007ba:	fcc79de3          	bne	a5,a2,ffffffffc0200794 <slub_init+0x54>
    init_base();
    init_cache_set();
}
ffffffffc02007be:	6105                	addi	sp,sp,32
ffffffffc02007c0:	8082                	ret

ffffffffc02007c2 <slub_get_free_pages>:
    }
}

static size_t slub_get_free_pages(void) {
    return free_total;
}
ffffffffc02007c2:	00006517          	auipc	a0,0x6
ffffffffc02007c6:	8c656503          	lwu	a0,-1850(a0) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc02007ca:	8082                	ret

ffffffffc02007cc <alloc_base_pages>:
    assert(n > 0);
ffffffffc02007cc:	cd41                	beqz	a0,ffffffffc0200864 <alloc_base_pages+0x98>
    if (n > free_total) return NULL;
ffffffffc02007ce:	00006597          	auipc	a1,0x6
ffffffffc02007d2:	8ba5a583          	lw	a1,-1862(a1) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc02007d6:	86aa                	mv	a3,a0
ffffffffc02007d8:	02059793          	slli	a5,a1,0x20
ffffffffc02007dc:	9381                	srli	a5,a5,0x20
ffffffffc02007de:	00a7ef63          	bltu	a5,a0,ffffffffc02007fc <alloc_base_pages+0x30>
    list_entry_t *le = &free_links;
ffffffffc02007e2:	00006617          	auipc	a2,0x6
ffffffffc02007e6:	89660613          	addi	a2,a2,-1898 # ffffffffc0206078 <mem_pool>
ffffffffc02007ea:	87b2                	mv	a5,a2
ffffffffc02007ec:	a029                	j	ffffffffc02007f6 <alloc_base_pages+0x2a>
        if (p->property >= n) {
ffffffffc02007ee:	ff87e703          	lwu	a4,-8(a5)
ffffffffc02007f2:	00d77763          	bgeu	a4,a3,ffffffffc0200800 <alloc_base_pages+0x34>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc02007f6:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_links) {
ffffffffc02007f8:	fec79be3          	bne	a5,a2,ffffffffc02007ee <alloc_base_pages+0x22>
    if (n > free_total) return NULL;
ffffffffc02007fc:	4501                	li	a0,0
}
ffffffffc02007fe:	8082                	ret
        if (page->property > n) {
ffffffffc0200800:	ff87a303          	lw	t1,-8(a5)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
ffffffffc0200804:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200808:	0087b883          	ld	a7,8(a5)
ffffffffc020080c:	02031713          	slli	a4,t1,0x20
ffffffffc0200810:	9301                	srli	a4,a4,0x20
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0200812:	01183423          	sd	a7,8(a6) # fffffffffff80008 <end+0x3fd79f28>
    next->prev = prev;
ffffffffc0200816:	0108b023          	sd	a6,0(a7)
        struct Page *p = le2page(le, page_link);
ffffffffc020081a:	fe878513          	addi	a0,a5,-24
        if (page->property > n) {
ffffffffc020081e:	02e6fb63          	bgeu	a3,a4,ffffffffc0200854 <alloc_base_pages+0x88>
            struct Page *p = page + n;
ffffffffc0200822:	00269713          	slli	a4,a3,0x2
ffffffffc0200826:	9736                	add	a4,a4,a3
ffffffffc0200828:	070e                	slli	a4,a4,0x3
ffffffffc020082a:	972a                	add	a4,a4,a0
            SetPageProperty(p);
ffffffffc020082c:	00873e03          	ld	t3,8(a4)
            p->property = page->property - n;
ffffffffc0200830:	40d3033b          	subw	t1,t1,a3
ffffffffc0200834:	00672823          	sw	t1,16(a4)
            SetPageProperty(p);
ffffffffc0200838:	002e6313          	ori	t1,t3,2
ffffffffc020083c:	00673423          	sd	t1,8(a4)
            list_add(prev, &(p->page_link));
ffffffffc0200840:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc0200844:	0068b023          	sd	t1,0(a7)
ffffffffc0200848:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc020084c:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc0200850:	01073c23          	sd	a6,24(a4)
        ClearPageProperty(page);
ffffffffc0200854:	ff07b703          	ld	a4,-16(a5)
        free_total -= n;
ffffffffc0200858:	9d95                	subw	a1,a1,a3
ffffffffc020085a:	ca0c                	sw	a1,16(a2)
        ClearPageProperty(page);
ffffffffc020085c:	9b75                	andi	a4,a4,-3
ffffffffc020085e:	fee7b823          	sd	a4,-16(a5)
ffffffffc0200862:	8082                	ret
static struct Page *alloc_base_pages(size_t n) {
ffffffffc0200864:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0200866:	00001697          	auipc	a3,0x1
ffffffffc020086a:	77268693          	addi	a3,a3,1906 # ffffffffc0201fd8 <etext+0x396>
ffffffffc020086e:	00001617          	auipc	a2,0x1
ffffffffc0200872:	77260613          	addi	a2,a2,1906 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc0200876:	0b100593          	li	a1,177
ffffffffc020087a:	00001517          	auipc	a0,0x1
ffffffffc020087e:	77e50513          	addi	a0,a0,1918 # ffffffffc0201ff8 <etext+0x3b6>
static struct Page *alloc_base_pages(size_t n) {
ffffffffc0200882:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200884:	945ff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200888 <slub_init_memmap>:
static void slub_init_memmap(struct Page *base, size_t n) {
ffffffffc0200888:	1141                	addi	sp,sp,-16
ffffffffc020088a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020088c:	c9e9                	beqz	a1,ffffffffc020095e <slub_init_memmap+0xd6>
    for (; p != base + n; p++) {
ffffffffc020088e:	00259713          	slli	a4,a1,0x2
ffffffffc0200892:	972e                	add	a4,a4,a1
ffffffffc0200894:	070e                	slli	a4,a4,0x3
ffffffffc0200896:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc020089a:	87aa                	mv	a5,a0
    for (; p != base + n; p++) {
ffffffffc020089c:	cf11                	beqz	a4,ffffffffc02008b8 <slub_init_memmap+0x30>
        assert(PageReserved(p));
ffffffffc020089e:	6798                	ld	a4,8(a5)
ffffffffc02008a0:	8b05                	andi	a4,a4,1
ffffffffc02008a2:	cf51                	beqz	a4,ffffffffc020093e <slub_init_memmap+0xb6>
        p->flags = p->property = 0;
ffffffffc02008a4:	0007a823          	sw	zero,16(a5)
ffffffffc02008a8:	0007b423          	sd	zero,8(a5)
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc02008ac:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++) {
ffffffffc02008b0:	02878793          	addi	a5,a5,40
ffffffffc02008b4:	fed795e3          	bne	a5,a3,ffffffffc020089e <slub_init_memmap+0x16>
    SetPageProperty(base);
ffffffffc02008b8:	6510                	ld	a2,8(a0)
    free_total += n;
ffffffffc02008ba:	00005717          	auipc	a4,0x5
ffffffffc02008be:	7ce72703          	lw	a4,1998(a4) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc02008c2:	00005697          	auipc	a3,0x5
ffffffffc02008c6:	7b668693          	addi	a3,a3,1974 # ffffffffc0206078 <mem_pool>
    return list->next == list;
ffffffffc02008ca:	669c                	ld	a5,8(a3)
    SetPageProperty(base);
ffffffffc02008cc:	00266613          	ori	a2,a2,2
    base->property = n;
ffffffffc02008d0:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02008d2:	e510                	sd	a2,8(a0)
    free_total += n;
ffffffffc02008d4:	9f2d                	addw	a4,a4,a1
ffffffffc02008d6:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_links)) {
ffffffffc02008d8:	04d78663          	beq	a5,a3,ffffffffc0200924 <slub_init_memmap+0x9c>
            struct Page *page = le2page(le, page_link);
ffffffffc02008dc:	fe878713          	addi	a4,a5,-24
ffffffffc02008e0:	4581                	li	a1,0
ffffffffc02008e2:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc02008e6:	00e56a63          	bltu	a0,a4,ffffffffc02008fa <slub_init_memmap+0x72>
    return listelm->next;
ffffffffc02008ea:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_links) {
ffffffffc02008ec:	02d70263          	beq	a4,a3,ffffffffc0200910 <slub_init_memmap+0x88>
    struct Page *p = base;
ffffffffc02008f0:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02008f2:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02008f6:	fee57ae3          	bgeu	a0,a4,ffffffffc02008ea <slub_init_memmap+0x62>
ffffffffc02008fa:	c199                	beqz	a1,ffffffffc0200900 <slub_init_memmap+0x78>
ffffffffc02008fc:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0200900:	6398                	ld	a4,0(a5)
}
ffffffffc0200902:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0200904:	e390                	sd	a2,0(a5)
ffffffffc0200906:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc0200908:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc020090a:	f11c                	sd	a5,32(a0)
ffffffffc020090c:	0141                	addi	sp,sp,16
ffffffffc020090e:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0200910:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0200912:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0200914:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0200916:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0200918:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_links) {
ffffffffc020091a:	00d70e63          	beq	a4,a3,ffffffffc0200936 <slub_init_memmap+0xae>
ffffffffc020091e:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc0200920:	87ba                	mv	a5,a4
ffffffffc0200922:	bfc1                	j	ffffffffc02008f2 <slub_init_memmap+0x6a>
}
ffffffffc0200924:	60a2                	ld	ra,8(sp)
        list_add(&free_links, &(base->page_link));
ffffffffc0200926:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc020092a:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020092c:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc020092e:	e398                	sd	a4,0(a5)
ffffffffc0200930:	e798                	sd	a4,8(a5)
}
ffffffffc0200932:	0141                	addi	sp,sp,16
ffffffffc0200934:	8082                	ret
ffffffffc0200936:	60a2                	ld	ra,8(sp)
ffffffffc0200938:	e290                	sd	a2,0(a3)
ffffffffc020093a:	0141                	addi	sp,sp,16
ffffffffc020093c:	8082                	ret
        assert(PageReserved(p));
ffffffffc020093e:	00001697          	auipc	a3,0x1
ffffffffc0200942:	6d268693          	addi	a3,a3,1746 # ffffffffc0202010 <etext+0x3ce>
ffffffffc0200946:	00001617          	auipc	a2,0x1
ffffffffc020094a:	69a60613          	addi	a2,a2,1690 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020094e:	09500593          	li	a1,149
ffffffffc0200952:	00001517          	auipc	a0,0x1
ffffffffc0200956:	6a650513          	addi	a0,a0,1702 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc020095a:	86fff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(n > 0);
ffffffffc020095e:	00001697          	auipc	a3,0x1
ffffffffc0200962:	67a68693          	addi	a3,a3,1658 # ffffffffc0201fd8 <etext+0x396>
ffffffffc0200966:	00001617          	auipc	a2,0x1
ffffffffc020096a:	67a60613          	addi	a2,a2,1658 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020096e:	09200593          	li	a1,146
ffffffffc0200972:	00001517          	auipc	a0,0x1
ffffffffc0200976:	68650513          	addi	a0,a0,1670 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc020097a:	84fff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc020097e <slub_alloc_object>:
    for (int i = 0; i < cache_num; i++) {
ffffffffc020097e:	00005697          	auipc	a3,0x5
ffffffffc0200982:	75a6b683          	ld	a3,1882(a3) # ffffffffc02060d8 <cache_num>
ffffffffc0200986:	00005f17          	auipc	t5,0x5
ffffffffc020098a:	692f0f13          	addi	t5,t5,1682 # ffffffffc0206018 <cache_set>
ffffffffc020098e:	877a                	mv	a4,t5
ffffffffc0200990:	4781                	li	a5,0
ffffffffc0200992:	e689                	bnez	a3,ffffffffc020099c <slub_alloc_object+0x1e>
ffffffffc0200994:	a069                	j	ffffffffc0200a1e <slub_alloc_object+0xa0>
ffffffffc0200996:	0785                	addi	a5,a5,1
ffffffffc0200998:	08f68363          	beq	a3,a5,ffffffffc0200a1e <slub_alloc_object+0xa0>
        if (cache_set[i].obj_sz >= sz) {
ffffffffc020099c:	01073803          	ld	a6,16(a4)
    for (int i = 0; i < cache_num; i++) {
ffffffffc02009a0:	02070713          	addi	a4,a4,32
        if (cache_set[i].obj_sz >= sz) {
ffffffffc02009a4:	fea869e3          	bltu	a6,a0,ffffffffc0200996 <slub_alloc_object+0x18>
ffffffffc02009a8:	2781                	sext.w	a5,a5
            cache = &cache_set[i];
ffffffffc02009aa:	00579713          	slli	a4,a5,0x5
ffffffffc02009ae:	00ef0eb3          	add	t4,t5,a4
    return listelm->next;
ffffffffc02009b2:	008eb883          	ld	a7,8(t4)
    while ((le = list_next(le)) != &cache->slabs) {
ffffffffc02009b6:	011e9763          	bne	t4,a7,ffffffffc02009c4 <slub_alloc_object+0x46>
ffffffffc02009ba:	a0a5                	j	ffffffffc0200a22 <slub_alloc_object+0xa4>
ffffffffc02009bc:	0088b883          	ld	a7,8(a7)
ffffffffc02009c0:	071e8163          	beq	t4,a7,ffffffffc0200a22 <slub_alloc_object+0xa4>
        if (slab->free_objs > 0) {
ffffffffc02009c4:	0108b783          	ld	a5,16(a7)
ffffffffc02009c8:	dbf5                	beqz	a5,ffffffffc02009bc <slub_alloc_object+0x3e>
            for (size_t i = 0; i < cache->obj_cnt; i++) {
ffffffffc02009ca:	018eb303          	ld	t1,24(t4)
ffffffffc02009ce:	fe0307e3          	beqz	t1,ffffffffc02009bc <slub_alloc_object+0x3e>
                if (!(slab->map[b] & (1 << bit))) {
ffffffffc02009d2:	0208be03          	ld	t3,32(a7)
            for (size_t i = 0; i < cache->obj_cnt; i++) {
ffffffffc02009d6:	4781                	li	a5,0
ffffffffc02009d8:	a021                	j	ffffffffc02009e0 <slub_alloc_object+0x62>
ffffffffc02009da:	0785                	addi	a5,a5,1
ffffffffc02009dc:	fef300e3          	beq	t1,a5,ffffffffc02009bc <slub_alloc_object+0x3e>
                size_t b = i / 8;
ffffffffc02009e0:	0037d693          	srli	a3,a5,0x3
                if (!(slab->map[b] & (1 << bit))) {
ffffffffc02009e4:	96f2                	add	a3,a3,t3
ffffffffc02009e6:	0006c583          	lbu	a1,0(a3)
ffffffffc02009ea:	0077f513          	andi	a0,a5,7
ffffffffc02009ee:	40a5d63b          	sraw	a2,a1,a0
ffffffffc02009f2:	8a05                	andi	a2,a2,1
ffffffffc02009f4:	f27d                	bnez	a2,ffffffffc02009da <slub_alloc_object+0x5c>
                    slab->map[b] |= (1 << bit);
ffffffffc02009f6:	4605                	li	a2,1
ffffffffc02009f8:	00a6163b          	sllw	a2,a2,a0
ffffffffc02009fc:	8dd1                	or	a1,a1,a2
ffffffffc02009fe:	00b68023          	sb	a1,0(a3)
                    return (void *)slab->obj_base + i * cache->obj_sz;
ffffffffc0200a02:	9f3a                	add	t5,t5,a4
ffffffffc0200a04:	010f3683          	ld	a3,16(t5)
                    slab->free_objs--;
ffffffffc0200a08:	0108b703          	ld	a4,16(a7)
                    return (void *)slab->obj_base + i * cache->obj_sz;
ffffffffc0200a0c:	0188b503          	ld	a0,24(a7)
ffffffffc0200a10:	02d787b3          	mul	a5,a5,a3
                    slab->free_objs--;
ffffffffc0200a14:	177d                	addi	a4,a4,-1
ffffffffc0200a16:	00e8b823          	sd	a4,16(a7)
                    return (void *)slab->obj_base + i * cache->obj_sz;
ffffffffc0200a1a:	953e                	add	a0,a0,a5
ffffffffc0200a1c:	8082                	ret
    if (sz <= 0) return NULL;
ffffffffc0200a1e:	4501                	li	a0,0
}
ffffffffc0200a20:	8082                	ret
    slab_t *new_slab = create_new_slab(cache->obj_sz, cache->obj_cnt);
ffffffffc0200a22:	9f3a                	add	t5,t5,a4
ffffffffc0200a24:	018f3683          	ld	a3,24(t5)
static void *slub_alloc_object(size_t sz) {
ffffffffc0200a28:	7179                	addi	sp,sp,-48
    struct Page *page = alloc_base_pages(1);
ffffffffc0200a2a:	4505                	li	a0,1
static void *slub_alloc_object(size_t sz) {
ffffffffc0200a2c:	f406                	sd	ra,40(sp)
ffffffffc0200a2e:	ec76                	sd	t4,24(sp)
ffffffffc0200a30:	e842                	sd	a6,16(sp)
    slab_t *new_slab = create_new_slab(cache->obj_sz, cache->obj_cnt);
ffffffffc0200a32:	e436                	sd	a3,8(sp)
    struct Page *page = alloc_base_pages(1);
ffffffffc0200a34:	d99ff0ef          	jal	ffffffffc02007cc <alloc_base_pages>
    if (!page) return NULL;
ffffffffc0200a38:	c541                	beqz	a0,ffffffffc0200ac0 <slub_alloc_object+0x142>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200a3a:	00005797          	auipc	a5,0x5
ffffffffc0200a3e:	6967b783          	ld	a5,1686(a5) # ffffffffc02060d0 <pages>
ffffffffc0200a42:	ccccd737          	lui	a4,0xccccd
ffffffffc0200a46:	ccd70713          	addi	a4,a4,-819 # ffffffffcccccccd <end+0xcac6bed>
ffffffffc0200a4a:	02071613          	slli	a2,a4,0x20
ffffffffc0200a4e:	40f507b3          	sub	a5,a0,a5
ffffffffc0200a52:	963a                	add	a2,a2,a4
ffffffffc0200a54:	878d                	srai	a5,a5,0x3
ffffffffc0200a56:	02c787b3          	mul	a5,a5,a2
    memset(slab->map, 0, (cnt + 7) / 8);
ffffffffc0200a5a:	66a2                	ld	a3,8(sp)
    slab->map = (unsigned char *)((void *)slab->obj_base + sz * cnt);
ffffffffc0200a5c:	6842                	ld	a6,16(sp)
ffffffffc0200a5e:	00002517          	auipc	a0,0x2
ffffffffc0200a62:	eba53503          	ld	a0,-326(a0) # ffffffffc0202918 <nbase>
    void *kva = KADDR(page2pa(page));
ffffffffc0200a66:	5775                	li	a4,-3
ffffffffc0200a68:	077a                	slli	a4,a4,0x1e
    memset(slab->map, 0, (cnt + 7) / 8);
ffffffffc0200a6a:	00768613          	addi	a2,a3,7
ffffffffc0200a6e:	820d                	srli	a2,a2,0x3
ffffffffc0200a70:	4581                	li	a1,0
    slab->map = (unsigned char *)((void *)slab->obj_base + sz * cnt);
ffffffffc0200a72:	02d80833          	mul	a6,a6,a3
ffffffffc0200a76:	97aa                	add	a5,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200a78:	07b2                	slli	a5,a5,0xc
    void *kva = KADDR(page2pa(page));
ffffffffc0200a7a:	97ba                	add	a5,a5,a4
    slab->obj_base = (void *)slab + sizeof(slab_t);
ffffffffc0200a7c:	02878513          	addi	a0,a5,40
ffffffffc0200a80:	ef88                	sd	a0,24(a5)
    slab->free_objs = cnt;
ffffffffc0200a82:	eb94                	sd	a3,16(a5)
    slab->map = (unsigned char *)((void *)slab->obj_base + sz * cnt);
ffffffffc0200a84:	e43e                	sd	a5,8(sp)
ffffffffc0200a86:	9542                	add	a0,a0,a6
ffffffffc0200a88:	f388                	sd	a0,32(a5)
    memset(slab->map, 0, (cnt + 7) / 8);
ffffffffc0200a8a:	1a6010ef          	jal	ffffffffc0201c30 <memset>
    elm->prev = elm->next = elm;
ffffffffc0200a8e:	67a2                	ld	a5,8(sp)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200a90:	6ee2                	ld	t4,24(sp)
    elm->prev = elm->next = elm;
ffffffffc0200a92:	e79c                	sd	a5,8(a5)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200a94:	008eb703          	ld	a4,8(t4)
    new_slab->map[0] |= 1;
ffffffffc0200a98:	7394                	ld	a3,32(a5)
    prev->next = next->prev = elm;
ffffffffc0200a9a:	e31c                	sd	a5,0(a4)
ffffffffc0200a9c:	00feb423          	sd	a5,8(t4)
    elm->next = next;
ffffffffc0200aa0:	e798                	sd	a4,8(a5)
    elm->prev = prev;
ffffffffc0200aa2:	01d7b023          	sd	t4,0(a5)
ffffffffc0200aa6:	0006c703          	lbu	a4,0(a3)
ffffffffc0200aaa:	00176713          	ori	a4,a4,1
ffffffffc0200aae:	00e68023          	sb	a4,0(a3)
    new_slab->free_objs--;
ffffffffc0200ab2:	6b98                	ld	a4,16(a5)
    return new_slab->obj_base;
ffffffffc0200ab4:	6f88                	ld	a0,24(a5)
    new_slab->free_objs--;
ffffffffc0200ab6:	177d                	addi	a4,a4,-1
ffffffffc0200ab8:	eb98                	sd	a4,16(a5)
}
ffffffffc0200aba:	70a2                	ld	ra,40(sp)
ffffffffc0200abc:	6145                	addi	sp,sp,48
ffffffffc0200abe:	8082                	ret
    if (sz <= 0) return NULL;
ffffffffc0200ac0:	4501                	li	a0,0
ffffffffc0200ac2:	bfe5                	j	ffffffffc0200aba <slub_alloc_object+0x13c>

ffffffffc0200ac4 <free_base_pages.part.0>:
    for (; p != base + n; p++) {
ffffffffc0200ac4:	00259713          	slli	a4,a1,0x2
ffffffffc0200ac8:	972e                	add	a4,a4,a1
ffffffffc0200aca:	070e                	slli	a4,a4,0x3
ffffffffc0200acc:	00e506b3          	add	a3,a0,a4
ffffffffc0200ad0:	87aa                	mv	a5,a0
ffffffffc0200ad2:	cf09                	beqz	a4,ffffffffc0200aec <free_base_pages.part.0+0x28>
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200ad4:	6798                	ld	a4,8(a5)
ffffffffc0200ad6:	8b0d                	andi	a4,a4,3
ffffffffc0200ad8:	10071c63          	bnez	a4,ffffffffc0200bf0 <free_base_pages.part.0+0x12c>
        p->flags = 0;
ffffffffc0200adc:	0007b423          	sd	zero,8(a5)
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200ae0:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++) {
ffffffffc0200ae4:	02878793          	addi	a5,a5,40
ffffffffc0200ae8:	fed796e3          	bne	a5,a3,ffffffffc0200ad4 <free_base_pages.part.0+0x10>
    SetPageProperty(base);
ffffffffc0200aec:	00853883          	ld	a7,8(a0)
    free_total += n;
ffffffffc0200af0:	00005717          	auipc	a4,0x5
ffffffffc0200af4:	59872703          	lw	a4,1432(a4) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc0200af8:	00005697          	auipc	a3,0x5
ffffffffc0200afc:	58068693          	addi	a3,a3,1408 # ffffffffc0206078 <mem_pool>
    return list->next == list;
ffffffffc0200b00:	669c                	ld	a5,8(a3)
    SetPageProperty(base);
ffffffffc0200b02:	0028e613          	ori	a2,a7,2
    base->property = n;
ffffffffc0200b06:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0200b08:	e510                	sd	a2,8(a0)
    free_total += n;
ffffffffc0200b0a:	9f2d                	addw	a4,a4,a1
ffffffffc0200b0c:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_links)) {
ffffffffc0200b0e:	0cd78663          	beq	a5,a3,ffffffffc0200bda <free_base_pages.part.0+0x116>
            struct Page *page = le2page(le, page_link);
ffffffffc0200b12:	fe878713          	addi	a4,a5,-24
ffffffffc0200b16:	4801                	li	a6,0
ffffffffc0200b18:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0200b1c:	00e56a63          	bltu	a0,a4,ffffffffc0200b30 <free_base_pages.part.0+0x6c>
    return listelm->next;
ffffffffc0200b20:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_links) {
ffffffffc0200b22:	06d70363          	beq	a4,a3,ffffffffc0200b88 <free_base_pages.part.0+0xc4>
    struct Page *p = base;
ffffffffc0200b26:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0200b28:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0200b2c:	fee57ae3          	bgeu	a0,a4,ffffffffc0200b20 <free_base_pages.part.0+0x5c>
ffffffffc0200b30:	00080463          	beqz	a6,ffffffffc0200b38 <free_base_pages.part.0+0x74>
ffffffffc0200b34:	0066b023          	sd	t1,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0200b38:	0007b803          	ld	a6,0(a5)
    prev->next = next->prev = elm;
ffffffffc0200b3c:	e390                	sd	a2,0(a5)
ffffffffc0200b3e:	00c83423          	sd	a2,8(a6)
    elm->prev = prev;
ffffffffc0200b42:	01053c23          	sd	a6,24(a0)
    elm->next = next;
ffffffffc0200b46:	f11c                	sd	a5,32(a0)
    if (le != &free_links) {
ffffffffc0200b48:	02d80063          	beq	a6,a3,ffffffffc0200b68 <free_base_pages.part.0+0xa4>
        if (p + p->property == base) {
ffffffffc0200b4c:	ff882e03          	lw	t3,-8(a6)
        p = le2page(le, page_link);
ffffffffc0200b50:	fe880313          	addi	t1,a6,-24
        if (p + p->property == base) {
ffffffffc0200b54:	020e1613          	slli	a2,t3,0x20
ffffffffc0200b58:	9201                	srli	a2,a2,0x20
ffffffffc0200b5a:	00261713          	slli	a4,a2,0x2
ffffffffc0200b5e:	9732                	add	a4,a4,a2
ffffffffc0200b60:	070e                	slli	a4,a4,0x3
ffffffffc0200b62:	971a                	add	a4,a4,t1
ffffffffc0200b64:	04e50d63          	beq	a0,a4,ffffffffc0200bbe <free_base_pages.part.0+0xfa>
    if (le != &free_links) {
ffffffffc0200b68:	00d78f63          	beq	a5,a3,ffffffffc0200b86 <free_base_pages.part.0+0xc2>
        if (base + base->property == p) {
ffffffffc0200b6c:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc0200b6e:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p) {
ffffffffc0200b72:	02059613          	slli	a2,a1,0x20
ffffffffc0200b76:	9201                	srli	a2,a2,0x20
ffffffffc0200b78:	00261713          	slli	a4,a2,0x2
ffffffffc0200b7c:	9732                	add	a4,a4,a2
ffffffffc0200b7e:	070e                	slli	a4,a4,0x3
ffffffffc0200b80:	972a                	add	a4,a4,a0
ffffffffc0200b82:	00e68d63          	beq	a3,a4,ffffffffc0200b9c <free_base_pages.part.0+0xd8>
ffffffffc0200b86:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0200b88:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0200b8a:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0200b8c:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0200b8e:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0200b90:	8332                	mv	t1,a2
        while ((le = list_next(le)) != &free_links) {
ffffffffc0200b92:	04d70b63          	beq	a4,a3,ffffffffc0200be8 <free_base_pages.part.0+0x124>
ffffffffc0200b96:	4805                	li	a6,1
    struct Page *p = base;
ffffffffc0200b98:	87ba                	mv	a5,a4
ffffffffc0200b9a:	b779                	j	ffffffffc0200b28 <free_base_pages.part.0+0x64>
            base->property += p->property;
ffffffffc0200b9c:	ff87a683          	lw	a3,-8(a5)
            ClearPageProperty(p);
ffffffffc0200ba0:	ff07b703          	ld	a4,-16(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200ba4:	0007b803          	ld	a6,0(a5)
ffffffffc0200ba8:	6790                	ld	a2,8(a5)
            base->property += p->property;
ffffffffc0200baa:	9ead                	addw	a3,a3,a1
ffffffffc0200bac:	c914                	sw	a3,16(a0)
            ClearPageProperty(p);
ffffffffc0200bae:	9b75                	andi	a4,a4,-3
ffffffffc0200bb0:	fee7b823          	sd	a4,-16(a5)
    prev->next = next;
ffffffffc0200bb4:	00c83423          	sd	a2,8(a6)
    next->prev = prev;
ffffffffc0200bb8:	01063023          	sd	a6,0(a2)
ffffffffc0200bbc:	8082                	ret
            p->property += base->property;
ffffffffc0200bbe:	01c585bb          	addw	a1,a1,t3
ffffffffc0200bc2:	feb82c23          	sw	a1,-8(a6)
            ClearPageProperty(base);
ffffffffc0200bc6:	ffd8f893          	andi	a7,a7,-3
ffffffffc0200bca:	01153423          	sd	a7,8(a0)
    prev->next = next;
ffffffffc0200bce:	00f83423          	sd	a5,8(a6)
    next->prev = prev;
ffffffffc0200bd2:	0107b023          	sd	a6,0(a5)
            base = p;
ffffffffc0200bd6:	851a                	mv	a0,t1
ffffffffc0200bd8:	bf41                	j	ffffffffc0200b68 <free_base_pages.part.0+0xa4>
        list_add(&free_links, &(base->page_link));
ffffffffc0200bda:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0200bde:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200be0:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0200be2:	e398                	sd	a4,0(a5)
ffffffffc0200be4:	e798                	sd	a4,8(a5)
    if (le != &free_links) {
ffffffffc0200be6:	8082                	ret
    return listelm->prev;
ffffffffc0200be8:	883e                	mv	a6,a5
ffffffffc0200bea:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200bec:	87b6                	mv	a5,a3
ffffffffc0200bee:	bfa9                	j	ffffffffc0200b48 <free_base_pages.part.0+0x84>
static void free_base_pages(struct Page *base, size_t n) {
ffffffffc0200bf0:	1141                	addi	sp,sp,-16
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200bf2:	00001697          	auipc	a3,0x1
ffffffffc0200bf6:	42e68693          	addi	a3,a3,1070 # ffffffffc0202020 <etext+0x3de>
ffffffffc0200bfa:	00001617          	auipc	a2,0x1
ffffffffc0200bfe:	3e660613          	addi	a2,a2,998 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc0200c02:	0fd00593          	li	a1,253
ffffffffc0200c06:	00001517          	auipc	a0,0x1
ffffffffc0200c0a:	3f250513          	addi	a0,a0,1010 # ffffffffc0201ff8 <etext+0x3b6>
static void free_base_pages(struct Page *base, size_t n) {
ffffffffc0200c0e:	e406                	sd	ra,8(sp)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200c10:	db8ff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200c14 <free_base_pages>:
    assert(n > 0);
ffffffffc0200c14:	c191                	beqz	a1,ffffffffc0200c18 <free_base_pages+0x4>
ffffffffc0200c16:	b57d                	j	ffffffffc0200ac4 <free_base_pages.part.0>
static void free_base_pages(struct Page *base, size_t n) {
ffffffffc0200c18:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0200c1a:	00001697          	auipc	a3,0x1
ffffffffc0200c1e:	3be68693          	addi	a3,a3,958 # ffffffffc0201fd8 <etext+0x396>
ffffffffc0200c22:	00001617          	auipc	a2,0x1
ffffffffc0200c26:	3be60613          	addi	a2,a2,958 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc0200c2a:	0fa00593          	li	a1,250
ffffffffc0200c2e:	00001517          	auipc	a0,0x1
ffffffffc0200c32:	3ca50513          	addi	a0,a0,970 # ffffffffc0201ff8 <etext+0x3b6>
static void free_base_pages(struct Page *base, size_t n) {
ffffffffc0200c36:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200c38:	d90ff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200c3c <slub_free_object>:
    for (size_t i = 0; i < cache_num; i++) {
ffffffffc0200c3c:	00005897          	auipc	a7,0x5
ffffffffc0200c40:	49c8b883          	ld	a7,1180(a7) # ffffffffc02060d8 <cache_num>
ffffffffc0200c44:	04088d63          	beqz	a7,ffffffffc0200c9e <slub_free_object+0x62>
ffffffffc0200c48:	00005317          	auipc	t1,0x5
ffffffffc0200c4c:	3d030313          	addi	t1,t1,976 # ffffffffc0206018 <cache_set>
ffffffffc0200c50:	861a                	mv	a2,t1
ffffffffc0200c52:	4801                	li	a6,0
    return listelm->next;
ffffffffc0200c54:	6614                	ld	a3,8(a2)
        while ((le = list_next(le)) != &cache->slabs) {
ffffffffc0200c56:	00c68f63          	beq	a3,a2,ffffffffc0200c74 <slub_free_object+0x38>
            if (obj >= slab->obj_base && obj < (slab->obj_base + cache->obj_sz * cache->obj_cnt)) {
ffffffffc0200c5a:	6e98                	ld	a4,24(a3)
ffffffffc0200c5c:	00e56963          	bltu	a0,a4,ffffffffc0200c6e <slub_free_object+0x32>
ffffffffc0200c60:	6a0c                	ld	a1,16(a2)
ffffffffc0200c62:	6e1c                	ld	a5,24(a2)
ffffffffc0200c64:	02f587b3          	mul	a5,a1,a5
ffffffffc0200c68:	97ba                	add	a5,a5,a4
ffffffffc0200c6a:	00f56b63          	bltu	a0,a5,ffffffffc0200c80 <slub_free_object+0x44>
ffffffffc0200c6e:	6694                	ld	a3,8(a3)
        while ((le = list_next(le)) != &cache->slabs) {
ffffffffc0200c70:	fec695e3          	bne	a3,a2,ffffffffc0200c5a <slub_free_object+0x1e>
    for (size_t i = 0; i < cache_num; i++) {
ffffffffc0200c74:	0805                	addi	a6,a6,1
ffffffffc0200c76:	02060613          	addi	a2,a2,32
ffffffffc0200c7a:	fd089de3          	bne	a7,a6,ffffffffc0200c54 <slub_free_object+0x18>
ffffffffc0200c7e:	8082                	ret
                size_t off = (char *)obj - (char *)slab->obj_base;
ffffffffc0200c80:	40e50733          	sub	a4,a0,a4
                size_t idx = off / cache->obj_sz;
ffffffffc0200c84:	02b75733          	divu	a4,a4,a1
                if (slab->map[b] & (1 << bit)) {
ffffffffc0200c88:	729c                	ld	a5,32(a3)
                size_t b = idx / 8;
ffffffffc0200c8a:	00375613          	srli	a2,a4,0x3
                if (slab->map[b] & (1 << bit)) {
ffffffffc0200c8e:	97b2                	add	a5,a5,a2
ffffffffc0200c90:	0007c583          	lbu	a1,0(a5)
ffffffffc0200c94:	8b1d                	andi	a4,a4,7
ffffffffc0200c96:	40e5d63b          	sraw	a2,a1,a4
ffffffffc0200c9a:	8a05                	andi	a2,a2,1
ffffffffc0200c9c:	e211                	bnez	a2,ffffffffc0200ca0 <slub_free_object+0x64>
ffffffffc0200c9e:	8082                	ret
                    slab->map[b] &= ~(1 << bit);
ffffffffc0200ca0:	4605                	li	a2,1
ffffffffc0200ca2:	00e6173b          	sllw	a4,a2,a4
static void slub_free_object(void *obj) {
ffffffffc0200ca6:	1101                	addi	sp,sp,-32
                    slab->map[b] &= ~(1 << bit);
ffffffffc0200ca8:	fff74713          	not	a4,a4
ffffffffc0200cac:	8df9                	and	a1,a1,a4
static void slub_free_object(void *obj) {
ffffffffc0200cae:	ec06                	sd	ra,24(sp)
                    slab->map[b] &= ~(1 << bit);
ffffffffc0200cb0:	00b78023          	sb	a1,0(a5)
                    slab->free_objs++;
ffffffffc0200cb4:	6a9c                	ld	a5,16(a3)
                    memset(obj, 0, cache->obj_sz);
ffffffffc0200cb6:	0816                	slli	a6,a6,0x5
ffffffffc0200cb8:	9342                	add	t1,t1,a6
ffffffffc0200cba:	01033603          	ld	a2,16(t1)
                    slab->free_objs++;
ffffffffc0200cbe:	0785                	addi	a5,a5,1
ffffffffc0200cc0:	ea9c                	sd	a5,16(a3)
                    memset(obj, 0, cache->obj_sz);
ffffffffc0200cc2:	4581                	li	a1,0
ffffffffc0200cc4:	e41a                	sd	t1,8(sp)
                    slab->free_objs++;
ffffffffc0200cc6:	e036                	sd	a3,0(sp)
                    memset(obj, 0, cache->obj_sz);
ffffffffc0200cc8:	769000ef          	jal	ffffffffc0201c30 <memset>
                    if (slab->free_objs == cache->obj_cnt) {
ffffffffc0200ccc:	6322                	ld	t1,8(sp)
ffffffffc0200cce:	6682                	ld	a3,0(sp)
ffffffffc0200cd0:	01833783          	ld	a5,24(t1)
ffffffffc0200cd4:	6a98                	ld	a4,16(a3)
ffffffffc0200cd6:	04f71963          	bne	a4,a5,ffffffffc0200d28 <slub_free_object+0xec>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200cda:	6298                	ld	a4,0(a3)
ffffffffc0200cdc:	669c                	ld	a5,8(a3)
                        free_base_pages(pa2page(PADDR(slab)), 1);
ffffffffc0200cde:	c0200637          	lui	a2,0xc0200
    prev->next = next;
ffffffffc0200ce2:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0200ce4:	e398                	sd	a4,0(a5)
ffffffffc0200ce6:	06c6e063          	bltu	a3,a2,ffffffffc0200d46 <slub_free_object+0x10a>
ffffffffc0200cea:	00005797          	auipc	a5,0x5
ffffffffc0200cee:	3d67b783          	ld	a5,982(a5) # ffffffffc02060c0 <va_pa_offset>
    if (PPN(pa) >= npage) {
ffffffffc0200cf2:	00005717          	auipc	a4,0x5
ffffffffc0200cf6:	3d673703          	ld	a4,982(a4) # ffffffffc02060c8 <npage>
ffffffffc0200cfa:	40f687b3          	sub	a5,a3,a5
ffffffffc0200cfe:	83b1                	srli	a5,a5,0xc
ffffffffc0200d00:	02e7f763          	bgeu	a5,a4,ffffffffc0200d2e <slub_free_object+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0200d04:	00002717          	auipc	a4,0x2
ffffffffc0200d08:	c1473703          	ld	a4,-1004(a4) # ffffffffc0202918 <nbase>
ffffffffc0200d0c:	00005517          	auipc	a0,0x5
ffffffffc0200d10:	3c453503          	ld	a0,964(a0) # ffffffffc02060d0 <pages>
}
ffffffffc0200d14:	60e2                	ld	ra,24(sp)
ffffffffc0200d16:	8f99                	sub	a5,a5,a4
ffffffffc0200d18:	00279713          	slli	a4,a5,0x2
ffffffffc0200d1c:	97ba                	add	a5,a5,a4
ffffffffc0200d1e:	078e                	slli	a5,a5,0x3
ffffffffc0200d20:	4585                	li	a1,1
ffffffffc0200d22:	953e                	add	a0,a0,a5
ffffffffc0200d24:	6105                	addi	sp,sp,32
ffffffffc0200d26:	bb79                	j	ffffffffc0200ac4 <free_base_pages.part.0>
ffffffffc0200d28:	60e2                	ld	ra,24(sp)
ffffffffc0200d2a:	6105                	addi	sp,sp,32
ffffffffc0200d2c:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0200d2e:	00001617          	auipc	a2,0x1
ffffffffc0200d32:	21a60613          	addi	a2,a2,538 # ffffffffc0201f48 <etext+0x306>
ffffffffc0200d36:	06a00593          	li	a1,106
ffffffffc0200d3a:	00001517          	auipc	a0,0x1
ffffffffc0200d3e:	22e50513          	addi	a0,a0,558 # ffffffffc0201f68 <etext+0x326>
ffffffffc0200d42:	c86ff0ef          	jal	ffffffffc02001c8 <__panic>
                        free_base_pages(pa2page(PADDR(slab)), 1);
ffffffffc0200d46:	00001617          	auipc	a2,0x1
ffffffffc0200d4a:	1da60613          	addi	a2,a2,474 # ffffffffc0201f20 <etext+0x2de>
ffffffffc0200d4e:	13800593          	li	a1,312
ffffffffc0200d52:	00001517          	auipc	a0,0x1
ffffffffc0200d56:	2a650513          	addi	a0,a0,678 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0200d5a:	c6eff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200d5e <slub_run_tests>:

static void slub_run_tests(void) {
ffffffffc0200d5e:	7159                	addi	sp,sp,-112
ffffffffc0200d60:	fff9e2b7          	lui	t0,0xfff9e
ffffffffc0200d64:	f486                	sd	ra,104(sp)
ffffffffc0200d66:	f0a2                	sd	s0,96(sp)
ffffffffc0200d68:	eca6                	sd	s1,88(sp)
ffffffffc0200d6a:	1880                	addi	s0,sp,112
ffffffffc0200d6c:	e8ca                	sd	s2,80(sp)
ffffffffc0200d6e:	e4ce                	sd	s3,72(sp)
ffffffffc0200d70:	e0d2                	sd	s4,64(sp)
ffffffffc0200d72:	fc56                	sd	s5,56(sp)
ffffffffc0200d74:	f85a                	sd	s6,48(sp)
ffffffffc0200d76:	f45e                	sd	s7,40(sp)
ffffffffc0200d78:	f062                	sd	s8,32(sp)
ffffffffc0200d7a:	ec66                	sd	s9,24(sp)
ffffffffc0200d7c:	e86a                	sd	s10,16(sp)
ffffffffc0200d7e:	e46e                	sd	s11,8(sp)
ffffffffc0200d80:	55028293          	addi	t0,t0,1360 # fffffffffff9e550 <end+0x3fd98470>
    cprintf("Starting SLUB allocator tests...\n\n");
ffffffffc0200d84:	00001517          	auipc	a0,0x1
ffffffffc0200d88:	2c450513          	addi	a0,a0,708 # ffffffffc0202048 <etext+0x406>
static void slub_run_tests(void) {
ffffffffc0200d8c:	9116                	add	sp,sp,t0
    cprintf("Starting SLUB allocator tests...\n\n");
ffffffffc0200d8e:	bbaff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("The slab struct size is %d\n", sizeof(slab_t));
ffffffffc0200d92:	02800593          	li	a1,40
ffffffffc0200d96:	00001517          	auipc	a0,0x1
ffffffffc0200d9a:	2da50513          	addi	a0,a0,730 # ffffffffc0202070 <etext+0x42e>
ffffffffc0200d9e:	baaff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("----------------------START-------------------------\n");
ffffffffc0200da2:	00001517          	auipc	a0,0x1
ffffffffc0200da6:	2ee50513          	addi	a0,a0,750 # ffffffffc0202090 <etext+0x44e>
ffffffffc0200daa:	b9eff0ef          	jal	ffffffffc0200148 <cprintf>
    size_t exp[3] = {126, 63, 31};
ffffffffc0200dae:	fff9e5b7          	lui	a1,0xfff9e
ffffffffc0200db2:	4f058593          	addi	a1,a1,1264 # fffffffffff9e4f0 <end+0x3fd98410>
ffffffffc0200db6:	07e00693          	li	a3,126
ffffffffc0200dba:	95a2                	add	a1,a1,s0
ffffffffc0200dbc:	e194                	sd	a3,0(a1)
ffffffffc0200dbe:	fff9e637          	lui	a2,0xfff9e
ffffffffc0200dc2:	fff9e6b7          	lui	a3,0xfff9e
ffffffffc0200dc6:	4f860613          	addi	a2,a2,1272 # fffffffffff9e4f8 <end+0x3fd98418>
ffffffffc0200dca:	50068693          	addi	a3,a3,1280 # fffffffffff9e500 <end+0x3fd98420>
    for (int i = 0; i < cache_num; i++) {
ffffffffc0200dce:	00005517          	auipc	a0,0x5
ffffffffc0200dd2:	30a53503          	ld	a0,778(a0) # ffffffffc02060d8 <cache_num>
    size_t exp[3] = {126, 63, 31};
ffffffffc0200dd6:	03f00713          	li	a4,63
ffffffffc0200dda:	47fd                	li	a5,31
ffffffffc0200ddc:	9622                	add	a2,a2,s0
ffffffffc0200dde:	96a2                	add	a3,a3,s0
ffffffffc0200de0:	e218                	sd	a4,0(a2)
ffffffffc0200de2:	e29c                	sd	a5,0(a3)
    for (int i = 0; i < cache_num; i++) {
ffffffffc0200de4:	c10d                	beqz	a0,ffffffffc0200e06 <slub_run_tests+0xa8>
ffffffffc0200de6:	87ae                	mv	a5,a1
ffffffffc0200de8:	00005697          	auipc	a3,0x5
ffffffffc0200dec:	23068693          	addi	a3,a3,560 # ffffffffc0206018 <cache_set>
ffffffffc0200df0:	4701                	li	a4,0
        assert(cache_set[i].obj_cnt == exp[i]);
ffffffffc0200df2:	6e8c                	ld	a1,24(a3)
ffffffffc0200df4:	6390                	ld	a2,0(a5)
ffffffffc0200df6:	66c59263          	bne	a1,a2,ffffffffc020145a <slub_run_tests+0x6fc>
    for (int i = 0; i < cache_num; i++) {
ffffffffc0200dfa:	0705                	addi	a4,a4,1
ffffffffc0200dfc:	02068693          	addi	a3,a3,32
ffffffffc0200e00:	07a1                	addi	a5,a5,8
ffffffffc0200e02:	fee518e3          	bne	a0,a4,ffffffffc0200df2 <slub_run_tests+0x94>
    }
    size_t init_free = free_total;
    {
        void *obj = slub_alloc_object(0);
        assert(obj == NULL);
        obj = slub_alloc_object(256);
ffffffffc0200e06:	10000513          	li	a0,256
    size_t init_free = free_total;
ffffffffc0200e0a:	00005a17          	auipc	s4,0x5
ffffffffc0200e0e:	27ea2a03          	lw	s4,638(s4) # ffffffffc0206088 <mem_pool+0x10>
        obj = slub_alloc_object(256);
ffffffffc0200e12:	b6dff0ef          	jal	ffffffffc020097e <slub_alloc_object>
        assert(obj == NULL);
ffffffffc0200e16:	62051263          	bnez	a0,ffffffffc020143a <slub_run_tests+0x6dc>
        cprintf("Boundary check passed. \n");
ffffffffc0200e1a:	00001517          	auipc	a0,0x1
ffffffffc0200e1e:	2de50513          	addi	a0,a0,734 # ffffffffc02020f8 <etext+0x4b6>
ffffffffc0200e22:	b26ff0ef          	jal	ffffffffc0200148 <cprintf>
    }
    {
        void *obj1 = slub_alloc_object(32);
ffffffffc0200e26:	02000513          	li	a0,32
ffffffffc0200e2a:	b55ff0ef          	jal	ffffffffc020097e <slub_alloc_object>
ffffffffc0200e2e:	84aa                	mv	s1,a0
        assert(obj1 != NULL);
ffffffffc0200e30:	5e050563          	beqz	a0,ffffffffc020141a <slub_run_tests+0x6bc>
        cprintf("Allocated 32-byte object at %p\n", obj1);
ffffffffc0200e34:	85aa                	mv	a1,a0
ffffffffc0200e36:	00001517          	auipc	a0,0x1
ffffffffc0200e3a:	2f250513          	addi	a0,a0,754 # ffffffffc0202128 <etext+0x4e6>
ffffffffc0200e3e:	b0aff0ef          	jal	ffffffffc0200148 <cprintf>
        memset(obj1, 0x66, 32);
ffffffffc0200e42:	02000613          	li	a2,32
ffffffffc0200e46:	8526                	mv	a0,s1
ffffffffc0200e48:	06600593          	li	a1,102
ffffffffc0200e4c:	5e5000ef          	jal	ffffffffc0201c30 <memset>
        for (int i = 0; i < 32; i++) {
ffffffffc0200e50:	87a6                	mv	a5,s1
ffffffffc0200e52:	02048613          	addi	a2,s1,32
            assert(((unsigned char *)obj1)[i] == 0x66);
ffffffffc0200e56:	06600693          	li	a3,102
ffffffffc0200e5a:	0007c703          	lbu	a4,0(a5)
ffffffffc0200e5e:	58d71e63          	bne	a4,a3,ffffffffc02013fa <slub_run_tests+0x69c>
        for (int i = 0; i < 32; i++) {
ffffffffc0200e62:	0785                	addi	a5,a5,1
ffffffffc0200e64:	fec79be3          	bne	a5,a2,ffffffffc0200e5a <slub_run_tests+0xfc>
        }
        cprintf("Memory alloc verification passed. \n");
ffffffffc0200e68:	00001517          	auipc	a0,0x1
ffffffffc0200e6c:	30850513          	addi	a0,a0,776 # ffffffffc0202170 <etext+0x52e>
ffffffffc0200e70:	ad8ff0ef          	jal	ffffffffc0200148 <cprintf>
        slub_free_object(obj1);
ffffffffc0200e74:	8526                	mv	a0,s1
ffffffffc0200e76:	dc7ff0ef          	jal	ffffffffc0200c3c <slub_free_object>
        void *obj2 = slub_alloc_object(32);
ffffffffc0200e7a:	02000513          	li	a0,32
ffffffffc0200e7e:	b01ff0ef          	jal	ffffffffc020097e <slub_alloc_object>
ffffffffc0200e82:	84aa                	mv	s1,a0
        cprintf("Allocated 32-byte object at %p\n", obj2);
ffffffffc0200e84:	85aa                	mv	a1,a0
ffffffffc0200e86:	00001517          	auipc	a0,0x1
ffffffffc0200e8a:	2a250513          	addi	a0,a0,674 # ffffffffc0202128 <etext+0x4e6>
ffffffffc0200e8e:	abaff0ef          	jal	ffffffffc0200148 <cprintf>
        for (int i = 0; i < 32; i++) {
ffffffffc0200e92:	87a6                	mv	a5,s1
ffffffffc0200e94:	02048693          	addi	a3,s1,32
            assert(((unsigned char *)obj2)[i] == 0x00);
ffffffffc0200e98:	0007c703          	lbu	a4,0(a5)
ffffffffc0200e9c:	0a071fe3          	bnez	a4,ffffffffc020175a <slub_run_tests+0x9fc>
        for (int i = 0; i < 32; i++) {
ffffffffc0200ea0:	0785                	addi	a5,a5,1
ffffffffc0200ea2:	fed79be3          	bne	a5,a3,ffffffffc0200e98 <slub_run_tests+0x13a>
        }
        slub_free_object(obj2);
ffffffffc0200ea6:	8526                	mv	a0,s1
ffffffffc0200ea8:	d95ff0ef          	jal	ffffffffc0200c3c <slub_free_object>
        cprintf("Memory free verification passed. \n");
ffffffffc0200eac:	00001517          	auipc	a0,0x1
ffffffffc0200eb0:	31450513          	addi	a0,a0,788 # ffffffffc02021c0 <etext+0x57e>
ffffffffc0200eb4:	a94ff0ef          	jal	ffffffffc0200148 <cprintf>
    }
    {
ffffffffc0200eb8:	898a                	mv	s3,sp
        const int cnt = 10;
        void *objs[cnt];
        cprintf("Allocating %d objects of size 64 bytes.\n", cnt);
ffffffffc0200eba:	45a9                	li	a1,10
        void *objs[cnt];
ffffffffc0200ebc:	715d                	addi	sp,sp,-80
        cprintf("Allocating %d objects of size 64 bytes.\n", cnt);
ffffffffc0200ebe:	00001517          	auipc	a0,0x1
ffffffffc0200ec2:	32a50513          	addi	a0,a0,810 # ffffffffc02021e8 <etext+0x5a6>
        void *objs[cnt];
ffffffffc0200ec6:	8b0a                	mv	s6,sp
        cprintf("Allocating %d objects of size 64 bytes.\n", cnt);
ffffffffc0200ec8:	a80ff0ef          	jal	ffffffffc0200148 <cprintf>
        for (int i = 0; i < cnt; i++) {
ffffffffc0200ecc:	890a                	mv	s2,sp
        cprintf("Allocating %d objects of size 64 bytes.\n", cnt);
ffffffffc0200ece:	8a8a                	mv	s5,sp
        for (int i = 0; i < cnt; i++) {
ffffffffc0200ed0:	4481                	li	s1,0
ffffffffc0200ed2:	4ba9                	li	s7,10
            objs[i] = slub_alloc_object(64);
ffffffffc0200ed4:	04000513          	li	a0,64
ffffffffc0200ed8:	aa7ff0ef          	jal	ffffffffc020097e <slub_alloc_object>
ffffffffc0200edc:	00aab023          	sd	a0,0(s5)
            assert(objs[i] != NULL);
ffffffffc0200ee0:	04050de3          	beqz	a0,ffffffffc020173a <slub_run_tests+0x9dc>
            memset(objs[i], i, 64);
ffffffffc0200ee4:	0ff4f593          	zext.b	a1,s1
ffffffffc0200ee8:	04000613          	li	a2,64
        for (int i = 0; i < cnt; i++) {
ffffffffc0200eec:	2485                	addiw	s1,s1,1
            memset(objs[i], i, 64);
ffffffffc0200eee:	543000ef          	jal	ffffffffc0201c30 <memset>
        for (int i = 0; i < cnt; i++) {
ffffffffc0200ef2:	0aa1                	addi	s5,s5,8
ffffffffc0200ef4:	ff7490e3          	bne	s1,s7,ffffffffc0200ed4 <slub_run_tests+0x176>
ffffffffc0200ef8:	855a                	mv	a0,s6
        }
        for (int i = 0; i < cnt; i++) {
ffffffffc0200efa:	4581                	li	a1,0
ffffffffc0200efc:	4829                	li	a6,10
            for (int j = 0; j < 64; j++) {
ffffffffc0200efe:	611c                	ld	a5,0(a0)
ffffffffc0200f00:	0ff5f613          	zext.b	a2,a1
ffffffffc0200f04:	04078693          	addi	a3,a5,64
                assert(((unsigned char *)objs[i])[j] == (unsigned char)i);
ffffffffc0200f08:	0007c703          	lbu	a4,0(a5)
ffffffffc0200f0c:	44c71763          	bne	a4,a2,ffffffffc020135a <slub_run_tests+0x5fc>
            for (int j = 0; j < 64; j++) {
ffffffffc0200f10:	0785                	addi	a5,a5,1
ffffffffc0200f12:	fed79be3          	bne	a5,a3,ffffffffc0200f08 <slub_run_tests+0x1aa>
        for (int i = 0; i < cnt; i++) {
ffffffffc0200f16:	2585                	addiw	a1,a1,1
ffffffffc0200f18:	0521                	addi	a0,a0,8
ffffffffc0200f1a:	ff0592e3          	bne	a1,a6,ffffffffc0200efe <slub_run_tests+0x1a0>
            }
        }
        cprintf("Memory verification for 64-byte objects passed.\n");
ffffffffc0200f1e:	00001517          	auipc	a0,0x1
ffffffffc0200f22:	34250513          	addi	a0,a0,834 # ffffffffc0202260 <etext+0x61e>
ffffffffc0200f26:	a22ff0ef          	jal	ffffffffc0200148 <cprintf>
        for (int i = 0; i < cnt; i++) {
ffffffffc0200f2a:	050b0b13          	addi	s6,s6,80
            slub_free_object(objs[i]);
ffffffffc0200f2e:	00093483          	ld	s1,0(s2)
ffffffffc0200f32:	8526                	mv	a0,s1
ffffffffc0200f34:	d09ff0ef          	jal	ffffffffc0200c3c <slub_free_object>
            cprintf("Freed 64-byte object at %p\n", objs[i]);
ffffffffc0200f38:	85a6                	mv	a1,s1
ffffffffc0200f3a:	00001517          	auipc	a0,0x1
ffffffffc0200f3e:	35e50513          	addi	a0,a0,862 # ffffffffc0202298 <etext+0x656>
ffffffffc0200f42:	a06ff0ef          	jal	ffffffffc0200148 <cprintf>
            for (int j = 0; j < 64; j++) {
ffffffffc0200f46:	85a6                	mv	a1,s1
ffffffffc0200f48:	04048713          	addi	a4,s1,64
                assert(((unsigned char *)objs[i])[j] == 0x00);
ffffffffc0200f4c:	0005c783          	lbu	a5,0(a1)
ffffffffc0200f50:	42079563          	bnez	a5,ffffffffc020137a <slub_run_tests+0x61c>
            for (int j = 0; j < 64; j++) {
ffffffffc0200f54:	0585                	addi	a1,a1,1
ffffffffc0200f56:	fee59be3          	bne	a1,a4,ffffffffc0200f4c <slub_run_tests+0x1ee>
        for (int i = 0; i < cnt; i++) {
ffffffffc0200f5a:	0921                	addi	s2,s2,8
ffffffffc0200f5c:	fd6919e3          	bne	s2,s6,ffffffffc0200f2e <slub_run_tests+0x1d0>
            }
        }
        cprintf("Memory free verification for 64-byte objects passed.\n");
ffffffffc0200f60:	00001517          	auipc	a0,0x1
ffffffffc0200f64:	38050513          	addi	a0,a0,896 # ffffffffc02022e0 <etext+0x69e>
ffffffffc0200f68:	9e0ff0ef          	jal	ffffffffc0200148 <cprintf>
    }
    {
        size_t f2, f3, f4;
        cprintf("Bulk allocation release check start.\n");
ffffffffc0200f6c:	00001517          	auipc	a0,0x1
ffffffffc0200f70:	3ac50513          	addi	a0,a0,940 # ffffffffc0202318 <etext+0x6d6>
ffffffffc0200f74:	814e                	mv	sp,s3
ffffffffc0200f76:	9d2ff0ef          	jal	ffffffffc0200148 <cprintf>
        assert(init_free == free_total);
ffffffffc0200f7a:	00005797          	auipc	a5,0x5
ffffffffc0200f7e:	10e7a783          	lw	a5,270(a5) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc0200f82:	41479c63          	bne	a5,s4,ffffffffc020139a <slub_run_tests+0x63c>
ffffffffc0200f86:	fff9e7b7          	lui	a5,0xfff9e
ffffffffc0200f8a:	51078793          	addi	a5,a5,1296 # fffffffffff9e510 <end+0x3fd98430>
ffffffffc0200f8e:	6bd1                	lui	s7,0x14
        void *bulk[50000];
        for (int i = 1; i <= 10000; i++) {
            bulk[i - 1] = slub_alloc_object(25);
            assert(free_total == init_free - (i + 125) / 126);
ffffffffc0200f90:	41041c37          	lui	s8,0x41041
ffffffffc0200f94:	00f40ab3          	add	s5,s0,a5
    size_t init_free = free_total;
ffffffffc0200f98:	020a1493          	slli	s1,s4,0x20
ffffffffc0200f9c:	880b8b93          	addi	s7,s7,-1920 # 13880 <kern_entry-0xffffffffc01ec780>
            assert(free_total == init_free - (i + 125) / 126);
ffffffffc0200fa0:	0c06                	slli	s8,s8,0x1
    size_t init_free = free_total;
ffffffffc0200fa2:	9081                	srli	s1,s1,0x20
ffffffffc0200fa4:	9bd6                	add	s7,s7,s5
ffffffffc0200fa6:	8956                	mv	s2,s5
            assert(free_total == init_free - (i + 125) / 126);
ffffffffc0200fa8:	083c0c13          	addi	s8,s8,131 # 41041083 <kern_entry-0xffffffff7f1bef7d>
    size_t init_free = free_total;
ffffffffc0200fac:	07e00993          	li	s3,126
            assert(free_total == init_free - (i + 125) / 126);
ffffffffc0200fb0:	0019db1b          	srliw	s6,s3,0x1
ffffffffc0200fb4:	038b0b33          	mul	s6,s6,s8
            bulk[i - 1] = slub_alloc_object(25);
ffffffffc0200fb8:	4565                	li	a0,25
ffffffffc0200fba:	9c5ff0ef          	jal	ffffffffc020097e <slub_alloc_object>
            assert(free_total == init_free - (i + 125) / 126);
ffffffffc0200fbe:	00005797          	auipc	a5,0x5
ffffffffc0200fc2:	0ca7e783          	lwu	a5,202(a5) # ffffffffc0206088 <mem_pool+0x10>
            bulk[i - 1] = slub_alloc_object(25);
ffffffffc0200fc6:	00a93023          	sd	a0,0(s2)
            assert(free_total == init_free - (i + 125) / 126);
ffffffffc0200fca:	025b5b13          	srli	s6,s6,0x25
ffffffffc0200fce:	41648b33          	sub	s6,s1,s6
ffffffffc0200fd2:	71679463          	bne	a5,s6,ffffffffc02016da <slub_run_tests+0x97c>
        for (int i = 1; i <= 10000; i++) {
ffffffffc0200fd6:	0921                	addi	s2,s2,8
ffffffffc0200fd8:	2985                	addiw	s3,s3,1
ffffffffc0200fda:	fd791be3          	bne	s2,s7,ffffffffc0200fb0 <slub_run_tests+0x252>
ffffffffc0200fde:	00027cb7          	lui	s9,0x27
ffffffffc0200fe2:	100c8c93          	addi	s9,s9,256 # 27100 <kern_entry-0xffffffffc01d8f00>
        }
        f2 = free_total;
        for (int i = 1; i <= 10000; i++) {
            bulk[i + 9999] = slub_alloc_object(62);
            assert(free_total == f2 - (i + 62) / 63);
ffffffffc0200fe6:	820829b7          	lui	s3,0x82082
ffffffffc0200fea:	9cd6                	add	s9,s9,s5
ffffffffc0200fec:	08398993          	addi	s3,s3,131 # ffffffff82082083 <kern_entry-0x3e17df7d>
        for (int i = 1; i <= 10000; i++) {
ffffffffc0200ff0:	03f00c13          	li	s8,63
            assert(free_total == f2 - (i + 62) / 63);
ffffffffc0200ff4:	033c0933          	mul	s2,s8,s3
            bulk[i + 9999] = slub_alloc_object(62);
ffffffffc0200ff8:	03e00513          	li	a0,62
ffffffffc0200ffc:	983ff0ef          	jal	ffffffffc020097e <slub_alloc_object>
            assert(free_total == f2 - (i + 62) / 63);
ffffffffc0201000:	41fc579b          	sraiw	a5,s8,0x1f
ffffffffc0201004:	00005717          	auipc	a4,0x5
ffffffffc0201008:	08476703          	lwu	a4,132(a4) # ffffffffc0206088 <mem_pool+0x10>
            bulk[i + 9999] = slub_alloc_object(62);
ffffffffc020100c:	00abb023          	sd	a0,0(s7)
            assert(free_total == f2 - (i + 62) / 63);
ffffffffc0201010:	02095913          	srli	s2,s2,0x20
ffffffffc0201014:	012c093b          	addw	s2,s8,s2
ffffffffc0201018:	4059591b          	sraiw	s2,s2,0x5
ffffffffc020101c:	40f9093b          	subw	s2,s2,a5
ffffffffc0201020:	412b0933          	sub	s2,s6,s2
ffffffffc0201024:	69271b63          	bne	a4,s2,ffffffffc02016ba <slub_run_tests+0x95c>
        for (int i = 1; i <= 10000; i++) {
ffffffffc0201028:	0ba1                	addi	s7,s7,8
ffffffffc020102a:	2c05                	addiw	s8,s8,1
ffffffffc020102c:	fd9b94e3          	bne	s7,s9,ffffffffc0200ff4 <slub_run_tests+0x296>
ffffffffc0201030:	0003b9b7          	lui	s3,0x3b
ffffffffc0201034:	98098993          	addi	s3,s3,-1664 # 3a980 <kern_entry-0xffffffffc01c5680>
        }
        f3 = free_total;
        for (int i = 1; i <= 10000; i++) {
            bulk[i + 19999] = slub_alloc_object(124);
            assert(free_total == f3 - (i + 30) / 31);
ffffffffc0201038:	84211b37          	lui	s6,0x84211
ffffffffc020103c:	99d6                	add	s3,s3,s5
ffffffffc020103e:	843b0b13          	addi	s6,s6,-1981 # ffffffff84210843 <kern_entry-0x3bfef7bd>
        for (int i = 1; i <= 10000; i++) {
ffffffffc0201042:	4bfd                	li	s7,31
            bulk[i + 19999] = slub_alloc_object(124);
ffffffffc0201044:	07c00513          	li	a0,124
ffffffffc0201048:	937ff0ef          	jal	ffffffffc020097e <slub_alloc_object>
            assert(free_total == f3 - (i + 30) / 31);
ffffffffc020104c:	036b87b3          	mul	a5,s7,s6
ffffffffc0201050:	00005d17          	auipc	s10,0x5
ffffffffc0201054:	038d2d03          	lw	s10,56(s10) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc0201058:	41fbd71b          	sraiw	a4,s7,0x1f
            bulk[i + 19999] = slub_alloc_object(124);
ffffffffc020105c:	00acb023          	sd	a0,0(s9)
            assert(free_total == f3 - (i + 30) / 31);
ffffffffc0201060:	020d1693          	slli	a3,s10,0x20
ffffffffc0201064:	9281                	srli	a3,a3,0x20
ffffffffc0201066:	9381                	srli	a5,a5,0x20
ffffffffc0201068:	00fb87bb          	addw	a5,s7,a5
ffffffffc020106c:	4047d79b          	sraiw	a5,a5,0x4
ffffffffc0201070:	9f99                	subw	a5,a5,a4
ffffffffc0201072:	40f907b3          	sub	a5,s2,a5
ffffffffc0201076:	56f69263          	bne	a3,a5,ffffffffc02015da <slub_run_tests+0x87c>
        for (int i = 1; i <= 10000; i++) {
ffffffffc020107a:	0ca1                	addi	s9,s9,8
ffffffffc020107c:	2b85                	addiw	s7,s7,1
ffffffffc020107e:	fd3c93e3          	bne	s9,s3,ffffffffc0201044 <slub_run_tests+0x2e6>
        }
        f4 = free_total;
        for (int i = 1; i <= 10000; i++) {
            bulk[i + 29999] = slub_alloc_object(129 + i % 666);
ffffffffc0201082:	06267937          	lui	s2,0x6267
ffffffffc0201086:	0916                	slli	s2,s2,0x5
        for (int i = 1; i <= 10000; i++) {
ffffffffc0201088:	6b09                	lui	s6,0x2
            bulk[i + 29999] = slub_alloc_object(129 + i % 666);
ffffffffc020108a:	7b190913          	addi	s2,s2,1969 # 62677b1 <kern_entry-0xffffffffb9f9884f>
        for (int i = 1; i <= 10000; i++) {
ffffffffc020108e:	711b0b13          	addi	s6,s6,1809 # 2711 <kern_entry-0xffffffffc01fd8ef>
ffffffffc0201092:	4c05                	li	s8,1
            bulk[i + 29999] = slub_alloc_object(129 + i % 666);
ffffffffc0201094:	29a00b93          	li	s7,666
ffffffffc0201098:	001c551b          	srliw	a0,s8,0x1
ffffffffc020109c:	03250533          	mul	a0,a0,s2
ffffffffc02010a0:	9121                	srli	a0,a0,0x28
ffffffffc02010a2:	02ab853b          	mulw	a0,s7,a0
ffffffffc02010a6:	40ac053b          	subw	a0,s8,a0
ffffffffc02010aa:	0815051b          	addiw	a0,a0,129
ffffffffc02010ae:	8d1ff0ef          	jal	ffffffffc020097e <slub_alloc_object>
            assert(free_total == f4);
ffffffffc02010b2:	00005797          	auipc	a5,0x5
ffffffffc02010b6:	fd67a783          	lw	a5,-42(a5) # ffffffffc0206088 <mem_pool+0x10>
            bulk[i + 29999] = slub_alloc_object(129 + i % 666);
ffffffffc02010ba:	00a9b023          	sd	a0,0(s3)
            assert(free_total == f4);
ffffffffc02010be:	4fa79e63          	bne	a5,s10,ffffffffc02015ba <slub_run_tests+0x85c>
        for (int i = 1; i <= 10000; i++) {
ffffffffc02010c2:	2c05                	addiw	s8,s8,1
ffffffffc02010c4:	09a1                	addi	s3,s3,8
ffffffffc02010c6:	fd6c19e3          	bne	s8,s6,ffffffffc0201098 <slub_run_tests+0x33a>
        }
        for (int i = 0; i < 40000; i++) {
            if (i < 30000) {
ffffffffc02010ca:	699d                	lui	s3,0x7
        for (int i = 0; i < 40000; i++) {
ffffffffc02010cc:	6b29                	lui	s6,0xa
            if (i < 30000) {
ffffffffc02010ce:	52f98993          	addi	s3,s3,1327 # 752f <kern_entry-0xffffffffc01f8ad1>
        for (int i = 0; i < 40000; i++) {
ffffffffc02010d2:	c40b0b13          	addi	s6,s6,-960 # 9c40 <kern_entry-0xffffffffc01f63c0>
ffffffffc02010d6:	4901                	li	s2,0
                assert(bulk[i] != NULL);
ffffffffc02010d8:	000ab503          	ld	a0,0(s5)
            if (i < 30000) {
ffffffffc02010dc:	0129cc63          	blt	s3,s2,ffffffffc02010f4 <slub_run_tests+0x396>
                assert(bulk[i] != NULL);
ffffffffc02010e0:	62050d63          	beqz	a0,ffffffffc020171a <slub_run_tests+0x9bc>
                slub_free_object(bulk[i]);
ffffffffc02010e4:	b59ff0ef          	jal	ffffffffc0200c3c <slub_free_object>
        for (int i = 0; i < 40000; i++) {
ffffffffc02010e8:	2905                	addiw	s2,s2,1
ffffffffc02010ea:	0aa1                	addi	s5,s5,8
                assert(bulk[i] != NULL);
ffffffffc02010ec:	000ab503          	ld	a0,0(s5)
            if (i < 30000) {
ffffffffc02010f0:	ff29d8e3          	bge	s3,s2,ffffffffc02010e0 <slub_run_tests+0x382>
            } else {
                assert(bulk[i] == NULL);
ffffffffc02010f4:	60051363          	bnez	a0,ffffffffc02016fa <slub_run_tests+0x99c>
        for (int i = 0; i < 40000; i++) {
ffffffffc02010f8:	2905                	addiw	s2,s2,1
ffffffffc02010fa:	01690463          	beq	s2,s6,ffffffffc0201102 <slub_run_tests+0x3a4>
ffffffffc02010fe:	0aa1                	addi	s5,s5,8
ffffffffc0201100:	bfe1                	j	ffffffffc02010d8 <slub_run_tests+0x37a>
            }
        }
        assert(free_total == init_free);
ffffffffc0201102:	00005797          	auipc	a5,0x5
ffffffffc0201106:	f867a783          	lw	a5,-122(a5) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc020110a:	2d479863          	bne	a5,s4,ffffffffc02013da <slub_run_tests+0x67c>
        cprintf("Bulk allocation release check passed.\n");
ffffffffc020110e:	00001517          	auipc	a0,0x1
ffffffffc0201112:	31a50513          	addi	a0,a0,794 # ffffffffc0202428 <etext+0x7e6>
ffffffffc0201116:	832ff0ef          	jal	ffffffffc0200148 <cprintf>
    }
    {
        cprintf("Mixed check start.\n");
ffffffffc020111a:	00001517          	auipc	a0,0x1
ffffffffc020111e:	33650513          	addi	a0,a0,822 # ffffffffc0202450 <etext+0x80e>
ffffffffc0201122:	826ff0ef          	jal	ffffffffc0200148 <cprintf>
        void *o1 = slub_alloc_object(32);
ffffffffc0201126:	02000513          	li	a0,32
ffffffffc020112a:	855ff0ef          	jal	ffffffffc020097e <slub_alloc_object>
ffffffffc020112e:	8daa                	mv	s11,a0
        assert(o1 != NULL);
ffffffffc0201130:	28050563          	beqz	a0,ffffffffc02013ba <slub_run_tests+0x65c>
        cprintf("Allocated 32-byte object at %p\n", o1);
ffffffffc0201134:	85aa                	mv	a1,a0
ffffffffc0201136:	00001517          	auipc	a0,0x1
ffffffffc020113a:	ff250513          	addi	a0,a0,-14 # ffffffffc0202128 <etext+0x4e6>
ffffffffc020113e:	80aff0ef          	jal	ffffffffc0200148 <cprintf>
        assert(free_total == init_free - 1);
ffffffffc0201142:	00005797          	auipc	a5,0x5
ffffffffc0201146:	f467e783          	lwu	a5,-186(a5) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc020114a:	fff48b93          	addi	s7,s1,-1
ffffffffc020114e:	55779663          	bne	a5,s7,ffffffffc020169a <slub_run_tests+0x93c>
        void *o2 = slub_alloc_object(64);
ffffffffc0201152:	04000513          	li	a0,64
ffffffffc0201156:	829ff0ef          	jal	ffffffffc020097e <slub_alloc_object>
ffffffffc020115a:	8d2a                	mv	s10,a0
        assert(o2 != NULL);
ffffffffc020115c:	50050f63          	beqz	a0,ffffffffc020167a <slub_run_tests+0x91c>
        cprintf("Allocated 64-byte object at %p\n", o2);
ffffffffc0201160:	85aa                	mv	a1,a0
ffffffffc0201162:	00001517          	auipc	a0,0x1
ffffffffc0201166:	34650513          	addi	a0,a0,838 # ffffffffc02024a8 <etext+0x866>
ffffffffc020116a:	fdffe0ef          	jal	ffffffffc0200148 <cprintf>
        assert(free_total == init_free - 2);
ffffffffc020116e:	00005797          	auipc	a5,0x5
ffffffffc0201172:	f1a7e783          	lwu	a5,-230(a5) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc0201176:	ffe48c13          	addi	s8,s1,-2
ffffffffc020117a:	4f879063          	bne	a5,s8,ffffffffc020165a <slub_run_tests+0x8fc>
        void *o3 = slub_alloc_object(128);
ffffffffc020117e:	08000513          	li	a0,128
ffffffffc0201182:	ffcff0ef          	jal	ffffffffc020097e <slub_alloc_object>
ffffffffc0201186:	8caa                	mv	s9,a0
        assert(o3 != NULL);
ffffffffc0201188:	4a050963          	beqz	a0,ffffffffc020163a <slub_run_tests+0x8dc>
        cprintf("Allocated 128-byte object at %p\n", o3);
ffffffffc020118c:	85aa                	mv	a1,a0
ffffffffc020118e:	00001517          	auipc	a0,0x1
ffffffffc0201192:	36a50513          	addi	a0,a0,874 # ffffffffc02024f8 <etext+0x8b6>
ffffffffc0201196:	fb3fe0ef          	jal	ffffffffc0200148 <cprintf>
        assert(free_total == init_free - 3);
ffffffffc020119a:	00005797          	auipc	a5,0x5
ffffffffc020119e:	eee7e783          	lwu	a5,-274(a5) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc02011a2:	ffd48a93          	addi	s5,s1,-3
ffffffffc02011a6:	47579a63          	bne	a5,s5,ffffffffc020161a <slub_run_tests+0x8bc>
        void *o4 = slub_alloc_object(32);
ffffffffc02011aa:	02000513          	li	a0,32
ffffffffc02011ae:	fd0ff0ef          	jal	ffffffffc020097e <slub_alloc_object>
ffffffffc02011b2:	fff9e737          	lui	a4,0xfff9e
ffffffffc02011b6:	4e870713          	addi	a4,a4,1256 # fffffffffff9e4e8 <end+0x3fd98408>
ffffffffc02011ba:	9722                	add	a4,a4,s0
ffffffffc02011bc:	e308                	sd	a0,0(a4)
        assert(o4 != NULL);
ffffffffc02011be:	42050e63          	beqz	a0,ffffffffc02015fa <slub_run_tests+0x89c>
        cprintf("Allocated second 32-byte object at %p\n", o4);
ffffffffc02011c2:	fff9e7b7          	lui	a5,0xfff9e
ffffffffc02011c6:	4e878793          	addi	a5,a5,1256 # fffffffffff9e4e8 <end+0x3fd98408>
ffffffffc02011ca:	97a2                	add	a5,a5,s0
ffffffffc02011cc:	638c                	ld	a1,0(a5)
ffffffffc02011ce:	00001517          	auipc	a0,0x1
ffffffffc02011d2:	38250513          	addi	a0,a0,898 # ffffffffc0202550 <etext+0x90e>
ffffffffc02011d6:	f73fe0ef          	jal	ffffffffc0200148 <cprintf>
        assert(free_total == init_free - 3);
ffffffffc02011da:	00005797          	auipc	a5,0x5
ffffffffc02011de:	eae7e783          	lwu	a5,-338(a5) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc02011e2:	5afa9c63          	bne	s5,a5,ffffffffc020179a <slub_run_tests+0xa3c>
ffffffffc02011e6:	fff9e7b7          	lui	a5,0xfff9e
ffffffffc02011ea:	51078793          	addi	a5,a5,1296 # fffffffffff9e510 <end+0x3fd98430>
ffffffffc02011ee:	00f409b3          	add	s3,s0,a5
ffffffffc02011f2:	00898913          	addi	s2,s3,8
ffffffffc02011f6:	8b4a                	mv	s6,s2
ffffffffc02011f8:	0f098993          	addi	s3,s3,240
        void *obs[100];
        for (int i = 1; i <= 29; i++) {
            obs[i] = slub_alloc_object(128);
ffffffffc02011fc:	08000513          	li	a0,128
ffffffffc0201200:	f7eff0ef          	jal	ffffffffc020097e <slub_alloc_object>
ffffffffc0201204:	00ab3023          	sd	a0,0(s6)
        for (int i = 1; i <= 29; i++) {
ffffffffc0201208:	0b21                	addi	s6,s6,8
ffffffffc020120a:	ff6999e3          	bne	s3,s6,ffffffffc02011fc <slub_run_tests+0x49e>
        }
        void *o5 = slub_alloc_object(128);
ffffffffc020120e:	08000513          	li	a0,128
ffffffffc0201212:	f6cff0ef          	jal	ffffffffc020097e <slub_alloc_object>
ffffffffc0201216:	fff9e737          	lui	a4,0xfff9e
ffffffffc020121a:	4e070713          	addi	a4,a4,1248 # fffffffffff9e4e0 <end+0x3fd98400>
ffffffffc020121e:	9722                	add	a4,a4,s0
ffffffffc0201220:	e308                	sd	a0,0(a4)
        assert(o5 != NULL);
ffffffffc0201222:	54050c63          	beqz	a0,ffffffffc020177a <slub_run_tests+0xa1c>
        cprintf("Allocated 31th 128-byte object at %p\n", o5);
ffffffffc0201226:	fff9e7b7          	lui	a5,0xfff9e
ffffffffc020122a:	4e078793          	addi	a5,a5,1248 # fffffffffff9e4e0 <end+0x3fd98400>
ffffffffc020122e:	97a2                	add	a5,a5,s0
ffffffffc0201230:	638c                	ld	a1,0(a5)
ffffffffc0201232:	00001517          	auipc	a0,0x1
ffffffffc0201236:	35650513          	addi	a0,a0,854 # ffffffffc0202588 <etext+0x946>
ffffffffc020123a:	f0ffe0ef          	jal	ffffffffc0200148 <cprintf>
        assert(free_total == init_free - 3);
ffffffffc020123e:	00005797          	auipc	a5,0x5
ffffffffc0201242:	e4a7e783          	lwu	a5,-438(a5) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc0201246:	34fa9a63          	bne	s5,a5,ffffffffc020159a <slub_run_tests+0x83c>
        void *o6 = slub_alloc_object(128);
ffffffffc020124a:	08000513          	li	a0,128
ffffffffc020124e:	f30ff0ef          	jal	ffffffffc020097e <slub_alloc_object>
ffffffffc0201252:	8b2a                	mv	s6,a0
        assert(o6 != NULL);
ffffffffc0201254:	32050363          	beqz	a0,ffffffffc020157a <slub_run_tests+0x81c>
        cprintf("Allocated 32th(new slam) 128-byte object at %p\n", o6);
ffffffffc0201258:	85aa                	mv	a1,a0
ffffffffc020125a:	00001517          	auipc	a0,0x1
ffffffffc020125e:	36650513          	addi	a0,a0,870 # ffffffffc02025c0 <etext+0x97e>
ffffffffc0201262:	ee7fe0ef          	jal	ffffffffc0200148 <cprintf>
        assert(free_total == init_free - 4);
ffffffffc0201266:	00005797          	auipc	a5,0x5
ffffffffc020126a:	e227e783          	lwu	a5,-478(a5) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc020126e:	14f1                	addi	s1,s1,-4
ffffffffc0201270:	2e979563          	bne	a5,s1,ffffffffc020155a <slub_run_tests+0x7fc>
        for (int i = 1; i <= 29; i++) {
            slub_free_object(obs[i]);
ffffffffc0201274:	00093503          	ld	a0,0(s2)
        for (int i = 1; i <= 29; i++) {
ffffffffc0201278:	0921                	addi	s2,s2,8
            slub_free_object(obs[i]);
ffffffffc020127a:	9c3ff0ef          	jal	ffffffffc0200c3c <slub_free_object>
        for (int i = 1; i <= 29; i++) {
ffffffffc020127e:	ff391be3          	bne	s2,s3,ffffffffc0201274 <slub_run_tests+0x516>
        }
        assert(free_total == init_free - 4);
ffffffffc0201282:	00005797          	auipc	a5,0x5
ffffffffc0201286:	e067e783          	lwu	a5,-506(a5) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc020128a:	2af49863          	bne	s1,a5,ffffffffc020153a <slub_run_tests+0x7dc>
        slub_free_object(o1);
ffffffffc020128e:	856e                	mv	a0,s11
ffffffffc0201290:	9adff0ef          	jal	ffffffffc0200c3c <slub_free_object>
        assert(free_total == init_free - 4);
ffffffffc0201294:	00005797          	auipc	a5,0x5
ffffffffc0201298:	df47e783          	lwu	a5,-524(a5) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc020129c:	26f49f63          	bne	s1,a5,ffffffffc020151a <slub_run_tests+0x7bc>
        slub_free_object(o2);
ffffffffc02012a0:	856a                	mv	a0,s10
ffffffffc02012a2:	99bff0ef          	jal	ffffffffc0200c3c <slub_free_object>
        assert(free_total == init_free - 3);
ffffffffc02012a6:	00005797          	auipc	a5,0x5
ffffffffc02012aa:	de27e783          	lwu	a5,-542(a5) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc02012ae:	24fa9663          	bne	s5,a5,ffffffffc02014fa <slub_run_tests+0x79c>
        slub_free_object(o3);
ffffffffc02012b2:	8566                	mv	a0,s9
ffffffffc02012b4:	989ff0ef          	jal	ffffffffc0200c3c <slub_free_object>
        assert(free_total == init_free - 3);
ffffffffc02012b8:	00005797          	auipc	a5,0x5
ffffffffc02012bc:	dd07e783          	lwu	a5,-560(a5) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc02012c0:	20fa9d63          	bne	s5,a5,ffffffffc02014da <slub_run_tests+0x77c>
        slub_free_object(o4);
ffffffffc02012c4:	fff9e7b7          	lui	a5,0xfff9e
ffffffffc02012c8:	4e878793          	addi	a5,a5,1256 # fffffffffff9e4e8 <end+0x3fd98408>
ffffffffc02012cc:	97a2                	add	a5,a5,s0
ffffffffc02012ce:	6388                	ld	a0,0(a5)
ffffffffc02012d0:	96dff0ef          	jal	ffffffffc0200c3c <slub_free_object>
        assert(free_total == init_free - 2);
ffffffffc02012d4:	00005797          	auipc	a5,0x5
ffffffffc02012d8:	db47e783          	lwu	a5,-588(a5) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc02012dc:	1cfc1f63          	bne	s8,a5,ffffffffc02014ba <slub_run_tests+0x75c>
        slub_free_object(o5);
ffffffffc02012e0:	fff9e7b7          	lui	a5,0xfff9e
ffffffffc02012e4:	4e078793          	addi	a5,a5,1248 # fffffffffff9e4e0 <end+0x3fd98400>
ffffffffc02012e8:	97a2                	add	a5,a5,s0
ffffffffc02012ea:	6388                	ld	a0,0(a5)
ffffffffc02012ec:	951ff0ef          	jal	ffffffffc0200c3c <slub_free_object>
        assert(free_total == init_free - 1);
ffffffffc02012f0:	00005797          	auipc	a5,0x5
ffffffffc02012f4:	d987e783          	lwu	a5,-616(a5) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc02012f8:	1afb9163          	bne	s7,a5,ffffffffc020149a <slub_run_tests+0x73c>
        slub_free_object(o6);
ffffffffc02012fc:	855a                	mv	a0,s6
ffffffffc02012fe:	93fff0ef          	jal	ffffffffc0200c3c <slub_free_object>
        assert(free_total == init_free);
ffffffffc0201302:	00005797          	auipc	a5,0x5
ffffffffc0201306:	d867a783          	lw	a5,-634(a5) # ffffffffc0206088 <mem_pool+0x10>
ffffffffc020130a:	17479863          	bne	a5,s4,ffffffffc020147a <slub_run_tests+0x71c>
        cprintf("Mixed check passed.\n");
ffffffffc020130e:	00001517          	auipc	a0,0x1
ffffffffc0201312:	30250513          	addi	a0,a0,770 # ffffffffc0202610 <etext+0x9ce>
ffffffffc0201316:	e33fe0ef          	jal	ffffffffc0200148 <cprintf>
    }
    cprintf("----------------------END-------------------------\n");
ffffffffc020131a:	00001517          	auipc	a0,0x1
ffffffffc020131e:	30e50513          	addi	a0,a0,782 # ffffffffc0202628 <etext+0x9e6>
ffffffffc0201322:	e27fe0ef          	jal	ffffffffc0200148 <cprintf>
}
ffffffffc0201326:	fff9e2b7          	lui	t0,0xfff9e
ffffffffc020132a:	4e028293          	addi	t0,t0,1248 # fffffffffff9e4e0 <end+0x3fd98400>
ffffffffc020132e:	00540133          	add	sp,s0,t0
ffffffffc0201332:	000622b7          	lui	t0,0x62
ffffffffc0201336:	ab028293          	addi	t0,t0,-1360 # 61ab0 <kern_entry-0xffffffffc019e550>
ffffffffc020133a:	9116                	add	sp,sp,t0
ffffffffc020133c:	70a6                	ld	ra,104(sp)
ffffffffc020133e:	7406                	ld	s0,96(sp)
ffffffffc0201340:	64e6                	ld	s1,88(sp)
ffffffffc0201342:	6946                	ld	s2,80(sp)
ffffffffc0201344:	69a6                	ld	s3,72(sp)
ffffffffc0201346:	6a06                	ld	s4,64(sp)
ffffffffc0201348:	7ae2                	ld	s5,56(sp)
ffffffffc020134a:	7b42                	ld	s6,48(sp)
ffffffffc020134c:	7ba2                	ld	s7,40(sp)
ffffffffc020134e:	7c02                	ld	s8,32(sp)
ffffffffc0201350:	6ce2                	ld	s9,24(sp)
ffffffffc0201352:	6d42                	ld	s10,16(sp)
ffffffffc0201354:	6da2                	ld	s11,8(sp)
ffffffffc0201356:	6165                	addi	sp,sp,112
ffffffffc0201358:	8082                	ret
                assert(((unsigned char *)objs[i])[j] == (unsigned char)i);
ffffffffc020135a:	00001697          	auipc	a3,0x1
ffffffffc020135e:	ece68693          	addi	a3,a3,-306 # ffffffffc0202228 <etext+0x5e6>
ffffffffc0201362:	00001617          	auipc	a2,0x1
ffffffffc0201366:	c7e60613          	addi	a2,a2,-898 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020136a:	17200593          	li	a1,370
ffffffffc020136e:	00001517          	auipc	a0,0x1
ffffffffc0201372:	c8a50513          	addi	a0,a0,-886 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201376:	e53fe0ef          	jal	ffffffffc02001c8 <__panic>
                assert(((unsigned char *)objs[i])[j] == 0x00);
ffffffffc020137a:	00001697          	auipc	a3,0x1
ffffffffc020137e:	f3e68693          	addi	a3,a3,-194 # ffffffffc02022b8 <etext+0x676>
ffffffffc0201382:	00001617          	auipc	a2,0x1
ffffffffc0201386:	c5e60613          	addi	a2,a2,-930 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020138a:	17a00593          	li	a1,378
ffffffffc020138e:	00001517          	auipc	a0,0x1
ffffffffc0201392:	c6a50513          	addi	a0,a0,-918 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201396:	e33fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(init_free == free_total);
ffffffffc020139a:	00001697          	auipc	a3,0x1
ffffffffc020139e:	fa668693          	addi	a3,a3,-90 # ffffffffc0202340 <etext+0x6fe>
ffffffffc02013a2:	00001617          	auipc	a2,0x1
ffffffffc02013a6:	c3e60613          	addi	a2,a2,-962 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc02013aa:	18200593          	li	a1,386
ffffffffc02013ae:	00001517          	auipc	a0,0x1
ffffffffc02013b2:	c4a50513          	addi	a0,a0,-950 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc02013b6:	e13fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(o1 != NULL);
ffffffffc02013ba:	00001697          	auipc	a3,0x1
ffffffffc02013be:	0ae68693          	addi	a3,a3,174 # ffffffffc0202468 <etext+0x826>
ffffffffc02013c2:	00001617          	auipc	a2,0x1
ffffffffc02013c6:	c1e60613          	addi	a2,a2,-994 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc02013ca:	1a500593          	li	a1,421
ffffffffc02013ce:	00001517          	auipc	a0,0x1
ffffffffc02013d2:	c2a50513          	addi	a0,a0,-982 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc02013d6:	df3fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(free_total == init_free);
ffffffffc02013da:	00001697          	auipc	a3,0x1
ffffffffc02013de:	03668693          	addi	a3,a3,54 # ffffffffc0202410 <etext+0x7ce>
ffffffffc02013e2:	00001617          	auipc	a2,0x1
ffffffffc02013e6:	bfe60613          	addi	a2,a2,-1026 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc02013ea:	19f00593          	li	a1,415
ffffffffc02013ee:	00001517          	auipc	a0,0x1
ffffffffc02013f2:	c0a50513          	addi	a0,a0,-1014 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc02013f6:	dd3fe0ef          	jal	ffffffffc02001c8 <__panic>
            assert(((unsigned char *)obj1)[i] == 0x66);
ffffffffc02013fa:	00001697          	auipc	a3,0x1
ffffffffc02013fe:	d4e68693          	addi	a3,a3,-690 # ffffffffc0202148 <etext+0x506>
ffffffffc0201402:	00001617          	auipc	a2,0x1
ffffffffc0201406:	bde60613          	addi	a2,a2,-1058 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020140a:	15b00593          	li	a1,347
ffffffffc020140e:	00001517          	auipc	a0,0x1
ffffffffc0201412:	bea50513          	addi	a0,a0,-1046 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201416:	db3fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(obj1 != NULL);
ffffffffc020141a:	00001697          	auipc	a3,0x1
ffffffffc020141e:	cfe68693          	addi	a3,a3,-770 # ffffffffc0202118 <etext+0x4d6>
ffffffffc0201422:	00001617          	auipc	a2,0x1
ffffffffc0201426:	bbe60613          	addi	a2,a2,-1090 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020142a:	15700593          	li	a1,343
ffffffffc020142e:	00001517          	auipc	a0,0x1
ffffffffc0201432:	bca50513          	addi	a0,a0,-1078 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201436:	d93fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(obj == NULL);
ffffffffc020143a:	00001697          	auipc	a3,0x1
ffffffffc020143e:	cae68693          	addi	a3,a3,-850 # ffffffffc02020e8 <etext+0x4a6>
ffffffffc0201442:	00001617          	auipc	a2,0x1
ffffffffc0201446:	b9e60613          	addi	a2,a2,-1122 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020144a:	15200593          	li	a1,338
ffffffffc020144e:	00001517          	auipc	a0,0x1
ffffffffc0201452:	baa50513          	addi	a0,a0,-1110 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201456:	d73fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(cache_set[i].obj_cnt == exp[i]);
ffffffffc020145a:	00001697          	auipc	a3,0x1
ffffffffc020145e:	c6e68693          	addi	a3,a3,-914 # ffffffffc02020c8 <etext+0x486>
ffffffffc0201462:	00001617          	auipc	a2,0x1
ffffffffc0201466:	b7e60613          	addi	a2,a2,-1154 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020146a:	14b00593          	li	a1,331
ffffffffc020146e:	00001517          	auipc	a0,0x1
ffffffffc0201472:	b8a50513          	addi	a0,a0,-1142 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201476:	d53fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(free_total == init_free);
ffffffffc020147a:	00001697          	auipc	a3,0x1
ffffffffc020147e:	f9668693          	addi	a3,a3,-106 # ffffffffc0202410 <etext+0x7ce>
ffffffffc0201482:	00001617          	auipc	a2,0x1
ffffffffc0201486:	b5e60613          	addi	a2,a2,-1186 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020148a:	1cf00593          	li	a1,463
ffffffffc020148e:	00001517          	auipc	a0,0x1
ffffffffc0201492:	b6a50513          	addi	a0,a0,-1174 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201496:	d33fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(free_total == init_free - 1);
ffffffffc020149a:	00001697          	auipc	a3,0x1
ffffffffc020149e:	fde68693          	addi	a3,a3,-34 # ffffffffc0202478 <etext+0x836>
ffffffffc02014a2:	00001617          	auipc	a2,0x1
ffffffffc02014a6:	b3e60613          	addi	a2,a2,-1218 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc02014aa:	1cd00593          	li	a1,461
ffffffffc02014ae:	00001517          	auipc	a0,0x1
ffffffffc02014b2:	b4a50513          	addi	a0,a0,-1206 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc02014b6:	d13fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(free_total == init_free - 2);
ffffffffc02014ba:	00001697          	auipc	a3,0x1
ffffffffc02014be:	00e68693          	addi	a3,a3,14 # ffffffffc02024c8 <etext+0x886>
ffffffffc02014c2:	00001617          	auipc	a2,0x1
ffffffffc02014c6:	b1e60613          	addi	a2,a2,-1250 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc02014ca:	1cb00593          	li	a1,459
ffffffffc02014ce:	00001517          	auipc	a0,0x1
ffffffffc02014d2:	b2a50513          	addi	a0,a0,-1238 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc02014d6:	cf3fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(free_total == init_free - 3);
ffffffffc02014da:	00001697          	auipc	a3,0x1
ffffffffc02014de:	04668693          	addi	a3,a3,70 # ffffffffc0202520 <etext+0x8de>
ffffffffc02014e2:	00001617          	auipc	a2,0x1
ffffffffc02014e6:	afe60613          	addi	a2,a2,-1282 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc02014ea:	1c900593          	li	a1,457
ffffffffc02014ee:	00001517          	auipc	a0,0x1
ffffffffc02014f2:	b0a50513          	addi	a0,a0,-1270 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc02014f6:	cd3fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(free_total == init_free - 3);
ffffffffc02014fa:	00001697          	auipc	a3,0x1
ffffffffc02014fe:	02668693          	addi	a3,a3,38 # ffffffffc0202520 <etext+0x8de>
ffffffffc0201502:	00001617          	auipc	a2,0x1
ffffffffc0201506:	ade60613          	addi	a2,a2,-1314 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020150a:	1c700593          	li	a1,455
ffffffffc020150e:	00001517          	auipc	a0,0x1
ffffffffc0201512:	aea50513          	addi	a0,a0,-1302 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201516:	cb3fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(free_total == init_free - 4);
ffffffffc020151a:	00001697          	auipc	a3,0x1
ffffffffc020151e:	0d668693          	addi	a3,a3,214 # ffffffffc02025f0 <etext+0x9ae>
ffffffffc0201522:	00001617          	auipc	a2,0x1
ffffffffc0201526:	abe60613          	addi	a2,a2,-1346 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020152a:	1c500593          	li	a1,453
ffffffffc020152e:	00001517          	auipc	a0,0x1
ffffffffc0201532:	aca50513          	addi	a0,a0,-1334 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201536:	c93fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(free_total == init_free - 4);
ffffffffc020153a:	00001697          	auipc	a3,0x1
ffffffffc020153e:	0b668693          	addi	a3,a3,182 # ffffffffc02025f0 <etext+0x9ae>
ffffffffc0201542:	00001617          	auipc	a2,0x1
ffffffffc0201546:	a9e60613          	addi	a2,a2,-1378 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020154a:	1c300593          	li	a1,451
ffffffffc020154e:	00001517          	auipc	a0,0x1
ffffffffc0201552:	aaa50513          	addi	a0,a0,-1366 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201556:	c73fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(free_total == init_free - 4);
ffffffffc020155a:	00001697          	auipc	a3,0x1
ffffffffc020155e:	09668693          	addi	a3,a3,150 # ffffffffc02025f0 <etext+0x9ae>
ffffffffc0201562:	00001617          	auipc	a2,0x1
ffffffffc0201566:	a7e60613          	addi	a2,a2,-1410 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020156a:	1bf00593          	li	a1,447
ffffffffc020156e:	00001517          	auipc	a0,0x1
ffffffffc0201572:	a8a50513          	addi	a0,a0,-1398 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201576:	c53fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(o6 != NULL);
ffffffffc020157a:	00001697          	auipc	a3,0x1
ffffffffc020157e:	03668693          	addi	a3,a3,54 # ffffffffc02025b0 <etext+0x96e>
ffffffffc0201582:	00001617          	auipc	a2,0x1
ffffffffc0201586:	a5e60613          	addi	a2,a2,-1442 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020158a:	1bd00593          	li	a1,445
ffffffffc020158e:	00001517          	auipc	a0,0x1
ffffffffc0201592:	a6a50513          	addi	a0,a0,-1430 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201596:	c33fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(free_total == init_free - 3);
ffffffffc020159a:	00001697          	auipc	a3,0x1
ffffffffc020159e:	f8668693          	addi	a3,a3,-122 # ffffffffc0202520 <etext+0x8de>
ffffffffc02015a2:	00001617          	auipc	a2,0x1
ffffffffc02015a6:	a3e60613          	addi	a2,a2,-1474 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc02015aa:	1bb00593          	li	a1,443
ffffffffc02015ae:	00001517          	auipc	a0,0x1
ffffffffc02015b2:	a4a50513          	addi	a0,a0,-1462 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc02015b6:	c13fe0ef          	jal	ffffffffc02001c8 <__panic>
            assert(free_total == f4);
ffffffffc02015ba:	00001697          	auipc	a3,0x1
ffffffffc02015be:	e1e68693          	addi	a3,a3,-482 # ffffffffc02023d8 <etext+0x796>
ffffffffc02015c2:	00001617          	auipc	a2,0x1
ffffffffc02015c6:	a1e60613          	addi	a2,a2,-1506 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc02015ca:	19500593          	li	a1,405
ffffffffc02015ce:	00001517          	auipc	a0,0x1
ffffffffc02015d2:	a2a50513          	addi	a0,a0,-1494 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc02015d6:	bf3fe0ef          	jal	ffffffffc02001c8 <__panic>
            assert(free_total == f3 - (i + 30) / 31);
ffffffffc02015da:	00001697          	auipc	a3,0x1
ffffffffc02015de:	dd668693          	addi	a3,a3,-554 # ffffffffc02023b0 <etext+0x76e>
ffffffffc02015e2:	00001617          	auipc	a2,0x1
ffffffffc02015e6:	9fe60613          	addi	a2,a2,-1538 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc02015ea:	19000593          	li	a1,400
ffffffffc02015ee:	00001517          	auipc	a0,0x1
ffffffffc02015f2:	a0a50513          	addi	a0,a0,-1526 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc02015f6:	bd3fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(o4 != NULL);
ffffffffc02015fa:	00001697          	auipc	a3,0x1
ffffffffc02015fe:	f4668693          	addi	a3,a3,-186 # ffffffffc0202540 <etext+0x8fe>
ffffffffc0201602:	00001617          	auipc	a2,0x1
ffffffffc0201606:	9de60613          	addi	a2,a2,-1570 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020160a:	1b100593          	li	a1,433
ffffffffc020160e:	00001517          	auipc	a0,0x1
ffffffffc0201612:	9ea50513          	addi	a0,a0,-1558 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201616:	bb3fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(free_total == init_free - 3);
ffffffffc020161a:	00001697          	auipc	a3,0x1
ffffffffc020161e:	f0668693          	addi	a3,a3,-250 # ffffffffc0202520 <etext+0x8de>
ffffffffc0201622:	00001617          	auipc	a2,0x1
ffffffffc0201626:	9be60613          	addi	a2,a2,-1602 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020162a:	1af00593          	li	a1,431
ffffffffc020162e:	00001517          	auipc	a0,0x1
ffffffffc0201632:	9ca50513          	addi	a0,a0,-1590 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201636:	b93fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(o3 != NULL);
ffffffffc020163a:	00001697          	auipc	a3,0x1
ffffffffc020163e:	eae68693          	addi	a3,a3,-338 # ffffffffc02024e8 <etext+0x8a6>
ffffffffc0201642:	00001617          	auipc	a2,0x1
ffffffffc0201646:	99e60613          	addi	a2,a2,-1634 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020164a:	1ad00593          	li	a1,429
ffffffffc020164e:	00001517          	auipc	a0,0x1
ffffffffc0201652:	9aa50513          	addi	a0,a0,-1622 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201656:	b73fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(free_total == init_free - 2);
ffffffffc020165a:	00001697          	auipc	a3,0x1
ffffffffc020165e:	e6e68693          	addi	a3,a3,-402 # ffffffffc02024c8 <etext+0x886>
ffffffffc0201662:	00001617          	auipc	a2,0x1
ffffffffc0201666:	97e60613          	addi	a2,a2,-1666 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020166a:	1ab00593          	li	a1,427
ffffffffc020166e:	00001517          	auipc	a0,0x1
ffffffffc0201672:	98a50513          	addi	a0,a0,-1654 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201676:	b53fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(o2 != NULL);
ffffffffc020167a:	00001697          	auipc	a3,0x1
ffffffffc020167e:	e1e68693          	addi	a3,a3,-482 # ffffffffc0202498 <etext+0x856>
ffffffffc0201682:	00001617          	auipc	a2,0x1
ffffffffc0201686:	95e60613          	addi	a2,a2,-1698 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020168a:	1a900593          	li	a1,425
ffffffffc020168e:	00001517          	auipc	a0,0x1
ffffffffc0201692:	96a50513          	addi	a0,a0,-1686 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201696:	b33fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(free_total == init_free - 1);
ffffffffc020169a:	00001697          	auipc	a3,0x1
ffffffffc020169e:	dde68693          	addi	a3,a3,-546 # ffffffffc0202478 <etext+0x836>
ffffffffc02016a2:	00001617          	auipc	a2,0x1
ffffffffc02016a6:	93e60613          	addi	a2,a2,-1730 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc02016aa:	1a700593          	li	a1,423
ffffffffc02016ae:	00001517          	auipc	a0,0x1
ffffffffc02016b2:	94a50513          	addi	a0,a0,-1718 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc02016b6:	b13fe0ef          	jal	ffffffffc02001c8 <__panic>
            assert(free_total == f2 - (i + 62) / 63);
ffffffffc02016ba:	00001697          	auipc	a3,0x1
ffffffffc02016be:	cce68693          	addi	a3,a3,-818 # ffffffffc0202388 <etext+0x746>
ffffffffc02016c2:	00001617          	auipc	a2,0x1
ffffffffc02016c6:	91e60613          	addi	a2,a2,-1762 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc02016ca:	18b00593          	li	a1,395
ffffffffc02016ce:	00001517          	auipc	a0,0x1
ffffffffc02016d2:	92a50513          	addi	a0,a0,-1750 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc02016d6:	af3fe0ef          	jal	ffffffffc02001c8 <__panic>
            assert(free_total == init_free - (i + 125) / 126);
ffffffffc02016da:	00001697          	auipc	a3,0x1
ffffffffc02016de:	c7e68693          	addi	a3,a3,-898 # ffffffffc0202358 <etext+0x716>
ffffffffc02016e2:	00001617          	auipc	a2,0x1
ffffffffc02016e6:	8fe60613          	addi	a2,a2,-1794 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc02016ea:	18600593          	li	a1,390
ffffffffc02016ee:	00001517          	auipc	a0,0x1
ffffffffc02016f2:	90a50513          	addi	a0,a0,-1782 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc02016f6:	ad3fe0ef          	jal	ffffffffc02001c8 <__panic>
                assert(bulk[i] == NULL);
ffffffffc02016fa:	00001697          	auipc	a3,0x1
ffffffffc02016fe:	d0668693          	addi	a3,a3,-762 # ffffffffc0202400 <etext+0x7be>
ffffffffc0201702:	00001617          	auipc	a2,0x1
ffffffffc0201706:	8de60613          	addi	a2,a2,-1826 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020170a:	19c00593          	li	a1,412
ffffffffc020170e:	00001517          	auipc	a0,0x1
ffffffffc0201712:	8ea50513          	addi	a0,a0,-1814 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201716:	ab3fe0ef          	jal	ffffffffc02001c8 <__panic>
                assert(bulk[i] != NULL);
ffffffffc020171a:	00001697          	auipc	a3,0x1
ffffffffc020171e:	cd668693          	addi	a3,a3,-810 # ffffffffc02023f0 <etext+0x7ae>
ffffffffc0201722:	00001617          	auipc	a2,0x1
ffffffffc0201726:	8be60613          	addi	a2,a2,-1858 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020172a:	19900593          	li	a1,409
ffffffffc020172e:	00001517          	auipc	a0,0x1
ffffffffc0201732:	8ca50513          	addi	a0,a0,-1846 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201736:	a93fe0ef          	jal	ffffffffc02001c8 <__panic>
            assert(objs[i] != NULL);
ffffffffc020173a:	00001697          	auipc	a3,0x1
ffffffffc020173e:	ade68693          	addi	a3,a3,-1314 # ffffffffc0202218 <etext+0x5d6>
ffffffffc0201742:	00001617          	auipc	a2,0x1
ffffffffc0201746:	89e60613          	addi	a2,a2,-1890 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020174a:	16d00593          	li	a1,365
ffffffffc020174e:	00001517          	auipc	a0,0x1
ffffffffc0201752:	8aa50513          	addi	a0,a0,-1878 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201756:	a73fe0ef          	jal	ffffffffc02001c8 <__panic>
            assert(((unsigned char *)obj2)[i] == 0x00);
ffffffffc020175a:	00001697          	auipc	a3,0x1
ffffffffc020175e:	a3e68693          	addi	a3,a3,-1474 # ffffffffc0202198 <etext+0x556>
ffffffffc0201762:	00001617          	auipc	a2,0x1
ffffffffc0201766:	87e60613          	addi	a2,a2,-1922 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020176a:	16200593          	li	a1,354
ffffffffc020176e:	00001517          	auipc	a0,0x1
ffffffffc0201772:	88a50513          	addi	a0,a0,-1910 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201776:	a53fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(o5 != NULL);
ffffffffc020177a:	00001697          	auipc	a3,0x1
ffffffffc020177e:	dfe68693          	addi	a3,a3,-514 # ffffffffc0202578 <etext+0x936>
ffffffffc0201782:	00001617          	auipc	a2,0x1
ffffffffc0201786:	85e60613          	addi	a2,a2,-1954 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc020178a:	1b900593          	li	a1,441
ffffffffc020178e:	00001517          	auipc	a0,0x1
ffffffffc0201792:	86a50513          	addi	a0,a0,-1942 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc0201796:	a33fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(free_total == init_free - 3);
ffffffffc020179a:	00001697          	auipc	a3,0x1
ffffffffc020179e:	d8668693          	addi	a3,a3,-634 # ffffffffc0202520 <etext+0x8de>
ffffffffc02017a2:	00001617          	auipc	a2,0x1
ffffffffc02017a6:	83e60613          	addi	a2,a2,-1986 # ffffffffc0201fe0 <etext+0x39e>
ffffffffc02017aa:	1b300593          	li	a1,435
ffffffffc02017ae:	00001517          	auipc	a0,0x1
ffffffffc02017b2:	84a50513          	addi	a0,a0,-1974 # ffffffffc0201ff8 <etext+0x3b6>
ffffffffc02017b6:	a13fe0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc02017ba <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02017ba:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02017bc:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02017c0:	f022                	sd	s0,32(sp)
ffffffffc02017c2:	ec26                	sd	s1,24(sp)
ffffffffc02017c4:	e84a                	sd	s2,16(sp)
ffffffffc02017c6:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02017c8:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02017cc:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc02017ce:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02017d2:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02017d6:	84aa                	mv	s1,a0
ffffffffc02017d8:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc02017da:	03067d63          	bgeu	a2,a6,ffffffffc0201814 <printnum+0x5a>
ffffffffc02017de:	e44e                	sd	s3,8(sp)
ffffffffc02017e0:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02017e2:	4785                	li	a5,1
ffffffffc02017e4:	00e7d763          	bge	a5,a4,ffffffffc02017f2 <printnum+0x38>
            putch(padc, putdat);
ffffffffc02017e8:	85ca                	mv	a1,s2
ffffffffc02017ea:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc02017ec:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02017ee:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02017f0:	fc65                	bnez	s0,ffffffffc02017e8 <printnum+0x2e>
ffffffffc02017f2:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02017f4:	00001797          	auipc	a5,0x1
ffffffffc02017f8:	e8478793          	addi	a5,a5,-380 # ffffffffc0202678 <etext+0xa36>
ffffffffc02017fc:	97d2                	add	a5,a5,s4
}
ffffffffc02017fe:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201800:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0201804:	70a2                	ld	ra,40(sp)
ffffffffc0201806:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201808:	85ca                	mv	a1,s2
ffffffffc020180a:	87a6                	mv	a5,s1
}
ffffffffc020180c:	6942                	ld	s2,16(sp)
ffffffffc020180e:	64e2                	ld	s1,24(sp)
ffffffffc0201810:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201812:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0201814:	03065633          	divu	a2,a2,a6
ffffffffc0201818:	8722                	mv	a4,s0
ffffffffc020181a:	fa1ff0ef          	jal	ffffffffc02017ba <printnum>
ffffffffc020181e:	bfd9                	j	ffffffffc02017f4 <printnum+0x3a>

ffffffffc0201820 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201820:	7119                	addi	sp,sp,-128
ffffffffc0201822:	f4a6                	sd	s1,104(sp)
ffffffffc0201824:	f0ca                	sd	s2,96(sp)
ffffffffc0201826:	ecce                	sd	s3,88(sp)
ffffffffc0201828:	e8d2                	sd	s4,80(sp)
ffffffffc020182a:	e4d6                	sd	s5,72(sp)
ffffffffc020182c:	e0da                	sd	s6,64(sp)
ffffffffc020182e:	f862                	sd	s8,48(sp)
ffffffffc0201830:	fc86                	sd	ra,120(sp)
ffffffffc0201832:	f8a2                	sd	s0,112(sp)
ffffffffc0201834:	fc5e                	sd	s7,56(sp)
ffffffffc0201836:	f466                	sd	s9,40(sp)
ffffffffc0201838:	f06a                	sd	s10,32(sp)
ffffffffc020183a:	ec6e                	sd	s11,24(sp)
ffffffffc020183c:	84aa                	mv	s1,a0
ffffffffc020183e:	8c32                	mv	s8,a2
ffffffffc0201840:	8a36                	mv	s4,a3
ffffffffc0201842:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201844:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201848:	05500b13          	li	s6,85
ffffffffc020184c:	00001a97          	auipc	s5,0x1
ffffffffc0201850:	f3ca8a93          	addi	s5,s5,-196 # ffffffffc0202788 <slub_pmm_manager+0x38>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201854:	000c4503          	lbu	a0,0(s8)
ffffffffc0201858:	001c0413          	addi	s0,s8,1
ffffffffc020185c:	01350a63          	beq	a0,s3,ffffffffc0201870 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0201860:	cd0d                	beqz	a0,ffffffffc020189a <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0201862:	85ca                	mv	a1,s2
ffffffffc0201864:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201866:	00044503          	lbu	a0,0(s0)
ffffffffc020186a:	0405                	addi	s0,s0,1
ffffffffc020186c:	ff351ae3          	bne	a0,s3,ffffffffc0201860 <vprintfmt+0x40>
        width = precision = -1;
ffffffffc0201870:	5cfd                	li	s9,-1
ffffffffc0201872:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc0201874:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc0201878:	4b81                	li	s7,0
ffffffffc020187a:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020187c:	00044683          	lbu	a3,0(s0)
ffffffffc0201880:	00140c13          	addi	s8,s0,1
ffffffffc0201884:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0201888:	0ff5f593          	zext.b	a1,a1
ffffffffc020188c:	02bb6663          	bltu	s6,a1,ffffffffc02018b8 <vprintfmt+0x98>
ffffffffc0201890:	058a                	slli	a1,a1,0x2
ffffffffc0201892:	95d6                	add	a1,a1,s5
ffffffffc0201894:	4198                	lw	a4,0(a1)
ffffffffc0201896:	9756                	add	a4,a4,s5
ffffffffc0201898:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc020189a:	70e6                	ld	ra,120(sp)
ffffffffc020189c:	7446                	ld	s0,112(sp)
ffffffffc020189e:	74a6                	ld	s1,104(sp)
ffffffffc02018a0:	7906                	ld	s2,96(sp)
ffffffffc02018a2:	69e6                	ld	s3,88(sp)
ffffffffc02018a4:	6a46                	ld	s4,80(sp)
ffffffffc02018a6:	6aa6                	ld	s5,72(sp)
ffffffffc02018a8:	6b06                	ld	s6,64(sp)
ffffffffc02018aa:	7be2                	ld	s7,56(sp)
ffffffffc02018ac:	7c42                	ld	s8,48(sp)
ffffffffc02018ae:	7ca2                	ld	s9,40(sp)
ffffffffc02018b0:	7d02                	ld	s10,32(sp)
ffffffffc02018b2:	6de2                	ld	s11,24(sp)
ffffffffc02018b4:	6109                	addi	sp,sp,128
ffffffffc02018b6:	8082                	ret
            putch('%', putdat);
ffffffffc02018b8:	85ca                	mv	a1,s2
ffffffffc02018ba:	02500513          	li	a0,37
ffffffffc02018be:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02018c0:	fff44783          	lbu	a5,-1(s0)
ffffffffc02018c4:	02500713          	li	a4,37
ffffffffc02018c8:	8c22                	mv	s8,s0
ffffffffc02018ca:	f8e785e3          	beq	a5,a4,ffffffffc0201854 <vprintfmt+0x34>
ffffffffc02018ce:	ffec4783          	lbu	a5,-2(s8)
ffffffffc02018d2:	1c7d                	addi	s8,s8,-1
ffffffffc02018d4:	fee79de3          	bne	a5,a4,ffffffffc02018ce <vprintfmt+0xae>
ffffffffc02018d8:	bfb5                	j	ffffffffc0201854 <vprintfmt+0x34>
                ch = *fmt;
ffffffffc02018da:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc02018de:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc02018e0:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc02018e4:	fd06071b          	addiw	a4,a2,-48
ffffffffc02018e8:	24e56a63          	bltu	a0,a4,ffffffffc0201b3c <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc02018ec:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02018ee:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc02018f0:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc02018f4:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02018f8:	0197073b          	addw	a4,a4,s9
ffffffffc02018fc:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201900:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201902:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201906:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201908:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc020190c:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc0201910:	feb570e3          	bgeu	a0,a1,ffffffffc02018f0 <vprintfmt+0xd0>
            if (width < 0)
ffffffffc0201914:	f60d54e3          	bgez	s10,ffffffffc020187c <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0201918:	8d66                	mv	s10,s9
ffffffffc020191a:	5cfd                	li	s9,-1
ffffffffc020191c:	b785                	j	ffffffffc020187c <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020191e:	8db6                	mv	s11,a3
ffffffffc0201920:	8462                	mv	s0,s8
ffffffffc0201922:	bfa9                	j	ffffffffc020187c <vprintfmt+0x5c>
ffffffffc0201924:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0201926:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0201928:	bf91                	j	ffffffffc020187c <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc020192a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020192c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201930:	00f74463          	blt	a4,a5,ffffffffc0201938 <vprintfmt+0x118>
    else if (lflag) {
ffffffffc0201934:	1a078763          	beqz	a5,ffffffffc0201ae2 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0201938:	000a3603          	ld	a2,0(s4)
ffffffffc020193c:	46c1                	li	a3,16
ffffffffc020193e:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201940:	000d879b          	sext.w	a5,s11
ffffffffc0201944:	876a                	mv	a4,s10
ffffffffc0201946:	85ca                	mv	a1,s2
ffffffffc0201948:	8526                	mv	a0,s1
ffffffffc020194a:	e71ff0ef          	jal	ffffffffc02017ba <printnum>
            break;
ffffffffc020194e:	b719                	j	ffffffffc0201854 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0201950:	000a2503          	lw	a0,0(s4)
ffffffffc0201954:	85ca                	mv	a1,s2
ffffffffc0201956:	0a21                	addi	s4,s4,8
ffffffffc0201958:	9482                	jalr	s1
            break;
ffffffffc020195a:	bded                	j	ffffffffc0201854 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc020195c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020195e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201962:	00f74463          	blt	a4,a5,ffffffffc020196a <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0201966:	16078963          	beqz	a5,ffffffffc0201ad8 <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc020196a:	000a3603          	ld	a2,0(s4)
ffffffffc020196e:	46a9                	li	a3,10
ffffffffc0201970:	8a2e                	mv	s4,a1
ffffffffc0201972:	b7f9                	j	ffffffffc0201940 <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc0201974:	85ca                	mv	a1,s2
ffffffffc0201976:	03000513          	li	a0,48
ffffffffc020197a:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc020197c:	85ca                	mv	a1,s2
ffffffffc020197e:	07800513          	li	a0,120
ffffffffc0201982:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201984:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc0201988:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020198a:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc020198c:	bf55                	j	ffffffffc0201940 <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc020198e:	85ca                	mv	a1,s2
ffffffffc0201990:	02500513          	li	a0,37
ffffffffc0201994:	9482                	jalr	s1
            break;
ffffffffc0201996:	bd7d                	j	ffffffffc0201854 <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc0201998:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020199c:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc020199e:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc02019a0:	bf95                	j	ffffffffc0201914 <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc02019a2:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02019a4:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02019a8:	00f74463          	blt	a4,a5,ffffffffc02019b0 <vprintfmt+0x190>
    else if (lflag) {
ffffffffc02019ac:	12078163          	beqz	a5,ffffffffc0201ace <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc02019b0:	000a3603          	ld	a2,0(s4)
ffffffffc02019b4:	46a1                	li	a3,8
ffffffffc02019b6:	8a2e                	mv	s4,a1
ffffffffc02019b8:	b761                	j	ffffffffc0201940 <vprintfmt+0x120>
            if (width < 0)
ffffffffc02019ba:	876a                	mv	a4,s10
ffffffffc02019bc:	000d5363          	bgez	s10,ffffffffc02019c2 <vprintfmt+0x1a2>
ffffffffc02019c0:	4701                	li	a4,0
ffffffffc02019c2:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02019c6:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc02019c8:	bd55                	j	ffffffffc020187c <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc02019ca:	000d841b          	sext.w	s0,s11
ffffffffc02019ce:	fd340793          	addi	a5,s0,-45
ffffffffc02019d2:	00f037b3          	snez	a5,a5
ffffffffc02019d6:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02019da:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc02019de:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02019e0:	008a0793          	addi	a5,s4,8
ffffffffc02019e4:	e43e                	sd	a5,8(sp)
ffffffffc02019e6:	100d8c63          	beqz	s11,ffffffffc0201afe <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc02019ea:	12071363          	bnez	a4,ffffffffc0201b10 <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02019ee:	000dc783          	lbu	a5,0(s11)
ffffffffc02019f2:	0007851b          	sext.w	a0,a5
ffffffffc02019f6:	c78d                	beqz	a5,ffffffffc0201a20 <vprintfmt+0x200>
ffffffffc02019f8:	0d85                	addi	s11,s11,1
ffffffffc02019fa:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02019fc:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201a00:	000cc563          	bltz	s9,ffffffffc0201a0a <vprintfmt+0x1ea>
ffffffffc0201a04:	3cfd                	addiw	s9,s9,-1
ffffffffc0201a06:	008c8d63          	beq	s9,s0,ffffffffc0201a20 <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201a0a:	020b9663          	bnez	s7,ffffffffc0201a36 <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc0201a0e:	85ca                	mv	a1,s2
ffffffffc0201a10:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201a12:	000dc783          	lbu	a5,0(s11)
ffffffffc0201a16:	0d85                	addi	s11,s11,1
ffffffffc0201a18:	3d7d                	addiw	s10,s10,-1
ffffffffc0201a1a:	0007851b          	sext.w	a0,a5
ffffffffc0201a1e:	f3ed                	bnez	a5,ffffffffc0201a00 <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc0201a20:	01a05963          	blez	s10,ffffffffc0201a32 <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc0201a24:	85ca                	mv	a1,s2
ffffffffc0201a26:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0201a2a:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc0201a2c:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc0201a2e:	fe0d1be3          	bnez	s10,ffffffffc0201a24 <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201a32:	6a22                	ld	s4,8(sp)
ffffffffc0201a34:	b505                	j	ffffffffc0201854 <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201a36:	3781                	addiw	a5,a5,-32
ffffffffc0201a38:	fcfa7be3          	bgeu	s4,a5,ffffffffc0201a0e <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc0201a3c:	03f00513          	li	a0,63
ffffffffc0201a40:	85ca                	mv	a1,s2
ffffffffc0201a42:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201a44:	000dc783          	lbu	a5,0(s11)
ffffffffc0201a48:	0d85                	addi	s11,s11,1
ffffffffc0201a4a:	3d7d                	addiw	s10,s10,-1
ffffffffc0201a4c:	0007851b          	sext.w	a0,a5
ffffffffc0201a50:	dbe1                	beqz	a5,ffffffffc0201a20 <vprintfmt+0x200>
ffffffffc0201a52:	fa0cd9e3          	bgez	s9,ffffffffc0201a04 <vprintfmt+0x1e4>
ffffffffc0201a56:	b7c5                	j	ffffffffc0201a36 <vprintfmt+0x216>
            if (err < 0) {
ffffffffc0201a58:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201a5c:	4619                	li	a2,6
            err = va_arg(ap, int);
ffffffffc0201a5e:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0201a60:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0201a64:	8fb9                	xor	a5,a5,a4
ffffffffc0201a66:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201a6a:	02d64563          	blt	a2,a3,ffffffffc0201a94 <vprintfmt+0x274>
ffffffffc0201a6e:	00001797          	auipc	a5,0x1
ffffffffc0201a72:	e7278793          	addi	a5,a5,-398 # ffffffffc02028e0 <error_string>
ffffffffc0201a76:	00369713          	slli	a4,a3,0x3
ffffffffc0201a7a:	97ba                	add	a5,a5,a4
ffffffffc0201a7c:	639c                	ld	a5,0(a5)
ffffffffc0201a7e:	cb99                	beqz	a5,ffffffffc0201a94 <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc0201a80:	86be                	mv	a3,a5
ffffffffc0201a82:	00001617          	auipc	a2,0x1
ffffffffc0201a86:	c2660613          	addi	a2,a2,-986 # ffffffffc02026a8 <etext+0xa66>
ffffffffc0201a8a:	85ca                	mv	a1,s2
ffffffffc0201a8c:	8526                	mv	a0,s1
ffffffffc0201a8e:	0d8000ef          	jal	ffffffffc0201b66 <printfmt>
ffffffffc0201a92:	b3c9                	j	ffffffffc0201854 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201a94:	00001617          	auipc	a2,0x1
ffffffffc0201a98:	c0460613          	addi	a2,a2,-1020 # ffffffffc0202698 <etext+0xa56>
ffffffffc0201a9c:	85ca                	mv	a1,s2
ffffffffc0201a9e:	8526                	mv	a0,s1
ffffffffc0201aa0:	0c6000ef          	jal	ffffffffc0201b66 <printfmt>
ffffffffc0201aa4:	bb45                	j	ffffffffc0201854 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0201aa6:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201aa8:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc0201aac:	00f74363          	blt	a4,a5,ffffffffc0201ab2 <vprintfmt+0x292>
    else if (lflag) {
ffffffffc0201ab0:	cf81                	beqz	a5,ffffffffc0201ac8 <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc0201ab2:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201ab6:	02044b63          	bltz	s0,ffffffffc0201aec <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc0201aba:	8622                	mv	a2,s0
ffffffffc0201abc:	8a5e                	mv	s4,s7
ffffffffc0201abe:	46a9                	li	a3,10
ffffffffc0201ac0:	b541                	j	ffffffffc0201940 <vprintfmt+0x120>
            lflag ++;
ffffffffc0201ac2:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201ac4:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0201ac6:	bb5d                	j	ffffffffc020187c <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc0201ac8:	000a2403          	lw	s0,0(s4)
ffffffffc0201acc:	b7ed                	j	ffffffffc0201ab6 <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc0201ace:	000a6603          	lwu	a2,0(s4)
ffffffffc0201ad2:	46a1                	li	a3,8
ffffffffc0201ad4:	8a2e                	mv	s4,a1
ffffffffc0201ad6:	b5ad                	j	ffffffffc0201940 <vprintfmt+0x120>
ffffffffc0201ad8:	000a6603          	lwu	a2,0(s4)
ffffffffc0201adc:	46a9                	li	a3,10
ffffffffc0201ade:	8a2e                	mv	s4,a1
ffffffffc0201ae0:	b585                	j	ffffffffc0201940 <vprintfmt+0x120>
ffffffffc0201ae2:	000a6603          	lwu	a2,0(s4)
ffffffffc0201ae6:	46c1                	li	a3,16
ffffffffc0201ae8:	8a2e                	mv	s4,a1
ffffffffc0201aea:	bd99                	j	ffffffffc0201940 <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc0201aec:	85ca                	mv	a1,s2
ffffffffc0201aee:	02d00513          	li	a0,45
ffffffffc0201af2:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc0201af4:	40800633          	neg	a2,s0
ffffffffc0201af8:	8a5e                	mv	s4,s7
ffffffffc0201afa:	46a9                	li	a3,10
ffffffffc0201afc:	b591                	j	ffffffffc0201940 <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc0201afe:	e329                	bnez	a4,ffffffffc0201b40 <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201b00:	02800793          	li	a5,40
ffffffffc0201b04:	853e                	mv	a0,a5
ffffffffc0201b06:	00001d97          	auipc	s11,0x1
ffffffffc0201b0a:	b8bd8d93          	addi	s11,s11,-1141 # ffffffffc0202691 <etext+0xa4f>
ffffffffc0201b0e:	b5f5                	j	ffffffffc02019fa <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201b10:	85e6                	mv	a1,s9
ffffffffc0201b12:	856e                	mv	a0,s11
ffffffffc0201b14:	0a4000ef          	jal	ffffffffc0201bb8 <strnlen>
ffffffffc0201b18:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0201b1c:	01a05863          	blez	s10,ffffffffc0201b2c <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc0201b20:	85ca                	mv	a1,s2
ffffffffc0201b22:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201b24:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc0201b26:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201b28:	fe0d1ce3          	bnez	s10,ffffffffc0201b20 <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201b2c:	000dc783          	lbu	a5,0(s11)
ffffffffc0201b30:	0007851b          	sext.w	a0,a5
ffffffffc0201b34:	ec0792e3          	bnez	a5,ffffffffc02019f8 <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201b38:	6a22                	ld	s4,8(sp)
ffffffffc0201b3a:	bb29                	j	ffffffffc0201854 <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b3c:	8462                	mv	s0,s8
ffffffffc0201b3e:	bbd9                	j	ffffffffc0201914 <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201b40:	85e6                	mv	a1,s9
ffffffffc0201b42:	00001517          	auipc	a0,0x1
ffffffffc0201b46:	b4e50513          	addi	a0,a0,-1202 # ffffffffc0202690 <etext+0xa4e>
ffffffffc0201b4a:	06e000ef          	jal	ffffffffc0201bb8 <strnlen>
ffffffffc0201b4e:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201b52:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0201b56:	00001d97          	auipc	s11,0x1
ffffffffc0201b5a:	b3ad8d93          	addi	s11,s11,-1222 # ffffffffc0202690 <etext+0xa4e>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201b5e:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201b60:	fda040e3          	bgtz	s10,ffffffffc0201b20 <vprintfmt+0x300>
ffffffffc0201b64:	bd51                	j	ffffffffc02019f8 <vprintfmt+0x1d8>

ffffffffc0201b66 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201b66:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201b68:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201b6c:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201b6e:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201b70:	ec06                	sd	ra,24(sp)
ffffffffc0201b72:	f83a                	sd	a4,48(sp)
ffffffffc0201b74:	fc3e                	sd	a5,56(sp)
ffffffffc0201b76:	e0c2                	sd	a6,64(sp)
ffffffffc0201b78:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0201b7a:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201b7c:	ca5ff0ef          	jal	ffffffffc0201820 <vprintfmt>
}
ffffffffc0201b80:	60e2                	ld	ra,24(sp)
ffffffffc0201b82:	6161                	addi	sp,sp,80
ffffffffc0201b84:	8082                	ret

ffffffffc0201b86 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201b86:	00004717          	auipc	a4,0x4
ffffffffc0201b8a:	48a73703          	ld	a4,1162(a4) # ffffffffc0206010 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201b8e:	4781                	li	a5,0
ffffffffc0201b90:	88ba                	mv	a7,a4
ffffffffc0201b92:	852a                	mv	a0,a0
ffffffffc0201b94:	85be                	mv	a1,a5
ffffffffc0201b96:	863e                	mv	a2,a5
ffffffffc0201b98:	00000073          	ecall
ffffffffc0201b9c:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc0201b9e:	8082                	ret

ffffffffc0201ba0 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0201ba0:	00054783          	lbu	a5,0(a0)
ffffffffc0201ba4:	cb81                	beqz	a5,ffffffffc0201bb4 <strlen+0x14>
    size_t cnt = 0;
ffffffffc0201ba6:	4781                	li	a5,0
        cnt ++;
ffffffffc0201ba8:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc0201baa:	00f50733          	add	a4,a0,a5
ffffffffc0201bae:	00074703          	lbu	a4,0(a4)
ffffffffc0201bb2:	fb7d                	bnez	a4,ffffffffc0201ba8 <strlen+0x8>
    }
    return cnt;
}
ffffffffc0201bb4:	853e                	mv	a0,a5
ffffffffc0201bb6:	8082                	ret

ffffffffc0201bb8 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201bb8:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201bba:	e589                	bnez	a1,ffffffffc0201bc4 <strnlen+0xc>
ffffffffc0201bbc:	a811                	j	ffffffffc0201bd0 <strnlen+0x18>
        cnt ++;
ffffffffc0201bbe:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201bc0:	00f58863          	beq	a1,a5,ffffffffc0201bd0 <strnlen+0x18>
ffffffffc0201bc4:	00f50733          	add	a4,a0,a5
ffffffffc0201bc8:	00074703          	lbu	a4,0(a4)
ffffffffc0201bcc:	fb6d                	bnez	a4,ffffffffc0201bbe <strnlen+0x6>
ffffffffc0201bce:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201bd0:	852e                	mv	a0,a1
ffffffffc0201bd2:	8082                	ret

ffffffffc0201bd4 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201bd4:	00054783          	lbu	a5,0(a0)
ffffffffc0201bd8:	e791                	bnez	a5,ffffffffc0201be4 <strcmp+0x10>
ffffffffc0201bda:	a01d                	j	ffffffffc0201c00 <strcmp+0x2c>
ffffffffc0201bdc:	00054783          	lbu	a5,0(a0)
ffffffffc0201be0:	cb99                	beqz	a5,ffffffffc0201bf6 <strcmp+0x22>
ffffffffc0201be2:	0585                	addi	a1,a1,1
ffffffffc0201be4:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0201be8:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201bea:	fef709e3          	beq	a4,a5,ffffffffc0201bdc <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201bee:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0201bf2:	9d19                	subw	a0,a0,a4
ffffffffc0201bf4:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201bf6:	0015c703          	lbu	a4,1(a1)
ffffffffc0201bfa:	4501                	li	a0,0
}
ffffffffc0201bfc:	9d19                	subw	a0,a0,a4
ffffffffc0201bfe:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201c00:	0005c703          	lbu	a4,0(a1)
ffffffffc0201c04:	4501                	li	a0,0
ffffffffc0201c06:	b7f5                	j	ffffffffc0201bf2 <strcmp+0x1e>

ffffffffc0201c08 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201c08:	ce01                	beqz	a2,ffffffffc0201c20 <strncmp+0x18>
ffffffffc0201c0a:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201c0e:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201c10:	cb91                	beqz	a5,ffffffffc0201c24 <strncmp+0x1c>
ffffffffc0201c12:	0005c703          	lbu	a4,0(a1)
ffffffffc0201c16:	00f71763          	bne	a4,a5,ffffffffc0201c24 <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc0201c1a:	0505                	addi	a0,a0,1
ffffffffc0201c1c:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201c1e:	f675                	bnez	a2,ffffffffc0201c0a <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201c20:	4501                	li	a0,0
ffffffffc0201c22:	8082                	ret
ffffffffc0201c24:	00054503          	lbu	a0,0(a0)
ffffffffc0201c28:	0005c783          	lbu	a5,0(a1)
ffffffffc0201c2c:	9d1d                	subw	a0,a0,a5
}
ffffffffc0201c2e:	8082                	ret

ffffffffc0201c30 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201c30:	ca01                	beqz	a2,ffffffffc0201c40 <memset+0x10>
ffffffffc0201c32:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0201c34:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0201c36:	0785                	addi	a5,a5,1
ffffffffc0201c38:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201c3c:	fef61de3          	bne	a2,a5,ffffffffc0201c36 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201c40:	8082                	ret
