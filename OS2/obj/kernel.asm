
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00005297          	auipc	t0,0x5
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0205000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00005297          	auipc	t0,0x5
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0205008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02042b7          	lui	t0,0xc0204
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
ffffffffc020003c:	c0204137          	lui	sp,0xc0204

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
ffffffffc020004a:	1141                	addi	sp,sp,-16 # ffffffffc0203ff0 <bootstack+0x1ff0>
    extern char etext[], edata[], end[];
    cprintf("Special kernel symbols:\n");
ffffffffc020004c:	00001517          	auipc	a0,0x1
ffffffffc0200050:	22450513          	addi	a0,a0,548 # ffffffffc0201270 <etext+0x4>
void print_kerninfo(void) {
ffffffffc0200054:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200056:	0f2000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", (uintptr_t)kern_init);
ffffffffc020005a:	00000597          	auipc	a1,0x0
ffffffffc020005e:	07c58593          	addi	a1,a1,124 # ffffffffc02000d6 <kern_init>
ffffffffc0200062:	00001517          	auipc	a0,0x1
ffffffffc0200066:	22e50513          	addi	a0,a0,558 # ffffffffc0201290 <etext+0x24>
ffffffffc020006a:	0de000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc020006e:	00001597          	auipc	a1,0x1
ffffffffc0200072:	1fe58593          	addi	a1,a1,510 # ffffffffc020126c <etext>
ffffffffc0200076:	00001517          	auipc	a0,0x1
ffffffffc020007a:	23a50513          	addi	a0,a0,570 # ffffffffc02012b0 <etext+0x44>
ffffffffc020007e:	0ca000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc0200082:	00005597          	auipc	a1,0x5
ffffffffc0200086:	f9658593          	addi	a1,a1,-106 # ffffffffc0205018 <buddy_data>
ffffffffc020008a:	00001517          	auipc	a0,0x1
ffffffffc020008e:	24650513          	addi	a0,a0,582 # ffffffffc02012d0 <etext+0x64>
ffffffffc0200092:	0b6000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc0200096:	00005597          	auipc	a1,0x5
ffffffffc020009a:	0c258593          	addi	a1,a1,194 # ffffffffc0205158 <end>
ffffffffc020009e:	00001517          	auipc	a0,0x1
ffffffffc02000a2:	25250513          	addi	a0,a0,594 # ffffffffc02012f0 <etext+0x84>
ffffffffc02000a6:	0a2000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - (char*)kern_init + 1023) / 1024);
ffffffffc02000aa:	00000717          	auipc	a4,0x0
ffffffffc02000ae:	02c70713          	addi	a4,a4,44 # ffffffffc02000d6 <kern_init>
ffffffffc02000b2:	00005797          	auipc	a5,0x5
ffffffffc02000b6:	4a578793          	addi	a5,a5,1189 # ffffffffc0205557 <end+0x3ff>
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
ffffffffc02000ce:	24650513          	addi	a0,a0,582 # ffffffffc0201310 <etext+0xa4>
}
ffffffffc02000d2:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000d4:	a895                	j	ffffffffc0200148 <cprintf>

ffffffffc02000d6 <kern_init>:

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc02000d6:	00005517          	auipc	a0,0x5
ffffffffc02000da:	f4250513          	addi	a0,a0,-190 # ffffffffc0205018 <buddy_data>
ffffffffc02000de:	00005617          	auipc	a2,0x5
ffffffffc02000e2:	07a60613          	addi	a2,a2,122 # ffffffffc0205158 <end>
int kern_init(void) {
ffffffffc02000e6:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc02000e8:	8e09                	sub	a2,a2,a0
ffffffffc02000ea:	4581                	li	a1,0
int kern_init(void) {
ffffffffc02000ec:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc02000ee:	16c010ef          	jal	ffffffffc020125a <memset>
    dtb_init();
ffffffffc02000f2:	136000ef          	jal	ffffffffc0200228 <dtb_init>
    cons_init();  // init the console
ffffffffc02000f6:	128000ef          	jal	ffffffffc020021e <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc02000fa:	00002517          	auipc	a0,0x2
ffffffffc02000fe:	8d650513          	addi	a0,a0,-1834 # ffffffffc02019d0 <etext+0x764>
ffffffffc0200102:	07a000ef          	jal	ffffffffc020017c <cputs>

    print_kerninfo();
ffffffffc0200106:	f45ff0ef          	jal	ffffffffc020004a <print_kerninfo>

    // grade_backtrace();
    pmm_init();  // init physical memory management
ffffffffc020010a:	307000ef          	jal	ffffffffc0200c10 <pmm_init>

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
ffffffffc020013c:	50f000ef          	jal	ffffffffc0200e4a <vprintfmt>
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
ffffffffc0200170:	4db000ef          	jal	ffffffffc0200e4a <vprintfmt>
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
ffffffffc02001c8:	00005317          	auipc	t1,0x5
ffffffffc02001cc:	f4832303          	lw	t1,-184(t1) # ffffffffc0205110 <is_panic>
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
ffffffffc02001f4:	15050513          	addi	a0,a0,336 # ffffffffc0201340 <etext+0xd4>
    is_panic = 1;
ffffffffc02001f8:	00005697          	auipc	a3,0x5
ffffffffc02001fc:	f0e6ac23          	sw	a4,-232(a3) # ffffffffc0205110 <is_panic>
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
ffffffffc0200212:	15250513          	addi	a0,a0,338 # ffffffffc0201360 <etext+0xf4>
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
ffffffffc0200224:	78d0006f          	j	ffffffffc02011b0 <sbi_console_putchar>

ffffffffc0200228 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200228:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc020022a:	00001517          	auipc	a0,0x1
ffffffffc020022e:	13e50513          	addi	a0,a0,318 # ffffffffc0201368 <etext+0xfc>
void dtb_init(void) {
ffffffffc0200232:	f406                	sd	ra,40(sp)
ffffffffc0200234:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc0200236:	f13ff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc020023a:	00005597          	auipc	a1,0x5
ffffffffc020023e:	dc65b583          	ld	a1,-570(a1) # ffffffffc0205000 <boot_hartid>
ffffffffc0200242:	00001517          	auipc	a0,0x1
ffffffffc0200246:	13650513          	addi	a0,a0,310 # ffffffffc0201378 <etext+0x10c>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020024a:	00005417          	auipc	s0,0x5
ffffffffc020024e:	dbe40413          	addi	s0,s0,-578 # ffffffffc0205008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200252:	ef7ff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200256:	600c                	ld	a1,0(s0)
ffffffffc0200258:	00001517          	auipc	a0,0x1
ffffffffc020025c:	13050513          	addi	a0,a0,304 # ffffffffc0201388 <etext+0x11c>
ffffffffc0200260:	ee9ff0ef          	jal	ffffffffc0200148 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200264:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200266:	00001517          	auipc	a0,0x1
ffffffffc020026a:	13a50513          	addi	a0,a0,314 # ffffffffc02013a0 <etext+0x134>
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
ffffffffc020027e:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfedad95>
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
ffffffffc020035c:	11050513          	addi	a0,a0,272 # ffffffffc0201468 <etext+0x1fc>
ffffffffc0200360:	de9ff0ef          	jal	ffffffffc0200148 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200364:	64e2                	ld	s1,24(sp)
ffffffffc0200366:	6942                	ld	s2,16(sp)
ffffffffc0200368:	00001517          	auipc	a0,0x1
ffffffffc020036c:	13850513          	addi	a0,a0,312 # ffffffffc02014a0 <etext+0x234>
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
ffffffffc0200380:	04450513          	addi	a0,a0,68 # ffffffffc02013c0 <etext+0x154>
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
ffffffffc02003c2:	609000ef          	jal	ffffffffc02011ca <strlen>
ffffffffc02003c6:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003c8:	4619                	li	a2,6
ffffffffc02003ca:	8522                	mv	a0,s0
ffffffffc02003cc:	00001597          	auipc	a1,0x1
ffffffffc02003d0:	01c58593          	addi	a1,a1,28 # ffffffffc02013e8 <etext+0x17c>
ffffffffc02003d4:	65f000ef          	jal	ffffffffc0201232 <strncmp>
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
ffffffffc02003fc:	ff858593          	addi	a1,a1,-8 # ffffffffc02013f0 <etext+0x184>
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
ffffffffc020042e:	5d1000ef          	jal	ffffffffc02011fe <strcmp>
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
ffffffffc0200452:	faa50513          	addi	a0,a0,-86 # ffffffffc02013f8 <etext+0x18c>
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
ffffffffc020051c:	f0050513          	addi	a0,a0,-256 # ffffffffc0201418 <etext+0x1ac>
ffffffffc0200520:	c29ff0ef          	jal	ffffffffc0200148 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200524:	01445613          	srli	a2,s0,0x14
ffffffffc0200528:	85a2                	mv	a1,s0
ffffffffc020052a:	00001517          	auipc	a0,0x1
ffffffffc020052e:	f0650513          	addi	a0,a0,-250 # ffffffffc0201430 <etext+0x1c4>
ffffffffc0200532:	c17ff0ef          	jal	ffffffffc0200148 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200536:	009405b3          	add	a1,s0,s1
ffffffffc020053a:	15fd                	addi	a1,a1,-1
ffffffffc020053c:	00001517          	auipc	a0,0x1
ffffffffc0200540:	f1450513          	addi	a0,a0,-236 # ffffffffc0201450 <etext+0x1e4>
ffffffffc0200544:	c05ff0ef          	jal	ffffffffc0200148 <cprintf>
        memory_base = mem_base;
ffffffffc0200548:	00005797          	auipc	a5,0x5
ffffffffc020054c:	bc97bc23          	sd	s1,-1064(a5) # ffffffffc0205120 <memory_base>
        memory_size = mem_size;
ffffffffc0200550:	00005797          	auipc	a5,0x5
ffffffffc0200554:	bc87b423          	sd	s0,-1080(a5) # ffffffffc0205118 <memory_size>
ffffffffc0200558:	b531                	j	ffffffffc0200364 <dtb_init+0x13c>

ffffffffc020055a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020055a:	00005517          	auipc	a0,0x5
ffffffffc020055e:	bc653503          	ld	a0,-1082(a0) # ffffffffc0205120 <memory_base>
ffffffffc0200562:	8082                	ret

ffffffffc0200564 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc0200564:	00005517          	auipc	a0,0x5
ffffffffc0200568:	bb453503          	ld	a0,-1100(a0) # ffffffffc0205118 <memory_size>
ffffffffc020056c:	8082                	ret

ffffffffc020056e <buddy_init>:
    if (nothing) cprintf("No free buddy blocks.\n");
    cprintf("=========================\n");
}

static void buddy_init(void) {
    for (int i = 0; i <= MAX_BUDDY_ORDER; ++i)
ffffffffc020056e:	00005797          	auipc	a5,0x5
ffffffffc0200572:	aaa78793          	addi	a5,a5,-1366 # ffffffffc0205018 <buddy_data>
ffffffffc0200576:	00005717          	auipc	a4,0x5
ffffffffc020057a:	b9270713          	addi	a4,a4,-1134 # ffffffffc0205108 <buddy_data+0xf0>
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc020057e:	e79c                	sd	a5,8(a5)
ffffffffc0200580:	e39c                	sd	a5,0(a5)
ffffffffc0200582:	07c1                	addi	a5,a5,16
ffffffffc0200584:	fee79de3          	bne	a5,a4,ffffffffc020057e <buddy_init+0x10>
        list_init(&BUDDY_ARRAY[i]);
    BUDDY_MAX_ORDER_VALUE = 0;
ffffffffc0200588:	00005797          	auipc	a5,0x5
ffffffffc020058c:	b807b023          	sd	zero,-1152(a5) # ffffffffc0205108 <buddy_data+0xf0>
    BUDDY_NR_FREE = 0;
}
ffffffffc0200590:	8082                	ret

ffffffffc0200592 <buddy_nr_free_pages>:
    BUDDY_NR_FREE += blocksz;
}

static size_t buddy_nr_free_pages(void) {
    return BUDDY_NR_FREE;
}
ffffffffc0200592:	00005517          	auipc	a0,0x5
ffffffffc0200596:	b7a56503          	lwu	a0,-1158(a0) # ffffffffc020510c <buddy_data+0xf4>
ffffffffc020059a:	8082                	ret

ffffffffc020059c <buddy_free_pages>:
static void buddy_free_pages(struct Page *base, size_t n) {
ffffffffc020059c:	1141                	addi	sp,sp,-16
ffffffffc020059e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02005a0:	12058763          	beqz	a1,ffffffffc02006ce <buddy_free_pages+0x132>
    unsigned int blocksz = 1 << base->property;
ffffffffc02005a4:	4910                	lw	a2,16(a0)
    return !(n == 0 || (n & (n - 1)));
ffffffffc02005a6:	fff58793          	addi	a5,a1,-1
    unsigned int blocksz = 1 << base->property;
ffffffffc02005aa:	4e85                	li	t4,1
    return !(n == 0 || (n & (n - 1)));
ffffffffc02005ac:	8fed                	and	a5,a5,a1
    unsigned int blocksz = 1 << base->property;
ffffffffc02005ae:	00ce9ebb          	sllw	t4,t4,a2
    return !(n == 0 || (n & (n - 1)));
ffffffffc02005b2:	e7e5                	bnez	a5,ffffffffc020069a <buddy_free_pages+0xfe>
    assert(round_up_power2(n) == blocksz);
ffffffffc02005b4:	020e9793          	slli	a5,t4,0x20
ffffffffc02005b8:	9381                	srli	a5,a5,0x20
ffffffffc02005ba:	0eb79a63          	bne	a5,a1,ffffffffc02006ae <buddy_free_pages+0x112>
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
ffffffffc02005be:	02061793          	slli	a5,a2,0x20
    size_t offset = (size_t)block - 0xffffffffc020f318;
ffffffffc02005c2:	3fdf1337          	lui	t1,0x3fdf1
ffffffffc02005c6:	ce830313          	addi	t1,t1,-792 # 3fdf0ce8 <kern_entry-0xffffffff8040f318>
ffffffffc02005ca:	01c7d713          	srli	a4,a5,0x1c
    size_t block_bytes = (1UL << order) * 0x28;
ffffffffc02005ce:	02800f13          	li	t5,40
ffffffffc02005d2:	00005e17          	auipc	t3,0x5
ffffffffc02005d6:	a46e0e13          	addi	t3,t3,-1466 # ffffffffc0205018 <buddy_data>
ffffffffc02005da:	9772                	add	a4,a4,t3
ffffffffc02005dc:	00cf16b3          	sll	a3,t5,a2
    size_t offset = (size_t)block - 0xffffffffc020f318;
ffffffffc02005e0:	006507b3          	add	a5,a0,t1
ffffffffc02005e4:	670c                	ld	a1,8(a4)
    size_t buddy_offset = offset ^ block_bytes;
ffffffffc02005e6:	8fb5                	xor	a5,a5,a3
    return (struct Page *)(buddy_offset + 0xffffffffc020f318);
ffffffffc02005e8:	406787b3          	sub	a5,a5,t1
    while (PageProperty(buddy) && block->property < BUDDY_MAX_ORDER_VALUE) {
ffffffffc02005ec:	6794                	ld	a3,8(a5)
    list_add(&BUDDY_ARRAY[block->property], &block->page_link);
ffffffffc02005ee:	01850813          	addi	a6,a0,24
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02005f2:	0105b023          	sd	a6,0(a1)
ffffffffc02005f6:	01073423          	sd	a6,8(a4)
    while (PageProperty(buddy) && block->property < BUDDY_MAX_ORDER_VALUE) {
ffffffffc02005fa:	8a89                	andi	a3,a3,2
    elm->next = next;
ffffffffc02005fc:	f10c                	sd	a1,32(a0)
    elm->prev = prev;
ffffffffc02005fe:	ed18                	sd	a4,24(a0)
ffffffffc0200600:	c6cd                	beqz	a3,ffffffffc02006aa <buddy_free_pages+0x10e>
ffffffffc0200602:	00005f97          	auipc	t6,0x5
ffffffffc0200606:	b06faf83          	lw	t6,-1274(t6) # ffffffffc0205108 <buddy_data+0xf0>
    struct Page *block = base;
ffffffffc020060a:	86aa                	mv	a3,a0
            block->property = -1;
ffffffffc020060c:	52fd                	li	t0,-1
    while (PageProperty(buddy) && block->property < BUDDY_MAX_ORDER_VALUE) {
ffffffffc020060e:	07f67763          	bgeu	a2,t6,ffffffffc020067c <buddy_free_pages+0xe0>
        if (block > buddy) {
ffffffffc0200612:	00d7fc63          	bgeu	a5,a3,ffffffffc020062a <buddy_free_pages+0x8e>
            SetPageProperty(base);
ffffffffc0200616:	6518                	ld	a4,8(a0)
        block->property += 1;
ffffffffc0200618:	85b6                	mv	a1,a3
            block->property = -1;
ffffffffc020061a:	0056a823          	sw	t0,16(a3)
            SetPageProperty(base);
ffffffffc020061e:	00276713          	ori	a4,a4,2
        block->property += 1;
ffffffffc0200622:	4b90                	lw	a2,16(a5)
            block = buddy;
ffffffffc0200624:	86be                	mv	a3,a5
            SetPageProperty(base);
ffffffffc0200626:	e518                	sd	a4,8(a0)
            buddy = tmp;
ffffffffc0200628:	87ae                	mv	a5,a1
    __list_del(listelm->prev, listelm->next);
ffffffffc020062a:	0186b803          	ld	a6,24(a3)
ffffffffc020062e:	728c                	ld	a1,32(a3)
        block->property += 1;
ffffffffc0200630:	2605                	addiw	a2,a2,1
    __list_add(elm, listelm, listelm->next);
ffffffffc0200632:	02061893          	slli	a7,a2,0x20
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0200636:	00b83423          	sd	a1,8(a6) # ff0008 <kern_entry-0xffffffffbf20fff8>
    next->prev = prev;
ffffffffc020063a:	0105b023          	sd	a6,0(a1)
    __list_del(listelm->prev, listelm->next);
ffffffffc020063e:	6f8c                	ld	a1,24(a5)
ffffffffc0200640:	739c                	ld	a5,32(a5)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200642:	01c8d713          	srli	a4,a7,0x1c
ffffffffc0200646:	9772                	add	a4,a4,t3
    prev->next = next;
ffffffffc0200648:	e59c                	sd	a5,8(a1)
    next->prev = prev;
ffffffffc020064a:	e38c                	sd	a1,0(a5)
    size_t block_bytes = (1UL << order) * 0x28;
ffffffffc020064c:	00cf1833          	sll	a6,t5,a2
    size_t offset = (size_t)block - 0xffffffffc020f318;
ffffffffc0200650:	006687b3          	add	a5,a3,t1
    __list_add(elm, listelm, listelm->next);
ffffffffc0200654:	00873883          	ld	a7,8(a4)
    size_t buddy_offset = offset ^ block_bytes;
ffffffffc0200658:	0107c7b3          	xor	a5,a5,a6
    return (struct Page *)(buddy_offset + 0xffffffffc020f318);
ffffffffc020065c:	406787b3          	sub	a5,a5,t1
    while (PageProperty(buddy) && block->property < BUDDY_MAX_ORDER_VALUE) {
ffffffffc0200660:	0087b803          	ld	a6,8(a5)
        block->property += 1;
ffffffffc0200664:	ca90                	sw	a2,16(a3)
        list_add(&BUDDY_ARRAY[block->property], &block->page_link);
ffffffffc0200666:	01868593          	addi	a1,a3,24
    prev->next = next->prev = elm;
ffffffffc020066a:	00b8b023          	sd	a1,0(a7)
ffffffffc020066e:	e70c                	sd	a1,8(a4)
    elm->prev = prev;
ffffffffc0200670:	ee98                	sd	a4,24(a3)
    elm->next = next;
ffffffffc0200672:	0316b023          	sd	a7,32(a3)
    while (PageProperty(buddy) && block->property < BUDDY_MAX_ORDER_VALUE) {
ffffffffc0200676:	00287713          	andi	a4,a6,2
ffffffffc020067a:	fb51                	bnez	a4,ffffffffc020060e <buddy_free_pages+0x72>
    SetPageProperty(block);
ffffffffc020067c:	6698                	ld	a4,8(a3)
    BUDDY_NR_FREE += blocksz;
ffffffffc020067e:	00005797          	auipc	a5,0x5
ffffffffc0200682:	a8e7a783          	lw	a5,-1394(a5) # ffffffffc020510c <buddy_data+0xf4>
}
ffffffffc0200686:	60a2                	ld	ra,8(sp)
    SetPageProperty(block);
ffffffffc0200688:	00276713          	ori	a4,a4,2
ffffffffc020068c:	e698                	sd	a4,8(a3)
    BUDDY_NR_FREE += blocksz;
ffffffffc020068e:	01d787bb          	addw	a5,a5,t4
ffffffffc0200692:	0efe2a23          	sw	a5,244(t3)
}
ffffffffc0200696:	0141                	addi	sp,sp,16
ffffffffc0200698:	8082                	ret
    while (p < n) p <<= 1;
ffffffffc020069a:	4785                	li	a5,1
ffffffffc020069c:	f0f58ce3          	beq	a1,a5,ffffffffc02005b4 <buddy_free_pages+0x18>
ffffffffc02006a0:	0786                	slli	a5,a5,0x1
ffffffffc02006a2:	feb7efe3          	bltu	a5,a1,ffffffffc02006a0 <buddy_free_pages+0x104>
    return p;
ffffffffc02006a6:	85be                	mv	a1,a5
ffffffffc02006a8:	b731                	j	ffffffffc02005b4 <buddy_free_pages+0x18>
    struct Page *block = base;
ffffffffc02006aa:	86aa                	mv	a3,a0
ffffffffc02006ac:	bfc1                	j	ffffffffc020067c <buddy_free_pages+0xe0>
    assert(round_up_power2(n) == blocksz);
ffffffffc02006ae:	00001697          	auipc	a3,0x1
ffffffffc02006b2:	e4268693          	addi	a3,a3,-446 # ffffffffc02014f0 <etext+0x284>
ffffffffc02006b6:	00001617          	auipc	a2,0x1
ffffffffc02006ba:	e0a60613          	addi	a2,a2,-502 # ffffffffc02014c0 <etext+0x254>
ffffffffc02006be:	09700593          	li	a1,151
ffffffffc02006c2:	00001517          	auipc	a0,0x1
ffffffffc02006c6:	e1650513          	addi	a0,a0,-490 # ffffffffc02014d8 <etext+0x26c>
ffffffffc02006ca:	affff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(n > 0);
ffffffffc02006ce:	00001697          	auipc	a3,0x1
ffffffffc02006d2:	dea68693          	addi	a3,a3,-534 # ffffffffc02014b8 <etext+0x24c>
ffffffffc02006d6:	00001617          	auipc	a2,0x1
ffffffffc02006da:	dea60613          	addi	a2,a2,-534 # ffffffffc02014c0 <etext+0x254>
ffffffffc02006de:	09500593          	li	a1,149
ffffffffc02006e2:	00001517          	auipc	a0,0x1
ffffffffc02006e6:	df650513          	addi	a0,a0,-522 # ffffffffc02014d8 <etext+0x26c>
ffffffffc02006ea:	adfff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc02006ee <buddy_alloc_pages>:
static struct Page *buddy_alloc_pages(size_t reqpg) {
ffffffffc02006ee:	1101                	addi	sp,sp,-32
ffffffffc02006f0:	ec06                	sd	ra,24(sp)
    assert(reqpg > 0);
ffffffffc02006f2:	1a050263          	beqz	a0,ffffffffc0200896 <buddy_alloc_pages+0x1a8>
    if (reqpg > BUDDY_NR_FREE)
ffffffffc02006f6:	00005397          	auipc	t2,0x5
ffffffffc02006fa:	a163a383          	lw	t2,-1514(t2) # ffffffffc020510c <buddy_data+0xf4>
ffffffffc02006fe:	02039793          	slli	a5,t2,0x20
ffffffffc0200702:	9381                	srli	a5,a5,0x20
ffffffffc0200704:	10a7ed63          	bltu	a5,a0,ffffffffc020081e <buddy_alloc_pages+0x130>
    return !(n == 0 || (n & (n - 1)));
ffffffffc0200708:	fff50793          	addi	a5,a0,-1
ffffffffc020070c:	e822                	sd	s0,16(sp)
ffffffffc020070e:	e426                	sd	s1,8(sp)
ffffffffc0200710:	8fe9                	and	a5,a5,a0
ffffffffc0200712:	10079a63          	bnez	a5,ffffffffc0200826 <buddy_alloc_pages+0x138>
    while (n >>= 1) ++idx;
ffffffffc0200716:	00155793          	srli	a5,a0,0x1
ffffffffc020071a:	12078663          	beqz	a5,ffffffffc0200846 <buddy_alloc_pages+0x158>
ffffffffc020071e:	88aa                	mv	a7,a0
ffffffffc0200720:	4701                	li	a4,0
ffffffffc0200722:	8385                	srli	a5,a5,0x1
ffffffffc0200724:	2705                	addiw	a4,a4,1
ffffffffc0200726:	fff5                	bnez	a5,ffffffffc0200722 <buddy_alloc_pages+0x34>
        if (!list_empty(&BUDDY_ARRAY[order])) {
ffffffffc0200728:	02071793          	slli	a5,a4,0x20
ffffffffc020072c:	01c7de13          	srli	t3,a5,0x1c
ffffffffc0200730:	00005317          	auipc	t1,0x5
ffffffffc0200734:	8e830313          	addi	t1,t1,-1816 # ffffffffc0205018 <buddy_data>
ffffffffc0200738:	9e1a                	add	t3,t3,t1
    return list->next == list;
ffffffffc020073a:	02071793          	slli	a5,a4,0x20
ffffffffc020073e:	00170f1b          	addiw	t5,a4,1
ffffffffc0200742:	01c7d713          	srli	a4,a5,0x1c
            for (int i = order + 1; i <= BUDDY_MAX_ORDER_VALUE; ++i) {
ffffffffc0200746:	00005617          	auipc	a2,0x5
ffffffffc020074a:	9c262603          	lw	a2,-1598(a2) # ffffffffc0205108 <buddy_data+0xf0>
ffffffffc020074e:	00e30833          	add	a6,t1,a4
ffffffffc0200752:	020f1f93          	slli	t6,t5,0x20
ffffffffc0200756:	00883783          	ld	a5,8(a6)
ffffffffc020075a:	020fdf93          	srli	t6,t6,0x20
ffffffffc020075e:	004f9e93          	slli	t4,t6,0x4
    assert(order > 0 && order <= BUDDY_MAX_ORDER_VALUE);
ffffffffc0200762:	02061413          	slli	s0,a2,0x20
ffffffffc0200766:	9e9a                	add	t4,t4,t1
ffffffffc0200768:	9001                	srli	s0,s0,0x20
    size_t half_size = 1 << (order - 1);
ffffffffc020076a:	4285                	li	t0,1
        if (!list_empty(&BUDDY_ARRAY[order])) {
ffffffffc020076c:	09c79363          	bne	a5,t3,ffffffffc02007f2 <buddy_alloc_pages+0x104>
            for (int i = order + 1; i <= BUDDY_MAX_ORDER_VALUE; ++i) {
ffffffffc0200770:	0be66563          	bltu	a2,t5,ffffffffc020081a <buddy_alloc_pages+0x12c>
ffffffffc0200774:	87f6                	mv	a5,t4
ffffffffc0200776:	877e                	mv	a4,t6
ffffffffc0200778:	a039                	j	ffffffffc0200786 <buddy_alloc_pages+0x98>
ffffffffc020077a:	0705                	addi	a4,a4,1
ffffffffc020077c:	0007069b          	sext.w	a3,a4
ffffffffc0200780:	07c1                	addi	a5,a5,16
ffffffffc0200782:	08d66c63          	bltu	a2,a3,ffffffffc020081a <buddy_alloc_pages+0x12c>
                if (!list_empty(&BUDDY_ARRAY[i])) {
ffffffffc0200786:	6794                	ld	a3,8(a5)
ffffffffc0200788:	fed789e3          	beq	a5,a3,ffffffffc020077a <buddy_alloc_pages+0x8c>
    assert(order > 0 && order <= BUDDY_MAX_ORDER_VALUE);
ffffffffc020078c:	0ce46563          	bltu	s0,a4,ffffffffc0200856 <buddy_alloc_pages+0x168>
ffffffffc0200790:	00471693          	slli	a3,a4,0x4
ffffffffc0200794:	969a                	add	a3,a3,t1
ffffffffc0200796:	6694                	ld	a3,8(a3)
    assert(!list_empty(&BUDDY_ARRAY[order]));
ffffffffc0200798:	0cd78f63          	beq	a5,a3,ffffffffc0200876 <buddy_alloc_pages+0x188>
    size_t half_size = 1 << (order - 1);
ffffffffc020079c:	fff7051b          	addiw	a0,a4,-1
ffffffffc02007a0:	00a295bb          	sllw	a1,t0,a0
    struct Page *buddy = block + half_size;
ffffffffc02007a4:	00259793          	slli	a5,a1,0x2
ffffffffc02007a8:	97ae                	add	a5,a5,a1
ffffffffc02007aa:	078e                	slli	a5,a5,0x3
    SetPageProperty(block);
ffffffffc02007ac:	ff06b583          	ld	a1,-16(a3)
    struct Page *buddy = block + half_size;
ffffffffc02007b0:	17a1                	addi	a5,a5,-24
    block->property = order - 1;
ffffffffc02007b2:	fea6ac23          	sw	a0,-8(a3)
    struct Page *buddy = block + half_size;
ffffffffc02007b6:	97b6                	add	a5,a5,a3
    buddy->property = order - 1;
ffffffffc02007b8:	cb88                	sw	a0,16(a5)
    SetPageProperty(block);
ffffffffc02007ba:	0025e593          	ori	a1,a1,2
ffffffffc02007be:	feb6b823          	sd	a1,-16(a3)
    SetPageProperty(buddy);
ffffffffc02007c2:	678c                	ld	a1,8(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02007c4:	6688                	ld	a0,8(a3)
ffffffffc02007c6:	6284                	ld	s1,0(a3)
ffffffffc02007c8:	0025e593          	ori	a1,a1,2
ffffffffc02007cc:	e78c                	sd	a1,8(a5)
    __list_add(elm, listelm, listelm->next);
ffffffffc02007ce:	0712                	slli	a4,a4,0x4
    prev->next = next;
ffffffffc02007d0:	e488                	sd	a0,8(s1)
    __list_add(elm, listelm, listelm->next);
ffffffffc02007d2:	1741                	addi	a4,a4,-16
    next->prev = prev;
ffffffffc02007d4:	e104                	sd	s1,0(a0)
    __list_add(elm, listelm, listelm->next);
ffffffffc02007d6:	971a                	add	a4,a4,t1
ffffffffc02007d8:	670c                	ld	a1,8(a4)
    prev->next = next->prev = elm;
ffffffffc02007da:	e714                	sd	a3,8(a4)
    elm->prev = prev;
ffffffffc02007dc:	e298                	sd	a4,0(a3)
    list_add(&block->page_link, &buddy->page_link);
ffffffffc02007de:	01878513          	addi	a0,a5,24
    prev->next = next->prev = elm;
ffffffffc02007e2:	e188                	sd	a0,0(a1)
ffffffffc02007e4:	e688                	sd	a0,8(a3)
    elm->next = next;
ffffffffc02007e6:	f38c                	sd	a1,32(a5)
    elm->prev = prev;
ffffffffc02007e8:	ef94                	sd	a3,24(a5)
    return list->next == list;
ffffffffc02007ea:	00883783          	ld	a5,8(a6)
        if (!list_empty(&BUDDY_ARRAY[order])) {
ffffffffc02007ee:	f9c781e3          	beq	a5,t3,ffffffffc0200770 <buddy_alloc_pages+0x82>
    __list_del(listelm->prev, listelm->next);
ffffffffc02007f2:	6390                	ld	a2,0(a5)
ffffffffc02007f4:	6794                	ld	a3,8(a5)
            ClearPageProperty(alloc);
ffffffffc02007f6:	ff07b703          	ld	a4,-16(a5)
ffffffffc02007fa:	6442                	ld	s0,16(sp)
    prev->next = next;
ffffffffc02007fc:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc02007fe:	e290                	sd	a2,0(a3)
}
ffffffffc0200800:	60e2                	ld	ra,24(sp)
            ClearPageProperty(alloc);
ffffffffc0200802:	9b75                	andi	a4,a4,-3
ffffffffc0200804:	fee7b823          	sd	a4,-16(a5)
    if (alloc) BUDDY_NR_FREE -= required;
ffffffffc0200808:	411383bb          	subw	t2,t2,a7
ffffffffc020080c:	0e732a23          	sw	t2,244(t1)
ffffffffc0200810:	64a2                	ld	s1,8(sp)
            alloc = le2page(le, page_link);
ffffffffc0200812:	fe878513          	addi	a0,a5,-24
}
ffffffffc0200816:	6105                	addi	sp,sp,32
ffffffffc0200818:	8082                	ret
ffffffffc020081a:	6442                	ld	s0,16(sp)
ffffffffc020081c:	64a2                	ld	s1,8(sp)
ffffffffc020081e:	60e2                	ld	ra,24(sp)
        return NULL;
ffffffffc0200820:	4501                	li	a0,0
}
ffffffffc0200822:	6105                	addi	sp,sp,32
ffffffffc0200824:	8082                	ret
    while (p < n) p <<= 1;
ffffffffc0200826:	4885                	li	a7,1
ffffffffc0200828:	01150763          	beq	a0,a7,ffffffffc0200836 <buddy_alloc_pages+0x148>
ffffffffc020082c:	87c6                	mv	a5,a7
ffffffffc020082e:	0886                	slli	a7,a7,0x1
ffffffffc0200830:	fea8eee3          	bltu	a7,a0,ffffffffc020082c <buddy_alloc_pages+0x13e>
ffffffffc0200834:	b5f5                	j	ffffffffc0200720 <buddy_alloc_pages+0x32>
ffffffffc0200836:	00004317          	auipc	t1,0x4
ffffffffc020083a:	7e230313          	addi	t1,t1,2018 # ffffffffc0205018 <buddy_data>
ffffffffc020083e:	88aa                	mv	a7,a0
ffffffffc0200840:	8e1a                	mv	t3,t1
    unsigned int idx = 0;
ffffffffc0200842:	4701                	li	a4,0
ffffffffc0200844:	bddd                	j	ffffffffc020073a <buddy_alloc_pages+0x4c>
    while (n >>= 1) ++idx;
ffffffffc0200846:	00004317          	auipc	t1,0x4
ffffffffc020084a:	7d230313          	addi	t1,t1,2002 # ffffffffc0205018 <buddy_data>
ffffffffc020084e:	8e1a                	mv	t3,t1
ffffffffc0200850:	4885                	li	a7,1
    unsigned int idx = 0;
ffffffffc0200852:	4701                	li	a4,0
ffffffffc0200854:	b5dd                	j	ffffffffc020073a <buddy_alloc_pages+0x4c>
    assert(order > 0 && order <= BUDDY_MAX_ORDER_VALUE);
ffffffffc0200856:	00001697          	auipc	a3,0x1
ffffffffc020085a:	cca68693          	addi	a3,a3,-822 # ffffffffc0201520 <etext+0x2b4>
ffffffffc020085e:	00001617          	auipc	a2,0x1
ffffffffc0200862:	c6260613          	addi	a2,a2,-926 # ffffffffc02014c0 <etext+0x254>
ffffffffc0200866:	02800593          	li	a1,40
ffffffffc020086a:	00001517          	auipc	a0,0x1
ffffffffc020086e:	c6e50513          	addi	a0,a0,-914 # ffffffffc02014d8 <etext+0x26c>
ffffffffc0200872:	957ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(!list_empty(&BUDDY_ARRAY[order]));
ffffffffc0200876:	00001697          	auipc	a3,0x1
ffffffffc020087a:	cda68693          	addi	a3,a3,-806 # ffffffffc0201550 <etext+0x2e4>
ffffffffc020087e:	00001617          	auipc	a2,0x1
ffffffffc0200882:	c4260613          	addi	a2,a2,-958 # ffffffffc02014c0 <etext+0x254>
ffffffffc0200886:	02900593          	li	a1,41
ffffffffc020088a:	00001517          	auipc	a0,0x1
ffffffffc020088e:	c4e50513          	addi	a0,a0,-946 # ffffffffc02014d8 <etext+0x26c>
ffffffffc0200892:	937ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(reqpg > 0);
ffffffffc0200896:	00001697          	auipc	a3,0x1
ffffffffc020089a:	c7a68693          	addi	a3,a3,-902 # ffffffffc0201510 <etext+0x2a4>
ffffffffc020089e:	00001617          	auipc	a2,0x1
ffffffffc02008a2:	c2260613          	addi	a2,a2,-990 # ffffffffc02014c0 <etext+0x254>
ffffffffc02008a6:	06e00593          	li	a1,110
ffffffffc02008aa:	00001517          	auipc	a0,0x1
ffffffffc02008ae:	c2e50513          	addi	a0,a0,-978 # ffffffffc02014d8 <etext+0x26c>
ffffffffc02008b2:	e822                	sd	s0,16(sp)
ffffffffc02008b4:	e426                	sd	s1,8(sp)
ffffffffc02008b6:	913ff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc02008ba <buddy_init_memmap>:
static void buddy_init_memmap(struct Page *base, size_t n) {
ffffffffc02008ba:	1141                	addi	sp,sp,-16
ffffffffc02008bc:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02008be:	c9e1                	beqz	a1,ffffffffc020098e <buddy_init_memmap+0xd4>
    return !(n == 0 || (n & (n - 1)));
ffffffffc02008c0:	fff58793          	addi	a5,a1,-1
ffffffffc02008c4:	8fed                	and	a5,a5,a1
ffffffffc02008c6:	e3d1                	bnez	a5,ffffffffc020094a <buddy_init_memmap+0x90>
    while (n >>= 1) ++idx;
ffffffffc02008c8:	0015d793          	srli	a5,a1,0x1
    unsigned int idx = 0;
ffffffffc02008cc:	4601                	li	a2,0
    while (n >>= 1) ++idx;
ffffffffc02008ce:	c781                	beqz	a5,ffffffffc02008d6 <buddy_init_memmap+0x1c>
ffffffffc02008d0:	8385                	srli	a5,a5,0x1
ffffffffc02008d2:	2605                	addiw	a2,a2,1
ffffffffc02008d4:	fff5                	bnez	a5,ffffffffc02008d0 <buddy_init_memmap+0x16>
    for (struct Page *p = base; p < base + blocksz; ++p) {
ffffffffc02008d6:	00259693          	slli	a3,a1,0x2
ffffffffc02008da:	96ae                	add	a3,a3,a1
ffffffffc02008dc:	068e                	slli	a3,a3,0x3
ffffffffc02008de:	96aa                	add	a3,a3,a0
ffffffffc02008e0:	02d57163          	bgeu	a0,a3,ffffffffc0200902 <buddy_init_memmap+0x48>
ffffffffc02008e4:	87aa                	mv	a5,a0
        p->property = -1;
ffffffffc02008e6:	587d                	li	a6,-1
        assert(PageReserved(p));
ffffffffc02008e8:	6798                	ld	a4,8(a5)
ffffffffc02008ea:	8b05                	andi	a4,a4,1
ffffffffc02008ec:	c349                	beqz	a4,ffffffffc020096e <buddy_init_memmap+0xb4>
        p->flags = 0;
ffffffffc02008ee:	0007b423          	sd	zero,8(a5)
        p->property = -1;
ffffffffc02008f2:	0107a823          	sw	a6,16(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc02008f6:	0007a023          	sw	zero,0(a5)
    for (struct Page *p = base; p < base + blocksz; ++p) {
ffffffffc02008fa:	02878793          	addi	a5,a5,40
ffffffffc02008fe:	fed7e5e3          	bltu	a5,a3,ffffffffc02008e8 <buddy_init_memmap+0x2e>
    list_add(&BUDDY_ARRAY[BUDDY_MAX_ORDER_VALUE], &base->page_link);
ffffffffc0200902:	02061793          	slli	a5,a2,0x20
ffffffffc0200906:	9381                	srli	a5,a5,0x20
ffffffffc0200908:	00004717          	auipc	a4,0x4
ffffffffc020090c:	71070713          	addi	a4,a4,1808 # ffffffffc0205018 <buddy_data>
ffffffffc0200910:	00479813          	slli	a6,a5,0x4
    BUDDY_NR_FREE = blocksz;
ffffffffc0200914:	2581                	sext.w	a1,a1
    list_add(&BUDDY_ARRAY[BUDDY_MAX_ORDER_VALUE], &base->page_link);
ffffffffc0200916:	983a                	add	a6,a6,a4
    __list_add(elm, listelm, listelm->next);
ffffffffc0200918:	0792                	slli	a5,a5,0x4
ffffffffc020091a:	97ba                	add	a5,a5,a4
ffffffffc020091c:	0087b883          	ld	a7,8(a5)
    SetPageProperty(base);
ffffffffc0200920:	6514                	ld	a3,8(a0)
    BUDDY_MAX_ORDER_VALUE = order;
ffffffffc0200922:	0ec72823          	sw	a2,240(a4)
    BUDDY_NR_FREE = blocksz;
ffffffffc0200926:	0eb72a23          	sw	a1,244(a4)
    list_add(&BUDDY_ARRAY[BUDDY_MAX_ORDER_VALUE], &base->page_link);
ffffffffc020092a:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc020092e:	00e8b023          	sd	a4,0(a7)
}
ffffffffc0200932:	60a2                	ld	ra,8(sp)
ffffffffc0200934:	e798                	sd	a4,8(a5)
    SetPageProperty(base);
ffffffffc0200936:	0026e793          	ori	a5,a3,2
    elm->next = next;
ffffffffc020093a:	03153023          	sd	a7,32(a0)
    elm->prev = prev;
ffffffffc020093e:	01053c23          	sd	a6,24(a0)
    base->property = BUDDY_MAX_ORDER_VALUE;
ffffffffc0200942:	c910                	sw	a2,16(a0)
    SetPageProperty(base);
ffffffffc0200944:	e51c                	sd	a5,8(a0)
}
ffffffffc0200946:	0141                	addi	sp,sp,16
ffffffffc0200948:	8082                	ret
    while (p < n) p <<= 1;
ffffffffc020094a:	4785                	li	a5,1
ffffffffc020094c:	00f58863          	beq	a1,a5,ffffffffc020095c <buddy_init_memmap+0xa2>
ffffffffc0200950:	0786                	slli	a5,a5,0x1
ffffffffc0200952:	feb7efe3          	bltu	a5,a1,ffffffffc0200950 <buddy_init_memmap+0x96>
    return p >> 1;
ffffffffc0200956:	0017d593          	srli	a1,a5,0x1
ffffffffc020095a:	b7bd                	j	ffffffffc02008c8 <buddy_init_memmap+0xe>
    while (p < n) p <<= 1;
ffffffffc020095c:	00004717          	auipc	a4,0x4
ffffffffc0200960:	6bc70713          	addi	a4,a4,1724 # ffffffffc0205018 <buddy_data>
ffffffffc0200964:	883a                	mv	a6,a4
ffffffffc0200966:	4581                	li	a1,0
    unsigned int idx = 0;
ffffffffc0200968:	4601                	li	a2,0
ffffffffc020096a:	4781                	li	a5,0
ffffffffc020096c:	b775                	j	ffffffffc0200918 <buddy_init_memmap+0x5e>
        assert(PageReserved(p));
ffffffffc020096e:	00001697          	auipc	a3,0x1
ffffffffc0200972:	c0a68693          	addi	a3,a3,-1014 # ffffffffc0201578 <etext+0x30c>
ffffffffc0200976:	00001617          	auipc	a2,0x1
ffffffffc020097a:	b4a60613          	addi	a2,a2,-1206 # ffffffffc02014c0 <etext+0x254>
ffffffffc020097e:	06000593          	li	a1,96
ffffffffc0200982:	00001517          	auipc	a0,0x1
ffffffffc0200986:	b5650513          	addi	a0,a0,-1194 # ffffffffc02014d8 <etext+0x26c>
ffffffffc020098a:	83fff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(n > 0);
ffffffffc020098e:	00001697          	auipc	a3,0x1
ffffffffc0200992:	b2a68693          	addi	a3,a3,-1238 # ffffffffc02014b8 <etext+0x24c>
ffffffffc0200996:	00001617          	auipc	a2,0x1
ffffffffc020099a:	b2a60613          	addi	a2,a2,-1238 # ffffffffc02014c0 <etext+0x254>
ffffffffc020099e:	05b00593          	li	a1,91
ffffffffc02009a2:	00001517          	auipc	a0,0x1
ffffffffc02009a6:	b3650513          	addi	a0,a0,-1226 # ffffffffc02014d8 <etext+0x26c>
ffffffffc02009aa:	81fff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc02009ae <buddy_show_array.constprop.0>:
    assert(right >= 0 && right <= BUDDY_MAX_ORDER_VALUE);
ffffffffc02009ae:	00004717          	auipc	a4,0x4
ffffffffc02009b2:	75a72703          	lw	a4,1882(a4) # ffffffffc0205108 <buddy_data+0xf0>
static void buddy_show_array(int left, int right) {
ffffffffc02009b6:	7139                	addi	sp,sp,-64
ffffffffc02009b8:	fc06                	sd	ra,56(sp)
ffffffffc02009ba:	f822                	sd	s0,48(sp)
ffffffffc02009bc:	f426                	sd	s1,40(sp)
ffffffffc02009be:	f04a                	sd	s2,32(sp)
ffffffffc02009c0:	ec4e                	sd	s3,24(sp)
ffffffffc02009c2:	e852                	sd	s4,16(sp)
    assert(right >= 0 && right <= BUDDY_MAX_ORDER_VALUE);
ffffffffc02009c4:	47b5                	li	a5,13
ffffffffc02009c6:	08e7fe63          	bgeu	a5,a4,ffffffffc0200a62 <buddy_show_array.constprop.0+0xb4>
    cprintf("==== Buddy Free List ====\n");
ffffffffc02009ca:	00001517          	auipc	a0,0x1
ffffffffc02009ce:	bee50513          	addi	a0,a0,-1042 # ffffffffc02015b8 <etext+0x34c>
ffffffffc02009d2:	f76ff0ef          	jal	ffffffffc0200148 <cprintf>
    int nothing = 1;
ffffffffc02009d6:	4785                	li	a5,1
            cprintf("[%d pages @%p] ", 1 << pg->property, pg);
ffffffffc02009d8:	893e                	mv	s2,a5
ffffffffc02009da:	00004497          	auipc	s1,0x4
ffffffffc02009de:	63e48493          	addi	s1,s1,1598 # ffffffffc0205018 <buddy_data>
    for (int i = left; i <= right; ++i) {
ffffffffc02009e2:	4981                	li	s3,0
ffffffffc02009e4:	4a3d                	li	s4,15
    return listelm->next;
ffffffffc02009e6:	6480                	ld	s0,8(s1)
        for (list_entry_t *le = list_next(head); le != head; le = list_next(le)) {
ffffffffc02009e8:	04940463          	beq	s0,s1,ffffffffc0200a30 <buddy_show_array.constprop.0+0x82>
            struct Page *pg = le2page(le, page_link);
ffffffffc02009ec:	fe840613          	addi	a2,s0,-24
                cprintf("Order %d: ", i);
ffffffffc02009f0:	85ce                	mv	a1,s3
ffffffffc02009f2:	00001517          	auipc	a0,0x1
ffffffffc02009f6:	be650513          	addi	a0,a0,-1050 # ffffffffc02015d8 <etext+0x36c>
            struct Page *pg = le2page(le, page_link);
ffffffffc02009fa:	e432                	sd	a2,8(sp)
                cprintf("Order %d: ", i);
ffffffffc02009fc:	f4cff0ef          	jal	ffffffffc0200148 <cprintf>
ffffffffc0200a00:	6622                	ld	a2,8(sp)
                first = 0;
ffffffffc0200a02:	a019                	j	ffffffffc0200a08 <buddy_show_array.constprop.0+0x5a>
            struct Page *pg = le2page(le, page_link);
ffffffffc0200a04:	fe840613          	addi	a2,s0,-24
            cprintf("[%d pages @%p] ", 1 << pg->property, pg);
ffffffffc0200a08:	ff842583          	lw	a1,-8(s0)
ffffffffc0200a0c:	00001517          	auipc	a0,0x1
ffffffffc0200a10:	bdc50513          	addi	a0,a0,-1060 # ffffffffc02015e8 <etext+0x37c>
ffffffffc0200a14:	00b915bb          	sllw	a1,s2,a1
ffffffffc0200a18:	f30ff0ef          	jal	ffffffffc0200148 <cprintf>
ffffffffc0200a1c:	6400                	ld	s0,8(s0)
        for (list_entry_t *le = list_next(head); le != head; le = list_next(le)) {
ffffffffc0200a1e:	fe9413e3          	bne	s0,s1,ffffffffc0200a04 <buddy_show_array.constprop.0+0x56>
        if (!first) cprintf("\n");
ffffffffc0200a22:	00001517          	auipc	a0,0x1
ffffffffc0200a26:	93e50513          	addi	a0,a0,-1730 # ffffffffc0201360 <etext+0xf4>
ffffffffc0200a2a:	f1eff0ef          	jal	ffffffffc0200148 <cprintf>
ffffffffc0200a2e:	4781                	li	a5,0
    for (int i = left; i <= right; ++i) {
ffffffffc0200a30:	2985                	addiw	s3,s3,1
ffffffffc0200a32:	04c1                	addi	s1,s1,16
ffffffffc0200a34:	fb4999e3          	bne	s3,s4,ffffffffc02009e6 <buddy_show_array.constprop.0+0x38>
    if (nothing) cprintf("No free buddy blocks.\n");
ffffffffc0200a38:	ef91                	bnez	a5,ffffffffc0200a54 <buddy_show_array.constprop.0+0xa6>
}
ffffffffc0200a3a:	7442                	ld	s0,48(sp)
ffffffffc0200a3c:	70e2                	ld	ra,56(sp)
ffffffffc0200a3e:	74a2                	ld	s1,40(sp)
ffffffffc0200a40:	7902                	ld	s2,32(sp)
ffffffffc0200a42:	69e2                	ld	s3,24(sp)
ffffffffc0200a44:	6a42                	ld	s4,16(sp)
    cprintf("=========================\n");
ffffffffc0200a46:	00001517          	auipc	a0,0x1
ffffffffc0200a4a:	bca50513          	addi	a0,a0,-1078 # ffffffffc0201610 <etext+0x3a4>
}
ffffffffc0200a4e:	6121                	addi	sp,sp,64
    cprintf("=========================\n");
ffffffffc0200a50:	ef8ff06f          	j	ffffffffc0200148 <cprintf>
    if (nothing) cprintf("No free buddy blocks.\n");
ffffffffc0200a54:	00001517          	auipc	a0,0x1
ffffffffc0200a58:	ba450513          	addi	a0,a0,-1116 # ffffffffc02015f8 <etext+0x38c>
ffffffffc0200a5c:	eecff0ef          	jal	ffffffffc0200148 <cprintf>
ffffffffc0200a60:	bfe9                	j	ffffffffc0200a3a <buddy_show_array.constprop.0+0x8c>
    assert(right >= 0 && right <= BUDDY_MAX_ORDER_VALUE);
ffffffffc0200a62:	00001697          	auipc	a3,0x1
ffffffffc0200a66:	b2668693          	addi	a3,a3,-1242 # ffffffffc0201588 <etext+0x31c>
ffffffffc0200a6a:	00001617          	auipc	a2,0x1
ffffffffc0200a6e:	a5660613          	addi	a2,a2,-1450 # ffffffffc02014c0 <etext+0x254>
ffffffffc0200a72:	03d00593          	li	a1,61
ffffffffc0200a76:	00001517          	auipc	a0,0x1
ffffffffc0200a7a:	a6250513          	addi	a0,a0,-1438 # ffffffffc02014d8 <etext+0x26c>
ffffffffc0200a7e:	f4aff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200a82 <buddy_check>:
    free_pages(p2, 100);
    cprintf("Freed p2 (100 pages):\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);
}

static void buddy_check(void) {
ffffffffc0200a82:	1101                	addi	sp,sp,-32
    cprintf("Buddy system self-test\n");
ffffffffc0200a84:	00001517          	auipc	a0,0x1
ffffffffc0200a88:	bac50513          	addi	a0,a0,-1108 # ffffffffc0201630 <etext+0x3c4>
static void buddy_check(void) {
ffffffffc0200a8c:	ec06                	sd	ra,24(sp)
ffffffffc0200a8e:	e822                	sd	s0,16(sp)
ffffffffc0200a90:	e426                	sd	s1,8(sp)
ffffffffc0200a92:	e04a                	sd	s2,0(sp)
    cprintf("Buddy system self-test\n");
ffffffffc0200a94:	eb4ff0ef          	jal	ffffffffc0200148 <cprintf>
    struct Page *p0 = alloc_pages(10), *p1 = alloc_pages(10), *p2 = alloc_pages(10);
ffffffffc0200a98:	4529                	li	a0,10
ffffffffc0200a9a:	15e000ef          	jal	ffffffffc0200bf8 <alloc_pages>
ffffffffc0200a9e:	892a                	mv	s2,a0
ffffffffc0200aa0:	4529                	li	a0,10
ffffffffc0200aa2:	156000ef          	jal	ffffffffc0200bf8 <alloc_pages>
ffffffffc0200aa6:	84aa                	mv	s1,a0
ffffffffc0200aa8:	4529                	li	a0,10
ffffffffc0200aaa:	14e000ef          	jal	ffffffffc0200bf8 <alloc_pages>
ffffffffc0200aae:	842a                	mv	s0,a0
    cprintf("After allocating p0, p1, p2 (10 pages each):\n");
ffffffffc0200ab0:	00001517          	auipc	a0,0x1
ffffffffc0200ab4:	b9850513          	addi	a0,a0,-1128 # ffffffffc0201648 <etext+0x3dc>
ffffffffc0200ab8:	e90ff0ef          	jal	ffffffffc0200148 <cprintf>
    buddy_show_array(0, MAX_BUDDY_ORDER);
ffffffffc0200abc:	ef3ff0ef          	jal	ffffffffc02009ae <buddy_show_array.constprop.0>
    free_pages(p0, 10);
ffffffffc0200ac0:	45a9                	li	a1,10
ffffffffc0200ac2:	854a                	mv	a0,s2
ffffffffc0200ac4:	140000ef          	jal	ffffffffc0200c04 <free_pages>
    cprintf("Freed p0 (10 pages):\n");
ffffffffc0200ac8:	00001517          	auipc	a0,0x1
ffffffffc0200acc:	bb050513          	addi	a0,a0,-1104 # ffffffffc0201678 <etext+0x40c>
ffffffffc0200ad0:	e78ff0ef          	jal	ffffffffc0200148 <cprintf>
    buddy_show_array(0, MAX_BUDDY_ORDER);
ffffffffc0200ad4:	edbff0ef          	jal	ffffffffc02009ae <buddy_show_array.constprop.0>
    free_pages(p1, 10);
ffffffffc0200ad8:	45a9                	li	a1,10
ffffffffc0200ada:	8526                	mv	a0,s1
ffffffffc0200adc:	128000ef          	jal	ffffffffc0200c04 <free_pages>
    cprintf("Freed p1 (10 pages):\n");
ffffffffc0200ae0:	00001517          	auipc	a0,0x1
ffffffffc0200ae4:	bb050513          	addi	a0,a0,-1104 # ffffffffc0201690 <etext+0x424>
ffffffffc0200ae8:	e60ff0ef          	jal	ffffffffc0200148 <cprintf>
    buddy_show_array(0, MAX_BUDDY_ORDER);
ffffffffc0200aec:	ec3ff0ef          	jal	ffffffffc02009ae <buddy_show_array.constprop.0>
    free_pages(p2, 10);
ffffffffc0200af0:	45a9                	li	a1,10
ffffffffc0200af2:	8522                	mv	a0,s0
ffffffffc0200af4:	110000ef          	jal	ffffffffc0200c04 <free_pages>
    cprintf("Freed p2 (10 pages):\n");
ffffffffc0200af8:	00001517          	auipc	a0,0x1
ffffffffc0200afc:	bb050513          	addi	a0,a0,-1104 # ffffffffc02016a8 <etext+0x43c>
ffffffffc0200b00:	e48ff0ef          	jal	ffffffffc0200148 <cprintf>
    buddy_show_array(0, MAX_BUDDY_ORDER);
ffffffffc0200b04:	eabff0ef          	jal	ffffffffc02009ae <buddy_show_array.constprop.0>
    struct Page *p = alloc_pages(1);
ffffffffc0200b08:	4505                	li	a0,1
ffffffffc0200b0a:	0ee000ef          	jal	ffffffffc0200bf8 <alloc_pages>
ffffffffc0200b0e:	842a                	mv	s0,a0
    cprintf("Allocated 1 page:\n");
ffffffffc0200b10:	00001517          	auipc	a0,0x1
ffffffffc0200b14:	bb050513          	addi	a0,a0,-1104 # ffffffffc02016c0 <etext+0x454>
ffffffffc0200b18:	e30ff0ef          	jal	ffffffffc0200148 <cprintf>
    buddy_show_array(0, MAX_BUDDY_ORDER);
ffffffffc0200b1c:	e93ff0ef          	jal	ffffffffc02009ae <buddy_show_array.constprop.0>
    free_pages(p, 1);
ffffffffc0200b20:	4585                	li	a1,1
ffffffffc0200b22:	8522                	mv	a0,s0
ffffffffc0200b24:	0e0000ef          	jal	ffffffffc0200c04 <free_pages>
    cprintf("Freed 1 page:\n");
ffffffffc0200b28:	00001517          	auipc	a0,0x1
ffffffffc0200b2c:	bb050513          	addi	a0,a0,-1104 # ffffffffc02016d8 <etext+0x46c>
ffffffffc0200b30:	e18ff0ef          	jal	ffffffffc0200148 <cprintf>
    buddy_show_array(0, MAX_BUDDY_ORDER);
ffffffffc0200b34:	e7bff0ef          	jal	ffffffffc02009ae <buddy_show_array.constprop.0>
    struct Page *p = alloc_pages(8192);
ffffffffc0200b38:	6509                	lui	a0,0x2
ffffffffc0200b3a:	0be000ef          	jal	ffffffffc0200bf8 <alloc_pages>
ffffffffc0200b3e:	842a                	mv	s0,a0
    cprintf("Allocated 8192 pages:\n");
ffffffffc0200b40:	00001517          	auipc	a0,0x1
ffffffffc0200b44:	ba850513          	addi	a0,a0,-1112 # ffffffffc02016e8 <etext+0x47c>
ffffffffc0200b48:	e00ff0ef          	jal	ffffffffc0200148 <cprintf>
    if (p == NULL) {  // 新增：判断分配是否失败
ffffffffc0200b4c:	cc59                	beqz	s0,ffffffffc0200bea <buddy_check+0x168>
    buddy_show_array(0, MAX_BUDDY_ORDER);
ffffffffc0200b4e:	e61ff0ef          	jal	ffffffffc02009ae <buddy_show_array.constprop.0>
    free_pages(p, 8192);
ffffffffc0200b52:	8522                	mv	a0,s0
ffffffffc0200b54:	6589                	lui	a1,0x2
ffffffffc0200b56:	0ae000ef          	jal	ffffffffc0200c04 <free_pages>
    cprintf("Freed 8192 pages:\n");
ffffffffc0200b5a:	00001517          	auipc	a0,0x1
ffffffffc0200b5e:	bde50513          	addi	a0,a0,-1058 # ffffffffc0201738 <etext+0x4cc>
ffffffffc0200b62:	de6ff0ef          	jal	ffffffffc0200148 <cprintf>
    buddy_show_array(0, MAX_BUDDY_ORDER);
ffffffffc0200b66:	e49ff0ef          	jal	ffffffffc02009ae <buddy_show_array.constprop.0>
    struct Page *p0 = alloc_pages(10), *p1 = alloc_pages(50), *p2 = alloc_pages(100);
ffffffffc0200b6a:	4529                	li	a0,10
ffffffffc0200b6c:	08c000ef          	jal	ffffffffc0200bf8 <alloc_pages>
ffffffffc0200b70:	892a                	mv	s2,a0
ffffffffc0200b72:	03200513          	li	a0,50
ffffffffc0200b76:	082000ef          	jal	ffffffffc0200bf8 <alloc_pages>
ffffffffc0200b7a:	84aa                	mv	s1,a0
ffffffffc0200b7c:	06400513          	li	a0,100
ffffffffc0200b80:	078000ef          	jal	ffffffffc0200bf8 <alloc_pages>
ffffffffc0200b84:	842a                	mv	s0,a0
    cprintf("After allocating p0 (10), p1 (50), p2 (100):\n");
ffffffffc0200b86:	00001517          	auipc	a0,0x1
ffffffffc0200b8a:	bca50513          	addi	a0,a0,-1078 # ffffffffc0201750 <etext+0x4e4>
ffffffffc0200b8e:	dbaff0ef          	jal	ffffffffc0200148 <cprintf>
    buddy_show_array(0, MAX_BUDDY_ORDER);
ffffffffc0200b92:	e1dff0ef          	jal	ffffffffc02009ae <buddy_show_array.constprop.0>
    free_pages(p0, 10);
ffffffffc0200b96:	45a9                	li	a1,10
ffffffffc0200b98:	854a                	mv	a0,s2
ffffffffc0200b9a:	06a000ef          	jal	ffffffffc0200c04 <free_pages>
    cprintf("Freed p0 (10 pages):\n");
ffffffffc0200b9e:	00001517          	auipc	a0,0x1
ffffffffc0200ba2:	ada50513          	addi	a0,a0,-1318 # ffffffffc0201678 <etext+0x40c>
ffffffffc0200ba6:	da2ff0ef          	jal	ffffffffc0200148 <cprintf>
    buddy_show_array(0, MAX_BUDDY_ORDER);
ffffffffc0200baa:	e05ff0ef          	jal	ffffffffc02009ae <buddy_show_array.constprop.0>
    free_pages(p1, 50);
ffffffffc0200bae:	03200593          	li	a1,50
ffffffffc0200bb2:	8526                	mv	a0,s1
ffffffffc0200bb4:	050000ef          	jal	ffffffffc0200c04 <free_pages>
    cprintf("Freed p1 (50 pages):\n");
ffffffffc0200bb8:	00001517          	auipc	a0,0x1
ffffffffc0200bbc:	bc850513          	addi	a0,a0,-1080 # ffffffffc0201780 <etext+0x514>
ffffffffc0200bc0:	d88ff0ef          	jal	ffffffffc0200148 <cprintf>
    buddy_show_array(0, MAX_BUDDY_ORDER);
ffffffffc0200bc4:	debff0ef          	jal	ffffffffc02009ae <buddy_show_array.constprop.0>
    free_pages(p2, 100);
ffffffffc0200bc8:	8522                	mv	a0,s0
ffffffffc0200bca:	06400593          	li	a1,100
ffffffffc0200bce:	036000ef          	jal	ffffffffc0200c04 <free_pages>
    cprintf("Freed p2 (100 pages):\n");
ffffffffc0200bd2:	00001517          	auipc	a0,0x1
ffffffffc0200bd6:	bc650513          	addi	a0,a0,-1082 # ffffffffc0201798 <etext+0x52c>
ffffffffc0200bda:	d6eff0ef          	jal	ffffffffc0200148 <cprintf>
    buddy_check_easy();
    buddy_check_min_alloc_free();
    buddy_check_max_alloc_free();
    buddy_check_difficult();
}
ffffffffc0200bde:	6442                	ld	s0,16(sp)
ffffffffc0200be0:	60e2                	ld	ra,24(sp)
ffffffffc0200be2:	64a2                	ld	s1,8(sp)
ffffffffc0200be4:	6902                	ld	s2,0(sp)
ffffffffc0200be6:	6105                	addi	sp,sp,32
    buddy_show_array(0, MAX_BUDDY_ORDER);
ffffffffc0200be8:	b3d9                	j	ffffffffc02009ae <buddy_show_array.constprop.0>
        cprintf("Allocate 8192 pages failed (insufficient memory)\n");
ffffffffc0200bea:	00001517          	auipc	a0,0x1
ffffffffc0200bee:	b1650513          	addi	a0,a0,-1258 # ffffffffc0201700 <etext+0x494>
ffffffffc0200bf2:	d56ff0ef          	jal	ffffffffc0200148 <cprintf>
        return;  // 避免后续对NULL指针操作
ffffffffc0200bf6:	bf95                	j	ffffffffc0200b6a <buddy_check+0xe8>

ffffffffc0200bf8 <alloc_pages>:
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
    return pmm_manager->alloc_pages(n);
ffffffffc0200bf8:	00004797          	auipc	a5,0x4
ffffffffc0200bfc:	5307b783          	ld	a5,1328(a5) # ffffffffc0205128 <pmm_manager>
ffffffffc0200c00:	6f9c                	ld	a5,24(a5)
ffffffffc0200c02:	8782                	jr	a5

ffffffffc0200c04 <free_pages>:
}

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    pmm_manager->free_pages(base, n);
ffffffffc0200c04:	00004797          	auipc	a5,0x4
ffffffffc0200c08:	5247b783          	ld	a5,1316(a5) # ffffffffc0205128 <pmm_manager>
ffffffffc0200c0c:	739c                	ld	a5,32(a5)
ffffffffc0200c0e:	8782                	jr	a5

ffffffffc0200c10 <pmm_init>:
    pmm_manager = &buddy_system_pmm_manager;
ffffffffc0200c10:	00001797          	auipc	a5,0x1
ffffffffc0200c14:	de078793          	addi	a5,a5,-544 # ffffffffc02019f0 <buddy_system_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200c18:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc0200c1a:	7139                	addi	sp,sp,-64
ffffffffc0200c1c:	fc06                	sd	ra,56(sp)
ffffffffc0200c1e:	f822                	sd	s0,48(sp)
ffffffffc0200c20:	f426                	sd	s1,40(sp)
ffffffffc0200c22:	ec4e                	sd	s3,24(sp)
ffffffffc0200c24:	f04a                	sd	s2,32(sp)
    pmm_manager = &buddy_system_pmm_manager;
ffffffffc0200c26:	00004417          	auipc	s0,0x4
ffffffffc0200c2a:	50240413          	addi	s0,s0,1282 # ffffffffc0205128 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200c2e:	00001517          	auipc	a0,0x1
ffffffffc0200c32:	ba250513          	addi	a0,a0,-1118 # ffffffffc02017d0 <etext+0x564>
    pmm_manager = &buddy_system_pmm_manager;
ffffffffc0200c36:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200c38:	d10ff0ef          	jal	ffffffffc0200148 <cprintf>
    pmm_manager->init();
ffffffffc0200c3c:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200c3e:	00004497          	auipc	s1,0x4
ffffffffc0200c42:	50248493          	addi	s1,s1,1282 # ffffffffc0205140 <va_pa_offset>
    pmm_manager->init();
ffffffffc0200c46:	679c                	ld	a5,8(a5)
ffffffffc0200c48:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200c4a:	57f5                	li	a5,-3
ffffffffc0200c4c:	07fa                	slli	a5,a5,0x1e
ffffffffc0200c4e:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc0200c50:	90bff0ef          	jal	ffffffffc020055a <get_memory_base>
ffffffffc0200c54:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0200c56:	90fff0ef          	jal	ffffffffc0200564 <get_memory_size>
    if (mem_size == 0) {
ffffffffc0200c5a:	14050c63          	beqz	a0,ffffffffc0200db2 <pmm_init+0x1a2>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0200c5e:	00a98933          	add	s2,s3,a0
ffffffffc0200c62:	e42a                	sd	a0,8(sp)
    cprintf("physcial memory map:\n");
ffffffffc0200c64:	00001517          	auipc	a0,0x1
ffffffffc0200c68:	bb450513          	addi	a0,a0,-1100 # ffffffffc0201818 <etext+0x5ac>
ffffffffc0200c6c:	cdcff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0200c70:	65a2                	ld	a1,8(sp)
ffffffffc0200c72:	864e                	mv	a2,s3
ffffffffc0200c74:	fff90693          	addi	a3,s2,-1
ffffffffc0200c78:	00001517          	auipc	a0,0x1
ffffffffc0200c7c:	bb850513          	addi	a0,a0,-1096 # ffffffffc0201830 <etext+0x5c4>
ffffffffc0200c80:	cc8ff0ef          	jal	ffffffffc0200148 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc0200c84:	c80007b7          	lui	a5,0xc8000
ffffffffc0200c88:	85ca                	mv	a1,s2
ffffffffc0200c8a:	0d27e263          	bltu	a5,s2,ffffffffc0200d4e <pmm_init+0x13e>
ffffffffc0200c8e:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200c90:	00005697          	auipc	a3,0x5
ffffffffc0200c94:	4c768693          	addi	a3,a3,1223 # ffffffffc0206157 <end+0xfff>
ffffffffc0200c98:	8efd                	and	a3,a3,a5
    npage = maxpa / PGSIZE;
ffffffffc0200c9a:	81b1                	srli	a1,a1,0xc
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200c9c:	fff80837          	lui	a6,0xfff80
    npage = maxpa / PGSIZE;
ffffffffc0200ca0:	00004797          	auipc	a5,0x4
ffffffffc0200ca4:	4ab7b423          	sd	a1,1192(a5) # ffffffffc0205148 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200ca8:	00004797          	auipc	a5,0x4
ffffffffc0200cac:	4ad7b423          	sd	a3,1192(a5) # ffffffffc0205150 <pages>
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200cb0:	982e                	add	a6,a6,a1
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200cb2:	88b6                	mv	a7,a3
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200cb4:	02080963          	beqz	a6,ffffffffc0200ce6 <pmm_init+0xd6>
ffffffffc0200cb8:	00259613          	slli	a2,a1,0x2
ffffffffc0200cbc:	962e                	add	a2,a2,a1
ffffffffc0200cbe:	fec007b7          	lui	a5,0xfec00
ffffffffc0200cc2:	97b6                	add	a5,a5,a3
ffffffffc0200cc4:	060e                	slli	a2,a2,0x3
ffffffffc0200cc6:	963e                	add	a2,a2,a5
ffffffffc0200cc8:	87b6                	mv	a5,a3
        SetPageReserved(pages + i);
ffffffffc0200cca:	6798                	ld	a4,8(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200ccc:	02878793          	addi	a5,a5,40 # fffffffffec00028 <end+0x3e9faed0>
        SetPageReserved(pages + i);
ffffffffc0200cd0:	00176713          	ori	a4,a4,1
ffffffffc0200cd4:	fee7b023          	sd	a4,-32(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200cd8:	fec799e3          	bne	a5,a2,ffffffffc0200cca <pmm_init+0xba>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200cdc:	00281793          	slli	a5,a6,0x2
ffffffffc0200ce0:	97c2                	add	a5,a5,a6
ffffffffc0200ce2:	078e                	slli	a5,a5,0x3
ffffffffc0200ce4:	96be                	add	a3,a3,a5
ffffffffc0200ce6:	c02007b7          	lui	a5,0xc0200
ffffffffc0200cea:	0af6e863          	bltu	a3,a5,ffffffffc0200d9a <pmm_init+0x18a>
ffffffffc0200cee:	6098                	ld	a4,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0200cf0:	77fd                	lui	a5,0xfffff
ffffffffc0200cf2:	00f97933          	and	s2,s2,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200cf6:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0200cf8:	0526ed63          	bltu	a3,s2,ffffffffc0200d52 <pmm_init+0x142>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0200cfc:	601c                	ld	a5,0(s0)
ffffffffc0200cfe:	7b9c                	ld	a5,48(a5)
ffffffffc0200d00:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0200d02:	00001517          	auipc	a0,0x1
ffffffffc0200d06:	bb650513          	addi	a0,a0,-1098 # ffffffffc02018b8 <etext+0x64c>
ffffffffc0200d0a:	c3eff0ef          	jal	ffffffffc0200148 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0200d0e:	00003597          	auipc	a1,0x3
ffffffffc0200d12:	2f258593          	addi	a1,a1,754 # ffffffffc0204000 <boot_page_table_sv39>
ffffffffc0200d16:	00004797          	auipc	a5,0x4
ffffffffc0200d1a:	42b7b123          	sd	a1,1058(a5) # ffffffffc0205138 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200d1e:	c02007b7          	lui	a5,0xc0200
ffffffffc0200d22:	0af5e463          	bltu	a1,a5,ffffffffc0200dca <pmm_init+0x1ba>
ffffffffc0200d26:	609c                	ld	a5,0(s1)
}
ffffffffc0200d28:	7442                	ld	s0,48(sp)
ffffffffc0200d2a:	70e2                	ld	ra,56(sp)
ffffffffc0200d2c:	74a2                	ld	s1,40(sp)
ffffffffc0200d2e:	7902                	ld	s2,32(sp)
ffffffffc0200d30:	69e2                	ld	s3,24(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0200d32:	40f586b3          	sub	a3,a1,a5
ffffffffc0200d36:	00004797          	auipc	a5,0x4
ffffffffc0200d3a:	3ed7bd23          	sd	a3,1018(a5) # ffffffffc0205130 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200d3e:	00001517          	auipc	a0,0x1
ffffffffc0200d42:	b9a50513          	addi	a0,a0,-1126 # ffffffffc02018d8 <etext+0x66c>
ffffffffc0200d46:	8636                	mv	a2,a3
}
ffffffffc0200d48:	6121                	addi	sp,sp,64
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200d4a:	bfeff06f          	j	ffffffffc0200148 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc0200d4e:	85be                	mv	a1,a5
ffffffffc0200d50:	bf3d                	j	ffffffffc0200c8e <pmm_init+0x7e>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0200d52:	6705                	lui	a4,0x1
ffffffffc0200d54:	177d                	addi	a4,a4,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc0200d56:	96ba                	add	a3,a3,a4
ffffffffc0200d58:	8efd                	and	a3,a3,a5
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0200d5a:	00c6d793          	srli	a5,a3,0xc
ffffffffc0200d5e:	02b7f263          	bgeu	a5,a1,ffffffffc0200d82 <pmm_init+0x172>
    pmm_manager->init_memmap(base, n);
ffffffffc0200d62:	6018                	ld	a4,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0200d64:	fff80637          	lui	a2,0xfff80
ffffffffc0200d68:	97b2                	add	a5,a5,a2
ffffffffc0200d6a:	00279513          	slli	a0,a5,0x2
ffffffffc0200d6e:	953e                	add	a0,a0,a5
ffffffffc0200d70:	6b1c                	ld	a5,16(a4)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0200d72:	40d90933          	sub	s2,s2,a3
ffffffffc0200d76:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0200d78:	00c95593          	srli	a1,s2,0xc
ffffffffc0200d7c:	9546                	add	a0,a0,a7
ffffffffc0200d7e:	9782                	jalr	a5
}
ffffffffc0200d80:	bfb5                	j	ffffffffc0200cfc <pmm_init+0xec>
        panic("pa2page called with invalid pa");
ffffffffc0200d82:	00001617          	auipc	a2,0x1
ffffffffc0200d86:	b0660613          	addi	a2,a2,-1274 # ffffffffc0201888 <etext+0x61c>
ffffffffc0200d8a:	06a00593          	li	a1,106
ffffffffc0200d8e:	00001517          	auipc	a0,0x1
ffffffffc0200d92:	b1a50513          	addi	a0,a0,-1254 # ffffffffc02018a8 <etext+0x63c>
ffffffffc0200d96:	c32ff0ef          	jal	ffffffffc02001c8 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200d9a:	00001617          	auipc	a2,0x1
ffffffffc0200d9e:	ac660613          	addi	a2,a2,-1338 # ffffffffc0201860 <etext+0x5f4>
ffffffffc0200da2:	05f00593          	li	a1,95
ffffffffc0200da6:	00001517          	auipc	a0,0x1
ffffffffc0200daa:	a6250513          	addi	a0,a0,-1438 # ffffffffc0201808 <etext+0x59c>
ffffffffc0200dae:	c1aff0ef          	jal	ffffffffc02001c8 <__panic>
        panic("DTB memory info not available");
ffffffffc0200db2:	00001617          	auipc	a2,0x1
ffffffffc0200db6:	a3660613          	addi	a2,a2,-1482 # ffffffffc02017e8 <etext+0x57c>
ffffffffc0200dba:	04700593          	li	a1,71
ffffffffc0200dbe:	00001517          	auipc	a0,0x1
ffffffffc0200dc2:	a4a50513          	addi	a0,a0,-1462 # ffffffffc0201808 <etext+0x59c>
ffffffffc0200dc6:	c02ff0ef          	jal	ffffffffc02001c8 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200dca:	86ae                	mv	a3,a1
ffffffffc0200dcc:	00001617          	auipc	a2,0x1
ffffffffc0200dd0:	a9460613          	addi	a2,a2,-1388 # ffffffffc0201860 <etext+0x5f4>
ffffffffc0200dd4:	07a00593          	li	a1,122
ffffffffc0200dd8:	00001517          	auipc	a0,0x1
ffffffffc0200ddc:	a3050513          	addi	a0,a0,-1488 # ffffffffc0201808 <etext+0x59c>
ffffffffc0200de0:	be8ff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200de4 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0200de4:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0200de6:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0200dea:	f022                	sd	s0,32(sp)
ffffffffc0200dec:	ec26                	sd	s1,24(sp)
ffffffffc0200dee:	e84a                	sd	s2,16(sp)
ffffffffc0200df0:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0200df2:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0200df6:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc0200df8:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0200dfc:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0200e00:	84aa                	mv	s1,a0
ffffffffc0200e02:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc0200e04:	03067d63          	bgeu	a2,a6,ffffffffc0200e3e <printnum+0x5a>
ffffffffc0200e08:	e44e                	sd	s3,8(sp)
ffffffffc0200e0a:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0200e0c:	4785                	li	a5,1
ffffffffc0200e0e:	00e7d763          	bge	a5,a4,ffffffffc0200e1c <printnum+0x38>
            putch(padc, putdat);
ffffffffc0200e12:	85ca                	mv	a1,s2
ffffffffc0200e14:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc0200e16:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0200e18:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0200e1a:	fc65                	bnez	s0,ffffffffc0200e12 <printnum+0x2e>
ffffffffc0200e1c:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0200e1e:	00001797          	auipc	a5,0x1
ffffffffc0200e22:	afa78793          	addi	a5,a5,-1286 # ffffffffc0201918 <etext+0x6ac>
ffffffffc0200e26:	97d2                	add	a5,a5,s4
}
ffffffffc0200e28:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0200e2a:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0200e2e:	70a2                	ld	ra,40(sp)
ffffffffc0200e30:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0200e32:	85ca                	mv	a1,s2
ffffffffc0200e34:	87a6                	mv	a5,s1
}
ffffffffc0200e36:	6942                	ld	s2,16(sp)
ffffffffc0200e38:	64e2                	ld	s1,24(sp)
ffffffffc0200e3a:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0200e3c:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0200e3e:	03065633          	divu	a2,a2,a6
ffffffffc0200e42:	8722                	mv	a4,s0
ffffffffc0200e44:	fa1ff0ef          	jal	ffffffffc0200de4 <printnum>
ffffffffc0200e48:	bfd9                	j	ffffffffc0200e1e <printnum+0x3a>

ffffffffc0200e4a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0200e4a:	7119                	addi	sp,sp,-128
ffffffffc0200e4c:	f4a6                	sd	s1,104(sp)
ffffffffc0200e4e:	f0ca                	sd	s2,96(sp)
ffffffffc0200e50:	ecce                	sd	s3,88(sp)
ffffffffc0200e52:	e8d2                	sd	s4,80(sp)
ffffffffc0200e54:	e4d6                	sd	s5,72(sp)
ffffffffc0200e56:	e0da                	sd	s6,64(sp)
ffffffffc0200e58:	f862                	sd	s8,48(sp)
ffffffffc0200e5a:	fc86                	sd	ra,120(sp)
ffffffffc0200e5c:	f8a2                	sd	s0,112(sp)
ffffffffc0200e5e:	fc5e                	sd	s7,56(sp)
ffffffffc0200e60:	f466                	sd	s9,40(sp)
ffffffffc0200e62:	f06a                	sd	s10,32(sp)
ffffffffc0200e64:	ec6e                	sd	s11,24(sp)
ffffffffc0200e66:	84aa                	mv	s1,a0
ffffffffc0200e68:	8c32                	mv	s8,a2
ffffffffc0200e6a:	8a36                	mv	s4,a3
ffffffffc0200e6c:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0200e6e:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200e72:	05500b13          	li	s6,85
ffffffffc0200e76:	00001a97          	auipc	s5,0x1
ffffffffc0200e7a:	bb2a8a93          	addi	s5,s5,-1102 # ffffffffc0201a28 <buddy_system_pmm_manager+0x38>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0200e7e:	000c4503          	lbu	a0,0(s8)
ffffffffc0200e82:	001c0413          	addi	s0,s8,1
ffffffffc0200e86:	01350a63          	beq	a0,s3,ffffffffc0200e9a <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0200e8a:	cd0d                	beqz	a0,ffffffffc0200ec4 <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0200e8c:	85ca                	mv	a1,s2
ffffffffc0200e8e:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0200e90:	00044503          	lbu	a0,0(s0)
ffffffffc0200e94:	0405                	addi	s0,s0,1
ffffffffc0200e96:	ff351ae3          	bne	a0,s3,ffffffffc0200e8a <vprintfmt+0x40>
        width = precision = -1;
ffffffffc0200e9a:	5cfd                	li	s9,-1
ffffffffc0200e9c:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc0200e9e:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc0200ea2:	4b81                	li	s7,0
ffffffffc0200ea4:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200ea6:	00044683          	lbu	a3,0(s0)
ffffffffc0200eaa:	00140c13          	addi	s8,s0,1
ffffffffc0200eae:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0200eb2:	0ff5f593          	zext.b	a1,a1
ffffffffc0200eb6:	02bb6663          	bltu	s6,a1,ffffffffc0200ee2 <vprintfmt+0x98>
ffffffffc0200eba:	058a                	slli	a1,a1,0x2
ffffffffc0200ebc:	95d6                	add	a1,a1,s5
ffffffffc0200ebe:	4198                	lw	a4,0(a1)
ffffffffc0200ec0:	9756                	add	a4,a4,s5
ffffffffc0200ec2:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0200ec4:	70e6                	ld	ra,120(sp)
ffffffffc0200ec6:	7446                	ld	s0,112(sp)
ffffffffc0200ec8:	74a6                	ld	s1,104(sp)
ffffffffc0200eca:	7906                	ld	s2,96(sp)
ffffffffc0200ecc:	69e6                	ld	s3,88(sp)
ffffffffc0200ece:	6a46                	ld	s4,80(sp)
ffffffffc0200ed0:	6aa6                	ld	s5,72(sp)
ffffffffc0200ed2:	6b06                	ld	s6,64(sp)
ffffffffc0200ed4:	7be2                	ld	s7,56(sp)
ffffffffc0200ed6:	7c42                	ld	s8,48(sp)
ffffffffc0200ed8:	7ca2                	ld	s9,40(sp)
ffffffffc0200eda:	7d02                	ld	s10,32(sp)
ffffffffc0200edc:	6de2                	ld	s11,24(sp)
ffffffffc0200ede:	6109                	addi	sp,sp,128
ffffffffc0200ee0:	8082                	ret
            putch('%', putdat);
ffffffffc0200ee2:	85ca                	mv	a1,s2
ffffffffc0200ee4:	02500513          	li	a0,37
ffffffffc0200ee8:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0200eea:	fff44783          	lbu	a5,-1(s0)
ffffffffc0200eee:	02500713          	li	a4,37
ffffffffc0200ef2:	8c22                	mv	s8,s0
ffffffffc0200ef4:	f8e785e3          	beq	a5,a4,ffffffffc0200e7e <vprintfmt+0x34>
ffffffffc0200ef8:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0200efc:	1c7d                	addi	s8,s8,-1
ffffffffc0200efe:	fee79de3          	bne	a5,a4,ffffffffc0200ef8 <vprintfmt+0xae>
ffffffffc0200f02:	bfb5                	j	ffffffffc0200e7e <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0200f04:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0200f08:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc0200f0a:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc0200f0e:	fd06071b          	addiw	a4,a2,-48
ffffffffc0200f12:	24e56a63          	bltu	a0,a4,ffffffffc0201166 <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc0200f16:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200f18:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc0200f1a:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc0200f1e:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0200f22:	0197073b          	addw	a4,a4,s9
ffffffffc0200f26:	0017171b          	slliw	a4,a4,0x1
ffffffffc0200f2a:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc0200f2c:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0200f30:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0200f32:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0200f36:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc0200f3a:	feb570e3          	bgeu	a0,a1,ffffffffc0200f1a <vprintfmt+0xd0>
            if (width < 0)
ffffffffc0200f3e:	f60d54e3          	bgez	s10,ffffffffc0200ea6 <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0200f42:	8d66                	mv	s10,s9
ffffffffc0200f44:	5cfd                	li	s9,-1
ffffffffc0200f46:	b785                	j	ffffffffc0200ea6 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200f48:	8db6                	mv	s11,a3
ffffffffc0200f4a:	8462                	mv	s0,s8
ffffffffc0200f4c:	bfa9                	j	ffffffffc0200ea6 <vprintfmt+0x5c>
ffffffffc0200f4e:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0200f50:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0200f52:	bf91                	j	ffffffffc0200ea6 <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0200f54:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0200f56:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0200f5a:	00f74463          	blt	a4,a5,ffffffffc0200f62 <vprintfmt+0x118>
    else if (lflag) {
ffffffffc0200f5e:	1a078763          	beqz	a5,ffffffffc020110c <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0200f62:	000a3603          	ld	a2,0(s4)
ffffffffc0200f66:	46c1                	li	a3,16
ffffffffc0200f68:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0200f6a:	000d879b          	sext.w	a5,s11
ffffffffc0200f6e:	876a                	mv	a4,s10
ffffffffc0200f70:	85ca                	mv	a1,s2
ffffffffc0200f72:	8526                	mv	a0,s1
ffffffffc0200f74:	e71ff0ef          	jal	ffffffffc0200de4 <printnum>
            break;
ffffffffc0200f78:	b719                	j	ffffffffc0200e7e <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0200f7a:	000a2503          	lw	a0,0(s4)
ffffffffc0200f7e:	85ca                	mv	a1,s2
ffffffffc0200f80:	0a21                	addi	s4,s4,8
ffffffffc0200f82:	9482                	jalr	s1
            break;
ffffffffc0200f84:	bded                	j	ffffffffc0200e7e <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0200f86:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0200f88:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0200f8c:	00f74463          	blt	a4,a5,ffffffffc0200f94 <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0200f90:	16078963          	beqz	a5,ffffffffc0201102 <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc0200f94:	000a3603          	ld	a2,0(s4)
ffffffffc0200f98:	46a9                	li	a3,10
ffffffffc0200f9a:	8a2e                	mv	s4,a1
ffffffffc0200f9c:	b7f9                	j	ffffffffc0200f6a <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc0200f9e:	85ca                	mv	a1,s2
ffffffffc0200fa0:	03000513          	li	a0,48
ffffffffc0200fa4:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc0200fa6:	85ca                	mv	a1,s2
ffffffffc0200fa8:	07800513          	li	a0,120
ffffffffc0200fac:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0200fae:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc0200fb2:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0200fb4:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0200fb6:	bf55                	j	ffffffffc0200f6a <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc0200fb8:	85ca                	mv	a1,s2
ffffffffc0200fba:	02500513          	li	a0,37
ffffffffc0200fbe:	9482                	jalr	s1
            break;
ffffffffc0200fc0:	bd7d                	j	ffffffffc0200e7e <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc0200fc2:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200fc6:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc0200fc8:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc0200fca:	bf95                	j	ffffffffc0200f3e <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc0200fcc:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0200fce:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0200fd2:	00f74463          	blt	a4,a5,ffffffffc0200fda <vprintfmt+0x190>
    else if (lflag) {
ffffffffc0200fd6:	12078163          	beqz	a5,ffffffffc02010f8 <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc0200fda:	000a3603          	ld	a2,0(s4)
ffffffffc0200fde:	46a1                	li	a3,8
ffffffffc0200fe0:	8a2e                	mv	s4,a1
ffffffffc0200fe2:	b761                	j	ffffffffc0200f6a <vprintfmt+0x120>
            if (width < 0)
ffffffffc0200fe4:	876a                	mv	a4,s10
ffffffffc0200fe6:	000d5363          	bgez	s10,ffffffffc0200fec <vprintfmt+0x1a2>
ffffffffc0200fea:	4701                	li	a4,0
ffffffffc0200fec:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0200ff0:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0200ff2:	bd55                	j	ffffffffc0200ea6 <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc0200ff4:	000d841b          	sext.w	s0,s11
ffffffffc0200ff8:	fd340793          	addi	a5,s0,-45
ffffffffc0200ffc:	00f037b3          	snez	a5,a5
ffffffffc0201000:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201004:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc0201008:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020100a:	008a0793          	addi	a5,s4,8
ffffffffc020100e:	e43e                	sd	a5,8(sp)
ffffffffc0201010:	100d8c63          	beqz	s11,ffffffffc0201128 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0201014:	12071363          	bnez	a4,ffffffffc020113a <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201018:	000dc783          	lbu	a5,0(s11)
ffffffffc020101c:	0007851b          	sext.w	a0,a5
ffffffffc0201020:	c78d                	beqz	a5,ffffffffc020104a <vprintfmt+0x200>
ffffffffc0201022:	0d85                	addi	s11,s11,1
ffffffffc0201024:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201026:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020102a:	000cc563          	bltz	s9,ffffffffc0201034 <vprintfmt+0x1ea>
ffffffffc020102e:	3cfd                	addiw	s9,s9,-1
ffffffffc0201030:	008c8d63          	beq	s9,s0,ffffffffc020104a <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201034:	020b9663          	bnez	s7,ffffffffc0201060 <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc0201038:	85ca                	mv	a1,s2
ffffffffc020103a:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020103c:	000dc783          	lbu	a5,0(s11)
ffffffffc0201040:	0d85                	addi	s11,s11,1
ffffffffc0201042:	3d7d                	addiw	s10,s10,-1
ffffffffc0201044:	0007851b          	sext.w	a0,a5
ffffffffc0201048:	f3ed                	bnez	a5,ffffffffc020102a <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc020104a:	01a05963          	blez	s10,ffffffffc020105c <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc020104e:	85ca                	mv	a1,s2
ffffffffc0201050:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0201054:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc0201056:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc0201058:	fe0d1be3          	bnez	s10,ffffffffc020104e <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020105c:	6a22                	ld	s4,8(sp)
ffffffffc020105e:	b505                	j	ffffffffc0200e7e <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201060:	3781                	addiw	a5,a5,-32
ffffffffc0201062:	fcfa7be3          	bgeu	s4,a5,ffffffffc0201038 <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc0201066:	03f00513          	li	a0,63
ffffffffc020106a:	85ca                	mv	a1,s2
ffffffffc020106c:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020106e:	000dc783          	lbu	a5,0(s11)
ffffffffc0201072:	0d85                	addi	s11,s11,1
ffffffffc0201074:	3d7d                	addiw	s10,s10,-1
ffffffffc0201076:	0007851b          	sext.w	a0,a5
ffffffffc020107a:	dbe1                	beqz	a5,ffffffffc020104a <vprintfmt+0x200>
ffffffffc020107c:	fa0cd9e3          	bgez	s9,ffffffffc020102e <vprintfmt+0x1e4>
ffffffffc0201080:	b7c5                	j	ffffffffc0201060 <vprintfmt+0x216>
            if (err < 0) {
ffffffffc0201082:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201086:	4619                	li	a2,6
            err = va_arg(ap, int);
ffffffffc0201088:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020108a:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020108e:	8fb9                	xor	a5,a5,a4
ffffffffc0201090:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201094:	02d64563          	blt	a2,a3,ffffffffc02010be <vprintfmt+0x274>
ffffffffc0201098:	00001797          	auipc	a5,0x1
ffffffffc020109c:	ae878793          	addi	a5,a5,-1304 # ffffffffc0201b80 <error_string>
ffffffffc02010a0:	00369713          	slli	a4,a3,0x3
ffffffffc02010a4:	97ba                	add	a5,a5,a4
ffffffffc02010a6:	639c                	ld	a5,0(a5)
ffffffffc02010a8:	cb99                	beqz	a5,ffffffffc02010be <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc02010aa:	86be                	mv	a3,a5
ffffffffc02010ac:	00001617          	auipc	a2,0x1
ffffffffc02010b0:	89c60613          	addi	a2,a2,-1892 # ffffffffc0201948 <etext+0x6dc>
ffffffffc02010b4:	85ca                	mv	a1,s2
ffffffffc02010b6:	8526                	mv	a0,s1
ffffffffc02010b8:	0d8000ef          	jal	ffffffffc0201190 <printfmt>
ffffffffc02010bc:	b3c9                	j	ffffffffc0200e7e <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02010be:	00001617          	auipc	a2,0x1
ffffffffc02010c2:	87a60613          	addi	a2,a2,-1926 # ffffffffc0201938 <etext+0x6cc>
ffffffffc02010c6:	85ca                	mv	a1,s2
ffffffffc02010c8:	8526                	mv	a0,s1
ffffffffc02010ca:	0c6000ef          	jal	ffffffffc0201190 <printfmt>
ffffffffc02010ce:	bb45                	j	ffffffffc0200e7e <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc02010d0:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02010d2:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc02010d6:	00f74363          	blt	a4,a5,ffffffffc02010dc <vprintfmt+0x292>
    else if (lflag) {
ffffffffc02010da:	cf81                	beqz	a5,ffffffffc02010f2 <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc02010dc:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02010e0:	02044b63          	bltz	s0,ffffffffc0201116 <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc02010e4:	8622                	mv	a2,s0
ffffffffc02010e6:	8a5e                	mv	s4,s7
ffffffffc02010e8:	46a9                	li	a3,10
ffffffffc02010ea:	b541                	j	ffffffffc0200f6a <vprintfmt+0x120>
            lflag ++;
ffffffffc02010ec:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02010ee:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc02010f0:	bb5d                	j	ffffffffc0200ea6 <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc02010f2:	000a2403          	lw	s0,0(s4)
ffffffffc02010f6:	b7ed                	j	ffffffffc02010e0 <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc02010f8:	000a6603          	lwu	a2,0(s4)
ffffffffc02010fc:	46a1                	li	a3,8
ffffffffc02010fe:	8a2e                	mv	s4,a1
ffffffffc0201100:	b5ad                	j	ffffffffc0200f6a <vprintfmt+0x120>
ffffffffc0201102:	000a6603          	lwu	a2,0(s4)
ffffffffc0201106:	46a9                	li	a3,10
ffffffffc0201108:	8a2e                	mv	s4,a1
ffffffffc020110a:	b585                	j	ffffffffc0200f6a <vprintfmt+0x120>
ffffffffc020110c:	000a6603          	lwu	a2,0(s4)
ffffffffc0201110:	46c1                	li	a3,16
ffffffffc0201112:	8a2e                	mv	s4,a1
ffffffffc0201114:	bd99                	j	ffffffffc0200f6a <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc0201116:	85ca                	mv	a1,s2
ffffffffc0201118:	02d00513          	li	a0,45
ffffffffc020111c:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc020111e:	40800633          	neg	a2,s0
ffffffffc0201122:	8a5e                	mv	s4,s7
ffffffffc0201124:	46a9                	li	a3,10
ffffffffc0201126:	b591                	j	ffffffffc0200f6a <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc0201128:	e329                	bnez	a4,ffffffffc020116a <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020112a:	02800793          	li	a5,40
ffffffffc020112e:	853e                	mv	a0,a5
ffffffffc0201130:	00001d97          	auipc	s11,0x1
ffffffffc0201134:	801d8d93          	addi	s11,s11,-2047 # ffffffffc0201931 <etext+0x6c5>
ffffffffc0201138:	b5f5                	j	ffffffffc0201024 <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020113a:	85e6                	mv	a1,s9
ffffffffc020113c:	856e                	mv	a0,s11
ffffffffc020113e:	0a4000ef          	jal	ffffffffc02011e2 <strnlen>
ffffffffc0201142:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0201146:	01a05863          	blez	s10,ffffffffc0201156 <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc020114a:	85ca                	mv	a1,s2
ffffffffc020114c:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020114e:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc0201150:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201152:	fe0d1ce3          	bnez	s10,ffffffffc020114a <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201156:	000dc783          	lbu	a5,0(s11)
ffffffffc020115a:	0007851b          	sext.w	a0,a5
ffffffffc020115e:	ec0792e3          	bnez	a5,ffffffffc0201022 <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201162:	6a22                	ld	s4,8(sp)
ffffffffc0201164:	bb29                	j	ffffffffc0200e7e <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201166:	8462                	mv	s0,s8
ffffffffc0201168:	bbd9                	j	ffffffffc0200f3e <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020116a:	85e6                	mv	a1,s9
ffffffffc020116c:	00000517          	auipc	a0,0x0
ffffffffc0201170:	7c450513          	addi	a0,a0,1988 # ffffffffc0201930 <etext+0x6c4>
ffffffffc0201174:	06e000ef          	jal	ffffffffc02011e2 <strnlen>
ffffffffc0201178:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020117c:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0201180:	00000d97          	auipc	s11,0x0
ffffffffc0201184:	7b0d8d93          	addi	s11,s11,1968 # ffffffffc0201930 <etext+0x6c4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201188:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020118a:	fda040e3          	bgtz	s10,ffffffffc020114a <vprintfmt+0x300>
ffffffffc020118e:	bd51                	j	ffffffffc0201022 <vprintfmt+0x1d8>

ffffffffc0201190 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201190:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201192:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201196:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201198:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020119a:	ec06                	sd	ra,24(sp)
ffffffffc020119c:	f83a                	sd	a4,48(sp)
ffffffffc020119e:	fc3e                	sd	a5,56(sp)
ffffffffc02011a0:	e0c2                	sd	a6,64(sp)
ffffffffc02011a2:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02011a4:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02011a6:	ca5ff0ef          	jal	ffffffffc0200e4a <vprintfmt>
}
ffffffffc02011aa:	60e2                	ld	ra,24(sp)
ffffffffc02011ac:	6161                	addi	sp,sp,80
ffffffffc02011ae:	8082                	ret

ffffffffc02011b0 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc02011b0:	00004717          	auipc	a4,0x4
ffffffffc02011b4:	e6073703          	ld	a4,-416(a4) # ffffffffc0205010 <SBI_CONSOLE_PUTCHAR>
ffffffffc02011b8:	4781                	li	a5,0
ffffffffc02011ba:	88ba                	mv	a7,a4
ffffffffc02011bc:	852a                	mv	a0,a0
ffffffffc02011be:	85be                	mv	a1,a5
ffffffffc02011c0:	863e                	mv	a2,a5
ffffffffc02011c2:	00000073          	ecall
ffffffffc02011c6:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc02011c8:	8082                	ret

ffffffffc02011ca <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02011ca:	00054783          	lbu	a5,0(a0)
ffffffffc02011ce:	cb81                	beqz	a5,ffffffffc02011de <strlen+0x14>
    size_t cnt = 0;
ffffffffc02011d0:	4781                	li	a5,0
        cnt ++;
ffffffffc02011d2:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc02011d4:	00f50733          	add	a4,a0,a5
ffffffffc02011d8:	00074703          	lbu	a4,0(a4)
ffffffffc02011dc:	fb7d                	bnez	a4,ffffffffc02011d2 <strlen+0x8>
    }
    return cnt;
}
ffffffffc02011de:	853e                	mv	a0,a5
ffffffffc02011e0:	8082                	ret

ffffffffc02011e2 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02011e2:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02011e4:	e589                	bnez	a1,ffffffffc02011ee <strnlen+0xc>
ffffffffc02011e6:	a811                	j	ffffffffc02011fa <strnlen+0x18>
        cnt ++;
ffffffffc02011e8:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02011ea:	00f58863          	beq	a1,a5,ffffffffc02011fa <strnlen+0x18>
ffffffffc02011ee:	00f50733          	add	a4,a0,a5
ffffffffc02011f2:	00074703          	lbu	a4,0(a4)
ffffffffc02011f6:	fb6d                	bnez	a4,ffffffffc02011e8 <strnlen+0x6>
ffffffffc02011f8:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02011fa:	852e                	mv	a0,a1
ffffffffc02011fc:	8082                	ret

ffffffffc02011fe <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02011fe:	00054783          	lbu	a5,0(a0)
ffffffffc0201202:	e791                	bnez	a5,ffffffffc020120e <strcmp+0x10>
ffffffffc0201204:	a01d                	j	ffffffffc020122a <strcmp+0x2c>
ffffffffc0201206:	00054783          	lbu	a5,0(a0)
ffffffffc020120a:	cb99                	beqz	a5,ffffffffc0201220 <strcmp+0x22>
ffffffffc020120c:	0585                	addi	a1,a1,1
ffffffffc020120e:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0201212:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201214:	fef709e3          	beq	a4,a5,ffffffffc0201206 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201218:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc020121c:	9d19                	subw	a0,a0,a4
ffffffffc020121e:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201220:	0015c703          	lbu	a4,1(a1)
ffffffffc0201224:	4501                	li	a0,0
}
ffffffffc0201226:	9d19                	subw	a0,a0,a4
ffffffffc0201228:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020122a:	0005c703          	lbu	a4,0(a1)
ffffffffc020122e:	4501                	li	a0,0
ffffffffc0201230:	b7f5                	j	ffffffffc020121c <strcmp+0x1e>

ffffffffc0201232 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201232:	ce01                	beqz	a2,ffffffffc020124a <strncmp+0x18>
ffffffffc0201234:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201238:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020123a:	cb91                	beqz	a5,ffffffffc020124e <strncmp+0x1c>
ffffffffc020123c:	0005c703          	lbu	a4,0(a1)
ffffffffc0201240:	00f71763          	bne	a4,a5,ffffffffc020124e <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc0201244:	0505                	addi	a0,a0,1
ffffffffc0201246:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201248:	f675                	bnez	a2,ffffffffc0201234 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020124a:	4501                	li	a0,0
ffffffffc020124c:	8082                	ret
ffffffffc020124e:	00054503          	lbu	a0,0(a0)
ffffffffc0201252:	0005c783          	lbu	a5,0(a1)
ffffffffc0201256:	9d1d                	subw	a0,a0,a5
}
ffffffffc0201258:	8082                	ret

ffffffffc020125a <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc020125a:	ca01                	beqz	a2,ffffffffc020126a <memset+0x10>
ffffffffc020125c:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc020125e:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0201260:	0785                	addi	a5,a5,1
ffffffffc0201262:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201266:	fef61de3          	bne	a2,a5,ffffffffc0201260 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc020126a:	8082                	ret
