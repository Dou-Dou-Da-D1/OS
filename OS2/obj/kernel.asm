
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
ffffffffc020004c:	00001517          	auipc	a0,0x1
ffffffffc0200050:	65450513          	addi	a0,a0,1620 # ffffffffc02016a0 <etext+0x6>
void print_kerninfo(void) {
ffffffffc0200054:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200056:	0f2000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", (uintptr_t)kern_init);
ffffffffc020005a:	00000597          	auipc	a1,0x0
ffffffffc020005e:	07c58593          	addi	a1,a1,124 # ffffffffc02000d6 <kern_init>
ffffffffc0200062:	00001517          	auipc	a0,0x1
ffffffffc0200066:	65e50513          	addi	a0,a0,1630 # ffffffffc02016c0 <etext+0x26>
ffffffffc020006a:	0de000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc020006e:	00001597          	auipc	a1,0x1
ffffffffc0200072:	62c58593          	addi	a1,a1,1580 # ffffffffc020169a <etext>
ffffffffc0200076:	00001517          	auipc	a0,0x1
ffffffffc020007a:	66a50513          	addi	a0,a0,1642 # ffffffffc02016e0 <etext+0x46>
ffffffffc020007e:	0ca000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc0200082:	00006597          	auipc	a1,0x6
ffffffffc0200086:	f9658593          	addi	a1,a1,-106 # ffffffffc0206018 <slub_caches>
ffffffffc020008a:	00001517          	auipc	a0,0x1
ffffffffc020008e:	67650513          	addi	a0,a0,1654 # ffffffffc0201700 <etext+0x66>
ffffffffc0200092:	0b6000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc0200096:	00006597          	auipc	a1,0x6
ffffffffc020009a:	04a58593          	addi	a1,a1,74 # ffffffffc02060e0 <end>
ffffffffc020009e:	00001517          	auipc	a0,0x1
ffffffffc02000a2:	68250513          	addi	a0,a0,1666 # ffffffffc0201720 <etext+0x86>
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
ffffffffc02000ca:	00001517          	auipc	a0,0x1
ffffffffc02000ce:	67650513          	addi	a0,a0,1654 # ffffffffc0201740 <etext+0xa6>
}
ffffffffc02000d2:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000d4:	a895                	j	ffffffffc0200148 <cprintf>

ffffffffc02000d6 <kern_init>:

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc02000d6:	00006517          	auipc	a0,0x6
ffffffffc02000da:	f4250513          	addi	a0,a0,-190 # ffffffffc0206018 <slub_caches>
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
ffffffffc02000ee:	59a010ef          	jal	ffffffffc0201688 <memset>
    dtb_init();
ffffffffc02000f2:	136000ef          	jal	ffffffffc0200228 <dtb_init>
    cons_init();  // init the console
ffffffffc02000f6:	128000ef          	jal	ffffffffc020021e <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc02000fa:	00002517          	auipc	a0,0x2
ffffffffc02000fe:	e7650513          	addi	a0,a0,-394 # ffffffffc0201f70 <etext+0x8d6>
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
ffffffffc020013c:	13c010ef          	jal	ffffffffc0201278 <vprintfmt>
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
ffffffffc0200170:	108010ef          	jal	ffffffffc0201278 <vprintfmt>
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
ffffffffc02001f0:	00001517          	auipc	a0,0x1
ffffffffc02001f4:	58050513          	addi	a0,a0,1408 # ffffffffc0201770 <etext+0xd6>
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
ffffffffc020020e:	00001517          	auipc	a0,0x1
ffffffffc0200212:	58250513          	addi	a0,a0,1410 # ffffffffc0201790 <etext+0xf6>
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
ffffffffc0200224:	3ba0106f          	j	ffffffffc02015de <sbi_console_putchar>

ffffffffc0200228 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200228:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc020022a:	00001517          	auipc	a0,0x1
ffffffffc020022e:	56e50513          	addi	a0,a0,1390 # ffffffffc0201798 <etext+0xfe>
void dtb_init(void) {
ffffffffc0200232:	f406                	sd	ra,40(sp)
ffffffffc0200234:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc0200236:	f13ff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc020023a:	00006597          	auipc	a1,0x6
ffffffffc020023e:	dc65b583          	ld	a1,-570(a1) # ffffffffc0206000 <boot_hartid>
ffffffffc0200242:	00001517          	auipc	a0,0x1
ffffffffc0200246:	56650513          	addi	a0,a0,1382 # ffffffffc02017a8 <etext+0x10e>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020024a:	00006417          	auipc	s0,0x6
ffffffffc020024e:	dbe40413          	addi	s0,s0,-578 # ffffffffc0206008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200252:	ef7ff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200256:	600c                	ld	a1,0(s0)
ffffffffc0200258:	00001517          	auipc	a0,0x1
ffffffffc020025c:	56050513          	addi	a0,a0,1376 # ffffffffc02017b8 <etext+0x11e>
ffffffffc0200260:	ee9ff0ef          	jal	ffffffffc0200148 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200264:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200266:	00001517          	auipc	a0,0x1
ffffffffc020026a:	56a50513          	addi	a0,a0,1386 # ffffffffc02017d0 <etext+0x136>
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
ffffffffc0200358:	00001517          	auipc	a0,0x1
ffffffffc020035c:	54050513          	addi	a0,a0,1344 # ffffffffc0201898 <etext+0x1fe>
ffffffffc0200360:	de9ff0ef          	jal	ffffffffc0200148 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200364:	64e2                	ld	s1,24(sp)
ffffffffc0200366:	6942                	ld	s2,16(sp)
ffffffffc0200368:	00001517          	auipc	a0,0x1
ffffffffc020036c:	56850513          	addi	a0,a0,1384 # ffffffffc02018d0 <etext+0x236>
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
ffffffffc020037c:	00001517          	auipc	a0,0x1
ffffffffc0200380:	47450513          	addi	a0,a0,1140 # ffffffffc02017f0 <etext+0x156>
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
ffffffffc02003c2:	236010ef          	jal	ffffffffc02015f8 <strlen>
ffffffffc02003c6:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003c8:	4619                	li	a2,6
ffffffffc02003ca:	8522                	mv	a0,s0
ffffffffc02003cc:	00001597          	auipc	a1,0x1
ffffffffc02003d0:	44c58593          	addi	a1,a1,1100 # ffffffffc0201818 <etext+0x17e>
ffffffffc02003d4:	28c010ef          	jal	ffffffffc0201660 <strncmp>
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
ffffffffc02003f8:	00001597          	auipc	a1,0x1
ffffffffc02003fc:	42858593          	addi	a1,a1,1064 # ffffffffc0201820 <etext+0x186>
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
ffffffffc020042e:	1fe010ef          	jal	ffffffffc020162c <strcmp>
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
ffffffffc020044e:	00001517          	auipc	a0,0x1
ffffffffc0200452:	3da50513          	addi	a0,a0,986 # ffffffffc0201828 <etext+0x18e>
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
ffffffffc0200518:	00001517          	auipc	a0,0x1
ffffffffc020051c:	33050513          	addi	a0,a0,816 # ffffffffc0201848 <etext+0x1ae>
ffffffffc0200520:	c29ff0ef          	jal	ffffffffc0200148 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200524:	01445613          	srli	a2,s0,0x14
ffffffffc0200528:	85a2                	mv	a1,s0
ffffffffc020052a:	00001517          	auipc	a0,0x1
ffffffffc020052e:	33650513          	addi	a0,a0,822 # ffffffffc0201860 <etext+0x1c6>
ffffffffc0200532:	c17ff0ef          	jal	ffffffffc0200148 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200536:	009405b3          	add	a1,s0,s1
ffffffffc020053a:	15fd                	addi	a1,a1,-1
ffffffffc020053c:	00001517          	auipc	a0,0x1
ffffffffc0200540:	34450513          	addi	a0,a0,836 # ffffffffc0201880 <etext+0x1e6>
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
ffffffffc0200572:	a2278793          	addi	a5,a5,-1502 # ffffffffc0201f90 <slub_pmm_manager>
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
ffffffffc020058c:	00001517          	auipc	a0,0x1
ffffffffc0200590:	35c50513          	addi	a0,a0,860 # ffffffffc02018e8 <etext+0x24e>
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
ffffffffc02005c2:	00001517          	auipc	a0,0x1
ffffffffc02005c6:	36e50513          	addi	a0,a0,878 # ffffffffc0201930 <etext+0x296>
ffffffffc02005ca:	b7fff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc02005ce:	65a2                	ld	a1,8(sp)
ffffffffc02005d0:	864e                	mv	a2,s3
ffffffffc02005d2:	fff90693          	addi	a3,s2,-1
ffffffffc02005d6:	00001517          	auipc	a0,0x1
ffffffffc02005da:	37250513          	addi	a0,a0,882 # ffffffffc0201948 <etext+0x2ae>
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
ffffffffc0200660:	00001517          	auipc	a0,0x1
ffffffffc0200664:	37050513          	addi	a0,a0,880 # ffffffffc02019d0 <etext+0x336>
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
ffffffffc020069c:	00001517          	auipc	a0,0x1
ffffffffc02006a0:	35450513          	addi	a0,a0,852 # ffffffffc02019f0 <etext+0x356>
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
ffffffffc02006de:	00001617          	auipc	a2,0x1
ffffffffc02006e2:	2c260613          	addi	a2,a2,706 # ffffffffc02019a0 <etext+0x306>
ffffffffc02006e6:	06a00593          	li	a1,106
ffffffffc02006ea:	00001517          	auipc	a0,0x1
ffffffffc02006ee:	2d650513          	addi	a0,a0,726 # ffffffffc02019c0 <etext+0x326>
ffffffffc02006f2:	ad7ff0ef          	jal	ffffffffc02001c8 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02006f6:	00001617          	auipc	a2,0x1
ffffffffc02006fa:	28260613          	addi	a2,a2,642 # ffffffffc0201978 <etext+0x2de>
ffffffffc02006fe:	06000593          	li	a1,96
ffffffffc0200702:	00001517          	auipc	a0,0x1
ffffffffc0200706:	21e50513          	addi	a0,a0,542 # ffffffffc0201920 <etext+0x286>
ffffffffc020070a:	abfff0ef          	jal	ffffffffc02001c8 <__panic>
        panic("DTB memory info not available");
ffffffffc020070e:	00001617          	auipc	a2,0x1
ffffffffc0200712:	1f260613          	addi	a2,a2,498 # ffffffffc0201900 <etext+0x266>
ffffffffc0200716:	04800593          	li	a1,72
ffffffffc020071a:	00001517          	auipc	a0,0x1
ffffffffc020071e:	20650513          	addi	a0,a0,518 # ffffffffc0201920 <etext+0x286>
ffffffffc0200722:	aa7ff0ef          	jal	ffffffffc02001c8 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200726:	86ae                	mv	a3,a1
ffffffffc0200728:	00001617          	auipc	a2,0x1
ffffffffc020072c:	25060613          	addi	a2,a2,592 # ffffffffc0201978 <etext+0x2de>
ffffffffc0200730:	07b00593          	li	a1,123
ffffffffc0200734:	00001517          	auipc	a0,0x1
ffffffffc0200738:	1ec50513          	addi	a0,a0,492 # ffffffffc0201920 <etext+0x286>
ffffffffc020073c:	a8dff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200740 <slub_init>:
    size_t obj_num = total_usable_sz / obj_total_sz;
    return obj_num > 0 ? obj_num : 1;
}

static void slub_cache_init(void) {
    slub_cache_count = 3;
ffffffffc0200740:	470d                	li	a4,3
static void area_init(void) {
    list_init(&free_list);
    nr_free = 0;
}

void slub_init(void) {
ffffffffc0200742:	1101                	addi	sp,sp,-32
    slub_cache_count = 3;
ffffffffc0200744:	00006697          	auipc	a3,0x6
ffffffffc0200748:	98e6ba23          	sd	a4,-1644(a3) # ffffffffc02060d8 <slub_cache_count>
    size_t obj_sizes[3] = {32, 64, 128};
ffffffffc020074c:	02000713          	li	a4,32
ffffffffc0200750:	e43a                	sd	a4,8(sp)
ffffffffc0200752:	04000713          	li	a4,64
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200756:	00006797          	auipc	a5,0x6
ffffffffc020075a:	92278793          	addi	a5,a5,-1758 # ffffffffc0206078 <area>
ffffffffc020075e:	e83a                	sd	a4,16(sp)
    return obj_num > 0 ? obj_num : 1;
ffffffffc0200760:	6605                	lui	a2,0x1
    size_t obj_sizes[3] = {32, 64, 128};
ffffffffc0200762:	08000713          	li	a4,128
ffffffffc0200766:	ec3a                	sd	a4,24(sp)
ffffffffc0200768:	e79c                	sd	a5,8(a5)
ffffffffc020076a:	e39c                	sd	a5,0(a5)
    nr_free = 0;
ffffffffc020076c:	00006717          	auipc	a4,0x6
ffffffffc0200770:	90072e23          	sw	zero,-1764(a4) # ffffffffc0206088 <area+0x10>
    return obj_num > 0 ? obj_num : 1;
ffffffffc0200774:	fd860613          	addi	a2,a2,-40 # fd8 <kern_entry-0xffffffffc01ff028>
ffffffffc0200778:	0034                	addi	a3,sp,8
ffffffffc020077a:	00006797          	auipc	a5,0x6
ffffffffc020077e:	89e78793          	addi	a5,a5,-1890 # ffffffffc0206018 <slub_caches>
ffffffffc0200782:	00006517          	auipc	a0,0x6
ffffffffc0200786:	8f650513          	addi	a0,a0,-1802 # ffffffffc0206078 <area>
        slub_caches[i].obj_size = obj_sizes[i];
ffffffffc020078a:	6298                	ld	a4,0(a3)
    return obj_num > 0 ? obj_num : 1;
ffffffffc020078c:	4585                	li	a1,1
    for (int i = 0; i < slub_cache_count; i++) {
ffffffffc020078e:	06a1                	addi	a3,a3,8
        slub_caches[i].obj_size = obj_sizes[i];
ffffffffc0200790:	eb98                	sd	a4,16(a5)
    return obj_num > 0 ? obj_num : 1;
ffffffffc0200792:	00e66463          	bltu	a2,a4,ffffffffc020079a <slub_init+0x5a>
    size_t obj_num = total_usable_sz / obj_total_sz;
ffffffffc0200796:	02e655b3          	divu	a1,a2,a4
ffffffffc020079a:	e79c                	sd	a5,8(a5)
ffffffffc020079c:	e39c                	sd	a5,0(a5)
        slub_caches[i].obj_num = slub_calc_obj_num(obj_sizes[i]);
ffffffffc020079e:	ef8c                	sd	a1,24(a5)
    for (int i = 0; i < slub_cache_count; i++) {
ffffffffc02007a0:	02078793          	addi	a5,a5,32
ffffffffc02007a4:	fea793e3          	bne	a5,a0,ffffffffc020078a <slub_init+0x4a>
    area_init();
    slub_cache_init();
}
ffffffffc02007a8:	6105                	addi	sp,sp,32
ffffffffc02007aa:	8082                	ret

ffffffffc02007ac <slub_nr_free_pages>:
    }
}

size_t slub_nr_free_pages(void) {
    return nr_free;
}
ffffffffc02007ac:	00006517          	auipc	a0,0x6
ffffffffc02007b0:	8dc56503          	lwu	a0,-1828(a0) # ffffffffc0206088 <area+0x10>
ffffffffc02007b4:	8082                	ret

ffffffffc02007b6 <slub_init_memmap>:
void slub_init_memmap(struct Page *base, size_t n) {
ffffffffc02007b6:	1141                	addi	sp,sp,-16
ffffffffc02007b8:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02007ba:	c9e9                	beqz	a1,ffffffffc020088c <slub_init_memmap+0xd6>
    for (; p != base + n; p++) {
ffffffffc02007bc:	00259713          	slli	a4,a1,0x2
ffffffffc02007c0:	972e                	add	a4,a4,a1
ffffffffc02007c2:	070e                	slli	a4,a4,0x3
ffffffffc02007c4:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc02007c8:	87aa                	mv	a5,a0
    for (; p != base + n; p++) {
ffffffffc02007ca:	cf11                	beqz	a4,ffffffffc02007e6 <slub_init_memmap+0x30>
        assert(PageReserved(p));
ffffffffc02007cc:	6798                	ld	a4,8(a5)
ffffffffc02007ce:	8b05                	andi	a4,a4,1
ffffffffc02007d0:	cf51                	beqz	a4,ffffffffc020086c <slub_init_memmap+0xb6>
        p->flags = p->property = 0;
ffffffffc02007d2:	0007a823          	sw	zero,16(a5)
ffffffffc02007d6:	0007b423          	sd	zero,8(a5)
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc02007da:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++) {
ffffffffc02007de:	02878793          	addi	a5,a5,40
ffffffffc02007e2:	fed795e3          	bne	a5,a3,ffffffffc02007cc <slub_init_memmap+0x16>
    SetPageProperty(base);
ffffffffc02007e6:	6510                	ld	a2,8(a0)
    nr_free += n;
ffffffffc02007e8:	00006717          	auipc	a4,0x6
ffffffffc02007ec:	8a072703          	lw	a4,-1888(a4) # ffffffffc0206088 <area+0x10>
ffffffffc02007f0:	00006697          	auipc	a3,0x6
ffffffffc02007f4:	88868693          	addi	a3,a3,-1912 # ffffffffc0206078 <area>
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
ffffffffc02007f8:	669c                	ld	a5,8(a3)
    SetPageProperty(base);
ffffffffc02007fa:	00266613          	ori	a2,a2,2
    base->property = n;
ffffffffc02007fe:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0200800:	e510                	sd	a2,8(a0)
    nr_free += n;
ffffffffc0200802:	9f2d                	addw	a4,a4,a1
ffffffffc0200804:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0200806:	04d78663          	beq	a5,a3,ffffffffc0200852 <slub_init_memmap+0x9c>
            struct Page *page = le2page(le, page_link);
ffffffffc020080a:	fe878713          	addi	a4,a5,-24
ffffffffc020080e:	4581                	li	a1,0
ffffffffc0200810:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0200814:	00e56a63          	bltu	a0,a4,ffffffffc0200828 <slub_init_memmap+0x72>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200818:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020081a:	02d70263          	beq	a4,a3,ffffffffc020083e <slub_init_memmap+0x88>
    struct Page *p = base;
ffffffffc020081e:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0200820:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0200824:	fee57ae3          	bgeu	a0,a4,ffffffffc0200818 <slub_init_memmap+0x62>
ffffffffc0200828:	c199                	beqz	a1,ffffffffc020082e <slub_init_memmap+0x78>
ffffffffc020082a:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020082e:	6398                	ld	a4,0(a5)
}
ffffffffc0200830:	60a2                	ld	ra,8(sp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0200832:	e390                	sd	a2,0(a5)
ffffffffc0200834:	e710                	sd	a2,8(a4)
    elm->next = next;
    elm->prev = prev;
ffffffffc0200836:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0200838:	f11c                	sd	a5,32(a0)
ffffffffc020083a:	0141                	addi	sp,sp,16
ffffffffc020083c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020083e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0200840:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0200842:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0200844:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0200846:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0200848:	00d70e63          	beq	a4,a3,ffffffffc0200864 <slub_init_memmap+0xae>
ffffffffc020084c:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc020084e:	87ba                	mv	a5,a4
ffffffffc0200850:	bfc1                	j	ffffffffc0200820 <slub_init_memmap+0x6a>
}
ffffffffc0200852:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0200854:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0200858:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020085a:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc020085c:	e398                	sd	a4,0(a5)
ffffffffc020085e:	e798                	sd	a4,8(a5)
}
ffffffffc0200860:	0141                	addi	sp,sp,16
ffffffffc0200862:	8082                	ret
ffffffffc0200864:	60a2                	ld	ra,8(sp)
ffffffffc0200866:	e290                	sd	a2,0(a3)
ffffffffc0200868:	0141                	addi	sp,sp,16
ffffffffc020086a:	8082                	ret
        assert(PageReserved(p));
ffffffffc020086c:	00001697          	auipc	a3,0x1
ffffffffc0200870:	1fc68693          	addi	a3,a3,508 # ffffffffc0201a68 <etext+0x3ce>
ffffffffc0200874:	00001617          	auipc	a2,0x1
ffffffffc0200878:	1c460613          	addi	a2,a2,452 # ffffffffc0201a38 <etext+0x39e>
ffffffffc020087c:	03400593          	li	a1,52
ffffffffc0200880:	00001517          	auipc	a0,0x1
ffffffffc0200884:	1d050513          	addi	a0,a0,464 # ffffffffc0201a50 <etext+0x3b6>
ffffffffc0200888:	941ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(n > 0);
ffffffffc020088c:	00001697          	auipc	a3,0x1
ffffffffc0200890:	1a468693          	addi	a3,a3,420 # ffffffffc0201a30 <etext+0x396>
ffffffffc0200894:	00001617          	auipc	a2,0x1
ffffffffc0200898:	1a460613          	addi	a2,a2,420 # ffffffffc0201a38 <etext+0x39e>
ffffffffc020089c:	03100593          	li	a1,49
ffffffffc02008a0:	00001517          	auipc	a0,0x1
ffffffffc02008a4:	1b050513          	addi	a0,a0,432 # ffffffffc0201a50 <etext+0x3b6>
ffffffffc02008a8:	921ff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc02008ac <area_alloc_pages>:
    assert(n > 0);
ffffffffc02008ac:	cd41                	beqz	a0,ffffffffc0200944 <area_alloc_pages+0x98>
    if (n > nr_free) return NULL;
ffffffffc02008ae:	00005597          	auipc	a1,0x5
ffffffffc02008b2:	7da5a583          	lw	a1,2010(a1) # ffffffffc0206088 <area+0x10>
ffffffffc02008b6:	86aa                	mv	a3,a0
ffffffffc02008b8:	02059793          	slli	a5,a1,0x20
ffffffffc02008bc:	9381                	srli	a5,a5,0x20
ffffffffc02008be:	00a7ef63          	bltu	a5,a0,ffffffffc02008dc <area_alloc_pages+0x30>
    list_entry_t *le = &free_list;
ffffffffc02008c2:	00005617          	auipc	a2,0x5
ffffffffc02008c6:	7b660613          	addi	a2,a2,1974 # ffffffffc0206078 <area>
ffffffffc02008ca:	87b2                	mv	a5,a2
ffffffffc02008cc:	a029                	j	ffffffffc02008d6 <area_alloc_pages+0x2a>
        if (p->property >= n) {
ffffffffc02008ce:	ff87e703          	lwu	a4,-8(a5)
ffffffffc02008d2:	00d77763          	bgeu	a4,a3,ffffffffc02008e0 <area_alloc_pages+0x34>
    return listelm->next;
ffffffffc02008d6:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02008d8:	fec79be3          	bne	a5,a2,ffffffffc02008ce <area_alloc_pages+0x22>
    if (n > nr_free) return NULL;
ffffffffc02008dc:	4501                	li	a0,0
}
ffffffffc02008de:	8082                	ret
        if (result->property > n) {
ffffffffc02008e0:	ff87a303          	lw	t1,-8(a5)
    return listelm->prev;
ffffffffc02008e4:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02008e8:	0087b883          	ld	a7,8(a5)
ffffffffc02008ec:	02031713          	slli	a4,t1,0x20
ffffffffc02008f0:	9301                	srli	a4,a4,0x20
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02008f2:	01183423          	sd	a7,8(a6) # fffffffffff80008 <end+0x3fd79f28>
    next->prev = prev;
ffffffffc02008f6:	0108b023          	sd	a6,0(a7)
        struct Page *p = le2page(le, page_link);
ffffffffc02008fa:	fe878513          	addi	a0,a5,-24
        if (result->property > n) {
ffffffffc02008fe:	02e6fb63          	bgeu	a3,a4,ffffffffc0200934 <area_alloc_pages+0x88>
            struct Page *remain_page = result + n;
ffffffffc0200902:	00269713          	slli	a4,a3,0x2
ffffffffc0200906:	9736                	add	a4,a4,a3
ffffffffc0200908:	070e                	slli	a4,a4,0x3
ffffffffc020090a:	972a                	add	a4,a4,a0
            SetPageProperty(remain_page);
ffffffffc020090c:	00873e03          	ld	t3,8(a4)
            remain_page->property = result->property - n;
ffffffffc0200910:	40d3033b          	subw	t1,t1,a3
ffffffffc0200914:	00672823          	sw	t1,16(a4)
            SetPageProperty(remain_page);
ffffffffc0200918:	002e6313          	ori	t1,t3,2
ffffffffc020091c:	00673423          	sd	t1,8(a4)
            list_add(prev_le, &(remain_page->page_link));
ffffffffc0200920:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc0200924:	0068b023          	sd	t1,0(a7)
ffffffffc0200928:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc020092c:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc0200930:	01073c23          	sd	a6,24(a4)
        ClearPageProperty(result);
ffffffffc0200934:	ff07b703          	ld	a4,-16(a5)
        nr_free -= n;
ffffffffc0200938:	9d95                	subw	a1,a1,a3
ffffffffc020093a:	ca0c                	sw	a1,16(a2)
        ClearPageProperty(result);
ffffffffc020093c:	9b75                	andi	a4,a4,-3
ffffffffc020093e:	fee7b823          	sd	a4,-16(a5)
ffffffffc0200942:	8082                	ret
struct Page *area_alloc_pages(size_t n) {
ffffffffc0200944:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0200946:	00001697          	auipc	a3,0x1
ffffffffc020094a:	0ea68693          	addi	a3,a3,234 # ffffffffc0201a30 <etext+0x396>
ffffffffc020094e:	00001617          	auipc	a2,0x1
ffffffffc0200952:	0ea60613          	addi	a2,a2,234 # ffffffffc0201a38 <etext+0x39e>
ffffffffc0200956:	05000593          	li	a1,80
ffffffffc020095a:	00001517          	auipc	a0,0x1
ffffffffc020095e:	0f650513          	addi	a0,a0,246 # ffffffffc0201a50 <etext+0x3b6>
struct Page *area_alloc_pages(size_t n) {
ffffffffc0200962:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200964:	865ff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200968 <area_free_pages.part.0>:
    for (; p != base + n; p++) {
ffffffffc0200968:	00259713          	slli	a4,a1,0x2
ffffffffc020096c:	972e                	add	a4,a4,a1
ffffffffc020096e:	070e                	slli	a4,a4,0x3
ffffffffc0200970:	00e506b3          	add	a3,a0,a4
ffffffffc0200974:	87aa                	mv	a5,a0
ffffffffc0200976:	cf09                	beqz	a4,ffffffffc0200990 <area_free_pages.part.0+0x28>
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200978:	6798                	ld	a4,8(a5)
ffffffffc020097a:	8b0d                	andi	a4,a4,3
ffffffffc020097c:	10071c63          	bnez	a4,ffffffffc0200a94 <area_free_pages.part.0+0x12c>
        p->flags = 0;
ffffffffc0200980:	0007b423          	sd	zero,8(a5)
ffffffffc0200984:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++) {
ffffffffc0200988:	02878793          	addi	a5,a5,40
ffffffffc020098c:	fed796e3          	bne	a5,a3,ffffffffc0200978 <area_free_pages.part.0+0x10>
    SetPageProperty(base);
ffffffffc0200990:	00853883          	ld	a7,8(a0)
    nr_free += n;
ffffffffc0200994:	00005717          	auipc	a4,0x5
ffffffffc0200998:	6f472703          	lw	a4,1780(a4) # ffffffffc0206088 <area+0x10>
ffffffffc020099c:	00005697          	auipc	a3,0x5
ffffffffc02009a0:	6dc68693          	addi	a3,a3,1756 # ffffffffc0206078 <area>
    return list->next == list;
ffffffffc02009a4:	669c                	ld	a5,8(a3)
    SetPageProperty(base);
ffffffffc02009a6:	0028e613          	ori	a2,a7,2
    base->property = n;
ffffffffc02009aa:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02009ac:	e510                	sd	a2,8(a0)
    nr_free += n;
ffffffffc02009ae:	9f2d                	addw	a4,a4,a1
ffffffffc02009b0:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02009b2:	0cd78663          	beq	a5,a3,ffffffffc0200a7e <area_free_pages.part.0+0x116>
            struct Page *page = le2page(le, page_link);
ffffffffc02009b6:	fe878713          	addi	a4,a5,-24
ffffffffc02009ba:	4801                	li	a6,0
ffffffffc02009bc:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc02009c0:	00e56a63          	bltu	a0,a4,ffffffffc02009d4 <area_free_pages.part.0+0x6c>
    return listelm->next;
ffffffffc02009c4:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02009c6:	06d70363          	beq	a4,a3,ffffffffc0200a2c <area_free_pages.part.0+0xc4>
    struct Page *p = base;
ffffffffc02009ca:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02009cc:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02009d0:	fee57ae3          	bgeu	a0,a4,ffffffffc02009c4 <area_free_pages.part.0+0x5c>
ffffffffc02009d4:	00080463          	beqz	a6,ffffffffc02009dc <area_free_pages.part.0+0x74>
ffffffffc02009d8:	0066b023          	sd	t1,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02009dc:	0007b803          	ld	a6,0(a5)
    prev->next = next->prev = elm;
ffffffffc02009e0:	e390                	sd	a2,0(a5)
ffffffffc02009e2:	00c83423          	sd	a2,8(a6)
    elm->prev = prev;
ffffffffc02009e6:	01053c23          	sd	a6,24(a0)
    elm->next = next;
ffffffffc02009ea:	f11c                	sd	a5,32(a0)
    if (prev_le != &free_list) {
ffffffffc02009ec:	02d80063          	beq	a6,a3,ffffffffc0200a0c <area_free_pages.part.0+0xa4>
        if (p + p->property == base) {
ffffffffc02009f0:	ff882e03          	lw	t3,-8(a6)
        p = le2page(prev_le, page_link);
ffffffffc02009f4:	fe880313          	addi	t1,a6,-24
        if (p + p->property == base) {
ffffffffc02009f8:	020e1613          	slli	a2,t3,0x20
ffffffffc02009fc:	9201                	srli	a2,a2,0x20
ffffffffc02009fe:	00261713          	slli	a4,a2,0x2
ffffffffc0200a02:	9732                	add	a4,a4,a2
ffffffffc0200a04:	070e                	slli	a4,a4,0x3
ffffffffc0200a06:	971a                	add	a4,a4,t1
ffffffffc0200a08:	04e50d63          	beq	a0,a4,ffffffffc0200a62 <area_free_pages.part.0+0xfa>
    if (next_le != &free_list) {
ffffffffc0200a0c:	00d78f63          	beq	a5,a3,ffffffffc0200a2a <area_free_pages.part.0+0xc2>
        if (base + base->property == p) {
ffffffffc0200a10:	490c                	lw	a1,16(a0)
        p = le2page(next_le, page_link);
ffffffffc0200a12:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p) {
ffffffffc0200a16:	02059613          	slli	a2,a1,0x20
ffffffffc0200a1a:	9201                	srli	a2,a2,0x20
ffffffffc0200a1c:	00261713          	slli	a4,a2,0x2
ffffffffc0200a20:	9732                	add	a4,a4,a2
ffffffffc0200a22:	070e                	slli	a4,a4,0x3
ffffffffc0200a24:	972a                	add	a4,a4,a0
ffffffffc0200a26:	00e68d63          	beq	a3,a4,ffffffffc0200a40 <area_free_pages.part.0+0xd8>
ffffffffc0200a2a:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0200a2c:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0200a2e:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0200a30:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0200a32:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0200a34:	8332                	mv	t1,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0200a36:	04d70b63          	beq	a4,a3,ffffffffc0200a8c <area_free_pages.part.0+0x124>
ffffffffc0200a3a:	4805                	li	a6,1
    struct Page *p = base;
ffffffffc0200a3c:	87ba                	mv	a5,a4
ffffffffc0200a3e:	b779                	j	ffffffffc02009cc <area_free_pages.part.0+0x64>
            base->property += p->property;
ffffffffc0200a40:	ff87a683          	lw	a3,-8(a5)
            ClearPageProperty(p);
ffffffffc0200a44:	ff07b703          	ld	a4,-16(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200a48:	0007b803          	ld	a6,0(a5)
ffffffffc0200a4c:	6790                	ld	a2,8(a5)
            base->property += p->property;
ffffffffc0200a4e:	9ead                	addw	a3,a3,a1
ffffffffc0200a50:	c914                	sw	a3,16(a0)
            ClearPageProperty(p);
ffffffffc0200a52:	9b75                	andi	a4,a4,-3
ffffffffc0200a54:	fee7b823          	sd	a4,-16(a5)
    prev->next = next;
ffffffffc0200a58:	00c83423          	sd	a2,8(a6)
    next->prev = prev;
ffffffffc0200a5c:	01063023          	sd	a6,0(a2)
ffffffffc0200a60:	8082                	ret
            p->property += base->property;
ffffffffc0200a62:	01c585bb          	addw	a1,a1,t3
ffffffffc0200a66:	feb82c23          	sw	a1,-8(a6)
            ClearPageProperty(base);
ffffffffc0200a6a:	ffd8f893          	andi	a7,a7,-3
ffffffffc0200a6e:	01153423          	sd	a7,8(a0)
    prev->next = next;
ffffffffc0200a72:	00f83423          	sd	a5,8(a6)
    next->prev = prev;
ffffffffc0200a76:	0107b023          	sd	a6,0(a5)
            base = p;
ffffffffc0200a7a:	851a                	mv	a0,t1
ffffffffc0200a7c:	bf41                	j	ffffffffc0200a0c <area_free_pages.part.0+0xa4>
        list_add(&free_list, &(base->page_link));
ffffffffc0200a7e:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0200a82:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200a84:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0200a86:	e398                	sd	a4,0(a5)
ffffffffc0200a88:	e798                	sd	a4,8(a5)
    if (next_le != &free_list) {
ffffffffc0200a8a:	8082                	ret
    return listelm->prev;
ffffffffc0200a8c:	883e                	mv	a6,a5
ffffffffc0200a8e:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200a90:	87b6                	mv	a5,a3
ffffffffc0200a92:	bfa9                	j	ffffffffc02009ec <area_free_pages.part.0+0x84>
void area_free_pages(struct Page *base, size_t n) {
ffffffffc0200a94:	1141                	addi	sp,sp,-16
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200a96:	00001697          	auipc	a3,0x1
ffffffffc0200a9a:	fe268693          	addi	a3,a3,-30 # ffffffffc0201a78 <etext+0x3de>
ffffffffc0200a9e:	00001617          	auipc	a2,0x1
ffffffffc0200aa2:	f9a60613          	addi	a2,a2,-102 # ffffffffc0201a38 <etext+0x39e>
ffffffffc0200aa6:	09c00593          	li	a1,156
ffffffffc0200aaa:	00001517          	auipc	a0,0x1
ffffffffc0200aae:	fa650513          	addi	a0,a0,-90 # ffffffffc0201a50 <etext+0x3b6>
void area_free_pages(struct Page *base, size_t n) {
ffffffffc0200ab2:	e406                	sd	ra,8(sp)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200ab4:	f14ff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200ab8 <area_free_pages>:
    assert(n > 0);
ffffffffc0200ab8:	c191                	beqz	a1,ffffffffc0200abc <area_free_pages+0x4>
ffffffffc0200aba:	b57d                	j	ffffffffc0200968 <area_free_pages.part.0>
void area_free_pages(struct Page *base, size_t n) {
ffffffffc0200abc:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0200abe:	00001697          	auipc	a3,0x1
ffffffffc0200ac2:	f7268693          	addi	a3,a3,-142 # ffffffffc0201a30 <etext+0x396>
ffffffffc0200ac6:	00001617          	auipc	a2,0x1
ffffffffc0200aca:	f7260613          	addi	a2,a2,-142 # ffffffffc0201a38 <etext+0x39e>
ffffffffc0200ace:	09900593          	li	a1,153
ffffffffc0200ad2:	00001517          	auipc	a0,0x1
ffffffffc0200ad6:	f7e50513          	addi	a0,a0,-130 # ffffffffc0201a50 <etext+0x3b6>
void area_free_pages(struct Page *base, size_t n) {
ffffffffc0200ada:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200adc:	eecff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200ae0 <slub_free_obj.part.0>:
    for (size_t cache_idx = 0; cache_idx < slub_cache_count; cache_idx++) {
ffffffffc0200ae0:	00005317          	auipc	t1,0x5
ffffffffc0200ae4:	5f833303          	ld	t1,1528(t1) # ffffffffc02060d8 <slub_cache_count>
ffffffffc0200ae8:	04030563          	beqz	t1,ffffffffc0200b32 <slub_free_obj.part.0+0x52>
ffffffffc0200aec:	00005897          	auipc	a7,0x5
ffffffffc0200af0:	52c88893          	addi	a7,a7,1324 # ffffffffc0206018 <slub_caches>
ffffffffc0200af4:	8746                	mv	a4,a7
ffffffffc0200af6:	4801                	li	a6,0
        list_entry_t *le = &cache->blocks;
ffffffffc0200af8:	86ba                	mv	a3,a4
    return listelm->next;
ffffffffc0200afa:	6694                	ld	a3,8(a3)
        while ((le = list_next(le)) != &cache->blocks) {
ffffffffc0200afc:	02e68c63          	beq	a3,a4,ffffffffc0200b34 <slub_free_obj.part.0+0x54>
            void *obj_end = obj_start + cache->obj_size * cache->obj_num;
ffffffffc0200b00:	6b0c                	ld	a1,16(a4)
ffffffffc0200b02:	6f1c                	ld	a5,24(a4)
            void *obj_start = blk->objs;
ffffffffc0200b04:	6e90                	ld	a2,24(a3)
            void *obj_end = obj_start + cache->obj_size * cache->obj_num;
ffffffffc0200b06:	02f587b3          	mul	a5,a1,a5
ffffffffc0200b0a:	97b2                	add	a5,a5,a2
            if (obj >= obj_start && obj < obj_end) {
ffffffffc0200b0c:	fef577e3          	bgeu	a0,a5,ffffffffc0200afa <slub_free_obj.part.0+0x1a>
ffffffffc0200b10:	fec565e3          	bltu	a0,a2,ffffffffc0200afa <slub_free_obj.part.0+0x1a>
                size_t obj_offset = (char *)obj - (char *)obj_start;
ffffffffc0200b14:	40c50633          	sub	a2,a0,a2
                size_t obj_idx = obj_offset / cache->obj_size;
ffffffffc0200b18:	02b65633          	divu	a2,a2,a1
                if (blk->bitmap[byte_idx] & (1 << bit_idx)) {
ffffffffc0200b1c:	729c                	ld	a5,32(a3)
                size_t byte_idx = obj_idx / 8;
ffffffffc0200b1e:	00365713          	srli	a4,a2,0x3
                if (blk->bitmap[byte_idx] & (1 << bit_idx)) {
ffffffffc0200b22:	97ba                	add	a5,a5,a4
ffffffffc0200b24:	0007c583          	lbu	a1,0(a5)
ffffffffc0200b28:	8a1d                	andi	a2,a2,7
ffffffffc0200b2a:	40c5d73b          	sraw	a4,a1,a2
ffffffffc0200b2e:	8b05                	andi	a4,a4,1
ffffffffc0200b30:	eb01                	bnez	a4,ffffffffc0200b40 <slub_free_obj.part.0+0x60>
ffffffffc0200b32:	8082                	ret
    for (size_t cache_idx = 0; cache_idx < slub_cache_count; cache_idx++) {
ffffffffc0200b34:	0805                	addi	a6,a6,1
ffffffffc0200b36:	02070713          	addi	a4,a4,32
ffffffffc0200b3a:	fa681fe3          	bne	a6,t1,ffffffffc0200af8 <slub_free_obj.part.0+0x18>
ffffffffc0200b3e:	8082                	ret
                    blk->bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffffc0200b40:	4705                	li	a4,1
ffffffffc0200b42:	00c7173b          	sllw	a4,a4,a2
void slub_free_obj(void *obj) {
ffffffffc0200b46:	1101                	addi	sp,sp,-32
                    blk->bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffffc0200b48:	fff74713          	not	a4,a4
ffffffffc0200b4c:	8df9                	and	a1,a1,a4
void slub_free_obj(void *obj) {
ffffffffc0200b4e:	ec06                	sd	ra,24(sp)
                    blk->bitmap[byte_idx] &= ~(1 << bit_idx);
ffffffffc0200b50:	00b78023          	sb	a1,0(a5)
                    blk->free_cnt++;
ffffffffc0200b54:	6a9c                	ld	a5,16(a3)
                    memset(obj, 0, cache->obj_size);
ffffffffc0200b56:	0816                	slli	a6,a6,0x5
ffffffffc0200b58:	98c2                	add	a7,a7,a6
ffffffffc0200b5a:	0108b603          	ld	a2,16(a7)
                    blk->free_cnt++;
ffffffffc0200b5e:	0785                	addi	a5,a5,1
ffffffffc0200b60:	ea9c                	sd	a5,16(a3)
                    memset(obj, 0, cache->obj_size);
ffffffffc0200b62:	4581                	li	a1,0
ffffffffc0200b64:	e446                	sd	a7,8(sp)
                    blk->free_cnt++;
ffffffffc0200b66:	e036                	sd	a3,0(sp)
                    memset(obj, 0, cache->obj_size);
ffffffffc0200b68:	321000ef          	jal	ffffffffc0201688 <memset>
                    if (blk->free_cnt == cache->obj_num) {
ffffffffc0200b6c:	68a2                	ld	a7,8(sp)
ffffffffc0200b6e:	6682                	ld	a3,0(sp)
ffffffffc0200b70:	0188b783          	ld	a5,24(a7)
ffffffffc0200b74:	6a98                	ld	a4,16(a3)
ffffffffc0200b76:	04f71963          	bne	a4,a5,ffffffffc0200bc8 <slub_free_obj.part.0+0xe8>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200b7a:	6298                	ld	a4,0(a3)
ffffffffc0200b7c:	669c                	ld	a5,8(a3)
                        struct Page *blk_page = pa2page(PADDR(blk));
ffffffffc0200b7e:	c0200637          	lui	a2,0xc0200
    prev->next = next;
ffffffffc0200b82:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0200b84:	e398                	sd	a4,0(a5)
ffffffffc0200b86:	06c6e063          	bltu	a3,a2,ffffffffc0200be6 <slub_free_obj.part.0+0x106>
ffffffffc0200b8a:	00005797          	auipc	a5,0x5
ffffffffc0200b8e:	5367b783          	ld	a5,1334(a5) # ffffffffc02060c0 <va_pa_offset>
    if (PPN(pa) >= npage) {
ffffffffc0200b92:	00005717          	auipc	a4,0x5
ffffffffc0200b96:	53673703          	ld	a4,1334(a4) # ffffffffc02060c8 <npage>
ffffffffc0200b9a:	40f687b3          	sub	a5,a3,a5
ffffffffc0200b9e:	83b1                	srli	a5,a5,0xc
ffffffffc0200ba0:	02e7f763          	bgeu	a5,a4,ffffffffc0200bce <slub_free_obj.part.0+0xee>
    return &pages[PPN(pa) - nbase];
ffffffffc0200ba4:	00001717          	auipc	a4,0x1
ffffffffc0200ba8:	5b473703          	ld	a4,1460(a4) # ffffffffc0202158 <nbase>
ffffffffc0200bac:	00005517          	auipc	a0,0x5
ffffffffc0200bb0:	52453503          	ld	a0,1316(a0) # ffffffffc02060d0 <pages>
}
ffffffffc0200bb4:	60e2                	ld	ra,24(sp)
ffffffffc0200bb6:	8f99                	sub	a5,a5,a4
ffffffffc0200bb8:	00279713          	slli	a4,a5,0x2
ffffffffc0200bbc:	97ba                	add	a5,a5,a4
ffffffffc0200bbe:	078e                	slli	a5,a5,0x3
ffffffffc0200bc0:	4585                	li	a1,1
ffffffffc0200bc2:	953e                	add	a0,a0,a5
ffffffffc0200bc4:	6105                	addi	sp,sp,32
ffffffffc0200bc6:	b34d                	j	ffffffffc0200968 <area_free_pages.part.0>
ffffffffc0200bc8:	60e2                	ld	ra,24(sp)
ffffffffc0200bca:	6105                	addi	sp,sp,32
ffffffffc0200bcc:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0200bce:	00001617          	auipc	a2,0x1
ffffffffc0200bd2:	dd260613          	addi	a2,a2,-558 # ffffffffc02019a0 <etext+0x306>
ffffffffc0200bd6:	06a00593          	li	a1,106
ffffffffc0200bda:	00001517          	auipc	a0,0x1
ffffffffc0200bde:	de650513          	addi	a0,a0,-538 # ffffffffc02019c0 <etext+0x326>
ffffffffc0200be2:	de6ff0ef          	jal	ffffffffc02001c8 <__panic>
                        struct Page *blk_page = pa2page(PADDR(blk));
ffffffffc0200be6:	00001617          	auipc	a2,0x1
ffffffffc0200bea:	d9260613          	addi	a2,a2,-622 # ffffffffc0201978 <etext+0x2de>
ffffffffc0200bee:	0da00593          	li	a1,218
ffffffffc0200bf2:	00001517          	auipc	a0,0x1
ffffffffc0200bf6:	e5e50513          	addi	a0,a0,-418 # ffffffffc0201a50 <etext+0x3b6>
ffffffffc0200bfa:	dceff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200bfe <slub_alloc_obj>:
    if (size == 0 || size > 128) return NULL;
ffffffffc0200bfe:	fff50713          	addi	a4,a0,-1
ffffffffc0200c02:	07f00793          	li	a5,127
ffffffffc0200c06:	0ae7e263          	bltu	a5,a4,ffffffffc0200caa <slub_alloc_obj+0xac>
    for (int i = 0; i < slub_cache_count; i++) {
ffffffffc0200c0a:	00005697          	auipc	a3,0x5
ffffffffc0200c0e:	4ce6b683          	ld	a3,1230(a3) # ffffffffc02060d8 <slub_cache_count>
ffffffffc0200c12:	cec1                	beqz	a3,ffffffffc0200caa <slub_alloc_obj+0xac>
ffffffffc0200c14:	00005f17          	auipc	t5,0x5
ffffffffc0200c18:	404f0f13          	addi	t5,t5,1028 # ffffffffc0206018 <slub_caches>
ffffffffc0200c1c:	877a                	mv	a4,t5
ffffffffc0200c1e:	4781                	li	a5,0
ffffffffc0200c20:	a021                	j	ffffffffc0200c28 <slub_alloc_obj+0x2a>
ffffffffc0200c22:	0785                	addi	a5,a5,1
ffffffffc0200c24:	08f68363          	beq	a3,a5,ffffffffc0200caa <slub_alloc_obj+0xac>
        if (slub_caches[i].obj_size >= size) {
ffffffffc0200c28:	01073803          	ld	a6,16(a4)
    for (int i = 0; i < slub_cache_count; i++) {
ffffffffc0200c2c:	02070713          	addi	a4,a4,32
        if (slub_caches[i].obj_size >= size) {
ffffffffc0200c30:	fea869e3          	bltu	a6,a0,ffffffffc0200c22 <slub_alloc_obj+0x24>
ffffffffc0200c34:	2781                	sext.w	a5,a5
            target_cache = &slub_caches[i];
ffffffffc0200c36:	00579713          	slli	a4,a5,0x5
ffffffffc0200c3a:	00ef0eb3          	add	t4,t5,a4
    return listelm->next;
ffffffffc0200c3e:	008eb883          	ld	a7,8(t4)
    while ((le = list_next(le)) != &target_cache->blocks) {
ffffffffc0200c42:	011e9763          	bne	t4,a7,ffffffffc0200c50 <slub_alloc_obj+0x52>
ffffffffc0200c46:	a0a5                	j	ffffffffc0200cae <slub_alloc_obj+0xb0>
ffffffffc0200c48:	0088b883          	ld	a7,8(a7)
ffffffffc0200c4c:	071e8163          	beq	t4,a7,ffffffffc0200cae <slub_alloc_obj+0xb0>
        if (blk->free_cnt > 0) {
ffffffffc0200c50:	0108b783          	ld	a5,16(a7)
ffffffffc0200c54:	dbf5                	beqz	a5,ffffffffc0200c48 <slub_alloc_obj+0x4a>
            for (size_t obj_idx = 0; obj_idx < target_cache->obj_num; obj_idx++) {
ffffffffc0200c56:	018eb303          	ld	t1,24(t4)
ffffffffc0200c5a:	fe0307e3          	beqz	t1,ffffffffc0200c48 <slub_alloc_obj+0x4a>
                if (!(blk->bitmap[byte_idx] & (1 << bit_idx))) {
ffffffffc0200c5e:	0208be03          	ld	t3,32(a7)
            for (size_t obj_idx = 0; obj_idx < target_cache->obj_num; obj_idx++) {
ffffffffc0200c62:	4781                	li	a5,0
ffffffffc0200c64:	a021                	j	ffffffffc0200c6c <slub_alloc_obj+0x6e>
ffffffffc0200c66:	0785                	addi	a5,a5,1
ffffffffc0200c68:	fef300e3          	beq	t1,a5,ffffffffc0200c48 <slub_alloc_obj+0x4a>
                size_t byte_idx = obj_idx / 8;
ffffffffc0200c6c:	0037d693          	srli	a3,a5,0x3
                if (!(blk->bitmap[byte_idx] & (1 << bit_idx))) {
ffffffffc0200c70:	96f2                	add	a3,a3,t3
ffffffffc0200c72:	0006c583          	lbu	a1,0(a3)
ffffffffc0200c76:	0077f513          	andi	a0,a5,7
ffffffffc0200c7a:	40a5d63b          	sraw	a2,a1,a0
ffffffffc0200c7e:	8a05                	andi	a2,a2,1
ffffffffc0200c80:	f27d                	bnez	a2,ffffffffc0200c66 <slub_alloc_obj+0x68>
                    blk->bitmap[byte_idx] |= (1 << bit_idx);
ffffffffc0200c82:	4605                	li	a2,1
ffffffffc0200c84:	00a6163b          	sllw	a2,a2,a0
ffffffffc0200c88:	8dd1                	or	a1,a1,a2
ffffffffc0200c8a:	00b68023          	sb	a1,0(a3)
                    return blk->objs + obj_idx * target_cache->obj_size;
ffffffffc0200c8e:	9f3a                	add	t5,t5,a4
ffffffffc0200c90:	010f3683          	ld	a3,16(t5)
                    blk->free_cnt--;
ffffffffc0200c94:	0108b703          	ld	a4,16(a7)
                    return blk->objs + obj_idx * target_cache->obj_size;
ffffffffc0200c98:	0188b503          	ld	a0,24(a7)
ffffffffc0200c9c:	02d787b3          	mul	a5,a5,a3
                    blk->free_cnt--;
ffffffffc0200ca0:	177d                	addi	a4,a4,-1
ffffffffc0200ca2:	00e8b823          	sd	a4,16(a7)
                    return blk->objs + obj_idx * target_cache->obj_size;
ffffffffc0200ca6:	953e                	add	a0,a0,a5
ffffffffc0200ca8:	8082                	ret
    if (size == 0 || size > 128) return NULL;
ffffffffc0200caa:	4501                	li	a0,0
}
ffffffffc0200cac:	8082                	ret
    slub_block_t *new_blk = slub_block_create(target_cache->obj_size, target_cache->obj_num);
ffffffffc0200cae:	9f3a                	add	t5,t5,a4
ffffffffc0200cb0:	018f3683          	ld	a3,24(t5)
void *slub_alloc_obj(size_t size) {
ffffffffc0200cb4:	7179                	addi	sp,sp,-48
    struct Page *page = area_alloc_pages(1);
ffffffffc0200cb6:	4505                	li	a0,1
void *slub_alloc_obj(size_t size) {
ffffffffc0200cb8:	f406                	sd	ra,40(sp)
ffffffffc0200cba:	ec76                	sd	t4,24(sp)
ffffffffc0200cbc:	e842                	sd	a6,16(sp)
    slub_block_t *new_blk = slub_block_create(target_cache->obj_size, target_cache->obj_num);
ffffffffc0200cbe:	e436                	sd	a3,8(sp)
    struct Page *page = area_alloc_pages(1);
ffffffffc0200cc0:	bedff0ef          	jal	ffffffffc02008ac <area_alloc_pages>
    if (!page) return NULL;
ffffffffc0200cc4:	c541                	beqz	a0,ffffffffc0200d4c <slub_alloc_obj+0x14e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200cc6:	00005797          	auipc	a5,0x5
ffffffffc0200cca:	40a7b783          	ld	a5,1034(a5) # ffffffffc02060d0 <pages>
ffffffffc0200cce:	ccccd737          	lui	a4,0xccccd
ffffffffc0200cd2:	ccd70713          	addi	a4,a4,-819 # ffffffffcccccccd <end+0xcac6bed>
ffffffffc0200cd6:	02071613          	slli	a2,a4,0x20
ffffffffc0200cda:	40f507b3          	sub	a5,a0,a5
ffffffffc0200cde:	963a                	add	a2,a2,a4
ffffffffc0200ce0:	878d                	srai	a5,a5,0x3
ffffffffc0200ce2:	02c787b3          	mul	a5,a5,a2
    memset(blk->bitmap, 0, (obj_num + 7) / 8);
ffffffffc0200ce6:	66a2                	ld	a3,8(sp)
    blk->bitmap = (unsigned char *)(blk->objs + obj_size * obj_num);
ffffffffc0200ce8:	6842                	ld	a6,16(sp)
ffffffffc0200cea:	00001717          	auipc	a4,0x1
ffffffffc0200cee:	46e73703          	ld	a4,1134(a4) # ffffffffc0202158 <nbase>
    memset(blk->bitmap, 0, (obj_num + 7) / 8);
ffffffffc0200cf2:	00768613          	addi	a2,a3,7
ffffffffc0200cf6:	820d                	srli	a2,a2,0x3
ffffffffc0200cf8:	4581                	li	a1,0
    blk->bitmap = (unsigned char *)(blk->objs + obj_size * obj_num);
ffffffffc0200cfa:	02d80833          	mul	a6,a6,a3
ffffffffc0200cfe:	97ba                	add	a5,a5,a4
    void *page_vaddr = KADDR(page2pa(page));
ffffffffc0200d00:	07b2                	slli	a5,a5,0xc
ffffffffc0200d02:	c0200737          	lui	a4,0xc0200
ffffffffc0200d06:	97ba                	add	a5,a5,a4
    blk->objs = (void *)blk + sizeof(slub_block_t);
ffffffffc0200d08:	02878513          	addi	a0,a5,40
ffffffffc0200d0c:	ef88                	sd	a0,24(a5)
    blk->free_cnt = obj_num;
ffffffffc0200d0e:	eb94                	sd	a3,16(a5)
    blk->bitmap = (unsigned char *)(blk->objs + obj_size * obj_num);
ffffffffc0200d10:	e43e                	sd	a5,8(sp)
ffffffffc0200d12:	9542                	add	a0,a0,a6
ffffffffc0200d14:	f388                	sd	a0,32(a5)
    memset(blk->bitmap, 0, (obj_num + 7) / 8);
ffffffffc0200d16:	173000ef          	jal	ffffffffc0201688 <memset>
    elm->prev = elm->next = elm;
ffffffffc0200d1a:	67a2                	ld	a5,8(sp)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200d1c:	6ee2                	ld	t4,24(sp)
    elm->prev = elm->next = elm;
ffffffffc0200d1e:	e79c                	sd	a5,8(a5)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200d20:	008eb703          	ld	a4,8(t4)
    new_blk->bitmap[0] |= 1 << 0;
ffffffffc0200d24:	7394                	ld	a3,32(a5)
    prev->next = next->prev = elm;
ffffffffc0200d26:	e31c                	sd	a5,0(a4)
ffffffffc0200d28:	00feb423          	sd	a5,8(t4)
    elm->next = next;
ffffffffc0200d2c:	e798                	sd	a4,8(a5)
    elm->prev = prev;
ffffffffc0200d2e:	01d7b023          	sd	t4,0(a5)
ffffffffc0200d32:	0006c703          	lbu	a4,0(a3)
ffffffffc0200d36:	00176713          	ori	a4,a4,1
ffffffffc0200d3a:	00e68023          	sb	a4,0(a3)
    new_blk->free_cnt--;
ffffffffc0200d3e:	6b98                	ld	a4,16(a5)
    return new_blk->objs;
ffffffffc0200d40:	6f88                	ld	a0,24(a5)
    new_blk->free_cnt--;
ffffffffc0200d42:	177d                	addi	a4,a4,-1 # ffffffffc01fffff <kern_entry-0x1>
ffffffffc0200d44:	eb98                	sd	a4,16(a5)
}
ffffffffc0200d46:	70a2                	ld	ra,40(sp)
ffffffffc0200d48:	6145                	addi	sp,sp,48
ffffffffc0200d4a:	8082                	ret
    if (size == 0 || size > 128) return NULL;
ffffffffc0200d4c:	4501                	li	a0,0
ffffffffc0200d4e:	bfe5                	j	ffffffffc0200d46 <slub_alloc_obj+0x148>

ffffffffc0200d50 <slub_check>:

void slub_check(void) {
ffffffffc0200d50:	fffc52b7          	lui	t0,0xfffc5
ffffffffc0200d54:	711d                	addi	sp,sp,-96
ffffffffc0200d56:	52028293          	addi	t0,t0,1312 # fffffffffffc5520 <end+0x3fdbf440>
ffffffffc0200d5a:	fc4e                	sd	s3,56(sp)
ffffffffc0200d5c:	ec86                	sd	ra,88(sp)
ffffffffc0200d5e:	e8a2                	sd	s0,80(sp)
ffffffffc0200d60:	e4a6                	sd	s1,72(sp)
ffffffffc0200d62:	e0ca                	sd	s2,64(sp)
ffffffffc0200d64:	f852                	sd	s4,48(sp)
ffffffffc0200d66:	f456                	sd	s5,40(sp)
ffffffffc0200d68:	f05a                	sd	s6,32(sp)
ffffffffc0200d6a:	ec5e                	sd	s7,24(sp)
ffffffffc0200d6c:	e862                	sd	s8,16(sp)
ffffffffc0200d6e:	e466                	sd	s9,8(sp)
    // 替换%zu为%lu，size_t转换为unsigned long
    cprintf("SLUB allocator check: slub_block struct size = %lu bytes\n", (unsigned long)sizeof(slub_block_t));
ffffffffc0200d70:	02800593          	li	a1,40
void slub_check(void) {
ffffffffc0200d74:	9116                	add	sp,sp,t0
    cprintf("SLUB allocator check: slub_block struct size = %lu bytes\n", (unsigned long)sizeof(slub_block_t));
ffffffffc0200d76:	00001517          	auipc	a0,0x1
ffffffffc0200d7a:	d2a50513          	addi	a0,a0,-726 # ffffffffc0201aa0 <etext+0x406>
ffffffffc0200d7e:	bcaff0ef          	jal	ffffffffc0200148 <cprintf>
    size_t expect_obj_num[3] = {126, 63, 31};
    for (int i = 0; i < slub_cache_count; i++) {
ffffffffc0200d82:	00005997          	auipc	s3,0x5
ffffffffc0200d86:	35698993          	addi	s3,s3,854 # ffffffffc02060d8 <slub_cache_count>
ffffffffc0200d8a:	0009b783          	ld	a5,0(s3)
    size_t expect_obj_num[3] = {126, 63, 31};
ffffffffc0200d8e:	07e00613          	li	a2,126
ffffffffc0200d92:	03f00693          	li	a3,63
ffffffffc0200d96:	477d                	li	a4,31
ffffffffc0200d98:	e432                	sd	a2,8(sp)
ffffffffc0200d9a:	e836                	sd	a3,16(sp)
ffffffffc0200d9c:	ec3a                	sd	a4,24(sp)
    for (int i = 0; i < slub_cache_count; i++) {
ffffffffc0200d9e:	cf95                	beqz	a5,ffffffffc0200dda <slub_check+0x8a>
ffffffffc0200da0:	00810913          	addi	s2,sp,8
ffffffffc0200da4:	00005497          	auipc	s1,0x5
ffffffffc0200da8:	27448493          	addi	s1,s1,628 # ffffffffc0206018 <slub_caches>
ffffffffc0200dac:	4401                	li	s0,0
        assert(slub_caches[i].obj_num == expect_obj_num[i]);
ffffffffc0200dae:	6c94                	ld	a3,24(s1)
ffffffffc0200db0:	00093783          	ld	a5,0(s2)
ffffffffc0200db4:	30f69f63          	bne	a3,a5,ffffffffc02010d2 <slub_check+0x382>
        // 替换%zu为%lu，变量转换为unsigned long
        cprintf("Cache %d: obj_size=%luB, obj_num=%lu\n", 
ffffffffc0200db8:	6890                	ld	a2,16(s1)
ffffffffc0200dba:	0004059b          	sext.w	a1,s0
ffffffffc0200dbe:	00001517          	auipc	a0,0x1
ffffffffc0200dc2:	d5250513          	addi	a0,a0,-686 # ffffffffc0201b10 <etext+0x476>
ffffffffc0200dc6:	b82ff0ef          	jal	ffffffffc0200148 <cprintf>
    for (int i = 0; i < slub_cache_count; i++) {
ffffffffc0200dca:	0009b783          	ld	a5,0(s3)
ffffffffc0200dce:	0405                	addi	s0,s0,1
ffffffffc0200dd0:	02048493          	addi	s1,s1,32
ffffffffc0200dd4:	0921                	addi	s2,s2,8
ffffffffc0200dd6:	fcf46ce3          	bltu	s0,a5,ffffffffc0200dae <slub_check+0x5e>
                i, (unsigned long)slub_caches[i].obj_size, (unsigned long)slub_caches[i].obj_num);
    }
    size_t base_free_pages = nr_free;
ffffffffc0200dda:	00005917          	auipc	s2,0x5
ffffffffc0200dde:	2ae92903          	lw	s2,686(s2) # ffffffffc0206088 <area+0x10>
    // 替换%zu为%lu，变量转换为unsigned long
    cprintf("Initial free pages: %lu\n", (unsigned long)base_free_pages);
ffffffffc0200de2:	00001517          	auipc	a0,0x1
ffffffffc0200de6:	d5650513          	addi	a0,a0,-682 # ffffffffc0201b38 <etext+0x49e>
    size_t base_free_pages = nr_free;
ffffffffc0200dea:	02091993          	slli	s3,s2,0x20
ffffffffc0200dee:	0209d993          	srli	s3,s3,0x20
    cprintf("Initial free pages: %lu\n", (unsigned long)base_free_pages);
ffffffffc0200df2:	85ce                	mv	a1,s3
ffffffffc0200df4:	b54ff0ef          	jal	ffffffffc0200148 <cprintf>
    
    assert(slub_alloc_obj(0) == NULL);
    assert(slub_alloc_obj(256) == NULL);
    cprintf("Boundary test passed: alloc 0B/256B → NULL\n");
ffffffffc0200df8:	00001517          	auipc	a0,0x1
ffffffffc0200dfc:	d6050513          	addi	a0,a0,-672 # ffffffffc0201b58 <etext+0x4be>
ffffffffc0200e00:	b48ff0ef          	jal	ffffffffc0200148 <cprintf>
    
    // 新增：标记进入单个对象测试
    cprintf("Start single object test...\n");
ffffffffc0200e04:	00001517          	auipc	a0,0x1
ffffffffc0200e08:	d8450513          	addi	a0,a0,-636 # ffffffffc0201b88 <etext+0x4ee>
ffffffffc0200e0c:	b3cff0ef          	jal	ffffffffc0200148 <cprintf>
    void *obj1 = slub_alloc_obj(32);
ffffffffc0200e10:	02000513          	li	a0,32
ffffffffc0200e14:	debff0ef          	jal	ffffffffc0200bfe <slub_alloc_obj>
ffffffffc0200e18:	842a                	mv	s0,a0
    // 新增：打印 obj1 是否为 NULL
    cprintf("obj1 address: %p\n", obj1);
ffffffffc0200e1a:	85aa                	mv	a1,a0
ffffffffc0200e1c:	00001517          	auipc	a0,0x1
ffffffffc0200e20:	d8c50513          	addi	a0,a0,-628 # ffffffffc0201ba8 <etext+0x50e>
ffffffffc0200e24:	b24ff0ef          	jal	ffffffffc0200148 <cprintf>
    assert(obj1 != NULL);  // 若 obj1 是 NULL，这里会 panic
ffffffffc0200e28:	3c040563          	beqz	s0,ffffffffc02011f2 <slub_check+0x4a2>
    
    memset(obj1, 0x66, 32);
ffffffffc0200e2c:	02000613          	li	a2,32
ffffffffc0200e30:	06600593          	li	a1,102
ffffffffc0200e34:	8522                	mv	a0,s0
ffffffffc0200e36:	053000ef          	jal	ffffffffc0201688 <memset>
    // 新增：标记 memset 完成
    cprintf("memset obj1 done...\n");
ffffffffc0200e3a:	00001517          	auipc	a0,0x1
ffffffffc0200e3e:	d9650513          	addi	a0,a0,-618 # ffffffffc0201bd0 <etext+0x536>
ffffffffc0200e42:	b06ff0ef          	jal	ffffffffc0200148 <cprintf>
    for (int i = 0; i < 32; i++) {
ffffffffc0200e46:	87a2                	mv	a5,s0
ffffffffc0200e48:	02040613          	addi	a2,s0,32
        assert(((unsigned char *)obj1)[i] == 0x66);
ffffffffc0200e4c:	06600693          	li	a3,102
ffffffffc0200e50:	0007c703          	lbu	a4,0(a5)
ffffffffc0200e54:	2ed71f63          	bne	a4,a3,ffffffffc0201152 <slub_check+0x402>
    for (int i = 0; i < 32; i++) {
ffffffffc0200e58:	0785                	addi	a5,a5,1
ffffffffc0200e5a:	fec79be3          	bne	a5,a2,ffffffffc0200e50 <slub_check+0x100>
    if (!obj) return;
ffffffffc0200e5e:	8522                	mv	a0,s0
ffffffffc0200e60:	c81ff0ef          	jal	ffffffffc0200ae0 <slub_free_obj.part.0>
    }
    slub_free_obj(obj1);
    cprintf("Single object (32B) alloc/free test passed\n");
ffffffffc0200e64:	00001517          	auipc	a0,0x1
ffffffffc0200e68:	dac50513          	addi	a0,a0,-596 # ffffffffc0201c10 <etext+0x576>
ffffffffc0200e6c:	02010a13          	addi	s4,sp,32
ffffffffc0200e70:	ad8ff0ef          	jal	ffffffffc0200148 <cprintf>
ffffffffc0200e74:	8b52                	mv	s6,s4
    
    void *objs[10];
    for (int i = 0; i < 10; i++) {
ffffffffc0200e76:	4a81                	li	s5,0
ffffffffc0200e78:	4ba9                	li	s7,10
        objs[i] = slub_alloc_obj(64);
ffffffffc0200e7a:	04000513          	li	a0,64
ffffffffc0200e7e:	d81ff0ef          	jal	ffffffffc0200bfe <slub_alloc_obj>
ffffffffc0200e82:	00ab3023          	sd	a0,0(s6)
ffffffffc0200e86:	842a                	mv	s0,a0
        assert(objs[i] != NULL);
ffffffffc0200e88:	32050563          	beqz	a0,ffffffffc02011b2 <slub_check+0x462>
        memset(objs[i], i, 64);
ffffffffc0200e8c:	0ffaf493          	zext.b	s1,s5
ffffffffc0200e90:	85a6                	mv	a1,s1
ffffffffc0200e92:	04000613          	li	a2,64
ffffffffc0200e96:	7f2000ef          	jal	ffffffffc0201688 <memset>
        for (int j = 0; j < 64; j++) {
ffffffffc0200e9a:	8522                	mv	a0,s0
ffffffffc0200e9c:	04040713          	addi	a4,s0,64
            assert(((unsigned char *)objs[i])[j] == (unsigned char)i);
ffffffffc0200ea0:	00054783          	lbu	a5,0(a0)
ffffffffc0200ea4:	1e979763          	bne	a5,s1,ffffffffc0201092 <slub_check+0x342>
        for (int j = 0; j < 64; j++) {
ffffffffc0200ea8:	0505                	addi	a0,a0,1
ffffffffc0200eaa:	fee51be3          	bne	a0,a4,ffffffffc0200ea0 <slub_check+0x150>
    for (int i = 0; i < 10; i++) {
ffffffffc0200eae:	2a85                	addiw	s5,s5,1
ffffffffc0200eb0:	0b21                	addi	s6,s6,8
ffffffffc0200eb2:	fd7a94e3          	bne	s5,s7,ffffffffc0200e7a <slub_check+0x12a>
ffffffffc0200eb6:	050a0493          	addi	s1,s4,80
        }
    }
    for (int i = 0; i < 10; i++) {
        slub_free_obj(objs[i]);
ffffffffc0200eba:	000a3403          	ld	s0,0(s4)
    if (!obj) return;
ffffffffc0200ebe:	c401                	beqz	s0,ffffffffc0200ec6 <slub_check+0x176>
ffffffffc0200ec0:	8522                	mv	a0,s0
ffffffffc0200ec2:	c1fff0ef          	jal	ffffffffc0200ae0 <slub_free_obj.part.0>
        for (int j = 0; j < 64; j++) {
ffffffffc0200ec6:	8522                	mv	a0,s0
ffffffffc0200ec8:	04040713          	addi	a4,s0,64
            assert(((unsigned char *)objs[i])[j] == 0x00);
ffffffffc0200ecc:	00054783          	lbu	a5,0(a0)
ffffffffc0200ed0:	1e079163          	bnez	a5,ffffffffc02010b2 <slub_check+0x362>
        for (int j = 0; j < 64; j++) {
ffffffffc0200ed4:	0505                	addi	a0,a0,1
ffffffffc0200ed6:	fee51be3          	bne	a0,a4,ffffffffc0200ecc <slub_check+0x17c>
    for (int i = 0; i < 10; i++) {
ffffffffc0200eda:	0a21                	addi	s4,s4,8
ffffffffc0200edc:	fc9a1fe3          	bne	s4,s1,ffffffffc0200eba <slub_check+0x16a>
        }
    }
    cprintf("Multiple objects (64B) alloc/free test passed\n");
ffffffffc0200ee0:	6451                	lui	s0,0x14
ffffffffc0200ee2:	16010a13          	addi	s4,sp,352
ffffffffc0200ee6:	00001517          	auipc	a0,0x1
ffffffffc0200eea:	dca50513          	addi	a0,a0,-566 # ffffffffc0201cb0 <etext+0x616>
ffffffffc0200eee:	88040413          	addi	s0,s0,-1920 # 13880 <kern_entry-0xffffffffc01ec780>
ffffffffc0200ef2:	a56ff0ef          	jal	ffffffffc0200148 <cprintf>
    
    void *bulk_objs[30000];
    size_t free_pages_mid1, free_pages_mid2;
    
    for (int i = 0; i < 10000; i++) {
ffffffffc0200ef6:	9452                	add	s0,s0,s4
    cprintf("Multiple objects (64B) alloc/free test passed\n");
ffffffffc0200ef8:	84d2                	mv	s1,s4
        bulk_objs[i] = slub_alloc_obj(25);
ffffffffc0200efa:	4565                	li	a0,25
ffffffffc0200efc:	d03ff0ef          	jal	ffffffffc0200bfe <slub_alloc_obj>
ffffffffc0200f00:	e088                	sd	a0,0(s1)
        assert(bulk_objs[i] != NULL);
ffffffffc0200f02:	26050863          	beqz	a0,ffffffffc0201172 <slub_check+0x422>
    for (int i = 0; i < 10000; i++) {
ffffffffc0200f06:	04a1                	addi	s1,s1,8
ffffffffc0200f08:	fe8499e3          	bne	s1,s0,ffffffffc0200efa <slub_check+0x1aa>
    }
    free_pages_mid1 = nr_free;
    // 替换%zu为%lu，变量转换为unsigned long
    cprintf("After alloc 10000×25B: free pages = %lu\n", (unsigned long)free_pages_mid1);
ffffffffc0200f0c:	00005597          	auipc	a1,0x5
ffffffffc0200f10:	17c5e583          	lwu	a1,380(a1) # ffffffffc0206088 <area+0x10>
ffffffffc0200f14:	000274b7          	lui	s1,0x27
ffffffffc0200f18:	00001517          	auipc	a0,0x1
ffffffffc0200f1c:	de050513          	addi	a0,a0,-544 # ffffffffc0201cf8 <etext+0x65e>
ffffffffc0200f20:	10048493          	addi	s1,s1,256 # 27100 <kern_entry-0xffffffffc01d8f00>
ffffffffc0200f24:	a24ff0ef          	jal	ffffffffc0200148 <cprintf>
    
    for (int i = 0; i < 10000; i++) {
ffffffffc0200f28:	94d2                	add	s1,s1,s4
        bulk_objs[10000 + i] = slub_alloc_obj(62);
ffffffffc0200f2a:	03e00513          	li	a0,62
ffffffffc0200f2e:	cd1ff0ef          	jal	ffffffffc0200bfe <slub_alloc_obj>
ffffffffc0200f32:	e008                	sd	a0,0(s0)
        assert(bulk_objs[10000 + i] != NULL);
ffffffffc0200f34:	1e050f63          	beqz	a0,ffffffffc0201132 <slub_check+0x3e2>
    for (int i = 0; i < 10000; i++) {
ffffffffc0200f38:	0421                	addi	s0,s0,8
ffffffffc0200f3a:	fe9418e3          	bne	s0,s1,ffffffffc0200f2a <slub_check+0x1da>
    }
    free_pages_mid2 = nr_free;
    // 替换%zu为%lu，变量转换为unsigned long
    cprintf("After alloc 10000×62B: free pages = %lu\n", (unsigned long)free_pages_mid2);
ffffffffc0200f3e:	00005597          	auipc	a1,0x5
ffffffffc0200f42:	14a5e583          	lwu	a1,330(a1) # ffffffffc0206088 <area+0x10>
ffffffffc0200f46:	0003b437          	lui	s0,0x3b
ffffffffc0200f4a:	00001517          	auipc	a0,0x1
ffffffffc0200f4e:	dfe50513          	addi	a0,a0,-514 # ffffffffc0201d48 <etext+0x6ae>
ffffffffc0200f52:	98040413          	addi	s0,s0,-1664 # 3a980 <kern_entry-0xffffffffc01c5680>
ffffffffc0200f56:	9f2ff0ef          	jal	ffffffffc0200148 <cprintf>
    
    for (int i = 0; i < 10000; i++) {
ffffffffc0200f5a:	9452                	add	s0,s0,s4
        bulk_objs[20000 + i] = slub_alloc_obj(124);
ffffffffc0200f5c:	07c00513          	li	a0,124
ffffffffc0200f60:	c9fff0ef          	jal	ffffffffc0200bfe <slub_alloc_obj>
ffffffffc0200f64:	e088                	sd	a0,0(s1)
        assert(bulk_objs[20000 + i] != NULL);
ffffffffc0200f66:	1a050663          	beqz	a0,ffffffffc0201112 <slub_check+0x3c2>
    for (int i = 0; i < 10000; i++) {
ffffffffc0200f6a:	04a1                	addi	s1,s1,8
ffffffffc0200f6c:	fe8498e3          	bne	s1,s0,ffffffffc0200f5c <slub_check+0x20c>
    }
    // 替换%zu为%lu，变量转换为unsigned long
    cprintf("After alloc 10000×124B: free pages = %lu\n", (unsigned long)nr_free);
ffffffffc0200f70:	00005597          	auipc	a1,0x5
ffffffffc0200f74:	1185e583          	lwu	a1,280(a1) # ffffffffc0206088 <area+0x10>
ffffffffc0200f78:	00001517          	auipc	a0,0x1
ffffffffc0200f7c:	e2050513          	addi	a0,a0,-480 # ffffffffc0201d98 <etext+0x6fe>
ffffffffc0200f80:	9c8ff0ef          	jal	ffffffffc0200148 <cprintf>
    
    for (int i = 0; i < 30000; i++) {
        slub_free_obj(bulk_objs[i]);
ffffffffc0200f84:	000a3503          	ld	a0,0(s4)
    if (!obj) return;
ffffffffc0200f88:	c119                	beqz	a0,ffffffffc0200f8e <slub_check+0x23e>
ffffffffc0200f8a:	b57ff0ef          	jal	ffffffffc0200ae0 <slub_free_obj.part.0>
    for (int i = 0; i < 30000; i++) {
ffffffffc0200f8e:	0a21                	addi	s4,s4,8
ffffffffc0200f90:	fe8a1ae3          	bne	s4,s0,ffffffffc0200f84 <slub_check+0x234>
    }
    assert(nr_free == base_free_pages);
ffffffffc0200f94:	00005797          	auipc	a5,0x5
ffffffffc0200f98:	0f47a783          	lw	a5,244(a5) # ffffffffc0206088 <area+0x10>
ffffffffc0200f9c:	14f91b63          	bne	s2,a5,ffffffffc02010f2 <slub_check+0x3a2>
    // 替换%zu为%lu，变量转换为unsigned long
    cprintf("Bulk objects alloc/free test passed: free pages restored to %lu\n", (unsigned long)nr_free);
ffffffffc0200fa0:	85ce                	mv	a1,s3
ffffffffc0200fa2:	00001517          	auipc	a0,0x1
ffffffffc0200fa6:	e4650513          	addi	a0,a0,-442 # ffffffffc0201de8 <etext+0x74e>
ffffffffc0200faa:	99eff0ef          	jal	ffffffffc0200148 <cprintf>
    
    void *o1 = slub_alloc_obj(32), *o2 = slub_alloc_obj(64), *o3 = slub_alloc_obj(128);
ffffffffc0200fae:	02000513          	li	a0,32
ffffffffc0200fb2:	c4dff0ef          	jal	ffffffffc0200bfe <slub_alloc_obj>
ffffffffc0200fb6:	8c2a                	mv	s8,a0
ffffffffc0200fb8:	04000513          	li	a0,64
ffffffffc0200fbc:	c43ff0ef          	jal	ffffffffc0200bfe <slub_alloc_obj>
ffffffffc0200fc0:	8caa                	mv	s9,a0
ffffffffc0200fc2:	08000513          	li	a0,128
ffffffffc0200fc6:	c39ff0ef          	jal	ffffffffc0200bfe <slub_alloc_obj>
ffffffffc0200fca:	8baa                	mv	s7,a0
    void *o4 = slub_alloc_obj(32), *o5 = slub_alloc_obj(128), *o6 = slub_alloc_obj(128);
ffffffffc0200fcc:	02000513          	li	a0,32
ffffffffc0200fd0:	c2fff0ef          	jal	ffffffffc0200bfe <slub_alloc_obj>
ffffffffc0200fd4:	8b2a                	mv	s6,a0
ffffffffc0200fd6:	08000513          	li	a0,128
ffffffffc0200fda:	c25ff0ef          	jal	ffffffffc0200bfe <slub_alloc_obj>
ffffffffc0200fde:	8a2a                	mv	s4,a0
ffffffffc0200fe0:	08000513          	li	a0,128
ffffffffc0200fe4:	1880                	addi	s0,sp,112
ffffffffc0200fe6:	c19ff0ef          	jal	ffffffffc0200bfe <slub_alloc_obj>
ffffffffc0200fea:	89aa                	mv	s3,a0
    void *objs2[30];
    for (int i = 0; i < 29; i++) {
ffffffffc0200fec:	0e840a93          	addi	s5,s0,232
    void *o4 = slub_alloc_obj(32), *o5 = slub_alloc_obj(128), *o6 = slub_alloc_obj(128);
ffffffffc0200ff0:	84a2                	mv	s1,s0
        objs2[i] = slub_alloc_obj(128);
ffffffffc0200ff2:	08000513          	li	a0,128
ffffffffc0200ff6:	c09ff0ef          	jal	ffffffffc0200bfe <slub_alloc_obj>
ffffffffc0200ffa:	e088                	sd	a0,0(s1)
    for (int i = 0; i < 29; i++) {
ffffffffc0200ffc:	04a1                	addi	s1,s1,8
ffffffffc0200ffe:	fe9a9ae3          	bne	s5,s1,ffffffffc0200ff2 <slub_check+0x2a2>
    }
    assert(o5 != NULL && o6 != NULL);
ffffffffc0201002:	180a0863          	beqz	s4,ffffffffc0201192 <slub_check+0x442>
ffffffffc0201006:	18098663          	beqz	s3,ffffffffc0201192 <slub_check+0x442>
    
    for (int i = 0; i < 29; i++) slub_free_obj(objs2[i]);
ffffffffc020100a:	6008                	ld	a0,0(s0)
    if (!obj) return;
ffffffffc020100c:	c119                	beqz	a0,ffffffffc0201012 <slub_check+0x2c2>
ffffffffc020100e:	ad3ff0ef          	jal	ffffffffc0200ae0 <slub_free_obj.part.0>
    for (int i = 0; i < 29; i++) slub_free_obj(objs2[i]);
ffffffffc0201012:	0421                	addi	s0,s0,8
ffffffffc0201014:	fe8a9be3          	bne	s5,s0,ffffffffc020100a <slub_check+0x2ba>
    if (!obj) return;
ffffffffc0201018:	000c0563          	beqz	s8,ffffffffc0201022 <slub_check+0x2d2>
ffffffffc020101c:	8562                	mv	a0,s8
ffffffffc020101e:	ac3ff0ef          	jal	ffffffffc0200ae0 <slub_free_obj.part.0>
ffffffffc0201022:	000c8563          	beqz	s9,ffffffffc020102c <slub_check+0x2dc>
ffffffffc0201026:	8566                	mv	a0,s9
ffffffffc0201028:	ab9ff0ef          	jal	ffffffffc0200ae0 <slub_free_obj.part.0>
ffffffffc020102c:	000b8563          	beqz	s7,ffffffffc0201036 <slub_check+0x2e6>
ffffffffc0201030:	855e                	mv	a0,s7
ffffffffc0201032:	aafff0ef          	jal	ffffffffc0200ae0 <slub_free_obj.part.0>
ffffffffc0201036:	000b0563          	beqz	s6,ffffffffc0201040 <slub_check+0x2f0>
ffffffffc020103a:	855a                	mv	a0,s6
ffffffffc020103c:	aa5ff0ef          	jal	ffffffffc0200ae0 <slub_free_obj.part.0>
ffffffffc0201040:	8552                	mv	a0,s4
ffffffffc0201042:	a9fff0ef          	jal	ffffffffc0200ae0 <slub_free_obj.part.0>
ffffffffc0201046:	854e                	mv	a0,s3
ffffffffc0201048:	a99ff0ef          	jal	ffffffffc0200ae0 <slub_free_obj.part.0>
    slub_free_obj(o1); slub_free_obj(o2); slub_free_obj(o3);
    slub_free_obj(o4); slub_free_obj(o5); slub_free_obj(o6);
    assert(nr_free == base_free_pages);
ffffffffc020104c:	00005797          	auipc	a5,0x5
ffffffffc0201050:	03c7a783          	lw	a5,60(a5) # ffffffffc0206088 <area+0x10>
ffffffffc0201054:	17279f63          	bne	a5,s2,ffffffffc02011d2 <slub_check+0x482>
    cprintf("Complex mixed alloc/free test passed\n");
ffffffffc0201058:	00001517          	auipc	a0,0x1
ffffffffc020105c:	df850513          	addi	a0,a0,-520 # ffffffffc0201e50 <etext+0x7b6>
ffffffffc0201060:	8e8ff0ef          	jal	ffffffffc0200148 <cprintf>
    
    cprintf("All SLUB allocator checks passed!\n");
}
ffffffffc0201064:	0003b2b7          	lui	t0,0x3b
ffffffffc0201068:	ae028293          	addi	t0,t0,-1312 # 3aae0 <kern_entry-0xffffffffc01c5520>
ffffffffc020106c:	9116                	add	sp,sp,t0
ffffffffc020106e:	60e6                	ld	ra,88(sp)
ffffffffc0201070:	6446                	ld	s0,80(sp)
ffffffffc0201072:	64a6                	ld	s1,72(sp)
ffffffffc0201074:	6906                	ld	s2,64(sp)
ffffffffc0201076:	79e2                	ld	s3,56(sp)
ffffffffc0201078:	7a42                	ld	s4,48(sp)
ffffffffc020107a:	7aa2                	ld	s5,40(sp)
ffffffffc020107c:	7b02                	ld	s6,32(sp)
ffffffffc020107e:	6be2                	ld	s7,24(sp)
ffffffffc0201080:	6c42                	ld	s8,16(sp)
ffffffffc0201082:	6ca2                	ld	s9,8(sp)
    cprintf("All SLUB allocator checks passed!\n");
ffffffffc0201084:	00001517          	auipc	a0,0x1
ffffffffc0201088:	df450513          	addi	a0,a0,-524 # ffffffffc0201e78 <etext+0x7de>
}
ffffffffc020108c:	6125                	addi	sp,sp,96
    cprintf("All SLUB allocator checks passed!\n");
ffffffffc020108e:	8baff06f          	j	ffffffffc0200148 <cprintf>
            assert(((unsigned char *)objs[i])[j] == (unsigned char)i);
ffffffffc0201092:	00001697          	auipc	a3,0x1
ffffffffc0201096:	bbe68693          	addi	a3,a3,-1090 # ffffffffc0201c50 <etext+0x5b6>
ffffffffc020109a:	00001617          	auipc	a2,0x1
ffffffffc020109e:	99e60613          	addi	a2,a2,-1634 # ffffffffc0201a38 <etext+0x39e>
ffffffffc02010a2:	11000593          	li	a1,272
ffffffffc02010a6:	00001517          	auipc	a0,0x1
ffffffffc02010aa:	9aa50513          	addi	a0,a0,-1622 # ffffffffc0201a50 <etext+0x3b6>
ffffffffc02010ae:	91aff0ef          	jal	ffffffffc02001c8 <__panic>
            assert(((unsigned char *)objs[i])[j] == 0x00);
ffffffffc02010b2:	00001697          	auipc	a3,0x1
ffffffffc02010b6:	bd668693          	addi	a3,a3,-1066 # ffffffffc0201c88 <etext+0x5ee>
ffffffffc02010ba:	00001617          	auipc	a2,0x1
ffffffffc02010be:	97e60613          	addi	a2,a2,-1666 # ffffffffc0201a38 <etext+0x39e>
ffffffffc02010c2:	11600593          	li	a1,278
ffffffffc02010c6:	00001517          	auipc	a0,0x1
ffffffffc02010ca:	98a50513          	addi	a0,a0,-1654 # ffffffffc0201a50 <etext+0x3b6>
ffffffffc02010ce:	8faff0ef          	jal	ffffffffc02001c8 <__panic>
        assert(slub_caches[i].obj_num == expect_obj_num[i]);
ffffffffc02010d2:	00001697          	auipc	a3,0x1
ffffffffc02010d6:	a0e68693          	addi	a3,a3,-1522 # ffffffffc0201ae0 <etext+0x446>
ffffffffc02010da:	00001617          	auipc	a2,0x1
ffffffffc02010de:	95e60613          	addi	a2,a2,-1698 # ffffffffc0201a38 <etext+0x39e>
ffffffffc02010e2:	0ed00593          	li	a1,237
ffffffffc02010e6:	00001517          	auipc	a0,0x1
ffffffffc02010ea:	96a50513          	addi	a0,a0,-1686 # ffffffffc0201a50 <etext+0x3b6>
ffffffffc02010ee:	8daff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(nr_free == base_free_pages);
ffffffffc02010f2:	00001697          	auipc	a3,0x1
ffffffffc02010f6:	cd668693          	addi	a3,a3,-810 # ffffffffc0201dc8 <etext+0x72e>
ffffffffc02010fa:	00001617          	auipc	a2,0x1
ffffffffc02010fe:	93e60613          	addi	a2,a2,-1730 # ffffffffc0201a38 <etext+0x39e>
ffffffffc0201102:	13800593          	li	a1,312
ffffffffc0201106:	00001517          	auipc	a0,0x1
ffffffffc020110a:	94a50513          	addi	a0,a0,-1718 # ffffffffc0201a50 <etext+0x3b6>
ffffffffc020110e:	8baff0ef          	jal	ffffffffc02001c8 <__panic>
        assert(bulk_objs[20000 + i] != NULL);
ffffffffc0201112:	00001697          	auipc	a3,0x1
ffffffffc0201116:	c6668693          	addi	a3,a3,-922 # ffffffffc0201d78 <etext+0x6de>
ffffffffc020111a:	00001617          	auipc	a2,0x1
ffffffffc020111e:	91e60613          	addi	a2,a2,-1762 # ffffffffc0201a38 <etext+0x39e>
ffffffffc0201122:	13000593          	li	a1,304
ffffffffc0201126:	00001517          	auipc	a0,0x1
ffffffffc020112a:	92a50513          	addi	a0,a0,-1750 # ffffffffc0201a50 <etext+0x3b6>
ffffffffc020112e:	89aff0ef          	jal	ffffffffc02001c8 <__panic>
        assert(bulk_objs[10000 + i] != NULL);
ffffffffc0201132:	00001697          	auipc	a3,0x1
ffffffffc0201136:	bf668693          	addi	a3,a3,-1034 # ffffffffc0201d28 <etext+0x68e>
ffffffffc020113a:	00001617          	auipc	a2,0x1
ffffffffc020113e:	8fe60613          	addi	a2,a2,-1794 # ffffffffc0201a38 <etext+0x39e>
ffffffffc0201142:	12800593          	li	a1,296
ffffffffc0201146:	00001517          	auipc	a0,0x1
ffffffffc020114a:	90a50513          	addi	a0,a0,-1782 # ffffffffc0201a50 <etext+0x3b6>
ffffffffc020114e:	87aff0ef          	jal	ffffffffc02001c8 <__panic>
        assert(((unsigned char *)obj1)[i] == 0x66);
ffffffffc0201152:	00001697          	auipc	a3,0x1
ffffffffc0201156:	a9668693          	addi	a3,a3,-1386 # ffffffffc0201be8 <etext+0x54e>
ffffffffc020115a:	00001617          	auipc	a2,0x1
ffffffffc020115e:	8de60613          	addi	a2,a2,-1826 # ffffffffc0201a38 <etext+0x39e>
ffffffffc0201162:	10500593          	li	a1,261
ffffffffc0201166:	00001517          	auipc	a0,0x1
ffffffffc020116a:	8ea50513          	addi	a0,a0,-1814 # ffffffffc0201a50 <etext+0x3b6>
ffffffffc020116e:	85aff0ef          	jal	ffffffffc02001c8 <__panic>
        assert(bulk_objs[i] != NULL);
ffffffffc0201172:	00001697          	auipc	a3,0x1
ffffffffc0201176:	b6e68693          	addi	a3,a3,-1170 # ffffffffc0201ce0 <etext+0x646>
ffffffffc020117a:	00001617          	auipc	a2,0x1
ffffffffc020117e:	8be60613          	addi	a2,a2,-1858 # ffffffffc0201a38 <etext+0x39e>
ffffffffc0201182:	12000593          	li	a1,288
ffffffffc0201186:	00001517          	auipc	a0,0x1
ffffffffc020118a:	8ca50513          	addi	a0,a0,-1846 # ffffffffc0201a50 <etext+0x3b6>
ffffffffc020118e:	83aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(o5 != NULL && o6 != NULL);
ffffffffc0201192:	00001697          	auipc	a3,0x1
ffffffffc0201196:	c9e68693          	addi	a3,a3,-866 # ffffffffc0201e30 <etext+0x796>
ffffffffc020119a:	00001617          	auipc	a2,0x1
ffffffffc020119e:	89e60613          	addi	a2,a2,-1890 # ffffffffc0201a38 <etext+0x39e>
ffffffffc02011a2:	14200593          	li	a1,322
ffffffffc02011a6:	00001517          	auipc	a0,0x1
ffffffffc02011aa:	8aa50513          	addi	a0,a0,-1878 # ffffffffc0201a50 <etext+0x3b6>
ffffffffc02011ae:	81aff0ef          	jal	ffffffffc02001c8 <__panic>
        assert(objs[i] != NULL);
ffffffffc02011b2:	00001697          	auipc	a3,0x1
ffffffffc02011b6:	a8e68693          	addi	a3,a3,-1394 # ffffffffc0201c40 <etext+0x5a6>
ffffffffc02011ba:	00001617          	auipc	a2,0x1
ffffffffc02011be:	87e60613          	addi	a2,a2,-1922 # ffffffffc0201a38 <etext+0x39e>
ffffffffc02011c2:	10d00593          	li	a1,269
ffffffffc02011c6:	00001517          	auipc	a0,0x1
ffffffffc02011ca:	88a50513          	addi	a0,a0,-1910 # ffffffffc0201a50 <etext+0x3b6>
ffffffffc02011ce:	ffbfe0ef          	jal	ffffffffc02001c8 <__panic>
    assert(nr_free == base_free_pages);
ffffffffc02011d2:	00001697          	auipc	a3,0x1
ffffffffc02011d6:	bf668693          	addi	a3,a3,-1034 # ffffffffc0201dc8 <etext+0x72e>
ffffffffc02011da:	00001617          	auipc	a2,0x1
ffffffffc02011de:	85e60613          	addi	a2,a2,-1954 # ffffffffc0201a38 <etext+0x39e>
ffffffffc02011e2:	14700593          	li	a1,327
ffffffffc02011e6:	00001517          	auipc	a0,0x1
ffffffffc02011ea:	86a50513          	addi	a0,a0,-1942 # ffffffffc0201a50 <etext+0x3b6>
ffffffffc02011ee:	fdbfe0ef          	jal	ffffffffc02001c8 <__panic>
    assert(obj1 != NULL);  // 若 obj1 是 NULL，这里会 panic
ffffffffc02011f2:	00001697          	auipc	a3,0x1
ffffffffc02011f6:	9ce68693          	addi	a3,a3,-1586 # ffffffffc0201bc0 <etext+0x526>
ffffffffc02011fa:	00001617          	auipc	a2,0x1
ffffffffc02011fe:	83e60613          	addi	a2,a2,-1986 # ffffffffc0201a38 <etext+0x39e>
ffffffffc0201202:	0ff00593          	li	a1,255
ffffffffc0201206:	00001517          	auipc	a0,0x1
ffffffffc020120a:	84a50513          	addi	a0,a0,-1974 # ffffffffc0201a50 <etext+0x3b6>
ffffffffc020120e:	fbbfe0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0201212 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201212:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0201214:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201218:	f022                	sd	s0,32(sp)
ffffffffc020121a:	ec26                	sd	s1,24(sp)
ffffffffc020121c:	e84a                	sd	s2,16(sp)
ffffffffc020121e:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201220:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201224:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201226:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc020122a:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020122e:	84aa                	mv	s1,a0
ffffffffc0201230:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc0201232:	03067d63          	bgeu	a2,a6,ffffffffc020126c <printnum+0x5a>
ffffffffc0201236:	e44e                	sd	s3,8(sp)
ffffffffc0201238:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020123a:	4785                	li	a5,1
ffffffffc020123c:	00e7d763          	bge	a5,a4,ffffffffc020124a <printnum+0x38>
            putch(padc, putdat);
ffffffffc0201240:	85ca                	mv	a1,s2
ffffffffc0201242:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc0201244:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201246:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0201248:	fc65                	bnez	s0,ffffffffc0201240 <printnum+0x2e>
ffffffffc020124a:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020124c:	00001797          	auipc	a5,0x1
ffffffffc0201250:	c6c78793          	addi	a5,a5,-916 # ffffffffc0201eb8 <etext+0x81e>
ffffffffc0201254:	97d2                	add	a5,a5,s4
}
ffffffffc0201256:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201258:	0007c503          	lbu	a0,0(a5)
}
ffffffffc020125c:	70a2                	ld	ra,40(sp)
ffffffffc020125e:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201260:	85ca                	mv	a1,s2
ffffffffc0201262:	87a6                	mv	a5,s1
}
ffffffffc0201264:	6942                	ld	s2,16(sp)
ffffffffc0201266:	64e2                	ld	s1,24(sp)
ffffffffc0201268:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020126a:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc020126c:	03065633          	divu	a2,a2,a6
ffffffffc0201270:	8722                	mv	a4,s0
ffffffffc0201272:	fa1ff0ef          	jal	ffffffffc0201212 <printnum>
ffffffffc0201276:	bfd9                	j	ffffffffc020124c <printnum+0x3a>

ffffffffc0201278 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201278:	7119                	addi	sp,sp,-128
ffffffffc020127a:	f4a6                	sd	s1,104(sp)
ffffffffc020127c:	f0ca                	sd	s2,96(sp)
ffffffffc020127e:	ecce                	sd	s3,88(sp)
ffffffffc0201280:	e8d2                	sd	s4,80(sp)
ffffffffc0201282:	e4d6                	sd	s5,72(sp)
ffffffffc0201284:	e0da                	sd	s6,64(sp)
ffffffffc0201286:	f862                	sd	s8,48(sp)
ffffffffc0201288:	fc86                	sd	ra,120(sp)
ffffffffc020128a:	f8a2                	sd	s0,112(sp)
ffffffffc020128c:	fc5e                	sd	s7,56(sp)
ffffffffc020128e:	f466                	sd	s9,40(sp)
ffffffffc0201290:	f06a                	sd	s10,32(sp)
ffffffffc0201292:	ec6e                	sd	s11,24(sp)
ffffffffc0201294:	84aa                	mv	s1,a0
ffffffffc0201296:	8c32                	mv	s8,a2
ffffffffc0201298:	8a36                	mv	s4,a3
ffffffffc020129a:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020129c:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02012a0:	05500b13          	li	s6,85
ffffffffc02012a4:	00001a97          	auipc	s5,0x1
ffffffffc02012a8:	d24a8a93          	addi	s5,s5,-732 # ffffffffc0201fc8 <slub_pmm_manager+0x38>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02012ac:	000c4503          	lbu	a0,0(s8)
ffffffffc02012b0:	001c0413          	addi	s0,s8,1
ffffffffc02012b4:	01350a63          	beq	a0,s3,ffffffffc02012c8 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc02012b8:	cd0d                	beqz	a0,ffffffffc02012f2 <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc02012ba:	85ca                	mv	a1,s2
ffffffffc02012bc:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02012be:	00044503          	lbu	a0,0(s0)
ffffffffc02012c2:	0405                	addi	s0,s0,1
ffffffffc02012c4:	ff351ae3          	bne	a0,s3,ffffffffc02012b8 <vprintfmt+0x40>
        width = precision = -1;
ffffffffc02012c8:	5cfd                	li	s9,-1
ffffffffc02012ca:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc02012cc:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc02012d0:	4b81                	li	s7,0
ffffffffc02012d2:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02012d4:	00044683          	lbu	a3,0(s0)
ffffffffc02012d8:	00140c13          	addi	s8,s0,1
ffffffffc02012dc:	fdd6859b          	addiw	a1,a3,-35
ffffffffc02012e0:	0ff5f593          	zext.b	a1,a1
ffffffffc02012e4:	02bb6663          	bltu	s6,a1,ffffffffc0201310 <vprintfmt+0x98>
ffffffffc02012e8:	058a                	slli	a1,a1,0x2
ffffffffc02012ea:	95d6                	add	a1,a1,s5
ffffffffc02012ec:	4198                	lw	a4,0(a1)
ffffffffc02012ee:	9756                	add	a4,a4,s5
ffffffffc02012f0:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02012f2:	70e6                	ld	ra,120(sp)
ffffffffc02012f4:	7446                	ld	s0,112(sp)
ffffffffc02012f6:	74a6                	ld	s1,104(sp)
ffffffffc02012f8:	7906                	ld	s2,96(sp)
ffffffffc02012fa:	69e6                	ld	s3,88(sp)
ffffffffc02012fc:	6a46                	ld	s4,80(sp)
ffffffffc02012fe:	6aa6                	ld	s5,72(sp)
ffffffffc0201300:	6b06                	ld	s6,64(sp)
ffffffffc0201302:	7be2                	ld	s7,56(sp)
ffffffffc0201304:	7c42                	ld	s8,48(sp)
ffffffffc0201306:	7ca2                	ld	s9,40(sp)
ffffffffc0201308:	7d02                	ld	s10,32(sp)
ffffffffc020130a:	6de2                	ld	s11,24(sp)
ffffffffc020130c:	6109                	addi	sp,sp,128
ffffffffc020130e:	8082                	ret
            putch('%', putdat);
ffffffffc0201310:	85ca                	mv	a1,s2
ffffffffc0201312:	02500513          	li	a0,37
ffffffffc0201316:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201318:	fff44783          	lbu	a5,-1(s0)
ffffffffc020131c:	02500713          	li	a4,37
ffffffffc0201320:	8c22                	mv	s8,s0
ffffffffc0201322:	f8e785e3          	beq	a5,a4,ffffffffc02012ac <vprintfmt+0x34>
ffffffffc0201326:	ffec4783          	lbu	a5,-2(s8)
ffffffffc020132a:	1c7d                	addi	s8,s8,-1
ffffffffc020132c:	fee79de3          	bne	a5,a4,ffffffffc0201326 <vprintfmt+0xae>
ffffffffc0201330:	bfb5                	j	ffffffffc02012ac <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0201332:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0201336:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc0201338:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc020133c:	fd06071b          	addiw	a4,a2,-48
ffffffffc0201340:	24e56a63          	bltu	a0,a4,ffffffffc0201594 <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc0201344:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201346:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc0201348:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc020134c:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201350:	0197073b          	addw	a4,a4,s9
ffffffffc0201354:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201358:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc020135a:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc020135e:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201360:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0201364:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc0201368:	feb570e3          	bgeu	a0,a1,ffffffffc0201348 <vprintfmt+0xd0>
            if (width < 0)
ffffffffc020136c:	f60d54e3          	bgez	s10,ffffffffc02012d4 <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0201370:	8d66                	mv	s10,s9
ffffffffc0201372:	5cfd                	li	s9,-1
ffffffffc0201374:	b785                	j	ffffffffc02012d4 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201376:	8db6                	mv	s11,a3
ffffffffc0201378:	8462                	mv	s0,s8
ffffffffc020137a:	bfa9                	j	ffffffffc02012d4 <vprintfmt+0x5c>
ffffffffc020137c:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc020137e:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0201380:	bf91                	j	ffffffffc02012d4 <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0201382:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201384:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201388:	00f74463          	blt	a4,a5,ffffffffc0201390 <vprintfmt+0x118>
    else if (lflag) {
ffffffffc020138c:	1a078763          	beqz	a5,ffffffffc020153a <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0201390:	000a3603          	ld	a2,0(s4)
ffffffffc0201394:	46c1                	li	a3,16
ffffffffc0201396:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201398:	000d879b          	sext.w	a5,s11
ffffffffc020139c:	876a                	mv	a4,s10
ffffffffc020139e:	85ca                	mv	a1,s2
ffffffffc02013a0:	8526                	mv	a0,s1
ffffffffc02013a2:	e71ff0ef          	jal	ffffffffc0201212 <printnum>
            break;
ffffffffc02013a6:	b719                	j	ffffffffc02012ac <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc02013a8:	000a2503          	lw	a0,0(s4)
ffffffffc02013ac:	85ca                	mv	a1,s2
ffffffffc02013ae:	0a21                	addi	s4,s4,8
ffffffffc02013b0:	9482                	jalr	s1
            break;
ffffffffc02013b2:	bded                	j	ffffffffc02012ac <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc02013b4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02013b6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02013ba:	00f74463          	blt	a4,a5,ffffffffc02013c2 <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc02013be:	16078963          	beqz	a5,ffffffffc0201530 <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc02013c2:	000a3603          	ld	a2,0(s4)
ffffffffc02013c6:	46a9                	li	a3,10
ffffffffc02013c8:	8a2e                	mv	s4,a1
ffffffffc02013ca:	b7f9                	j	ffffffffc0201398 <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc02013cc:	85ca                	mv	a1,s2
ffffffffc02013ce:	03000513          	li	a0,48
ffffffffc02013d2:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc02013d4:	85ca                	mv	a1,s2
ffffffffc02013d6:	07800513          	li	a0,120
ffffffffc02013da:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02013dc:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc02013e0:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02013e2:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02013e4:	bf55                	j	ffffffffc0201398 <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc02013e6:	85ca                	mv	a1,s2
ffffffffc02013e8:	02500513          	li	a0,37
ffffffffc02013ec:	9482                	jalr	s1
            break;
ffffffffc02013ee:	bd7d                	j	ffffffffc02012ac <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc02013f0:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02013f4:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc02013f6:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc02013f8:	bf95                	j	ffffffffc020136c <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc02013fa:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02013fc:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201400:	00f74463          	blt	a4,a5,ffffffffc0201408 <vprintfmt+0x190>
    else if (lflag) {
ffffffffc0201404:	12078163          	beqz	a5,ffffffffc0201526 <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc0201408:	000a3603          	ld	a2,0(s4)
ffffffffc020140c:	46a1                	li	a3,8
ffffffffc020140e:	8a2e                	mv	s4,a1
ffffffffc0201410:	b761                	j	ffffffffc0201398 <vprintfmt+0x120>
            if (width < 0)
ffffffffc0201412:	876a                	mv	a4,s10
ffffffffc0201414:	000d5363          	bgez	s10,ffffffffc020141a <vprintfmt+0x1a2>
ffffffffc0201418:	4701                	li	a4,0
ffffffffc020141a:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020141e:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0201420:	bd55                	j	ffffffffc02012d4 <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc0201422:	000d841b          	sext.w	s0,s11
ffffffffc0201426:	fd340793          	addi	a5,s0,-45
ffffffffc020142a:	00f037b3          	snez	a5,a5
ffffffffc020142e:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201432:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc0201436:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201438:	008a0793          	addi	a5,s4,8
ffffffffc020143c:	e43e                	sd	a5,8(sp)
ffffffffc020143e:	100d8c63          	beqz	s11,ffffffffc0201556 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0201442:	12071363          	bnez	a4,ffffffffc0201568 <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201446:	000dc783          	lbu	a5,0(s11)
ffffffffc020144a:	0007851b          	sext.w	a0,a5
ffffffffc020144e:	c78d                	beqz	a5,ffffffffc0201478 <vprintfmt+0x200>
ffffffffc0201450:	0d85                	addi	s11,s11,1
ffffffffc0201452:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201454:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201458:	000cc563          	bltz	s9,ffffffffc0201462 <vprintfmt+0x1ea>
ffffffffc020145c:	3cfd                	addiw	s9,s9,-1
ffffffffc020145e:	008c8d63          	beq	s9,s0,ffffffffc0201478 <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201462:	020b9663          	bnez	s7,ffffffffc020148e <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc0201466:	85ca                	mv	a1,s2
ffffffffc0201468:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020146a:	000dc783          	lbu	a5,0(s11)
ffffffffc020146e:	0d85                	addi	s11,s11,1
ffffffffc0201470:	3d7d                	addiw	s10,s10,-1
ffffffffc0201472:	0007851b          	sext.w	a0,a5
ffffffffc0201476:	f3ed                	bnez	a5,ffffffffc0201458 <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc0201478:	01a05963          	blez	s10,ffffffffc020148a <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc020147c:	85ca                	mv	a1,s2
ffffffffc020147e:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0201482:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc0201484:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc0201486:	fe0d1be3          	bnez	s10,ffffffffc020147c <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020148a:	6a22                	ld	s4,8(sp)
ffffffffc020148c:	b505                	j	ffffffffc02012ac <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020148e:	3781                	addiw	a5,a5,-32
ffffffffc0201490:	fcfa7be3          	bgeu	s4,a5,ffffffffc0201466 <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc0201494:	03f00513          	li	a0,63
ffffffffc0201498:	85ca                	mv	a1,s2
ffffffffc020149a:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020149c:	000dc783          	lbu	a5,0(s11)
ffffffffc02014a0:	0d85                	addi	s11,s11,1
ffffffffc02014a2:	3d7d                	addiw	s10,s10,-1
ffffffffc02014a4:	0007851b          	sext.w	a0,a5
ffffffffc02014a8:	dbe1                	beqz	a5,ffffffffc0201478 <vprintfmt+0x200>
ffffffffc02014aa:	fa0cd9e3          	bgez	s9,ffffffffc020145c <vprintfmt+0x1e4>
ffffffffc02014ae:	b7c5                	j	ffffffffc020148e <vprintfmt+0x216>
            if (err < 0) {
ffffffffc02014b0:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02014b4:	4619                	li	a2,6
            err = va_arg(ap, int);
ffffffffc02014b6:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc02014b8:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc02014bc:	8fb9                	xor	a5,a5,a4
ffffffffc02014be:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02014c2:	02d64563          	blt	a2,a3,ffffffffc02014ec <vprintfmt+0x274>
ffffffffc02014c6:	00001797          	auipc	a5,0x1
ffffffffc02014ca:	c5a78793          	addi	a5,a5,-934 # ffffffffc0202120 <error_string>
ffffffffc02014ce:	00369713          	slli	a4,a3,0x3
ffffffffc02014d2:	97ba                	add	a5,a5,a4
ffffffffc02014d4:	639c                	ld	a5,0(a5)
ffffffffc02014d6:	cb99                	beqz	a5,ffffffffc02014ec <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc02014d8:	86be                	mv	a3,a5
ffffffffc02014da:	00001617          	auipc	a2,0x1
ffffffffc02014de:	a0e60613          	addi	a2,a2,-1522 # ffffffffc0201ee8 <etext+0x84e>
ffffffffc02014e2:	85ca                	mv	a1,s2
ffffffffc02014e4:	8526                	mv	a0,s1
ffffffffc02014e6:	0d8000ef          	jal	ffffffffc02015be <printfmt>
ffffffffc02014ea:	b3c9                	j	ffffffffc02012ac <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02014ec:	00001617          	auipc	a2,0x1
ffffffffc02014f0:	9ec60613          	addi	a2,a2,-1556 # ffffffffc0201ed8 <etext+0x83e>
ffffffffc02014f4:	85ca                	mv	a1,s2
ffffffffc02014f6:	8526                	mv	a0,s1
ffffffffc02014f8:	0c6000ef          	jal	ffffffffc02015be <printfmt>
ffffffffc02014fc:	bb45                	j	ffffffffc02012ac <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc02014fe:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201500:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc0201504:	00f74363          	blt	a4,a5,ffffffffc020150a <vprintfmt+0x292>
    else if (lflag) {
ffffffffc0201508:	cf81                	beqz	a5,ffffffffc0201520 <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc020150a:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc020150e:	02044b63          	bltz	s0,ffffffffc0201544 <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc0201512:	8622                	mv	a2,s0
ffffffffc0201514:	8a5e                	mv	s4,s7
ffffffffc0201516:	46a9                	li	a3,10
ffffffffc0201518:	b541                	j	ffffffffc0201398 <vprintfmt+0x120>
            lflag ++;
ffffffffc020151a:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020151c:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc020151e:	bb5d                	j	ffffffffc02012d4 <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc0201520:	000a2403          	lw	s0,0(s4)
ffffffffc0201524:	b7ed                	j	ffffffffc020150e <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc0201526:	000a6603          	lwu	a2,0(s4)
ffffffffc020152a:	46a1                	li	a3,8
ffffffffc020152c:	8a2e                	mv	s4,a1
ffffffffc020152e:	b5ad                	j	ffffffffc0201398 <vprintfmt+0x120>
ffffffffc0201530:	000a6603          	lwu	a2,0(s4)
ffffffffc0201534:	46a9                	li	a3,10
ffffffffc0201536:	8a2e                	mv	s4,a1
ffffffffc0201538:	b585                	j	ffffffffc0201398 <vprintfmt+0x120>
ffffffffc020153a:	000a6603          	lwu	a2,0(s4)
ffffffffc020153e:	46c1                	li	a3,16
ffffffffc0201540:	8a2e                	mv	s4,a1
ffffffffc0201542:	bd99                	j	ffffffffc0201398 <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc0201544:	85ca                	mv	a1,s2
ffffffffc0201546:	02d00513          	li	a0,45
ffffffffc020154a:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc020154c:	40800633          	neg	a2,s0
ffffffffc0201550:	8a5e                	mv	s4,s7
ffffffffc0201552:	46a9                	li	a3,10
ffffffffc0201554:	b591                	j	ffffffffc0201398 <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc0201556:	e329                	bnez	a4,ffffffffc0201598 <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201558:	02800793          	li	a5,40
ffffffffc020155c:	853e                	mv	a0,a5
ffffffffc020155e:	00001d97          	auipc	s11,0x1
ffffffffc0201562:	973d8d93          	addi	s11,s11,-1677 # ffffffffc0201ed1 <etext+0x837>
ffffffffc0201566:	b5f5                	j	ffffffffc0201452 <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201568:	85e6                	mv	a1,s9
ffffffffc020156a:	856e                	mv	a0,s11
ffffffffc020156c:	0a4000ef          	jal	ffffffffc0201610 <strnlen>
ffffffffc0201570:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0201574:	01a05863          	blez	s10,ffffffffc0201584 <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc0201578:	85ca                	mv	a1,s2
ffffffffc020157a:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020157c:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc020157e:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201580:	fe0d1ce3          	bnez	s10,ffffffffc0201578 <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201584:	000dc783          	lbu	a5,0(s11)
ffffffffc0201588:	0007851b          	sext.w	a0,a5
ffffffffc020158c:	ec0792e3          	bnez	a5,ffffffffc0201450 <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201590:	6a22                	ld	s4,8(sp)
ffffffffc0201592:	bb29                	j	ffffffffc02012ac <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201594:	8462                	mv	s0,s8
ffffffffc0201596:	bbd9                	j	ffffffffc020136c <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201598:	85e6                	mv	a1,s9
ffffffffc020159a:	00001517          	auipc	a0,0x1
ffffffffc020159e:	93650513          	addi	a0,a0,-1738 # ffffffffc0201ed0 <etext+0x836>
ffffffffc02015a2:	06e000ef          	jal	ffffffffc0201610 <strnlen>
ffffffffc02015a6:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02015aa:	02800793          	li	a5,40
                p = "(null)";
ffffffffc02015ae:	00001d97          	auipc	s11,0x1
ffffffffc02015b2:	922d8d93          	addi	s11,s11,-1758 # ffffffffc0201ed0 <etext+0x836>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02015b6:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02015b8:	fda040e3          	bgtz	s10,ffffffffc0201578 <vprintfmt+0x300>
ffffffffc02015bc:	bd51                	j	ffffffffc0201450 <vprintfmt+0x1d8>

ffffffffc02015be <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02015be:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02015c0:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02015c4:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02015c6:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02015c8:	ec06                	sd	ra,24(sp)
ffffffffc02015ca:	f83a                	sd	a4,48(sp)
ffffffffc02015cc:	fc3e                	sd	a5,56(sp)
ffffffffc02015ce:	e0c2                	sd	a6,64(sp)
ffffffffc02015d0:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02015d2:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02015d4:	ca5ff0ef          	jal	ffffffffc0201278 <vprintfmt>
}
ffffffffc02015d8:	60e2                	ld	ra,24(sp)
ffffffffc02015da:	6161                	addi	sp,sp,80
ffffffffc02015dc:	8082                	ret

ffffffffc02015de <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc02015de:	00005717          	auipc	a4,0x5
ffffffffc02015e2:	a3273703          	ld	a4,-1486(a4) # ffffffffc0206010 <SBI_CONSOLE_PUTCHAR>
ffffffffc02015e6:	4781                	li	a5,0
ffffffffc02015e8:	88ba                	mv	a7,a4
ffffffffc02015ea:	852a                	mv	a0,a0
ffffffffc02015ec:	85be                	mv	a1,a5
ffffffffc02015ee:	863e                	mv	a2,a5
ffffffffc02015f0:	00000073          	ecall
ffffffffc02015f4:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc02015f6:	8082                	ret

ffffffffc02015f8 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02015f8:	00054783          	lbu	a5,0(a0)
ffffffffc02015fc:	cb81                	beqz	a5,ffffffffc020160c <strlen+0x14>
    size_t cnt = 0;
ffffffffc02015fe:	4781                	li	a5,0
        cnt ++;
ffffffffc0201600:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc0201602:	00f50733          	add	a4,a0,a5
ffffffffc0201606:	00074703          	lbu	a4,0(a4)
ffffffffc020160a:	fb7d                	bnez	a4,ffffffffc0201600 <strlen+0x8>
    }
    return cnt;
}
ffffffffc020160c:	853e                	mv	a0,a5
ffffffffc020160e:	8082                	ret

ffffffffc0201610 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201610:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201612:	e589                	bnez	a1,ffffffffc020161c <strnlen+0xc>
ffffffffc0201614:	a811                	j	ffffffffc0201628 <strnlen+0x18>
        cnt ++;
ffffffffc0201616:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201618:	00f58863          	beq	a1,a5,ffffffffc0201628 <strnlen+0x18>
ffffffffc020161c:	00f50733          	add	a4,a0,a5
ffffffffc0201620:	00074703          	lbu	a4,0(a4)
ffffffffc0201624:	fb6d                	bnez	a4,ffffffffc0201616 <strnlen+0x6>
ffffffffc0201626:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201628:	852e                	mv	a0,a1
ffffffffc020162a:	8082                	ret

ffffffffc020162c <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020162c:	00054783          	lbu	a5,0(a0)
ffffffffc0201630:	e791                	bnez	a5,ffffffffc020163c <strcmp+0x10>
ffffffffc0201632:	a01d                	j	ffffffffc0201658 <strcmp+0x2c>
ffffffffc0201634:	00054783          	lbu	a5,0(a0)
ffffffffc0201638:	cb99                	beqz	a5,ffffffffc020164e <strcmp+0x22>
ffffffffc020163a:	0585                	addi	a1,a1,1
ffffffffc020163c:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0201640:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201642:	fef709e3          	beq	a4,a5,ffffffffc0201634 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201646:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc020164a:	9d19                	subw	a0,a0,a4
ffffffffc020164c:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020164e:	0015c703          	lbu	a4,1(a1)
ffffffffc0201652:	4501                	li	a0,0
}
ffffffffc0201654:	9d19                	subw	a0,a0,a4
ffffffffc0201656:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201658:	0005c703          	lbu	a4,0(a1)
ffffffffc020165c:	4501                	li	a0,0
ffffffffc020165e:	b7f5                	j	ffffffffc020164a <strcmp+0x1e>

ffffffffc0201660 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201660:	ce01                	beqz	a2,ffffffffc0201678 <strncmp+0x18>
ffffffffc0201662:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201666:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201668:	cb91                	beqz	a5,ffffffffc020167c <strncmp+0x1c>
ffffffffc020166a:	0005c703          	lbu	a4,0(a1)
ffffffffc020166e:	00f71763          	bne	a4,a5,ffffffffc020167c <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc0201672:	0505                	addi	a0,a0,1
ffffffffc0201674:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201676:	f675                	bnez	a2,ffffffffc0201662 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201678:	4501                	li	a0,0
ffffffffc020167a:	8082                	ret
ffffffffc020167c:	00054503          	lbu	a0,0(a0)
ffffffffc0201680:	0005c783          	lbu	a5,0(a1)
ffffffffc0201684:	9d1d                	subw	a0,a0,a5
}
ffffffffc0201686:	8082                	ret

ffffffffc0201688 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201688:	ca01                	beqz	a2,ffffffffc0201698 <memset+0x10>
ffffffffc020168a:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc020168c:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc020168e:	0785                	addi	a5,a5,1
ffffffffc0201690:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201694:	fef61de3          	bne	a2,a5,ffffffffc020168e <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201698:	8082                	ret
