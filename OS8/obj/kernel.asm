
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00014297          	auipc	t0,0x14
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0214000 <boot_hartid>
ffffffffc020000c:	00014297          	auipc	t0,0x14
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0214008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02132b7          	lui	t0,0xc0213
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0213137          	lui	sp,0xc0213
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
ffffffffc020004a:	00091517          	auipc	a0,0x91
ffffffffc020004e:	01650513          	addi	a0,a0,22 # ffffffffc0291060 <buf>
ffffffffc0200052:	00097617          	auipc	a2,0x97
ffffffffc0200056:	8be60613          	addi	a2,a2,-1858 # ffffffffc0296910 <end>
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc0212ff0 <bootstack+0x1ff0>
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
ffffffffc0200060:	e406                	sd	ra,8(sp)
ffffffffc0200062:	3380b0ef          	jal	ffffffffc020b39a <memset>
ffffffffc0200066:	4da000ef          	jal	ffffffffc0200540 <cons_init>
ffffffffc020006a:	0000b597          	auipc	a1,0xb
ffffffffc020006e:	39e58593          	addi	a1,a1,926 # ffffffffc020b408 <etext+0x6>
ffffffffc0200072:	0000b517          	auipc	a0,0xb
ffffffffc0200076:	3b650513          	addi	a0,a0,950 # ffffffffc020b428 <etext+0x26>
ffffffffc020007a:	12c000ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020007e:	1ac000ef          	jal	ffffffffc020022a <print_kerninfo>
ffffffffc0200082:	618000ef          	jal	ffffffffc020069a <dtb_init>
ffffffffc0200086:	1e7020ef          	jal	ffffffffc0202a6c <pmm_init>
ffffffffc020008a:	379000ef          	jal	ffffffffc0200c02 <pic_init>
ffffffffc020008e:	49b000ef          	jal	ffffffffc0200d28 <idt_init>
ffffffffc0200092:	4e1030ef          	jal	ffffffffc0203d72 <vmm_init>
ffffffffc0200096:	07c070ef          	jal	ffffffffc0207112 <sched_init>
ffffffffc020009a:	481060ef          	jal	ffffffffc0206d1a <proc_init>
ffffffffc020009e:	143000ef          	jal	ffffffffc02009e0 <ide_init>
ffffffffc02000a2:	759040ef          	jal	ffffffffc0204ffa <fs_init>
ffffffffc02000a6:	452000ef          	jal	ffffffffc02004f8 <clock_init>
ffffffffc02000aa:	34d000ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc02000ae:	641060ef          	jal	ffffffffc0206eee <cpu_idle>

ffffffffc02000b2 <readline>:
ffffffffc02000b2:	7179                	addi	sp,sp,-48
ffffffffc02000b4:	f406                	sd	ra,40(sp)
ffffffffc02000b6:	f022                	sd	s0,32(sp)
ffffffffc02000b8:	ec26                	sd	s1,24(sp)
ffffffffc02000ba:	e84a                	sd	s2,16(sp)
ffffffffc02000bc:	e44e                	sd	s3,8(sp)
ffffffffc02000be:	c901                	beqz	a0,ffffffffc02000ce <readline+0x1c>
ffffffffc02000c0:	85aa                	mv	a1,a0
ffffffffc02000c2:	0000b517          	auipc	a0,0xb
ffffffffc02000c6:	36e50513          	addi	a0,a0,878 # ffffffffc020b430 <etext+0x2e>
ffffffffc02000ca:	0dc000ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02000ce:	4481                	li	s1,0
ffffffffc02000d0:	497d                	li	s2,31
ffffffffc02000d2:	00091997          	auipc	s3,0x91
ffffffffc02000d6:	f8e98993          	addi	s3,s3,-114 # ffffffffc0291060 <buf>
ffffffffc02000da:	108000ef          	jal	ffffffffc02001e2 <getchar>
ffffffffc02000de:	842a                	mv	s0,a0
ffffffffc02000e0:	ff850793          	addi	a5,a0,-8
ffffffffc02000e4:	3ff4a713          	slti	a4,s1,1023
ffffffffc02000e8:	ff650693          	addi	a3,a0,-10
ffffffffc02000ec:	ff350613          	addi	a2,a0,-13
ffffffffc02000f0:	02054963          	bltz	a0,ffffffffc0200122 <readline+0x70>
ffffffffc02000f4:	02a95f63          	bge	s2,a0,ffffffffc0200132 <readline+0x80>
ffffffffc02000f8:	cf0d                	beqz	a4,ffffffffc0200132 <readline+0x80>
ffffffffc02000fa:	0e6000ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc02000fe:	009987b3          	add	a5,s3,s1
ffffffffc0200102:	00878023          	sb	s0,0(a5)
ffffffffc0200106:	2485                	addiw	s1,s1,1
ffffffffc0200108:	0da000ef          	jal	ffffffffc02001e2 <getchar>
ffffffffc020010c:	842a                	mv	s0,a0
ffffffffc020010e:	ff850793          	addi	a5,a0,-8
ffffffffc0200112:	3ff4a713          	slti	a4,s1,1023
ffffffffc0200116:	ff650693          	addi	a3,a0,-10
ffffffffc020011a:	ff350613          	addi	a2,a0,-13
ffffffffc020011e:	fc055be3          	bgez	a0,ffffffffc02000f4 <readline+0x42>
ffffffffc0200122:	70a2                	ld	ra,40(sp)
ffffffffc0200124:	7402                	ld	s0,32(sp)
ffffffffc0200126:	64e2                	ld	s1,24(sp)
ffffffffc0200128:	6942                	ld	s2,16(sp)
ffffffffc020012a:	69a2                	ld	s3,8(sp)
ffffffffc020012c:	4501                	li	a0,0
ffffffffc020012e:	6145                	addi	sp,sp,48
ffffffffc0200130:	8082                	ret
ffffffffc0200132:	eb81                	bnez	a5,ffffffffc0200142 <readline+0x90>
ffffffffc0200134:	4521                	li	a0,8
ffffffffc0200136:	00905663          	blez	s1,ffffffffc0200142 <readline+0x90>
ffffffffc020013a:	0a6000ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc020013e:	34fd                	addiw	s1,s1,-1
ffffffffc0200140:	bf69                	j	ffffffffc02000da <readline+0x28>
ffffffffc0200142:	c291                	beqz	a3,ffffffffc0200146 <readline+0x94>
ffffffffc0200144:	fa59                	bnez	a2,ffffffffc02000da <readline+0x28>
ffffffffc0200146:	8522                	mv	a0,s0
ffffffffc0200148:	098000ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc020014c:	00091517          	auipc	a0,0x91
ffffffffc0200150:	f1450513          	addi	a0,a0,-236 # ffffffffc0291060 <buf>
ffffffffc0200154:	94aa                	add	s1,s1,a0
ffffffffc0200156:	00048023          	sb	zero,0(s1)
ffffffffc020015a:	70a2                	ld	ra,40(sp)
ffffffffc020015c:	7402                	ld	s0,32(sp)
ffffffffc020015e:	64e2                	ld	s1,24(sp)
ffffffffc0200160:	6942                	ld	s2,16(sp)
ffffffffc0200162:	69a2                	ld	s3,8(sp)
ffffffffc0200164:	6145                	addi	sp,sp,48
ffffffffc0200166:	8082                	ret

ffffffffc0200168 <cputch>:
ffffffffc0200168:	1101                	addi	sp,sp,-32
ffffffffc020016a:	ec06                	sd	ra,24(sp)
ffffffffc020016c:	e42e                	sd	a1,8(sp)
ffffffffc020016e:	3e0000ef          	jal	ffffffffc020054e <cons_putc>
ffffffffc0200172:	65a2                	ld	a1,8(sp)
ffffffffc0200174:	60e2                	ld	ra,24(sp)
ffffffffc0200176:	419c                	lw	a5,0(a1)
ffffffffc0200178:	2785                	addiw	a5,a5,1
ffffffffc020017a:	c19c                	sw	a5,0(a1)
ffffffffc020017c:	6105                	addi	sp,sp,32
ffffffffc020017e:	8082                	ret

ffffffffc0200180 <vcprintf>:
ffffffffc0200180:	1101                	addi	sp,sp,-32
ffffffffc0200182:	872e                	mv	a4,a1
ffffffffc0200184:	75dd                	lui	a1,0xffff7
ffffffffc0200186:	86aa                	mv	a3,a0
ffffffffc0200188:	0070                	addi	a2,sp,12
ffffffffc020018a:	00000517          	auipc	a0,0x0
ffffffffc020018e:	fde50513          	addi	a0,a0,-34 # ffffffffc0200168 <cputch>
ffffffffc0200192:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0200196:	ec06                	sd	ra,24(sp)
ffffffffc0200198:	c602                	sw	zero,12(sp)
ffffffffc020019a:	5650a0ef          	jal	ffffffffc020aefe <vprintfmt>
ffffffffc020019e:	60e2                	ld	ra,24(sp)
ffffffffc02001a0:	4532                	lw	a0,12(sp)
ffffffffc02001a2:	6105                	addi	sp,sp,32
ffffffffc02001a4:	8082                	ret

ffffffffc02001a6 <cprintf>:
ffffffffc02001a6:	711d                	addi	sp,sp,-96
ffffffffc02001a8:	02810313          	addi	t1,sp,40
ffffffffc02001ac:	f42e                	sd	a1,40(sp)
ffffffffc02001ae:	75dd                	lui	a1,0xffff7
ffffffffc02001b0:	f832                	sd	a2,48(sp)
ffffffffc02001b2:	fc36                	sd	a3,56(sp)
ffffffffc02001b4:	e0ba                	sd	a4,64(sp)
ffffffffc02001b6:	86aa                	mv	a3,a0
ffffffffc02001b8:	0050                	addi	a2,sp,4
ffffffffc02001ba:	00000517          	auipc	a0,0x0
ffffffffc02001be:	fae50513          	addi	a0,a0,-82 # ffffffffc0200168 <cputch>
ffffffffc02001c2:	871a                	mv	a4,t1
ffffffffc02001c4:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc02001c8:	ec06                	sd	ra,24(sp)
ffffffffc02001ca:	e4be                	sd	a5,72(sp)
ffffffffc02001cc:	e8c2                	sd	a6,80(sp)
ffffffffc02001ce:	ecc6                	sd	a7,88(sp)
ffffffffc02001d0:	c202                	sw	zero,4(sp)
ffffffffc02001d2:	e41a                	sd	t1,8(sp)
ffffffffc02001d4:	52b0a0ef          	jal	ffffffffc020aefe <vprintfmt>
ffffffffc02001d8:	60e2                	ld	ra,24(sp)
ffffffffc02001da:	4512                	lw	a0,4(sp)
ffffffffc02001dc:	6125                	addi	sp,sp,96
ffffffffc02001de:	8082                	ret

ffffffffc02001e0 <cputchar>:
ffffffffc02001e0:	a6bd                	j	ffffffffc020054e <cons_putc>

ffffffffc02001e2 <getchar>:
ffffffffc02001e2:	1141                	addi	sp,sp,-16
ffffffffc02001e4:	e406                	sd	ra,8(sp)
ffffffffc02001e6:	3d0000ef          	jal	ffffffffc02005b6 <cons_getc>
ffffffffc02001ea:	dd75                	beqz	a0,ffffffffc02001e6 <getchar+0x4>
ffffffffc02001ec:	60a2                	ld	ra,8(sp)
ffffffffc02001ee:	0141                	addi	sp,sp,16
ffffffffc02001f0:	8082                	ret

ffffffffc02001f2 <strdup>:
ffffffffc02001f2:	7179                	addi	sp,sp,-48
ffffffffc02001f4:	f406                	sd	ra,40(sp)
ffffffffc02001f6:	f022                	sd	s0,32(sp)
ffffffffc02001f8:	ec26                	sd	s1,24(sp)
ffffffffc02001fa:	84aa                	mv	s1,a0
ffffffffc02001fc:	0ea0b0ef          	jal	ffffffffc020b2e6 <strlen>
ffffffffc0200200:	842a                	mv	s0,a0
ffffffffc0200202:	0505                	addi	a0,a0,1
ffffffffc0200204:	5d1010ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0200208:	87aa                	mv	a5,a0
ffffffffc020020a:	c911                	beqz	a0,ffffffffc020021e <strdup+0x2c>
ffffffffc020020c:	8622                	mv	a2,s0
ffffffffc020020e:	85a6                	mv	a1,s1
ffffffffc0200210:	e42a                	sd	a0,8(sp)
ffffffffc0200212:	1d80b0ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc0200216:	67a2                	ld	a5,8(sp)
ffffffffc0200218:	943e                	add	s0,s0,a5
ffffffffc020021a:	00040023          	sb	zero,0(s0)
ffffffffc020021e:	70a2                	ld	ra,40(sp)
ffffffffc0200220:	7402                	ld	s0,32(sp)
ffffffffc0200222:	64e2                	ld	s1,24(sp)
ffffffffc0200224:	853e                	mv	a0,a5
ffffffffc0200226:	6145                	addi	sp,sp,48
ffffffffc0200228:	8082                	ret

ffffffffc020022a <print_kerninfo>:
ffffffffc020022a:	1141                	addi	sp,sp,-16
ffffffffc020022c:	0000b517          	auipc	a0,0xb
ffffffffc0200230:	20c50513          	addi	a0,a0,524 # ffffffffc020b438 <etext+0x36>
ffffffffc0200234:	e406                	sd	ra,8(sp)
ffffffffc0200236:	f71ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020023a:	00000597          	auipc	a1,0x0
ffffffffc020023e:	e1058593          	addi	a1,a1,-496 # ffffffffc020004a <kern_init>
ffffffffc0200242:	0000b517          	auipc	a0,0xb
ffffffffc0200246:	21650513          	addi	a0,a0,534 # ffffffffc020b458 <etext+0x56>
ffffffffc020024a:	f5dff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020024e:	0000b597          	auipc	a1,0xb
ffffffffc0200252:	1b458593          	addi	a1,a1,436 # ffffffffc020b402 <etext>
ffffffffc0200256:	0000b517          	auipc	a0,0xb
ffffffffc020025a:	22250513          	addi	a0,a0,546 # ffffffffc020b478 <etext+0x76>
ffffffffc020025e:	f49ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200262:	00091597          	auipc	a1,0x91
ffffffffc0200266:	dfe58593          	addi	a1,a1,-514 # ffffffffc0291060 <buf>
ffffffffc020026a:	0000b517          	auipc	a0,0xb
ffffffffc020026e:	22e50513          	addi	a0,a0,558 # ffffffffc020b498 <etext+0x96>
ffffffffc0200272:	f35ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200276:	00096597          	auipc	a1,0x96
ffffffffc020027a:	69a58593          	addi	a1,a1,1690 # ffffffffc0296910 <end>
ffffffffc020027e:	0000b517          	auipc	a0,0xb
ffffffffc0200282:	23a50513          	addi	a0,a0,570 # ffffffffc020b4b8 <etext+0xb6>
ffffffffc0200286:	f21ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020028a:	00000717          	auipc	a4,0x0
ffffffffc020028e:	dc070713          	addi	a4,a4,-576 # ffffffffc020004a <kern_init>
ffffffffc0200292:	00097797          	auipc	a5,0x97
ffffffffc0200296:	a7d78793          	addi	a5,a5,-1411 # ffffffffc0296d0f <end+0x3ff>
ffffffffc020029a:	8f99                	sub	a5,a5,a4
ffffffffc020029c:	43f7d593          	srai	a1,a5,0x3f
ffffffffc02002a0:	60a2                	ld	ra,8(sp)
ffffffffc02002a2:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002a6:	95be                	add	a1,a1,a5
ffffffffc02002a8:	85a9                	srai	a1,a1,0xa
ffffffffc02002aa:	0000b517          	auipc	a0,0xb
ffffffffc02002ae:	22e50513          	addi	a0,a0,558 # ffffffffc020b4d8 <etext+0xd6>
ffffffffc02002b2:	0141                	addi	sp,sp,16
ffffffffc02002b4:	bdcd                	j	ffffffffc02001a6 <cprintf>

ffffffffc02002b6 <print_stackframe>:
ffffffffc02002b6:	1141                	addi	sp,sp,-16
ffffffffc02002b8:	0000b617          	auipc	a2,0xb
ffffffffc02002bc:	25060613          	addi	a2,a2,592 # ffffffffc020b508 <etext+0x106>
ffffffffc02002c0:	04e00593          	li	a1,78
ffffffffc02002c4:	0000b517          	auipc	a0,0xb
ffffffffc02002c8:	25c50513          	addi	a0,a0,604 # ffffffffc020b520 <etext+0x11e>
ffffffffc02002cc:	e406                	sd	ra,8(sp)
ffffffffc02002ce:	17c000ef          	jal	ffffffffc020044a <__panic>

ffffffffc02002d2 <mon_help>:
ffffffffc02002d2:	1101                	addi	sp,sp,-32
ffffffffc02002d4:	e822                	sd	s0,16(sp)
ffffffffc02002d6:	e426                	sd	s1,8(sp)
ffffffffc02002d8:	ec06                	sd	ra,24(sp)
ffffffffc02002da:	0000e417          	auipc	s0,0xe
ffffffffc02002de:	63640413          	addi	s0,s0,1590 # ffffffffc020e910 <commands>
ffffffffc02002e2:	0000e497          	auipc	s1,0xe
ffffffffc02002e6:	67648493          	addi	s1,s1,1654 # ffffffffc020e958 <commands+0x48>
ffffffffc02002ea:	6410                	ld	a2,8(s0)
ffffffffc02002ec:	600c                	ld	a1,0(s0)
ffffffffc02002ee:	0000b517          	auipc	a0,0xb
ffffffffc02002f2:	24a50513          	addi	a0,a0,586 # ffffffffc020b538 <etext+0x136>
ffffffffc02002f6:	0461                	addi	s0,s0,24
ffffffffc02002f8:	eafff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02002fc:	fe9417e3          	bne	s0,s1,ffffffffc02002ea <mon_help+0x18>
ffffffffc0200300:	60e2                	ld	ra,24(sp)
ffffffffc0200302:	6442                	ld	s0,16(sp)
ffffffffc0200304:	64a2                	ld	s1,8(sp)
ffffffffc0200306:	4501                	li	a0,0
ffffffffc0200308:	6105                	addi	sp,sp,32
ffffffffc020030a:	8082                	ret

ffffffffc020030c <mon_kerninfo>:
ffffffffc020030c:	1141                	addi	sp,sp,-16
ffffffffc020030e:	e406                	sd	ra,8(sp)
ffffffffc0200310:	f1bff0ef          	jal	ffffffffc020022a <print_kerninfo>
ffffffffc0200314:	60a2                	ld	ra,8(sp)
ffffffffc0200316:	4501                	li	a0,0
ffffffffc0200318:	0141                	addi	sp,sp,16
ffffffffc020031a:	8082                	ret

ffffffffc020031c <mon_backtrace>:
ffffffffc020031c:	1141                	addi	sp,sp,-16
ffffffffc020031e:	e406                	sd	ra,8(sp)
ffffffffc0200320:	f97ff0ef          	jal	ffffffffc02002b6 <print_stackframe>
ffffffffc0200324:	60a2                	ld	ra,8(sp)
ffffffffc0200326:	4501                	li	a0,0
ffffffffc0200328:	0141                	addi	sp,sp,16
ffffffffc020032a:	8082                	ret

ffffffffc020032c <kmonitor>:
ffffffffc020032c:	7131                	addi	sp,sp,-192
ffffffffc020032e:	e952                	sd	s4,144(sp)
ffffffffc0200330:	8a2a                	mv	s4,a0
ffffffffc0200332:	0000b517          	auipc	a0,0xb
ffffffffc0200336:	21650513          	addi	a0,a0,534 # ffffffffc020b548 <etext+0x146>
ffffffffc020033a:	fd06                	sd	ra,184(sp)
ffffffffc020033c:	f922                	sd	s0,176(sp)
ffffffffc020033e:	f526                	sd	s1,168(sp)
ffffffffc0200340:	ed4e                	sd	s3,152(sp)
ffffffffc0200342:	e556                	sd	s5,136(sp)
ffffffffc0200344:	e15a                	sd	s6,128(sp)
ffffffffc0200346:	e61ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020034a:	0000b517          	auipc	a0,0xb
ffffffffc020034e:	22650513          	addi	a0,a0,550 # ffffffffc020b570 <etext+0x16e>
ffffffffc0200352:	e55ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200356:	000a0563          	beqz	s4,ffffffffc0200360 <kmonitor+0x34>
ffffffffc020035a:	8552                	mv	a0,s4
ffffffffc020035c:	3b5000ef          	jal	ffffffffc0200f10 <print_trapframe>
ffffffffc0200360:	0000ea97          	auipc	s5,0xe
ffffffffc0200364:	5b0a8a93          	addi	s5,s5,1456 # ffffffffc020e910 <commands>
ffffffffc0200368:	49bd                	li	s3,15
ffffffffc020036a:	0000b517          	auipc	a0,0xb
ffffffffc020036e:	22e50513          	addi	a0,a0,558 # ffffffffc020b598 <etext+0x196>
ffffffffc0200372:	d41ff0ef          	jal	ffffffffc02000b2 <readline>
ffffffffc0200376:	842a                	mv	s0,a0
ffffffffc0200378:	d96d                	beqz	a0,ffffffffc020036a <kmonitor+0x3e>
ffffffffc020037a:	00054583          	lbu	a1,0(a0)
ffffffffc020037e:	4481                	li	s1,0
ffffffffc0200380:	e99d                	bnez	a1,ffffffffc02003b6 <kmonitor+0x8a>
ffffffffc0200382:	8b26                	mv	s6,s1
ffffffffc0200384:	fe0b03e3          	beqz	s6,ffffffffc020036a <kmonitor+0x3e>
ffffffffc0200388:	0000e497          	auipc	s1,0xe
ffffffffc020038c:	58848493          	addi	s1,s1,1416 # ffffffffc020e910 <commands>
ffffffffc0200390:	4401                	li	s0,0
ffffffffc0200392:	6582                	ld	a1,0(sp)
ffffffffc0200394:	6088                	ld	a0,0(s1)
ffffffffc0200396:	7970a0ef          	jal	ffffffffc020b32c <strcmp>
ffffffffc020039a:	478d                	li	a5,3
ffffffffc020039c:	c149                	beqz	a0,ffffffffc020041e <kmonitor+0xf2>
ffffffffc020039e:	2405                	addiw	s0,s0,1
ffffffffc02003a0:	04e1                	addi	s1,s1,24
ffffffffc02003a2:	fef418e3          	bne	s0,a5,ffffffffc0200392 <kmonitor+0x66>
ffffffffc02003a6:	6582                	ld	a1,0(sp)
ffffffffc02003a8:	0000b517          	auipc	a0,0xb
ffffffffc02003ac:	22050513          	addi	a0,a0,544 # ffffffffc020b5c8 <etext+0x1c6>
ffffffffc02003b0:	df7ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02003b4:	bf5d                	j	ffffffffc020036a <kmonitor+0x3e>
ffffffffc02003b6:	0000b517          	auipc	a0,0xb
ffffffffc02003ba:	1ea50513          	addi	a0,a0,490 # ffffffffc020b5a0 <etext+0x19e>
ffffffffc02003be:	7cb0a0ef          	jal	ffffffffc020b388 <strchr>
ffffffffc02003c2:	c901                	beqz	a0,ffffffffc02003d2 <kmonitor+0xa6>
ffffffffc02003c4:	00144583          	lbu	a1,1(s0)
ffffffffc02003c8:	00040023          	sb	zero,0(s0)
ffffffffc02003cc:	0405                	addi	s0,s0,1
ffffffffc02003ce:	d9d5                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc02003d0:	b7dd                	j	ffffffffc02003b6 <kmonitor+0x8a>
ffffffffc02003d2:	00044783          	lbu	a5,0(s0)
ffffffffc02003d6:	d7d5                	beqz	a5,ffffffffc0200382 <kmonitor+0x56>
ffffffffc02003d8:	03348b63          	beq	s1,s3,ffffffffc020040e <kmonitor+0xe2>
ffffffffc02003dc:	00349793          	slli	a5,s1,0x3
ffffffffc02003e0:	978a                	add	a5,a5,sp
ffffffffc02003e2:	e380                	sd	s0,0(a5)
ffffffffc02003e4:	00044583          	lbu	a1,0(s0)
ffffffffc02003e8:	2485                	addiw	s1,s1,1
ffffffffc02003ea:	8b26                	mv	s6,s1
ffffffffc02003ec:	e591                	bnez	a1,ffffffffc02003f8 <kmonitor+0xcc>
ffffffffc02003ee:	bf59                	j	ffffffffc0200384 <kmonitor+0x58>
ffffffffc02003f0:	00144583          	lbu	a1,1(s0)
ffffffffc02003f4:	0405                	addi	s0,s0,1
ffffffffc02003f6:	d5d1                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc02003f8:	0000b517          	auipc	a0,0xb
ffffffffc02003fc:	1a850513          	addi	a0,a0,424 # ffffffffc020b5a0 <etext+0x19e>
ffffffffc0200400:	7890a0ef          	jal	ffffffffc020b388 <strchr>
ffffffffc0200404:	d575                	beqz	a0,ffffffffc02003f0 <kmonitor+0xc4>
ffffffffc0200406:	00044583          	lbu	a1,0(s0)
ffffffffc020040a:	dda5                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc020040c:	b76d                	j	ffffffffc02003b6 <kmonitor+0x8a>
ffffffffc020040e:	45c1                	li	a1,16
ffffffffc0200410:	0000b517          	auipc	a0,0xb
ffffffffc0200414:	19850513          	addi	a0,a0,408 # ffffffffc020b5a8 <etext+0x1a6>
ffffffffc0200418:	d8fff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020041c:	b7c1                	j	ffffffffc02003dc <kmonitor+0xb0>
ffffffffc020041e:	00141793          	slli	a5,s0,0x1
ffffffffc0200422:	97a2                	add	a5,a5,s0
ffffffffc0200424:	078e                	slli	a5,a5,0x3
ffffffffc0200426:	97d6                	add	a5,a5,s5
ffffffffc0200428:	6b9c                	ld	a5,16(a5)
ffffffffc020042a:	fffb051b          	addiw	a0,s6,-1
ffffffffc020042e:	8652                	mv	a2,s4
ffffffffc0200430:	002c                	addi	a1,sp,8
ffffffffc0200432:	9782                	jalr	a5
ffffffffc0200434:	f2055be3          	bgez	a0,ffffffffc020036a <kmonitor+0x3e>
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
ffffffffc020044a:	00096317          	auipc	t1,0x96
ffffffffc020044e:	41e33303          	ld	t1,1054(t1) # ffffffffc0296868 <is_panic>
ffffffffc0200452:	715d                	addi	sp,sp,-80
ffffffffc0200454:	ec06                	sd	ra,24(sp)
ffffffffc0200456:	f436                	sd	a3,40(sp)
ffffffffc0200458:	f83a                	sd	a4,48(sp)
ffffffffc020045a:	fc3e                	sd	a5,56(sp)
ffffffffc020045c:	e0c2                	sd	a6,64(sp)
ffffffffc020045e:	e4c6                	sd	a7,72(sp)
ffffffffc0200460:	02031e63          	bnez	t1,ffffffffc020049c <__panic+0x52>
ffffffffc0200464:	4705                	li	a4,1
ffffffffc0200466:	103c                	addi	a5,sp,40
ffffffffc0200468:	e822                	sd	s0,16(sp)
ffffffffc020046a:	8432                	mv	s0,a2
ffffffffc020046c:	862e                	mv	a2,a1
ffffffffc020046e:	85aa                	mv	a1,a0
ffffffffc0200470:	0000b517          	auipc	a0,0xb
ffffffffc0200474:	20050513          	addi	a0,a0,512 # ffffffffc020b670 <etext+0x26e>
ffffffffc0200478:	00096697          	auipc	a3,0x96
ffffffffc020047c:	3ee6b823          	sd	a4,1008(a3) # ffffffffc0296868 <is_panic>
ffffffffc0200480:	e43e                	sd	a5,8(sp)
ffffffffc0200482:	d25ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200486:	65a2                	ld	a1,8(sp)
ffffffffc0200488:	8522                	mv	a0,s0
ffffffffc020048a:	cf7ff0ef          	jal	ffffffffc0200180 <vcprintf>
ffffffffc020048e:	0000b517          	auipc	a0,0xb
ffffffffc0200492:	20250513          	addi	a0,a0,514 # ffffffffc020b690 <etext+0x28e>
ffffffffc0200496:	d11ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020049a:	6442                	ld	s0,16(sp)
ffffffffc020049c:	4501                	li	a0,0
ffffffffc020049e:	4581                	li	a1,0
ffffffffc02004a0:	4601                	li	a2,0
ffffffffc02004a2:	48a1                	li	a7,8
ffffffffc02004a4:	00000073          	ecall
ffffffffc02004a8:	754000ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc02004ac:	4501                	li	a0,0
ffffffffc02004ae:	e7fff0ef          	jal	ffffffffc020032c <kmonitor>
ffffffffc02004b2:	bfed                	j	ffffffffc02004ac <__panic+0x62>

ffffffffc02004b4 <__warn>:
ffffffffc02004b4:	715d                	addi	sp,sp,-80
ffffffffc02004b6:	e822                	sd	s0,16(sp)
ffffffffc02004b8:	02810313          	addi	t1,sp,40
ffffffffc02004bc:	8432                	mv	s0,a2
ffffffffc02004be:	862e                	mv	a2,a1
ffffffffc02004c0:	85aa                	mv	a1,a0
ffffffffc02004c2:	0000b517          	auipc	a0,0xb
ffffffffc02004c6:	1d650513          	addi	a0,a0,470 # ffffffffc020b698 <etext+0x296>
ffffffffc02004ca:	ec06                	sd	ra,24(sp)
ffffffffc02004cc:	f436                	sd	a3,40(sp)
ffffffffc02004ce:	f83a                	sd	a4,48(sp)
ffffffffc02004d0:	fc3e                	sd	a5,56(sp)
ffffffffc02004d2:	e0c2                	sd	a6,64(sp)
ffffffffc02004d4:	e4c6                	sd	a7,72(sp)
ffffffffc02004d6:	e41a                	sd	t1,8(sp)
ffffffffc02004d8:	ccfff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02004dc:	65a2                	ld	a1,8(sp)
ffffffffc02004de:	8522                	mv	a0,s0
ffffffffc02004e0:	ca1ff0ef          	jal	ffffffffc0200180 <vcprintf>
ffffffffc02004e4:	0000b517          	auipc	a0,0xb
ffffffffc02004e8:	1ac50513          	addi	a0,a0,428 # ffffffffc020b690 <etext+0x28e>
ffffffffc02004ec:	cbbff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02004f0:	60e2                	ld	ra,24(sp)
ffffffffc02004f2:	6442                	ld	s0,16(sp)
ffffffffc02004f4:	6161                	addi	sp,sp,80
ffffffffc02004f6:	8082                	ret

ffffffffc02004f8 <clock_init>:
ffffffffc02004f8:	02000793          	li	a5,32
ffffffffc02004fc:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc0200500:	c0102573          	rdtime	a0
ffffffffc0200504:	67e1                	lui	a5,0x18
ffffffffc0200506:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc020050a:	953e                	add	a0,a0,a5
ffffffffc020050c:	4581                	li	a1,0
ffffffffc020050e:	4601                	li	a2,0
ffffffffc0200510:	4881                	li	a7,0
ffffffffc0200512:	00000073          	ecall
ffffffffc0200516:	0000b517          	auipc	a0,0xb
ffffffffc020051a:	1a250513          	addi	a0,a0,418 # ffffffffc020b6b8 <etext+0x2b6>
ffffffffc020051e:	00096797          	auipc	a5,0x96
ffffffffc0200522:	3407b923          	sd	zero,850(a5) # ffffffffc0296870 <ticks>
ffffffffc0200526:	b141                	j	ffffffffc02001a6 <cprintf>

ffffffffc0200528 <clock_set_next_event>:
ffffffffc0200528:	c0102573          	rdtime	a0
ffffffffc020052c:	67e1                	lui	a5,0x18
ffffffffc020052e:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc0200532:	953e                	add	a0,a0,a5
ffffffffc0200534:	4581                	li	a1,0
ffffffffc0200536:	4601                	li	a2,0
ffffffffc0200538:	4881                	li	a7,0
ffffffffc020053a:	00000073          	ecall
ffffffffc020053e:	8082                	ret

ffffffffc0200540 <cons_init>:
ffffffffc0200540:	4501                	li	a0,0
ffffffffc0200542:	4581                	li	a1,0
ffffffffc0200544:	4601                	li	a2,0
ffffffffc0200546:	4889                	li	a7,2
ffffffffc0200548:	00000073          	ecall
ffffffffc020054c:	8082                	ret

ffffffffc020054e <cons_putc>:
ffffffffc020054e:	1101                	addi	sp,sp,-32
ffffffffc0200550:	ec06                	sd	ra,24(sp)
ffffffffc0200552:	100027f3          	csrr	a5,sstatus
ffffffffc0200556:	8b89                	andi	a5,a5,2
ffffffffc0200558:	ef95                	bnez	a5,ffffffffc0200594 <cons_putc+0x46>
ffffffffc020055a:	47a1                	li	a5,8
ffffffffc020055c:	00f50a63          	beq	a0,a5,ffffffffc0200570 <cons_putc+0x22>
ffffffffc0200560:	4581                	li	a1,0
ffffffffc0200562:	4601                	li	a2,0
ffffffffc0200564:	4885                	li	a7,1
ffffffffc0200566:	00000073          	ecall
ffffffffc020056a:	60e2                	ld	ra,24(sp)
ffffffffc020056c:	6105                	addi	sp,sp,32
ffffffffc020056e:	8082                	ret
ffffffffc0200570:	4781                	li	a5,0
ffffffffc0200572:	4521                	li	a0,8
ffffffffc0200574:	4581                	li	a1,0
ffffffffc0200576:	4601                	li	a2,0
ffffffffc0200578:	4885                	li	a7,1
ffffffffc020057a:	00000073          	ecall
ffffffffc020057e:	02000513          	li	a0,32
ffffffffc0200582:	00000073          	ecall
ffffffffc0200586:	4521                	li	a0,8
ffffffffc0200588:	00000073          	ecall
ffffffffc020058c:	dff9                	beqz	a5,ffffffffc020056a <cons_putc+0x1c>
ffffffffc020058e:	60e2                	ld	ra,24(sp)
ffffffffc0200590:	6105                	addi	sp,sp,32
ffffffffc0200592:	a595                	j	ffffffffc0200bf6 <intr_enable>
ffffffffc0200594:	e42a                	sd	a0,8(sp)
ffffffffc0200596:	666000ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc020059a:	6522                	ld	a0,8(sp)
ffffffffc020059c:	47a1                	li	a5,8
ffffffffc020059e:	00f50a63          	beq	a0,a5,ffffffffc02005b2 <cons_putc+0x64>
ffffffffc02005a2:	4581                	li	a1,0
ffffffffc02005a4:	4601                	li	a2,0
ffffffffc02005a6:	4885                	li	a7,1
ffffffffc02005a8:	00000073          	ecall
ffffffffc02005ac:	60e2                	ld	ra,24(sp)
ffffffffc02005ae:	6105                	addi	sp,sp,32
ffffffffc02005b0:	a599                	j	ffffffffc0200bf6 <intr_enable>
ffffffffc02005b2:	4785                	li	a5,1
ffffffffc02005b4:	bf7d                	j	ffffffffc0200572 <cons_putc+0x24>

ffffffffc02005b6 <cons_getc>:
ffffffffc02005b6:	7179                	addi	sp,sp,-48
ffffffffc02005b8:	f406                	sd	ra,40(sp)
ffffffffc02005ba:	f022                	sd	s0,32(sp)
ffffffffc02005bc:	ec26                	sd	s1,24(sp)
ffffffffc02005be:	e84a                	sd	s2,16(sp)
ffffffffc02005c0:	100027f3          	csrr	a5,sstatus
ffffffffc02005c4:	8b89                	andi	a5,a5,2
ffffffffc02005c6:	4901                	li	s2,0
ffffffffc02005c8:	e7e9                	bnez	a5,ffffffffc0200692 <cons_getc+0xdc>
ffffffffc02005ca:	00091497          	auipc	s1,0x91
ffffffffc02005ce:	e9648493          	addi	s1,s1,-362 # ffffffffc0291460 <cons>
ffffffffc02005d2:	07f00413          	li	s0,127
ffffffffc02005d6:	4501                	li	a0,0
ffffffffc02005d8:	4581                	li	a1,0
ffffffffc02005da:	4601                	li	a2,0
ffffffffc02005dc:	4889                	li	a7,2
ffffffffc02005de:	00000073          	ecall
ffffffffc02005e2:	0005079b          	sext.w	a5,a0
ffffffffc02005e6:	0407c663          	bltz	a5,ffffffffc0200632 <cons_getc+0x7c>
ffffffffc02005ea:	04878263          	beq	a5,s0,ffffffffc020062e <cons_getc+0x78>
ffffffffc02005ee:	0ff57513          	zext.b	a0,a0
ffffffffc02005f2:	d3f5                	beqz	a5,ffffffffc02005d6 <cons_getc+0x20>
ffffffffc02005f4:	00091797          	auipc	a5,0x91
ffffffffc02005f8:	0707a783          	lw	a5,112(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc02005fc:	02079713          	slli	a4,a5,0x20
ffffffffc0200600:	9301                	srli	a4,a4,0x20
ffffffffc0200602:	2785                	addiw	a5,a5,1
ffffffffc0200604:	20f4a223          	sw	a5,516(s1)
ffffffffc0200608:	00e487b3          	add	a5,s1,a4
ffffffffc020060c:	00a78023          	sb	a0,0(a5)
ffffffffc0200610:	402080ef          	jal	ffffffffc0208a12 <dev_stdin_write>
ffffffffc0200614:	00091717          	auipc	a4,0x91
ffffffffc0200618:	05072703          	lw	a4,80(a4) # ffffffffc0291664 <cons+0x204>
ffffffffc020061c:	20000793          	li	a5,512
ffffffffc0200620:	faf71be3          	bne	a4,a5,ffffffffc02005d6 <cons_getc+0x20>
ffffffffc0200624:	00091797          	auipc	a5,0x91
ffffffffc0200628:	0407a023          	sw	zero,64(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc020062c:	b76d                	j	ffffffffc02005d6 <cons_getc+0x20>
ffffffffc020062e:	4521                	li	a0,8
ffffffffc0200630:	b7d1                	j	ffffffffc02005f4 <cons_getc+0x3e>
ffffffffc0200632:	00091797          	auipc	a5,0x91
ffffffffc0200636:	02e7a783          	lw	a5,46(a5) # ffffffffc0291660 <cons+0x200>
ffffffffc020063a:	00091717          	auipc	a4,0x91
ffffffffc020063e:	02a72703          	lw	a4,42(a4) # ffffffffc0291664 <cons+0x204>
ffffffffc0200642:	4501                	li	a0,0
ffffffffc0200644:	00f70f63          	beq	a4,a5,ffffffffc0200662 <cons_getc+0xac>
ffffffffc0200648:	02079713          	slli	a4,a5,0x20
ffffffffc020064c:	9301                	srli	a4,a4,0x20
ffffffffc020064e:	2785                	addiw	a5,a5,1
ffffffffc0200650:	20f4a023          	sw	a5,512(s1)
ffffffffc0200654:	94ba                	add	s1,s1,a4
ffffffffc0200656:	20000713          	li	a4,512
ffffffffc020065a:	0004c503          	lbu	a0,0(s1)
ffffffffc020065e:	00e78a63          	beq	a5,a4,ffffffffc0200672 <cons_getc+0xbc>
ffffffffc0200662:	00091e63          	bnez	s2,ffffffffc020067e <cons_getc+0xc8>
ffffffffc0200666:	70a2                	ld	ra,40(sp)
ffffffffc0200668:	7402                	ld	s0,32(sp)
ffffffffc020066a:	64e2                	ld	s1,24(sp)
ffffffffc020066c:	6942                	ld	s2,16(sp)
ffffffffc020066e:	6145                	addi	sp,sp,48
ffffffffc0200670:	8082                	ret
ffffffffc0200672:	00091797          	auipc	a5,0x91
ffffffffc0200676:	fe07a723          	sw	zero,-18(a5) # ffffffffc0291660 <cons+0x200>
ffffffffc020067a:	fe0906e3          	beqz	s2,ffffffffc0200666 <cons_getc+0xb0>
ffffffffc020067e:	e42a                	sd	a0,8(sp)
ffffffffc0200680:	576000ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc0200684:	70a2                	ld	ra,40(sp)
ffffffffc0200686:	7402                	ld	s0,32(sp)
ffffffffc0200688:	6522                	ld	a0,8(sp)
ffffffffc020068a:	64e2                	ld	s1,24(sp)
ffffffffc020068c:	6942                	ld	s2,16(sp)
ffffffffc020068e:	6145                	addi	sp,sp,48
ffffffffc0200690:	8082                	ret
ffffffffc0200692:	56a000ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0200696:	4905                	li	s2,1
ffffffffc0200698:	bf0d                	j	ffffffffc02005ca <cons_getc+0x14>

ffffffffc020069a <dtb_init>:
ffffffffc020069a:	7179                	addi	sp,sp,-48
ffffffffc020069c:	0000b517          	auipc	a0,0xb
ffffffffc02006a0:	03c50513          	addi	a0,a0,60 # ffffffffc020b6d8 <etext+0x2d6>
ffffffffc02006a4:	f406                	sd	ra,40(sp)
ffffffffc02006a6:	f022                	sd	s0,32(sp)
ffffffffc02006a8:	affff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02006ac:	00014597          	auipc	a1,0x14
ffffffffc02006b0:	9545b583          	ld	a1,-1708(a1) # ffffffffc0214000 <boot_hartid>
ffffffffc02006b4:	0000b517          	auipc	a0,0xb
ffffffffc02006b8:	03450513          	addi	a0,a0,52 # ffffffffc020b6e8 <etext+0x2e6>
ffffffffc02006bc:	00014417          	auipc	s0,0x14
ffffffffc02006c0:	94c40413          	addi	s0,s0,-1716 # ffffffffc0214008 <boot_dtb>
ffffffffc02006c4:	ae3ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02006c8:	600c                	ld	a1,0(s0)
ffffffffc02006ca:	0000b517          	auipc	a0,0xb
ffffffffc02006ce:	02e50513          	addi	a0,a0,46 # ffffffffc020b6f8 <etext+0x2f6>
ffffffffc02006d2:	ad5ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02006d6:	6018                	ld	a4,0(s0)
ffffffffc02006d8:	0000b517          	auipc	a0,0xb
ffffffffc02006dc:	03850513          	addi	a0,a0,56 # ffffffffc020b710 <etext+0x30e>
ffffffffc02006e0:	10070163          	beqz	a4,ffffffffc02007e2 <dtb_init+0x148>
ffffffffc02006e4:	57f5                	li	a5,-3
ffffffffc02006e6:	07fa                	slli	a5,a5,0x1e
ffffffffc02006e8:	973e                	add	a4,a4,a5
ffffffffc02006ea:	431c                	lw	a5,0(a4)
ffffffffc02006ec:	d00e06b7          	lui	a3,0xd00e0
ffffffffc02006f0:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfe495dd>
ffffffffc02006f4:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02006f8:	0187961b          	slliw	a2,a5,0x18
ffffffffc02006fc:	0187d51b          	srliw	a0,a5,0x18
ffffffffc0200700:	0ff5f593          	zext.b	a1,a1
ffffffffc0200704:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200708:	05c2                	slli	a1,a1,0x10
ffffffffc020070a:	8e49                	or	a2,a2,a0
ffffffffc020070c:	0ff7f793          	zext.b	a5,a5
ffffffffc0200710:	8dd1                	or	a1,a1,a2
ffffffffc0200712:	07a2                	slli	a5,a5,0x8
ffffffffc0200714:	8ddd                	or	a1,a1,a5
ffffffffc0200716:	00ff0837          	lui	a6,0xff0
ffffffffc020071a:	0cd59863          	bne	a1,a3,ffffffffc02007ea <dtb_init+0x150>
ffffffffc020071e:	4710                	lw	a2,8(a4)
ffffffffc0200720:	4754                	lw	a3,12(a4)
ffffffffc0200722:	e84a                	sd	s2,16(sp)
ffffffffc0200724:	0086541b          	srliw	s0,a2,0x8
ffffffffc0200728:	0086d79b          	srliw	a5,a3,0x8
ffffffffc020072c:	01865e1b          	srliw	t3,a2,0x18
ffffffffc0200730:	0186d89b          	srliw	a7,a3,0x18
ffffffffc0200734:	0186151b          	slliw	a0,a2,0x18
ffffffffc0200738:	0186959b          	slliw	a1,a3,0x18
ffffffffc020073c:	0104141b          	slliw	s0,s0,0x10
ffffffffc0200740:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200744:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200748:	0106d69b          	srliw	a3,a3,0x10
ffffffffc020074c:	01c56533          	or	a0,a0,t3
ffffffffc0200750:	0115e5b3          	or	a1,a1,a7
ffffffffc0200754:	01047433          	and	s0,s0,a6
ffffffffc0200758:	0ff67613          	zext.b	a2,a2
ffffffffc020075c:	0107f7b3          	and	a5,a5,a6
ffffffffc0200760:	0ff6f693          	zext.b	a3,a3
ffffffffc0200764:	8c49                	or	s0,s0,a0
ffffffffc0200766:	0622                	slli	a2,a2,0x8
ffffffffc0200768:	8fcd                	or	a5,a5,a1
ffffffffc020076a:	06a2                	slli	a3,a3,0x8
ffffffffc020076c:	8c51                	or	s0,s0,a2
ffffffffc020076e:	8fd5                	or	a5,a5,a3
ffffffffc0200770:	1402                	slli	s0,s0,0x20
ffffffffc0200772:	1782                	slli	a5,a5,0x20
ffffffffc0200774:	9001                	srli	s0,s0,0x20
ffffffffc0200776:	9381                	srli	a5,a5,0x20
ffffffffc0200778:	ec26                	sd	s1,24(sp)
ffffffffc020077a:	4301                	li	t1,0
ffffffffc020077c:	488d                	li	a7,3
ffffffffc020077e:	943a                	add	s0,s0,a4
ffffffffc0200780:	00e78933          	add	s2,a5,a4
ffffffffc0200784:	4e05                	li	t3,1
ffffffffc0200786:	4018                	lw	a4,0(s0)
ffffffffc0200788:	0087579b          	srliw	a5,a4,0x8
ffffffffc020078c:	0187169b          	slliw	a3,a4,0x18
ffffffffc0200790:	0187561b          	srliw	a2,a4,0x18
ffffffffc0200794:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200798:	0107571b          	srliw	a4,a4,0x10
ffffffffc020079c:	0107f7b3          	and	a5,a5,a6
ffffffffc02007a0:	8ed1                	or	a3,a3,a2
ffffffffc02007a2:	0ff77713          	zext.b	a4,a4
ffffffffc02007a6:	8fd5                	or	a5,a5,a3
ffffffffc02007a8:	0722                	slli	a4,a4,0x8
ffffffffc02007aa:	8fd9                	or	a5,a5,a4
ffffffffc02007ac:	05178763          	beq	a5,a7,ffffffffc02007fa <dtb_init+0x160>
ffffffffc02007b0:	0411                	addi	s0,s0,4
ffffffffc02007b2:	00f8e963          	bltu	a7,a5,ffffffffc02007c4 <dtb_init+0x12a>
ffffffffc02007b6:	07c78d63          	beq	a5,t3,ffffffffc0200830 <dtb_init+0x196>
ffffffffc02007ba:	4709                	li	a4,2
ffffffffc02007bc:	00e79763          	bne	a5,a4,ffffffffc02007ca <dtb_init+0x130>
ffffffffc02007c0:	4301                	li	t1,0
ffffffffc02007c2:	b7d1                	j	ffffffffc0200786 <dtb_init+0xec>
ffffffffc02007c4:	4711                	li	a4,4
ffffffffc02007c6:	fce780e3          	beq	a5,a4,ffffffffc0200786 <dtb_init+0xec>
ffffffffc02007ca:	0000b517          	auipc	a0,0xb
ffffffffc02007ce:	00e50513          	addi	a0,a0,14 # ffffffffc020b7d8 <etext+0x3d6>
ffffffffc02007d2:	9d5ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02007d6:	64e2                	ld	s1,24(sp)
ffffffffc02007d8:	6942                	ld	s2,16(sp)
ffffffffc02007da:	0000b517          	auipc	a0,0xb
ffffffffc02007de:	03650513          	addi	a0,a0,54 # ffffffffc020b810 <etext+0x40e>
ffffffffc02007e2:	7402                	ld	s0,32(sp)
ffffffffc02007e4:	70a2                	ld	ra,40(sp)
ffffffffc02007e6:	6145                	addi	sp,sp,48
ffffffffc02007e8:	ba7d                	j	ffffffffc02001a6 <cprintf>
ffffffffc02007ea:	7402                	ld	s0,32(sp)
ffffffffc02007ec:	70a2                	ld	ra,40(sp)
ffffffffc02007ee:	0000b517          	auipc	a0,0xb
ffffffffc02007f2:	f4250513          	addi	a0,a0,-190 # ffffffffc020b730 <etext+0x32e>
ffffffffc02007f6:	6145                	addi	sp,sp,48
ffffffffc02007f8:	b27d                	j	ffffffffc02001a6 <cprintf>
ffffffffc02007fa:	4058                	lw	a4,4(s0)
ffffffffc02007fc:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200800:	0187169b          	slliw	a3,a4,0x18
ffffffffc0200804:	0187561b          	srliw	a2,a4,0x18
ffffffffc0200808:	0107979b          	slliw	a5,a5,0x10
ffffffffc020080c:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200810:	0107f7b3          	and	a5,a5,a6
ffffffffc0200814:	8ed1                	or	a3,a3,a2
ffffffffc0200816:	0ff77713          	zext.b	a4,a4
ffffffffc020081a:	8fd5                	or	a5,a5,a3
ffffffffc020081c:	0722                	slli	a4,a4,0x8
ffffffffc020081e:	8fd9                	or	a5,a5,a4
ffffffffc0200820:	04031463          	bnez	t1,ffffffffc0200868 <dtb_init+0x1ce>
ffffffffc0200824:	1782                	slli	a5,a5,0x20
ffffffffc0200826:	9381                	srli	a5,a5,0x20
ffffffffc0200828:	043d                	addi	s0,s0,15
ffffffffc020082a:	943e                	add	s0,s0,a5
ffffffffc020082c:	9871                	andi	s0,s0,-4
ffffffffc020082e:	bfa1                	j	ffffffffc0200786 <dtb_init+0xec>
ffffffffc0200830:	8522                	mv	a0,s0
ffffffffc0200832:	e01a                	sd	t1,0(sp)
ffffffffc0200834:	2b30a0ef          	jal	ffffffffc020b2e6 <strlen>
ffffffffc0200838:	84aa                	mv	s1,a0
ffffffffc020083a:	4619                	li	a2,6
ffffffffc020083c:	8522                	mv	a0,s0
ffffffffc020083e:	0000b597          	auipc	a1,0xb
ffffffffc0200842:	f1a58593          	addi	a1,a1,-230 # ffffffffc020b758 <etext+0x356>
ffffffffc0200846:	31b0a0ef          	jal	ffffffffc020b360 <strncmp>
ffffffffc020084a:	6302                	ld	t1,0(sp)
ffffffffc020084c:	0411                	addi	s0,s0,4
ffffffffc020084e:	0004879b          	sext.w	a5,s1
ffffffffc0200852:	943e                	add	s0,s0,a5
ffffffffc0200854:	00153513          	seqz	a0,a0
ffffffffc0200858:	9871                	andi	s0,s0,-4
ffffffffc020085a:	00a36333          	or	t1,t1,a0
ffffffffc020085e:	00ff0837          	lui	a6,0xff0
ffffffffc0200862:	488d                	li	a7,3
ffffffffc0200864:	4e05                	li	t3,1
ffffffffc0200866:	b705                	j	ffffffffc0200786 <dtb_init+0xec>
ffffffffc0200868:	4418                	lw	a4,8(s0)
ffffffffc020086a:	0000b597          	auipc	a1,0xb
ffffffffc020086e:	ef658593          	addi	a1,a1,-266 # ffffffffc020b760 <etext+0x35e>
ffffffffc0200872:	e43e                	sd	a5,8(sp)
ffffffffc0200874:	0087551b          	srliw	a0,a4,0x8
ffffffffc0200878:	0187561b          	srliw	a2,a4,0x18
ffffffffc020087c:	0187169b          	slliw	a3,a4,0x18
ffffffffc0200880:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200884:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200888:	01057533          	and	a0,a0,a6
ffffffffc020088c:	8ed1                	or	a3,a3,a2
ffffffffc020088e:	0ff77713          	zext.b	a4,a4
ffffffffc0200892:	0722                	slli	a4,a4,0x8
ffffffffc0200894:	8d55                	or	a0,a0,a3
ffffffffc0200896:	8d59                	or	a0,a0,a4
ffffffffc0200898:	1502                	slli	a0,a0,0x20
ffffffffc020089a:	9101                	srli	a0,a0,0x20
ffffffffc020089c:	954a                	add	a0,a0,s2
ffffffffc020089e:	e01a                	sd	t1,0(sp)
ffffffffc02008a0:	28d0a0ef          	jal	ffffffffc020b32c <strcmp>
ffffffffc02008a4:	67a2                	ld	a5,8(sp)
ffffffffc02008a6:	473d                	li	a4,15
ffffffffc02008a8:	6302                	ld	t1,0(sp)
ffffffffc02008aa:	00ff0837          	lui	a6,0xff0
ffffffffc02008ae:	488d                	li	a7,3
ffffffffc02008b0:	4e05                	li	t3,1
ffffffffc02008b2:	f6f779e3          	bgeu	a4,a5,ffffffffc0200824 <dtb_init+0x18a>
ffffffffc02008b6:	f53d                	bnez	a0,ffffffffc0200824 <dtb_init+0x18a>
ffffffffc02008b8:	00c43683          	ld	a3,12(s0)
ffffffffc02008bc:	01443703          	ld	a4,20(s0)
ffffffffc02008c0:	0000b517          	auipc	a0,0xb
ffffffffc02008c4:	ea850513          	addi	a0,a0,-344 # ffffffffc020b768 <etext+0x366>
ffffffffc02008c8:	4206d793          	srai	a5,a3,0x20
ffffffffc02008cc:	0087d31b          	srliw	t1,a5,0x8
ffffffffc02008d0:	00871f93          	slli	t6,a4,0x8
ffffffffc02008d4:	42075893          	srai	a7,a4,0x20
ffffffffc02008d8:	0187df1b          	srliw	t5,a5,0x18
ffffffffc02008dc:	0187959b          	slliw	a1,a5,0x18
ffffffffc02008e0:	0103131b          	slliw	t1,t1,0x10
ffffffffc02008e4:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02008e8:	420fd613          	srai	a2,t6,0x20
ffffffffc02008ec:	0188de9b          	srliw	t4,a7,0x18
ffffffffc02008f0:	01037333          	and	t1,t1,a6
ffffffffc02008f4:	01889e1b          	slliw	t3,a7,0x18
ffffffffc02008f8:	01e5e5b3          	or	a1,a1,t5
ffffffffc02008fc:	0ff7f793          	zext.b	a5,a5
ffffffffc0200900:	01de6e33          	or	t3,t3,t4
ffffffffc0200904:	0065e5b3          	or	a1,a1,t1
ffffffffc0200908:	01067633          	and	a2,a2,a6
ffffffffc020090c:	0086d31b          	srliw	t1,a3,0x8
ffffffffc0200910:	0087541b          	srliw	s0,a4,0x8
ffffffffc0200914:	07a2                	slli	a5,a5,0x8
ffffffffc0200916:	0108d89b          	srliw	a7,a7,0x10
ffffffffc020091a:	0186df1b          	srliw	t5,a3,0x18
ffffffffc020091e:	01875e9b          	srliw	t4,a4,0x18
ffffffffc0200922:	8ddd                	or	a1,a1,a5
ffffffffc0200924:	01c66633          	or	a2,a2,t3
ffffffffc0200928:	0186979b          	slliw	a5,a3,0x18
ffffffffc020092c:	01871e1b          	slliw	t3,a4,0x18
ffffffffc0200930:	0ff8f893          	zext.b	a7,a7
ffffffffc0200934:	0103131b          	slliw	t1,t1,0x10
ffffffffc0200938:	0106d69b          	srliw	a3,a3,0x10
ffffffffc020093c:	0104141b          	slliw	s0,s0,0x10
ffffffffc0200940:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200944:	01037333          	and	t1,t1,a6
ffffffffc0200948:	08a2                	slli	a7,a7,0x8
ffffffffc020094a:	01e7e7b3          	or	a5,a5,t5
ffffffffc020094e:	01047433          	and	s0,s0,a6
ffffffffc0200952:	0ff6f693          	zext.b	a3,a3
ffffffffc0200956:	01de6833          	or	a6,t3,t4
ffffffffc020095a:	0ff77713          	zext.b	a4,a4
ffffffffc020095e:	01166633          	or	a2,a2,a7
ffffffffc0200962:	0067e7b3          	or	a5,a5,t1
ffffffffc0200966:	06a2                	slli	a3,a3,0x8
ffffffffc0200968:	01046433          	or	s0,s0,a6
ffffffffc020096c:	0722                	slli	a4,a4,0x8
ffffffffc020096e:	8fd5                	or	a5,a5,a3
ffffffffc0200970:	8c59                	or	s0,s0,a4
ffffffffc0200972:	1582                	slli	a1,a1,0x20
ffffffffc0200974:	1602                	slli	a2,a2,0x20
ffffffffc0200976:	1782                	slli	a5,a5,0x20
ffffffffc0200978:	9201                	srli	a2,a2,0x20
ffffffffc020097a:	9181                	srli	a1,a1,0x20
ffffffffc020097c:	1402                	slli	s0,s0,0x20
ffffffffc020097e:	00b7e4b3          	or	s1,a5,a1
ffffffffc0200982:	8c51                	or	s0,s0,a2
ffffffffc0200984:	823ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200988:	85a6                	mv	a1,s1
ffffffffc020098a:	0000b517          	auipc	a0,0xb
ffffffffc020098e:	dfe50513          	addi	a0,a0,-514 # ffffffffc020b788 <etext+0x386>
ffffffffc0200992:	815ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200996:	01445613          	srli	a2,s0,0x14
ffffffffc020099a:	85a2                	mv	a1,s0
ffffffffc020099c:	0000b517          	auipc	a0,0xb
ffffffffc02009a0:	e0450513          	addi	a0,a0,-508 # ffffffffc020b7a0 <etext+0x39e>
ffffffffc02009a4:	803ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02009a8:	009405b3          	add	a1,s0,s1
ffffffffc02009ac:	15fd                	addi	a1,a1,-1
ffffffffc02009ae:	0000b517          	auipc	a0,0xb
ffffffffc02009b2:	e1250513          	addi	a0,a0,-494 # ffffffffc020b7c0 <etext+0x3be>
ffffffffc02009b6:	ff0ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02009ba:	00096797          	auipc	a5,0x96
ffffffffc02009be:	ec97b323          	sd	s1,-314(a5) # ffffffffc0296880 <memory_base>
ffffffffc02009c2:	00096797          	auipc	a5,0x96
ffffffffc02009c6:	ea87bb23          	sd	s0,-330(a5) # ffffffffc0296878 <memory_size>
ffffffffc02009ca:	b531                	j	ffffffffc02007d6 <dtb_init+0x13c>

ffffffffc02009cc <get_memory_base>:
ffffffffc02009cc:	00096517          	auipc	a0,0x96
ffffffffc02009d0:	eb453503          	ld	a0,-332(a0) # ffffffffc0296880 <memory_base>
ffffffffc02009d4:	8082                	ret

ffffffffc02009d6 <get_memory_size>:
ffffffffc02009d6:	00096517          	auipc	a0,0x96
ffffffffc02009da:	ea253503          	ld	a0,-350(a0) # ffffffffc0296878 <memory_size>
ffffffffc02009de:	8082                	ret

ffffffffc02009e0 <ide_init>:
ffffffffc02009e0:	1141                	addi	sp,sp,-16
ffffffffc02009e2:	00091597          	auipc	a1,0x91
ffffffffc02009e6:	cd658593          	addi	a1,a1,-810 # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc02009ea:	4505                	li	a0,1
ffffffffc02009ec:	00091797          	auipc	a5,0x91
ffffffffc02009f0:	c607ae23          	sw	zero,-900(a5) # ffffffffc0291668 <ide_devices>
ffffffffc02009f4:	00091797          	auipc	a5,0x91
ffffffffc02009f8:	cc07a223          	sw	zero,-828(a5) # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc02009fc:	00091797          	auipc	a5,0x91
ffffffffc0200a00:	d007a623          	sw	zero,-756(a5) # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200a04:	00091797          	auipc	a5,0x91
ffffffffc0200a08:	d407aa23          	sw	zero,-684(a5) # ffffffffc0291758 <ide_devices+0xf0>
ffffffffc0200a0c:	e406                	sd	ra,8(sp)
ffffffffc0200a0e:	24c000ef          	jal	ffffffffc0200c5a <ramdisk_init>
ffffffffc0200a12:	00091797          	auipc	a5,0x91
ffffffffc0200a16:	ca67a783          	lw	a5,-858(a5) # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200a1a:	c385                	beqz	a5,ffffffffc0200a3a <ide_init+0x5a>
ffffffffc0200a1c:	00091597          	auipc	a1,0x91
ffffffffc0200a20:	cec58593          	addi	a1,a1,-788 # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200a24:	4509                	li	a0,2
ffffffffc0200a26:	234000ef          	jal	ffffffffc0200c5a <ramdisk_init>
ffffffffc0200a2a:	00091797          	auipc	a5,0x91
ffffffffc0200a2e:	cde7a783          	lw	a5,-802(a5) # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200a32:	c39d                	beqz	a5,ffffffffc0200a58 <ide_init+0x78>
ffffffffc0200a34:	60a2                	ld	ra,8(sp)
ffffffffc0200a36:	0141                	addi	sp,sp,16
ffffffffc0200a38:	8082                	ret
ffffffffc0200a3a:	0000b697          	auipc	a3,0xb
ffffffffc0200a3e:	dee68693          	addi	a3,a3,-530 # ffffffffc020b828 <etext+0x426>
ffffffffc0200a42:	0000b617          	auipc	a2,0xb
ffffffffc0200a46:	dfe60613          	addi	a2,a2,-514 # ffffffffc020b840 <etext+0x43e>
ffffffffc0200a4a:	45c5                	li	a1,17
ffffffffc0200a4c:	0000b517          	auipc	a0,0xb
ffffffffc0200a50:	e0c50513          	addi	a0,a0,-500 # ffffffffc020b858 <etext+0x456>
ffffffffc0200a54:	9f7ff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0200a58:	0000b697          	auipc	a3,0xb
ffffffffc0200a5c:	e1868693          	addi	a3,a3,-488 # ffffffffc020b870 <etext+0x46e>
ffffffffc0200a60:	0000b617          	auipc	a2,0xb
ffffffffc0200a64:	de060613          	addi	a2,a2,-544 # ffffffffc020b840 <etext+0x43e>
ffffffffc0200a68:	45d1                	li	a1,20
ffffffffc0200a6a:	0000b517          	auipc	a0,0xb
ffffffffc0200a6e:	dee50513          	addi	a0,a0,-530 # ffffffffc020b858 <etext+0x456>
ffffffffc0200a72:	9d9ff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200a76 <ide_device_valid>:
ffffffffc0200a76:	478d                	li	a5,3
ffffffffc0200a78:	00a7ef63          	bltu	a5,a0,ffffffffc0200a96 <ide_device_valid+0x20>
ffffffffc0200a7c:	00251793          	slli	a5,a0,0x2
ffffffffc0200a80:	97aa                	add	a5,a5,a0
ffffffffc0200a82:	00091717          	auipc	a4,0x91
ffffffffc0200a86:	be670713          	addi	a4,a4,-1050 # ffffffffc0291668 <ide_devices>
ffffffffc0200a8a:	0792                	slli	a5,a5,0x4
ffffffffc0200a8c:	97ba                	add	a5,a5,a4
ffffffffc0200a8e:	4388                	lw	a0,0(a5)
ffffffffc0200a90:	00a03533          	snez	a0,a0
ffffffffc0200a94:	8082                	ret
ffffffffc0200a96:	4501                	li	a0,0
ffffffffc0200a98:	8082                	ret

ffffffffc0200a9a <ide_device_size>:
ffffffffc0200a9a:	478d                	li	a5,3
ffffffffc0200a9c:	02a7e163          	bltu	a5,a0,ffffffffc0200abe <ide_device_size+0x24>
ffffffffc0200aa0:	00251793          	slli	a5,a0,0x2
ffffffffc0200aa4:	97aa                	add	a5,a5,a0
ffffffffc0200aa6:	00091717          	auipc	a4,0x91
ffffffffc0200aaa:	bc270713          	addi	a4,a4,-1086 # ffffffffc0291668 <ide_devices>
ffffffffc0200aae:	0792                	slli	a5,a5,0x4
ffffffffc0200ab0:	97ba                	add	a5,a5,a4
ffffffffc0200ab2:	4398                	lw	a4,0(a5)
ffffffffc0200ab4:	4501                	li	a0,0
ffffffffc0200ab6:	c709                	beqz	a4,ffffffffc0200ac0 <ide_device_size+0x26>
ffffffffc0200ab8:	0087e503          	lwu	a0,8(a5)
ffffffffc0200abc:	8082                	ret
ffffffffc0200abe:	4501                	li	a0,0
ffffffffc0200ac0:	8082                	ret

ffffffffc0200ac2 <ide_read_secs>:
ffffffffc0200ac2:	1141                	addi	sp,sp,-16
ffffffffc0200ac4:	e406                	sd	ra,8(sp)
ffffffffc0200ac6:	0816b793          	sltiu	a5,a3,129
ffffffffc0200aca:	cba9                	beqz	a5,ffffffffc0200b1c <ide_read_secs+0x5a>
ffffffffc0200acc:	478d                	li	a5,3
ffffffffc0200ace:	0005081b          	sext.w	a6,a0
ffffffffc0200ad2:	04a7e563          	bltu	a5,a0,ffffffffc0200b1c <ide_read_secs+0x5a>
ffffffffc0200ad6:	00281793          	slli	a5,a6,0x2
ffffffffc0200ada:	97c2                	add	a5,a5,a6
ffffffffc0200adc:	0792                	slli	a5,a5,0x4
ffffffffc0200ade:	00091817          	auipc	a6,0x91
ffffffffc0200ae2:	b8a80813          	addi	a6,a6,-1142 # ffffffffc0291668 <ide_devices>
ffffffffc0200ae6:	97c2                	add	a5,a5,a6
ffffffffc0200ae8:	0007a883          	lw	a7,0(a5)
ffffffffc0200aec:	02088863          	beqz	a7,ffffffffc0200b1c <ide_read_secs+0x5a>
ffffffffc0200af0:	100008b7          	lui	a7,0x10000
ffffffffc0200af4:	0515f463          	bgeu	a1,a7,ffffffffc0200b3c <ide_read_secs+0x7a>
ffffffffc0200af8:	1582                	slli	a1,a1,0x20
ffffffffc0200afa:	9181                	srli	a1,a1,0x20
ffffffffc0200afc:	00d58733          	add	a4,a1,a3
ffffffffc0200b00:	02e8ee63          	bltu	a7,a4,ffffffffc0200b3c <ide_read_secs+0x7a>
ffffffffc0200b04:	00251713          	slli	a4,a0,0x2
ffffffffc0200b08:	0407b883          	ld	a7,64(a5)
ffffffffc0200b0c:	60a2                	ld	ra,8(sp)
ffffffffc0200b0e:	00a707b3          	add	a5,a4,a0
ffffffffc0200b12:	0792                	slli	a5,a5,0x4
ffffffffc0200b14:	00f80533          	add	a0,a6,a5
ffffffffc0200b18:	0141                	addi	sp,sp,16
ffffffffc0200b1a:	8882                	jr	a7
ffffffffc0200b1c:	0000b697          	auipc	a3,0xb
ffffffffc0200b20:	d6c68693          	addi	a3,a3,-660 # ffffffffc020b888 <etext+0x486>
ffffffffc0200b24:	0000b617          	auipc	a2,0xb
ffffffffc0200b28:	d1c60613          	addi	a2,a2,-740 # ffffffffc020b840 <etext+0x43e>
ffffffffc0200b2c:	02200593          	li	a1,34
ffffffffc0200b30:	0000b517          	auipc	a0,0xb
ffffffffc0200b34:	d2850513          	addi	a0,a0,-728 # ffffffffc020b858 <etext+0x456>
ffffffffc0200b38:	913ff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0200b3c:	0000b697          	auipc	a3,0xb
ffffffffc0200b40:	d7468693          	addi	a3,a3,-652 # ffffffffc020b8b0 <etext+0x4ae>
ffffffffc0200b44:	0000b617          	auipc	a2,0xb
ffffffffc0200b48:	cfc60613          	addi	a2,a2,-772 # ffffffffc020b840 <etext+0x43e>
ffffffffc0200b4c:	02300593          	li	a1,35
ffffffffc0200b50:	0000b517          	auipc	a0,0xb
ffffffffc0200b54:	d0850513          	addi	a0,a0,-760 # ffffffffc020b858 <etext+0x456>
ffffffffc0200b58:	8f3ff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200b5c <ide_write_secs>:
ffffffffc0200b5c:	1141                	addi	sp,sp,-16
ffffffffc0200b5e:	e406                	sd	ra,8(sp)
ffffffffc0200b60:	0816b793          	sltiu	a5,a3,129
ffffffffc0200b64:	cba9                	beqz	a5,ffffffffc0200bb6 <ide_write_secs+0x5a>
ffffffffc0200b66:	478d                	li	a5,3
ffffffffc0200b68:	0005081b          	sext.w	a6,a0
ffffffffc0200b6c:	04a7e563          	bltu	a5,a0,ffffffffc0200bb6 <ide_write_secs+0x5a>
ffffffffc0200b70:	00281793          	slli	a5,a6,0x2
ffffffffc0200b74:	97c2                	add	a5,a5,a6
ffffffffc0200b76:	0792                	slli	a5,a5,0x4
ffffffffc0200b78:	00091817          	auipc	a6,0x91
ffffffffc0200b7c:	af080813          	addi	a6,a6,-1296 # ffffffffc0291668 <ide_devices>
ffffffffc0200b80:	97c2                	add	a5,a5,a6
ffffffffc0200b82:	0007a883          	lw	a7,0(a5)
ffffffffc0200b86:	02088863          	beqz	a7,ffffffffc0200bb6 <ide_write_secs+0x5a>
ffffffffc0200b8a:	100008b7          	lui	a7,0x10000
ffffffffc0200b8e:	0515f463          	bgeu	a1,a7,ffffffffc0200bd6 <ide_write_secs+0x7a>
ffffffffc0200b92:	1582                	slli	a1,a1,0x20
ffffffffc0200b94:	9181                	srli	a1,a1,0x20
ffffffffc0200b96:	00d58733          	add	a4,a1,a3
ffffffffc0200b9a:	02e8ee63          	bltu	a7,a4,ffffffffc0200bd6 <ide_write_secs+0x7a>
ffffffffc0200b9e:	00251713          	slli	a4,a0,0x2
ffffffffc0200ba2:	0487b883          	ld	a7,72(a5)
ffffffffc0200ba6:	60a2                	ld	ra,8(sp)
ffffffffc0200ba8:	00a707b3          	add	a5,a4,a0
ffffffffc0200bac:	0792                	slli	a5,a5,0x4
ffffffffc0200bae:	00f80533          	add	a0,a6,a5
ffffffffc0200bb2:	0141                	addi	sp,sp,16
ffffffffc0200bb4:	8882                	jr	a7
ffffffffc0200bb6:	0000b697          	auipc	a3,0xb
ffffffffc0200bba:	cd268693          	addi	a3,a3,-814 # ffffffffc020b888 <etext+0x486>
ffffffffc0200bbe:	0000b617          	auipc	a2,0xb
ffffffffc0200bc2:	c8260613          	addi	a2,a2,-894 # ffffffffc020b840 <etext+0x43e>
ffffffffc0200bc6:	02900593          	li	a1,41
ffffffffc0200bca:	0000b517          	auipc	a0,0xb
ffffffffc0200bce:	c8e50513          	addi	a0,a0,-882 # ffffffffc020b858 <etext+0x456>
ffffffffc0200bd2:	879ff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0200bd6:	0000b697          	auipc	a3,0xb
ffffffffc0200bda:	cda68693          	addi	a3,a3,-806 # ffffffffc020b8b0 <etext+0x4ae>
ffffffffc0200bde:	0000b617          	auipc	a2,0xb
ffffffffc0200be2:	c6260613          	addi	a2,a2,-926 # ffffffffc020b840 <etext+0x43e>
ffffffffc0200be6:	02a00593          	li	a1,42
ffffffffc0200bea:	0000b517          	auipc	a0,0xb
ffffffffc0200bee:	c6e50513          	addi	a0,a0,-914 # ffffffffc020b858 <etext+0x456>
ffffffffc0200bf2:	859ff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200bf6 <intr_enable>:
ffffffffc0200bf6:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200bfa:	8082                	ret

ffffffffc0200bfc <intr_disable>:
ffffffffc0200bfc:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200c00:	8082                	ret

ffffffffc0200c02 <pic_init>:
ffffffffc0200c02:	8082                	ret

ffffffffc0200c04 <ramdisk_write>:
ffffffffc0200c04:	00856783          	lwu	a5,8(a0)
ffffffffc0200c08:	1141                	addi	sp,sp,-16
ffffffffc0200c0a:	e406                	sd	ra,8(sp)
ffffffffc0200c0c:	8f8d                	sub	a5,a5,a1
ffffffffc0200c0e:	8732                	mv	a4,a2
ffffffffc0200c10:	00f6f363          	bgeu	a3,a5,ffffffffc0200c16 <ramdisk_write+0x12>
ffffffffc0200c14:	87b6                	mv	a5,a3
ffffffffc0200c16:	6914                	ld	a3,16(a0)
ffffffffc0200c18:	00959513          	slli	a0,a1,0x9
ffffffffc0200c1c:	00979613          	slli	a2,a5,0x9
ffffffffc0200c20:	9536                	add	a0,a0,a3
ffffffffc0200c22:	85ba                	mv	a1,a4
ffffffffc0200c24:	7c60a0ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc0200c28:	60a2                	ld	ra,8(sp)
ffffffffc0200c2a:	4501                	li	a0,0
ffffffffc0200c2c:	0141                	addi	sp,sp,16
ffffffffc0200c2e:	8082                	ret

ffffffffc0200c30 <ramdisk_read>:
ffffffffc0200c30:	00856783          	lwu	a5,8(a0)
ffffffffc0200c34:	1141                	addi	sp,sp,-16
ffffffffc0200c36:	e406                	sd	ra,8(sp)
ffffffffc0200c38:	8f8d                	sub	a5,a5,a1
ffffffffc0200c3a:	872a                	mv	a4,a0
ffffffffc0200c3c:	8532                	mv	a0,a2
ffffffffc0200c3e:	00f6f363          	bgeu	a3,a5,ffffffffc0200c44 <ramdisk_read+0x14>
ffffffffc0200c42:	87b6                	mv	a5,a3
ffffffffc0200c44:	6b18                	ld	a4,16(a4)
ffffffffc0200c46:	05a6                	slli	a1,a1,0x9
ffffffffc0200c48:	00979613          	slli	a2,a5,0x9
ffffffffc0200c4c:	95ba                	add	a1,a1,a4
ffffffffc0200c4e:	79c0a0ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc0200c52:	60a2                	ld	ra,8(sp)
ffffffffc0200c54:	4501                	li	a0,0
ffffffffc0200c56:	0141                	addi	sp,sp,16
ffffffffc0200c58:	8082                	ret

ffffffffc0200c5a <ramdisk_init>:
ffffffffc0200c5a:	7179                	addi	sp,sp,-48
ffffffffc0200c5c:	f022                	sd	s0,32(sp)
ffffffffc0200c5e:	ec26                	sd	s1,24(sp)
ffffffffc0200c60:	842e                	mv	s0,a1
ffffffffc0200c62:	84aa                	mv	s1,a0
ffffffffc0200c64:	05000613          	li	a2,80
ffffffffc0200c68:	852e                	mv	a0,a1
ffffffffc0200c6a:	4581                	li	a1,0
ffffffffc0200c6c:	f406                	sd	ra,40(sp)
ffffffffc0200c6e:	72c0a0ef          	jal	ffffffffc020b39a <memset>
ffffffffc0200c72:	4785                	li	a5,1
ffffffffc0200c74:	06f48a63          	beq	s1,a5,ffffffffc0200ce8 <ramdisk_init+0x8e>
ffffffffc0200c78:	4789                	li	a5,2
ffffffffc0200c7a:	00090617          	auipc	a2,0x90
ffffffffc0200c7e:	39660613          	addi	a2,a2,918 # ffffffffc0291010 <arena>
ffffffffc0200c82:	0001b597          	auipc	a1,0x1b
ffffffffc0200c86:	08e58593          	addi	a1,a1,142 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200c8a:	08f49363          	bne	s1,a5,ffffffffc0200d10 <ramdisk_init+0xb6>
ffffffffc0200c8e:	06c58763          	beq	a1,a2,ffffffffc0200cfc <ramdisk_init+0xa2>
ffffffffc0200c92:	40b604b3          	sub	s1,a2,a1
ffffffffc0200c96:	86a6                	mv	a3,s1
ffffffffc0200c98:	167d                	addi	a2,a2,-1
ffffffffc0200c9a:	0000b517          	auipc	a0,0xb
ffffffffc0200c9e:	c6e50513          	addi	a0,a0,-914 # ffffffffc020b908 <etext+0x506>
ffffffffc0200ca2:	e42e                	sd	a1,8(sp)
ffffffffc0200ca4:	d02ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ca8:	65a2                	ld	a1,8(sp)
ffffffffc0200caa:	57fd                	li	a5,-1
ffffffffc0200cac:	1782                	slli	a5,a5,0x20
ffffffffc0200cae:	0094d69b          	srliw	a3,s1,0x9
ffffffffc0200cb2:	0785                	addi	a5,a5,1
ffffffffc0200cb4:	e80c                	sd	a1,16(s0)
ffffffffc0200cb6:	e01c                	sd	a5,0(s0)
ffffffffc0200cb8:	c414                	sw	a3,8(s0)
ffffffffc0200cba:	02040513          	addi	a0,s0,32
ffffffffc0200cbe:	0000b597          	auipc	a1,0xb
ffffffffc0200cc2:	ca258593          	addi	a1,a1,-862 # ffffffffc020b960 <etext+0x55e>
ffffffffc0200cc6:	6540a0ef          	jal	ffffffffc020b31a <strcpy>
ffffffffc0200cca:	00000717          	auipc	a4,0x0
ffffffffc0200cce:	f6670713          	addi	a4,a4,-154 # ffffffffc0200c30 <ramdisk_read>
ffffffffc0200cd2:	00000797          	auipc	a5,0x0
ffffffffc0200cd6:	f3278793          	addi	a5,a5,-206 # ffffffffc0200c04 <ramdisk_write>
ffffffffc0200cda:	70a2                	ld	ra,40(sp)
ffffffffc0200cdc:	e038                	sd	a4,64(s0)
ffffffffc0200cde:	e43c                	sd	a5,72(s0)
ffffffffc0200ce0:	7402                	ld	s0,32(sp)
ffffffffc0200ce2:	64e2                	ld	s1,24(sp)
ffffffffc0200ce4:	6145                	addi	sp,sp,48
ffffffffc0200ce6:	8082                	ret
ffffffffc0200ce8:	0001b617          	auipc	a2,0x1b
ffffffffc0200cec:	02860613          	addi	a2,a2,40 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200cf0:	00013597          	auipc	a1,0x13
ffffffffc0200cf4:	32058593          	addi	a1,a1,800 # ffffffffc0214010 <_binary_bin_swap_img_start>
ffffffffc0200cf8:	f8c59de3          	bne	a1,a2,ffffffffc0200c92 <ramdisk_init+0x38>
ffffffffc0200cfc:	7402                	ld	s0,32(sp)
ffffffffc0200cfe:	70a2                	ld	ra,40(sp)
ffffffffc0200d00:	64e2                	ld	s1,24(sp)
ffffffffc0200d02:	0000b517          	auipc	a0,0xb
ffffffffc0200d06:	bee50513          	addi	a0,a0,-1042 # ffffffffc020b8f0 <etext+0x4ee>
ffffffffc0200d0a:	6145                	addi	sp,sp,48
ffffffffc0200d0c:	c9aff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200d10:	0000b617          	auipc	a2,0xb
ffffffffc0200d14:	c2060613          	addi	a2,a2,-992 # ffffffffc020b930 <etext+0x52e>
ffffffffc0200d18:	03200593          	li	a1,50
ffffffffc0200d1c:	0000b517          	auipc	a0,0xb
ffffffffc0200d20:	c2c50513          	addi	a0,a0,-980 # ffffffffc020b948 <etext+0x546>
ffffffffc0200d24:	f26ff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200d28 <idt_init>:
ffffffffc0200d28:	14005073          	csrwi	sscratch,0
ffffffffc0200d2c:	00000797          	auipc	a5,0x0
ffffffffc0200d30:	46c78793          	addi	a5,a5,1132 # ffffffffc0201198 <__alltraps>
ffffffffc0200d34:	10579073          	csrw	stvec,a5
ffffffffc0200d38:	000407b7          	lui	a5,0x40
ffffffffc0200d3c:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200d40:	8082                	ret

ffffffffc0200d42 <print_regs>:
ffffffffc0200d42:	610c                	ld	a1,0(a0)
ffffffffc0200d44:	1141                	addi	sp,sp,-16
ffffffffc0200d46:	e022                	sd	s0,0(sp)
ffffffffc0200d48:	842a                	mv	s0,a0
ffffffffc0200d4a:	0000b517          	auipc	a0,0xb
ffffffffc0200d4e:	c2650513          	addi	a0,a0,-986 # ffffffffc020b970 <etext+0x56e>
ffffffffc0200d52:	e406                	sd	ra,8(sp)
ffffffffc0200d54:	c52ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d58:	640c                	ld	a1,8(s0)
ffffffffc0200d5a:	0000b517          	auipc	a0,0xb
ffffffffc0200d5e:	c2e50513          	addi	a0,a0,-978 # ffffffffc020b988 <etext+0x586>
ffffffffc0200d62:	c44ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d66:	680c                	ld	a1,16(s0)
ffffffffc0200d68:	0000b517          	auipc	a0,0xb
ffffffffc0200d6c:	c3850513          	addi	a0,a0,-968 # ffffffffc020b9a0 <etext+0x59e>
ffffffffc0200d70:	c36ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d74:	6c0c                	ld	a1,24(s0)
ffffffffc0200d76:	0000b517          	auipc	a0,0xb
ffffffffc0200d7a:	c4250513          	addi	a0,a0,-958 # ffffffffc020b9b8 <etext+0x5b6>
ffffffffc0200d7e:	c28ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d82:	700c                	ld	a1,32(s0)
ffffffffc0200d84:	0000b517          	auipc	a0,0xb
ffffffffc0200d88:	c4c50513          	addi	a0,a0,-948 # ffffffffc020b9d0 <etext+0x5ce>
ffffffffc0200d8c:	c1aff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d90:	740c                	ld	a1,40(s0)
ffffffffc0200d92:	0000b517          	auipc	a0,0xb
ffffffffc0200d96:	c5650513          	addi	a0,a0,-938 # ffffffffc020b9e8 <etext+0x5e6>
ffffffffc0200d9a:	c0cff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d9e:	780c                	ld	a1,48(s0)
ffffffffc0200da0:	0000b517          	auipc	a0,0xb
ffffffffc0200da4:	c6050513          	addi	a0,a0,-928 # ffffffffc020ba00 <etext+0x5fe>
ffffffffc0200da8:	bfeff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200dac:	7c0c                	ld	a1,56(s0)
ffffffffc0200dae:	0000b517          	auipc	a0,0xb
ffffffffc0200db2:	c6a50513          	addi	a0,a0,-918 # ffffffffc020ba18 <etext+0x616>
ffffffffc0200db6:	bf0ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200dba:	602c                	ld	a1,64(s0)
ffffffffc0200dbc:	0000b517          	auipc	a0,0xb
ffffffffc0200dc0:	c7450513          	addi	a0,a0,-908 # ffffffffc020ba30 <etext+0x62e>
ffffffffc0200dc4:	be2ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200dc8:	642c                	ld	a1,72(s0)
ffffffffc0200dca:	0000b517          	auipc	a0,0xb
ffffffffc0200dce:	c7e50513          	addi	a0,a0,-898 # ffffffffc020ba48 <etext+0x646>
ffffffffc0200dd2:	bd4ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200dd6:	682c                	ld	a1,80(s0)
ffffffffc0200dd8:	0000b517          	auipc	a0,0xb
ffffffffc0200ddc:	c8850513          	addi	a0,a0,-888 # ffffffffc020ba60 <etext+0x65e>
ffffffffc0200de0:	bc6ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200de4:	6c2c                	ld	a1,88(s0)
ffffffffc0200de6:	0000b517          	auipc	a0,0xb
ffffffffc0200dea:	c9250513          	addi	a0,a0,-878 # ffffffffc020ba78 <etext+0x676>
ffffffffc0200dee:	bb8ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200df2:	702c                	ld	a1,96(s0)
ffffffffc0200df4:	0000b517          	auipc	a0,0xb
ffffffffc0200df8:	c9c50513          	addi	a0,a0,-868 # ffffffffc020ba90 <etext+0x68e>
ffffffffc0200dfc:	baaff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e00:	742c                	ld	a1,104(s0)
ffffffffc0200e02:	0000b517          	auipc	a0,0xb
ffffffffc0200e06:	ca650513          	addi	a0,a0,-858 # ffffffffc020baa8 <etext+0x6a6>
ffffffffc0200e0a:	b9cff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e0e:	782c                	ld	a1,112(s0)
ffffffffc0200e10:	0000b517          	auipc	a0,0xb
ffffffffc0200e14:	cb050513          	addi	a0,a0,-848 # ffffffffc020bac0 <etext+0x6be>
ffffffffc0200e18:	b8eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e1c:	7c2c                	ld	a1,120(s0)
ffffffffc0200e1e:	0000b517          	auipc	a0,0xb
ffffffffc0200e22:	cba50513          	addi	a0,a0,-838 # ffffffffc020bad8 <etext+0x6d6>
ffffffffc0200e26:	b80ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e2a:	604c                	ld	a1,128(s0)
ffffffffc0200e2c:	0000b517          	auipc	a0,0xb
ffffffffc0200e30:	cc450513          	addi	a0,a0,-828 # ffffffffc020baf0 <etext+0x6ee>
ffffffffc0200e34:	b72ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e38:	644c                	ld	a1,136(s0)
ffffffffc0200e3a:	0000b517          	auipc	a0,0xb
ffffffffc0200e3e:	cce50513          	addi	a0,a0,-818 # ffffffffc020bb08 <etext+0x706>
ffffffffc0200e42:	b64ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e46:	684c                	ld	a1,144(s0)
ffffffffc0200e48:	0000b517          	auipc	a0,0xb
ffffffffc0200e4c:	cd850513          	addi	a0,a0,-808 # ffffffffc020bb20 <etext+0x71e>
ffffffffc0200e50:	b56ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e54:	6c4c                	ld	a1,152(s0)
ffffffffc0200e56:	0000b517          	auipc	a0,0xb
ffffffffc0200e5a:	ce250513          	addi	a0,a0,-798 # ffffffffc020bb38 <etext+0x736>
ffffffffc0200e5e:	b48ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e62:	704c                	ld	a1,160(s0)
ffffffffc0200e64:	0000b517          	auipc	a0,0xb
ffffffffc0200e68:	cec50513          	addi	a0,a0,-788 # ffffffffc020bb50 <etext+0x74e>
ffffffffc0200e6c:	b3aff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e70:	744c                	ld	a1,168(s0)
ffffffffc0200e72:	0000b517          	auipc	a0,0xb
ffffffffc0200e76:	cf650513          	addi	a0,a0,-778 # ffffffffc020bb68 <etext+0x766>
ffffffffc0200e7a:	b2cff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e7e:	784c                	ld	a1,176(s0)
ffffffffc0200e80:	0000b517          	auipc	a0,0xb
ffffffffc0200e84:	d0050513          	addi	a0,a0,-768 # ffffffffc020bb80 <etext+0x77e>
ffffffffc0200e88:	b1eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e8c:	7c4c                	ld	a1,184(s0)
ffffffffc0200e8e:	0000b517          	auipc	a0,0xb
ffffffffc0200e92:	d0a50513          	addi	a0,a0,-758 # ffffffffc020bb98 <etext+0x796>
ffffffffc0200e96:	b10ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e9a:	606c                	ld	a1,192(s0)
ffffffffc0200e9c:	0000b517          	auipc	a0,0xb
ffffffffc0200ea0:	d1450513          	addi	a0,a0,-748 # ffffffffc020bbb0 <etext+0x7ae>
ffffffffc0200ea4:	b02ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ea8:	646c                	ld	a1,200(s0)
ffffffffc0200eaa:	0000b517          	auipc	a0,0xb
ffffffffc0200eae:	d1e50513          	addi	a0,a0,-738 # ffffffffc020bbc8 <etext+0x7c6>
ffffffffc0200eb2:	af4ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200eb6:	686c                	ld	a1,208(s0)
ffffffffc0200eb8:	0000b517          	auipc	a0,0xb
ffffffffc0200ebc:	d2850513          	addi	a0,a0,-728 # ffffffffc020bbe0 <etext+0x7de>
ffffffffc0200ec0:	ae6ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ec4:	6c6c                	ld	a1,216(s0)
ffffffffc0200ec6:	0000b517          	auipc	a0,0xb
ffffffffc0200eca:	d3250513          	addi	a0,a0,-718 # ffffffffc020bbf8 <etext+0x7f6>
ffffffffc0200ece:	ad8ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ed2:	706c                	ld	a1,224(s0)
ffffffffc0200ed4:	0000b517          	auipc	a0,0xb
ffffffffc0200ed8:	d3c50513          	addi	a0,a0,-708 # ffffffffc020bc10 <etext+0x80e>
ffffffffc0200edc:	acaff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ee0:	746c                	ld	a1,232(s0)
ffffffffc0200ee2:	0000b517          	auipc	a0,0xb
ffffffffc0200ee6:	d4650513          	addi	a0,a0,-698 # ffffffffc020bc28 <etext+0x826>
ffffffffc0200eea:	abcff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200eee:	786c                	ld	a1,240(s0)
ffffffffc0200ef0:	0000b517          	auipc	a0,0xb
ffffffffc0200ef4:	d5050513          	addi	a0,a0,-688 # ffffffffc020bc40 <etext+0x83e>
ffffffffc0200ef8:	aaeff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200efc:	7c6c                	ld	a1,248(s0)
ffffffffc0200efe:	6402                	ld	s0,0(sp)
ffffffffc0200f00:	60a2                	ld	ra,8(sp)
ffffffffc0200f02:	0000b517          	auipc	a0,0xb
ffffffffc0200f06:	d5650513          	addi	a0,a0,-682 # ffffffffc020bc58 <etext+0x856>
ffffffffc0200f0a:	0141                	addi	sp,sp,16
ffffffffc0200f0c:	a9aff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200f10 <print_trapframe>:
ffffffffc0200f10:	1141                	addi	sp,sp,-16
ffffffffc0200f12:	e022                	sd	s0,0(sp)
ffffffffc0200f14:	85aa                	mv	a1,a0
ffffffffc0200f16:	842a                	mv	s0,a0
ffffffffc0200f18:	0000b517          	auipc	a0,0xb
ffffffffc0200f1c:	d5850513          	addi	a0,a0,-680 # ffffffffc020bc70 <etext+0x86e>
ffffffffc0200f20:	e406                	sd	ra,8(sp)
ffffffffc0200f22:	a84ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f26:	8522                	mv	a0,s0
ffffffffc0200f28:	e1bff0ef          	jal	ffffffffc0200d42 <print_regs>
ffffffffc0200f2c:	10043583          	ld	a1,256(s0)
ffffffffc0200f30:	0000b517          	auipc	a0,0xb
ffffffffc0200f34:	d5850513          	addi	a0,a0,-680 # ffffffffc020bc88 <etext+0x886>
ffffffffc0200f38:	a6eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f3c:	10843583          	ld	a1,264(s0)
ffffffffc0200f40:	0000b517          	auipc	a0,0xb
ffffffffc0200f44:	d6050513          	addi	a0,a0,-672 # ffffffffc020bca0 <etext+0x89e>
ffffffffc0200f48:	a5eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f4c:	11043583          	ld	a1,272(s0)
ffffffffc0200f50:	0000b517          	auipc	a0,0xb
ffffffffc0200f54:	d6850513          	addi	a0,a0,-664 # ffffffffc020bcb8 <etext+0x8b6>
ffffffffc0200f58:	a4eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f5c:	11843583          	ld	a1,280(s0)
ffffffffc0200f60:	6402                	ld	s0,0(sp)
ffffffffc0200f62:	60a2                	ld	ra,8(sp)
ffffffffc0200f64:	0000b517          	auipc	a0,0xb
ffffffffc0200f68:	d6450513          	addi	a0,a0,-668 # ffffffffc020bcc8 <etext+0x8c6>
ffffffffc0200f6c:	0141                	addi	sp,sp,16
ffffffffc0200f6e:	a38ff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200f72 <interrupt_handler>:
ffffffffc0200f72:	11853783          	ld	a5,280(a0)
ffffffffc0200f76:	472d                	li	a4,11
ffffffffc0200f78:	0786                	slli	a5,a5,0x1
ffffffffc0200f7a:	8385                	srli	a5,a5,0x1
ffffffffc0200f7c:	06f76963          	bltu	a4,a5,ffffffffc0200fee <interrupt_handler+0x7c>
ffffffffc0200f80:	0000e717          	auipc	a4,0xe
ffffffffc0200f84:	9d870713          	addi	a4,a4,-1576 # ffffffffc020e958 <commands+0x48>
ffffffffc0200f88:	078a                	slli	a5,a5,0x2
ffffffffc0200f8a:	97ba                	add	a5,a5,a4
ffffffffc0200f8c:	439c                	lw	a5,0(a5)
ffffffffc0200f8e:	97ba                	add	a5,a5,a4
ffffffffc0200f90:	8782                	jr	a5
ffffffffc0200f92:	0000b517          	auipc	a0,0xb
ffffffffc0200f96:	dae50513          	addi	a0,a0,-594 # ffffffffc020bd40 <etext+0x93e>
ffffffffc0200f9a:	a0cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200f9e:	0000b517          	auipc	a0,0xb
ffffffffc0200fa2:	d8250513          	addi	a0,a0,-638 # ffffffffc020bd20 <etext+0x91e>
ffffffffc0200fa6:	a00ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200faa:	0000b517          	auipc	a0,0xb
ffffffffc0200fae:	d3650513          	addi	a0,a0,-714 # ffffffffc020bce0 <etext+0x8de>
ffffffffc0200fb2:	9f4ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200fb6:	0000b517          	auipc	a0,0xb
ffffffffc0200fba:	d4a50513          	addi	a0,a0,-694 # ffffffffc020bd00 <etext+0x8fe>
ffffffffc0200fbe:	9e8ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200fc2:	1141                	addi	sp,sp,-16
ffffffffc0200fc4:	e406                	sd	ra,8(sp)
ffffffffc0200fc6:	d62ff0ef          	jal	ffffffffc0200528 <clock_set_next_event>
ffffffffc0200fca:	00096797          	auipc	a5,0x96
ffffffffc0200fce:	8a67b783          	ld	a5,-1882(a5) # ffffffffc0296870 <ticks>
ffffffffc0200fd2:	60a2                	ld	ra,8(sp)
ffffffffc0200fd4:	0785                	addi	a5,a5,1
ffffffffc0200fd6:	00096717          	auipc	a4,0x96
ffffffffc0200fda:	88f73d23          	sd	a5,-1894(a4) # ffffffffc0296870 <ticks>
ffffffffc0200fde:	0141                	addi	sp,sp,16
ffffffffc0200fe0:	8082                	ret
ffffffffc0200fe2:	0000b517          	auipc	a0,0xb
ffffffffc0200fe6:	d7e50513          	addi	a0,a0,-642 # ffffffffc020bd60 <etext+0x95e>
ffffffffc0200fea:	9bcff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200fee:	b70d                	j	ffffffffc0200f10 <print_trapframe>

ffffffffc0200ff0 <exception_handler>:
ffffffffc0200ff0:	11853783          	ld	a5,280(a0)
ffffffffc0200ff4:	473d                	li	a4,15
ffffffffc0200ff6:	10f76e63          	bltu	a4,a5,ffffffffc0201112 <exception_handler+0x122>
ffffffffc0200ffa:	0000e717          	auipc	a4,0xe
ffffffffc0200ffe:	98e70713          	addi	a4,a4,-1650 # ffffffffc020e988 <commands+0x78>
ffffffffc0201002:	078a                	slli	a5,a5,0x2
ffffffffc0201004:	97ba                	add	a5,a5,a4
ffffffffc0201006:	439c                	lw	a5,0(a5)
ffffffffc0201008:	1101                	addi	sp,sp,-32
ffffffffc020100a:	ec06                	sd	ra,24(sp)
ffffffffc020100c:	97ba                	add	a5,a5,a4
ffffffffc020100e:	86aa                	mv	a3,a0
ffffffffc0201010:	8782                	jr	a5
ffffffffc0201012:	e42a                	sd	a0,8(sp)
ffffffffc0201014:	0000b517          	auipc	a0,0xb
ffffffffc0201018:	e5450513          	addi	a0,a0,-428 # ffffffffc020be68 <etext+0xa66>
ffffffffc020101c:	98aff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0201020:	66a2                	ld	a3,8(sp)
ffffffffc0201022:	1086b783          	ld	a5,264(a3)
ffffffffc0201026:	60e2                	ld	ra,24(sp)
ffffffffc0201028:	0791                	addi	a5,a5,4
ffffffffc020102a:	10f6b423          	sd	a5,264(a3)
ffffffffc020102e:	6105                	addi	sp,sp,32
ffffffffc0201030:	50c0606f          	j	ffffffffc020753c <syscall>
ffffffffc0201034:	60e2                	ld	ra,24(sp)
ffffffffc0201036:	0000b517          	auipc	a0,0xb
ffffffffc020103a:	e5250513          	addi	a0,a0,-430 # ffffffffc020be88 <etext+0xa86>
ffffffffc020103e:	6105                	addi	sp,sp,32
ffffffffc0201040:	966ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201044:	60e2                	ld	ra,24(sp)
ffffffffc0201046:	0000b517          	auipc	a0,0xb
ffffffffc020104a:	e6250513          	addi	a0,a0,-414 # ffffffffc020bea8 <etext+0xaa6>
ffffffffc020104e:	6105                	addi	sp,sp,32
ffffffffc0201050:	956ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201054:	60e2                	ld	ra,24(sp)
ffffffffc0201056:	0000b517          	auipc	a0,0xb
ffffffffc020105a:	e7250513          	addi	a0,a0,-398 # ffffffffc020bec8 <etext+0xac6>
ffffffffc020105e:	6105                	addi	sp,sp,32
ffffffffc0201060:	946ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201064:	60e2                	ld	ra,24(sp)
ffffffffc0201066:	0000b517          	auipc	a0,0xb
ffffffffc020106a:	e7a50513          	addi	a0,a0,-390 # ffffffffc020bee0 <etext+0xade>
ffffffffc020106e:	6105                	addi	sp,sp,32
ffffffffc0201070:	936ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201074:	60e2                	ld	ra,24(sp)
ffffffffc0201076:	0000b517          	auipc	a0,0xb
ffffffffc020107a:	e8250513          	addi	a0,a0,-382 # ffffffffc020bef8 <etext+0xaf6>
ffffffffc020107e:	6105                	addi	sp,sp,32
ffffffffc0201080:	926ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201084:	60e2                	ld	ra,24(sp)
ffffffffc0201086:	0000b517          	auipc	a0,0xb
ffffffffc020108a:	cfa50513          	addi	a0,a0,-774 # ffffffffc020bd80 <etext+0x97e>
ffffffffc020108e:	6105                	addi	sp,sp,32
ffffffffc0201090:	916ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201094:	60e2                	ld	ra,24(sp)
ffffffffc0201096:	0000b517          	auipc	a0,0xb
ffffffffc020109a:	d0a50513          	addi	a0,a0,-758 # ffffffffc020bda0 <etext+0x99e>
ffffffffc020109e:	6105                	addi	sp,sp,32
ffffffffc02010a0:	906ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010a4:	60e2                	ld	ra,24(sp)
ffffffffc02010a6:	0000b517          	auipc	a0,0xb
ffffffffc02010aa:	d1a50513          	addi	a0,a0,-742 # ffffffffc020bdc0 <etext+0x9be>
ffffffffc02010ae:	6105                	addi	sp,sp,32
ffffffffc02010b0:	8f6ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010b4:	60e2                	ld	ra,24(sp)
ffffffffc02010b6:	0000b517          	auipc	a0,0xb
ffffffffc02010ba:	d2250513          	addi	a0,a0,-734 # ffffffffc020bdd8 <etext+0x9d6>
ffffffffc02010be:	6105                	addi	sp,sp,32
ffffffffc02010c0:	8e6ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010c4:	60e2                	ld	ra,24(sp)
ffffffffc02010c6:	0000b517          	auipc	a0,0xb
ffffffffc02010ca:	d2250513          	addi	a0,a0,-734 # ffffffffc020bde8 <etext+0x9e6>
ffffffffc02010ce:	6105                	addi	sp,sp,32
ffffffffc02010d0:	8d6ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010d4:	60e2                	ld	ra,24(sp)
ffffffffc02010d6:	0000b517          	auipc	a0,0xb
ffffffffc02010da:	d3250513          	addi	a0,a0,-718 # ffffffffc020be08 <etext+0xa06>
ffffffffc02010de:	6105                	addi	sp,sp,32
ffffffffc02010e0:	8c6ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010e4:	60e2                	ld	ra,24(sp)
ffffffffc02010e6:	0000b517          	auipc	a0,0xb
ffffffffc02010ea:	d6a50513          	addi	a0,a0,-662 # ffffffffc020be50 <etext+0xa4e>
ffffffffc02010ee:	6105                	addi	sp,sp,32
ffffffffc02010f0:	8b6ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010f4:	60e2                	ld	ra,24(sp)
ffffffffc02010f6:	6105                	addi	sp,sp,32
ffffffffc02010f8:	bd21                	j	ffffffffc0200f10 <print_trapframe>
ffffffffc02010fa:	0000b617          	auipc	a2,0xb
ffffffffc02010fe:	d2660613          	addi	a2,a2,-730 # ffffffffc020be20 <etext+0xa1e>
ffffffffc0201102:	0b000593          	li	a1,176
ffffffffc0201106:	0000b517          	auipc	a0,0xb
ffffffffc020110a:	d3250513          	addi	a0,a0,-718 # ffffffffc020be38 <etext+0xa36>
ffffffffc020110e:	b3cff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201112:	bbfd                	j	ffffffffc0200f10 <print_trapframe>

ffffffffc0201114 <trap>:
ffffffffc0201114:	00095717          	auipc	a4,0x95
ffffffffc0201118:	7b473703          	ld	a4,1972(a4) # ffffffffc02968c8 <current>
ffffffffc020111c:	11853583          	ld	a1,280(a0)
ffffffffc0201120:	cf21                	beqz	a4,ffffffffc0201178 <trap+0x64>
ffffffffc0201122:	10053603          	ld	a2,256(a0)
ffffffffc0201126:	0a073803          	ld	a6,160(a4)
ffffffffc020112a:	1101                	addi	sp,sp,-32
ffffffffc020112c:	ec06                	sd	ra,24(sp)
ffffffffc020112e:	10067613          	andi	a2,a2,256
ffffffffc0201132:	f348                	sd	a0,160(a4)
ffffffffc0201134:	e432                	sd	a2,8(sp)
ffffffffc0201136:	e042                	sd	a6,0(sp)
ffffffffc0201138:	0205c763          	bltz	a1,ffffffffc0201166 <trap+0x52>
ffffffffc020113c:	eb5ff0ef          	jal	ffffffffc0200ff0 <exception_handler>
ffffffffc0201140:	6622                	ld	a2,8(sp)
ffffffffc0201142:	6802                	ld	a6,0(sp)
ffffffffc0201144:	00095697          	auipc	a3,0x95
ffffffffc0201148:	78468693          	addi	a3,a3,1924 # ffffffffc02968c8 <current>
ffffffffc020114c:	6298                	ld	a4,0(a3)
ffffffffc020114e:	0b073023          	sd	a6,160(a4)
ffffffffc0201152:	e619                	bnez	a2,ffffffffc0201160 <trap+0x4c>
ffffffffc0201154:	0b072783          	lw	a5,176(a4)
ffffffffc0201158:	8b85                	andi	a5,a5,1
ffffffffc020115a:	e79d                	bnez	a5,ffffffffc0201188 <trap+0x74>
ffffffffc020115c:	6f1c                	ld	a5,24(a4)
ffffffffc020115e:	e38d                	bnez	a5,ffffffffc0201180 <trap+0x6c>
ffffffffc0201160:	60e2                	ld	ra,24(sp)
ffffffffc0201162:	6105                	addi	sp,sp,32
ffffffffc0201164:	8082                	ret
ffffffffc0201166:	e0dff0ef          	jal	ffffffffc0200f72 <interrupt_handler>
ffffffffc020116a:	6802                	ld	a6,0(sp)
ffffffffc020116c:	6622                	ld	a2,8(sp)
ffffffffc020116e:	00095697          	auipc	a3,0x95
ffffffffc0201172:	75a68693          	addi	a3,a3,1882 # ffffffffc02968c8 <current>
ffffffffc0201176:	bfd9                	j	ffffffffc020114c <trap+0x38>
ffffffffc0201178:	0005c363          	bltz	a1,ffffffffc020117e <trap+0x6a>
ffffffffc020117c:	bd95                	j	ffffffffc0200ff0 <exception_handler>
ffffffffc020117e:	bbd5                	j	ffffffffc0200f72 <interrupt_handler>
ffffffffc0201180:	60e2                	ld	ra,24(sp)
ffffffffc0201182:	6105                	addi	sp,sp,32
ffffffffc0201184:	0da0606f          	j	ffffffffc020725e <schedule>
ffffffffc0201188:	555d                	li	a0,-9
ffffffffc020118a:	563040ef          	jal	ffffffffc0205eec <do_exit>
ffffffffc020118e:	00095717          	auipc	a4,0x95
ffffffffc0201192:	73a73703          	ld	a4,1850(a4) # ffffffffc02968c8 <current>
ffffffffc0201196:	b7d9                	j	ffffffffc020115c <trap+0x48>

ffffffffc0201198 <__alltraps>:
ffffffffc0201198:	14011173          	csrrw	sp,sscratch,sp
ffffffffc020119c:	00011463          	bnez	sp,ffffffffc02011a4 <__alltraps+0xc>
ffffffffc02011a0:	14002173          	csrr	sp,sscratch
ffffffffc02011a4:	712d                	addi	sp,sp,-288
ffffffffc02011a6:	e002                	sd	zero,0(sp)
ffffffffc02011a8:	e406                	sd	ra,8(sp)
ffffffffc02011aa:	ec0e                	sd	gp,24(sp)
ffffffffc02011ac:	f012                	sd	tp,32(sp)
ffffffffc02011ae:	f416                	sd	t0,40(sp)
ffffffffc02011b0:	f81a                	sd	t1,48(sp)
ffffffffc02011b2:	fc1e                	sd	t2,56(sp)
ffffffffc02011b4:	e0a2                	sd	s0,64(sp)
ffffffffc02011b6:	e4a6                	sd	s1,72(sp)
ffffffffc02011b8:	e8aa                	sd	a0,80(sp)
ffffffffc02011ba:	ecae                	sd	a1,88(sp)
ffffffffc02011bc:	f0b2                	sd	a2,96(sp)
ffffffffc02011be:	f4b6                	sd	a3,104(sp)
ffffffffc02011c0:	f8ba                	sd	a4,112(sp)
ffffffffc02011c2:	fcbe                	sd	a5,120(sp)
ffffffffc02011c4:	e142                	sd	a6,128(sp)
ffffffffc02011c6:	e546                	sd	a7,136(sp)
ffffffffc02011c8:	e94a                	sd	s2,144(sp)
ffffffffc02011ca:	ed4e                	sd	s3,152(sp)
ffffffffc02011cc:	f152                	sd	s4,160(sp)
ffffffffc02011ce:	f556                	sd	s5,168(sp)
ffffffffc02011d0:	f95a                	sd	s6,176(sp)
ffffffffc02011d2:	fd5e                	sd	s7,184(sp)
ffffffffc02011d4:	e1e2                	sd	s8,192(sp)
ffffffffc02011d6:	e5e6                	sd	s9,200(sp)
ffffffffc02011d8:	e9ea                	sd	s10,208(sp)
ffffffffc02011da:	edee                	sd	s11,216(sp)
ffffffffc02011dc:	f1f2                	sd	t3,224(sp)
ffffffffc02011de:	f5f6                	sd	t4,232(sp)
ffffffffc02011e0:	f9fa                	sd	t5,240(sp)
ffffffffc02011e2:	fdfe                	sd	t6,248(sp)
ffffffffc02011e4:	14001473          	csrrw	s0,sscratch,zero
ffffffffc02011e8:	100024f3          	csrr	s1,sstatus
ffffffffc02011ec:	14102973          	csrr	s2,sepc
ffffffffc02011f0:	143029f3          	csrr	s3,stval
ffffffffc02011f4:	14202a73          	csrr	s4,scause
ffffffffc02011f8:	e822                	sd	s0,16(sp)
ffffffffc02011fa:	e226                	sd	s1,256(sp)
ffffffffc02011fc:	e64a                	sd	s2,264(sp)
ffffffffc02011fe:	ea4e                	sd	s3,272(sp)
ffffffffc0201200:	ee52                	sd	s4,280(sp)
ffffffffc0201202:	850a                	mv	a0,sp
ffffffffc0201204:	f11ff0ef          	jal	ffffffffc0201114 <trap>

ffffffffc0201208 <__trapret>:
ffffffffc0201208:	6492                	ld	s1,256(sp)
ffffffffc020120a:	6932                	ld	s2,264(sp)
ffffffffc020120c:	1004f413          	andi	s0,s1,256
ffffffffc0201210:	e401                	bnez	s0,ffffffffc0201218 <__trapret+0x10>
ffffffffc0201212:	1200                	addi	s0,sp,288
ffffffffc0201214:	14041073          	csrw	sscratch,s0
ffffffffc0201218:	10049073          	csrw	sstatus,s1
ffffffffc020121c:	14191073          	csrw	sepc,s2
ffffffffc0201220:	60a2                	ld	ra,8(sp)
ffffffffc0201222:	61e2                	ld	gp,24(sp)
ffffffffc0201224:	7202                	ld	tp,32(sp)
ffffffffc0201226:	72a2                	ld	t0,40(sp)
ffffffffc0201228:	7342                	ld	t1,48(sp)
ffffffffc020122a:	73e2                	ld	t2,56(sp)
ffffffffc020122c:	6406                	ld	s0,64(sp)
ffffffffc020122e:	64a6                	ld	s1,72(sp)
ffffffffc0201230:	6546                	ld	a0,80(sp)
ffffffffc0201232:	65e6                	ld	a1,88(sp)
ffffffffc0201234:	7606                	ld	a2,96(sp)
ffffffffc0201236:	76a6                	ld	a3,104(sp)
ffffffffc0201238:	7746                	ld	a4,112(sp)
ffffffffc020123a:	77e6                	ld	a5,120(sp)
ffffffffc020123c:	680a                	ld	a6,128(sp)
ffffffffc020123e:	68aa                	ld	a7,136(sp)
ffffffffc0201240:	694a                	ld	s2,144(sp)
ffffffffc0201242:	69ea                	ld	s3,152(sp)
ffffffffc0201244:	7a0a                	ld	s4,160(sp)
ffffffffc0201246:	7aaa                	ld	s5,168(sp)
ffffffffc0201248:	7b4a                	ld	s6,176(sp)
ffffffffc020124a:	7bea                	ld	s7,184(sp)
ffffffffc020124c:	6c0e                	ld	s8,192(sp)
ffffffffc020124e:	6cae                	ld	s9,200(sp)
ffffffffc0201250:	6d4e                	ld	s10,208(sp)
ffffffffc0201252:	6dee                	ld	s11,216(sp)
ffffffffc0201254:	7e0e                	ld	t3,224(sp)
ffffffffc0201256:	7eae                	ld	t4,232(sp)
ffffffffc0201258:	7f4e                	ld	t5,240(sp)
ffffffffc020125a:	7fee                	ld	t6,248(sp)
ffffffffc020125c:	6142                	ld	sp,16(sp)
ffffffffc020125e:	10200073          	sret

ffffffffc0201262 <forkrets>:
ffffffffc0201262:	812a                	mv	sp,a0
ffffffffc0201264:	b755                	j	ffffffffc0201208 <__trapret>

ffffffffc0201266 <default_init>:
ffffffffc0201266:	00090797          	auipc	a5,0x90
ffffffffc020126a:	54278793          	addi	a5,a5,1346 # ffffffffc02917a8 <free_area>
ffffffffc020126e:	e79c                	sd	a5,8(a5)
ffffffffc0201270:	e39c                	sd	a5,0(a5)
ffffffffc0201272:	0007a823          	sw	zero,16(a5)
ffffffffc0201276:	8082                	ret

ffffffffc0201278 <default_nr_free_pages>:
ffffffffc0201278:	00090517          	auipc	a0,0x90
ffffffffc020127c:	54056503          	lwu	a0,1344(a0) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201280:	8082                	ret

ffffffffc0201282 <default_check>:
ffffffffc0201282:	711d                	addi	sp,sp,-96
ffffffffc0201284:	e0ca                	sd	s2,64(sp)
ffffffffc0201286:	00090917          	auipc	s2,0x90
ffffffffc020128a:	52290913          	addi	s2,s2,1314 # ffffffffc02917a8 <free_area>
ffffffffc020128e:	00893783          	ld	a5,8(s2)
ffffffffc0201292:	ec86                	sd	ra,88(sp)
ffffffffc0201294:	e8a2                	sd	s0,80(sp)
ffffffffc0201296:	e4a6                	sd	s1,72(sp)
ffffffffc0201298:	fc4e                	sd	s3,56(sp)
ffffffffc020129a:	f852                	sd	s4,48(sp)
ffffffffc020129c:	f456                	sd	s5,40(sp)
ffffffffc020129e:	f05a                	sd	s6,32(sp)
ffffffffc02012a0:	ec5e                	sd	s7,24(sp)
ffffffffc02012a2:	e862                	sd	s8,16(sp)
ffffffffc02012a4:	e466                	sd	s9,8(sp)
ffffffffc02012a6:	2f278363          	beq	a5,s2,ffffffffc020158c <default_check+0x30a>
ffffffffc02012aa:	4401                	li	s0,0
ffffffffc02012ac:	4481                	li	s1,0
ffffffffc02012ae:	ff07b703          	ld	a4,-16(a5)
ffffffffc02012b2:	8b09                	andi	a4,a4,2
ffffffffc02012b4:	2e070063          	beqz	a4,ffffffffc0201594 <default_check+0x312>
ffffffffc02012b8:	ff87a703          	lw	a4,-8(a5)
ffffffffc02012bc:	679c                	ld	a5,8(a5)
ffffffffc02012be:	2485                	addiw	s1,s1,1
ffffffffc02012c0:	9c39                	addw	s0,s0,a4
ffffffffc02012c2:	ff2796e3          	bne	a5,s2,ffffffffc02012ae <default_check+0x2c>
ffffffffc02012c6:	89a2                	mv	s3,s0
ffffffffc02012c8:	743000ef          	jal	ffffffffc020220a <nr_free_pages>
ffffffffc02012cc:	73351463          	bne	a0,s3,ffffffffc02019f4 <default_check+0x772>
ffffffffc02012d0:	4505                	li	a0,1
ffffffffc02012d2:	6c7000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc02012d6:	8a2a                	mv	s4,a0
ffffffffc02012d8:	44050e63          	beqz	a0,ffffffffc0201734 <default_check+0x4b2>
ffffffffc02012dc:	4505                	li	a0,1
ffffffffc02012de:	6bb000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc02012e2:	89aa                	mv	s3,a0
ffffffffc02012e4:	72050863          	beqz	a0,ffffffffc0201a14 <default_check+0x792>
ffffffffc02012e8:	4505                	li	a0,1
ffffffffc02012ea:	6af000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc02012ee:	8aaa                	mv	s5,a0
ffffffffc02012f0:	4c050263          	beqz	a0,ffffffffc02017b4 <default_check+0x532>
ffffffffc02012f4:	40a987b3          	sub	a5,s3,a0
ffffffffc02012f8:	40aa0733          	sub	a4,s4,a0
ffffffffc02012fc:	0017b793          	seqz	a5,a5
ffffffffc0201300:	00173713          	seqz	a4,a4
ffffffffc0201304:	8fd9                	or	a5,a5,a4
ffffffffc0201306:	30079763          	bnez	a5,ffffffffc0201614 <default_check+0x392>
ffffffffc020130a:	313a0563          	beq	s4,s3,ffffffffc0201614 <default_check+0x392>
ffffffffc020130e:	000a2783          	lw	a5,0(s4)
ffffffffc0201312:	2a079163          	bnez	a5,ffffffffc02015b4 <default_check+0x332>
ffffffffc0201316:	0009a783          	lw	a5,0(s3)
ffffffffc020131a:	28079d63          	bnez	a5,ffffffffc02015b4 <default_check+0x332>
ffffffffc020131e:	411c                	lw	a5,0(a0)
ffffffffc0201320:	28079a63          	bnez	a5,ffffffffc02015b4 <default_check+0x332>
ffffffffc0201324:	00095797          	auipc	a5,0x95
ffffffffc0201328:	5947b783          	ld	a5,1428(a5) # ffffffffc02968b8 <pages>
ffffffffc020132c:	0000e617          	auipc	a2,0xe
ffffffffc0201330:	2a463603          	ld	a2,676(a2) # ffffffffc020f5d0 <nbase>
ffffffffc0201334:	00095697          	auipc	a3,0x95
ffffffffc0201338:	57c6b683          	ld	a3,1404(a3) # ffffffffc02968b0 <npage>
ffffffffc020133c:	40fa0733          	sub	a4,s4,a5
ffffffffc0201340:	8719                	srai	a4,a4,0x6
ffffffffc0201342:	9732                	add	a4,a4,a2
ffffffffc0201344:	0732                	slli	a4,a4,0xc
ffffffffc0201346:	06b2                	slli	a3,a3,0xc
ffffffffc0201348:	2ad77663          	bgeu	a4,a3,ffffffffc02015f4 <default_check+0x372>
ffffffffc020134c:	40f98733          	sub	a4,s3,a5
ffffffffc0201350:	8719                	srai	a4,a4,0x6
ffffffffc0201352:	9732                	add	a4,a4,a2
ffffffffc0201354:	0732                	slli	a4,a4,0xc
ffffffffc0201356:	4cd77f63          	bgeu	a4,a3,ffffffffc0201834 <default_check+0x5b2>
ffffffffc020135a:	40f507b3          	sub	a5,a0,a5
ffffffffc020135e:	8799                	srai	a5,a5,0x6
ffffffffc0201360:	97b2                	add	a5,a5,a2
ffffffffc0201362:	07b2                	slli	a5,a5,0xc
ffffffffc0201364:	32d7f863          	bgeu	a5,a3,ffffffffc0201694 <default_check+0x412>
ffffffffc0201368:	4505                	li	a0,1
ffffffffc020136a:	00093c03          	ld	s8,0(s2)
ffffffffc020136e:	00893b83          	ld	s7,8(s2)
ffffffffc0201372:	00090b17          	auipc	s6,0x90
ffffffffc0201376:	446b2b03          	lw	s6,1094(s6) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020137a:	01293023          	sd	s2,0(s2)
ffffffffc020137e:	01293423          	sd	s2,8(s2)
ffffffffc0201382:	00090797          	auipc	a5,0x90
ffffffffc0201386:	4207ab23          	sw	zero,1078(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020138a:	60f000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc020138e:	2e051363          	bnez	a0,ffffffffc0201674 <default_check+0x3f2>
ffffffffc0201392:	8552                	mv	a0,s4
ffffffffc0201394:	4585                	li	a1,1
ffffffffc0201396:	63d000ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc020139a:	854e                	mv	a0,s3
ffffffffc020139c:	4585                	li	a1,1
ffffffffc020139e:	635000ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc02013a2:	8556                	mv	a0,s5
ffffffffc02013a4:	4585                	li	a1,1
ffffffffc02013a6:	62d000ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc02013aa:	00090717          	auipc	a4,0x90
ffffffffc02013ae:	40e72703          	lw	a4,1038(a4) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02013b2:	478d                	li	a5,3
ffffffffc02013b4:	2af71063          	bne	a4,a5,ffffffffc0201654 <default_check+0x3d2>
ffffffffc02013b8:	4505                	li	a0,1
ffffffffc02013ba:	5df000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc02013be:	89aa                	mv	s3,a0
ffffffffc02013c0:	26050a63          	beqz	a0,ffffffffc0201634 <default_check+0x3b2>
ffffffffc02013c4:	4505                	li	a0,1
ffffffffc02013c6:	5d3000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc02013ca:	8aaa                	mv	s5,a0
ffffffffc02013cc:	3c050463          	beqz	a0,ffffffffc0201794 <default_check+0x512>
ffffffffc02013d0:	4505                	li	a0,1
ffffffffc02013d2:	5c7000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc02013d6:	8a2a                	mv	s4,a0
ffffffffc02013d8:	38050e63          	beqz	a0,ffffffffc0201774 <default_check+0x4f2>
ffffffffc02013dc:	4505                	li	a0,1
ffffffffc02013de:	5bb000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc02013e2:	36051963          	bnez	a0,ffffffffc0201754 <default_check+0x4d2>
ffffffffc02013e6:	4585                	li	a1,1
ffffffffc02013e8:	854e                	mv	a0,s3
ffffffffc02013ea:	5e9000ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc02013ee:	00893783          	ld	a5,8(s2)
ffffffffc02013f2:	1f278163          	beq	a5,s2,ffffffffc02015d4 <default_check+0x352>
ffffffffc02013f6:	4505                	li	a0,1
ffffffffc02013f8:	5a1000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc02013fc:	8caa                	mv	s9,a0
ffffffffc02013fe:	30a99b63          	bne	s3,a0,ffffffffc0201714 <default_check+0x492>
ffffffffc0201402:	4505                	li	a0,1
ffffffffc0201404:	595000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc0201408:	2e051663          	bnez	a0,ffffffffc02016f4 <default_check+0x472>
ffffffffc020140c:	00090797          	auipc	a5,0x90
ffffffffc0201410:	3ac7a783          	lw	a5,940(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201414:	2c079063          	bnez	a5,ffffffffc02016d4 <default_check+0x452>
ffffffffc0201418:	8566                	mv	a0,s9
ffffffffc020141a:	4585                	li	a1,1
ffffffffc020141c:	01893023          	sd	s8,0(s2)
ffffffffc0201420:	01793423          	sd	s7,8(s2)
ffffffffc0201424:	01692823          	sw	s6,16(s2)
ffffffffc0201428:	5ab000ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc020142c:	8556                	mv	a0,s5
ffffffffc020142e:	4585                	li	a1,1
ffffffffc0201430:	5a3000ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc0201434:	8552                	mv	a0,s4
ffffffffc0201436:	4585                	li	a1,1
ffffffffc0201438:	59b000ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc020143c:	4515                	li	a0,5
ffffffffc020143e:	55b000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc0201442:	89aa                	mv	s3,a0
ffffffffc0201444:	26050863          	beqz	a0,ffffffffc02016b4 <default_check+0x432>
ffffffffc0201448:	651c                	ld	a5,8(a0)
ffffffffc020144a:	8b89                	andi	a5,a5,2
ffffffffc020144c:	54079463          	bnez	a5,ffffffffc0201994 <default_check+0x712>
ffffffffc0201450:	4505                	li	a0,1
ffffffffc0201452:	00093b83          	ld	s7,0(s2)
ffffffffc0201456:	00893b03          	ld	s6,8(s2)
ffffffffc020145a:	01293023          	sd	s2,0(s2)
ffffffffc020145e:	01293423          	sd	s2,8(s2)
ffffffffc0201462:	537000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc0201466:	50051763          	bnez	a0,ffffffffc0201974 <default_check+0x6f2>
ffffffffc020146a:	08098a13          	addi	s4,s3,128
ffffffffc020146e:	8552                	mv	a0,s4
ffffffffc0201470:	458d                	li	a1,3
ffffffffc0201472:	00090c17          	auipc	s8,0x90
ffffffffc0201476:	346c2c03          	lw	s8,838(s8) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020147a:	00090797          	auipc	a5,0x90
ffffffffc020147e:	3207af23          	sw	zero,830(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201482:	551000ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc0201486:	4511                	li	a0,4
ffffffffc0201488:	511000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc020148c:	4c051463          	bnez	a0,ffffffffc0201954 <default_check+0x6d2>
ffffffffc0201490:	0889b783          	ld	a5,136(s3)
ffffffffc0201494:	8b89                	andi	a5,a5,2
ffffffffc0201496:	48078f63          	beqz	a5,ffffffffc0201934 <default_check+0x6b2>
ffffffffc020149a:	0909a503          	lw	a0,144(s3)
ffffffffc020149e:	478d                	li	a5,3
ffffffffc02014a0:	48f51a63          	bne	a0,a5,ffffffffc0201934 <default_check+0x6b2>
ffffffffc02014a4:	4f5000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc02014a8:	8aaa                	mv	s5,a0
ffffffffc02014aa:	46050563          	beqz	a0,ffffffffc0201914 <default_check+0x692>
ffffffffc02014ae:	4505                	li	a0,1
ffffffffc02014b0:	4e9000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc02014b4:	44051063          	bnez	a0,ffffffffc02018f4 <default_check+0x672>
ffffffffc02014b8:	415a1e63          	bne	s4,s5,ffffffffc02018d4 <default_check+0x652>
ffffffffc02014bc:	4585                	li	a1,1
ffffffffc02014be:	854e                	mv	a0,s3
ffffffffc02014c0:	513000ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc02014c4:	8552                	mv	a0,s4
ffffffffc02014c6:	458d                	li	a1,3
ffffffffc02014c8:	50b000ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc02014cc:	0089b783          	ld	a5,8(s3)
ffffffffc02014d0:	8b89                	andi	a5,a5,2
ffffffffc02014d2:	3e078163          	beqz	a5,ffffffffc02018b4 <default_check+0x632>
ffffffffc02014d6:	0109aa83          	lw	s5,16(s3)
ffffffffc02014da:	4785                	li	a5,1
ffffffffc02014dc:	3cfa9c63          	bne	s5,a5,ffffffffc02018b4 <default_check+0x632>
ffffffffc02014e0:	008a3783          	ld	a5,8(s4)
ffffffffc02014e4:	8b89                	andi	a5,a5,2
ffffffffc02014e6:	3a078763          	beqz	a5,ffffffffc0201894 <default_check+0x612>
ffffffffc02014ea:	010a2703          	lw	a4,16(s4)
ffffffffc02014ee:	478d                	li	a5,3
ffffffffc02014f0:	3af71263          	bne	a4,a5,ffffffffc0201894 <default_check+0x612>
ffffffffc02014f4:	8556                	mv	a0,s5
ffffffffc02014f6:	4a3000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc02014fa:	36a99d63          	bne	s3,a0,ffffffffc0201874 <default_check+0x5f2>
ffffffffc02014fe:	85d6                	mv	a1,s5
ffffffffc0201500:	4d3000ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc0201504:	4509                	li	a0,2
ffffffffc0201506:	493000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc020150a:	34aa1563          	bne	s4,a0,ffffffffc0201854 <default_check+0x5d2>
ffffffffc020150e:	4589                	li	a1,2
ffffffffc0201510:	4c3000ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc0201514:	04098513          	addi	a0,s3,64
ffffffffc0201518:	85d6                	mv	a1,s5
ffffffffc020151a:	4b9000ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc020151e:	4515                	li	a0,5
ffffffffc0201520:	479000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc0201524:	89aa                	mv	s3,a0
ffffffffc0201526:	48050763          	beqz	a0,ffffffffc02019b4 <default_check+0x732>
ffffffffc020152a:	8556                	mv	a0,s5
ffffffffc020152c:	46d000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc0201530:	2e051263          	bnez	a0,ffffffffc0201814 <default_check+0x592>
ffffffffc0201534:	00090797          	auipc	a5,0x90
ffffffffc0201538:	2847a783          	lw	a5,644(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020153c:	2a079c63          	bnez	a5,ffffffffc02017f4 <default_check+0x572>
ffffffffc0201540:	854e                	mv	a0,s3
ffffffffc0201542:	4595                	li	a1,5
ffffffffc0201544:	01892823          	sw	s8,16(s2)
ffffffffc0201548:	01793023          	sd	s7,0(s2)
ffffffffc020154c:	01693423          	sd	s6,8(s2)
ffffffffc0201550:	483000ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc0201554:	00893783          	ld	a5,8(s2)
ffffffffc0201558:	01278963          	beq	a5,s2,ffffffffc020156a <default_check+0x2e8>
ffffffffc020155c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201560:	679c                	ld	a5,8(a5)
ffffffffc0201562:	34fd                	addiw	s1,s1,-1
ffffffffc0201564:	9c19                	subw	s0,s0,a4
ffffffffc0201566:	ff279be3          	bne	a5,s2,ffffffffc020155c <default_check+0x2da>
ffffffffc020156a:	26049563          	bnez	s1,ffffffffc02017d4 <default_check+0x552>
ffffffffc020156e:	46041363          	bnez	s0,ffffffffc02019d4 <default_check+0x752>
ffffffffc0201572:	60e6                	ld	ra,88(sp)
ffffffffc0201574:	6446                	ld	s0,80(sp)
ffffffffc0201576:	64a6                	ld	s1,72(sp)
ffffffffc0201578:	6906                	ld	s2,64(sp)
ffffffffc020157a:	79e2                	ld	s3,56(sp)
ffffffffc020157c:	7a42                	ld	s4,48(sp)
ffffffffc020157e:	7aa2                	ld	s5,40(sp)
ffffffffc0201580:	7b02                	ld	s6,32(sp)
ffffffffc0201582:	6be2                	ld	s7,24(sp)
ffffffffc0201584:	6c42                	ld	s8,16(sp)
ffffffffc0201586:	6ca2                	ld	s9,8(sp)
ffffffffc0201588:	6125                	addi	sp,sp,96
ffffffffc020158a:	8082                	ret
ffffffffc020158c:	4981                	li	s3,0
ffffffffc020158e:	4401                	li	s0,0
ffffffffc0201590:	4481                	li	s1,0
ffffffffc0201592:	bb1d                	j	ffffffffc02012c8 <default_check+0x46>
ffffffffc0201594:	0000b697          	auipc	a3,0xb
ffffffffc0201598:	97c68693          	addi	a3,a3,-1668 # ffffffffc020bf10 <etext+0xb0e>
ffffffffc020159c:	0000a617          	auipc	a2,0xa
ffffffffc02015a0:	2a460613          	addi	a2,a2,676 # ffffffffc020b840 <etext+0x43e>
ffffffffc02015a4:	0ef00593          	li	a1,239
ffffffffc02015a8:	0000b517          	auipc	a0,0xb
ffffffffc02015ac:	97850513          	addi	a0,a0,-1672 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc02015b0:	e9bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02015b4:	0000b697          	auipc	a3,0xb
ffffffffc02015b8:	a2c68693          	addi	a3,a3,-1492 # ffffffffc020bfe0 <etext+0xbde>
ffffffffc02015bc:	0000a617          	auipc	a2,0xa
ffffffffc02015c0:	28460613          	addi	a2,a2,644 # ffffffffc020b840 <etext+0x43e>
ffffffffc02015c4:	0bd00593          	li	a1,189
ffffffffc02015c8:	0000b517          	auipc	a0,0xb
ffffffffc02015cc:	95850513          	addi	a0,a0,-1704 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc02015d0:	e7bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02015d4:	0000b697          	auipc	a3,0xb
ffffffffc02015d8:	ad468693          	addi	a3,a3,-1324 # ffffffffc020c0a8 <etext+0xca6>
ffffffffc02015dc:	0000a617          	auipc	a2,0xa
ffffffffc02015e0:	26460613          	addi	a2,a2,612 # ffffffffc020b840 <etext+0x43e>
ffffffffc02015e4:	0d800593          	li	a1,216
ffffffffc02015e8:	0000b517          	auipc	a0,0xb
ffffffffc02015ec:	93850513          	addi	a0,a0,-1736 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc02015f0:	e5bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02015f4:	0000b697          	auipc	a3,0xb
ffffffffc02015f8:	a2c68693          	addi	a3,a3,-1492 # ffffffffc020c020 <etext+0xc1e>
ffffffffc02015fc:	0000a617          	auipc	a2,0xa
ffffffffc0201600:	24460613          	addi	a2,a2,580 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201604:	0bf00593          	li	a1,191
ffffffffc0201608:	0000b517          	auipc	a0,0xb
ffffffffc020160c:	91850513          	addi	a0,a0,-1768 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201610:	e3bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201614:	0000b697          	auipc	a3,0xb
ffffffffc0201618:	9a468693          	addi	a3,a3,-1628 # ffffffffc020bfb8 <etext+0xbb6>
ffffffffc020161c:	0000a617          	auipc	a2,0xa
ffffffffc0201620:	22460613          	addi	a2,a2,548 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201624:	0bc00593          	li	a1,188
ffffffffc0201628:	0000b517          	auipc	a0,0xb
ffffffffc020162c:	8f850513          	addi	a0,a0,-1800 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201630:	e1bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201634:	0000b697          	auipc	a3,0xb
ffffffffc0201638:	92468693          	addi	a3,a3,-1756 # ffffffffc020bf58 <etext+0xb56>
ffffffffc020163c:	0000a617          	auipc	a2,0xa
ffffffffc0201640:	20460613          	addi	a2,a2,516 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201644:	0d100593          	li	a1,209
ffffffffc0201648:	0000b517          	auipc	a0,0xb
ffffffffc020164c:	8d850513          	addi	a0,a0,-1832 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201650:	dfbfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201654:	0000b697          	auipc	a3,0xb
ffffffffc0201658:	a4468693          	addi	a3,a3,-1468 # ffffffffc020c098 <etext+0xc96>
ffffffffc020165c:	0000a617          	auipc	a2,0xa
ffffffffc0201660:	1e460613          	addi	a2,a2,484 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201664:	0cf00593          	li	a1,207
ffffffffc0201668:	0000b517          	auipc	a0,0xb
ffffffffc020166c:	8b850513          	addi	a0,a0,-1864 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201670:	ddbfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201674:	0000b697          	auipc	a3,0xb
ffffffffc0201678:	a0c68693          	addi	a3,a3,-1524 # ffffffffc020c080 <etext+0xc7e>
ffffffffc020167c:	0000a617          	auipc	a2,0xa
ffffffffc0201680:	1c460613          	addi	a2,a2,452 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201684:	0ca00593          	li	a1,202
ffffffffc0201688:	0000b517          	auipc	a0,0xb
ffffffffc020168c:	89850513          	addi	a0,a0,-1896 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201690:	dbbfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201694:	0000b697          	auipc	a3,0xb
ffffffffc0201698:	9cc68693          	addi	a3,a3,-1588 # ffffffffc020c060 <etext+0xc5e>
ffffffffc020169c:	0000a617          	auipc	a2,0xa
ffffffffc02016a0:	1a460613          	addi	a2,a2,420 # ffffffffc020b840 <etext+0x43e>
ffffffffc02016a4:	0c100593          	li	a1,193
ffffffffc02016a8:	0000b517          	auipc	a0,0xb
ffffffffc02016ac:	87850513          	addi	a0,a0,-1928 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc02016b0:	d9bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02016b4:	0000b697          	auipc	a3,0xb
ffffffffc02016b8:	a3c68693          	addi	a3,a3,-1476 # ffffffffc020c0f0 <etext+0xcee>
ffffffffc02016bc:	0000a617          	auipc	a2,0xa
ffffffffc02016c0:	18460613          	addi	a2,a2,388 # ffffffffc020b840 <etext+0x43e>
ffffffffc02016c4:	0f700593          	li	a1,247
ffffffffc02016c8:	0000b517          	auipc	a0,0xb
ffffffffc02016cc:	85850513          	addi	a0,a0,-1960 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc02016d0:	d7bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02016d4:	0000b697          	auipc	a3,0xb
ffffffffc02016d8:	a0c68693          	addi	a3,a3,-1524 # ffffffffc020c0e0 <etext+0xcde>
ffffffffc02016dc:	0000a617          	auipc	a2,0xa
ffffffffc02016e0:	16460613          	addi	a2,a2,356 # ffffffffc020b840 <etext+0x43e>
ffffffffc02016e4:	0de00593          	li	a1,222
ffffffffc02016e8:	0000b517          	auipc	a0,0xb
ffffffffc02016ec:	83850513          	addi	a0,a0,-1992 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc02016f0:	d5bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02016f4:	0000b697          	auipc	a3,0xb
ffffffffc02016f8:	98c68693          	addi	a3,a3,-1652 # ffffffffc020c080 <etext+0xc7e>
ffffffffc02016fc:	0000a617          	auipc	a2,0xa
ffffffffc0201700:	14460613          	addi	a2,a2,324 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201704:	0dc00593          	li	a1,220
ffffffffc0201708:	0000b517          	auipc	a0,0xb
ffffffffc020170c:	81850513          	addi	a0,a0,-2024 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201710:	d3bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201714:	0000b697          	auipc	a3,0xb
ffffffffc0201718:	9ac68693          	addi	a3,a3,-1620 # ffffffffc020c0c0 <etext+0xcbe>
ffffffffc020171c:	0000a617          	auipc	a2,0xa
ffffffffc0201720:	12460613          	addi	a2,a2,292 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201724:	0db00593          	li	a1,219
ffffffffc0201728:	0000a517          	auipc	a0,0xa
ffffffffc020172c:	7f850513          	addi	a0,a0,2040 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201730:	d1bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201734:	0000b697          	auipc	a3,0xb
ffffffffc0201738:	82468693          	addi	a3,a3,-2012 # ffffffffc020bf58 <etext+0xb56>
ffffffffc020173c:	0000a617          	auipc	a2,0xa
ffffffffc0201740:	10460613          	addi	a2,a2,260 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201744:	0b800593          	li	a1,184
ffffffffc0201748:	0000a517          	auipc	a0,0xa
ffffffffc020174c:	7d850513          	addi	a0,a0,2008 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201750:	cfbfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201754:	0000b697          	auipc	a3,0xb
ffffffffc0201758:	92c68693          	addi	a3,a3,-1748 # ffffffffc020c080 <etext+0xc7e>
ffffffffc020175c:	0000a617          	auipc	a2,0xa
ffffffffc0201760:	0e460613          	addi	a2,a2,228 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201764:	0d500593          	li	a1,213
ffffffffc0201768:	0000a517          	auipc	a0,0xa
ffffffffc020176c:	7b850513          	addi	a0,a0,1976 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201770:	cdbfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201774:	0000b697          	auipc	a3,0xb
ffffffffc0201778:	82468693          	addi	a3,a3,-2012 # ffffffffc020bf98 <etext+0xb96>
ffffffffc020177c:	0000a617          	auipc	a2,0xa
ffffffffc0201780:	0c460613          	addi	a2,a2,196 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201784:	0d300593          	li	a1,211
ffffffffc0201788:	0000a517          	auipc	a0,0xa
ffffffffc020178c:	79850513          	addi	a0,a0,1944 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201790:	cbbfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201794:	0000a697          	auipc	a3,0xa
ffffffffc0201798:	7e468693          	addi	a3,a3,2020 # ffffffffc020bf78 <etext+0xb76>
ffffffffc020179c:	0000a617          	auipc	a2,0xa
ffffffffc02017a0:	0a460613          	addi	a2,a2,164 # ffffffffc020b840 <etext+0x43e>
ffffffffc02017a4:	0d200593          	li	a1,210
ffffffffc02017a8:	0000a517          	auipc	a0,0xa
ffffffffc02017ac:	77850513          	addi	a0,a0,1912 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc02017b0:	c9bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02017b4:	0000a697          	auipc	a3,0xa
ffffffffc02017b8:	7e468693          	addi	a3,a3,2020 # ffffffffc020bf98 <etext+0xb96>
ffffffffc02017bc:	0000a617          	auipc	a2,0xa
ffffffffc02017c0:	08460613          	addi	a2,a2,132 # ffffffffc020b840 <etext+0x43e>
ffffffffc02017c4:	0ba00593          	li	a1,186
ffffffffc02017c8:	0000a517          	auipc	a0,0xa
ffffffffc02017cc:	75850513          	addi	a0,a0,1880 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc02017d0:	c7bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02017d4:	0000b697          	auipc	a3,0xb
ffffffffc02017d8:	a6c68693          	addi	a3,a3,-1428 # ffffffffc020c240 <etext+0xe3e>
ffffffffc02017dc:	0000a617          	auipc	a2,0xa
ffffffffc02017e0:	06460613          	addi	a2,a2,100 # ffffffffc020b840 <etext+0x43e>
ffffffffc02017e4:	12400593          	li	a1,292
ffffffffc02017e8:	0000a517          	auipc	a0,0xa
ffffffffc02017ec:	73850513          	addi	a0,a0,1848 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc02017f0:	c5bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02017f4:	0000b697          	auipc	a3,0xb
ffffffffc02017f8:	8ec68693          	addi	a3,a3,-1812 # ffffffffc020c0e0 <etext+0xcde>
ffffffffc02017fc:	0000a617          	auipc	a2,0xa
ffffffffc0201800:	04460613          	addi	a2,a2,68 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201804:	11900593          	li	a1,281
ffffffffc0201808:	0000a517          	auipc	a0,0xa
ffffffffc020180c:	71850513          	addi	a0,a0,1816 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201810:	c3bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201814:	0000b697          	auipc	a3,0xb
ffffffffc0201818:	86c68693          	addi	a3,a3,-1940 # ffffffffc020c080 <etext+0xc7e>
ffffffffc020181c:	0000a617          	auipc	a2,0xa
ffffffffc0201820:	02460613          	addi	a2,a2,36 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201824:	11700593          	li	a1,279
ffffffffc0201828:	0000a517          	auipc	a0,0xa
ffffffffc020182c:	6f850513          	addi	a0,a0,1784 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201830:	c1bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201834:	0000b697          	auipc	a3,0xb
ffffffffc0201838:	80c68693          	addi	a3,a3,-2036 # ffffffffc020c040 <etext+0xc3e>
ffffffffc020183c:	0000a617          	auipc	a2,0xa
ffffffffc0201840:	00460613          	addi	a2,a2,4 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201844:	0c000593          	li	a1,192
ffffffffc0201848:	0000a517          	auipc	a0,0xa
ffffffffc020184c:	6d850513          	addi	a0,a0,1752 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201850:	bfbfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201854:	0000b697          	auipc	a3,0xb
ffffffffc0201858:	9ac68693          	addi	a3,a3,-1620 # ffffffffc020c200 <etext+0xdfe>
ffffffffc020185c:	0000a617          	auipc	a2,0xa
ffffffffc0201860:	fe460613          	addi	a2,a2,-28 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201864:	11100593          	li	a1,273
ffffffffc0201868:	0000a517          	auipc	a0,0xa
ffffffffc020186c:	6b850513          	addi	a0,a0,1720 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201870:	bdbfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201874:	0000b697          	auipc	a3,0xb
ffffffffc0201878:	96c68693          	addi	a3,a3,-1684 # ffffffffc020c1e0 <etext+0xdde>
ffffffffc020187c:	0000a617          	auipc	a2,0xa
ffffffffc0201880:	fc460613          	addi	a2,a2,-60 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201884:	10f00593          	li	a1,271
ffffffffc0201888:	0000a517          	auipc	a0,0xa
ffffffffc020188c:	69850513          	addi	a0,a0,1688 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201890:	bbbfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201894:	0000b697          	auipc	a3,0xb
ffffffffc0201898:	92468693          	addi	a3,a3,-1756 # ffffffffc020c1b8 <etext+0xdb6>
ffffffffc020189c:	0000a617          	auipc	a2,0xa
ffffffffc02018a0:	fa460613          	addi	a2,a2,-92 # ffffffffc020b840 <etext+0x43e>
ffffffffc02018a4:	10d00593          	li	a1,269
ffffffffc02018a8:	0000a517          	auipc	a0,0xa
ffffffffc02018ac:	67850513          	addi	a0,a0,1656 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc02018b0:	b9bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02018b4:	0000b697          	auipc	a3,0xb
ffffffffc02018b8:	8dc68693          	addi	a3,a3,-1828 # ffffffffc020c190 <etext+0xd8e>
ffffffffc02018bc:	0000a617          	auipc	a2,0xa
ffffffffc02018c0:	f8460613          	addi	a2,a2,-124 # ffffffffc020b840 <etext+0x43e>
ffffffffc02018c4:	10c00593          	li	a1,268
ffffffffc02018c8:	0000a517          	auipc	a0,0xa
ffffffffc02018cc:	65850513          	addi	a0,a0,1624 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc02018d0:	b7bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02018d4:	0000b697          	auipc	a3,0xb
ffffffffc02018d8:	8ac68693          	addi	a3,a3,-1876 # ffffffffc020c180 <etext+0xd7e>
ffffffffc02018dc:	0000a617          	auipc	a2,0xa
ffffffffc02018e0:	f6460613          	addi	a2,a2,-156 # ffffffffc020b840 <etext+0x43e>
ffffffffc02018e4:	10700593          	li	a1,263
ffffffffc02018e8:	0000a517          	auipc	a0,0xa
ffffffffc02018ec:	63850513          	addi	a0,a0,1592 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc02018f0:	b5bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02018f4:	0000a697          	auipc	a3,0xa
ffffffffc02018f8:	78c68693          	addi	a3,a3,1932 # ffffffffc020c080 <etext+0xc7e>
ffffffffc02018fc:	0000a617          	auipc	a2,0xa
ffffffffc0201900:	f4460613          	addi	a2,a2,-188 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201904:	10600593          	li	a1,262
ffffffffc0201908:	0000a517          	auipc	a0,0xa
ffffffffc020190c:	61850513          	addi	a0,a0,1560 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201910:	b3bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201914:	0000b697          	auipc	a3,0xb
ffffffffc0201918:	84c68693          	addi	a3,a3,-1972 # ffffffffc020c160 <etext+0xd5e>
ffffffffc020191c:	0000a617          	auipc	a2,0xa
ffffffffc0201920:	f2460613          	addi	a2,a2,-220 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201924:	10500593          	li	a1,261
ffffffffc0201928:	0000a517          	auipc	a0,0xa
ffffffffc020192c:	5f850513          	addi	a0,a0,1528 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201930:	b1bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201934:	0000a697          	auipc	a3,0xa
ffffffffc0201938:	7fc68693          	addi	a3,a3,2044 # ffffffffc020c130 <etext+0xd2e>
ffffffffc020193c:	0000a617          	auipc	a2,0xa
ffffffffc0201940:	f0460613          	addi	a2,a2,-252 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201944:	10400593          	li	a1,260
ffffffffc0201948:	0000a517          	auipc	a0,0xa
ffffffffc020194c:	5d850513          	addi	a0,a0,1496 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201950:	afbfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201954:	0000a697          	auipc	a3,0xa
ffffffffc0201958:	7c468693          	addi	a3,a3,1988 # ffffffffc020c118 <etext+0xd16>
ffffffffc020195c:	0000a617          	auipc	a2,0xa
ffffffffc0201960:	ee460613          	addi	a2,a2,-284 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201964:	10300593          	li	a1,259
ffffffffc0201968:	0000a517          	auipc	a0,0xa
ffffffffc020196c:	5b850513          	addi	a0,a0,1464 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201970:	adbfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201974:	0000a697          	auipc	a3,0xa
ffffffffc0201978:	70c68693          	addi	a3,a3,1804 # ffffffffc020c080 <etext+0xc7e>
ffffffffc020197c:	0000a617          	auipc	a2,0xa
ffffffffc0201980:	ec460613          	addi	a2,a2,-316 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201984:	0fd00593          	li	a1,253
ffffffffc0201988:	0000a517          	auipc	a0,0xa
ffffffffc020198c:	59850513          	addi	a0,a0,1432 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201990:	abbfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201994:	0000a697          	auipc	a3,0xa
ffffffffc0201998:	76c68693          	addi	a3,a3,1900 # ffffffffc020c100 <etext+0xcfe>
ffffffffc020199c:	0000a617          	auipc	a2,0xa
ffffffffc02019a0:	ea460613          	addi	a2,a2,-348 # ffffffffc020b840 <etext+0x43e>
ffffffffc02019a4:	0f800593          	li	a1,248
ffffffffc02019a8:	0000a517          	auipc	a0,0xa
ffffffffc02019ac:	57850513          	addi	a0,a0,1400 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc02019b0:	a9bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02019b4:	0000b697          	auipc	a3,0xb
ffffffffc02019b8:	86c68693          	addi	a3,a3,-1940 # ffffffffc020c220 <etext+0xe1e>
ffffffffc02019bc:	0000a617          	auipc	a2,0xa
ffffffffc02019c0:	e8460613          	addi	a2,a2,-380 # ffffffffc020b840 <etext+0x43e>
ffffffffc02019c4:	11600593          	li	a1,278
ffffffffc02019c8:	0000a517          	auipc	a0,0xa
ffffffffc02019cc:	55850513          	addi	a0,a0,1368 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc02019d0:	a7bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02019d4:	0000b697          	auipc	a3,0xb
ffffffffc02019d8:	87c68693          	addi	a3,a3,-1924 # ffffffffc020c250 <etext+0xe4e>
ffffffffc02019dc:	0000a617          	auipc	a2,0xa
ffffffffc02019e0:	e6460613          	addi	a2,a2,-412 # ffffffffc020b840 <etext+0x43e>
ffffffffc02019e4:	12500593          	li	a1,293
ffffffffc02019e8:	0000a517          	auipc	a0,0xa
ffffffffc02019ec:	53850513          	addi	a0,a0,1336 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc02019f0:	a5bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02019f4:	0000a697          	auipc	a3,0xa
ffffffffc02019f8:	54468693          	addi	a3,a3,1348 # ffffffffc020bf38 <etext+0xb36>
ffffffffc02019fc:	0000a617          	auipc	a2,0xa
ffffffffc0201a00:	e4460613          	addi	a2,a2,-444 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201a04:	0f200593          	li	a1,242
ffffffffc0201a08:	0000a517          	auipc	a0,0xa
ffffffffc0201a0c:	51850513          	addi	a0,a0,1304 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201a10:	a3bfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201a14:	0000a697          	auipc	a3,0xa
ffffffffc0201a18:	56468693          	addi	a3,a3,1380 # ffffffffc020bf78 <etext+0xb76>
ffffffffc0201a1c:	0000a617          	auipc	a2,0xa
ffffffffc0201a20:	e2460613          	addi	a2,a2,-476 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201a24:	0b900593          	li	a1,185
ffffffffc0201a28:	0000a517          	auipc	a0,0xa
ffffffffc0201a2c:	4f850513          	addi	a0,a0,1272 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201a30:	a1bfe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201a34 <default_free_pages>:
ffffffffc0201a34:	1141                	addi	sp,sp,-16
ffffffffc0201a36:	e406                	sd	ra,8(sp)
ffffffffc0201a38:	14058663          	beqz	a1,ffffffffc0201b84 <default_free_pages+0x150>
ffffffffc0201a3c:	00659713          	slli	a4,a1,0x6
ffffffffc0201a40:	00e506b3          	add	a3,a0,a4
ffffffffc0201a44:	87aa                	mv	a5,a0
ffffffffc0201a46:	c30d                	beqz	a4,ffffffffc0201a68 <default_free_pages+0x34>
ffffffffc0201a48:	6798                	ld	a4,8(a5)
ffffffffc0201a4a:	8b05                	andi	a4,a4,1
ffffffffc0201a4c:	10071c63          	bnez	a4,ffffffffc0201b64 <default_free_pages+0x130>
ffffffffc0201a50:	6798                	ld	a4,8(a5)
ffffffffc0201a52:	8b09                	andi	a4,a4,2
ffffffffc0201a54:	10071863          	bnez	a4,ffffffffc0201b64 <default_free_pages+0x130>
ffffffffc0201a58:	0007b423          	sd	zero,8(a5)
ffffffffc0201a5c:	0007a023          	sw	zero,0(a5)
ffffffffc0201a60:	04078793          	addi	a5,a5,64
ffffffffc0201a64:	fed792e3          	bne	a5,a3,ffffffffc0201a48 <default_free_pages+0x14>
ffffffffc0201a68:	c90c                	sw	a1,16(a0)
ffffffffc0201a6a:	00850893          	addi	a7,a0,8
ffffffffc0201a6e:	4789                	li	a5,2
ffffffffc0201a70:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc0201a74:	00090717          	auipc	a4,0x90
ffffffffc0201a78:	d4472703          	lw	a4,-700(a4) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201a7c:	00090697          	auipc	a3,0x90
ffffffffc0201a80:	d2c68693          	addi	a3,a3,-724 # ffffffffc02917a8 <free_area>
ffffffffc0201a84:	669c                	ld	a5,8(a3)
ffffffffc0201a86:	9f2d                	addw	a4,a4,a1
ffffffffc0201a88:	ca98                	sw	a4,16(a3)
ffffffffc0201a8a:	0ad78163          	beq	a5,a3,ffffffffc0201b2c <default_free_pages+0xf8>
ffffffffc0201a8e:	fe878713          	addi	a4,a5,-24
ffffffffc0201a92:	4581                	li	a1,0
ffffffffc0201a94:	01850613          	addi	a2,a0,24
ffffffffc0201a98:	00e56a63          	bltu	a0,a4,ffffffffc0201aac <default_free_pages+0x78>
ffffffffc0201a9c:	6798                	ld	a4,8(a5)
ffffffffc0201a9e:	04d70c63          	beq	a4,a3,ffffffffc0201af6 <default_free_pages+0xc2>
ffffffffc0201aa2:	87ba                	mv	a5,a4
ffffffffc0201aa4:	fe878713          	addi	a4,a5,-24
ffffffffc0201aa8:	fee57ae3          	bgeu	a0,a4,ffffffffc0201a9c <default_free_pages+0x68>
ffffffffc0201aac:	c199                	beqz	a1,ffffffffc0201ab2 <default_free_pages+0x7e>
ffffffffc0201aae:	0106b023          	sd	a6,0(a3)
ffffffffc0201ab2:	6398                	ld	a4,0(a5)
ffffffffc0201ab4:	e390                	sd	a2,0(a5)
ffffffffc0201ab6:	e710                	sd	a2,8(a4)
ffffffffc0201ab8:	ed18                	sd	a4,24(a0)
ffffffffc0201aba:	f11c                	sd	a5,32(a0)
ffffffffc0201abc:	00d70d63          	beq	a4,a3,ffffffffc0201ad6 <default_free_pages+0xa2>
ffffffffc0201ac0:	ff872583          	lw	a1,-8(a4)
ffffffffc0201ac4:	fe870613          	addi	a2,a4,-24
ffffffffc0201ac8:	02059813          	slli	a6,a1,0x20
ffffffffc0201acc:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201ad0:	97b2                	add	a5,a5,a2
ffffffffc0201ad2:	02f50c63          	beq	a0,a5,ffffffffc0201b0a <default_free_pages+0xd6>
ffffffffc0201ad6:	711c                	ld	a5,32(a0)
ffffffffc0201ad8:	00d78c63          	beq	a5,a3,ffffffffc0201af0 <default_free_pages+0xbc>
ffffffffc0201adc:	4910                	lw	a2,16(a0)
ffffffffc0201ade:	fe878693          	addi	a3,a5,-24
ffffffffc0201ae2:	02061593          	slli	a1,a2,0x20
ffffffffc0201ae6:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201aea:	972a                	add	a4,a4,a0
ffffffffc0201aec:	04e68c63          	beq	a3,a4,ffffffffc0201b44 <default_free_pages+0x110>
ffffffffc0201af0:	60a2                	ld	ra,8(sp)
ffffffffc0201af2:	0141                	addi	sp,sp,16
ffffffffc0201af4:	8082                	ret
ffffffffc0201af6:	e790                	sd	a2,8(a5)
ffffffffc0201af8:	f114                	sd	a3,32(a0)
ffffffffc0201afa:	6798                	ld	a4,8(a5)
ffffffffc0201afc:	ed1c                	sd	a5,24(a0)
ffffffffc0201afe:	8832                	mv	a6,a2
ffffffffc0201b00:	02d70f63          	beq	a4,a3,ffffffffc0201b3e <default_free_pages+0x10a>
ffffffffc0201b04:	4585                	li	a1,1
ffffffffc0201b06:	87ba                	mv	a5,a4
ffffffffc0201b08:	bf71                	j	ffffffffc0201aa4 <default_free_pages+0x70>
ffffffffc0201b0a:	491c                	lw	a5,16(a0)
ffffffffc0201b0c:	5875                	li	a6,-3
ffffffffc0201b0e:	9fad                	addw	a5,a5,a1
ffffffffc0201b10:	fef72c23          	sw	a5,-8(a4)
ffffffffc0201b14:	6108b02f          	amoand.d	zero,a6,(a7)
ffffffffc0201b18:	01853803          	ld	a6,24(a0)
ffffffffc0201b1c:	710c                	ld	a1,32(a0)
ffffffffc0201b1e:	8532                	mv	a0,a2
ffffffffc0201b20:	00b83423          	sd	a1,8(a6)
ffffffffc0201b24:	671c                	ld	a5,8(a4)
ffffffffc0201b26:	0105b023          	sd	a6,0(a1)
ffffffffc0201b2a:	b77d                	j	ffffffffc0201ad8 <default_free_pages+0xa4>
ffffffffc0201b2c:	60a2                	ld	ra,8(sp)
ffffffffc0201b2e:	01850713          	addi	a4,a0,24
ffffffffc0201b32:	f11c                	sd	a5,32(a0)
ffffffffc0201b34:	ed1c                	sd	a5,24(a0)
ffffffffc0201b36:	e398                	sd	a4,0(a5)
ffffffffc0201b38:	e798                	sd	a4,8(a5)
ffffffffc0201b3a:	0141                	addi	sp,sp,16
ffffffffc0201b3c:	8082                	ret
ffffffffc0201b3e:	e290                	sd	a2,0(a3)
ffffffffc0201b40:	873e                	mv	a4,a5
ffffffffc0201b42:	bfad                	j	ffffffffc0201abc <default_free_pages+0x88>
ffffffffc0201b44:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201b48:	56f5                	li	a3,-3
ffffffffc0201b4a:	9f31                	addw	a4,a4,a2
ffffffffc0201b4c:	c918                	sw	a4,16(a0)
ffffffffc0201b4e:	ff078713          	addi	a4,a5,-16
ffffffffc0201b52:	60d7302f          	amoand.d	zero,a3,(a4)
ffffffffc0201b56:	6398                	ld	a4,0(a5)
ffffffffc0201b58:	679c                	ld	a5,8(a5)
ffffffffc0201b5a:	60a2                	ld	ra,8(sp)
ffffffffc0201b5c:	e71c                	sd	a5,8(a4)
ffffffffc0201b5e:	e398                	sd	a4,0(a5)
ffffffffc0201b60:	0141                	addi	sp,sp,16
ffffffffc0201b62:	8082                	ret
ffffffffc0201b64:	0000a697          	auipc	a3,0xa
ffffffffc0201b68:	70468693          	addi	a3,a3,1796 # ffffffffc020c268 <etext+0xe66>
ffffffffc0201b6c:	0000a617          	auipc	a2,0xa
ffffffffc0201b70:	cd460613          	addi	a2,a2,-812 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201b74:	08200593          	li	a1,130
ffffffffc0201b78:	0000a517          	auipc	a0,0xa
ffffffffc0201b7c:	3a850513          	addi	a0,a0,936 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201b80:	8cbfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201b84:	0000a697          	auipc	a3,0xa
ffffffffc0201b88:	6dc68693          	addi	a3,a3,1756 # ffffffffc020c260 <etext+0xe5e>
ffffffffc0201b8c:	0000a617          	auipc	a2,0xa
ffffffffc0201b90:	cb460613          	addi	a2,a2,-844 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201b94:	07f00593          	li	a1,127
ffffffffc0201b98:	0000a517          	auipc	a0,0xa
ffffffffc0201b9c:	38850513          	addi	a0,a0,904 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201ba0:	8abfe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201ba4 <default_alloc_pages>:
ffffffffc0201ba4:	c951                	beqz	a0,ffffffffc0201c38 <default_alloc_pages+0x94>
ffffffffc0201ba6:	00090597          	auipc	a1,0x90
ffffffffc0201baa:	c125a583          	lw	a1,-1006(a1) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201bae:	86aa                	mv	a3,a0
ffffffffc0201bb0:	02059793          	slli	a5,a1,0x20
ffffffffc0201bb4:	9381                	srli	a5,a5,0x20
ffffffffc0201bb6:	00a7ef63          	bltu	a5,a0,ffffffffc0201bd4 <default_alloc_pages+0x30>
ffffffffc0201bba:	00090617          	auipc	a2,0x90
ffffffffc0201bbe:	bee60613          	addi	a2,a2,-1042 # ffffffffc02917a8 <free_area>
ffffffffc0201bc2:	87b2                	mv	a5,a2
ffffffffc0201bc4:	a029                	j	ffffffffc0201bce <default_alloc_pages+0x2a>
ffffffffc0201bc6:	ff87e703          	lwu	a4,-8(a5)
ffffffffc0201bca:	00d77763          	bgeu	a4,a3,ffffffffc0201bd8 <default_alloc_pages+0x34>
ffffffffc0201bce:	679c                	ld	a5,8(a5)
ffffffffc0201bd0:	fec79be3          	bne	a5,a2,ffffffffc0201bc6 <default_alloc_pages+0x22>
ffffffffc0201bd4:	4501                	li	a0,0
ffffffffc0201bd6:	8082                	ret
ffffffffc0201bd8:	ff87a883          	lw	a7,-8(a5)
ffffffffc0201bdc:	0007b803          	ld	a6,0(a5)
ffffffffc0201be0:	6798                	ld	a4,8(a5)
ffffffffc0201be2:	02089313          	slli	t1,a7,0x20
ffffffffc0201be6:	02035313          	srli	t1,t1,0x20
ffffffffc0201bea:	00e83423          	sd	a4,8(a6)
ffffffffc0201bee:	01073023          	sd	a6,0(a4)
ffffffffc0201bf2:	fe878513          	addi	a0,a5,-24
ffffffffc0201bf6:	0266fa63          	bgeu	a3,t1,ffffffffc0201c2a <default_alloc_pages+0x86>
ffffffffc0201bfa:	00669713          	slli	a4,a3,0x6
ffffffffc0201bfe:	40d888bb          	subw	a7,a7,a3
ffffffffc0201c02:	972a                	add	a4,a4,a0
ffffffffc0201c04:	01172823          	sw	a7,16(a4)
ffffffffc0201c08:	00870313          	addi	t1,a4,8
ffffffffc0201c0c:	4889                	li	a7,2
ffffffffc0201c0e:	4113302f          	amoor.d	zero,a7,(t1)
ffffffffc0201c12:	00883883          	ld	a7,8(a6)
ffffffffc0201c16:	01870313          	addi	t1,a4,24
ffffffffc0201c1a:	0068b023          	sd	t1,0(a7) # 10000000 <_binary_bin_sfs_img_size+0xff8ad00>
ffffffffc0201c1e:	00683423          	sd	t1,8(a6)
ffffffffc0201c22:	03173023          	sd	a7,32(a4)
ffffffffc0201c26:	01073c23          	sd	a6,24(a4)
ffffffffc0201c2a:	9d95                	subw	a1,a1,a3
ffffffffc0201c2c:	ca0c                	sw	a1,16(a2)
ffffffffc0201c2e:	5775                	li	a4,-3
ffffffffc0201c30:	17c1                	addi	a5,a5,-16
ffffffffc0201c32:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0201c36:	8082                	ret
ffffffffc0201c38:	1141                	addi	sp,sp,-16
ffffffffc0201c3a:	0000a697          	auipc	a3,0xa
ffffffffc0201c3e:	62668693          	addi	a3,a3,1574 # ffffffffc020c260 <etext+0xe5e>
ffffffffc0201c42:	0000a617          	auipc	a2,0xa
ffffffffc0201c46:	bfe60613          	addi	a2,a2,-1026 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201c4a:	06100593          	li	a1,97
ffffffffc0201c4e:	0000a517          	auipc	a0,0xa
ffffffffc0201c52:	2d250513          	addi	a0,a0,722 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201c56:	e406                	sd	ra,8(sp)
ffffffffc0201c58:	ff2fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201c5c <default_init_memmap>:
ffffffffc0201c5c:	1141                	addi	sp,sp,-16
ffffffffc0201c5e:	e406                	sd	ra,8(sp)
ffffffffc0201c60:	c9e1                	beqz	a1,ffffffffc0201d30 <default_init_memmap+0xd4>
ffffffffc0201c62:	00659713          	slli	a4,a1,0x6
ffffffffc0201c66:	00e506b3          	add	a3,a0,a4
ffffffffc0201c6a:	87aa                	mv	a5,a0
ffffffffc0201c6c:	cf11                	beqz	a4,ffffffffc0201c88 <default_init_memmap+0x2c>
ffffffffc0201c6e:	6798                	ld	a4,8(a5)
ffffffffc0201c70:	8b05                	andi	a4,a4,1
ffffffffc0201c72:	cf59                	beqz	a4,ffffffffc0201d10 <default_init_memmap+0xb4>
ffffffffc0201c74:	0007a823          	sw	zero,16(a5)
ffffffffc0201c78:	0007b423          	sd	zero,8(a5)
ffffffffc0201c7c:	0007a023          	sw	zero,0(a5)
ffffffffc0201c80:	04078793          	addi	a5,a5,64
ffffffffc0201c84:	fed795e3          	bne	a5,a3,ffffffffc0201c6e <default_init_memmap+0x12>
ffffffffc0201c88:	c90c                	sw	a1,16(a0)
ffffffffc0201c8a:	4789                	li	a5,2
ffffffffc0201c8c:	00850713          	addi	a4,a0,8
ffffffffc0201c90:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0201c94:	00090717          	auipc	a4,0x90
ffffffffc0201c98:	b2472703          	lw	a4,-1244(a4) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201c9c:	00090697          	auipc	a3,0x90
ffffffffc0201ca0:	b0c68693          	addi	a3,a3,-1268 # ffffffffc02917a8 <free_area>
ffffffffc0201ca4:	669c                	ld	a5,8(a3)
ffffffffc0201ca6:	9f2d                	addw	a4,a4,a1
ffffffffc0201ca8:	ca98                	sw	a4,16(a3)
ffffffffc0201caa:	04d78663          	beq	a5,a3,ffffffffc0201cf6 <default_init_memmap+0x9a>
ffffffffc0201cae:	fe878713          	addi	a4,a5,-24
ffffffffc0201cb2:	4581                	li	a1,0
ffffffffc0201cb4:	01850613          	addi	a2,a0,24
ffffffffc0201cb8:	00e56a63          	bltu	a0,a4,ffffffffc0201ccc <default_init_memmap+0x70>
ffffffffc0201cbc:	6798                	ld	a4,8(a5)
ffffffffc0201cbe:	02d70263          	beq	a4,a3,ffffffffc0201ce2 <default_init_memmap+0x86>
ffffffffc0201cc2:	87ba                	mv	a5,a4
ffffffffc0201cc4:	fe878713          	addi	a4,a5,-24
ffffffffc0201cc8:	fee57ae3          	bgeu	a0,a4,ffffffffc0201cbc <default_init_memmap+0x60>
ffffffffc0201ccc:	c199                	beqz	a1,ffffffffc0201cd2 <default_init_memmap+0x76>
ffffffffc0201cce:	0106b023          	sd	a6,0(a3)
ffffffffc0201cd2:	6398                	ld	a4,0(a5)
ffffffffc0201cd4:	60a2                	ld	ra,8(sp)
ffffffffc0201cd6:	e390                	sd	a2,0(a5)
ffffffffc0201cd8:	e710                	sd	a2,8(a4)
ffffffffc0201cda:	ed18                	sd	a4,24(a0)
ffffffffc0201cdc:	f11c                	sd	a5,32(a0)
ffffffffc0201cde:	0141                	addi	sp,sp,16
ffffffffc0201ce0:	8082                	ret
ffffffffc0201ce2:	e790                	sd	a2,8(a5)
ffffffffc0201ce4:	f114                	sd	a3,32(a0)
ffffffffc0201ce6:	6798                	ld	a4,8(a5)
ffffffffc0201ce8:	ed1c                	sd	a5,24(a0)
ffffffffc0201cea:	8832                	mv	a6,a2
ffffffffc0201cec:	00d70e63          	beq	a4,a3,ffffffffc0201d08 <default_init_memmap+0xac>
ffffffffc0201cf0:	4585                	li	a1,1
ffffffffc0201cf2:	87ba                	mv	a5,a4
ffffffffc0201cf4:	bfc1                	j	ffffffffc0201cc4 <default_init_memmap+0x68>
ffffffffc0201cf6:	60a2                	ld	ra,8(sp)
ffffffffc0201cf8:	01850713          	addi	a4,a0,24
ffffffffc0201cfc:	f11c                	sd	a5,32(a0)
ffffffffc0201cfe:	ed1c                	sd	a5,24(a0)
ffffffffc0201d00:	e398                	sd	a4,0(a5)
ffffffffc0201d02:	e798                	sd	a4,8(a5)
ffffffffc0201d04:	0141                	addi	sp,sp,16
ffffffffc0201d06:	8082                	ret
ffffffffc0201d08:	60a2                	ld	ra,8(sp)
ffffffffc0201d0a:	e290                	sd	a2,0(a3)
ffffffffc0201d0c:	0141                	addi	sp,sp,16
ffffffffc0201d0e:	8082                	ret
ffffffffc0201d10:	0000a697          	auipc	a3,0xa
ffffffffc0201d14:	58068693          	addi	a3,a3,1408 # ffffffffc020c290 <etext+0xe8e>
ffffffffc0201d18:	0000a617          	auipc	a2,0xa
ffffffffc0201d1c:	b2860613          	addi	a2,a2,-1240 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201d20:	04800593          	li	a1,72
ffffffffc0201d24:	0000a517          	auipc	a0,0xa
ffffffffc0201d28:	1fc50513          	addi	a0,a0,508 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201d2c:	f1efe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201d30:	0000a697          	auipc	a3,0xa
ffffffffc0201d34:	53068693          	addi	a3,a3,1328 # ffffffffc020c260 <etext+0xe5e>
ffffffffc0201d38:	0000a617          	auipc	a2,0xa
ffffffffc0201d3c:	b0860613          	addi	a2,a2,-1272 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201d40:	04500593          	li	a1,69
ffffffffc0201d44:	0000a517          	auipc	a0,0xa
ffffffffc0201d48:	1dc50513          	addi	a0,a0,476 # ffffffffc020bf20 <etext+0xb1e>
ffffffffc0201d4c:	efefe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201d50 <slob_free>:
ffffffffc0201d50:	c531                	beqz	a0,ffffffffc0201d9c <slob_free+0x4c>
ffffffffc0201d52:	e9b9                	bnez	a1,ffffffffc0201da8 <slob_free+0x58>
ffffffffc0201d54:	100027f3          	csrr	a5,sstatus
ffffffffc0201d58:	8b89                	andi	a5,a5,2
ffffffffc0201d5a:	4581                	li	a1,0
ffffffffc0201d5c:	efb1                	bnez	a5,ffffffffc0201db8 <slob_free+0x68>
ffffffffc0201d5e:	0008f797          	auipc	a5,0x8f
ffffffffc0201d62:	2f27b783          	ld	a5,754(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201d66:	873e                	mv	a4,a5
ffffffffc0201d68:	679c                	ld	a5,8(a5)
ffffffffc0201d6a:	02a77a63          	bgeu	a4,a0,ffffffffc0201d9e <slob_free+0x4e>
ffffffffc0201d6e:	00f56463          	bltu	a0,a5,ffffffffc0201d76 <slob_free+0x26>
ffffffffc0201d72:	fef76ae3          	bltu	a4,a5,ffffffffc0201d66 <slob_free+0x16>
ffffffffc0201d76:	4110                	lw	a2,0(a0)
ffffffffc0201d78:	00461693          	slli	a3,a2,0x4
ffffffffc0201d7c:	96aa                	add	a3,a3,a0
ffffffffc0201d7e:	0ad78463          	beq	a5,a3,ffffffffc0201e26 <slob_free+0xd6>
ffffffffc0201d82:	4310                	lw	a2,0(a4)
ffffffffc0201d84:	e51c                	sd	a5,8(a0)
ffffffffc0201d86:	00461693          	slli	a3,a2,0x4
ffffffffc0201d8a:	96ba                	add	a3,a3,a4
ffffffffc0201d8c:	08d50163          	beq	a0,a3,ffffffffc0201e0e <slob_free+0xbe>
ffffffffc0201d90:	e708                	sd	a0,8(a4)
ffffffffc0201d92:	0008f797          	auipc	a5,0x8f
ffffffffc0201d96:	2ae7bf23          	sd	a4,702(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201d9a:	e9a5                	bnez	a1,ffffffffc0201e0a <slob_free+0xba>
ffffffffc0201d9c:	8082                	ret
ffffffffc0201d9e:	fcf574e3          	bgeu	a0,a5,ffffffffc0201d66 <slob_free+0x16>
ffffffffc0201da2:	fcf762e3          	bltu	a4,a5,ffffffffc0201d66 <slob_free+0x16>
ffffffffc0201da6:	bfc1                	j	ffffffffc0201d76 <slob_free+0x26>
ffffffffc0201da8:	25bd                	addiw	a1,a1,15
ffffffffc0201daa:	8191                	srli	a1,a1,0x4
ffffffffc0201dac:	c10c                	sw	a1,0(a0)
ffffffffc0201dae:	100027f3          	csrr	a5,sstatus
ffffffffc0201db2:	8b89                	andi	a5,a5,2
ffffffffc0201db4:	4581                	li	a1,0
ffffffffc0201db6:	d7c5                	beqz	a5,ffffffffc0201d5e <slob_free+0xe>
ffffffffc0201db8:	1101                	addi	sp,sp,-32
ffffffffc0201dba:	e42a                	sd	a0,8(sp)
ffffffffc0201dbc:	ec06                	sd	ra,24(sp)
ffffffffc0201dbe:	e3ffe0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0201dc2:	6522                	ld	a0,8(sp)
ffffffffc0201dc4:	0008f797          	auipc	a5,0x8f
ffffffffc0201dc8:	28c7b783          	ld	a5,652(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201dcc:	4585                	li	a1,1
ffffffffc0201dce:	873e                	mv	a4,a5
ffffffffc0201dd0:	679c                	ld	a5,8(a5)
ffffffffc0201dd2:	06a77663          	bgeu	a4,a0,ffffffffc0201e3e <slob_free+0xee>
ffffffffc0201dd6:	00f56463          	bltu	a0,a5,ffffffffc0201dde <slob_free+0x8e>
ffffffffc0201dda:	fef76ae3          	bltu	a4,a5,ffffffffc0201dce <slob_free+0x7e>
ffffffffc0201dde:	4110                	lw	a2,0(a0)
ffffffffc0201de0:	00461693          	slli	a3,a2,0x4
ffffffffc0201de4:	96aa                	add	a3,a3,a0
ffffffffc0201de6:	06d78363          	beq	a5,a3,ffffffffc0201e4c <slob_free+0xfc>
ffffffffc0201dea:	4310                	lw	a2,0(a4)
ffffffffc0201dec:	e51c                	sd	a5,8(a0)
ffffffffc0201dee:	00461693          	slli	a3,a2,0x4
ffffffffc0201df2:	96ba                	add	a3,a3,a4
ffffffffc0201df4:	06d50163          	beq	a0,a3,ffffffffc0201e56 <slob_free+0x106>
ffffffffc0201df8:	e708                	sd	a0,8(a4)
ffffffffc0201dfa:	0008f797          	auipc	a5,0x8f
ffffffffc0201dfe:	24e7bb23          	sd	a4,598(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201e02:	e1a9                	bnez	a1,ffffffffc0201e44 <slob_free+0xf4>
ffffffffc0201e04:	60e2                	ld	ra,24(sp)
ffffffffc0201e06:	6105                	addi	sp,sp,32
ffffffffc0201e08:	8082                	ret
ffffffffc0201e0a:	dedfe06f          	j	ffffffffc0200bf6 <intr_enable>
ffffffffc0201e0e:	4114                	lw	a3,0(a0)
ffffffffc0201e10:	853e                	mv	a0,a5
ffffffffc0201e12:	e708                	sd	a0,8(a4)
ffffffffc0201e14:	00c687bb          	addw	a5,a3,a2
ffffffffc0201e18:	c31c                	sw	a5,0(a4)
ffffffffc0201e1a:	0008f797          	auipc	a5,0x8f
ffffffffc0201e1e:	22e7bb23          	sd	a4,566(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201e22:	ddad                	beqz	a1,ffffffffc0201d9c <slob_free+0x4c>
ffffffffc0201e24:	b7dd                	j	ffffffffc0201e0a <slob_free+0xba>
ffffffffc0201e26:	4394                	lw	a3,0(a5)
ffffffffc0201e28:	679c                	ld	a5,8(a5)
ffffffffc0201e2a:	9eb1                	addw	a3,a3,a2
ffffffffc0201e2c:	c114                	sw	a3,0(a0)
ffffffffc0201e2e:	4310                	lw	a2,0(a4)
ffffffffc0201e30:	e51c                	sd	a5,8(a0)
ffffffffc0201e32:	00461693          	slli	a3,a2,0x4
ffffffffc0201e36:	96ba                	add	a3,a3,a4
ffffffffc0201e38:	f4d51ce3          	bne	a0,a3,ffffffffc0201d90 <slob_free+0x40>
ffffffffc0201e3c:	bfc9                	j	ffffffffc0201e0e <slob_free+0xbe>
ffffffffc0201e3e:	f8f56ee3          	bltu	a0,a5,ffffffffc0201dda <slob_free+0x8a>
ffffffffc0201e42:	b771                	j	ffffffffc0201dce <slob_free+0x7e>
ffffffffc0201e44:	60e2                	ld	ra,24(sp)
ffffffffc0201e46:	6105                	addi	sp,sp,32
ffffffffc0201e48:	daffe06f          	j	ffffffffc0200bf6 <intr_enable>
ffffffffc0201e4c:	4394                	lw	a3,0(a5)
ffffffffc0201e4e:	679c                	ld	a5,8(a5)
ffffffffc0201e50:	9eb1                	addw	a3,a3,a2
ffffffffc0201e52:	c114                	sw	a3,0(a0)
ffffffffc0201e54:	bf59                	j	ffffffffc0201dea <slob_free+0x9a>
ffffffffc0201e56:	4114                	lw	a3,0(a0)
ffffffffc0201e58:	853e                	mv	a0,a5
ffffffffc0201e5a:	00c687bb          	addw	a5,a3,a2
ffffffffc0201e5e:	c31c                	sw	a5,0(a4)
ffffffffc0201e60:	bf61                	j	ffffffffc0201df8 <slob_free+0xa8>

ffffffffc0201e62 <__slob_get_free_pages.constprop.0>:
ffffffffc0201e62:	4785                	li	a5,1
ffffffffc0201e64:	1141                	addi	sp,sp,-16
ffffffffc0201e66:	00a7953b          	sllw	a0,a5,a0
ffffffffc0201e6a:	e406                	sd	ra,8(sp)
ffffffffc0201e6c:	32c000ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc0201e70:	c91d                	beqz	a0,ffffffffc0201ea6 <__slob_get_free_pages.constprop.0+0x44>
ffffffffc0201e72:	00095697          	auipc	a3,0x95
ffffffffc0201e76:	a466b683          	ld	a3,-1466(a3) # ffffffffc02968b8 <pages>
ffffffffc0201e7a:	0000d797          	auipc	a5,0xd
ffffffffc0201e7e:	7567b783          	ld	a5,1878(a5) # ffffffffc020f5d0 <nbase>
ffffffffc0201e82:	00095717          	auipc	a4,0x95
ffffffffc0201e86:	a2e73703          	ld	a4,-1490(a4) # ffffffffc02968b0 <npage>
ffffffffc0201e8a:	8d15                	sub	a0,a0,a3
ffffffffc0201e8c:	8519                	srai	a0,a0,0x6
ffffffffc0201e8e:	953e                	add	a0,a0,a5
ffffffffc0201e90:	00c51793          	slli	a5,a0,0xc
ffffffffc0201e94:	83b1                	srli	a5,a5,0xc
ffffffffc0201e96:	0532                	slli	a0,a0,0xc
ffffffffc0201e98:	00e7fa63          	bgeu	a5,a4,ffffffffc0201eac <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201e9c:	00095797          	auipc	a5,0x95
ffffffffc0201ea0:	a0c7b783          	ld	a5,-1524(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0201ea4:	953e                	add	a0,a0,a5
ffffffffc0201ea6:	60a2                	ld	ra,8(sp)
ffffffffc0201ea8:	0141                	addi	sp,sp,16
ffffffffc0201eaa:	8082                	ret
ffffffffc0201eac:	86aa                	mv	a3,a0
ffffffffc0201eae:	0000a617          	auipc	a2,0xa
ffffffffc0201eb2:	40a60613          	addi	a2,a2,1034 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc0201eb6:	07100593          	li	a1,113
ffffffffc0201eba:	0000a517          	auipc	a0,0xa
ffffffffc0201ebe:	42650513          	addi	a0,a0,1062 # ffffffffc020c2e0 <etext+0xede>
ffffffffc0201ec2:	d88fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201ec6 <slob_alloc.constprop.0>:
ffffffffc0201ec6:	7179                	addi	sp,sp,-48
ffffffffc0201ec8:	f406                	sd	ra,40(sp)
ffffffffc0201eca:	f022                	sd	s0,32(sp)
ffffffffc0201ecc:	ec26                	sd	s1,24(sp)
ffffffffc0201ece:	01050713          	addi	a4,a0,16
ffffffffc0201ed2:	6785                	lui	a5,0x1
ffffffffc0201ed4:	0af77e63          	bgeu	a4,a5,ffffffffc0201f90 <slob_alloc.constprop.0+0xca>
ffffffffc0201ed8:	00f50413          	addi	s0,a0,15
ffffffffc0201edc:	8011                	srli	s0,s0,0x4
ffffffffc0201ede:	2401                	sext.w	s0,s0
ffffffffc0201ee0:	100025f3          	csrr	a1,sstatus
ffffffffc0201ee4:	8989                	andi	a1,a1,2
ffffffffc0201ee6:	edd1                	bnez	a1,ffffffffc0201f82 <slob_alloc.constprop.0+0xbc>
ffffffffc0201ee8:	0008f497          	auipc	s1,0x8f
ffffffffc0201eec:	16848493          	addi	s1,s1,360 # ffffffffc0291050 <slobfree>
ffffffffc0201ef0:	6090                	ld	a2,0(s1)
ffffffffc0201ef2:	6618                	ld	a4,8(a2)
ffffffffc0201ef4:	4314                	lw	a3,0(a4)
ffffffffc0201ef6:	0886da63          	bge	a3,s0,ffffffffc0201f8a <slob_alloc.constprop.0+0xc4>
ffffffffc0201efa:	00e60a63          	beq	a2,a4,ffffffffc0201f0e <slob_alloc.constprop.0+0x48>
ffffffffc0201efe:	671c                	ld	a5,8(a4)
ffffffffc0201f00:	4394                	lw	a3,0(a5)
ffffffffc0201f02:	0286d863          	bge	a3,s0,ffffffffc0201f32 <slob_alloc.constprop.0+0x6c>
ffffffffc0201f06:	6090                	ld	a2,0(s1)
ffffffffc0201f08:	873e                	mv	a4,a5
ffffffffc0201f0a:	fee61ae3          	bne	a2,a4,ffffffffc0201efe <slob_alloc.constprop.0+0x38>
ffffffffc0201f0e:	e9b1                	bnez	a1,ffffffffc0201f62 <slob_alloc.constprop.0+0x9c>
ffffffffc0201f10:	4501                	li	a0,0
ffffffffc0201f12:	f51ff0ef          	jal	ffffffffc0201e62 <__slob_get_free_pages.constprop.0>
ffffffffc0201f16:	87aa                	mv	a5,a0
ffffffffc0201f18:	c915                	beqz	a0,ffffffffc0201f4c <slob_alloc.constprop.0+0x86>
ffffffffc0201f1a:	6585                	lui	a1,0x1
ffffffffc0201f1c:	e35ff0ef          	jal	ffffffffc0201d50 <slob_free>
ffffffffc0201f20:	100025f3          	csrr	a1,sstatus
ffffffffc0201f24:	8989                	andi	a1,a1,2
ffffffffc0201f26:	e98d                	bnez	a1,ffffffffc0201f58 <slob_alloc.constprop.0+0x92>
ffffffffc0201f28:	6098                	ld	a4,0(s1)
ffffffffc0201f2a:	671c                	ld	a5,8(a4)
ffffffffc0201f2c:	4394                	lw	a3,0(a5)
ffffffffc0201f2e:	fc86cce3          	blt	a3,s0,ffffffffc0201f06 <slob_alloc.constprop.0+0x40>
ffffffffc0201f32:	04d40563          	beq	s0,a3,ffffffffc0201f7c <slob_alloc.constprop.0+0xb6>
ffffffffc0201f36:	00441613          	slli	a2,s0,0x4
ffffffffc0201f3a:	963e                	add	a2,a2,a5
ffffffffc0201f3c:	e710                	sd	a2,8(a4)
ffffffffc0201f3e:	6788                	ld	a0,8(a5)
ffffffffc0201f40:	9e81                	subw	a3,a3,s0
ffffffffc0201f42:	c214                	sw	a3,0(a2)
ffffffffc0201f44:	e608                	sd	a0,8(a2)
ffffffffc0201f46:	c380                	sw	s0,0(a5)
ffffffffc0201f48:	e098                	sd	a4,0(s1)
ffffffffc0201f4a:	ed99                	bnez	a1,ffffffffc0201f68 <slob_alloc.constprop.0+0xa2>
ffffffffc0201f4c:	70a2                	ld	ra,40(sp)
ffffffffc0201f4e:	7402                	ld	s0,32(sp)
ffffffffc0201f50:	64e2                	ld	s1,24(sp)
ffffffffc0201f52:	853e                	mv	a0,a5
ffffffffc0201f54:	6145                	addi	sp,sp,48
ffffffffc0201f56:	8082                	ret
ffffffffc0201f58:	ca5fe0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0201f5c:	6098                	ld	a4,0(s1)
ffffffffc0201f5e:	4585                	li	a1,1
ffffffffc0201f60:	b7e9                	j	ffffffffc0201f2a <slob_alloc.constprop.0+0x64>
ffffffffc0201f62:	c95fe0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc0201f66:	b76d                	j	ffffffffc0201f10 <slob_alloc.constprop.0+0x4a>
ffffffffc0201f68:	e43e                	sd	a5,8(sp)
ffffffffc0201f6a:	c8dfe0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc0201f6e:	67a2                	ld	a5,8(sp)
ffffffffc0201f70:	70a2                	ld	ra,40(sp)
ffffffffc0201f72:	7402                	ld	s0,32(sp)
ffffffffc0201f74:	64e2                	ld	s1,24(sp)
ffffffffc0201f76:	853e                	mv	a0,a5
ffffffffc0201f78:	6145                	addi	sp,sp,48
ffffffffc0201f7a:	8082                	ret
ffffffffc0201f7c:	6794                	ld	a3,8(a5)
ffffffffc0201f7e:	e714                	sd	a3,8(a4)
ffffffffc0201f80:	b7e1                	j	ffffffffc0201f48 <slob_alloc.constprop.0+0x82>
ffffffffc0201f82:	c7bfe0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0201f86:	4585                	li	a1,1
ffffffffc0201f88:	b785                	j	ffffffffc0201ee8 <slob_alloc.constprop.0+0x22>
ffffffffc0201f8a:	87ba                	mv	a5,a4
ffffffffc0201f8c:	8732                	mv	a4,a2
ffffffffc0201f8e:	b755                	j	ffffffffc0201f32 <slob_alloc.constprop.0+0x6c>
ffffffffc0201f90:	0000a697          	auipc	a3,0xa
ffffffffc0201f94:	36068693          	addi	a3,a3,864 # ffffffffc020c2f0 <etext+0xeee>
ffffffffc0201f98:	0000a617          	auipc	a2,0xa
ffffffffc0201f9c:	8a860613          	addi	a2,a2,-1880 # ffffffffc020b840 <etext+0x43e>
ffffffffc0201fa0:	06300593          	li	a1,99
ffffffffc0201fa4:	0000a517          	auipc	a0,0xa
ffffffffc0201fa8:	36c50513          	addi	a0,a0,876 # ffffffffc020c310 <etext+0xf0e>
ffffffffc0201fac:	c9efe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201fb0 <kmalloc_init>:
ffffffffc0201fb0:	1141                	addi	sp,sp,-16
ffffffffc0201fb2:	0000a517          	auipc	a0,0xa
ffffffffc0201fb6:	37650513          	addi	a0,a0,886 # ffffffffc020c328 <etext+0xf26>
ffffffffc0201fba:	e406                	sd	ra,8(sp)
ffffffffc0201fbc:	9eafe0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0201fc0:	60a2                	ld	ra,8(sp)
ffffffffc0201fc2:	0000a517          	auipc	a0,0xa
ffffffffc0201fc6:	37e50513          	addi	a0,a0,894 # ffffffffc020c340 <etext+0xf3e>
ffffffffc0201fca:	0141                	addi	sp,sp,16
ffffffffc0201fcc:	9dafe06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0201fd0 <kallocated>:
ffffffffc0201fd0:	4501                	li	a0,0
ffffffffc0201fd2:	8082                	ret

ffffffffc0201fd4 <kmalloc>:
ffffffffc0201fd4:	1101                	addi	sp,sp,-32
ffffffffc0201fd6:	6685                	lui	a3,0x1
ffffffffc0201fd8:	ec06                	sd	ra,24(sp)
ffffffffc0201fda:	16bd                	addi	a3,a3,-17 # fef <_binary_bin_swap_img_size-0x6d11>
ffffffffc0201fdc:	04a6f963          	bgeu	a3,a0,ffffffffc020202e <kmalloc+0x5a>
ffffffffc0201fe0:	e42a                	sd	a0,8(sp)
ffffffffc0201fe2:	4561                	li	a0,24
ffffffffc0201fe4:	e822                	sd	s0,16(sp)
ffffffffc0201fe6:	ee1ff0ef          	jal	ffffffffc0201ec6 <slob_alloc.constprop.0>
ffffffffc0201fea:	842a                	mv	s0,a0
ffffffffc0201fec:	c541                	beqz	a0,ffffffffc0202074 <kmalloc+0xa0>
ffffffffc0201fee:	47a2                	lw	a5,8(sp)
ffffffffc0201ff0:	6705                	lui	a4,0x1
ffffffffc0201ff2:	4501                	li	a0,0
ffffffffc0201ff4:	00f75763          	bge	a4,a5,ffffffffc0202002 <kmalloc+0x2e>
ffffffffc0201ff8:	4017d79b          	sraiw	a5,a5,0x1
ffffffffc0201ffc:	2505                	addiw	a0,a0,1
ffffffffc0201ffe:	fef74de3          	blt	a4,a5,ffffffffc0201ff8 <kmalloc+0x24>
ffffffffc0202002:	c008                	sw	a0,0(s0)
ffffffffc0202004:	e5fff0ef          	jal	ffffffffc0201e62 <__slob_get_free_pages.constprop.0>
ffffffffc0202008:	e408                	sd	a0,8(s0)
ffffffffc020200a:	cd31                	beqz	a0,ffffffffc0202066 <kmalloc+0x92>
ffffffffc020200c:	100027f3          	csrr	a5,sstatus
ffffffffc0202010:	8b89                	andi	a5,a5,2
ffffffffc0202012:	eb85                	bnez	a5,ffffffffc0202042 <kmalloc+0x6e>
ffffffffc0202014:	00095797          	auipc	a5,0x95
ffffffffc0202018:	8747b783          	ld	a5,-1932(a5) # ffffffffc0296888 <bigblocks>
ffffffffc020201c:	00095717          	auipc	a4,0x95
ffffffffc0202020:	86873623          	sd	s0,-1940(a4) # ffffffffc0296888 <bigblocks>
ffffffffc0202024:	e81c                	sd	a5,16(s0)
ffffffffc0202026:	6442                	ld	s0,16(sp)
ffffffffc0202028:	60e2                	ld	ra,24(sp)
ffffffffc020202a:	6105                	addi	sp,sp,32
ffffffffc020202c:	8082                	ret
ffffffffc020202e:	0541                	addi	a0,a0,16
ffffffffc0202030:	e97ff0ef          	jal	ffffffffc0201ec6 <slob_alloc.constprop.0>
ffffffffc0202034:	87aa                	mv	a5,a0
ffffffffc0202036:	0541                	addi	a0,a0,16
ffffffffc0202038:	fbe5                	bnez	a5,ffffffffc0202028 <kmalloc+0x54>
ffffffffc020203a:	4501                	li	a0,0
ffffffffc020203c:	60e2                	ld	ra,24(sp)
ffffffffc020203e:	6105                	addi	sp,sp,32
ffffffffc0202040:	8082                	ret
ffffffffc0202042:	bbbfe0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0202046:	00095797          	auipc	a5,0x95
ffffffffc020204a:	8427b783          	ld	a5,-1982(a5) # ffffffffc0296888 <bigblocks>
ffffffffc020204e:	00095717          	auipc	a4,0x95
ffffffffc0202052:	82873d23          	sd	s0,-1990(a4) # ffffffffc0296888 <bigblocks>
ffffffffc0202056:	e81c                	sd	a5,16(s0)
ffffffffc0202058:	b9ffe0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc020205c:	6408                	ld	a0,8(s0)
ffffffffc020205e:	60e2                	ld	ra,24(sp)
ffffffffc0202060:	6442                	ld	s0,16(sp)
ffffffffc0202062:	6105                	addi	sp,sp,32
ffffffffc0202064:	8082                	ret
ffffffffc0202066:	8522                	mv	a0,s0
ffffffffc0202068:	45e1                	li	a1,24
ffffffffc020206a:	ce7ff0ef          	jal	ffffffffc0201d50 <slob_free>
ffffffffc020206e:	4501                	li	a0,0
ffffffffc0202070:	6442                	ld	s0,16(sp)
ffffffffc0202072:	b7e9                	j	ffffffffc020203c <kmalloc+0x68>
ffffffffc0202074:	6442                	ld	s0,16(sp)
ffffffffc0202076:	4501                	li	a0,0
ffffffffc0202078:	b7d1                	j	ffffffffc020203c <kmalloc+0x68>

ffffffffc020207a <kfree>:
ffffffffc020207a:	c579                	beqz	a0,ffffffffc0202148 <kfree+0xce>
ffffffffc020207c:	03451793          	slli	a5,a0,0x34
ffffffffc0202080:	e3e1                	bnez	a5,ffffffffc0202140 <kfree+0xc6>
ffffffffc0202082:	1101                	addi	sp,sp,-32
ffffffffc0202084:	ec06                	sd	ra,24(sp)
ffffffffc0202086:	100027f3          	csrr	a5,sstatus
ffffffffc020208a:	8b89                	andi	a5,a5,2
ffffffffc020208c:	e7c1                	bnez	a5,ffffffffc0202114 <kfree+0x9a>
ffffffffc020208e:	00094797          	auipc	a5,0x94
ffffffffc0202092:	7fa7b783          	ld	a5,2042(a5) # ffffffffc0296888 <bigblocks>
ffffffffc0202096:	4581                	li	a1,0
ffffffffc0202098:	cbad                	beqz	a5,ffffffffc020210a <kfree+0x90>
ffffffffc020209a:	00094617          	auipc	a2,0x94
ffffffffc020209e:	7ee60613          	addi	a2,a2,2030 # ffffffffc0296888 <bigblocks>
ffffffffc02020a2:	a021                	j	ffffffffc02020aa <kfree+0x30>
ffffffffc02020a4:	01070613          	addi	a2,a4,16
ffffffffc02020a8:	c3a5                	beqz	a5,ffffffffc0202108 <kfree+0x8e>
ffffffffc02020aa:	6794                	ld	a3,8(a5)
ffffffffc02020ac:	873e                	mv	a4,a5
ffffffffc02020ae:	6b9c                	ld	a5,16(a5)
ffffffffc02020b0:	fea69ae3          	bne	a3,a0,ffffffffc02020a4 <kfree+0x2a>
ffffffffc02020b4:	e21c                	sd	a5,0(a2)
ffffffffc02020b6:	edb5                	bnez	a1,ffffffffc0202132 <kfree+0xb8>
ffffffffc02020b8:	c02007b7          	lui	a5,0xc0200
ffffffffc02020bc:	0af56363          	bltu	a0,a5,ffffffffc0202162 <kfree+0xe8>
ffffffffc02020c0:	00094797          	auipc	a5,0x94
ffffffffc02020c4:	7e87b783          	ld	a5,2024(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc02020c8:	00094697          	auipc	a3,0x94
ffffffffc02020cc:	7e86b683          	ld	a3,2024(a3) # ffffffffc02968b0 <npage>
ffffffffc02020d0:	8d1d                	sub	a0,a0,a5
ffffffffc02020d2:	00c55793          	srli	a5,a0,0xc
ffffffffc02020d6:	06d7fa63          	bgeu	a5,a3,ffffffffc020214a <kfree+0xd0>
ffffffffc02020da:	0000d617          	auipc	a2,0xd
ffffffffc02020de:	4f663603          	ld	a2,1270(a2) # ffffffffc020f5d0 <nbase>
ffffffffc02020e2:	00094517          	auipc	a0,0x94
ffffffffc02020e6:	7d653503          	ld	a0,2006(a0) # ffffffffc02968b8 <pages>
ffffffffc02020ea:	4314                	lw	a3,0(a4)
ffffffffc02020ec:	8f91                	sub	a5,a5,a2
ffffffffc02020ee:	079a                	slli	a5,a5,0x6
ffffffffc02020f0:	4585                	li	a1,1
ffffffffc02020f2:	953e                	add	a0,a0,a5
ffffffffc02020f4:	00d595bb          	sllw	a1,a1,a3
ffffffffc02020f8:	e03a                	sd	a4,0(sp)
ffffffffc02020fa:	0d8000ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc02020fe:	6502                	ld	a0,0(sp)
ffffffffc0202100:	60e2                	ld	ra,24(sp)
ffffffffc0202102:	45e1                	li	a1,24
ffffffffc0202104:	6105                	addi	sp,sp,32
ffffffffc0202106:	b1a9                	j	ffffffffc0201d50 <slob_free>
ffffffffc0202108:	e185                	bnez	a1,ffffffffc0202128 <kfree+0xae>
ffffffffc020210a:	60e2                	ld	ra,24(sp)
ffffffffc020210c:	1541                	addi	a0,a0,-16
ffffffffc020210e:	4581                	li	a1,0
ffffffffc0202110:	6105                	addi	sp,sp,32
ffffffffc0202112:	b93d                	j	ffffffffc0201d50 <slob_free>
ffffffffc0202114:	e02a                	sd	a0,0(sp)
ffffffffc0202116:	ae7fe0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc020211a:	00094797          	auipc	a5,0x94
ffffffffc020211e:	76e7b783          	ld	a5,1902(a5) # ffffffffc0296888 <bigblocks>
ffffffffc0202122:	6502                	ld	a0,0(sp)
ffffffffc0202124:	4585                	li	a1,1
ffffffffc0202126:	fbb5                	bnez	a5,ffffffffc020209a <kfree+0x20>
ffffffffc0202128:	e02a                	sd	a0,0(sp)
ffffffffc020212a:	acdfe0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc020212e:	6502                	ld	a0,0(sp)
ffffffffc0202130:	bfe9                	j	ffffffffc020210a <kfree+0x90>
ffffffffc0202132:	e42a                	sd	a0,8(sp)
ffffffffc0202134:	e03a                	sd	a4,0(sp)
ffffffffc0202136:	ac1fe0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc020213a:	6522                	ld	a0,8(sp)
ffffffffc020213c:	6702                	ld	a4,0(sp)
ffffffffc020213e:	bfad                	j	ffffffffc02020b8 <kfree+0x3e>
ffffffffc0202140:	1541                	addi	a0,a0,-16
ffffffffc0202142:	4581                	li	a1,0
ffffffffc0202144:	c0dff06f          	j	ffffffffc0201d50 <slob_free>
ffffffffc0202148:	8082                	ret
ffffffffc020214a:	0000a617          	auipc	a2,0xa
ffffffffc020214e:	23e60613          	addi	a2,a2,574 # ffffffffc020c388 <etext+0xf86>
ffffffffc0202152:	06900593          	li	a1,105
ffffffffc0202156:	0000a517          	auipc	a0,0xa
ffffffffc020215a:	18a50513          	addi	a0,a0,394 # ffffffffc020c2e0 <etext+0xede>
ffffffffc020215e:	aecfe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202162:	86aa                	mv	a3,a0
ffffffffc0202164:	0000a617          	auipc	a2,0xa
ffffffffc0202168:	1fc60613          	addi	a2,a2,508 # ffffffffc020c360 <etext+0xf5e>
ffffffffc020216c:	07700593          	li	a1,119
ffffffffc0202170:	0000a517          	auipc	a0,0xa
ffffffffc0202174:	17050513          	addi	a0,a0,368 # ffffffffc020c2e0 <etext+0xede>
ffffffffc0202178:	ad2fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020217c <pa2page.part.0>:
ffffffffc020217c:	1141                	addi	sp,sp,-16
ffffffffc020217e:	0000a617          	auipc	a2,0xa
ffffffffc0202182:	20a60613          	addi	a2,a2,522 # ffffffffc020c388 <etext+0xf86>
ffffffffc0202186:	06900593          	li	a1,105
ffffffffc020218a:	0000a517          	auipc	a0,0xa
ffffffffc020218e:	15650513          	addi	a0,a0,342 # ffffffffc020c2e0 <etext+0xede>
ffffffffc0202192:	e406                	sd	ra,8(sp)
ffffffffc0202194:	ab6fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0202198 <alloc_pages>:
ffffffffc0202198:	100027f3          	csrr	a5,sstatus
ffffffffc020219c:	8b89                	andi	a5,a5,2
ffffffffc020219e:	e799                	bnez	a5,ffffffffc02021ac <alloc_pages+0x14>
ffffffffc02021a0:	00094797          	auipc	a5,0x94
ffffffffc02021a4:	6f07b783          	ld	a5,1776(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02021a8:	6f9c                	ld	a5,24(a5)
ffffffffc02021aa:	8782                	jr	a5
ffffffffc02021ac:	1101                	addi	sp,sp,-32
ffffffffc02021ae:	ec06                	sd	ra,24(sp)
ffffffffc02021b0:	e42a                	sd	a0,8(sp)
ffffffffc02021b2:	a4bfe0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc02021b6:	00094797          	auipc	a5,0x94
ffffffffc02021ba:	6da7b783          	ld	a5,1754(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02021be:	6522                	ld	a0,8(sp)
ffffffffc02021c0:	6f9c                	ld	a5,24(a5)
ffffffffc02021c2:	9782                	jalr	a5
ffffffffc02021c4:	e42a                	sd	a0,8(sp)
ffffffffc02021c6:	a31fe0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc02021ca:	60e2                	ld	ra,24(sp)
ffffffffc02021cc:	6522                	ld	a0,8(sp)
ffffffffc02021ce:	6105                	addi	sp,sp,32
ffffffffc02021d0:	8082                	ret

ffffffffc02021d2 <free_pages>:
ffffffffc02021d2:	100027f3          	csrr	a5,sstatus
ffffffffc02021d6:	8b89                	andi	a5,a5,2
ffffffffc02021d8:	e799                	bnez	a5,ffffffffc02021e6 <free_pages+0x14>
ffffffffc02021da:	00094797          	auipc	a5,0x94
ffffffffc02021de:	6b67b783          	ld	a5,1718(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02021e2:	739c                	ld	a5,32(a5)
ffffffffc02021e4:	8782                	jr	a5
ffffffffc02021e6:	1101                	addi	sp,sp,-32
ffffffffc02021e8:	ec06                	sd	ra,24(sp)
ffffffffc02021ea:	e42e                	sd	a1,8(sp)
ffffffffc02021ec:	e02a                	sd	a0,0(sp)
ffffffffc02021ee:	a0ffe0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc02021f2:	00094797          	auipc	a5,0x94
ffffffffc02021f6:	69e7b783          	ld	a5,1694(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02021fa:	65a2                	ld	a1,8(sp)
ffffffffc02021fc:	6502                	ld	a0,0(sp)
ffffffffc02021fe:	739c                	ld	a5,32(a5)
ffffffffc0202200:	9782                	jalr	a5
ffffffffc0202202:	60e2                	ld	ra,24(sp)
ffffffffc0202204:	6105                	addi	sp,sp,32
ffffffffc0202206:	9f1fe06f          	j	ffffffffc0200bf6 <intr_enable>

ffffffffc020220a <nr_free_pages>:
ffffffffc020220a:	100027f3          	csrr	a5,sstatus
ffffffffc020220e:	8b89                	andi	a5,a5,2
ffffffffc0202210:	e799                	bnez	a5,ffffffffc020221e <nr_free_pages+0x14>
ffffffffc0202212:	00094797          	auipc	a5,0x94
ffffffffc0202216:	67e7b783          	ld	a5,1662(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc020221a:	779c                	ld	a5,40(a5)
ffffffffc020221c:	8782                	jr	a5
ffffffffc020221e:	1101                	addi	sp,sp,-32
ffffffffc0202220:	ec06                	sd	ra,24(sp)
ffffffffc0202222:	9dbfe0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0202226:	00094797          	auipc	a5,0x94
ffffffffc020222a:	66a7b783          	ld	a5,1642(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc020222e:	779c                	ld	a5,40(a5)
ffffffffc0202230:	9782                	jalr	a5
ffffffffc0202232:	e42a                	sd	a0,8(sp)
ffffffffc0202234:	9c3fe0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc0202238:	60e2                	ld	ra,24(sp)
ffffffffc020223a:	6522                	ld	a0,8(sp)
ffffffffc020223c:	6105                	addi	sp,sp,32
ffffffffc020223e:	8082                	ret

ffffffffc0202240 <get_pte>:
ffffffffc0202240:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202244:	1ff7f793          	andi	a5,a5,511
ffffffffc0202248:	078e                	slli	a5,a5,0x3
ffffffffc020224a:	00f50733          	add	a4,a0,a5
ffffffffc020224e:	6314                	ld	a3,0(a4)
ffffffffc0202250:	7139                	addi	sp,sp,-64
ffffffffc0202252:	f822                	sd	s0,48(sp)
ffffffffc0202254:	f426                	sd	s1,40(sp)
ffffffffc0202256:	fc06                	sd	ra,56(sp)
ffffffffc0202258:	0016f793          	andi	a5,a3,1
ffffffffc020225c:	842e                	mv	s0,a1
ffffffffc020225e:	8832                	mv	a6,a2
ffffffffc0202260:	00094497          	auipc	s1,0x94
ffffffffc0202264:	65048493          	addi	s1,s1,1616 # ffffffffc02968b0 <npage>
ffffffffc0202268:	ebd1                	bnez	a5,ffffffffc02022fc <get_pte+0xbc>
ffffffffc020226a:	16060d63          	beqz	a2,ffffffffc02023e4 <get_pte+0x1a4>
ffffffffc020226e:	100027f3          	csrr	a5,sstatus
ffffffffc0202272:	8b89                	andi	a5,a5,2
ffffffffc0202274:	16079e63          	bnez	a5,ffffffffc02023f0 <get_pte+0x1b0>
ffffffffc0202278:	00094797          	auipc	a5,0x94
ffffffffc020227c:	6187b783          	ld	a5,1560(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202280:	4505                	li	a0,1
ffffffffc0202282:	e43a                	sd	a4,8(sp)
ffffffffc0202284:	6f9c                	ld	a5,24(a5)
ffffffffc0202286:	e832                	sd	a2,16(sp)
ffffffffc0202288:	9782                	jalr	a5
ffffffffc020228a:	6722                	ld	a4,8(sp)
ffffffffc020228c:	6842                	ld	a6,16(sp)
ffffffffc020228e:	87aa                	mv	a5,a0
ffffffffc0202290:	14078a63          	beqz	a5,ffffffffc02023e4 <get_pte+0x1a4>
ffffffffc0202294:	00094517          	auipc	a0,0x94
ffffffffc0202298:	62453503          	ld	a0,1572(a0) # ffffffffc02968b8 <pages>
ffffffffc020229c:	000808b7          	lui	a7,0x80
ffffffffc02022a0:	00094497          	auipc	s1,0x94
ffffffffc02022a4:	61048493          	addi	s1,s1,1552 # ffffffffc02968b0 <npage>
ffffffffc02022a8:	40a78533          	sub	a0,a5,a0
ffffffffc02022ac:	8519                	srai	a0,a0,0x6
ffffffffc02022ae:	9546                	add	a0,a0,a7
ffffffffc02022b0:	6090                	ld	a2,0(s1)
ffffffffc02022b2:	00c51693          	slli	a3,a0,0xc
ffffffffc02022b6:	4585                	li	a1,1
ffffffffc02022b8:	82b1                	srli	a3,a3,0xc
ffffffffc02022ba:	c38c                	sw	a1,0(a5)
ffffffffc02022bc:	0532                	slli	a0,a0,0xc
ffffffffc02022be:	1ac6f763          	bgeu	a3,a2,ffffffffc020246c <get_pte+0x22c>
ffffffffc02022c2:	00094697          	auipc	a3,0x94
ffffffffc02022c6:	5e66b683          	ld	a3,1510(a3) # ffffffffc02968a8 <va_pa_offset>
ffffffffc02022ca:	6605                	lui	a2,0x1
ffffffffc02022cc:	4581                	li	a1,0
ffffffffc02022ce:	9536                	add	a0,a0,a3
ffffffffc02022d0:	ec42                	sd	a6,24(sp)
ffffffffc02022d2:	e83e                	sd	a5,16(sp)
ffffffffc02022d4:	e43a                	sd	a4,8(sp)
ffffffffc02022d6:	0c4090ef          	jal	ffffffffc020b39a <memset>
ffffffffc02022da:	00094697          	auipc	a3,0x94
ffffffffc02022de:	5de6b683          	ld	a3,1502(a3) # ffffffffc02968b8 <pages>
ffffffffc02022e2:	67c2                	ld	a5,16(sp)
ffffffffc02022e4:	000808b7          	lui	a7,0x80
ffffffffc02022e8:	6722                	ld	a4,8(sp)
ffffffffc02022ea:	40d786b3          	sub	a3,a5,a3
ffffffffc02022ee:	8699                	srai	a3,a3,0x6
ffffffffc02022f0:	96c6                	add	a3,a3,a7
ffffffffc02022f2:	06aa                	slli	a3,a3,0xa
ffffffffc02022f4:	6862                	ld	a6,24(sp)
ffffffffc02022f6:	0116e693          	ori	a3,a3,17
ffffffffc02022fa:	e314                	sd	a3,0(a4)
ffffffffc02022fc:	c006f693          	andi	a3,a3,-1024
ffffffffc0202300:	6098                	ld	a4,0(s1)
ffffffffc0202302:	068a                	slli	a3,a3,0x2
ffffffffc0202304:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202308:	14e7f663          	bgeu	a5,a4,ffffffffc0202454 <get_pte+0x214>
ffffffffc020230c:	00094897          	auipc	a7,0x94
ffffffffc0202310:	59c88893          	addi	a7,a7,1436 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202314:	0008b603          	ld	a2,0(a7)
ffffffffc0202318:	01545793          	srli	a5,s0,0x15
ffffffffc020231c:	1ff7f793          	andi	a5,a5,511
ffffffffc0202320:	96b2                	add	a3,a3,a2
ffffffffc0202322:	078e                	slli	a5,a5,0x3
ffffffffc0202324:	97b6                	add	a5,a5,a3
ffffffffc0202326:	6394                	ld	a3,0(a5)
ffffffffc0202328:	0016f613          	andi	a2,a3,1
ffffffffc020232c:	e659                	bnez	a2,ffffffffc02023ba <get_pte+0x17a>
ffffffffc020232e:	0a080b63          	beqz	a6,ffffffffc02023e4 <get_pte+0x1a4>
ffffffffc0202332:	10002773          	csrr	a4,sstatus
ffffffffc0202336:	8b09                	andi	a4,a4,2
ffffffffc0202338:	ef71                	bnez	a4,ffffffffc0202414 <get_pte+0x1d4>
ffffffffc020233a:	00094717          	auipc	a4,0x94
ffffffffc020233e:	55673703          	ld	a4,1366(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc0202342:	4505                	li	a0,1
ffffffffc0202344:	e43e                	sd	a5,8(sp)
ffffffffc0202346:	6f18                	ld	a4,24(a4)
ffffffffc0202348:	9702                	jalr	a4
ffffffffc020234a:	67a2                	ld	a5,8(sp)
ffffffffc020234c:	872a                	mv	a4,a0
ffffffffc020234e:	00094897          	auipc	a7,0x94
ffffffffc0202352:	55a88893          	addi	a7,a7,1370 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202356:	c759                	beqz	a4,ffffffffc02023e4 <get_pte+0x1a4>
ffffffffc0202358:	00094697          	auipc	a3,0x94
ffffffffc020235c:	5606b683          	ld	a3,1376(a3) # ffffffffc02968b8 <pages>
ffffffffc0202360:	00080837          	lui	a6,0x80
ffffffffc0202364:	608c                	ld	a1,0(s1)
ffffffffc0202366:	40d706b3          	sub	a3,a4,a3
ffffffffc020236a:	8699                	srai	a3,a3,0x6
ffffffffc020236c:	96c2                	add	a3,a3,a6
ffffffffc020236e:	00c69613          	slli	a2,a3,0xc
ffffffffc0202372:	4505                	li	a0,1
ffffffffc0202374:	8231                	srli	a2,a2,0xc
ffffffffc0202376:	c308                	sw	a0,0(a4)
ffffffffc0202378:	06b2                	slli	a3,a3,0xc
ffffffffc020237a:	10b67663          	bgeu	a2,a1,ffffffffc0202486 <get_pte+0x246>
ffffffffc020237e:	0008b503          	ld	a0,0(a7)
ffffffffc0202382:	6605                	lui	a2,0x1
ffffffffc0202384:	4581                	li	a1,0
ffffffffc0202386:	9536                	add	a0,a0,a3
ffffffffc0202388:	e83a                	sd	a4,16(sp)
ffffffffc020238a:	e43e                	sd	a5,8(sp)
ffffffffc020238c:	00e090ef          	jal	ffffffffc020b39a <memset>
ffffffffc0202390:	00094697          	auipc	a3,0x94
ffffffffc0202394:	5286b683          	ld	a3,1320(a3) # ffffffffc02968b8 <pages>
ffffffffc0202398:	6742                	ld	a4,16(sp)
ffffffffc020239a:	00080837          	lui	a6,0x80
ffffffffc020239e:	67a2                	ld	a5,8(sp)
ffffffffc02023a0:	40d706b3          	sub	a3,a4,a3
ffffffffc02023a4:	8699                	srai	a3,a3,0x6
ffffffffc02023a6:	96c2                	add	a3,a3,a6
ffffffffc02023a8:	06aa                	slli	a3,a3,0xa
ffffffffc02023aa:	0116e693          	ori	a3,a3,17
ffffffffc02023ae:	e394                	sd	a3,0(a5)
ffffffffc02023b0:	6098                	ld	a4,0(s1)
ffffffffc02023b2:	00094897          	auipc	a7,0x94
ffffffffc02023b6:	4f688893          	addi	a7,a7,1270 # ffffffffc02968a8 <va_pa_offset>
ffffffffc02023ba:	c006f693          	andi	a3,a3,-1024
ffffffffc02023be:	068a                	slli	a3,a3,0x2
ffffffffc02023c0:	00c6d793          	srli	a5,a3,0xc
ffffffffc02023c4:	06e7fc63          	bgeu	a5,a4,ffffffffc020243c <get_pte+0x1fc>
ffffffffc02023c8:	0008b783          	ld	a5,0(a7)
ffffffffc02023cc:	8031                	srli	s0,s0,0xc
ffffffffc02023ce:	1ff47413          	andi	s0,s0,511
ffffffffc02023d2:	040e                	slli	s0,s0,0x3
ffffffffc02023d4:	96be                	add	a3,a3,a5
ffffffffc02023d6:	70e2                	ld	ra,56(sp)
ffffffffc02023d8:	00868533          	add	a0,a3,s0
ffffffffc02023dc:	7442                	ld	s0,48(sp)
ffffffffc02023de:	74a2                	ld	s1,40(sp)
ffffffffc02023e0:	6121                	addi	sp,sp,64
ffffffffc02023e2:	8082                	ret
ffffffffc02023e4:	70e2                	ld	ra,56(sp)
ffffffffc02023e6:	7442                	ld	s0,48(sp)
ffffffffc02023e8:	74a2                	ld	s1,40(sp)
ffffffffc02023ea:	4501                	li	a0,0
ffffffffc02023ec:	6121                	addi	sp,sp,64
ffffffffc02023ee:	8082                	ret
ffffffffc02023f0:	e83a                	sd	a4,16(sp)
ffffffffc02023f2:	ec32                	sd	a2,24(sp)
ffffffffc02023f4:	809fe0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc02023f8:	00094797          	auipc	a5,0x94
ffffffffc02023fc:	4987b783          	ld	a5,1176(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202400:	4505                	li	a0,1
ffffffffc0202402:	6f9c                	ld	a5,24(a5)
ffffffffc0202404:	9782                	jalr	a5
ffffffffc0202406:	e42a                	sd	a0,8(sp)
ffffffffc0202408:	feefe0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc020240c:	6862                	ld	a6,24(sp)
ffffffffc020240e:	6742                	ld	a4,16(sp)
ffffffffc0202410:	67a2                	ld	a5,8(sp)
ffffffffc0202412:	bdbd                	j	ffffffffc0202290 <get_pte+0x50>
ffffffffc0202414:	e83e                	sd	a5,16(sp)
ffffffffc0202416:	fe6fe0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc020241a:	00094717          	auipc	a4,0x94
ffffffffc020241e:	47673703          	ld	a4,1142(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc0202422:	4505                	li	a0,1
ffffffffc0202424:	6f18                	ld	a4,24(a4)
ffffffffc0202426:	9702                	jalr	a4
ffffffffc0202428:	e42a                	sd	a0,8(sp)
ffffffffc020242a:	fccfe0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc020242e:	6722                	ld	a4,8(sp)
ffffffffc0202430:	67c2                	ld	a5,16(sp)
ffffffffc0202432:	00094897          	auipc	a7,0x94
ffffffffc0202436:	47688893          	addi	a7,a7,1142 # ffffffffc02968a8 <va_pa_offset>
ffffffffc020243a:	bf31                	j	ffffffffc0202356 <get_pte+0x116>
ffffffffc020243c:	0000a617          	auipc	a2,0xa
ffffffffc0202440:	e7c60613          	addi	a2,a2,-388 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc0202444:	0f900593          	li	a1,249
ffffffffc0202448:	0000a517          	auipc	a0,0xa
ffffffffc020244c:	f6050513          	addi	a0,a0,-160 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0202450:	ffbfd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202454:	0000a617          	auipc	a2,0xa
ffffffffc0202458:	e6460613          	addi	a2,a2,-412 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc020245c:	0ec00593          	li	a1,236
ffffffffc0202460:	0000a517          	auipc	a0,0xa
ffffffffc0202464:	f4850513          	addi	a0,a0,-184 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0202468:	fe3fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020246c:	86aa                	mv	a3,a0
ffffffffc020246e:	0000a617          	auipc	a2,0xa
ffffffffc0202472:	e4a60613          	addi	a2,a2,-438 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc0202476:	0e800593          	li	a1,232
ffffffffc020247a:	0000a517          	auipc	a0,0xa
ffffffffc020247e:	f2e50513          	addi	a0,a0,-210 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0202482:	fc9fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202486:	0000a617          	auipc	a2,0xa
ffffffffc020248a:	e3260613          	addi	a2,a2,-462 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc020248e:	0f600593          	li	a1,246
ffffffffc0202492:	0000a517          	auipc	a0,0xa
ffffffffc0202496:	f1650513          	addi	a0,a0,-234 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc020249a:	fb1fd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020249e <get_page>:
ffffffffc020249e:	1141                	addi	sp,sp,-16
ffffffffc02024a0:	e022                	sd	s0,0(sp)
ffffffffc02024a2:	8432                	mv	s0,a2
ffffffffc02024a4:	4601                	li	a2,0
ffffffffc02024a6:	e406                	sd	ra,8(sp)
ffffffffc02024a8:	d99ff0ef          	jal	ffffffffc0202240 <get_pte>
ffffffffc02024ac:	c011                	beqz	s0,ffffffffc02024b0 <get_page+0x12>
ffffffffc02024ae:	e008                	sd	a0,0(s0)
ffffffffc02024b0:	c511                	beqz	a0,ffffffffc02024bc <get_page+0x1e>
ffffffffc02024b2:	611c                	ld	a5,0(a0)
ffffffffc02024b4:	4501                	li	a0,0
ffffffffc02024b6:	0017f713          	andi	a4,a5,1
ffffffffc02024ba:	e709                	bnez	a4,ffffffffc02024c4 <get_page+0x26>
ffffffffc02024bc:	60a2                	ld	ra,8(sp)
ffffffffc02024be:	6402                	ld	s0,0(sp)
ffffffffc02024c0:	0141                	addi	sp,sp,16
ffffffffc02024c2:	8082                	ret
ffffffffc02024c4:	00094717          	auipc	a4,0x94
ffffffffc02024c8:	3ec73703          	ld	a4,1004(a4) # ffffffffc02968b0 <npage>
ffffffffc02024cc:	078a                	slli	a5,a5,0x2
ffffffffc02024ce:	83b1                	srli	a5,a5,0xc
ffffffffc02024d0:	00e7ff63          	bgeu	a5,a4,ffffffffc02024ee <get_page+0x50>
ffffffffc02024d4:	00094517          	auipc	a0,0x94
ffffffffc02024d8:	3e453503          	ld	a0,996(a0) # ffffffffc02968b8 <pages>
ffffffffc02024dc:	60a2                	ld	ra,8(sp)
ffffffffc02024de:	6402                	ld	s0,0(sp)
ffffffffc02024e0:	079a                	slli	a5,a5,0x6
ffffffffc02024e2:	fe000737          	lui	a4,0xfe000
ffffffffc02024e6:	97ba                	add	a5,a5,a4
ffffffffc02024e8:	953e                	add	a0,a0,a5
ffffffffc02024ea:	0141                	addi	sp,sp,16
ffffffffc02024ec:	8082                	ret
ffffffffc02024ee:	c8fff0ef          	jal	ffffffffc020217c <pa2page.part.0>

ffffffffc02024f2 <unmap_range>:
ffffffffc02024f2:	715d                	addi	sp,sp,-80
ffffffffc02024f4:	00c5e7b3          	or	a5,a1,a2
ffffffffc02024f8:	e486                	sd	ra,72(sp)
ffffffffc02024fa:	e0a2                	sd	s0,64(sp)
ffffffffc02024fc:	fc26                	sd	s1,56(sp)
ffffffffc02024fe:	f84a                	sd	s2,48(sp)
ffffffffc0202500:	f44e                	sd	s3,40(sp)
ffffffffc0202502:	f052                	sd	s4,32(sp)
ffffffffc0202504:	ec56                	sd	s5,24(sp)
ffffffffc0202506:	03479713          	slli	a4,a5,0x34
ffffffffc020250a:	ef61                	bnez	a4,ffffffffc02025e2 <unmap_range+0xf0>
ffffffffc020250c:	00200a37          	lui	s4,0x200
ffffffffc0202510:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc0202514:	0145b733          	sltu	a4,a1,s4
ffffffffc0202518:	0017b793          	seqz	a5,a5
ffffffffc020251c:	8fd9                	or	a5,a5,a4
ffffffffc020251e:	842e                	mv	s0,a1
ffffffffc0202520:	84b2                	mv	s1,a2
ffffffffc0202522:	e3e5                	bnez	a5,ffffffffc0202602 <unmap_range+0x110>
ffffffffc0202524:	4785                	li	a5,1
ffffffffc0202526:	07fe                	slli	a5,a5,0x1f
ffffffffc0202528:	0785                	addi	a5,a5,1
ffffffffc020252a:	892a                	mv	s2,a0
ffffffffc020252c:	6985                	lui	s3,0x1
ffffffffc020252e:	ffe00ab7          	lui	s5,0xffe00
ffffffffc0202532:	0cf67863          	bgeu	a2,a5,ffffffffc0202602 <unmap_range+0x110>
ffffffffc0202536:	4601                	li	a2,0
ffffffffc0202538:	85a2                	mv	a1,s0
ffffffffc020253a:	854a                	mv	a0,s2
ffffffffc020253c:	d05ff0ef          	jal	ffffffffc0202240 <get_pte>
ffffffffc0202540:	87aa                	mv	a5,a0
ffffffffc0202542:	cd31                	beqz	a0,ffffffffc020259e <unmap_range+0xac>
ffffffffc0202544:	6118                	ld	a4,0(a0)
ffffffffc0202546:	ef11                	bnez	a4,ffffffffc0202562 <unmap_range+0x70>
ffffffffc0202548:	944e                	add	s0,s0,s3
ffffffffc020254a:	c019                	beqz	s0,ffffffffc0202550 <unmap_range+0x5e>
ffffffffc020254c:	fe9465e3          	bltu	s0,s1,ffffffffc0202536 <unmap_range+0x44>
ffffffffc0202550:	60a6                	ld	ra,72(sp)
ffffffffc0202552:	6406                	ld	s0,64(sp)
ffffffffc0202554:	74e2                	ld	s1,56(sp)
ffffffffc0202556:	7942                	ld	s2,48(sp)
ffffffffc0202558:	79a2                	ld	s3,40(sp)
ffffffffc020255a:	7a02                	ld	s4,32(sp)
ffffffffc020255c:	6ae2                	ld	s5,24(sp)
ffffffffc020255e:	6161                	addi	sp,sp,80
ffffffffc0202560:	8082                	ret
ffffffffc0202562:	00177693          	andi	a3,a4,1
ffffffffc0202566:	d2ed                	beqz	a3,ffffffffc0202548 <unmap_range+0x56>
ffffffffc0202568:	00094697          	auipc	a3,0x94
ffffffffc020256c:	3486b683          	ld	a3,840(a3) # ffffffffc02968b0 <npage>
ffffffffc0202570:	070a                	slli	a4,a4,0x2
ffffffffc0202572:	8331                	srli	a4,a4,0xc
ffffffffc0202574:	0ad77763          	bgeu	a4,a3,ffffffffc0202622 <unmap_range+0x130>
ffffffffc0202578:	00094517          	auipc	a0,0x94
ffffffffc020257c:	34053503          	ld	a0,832(a0) # ffffffffc02968b8 <pages>
ffffffffc0202580:	071a                	slli	a4,a4,0x6
ffffffffc0202582:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202586:	9736                	add	a4,a4,a3
ffffffffc0202588:	953a                	add	a0,a0,a4
ffffffffc020258a:	4118                	lw	a4,0(a0)
ffffffffc020258c:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3dd696ef>
ffffffffc020258e:	c118                	sw	a4,0(a0)
ffffffffc0202590:	cb19                	beqz	a4,ffffffffc02025a6 <unmap_range+0xb4>
ffffffffc0202592:	0007b023          	sd	zero,0(a5)
ffffffffc0202596:	12040073          	sfence.vma	s0
ffffffffc020259a:	944e                	add	s0,s0,s3
ffffffffc020259c:	b77d                	j	ffffffffc020254a <unmap_range+0x58>
ffffffffc020259e:	9452                	add	s0,s0,s4
ffffffffc02025a0:	01547433          	and	s0,s0,s5
ffffffffc02025a4:	b75d                	j	ffffffffc020254a <unmap_range+0x58>
ffffffffc02025a6:	10002773          	csrr	a4,sstatus
ffffffffc02025aa:	8b09                	andi	a4,a4,2
ffffffffc02025ac:	eb19                	bnez	a4,ffffffffc02025c2 <unmap_range+0xd0>
ffffffffc02025ae:	00094717          	auipc	a4,0x94
ffffffffc02025b2:	2e273703          	ld	a4,738(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc02025b6:	4585                	li	a1,1
ffffffffc02025b8:	e03e                	sd	a5,0(sp)
ffffffffc02025ba:	7318                	ld	a4,32(a4)
ffffffffc02025bc:	9702                	jalr	a4
ffffffffc02025be:	6782                	ld	a5,0(sp)
ffffffffc02025c0:	bfc9                	j	ffffffffc0202592 <unmap_range+0xa0>
ffffffffc02025c2:	e43e                	sd	a5,8(sp)
ffffffffc02025c4:	e02a                	sd	a0,0(sp)
ffffffffc02025c6:	e36fe0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc02025ca:	00094717          	auipc	a4,0x94
ffffffffc02025ce:	2c673703          	ld	a4,710(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc02025d2:	6502                	ld	a0,0(sp)
ffffffffc02025d4:	4585                	li	a1,1
ffffffffc02025d6:	7318                	ld	a4,32(a4)
ffffffffc02025d8:	9702                	jalr	a4
ffffffffc02025da:	e1cfe0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc02025de:	67a2                	ld	a5,8(sp)
ffffffffc02025e0:	bf4d                	j	ffffffffc0202592 <unmap_range+0xa0>
ffffffffc02025e2:	0000a697          	auipc	a3,0xa
ffffffffc02025e6:	dd668693          	addi	a3,a3,-554 # ffffffffc020c3b8 <etext+0xfb6>
ffffffffc02025ea:	00009617          	auipc	a2,0x9
ffffffffc02025ee:	25660613          	addi	a2,a2,598 # ffffffffc020b840 <etext+0x43e>
ffffffffc02025f2:	12100593          	li	a1,289
ffffffffc02025f6:	0000a517          	auipc	a0,0xa
ffffffffc02025fa:	db250513          	addi	a0,a0,-590 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02025fe:	e4dfd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202602:	0000a697          	auipc	a3,0xa
ffffffffc0202606:	de668693          	addi	a3,a3,-538 # ffffffffc020c3e8 <etext+0xfe6>
ffffffffc020260a:	00009617          	auipc	a2,0x9
ffffffffc020260e:	23660613          	addi	a2,a2,566 # ffffffffc020b840 <etext+0x43e>
ffffffffc0202612:	12200593          	li	a1,290
ffffffffc0202616:	0000a517          	auipc	a0,0xa
ffffffffc020261a:	d9250513          	addi	a0,a0,-622 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc020261e:	e2dfd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202622:	b5bff0ef          	jal	ffffffffc020217c <pa2page.part.0>

ffffffffc0202626 <exit_range>:
ffffffffc0202626:	7135                	addi	sp,sp,-160
ffffffffc0202628:	00c5e7b3          	or	a5,a1,a2
ffffffffc020262c:	ed06                	sd	ra,152(sp)
ffffffffc020262e:	e922                	sd	s0,144(sp)
ffffffffc0202630:	e526                	sd	s1,136(sp)
ffffffffc0202632:	e14a                	sd	s2,128(sp)
ffffffffc0202634:	fcce                	sd	s3,120(sp)
ffffffffc0202636:	f8d2                	sd	s4,112(sp)
ffffffffc0202638:	f4d6                	sd	s5,104(sp)
ffffffffc020263a:	f0da                	sd	s6,96(sp)
ffffffffc020263c:	ecde                	sd	s7,88(sp)
ffffffffc020263e:	17d2                	slli	a5,a5,0x34
ffffffffc0202640:	22079263          	bnez	a5,ffffffffc0202864 <exit_range+0x23e>
ffffffffc0202644:	00200937          	lui	s2,0x200
ffffffffc0202648:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc020264c:	0125b733          	sltu	a4,a1,s2
ffffffffc0202650:	0017b793          	seqz	a5,a5
ffffffffc0202654:	8fd9                	or	a5,a5,a4
ffffffffc0202656:	26079263          	bnez	a5,ffffffffc02028ba <exit_range+0x294>
ffffffffc020265a:	4785                	li	a5,1
ffffffffc020265c:	07fe                	slli	a5,a5,0x1f
ffffffffc020265e:	0785                	addi	a5,a5,1
ffffffffc0202660:	24f67d63          	bgeu	a2,a5,ffffffffc02028ba <exit_range+0x294>
ffffffffc0202664:	c00004b7          	lui	s1,0xc0000
ffffffffc0202668:	ffe007b7          	lui	a5,0xffe00
ffffffffc020266c:	8a2a                	mv	s4,a0
ffffffffc020266e:	8ced                	and	s1,s1,a1
ffffffffc0202670:	00f5f833          	and	a6,a1,a5
ffffffffc0202674:	00094a97          	auipc	s5,0x94
ffffffffc0202678:	23ca8a93          	addi	s5,s5,572 # ffffffffc02968b0 <npage>
ffffffffc020267c:	400009b7          	lui	s3,0x40000
ffffffffc0202680:	a809                	j	ffffffffc0202692 <exit_range+0x6c>
ffffffffc0202682:	013487b3          	add	a5,s1,s3
ffffffffc0202686:	400004b7          	lui	s1,0x40000
ffffffffc020268a:	8826                	mv	a6,s1
ffffffffc020268c:	c3f1                	beqz	a5,ffffffffc0202750 <exit_range+0x12a>
ffffffffc020268e:	0cc7f163          	bgeu	a5,a2,ffffffffc0202750 <exit_range+0x12a>
ffffffffc0202692:	01e4d413          	srli	s0,s1,0x1e
ffffffffc0202696:	1ff47413          	andi	s0,s0,511
ffffffffc020269a:	040e                	slli	s0,s0,0x3
ffffffffc020269c:	9452                	add	s0,s0,s4
ffffffffc020269e:	00043883          	ld	a7,0(s0)
ffffffffc02026a2:	0018f793          	andi	a5,a7,1
ffffffffc02026a6:	dff1                	beqz	a5,ffffffffc0202682 <exit_range+0x5c>
ffffffffc02026a8:	000ab783          	ld	a5,0(s5)
ffffffffc02026ac:	088a                	slli	a7,a7,0x2
ffffffffc02026ae:	00c8d893          	srli	a7,a7,0xc
ffffffffc02026b2:	20f8f263          	bgeu	a7,a5,ffffffffc02028b6 <exit_range+0x290>
ffffffffc02026b6:	fff802b7          	lui	t0,0xfff80
ffffffffc02026ba:	00588f33          	add	t5,a7,t0
ffffffffc02026be:	000803b7          	lui	t2,0x80
ffffffffc02026c2:	007f0733          	add	a4,t5,t2
ffffffffc02026c6:	00c71e13          	slli	t3,a4,0xc
ffffffffc02026ca:	0f1a                	slli	t5,t5,0x6
ffffffffc02026cc:	1cf77863          	bgeu	a4,a5,ffffffffc020289c <exit_range+0x276>
ffffffffc02026d0:	00094f97          	auipc	t6,0x94
ffffffffc02026d4:	1d8f8f93          	addi	t6,t6,472 # ffffffffc02968a8 <va_pa_offset>
ffffffffc02026d8:	000fb783          	ld	a5,0(t6)
ffffffffc02026dc:	4e85                	li	t4,1
ffffffffc02026de:	6b05                	lui	s6,0x1
ffffffffc02026e0:	9e3e                	add	t3,t3,a5
ffffffffc02026e2:	01348333          	add	t1,s1,s3
ffffffffc02026e6:	01585713          	srli	a4,a6,0x15
ffffffffc02026ea:	1ff77713          	andi	a4,a4,511
ffffffffc02026ee:	070e                	slli	a4,a4,0x3
ffffffffc02026f0:	9772                	add	a4,a4,t3
ffffffffc02026f2:	631c                	ld	a5,0(a4)
ffffffffc02026f4:	0017f693          	andi	a3,a5,1
ffffffffc02026f8:	e6bd                	bnez	a3,ffffffffc0202766 <exit_range+0x140>
ffffffffc02026fa:	4e81                	li	t4,0
ffffffffc02026fc:	984a                	add	a6,a6,s2
ffffffffc02026fe:	00080863          	beqz	a6,ffffffffc020270e <exit_range+0xe8>
ffffffffc0202702:	879a                	mv	a5,t1
ffffffffc0202704:	00667363          	bgeu	a2,t1,ffffffffc020270a <exit_range+0xe4>
ffffffffc0202708:	87b2                	mv	a5,a2
ffffffffc020270a:	fcf86ee3          	bltu	a6,a5,ffffffffc02026e6 <exit_range+0xc0>
ffffffffc020270e:	f60e8ae3          	beqz	t4,ffffffffc0202682 <exit_range+0x5c>
ffffffffc0202712:	000ab783          	ld	a5,0(s5)
ffffffffc0202716:	1af8f063          	bgeu	a7,a5,ffffffffc02028b6 <exit_range+0x290>
ffffffffc020271a:	00094517          	auipc	a0,0x94
ffffffffc020271e:	19e53503          	ld	a0,414(a0) # ffffffffc02968b8 <pages>
ffffffffc0202722:	957a                	add	a0,a0,t5
ffffffffc0202724:	100027f3          	csrr	a5,sstatus
ffffffffc0202728:	8b89                	andi	a5,a5,2
ffffffffc020272a:	10079b63          	bnez	a5,ffffffffc0202840 <exit_range+0x21a>
ffffffffc020272e:	00094797          	auipc	a5,0x94
ffffffffc0202732:	1627b783          	ld	a5,354(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202736:	4585                	li	a1,1
ffffffffc0202738:	e432                	sd	a2,8(sp)
ffffffffc020273a:	739c                	ld	a5,32(a5)
ffffffffc020273c:	9782                	jalr	a5
ffffffffc020273e:	6622                	ld	a2,8(sp)
ffffffffc0202740:	00043023          	sd	zero,0(s0)
ffffffffc0202744:	013487b3          	add	a5,s1,s3
ffffffffc0202748:	400004b7          	lui	s1,0x40000
ffffffffc020274c:	8826                	mv	a6,s1
ffffffffc020274e:	f3a1                	bnez	a5,ffffffffc020268e <exit_range+0x68>
ffffffffc0202750:	60ea                	ld	ra,152(sp)
ffffffffc0202752:	644a                	ld	s0,144(sp)
ffffffffc0202754:	64aa                	ld	s1,136(sp)
ffffffffc0202756:	690a                	ld	s2,128(sp)
ffffffffc0202758:	79e6                	ld	s3,120(sp)
ffffffffc020275a:	7a46                	ld	s4,112(sp)
ffffffffc020275c:	7aa6                	ld	s5,104(sp)
ffffffffc020275e:	7b06                	ld	s6,96(sp)
ffffffffc0202760:	6be6                	ld	s7,88(sp)
ffffffffc0202762:	610d                	addi	sp,sp,160
ffffffffc0202764:	8082                	ret
ffffffffc0202766:	000ab503          	ld	a0,0(s5)
ffffffffc020276a:	078a                	slli	a5,a5,0x2
ffffffffc020276c:	83b1                	srli	a5,a5,0xc
ffffffffc020276e:	14a7f463          	bgeu	a5,a0,ffffffffc02028b6 <exit_range+0x290>
ffffffffc0202772:	9796                	add	a5,a5,t0
ffffffffc0202774:	00778bb3          	add	s7,a5,t2
ffffffffc0202778:	00679593          	slli	a1,a5,0x6
ffffffffc020277c:	00cb9693          	slli	a3,s7,0xc
ffffffffc0202780:	10abf263          	bgeu	s7,a0,ffffffffc0202884 <exit_range+0x25e>
ffffffffc0202784:	000fb783          	ld	a5,0(t6)
ffffffffc0202788:	96be                	add	a3,a3,a5
ffffffffc020278a:	01668533          	add	a0,a3,s6
ffffffffc020278e:	629c                	ld	a5,0(a3)
ffffffffc0202790:	8b85                	andi	a5,a5,1
ffffffffc0202792:	f7ad                	bnez	a5,ffffffffc02026fc <exit_range+0xd6>
ffffffffc0202794:	06a1                	addi	a3,a3,8
ffffffffc0202796:	fea69ce3          	bne	a3,a0,ffffffffc020278e <exit_range+0x168>
ffffffffc020279a:	00094517          	auipc	a0,0x94
ffffffffc020279e:	11e53503          	ld	a0,286(a0) # ffffffffc02968b8 <pages>
ffffffffc02027a2:	952e                	add	a0,a0,a1
ffffffffc02027a4:	100027f3          	csrr	a5,sstatus
ffffffffc02027a8:	8b89                	andi	a5,a5,2
ffffffffc02027aa:	e3b9                	bnez	a5,ffffffffc02027f0 <exit_range+0x1ca>
ffffffffc02027ac:	00094797          	auipc	a5,0x94
ffffffffc02027b0:	0e47b783          	ld	a5,228(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02027b4:	4585                	li	a1,1
ffffffffc02027b6:	e0b2                	sd	a2,64(sp)
ffffffffc02027b8:	739c                	ld	a5,32(a5)
ffffffffc02027ba:	fc1a                	sd	t1,56(sp)
ffffffffc02027bc:	f846                	sd	a7,48(sp)
ffffffffc02027be:	f47a                	sd	t5,40(sp)
ffffffffc02027c0:	f072                	sd	t3,32(sp)
ffffffffc02027c2:	ec76                	sd	t4,24(sp)
ffffffffc02027c4:	e842                	sd	a6,16(sp)
ffffffffc02027c6:	e43a                	sd	a4,8(sp)
ffffffffc02027c8:	9782                	jalr	a5
ffffffffc02027ca:	6722                	ld	a4,8(sp)
ffffffffc02027cc:	6842                	ld	a6,16(sp)
ffffffffc02027ce:	6ee2                	ld	t4,24(sp)
ffffffffc02027d0:	7e02                	ld	t3,32(sp)
ffffffffc02027d2:	7f22                	ld	t5,40(sp)
ffffffffc02027d4:	78c2                	ld	a7,48(sp)
ffffffffc02027d6:	7362                	ld	t1,56(sp)
ffffffffc02027d8:	6606                	ld	a2,64(sp)
ffffffffc02027da:	fff802b7          	lui	t0,0xfff80
ffffffffc02027de:	000803b7          	lui	t2,0x80
ffffffffc02027e2:	00094f97          	auipc	t6,0x94
ffffffffc02027e6:	0c6f8f93          	addi	t6,t6,198 # ffffffffc02968a8 <va_pa_offset>
ffffffffc02027ea:	00073023          	sd	zero,0(a4)
ffffffffc02027ee:	b739                	j	ffffffffc02026fc <exit_range+0xd6>
ffffffffc02027f0:	e4b2                	sd	a2,72(sp)
ffffffffc02027f2:	e09a                	sd	t1,64(sp)
ffffffffc02027f4:	fc46                	sd	a7,56(sp)
ffffffffc02027f6:	f47a                	sd	t5,40(sp)
ffffffffc02027f8:	f072                	sd	t3,32(sp)
ffffffffc02027fa:	ec76                	sd	t4,24(sp)
ffffffffc02027fc:	e842                	sd	a6,16(sp)
ffffffffc02027fe:	e43a                	sd	a4,8(sp)
ffffffffc0202800:	f82a                	sd	a0,48(sp)
ffffffffc0202802:	bfafe0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0202806:	00094797          	auipc	a5,0x94
ffffffffc020280a:	08a7b783          	ld	a5,138(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc020280e:	7542                	ld	a0,48(sp)
ffffffffc0202810:	4585                	li	a1,1
ffffffffc0202812:	739c                	ld	a5,32(a5)
ffffffffc0202814:	9782                	jalr	a5
ffffffffc0202816:	be0fe0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc020281a:	6722                	ld	a4,8(sp)
ffffffffc020281c:	6626                	ld	a2,72(sp)
ffffffffc020281e:	6306                	ld	t1,64(sp)
ffffffffc0202820:	78e2                	ld	a7,56(sp)
ffffffffc0202822:	7f22                	ld	t5,40(sp)
ffffffffc0202824:	7e02                	ld	t3,32(sp)
ffffffffc0202826:	6ee2                	ld	t4,24(sp)
ffffffffc0202828:	6842                	ld	a6,16(sp)
ffffffffc020282a:	00094f97          	auipc	t6,0x94
ffffffffc020282e:	07ef8f93          	addi	t6,t6,126 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202832:	000803b7          	lui	t2,0x80
ffffffffc0202836:	fff802b7          	lui	t0,0xfff80
ffffffffc020283a:	00073023          	sd	zero,0(a4)
ffffffffc020283e:	bd7d                	j	ffffffffc02026fc <exit_range+0xd6>
ffffffffc0202840:	e832                	sd	a2,16(sp)
ffffffffc0202842:	e42a                	sd	a0,8(sp)
ffffffffc0202844:	bb8fe0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0202848:	00094797          	auipc	a5,0x94
ffffffffc020284c:	0487b783          	ld	a5,72(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202850:	6522                	ld	a0,8(sp)
ffffffffc0202852:	4585                	li	a1,1
ffffffffc0202854:	739c                	ld	a5,32(a5)
ffffffffc0202856:	9782                	jalr	a5
ffffffffc0202858:	b9efe0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc020285c:	6642                	ld	a2,16(sp)
ffffffffc020285e:	00043023          	sd	zero,0(s0)
ffffffffc0202862:	b5cd                	j	ffffffffc0202744 <exit_range+0x11e>
ffffffffc0202864:	0000a697          	auipc	a3,0xa
ffffffffc0202868:	b5468693          	addi	a3,a3,-1196 # ffffffffc020c3b8 <etext+0xfb6>
ffffffffc020286c:	00009617          	auipc	a2,0x9
ffffffffc0202870:	fd460613          	addi	a2,a2,-44 # ffffffffc020b840 <etext+0x43e>
ffffffffc0202874:	13600593          	li	a1,310
ffffffffc0202878:	0000a517          	auipc	a0,0xa
ffffffffc020287c:	b3050513          	addi	a0,a0,-1232 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0202880:	bcbfd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202884:	0000a617          	auipc	a2,0xa
ffffffffc0202888:	a3460613          	addi	a2,a2,-1484 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc020288c:	07100593          	li	a1,113
ffffffffc0202890:	0000a517          	auipc	a0,0xa
ffffffffc0202894:	a5050513          	addi	a0,a0,-1456 # ffffffffc020c2e0 <etext+0xede>
ffffffffc0202898:	bb3fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020289c:	86f2                	mv	a3,t3
ffffffffc020289e:	0000a617          	auipc	a2,0xa
ffffffffc02028a2:	a1a60613          	addi	a2,a2,-1510 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc02028a6:	07100593          	li	a1,113
ffffffffc02028aa:	0000a517          	auipc	a0,0xa
ffffffffc02028ae:	a3650513          	addi	a0,a0,-1482 # ffffffffc020c2e0 <etext+0xede>
ffffffffc02028b2:	b99fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02028b6:	8c7ff0ef          	jal	ffffffffc020217c <pa2page.part.0>
ffffffffc02028ba:	0000a697          	auipc	a3,0xa
ffffffffc02028be:	b2e68693          	addi	a3,a3,-1234 # ffffffffc020c3e8 <etext+0xfe6>
ffffffffc02028c2:	00009617          	auipc	a2,0x9
ffffffffc02028c6:	f7e60613          	addi	a2,a2,-130 # ffffffffc020b840 <etext+0x43e>
ffffffffc02028ca:	13700593          	li	a1,311
ffffffffc02028ce:	0000a517          	auipc	a0,0xa
ffffffffc02028d2:	ada50513          	addi	a0,a0,-1318 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02028d6:	b75fd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02028da <page_remove>:
ffffffffc02028da:	1101                	addi	sp,sp,-32
ffffffffc02028dc:	4601                	li	a2,0
ffffffffc02028de:	e822                	sd	s0,16(sp)
ffffffffc02028e0:	ec06                	sd	ra,24(sp)
ffffffffc02028e2:	842e                	mv	s0,a1
ffffffffc02028e4:	95dff0ef          	jal	ffffffffc0202240 <get_pte>
ffffffffc02028e8:	c511                	beqz	a0,ffffffffc02028f4 <page_remove+0x1a>
ffffffffc02028ea:	6118                	ld	a4,0(a0)
ffffffffc02028ec:	87aa                	mv	a5,a0
ffffffffc02028ee:	00177693          	andi	a3,a4,1
ffffffffc02028f2:	e689                	bnez	a3,ffffffffc02028fc <page_remove+0x22>
ffffffffc02028f4:	60e2                	ld	ra,24(sp)
ffffffffc02028f6:	6442                	ld	s0,16(sp)
ffffffffc02028f8:	6105                	addi	sp,sp,32
ffffffffc02028fa:	8082                	ret
ffffffffc02028fc:	00094697          	auipc	a3,0x94
ffffffffc0202900:	fb46b683          	ld	a3,-76(a3) # ffffffffc02968b0 <npage>
ffffffffc0202904:	070a                	slli	a4,a4,0x2
ffffffffc0202906:	8331                	srli	a4,a4,0xc
ffffffffc0202908:	06d77563          	bgeu	a4,a3,ffffffffc0202972 <page_remove+0x98>
ffffffffc020290c:	00094517          	auipc	a0,0x94
ffffffffc0202910:	fac53503          	ld	a0,-84(a0) # ffffffffc02968b8 <pages>
ffffffffc0202914:	071a                	slli	a4,a4,0x6
ffffffffc0202916:	fe0006b7          	lui	a3,0xfe000
ffffffffc020291a:	9736                	add	a4,a4,a3
ffffffffc020291c:	953a                	add	a0,a0,a4
ffffffffc020291e:	4118                	lw	a4,0(a0)
ffffffffc0202920:	377d                	addiw	a4,a4,-1
ffffffffc0202922:	c118                	sw	a4,0(a0)
ffffffffc0202924:	cb09                	beqz	a4,ffffffffc0202936 <page_remove+0x5c>
ffffffffc0202926:	0007b023          	sd	zero,0(a5)
ffffffffc020292a:	12040073          	sfence.vma	s0
ffffffffc020292e:	60e2                	ld	ra,24(sp)
ffffffffc0202930:	6442                	ld	s0,16(sp)
ffffffffc0202932:	6105                	addi	sp,sp,32
ffffffffc0202934:	8082                	ret
ffffffffc0202936:	10002773          	csrr	a4,sstatus
ffffffffc020293a:	8b09                	andi	a4,a4,2
ffffffffc020293c:	eb19                	bnez	a4,ffffffffc0202952 <page_remove+0x78>
ffffffffc020293e:	00094717          	auipc	a4,0x94
ffffffffc0202942:	f5273703          	ld	a4,-174(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc0202946:	4585                	li	a1,1
ffffffffc0202948:	e03e                	sd	a5,0(sp)
ffffffffc020294a:	7318                	ld	a4,32(a4)
ffffffffc020294c:	9702                	jalr	a4
ffffffffc020294e:	6782                	ld	a5,0(sp)
ffffffffc0202950:	bfd9                	j	ffffffffc0202926 <page_remove+0x4c>
ffffffffc0202952:	e43e                	sd	a5,8(sp)
ffffffffc0202954:	e02a                	sd	a0,0(sp)
ffffffffc0202956:	aa6fe0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc020295a:	00094717          	auipc	a4,0x94
ffffffffc020295e:	f3673703          	ld	a4,-202(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc0202962:	6502                	ld	a0,0(sp)
ffffffffc0202964:	4585                	li	a1,1
ffffffffc0202966:	7318                	ld	a4,32(a4)
ffffffffc0202968:	9702                	jalr	a4
ffffffffc020296a:	a8cfe0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc020296e:	67a2                	ld	a5,8(sp)
ffffffffc0202970:	bf5d                	j	ffffffffc0202926 <page_remove+0x4c>
ffffffffc0202972:	80bff0ef          	jal	ffffffffc020217c <pa2page.part.0>

ffffffffc0202976 <page_insert>:
ffffffffc0202976:	7139                	addi	sp,sp,-64
ffffffffc0202978:	f426                	sd	s1,40(sp)
ffffffffc020297a:	84b2                	mv	s1,a2
ffffffffc020297c:	f822                	sd	s0,48(sp)
ffffffffc020297e:	4605                	li	a2,1
ffffffffc0202980:	842e                	mv	s0,a1
ffffffffc0202982:	85a6                	mv	a1,s1
ffffffffc0202984:	fc06                	sd	ra,56(sp)
ffffffffc0202986:	e436                	sd	a3,8(sp)
ffffffffc0202988:	8b9ff0ef          	jal	ffffffffc0202240 <get_pte>
ffffffffc020298c:	cd61                	beqz	a0,ffffffffc0202a64 <page_insert+0xee>
ffffffffc020298e:	400c                	lw	a1,0(s0)
ffffffffc0202990:	611c                	ld	a5,0(a0)
ffffffffc0202992:	66a2                	ld	a3,8(sp)
ffffffffc0202994:	0015861b          	addiw	a2,a1,1 # 1001 <_binary_bin_swap_img_size-0x6cff>
ffffffffc0202998:	c010                	sw	a2,0(s0)
ffffffffc020299a:	0017f613          	andi	a2,a5,1
ffffffffc020299e:	872a                	mv	a4,a0
ffffffffc02029a0:	e61d                	bnez	a2,ffffffffc02029ce <page_insert+0x58>
ffffffffc02029a2:	00094617          	auipc	a2,0x94
ffffffffc02029a6:	f1663603          	ld	a2,-234(a2) # ffffffffc02968b8 <pages>
ffffffffc02029aa:	8c11                	sub	s0,s0,a2
ffffffffc02029ac:	8419                	srai	s0,s0,0x6
ffffffffc02029ae:	200007b7          	lui	a5,0x20000
ffffffffc02029b2:	042a                	slli	s0,s0,0xa
ffffffffc02029b4:	943e                	add	s0,s0,a5
ffffffffc02029b6:	8ec1                	or	a3,a3,s0
ffffffffc02029b8:	0016e693          	ori	a3,a3,1
ffffffffc02029bc:	e314                	sd	a3,0(a4)
ffffffffc02029be:	12048073          	sfence.vma	s1
ffffffffc02029c2:	4501                	li	a0,0
ffffffffc02029c4:	70e2                	ld	ra,56(sp)
ffffffffc02029c6:	7442                	ld	s0,48(sp)
ffffffffc02029c8:	74a2                	ld	s1,40(sp)
ffffffffc02029ca:	6121                	addi	sp,sp,64
ffffffffc02029cc:	8082                	ret
ffffffffc02029ce:	00094617          	auipc	a2,0x94
ffffffffc02029d2:	ee263603          	ld	a2,-286(a2) # ffffffffc02968b0 <npage>
ffffffffc02029d6:	078a                	slli	a5,a5,0x2
ffffffffc02029d8:	83b1                	srli	a5,a5,0xc
ffffffffc02029da:	08c7f763          	bgeu	a5,a2,ffffffffc0202a68 <page_insert+0xf2>
ffffffffc02029de:	00094617          	auipc	a2,0x94
ffffffffc02029e2:	eda63603          	ld	a2,-294(a2) # ffffffffc02968b8 <pages>
ffffffffc02029e6:	fe000537          	lui	a0,0xfe000
ffffffffc02029ea:	079a                	slli	a5,a5,0x6
ffffffffc02029ec:	97aa                	add	a5,a5,a0
ffffffffc02029ee:	00f60533          	add	a0,a2,a5
ffffffffc02029f2:	00a40963          	beq	s0,a0,ffffffffc0202a04 <page_insert+0x8e>
ffffffffc02029f6:	411c                	lw	a5,0(a0)
ffffffffc02029f8:	37fd                	addiw	a5,a5,-1 # 1fffffff <_binary_bin_sfs_img_size+0x1ff8acff>
ffffffffc02029fa:	c11c                	sw	a5,0(a0)
ffffffffc02029fc:	c791                	beqz	a5,ffffffffc0202a08 <page_insert+0x92>
ffffffffc02029fe:	12048073          	sfence.vma	s1
ffffffffc0202a02:	b765                	j	ffffffffc02029aa <page_insert+0x34>
ffffffffc0202a04:	c00c                	sw	a1,0(s0)
ffffffffc0202a06:	b755                	j	ffffffffc02029aa <page_insert+0x34>
ffffffffc0202a08:	100027f3          	csrr	a5,sstatus
ffffffffc0202a0c:	8b89                	andi	a5,a5,2
ffffffffc0202a0e:	e39d                	bnez	a5,ffffffffc0202a34 <page_insert+0xbe>
ffffffffc0202a10:	00094797          	auipc	a5,0x94
ffffffffc0202a14:	e807b783          	ld	a5,-384(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202a18:	4585                	li	a1,1
ffffffffc0202a1a:	e83a                	sd	a4,16(sp)
ffffffffc0202a1c:	739c                	ld	a5,32(a5)
ffffffffc0202a1e:	e436                	sd	a3,8(sp)
ffffffffc0202a20:	9782                	jalr	a5
ffffffffc0202a22:	00094617          	auipc	a2,0x94
ffffffffc0202a26:	e9663603          	ld	a2,-362(a2) # ffffffffc02968b8 <pages>
ffffffffc0202a2a:	66a2                	ld	a3,8(sp)
ffffffffc0202a2c:	6742                	ld	a4,16(sp)
ffffffffc0202a2e:	12048073          	sfence.vma	s1
ffffffffc0202a32:	bfa5                	j	ffffffffc02029aa <page_insert+0x34>
ffffffffc0202a34:	ec3a                	sd	a4,24(sp)
ffffffffc0202a36:	e836                	sd	a3,16(sp)
ffffffffc0202a38:	e42a                	sd	a0,8(sp)
ffffffffc0202a3a:	9c2fe0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0202a3e:	00094797          	auipc	a5,0x94
ffffffffc0202a42:	e527b783          	ld	a5,-430(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202a46:	6522                	ld	a0,8(sp)
ffffffffc0202a48:	4585                	li	a1,1
ffffffffc0202a4a:	739c                	ld	a5,32(a5)
ffffffffc0202a4c:	9782                	jalr	a5
ffffffffc0202a4e:	9a8fe0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc0202a52:	00094617          	auipc	a2,0x94
ffffffffc0202a56:	e6663603          	ld	a2,-410(a2) # ffffffffc02968b8 <pages>
ffffffffc0202a5a:	6762                	ld	a4,24(sp)
ffffffffc0202a5c:	66c2                	ld	a3,16(sp)
ffffffffc0202a5e:	12048073          	sfence.vma	s1
ffffffffc0202a62:	b7a1                	j	ffffffffc02029aa <page_insert+0x34>
ffffffffc0202a64:	5571                	li	a0,-4
ffffffffc0202a66:	bfb9                	j	ffffffffc02029c4 <page_insert+0x4e>
ffffffffc0202a68:	f14ff0ef          	jal	ffffffffc020217c <pa2page.part.0>

ffffffffc0202a6c <pmm_init>:
ffffffffc0202a6c:	0000c797          	auipc	a5,0xc
ffffffffc0202a70:	f5c78793          	addi	a5,a5,-164 # ffffffffc020e9c8 <default_pmm_manager>
ffffffffc0202a74:	638c                	ld	a1,0(a5)
ffffffffc0202a76:	7159                	addi	sp,sp,-112
ffffffffc0202a78:	f486                	sd	ra,104(sp)
ffffffffc0202a7a:	e8ca                	sd	s2,80(sp)
ffffffffc0202a7c:	e4ce                	sd	s3,72(sp)
ffffffffc0202a7e:	f85a                	sd	s6,48(sp)
ffffffffc0202a80:	f0a2                	sd	s0,96(sp)
ffffffffc0202a82:	eca6                	sd	s1,88(sp)
ffffffffc0202a84:	e0d2                	sd	s4,64(sp)
ffffffffc0202a86:	fc56                	sd	s5,56(sp)
ffffffffc0202a88:	f45e                	sd	s7,40(sp)
ffffffffc0202a8a:	f062                	sd	s8,32(sp)
ffffffffc0202a8c:	ec66                	sd	s9,24(sp)
ffffffffc0202a8e:	00094b17          	auipc	s6,0x94
ffffffffc0202a92:	e02b0b13          	addi	s6,s6,-510 # ffffffffc0296890 <pmm_manager>
ffffffffc0202a96:	0000a517          	auipc	a0,0xa
ffffffffc0202a9a:	96a50513          	addi	a0,a0,-1686 # ffffffffc020c400 <etext+0xffe>
ffffffffc0202a9e:	00fb3023          	sd	a5,0(s6)
ffffffffc0202aa2:	f04fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202aa6:	000b3783          	ld	a5,0(s6)
ffffffffc0202aaa:	00094997          	auipc	s3,0x94
ffffffffc0202aae:	dfe98993          	addi	s3,s3,-514 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202ab2:	679c                	ld	a5,8(a5)
ffffffffc0202ab4:	9782                	jalr	a5
ffffffffc0202ab6:	57f5                	li	a5,-3
ffffffffc0202ab8:	07fa                	slli	a5,a5,0x1e
ffffffffc0202aba:	00f9b023          	sd	a5,0(s3)
ffffffffc0202abe:	f0ffd0ef          	jal	ffffffffc02009cc <get_memory_base>
ffffffffc0202ac2:	892a                	mv	s2,a0
ffffffffc0202ac4:	f13fd0ef          	jal	ffffffffc02009d6 <get_memory_size>
ffffffffc0202ac8:	70050e63          	beqz	a0,ffffffffc02031e4 <pmm_init+0x778>
ffffffffc0202acc:	84aa                	mv	s1,a0
ffffffffc0202ace:	0000a517          	auipc	a0,0xa
ffffffffc0202ad2:	96a50513          	addi	a0,a0,-1686 # ffffffffc020c438 <etext+0x1036>
ffffffffc0202ad6:	ed0fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202ada:	00990433          	add	s0,s2,s1
ffffffffc0202ade:	864a                	mv	a2,s2
ffffffffc0202ae0:	85a6                	mv	a1,s1
ffffffffc0202ae2:	fff40693          	addi	a3,s0,-1
ffffffffc0202ae6:	0000a517          	auipc	a0,0xa
ffffffffc0202aea:	96a50513          	addi	a0,a0,-1686 # ffffffffc020c450 <etext+0x104e>
ffffffffc0202aee:	eb8fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202af2:	c80007b7          	lui	a5,0xc8000
ffffffffc0202af6:	8522                	mv	a0,s0
ffffffffc0202af8:	5287ed63          	bltu	a5,s0,ffffffffc0203032 <pmm_init+0x5c6>
ffffffffc0202afc:	77fd                	lui	a5,0xfffff
ffffffffc0202afe:	00095617          	auipc	a2,0x95
ffffffffc0202b02:	e1160613          	addi	a2,a2,-495 # ffffffffc029790f <end+0xfff>
ffffffffc0202b06:	8e7d                	and	a2,a2,a5
ffffffffc0202b08:	8131                	srli	a0,a0,0xc
ffffffffc0202b0a:	00094b97          	auipc	s7,0x94
ffffffffc0202b0e:	daeb8b93          	addi	s7,s7,-594 # ffffffffc02968b8 <pages>
ffffffffc0202b12:	00094497          	auipc	s1,0x94
ffffffffc0202b16:	d9e48493          	addi	s1,s1,-610 # ffffffffc02968b0 <npage>
ffffffffc0202b1a:	00cbb023          	sd	a2,0(s7)
ffffffffc0202b1e:	e088                	sd	a0,0(s1)
ffffffffc0202b20:	000807b7          	lui	a5,0x80
ffffffffc0202b24:	86b2                	mv	a3,a2
ffffffffc0202b26:	02f50763          	beq	a0,a5,ffffffffc0202b54 <pmm_init+0xe8>
ffffffffc0202b2a:	4701                	li	a4,0
ffffffffc0202b2c:	4585                	li	a1,1
ffffffffc0202b2e:	fff806b7          	lui	a3,0xfff80
ffffffffc0202b32:	00671793          	slli	a5,a4,0x6
ffffffffc0202b36:	97b2                	add	a5,a5,a2
ffffffffc0202b38:	07a1                	addi	a5,a5,8 # 80008 <_binary_bin_sfs_img_size+0xad08>
ffffffffc0202b3a:	40b7b02f          	amoor.d	zero,a1,(a5)
ffffffffc0202b3e:	6088                	ld	a0,0(s1)
ffffffffc0202b40:	0705                	addi	a4,a4,1
ffffffffc0202b42:	000bb603          	ld	a2,0(s7)
ffffffffc0202b46:	00d507b3          	add	a5,a0,a3
ffffffffc0202b4a:	fef764e3          	bltu	a4,a5,ffffffffc0202b32 <pmm_init+0xc6>
ffffffffc0202b4e:	079a                	slli	a5,a5,0x6
ffffffffc0202b50:	00f606b3          	add	a3,a2,a5
ffffffffc0202b54:	c02007b7          	lui	a5,0xc0200
ffffffffc0202b58:	16f6eee3          	bltu	a3,a5,ffffffffc02034d4 <pmm_init+0xa68>
ffffffffc0202b5c:	0009b583          	ld	a1,0(s3)
ffffffffc0202b60:	77fd                	lui	a5,0xfffff
ffffffffc0202b62:	8c7d                	and	s0,s0,a5
ffffffffc0202b64:	8e8d                	sub	a3,a3,a1
ffffffffc0202b66:	4e86ed63          	bltu	a3,s0,ffffffffc0203060 <pmm_init+0x5f4>
ffffffffc0202b6a:	0000a517          	auipc	a0,0xa
ffffffffc0202b6e:	90e50513          	addi	a0,a0,-1778 # ffffffffc020c478 <etext+0x1076>
ffffffffc0202b72:	e34fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202b76:	000b3783          	ld	a5,0(s6)
ffffffffc0202b7a:	00094917          	auipc	s2,0x94
ffffffffc0202b7e:	d2690913          	addi	s2,s2,-730 # ffffffffc02968a0 <boot_pgdir_va>
ffffffffc0202b82:	7b9c                	ld	a5,48(a5)
ffffffffc0202b84:	9782                	jalr	a5
ffffffffc0202b86:	0000a517          	auipc	a0,0xa
ffffffffc0202b8a:	90a50513          	addi	a0,a0,-1782 # ffffffffc020c490 <etext+0x108e>
ffffffffc0202b8e:	e18fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202b92:	00010697          	auipc	a3,0x10
ffffffffc0202b96:	46e68693          	addi	a3,a3,1134 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc0202b9a:	00d93023          	sd	a3,0(s2)
ffffffffc0202b9e:	c02007b7          	lui	a5,0xc0200
ffffffffc0202ba2:	2af6eee3          	bltu	a3,a5,ffffffffc020365e <pmm_init+0xbf2>
ffffffffc0202ba6:	0009b783          	ld	a5,0(s3)
ffffffffc0202baa:	8e9d                	sub	a3,a3,a5
ffffffffc0202bac:	00094797          	auipc	a5,0x94
ffffffffc0202bb0:	ced7b623          	sd	a3,-788(a5) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc0202bb4:	100027f3          	csrr	a5,sstatus
ffffffffc0202bb8:	8b89                	andi	a5,a5,2
ffffffffc0202bba:	48079963          	bnez	a5,ffffffffc020304c <pmm_init+0x5e0>
ffffffffc0202bbe:	000b3783          	ld	a5,0(s6)
ffffffffc0202bc2:	779c                	ld	a5,40(a5)
ffffffffc0202bc4:	9782                	jalr	a5
ffffffffc0202bc6:	842a                	mv	s0,a0
ffffffffc0202bc8:	6098                	ld	a4,0(s1)
ffffffffc0202bca:	c80007b7          	lui	a5,0xc8000
ffffffffc0202bce:	83b1                	srli	a5,a5,0xc
ffffffffc0202bd0:	66e7e663          	bltu	a5,a4,ffffffffc020323c <pmm_init+0x7d0>
ffffffffc0202bd4:	00093503          	ld	a0,0(s2)
ffffffffc0202bd8:	64050263          	beqz	a0,ffffffffc020321c <pmm_init+0x7b0>
ffffffffc0202bdc:	03451793          	slli	a5,a0,0x34
ffffffffc0202be0:	62079e63          	bnez	a5,ffffffffc020321c <pmm_init+0x7b0>
ffffffffc0202be4:	4601                	li	a2,0
ffffffffc0202be6:	4581                	li	a1,0
ffffffffc0202be8:	8b7ff0ef          	jal	ffffffffc020249e <get_page>
ffffffffc0202bec:	240519e3          	bnez	a0,ffffffffc020363e <pmm_init+0xbd2>
ffffffffc0202bf0:	100027f3          	csrr	a5,sstatus
ffffffffc0202bf4:	8b89                	andi	a5,a5,2
ffffffffc0202bf6:	44079063          	bnez	a5,ffffffffc0203036 <pmm_init+0x5ca>
ffffffffc0202bfa:	000b3783          	ld	a5,0(s6)
ffffffffc0202bfe:	4505                	li	a0,1
ffffffffc0202c00:	6f9c                	ld	a5,24(a5)
ffffffffc0202c02:	9782                	jalr	a5
ffffffffc0202c04:	8a2a                	mv	s4,a0
ffffffffc0202c06:	00093503          	ld	a0,0(s2)
ffffffffc0202c0a:	4681                	li	a3,0
ffffffffc0202c0c:	4601                	li	a2,0
ffffffffc0202c0e:	85d2                	mv	a1,s4
ffffffffc0202c10:	d67ff0ef          	jal	ffffffffc0202976 <page_insert>
ffffffffc0202c14:	280511e3          	bnez	a0,ffffffffc0203696 <pmm_init+0xc2a>
ffffffffc0202c18:	00093503          	ld	a0,0(s2)
ffffffffc0202c1c:	4601                	li	a2,0
ffffffffc0202c1e:	4581                	li	a1,0
ffffffffc0202c20:	e20ff0ef          	jal	ffffffffc0202240 <get_pte>
ffffffffc0202c24:	240509e3          	beqz	a0,ffffffffc0203676 <pmm_init+0xc0a>
ffffffffc0202c28:	611c                	ld	a5,0(a0)
ffffffffc0202c2a:	0017f713          	andi	a4,a5,1
ffffffffc0202c2e:	58070f63          	beqz	a4,ffffffffc02031cc <pmm_init+0x760>
ffffffffc0202c32:	6098                	ld	a4,0(s1)
ffffffffc0202c34:	078a                	slli	a5,a5,0x2
ffffffffc0202c36:	83b1                	srli	a5,a5,0xc
ffffffffc0202c38:	58e7f863          	bgeu	a5,a4,ffffffffc02031c8 <pmm_init+0x75c>
ffffffffc0202c3c:	000bb683          	ld	a3,0(s7)
ffffffffc0202c40:	079a                	slli	a5,a5,0x6
ffffffffc0202c42:	fe000637          	lui	a2,0xfe000
ffffffffc0202c46:	97b2                	add	a5,a5,a2
ffffffffc0202c48:	97b6                	add	a5,a5,a3
ffffffffc0202c4a:	14fa1ae3          	bne	s4,a5,ffffffffc020359e <pmm_init+0xb32>
ffffffffc0202c4e:	000a2683          	lw	a3,0(s4) # 200000 <_binary_bin_sfs_img_size+0x18ad00>
ffffffffc0202c52:	4785                	li	a5,1
ffffffffc0202c54:	12f695e3          	bne	a3,a5,ffffffffc020357e <pmm_init+0xb12>
ffffffffc0202c58:	00093503          	ld	a0,0(s2)
ffffffffc0202c5c:	77fd                	lui	a5,0xfffff
ffffffffc0202c5e:	6114                	ld	a3,0(a0)
ffffffffc0202c60:	068a                	slli	a3,a3,0x2
ffffffffc0202c62:	8efd                	and	a3,a3,a5
ffffffffc0202c64:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202c68:	0ee67fe3          	bgeu	a2,a4,ffffffffc0203566 <pmm_init+0xafa>
ffffffffc0202c6c:	0009bc03          	ld	s8,0(s3)
ffffffffc0202c70:	96e2                	add	a3,a3,s8
ffffffffc0202c72:	0006ba83          	ld	s5,0(a3)
ffffffffc0202c76:	0a8a                	slli	s5,s5,0x2
ffffffffc0202c78:	00fafab3          	and	s5,s5,a5
ffffffffc0202c7c:	00cad793          	srli	a5,s5,0xc
ffffffffc0202c80:	0ce7f6e3          	bgeu	a5,a4,ffffffffc020354c <pmm_init+0xae0>
ffffffffc0202c84:	4601                	li	a2,0
ffffffffc0202c86:	6585                	lui	a1,0x1
ffffffffc0202c88:	9c56                	add	s8,s8,s5
ffffffffc0202c8a:	db6ff0ef          	jal	ffffffffc0202240 <get_pte>
ffffffffc0202c8e:	0c21                	addi	s8,s8,8
ffffffffc0202c90:	05851ee3          	bne	a0,s8,ffffffffc02034ec <pmm_init+0xa80>
ffffffffc0202c94:	100027f3          	csrr	a5,sstatus
ffffffffc0202c98:	8b89                	andi	a5,a5,2
ffffffffc0202c9a:	3e079b63          	bnez	a5,ffffffffc0203090 <pmm_init+0x624>
ffffffffc0202c9e:	000b3783          	ld	a5,0(s6)
ffffffffc0202ca2:	4505                	li	a0,1
ffffffffc0202ca4:	6f9c                	ld	a5,24(a5)
ffffffffc0202ca6:	9782                	jalr	a5
ffffffffc0202ca8:	8c2a                	mv	s8,a0
ffffffffc0202caa:	00093503          	ld	a0,0(s2)
ffffffffc0202cae:	46d1                	li	a3,20
ffffffffc0202cb0:	6605                	lui	a2,0x1
ffffffffc0202cb2:	85e2                	mv	a1,s8
ffffffffc0202cb4:	cc3ff0ef          	jal	ffffffffc0202976 <page_insert>
ffffffffc0202cb8:	06051ae3          	bnez	a0,ffffffffc020352c <pmm_init+0xac0>
ffffffffc0202cbc:	00093503          	ld	a0,0(s2)
ffffffffc0202cc0:	4601                	li	a2,0
ffffffffc0202cc2:	6585                	lui	a1,0x1
ffffffffc0202cc4:	d7cff0ef          	jal	ffffffffc0202240 <get_pte>
ffffffffc0202cc8:	040502e3          	beqz	a0,ffffffffc020350c <pmm_init+0xaa0>
ffffffffc0202ccc:	611c                	ld	a5,0(a0)
ffffffffc0202cce:	0107f713          	andi	a4,a5,16
ffffffffc0202cd2:	7e070163          	beqz	a4,ffffffffc02034b4 <pmm_init+0xa48>
ffffffffc0202cd6:	8b91                	andi	a5,a5,4
ffffffffc0202cd8:	7a078e63          	beqz	a5,ffffffffc0203494 <pmm_init+0xa28>
ffffffffc0202cdc:	00093503          	ld	a0,0(s2)
ffffffffc0202ce0:	611c                	ld	a5,0(a0)
ffffffffc0202ce2:	8bc1                	andi	a5,a5,16
ffffffffc0202ce4:	78078863          	beqz	a5,ffffffffc0203474 <pmm_init+0xa08>
ffffffffc0202ce8:	000c2703          	lw	a4,0(s8)
ffffffffc0202cec:	4785                	li	a5,1
ffffffffc0202cee:	76f71363          	bne	a4,a5,ffffffffc0203454 <pmm_init+0x9e8>
ffffffffc0202cf2:	4681                	li	a3,0
ffffffffc0202cf4:	6605                	lui	a2,0x1
ffffffffc0202cf6:	85d2                	mv	a1,s4
ffffffffc0202cf8:	c7fff0ef          	jal	ffffffffc0202976 <page_insert>
ffffffffc0202cfc:	72051c63          	bnez	a0,ffffffffc0203434 <pmm_init+0x9c8>
ffffffffc0202d00:	000a2703          	lw	a4,0(s4)
ffffffffc0202d04:	4789                	li	a5,2
ffffffffc0202d06:	70f71763          	bne	a4,a5,ffffffffc0203414 <pmm_init+0x9a8>
ffffffffc0202d0a:	000c2783          	lw	a5,0(s8)
ffffffffc0202d0e:	6e079363          	bnez	a5,ffffffffc02033f4 <pmm_init+0x988>
ffffffffc0202d12:	00093503          	ld	a0,0(s2)
ffffffffc0202d16:	4601                	li	a2,0
ffffffffc0202d18:	6585                	lui	a1,0x1
ffffffffc0202d1a:	d26ff0ef          	jal	ffffffffc0202240 <get_pte>
ffffffffc0202d1e:	6a050b63          	beqz	a0,ffffffffc02033d4 <pmm_init+0x968>
ffffffffc0202d22:	6118                	ld	a4,0(a0)
ffffffffc0202d24:	00177793          	andi	a5,a4,1
ffffffffc0202d28:	4a078263          	beqz	a5,ffffffffc02031cc <pmm_init+0x760>
ffffffffc0202d2c:	6094                	ld	a3,0(s1)
ffffffffc0202d2e:	00271793          	slli	a5,a4,0x2
ffffffffc0202d32:	83b1                	srli	a5,a5,0xc
ffffffffc0202d34:	48d7fa63          	bgeu	a5,a3,ffffffffc02031c8 <pmm_init+0x75c>
ffffffffc0202d38:	000bb683          	ld	a3,0(s7)
ffffffffc0202d3c:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202d40:	97d6                	add	a5,a5,s5
ffffffffc0202d42:	079a                	slli	a5,a5,0x6
ffffffffc0202d44:	97b6                	add	a5,a5,a3
ffffffffc0202d46:	66fa1763          	bne	s4,a5,ffffffffc02033b4 <pmm_init+0x948>
ffffffffc0202d4a:	8b41                	andi	a4,a4,16
ffffffffc0202d4c:	64071463          	bnez	a4,ffffffffc0203394 <pmm_init+0x928>
ffffffffc0202d50:	00093503          	ld	a0,0(s2)
ffffffffc0202d54:	4581                	li	a1,0
ffffffffc0202d56:	b85ff0ef          	jal	ffffffffc02028da <page_remove>
ffffffffc0202d5a:	000a2c83          	lw	s9,0(s4)
ffffffffc0202d5e:	4785                	li	a5,1
ffffffffc0202d60:	60fc9a63          	bne	s9,a5,ffffffffc0203374 <pmm_init+0x908>
ffffffffc0202d64:	000c2783          	lw	a5,0(s8)
ffffffffc0202d68:	5e079663          	bnez	a5,ffffffffc0203354 <pmm_init+0x8e8>
ffffffffc0202d6c:	00093503          	ld	a0,0(s2)
ffffffffc0202d70:	6585                	lui	a1,0x1
ffffffffc0202d72:	b69ff0ef          	jal	ffffffffc02028da <page_remove>
ffffffffc0202d76:	000a2783          	lw	a5,0(s4)
ffffffffc0202d7a:	52079d63          	bnez	a5,ffffffffc02032b4 <pmm_init+0x848>
ffffffffc0202d7e:	000c2783          	lw	a5,0(s8)
ffffffffc0202d82:	50079963          	bnez	a5,ffffffffc0203294 <pmm_init+0x828>
ffffffffc0202d86:	00093a03          	ld	s4,0(s2)
ffffffffc0202d8a:	6098                	ld	a4,0(s1)
ffffffffc0202d8c:	000a3783          	ld	a5,0(s4)
ffffffffc0202d90:	078a                	slli	a5,a5,0x2
ffffffffc0202d92:	83b1                	srli	a5,a5,0xc
ffffffffc0202d94:	42e7fa63          	bgeu	a5,a4,ffffffffc02031c8 <pmm_init+0x75c>
ffffffffc0202d98:	000bb503          	ld	a0,0(s7)
ffffffffc0202d9c:	97d6                	add	a5,a5,s5
ffffffffc0202d9e:	079a                	slli	a5,a5,0x6
ffffffffc0202da0:	00f506b3          	add	a3,a0,a5
ffffffffc0202da4:	4294                	lw	a3,0(a3)
ffffffffc0202da6:	4d969763          	bne	a3,s9,ffffffffc0203274 <pmm_init+0x808>
ffffffffc0202daa:	8799                	srai	a5,a5,0x6
ffffffffc0202dac:	00080637          	lui	a2,0x80
ffffffffc0202db0:	97b2                	add	a5,a5,a2
ffffffffc0202db2:	00c79693          	slli	a3,a5,0xc
ffffffffc0202db6:	4ae7f363          	bgeu	a5,a4,ffffffffc020325c <pmm_init+0x7f0>
ffffffffc0202dba:	0009b783          	ld	a5,0(s3)
ffffffffc0202dbe:	97b6                	add	a5,a5,a3
ffffffffc0202dc0:	639c                	ld	a5,0(a5)
ffffffffc0202dc2:	078a                	slli	a5,a5,0x2
ffffffffc0202dc4:	83b1                	srli	a5,a5,0xc
ffffffffc0202dc6:	40e7f163          	bgeu	a5,a4,ffffffffc02031c8 <pmm_init+0x75c>
ffffffffc0202dca:	8f91                	sub	a5,a5,a2
ffffffffc0202dcc:	079a                	slli	a5,a5,0x6
ffffffffc0202dce:	953e                	add	a0,a0,a5
ffffffffc0202dd0:	100027f3          	csrr	a5,sstatus
ffffffffc0202dd4:	8b89                	andi	a5,a5,2
ffffffffc0202dd6:	30079863          	bnez	a5,ffffffffc02030e6 <pmm_init+0x67a>
ffffffffc0202dda:	000b3783          	ld	a5,0(s6)
ffffffffc0202dde:	4585                	li	a1,1
ffffffffc0202de0:	739c                	ld	a5,32(a5)
ffffffffc0202de2:	9782                	jalr	a5
ffffffffc0202de4:	000a3783          	ld	a5,0(s4)
ffffffffc0202de8:	6098                	ld	a4,0(s1)
ffffffffc0202dea:	078a                	slli	a5,a5,0x2
ffffffffc0202dec:	83b1                	srli	a5,a5,0xc
ffffffffc0202dee:	3ce7fd63          	bgeu	a5,a4,ffffffffc02031c8 <pmm_init+0x75c>
ffffffffc0202df2:	000bb503          	ld	a0,0(s7)
ffffffffc0202df6:	fe000737          	lui	a4,0xfe000
ffffffffc0202dfa:	079a                	slli	a5,a5,0x6
ffffffffc0202dfc:	97ba                	add	a5,a5,a4
ffffffffc0202dfe:	953e                	add	a0,a0,a5
ffffffffc0202e00:	100027f3          	csrr	a5,sstatus
ffffffffc0202e04:	8b89                	andi	a5,a5,2
ffffffffc0202e06:	2c079463          	bnez	a5,ffffffffc02030ce <pmm_init+0x662>
ffffffffc0202e0a:	000b3783          	ld	a5,0(s6)
ffffffffc0202e0e:	4585                	li	a1,1
ffffffffc0202e10:	739c                	ld	a5,32(a5)
ffffffffc0202e12:	9782                	jalr	a5
ffffffffc0202e14:	00093783          	ld	a5,0(s2)
ffffffffc0202e18:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0202e1c:	12000073          	sfence.vma
ffffffffc0202e20:	100027f3          	csrr	a5,sstatus
ffffffffc0202e24:	8b89                	andi	a5,a5,2
ffffffffc0202e26:	28079a63          	bnez	a5,ffffffffc02030ba <pmm_init+0x64e>
ffffffffc0202e2a:	000b3783          	ld	a5,0(s6)
ffffffffc0202e2e:	779c                	ld	a5,40(a5)
ffffffffc0202e30:	9782                	jalr	a5
ffffffffc0202e32:	8a2a                	mv	s4,a0
ffffffffc0202e34:	4d441063          	bne	s0,s4,ffffffffc02032f4 <pmm_init+0x888>
ffffffffc0202e38:	0000a517          	auipc	a0,0xa
ffffffffc0202e3c:	9a850513          	addi	a0,a0,-1624 # ffffffffc020c7e0 <etext+0x13de>
ffffffffc0202e40:	b66fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202e44:	100027f3          	csrr	a5,sstatus
ffffffffc0202e48:	8b89                	andi	a5,a5,2
ffffffffc0202e4a:	24079e63          	bnez	a5,ffffffffc02030a6 <pmm_init+0x63a>
ffffffffc0202e4e:	000b3783          	ld	a5,0(s6)
ffffffffc0202e52:	779c                	ld	a5,40(a5)
ffffffffc0202e54:	9782                	jalr	a5
ffffffffc0202e56:	8c2a                	mv	s8,a0
ffffffffc0202e58:	609c                	ld	a5,0(s1)
ffffffffc0202e5a:	c0200437          	lui	s0,0xc0200
ffffffffc0202e5e:	7a7d                	lui	s4,0xfffff
ffffffffc0202e60:	00c79713          	slli	a4,a5,0xc
ffffffffc0202e64:	6a85                	lui	s5,0x1
ffffffffc0202e66:	02e47c63          	bgeu	s0,a4,ffffffffc0202e9e <pmm_init+0x432>
ffffffffc0202e6a:	00c45713          	srli	a4,s0,0xc
ffffffffc0202e6e:	30f77063          	bgeu	a4,a5,ffffffffc020316e <pmm_init+0x702>
ffffffffc0202e72:	0009b583          	ld	a1,0(s3)
ffffffffc0202e76:	00093503          	ld	a0,0(s2)
ffffffffc0202e7a:	4601                	li	a2,0
ffffffffc0202e7c:	95a2                	add	a1,a1,s0
ffffffffc0202e7e:	bc2ff0ef          	jal	ffffffffc0202240 <get_pte>
ffffffffc0202e82:	32050363          	beqz	a0,ffffffffc02031a8 <pmm_init+0x73c>
ffffffffc0202e86:	611c                	ld	a5,0(a0)
ffffffffc0202e88:	078a                	slli	a5,a5,0x2
ffffffffc0202e8a:	0147f7b3          	and	a5,a5,s4
ffffffffc0202e8e:	2e879d63          	bne	a5,s0,ffffffffc0203188 <pmm_init+0x71c>
ffffffffc0202e92:	609c                	ld	a5,0(s1)
ffffffffc0202e94:	9456                	add	s0,s0,s5
ffffffffc0202e96:	00c79713          	slli	a4,a5,0xc
ffffffffc0202e9a:	fce468e3          	bltu	s0,a4,ffffffffc0202e6a <pmm_init+0x3fe>
ffffffffc0202e9e:	00093783          	ld	a5,0(s2)
ffffffffc0202ea2:	639c                	ld	a5,0(a5)
ffffffffc0202ea4:	42079863          	bnez	a5,ffffffffc02032d4 <pmm_init+0x868>
ffffffffc0202ea8:	100027f3          	csrr	a5,sstatus
ffffffffc0202eac:	8b89                	andi	a5,a5,2
ffffffffc0202eae:	24079863          	bnez	a5,ffffffffc02030fe <pmm_init+0x692>
ffffffffc0202eb2:	000b3783          	ld	a5,0(s6)
ffffffffc0202eb6:	4505                	li	a0,1
ffffffffc0202eb8:	6f9c                	ld	a5,24(a5)
ffffffffc0202eba:	9782                	jalr	a5
ffffffffc0202ebc:	842a                	mv	s0,a0
ffffffffc0202ebe:	00093503          	ld	a0,0(s2)
ffffffffc0202ec2:	4699                	li	a3,6
ffffffffc0202ec4:	10000613          	li	a2,256
ffffffffc0202ec8:	85a2                	mv	a1,s0
ffffffffc0202eca:	aadff0ef          	jal	ffffffffc0202976 <page_insert>
ffffffffc0202ece:	46051363          	bnez	a0,ffffffffc0203334 <pmm_init+0x8c8>
ffffffffc0202ed2:	4018                	lw	a4,0(s0)
ffffffffc0202ed4:	4785                	li	a5,1
ffffffffc0202ed6:	42f71f63          	bne	a4,a5,ffffffffc0203314 <pmm_init+0x8a8>
ffffffffc0202eda:	00093503          	ld	a0,0(s2)
ffffffffc0202ede:	6605                	lui	a2,0x1
ffffffffc0202ee0:	10060613          	addi	a2,a2,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc0202ee4:	4699                	li	a3,6
ffffffffc0202ee6:	85a2                	mv	a1,s0
ffffffffc0202ee8:	a8fff0ef          	jal	ffffffffc0202976 <page_insert>
ffffffffc0202eec:	72051963          	bnez	a0,ffffffffc020361e <pmm_init+0xbb2>
ffffffffc0202ef0:	4018                	lw	a4,0(s0)
ffffffffc0202ef2:	4789                	li	a5,2
ffffffffc0202ef4:	70f71563          	bne	a4,a5,ffffffffc02035fe <pmm_init+0xb92>
ffffffffc0202ef8:	0000a597          	auipc	a1,0xa
ffffffffc0202efc:	a3058593          	addi	a1,a1,-1488 # ffffffffc020c928 <etext+0x1526>
ffffffffc0202f00:	10000513          	li	a0,256
ffffffffc0202f04:	416080ef          	jal	ffffffffc020b31a <strcpy>
ffffffffc0202f08:	6585                	lui	a1,0x1
ffffffffc0202f0a:	10058593          	addi	a1,a1,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc0202f0e:	10000513          	li	a0,256
ffffffffc0202f12:	41a080ef          	jal	ffffffffc020b32c <strcmp>
ffffffffc0202f16:	6c051463          	bnez	a0,ffffffffc02035de <pmm_init+0xb72>
ffffffffc0202f1a:	000bb683          	ld	a3,0(s7)
ffffffffc0202f1e:	000807b7          	lui	a5,0x80
ffffffffc0202f22:	6098                	ld	a4,0(s1)
ffffffffc0202f24:	40d406b3          	sub	a3,s0,a3
ffffffffc0202f28:	8699                	srai	a3,a3,0x6
ffffffffc0202f2a:	96be                	add	a3,a3,a5
ffffffffc0202f2c:	00c69793          	slli	a5,a3,0xc
ffffffffc0202f30:	83b1                	srli	a5,a5,0xc
ffffffffc0202f32:	06b2                	slli	a3,a3,0xc
ffffffffc0202f34:	32e7f463          	bgeu	a5,a4,ffffffffc020325c <pmm_init+0x7f0>
ffffffffc0202f38:	0009b783          	ld	a5,0(s3)
ffffffffc0202f3c:	10000513          	li	a0,256
ffffffffc0202f40:	97b6                	add	a5,a5,a3
ffffffffc0202f42:	10078023          	sb	zero,256(a5) # 80100 <_binary_bin_sfs_img_size+0xae00>
ffffffffc0202f46:	3a0080ef          	jal	ffffffffc020b2e6 <strlen>
ffffffffc0202f4a:	66051a63          	bnez	a0,ffffffffc02035be <pmm_init+0xb52>
ffffffffc0202f4e:	00093a03          	ld	s4,0(s2)
ffffffffc0202f52:	6098                	ld	a4,0(s1)
ffffffffc0202f54:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0202f58:	078a                	slli	a5,a5,0x2
ffffffffc0202f5a:	83b1                	srli	a5,a5,0xc
ffffffffc0202f5c:	26e7f663          	bgeu	a5,a4,ffffffffc02031c8 <pmm_init+0x75c>
ffffffffc0202f60:	00c79693          	slli	a3,a5,0xc
ffffffffc0202f64:	2ee7fc63          	bgeu	a5,a4,ffffffffc020325c <pmm_init+0x7f0>
ffffffffc0202f68:	0009b783          	ld	a5,0(s3)
ffffffffc0202f6c:	00f689b3          	add	s3,a3,a5
ffffffffc0202f70:	100027f3          	csrr	a5,sstatus
ffffffffc0202f74:	8b89                	andi	a5,a5,2
ffffffffc0202f76:	1e079163          	bnez	a5,ffffffffc0203158 <pmm_init+0x6ec>
ffffffffc0202f7a:	000b3783          	ld	a5,0(s6)
ffffffffc0202f7e:	8522                	mv	a0,s0
ffffffffc0202f80:	4585                	li	a1,1
ffffffffc0202f82:	739c                	ld	a5,32(a5)
ffffffffc0202f84:	9782                	jalr	a5
ffffffffc0202f86:	0009b783          	ld	a5,0(s3)
ffffffffc0202f8a:	6098                	ld	a4,0(s1)
ffffffffc0202f8c:	078a                	slli	a5,a5,0x2
ffffffffc0202f8e:	83b1                	srli	a5,a5,0xc
ffffffffc0202f90:	22e7fc63          	bgeu	a5,a4,ffffffffc02031c8 <pmm_init+0x75c>
ffffffffc0202f94:	000bb503          	ld	a0,0(s7)
ffffffffc0202f98:	fe000737          	lui	a4,0xfe000
ffffffffc0202f9c:	079a                	slli	a5,a5,0x6
ffffffffc0202f9e:	97ba                	add	a5,a5,a4
ffffffffc0202fa0:	953e                	add	a0,a0,a5
ffffffffc0202fa2:	100027f3          	csrr	a5,sstatus
ffffffffc0202fa6:	8b89                	andi	a5,a5,2
ffffffffc0202fa8:	18079c63          	bnez	a5,ffffffffc0203140 <pmm_init+0x6d4>
ffffffffc0202fac:	000b3783          	ld	a5,0(s6)
ffffffffc0202fb0:	4585                	li	a1,1
ffffffffc0202fb2:	739c                	ld	a5,32(a5)
ffffffffc0202fb4:	9782                	jalr	a5
ffffffffc0202fb6:	000a3783          	ld	a5,0(s4)
ffffffffc0202fba:	6098                	ld	a4,0(s1)
ffffffffc0202fbc:	078a                	slli	a5,a5,0x2
ffffffffc0202fbe:	83b1                	srli	a5,a5,0xc
ffffffffc0202fc0:	20e7f463          	bgeu	a5,a4,ffffffffc02031c8 <pmm_init+0x75c>
ffffffffc0202fc4:	000bb503          	ld	a0,0(s7)
ffffffffc0202fc8:	fe000737          	lui	a4,0xfe000
ffffffffc0202fcc:	079a                	slli	a5,a5,0x6
ffffffffc0202fce:	97ba                	add	a5,a5,a4
ffffffffc0202fd0:	953e                	add	a0,a0,a5
ffffffffc0202fd2:	100027f3          	csrr	a5,sstatus
ffffffffc0202fd6:	8b89                	andi	a5,a5,2
ffffffffc0202fd8:	14079863          	bnez	a5,ffffffffc0203128 <pmm_init+0x6bc>
ffffffffc0202fdc:	000b3783          	ld	a5,0(s6)
ffffffffc0202fe0:	4585                	li	a1,1
ffffffffc0202fe2:	739c                	ld	a5,32(a5)
ffffffffc0202fe4:	9782                	jalr	a5
ffffffffc0202fe6:	00093783          	ld	a5,0(s2)
ffffffffc0202fea:	0007b023          	sd	zero,0(a5)
ffffffffc0202fee:	12000073          	sfence.vma
ffffffffc0202ff2:	100027f3          	csrr	a5,sstatus
ffffffffc0202ff6:	8b89                	andi	a5,a5,2
ffffffffc0202ff8:	10079e63          	bnez	a5,ffffffffc0203114 <pmm_init+0x6a8>
ffffffffc0202ffc:	000b3783          	ld	a5,0(s6)
ffffffffc0203000:	779c                	ld	a5,40(a5)
ffffffffc0203002:	9782                	jalr	a5
ffffffffc0203004:	842a                	mv	s0,a0
ffffffffc0203006:	1e8c1b63          	bne	s8,s0,ffffffffc02031fc <pmm_init+0x790>
ffffffffc020300a:	0000a517          	auipc	a0,0xa
ffffffffc020300e:	99650513          	addi	a0,a0,-1642 # ffffffffc020c9a0 <etext+0x159e>
ffffffffc0203012:	994fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0203016:	7406                	ld	s0,96(sp)
ffffffffc0203018:	70a6                	ld	ra,104(sp)
ffffffffc020301a:	64e6                	ld	s1,88(sp)
ffffffffc020301c:	6946                	ld	s2,80(sp)
ffffffffc020301e:	69a6                	ld	s3,72(sp)
ffffffffc0203020:	6a06                	ld	s4,64(sp)
ffffffffc0203022:	7ae2                	ld	s5,56(sp)
ffffffffc0203024:	7b42                	ld	s6,48(sp)
ffffffffc0203026:	7ba2                	ld	s7,40(sp)
ffffffffc0203028:	7c02                	ld	s8,32(sp)
ffffffffc020302a:	6ce2                	ld	s9,24(sp)
ffffffffc020302c:	6165                	addi	sp,sp,112
ffffffffc020302e:	f83fe06f          	j	ffffffffc0201fb0 <kmalloc_init>
ffffffffc0203032:	853e                	mv	a0,a5
ffffffffc0203034:	b4e1                	j	ffffffffc0202afc <pmm_init+0x90>
ffffffffc0203036:	bc7fd0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc020303a:	000b3783          	ld	a5,0(s6)
ffffffffc020303e:	4505                	li	a0,1
ffffffffc0203040:	6f9c                	ld	a5,24(a5)
ffffffffc0203042:	9782                	jalr	a5
ffffffffc0203044:	8a2a                	mv	s4,a0
ffffffffc0203046:	bb1fd0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc020304a:	be75                	j	ffffffffc0202c06 <pmm_init+0x19a>
ffffffffc020304c:	bb1fd0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0203050:	000b3783          	ld	a5,0(s6)
ffffffffc0203054:	779c                	ld	a5,40(a5)
ffffffffc0203056:	9782                	jalr	a5
ffffffffc0203058:	842a                	mv	s0,a0
ffffffffc020305a:	b9dfd0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc020305e:	b6ad                	j	ffffffffc0202bc8 <pmm_init+0x15c>
ffffffffc0203060:	6705                	lui	a4,0x1
ffffffffc0203062:	177d                	addi	a4,a4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0203064:	96ba                	add	a3,a3,a4
ffffffffc0203066:	8ff5                	and	a5,a5,a3
ffffffffc0203068:	00c7d713          	srli	a4,a5,0xc
ffffffffc020306c:	14a77e63          	bgeu	a4,a0,ffffffffc02031c8 <pmm_init+0x75c>
ffffffffc0203070:	000b3683          	ld	a3,0(s6)
ffffffffc0203074:	8c1d                	sub	s0,s0,a5
ffffffffc0203076:	071a                	slli	a4,a4,0x6
ffffffffc0203078:	fe0007b7          	lui	a5,0xfe000
ffffffffc020307c:	973e                	add	a4,a4,a5
ffffffffc020307e:	6a9c                	ld	a5,16(a3)
ffffffffc0203080:	00c45593          	srli	a1,s0,0xc
ffffffffc0203084:	00e60533          	add	a0,a2,a4
ffffffffc0203088:	9782                	jalr	a5
ffffffffc020308a:	0009b583          	ld	a1,0(s3)
ffffffffc020308e:	bcf1                	j	ffffffffc0202b6a <pmm_init+0xfe>
ffffffffc0203090:	b6dfd0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0203094:	000b3783          	ld	a5,0(s6)
ffffffffc0203098:	4505                	li	a0,1
ffffffffc020309a:	6f9c                	ld	a5,24(a5)
ffffffffc020309c:	9782                	jalr	a5
ffffffffc020309e:	8c2a                	mv	s8,a0
ffffffffc02030a0:	b57fd0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc02030a4:	b119                	j	ffffffffc0202caa <pmm_init+0x23e>
ffffffffc02030a6:	b57fd0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc02030aa:	000b3783          	ld	a5,0(s6)
ffffffffc02030ae:	779c                	ld	a5,40(a5)
ffffffffc02030b0:	9782                	jalr	a5
ffffffffc02030b2:	8c2a                	mv	s8,a0
ffffffffc02030b4:	b43fd0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc02030b8:	b345                	j	ffffffffc0202e58 <pmm_init+0x3ec>
ffffffffc02030ba:	b43fd0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc02030be:	000b3783          	ld	a5,0(s6)
ffffffffc02030c2:	779c                	ld	a5,40(a5)
ffffffffc02030c4:	9782                	jalr	a5
ffffffffc02030c6:	8a2a                	mv	s4,a0
ffffffffc02030c8:	b2ffd0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc02030cc:	b3a5                	j	ffffffffc0202e34 <pmm_init+0x3c8>
ffffffffc02030ce:	e42a                	sd	a0,8(sp)
ffffffffc02030d0:	b2dfd0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc02030d4:	000b3783          	ld	a5,0(s6)
ffffffffc02030d8:	6522                	ld	a0,8(sp)
ffffffffc02030da:	4585                	li	a1,1
ffffffffc02030dc:	739c                	ld	a5,32(a5)
ffffffffc02030de:	9782                	jalr	a5
ffffffffc02030e0:	b17fd0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc02030e4:	bb05                	j	ffffffffc0202e14 <pmm_init+0x3a8>
ffffffffc02030e6:	e42a                	sd	a0,8(sp)
ffffffffc02030e8:	b15fd0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc02030ec:	000b3783          	ld	a5,0(s6)
ffffffffc02030f0:	6522                	ld	a0,8(sp)
ffffffffc02030f2:	4585                	li	a1,1
ffffffffc02030f4:	739c                	ld	a5,32(a5)
ffffffffc02030f6:	9782                	jalr	a5
ffffffffc02030f8:	afffd0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc02030fc:	b1e5                	j	ffffffffc0202de4 <pmm_init+0x378>
ffffffffc02030fe:	afffd0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0203102:	000b3783          	ld	a5,0(s6)
ffffffffc0203106:	4505                	li	a0,1
ffffffffc0203108:	6f9c                	ld	a5,24(a5)
ffffffffc020310a:	9782                	jalr	a5
ffffffffc020310c:	842a                	mv	s0,a0
ffffffffc020310e:	ae9fd0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc0203112:	b375                	j	ffffffffc0202ebe <pmm_init+0x452>
ffffffffc0203114:	ae9fd0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0203118:	000b3783          	ld	a5,0(s6)
ffffffffc020311c:	779c                	ld	a5,40(a5)
ffffffffc020311e:	9782                	jalr	a5
ffffffffc0203120:	842a                	mv	s0,a0
ffffffffc0203122:	ad5fd0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc0203126:	b5c5                	j	ffffffffc0203006 <pmm_init+0x59a>
ffffffffc0203128:	e42a                	sd	a0,8(sp)
ffffffffc020312a:	ad3fd0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc020312e:	000b3783          	ld	a5,0(s6)
ffffffffc0203132:	6522                	ld	a0,8(sp)
ffffffffc0203134:	4585                	li	a1,1
ffffffffc0203136:	739c                	ld	a5,32(a5)
ffffffffc0203138:	9782                	jalr	a5
ffffffffc020313a:	abdfd0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc020313e:	b565                	j	ffffffffc0202fe6 <pmm_init+0x57a>
ffffffffc0203140:	e42a                	sd	a0,8(sp)
ffffffffc0203142:	abbfd0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0203146:	000b3783          	ld	a5,0(s6)
ffffffffc020314a:	6522                	ld	a0,8(sp)
ffffffffc020314c:	4585                	li	a1,1
ffffffffc020314e:	739c                	ld	a5,32(a5)
ffffffffc0203150:	9782                	jalr	a5
ffffffffc0203152:	aa5fd0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc0203156:	b585                	j	ffffffffc0202fb6 <pmm_init+0x54a>
ffffffffc0203158:	aa5fd0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc020315c:	000b3783          	ld	a5,0(s6)
ffffffffc0203160:	8522                	mv	a0,s0
ffffffffc0203162:	4585                	li	a1,1
ffffffffc0203164:	739c                	ld	a5,32(a5)
ffffffffc0203166:	9782                	jalr	a5
ffffffffc0203168:	a8ffd0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc020316c:	bd29                	j	ffffffffc0202f86 <pmm_init+0x51a>
ffffffffc020316e:	86a2                	mv	a3,s0
ffffffffc0203170:	00009617          	auipc	a2,0x9
ffffffffc0203174:	14860613          	addi	a2,a2,328 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc0203178:	25100593          	li	a1,593
ffffffffc020317c:	00009517          	auipc	a0,0x9
ffffffffc0203180:	22c50513          	addi	a0,a0,556 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203184:	ac6fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203188:	00009697          	auipc	a3,0x9
ffffffffc020318c:	6b868693          	addi	a3,a3,1720 # ffffffffc020c840 <etext+0x143e>
ffffffffc0203190:	00008617          	auipc	a2,0x8
ffffffffc0203194:	6b060613          	addi	a2,a2,1712 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203198:	25200593          	li	a1,594
ffffffffc020319c:	00009517          	auipc	a0,0x9
ffffffffc02031a0:	20c50513          	addi	a0,a0,524 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02031a4:	aa6fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02031a8:	00009697          	auipc	a3,0x9
ffffffffc02031ac:	65868693          	addi	a3,a3,1624 # ffffffffc020c800 <etext+0x13fe>
ffffffffc02031b0:	00008617          	auipc	a2,0x8
ffffffffc02031b4:	69060613          	addi	a2,a2,1680 # ffffffffc020b840 <etext+0x43e>
ffffffffc02031b8:	25100593          	li	a1,593
ffffffffc02031bc:	00009517          	auipc	a0,0x9
ffffffffc02031c0:	1ec50513          	addi	a0,a0,492 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02031c4:	a86fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02031c8:	fb5fe0ef          	jal	ffffffffc020217c <pa2page.part.0>
ffffffffc02031cc:	00009617          	auipc	a2,0x9
ffffffffc02031d0:	3d460613          	addi	a2,a2,980 # ffffffffc020c5a0 <etext+0x119e>
ffffffffc02031d4:	07f00593          	li	a1,127
ffffffffc02031d8:	00009517          	auipc	a0,0x9
ffffffffc02031dc:	10850513          	addi	a0,a0,264 # ffffffffc020c2e0 <etext+0xede>
ffffffffc02031e0:	a6afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02031e4:	00009617          	auipc	a2,0x9
ffffffffc02031e8:	23460613          	addi	a2,a2,564 # ffffffffc020c418 <etext+0x1016>
ffffffffc02031ec:	06400593          	li	a1,100
ffffffffc02031f0:	00009517          	auipc	a0,0x9
ffffffffc02031f4:	1b850513          	addi	a0,a0,440 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02031f8:	a52fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02031fc:	00009697          	auipc	a3,0x9
ffffffffc0203200:	5bc68693          	addi	a3,a3,1468 # ffffffffc020c7b8 <etext+0x13b6>
ffffffffc0203204:	00008617          	auipc	a2,0x8
ffffffffc0203208:	63c60613          	addi	a2,a2,1596 # ffffffffc020b840 <etext+0x43e>
ffffffffc020320c:	26c00593          	li	a1,620
ffffffffc0203210:	00009517          	auipc	a0,0x9
ffffffffc0203214:	19850513          	addi	a0,a0,408 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203218:	a32fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020321c:	00009697          	auipc	a3,0x9
ffffffffc0203220:	2b468693          	addi	a3,a3,692 # ffffffffc020c4d0 <etext+0x10ce>
ffffffffc0203224:	00008617          	auipc	a2,0x8
ffffffffc0203228:	61c60613          	addi	a2,a2,1564 # ffffffffc020b840 <etext+0x43e>
ffffffffc020322c:	21300593          	li	a1,531
ffffffffc0203230:	00009517          	auipc	a0,0x9
ffffffffc0203234:	17850513          	addi	a0,a0,376 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203238:	a12fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020323c:	00009697          	auipc	a3,0x9
ffffffffc0203240:	27468693          	addi	a3,a3,628 # ffffffffc020c4b0 <etext+0x10ae>
ffffffffc0203244:	00008617          	auipc	a2,0x8
ffffffffc0203248:	5fc60613          	addi	a2,a2,1532 # ffffffffc020b840 <etext+0x43e>
ffffffffc020324c:	21200593          	li	a1,530
ffffffffc0203250:	00009517          	auipc	a0,0x9
ffffffffc0203254:	15850513          	addi	a0,a0,344 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203258:	9f2fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020325c:	00009617          	auipc	a2,0x9
ffffffffc0203260:	05c60613          	addi	a2,a2,92 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc0203264:	07100593          	li	a1,113
ffffffffc0203268:	00009517          	auipc	a0,0x9
ffffffffc020326c:	07850513          	addi	a0,a0,120 # ffffffffc020c2e0 <etext+0xede>
ffffffffc0203270:	9dafd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203274:	00009697          	auipc	a3,0x9
ffffffffc0203278:	51468693          	addi	a3,a3,1300 # ffffffffc020c788 <etext+0x1386>
ffffffffc020327c:	00008617          	auipc	a2,0x8
ffffffffc0203280:	5c460613          	addi	a2,a2,1476 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203284:	23a00593          	li	a1,570
ffffffffc0203288:	00009517          	auipc	a0,0x9
ffffffffc020328c:	12050513          	addi	a0,a0,288 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203290:	9bafd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203294:	00009697          	auipc	a3,0x9
ffffffffc0203298:	4ac68693          	addi	a3,a3,1196 # ffffffffc020c740 <etext+0x133e>
ffffffffc020329c:	00008617          	auipc	a2,0x8
ffffffffc02032a0:	5a460613          	addi	a2,a2,1444 # ffffffffc020b840 <etext+0x43e>
ffffffffc02032a4:	23800593          	li	a1,568
ffffffffc02032a8:	00009517          	auipc	a0,0x9
ffffffffc02032ac:	10050513          	addi	a0,a0,256 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02032b0:	99afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02032b4:	00009697          	auipc	a3,0x9
ffffffffc02032b8:	4bc68693          	addi	a3,a3,1212 # ffffffffc020c770 <etext+0x136e>
ffffffffc02032bc:	00008617          	auipc	a2,0x8
ffffffffc02032c0:	58460613          	addi	a2,a2,1412 # ffffffffc020b840 <etext+0x43e>
ffffffffc02032c4:	23700593          	li	a1,567
ffffffffc02032c8:	00009517          	auipc	a0,0x9
ffffffffc02032cc:	0e050513          	addi	a0,a0,224 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02032d0:	97afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02032d4:	00009697          	auipc	a3,0x9
ffffffffc02032d8:	58468693          	addi	a3,a3,1412 # ffffffffc020c858 <etext+0x1456>
ffffffffc02032dc:	00008617          	auipc	a2,0x8
ffffffffc02032e0:	56460613          	addi	a2,a2,1380 # ffffffffc020b840 <etext+0x43e>
ffffffffc02032e4:	25500593          	li	a1,597
ffffffffc02032e8:	00009517          	auipc	a0,0x9
ffffffffc02032ec:	0c050513          	addi	a0,a0,192 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02032f0:	95afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02032f4:	00009697          	auipc	a3,0x9
ffffffffc02032f8:	4c468693          	addi	a3,a3,1220 # ffffffffc020c7b8 <etext+0x13b6>
ffffffffc02032fc:	00008617          	auipc	a2,0x8
ffffffffc0203300:	54460613          	addi	a2,a2,1348 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203304:	24200593          	li	a1,578
ffffffffc0203308:	00009517          	auipc	a0,0x9
ffffffffc020330c:	0a050513          	addi	a0,a0,160 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203310:	93afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203314:	00009697          	auipc	a3,0x9
ffffffffc0203318:	59c68693          	addi	a3,a3,1436 # ffffffffc020c8b0 <etext+0x14ae>
ffffffffc020331c:	00008617          	auipc	a2,0x8
ffffffffc0203320:	52460613          	addi	a2,a2,1316 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203324:	25a00593          	li	a1,602
ffffffffc0203328:	00009517          	auipc	a0,0x9
ffffffffc020332c:	08050513          	addi	a0,a0,128 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203330:	91afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203334:	00009697          	auipc	a3,0x9
ffffffffc0203338:	53c68693          	addi	a3,a3,1340 # ffffffffc020c870 <etext+0x146e>
ffffffffc020333c:	00008617          	auipc	a2,0x8
ffffffffc0203340:	50460613          	addi	a2,a2,1284 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203344:	25900593          	li	a1,601
ffffffffc0203348:	00009517          	auipc	a0,0x9
ffffffffc020334c:	06050513          	addi	a0,a0,96 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203350:	8fafd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203354:	00009697          	auipc	a3,0x9
ffffffffc0203358:	3ec68693          	addi	a3,a3,1004 # ffffffffc020c740 <etext+0x133e>
ffffffffc020335c:	00008617          	auipc	a2,0x8
ffffffffc0203360:	4e460613          	addi	a2,a2,1252 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203364:	23400593          	li	a1,564
ffffffffc0203368:	00009517          	auipc	a0,0x9
ffffffffc020336c:	04050513          	addi	a0,a0,64 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203370:	8dafd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203374:	00009697          	auipc	a3,0x9
ffffffffc0203378:	26c68693          	addi	a3,a3,620 # ffffffffc020c5e0 <etext+0x11de>
ffffffffc020337c:	00008617          	auipc	a2,0x8
ffffffffc0203380:	4c460613          	addi	a2,a2,1220 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203384:	23300593          	li	a1,563
ffffffffc0203388:	00009517          	auipc	a0,0x9
ffffffffc020338c:	02050513          	addi	a0,a0,32 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203390:	8bafd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203394:	00009697          	auipc	a3,0x9
ffffffffc0203398:	3c468693          	addi	a3,a3,964 # ffffffffc020c758 <etext+0x1356>
ffffffffc020339c:	00008617          	auipc	a2,0x8
ffffffffc02033a0:	4a460613          	addi	a2,a2,1188 # ffffffffc020b840 <etext+0x43e>
ffffffffc02033a4:	23000593          	li	a1,560
ffffffffc02033a8:	00009517          	auipc	a0,0x9
ffffffffc02033ac:	00050513          	mv	a0,a0
ffffffffc02033b0:	89afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02033b4:	00009697          	auipc	a3,0x9
ffffffffc02033b8:	21468693          	addi	a3,a3,532 # ffffffffc020c5c8 <etext+0x11c6>
ffffffffc02033bc:	00008617          	auipc	a2,0x8
ffffffffc02033c0:	48460613          	addi	a2,a2,1156 # ffffffffc020b840 <etext+0x43e>
ffffffffc02033c4:	22f00593          	li	a1,559
ffffffffc02033c8:	00009517          	auipc	a0,0x9
ffffffffc02033cc:	fe050513          	addi	a0,a0,-32 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02033d0:	87afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02033d4:	00009697          	auipc	a3,0x9
ffffffffc02033d8:	29468693          	addi	a3,a3,660 # ffffffffc020c668 <etext+0x1266>
ffffffffc02033dc:	00008617          	auipc	a2,0x8
ffffffffc02033e0:	46460613          	addi	a2,a2,1124 # ffffffffc020b840 <etext+0x43e>
ffffffffc02033e4:	22e00593          	li	a1,558
ffffffffc02033e8:	00009517          	auipc	a0,0x9
ffffffffc02033ec:	fc050513          	addi	a0,a0,-64 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02033f0:	85afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02033f4:	00009697          	auipc	a3,0x9
ffffffffc02033f8:	34c68693          	addi	a3,a3,844 # ffffffffc020c740 <etext+0x133e>
ffffffffc02033fc:	00008617          	auipc	a2,0x8
ffffffffc0203400:	44460613          	addi	a2,a2,1092 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203404:	22d00593          	li	a1,557
ffffffffc0203408:	00009517          	auipc	a0,0x9
ffffffffc020340c:	fa050513          	addi	a0,a0,-96 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203410:	83afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203414:	00009697          	auipc	a3,0x9
ffffffffc0203418:	31468693          	addi	a3,a3,788 # ffffffffc020c728 <etext+0x1326>
ffffffffc020341c:	00008617          	auipc	a2,0x8
ffffffffc0203420:	42460613          	addi	a2,a2,1060 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203424:	22c00593          	li	a1,556
ffffffffc0203428:	00009517          	auipc	a0,0x9
ffffffffc020342c:	f8050513          	addi	a0,a0,-128 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203430:	81afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203434:	00009697          	auipc	a3,0x9
ffffffffc0203438:	2c468693          	addi	a3,a3,708 # ffffffffc020c6f8 <etext+0x12f6>
ffffffffc020343c:	00008617          	auipc	a2,0x8
ffffffffc0203440:	40460613          	addi	a2,a2,1028 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203444:	22b00593          	li	a1,555
ffffffffc0203448:	00009517          	auipc	a0,0x9
ffffffffc020344c:	f6050513          	addi	a0,a0,-160 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203450:	ffbfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203454:	00009697          	auipc	a3,0x9
ffffffffc0203458:	28c68693          	addi	a3,a3,652 # ffffffffc020c6e0 <etext+0x12de>
ffffffffc020345c:	00008617          	auipc	a2,0x8
ffffffffc0203460:	3e460613          	addi	a2,a2,996 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203464:	22900593          	li	a1,553
ffffffffc0203468:	00009517          	auipc	a0,0x9
ffffffffc020346c:	f4050513          	addi	a0,a0,-192 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203470:	fdbfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203474:	00009697          	auipc	a3,0x9
ffffffffc0203478:	24c68693          	addi	a3,a3,588 # ffffffffc020c6c0 <etext+0x12be>
ffffffffc020347c:	00008617          	auipc	a2,0x8
ffffffffc0203480:	3c460613          	addi	a2,a2,964 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203484:	22800593          	li	a1,552
ffffffffc0203488:	00009517          	auipc	a0,0x9
ffffffffc020348c:	f2050513          	addi	a0,a0,-224 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203490:	fbbfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203494:	00009697          	auipc	a3,0x9
ffffffffc0203498:	21c68693          	addi	a3,a3,540 # ffffffffc020c6b0 <etext+0x12ae>
ffffffffc020349c:	00008617          	auipc	a2,0x8
ffffffffc02034a0:	3a460613          	addi	a2,a2,932 # ffffffffc020b840 <etext+0x43e>
ffffffffc02034a4:	22700593          	li	a1,551
ffffffffc02034a8:	00009517          	auipc	a0,0x9
ffffffffc02034ac:	f0050513          	addi	a0,a0,-256 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02034b0:	f9bfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02034b4:	00009697          	auipc	a3,0x9
ffffffffc02034b8:	1ec68693          	addi	a3,a3,492 # ffffffffc020c6a0 <etext+0x129e>
ffffffffc02034bc:	00008617          	auipc	a2,0x8
ffffffffc02034c0:	38460613          	addi	a2,a2,900 # ffffffffc020b840 <etext+0x43e>
ffffffffc02034c4:	22600593          	li	a1,550
ffffffffc02034c8:	00009517          	auipc	a0,0x9
ffffffffc02034cc:	ee050513          	addi	a0,a0,-288 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02034d0:	f7bfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02034d4:	00009617          	auipc	a2,0x9
ffffffffc02034d8:	e8c60613          	addi	a2,a2,-372 # ffffffffc020c360 <etext+0xf5e>
ffffffffc02034dc:	08000593          	li	a1,128
ffffffffc02034e0:	00009517          	auipc	a0,0x9
ffffffffc02034e4:	ec850513          	addi	a0,a0,-312 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02034e8:	f63fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02034ec:	00009697          	auipc	a3,0x9
ffffffffc02034f0:	10c68693          	addi	a3,a3,268 # ffffffffc020c5f8 <etext+0x11f6>
ffffffffc02034f4:	00008617          	auipc	a2,0x8
ffffffffc02034f8:	34c60613          	addi	a2,a2,844 # ffffffffc020b840 <etext+0x43e>
ffffffffc02034fc:	22100593          	li	a1,545
ffffffffc0203500:	00009517          	auipc	a0,0x9
ffffffffc0203504:	ea850513          	addi	a0,a0,-344 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203508:	f43fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020350c:	00009697          	auipc	a3,0x9
ffffffffc0203510:	15c68693          	addi	a3,a3,348 # ffffffffc020c668 <etext+0x1266>
ffffffffc0203514:	00008617          	auipc	a2,0x8
ffffffffc0203518:	32c60613          	addi	a2,a2,812 # ffffffffc020b840 <etext+0x43e>
ffffffffc020351c:	22500593          	li	a1,549
ffffffffc0203520:	00009517          	auipc	a0,0x9
ffffffffc0203524:	e8850513          	addi	a0,a0,-376 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203528:	f23fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020352c:	00009697          	auipc	a3,0x9
ffffffffc0203530:	0fc68693          	addi	a3,a3,252 # ffffffffc020c628 <etext+0x1226>
ffffffffc0203534:	00008617          	auipc	a2,0x8
ffffffffc0203538:	30c60613          	addi	a2,a2,780 # ffffffffc020b840 <etext+0x43e>
ffffffffc020353c:	22400593          	li	a1,548
ffffffffc0203540:	00009517          	auipc	a0,0x9
ffffffffc0203544:	e6850513          	addi	a0,a0,-408 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203548:	f03fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020354c:	86d6                	mv	a3,s5
ffffffffc020354e:	00009617          	auipc	a2,0x9
ffffffffc0203552:	d6a60613          	addi	a2,a2,-662 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc0203556:	22000593          	li	a1,544
ffffffffc020355a:	00009517          	auipc	a0,0x9
ffffffffc020355e:	e4e50513          	addi	a0,a0,-434 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203562:	ee9fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203566:	00009617          	auipc	a2,0x9
ffffffffc020356a:	d5260613          	addi	a2,a2,-686 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc020356e:	21f00593          	li	a1,543
ffffffffc0203572:	00009517          	auipc	a0,0x9
ffffffffc0203576:	e3650513          	addi	a0,a0,-458 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc020357a:	ed1fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020357e:	00009697          	auipc	a3,0x9
ffffffffc0203582:	06268693          	addi	a3,a3,98 # ffffffffc020c5e0 <etext+0x11de>
ffffffffc0203586:	00008617          	auipc	a2,0x8
ffffffffc020358a:	2ba60613          	addi	a2,a2,698 # ffffffffc020b840 <etext+0x43e>
ffffffffc020358e:	21d00593          	li	a1,541
ffffffffc0203592:	00009517          	auipc	a0,0x9
ffffffffc0203596:	e1650513          	addi	a0,a0,-490 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc020359a:	eb1fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020359e:	00009697          	auipc	a3,0x9
ffffffffc02035a2:	02a68693          	addi	a3,a3,42 # ffffffffc020c5c8 <etext+0x11c6>
ffffffffc02035a6:	00008617          	auipc	a2,0x8
ffffffffc02035aa:	29a60613          	addi	a2,a2,666 # ffffffffc020b840 <etext+0x43e>
ffffffffc02035ae:	21c00593          	li	a1,540
ffffffffc02035b2:	00009517          	auipc	a0,0x9
ffffffffc02035b6:	df650513          	addi	a0,a0,-522 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02035ba:	e91fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035be:	00009697          	auipc	a3,0x9
ffffffffc02035c2:	3ba68693          	addi	a3,a3,954 # ffffffffc020c978 <etext+0x1576>
ffffffffc02035c6:	00008617          	auipc	a2,0x8
ffffffffc02035ca:	27a60613          	addi	a2,a2,634 # ffffffffc020b840 <etext+0x43e>
ffffffffc02035ce:	26300593          	li	a1,611
ffffffffc02035d2:	00009517          	auipc	a0,0x9
ffffffffc02035d6:	dd650513          	addi	a0,a0,-554 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02035da:	e71fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035de:	00009697          	auipc	a3,0x9
ffffffffc02035e2:	36268693          	addi	a3,a3,866 # ffffffffc020c940 <etext+0x153e>
ffffffffc02035e6:	00008617          	auipc	a2,0x8
ffffffffc02035ea:	25a60613          	addi	a2,a2,602 # ffffffffc020b840 <etext+0x43e>
ffffffffc02035ee:	26000593          	li	a1,608
ffffffffc02035f2:	00009517          	auipc	a0,0x9
ffffffffc02035f6:	db650513          	addi	a0,a0,-586 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02035fa:	e51fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035fe:	00009697          	auipc	a3,0x9
ffffffffc0203602:	31268693          	addi	a3,a3,786 # ffffffffc020c910 <etext+0x150e>
ffffffffc0203606:	00008617          	auipc	a2,0x8
ffffffffc020360a:	23a60613          	addi	a2,a2,570 # ffffffffc020b840 <etext+0x43e>
ffffffffc020360e:	25c00593          	li	a1,604
ffffffffc0203612:	00009517          	auipc	a0,0x9
ffffffffc0203616:	d9650513          	addi	a0,a0,-618 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc020361a:	e31fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020361e:	00009697          	auipc	a3,0x9
ffffffffc0203622:	2aa68693          	addi	a3,a3,682 # ffffffffc020c8c8 <etext+0x14c6>
ffffffffc0203626:	00008617          	auipc	a2,0x8
ffffffffc020362a:	21a60613          	addi	a2,a2,538 # ffffffffc020b840 <etext+0x43e>
ffffffffc020362e:	25b00593          	li	a1,603
ffffffffc0203632:	00009517          	auipc	a0,0x9
ffffffffc0203636:	d7650513          	addi	a0,a0,-650 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc020363a:	e11fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020363e:	00009697          	auipc	a3,0x9
ffffffffc0203642:	ed268693          	addi	a3,a3,-302 # ffffffffc020c510 <etext+0x110e>
ffffffffc0203646:	00008617          	auipc	a2,0x8
ffffffffc020364a:	1fa60613          	addi	a2,a2,506 # ffffffffc020b840 <etext+0x43e>
ffffffffc020364e:	21400593          	li	a1,532
ffffffffc0203652:	00009517          	auipc	a0,0x9
ffffffffc0203656:	d5650513          	addi	a0,a0,-682 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc020365a:	df1fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020365e:	00009617          	auipc	a2,0x9
ffffffffc0203662:	d0260613          	addi	a2,a2,-766 # ffffffffc020c360 <etext+0xf5e>
ffffffffc0203666:	0c800593          	li	a1,200
ffffffffc020366a:	00009517          	auipc	a0,0x9
ffffffffc020366e:	d3e50513          	addi	a0,a0,-706 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203672:	dd9fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203676:	00009697          	auipc	a3,0x9
ffffffffc020367a:	efa68693          	addi	a3,a3,-262 # ffffffffc020c570 <etext+0x116e>
ffffffffc020367e:	00008617          	auipc	a2,0x8
ffffffffc0203682:	1c260613          	addi	a2,a2,450 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203686:	21b00593          	li	a1,539
ffffffffc020368a:	00009517          	auipc	a0,0x9
ffffffffc020368e:	d1e50513          	addi	a0,a0,-738 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203692:	db9fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203696:	00009697          	auipc	a3,0x9
ffffffffc020369a:	eaa68693          	addi	a3,a3,-342 # ffffffffc020c540 <etext+0x113e>
ffffffffc020369e:	00008617          	auipc	a2,0x8
ffffffffc02036a2:	1a260613          	addi	a2,a2,418 # ffffffffc020b840 <etext+0x43e>
ffffffffc02036a6:	21800593          	li	a1,536
ffffffffc02036aa:	00009517          	auipc	a0,0x9
ffffffffc02036ae:	cfe50513          	addi	a0,a0,-770 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02036b2:	d99fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02036b6 <copy_range>:
ffffffffc02036b6:	7159                	addi	sp,sp,-112
ffffffffc02036b8:	00d667b3          	or	a5,a2,a3
ffffffffc02036bc:	f486                	sd	ra,104(sp)
ffffffffc02036be:	f0a2                	sd	s0,96(sp)
ffffffffc02036c0:	eca6                	sd	s1,88(sp)
ffffffffc02036c2:	e8ca                	sd	s2,80(sp)
ffffffffc02036c4:	e4ce                	sd	s3,72(sp)
ffffffffc02036c6:	e0d2                	sd	s4,64(sp)
ffffffffc02036c8:	fc56                	sd	s5,56(sp)
ffffffffc02036ca:	f85a                	sd	s6,48(sp)
ffffffffc02036cc:	f45e                	sd	s7,40(sp)
ffffffffc02036ce:	f062                	sd	s8,32(sp)
ffffffffc02036d0:	ec66                	sd	s9,24(sp)
ffffffffc02036d2:	e86a                	sd	s10,16(sp)
ffffffffc02036d4:	e46e                	sd	s11,8(sp)
ffffffffc02036d6:	03479713          	slli	a4,a5,0x34
ffffffffc02036da:	20071f63          	bnez	a4,ffffffffc02038f8 <copy_range+0x242>
ffffffffc02036de:	002007b7          	lui	a5,0x200
ffffffffc02036e2:	00d63733          	sltu	a4,a2,a3
ffffffffc02036e6:	00f637b3          	sltu	a5,a2,a5
ffffffffc02036ea:	00173713          	seqz	a4,a4
ffffffffc02036ee:	8fd9                	or	a5,a5,a4
ffffffffc02036f0:	8432                	mv	s0,a2
ffffffffc02036f2:	8936                	mv	s2,a3
ffffffffc02036f4:	1e079263          	bnez	a5,ffffffffc02038d8 <copy_range+0x222>
ffffffffc02036f8:	4785                	li	a5,1
ffffffffc02036fa:	07fe                	slli	a5,a5,0x1f
ffffffffc02036fc:	0785                	addi	a5,a5,1 # 200001 <_binary_bin_sfs_img_size+0x18ad01>
ffffffffc02036fe:	1cf6fd63          	bgeu	a3,a5,ffffffffc02038d8 <copy_range+0x222>
ffffffffc0203702:	5b7d                	li	s6,-1
ffffffffc0203704:	8baa                	mv	s7,a0
ffffffffc0203706:	8a2e                	mv	s4,a1
ffffffffc0203708:	6a85                	lui	s5,0x1
ffffffffc020370a:	00cb5b13          	srli	s6,s6,0xc
ffffffffc020370e:	00093c97          	auipc	s9,0x93
ffffffffc0203712:	1a2c8c93          	addi	s9,s9,418 # ffffffffc02968b0 <npage>
ffffffffc0203716:	00093c17          	auipc	s8,0x93
ffffffffc020371a:	1a2c0c13          	addi	s8,s8,418 # ffffffffc02968b8 <pages>
ffffffffc020371e:	fff80d37          	lui	s10,0xfff80
ffffffffc0203722:	4601                	li	a2,0
ffffffffc0203724:	85a2                	mv	a1,s0
ffffffffc0203726:	8552                	mv	a0,s4
ffffffffc0203728:	b19fe0ef          	jal	ffffffffc0202240 <get_pte>
ffffffffc020372c:	84aa                	mv	s1,a0
ffffffffc020372e:	0e050a63          	beqz	a0,ffffffffc0203822 <copy_range+0x16c>
ffffffffc0203732:	611c                	ld	a5,0(a0)
ffffffffc0203734:	8b85                	andi	a5,a5,1
ffffffffc0203736:	e78d                	bnez	a5,ffffffffc0203760 <copy_range+0xaa>
ffffffffc0203738:	9456                	add	s0,s0,s5
ffffffffc020373a:	c019                	beqz	s0,ffffffffc0203740 <copy_range+0x8a>
ffffffffc020373c:	ff2463e3          	bltu	s0,s2,ffffffffc0203722 <copy_range+0x6c>
ffffffffc0203740:	4501                	li	a0,0
ffffffffc0203742:	70a6                	ld	ra,104(sp)
ffffffffc0203744:	7406                	ld	s0,96(sp)
ffffffffc0203746:	64e6                	ld	s1,88(sp)
ffffffffc0203748:	6946                	ld	s2,80(sp)
ffffffffc020374a:	69a6                	ld	s3,72(sp)
ffffffffc020374c:	6a06                	ld	s4,64(sp)
ffffffffc020374e:	7ae2                	ld	s5,56(sp)
ffffffffc0203750:	7b42                	ld	s6,48(sp)
ffffffffc0203752:	7ba2                	ld	s7,40(sp)
ffffffffc0203754:	7c02                	ld	s8,32(sp)
ffffffffc0203756:	6ce2                	ld	s9,24(sp)
ffffffffc0203758:	6d42                	ld	s10,16(sp)
ffffffffc020375a:	6da2                	ld	s11,8(sp)
ffffffffc020375c:	6165                	addi	sp,sp,112
ffffffffc020375e:	8082                	ret
ffffffffc0203760:	4605                	li	a2,1
ffffffffc0203762:	85a2                	mv	a1,s0
ffffffffc0203764:	855e                	mv	a0,s7
ffffffffc0203766:	adbfe0ef          	jal	ffffffffc0202240 <get_pte>
ffffffffc020376a:	c165                	beqz	a0,ffffffffc020384a <copy_range+0x194>
ffffffffc020376c:	0004b983          	ld	s3,0(s1)
ffffffffc0203770:	0019f793          	andi	a5,s3,1
ffffffffc0203774:	14078663          	beqz	a5,ffffffffc02038c0 <copy_range+0x20a>
ffffffffc0203778:	000cb703          	ld	a4,0(s9)
ffffffffc020377c:	00299793          	slli	a5,s3,0x2
ffffffffc0203780:	83b1                	srli	a5,a5,0xc
ffffffffc0203782:	12e7f363          	bgeu	a5,a4,ffffffffc02038a8 <copy_range+0x1f2>
ffffffffc0203786:	000c3483          	ld	s1,0(s8)
ffffffffc020378a:	97ea                	add	a5,a5,s10
ffffffffc020378c:	079a                	slli	a5,a5,0x6
ffffffffc020378e:	94be                	add	s1,s1,a5
ffffffffc0203790:	100027f3          	csrr	a5,sstatus
ffffffffc0203794:	8b89                	andi	a5,a5,2
ffffffffc0203796:	efc9                	bnez	a5,ffffffffc0203830 <copy_range+0x17a>
ffffffffc0203798:	00093797          	auipc	a5,0x93
ffffffffc020379c:	0f87b783          	ld	a5,248(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02037a0:	4505                	li	a0,1
ffffffffc02037a2:	6f9c                	ld	a5,24(a5)
ffffffffc02037a4:	9782                	jalr	a5
ffffffffc02037a6:	8daa                	mv	s11,a0
ffffffffc02037a8:	c0e5                	beqz	s1,ffffffffc0203888 <copy_range+0x1d2>
ffffffffc02037aa:	0a0d8f63          	beqz	s11,ffffffffc0203868 <copy_range+0x1b2>
ffffffffc02037ae:	000c3783          	ld	a5,0(s8)
ffffffffc02037b2:	00080637          	lui	a2,0x80
ffffffffc02037b6:	000cb703          	ld	a4,0(s9)
ffffffffc02037ba:	40f486b3          	sub	a3,s1,a5
ffffffffc02037be:	8699                	srai	a3,a3,0x6
ffffffffc02037c0:	96b2                	add	a3,a3,a2
ffffffffc02037c2:	0166f5b3          	and	a1,a3,s6
ffffffffc02037c6:	06b2                	slli	a3,a3,0xc
ffffffffc02037c8:	08e5f463          	bgeu	a1,a4,ffffffffc0203850 <copy_range+0x19a>
ffffffffc02037cc:	40fd87b3          	sub	a5,s11,a5
ffffffffc02037d0:	8799                	srai	a5,a5,0x6
ffffffffc02037d2:	97b2                	add	a5,a5,a2
ffffffffc02037d4:	0167f633          	and	a2,a5,s6
ffffffffc02037d8:	07b2                	slli	a5,a5,0xc
ffffffffc02037da:	06e67a63          	bgeu	a2,a4,ffffffffc020384e <copy_range+0x198>
ffffffffc02037de:	00093517          	auipc	a0,0x93
ffffffffc02037e2:	0ca53503          	ld	a0,202(a0) # ffffffffc02968a8 <va_pa_offset>
ffffffffc02037e6:	6605                	lui	a2,0x1
ffffffffc02037e8:	00a685b3          	add	a1,a3,a0
ffffffffc02037ec:	953e                	add	a0,a0,a5
ffffffffc02037ee:	3fd070ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc02037f2:	01f9f693          	andi	a3,s3,31
ffffffffc02037f6:	85ee                	mv	a1,s11
ffffffffc02037f8:	8622                	mv	a2,s0
ffffffffc02037fa:	855e                	mv	a0,s7
ffffffffc02037fc:	97aff0ef          	jal	ffffffffc0202976 <page_insert>
ffffffffc0203800:	dd05                	beqz	a0,ffffffffc0203738 <copy_range+0x82>
ffffffffc0203802:	00009697          	auipc	a3,0x9
ffffffffc0203806:	1de68693          	addi	a3,a3,478 # ffffffffc020c9e0 <etext+0x15de>
ffffffffc020380a:	00008617          	auipc	a2,0x8
ffffffffc020380e:	03660613          	addi	a2,a2,54 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203812:	1b000593          	li	a1,432
ffffffffc0203816:	00009517          	auipc	a0,0x9
ffffffffc020381a:	b9250513          	addi	a0,a0,-1134 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc020381e:	c2dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203822:	002007b7          	lui	a5,0x200
ffffffffc0203826:	97a2                	add	a5,a5,s0
ffffffffc0203828:	ffe00437          	lui	s0,0xffe00
ffffffffc020382c:	8c7d                	and	s0,s0,a5
ffffffffc020382e:	b731                	j	ffffffffc020373a <copy_range+0x84>
ffffffffc0203830:	bccfd0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0203834:	00093797          	auipc	a5,0x93
ffffffffc0203838:	05c7b783          	ld	a5,92(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc020383c:	4505                	li	a0,1
ffffffffc020383e:	6f9c                	ld	a5,24(a5)
ffffffffc0203840:	9782                	jalr	a5
ffffffffc0203842:	8daa                	mv	s11,a0
ffffffffc0203844:	bb2fd0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc0203848:	b785                	j	ffffffffc02037a8 <copy_range+0xf2>
ffffffffc020384a:	5571                	li	a0,-4
ffffffffc020384c:	bddd                	j	ffffffffc0203742 <copy_range+0x8c>
ffffffffc020384e:	86be                	mv	a3,a5
ffffffffc0203850:	00009617          	auipc	a2,0x9
ffffffffc0203854:	a6860613          	addi	a2,a2,-1432 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc0203858:	07100593          	li	a1,113
ffffffffc020385c:	00009517          	auipc	a0,0x9
ffffffffc0203860:	a8450513          	addi	a0,a0,-1404 # ffffffffc020c2e0 <etext+0xede>
ffffffffc0203864:	be7fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203868:	00009697          	auipc	a3,0x9
ffffffffc020386c:	16868693          	addi	a3,a3,360 # ffffffffc020c9d0 <etext+0x15ce>
ffffffffc0203870:	00008617          	auipc	a2,0x8
ffffffffc0203874:	fd060613          	addi	a2,a2,-48 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203878:	19600593          	li	a1,406
ffffffffc020387c:	00009517          	auipc	a0,0x9
ffffffffc0203880:	b2c50513          	addi	a0,a0,-1236 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203884:	bc7fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203888:	00009697          	auipc	a3,0x9
ffffffffc020388c:	13868693          	addi	a3,a3,312 # ffffffffc020c9c0 <etext+0x15be>
ffffffffc0203890:	00008617          	auipc	a2,0x8
ffffffffc0203894:	fb060613          	addi	a2,a2,-80 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203898:	19500593          	li	a1,405
ffffffffc020389c:	00009517          	auipc	a0,0x9
ffffffffc02038a0:	b0c50513          	addi	a0,a0,-1268 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02038a4:	ba7fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02038a8:	00009617          	auipc	a2,0x9
ffffffffc02038ac:	ae060613          	addi	a2,a2,-1312 # ffffffffc020c388 <etext+0xf86>
ffffffffc02038b0:	06900593          	li	a1,105
ffffffffc02038b4:	00009517          	auipc	a0,0x9
ffffffffc02038b8:	a2c50513          	addi	a0,a0,-1492 # ffffffffc020c2e0 <etext+0xede>
ffffffffc02038bc:	b8ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02038c0:	00009617          	auipc	a2,0x9
ffffffffc02038c4:	ce060613          	addi	a2,a2,-800 # ffffffffc020c5a0 <etext+0x119e>
ffffffffc02038c8:	07f00593          	li	a1,127
ffffffffc02038cc:	00009517          	auipc	a0,0x9
ffffffffc02038d0:	a1450513          	addi	a0,a0,-1516 # ffffffffc020c2e0 <etext+0xede>
ffffffffc02038d4:	b77fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02038d8:	00009697          	auipc	a3,0x9
ffffffffc02038dc:	b1068693          	addi	a3,a3,-1264 # ffffffffc020c3e8 <etext+0xfe6>
ffffffffc02038e0:	00008617          	auipc	a2,0x8
ffffffffc02038e4:	f6060613          	addi	a2,a2,-160 # ffffffffc020b840 <etext+0x43e>
ffffffffc02038e8:	17d00593          	li	a1,381
ffffffffc02038ec:	00009517          	auipc	a0,0x9
ffffffffc02038f0:	abc50513          	addi	a0,a0,-1348 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc02038f4:	b57fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02038f8:	00009697          	auipc	a3,0x9
ffffffffc02038fc:	ac068693          	addi	a3,a3,-1344 # ffffffffc020c3b8 <etext+0xfb6>
ffffffffc0203900:	00008617          	auipc	a2,0x8
ffffffffc0203904:	f4060613          	addi	a2,a2,-192 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203908:	17c00593          	li	a1,380
ffffffffc020390c:	00009517          	auipc	a0,0x9
ffffffffc0203910:	a9c50513          	addi	a0,a0,-1380 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc0203914:	b37fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203918 <pgdir_alloc_page>:
ffffffffc0203918:	7139                	addi	sp,sp,-64
ffffffffc020391a:	f426                	sd	s1,40(sp)
ffffffffc020391c:	f04a                	sd	s2,32(sp)
ffffffffc020391e:	ec4e                	sd	s3,24(sp)
ffffffffc0203920:	fc06                	sd	ra,56(sp)
ffffffffc0203922:	f822                	sd	s0,48(sp)
ffffffffc0203924:	892a                	mv	s2,a0
ffffffffc0203926:	84ae                	mv	s1,a1
ffffffffc0203928:	89b2                	mv	s3,a2
ffffffffc020392a:	100027f3          	csrr	a5,sstatus
ffffffffc020392e:	8b89                	andi	a5,a5,2
ffffffffc0203930:	ebb5                	bnez	a5,ffffffffc02039a4 <pgdir_alloc_page+0x8c>
ffffffffc0203932:	00093417          	auipc	s0,0x93
ffffffffc0203936:	f5e40413          	addi	s0,s0,-162 # ffffffffc0296890 <pmm_manager>
ffffffffc020393a:	601c                	ld	a5,0(s0)
ffffffffc020393c:	4505                	li	a0,1
ffffffffc020393e:	6f9c                	ld	a5,24(a5)
ffffffffc0203940:	9782                	jalr	a5
ffffffffc0203942:	85aa                	mv	a1,a0
ffffffffc0203944:	c5b9                	beqz	a1,ffffffffc0203992 <pgdir_alloc_page+0x7a>
ffffffffc0203946:	86ce                	mv	a3,s3
ffffffffc0203948:	854a                	mv	a0,s2
ffffffffc020394a:	8626                	mv	a2,s1
ffffffffc020394c:	e42e                	sd	a1,8(sp)
ffffffffc020394e:	828ff0ef          	jal	ffffffffc0202976 <page_insert>
ffffffffc0203952:	65a2                	ld	a1,8(sp)
ffffffffc0203954:	e515                	bnez	a0,ffffffffc0203980 <pgdir_alloc_page+0x68>
ffffffffc0203956:	4198                	lw	a4,0(a1)
ffffffffc0203958:	fd84                	sd	s1,56(a1)
ffffffffc020395a:	4785                	li	a5,1
ffffffffc020395c:	02f70c63          	beq	a4,a5,ffffffffc0203994 <pgdir_alloc_page+0x7c>
ffffffffc0203960:	00009697          	auipc	a3,0x9
ffffffffc0203964:	09068693          	addi	a3,a3,144 # ffffffffc020c9f0 <etext+0x15ee>
ffffffffc0203968:	00008617          	auipc	a2,0x8
ffffffffc020396c:	ed860613          	addi	a2,a2,-296 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203970:	1f900593          	li	a1,505
ffffffffc0203974:	00009517          	auipc	a0,0x9
ffffffffc0203978:	a3450513          	addi	a0,a0,-1484 # ffffffffc020c3a8 <etext+0xfa6>
ffffffffc020397c:	acffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203980:	100027f3          	csrr	a5,sstatus
ffffffffc0203984:	8b89                	andi	a5,a5,2
ffffffffc0203986:	ef95                	bnez	a5,ffffffffc02039c2 <pgdir_alloc_page+0xaa>
ffffffffc0203988:	601c                	ld	a5,0(s0)
ffffffffc020398a:	852e                	mv	a0,a1
ffffffffc020398c:	4585                	li	a1,1
ffffffffc020398e:	739c                	ld	a5,32(a5)
ffffffffc0203990:	9782                	jalr	a5
ffffffffc0203992:	4581                	li	a1,0
ffffffffc0203994:	70e2                	ld	ra,56(sp)
ffffffffc0203996:	7442                	ld	s0,48(sp)
ffffffffc0203998:	74a2                	ld	s1,40(sp)
ffffffffc020399a:	7902                	ld	s2,32(sp)
ffffffffc020399c:	69e2                	ld	s3,24(sp)
ffffffffc020399e:	852e                	mv	a0,a1
ffffffffc02039a0:	6121                	addi	sp,sp,64
ffffffffc02039a2:	8082                	ret
ffffffffc02039a4:	a58fd0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc02039a8:	00093417          	auipc	s0,0x93
ffffffffc02039ac:	ee840413          	addi	s0,s0,-280 # ffffffffc0296890 <pmm_manager>
ffffffffc02039b0:	601c                	ld	a5,0(s0)
ffffffffc02039b2:	4505                	li	a0,1
ffffffffc02039b4:	6f9c                	ld	a5,24(a5)
ffffffffc02039b6:	9782                	jalr	a5
ffffffffc02039b8:	e42a                	sd	a0,8(sp)
ffffffffc02039ba:	a3cfd0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc02039be:	65a2                	ld	a1,8(sp)
ffffffffc02039c0:	b751                	j	ffffffffc0203944 <pgdir_alloc_page+0x2c>
ffffffffc02039c2:	a3afd0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc02039c6:	601c                	ld	a5,0(s0)
ffffffffc02039c8:	6522                	ld	a0,8(sp)
ffffffffc02039ca:	4585                	li	a1,1
ffffffffc02039cc:	739c                	ld	a5,32(a5)
ffffffffc02039ce:	9782                	jalr	a5
ffffffffc02039d0:	a26fd0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc02039d4:	bf7d                	j	ffffffffc0203992 <pgdir_alloc_page+0x7a>

ffffffffc02039d6 <check_vma_overlap.part.0>:
ffffffffc02039d6:	1141                	addi	sp,sp,-16
ffffffffc02039d8:	00009697          	auipc	a3,0x9
ffffffffc02039dc:	03068693          	addi	a3,a3,48 # ffffffffc020ca08 <etext+0x1606>
ffffffffc02039e0:	00008617          	auipc	a2,0x8
ffffffffc02039e4:	e6060613          	addi	a2,a2,-416 # ffffffffc020b840 <etext+0x43e>
ffffffffc02039e8:	07400593          	li	a1,116
ffffffffc02039ec:	00009517          	auipc	a0,0x9
ffffffffc02039f0:	03c50513          	addi	a0,a0,60 # ffffffffc020ca28 <etext+0x1626>
ffffffffc02039f4:	e406                	sd	ra,8(sp)
ffffffffc02039f6:	a55fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02039fa <mm_create>:
ffffffffc02039fa:	1101                	addi	sp,sp,-32
ffffffffc02039fc:	05800513          	li	a0,88
ffffffffc0203a00:	ec06                	sd	ra,24(sp)
ffffffffc0203a02:	dd2fe0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0203a06:	87aa                	mv	a5,a0
ffffffffc0203a08:	c505                	beqz	a0,ffffffffc0203a30 <mm_create+0x36>
ffffffffc0203a0a:	e788                	sd	a0,8(a5)
ffffffffc0203a0c:	e388                	sd	a0,0(a5)
ffffffffc0203a0e:	00053823          	sd	zero,16(a0)
ffffffffc0203a12:	00053c23          	sd	zero,24(a0)
ffffffffc0203a16:	02052023          	sw	zero,32(a0)
ffffffffc0203a1a:	02053423          	sd	zero,40(a0)
ffffffffc0203a1e:	02052823          	sw	zero,48(a0)
ffffffffc0203a22:	4585                	li	a1,1
ffffffffc0203a24:	03850513          	addi	a0,a0,56
ffffffffc0203a28:	e43e                	sd	a5,8(sp)
ffffffffc0203a2a:	169000ef          	jal	ffffffffc0204392 <sem_init>
ffffffffc0203a2e:	67a2                	ld	a5,8(sp)
ffffffffc0203a30:	60e2                	ld	ra,24(sp)
ffffffffc0203a32:	853e                	mv	a0,a5
ffffffffc0203a34:	6105                	addi	sp,sp,32
ffffffffc0203a36:	8082                	ret

ffffffffc0203a38 <find_vma>:
ffffffffc0203a38:	c505                	beqz	a0,ffffffffc0203a60 <find_vma+0x28>
ffffffffc0203a3a:	691c                	ld	a5,16(a0)
ffffffffc0203a3c:	c781                	beqz	a5,ffffffffc0203a44 <find_vma+0xc>
ffffffffc0203a3e:	6798                	ld	a4,8(a5)
ffffffffc0203a40:	02e5f363          	bgeu	a1,a4,ffffffffc0203a66 <find_vma+0x2e>
ffffffffc0203a44:	651c                	ld	a5,8(a0)
ffffffffc0203a46:	00f50d63          	beq	a0,a5,ffffffffc0203a60 <find_vma+0x28>
ffffffffc0203a4a:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203a4e:	00e5e663          	bltu	a1,a4,ffffffffc0203a5a <find_vma+0x22>
ffffffffc0203a52:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203a56:	00e5ee63          	bltu	a1,a4,ffffffffc0203a72 <find_vma+0x3a>
ffffffffc0203a5a:	679c                	ld	a5,8(a5)
ffffffffc0203a5c:	fef517e3          	bne	a0,a5,ffffffffc0203a4a <find_vma+0x12>
ffffffffc0203a60:	4781                	li	a5,0
ffffffffc0203a62:	853e                	mv	a0,a5
ffffffffc0203a64:	8082                	ret
ffffffffc0203a66:	6b98                	ld	a4,16(a5)
ffffffffc0203a68:	fce5fee3          	bgeu	a1,a4,ffffffffc0203a44 <find_vma+0xc>
ffffffffc0203a6c:	e91c                	sd	a5,16(a0)
ffffffffc0203a6e:	853e                	mv	a0,a5
ffffffffc0203a70:	8082                	ret
ffffffffc0203a72:	1781                	addi	a5,a5,-32
ffffffffc0203a74:	e91c                	sd	a5,16(a0)
ffffffffc0203a76:	bfe5                	j	ffffffffc0203a6e <find_vma+0x36>

ffffffffc0203a78 <insert_vma_struct>:
ffffffffc0203a78:	6590                	ld	a2,8(a1)
ffffffffc0203a7a:	0105b803          	ld	a6,16(a1)
ffffffffc0203a7e:	1141                	addi	sp,sp,-16
ffffffffc0203a80:	e406                	sd	ra,8(sp)
ffffffffc0203a82:	87aa                	mv	a5,a0
ffffffffc0203a84:	01066763          	bltu	a2,a6,ffffffffc0203a92 <insert_vma_struct+0x1a>
ffffffffc0203a88:	a8b9                	j	ffffffffc0203ae6 <insert_vma_struct+0x6e>
ffffffffc0203a8a:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203a8e:	04e66763          	bltu	a2,a4,ffffffffc0203adc <insert_vma_struct+0x64>
ffffffffc0203a92:	86be                	mv	a3,a5
ffffffffc0203a94:	679c                	ld	a5,8(a5)
ffffffffc0203a96:	fef51ae3          	bne	a0,a5,ffffffffc0203a8a <insert_vma_struct+0x12>
ffffffffc0203a9a:	02a68463          	beq	a3,a0,ffffffffc0203ac2 <insert_vma_struct+0x4a>
ffffffffc0203a9e:	ff06b703          	ld	a4,-16(a3)
ffffffffc0203aa2:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203aa6:	08e8f063          	bgeu	a7,a4,ffffffffc0203b26 <insert_vma_struct+0xae>
ffffffffc0203aaa:	04e66e63          	bltu	a2,a4,ffffffffc0203b06 <insert_vma_struct+0x8e>
ffffffffc0203aae:	00f50a63          	beq	a0,a5,ffffffffc0203ac2 <insert_vma_struct+0x4a>
ffffffffc0203ab2:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203ab6:	05076863          	bltu	a4,a6,ffffffffc0203b06 <insert_vma_struct+0x8e>
ffffffffc0203aba:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203abe:	02c77263          	bgeu	a4,a2,ffffffffc0203ae2 <insert_vma_struct+0x6a>
ffffffffc0203ac2:	5118                	lw	a4,32(a0)
ffffffffc0203ac4:	e188                	sd	a0,0(a1)
ffffffffc0203ac6:	02058613          	addi	a2,a1,32
ffffffffc0203aca:	e390                	sd	a2,0(a5)
ffffffffc0203acc:	e690                	sd	a2,8(a3)
ffffffffc0203ace:	60a2                	ld	ra,8(sp)
ffffffffc0203ad0:	f59c                	sd	a5,40(a1)
ffffffffc0203ad2:	f194                	sd	a3,32(a1)
ffffffffc0203ad4:	2705                	addiw	a4,a4,1
ffffffffc0203ad6:	d118                	sw	a4,32(a0)
ffffffffc0203ad8:	0141                	addi	sp,sp,16
ffffffffc0203ada:	8082                	ret
ffffffffc0203adc:	fca691e3          	bne	a3,a0,ffffffffc0203a9e <insert_vma_struct+0x26>
ffffffffc0203ae0:	bfd9                	j	ffffffffc0203ab6 <insert_vma_struct+0x3e>
ffffffffc0203ae2:	ef5ff0ef          	jal	ffffffffc02039d6 <check_vma_overlap.part.0>
ffffffffc0203ae6:	00009697          	auipc	a3,0x9
ffffffffc0203aea:	f5268693          	addi	a3,a3,-174 # ffffffffc020ca38 <etext+0x1636>
ffffffffc0203aee:	00008617          	auipc	a2,0x8
ffffffffc0203af2:	d5260613          	addi	a2,a2,-686 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203af6:	07a00593          	li	a1,122
ffffffffc0203afa:	00009517          	auipc	a0,0x9
ffffffffc0203afe:	f2e50513          	addi	a0,a0,-210 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0203b02:	949fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203b06:	00009697          	auipc	a3,0x9
ffffffffc0203b0a:	f7268693          	addi	a3,a3,-142 # ffffffffc020ca78 <etext+0x1676>
ffffffffc0203b0e:	00008617          	auipc	a2,0x8
ffffffffc0203b12:	d3260613          	addi	a2,a2,-718 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203b16:	07300593          	li	a1,115
ffffffffc0203b1a:	00009517          	auipc	a0,0x9
ffffffffc0203b1e:	f0e50513          	addi	a0,a0,-242 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0203b22:	929fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203b26:	00009697          	auipc	a3,0x9
ffffffffc0203b2a:	f3268693          	addi	a3,a3,-206 # ffffffffc020ca58 <etext+0x1656>
ffffffffc0203b2e:	00008617          	auipc	a2,0x8
ffffffffc0203b32:	d1260613          	addi	a2,a2,-750 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203b36:	07200593          	li	a1,114
ffffffffc0203b3a:	00009517          	auipc	a0,0x9
ffffffffc0203b3e:	eee50513          	addi	a0,a0,-274 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0203b42:	909fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203b46 <mm_destroy>:
ffffffffc0203b46:	591c                	lw	a5,48(a0)
ffffffffc0203b48:	1141                	addi	sp,sp,-16
ffffffffc0203b4a:	e406                	sd	ra,8(sp)
ffffffffc0203b4c:	e022                	sd	s0,0(sp)
ffffffffc0203b4e:	e78d                	bnez	a5,ffffffffc0203b78 <mm_destroy+0x32>
ffffffffc0203b50:	842a                	mv	s0,a0
ffffffffc0203b52:	6508                	ld	a0,8(a0)
ffffffffc0203b54:	00a40c63          	beq	s0,a0,ffffffffc0203b6c <mm_destroy+0x26>
ffffffffc0203b58:	6118                	ld	a4,0(a0)
ffffffffc0203b5a:	651c                	ld	a5,8(a0)
ffffffffc0203b5c:	1501                	addi	a0,a0,-32
ffffffffc0203b5e:	e71c                	sd	a5,8(a4)
ffffffffc0203b60:	e398                	sd	a4,0(a5)
ffffffffc0203b62:	d18fe0ef          	jal	ffffffffc020207a <kfree>
ffffffffc0203b66:	6408                	ld	a0,8(s0)
ffffffffc0203b68:	fea418e3          	bne	s0,a0,ffffffffc0203b58 <mm_destroy+0x12>
ffffffffc0203b6c:	8522                	mv	a0,s0
ffffffffc0203b6e:	6402                	ld	s0,0(sp)
ffffffffc0203b70:	60a2                	ld	ra,8(sp)
ffffffffc0203b72:	0141                	addi	sp,sp,16
ffffffffc0203b74:	d06fe06f          	j	ffffffffc020207a <kfree>
ffffffffc0203b78:	00009697          	auipc	a3,0x9
ffffffffc0203b7c:	f2068693          	addi	a3,a3,-224 # ffffffffc020ca98 <etext+0x1696>
ffffffffc0203b80:	00008617          	auipc	a2,0x8
ffffffffc0203b84:	cc060613          	addi	a2,a2,-832 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203b88:	09e00593          	li	a1,158
ffffffffc0203b8c:	00009517          	auipc	a0,0x9
ffffffffc0203b90:	e9c50513          	addi	a0,a0,-356 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0203b94:	8b7fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203b98 <mm_map>:
ffffffffc0203b98:	6785                	lui	a5,0x1
ffffffffc0203b9a:	17fd                	addi	a5,a5,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0203b9c:	963e                	add	a2,a2,a5
ffffffffc0203b9e:	4785                	li	a5,1
ffffffffc0203ba0:	7139                	addi	sp,sp,-64
ffffffffc0203ba2:	962e                	add	a2,a2,a1
ffffffffc0203ba4:	787d                	lui	a6,0xfffff
ffffffffc0203ba6:	07fe                	slli	a5,a5,0x1f
ffffffffc0203ba8:	f822                	sd	s0,48(sp)
ffffffffc0203baa:	f426                	sd	s1,40(sp)
ffffffffc0203bac:	01067433          	and	s0,a2,a6
ffffffffc0203bb0:	0105f4b3          	and	s1,a1,a6
ffffffffc0203bb4:	0785                	addi	a5,a5,1
ffffffffc0203bb6:	0084b633          	sltu	a2,s1,s0
ffffffffc0203bba:	00f437b3          	sltu	a5,s0,a5
ffffffffc0203bbe:	00163613          	seqz	a2,a2
ffffffffc0203bc2:	0017b793          	seqz	a5,a5
ffffffffc0203bc6:	fc06                	sd	ra,56(sp)
ffffffffc0203bc8:	8fd1                	or	a5,a5,a2
ffffffffc0203bca:	ebbd                	bnez	a5,ffffffffc0203c40 <mm_map+0xa8>
ffffffffc0203bcc:	002007b7          	lui	a5,0x200
ffffffffc0203bd0:	06f4e863          	bltu	s1,a5,ffffffffc0203c40 <mm_map+0xa8>
ffffffffc0203bd4:	f04a                	sd	s2,32(sp)
ffffffffc0203bd6:	ec4e                	sd	s3,24(sp)
ffffffffc0203bd8:	e852                	sd	s4,16(sp)
ffffffffc0203bda:	892a                	mv	s2,a0
ffffffffc0203bdc:	89ba                	mv	s3,a4
ffffffffc0203bde:	8a36                	mv	s4,a3
ffffffffc0203be0:	c135                	beqz	a0,ffffffffc0203c44 <mm_map+0xac>
ffffffffc0203be2:	85a6                	mv	a1,s1
ffffffffc0203be4:	e55ff0ef          	jal	ffffffffc0203a38 <find_vma>
ffffffffc0203be8:	c501                	beqz	a0,ffffffffc0203bf0 <mm_map+0x58>
ffffffffc0203bea:	651c                	ld	a5,8(a0)
ffffffffc0203bec:	0487e763          	bltu	a5,s0,ffffffffc0203c3a <mm_map+0xa2>
ffffffffc0203bf0:	03000513          	li	a0,48
ffffffffc0203bf4:	be0fe0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0203bf8:	85aa                	mv	a1,a0
ffffffffc0203bfa:	5571                	li	a0,-4
ffffffffc0203bfc:	c59d                	beqz	a1,ffffffffc0203c2a <mm_map+0x92>
ffffffffc0203bfe:	e584                	sd	s1,8(a1)
ffffffffc0203c00:	e980                	sd	s0,16(a1)
ffffffffc0203c02:	0145ac23          	sw	s4,24(a1)
ffffffffc0203c06:	854a                	mv	a0,s2
ffffffffc0203c08:	e42e                	sd	a1,8(sp)
ffffffffc0203c0a:	e6fff0ef          	jal	ffffffffc0203a78 <insert_vma_struct>
ffffffffc0203c0e:	65a2                	ld	a1,8(sp)
ffffffffc0203c10:	00098463          	beqz	s3,ffffffffc0203c18 <mm_map+0x80>
ffffffffc0203c14:	00b9b023          	sd	a1,0(s3)
ffffffffc0203c18:	7902                	ld	s2,32(sp)
ffffffffc0203c1a:	69e2                	ld	s3,24(sp)
ffffffffc0203c1c:	6a42                	ld	s4,16(sp)
ffffffffc0203c1e:	4501                	li	a0,0
ffffffffc0203c20:	70e2                	ld	ra,56(sp)
ffffffffc0203c22:	7442                	ld	s0,48(sp)
ffffffffc0203c24:	74a2                	ld	s1,40(sp)
ffffffffc0203c26:	6121                	addi	sp,sp,64
ffffffffc0203c28:	8082                	ret
ffffffffc0203c2a:	70e2                	ld	ra,56(sp)
ffffffffc0203c2c:	7442                	ld	s0,48(sp)
ffffffffc0203c2e:	7902                	ld	s2,32(sp)
ffffffffc0203c30:	69e2                	ld	s3,24(sp)
ffffffffc0203c32:	6a42                	ld	s4,16(sp)
ffffffffc0203c34:	74a2                	ld	s1,40(sp)
ffffffffc0203c36:	6121                	addi	sp,sp,64
ffffffffc0203c38:	8082                	ret
ffffffffc0203c3a:	7902                	ld	s2,32(sp)
ffffffffc0203c3c:	69e2                	ld	s3,24(sp)
ffffffffc0203c3e:	6a42                	ld	s4,16(sp)
ffffffffc0203c40:	5575                	li	a0,-3
ffffffffc0203c42:	bff9                	j	ffffffffc0203c20 <mm_map+0x88>
ffffffffc0203c44:	00009697          	auipc	a3,0x9
ffffffffc0203c48:	e6c68693          	addi	a3,a3,-404 # ffffffffc020cab0 <etext+0x16ae>
ffffffffc0203c4c:	00008617          	auipc	a2,0x8
ffffffffc0203c50:	bf460613          	addi	a2,a2,-1036 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203c54:	0b300593          	li	a1,179
ffffffffc0203c58:	00009517          	auipc	a0,0x9
ffffffffc0203c5c:	dd050513          	addi	a0,a0,-560 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0203c60:	feafc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203c64 <dup_mmap>:
ffffffffc0203c64:	7139                	addi	sp,sp,-64
ffffffffc0203c66:	fc06                	sd	ra,56(sp)
ffffffffc0203c68:	f822                	sd	s0,48(sp)
ffffffffc0203c6a:	f426                	sd	s1,40(sp)
ffffffffc0203c6c:	f04a                	sd	s2,32(sp)
ffffffffc0203c6e:	ec4e                	sd	s3,24(sp)
ffffffffc0203c70:	e852                	sd	s4,16(sp)
ffffffffc0203c72:	e456                	sd	s5,8(sp)
ffffffffc0203c74:	c525                	beqz	a0,ffffffffc0203cdc <dup_mmap+0x78>
ffffffffc0203c76:	892a                	mv	s2,a0
ffffffffc0203c78:	84ae                	mv	s1,a1
ffffffffc0203c7a:	842e                	mv	s0,a1
ffffffffc0203c7c:	c1a5                	beqz	a1,ffffffffc0203cdc <dup_mmap+0x78>
ffffffffc0203c7e:	6000                	ld	s0,0(s0)
ffffffffc0203c80:	04848c63          	beq	s1,s0,ffffffffc0203cd8 <dup_mmap+0x74>
ffffffffc0203c84:	03000513          	li	a0,48
ffffffffc0203c88:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203c8c:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203c90:	ff842983          	lw	s3,-8(s0)
ffffffffc0203c94:	b40fe0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0203c98:	c515                	beqz	a0,ffffffffc0203cc4 <dup_mmap+0x60>
ffffffffc0203c9a:	85aa                	mv	a1,a0
ffffffffc0203c9c:	01553423          	sd	s5,8(a0)
ffffffffc0203ca0:	01453823          	sd	s4,16(a0)
ffffffffc0203ca4:	01352c23          	sw	s3,24(a0)
ffffffffc0203ca8:	854a                	mv	a0,s2
ffffffffc0203caa:	dcfff0ef          	jal	ffffffffc0203a78 <insert_vma_struct>
ffffffffc0203cae:	ff043683          	ld	a3,-16(s0)
ffffffffc0203cb2:	fe843603          	ld	a2,-24(s0)
ffffffffc0203cb6:	6c8c                	ld	a1,24(s1)
ffffffffc0203cb8:	01893503          	ld	a0,24(s2)
ffffffffc0203cbc:	4701                	li	a4,0
ffffffffc0203cbe:	9f9ff0ef          	jal	ffffffffc02036b6 <copy_range>
ffffffffc0203cc2:	dd55                	beqz	a0,ffffffffc0203c7e <dup_mmap+0x1a>
ffffffffc0203cc4:	5571                	li	a0,-4
ffffffffc0203cc6:	70e2                	ld	ra,56(sp)
ffffffffc0203cc8:	7442                	ld	s0,48(sp)
ffffffffc0203cca:	74a2                	ld	s1,40(sp)
ffffffffc0203ccc:	7902                	ld	s2,32(sp)
ffffffffc0203cce:	69e2                	ld	s3,24(sp)
ffffffffc0203cd0:	6a42                	ld	s4,16(sp)
ffffffffc0203cd2:	6aa2                	ld	s5,8(sp)
ffffffffc0203cd4:	6121                	addi	sp,sp,64
ffffffffc0203cd6:	8082                	ret
ffffffffc0203cd8:	4501                	li	a0,0
ffffffffc0203cda:	b7f5                	j	ffffffffc0203cc6 <dup_mmap+0x62>
ffffffffc0203cdc:	00009697          	auipc	a3,0x9
ffffffffc0203ce0:	de468693          	addi	a3,a3,-540 # ffffffffc020cac0 <etext+0x16be>
ffffffffc0203ce4:	00008617          	auipc	a2,0x8
ffffffffc0203ce8:	b5c60613          	addi	a2,a2,-1188 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203cec:	0cf00593          	li	a1,207
ffffffffc0203cf0:	00009517          	auipc	a0,0x9
ffffffffc0203cf4:	d3850513          	addi	a0,a0,-712 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0203cf8:	f52fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203cfc <exit_mmap>:
ffffffffc0203cfc:	1101                	addi	sp,sp,-32
ffffffffc0203cfe:	ec06                	sd	ra,24(sp)
ffffffffc0203d00:	e822                	sd	s0,16(sp)
ffffffffc0203d02:	e426                	sd	s1,8(sp)
ffffffffc0203d04:	e04a                	sd	s2,0(sp)
ffffffffc0203d06:	c531                	beqz	a0,ffffffffc0203d52 <exit_mmap+0x56>
ffffffffc0203d08:	591c                	lw	a5,48(a0)
ffffffffc0203d0a:	84aa                	mv	s1,a0
ffffffffc0203d0c:	e3b9                	bnez	a5,ffffffffc0203d52 <exit_mmap+0x56>
ffffffffc0203d0e:	6500                	ld	s0,8(a0)
ffffffffc0203d10:	01853903          	ld	s2,24(a0)
ffffffffc0203d14:	02850663          	beq	a0,s0,ffffffffc0203d40 <exit_mmap+0x44>
ffffffffc0203d18:	ff043603          	ld	a2,-16(s0)
ffffffffc0203d1c:	fe843583          	ld	a1,-24(s0)
ffffffffc0203d20:	854a                	mv	a0,s2
ffffffffc0203d22:	fd0fe0ef          	jal	ffffffffc02024f2 <unmap_range>
ffffffffc0203d26:	6400                	ld	s0,8(s0)
ffffffffc0203d28:	fe8498e3          	bne	s1,s0,ffffffffc0203d18 <exit_mmap+0x1c>
ffffffffc0203d2c:	6400                	ld	s0,8(s0)
ffffffffc0203d2e:	00848c63          	beq	s1,s0,ffffffffc0203d46 <exit_mmap+0x4a>
ffffffffc0203d32:	ff043603          	ld	a2,-16(s0)
ffffffffc0203d36:	fe843583          	ld	a1,-24(s0)
ffffffffc0203d3a:	854a                	mv	a0,s2
ffffffffc0203d3c:	8ebfe0ef          	jal	ffffffffc0202626 <exit_range>
ffffffffc0203d40:	6400                	ld	s0,8(s0)
ffffffffc0203d42:	fe8498e3          	bne	s1,s0,ffffffffc0203d32 <exit_mmap+0x36>
ffffffffc0203d46:	60e2                	ld	ra,24(sp)
ffffffffc0203d48:	6442                	ld	s0,16(sp)
ffffffffc0203d4a:	64a2                	ld	s1,8(sp)
ffffffffc0203d4c:	6902                	ld	s2,0(sp)
ffffffffc0203d4e:	6105                	addi	sp,sp,32
ffffffffc0203d50:	8082                	ret
ffffffffc0203d52:	00009697          	auipc	a3,0x9
ffffffffc0203d56:	d8e68693          	addi	a3,a3,-626 # ffffffffc020cae0 <etext+0x16de>
ffffffffc0203d5a:	00008617          	auipc	a2,0x8
ffffffffc0203d5e:	ae660613          	addi	a2,a2,-1306 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203d62:	0e800593          	li	a1,232
ffffffffc0203d66:	00009517          	auipc	a0,0x9
ffffffffc0203d6a:	cc250513          	addi	a0,a0,-830 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0203d6e:	edcfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203d72 <vmm_init>:
ffffffffc0203d72:	7179                	addi	sp,sp,-48
ffffffffc0203d74:	05800513          	li	a0,88
ffffffffc0203d78:	f406                	sd	ra,40(sp)
ffffffffc0203d7a:	f022                	sd	s0,32(sp)
ffffffffc0203d7c:	ec26                	sd	s1,24(sp)
ffffffffc0203d7e:	e84a                	sd	s2,16(sp)
ffffffffc0203d80:	e44e                	sd	s3,8(sp)
ffffffffc0203d82:	e052                	sd	s4,0(sp)
ffffffffc0203d84:	a50fe0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0203d88:	16050f63          	beqz	a0,ffffffffc0203f06 <vmm_init+0x194>
ffffffffc0203d8c:	e508                	sd	a0,8(a0)
ffffffffc0203d8e:	e108                	sd	a0,0(a0)
ffffffffc0203d90:	00053823          	sd	zero,16(a0)
ffffffffc0203d94:	00053c23          	sd	zero,24(a0)
ffffffffc0203d98:	02052023          	sw	zero,32(a0)
ffffffffc0203d9c:	02053423          	sd	zero,40(a0)
ffffffffc0203da0:	02052823          	sw	zero,48(a0)
ffffffffc0203da4:	842a                	mv	s0,a0
ffffffffc0203da6:	4585                	li	a1,1
ffffffffc0203da8:	03850513          	addi	a0,a0,56
ffffffffc0203dac:	5e6000ef          	jal	ffffffffc0204392 <sem_init>
ffffffffc0203db0:	03200493          	li	s1,50
ffffffffc0203db4:	03000513          	li	a0,48
ffffffffc0203db8:	a1cfe0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0203dbc:	12050563          	beqz	a0,ffffffffc0203ee6 <vmm_init+0x174>
ffffffffc0203dc0:	00248793          	addi	a5,s1,2
ffffffffc0203dc4:	e504                	sd	s1,8(a0)
ffffffffc0203dc6:	00052c23          	sw	zero,24(a0)
ffffffffc0203dca:	e91c                	sd	a5,16(a0)
ffffffffc0203dcc:	85aa                	mv	a1,a0
ffffffffc0203dce:	14ed                	addi	s1,s1,-5
ffffffffc0203dd0:	8522                	mv	a0,s0
ffffffffc0203dd2:	ca7ff0ef          	jal	ffffffffc0203a78 <insert_vma_struct>
ffffffffc0203dd6:	fcf9                	bnez	s1,ffffffffc0203db4 <vmm_init+0x42>
ffffffffc0203dd8:	03700493          	li	s1,55
ffffffffc0203ddc:	1f900913          	li	s2,505
ffffffffc0203de0:	03000513          	li	a0,48
ffffffffc0203de4:	9f0fe0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0203de8:	12050f63          	beqz	a0,ffffffffc0203f26 <vmm_init+0x1b4>
ffffffffc0203dec:	00248793          	addi	a5,s1,2
ffffffffc0203df0:	e504                	sd	s1,8(a0)
ffffffffc0203df2:	00052c23          	sw	zero,24(a0)
ffffffffc0203df6:	e91c                	sd	a5,16(a0)
ffffffffc0203df8:	85aa                	mv	a1,a0
ffffffffc0203dfa:	0495                	addi	s1,s1,5
ffffffffc0203dfc:	8522                	mv	a0,s0
ffffffffc0203dfe:	c7bff0ef          	jal	ffffffffc0203a78 <insert_vma_struct>
ffffffffc0203e02:	fd249fe3          	bne	s1,s2,ffffffffc0203de0 <vmm_init+0x6e>
ffffffffc0203e06:	641c                	ld	a5,8(s0)
ffffffffc0203e08:	471d                	li	a4,7
ffffffffc0203e0a:	1fb00593          	li	a1,507
ffffffffc0203e0e:	1ef40c63          	beq	s0,a5,ffffffffc0204006 <vmm_init+0x294>
ffffffffc0203e12:	fe87b603          	ld	a2,-24(a5) # 1fffe8 <_binary_bin_sfs_img_size+0x18ace8>
ffffffffc0203e16:	ffe70693          	addi	a3,a4,-2
ffffffffc0203e1a:	12d61663          	bne	a2,a3,ffffffffc0203f46 <vmm_init+0x1d4>
ffffffffc0203e1e:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203e22:	12e69263          	bne	a3,a4,ffffffffc0203f46 <vmm_init+0x1d4>
ffffffffc0203e26:	0715                	addi	a4,a4,5
ffffffffc0203e28:	679c                	ld	a5,8(a5)
ffffffffc0203e2a:	feb712e3          	bne	a4,a1,ffffffffc0203e0e <vmm_init+0x9c>
ffffffffc0203e2e:	491d                	li	s2,7
ffffffffc0203e30:	4495                	li	s1,5
ffffffffc0203e32:	85a6                	mv	a1,s1
ffffffffc0203e34:	8522                	mv	a0,s0
ffffffffc0203e36:	c03ff0ef          	jal	ffffffffc0203a38 <find_vma>
ffffffffc0203e3a:	8a2a                	mv	s4,a0
ffffffffc0203e3c:	20050563          	beqz	a0,ffffffffc0204046 <vmm_init+0x2d4>
ffffffffc0203e40:	00148593          	addi	a1,s1,1
ffffffffc0203e44:	8522                	mv	a0,s0
ffffffffc0203e46:	bf3ff0ef          	jal	ffffffffc0203a38 <find_vma>
ffffffffc0203e4a:	89aa                	mv	s3,a0
ffffffffc0203e4c:	1c050d63          	beqz	a0,ffffffffc0204026 <vmm_init+0x2b4>
ffffffffc0203e50:	85ca                	mv	a1,s2
ffffffffc0203e52:	8522                	mv	a0,s0
ffffffffc0203e54:	be5ff0ef          	jal	ffffffffc0203a38 <find_vma>
ffffffffc0203e58:	18051763          	bnez	a0,ffffffffc0203fe6 <vmm_init+0x274>
ffffffffc0203e5c:	00348593          	addi	a1,s1,3
ffffffffc0203e60:	8522                	mv	a0,s0
ffffffffc0203e62:	bd7ff0ef          	jal	ffffffffc0203a38 <find_vma>
ffffffffc0203e66:	16051063          	bnez	a0,ffffffffc0203fc6 <vmm_init+0x254>
ffffffffc0203e6a:	00448593          	addi	a1,s1,4
ffffffffc0203e6e:	8522                	mv	a0,s0
ffffffffc0203e70:	bc9ff0ef          	jal	ffffffffc0203a38 <find_vma>
ffffffffc0203e74:	12051963          	bnez	a0,ffffffffc0203fa6 <vmm_init+0x234>
ffffffffc0203e78:	008a3783          	ld	a5,8(s4)
ffffffffc0203e7c:	10979563          	bne	a5,s1,ffffffffc0203f86 <vmm_init+0x214>
ffffffffc0203e80:	010a3783          	ld	a5,16(s4)
ffffffffc0203e84:	11279163          	bne	a5,s2,ffffffffc0203f86 <vmm_init+0x214>
ffffffffc0203e88:	0089b783          	ld	a5,8(s3)
ffffffffc0203e8c:	0c979d63          	bne	a5,s1,ffffffffc0203f66 <vmm_init+0x1f4>
ffffffffc0203e90:	0109b783          	ld	a5,16(s3)
ffffffffc0203e94:	0d279963          	bne	a5,s2,ffffffffc0203f66 <vmm_init+0x1f4>
ffffffffc0203e98:	0495                	addi	s1,s1,5
ffffffffc0203e9a:	1f900793          	li	a5,505
ffffffffc0203e9e:	0915                	addi	s2,s2,5
ffffffffc0203ea0:	f8f499e3          	bne	s1,a5,ffffffffc0203e32 <vmm_init+0xc0>
ffffffffc0203ea4:	4491                	li	s1,4
ffffffffc0203ea6:	597d                	li	s2,-1
ffffffffc0203ea8:	85a6                	mv	a1,s1
ffffffffc0203eaa:	8522                	mv	a0,s0
ffffffffc0203eac:	b8dff0ef          	jal	ffffffffc0203a38 <find_vma>
ffffffffc0203eb0:	1a051b63          	bnez	a0,ffffffffc0204066 <vmm_init+0x2f4>
ffffffffc0203eb4:	14fd                	addi	s1,s1,-1
ffffffffc0203eb6:	ff2499e3          	bne	s1,s2,ffffffffc0203ea8 <vmm_init+0x136>
ffffffffc0203eba:	8522                	mv	a0,s0
ffffffffc0203ebc:	c8bff0ef          	jal	ffffffffc0203b46 <mm_destroy>
ffffffffc0203ec0:	00009517          	auipc	a0,0x9
ffffffffc0203ec4:	d9050513          	addi	a0,a0,-624 # ffffffffc020cc50 <etext+0x184e>
ffffffffc0203ec8:	adefc0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0203ecc:	7402                	ld	s0,32(sp)
ffffffffc0203ece:	70a2                	ld	ra,40(sp)
ffffffffc0203ed0:	64e2                	ld	s1,24(sp)
ffffffffc0203ed2:	6942                	ld	s2,16(sp)
ffffffffc0203ed4:	69a2                	ld	s3,8(sp)
ffffffffc0203ed6:	6a02                	ld	s4,0(sp)
ffffffffc0203ed8:	00009517          	auipc	a0,0x9
ffffffffc0203edc:	d9850513          	addi	a0,a0,-616 # ffffffffc020cc70 <etext+0x186e>
ffffffffc0203ee0:	6145                	addi	sp,sp,48
ffffffffc0203ee2:	ac4fc06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0203ee6:	00009697          	auipc	a3,0x9
ffffffffc0203eea:	c1a68693          	addi	a3,a3,-998 # ffffffffc020cb00 <etext+0x16fe>
ffffffffc0203eee:	00008617          	auipc	a2,0x8
ffffffffc0203ef2:	95260613          	addi	a2,a2,-1710 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203ef6:	12c00593          	li	a1,300
ffffffffc0203efa:	00009517          	auipc	a0,0x9
ffffffffc0203efe:	b2e50513          	addi	a0,a0,-1234 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0203f02:	d48fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203f06:	00009697          	auipc	a3,0x9
ffffffffc0203f0a:	baa68693          	addi	a3,a3,-1110 # ffffffffc020cab0 <etext+0x16ae>
ffffffffc0203f0e:	00008617          	auipc	a2,0x8
ffffffffc0203f12:	93260613          	addi	a2,a2,-1742 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203f16:	12400593          	li	a1,292
ffffffffc0203f1a:	00009517          	auipc	a0,0x9
ffffffffc0203f1e:	b0e50513          	addi	a0,a0,-1266 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0203f22:	d28fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203f26:	00009697          	auipc	a3,0x9
ffffffffc0203f2a:	bda68693          	addi	a3,a3,-1062 # ffffffffc020cb00 <etext+0x16fe>
ffffffffc0203f2e:	00008617          	auipc	a2,0x8
ffffffffc0203f32:	91260613          	addi	a2,a2,-1774 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203f36:	13300593          	li	a1,307
ffffffffc0203f3a:	00009517          	auipc	a0,0x9
ffffffffc0203f3e:	aee50513          	addi	a0,a0,-1298 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0203f42:	d08fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203f46:	00009697          	auipc	a3,0x9
ffffffffc0203f4a:	be268693          	addi	a3,a3,-1054 # ffffffffc020cb28 <etext+0x1726>
ffffffffc0203f4e:	00008617          	auipc	a2,0x8
ffffffffc0203f52:	8f260613          	addi	a2,a2,-1806 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203f56:	13d00593          	li	a1,317
ffffffffc0203f5a:	00009517          	auipc	a0,0x9
ffffffffc0203f5e:	ace50513          	addi	a0,a0,-1330 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0203f62:	ce8fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203f66:	00009697          	auipc	a3,0x9
ffffffffc0203f6a:	c7a68693          	addi	a3,a3,-902 # ffffffffc020cbe0 <etext+0x17de>
ffffffffc0203f6e:	00008617          	auipc	a2,0x8
ffffffffc0203f72:	8d260613          	addi	a2,a2,-1838 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203f76:	14f00593          	li	a1,335
ffffffffc0203f7a:	00009517          	auipc	a0,0x9
ffffffffc0203f7e:	aae50513          	addi	a0,a0,-1362 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0203f82:	cc8fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203f86:	00009697          	auipc	a3,0x9
ffffffffc0203f8a:	c2a68693          	addi	a3,a3,-982 # ffffffffc020cbb0 <etext+0x17ae>
ffffffffc0203f8e:	00008617          	auipc	a2,0x8
ffffffffc0203f92:	8b260613          	addi	a2,a2,-1870 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203f96:	14e00593          	li	a1,334
ffffffffc0203f9a:	00009517          	auipc	a0,0x9
ffffffffc0203f9e:	a8e50513          	addi	a0,a0,-1394 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0203fa2:	ca8fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203fa6:	00009697          	auipc	a3,0x9
ffffffffc0203faa:	bfa68693          	addi	a3,a3,-1030 # ffffffffc020cba0 <etext+0x179e>
ffffffffc0203fae:	00008617          	auipc	a2,0x8
ffffffffc0203fb2:	89260613          	addi	a2,a2,-1902 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203fb6:	14c00593          	li	a1,332
ffffffffc0203fba:	00009517          	auipc	a0,0x9
ffffffffc0203fbe:	a6e50513          	addi	a0,a0,-1426 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0203fc2:	c88fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203fc6:	00009697          	auipc	a3,0x9
ffffffffc0203fca:	bca68693          	addi	a3,a3,-1078 # ffffffffc020cb90 <etext+0x178e>
ffffffffc0203fce:	00008617          	auipc	a2,0x8
ffffffffc0203fd2:	87260613          	addi	a2,a2,-1934 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203fd6:	14a00593          	li	a1,330
ffffffffc0203fda:	00009517          	auipc	a0,0x9
ffffffffc0203fde:	a4e50513          	addi	a0,a0,-1458 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0203fe2:	c68fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203fe6:	00009697          	auipc	a3,0x9
ffffffffc0203fea:	b9a68693          	addi	a3,a3,-1126 # ffffffffc020cb80 <etext+0x177e>
ffffffffc0203fee:	00008617          	auipc	a2,0x8
ffffffffc0203ff2:	85260613          	addi	a2,a2,-1966 # ffffffffc020b840 <etext+0x43e>
ffffffffc0203ff6:	14800593          	li	a1,328
ffffffffc0203ffa:	00009517          	auipc	a0,0x9
ffffffffc0203ffe:	a2e50513          	addi	a0,a0,-1490 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0204002:	c48fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204006:	00009697          	auipc	a3,0x9
ffffffffc020400a:	b0a68693          	addi	a3,a3,-1270 # ffffffffc020cb10 <etext+0x170e>
ffffffffc020400e:	00008617          	auipc	a2,0x8
ffffffffc0204012:	83260613          	addi	a2,a2,-1998 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204016:	13b00593          	li	a1,315
ffffffffc020401a:	00009517          	auipc	a0,0x9
ffffffffc020401e:	a0e50513          	addi	a0,a0,-1522 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0204022:	c28fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204026:	00009697          	auipc	a3,0x9
ffffffffc020402a:	b4a68693          	addi	a3,a3,-1206 # ffffffffc020cb70 <etext+0x176e>
ffffffffc020402e:	00008617          	auipc	a2,0x8
ffffffffc0204032:	81260613          	addi	a2,a2,-2030 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204036:	14600593          	li	a1,326
ffffffffc020403a:	00009517          	auipc	a0,0x9
ffffffffc020403e:	9ee50513          	addi	a0,a0,-1554 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0204042:	c08fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204046:	00009697          	auipc	a3,0x9
ffffffffc020404a:	b1a68693          	addi	a3,a3,-1254 # ffffffffc020cb60 <etext+0x175e>
ffffffffc020404e:	00007617          	auipc	a2,0x7
ffffffffc0204052:	7f260613          	addi	a2,a2,2034 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204056:	14400593          	li	a1,324
ffffffffc020405a:	00009517          	auipc	a0,0x9
ffffffffc020405e:	9ce50513          	addi	a0,a0,-1586 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0204062:	be8fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204066:	6914                	ld	a3,16(a0)
ffffffffc0204068:	6510                	ld	a2,8(a0)
ffffffffc020406a:	0004859b          	sext.w	a1,s1
ffffffffc020406e:	00009517          	auipc	a0,0x9
ffffffffc0204072:	ba250513          	addi	a0,a0,-1118 # ffffffffc020cc10 <etext+0x180e>
ffffffffc0204076:	930fc0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020407a:	00009697          	auipc	a3,0x9
ffffffffc020407e:	bbe68693          	addi	a3,a3,-1090 # ffffffffc020cc38 <etext+0x1836>
ffffffffc0204082:	00007617          	auipc	a2,0x7
ffffffffc0204086:	7be60613          	addi	a2,a2,1982 # ffffffffc020b840 <etext+0x43e>
ffffffffc020408a:	15900593          	li	a1,345
ffffffffc020408e:	00009517          	auipc	a0,0x9
ffffffffc0204092:	99a50513          	addi	a0,a0,-1638 # ffffffffc020ca28 <etext+0x1626>
ffffffffc0204096:	bb4fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020409a <user_mem_check>:
ffffffffc020409a:	7179                	addi	sp,sp,-48
ffffffffc020409c:	f022                	sd	s0,32(sp)
ffffffffc020409e:	f406                	sd	ra,40(sp)
ffffffffc02040a0:	842e                	mv	s0,a1
ffffffffc02040a2:	c52d                	beqz	a0,ffffffffc020410c <user_mem_check+0x72>
ffffffffc02040a4:	002007b7          	lui	a5,0x200
ffffffffc02040a8:	04f5ed63          	bltu	a1,a5,ffffffffc0204102 <user_mem_check+0x68>
ffffffffc02040ac:	ec26                	sd	s1,24(sp)
ffffffffc02040ae:	00c584b3          	add	s1,a1,a2
ffffffffc02040b2:	0695ff63          	bgeu	a1,s1,ffffffffc0204130 <user_mem_check+0x96>
ffffffffc02040b6:	4785                	li	a5,1
ffffffffc02040b8:	07fe                	slli	a5,a5,0x1f
ffffffffc02040ba:	0785                	addi	a5,a5,1 # 200001 <_binary_bin_sfs_img_size+0x18ad01>
ffffffffc02040bc:	06f4fa63          	bgeu	s1,a5,ffffffffc0204130 <user_mem_check+0x96>
ffffffffc02040c0:	e84a                	sd	s2,16(sp)
ffffffffc02040c2:	e44e                	sd	s3,8(sp)
ffffffffc02040c4:	8936                	mv	s2,a3
ffffffffc02040c6:	89aa                	mv	s3,a0
ffffffffc02040c8:	a829                	j	ffffffffc02040e2 <user_mem_check+0x48>
ffffffffc02040ca:	6685                	lui	a3,0x1
ffffffffc02040cc:	9736                	add	a4,a4,a3
ffffffffc02040ce:	0027f693          	andi	a3,a5,2
ffffffffc02040d2:	8ba1                	andi	a5,a5,8
ffffffffc02040d4:	c685                	beqz	a3,ffffffffc02040fc <user_mem_check+0x62>
ffffffffc02040d6:	c399                	beqz	a5,ffffffffc02040dc <user_mem_check+0x42>
ffffffffc02040d8:	02e46263          	bltu	s0,a4,ffffffffc02040fc <user_mem_check+0x62>
ffffffffc02040dc:	6900                	ld	s0,16(a0)
ffffffffc02040de:	04947b63          	bgeu	s0,s1,ffffffffc0204134 <user_mem_check+0x9a>
ffffffffc02040e2:	85a2                	mv	a1,s0
ffffffffc02040e4:	854e                	mv	a0,s3
ffffffffc02040e6:	953ff0ef          	jal	ffffffffc0203a38 <find_vma>
ffffffffc02040ea:	c909                	beqz	a0,ffffffffc02040fc <user_mem_check+0x62>
ffffffffc02040ec:	6518                	ld	a4,8(a0)
ffffffffc02040ee:	00e46763          	bltu	s0,a4,ffffffffc02040fc <user_mem_check+0x62>
ffffffffc02040f2:	4d1c                	lw	a5,24(a0)
ffffffffc02040f4:	fc091be3          	bnez	s2,ffffffffc02040ca <user_mem_check+0x30>
ffffffffc02040f8:	8b85                	andi	a5,a5,1
ffffffffc02040fa:	f3ed                	bnez	a5,ffffffffc02040dc <user_mem_check+0x42>
ffffffffc02040fc:	64e2                	ld	s1,24(sp)
ffffffffc02040fe:	6942                	ld	s2,16(sp)
ffffffffc0204100:	69a2                	ld	s3,8(sp)
ffffffffc0204102:	4501                	li	a0,0
ffffffffc0204104:	70a2                	ld	ra,40(sp)
ffffffffc0204106:	7402                	ld	s0,32(sp)
ffffffffc0204108:	6145                	addi	sp,sp,48
ffffffffc020410a:	8082                	ret
ffffffffc020410c:	c02007b7          	lui	a5,0xc0200
ffffffffc0204110:	fef5eae3          	bltu	a1,a5,ffffffffc0204104 <user_mem_check+0x6a>
ffffffffc0204114:	c80007b7          	lui	a5,0xc8000
ffffffffc0204118:	962e                	add	a2,a2,a1
ffffffffc020411a:	0785                	addi	a5,a5,1 # ffffffffc8000001 <end+0x7d696f1>
ffffffffc020411c:	00c5b433          	sltu	s0,a1,a2
ffffffffc0204120:	00f63633          	sltu	a2,a2,a5
ffffffffc0204124:	70a2                	ld	ra,40(sp)
ffffffffc0204126:	00867533          	and	a0,a2,s0
ffffffffc020412a:	7402                	ld	s0,32(sp)
ffffffffc020412c:	6145                	addi	sp,sp,48
ffffffffc020412e:	8082                	ret
ffffffffc0204130:	64e2                	ld	s1,24(sp)
ffffffffc0204132:	bfc1                	j	ffffffffc0204102 <user_mem_check+0x68>
ffffffffc0204134:	64e2                	ld	s1,24(sp)
ffffffffc0204136:	6942                	ld	s2,16(sp)
ffffffffc0204138:	69a2                	ld	s3,8(sp)
ffffffffc020413a:	4505                	li	a0,1
ffffffffc020413c:	b7e1                	j	ffffffffc0204104 <user_mem_check+0x6a>

ffffffffc020413e <copy_from_user>:
ffffffffc020413e:	7179                	addi	sp,sp,-48
ffffffffc0204140:	f022                	sd	s0,32(sp)
ffffffffc0204142:	8432                	mv	s0,a2
ffffffffc0204144:	ec26                	sd	s1,24(sp)
ffffffffc0204146:	8636                	mv	a2,a3
ffffffffc0204148:	84ae                	mv	s1,a1
ffffffffc020414a:	86ba                	mv	a3,a4
ffffffffc020414c:	85a2                	mv	a1,s0
ffffffffc020414e:	f406                	sd	ra,40(sp)
ffffffffc0204150:	e032                	sd	a2,0(sp)
ffffffffc0204152:	f49ff0ef          	jal	ffffffffc020409a <user_mem_check>
ffffffffc0204156:	87aa                	mv	a5,a0
ffffffffc0204158:	c901                	beqz	a0,ffffffffc0204168 <copy_from_user+0x2a>
ffffffffc020415a:	6602                	ld	a2,0(sp)
ffffffffc020415c:	e42a                	sd	a0,8(sp)
ffffffffc020415e:	85a2                	mv	a1,s0
ffffffffc0204160:	8526                	mv	a0,s1
ffffffffc0204162:	288070ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc0204166:	67a2                	ld	a5,8(sp)
ffffffffc0204168:	70a2                	ld	ra,40(sp)
ffffffffc020416a:	7402                	ld	s0,32(sp)
ffffffffc020416c:	64e2                	ld	s1,24(sp)
ffffffffc020416e:	853e                	mv	a0,a5
ffffffffc0204170:	6145                	addi	sp,sp,48
ffffffffc0204172:	8082                	ret

ffffffffc0204174 <copy_to_user>:
ffffffffc0204174:	7179                	addi	sp,sp,-48
ffffffffc0204176:	f022                	sd	s0,32(sp)
ffffffffc0204178:	8436                	mv	s0,a3
ffffffffc020417a:	e84a                	sd	s2,16(sp)
ffffffffc020417c:	4685                	li	a3,1
ffffffffc020417e:	8932                	mv	s2,a2
ffffffffc0204180:	8622                	mv	a2,s0
ffffffffc0204182:	ec26                	sd	s1,24(sp)
ffffffffc0204184:	f406                	sd	ra,40(sp)
ffffffffc0204186:	84ae                	mv	s1,a1
ffffffffc0204188:	f13ff0ef          	jal	ffffffffc020409a <user_mem_check>
ffffffffc020418c:	87aa                	mv	a5,a0
ffffffffc020418e:	c901                	beqz	a0,ffffffffc020419e <copy_to_user+0x2a>
ffffffffc0204190:	e42a                	sd	a0,8(sp)
ffffffffc0204192:	8622                	mv	a2,s0
ffffffffc0204194:	85ca                	mv	a1,s2
ffffffffc0204196:	8526                	mv	a0,s1
ffffffffc0204198:	252070ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc020419c:	67a2                	ld	a5,8(sp)
ffffffffc020419e:	70a2                	ld	ra,40(sp)
ffffffffc02041a0:	7402                	ld	s0,32(sp)
ffffffffc02041a2:	64e2                	ld	s1,24(sp)
ffffffffc02041a4:	6942                	ld	s2,16(sp)
ffffffffc02041a6:	853e                	mv	a0,a5
ffffffffc02041a8:	6145                	addi	sp,sp,48
ffffffffc02041aa:	8082                	ret

ffffffffc02041ac <copy_string>:
ffffffffc02041ac:	6785                	lui	a5,0x1
ffffffffc02041ae:	97b2                	add	a5,a5,a2
ffffffffc02041b0:	777d                	lui	a4,0xfffff
ffffffffc02041b2:	7139                	addi	sp,sp,-64
ffffffffc02041b4:	8ff9                	and	a5,a5,a4
ffffffffc02041b6:	f822                	sd	s0,48(sp)
ffffffffc02041b8:	f426                	sd	s1,40(sp)
ffffffffc02041ba:	ec4e                	sd	s3,24(sp)
ffffffffc02041bc:	e456                	sd	s5,8(sp)
ffffffffc02041be:	e05a                	sd	s6,0(sp)
ffffffffc02041c0:	fc06                	sd	ra,56(sp)
ffffffffc02041c2:	f04a                	sd	s2,32(sp)
ffffffffc02041c4:	e852                	sd	s4,16(sp)
ffffffffc02041c6:	40c78433          	sub	s0,a5,a2
ffffffffc02041ca:	84b2                	mv	s1,a2
ffffffffc02041cc:	89b6                	mv	s3,a3
ffffffffc02041ce:	8aae                	mv	s5,a1
ffffffffc02041d0:	8b2a                	mv	s6,a0
ffffffffc02041d2:	0086f363          	bgeu	a3,s0,ffffffffc02041d8 <copy_string+0x2c>
ffffffffc02041d6:	8436                	mv	s0,a3
ffffffffc02041d8:	4901                	li	s2,0
ffffffffc02041da:	e82d                	bnez	s0,ffffffffc020424c <copy_string+0xa0>
ffffffffc02041dc:	4681                	li	a3,0
ffffffffc02041de:	8622                	mv	a2,s0
ffffffffc02041e0:	85a6                	mv	a1,s1
ffffffffc02041e2:	855a                	mv	a0,s6
ffffffffc02041e4:	eb7ff0ef          	jal	ffffffffc020409a <user_mem_check>
ffffffffc02041e8:	8a2a                	mv	s4,a0
ffffffffc02041ea:	c529                	beqz	a0,ffffffffc0204234 <copy_string+0x88>
ffffffffc02041ec:	8556                	mv	a0,s5
ffffffffc02041ee:	8622                	mv	a2,s0
ffffffffc02041f0:	85a6                	mv	a1,s1
ffffffffc02041f2:	1f8070ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc02041f6:	9aa2                	add	s5,s5,s0
ffffffffc02041f8:	05246c63          	bltu	s0,s2,ffffffffc0204250 <copy_string+0xa4>
ffffffffc02041fc:	03340c63          	beq	s0,s3,ffffffffc0204234 <copy_string+0x88>
ffffffffc0204200:	408989b3          	sub	s3,s3,s0
ffffffffc0204204:	6785                	lui	a5,0x1
ffffffffc0204206:	94a2                	add	s1,s1,s0
ffffffffc0204208:	894e                	mv	s2,s3
ffffffffc020420a:	0137f363          	bgeu	a5,s3,ffffffffc0204210 <copy_string+0x64>
ffffffffc020420e:	893e                	mv	s2,a5
ffffffffc0204210:	4401                	li	s0,0
ffffffffc0204212:	a021                	j	ffffffffc020421a <copy_string+0x6e>
ffffffffc0204214:	0405                	addi	s0,s0,1
ffffffffc0204216:	fd2403e3          	beq	s0,s2,ffffffffc02041dc <copy_string+0x30>
ffffffffc020421a:	008487b3          	add	a5,s1,s0
ffffffffc020421e:	0007c783          	lbu	a5,0(a5) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0204222:	fbed                	bnez	a5,ffffffffc0204214 <copy_string+0x68>
ffffffffc0204224:	4681                	li	a3,0
ffffffffc0204226:	8622                	mv	a2,s0
ffffffffc0204228:	85a6                	mv	a1,s1
ffffffffc020422a:	855a                	mv	a0,s6
ffffffffc020422c:	e6fff0ef          	jal	ffffffffc020409a <user_mem_check>
ffffffffc0204230:	8a2a                	mv	s4,a0
ffffffffc0204232:	fd4d                	bnez	a0,ffffffffc02041ec <copy_string+0x40>
ffffffffc0204234:	4a01                	li	s4,0
ffffffffc0204236:	70e2                	ld	ra,56(sp)
ffffffffc0204238:	7442                	ld	s0,48(sp)
ffffffffc020423a:	74a2                	ld	s1,40(sp)
ffffffffc020423c:	7902                	ld	s2,32(sp)
ffffffffc020423e:	69e2                	ld	s3,24(sp)
ffffffffc0204240:	6aa2                	ld	s5,8(sp)
ffffffffc0204242:	6b02                	ld	s6,0(sp)
ffffffffc0204244:	8552                	mv	a0,s4
ffffffffc0204246:	6a42                	ld	s4,16(sp)
ffffffffc0204248:	6121                	addi	sp,sp,64
ffffffffc020424a:	8082                	ret
ffffffffc020424c:	8922                	mv	s2,s0
ffffffffc020424e:	b7c9                	j	ffffffffc0204210 <copy_string+0x64>
ffffffffc0204250:	ff3402e3          	beq	s0,s3,ffffffffc0204234 <copy_string+0x88>
ffffffffc0204254:	000a8023          	sb	zero,0(s5) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0204258:	bff9                	j	ffffffffc0204236 <copy_string+0x8a>

ffffffffc020425a <__down.constprop.0>:
ffffffffc020425a:	711d                	addi	sp,sp,-96
ffffffffc020425c:	ec86                	sd	ra,88(sp)
ffffffffc020425e:	100027f3          	csrr	a5,sstatus
ffffffffc0204262:	8b89                	andi	a5,a5,2
ffffffffc0204264:	eba1                	bnez	a5,ffffffffc02042b4 <__down.constprop.0+0x5a>
ffffffffc0204266:	411c                	lw	a5,0(a0)
ffffffffc0204268:	00f05863          	blez	a5,ffffffffc0204278 <__down.constprop.0+0x1e>
ffffffffc020426c:	37fd                	addiw	a5,a5,-1
ffffffffc020426e:	c11c                	sw	a5,0(a0)
ffffffffc0204270:	60e6                	ld	ra,88(sp)
ffffffffc0204272:	4501                	li	a0,0
ffffffffc0204274:	6125                	addi	sp,sp,96
ffffffffc0204276:	8082                	ret
ffffffffc0204278:	0521                	addi	a0,a0,8
ffffffffc020427a:	082c                	addi	a1,sp,24
ffffffffc020427c:	10000613          	li	a2,256
ffffffffc0204280:	e8a2                	sd	s0,80(sp)
ffffffffc0204282:	e4a6                	sd	s1,72(sp)
ffffffffc0204284:	0820                	addi	s0,sp,24
ffffffffc0204286:	84aa                	mv	s1,a0
ffffffffc0204288:	2d0000ef          	jal	ffffffffc0204558 <wait_current_set>
ffffffffc020428c:	7d3020ef          	jal	ffffffffc020725e <schedule>
ffffffffc0204290:	100027f3          	csrr	a5,sstatus
ffffffffc0204294:	8b89                	andi	a5,a5,2
ffffffffc0204296:	efa9                	bnez	a5,ffffffffc02042f0 <__down.constprop.0+0x96>
ffffffffc0204298:	8522                	mv	a0,s0
ffffffffc020429a:	192000ef          	jal	ffffffffc020442c <wait_in_queue>
ffffffffc020429e:	e521                	bnez	a0,ffffffffc02042e6 <__down.constprop.0+0x8c>
ffffffffc02042a0:	5502                	lw	a0,32(sp)
ffffffffc02042a2:	10000793          	li	a5,256
ffffffffc02042a6:	6446                	ld	s0,80(sp)
ffffffffc02042a8:	64a6                	ld	s1,72(sp)
ffffffffc02042aa:	fcf503e3          	beq	a0,a5,ffffffffc0204270 <__down.constprop.0+0x16>
ffffffffc02042ae:	60e6                	ld	ra,88(sp)
ffffffffc02042b0:	6125                	addi	sp,sp,96
ffffffffc02042b2:	8082                	ret
ffffffffc02042b4:	e42a                	sd	a0,8(sp)
ffffffffc02042b6:	947fc0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc02042ba:	6522                	ld	a0,8(sp)
ffffffffc02042bc:	411c                	lw	a5,0(a0)
ffffffffc02042be:	00f05763          	blez	a5,ffffffffc02042cc <__down.constprop.0+0x72>
ffffffffc02042c2:	37fd                	addiw	a5,a5,-1
ffffffffc02042c4:	c11c                	sw	a5,0(a0)
ffffffffc02042c6:	931fc0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc02042ca:	b75d                	j	ffffffffc0204270 <__down.constprop.0+0x16>
ffffffffc02042cc:	0521                	addi	a0,a0,8
ffffffffc02042ce:	082c                	addi	a1,sp,24
ffffffffc02042d0:	10000613          	li	a2,256
ffffffffc02042d4:	e8a2                	sd	s0,80(sp)
ffffffffc02042d6:	e4a6                	sd	s1,72(sp)
ffffffffc02042d8:	0820                	addi	s0,sp,24
ffffffffc02042da:	84aa                	mv	s1,a0
ffffffffc02042dc:	27c000ef          	jal	ffffffffc0204558 <wait_current_set>
ffffffffc02042e0:	917fc0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc02042e4:	b765                	j	ffffffffc020428c <__down.constprop.0+0x32>
ffffffffc02042e6:	85a2                	mv	a1,s0
ffffffffc02042e8:	8526                	mv	a0,s1
ffffffffc02042ea:	0e8000ef          	jal	ffffffffc02043d2 <wait_queue_del>
ffffffffc02042ee:	bf4d                	j	ffffffffc02042a0 <__down.constprop.0+0x46>
ffffffffc02042f0:	90dfc0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc02042f4:	8522                	mv	a0,s0
ffffffffc02042f6:	136000ef          	jal	ffffffffc020442c <wait_in_queue>
ffffffffc02042fa:	e501                	bnez	a0,ffffffffc0204302 <__down.constprop.0+0xa8>
ffffffffc02042fc:	8fbfc0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc0204300:	b745                	j	ffffffffc02042a0 <__down.constprop.0+0x46>
ffffffffc0204302:	85a2                	mv	a1,s0
ffffffffc0204304:	8526                	mv	a0,s1
ffffffffc0204306:	0cc000ef          	jal	ffffffffc02043d2 <wait_queue_del>
ffffffffc020430a:	bfcd                	j	ffffffffc02042fc <__down.constprop.0+0xa2>

ffffffffc020430c <__up.constprop.0>:
ffffffffc020430c:	1101                	addi	sp,sp,-32
ffffffffc020430e:	e426                	sd	s1,8(sp)
ffffffffc0204310:	ec06                	sd	ra,24(sp)
ffffffffc0204312:	e822                	sd	s0,16(sp)
ffffffffc0204314:	e04a                	sd	s2,0(sp)
ffffffffc0204316:	84aa                	mv	s1,a0
ffffffffc0204318:	100027f3          	csrr	a5,sstatus
ffffffffc020431c:	8b89                	andi	a5,a5,2
ffffffffc020431e:	4901                	li	s2,0
ffffffffc0204320:	e7b1                	bnez	a5,ffffffffc020436c <__up.constprop.0+0x60>
ffffffffc0204322:	00848413          	addi	s0,s1,8
ffffffffc0204326:	8522                	mv	a0,s0
ffffffffc0204328:	0e8000ef          	jal	ffffffffc0204410 <wait_queue_first>
ffffffffc020432c:	cd05                	beqz	a0,ffffffffc0204364 <__up.constprop.0+0x58>
ffffffffc020432e:	6118                	ld	a4,0(a0)
ffffffffc0204330:	10000793          	li	a5,256
ffffffffc0204334:	0ec72603          	lw	a2,236(a4) # fffffffffffff0ec <end+0x3fd687dc>
ffffffffc0204338:	02f61e63          	bne	a2,a5,ffffffffc0204374 <__up.constprop.0+0x68>
ffffffffc020433c:	85aa                	mv	a1,a0
ffffffffc020433e:	4685                	li	a3,1
ffffffffc0204340:	8522                	mv	a0,s0
ffffffffc0204342:	0f8000ef          	jal	ffffffffc020443a <wakeup_wait>
ffffffffc0204346:	00091863          	bnez	s2,ffffffffc0204356 <__up.constprop.0+0x4a>
ffffffffc020434a:	60e2                	ld	ra,24(sp)
ffffffffc020434c:	6442                	ld	s0,16(sp)
ffffffffc020434e:	64a2                	ld	s1,8(sp)
ffffffffc0204350:	6902                	ld	s2,0(sp)
ffffffffc0204352:	6105                	addi	sp,sp,32
ffffffffc0204354:	8082                	ret
ffffffffc0204356:	6442                	ld	s0,16(sp)
ffffffffc0204358:	60e2                	ld	ra,24(sp)
ffffffffc020435a:	64a2                	ld	s1,8(sp)
ffffffffc020435c:	6902                	ld	s2,0(sp)
ffffffffc020435e:	6105                	addi	sp,sp,32
ffffffffc0204360:	897fc06f          	j	ffffffffc0200bf6 <intr_enable>
ffffffffc0204364:	409c                	lw	a5,0(s1)
ffffffffc0204366:	2785                	addiw	a5,a5,1
ffffffffc0204368:	c09c                	sw	a5,0(s1)
ffffffffc020436a:	bff1                	j	ffffffffc0204346 <__up.constprop.0+0x3a>
ffffffffc020436c:	891fc0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0204370:	4905                	li	s2,1
ffffffffc0204372:	bf45                	j	ffffffffc0204322 <__up.constprop.0+0x16>
ffffffffc0204374:	00009697          	auipc	a3,0x9
ffffffffc0204378:	91468693          	addi	a3,a3,-1772 # ffffffffc020cc88 <etext+0x1886>
ffffffffc020437c:	00007617          	auipc	a2,0x7
ffffffffc0204380:	4c460613          	addi	a2,a2,1220 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204384:	45e5                	li	a1,25
ffffffffc0204386:	00009517          	auipc	a0,0x9
ffffffffc020438a:	92a50513          	addi	a0,a0,-1750 # ffffffffc020ccb0 <etext+0x18ae>
ffffffffc020438e:	8bcfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204392 <sem_init>:
ffffffffc0204392:	c10c                	sw	a1,0(a0)
ffffffffc0204394:	0521                	addi	a0,a0,8
ffffffffc0204396:	a81d                	j	ffffffffc02043cc <wait_queue_init>

ffffffffc0204398 <up>:
ffffffffc0204398:	f75ff06f          	j	ffffffffc020430c <__up.constprop.0>

ffffffffc020439c <down>:
ffffffffc020439c:	1141                	addi	sp,sp,-16
ffffffffc020439e:	e406                	sd	ra,8(sp)
ffffffffc02043a0:	ebbff0ef          	jal	ffffffffc020425a <__down.constprop.0>
ffffffffc02043a4:	e501                	bnez	a0,ffffffffc02043ac <down+0x10>
ffffffffc02043a6:	60a2                	ld	ra,8(sp)
ffffffffc02043a8:	0141                	addi	sp,sp,16
ffffffffc02043aa:	8082                	ret
ffffffffc02043ac:	00009697          	auipc	a3,0x9
ffffffffc02043b0:	91468693          	addi	a3,a3,-1772 # ffffffffc020ccc0 <etext+0x18be>
ffffffffc02043b4:	00007617          	auipc	a2,0x7
ffffffffc02043b8:	48c60613          	addi	a2,a2,1164 # ffffffffc020b840 <etext+0x43e>
ffffffffc02043bc:	04000593          	li	a1,64
ffffffffc02043c0:	00009517          	auipc	a0,0x9
ffffffffc02043c4:	8f050513          	addi	a0,a0,-1808 # ffffffffc020ccb0 <etext+0x18ae>
ffffffffc02043c8:	882fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02043cc <wait_queue_init>:
ffffffffc02043cc:	e508                	sd	a0,8(a0)
ffffffffc02043ce:	e108                	sd	a0,0(a0)
ffffffffc02043d0:	8082                	ret

ffffffffc02043d2 <wait_queue_del>:
ffffffffc02043d2:	7198                	ld	a4,32(a1)
ffffffffc02043d4:	01858793          	addi	a5,a1,24
ffffffffc02043d8:	00e78b63          	beq	a5,a4,ffffffffc02043ee <wait_queue_del+0x1c>
ffffffffc02043dc:	6994                	ld	a3,16(a1)
ffffffffc02043de:	00a69863          	bne	a3,a0,ffffffffc02043ee <wait_queue_del+0x1c>
ffffffffc02043e2:	6d94                	ld	a3,24(a1)
ffffffffc02043e4:	e698                	sd	a4,8(a3)
ffffffffc02043e6:	e314                	sd	a3,0(a4)
ffffffffc02043e8:	f19c                	sd	a5,32(a1)
ffffffffc02043ea:	ed9c                	sd	a5,24(a1)
ffffffffc02043ec:	8082                	ret
ffffffffc02043ee:	1141                	addi	sp,sp,-16
ffffffffc02043f0:	00009697          	auipc	a3,0x9
ffffffffc02043f4:	93068693          	addi	a3,a3,-1744 # ffffffffc020cd20 <etext+0x191e>
ffffffffc02043f8:	00007617          	auipc	a2,0x7
ffffffffc02043fc:	44860613          	addi	a2,a2,1096 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204400:	45f1                	li	a1,28
ffffffffc0204402:	00009517          	auipc	a0,0x9
ffffffffc0204406:	90650513          	addi	a0,a0,-1786 # ffffffffc020cd08 <etext+0x1906>
ffffffffc020440a:	e406                	sd	ra,8(sp)
ffffffffc020440c:	83efc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204410 <wait_queue_first>:
ffffffffc0204410:	651c                	ld	a5,8(a0)
ffffffffc0204412:	00f50563          	beq	a0,a5,ffffffffc020441c <wait_queue_first+0xc>
ffffffffc0204416:	fe878513          	addi	a0,a5,-24
ffffffffc020441a:	8082                	ret
ffffffffc020441c:	4501                	li	a0,0
ffffffffc020441e:	8082                	ret

ffffffffc0204420 <wait_queue_empty>:
ffffffffc0204420:	651c                	ld	a5,8(a0)
ffffffffc0204422:	40a78533          	sub	a0,a5,a0
ffffffffc0204426:	00153513          	seqz	a0,a0
ffffffffc020442a:	8082                	ret

ffffffffc020442c <wait_in_queue>:
ffffffffc020442c:	711c                	ld	a5,32(a0)
ffffffffc020442e:	0561                	addi	a0,a0,24
ffffffffc0204430:	40a78533          	sub	a0,a5,a0
ffffffffc0204434:	00a03533          	snez	a0,a0
ffffffffc0204438:	8082                	ret

ffffffffc020443a <wakeup_wait>:
ffffffffc020443a:	e689                	bnez	a3,ffffffffc0204444 <wakeup_wait+0xa>
ffffffffc020443c:	6188                	ld	a0,0(a1)
ffffffffc020443e:	c590                	sw	a2,8(a1)
ffffffffc0204440:	5270206f          	j	ffffffffc0207166 <wakeup_proc>
ffffffffc0204444:	7198                	ld	a4,32(a1)
ffffffffc0204446:	01858793          	addi	a5,a1,24
ffffffffc020444a:	00e78e63          	beq	a5,a4,ffffffffc0204466 <wakeup_wait+0x2c>
ffffffffc020444e:	6994                	ld	a3,16(a1)
ffffffffc0204450:	00d51b63          	bne	a0,a3,ffffffffc0204466 <wakeup_wait+0x2c>
ffffffffc0204454:	6d94                	ld	a3,24(a1)
ffffffffc0204456:	6188                	ld	a0,0(a1)
ffffffffc0204458:	e698                	sd	a4,8(a3)
ffffffffc020445a:	e314                	sd	a3,0(a4)
ffffffffc020445c:	f19c                	sd	a5,32(a1)
ffffffffc020445e:	ed9c                	sd	a5,24(a1)
ffffffffc0204460:	c590                	sw	a2,8(a1)
ffffffffc0204462:	5050206f          	j	ffffffffc0207166 <wakeup_proc>
ffffffffc0204466:	1141                	addi	sp,sp,-16
ffffffffc0204468:	00009697          	auipc	a3,0x9
ffffffffc020446c:	8b868693          	addi	a3,a3,-1864 # ffffffffc020cd20 <etext+0x191e>
ffffffffc0204470:	00007617          	auipc	a2,0x7
ffffffffc0204474:	3d060613          	addi	a2,a2,976 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204478:	45f1                	li	a1,28
ffffffffc020447a:	00009517          	auipc	a0,0x9
ffffffffc020447e:	88e50513          	addi	a0,a0,-1906 # ffffffffc020cd08 <etext+0x1906>
ffffffffc0204482:	e406                	sd	ra,8(sp)
ffffffffc0204484:	fc7fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204488 <wakeup_queue>:
ffffffffc0204488:	651c                	ld	a5,8(a0)
ffffffffc020448a:	0aa78763          	beq	a5,a0,ffffffffc0204538 <wakeup_queue+0xb0>
ffffffffc020448e:	1101                	addi	sp,sp,-32
ffffffffc0204490:	e822                	sd	s0,16(sp)
ffffffffc0204492:	e426                	sd	s1,8(sp)
ffffffffc0204494:	e04a                	sd	s2,0(sp)
ffffffffc0204496:	ec06                	sd	ra,24(sp)
ffffffffc0204498:	892e                	mv	s2,a1
ffffffffc020449a:	84aa                	mv	s1,a0
ffffffffc020449c:	fe878413          	addi	s0,a5,-24
ffffffffc02044a0:	ee29                	bnez	a2,ffffffffc02044fa <wakeup_queue+0x72>
ffffffffc02044a2:	6008                	ld	a0,0(s0)
ffffffffc02044a4:	01242423          	sw	s2,8(s0)
ffffffffc02044a8:	4bf020ef          	jal	ffffffffc0207166 <wakeup_proc>
ffffffffc02044ac:	701c                	ld	a5,32(s0)
ffffffffc02044ae:	01840713          	addi	a4,s0,24
ffffffffc02044b2:	02e78463          	beq	a5,a4,ffffffffc02044da <wakeup_queue+0x52>
ffffffffc02044b6:	6818                	ld	a4,16(s0)
ffffffffc02044b8:	02e49163          	bne	s1,a4,ffffffffc02044da <wakeup_queue+0x52>
ffffffffc02044bc:	06f48863          	beq	s1,a5,ffffffffc020452c <wakeup_queue+0xa4>
ffffffffc02044c0:	fe87b503          	ld	a0,-24(a5)
ffffffffc02044c4:	ff27a823          	sw	s2,-16(a5)
ffffffffc02044c8:	fe878413          	addi	s0,a5,-24
ffffffffc02044cc:	49b020ef          	jal	ffffffffc0207166 <wakeup_proc>
ffffffffc02044d0:	701c                	ld	a5,32(s0)
ffffffffc02044d2:	01840713          	addi	a4,s0,24
ffffffffc02044d6:	fee790e3          	bne	a5,a4,ffffffffc02044b6 <wakeup_queue+0x2e>
ffffffffc02044da:	00009697          	auipc	a3,0x9
ffffffffc02044de:	84668693          	addi	a3,a3,-1978 # ffffffffc020cd20 <etext+0x191e>
ffffffffc02044e2:	00007617          	auipc	a2,0x7
ffffffffc02044e6:	35e60613          	addi	a2,a2,862 # ffffffffc020b840 <etext+0x43e>
ffffffffc02044ea:	02200593          	li	a1,34
ffffffffc02044ee:	00009517          	auipc	a0,0x9
ffffffffc02044f2:	81a50513          	addi	a0,a0,-2022 # ffffffffc020cd08 <etext+0x1906>
ffffffffc02044f6:	f55fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02044fa:	6798                	ld	a4,8(a5)
ffffffffc02044fc:	00e79863          	bne	a5,a4,ffffffffc020450c <wakeup_queue+0x84>
ffffffffc0204500:	a82d                	j	ffffffffc020453a <wakeup_queue+0xb2>
ffffffffc0204502:	6418                	ld	a4,8(s0)
ffffffffc0204504:	87a2                	mv	a5,s0
ffffffffc0204506:	1421                	addi	s0,s0,-24
ffffffffc0204508:	02e78963          	beq	a5,a4,ffffffffc020453a <wakeup_queue+0xb2>
ffffffffc020450c:	6814                	ld	a3,16(s0)
ffffffffc020450e:	02d49663          	bne	s1,a3,ffffffffc020453a <wakeup_queue+0xb2>
ffffffffc0204512:	6c14                	ld	a3,24(s0)
ffffffffc0204514:	6008                	ld	a0,0(s0)
ffffffffc0204516:	e698                	sd	a4,8(a3)
ffffffffc0204518:	e314                	sd	a3,0(a4)
ffffffffc020451a:	f01c                	sd	a5,32(s0)
ffffffffc020451c:	ec1c                	sd	a5,24(s0)
ffffffffc020451e:	01242423          	sw	s2,8(s0)
ffffffffc0204522:	445020ef          	jal	ffffffffc0207166 <wakeup_proc>
ffffffffc0204526:	6480                	ld	s0,8(s1)
ffffffffc0204528:	fc849de3          	bne	s1,s0,ffffffffc0204502 <wakeup_queue+0x7a>
ffffffffc020452c:	60e2                	ld	ra,24(sp)
ffffffffc020452e:	6442                	ld	s0,16(sp)
ffffffffc0204530:	64a2                	ld	s1,8(sp)
ffffffffc0204532:	6902                	ld	s2,0(sp)
ffffffffc0204534:	6105                	addi	sp,sp,32
ffffffffc0204536:	8082                	ret
ffffffffc0204538:	8082                	ret
ffffffffc020453a:	00008697          	auipc	a3,0x8
ffffffffc020453e:	7e668693          	addi	a3,a3,2022 # ffffffffc020cd20 <etext+0x191e>
ffffffffc0204542:	00007617          	auipc	a2,0x7
ffffffffc0204546:	2fe60613          	addi	a2,a2,766 # ffffffffc020b840 <etext+0x43e>
ffffffffc020454a:	45f1                	li	a1,28
ffffffffc020454c:	00008517          	auipc	a0,0x8
ffffffffc0204550:	7bc50513          	addi	a0,a0,1980 # ffffffffc020cd08 <etext+0x1906>
ffffffffc0204554:	ef7fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204558 <wait_current_set>:
ffffffffc0204558:	00092797          	auipc	a5,0x92
ffffffffc020455c:	3707b783          	ld	a5,880(a5) # ffffffffc02968c8 <current>
ffffffffc0204560:	c39d                	beqz	a5,ffffffffc0204586 <wait_current_set+0x2e>
ffffffffc0204562:	80000737          	lui	a4,0x80000
ffffffffc0204566:	c598                	sw	a4,8(a1)
ffffffffc0204568:	01858713          	addi	a4,a1,24
ffffffffc020456c:	ed98                	sd	a4,24(a1)
ffffffffc020456e:	e19c                	sd	a5,0(a1)
ffffffffc0204570:	0ec7a623          	sw	a2,236(a5)
ffffffffc0204574:	4605                	li	a2,1
ffffffffc0204576:	6114                	ld	a3,0(a0)
ffffffffc0204578:	c390                	sw	a2,0(a5)
ffffffffc020457a:	e988                	sd	a0,16(a1)
ffffffffc020457c:	e118                	sd	a4,0(a0)
ffffffffc020457e:	e698                	sd	a4,8(a3)
ffffffffc0204580:	ed94                	sd	a3,24(a1)
ffffffffc0204582:	f188                	sd	a0,32(a1)
ffffffffc0204584:	8082                	ret
ffffffffc0204586:	1141                	addi	sp,sp,-16
ffffffffc0204588:	00008697          	auipc	a3,0x8
ffffffffc020458c:	7d868693          	addi	a3,a3,2008 # ffffffffc020cd60 <etext+0x195e>
ffffffffc0204590:	00007617          	auipc	a2,0x7
ffffffffc0204594:	2b060613          	addi	a2,a2,688 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204598:	07400593          	li	a1,116
ffffffffc020459c:	00008517          	auipc	a0,0x8
ffffffffc02045a0:	76c50513          	addi	a0,a0,1900 # ffffffffc020cd08 <etext+0x1906>
ffffffffc02045a4:	e406                	sd	ra,8(sp)
ffffffffc02045a6:	ea5fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02045aa <get_fd_array.part.0>:
ffffffffc02045aa:	1141                	addi	sp,sp,-16
ffffffffc02045ac:	00008697          	auipc	a3,0x8
ffffffffc02045b0:	7c468693          	addi	a3,a3,1988 # ffffffffc020cd70 <etext+0x196e>
ffffffffc02045b4:	00007617          	auipc	a2,0x7
ffffffffc02045b8:	28c60613          	addi	a2,a2,652 # ffffffffc020b840 <etext+0x43e>
ffffffffc02045bc:	45d1                	li	a1,20
ffffffffc02045be:	00008517          	auipc	a0,0x8
ffffffffc02045c2:	7e250513          	addi	a0,a0,2018 # ffffffffc020cda0 <etext+0x199e>
ffffffffc02045c6:	e406                	sd	ra,8(sp)
ffffffffc02045c8:	e83fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02045cc <fd_array_alloc>:
ffffffffc02045cc:	00092797          	auipc	a5,0x92
ffffffffc02045d0:	2fc7b783          	ld	a5,764(a5) # ffffffffc02968c8 <current>
ffffffffc02045d4:	1141                	addi	sp,sp,-16
ffffffffc02045d6:	e406                	sd	ra,8(sp)
ffffffffc02045d8:	1487b783          	ld	a5,328(a5)
ffffffffc02045dc:	cfb9                	beqz	a5,ffffffffc020463a <fd_array_alloc+0x6e>
ffffffffc02045de:	4b98                	lw	a4,16(a5)
ffffffffc02045e0:	04e05d63          	blez	a4,ffffffffc020463a <fd_array_alloc+0x6e>
ffffffffc02045e4:	775d                	lui	a4,0xffff7
ffffffffc02045e6:	ad970713          	addi	a4,a4,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc02045ea:	679c                	ld	a5,8(a5)
ffffffffc02045ec:	02e50763          	beq	a0,a4,ffffffffc020461a <fd_array_alloc+0x4e>
ffffffffc02045f0:	04700713          	li	a4,71
ffffffffc02045f4:	04a76163          	bltu	a4,a0,ffffffffc0204636 <fd_array_alloc+0x6a>
ffffffffc02045f8:	00351713          	slli	a4,a0,0x3
ffffffffc02045fc:	8f09                	sub	a4,a4,a0
ffffffffc02045fe:	070e                	slli	a4,a4,0x3
ffffffffc0204600:	97ba                	add	a5,a5,a4
ffffffffc0204602:	4398                	lw	a4,0(a5)
ffffffffc0204604:	e71d                	bnez	a4,ffffffffc0204632 <fd_array_alloc+0x66>
ffffffffc0204606:	5b88                	lw	a0,48(a5)
ffffffffc0204608:	e91d                	bnez	a0,ffffffffc020463e <fd_array_alloc+0x72>
ffffffffc020460a:	4705                	li	a4,1
ffffffffc020460c:	0207b423          	sd	zero,40(a5)
ffffffffc0204610:	c398                	sw	a4,0(a5)
ffffffffc0204612:	e19c                	sd	a5,0(a1)
ffffffffc0204614:	60a2                	ld	ra,8(sp)
ffffffffc0204616:	0141                	addi	sp,sp,16
ffffffffc0204618:	8082                	ret
ffffffffc020461a:	7ff78693          	addi	a3,a5,2047
ffffffffc020461e:	7c168693          	addi	a3,a3,1985
ffffffffc0204622:	4398                	lw	a4,0(a5)
ffffffffc0204624:	d36d                	beqz	a4,ffffffffc0204606 <fd_array_alloc+0x3a>
ffffffffc0204626:	03878793          	addi	a5,a5,56
ffffffffc020462a:	fed79ce3          	bne	a5,a3,ffffffffc0204622 <fd_array_alloc+0x56>
ffffffffc020462e:	5529                	li	a0,-22
ffffffffc0204630:	b7d5                	j	ffffffffc0204614 <fd_array_alloc+0x48>
ffffffffc0204632:	5545                	li	a0,-15
ffffffffc0204634:	b7c5                	j	ffffffffc0204614 <fd_array_alloc+0x48>
ffffffffc0204636:	5575                	li	a0,-3
ffffffffc0204638:	bff1                	j	ffffffffc0204614 <fd_array_alloc+0x48>
ffffffffc020463a:	f71ff0ef          	jal	ffffffffc02045aa <get_fd_array.part.0>
ffffffffc020463e:	00008697          	auipc	a3,0x8
ffffffffc0204642:	77268693          	addi	a3,a3,1906 # ffffffffc020cdb0 <etext+0x19ae>
ffffffffc0204646:	00007617          	auipc	a2,0x7
ffffffffc020464a:	1fa60613          	addi	a2,a2,506 # ffffffffc020b840 <etext+0x43e>
ffffffffc020464e:	03b00593          	li	a1,59
ffffffffc0204652:	00008517          	auipc	a0,0x8
ffffffffc0204656:	74e50513          	addi	a0,a0,1870 # ffffffffc020cda0 <etext+0x199e>
ffffffffc020465a:	df1fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020465e <fd_array_free>:
ffffffffc020465e:	4118                	lw	a4,0(a0)
ffffffffc0204660:	1101                	addi	sp,sp,-32
ffffffffc0204662:	ec06                	sd	ra,24(sp)
ffffffffc0204664:	4685                	li	a3,1
ffffffffc0204666:	ffd77613          	andi	a2,a4,-3
ffffffffc020466a:	04d61763          	bne	a2,a3,ffffffffc02046b8 <fd_array_free+0x5a>
ffffffffc020466e:	5914                	lw	a3,48(a0)
ffffffffc0204670:	87aa                	mv	a5,a0
ffffffffc0204672:	e29d                	bnez	a3,ffffffffc0204698 <fd_array_free+0x3a>
ffffffffc0204674:	468d                	li	a3,3
ffffffffc0204676:	00d70763          	beq	a4,a3,ffffffffc0204684 <fd_array_free+0x26>
ffffffffc020467a:	60e2                	ld	ra,24(sp)
ffffffffc020467c:	0007a023          	sw	zero,0(a5)
ffffffffc0204680:	6105                	addi	sp,sp,32
ffffffffc0204682:	8082                	ret
ffffffffc0204684:	7508                	ld	a0,40(a0)
ffffffffc0204686:	e43e                	sd	a5,8(sp)
ffffffffc0204688:	09d030ef          	jal	ffffffffc0207f24 <vfs_close>
ffffffffc020468c:	67a2                	ld	a5,8(sp)
ffffffffc020468e:	60e2                	ld	ra,24(sp)
ffffffffc0204690:	0007a023          	sw	zero,0(a5)
ffffffffc0204694:	6105                	addi	sp,sp,32
ffffffffc0204696:	8082                	ret
ffffffffc0204698:	00008697          	auipc	a3,0x8
ffffffffc020469c:	71868693          	addi	a3,a3,1816 # ffffffffc020cdb0 <etext+0x19ae>
ffffffffc02046a0:	00007617          	auipc	a2,0x7
ffffffffc02046a4:	1a060613          	addi	a2,a2,416 # ffffffffc020b840 <etext+0x43e>
ffffffffc02046a8:	04500593          	li	a1,69
ffffffffc02046ac:	00008517          	auipc	a0,0x8
ffffffffc02046b0:	6f450513          	addi	a0,a0,1780 # ffffffffc020cda0 <etext+0x199e>
ffffffffc02046b4:	d97fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02046b8:	00008697          	auipc	a3,0x8
ffffffffc02046bc:	73068693          	addi	a3,a3,1840 # ffffffffc020cde8 <etext+0x19e6>
ffffffffc02046c0:	00007617          	auipc	a2,0x7
ffffffffc02046c4:	18060613          	addi	a2,a2,384 # ffffffffc020b840 <etext+0x43e>
ffffffffc02046c8:	04400593          	li	a1,68
ffffffffc02046cc:	00008517          	auipc	a0,0x8
ffffffffc02046d0:	6d450513          	addi	a0,a0,1748 # ffffffffc020cda0 <etext+0x199e>
ffffffffc02046d4:	d77fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02046d8 <fd_array_release>:
ffffffffc02046d8:	411c                	lw	a5,0(a0)
ffffffffc02046da:	1141                	addi	sp,sp,-16
ffffffffc02046dc:	e406                	sd	ra,8(sp)
ffffffffc02046de:	4685                	li	a3,1
ffffffffc02046e0:	37f9                	addiw	a5,a5,-2
ffffffffc02046e2:	02f6ef63          	bltu	a3,a5,ffffffffc0204720 <fd_array_release+0x48>
ffffffffc02046e6:	591c                	lw	a5,48(a0)
ffffffffc02046e8:	00f05c63          	blez	a5,ffffffffc0204700 <fd_array_release+0x28>
ffffffffc02046ec:	37fd                	addiw	a5,a5,-1
ffffffffc02046ee:	d91c                	sw	a5,48(a0)
ffffffffc02046f0:	c781                	beqz	a5,ffffffffc02046f8 <fd_array_release+0x20>
ffffffffc02046f2:	60a2                	ld	ra,8(sp)
ffffffffc02046f4:	0141                	addi	sp,sp,16
ffffffffc02046f6:	8082                	ret
ffffffffc02046f8:	60a2                	ld	ra,8(sp)
ffffffffc02046fa:	0141                	addi	sp,sp,16
ffffffffc02046fc:	f63ff06f          	j	ffffffffc020465e <fd_array_free>
ffffffffc0204700:	00008697          	auipc	a3,0x8
ffffffffc0204704:	75868693          	addi	a3,a3,1880 # ffffffffc020ce58 <etext+0x1a56>
ffffffffc0204708:	00007617          	auipc	a2,0x7
ffffffffc020470c:	13860613          	addi	a2,a2,312 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204710:	05600593          	li	a1,86
ffffffffc0204714:	00008517          	auipc	a0,0x8
ffffffffc0204718:	68c50513          	addi	a0,a0,1676 # ffffffffc020cda0 <etext+0x199e>
ffffffffc020471c:	d2ffb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204720:	00008697          	auipc	a3,0x8
ffffffffc0204724:	70068693          	addi	a3,a3,1792 # ffffffffc020ce20 <etext+0x1a1e>
ffffffffc0204728:	00007617          	auipc	a2,0x7
ffffffffc020472c:	11860613          	addi	a2,a2,280 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204730:	05500593          	li	a1,85
ffffffffc0204734:	00008517          	auipc	a0,0x8
ffffffffc0204738:	66c50513          	addi	a0,a0,1644 # ffffffffc020cda0 <etext+0x199e>
ffffffffc020473c:	d0ffb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204740 <fd_array_open.part.0>:
ffffffffc0204740:	1141                	addi	sp,sp,-16
ffffffffc0204742:	00008697          	auipc	a3,0x8
ffffffffc0204746:	72e68693          	addi	a3,a3,1838 # ffffffffc020ce70 <etext+0x1a6e>
ffffffffc020474a:	00007617          	auipc	a2,0x7
ffffffffc020474e:	0f660613          	addi	a2,a2,246 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204752:	05f00593          	li	a1,95
ffffffffc0204756:	00008517          	auipc	a0,0x8
ffffffffc020475a:	64a50513          	addi	a0,a0,1610 # ffffffffc020cda0 <etext+0x199e>
ffffffffc020475e:	e406                	sd	ra,8(sp)
ffffffffc0204760:	cebfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204764 <fd_array_init>:
ffffffffc0204764:	4781                	li	a5,0
ffffffffc0204766:	04800713          	li	a4,72
ffffffffc020476a:	cd1c                	sw	a5,24(a0)
ffffffffc020476c:	02052823          	sw	zero,48(a0)
ffffffffc0204770:	00052023          	sw	zero,0(a0)
ffffffffc0204774:	2785                	addiw	a5,a5,1
ffffffffc0204776:	03850513          	addi	a0,a0,56
ffffffffc020477a:	fee798e3          	bne	a5,a4,ffffffffc020476a <fd_array_init+0x6>
ffffffffc020477e:	8082                	ret

ffffffffc0204780 <fd_array_close>:
ffffffffc0204780:	4114                	lw	a3,0(a0)
ffffffffc0204782:	1101                	addi	sp,sp,-32
ffffffffc0204784:	ec06                	sd	ra,24(sp)
ffffffffc0204786:	4789                	li	a5,2
ffffffffc0204788:	04f69863          	bne	a3,a5,ffffffffc02047d8 <fd_array_close+0x58>
ffffffffc020478c:	591c                	lw	a5,48(a0)
ffffffffc020478e:	872a                	mv	a4,a0
ffffffffc0204790:	02f05463          	blez	a5,ffffffffc02047b8 <fd_array_close+0x38>
ffffffffc0204794:	37fd                	addiw	a5,a5,-1
ffffffffc0204796:	468d                	li	a3,3
ffffffffc0204798:	d91c                	sw	a5,48(a0)
ffffffffc020479a:	c114                	sw	a3,0(a0)
ffffffffc020479c:	c781                	beqz	a5,ffffffffc02047a4 <fd_array_close+0x24>
ffffffffc020479e:	60e2                	ld	ra,24(sp)
ffffffffc02047a0:	6105                	addi	sp,sp,32
ffffffffc02047a2:	8082                	ret
ffffffffc02047a4:	7508                	ld	a0,40(a0)
ffffffffc02047a6:	e43a                	sd	a4,8(sp)
ffffffffc02047a8:	77c030ef          	jal	ffffffffc0207f24 <vfs_close>
ffffffffc02047ac:	6722                	ld	a4,8(sp)
ffffffffc02047ae:	60e2                	ld	ra,24(sp)
ffffffffc02047b0:	00072023          	sw	zero,0(a4)
ffffffffc02047b4:	6105                	addi	sp,sp,32
ffffffffc02047b6:	8082                	ret
ffffffffc02047b8:	00008697          	auipc	a3,0x8
ffffffffc02047bc:	6a068693          	addi	a3,a3,1696 # ffffffffc020ce58 <etext+0x1a56>
ffffffffc02047c0:	00007617          	auipc	a2,0x7
ffffffffc02047c4:	08060613          	addi	a2,a2,128 # ffffffffc020b840 <etext+0x43e>
ffffffffc02047c8:	06800593          	li	a1,104
ffffffffc02047cc:	00008517          	auipc	a0,0x8
ffffffffc02047d0:	5d450513          	addi	a0,a0,1492 # ffffffffc020cda0 <etext+0x199e>
ffffffffc02047d4:	c77fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02047d8:	00008697          	auipc	a3,0x8
ffffffffc02047dc:	5f068693          	addi	a3,a3,1520 # ffffffffc020cdc8 <etext+0x19c6>
ffffffffc02047e0:	00007617          	auipc	a2,0x7
ffffffffc02047e4:	06060613          	addi	a2,a2,96 # ffffffffc020b840 <etext+0x43e>
ffffffffc02047e8:	06700593          	li	a1,103
ffffffffc02047ec:	00008517          	auipc	a0,0x8
ffffffffc02047f0:	5b450513          	addi	a0,a0,1460 # ffffffffc020cda0 <etext+0x199e>
ffffffffc02047f4:	c57fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02047f8 <fd_array_dup>:
ffffffffc02047f8:	4118                	lw	a4,0(a0)
ffffffffc02047fa:	1101                	addi	sp,sp,-32
ffffffffc02047fc:	ec06                	sd	ra,24(sp)
ffffffffc02047fe:	e822                	sd	s0,16(sp)
ffffffffc0204800:	e426                	sd	s1,8(sp)
ffffffffc0204802:	e04a                	sd	s2,0(sp)
ffffffffc0204804:	4785                	li	a5,1
ffffffffc0204806:	04f71563          	bne	a4,a5,ffffffffc0204850 <fd_array_dup+0x58>
ffffffffc020480a:	0005a903          	lw	s2,0(a1)
ffffffffc020480e:	4789                	li	a5,2
ffffffffc0204810:	04f91063          	bne	s2,a5,ffffffffc0204850 <fd_array_dup+0x58>
ffffffffc0204814:	719c                	ld	a5,32(a1)
ffffffffc0204816:	7584                	ld	s1,40(a1)
ffffffffc0204818:	842a                	mv	s0,a0
ffffffffc020481a:	f11c                	sd	a5,32(a0)
ffffffffc020481c:	699c                	ld	a5,16(a1)
ffffffffc020481e:	6598                	ld	a4,8(a1)
ffffffffc0204820:	8526                	mv	a0,s1
ffffffffc0204822:	e81c                	sd	a5,16(s0)
ffffffffc0204824:	e418                	sd	a4,8(s0)
ffffffffc0204826:	613020ef          	jal	ffffffffc0207638 <inode_ref_inc>
ffffffffc020482a:	8526                	mv	a0,s1
ffffffffc020482c:	617020ef          	jal	ffffffffc0207642 <inode_open_inc>
ffffffffc0204830:	401c                	lw	a5,0(s0)
ffffffffc0204832:	f404                	sd	s1,40(s0)
ffffffffc0204834:	17fd                	addi	a5,a5,-1
ffffffffc0204836:	ef8d                	bnez	a5,ffffffffc0204870 <fd_array_dup+0x78>
ffffffffc0204838:	cc85                	beqz	s1,ffffffffc0204870 <fd_array_dup+0x78>
ffffffffc020483a:	581c                	lw	a5,48(s0)
ffffffffc020483c:	01242023          	sw	s2,0(s0)
ffffffffc0204840:	60e2                	ld	ra,24(sp)
ffffffffc0204842:	2785                	addiw	a5,a5,1
ffffffffc0204844:	d81c                	sw	a5,48(s0)
ffffffffc0204846:	6442                	ld	s0,16(sp)
ffffffffc0204848:	64a2                	ld	s1,8(sp)
ffffffffc020484a:	6902                	ld	s2,0(sp)
ffffffffc020484c:	6105                	addi	sp,sp,32
ffffffffc020484e:	8082                	ret
ffffffffc0204850:	00008697          	auipc	a3,0x8
ffffffffc0204854:	65068693          	addi	a3,a3,1616 # ffffffffc020cea0 <etext+0x1a9e>
ffffffffc0204858:	00007617          	auipc	a2,0x7
ffffffffc020485c:	fe860613          	addi	a2,a2,-24 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204860:	07300593          	li	a1,115
ffffffffc0204864:	00008517          	auipc	a0,0x8
ffffffffc0204868:	53c50513          	addi	a0,a0,1340 # ffffffffc020cda0 <etext+0x199e>
ffffffffc020486c:	bdffb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204870:	ed1ff0ef          	jal	ffffffffc0204740 <fd_array_open.part.0>

ffffffffc0204874 <file_testfd>:
ffffffffc0204874:	04700793          	li	a5,71
ffffffffc0204878:	04a7e263          	bltu	a5,a0,ffffffffc02048bc <file_testfd+0x48>
ffffffffc020487c:	00092797          	auipc	a5,0x92
ffffffffc0204880:	04c7b783          	ld	a5,76(a5) # ffffffffc02968c8 <current>
ffffffffc0204884:	1487b783          	ld	a5,328(a5)
ffffffffc0204888:	cf85                	beqz	a5,ffffffffc02048c0 <file_testfd+0x4c>
ffffffffc020488a:	4b98                	lw	a4,16(a5)
ffffffffc020488c:	02e05a63          	blez	a4,ffffffffc02048c0 <file_testfd+0x4c>
ffffffffc0204890:	6798                	ld	a4,8(a5)
ffffffffc0204892:	00351793          	slli	a5,a0,0x3
ffffffffc0204896:	8f89                	sub	a5,a5,a0
ffffffffc0204898:	078e                	slli	a5,a5,0x3
ffffffffc020489a:	97ba                	add	a5,a5,a4
ffffffffc020489c:	4394                	lw	a3,0(a5)
ffffffffc020489e:	4709                	li	a4,2
ffffffffc02048a0:	00e69e63          	bne	a3,a4,ffffffffc02048bc <file_testfd+0x48>
ffffffffc02048a4:	4f98                	lw	a4,24(a5)
ffffffffc02048a6:	00a71b63          	bne	a4,a0,ffffffffc02048bc <file_testfd+0x48>
ffffffffc02048aa:	c199                	beqz	a1,ffffffffc02048b0 <file_testfd+0x3c>
ffffffffc02048ac:	6788                	ld	a0,8(a5)
ffffffffc02048ae:	c901                	beqz	a0,ffffffffc02048be <file_testfd+0x4a>
ffffffffc02048b0:	4505                	li	a0,1
ffffffffc02048b2:	c611                	beqz	a2,ffffffffc02048be <file_testfd+0x4a>
ffffffffc02048b4:	6b88                	ld	a0,16(a5)
ffffffffc02048b6:	00a03533          	snez	a0,a0
ffffffffc02048ba:	8082                	ret
ffffffffc02048bc:	4501                	li	a0,0
ffffffffc02048be:	8082                	ret
ffffffffc02048c0:	1141                	addi	sp,sp,-16
ffffffffc02048c2:	e406                	sd	ra,8(sp)
ffffffffc02048c4:	ce7ff0ef          	jal	ffffffffc02045aa <get_fd_array.part.0>

ffffffffc02048c8 <file_open>:
ffffffffc02048c8:	0035f793          	andi	a5,a1,3
ffffffffc02048cc:	470d                	li	a4,3
ffffffffc02048ce:	0ee78563          	beq	a5,a4,ffffffffc02049b8 <file_open+0xf0>
ffffffffc02048d2:	078e                	slli	a5,a5,0x3
ffffffffc02048d4:	0000a717          	auipc	a4,0xa
ffffffffc02048d8:	12c70713          	addi	a4,a4,300 # ffffffffc020ea00 <CSWTCH.79>
ffffffffc02048dc:	0000a697          	auipc	a3,0xa
ffffffffc02048e0:	13c68693          	addi	a3,a3,316 # ffffffffc020ea18 <CSWTCH.78>
ffffffffc02048e4:	96be                	add	a3,a3,a5
ffffffffc02048e6:	97ba                	add	a5,a5,a4
ffffffffc02048e8:	7159                	addi	sp,sp,-112
ffffffffc02048ea:	639c                	ld	a5,0(a5)
ffffffffc02048ec:	6298                	ld	a4,0(a3)
ffffffffc02048ee:	eca6                	sd	s1,88(sp)
ffffffffc02048f0:	84aa                	mv	s1,a0
ffffffffc02048f2:	755d                	lui	a0,0xffff7
ffffffffc02048f4:	f0a2                	sd	s0,96(sp)
ffffffffc02048f6:	ad950513          	addi	a0,a0,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc02048fa:	842e                	mv	s0,a1
ffffffffc02048fc:	080c                	addi	a1,sp,16
ffffffffc02048fe:	e8ca                	sd	s2,80(sp)
ffffffffc0204900:	e4ce                	sd	s3,72(sp)
ffffffffc0204902:	f486                	sd	ra,104(sp)
ffffffffc0204904:	89be                	mv	s3,a5
ffffffffc0204906:	893a                	mv	s2,a4
ffffffffc0204908:	cc5ff0ef          	jal	ffffffffc02045cc <fd_array_alloc>
ffffffffc020490c:	87aa                	mv	a5,a0
ffffffffc020490e:	c909                	beqz	a0,ffffffffc0204920 <file_open+0x58>
ffffffffc0204910:	70a6                	ld	ra,104(sp)
ffffffffc0204912:	7406                	ld	s0,96(sp)
ffffffffc0204914:	64e6                	ld	s1,88(sp)
ffffffffc0204916:	6946                	ld	s2,80(sp)
ffffffffc0204918:	69a6                	ld	s3,72(sp)
ffffffffc020491a:	853e                	mv	a0,a5
ffffffffc020491c:	6165                	addi	sp,sp,112
ffffffffc020491e:	8082                	ret
ffffffffc0204920:	8526                	mv	a0,s1
ffffffffc0204922:	0830                	addi	a2,sp,24
ffffffffc0204924:	85a2                	mv	a1,s0
ffffffffc0204926:	428030ef          	jal	ffffffffc0207d4e <vfs_open>
ffffffffc020492a:	6742                	ld	a4,16(sp)
ffffffffc020492c:	e141                	bnez	a0,ffffffffc02049ac <file_open+0xe4>
ffffffffc020492e:	02073023          	sd	zero,32(a4)
ffffffffc0204932:	02047593          	andi	a1,s0,32
ffffffffc0204936:	c98d                	beqz	a1,ffffffffc0204968 <file_open+0xa0>
ffffffffc0204938:	6562                	ld	a0,24(sp)
ffffffffc020493a:	c541                	beqz	a0,ffffffffc02049c2 <file_open+0xfa>
ffffffffc020493c:	793c                	ld	a5,112(a0)
ffffffffc020493e:	c3d1                	beqz	a5,ffffffffc02049c2 <file_open+0xfa>
ffffffffc0204940:	779c                	ld	a5,40(a5)
ffffffffc0204942:	c3c1                	beqz	a5,ffffffffc02049c2 <file_open+0xfa>
ffffffffc0204944:	00008597          	auipc	a1,0x8
ffffffffc0204948:	5e458593          	addi	a1,a1,1508 # ffffffffc020cf28 <etext+0x1b26>
ffffffffc020494c:	e43a                	sd	a4,8(sp)
ffffffffc020494e:	e02a                	sd	a0,0(sp)
ffffffffc0204950:	4fd020ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0204954:	6502                	ld	a0,0(sp)
ffffffffc0204956:	100c                	addi	a1,sp,32
ffffffffc0204958:	793c                	ld	a5,112(a0)
ffffffffc020495a:	6562                	ld	a0,24(sp)
ffffffffc020495c:	779c                	ld	a5,40(a5)
ffffffffc020495e:	9782                	jalr	a5
ffffffffc0204960:	6722                	ld	a4,8(sp)
ffffffffc0204962:	e91d                	bnez	a0,ffffffffc0204998 <file_open+0xd0>
ffffffffc0204964:	77e2                	ld	a5,56(sp)
ffffffffc0204966:	f31c                	sd	a5,32(a4)
ffffffffc0204968:	66e2                	ld	a3,24(sp)
ffffffffc020496a:	431c                	lw	a5,0(a4)
ffffffffc020496c:	01273423          	sd	s2,8(a4)
ffffffffc0204970:	01373823          	sd	s3,16(a4)
ffffffffc0204974:	f714                	sd	a3,40(a4)
ffffffffc0204976:	17fd                	addi	a5,a5,-1
ffffffffc0204978:	e3b9                	bnez	a5,ffffffffc02049be <file_open+0xf6>
ffffffffc020497a:	c2b1                	beqz	a3,ffffffffc02049be <file_open+0xf6>
ffffffffc020497c:	5b1c                	lw	a5,48(a4)
ffffffffc020497e:	70a6                	ld	ra,104(sp)
ffffffffc0204980:	7406                	ld	s0,96(sp)
ffffffffc0204982:	2785                	addiw	a5,a5,1
ffffffffc0204984:	db1c                	sw	a5,48(a4)
ffffffffc0204986:	4f1c                	lw	a5,24(a4)
ffffffffc0204988:	4689                	li	a3,2
ffffffffc020498a:	c314                	sw	a3,0(a4)
ffffffffc020498c:	64e6                	ld	s1,88(sp)
ffffffffc020498e:	6946                	ld	s2,80(sp)
ffffffffc0204990:	69a6                	ld	s3,72(sp)
ffffffffc0204992:	853e                	mv	a0,a5
ffffffffc0204994:	6165                	addi	sp,sp,112
ffffffffc0204996:	8082                	ret
ffffffffc0204998:	e42a                	sd	a0,8(sp)
ffffffffc020499a:	6562                	ld	a0,24(sp)
ffffffffc020499c:	e03a                	sd	a4,0(sp)
ffffffffc020499e:	586030ef          	jal	ffffffffc0207f24 <vfs_close>
ffffffffc02049a2:	6502                	ld	a0,0(sp)
ffffffffc02049a4:	cbbff0ef          	jal	ffffffffc020465e <fd_array_free>
ffffffffc02049a8:	67a2                	ld	a5,8(sp)
ffffffffc02049aa:	b79d                	j	ffffffffc0204910 <file_open+0x48>
ffffffffc02049ac:	e02a                	sd	a0,0(sp)
ffffffffc02049ae:	853a                	mv	a0,a4
ffffffffc02049b0:	cafff0ef          	jal	ffffffffc020465e <fd_array_free>
ffffffffc02049b4:	6782                	ld	a5,0(sp)
ffffffffc02049b6:	bfa9                	j	ffffffffc0204910 <file_open+0x48>
ffffffffc02049b8:	57f5                	li	a5,-3
ffffffffc02049ba:	853e                	mv	a0,a5
ffffffffc02049bc:	8082                	ret
ffffffffc02049be:	d83ff0ef          	jal	ffffffffc0204740 <fd_array_open.part.0>
ffffffffc02049c2:	00008697          	auipc	a3,0x8
ffffffffc02049c6:	51668693          	addi	a3,a3,1302 # ffffffffc020ced8 <etext+0x1ad6>
ffffffffc02049ca:	00007617          	auipc	a2,0x7
ffffffffc02049ce:	e7660613          	addi	a2,a2,-394 # ffffffffc020b840 <etext+0x43e>
ffffffffc02049d2:	0b500593          	li	a1,181
ffffffffc02049d6:	00008517          	auipc	a0,0x8
ffffffffc02049da:	3ca50513          	addi	a0,a0,970 # ffffffffc020cda0 <etext+0x199e>
ffffffffc02049de:	a6dfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02049e2 <file_close>:
ffffffffc02049e2:	04700793          	li	a5,71
ffffffffc02049e6:	04a7e663          	bltu	a5,a0,ffffffffc0204a32 <file_close+0x50>
ffffffffc02049ea:	00092717          	auipc	a4,0x92
ffffffffc02049ee:	ede73703          	ld	a4,-290(a4) # ffffffffc02968c8 <current>
ffffffffc02049f2:	1141                	addi	sp,sp,-16
ffffffffc02049f4:	e406                	sd	ra,8(sp)
ffffffffc02049f6:	14873703          	ld	a4,328(a4)
ffffffffc02049fa:	87aa                	mv	a5,a0
ffffffffc02049fc:	cf0d                	beqz	a4,ffffffffc0204a36 <file_close+0x54>
ffffffffc02049fe:	4b14                	lw	a3,16(a4)
ffffffffc0204a00:	02d05b63          	blez	a3,ffffffffc0204a36 <file_close+0x54>
ffffffffc0204a04:	6708                	ld	a0,8(a4)
ffffffffc0204a06:	00379713          	slli	a4,a5,0x3
ffffffffc0204a0a:	8f1d                	sub	a4,a4,a5
ffffffffc0204a0c:	070e                	slli	a4,a4,0x3
ffffffffc0204a0e:	953a                	add	a0,a0,a4
ffffffffc0204a10:	4114                	lw	a3,0(a0)
ffffffffc0204a12:	4709                	li	a4,2
ffffffffc0204a14:	00e69b63          	bne	a3,a4,ffffffffc0204a2a <file_close+0x48>
ffffffffc0204a18:	4d18                	lw	a4,24(a0)
ffffffffc0204a1a:	00f71863          	bne	a4,a5,ffffffffc0204a2a <file_close+0x48>
ffffffffc0204a1e:	d63ff0ef          	jal	ffffffffc0204780 <fd_array_close>
ffffffffc0204a22:	60a2                	ld	ra,8(sp)
ffffffffc0204a24:	4501                	li	a0,0
ffffffffc0204a26:	0141                	addi	sp,sp,16
ffffffffc0204a28:	8082                	ret
ffffffffc0204a2a:	60a2                	ld	ra,8(sp)
ffffffffc0204a2c:	5575                	li	a0,-3
ffffffffc0204a2e:	0141                	addi	sp,sp,16
ffffffffc0204a30:	8082                	ret
ffffffffc0204a32:	5575                	li	a0,-3
ffffffffc0204a34:	8082                	ret
ffffffffc0204a36:	b75ff0ef          	jal	ffffffffc02045aa <get_fd_array.part.0>

ffffffffc0204a3a <file_read>:
ffffffffc0204a3a:	711d                	addi	sp,sp,-96
ffffffffc0204a3c:	ec86                	sd	ra,88(sp)
ffffffffc0204a3e:	e0ca                	sd	s2,64(sp)
ffffffffc0204a40:	0006b023          	sd	zero,0(a3)
ffffffffc0204a44:	04700793          	li	a5,71
ffffffffc0204a48:	0aa7ec63          	bltu	a5,a0,ffffffffc0204b00 <file_read+0xc6>
ffffffffc0204a4c:	00092797          	auipc	a5,0x92
ffffffffc0204a50:	e7c7b783          	ld	a5,-388(a5) # ffffffffc02968c8 <current>
ffffffffc0204a54:	e4a6                	sd	s1,72(sp)
ffffffffc0204a56:	e8a2                	sd	s0,80(sp)
ffffffffc0204a58:	1487b783          	ld	a5,328(a5)
ffffffffc0204a5c:	fc4e                	sd	s3,56(sp)
ffffffffc0204a5e:	84b6                	mv	s1,a3
ffffffffc0204a60:	c3f1                	beqz	a5,ffffffffc0204b24 <file_read+0xea>
ffffffffc0204a62:	4b98                	lw	a4,16(a5)
ffffffffc0204a64:	0ce05063          	blez	a4,ffffffffc0204b24 <file_read+0xea>
ffffffffc0204a68:	6780                	ld	s0,8(a5)
ffffffffc0204a6a:	00351793          	slli	a5,a0,0x3
ffffffffc0204a6e:	8f89                	sub	a5,a5,a0
ffffffffc0204a70:	078e                	slli	a5,a5,0x3
ffffffffc0204a72:	943e                	add	s0,s0,a5
ffffffffc0204a74:	00042983          	lw	s3,0(s0)
ffffffffc0204a78:	4789                	li	a5,2
ffffffffc0204a7a:	06f99a63          	bne	s3,a5,ffffffffc0204aee <file_read+0xb4>
ffffffffc0204a7e:	4c1c                	lw	a5,24(s0)
ffffffffc0204a80:	06a79763          	bne	a5,a0,ffffffffc0204aee <file_read+0xb4>
ffffffffc0204a84:	641c                	ld	a5,8(s0)
ffffffffc0204a86:	c7a5                	beqz	a5,ffffffffc0204aee <file_read+0xb4>
ffffffffc0204a88:	581c                	lw	a5,48(s0)
ffffffffc0204a8a:	7014                	ld	a3,32(s0)
ffffffffc0204a8c:	0808                	addi	a0,sp,16
ffffffffc0204a8e:	2785                	addiw	a5,a5,1
ffffffffc0204a90:	d81c                	sw	a5,48(s0)
ffffffffc0204a92:	7a0000ef          	jal	ffffffffc0205232 <iobuf_init>
ffffffffc0204a96:	892a                	mv	s2,a0
ffffffffc0204a98:	7408                	ld	a0,40(s0)
ffffffffc0204a9a:	c52d                	beqz	a0,ffffffffc0204b04 <file_read+0xca>
ffffffffc0204a9c:	793c                	ld	a5,112(a0)
ffffffffc0204a9e:	c3bd                	beqz	a5,ffffffffc0204b04 <file_read+0xca>
ffffffffc0204aa0:	6f9c                	ld	a5,24(a5)
ffffffffc0204aa2:	c3ad                	beqz	a5,ffffffffc0204b04 <file_read+0xca>
ffffffffc0204aa4:	00008597          	auipc	a1,0x8
ffffffffc0204aa8:	4dc58593          	addi	a1,a1,1244 # ffffffffc020cf80 <etext+0x1b7e>
ffffffffc0204aac:	e42a                	sd	a0,8(sp)
ffffffffc0204aae:	39f020ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0204ab2:	6522                	ld	a0,8(sp)
ffffffffc0204ab4:	85ca                	mv	a1,s2
ffffffffc0204ab6:	793c                	ld	a5,112(a0)
ffffffffc0204ab8:	7408                	ld	a0,40(s0)
ffffffffc0204aba:	6f9c                	ld	a5,24(a5)
ffffffffc0204abc:	9782                	jalr	a5
ffffffffc0204abe:	01093783          	ld	a5,16(s2)
ffffffffc0204ac2:	01893683          	ld	a3,24(s2)
ffffffffc0204ac6:	4018                	lw	a4,0(s0)
ffffffffc0204ac8:	892a                	mv	s2,a0
ffffffffc0204aca:	8f95                	sub	a5,a5,a3
ffffffffc0204acc:	01371563          	bne	a4,s3,ffffffffc0204ad6 <file_read+0x9c>
ffffffffc0204ad0:	7018                	ld	a4,32(s0)
ffffffffc0204ad2:	973e                	add	a4,a4,a5
ffffffffc0204ad4:	f018                	sd	a4,32(s0)
ffffffffc0204ad6:	e09c                	sd	a5,0(s1)
ffffffffc0204ad8:	8522                	mv	a0,s0
ffffffffc0204ada:	bffff0ef          	jal	ffffffffc02046d8 <fd_array_release>
ffffffffc0204ade:	6446                	ld	s0,80(sp)
ffffffffc0204ae0:	64a6                	ld	s1,72(sp)
ffffffffc0204ae2:	79e2                	ld	s3,56(sp)
ffffffffc0204ae4:	60e6                	ld	ra,88(sp)
ffffffffc0204ae6:	854a                	mv	a0,s2
ffffffffc0204ae8:	6906                	ld	s2,64(sp)
ffffffffc0204aea:	6125                	addi	sp,sp,96
ffffffffc0204aec:	8082                	ret
ffffffffc0204aee:	6446                	ld	s0,80(sp)
ffffffffc0204af0:	60e6                	ld	ra,88(sp)
ffffffffc0204af2:	5975                	li	s2,-3
ffffffffc0204af4:	64a6                	ld	s1,72(sp)
ffffffffc0204af6:	79e2                	ld	s3,56(sp)
ffffffffc0204af8:	854a                	mv	a0,s2
ffffffffc0204afa:	6906                	ld	s2,64(sp)
ffffffffc0204afc:	6125                	addi	sp,sp,96
ffffffffc0204afe:	8082                	ret
ffffffffc0204b00:	5975                	li	s2,-3
ffffffffc0204b02:	b7cd                	j	ffffffffc0204ae4 <file_read+0xaa>
ffffffffc0204b04:	00008697          	auipc	a3,0x8
ffffffffc0204b08:	42c68693          	addi	a3,a3,1068 # ffffffffc020cf30 <etext+0x1b2e>
ffffffffc0204b0c:	00007617          	auipc	a2,0x7
ffffffffc0204b10:	d3460613          	addi	a2,a2,-716 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204b14:	0de00593          	li	a1,222
ffffffffc0204b18:	00008517          	auipc	a0,0x8
ffffffffc0204b1c:	28850513          	addi	a0,a0,648 # ffffffffc020cda0 <etext+0x199e>
ffffffffc0204b20:	92bfb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204b24:	a87ff0ef          	jal	ffffffffc02045aa <get_fd_array.part.0>

ffffffffc0204b28 <file_write>:
ffffffffc0204b28:	711d                	addi	sp,sp,-96
ffffffffc0204b2a:	ec86                	sd	ra,88(sp)
ffffffffc0204b2c:	e0ca                	sd	s2,64(sp)
ffffffffc0204b2e:	0006b023          	sd	zero,0(a3)
ffffffffc0204b32:	04700793          	li	a5,71
ffffffffc0204b36:	0aa7ec63          	bltu	a5,a0,ffffffffc0204bee <file_write+0xc6>
ffffffffc0204b3a:	00092797          	auipc	a5,0x92
ffffffffc0204b3e:	d8e7b783          	ld	a5,-626(a5) # ffffffffc02968c8 <current>
ffffffffc0204b42:	e4a6                	sd	s1,72(sp)
ffffffffc0204b44:	e8a2                	sd	s0,80(sp)
ffffffffc0204b46:	1487b783          	ld	a5,328(a5)
ffffffffc0204b4a:	fc4e                	sd	s3,56(sp)
ffffffffc0204b4c:	84b6                	mv	s1,a3
ffffffffc0204b4e:	c3f1                	beqz	a5,ffffffffc0204c12 <file_write+0xea>
ffffffffc0204b50:	4b98                	lw	a4,16(a5)
ffffffffc0204b52:	0ce05063          	blez	a4,ffffffffc0204c12 <file_write+0xea>
ffffffffc0204b56:	6780                	ld	s0,8(a5)
ffffffffc0204b58:	00351793          	slli	a5,a0,0x3
ffffffffc0204b5c:	8f89                	sub	a5,a5,a0
ffffffffc0204b5e:	078e                	slli	a5,a5,0x3
ffffffffc0204b60:	943e                	add	s0,s0,a5
ffffffffc0204b62:	00042983          	lw	s3,0(s0)
ffffffffc0204b66:	4789                	li	a5,2
ffffffffc0204b68:	06f99a63          	bne	s3,a5,ffffffffc0204bdc <file_write+0xb4>
ffffffffc0204b6c:	4c1c                	lw	a5,24(s0)
ffffffffc0204b6e:	06a79763          	bne	a5,a0,ffffffffc0204bdc <file_write+0xb4>
ffffffffc0204b72:	681c                	ld	a5,16(s0)
ffffffffc0204b74:	c7a5                	beqz	a5,ffffffffc0204bdc <file_write+0xb4>
ffffffffc0204b76:	581c                	lw	a5,48(s0)
ffffffffc0204b78:	7014                	ld	a3,32(s0)
ffffffffc0204b7a:	0808                	addi	a0,sp,16
ffffffffc0204b7c:	2785                	addiw	a5,a5,1
ffffffffc0204b7e:	d81c                	sw	a5,48(s0)
ffffffffc0204b80:	6b2000ef          	jal	ffffffffc0205232 <iobuf_init>
ffffffffc0204b84:	892a                	mv	s2,a0
ffffffffc0204b86:	7408                	ld	a0,40(s0)
ffffffffc0204b88:	c52d                	beqz	a0,ffffffffc0204bf2 <file_write+0xca>
ffffffffc0204b8a:	793c                	ld	a5,112(a0)
ffffffffc0204b8c:	c3bd                	beqz	a5,ffffffffc0204bf2 <file_write+0xca>
ffffffffc0204b8e:	739c                	ld	a5,32(a5)
ffffffffc0204b90:	c3ad                	beqz	a5,ffffffffc0204bf2 <file_write+0xca>
ffffffffc0204b92:	00008597          	auipc	a1,0x8
ffffffffc0204b96:	44658593          	addi	a1,a1,1094 # ffffffffc020cfd8 <etext+0x1bd6>
ffffffffc0204b9a:	e42a                	sd	a0,8(sp)
ffffffffc0204b9c:	2b1020ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0204ba0:	6522                	ld	a0,8(sp)
ffffffffc0204ba2:	85ca                	mv	a1,s2
ffffffffc0204ba4:	793c                	ld	a5,112(a0)
ffffffffc0204ba6:	7408                	ld	a0,40(s0)
ffffffffc0204ba8:	739c                	ld	a5,32(a5)
ffffffffc0204baa:	9782                	jalr	a5
ffffffffc0204bac:	01093783          	ld	a5,16(s2)
ffffffffc0204bb0:	01893683          	ld	a3,24(s2)
ffffffffc0204bb4:	4018                	lw	a4,0(s0)
ffffffffc0204bb6:	892a                	mv	s2,a0
ffffffffc0204bb8:	8f95                	sub	a5,a5,a3
ffffffffc0204bba:	01371563          	bne	a4,s3,ffffffffc0204bc4 <file_write+0x9c>
ffffffffc0204bbe:	7018                	ld	a4,32(s0)
ffffffffc0204bc0:	973e                	add	a4,a4,a5
ffffffffc0204bc2:	f018                	sd	a4,32(s0)
ffffffffc0204bc4:	e09c                	sd	a5,0(s1)
ffffffffc0204bc6:	8522                	mv	a0,s0
ffffffffc0204bc8:	b11ff0ef          	jal	ffffffffc02046d8 <fd_array_release>
ffffffffc0204bcc:	6446                	ld	s0,80(sp)
ffffffffc0204bce:	64a6                	ld	s1,72(sp)
ffffffffc0204bd0:	79e2                	ld	s3,56(sp)
ffffffffc0204bd2:	60e6                	ld	ra,88(sp)
ffffffffc0204bd4:	854a                	mv	a0,s2
ffffffffc0204bd6:	6906                	ld	s2,64(sp)
ffffffffc0204bd8:	6125                	addi	sp,sp,96
ffffffffc0204bda:	8082                	ret
ffffffffc0204bdc:	6446                	ld	s0,80(sp)
ffffffffc0204bde:	60e6                	ld	ra,88(sp)
ffffffffc0204be0:	5975                	li	s2,-3
ffffffffc0204be2:	64a6                	ld	s1,72(sp)
ffffffffc0204be4:	79e2                	ld	s3,56(sp)
ffffffffc0204be6:	854a                	mv	a0,s2
ffffffffc0204be8:	6906                	ld	s2,64(sp)
ffffffffc0204bea:	6125                	addi	sp,sp,96
ffffffffc0204bec:	8082                	ret
ffffffffc0204bee:	5975                	li	s2,-3
ffffffffc0204bf0:	b7cd                	j	ffffffffc0204bd2 <file_write+0xaa>
ffffffffc0204bf2:	00008697          	auipc	a3,0x8
ffffffffc0204bf6:	39668693          	addi	a3,a3,918 # ffffffffc020cf88 <etext+0x1b86>
ffffffffc0204bfa:	00007617          	auipc	a2,0x7
ffffffffc0204bfe:	c4660613          	addi	a2,a2,-954 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204c02:	0f800593          	li	a1,248
ffffffffc0204c06:	00008517          	auipc	a0,0x8
ffffffffc0204c0a:	19a50513          	addi	a0,a0,410 # ffffffffc020cda0 <etext+0x199e>
ffffffffc0204c0e:	83dfb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204c12:	999ff0ef          	jal	ffffffffc02045aa <get_fd_array.part.0>

ffffffffc0204c16 <file_seek>:
ffffffffc0204c16:	7139                	addi	sp,sp,-64
ffffffffc0204c18:	fc06                	sd	ra,56(sp)
ffffffffc0204c1a:	f426                	sd	s1,40(sp)
ffffffffc0204c1c:	04700793          	li	a5,71
ffffffffc0204c20:	0ca7e563          	bltu	a5,a0,ffffffffc0204cea <file_seek+0xd4>
ffffffffc0204c24:	00092797          	auipc	a5,0x92
ffffffffc0204c28:	ca47b783          	ld	a5,-860(a5) # ffffffffc02968c8 <current>
ffffffffc0204c2c:	f822                	sd	s0,48(sp)
ffffffffc0204c2e:	1487b783          	ld	a5,328(a5)
ffffffffc0204c32:	c3e9                	beqz	a5,ffffffffc0204cf4 <file_seek+0xde>
ffffffffc0204c34:	4b98                	lw	a4,16(a5)
ffffffffc0204c36:	0ae05f63          	blez	a4,ffffffffc0204cf4 <file_seek+0xde>
ffffffffc0204c3a:	6780                	ld	s0,8(a5)
ffffffffc0204c3c:	00351793          	slli	a5,a0,0x3
ffffffffc0204c40:	8f89                	sub	a5,a5,a0
ffffffffc0204c42:	078e                	slli	a5,a5,0x3
ffffffffc0204c44:	943e                	add	s0,s0,a5
ffffffffc0204c46:	4018                	lw	a4,0(s0)
ffffffffc0204c48:	4789                	li	a5,2
ffffffffc0204c4a:	0af71263          	bne	a4,a5,ffffffffc0204cee <file_seek+0xd8>
ffffffffc0204c4e:	4c1c                	lw	a5,24(s0)
ffffffffc0204c50:	f04a                	sd	s2,32(sp)
ffffffffc0204c52:	08a79863          	bne	a5,a0,ffffffffc0204ce2 <file_seek+0xcc>
ffffffffc0204c56:	581c                	lw	a5,48(s0)
ffffffffc0204c58:	4685                	li	a3,1
ffffffffc0204c5a:	892e                	mv	s2,a1
ffffffffc0204c5c:	2785                	addiw	a5,a5,1
ffffffffc0204c5e:	d81c                	sw	a5,48(s0)
ffffffffc0204c60:	06d60d63          	beq	a2,a3,ffffffffc0204cda <file_seek+0xc4>
ffffffffc0204c64:	04e60463          	beq	a2,a4,ffffffffc0204cac <file_seek+0x96>
ffffffffc0204c68:	54f5                	li	s1,-3
ffffffffc0204c6a:	e61d                	bnez	a2,ffffffffc0204c98 <file_seek+0x82>
ffffffffc0204c6c:	7404                	ld	s1,40(s0)
ffffffffc0204c6e:	c4d1                	beqz	s1,ffffffffc0204cfa <file_seek+0xe4>
ffffffffc0204c70:	78bc                	ld	a5,112(s1)
ffffffffc0204c72:	c7c1                	beqz	a5,ffffffffc0204cfa <file_seek+0xe4>
ffffffffc0204c74:	6fbc                	ld	a5,88(a5)
ffffffffc0204c76:	c3d1                	beqz	a5,ffffffffc0204cfa <file_seek+0xe4>
ffffffffc0204c78:	8526                	mv	a0,s1
ffffffffc0204c7a:	00008597          	auipc	a1,0x8
ffffffffc0204c7e:	3b658593          	addi	a1,a1,950 # ffffffffc020d030 <etext+0x1c2e>
ffffffffc0204c82:	1cb020ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0204c86:	78bc                	ld	a5,112(s1)
ffffffffc0204c88:	7408                	ld	a0,40(s0)
ffffffffc0204c8a:	85ca                	mv	a1,s2
ffffffffc0204c8c:	6fbc                	ld	a5,88(a5)
ffffffffc0204c8e:	9782                	jalr	a5
ffffffffc0204c90:	84aa                	mv	s1,a0
ffffffffc0204c92:	e119                	bnez	a0,ffffffffc0204c98 <file_seek+0x82>
ffffffffc0204c94:	03243023          	sd	s2,32(s0)
ffffffffc0204c98:	8522                	mv	a0,s0
ffffffffc0204c9a:	a3fff0ef          	jal	ffffffffc02046d8 <fd_array_release>
ffffffffc0204c9e:	7442                	ld	s0,48(sp)
ffffffffc0204ca0:	7902                	ld	s2,32(sp)
ffffffffc0204ca2:	70e2                	ld	ra,56(sp)
ffffffffc0204ca4:	8526                	mv	a0,s1
ffffffffc0204ca6:	74a2                	ld	s1,40(sp)
ffffffffc0204ca8:	6121                	addi	sp,sp,64
ffffffffc0204caa:	8082                	ret
ffffffffc0204cac:	7404                	ld	s1,40(s0)
ffffffffc0204cae:	c4b5                	beqz	s1,ffffffffc0204d1a <file_seek+0x104>
ffffffffc0204cb0:	78bc                	ld	a5,112(s1)
ffffffffc0204cb2:	c7a5                	beqz	a5,ffffffffc0204d1a <file_seek+0x104>
ffffffffc0204cb4:	779c                	ld	a5,40(a5)
ffffffffc0204cb6:	c3b5                	beqz	a5,ffffffffc0204d1a <file_seek+0x104>
ffffffffc0204cb8:	8526                	mv	a0,s1
ffffffffc0204cba:	00008597          	auipc	a1,0x8
ffffffffc0204cbe:	26e58593          	addi	a1,a1,622 # ffffffffc020cf28 <etext+0x1b26>
ffffffffc0204cc2:	18b020ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0204cc6:	78bc                	ld	a5,112(s1)
ffffffffc0204cc8:	7408                	ld	a0,40(s0)
ffffffffc0204cca:	858a                	mv	a1,sp
ffffffffc0204ccc:	779c                	ld	a5,40(a5)
ffffffffc0204cce:	9782                	jalr	a5
ffffffffc0204cd0:	84aa                	mv	s1,a0
ffffffffc0204cd2:	f179                	bnez	a0,ffffffffc0204c98 <file_seek+0x82>
ffffffffc0204cd4:	67e2                	ld	a5,24(sp)
ffffffffc0204cd6:	993e                	add	s2,s2,a5
ffffffffc0204cd8:	bf51                	j	ffffffffc0204c6c <file_seek+0x56>
ffffffffc0204cda:	701c                	ld	a5,32(s0)
ffffffffc0204cdc:	00f58933          	add	s2,a1,a5
ffffffffc0204ce0:	b771                	j	ffffffffc0204c6c <file_seek+0x56>
ffffffffc0204ce2:	7442                	ld	s0,48(sp)
ffffffffc0204ce4:	7902                	ld	s2,32(sp)
ffffffffc0204ce6:	54f5                	li	s1,-3
ffffffffc0204ce8:	bf6d                	j	ffffffffc0204ca2 <file_seek+0x8c>
ffffffffc0204cea:	54f5                	li	s1,-3
ffffffffc0204cec:	bf5d                	j	ffffffffc0204ca2 <file_seek+0x8c>
ffffffffc0204cee:	7442                	ld	s0,48(sp)
ffffffffc0204cf0:	54f5                	li	s1,-3
ffffffffc0204cf2:	bf45                	j	ffffffffc0204ca2 <file_seek+0x8c>
ffffffffc0204cf4:	f04a                	sd	s2,32(sp)
ffffffffc0204cf6:	8b5ff0ef          	jal	ffffffffc02045aa <get_fd_array.part.0>
ffffffffc0204cfa:	00008697          	auipc	a3,0x8
ffffffffc0204cfe:	2e668693          	addi	a3,a3,742 # ffffffffc020cfe0 <etext+0x1bde>
ffffffffc0204d02:	00007617          	auipc	a2,0x7
ffffffffc0204d06:	b3e60613          	addi	a2,a2,-1218 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204d0a:	11a00593          	li	a1,282
ffffffffc0204d0e:	00008517          	auipc	a0,0x8
ffffffffc0204d12:	09250513          	addi	a0,a0,146 # ffffffffc020cda0 <etext+0x199e>
ffffffffc0204d16:	f34fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204d1a:	00008697          	auipc	a3,0x8
ffffffffc0204d1e:	1be68693          	addi	a3,a3,446 # ffffffffc020ced8 <etext+0x1ad6>
ffffffffc0204d22:	00007617          	auipc	a2,0x7
ffffffffc0204d26:	b1e60613          	addi	a2,a2,-1250 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204d2a:	11200593          	li	a1,274
ffffffffc0204d2e:	00008517          	auipc	a0,0x8
ffffffffc0204d32:	07250513          	addi	a0,a0,114 # ffffffffc020cda0 <etext+0x199e>
ffffffffc0204d36:	f14fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204d3a <file_fstat>:
ffffffffc0204d3a:	7179                	addi	sp,sp,-48
ffffffffc0204d3c:	f406                	sd	ra,40(sp)
ffffffffc0204d3e:	f022                	sd	s0,32(sp)
ffffffffc0204d40:	04700793          	li	a5,71
ffffffffc0204d44:	08a7e363          	bltu	a5,a0,ffffffffc0204dca <file_fstat+0x90>
ffffffffc0204d48:	00092797          	auipc	a5,0x92
ffffffffc0204d4c:	b807b783          	ld	a5,-1152(a5) # ffffffffc02968c8 <current>
ffffffffc0204d50:	ec26                	sd	s1,24(sp)
ffffffffc0204d52:	84ae                	mv	s1,a1
ffffffffc0204d54:	1487b783          	ld	a5,328(a5)
ffffffffc0204d58:	cbd9                	beqz	a5,ffffffffc0204dee <file_fstat+0xb4>
ffffffffc0204d5a:	4b98                	lw	a4,16(a5)
ffffffffc0204d5c:	08e05963          	blez	a4,ffffffffc0204dee <file_fstat+0xb4>
ffffffffc0204d60:	6780                	ld	s0,8(a5)
ffffffffc0204d62:	00351793          	slli	a5,a0,0x3
ffffffffc0204d66:	8f89                	sub	a5,a5,a0
ffffffffc0204d68:	078e                	slli	a5,a5,0x3
ffffffffc0204d6a:	943e                	add	s0,s0,a5
ffffffffc0204d6c:	4018                	lw	a4,0(s0)
ffffffffc0204d6e:	4789                	li	a5,2
ffffffffc0204d70:	04f71663          	bne	a4,a5,ffffffffc0204dbc <file_fstat+0x82>
ffffffffc0204d74:	4c1c                	lw	a5,24(s0)
ffffffffc0204d76:	04a79363          	bne	a5,a0,ffffffffc0204dbc <file_fstat+0x82>
ffffffffc0204d7a:	581c                	lw	a5,48(s0)
ffffffffc0204d7c:	7408                	ld	a0,40(s0)
ffffffffc0204d7e:	2785                	addiw	a5,a5,1
ffffffffc0204d80:	d81c                	sw	a5,48(s0)
ffffffffc0204d82:	c531                	beqz	a0,ffffffffc0204dce <file_fstat+0x94>
ffffffffc0204d84:	793c                	ld	a5,112(a0)
ffffffffc0204d86:	c7a1                	beqz	a5,ffffffffc0204dce <file_fstat+0x94>
ffffffffc0204d88:	779c                	ld	a5,40(a5)
ffffffffc0204d8a:	c3b1                	beqz	a5,ffffffffc0204dce <file_fstat+0x94>
ffffffffc0204d8c:	00008597          	auipc	a1,0x8
ffffffffc0204d90:	19c58593          	addi	a1,a1,412 # ffffffffc020cf28 <etext+0x1b26>
ffffffffc0204d94:	e42a                	sd	a0,8(sp)
ffffffffc0204d96:	0b7020ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0204d9a:	6522                	ld	a0,8(sp)
ffffffffc0204d9c:	85a6                	mv	a1,s1
ffffffffc0204d9e:	793c                	ld	a5,112(a0)
ffffffffc0204da0:	7408                	ld	a0,40(s0)
ffffffffc0204da2:	779c                	ld	a5,40(a5)
ffffffffc0204da4:	9782                	jalr	a5
ffffffffc0204da6:	87aa                	mv	a5,a0
ffffffffc0204da8:	8522                	mv	a0,s0
ffffffffc0204daa:	843e                	mv	s0,a5
ffffffffc0204dac:	92dff0ef          	jal	ffffffffc02046d8 <fd_array_release>
ffffffffc0204db0:	64e2                	ld	s1,24(sp)
ffffffffc0204db2:	70a2                	ld	ra,40(sp)
ffffffffc0204db4:	8522                	mv	a0,s0
ffffffffc0204db6:	7402                	ld	s0,32(sp)
ffffffffc0204db8:	6145                	addi	sp,sp,48
ffffffffc0204dba:	8082                	ret
ffffffffc0204dbc:	5475                	li	s0,-3
ffffffffc0204dbe:	70a2                	ld	ra,40(sp)
ffffffffc0204dc0:	8522                	mv	a0,s0
ffffffffc0204dc2:	7402                	ld	s0,32(sp)
ffffffffc0204dc4:	64e2                	ld	s1,24(sp)
ffffffffc0204dc6:	6145                	addi	sp,sp,48
ffffffffc0204dc8:	8082                	ret
ffffffffc0204dca:	5475                	li	s0,-3
ffffffffc0204dcc:	b7dd                	j	ffffffffc0204db2 <file_fstat+0x78>
ffffffffc0204dce:	00008697          	auipc	a3,0x8
ffffffffc0204dd2:	10a68693          	addi	a3,a3,266 # ffffffffc020ced8 <etext+0x1ad6>
ffffffffc0204dd6:	00007617          	auipc	a2,0x7
ffffffffc0204dda:	a6a60613          	addi	a2,a2,-1430 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204dde:	12c00593          	li	a1,300
ffffffffc0204de2:	00008517          	auipc	a0,0x8
ffffffffc0204de6:	fbe50513          	addi	a0,a0,-66 # ffffffffc020cda0 <etext+0x199e>
ffffffffc0204dea:	e60fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204dee:	fbcff0ef          	jal	ffffffffc02045aa <get_fd_array.part.0>

ffffffffc0204df2 <file_fsync>:
ffffffffc0204df2:	1101                	addi	sp,sp,-32
ffffffffc0204df4:	ec06                	sd	ra,24(sp)
ffffffffc0204df6:	e822                	sd	s0,16(sp)
ffffffffc0204df8:	04700793          	li	a5,71
ffffffffc0204dfc:	06a7e863          	bltu	a5,a0,ffffffffc0204e6c <file_fsync+0x7a>
ffffffffc0204e00:	00092797          	auipc	a5,0x92
ffffffffc0204e04:	ac87b783          	ld	a5,-1336(a5) # ffffffffc02968c8 <current>
ffffffffc0204e08:	1487b783          	ld	a5,328(a5)
ffffffffc0204e0c:	c7d1                	beqz	a5,ffffffffc0204e98 <file_fsync+0xa6>
ffffffffc0204e0e:	4b98                	lw	a4,16(a5)
ffffffffc0204e10:	08e05463          	blez	a4,ffffffffc0204e98 <file_fsync+0xa6>
ffffffffc0204e14:	6780                	ld	s0,8(a5)
ffffffffc0204e16:	00351793          	slli	a5,a0,0x3
ffffffffc0204e1a:	8f89                	sub	a5,a5,a0
ffffffffc0204e1c:	078e                	slli	a5,a5,0x3
ffffffffc0204e1e:	943e                	add	s0,s0,a5
ffffffffc0204e20:	4018                	lw	a4,0(s0)
ffffffffc0204e22:	4789                	li	a5,2
ffffffffc0204e24:	04f71463          	bne	a4,a5,ffffffffc0204e6c <file_fsync+0x7a>
ffffffffc0204e28:	4c1c                	lw	a5,24(s0)
ffffffffc0204e2a:	04a79163          	bne	a5,a0,ffffffffc0204e6c <file_fsync+0x7a>
ffffffffc0204e2e:	581c                	lw	a5,48(s0)
ffffffffc0204e30:	7408                	ld	a0,40(s0)
ffffffffc0204e32:	2785                	addiw	a5,a5,1
ffffffffc0204e34:	d81c                	sw	a5,48(s0)
ffffffffc0204e36:	c129                	beqz	a0,ffffffffc0204e78 <file_fsync+0x86>
ffffffffc0204e38:	793c                	ld	a5,112(a0)
ffffffffc0204e3a:	cf9d                	beqz	a5,ffffffffc0204e78 <file_fsync+0x86>
ffffffffc0204e3c:	7b9c                	ld	a5,48(a5)
ffffffffc0204e3e:	cf8d                	beqz	a5,ffffffffc0204e78 <file_fsync+0x86>
ffffffffc0204e40:	00008597          	auipc	a1,0x8
ffffffffc0204e44:	24858593          	addi	a1,a1,584 # ffffffffc020d088 <etext+0x1c86>
ffffffffc0204e48:	e42a                	sd	a0,8(sp)
ffffffffc0204e4a:	003020ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0204e4e:	6522                	ld	a0,8(sp)
ffffffffc0204e50:	793c                	ld	a5,112(a0)
ffffffffc0204e52:	7408                	ld	a0,40(s0)
ffffffffc0204e54:	7b9c                	ld	a5,48(a5)
ffffffffc0204e56:	9782                	jalr	a5
ffffffffc0204e58:	87aa                	mv	a5,a0
ffffffffc0204e5a:	8522                	mv	a0,s0
ffffffffc0204e5c:	843e                	mv	s0,a5
ffffffffc0204e5e:	87bff0ef          	jal	ffffffffc02046d8 <fd_array_release>
ffffffffc0204e62:	60e2                	ld	ra,24(sp)
ffffffffc0204e64:	8522                	mv	a0,s0
ffffffffc0204e66:	6442                	ld	s0,16(sp)
ffffffffc0204e68:	6105                	addi	sp,sp,32
ffffffffc0204e6a:	8082                	ret
ffffffffc0204e6c:	5475                	li	s0,-3
ffffffffc0204e6e:	60e2                	ld	ra,24(sp)
ffffffffc0204e70:	8522                	mv	a0,s0
ffffffffc0204e72:	6442                	ld	s0,16(sp)
ffffffffc0204e74:	6105                	addi	sp,sp,32
ffffffffc0204e76:	8082                	ret
ffffffffc0204e78:	00008697          	auipc	a3,0x8
ffffffffc0204e7c:	1c068693          	addi	a3,a3,448 # ffffffffc020d038 <etext+0x1c36>
ffffffffc0204e80:	00007617          	auipc	a2,0x7
ffffffffc0204e84:	9c060613          	addi	a2,a2,-1600 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204e88:	13a00593          	li	a1,314
ffffffffc0204e8c:	00008517          	auipc	a0,0x8
ffffffffc0204e90:	f1450513          	addi	a0,a0,-236 # ffffffffc020cda0 <etext+0x199e>
ffffffffc0204e94:	db6fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204e98:	f12ff0ef          	jal	ffffffffc02045aa <get_fd_array.part.0>

ffffffffc0204e9c <file_getdirentry>:
ffffffffc0204e9c:	715d                	addi	sp,sp,-80
ffffffffc0204e9e:	e486                	sd	ra,72(sp)
ffffffffc0204ea0:	f84a                	sd	s2,48(sp)
ffffffffc0204ea2:	04700793          	li	a5,71
ffffffffc0204ea6:	0aa7e963          	bltu	a5,a0,ffffffffc0204f58 <file_getdirentry+0xbc>
ffffffffc0204eaa:	00092797          	auipc	a5,0x92
ffffffffc0204eae:	a1e7b783          	ld	a5,-1506(a5) # ffffffffc02968c8 <current>
ffffffffc0204eb2:	fc26                	sd	s1,56(sp)
ffffffffc0204eb4:	e0a2                	sd	s0,64(sp)
ffffffffc0204eb6:	1487b783          	ld	a5,328(a5)
ffffffffc0204eba:	84ae                	mv	s1,a1
ffffffffc0204ebc:	c7e1                	beqz	a5,ffffffffc0204f84 <file_getdirentry+0xe8>
ffffffffc0204ebe:	4b98                	lw	a4,16(a5)
ffffffffc0204ec0:	0ce05263          	blez	a4,ffffffffc0204f84 <file_getdirentry+0xe8>
ffffffffc0204ec4:	6780                	ld	s0,8(a5)
ffffffffc0204ec6:	00351793          	slli	a5,a0,0x3
ffffffffc0204eca:	8f89                	sub	a5,a5,a0
ffffffffc0204ecc:	078e                	slli	a5,a5,0x3
ffffffffc0204ece:	943e                	add	s0,s0,a5
ffffffffc0204ed0:	4018                	lw	a4,0(s0)
ffffffffc0204ed2:	4789                	li	a5,2
ffffffffc0204ed4:	08f71463          	bne	a4,a5,ffffffffc0204f5c <file_getdirentry+0xc0>
ffffffffc0204ed8:	4c1c                	lw	a5,24(s0)
ffffffffc0204eda:	f44e                	sd	s3,40(sp)
ffffffffc0204edc:	06a79963          	bne	a5,a0,ffffffffc0204f4e <file_getdirentry+0xb2>
ffffffffc0204ee0:	581c                	lw	a5,48(s0)
ffffffffc0204ee2:	6194                	ld	a3,0(a1)
ffffffffc0204ee4:	10000613          	li	a2,256
ffffffffc0204ee8:	2785                	addiw	a5,a5,1
ffffffffc0204eea:	d81c                	sw	a5,48(s0)
ffffffffc0204eec:	05a1                	addi	a1,a1,8
ffffffffc0204eee:	850a                	mv	a0,sp
ffffffffc0204ef0:	342000ef          	jal	ffffffffc0205232 <iobuf_init>
ffffffffc0204ef4:	02843903          	ld	s2,40(s0)
ffffffffc0204ef8:	89aa                	mv	s3,a0
ffffffffc0204efa:	06090563          	beqz	s2,ffffffffc0204f64 <file_getdirentry+0xc8>
ffffffffc0204efe:	07093783          	ld	a5,112(s2)
ffffffffc0204f02:	c3ad                	beqz	a5,ffffffffc0204f64 <file_getdirentry+0xc8>
ffffffffc0204f04:	63bc                	ld	a5,64(a5)
ffffffffc0204f06:	cfb9                	beqz	a5,ffffffffc0204f64 <file_getdirentry+0xc8>
ffffffffc0204f08:	854a                	mv	a0,s2
ffffffffc0204f0a:	00008597          	auipc	a1,0x8
ffffffffc0204f0e:	1de58593          	addi	a1,a1,478 # ffffffffc020d0e8 <etext+0x1ce6>
ffffffffc0204f12:	73a020ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0204f16:	07093783          	ld	a5,112(s2)
ffffffffc0204f1a:	7408                	ld	a0,40(s0)
ffffffffc0204f1c:	85ce                	mv	a1,s3
ffffffffc0204f1e:	63bc                	ld	a5,64(a5)
ffffffffc0204f20:	9782                	jalr	a5
ffffffffc0204f22:	892a                	mv	s2,a0
ffffffffc0204f24:	cd01                	beqz	a0,ffffffffc0204f3c <file_getdirentry+0xa0>
ffffffffc0204f26:	8522                	mv	a0,s0
ffffffffc0204f28:	fb0ff0ef          	jal	ffffffffc02046d8 <fd_array_release>
ffffffffc0204f2c:	6406                	ld	s0,64(sp)
ffffffffc0204f2e:	74e2                	ld	s1,56(sp)
ffffffffc0204f30:	79a2                	ld	s3,40(sp)
ffffffffc0204f32:	60a6                	ld	ra,72(sp)
ffffffffc0204f34:	854a                	mv	a0,s2
ffffffffc0204f36:	7942                	ld	s2,48(sp)
ffffffffc0204f38:	6161                	addi	sp,sp,80
ffffffffc0204f3a:	8082                	ret
ffffffffc0204f3c:	609c                	ld	a5,0(s1)
ffffffffc0204f3e:	0109b683          	ld	a3,16(s3)
ffffffffc0204f42:	0189b703          	ld	a4,24(s3)
ffffffffc0204f46:	97b6                	add	a5,a5,a3
ffffffffc0204f48:	8f99                	sub	a5,a5,a4
ffffffffc0204f4a:	e09c                	sd	a5,0(s1)
ffffffffc0204f4c:	bfe9                	j	ffffffffc0204f26 <file_getdirentry+0x8a>
ffffffffc0204f4e:	6406                	ld	s0,64(sp)
ffffffffc0204f50:	74e2                	ld	s1,56(sp)
ffffffffc0204f52:	79a2                	ld	s3,40(sp)
ffffffffc0204f54:	5975                	li	s2,-3
ffffffffc0204f56:	bff1                	j	ffffffffc0204f32 <file_getdirentry+0x96>
ffffffffc0204f58:	5975                	li	s2,-3
ffffffffc0204f5a:	bfe1                	j	ffffffffc0204f32 <file_getdirentry+0x96>
ffffffffc0204f5c:	6406                	ld	s0,64(sp)
ffffffffc0204f5e:	74e2                	ld	s1,56(sp)
ffffffffc0204f60:	5975                	li	s2,-3
ffffffffc0204f62:	bfc1                	j	ffffffffc0204f32 <file_getdirentry+0x96>
ffffffffc0204f64:	00008697          	auipc	a3,0x8
ffffffffc0204f68:	12c68693          	addi	a3,a3,300 # ffffffffc020d090 <etext+0x1c8e>
ffffffffc0204f6c:	00007617          	auipc	a2,0x7
ffffffffc0204f70:	8d460613          	addi	a2,a2,-1836 # ffffffffc020b840 <etext+0x43e>
ffffffffc0204f74:	14a00593          	li	a1,330
ffffffffc0204f78:	00008517          	auipc	a0,0x8
ffffffffc0204f7c:	e2850513          	addi	a0,a0,-472 # ffffffffc020cda0 <etext+0x199e>
ffffffffc0204f80:	ccafb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204f84:	f44e                	sd	s3,40(sp)
ffffffffc0204f86:	e24ff0ef          	jal	ffffffffc02045aa <get_fd_array.part.0>

ffffffffc0204f8a <file_dup>:
ffffffffc0204f8a:	04700713          	li	a4,71
ffffffffc0204f8e:	06a76263          	bltu	a4,a0,ffffffffc0204ff2 <file_dup+0x68>
ffffffffc0204f92:	00092717          	auipc	a4,0x92
ffffffffc0204f96:	93673703          	ld	a4,-1738(a4) # ffffffffc02968c8 <current>
ffffffffc0204f9a:	7179                	addi	sp,sp,-48
ffffffffc0204f9c:	f406                	sd	ra,40(sp)
ffffffffc0204f9e:	14873703          	ld	a4,328(a4)
ffffffffc0204fa2:	f022                	sd	s0,32(sp)
ffffffffc0204fa4:	87aa                	mv	a5,a0
ffffffffc0204fa6:	852e                	mv	a0,a1
ffffffffc0204fa8:	c739                	beqz	a4,ffffffffc0204ff6 <file_dup+0x6c>
ffffffffc0204faa:	4b14                	lw	a3,16(a4)
ffffffffc0204fac:	04d05563          	blez	a3,ffffffffc0204ff6 <file_dup+0x6c>
ffffffffc0204fb0:	6700                	ld	s0,8(a4)
ffffffffc0204fb2:	00379713          	slli	a4,a5,0x3
ffffffffc0204fb6:	8f1d                	sub	a4,a4,a5
ffffffffc0204fb8:	070e                	slli	a4,a4,0x3
ffffffffc0204fba:	943a                	add	s0,s0,a4
ffffffffc0204fbc:	4014                	lw	a3,0(s0)
ffffffffc0204fbe:	4709                	li	a4,2
ffffffffc0204fc0:	02e69463          	bne	a3,a4,ffffffffc0204fe8 <file_dup+0x5e>
ffffffffc0204fc4:	4c18                	lw	a4,24(s0)
ffffffffc0204fc6:	02f71163          	bne	a4,a5,ffffffffc0204fe8 <file_dup+0x5e>
ffffffffc0204fca:	082c                	addi	a1,sp,24
ffffffffc0204fcc:	e00ff0ef          	jal	ffffffffc02045cc <fd_array_alloc>
ffffffffc0204fd0:	e901                	bnez	a0,ffffffffc0204fe0 <file_dup+0x56>
ffffffffc0204fd2:	6562                	ld	a0,24(sp)
ffffffffc0204fd4:	85a2                	mv	a1,s0
ffffffffc0204fd6:	e42a                	sd	a0,8(sp)
ffffffffc0204fd8:	821ff0ef          	jal	ffffffffc02047f8 <fd_array_dup>
ffffffffc0204fdc:	6522                	ld	a0,8(sp)
ffffffffc0204fde:	4d08                	lw	a0,24(a0)
ffffffffc0204fe0:	70a2                	ld	ra,40(sp)
ffffffffc0204fe2:	7402                	ld	s0,32(sp)
ffffffffc0204fe4:	6145                	addi	sp,sp,48
ffffffffc0204fe6:	8082                	ret
ffffffffc0204fe8:	70a2                	ld	ra,40(sp)
ffffffffc0204fea:	7402                	ld	s0,32(sp)
ffffffffc0204fec:	5575                	li	a0,-3
ffffffffc0204fee:	6145                	addi	sp,sp,48
ffffffffc0204ff0:	8082                	ret
ffffffffc0204ff2:	5575                	li	a0,-3
ffffffffc0204ff4:	8082                	ret
ffffffffc0204ff6:	db4ff0ef          	jal	ffffffffc02045aa <get_fd_array.part.0>

ffffffffc0204ffa <fs_init>:
ffffffffc0204ffa:	1141                	addi	sp,sp,-16
ffffffffc0204ffc:	e406                	sd	ra,8(sp)
ffffffffc0204ffe:	059020ef          	jal	ffffffffc0207856 <vfs_init>
ffffffffc0205002:	566030ef          	jal	ffffffffc0208568 <dev_init>
ffffffffc0205006:	60a2                	ld	ra,8(sp)
ffffffffc0205008:	0141                	addi	sp,sp,16
ffffffffc020500a:	6db0306f          	j	ffffffffc0208ee4 <sfs_init>

ffffffffc020500e <fs_cleanup>:
ffffffffc020500e:	2c50206f          	j	ffffffffc0207ad2 <vfs_cleanup>

ffffffffc0205012 <lock_files>:
ffffffffc0205012:	0561                	addi	a0,a0,24
ffffffffc0205014:	b88ff06f          	j	ffffffffc020439c <down>

ffffffffc0205018 <unlock_files>:
ffffffffc0205018:	0561                	addi	a0,a0,24
ffffffffc020501a:	b7eff06f          	j	ffffffffc0204398 <up>

ffffffffc020501e <files_create>:
ffffffffc020501e:	1141                	addi	sp,sp,-16
ffffffffc0205020:	6505                	lui	a0,0x1
ffffffffc0205022:	e022                	sd	s0,0(sp)
ffffffffc0205024:	e406                	sd	ra,8(sp)
ffffffffc0205026:	faffc0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc020502a:	842a                	mv	s0,a0
ffffffffc020502c:	cd19                	beqz	a0,ffffffffc020504a <files_create+0x2c>
ffffffffc020502e:	03050793          	addi	a5,a0,48 # 1030 <_binary_bin_swap_img_size-0x6cd0>
ffffffffc0205032:	e51c                	sd	a5,8(a0)
ffffffffc0205034:	00053023          	sd	zero,0(a0)
ffffffffc0205038:	00052823          	sw	zero,16(a0)
ffffffffc020503c:	4585                	li	a1,1
ffffffffc020503e:	0561                	addi	a0,a0,24
ffffffffc0205040:	b52ff0ef          	jal	ffffffffc0204392 <sem_init>
ffffffffc0205044:	6408                	ld	a0,8(s0)
ffffffffc0205046:	f1eff0ef          	jal	ffffffffc0204764 <fd_array_init>
ffffffffc020504a:	60a2                	ld	ra,8(sp)
ffffffffc020504c:	8522                	mv	a0,s0
ffffffffc020504e:	6402                	ld	s0,0(sp)
ffffffffc0205050:	0141                	addi	sp,sp,16
ffffffffc0205052:	8082                	ret

ffffffffc0205054 <files_destroy>:
ffffffffc0205054:	7179                	addi	sp,sp,-48
ffffffffc0205056:	f406                	sd	ra,40(sp)
ffffffffc0205058:	f022                	sd	s0,32(sp)
ffffffffc020505a:	ec26                	sd	s1,24(sp)
ffffffffc020505c:	e84a                	sd	s2,16(sp)
ffffffffc020505e:	e44e                	sd	s3,8(sp)
ffffffffc0205060:	c52d                	beqz	a0,ffffffffc02050ca <files_destroy+0x76>
ffffffffc0205062:	491c                	lw	a5,16(a0)
ffffffffc0205064:	89aa                	mv	s3,a0
ffffffffc0205066:	e3b5                	bnez	a5,ffffffffc02050ca <files_destroy+0x76>
ffffffffc0205068:	6108                	ld	a0,0(a0)
ffffffffc020506a:	c119                	beqz	a0,ffffffffc0205070 <files_destroy+0x1c>
ffffffffc020506c:	69a020ef          	jal	ffffffffc0207706 <inode_ref_dec>
ffffffffc0205070:	0089b403          	ld	s0,8(s3)
ffffffffc0205074:	4909                	li	s2,2
ffffffffc0205076:	7ff40493          	addi	s1,s0,2047
ffffffffc020507a:	7c148493          	addi	s1,s1,1985
ffffffffc020507e:	401c                	lw	a5,0(s0)
ffffffffc0205080:	03278063          	beq	a5,s2,ffffffffc02050a0 <files_destroy+0x4c>
ffffffffc0205084:	e39d                	bnez	a5,ffffffffc02050aa <files_destroy+0x56>
ffffffffc0205086:	03840413          	addi	s0,s0,56
ffffffffc020508a:	fe941ae3          	bne	s0,s1,ffffffffc020507e <files_destroy+0x2a>
ffffffffc020508e:	7402                	ld	s0,32(sp)
ffffffffc0205090:	70a2                	ld	ra,40(sp)
ffffffffc0205092:	64e2                	ld	s1,24(sp)
ffffffffc0205094:	6942                	ld	s2,16(sp)
ffffffffc0205096:	854e                	mv	a0,s3
ffffffffc0205098:	69a2                	ld	s3,8(sp)
ffffffffc020509a:	6145                	addi	sp,sp,48
ffffffffc020509c:	fdffc06f          	j	ffffffffc020207a <kfree>
ffffffffc02050a0:	8522                	mv	a0,s0
ffffffffc02050a2:	edeff0ef          	jal	ffffffffc0204780 <fd_array_close>
ffffffffc02050a6:	401c                	lw	a5,0(s0)
ffffffffc02050a8:	bff1                	j	ffffffffc0205084 <files_destroy+0x30>
ffffffffc02050aa:	00008697          	auipc	a3,0x8
ffffffffc02050ae:	08e68693          	addi	a3,a3,142 # ffffffffc020d138 <etext+0x1d36>
ffffffffc02050b2:	00006617          	auipc	a2,0x6
ffffffffc02050b6:	78e60613          	addi	a2,a2,1934 # ffffffffc020b840 <etext+0x43e>
ffffffffc02050ba:	03d00593          	li	a1,61
ffffffffc02050be:	00008517          	auipc	a0,0x8
ffffffffc02050c2:	06a50513          	addi	a0,a0,106 # ffffffffc020d128 <etext+0x1d26>
ffffffffc02050c6:	b84fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02050ca:	00008697          	auipc	a3,0x8
ffffffffc02050ce:	02e68693          	addi	a3,a3,46 # ffffffffc020d0f8 <etext+0x1cf6>
ffffffffc02050d2:	00006617          	auipc	a2,0x6
ffffffffc02050d6:	76e60613          	addi	a2,a2,1902 # ffffffffc020b840 <etext+0x43e>
ffffffffc02050da:	03300593          	li	a1,51
ffffffffc02050de:	00008517          	auipc	a0,0x8
ffffffffc02050e2:	04a50513          	addi	a0,a0,74 # ffffffffc020d128 <etext+0x1d26>
ffffffffc02050e6:	b64fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02050ea <files_closeall>:
ffffffffc02050ea:	1101                	addi	sp,sp,-32
ffffffffc02050ec:	ec06                	sd	ra,24(sp)
ffffffffc02050ee:	e822                	sd	s0,16(sp)
ffffffffc02050f0:	e426                	sd	s1,8(sp)
ffffffffc02050f2:	e04a                	sd	s2,0(sp)
ffffffffc02050f4:	c129                	beqz	a0,ffffffffc0205136 <files_closeall+0x4c>
ffffffffc02050f6:	491c                	lw	a5,16(a0)
ffffffffc02050f8:	02f05f63          	blez	a5,ffffffffc0205136 <files_closeall+0x4c>
ffffffffc02050fc:	6500                	ld	s0,8(a0)
ffffffffc02050fe:	4909                	li	s2,2
ffffffffc0205100:	7ff40493          	addi	s1,s0,2047
ffffffffc0205104:	7c148493          	addi	s1,s1,1985
ffffffffc0205108:	07040413          	addi	s0,s0,112
ffffffffc020510c:	a029                	j	ffffffffc0205116 <files_closeall+0x2c>
ffffffffc020510e:	03840413          	addi	s0,s0,56
ffffffffc0205112:	00940c63          	beq	s0,s1,ffffffffc020512a <files_closeall+0x40>
ffffffffc0205116:	401c                	lw	a5,0(s0)
ffffffffc0205118:	ff279be3          	bne	a5,s2,ffffffffc020510e <files_closeall+0x24>
ffffffffc020511c:	8522                	mv	a0,s0
ffffffffc020511e:	03840413          	addi	s0,s0,56
ffffffffc0205122:	e5eff0ef          	jal	ffffffffc0204780 <fd_array_close>
ffffffffc0205126:	fe9418e3          	bne	s0,s1,ffffffffc0205116 <files_closeall+0x2c>
ffffffffc020512a:	60e2                	ld	ra,24(sp)
ffffffffc020512c:	6442                	ld	s0,16(sp)
ffffffffc020512e:	64a2                	ld	s1,8(sp)
ffffffffc0205130:	6902                	ld	s2,0(sp)
ffffffffc0205132:	6105                	addi	sp,sp,32
ffffffffc0205134:	8082                	ret
ffffffffc0205136:	00008697          	auipc	a3,0x8
ffffffffc020513a:	c3a68693          	addi	a3,a3,-966 # ffffffffc020cd70 <etext+0x196e>
ffffffffc020513e:	00006617          	auipc	a2,0x6
ffffffffc0205142:	70260613          	addi	a2,a2,1794 # ffffffffc020b840 <etext+0x43e>
ffffffffc0205146:	04500593          	li	a1,69
ffffffffc020514a:	00008517          	auipc	a0,0x8
ffffffffc020514e:	fde50513          	addi	a0,a0,-34 # ffffffffc020d128 <etext+0x1d26>
ffffffffc0205152:	af8fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205156 <dup_files>:
ffffffffc0205156:	7179                	addi	sp,sp,-48
ffffffffc0205158:	f406                	sd	ra,40(sp)
ffffffffc020515a:	f022                	sd	s0,32(sp)
ffffffffc020515c:	ec26                	sd	s1,24(sp)
ffffffffc020515e:	e84a                	sd	s2,16(sp)
ffffffffc0205160:	e44e                	sd	s3,8(sp)
ffffffffc0205162:	e052                	sd	s4,0(sp)
ffffffffc0205164:	c52d                	beqz	a0,ffffffffc02051ce <dup_files+0x78>
ffffffffc0205166:	842e                	mv	s0,a1
ffffffffc0205168:	c1bd                	beqz	a1,ffffffffc02051ce <dup_files+0x78>
ffffffffc020516a:	491c                	lw	a5,16(a0)
ffffffffc020516c:	84aa                	mv	s1,a0
ffffffffc020516e:	e3c1                	bnez	a5,ffffffffc02051ee <dup_files+0x98>
ffffffffc0205170:	499c                	lw	a5,16(a1)
ffffffffc0205172:	06f05e63          	blez	a5,ffffffffc02051ee <dup_files+0x98>
ffffffffc0205176:	6188                	ld	a0,0(a1)
ffffffffc0205178:	e088                	sd	a0,0(s1)
ffffffffc020517a:	c119                	beqz	a0,ffffffffc0205180 <dup_files+0x2a>
ffffffffc020517c:	4bc020ef          	jal	ffffffffc0207638 <inode_ref_inc>
ffffffffc0205180:	6400                	ld	s0,8(s0)
ffffffffc0205182:	6484                	ld	s1,8(s1)
ffffffffc0205184:	4989                	li	s3,2
ffffffffc0205186:	7ff40913          	addi	s2,s0,2047
ffffffffc020518a:	7c190913          	addi	s2,s2,1985
ffffffffc020518e:	4a05                	li	s4,1
ffffffffc0205190:	a039                	j	ffffffffc020519e <dup_files+0x48>
ffffffffc0205192:	03840413          	addi	s0,s0,56
ffffffffc0205196:	03848493          	addi	s1,s1,56
ffffffffc020519a:	03240163          	beq	s0,s2,ffffffffc02051bc <dup_files+0x66>
ffffffffc020519e:	401c                	lw	a5,0(s0)
ffffffffc02051a0:	ff3799e3          	bne	a5,s3,ffffffffc0205192 <dup_files+0x3c>
ffffffffc02051a4:	0144a023          	sw	s4,0(s1)
ffffffffc02051a8:	85a2                	mv	a1,s0
ffffffffc02051aa:	8526                	mv	a0,s1
ffffffffc02051ac:	03840413          	addi	s0,s0,56
ffffffffc02051b0:	e48ff0ef          	jal	ffffffffc02047f8 <fd_array_dup>
ffffffffc02051b4:	03848493          	addi	s1,s1,56
ffffffffc02051b8:	ff2413e3          	bne	s0,s2,ffffffffc020519e <dup_files+0x48>
ffffffffc02051bc:	70a2                	ld	ra,40(sp)
ffffffffc02051be:	7402                	ld	s0,32(sp)
ffffffffc02051c0:	64e2                	ld	s1,24(sp)
ffffffffc02051c2:	6942                	ld	s2,16(sp)
ffffffffc02051c4:	69a2                	ld	s3,8(sp)
ffffffffc02051c6:	6a02                	ld	s4,0(sp)
ffffffffc02051c8:	4501                	li	a0,0
ffffffffc02051ca:	6145                	addi	sp,sp,48
ffffffffc02051cc:	8082                	ret
ffffffffc02051ce:	00008697          	auipc	a3,0x8
ffffffffc02051d2:	8f268693          	addi	a3,a3,-1806 # ffffffffc020cac0 <etext+0x16be>
ffffffffc02051d6:	00006617          	auipc	a2,0x6
ffffffffc02051da:	66a60613          	addi	a2,a2,1642 # ffffffffc020b840 <etext+0x43e>
ffffffffc02051de:	05300593          	li	a1,83
ffffffffc02051e2:	00008517          	auipc	a0,0x8
ffffffffc02051e6:	f4650513          	addi	a0,a0,-186 # ffffffffc020d128 <etext+0x1d26>
ffffffffc02051ea:	a60fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02051ee:	00008697          	auipc	a3,0x8
ffffffffc02051f2:	f6268693          	addi	a3,a3,-158 # ffffffffc020d150 <etext+0x1d4e>
ffffffffc02051f6:	00006617          	auipc	a2,0x6
ffffffffc02051fa:	64a60613          	addi	a2,a2,1610 # ffffffffc020b840 <etext+0x43e>
ffffffffc02051fe:	05400593          	li	a1,84
ffffffffc0205202:	00008517          	auipc	a0,0x8
ffffffffc0205206:	f2650513          	addi	a0,a0,-218 # ffffffffc020d128 <etext+0x1d26>
ffffffffc020520a:	a40fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020520e <iobuf_skip.part.0>:
ffffffffc020520e:	1141                	addi	sp,sp,-16
ffffffffc0205210:	00008697          	auipc	a3,0x8
ffffffffc0205214:	f7068693          	addi	a3,a3,-144 # ffffffffc020d180 <etext+0x1d7e>
ffffffffc0205218:	00006617          	auipc	a2,0x6
ffffffffc020521c:	62860613          	addi	a2,a2,1576 # ffffffffc020b840 <etext+0x43e>
ffffffffc0205220:	04a00593          	li	a1,74
ffffffffc0205224:	00008517          	auipc	a0,0x8
ffffffffc0205228:	f7450513          	addi	a0,a0,-140 # ffffffffc020d198 <etext+0x1d96>
ffffffffc020522c:	e406                	sd	ra,8(sp)
ffffffffc020522e:	a1cfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205232 <iobuf_init>:
ffffffffc0205232:	e10c                	sd	a1,0(a0)
ffffffffc0205234:	e514                	sd	a3,8(a0)
ffffffffc0205236:	ed10                	sd	a2,24(a0)
ffffffffc0205238:	e910                	sd	a2,16(a0)
ffffffffc020523a:	8082                	ret

ffffffffc020523c <iobuf_move>:
ffffffffc020523c:	6d1c                	ld	a5,24(a0)
ffffffffc020523e:	88aa                	mv	a7,a0
ffffffffc0205240:	8832                	mv	a6,a2
ffffffffc0205242:	00f67363          	bgeu	a2,a5,ffffffffc0205248 <iobuf_move+0xc>
ffffffffc0205246:	87b2                	mv	a5,a2
ffffffffc0205248:	cfa1                	beqz	a5,ffffffffc02052a0 <iobuf_move+0x64>
ffffffffc020524a:	7179                	addi	sp,sp,-48
ffffffffc020524c:	f406                	sd	ra,40(sp)
ffffffffc020524e:	0008b503          	ld	a0,0(a7)
ffffffffc0205252:	cea9                	beqz	a3,ffffffffc02052ac <iobuf_move+0x70>
ffffffffc0205254:	863e                	mv	a2,a5
ffffffffc0205256:	ec3a                	sd	a4,24(sp)
ffffffffc0205258:	e846                	sd	a7,16(sp)
ffffffffc020525a:	e442                	sd	a6,8(sp)
ffffffffc020525c:	e03e                	sd	a5,0(sp)
ffffffffc020525e:	14e060ef          	jal	ffffffffc020b3ac <memmove>
ffffffffc0205262:	68c2                	ld	a7,16(sp)
ffffffffc0205264:	6782                	ld	a5,0(sp)
ffffffffc0205266:	6822                	ld	a6,8(sp)
ffffffffc0205268:	0188b683          	ld	a3,24(a7)
ffffffffc020526c:	6762                	ld	a4,24(sp)
ffffffffc020526e:	04f6e763          	bltu	a3,a5,ffffffffc02052bc <iobuf_move+0x80>
ffffffffc0205272:	0008b583          	ld	a1,0(a7)
ffffffffc0205276:	0088b603          	ld	a2,8(a7)
ffffffffc020527a:	8e9d                	sub	a3,a3,a5
ffffffffc020527c:	95be                	add	a1,a1,a5
ffffffffc020527e:	963e                	add	a2,a2,a5
ffffffffc0205280:	00d8bc23          	sd	a3,24(a7)
ffffffffc0205284:	00b8b023          	sd	a1,0(a7)
ffffffffc0205288:	00c8b423          	sd	a2,8(a7)
ffffffffc020528c:	40f80833          	sub	a6,a6,a5
ffffffffc0205290:	c311                	beqz	a4,ffffffffc0205294 <iobuf_move+0x58>
ffffffffc0205292:	e31c                	sd	a5,0(a4)
ffffffffc0205294:	02081263          	bnez	a6,ffffffffc02052b8 <iobuf_move+0x7c>
ffffffffc0205298:	4501                	li	a0,0
ffffffffc020529a:	70a2                	ld	ra,40(sp)
ffffffffc020529c:	6145                	addi	sp,sp,48
ffffffffc020529e:	8082                	ret
ffffffffc02052a0:	c311                	beqz	a4,ffffffffc02052a4 <iobuf_move+0x68>
ffffffffc02052a2:	e31c                	sd	a5,0(a4)
ffffffffc02052a4:	00081863          	bnez	a6,ffffffffc02052b4 <iobuf_move+0x78>
ffffffffc02052a8:	4501                	li	a0,0
ffffffffc02052aa:	8082                	ret
ffffffffc02052ac:	86ae                	mv	a3,a1
ffffffffc02052ae:	85aa                	mv	a1,a0
ffffffffc02052b0:	8536                	mv	a0,a3
ffffffffc02052b2:	b74d                	j	ffffffffc0205254 <iobuf_move+0x18>
ffffffffc02052b4:	5571                	li	a0,-4
ffffffffc02052b6:	8082                	ret
ffffffffc02052b8:	5571                	li	a0,-4
ffffffffc02052ba:	b7c5                	j	ffffffffc020529a <iobuf_move+0x5e>
ffffffffc02052bc:	f53ff0ef          	jal	ffffffffc020520e <iobuf_skip.part.0>

ffffffffc02052c0 <iobuf_skip>:
ffffffffc02052c0:	6d1c                	ld	a5,24(a0)
ffffffffc02052c2:	00b7eb63          	bltu	a5,a1,ffffffffc02052d8 <iobuf_skip+0x18>
ffffffffc02052c6:	6114                	ld	a3,0(a0)
ffffffffc02052c8:	6518                	ld	a4,8(a0)
ffffffffc02052ca:	8f8d                	sub	a5,a5,a1
ffffffffc02052cc:	96ae                	add	a3,a3,a1
ffffffffc02052ce:	972e                	add	a4,a4,a1
ffffffffc02052d0:	ed1c                	sd	a5,24(a0)
ffffffffc02052d2:	e114                	sd	a3,0(a0)
ffffffffc02052d4:	e518                	sd	a4,8(a0)
ffffffffc02052d6:	8082                	ret
ffffffffc02052d8:	1141                	addi	sp,sp,-16
ffffffffc02052da:	e406                	sd	ra,8(sp)
ffffffffc02052dc:	f33ff0ef          	jal	ffffffffc020520e <iobuf_skip.part.0>

ffffffffc02052e0 <copy_path>:
ffffffffc02052e0:	7139                	addi	sp,sp,-64
ffffffffc02052e2:	f04a                	sd	s2,32(sp)
ffffffffc02052e4:	00091917          	auipc	s2,0x91
ffffffffc02052e8:	5e490913          	addi	s2,s2,1508 # ffffffffc02968c8 <current>
ffffffffc02052ec:	00093783          	ld	a5,0(s2)
ffffffffc02052f0:	e852                	sd	s4,16(sp)
ffffffffc02052f2:	8a2a                	mv	s4,a0
ffffffffc02052f4:	6505                	lui	a0,0x1
ffffffffc02052f6:	f426                	sd	s1,40(sp)
ffffffffc02052f8:	ec4e                	sd	s3,24(sp)
ffffffffc02052fa:	fc06                	sd	ra,56(sp)
ffffffffc02052fc:	7784                	ld	s1,40(a5)
ffffffffc02052fe:	89ae                	mv	s3,a1
ffffffffc0205300:	cd5fc0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0205304:	c92d                	beqz	a0,ffffffffc0205376 <copy_path+0x96>
ffffffffc0205306:	f822                	sd	s0,48(sp)
ffffffffc0205308:	842a                	mv	s0,a0
ffffffffc020530a:	c0b1                	beqz	s1,ffffffffc020534e <copy_path+0x6e>
ffffffffc020530c:	03848513          	addi	a0,s1,56
ffffffffc0205310:	88cff0ef          	jal	ffffffffc020439c <down>
ffffffffc0205314:	00093783          	ld	a5,0(s2)
ffffffffc0205318:	c399                	beqz	a5,ffffffffc020531e <copy_path+0x3e>
ffffffffc020531a:	43dc                	lw	a5,4(a5)
ffffffffc020531c:	c8bc                	sw	a5,80(s1)
ffffffffc020531e:	864e                	mv	a2,s3
ffffffffc0205320:	6685                	lui	a3,0x1
ffffffffc0205322:	85a2                	mv	a1,s0
ffffffffc0205324:	8526                	mv	a0,s1
ffffffffc0205326:	e87fe0ef          	jal	ffffffffc02041ac <copy_string>
ffffffffc020532a:	cd1d                	beqz	a0,ffffffffc0205368 <copy_path+0x88>
ffffffffc020532c:	03848513          	addi	a0,s1,56
ffffffffc0205330:	868ff0ef          	jal	ffffffffc0204398 <up>
ffffffffc0205334:	0404a823          	sw	zero,80(s1)
ffffffffc0205338:	008a3023          	sd	s0,0(s4)
ffffffffc020533c:	7442                	ld	s0,48(sp)
ffffffffc020533e:	4501                	li	a0,0
ffffffffc0205340:	70e2                	ld	ra,56(sp)
ffffffffc0205342:	74a2                	ld	s1,40(sp)
ffffffffc0205344:	7902                	ld	s2,32(sp)
ffffffffc0205346:	69e2                	ld	s3,24(sp)
ffffffffc0205348:	6a42                	ld	s4,16(sp)
ffffffffc020534a:	6121                	addi	sp,sp,64
ffffffffc020534c:	8082                	ret
ffffffffc020534e:	85aa                	mv	a1,a0
ffffffffc0205350:	864e                	mv	a2,s3
ffffffffc0205352:	6685                	lui	a3,0x1
ffffffffc0205354:	4501                	li	a0,0
ffffffffc0205356:	e57fe0ef          	jal	ffffffffc02041ac <copy_string>
ffffffffc020535a:	fd79                	bnez	a0,ffffffffc0205338 <copy_path+0x58>
ffffffffc020535c:	8522                	mv	a0,s0
ffffffffc020535e:	d1dfc0ef          	jal	ffffffffc020207a <kfree>
ffffffffc0205362:	5575                	li	a0,-3
ffffffffc0205364:	7442                	ld	s0,48(sp)
ffffffffc0205366:	bfe9                	j	ffffffffc0205340 <copy_path+0x60>
ffffffffc0205368:	03848513          	addi	a0,s1,56
ffffffffc020536c:	82cff0ef          	jal	ffffffffc0204398 <up>
ffffffffc0205370:	0404a823          	sw	zero,80(s1)
ffffffffc0205374:	b7e5                	j	ffffffffc020535c <copy_path+0x7c>
ffffffffc0205376:	5571                	li	a0,-4
ffffffffc0205378:	b7e1                	j	ffffffffc0205340 <copy_path+0x60>

ffffffffc020537a <sysfile_open>:
ffffffffc020537a:	7179                	addi	sp,sp,-48
ffffffffc020537c:	f022                	sd	s0,32(sp)
ffffffffc020537e:	842e                	mv	s0,a1
ffffffffc0205380:	85aa                	mv	a1,a0
ffffffffc0205382:	0828                	addi	a0,sp,24
ffffffffc0205384:	f406                	sd	ra,40(sp)
ffffffffc0205386:	f5bff0ef          	jal	ffffffffc02052e0 <copy_path>
ffffffffc020538a:	87aa                	mv	a5,a0
ffffffffc020538c:	ed09                	bnez	a0,ffffffffc02053a6 <sysfile_open+0x2c>
ffffffffc020538e:	6762                	ld	a4,24(sp)
ffffffffc0205390:	85a2                	mv	a1,s0
ffffffffc0205392:	853a                	mv	a0,a4
ffffffffc0205394:	e43a                	sd	a4,8(sp)
ffffffffc0205396:	d32ff0ef          	jal	ffffffffc02048c8 <file_open>
ffffffffc020539a:	6722                	ld	a4,8(sp)
ffffffffc020539c:	e42a                	sd	a0,8(sp)
ffffffffc020539e:	853a                	mv	a0,a4
ffffffffc02053a0:	cdbfc0ef          	jal	ffffffffc020207a <kfree>
ffffffffc02053a4:	67a2                	ld	a5,8(sp)
ffffffffc02053a6:	70a2                	ld	ra,40(sp)
ffffffffc02053a8:	7402                	ld	s0,32(sp)
ffffffffc02053aa:	853e                	mv	a0,a5
ffffffffc02053ac:	6145                	addi	sp,sp,48
ffffffffc02053ae:	8082                	ret

ffffffffc02053b0 <sysfile_close>:
ffffffffc02053b0:	e32ff06f          	j	ffffffffc02049e2 <file_close>

ffffffffc02053b4 <sysfile_read>:
ffffffffc02053b4:	7119                	addi	sp,sp,-128
ffffffffc02053b6:	f466                	sd	s9,40(sp)
ffffffffc02053b8:	fc86                	sd	ra,120(sp)
ffffffffc02053ba:	4c81                	li	s9,0
ffffffffc02053bc:	e611                	bnez	a2,ffffffffc02053c8 <sysfile_read+0x14>
ffffffffc02053be:	70e6                	ld	ra,120(sp)
ffffffffc02053c0:	8566                	mv	a0,s9
ffffffffc02053c2:	7ca2                	ld	s9,40(sp)
ffffffffc02053c4:	6109                	addi	sp,sp,128
ffffffffc02053c6:	8082                	ret
ffffffffc02053c8:	f862                	sd	s8,48(sp)
ffffffffc02053ca:	00091c17          	auipc	s8,0x91
ffffffffc02053ce:	4fec0c13          	addi	s8,s8,1278 # ffffffffc02968c8 <current>
ffffffffc02053d2:	000c3783          	ld	a5,0(s8)
ffffffffc02053d6:	f8a2                	sd	s0,112(sp)
ffffffffc02053d8:	f0ca                	sd	s2,96(sp)
ffffffffc02053da:	8432                	mv	s0,a2
ffffffffc02053dc:	892e                	mv	s2,a1
ffffffffc02053de:	4601                	li	a2,0
ffffffffc02053e0:	4585                	li	a1,1
ffffffffc02053e2:	f4a6                	sd	s1,104(sp)
ffffffffc02053e4:	e8d2                	sd	s4,80(sp)
ffffffffc02053e6:	7784                	ld	s1,40(a5)
ffffffffc02053e8:	8a2a                	mv	s4,a0
ffffffffc02053ea:	c8aff0ef          	jal	ffffffffc0204874 <file_testfd>
ffffffffc02053ee:	c969                	beqz	a0,ffffffffc02054c0 <sysfile_read+0x10c>
ffffffffc02053f0:	6505                	lui	a0,0x1
ffffffffc02053f2:	ecce                	sd	s3,88(sp)
ffffffffc02053f4:	be1fc0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc02053f8:	89aa                	mv	s3,a0
ffffffffc02053fa:	c971                	beqz	a0,ffffffffc02054ce <sysfile_read+0x11a>
ffffffffc02053fc:	e4d6                	sd	s5,72(sp)
ffffffffc02053fe:	e0da                	sd	s6,64(sp)
ffffffffc0205400:	6a85                	lui	s5,0x1
ffffffffc0205402:	4b01                	li	s6,0
ffffffffc0205404:	09546863          	bltu	s0,s5,ffffffffc0205494 <sysfile_read+0xe0>
ffffffffc0205408:	6785                	lui	a5,0x1
ffffffffc020540a:	863e                	mv	a2,a5
ffffffffc020540c:	0834                	addi	a3,sp,24
ffffffffc020540e:	85ce                	mv	a1,s3
ffffffffc0205410:	8552                	mv	a0,s4
ffffffffc0205412:	ec3e                	sd	a5,24(sp)
ffffffffc0205414:	e26ff0ef          	jal	ffffffffc0204a3a <file_read>
ffffffffc0205418:	66e2                	ld	a3,24(sp)
ffffffffc020541a:	8caa                	mv	s9,a0
ffffffffc020541c:	e68d                	bnez	a3,ffffffffc0205446 <sysfile_read+0x92>
ffffffffc020541e:	854e                	mv	a0,s3
ffffffffc0205420:	c5bfc0ef          	jal	ffffffffc020207a <kfree>
ffffffffc0205424:	000b0463          	beqz	s6,ffffffffc020542c <sysfile_read+0x78>
ffffffffc0205428:	000b0c9b          	sext.w	s9,s6
ffffffffc020542c:	7446                	ld	s0,112(sp)
ffffffffc020542e:	70e6                	ld	ra,120(sp)
ffffffffc0205430:	74a6                	ld	s1,104(sp)
ffffffffc0205432:	7906                	ld	s2,96(sp)
ffffffffc0205434:	69e6                	ld	s3,88(sp)
ffffffffc0205436:	6a46                	ld	s4,80(sp)
ffffffffc0205438:	6aa6                	ld	s5,72(sp)
ffffffffc020543a:	6b06                	ld	s6,64(sp)
ffffffffc020543c:	7c42                	ld	s8,48(sp)
ffffffffc020543e:	8566                	mv	a0,s9
ffffffffc0205440:	7ca2                	ld	s9,40(sp)
ffffffffc0205442:	6109                	addi	sp,sp,128
ffffffffc0205444:	8082                	ret
ffffffffc0205446:	c899                	beqz	s1,ffffffffc020545c <sysfile_read+0xa8>
ffffffffc0205448:	03848513          	addi	a0,s1,56
ffffffffc020544c:	f51fe0ef          	jal	ffffffffc020439c <down>
ffffffffc0205450:	000c3783          	ld	a5,0(s8)
ffffffffc0205454:	66e2                	ld	a3,24(sp)
ffffffffc0205456:	c399                	beqz	a5,ffffffffc020545c <sysfile_read+0xa8>
ffffffffc0205458:	43dc                	lw	a5,4(a5)
ffffffffc020545a:	c8bc                	sw	a5,80(s1)
ffffffffc020545c:	864e                	mv	a2,s3
ffffffffc020545e:	85ca                	mv	a1,s2
ffffffffc0205460:	8526                	mv	a0,s1
ffffffffc0205462:	d13fe0ef          	jal	ffffffffc0204174 <copy_to_user>
ffffffffc0205466:	c915                	beqz	a0,ffffffffc020549a <sysfile_read+0xe6>
ffffffffc0205468:	67e2                	ld	a5,24(sp)
ffffffffc020546a:	06f46a63          	bltu	s0,a5,ffffffffc02054de <sysfile_read+0x12a>
ffffffffc020546e:	9b3e                	add	s6,s6,a5
ffffffffc0205470:	c889                	beqz	s1,ffffffffc0205482 <sysfile_read+0xce>
ffffffffc0205472:	03848513          	addi	a0,s1,56
ffffffffc0205476:	e43e                	sd	a5,8(sp)
ffffffffc0205478:	f21fe0ef          	jal	ffffffffc0204398 <up>
ffffffffc020547c:	67a2                	ld	a5,8(sp)
ffffffffc020547e:	0404a823          	sw	zero,80(s1)
ffffffffc0205482:	f80c9ee3          	bnez	s9,ffffffffc020541e <sysfile_read+0x6a>
ffffffffc0205486:	6762                	ld	a4,24(sp)
ffffffffc0205488:	db59                	beqz	a4,ffffffffc020541e <sysfile_read+0x6a>
ffffffffc020548a:	8c1d                	sub	s0,s0,a5
ffffffffc020548c:	d849                	beqz	s0,ffffffffc020541e <sysfile_read+0x6a>
ffffffffc020548e:	993e                	add	s2,s2,a5
ffffffffc0205490:	f7547ce3          	bgeu	s0,s5,ffffffffc0205408 <sysfile_read+0x54>
ffffffffc0205494:	87a2                	mv	a5,s0
ffffffffc0205496:	8622                	mv	a2,s0
ffffffffc0205498:	bf95                	j	ffffffffc020540c <sysfile_read+0x58>
ffffffffc020549a:	000c8a63          	beqz	s9,ffffffffc02054ae <sysfile_read+0xfa>
ffffffffc020549e:	d0c1                	beqz	s1,ffffffffc020541e <sysfile_read+0x6a>
ffffffffc02054a0:	03848513          	addi	a0,s1,56
ffffffffc02054a4:	ef5fe0ef          	jal	ffffffffc0204398 <up>
ffffffffc02054a8:	0404a823          	sw	zero,80(s1)
ffffffffc02054ac:	bf8d                	j	ffffffffc020541e <sysfile_read+0x6a>
ffffffffc02054ae:	c499                	beqz	s1,ffffffffc02054bc <sysfile_read+0x108>
ffffffffc02054b0:	03848513          	addi	a0,s1,56
ffffffffc02054b4:	ee5fe0ef          	jal	ffffffffc0204398 <up>
ffffffffc02054b8:	0404a823          	sw	zero,80(s1)
ffffffffc02054bc:	5cf5                	li	s9,-3
ffffffffc02054be:	b785                	j	ffffffffc020541e <sysfile_read+0x6a>
ffffffffc02054c0:	7446                	ld	s0,112(sp)
ffffffffc02054c2:	74a6                	ld	s1,104(sp)
ffffffffc02054c4:	7906                	ld	s2,96(sp)
ffffffffc02054c6:	6a46                	ld	s4,80(sp)
ffffffffc02054c8:	7c42                	ld	s8,48(sp)
ffffffffc02054ca:	5cf5                	li	s9,-3
ffffffffc02054cc:	bdcd                	j	ffffffffc02053be <sysfile_read+0xa>
ffffffffc02054ce:	7446                	ld	s0,112(sp)
ffffffffc02054d0:	74a6                	ld	s1,104(sp)
ffffffffc02054d2:	7906                	ld	s2,96(sp)
ffffffffc02054d4:	69e6                	ld	s3,88(sp)
ffffffffc02054d6:	6a46                	ld	s4,80(sp)
ffffffffc02054d8:	7c42                	ld	s8,48(sp)
ffffffffc02054da:	5cf1                	li	s9,-4
ffffffffc02054dc:	b5cd                	j	ffffffffc02053be <sysfile_read+0xa>
ffffffffc02054de:	00008697          	auipc	a3,0x8
ffffffffc02054e2:	cca68693          	addi	a3,a3,-822 # ffffffffc020d1a8 <etext+0x1da6>
ffffffffc02054e6:	00006617          	auipc	a2,0x6
ffffffffc02054ea:	35a60613          	addi	a2,a2,858 # ffffffffc020b840 <etext+0x43e>
ffffffffc02054ee:	05500593          	li	a1,85
ffffffffc02054f2:	00008517          	auipc	a0,0x8
ffffffffc02054f6:	cc650513          	addi	a0,a0,-826 # ffffffffc020d1b8 <etext+0x1db6>
ffffffffc02054fa:	fc5e                	sd	s7,56(sp)
ffffffffc02054fc:	f4ffa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205500 <sysfile_write>:
ffffffffc0205500:	e601                	bnez	a2,ffffffffc0205508 <sysfile_write+0x8>
ffffffffc0205502:	4701                	li	a4,0
ffffffffc0205504:	853a                	mv	a0,a4
ffffffffc0205506:	8082                	ret
ffffffffc0205508:	7159                	addi	sp,sp,-112
ffffffffc020550a:	f062                	sd	s8,32(sp)
ffffffffc020550c:	00091c17          	auipc	s8,0x91
ffffffffc0205510:	3bcc0c13          	addi	s8,s8,956 # ffffffffc02968c8 <current>
ffffffffc0205514:	000c3783          	ld	a5,0(s8)
ffffffffc0205518:	f0a2                	sd	s0,96(sp)
ffffffffc020551a:	eca6                	sd	s1,88(sp)
ffffffffc020551c:	8432                	mv	s0,a2
ffffffffc020551e:	84ae                	mv	s1,a1
ffffffffc0205520:	4605                	li	a2,1
ffffffffc0205522:	4581                	li	a1,0
ffffffffc0205524:	e8ca                	sd	s2,80(sp)
ffffffffc0205526:	e0d2                	sd	s4,64(sp)
ffffffffc0205528:	f486                	sd	ra,104(sp)
ffffffffc020552a:	0287b903          	ld	s2,40(a5) # 1028 <_binary_bin_swap_img_size-0x6cd8>
ffffffffc020552e:	8a2a                	mv	s4,a0
ffffffffc0205530:	b44ff0ef          	jal	ffffffffc0204874 <file_testfd>
ffffffffc0205534:	c969                	beqz	a0,ffffffffc0205606 <sysfile_write+0x106>
ffffffffc0205536:	6505                	lui	a0,0x1
ffffffffc0205538:	e4ce                	sd	s3,72(sp)
ffffffffc020553a:	a9bfc0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc020553e:	89aa                	mv	s3,a0
ffffffffc0205540:	c569                	beqz	a0,ffffffffc020560a <sysfile_write+0x10a>
ffffffffc0205542:	fc56                	sd	s5,56(sp)
ffffffffc0205544:	f45e                	sd	s7,40(sp)
ffffffffc0205546:	4a81                	li	s5,0
ffffffffc0205548:	6b85                	lui	s7,0x1
ffffffffc020554a:	86a2                	mv	a3,s0
ffffffffc020554c:	008bf363          	bgeu	s7,s0,ffffffffc0205552 <sysfile_write+0x52>
ffffffffc0205550:	6685                	lui	a3,0x1
ffffffffc0205552:	ec36                	sd	a3,24(sp)
ffffffffc0205554:	04090e63          	beqz	s2,ffffffffc02055b0 <sysfile_write+0xb0>
ffffffffc0205558:	03890513          	addi	a0,s2,56
ffffffffc020555c:	e41fe0ef          	jal	ffffffffc020439c <down>
ffffffffc0205560:	000c3783          	ld	a5,0(s8)
ffffffffc0205564:	c781                	beqz	a5,ffffffffc020556c <sysfile_write+0x6c>
ffffffffc0205566:	43dc                	lw	a5,4(a5)
ffffffffc0205568:	04f92823          	sw	a5,80(s2)
ffffffffc020556c:	66e2                	ld	a3,24(sp)
ffffffffc020556e:	4701                	li	a4,0
ffffffffc0205570:	8626                	mv	a2,s1
ffffffffc0205572:	85ce                	mv	a1,s3
ffffffffc0205574:	854a                	mv	a0,s2
ffffffffc0205576:	bc9fe0ef          	jal	ffffffffc020413e <copy_from_user>
ffffffffc020557a:	ed3d                	bnez	a0,ffffffffc02055f8 <sysfile_write+0xf8>
ffffffffc020557c:	03890513          	addi	a0,s2,56
ffffffffc0205580:	e19fe0ef          	jal	ffffffffc0204398 <up>
ffffffffc0205584:	04092823          	sw	zero,80(s2)
ffffffffc0205588:	5775                	li	a4,-3
ffffffffc020558a:	854e                	mv	a0,s3
ffffffffc020558c:	e43a                	sd	a4,8(sp)
ffffffffc020558e:	aedfc0ef          	jal	ffffffffc020207a <kfree>
ffffffffc0205592:	6722                	ld	a4,8(sp)
ffffffffc0205594:	040a9c63          	bnez	s5,ffffffffc02055ec <sysfile_write+0xec>
ffffffffc0205598:	69a6                	ld	s3,72(sp)
ffffffffc020559a:	7ae2                	ld	s5,56(sp)
ffffffffc020559c:	7ba2                	ld	s7,40(sp)
ffffffffc020559e:	70a6                	ld	ra,104(sp)
ffffffffc02055a0:	7406                	ld	s0,96(sp)
ffffffffc02055a2:	64e6                	ld	s1,88(sp)
ffffffffc02055a4:	6946                	ld	s2,80(sp)
ffffffffc02055a6:	6a06                	ld	s4,64(sp)
ffffffffc02055a8:	7c02                	ld	s8,32(sp)
ffffffffc02055aa:	853a                	mv	a0,a4
ffffffffc02055ac:	6165                	addi	sp,sp,112
ffffffffc02055ae:	8082                	ret
ffffffffc02055b0:	4701                	li	a4,0
ffffffffc02055b2:	8626                	mv	a2,s1
ffffffffc02055b4:	85ce                	mv	a1,s3
ffffffffc02055b6:	4501                	li	a0,0
ffffffffc02055b8:	b87fe0ef          	jal	ffffffffc020413e <copy_from_user>
ffffffffc02055bc:	d571                	beqz	a0,ffffffffc0205588 <sysfile_write+0x88>
ffffffffc02055be:	6662                	ld	a2,24(sp)
ffffffffc02055c0:	0834                	addi	a3,sp,24
ffffffffc02055c2:	85ce                	mv	a1,s3
ffffffffc02055c4:	8552                	mv	a0,s4
ffffffffc02055c6:	d62ff0ef          	jal	ffffffffc0204b28 <file_write>
ffffffffc02055ca:	67e2                	ld	a5,24(sp)
ffffffffc02055cc:	872a                	mv	a4,a0
ffffffffc02055ce:	dfd5                	beqz	a5,ffffffffc020558a <sysfile_write+0x8a>
ffffffffc02055d0:	04f46063          	bltu	s0,a5,ffffffffc0205610 <sysfile_write+0x110>
ffffffffc02055d4:	9abe                	add	s5,s5,a5
ffffffffc02055d6:	f955                	bnez	a0,ffffffffc020558a <sysfile_write+0x8a>
ffffffffc02055d8:	8c1d                	sub	s0,s0,a5
ffffffffc02055da:	94be                	add	s1,s1,a5
ffffffffc02055dc:	f43d                	bnez	s0,ffffffffc020554a <sysfile_write+0x4a>
ffffffffc02055de:	854e                	mv	a0,s3
ffffffffc02055e0:	e43a                	sd	a4,8(sp)
ffffffffc02055e2:	a99fc0ef          	jal	ffffffffc020207a <kfree>
ffffffffc02055e6:	6722                	ld	a4,8(sp)
ffffffffc02055e8:	fa0a88e3          	beqz	s5,ffffffffc0205598 <sysfile_write+0x98>
ffffffffc02055ec:	000a871b          	sext.w	a4,s5
ffffffffc02055f0:	69a6                	ld	s3,72(sp)
ffffffffc02055f2:	7ae2                	ld	s5,56(sp)
ffffffffc02055f4:	7ba2                	ld	s7,40(sp)
ffffffffc02055f6:	b765                	j	ffffffffc020559e <sysfile_write+0x9e>
ffffffffc02055f8:	03890513          	addi	a0,s2,56
ffffffffc02055fc:	d9dfe0ef          	jal	ffffffffc0204398 <up>
ffffffffc0205600:	04092823          	sw	zero,80(s2)
ffffffffc0205604:	bf6d                	j	ffffffffc02055be <sysfile_write+0xbe>
ffffffffc0205606:	5775                	li	a4,-3
ffffffffc0205608:	bf59                	j	ffffffffc020559e <sysfile_write+0x9e>
ffffffffc020560a:	69a6                	ld	s3,72(sp)
ffffffffc020560c:	5771                	li	a4,-4
ffffffffc020560e:	bf41                	j	ffffffffc020559e <sysfile_write+0x9e>
ffffffffc0205610:	00008697          	auipc	a3,0x8
ffffffffc0205614:	b9868693          	addi	a3,a3,-1128 # ffffffffc020d1a8 <etext+0x1da6>
ffffffffc0205618:	00006617          	auipc	a2,0x6
ffffffffc020561c:	22860613          	addi	a2,a2,552 # ffffffffc020b840 <etext+0x43e>
ffffffffc0205620:	08a00593          	li	a1,138
ffffffffc0205624:	00008517          	auipc	a0,0x8
ffffffffc0205628:	b9450513          	addi	a0,a0,-1132 # ffffffffc020d1b8 <etext+0x1db6>
ffffffffc020562c:	f85a                	sd	s6,48(sp)
ffffffffc020562e:	e1dfa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205632 <sysfile_seek>:
ffffffffc0205632:	de4ff06f          	j	ffffffffc0204c16 <file_seek>

ffffffffc0205636 <sysfile_fstat>:
ffffffffc0205636:	715d                	addi	sp,sp,-80
ffffffffc0205638:	f84a                	sd	s2,48(sp)
ffffffffc020563a:	00091917          	auipc	s2,0x91
ffffffffc020563e:	28e90913          	addi	s2,s2,654 # ffffffffc02968c8 <current>
ffffffffc0205642:	00093783          	ld	a5,0(s2)
ffffffffc0205646:	f44e                	sd	s3,40(sp)
ffffffffc0205648:	89ae                	mv	s3,a1
ffffffffc020564a:	858a                	mv	a1,sp
ffffffffc020564c:	e0a2                	sd	s0,64(sp)
ffffffffc020564e:	fc26                	sd	s1,56(sp)
ffffffffc0205650:	e486                	sd	ra,72(sp)
ffffffffc0205652:	7784                	ld	s1,40(a5)
ffffffffc0205654:	ee6ff0ef          	jal	ffffffffc0204d3a <file_fstat>
ffffffffc0205658:	842a                	mv	s0,a0
ffffffffc020565a:	e915                	bnez	a0,ffffffffc020568e <sysfile_fstat+0x58>
ffffffffc020565c:	c0a9                	beqz	s1,ffffffffc020569e <sysfile_fstat+0x68>
ffffffffc020565e:	03848513          	addi	a0,s1,56
ffffffffc0205662:	d3bfe0ef          	jal	ffffffffc020439c <down>
ffffffffc0205666:	00093783          	ld	a5,0(s2)
ffffffffc020566a:	c399                	beqz	a5,ffffffffc0205670 <sysfile_fstat+0x3a>
ffffffffc020566c:	43dc                	lw	a5,4(a5)
ffffffffc020566e:	c8bc                	sw	a5,80(s1)
ffffffffc0205670:	860a                	mv	a2,sp
ffffffffc0205672:	85ce                	mv	a1,s3
ffffffffc0205674:	02000693          	li	a3,32
ffffffffc0205678:	8526                	mv	a0,s1
ffffffffc020567a:	afbfe0ef          	jal	ffffffffc0204174 <copy_to_user>
ffffffffc020567e:	e111                	bnez	a0,ffffffffc0205682 <sysfile_fstat+0x4c>
ffffffffc0205680:	5475                	li	s0,-3
ffffffffc0205682:	03848513          	addi	a0,s1,56
ffffffffc0205686:	d13fe0ef          	jal	ffffffffc0204398 <up>
ffffffffc020568a:	0404a823          	sw	zero,80(s1)
ffffffffc020568e:	60a6                	ld	ra,72(sp)
ffffffffc0205690:	8522                	mv	a0,s0
ffffffffc0205692:	6406                	ld	s0,64(sp)
ffffffffc0205694:	74e2                	ld	s1,56(sp)
ffffffffc0205696:	7942                	ld	s2,48(sp)
ffffffffc0205698:	79a2                	ld	s3,40(sp)
ffffffffc020569a:	6161                	addi	sp,sp,80
ffffffffc020569c:	8082                	ret
ffffffffc020569e:	860a                	mv	a2,sp
ffffffffc02056a0:	85ce                	mv	a1,s3
ffffffffc02056a2:	02000693          	li	a3,32
ffffffffc02056a6:	acffe0ef          	jal	ffffffffc0204174 <copy_to_user>
ffffffffc02056aa:	f175                	bnez	a0,ffffffffc020568e <sysfile_fstat+0x58>
ffffffffc02056ac:	5475                	li	s0,-3
ffffffffc02056ae:	60a6                	ld	ra,72(sp)
ffffffffc02056b0:	8522                	mv	a0,s0
ffffffffc02056b2:	6406                	ld	s0,64(sp)
ffffffffc02056b4:	74e2                	ld	s1,56(sp)
ffffffffc02056b6:	7942                	ld	s2,48(sp)
ffffffffc02056b8:	79a2                	ld	s3,40(sp)
ffffffffc02056ba:	6161                	addi	sp,sp,80
ffffffffc02056bc:	8082                	ret

ffffffffc02056be <sysfile_fsync>:
ffffffffc02056be:	f34ff06f          	j	ffffffffc0204df2 <file_fsync>

ffffffffc02056c2 <sysfile_getcwd>:
ffffffffc02056c2:	c1d5                	beqz	a1,ffffffffc0205766 <sysfile_getcwd+0xa4>
ffffffffc02056c4:	00091717          	auipc	a4,0x91
ffffffffc02056c8:	20473703          	ld	a4,516(a4) # ffffffffc02968c8 <current>
ffffffffc02056cc:	711d                	addi	sp,sp,-96
ffffffffc02056ce:	e8a2                	sd	s0,80(sp)
ffffffffc02056d0:	7700                	ld	s0,40(a4)
ffffffffc02056d2:	e4a6                	sd	s1,72(sp)
ffffffffc02056d4:	e0ca                	sd	s2,64(sp)
ffffffffc02056d6:	ec86                	sd	ra,88(sp)
ffffffffc02056d8:	892a                	mv	s2,a0
ffffffffc02056da:	84ae                	mv	s1,a1
ffffffffc02056dc:	c039                	beqz	s0,ffffffffc0205722 <sysfile_getcwd+0x60>
ffffffffc02056de:	03840513          	addi	a0,s0,56
ffffffffc02056e2:	cbbfe0ef          	jal	ffffffffc020439c <down>
ffffffffc02056e6:	00091797          	auipc	a5,0x91
ffffffffc02056ea:	1e27b783          	ld	a5,482(a5) # ffffffffc02968c8 <current>
ffffffffc02056ee:	c399                	beqz	a5,ffffffffc02056f4 <sysfile_getcwd+0x32>
ffffffffc02056f0:	43dc                	lw	a5,4(a5)
ffffffffc02056f2:	c83c                	sw	a5,80(s0)
ffffffffc02056f4:	4685                	li	a3,1
ffffffffc02056f6:	8626                	mv	a2,s1
ffffffffc02056f8:	85ca                	mv	a1,s2
ffffffffc02056fa:	8522                	mv	a0,s0
ffffffffc02056fc:	99ffe0ef          	jal	ffffffffc020409a <user_mem_check>
ffffffffc0205700:	57f5                	li	a5,-3
ffffffffc0205702:	e921                	bnez	a0,ffffffffc0205752 <sysfile_getcwd+0x90>
ffffffffc0205704:	03840513          	addi	a0,s0,56
ffffffffc0205708:	e43e                	sd	a5,8(sp)
ffffffffc020570a:	c8ffe0ef          	jal	ffffffffc0204398 <up>
ffffffffc020570e:	67a2                	ld	a5,8(sp)
ffffffffc0205710:	04042823          	sw	zero,80(s0)
ffffffffc0205714:	60e6                	ld	ra,88(sp)
ffffffffc0205716:	6446                	ld	s0,80(sp)
ffffffffc0205718:	64a6                	ld	s1,72(sp)
ffffffffc020571a:	6906                	ld	s2,64(sp)
ffffffffc020571c:	853e                	mv	a0,a5
ffffffffc020571e:	6125                	addi	sp,sp,96
ffffffffc0205720:	8082                	ret
ffffffffc0205722:	862e                	mv	a2,a1
ffffffffc0205724:	4685                	li	a3,1
ffffffffc0205726:	85aa                	mv	a1,a0
ffffffffc0205728:	4501                	li	a0,0
ffffffffc020572a:	971fe0ef          	jal	ffffffffc020409a <user_mem_check>
ffffffffc020572e:	57f5                	li	a5,-3
ffffffffc0205730:	d175                	beqz	a0,ffffffffc0205714 <sysfile_getcwd+0x52>
ffffffffc0205732:	8626                	mv	a2,s1
ffffffffc0205734:	85ca                	mv	a1,s2
ffffffffc0205736:	4681                	li	a3,0
ffffffffc0205738:	0808                	addi	a0,sp,16
ffffffffc020573a:	af9ff0ef          	jal	ffffffffc0205232 <iobuf_init>
ffffffffc020573e:	2e1020ef          	jal	ffffffffc020821e <vfs_getcwd>
ffffffffc0205742:	60e6                	ld	ra,88(sp)
ffffffffc0205744:	6446                	ld	s0,80(sp)
ffffffffc0205746:	87aa                	mv	a5,a0
ffffffffc0205748:	64a6                	ld	s1,72(sp)
ffffffffc020574a:	6906                	ld	s2,64(sp)
ffffffffc020574c:	853e                	mv	a0,a5
ffffffffc020574e:	6125                	addi	sp,sp,96
ffffffffc0205750:	8082                	ret
ffffffffc0205752:	8626                	mv	a2,s1
ffffffffc0205754:	85ca                	mv	a1,s2
ffffffffc0205756:	4681                	li	a3,0
ffffffffc0205758:	0808                	addi	a0,sp,16
ffffffffc020575a:	ad9ff0ef          	jal	ffffffffc0205232 <iobuf_init>
ffffffffc020575e:	2c1020ef          	jal	ffffffffc020821e <vfs_getcwd>
ffffffffc0205762:	87aa                	mv	a5,a0
ffffffffc0205764:	b745                	j	ffffffffc0205704 <sysfile_getcwd+0x42>
ffffffffc0205766:	57f5                	li	a5,-3
ffffffffc0205768:	853e                	mv	a0,a5
ffffffffc020576a:	8082                	ret

ffffffffc020576c <sysfile_getdirentry>:
ffffffffc020576c:	7139                	addi	sp,sp,-64
ffffffffc020576e:	ec4e                	sd	s3,24(sp)
ffffffffc0205770:	00091997          	auipc	s3,0x91
ffffffffc0205774:	15898993          	addi	s3,s3,344 # ffffffffc02968c8 <current>
ffffffffc0205778:	0009b783          	ld	a5,0(s3)
ffffffffc020577c:	f04a                	sd	s2,32(sp)
ffffffffc020577e:	892a                	mv	s2,a0
ffffffffc0205780:	10800513          	li	a0,264
ffffffffc0205784:	f426                	sd	s1,40(sp)
ffffffffc0205786:	e852                	sd	s4,16(sp)
ffffffffc0205788:	fc06                	sd	ra,56(sp)
ffffffffc020578a:	7784                	ld	s1,40(a5)
ffffffffc020578c:	8a2e                	mv	s4,a1
ffffffffc020578e:	847fc0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0205792:	c179                	beqz	a0,ffffffffc0205858 <sysfile_getdirentry+0xec>
ffffffffc0205794:	f822                	sd	s0,48(sp)
ffffffffc0205796:	842a                	mv	s0,a0
ffffffffc0205798:	c8d1                	beqz	s1,ffffffffc020582c <sysfile_getdirentry+0xc0>
ffffffffc020579a:	03848513          	addi	a0,s1,56
ffffffffc020579e:	bfffe0ef          	jal	ffffffffc020439c <down>
ffffffffc02057a2:	0009b783          	ld	a5,0(s3)
ffffffffc02057a6:	c399                	beqz	a5,ffffffffc02057ac <sysfile_getdirentry+0x40>
ffffffffc02057a8:	43dc                	lw	a5,4(a5)
ffffffffc02057aa:	c8bc                	sw	a5,80(s1)
ffffffffc02057ac:	4705                	li	a4,1
ffffffffc02057ae:	46a1                	li	a3,8
ffffffffc02057b0:	8652                	mv	a2,s4
ffffffffc02057b2:	85a2                	mv	a1,s0
ffffffffc02057b4:	8526                	mv	a0,s1
ffffffffc02057b6:	989fe0ef          	jal	ffffffffc020413e <copy_from_user>
ffffffffc02057ba:	e505                	bnez	a0,ffffffffc02057e2 <sysfile_getdirentry+0x76>
ffffffffc02057bc:	03848513          	addi	a0,s1,56
ffffffffc02057c0:	bd9fe0ef          	jal	ffffffffc0204398 <up>
ffffffffc02057c4:	0404a823          	sw	zero,80(s1)
ffffffffc02057c8:	5975                	li	s2,-3
ffffffffc02057ca:	8522                	mv	a0,s0
ffffffffc02057cc:	8affc0ef          	jal	ffffffffc020207a <kfree>
ffffffffc02057d0:	7442                	ld	s0,48(sp)
ffffffffc02057d2:	70e2                	ld	ra,56(sp)
ffffffffc02057d4:	74a2                	ld	s1,40(sp)
ffffffffc02057d6:	69e2                	ld	s3,24(sp)
ffffffffc02057d8:	6a42                	ld	s4,16(sp)
ffffffffc02057da:	854a                	mv	a0,s2
ffffffffc02057dc:	7902                	ld	s2,32(sp)
ffffffffc02057de:	6121                	addi	sp,sp,64
ffffffffc02057e0:	8082                	ret
ffffffffc02057e2:	03848513          	addi	a0,s1,56
ffffffffc02057e6:	bb3fe0ef          	jal	ffffffffc0204398 <up>
ffffffffc02057ea:	854a                	mv	a0,s2
ffffffffc02057ec:	0404a823          	sw	zero,80(s1)
ffffffffc02057f0:	85a2                	mv	a1,s0
ffffffffc02057f2:	eaaff0ef          	jal	ffffffffc0204e9c <file_getdirentry>
ffffffffc02057f6:	892a                	mv	s2,a0
ffffffffc02057f8:	f969                	bnez	a0,ffffffffc02057ca <sysfile_getdirentry+0x5e>
ffffffffc02057fa:	03848513          	addi	a0,s1,56
ffffffffc02057fe:	b9ffe0ef          	jal	ffffffffc020439c <down>
ffffffffc0205802:	0009b783          	ld	a5,0(s3)
ffffffffc0205806:	c399                	beqz	a5,ffffffffc020580c <sysfile_getdirentry+0xa0>
ffffffffc0205808:	43dc                	lw	a5,4(a5)
ffffffffc020580a:	c8bc                	sw	a5,80(s1)
ffffffffc020580c:	85d2                	mv	a1,s4
ffffffffc020580e:	10800693          	li	a3,264
ffffffffc0205812:	8622                	mv	a2,s0
ffffffffc0205814:	8526                	mv	a0,s1
ffffffffc0205816:	95ffe0ef          	jal	ffffffffc0204174 <copy_to_user>
ffffffffc020581a:	e111                	bnez	a0,ffffffffc020581e <sysfile_getdirentry+0xb2>
ffffffffc020581c:	5975                	li	s2,-3
ffffffffc020581e:	03848513          	addi	a0,s1,56
ffffffffc0205822:	b77fe0ef          	jal	ffffffffc0204398 <up>
ffffffffc0205826:	0404a823          	sw	zero,80(s1)
ffffffffc020582a:	b745                	j	ffffffffc02057ca <sysfile_getdirentry+0x5e>
ffffffffc020582c:	85aa                	mv	a1,a0
ffffffffc020582e:	4705                	li	a4,1
ffffffffc0205830:	46a1                	li	a3,8
ffffffffc0205832:	8652                	mv	a2,s4
ffffffffc0205834:	4501                	li	a0,0
ffffffffc0205836:	909fe0ef          	jal	ffffffffc020413e <copy_from_user>
ffffffffc020583a:	d559                	beqz	a0,ffffffffc02057c8 <sysfile_getdirentry+0x5c>
ffffffffc020583c:	854a                	mv	a0,s2
ffffffffc020583e:	85a2                	mv	a1,s0
ffffffffc0205840:	e5cff0ef          	jal	ffffffffc0204e9c <file_getdirentry>
ffffffffc0205844:	892a                	mv	s2,a0
ffffffffc0205846:	f151                	bnez	a0,ffffffffc02057ca <sysfile_getdirentry+0x5e>
ffffffffc0205848:	85d2                	mv	a1,s4
ffffffffc020584a:	10800693          	li	a3,264
ffffffffc020584e:	8622                	mv	a2,s0
ffffffffc0205850:	925fe0ef          	jal	ffffffffc0204174 <copy_to_user>
ffffffffc0205854:	f93d                	bnez	a0,ffffffffc02057ca <sysfile_getdirentry+0x5e>
ffffffffc0205856:	bf8d                	j	ffffffffc02057c8 <sysfile_getdirentry+0x5c>
ffffffffc0205858:	5971                	li	s2,-4
ffffffffc020585a:	bfa5                	j	ffffffffc02057d2 <sysfile_getdirentry+0x66>

ffffffffc020585c <sysfile_dup>:
ffffffffc020585c:	f2eff06f          	j	ffffffffc0204f8a <file_dup>

ffffffffc0205860 <kernel_thread_entry>:
ffffffffc0205860:	8526                	mv	a0,s1
ffffffffc0205862:	9402                	jalr	s0
ffffffffc0205864:	688000ef          	jal	ffffffffc0205eec <do_exit>

ffffffffc0205868 <alloc_proc>:
ffffffffc0205868:	1141                	addi	sp,sp,-16
ffffffffc020586a:	15000513          	li	a0,336
ffffffffc020586e:	e022                	sd	s0,0(sp)
ffffffffc0205870:	e406                	sd	ra,8(sp)
ffffffffc0205872:	f62fc0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0205876:	842a                	mv	s0,a0
ffffffffc0205878:	c141                	beqz	a0,ffffffffc02058f8 <alloc_proc+0x90>
ffffffffc020587a:	57fd                	li	a5,-1
ffffffffc020587c:	1782                	slli	a5,a5,0x20
ffffffffc020587e:	e11c                	sd	a5,0(a0)
ffffffffc0205880:	00052423          	sw	zero,8(a0)
ffffffffc0205884:	00053823          	sd	zero,16(a0)
ffffffffc0205888:	00053c23          	sd	zero,24(a0)
ffffffffc020588c:	02053023          	sd	zero,32(a0)
ffffffffc0205890:	02053423          	sd	zero,40(a0)
ffffffffc0205894:	07000613          	li	a2,112
ffffffffc0205898:	4581                	li	a1,0
ffffffffc020589a:	03050513          	addi	a0,a0,48
ffffffffc020589e:	2fd050ef          	jal	ffffffffc020b39a <memset>
ffffffffc02058a2:	00091797          	auipc	a5,0x91
ffffffffc02058a6:	ff67b783          	ld	a5,-10(a5) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc02058aa:	0a043023          	sd	zero,160(s0)
ffffffffc02058ae:	0a042823          	sw	zero,176(s0)
ffffffffc02058b2:	f45c                	sd	a5,168(s0)
ffffffffc02058b4:	0b440513          	addi	a0,s0,180
ffffffffc02058b8:	463d                	li	a2,15
ffffffffc02058ba:	4581                	li	a1,0
ffffffffc02058bc:	2df050ef          	jal	ffffffffc020b39a <memset>
ffffffffc02058c0:	11040793          	addi	a5,s0,272
ffffffffc02058c4:	0e042623          	sw	zero,236(s0)
ffffffffc02058c8:	0e043c23          	sd	zero,248(s0)
ffffffffc02058cc:	10043023          	sd	zero,256(s0)
ffffffffc02058d0:	0e043823          	sd	zero,240(s0)
ffffffffc02058d4:	10043423          	sd	zero,264(s0)
ffffffffc02058d8:	12042023          	sw	zero,288(s0)
ffffffffc02058dc:	12043423          	sd	zero,296(s0)
ffffffffc02058e0:	12043c23          	sd	zero,312(s0)
ffffffffc02058e4:	12043823          	sd	zero,304(s0)
ffffffffc02058e8:	14043023          	sd	zero,320(s0)
ffffffffc02058ec:	14043423          	sd	zero,328(s0)
ffffffffc02058f0:	10f43c23          	sd	a5,280(s0)
ffffffffc02058f4:	10f43823          	sd	a5,272(s0)
ffffffffc02058f8:	60a2                	ld	ra,8(sp)
ffffffffc02058fa:	8522                	mv	a0,s0
ffffffffc02058fc:	6402                	ld	s0,0(sp)
ffffffffc02058fe:	0141                	addi	sp,sp,16
ffffffffc0205900:	8082                	ret

ffffffffc0205902 <forkret>:
ffffffffc0205902:	00091797          	auipc	a5,0x91
ffffffffc0205906:	fc67b783          	ld	a5,-58(a5) # ffffffffc02968c8 <current>
ffffffffc020590a:	73c8                	ld	a0,160(a5)
ffffffffc020590c:	957fb06f          	j	ffffffffc0201262 <forkrets>

ffffffffc0205910 <put_pgdir.isra.0>:
ffffffffc0205910:	1141                	addi	sp,sp,-16
ffffffffc0205912:	e406                	sd	ra,8(sp)
ffffffffc0205914:	c02007b7          	lui	a5,0xc0200
ffffffffc0205918:	02f56f63          	bltu	a0,a5,ffffffffc0205956 <put_pgdir.isra.0+0x46>
ffffffffc020591c:	00091797          	auipc	a5,0x91
ffffffffc0205920:	f8c7b783          	ld	a5,-116(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0205924:	00091717          	auipc	a4,0x91
ffffffffc0205928:	f8c73703          	ld	a4,-116(a4) # ffffffffc02968b0 <npage>
ffffffffc020592c:	8d1d                	sub	a0,a0,a5
ffffffffc020592e:	00c55793          	srli	a5,a0,0xc
ffffffffc0205932:	02e7ff63          	bgeu	a5,a4,ffffffffc0205970 <put_pgdir.isra.0+0x60>
ffffffffc0205936:	0000a717          	auipc	a4,0xa
ffffffffc020593a:	c9a73703          	ld	a4,-870(a4) # ffffffffc020f5d0 <nbase>
ffffffffc020593e:	00091517          	auipc	a0,0x91
ffffffffc0205942:	f7a53503          	ld	a0,-134(a0) # ffffffffc02968b8 <pages>
ffffffffc0205946:	60a2                	ld	ra,8(sp)
ffffffffc0205948:	8f99                	sub	a5,a5,a4
ffffffffc020594a:	079a                	slli	a5,a5,0x6
ffffffffc020594c:	4585                	li	a1,1
ffffffffc020594e:	953e                	add	a0,a0,a5
ffffffffc0205950:	0141                	addi	sp,sp,16
ffffffffc0205952:	881fc06f          	j	ffffffffc02021d2 <free_pages>
ffffffffc0205956:	86aa                	mv	a3,a0
ffffffffc0205958:	00007617          	auipc	a2,0x7
ffffffffc020595c:	a0860613          	addi	a2,a2,-1528 # ffffffffc020c360 <etext+0xf5e>
ffffffffc0205960:	07700593          	li	a1,119
ffffffffc0205964:	00007517          	auipc	a0,0x7
ffffffffc0205968:	97c50513          	addi	a0,a0,-1668 # ffffffffc020c2e0 <etext+0xede>
ffffffffc020596c:	adffa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205970:	00007617          	auipc	a2,0x7
ffffffffc0205974:	a1860613          	addi	a2,a2,-1512 # ffffffffc020c388 <etext+0xf86>
ffffffffc0205978:	06900593          	li	a1,105
ffffffffc020597c:	00007517          	auipc	a0,0x7
ffffffffc0205980:	96450513          	addi	a0,a0,-1692 # ffffffffc020c2e0 <etext+0xede>
ffffffffc0205984:	ac7fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205988 <setup_pgdir>:
ffffffffc0205988:	1101                	addi	sp,sp,-32
ffffffffc020598a:	e426                	sd	s1,8(sp)
ffffffffc020598c:	84aa                	mv	s1,a0
ffffffffc020598e:	4505                	li	a0,1
ffffffffc0205990:	ec06                	sd	ra,24(sp)
ffffffffc0205992:	807fc0ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc0205996:	cd29                	beqz	a0,ffffffffc02059f0 <setup_pgdir+0x68>
ffffffffc0205998:	00091697          	auipc	a3,0x91
ffffffffc020599c:	f206b683          	ld	a3,-224(a3) # ffffffffc02968b8 <pages>
ffffffffc02059a0:	0000a797          	auipc	a5,0xa
ffffffffc02059a4:	c307b783          	ld	a5,-976(a5) # ffffffffc020f5d0 <nbase>
ffffffffc02059a8:	00091717          	auipc	a4,0x91
ffffffffc02059ac:	f0873703          	ld	a4,-248(a4) # ffffffffc02968b0 <npage>
ffffffffc02059b0:	40d506b3          	sub	a3,a0,a3
ffffffffc02059b4:	8699                	srai	a3,a3,0x6
ffffffffc02059b6:	96be                	add	a3,a3,a5
ffffffffc02059b8:	00c69793          	slli	a5,a3,0xc
ffffffffc02059bc:	e822                	sd	s0,16(sp)
ffffffffc02059be:	83b1                	srli	a5,a5,0xc
ffffffffc02059c0:	06b2                	slli	a3,a3,0xc
ffffffffc02059c2:	02e7f963          	bgeu	a5,a4,ffffffffc02059f4 <setup_pgdir+0x6c>
ffffffffc02059c6:	00091797          	auipc	a5,0x91
ffffffffc02059ca:	ee27b783          	ld	a5,-286(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc02059ce:	00091597          	auipc	a1,0x91
ffffffffc02059d2:	ed25b583          	ld	a1,-302(a1) # ffffffffc02968a0 <boot_pgdir_va>
ffffffffc02059d6:	6605                	lui	a2,0x1
ffffffffc02059d8:	00f68433          	add	s0,a3,a5
ffffffffc02059dc:	8522                	mv	a0,s0
ffffffffc02059de:	20d050ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc02059e2:	ec80                	sd	s0,24(s1)
ffffffffc02059e4:	6442                	ld	s0,16(sp)
ffffffffc02059e6:	4501                	li	a0,0
ffffffffc02059e8:	60e2                	ld	ra,24(sp)
ffffffffc02059ea:	64a2                	ld	s1,8(sp)
ffffffffc02059ec:	6105                	addi	sp,sp,32
ffffffffc02059ee:	8082                	ret
ffffffffc02059f0:	5571                	li	a0,-4
ffffffffc02059f2:	bfdd                	j	ffffffffc02059e8 <setup_pgdir+0x60>
ffffffffc02059f4:	00007617          	auipc	a2,0x7
ffffffffc02059f8:	8c460613          	addi	a2,a2,-1852 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc02059fc:	07100593          	li	a1,113
ffffffffc0205a00:	00007517          	auipc	a0,0x7
ffffffffc0205a04:	8e050513          	addi	a0,a0,-1824 # ffffffffc020c2e0 <etext+0xede>
ffffffffc0205a08:	a43fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205a0c <proc_run>:
ffffffffc0205a0c:	00091697          	auipc	a3,0x91
ffffffffc0205a10:	ebc6b683          	ld	a3,-324(a3) # ffffffffc02968c8 <current>
ffffffffc0205a14:	04a68663          	beq	a3,a0,ffffffffc0205a60 <proc_run+0x54>
ffffffffc0205a18:	1101                	addi	sp,sp,-32
ffffffffc0205a1a:	ec06                	sd	ra,24(sp)
ffffffffc0205a1c:	100027f3          	csrr	a5,sstatus
ffffffffc0205a20:	8b89                	andi	a5,a5,2
ffffffffc0205a22:	4601                	li	a2,0
ffffffffc0205a24:	ef9d                	bnez	a5,ffffffffc0205a62 <proc_run+0x56>
ffffffffc0205a26:	755c                	ld	a5,168(a0)
ffffffffc0205a28:	577d                	li	a4,-1
ffffffffc0205a2a:	177e                	slli	a4,a4,0x3f
ffffffffc0205a2c:	83b1                	srli	a5,a5,0xc
ffffffffc0205a2e:	e032                	sd	a2,0(sp)
ffffffffc0205a30:	00091597          	auipc	a1,0x91
ffffffffc0205a34:	e8a5bc23          	sd	a0,-360(a1) # ffffffffc02968c8 <current>
ffffffffc0205a38:	8fd9                	or	a5,a5,a4
ffffffffc0205a3a:	18079073          	csrw	satp,a5
ffffffffc0205a3e:	12000073          	sfence.vma
ffffffffc0205a42:	03050593          	addi	a1,a0,48
ffffffffc0205a46:	03068513          	addi	a0,a3,48
ffffffffc0205a4a:	572010ef          	jal	ffffffffc0206fbc <switch_to>
ffffffffc0205a4e:	6602                	ld	a2,0(sp)
ffffffffc0205a50:	e601                	bnez	a2,ffffffffc0205a58 <proc_run+0x4c>
ffffffffc0205a52:	60e2                	ld	ra,24(sp)
ffffffffc0205a54:	6105                	addi	sp,sp,32
ffffffffc0205a56:	8082                	ret
ffffffffc0205a58:	60e2                	ld	ra,24(sp)
ffffffffc0205a5a:	6105                	addi	sp,sp,32
ffffffffc0205a5c:	99afb06f          	j	ffffffffc0200bf6 <intr_enable>
ffffffffc0205a60:	8082                	ret
ffffffffc0205a62:	e42a                	sd	a0,8(sp)
ffffffffc0205a64:	e036                	sd	a3,0(sp)
ffffffffc0205a66:	996fb0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0205a6a:	6522                	ld	a0,8(sp)
ffffffffc0205a6c:	6682                	ld	a3,0(sp)
ffffffffc0205a6e:	4605                	li	a2,1
ffffffffc0205a70:	bf5d                	j	ffffffffc0205a26 <proc_run+0x1a>

ffffffffc0205a72 <do_fork>:
ffffffffc0205a72:	00091717          	auipc	a4,0x91
ffffffffc0205a76:	e4e72703          	lw	a4,-434(a4) # ffffffffc02968c0 <nr_process>
ffffffffc0205a7a:	6785                	lui	a5,0x1
ffffffffc0205a7c:	34f75a63          	bge	a4,a5,ffffffffc0205dd0 <do_fork+0x35e>
ffffffffc0205a80:	7119                	addi	sp,sp,-128
ffffffffc0205a82:	f8a2                	sd	s0,112(sp)
ffffffffc0205a84:	f4a6                	sd	s1,104(sp)
ffffffffc0205a86:	f0ca                	sd	s2,96(sp)
ffffffffc0205a88:	ecce                	sd	s3,88(sp)
ffffffffc0205a8a:	fc86                	sd	ra,120(sp)
ffffffffc0205a8c:	892e                	mv	s2,a1
ffffffffc0205a8e:	84b2                	mv	s1,a2
ffffffffc0205a90:	89aa                	mv	s3,a0
ffffffffc0205a92:	dd7ff0ef          	jal	ffffffffc0205868 <alloc_proc>
ffffffffc0205a96:	842a                	mv	s0,a0
ffffffffc0205a98:	2a050263          	beqz	a0,ffffffffc0205d3c <do_fork+0x2ca>
ffffffffc0205a9c:	f466                	sd	s9,40(sp)
ffffffffc0205a9e:	00091c97          	auipc	s9,0x91
ffffffffc0205aa2:	e2ac8c93          	addi	s9,s9,-470 # ffffffffc02968c8 <current>
ffffffffc0205aa6:	000cb783          	ld	a5,0(s9)
ffffffffc0205aaa:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_bin_swap_img_size-0x6c14>
ffffffffc0205aae:	f11c                	sd	a5,32(a0)
ffffffffc0205ab0:	3a071163          	bnez	a4,ffffffffc0205e52 <do_fork+0x3e0>
ffffffffc0205ab4:	4509                	li	a0,2
ffffffffc0205ab6:	ee2fc0ef          	jal	ffffffffc0202198 <alloc_pages>
ffffffffc0205aba:	26050d63          	beqz	a0,ffffffffc0205d34 <do_fork+0x2c2>
ffffffffc0205abe:	e4d6                	sd	s5,72(sp)
ffffffffc0205ac0:	00091a97          	auipc	s5,0x91
ffffffffc0205ac4:	df8a8a93          	addi	s5,s5,-520 # ffffffffc02968b8 <pages>
ffffffffc0205ac8:	000ab783          	ld	a5,0(s5)
ffffffffc0205acc:	e8d2                	sd	s4,80(sp)
ffffffffc0205ace:	0000aa17          	auipc	s4,0xa
ffffffffc0205ad2:	b02a3a03          	ld	s4,-1278(s4) # ffffffffc020f5d0 <nbase>
ffffffffc0205ad6:	40f506b3          	sub	a3,a0,a5
ffffffffc0205ada:	e0da                	sd	s6,64(sp)
ffffffffc0205adc:	8699                	srai	a3,a3,0x6
ffffffffc0205ade:	00091b17          	auipc	s6,0x91
ffffffffc0205ae2:	dd2b0b13          	addi	s6,s6,-558 # ffffffffc02968b0 <npage>
ffffffffc0205ae6:	96d2                	add	a3,a3,s4
ffffffffc0205ae8:	000b3703          	ld	a4,0(s6)
ffffffffc0205aec:	00c69793          	slli	a5,a3,0xc
ffffffffc0205af0:	fc5e                	sd	s7,56(sp)
ffffffffc0205af2:	f862                	sd	s8,48(sp)
ffffffffc0205af4:	83b1                	srli	a5,a5,0xc
ffffffffc0205af6:	06b2                	slli	a3,a3,0xc
ffffffffc0205af8:	38e7f463          	bgeu	a5,a4,ffffffffc0205e80 <do_fork+0x40e>
ffffffffc0205afc:	000cb703          	ld	a4,0(s9)
ffffffffc0205b00:	00091b97          	auipc	s7,0x91
ffffffffc0205b04:	da8b8b93          	addi	s7,s7,-600 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0205b08:	000bb783          	ld	a5,0(s7)
ffffffffc0205b0c:	02873c03          	ld	s8,40(a4)
ffffffffc0205b10:	96be                	add	a3,a3,a5
ffffffffc0205b12:	e814                	sd	a3,16(s0)
ffffffffc0205b14:	020c0a63          	beqz	s8,ffffffffc0205b48 <do_fork+0xd6>
ffffffffc0205b18:	1009f793          	andi	a5,s3,256
ffffffffc0205b1c:	1c078363          	beqz	a5,ffffffffc0205ce2 <do_fork+0x270>
ffffffffc0205b20:	030c2703          	lw	a4,48(s8)
ffffffffc0205b24:	018c3783          	ld	a5,24(s8)
ffffffffc0205b28:	c02006b7          	lui	a3,0xc0200
ffffffffc0205b2c:	2705                	addiw	a4,a4,1
ffffffffc0205b2e:	02ec2823          	sw	a4,48(s8)
ffffffffc0205b32:	03843423          	sd	s8,40(s0)
ffffffffc0205b36:	2ed7ef63          	bltu	a5,a3,ffffffffc0205e34 <do_fork+0x3c2>
ffffffffc0205b3a:	000bb603          	ld	a2,0(s7)
ffffffffc0205b3e:	000cb703          	ld	a4,0(s9)
ffffffffc0205b42:	6814                	ld	a3,16(s0)
ffffffffc0205b44:	8f91                	sub	a5,a5,a2
ffffffffc0205b46:	f45c                	sd	a5,168(s0)
ffffffffc0205b48:	6789                	lui	a5,0x2
ffffffffc0205b4a:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0205b4e:	96be                	add	a3,a3,a5
ffffffffc0205b50:	f054                	sd	a3,160(s0)
ffffffffc0205b52:	87b6                	mv	a5,a3
ffffffffc0205b54:	12048613          	addi	a2,s1,288
ffffffffc0205b58:	688c                	ld	a1,16(s1)
ffffffffc0205b5a:	0004b803          	ld	a6,0(s1)
ffffffffc0205b5e:	6488                	ld	a0,8(s1)
ffffffffc0205b60:	eb8c                	sd	a1,16(a5)
ffffffffc0205b62:	0107b023          	sd	a6,0(a5)
ffffffffc0205b66:	e788                	sd	a0,8(a5)
ffffffffc0205b68:	6c8c                	ld	a1,24(s1)
ffffffffc0205b6a:	02048493          	addi	s1,s1,32
ffffffffc0205b6e:	02078793          	addi	a5,a5,32
ffffffffc0205b72:	feb7bc23          	sd	a1,-8(a5)
ffffffffc0205b76:	fec491e3          	bne	s1,a2,ffffffffc0205b58 <do_fork+0xe6>
ffffffffc0205b7a:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
ffffffffc0205b7e:	1c090163          	beqz	s2,ffffffffc0205d40 <do_fork+0x2ce>
ffffffffc0205b82:	14873483          	ld	s1,328(a4)
ffffffffc0205b86:	00000797          	auipc	a5,0x0
ffffffffc0205b8a:	d7c78793          	addi	a5,a5,-644 # ffffffffc0205902 <forkret>
ffffffffc0205b8e:	0126b823          	sd	s2,16(a3)
ffffffffc0205b92:	fc14                	sd	a3,56(s0)
ffffffffc0205b94:	f81c                	sd	a5,48(s0)
ffffffffc0205b96:	24048f63          	beqz	s1,ffffffffc0205df4 <do_fork+0x382>
ffffffffc0205b9a:	03499793          	slli	a5,s3,0x34
ffffffffc0205b9e:	0007cd63          	bltz	a5,ffffffffc0205bb8 <do_fork+0x146>
ffffffffc0205ba2:	c7cff0ef          	jal	ffffffffc020501e <files_create>
ffffffffc0205ba6:	892a                	mv	s2,a0
ffffffffc0205ba8:	20050163          	beqz	a0,ffffffffc0205daa <do_fork+0x338>
ffffffffc0205bac:	85a6                	mv	a1,s1
ffffffffc0205bae:	da8ff0ef          	jal	ffffffffc0205156 <dup_files>
ffffffffc0205bb2:	84ca                	mv	s1,s2
ffffffffc0205bb4:	1e051863          	bnez	a0,ffffffffc0205da4 <do_fork+0x332>
ffffffffc0205bb8:	489c                	lw	a5,16(s1)
ffffffffc0205bba:	2785                	addiw	a5,a5,1
ffffffffc0205bbc:	c89c                	sw	a5,16(s1)
ffffffffc0205bbe:	14943423          	sd	s1,328(s0)
ffffffffc0205bc2:	100027f3          	csrr	a5,sstatus
ffffffffc0205bc6:	8b89                	andi	a5,a5,2
ffffffffc0205bc8:	1c079a63          	bnez	a5,ffffffffc0205d9c <do_fork+0x32a>
ffffffffc0205bcc:	4901                	li	s2,0
ffffffffc0205bce:	0008b517          	auipc	a0,0x8b
ffffffffc0205bd2:	48e52503          	lw	a0,1166(a0) # ffffffffc029105c <last_pid.1>
ffffffffc0205bd6:	6789                	lui	a5,0x2
ffffffffc0205bd8:	2505                	addiw	a0,a0,1
ffffffffc0205bda:	0008b717          	auipc	a4,0x8b
ffffffffc0205bde:	48a72123          	sw	a0,1154(a4) # ffffffffc029105c <last_pid.1>
ffffffffc0205be2:	16f55163          	bge	a0,a5,ffffffffc0205d44 <do_fork+0x2d2>
ffffffffc0205be6:	0008b797          	auipc	a5,0x8b
ffffffffc0205bea:	4727a783          	lw	a5,1138(a5) # ffffffffc0291058 <next_safe.0>
ffffffffc0205bee:	00090497          	auipc	s1,0x90
ffffffffc0205bf2:	bd248493          	addi	s1,s1,-1070 # ffffffffc02957c0 <proc_list>
ffffffffc0205bf6:	06f54563          	blt	a0,a5,ffffffffc0205c60 <do_fork+0x1ee>
ffffffffc0205bfa:	00090497          	auipc	s1,0x90
ffffffffc0205bfe:	bc648493          	addi	s1,s1,-1082 # ffffffffc02957c0 <proc_list>
ffffffffc0205c02:	0084b883          	ld	a7,8(s1)
ffffffffc0205c06:	6789                	lui	a5,0x2
ffffffffc0205c08:	0008b717          	auipc	a4,0x8b
ffffffffc0205c0c:	44f72823          	sw	a5,1104(a4) # ffffffffc0291058 <next_safe.0>
ffffffffc0205c10:	86aa                	mv	a3,a0
ffffffffc0205c12:	4581                	li	a1,0
ffffffffc0205c14:	04988063          	beq	a7,s1,ffffffffc0205c54 <do_fork+0x1e2>
ffffffffc0205c18:	882e                	mv	a6,a1
ffffffffc0205c1a:	87c6                	mv	a5,a7
ffffffffc0205c1c:	6609                	lui	a2,0x2
ffffffffc0205c1e:	a811                	j	ffffffffc0205c32 <do_fork+0x1c0>
ffffffffc0205c20:	00e6d663          	bge	a3,a4,ffffffffc0205c2c <do_fork+0x1ba>
ffffffffc0205c24:	00c75463          	bge	a4,a2,ffffffffc0205c2c <do_fork+0x1ba>
ffffffffc0205c28:	863a                	mv	a2,a4
ffffffffc0205c2a:	4805                	li	a6,1
ffffffffc0205c2c:	679c                	ld	a5,8(a5)
ffffffffc0205c2e:	00978d63          	beq	a5,s1,ffffffffc0205c48 <do_fork+0x1d6>
ffffffffc0205c32:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_bin_swap_img_size-0x5dc4>
ffffffffc0205c36:	fed715e3          	bne	a4,a3,ffffffffc0205c20 <do_fork+0x1ae>
ffffffffc0205c3a:	2685                	addiw	a3,a3,1
ffffffffc0205c3c:	10c6dd63          	bge	a3,a2,ffffffffc0205d56 <do_fork+0x2e4>
ffffffffc0205c40:	679c                	ld	a5,8(a5)
ffffffffc0205c42:	4585                	li	a1,1
ffffffffc0205c44:	fe9797e3          	bne	a5,s1,ffffffffc0205c32 <do_fork+0x1c0>
ffffffffc0205c48:	00080663          	beqz	a6,ffffffffc0205c54 <do_fork+0x1e2>
ffffffffc0205c4c:	0008b797          	auipc	a5,0x8b
ffffffffc0205c50:	40c7a623          	sw	a2,1036(a5) # ffffffffc0291058 <next_safe.0>
ffffffffc0205c54:	c591                	beqz	a1,ffffffffc0205c60 <do_fork+0x1ee>
ffffffffc0205c56:	0008b797          	auipc	a5,0x8b
ffffffffc0205c5a:	40d7a323          	sw	a3,1030(a5) # ffffffffc029105c <last_pid.1>
ffffffffc0205c5e:	8536                	mv	a0,a3
ffffffffc0205c60:	c048                	sw	a0,4(s0)
ffffffffc0205c62:	45a9                	li	a1,10
ffffffffc0205c64:	1fa050ef          	jal	ffffffffc020ae5e <hash32>
ffffffffc0205c68:	02051793          	slli	a5,a0,0x20
ffffffffc0205c6c:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0205c70:	0008c797          	auipc	a5,0x8c
ffffffffc0205c74:	b5078793          	addi	a5,a5,-1200 # ffffffffc02917c0 <hash_list>
ffffffffc0205c78:	953e                	add	a0,a0,a5
ffffffffc0205c7a:	6518                	ld	a4,8(a0)
ffffffffc0205c7c:	0d840793          	addi	a5,s0,216
ffffffffc0205c80:	6490                	ld	a2,8(s1)
ffffffffc0205c82:	e31c                	sd	a5,0(a4)
ffffffffc0205c84:	e51c                	sd	a5,8(a0)
ffffffffc0205c86:	f078                	sd	a4,224(s0)
ffffffffc0205c88:	0c840793          	addi	a5,s0,200
ffffffffc0205c8c:	7018                	ld	a4,32(s0)
ffffffffc0205c8e:	ec68                	sd	a0,216(s0)
ffffffffc0205c90:	e21c                	sd	a5,0(a2)
ffffffffc0205c92:	0e043c23          	sd	zero,248(s0)
ffffffffc0205c96:	7b74                	ld	a3,240(a4)
ffffffffc0205c98:	e49c                	sd	a5,8(s1)
ffffffffc0205c9a:	e870                	sd	a2,208(s0)
ffffffffc0205c9c:	e464                	sd	s1,200(s0)
ffffffffc0205c9e:	10d43023          	sd	a3,256(s0)
ffffffffc0205ca2:	c299                	beqz	a3,ffffffffc0205ca8 <do_fork+0x236>
ffffffffc0205ca4:	fee0                	sd	s0,248(a3)
ffffffffc0205ca6:	7018                	ld	a4,32(s0)
ffffffffc0205ca8:	00091797          	auipc	a5,0x91
ffffffffc0205cac:	c187a783          	lw	a5,-1000(a5) # ffffffffc02968c0 <nr_process>
ffffffffc0205cb0:	fb60                	sd	s0,240(a4)
ffffffffc0205cb2:	2785                	addiw	a5,a5,1
ffffffffc0205cb4:	00091717          	auipc	a4,0x91
ffffffffc0205cb8:	c0f72623          	sw	a5,-1012(a4) # ffffffffc02968c0 <nr_process>
ffffffffc0205cbc:	08091a63          	bnez	s2,ffffffffc0205d50 <do_fork+0x2de>
ffffffffc0205cc0:	8522                	mv	a0,s0
ffffffffc0205cc2:	4a4010ef          	jal	ffffffffc0207166 <wakeup_proc>
ffffffffc0205cc6:	4048                	lw	a0,4(s0)
ffffffffc0205cc8:	6a46                	ld	s4,80(sp)
ffffffffc0205cca:	6aa6                	ld	s5,72(sp)
ffffffffc0205ccc:	6b06                	ld	s6,64(sp)
ffffffffc0205cce:	7be2                	ld	s7,56(sp)
ffffffffc0205cd0:	7c42                	ld	s8,48(sp)
ffffffffc0205cd2:	7ca2                	ld	s9,40(sp)
ffffffffc0205cd4:	70e6                	ld	ra,120(sp)
ffffffffc0205cd6:	7446                	ld	s0,112(sp)
ffffffffc0205cd8:	74a6                	ld	s1,104(sp)
ffffffffc0205cda:	7906                	ld	s2,96(sp)
ffffffffc0205cdc:	69e6                	ld	s3,88(sp)
ffffffffc0205cde:	6109                	addi	sp,sp,128
ffffffffc0205ce0:	8082                	ret
ffffffffc0205ce2:	f06a                	sd	s10,32(sp)
ffffffffc0205ce4:	d17fd0ef          	jal	ffffffffc02039fa <mm_create>
ffffffffc0205ce8:	8d2a                	mv	s10,a0
ffffffffc0205cea:	0e050563          	beqz	a0,ffffffffc0205dd4 <do_fork+0x362>
ffffffffc0205cee:	c9bff0ef          	jal	ffffffffc0205988 <setup_pgdir>
ffffffffc0205cf2:	c925                	beqz	a0,ffffffffc0205d62 <do_fork+0x2f0>
ffffffffc0205cf4:	856a                	mv	a0,s10
ffffffffc0205cf6:	e51fd0ef          	jal	ffffffffc0203b46 <mm_destroy>
ffffffffc0205cfa:	7d02                	ld	s10,32(sp)
ffffffffc0205cfc:	6814                	ld	a3,16(s0)
ffffffffc0205cfe:	c02007b7          	lui	a5,0xc0200
ffffffffc0205d02:	0cf6eb63          	bltu	a3,a5,ffffffffc0205dd8 <do_fork+0x366>
ffffffffc0205d06:	000bb783          	ld	a5,0(s7)
ffffffffc0205d0a:	000b3703          	ld	a4,0(s6)
ffffffffc0205d0e:	40f687b3          	sub	a5,a3,a5
ffffffffc0205d12:	83b1                	srli	a5,a5,0xc
ffffffffc0205d14:	10e7f263          	bgeu	a5,a4,ffffffffc0205e18 <do_fork+0x3a6>
ffffffffc0205d18:	000ab503          	ld	a0,0(s5)
ffffffffc0205d1c:	414787b3          	sub	a5,a5,s4
ffffffffc0205d20:	079a                	slli	a5,a5,0x6
ffffffffc0205d22:	953e                	add	a0,a0,a5
ffffffffc0205d24:	4589                	li	a1,2
ffffffffc0205d26:	cacfc0ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc0205d2a:	6a46                	ld	s4,80(sp)
ffffffffc0205d2c:	6aa6                	ld	s5,72(sp)
ffffffffc0205d2e:	6b06                	ld	s6,64(sp)
ffffffffc0205d30:	7be2                	ld	s7,56(sp)
ffffffffc0205d32:	7c42                	ld	s8,48(sp)
ffffffffc0205d34:	8522                	mv	a0,s0
ffffffffc0205d36:	b44fc0ef          	jal	ffffffffc020207a <kfree>
ffffffffc0205d3a:	7ca2                	ld	s9,40(sp)
ffffffffc0205d3c:	5571                	li	a0,-4
ffffffffc0205d3e:	bf59                	j	ffffffffc0205cd4 <do_fork+0x262>
ffffffffc0205d40:	8936                	mv	s2,a3
ffffffffc0205d42:	b581                	j	ffffffffc0205b82 <do_fork+0x110>
ffffffffc0205d44:	4505                	li	a0,1
ffffffffc0205d46:	0008b797          	auipc	a5,0x8b
ffffffffc0205d4a:	30a7ab23          	sw	a0,790(a5) # ffffffffc029105c <last_pid.1>
ffffffffc0205d4e:	b575                	j	ffffffffc0205bfa <do_fork+0x188>
ffffffffc0205d50:	ea7fa0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc0205d54:	b7b5                	j	ffffffffc0205cc0 <do_fork+0x24e>
ffffffffc0205d56:	6789                	lui	a5,0x2
ffffffffc0205d58:	00f6c363          	blt	a3,a5,ffffffffc0205d5e <do_fork+0x2ec>
ffffffffc0205d5c:	4685                	li	a3,1
ffffffffc0205d5e:	4585                	li	a1,1
ffffffffc0205d60:	bd55                	j	ffffffffc0205c14 <do_fork+0x1a2>
ffffffffc0205d62:	038c0793          	addi	a5,s8,56
ffffffffc0205d66:	853e                	mv	a0,a5
ffffffffc0205d68:	e43e                	sd	a5,8(sp)
ffffffffc0205d6a:	ec6e                	sd	s11,24(sp)
ffffffffc0205d6c:	e30fe0ef          	jal	ffffffffc020439c <down>
ffffffffc0205d70:	000cb783          	ld	a5,0(s9)
ffffffffc0205d74:	c781                	beqz	a5,ffffffffc0205d7c <do_fork+0x30a>
ffffffffc0205d76:	43dc                	lw	a5,4(a5)
ffffffffc0205d78:	04fc2823          	sw	a5,80(s8)
ffffffffc0205d7c:	85e2                	mv	a1,s8
ffffffffc0205d7e:	856a                	mv	a0,s10
ffffffffc0205d80:	ee5fd0ef          	jal	ffffffffc0203c64 <dup_mmap>
ffffffffc0205d84:	8daa                	mv	s11,a0
ffffffffc0205d86:	6522                	ld	a0,8(sp)
ffffffffc0205d88:	e10fe0ef          	jal	ffffffffc0204398 <up>
ffffffffc0205d8c:	040c2823          	sw	zero,80(s8)
ffffffffc0205d90:	8c6a                	mv	s8,s10
ffffffffc0205d92:	020d9663          	bnez	s11,ffffffffc0205dbe <do_fork+0x34c>
ffffffffc0205d96:	7d02                	ld	s10,32(sp)
ffffffffc0205d98:	6de2                	ld	s11,24(sp)
ffffffffc0205d9a:	b359                	j	ffffffffc0205b20 <do_fork+0xae>
ffffffffc0205d9c:	e61fa0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0205da0:	4905                	li	s2,1
ffffffffc0205da2:	b535                	j	ffffffffc0205bce <do_fork+0x15c>
ffffffffc0205da4:	854a                	mv	a0,s2
ffffffffc0205da6:	aaeff0ef          	jal	ffffffffc0205054 <files_destroy>
ffffffffc0205daa:	14843503          	ld	a0,328(s0)
ffffffffc0205dae:	d539                	beqz	a0,ffffffffc0205cfc <do_fork+0x28a>
ffffffffc0205db0:	491c                	lw	a5,16(a0)
ffffffffc0205db2:	37fd                	addiw	a5,a5,-1 # 1fff <_binary_bin_swap_img_size-0x5d01>
ffffffffc0205db4:	c91c                	sw	a5,16(a0)
ffffffffc0205db6:	f3b9                	bnez	a5,ffffffffc0205cfc <do_fork+0x28a>
ffffffffc0205db8:	a9cff0ef          	jal	ffffffffc0205054 <files_destroy>
ffffffffc0205dbc:	b781                	j	ffffffffc0205cfc <do_fork+0x28a>
ffffffffc0205dbe:	856a                	mv	a0,s10
ffffffffc0205dc0:	f3dfd0ef          	jal	ffffffffc0203cfc <exit_mmap>
ffffffffc0205dc4:	018d3503          	ld	a0,24(s10) # fffffffffff80018 <end+0x3fce9708>
ffffffffc0205dc8:	b49ff0ef          	jal	ffffffffc0205910 <put_pgdir.isra.0>
ffffffffc0205dcc:	6de2                	ld	s11,24(sp)
ffffffffc0205dce:	b71d                	j	ffffffffc0205cf4 <do_fork+0x282>
ffffffffc0205dd0:	556d                	li	a0,-5
ffffffffc0205dd2:	8082                	ret
ffffffffc0205dd4:	7d02                	ld	s10,32(sp)
ffffffffc0205dd6:	b71d                	j	ffffffffc0205cfc <do_fork+0x28a>
ffffffffc0205dd8:	00006617          	auipc	a2,0x6
ffffffffc0205ddc:	58860613          	addi	a2,a2,1416 # ffffffffc020c360 <etext+0xf5e>
ffffffffc0205de0:	07700593          	li	a1,119
ffffffffc0205de4:	00006517          	auipc	a0,0x6
ffffffffc0205de8:	4fc50513          	addi	a0,a0,1276 # ffffffffc020c2e0 <etext+0xede>
ffffffffc0205dec:	f06a                	sd	s10,32(sp)
ffffffffc0205dee:	ec6e                	sd	s11,24(sp)
ffffffffc0205df0:	e5afa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205df4:	00007697          	auipc	a3,0x7
ffffffffc0205df8:	41468693          	addi	a3,a3,1044 # ffffffffc020d208 <etext+0x1e06>
ffffffffc0205dfc:	00006617          	auipc	a2,0x6
ffffffffc0205e00:	a4460613          	addi	a2,a2,-1468 # ffffffffc020b840 <etext+0x43e>
ffffffffc0205e04:	1bd00593          	li	a1,445
ffffffffc0205e08:	00007517          	auipc	a0,0x7
ffffffffc0205e0c:	3e850513          	addi	a0,a0,1000 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0205e10:	f06a                	sd	s10,32(sp)
ffffffffc0205e12:	ec6e                	sd	s11,24(sp)
ffffffffc0205e14:	e36fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205e18:	00006617          	auipc	a2,0x6
ffffffffc0205e1c:	57060613          	addi	a2,a2,1392 # ffffffffc020c388 <etext+0xf86>
ffffffffc0205e20:	06900593          	li	a1,105
ffffffffc0205e24:	00006517          	auipc	a0,0x6
ffffffffc0205e28:	4bc50513          	addi	a0,a0,1212 # ffffffffc020c2e0 <etext+0xede>
ffffffffc0205e2c:	f06a                	sd	s10,32(sp)
ffffffffc0205e2e:	ec6e                	sd	s11,24(sp)
ffffffffc0205e30:	e1afa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205e34:	86be                	mv	a3,a5
ffffffffc0205e36:	00006617          	auipc	a2,0x6
ffffffffc0205e3a:	52a60613          	addi	a2,a2,1322 # ffffffffc020c360 <etext+0xf5e>
ffffffffc0205e3e:	19d00593          	li	a1,413
ffffffffc0205e42:	00007517          	auipc	a0,0x7
ffffffffc0205e46:	3ae50513          	addi	a0,a0,942 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0205e4a:	f06a                	sd	s10,32(sp)
ffffffffc0205e4c:	ec6e                	sd	s11,24(sp)
ffffffffc0205e4e:	dfcfa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205e52:	00007697          	auipc	a3,0x7
ffffffffc0205e56:	37e68693          	addi	a3,a3,894 # ffffffffc020d1d0 <etext+0x1dce>
ffffffffc0205e5a:	00006617          	auipc	a2,0x6
ffffffffc0205e5e:	9e660613          	addi	a2,a2,-1562 # ffffffffc020b840 <etext+0x43e>
ffffffffc0205e62:	22100593          	li	a1,545
ffffffffc0205e66:	00007517          	auipc	a0,0x7
ffffffffc0205e6a:	38a50513          	addi	a0,a0,906 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0205e6e:	e8d2                	sd	s4,80(sp)
ffffffffc0205e70:	e4d6                	sd	s5,72(sp)
ffffffffc0205e72:	e0da                	sd	s6,64(sp)
ffffffffc0205e74:	fc5e                	sd	s7,56(sp)
ffffffffc0205e76:	f862                	sd	s8,48(sp)
ffffffffc0205e78:	f06a                	sd	s10,32(sp)
ffffffffc0205e7a:	ec6e                	sd	s11,24(sp)
ffffffffc0205e7c:	dcefa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205e80:	00006617          	auipc	a2,0x6
ffffffffc0205e84:	43860613          	addi	a2,a2,1080 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc0205e88:	07100593          	li	a1,113
ffffffffc0205e8c:	00006517          	auipc	a0,0x6
ffffffffc0205e90:	45450513          	addi	a0,a0,1108 # ffffffffc020c2e0 <etext+0xede>
ffffffffc0205e94:	f06a                	sd	s10,32(sp)
ffffffffc0205e96:	ec6e                	sd	s11,24(sp)
ffffffffc0205e98:	db2fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205e9c <kernel_thread>:
ffffffffc0205e9c:	7129                	addi	sp,sp,-320
ffffffffc0205e9e:	fa22                	sd	s0,304(sp)
ffffffffc0205ea0:	f626                	sd	s1,296(sp)
ffffffffc0205ea2:	f24a                	sd	s2,288(sp)
ffffffffc0205ea4:	842a                	mv	s0,a0
ffffffffc0205ea6:	84ae                	mv	s1,a1
ffffffffc0205ea8:	8932                	mv	s2,a2
ffffffffc0205eaa:	850a                	mv	a0,sp
ffffffffc0205eac:	12000613          	li	a2,288
ffffffffc0205eb0:	4581                	li	a1,0
ffffffffc0205eb2:	fe06                	sd	ra,312(sp)
ffffffffc0205eb4:	4e6050ef          	jal	ffffffffc020b39a <memset>
ffffffffc0205eb8:	e0a2                	sd	s0,64(sp)
ffffffffc0205eba:	e4a6                	sd	s1,72(sp)
ffffffffc0205ebc:	100027f3          	csrr	a5,sstatus
ffffffffc0205ec0:	edd7f793          	andi	a5,a5,-291
ffffffffc0205ec4:	1207e793          	ori	a5,a5,288
ffffffffc0205ec8:	860a                	mv	a2,sp
ffffffffc0205eca:	10096513          	ori	a0,s2,256
ffffffffc0205ece:	00000717          	auipc	a4,0x0
ffffffffc0205ed2:	99270713          	addi	a4,a4,-1646 # ffffffffc0205860 <kernel_thread_entry>
ffffffffc0205ed6:	4581                	li	a1,0
ffffffffc0205ed8:	e23e                	sd	a5,256(sp)
ffffffffc0205eda:	e63a                	sd	a4,264(sp)
ffffffffc0205edc:	b97ff0ef          	jal	ffffffffc0205a72 <do_fork>
ffffffffc0205ee0:	70f2                	ld	ra,312(sp)
ffffffffc0205ee2:	7452                	ld	s0,304(sp)
ffffffffc0205ee4:	74b2                	ld	s1,296(sp)
ffffffffc0205ee6:	7912                	ld	s2,288(sp)
ffffffffc0205ee8:	6131                	addi	sp,sp,320
ffffffffc0205eea:	8082                	ret

ffffffffc0205eec <do_exit>:
ffffffffc0205eec:	7179                	addi	sp,sp,-48
ffffffffc0205eee:	f022                	sd	s0,32(sp)
ffffffffc0205ef0:	00091417          	auipc	s0,0x91
ffffffffc0205ef4:	9d840413          	addi	s0,s0,-1576 # ffffffffc02968c8 <current>
ffffffffc0205ef8:	601c                	ld	a5,0(s0)
ffffffffc0205efa:	00091717          	auipc	a4,0x91
ffffffffc0205efe:	9de73703          	ld	a4,-1570(a4) # ffffffffc02968d8 <idleproc>
ffffffffc0205f02:	f406                	sd	ra,40(sp)
ffffffffc0205f04:	ec26                	sd	s1,24(sp)
ffffffffc0205f06:	0ee78763          	beq	a5,a4,ffffffffc0205ff4 <do_exit+0x108>
ffffffffc0205f0a:	00091497          	auipc	s1,0x91
ffffffffc0205f0e:	9c648493          	addi	s1,s1,-1594 # ffffffffc02968d0 <initproc>
ffffffffc0205f12:	6098                	ld	a4,0(s1)
ffffffffc0205f14:	e84a                	sd	s2,16(sp)
ffffffffc0205f16:	10e78863          	beq	a5,a4,ffffffffc0206026 <do_exit+0x13a>
ffffffffc0205f1a:	7798                	ld	a4,40(a5)
ffffffffc0205f1c:	892a                	mv	s2,a0
ffffffffc0205f1e:	cb0d                	beqz	a4,ffffffffc0205f50 <do_exit+0x64>
ffffffffc0205f20:	00091797          	auipc	a5,0x91
ffffffffc0205f24:	9787b783          	ld	a5,-1672(a5) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc0205f28:	56fd                	li	a3,-1
ffffffffc0205f2a:	16fe                	slli	a3,a3,0x3f
ffffffffc0205f2c:	83b1                	srli	a5,a5,0xc
ffffffffc0205f2e:	8fd5                	or	a5,a5,a3
ffffffffc0205f30:	18079073          	csrw	satp,a5
ffffffffc0205f34:	5b1c                	lw	a5,48(a4)
ffffffffc0205f36:	37fd                	addiw	a5,a5,-1
ffffffffc0205f38:	db1c                	sw	a5,48(a4)
ffffffffc0205f3a:	cbf1                	beqz	a5,ffffffffc020600e <do_exit+0x122>
ffffffffc0205f3c:	601c                	ld	a5,0(s0)
ffffffffc0205f3e:	1487b503          	ld	a0,328(a5)
ffffffffc0205f42:	0207b423          	sd	zero,40(a5)
ffffffffc0205f46:	c509                	beqz	a0,ffffffffc0205f50 <do_exit+0x64>
ffffffffc0205f48:	491c                	lw	a5,16(a0)
ffffffffc0205f4a:	37fd                	addiw	a5,a5,-1
ffffffffc0205f4c:	c91c                	sw	a5,16(a0)
ffffffffc0205f4e:	c3c5                	beqz	a5,ffffffffc0205fee <do_exit+0x102>
ffffffffc0205f50:	601c                	ld	a5,0(s0)
ffffffffc0205f52:	470d                	li	a4,3
ffffffffc0205f54:	0f27a423          	sw	s2,232(a5)
ffffffffc0205f58:	c398                	sw	a4,0(a5)
ffffffffc0205f5a:	100027f3          	csrr	a5,sstatus
ffffffffc0205f5e:	8b89                	andi	a5,a5,2
ffffffffc0205f60:	4901                	li	s2,0
ffffffffc0205f62:	0c079e63          	bnez	a5,ffffffffc020603e <do_exit+0x152>
ffffffffc0205f66:	6018                	ld	a4,0(s0)
ffffffffc0205f68:	800007b7          	lui	a5,0x80000
ffffffffc0205f6c:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc0205f6e:	7308                	ld	a0,32(a4)
ffffffffc0205f70:	0ec52703          	lw	a4,236(a0)
ffffffffc0205f74:	0cf70963          	beq	a4,a5,ffffffffc0206046 <do_exit+0x15a>
ffffffffc0205f78:	6018                	ld	a4,0(s0)
ffffffffc0205f7a:	7b7c                	ld	a5,240(a4)
ffffffffc0205f7c:	c7a1                	beqz	a5,ffffffffc0205fc4 <do_exit+0xd8>
ffffffffc0205f7e:	800005b7          	lui	a1,0x80000
ffffffffc0205f82:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc0205f84:	460d                	li	a2,3
ffffffffc0205f86:	a021                	j	ffffffffc0205f8e <do_exit+0xa2>
ffffffffc0205f88:	6018                	ld	a4,0(s0)
ffffffffc0205f8a:	7b7c                	ld	a5,240(a4)
ffffffffc0205f8c:	cf85                	beqz	a5,ffffffffc0205fc4 <do_exit+0xd8>
ffffffffc0205f8e:	1007b683          	ld	a3,256(a5)
ffffffffc0205f92:	6088                	ld	a0,0(s1)
ffffffffc0205f94:	fb74                	sd	a3,240(a4)
ffffffffc0205f96:	0e07bc23          	sd	zero,248(a5)
ffffffffc0205f9a:	7978                	ld	a4,240(a0)
ffffffffc0205f9c:	10e7b023          	sd	a4,256(a5)
ffffffffc0205fa0:	c311                	beqz	a4,ffffffffc0205fa4 <do_exit+0xb8>
ffffffffc0205fa2:	ff7c                	sd	a5,248(a4)
ffffffffc0205fa4:	4398                	lw	a4,0(a5)
ffffffffc0205fa6:	f388                	sd	a0,32(a5)
ffffffffc0205fa8:	f97c                	sd	a5,240(a0)
ffffffffc0205faa:	fcc71fe3          	bne	a4,a2,ffffffffc0205f88 <do_exit+0x9c>
ffffffffc0205fae:	0ec52783          	lw	a5,236(a0)
ffffffffc0205fb2:	fcb79be3          	bne	a5,a1,ffffffffc0205f88 <do_exit+0x9c>
ffffffffc0205fb6:	1b0010ef          	jal	ffffffffc0207166 <wakeup_proc>
ffffffffc0205fba:	800005b7          	lui	a1,0x80000
ffffffffc0205fbe:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc0205fc0:	460d                	li	a2,3
ffffffffc0205fc2:	b7d9                	j	ffffffffc0205f88 <do_exit+0x9c>
ffffffffc0205fc4:	02091263          	bnez	s2,ffffffffc0205fe8 <do_exit+0xfc>
ffffffffc0205fc8:	296010ef          	jal	ffffffffc020725e <schedule>
ffffffffc0205fcc:	601c                	ld	a5,0(s0)
ffffffffc0205fce:	00007617          	auipc	a2,0x7
ffffffffc0205fd2:	27260613          	addi	a2,a2,626 # ffffffffc020d240 <etext+0x1e3e>
ffffffffc0205fd6:	29000593          	li	a1,656
ffffffffc0205fda:	43d4                	lw	a3,4(a5)
ffffffffc0205fdc:	00007517          	auipc	a0,0x7
ffffffffc0205fe0:	21450513          	addi	a0,a0,532 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0205fe4:	c66fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205fe8:	c0ffa0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc0205fec:	bff1                	j	ffffffffc0205fc8 <do_exit+0xdc>
ffffffffc0205fee:	866ff0ef          	jal	ffffffffc0205054 <files_destroy>
ffffffffc0205ff2:	bfb9                	j	ffffffffc0205f50 <do_exit+0x64>
ffffffffc0205ff4:	00007617          	auipc	a2,0x7
ffffffffc0205ff8:	22c60613          	addi	a2,a2,556 # ffffffffc020d220 <etext+0x1e1e>
ffffffffc0205ffc:	25b00593          	li	a1,603
ffffffffc0206000:	00007517          	auipc	a0,0x7
ffffffffc0206004:	1f050513          	addi	a0,a0,496 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0206008:	e84a                	sd	s2,16(sp)
ffffffffc020600a:	c40fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020600e:	853a                	mv	a0,a4
ffffffffc0206010:	e43a                	sd	a4,8(sp)
ffffffffc0206012:	cebfd0ef          	jal	ffffffffc0203cfc <exit_mmap>
ffffffffc0206016:	6722                	ld	a4,8(sp)
ffffffffc0206018:	6f08                	ld	a0,24(a4)
ffffffffc020601a:	8f7ff0ef          	jal	ffffffffc0205910 <put_pgdir.isra.0>
ffffffffc020601e:	6522                	ld	a0,8(sp)
ffffffffc0206020:	b27fd0ef          	jal	ffffffffc0203b46 <mm_destroy>
ffffffffc0206024:	bf21                	j	ffffffffc0205f3c <do_exit+0x50>
ffffffffc0206026:	00007617          	auipc	a2,0x7
ffffffffc020602a:	20a60613          	addi	a2,a2,522 # ffffffffc020d230 <etext+0x1e2e>
ffffffffc020602e:	25f00593          	li	a1,607
ffffffffc0206032:	00007517          	auipc	a0,0x7
ffffffffc0206036:	1be50513          	addi	a0,a0,446 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc020603a:	c10fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020603e:	bbffa0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0206042:	4905                	li	s2,1
ffffffffc0206044:	b70d                	j	ffffffffc0205f66 <do_exit+0x7a>
ffffffffc0206046:	120010ef          	jal	ffffffffc0207166 <wakeup_proc>
ffffffffc020604a:	b73d                	j	ffffffffc0205f78 <do_exit+0x8c>

ffffffffc020604c <do_wait.part.0>:
ffffffffc020604c:	7179                	addi	sp,sp,-48
ffffffffc020604e:	ec26                	sd	s1,24(sp)
ffffffffc0206050:	e84a                	sd	s2,16(sp)
ffffffffc0206052:	e44e                	sd	s3,8(sp)
ffffffffc0206054:	f406                	sd	ra,40(sp)
ffffffffc0206056:	f022                	sd	s0,32(sp)
ffffffffc0206058:	84aa                	mv	s1,a0
ffffffffc020605a:	892e                	mv	s2,a1
ffffffffc020605c:	00091997          	auipc	s3,0x91
ffffffffc0206060:	86c98993          	addi	s3,s3,-1940 # ffffffffc02968c8 <current>
ffffffffc0206064:	cd19                	beqz	a0,ffffffffc0206082 <do_wait.part.0+0x36>
ffffffffc0206066:	6789                	lui	a5,0x2
ffffffffc0206068:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_bin_swap_img_size-0x5d02>
ffffffffc020606a:	fff5071b          	addiw	a4,a0,-1
ffffffffc020606e:	12e7f563          	bgeu	a5,a4,ffffffffc0206198 <do_wait.part.0+0x14c>
ffffffffc0206072:	70a2                	ld	ra,40(sp)
ffffffffc0206074:	7402                	ld	s0,32(sp)
ffffffffc0206076:	64e2                	ld	s1,24(sp)
ffffffffc0206078:	6942                	ld	s2,16(sp)
ffffffffc020607a:	69a2                	ld	s3,8(sp)
ffffffffc020607c:	5579                	li	a0,-2
ffffffffc020607e:	6145                	addi	sp,sp,48
ffffffffc0206080:	8082                	ret
ffffffffc0206082:	0009b703          	ld	a4,0(s3)
ffffffffc0206086:	7b60                	ld	s0,240(a4)
ffffffffc0206088:	d46d                	beqz	s0,ffffffffc0206072 <do_wait.part.0+0x26>
ffffffffc020608a:	468d                	li	a3,3
ffffffffc020608c:	a021                	j	ffffffffc0206094 <do_wait.part.0+0x48>
ffffffffc020608e:	10043403          	ld	s0,256(s0)
ffffffffc0206092:	c075                	beqz	s0,ffffffffc0206176 <do_wait.part.0+0x12a>
ffffffffc0206094:	401c                	lw	a5,0(s0)
ffffffffc0206096:	fed79ce3          	bne	a5,a3,ffffffffc020608e <do_wait.part.0+0x42>
ffffffffc020609a:	00091797          	auipc	a5,0x91
ffffffffc020609e:	83e7b783          	ld	a5,-1986(a5) # ffffffffc02968d8 <idleproc>
ffffffffc02060a2:	14878263          	beq	a5,s0,ffffffffc02061e6 <do_wait.part.0+0x19a>
ffffffffc02060a6:	00091797          	auipc	a5,0x91
ffffffffc02060aa:	82a7b783          	ld	a5,-2006(a5) # ffffffffc02968d0 <initproc>
ffffffffc02060ae:	12f40c63          	beq	s0,a5,ffffffffc02061e6 <do_wait.part.0+0x19a>
ffffffffc02060b2:	00090663          	beqz	s2,ffffffffc02060be <do_wait.part.0+0x72>
ffffffffc02060b6:	0e842783          	lw	a5,232(s0)
ffffffffc02060ba:	00f92023          	sw	a5,0(s2)
ffffffffc02060be:	100027f3          	csrr	a5,sstatus
ffffffffc02060c2:	8b89                	andi	a5,a5,2
ffffffffc02060c4:	4601                	li	a2,0
ffffffffc02060c6:	10079963          	bnez	a5,ffffffffc02061d8 <do_wait.part.0+0x18c>
ffffffffc02060ca:	6c74                	ld	a3,216(s0)
ffffffffc02060cc:	7078                	ld	a4,224(s0)
ffffffffc02060ce:	10043783          	ld	a5,256(s0)
ffffffffc02060d2:	e698                	sd	a4,8(a3)
ffffffffc02060d4:	e314                	sd	a3,0(a4)
ffffffffc02060d6:	6474                	ld	a3,200(s0)
ffffffffc02060d8:	6878                	ld	a4,208(s0)
ffffffffc02060da:	e698                	sd	a4,8(a3)
ffffffffc02060dc:	e314                	sd	a3,0(a4)
ffffffffc02060de:	c789                	beqz	a5,ffffffffc02060e8 <do_wait.part.0+0x9c>
ffffffffc02060e0:	7c78                	ld	a4,248(s0)
ffffffffc02060e2:	fff8                	sd	a4,248(a5)
ffffffffc02060e4:	10043783          	ld	a5,256(s0)
ffffffffc02060e8:	7c78                	ld	a4,248(s0)
ffffffffc02060ea:	c36d                	beqz	a4,ffffffffc02061cc <do_wait.part.0+0x180>
ffffffffc02060ec:	10f73023          	sd	a5,256(a4)
ffffffffc02060f0:	00090797          	auipc	a5,0x90
ffffffffc02060f4:	7d07a783          	lw	a5,2000(a5) # ffffffffc02968c0 <nr_process>
ffffffffc02060f8:	37fd                	addiw	a5,a5,-1
ffffffffc02060fa:	00090717          	auipc	a4,0x90
ffffffffc02060fe:	7cf72323          	sw	a5,1990(a4) # ffffffffc02968c0 <nr_process>
ffffffffc0206102:	e271                	bnez	a2,ffffffffc02061c6 <do_wait.part.0+0x17a>
ffffffffc0206104:	6814                	ld	a3,16(s0)
ffffffffc0206106:	c02007b7          	lui	a5,0xc0200
ffffffffc020610a:	10f6e663          	bltu	a3,a5,ffffffffc0206216 <do_wait.part.0+0x1ca>
ffffffffc020610e:	00090717          	auipc	a4,0x90
ffffffffc0206112:	79a73703          	ld	a4,1946(a4) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0206116:	00090797          	auipc	a5,0x90
ffffffffc020611a:	79a7b783          	ld	a5,1946(a5) # ffffffffc02968b0 <npage>
ffffffffc020611e:	8e99                	sub	a3,a3,a4
ffffffffc0206120:	82b1                	srli	a3,a3,0xc
ffffffffc0206122:	0cf6fe63          	bgeu	a3,a5,ffffffffc02061fe <do_wait.part.0+0x1b2>
ffffffffc0206126:	00009797          	auipc	a5,0x9
ffffffffc020612a:	4aa7b783          	ld	a5,1194(a5) # ffffffffc020f5d0 <nbase>
ffffffffc020612e:	00090517          	auipc	a0,0x90
ffffffffc0206132:	78a53503          	ld	a0,1930(a0) # ffffffffc02968b8 <pages>
ffffffffc0206136:	4589                	li	a1,2
ffffffffc0206138:	8e9d                	sub	a3,a3,a5
ffffffffc020613a:	069a                	slli	a3,a3,0x6
ffffffffc020613c:	9536                	add	a0,a0,a3
ffffffffc020613e:	894fc0ef          	jal	ffffffffc02021d2 <free_pages>
ffffffffc0206142:	8522                	mv	a0,s0
ffffffffc0206144:	f37fb0ef          	jal	ffffffffc020207a <kfree>
ffffffffc0206148:	70a2                	ld	ra,40(sp)
ffffffffc020614a:	7402                	ld	s0,32(sp)
ffffffffc020614c:	64e2                	ld	s1,24(sp)
ffffffffc020614e:	6942                	ld	s2,16(sp)
ffffffffc0206150:	69a2                	ld	s3,8(sp)
ffffffffc0206152:	4501                	li	a0,0
ffffffffc0206154:	6145                	addi	sp,sp,48
ffffffffc0206156:	8082                	ret
ffffffffc0206158:	00090997          	auipc	s3,0x90
ffffffffc020615c:	77098993          	addi	s3,s3,1904 # ffffffffc02968c8 <current>
ffffffffc0206160:	0009b703          	ld	a4,0(s3)
ffffffffc0206164:	f487b683          	ld	a3,-184(a5)
ffffffffc0206168:	f0e695e3          	bne	a3,a4,ffffffffc0206072 <do_wait.part.0+0x26>
ffffffffc020616c:	f287a603          	lw	a2,-216(a5)
ffffffffc0206170:	468d                	li	a3,3
ffffffffc0206172:	06d60063          	beq	a2,a3,ffffffffc02061d2 <do_wait.part.0+0x186>
ffffffffc0206176:	800007b7          	lui	a5,0x80000
ffffffffc020617a:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc020617c:	4685                	li	a3,1
ffffffffc020617e:	0ef72623          	sw	a5,236(a4)
ffffffffc0206182:	c314                	sw	a3,0(a4)
ffffffffc0206184:	0da010ef          	jal	ffffffffc020725e <schedule>
ffffffffc0206188:	0009b783          	ld	a5,0(s3)
ffffffffc020618c:	0b07a783          	lw	a5,176(a5)
ffffffffc0206190:	8b85                	andi	a5,a5,1
ffffffffc0206192:	e7b9                	bnez	a5,ffffffffc02061e0 <do_wait.part.0+0x194>
ffffffffc0206194:	ee0487e3          	beqz	s1,ffffffffc0206082 <do_wait.part.0+0x36>
ffffffffc0206198:	45a9                	li	a1,10
ffffffffc020619a:	8526                	mv	a0,s1
ffffffffc020619c:	4c3040ef          	jal	ffffffffc020ae5e <hash32>
ffffffffc02061a0:	02051793          	slli	a5,a0,0x20
ffffffffc02061a4:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02061a8:	0008b797          	auipc	a5,0x8b
ffffffffc02061ac:	61878793          	addi	a5,a5,1560 # ffffffffc02917c0 <hash_list>
ffffffffc02061b0:	953e                	add	a0,a0,a5
ffffffffc02061b2:	87aa                	mv	a5,a0
ffffffffc02061b4:	a029                	j	ffffffffc02061be <do_wait.part.0+0x172>
ffffffffc02061b6:	f2c7a703          	lw	a4,-212(a5)
ffffffffc02061ba:	f8970fe3          	beq	a4,s1,ffffffffc0206158 <do_wait.part.0+0x10c>
ffffffffc02061be:	679c                	ld	a5,8(a5)
ffffffffc02061c0:	fef51be3          	bne	a0,a5,ffffffffc02061b6 <do_wait.part.0+0x16a>
ffffffffc02061c4:	b57d                	j	ffffffffc0206072 <do_wait.part.0+0x26>
ffffffffc02061c6:	a31fa0ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc02061ca:	bf2d                	j	ffffffffc0206104 <do_wait.part.0+0xb8>
ffffffffc02061cc:	7018                	ld	a4,32(s0)
ffffffffc02061ce:	fb7c                	sd	a5,240(a4)
ffffffffc02061d0:	b705                	j	ffffffffc02060f0 <do_wait.part.0+0xa4>
ffffffffc02061d2:	f2878413          	addi	s0,a5,-216
ffffffffc02061d6:	b5d1                	j	ffffffffc020609a <do_wait.part.0+0x4e>
ffffffffc02061d8:	a25fa0ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc02061dc:	4605                	li	a2,1
ffffffffc02061de:	b5f5                	j	ffffffffc02060ca <do_wait.part.0+0x7e>
ffffffffc02061e0:	555d                	li	a0,-9
ffffffffc02061e2:	d0bff0ef          	jal	ffffffffc0205eec <do_exit>
ffffffffc02061e6:	00007617          	auipc	a2,0x7
ffffffffc02061ea:	07a60613          	addi	a2,a2,122 # ffffffffc020d260 <etext+0x1e5e>
ffffffffc02061ee:	40f00593          	li	a1,1039
ffffffffc02061f2:	00007517          	auipc	a0,0x7
ffffffffc02061f6:	ffe50513          	addi	a0,a0,-2 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc02061fa:	a50fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02061fe:	00006617          	auipc	a2,0x6
ffffffffc0206202:	18a60613          	addi	a2,a2,394 # ffffffffc020c388 <etext+0xf86>
ffffffffc0206206:	06900593          	li	a1,105
ffffffffc020620a:	00006517          	auipc	a0,0x6
ffffffffc020620e:	0d650513          	addi	a0,a0,214 # ffffffffc020c2e0 <etext+0xede>
ffffffffc0206212:	a38fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206216:	00006617          	auipc	a2,0x6
ffffffffc020621a:	14a60613          	addi	a2,a2,330 # ffffffffc020c360 <etext+0xf5e>
ffffffffc020621e:	07700593          	li	a1,119
ffffffffc0206222:	00006517          	auipc	a0,0x6
ffffffffc0206226:	0be50513          	addi	a0,a0,190 # ffffffffc020c2e0 <etext+0xede>
ffffffffc020622a:	a20fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020622e <init_main>:
ffffffffc020622e:	1141                	addi	sp,sp,-16
ffffffffc0206230:	00007517          	auipc	a0,0x7
ffffffffc0206234:	05050513          	addi	a0,a0,80 # ffffffffc020d280 <etext+0x1e7e>
ffffffffc0206238:	e406                	sd	ra,8(sp)
ffffffffc020623a:	634010ef          	jal	ffffffffc020786e <vfs_set_bootfs>
ffffffffc020623e:	e179                	bnez	a0,ffffffffc0206304 <init_main+0xd6>
ffffffffc0206240:	fcbfb0ef          	jal	ffffffffc020220a <nr_free_pages>
ffffffffc0206244:	d8dfb0ef          	jal	ffffffffc0201fd0 <kallocated>
ffffffffc0206248:	4601                	li	a2,0
ffffffffc020624a:	4581                	li	a1,0
ffffffffc020624c:	00001517          	auipc	a0,0x1
ffffffffc0206250:	97850513          	addi	a0,a0,-1672 # ffffffffc0206bc4 <user_main>
ffffffffc0206254:	c49ff0ef          	jal	ffffffffc0205e9c <kernel_thread>
ffffffffc0206258:	00a04563          	bgtz	a0,ffffffffc0206262 <init_main+0x34>
ffffffffc020625c:	a841                	j	ffffffffc02062ec <init_main+0xbe>
ffffffffc020625e:	000010ef          	jal	ffffffffc020725e <schedule>
ffffffffc0206262:	4581                	li	a1,0
ffffffffc0206264:	4501                	li	a0,0
ffffffffc0206266:	de7ff0ef          	jal	ffffffffc020604c <do_wait.part.0>
ffffffffc020626a:	d975                	beqz	a0,ffffffffc020625e <init_main+0x30>
ffffffffc020626c:	da3fe0ef          	jal	ffffffffc020500e <fs_cleanup>
ffffffffc0206270:	00007517          	auipc	a0,0x7
ffffffffc0206274:	05850513          	addi	a0,a0,88 # ffffffffc020d2c8 <etext+0x1ec6>
ffffffffc0206278:	f2ff90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020627c:	00090797          	auipc	a5,0x90
ffffffffc0206280:	6547b783          	ld	a5,1620(a5) # ffffffffc02968d0 <initproc>
ffffffffc0206284:	7bf8                	ld	a4,240(a5)
ffffffffc0206286:	e339                	bnez	a4,ffffffffc02062cc <init_main+0x9e>
ffffffffc0206288:	7ff8                	ld	a4,248(a5)
ffffffffc020628a:	e329                	bnez	a4,ffffffffc02062cc <init_main+0x9e>
ffffffffc020628c:	1007b703          	ld	a4,256(a5)
ffffffffc0206290:	ef15                	bnez	a4,ffffffffc02062cc <init_main+0x9e>
ffffffffc0206292:	00090697          	auipc	a3,0x90
ffffffffc0206296:	62e6a683          	lw	a3,1582(a3) # ffffffffc02968c0 <nr_process>
ffffffffc020629a:	4709                	li	a4,2
ffffffffc020629c:	0ce69163          	bne	a3,a4,ffffffffc020635e <init_main+0x130>
ffffffffc02062a0:	0008f717          	auipc	a4,0x8f
ffffffffc02062a4:	52070713          	addi	a4,a4,1312 # ffffffffc02957c0 <proc_list>
ffffffffc02062a8:	6714                	ld	a3,8(a4)
ffffffffc02062aa:	0c878793          	addi	a5,a5,200
ffffffffc02062ae:	08d79863          	bne	a5,a3,ffffffffc020633e <init_main+0x110>
ffffffffc02062b2:	6318                	ld	a4,0(a4)
ffffffffc02062b4:	06e79563          	bne	a5,a4,ffffffffc020631e <init_main+0xf0>
ffffffffc02062b8:	00007517          	auipc	a0,0x7
ffffffffc02062bc:	0f850513          	addi	a0,a0,248 # ffffffffc020d3b0 <etext+0x1fae>
ffffffffc02062c0:	ee7f90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02062c4:	60a2                	ld	ra,8(sp)
ffffffffc02062c6:	4501                	li	a0,0
ffffffffc02062c8:	0141                	addi	sp,sp,16
ffffffffc02062ca:	8082                	ret
ffffffffc02062cc:	00007697          	auipc	a3,0x7
ffffffffc02062d0:	02468693          	addi	a3,a3,36 # ffffffffc020d2f0 <etext+0x1eee>
ffffffffc02062d4:	00005617          	auipc	a2,0x5
ffffffffc02062d8:	56c60613          	addi	a2,a2,1388 # ffffffffc020b840 <etext+0x43e>
ffffffffc02062dc:	48500593          	li	a1,1157
ffffffffc02062e0:	00007517          	auipc	a0,0x7
ffffffffc02062e4:	f1050513          	addi	a0,a0,-240 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc02062e8:	962fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02062ec:	00007617          	auipc	a2,0x7
ffffffffc02062f0:	fbc60613          	addi	a2,a2,-68 # ffffffffc020d2a8 <etext+0x1ea6>
ffffffffc02062f4:	47800593          	li	a1,1144
ffffffffc02062f8:	00007517          	auipc	a0,0x7
ffffffffc02062fc:	ef850513          	addi	a0,a0,-264 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0206300:	94afa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206304:	86aa                	mv	a3,a0
ffffffffc0206306:	00007617          	auipc	a2,0x7
ffffffffc020630a:	f8260613          	addi	a2,a2,-126 # ffffffffc020d288 <etext+0x1e86>
ffffffffc020630e:	47000593          	li	a1,1136
ffffffffc0206312:	00007517          	auipc	a0,0x7
ffffffffc0206316:	ede50513          	addi	a0,a0,-290 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc020631a:	930fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020631e:	00007697          	auipc	a3,0x7
ffffffffc0206322:	06268693          	addi	a3,a3,98 # ffffffffc020d380 <etext+0x1f7e>
ffffffffc0206326:	00005617          	auipc	a2,0x5
ffffffffc020632a:	51a60613          	addi	a2,a2,1306 # ffffffffc020b840 <etext+0x43e>
ffffffffc020632e:	48800593          	li	a1,1160
ffffffffc0206332:	00007517          	auipc	a0,0x7
ffffffffc0206336:	ebe50513          	addi	a0,a0,-322 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc020633a:	910fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020633e:	00007697          	auipc	a3,0x7
ffffffffc0206342:	01268693          	addi	a3,a3,18 # ffffffffc020d350 <etext+0x1f4e>
ffffffffc0206346:	00005617          	auipc	a2,0x5
ffffffffc020634a:	4fa60613          	addi	a2,a2,1274 # ffffffffc020b840 <etext+0x43e>
ffffffffc020634e:	48700593          	li	a1,1159
ffffffffc0206352:	00007517          	auipc	a0,0x7
ffffffffc0206356:	e9e50513          	addi	a0,a0,-354 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc020635a:	8f0fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020635e:	00007697          	auipc	a3,0x7
ffffffffc0206362:	fe268693          	addi	a3,a3,-30 # ffffffffc020d340 <etext+0x1f3e>
ffffffffc0206366:	00005617          	auipc	a2,0x5
ffffffffc020636a:	4da60613          	addi	a2,a2,1242 # ffffffffc020b840 <etext+0x43e>
ffffffffc020636e:	48600593          	li	a1,1158
ffffffffc0206372:	00007517          	auipc	a0,0x7
ffffffffc0206376:	e7e50513          	addi	a0,a0,-386 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc020637a:	8d0fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020637e <do_execve>:
ffffffffc020637e:	db010113          	addi	sp,sp,-592
ffffffffc0206382:	21613823          	sd	s6,528(sp)
ffffffffc0206386:	24113423          	sd	ra,584(sp)
ffffffffc020638a:	f7ee                	sd	s11,488(sp)
ffffffffc020638c:	fff58b1b          	addiw	s6,a1,-1
ffffffffc0206390:	47fd                	li	a5,31
ffffffffc0206392:	5f67ea63          	bltu	a5,s6,ffffffffc0206986 <do_execve+0x608>
ffffffffc0206396:	23213823          	sd	s2,560(sp)
ffffffffc020639a:	00090917          	auipc	s2,0x90
ffffffffc020639e:	52e90913          	addi	s2,s2,1326 # ffffffffc02968c8 <current>
ffffffffc02063a2:	00093783          	ld	a5,0(s2)
ffffffffc02063a6:	21513c23          	sd	s5,536(sp)
ffffffffc02063aa:	24813023          	sd	s0,576(sp)
ffffffffc02063ae:	0287ba83          	ld	s5,40(a5)
ffffffffc02063b2:	22913c23          	sd	s1,568(sp)
ffffffffc02063b6:	21813023          	sd	s8,512(sp)
ffffffffc02063ba:	84aa                	mv	s1,a0
ffffffffc02063bc:	8c32                	mv	s8,a2
ffffffffc02063be:	842e                	mv	s0,a1
ffffffffc02063c0:	08a8                	addi	a0,sp,88
ffffffffc02063c2:	4641                	li	a2,16
ffffffffc02063c4:	4581                	li	a1,0
ffffffffc02063c6:	7d5040ef          	jal	ffffffffc020b39a <memset>
ffffffffc02063ca:	000a8c63          	beqz	s5,ffffffffc02063e2 <do_execve+0x64>
ffffffffc02063ce:	038a8513          	addi	a0,s5,56
ffffffffc02063d2:	fcbfd0ef          	jal	ffffffffc020439c <down>
ffffffffc02063d6:	00093783          	ld	a5,0(s2)
ffffffffc02063da:	c781                	beqz	a5,ffffffffc02063e2 <do_execve+0x64>
ffffffffc02063dc:	43dc                	lw	a5,4(a5)
ffffffffc02063de:	04faa823          	sw	a5,80(s5)
ffffffffc02063e2:	1c048963          	beqz	s1,ffffffffc02065b4 <do_execve+0x236>
ffffffffc02063e6:	8626                	mv	a2,s1
ffffffffc02063e8:	46c1                	li	a3,16
ffffffffc02063ea:	08ac                	addi	a1,sp,88
ffffffffc02063ec:	8556                	mv	a0,s5
ffffffffc02063ee:	dbffd0ef          	jal	ffffffffc02041ac <copy_string>
ffffffffc02063f2:	56050863          	beqz	a0,ffffffffc0206962 <do_execve+0x5e4>
ffffffffc02063f6:	23413023          	sd	s4,544(sp)
ffffffffc02063fa:	fbea                	sd	s10,496(sp)
ffffffffc02063fc:	00341d13          	slli	s10,s0,0x3
ffffffffc0206400:	866a                	mv	a2,s10
ffffffffc0206402:	4681                	li	a3,0
ffffffffc0206404:	85e2                	mv	a1,s8
ffffffffc0206406:	8556                	mv	a0,s5
ffffffffc0206408:	8a62                	mv	s4,s8
ffffffffc020640a:	c91fd0ef          	jal	ffffffffc020409a <user_mem_check>
ffffffffc020640e:	6a050963          	beqz	a0,ffffffffc0206ac0 <do_execve+0x742>
ffffffffc0206412:	23313423          	sd	s3,552(sp)
ffffffffc0206416:	21713423          	sd	s7,520(sp)
ffffffffc020641a:	4981                	li	s3,0
ffffffffc020641c:	0e010b93          	addi	s7,sp,224
ffffffffc0206420:	6505                	lui	a0,0x1
ffffffffc0206422:	bb3fb0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0206426:	84aa                	mv	s1,a0
ffffffffc0206428:	10050863          	beqz	a0,ffffffffc0206538 <do_execve+0x1ba>
ffffffffc020642c:	000a3603          	ld	a2,0(s4)
ffffffffc0206430:	85aa                	mv	a1,a0
ffffffffc0206432:	6685                	lui	a3,0x1
ffffffffc0206434:	8556                	mv	a0,s5
ffffffffc0206436:	d77fd0ef          	jal	ffffffffc02041ac <copy_string>
ffffffffc020643a:	16050863          	beqz	a0,ffffffffc02065aa <do_execve+0x22c>
ffffffffc020643e:	009bb023          	sd	s1,0(s7)
ffffffffc0206442:	2985                	addiw	s3,s3,1
ffffffffc0206444:	0ba1                	addi	s7,s7,8
ffffffffc0206446:	0a21                	addi	s4,s4,8
ffffffffc0206448:	fd341ce3          	bne	s0,s3,ffffffffc0206420 <do_execve+0xa2>
ffffffffc020644c:	ffe6                	sd	s9,504(sp)
ffffffffc020644e:	000c3483          	ld	s1,0(s8)
ffffffffc0206452:	0a0a8663          	beqz	s5,ffffffffc02064fe <do_execve+0x180>
ffffffffc0206456:	038a8513          	addi	a0,s5,56
ffffffffc020645a:	f3ffd0ef          	jal	ffffffffc0204398 <up>
ffffffffc020645e:	00093783          	ld	a5,0(s2)
ffffffffc0206462:	040aa823          	sw	zero,80(s5)
ffffffffc0206466:	1487b503          	ld	a0,328(a5)
ffffffffc020646a:	c81fe0ef          	jal	ffffffffc02050ea <files_closeall>
ffffffffc020646e:	8526                	mv	a0,s1
ffffffffc0206470:	4581                	li	a1,0
ffffffffc0206472:	f09fe0ef          	jal	ffffffffc020537a <sysfile_open>
ffffffffc0206476:	8a2a                	mv	s4,a0
ffffffffc0206478:	6c054463          	bltz	a0,ffffffffc0206b40 <do_execve+0x7c2>
ffffffffc020647c:	00090797          	auipc	a5,0x90
ffffffffc0206480:	41c7b783          	ld	a5,1052(a5) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc0206484:	577d                	li	a4,-1
ffffffffc0206486:	177e                	slli	a4,a4,0x3f
ffffffffc0206488:	83b1                	srli	a5,a5,0xc
ffffffffc020648a:	8fd9                	or	a5,a5,a4
ffffffffc020648c:	18079073          	csrw	satp,a5
ffffffffc0206490:	030aa783          	lw	a5,48(s5)
ffffffffc0206494:	37fd                	addiw	a5,a5,-1
ffffffffc0206496:	02faa823          	sw	a5,48(s5)
ffffffffc020649a:	14078f63          	beqz	a5,ffffffffc02065f8 <do_execve+0x27a>
ffffffffc020649e:	00093783          	ld	a5,0(s2)
ffffffffc02064a2:	0207b423          	sd	zero,40(a5)
ffffffffc02064a6:	d54fd0ef          	jal	ffffffffc02039fa <mm_create>
ffffffffc02064aa:	89aa                	mv	s3,a0
ffffffffc02064ac:	5df1                	li	s11,-4
ffffffffc02064ae:	c505                	beqz	a0,ffffffffc02064d6 <do_execve+0x158>
ffffffffc02064b0:	cd8ff0ef          	jal	ffffffffc0205988 <setup_pgdir>
ffffffffc02064b4:	5df1                	li	s11,-4
ffffffffc02064b6:	ed09                	bnez	a0,ffffffffc02064d0 <do_execve+0x152>
ffffffffc02064b8:	4601                	li	a2,0
ffffffffc02064ba:	4581                	li	a1,0
ffffffffc02064bc:	8552                	mv	a0,s4
ffffffffc02064be:	974ff0ef          	jal	ffffffffc0205632 <sysfile_seek>
ffffffffc02064c2:	8daa                	mv	s11,a0
ffffffffc02064c4:	10050963          	beqz	a0,ffffffffc02065d6 <do_execve+0x258>
ffffffffc02064c8:	0189b503          	ld	a0,24(s3)
ffffffffc02064cc:	c44ff0ef          	jal	ffffffffc0205910 <put_pgdir.isra.0>
ffffffffc02064d0:	854e                	mv	a0,s3
ffffffffc02064d2:	e74fd0ef          	jal	ffffffffc0203b46 <mm_destroy>
ffffffffc02064d6:	0d010913          	addi	s2,sp,208
ffffffffc02064da:	020b1713          	slli	a4,s6,0x20
ffffffffc02064de:	01d75793          	srli	a5,a4,0x1d
ffffffffc02064e2:	996a                	add	s2,s2,s10
ffffffffc02064e4:	09a0                	addi	s0,sp,216
ffffffffc02064e6:	40f90933          	sub	s2,s2,a5
ffffffffc02064ea:	946a                	add	s0,s0,s10
ffffffffc02064ec:	6008                	ld	a0,0(s0)
ffffffffc02064ee:	1461                	addi	s0,s0,-8
ffffffffc02064f0:	b8bfb0ef          	jal	ffffffffc020207a <kfree>
ffffffffc02064f4:	ff241ce3          	bne	s0,s2,ffffffffc02064ec <do_execve+0x16e>
ffffffffc02064f8:	856e                	mv	a0,s11
ffffffffc02064fa:	9f3ff0ef          	jal	ffffffffc0205eec <do_exit>
ffffffffc02064fe:	00093783          	ld	a5,0(s2)
ffffffffc0206502:	1487b503          	ld	a0,328(a5)
ffffffffc0206506:	be5fe0ef          	jal	ffffffffc02050ea <files_closeall>
ffffffffc020650a:	8526                	mv	a0,s1
ffffffffc020650c:	4581                	li	a1,0
ffffffffc020650e:	e6dfe0ef          	jal	ffffffffc020537a <sysfile_open>
ffffffffc0206512:	8a2a                	mv	s4,a0
ffffffffc0206514:	0a054f63          	bltz	a0,ffffffffc02065d2 <do_execve+0x254>
ffffffffc0206518:	00093783          	ld	a5,0(s2)
ffffffffc020651c:	779c                	ld	a5,40(a5)
ffffffffc020651e:	d7c1                	beqz	a5,ffffffffc02064a6 <do_execve+0x128>
ffffffffc0206520:	00007617          	auipc	a2,0x7
ffffffffc0206524:	ec060613          	addi	a2,a2,-320 # ffffffffc020d3e0 <etext+0x1fde>
ffffffffc0206528:	2aa00593          	li	a1,682
ffffffffc020652c:	00007517          	auipc	a0,0x7
ffffffffc0206530:	cc450513          	addi	a0,a0,-828 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0206534:	f17f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206538:	5df1                	li	s11,-4
ffffffffc020653a:	02098663          	beqz	s3,ffffffffc0206566 <do_execve+0x1e8>
ffffffffc020653e:	00399793          	slli	a5,s3,0x3
ffffffffc0206542:	39fd                	addiw	s3,s3,-1
ffffffffc0206544:	0d010913          	addi	s2,sp,208
ffffffffc0206548:	02099713          	slli	a4,s3,0x20
ffffffffc020654c:	01d75993          	srli	s3,a4,0x1d
ffffffffc0206550:	993e                	add	s2,s2,a5
ffffffffc0206552:	09a0                	addi	s0,sp,216
ffffffffc0206554:	41390933          	sub	s2,s2,s3
ffffffffc0206558:	943e                	add	s0,s0,a5
ffffffffc020655a:	6008                	ld	a0,0(s0)
ffffffffc020655c:	1461                	addi	s0,s0,-8
ffffffffc020655e:	b1dfb0ef          	jal	ffffffffc020207a <kfree>
ffffffffc0206562:	ff241ce3          	bne	s0,s2,ffffffffc020655a <do_execve+0x1dc>
ffffffffc0206566:	22813983          	ld	s3,552(sp)
ffffffffc020656a:	20813b83          	ld	s7,520(sp)
ffffffffc020656e:	000a8863          	beqz	s5,ffffffffc020657e <do_execve+0x200>
ffffffffc0206572:	038a8513          	addi	a0,s5,56
ffffffffc0206576:	e23fd0ef          	jal	ffffffffc0204398 <up>
ffffffffc020657a:	040aa823          	sw	zero,80(s5)
ffffffffc020657e:	24013403          	ld	s0,576(sp)
ffffffffc0206582:	23813483          	ld	s1,568(sp)
ffffffffc0206586:	23013903          	ld	s2,560(sp)
ffffffffc020658a:	22013a03          	ld	s4,544(sp)
ffffffffc020658e:	21813a83          	ld	s5,536(sp)
ffffffffc0206592:	20013c03          	ld	s8,512(sp)
ffffffffc0206596:	7d5e                	ld	s10,496(sp)
ffffffffc0206598:	24813083          	ld	ra,584(sp)
ffffffffc020659c:	21013b03          	ld	s6,528(sp)
ffffffffc02065a0:	856e                	mv	a0,s11
ffffffffc02065a2:	7dbe                	ld	s11,488(sp)
ffffffffc02065a4:	25010113          	addi	sp,sp,592
ffffffffc02065a8:	8082                	ret
ffffffffc02065aa:	8526                	mv	a0,s1
ffffffffc02065ac:	acffb0ef          	jal	ffffffffc020207a <kfree>
ffffffffc02065b0:	5df5                	li	s11,-3
ffffffffc02065b2:	b761                	j	ffffffffc020653a <do_execve+0x1bc>
ffffffffc02065b4:	00093783          	ld	a5,0(s2)
ffffffffc02065b8:	00007617          	auipc	a2,0x7
ffffffffc02065bc:	e1860613          	addi	a2,a2,-488 # ffffffffc020d3d0 <etext+0x1fce>
ffffffffc02065c0:	45c1                	li	a1,16
ffffffffc02065c2:	43d4                	lw	a3,4(a5)
ffffffffc02065c4:	08a8                	addi	a0,sp,88
ffffffffc02065c6:	23413023          	sd	s4,544(sp)
ffffffffc02065ca:	fbea                	sd	s10,496(sp)
ffffffffc02065cc:	4cd040ef          	jal	ffffffffc020b298 <snprintf>
ffffffffc02065d0:	b535                	j	ffffffffc02063fc <do_execve+0x7e>
ffffffffc02065d2:	8daa                	mv	s11,a0
ffffffffc02065d4:	b709                	j	ffffffffc02064d6 <do_execve+0x158>
ffffffffc02065d6:	04000613          	li	a2,64
ffffffffc02065da:	110c                	addi	a1,sp,160
ffffffffc02065dc:	8552                	mv	a0,s4
ffffffffc02065de:	dd7fe0ef          	jal	ffffffffc02053b4 <sysfile_read>
ffffffffc02065e2:	04000793          	li	a5,64
ffffffffc02065e6:	02f50463          	beq	a0,a5,ffffffffc020660e <do_execve+0x290>
ffffffffc02065ea:	84aa                	mv	s1,a0
ffffffffc02065ec:	00054363          	bltz	a0,ffffffffc02065f2 <do_execve+0x274>
ffffffffc02065f0:	54fd                	li	s1,-1
ffffffffc02065f2:	00048d9b          	sext.w	s11,s1
ffffffffc02065f6:	bdc9                	j	ffffffffc02064c8 <do_execve+0x14a>
ffffffffc02065f8:	8556                	mv	a0,s5
ffffffffc02065fa:	f02fd0ef          	jal	ffffffffc0203cfc <exit_mmap>
ffffffffc02065fe:	018ab503          	ld	a0,24(s5)
ffffffffc0206602:	b0eff0ef          	jal	ffffffffc0205910 <put_pgdir.isra.0>
ffffffffc0206606:	8556                	mv	a0,s5
ffffffffc0206608:	d3efd0ef          	jal	ffffffffc0203b46 <mm_destroy>
ffffffffc020660c:	bd49                	j	ffffffffc020649e <do_execve+0x120>
ffffffffc020660e:	570a                	lw	a4,160(sp)
ffffffffc0206610:	464c47b7          	lui	a5,0x464c4
ffffffffc0206614:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_bin_sfs_img_size+0x4644f27f>
ffffffffc0206618:	32f71163          	bne	a4,a5,ffffffffc020693a <do_execve+0x5bc>
ffffffffc020661c:	0d815783          	lhu	a5,216(sp)
ffffffffc0206620:	cba5                	beqz	a5,ffffffffc0206690 <do_execve+0x312>
ffffffffc0206622:	f402                	sd	zero,40(sp)
ffffffffc0206624:	4a81                	li	s5,0
ffffffffc0206626:	e082                	sd	zero,64(sp)
ffffffffc0206628:	f06a                	sd	s10,32(sp)
ffffffffc020662a:	e452                	sd	s4,8(sp)
ffffffffc020662c:	e4a2                	sd	s0,72(sp)
ffffffffc020662e:	658e                	ld	a1,192(sp)
ffffffffc0206630:	6422                	ld	s0,8(sp)
ffffffffc0206632:	77a2                	ld	a5,40(sp)
ffffffffc0206634:	4601                	li	a2,0
ffffffffc0206636:	8522                	mv	a0,s0
ffffffffc0206638:	95be                	add	a1,a1,a5
ffffffffc020663a:	ff9fe0ef          	jal	ffffffffc0205632 <sysfile_seek>
ffffffffc020663e:	20051763          	bnez	a0,ffffffffc020684c <do_execve+0x4ce>
ffffffffc0206642:	03800613          	li	a2,56
ffffffffc0206646:	10ac                	addi	a1,sp,104
ffffffffc0206648:	8522                	mv	a0,s0
ffffffffc020664a:	d6bfe0ef          	jal	ffffffffc02053b4 <sysfile_read>
ffffffffc020664e:	03800793          	li	a5,56
ffffffffc0206652:	00f50d63          	beq	a0,a5,ffffffffc020666c <do_execve+0x2ee>
ffffffffc0206656:	7d02                	ld	s10,32(sp)
ffffffffc0206658:	84aa                	mv	s1,a0
ffffffffc020665a:	00054363          	bltz	a0,ffffffffc0206660 <do_execve+0x2e2>
ffffffffc020665e:	54fd                	li	s1,-1
ffffffffc0206660:	00048d9b          	sext.w	s11,s1
ffffffffc0206664:	854e                	mv	a0,s3
ffffffffc0206666:	e96fd0ef          	jal	ffffffffc0203cfc <exit_mmap>
ffffffffc020666a:	bdb9                	j	ffffffffc02064c8 <do_execve+0x14a>
ffffffffc020666c:	57a6                	lw	a5,104(sp)
ffffffffc020666e:	4705                	li	a4,1
ffffffffc0206670:	1ee78163          	beq	a5,a4,ffffffffc0206852 <do_execve+0x4d4>
ffffffffc0206674:	6706                	ld	a4,64(sp)
ffffffffc0206676:	76a2                	ld	a3,40(sp)
ffffffffc0206678:	0d815783          	lhu	a5,216(sp)
ffffffffc020667c:	2705                	addiw	a4,a4,1
ffffffffc020667e:	03868693          	addi	a3,a3,56 # 1038 <_binary_bin_swap_img_size-0x6cc8>
ffffffffc0206682:	e0ba                	sd	a4,64(sp)
ffffffffc0206684:	f436                	sd	a3,40(sp)
ffffffffc0206686:	faf764e3          	bltu	a4,a5,ffffffffc020662e <do_execve+0x2b0>
ffffffffc020668a:	7d02                	ld	s10,32(sp)
ffffffffc020668c:	6a22                	ld	s4,8(sp)
ffffffffc020668e:	6426                	ld	s0,72(sp)
ffffffffc0206690:	8552                	mv	a0,s4
ffffffffc0206692:	d1ffe0ef          	jal	ffffffffc02053b0 <sysfile_close>
ffffffffc0206696:	854e                	mv	a0,s3
ffffffffc0206698:	4701                	li	a4,0
ffffffffc020669a:	46ad                	li	a3,11
ffffffffc020669c:	00100637          	lui	a2,0x100
ffffffffc02066a0:	7ff005b7          	lui	a1,0x7ff00
ffffffffc02066a4:	cf4fd0ef          	jal	ffffffffc0203b98 <mm_map>
ffffffffc02066a8:	8daa                	mv	s11,a0
ffffffffc02066aa:	fd4d                	bnez	a0,ffffffffc0206664 <do_execve+0x2e6>
ffffffffc02066ac:	0189b503          	ld	a0,24(s3)
ffffffffc02066b0:	467d                	li	a2,31
ffffffffc02066b2:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc02066b6:	a62fd0ef          	jal	ffffffffc0203918 <pgdir_alloc_page>
ffffffffc02066ba:	4e050563          	beqz	a0,ffffffffc0206ba4 <do_execve+0x826>
ffffffffc02066be:	0189b503          	ld	a0,24(s3)
ffffffffc02066c2:	467d                	li	a2,31
ffffffffc02066c4:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc02066c8:	a50fd0ef          	jal	ffffffffc0203918 <pgdir_alloc_page>
ffffffffc02066cc:	4a050c63          	beqz	a0,ffffffffc0206b84 <do_execve+0x806>
ffffffffc02066d0:	0189b503          	ld	a0,24(s3)
ffffffffc02066d4:	467d                	li	a2,31
ffffffffc02066d6:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc02066da:	a3efd0ef          	jal	ffffffffc0203918 <pgdir_alloc_page>
ffffffffc02066de:	48050363          	beqz	a0,ffffffffc0206b64 <do_execve+0x7e6>
ffffffffc02066e2:	0189b503          	ld	a0,24(s3)
ffffffffc02066e6:	467d                	li	a2,31
ffffffffc02066e8:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc02066ec:	a2cfd0ef          	jal	ffffffffc0203918 <pgdir_alloc_page>
ffffffffc02066f0:	44050a63          	beqz	a0,ffffffffc0206b44 <do_execve+0x7c6>
ffffffffc02066f4:	0309a783          	lw	a5,48(s3)
ffffffffc02066f8:	00093603          	ld	a2,0(s2)
ffffffffc02066fc:	0189b683          	ld	a3,24(s3)
ffffffffc0206700:	2785                	addiw	a5,a5,1
ffffffffc0206702:	02f9a823          	sw	a5,48(s3)
ffffffffc0206706:	03363423          	sd	s3,40(a2) # 100028 <_binary_bin_sfs_img_size+0x8ad28>
ffffffffc020670a:	c02007b7          	lui	a5,0xc0200
ffffffffc020670e:	40f6e063          	bltu	a3,a5,ffffffffc0206b0e <do_execve+0x790>
ffffffffc0206712:	00090797          	auipc	a5,0x90
ffffffffc0206716:	1967b783          	ld	a5,406(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc020671a:	577d                	li	a4,-1
ffffffffc020671c:	177e                	slli	a4,a4,0x3f
ffffffffc020671e:	8e9d                	sub	a3,a3,a5
ffffffffc0206720:	00c6d793          	srli	a5,a3,0xc
ffffffffc0206724:	f654                	sd	a3,168(a2)
ffffffffc0206726:	8fd9                	or	a5,a5,a4
ffffffffc0206728:	18079073          	csrw	satp,a5
ffffffffc020672c:	4a01                	li	s4,0
ffffffffc020672e:	0e010a93          	addi	s5,sp,224
ffffffffc0206732:	4981                	li	s3,0
ffffffffc0206734:	000ab503          	ld	a0,0(s5)
ffffffffc0206738:	6585                	lui	a1,0x1
ffffffffc020673a:	2985                	addiw	s3,s3,1
ffffffffc020673c:	3c3040ef          	jal	ffffffffc020b2fe <strnlen>
ffffffffc0206740:	00150793          	addi	a5,a0,1
ffffffffc0206744:	0aa1                	addi	s5,s5,8
ffffffffc0206746:	01478a3b          	addw	s4,a5,s4
ffffffffc020674a:	fe89e5e3          	bltu	s3,s0,ffffffffc0206734 <do_execve+0x3b6>
ffffffffc020674e:	100009b7          	lui	s3,0x10000
ffffffffc0206752:	003a5a1b          	srliw	s4,s4,0x3
ffffffffc0206756:	19fd                	addi	s3,s3,-1 # fffffff <_binary_bin_sfs_img_size+0xff8acff>
ffffffffc0206758:	414989b3          	sub	s3,s3,s4
ffffffffc020675c:	098e                	slli	s3,s3,0x3
ffffffffc020675e:	119c                	addi	a5,sp,224
ffffffffc0206760:	41a98ab3          	sub	s5,s3,s10
ffffffffc0206764:	40fa8c33          	sub	s8,s5,a5
ffffffffc0206768:	8a3e                	mv	s4,a5
ffffffffc020676a:	4c81                	li	s9,0
ffffffffc020676c:	4b81                	li	s7,0
ffffffffc020676e:	000a3483          	ld	s1,0(s4)
ffffffffc0206772:	020b9513          	slli	a0,s7,0x20
ffffffffc0206776:	9101                	srli	a0,a0,0x20
ffffffffc0206778:	85a6                	mv	a1,s1
ffffffffc020677a:	954e                	add	a0,a0,s3
ffffffffc020677c:	39f040ef          	jal	ffffffffc020b31a <strcpy>
ffffffffc0206780:	014c07b3          	add	a5,s8,s4
ffffffffc0206784:	872a                	mv	a4,a0
ffffffffc0206786:	e398                	sd	a4,0(a5)
ffffffffc0206788:	8526                	mv	a0,s1
ffffffffc020678a:	6585                	lui	a1,0x1
ffffffffc020678c:	373040ef          	jal	ffffffffc020b2fe <strnlen>
ffffffffc0206790:	00150793          	addi	a5,a0,1
ffffffffc0206794:	2c85                	addiw	s9,s9,1
ffffffffc0206796:	0a21                	addi	s4,s4,8
ffffffffc0206798:	01778bbb          	addw	s7,a5,s7
ffffffffc020679c:	fc8ce9e3          	bltu	s9,s0,ffffffffc020676e <do_execve+0x3f0>
ffffffffc02067a0:	00093783          	ld	a5,0(s2)
ffffffffc02067a4:	fe8aae23          	sw	s0,-4(s5)
ffffffffc02067a8:	12000613          	li	a2,288
ffffffffc02067ac:	0a07ba03          	ld	s4,160(a5)
ffffffffc02067b0:	4581                	li	a1,0
ffffffffc02067b2:	1af1                	addi	s5,s5,-4
ffffffffc02067b4:	100a3403          	ld	s0,256(s4)
ffffffffc02067b8:	8552                	mv	a0,s4
ffffffffc02067ba:	3e1040ef          	jal	ffffffffc020b39a <memset>
ffffffffc02067be:	776a                	ld	a4,184(sp)
ffffffffc02067c0:	edf47793          	andi	a5,s0,-289
ffffffffc02067c4:	0d010993          	addi	s3,sp,208
ffffffffc02067c8:	020b1613          	slli	a2,s6,0x20
ffffffffc02067cc:	0207e793          	ori	a5,a5,32
ffffffffc02067d0:	ff8afa93          	andi	s5,s5,-8
ffffffffc02067d4:	01d65693          	srli	a3,a2,0x1d
ffffffffc02067d8:	99ea                	add	s3,s3,s10
ffffffffc02067da:	09a0                	addi	s0,sp,216
ffffffffc02067dc:	10fa3023          	sd	a5,256(s4)
ffffffffc02067e0:	015a3823          	sd	s5,16(s4)
ffffffffc02067e4:	40d989b3          	sub	s3,s3,a3
ffffffffc02067e8:	946a                	add	s0,s0,s10
ffffffffc02067ea:	10ea3423          	sd	a4,264(s4)
ffffffffc02067ee:	6008                	ld	a0,0(s0)
ffffffffc02067f0:	1461                	addi	s0,s0,-8
ffffffffc02067f2:	889fb0ef          	jal	ffffffffc020207a <kfree>
ffffffffc02067f6:	ff341ce3          	bne	s0,s3,ffffffffc02067ee <do_execve+0x470>
ffffffffc02067fa:	00093403          	ld	s0,0(s2)
ffffffffc02067fe:	4641                	li	a2,16
ffffffffc0206800:	4581                	li	a1,0
ffffffffc0206802:	0b440413          	addi	s0,s0,180
ffffffffc0206806:	8522                	mv	a0,s0
ffffffffc0206808:	393040ef          	jal	ffffffffc020b39a <memset>
ffffffffc020680c:	08ac                	addi	a1,sp,88
ffffffffc020680e:	8522                	mv	a0,s0
ffffffffc0206810:	463d                	li	a2,15
ffffffffc0206812:	3d9040ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc0206816:	24813083          	ld	ra,584(sp)
ffffffffc020681a:	24013403          	ld	s0,576(sp)
ffffffffc020681e:	23813483          	ld	s1,568(sp)
ffffffffc0206822:	23013903          	ld	s2,560(sp)
ffffffffc0206826:	22813983          	ld	s3,552(sp)
ffffffffc020682a:	22013a03          	ld	s4,544(sp)
ffffffffc020682e:	21813a83          	ld	s5,536(sp)
ffffffffc0206832:	20813b83          	ld	s7,520(sp)
ffffffffc0206836:	20013c03          	ld	s8,512(sp)
ffffffffc020683a:	7cfe                	ld	s9,504(sp)
ffffffffc020683c:	7d5e                	ld	s10,496(sp)
ffffffffc020683e:	21013b03          	ld	s6,528(sp)
ffffffffc0206842:	856e                	mv	a0,s11
ffffffffc0206844:	7dbe                	ld	s11,488(sp)
ffffffffc0206846:	25010113          	addi	sp,sp,592
ffffffffc020684a:	8082                	ret
ffffffffc020684c:	7d02                	ld	s10,32(sp)
ffffffffc020684e:	8daa                	mv	s11,a0
ffffffffc0206850:	bd11                	j	ffffffffc0206664 <do_execve+0x2e6>
ffffffffc0206852:	664a                	ld	a2,144(sp)
ffffffffc0206854:	67aa                	ld	a5,136(sp)
ffffffffc0206856:	26f66c63          	bltu	a2,a5,ffffffffc0206ace <do_execve+0x750>
ffffffffc020685a:	57b6                	lw	a5,108(sp)
ffffffffc020685c:	0027971b          	slliw	a4,a5,0x2
ffffffffc0206860:	0027f693          	andi	a3,a5,2
ffffffffc0206864:	8b11                	andi	a4,a4,4
ffffffffc0206866:	8b91                	andi	a5,a5,4
ffffffffc0206868:	caf9                	beqz	a3,ffffffffc020693e <do_execve+0x5c0>
ffffffffc020686a:	24079463          	bnez	a5,ffffffffc0206ab2 <do_execve+0x734>
ffffffffc020686e:	47dd                	li	a5,23
ffffffffc0206870:	00276693          	ori	a3,a4,2
ffffffffc0206874:	ec3e                	sd	a5,24(sp)
ffffffffc0206876:	c709                	beqz	a4,ffffffffc0206880 <do_execve+0x502>
ffffffffc0206878:	67e2                	ld	a5,24(sp)
ffffffffc020687a:	0087e793          	ori	a5,a5,8
ffffffffc020687e:	ec3e                	sd	a5,24(sp)
ffffffffc0206880:	75e6                	ld	a1,120(sp)
ffffffffc0206882:	4701                	li	a4,0
ffffffffc0206884:	854e                	mv	a0,s3
ffffffffc0206886:	b12fd0ef          	jal	ffffffffc0203b98 <mm_map>
ffffffffc020688a:	f169                	bnez	a0,ffffffffc020684c <do_execve+0x4ce>
ffffffffc020688c:	74e6                	ld	s1,120(sp)
ffffffffc020688e:	662a                	ld	a2,136(sp)
ffffffffc0206890:	77fd                	lui	a5,0xfffff
ffffffffc0206892:	00f4fa33          	and	s4,s1,a5
ffffffffc0206896:	00c48c33          	add	s8,s1,a2
ffffffffc020689a:	2384f763          	bgeu	s1,s8,ffffffffc0206ac8 <do_execve+0x74a>
ffffffffc020689e:	577d                	li	a4,-1
ffffffffc02068a0:	7bc6                	ld	s7,112(sp)
ffffffffc02068a2:	00c75793          	srli	a5,a4,0xc
ffffffffc02068a6:	f83e                	sd	a5,48(sp)
ffffffffc02068a8:	00090d97          	auipc	s11,0x90
ffffffffc02068ac:	010d8d93          	addi	s11,s11,16 # ffffffffc02968b8 <pages>
ffffffffc02068b0:	00009c97          	auipc	s9,0x9
ffffffffc02068b4:	d20c8c93          	addi	s9,s9,-736 # ffffffffc020f5d0 <nbase>
ffffffffc02068b8:	fc5a                	sd	s6,56(sp)
ffffffffc02068ba:	e84e                	sd	s3,16(sp)
ffffffffc02068bc:	67c2                	ld	a5,16(sp)
ffffffffc02068be:	6662                	ld	a2,24(sp)
ffffffffc02068c0:	85d2                	mv	a1,s4
ffffffffc02068c2:	6f88                	ld	a0,24(a5)
ffffffffc02068c4:	854fd0ef          	jal	ffffffffc0203918 <pgdir_alloc_page>
ffffffffc02068c8:	8d2a                	mv	s10,a0
ffffffffc02068ca:	c161                	beqz	a0,ffffffffc020698a <do_execve+0x60c>
ffffffffc02068cc:	6785                	lui	a5,0x1
ffffffffc02068ce:	00fa0b33          	add	s6,s4,a5
ffffffffc02068d2:	409c09b3          	sub	s3,s8,s1
ffffffffc02068d6:	016c6463          	bltu	s8,s6,ffffffffc02068de <do_execve+0x560>
ffffffffc02068da:	409b09b3          	sub	s3,s6,s1
ffffffffc02068de:	000db403          	ld	s0,0(s11)
ffffffffc02068e2:	000cb583          	ld	a1,0(s9)
ffffffffc02068e6:	77c2                	ld	a5,48(sp)
ffffffffc02068e8:	408d0433          	sub	s0,s10,s0
ffffffffc02068ec:	8419                	srai	s0,s0,0x6
ffffffffc02068ee:	00090617          	auipc	a2,0x90
ffffffffc02068f2:	fc263603          	ld	a2,-62(a2) # ffffffffc02968b0 <npage>
ffffffffc02068f6:	942e                	add	s0,s0,a1
ffffffffc02068f8:	00f475b3          	and	a1,s0,a5
ffffffffc02068fc:	0432                	slli	s0,s0,0xc
ffffffffc02068fe:	22c5f463          	bgeu	a1,a2,ffffffffc0206b26 <do_execve+0x7a8>
ffffffffc0206902:	6522                	ld	a0,8(sp)
ffffffffc0206904:	4601                	li	a2,0
ffffffffc0206906:	85de                	mv	a1,s7
ffffffffc0206908:	00090a97          	auipc	s5,0x90
ffffffffc020690c:	fa0aba83          	ld	s5,-96(s5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0206910:	d23fe0ef          	jal	ffffffffc0205632 <sysfile_seek>
ffffffffc0206914:	e131                	bnez	a0,ffffffffc0206958 <do_execve+0x5da>
ffffffffc0206916:	6522                	ld	a0,8(sp)
ffffffffc0206918:	9aa2                	add	s5,s5,s0
ffffffffc020691a:	414485b3          	sub	a1,s1,s4
ffffffffc020691e:	95d6                	add	a1,a1,s5
ffffffffc0206920:	864e                	mv	a2,s3
ffffffffc0206922:	a93fe0ef          	jal	ffffffffc02053b4 <sysfile_read>
ffffffffc0206926:	02a98363          	beq	s3,a0,ffffffffc020694c <do_execve+0x5ce>
ffffffffc020692a:	7d02                	ld	s10,32(sp)
ffffffffc020692c:	7b62                	ld	s6,56(sp)
ffffffffc020692e:	69c2                	ld	s3,16(sp)
ffffffffc0206930:	84aa                	mv	s1,a0
ffffffffc0206932:	d20547e3          	bltz	a0,ffffffffc0206660 <do_execve+0x2e2>
ffffffffc0206936:	54fd                	li	s1,-1
ffffffffc0206938:	b325                	j	ffffffffc0206660 <do_execve+0x2e2>
ffffffffc020693a:	5de1                	li	s11,-8
ffffffffc020693c:	b671                	j	ffffffffc02064c8 <do_execve+0x14a>
ffffffffc020693e:	16078663          	beqz	a5,ffffffffc0206aaa <do_execve+0x72c>
ffffffffc0206942:	47cd                	li	a5,19
ffffffffc0206944:	00176693          	ori	a3,a4,1
ffffffffc0206948:	ec3e                	sd	a5,24(sp)
ffffffffc020694a:	b735                	j	ffffffffc0206876 <do_execve+0x4f8>
ffffffffc020694c:	94ce                	add	s1,s1,s3
ffffffffc020694e:	9bce                	add	s7,s7,s3
ffffffffc0206950:	0584f263          	bgeu	s1,s8,ffffffffc0206994 <do_execve+0x616>
ffffffffc0206954:	8a5a                	mv	s4,s6
ffffffffc0206956:	b79d                	j	ffffffffc02068bc <do_execve+0x53e>
ffffffffc0206958:	7d02                	ld	s10,32(sp)
ffffffffc020695a:	7b62                	ld	s6,56(sp)
ffffffffc020695c:	69c2                	ld	s3,16(sp)
ffffffffc020695e:	8daa                	mv	s11,a0
ffffffffc0206960:	b311                	j	ffffffffc0206664 <do_execve+0x2e6>
ffffffffc0206962:	000a8863          	beqz	s5,ffffffffc0206972 <do_execve+0x5f4>
ffffffffc0206966:	038a8513          	addi	a0,s5,56
ffffffffc020696a:	a2ffd0ef          	jal	ffffffffc0204398 <up>
ffffffffc020696e:	040aa823          	sw	zero,80(s5)
ffffffffc0206972:	24013403          	ld	s0,576(sp)
ffffffffc0206976:	23813483          	ld	s1,568(sp)
ffffffffc020697a:	23013903          	ld	s2,560(sp)
ffffffffc020697e:	21813a83          	ld	s5,536(sp)
ffffffffc0206982:	20013c03          	ld	s8,512(sp)
ffffffffc0206986:	5df5                	li	s11,-3
ffffffffc0206988:	b901                	j	ffffffffc0206598 <do_execve+0x21a>
ffffffffc020698a:	7d02                	ld	s10,32(sp)
ffffffffc020698c:	7b62                	ld	s6,56(sp)
ffffffffc020698e:	69c2                	ld	s3,16(sp)
ffffffffc0206990:	5df1                	li	s11,-4
ffffffffc0206992:	b9c9                	j	ffffffffc0206664 <do_execve+0x2e6>
ffffffffc0206994:	8aea                	mv	s5,s10
ffffffffc0206996:	69c2                	ld	s3,16(sp)
ffffffffc0206998:	8d5a                	mv	s10,s6
ffffffffc020699a:	7866                	ld	a6,120(sp)
ffffffffc020699c:	7b62                	ld	s6,56(sp)
ffffffffc020699e:	66ca                	ld	a3,144(sp)
ffffffffc02069a0:	00d80433          	add	s0,a6,a3
ffffffffc02069a4:	07a4f863          	bgeu	s1,s10,ffffffffc0206a14 <do_execve+0x696>
ffffffffc02069a8:	cc9406e3          	beq	s0,s1,ffffffffc0206674 <do_execve+0x2f6>
ffffffffc02069ac:	40940a33          	sub	s4,s0,s1
ffffffffc02069b0:	01a46463          	bltu	s0,s10,ffffffffc02069b8 <do_execve+0x63a>
ffffffffc02069b4:	409d0a33          	sub	s4,s10,s1
ffffffffc02069b8:	00090697          	auipc	a3,0x90
ffffffffc02069bc:	f006b683          	ld	a3,-256(a3) # ffffffffc02968b8 <pages>
ffffffffc02069c0:	00009617          	auipc	a2,0x9
ffffffffc02069c4:	c1063603          	ld	a2,-1008(a2) # ffffffffc020f5d0 <nbase>
ffffffffc02069c8:	00090597          	auipc	a1,0x90
ffffffffc02069cc:	ee85b583          	ld	a1,-280(a1) # ffffffffc02968b0 <npage>
ffffffffc02069d0:	40da86b3          	sub	a3,s5,a3
ffffffffc02069d4:	8699                	srai	a3,a3,0x6
ffffffffc02069d6:	96b2                	add	a3,a3,a2
ffffffffc02069d8:	00c69613          	slli	a2,a3,0xc
ffffffffc02069dc:	8231                	srli	a2,a2,0xc
ffffffffc02069de:	06b2                	slli	a3,a3,0xc
ffffffffc02069e0:	0eb67b63          	bgeu	a2,a1,ffffffffc0206ad6 <do_execve+0x758>
ffffffffc02069e4:	00090617          	auipc	a2,0x90
ffffffffc02069e8:	ec463603          	ld	a2,-316(a2) # ffffffffc02968a8 <va_pa_offset>
ffffffffc02069ec:	6505                	lui	a0,0x1
ffffffffc02069ee:	9526                	add	a0,a0,s1
ffffffffc02069f0:	96b2                	add	a3,a3,a2
ffffffffc02069f2:	41a50533          	sub	a0,a0,s10
ffffffffc02069f6:	9536                	add	a0,a0,a3
ffffffffc02069f8:	8652                	mv	a2,s4
ffffffffc02069fa:	4581                	li	a1,0
ffffffffc02069fc:	19f040ef          	jal	ffffffffc020b39a <memset>
ffffffffc0206a00:	94d2                	add	s1,s1,s4
ffffffffc0206a02:	01a436b3          	sltu	a3,s0,s10
ffffffffc0206a06:	01a47463          	bgeu	s0,s10,ffffffffc0206a0e <do_execve+0x690>
ffffffffc0206a0a:	c69405e3          	beq	s0,s1,ffffffffc0206674 <do_execve+0x2f6>
ffffffffc0206a0e:	e2e5                	bnez	a3,ffffffffc0206aee <do_execve+0x770>
ffffffffc0206a10:	0da49f63          	bne	s1,s10,ffffffffc0206aee <do_execve+0x770>
ffffffffc0206a14:	c684f0e3          	bgeu	s1,s0,ffffffffc0206674 <do_execve+0x2f6>
ffffffffc0206a18:	57fd                	li	a5,-1
ffffffffc0206a1a:	83b1                	srli	a5,a5,0xc
ffffffffc0206a1c:	e83e                	sd	a5,16(sp)
ffffffffc0206a1e:	00090c97          	auipc	s9,0x90
ffffffffc0206a22:	e9ac8c93          	addi	s9,s9,-358 # ffffffffc02968b8 <pages>
ffffffffc0206a26:	00009c17          	auipc	s8,0x9
ffffffffc0206a2a:	baac0c13          	addi	s8,s8,-1110 # ffffffffc020f5d0 <nbase>
ffffffffc0206a2e:	00090b97          	auipc	s7,0x90
ffffffffc0206a32:	e82b8b93          	addi	s7,s7,-382 # ffffffffc02968b0 <npage>
ffffffffc0206a36:	00090d97          	auipc	s11,0x90
ffffffffc0206a3a:	e72d8d93          	addi	s11,s11,-398 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0206a3e:	f85a                	sd	s6,48(sp)
ffffffffc0206a40:	a889                	j	ffffffffc0206a92 <do_execve+0x714>
ffffffffc0206a42:	6785                	lui	a5,0x1
ffffffffc0206a44:	00fd0a33          	add	s4,s10,a5
ffffffffc0206a48:	40940b33          	sub	s6,s0,s1
ffffffffc0206a4c:	01446463          	bltu	s0,s4,ffffffffc0206a54 <do_execve+0x6d6>
ffffffffc0206a50:	409a0b33          	sub	s6,s4,s1
ffffffffc0206a54:	000cb783          	ld	a5,0(s9)
ffffffffc0206a58:	000c3583          	ld	a1,0(s8)
ffffffffc0206a5c:	6742                	ld	a4,16(sp)
ffffffffc0206a5e:	40fa87b3          	sub	a5,s5,a5
ffffffffc0206a62:	8799                	srai	a5,a5,0x6
ffffffffc0206a64:	000bb683          	ld	a3,0(s7)
ffffffffc0206a68:	97ae                	add	a5,a5,a1
ffffffffc0206a6a:	00e7f5b3          	and	a1,a5,a4
ffffffffc0206a6e:	07b2                	slli	a5,a5,0xc
ffffffffc0206a70:	06d5f263          	bgeu	a1,a3,ffffffffc0206ad4 <do_execve+0x756>
ffffffffc0206a74:	000db683          	ld	a3,0(s11)
ffffffffc0206a78:	41a48d33          	sub	s10,s1,s10
ffffffffc0206a7c:	865a                	mv	a2,s6
ffffffffc0206a7e:	97b6                	add	a5,a5,a3
ffffffffc0206a80:	01a78533          	add	a0,a5,s10
ffffffffc0206a84:	4581                	li	a1,0
ffffffffc0206a86:	94da                	add	s1,s1,s6
ffffffffc0206a88:	113040ef          	jal	ffffffffc020b39a <memset>
ffffffffc0206a8c:	0284f863          	bgeu	s1,s0,ffffffffc0206abc <do_execve+0x73e>
ffffffffc0206a90:	8d52                	mv	s10,s4
ffffffffc0206a92:	0189b503          	ld	a0,24(s3)
ffffffffc0206a96:	6662                	ld	a2,24(sp)
ffffffffc0206a98:	85ea                	mv	a1,s10
ffffffffc0206a9a:	e7ffc0ef          	jal	ffffffffc0203918 <pgdir_alloc_page>
ffffffffc0206a9e:	8aaa                	mv	s5,a0
ffffffffc0206aa0:	f14d                	bnez	a0,ffffffffc0206a42 <do_execve+0x6c4>
ffffffffc0206aa2:	7d02                	ld	s10,32(sp)
ffffffffc0206aa4:	7b42                	ld	s6,48(sp)
ffffffffc0206aa6:	5df1                	li	s11,-4
ffffffffc0206aa8:	be75                	j	ffffffffc0206664 <do_execve+0x2e6>
ffffffffc0206aaa:	47c5                	li	a5,17
ffffffffc0206aac:	86ba                	mv	a3,a4
ffffffffc0206aae:	ec3e                	sd	a5,24(sp)
ffffffffc0206ab0:	b3d9                	j	ffffffffc0206876 <do_execve+0x4f8>
ffffffffc0206ab2:	47dd                	li	a5,23
ffffffffc0206ab4:	00376693          	ori	a3,a4,3
ffffffffc0206ab8:	ec3e                	sd	a5,24(sp)
ffffffffc0206aba:	bb75                	j	ffffffffc0206876 <do_execve+0x4f8>
ffffffffc0206abc:	7b42                	ld	s6,48(sp)
ffffffffc0206abe:	be5d                	j	ffffffffc0206674 <do_execve+0x2f6>
ffffffffc0206ac0:	5df5                	li	s11,-3
ffffffffc0206ac2:	aa0a98e3          	bnez	s5,ffffffffc0206572 <do_execve+0x1f4>
ffffffffc0206ac6:	bc65                	j	ffffffffc020657e <do_execve+0x200>
ffffffffc0206ac8:	8d52                	mv	s10,s4
ffffffffc0206aca:	8826                	mv	a6,s1
ffffffffc0206acc:	bdc9                	j	ffffffffc020699e <do_execve+0x620>
ffffffffc0206ace:	7d02                	ld	s10,32(sp)
ffffffffc0206ad0:	5de1                	li	s11,-8
ffffffffc0206ad2:	be49                	j	ffffffffc0206664 <do_execve+0x2e6>
ffffffffc0206ad4:	86be                	mv	a3,a5
ffffffffc0206ad6:	00005617          	auipc	a2,0x5
ffffffffc0206ada:	7e260613          	addi	a2,a2,2018 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc0206ade:	07100593          	li	a1,113
ffffffffc0206ae2:	00005517          	auipc	a0,0x5
ffffffffc0206ae6:	7fe50513          	addi	a0,a0,2046 # ffffffffc020c2e0 <etext+0xede>
ffffffffc0206aea:	961f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206aee:	00007697          	auipc	a3,0x7
ffffffffc0206af2:	91a68693          	addi	a3,a3,-1766 # ffffffffc020d408 <etext+0x2006>
ffffffffc0206af6:	00005617          	auipc	a2,0x5
ffffffffc0206afa:	d4a60613          	addi	a2,a2,-694 # ffffffffc020b840 <etext+0x43e>
ffffffffc0206afe:	30f00593          	li	a1,783
ffffffffc0206b02:	00006517          	auipc	a0,0x6
ffffffffc0206b06:	6ee50513          	addi	a0,a0,1774 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0206b0a:	941f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206b0e:	00006617          	auipc	a2,0x6
ffffffffc0206b12:	85260613          	addi	a2,a2,-1966 # ffffffffc020c360 <etext+0xf5e>
ffffffffc0206b16:	32f00593          	li	a1,815
ffffffffc0206b1a:	00006517          	auipc	a0,0x6
ffffffffc0206b1e:	6d650513          	addi	a0,a0,1750 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0206b22:	929f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206b26:	86a2                	mv	a3,s0
ffffffffc0206b28:	00005617          	auipc	a2,0x5
ffffffffc0206b2c:	79060613          	addi	a2,a2,1936 # ffffffffc020c2b8 <etext+0xeb6>
ffffffffc0206b30:	07100593          	li	a1,113
ffffffffc0206b34:	00005517          	auipc	a0,0x5
ffffffffc0206b38:	7ac50513          	addi	a0,a0,1964 # ffffffffc020c2e0 <etext+0xede>
ffffffffc0206b3c:	90ff90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206b40:	8daa                	mv	s11,a0
ffffffffc0206b42:	ba51                	j	ffffffffc02064d6 <do_execve+0x158>
ffffffffc0206b44:	00007697          	auipc	a3,0x7
ffffffffc0206b48:	9dc68693          	addi	a3,a3,-1572 # ffffffffc020d520 <etext+0x211e>
ffffffffc0206b4c:	00005617          	auipc	a2,0x5
ffffffffc0206b50:	cf460613          	addi	a2,a2,-780 # ffffffffc020b840 <etext+0x43e>
ffffffffc0206b54:	32a00593          	li	a1,810
ffffffffc0206b58:	00006517          	auipc	a0,0x6
ffffffffc0206b5c:	69850513          	addi	a0,a0,1688 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0206b60:	8ebf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206b64:	00007697          	auipc	a3,0x7
ffffffffc0206b68:	97468693          	addi	a3,a3,-1676 # ffffffffc020d4d8 <etext+0x20d6>
ffffffffc0206b6c:	00005617          	auipc	a2,0x5
ffffffffc0206b70:	cd460613          	addi	a2,a2,-812 # ffffffffc020b840 <etext+0x43e>
ffffffffc0206b74:	32900593          	li	a1,809
ffffffffc0206b78:	00006517          	auipc	a0,0x6
ffffffffc0206b7c:	67850513          	addi	a0,a0,1656 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0206b80:	8cbf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206b84:	00007697          	auipc	a3,0x7
ffffffffc0206b88:	90c68693          	addi	a3,a3,-1780 # ffffffffc020d490 <etext+0x208e>
ffffffffc0206b8c:	00005617          	auipc	a2,0x5
ffffffffc0206b90:	cb460613          	addi	a2,a2,-844 # ffffffffc020b840 <etext+0x43e>
ffffffffc0206b94:	32800593          	li	a1,808
ffffffffc0206b98:	00006517          	auipc	a0,0x6
ffffffffc0206b9c:	65850513          	addi	a0,a0,1624 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0206ba0:	8abf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206ba4:	00007697          	auipc	a3,0x7
ffffffffc0206ba8:	8a468693          	addi	a3,a3,-1884 # ffffffffc020d448 <etext+0x2046>
ffffffffc0206bac:	00005617          	auipc	a2,0x5
ffffffffc0206bb0:	c9460613          	addi	a2,a2,-876 # ffffffffc020b840 <etext+0x43e>
ffffffffc0206bb4:	32700593          	li	a1,807
ffffffffc0206bb8:	00006517          	auipc	a0,0x6
ffffffffc0206bbc:	63850513          	addi	a0,a0,1592 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0206bc0:	88bf90ef          	jal	ffffffffc020044a <__panic>

ffffffffc0206bc4 <user_main>:
ffffffffc0206bc4:	7179                	addi	sp,sp,-48
ffffffffc0206bc6:	e84a                	sd	s2,16(sp)
ffffffffc0206bc8:	00090917          	auipc	s2,0x90
ffffffffc0206bcc:	d0090913          	addi	s2,s2,-768 # ffffffffc02968c8 <current>
ffffffffc0206bd0:	00093783          	ld	a5,0(s2)
ffffffffc0206bd4:	00007617          	auipc	a2,0x7
ffffffffc0206bd8:	99460613          	addi	a2,a2,-1644 # ffffffffc020d568 <etext+0x2166>
ffffffffc0206bdc:	00007517          	auipc	a0,0x7
ffffffffc0206be0:	99450513          	addi	a0,a0,-1644 # ffffffffc020d570 <etext+0x216e>
ffffffffc0206be4:	43cc                	lw	a1,4(a5)
ffffffffc0206be6:	f406                	sd	ra,40(sp)
ffffffffc0206be8:	f022                	sd	s0,32(sp)
ffffffffc0206bea:	ec26                	sd	s1,24(sp)
ffffffffc0206bec:	e402                	sd	zero,8(sp)
ffffffffc0206bee:	e032                	sd	a2,0(sp)
ffffffffc0206bf0:	db6f90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0206bf4:	6782                	ld	a5,0(sp)
ffffffffc0206bf6:	cfb9                	beqz	a5,ffffffffc0206c54 <user_main+0x90>
ffffffffc0206bf8:	003c                	addi	a5,sp,8
ffffffffc0206bfa:	4401                	li	s0,0
ffffffffc0206bfc:	6398                	ld	a4,0(a5)
ffffffffc0206bfe:	07a1                	addi	a5,a5,8 # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc0206c00:	0405                	addi	s0,s0,1
ffffffffc0206c02:	ff6d                	bnez	a4,ffffffffc0206bfc <user_main+0x38>
ffffffffc0206c04:	00093703          	ld	a4,0(s2)
ffffffffc0206c08:	6789                	lui	a5,0x2
ffffffffc0206c0a:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0206c0e:	6b04                	ld	s1,16(a4)
ffffffffc0206c10:	734c                	ld	a1,160(a4)
ffffffffc0206c12:	12000613          	li	a2,288
ffffffffc0206c16:	94be                	add	s1,s1,a5
ffffffffc0206c18:	8526                	mv	a0,s1
ffffffffc0206c1a:	7d0040ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc0206c1e:	00093783          	ld	a5,0(s2)
ffffffffc0206c22:	0004059b          	sext.w	a1,s0
ffffffffc0206c26:	860a                	mv	a2,sp
ffffffffc0206c28:	f3c4                	sd	s1,160(a5)
ffffffffc0206c2a:	00007517          	auipc	a0,0x7
ffffffffc0206c2e:	93e50513          	addi	a0,a0,-1730 # ffffffffc020d568 <etext+0x2166>
ffffffffc0206c32:	f4cff0ef          	jal	ffffffffc020637e <do_execve>
ffffffffc0206c36:	8126                	mv	sp,s1
ffffffffc0206c38:	dd0fa06f          	j	ffffffffc0201208 <__trapret>
ffffffffc0206c3c:	00007617          	auipc	a2,0x7
ffffffffc0206c40:	95c60613          	addi	a2,a2,-1700 # ffffffffc020d598 <etext+0x2196>
ffffffffc0206c44:	46600593          	li	a1,1126
ffffffffc0206c48:	00006517          	auipc	a0,0x6
ffffffffc0206c4c:	5a850513          	addi	a0,a0,1448 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0206c50:	ffaf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206c54:	4401                	li	s0,0
ffffffffc0206c56:	b77d                	j	ffffffffc0206c04 <user_main+0x40>

ffffffffc0206c58 <do_yield>:
ffffffffc0206c58:	00090797          	auipc	a5,0x90
ffffffffc0206c5c:	c707b783          	ld	a5,-912(a5) # ffffffffc02968c8 <current>
ffffffffc0206c60:	4705                	li	a4,1
ffffffffc0206c62:	4501                	li	a0,0
ffffffffc0206c64:	ef98                	sd	a4,24(a5)
ffffffffc0206c66:	8082                	ret

ffffffffc0206c68 <do_wait>:
ffffffffc0206c68:	c59d                	beqz	a1,ffffffffc0206c96 <do_wait+0x2e>
ffffffffc0206c6a:	1101                	addi	sp,sp,-32
ffffffffc0206c6c:	e02a                	sd	a0,0(sp)
ffffffffc0206c6e:	00090517          	auipc	a0,0x90
ffffffffc0206c72:	c5a53503          	ld	a0,-934(a0) # ffffffffc02968c8 <current>
ffffffffc0206c76:	4685                	li	a3,1
ffffffffc0206c78:	4611                	li	a2,4
ffffffffc0206c7a:	7508                	ld	a0,40(a0)
ffffffffc0206c7c:	ec06                	sd	ra,24(sp)
ffffffffc0206c7e:	e42e                	sd	a1,8(sp)
ffffffffc0206c80:	c1afd0ef          	jal	ffffffffc020409a <user_mem_check>
ffffffffc0206c84:	6702                	ld	a4,0(sp)
ffffffffc0206c86:	67a2                	ld	a5,8(sp)
ffffffffc0206c88:	c909                	beqz	a0,ffffffffc0206c9a <do_wait+0x32>
ffffffffc0206c8a:	60e2                	ld	ra,24(sp)
ffffffffc0206c8c:	85be                	mv	a1,a5
ffffffffc0206c8e:	853a                	mv	a0,a4
ffffffffc0206c90:	6105                	addi	sp,sp,32
ffffffffc0206c92:	bbaff06f          	j	ffffffffc020604c <do_wait.part.0>
ffffffffc0206c96:	bb6ff06f          	j	ffffffffc020604c <do_wait.part.0>
ffffffffc0206c9a:	60e2                	ld	ra,24(sp)
ffffffffc0206c9c:	5575                	li	a0,-3
ffffffffc0206c9e:	6105                	addi	sp,sp,32
ffffffffc0206ca0:	8082                	ret

ffffffffc0206ca2 <do_kill>:
ffffffffc0206ca2:	6789                	lui	a5,0x2
ffffffffc0206ca4:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206ca8:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_bin_swap_img_size-0x5d02>
ffffffffc0206caa:	06e7e463          	bltu	a5,a4,ffffffffc0206d12 <do_kill+0x70>
ffffffffc0206cae:	1101                	addi	sp,sp,-32
ffffffffc0206cb0:	45a9                	li	a1,10
ffffffffc0206cb2:	ec06                	sd	ra,24(sp)
ffffffffc0206cb4:	e42a                	sd	a0,8(sp)
ffffffffc0206cb6:	1a8040ef          	jal	ffffffffc020ae5e <hash32>
ffffffffc0206cba:	02051793          	slli	a5,a0,0x20
ffffffffc0206cbe:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0206cc2:	0008b797          	auipc	a5,0x8b
ffffffffc0206cc6:	afe78793          	addi	a5,a5,-1282 # ffffffffc02917c0 <hash_list>
ffffffffc0206cca:	96be                	add	a3,a3,a5
ffffffffc0206ccc:	6622                	ld	a2,8(sp)
ffffffffc0206cce:	8536                	mv	a0,a3
ffffffffc0206cd0:	a029                	j	ffffffffc0206cda <do_kill+0x38>
ffffffffc0206cd2:	f2c52703          	lw	a4,-212(a0)
ffffffffc0206cd6:	00c70963          	beq	a4,a2,ffffffffc0206ce8 <do_kill+0x46>
ffffffffc0206cda:	6508                	ld	a0,8(a0)
ffffffffc0206cdc:	fea69be3          	bne	a3,a0,ffffffffc0206cd2 <do_kill+0x30>
ffffffffc0206ce0:	60e2                	ld	ra,24(sp)
ffffffffc0206ce2:	5575                	li	a0,-3
ffffffffc0206ce4:	6105                	addi	sp,sp,32
ffffffffc0206ce6:	8082                	ret
ffffffffc0206ce8:	fd852703          	lw	a4,-40(a0)
ffffffffc0206cec:	00177693          	andi	a3,a4,1
ffffffffc0206cf0:	e29d                	bnez	a3,ffffffffc0206d16 <do_kill+0x74>
ffffffffc0206cf2:	4954                	lw	a3,20(a0)
ffffffffc0206cf4:	00176713          	ori	a4,a4,1
ffffffffc0206cf8:	fce52c23          	sw	a4,-40(a0)
ffffffffc0206cfc:	0006c663          	bltz	a3,ffffffffc0206d08 <do_kill+0x66>
ffffffffc0206d00:	4501                	li	a0,0
ffffffffc0206d02:	60e2                	ld	ra,24(sp)
ffffffffc0206d04:	6105                	addi	sp,sp,32
ffffffffc0206d06:	8082                	ret
ffffffffc0206d08:	f2850513          	addi	a0,a0,-216
ffffffffc0206d0c:	45a000ef          	jal	ffffffffc0207166 <wakeup_proc>
ffffffffc0206d10:	bfc5                	j	ffffffffc0206d00 <do_kill+0x5e>
ffffffffc0206d12:	5575                	li	a0,-3
ffffffffc0206d14:	8082                	ret
ffffffffc0206d16:	555d                	li	a0,-9
ffffffffc0206d18:	b7ed                	j	ffffffffc0206d02 <do_kill+0x60>

ffffffffc0206d1a <proc_init>:
ffffffffc0206d1a:	1101                	addi	sp,sp,-32
ffffffffc0206d1c:	e426                	sd	s1,8(sp)
ffffffffc0206d1e:	0008f797          	auipc	a5,0x8f
ffffffffc0206d22:	aa278793          	addi	a5,a5,-1374 # ffffffffc02957c0 <proc_list>
ffffffffc0206d26:	ec06                	sd	ra,24(sp)
ffffffffc0206d28:	e822                	sd	s0,16(sp)
ffffffffc0206d2a:	e04a                	sd	s2,0(sp)
ffffffffc0206d2c:	0008b497          	auipc	s1,0x8b
ffffffffc0206d30:	a9448493          	addi	s1,s1,-1388 # ffffffffc02917c0 <hash_list>
ffffffffc0206d34:	e79c                	sd	a5,8(a5)
ffffffffc0206d36:	e39c                	sd	a5,0(a5)
ffffffffc0206d38:	0008f717          	auipc	a4,0x8f
ffffffffc0206d3c:	a8870713          	addi	a4,a4,-1400 # ffffffffc02957c0 <proc_list>
ffffffffc0206d40:	87a6                	mv	a5,s1
ffffffffc0206d42:	e79c                	sd	a5,8(a5)
ffffffffc0206d44:	e39c                	sd	a5,0(a5)
ffffffffc0206d46:	07c1                	addi	a5,a5,16
ffffffffc0206d48:	fee79de3          	bne	a5,a4,ffffffffc0206d42 <proc_init+0x28>
ffffffffc0206d4c:	b1dfe0ef          	jal	ffffffffc0205868 <alloc_proc>
ffffffffc0206d50:	00090917          	auipc	s2,0x90
ffffffffc0206d54:	b8890913          	addi	s2,s2,-1144 # ffffffffc02968d8 <idleproc>
ffffffffc0206d58:	00a93023          	sd	a0,0(s2)
ffffffffc0206d5c:	842a                	mv	s0,a0
ffffffffc0206d5e:	12050c63          	beqz	a0,ffffffffc0206e96 <proc_init+0x17c>
ffffffffc0206d62:	4689                	li	a3,2
ffffffffc0206d64:	0000a717          	auipc	a4,0xa
ffffffffc0206d68:	29c70713          	addi	a4,a4,668 # ffffffffc0211000 <bootstack>
ffffffffc0206d6c:	4785                	li	a5,1
ffffffffc0206d6e:	e114                	sd	a3,0(a0)
ffffffffc0206d70:	e918                	sd	a4,16(a0)
ffffffffc0206d72:	ed1c                	sd	a5,24(a0)
ffffffffc0206d74:	aaafe0ef          	jal	ffffffffc020501e <files_create>
ffffffffc0206d78:	14a43423          	sd	a0,328(s0)
ffffffffc0206d7c:	10050163          	beqz	a0,ffffffffc0206e7e <proc_init+0x164>
ffffffffc0206d80:	00093403          	ld	s0,0(s2)
ffffffffc0206d84:	4641                	li	a2,16
ffffffffc0206d86:	4581                	li	a1,0
ffffffffc0206d88:	14843703          	ld	a4,328(s0)
ffffffffc0206d8c:	0b440413          	addi	s0,s0,180
ffffffffc0206d90:	8522                	mv	a0,s0
ffffffffc0206d92:	4b1c                	lw	a5,16(a4)
ffffffffc0206d94:	2785                	addiw	a5,a5,1
ffffffffc0206d96:	cb1c                	sw	a5,16(a4)
ffffffffc0206d98:	602040ef          	jal	ffffffffc020b39a <memset>
ffffffffc0206d9c:	8522                	mv	a0,s0
ffffffffc0206d9e:	463d                	li	a2,15
ffffffffc0206da0:	00007597          	auipc	a1,0x7
ffffffffc0206da4:	85858593          	addi	a1,a1,-1960 # ffffffffc020d5f8 <etext+0x21f6>
ffffffffc0206da8:	642040ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc0206dac:	00090797          	auipc	a5,0x90
ffffffffc0206db0:	b147a783          	lw	a5,-1260(a5) # ffffffffc02968c0 <nr_process>
ffffffffc0206db4:	00093703          	ld	a4,0(s2)
ffffffffc0206db8:	4601                	li	a2,0
ffffffffc0206dba:	2785                	addiw	a5,a5,1
ffffffffc0206dbc:	4581                	li	a1,0
ffffffffc0206dbe:	fffff517          	auipc	a0,0xfffff
ffffffffc0206dc2:	47050513          	addi	a0,a0,1136 # ffffffffc020622e <init_main>
ffffffffc0206dc6:	00090697          	auipc	a3,0x90
ffffffffc0206dca:	b0e6b123          	sd	a4,-1278(a3) # ffffffffc02968c8 <current>
ffffffffc0206dce:	00090717          	auipc	a4,0x90
ffffffffc0206dd2:	aef72923          	sw	a5,-1294(a4) # ffffffffc02968c0 <nr_process>
ffffffffc0206dd6:	8c6ff0ef          	jal	ffffffffc0205e9c <kernel_thread>
ffffffffc0206dda:	842a                	mv	s0,a0
ffffffffc0206ddc:	08a05563          	blez	a0,ffffffffc0206e66 <proc_init+0x14c>
ffffffffc0206de0:	6789                	lui	a5,0x2
ffffffffc0206de2:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_bin_swap_img_size-0x5d02>
ffffffffc0206de4:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206de8:	02e7e463          	bltu	a5,a4,ffffffffc0206e10 <proc_init+0xf6>
ffffffffc0206dec:	45a9                	li	a1,10
ffffffffc0206dee:	070040ef          	jal	ffffffffc020ae5e <hash32>
ffffffffc0206df2:	02051713          	slli	a4,a0,0x20
ffffffffc0206df6:	01c75793          	srli	a5,a4,0x1c
ffffffffc0206dfa:	00f486b3          	add	a3,s1,a5
ffffffffc0206dfe:	87b6                	mv	a5,a3
ffffffffc0206e00:	a029                	j	ffffffffc0206e0a <proc_init+0xf0>
ffffffffc0206e02:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0206e06:	04870d63          	beq	a4,s0,ffffffffc0206e60 <proc_init+0x146>
ffffffffc0206e0a:	679c                	ld	a5,8(a5)
ffffffffc0206e0c:	fef69be3          	bne	a3,a5,ffffffffc0206e02 <proc_init+0xe8>
ffffffffc0206e10:	4781                	li	a5,0
ffffffffc0206e12:	0b478413          	addi	s0,a5,180
ffffffffc0206e16:	4641                	li	a2,16
ffffffffc0206e18:	4581                	li	a1,0
ffffffffc0206e1a:	8522                	mv	a0,s0
ffffffffc0206e1c:	00090717          	auipc	a4,0x90
ffffffffc0206e20:	aaf73a23          	sd	a5,-1356(a4) # ffffffffc02968d0 <initproc>
ffffffffc0206e24:	576040ef          	jal	ffffffffc020b39a <memset>
ffffffffc0206e28:	8522                	mv	a0,s0
ffffffffc0206e2a:	463d                	li	a2,15
ffffffffc0206e2c:	00006597          	auipc	a1,0x6
ffffffffc0206e30:	7f458593          	addi	a1,a1,2036 # ffffffffc020d620 <etext+0x221e>
ffffffffc0206e34:	5b6040ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc0206e38:	00093783          	ld	a5,0(s2)
ffffffffc0206e3c:	cbc9                	beqz	a5,ffffffffc0206ece <proc_init+0x1b4>
ffffffffc0206e3e:	43dc                	lw	a5,4(a5)
ffffffffc0206e40:	e7d9                	bnez	a5,ffffffffc0206ece <proc_init+0x1b4>
ffffffffc0206e42:	00090797          	auipc	a5,0x90
ffffffffc0206e46:	a8e7b783          	ld	a5,-1394(a5) # ffffffffc02968d0 <initproc>
ffffffffc0206e4a:	c3b5                	beqz	a5,ffffffffc0206eae <proc_init+0x194>
ffffffffc0206e4c:	43d8                	lw	a4,4(a5)
ffffffffc0206e4e:	4785                	li	a5,1
ffffffffc0206e50:	04f71f63          	bne	a4,a5,ffffffffc0206eae <proc_init+0x194>
ffffffffc0206e54:	60e2                	ld	ra,24(sp)
ffffffffc0206e56:	6442                	ld	s0,16(sp)
ffffffffc0206e58:	64a2                	ld	s1,8(sp)
ffffffffc0206e5a:	6902                	ld	s2,0(sp)
ffffffffc0206e5c:	6105                	addi	sp,sp,32
ffffffffc0206e5e:	8082                	ret
ffffffffc0206e60:	f2878793          	addi	a5,a5,-216
ffffffffc0206e64:	b77d                	j	ffffffffc0206e12 <proc_init+0xf8>
ffffffffc0206e66:	00006617          	auipc	a2,0x6
ffffffffc0206e6a:	79a60613          	addi	a2,a2,1946 # ffffffffc020d600 <etext+0x21fe>
ffffffffc0206e6e:	4b200593          	li	a1,1202
ffffffffc0206e72:	00006517          	auipc	a0,0x6
ffffffffc0206e76:	37e50513          	addi	a0,a0,894 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0206e7a:	dd0f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206e7e:	00006617          	auipc	a2,0x6
ffffffffc0206e82:	75260613          	addi	a2,a2,1874 # ffffffffc020d5d0 <etext+0x21ce>
ffffffffc0206e86:	4a600593          	li	a1,1190
ffffffffc0206e8a:	00006517          	auipc	a0,0x6
ffffffffc0206e8e:	36650513          	addi	a0,a0,870 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0206e92:	db8f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206e96:	00006617          	auipc	a2,0x6
ffffffffc0206e9a:	72260613          	addi	a2,a2,1826 # ffffffffc020d5b8 <etext+0x21b6>
ffffffffc0206e9e:	49c00593          	li	a1,1180
ffffffffc0206ea2:	00006517          	auipc	a0,0x6
ffffffffc0206ea6:	34e50513          	addi	a0,a0,846 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0206eaa:	da0f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206eae:	00006697          	auipc	a3,0x6
ffffffffc0206eb2:	7a268693          	addi	a3,a3,1954 # ffffffffc020d650 <etext+0x224e>
ffffffffc0206eb6:	00005617          	auipc	a2,0x5
ffffffffc0206eba:	98a60613          	addi	a2,a2,-1654 # ffffffffc020b840 <etext+0x43e>
ffffffffc0206ebe:	4b900593          	li	a1,1209
ffffffffc0206ec2:	00006517          	auipc	a0,0x6
ffffffffc0206ec6:	32e50513          	addi	a0,a0,814 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0206eca:	d80f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206ece:	00006697          	auipc	a3,0x6
ffffffffc0206ed2:	75a68693          	addi	a3,a3,1882 # ffffffffc020d628 <etext+0x2226>
ffffffffc0206ed6:	00005617          	auipc	a2,0x5
ffffffffc0206eda:	96a60613          	addi	a2,a2,-1686 # ffffffffc020b840 <etext+0x43e>
ffffffffc0206ede:	4b800593          	li	a1,1208
ffffffffc0206ee2:	00006517          	auipc	a0,0x6
ffffffffc0206ee6:	30e50513          	addi	a0,a0,782 # ffffffffc020d1f0 <etext+0x1dee>
ffffffffc0206eea:	d60f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc0206eee <cpu_idle>:
ffffffffc0206eee:	1141                	addi	sp,sp,-16
ffffffffc0206ef0:	e022                	sd	s0,0(sp)
ffffffffc0206ef2:	e406                	sd	ra,8(sp)
ffffffffc0206ef4:	00090417          	auipc	s0,0x90
ffffffffc0206ef8:	9d440413          	addi	s0,s0,-1580 # ffffffffc02968c8 <current>
ffffffffc0206efc:	6018                	ld	a4,0(s0)
ffffffffc0206efe:	6f1c                	ld	a5,24(a4)
ffffffffc0206f00:	dffd                	beqz	a5,ffffffffc0206efe <cpu_idle+0x10>
ffffffffc0206f02:	35c000ef          	jal	ffffffffc020725e <schedule>
ffffffffc0206f06:	bfdd                	j	ffffffffc0206efc <cpu_idle+0xe>

ffffffffc0206f08 <lab6_set_priority>:
ffffffffc0206f08:	1101                	addi	sp,sp,-32
ffffffffc0206f0a:	85aa                	mv	a1,a0
ffffffffc0206f0c:	e42a                	sd	a0,8(sp)
ffffffffc0206f0e:	00006517          	auipc	a0,0x6
ffffffffc0206f12:	76a50513          	addi	a0,a0,1898 # ffffffffc020d678 <etext+0x2276>
ffffffffc0206f16:	ec06                	sd	ra,24(sp)
ffffffffc0206f18:	a8ef90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0206f1c:	65a2                	ld	a1,8(sp)
ffffffffc0206f1e:	00090717          	auipc	a4,0x90
ffffffffc0206f22:	9aa73703          	ld	a4,-1622(a4) # ffffffffc02968c8 <current>
ffffffffc0206f26:	4785                	li	a5,1
ffffffffc0206f28:	c191                	beqz	a1,ffffffffc0206f2c <lab6_set_priority+0x24>
ffffffffc0206f2a:	87ae                	mv	a5,a1
ffffffffc0206f2c:	60e2                	ld	ra,24(sp)
ffffffffc0206f2e:	14f72223          	sw	a5,324(a4)
ffffffffc0206f32:	6105                	addi	sp,sp,32
ffffffffc0206f34:	8082                	ret

ffffffffc0206f36 <do_sleep>:
ffffffffc0206f36:	c531                	beqz	a0,ffffffffc0206f82 <do_sleep+0x4c>
ffffffffc0206f38:	7139                	addi	sp,sp,-64
ffffffffc0206f3a:	fc06                	sd	ra,56(sp)
ffffffffc0206f3c:	f822                	sd	s0,48(sp)
ffffffffc0206f3e:	100027f3          	csrr	a5,sstatus
ffffffffc0206f42:	8b89                	andi	a5,a5,2
ffffffffc0206f44:	e3a9                	bnez	a5,ffffffffc0206f86 <do_sleep+0x50>
ffffffffc0206f46:	00090797          	auipc	a5,0x90
ffffffffc0206f4a:	9827b783          	ld	a5,-1662(a5) # ffffffffc02968c8 <current>
ffffffffc0206f4e:	1014                	addi	a3,sp,32
ffffffffc0206f50:	80000737          	lui	a4,0x80000
ffffffffc0206f54:	c82a                	sw	a0,16(sp)
ffffffffc0206f56:	f436                	sd	a3,40(sp)
ffffffffc0206f58:	f036                	sd	a3,32(sp)
ffffffffc0206f5a:	ec3e                	sd	a5,24(sp)
ffffffffc0206f5c:	4685                	li	a3,1
ffffffffc0206f5e:	0709                	addi	a4,a4,2 # ffffffff80000002 <_binary_bin_sfs_img_size+0xffffffff7ff8ad02>
ffffffffc0206f60:	0808                	addi	a0,sp,16
ffffffffc0206f62:	c394                	sw	a3,0(a5)
ffffffffc0206f64:	0ee7a623          	sw	a4,236(a5)
ffffffffc0206f68:	842a                	mv	s0,a0
ffffffffc0206f6a:	3aa000ef          	jal	ffffffffc0207314 <add_timer>
ffffffffc0206f6e:	2f0000ef          	jal	ffffffffc020725e <schedule>
ffffffffc0206f72:	8522                	mv	a0,s0
ffffffffc0206f74:	466000ef          	jal	ffffffffc02073da <del_timer>
ffffffffc0206f78:	70e2                	ld	ra,56(sp)
ffffffffc0206f7a:	7442                	ld	s0,48(sp)
ffffffffc0206f7c:	4501                	li	a0,0
ffffffffc0206f7e:	6121                	addi	sp,sp,64
ffffffffc0206f80:	8082                	ret
ffffffffc0206f82:	4501                	li	a0,0
ffffffffc0206f84:	8082                	ret
ffffffffc0206f86:	e42a                	sd	a0,8(sp)
ffffffffc0206f88:	c75f90ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0206f8c:	00090797          	auipc	a5,0x90
ffffffffc0206f90:	93c7b783          	ld	a5,-1732(a5) # ffffffffc02968c8 <current>
ffffffffc0206f94:	6522                	ld	a0,8(sp)
ffffffffc0206f96:	1014                	addi	a3,sp,32
ffffffffc0206f98:	80000737          	lui	a4,0x80000
ffffffffc0206f9c:	c82a                	sw	a0,16(sp)
ffffffffc0206f9e:	f436                	sd	a3,40(sp)
ffffffffc0206fa0:	f036                	sd	a3,32(sp)
ffffffffc0206fa2:	ec3e                	sd	a5,24(sp)
ffffffffc0206fa4:	4685                	li	a3,1
ffffffffc0206fa6:	0709                	addi	a4,a4,2 # ffffffff80000002 <_binary_bin_sfs_img_size+0xffffffff7ff8ad02>
ffffffffc0206fa8:	0808                	addi	a0,sp,16
ffffffffc0206faa:	c394                	sw	a3,0(a5)
ffffffffc0206fac:	0ee7a623          	sw	a4,236(a5)
ffffffffc0206fb0:	842a                	mv	s0,a0
ffffffffc0206fb2:	362000ef          	jal	ffffffffc0207314 <add_timer>
ffffffffc0206fb6:	c41f90ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc0206fba:	bf55                	j	ffffffffc0206f6e <do_sleep+0x38>

ffffffffc0206fbc <switch_to>:
ffffffffc0206fbc:	00153023          	sd	ra,0(a0)
ffffffffc0206fc0:	00253423          	sd	sp,8(a0)
ffffffffc0206fc4:	e900                	sd	s0,16(a0)
ffffffffc0206fc6:	ed04                	sd	s1,24(a0)
ffffffffc0206fc8:	03253023          	sd	s2,32(a0)
ffffffffc0206fcc:	03353423          	sd	s3,40(a0)
ffffffffc0206fd0:	03453823          	sd	s4,48(a0)
ffffffffc0206fd4:	03553c23          	sd	s5,56(a0)
ffffffffc0206fd8:	05653023          	sd	s6,64(a0)
ffffffffc0206fdc:	05753423          	sd	s7,72(a0)
ffffffffc0206fe0:	05853823          	sd	s8,80(a0)
ffffffffc0206fe4:	05953c23          	sd	s9,88(a0)
ffffffffc0206fe8:	07a53023          	sd	s10,96(a0)
ffffffffc0206fec:	07b53423          	sd	s11,104(a0)
ffffffffc0206ff0:	0005b083          	ld	ra,0(a1)
ffffffffc0206ff4:	0085b103          	ld	sp,8(a1)
ffffffffc0206ff8:	6980                	ld	s0,16(a1)
ffffffffc0206ffa:	6d84                	ld	s1,24(a1)
ffffffffc0206ffc:	0205b903          	ld	s2,32(a1)
ffffffffc0207000:	0285b983          	ld	s3,40(a1)
ffffffffc0207004:	0305ba03          	ld	s4,48(a1)
ffffffffc0207008:	0385ba83          	ld	s5,56(a1)
ffffffffc020700c:	0405bb03          	ld	s6,64(a1)
ffffffffc0207010:	0485bb83          	ld	s7,72(a1)
ffffffffc0207014:	0505bc03          	ld	s8,80(a1)
ffffffffc0207018:	0585bc83          	ld	s9,88(a1)
ffffffffc020701c:	0605bd03          	ld	s10,96(a1)
ffffffffc0207020:	0685bd83          	ld	s11,104(a1)
ffffffffc0207024:	8082                	ret

ffffffffc0207026 <RR_init>:
ffffffffc0207026:	e508                	sd	a0,8(a0)
ffffffffc0207028:	e108                	sd	a0,0(a0)
ffffffffc020702a:	00052823          	sw	zero,16(a0)
ffffffffc020702e:	00053c23          	sd	zero,24(a0)
ffffffffc0207032:	8082                	ret

ffffffffc0207034 <RR_pick_next>:
ffffffffc0207034:	651c                	ld	a5,8(a0)
ffffffffc0207036:	00f50563          	beq	a0,a5,ffffffffc0207040 <RR_pick_next+0xc>
ffffffffc020703a:	ef078513          	addi	a0,a5,-272
ffffffffc020703e:	8082                	ret
ffffffffc0207040:	4501                	li	a0,0
ffffffffc0207042:	8082                	ret

ffffffffc0207044 <RR_proc_tick>:
ffffffffc0207044:	00090797          	auipc	a5,0x90
ffffffffc0207048:	8947b783          	ld	a5,-1900(a5) # ffffffffc02968d8 <idleproc>
ffffffffc020704c:	00b78d63          	beq	a5,a1,ffffffffc0207066 <RR_proc_tick+0x22>
ffffffffc0207050:	c999                	beqz	a1,ffffffffc0207066 <RR_proc_tick+0x22>
ffffffffc0207052:	1205a783          	lw	a5,288(a1)
ffffffffc0207056:	00f05563          	blez	a5,ffffffffc0207060 <RR_proc_tick+0x1c>
ffffffffc020705a:	37fd                	addiw	a5,a5,-1
ffffffffc020705c:	12f5a023          	sw	a5,288(a1)
ffffffffc0207060:	e399                	bnez	a5,ffffffffc0207066 <RR_proc_tick+0x22>
ffffffffc0207062:	4785                	li	a5,1
ffffffffc0207064:	ed9c                	sd	a5,24(a1)
ffffffffc0207066:	8082                	ret

ffffffffc0207068 <RR_dequeue>:
ffffffffc0207068:	c59d                	beqz	a1,ffffffffc0207096 <RR_dequeue+0x2e>
ffffffffc020706a:	1085b783          	ld	a5,264(a1)
ffffffffc020706e:	02a79463          	bne	a5,a0,ffffffffc0207096 <RR_dequeue+0x2e>
ffffffffc0207072:	1105b503          	ld	a0,272(a1)
ffffffffc0207076:	1185b603          	ld	a2,280(a1)
ffffffffc020707a:	4b98                	lw	a4,16(a5)
ffffffffc020707c:	11058693          	addi	a3,a1,272
ffffffffc0207080:	e510                	sd	a2,8(a0)
ffffffffc0207082:	e208                	sd	a0,0(a2)
ffffffffc0207084:	1005b423          	sd	zero,264(a1)
ffffffffc0207088:	377d                	addiw	a4,a4,-1
ffffffffc020708a:	10d5bc23          	sd	a3,280(a1)
ffffffffc020708e:	10d5b823          	sd	a3,272(a1)
ffffffffc0207092:	cb98                	sw	a4,16(a5)
ffffffffc0207094:	8082                	ret
ffffffffc0207096:	1141                	addi	sp,sp,-16
ffffffffc0207098:	00006697          	auipc	a3,0x6
ffffffffc020709c:	5f868693          	addi	a3,a3,1528 # ffffffffc020d690 <etext+0x228e>
ffffffffc02070a0:	00004617          	auipc	a2,0x4
ffffffffc02070a4:	7a060613          	addi	a2,a2,1952 # ffffffffc020b840 <etext+0x43e>
ffffffffc02070a8:	03300593          	li	a1,51
ffffffffc02070ac:	00006517          	auipc	a0,0x6
ffffffffc02070b0:	5fc50513          	addi	a0,a0,1532 # ffffffffc020d6a8 <etext+0x22a6>
ffffffffc02070b4:	e406                	sd	ra,8(sp)
ffffffffc02070b6:	b94f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc02070ba <RR_enqueue>:
ffffffffc02070ba:	c995                	beqz	a1,ffffffffc02070ee <RR_enqueue+0x34>
ffffffffc02070bc:	6114                	ld	a3,0(a0)
ffffffffc02070be:	4918                	lw	a4,16(a0)
ffffffffc02070c0:	11058793          	addi	a5,a1,272
ffffffffc02070c4:	e11c                	sd	a5,0(a0)
ffffffffc02070c6:	e69c                	sd	a5,8(a3)
ffffffffc02070c8:	00090617          	auipc	a2,0x90
ffffffffc02070cc:	81063603          	ld	a2,-2032(a2) # ffffffffc02968d8 <idleproc>
ffffffffc02070d0:	10d5b823          	sd	a3,272(a1)
ffffffffc02070d4:	10a5bc23          	sd	a0,280(a1)
ffffffffc02070d8:	10a5b423          	sd	a0,264(a1)
ffffffffc02070dc:	0017079b          	addiw	a5,a4,1
ffffffffc02070e0:	c91c                	sw	a5,16(a0)
ffffffffc02070e2:	00b60563          	beq	a2,a1,ffffffffc02070ec <RR_enqueue+0x32>
ffffffffc02070e6:	495c                	lw	a5,20(a0)
ffffffffc02070e8:	12f5a023          	sw	a5,288(a1)
ffffffffc02070ec:	8082                	ret
ffffffffc02070ee:	1141                	addi	sp,sp,-16
ffffffffc02070f0:	00006697          	auipc	a3,0x6
ffffffffc02070f4:	5d868693          	addi	a3,a3,1496 # ffffffffc020d6c8 <etext+0x22c6>
ffffffffc02070f8:	00004617          	auipc	a2,0x4
ffffffffc02070fc:	74860613          	addi	a2,a2,1864 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207100:	02200593          	li	a1,34
ffffffffc0207104:	00006517          	auipc	a0,0x6
ffffffffc0207108:	5a450513          	addi	a0,a0,1444 # ffffffffc020d6a8 <etext+0x22a6>
ffffffffc020710c:	e406                	sd	ra,8(sp)
ffffffffc020710e:	b3cf90ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207112 <sched_init>:
ffffffffc0207112:	0008a797          	auipc	a5,0x8a
ffffffffc0207116:	f0e78793          	addi	a5,a5,-242 # ffffffffc0291020 <default_sched_class>
ffffffffc020711a:	1141                	addi	sp,sp,-16
ffffffffc020711c:	6794                	ld	a3,8(a5)
ffffffffc020711e:	0008f717          	auipc	a4,0x8f
ffffffffc0207122:	7cf73523          	sd	a5,1994(a4) # ffffffffc02968e8 <sched_class>
ffffffffc0207126:	e406                	sd	ra,8(sp)
ffffffffc0207128:	0008e797          	auipc	a5,0x8e
ffffffffc020712c:	6c878793          	addi	a5,a5,1736 # ffffffffc02957f0 <timer_list>
ffffffffc0207130:	0008e717          	auipc	a4,0x8e
ffffffffc0207134:	6a070713          	addi	a4,a4,1696 # ffffffffc02957d0 <__rq>
ffffffffc0207138:	4615                	li	a2,5
ffffffffc020713a:	e79c                	sd	a5,8(a5)
ffffffffc020713c:	e39c                	sd	a5,0(a5)
ffffffffc020713e:	853a                	mv	a0,a4
ffffffffc0207140:	cb50                	sw	a2,20(a4)
ffffffffc0207142:	0008f797          	auipc	a5,0x8f
ffffffffc0207146:	78e7bf23          	sd	a4,1950(a5) # ffffffffc02968e0 <rq>
ffffffffc020714a:	9682                	jalr	a3
ffffffffc020714c:	0008f797          	auipc	a5,0x8f
ffffffffc0207150:	79c7b783          	ld	a5,1948(a5) # ffffffffc02968e8 <sched_class>
ffffffffc0207154:	60a2                	ld	ra,8(sp)
ffffffffc0207156:	00006517          	auipc	a0,0x6
ffffffffc020715a:	58a50513          	addi	a0,a0,1418 # ffffffffc020d6e0 <etext+0x22de>
ffffffffc020715e:	638c                	ld	a1,0(a5)
ffffffffc0207160:	0141                	addi	sp,sp,16
ffffffffc0207162:	844f906f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0207166 <wakeup_proc>:
ffffffffc0207166:	4118                	lw	a4,0(a0)
ffffffffc0207168:	1101                	addi	sp,sp,-32
ffffffffc020716a:	ec06                	sd	ra,24(sp)
ffffffffc020716c:	478d                	li	a5,3
ffffffffc020716e:	0cf70863          	beq	a4,a5,ffffffffc020723e <wakeup_proc+0xd8>
ffffffffc0207172:	85aa                	mv	a1,a0
ffffffffc0207174:	100027f3          	csrr	a5,sstatus
ffffffffc0207178:	8b89                	andi	a5,a5,2
ffffffffc020717a:	e3b1                	bnez	a5,ffffffffc02071be <wakeup_proc+0x58>
ffffffffc020717c:	4789                	li	a5,2
ffffffffc020717e:	08f70563          	beq	a4,a5,ffffffffc0207208 <wakeup_proc+0xa2>
ffffffffc0207182:	0008f717          	auipc	a4,0x8f
ffffffffc0207186:	74673703          	ld	a4,1862(a4) # ffffffffc02968c8 <current>
ffffffffc020718a:	0e052623          	sw	zero,236(a0)
ffffffffc020718e:	c11c                	sw	a5,0(a0)
ffffffffc0207190:	02e50463          	beq	a0,a4,ffffffffc02071b8 <wakeup_proc+0x52>
ffffffffc0207194:	0008f797          	auipc	a5,0x8f
ffffffffc0207198:	7447b783          	ld	a5,1860(a5) # ffffffffc02968d8 <idleproc>
ffffffffc020719c:	00f50e63          	beq	a0,a5,ffffffffc02071b8 <wakeup_proc+0x52>
ffffffffc02071a0:	0008f797          	auipc	a5,0x8f
ffffffffc02071a4:	7487b783          	ld	a5,1864(a5) # ffffffffc02968e8 <sched_class>
ffffffffc02071a8:	60e2                	ld	ra,24(sp)
ffffffffc02071aa:	0008f517          	auipc	a0,0x8f
ffffffffc02071ae:	73653503          	ld	a0,1846(a0) # ffffffffc02968e0 <rq>
ffffffffc02071b2:	6b9c                	ld	a5,16(a5)
ffffffffc02071b4:	6105                	addi	sp,sp,32
ffffffffc02071b6:	8782                	jr	a5
ffffffffc02071b8:	60e2                	ld	ra,24(sp)
ffffffffc02071ba:	6105                	addi	sp,sp,32
ffffffffc02071bc:	8082                	ret
ffffffffc02071be:	e42a                	sd	a0,8(sp)
ffffffffc02071c0:	a3df90ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc02071c4:	65a2                	ld	a1,8(sp)
ffffffffc02071c6:	4789                	li	a5,2
ffffffffc02071c8:	4198                	lw	a4,0(a1)
ffffffffc02071ca:	04f70d63          	beq	a4,a5,ffffffffc0207224 <wakeup_proc+0xbe>
ffffffffc02071ce:	0008f717          	auipc	a4,0x8f
ffffffffc02071d2:	6fa73703          	ld	a4,1786(a4) # ffffffffc02968c8 <current>
ffffffffc02071d6:	0e05a623          	sw	zero,236(a1)
ffffffffc02071da:	c19c                	sw	a5,0(a1)
ffffffffc02071dc:	02e58263          	beq	a1,a4,ffffffffc0207200 <wakeup_proc+0x9a>
ffffffffc02071e0:	0008f797          	auipc	a5,0x8f
ffffffffc02071e4:	6f87b783          	ld	a5,1784(a5) # ffffffffc02968d8 <idleproc>
ffffffffc02071e8:	00f58c63          	beq	a1,a5,ffffffffc0207200 <wakeup_proc+0x9a>
ffffffffc02071ec:	0008f797          	auipc	a5,0x8f
ffffffffc02071f0:	6fc7b783          	ld	a5,1788(a5) # ffffffffc02968e8 <sched_class>
ffffffffc02071f4:	0008f517          	auipc	a0,0x8f
ffffffffc02071f8:	6ec53503          	ld	a0,1772(a0) # ffffffffc02968e0 <rq>
ffffffffc02071fc:	6b9c                	ld	a5,16(a5)
ffffffffc02071fe:	9782                	jalr	a5
ffffffffc0207200:	60e2                	ld	ra,24(sp)
ffffffffc0207202:	6105                	addi	sp,sp,32
ffffffffc0207204:	9f3f906f          	j	ffffffffc0200bf6 <intr_enable>
ffffffffc0207208:	60e2                	ld	ra,24(sp)
ffffffffc020720a:	00006617          	auipc	a2,0x6
ffffffffc020720e:	52660613          	addi	a2,a2,1318 # ffffffffc020d730 <etext+0x232e>
ffffffffc0207212:	05200593          	li	a1,82
ffffffffc0207216:	00006517          	auipc	a0,0x6
ffffffffc020721a:	50250513          	addi	a0,a0,1282 # ffffffffc020d718 <etext+0x2316>
ffffffffc020721e:	6105                	addi	sp,sp,32
ffffffffc0207220:	a94f906f          	j	ffffffffc02004b4 <__warn>
ffffffffc0207224:	00006617          	auipc	a2,0x6
ffffffffc0207228:	50c60613          	addi	a2,a2,1292 # ffffffffc020d730 <etext+0x232e>
ffffffffc020722c:	05200593          	li	a1,82
ffffffffc0207230:	00006517          	auipc	a0,0x6
ffffffffc0207234:	4e850513          	addi	a0,a0,1256 # ffffffffc020d718 <etext+0x2316>
ffffffffc0207238:	a7cf90ef          	jal	ffffffffc02004b4 <__warn>
ffffffffc020723c:	b7d1                	j	ffffffffc0207200 <wakeup_proc+0x9a>
ffffffffc020723e:	00006697          	auipc	a3,0x6
ffffffffc0207242:	4ba68693          	addi	a3,a3,1210 # ffffffffc020d6f8 <etext+0x22f6>
ffffffffc0207246:	00004617          	auipc	a2,0x4
ffffffffc020724a:	5fa60613          	addi	a2,a2,1530 # ffffffffc020b840 <etext+0x43e>
ffffffffc020724e:	04300593          	li	a1,67
ffffffffc0207252:	00006517          	auipc	a0,0x6
ffffffffc0207256:	4c650513          	addi	a0,a0,1222 # ffffffffc020d718 <etext+0x2316>
ffffffffc020725a:	9f0f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc020725e <schedule>:
ffffffffc020725e:	7139                	addi	sp,sp,-64
ffffffffc0207260:	fc06                	sd	ra,56(sp)
ffffffffc0207262:	f822                	sd	s0,48(sp)
ffffffffc0207264:	f426                	sd	s1,40(sp)
ffffffffc0207266:	f04a                	sd	s2,32(sp)
ffffffffc0207268:	ec4e                	sd	s3,24(sp)
ffffffffc020726a:	100027f3          	csrr	a5,sstatus
ffffffffc020726e:	8b89                	andi	a5,a5,2
ffffffffc0207270:	4981                	li	s3,0
ffffffffc0207272:	efc9                	bnez	a5,ffffffffc020730c <schedule+0xae>
ffffffffc0207274:	0008f417          	auipc	s0,0x8f
ffffffffc0207278:	65440413          	addi	s0,s0,1620 # ffffffffc02968c8 <current>
ffffffffc020727c:	600c                	ld	a1,0(s0)
ffffffffc020727e:	4789                	li	a5,2
ffffffffc0207280:	0008f497          	auipc	s1,0x8f
ffffffffc0207284:	66048493          	addi	s1,s1,1632 # ffffffffc02968e0 <rq>
ffffffffc0207288:	4198                	lw	a4,0(a1)
ffffffffc020728a:	0005bc23          	sd	zero,24(a1)
ffffffffc020728e:	0008f917          	auipc	s2,0x8f
ffffffffc0207292:	65a90913          	addi	s2,s2,1626 # ffffffffc02968e8 <sched_class>
ffffffffc0207296:	04f70f63          	beq	a4,a5,ffffffffc02072f4 <schedule+0x96>
ffffffffc020729a:	00093783          	ld	a5,0(s2)
ffffffffc020729e:	6088                	ld	a0,0(s1)
ffffffffc02072a0:	739c                	ld	a5,32(a5)
ffffffffc02072a2:	9782                	jalr	a5
ffffffffc02072a4:	85aa                	mv	a1,a0
ffffffffc02072a6:	c131                	beqz	a0,ffffffffc02072ea <schedule+0x8c>
ffffffffc02072a8:	00093783          	ld	a5,0(s2)
ffffffffc02072ac:	6088                	ld	a0,0(s1)
ffffffffc02072ae:	e42e                	sd	a1,8(sp)
ffffffffc02072b0:	6f9c                	ld	a5,24(a5)
ffffffffc02072b2:	9782                	jalr	a5
ffffffffc02072b4:	65a2                	ld	a1,8(sp)
ffffffffc02072b6:	459c                	lw	a5,8(a1)
ffffffffc02072b8:	6018                	ld	a4,0(s0)
ffffffffc02072ba:	2785                	addiw	a5,a5,1
ffffffffc02072bc:	c59c                	sw	a5,8(a1)
ffffffffc02072be:	00b70563          	beq	a4,a1,ffffffffc02072c8 <schedule+0x6a>
ffffffffc02072c2:	852e                	mv	a0,a1
ffffffffc02072c4:	f48fe0ef          	jal	ffffffffc0205a0c <proc_run>
ffffffffc02072c8:	00099963          	bnez	s3,ffffffffc02072da <schedule+0x7c>
ffffffffc02072cc:	70e2                	ld	ra,56(sp)
ffffffffc02072ce:	7442                	ld	s0,48(sp)
ffffffffc02072d0:	74a2                	ld	s1,40(sp)
ffffffffc02072d2:	7902                	ld	s2,32(sp)
ffffffffc02072d4:	69e2                	ld	s3,24(sp)
ffffffffc02072d6:	6121                	addi	sp,sp,64
ffffffffc02072d8:	8082                	ret
ffffffffc02072da:	7442                	ld	s0,48(sp)
ffffffffc02072dc:	70e2                	ld	ra,56(sp)
ffffffffc02072de:	74a2                	ld	s1,40(sp)
ffffffffc02072e0:	7902                	ld	s2,32(sp)
ffffffffc02072e2:	69e2                	ld	s3,24(sp)
ffffffffc02072e4:	6121                	addi	sp,sp,64
ffffffffc02072e6:	911f906f          	j	ffffffffc0200bf6 <intr_enable>
ffffffffc02072ea:	0008f597          	auipc	a1,0x8f
ffffffffc02072ee:	5ee5b583          	ld	a1,1518(a1) # ffffffffc02968d8 <idleproc>
ffffffffc02072f2:	b7d1                	j	ffffffffc02072b6 <schedule+0x58>
ffffffffc02072f4:	0008f797          	auipc	a5,0x8f
ffffffffc02072f8:	5e47b783          	ld	a5,1508(a5) # ffffffffc02968d8 <idleproc>
ffffffffc02072fc:	f8f58fe3          	beq	a1,a5,ffffffffc020729a <schedule+0x3c>
ffffffffc0207300:	00093783          	ld	a5,0(s2)
ffffffffc0207304:	6088                	ld	a0,0(s1)
ffffffffc0207306:	6b9c                	ld	a5,16(a5)
ffffffffc0207308:	9782                	jalr	a5
ffffffffc020730a:	bf41                	j	ffffffffc020729a <schedule+0x3c>
ffffffffc020730c:	8f1f90ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0207310:	4985                	li	s3,1
ffffffffc0207312:	b78d                	j	ffffffffc0207274 <schedule+0x16>

ffffffffc0207314 <add_timer>:
ffffffffc0207314:	1101                	addi	sp,sp,-32
ffffffffc0207316:	ec06                	sd	ra,24(sp)
ffffffffc0207318:	100027f3          	csrr	a5,sstatus
ffffffffc020731c:	8b89                	andi	a5,a5,2
ffffffffc020731e:	4801                	li	a6,0
ffffffffc0207320:	e7bd                	bnez	a5,ffffffffc020738e <add_timer+0x7a>
ffffffffc0207322:	4118                	lw	a4,0(a0)
ffffffffc0207324:	cb3d                	beqz	a4,ffffffffc020739a <add_timer+0x86>
ffffffffc0207326:	651c                	ld	a5,8(a0)
ffffffffc0207328:	cbad                	beqz	a5,ffffffffc020739a <add_timer+0x86>
ffffffffc020732a:	6d1c                	ld	a5,24(a0)
ffffffffc020732c:	01050593          	addi	a1,a0,16
ffffffffc0207330:	08f59563          	bne	a1,a5,ffffffffc02073ba <add_timer+0xa6>
ffffffffc0207334:	0008e617          	auipc	a2,0x8e
ffffffffc0207338:	4bc60613          	addi	a2,a2,1212 # ffffffffc02957f0 <timer_list>
ffffffffc020733c:	661c                	ld	a5,8(a2)
ffffffffc020733e:	00c79863          	bne	a5,a2,ffffffffc020734e <add_timer+0x3a>
ffffffffc0207342:	a805                	j	ffffffffc0207372 <add_timer+0x5e>
ffffffffc0207344:	679c                	ld	a5,8(a5)
ffffffffc0207346:	9f15                	subw	a4,a4,a3
ffffffffc0207348:	c118                	sw	a4,0(a0)
ffffffffc020734a:	02c78463          	beq	a5,a2,ffffffffc0207372 <add_timer+0x5e>
ffffffffc020734e:	ff07a683          	lw	a3,-16(a5)
ffffffffc0207352:	fed779e3          	bgeu	a4,a3,ffffffffc0207344 <add_timer+0x30>
ffffffffc0207356:	9e99                	subw	a3,a3,a4
ffffffffc0207358:	6398                	ld	a4,0(a5)
ffffffffc020735a:	fed7a823          	sw	a3,-16(a5)
ffffffffc020735e:	e38c                	sd	a1,0(a5)
ffffffffc0207360:	e70c                	sd	a1,8(a4)
ffffffffc0207362:	e918                	sd	a4,16(a0)
ffffffffc0207364:	ed1c                	sd	a5,24(a0)
ffffffffc0207366:	02080163          	beqz	a6,ffffffffc0207388 <add_timer+0x74>
ffffffffc020736a:	60e2                	ld	ra,24(sp)
ffffffffc020736c:	6105                	addi	sp,sp,32
ffffffffc020736e:	889f906f          	j	ffffffffc0200bf6 <intr_enable>
ffffffffc0207372:	0008e797          	auipc	a5,0x8e
ffffffffc0207376:	47e78793          	addi	a5,a5,1150 # ffffffffc02957f0 <timer_list>
ffffffffc020737a:	6398                	ld	a4,0(a5)
ffffffffc020737c:	e38c                	sd	a1,0(a5)
ffffffffc020737e:	e70c                	sd	a1,8(a4)
ffffffffc0207380:	e918                	sd	a4,16(a0)
ffffffffc0207382:	ed1c                	sd	a5,24(a0)
ffffffffc0207384:	fe0813e3          	bnez	a6,ffffffffc020736a <add_timer+0x56>
ffffffffc0207388:	60e2                	ld	ra,24(sp)
ffffffffc020738a:	6105                	addi	sp,sp,32
ffffffffc020738c:	8082                	ret
ffffffffc020738e:	e42a                	sd	a0,8(sp)
ffffffffc0207390:	86df90ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0207394:	6522                	ld	a0,8(sp)
ffffffffc0207396:	4805                	li	a6,1
ffffffffc0207398:	b769                	j	ffffffffc0207322 <add_timer+0xe>
ffffffffc020739a:	00006697          	auipc	a3,0x6
ffffffffc020739e:	3b668693          	addi	a3,a3,950 # ffffffffc020d750 <etext+0x234e>
ffffffffc02073a2:	00004617          	auipc	a2,0x4
ffffffffc02073a6:	49e60613          	addi	a2,a2,1182 # ffffffffc020b840 <etext+0x43e>
ffffffffc02073aa:	07a00593          	li	a1,122
ffffffffc02073ae:	00006517          	auipc	a0,0x6
ffffffffc02073b2:	36a50513          	addi	a0,a0,874 # ffffffffc020d718 <etext+0x2316>
ffffffffc02073b6:	894f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc02073ba:	00006697          	auipc	a3,0x6
ffffffffc02073be:	3c668693          	addi	a3,a3,966 # ffffffffc020d780 <etext+0x237e>
ffffffffc02073c2:	00004617          	auipc	a2,0x4
ffffffffc02073c6:	47e60613          	addi	a2,a2,1150 # ffffffffc020b840 <etext+0x43e>
ffffffffc02073ca:	07b00593          	li	a1,123
ffffffffc02073ce:	00006517          	auipc	a0,0x6
ffffffffc02073d2:	34a50513          	addi	a0,a0,842 # ffffffffc020d718 <etext+0x2316>
ffffffffc02073d6:	874f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc02073da <del_timer>:
ffffffffc02073da:	100027f3          	csrr	a5,sstatus
ffffffffc02073de:	8b89                	andi	a5,a5,2
ffffffffc02073e0:	ef95                	bnez	a5,ffffffffc020741c <del_timer+0x42>
ffffffffc02073e2:	6d1c                	ld	a5,24(a0)
ffffffffc02073e4:	01050713          	addi	a4,a0,16
ffffffffc02073e8:	4601                	li	a2,0
ffffffffc02073ea:	02f70863          	beq	a4,a5,ffffffffc020741a <del_timer+0x40>
ffffffffc02073ee:	0008e597          	auipc	a1,0x8e
ffffffffc02073f2:	40258593          	addi	a1,a1,1026 # ffffffffc02957f0 <timer_list>
ffffffffc02073f6:	4114                	lw	a3,0(a0)
ffffffffc02073f8:	00b78863          	beq	a5,a1,ffffffffc0207408 <del_timer+0x2e>
ffffffffc02073fc:	c691                	beqz	a3,ffffffffc0207408 <del_timer+0x2e>
ffffffffc02073fe:	ff07a583          	lw	a1,-16(a5)
ffffffffc0207402:	9ead                	addw	a3,a3,a1
ffffffffc0207404:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207408:	6914                	ld	a3,16(a0)
ffffffffc020740a:	e69c                	sd	a5,8(a3)
ffffffffc020740c:	e394                	sd	a3,0(a5)
ffffffffc020740e:	ed18                	sd	a4,24(a0)
ffffffffc0207410:	e918                	sd	a4,16(a0)
ffffffffc0207412:	e211                	bnez	a2,ffffffffc0207416 <del_timer+0x3c>
ffffffffc0207414:	8082                	ret
ffffffffc0207416:	fe0f906f          	j	ffffffffc0200bf6 <intr_enable>
ffffffffc020741a:	8082                	ret
ffffffffc020741c:	1101                	addi	sp,sp,-32
ffffffffc020741e:	e42a                	sd	a0,8(sp)
ffffffffc0207420:	ec06                	sd	ra,24(sp)
ffffffffc0207422:	fdaf90ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0207426:	6522                	ld	a0,8(sp)
ffffffffc0207428:	4605                	li	a2,1
ffffffffc020742a:	6d1c                	ld	a5,24(a0)
ffffffffc020742c:	01050713          	addi	a4,a0,16
ffffffffc0207430:	02f70863          	beq	a4,a5,ffffffffc0207460 <del_timer+0x86>
ffffffffc0207434:	0008e597          	auipc	a1,0x8e
ffffffffc0207438:	3bc58593          	addi	a1,a1,956 # ffffffffc02957f0 <timer_list>
ffffffffc020743c:	4114                	lw	a3,0(a0)
ffffffffc020743e:	00b78863          	beq	a5,a1,ffffffffc020744e <del_timer+0x74>
ffffffffc0207442:	c691                	beqz	a3,ffffffffc020744e <del_timer+0x74>
ffffffffc0207444:	ff07a583          	lw	a1,-16(a5)
ffffffffc0207448:	9ead                	addw	a3,a3,a1
ffffffffc020744a:	fed7a823          	sw	a3,-16(a5)
ffffffffc020744e:	6914                	ld	a3,16(a0)
ffffffffc0207450:	e69c                	sd	a5,8(a3)
ffffffffc0207452:	e394                	sd	a3,0(a5)
ffffffffc0207454:	ed18                	sd	a4,24(a0)
ffffffffc0207456:	e918                	sd	a4,16(a0)
ffffffffc0207458:	e601                	bnez	a2,ffffffffc0207460 <del_timer+0x86>
ffffffffc020745a:	60e2                	ld	ra,24(sp)
ffffffffc020745c:	6105                	addi	sp,sp,32
ffffffffc020745e:	8082                	ret
ffffffffc0207460:	60e2                	ld	ra,24(sp)
ffffffffc0207462:	6105                	addi	sp,sp,32
ffffffffc0207464:	f92f906f          	j	ffffffffc0200bf6 <intr_enable>

ffffffffc0207468 <sys_getpid>:
ffffffffc0207468:	0008f797          	auipc	a5,0x8f
ffffffffc020746c:	4607b783          	ld	a5,1120(a5) # ffffffffc02968c8 <current>
ffffffffc0207470:	43c8                	lw	a0,4(a5)
ffffffffc0207472:	8082                	ret

ffffffffc0207474 <sys_pgdir>:
ffffffffc0207474:	4501                	li	a0,0
ffffffffc0207476:	8082                	ret

ffffffffc0207478 <sys_gettime>:
ffffffffc0207478:	0008f797          	auipc	a5,0x8f
ffffffffc020747c:	3f87b783          	ld	a5,1016(a5) # ffffffffc0296870 <ticks>
ffffffffc0207480:	0027951b          	slliw	a0,a5,0x2
ffffffffc0207484:	9d3d                	addw	a0,a0,a5
ffffffffc0207486:	0015151b          	slliw	a0,a0,0x1
ffffffffc020748a:	8082                	ret

ffffffffc020748c <sys_lab6_set_priority>:
ffffffffc020748c:	4108                	lw	a0,0(a0)
ffffffffc020748e:	1141                	addi	sp,sp,-16
ffffffffc0207490:	e406                	sd	ra,8(sp)
ffffffffc0207492:	a77ff0ef          	jal	ffffffffc0206f08 <lab6_set_priority>
ffffffffc0207496:	60a2                	ld	ra,8(sp)
ffffffffc0207498:	4501                	li	a0,0
ffffffffc020749a:	0141                	addi	sp,sp,16
ffffffffc020749c:	8082                	ret

ffffffffc020749e <sys_dup>:
ffffffffc020749e:	450c                	lw	a1,8(a0)
ffffffffc02074a0:	4108                	lw	a0,0(a0)
ffffffffc02074a2:	bbafe06f          	j	ffffffffc020585c <sysfile_dup>

ffffffffc02074a6 <sys_getdirentry>:
ffffffffc02074a6:	650c                	ld	a1,8(a0)
ffffffffc02074a8:	4108                	lw	a0,0(a0)
ffffffffc02074aa:	ac2fe06f          	j	ffffffffc020576c <sysfile_getdirentry>

ffffffffc02074ae <sys_getcwd>:
ffffffffc02074ae:	650c                	ld	a1,8(a0)
ffffffffc02074b0:	6108                	ld	a0,0(a0)
ffffffffc02074b2:	a10fe06f          	j	ffffffffc02056c2 <sysfile_getcwd>

ffffffffc02074b6 <sys_fsync>:
ffffffffc02074b6:	4108                	lw	a0,0(a0)
ffffffffc02074b8:	a06fe06f          	j	ffffffffc02056be <sysfile_fsync>

ffffffffc02074bc <sys_fstat>:
ffffffffc02074bc:	650c                	ld	a1,8(a0)
ffffffffc02074be:	4108                	lw	a0,0(a0)
ffffffffc02074c0:	976fe06f          	j	ffffffffc0205636 <sysfile_fstat>

ffffffffc02074c4 <sys_seek>:
ffffffffc02074c4:	4910                	lw	a2,16(a0)
ffffffffc02074c6:	650c                	ld	a1,8(a0)
ffffffffc02074c8:	4108                	lw	a0,0(a0)
ffffffffc02074ca:	968fe06f          	j	ffffffffc0205632 <sysfile_seek>

ffffffffc02074ce <sys_write>:
ffffffffc02074ce:	6910                	ld	a2,16(a0)
ffffffffc02074d0:	650c                	ld	a1,8(a0)
ffffffffc02074d2:	4108                	lw	a0,0(a0)
ffffffffc02074d4:	82cfe06f          	j	ffffffffc0205500 <sysfile_write>

ffffffffc02074d8 <sys_read>:
ffffffffc02074d8:	6910                	ld	a2,16(a0)
ffffffffc02074da:	650c                	ld	a1,8(a0)
ffffffffc02074dc:	4108                	lw	a0,0(a0)
ffffffffc02074de:	ed7fd06f          	j	ffffffffc02053b4 <sysfile_read>

ffffffffc02074e2 <sys_close>:
ffffffffc02074e2:	4108                	lw	a0,0(a0)
ffffffffc02074e4:	ecdfd06f          	j	ffffffffc02053b0 <sysfile_close>

ffffffffc02074e8 <sys_open>:
ffffffffc02074e8:	450c                	lw	a1,8(a0)
ffffffffc02074ea:	6108                	ld	a0,0(a0)
ffffffffc02074ec:	e8ffd06f          	j	ffffffffc020537a <sysfile_open>

ffffffffc02074f0 <sys_putc>:
ffffffffc02074f0:	4108                	lw	a0,0(a0)
ffffffffc02074f2:	1141                	addi	sp,sp,-16
ffffffffc02074f4:	e406                	sd	ra,8(sp)
ffffffffc02074f6:	cebf80ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc02074fa:	60a2                	ld	ra,8(sp)
ffffffffc02074fc:	4501                	li	a0,0
ffffffffc02074fe:	0141                	addi	sp,sp,16
ffffffffc0207500:	8082                	ret

ffffffffc0207502 <sys_kill>:
ffffffffc0207502:	4108                	lw	a0,0(a0)
ffffffffc0207504:	f9eff06f          	j	ffffffffc0206ca2 <do_kill>

ffffffffc0207508 <sys_sleep>:
ffffffffc0207508:	4108                	lw	a0,0(a0)
ffffffffc020750a:	a2dff06f          	j	ffffffffc0206f36 <do_sleep>

ffffffffc020750e <sys_yield>:
ffffffffc020750e:	f4aff06f          	j	ffffffffc0206c58 <do_yield>

ffffffffc0207512 <sys_exec>:
ffffffffc0207512:	6910                	ld	a2,16(a0)
ffffffffc0207514:	450c                	lw	a1,8(a0)
ffffffffc0207516:	6108                	ld	a0,0(a0)
ffffffffc0207518:	e67fe06f          	j	ffffffffc020637e <do_execve>

ffffffffc020751c <sys_wait>:
ffffffffc020751c:	650c                	ld	a1,8(a0)
ffffffffc020751e:	4108                	lw	a0,0(a0)
ffffffffc0207520:	f48ff06f          	j	ffffffffc0206c68 <do_wait>

ffffffffc0207524 <sys_fork>:
ffffffffc0207524:	0008f797          	auipc	a5,0x8f
ffffffffc0207528:	3a47b783          	ld	a5,932(a5) # ffffffffc02968c8 <current>
ffffffffc020752c:	4501                	li	a0,0
ffffffffc020752e:	73d0                	ld	a2,160(a5)
ffffffffc0207530:	6a0c                	ld	a1,16(a2)
ffffffffc0207532:	d40fe06f          	j	ffffffffc0205a72 <do_fork>

ffffffffc0207536 <sys_exit>:
ffffffffc0207536:	4108                	lw	a0,0(a0)
ffffffffc0207538:	9b5fe06f          	j	ffffffffc0205eec <do_exit>

ffffffffc020753c <syscall>:
ffffffffc020753c:	0008f697          	auipc	a3,0x8f
ffffffffc0207540:	38c6b683          	ld	a3,908(a3) # ffffffffc02968c8 <current>
ffffffffc0207544:	715d                	addi	sp,sp,-80
ffffffffc0207546:	e0a2                	sd	s0,64(sp)
ffffffffc0207548:	72c0                	ld	s0,160(a3)
ffffffffc020754a:	e486                	sd	ra,72(sp)
ffffffffc020754c:	0ff00793          	li	a5,255
ffffffffc0207550:	4834                	lw	a3,80(s0)
ffffffffc0207552:	02d7ec63          	bltu	a5,a3,ffffffffc020758a <syscall+0x4e>
ffffffffc0207556:	00007797          	auipc	a5,0x7
ffffffffc020755a:	4da78793          	addi	a5,a5,1242 # ffffffffc020ea30 <syscalls>
ffffffffc020755e:	00369613          	slli	a2,a3,0x3
ffffffffc0207562:	97b2                	add	a5,a5,a2
ffffffffc0207564:	639c                	ld	a5,0(a5)
ffffffffc0207566:	c395                	beqz	a5,ffffffffc020758a <syscall+0x4e>
ffffffffc0207568:	7028                	ld	a0,96(s0)
ffffffffc020756a:	742c                	ld	a1,104(s0)
ffffffffc020756c:	7830                	ld	a2,112(s0)
ffffffffc020756e:	7c34                	ld	a3,120(s0)
ffffffffc0207570:	6c38                	ld	a4,88(s0)
ffffffffc0207572:	f02a                	sd	a0,32(sp)
ffffffffc0207574:	f42e                	sd	a1,40(sp)
ffffffffc0207576:	f832                	sd	a2,48(sp)
ffffffffc0207578:	fc36                	sd	a3,56(sp)
ffffffffc020757a:	ec3a                	sd	a4,24(sp)
ffffffffc020757c:	0828                	addi	a0,sp,24
ffffffffc020757e:	9782                	jalr	a5
ffffffffc0207580:	60a6                	ld	ra,72(sp)
ffffffffc0207582:	e828                	sd	a0,80(s0)
ffffffffc0207584:	6406                	ld	s0,64(sp)
ffffffffc0207586:	6161                	addi	sp,sp,80
ffffffffc0207588:	8082                	ret
ffffffffc020758a:	8522                	mv	a0,s0
ffffffffc020758c:	e436                	sd	a3,8(sp)
ffffffffc020758e:	983f90ef          	jal	ffffffffc0200f10 <print_trapframe>
ffffffffc0207592:	0008f797          	auipc	a5,0x8f
ffffffffc0207596:	3367b783          	ld	a5,822(a5) # ffffffffc02968c8 <current>
ffffffffc020759a:	66a2                	ld	a3,8(sp)
ffffffffc020759c:	00006617          	auipc	a2,0x6
ffffffffc02075a0:	20c60613          	addi	a2,a2,524 # ffffffffc020d7a8 <etext+0x23a6>
ffffffffc02075a4:	43d8                	lw	a4,4(a5)
ffffffffc02075a6:	0d800593          	li	a1,216
ffffffffc02075aa:	0b478793          	addi	a5,a5,180
ffffffffc02075ae:	00006517          	auipc	a0,0x6
ffffffffc02075b2:	22a50513          	addi	a0,a0,554 # ffffffffc020d7d8 <etext+0x23d6>
ffffffffc02075b6:	e95f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02075ba <__alloc_inode>:
ffffffffc02075ba:	1141                	addi	sp,sp,-16
ffffffffc02075bc:	e022                	sd	s0,0(sp)
ffffffffc02075be:	842a                	mv	s0,a0
ffffffffc02075c0:	07800513          	li	a0,120
ffffffffc02075c4:	e406                	sd	ra,8(sp)
ffffffffc02075c6:	a0ffa0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc02075ca:	c111                	beqz	a0,ffffffffc02075ce <__alloc_inode+0x14>
ffffffffc02075cc:	cd20                	sw	s0,88(a0)
ffffffffc02075ce:	60a2                	ld	ra,8(sp)
ffffffffc02075d0:	6402                	ld	s0,0(sp)
ffffffffc02075d2:	0141                	addi	sp,sp,16
ffffffffc02075d4:	8082                	ret

ffffffffc02075d6 <inode_init>:
ffffffffc02075d6:	4785                	li	a5,1
ffffffffc02075d8:	06052023          	sw	zero,96(a0)
ffffffffc02075dc:	f92c                	sd	a1,112(a0)
ffffffffc02075de:	f530                	sd	a2,104(a0)
ffffffffc02075e0:	cd7c                	sw	a5,92(a0)
ffffffffc02075e2:	8082                	ret

ffffffffc02075e4 <inode_kill>:
ffffffffc02075e4:	4d78                	lw	a4,92(a0)
ffffffffc02075e6:	1141                	addi	sp,sp,-16
ffffffffc02075e8:	e406                	sd	ra,8(sp)
ffffffffc02075ea:	e719                	bnez	a4,ffffffffc02075f8 <inode_kill+0x14>
ffffffffc02075ec:	513c                	lw	a5,96(a0)
ffffffffc02075ee:	e78d                	bnez	a5,ffffffffc0207618 <inode_kill+0x34>
ffffffffc02075f0:	60a2                	ld	ra,8(sp)
ffffffffc02075f2:	0141                	addi	sp,sp,16
ffffffffc02075f4:	a87fa06f          	j	ffffffffc020207a <kfree>
ffffffffc02075f8:	00006697          	auipc	a3,0x6
ffffffffc02075fc:	1f868693          	addi	a3,a3,504 # ffffffffc020d7f0 <etext+0x23ee>
ffffffffc0207600:	00004617          	auipc	a2,0x4
ffffffffc0207604:	24060613          	addi	a2,a2,576 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207608:	02900593          	li	a1,41
ffffffffc020760c:	00006517          	auipc	a0,0x6
ffffffffc0207610:	20450513          	addi	a0,a0,516 # ffffffffc020d810 <etext+0x240e>
ffffffffc0207614:	e37f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207618:	00006697          	auipc	a3,0x6
ffffffffc020761c:	21068693          	addi	a3,a3,528 # ffffffffc020d828 <etext+0x2426>
ffffffffc0207620:	00004617          	auipc	a2,0x4
ffffffffc0207624:	22060613          	addi	a2,a2,544 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207628:	02a00593          	li	a1,42
ffffffffc020762c:	00006517          	auipc	a0,0x6
ffffffffc0207630:	1e450513          	addi	a0,a0,484 # ffffffffc020d810 <etext+0x240e>
ffffffffc0207634:	e17f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207638 <inode_ref_inc>:
ffffffffc0207638:	4d7c                	lw	a5,92(a0)
ffffffffc020763a:	2785                	addiw	a5,a5,1
ffffffffc020763c:	cd7c                	sw	a5,92(a0)
ffffffffc020763e:	853e                	mv	a0,a5
ffffffffc0207640:	8082                	ret

ffffffffc0207642 <inode_open_inc>:
ffffffffc0207642:	513c                	lw	a5,96(a0)
ffffffffc0207644:	2785                	addiw	a5,a5,1
ffffffffc0207646:	d13c                	sw	a5,96(a0)
ffffffffc0207648:	853e                	mv	a0,a5
ffffffffc020764a:	8082                	ret

ffffffffc020764c <inode_check>:
ffffffffc020764c:	1141                	addi	sp,sp,-16
ffffffffc020764e:	e406                	sd	ra,8(sp)
ffffffffc0207650:	c91d                	beqz	a0,ffffffffc0207686 <inode_check+0x3a>
ffffffffc0207652:	793c                	ld	a5,112(a0)
ffffffffc0207654:	cb8d                	beqz	a5,ffffffffc0207686 <inode_check+0x3a>
ffffffffc0207656:	6398                	ld	a4,0(a5)
ffffffffc0207658:	4625d7b7          	lui	a5,0x4625d
ffffffffc020765c:	0786                	slli	a5,a5,0x1
ffffffffc020765e:	47678793          	addi	a5,a5,1142 # 4625d476 <_binary_bin_sfs_img_size+0x461e8176>
ffffffffc0207662:	08f71263          	bne	a4,a5,ffffffffc02076e6 <inode_check+0x9a>
ffffffffc0207666:	4d74                	lw	a3,92(a0)
ffffffffc0207668:	5138                	lw	a4,96(a0)
ffffffffc020766a:	04e6ce63          	blt	a3,a4,ffffffffc02076c6 <inode_check+0x7a>
ffffffffc020766e:	01f7579b          	srliw	a5,a4,0x1f
ffffffffc0207672:	ebb1                	bnez	a5,ffffffffc02076c6 <inode_check+0x7a>
ffffffffc0207674:	67c1                	lui	a5,0x10
ffffffffc0207676:	17fd                	addi	a5,a5,-1 # ffff <_binary_bin_swap_img_size+0x82ff>
ffffffffc0207678:	02d7c763          	blt	a5,a3,ffffffffc02076a6 <inode_check+0x5a>
ffffffffc020767c:	02e7c563          	blt	a5,a4,ffffffffc02076a6 <inode_check+0x5a>
ffffffffc0207680:	60a2                	ld	ra,8(sp)
ffffffffc0207682:	0141                	addi	sp,sp,16
ffffffffc0207684:	8082                	ret
ffffffffc0207686:	00006697          	auipc	a3,0x6
ffffffffc020768a:	1c268693          	addi	a3,a3,450 # ffffffffc020d848 <etext+0x2446>
ffffffffc020768e:	00004617          	auipc	a2,0x4
ffffffffc0207692:	1b260613          	addi	a2,a2,434 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207696:	06e00593          	li	a1,110
ffffffffc020769a:	00006517          	auipc	a0,0x6
ffffffffc020769e:	17650513          	addi	a0,a0,374 # ffffffffc020d810 <etext+0x240e>
ffffffffc02076a2:	da9f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02076a6:	00006697          	auipc	a3,0x6
ffffffffc02076aa:	22268693          	addi	a3,a3,546 # ffffffffc020d8c8 <etext+0x24c6>
ffffffffc02076ae:	00004617          	auipc	a2,0x4
ffffffffc02076b2:	19260613          	addi	a2,a2,402 # ffffffffc020b840 <etext+0x43e>
ffffffffc02076b6:	07200593          	li	a1,114
ffffffffc02076ba:	00006517          	auipc	a0,0x6
ffffffffc02076be:	15650513          	addi	a0,a0,342 # ffffffffc020d810 <etext+0x240e>
ffffffffc02076c2:	d89f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02076c6:	00006697          	auipc	a3,0x6
ffffffffc02076ca:	1d268693          	addi	a3,a3,466 # ffffffffc020d898 <etext+0x2496>
ffffffffc02076ce:	00004617          	auipc	a2,0x4
ffffffffc02076d2:	17260613          	addi	a2,a2,370 # ffffffffc020b840 <etext+0x43e>
ffffffffc02076d6:	07100593          	li	a1,113
ffffffffc02076da:	00006517          	auipc	a0,0x6
ffffffffc02076de:	13650513          	addi	a0,a0,310 # ffffffffc020d810 <etext+0x240e>
ffffffffc02076e2:	d69f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02076e6:	00006697          	auipc	a3,0x6
ffffffffc02076ea:	18a68693          	addi	a3,a3,394 # ffffffffc020d870 <etext+0x246e>
ffffffffc02076ee:	00004617          	auipc	a2,0x4
ffffffffc02076f2:	15260613          	addi	a2,a2,338 # ffffffffc020b840 <etext+0x43e>
ffffffffc02076f6:	06f00593          	li	a1,111
ffffffffc02076fa:	00006517          	auipc	a0,0x6
ffffffffc02076fe:	11650513          	addi	a0,a0,278 # ffffffffc020d810 <etext+0x240e>
ffffffffc0207702:	d49f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207706 <inode_ref_dec>:
ffffffffc0207706:	4d7c                	lw	a5,92(a0)
ffffffffc0207708:	7179                	addi	sp,sp,-48
ffffffffc020770a:	f406                	sd	ra,40(sp)
ffffffffc020770c:	06f05b63          	blez	a5,ffffffffc0207782 <inode_ref_dec+0x7c>
ffffffffc0207710:	37fd                	addiw	a5,a5,-1
ffffffffc0207712:	cd7c                	sw	a5,92(a0)
ffffffffc0207714:	e795                	bnez	a5,ffffffffc0207740 <inode_ref_dec+0x3a>
ffffffffc0207716:	7934                	ld	a3,112(a0)
ffffffffc0207718:	c6a9                	beqz	a3,ffffffffc0207762 <inode_ref_dec+0x5c>
ffffffffc020771a:	66b4                	ld	a3,72(a3)
ffffffffc020771c:	c2b9                	beqz	a3,ffffffffc0207762 <inode_ref_dec+0x5c>
ffffffffc020771e:	00006597          	auipc	a1,0x6
ffffffffc0207722:	25a58593          	addi	a1,a1,602 # ffffffffc020d978 <etext+0x2576>
ffffffffc0207726:	e83e                	sd	a5,16(sp)
ffffffffc0207728:	ec2a                	sd	a0,24(sp)
ffffffffc020772a:	e436                	sd	a3,8(sp)
ffffffffc020772c:	f21ff0ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0207730:	6562                	ld	a0,24(sp)
ffffffffc0207732:	66a2                	ld	a3,8(sp)
ffffffffc0207734:	9682                	jalr	a3
ffffffffc0207736:	00f50713          	addi	a4,a0,15
ffffffffc020773a:	67c2                	ld	a5,16(sp)
ffffffffc020773c:	c311                	beqz	a4,ffffffffc0207740 <inode_ref_dec+0x3a>
ffffffffc020773e:	e509                	bnez	a0,ffffffffc0207748 <inode_ref_dec+0x42>
ffffffffc0207740:	70a2                	ld	ra,40(sp)
ffffffffc0207742:	853e                	mv	a0,a5
ffffffffc0207744:	6145                	addi	sp,sp,48
ffffffffc0207746:	8082                	ret
ffffffffc0207748:	85aa                	mv	a1,a0
ffffffffc020774a:	00006517          	auipc	a0,0x6
ffffffffc020774e:	23650513          	addi	a0,a0,566 # ffffffffc020d980 <etext+0x257e>
ffffffffc0207752:	e43e                	sd	a5,8(sp)
ffffffffc0207754:	a53f80ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0207758:	67a2                	ld	a5,8(sp)
ffffffffc020775a:	70a2                	ld	ra,40(sp)
ffffffffc020775c:	853e                	mv	a0,a5
ffffffffc020775e:	6145                	addi	sp,sp,48
ffffffffc0207760:	8082                	ret
ffffffffc0207762:	00006697          	auipc	a3,0x6
ffffffffc0207766:	1c668693          	addi	a3,a3,454 # ffffffffc020d928 <etext+0x2526>
ffffffffc020776a:	00004617          	auipc	a2,0x4
ffffffffc020776e:	0d660613          	addi	a2,a2,214 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207772:	04400593          	li	a1,68
ffffffffc0207776:	00006517          	auipc	a0,0x6
ffffffffc020777a:	09a50513          	addi	a0,a0,154 # ffffffffc020d810 <etext+0x240e>
ffffffffc020777e:	ccdf80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207782:	00006697          	auipc	a3,0x6
ffffffffc0207786:	18668693          	addi	a3,a3,390 # ffffffffc020d908 <etext+0x2506>
ffffffffc020778a:	00004617          	auipc	a2,0x4
ffffffffc020778e:	0b660613          	addi	a2,a2,182 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207792:	03f00593          	li	a1,63
ffffffffc0207796:	00006517          	auipc	a0,0x6
ffffffffc020779a:	07a50513          	addi	a0,a0,122 # ffffffffc020d810 <etext+0x240e>
ffffffffc020779e:	cadf80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02077a2 <inode_open_dec>:
ffffffffc02077a2:	513c                	lw	a5,96(a0)
ffffffffc02077a4:	7179                	addi	sp,sp,-48
ffffffffc02077a6:	f406                	sd	ra,40(sp)
ffffffffc02077a8:	06f05863          	blez	a5,ffffffffc0207818 <inode_open_dec+0x76>
ffffffffc02077ac:	37fd                	addiw	a5,a5,-1
ffffffffc02077ae:	d13c                	sw	a5,96(a0)
ffffffffc02077b0:	e39d                	bnez	a5,ffffffffc02077d6 <inode_open_dec+0x34>
ffffffffc02077b2:	7934                	ld	a3,112(a0)
ffffffffc02077b4:	c2b1                	beqz	a3,ffffffffc02077f8 <inode_open_dec+0x56>
ffffffffc02077b6:	6a94                	ld	a3,16(a3)
ffffffffc02077b8:	c2a1                	beqz	a3,ffffffffc02077f8 <inode_open_dec+0x56>
ffffffffc02077ba:	00006597          	auipc	a1,0x6
ffffffffc02077be:	25658593          	addi	a1,a1,598 # ffffffffc020da10 <etext+0x260e>
ffffffffc02077c2:	e83e                	sd	a5,16(sp)
ffffffffc02077c4:	ec2a                	sd	a0,24(sp)
ffffffffc02077c6:	e436                	sd	a3,8(sp)
ffffffffc02077c8:	e85ff0ef          	jal	ffffffffc020764c <inode_check>
ffffffffc02077cc:	6562                	ld	a0,24(sp)
ffffffffc02077ce:	66a2                	ld	a3,8(sp)
ffffffffc02077d0:	9682                	jalr	a3
ffffffffc02077d2:	67c2                	ld	a5,16(sp)
ffffffffc02077d4:	e509                	bnez	a0,ffffffffc02077de <inode_open_dec+0x3c>
ffffffffc02077d6:	70a2                	ld	ra,40(sp)
ffffffffc02077d8:	853e                	mv	a0,a5
ffffffffc02077da:	6145                	addi	sp,sp,48
ffffffffc02077dc:	8082                	ret
ffffffffc02077de:	85aa                	mv	a1,a0
ffffffffc02077e0:	00006517          	auipc	a0,0x6
ffffffffc02077e4:	23850513          	addi	a0,a0,568 # ffffffffc020da18 <etext+0x2616>
ffffffffc02077e8:	e43e                	sd	a5,8(sp)
ffffffffc02077ea:	9bdf80ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02077ee:	67a2                	ld	a5,8(sp)
ffffffffc02077f0:	70a2                	ld	ra,40(sp)
ffffffffc02077f2:	853e                	mv	a0,a5
ffffffffc02077f4:	6145                	addi	sp,sp,48
ffffffffc02077f6:	8082                	ret
ffffffffc02077f8:	00006697          	auipc	a3,0x6
ffffffffc02077fc:	1c868693          	addi	a3,a3,456 # ffffffffc020d9c0 <etext+0x25be>
ffffffffc0207800:	00004617          	auipc	a2,0x4
ffffffffc0207804:	04060613          	addi	a2,a2,64 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207808:	06100593          	li	a1,97
ffffffffc020780c:	00006517          	auipc	a0,0x6
ffffffffc0207810:	00450513          	addi	a0,a0,4 # ffffffffc020d810 <etext+0x240e>
ffffffffc0207814:	c37f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207818:	00006697          	auipc	a3,0x6
ffffffffc020781c:	18868693          	addi	a3,a3,392 # ffffffffc020d9a0 <etext+0x259e>
ffffffffc0207820:	00004617          	auipc	a2,0x4
ffffffffc0207824:	02060613          	addi	a2,a2,32 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207828:	05c00593          	li	a1,92
ffffffffc020782c:	00006517          	auipc	a0,0x6
ffffffffc0207830:	fe450513          	addi	a0,a0,-28 # ffffffffc020d810 <etext+0x240e>
ffffffffc0207834:	c17f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207838 <__alloc_fs>:
ffffffffc0207838:	1141                	addi	sp,sp,-16
ffffffffc020783a:	e022                	sd	s0,0(sp)
ffffffffc020783c:	842a                	mv	s0,a0
ffffffffc020783e:	0d800513          	li	a0,216
ffffffffc0207842:	e406                	sd	ra,8(sp)
ffffffffc0207844:	f90fa0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0207848:	c119                	beqz	a0,ffffffffc020784e <__alloc_fs+0x16>
ffffffffc020784a:	0a852823          	sw	s0,176(a0)
ffffffffc020784e:	60a2                	ld	ra,8(sp)
ffffffffc0207850:	6402                	ld	s0,0(sp)
ffffffffc0207852:	0141                	addi	sp,sp,16
ffffffffc0207854:	8082                	ret

ffffffffc0207856 <vfs_init>:
ffffffffc0207856:	1141                	addi	sp,sp,-16
ffffffffc0207858:	4585                	li	a1,1
ffffffffc020785a:	0008e517          	auipc	a0,0x8e
ffffffffc020785e:	fa650513          	addi	a0,a0,-90 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207862:	e406                	sd	ra,8(sp)
ffffffffc0207864:	b2ffc0ef          	jal	ffffffffc0204392 <sem_init>
ffffffffc0207868:	60a2                	ld	ra,8(sp)
ffffffffc020786a:	0141                	addi	sp,sp,16
ffffffffc020786c:	a4b1                	j	ffffffffc0207ab8 <vfs_devlist_init>

ffffffffc020786e <vfs_set_bootfs>:
ffffffffc020786e:	7179                	addi	sp,sp,-48
ffffffffc0207870:	f022                	sd	s0,32(sp)
ffffffffc0207872:	f406                	sd	ra,40(sp)
ffffffffc0207874:	ec02                	sd	zero,24(sp)
ffffffffc0207876:	842a                	mv	s0,a0
ffffffffc0207878:	c515                	beqz	a0,ffffffffc02078a4 <vfs_set_bootfs+0x36>
ffffffffc020787a:	03a00593          	li	a1,58
ffffffffc020787e:	30b030ef          	jal	ffffffffc020b388 <strchr>
ffffffffc0207882:	c125                	beqz	a0,ffffffffc02078e2 <vfs_set_bootfs+0x74>
ffffffffc0207884:	00154783          	lbu	a5,1(a0)
ffffffffc0207888:	efa9                	bnez	a5,ffffffffc02078e2 <vfs_set_bootfs+0x74>
ffffffffc020788a:	8522                	mv	a0,s0
ffffffffc020788c:	163000ef          	jal	ffffffffc02081ee <vfs_chdir>
ffffffffc0207890:	c509                	beqz	a0,ffffffffc020789a <vfs_set_bootfs+0x2c>
ffffffffc0207892:	70a2                	ld	ra,40(sp)
ffffffffc0207894:	7402                	ld	s0,32(sp)
ffffffffc0207896:	6145                	addi	sp,sp,48
ffffffffc0207898:	8082                	ret
ffffffffc020789a:	0828                	addi	a0,sp,24
ffffffffc020789c:	05f000ef          	jal	ffffffffc02080fa <vfs_get_curdir>
ffffffffc02078a0:	f96d                	bnez	a0,ffffffffc0207892 <vfs_set_bootfs+0x24>
ffffffffc02078a2:	6462                	ld	s0,24(sp)
ffffffffc02078a4:	0008e517          	auipc	a0,0x8e
ffffffffc02078a8:	f5c50513          	addi	a0,a0,-164 # ffffffffc0295800 <bootfs_sem>
ffffffffc02078ac:	af1fc0ef          	jal	ffffffffc020439c <down>
ffffffffc02078b0:	0008f797          	auipc	a5,0x8f
ffffffffc02078b4:	0407b783          	ld	a5,64(a5) # ffffffffc02968f0 <bootfs_node>
ffffffffc02078b8:	0008e517          	auipc	a0,0x8e
ffffffffc02078bc:	f4850513          	addi	a0,a0,-184 # ffffffffc0295800 <bootfs_sem>
ffffffffc02078c0:	0008f717          	auipc	a4,0x8f
ffffffffc02078c4:	02873823          	sd	s0,48(a4) # ffffffffc02968f0 <bootfs_node>
ffffffffc02078c8:	e43e                	sd	a5,8(sp)
ffffffffc02078ca:	acffc0ef          	jal	ffffffffc0204398 <up>
ffffffffc02078ce:	67a2                	ld	a5,8(sp)
ffffffffc02078d0:	c781                	beqz	a5,ffffffffc02078d8 <vfs_set_bootfs+0x6a>
ffffffffc02078d2:	853e                	mv	a0,a5
ffffffffc02078d4:	e33ff0ef          	jal	ffffffffc0207706 <inode_ref_dec>
ffffffffc02078d8:	70a2                	ld	ra,40(sp)
ffffffffc02078da:	7402                	ld	s0,32(sp)
ffffffffc02078dc:	4501                	li	a0,0
ffffffffc02078de:	6145                	addi	sp,sp,48
ffffffffc02078e0:	8082                	ret
ffffffffc02078e2:	5575                	li	a0,-3
ffffffffc02078e4:	b77d                	j	ffffffffc0207892 <vfs_set_bootfs+0x24>

ffffffffc02078e6 <vfs_get_bootfs>:
ffffffffc02078e6:	1101                	addi	sp,sp,-32
ffffffffc02078e8:	e426                	sd	s1,8(sp)
ffffffffc02078ea:	0008f497          	auipc	s1,0x8f
ffffffffc02078ee:	00648493          	addi	s1,s1,6 # ffffffffc02968f0 <bootfs_node>
ffffffffc02078f2:	609c                	ld	a5,0(s1)
ffffffffc02078f4:	ec06                	sd	ra,24(sp)
ffffffffc02078f6:	c3b1                	beqz	a5,ffffffffc020793a <vfs_get_bootfs+0x54>
ffffffffc02078f8:	e822                	sd	s0,16(sp)
ffffffffc02078fa:	842a                	mv	s0,a0
ffffffffc02078fc:	0008e517          	auipc	a0,0x8e
ffffffffc0207900:	f0450513          	addi	a0,a0,-252 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207904:	a99fc0ef          	jal	ffffffffc020439c <down>
ffffffffc0207908:	6084                	ld	s1,0(s1)
ffffffffc020790a:	c08d                	beqz	s1,ffffffffc020792c <vfs_get_bootfs+0x46>
ffffffffc020790c:	8526                	mv	a0,s1
ffffffffc020790e:	d2bff0ef          	jal	ffffffffc0207638 <inode_ref_inc>
ffffffffc0207912:	0008e517          	auipc	a0,0x8e
ffffffffc0207916:	eee50513          	addi	a0,a0,-274 # ffffffffc0295800 <bootfs_sem>
ffffffffc020791a:	a7ffc0ef          	jal	ffffffffc0204398 <up>
ffffffffc020791e:	60e2                	ld	ra,24(sp)
ffffffffc0207920:	e004                	sd	s1,0(s0)
ffffffffc0207922:	6442                	ld	s0,16(sp)
ffffffffc0207924:	64a2                	ld	s1,8(sp)
ffffffffc0207926:	4501                	li	a0,0
ffffffffc0207928:	6105                	addi	sp,sp,32
ffffffffc020792a:	8082                	ret
ffffffffc020792c:	0008e517          	auipc	a0,0x8e
ffffffffc0207930:	ed450513          	addi	a0,a0,-300 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207934:	a65fc0ef          	jal	ffffffffc0204398 <up>
ffffffffc0207938:	6442                	ld	s0,16(sp)
ffffffffc020793a:	60e2                	ld	ra,24(sp)
ffffffffc020793c:	64a2                	ld	s1,8(sp)
ffffffffc020793e:	5541                	li	a0,-16
ffffffffc0207940:	6105                	addi	sp,sp,32
ffffffffc0207942:	8082                	ret

ffffffffc0207944 <vfs_do_add>:
ffffffffc0207944:	7139                	addi	sp,sp,-64
ffffffffc0207946:	fc06                	sd	ra,56(sp)
ffffffffc0207948:	f822                	sd	s0,48(sp)
ffffffffc020794a:	e852                	sd	s4,16(sp)
ffffffffc020794c:	e456                	sd	s5,8(sp)
ffffffffc020794e:	e05a                	sd	s6,0(sp)
ffffffffc0207950:	10050f63          	beqz	a0,ffffffffc0207a6e <vfs_do_add+0x12a>
ffffffffc0207954:	00d5e7b3          	or	a5,a1,a3
ffffffffc0207958:	842a                	mv	s0,a0
ffffffffc020795a:	8a2e                	mv	s4,a1
ffffffffc020795c:	8b32                	mv	s6,a2
ffffffffc020795e:	8ab6                	mv	s5,a3
ffffffffc0207960:	cb89                	beqz	a5,ffffffffc0207972 <vfs_do_add+0x2e>
ffffffffc0207962:	0e058363          	beqz	a1,ffffffffc0207a48 <vfs_do_add+0x104>
ffffffffc0207966:	4db8                	lw	a4,88(a1)
ffffffffc0207968:	6785                	lui	a5,0x1
ffffffffc020796a:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc020796e:	0cf71d63          	bne	a4,a5,ffffffffc0207a48 <vfs_do_add+0x104>
ffffffffc0207972:	8522                	mv	a0,s0
ffffffffc0207974:	173030ef          	jal	ffffffffc020b2e6 <strlen>
ffffffffc0207978:	47fd                	li	a5,31
ffffffffc020797a:	0ca7e263          	bltu	a5,a0,ffffffffc0207a3e <vfs_do_add+0xfa>
ffffffffc020797e:	8522                	mv	a0,s0
ffffffffc0207980:	f426                	sd	s1,40(sp)
ffffffffc0207982:	871f80ef          	jal	ffffffffc02001f2 <strdup>
ffffffffc0207986:	84aa                	mv	s1,a0
ffffffffc0207988:	cd4d                	beqz	a0,ffffffffc0207a42 <vfs_do_add+0xfe>
ffffffffc020798a:	03000513          	li	a0,48
ffffffffc020798e:	ec4e                	sd	s3,24(sp)
ffffffffc0207990:	e44fa0ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0207994:	89aa                	mv	s3,a0
ffffffffc0207996:	c935                	beqz	a0,ffffffffc0207a0a <vfs_do_add+0xc6>
ffffffffc0207998:	f04a                	sd	s2,32(sp)
ffffffffc020799a:	0008e517          	auipc	a0,0x8e
ffffffffc020799e:	e7e50513          	addi	a0,a0,-386 # ffffffffc0295818 <vdev_list_sem>
ffffffffc02079a2:	0008e917          	auipc	s2,0x8e
ffffffffc02079a6:	e8e90913          	addi	s2,s2,-370 # ffffffffc0295830 <vdev_list>
ffffffffc02079aa:	9f3fc0ef          	jal	ffffffffc020439c <down>
ffffffffc02079ae:	844a                	mv	s0,s2
ffffffffc02079b0:	a039                	j	ffffffffc02079be <vfs_do_add+0x7a>
ffffffffc02079b2:	fe043503          	ld	a0,-32(s0)
ffffffffc02079b6:	85a6                	mv	a1,s1
ffffffffc02079b8:	175030ef          	jal	ffffffffc020b32c <strcmp>
ffffffffc02079bc:	c52d                	beqz	a0,ffffffffc0207a26 <vfs_do_add+0xe2>
ffffffffc02079be:	6400                	ld	s0,8(s0)
ffffffffc02079c0:	ff2419e3          	bne	s0,s2,ffffffffc02079b2 <vfs_do_add+0x6e>
ffffffffc02079c4:	6418                	ld	a4,8(s0)
ffffffffc02079c6:	02098793          	addi	a5,s3,32
ffffffffc02079ca:	0099b023          	sd	s1,0(s3)
ffffffffc02079ce:	0149b423          	sd	s4,8(s3)
ffffffffc02079d2:	0159bc23          	sd	s5,24(s3)
ffffffffc02079d6:	0169b823          	sd	s6,16(s3)
ffffffffc02079da:	e31c                	sd	a5,0(a4)
ffffffffc02079dc:	0289b023          	sd	s0,32(s3)
ffffffffc02079e0:	02e9b423          	sd	a4,40(s3)
ffffffffc02079e4:	0008e517          	auipc	a0,0x8e
ffffffffc02079e8:	e3450513          	addi	a0,a0,-460 # ffffffffc0295818 <vdev_list_sem>
ffffffffc02079ec:	e41c                	sd	a5,8(s0)
ffffffffc02079ee:	9abfc0ef          	jal	ffffffffc0204398 <up>
ffffffffc02079f2:	74a2                	ld	s1,40(sp)
ffffffffc02079f4:	7902                	ld	s2,32(sp)
ffffffffc02079f6:	69e2                	ld	s3,24(sp)
ffffffffc02079f8:	4401                	li	s0,0
ffffffffc02079fa:	70e2                	ld	ra,56(sp)
ffffffffc02079fc:	8522                	mv	a0,s0
ffffffffc02079fe:	7442                	ld	s0,48(sp)
ffffffffc0207a00:	6a42                	ld	s4,16(sp)
ffffffffc0207a02:	6aa2                	ld	s5,8(sp)
ffffffffc0207a04:	6b02                	ld	s6,0(sp)
ffffffffc0207a06:	6121                	addi	sp,sp,64
ffffffffc0207a08:	8082                	ret
ffffffffc0207a0a:	5471                	li	s0,-4
ffffffffc0207a0c:	8526                	mv	a0,s1
ffffffffc0207a0e:	e6cfa0ef          	jal	ffffffffc020207a <kfree>
ffffffffc0207a12:	70e2                	ld	ra,56(sp)
ffffffffc0207a14:	8522                	mv	a0,s0
ffffffffc0207a16:	7442                	ld	s0,48(sp)
ffffffffc0207a18:	74a2                	ld	s1,40(sp)
ffffffffc0207a1a:	69e2                	ld	s3,24(sp)
ffffffffc0207a1c:	6a42                	ld	s4,16(sp)
ffffffffc0207a1e:	6aa2                	ld	s5,8(sp)
ffffffffc0207a20:	6b02                	ld	s6,0(sp)
ffffffffc0207a22:	6121                	addi	sp,sp,64
ffffffffc0207a24:	8082                	ret
ffffffffc0207a26:	0008e517          	auipc	a0,0x8e
ffffffffc0207a2a:	df250513          	addi	a0,a0,-526 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207a2e:	96bfc0ef          	jal	ffffffffc0204398 <up>
ffffffffc0207a32:	854e                	mv	a0,s3
ffffffffc0207a34:	e46fa0ef          	jal	ffffffffc020207a <kfree>
ffffffffc0207a38:	5425                	li	s0,-23
ffffffffc0207a3a:	7902                	ld	s2,32(sp)
ffffffffc0207a3c:	bfc1                	j	ffffffffc0207a0c <vfs_do_add+0xc8>
ffffffffc0207a3e:	5451                	li	s0,-12
ffffffffc0207a40:	bf6d                	j	ffffffffc02079fa <vfs_do_add+0xb6>
ffffffffc0207a42:	74a2                	ld	s1,40(sp)
ffffffffc0207a44:	5471                	li	s0,-4
ffffffffc0207a46:	bf55                	j	ffffffffc02079fa <vfs_do_add+0xb6>
ffffffffc0207a48:	00006697          	auipc	a3,0x6
ffffffffc0207a4c:	01868693          	addi	a3,a3,24 # ffffffffc020da60 <etext+0x265e>
ffffffffc0207a50:	00004617          	auipc	a2,0x4
ffffffffc0207a54:	df060613          	addi	a2,a2,-528 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207a58:	08f00593          	li	a1,143
ffffffffc0207a5c:	00006517          	auipc	a0,0x6
ffffffffc0207a60:	fec50513          	addi	a0,a0,-20 # ffffffffc020da48 <etext+0x2646>
ffffffffc0207a64:	f426                	sd	s1,40(sp)
ffffffffc0207a66:	f04a                	sd	s2,32(sp)
ffffffffc0207a68:	ec4e                	sd	s3,24(sp)
ffffffffc0207a6a:	9e1f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207a6e:	00006697          	auipc	a3,0x6
ffffffffc0207a72:	fca68693          	addi	a3,a3,-54 # ffffffffc020da38 <etext+0x2636>
ffffffffc0207a76:	00004617          	auipc	a2,0x4
ffffffffc0207a7a:	dca60613          	addi	a2,a2,-566 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207a7e:	08e00593          	li	a1,142
ffffffffc0207a82:	00006517          	auipc	a0,0x6
ffffffffc0207a86:	fc650513          	addi	a0,a0,-58 # ffffffffc020da48 <etext+0x2646>
ffffffffc0207a8a:	f426                	sd	s1,40(sp)
ffffffffc0207a8c:	f04a                	sd	s2,32(sp)
ffffffffc0207a8e:	ec4e                	sd	s3,24(sp)
ffffffffc0207a90:	9bbf80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207a94 <find_mount.part.0>:
ffffffffc0207a94:	1141                	addi	sp,sp,-16
ffffffffc0207a96:	00006697          	auipc	a3,0x6
ffffffffc0207a9a:	fa268693          	addi	a3,a3,-94 # ffffffffc020da38 <etext+0x2636>
ffffffffc0207a9e:	00004617          	auipc	a2,0x4
ffffffffc0207aa2:	da260613          	addi	a2,a2,-606 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207aa6:	0cd00593          	li	a1,205
ffffffffc0207aaa:	00006517          	auipc	a0,0x6
ffffffffc0207aae:	f9e50513          	addi	a0,a0,-98 # ffffffffc020da48 <etext+0x2646>
ffffffffc0207ab2:	e406                	sd	ra,8(sp)
ffffffffc0207ab4:	997f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207ab8 <vfs_devlist_init>:
ffffffffc0207ab8:	0008e797          	auipc	a5,0x8e
ffffffffc0207abc:	d7878793          	addi	a5,a5,-648 # ffffffffc0295830 <vdev_list>
ffffffffc0207ac0:	4585                	li	a1,1
ffffffffc0207ac2:	0008e517          	auipc	a0,0x8e
ffffffffc0207ac6:	d5650513          	addi	a0,a0,-682 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207aca:	e79c                	sd	a5,8(a5)
ffffffffc0207acc:	e39c                	sd	a5,0(a5)
ffffffffc0207ace:	8c5fc06f          	j	ffffffffc0204392 <sem_init>

ffffffffc0207ad2 <vfs_cleanup>:
ffffffffc0207ad2:	1101                	addi	sp,sp,-32
ffffffffc0207ad4:	e426                	sd	s1,8(sp)
ffffffffc0207ad6:	0008e497          	auipc	s1,0x8e
ffffffffc0207ada:	d5a48493          	addi	s1,s1,-678 # ffffffffc0295830 <vdev_list>
ffffffffc0207ade:	649c                	ld	a5,8(s1)
ffffffffc0207ae0:	ec06                	sd	ra,24(sp)
ffffffffc0207ae2:	02978f63          	beq	a5,s1,ffffffffc0207b20 <vfs_cleanup+0x4e>
ffffffffc0207ae6:	0008e517          	auipc	a0,0x8e
ffffffffc0207aea:	d3250513          	addi	a0,a0,-718 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207aee:	e822                	sd	s0,16(sp)
ffffffffc0207af0:	8adfc0ef          	jal	ffffffffc020439c <down>
ffffffffc0207af4:	6480                	ld	s0,8(s1)
ffffffffc0207af6:	00940b63          	beq	s0,s1,ffffffffc0207b0c <vfs_cleanup+0x3a>
ffffffffc0207afa:	ff043783          	ld	a5,-16(s0)
ffffffffc0207afe:	853e                	mv	a0,a5
ffffffffc0207b00:	c399                	beqz	a5,ffffffffc0207b06 <vfs_cleanup+0x34>
ffffffffc0207b02:	6bfc                	ld	a5,208(a5)
ffffffffc0207b04:	9782                	jalr	a5
ffffffffc0207b06:	6400                	ld	s0,8(s0)
ffffffffc0207b08:	fe9419e3          	bne	s0,s1,ffffffffc0207afa <vfs_cleanup+0x28>
ffffffffc0207b0c:	6442                	ld	s0,16(sp)
ffffffffc0207b0e:	60e2                	ld	ra,24(sp)
ffffffffc0207b10:	64a2                	ld	s1,8(sp)
ffffffffc0207b12:	0008e517          	auipc	a0,0x8e
ffffffffc0207b16:	d0650513          	addi	a0,a0,-762 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207b1a:	6105                	addi	sp,sp,32
ffffffffc0207b1c:	87dfc06f          	j	ffffffffc0204398 <up>
ffffffffc0207b20:	60e2                	ld	ra,24(sp)
ffffffffc0207b22:	64a2                	ld	s1,8(sp)
ffffffffc0207b24:	6105                	addi	sp,sp,32
ffffffffc0207b26:	8082                	ret

ffffffffc0207b28 <vfs_get_root>:
ffffffffc0207b28:	7179                	addi	sp,sp,-48
ffffffffc0207b2a:	f406                	sd	ra,40(sp)
ffffffffc0207b2c:	c949                	beqz	a0,ffffffffc0207bbe <vfs_get_root+0x96>
ffffffffc0207b2e:	e84a                	sd	s2,16(sp)
ffffffffc0207b30:	0008e917          	auipc	s2,0x8e
ffffffffc0207b34:	d0090913          	addi	s2,s2,-768 # ffffffffc0295830 <vdev_list>
ffffffffc0207b38:	00893783          	ld	a5,8(s2)
ffffffffc0207b3c:	ec26                	sd	s1,24(sp)
ffffffffc0207b3e:	07278e63          	beq	a5,s2,ffffffffc0207bba <vfs_get_root+0x92>
ffffffffc0207b42:	e44e                	sd	s3,8(sp)
ffffffffc0207b44:	89aa                	mv	s3,a0
ffffffffc0207b46:	0008e517          	auipc	a0,0x8e
ffffffffc0207b4a:	cd250513          	addi	a0,a0,-814 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207b4e:	f022                	sd	s0,32(sp)
ffffffffc0207b50:	e052                	sd	s4,0(sp)
ffffffffc0207b52:	844a                	mv	s0,s2
ffffffffc0207b54:	8a2e                	mv	s4,a1
ffffffffc0207b56:	847fc0ef          	jal	ffffffffc020439c <down>
ffffffffc0207b5a:	a801                	j	ffffffffc0207b6a <vfs_get_root+0x42>
ffffffffc0207b5c:	fe043583          	ld	a1,-32(s0)
ffffffffc0207b60:	854e                	mv	a0,s3
ffffffffc0207b62:	7ca030ef          	jal	ffffffffc020b32c <strcmp>
ffffffffc0207b66:	84aa                	mv	s1,a0
ffffffffc0207b68:	c505                	beqz	a0,ffffffffc0207b90 <vfs_get_root+0x68>
ffffffffc0207b6a:	6400                	ld	s0,8(s0)
ffffffffc0207b6c:	ff2418e3          	bne	s0,s2,ffffffffc0207b5c <vfs_get_root+0x34>
ffffffffc0207b70:	54cd                	li	s1,-13
ffffffffc0207b72:	0008e517          	auipc	a0,0x8e
ffffffffc0207b76:	ca650513          	addi	a0,a0,-858 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207b7a:	81ffc0ef          	jal	ffffffffc0204398 <up>
ffffffffc0207b7e:	7402                	ld	s0,32(sp)
ffffffffc0207b80:	69a2                	ld	s3,8(sp)
ffffffffc0207b82:	6a02                	ld	s4,0(sp)
ffffffffc0207b84:	70a2                	ld	ra,40(sp)
ffffffffc0207b86:	6942                	ld	s2,16(sp)
ffffffffc0207b88:	8526                	mv	a0,s1
ffffffffc0207b8a:	64e2                	ld	s1,24(sp)
ffffffffc0207b8c:	6145                	addi	sp,sp,48
ffffffffc0207b8e:	8082                	ret
ffffffffc0207b90:	ff043503          	ld	a0,-16(s0)
ffffffffc0207b94:	c519                	beqz	a0,ffffffffc0207ba2 <vfs_get_root+0x7a>
ffffffffc0207b96:	617c                	ld	a5,192(a0)
ffffffffc0207b98:	9782                	jalr	a5
ffffffffc0207b9a:	c519                	beqz	a0,ffffffffc0207ba8 <vfs_get_root+0x80>
ffffffffc0207b9c:	00aa3023          	sd	a0,0(s4)
ffffffffc0207ba0:	bfc9                	j	ffffffffc0207b72 <vfs_get_root+0x4a>
ffffffffc0207ba2:	ff843783          	ld	a5,-8(s0)
ffffffffc0207ba6:	c399                	beqz	a5,ffffffffc0207bac <vfs_get_root+0x84>
ffffffffc0207ba8:	54c9                	li	s1,-14
ffffffffc0207baa:	b7e1                	j	ffffffffc0207b72 <vfs_get_root+0x4a>
ffffffffc0207bac:	fe843503          	ld	a0,-24(s0)
ffffffffc0207bb0:	a89ff0ef          	jal	ffffffffc0207638 <inode_ref_inc>
ffffffffc0207bb4:	fe843503          	ld	a0,-24(s0)
ffffffffc0207bb8:	b7cd                	j	ffffffffc0207b9a <vfs_get_root+0x72>
ffffffffc0207bba:	54cd                	li	s1,-13
ffffffffc0207bbc:	b7e1                	j	ffffffffc0207b84 <vfs_get_root+0x5c>
ffffffffc0207bbe:	00006697          	auipc	a3,0x6
ffffffffc0207bc2:	e7a68693          	addi	a3,a3,-390 # ffffffffc020da38 <etext+0x2636>
ffffffffc0207bc6:	00004617          	auipc	a2,0x4
ffffffffc0207bca:	c7a60613          	addi	a2,a2,-902 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207bce:	04500593          	li	a1,69
ffffffffc0207bd2:	00006517          	auipc	a0,0x6
ffffffffc0207bd6:	e7650513          	addi	a0,a0,-394 # ffffffffc020da48 <etext+0x2646>
ffffffffc0207bda:	f022                	sd	s0,32(sp)
ffffffffc0207bdc:	ec26                	sd	s1,24(sp)
ffffffffc0207bde:	e84a                	sd	s2,16(sp)
ffffffffc0207be0:	e44e                	sd	s3,8(sp)
ffffffffc0207be2:	e052                	sd	s4,0(sp)
ffffffffc0207be4:	867f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207be8 <vfs_get_devname>:
ffffffffc0207be8:	0008e697          	auipc	a3,0x8e
ffffffffc0207bec:	c4868693          	addi	a3,a3,-952 # ffffffffc0295830 <vdev_list>
ffffffffc0207bf0:	87b6                	mv	a5,a3
ffffffffc0207bf2:	e511                	bnez	a0,ffffffffc0207bfe <vfs_get_devname+0x16>
ffffffffc0207bf4:	a829                	j	ffffffffc0207c0e <vfs_get_devname+0x26>
ffffffffc0207bf6:	ff07b703          	ld	a4,-16(a5)
ffffffffc0207bfa:	00a70763          	beq	a4,a0,ffffffffc0207c08 <vfs_get_devname+0x20>
ffffffffc0207bfe:	679c                	ld	a5,8(a5)
ffffffffc0207c00:	fed79be3          	bne	a5,a3,ffffffffc0207bf6 <vfs_get_devname+0xe>
ffffffffc0207c04:	4501                	li	a0,0
ffffffffc0207c06:	8082                	ret
ffffffffc0207c08:	fe07b503          	ld	a0,-32(a5)
ffffffffc0207c0c:	8082                	ret
ffffffffc0207c0e:	1141                	addi	sp,sp,-16
ffffffffc0207c10:	00006697          	auipc	a3,0x6
ffffffffc0207c14:	eb068693          	addi	a3,a3,-336 # ffffffffc020dac0 <etext+0x26be>
ffffffffc0207c18:	00004617          	auipc	a2,0x4
ffffffffc0207c1c:	c2860613          	addi	a2,a2,-984 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207c20:	06a00593          	li	a1,106
ffffffffc0207c24:	00006517          	auipc	a0,0x6
ffffffffc0207c28:	e2450513          	addi	a0,a0,-476 # ffffffffc020da48 <etext+0x2646>
ffffffffc0207c2c:	e406                	sd	ra,8(sp)
ffffffffc0207c2e:	81df80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207c32 <vfs_add_dev>:
ffffffffc0207c32:	86b2                	mv	a3,a2
ffffffffc0207c34:	4601                	li	a2,0
ffffffffc0207c36:	d0fff06f          	j	ffffffffc0207944 <vfs_do_add>

ffffffffc0207c3a <vfs_mount>:
ffffffffc0207c3a:	7179                	addi	sp,sp,-48
ffffffffc0207c3c:	e84a                	sd	s2,16(sp)
ffffffffc0207c3e:	892a                	mv	s2,a0
ffffffffc0207c40:	0008e517          	auipc	a0,0x8e
ffffffffc0207c44:	bd850513          	addi	a0,a0,-1064 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207c48:	e44e                	sd	s3,8(sp)
ffffffffc0207c4a:	f406                	sd	ra,40(sp)
ffffffffc0207c4c:	f022                	sd	s0,32(sp)
ffffffffc0207c4e:	ec26                	sd	s1,24(sp)
ffffffffc0207c50:	89ae                	mv	s3,a1
ffffffffc0207c52:	f4afc0ef          	jal	ffffffffc020439c <down>
ffffffffc0207c56:	0c090a63          	beqz	s2,ffffffffc0207d2a <vfs_mount+0xf0>
ffffffffc0207c5a:	0008e497          	auipc	s1,0x8e
ffffffffc0207c5e:	bd648493          	addi	s1,s1,-1066 # ffffffffc0295830 <vdev_list>
ffffffffc0207c62:	6480                	ld	s0,8(s1)
ffffffffc0207c64:	00941663          	bne	s0,s1,ffffffffc0207c70 <vfs_mount+0x36>
ffffffffc0207c68:	a8ad                	j	ffffffffc0207ce2 <vfs_mount+0xa8>
ffffffffc0207c6a:	6400                	ld	s0,8(s0)
ffffffffc0207c6c:	06940b63          	beq	s0,s1,ffffffffc0207ce2 <vfs_mount+0xa8>
ffffffffc0207c70:	ff843783          	ld	a5,-8(s0)
ffffffffc0207c74:	dbfd                	beqz	a5,ffffffffc0207c6a <vfs_mount+0x30>
ffffffffc0207c76:	fe043503          	ld	a0,-32(s0)
ffffffffc0207c7a:	85ca                	mv	a1,s2
ffffffffc0207c7c:	6b0030ef          	jal	ffffffffc020b32c <strcmp>
ffffffffc0207c80:	f56d                	bnez	a0,ffffffffc0207c6a <vfs_mount+0x30>
ffffffffc0207c82:	ff043783          	ld	a5,-16(s0)
ffffffffc0207c86:	e3a5                	bnez	a5,ffffffffc0207ce6 <vfs_mount+0xac>
ffffffffc0207c88:	fe043783          	ld	a5,-32(s0)
ffffffffc0207c8c:	cfbd                	beqz	a5,ffffffffc0207d0a <vfs_mount+0xd0>
ffffffffc0207c8e:	ff843783          	ld	a5,-8(s0)
ffffffffc0207c92:	cfa5                	beqz	a5,ffffffffc0207d0a <vfs_mount+0xd0>
ffffffffc0207c94:	fe843503          	ld	a0,-24(s0)
ffffffffc0207c98:	c929                	beqz	a0,ffffffffc0207cea <vfs_mount+0xb0>
ffffffffc0207c9a:	4d38                	lw	a4,88(a0)
ffffffffc0207c9c:	6785                	lui	a5,0x1
ffffffffc0207c9e:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0207ca2:	04f71463          	bne	a4,a5,ffffffffc0207cea <vfs_mount+0xb0>
ffffffffc0207ca6:	ff040593          	addi	a1,s0,-16
ffffffffc0207caa:	9982                	jalr	s3
ffffffffc0207cac:	84aa                	mv	s1,a0
ffffffffc0207cae:	ed01                	bnez	a0,ffffffffc0207cc6 <vfs_mount+0x8c>
ffffffffc0207cb0:	ff043783          	ld	a5,-16(s0)
ffffffffc0207cb4:	cfad                	beqz	a5,ffffffffc0207d2e <vfs_mount+0xf4>
ffffffffc0207cb6:	fe043583          	ld	a1,-32(s0)
ffffffffc0207cba:	00006517          	auipc	a0,0x6
ffffffffc0207cbe:	e9650513          	addi	a0,a0,-362 # ffffffffc020db50 <etext+0x274e>
ffffffffc0207cc2:	ce4f80ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0207cc6:	0008e517          	auipc	a0,0x8e
ffffffffc0207cca:	b5250513          	addi	a0,a0,-1198 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207cce:	ecafc0ef          	jal	ffffffffc0204398 <up>
ffffffffc0207cd2:	70a2                	ld	ra,40(sp)
ffffffffc0207cd4:	7402                	ld	s0,32(sp)
ffffffffc0207cd6:	6942                	ld	s2,16(sp)
ffffffffc0207cd8:	69a2                	ld	s3,8(sp)
ffffffffc0207cda:	8526                	mv	a0,s1
ffffffffc0207cdc:	64e2                	ld	s1,24(sp)
ffffffffc0207cde:	6145                	addi	sp,sp,48
ffffffffc0207ce0:	8082                	ret
ffffffffc0207ce2:	54cd                	li	s1,-13
ffffffffc0207ce4:	b7cd                	j	ffffffffc0207cc6 <vfs_mount+0x8c>
ffffffffc0207ce6:	54c5                	li	s1,-15
ffffffffc0207ce8:	bff9                	j	ffffffffc0207cc6 <vfs_mount+0x8c>
ffffffffc0207cea:	00006697          	auipc	a3,0x6
ffffffffc0207cee:	e1668693          	addi	a3,a3,-490 # ffffffffc020db00 <etext+0x26fe>
ffffffffc0207cf2:	00004617          	auipc	a2,0x4
ffffffffc0207cf6:	b4e60613          	addi	a2,a2,-1202 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207cfa:	0ed00593          	li	a1,237
ffffffffc0207cfe:	00006517          	auipc	a0,0x6
ffffffffc0207d02:	d4a50513          	addi	a0,a0,-694 # ffffffffc020da48 <etext+0x2646>
ffffffffc0207d06:	f44f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207d0a:	00006697          	auipc	a3,0x6
ffffffffc0207d0e:	dc668693          	addi	a3,a3,-570 # ffffffffc020dad0 <etext+0x26ce>
ffffffffc0207d12:	00004617          	auipc	a2,0x4
ffffffffc0207d16:	b2e60613          	addi	a2,a2,-1234 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207d1a:	0eb00593          	li	a1,235
ffffffffc0207d1e:	00006517          	auipc	a0,0x6
ffffffffc0207d22:	d2a50513          	addi	a0,a0,-726 # ffffffffc020da48 <etext+0x2646>
ffffffffc0207d26:	f24f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207d2a:	d6bff0ef          	jal	ffffffffc0207a94 <find_mount.part.0>
ffffffffc0207d2e:	00006697          	auipc	a3,0x6
ffffffffc0207d32:	e0a68693          	addi	a3,a3,-502 # ffffffffc020db38 <etext+0x2736>
ffffffffc0207d36:	00004617          	auipc	a2,0x4
ffffffffc0207d3a:	b0a60613          	addi	a2,a2,-1270 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207d3e:	0ef00593          	li	a1,239
ffffffffc0207d42:	00006517          	auipc	a0,0x6
ffffffffc0207d46:	d0650513          	addi	a0,a0,-762 # ffffffffc020da48 <etext+0x2646>
ffffffffc0207d4a:	f00f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207d4e <vfs_open>:
ffffffffc0207d4e:	7159                	addi	sp,sp,-112
ffffffffc0207d50:	f486                	sd	ra,104(sp)
ffffffffc0207d52:	e0d2                	sd	s4,64(sp)
ffffffffc0207d54:	0035f793          	andi	a5,a1,3
ffffffffc0207d58:	10078363          	beqz	a5,ffffffffc0207e5e <vfs_open+0x110>
ffffffffc0207d5c:	470d                	li	a4,3
ffffffffc0207d5e:	12e78163          	beq	a5,a4,ffffffffc0207e80 <vfs_open+0x132>
ffffffffc0207d62:	f0a2                	sd	s0,96(sp)
ffffffffc0207d64:	eca6                	sd	s1,88(sp)
ffffffffc0207d66:	e8ca                	sd	s2,80(sp)
ffffffffc0207d68:	e4ce                	sd	s3,72(sp)
ffffffffc0207d6a:	fc56                	sd	s5,56(sp)
ffffffffc0207d6c:	f85a                	sd	s6,48(sp)
ffffffffc0207d6e:	0105fa13          	andi	s4,a1,16
ffffffffc0207d72:	842e                	mv	s0,a1
ffffffffc0207d74:	00447793          	andi	a5,s0,4
ffffffffc0207d78:	8b32                	mv	s6,a2
ffffffffc0207d7a:	082c                	addi	a1,sp,24
ffffffffc0207d7c:	00345613          	srli	a2,s0,0x3
ffffffffc0207d80:	8abe                	mv	s5,a5
ffffffffc0207d82:	0027d493          	srli	s1,a5,0x2
ffffffffc0207d86:	892a                	mv	s2,a0
ffffffffc0207d88:	00167993          	andi	s3,a2,1
ffffffffc0207d8c:	2ba000ef          	jal	ffffffffc0208046 <vfs_lookup>
ffffffffc0207d90:	87aa                	mv	a5,a0
ffffffffc0207d92:	c175                	beqz	a0,ffffffffc0207e76 <vfs_open+0x128>
ffffffffc0207d94:	01050713          	addi	a4,a0,16
ffffffffc0207d98:	eb45                	bnez	a4,ffffffffc0207e48 <vfs_open+0xfa>
ffffffffc0207d9a:	c4dd                	beqz	s1,ffffffffc0207e48 <vfs_open+0xfa>
ffffffffc0207d9c:	854a                	mv	a0,s2
ffffffffc0207d9e:	1010                	addi	a2,sp,32
ffffffffc0207da0:	102c                	addi	a1,sp,40
ffffffffc0207da2:	32e000ef          	jal	ffffffffc02080d0 <vfs_lookup_parent>
ffffffffc0207da6:	87aa                	mv	a5,a0
ffffffffc0207da8:	e145                	bnez	a0,ffffffffc0207e48 <vfs_open+0xfa>
ffffffffc0207daa:	7522                	ld	a0,40(sp)
ffffffffc0207dac:	14050c63          	beqz	a0,ffffffffc0207f04 <vfs_open+0x1b6>
ffffffffc0207db0:	793c                	ld	a5,112(a0)
ffffffffc0207db2:	14078963          	beqz	a5,ffffffffc0207f04 <vfs_open+0x1b6>
ffffffffc0207db6:	77bc                	ld	a5,104(a5)
ffffffffc0207db8:	14078663          	beqz	a5,ffffffffc0207f04 <vfs_open+0x1b6>
ffffffffc0207dbc:	00006597          	auipc	a1,0x6
ffffffffc0207dc0:	e0c58593          	addi	a1,a1,-500 # ffffffffc020dbc8 <etext+0x27c6>
ffffffffc0207dc4:	e42a                	sd	a0,8(sp)
ffffffffc0207dc6:	887ff0ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0207dca:	6522                	ld	a0,8(sp)
ffffffffc0207dcc:	7582                	ld	a1,32(sp)
ffffffffc0207dce:	0834                	addi	a3,sp,24
ffffffffc0207dd0:	793c                	ld	a5,112(a0)
ffffffffc0207dd2:	7522                	ld	a0,40(sp)
ffffffffc0207dd4:	864e                	mv	a2,s3
ffffffffc0207dd6:	77bc                	ld	a5,104(a5)
ffffffffc0207dd8:	9782                	jalr	a5
ffffffffc0207dda:	6562                	ld	a0,24(sp)
ffffffffc0207ddc:	10050463          	beqz	a0,ffffffffc0207ee4 <vfs_open+0x196>
ffffffffc0207de0:	793c                	ld	a5,112(a0)
ffffffffc0207de2:	c3e9                	beqz	a5,ffffffffc0207ea4 <vfs_open+0x156>
ffffffffc0207de4:	679c                	ld	a5,8(a5)
ffffffffc0207de6:	cfdd                	beqz	a5,ffffffffc0207ea4 <vfs_open+0x156>
ffffffffc0207de8:	00006597          	auipc	a1,0x6
ffffffffc0207dec:	e4858593          	addi	a1,a1,-440 # ffffffffc020dc30 <etext+0x282e>
ffffffffc0207df0:	e42a                	sd	a0,8(sp)
ffffffffc0207df2:	85bff0ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0207df6:	6522                	ld	a0,8(sp)
ffffffffc0207df8:	85a2                	mv	a1,s0
ffffffffc0207dfa:	793c                	ld	a5,112(a0)
ffffffffc0207dfc:	6562                	ld	a0,24(sp)
ffffffffc0207dfe:	679c                	ld	a5,8(a5)
ffffffffc0207e00:	9782                	jalr	a5
ffffffffc0207e02:	87aa                	mv	a5,a0
ffffffffc0207e04:	e43e                	sd	a5,8(sp)
ffffffffc0207e06:	6562                	ld	a0,24(sp)
ffffffffc0207e08:	e3d1                	bnez	a5,ffffffffc0207e8c <vfs_open+0x13e>
ffffffffc0207e0a:	839ff0ef          	jal	ffffffffc0207642 <inode_open_inc>
ffffffffc0207e0e:	014ae733          	or	a4,s5,s4
ffffffffc0207e12:	67a2                	ld	a5,8(sp)
ffffffffc0207e14:	c71d                	beqz	a4,ffffffffc0207e42 <vfs_open+0xf4>
ffffffffc0207e16:	6462                	ld	s0,24(sp)
ffffffffc0207e18:	c455                	beqz	s0,ffffffffc0207ec4 <vfs_open+0x176>
ffffffffc0207e1a:	7838                	ld	a4,112(s0)
ffffffffc0207e1c:	c745                	beqz	a4,ffffffffc0207ec4 <vfs_open+0x176>
ffffffffc0207e1e:	7338                	ld	a4,96(a4)
ffffffffc0207e20:	c355                	beqz	a4,ffffffffc0207ec4 <vfs_open+0x176>
ffffffffc0207e22:	8522                	mv	a0,s0
ffffffffc0207e24:	00006597          	auipc	a1,0x6
ffffffffc0207e28:	e6c58593          	addi	a1,a1,-404 # ffffffffc020dc90 <etext+0x288e>
ffffffffc0207e2c:	e43e                	sd	a5,8(sp)
ffffffffc0207e2e:	81fff0ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0207e32:	7838                	ld	a4,112(s0)
ffffffffc0207e34:	6562                	ld	a0,24(sp)
ffffffffc0207e36:	4581                	li	a1,0
ffffffffc0207e38:	7338                	ld	a4,96(a4)
ffffffffc0207e3a:	9702                	jalr	a4
ffffffffc0207e3c:	67a2                	ld	a5,8(sp)
ffffffffc0207e3e:	842a                	mv	s0,a0
ffffffffc0207e40:	e931                	bnez	a0,ffffffffc0207e94 <vfs_open+0x146>
ffffffffc0207e42:	6762                	ld	a4,24(sp)
ffffffffc0207e44:	00eb3023          	sd	a4,0(s6)
ffffffffc0207e48:	7406                	ld	s0,96(sp)
ffffffffc0207e4a:	64e6                	ld	s1,88(sp)
ffffffffc0207e4c:	6946                	ld	s2,80(sp)
ffffffffc0207e4e:	69a6                	ld	s3,72(sp)
ffffffffc0207e50:	7ae2                	ld	s5,56(sp)
ffffffffc0207e52:	7b42                	ld	s6,48(sp)
ffffffffc0207e54:	70a6                	ld	ra,104(sp)
ffffffffc0207e56:	6a06                	ld	s4,64(sp)
ffffffffc0207e58:	853e                	mv	a0,a5
ffffffffc0207e5a:	6165                	addi	sp,sp,112
ffffffffc0207e5c:	8082                	ret
ffffffffc0207e5e:	0105f713          	andi	a4,a1,16
ffffffffc0207e62:	8a3a                	mv	s4,a4
ffffffffc0207e64:	57f5                	li	a5,-3
ffffffffc0207e66:	f77d                	bnez	a4,ffffffffc0207e54 <vfs_open+0x106>
ffffffffc0207e68:	f0a2                	sd	s0,96(sp)
ffffffffc0207e6a:	eca6                	sd	s1,88(sp)
ffffffffc0207e6c:	e8ca                	sd	s2,80(sp)
ffffffffc0207e6e:	e4ce                	sd	s3,72(sp)
ffffffffc0207e70:	fc56                	sd	s5,56(sp)
ffffffffc0207e72:	f85a                	sd	s6,48(sp)
ffffffffc0207e74:	bdfd                	j	ffffffffc0207d72 <vfs_open+0x24>
ffffffffc0207e76:	f60982e3          	beqz	s3,ffffffffc0207dda <vfs_open+0x8c>
ffffffffc0207e7a:	d0a5                	beqz	s1,ffffffffc0207dda <vfs_open+0x8c>
ffffffffc0207e7c:	57a5                	li	a5,-23
ffffffffc0207e7e:	b7e9                	j	ffffffffc0207e48 <vfs_open+0xfa>
ffffffffc0207e80:	70a6                	ld	ra,104(sp)
ffffffffc0207e82:	57f5                	li	a5,-3
ffffffffc0207e84:	6a06                	ld	s4,64(sp)
ffffffffc0207e86:	853e                	mv	a0,a5
ffffffffc0207e88:	6165                	addi	sp,sp,112
ffffffffc0207e8a:	8082                	ret
ffffffffc0207e8c:	87bff0ef          	jal	ffffffffc0207706 <inode_ref_dec>
ffffffffc0207e90:	67a2                	ld	a5,8(sp)
ffffffffc0207e92:	bf5d                	j	ffffffffc0207e48 <vfs_open+0xfa>
ffffffffc0207e94:	6562                	ld	a0,24(sp)
ffffffffc0207e96:	90dff0ef          	jal	ffffffffc02077a2 <inode_open_dec>
ffffffffc0207e9a:	6562                	ld	a0,24(sp)
ffffffffc0207e9c:	86bff0ef          	jal	ffffffffc0207706 <inode_ref_dec>
ffffffffc0207ea0:	87a2                	mv	a5,s0
ffffffffc0207ea2:	b75d                	j	ffffffffc0207e48 <vfs_open+0xfa>
ffffffffc0207ea4:	00006697          	auipc	a3,0x6
ffffffffc0207ea8:	d3c68693          	addi	a3,a3,-708 # ffffffffc020dbe0 <etext+0x27de>
ffffffffc0207eac:	00004617          	auipc	a2,0x4
ffffffffc0207eb0:	99460613          	addi	a2,a2,-1644 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207eb4:	03300593          	li	a1,51
ffffffffc0207eb8:	00006517          	auipc	a0,0x6
ffffffffc0207ebc:	cf850513          	addi	a0,a0,-776 # ffffffffc020dbb0 <etext+0x27ae>
ffffffffc0207ec0:	d8af80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207ec4:	00006697          	auipc	a3,0x6
ffffffffc0207ec8:	d7468693          	addi	a3,a3,-652 # ffffffffc020dc38 <etext+0x2836>
ffffffffc0207ecc:	00004617          	auipc	a2,0x4
ffffffffc0207ed0:	97460613          	addi	a2,a2,-1676 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207ed4:	03a00593          	li	a1,58
ffffffffc0207ed8:	00006517          	auipc	a0,0x6
ffffffffc0207edc:	cd850513          	addi	a0,a0,-808 # ffffffffc020dbb0 <etext+0x27ae>
ffffffffc0207ee0:	d6af80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207ee4:	00006697          	auipc	a3,0x6
ffffffffc0207ee8:	cec68693          	addi	a3,a3,-788 # ffffffffc020dbd0 <etext+0x27ce>
ffffffffc0207eec:	00004617          	auipc	a2,0x4
ffffffffc0207ef0:	95460613          	addi	a2,a2,-1708 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207ef4:	03100593          	li	a1,49
ffffffffc0207ef8:	00006517          	auipc	a0,0x6
ffffffffc0207efc:	cb850513          	addi	a0,a0,-840 # ffffffffc020dbb0 <etext+0x27ae>
ffffffffc0207f00:	d4af80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207f04:	00006697          	auipc	a3,0x6
ffffffffc0207f08:	c5c68693          	addi	a3,a3,-932 # ffffffffc020db60 <etext+0x275e>
ffffffffc0207f0c:	00004617          	auipc	a2,0x4
ffffffffc0207f10:	93460613          	addi	a2,a2,-1740 # ffffffffc020b840 <etext+0x43e>
ffffffffc0207f14:	02c00593          	li	a1,44
ffffffffc0207f18:	00006517          	auipc	a0,0x6
ffffffffc0207f1c:	c9850513          	addi	a0,a0,-872 # ffffffffc020dbb0 <etext+0x27ae>
ffffffffc0207f20:	d2af80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207f24 <vfs_close>:
ffffffffc0207f24:	1141                	addi	sp,sp,-16
ffffffffc0207f26:	e406                	sd	ra,8(sp)
ffffffffc0207f28:	e022                	sd	s0,0(sp)
ffffffffc0207f2a:	842a                	mv	s0,a0
ffffffffc0207f2c:	877ff0ef          	jal	ffffffffc02077a2 <inode_open_dec>
ffffffffc0207f30:	8522                	mv	a0,s0
ffffffffc0207f32:	fd4ff0ef          	jal	ffffffffc0207706 <inode_ref_dec>
ffffffffc0207f36:	60a2                	ld	ra,8(sp)
ffffffffc0207f38:	6402                	ld	s0,0(sp)
ffffffffc0207f3a:	4501                	li	a0,0
ffffffffc0207f3c:	0141                	addi	sp,sp,16
ffffffffc0207f3e:	8082                	ret

ffffffffc0207f40 <get_device>:
ffffffffc0207f40:	00054e03          	lbu	t3,0(a0)
ffffffffc0207f44:	020e0463          	beqz	t3,ffffffffc0207f6c <get_device+0x2c>
ffffffffc0207f48:	00150693          	addi	a3,a0,1
ffffffffc0207f4c:	8736                	mv	a4,a3
ffffffffc0207f4e:	87f2                	mv	a5,t3
ffffffffc0207f50:	4801                	li	a6,0
ffffffffc0207f52:	03a00893          	li	a7,58
ffffffffc0207f56:	02f00313          	li	t1,47
ffffffffc0207f5a:	01178c63          	beq	a5,a7,ffffffffc0207f72 <get_device+0x32>
ffffffffc0207f5e:	02678e63          	beq	a5,t1,ffffffffc0207f9a <get_device+0x5a>
ffffffffc0207f62:	00074783          	lbu	a5,0(a4)
ffffffffc0207f66:	0705                	addi	a4,a4,1
ffffffffc0207f68:	2805                	addiw	a6,a6,1 # fffffffffffff001 <end+0x3fd686f1>
ffffffffc0207f6a:	fbe5                	bnez	a5,ffffffffc0207f5a <get_device+0x1a>
ffffffffc0207f6c:	e188                	sd	a0,0(a1)
ffffffffc0207f6e:	8532                	mv	a0,a2
ffffffffc0207f70:	a269                	j	ffffffffc02080fa <vfs_get_curdir>
ffffffffc0207f72:	02080663          	beqz	a6,ffffffffc0207f9e <get_device+0x5e>
ffffffffc0207f76:	01050733          	add	a4,a0,a6
ffffffffc0207f7a:	010687b3          	add	a5,a3,a6
ffffffffc0207f7e:	00070023          	sb	zero,0(a4)
ffffffffc0207f82:	02f00813          	li	a6,47
ffffffffc0207f86:	86be                	mv	a3,a5
ffffffffc0207f88:	0007c703          	lbu	a4,0(a5)
ffffffffc0207f8c:	0785                	addi	a5,a5,1
ffffffffc0207f8e:	ff070ce3          	beq	a4,a6,ffffffffc0207f86 <get_device+0x46>
ffffffffc0207f92:	e194                	sd	a3,0(a1)
ffffffffc0207f94:	85b2                	mv	a1,a2
ffffffffc0207f96:	b93ff06f          	j	ffffffffc0207b28 <vfs_get_root>
ffffffffc0207f9a:	fc0819e3          	bnez	a6,ffffffffc0207f6c <get_device+0x2c>
ffffffffc0207f9e:	7139                	addi	sp,sp,-64
ffffffffc0207fa0:	f822                	sd	s0,48(sp)
ffffffffc0207fa2:	f426                	sd	s1,40(sp)
ffffffffc0207fa4:	fc06                	sd	ra,56(sp)
ffffffffc0207fa6:	02f00793          	li	a5,47
ffffffffc0207faa:	8432                	mv	s0,a2
ffffffffc0207fac:	84ae                	mv	s1,a1
ffffffffc0207fae:	04fe0563          	beq	t3,a5,ffffffffc0207ff8 <get_device+0xb8>
ffffffffc0207fb2:	03a00793          	li	a5,58
ffffffffc0207fb6:	06fe1863          	bne	t3,a5,ffffffffc0208026 <get_device+0xe6>
ffffffffc0207fba:	0828                	addi	a0,sp,24
ffffffffc0207fbc:	e436                	sd	a3,8(sp)
ffffffffc0207fbe:	13c000ef          	jal	ffffffffc02080fa <vfs_get_curdir>
ffffffffc0207fc2:	e515                	bnez	a0,ffffffffc0207fee <get_device+0xae>
ffffffffc0207fc4:	67e2                	ld	a5,24(sp)
ffffffffc0207fc6:	77a8                	ld	a0,104(a5)
ffffffffc0207fc8:	cd1d                	beqz	a0,ffffffffc0208006 <get_device+0xc6>
ffffffffc0207fca:	617c                	ld	a5,192(a0)
ffffffffc0207fcc:	9782                	jalr	a5
ffffffffc0207fce:	87aa                	mv	a5,a0
ffffffffc0207fd0:	6562                	ld	a0,24(sp)
ffffffffc0207fd2:	e01c                	sd	a5,0(s0)
ffffffffc0207fd4:	f32ff0ef          	jal	ffffffffc0207706 <inode_ref_dec>
ffffffffc0207fd8:	66a2                	ld	a3,8(sp)
ffffffffc0207fda:	02f00713          	li	a4,47
ffffffffc0207fde:	a011                	j	ffffffffc0207fe2 <get_device+0xa2>
ffffffffc0207fe0:	0685                	addi	a3,a3,1
ffffffffc0207fe2:	0006c783          	lbu	a5,0(a3)
ffffffffc0207fe6:	fee78de3          	beq	a5,a4,ffffffffc0207fe0 <get_device+0xa0>
ffffffffc0207fea:	e094                	sd	a3,0(s1)
ffffffffc0207fec:	4501                	li	a0,0
ffffffffc0207fee:	70e2                	ld	ra,56(sp)
ffffffffc0207ff0:	7442                	ld	s0,48(sp)
ffffffffc0207ff2:	74a2                	ld	s1,40(sp)
ffffffffc0207ff4:	6121                	addi	sp,sp,64
ffffffffc0207ff6:	8082                	ret
ffffffffc0207ff8:	8532                	mv	a0,a2
ffffffffc0207ffa:	e436                	sd	a3,8(sp)
ffffffffc0207ffc:	8ebff0ef          	jal	ffffffffc02078e6 <vfs_get_bootfs>
ffffffffc0208000:	66a2                	ld	a3,8(sp)
ffffffffc0208002:	dd61                	beqz	a0,ffffffffc0207fda <get_device+0x9a>
ffffffffc0208004:	b7ed                	j	ffffffffc0207fee <get_device+0xae>
ffffffffc0208006:	00006697          	auipc	a3,0x6
ffffffffc020800a:	cc268693          	addi	a3,a3,-830 # ffffffffc020dcc8 <etext+0x28c6>
ffffffffc020800e:	00004617          	auipc	a2,0x4
ffffffffc0208012:	83260613          	addi	a2,a2,-1998 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208016:	03900593          	li	a1,57
ffffffffc020801a:	00006517          	auipc	a0,0x6
ffffffffc020801e:	c9650513          	addi	a0,a0,-874 # ffffffffc020dcb0 <etext+0x28ae>
ffffffffc0208022:	c28f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208026:	00006697          	auipc	a3,0x6
ffffffffc020802a:	c7a68693          	addi	a3,a3,-902 # ffffffffc020dca0 <etext+0x289e>
ffffffffc020802e:	00004617          	auipc	a2,0x4
ffffffffc0208032:	81260613          	addi	a2,a2,-2030 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208036:	03300593          	li	a1,51
ffffffffc020803a:	00006517          	auipc	a0,0x6
ffffffffc020803e:	c7650513          	addi	a0,a0,-906 # ffffffffc020dcb0 <etext+0x28ae>
ffffffffc0208042:	c08f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208046 <vfs_lookup>:
ffffffffc0208046:	7139                	addi	sp,sp,-64
ffffffffc0208048:	f822                	sd	s0,48(sp)
ffffffffc020804a:	1030                	addi	a2,sp,40
ffffffffc020804c:	842e                	mv	s0,a1
ffffffffc020804e:	082c                	addi	a1,sp,24
ffffffffc0208050:	fc06                	sd	ra,56(sp)
ffffffffc0208052:	ec2a                	sd	a0,24(sp)
ffffffffc0208054:	eedff0ef          	jal	ffffffffc0207f40 <get_device>
ffffffffc0208058:	87aa                	mv	a5,a0
ffffffffc020805a:	e121                	bnez	a0,ffffffffc020809a <vfs_lookup+0x54>
ffffffffc020805c:	6762                	ld	a4,24(sp)
ffffffffc020805e:	7522                	ld	a0,40(sp)
ffffffffc0208060:	00074683          	lbu	a3,0(a4)
ffffffffc0208064:	c2a1                	beqz	a3,ffffffffc02080a4 <vfs_lookup+0x5e>
ffffffffc0208066:	c529                	beqz	a0,ffffffffc02080b0 <vfs_lookup+0x6a>
ffffffffc0208068:	793c                	ld	a5,112(a0)
ffffffffc020806a:	c3b9                	beqz	a5,ffffffffc02080b0 <vfs_lookup+0x6a>
ffffffffc020806c:	7bbc                	ld	a5,112(a5)
ffffffffc020806e:	c3a9                	beqz	a5,ffffffffc02080b0 <vfs_lookup+0x6a>
ffffffffc0208070:	00006597          	auipc	a1,0x6
ffffffffc0208074:	cc058593          	addi	a1,a1,-832 # ffffffffc020dd30 <etext+0x292e>
ffffffffc0208078:	e83a                	sd	a4,16(sp)
ffffffffc020807a:	e42a                	sd	a0,8(sp)
ffffffffc020807c:	dd0ff0ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0208080:	6522                	ld	a0,8(sp)
ffffffffc0208082:	65c2                	ld	a1,16(sp)
ffffffffc0208084:	8622                	mv	a2,s0
ffffffffc0208086:	793c                	ld	a5,112(a0)
ffffffffc0208088:	7522                	ld	a0,40(sp)
ffffffffc020808a:	7bbc                	ld	a5,112(a5)
ffffffffc020808c:	9782                	jalr	a5
ffffffffc020808e:	87aa                	mv	a5,a0
ffffffffc0208090:	7522                	ld	a0,40(sp)
ffffffffc0208092:	e43e                	sd	a5,8(sp)
ffffffffc0208094:	e72ff0ef          	jal	ffffffffc0207706 <inode_ref_dec>
ffffffffc0208098:	67a2                	ld	a5,8(sp)
ffffffffc020809a:	70e2                	ld	ra,56(sp)
ffffffffc020809c:	7442                	ld	s0,48(sp)
ffffffffc020809e:	853e                	mv	a0,a5
ffffffffc02080a0:	6121                	addi	sp,sp,64
ffffffffc02080a2:	8082                	ret
ffffffffc02080a4:	e008                	sd	a0,0(s0)
ffffffffc02080a6:	70e2                	ld	ra,56(sp)
ffffffffc02080a8:	7442                	ld	s0,48(sp)
ffffffffc02080aa:	853e                	mv	a0,a5
ffffffffc02080ac:	6121                	addi	sp,sp,64
ffffffffc02080ae:	8082                	ret
ffffffffc02080b0:	00006697          	auipc	a3,0x6
ffffffffc02080b4:	c3068693          	addi	a3,a3,-976 # ffffffffc020dce0 <etext+0x28de>
ffffffffc02080b8:	00003617          	auipc	a2,0x3
ffffffffc02080bc:	78860613          	addi	a2,a2,1928 # ffffffffc020b840 <etext+0x43e>
ffffffffc02080c0:	04f00593          	li	a1,79
ffffffffc02080c4:	00006517          	auipc	a0,0x6
ffffffffc02080c8:	bec50513          	addi	a0,a0,-1044 # ffffffffc020dcb0 <etext+0x28ae>
ffffffffc02080cc:	b7ef80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02080d0 <vfs_lookup_parent>:
ffffffffc02080d0:	7139                	addi	sp,sp,-64
ffffffffc02080d2:	f822                	sd	s0,48(sp)
ffffffffc02080d4:	f426                	sd	s1,40(sp)
ffffffffc02080d6:	8432                	mv	s0,a2
ffffffffc02080d8:	84ae                	mv	s1,a1
ffffffffc02080da:	0830                	addi	a2,sp,24
ffffffffc02080dc:	002c                	addi	a1,sp,8
ffffffffc02080de:	fc06                	sd	ra,56(sp)
ffffffffc02080e0:	e42a                	sd	a0,8(sp)
ffffffffc02080e2:	e5fff0ef          	jal	ffffffffc0207f40 <get_device>
ffffffffc02080e6:	e509                	bnez	a0,ffffffffc02080f0 <vfs_lookup_parent+0x20>
ffffffffc02080e8:	6722                	ld	a4,8(sp)
ffffffffc02080ea:	67e2                	ld	a5,24(sp)
ffffffffc02080ec:	e018                	sd	a4,0(s0)
ffffffffc02080ee:	e09c                	sd	a5,0(s1)
ffffffffc02080f0:	70e2                	ld	ra,56(sp)
ffffffffc02080f2:	7442                	ld	s0,48(sp)
ffffffffc02080f4:	74a2                	ld	s1,40(sp)
ffffffffc02080f6:	6121                	addi	sp,sp,64
ffffffffc02080f8:	8082                	ret

ffffffffc02080fa <vfs_get_curdir>:
ffffffffc02080fa:	0008e797          	auipc	a5,0x8e
ffffffffc02080fe:	7ce7b783          	ld	a5,1998(a5) # ffffffffc02968c8 <current>
ffffffffc0208102:	1101                	addi	sp,sp,-32
ffffffffc0208104:	e822                	sd	s0,16(sp)
ffffffffc0208106:	1487b783          	ld	a5,328(a5)
ffffffffc020810a:	ec06                	sd	ra,24(sp)
ffffffffc020810c:	6380                	ld	s0,0(a5)
ffffffffc020810e:	cc09                	beqz	s0,ffffffffc0208128 <vfs_get_curdir+0x2e>
ffffffffc0208110:	e426                	sd	s1,8(sp)
ffffffffc0208112:	84aa                	mv	s1,a0
ffffffffc0208114:	8522                	mv	a0,s0
ffffffffc0208116:	d22ff0ef          	jal	ffffffffc0207638 <inode_ref_inc>
ffffffffc020811a:	e080                	sd	s0,0(s1)
ffffffffc020811c:	64a2                	ld	s1,8(sp)
ffffffffc020811e:	4501                	li	a0,0
ffffffffc0208120:	60e2                	ld	ra,24(sp)
ffffffffc0208122:	6442                	ld	s0,16(sp)
ffffffffc0208124:	6105                	addi	sp,sp,32
ffffffffc0208126:	8082                	ret
ffffffffc0208128:	5541                	li	a0,-16
ffffffffc020812a:	bfdd                	j	ffffffffc0208120 <vfs_get_curdir+0x26>

ffffffffc020812c <vfs_set_curdir>:
ffffffffc020812c:	7139                	addi	sp,sp,-64
ffffffffc020812e:	f04a                	sd	s2,32(sp)
ffffffffc0208130:	0008e917          	auipc	s2,0x8e
ffffffffc0208134:	79890913          	addi	s2,s2,1944 # ffffffffc02968c8 <current>
ffffffffc0208138:	00093783          	ld	a5,0(s2)
ffffffffc020813c:	f822                	sd	s0,48(sp)
ffffffffc020813e:	842a                	mv	s0,a0
ffffffffc0208140:	1487b503          	ld	a0,328(a5)
ffffffffc0208144:	fc06                	sd	ra,56(sp)
ffffffffc0208146:	f426                	sd	s1,40(sp)
ffffffffc0208148:	ecbfc0ef          	jal	ffffffffc0205012 <lock_files>
ffffffffc020814c:	00093783          	ld	a5,0(s2)
ffffffffc0208150:	1487b503          	ld	a0,328(a5)
ffffffffc0208154:	611c                	ld	a5,0(a0)
ffffffffc0208156:	06f40a63          	beq	s0,a5,ffffffffc02081ca <vfs_set_curdir+0x9e>
ffffffffc020815a:	c02d                	beqz	s0,ffffffffc02081bc <vfs_set_curdir+0x90>
ffffffffc020815c:	7838                	ld	a4,112(s0)
ffffffffc020815e:	cb25                	beqz	a4,ffffffffc02081ce <vfs_set_curdir+0xa2>
ffffffffc0208160:	6b38                	ld	a4,80(a4)
ffffffffc0208162:	c735                	beqz	a4,ffffffffc02081ce <vfs_set_curdir+0xa2>
ffffffffc0208164:	00006597          	auipc	a1,0x6
ffffffffc0208168:	c3c58593          	addi	a1,a1,-964 # ffffffffc020dda0 <etext+0x299e>
ffffffffc020816c:	8522                	mv	a0,s0
ffffffffc020816e:	e43e                	sd	a5,8(sp)
ffffffffc0208170:	cdcff0ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0208174:	7838                	ld	a4,112(s0)
ffffffffc0208176:	086c                	addi	a1,sp,28
ffffffffc0208178:	8522                	mv	a0,s0
ffffffffc020817a:	6b38                	ld	a4,80(a4)
ffffffffc020817c:	9702                	jalr	a4
ffffffffc020817e:	84aa                	mv	s1,a0
ffffffffc0208180:	e909                	bnez	a0,ffffffffc0208192 <vfs_set_curdir+0x66>
ffffffffc0208182:	4772                	lw	a4,28(sp)
ffffffffc0208184:	4609                	li	a2,2
ffffffffc0208186:	54b9                	li	s1,-18
ffffffffc0208188:	40c75693          	srai	a3,a4,0xc
ffffffffc020818c:	8a9d                	andi	a3,a3,7
ffffffffc020818e:	00c68f63          	beq	a3,a2,ffffffffc02081ac <vfs_set_curdir+0x80>
ffffffffc0208192:	00093783          	ld	a5,0(s2)
ffffffffc0208196:	1487b503          	ld	a0,328(a5)
ffffffffc020819a:	e7ffc0ef          	jal	ffffffffc0205018 <unlock_files>
ffffffffc020819e:	70e2                	ld	ra,56(sp)
ffffffffc02081a0:	7442                	ld	s0,48(sp)
ffffffffc02081a2:	7902                	ld	s2,32(sp)
ffffffffc02081a4:	8526                	mv	a0,s1
ffffffffc02081a6:	74a2                	ld	s1,40(sp)
ffffffffc02081a8:	6121                	addi	sp,sp,64
ffffffffc02081aa:	8082                	ret
ffffffffc02081ac:	8522                	mv	a0,s0
ffffffffc02081ae:	c8aff0ef          	jal	ffffffffc0207638 <inode_ref_inc>
ffffffffc02081b2:	00093703          	ld	a4,0(s2)
ffffffffc02081b6:	67a2                	ld	a5,8(sp)
ffffffffc02081b8:	14873503          	ld	a0,328(a4)
ffffffffc02081bc:	e100                	sd	s0,0(a0)
ffffffffc02081be:	4481                	li	s1,0
ffffffffc02081c0:	dfe9                	beqz	a5,ffffffffc020819a <vfs_set_curdir+0x6e>
ffffffffc02081c2:	853e                	mv	a0,a5
ffffffffc02081c4:	d42ff0ef          	jal	ffffffffc0207706 <inode_ref_dec>
ffffffffc02081c8:	b7e9                	j	ffffffffc0208192 <vfs_set_curdir+0x66>
ffffffffc02081ca:	4481                	li	s1,0
ffffffffc02081cc:	b7f9                	j	ffffffffc020819a <vfs_set_curdir+0x6e>
ffffffffc02081ce:	00006697          	auipc	a3,0x6
ffffffffc02081d2:	b6a68693          	addi	a3,a3,-1174 # ffffffffc020dd38 <etext+0x2936>
ffffffffc02081d6:	00003617          	auipc	a2,0x3
ffffffffc02081da:	66a60613          	addi	a2,a2,1642 # ffffffffc020b840 <etext+0x43e>
ffffffffc02081de:	04300593          	li	a1,67
ffffffffc02081e2:	00006517          	auipc	a0,0x6
ffffffffc02081e6:	ba650513          	addi	a0,a0,-1114 # ffffffffc020dd88 <etext+0x2986>
ffffffffc02081ea:	a60f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02081ee <vfs_chdir>:
ffffffffc02081ee:	7179                	addi	sp,sp,-48
ffffffffc02081f0:	082c                	addi	a1,sp,24
ffffffffc02081f2:	f406                	sd	ra,40(sp)
ffffffffc02081f4:	e53ff0ef          	jal	ffffffffc0208046 <vfs_lookup>
ffffffffc02081f8:	87aa                	mv	a5,a0
ffffffffc02081fa:	c509                	beqz	a0,ffffffffc0208204 <vfs_chdir+0x16>
ffffffffc02081fc:	70a2                	ld	ra,40(sp)
ffffffffc02081fe:	853e                	mv	a0,a5
ffffffffc0208200:	6145                	addi	sp,sp,48
ffffffffc0208202:	8082                	ret
ffffffffc0208204:	6562                	ld	a0,24(sp)
ffffffffc0208206:	f27ff0ef          	jal	ffffffffc020812c <vfs_set_curdir>
ffffffffc020820a:	87aa                	mv	a5,a0
ffffffffc020820c:	6562                	ld	a0,24(sp)
ffffffffc020820e:	e43e                	sd	a5,8(sp)
ffffffffc0208210:	cf6ff0ef          	jal	ffffffffc0207706 <inode_ref_dec>
ffffffffc0208214:	67a2                	ld	a5,8(sp)
ffffffffc0208216:	70a2                	ld	ra,40(sp)
ffffffffc0208218:	853e                	mv	a0,a5
ffffffffc020821a:	6145                	addi	sp,sp,48
ffffffffc020821c:	8082                	ret

ffffffffc020821e <vfs_getcwd>:
ffffffffc020821e:	0008e797          	auipc	a5,0x8e
ffffffffc0208222:	6aa7b783          	ld	a5,1706(a5) # ffffffffc02968c8 <current>
ffffffffc0208226:	7179                	addi	sp,sp,-48
ffffffffc0208228:	ec26                	sd	s1,24(sp)
ffffffffc020822a:	1487b783          	ld	a5,328(a5)
ffffffffc020822e:	f406                	sd	ra,40(sp)
ffffffffc0208230:	f022                	sd	s0,32(sp)
ffffffffc0208232:	6384                	ld	s1,0(a5)
ffffffffc0208234:	c0c1                	beqz	s1,ffffffffc02082b4 <vfs_getcwd+0x96>
ffffffffc0208236:	e84a                	sd	s2,16(sp)
ffffffffc0208238:	892a                	mv	s2,a0
ffffffffc020823a:	8526                	mv	a0,s1
ffffffffc020823c:	bfcff0ef          	jal	ffffffffc0207638 <inode_ref_inc>
ffffffffc0208240:	74a8                	ld	a0,104(s1)
ffffffffc0208242:	c93d                	beqz	a0,ffffffffc02082b8 <vfs_getcwd+0x9a>
ffffffffc0208244:	9a5ff0ef          	jal	ffffffffc0207be8 <vfs_get_devname>
ffffffffc0208248:	842a                	mv	s0,a0
ffffffffc020824a:	09c030ef          	jal	ffffffffc020b2e6 <strlen>
ffffffffc020824e:	862a                	mv	a2,a0
ffffffffc0208250:	85a2                	mv	a1,s0
ffffffffc0208252:	854a                	mv	a0,s2
ffffffffc0208254:	4701                	li	a4,0
ffffffffc0208256:	4685                	li	a3,1
ffffffffc0208258:	fe5fc0ef          	jal	ffffffffc020523c <iobuf_move>
ffffffffc020825c:	842a                	mv	s0,a0
ffffffffc020825e:	c919                	beqz	a0,ffffffffc0208274 <vfs_getcwd+0x56>
ffffffffc0208260:	8526                	mv	a0,s1
ffffffffc0208262:	ca4ff0ef          	jal	ffffffffc0207706 <inode_ref_dec>
ffffffffc0208266:	6942                	ld	s2,16(sp)
ffffffffc0208268:	70a2                	ld	ra,40(sp)
ffffffffc020826a:	8522                	mv	a0,s0
ffffffffc020826c:	7402                	ld	s0,32(sp)
ffffffffc020826e:	64e2                	ld	s1,24(sp)
ffffffffc0208270:	6145                	addi	sp,sp,48
ffffffffc0208272:	8082                	ret
ffffffffc0208274:	4685                	li	a3,1
ffffffffc0208276:	03a00793          	li	a5,58
ffffffffc020827a:	8636                	mv	a2,a3
ffffffffc020827c:	4701                	li	a4,0
ffffffffc020827e:	00f10593          	addi	a1,sp,15
ffffffffc0208282:	854a                	mv	a0,s2
ffffffffc0208284:	00f107a3          	sb	a5,15(sp)
ffffffffc0208288:	fb5fc0ef          	jal	ffffffffc020523c <iobuf_move>
ffffffffc020828c:	842a                	mv	s0,a0
ffffffffc020828e:	f969                	bnez	a0,ffffffffc0208260 <vfs_getcwd+0x42>
ffffffffc0208290:	78bc                	ld	a5,112(s1)
ffffffffc0208292:	c3b9                	beqz	a5,ffffffffc02082d8 <vfs_getcwd+0xba>
ffffffffc0208294:	7f9c                	ld	a5,56(a5)
ffffffffc0208296:	c3a9                	beqz	a5,ffffffffc02082d8 <vfs_getcwd+0xba>
ffffffffc0208298:	00006597          	auipc	a1,0x6
ffffffffc020829c:	b6858593          	addi	a1,a1,-1176 # ffffffffc020de00 <etext+0x29fe>
ffffffffc02082a0:	8526                	mv	a0,s1
ffffffffc02082a2:	baaff0ef          	jal	ffffffffc020764c <inode_check>
ffffffffc02082a6:	78bc                	ld	a5,112(s1)
ffffffffc02082a8:	85ca                	mv	a1,s2
ffffffffc02082aa:	8526                	mv	a0,s1
ffffffffc02082ac:	7f9c                	ld	a5,56(a5)
ffffffffc02082ae:	9782                	jalr	a5
ffffffffc02082b0:	842a                	mv	s0,a0
ffffffffc02082b2:	b77d                	j	ffffffffc0208260 <vfs_getcwd+0x42>
ffffffffc02082b4:	5441                	li	s0,-16
ffffffffc02082b6:	bf4d                	j	ffffffffc0208268 <vfs_getcwd+0x4a>
ffffffffc02082b8:	00006697          	auipc	a3,0x6
ffffffffc02082bc:	a1068693          	addi	a3,a3,-1520 # ffffffffc020dcc8 <etext+0x28c6>
ffffffffc02082c0:	00003617          	auipc	a2,0x3
ffffffffc02082c4:	58060613          	addi	a2,a2,1408 # ffffffffc020b840 <etext+0x43e>
ffffffffc02082c8:	06e00593          	li	a1,110
ffffffffc02082cc:	00006517          	auipc	a0,0x6
ffffffffc02082d0:	abc50513          	addi	a0,a0,-1348 # ffffffffc020dd88 <etext+0x2986>
ffffffffc02082d4:	976f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02082d8:	00006697          	auipc	a3,0x6
ffffffffc02082dc:	ad068693          	addi	a3,a3,-1328 # ffffffffc020dda8 <etext+0x29a6>
ffffffffc02082e0:	00003617          	auipc	a2,0x3
ffffffffc02082e4:	56060613          	addi	a2,a2,1376 # ffffffffc020b840 <etext+0x43e>
ffffffffc02082e8:	07800593          	li	a1,120
ffffffffc02082ec:	00006517          	auipc	a0,0x6
ffffffffc02082f0:	a9c50513          	addi	a0,a0,-1380 # ffffffffc020dd88 <etext+0x2986>
ffffffffc02082f4:	956f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02082f8 <dev_lookup>:
ffffffffc02082f8:	0005c703          	lbu	a4,0(a1)
ffffffffc02082fc:	ef11                	bnez	a4,ffffffffc0208318 <dev_lookup+0x20>
ffffffffc02082fe:	1101                	addi	sp,sp,-32
ffffffffc0208300:	ec06                	sd	ra,24(sp)
ffffffffc0208302:	e032                	sd	a2,0(sp)
ffffffffc0208304:	e42a                	sd	a0,8(sp)
ffffffffc0208306:	b32ff0ef          	jal	ffffffffc0207638 <inode_ref_inc>
ffffffffc020830a:	6602                	ld	a2,0(sp)
ffffffffc020830c:	67a2                	ld	a5,8(sp)
ffffffffc020830e:	60e2                	ld	ra,24(sp)
ffffffffc0208310:	4501                	li	a0,0
ffffffffc0208312:	e21c                	sd	a5,0(a2)
ffffffffc0208314:	6105                	addi	sp,sp,32
ffffffffc0208316:	8082                	ret
ffffffffc0208318:	5541                	li	a0,-16
ffffffffc020831a:	8082                	ret

ffffffffc020831c <dev_fstat>:
ffffffffc020831c:	1101                	addi	sp,sp,-32
ffffffffc020831e:	e822                	sd	s0,16(sp)
ffffffffc0208320:	e426                	sd	s1,8(sp)
ffffffffc0208322:	842a                	mv	s0,a0
ffffffffc0208324:	84ae                	mv	s1,a1
ffffffffc0208326:	852e                	mv	a0,a1
ffffffffc0208328:	02000613          	li	a2,32
ffffffffc020832c:	4581                	li	a1,0
ffffffffc020832e:	ec06                	sd	ra,24(sp)
ffffffffc0208330:	06a030ef          	jal	ffffffffc020b39a <memset>
ffffffffc0208334:	c429                	beqz	s0,ffffffffc020837e <dev_fstat+0x62>
ffffffffc0208336:	783c                	ld	a5,112(s0)
ffffffffc0208338:	c3b9                	beqz	a5,ffffffffc020837e <dev_fstat+0x62>
ffffffffc020833a:	6bbc                	ld	a5,80(a5)
ffffffffc020833c:	c3a9                	beqz	a5,ffffffffc020837e <dev_fstat+0x62>
ffffffffc020833e:	00006597          	auipc	a1,0x6
ffffffffc0208342:	a6258593          	addi	a1,a1,-1438 # ffffffffc020dda0 <etext+0x299e>
ffffffffc0208346:	8522                	mv	a0,s0
ffffffffc0208348:	b04ff0ef          	jal	ffffffffc020764c <inode_check>
ffffffffc020834c:	783c                	ld	a5,112(s0)
ffffffffc020834e:	85a6                	mv	a1,s1
ffffffffc0208350:	8522                	mv	a0,s0
ffffffffc0208352:	6bbc                	ld	a5,80(a5)
ffffffffc0208354:	9782                	jalr	a5
ffffffffc0208356:	ed19                	bnez	a0,ffffffffc0208374 <dev_fstat+0x58>
ffffffffc0208358:	4c38                	lw	a4,88(s0)
ffffffffc020835a:	6785                	lui	a5,0x1
ffffffffc020835c:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208360:	02f71f63          	bne	a4,a5,ffffffffc020839e <dev_fstat+0x82>
ffffffffc0208364:	6018                	ld	a4,0(s0)
ffffffffc0208366:	641c                	ld	a5,8(s0)
ffffffffc0208368:	4685                	li	a3,1
ffffffffc020836a:	e898                	sd	a4,16(s1)
ffffffffc020836c:	02e787b3          	mul	a5,a5,a4
ffffffffc0208370:	e494                	sd	a3,8(s1)
ffffffffc0208372:	ec9c                	sd	a5,24(s1)
ffffffffc0208374:	60e2                	ld	ra,24(sp)
ffffffffc0208376:	6442                	ld	s0,16(sp)
ffffffffc0208378:	64a2                	ld	s1,8(sp)
ffffffffc020837a:	6105                	addi	sp,sp,32
ffffffffc020837c:	8082                	ret
ffffffffc020837e:	00006697          	auipc	a3,0x6
ffffffffc0208382:	9ba68693          	addi	a3,a3,-1606 # ffffffffc020dd38 <etext+0x2936>
ffffffffc0208386:	00003617          	auipc	a2,0x3
ffffffffc020838a:	4ba60613          	addi	a2,a2,1210 # ffffffffc020b840 <etext+0x43e>
ffffffffc020838e:	04200593          	li	a1,66
ffffffffc0208392:	00006517          	auipc	a0,0x6
ffffffffc0208396:	a7e50513          	addi	a0,a0,-1410 # ffffffffc020de10 <etext+0x2a0e>
ffffffffc020839a:	8b0f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc020839e:	00005697          	auipc	a3,0x5
ffffffffc02083a2:	76268693          	addi	a3,a3,1890 # ffffffffc020db00 <etext+0x26fe>
ffffffffc02083a6:	00003617          	auipc	a2,0x3
ffffffffc02083aa:	49a60613          	addi	a2,a2,1178 # ffffffffc020b840 <etext+0x43e>
ffffffffc02083ae:	04500593          	li	a1,69
ffffffffc02083b2:	00006517          	auipc	a0,0x6
ffffffffc02083b6:	a5e50513          	addi	a0,a0,-1442 # ffffffffc020de10 <etext+0x2a0e>
ffffffffc02083ba:	890f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02083be <dev_ioctl>:
ffffffffc02083be:	c909                	beqz	a0,ffffffffc02083d0 <dev_ioctl+0x12>
ffffffffc02083c0:	4d34                	lw	a3,88(a0)
ffffffffc02083c2:	6705                	lui	a4,0x1
ffffffffc02083c4:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02083c8:	00e69463          	bne	a3,a4,ffffffffc02083d0 <dev_ioctl+0x12>
ffffffffc02083cc:	751c                	ld	a5,40(a0)
ffffffffc02083ce:	8782                	jr	a5
ffffffffc02083d0:	1141                	addi	sp,sp,-16
ffffffffc02083d2:	00005697          	auipc	a3,0x5
ffffffffc02083d6:	72e68693          	addi	a3,a3,1838 # ffffffffc020db00 <etext+0x26fe>
ffffffffc02083da:	00003617          	auipc	a2,0x3
ffffffffc02083de:	46660613          	addi	a2,a2,1126 # ffffffffc020b840 <etext+0x43e>
ffffffffc02083e2:	03500593          	li	a1,53
ffffffffc02083e6:	00006517          	auipc	a0,0x6
ffffffffc02083ea:	a2a50513          	addi	a0,a0,-1494 # ffffffffc020de10 <etext+0x2a0e>
ffffffffc02083ee:	e406                	sd	ra,8(sp)
ffffffffc02083f0:	85af80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02083f4 <dev_tryseek>:
ffffffffc02083f4:	c51d                	beqz	a0,ffffffffc0208422 <dev_tryseek+0x2e>
ffffffffc02083f6:	4d38                	lw	a4,88(a0)
ffffffffc02083f8:	6785                	lui	a5,0x1
ffffffffc02083fa:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02083fe:	02f71263          	bne	a4,a5,ffffffffc0208422 <dev_tryseek+0x2e>
ffffffffc0208402:	611c                	ld	a5,0(a0)
ffffffffc0208404:	cf89                	beqz	a5,ffffffffc020841e <dev_tryseek+0x2a>
ffffffffc0208406:	6518                	ld	a4,8(a0)
ffffffffc0208408:	02e5f6b3          	remu	a3,a1,a4
ffffffffc020840c:	ea89                	bnez	a3,ffffffffc020841e <dev_tryseek+0x2a>
ffffffffc020840e:	0005c863          	bltz	a1,ffffffffc020841e <dev_tryseek+0x2a>
ffffffffc0208412:	02e787b3          	mul	a5,a5,a4
ffffffffc0208416:	4501                	li	a0,0
ffffffffc0208418:	00f5f363          	bgeu	a1,a5,ffffffffc020841e <dev_tryseek+0x2a>
ffffffffc020841c:	8082                	ret
ffffffffc020841e:	5575                	li	a0,-3
ffffffffc0208420:	8082                	ret
ffffffffc0208422:	1141                	addi	sp,sp,-16
ffffffffc0208424:	00005697          	auipc	a3,0x5
ffffffffc0208428:	6dc68693          	addi	a3,a3,1756 # ffffffffc020db00 <etext+0x26fe>
ffffffffc020842c:	00003617          	auipc	a2,0x3
ffffffffc0208430:	41460613          	addi	a2,a2,1044 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208434:	05f00593          	li	a1,95
ffffffffc0208438:	00006517          	auipc	a0,0x6
ffffffffc020843c:	9d850513          	addi	a0,a0,-1576 # ffffffffc020de10 <etext+0x2a0e>
ffffffffc0208440:	e406                	sd	ra,8(sp)
ffffffffc0208442:	808f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208446 <dev_gettype>:
ffffffffc0208446:	cd11                	beqz	a0,ffffffffc0208462 <dev_gettype+0x1c>
ffffffffc0208448:	4d38                	lw	a4,88(a0)
ffffffffc020844a:	6785                	lui	a5,0x1
ffffffffc020844c:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208450:	00f71963          	bne	a4,a5,ffffffffc0208462 <dev_gettype+0x1c>
ffffffffc0208454:	6118                	ld	a4,0(a0)
ffffffffc0208456:	6791                	lui	a5,0x4
ffffffffc0208458:	c311                	beqz	a4,ffffffffc020845c <dev_gettype+0x16>
ffffffffc020845a:	6795                	lui	a5,0x5
ffffffffc020845c:	c19c                	sw	a5,0(a1)
ffffffffc020845e:	4501                	li	a0,0
ffffffffc0208460:	8082                	ret
ffffffffc0208462:	1141                	addi	sp,sp,-16
ffffffffc0208464:	00005697          	auipc	a3,0x5
ffffffffc0208468:	69c68693          	addi	a3,a3,1692 # ffffffffc020db00 <etext+0x26fe>
ffffffffc020846c:	00003617          	auipc	a2,0x3
ffffffffc0208470:	3d460613          	addi	a2,a2,980 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208474:	05300593          	li	a1,83
ffffffffc0208478:	00006517          	auipc	a0,0x6
ffffffffc020847c:	99850513          	addi	a0,a0,-1640 # ffffffffc020de10 <etext+0x2a0e>
ffffffffc0208480:	e406                	sd	ra,8(sp)
ffffffffc0208482:	fc9f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208486 <dev_write>:
ffffffffc0208486:	c911                	beqz	a0,ffffffffc020849a <dev_write+0x14>
ffffffffc0208488:	4d34                	lw	a3,88(a0)
ffffffffc020848a:	6705                	lui	a4,0x1
ffffffffc020848c:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208490:	00e69563          	bne	a3,a4,ffffffffc020849a <dev_write+0x14>
ffffffffc0208494:	711c                	ld	a5,32(a0)
ffffffffc0208496:	4605                	li	a2,1
ffffffffc0208498:	8782                	jr	a5
ffffffffc020849a:	1141                	addi	sp,sp,-16
ffffffffc020849c:	00005697          	auipc	a3,0x5
ffffffffc02084a0:	66468693          	addi	a3,a3,1636 # ffffffffc020db00 <etext+0x26fe>
ffffffffc02084a4:	00003617          	auipc	a2,0x3
ffffffffc02084a8:	39c60613          	addi	a2,a2,924 # ffffffffc020b840 <etext+0x43e>
ffffffffc02084ac:	02c00593          	li	a1,44
ffffffffc02084b0:	00006517          	auipc	a0,0x6
ffffffffc02084b4:	96050513          	addi	a0,a0,-1696 # ffffffffc020de10 <etext+0x2a0e>
ffffffffc02084b8:	e406                	sd	ra,8(sp)
ffffffffc02084ba:	f91f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02084be <dev_read>:
ffffffffc02084be:	c911                	beqz	a0,ffffffffc02084d2 <dev_read+0x14>
ffffffffc02084c0:	4d34                	lw	a3,88(a0)
ffffffffc02084c2:	6705                	lui	a4,0x1
ffffffffc02084c4:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02084c8:	00e69563          	bne	a3,a4,ffffffffc02084d2 <dev_read+0x14>
ffffffffc02084cc:	711c                	ld	a5,32(a0)
ffffffffc02084ce:	4601                	li	a2,0
ffffffffc02084d0:	8782                	jr	a5
ffffffffc02084d2:	1141                	addi	sp,sp,-16
ffffffffc02084d4:	00005697          	auipc	a3,0x5
ffffffffc02084d8:	62c68693          	addi	a3,a3,1580 # ffffffffc020db00 <etext+0x26fe>
ffffffffc02084dc:	00003617          	auipc	a2,0x3
ffffffffc02084e0:	36460613          	addi	a2,a2,868 # ffffffffc020b840 <etext+0x43e>
ffffffffc02084e4:	02300593          	li	a1,35
ffffffffc02084e8:	00006517          	auipc	a0,0x6
ffffffffc02084ec:	92850513          	addi	a0,a0,-1752 # ffffffffc020de10 <etext+0x2a0e>
ffffffffc02084f0:	e406                	sd	ra,8(sp)
ffffffffc02084f2:	f59f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02084f6 <dev_close>:
ffffffffc02084f6:	c909                	beqz	a0,ffffffffc0208508 <dev_close+0x12>
ffffffffc02084f8:	4d34                	lw	a3,88(a0)
ffffffffc02084fa:	6705                	lui	a4,0x1
ffffffffc02084fc:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208500:	00e69463          	bne	a3,a4,ffffffffc0208508 <dev_close+0x12>
ffffffffc0208504:	6d1c                	ld	a5,24(a0)
ffffffffc0208506:	8782                	jr	a5
ffffffffc0208508:	1141                	addi	sp,sp,-16
ffffffffc020850a:	00005697          	auipc	a3,0x5
ffffffffc020850e:	5f668693          	addi	a3,a3,1526 # ffffffffc020db00 <etext+0x26fe>
ffffffffc0208512:	00003617          	auipc	a2,0x3
ffffffffc0208516:	32e60613          	addi	a2,a2,814 # ffffffffc020b840 <etext+0x43e>
ffffffffc020851a:	45e9                	li	a1,26
ffffffffc020851c:	00006517          	auipc	a0,0x6
ffffffffc0208520:	8f450513          	addi	a0,a0,-1804 # ffffffffc020de10 <etext+0x2a0e>
ffffffffc0208524:	e406                	sd	ra,8(sp)
ffffffffc0208526:	f25f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc020852a <dev_open>:
ffffffffc020852a:	03c5f793          	andi	a5,a1,60
ffffffffc020852e:	eb91                	bnez	a5,ffffffffc0208542 <dev_open+0x18>
ffffffffc0208530:	c919                	beqz	a0,ffffffffc0208546 <dev_open+0x1c>
ffffffffc0208532:	4d34                	lw	a3,88(a0)
ffffffffc0208534:	6785                	lui	a5,0x1
ffffffffc0208536:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc020853a:	00f69663          	bne	a3,a5,ffffffffc0208546 <dev_open+0x1c>
ffffffffc020853e:	691c                	ld	a5,16(a0)
ffffffffc0208540:	8782                	jr	a5
ffffffffc0208542:	5575                	li	a0,-3
ffffffffc0208544:	8082                	ret
ffffffffc0208546:	1141                	addi	sp,sp,-16
ffffffffc0208548:	00005697          	auipc	a3,0x5
ffffffffc020854c:	5b868693          	addi	a3,a3,1464 # ffffffffc020db00 <etext+0x26fe>
ffffffffc0208550:	00003617          	auipc	a2,0x3
ffffffffc0208554:	2f060613          	addi	a2,a2,752 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208558:	45c5                	li	a1,17
ffffffffc020855a:	00006517          	auipc	a0,0x6
ffffffffc020855e:	8b650513          	addi	a0,a0,-1866 # ffffffffc020de10 <etext+0x2a0e>
ffffffffc0208562:	e406                	sd	ra,8(sp)
ffffffffc0208564:	ee7f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208568 <dev_init>:
ffffffffc0208568:	1141                	addi	sp,sp,-16
ffffffffc020856a:	e406                	sd	ra,8(sp)
ffffffffc020856c:	544000ef          	jal	ffffffffc0208ab0 <dev_init_stdin>
ffffffffc0208570:	65c000ef          	jal	ffffffffc0208bcc <dev_init_stdout>
ffffffffc0208574:	60a2                	ld	ra,8(sp)
ffffffffc0208576:	0141                	addi	sp,sp,16
ffffffffc0208578:	ac01                	j	ffffffffc0208788 <dev_init_disk0>

ffffffffc020857a <dev_create_inode>:
ffffffffc020857a:	6505                	lui	a0,0x1
ffffffffc020857c:	1101                	addi	sp,sp,-32
ffffffffc020857e:	23450513          	addi	a0,a0,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208582:	ec06                	sd	ra,24(sp)
ffffffffc0208584:	836ff0ef          	jal	ffffffffc02075ba <__alloc_inode>
ffffffffc0208588:	87aa                	mv	a5,a0
ffffffffc020858a:	c911                	beqz	a0,ffffffffc020859e <dev_create_inode+0x24>
ffffffffc020858c:	4601                	li	a2,0
ffffffffc020858e:	00007597          	auipc	a1,0x7
ffffffffc0208592:	ca258593          	addi	a1,a1,-862 # ffffffffc020f230 <dev_node_ops>
ffffffffc0208596:	e42a                	sd	a0,8(sp)
ffffffffc0208598:	83eff0ef          	jal	ffffffffc02075d6 <inode_init>
ffffffffc020859c:	67a2                	ld	a5,8(sp)
ffffffffc020859e:	60e2                	ld	ra,24(sp)
ffffffffc02085a0:	853e                	mv	a0,a5
ffffffffc02085a2:	6105                	addi	sp,sp,32
ffffffffc02085a4:	8082                	ret

ffffffffc02085a6 <disk0_open>:
ffffffffc02085a6:	4501                	li	a0,0
ffffffffc02085a8:	8082                	ret

ffffffffc02085aa <disk0_close>:
ffffffffc02085aa:	4501                	li	a0,0
ffffffffc02085ac:	8082                	ret

ffffffffc02085ae <disk0_ioctl>:
ffffffffc02085ae:	5531                	li	a0,-20
ffffffffc02085b0:	8082                	ret

ffffffffc02085b2 <disk0_io>:
ffffffffc02085b2:	711d                	addi	sp,sp,-96
ffffffffc02085b4:	6594                	ld	a3,8(a1)
ffffffffc02085b6:	e8a2                	sd	s0,80(sp)
ffffffffc02085b8:	6d80                	ld	s0,24(a1)
ffffffffc02085ba:	6785                	lui	a5,0x1
ffffffffc02085bc:	17fd                	addi	a5,a5,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc02085be:	0086e733          	or	a4,a3,s0
ffffffffc02085c2:	ec86                	sd	ra,88(sp)
ffffffffc02085c4:	8f7d                	and	a4,a4,a5
ffffffffc02085c6:	14071663          	bnez	a4,ffffffffc0208712 <disk0_io+0x160>
ffffffffc02085ca:	e0ca                	sd	s2,64(sp)
ffffffffc02085cc:	43f6d913          	srai	s2,a3,0x3f
ffffffffc02085d0:	00f97933          	and	s2,s2,a5
ffffffffc02085d4:	9936                	add	s2,s2,a3
ffffffffc02085d6:	40c95913          	srai	s2,s2,0xc
ffffffffc02085da:	00c45793          	srli	a5,s0,0xc
ffffffffc02085de:	0127873b          	addw	a4,a5,s2
ffffffffc02085e2:	6114                	ld	a3,0(a0)
ffffffffc02085e4:	1702                	slli	a4,a4,0x20
ffffffffc02085e6:	9301                	srli	a4,a4,0x20
ffffffffc02085e8:	2901                	sext.w	s2,s2
ffffffffc02085ea:	2781                	sext.w	a5,a5
ffffffffc02085ec:	12e6e063          	bltu	a3,a4,ffffffffc020870c <disk0_io+0x15a>
ffffffffc02085f0:	e799                	bnez	a5,ffffffffc02085fe <disk0_io+0x4c>
ffffffffc02085f2:	6906                	ld	s2,64(sp)
ffffffffc02085f4:	4501                	li	a0,0
ffffffffc02085f6:	60e6                	ld	ra,88(sp)
ffffffffc02085f8:	6446                	ld	s0,80(sp)
ffffffffc02085fa:	6125                	addi	sp,sp,96
ffffffffc02085fc:	8082                	ret
ffffffffc02085fe:	0008d517          	auipc	a0,0x8d
ffffffffc0208602:	24250513          	addi	a0,a0,578 # ffffffffc0295840 <disk0_sem>
ffffffffc0208606:	e4a6                	sd	s1,72(sp)
ffffffffc0208608:	f852                	sd	s4,48(sp)
ffffffffc020860a:	f456                	sd	s5,40(sp)
ffffffffc020860c:	84b2                	mv	s1,a2
ffffffffc020860e:	8aae                	mv	s5,a1
ffffffffc0208610:	0008ea17          	auipc	s4,0x8e
ffffffffc0208614:	2e8a0a13          	addi	s4,s4,744 # ffffffffc02968f8 <disk0_buffer>
ffffffffc0208618:	d85fb0ef          	jal	ffffffffc020439c <down>
ffffffffc020861c:	000a3603          	ld	a2,0(s4)
ffffffffc0208620:	e8ad                	bnez	s1,ffffffffc0208692 <disk0_io+0xe0>
ffffffffc0208622:	e862                	sd	s8,16(sp)
ffffffffc0208624:	fc4e                	sd	s3,56(sp)
ffffffffc0208626:	ec5e                	sd	s7,24(sp)
ffffffffc0208628:	6c11                	lui	s8,0x4
ffffffffc020862a:	a029                	j	ffffffffc0208634 <disk0_io+0x82>
ffffffffc020862c:	000a3603          	ld	a2,0(s4)
ffffffffc0208630:	0129893b          	addw	s2,s3,s2
ffffffffc0208634:	84a2                	mv	s1,s0
ffffffffc0208636:	008c7363          	bgeu	s8,s0,ffffffffc020863c <disk0_io+0x8a>
ffffffffc020863a:	6491                	lui	s1,0x4
ffffffffc020863c:	00c4d993          	srli	s3,s1,0xc
ffffffffc0208640:	2981                	sext.w	s3,s3
ffffffffc0208642:	00399b9b          	slliw	s7,s3,0x3
ffffffffc0208646:	020b9693          	slli	a3,s7,0x20
ffffffffc020864a:	9281                	srli	a3,a3,0x20
ffffffffc020864c:	0039159b          	slliw	a1,s2,0x3
ffffffffc0208650:	4509                	li	a0,2
ffffffffc0208652:	c70f80ef          	jal	ffffffffc0200ac2 <ide_read_secs>
ffffffffc0208656:	e16d                	bnez	a0,ffffffffc0208738 <disk0_io+0x186>
ffffffffc0208658:	000a3583          	ld	a1,0(s4)
ffffffffc020865c:	0038                	addi	a4,sp,8
ffffffffc020865e:	4685                	li	a3,1
ffffffffc0208660:	8626                	mv	a2,s1
ffffffffc0208662:	8556                	mv	a0,s5
ffffffffc0208664:	bd9fc0ef          	jal	ffffffffc020523c <iobuf_move>
ffffffffc0208668:	67a2                	ld	a5,8(sp)
ffffffffc020866a:	0a979663          	bne	a5,s1,ffffffffc0208716 <disk0_io+0x164>
ffffffffc020866e:	03449793          	slli	a5,s1,0x34
ffffffffc0208672:	e3d5                	bnez	a5,ffffffffc0208716 <disk0_io+0x164>
ffffffffc0208674:	8c05                	sub	s0,s0,s1
ffffffffc0208676:	f85d                	bnez	s0,ffffffffc020862c <disk0_io+0x7a>
ffffffffc0208678:	79e2                	ld	s3,56(sp)
ffffffffc020867a:	6be2                	ld	s7,24(sp)
ffffffffc020867c:	6c42                	ld	s8,16(sp)
ffffffffc020867e:	0008d517          	auipc	a0,0x8d
ffffffffc0208682:	1c250513          	addi	a0,a0,450 # ffffffffc0295840 <disk0_sem>
ffffffffc0208686:	d13fb0ef          	jal	ffffffffc0204398 <up>
ffffffffc020868a:	64a6                	ld	s1,72(sp)
ffffffffc020868c:	7a42                	ld	s4,48(sp)
ffffffffc020868e:	7aa2                	ld	s5,40(sp)
ffffffffc0208690:	b78d                	j	ffffffffc02085f2 <disk0_io+0x40>
ffffffffc0208692:	f05a                	sd	s6,32(sp)
ffffffffc0208694:	a029                	j	ffffffffc020869e <disk0_io+0xec>
ffffffffc0208696:	000a3603          	ld	a2,0(s4)
ffffffffc020869a:	0124893b          	addw	s2,s1,s2
ffffffffc020869e:	85b2                	mv	a1,a2
ffffffffc02086a0:	0038                	addi	a4,sp,8
ffffffffc02086a2:	4681                	li	a3,0
ffffffffc02086a4:	6611                	lui	a2,0x4
ffffffffc02086a6:	8556                	mv	a0,s5
ffffffffc02086a8:	b95fc0ef          	jal	ffffffffc020523c <iobuf_move>
ffffffffc02086ac:	67a2                	ld	a5,8(sp)
ffffffffc02086ae:	fff78713          	addi	a4,a5,-1
ffffffffc02086b2:	02877a63          	bgeu	a4,s0,ffffffffc02086e6 <disk0_io+0x134>
ffffffffc02086b6:	03479713          	slli	a4,a5,0x34
ffffffffc02086ba:	e715                	bnez	a4,ffffffffc02086e6 <disk0_io+0x134>
ffffffffc02086bc:	83b1                	srli	a5,a5,0xc
ffffffffc02086be:	0007849b          	sext.w	s1,a5
ffffffffc02086c2:	00349b1b          	slliw	s6,s1,0x3
ffffffffc02086c6:	000a3603          	ld	a2,0(s4)
ffffffffc02086ca:	020b1693          	slli	a3,s6,0x20
ffffffffc02086ce:	9281                	srli	a3,a3,0x20
ffffffffc02086d0:	0039159b          	slliw	a1,s2,0x3
ffffffffc02086d4:	4509                	li	a0,2
ffffffffc02086d6:	c86f80ef          	jal	ffffffffc0200b5c <ide_write_secs>
ffffffffc02086da:	e151                	bnez	a0,ffffffffc020875e <disk0_io+0x1ac>
ffffffffc02086dc:	67a2                	ld	a5,8(sp)
ffffffffc02086de:	8c1d                	sub	s0,s0,a5
ffffffffc02086e0:	f85d                	bnez	s0,ffffffffc0208696 <disk0_io+0xe4>
ffffffffc02086e2:	7b02                	ld	s6,32(sp)
ffffffffc02086e4:	bf69                	j	ffffffffc020867e <disk0_io+0xcc>
ffffffffc02086e6:	00005697          	auipc	a3,0x5
ffffffffc02086ea:	74268693          	addi	a3,a3,1858 # ffffffffc020de28 <etext+0x2a26>
ffffffffc02086ee:	00003617          	auipc	a2,0x3
ffffffffc02086f2:	15260613          	addi	a2,a2,338 # ffffffffc020b840 <etext+0x43e>
ffffffffc02086f6:	05700593          	li	a1,87
ffffffffc02086fa:	00005517          	auipc	a0,0x5
ffffffffc02086fe:	76e50513          	addi	a0,a0,1902 # ffffffffc020de68 <etext+0x2a66>
ffffffffc0208702:	fc4e                	sd	s3,56(sp)
ffffffffc0208704:	ec5e                	sd	s7,24(sp)
ffffffffc0208706:	e862                	sd	s8,16(sp)
ffffffffc0208708:	d43f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020870c:	6906                	ld	s2,64(sp)
ffffffffc020870e:	5575                	li	a0,-3
ffffffffc0208710:	b5dd                	j	ffffffffc02085f6 <disk0_io+0x44>
ffffffffc0208712:	5575                	li	a0,-3
ffffffffc0208714:	b5cd                	j	ffffffffc02085f6 <disk0_io+0x44>
ffffffffc0208716:	00006697          	auipc	a3,0x6
ffffffffc020871a:	80a68693          	addi	a3,a3,-2038 # ffffffffc020df20 <etext+0x2b1e>
ffffffffc020871e:	00003617          	auipc	a2,0x3
ffffffffc0208722:	12260613          	addi	a2,a2,290 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208726:	06200593          	li	a1,98
ffffffffc020872a:	00005517          	auipc	a0,0x5
ffffffffc020872e:	73e50513          	addi	a0,a0,1854 # ffffffffc020de68 <etext+0x2a66>
ffffffffc0208732:	f05a                	sd	s6,32(sp)
ffffffffc0208734:	d17f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208738:	88aa                	mv	a7,a0
ffffffffc020873a:	885e                	mv	a6,s7
ffffffffc020873c:	87ce                	mv	a5,s3
ffffffffc020873e:	0039171b          	slliw	a4,s2,0x3
ffffffffc0208742:	86ca                	mv	a3,s2
ffffffffc0208744:	00005617          	auipc	a2,0x5
ffffffffc0208748:	79460613          	addi	a2,a2,1940 # ffffffffc020ded8 <etext+0x2ad6>
ffffffffc020874c:	02d00593          	li	a1,45
ffffffffc0208750:	00005517          	auipc	a0,0x5
ffffffffc0208754:	71850513          	addi	a0,a0,1816 # ffffffffc020de68 <etext+0x2a66>
ffffffffc0208758:	f05a                	sd	s6,32(sp)
ffffffffc020875a:	cf1f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020875e:	88aa                	mv	a7,a0
ffffffffc0208760:	885a                	mv	a6,s6
ffffffffc0208762:	87a6                	mv	a5,s1
ffffffffc0208764:	0039171b          	slliw	a4,s2,0x3
ffffffffc0208768:	86ca                	mv	a3,s2
ffffffffc020876a:	00005617          	auipc	a2,0x5
ffffffffc020876e:	71e60613          	addi	a2,a2,1822 # ffffffffc020de88 <etext+0x2a86>
ffffffffc0208772:	03700593          	li	a1,55
ffffffffc0208776:	00005517          	auipc	a0,0x5
ffffffffc020877a:	6f250513          	addi	a0,a0,1778 # ffffffffc020de68 <etext+0x2a66>
ffffffffc020877e:	fc4e                	sd	s3,56(sp)
ffffffffc0208780:	ec5e                	sd	s7,24(sp)
ffffffffc0208782:	e862                	sd	s8,16(sp)
ffffffffc0208784:	cc7f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208788 <dev_init_disk0>:
ffffffffc0208788:	1101                	addi	sp,sp,-32
ffffffffc020878a:	ec06                	sd	ra,24(sp)
ffffffffc020878c:	e822                	sd	s0,16(sp)
ffffffffc020878e:	e426                	sd	s1,8(sp)
ffffffffc0208790:	debff0ef          	jal	ffffffffc020857a <dev_create_inode>
ffffffffc0208794:	c541                	beqz	a0,ffffffffc020881c <dev_init_disk0+0x94>
ffffffffc0208796:	4d38                	lw	a4,88(a0)
ffffffffc0208798:	6785                	lui	a5,0x1
ffffffffc020879a:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc020879e:	842a                	mv	s0,a0
ffffffffc02087a0:	6485                	lui	s1,0x1
ffffffffc02087a2:	0cf71e63          	bne	a4,a5,ffffffffc020887e <dev_init_disk0+0xf6>
ffffffffc02087a6:	4509                	li	a0,2
ffffffffc02087a8:	acef80ef          	jal	ffffffffc0200a76 <ide_device_valid>
ffffffffc02087ac:	cd4d                	beqz	a0,ffffffffc0208866 <dev_init_disk0+0xde>
ffffffffc02087ae:	4509                	li	a0,2
ffffffffc02087b0:	aeaf80ef          	jal	ffffffffc0200a9a <ide_device_size>
ffffffffc02087b4:	00000797          	auipc	a5,0x0
ffffffffc02087b8:	dfa78793          	addi	a5,a5,-518 # ffffffffc02085ae <disk0_ioctl>
ffffffffc02087bc:	00000617          	auipc	a2,0x0
ffffffffc02087c0:	dea60613          	addi	a2,a2,-534 # ffffffffc02085a6 <disk0_open>
ffffffffc02087c4:	00000697          	auipc	a3,0x0
ffffffffc02087c8:	de668693          	addi	a3,a3,-538 # ffffffffc02085aa <disk0_close>
ffffffffc02087cc:	00000717          	auipc	a4,0x0
ffffffffc02087d0:	de670713          	addi	a4,a4,-538 # ffffffffc02085b2 <disk0_io>
ffffffffc02087d4:	810d                	srli	a0,a0,0x3
ffffffffc02087d6:	f41c                	sd	a5,40(s0)
ffffffffc02087d8:	e008                	sd	a0,0(s0)
ffffffffc02087da:	e810                	sd	a2,16(s0)
ffffffffc02087dc:	ec14                	sd	a3,24(s0)
ffffffffc02087de:	f018                	sd	a4,32(s0)
ffffffffc02087e0:	4585                	li	a1,1
ffffffffc02087e2:	0008d517          	auipc	a0,0x8d
ffffffffc02087e6:	05e50513          	addi	a0,a0,94 # ffffffffc0295840 <disk0_sem>
ffffffffc02087ea:	e404                	sd	s1,8(s0)
ffffffffc02087ec:	ba7fb0ef          	jal	ffffffffc0204392 <sem_init>
ffffffffc02087f0:	6511                	lui	a0,0x4
ffffffffc02087f2:	fe2f90ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc02087f6:	0008e797          	auipc	a5,0x8e
ffffffffc02087fa:	10a7b123          	sd	a0,258(a5) # ffffffffc02968f8 <disk0_buffer>
ffffffffc02087fe:	c921                	beqz	a0,ffffffffc020884e <dev_init_disk0+0xc6>
ffffffffc0208800:	85a2                	mv	a1,s0
ffffffffc0208802:	4605                	li	a2,1
ffffffffc0208804:	00005517          	auipc	a0,0x5
ffffffffc0208808:	7ac50513          	addi	a0,a0,1964 # ffffffffc020dfb0 <etext+0x2bae>
ffffffffc020880c:	c26ff0ef          	jal	ffffffffc0207c32 <vfs_add_dev>
ffffffffc0208810:	e115                	bnez	a0,ffffffffc0208834 <dev_init_disk0+0xac>
ffffffffc0208812:	60e2                	ld	ra,24(sp)
ffffffffc0208814:	6442                	ld	s0,16(sp)
ffffffffc0208816:	64a2                	ld	s1,8(sp)
ffffffffc0208818:	6105                	addi	sp,sp,32
ffffffffc020881a:	8082                	ret
ffffffffc020881c:	00005617          	auipc	a2,0x5
ffffffffc0208820:	73460613          	addi	a2,a2,1844 # ffffffffc020df50 <etext+0x2b4e>
ffffffffc0208824:	08700593          	li	a1,135
ffffffffc0208828:	00005517          	auipc	a0,0x5
ffffffffc020882c:	64050513          	addi	a0,a0,1600 # ffffffffc020de68 <etext+0x2a66>
ffffffffc0208830:	c1bf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208834:	86aa                	mv	a3,a0
ffffffffc0208836:	00005617          	auipc	a2,0x5
ffffffffc020883a:	78260613          	addi	a2,a2,1922 # ffffffffc020dfb8 <etext+0x2bb6>
ffffffffc020883e:	08d00593          	li	a1,141
ffffffffc0208842:	00005517          	auipc	a0,0x5
ffffffffc0208846:	62650513          	addi	a0,a0,1574 # ffffffffc020de68 <etext+0x2a66>
ffffffffc020884a:	c01f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020884e:	00005617          	auipc	a2,0x5
ffffffffc0208852:	74260613          	addi	a2,a2,1858 # ffffffffc020df90 <etext+0x2b8e>
ffffffffc0208856:	07f00593          	li	a1,127
ffffffffc020885a:	00005517          	auipc	a0,0x5
ffffffffc020885e:	60e50513          	addi	a0,a0,1550 # ffffffffc020de68 <etext+0x2a66>
ffffffffc0208862:	be9f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208866:	00005617          	auipc	a2,0x5
ffffffffc020886a:	70a60613          	addi	a2,a2,1802 # ffffffffc020df70 <etext+0x2b6e>
ffffffffc020886e:	07300593          	li	a1,115
ffffffffc0208872:	00005517          	auipc	a0,0x5
ffffffffc0208876:	5f650513          	addi	a0,a0,1526 # ffffffffc020de68 <etext+0x2a66>
ffffffffc020887a:	bd1f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020887e:	00005697          	auipc	a3,0x5
ffffffffc0208882:	28268693          	addi	a3,a3,642 # ffffffffc020db00 <etext+0x26fe>
ffffffffc0208886:	00003617          	auipc	a2,0x3
ffffffffc020888a:	fba60613          	addi	a2,a2,-70 # ffffffffc020b840 <etext+0x43e>
ffffffffc020888e:	08900593          	li	a1,137
ffffffffc0208892:	00005517          	auipc	a0,0x5
ffffffffc0208896:	5d650513          	addi	a0,a0,1494 # ffffffffc020de68 <etext+0x2a66>
ffffffffc020889a:	bb1f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc020889e <stdin_open>:
ffffffffc020889e:	e199                	bnez	a1,ffffffffc02088a4 <stdin_open+0x6>
ffffffffc02088a0:	4501                	li	a0,0
ffffffffc02088a2:	8082                	ret
ffffffffc02088a4:	5575                	li	a0,-3
ffffffffc02088a6:	8082                	ret

ffffffffc02088a8 <stdin_close>:
ffffffffc02088a8:	4501                	li	a0,0
ffffffffc02088aa:	8082                	ret

ffffffffc02088ac <stdin_ioctl>:
ffffffffc02088ac:	5575                	li	a0,-3
ffffffffc02088ae:	8082                	ret

ffffffffc02088b0 <stdin_io>:
ffffffffc02088b0:	14061f63          	bnez	a2,ffffffffc0208a0e <stdin_io+0x15e>
ffffffffc02088b4:	7175                	addi	sp,sp,-144
ffffffffc02088b6:	ecd6                	sd	s5,88(sp)
ffffffffc02088b8:	e8da                	sd	s6,80(sp)
ffffffffc02088ba:	e4de                	sd	s7,72(sp)
ffffffffc02088bc:	0185bb03          	ld	s6,24(a1)
ffffffffc02088c0:	0005bb83          	ld	s7,0(a1)
ffffffffc02088c4:	e506                	sd	ra,136(sp)
ffffffffc02088c6:	e122                	sd	s0,128(sp)
ffffffffc02088c8:	8aae                	mv	s5,a1
ffffffffc02088ca:	100027f3          	csrr	a5,sstatus
ffffffffc02088ce:	8b89                	andi	a5,a5,2
ffffffffc02088d0:	12079663          	bnez	a5,ffffffffc02089fc <stdin_io+0x14c>
ffffffffc02088d4:	4401                	li	s0,0
ffffffffc02088d6:	120b0a63          	beqz	s6,ffffffffc0208a0a <stdin_io+0x15a>
ffffffffc02088da:	f8ca                	sd	s2,112(sp)
ffffffffc02088dc:	0008e917          	auipc	s2,0x8e
ffffffffc02088e0:	02c90913          	addi	s2,s2,44 # ffffffffc0296908 <p_rpos>
ffffffffc02088e4:	00093783          	ld	a5,0(s2)
ffffffffc02088e8:	fca6                	sd	s1,120(sp)
ffffffffc02088ea:	6705                	lui	a4,0x1
ffffffffc02088ec:	800004b7          	lui	s1,0x80000
ffffffffc02088f0:	f4ce                	sd	s3,104(sp)
ffffffffc02088f2:	f0d2                	sd	s4,96(sp)
ffffffffc02088f4:	e0e2                	sd	s8,64(sp)
ffffffffc02088f6:	0491                	addi	s1,s1,4 # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc02088f8:	fff70c13          	addi	s8,a4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc02088fc:	4a01                	li	s4,0
ffffffffc02088fe:	0008e997          	auipc	s3,0x8e
ffffffffc0208902:	00298993          	addi	s3,s3,2 # ffffffffc0296900 <p_wpos>
ffffffffc0208906:	0009b703          	ld	a4,0(s3)
ffffffffc020890a:	02e7d763          	bge	a5,a4,ffffffffc0208938 <stdin_io+0x88>
ffffffffc020890e:	a045                	j	ffffffffc02089ae <stdin_io+0xfe>
ffffffffc0208910:	94ffe0ef          	jal	ffffffffc020725e <schedule>
ffffffffc0208914:	100027f3          	csrr	a5,sstatus
ffffffffc0208918:	8b89                	andi	a5,a5,2
ffffffffc020891a:	4401                	li	s0,0
ffffffffc020891c:	e3b1                	bnez	a5,ffffffffc0208960 <stdin_io+0xb0>
ffffffffc020891e:	0828                	addi	a0,sp,24
ffffffffc0208920:	b0dfb0ef          	jal	ffffffffc020442c <wait_in_queue>
ffffffffc0208924:	e529                	bnez	a0,ffffffffc020896e <stdin_io+0xbe>
ffffffffc0208926:	5782                	lw	a5,32(sp)
ffffffffc0208928:	04979d63          	bne	a5,s1,ffffffffc0208982 <stdin_io+0xd2>
ffffffffc020892c:	00093783          	ld	a5,0(s2)
ffffffffc0208930:	0009b703          	ld	a4,0(s3)
ffffffffc0208934:	06e7cd63          	blt	a5,a4,ffffffffc02089ae <stdin_io+0xfe>
ffffffffc0208938:	80000637          	lui	a2,0x80000
ffffffffc020893c:	0611                	addi	a2,a2,4 # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc020893e:	082c                	addi	a1,sp,24
ffffffffc0208940:	0008d517          	auipc	a0,0x8d
ffffffffc0208944:	f1850513          	addi	a0,a0,-232 # ffffffffc0295858 <__wait_queue>
ffffffffc0208948:	c11fb0ef          	jal	ffffffffc0204558 <wait_current_set>
ffffffffc020894c:	d071                	beqz	s0,ffffffffc0208910 <stdin_io+0x60>
ffffffffc020894e:	aa8f80ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc0208952:	90dfe0ef          	jal	ffffffffc020725e <schedule>
ffffffffc0208956:	100027f3          	csrr	a5,sstatus
ffffffffc020895a:	8b89                	andi	a5,a5,2
ffffffffc020895c:	4401                	li	s0,0
ffffffffc020895e:	d3e1                	beqz	a5,ffffffffc020891e <stdin_io+0x6e>
ffffffffc0208960:	a9cf80ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0208964:	0828                	addi	a0,sp,24
ffffffffc0208966:	4405                	li	s0,1
ffffffffc0208968:	ac5fb0ef          	jal	ffffffffc020442c <wait_in_queue>
ffffffffc020896c:	dd4d                	beqz	a0,ffffffffc0208926 <stdin_io+0x76>
ffffffffc020896e:	082c                	addi	a1,sp,24
ffffffffc0208970:	0008d517          	auipc	a0,0x8d
ffffffffc0208974:	ee850513          	addi	a0,a0,-280 # ffffffffc0295858 <__wait_queue>
ffffffffc0208978:	a5bfb0ef          	jal	ffffffffc02043d2 <wait_queue_del>
ffffffffc020897c:	5782                	lw	a5,32(sp)
ffffffffc020897e:	fa9787e3          	beq	a5,s1,ffffffffc020892c <stdin_io+0x7c>
ffffffffc0208982:	000a051b          	sext.w	a0,s4
ffffffffc0208986:	e42d                	bnez	s0,ffffffffc02089f0 <stdin_io+0x140>
ffffffffc0208988:	c519                	beqz	a0,ffffffffc0208996 <stdin_io+0xe6>
ffffffffc020898a:	018ab783          	ld	a5,24(s5)
ffffffffc020898e:	414787b3          	sub	a5,a5,s4
ffffffffc0208992:	00fabc23          	sd	a5,24(s5)
ffffffffc0208996:	74e6                	ld	s1,120(sp)
ffffffffc0208998:	7946                	ld	s2,112(sp)
ffffffffc020899a:	79a6                	ld	s3,104(sp)
ffffffffc020899c:	7a06                	ld	s4,96(sp)
ffffffffc020899e:	6c06                	ld	s8,64(sp)
ffffffffc02089a0:	60aa                	ld	ra,136(sp)
ffffffffc02089a2:	640a                	ld	s0,128(sp)
ffffffffc02089a4:	6ae6                	ld	s5,88(sp)
ffffffffc02089a6:	6b46                	ld	s6,80(sp)
ffffffffc02089a8:	6ba6                	ld	s7,72(sp)
ffffffffc02089aa:	6149                	addi	sp,sp,144
ffffffffc02089ac:	8082                	ret
ffffffffc02089ae:	43f7d693          	srai	a3,a5,0x3f
ffffffffc02089b2:	92d1                	srli	a3,a3,0x34
ffffffffc02089b4:	00d78733          	add	a4,a5,a3
ffffffffc02089b8:	01877733          	and	a4,a4,s8
ffffffffc02089bc:	8f15                	sub	a4,a4,a3
ffffffffc02089be:	0008d697          	auipc	a3,0x8d
ffffffffc02089c2:	eaa68693          	addi	a3,a3,-342 # ffffffffc0295868 <stdin_buffer>
ffffffffc02089c6:	9736                	add	a4,a4,a3
ffffffffc02089c8:	00074683          	lbu	a3,0(a4)
ffffffffc02089cc:	0785                	addi	a5,a5,1
ffffffffc02089ce:	014b8733          	add	a4,s7,s4
ffffffffc02089d2:	001a051b          	addiw	a0,s4,1
ffffffffc02089d6:	00f93023          	sd	a5,0(s2)
ffffffffc02089da:	00d70023          	sb	a3,0(a4)
ffffffffc02089de:	0a05                	addi	s4,s4,1
ffffffffc02089e0:	f36a63e3          	bltu	s4,s6,ffffffffc0208906 <stdin_io+0x56>
ffffffffc02089e4:	d05d                	beqz	s0,ffffffffc020898a <stdin_io+0xda>
ffffffffc02089e6:	e42a                	sd	a0,8(sp)
ffffffffc02089e8:	a0ef80ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc02089ec:	6522                	ld	a0,8(sp)
ffffffffc02089ee:	bf71                	j	ffffffffc020898a <stdin_io+0xda>
ffffffffc02089f0:	e42a                	sd	a0,8(sp)
ffffffffc02089f2:	a04f80ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc02089f6:	6522                	ld	a0,8(sp)
ffffffffc02089f8:	f949                	bnez	a0,ffffffffc020898a <stdin_io+0xda>
ffffffffc02089fa:	bf71                	j	ffffffffc0208996 <stdin_io+0xe6>
ffffffffc02089fc:	a00f80ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0208a00:	4405                	li	s0,1
ffffffffc0208a02:	ec0b1ce3          	bnez	s6,ffffffffc02088da <stdin_io+0x2a>
ffffffffc0208a06:	9f0f80ef          	jal	ffffffffc0200bf6 <intr_enable>
ffffffffc0208a0a:	4501                	li	a0,0
ffffffffc0208a0c:	bf51                	j	ffffffffc02089a0 <stdin_io+0xf0>
ffffffffc0208a0e:	5575                	li	a0,-3
ffffffffc0208a10:	8082                	ret

ffffffffc0208a12 <dev_stdin_write>:
ffffffffc0208a12:	e111                	bnez	a0,ffffffffc0208a16 <dev_stdin_write+0x4>
ffffffffc0208a14:	8082                	ret
ffffffffc0208a16:	1101                	addi	sp,sp,-32
ffffffffc0208a18:	ec06                	sd	ra,24(sp)
ffffffffc0208a1a:	e822                	sd	s0,16(sp)
ffffffffc0208a1c:	100027f3          	csrr	a5,sstatus
ffffffffc0208a20:	8b89                	andi	a5,a5,2
ffffffffc0208a22:	4401                	li	s0,0
ffffffffc0208a24:	e3c1                	bnez	a5,ffffffffc0208aa4 <dev_stdin_write+0x92>
ffffffffc0208a26:	0008e717          	auipc	a4,0x8e
ffffffffc0208a2a:	eda73703          	ld	a4,-294(a4) # ffffffffc0296900 <p_wpos>
ffffffffc0208a2e:	6585                	lui	a1,0x1
ffffffffc0208a30:	fff58613          	addi	a2,a1,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0208a34:	43f75693          	srai	a3,a4,0x3f
ffffffffc0208a38:	92d1                	srli	a3,a3,0x34
ffffffffc0208a3a:	00d707b3          	add	a5,a4,a3
ffffffffc0208a3e:	8ff1                	and	a5,a5,a2
ffffffffc0208a40:	0008e617          	auipc	a2,0x8e
ffffffffc0208a44:	ec863603          	ld	a2,-312(a2) # ffffffffc0296908 <p_rpos>
ffffffffc0208a48:	8f95                	sub	a5,a5,a3
ffffffffc0208a4a:	0008d697          	auipc	a3,0x8d
ffffffffc0208a4e:	e1e68693          	addi	a3,a3,-482 # ffffffffc0295868 <stdin_buffer>
ffffffffc0208a52:	97b6                	add	a5,a5,a3
ffffffffc0208a54:	00a78023          	sb	a0,0(a5)
ffffffffc0208a58:	40c707b3          	sub	a5,a4,a2
ffffffffc0208a5c:	00b7d763          	bge	a5,a1,ffffffffc0208a6a <dev_stdin_write+0x58>
ffffffffc0208a60:	0705                	addi	a4,a4,1
ffffffffc0208a62:	0008e797          	auipc	a5,0x8e
ffffffffc0208a66:	e8e7bf23          	sd	a4,-354(a5) # ffffffffc0296900 <p_wpos>
ffffffffc0208a6a:	0008d517          	auipc	a0,0x8d
ffffffffc0208a6e:	dee50513          	addi	a0,a0,-530 # ffffffffc0295858 <__wait_queue>
ffffffffc0208a72:	9affb0ef          	jal	ffffffffc0204420 <wait_queue_empty>
ffffffffc0208a76:	c919                	beqz	a0,ffffffffc0208a8c <dev_stdin_write+0x7a>
ffffffffc0208a78:	e409                	bnez	s0,ffffffffc0208a82 <dev_stdin_write+0x70>
ffffffffc0208a7a:	60e2                	ld	ra,24(sp)
ffffffffc0208a7c:	6442                	ld	s0,16(sp)
ffffffffc0208a7e:	6105                	addi	sp,sp,32
ffffffffc0208a80:	8082                	ret
ffffffffc0208a82:	6442                	ld	s0,16(sp)
ffffffffc0208a84:	60e2                	ld	ra,24(sp)
ffffffffc0208a86:	6105                	addi	sp,sp,32
ffffffffc0208a88:	96ef806f          	j	ffffffffc0200bf6 <intr_enable>
ffffffffc0208a8c:	800005b7          	lui	a1,0x80000
ffffffffc0208a90:	0591                	addi	a1,a1,4 # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc0208a92:	4605                	li	a2,1
ffffffffc0208a94:	0008d517          	auipc	a0,0x8d
ffffffffc0208a98:	dc450513          	addi	a0,a0,-572 # ffffffffc0295858 <__wait_queue>
ffffffffc0208a9c:	9edfb0ef          	jal	ffffffffc0204488 <wakeup_queue>
ffffffffc0208aa0:	dc69                	beqz	s0,ffffffffc0208a7a <dev_stdin_write+0x68>
ffffffffc0208aa2:	b7c5                	j	ffffffffc0208a82 <dev_stdin_write+0x70>
ffffffffc0208aa4:	e42a                	sd	a0,8(sp)
ffffffffc0208aa6:	956f80ef          	jal	ffffffffc0200bfc <intr_disable>
ffffffffc0208aaa:	6522                	ld	a0,8(sp)
ffffffffc0208aac:	4405                	li	s0,1
ffffffffc0208aae:	bfa5                	j	ffffffffc0208a26 <dev_stdin_write+0x14>

ffffffffc0208ab0 <dev_init_stdin>:
ffffffffc0208ab0:	1101                	addi	sp,sp,-32
ffffffffc0208ab2:	ec06                	sd	ra,24(sp)
ffffffffc0208ab4:	ac7ff0ef          	jal	ffffffffc020857a <dev_create_inode>
ffffffffc0208ab8:	c935                	beqz	a0,ffffffffc0208b2c <dev_init_stdin+0x7c>
ffffffffc0208aba:	4d38                	lw	a4,88(a0)
ffffffffc0208abc:	6785                	lui	a5,0x1
ffffffffc0208abe:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208ac2:	08f71e63          	bne	a4,a5,ffffffffc0208b5e <dev_init_stdin+0xae>
ffffffffc0208ac6:	4785                	li	a5,1
ffffffffc0208ac8:	e51c                	sd	a5,8(a0)
ffffffffc0208aca:	00000797          	auipc	a5,0x0
ffffffffc0208ace:	dd478793          	addi	a5,a5,-556 # ffffffffc020889e <stdin_open>
ffffffffc0208ad2:	e91c                	sd	a5,16(a0)
ffffffffc0208ad4:	00000797          	auipc	a5,0x0
ffffffffc0208ad8:	dd478793          	addi	a5,a5,-556 # ffffffffc02088a8 <stdin_close>
ffffffffc0208adc:	ed1c                	sd	a5,24(a0)
ffffffffc0208ade:	00000797          	auipc	a5,0x0
ffffffffc0208ae2:	dd278793          	addi	a5,a5,-558 # ffffffffc02088b0 <stdin_io>
ffffffffc0208ae6:	f11c                	sd	a5,32(a0)
ffffffffc0208ae8:	00000797          	auipc	a5,0x0
ffffffffc0208aec:	dc478793          	addi	a5,a5,-572 # ffffffffc02088ac <stdin_ioctl>
ffffffffc0208af0:	f51c                	sd	a5,40(a0)
ffffffffc0208af2:	00053023          	sd	zero,0(a0)
ffffffffc0208af6:	e42a                	sd	a0,8(sp)
ffffffffc0208af8:	0008d517          	auipc	a0,0x8d
ffffffffc0208afc:	d6050513          	addi	a0,a0,-672 # ffffffffc0295858 <__wait_queue>
ffffffffc0208b00:	0008e797          	auipc	a5,0x8e
ffffffffc0208b04:	e007b023          	sd	zero,-512(a5) # ffffffffc0296900 <p_wpos>
ffffffffc0208b08:	0008e797          	auipc	a5,0x8e
ffffffffc0208b0c:	e007b023          	sd	zero,-512(a5) # ffffffffc0296908 <p_rpos>
ffffffffc0208b10:	8bdfb0ef          	jal	ffffffffc02043cc <wait_queue_init>
ffffffffc0208b14:	65a2                	ld	a1,8(sp)
ffffffffc0208b16:	4601                	li	a2,0
ffffffffc0208b18:	00005517          	auipc	a0,0x5
ffffffffc0208b1c:	50050513          	addi	a0,a0,1280 # ffffffffc020e018 <etext+0x2c16>
ffffffffc0208b20:	912ff0ef          	jal	ffffffffc0207c32 <vfs_add_dev>
ffffffffc0208b24:	e105                	bnez	a0,ffffffffc0208b44 <dev_init_stdin+0x94>
ffffffffc0208b26:	60e2                	ld	ra,24(sp)
ffffffffc0208b28:	6105                	addi	sp,sp,32
ffffffffc0208b2a:	8082                	ret
ffffffffc0208b2c:	00005617          	auipc	a2,0x5
ffffffffc0208b30:	4ac60613          	addi	a2,a2,1196 # ffffffffc020dfd8 <etext+0x2bd6>
ffffffffc0208b34:	07500593          	li	a1,117
ffffffffc0208b38:	00005517          	auipc	a0,0x5
ffffffffc0208b3c:	4c050513          	addi	a0,a0,1216 # ffffffffc020dff8 <etext+0x2bf6>
ffffffffc0208b40:	90bf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208b44:	86aa                	mv	a3,a0
ffffffffc0208b46:	00005617          	auipc	a2,0x5
ffffffffc0208b4a:	4da60613          	addi	a2,a2,1242 # ffffffffc020e020 <etext+0x2c1e>
ffffffffc0208b4e:	07b00593          	li	a1,123
ffffffffc0208b52:	00005517          	auipc	a0,0x5
ffffffffc0208b56:	4a650513          	addi	a0,a0,1190 # ffffffffc020dff8 <etext+0x2bf6>
ffffffffc0208b5a:	8f1f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208b5e:	00005697          	auipc	a3,0x5
ffffffffc0208b62:	fa268693          	addi	a3,a3,-94 # ffffffffc020db00 <etext+0x26fe>
ffffffffc0208b66:	00003617          	auipc	a2,0x3
ffffffffc0208b6a:	cda60613          	addi	a2,a2,-806 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208b6e:	07700593          	li	a1,119
ffffffffc0208b72:	00005517          	auipc	a0,0x5
ffffffffc0208b76:	48650513          	addi	a0,a0,1158 # ffffffffc020dff8 <etext+0x2bf6>
ffffffffc0208b7a:	8d1f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208b7e <stdout_open>:
ffffffffc0208b7e:	4785                	li	a5,1
ffffffffc0208b80:	00f59463          	bne	a1,a5,ffffffffc0208b88 <stdout_open+0xa>
ffffffffc0208b84:	4501                	li	a0,0
ffffffffc0208b86:	8082                	ret
ffffffffc0208b88:	5575                	li	a0,-3
ffffffffc0208b8a:	8082                	ret

ffffffffc0208b8c <stdout_close>:
ffffffffc0208b8c:	4501                	li	a0,0
ffffffffc0208b8e:	8082                	ret

ffffffffc0208b90 <stdout_ioctl>:
ffffffffc0208b90:	5575                	li	a0,-3
ffffffffc0208b92:	8082                	ret

ffffffffc0208b94 <stdout_io>:
ffffffffc0208b94:	ca15                	beqz	a2,ffffffffc0208bc8 <stdout_io+0x34>
ffffffffc0208b96:	6d9c                	ld	a5,24(a1)
ffffffffc0208b98:	c795                	beqz	a5,ffffffffc0208bc4 <stdout_io+0x30>
ffffffffc0208b9a:	1101                	addi	sp,sp,-32
ffffffffc0208b9c:	e822                	sd	s0,16(sp)
ffffffffc0208b9e:	6180                	ld	s0,0(a1)
ffffffffc0208ba0:	e426                	sd	s1,8(sp)
ffffffffc0208ba2:	ec06                	sd	ra,24(sp)
ffffffffc0208ba4:	84ae                	mv	s1,a1
ffffffffc0208ba6:	00044503          	lbu	a0,0(s0)
ffffffffc0208baa:	0405                	addi	s0,s0,1
ffffffffc0208bac:	e34f70ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc0208bb0:	6c9c                	ld	a5,24(s1)
ffffffffc0208bb2:	17fd                	addi	a5,a5,-1
ffffffffc0208bb4:	ec9c                	sd	a5,24(s1)
ffffffffc0208bb6:	fbe5                	bnez	a5,ffffffffc0208ba6 <stdout_io+0x12>
ffffffffc0208bb8:	60e2                	ld	ra,24(sp)
ffffffffc0208bba:	6442                	ld	s0,16(sp)
ffffffffc0208bbc:	64a2                	ld	s1,8(sp)
ffffffffc0208bbe:	4501                	li	a0,0
ffffffffc0208bc0:	6105                	addi	sp,sp,32
ffffffffc0208bc2:	8082                	ret
ffffffffc0208bc4:	4501                	li	a0,0
ffffffffc0208bc6:	8082                	ret
ffffffffc0208bc8:	5575                	li	a0,-3
ffffffffc0208bca:	8082                	ret

ffffffffc0208bcc <dev_init_stdout>:
ffffffffc0208bcc:	1141                	addi	sp,sp,-16
ffffffffc0208bce:	e406                	sd	ra,8(sp)
ffffffffc0208bd0:	9abff0ef          	jal	ffffffffc020857a <dev_create_inode>
ffffffffc0208bd4:	c939                	beqz	a0,ffffffffc0208c2a <dev_init_stdout+0x5e>
ffffffffc0208bd6:	4d38                	lw	a4,88(a0)
ffffffffc0208bd8:	6785                	lui	a5,0x1
ffffffffc0208bda:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208bde:	06f71f63          	bne	a4,a5,ffffffffc0208c5c <dev_init_stdout+0x90>
ffffffffc0208be2:	4785                	li	a5,1
ffffffffc0208be4:	e51c                	sd	a5,8(a0)
ffffffffc0208be6:	00000797          	auipc	a5,0x0
ffffffffc0208bea:	f9878793          	addi	a5,a5,-104 # ffffffffc0208b7e <stdout_open>
ffffffffc0208bee:	e91c                	sd	a5,16(a0)
ffffffffc0208bf0:	00000797          	auipc	a5,0x0
ffffffffc0208bf4:	f9c78793          	addi	a5,a5,-100 # ffffffffc0208b8c <stdout_close>
ffffffffc0208bf8:	ed1c                	sd	a5,24(a0)
ffffffffc0208bfa:	00000797          	auipc	a5,0x0
ffffffffc0208bfe:	f9a78793          	addi	a5,a5,-102 # ffffffffc0208b94 <stdout_io>
ffffffffc0208c02:	f11c                	sd	a5,32(a0)
ffffffffc0208c04:	00000797          	auipc	a5,0x0
ffffffffc0208c08:	f8c78793          	addi	a5,a5,-116 # ffffffffc0208b90 <stdout_ioctl>
ffffffffc0208c0c:	f51c                	sd	a5,40(a0)
ffffffffc0208c0e:	00053023          	sd	zero,0(a0)
ffffffffc0208c12:	85aa                	mv	a1,a0
ffffffffc0208c14:	4601                	li	a2,0
ffffffffc0208c16:	00005517          	auipc	a0,0x5
ffffffffc0208c1a:	46a50513          	addi	a0,a0,1130 # ffffffffc020e080 <etext+0x2c7e>
ffffffffc0208c1e:	814ff0ef          	jal	ffffffffc0207c32 <vfs_add_dev>
ffffffffc0208c22:	e105                	bnez	a0,ffffffffc0208c42 <dev_init_stdout+0x76>
ffffffffc0208c24:	60a2                	ld	ra,8(sp)
ffffffffc0208c26:	0141                	addi	sp,sp,16
ffffffffc0208c28:	8082                	ret
ffffffffc0208c2a:	00005617          	auipc	a2,0x5
ffffffffc0208c2e:	41660613          	addi	a2,a2,1046 # ffffffffc020e040 <etext+0x2c3e>
ffffffffc0208c32:	03700593          	li	a1,55
ffffffffc0208c36:	00005517          	auipc	a0,0x5
ffffffffc0208c3a:	42a50513          	addi	a0,a0,1066 # ffffffffc020e060 <etext+0x2c5e>
ffffffffc0208c3e:	80df70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208c42:	86aa                	mv	a3,a0
ffffffffc0208c44:	00005617          	auipc	a2,0x5
ffffffffc0208c48:	44460613          	addi	a2,a2,1092 # ffffffffc020e088 <etext+0x2c86>
ffffffffc0208c4c:	03d00593          	li	a1,61
ffffffffc0208c50:	00005517          	auipc	a0,0x5
ffffffffc0208c54:	41050513          	addi	a0,a0,1040 # ffffffffc020e060 <etext+0x2c5e>
ffffffffc0208c58:	ff2f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208c5c:	00005697          	auipc	a3,0x5
ffffffffc0208c60:	ea468693          	addi	a3,a3,-348 # ffffffffc020db00 <etext+0x26fe>
ffffffffc0208c64:	00003617          	auipc	a2,0x3
ffffffffc0208c68:	bdc60613          	addi	a2,a2,-1060 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208c6c:	03900593          	li	a1,57
ffffffffc0208c70:	00005517          	auipc	a0,0x5
ffffffffc0208c74:	3f050513          	addi	a0,a0,1008 # ffffffffc020e060 <etext+0x2c5e>
ffffffffc0208c78:	fd2f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208c7c <bitmap_translate.part.0>:
ffffffffc0208c7c:	1141                	addi	sp,sp,-16
ffffffffc0208c7e:	00005697          	auipc	a3,0x5
ffffffffc0208c82:	42a68693          	addi	a3,a3,1066 # ffffffffc020e0a8 <etext+0x2ca6>
ffffffffc0208c86:	00003617          	auipc	a2,0x3
ffffffffc0208c8a:	bba60613          	addi	a2,a2,-1094 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208c8e:	04c00593          	li	a1,76
ffffffffc0208c92:	00005517          	auipc	a0,0x5
ffffffffc0208c96:	42e50513          	addi	a0,a0,1070 # ffffffffc020e0c0 <etext+0x2cbe>
ffffffffc0208c9a:	e406                	sd	ra,8(sp)
ffffffffc0208c9c:	faef70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208ca0 <bitmap_create>:
ffffffffc0208ca0:	7139                	addi	sp,sp,-64
ffffffffc0208ca2:	fc06                	sd	ra,56(sp)
ffffffffc0208ca4:	f822                	sd	s0,48(sp)
ffffffffc0208ca6:	f426                	sd	s1,40(sp)
ffffffffc0208ca8:	c179                	beqz	a0,ffffffffc0208d6e <bitmap_create+0xce>
ffffffffc0208caa:	842a                	mv	s0,a0
ffffffffc0208cac:	4541                	li	a0,16
ffffffffc0208cae:	b26f90ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0208cb2:	84aa                	mv	s1,a0
ffffffffc0208cb4:	c555                	beqz	a0,ffffffffc0208d60 <bitmap_create+0xc0>
ffffffffc0208cb6:	e852                	sd	s4,16(sp)
ffffffffc0208cb8:	02041a13          	slli	s4,s0,0x20
ffffffffc0208cbc:	020a5a13          	srli	s4,s4,0x20
ffffffffc0208cc0:	f04a                	sd	s2,32(sp)
ffffffffc0208cc2:	01fa0913          	addi	s2,s4,31
ffffffffc0208cc6:	ec4e                	sd	s3,24(sp)
ffffffffc0208cc8:	00595993          	srli	s3,s2,0x5
ffffffffc0208ccc:	00299613          	slli	a2,s3,0x2
ffffffffc0208cd0:	8532                	mv	a0,a2
ffffffffc0208cd2:	e432                	sd	a2,8(sp)
ffffffffc0208cd4:	b00f90ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0208cd8:	6622                	ld	a2,8(sp)
ffffffffc0208cda:	cd2d                	beqz	a0,ffffffffc0208d54 <bitmap_create+0xb4>
ffffffffc0208cdc:	c080                	sw	s0,0(s1)
ffffffffc0208cde:	0134a223          	sw	s3,4(s1)
ffffffffc0208ce2:	0ff00593          	li	a1,255
ffffffffc0208ce6:	6b4020ef          	jal	ffffffffc020b39a <memset>
ffffffffc0208cea:	4785                	li	a5,1
ffffffffc0208cec:	1796                	slli	a5,a5,0x25
ffffffffc0208cee:	1781                	addi	a5,a5,-32
ffffffffc0208cf0:	e488                	sd	a0,8(s1)
ffffffffc0208cf2:	00f97933          	and	s2,s2,a5
ffffffffc0208cf6:	052a0663          	beq	s4,s2,ffffffffc0208d42 <bitmap_create+0xa2>
ffffffffc0208cfa:	39fd                	addiw	s3,s3,-1
ffffffffc0208cfc:	0054571b          	srliw	a4,s0,0x5
ffffffffc0208d00:	0b371963          	bne	a4,s3,ffffffffc0208db2 <bitmap_create+0x112>
ffffffffc0208d04:	0057179b          	slliw	a5,a4,0x5
ffffffffc0208d08:	40f407bb          	subw	a5,s0,a5
ffffffffc0208d0c:	fff7861b          	addiw	a2,a5,-1
ffffffffc0208d10:	46f9                	li	a3,30
ffffffffc0208d12:	08c6e063          	bltu	a3,a2,ffffffffc0208d92 <bitmap_create+0xf2>
ffffffffc0208d16:	070a                	slli	a4,a4,0x2
ffffffffc0208d18:	953a                	add	a0,a0,a4
ffffffffc0208d1a:	4118                	lw	a4,0(a0)
ffffffffc0208d1c:	4585                	li	a1,1
ffffffffc0208d1e:	02000613          	li	a2,32
ffffffffc0208d22:	00f596bb          	sllw	a3,a1,a5
ffffffffc0208d26:	2785                	addiw	a5,a5,1
ffffffffc0208d28:	8f35                	xor	a4,a4,a3
ffffffffc0208d2a:	fec79ce3          	bne	a5,a2,ffffffffc0208d22 <bitmap_create+0x82>
ffffffffc0208d2e:	7442                	ld	s0,48(sp)
ffffffffc0208d30:	70e2                	ld	ra,56(sp)
ffffffffc0208d32:	c118                	sw	a4,0(a0)
ffffffffc0208d34:	7902                	ld	s2,32(sp)
ffffffffc0208d36:	69e2                	ld	s3,24(sp)
ffffffffc0208d38:	6a42                	ld	s4,16(sp)
ffffffffc0208d3a:	8526                	mv	a0,s1
ffffffffc0208d3c:	74a2                	ld	s1,40(sp)
ffffffffc0208d3e:	6121                	addi	sp,sp,64
ffffffffc0208d40:	8082                	ret
ffffffffc0208d42:	7442                	ld	s0,48(sp)
ffffffffc0208d44:	70e2                	ld	ra,56(sp)
ffffffffc0208d46:	7902                	ld	s2,32(sp)
ffffffffc0208d48:	69e2                	ld	s3,24(sp)
ffffffffc0208d4a:	6a42                	ld	s4,16(sp)
ffffffffc0208d4c:	8526                	mv	a0,s1
ffffffffc0208d4e:	74a2                	ld	s1,40(sp)
ffffffffc0208d50:	6121                	addi	sp,sp,64
ffffffffc0208d52:	8082                	ret
ffffffffc0208d54:	8526                	mv	a0,s1
ffffffffc0208d56:	b24f90ef          	jal	ffffffffc020207a <kfree>
ffffffffc0208d5a:	7902                	ld	s2,32(sp)
ffffffffc0208d5c:	69e2                	ld	s3,24(sp)
ffffffffc0208d5e:	6a42                	ld	s4,16(sp)
ffffffffc0208d60:	7442                	ld	s0,48(sp)
ffffffffc0208d62:	70e2                	ld	ra,56(sp)
ffffffffc0208d64:	4481                	li	s1,0
ffffffffc0208d66:	8526                	mv	a0,s1
ffffffffc0208d68:	74a2                	ld	s1,40(sp)
ffffffffc0208d6a:	6121                	addi	sp,sp,64
ffffffffc0208d6c:	8082                	ret
ffffffffc0208d6e:	00005697          	auipc	a3,0x5
ffffffffc0208d72:	36a68693          	addi	a3,a3,874 # ffffffffc020e0d8 <etext+0x2cd6>
ffffffffc0208d76:	00003617          	auipc	a2,0x3
ffffffffc0208d7a:	aca60613          	addi	a2,a2,-1334 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208d7e:	45d5                	li	a1,21
ffffffffc0208d80:	00005517          	auipc	a0,0x5
ffffffffc0208d84:	34050513          	addi	a0,a0,832 # ffffffffc020e0c0 <etext+0x2cbe>
ffffffffc0208d88:	f04a                	sd	s2,32(sp)
ffffffffc0208d8a:	ec4e                	sd	s3,24(sp)
ffffffffc0208d8c:	e852                	sd	s4,16(sp)
ffffffffc0208d8e:	ebcf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208d92:	00005697          	auipc	a3,0x5
ffffffffc0208d96:	38668693          	addi	a3,a3,902 # ffffffffc020e118 <etext+0x2d16>
ffffffffc0208d9a:	00003617          	auipc	a2,0x3
ffffffffc0208d9e:	aa660613          	addi	a2,a2,-1370 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208da2:	02b00593          	li	a1,43
ffffffffc0208da6:	00005517          	auipc	a0,0x5
ffffffffc0208daa:	31a50513          	addi	a0,a0,794 # ffffffffc020e0c0 <etext+0x2cbe>
ffffffffc0208dae:	e9cf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208db2:	00005697          	auipc	a3,0x5
ffffffffc0208db6:	34e68693          	addi	a3,a3,846 # ffffffffc020e100 <etext+0x2cfe>
ffffffffc0208dba:	00003617          	auipc	a2,0x3
ffffffffc0208dbe:	a8660613          	addi	a2,a2,-1402 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208dc2:	02a00593          	li	a1,42
ffffffffc0208dc6:	00005517          	auipc	a0,0x5
ffffffffc0208dca:	2fa50513          	addi	a0,a0,762 # ffffffffc020e0c0 <etext+0x2cbe>
ffffffffc0208dce:	e7cf70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208dd2 <bitmap_alloc>:
ffffffffc0208dd2:	4150                	lw	a2,4(a0)
ffffffffc0208dd4:	c229                	beqz	a2,ffffffffc0208e16 <bitmap_alloc+0x44>
ffffffffc0208dd6:	6518                	ld	a4,8(a0)
ffffffffc0208dd8:	4781                	li	a5,0
ffffffffc0208dda:	a029                	j	ffffffffc0208de4 <bitmap_alloc+0x12>
ffffffffc0208ddc:	2785                	addiw	a5,a5,1
ffffffffc0208dde:	0711                	addi	a4,a4,4
ffffffffc0208de0:	02f60b63          	beq	a2,a5,ffffffffc0208e16 <bitmap_alloc+0x44>
ffffffffc0208de4:	4314                	lw	a3,0(a4)
ffffffffc0208de6:	dafd                	beqz	a3,ffffffffc0208ddc <bitmap_alloc+0xa>
ffffffffc0208de8:	0016f613          	andi	a2,a3,1
ffffffffc0208dec:	ea29                	bnez	a2,ffffffffc0208e3e <bitmap_alloc+0x6c>
ffffffffc0208dee:	02000893          	li	a7,32
ffffffffc0208df2:	4305                	li	t1,1
ffffffffc0208df4:	2605                	addiw	a2,a2,1
ffffffffc0208df6:	03160263          	beq	a2,a7,ffffffffc0208e1a <bitmap_alloc+0x48>
ffffffffc0208dfa:	00c3153b          	sllw	a0,t1,a2
ffffffffc0208dfe:	00a6f833          	and	a6,a3,a0
ffffffffc0208e02:	fe0809e3          	beqz	a6,ffffffffc0208df4 <bitmap_alloc+0x22>
ffffffffc0208e06:	8ea9                	xor	a3,a3,a0
ffffffffc0208e08:	0057979b          	slliw	a5,a5,0x5
ffffffffc0208e0c:	c314                	sw	a3,0(a4)
ffffffffc0208e0e:	9fb1                	addw	a5,a5,a2
ffffffffc0208e10:	c19c                	sw	a5,0(a1)
ffffffffc0208e12:	4501                	li	a0,0
ffffffffc0208e14:	8082                	ret
ffffffffc0208e16:	5571                	li	a0,-4
ffffffffc0208e18:	8082                	ret
ffffffffc0208e1a:	1141                	addi	sp,sp,-16
ffffffffc0208e1c:	00005697          	auipc	a3,0x5
ffffffffc0208e20:	32468693          	addi	a3,a3,804 # ffffffffc020e140 <etext+0x2d3e>
ffffffffc0208e24:	00003617          	auipc	a2,0x3
ffffffffc0208e28:	a1c60613          	addi	a2,a2,-1508 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208e2c:	04300593          	li	a1,67
ffffffffc0208e30:	00005517          	auipc	a0,0x5
ffffffffc0208e34:	29050513          	addi	a0,a0,656 # ffffffffc020e0c0 <etext+0x2cbe>
ffffffffc0208e38:	e406                	sd	ra,8(sp)
ffffffffc0208e3a:	e10f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208e3e:	8532                	mv	a0,a2
ffffffffc0208e40:	4601                	li	a2,0
ffffffffc0208e42:	b7d1                	j	ffffffffc0208e06 <bitmap_alloc+0x34>

ffffffffc0208e44 <bitmap_test>:
ffffffffc0208e44:	411c                	lw	a5,0(a0)
ffffffffc0208e46:	00f5ff63          	bgeu	a1,a5,ffffffffc0208e64 <bitmap_test+0x20>
ffffffffc0208e4a:	651c                	ld	a5,8(a0)
ffffffffc0208e4c:	0055d71b          	srliw	a4,a1,0x5
ffffffffc0208e50:	070a                	slli	a4,a4,0x2
ffffffffc0208e52:	97ba                	add	a5,a5,a4
ffffffffc0208e54:	439c                	lw	a5,0(a5)
ffffffffc0208e56:	4505                	li	a0,1
ffffffffc0208e58:	00b5153b          	sllw	a0,a0,a1
ffffffffc0208e5c:	8d7d                	and	a0,a0,a5
ffffffffc0208e5e:	1502                	slli	a0,a0,0x20
ffffffffc0208e60:	9101                	srli	a0,a0,0x20
ffffffffc0208e62:	8082                	ret
ffffffffc0208e64:	1141                	addi	sp,sp,-16
ffffffffc0208e66:	e406                	sd	ra,8(sp)
ffffffffc0208e68:	e15ff0ef          	jal	ffffffffc0208c7c <bitmap_translate.part.0>

ffffffffc0208e6c <bitmap_free>:
ffffffffc0208e6c:	411c                	lw	a5,0(a0)
ffffffffc0208e6e:	1141                	addi	sp,sp,-16
ffffffffc0208e70:	e406                	sd	ra,8(sp)
ffffffffc0208e72:	02f5f363          	bgeu	a1,a5,ffffffffc0208e98 <bitmap_free+0x2c>
ffffffffc0208e76:	651c                	ld	a5,8(a0)
ffffffffc0208e78:	0055d71b          	srliw	a4,a1,0x5
ffffffffc0208e7c:	070a                	slli	a4,a4,0x2
ffffffffc0208e7e:	97ba                	add	a5,a5,a4
ffffffffc0208e80:	4394                	lw	a3,0(a5)
ffffffffc0208e82:	4705                	li	a4,1
ffffffffc0208e84:	00b715bb          	sllw	a1,a4,a1
ffffffffc0208e88:	00b6f733          	and	a4,a3,a1
ffffffffc0208e8c:	eb01                	bnez	a4,ffffffffc0208e9c <bitmap_free+0x30>
ffffffffc0208e8e:	60a2                	ld	ra,8(sp)
ffffffffc0208e90:	8ecd                	or	a3,a3,a1
ffffffffc0208e92:	c394                	sw	a3,0(a5)
ffffffffc0208e94:	0141                	addi	sp,sp,16
ffffffffc0208e96:	8082                	ret
ffffffffc0208e98:	de5ff0ef          	jal	ffffffffc0208c7c <bitmap_translate.part.0>
ffffffffc0208e9c:	00005697          	auipc	a3,0x5
ffffffffc0208ea0:	2ac68693          	addi	a3,a3,684 # ffffffffc020e148 <etext+0x2d46>
ffffffffc0208ea4:	00003617          	auipc	a2,0x3
ffffffffc0208ea8:	99c60613          	addi	a2,a2,-1636 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208eac:	05f00593          	li	a1,95
ffffffffc0208eb0:	00005517          	auipc	a0,0x5
ffffffffc0208eb4:	21050513          	addi	a0,a0,528 # ffffffffc020e0c0 <etext+0x2cbe>
ffffffffc0208eb8:	d92f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208ebc <bitmap_destroy>:
ffffffffc0208ebc:	1141                	addi	sp,sp,-16
ffffffffc0208ebe:	e022                	sd	s0,0(sp)
ffffffffc0208ec0:	842a                	mv	s0,a0
ffffffffc0208ec2:	6508                	ld	a0,8(a0)
ffffffffc0208ec4:	e406                	sd	ra,8(sp)
ffffffffc0208ec6:	9b4f90ef          	jal	ffffffffc020207a <kfree>
ffffffffc0208eca:	8522                	mv	a0,s0
ffffffffc0208ecc:	6402                	ld	s0,0(sp)
ffffffffc0208ece:	60a2                	ld	ra,8(sp)
ffffffffc0208ed0:	0141                	addi	sp,sp,16
ffffffffc0208ed2:	9a8f906f          	j	ffffffffc020207a <kfree>

ffffffffc0208ed6 <bitmap_getdata>:
ffffffffc0208ed6:	c589                	beqz	a1,ffffffffc0208ee0 <bitmap_getdata+0xa>
ffffffffc0208ed8:	00456783          	lwu	a5,4(a0)
ffffffffc0208edc:	078a                	slli	a5,a5,0x2
ffffffffc0208ede:	e19c                	sd	a5,0(a1)
ffffffffc0208ee0:	6508                	ld	a0,8(a0)
ffffffffc0208ee2:	8082                	ret

ffffffffc0208ee4 <sfs_init>:
ffffffffc0208ee4:	1141                	addi	sp,sp,-16
ffffffffc0208ee6:	00005517          	auipc	a0,0x5
ffffffffc0208eea:	0ca50513          	addi	a0,a0,202 # ffffffffc020dfb0 <etext+0x2bae>
ffffffffc0208eee:	e406                	sd	ra,8(sp)
ffffffffc0208ef0:	576000ef          	jal	ffffffffc0209466 <sfs_mount>
ffffffffc0208ef4:	e501                	bnez	a0,ffffffffc0208efc <sfs_init+0x18>
ffffffffc0208ef6:	60a2                	ld	ra,8(sp)
ffffffffc0208ef8:	0141                	addi	sp,sp,16
ffffffffc0208efa:	8082                	ret
ffffffffc0208efc:	86aa                	mv	a3,a0
ffffffffc0208efe:	00005617          	auipc	a2,0x5
ffffffffc0208f02:	25a60613          	addi	a2,a2,602 # ffffffffc020e158 <etext+0x2d56>
ffffffffc0208f06:	45c1                	li	a1,16
ffffffffc0208f08:	00005517          	auipc	a0,0x5
ffffffffc0208f0c:	27050513          	addi	a0,a0,624 # ffffffffc020e178 <etext+0x2d76>
ffffffffc0208f10:	d3af70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208f14 <sfs_unmount>:
ffffffffc0208f14:	1141                	addi	sp,sp,-16
ffffffffc0208f16:	e406                	sd	ra,8(sp)
ffffffffc0208f18:	e022                	sd	s0,0(sp)
ffffffffc0208f1a:	cd1d                	beqz	a0,ffffffffc0208f58 <sfs_unmount+0x44>
ffffffffc0208f1c:	0b052783          	lw	a5,176(a0)
ffffffffc0208f20:	842a                	mv	s0,a0
ffffffffc0208f22:	eb9d                	bnez	a5,ffffffffc0208f58 <sfs_unmount+0x44>
ffffffffc0208f24:	7158                	ld	a4,160(a0)
ffffffffc0208f26:	09850793          	addi	a5,a0,152
ffffffffc0208f2a:	02f71563          	bne	a4,a5,ffffffffc0208f54 <sfs_unmount+0x40>
ffffffffc0208f2e:	613c                	ld	a5,64(a0)
ffffffffc0208f30:	e7a1                	bnez	a5,ffffffffc0208f78 <sfs_unmount+0x64>
ffffffffc0208f32:	7d08                	ld	a0,56(a0)
ffffffffc0208f34:	f89ff0ef          	jal	ffffffffc0208ebc <bitmap_destroy>
ffffffffc0208f38:	6428                	ld	a0,72(s0)
ffffffffc0208f3a:	940f90ef          	jal	ffffffffc020207a <kfree>
ffffffffc0208f3e:	7448                	ld	a0,168(s0)
ffffffffc0208f40:	93af90ef          	jal	ffffffffc020207a <kfree>
ffffffffc0208f44:	8522                	mv	a0,s0
ffffffffc0208f46:	934f90ef          	jal	ffffffffc020207a <kfree>
ffffffffc0208f4a:	4501                	li	a0,0
ffffffffc0208f4c:	60a2                	ld	ra,8(sp)
ffffffffc0208f4e:	6402                	ld	s0,0(sp)
ffffffffc0208f50:	0141                	addi	sp,sp,16
ffffffffc0208f52:	8082                	ret
ffffffffc0208f54:	5545                	li	a0,-15
ffffffffc0208f56:	bfdd                	j	ffffffffc0208f4c <sfs_unmount+0x38>
ffffffffc0208f58:	00005697          	auipc	a3,0x5
ffffffffc0208f5c:	23868693          	addi	a3,a3,568 # ffffffffc020e190 <etext+0x2d8e>
ffffffffc0208f60:	00003617          	auipc	a2,0x3
ffffffffc0208f64:	8e060613          	addi	a2,a2,-1824 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208f68:	04100593          	li	a1,65
ffffffffc0208f6c:	00005517          	auipc	a0,0x5
ffffffffc0208f70:	25450513          	addi	a0,a0,596 # ffffffffc020e1c0 <etext+0x2dbe>
ffffffffc0208f74:	cd6f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208f78:	00005697          	auipc	a3,0x5
ffffffffc0208f7c:	26068693          	addi	a3,a3,608 # ffffffffc020e1d8 <etext+0x2dd6>
ffffffffc0208f80:	00003617          	auipc	a2,0x3
ffffffffc0208f84:	8c060613          	addi	a2,a2,-1856 # ffffffffc020b840 <etext+0x43e>
ffffffffc0208f88:	04500593          	li	a1,69
ffffffffc0208f8c:	00005517          	auipc	a0,0x5
ffffffffc0208f90:	23450513          	addi	a0,a0,564 # ffffffffc020e1c0 <etext+0x2dbe>
ffffffffc0208f94:	cb6f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208f98 <sfs_cleanup>:
ffffffffc0208f98:	1101                	addi	sp,sp,-32
ffffffffc0208f9a:	ec06                	sd	ra,24(sp)
ffffffffc0208f9c:	e426                	sd	s1,8(sp)
ffffffffc0208f9e:	c13d                	beqz	a0,ffffffffc0209004 <sfs_cleanup+0x6c>
ffffffffc0208fa0:	0b052783          	lw	a5,176(a0)
ffffffffc0208fa4:	84aa                	mv	s1,a0
ffffffffc0208fa6:	efb9                	bnez	a5,ffffffffc0209004 <sfs_cleanup+0x6c>
ffffffffc0208fa8:	4158                	lw	a4,4(a0)
ffffffffc0208faa:	4514                	lw	a3,8(a0)
ffffffffc0208fac:	00c50593          	addi	a1,a0,12
ffffffffc0208fb0:	00005517          	auipc	a0,0x5
ffffffffc0208fb4:	24050513          	addi	a0,a0,576 # ffffffffc020e1f0 <etext+0x2dee>
ffffffffc0208fb8:	40d7063b          	subw	a2,a4,a3
ffffffffc0208fbc:	e822                	sd	s0,16(sp)
ffffffffc0208fbe:	9e8f70ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0208fc2:	02000413          	li	s0,32
ffffffffc0208fc6:	a019                	j	ffffffffc0208fcc <sfs_cleanup+0x34>
ffffffffc0208fc8:	347d                	addiw	s0,s0,-1
ffffffffc0208fca:	c811                	beqz	s0,ffffffffc0208fde <sfs_cleanup+0x46>
ffffffffc0208fcc:	7cdc                	ld	a5,184(s1)
ffffffffc0208fce:	8526                	mv	a0,s1
ffffffffc0208fd0:	9782                	jalr	a5
ffffffffc0208fd2:	f97d                	bnez	a0,ffffffffc0208fc8 <sfs_cleanup+0x30>
ffffffffc0208fd4:	6442                	ld	s0,16(sp)
ffffffffc0208fd6:	60e2                	ld	ra,24(sp)
ffffffffc0208fd8:	64a2                	ld	s1,8(sp)
ffffffffc0208fda:	6105                	addi	sp,sp,32
ffffffffc0208fdc:	8082                	ret
ffffffffc0208fde:	6442                	ld	s0,16(sp)
ffffffffc0208fe0:	60e2                	ld	ra,24(sp)
ffffffffc0208fe2:	00c48693          	addi	a3,s1,12
ffffffffc0208fe6:	64a2                	ld	s1,8(sp)
ffffffffc0208fe8:	872a                	mv	a4,a0
ffffffffc0208fea:	00005617          	auipc	a2,0x5
ffffffffc0208fee:	22660613          	addi	a2,a2,550 # ffffffffc020e210 <etext+0x2e0e>
ffffffffc0208ff2:	05f00593          	li	a1,95
ffffffffc0208ff6:	00005517          	auipc	a0,0x5
ffffffffc0208ffa:	1ca50513          	addi	a0,a0,458 # ffffffffc020e1c0 <etext+0x2dbe>
ffffffffc0208ffe:	6105                	addi	sp,sp,32
ffffffffc0209000:	cb4f706f          	j	ffffffffc02004b4 <__warn>
ffffffffc0209004:	00005697          	auipc	a3,0x5
ffffffffc0209008:	18c68693          	addi	a3,a3,396 # ffffffffc020e190 <etext+0x2d8e>
ffffffffc020900c:	00003617          	auipc	a2,0x3
ffffffffc0209010:	83460613          	addi	a2,a2,-1996 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209014:	05400593          	li	a1,84
ffffffffc0209018:	00005517          	auipc	a0,0x5
ffffffffc020901c:	1a850513          	addi	a0,a0,424 # ffffffffc020e1c0 <etext+0x2dbe>
ffffffffc0209020:	e822                	sd	s0,16(sp)
ffffffffc0209022:	e04a                	sd	s2,0(sp)
ffffffffc0209024:	c26f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209028 <sfs_sync>:
ffffffffc0209028:	7179                	addi	sp,sp,-48
ffffffffc020902a:	f406                	sd	ra,40(sp)
ffffffffc020902c:	e44e                	sd	s3,8(sp)
ffffffffc020902e:	c94d                	beqz	a0,ffffffffc02090e0 <sfs_sync+0xb8>
ffffffffc0209030:	0b052783          	lw	a5,176(a0)
ffffffffc0209034:	89aa                	mv	s3,a0
ffffffffc0209036:	e7cd                	bnez	a5,ffffffffc02090e0 <sfs_sync+0xb8>
ffffffffc0209038:	f022                	sd	s0,32(sp)
ffffffffc020903a:	e84a                	sd	s2,16(sp)
ffffffffc020903c:	603010ef          	jal	ffffffffc020ae3e <lock_sfs_fs>
ffffffffc0209040:	0a09b403          	ld	s0,160(s3)
ffffffffc0209044:	09898913          	addi	s2,s3,152
ffffffffc0209048:	02890663          	beq	s2,s0,ffffffffc0209074 <sfs_sync+0x4c>
ffffffffc020904c:	7c1c                	ld	a5,56(s0)
ffffffffc020904e:	cbad                	beqz	a5,ffffffffc02090c0 <sfs_sync+0x98>
ffffffffc0209050:	7b9c                	ld	a5,48(a5)
ffffffffc0209052:	c7bd                	beqz	a5,ffffffffc02090c0 <sfs_sync+0x98>
ffffffffc0209054:	fc840513          	addi	a0,s0,-56
ffffffffc0209058:	00004597          	auipc	a1,0x4
ffffffffc020905c:	03058593          	addi	a1,a1,48 # ffffffffc020d088 <etext+0x1c86>
ffffffffc0209060:	decfe0ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0209064:	7c1c                	ld	a5,56(s0)
ffffffffc0209066:	fc840513          	addi	a0,s0,-56
ffffffffc020906a:	7b9c                	ld	a5,48(a5)
ffffffffc020906c:	9782                	jalr	a5
ffffffffc020906e:	6400                	ld	s0,8(s0)
ffffffffc0209070:	fc891ee3          	bne	s2,s0,ffffffffc020904c <sfs_sync+0x24>
ffffffffc0209074:	854e                	mv	a0,s3
ffffffffc0209076:	5d9010ef          	jal	ffffffffc020ae4e <unlock_sfs_fs>
ffffffffc020907a:	0409b783          	ld	a5,64(s3)
ffffffffc020907e:	4501                	li	a0,0
ffffffffc0209080:	e799                	bnez	a5,ffffffffc020908e <sfs_sync+0x66>
ffffffffc0209082:	7402                	ld	s0,32(sp)
ffffffffc0209084:	70a2                	ld	ra,40(sp)
ffffffffc0209086:	6942                	ld	s2,16(sp)
ffffffffc0209088:	69a2                	ld	s3,8(sp)
ffffffffc020908a:	6145                	addi	sp,sp,48
ffffffffc020908c:	8082                	ret
ffffffffc020908e:	0409b023          	sd	zero,64(s3)
ffffffffc0209092:	854e                	mv	a0,s3
ffffffffc0209094:	48b010ef          	jal	ffffffffc020ad1e <sfs_sync_super>
ffffffffc0209098:	c911                	beqz	a0,ffffffffc02090ac <sfs_sync+0x84>
ffffffffc020909a:	7402                	ld	s0,32(sp)
ffffffffc020909c:	70a2                	ld	ra,40(sp)
ffffffffc020909e:	4785                	li	a5,1
ffffffffc02090a0:	04f9b023          	sd	a5,64(s3)
ffffffffc02090a4:	6942                	ld	s2,16(sp)
ffffffffc02090a6:	69a2                	ld	s3,8(sp)
ffffffffc02090a8:	6145                	addi	sp,sp,48
ffffffffc02090aa:	8082                	ret
ffffffffc02090ac:	854e                	mv	a0,s3
ffffffffc02090ae:	4b7010ef          	jal	ffffffffc020ad64 <sfs_sync_freemap>
ffffffffc02090b2:	f565                	bnez	a0,ffffffffc020909a <sfs_sync+0x72>
ffffffffc02090b4:	7402                	ld	s0,32(sp)
ffffffffc02090b6:	70a2                	ld	ra,40(sp)
ffffffffc02090b8:	6942                	ld	s2,16(sp)
ffffffffc02090ba:	69a2                	ld	s3,8(sp)
ffffffffc02090bc:	6145                	addi	sp,sp,48
ffffffffc02090be:	8082                	ret
ffffffffc02090c0:	00004697          	auipc	a3,0x4
ffffffffc02090c4:	f7868693          	addi	a3,a3,-136 # ffffffffc020d038 <etext+0x1c36>
ffffffffc02090c8:	00002617          	auipc	a2,0x2
ffffffffc02090cc:	77860613          	addi	a2,a2,1912 # ffffffffc020b840 <etext+0x43e>
ffffffffc02090d0:	45ed                	li	a1,27
ffffffffc02090d2:	00005517          	auipc	a0,0x5
ffffffffc02090d6:	0ee50513          	addi	a0,a0,238 # ffffffffc020e1c0 <etext+0x2dbe>
ffffffffc02090da:	ec26                	sd	s1,24(sp)
ffffffffc02090dc:	b6ef70ef          	jal	ffffffffc020044a <__panic>
ffffffffc02090e0:	00005697          	auipc	a3,0x5
ffffffffc02090e4:	0b068693          	addi	a3,a3,176 # ffffffffc020e190 <etext+0x2d8e>
ffffffffc02090e8:	00002617          	auipc	a2,0x2
ffffffffc02090ec:	75860613          	addi	a2,a2,1880 # ffffffffc020b840 <etext+0x43e>
ffffffffc02090f0:	45d5                	li	a1,21
ffffffffc02090f2:	00005517          	auipc	a0,0x5
ffffffffc02090f6:	0ce50513          	addi	a0,a0,206 # ffffffffc020e1c0 <etext+0x2dbe>
ffffffffc02090fa:	f022                	sd	s0,32(sp)
ffffffffc02090fc:	ec26                	sd	s1,24(sp)
ffffffffc02090fe:	e84a                	sd	s2,16(sp)
ffffffffc0209100:	b4af70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209104 <sfs_get_root>:
ffffffffc0209104:	1101                	addi	sp,sp,-32
ffffffffc0209106:	ec06                	sd	ra,24(sp)
ffffffffc0209108:	cd09                	beqz	a0,ffffffffc0209122 <sfs_get_root+0x1e>
ffffffffc020910a:	0b052783          	lw	a5,176(a0)
ffffffffc020910e:	eb91                	bnez	a5,ffffffffc0209122 <sfs_get_root+0x1e>
ffffffffc0209110:	4605                	li	a2,1
ffffffffc0209112:	002c                	addi	a1,sp,8
ffffffffc0209114:	368010ef          	jal	ffffffffc020a47c <sfs_load_inode>
ffffffffc0209118:	e50d                	bnez	a0,ffffffffc0209142 <sfs_get_root+0x3e>
ffffffffc020911a:	60e2                	ld	ra,24(sp)
ffffffffc020911c:	6522                	ld	a0,8(sp)
ffffffffc020911e:	6105                	addi	sp,sp,32
ffffffffc0209120:	8082                	ret
ffffffffc0209122:	00005697          	auipc	a3,0x5
ffffffffc0209126:	06e68693          	addi	a3,a3,110 # ffffffffc020e190 <etext+0x2d8e>
ffffffffc020912a:	00002617          	auipc	a2,0x2
ffffffffc020912e:	71660613          	addi	a2,a2,1814 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209132:	03600593          	li	a1,54
ffffffffc0209136:	00005517          	auipc	a0,0x5
ffffffffc020913a:	08a50513          	addi	a0,a0,138 # ffffffffc020e1c0 <etext+0x2dbe>
ffffffffc020913e:	b0cf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209142:	86aa                	mv	a3,a0
ffffffffc0209144:	00005617          	auipc	a2,0x5
ffffffffc0209148:	0ec60613          	addi	a2,a2,236 # ffffffffc020e230 <etext+0x2e2e>
ffffffffc020914c:	03700593          	li	a1,55
ffffffffc0209150:	00005517          	auipc	a0,0x5
ffffffffc0209154:	07050513          	addi	a0,a0,112 # ffffffffc020e1c0 <etext+0x2dbe>
ffffffffc0209158:	af2f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc020915c <sfs_do_mount>:
ffffffffc020915c:	7171                	addi	sp,sp,-176
ffffffffc020915e:	e54e                	sd	s3,136(sp)
ffffffffc0209160:	00853983          	ld	s3,8(a0)
ffffffffc0209164:	f506                	sd	ra,168(sp)
ffffffffc0209166:	6785                	lui	a5,0x1
ffffffffc0209168:	26f99a63          	bne	s3,a5,ffffffffc02093dc <sfs_do_mount+0x280>
ffffffffc020916c:	ed26                	sd	s1,152(sp)
ffffffffc020916e:	84aa                	mv	s1,a0
ffffffffc0209170:	4501                	li	a0,0
ffffffffc0209172:	f122                	sd	s0,160(sp)
ffffffffc0209174:	f4de                	sd	s7,104(sp)
ffffffffc0209176:	8bae                	mv	s7,a1
ffffffffc0209178:	ec0fe0ef          	jal	ffffffffc0207838 <__alloc_fs>
ffffffffc020917c:	842a                	mv	s0,a0
ffffffffc020917e:	26050663          	beqz	a0,ffffffffc02093ea <sfs_do_mount+0x28e>
ffffffffc0209182:	e152                	sd	s4,128(sp)
ffffffffc0209184:	0b052a03          	lw	s4,176(a0)
ffffffffc0209188:	e94a                	sd	s2,144(sp)
ffffffffc020918a:	280a1763          	bnez	s4,ffffffffc0209418 <sfs_do_mount+0x2bc>
ffffffffc020918e:	f904                	sd	s1,48(a0)
ffffffffc0209190:	854e                	mv	a0,s3
ffffffffc0209192:	e43f80ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0209196:	e428                	sd	a0,72(s0)
ffffffffc0209198:	892a                	mv	s2,a0
ffffffffc020919a:	16050863          	beqz	a0,ffffffffc020930a <sfs_do_mount+0x1ae>
ffffffffc020919e:	864e                	mv	a2,s3
ffffffffc02091a0:	4681                	li	a3,0
ffffffffc02091a2:	85ca                	mv	a1,s2
ffffffffc02091a4:	1008                	addi	a0,sp,32
ffffffffc02091a6:	88cfc0ef          	jal	ffffffffc0205232 <iobuf_init>
ffffffffc02091aa:	709c                	ld	a5,32(s1)
ffffffffc02091ac:	85aa                	mv	a1,a0
ffffffffc02091ae:	4601                	li	a2,0
ffffffffc02091b0:	8526                	mv	a0,s1
ffffffffc02091b2:	9782                	jalr	a5
ffffffffc02091b4:	89aa                	mv	s3,a0
ffffffffc02091b6:	12051a63          	bnez	a0,ffffffffc02092ea <sfs_do_mount+0x18e>
ffffffffc02091ba:	00092583          	lw	a1,0(s2)
ffffffffc02091be:	2f8dc637          	lui	a2,0x2f8dc
ffffffffc02091c2:	e2a60613          	addi	a2,a2,-470 # 2f8dbe2a <_binary_bin_sfs_img_size+0x2f866b2a>
ffffffffc02091c6:	14c59d63          	bne	a1,a2,ffffffffc0209320 <sfs_do_mount+0x1c4>
ffffffffc02091ca:	00492783          	lw	a5,4(s2)
ffffffffc02091ce:	6090                	ld	a2,0(s1)
ffffffffc02091d0:	02079713          	slli	a4,a5,0x20
ffffffffc02091d4:	9301                	srli	a4,a4,0x20
ffffffffc02091d6:	12e66c63          	bltu	a2,a4,ffffffffc020930e <sfs_do_mount+0x1b2>
ffffffffc02091da:	e4ee                	sd	s11,72(sp)
ffffffffc02091dc:	01892503          	lw	a0,24(s2)
ffffffffc02091e0:	00892e03          	lw	t3,8(s2)
ffffffffc02091e4:	00c92303          	lw	t1,12(s2)
ffffffffc02091e8:	01092883          	lw	a7,16(s2)
ffffffffc02091ec:	01492803          	lw	a6,20(s2)
ffffffffc02091f0:	01c92603          	lw	a2,28(s2)
ffffffffc02091f4:	02092683          	lw	a3,32(s2)
ffffffffc02091f8:	02492703          	lw	a4,36(s2)
ffffffffc02091fc:	020905a3          	sb	zero,43(s2)
ffffffffc0209200:	cc08                	sw	a0,24(s0)
ffffffffc0209202:	01c42423          	sw	t3,8(s0)
ffffffffc0209206:	00642623          	sw	t1,12(s0)
ffffffffc020920a:	01142823          	sw	a7,16(s0)
ffffffffc020920e:	01042a23          	sw	a6,20(s0)
ffffffffc0209212:	cc50                	sw	a2,28(s0)
ffffffffc0209214:	d014                	sw	a3,32(s0)
ffffffffc0209216:	d058                	sw	a4,36(s0)
ffffffffc0209218:	c00c                	sw	a1,0(s0)
ffffffffc020921a:	c05c                	sw	a5,4(s0)
ffffffffc020921c:	02892783          	lw	a5,40(s2)
ffffffffc0209220:	6511                	lui	a0,0x4
ffffffffc0209222:	d41c                	sw	a5,40(s0)
ffffffffc0209224:	db1f80ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc0209228:	f448                	sd	a0,168(s0)
ffffffffc020922a:	87aa                	mv	a5,a0
ffffffffc020922c:	8daa                	mv	s11,a0
ffffffffc020922e:	1a050963          	beqz	a0,ffffffffc02093e0 <sfs_do_mount+0x284>
ffffffffc0209232:	6711                	lui	a4,0x4
ffffffffc0209234:	fcd6                	sd	s5,120(sp)
ffffffffc0209236:	ece6                	sd	s9,88(sp)
ffffffffc0209238:	e8ea                	sd	s10,80(sp)
ffffffffc020923a:	972a                	add	a4,a4,a0
ffffffffc020923c:	e79c                	sd	a5,8(a5)
ffffffffc020923e:	e39c                	sd	a5,0(a5)
ffffffffc0209240:	07c1                	addi	a5,a5,16 # 1010 <_binary_bin_swap_img_size-0x6cf0>
ffffffffc0209242:	fee79de3          	bne	a5,a4,ffffffffc020923c <sfs_do_mount+0xe0>
ffffffffc0209246:	00496783          	lwu	a5,4(s2)
ffffffffc020924a:	6721                	lui	a4,0x8
ffffffffc020924c:	fff70a93          	addi	s5,a4,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc0209250:	97d6                	add	a5,a5,s5
ffffffffc0209252:	7761                	lui	a4,0xffff8
ffffffffc0209254:	8ff9                	and	a5,a5,a4
ffffffffc0209256:	0007851b          	sext.w	a0,a5
ffffffffc020925a:	00078c9b          	sext.w	s9,a5
ffffffffc020925e:	a43ff0ef          	jal	ffffffffc0208ca0 <bitmap_create>
ffffffffc0209262:	fc08                	sd	a0,56(s0)
ffffffffc0209264:	8d2a                	mv	s10,a0
ffffffffc0209266:	16050963          	beqz	a0,ffffffffc02093d8 <sfs_do_mount+0x27c>
ffffffffc020926a:	00492783          	lw	a5,4(s2)
ffffffffc020926e:	082c                	addi	a1,sp,24
ffffffffc0209270:	e43e                	sd	a5,8(sp)
ffffffffc0209272:	c65ff0ef          	jal	ffffffffc0208ed6 <bitmap_getdata>
ffffffffc0209276:	16050f63          	beqz	a0,ffffffffc02093f4 <sfs_do_mount+0x298>
ffffffffc020927a:	00816783          	lwu	a5,8(sp)
ffffffffc020927e:	66e2                	ld	a3,24(sp)
ffffffffc0209280:	97d6                	add	a5,a5,s5
ffffffffc0209282:	83bd                	srli	a5,a5,0xf
ffffffffc0209284:	00c7971b          	slliw	a4,a5,0xc
ffffffffc0209288:	1702                	slli	a4,a4,0x20
ffffffffc020928a:	9301                	srli	a4,a4,0x20
ffffffffc020928c:	16d71463          	bne	a4,a3,ffffffffc02093f4 <sfs_do_mount+0x298>
ffffffffc0209290:	f0e2                	sd	s8,96(sp)
ffffffffc0209292:	00c79713          	slli	a4,a5,0xc
ffffffffc0209296:	00e50c33          	add	s8,a0,a4
ffffffffc020929a:	8aaa                	mv	s5,a0
ffffffffc020929c:	cbd9                	beqz	a5,ffffffffc0209332 <sfs_do_mount+0x1d6>
ffffffffc020929e:	6789                	lui	a5,0x2
ffffffffc02092a0:	f8da                	sd	s6,112(sp)
ffffffffc02092a2:	40a78b3b          	subw	s6,a5,a0
ffffffffc02092a6:	a029                	j	ffffffffc02092b0 <sfs_do_mount+0x154>
ffffffffc02092a8:	6785                	lui	a5,0x1
ffffffffc02092aa:	9abe                	add	s5,s5,a5
ffffffffc02092ac:	098a8263          	beq	s5,s8,ffffffffc0209330 <sfs_do_mount+0x1d4>
ffffffffc02092b0:	015b06bb          	addw	a3,s6,s5
ffffffffc02092b4:	1682                	slli	a3,a3,0x20
ffffffffc02092b6:	6605                	lui	a2,0x1
ffffffffc02092b8:	85d6                	mv	a1,s5
ffffffffc02092ba:	9281                	srli	a3,a3,0x20
ffffffffc02092bc:	1008                	addi	a0,sp,32
ffffffffc02092be:	f75fb0ef          	jal	ffffffffc0205232 <iobuf_init>
ffffffffc02092c2:	709c                	ld	a5,32(s1)
ffffffffc02092c4:	85aa                	mv	a1,a0
ffffffffc02092c6:	4601                	li	a2,0
ffffffffc02092c8:	8526                	mv	a0,s1
ffffffffc02092ca:	9782                	jalr	a5
ffffffffc02092cc:	dd71                	beqz	a0,ffffffffc02092a8 <sfs_do_mount+0x14c>
ffffffffc02092ce:	e42a                	sd	a0,8(sp)
ffffffffc02092d0:	856a                	mv	a0,s10
ffffffffc02092d2:	bebff0ef          	jal	ffffffffc0208ebc <bitmap_destroy>
ffffffffc02092d6:	69a2                	ld	s3,8(sp)
ffffffffc02092d8:	7b46                	ld	s6,112(sp)
ffffffffc02092da:	7c06                	ld	s8,96(sp)
ffffffffc02092dc:	856e                	mv	a0,s11
ffffffffc02092de:	d9df80ef          	jal	ffffffffc020207a <kfree>
ffffffffc02092e2:	7ae6                	ld	s5,120(sp)
ffffffffc02092e4:	6ce6                	ld	s9,88(sp)
ffffffffc02092e6:	6d46                	ld	s10,80(sp)
ffffffffc02092e8:	6da6                	ld	s11,72(sp)
ffffffffc02092ea:	854a                	mv	a0,s2
ffffffffc02092ec:	d8ff80ef          	jal	ffffffffc020207a <kfree>
ffffffffc02092f0:	8522                	mv	a0,s0
ffffffffc02092f2:	d89f80ef          	jal	ffffffffc020207a <kfree>
ffffffffc02092f6:	740a                	ld	s0,160(sp)
ffffffffc02092f8:	64ea                	ld	s1,152(sp)
ffffffffc02092fa:	694a                	ld	s2,144(sp)
ffffffffc02092fc:	6a0a                	ld	s4,128(sp)
ffffffffc02092fe:	7ba6                	ld	s7,104(sp)
ffffffffc0209300:	70aa                	ld	ra,168(sp)
ffffffffc0209302:	854e                	mv	a0,s3
ffffffffc0209304:	69aa                	ld	s3,136(sp)
ffffffffc0209306:	614d                	addi	sp,sp,176
ffffffffc0209308:	8082                	ret
ffffffffc020930a:	59f1                	li	s3,-4
ffffffffc020930c:	b7d5                	j	ffffffffc02092f0 <sfs_do_mount+0x194>
ffffffffc020930e:	85be                	mv	a1,a5
ffffffffc0209310:	00005517          	auipc	a0,0x5
ffffffffc0209314:	f7850513          	addi	a0,a0,-136 # ffffffffc020e288 <etext+0x2e86>
ffffffffc0209318:	e8ff60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020931c:	59f5                	li	s3,-3
ffffffffc020931e:	b7f1                	j	ffffffffc02092ea <sfs_do_mount+0x18e>
ffffffffc0209320:	00005517          	auipc	a0,0x5
ffffffffc0209324:	f3050513          	addi	a0,a0,-208 # ffffffffc020e250 <etext+0x2e4e>
ffffffffc0209328:	e7ff60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020932c:	59f5                	li	s3,-3
ffffffffc020932e:	bf75                	j	ffffffffc02092ea <sfs_do_mount+0x18e>
ffffffffc0209330:	7b46                	ld	s6,112(sp)
ffffffffc0209332:	00442903          	lw	s2,4(s0)
ffffffffc0209336:	0a0c8863          	beqz	s9,ffffffffc02093e6 <sfs_do_mount+0x28a>
ffffffffc020933a:	4481                	li	s1,0
ffffffffc020933c:	85a6                	mv	a1,s1
ffffffffc020933e:	856a                	mv	a0,s10
ffffffffc0209340:	b05ff0ef          	jal	ffffffffc0208e44 <bitmap_test>
ffffffffc0209344:	c111                	beqz	a0,ffffffffc0209348 <sfs_do_mount+0x1ec>
ffffffffc0209346:	2a05                	addiw	s4,s4,1
ffffffffc0209348:	2485                	addiw	s1,s1,1
ffffffffc020934a:	fe9c99e3          	bne	s9,s1,ffffffffc020933c <sfs_do_mount+0x1e0>
ffffffffc020934e:	441c                	lw	a5,8(s0)
ffffffffc0209350:	0f479a63          	bne	a5,s4,ffffffffc0209444 <sfs_do_mount+0x2e8>
ffffffffc0209354:	05040513          	addi	a0,s0,80
ffffffffc0209358:	04043023          	sd	zero,64(s0)
ffffffffc020935c:	4585                	li	a1,1
ffffffffc020935e:	834fb0ef          	jal	ffffffffc0204392 <sem_init>
ffffffffc0209362:	06840513          	addi	a0,s0,104
ffffffffc0209366:	4585                	li	a1,1
ffffffffc0209368:	82afb0ef          	jal	ffffffffc0204392 <sem_init>
ffffffffc020936c:	08040513          	addi	a0,s0,128
ffffffffc0209370:	4585                	li	a1,1
ffffffffc0209372:	820fb0ef          	jal	ffffffffc0204392 <sem_init>
ffffffffc0209376:	09840793          	addi	a5,s0,152
ffffffffc020937a:	4149063b          	subw	a2,s2,s4
ffffffffc020937e:	f05c                	sd	a5,160(s0)
ffffffffc0209380:	ec5c                	sd	a5,152(s0)
ffffffffc0209382:	874a                	mv	a4,s2
ffffffffc0209384:	86d2                	mv	a3,s4
ffffffffc0209386:	00c40593          	addi	a1,s0,12
ffffffffc020938a:	00005517          	auipc	a0,0x5
ffffffffc020938e:	f8e50513          	addi	a0,a0,-114 # ffffffffc020e318 <etext+0x2f16>
ffffffffc0209392:	e15f60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0209396:	00000617          	auipc	a2,0x0
ffffffffc020939a:	c9260613          	addi	a2,a2,-878 # ffffffffc0209028 <sfs_sync>
ffffffffc020939e:	00000697          	auipc	a3,0x0
ffffffffc02093a2:	d6668693          	addi	a3,a3,-666 # ffffffffc0209104 <sfs_get_root>
ffffffffc02093a6:	00000717          	auipc	a4,0x0
ffffffffc02093aa:	b6e70713          	addi	a4,a4,-1170 # ffffffffc0208f14 <sfs_unmount>
ffffffffc02093ae:	00000797          	auipc	a5,0x0
ffffffffc02093b2:	bea78793          	addi	a5,a5,-1046 # ffffffffc0208f98 <sfs_cleanup>
ffffffffc02093b6:	fc50                	sd	a2,184(s0)
ffffffffc02093b8:	e074                	sd	a3,192(s0)
ffffffffc02093ba:	e478                	sd	a4,200(s0)
ffffffffc02093bc:	e87c                	sd	a5,208(s0)
ffffffffc02093be:	008bb023          	sd	s0,0(s7)
ffffffffc02093c2:	64ea                	ld	s1,152(sp)
ffffffffc02093c4:	740a                	ld	s0,160(sp)
ffffffffc02093c6:	694a                	ld	s2,144(sp)
ffffffffc02093c8:	6a0a                	ld	s4,128(sp)
ffffffffc02093ca:	7ae6                	ld	s5,120(sp)
ffffffffc02093cc:	7ba6                	ld	s7,104(sp)
ffffffffc02093ce:	7c06                	ld	s8,96(sp)
ffffffffc02093d0:	6ce6                	ld	s9,88(sp)
ffffffffc02093d2:	6d46                	ld	s10,80(sp)
ffffffffc02093d4:	6da6                	ld	s11,72(sp)
ffffffffc02093d6:	b72d                	j	ffffffffc0209300 <sfs_do_mount+0x1a4>
ffffffffc02093d8:	59f1                	li	s3,-4
ffffffffc02093da:	b709                	j	ffffffffc02092dc <sfs_do_mount+0x180>
ffffffffc02093dc:	59c9                	li	s3,-14
ffffffffc02093de:	b70d                	j	ffffffffc0209300 <sfs_do_mount+0x1a4>
ffffffffc02093e0:	6da6                	ld	s11,72(sp)
ffffffffc02093e2:	59f1                	li	s3,-4
ffffffffc02093e4:	b719                	j	ffffffffc02092ea <sfs_do_mount+0x18e>
ffffffffc02093e6:	4a01                	li	s4,0
ffffffffc02093e8:	b79d                	j	ffffffffc020934e <sfs_do_mount+0x1f2>
ffffffffc02093ea:	740a                	ld	s0,160(sp)
ffffffffc02093ec:	64ea                	ld	s1,152(sp)
ffffffffc02093ee:	7ba6                	ld	s7,104(sp)
ffffffffc02093f0:	59f1                	li	s3,-4
ffffffffc02093f2:	b739                	j	ffffffffc0209300 <sfs_do_mount+0x1a4>
ffffffffc02093f4:	00005697          	auipc	a3,0x5
ffffffffc02093f8:	ec468693          	addi	a3,a3,-316 # ffffffffc020e2b8 <etext+0x2eb6>
ffffffffc02093fc:	00002617          	auipc	a2,0x2
ffffffffc0209400:	44460613          	addi	a2,a2,1092 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209404:	08300593          	li	a1,131
ffffffffc0209408:	00005517          	auipc	a0,0x5
ffffffffc020940c:	db850513          	addi	a0,a0,-584 # ffffffffc020e1c0 <etext+0x2dbe>
ffffffffc0209410:	f8da                	sd	s6,112(sp)
ffffffffc0209412:	f0e2                	sd	s8,96(sp)
ffffffffc0209414:	836f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209418:	00005697          	auipc	a3,0x5
ffffffffc020941c:	d7868693          	addi	a3,a3,-648 # ffffffffc020e190 <etext+0x2d8e>
ffffffffc0209420:	00002617          	auipc	a2,0x2
ffffffffc0209424:	42060613          	addi	a2,a2,1056 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209428:	0a300593          	li	a1,163
ffffffffc020942c:	00005517          	auipc	a0,0x5
ffffffffc0209430:	d9450513          	addi	a0,a0,-620 # ffffffffc020e1c0 <etext+0x2dbe>
ffffffffc0209434:	fcd6                	sd	s5,120(sp)
ffffffffc0209436:	f8da                	sd	s6,112(sp)
ffffffffc0209438:	f0e2                	sd	s8,96(sp)
ffffffffc020943a:	ece6                	sd	s9,88(sp)
ffffffffc020943c:	e8ea                	sd	s10,80(sp)
ffffffffc020943e:	e4ee                	sd	s11,72(sp)
ffffffffc0209440:	80af70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209444:	00005697          	auipc	a3,0x5
ffffffffc0209448:	ea468693          	addi	a3,a3,-348 # ffffffffc020e2e8 <etext+0x2ee6>
ffffffffc020944c:	00002617          	auipc	a2,0x2
ffffffffc0209450:	3f460613          	addi	a2,a2,1012 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209454:	0e000593          	li	a1,224
ffffffffc0209458:	00005517          	auipc	a0,0x5
ffffffffc020945c:	d6850513          	addi	a0,a0,-664 # ffffffffc020e1c0 <etext+0x2dbe>
ffffffffc0209460:	f8da                	sd	s6,112(sp)
ffffffffc0209462:	fe9f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209466 <sfs_mount>:
ffffffffc0209466:	00000597          	auipc	a1,0x0
ffffffffc020946a:	cf658593          	addi	a1,a1,-778 # ffffffffc020915c <sfs_do_mount>
ffffffffc020946e:	fccfe06f          	j	ffffffffc0207c3a <vfs_mount>

ffffffffc0209472 <sfs_opendir>:
ffffffffc0209472:	0235f593          	andi	a1,a1,35
ffffffffc0209476:	e199                	bnez	a1,ffffffffc020947c <sfs_opendir+0xa>
ffffffffc0209478:	4501                	li	a0,0
ffffffffc020947a:	8082                	ret
ffffffffc020947c:	553d                	li	a0,-17
ffffffffc020947e:	8082                	ret

ffffffffc0209480 <sfs_openfile>:
ffffffffc0209480:	4501                	li	a0,0
ffffffffc0209482:	8082                	ret

ffffffffc0209484 <sfs_gettype>:
ffffffffc0209484:	1141                	addi	sp,sp,-16
ffffffffc0209486:	e406                	sd	ra,8(sp)
ffffffffc0209488:	c529                	beqz	a0,ffffffffc02094d2 <sfs_gettype+0x4e>
ffffffffc020948a:	4d38                	lw	a4,88(a0)
ffffffffc020948c:	6785                	lui	a5,0x1
ffffffffc020948e:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209492:	04f71063          	bne	a4,a5,ffffffffc02094d2 <sfs_gettype+0x4e>
ffffffffc0209496:	6118                	ld	a4,0(a0)
ffffffffc0209498:	4789                	li	a5,2
ffffffffc020949a:	00475683          	lhu	a3,4(a4)
ffffffffc020949e:	02f68463          	beq	a3,a5,ffffffffc02094c6 <sfs_gettype+0x42>
ffffffffc02094a2:	478d                	li	a5,3
ffffffffc02094a4:	00f68b63          	beq	a3,a5,ffffffffc02094ba <sfs_gettype+0x36>
ffffffffc02094a8:	4705                	li	a4,1
ffffffffc02094aa:	6785                	lui	a5,0x1
ffffffffc02094ac:	04e69363          	bne	a3,a4,ffffffffc02094f2 <sfs_gettype+0x6e>
ffffffffc02094b0:	60a2                	ld	ra,8(sp)
ffffffffc02094b2:	c19c                	sw	a5,0(a1)
ffffffffc02094b4:	4501                	li	a0,0
ffffffffc02094b6:	0141                	addi	sp,sp,16
ffffffffc02094b8:	8082                	ret
ffffffffc02094ba:	60a2                	ld	ra,8(sp)
ffffffffc02094bc:	678d                	lui	a5,0x3
ffffffffc02094be:	c19c                	sw	a5,0(a1)
ffffffffc02094c0:	4501                	li	a0,0
ffffffffc02094c2:	0141                	addi	sp,sp,16
ffffffffc02094c4:	8082                	ret
ffffffffc02094c6:	60a2                	ld	ra,8(sp)
ffffffffc02094c8:	6789                	lui	a5,0x2
ffffffffc02094ca:	c19c                	sw	a5,0(a1)
ffffffffc02094cc:	4501                	li	a0,0
ffffffffc02094ce:	0141                	addi	sp,sp,16
ffffffffc02094d0:	8082                	ret
ffffffffc02094d2:	00005697          	auipc	a3,0x5
ffffffffc02094d6:	e6668693          	addi	a3,a3,-410 # ffffffffc020e338 <etext+0x2f36>
ffffffffc02094da:	00002617          	auipc	a2,0x2
ffffffffc02094de:	36660613          	addi	a2,a2,870 # ffffffffc020b840 <etext+0x43e>
ffffffffc02094e2:	38600593          	li	a1,902
ffffffffc02094e6:	00005517          	auipc	a0,0x5
ffffffffc02094ea:	e8a50513          	addi	a0,a0,-374 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc02094ee:	f5df60ef          	jal	ffffffffc020044a <__panic>
ffffffffc02094f2:	00005617          	auipc	a2,0x5
ffffffffc02094f6:	e9660613          	addi	a2,a2,-362 # ffffffffc020e388 <etext+0x2f86>
ffffffffc02094fa:	39200593          	li	a1,914
ffffffffc02094fe:	00005517          	auipc	a0,0x5
ffffffffc0209502:	e7250513          	addi	a0,a0,-398 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209506:	f45f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020950a <sfs_fsync>:
ffffffffc020950a:	7530                	ld	a2,104(a0)
ffffffffc020950c:	7179                	addi	sp,sp,-48
ffffffffc020950e:	f406                	sd	ra,40(sp)
ffffffffc0209510:	ca2d                	beqz	a2,ffffffffc0209582 <sfs_fsync+0x78>
ffffffffc0209512:	0b062703          	lw	a4,176(a2)
ffffffffc0209516:	e735                	bnez	a4,ffffffffc0209582 <sfs_fsync+0x78>
ffffffffc0209518:	4d34                	lw	a3,88(a0)
ffffffffc020951a:	6705                	lui	a4,0x1
ffffffffc020951c:	23570713          	addi	a4,a4,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209520:	08e69263          	bne	a3,a4,ffffffffc02095a4 <sfs_fsync+0x9a>
ffffffffc0209524:	6914                	ld	a3,16(a0)
ffffffffc0209526:	4701                	li	a4,0
ffffffffc0209528:	e689                	bnez	a3,ffffffffc0209532 <sfs_fsync+0x28>
ffffffffc020952a:	70a2                	ld	ra,40(sp)
ffffffffc020952c:	853a                	mv	a0,a4
ffffffffc020952e:	6145                	addi	sp,sp,48
ffffffffc0209530:	8082                	ret
ffffffffc0209532:	f022                	sd	s0,32(sp)
ffffffffc0209534:	e42a                	sd	a0,8(sp)
ffffffffc0209536:	02050413          	addi	s0,a0,32
ffffffffc020953a:	02050513          	addi	a0,a0,32
ffffffffc020953e:	ec3a                	sd	a4,24(sp)
ffffffffc0209540:	e832                	sd	a2,16(sp)
ffffffffc0209542:	e5bfa0ef          	jal	ffffffffc020439c <down>
ffffffffc0209546:	67a2                	ld	a5,8(sp)
ffffffffc0209548:	6762                	ld	a4,24(sp)
ffffffffc020954a:	6b94                	ld	a3,16(a5)
ffffffffc020954c:	ea99                	bnez	a3,ffffffffc0209562 <sfs_fsync+0x58>
ffffffffc020954e:	8522                	mv	a0,s0
ffffffffc0209550:	e43a                	sd	a4,8(sp)
ffffffffc0209552:	e47fa0ef          	jal	ffffffffc0204398 <up>
ffffffffc0209556:	6722                	ld	a4,8(sp)
ffffffffc0209558:	7402                	ld	s0,32(sp)
ffffffffc020955a:	70a2                	ld	ra,40(sp)
ffffffffc020955c:	853a                	mv	a0,a4
ffffffffc020955e:	6145                	addi	sp,sp,48
ffffffffc0209560:	8082                	ret
ffffffffc0209562:	4794                	lw	a3,8(a5)
ffffffffc0209564:	638c                	ld	a1,0(a5)
ffffffffc0209566:	6542                	ld	a0,16(sp)
ffffffffc0209568:	4701                	li	a4,0
ffffffffc020956a:	0007b823          	sd	zero,16(a5) # 2010 <_binary_bin_swap_img_size-0x5cf0>
ffffffffc020956e:	04000613          	li	a2,64
ffffffffc0209572:	718010ef          	jal	ffffffffc020ac8a <sfs_wbuf>
ffffffffc0209576:	872a                	mv	a4,a0
ffffffffc0209578:	d979                	beqz	a0,ffffffffc020954e <sfs_fsync+0x44>
ffffffffc020957a:	67a2                	ld	a5,8(sp)
ffffffffc020957c:	4685                	li	a3,1
ffffffffc020957e:	eb94                	sd	a3,16(a5)
ffffffffc0209580:	b7f9                	j	ffffffffc020954e <sfs_fsync+0x44>
ffffffffc0209582:	00005697          	auipc	a3,0x5
ffffffffc0209586:	c0e68693          	addi	a3,a3,-1010 # ffffffffc020e190 <etext+0x2d8e>
ffffffffc020958a:	00002617          	auipc	a2,0x2
ffffffffc020958e:	2b660613          	addi	a2,a2,694 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209592:	2ca00593          	li	a1,714
ffffffffc0209596:	00005517          	auipc	a0,0x5
ffffffffc020959a:	dda50513          	addi	a0,a0,-550 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020959e:	f022                	sd	s0,32(sp)
ffffffffc02095a0:	eabf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc02095a4:	00005697          	auipc	a3,0x5
ffffffffc02095a8:	d9468693          	addi	a3,a3,-620 # ffffffffc020e338 <etext+0x2f36>
ffffffffc02095ac:	00002617          	auipc	a2,0x2
ffffffffc02095b0:	29460613          	addi	a2,a2,660 # ffffffffc020b840 <etext+0x43e>
ffffffffc02095b4:	2cb00593          	li	a1,715
ffffffffc02095b8:	00005517          	auipc	a0,0x5
ffffffffc02095bc:	db850513          	addi	a0,a0,-584 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc02095c0:	f022                	sd	s0,32(sp)
ffffffffc02095c2:	e89f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc02095c6 <sfs_fstat>:
ffffffffc02095c6:	1101                	addi	sp,sp,-32
ffffffffc02095c8:	e822                	sd	s0,16(sp)
ffffffffc02095ca:	e426                	sd	s1,8(sp)
ffffffffc02095cc:	842a                	mv	s0,a0
ffffffffc02095ce:	84ae                	mv	s1,a1
ffffffffc02095d0:	852e                	mv	a0,a1
ffffffffc02095d2:	02000613          	li	a2,32
ffffffffc02095d6:	4581                	li	a1,0
ffffffffc02095d8:	ec06                	sd	ra,24(sp)
ffffffffc02095da:	5c1010ef          	jal	ffffffffc020b39a <memset>
ffffffffc02095de:	c439                	beqz	s0,ffffffffc020962c <sfs_fstat+0x66>
ffffffffc02095e0:	783c                	ld	a5,112(s0)
ffffffffc02095e2:	c7a9                	beqz	a5,ffffffffc020962c <sfs_fstat+0x66>
ffffffffc02095e4:	6bbc                	ld	a5,80(a5)
ffffffffc02095e6:	c3b9                	beqz	a5,ffffffffc020962c <sfs_fstat+0x66>
ffffffffc02095e8:	00004597          	auipc	a1,0x4
ffffffffc02095ec:	7b858593          	addi	a1,a1,1976 # ffffffffc020dda0 <etext+0x299e>
ffffffffc02095f0:	8522                	mv	a0,s0
ffffffffc02095f2:	85afe0ef          	jal	ffffffffc020764c <inode_check>
ffffffffc02095f6:	783c                	ld	a5,112(s0)
ffffffffc02095f8:	85a6                	mv	a1,s1
ffffffffc02095fa:	8522                	mv	a0,s0
ffffffffc02095fc:	6bbc                	ld	a5,80(a5)
ffffffffc02095fe:	9782                	jalr	a5
ffffffffc0209600:	e10d                	bnez	a0,ffffffffc0209622 <sfs_fstat+0x5c>
ffffffffc0209602:	4c38                	lw	a4,88(s0)
ffffffffc0209604:	6785                	lui	a5,0x1
ffffffffc0209606:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020960a:	04f71163          	bne	a4,a5,ffffffffc020964c <sfs_fstat+0x86>
ffffffffc020960e:	601c                	ld	a5,0(s0)
ffffffffc0209610:	0067d683          	lhu	a3,6(a5)
ffffffffc0209614:	0087e703          	lwu	a4,8(a5)
ffffffffc0209618:	0007e783          	lwu	a5,0(a5)
ffffffffc020961c:	e494                	sd	a3,8(s1)
ffffffffc020961e:	e898                	sd	a4,16(s1)
ffffffffc0209620:	ec9c                	sd	a5,24(s1)
ffffffffc0209622:	60e2                	ld	ra,24(sp)
ffffffffc0209624:	6442                	ld	s0,16(sp)
ffffffffc0209626:	64a2                	ld	s1,8(sp)
ffffffffc0209628:	6105                	addi	sp,sp,32
ffffffffc020962a:	8082                	ret
ffffffffc020962c:	00004697          	auipc	a3,0x4
ffffffffc0209630:	70c68693          	addi	a3,a3,1804 # ffffffffc020dd38 <etext+0x2936>
ffffffffc0209634:	00002617          	auipc	a2,0x2
ffffffffc0209638:	20c60613          	addi	a2,a2,524 # ffffffffc020b840 <etext+0x43e>
ffffffffc020963c:	2bb00593          	li	a1,699
ffffffffc0209640:	00005517          	auipc	a0,0x5
ffffffffc0209644:	d3050513          	addi	a0,a0,-720 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209648:	e03f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020964c:	00005697          	auipc	a3,0x5
ffffffffc0209650:	cec68693          	addi	a3,a3,-788 # ffffffffc020e338 <etext+0x2f36>
ffffffffc0209654:	00002617          	auipc	a2,0x2
ffffffffc0209658:	1ec60613          	addi	a2,a2,492 # ffffffffc020b840 <etext+0x43e>
ffffffffc020965c:	2be00593          	li	a1,702
ffffffffc0209660:	00005517          	auipc	a0,0x5
ffffffffc0209664:	d1050513          	addi	a0,a0,-752 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209668:	de3f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020966c <sfs_tryseek>:
ffffffffc020966c:	08000737          	lui	a4,0x8000
ffffffffc0209670:	04e5f863          	bgeu	a1,a4,ffffffffc02096c0 <sfs_tryseek+0x54>
ffffffffc0209674:	1101                	addi	sp,sp,-32
ffffffffc0209676:	ec06                	sd	ra,24(sp)
ffffffffc0209678:	c531                	beqz	a0,ffffffffc02096c4 <sfs_tryseek+0x58>
ffffffffc020967a:	4d30                	lw	a2,88(a0)
ffffffffc020967c:	6685                	lui	a3,0x1
ffffffffc020967e:	23568693          	addi	a3,a3,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209682:	04d61163          	bne	a2,a3,ffffffffc02096c4 <sfs_tryseek+0x58>
ffffffffc0209686:	6114                	ld	a3,0(a0)
ffffffffc0209688:	0006e683          	lwu	a3,0(a3)
ffffffffc020968c:	02b6d663          	bge	a3,a1,ffffffffc02096b8 <sfs_tryseek+0x4c>
ffffffffc0209690:	7934                	ld	a3,112(a0)
ffffffffc0209692:	caa9                	beqz	a3,ffffffffc02096e4 <sfs_tryseek+0x78>
ffffffffc0209694:	72b4                	ld	a3,96(a3)
ffffffffc0209696:	c6b9                	beqz	a3,ffffffffc02096e4 <sfs_tryseek+0x78>
ffffffffc0209698:	e02e                	sd	a1,0(sp)
ffffffffc020969a:	00004597          	auipc	a1,0x4
ffffffffc020969e:	5f658593          	addi	a1,a1,1526 # ffffffffc020dc90 <etext+0x288e>
ffffffffc02096a2:	e42a                	sd	a0,8(sp)
ffffffffc02096a4:	fa9fd0ef          	jal	ffffffffc020764c <inode_check>
ffffffffc02096a8:	67a2                	ld	a5,8(sp)
ffffffffc02096aa:	6582                	ld	a1,0(sp)
ffffffffc02096ac:	60e2                	ld	ra,24(sp)
ffffffffc02096ae:	7bb4                	ld	a3,112(a5)
ffffffffc02096b0:	853e                	mv	a0,a5
ffffffffc02096b2:	72bc                	ld	a5,96(a3)
ffffffffc02096b4:	6105                	addi	sp,sp,32
ffffffffc02096b6:	8782                	jr	a5
ffffffffc02096b8:	60e2                	ld	ra,24(sp)
ffffffffc02096ba:	4501                	li	a0,0
ffffffffc02096bc:	6105                	addi	sp,sp,32
ffffffffc02096be:	8082                	ret
ffffffffc02096c0:	5575                	li	a0,-3
ffffffffc02096c2:	8082                	ret
ffffffffc02096c4:	00005697          	auipc	a3,0x5
ffffffffc02096c8:	c7468693          	addi	a3,a3,-908 # ffffffffc020e338 <etext+0x2f36>
ffffffffc02096cc:	00002617          	auipc	a2,0x2
ffffffffc02096d0:	17460613          	addi	a2,a2,372 # ffffffffc020b840 <etext+0x43e>
ffffffffc02096d4:	39d00593          	li	a1,925
ffffffffc02096d8:	00005517          	auipc	a0,0x5
ffffffffc02096dc:	c9850513          	addi	a0,a0,-872 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc02096e0:	d6bf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc02096e4:	00004697          	auipc	a3,0x4
ffffffffc02096e8:	55468693          	addi	a3,a3,1364 # ffffffffc020dc38 <etext+0x2836>
ffffffffc02096ec:	00002617          	auipc	a2,0x2
ffffffffc02096f0:	15460613          	addi	a2,a2,340 # ffffffffc020b840 <etext+0x43e>
ffffffffc02096f4:	39f00593          	li	a1,927
ffffffffc02096f8:	00005517          	auipc	a0,0x5
ffffffffc02096fc:	c7850513          	addi	a0,a0,-904 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209700:	d4bf60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209704 <sfs_close>:
ffffffffc0209704:	1141                	addi	sp,sp,-16
ffffffffc0209706:	e406                	sd	ra,8(sp)
ffffffffc0209708:	e022                	sd	s0,0(sp)
ffffffffc020970a:	c11d                	beqz	a0,ffffffffc0209730 <sfs_close+0x2c>
ffffffffc020970c:	793c                	ld	a5,112(a0)
ffffffffc020970e:	842a                	mv	s0,a0
ffffffffc0209710:	c385                	beqz	a5,ffffffffc0209730 <sfs_close+0x2c>
ffffffffc0209712:	7b9c                	ld	a5,48(a5)
ffffffffc0209714:	cf91                	beqz	a5,ffffffffc0209730 <sfs_close+0x2c>
ffffffffc0209716:	00004597          	auipc	a1,0x4
ffffffffc020971a:	97258593          	addi	a1,a1,-1678 # ffffffffc020d088 <etext+0x1c86>
ffffffffc020971e:	f2ffd0ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0209722:	783c                	ld	a5,112(s0)
ffffffffc0209724:	8522                	mv	a0,s0
ffffffffc0209726:	6402                	ld	s0,0(sp)
ffffffffc0209728:	60a2                	ld	ra,8(sp)
ffffffffc020972a:	7b9c                	ld	a5,48(a5)
ffffffffc020972c:	0141                	addi	sp,sp,16
ffffffffc020972e:	8782                	jr	a5
ffffffffc0209730:	00004697          	auipc	a3,0x4
ffffffffc0209734:	90868693          	addi	a3,a3,-1784 # ffffffffc020d038 <etext+0x1c36>
ffffffffc0209738:	00002617          	auipc	a2,0x2
ffffffffc020973c:	10860613          	addi	a2,a2,264 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209740:	21c00593          	li	a1,540
ffffffffc0209744:	00005517          	auipc	a0,0x5
ffffffffc0209748:	c2c50513          	addi	a0,a0,-980 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020974c:	cfff60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209750 <sfs_io.part.0>:
ffffffffc0209750:	1141                	addi	sp,sp,-16
ffffffffc0209752:	00005697          	auipc	a3,0x5
ffffffffc0209756:	be668693          	addi	a3,a3,-1050 # ffffffffc020e338 <etext+0x2f36>
ffffffffc020975a:	00002617          	auipc	a2,0x2
ffffffffc020975e:	0e660613          	addi	a2,a2,230 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209762:	29a00593          	li	a1,666
ffffffffc0209766:	00005517          	auipc	a0,0x5
ffffffffc020976a:	c0a50513          	addi	a0,a0,-1014 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020976e:	e406                	sd	ra,8(sp)
ffffffffc0209770:	cdbf60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209774 <sfs_block_free>:
ffffffffc0209774:	1101                	addi	sp,sp,-32
ffffffffc0209776:	e822                	sd	s0,16(sp)
ffffffffc0209778:	e426                	sd	s1,8(sp)
ffffffffc020977a:	ec06                	sd	ra,24(sp)
ffffffffc020977c:	84ae                	mv	s1,a1
ffffffffc020977e:	842a                	mv	s0,a0
ffffffffc0209780:	c595                	beqz	a1,ffffffffc02097ac <sfs_block_free+0x38>
ffffffffc0209782:	415c                	lw	a5,4(a0)
ffffffffc0209784:	02f5f463          	bgeu	a1,a5,ffffffffc02097ac <sfs_block_free+0x38>
ffffffffc0209788:	7d08                	ld	a0,56(a0)
ffffffffc020978a:	ebaff0ef          	jal	ffffffffc0208e44 <bitmap_test>
ffffffffc020978e:	ed0d                	bnez	a0,ffffffffc02097c8 <sfs_block_free+0x54>
ffffffffc0209790:	7c08                	ld	a0,56(s0)
ffffffffc0209792:	85a6                	mv	a1,s1
ffffffffc0209794:	ed8ff0ef          	jal	ffffffffc0208e6c <bitmap_free>
ffffffffc0209798:	441c                	lw	a5,8(s0)
ffffffffc020979a:	4705                	li	a4,1
ffffffffc020979c:	60e2                	ld	ra,24(sp)
ffffffffc020979e:	2785                	addiw	a5,a5,1
ffffffffc02097a0:	e038                	sd	a4,64(s0)
ffffffffc02097a2:	c41c                	sw	a5,8(s0)
ffffffffc02097a4:	6442                	ld	s0,16(sp)
ffffffffc02097a6:	64a2                	ld	s1,8(sp)
ffffffffc02097a8:	6105                	addi	sp,sp,32
ffffffffc02097aa:	8082                	ret
ffffffffc02097ac:	4054                	lw	a3,4(s0)
ffffffffc02097ae:	8726                	mv	a4,s1
ffffffffc02097b0:	00005617          	auipc	a2,0x5
ffffffffc02097b4:	bf060613          	addi	a2,a2,-1040 # ffffffffc020e3a0 <etext+0x2f9e>
ffffffffc02097b8:	05300593          	li	a1,83
ffffffffc02097bc:	00005517          	auipc	a0,0x5
ffffffffc02097c0:	bb450513          	addi	a0,a0,-1100 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc02097c4:	c87f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc02097c8:	00005697          	auipc	a3,0x5
ffffffffc02097cc:	c1068693          	addi	a3,a3,-1008 # ffffffffc020e3d8 <etext+0x2fd6>
ffffffffc02097d0:	00002617          	auipc	a2,0x2
ffffffffc02097d4:	07060613          	addi	a2,a2,112 # ffffffffc020b840 <etext+0x43e>
ffffffffc02097d8:	06a00593          	li	a1,106
ffffffffc02097dc:	00005517          	auipc	a0,0x5
ffffffffc02097e0:	b9450513          	addi	a0,a0,-1132 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc02097e4:	c67f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc02097e8 <sfs_reclaim>:
ffffffffc02097e8:	1101                	addi	sp,sp,-32
ffffffffc02097ea:	e426                	sd	s1,8(sp)
ffffffffc02097ec:	7524                	ld	s1,104(a0)
ffffffffc02097ee:	ec06                	sd	ra,24(sp)
ffffffffc02097f0:	e822                	sd	s0,16(sp)
ffffffffc02097f2:	e04a                	sd	s2,0(sp)
ffffffffc02097f4:	0e048963          	beqz	s1,ffffffffc02098e6 <sfs_reclaim+0xfe>
ffffffffc02097f8:	0b04a783          	lw	a5,176(s1)
ffffffffc02097fc:	0e079563          	bnez	a5,ffffffffc02098e6 <sfs_reclaim+0xfe>
ffffffffc0209800:	4d38                	lw	a4,88(a0)
ffffffffc0209802:	6785                	lui	a5,0x1
ffffffffc0209804:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209808:	842a                	mv	s0,a0
ffffffffc020980a:	10f71e63          	bne	a4,a5,ffffffffc0209926 <sfs_reclaim+0x13e>
ffffffffc020980e:	8526                	mv	a0,s1
ffffffffc0209810:	62e010ef          	jal	ffffffffc020ae3e <lock_sfs_fs>
ffffffffc0209814:	4c1c                	lw	a5,24(s0)
ffffffffc0209816:	0ef05863          	blez	a5,ffffffffc0209906 <sfs_reclaim+0x11e>
ffffffffc020981a:	37fd                	addiw	a5,a5,-1
ffffffffc020981c:	cc1c                	sw	a5,24(s0)
ffffffffc020981e:	ebd9                	bnez	a5,ffffffffc02098b4 <sfs_reclaim+0xcc>
ffffffffc0209820:	05c42903          	lw	s2,92(s0)
ffffffffc0209824:	08091863          	bnez	s2,ffffffffc02098b4 <sfs_reclaim+0xcc>
ffffffffc0209828:	601c                	ld	a5,0(s0)
ffffffffc020982a:	0067d783          	lhu	a5,6(a5)
ffffffffc020982e:	e785                	bnez	a5,ffffffffc0209856 <sfs_reclaim+0x6e>
ffffffffc0209830:	783c                	ld	a5,112(s0)
ffffffffc0209832:	10078a63          	beqz	a5,ffffffffc0209946 <sfs_reclaim+0x15e>
ffffffffc0209836:	73bc                	ld	a5,96(a5)
ffffffffc0209838:	10078763          	beqz	a5,ffffffffc0209946 <sfs_reclaim+0x15e>
ffffffffc020983c:	00004597          	auipc	a1,0x4
ffffffffc0209840:	45458593          	addi	a1,a1,1108 # ffffffffc020dc90 <etext+0x288e>
ffffffffc0209844:	8522                	mv	a0,s0
ffffffffc0209846:	e07fd0ef          	jal	ffffffffc020764c <inode_check>
ffffffffc020984a:	783c                	ld	a5,112(s0)
ffffffffc020984c:	8522                	mv	a0,s0
ffffffffc020984e:	4581                	li	a1,0
ffffffffc0209850:	73bc                	ld	a5,96(a5)
ffffffffc0209852:	9782                	jalr	a5
ffffffffc0209854:	e559                	bnez	a0,ffffffffc02098e2 <sfs_reclaim+0xfa>
ffffffffc0209856:	681c                	ld	a5,16(s0)
ffffffffc0209858:	c39d                	beqz	a5,ffffffffc020987e <sfs_reclaim+0x96>
ffffffffc020985a:	783c                	ld	a5,112(s0)
ffffffffc020985c:	10078563          	beqz	a5,ffffffffc0209966 <sfs_reclaim+0x17e>
ffffffffc0209860:	7b9c                	ld	a5,48(a5)
ffffffffc0209862:	10078263          	beqz	a5,ffffffffc0209966 <sfs_reclaim+0x17e>
ffffffffc0209866:	8522                	mv	a0,s0
ffffffffc0209868:	00004597          	auipc	a1,0x4
ffffffffc020986c:	82058593          	addi	a1,a1,-2016 # ffffffffc020d088 <etext+0x1c86>
ffffffffc0209870:	dddfd0ef          	jal	ffffffffc020764c <inode_check>
ffffffffc0209874:	783c                	ld	a5,112(s0)
ffffffffc0209876:	8522                	mv	a0,s0
ffffffffc0209878:	7b9c                	ld	a5,48(a5)
ffffffffc020987a:	9782                	jalr	a5
ffffffffc020987c:	e13d                	bnez	a0,ffffffffc02098e2 <sfs_reclaim+0xfa>
ffffffffc020987e:	7c18                	ld	a4,56(s0)
ffffffffc0209880:	603c                	ld	a5,64(s0)
ffffffffc0209882:	8526                	mv	a0,s1
ffffffffc0209884:	e71c                	sd	a5,8(a4)
ffffffffc0209886:	e398                	sd	a4,0(a5)
ffffffffc0209888:	6438                	ld	a4,72(s0)
ffffffffc020988a:	683c                	ld	a5,80(s0)
ffffffffc020988c:	e71c                	sd	a5,8(a4)
ffffffffc020988e:	e398                	sd	a4,0(a5)
ffffffffc0209890:	5be010ef          	jal	ffffffffc020ae4e <unlock_sfs_fs>
ffffffffc0209894:	6008                	ld	a0,0(s0)
ffffffffc0209896:	00655783          	lhu	a5,6(a0)
ffffffffc020989a:	cb85                	beqz	a5,ffffffffc02098ca <sfs_reclaim+0xe2>
ffffffffc020989c:	fdef80ef          	jal	ffffffffc020207a <kfree>
ffffffffc02098a0:	8522                	mv	a0,s0
ffffffffc02098a2:	d43fd0ef          	jal	ffffffffc02075e4 <inode_kill>
ffffffffc02098a6:	60e2                	ld	ra,24(sp)
ffffffffc02098a8:	6442                	ld	s0,16(sp)
ffffffffc02098aa:	64a2                	ld	s1,8(sp)
ffffffffc02098ac:	854a                	mv	a0,s2
ffffffffc02098ae:	6902                	ld	s2,0(sp)
ffffffffc02098b0:	6105                	addi	sp,sp,32
ffffffffc02098b2:	8082                	ret
ffffffffc02098b4:	5945                	li	s2,-15
ffffffffc02098b6:	8526                	mv	a0,s1
ffffffffc02098b8:	596010ef          	jal	ffffffffc020ae4e <unlock_sfs_fs>
ffffffffc02098bc:	60e2                	ld	ra,24(sp)
ffffffffc02098be:	6442                	ld	s0,16(sp)
ffffffffc02098c0:	64a2                	ld	s1,8(sp)
ffffffffc02098c2:	854a                	mv	a0,s2
ffffffffc02098c4:	6902                	ld	s2,0(sp)
ffffffffc02098c6:	6105                	addi	sp,sp,32
ffffffffc02098c8:	8082                	ret
ffffffffc02098ca:	440c                	lw	a1,8(s0)
ffffffffc02098cc:	8526                	mv	a0,s1
ffffffffc02098ce:	ea7ff0ef          	jal	ffffffffc0209774 <sfs_block_free>
ffffffffc02098d2:	6008                	ld	a0,0(s0)
ffffffffc02098d4:	5d4c                	lw	a1,60(a0)
ffffffffc02098d6:	d1f9                	beqz	a1,ffffffffc020989c <sfs_reclaim+0xb4>
ffffffffc02098d8:	8526                	mv	a0,s1
ffffffffc02098da:	e9bff0ef          	jal	ffffffffc0209774 <sfs_block_free>
ffffffffc02098de:	6008                	ld	a0,0(s0)
ffffffffc02098e0:	bf75                	j	ffffffffc020989c <sfs_reclaim+0xb4>
ffffffffc02098e2:	892a                	mv	s2,a0
ffffffffc02098e4:	bfc9                	j	ffffffffc02098b6 <sfs_reclaim+0xce>
ffffffffc02098e6:	00005697          	auipc	a3,0x5
ffffffffc02098ea:	8aa68693          	addi	a3,a3,-1878 # ffffffffc020e190 <etext+0x2d8e>
ffffffffc02098ee:	00002617          	auipc	a2,0x2
ffffffffc02098f2:	f5260613          	addi	a2,a2,-174 # ffffffffc020b840 <etext+0x43e>
ffffffffc02098f6:	35b00593          	li	a1,859
ffffffffc02098fa:	00005517          	auipc	a0,0x5
ffffffffc02098fe:	a7650513          	addi	a0,a0,-1418 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209902:	b49f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209906:	00005697          	auipc	a3,0x5
ffffffffc020990a:	af268693          	addi	a3,a3,-1294 # ffffffffc020e3f8 <etext+0x2ff6>
ffffffffc020990e:	00002617          	auipc	a2,0x2
ffffffffc0209912:	f3260613          	addi	a2,a2,-206 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209916:	36100593          	li	a1,865
ffffffffc020991a:	00005517          	auipc	a0,0x5
ffffffffc020991e:	a5650513          	addi	a0,a0,-1450 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209922:	b29f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209926:	00005697          	auipc	a3,0x5
ffffffffc020992a:	a1268693          	addi	a3,a3,-1518 # ffffffffc020e338 <etext+0x2f36>
ffffffffc020992e:	00002617          	auipc	a2,0x2
ffffffffc0209932:	f1260613          	addi	a2,a2,-238 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209936:	35c00593          	li	a1,860
ffffffffc020993a:	00005517          	auipc	a0,0x5
ffffffffc020993e:	a3650513          	addi	a0,a0,-1482 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209942:	b09f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209946:	00004697          	auipc	a3,0x4
ffffffffc020994a:	2f268693          	addi	a3,a3,754 # ffffffffc020dc38 <etext+0x2836>
ffffffffc020994e:	00002617          	auipc	a2,0x2
ffffffffc0209952:	ef260613          	addi	a2,a2,-270 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209956:	36600593          	li	a1,870
ffffffffc020995a:	00005517          	auipc	a0,0x5
ffffffffc020995e:	a1650513          	addi	a0,a0,-1514 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209962:	ae9f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209966:	00003697          	auipc	a3,0x3
ffffffffc020996a:	6d268693          	addi	a3,a3,1746 # ffffffffc020d038 <etext+0x1c36>
ffffffffc020996e:	00002617          	auipc	a2,0x2
ffffffffc0209972:	ed260613          	addi	a2,a2,-302 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209976:	36b00593          	li	a1,875
ffffffffc020997a:	00005517          	auipc	a0,0x5
ffffffffc020997e:	9f650513          	addi	a0,a0,-1546 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209982:	ac9f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209986 <sfs_block_alloc>:
ffffffffc0209986:	1101                	addi	sp,sp,-32
ffffffffc0209988:	e822                	sd	s0,16(sp)
ffffffffc020998a:	842a                	mv	s0,a0
ffffffffc020998c:	7d08                	ld	a0,56(a0)
ffffffffc020998e:	e426                	sd	s1,8(sp)
ffffffffc0209990:	ec06                	sd	ra,24(sp)
ffffffffc0209992:	84ae                	mv	s1,a1
ffffffffc0209994:	c3eff0ef          	jal	ffffffffc0208dd2 <bitmap_alloc>
ffffffffc0209998:	e90d                	bnez	a0,ffffffffc02099ca <sfs_block_alloc+0x44>
ffffffffc020999a:	441c                	lw	a5,8(s0)
ffffffffc020999c:	cbb5                	beqz	a5,ffffffffc0209a10 <sfs_block_alloc+0x8a>
ffffffffc020999e:	37fd                	addiw	a5,a5,-1
ffffffffc02099a0:	c41c                	sw	a5,8(s0)
ffffffffc02099a2:	408c                	lw	a1,0(s1)
ffffffffc02099a4:	4605                	li	a2,1
ffffffffc02099a6:	e030                	sd	a2,64(s0)
ffffffffc02099a8:	c595                	beqz	a1,ffffffffc02099d4 <sfs_block_alloc+0x4e>
ffffffffc02099aa:	405c                	lw	a5,4(s0)
ffffffffc02099ac:	02f5f463          	bgeu	a1,a5,ffffffffc02099d4 <sfs_block_alloc+0x4e>
ffffffffc02099b0:	7c08                	ld	a0,56(s0)
ffffffffc02099b2:	c92ff0ef          	jal	ffffffffc0208e44 <bitmap_test>
ffffffffc02099b6:	4605                	li	a2,1
ffffffffc02099b8:	ed05                	bnez	a0,ffffffffc02099f0 <sfs_block_alloc+0x6a>
ffffffffc02099ba:	8522                	mv	a0,s0
ffffffffc02099bc:	6442                	ld	s0,16(sp)
ffffffffc02099be:	408c                	lw	a1,0(s1)
ffffffffc02099c0:	60e2                	ld	ra,24(sp)
ffffffffc02099c2:	64a2                	ld	s1,8(sp)
ffffffffc02099c4:	6105                	addi	sp,sp,32
ffffffffc02099c6:	4180106f          	j	ffffffffc020adde <sfs_clear_block>
ffffffffc02099ca:	60e2                	ld	ra,24(sp)
ffffffffc02099cc:	6442                	ld	s0,16(sp)
ffffffffc02099ce:	64a2                	ld	s1,8(sp)
ffffffffc02099d0:	6105                	addi	sp,sp,32
ffffffffc02099d2:	8082                	ret
ffffffffc02099d4:	4054                	lw	a3,4(s0)
ffffffffc02099d6:	872e                	mv	a4,a1
ffffffffc02099d8:	00005617          	auipc	a2,0x5
ffffffffc02099dc:	9c860613          	addi	a2,a2,-1592 # ffffffffc020e3a0 <etext+0x2f9e>
ffffffffc02099e0:	05300593          	li	a1,83
ffffffffc02099e4:	00005517          	auipc	a0,0x5
ffffffffc02099e8:	98c50513          	addi	a0,a0,-1652 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc02099ec:	a5ff60ef          	jal	ffffffffc020044a <__panic>
ffffffffc02099f0:	00005697          	auipc	a3,0x5
ffffffffc02099f4:	a4068693          	addi	a3,a3,-1472 # ffffffffc020e430 <etext+0x302e>
ffffffffc02099f8:	00002617          	auipc	a2,0x2
ffffffffc02099fc:	e4860613          	addi	a2,a2,-440 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209a00:	06100593          	li	a1,97
ffffffffc0209a04:	00005517          	auipc	a0,0x5
ffffffffc0209a08:	96c50513          	addi	a0,a0,-1684 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209a0c:	a3ff60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209a10:	00005697          	auipc	a3,0x5
ffffffffc0209a14:	a0068693          	addi	a3,a3,-1536 # ffffffffc020e410 <etext+0x300e>
ffffffffc0209a18:	00002617          	auipc	a2,0x2
ffffffffc0209a1c:	e2860613          	addi	a2,a2,-472 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209a20:	05f00593          	li	a1,95
ffffffffc0209a24:	00005517          	auipc	a0,0x5
ffffffffc0209a28:	94c50513          	addi	a0,a0,-1716 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209a2c:	a1ff60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209a30 <sfs_bmap_load_nolock>:
ffffffffc0209a30:	711d                	addi	sp,sp,-96
ffffffffc0209a32:	e4a6                	sd	s1,72(sp)
ffffffffc0209a34:	6184                	ld	s1,0(a1)
ffffffffc0209a36:	e0ca                	sd	s2,64(sp)
ffffffffc0209a38:	ec86                	sd	ra,88(sp)
ffffffffc0209a3a:	0084a903          	lw	s2,8(s1)
ffffffffc0209a3e:	e8a2                	sd	s0,80(sp)
ffffffffc0209a40:	fc4e                	sd	s3,56(sp)
ffffffffc0209a42:	f852                	sd	s4,48(sp)
ffffffffc0209a44:	1ac96663          	bltu	s2,a2,ffffffffc0209bf0 <sfs_bmap_load_nolock+0x1c0>
ffffffffc0209a48:	47ad                	li	a5,11
ffffffffc0209a4a:	882e                	mv	a6,a1
ffffffffc0209a4c:	8432                	mv	s0,a2
ffffffffc0209a4e:	8a36                	mv	s4,a3
ffffffffc0209a50:	89aa                	mv	s3,a0
ffffffffc0209a52:	04c7f963          	bgeu	a5,a2,ffffffffc0209aa4 <sfs_bmap_load_nolock+0x74>
ffffffffc0209a56:	ff46079b          	addiw	a5,a2,-12
ffffffffc0209a5a:	3ff00713          	li	a4,1023
ffffffffc0209a5e:	f456                	sd	s5,40(sp)
ffffffffc0209a60:	1af76a63          	bltu	a4,a5,ffffffffc0209c14 <sfs_bmap_load_nolock+0x1e4>
ffffffffc0209a64:	03c4a883          	lw	a7,60(s1)
ffffffffc0209a68:	02079713          	slli	a4,a5,0x20
ffffffffc0209a6c:	01e75793          	srli	a5,a4,0x1e
ffffffffc0209a70:	ce02                	sw	zero,28(sp)
ffffffffc0209a72:	cc46                	sw	a7,24(sp)
ffffffffc0209a74:	8abe                	mv	s5,a5
ffffffffc0209a76:	12089063          	bnez	a7,ffffffffc0209b96 <sfs_bmap_load_nolock+0x166>
ffffffffc0209a7a:	08c90c63          	beq	s2,a2,ffffffffc0209b12 <sfs_bmap_load_nolock+0xe2>
ffffffffc0209a7e:	7aa2                	ld	s5,40(sp)
ffffffffc0209a80:	4581                	li	a1,0
ffffffffc0209a82:	0049a683          	lw	a3,4(s3)
ffffffffc0209a86:	f456                	sd	s5,40(sp)
ffffffffc0209a88:	f05a                	sd	s6,32(sp)
ffffffffc0209a8a:	872e                	mv	a4,a1
ffffffffc0209a8c:	00005617          	auipc	a2,0x5
ffffffffc0209a90:	91460613          	addi	a2,a2,-1772 # ffffffffc020e3a0 <etext+0x2f9e>
ffffffffc0209a94:	05300593          	li	a1,83
ffffffffc0209a98:	00005517          	auipc	a0,0x5
ffffffffc0209a9c:	8d850513          	addi	a0,a0,-1832 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209aa0:	9abf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209aa4:	02061793          	slli	a5,a2,0x20
ffffffffc0209aa8:	01e7d713          	srli	a4,a5,0x1e
ffffffffc0209aac:	9726                	add	a4,a4,s1
ffffffffc0209aae:	474c                	lw	a1,12(a4)
ffffffffc0209ab0:	ca2e                	sw	a1,20(sp)
ffffffffc0209ab2:	e581                	bnez	a1,ffffffffc0209aba <sfs_bmap_load_nolock+0x8a>
ffffffffc0209ab4:	0cc90063          	beq	s2,a2,ffffffffc0209b74 <sfs_bmap_load_nolock+0x144>
ffffffffc0209ab8:	d5e1                	beqz	a1,ffffffffc0209a80 <sfs_bmap_load_nolock+0x50>
ffffffffc0209aba:	0049a683          	lw	a3,4(s3)
ffffffffc0209abe:	16d5f863          	bgeu	a1,a3,ffffffffc0209c2e <sfs_bmap_load_nolock+0x1fe>
ffffffffc0209ac2:	0389b503          	ld	a0,56(s3)
ffffffffc0209ac6:	b7eff0ef          	jal	ffffffffc0208e44 <bitmap_test>
ffffffffc0209aca:	18051763          	bnez	a0,ffffffffc0209c58 <sfs_bmap_load_nolock+0x228>
ffffffffc0209ace:	45d2                	lw	a1,20(sp)
ffffffffc0209ad0:	0049a783          	lw	a5,4(s3)
ffffffffc0209ad4:	d5d5                	beqz	a1,ffffffffc0209a80 <sfs_bmap_load_nolock+0x50>
ffffffffc0209ad6:	faf5f6e3          	bgeu	a1,a5,ffffffffc0209a82 <sfs_bmap_load_nolock+0x52>
ffffffffc0209ada:	0389b503          	ld	a0,56(s3)
ffffffffc0209ade:	e02e                	sd	a1,0(sp)
ffffffffc0209ae0:	b64ff0ef          	jal	ffffffffc0208e44 <bitmap_test>
ffffffffc0209ae4:	6582                	ld	a1,0(sp)
ffffffffc0209ae6:	14051763          	bnez	a0,ffffffffc0209c34 <sfs_bmap_load_nolock+0x204>
ffffffffc0209aea:	02890063          	beq	s2,s0,ffffffffc0209b0a <sfs_bmap_load_nolock+0xda>
ffffffffc0209aee:	000a0463          	beqz	s4,ffffffffc0209af6 <sfs_bmap_load_nolock+0xc6>
ffffffffc0209af2:	00ba2023          	sw	a1,0(s4)
ffffffffc0209af6:	4781                	li	a5,0
ffffffffc0209af8:	6446                	ld	s0,80(sp)
ffffffffc0209afa:	60e6                	ld	ra,88(sp)
ffffffffc0209afc:	79e2                	ld	s3,56(sp)
ffffffffc0209afe:	7a42                	ld	s4,48(sp)
ffffffffc0209b00:	64a6                	ld	s1,72(sp)
ffffffffc0209b02:	6906                	ld	s2,64(sp)
ffffffffc0209b04:	853e                	mv	a0,a5
ffffffffc0209b06:	6125                	addi	sp,sp,96
ffffffffc0209b08:	8082                	ret
ffffffffc0209b0a:	449c                	lw	a5,8(s1)
ffffffffc0209b0c:	2785                	addiw	a5,a5,1
ffffffffc0209b0e:	c49c                	sw	a5,8(s1)
ffffffffc0209b10:	bff9                	j	ffffffffc0209aee <sfs_bmap_load_nolock+0xbe>
ffffffffc0209b12:	082c                	addi	a1,sp,24
ffffffffc0209b14:	e046                	sd	a7,0(sp)
ffffffffc0209b16:	e442                	sd	a6,8(sp)
ffffffffc0209b18:	e6fff0ef          	jal	ffffffffc0209986 <sfs_block_alloc>
ffffffffc0209b1c:	87aa                	mv	a5,a0
ffffffffc0209b1e:	ed5d                	bnez	a0,ffffffffc0209bdc <sfs_bmap_load_nolock+0x1ac>
ffffffffc0209b20:	6882                	ld	a7,0(sp)
ffffffffc0209b22:	6822                	ld	a6,8(sp)
ffffffffc0209b24:	f05a                	sd	s6,32(sp)
ffffffffc0209b26:	01c10b13          	addi	s6,sp,28
ffffffffc0209b2a:	85da                	mv	a1,s6
ffffffffc0209b2c:	854e                	mv	a0,s3
ffffffffc0209b2e:	e046                	sd	a7,0(sp)
ffffffffc0209b30:	e442                	sd	a6,8(sp)
ffffffffc0209b32:	e55ff0ef          	jal	ffffffffc0209986 <sfs_block_alloc>
ffffffffc0209b36:	6882                	ld	a7,0(sp)
ffffffffc0209b38:	87aa                	mv	a5,a0
ffffffffc0209b3a:	e959                	bnez	a0,ffffffffc0209bd0 <sfs_bmap_load_nolock+0x1a0>
ffffffffc0209b3c:	46e2                	lw	a3,24(sp)
ffffffffc0209b3e:	85da                	mv	a1,s6
ffffffffc0209b40:	8756                	mv	a4,s5
ffffffffc0209b42:	4611                	li	a2,4
ffffffffc0209b44:	854e                	mv	a0,s3
ffffffffc0209b46:	e046                	sd	a7,0(sp)
ffffffffc0209b48:	142010ef          	jal	ffffffffc020ac8a <sfs_wbuf>
ffffffffc0209b4c:	45f2                	lw	a1,28(sp)
ffffffffc0209b4e:	6882                	ld	a7,0(sp)
ffffffffc0209b50:	e92d                	bnez	a0,ffffffffc0209bc2 <sfs_bmap_load_nolock+0x192>
ffffffffc0209b52:	5cd8                	lw	a4,60(s1)
ffffffffc0209b54:	47e2                	lw	a5,24(sp)
ffffffffc0209b56:	6822                	ld	a6,8(sp)
ffffffffc0209b58:	ca2e                	sw	a1,20(sp)
ffffffffc0209b5a:	00f70863          	beq	a4,a5,ffffffffc0209b6a <sfs_bmap_load_nolock+0x13a>
ffffffffc0209b5e:	10071f63          	bnez	a4,ffffffffc0209c7c <sfs_bmap_load_nolock+0x24c>
ffffffffc0209b62:	dcdc                	sw	a5,60(s1)
ffffffffc0209b64:	4785                	li	a5,1
ffffffffc0209b66:	00f83823          	sd	a5,16(a6)
ffffffffc0209b6a:	7aa2                	ld	s5,40(sp)
ffffffffc0209b6c:	7b02                	ld	s6,32(sp)
ffffffffc0209b6e:	f00589e3          	beqz	a1,ffffffffc0209a80 <sfs_bmap_load_nolock+0x50>
ffffffffc0209b72:	b7a1                	j	ffffffffc0209aba <sfs_bmap_load_nolock+0x8a>
ffffffffc0209b74:	084c                	addi	a1,sp,20
ffffffffc0209b76:	e03a                	sd	a4,0(sp)
ffffffffc0209b78:	e442                	sd	a6,8(sp)
ffffffffc0209b7a:	e0dff0ef          	jal	ffffffffc0209986 <sfs_block_alloc>
ffffffffc0209b7e:	87aa                	mv	a5,a0
ffffffffc0209b80:	fd25                	bnez	a0,ffffffffc0209af8 <sfs_bmap_load_nolock+0xc8>
ffffffffc0209b82:	45d2                	lw	a1,20(sp)
ffffffffc0209b84:	6702                	ld	a4,0(sp)
ffffffffc0209b86:	6822                	ld	a6,8(sp)
ffffffffc0209b88:	4785                	li	a5,1
ffffffffc0209b8a:	c74c                	sw	a1,12(a4)
ffffffffc0209b8c:	00f83823          	sd	a5,16(a6)
ffffffffc0209b90:	ee0588e3          	beqz	a1,ffffffffc0209a80 <sfs_bmap_load_nolock+0x50>
ffffffffc0209b94:	b71d                	j	ffffffffc0209aba <sfs_bmap_load_nolock+0x8a>
ffffffffc0209b96:	e02e                	sd	a1,0(sp)
ffffffffc0209b98:	873e                	mv	a4,a5
ffffffffc0209b9a:	086c                	addi	a1,sp,28
ffffffffc0209b9c:	86c6                	mv	a3,a7
ffffffffc0209b9e:	4611                	li	a2,4
ffffffffc0209ba0:	f05a                	sd	s6,32(sp)
ffffffffc0209ba2:	e446                	sd	a7,8(sp)
ffffffffc0209ba4:	066010ef          	jal	ffffffffc020ac0a <sfs_rbuf>
ffffffffc0209ba8:	01c10b13          	addi	s6,sp,28
ffffffffc0209bac:	87aa                	mv	a5,a0
ffffffffc0209bae:	e505                	bnez	a0,ffffffffc0209bd6 <sfs_bmap_load_nolock+0x1a6>
ffffffffc0209bb0:	45f2                	lw	a1,28(sp)
ffffffffc0209bb2:	6802                	ld	a6,0(sp)
ffffffffc0209bb4:	00891463          	bne	s2,s0,ffffffffc0209bbc <sfs_bmap_load_nolock+0x18c>
ffffffffc0209bb8:	68a2                	ld	a7,8(sp)
ffffffffc0209bba:	d9a5                	beqz	a1,ffffffffc0209b2a <sfs_bmap_load_nolock+0xfa>
ffffffffc0209bbc:	5cd8                	lw	a4,60(s1)
ffffffffc0209bbe:	47e2                	lw	a5,24(sp)
ffffffffc0209bc0:	bf61                	j	ffffffffc0209b58 <sfs_bmap_load_nolock+0x128>
ffffffffc0209bc2:	e42a                	sd	a0,8(sp)
ffffffffc0209bc4:	854e                	mv	a0,s3
ffffffffc0209bc6:	e046                	sd	a7,0(sp)
ffffffffc0209bc8:	badff0ef          	jal	ffffffffc0209774 <sfs_block_free>
ffffffffc0209bcc:	6882                	ld	a7,0(sp)
ffffffffc0209bce:	67a2                	ld	a5,8(sp)
ffffffffc0209bd0:	45e2                	lw	a1,24(sp)
ffffffffc0209bd2:	00b89763          	bne	a7,a1,ffffffffc0209be0 <sfs_bmap_load_nolock+0x1b0>
ffffffffc0209bd6:	7aa2                	ld	s5,40(sp)
ffffffffc0209bd8:	7b02                	ld	s6,32(sp)
ffffffffc0209bda:	bf39                	j	ffffffffc0209af8 <sfs_bmap_load_nolock+0xc8>
ffffffffc0209bdc:	7aa2                	ld	s5,40(sp)
ffffffffc0209bde:	bf29                	j	ffffffffc0209af8 <sfs_bmap_load_nolock+0xc8>
ffffffffc0209be0:	854e                	mv	a0,s3
ffffffffc0209be2:	e03e                	sd	a5,0(sp)
ffffffffc0209be4:	b91ff0ef          	jal	ffffffffc0209774 <sfs_block_free>
ffffffffc0209be8:	6782                	ld	a5,0(sp)
ffffffffc0209bea:	7aa2                	ld	s5,40(sp)
ffffffffc0209bec:	7b02                	ld	s6,32(sp)
ffffffffc0209bee:	b729                	j	ffffffffc0209af8 <sfs_bmap_load_nolock+0xc8>
ffffffffc0209bf0:	00005697          	auipc	a3,0x5
ffffffffc0209bf4:	86868693          	addi	a3,a3,-1944 # ffffffffc020e458 <etext+0x3056>
ffffffffc0209bf8:	00002617          	auipc	a2,0x2
ffffffffc0209bfc:	c4860613          	addi	a2,a2,-952 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209c00:	16400593          	li	a1,356
ffffffffc0209c04:	00004517          	auipc	a0,0x4
ffffffffc0209c08:	76c50513          	addi	a0,a0,1900 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209c0c:	f456                	sd	s5,40(sp)
ffffffffc0209c0e:	f05a                	sd	s6,32(sp)
ffffffffc0209c10:	83bf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209c14:	00005617          	auipc	a2,0x5
ffffffffc0209c18:	87460613          	addi	a2,a2,-1932 # ffffffffc020e488 <etext+0x3086>
ffffffffc0209c1c:	11e00593          	li	a1,286
ffffffffc0209c20:	00004517          	auipc	a0,0x4
ffffffffc0209c24:	75050513          	addi	a0,a0,1872 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209c28:	f05a                	sd	s6,32(sp)
ffffffffc0209c2a:	821f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209c2e:	f456                	sd	s5,40(sp)
ffffffffc0209c30:	f05a                	sd	s6,32(sp)
ffffffffc0209c32:	bda1                	j	ffffffffc0209a8a <sfs_bmap_load_nolock+0x5a>
ffffffffc0209c34:	00004697          	auipc	a3,0x4
ffffffffc0209c38:	7a468693          	addi	a3,a3,1956 # ffffffffc020e3d8 <etext+0x2fd6>
ffffffffc0209c3c:	00002617          	auipc	a2,0x2
ffffffffc0209c40:	c0460613          	addi	a2,a2,-1020 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209c44:	16b00593          	li	a1,363
ffffffffc0209c48:	00004517          	auipc	a0,0x4
ffffffffc0209c4c:	72850513          	addi	a0,a0,1832 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209c50:	f456                	sd	s5,40(sp)
ffffffffc0209c52:	f05a                	sd	s6,32(sp)
ffffffffc0209c54:	ff6f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209c58:	00005697          	auipc	a3,0x5
ffffffffc0209c5c:	86068693          	addi	a3,a3,-1952 # ffffffffc020e4b8 <etext+0x30b6>
ffffffffc0209c60:	00002617          	auipc	a2,0x2
ffffffffc0209c64:	be060613          	addi	a2,a2,-1056 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209c68:	12100593          	li	a1,289
ffffffffc0209c6c:	00004517          	auipc	a0,0x4
ffffffffc0209c70:	70450513          	addi	a0,a0,1796 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209c74:	f456                	sd	s5,40(sp)
ffffffffc0209c76:	f05a                	sd	s6,32(sp)
ffffffffc0209c78:	fd2f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209c7c:	00004697          	auipc	a3,0x4
ffffffffc0209c80:	7f468693          	addi	a3,a3,2036 # ffffffffc020e470 <etext+0x306e>
ffffffffc0209c84:	00002617          	auipc	a2,0x2
ffffffffc0209c88:	bbc60613          	addi	a2,a2,-1092 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209c8c:	11800593          	li	a1,280
ffffffffc0209c90:	00004517          	auipc	a0,0x4
ffffffffc0209c94:	6e050513          	addi	a0,a0,1760 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209c98:	fb2f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209c9c <sfs_io_nolock>:
ffffffffc0209c9c:	7175                	addi	sp,sp,-144
ffffffffc0209c9e:	f8ca                	sd	s2,112(sp)
ffffffffc0209ca0:	892e                	mv	s2,a1
ffffffffc0209ca2:	618c                	ld	a1,0(a1)
ffffffffc0209ca4:	e506                	sd	ra,136(sp)
ffffffffc0209ca6:	4809                	li	a6,2
ffffffffc0209ca8:	0045d883          	lhu	a7,4(a1)
ffffffffc0209cac:	e122                	sd	s0,128(sp)
ffffffffc0209cae:	fca6                	sd	s1,120(sp)
ffffffffc0209cb0:	1d088a63          	beq	a7,a6,ffffffffc0209e84 <sfs_io_nolock+0x1e8>
ffffffffc0209cb4:	00073803          	ld	a6,0(a4) # 8000000 <_binary_bin_sfs_img_size+0x7f8ad00>
ffffffffc0209cb8:	84ba                	mv	s1,a4
ffffffffc0209cba:	0004b023          	sd	zero,0(s1)
ffffffffc0209cbe:	08000737          	lui	a4,0x8000
ffffffffc0209cc2:	8436                	mv	s0,a3
ffffffffc0209cc4:	9836                	add	a6,a6,a3
ffffffffc0209cc6:	8336                	mv	t1,a3
ffffffffc0209cc8:	1ae6fc63          	bgeu	a3,a4,ffffffffc0209e80 <sfs_io_nolock+0x1e4>
ffffffffc0209ccc:	1ad84a63          	blt	a6,a3,ffffffffc0209e80 <sfs_io_nolock+0x1e4>
ffffffffc0209cd0:	f4ce                	sd	s3,104(sp)
ffffffffc0209cd2:	89aa                	mv	s3,a0
ffffffffc0209cd4:	4501                	li	a0,0
ffffffffc0209cd6:	13068d63          	beq	a3,a6,ffffffffc0209e10 <sfs_io_nolock+0x174>
ffffffffc0209cda:	f0d2                	sd	s4,96(sp)
ffffffffc0209cdc:	e8da                	sd	s6,80(sp)
ffffffffc0209cde:	e4de                	sd	s7,72(sp)
ffffffffc0209ce0:	8a32                	mv	s4,a2
ffffffffc0209ce2:	01077363          	bgeu	a4,a6,ffffffffc0209ce8 <sfs_io_nolock+0x4c>
ffffffffc0209ce6:	883a                	mv	a6,a4
ffffffffc0209ce8:	cfd5                	beqz	a5,ffffffffc0209da4 <sfs_io_nolock+0x108>
ffffffffc0209cea:	ecd6                	sd	s5,88(sp)
ffffffffc0209cec:	00001b97          	auipc	s7,0x1
ffffffffc0209cf0:	ebcb8b93          	addi	s7,s7,-324 # ffffffffc020aba8 <sfs_wblock>
ffffffffc0209cf4:	00001b17          	auipc	s6,0x1
ffffffffc0209cf8:	f96b0b13          	addi	s6,s6,-106 # ffffffffc020ac8a <sfs_wbuf>
ffffffffc0209cfc:	6605                	lui	a2,0x1
ffffffffc0209cfe:	40c45693          	srai	a3,s0,0xc
ffffffffc0209d02:	fff60713          	addi	a4,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0209d06:	40c85793          	srai	a5,a6,0xc
ffffffffc0209d0a:	9f95                	subw	a5,a5,a3
ffffffffc0209d0c:	8f61                	and	a4,a4,s0
ffffffffc0209d0e:	00068a9b          	sext.w	s5,a3
ffffffffc0209d12:	8e3e                	mv	t3,a5
ffffffffc0209d14:	cb4d                	beqz	a4,ffffffffc0209dc6 <sfs_io_nolock+0x12a>
ffffffffc0209d16:	40880e33          	sub	t3,a6,s0
ffffffffc0209d1a:	10079263          	bnez	a5,ffffffffc0209e1e <sfs_io_nolock+0x182>
ffffffffc0209d1e:	1874                	addi	a3,sp,60
ffffffffc0209d20:	8656                	mv	a2,s5
ffffffffc0209d22:	85ca                	mv	a1,s2
ffffffffc0209d24:	854e                	mv	a0,s3
ffffffffc0209d26:	e41a                	sd	t1,8(sp)
ffffffffc0209d28:	f43e                	sd	a5,40(sp)
ffffffffc0209d2a:	ec3a                	sd	a4,24(sp)
ffffffffc0209d2c:	f042                	sd	a6,32(sp)
ffffffffc0209d2e:	e872                	sd	t3,16(sp)
ffffffffc0209d30:	d01ff0ef          	jal	ffffffffc0209a30 <sfs_bmap_load_nolock>
ffffffffc0209d34:	6322                	ld	t1,8(sp)
ffffffffc0209d36:	4881                	li	a7,0
ffffffffc0209d38:	ed0d                	bnez	a0,ffffffffc0209d72 <sfs_io_nolock+0xd6>
ffffffffc0209d3a:	56f2                	lw	a3,60(sp)
ffffffffc0209d3c:	6762                	ld	a4,24(sp)
ffffffffc0209d3e:	6642                	ld	a2,16(sp)
ffffffffc0209d40:	85d2                	mv	a1,s4
ffffffffc0209d42:	854e                	mv	a0,s3
ffffffffc0209d44:	9b02                	jalr	s6
ffffffffc0209d46:	6322                	ld	t1,8(sp)
ffffffffc0209d48:	4881                	li	a7,0
ffffffffc0209d4a:	e505                	bnez	a0,ffffffffc0209d72 <sfs_io_nolock+0xd6>
ffffffffc0209d4c:	77a2                	ld	a5,40(sp)
ffffffffc0209d4e:	68c2                	ld	a7,16(sp)
ffffffffc0209d50:	7802                	ld	a6,32(sp)
ffffffffc0209d52:	10078a63          	beqz	a5,ffffffffc0209e66 <sfs_io_nolock+0x1ca>
ffffffffc0209d56:	fff78e1b          	addiw	t3,a5,-1
ffffffffc0209d5a:	9a46                	add	s4,s4,a7
ffffffffc0209d5c:	2a85                	addiw	s5,s5,1
ffffffffc0209d5e:	060e1763          	bnez	t3,ffffffffc0209dcc <sfs_io_nolock+0x130>
ffffffffc0209d62:	1852                	slli	a6,a6,0x34
ffffffffc0209d64:	03485793          	srli	a5,a6,0x34
ffffffffc0209d68:	0c081863          	bnez	a6,ffffffffc0209e38 <sfs_io_nolock+0x19c>
ffffffffc0209d6c:	01140333          	add	t1,s0,a7
ffffffffc0209d70:	4501                	li	a0,0
ffffffffc0209d72:	00093783          	ld	a5,0(s2)
ffffffffc0209d76:	0114b023          	sd	a7,0(s1)
ffffffffc0209d7a:	0007e703          	lwu	a4,0(a5)
ffffffffc0209d7e:	00677863          	bgeu	a4,t1,ffffffffc0209d8e <sfs_io_nolock+0xf2>
ffffffffc0209d82:	0114043b          	addw	s0,s0,a7
ffffffffc0209d86:	c380                	sw	s0,0(a5)
ffffffffc0209d88:	4785                	li	a5,1
ffffffffc0209d8a:	00f93823          	sd	a5,16(s2)
ffffffffc0209d8e:	79a6                	ld	s3,104(sp)
ffffffffc0209d90:	7a06                	ld	s4,96(sp)
ffffffffc0209d92:	6ae6                	ld	s5,88(sp)
ffffffffc0209d94:	6b46                	ld	s6,80(sp)
ffffffffc0209d96:	6ba6                	ld	s7,72(sp)
ffffffffc0209d98:	640a                	ld	s0,128(sp)
ffffffffc0209d9a:	60aa                	ld	ra,136(sp)
ffffffffc0209d9c:	74e6                	ld	s1,120(sp)
ffffffffc0209d9e:	7946                	ld	s2,112(sp)
ffffffffc0209da0:	6149                	addi	sp,sp,144
ffffffffc0209da2:	8082                	ret
ffffffffc0209da4:	0005e783          	lwu	a5,0(a1)
ffffffffc0209da8:	4501                	li	a0,0
ffffffffc0209daa:	0cf45163          	bge	s0,a5,ffffffffc0209e6c <sfs_io_nolock+0x1d0>
ffffffffc0209dae:	ecd6                	sd	s5,88(sp)
ffffffffc0209db0:	0707ca63          	blt	a5,a6,ffffffffc0209e24 <sfs_io_nolock+0x188>
ffffffffc0209db4:	00001b97          	auipc	s7,0x1
ffffffffc0209db8:	d92b8b93          	addi	s7,s7,-622 # ffffffffc020ab46 <sfs_rblock>
ffffffffc0209dbc:	00001b17          	auipc	s6,0x1
ffffffffc0209dc0:	e4eb0b13          	addi	s6,s6,-434 # ffffffffc020ac0a <sfs_rbuf>
ffffffffc0209dc4:	bf25                	j	ffffffffc0209cfc <sfs_io_nolock+0x60>
ffffffffc0209dc6:	4881                	li	a7,0
ffffffffc0209dc8:	f80e0de3          	beqz	t3,ffffffffc0209d62 <sfs_io_nolock+0xc6>
ffffffffc0209dcc:	1874                	addi	a3,sp,60
ffffffffc0209dce:	8656                	mv	a2,s5
ffffffffc0209dd0:	85ca                	mv	a1,s2
ffffffffc0209dd2:	854e                	mv	a0,s3
ffffffffc0209dd4:	ec72                	sd	t3,24(sp)
ffffffffc0209dd6:	e846                	sd	a7,16(sp)
ffffffffc0209dd8:	e442                	sd	a6,8(sp)
ffffffffc0209dda:	c57ff0ef          	jal	ffffffffc0209a30 <sfs_bmap_load_nolock>
ffffffffc0209dde:	6822                	ld	a6,8(sp)
ffffffffc0209de0:	68c2                	ld	a7,16(sp)
ffffffffc0209de2:	6e62                	ld	t3,24(sp)
ffffffffc0209de4:	e149                	bnez	a0,ffffffffc0209e66 <sfs_io_nolock+0x1ca>
ffffffffc0209de6:	5672                	lw	a2,60(sp)
ffffffffc0209de8:	86f2                	mv	a3,t3
ffffffffc0209dea:	85d2                	mv	a1,s4
ffffffffc0209dec:	854e                	mv	a0,s3
ffffffffc0209dee:	ec46                	sd	a7,24(sp)
ffffffffc0209df0:	e842                	sd	a6,16(sp)
ffffffffc0209df2:	e472                	sd	t3,8(sp)
ffffffffc0209df4:	9b82                	jalr	s7
ffffffffc0209df6:	6e22                	ld	t3,8(sp)
ffffffffc0209df8:	6842                	ld	a6,16(sp)
ffffffffc0209dfa:	68e2                	ld	a7,24(sp)
ffffffffc0209dfc:	e52d                	bnez	a0,ffffffffc0209e66 <sfs_io_nolock+0x1ca>
ffffffffc0209dfe:	00ce179b          	slliw	a5,t3,0xc
ffffffffc0209e02:	1782                	slli	a5,a5,0x20
ffffffffc0209e04:	9381                	srli	a5,a5,0x20
ffffffffc0209e06:	01ca8abb          	addw	s5,s5,t3
ffffffffc0209e0a:	98be                	add	a7,a7,a5
ffffffffc0209e0c:	9a3e                	add	s4,s4,a5
ffffffffc0209e0e:	bf91                	j	ffffffffc0209d62 <sfs_io_nolock+0xc6>
ffffffffc0209e10:	640a                	ld	s0,128(sp)
ffffffffc0209e12:	60aa                	ld	ra,136(sp)
ffffffffc0209e14:	79a6                	ld	s3,104(sp)
ffffffffc0209e16:	74e6                	ld	s1,120(sp)
ffffffffc0209e18:	7946                	ld	s2,112(sp)
ffffffffc0209e1a:	6149                	addi	sp,sp,144
ffffffffc0209e1c:	8082                	ret
ffffffffc0209e1e:	40e60e33          	sub	t3,a2,a4
ffffffffc0209e22:	bdf5                	j	ffffffffc0209d1e <sfs_io_nolock+0x82>
ffffffffc0209e24:	883e                	mv	a6,a5
ffffffffc0209e26:	00001b97          	auipc	s7,0x1
ffffffffc0209e2a:	d20b8b93          	addi	s7,s7,-736 # ffffffffc020ab46 <sfs_rblock>
ffffffffc0209e2e:	00001b17          	auipc	s6,0x1
ffffffffc0209e32:	ddcb0b13          	addi	s6,s6,-548 # ffffffffc020ac0a <sfs_rbuf>
ffffffffc0209e36:	b5d9                	j	ffffffffc0209cfc <sfs_io_nolock+0x60>
ffffffffc0209e38:	8656                	mv	a2,s5
ffffffffc0209e3a:	1874                	addi	a3,sp,60
ffffffffc0209e3c:	85ca                	mv	a1,s2
ffffffffc0209e3e:	854e                	mv	a0,s3
ffffffffc0209e40:	e846                	sd	a7,16(sp)
ffffffffc0209e42:	e43e                	sd	a5,8(sp)
ffffffffc0209e44:	bedff0ef          	jal	ffffffffc0209a30 <sfs_bmap_load_nolock>
ffffffffc0209e48:	67a2                	ld	a5,8(sp)
ffffffffc0209e4a:	68c2                	ld	a7,16(sp)
ffffffffc0209e4c:	ed09                	bnez	a0,ffffffffc0209e66 <sfs_io_nolock+0x1ca>
ffffffffc0209e4e:	56f2                	lw	a3,60(sp)
ffffffffc0209e50:	863e                	mv	a2,a5
ffffffffc0209e52:	85d2                	mv	a1,s4
ffffffffc0209e54:	854e                	mv	a0,s3
ffffffffc0209e56:	4701                	li	a4,0
ffffffffc0209e58:	e846                	sd	a7,16(sp)
ffffffffc0209e5a:	e43e                	sd	a5,8(sp)
ffffffffc0209e5c:	9b02                	jalr	s6
ffffffffc0209e5e:	67a2                	ld	a5,8(sp)
ffffffffc0209e60:	68c2                	ld	a7,16(sp)
ffffffffc0209e62:	e111                	bnez	a0,ffffffffc0209e66 <sfs_io_nolock+0x1ca>
ffffffffc0209e64:	98be                	add	a7,a7,a5
ffffffffc0209e66:	01140333          	add	t1,s0,a7
ffffffffc0209e6a:	b721                	j	ffffffffc0209d72 <sfs_io_nolock+0xd6>
ffffffffc0209e6c:	640a                	ld	s0,128(sp)
ffffffffc0209e6e:	60aa                	ld	ra,136(sp)
ffffffffc0209e70:	79a6                	ld	s3,104(sp)
ffffffffc0209e72:	7a06                	ld	s4,96(sp)
ffffffffc0209e74:	6b46                	ld	s6,80(sp)
ffffffffc0209e76:	6ba6                	ld	s7,72(sp)
ffffffffc0209e78:	74e6                	ld	s1,120(sp)
ffffffffc0209e7a:	7946                	ld	s2,112(sp)
ffffffffc0209e7c:	6149                	addi	sp,sp,144
ffffffffc0209e7e:	8082                	ret
ffffffffc0209e80:	5575                	li	a0,-3
ffffffffc0209e82:	bf19                	j	ffffffffc0209d98 <sfs_io_nolock+0xfc>
ffffffffc0209e84:	00004697          	auipc	a3,0x4
ffffffffc0209e88:	65c68693          	addi	a3,a3,1628 # ffffffffc020e4e0 <etext+0x30de>
ffffffffc0209e8c:	00002617          	auipc	a2,0x2
ffffffffc0209e90:	9b460613          	addi	a2,a2,-1612 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209e94:	22b00593          	li	a1,555
ffffffffc0209e98:	00004517          	auipc	a0,0x4
ffffffffc0209e9c:	4d850513          	addi	a0,a0,1240 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209ea0:	f4ce                	sd	s3,104(sp)
ffffffffc0209ea2:	f0d2                	sd	s4,96(sp)
ffffffffc0209ea4:	ecd6                	sd	s5,88(sp)
ffffffffc0209ea6:	e8da                	sd	s6,80(sp)
ffffffffc0209ea8:	e4de                	sd	s7,72(sp)
ffffffffc0209eaa:	da0f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209eae <sfs_read>:
ffffffffc0209eae:	7139                	addi	sp,sp,-64
ffffffffc0209eb0:	f04a                	sd	s2,32(sp)
ffffffffc0209eb2:	06853903          	ld	s2,104(a0)
ffffffffc0209eb6:	fc06                	sd	ra,56(sp)
ffffffffc0209eb8:	f822                	sd	s0,48(sp)
ffffffffc0209eba:	f426                	sd	s1,40(sp)
ffffffffc0209ebc:	ec4e                	sd	s3,24(sp)
ffffffffc0209ebe:	04090e63          	beqz	s2,ffffffffc0209f1a <sfs_read+0x6c>
ffffffffc0209ec2:	0b092783          	lw	a5,176(s2)
ffffffffc0209ec6:	ebb1                	bnez	a5,ffffffffc0209f1a <sfs_read+0x6c>
ffffffffc0209ec8:	4d38                	lw	a4,88(a0)
ffffffffc0209eca:	6785                	lui	a5,0x1
ffffffffc0209ecc:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209ed0:	842a                	mv	s0,a0
ffffffffc0209ed2:	06f71463          	bne	a4,a5,ffffffffc0209f3a <sfs_read+0x8c>
ffffffffc0209ed6:	02050993          	addi	s3,a0,32
ffffffffc0209eda:	854e                	mv	a0,s3
ffffffffc0209edc:	84ae                	mv	s1,a1
ffffffffc0209ede:	cbefa0ef          	jal	ffffffffc020439c <down>
ffffffffc0209ee2:	6c9c                	ld	a5,24(s1)
ffffffffc0209ee4:	6494                	ld	a3,8(s1)
ffffffffc0209ee6:	6090                	ld	a2,0(s1)
ffffffffc0209ee8:	85a2                	mv	a1,s0
ffffffffc0209eea:	e43e                	sd	a5,8(sp)
ffffffffc0209eec:	854a                	mv	a0,s2
ffffffffc0209eee:	0038                	addi	a4,sp,8
ffffffffc0209ef0:	4781                	li	a5,0
ffffffffc0209ef2:	dabff0ef          	jal	ffffffffc0209c9c <sfs_io_nolock>
ffffffffc0209ef6:	65a2                	ld	a1,8(sp)
ffffffffc0209ef8:	842a                	mv	s0,a0
ffffffffc0209efa:	ed81                	bnez	a1,ffffffffc0209f12 <sfs_read+0x64>
ffffffffc0209efc:	854e                	mv	a0,s3
ffffffffc0209efe:	c9afa0ef          	jal	ffffffffc0204398 <up>
ffffffffc0209f02:	70e2                	ld	ra,56(sp)
ffffffffc0209f04:	8522                	mv	a0,s0
ffffffffc0209f06:	7442                	ld	s0,48(sp)
ffffffffc0209f08:	74a2                	ld	s1,40(sp)
ffffffffc0209f0a:	7902                	ld	s2,32(sp)
ffffffffc0209f0c:	69e2                	ld	s3,24(sp)
ffffffffc0209f0e:	6121                	addi	sp,sp,64
ffffffffc0209f10:	8082                	ret
ffffffffc0209f12:	8526                	mv	a0,s1
ffffffffc0209f14:	bacfb0ef          	jal	ffffffffc02052c0 <iobuf_skip>
ffffffffc0209f18:	b7d5                	j	ffffffffc0209efc <sfs_read+0x4e>
ffffffffc0209f1a:	00004697          	auipc	a3,0x4
ffffffffc0209f1e:	27668693          	addi	a3,a3,630 # ffffffffc020e190 <etext+0x2d8e>
ffffffffc0209f22:	00002617          	auipc	a2,0x2
ffffffffc0209f26:	91e60613          	addi	a2,a2,-1762 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209f2a:	29900593          	li	a1,665
ffffffffc0209f2e:	00004517          	auipc	a0,0x4
ffffffffc0209f32:	44250513          	addi	a0,a0,1090 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209f36:	d14f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209f3a:	817ff0ef          	jal	ffffffffc0209750 <sfs_io.part.0>

ffffffffc0209f3e <sfs_write>:
ffffffffc0209f3e:	7139                	addi	sp,sp,-64
ffffffffc0209f40:	f04a                	sd	s2,32(sp)
ffffffffc0209f42:	06853903          	ld	s2,104(a0)
ffffffffc0209f46:	fc06                	sd	ra,56(sp)
ffffffffc0209f48:	f822                	sd	s0,48(sp)
ffffffffc0209f4a:	f426                	sd	s1,40(sp)
ffffffffc0209f4c:	ec4e                	sd	s3,24(sp)
ffffffffc0209f4e:	04090e63          	beqz	s2,ffffffffc0209faa <sfs_write+0x6c>
ffffffffc0209f52:	0b092783          	lw	a5,176(s2)
ffffffffc0209f56:	ebb1                	bnez	a5,ffffffffc0209faa <sfs_write+0x6c>
ffffffffc0209f58:	4d38                	lw	a4,88(a0)
ffffffffc0209f5a:	6785                	lui	a5,0x1
ffffffffc0209f5c:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209f60:	842a                	mv	s0,a0
ffffffffc0209f62:	06f71463          	bne	a4,a5,ffffffffc0209fca <sfs_write+0x8c>
ffffffffc0209f66:	02050993          	addi	s3,a0,32
ffffffffc0209f6a:	854e                	mv	a0,s3
ffffffffc0209f6c:	84ae                	mv	s1,a1
ffffffffc0209f6e:	c2efa0ef          	jal	ffffffffc020439c <down>
ffffffffc0209f72:	6c9c                	ld	a5,24(s1)
ffffffffc0209f74:	6494                	ld	a3,8(s1)
ffffffffc0209f76:	6090                	ld	a2,0(s1)
ffffffffc0209f78:	85a2                	mv	a1,s0
ffffffffc0209f7a:	e43e                	sd	a5,8(sp)
ffffffffc0209f7c:	854a                	mv	a0,s2
ffffffffc0209f7e:	0038                	addi	a4,sp,8
ffffffffc0209f80:	4785                	li	a5,1
ffffffffc0209f82:	d1bff0ef          	jal	ffffffffc0209c9c <sfs_io_nolock>
ffffffffc0209f86:	65a2                	ld	a1,8(sp)
ffffffffc0209f88:	842a                	mv	s0,a0
ffffffffc0209f8a:	ed81                	bnez	a1,ffffffffc0209fa2 <sfs_write+0x64>
ffffffffc0209f8c:	854e                	mv	a0,s3
ffffffffc0209f8e:	c0afa0ef          	jal	ffffffffc0204398 <up>
ffffffffc0209f92:	70e2                	ld	ra,56(sp)
ffffffffc0209f94:	8522                	mv	a0,s0
ffffffffc0209f96:	7442                	ld	s0,48(sp)
ffffffffc0209f98:	74a2                	ld	s1,40(sp)
ffffffffc0209f9a:	7902                	ld	s2,32(sp)
ffffffffc0209f9c:	69e2                	ld	s3,24(sp)
ffffffffc0209f9e:	6121                	addi	sp,sp,64
ffffffffc0209fa0:	8082                	ret
ffffffffc0209fa2:	8526                	mv	a0,s1
ffffffffc0209fa4:	b1cfb0ef          	jal	ffffffffc02052c0 <iobuf_skip>
ffffffffc0209fa8:	b7d5                	j	ffffffffc0209f8c <sfs_write+0x4e>
ffffffffc0209faa:	00004697          	auipc	a3,0x4
ffffffffc0209fae:	1e668693          	addi	a3,a3,486 # ffffffffc020e190 <etext+0x2d8e>
ffffffffc0209fb2:	00002617          	auipc	a2,0x2
ffffffffc0209fb6:	88e60613          	addi	a2,a2,-1906 # ffffffffc020b840 <etext+0x43e>
ffffffffc0209fba:	29900593          	li	a1,665
ffffffffc0209fbe:	00004517          	auipc	a0,0x4
ffffffffc0209fc2:	3b250513          	addi	a0,a0,946 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc0209fc6:	c84f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209fca:	f86ff0ef          	jal	ffffffffc0209750 <sfs_io.part.0>

ffffffffc0209fce <sfs_dirent_read_nolock>:
ffffffffc0209fce:	619c                	ld	a5,0(a1)
ffffffffc0209fd0:	7139                	addi	sp,sp,-64
ffffffffc0209fd2:	f426                	sd	s1,40(sp)
ffffffffc0209fd4:	84b6                	mv	s1,a3
ffffffffc0209fd6:	0047d683          	lhu	a3,4(a5)
ffffffffc0209fda:	fc06                	sd	ra,56(sp)
ffffffffc0209fdc:	f822                	sd	s0,48(sp)
ffffffffc0209fde:	4709                	li	a4,2
ffffffffc0209fe0:	04e69963          	bne	a3,a4,ffffffffc020a032 <sfs_dirent_read_nolock+0x64>
ffffffffc0209fe4:	479c                	lw	a5,8(a5)
ffffffffc0209fe6:	04f67663          	bgeu	a2,a5,ffffffffc020a032 <sfs_dirent_read_nolock+0x64>
ffffffffc0209fea:	0874                	addi	a3,sp,28
ffffffffc0209fec:	842a                	mv	s0,a0
ffffffffc0209fee:	a43ff0ef          	jal	ffffffffc0209a30 <sfs_bmap_load_nolock>
ffffffffc0209ff2:	c511                	beqz	a0,ffffffffc0209ffe <sfs_dirent_read_nolock+0x30>
ffffffffc0209ff4:	70e2                	ld	ra,56(sp)
ffffffffc0209ff6:	7442                	ld	s0,48(sp)
ffffffffc0209ff8:	74a2                	ld	s1,40(sp)
ffffffffc0209ffa:	6121                	addi	sp,sp,64
ffffffffc0209ffc:	8082                	ret
ffffffffc0209ffe:	45f2                	lw	a1,28(sp)
ffffffffc020a000:	c9a9                	beqz	a1,ffffffffc020a052 <sfs_dirent_read_nolock+0x84>
ffffffffc020a002:	405c                	lw	a5,4(s0)
ffffffffc020a004:	04f5f763          	bgeu	a1,a5,ffffffffc020a052 <sfs_dirent_read_nolock+0x84>
ffffffffc020a008:	7c08                	ld	a0,56(s0)
ffffffffc020a00a:	e42e                	sd	a1,8(sp)
ffffffffc020a00c:	e39fe0ef          	jal	ffffffffc0208e44 <bitmap_test>
ffffffffc020a010:	ed39                	bnez	a0,ffffffffc020a06e <sfs_dirent_read_nolock+0xa0>
ffffffffc020a012:	66a2                	ld	a3,8(sp)
ffffffffc020a014:	8522                	mv	a0,s0
ffffffffc020a016:	4701                	li	a4,0
ffffffffc020a018:	10400613          	li	a2,260
ffffffffc020a01c:	85a6                	mv	a1,s1
ffffffffc020a01e:	3ed000ef          	jal	ffffffffc020ac0a <sfs_rbuf>
ffffffffc020a022:	f969                	bnez	a0,ffffffffc0209ff4 <sfs_dirent_read_nolock+0x26>
ffffffffc020a024:	100481a3          	sb	zero,259(s1)
ffffffffc020a028:	70e2                	ld	ra,56(sp)
ffffffffc020a02a:	7442                	ld	s0,48(sp)
ffffffffc020a02c:	74a2                	ld	s1,40(sp)
ffffffffc020a02e:	6121                	addi	sp,sp,64
ffffffffc020a030:	8082                	ret
ffffffffc020a032:	00004697          	auipc	a3,0x4
ffffffffc020a036:	4ce68693          	addi	a3,a3,1230 # ffffffffc020e500 <etext+0x30fe>
ffffffffc020a03a:	00002617          	auipc	a2,0x2
ffffffffc020a03e:	80660613          	addi	a2,a2,-2042 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a042:	18e00593          	li	a1,398
ffffffffc020a046:	00004517          	auipc	a0,0x4
ffffffffc020a04a:	32a50513          	addi	a0,a0,810 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a04e:	bfcf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a052:	4054                	lw	a3,4(s0)
ffffffffc020a054:	872e                	mv	a4,a1
ffffffffc020a056:	00004617          	auipc	a2,0x4
ffffffffc020a05a:	34a60613          	addi	a2,a2,842 # ffffffffc020e3a0 <etext+0x2f9e>
ffffffffc020a05e:	05300593          	li	a1,83
ffffffffc020a062:	00004517          	auipc	a0,0x4
ffffffffc020a066:	30e50513          	addi	a0,a0,782 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a06a:	be0f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a06e:	00004697          	auipc	a3,0x4
ffffffffc020a072:	36a68693          	addi	a3,a3,874 # ffffffffc020e3d8 <etext+0x2fd6>
ffffffffc020a076:	00001617          	auipc	a2,0x1
ffffffffc020a07a:	7ca60613          	addi	a2,a2,1994 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a07e:	19500593          	li	a1,405
ffffffffc020a082:	00004517          	auipc	a0,0x4
ffffffffc020a086:	2ee50513          	addi	a0,a0,750 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a08a:	bc0f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a08e <sfs_getdirentry>:
ffffffffc020a08e:	715d                	addi	sp,sp,-80
ffffffffc020a090:	f052                	sd	s4,32(sp)
ffffffffc020a092:	8a2a                	mv	s4,a0
ffffffffc020a094:	10400513          	li	a0,260
ffffffffc020a098:	e85a                	sd	s6,16(sp)
ffffffffc020a09a:	e486                	sd	ra,72(sp)
ffffffffc020a09c:	e0a2                	sd	s0,64(sp)
ffffffffc020a09e:	8b2e                	mv	s6,a1
ffffffffc020a0a0:	f35f70ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc020a0a4:	0e050963          	beqz	a0,ffffffffc020a196 <sfs_getdirentry+0x108>
ffffffffc020a0a8:	ec56                	sd	s5,24(sp)
ffffffffc020a0aa:	068a3a83          	ld	s5,104(s4)
ffffffffc020a0ae:	0e0a8663          	beqz	s5,ffffffffc020a19a <sfs_getdirentry+0x10c>
ffffffffc020a0b2:	0b0aa783          	lw	a5,176(s5)
ffffffffc020a0b6:	0e079263          	bnez	a5,ffffffffc020a19a <sfs_getdirentry+0x10c>
ffffffffc020a0ba:	058a2703          	lw	a4,88(s4)
ffffffffc020a0be:	6785                	lui	a5,0x1
ffffffffc020a0c0:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a0c4:	10f71063          	bne	a4,a5,ffffffffc020a1c4 <sfs_getdirentry+0x136>
ffffffffc020a0c8:	f44e                	sd	s3,40(sp)
ffffffffc020a0ca:	57fd                	li	a5,-1
ffffffffc020a0cc:	008b3983          	ld	s3,8(s6)
ffffffffc020a0d0:	17fe                	slli	a5,a5,0x3f
ffffffffc020a0d2:	0ff78793          	addi	a5,a5,255
ffffffffc020a0d6:	00f9f7b3          	and	a5,s3,a5
ffffffffc020a0da:	e3d5                	bnez	a5,ffffffffc020a17e <sfs_getdirentry+0xf0>
ffffffffc020a0dc:	000a3783          	ld	a5,0(s4)
ffffffffc020a0e0:	0089d993          	srli	s3,s3,0x8
ffffffffc020a0e4:	2981                	sext.w	s3,s3
ffffffffc020a0e6:	479c                	lw	a5,8(a5)
ffffffffc020a0e8:	0b37e163          	bltu	a5,s3,ffffffffc020a18a <sfs_getdirentry+0xfc>
ffffffffc020a0ec:	f84a                	sd	s2,48(sp)
ffffffffc020a0ee:	892a                	mv	s2,a0
ffffffffc020a0f0:	020a0513          	addi	a0,s4,32
ffffffffc020a0f4:	e45e                	sd	s7,8(sp)
ffffffffc020a0f6:	aa6fa0ef          	jal	ffffffffc020439c <down>
ffffffffc020a0fa:	000a3783          	ld	a5,0(s4)
ffffffffc020a0fe:	0087ab83          	lw	s7,8(a5)
ffffffffc020a102:	07705c63          	blez	s7,ffffffffc020a17a <sfs_getdirentry+0xec>
ffffffffc020a106:	fc26                	sd	s1,56(sp)
ffffffffc020a108:	4481                	li	s1,0
ffffffffc020a10a:	a811                	j	ffffffffc020a11e <sfs_getdirentry+0x90>
ffffffffc020a10c:	00092783          	lw	a5,0(s2)
ffffffffc020a110:	c781                	beqz	a5,ffffffffc020a118 <sfs_getdirentry+0x8a>
ffffffffc020a112:	02098463          	beqz	s3,ffffffffc020a13a <sfs_getdirentry+0xac>
ffffffffc020a116:	39fd                	addiw	s3,s3,-1
ffffffffc020a118:	2485                	addiw	s1,s1,1
ffffffffc020a11a:	049b8d63          	beq	s7,s1,ffffffffc020a174 <sfs_getdirentry+0xe6>
ffffffffc020a11e:	86ca                	mv	a3,s2
ffffffffc020a120:	8626                	mv	a2,s1
ffffffffc020a122:	85d2                	mv	a1,s4
ffffffffc020a124:	8556                	mv	a0,s5
ffffffffc020a126:	ea9ff0ef          	jal	ffffffffc0209fce <sfs_dirent_read_nolock>
ffffffffc020a12a:	842a                	mv	s0,a0
ffffffffc020a12c:	d165                	beqz	a0,ffffffffc020a10c <sfs_getdirentry+0x7e>
ffffffffc020a12e:	74e2                	ld	s1,56(sp)
ffffffffc020a130:	020a0513          	addi	a0,s4,32
ffffffffc020a134:	a64fa0ef          	jal	ffffffffc0204398 <up>
ffffffffc020a138:	a005                	j	ffffffffc020a158 <sfs_getdirentry+0xca>
ffffffffc020a13a:	020a0513          	addi	a0,s4,32
ffffffffc020a13e:	a5afa0ef          	jal	ffffffffc0204398 <up>
ffffffffc020a142:	855a                	mv	a0,s6
ffffffffc020a144:	00490593          	addi	a1,s2,4
ffffffffc020a148:	4701                	li	a4,0
ffffffffc020a14a:	4685                	li	a3,1
ffffffffc020a14c:	10000613          	li	a2,256
ffffffffc020a150:	8ecfb0ef          	jal	ffffffffc020523c <iobuf_move>
ffffffffc020a154:	74e2                	ld	s1,56(sp)
ffffffffc020a156:	842a                	mv	s0,a0
ffffffffc020a158:	854a                	mv	a0,s2
ffffffffc020a15a:	f21f70ef          	jal	ffffffffc020207a <kfree>
ffffffffc020a15e:	7942                	ld	s2,48(sp)
ffffffffc020a160:	79a2                	ld	s3,40(sp)
ffffffffc020a162:	6ae2                	ld	s5,24(sp)
ffffffffc020a164:	6ba2                	ld	s7,8(sp)
ffffffffc020a166:	60a6                	ld	ra,72(sp)
ffffffffc020a168:	8522                	mv	a0,s0
ffffffffc020a16a:	6406                	ld	s0,64(sp)
ffffffffc020a16c:	7a02                	ld	s4,32(sp)
ffffffffc020a16e:	6b42                	ld	s6,16(sp)
ffffffffc020a170:	6161                	addi	sp,sp,80
ffffffffc020a172:	8082                	ret
ffffffffc020a174:	74e2                	ld	s1,56(sp)
ffffffffc020a176:	5441                	li	s0,-16
ffffffffc020a178:	bf65                	j	ffffffffc020a130 <sfs_getdirentry+0xa2>
ffffffffc020a17a:	5441                	li	s0,-16
ffffffffc020a17c:	bf55                	j	ffffffffc020a130 <sfs_getdirentry+0xa2>
ffffffffc020a17e:	efdf70ef          	jal	ffffffffc020207a <kfree>
ffffffffc020a182:	5475                	li	s0,-3
ffffffffc020a184:	79a2                	ld	s3,40(sp)
ffffffffc020a186:	6ae2                	ld	s5,24(sp)
ffffffffc020a188:	bff9                	j	ffffffffc020a166 <sfs_getdirentry+0xd8>
ffffffffc020a18a:	ef1f70ef          	jal	ffffffffc020207a <kfree>
ffffffffc020a18e:	5441                	li	s0,-16
ffffffffc020a190:	79a2                	ld	s3,40(sp)
ffffffffc020a192:	6ae2                	ld	s5,24(sp)
ffffffffc020a194:	bfc9                	j	ffffffffc020a166 <sfs_getdirentry+0xd8>
ffffffffc020a196:	5471                	li	s0,-4
ffffffffc020a198:	b7f9                	j	ffffffffc020a166 <sfs_getdirentry+0xd8>
ffffffffc020a19a:	00004697          	auipc	a3,0x4
ffffffffc020a19e:	ff668693          	addi	a3,a3,-10 # ffffffffc020e190 <etext+0x2d8e>
ffffffffc020a1a2:	00001617          	auipc	a2,0x1
ffffffffc020a1a6:	69e60613          	addi	a2,a2,1694 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a1aa:	33d00593          	li	a1,829
ffffffffc020a1ae:	00004517          	auipc	a0,0x4
ffffffffc020a1b2:	1c250513          	addi	a0,a0,450 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a1b6:	fc26                	sd	s1,56(sp)
ffffffffc020a1b8:	f84a                	sd	s2,48(sp)
ffffffffc020a1ba:	f44e                	sd	s3,40(sp)
ffffffffc020a1bc:	e45e                	sd	s7,8(sp)
ffffffffc020a1be:	e062                	sd	s8,0(sp)
ffffffffc020a1c0:	a8af60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a1c4:	00004697          	auipc	a3,0x4
ffffffffc020a1c8:	17468693          	addi	a3,a3,372 # ffffffffc020e338 <etext+0x2f36>
ffffffffc020a1cc:	00001617          	auipc	a2,0x1
ffffffffc020a1d0:	67460613          	addi	a2,a2,1652 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a1d4:	33e00593          	li	a1,830
ffffffffc020a1d8:	00004517          	auipc	a0,0x4
ffffffffc020a1dc:	19850513          	addi	a0,a0,408 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a1e0:	fc26                	sd	s1,56(sp)
ffffffffc020a1e2:	f84a                	sd	s2,48(sp)
ffffffffc020a1e4:	f44e                	sd	s3,40(sp)
ffffffffc020a1e6:	e45e                	sd	s7,8(sp)
ffffffffc020a1e8:	e062                	sd	s8,0(sp)
ffffffffc020a1ea:	a60f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a1ee <sfs_truncfile>:
ffffffffc020a1ee:	080007b7          	lui	a5,0x8000
ffffffffc020a1f2:	1ab7eb63          	bltu	a5,a1,ffffffffc020a3a8 <sfs_truncfile+0x1ba>
ffffffffc020a1f6:	7159                	addi	sp,sp,-112
ffffffffc020a1f8:	e0d2                	sd	s4,64(sp)
ffffffffc020a1fa:	06853a03          	ld	s4,104(a0)
ffffffffc020a1fe:	e8ca                	sd	s2,80(sp)
ffffffffc020a200:	e4ce                	sd	s3,72(sp)
ffffffffc020a202:	f486                	sd	ra,104(sp)
ffffffffc020a204:	f0a2                	sd	s0,96(sp)
ffffffffc020a206:	fc56                	sd	s5,56(sp)
ffffffffc020a208:	892a                	mv	s2,a0
ffffffffc020a20a:	89ae                	mv	s3,a1
ffffffffc020a20c:	1a0a0163          	beqz	s4,ffffffffc020a3ae <sfs_truncfile+0x1c0>
ffffffffc020a210:	0b0a2783          	lw	a5,176(s4)
ffffffffc020a214:	18079d63          	bnez	a5,ffffffffc020a3ae <sfs_truncfile+0x1c0>
ffffffffc020a218:	4d38                	lw	a4,88(a0)
ffffffffc020a21a:	6785                	lui	a5,0x1
ffffffffc020a21c:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a220:	6405                	lui	s0,0x1
ffffffffc020a222:	1cf71963          	bne	a4,a5,ffffffffc020a3f4 <sfs_truncfile+0x206>
ffffffffc020a226:	00053a83          	ld	s5,0(a0)
ffffffffc020a22a:	147d                	addi	s0,s0,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020a22c:	942e                	add	s0,s0,a1
ffffffffc020a22e:	000ae783          	lwu	a5,0(s5)
ffffffffc020a232:	8031                	srli	s0,s0,0xc
ffffffffc020a234:	2401                	sext.w	s0,s0
ffffffffc020a236:	02b79063          	bne	a5,a1,ffffffffc020a256 <sfs_truncfile+0x68>
ffffffffc020a23a:	008aa703          	lw	a4,8(s5)
ffffffffc020a23e:	4781                	li	a5,0
ffffffffc020a240:	1c871c63          	bne	a4,s0,ffffffffc020a418 <sfs_truncfile+0x22a>
ffffffffc020a244:	70a6                	ld	ra,104(sp)
ffffffffc020a246:	7406                	ld	s0,96(sp)
ffffffffc020a248:	6946                	ld	s2,80(sp)
ffffffffc020a24a:	69a6                	ld	s3,72(sp)
ffffffffc020a24c:	6a06                	ld	s4,64(sp)
ffffffffc020a24e:	7ae2                	ld	s5,56(sp)
ffffffffc020a250:	853e                	mv	a0,a5
ffffffffc020a252:	6165                	addi	sp,sp,112
ffffffffc020a254:	8082                	ret
ffffffffc020a256:	02050513          	addi	a0,a0,32
ffffffffc020a25a:	eca6                	sd	s1,88(sp)
ffffffffc020a25c:	940fa0ef          	jal	ffffffffc020439c <down>
ffffffffc020a260:	008aa483          	lw	s1,8(s5)
ffffffffc020a264:	0c84e363          	bltu	s1,s0,ffffffffc020a32a <sfs_truncfile+0x13c>
ffffffffc020a268:	0c947e63          	bgeu	s0,s1,ffffffffc020a344 <sfs_truncfile+0x156>
ffffffffc020a26c:	48ad                	li	a7,11
ffffffffc020a26e:	4305                	li	t1,1
ffffffffc020a270:	a895                	j	ffffffffc020a2e4 <sfs_truncfile+0xf6>
ffffffffc020a272:	37cd                	addiw	a5,a5,-13
ffffffffc020a274:	3ff00693          	li	a3,1023
ffffffffc020a278:	04f6ef63          	bltu	a3,a5,ffffffffc020a2d6 <sfs_truncfile+0xe8>
ffffffffc020a27c:	03c82683          	lw	a3,60(a6)
ffffffffc020a280:	cab9                	beqz	a3,ffffffffc020a2d6 <sfs_truncfile+0xe8>
ffffffffc020a282:	004a2603          	lw	a2,4(s4)
ffffffffc020a286:	1ac6fb63          	bgeu	a3,a2,ffffffffc020a43c <sfs_truncfile+0x24e>
ffffffffc020a28a:	038a3503          	ld	a0,56(s4)
ffffffffc020a28e:	85b6                	mv	a1,a3
ffffffffc020a290:	e436                	sd	a3,8(sp)
ffffffffc020a292:	e842                	sd	a6,16(sp)
ffffffffc020a294:	ec3e                	sd	a5,24(sp)
ffffffffc020a296:	baffe0ef          	jal	ffffffffc0208e44 <bitmap_test>
ffffffffc020a29a:	66a2                	ld	a3,8(sp)
ffffffffc020a29c:	6842                	ld	a6,16(sp)
ffffffffc020a29e:	67e2                	ld	a5,24(sp)
ffffffffc020a2a0:	1a051d63          	bnez	a0,ffffffffc020a45a <sfs_truncfile+0x26c>
ffffffffc020a2a4:	02079613          	slli	a2,a5,0x20
ffffffffc020a2a8:	01e65713          	srli	a4,a2,0x1e
ffffffffc020a2ac:	102c                	addi	a1,sp,40
ffffffffc020a2ae:	4611                	li	a2,4
ffffffffc020a2b0:	8552                	mv	a0,s4
ffffffffc020a2b2:	ec42                	sd	a6,24(sp)
ffffffffc020a2b4:	e83a                	sd	a4,16(sp)
ffffffffc020a2b6:	e436                	sd	a3,8(sp)
ffffffffc020a2b8:	d602                	sw	zero,44(sp)
ffffffffc020a2ba:	151000ef          	jal	ffffffffc020ac0a <sfs_rbuf>
ffffffffc020a2be:	87aa                	mv	a5,a0
ffffffffc020a2c0:	e941                	bnez	a0,ffffffffc020a350 <sfs_truncfile+0x162>
ffffffffc020a2c2:	57a2                	lw	a5,40(sp)
ffffffffc020a2c4:	66a2                	ld	a3,8(sp)
ffffffffc020a2c6:	6742                	ld	a4,16(sp)
ffffffffc020a2c8:	6862                	ld	a6,24(sp)
ffffffffc020a2ca:	48ad                	li	a7,11
ffffffffc020a2cc:	4305                	li	t1,1
ffffffffc020a2ce:	ebd5                	bnez	a5,ffffffffc020a382 <sfs_truncfile+0x194>
ffffffffc020a2d0:	00882703          	lw	a4,8(a6)
ffffffffc020a2d4:	377d                	addiw	a4,a4,-1 # 7ffffff <_binary_bin_sfs_img_size+0x7f8acff>
ffffffffc020a2d6:	00e82423          	sw	a4,8(a6)
ffffffffc020a2da:	00693823          	sd	t1,16(s2)
ffffffffc020a2de:	34fd                	addiw	s1,s1,-1
ffffffffc020a2e0:	04940e63          	beq	s0,s1,ffffffffc020a33c <sfs_truncfile+0x14e>
ffffffffc020a2e4:	00093803          	ld	a6,0(s2)
ffffffffc020a2e8:	00882783          	lw	a5,8(a6)
ffffffffc020a2ec:	0e078363          	beqz	a5,ffffffffc020a3d2 <sfs_truncfile+0x1e4>
ffffffffc020a2f0:	fff7871b          	addiw	a4,a5,-1
ffffffffc020a2f4:	f6e8efe3          	bltu	a7,a4,ffffffffc020a272 <sfs_truncfile+0x84>
ffffffffc020a2f8:	02071693          	slli	a3,a4,0x20
ffffffffc020a2fc:	01e6d793          	srli	a5,a3,0x1e
ffffffffc020a300:	97c2                	add	a5,a5,a6
ffffffffc020a302:	47cc                	lw	a1,12(a5)
ffffffffc020a304:	d9e9                	beqz	a1,ffffffffc020a2d6 <sfs_truncfile+0xe8>
ffffffffc020a306:	8552                	mv	a0,s4
ffffffffc020a308:	e83e                	sd	a5,16(sp)
ffffffffc020a30a:	e442                	sd	a6,8(sp)
ffffffffc020a30c:	c68ff0ef          	jal	ffffffffc0209774 <sfs_block_free>
ffffffffc020a310:	67c2                	ld	a5,16(sp)
ffffffffc020a312:	6822                	ld	a6,8(sp)
ffffffffc020a314:	48ad                	li	a7,11
ffffffffc020a316:	0007a623          	sw	zero,12(a5)
ffffffffc020a31a:	00882703          	lw	a4,8(a6)
ffffffffc020a31e:	4305                	li	t1,1
ffffffffc020a320:	377d                	addiw	a4,a4,-1
ffffffffc020a322:	bf55                	j	ffffffffc020a2d6 <sfs_truncfile+0xe8>
ffffffffc020a324:	2485                	addiw	s1,s1,1
ffffffffc020a326:	00940b63          	beq	s0,s1,ffffffffc020a33c <sfs_truncfile+0x14e>
ffffffffc020a32a:	4681                	li	a3,0
ffffffffc020a32c:	8626                	mv	a2,s1
ffffffffc020a32e:	85ca                	mv	a1,s2
ffffffffc020a330:	8552                	mv	a0,s4
ffffffffc020a332:	efeff0ef          	jal	ffffffffc0209a30 <sfs_bmap_load_nolock>
ffffffffc020a336:	87aa                	mv	a5,a0
ffffffffc020a338:	d575                	beqz	a0,ffffffffc020a324 <sfs_truncfile+0x136>
ffffffffc020a33a:	a819                	j	ffffffffc020a350 <sfs_truncfile+0x162>
ffffffffc020a33c:	008aa783          	lw	a5,8(s5)
ffffffffc020a340:	02879063          	bne	a5,s0,ffffffffc020a360 <sfs_truncfile+0x172>
ffffffffc020a344:	4785                	li	a5,1
ffffffffc020a346:	013aa023          	sw	s3,0(s5)
ffffffffc020a34a:	00f93823          	sd	a5,16(s2)
ffffffffc020a34e:	4781                	li	a5,0
ffffffffc020a350:	02090513          	addi	a0,s2,32
ffffffffc020a354:	e43e                	sd	a5,8(sp)
ffffffffc020a356:	842fa0ef          	jal	ffffffffc0204398 <up>
ffffffffc020a35a:	67a2                	ld	a5,8(sp)
ffffffffc020a35c:	64e6                	ld	s1,88(sp)
ffffffffc020a35e:	b5dd                	j	ffffffffc020a244 <sfs_truncfile+0x56>
ffffffffc020a360:	00004697          	auipc	a3,0x4
ffffffffc020a364:	25868693          	addi	a3,a3,600 # ffffffffc020e5b8 <etext+0x31b6>
ffffffffc020a368:	00001617          	auipc	a2,0x1
ffffffffc020a36c:	4d860613          	addi	a2,a2,1240 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a370:	3cd00593          	li	a1,973
ffffffffc020a374:	00004517          	auipc	a0,0x4
ffffffffc020a378:	ffc50513          	addi	a0,a0,-4 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a37c:	f85a                	sd	s6,48(sp)
ffffffffc020a37e:	8ccf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a382:	4611                	li	a2,4
ffffffffc020a384:	106c                	addi	a1,sp,44
ffffffffc020a386:	8552                	mv	a0,s4
ffffffffc020a388:	e442                	sd	a6,8(sp)
ffffffffc020a38a:	101000ef          	jal	ffffffffc020ac8a <sfs_wbuf>
ffffffffc020a38e:	87aa                	mv	a5,a0
ffffffffc020a390:	f161                	bnez	a0,ffffffffc020a350 <sfs_truncfile+0x162>
ffffffffc020a392:	55a2                	lw	a1,40(sp)
ffffffffc020a394:	8552                	mv	a0,s4
ffffffffc020a396:	bdeff0ef          	jal	ffffffffc0209774 <sfs_block_free>
ffffffffc020a39a:	6822                	ld	a6,8(sp)
ffffffffc020a39c:	4305                	li	t1,1
ffffffffc020a39e:	48ad                	li	a7,11
ffffffffc020a3a0:	00882703          	lw	a4,8(a6)
ffffffffc020a3a4:	377d                	addiw	a4,a4,-1
ffffffffc020a3a6:	bf05                	j	ffffffffc020a2d6 <sfs_truncfile+0xe8>
ffffffffc020a3a8:	57f5                	li	a5,-3
ffffffffc020a3aa:	853e                	mv	a0,a5
ffffffffc020a3ac:	8082                	ret
ffffffffc020a3ae:	00004697          	auipc	a3,0x4
ffffffffc020a3b2:	de268693          	addi	a3,a3,-542 # ffffffffc020e190 <etext+0x2d8e>
ffffffffc020a3b6:	00001617          	auipc	a2,0x1
ffffffffc020a3ba:	48a60613          	addi	a2,a2,1162 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a3be:	3ac00593          	li	a1,940
ffffffffc020a3c2:	00004517          	auipc	a0,0x4
ffffffffc020a3c6:	fae50513          	addi	a0,a0,-82 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a3ca:	eca6                	sd	s1,88(sp)
ffffffffc020a3cc:	f85a                	sd	s6,48(sp)
ffffffffc020a3ce:	87cf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a3d2:	00004697          	auipc	a3,0x4
ffffffffc020a3d6:	19668693          	addi	a3,a3,406 # ffffffffc020e568 <etext+0x3166>
ffffffffc020a3da:	00001617          	auipc	a2,0x1
ffffffffc020a3de:	46660613          	addi	a2,a2,1126 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a3e2:	17b00593          	li	a1,379
ffffffffc020a3e6:	00004517          	auipc	a0,0x4
ffffffffc020a3ea:	f8a50513          	addi	a0,a0,-118 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a3ee:	f85a                	sd	s6,48(sp)
ffffffffc020a3f0:	85af60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a3f4:	00004697          	auipc	a3,0x4
ffffffffc020a3f8:	f4468693          	addi	a3,a3,-188 # ffffffffc020e338 <etext+0x2f36>
ffffffffc020a3fc:	00001617          	auipc	a2,0x1
ffffffffc020a400:	44460613          	addi	a2,a2,1092 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a404:	3ad00593          	li	a1,941
ffffffffc020a408:	00004517          	auipc	a0,0x4
ffffffffc020a40c:	f6850513          	addi	a0,a0,-152 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a410:	eca6                	sd	s1,88(sp)
ffffffffc020a412:	f85a                	sd	s6,48(sp)
ffffffffc020a414:	836f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a418:	00004697          	auipc	a3,0x4
ffffffffc020a41c:	13868693          	addi	a3,a3,312 # ffffffffc020e550 <etext+0x314e>
ffffffffc020a420:	00001617          	auipc	a2,0x1
ffffffffc020a424:	42060613          	addi	a2,a2,1056 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a428:	3b400593          	li	a1,948
ffffffffc020a42c:	00004517          	auipc	a0,0x4
ffffffffc020a430:	f4450513          	addi	a0,a0,-188 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a434:	eca6                	sd	s1,88(sp)
ffffffffc020a436:	f85a                	sd	s6,48(sp)
ffffffffc020a438:	812f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a43c:	8736                	mv	a4,a3
ffffffffc020a43e:	05300593          	li	a1,83
ffffffffc020a442:	86b2                	mv	a3,a2
ffffffffc020a444:	00004517          	auipc	a0,0x4
ffffffffc020a448:	f2c50513          	addi	a0,a0,-212 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a44c:	00004617          	auipc	a2,0x4
ffffffffc020a450:	f5460613          	addi	a2,a2,-172 # ffffffffc020e3a0 <etext+0x2f9e>
ffffffffc020a454:	f85a                	sd	s6,48(sp)
ffffffffc020a456:	ff5f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a45a:	00004697          	auipc	a3,0x4
ffffffffc020a45e:	12668693          	addi	a3,a3,294 # ffffffffc020e580 <etext+0x317e>
ffffffffc020a462:	00001617          	auipc	a2,0x1
ffffffffc020a466:	3de60613          	addi	a2,a2,990 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a46a:	12b00593          	li	a1,299
ffffffffc020a46e:	00004517          	auipc	a0,0x4
ffffffffc020a472:	f0250513          	addi	a0,a0,-254 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a476:	f85a                	sd	s6,48(sp)
ffffffffc020a478:	fd3f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a47c <sfs_load_inode>:
ffffffffc020a47c:	7139                	addi	sp,sp,-64
ffffffffc020a47e:	fc06                	sd	ra,56(sp)
ffffffffc020a480:	f822                	sd	s0,48(sp)
ffffffffc020a482:	f426                	sd	s1,40(sp)
ffffffffc020a484:	f04a                	sd	s2,32(sp)
ffffffffc020a486:	84b2                	mv	s1,a2
ffffffffc020a488:	892a                	mv	s2,a0
ffffffffc020a48a:	ec4e                	sd	s3,24(sp)
ffffffffc020a48c:	89ae                	mv	s3,a1
ffffffffc020a48e:	1b1000ef          	jal	ffffffffc020ae3e <lock_sfs_fs>
ffffffffc020a492:	8526                	mv	a0,s1
ffffffffc020a494:	45a9                	li	a1,10
ffffffffc020a496:	0a893403          	ld	s0,168(s2)
ffffffffc020a49a:	1c5000ef          	jal	ffffffffc020ae5e <hash32>
ffffffffc020a49e:	02051793          	slli	a5,a0,0x20
ffffffffc020a4a2:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020a4a6:	00a406b3          	add	a3,s0,a0
ffffffffc020a4aa:	87b6                	mv	a5,a3
ffffffffc020a4ac:	a029                	j	ffffffffc020a4b6 <sfs_load_inode+0x3a>
ffffffffc020a4ae:	fc07a703          	lw	a4,-64(a5)
ffffffffc020a4b2:	10970563          	beq	a4,s1,ffffffffc020a5bc <sfs_load_inode+0x140>
ffffffffc020a4b6:	679c                	ld	a5,8(a5)
ffffffffc020a4b8:	fef69be3          	bne	a3,a5,ffffffffc020a4ae <sfs_load_inode+0x32>
ffffffffc020a4bc:	04000513          	li	a0,64
ffffffffc020a4c0:	b15f70ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc020a4c4:	87aa                	mv	a5,a0
ffffffffc020a4c6:	10050b63          	beqz	a0,ffffffffc020a5dc <sfs_load_inode+0x160>
ffffffffc020a4ca:	14048f63          	beqz	s1,ffffffffc020a628 <sfs_load_inode+0x1ac>
ffffffffc020a4ce:	00492703          	lw	a4,4(s2)
ffffffffc020a4d2:	14e4fb63          	bgeu	s1,a4,ffffffffc020a628 <sfs_load_inode+0x1ac>
ffffffffc020a4d6:	03893503          	ld	a0,56(s2)
ffffffffc020a4da:	85a6                	mv	a1,s1
ffffffffc020a4dc:	e43e                	sd	a5,8(sp)
ffffffffc020a4de:	967fe0ef          	jal	ffffffffc0208e44 <bitmap_test>
ffffffffc020a4e2:	16051263          	bnez	a0,ffffffffc020a646 <sfs_load_inode+0x1ca>
ffffffffc020a4e6:	65a2                	ld	a1,8(sp)
ffffffffc020a4e8:	4701                	li	a4,0
ffffffffc020a4ea:	86a6                	mv	a3,s1
ffffffffc020a4ec:	04000613          	li	a2,64
ffffffffc020a4f0:	854a                	mv	a0,s2
ffffffffc020a4f2:	718000ef          	jal	ffffffffc020ac0a <sfs_rbuf>
ffffffffc020a4f6:	67a2                	ld	a5,8(sp)
ffffffffc020a4f8:	842a                	mv	s0,a0
ffffffffc020a4fa:	0e051e63          	bnez	a0,ffffffffc020a5f6 <sfs_load_inode+0x17a>
ffffffffc020a4fe:	0067d703          	lhu	a4,6(a5)
ffffffffc020a502:	10070363          	beqz	a4,ffffffffc020a608 <sfs_load_inode+0x18c>
ffffffffc020a506:	6505                	lui	a0,0x1
ffffffffc020a508:	23550513          	addi	a0,a0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a50c:	e43e                	sd	a5,8(sp)
ffffffffc020a50e:	8acfd0ef          	jal	ffffffffc02075ba <__alloc_inode>
ffffffffc020a512:	67a2                	ld	a5,8(sp)
ffffffffc020a514:	842a                	mv	s0,a0
ffffffffc020a516:	cd79                	beqz	a0,ffffffffc020a5f4 <sfs_load_inode+0x178>
ffffffffc020a518:	0047d683          	lhu	a3,4(a5)
ffffffffc020a51c:	4705                	li	a4,1
ffffffffc020a51e:	0ee68063          	beq	a3,a4,ffffffffc020a5fe <sfs_load_inode+0x182>
ffffffffc020a522:	4709                	li	a4,2
ffffffffc020a524:	00005597          	auipc	a1,0x5
ffffffffc020a528:	e0c58593          	addi	a1,a1,-500 # ffffffffc020f330 <sfs_node_dirops>
ffffffffc020a52c:	16e69d63          	bne	a3,a4,ffffffffc020a6a6 <sfs_load_inode+0x22a>
ffffffffc020a530:	864a                	mv	a2,s2
ffffffffc020a532:	8522                	mv	a0,s0
ffffffffc020a534:	e43e                	sd	a5,8(sp)
ffffffffc020a536:	8a0fd0ef          	jal	ffffffffc02075d6 <inode_init>
ffffffffc020a53a:	4c34                	lw	a3,88(s0)
ffffffffc020a53c:	6705                	lui	a4,0x1
ffffffffc020a53e:	23570713          	addi	a4,a4,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a542:	67a2                	ld	a5,8(sp)
ffffffffc020a544:	14e69163          	bne	a3,a4,ffffffffc020a686 <sfs_load_inode+0x20a>
ffffffffc020a548:	4585                	li	a1,1
ffffffffc020a54a:	e01c                	sd	a5,0(s0)
ffffffffc020a54c:	c404                	sw	s1,8(s0)
ffffffffc020a54e:	00043823          	sd	zero,16(s0)
ffffffffc020a552:	cc0c                	sw	a1,24(s0)
ffffffffc020a554:	02040513          	addi	a0,s0,32
ffffffffc020a558:	e436                	sd	a3,8(sp)
ffffffffc020a55a:	e39f90ef          	jal	ffffffffc0204392 <sem_init>
ffffffffc020a55e:	4c3c                	lw	a5,88(s0)
ffffffffc020a560:	66a2                	ld	a3,8(sp)
ffffffffc020a562:	10d79263          	bne	a5,a3,ffffffffc020a666 <sfs_load_inode+0x1ea>
ffffffffc020a566:	0a093703          	ld	a4,160(s2)
ffffffffc020a56a:	03840793          	addi	a5,s0,56
ffffffffc020a56e:	4408                	lw	a0,8(s0)
ffffffffc020a570:	e31c                	sd	a5,0(a4)
ffffffffc020a572:	0af93023          	sd	a5,160(s2)
ffffffffc020a576:	09890793          	addi	a5,s2,152
ffffffffc020a57a:	e038                	sd	a4,64(s0)
ffffffffc020a57c:	fc1c                	sd	a5,56(s0)
ffffffffc020a57e:	45a9                	li	a1,10
ffffffffc020a580:	0a893483          	ld	s1,168(s2)
ffffffffc020a584:	0db000ef          	jal	ffffffffc020ae5e <hash32>
ffffffffc020a588:	02051713          	slli	a4,a0,0x20
ffffffffc020a58c:	01c75793          	srli	a5,a4,0x1c
ffffffffc020a590:	97a6                	add	a5,a5,s1
ffffffffc020a592:	6798                	ld	a4,8(a5)
ffffffffc020a594:	04840693          	addi	a3,s0,72
ffffffffc020a598:	e314                	sd	a3,0(a4)
ffffffffc020a59a:	e794                	sd	a3,8(a5)
ffffffffc020a59c:	e838                	sd	a4,80(s0)
ffffffffc020a59e:	e43c                	sd	a5,72(s0)
ffffffffc020a5a0:	854a                	mv	a0,s2
ffffffffc020a5a2:	0ad000ef          	jal	ffffffffc020ae4e <unlock_sfs_fs>
ffffffffc020a5a6:	0089b023          	sd	s0,0(s3)
ffffffffc020a5aa:	4401                	li	s0,0
ffffffffc020a5ac:	70e2                	ld	ra,56(sp)
ffffffffc020a5ae:	8522                	mv	a0,s0
ffffffffc020a5b0:	7442                	ld	s0,48(sp)
ffffffffc020a5b2:	74a2                	ld	s1,40(sp)
ffffffffc020a5b4:	7902                	ld	s2,32(sp)
ffffffffc020a5b6:	69e2                	ld	s3,24(sp)
ffffffffc020a5b8:	6121                	addi	sp,sp,64
ffffffffc020a5ba:	8082                	ret
ffffffffc020a5bc:	fb878413          	addi	s0,a5,-72
ffffffffc020a5c0:	8522                	mv	a0,s0
ffffffffc020a5c2:	e43e                	sd	a5,8(sp)
ffffffffc020a5c4:	874fd0ef          	jal	ffffffffc0207638 <inode_ref_inc>
ffffffffc020a5c8:	4705                	li	a4,1
ffffffffc020a5ca:	67a2                	ld	a5,8(sp)
ffffffffc020a5cc:	fce51ae3          	bne	a0,a4,ffffffffc020a5a0 <sfs_load_inode+0x124>
ffffffffc020a5d0:	fd07a703          	lw	a4,-48(a5)
ffffffffc020a5d4:	2705                	addiw	a4,a4,1
ffffffffc020a5d6:	fce7a823          	sw	a4,-48(a5)
ffffffffc020a5da:	b7d9                	j	ffffffffc020a5a0 <sfs_load_inode+0x124>
ffffffffc020a5dc:	5471                	li	s0,-4
ffffffffc020a5de:	854a                	mv	a0,s2
ffffffffc020a5e0:	06f000ef          	jal	ffffffffc020ae4e <unlock_sfs_fs>
ffffffffc020a5e4:	70e2                	ld	ra,56(sp)
ffffffffc020a5e6:	8522                	mv	a0,s0
ffffffffc020a5e8:	7442                	ld	s0,48(sp)
ffffffffc020a5ea:	74a2                	ld	s1,40(sp)
ffffffffc020a5ec:	7902                	ld	s2,32(sp)
ffffffffc020a5ee:	69e2                	ld	s3,24(sp)
ffffffffc020a5f0:	6121                	addi	sp,sp,64
ffffffffc020a5f2:	8082                	ret
ffffffffc020a5f4:	5471                	li	s0,-4
ffffffffc020a5f6:	853e                	mv	a0,a5
ffffffffc020a5f8:	a83f70ef          	jal	ffffffffc020207a <kfree>
ffffffffc020a5fc:	b7cd                	j	ffffffffc020a5de <sfs_load_inode+0x162>
ffffffffc020a5fe:	00005597          	auipc	a1,0x5
ffffffffc020a602:	cb258593          	addi	a1,a1,-846 # ffffffffc020f2b0 <sfs_node_fileops>
ffffffffc020a606:	b72d                	j	ffffffffc020a530 <sfs_load_inode+0xb4>
ffffffffc020a608:	00004697          	auipc	a3,0x4
ffffffffc020a60c:	fc868693          	addi	a3,a3,-56 # ffffffffc020e5d0 <etext+0x31ce>
ffffffffc020a610:	00001617          	auipc	a2,0x1
ffffffffc020a614:	23060613          	addi	a2,a2,560 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a618:	0ad00593          	li	a1,173
ffffffffc020a61c:	00004517          	auipc	a0,0x4
ffffffffc020a620:	d5450513          	addi	a0,a0,-684 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a624:	e27f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a628:	00492683          	lw	a3,4(s2)
ffffffffc020a62c:	8726                	mv	a4,s1
ffffffffc020a62e:	00004617          	auipc	a2,0x4
ffffffffc020a632:	d7260613          	addi	a2,a2,-654 # ffffffffc020e3a0 <etext+0x2f9e>
ffffffffc020a636:	05300593          	li	a1,83
ffffffffc020a63a:	00004517          	auipc	a0,0x4
ffffffffc020a63e:	d3650513          	addi	a0,a0,-714 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a642:	e09f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a646:	00004697          	auipc	a3,0x4
ffffffffc020a64a:	d9268693          	addi	a3,a3,-622 # ffffffffc020e3d8 <etext+0x2fd6>
ffffffffc020a64e:	00001617          	auipc	a2,0x1
ffffffffc020a652:	1f260613          	addi	a2,a2,498 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a656:	0a800593          	li	a1,168
ffffffffc020a65a:	00004517          	auipc	a0,0x4
ffffffffc020a65e:	d1650513          	addi	a0,a0,-746 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a662:	de9f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a666:	00004697          	auipc	a3,0x4
ffffffffc020a66a:	cd268693          	addi	a3,a3,-814 # ffffffffc020e338 <etext+0x2f36>
ffffffffc020a66e:	00001617          	auipc	a2,0x1
ffffffffc020a672:	1d260613          	addi	a2,a2,466 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a676:	0b100593          	li	a1,177
ffffffffc020a67a:	00004517          	auipc	a0,0x4
ffffffffc020a67e:	cf650513          	addi	a0,a0,-778 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a682:	dc9f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a686:	00004697          	auipc	a3,0x4
ffffffffc020a68a:	cb268693          	addi	a3,a3,-846 # ffffffffc020e338 <etext+0x2f36>
ffffffffc020a68e:	00001617          	auipc	a2,0x1
ffffffffc020a692:	1b260613          	addi	a2,a2,434 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a696:	07700593          	li	a1,119
ffffffffc020a69a:	00004517          	auipc	a0,0x4
ffffffffc020a69e:	cd650513          	addi	a0,a0,-810 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a6a2:	da9f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a6a6:	00004617          	auipc	a2,0x4
ffffffffc020a6aa:	ce260613          	addi	a2,a2,-798 # ffffffffc020e388 <etext+0x2f86>
ffffffffc020a6ae:	02e00593          	li	a1,46
ffffffffc020a6b2:	00004517          	auipc	a0,0x4
ffffffffc020a6b6:	cbe50513          	addi	a0,a0,-834 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a6ba:	d91f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a6be <sfs_lookup_once.constprop.0>:
ffffffffc020a6be:	711d                	addi	sp,sp,-96
ffffffffc020a6c0:	f852                	sd	s4,48(sp)
ffffffffc020a6c2:	8a2a                	mv	s4,a0
ffffffffc020a6c4:	02058513          	addi	a0,a1,32
ffffffffc020a6c8:	ec86                	sd	ra,88(sp)
ffffffffc020a6ca:	e0ca                	sd	s2,64(sp)
ffffffffc020a6cc:	f456                	sd	s5,40(sp)
ffffffffc020a6ce:	e862                	sd	s8,16(sp)
ffffffffc020a6d0:	8ab2                	mv	s5,a2
ffffffffc020a6d2:	892e                	mv	s2,a1
ffffffffc020a6d4:	8c36                	mv	s8,a3
ffffffffc020a6d6:	cc7f90ef          	jal	ffffffffc020439c <down>
ffffffffc020a6da:	8556                	mv	a0,s5
ffffffffc020a6dc:	40b000ef          	jal	ffffffffc020b2e6 <strlen>
ffffffffc020a6e0:	0ff00793          	li	a5,255
ffffffffc020a6e4:	0aa7e963          	bltu	a5,a0,ffffffffc020a796 <sfs_lookup_once.constprop.0+0xd8>
ffffffffc020a6e8:	10400513          	li	a0,260
ffffffffc020a6ec:	e4a6                	sd	s1,72(sp)
ffffffffc020a6ee:	8e7f70ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc020a6f2:	84aa                	mv	s1,a0
ffffffffc020a6f4:	c959                	beqz	a0,ffffffffc020a78a <sfs_lookup_once.constprop.0+0xcc>
ffffffffc020a6f6:	00093783          	ld	a5,0(s2)
ffffffffc020a6fa:	fc4e                	sd	s3,56(sp)
ffffffffc020a6fc:	0087a983          	lw	s3,8(a5)
ffffffffc020a700:	05305d63          	blez	s3,ffffffffc020a75a <sfs_lookup_once.constprop.0+0x9c>
ffffffffc020a704:	e8a2                	sd	s0,80(sp)
ffffffffc020a706:	4401                	li	s0,0
ffffffffc020a708:	a821                	j	ffffffffc020a720 <sfs_lookup_once.constprop.0+0x62>
ffffffffc020a70a:	409c                	lw	a5,0(s1)
ffffffffc020a70c:	c799                	beqz	a5,ffffffffc020a71a <sfs_lookup_once.constprop.0+0x5c>
ffffffffc020a70e:	00448593          	addi	a1,s1,4
ffffffffc020a712:	8556                	mv	a0,s5
ffffffffc020a714:	419000ef          	jal	ffffffffc020b32c <strcmp>
ffffffffc020a718:	c139                	beqz	a0,ffffffffc020a75e <sfs_lookup_once.constprop.0+0xa0>
ffffffffc020a71a:	2405                	addiw	s0,s0,1
ffffffffc020a71c:	02898e63          	beq	s3,s0,ffffffffc020a758 <sfs_lookup_once.constprop.0+0x9a>
ffffffffc020a720:	86a6                	mv	a3,s1
ffffffffc020a722:	8622                	mv	a2,s0
ffffffffc020a724:	85ca                	mv	a1,s2
ffffffffc020a726:	8552                	mv	a0,s4
ffffffffc020a728:	8a7ff0ef          	jal	ffffffffc0209fce <sfs_dirent_read_nolock>
ffffffffc020a72c:	87aa                	mv	a5,a0
ffffffffc020a72e:	dd71                	beqz	a0,ffffffffc020a70a <sfs_lookup_once.constprop.0+0x4c>
ffffffffc020a730:	6446                	ld	s0,80(sp)
ffffffffc020a732:	8526                	mv	a0,s1
ffffffffc020a734:	e43e                	sd	a5,8(sp)
ffffffffc020a736:	945f70ef          	jal	ffffffffc020207a <kfree>
ffffffffc020a73a:	02090513          	addi	a0,s2,32
ffffffffc020a73e:	c5bf90ef          	jal	ffffffffc0204398 <up>
ffffffffc020a742:	67a2                	ld	a5,8(sp)
ffffffffc020a744:	79e2                	ld	s3,56(sp)
ffffffffc020a746:	60e6                	ld	ra,88(sp)
ffffffffc020a748:	64a6                	ld	s1,72(sp)
ffffffffc020a74a:	6906                	ld	s2,64(sp)
ffffffffc020a74c:	7a42                	ld	s4,48(sp)
ffffffffc020a74e:	7aa2                	ld	s5,40(sp)
ffffffffc020a750:	6c42                	ld	s8,16(sp)
ffffffffc020a752:	853e                	mv	a0,a5
ffffffffc020a754:	6125                	addi	sp,sp,96
ffffffffc020a756:	8082                	ret
ffffffffc020a758:	6446                	ld	s0,80(sp)
ffffffffc020a75a:	57c1                	li	a5,-16
ffffffffc020a75c:	bfd9                	j	ffffffffc020a732 <sfs_lookup_once.constprop.0+0x74>
ffffffffc020a75e:	8526                	mv	a0,s1
ffffffffc020a760:	4080                	lw	s0,0(s1)
ffffffffc020a762:	919f70ef          	jal	ffffffffc020207a <kfree>
ffffffffc020a766:	02090513          	addi	a0,s2,32
ffffffffc020a76a:	c2ff90ef          	jal	ffffffffc0204398 <up>
ffffffffc020a76e:	8622                	mv	a2,s0
ffffffffc020a770:	6446                	ld	s0,80(sp)
ffffffffc020a772:	64a6                	ld	s1,72(sp)
ffffffffc020a774:	79e2                	ld	s3,56(sp)
ffffffffc020a776:	60e6                	ld	ra,88(sp)
ffffffffc020a778:	6906                	ld	s2,64(sp)
ffffffffc020a77a:	7aa2                	ld	s5,40(sp)
ffffffffc020a77c:	85e2                	mv	a1,s8
ffffffffc020a77e:	8552                	mv	a0,s4
ffffffffc020a780:	6c42                	ld	s8,16(sp)
ffffffffc020a782:	7a42                	ld	s4,48(sp)
ffffffffc020a784:	6125                	addi	sp,sp,96
ffffffffc020a786:	cf7ff06f          	j	ffffffffc020a47c <sfs_load_inode>
ffffffffc020a78a:	02090513          	addi	a0,s2,32
ffffffffc020a78e:	c0bf90ef          	jal	ffffffffc0204398 <up>
ffffffffc020a792:	57f1                	li	a5,-4
ffffffffc020a794:	bf4d                	j	ffffffffc020a746 <sfs_lookup_once.constprop.0+0x88>
ffffffffc020a796:	00004697          	auipc	a3,0x4
ffffffffc020a79a:	e5268693          	addi	a3,a3,-430 # ffffffffc020e5e8 <etext+0x31e6>
ffffffffc020a79e:	00001617          	auipc	a2,0x1
ffffffffc020a7a2:	0a260613          	addi	a2,a2,162 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a7a6:	1ba00593          	li	a1,442
ffffffffc020a7aa:	00004517          	auipc	a0,0x4
ffffffffc020a7ae:	bc650513          	addi	a0,a0,-1082 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a7b2:	e8a2                	sd	s0,80(sp)
ffffffffc020a7b4:	e4a6                	sd	s1,72(sp)
ffffffffc020a7b6:	fc4e                	sd	s3,56(sp)
ffffffffc020a7b8:	f05a                	sd	s6,32(sp)
ffffffffc020a7ba:	ec5e                	sd	s7,24(sp)
ffffffffc020a7bc:	c8ff50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a7c0 <sfs_namefile>:
ffffffffc020a7c0:	6d9c                	ld	a5,24(a1)
ffffffffc020a7c2:	7175                	addi	sp,sp,-144
ffffffffc020a7c4:	f86a                	sd	s10,48(sp)
ffffffffc020a7c6:	e506                	sd	ra,136(sp)
ffffffffc020a7c8:	f46e                	sd	s11,40(sp)
ffffffffc020a7ca:	4d09                	li	s10,2
ffffffffc020a7cc:	1afd7763          	bgeu	s10,a5,ffffffffc020a97a <sfs_namefile+0x1ba>
ffffffffc020a7d0:	f4ce                	sd	s3,104(sp)
ffffffffc020a7d2:	89aa                	mv	s3,a0
ffffffffc020a7d4:	10400513          	li	a0,260
ffffffffc020a7d8:	fca6                	sd	s1,120(sp)
ffffffffc020a7da:	e42e                	sd	a1,8(sp)
ffffffffc020a7dc:	ff8f70ef          	jal	ffffffffc0201fd4 <kmalloc>
ffffffffc020a7e0:	84aa                	mv	s1,a0
ffffffffc020a7e2:	18050a63          	beqz	a0,ffffffffc020a976 <sfs_namefile+0x1b6>
ffffffffc020a7e6:	f0d2                	sd	s4,96(sp)
ffffffffc020a7e8:	0689ba03          	ld	s4,104(s3)
ffffffffc020a7ec:	1e0a0c63          	beqz	s4,ffffffffc020a9e4 <sfs_namefile+0x224>
ffffffffc020a7f0:	0b0a2783          	lw	a5,176(s4)
ffffffffc020a7f4:	1e079863          	bnez	a5,ffffffffc020a9e4 <sfs_namefile+0x224>
ffffffffc020a7f8:	0589a703          	lw	a4,88(s3)
ffffffffc020a7fc:	6785                	lui	a5,0x1
ffffffffc020a7fe:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a802:	e03a                	sd	a4,0(sp)
ffffffffc020a804:	e122                	sd	s0,128(sp)
ffffffffc020a806:	f8ca                	sd	s2,112(sp)
ffffffffc020a808:	ecd6                	sd	s5,88(sp)
ffffffffc020a80a:	e8da                	sd	s6,80(sp)
ffffffffc020a80c:	e4de                	sd	s7,72(sp)
ffffffffc020a80e:	e0e2                	sd	s8,64(sp)
ffffffffc020a810:	1af71963          	bne	a4,a5,ffffffffc020a9c2 <sfs_namefile+0x202>
ffffffffc020a814:	6722                	ld	a4,8(sp)
ffffffffc020a816:	854e                	mv	a0,s3
ffffffffc020a818:	8b4e                	mv	s6,s3
ffffffffc020a81a:	6f1c                	ld	a5,24(a4)
ffffffffc020a81c:	00073a83          	ld	s5,0(a4)
ffffffffc020a820:	ffe78c13          	addi	s8,a5,-2
ffffffffc020a824:	9abe                	add	s5,s5,a5
ffffffffc020a826:	e13fc0ef          	jal	ffffffffc0207638 <inode_ref_inc>
ffffffffc020a82a:	0834                	addi	a3,sp,24
ffffffffc020a82c:	00004617          	auipc	a2,0x4
ffffffffc020a830:	de460613          	addi	a2,a2,-540 # ffffffffc020e610 <etext+0x320e>
ffffffffc020a834:	85da                	mv	a1,s6
ffffffffc020a836:	8552                	mv	a0,s4
ffffffffc020a838:	e87ff0ef          	jal	ffffffffc020a6be <sfs_lookup_once.constprop.0>
ffffffffc020a83c:	8daa                	mv	s11,a0
ffffffffc020a83e:	e94d                	bnez	a0,ffffffffc020a8f0 <sfs_namefile+0x130>
ffffffffc020a840:	854e                	mv	a0,s3
ffffffffc020a842:	008b2903          	lw	s2,8(s6)
ffffffffc020a846:	ec1fc0ef          	jal	ffffffffc0207706 <inode_ref_dec>
ffffffffc020a84a:	6462                	ld	s0,24(sp)
ffffffffc020a84c:	0f340563          	beq	s0,s3,ffffffffc020a936 <sfs_namefile+0x176>
ffffffffc020a850:	14040863          	beqz	s0,ffffffffc020a9a0 <sfs_namefile+0x1e0>
ffffffffc020a854:	4c38                	lw	a4,88(s0)
ffffffffc020a856:	6782                	ld	a5,0(sp)
ffffffffc020a858:	14f71463          	bne	a4,a5,ffffffffc020a9a0 <sfs_namefile+0x1e0>
ffffffffc020a85c:	4418                	lw	a4,8(s0)
ffffffffc020a85e:	13270063          	beq	a4,s2,ffffffffc020a97e <sfs_namefile+0x1be>
ffffffffc020a862:	6018                	ld	a4,0(s0)
ffffffffc020a864:	00475703          	lhu	a4,4(a4)
ffffffffc020a868:	11a71b63          	bne	a4,s10,ffffffffc020a97e <sfs_namefile+0x1be>
ffffffffc020a86c:	02040b93          	addi	s7,s0,32
ffffffffc020a870:	855e                	mv	a0,s7
ffffffffc020a872:	b2bf90ef          	jal	ffffffffc020439c <down>
ffffffffc020a876:	6018                	ld	a4,0(s0)
ffffffffc020a878:	00872983          	lw	s3,8(a4)
ffffffffc020a87c:	0b305763          	blez	s3,ffffffffc020a92a <sfs_namefile+0x16a>
ffffffffc020a880:	8b22                	mv	s6,s0
ffffffffc020a882:	a039                	j	ffffffffc020a890 <sfs_namefile+0xd0>
ffffffffc020a884:	4098                	lw	a4,0(s1)
ffffffffc020a886:	01270e63          	beq	a4,s2,ffffffffc020a8a2 <sfs_namefile+0xe2>
ffffffffc020a88a:	2d85                	addiw	s11,s11,1
ffffffffc020a88c:	09b98763          	beq	s3,s11,ffffffffc020a91a <sfs_namefile+0x15a>
ffffffffc020a890:	86a6                	mv	a3,s1
ffffffffc020a892:	866e                	mv	a2,s11
ffffffffc020a894:	85a2                	mv	a1,s0
ffffffffc020a896:	8552                	mv	a0,s4
ffffffffc020a898:	f36ff0ef          	jal	ffffffffc0209fce <sfs_dirent_read_nolock>
ffffffffc020a89c:	872a                	mv	a4,a0
ffffffffc020a89e:	d17d                	beqz	a0,ffffffffc020a884 <sfs_namefile+0xc4>
ffffffffc020a8a0:	a8b5                	j	ffffffffc020a91c <sfs_namefile+0x15c>
ffffffffc020a8a2:	855e                	mv	a0,s7
ffffffffc020a8a4:	af5f90ef          	jal	ffffffffc0204398 <up>
ffffffffc020a8a8:	00448513          	addi	a0,s1,4
ffffffffc020a8ac:	23b000ef          	jal	ffffffffc020b2e6 <strlen>
ffffffffc020a8b0:	00150793          	addi	a5,a0,1
ffffffffc020a8b4:	0afc6e63          	bltu	s8,a5,ffffffffc020a970 <sfs_namefile+0x1b0>
ffffffffc020a8b8:	fff54913          	not	s2,a0
ffffffffc020a8bc:	862a                	mv	a2,a0
ffffffffc020a8be:	00448593          	addi	a1,s1,4
ffffffffc020a8c2:	012a8533          	add	a0,s5,s2
ffffffffc020a8c6:	40fc0c33          	sub	s8,s8,a5
ffffffffc020a8ca:	321000ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc020a8ce:	02f00793          	li	a5,47
ffffffffc020a8d2:	fefa8fa3          	sb	a5,-1(s5)
ffffffffc020a8d6:	0834                	addi	a3,sp,24
ffffffffc020a8d8:	00004617          	auipc	a2,0x4
ffffffffc020a8dc:	d3860613          	addi	a2,a2,-712 # ffffffffc020e610 <etext+0x320e>
ffffffffc020a8e0:	85da                	mv	a1,s6
ffffffffc020a8e2:	8552                	mv	a0,s4
ffffffffc020a8e4:	ddbff0ef          	jal	ffffffffc020a6be <sfs_lookup_once.constprop.0>
ffffffffc020a8e8:	89a2                	mv	s3,s0
ffffffffc020a8ea:	9aca                	add	s5,s5,s2
ffffffffc020a8ec:	8daa                	mv	s11,a0
ffffffffc020a8ee:	d929                	beqz	a0,ffffffffc020a840 <sfs_namefile+0x80>
ffffffffc020a8f0:	854e                	mv	a0,s3
ffffffffc020a8f2:	e15fc0ef          	jal	ffffffffc0207706 <inode_ref_dec>
ffffffffc020a8f6:	8526                	mv	a0,s1
ffffffffc020a8f8:	f82f70ef          	jal	ffffffffc020207a <kfree>
ffffffffc020a8fc:	640a                	ld	s0,128(sp)
ffffffffc020a8fe:	74e6                	ld	s1,120(sp)
ffffffffc020a900:	7946                	ld	s2,112(sp)
ffffffffc020a902:	79a6                	ld	s3,104(sp)
ffffffffc020a904:	7a06                	ld	s4,96(sp)
ffffffffc020a906:	6ae6                	ld	s5,88(sp)
ffffffffc020a908:	6b46                	ld	s6,80(sp)
ffffffffc020a90a:	6ba6                	ld	s7,72(sp)
ffffffffc020a90c:	6c06                	ld	s8,64(sp)
ffffffffc020a90e:	60aa                	ld	ra,136(sp)
ffffffffc020a910:	7d42                	ld	s10,48(sp)
ffffffffc020a912:	856e                	mv	a0,s11
ffffffffc020a914:	7da2                	ld	s11,40(sp)
ffffffffc020a916:	6149                	addi	sp,sp,144
ffffffffc020a918:	8082                	ret
ffffffffc020a91a:	5741                	li	a4,-16
ffffffffc020a91c:	855e                	mv	a0,s7
ffffffffc020a91e:	e03a                	sd	a4,0(sp)
ffffffffc020a920:	89a2                	mv	s3,s0
ffffffffc020a922:	a77f90ef          	jal	ffffffffc0204398 <up>
ffffffffc020a926:	6d82                	ld	s11,0(sp)
ffffffffc020a928:	b7e1                	j	ffffffffc020a8f0 <sfs_namefile+0x130>
ffffffffc020a92a:	855e                	mv	a0,s7
ffffffffc020a92c:	a6df90ef          	jal	ffffffffc0204398 <up>
ffffffffc020a930:	89a2                	mv	s3,s0
ffffffffc020a932:	5dc1                	li	s11,-16
ffffffffc020a934:	bf75                	j	ffffffffc020a8f0 <sfs_namefile+0x130>
ffffffffc020a936:	854e                	mv	a0,s3
ffffffffc020a938:	dcffc0ef          	jal	ffffffffc0207706 <inode_ref_dec>
ffffffffc020a93c:	6922                	ld	s2,8(sp)
ffffffffc020a93e:	85d6                	mv	a1,s5
ffffffffc020a940:	01893403          	ld	s0,24(s2)
ffffffffc020a944:	00093503          	ld	a0,0(s2)
ffffffffc020a948:	1479                	addi	s0,s0,-2
ffffffffc020a94a:	41840433          	sub	s0,s0,s8
ffffffffc020a94e:	8622                	mv	a2,s0
ffffffffc020a950:	0505                	addi	a0,a0,1
ffffffffc020a952:	25b000ef          	jal	ffffffffc020b3ac <memmove>
ffffffffc020a956:	02f00713          	li	a4,47
ffffffffc020a95a:	fee50fa3          	sb	a4,-1(a0)
ffffffffc020a95e:	00850733          	add	a4,a0,s0
ffffffffc020a962:	00070023          	sb	zero,0(a4)
ffffffffc020a966:	854a                	mv	a0,s2
ffffffffc020a968:	85a2                	mv	a1,s0
ffffffffc020a96a:	957fa0ef          	jal	ffffffffc02052c0 <iobuf_skip>
ffffffffc020a96e:	b761                	j	ffffffffc020a8f6 <sfs_namefile+0x136>
ffffffffc020a970:	89a2                	mv	s3,s0
ffffffffc020a972:	5df1                	li	s11,-4
ffffffffc020a974:	bfb5                	j	ffffffffc020a8f0 <sfs_namefile+0x130>
ffffffffc020a976:	74e6                	ld	s1,120(sp)
ffffffffc020a978:	79a6                	ld	s3,104(sp)
ffffffffc020a97a:	5df1                	li	s11,-4
ffffffffc020a97c:	bf49                	j	ffffffffc020a90e <sfs_namefile+0x14e>
ffffffffc020a97e:	00004697          	auipc	a3,0x4
ffffffffc020a982:	c9a68693          	addi	a3,a3,-870 # ffffffffc020e618 <etext+0x3216>
ffffffffc020a986:	00001617          	auipc	a2,0x1
ffffffffc020a98a:	eba60613          	addi	a2,a2,-326 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a98e:	2fc00593          	li	a1,764
ffffffffc020a992:	00004517          	auipc	a0,0x4
ffffffffc020a996:	9de50513          	addi	a0,a0,-1570 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a99a:	fc66                	sd	s9,56(sp)
ffffffffc020a99c:	aaff50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a9a0:	00004697          	auipc	a3,0x4
ffffffffc020a9a4:	99868693          	addi	a3,a3,-1640 # ffffffffc020e338 <etext+0x2f36>
ffffffffc020a9a8:	00001617          	auipc	a2,0x1
ffffffffc020a9ac:	e9860613          	addi	a2,a2,-360 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a9b0:	2fb00593          	li	a1,763
ffffffffc020a9b4:	00004517          	auipc	a0,0x4
ffffffffc020a9b8:	9bc50513          	addi	a0,a0,-1604 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a9bc:	fc66                	sd	s9,56(sp)
ffffffffc020a9be:	a8df50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a9c2:	00004697          	auipc	a3,0x4
ffffffffc020a9c6:	97668693          	addi	a3,a3,-1674 # ffffffffc020e338 <etext+0x2f36>
ffffffffc020a9ca:	00001617          	auipc	a2,0x1
ffffffffc020a9ce:	e7660613          	addi	a2,a2,-394 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a9d2:	2e800593          	li	a1,744
ffffffffc020a9d6:	00004517          	auipc	a0,0x4
ffffffffc020a9da:	99a50513          	addi	a0,a0,-1638 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020a9de:	fc66                	sd	s9,56(sp)
ffffffffc020a9e0:	a6bf50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a9e4:	00003697          	auipc	a3,0x3
ffffffffc020a9e8:	7ac68693          	addi	a3,a3,1964 # ffffffffc020e190 <etext+0x2d8e>
ffffffffc020a9ec:	00001617          	auipc	a2,0x1
ffffffffc020a9f0:	e5460613          	addi	a2,a2,-428 # ffffffffc020b840 <etext+0x43e>
ffffffffc020a9f4:	2e700593          	li	a1,743
ffffffffc020a9f8:	00004517          	auipc	a0,0x4
ffffffffc020a9fc:	97850513          	addi	a0,a0,-1672 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020aa00:	e122                	sd	s0,128(sp)
ffffffffc020aa02:	f8ca                	sd	s2,112(sp)
ffffffffc020aa04:	ecd6                	sd	s5,88(sp)
ffffffffc020aa06:	e8da                	sd	s6,80(sp)
ffffffffc020aa08:	e4de                	sd	s7,72(sp)
ffffffffc020aa0a:	e0e2                	sd	s8,64(sp)
ffffffffc020aa0c:	fc66                	sd	s9,56(sp)
ffffffffc020aa0e:	a3df50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020aa12 <sfs_lookup>:
ffffffffc020aa12:	7139                	addi	sp,sp,-64
ffffffffc020aa14:	f426                	sd	s1,40(sp)
ffffffffc020aa16:	7524                	ld	s1,104(a0)
ffffffffc020aa18:	fc06                	sd	ra,56(sp)
ffffffffc020aa1a:	f822                	sd	s0,48(sp)
ffffffffc020aa1c:	f04a                	sd	s2,32(sp)
ffffffffc020aa1e:	c4b5                	beqz	s1,ffffffffc020aa8a <sfs_lookup+0x78>
ffffffffc020aa20:	0b04a783          	lw	a5,176(s1)
ffffffffc020aa24:	e3bd                	bnez	a5,ffffffffc020aa8a <sfs_lookup+0x78>
ffffffffc020aa26:	0005c783          	lbu	a5,0(a1)
ffffffffc020aa2a:	c3c5                	beqz	a5,ffffffffc020aaca <sfs_lookup+0xb8>
ffffffffc020aa2c:	fd178793          	addi	a5,a5,-47
ffffffffc020aa30:	cfc9                	beqz	a5,ffffffffc020aaca <sfs_lookup+0xb8>
ffffffffc020aa32:	842a                	mv	s0,a0
ffffffffc020aa34:	8932                	mv	s2,a2
ffffffffc020aa36:	e42e                	sd	a1,8(sp)
ffffffffc020aa38:	c01fc0ef          	jal	ffffffffc0207638 <inode_ref_inc>
ffffffffc020aa3c:	4c38                	lw	a4,88(s0)
ffffffffc020aa3e:	6785                	lui	a5,0x1
ffffffffc020aa40:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020aa44:	06f71363          	bne	a4,a5,ffffffffc020aaaa <sfs_lookup+0x98>
ffffffffc020aa48:	6018                	ld	a4,0(s0)
ffffffffc020aa4a:	4789                	li	a5,2
ffffffffc020aa4c:	00475703          	lhu	a4,4(a4)
ffffffffc020aa50:	02f71863          	bne	a4,a5,ffffffffc020aa80 <sfs_lookup+0x6e>
ffffffffc020aa54:	6622                	ld	a2,8(sp)
ffffffffc020aa56:	85a2                	mv	a1,s0
ffffffffc020aa58:	8526                	mv	a0,s1
ffffffffc020aa5a:	0834                	addi	a3,sp,24
ffffffffc020aa5c:	c63ff0ef          	jal	ffffffffc020a6be <sfs_lookup_once.constprop.0>
ffffffffc020aa60:	87aa                	mv	a5,a0
ffffffffc020aa62:	8522                	mv	a0,s0
ffffffffc020aa64:	843e                	mv	s0,a5
ffffffffc020aa66:	ca1fc0ef          	jal	ffffffffc0207706 <inode_ref_dec>
ffffffffc020aa6a:	e401                	bnez	s0,ffffffffc020aa72 <sfs_lookup+0x60>
ffffffffc020aa6c:	67e2                	ld	a5,24(sp)
ffffffffc020aa6e:	00f93023          	sd	a5,0(s2)
ffffffffc020aa72:	70e2                	ld	ra,56(sp)
ffffffffc020aa74:	8522                	mv	a0,s0
ffffffffc020aa76:	7442                	ld	s0,48(sp)
ffffffffc020aa78:	74a2                	ld	s1,40(sp)
ffffffffc020aa7a:	7902                	ld	s2,32(sp)
ffffffffc020aa7c:	6121                	addi	sp,sp,64
ffffffffc020aa7e:	8082                	ret
ffffffffc020aa80:	8522                	mv	a0,s0
ffffffffc020aa82:	c85fc0ef          	jal	ffffffffc0207706 <inode_ref_dec>
ffffffffc020aa86:	5439                	li	s0,-18
ffffffffc020aa88:	b7ed                	j	ffffffffc020aa72 <sfs_lookup+0x60>
ffffffffc020aa8a:	00003697          	auipc	a3,0x3
ffffffffc020aa8e:	70668693          	addi	a3,a3,1798 # ffffffffc020e190 <etext+0x2d8e>
ffffffffc020aa92:	00001617          	auipc	a2,0x1
ffffffffc020aa96:	dae60613          	addi	a2,a2,-594 # ffffffffc020b840 <etext+0x43e>
ffffffffc020aa9a:	3dd00593          	li	a1,989
ffffffffc020aa9e:	00004517          	auipc	a0,0x4
ffffffffc020aaa2:	8d250513          	addi	a0,a0,-1838 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020aaa6:	9a5f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020aaaa:	00004697          	auipc	a3,0x4
ffffffffc020aaae:	88e68693          	addi	a3,a3,-1906 # ffffffffc020e338 <etext+0x2f36>
ffffffffc020aab2:	00001617          	auipc	a2,0x1
ffffffffc020aab6:	d8e60613          	addi	a2,a2,-626 # ffffffffc020b840 <etext+0x43e>
ffffffffc020aaba:	3e000593          	li	a1,992
ffffffffc020aabe:	00004517          	auipc	a0,0x4
ffffffffc020aac2:	8b250513          	addi	a0,a0,-1870 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020aac6:	985f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020aaca:	00004697          	auipc	a3,0x4
ffffffffc020aace:	b8668693          	addi	a3,a3,-1146 # ffffffffc020e650 <etext+0x324e>
ffffffffc020aad2:	00001617          	auipc	a2,0x1
ffffffffc020aad6:	d6e60613          	addi	a2,a2,-658 # ffffffffc020b840 <etext+0x43e>
ffffffffc020aada:	3de00593          	li	a1,990
ffffffffc020aade:	00004517          	auipc	a0,0x4
ffffffffc020aae2:	89250513          	addi	a0,a0,-1902 # ffffffffc020e370 <etext+0x2f6e>
ffffffffc020aae6:	965f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020aaea <sfs_rwblock_nolock>:
ffffffffc020aaea:	7139                	addi	sp,sp,-64
ffffffffc020aaec:	f822                	sd	s0,48(sp)
ffffffffc020aaee:	f426                	sd	s1,40(sp)
ffffffffc020aaf0:	fc06                	sd	ra,56(sp)
ffffffffc020aaf2:	842a                	mv	s0,a0
ffffffffc020aaf4:	84b6                	mv	s1,a3
ffffffffc020aaf6:	e219                	bnez	a2,ffffffffc020aafc <sfs_rwblock_nolock+0x12>
ffffffffc020aaf8:	8b05                	andi	a4,a4,1
ffffffffc020aafa:	e71d                	bnez	a4,ffffffffc020ab28 <sfs_rwblock_nolock+0x3e>
ffffffffc020aafc:	405c                	lw	a5,4(s0)
ffffffffc020aafe:	02f67563          	bgeu	a2,a5,ffffffffc020ab28 <sfs_rwblock_nolock+0x3e>
ffffffffc020ab02:	00c6161b          	slliw	a2,a2,0xc
ffffffffc020ab06:	02061693          	slli	a3,a2,0x20
ffffffffc020ab0a:	9281                	srli	a3,a3,0x20
ffffffffc020ab0c:	6605                	lui	a2,0x1
ffffffffc020ab0e:	850a                	mv	a0,sp
ffffffffc020ab10:	f22fa0ef          	jal	ffffffffc0205232 <iobuf_init>
ffffffffc020ab14:	85aa                	mv	a1,a0
ffffffffc020ab16:	7808                	ld	a0,48(s0)
ffffffffc020ab18:	8626                	mv	a2,s1
ffffffffc020ab1a:	7118                	ld	a4,32(a0)
ffffffffc020ab1c:	9702                	jalr	a4
ffffffffc020ab1e:	70e2                	ld	ra,56(sp)
ffffffffc020ab20:	7442                	ld	s0,48(sp)
ffffffffc020ab22:	74a2                	ld	s1,40(sp)
ffffffffc020ab24:	6121                	addi	sp,sp,64
ffffffffc020ab26:	8082                	ret
ffffffffc020ab28:	00004697          	auipc	a3,0x4
ffffffffc020ab2c:	b4868693          	addi	a3,a3,-1208 # ffffffffc020e670 <etext+0x326e>
ffffffffc020ab30:	00001617          	auipc	a2,0x1
ffffffffc020ab34:	d1060613          	addi	a2,a2,-752 # ffffffffc020b840 <etext+0x43e>
ffffffffc020ab38:	45d5                	li	a1,21
ffffffffc020ab3a:	00004517          	auipc	a0,0x4
ffffffffc020ab3e:	b6e50513          	addi	a0,a0,-1170 # ffffffffc020e6a8 <etext+0x32a6>
ffffffffc020ab42:	909f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020ab46 <sfs_rblock>:
ffffffffc020ab46:	7139                	addi	sp,sp,-64
ffffffffc020ab48:	ec4e                	sd	s3,24(sp)
ffffffffc020ab4a:	89b6                	mv	s3,a3
ffffffffc020ab4c:	f822                	sd	s0,48(sp)
ffffffffc020ab4e:	f04a                	sd	s2,32(sp)
ffffffffc020ab50:	e852                	sd	s4,16(sp)
ffffffffc020ab52:	fc06                	sd	ra,56(sp)
ffffffffc020ab54:	f426                	sd	s1,40(sp)
ffffffffc020ab56:	892e                	mv	s2,a1
ffffffffc020ab58:	8432                	mv	s0,a2
ffffffffc020ab5a:	8a2a                	mv	s4,a0
ffffffffc020ab5c:	2ea000ef          	jal	ffffffffc020ae46 <lock_sfs_io>
ffffffffc020ab60:	02098763          	beqz	s3,ffffffffc020ab8e <sfs_rblock+0x48>
ffffffffc020ab64:	e456                	sd	s5,8(sp)
ffffffffc020ab66:	013409bb          	addw	s3,s0,s3
ffffffffc020ab6a:	6a85                	lui	s5,0x1
ffffffffc020ab6c:	a021                	j	ffffffffc020ab74 <sfs_rblock+0x2e>
ffffffffc020ab6e:	9956                	add	s2,s2,s5
ffffffffc020ab70:	01340e63          	beq	s0,s3,ffffffffc020ab8c <sfs_rblock+0x46>
ffffffffc020ab74:	8622                	mv	a2,s0
ffffffffc020ab76:	4705                	li	a4,1
ffffffffc020ab78:	4681                	li	a3,0
ffffffffc020ab7a:	85ca                	mv	a1,s2
ffffffffc020ab7c:	8552                	mv	a0,s4
ffffffffc020ab7e:	f6dff0ef          	jal	ffffffffc020aaea <sfs_rwblock_nolock>
ffffffffc020ab82:	84aa                	mv	s1,a0
ffffffffc020ab84:	2405                	addiw	s0,s0,1
ffffffffc020ab86:	d565                	beqz	a0,ffffffffc020ab6e <sfs_rblock+0x28>
ffffffffc020ab88:	6aa2                	ld	s5,8(sp)
ffffffffc020ab8a:	a019                	j	ffffffffc020ab90 <sfs_rblock+0x4a>
ffffffffc020ab8c:	6aa2                	ld	s5,8(sp)
ffffffffc020ab8e:	4481                	li	s1,0
ffffffffc020ab90:	8552                	mv	a0,s4
ffffffffc020ab92:	2c4000ef          	jal	ffffffffc020ae56 <unlock_sfs_io>
ffffffffc020ab96:	70e2                	ld	ra,56(sp)
ffffffffc020ab98:	7442                	ld	s0,48(sp)
ffffffffc020ab9a:	7902                	ld	s2,32(sp)
ffffffffc020ab9c:	69e2                	ld	s3,24(sp)
ffffffffc020ab9e:	6a42                	ld	s4,16(sp)
ffffffffc020aba0:	8526                	mv	a0,s1
ffffffffc020aba2:	74a2                	ld	s1,40(sp)
ffffffffc020aba4:	6121                	addi	sp,sp,64
ffffffffc020aba6:	8082                	ret

ffffffffc020aba8 <sfs_wblock>:
ffffffffc020aba8:	7139                	addi	sp,sp,-64
ffffffffc020abaa:	ec4e                	sd	s3,24(sp)
ffffffffc020abac:	89b6                	mv	s3,a3
ffffffffc020abae:	f822                	sd	s0,48(sp)
ffffffffc020abb0:	f04a                	sd	s2,32(sp)
ffffffffc020abb2:	e852                	sd	s4,16(sp)
ffffffffc020abb4:	fc06                	sd	ra,56(sp)
ffffffffc020abb6:	f426                	sd	s1,40(sp)
ffffffffc020abb8:	892e                	mv	s2,a1
ffffffffc020abba:	8432                	mv	s0,a2
ffffffffc020abbc:	8a2a                	mv	s4,a0
ffffffffc020abbe:	288000ef          	jal	ffffffffc020ae46 <lock_sfs_io>
ffffffffc020abc2:	02098763          	beqz	s3,ffffffffc020abf0 <sfs_wblock+0x48>
ffffffffc020abc6:	e456                	sd	s5,8(sp)
ffffffffc020abc8:	013409bb          	addw	s3,s0,s3
ffffffffc020abcc:	6a85                	lui	s5,0x1
ffffffffc020abce:	a021                	j	ffffffffc020abd6 <sfs_wblock+0x2e>
ffffffffc020abd0:	9956                	add	s2,s2,s5
ffffffffc020abd2:	01340e63          	beq	s0,s3,ffffffffc020abee <sfs_wblock+0x46>
ffffffffc020abd6:	4705                	li	a4,1
ffffffffc020abd8:	8622                	mv	a2,s0
ffffffffc020abda:	86ba                	mv	a3,a4
ffffffffc020abdc:	85ca                	mv	a1,s2
ffffffffc020abde:	8552                	mv	a0,s4
ffffffffc020abe0:	f0bff0ef          	jal	ffffffffc020aaea <sfs_rwblock_nolock>
ffffffffc020abe4:	84aa                	mv	s1,a0
ffffffffc020abe6:	2405                	addiw	s0,s0,1
ffffffffc020abe8:	d565                	beqz	a0,ffffffffc020abd0 <sfs_wblock+0x28>
ffffffffc020abea:	6aa2                	ld	s5,8(sp)
ffffffffc020abec:	a019                	j	ffffffffc020abf2 <sfs_wblock+0x4a>
ffffffffc020abee:	6aa2                	ld	s5,8(sp)
ffffffffc020abf0:	4481                	li	s1,0
ffffffffc020abf2:	8552                	mv	a0,s4
ffffffffc020abf4:	262000ef          	jal	ffffffffc020ae56 <unlock_sfs_io>
ffffffffc020abf8:	70e2                	ld	ra,56(sp)
ffffffffc020abfa:	7442                	ld	s0,48(sp)
ffffffffc020abfc:	7902                	ld	s2,32(sp)
ffffffffc020abfe:	69e2                	ld	s3,24(sp)
ffffffffc020ac00:	6a42                	ld	s4,16(sp)
ffffffffc020ac02:	8526                	mv	a0,s1
ffffffffc020ac04:	74a2                	ld	s1,40(sp)
ffffffffc020ac06:	6121                	addi	sp,sp,64
ffffffffc020ac08:	8082                	ret

ffffffffc020ac0a <sfs_rbuf>:
ffffffffc020ac0a:	7179                	addi	sp,sp,-48
ffffffffc020ac0c:	f406                	sd	ra,40(sp)
ffffffffc020ac0e:	f022                	sd	s0,32(sp)
ffffffffc020ac10:	ec26                	sd	s1,24(sp)
ffffffffc020ac12:	e84a                	sd	s2,16(sp)
ffffffffc020ac14:	e44e                	sd	s3,8(sp)
ffffffffc020ac16:	e052                	sd	s4,0(sp)
ffffffffc020ac18:	6785                	lui	a5,0x1
ffffffffc020ac1a:	04f77863          	bgeu	a4,a5,ffffffffc020ac6a <sfs_rbuf+0x60>
ffffffffc020ac1e:	84ba                	mv	s1,a4
ffffffffc020ac20:	9732                	add	a4,a4,a2
ffffffffc020ac22:	04e7e463          	bltu	a5,a4,ffffffffc020ac6a <sfs_rbuf+0x60>
ffffffffc020ac26:	8936                	mv	s2,a3
ffffffffc020ac28:	842a                	mv	s0,a0
ffffffffc020ac2a:	89ae                	mv	s3,a1
ffffffffc020ac2c:	8a32                	mv	s4,a2
ffffffffc020ac2e:	218000ef          	jal	ffffffffc020ae46 <lock_sfs_io>
ffffffffc020ac32:	642c                	ld	a1,72(s0)
ffffffffc020ac34:	864a                	mv	a2,s2
ffffffffc020ac36:	8522                	mv	a0,s0
ffffffffc020ac38:	4705                	li	a4,1
ffffffffc020ac3a:	4681                	li	a3,0
ffffffffc020ac3c:	eafff0ef          	jal	ffffffffc020aaea <sfs_rwblock_nolock>
ffffffffc020ac40:	892a                	mv	s2,a0
ffffffffc020ac42:	cd09                	beqz	a0,ffffffffc020ac5c <sfs_rbuf+0x52>
ffffffffc020ac44:	8522                	mv	a0,s0
ffffffffc020ac46:	210000ef          	jal	ffffffffc020ae56 <unlock_sfs_io>
ffffffffc020ac4a:	70a2                	ld	ra,40(sp)
ffffffffc020ac4c:	7402                	ld	s0,32(sp)
ffffffffc020ac4e:	64e2                	ld	s1,24(sp)
ffffffffc020ac50:	69a2                	ld	s3,8(sp)
ffffffffc020ac52:	6a02                	ld	s4,0(sp)
ffffffffc020ac54:	854a                	mv	a0,s2
ffffffffc020ac56:	6942                	ld	s2,16(sp)
ffffffffc020ac58:	6145                	addi	sp,sp,48
ffffffffc020ac5a:	8082                	ret
ffffffffc020ac5c:	642c                	ld	a1,72(s0)
ffffffffc020ac5e:	8652                	mv	a2,s4
ffffffffc020ac60:	854e                	mv	a0,s3
ffffffffc020ac62:	95a6                	add	a1,a1,s1
ffffffffc020ac64:	786000ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc020ac68:	bff1                	j	ffffffffc020ac44 <sfs_rbuf+0x3a>
ffffffffc020ac6a:	00004697          	auipc	a3,0x4
ffffffffc020ac6e:	a5668693          	addi	a3,a3,-1450 # ffffffffc020e6c0 <etext+0x32be>
ffffffffc020ac72:	00001617          	auipc	a2,0x1
ffffffffc020ac76:	bce60613          	addi	a2,a2,-1074 # ffffffffc020b840 <etext+0x43e>
ffffffffc020ac7a:	05500593          	li	a1,85
ffffffffc020ac7e:	00004517          	auipc	a0,0x4
ffffffffc020ac82:	a2a50513          	addi	a0,a0,-1494 # ffffffffc020e6a8 <etext+0x32a6>
ffffffffc020ac86:	fc4f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020ac8a <sfs_wbuf>:
ffffffffc020ac8a:	7139                	addi	sp,sp,-64
ffffffffc020ac8c:	fc06                	sd	ra,56(sp)
ffffffffc020ac8e:	f822                	sd	s0,48(sp)
ffffffffc020ac90:	f426                	sd	s1,40(sp)
ffffffffc020ac92:	f04a                	sd	s2,32(sp)
ffffffffc020ac94:	ec4e                	sd	s3,24(sp)
ffffffffc020ac96:	e852                	sd	s4,16(sp)
ffffffffc020ac98:	e456                	sd	s5,8(sp)
ffffffffc020ac9a:	6785                	lui	a5,0x1
ffffffffc020ac9c:	06f77163          	bgeu	a4,a5,ffffffffc020acfe <sfs_wbuf+0x74>
ffffffffc020aca0:	893a                	mv	s2,a4
ffffffffc020aca2:	9732                	add	a4,a4,a2
ffffffffc020aca4:	04e7ed63          	bltu	a5,a4,ffffffffc020acfe <sfs_wbuf+0x74>
ffffffffc020aca8:	89b6                	mv	s3,a3
ffffffffc020acaa:	84aa                	mv	s1,a0
ffffffffc020acac:	8a2e                	mv	s4,a1
ffffffffc020acae:	8ab2                	mv	s5,a2
ffffffffc020acb0:	196000ef          	jal	ffffffffc020ae46 <lock_sfs_io>
ffffffffc020acb4:	64ac                	ld	a1,72(s1)
ffffffffc020acb6:	864e                	mv	a2,s3
ffffffffc020acb8:	8526                	mv	a0,s1
ffffffffc020acba:	4705                	li	a4,1
ffffffffc020acbc:	4681                	li	a3,0
ffffffffc020acbe:	e2dff0ef          	jal	ffffffffc020aaea <sfs_rwblock_nolock>
ffffffffc020acc2:	842a                	mv	s0,a0
ffffffffc020acc4:	cd11                	beqz	a0,ffffffffc020ace0 <sfs_wbuf+0x56>
ffffffffc020acc6:	8526                	mv	a0,s1
ffffffffc020acc8:	18e000ef          	jal	ffffffffc020ae56 <unlock_sfs_io>
ffffffffc020accc:	70e2                	ld	ra,56(sp)
ffffffffc020acce:	8522                	mv	a0,s0
ffffffffc020acd0:	7442                	ld	s0,48(sp)
ffffffffc020acd2:	74a2                	ld	s1,40(sp)
ffffffffc020acd4:	7902                	ld	s2,32(sp)
ffffffffc020acd6:	69e2                	ld	s3,24(sp)
ffffffffc020acd8:	6a42                	ld	s4,16(sp)
ffffffffc020acda:	6aa2                	ld	s5,8(sp)
ffffffffc020acdc:	6121                	addi	sp,sp,64
ffffffffc020acde:	8082                	ret
ffffffffc020ace0:	64a8                	ld	a0,72(s1)
ffffffffc020ace2:	8656                	mv	a2,s5
ffffffffc020ace4:	85d2                	mv	a1,s4
ffffffffc020ace6:	954a                	add	a0,a0,s2
ffffffffc020ace8:	702000ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc020acec:	64ac                	ld	a1,72(s1)
ffffffffc020acee:	4705                	li	a4,1
ffffffffc020acf0:	864e                	mv	a2,s3
ffffffffc020acf2:	8526                	mv	a0,s1
ffffffffc020acf4:	86ba                	mv	a3,a4
ffffffffc020acf6:	df5ff0ef          	jal	ffffffffc020aaea <sfs_rwblock_nolock>
ffffffffc020acfa:	842a                	mv	s0,a0
ffffffffc020acfc:	b7e9                	j	ffffffffc020acc6 <sfs_wbuf+0x3c>
ffffffffc020acfe:	00004697          	auipc	a3,0x4
ffffffffc020ad02:	9c268693          	addi	a3,a3,-1598 # ffffffffc020e6c0 <etext+0x32be>
ffffffffc020ad06:	00001617          	auipc	a2,0x1
ffffffffc020ad0a:	b3a60613          	addi	a2,a2,-1222 # ffffffffc020b840 <etext+0x43e>
ffffffffc020ad0e:	06b00593          	li	a1,107
ffffffffc020ad12:	00004517          	auipc	a0,0x4
ffffffffc020ad16:	99650513          	addi	a0,a0,-1642 # ffffffffc020e6a8 <etext+0x32a6>
ffffffffc020ad1a:	f30f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020ad1e <sfs_sync_super>:
ffffffffc020ad1e:	1101                	addi	sp,sp,-32
ffffffffc020ad20:	ec06                	sd	ra,24(sp)
ffffffffc020ad22:	e822                	sd	s0,16(sp)
ffffffffc020ad24:	e426                	sd	s1,8(sp)
ffffffffc020ad26:	842a                	mv	s0,a0
ffffffffc020ad28:	11e000ef          	jal	ffffffffc020ae46 <lock_sfs_io>
ffffffffc020ad2c:	6428                	ld	a0,72(s0)
ffffffffc020ad2e:	6605                	lui	a2,0x1
ffffffffc020ad30:	4581                	li	a1,0
ffffffffc020ad32:	668000ef          	jal	ffffffffc020b39a <memset>
ffffffffc020ad36:	6428                	ld	a0,72(s0)
ffffffffc020ad38:	85a2                	mv	a1,s0
ffffffffc020ad3a:	02c00613          	li	a2,44
ffffffffc020ad3e:	6ac000ef          	jal	ffffffffc020b3ea <memcpy>
ffffffffc020ad42:	642c                	ld	a1,72(s0)
ffffffffc020ad44:	8522                	mv	a0,s0
ffffffffc020ad46:	4701                	li	a4,0
ffffffffc020ad48:	4685                	li	a3,1
ffffffffc020ad4a:	4601                	li	a2,0
ffffffffc020ad4c:	d9fff0ef          	jal	ffffffffc020aaea <sfs_rwblock_nolock>
ffffffffc020ad50:	84aa                	mv	s1,a0
ffffffffc020ad52:	8522                	mv	a0,s0
ffffffffc020ad54:	102000ef          	jal	ffffffffc020ae56 <unlock_sfs_io>
ffffffffc020ad58:	60e2                	ld	ra,24(sp)
ffffffffc020ad5a:	6442                	ld	s0,16(sp)
ffffffffc020ad5c:	8526                	mv	a0,s1
ffffffffc020ad5e:	64a2                	ld	s1,8(sp)
ffffffffc020ad60:	6105                	addi	sp,sp,32
ffffffffc020ad62:	8082                	ret

ffffffffc020ad64 <sfs_sync_freemap>:
ffffffffc020ad64:	7139                	addi	sp,sp,-64
ffffffffc020ad66:	ec4e                	sd	s3,24(sp)
ffffffffc020ad68:	e852                	sd	s4,16(sp)
ffffffffc020ad6a:	00456983          	lwu	s3,4(a0)
ffffffffc020ad6e:	8a2a                	mv	s4,a0
ffffffffc020ad70:	7d08                	ld	a0,56(a0)
ffffffffc020ad72:	67a1                	lui	a5,0x8
ffffffffc020ad74:	17fd                	addi	a5,a5,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc020ad76:	4581                	li	a1,0
ffffffffc020ad78:	f822                	sd	s0,48(sp)
ffffffffc020ad7a:	fc06                	sd	ra,56(sp)
ffffffffc020ad7c:	f426                	sd	s1,40(sp)
ffffffffc020ad7e:	99be                	add	s3,s3,a5
ffffffffc020ad80:	956fe0ef          	jal	ffffffffc0208ed6 <bitmap_getdata>
ffffffffc020ad84:	00f9d993          	srli	s3,s3,0xf
ffffffffc020ad88:	842a                	mv	s0,a0
ffffffffc020ad8a:	8552                	mv	a0,s4
ffffffffc020ad8c:	0ba000ef          	jal	ffffffffc020ae46 <lock_sfs_io>
ffffffffc020ad90:	02098b63          	beqz	s3,ffffffffc020adc6 <sfs_sync_freemap+0x62>
ffffffffc020ad94:	09b2                	slli	s3,s3,0xc
ffffffffc020ad96:	f04a                	sd	s2,32(sp)
ffffffffc020ad98:	e456                	sd	s5,8(sp)
ffffffffc020ad9a:	99a2                	add	s3,s3,s0
ffffffffc020ad9c:	4909                	li	s2,2
ffffffffc020ad9e:	6a85                	lui	s5,0x1
ffffffffc020ada0:	a021                	j	ffffffffc020ada8 <sfs_sync_freemap+0x44>
ffffffffc020ada2:	2905                	addiw	s2,s2,1
ffffffffc020ada4:	01340f63          	beq	s0,s3,ffffffffc020adc2 <sfs_sync_freemap+0x5e>
ffffffffc020ada8:	4705                	li	a4,1
ffffffffc020adaa:	85a2                	mv	a1,s0
ffffffffc020adac:	86ba                	mv	a3,a4
ffffffffc020adae:	864a                	mv	a2,s2
ffffffffc020adb0:	8552                	mv	a0,s4
ffffffffc020adb2:	d39ff0ef          	jal	ffffffffc020aaea <sfs_rwblock_nolock>
ffffffffc020adb6:	84aa                	mv	s1,a0
ffffffffc020adb8:	9456                	add	s0,s0,s5
ffffffffc020adba:	d565                	beqz	a0,ffffffffc020ada2 <sfs_sync_freemap+0x3e>
ffffffffc020adbc:	7902                	ld	s2,32(sp)
ffffffffc020adbe:	6aa2                	ld	s5,8(sp)
ffffffffc020adc0:	a021                	j	ffffffffc020adc8 <sfs_sync_freemap+0x64>
ffffffffc020adc2:	7902                	ld	s2,32(sp)
ffffffffc020adc4:	6aa2                	ld	s5,8(sp)
ffffffffc020adc6:	4481                	li	s1,0
ffffffffc020adc8:	8552                	mv	a0,s4
ffffffffc020adca:	08c000ef          	jal	ffffffffc020ae56 <unlock_sfs_io>
ffffffffc020adce:	70e2                	ld	ra,56(sp)
ffffffffc020add0:	7442                	ld	s0,48(sp)
ffffffffc020add2:	69e2                	ld	s3,24(sp)
ffffffffc020add4:	6a42                	ld	s4,16(sp)
ffffffffc020add6:	8526                	mv	a0,s1
ffffffffc020add8:	74a2                	ld	s1,40(sp)
ffffffffc020adda:	6121                	addi	sp,sp,64
ffffffffc020addc:	8082                	ret

ffffffffc020adde <sfs_clear_block>:
ffffffffc020adde:	7179                	addi	sp,sp,-48
ffffffffc020ade0:	f022                	sd	s0,32(sp)
ffffffffc020ade2:	e84a                	sd	s2,16(sp)
ffffffffc020ade4:	e44e                	sd	s3,8(sp)
ffffffffc020ade6:	f406                	sd	ra,40(sp)
ffffffffc020ade8:	89b2                	mv	s3,a2
ffffffffc020adea:	ec26                	sd	s1,24(sp)
ffffffffc020adec:	842e                	mv	s0,a1
ffffffffc020adee:	892a                	mv	s2,a0
ffffffffc020adf0:	056000ef          	jal	ffffffffc020ae46 <lock_sfs_io>
ffffffffc020adf4:	04893503          	ld	a0,72(s2)
ffffffffc020adf8:	6605                	lui	a2,0x1
ffffffffc020adfa:	4581                	li	a1,0
ffffffffc020adfc:	59e000ef          	jal	ffffffffc020b39a <memset>
ffffffffc020ae00:	02098d63          	beqz	s3,ffffffffc020ae3a <sfs_clear_block+0x5c>
ffffffffc020ae04:	013409bb          	addw	s3,s0,s3
ffffffffc020ae08:	a019                	j	ffffffffc020ae0e <sfs_clear_block+0x30>
ffffffffc020ae0a:	03340863          	beq	s0,s3,ffffffffc020ae3a <sfs_clear_block+0x5c>
ffffffffc020ae0e:	04893583          	ld	a1,72(s2)
ffffffffc020ae12:	4705                	li	a4,1
ffffffffc020ae14:	8622                	mv	a2,s0
ffffffffc020ae16:	86ba                	mv	a3,a4
ffffffffc020ae18:	854a                	mv	a0,s2
ffffffffc020ae1a:	cd1ff0ef          	jal	ffffffffc020aaea <sfs_rwblock_nolock>
ffffffffc020ae1e:	84aa                	mv	s1,a0
ffffffffc020ae20:	2405                	addiw	s0,s0,1
ffffffffc020ae22:	d565                	beqz	a0,ffffffffc020ae0a <sfs_clear_block+0x2c>
ffffffffc020ae24:	854a                	mv	a0,s2
ffffffffc020ae26:	030000ef          	jal	ffffffffc020ae56 <unlock_sfs_io>
ffffffffc020ae2a:	70a2                	ld	ra,40(sp)
ffffffffc020ae2c:	7402                	ld	s0,32(sp)
ffffffffc020ae2e:	6942                	ld	s2,16(sp)
ffffffffc020ae30:	69a2                	ld	s3,8(sp)
ffffffffc020ae32:	8526                	mv	a0,s1
ffffffffc020ae34:	64e2                	ld	s1,24(sp)
ffffffffc020ae36:	6145                	addi	sp,sp,48
ffffffffc020ae38:	8082                	ret
ffffffffc020ae3a:	4481                	li	s1,0
ffffffffc020ae3c:	b7e5                	j	ffffffffc020ae24 <sfs_clear_block+0x46>

ffffffffc020ae3e <lock_sfs_fs>:
ffffffffc020ae3e:	05050513          	addi	a0,a0,80
ffffffffc020ae42:	d5af906f          	j	ffffffffc020439c <down>

ffffffffc020ae46 <lock_sfs_io>:
ffffffffc020ae46:	06850513          	addi	a0,a0,104
ffffffffc020ae4a:	d52f906f          	j	ffffffffc020439c <down>

ffffffffc020ae4e <unlock_sfs_fs>:
ffffffffc020ae4e:	05050513          	addi	a0,a0,80
ffffffffc020ae52:	d46f906f          	j	ffffffffc0204398 <up>

ffffffffc020ae56 <unlock_sfs_io>:
ffffffffc020ae56:	06850513          	addi	a0,a0,104
ffffffffc020ae5a:	d3ef906f          	j	ffffffffc0204398 <up>

ffffffffc020ae5e <hash32>:
ffffffffc020ae5e:	9e3707b7          	lui	a5,0x9e370
ffffffffc020ae62:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <_binary_bin_sfs_img_size+0xffffffff9e2fad01>
ffffffffc020ae64:	02a787bb          	mulw	a5,a5,a0
ffffffffc020ae68:	02000513          	li	a0,32
ffffffffc020ae6c:	9d0d                	subw	a0,a0,a1
ffffffffc020ae6e:	00a7d53b          	srlw	a0,a5,a0
ffffffffc020ae72:	8082                	ret

ffffffffc020ae74 <printnum>:
ffffffffc020ae74:	7139                	addi	sp,sp,-64
ffffffffc020ae76:	02071893          	slli	a7,a4,0x20
ffffffffc020ae7a:	f822                	sd	s0,48(sp)
ffffffffc020ae7c:	f426                	sd	s1,40(sp)
ffffffffc020ae7e:	f04a                	sd	s2,32(sp)
ffffffffc020ae80:	ec4e                	sd	s3,24(sp)
ffffffffc020ae82:	e456                	sd	s5,8(sp)
ffffffffc020ae84:	0208d893          	srli	a7,a7,0x20
ffffffffc020ae88:	fc06                	sd	ra,56(sp)
ffffffffc020ae8a:	0316fab3          	remu	s5,a3,a7
ffffffffc020ae8e:	fff7841b          	addiw	s0,a5,-1
ffffffffc020ae92:	84aa                	mv	s1,a0
ffffffffc020ae94:	89ae                	mv	s3,a1
ffffffffc020ae96:	8932                	mv	s2,a2
ffffffffc020ae98:	0516f063          	bgeu	a3,a7,ffffffffc020aed8 <printnum+0x64>
ffffffffc020ae9c:	e852                	sd	s4,16(sp)
ffffffffc020ae9e:	4705                	li	a4,1
ffffffffc020aea0:	8a42                	mv	s4,a6
ffffffffc020aea2:	00f75863          	bge	a4,a5,ffffffffc020aeb2 <printnum+0x3e>
ffffffffc020aea6:	864e                	mv	a2,s3
ffffffffc020aea8:	85ca                	mv	a1,s2
ffffffffc020aeaa:	8552                	mv	a0,s4
ffffffffc020aeac:	347d                	addiw	s0,s0,-1
ffffffffc020aeae:	9482                	jalr	s1
ffffffffc020aeb0:	f87d                	bnez	s0,ffffffffc020aea6 <printnum+0x32>
ffffffffc020aeb2:	6a42                	ld	s4,16(sp)
ffffffffc020aeb4:	00004797          	auipc	a5,0x4
ffffffffc020aeb8:	85478793          	addi	a5,a5,-1964 # ffffffffc020e708 <etext+0x3306>
ffffffffc020aebc:	97d6                	add	a5,a5,s5
ffffffffc020aebe:	7442                	ld	s0,48(sp)
ffffffffc020aec0:	0007c503          	lbu	a0,0(a5)
ffffffffc020aec4:	70e2                	ld	ra,56(sp)
ffffffffc020aec6:	6aa2                	ld	s5,8(sp)
ffffffffc020aec8:	864e                	mv	a2,s3
ffffffffc020aeca:	85ca                	mv	a1,s2
ffffffffc020aecc:	69e2                	ld	s3,24(sp)
ffffffffc020aece:	7902                	ld	s2,32(sp)
ffffffffc020aed0:	87a6                	mv	a5,s1
ffffffffc020aed2:	74a2                	ld	s1,40(sp)
ffffffffc020aed4:	6121                	addi	sp,sp,64
ffffffffc020aed6:	8782                	jr	a5
ffffffffc020aed8:	0316d6b3          	divu	a3,a3,a7
ffffffffc020aedc:	87a2                	mv	a5,s0
ffffffffc020aede:	f97ff0ef          	jal	ffffffffc020ae74 <printnum>
ffffffffc020aee2:	bfc9                	j	ffffffffc020aeb4 <printnum+0x40>

ffffffffc020aee4 <sprintputch>:
ffffffffc020aee4:	499c                	lw	a5,16(a1)
ffffffffc020aee6:	6198                	ld	a4,0(a1)
ffffffffc020aee8:	6594                	ld	a3,8(a1)
ffffffffc020aeea:	2785                	addiw	a5,a5,1
ffffffffc020aeec:	c99c                	sw	a5,16(a1)
ffffffffc020aeee:	00d77763          	bgeu	a4,a3,ffffffffc020aefc <sprintputch+0x18>
ffffffffc020aef2:	00170793          	addi	a5,a4,1
ffffffffc020aef6:	e19c                	sd	a5,0(a1)
ffffffffc020aef8:	00a70023          	sb	a0,0(a4)
ffffffffc020aefc:	8082                	ret

ffffffffc020aefe <vprintfmt>:
ffffffffc020aefe:	7119                	addi	sp,sp,-128
ffffffffc020af00:	f4a6                	sd	s1,104(sp)
ffffffffc020af02:	f0ca                	sd	s2,96(sp)
ffffffffc020af04:	ecce                	sd	s3,88(sp)
ffffffffc020af06:	e8d2                	sd	s4,80(sp)
ffffffffc020af08:	e4d6                	sd	s5,72(sp)
ffffffffc020af0a:	e0da                	sd	s6,64(sp)
ffffffffc020af0c:	fc5e                	sd	s7,56(sp)
ffffffffc020af0e:	f466                	sd	s9,40(sp)
ffffffffc020af10:	fc86                	sd	ra,120(sp)
ffffffffc020af12:	f8a2                	sd	s0,112(sp)
ffffffffc020af14:	f862                	sd	s8,48(sp)
ffffffffc020af16:	f06a                	sd	s10,32(sp)
ffffffffc020af18:	ec6e                	sd	s11,24(sp)
ffffffffc020af1a:	84aa                	mv	s1,a0
ffffffffc020af1c:	8cb6                	mv	s9,a3
ffffffffc020af1e:	8aba                	mv	s5,a4
ffffffffc020af20:	89ae                	mv	s3,a1
ffffffffc020af22:	8932                	mv	s2,a2
ffffffffc020af24:	02500a13          	li	s4,37
ffffffffc020af28:	05500b93          	li	s7,85
ffffffffc020af2c:	00004b17          	auipc	s6,0x4
ffffffffc020af30:	484b0b13          	addi	s6,s6,1156 # ffffffffc020f3b0 <sfs_node_dirops+0x80>
ffffffffc020af34:	000cc503          	lbu	a0,0(s9)
ffffffffc020af38:	001c8413          	addi	s0,s9,1
ffffffffc020af3c:	01450b63          	beq	a0,s4,ffffffffc020af52 <vprintfmt+0x54>
ffffffffc020af40:	cd15                	beqz	a0,ffffffffc020af7c <vprintfmt+0x7e>
ffffffffc020af42:	864e                	mv	a2,s3
ffffffffc020af44:	85ca                	mv	a1,s2
ffffffffc020af46:	9482                	jalr	s1
ffffffffc020af48:	00044503          	lbu	a0,0(s0)
ffffffffc020af4c:	0405                	addi	s0,s0,1
ffffffffc020af4e:	ff4519e3          	bne	a0,s4,ffffffffc020af40 <vprintfmt+0x42>
ffffffffc020af52:	5d7d                	li	s10,-1
ffffffffc020af54:	8dea                	mv	s11,s10
ffffffffc020af56:	02000813          	li	a6,32
ffffffffc020af5a:	4c01                	li	s8,0
ffffffffc020af5c:	4581                	li	a1,0
ffffffffc020af5e:	00044703          	lbu	a4,0(s0)
ffffffffc020af62:	00140c93          	addi	s9,s0,1
ffffffffc020af66:	fdd7061b          	addiw	a2,a4,-35
ffffffffc020af6a:	0ff67613          	zext.b	a2,a2
ffffffffc020af6e:	02cbe663          	bltu	s7,a2,ffffffffc020af9a <vprintfmt+0x9c>
ffffffffc020af72:	060a                	slli	a2,a2,0x2
ffffffffc020af74:	965a                	add	a2,a2,s6
ffffffffc020af76:	421c                	lw	a5,0(a2)
ffffffffc020af78:	97da                	add	a5,a5,s6
ffffffffc020af7a:	8782                	jr	a5
ffffffffc020af7c:	70e6                	ld	ra,120(sp)
ffffffffc020af7e:	7446                	ld	s0,112(sp)
ffffffffc020af80:	74a6                	ld	s1,104(sp)
ffffffffc020af82:	7906                	ld	s2,96(sp)
ffffffffc020af84:	69e6                	ld	s3,88(sp)
ffffffffc020af86:	6a46                	ld	s4,80(sp)
ffffffffc020af88:	6aa6                	ld	s5,72(sp)
ffffffffc020af8a:	6b06                	ld	s6,64(sp)
ffffffffc020af8c:	7be2                	ld	s7,56(sp)
ffffffffc020af8e:	7c42                	ld	s8,48(sp)
ffffffffc020af90:	7ca2                	ld	s9,40(sp)
ffffffffc020af92:	7d02                	ld	s10,32(sp)
ffffffffc020af94:	6de2                	ld	s11,24(sp)
ffffffffc020af96:	6109                	addi	sp,sp,128
ffffffffc020af98:	8082                	ret
ffffffffc020af9a:	864e                	mv	a2,s3
ffffffffc020af9c:	85ca                	mv	a1,s2
ffffffffc020af9e:	02500513          	li	a0,37
ffffffffc020afa2:	9482                	jalr	s1
ffffffffc020afa4:	fff44783          	lbu	a5,-1(s0)
ffffffffc020afa8:	02500713          	li	a4,37
ffffffffc020afac:	8ca2                	mv	s9,s0
ffffffffc020afae:	f8e783e3          	beq	a5,a4,ffffffffc020af34 <vprintfmt+0x36>
ffffffffc020afb2:	ffecc783          	lbu	a5,-2(s9)
ffffffffc020afb6:	1cfd                	addi	s9,s9,-1
ffffffffc020afb8:	fee79de3          	bne	a5,a4,ffffffffc020afb2 <vprintfmt+0xb4>
ffffffffc020afbc:	bfa5                	j	ffffffffc020af34 <vprintfmt+0x36>
ffffffffc020afbe:	00144683          	lbu	a3,1(s0)
ffffffffc020afc2:	4525                	li	a0,9
ffffffffc020afc4:	fd070d1b          	addiw	s10,a4,-48
ffffffffc020afc8:	fd06879b          	addiw	a5,a3,-48
ffffffffc020afcc:	28f56063          	bltu	a0,a5,ffffffffc020b24c <vprintfmt+0x34e>
ffffffffc020afd0:	2681                	sext.w	a3,a3
ffffffffc020afd2:	8466                	mv	s0,s9
ffffffffc020afd4:	002d179b          	slliw	a5,s10,0x2
ffffffffc020afd8:	00144703          	lbu	a4,1(s0)
ffffffffc020afdc:	01a787bb          	addw	a5,a5,s10
ffffffffc020afe0:	0017979b          	slliw	a5,a5,0x1
ffffffffc020afe4:	9fb5                	addw	a5,a5,a3
ffffffffc020afe6:	fd07061b          	addiw	a2,a4,-48
ffffffffc020afea:	0405                	addi	s0,s0,1
ffffffffc020afec:	fd078d1b          	addiw	s10,a5,-48
ffffffffc020aff0:	0007069b          	sext.w	a3,a4
ffffffffc020aff4:	fec570e3          	bgeu	a0,a2,ffffffffc020afd4 <vprintfmt+0xd6>
ffffffffc020aff8:	f60dd3e3          	bgez	s11,ffffffffc020af5e <vprintfmt+0x60>
ffffffffc020affc:	8dea                	mv	s11,s10
ffffffffc020affe:	5d7d                	li	s10,-1
ffffffffc020b000:	bfb9                	j	ffffffffc020af5e <vprintfmt+0x60>
ffffffffc020b002:	883a                	mv	a6,a4
ffffffffc020b004:	8466                	mv	s0,s9
ffffffffc020b006:	bfa1                	j	ffffffffc020af5e <vprintfmt+0x60>
ffffffffc020b008:	8466                	mv	s0,s9
ffffffffc020b00a:	4c05                	li	s8,1
ffffffffc020b00c:	bf89                	j	ffffffffc020af5e <vprintfmt+0x60>
ffffffffc020b00e:	4785                	li	a5,1
ffffffffc020b010:	008a8613          	addi	a2,s5,8 # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc020b014:	00b7c463          	blt	a5,a1,ffffffffc020b01c <vprintfmt+0x11e>
ffffffffc020b018:	1c058363          	beqz	a1,ffffffffc020b1de <vprintfmt+0x2e0>
ffffffffc020b01c:	000ab683          	ld	a3,0(s5)
ffffffffc020b020:	4741                	li	a4,16
ffffffffc020b022:	8ab2                	mv	s5,a2
ffffffffc020b024:	2801                	sext.w	a6,a6
ffffffffc020b026:	87ee                	mv	a5,s11
ffffffffc020b028:	864a                	mv	a2,s2
ffffffffc020b02a:	85ce                	mv	a1,s3
ffffffffc020b02c:	8526                	mv	a0,s1
ffffffffc020b02e:	e47ff0ef          	jal	ffffffffc020ae74 <printnum>
ffffffffc020b032:	b709                	j	ffffffffc020af34 <vprintfmt+0x36>
ffffffffc020b034:	000aa503          	lw	a0,0(s5)
ffffffffc020b038:	864e                	mv	a2,s3
ffffffffc020b03a:	85ca                	mv	a1,s2
ffffffffc020b03c:	9482                	jalr	s1
ffffffffc020b03e:	0aa1                	addi	s5,s5,8
ffffffffc020b040:	bdd5                	j	ffffffffc020af34 <vprintfmt+0x36>
ffffffffc020b042:	4785                	li	a5,1
ffffffffc020b044:	008a8613          	addi	a2,s5,8
ffffffffc020b048:	00b7c463          	blt	a5,a1,ffffffffc020b050 <vprintfmt+0x152>
ffffffffc020b04c:	18058463          	beqz	a1,ffffffffc020b1d4 <vprintfmt+0x2d6>
ffffffffc020b050:	000ab683          	ld	a3,0(s5)
ffffffffc020b054:	4729                	li	a4,10
ffffffffc020b056:	8ab2                	mv	s5,a2
ffffffffc020b058:	b7f1                	j	ffffffffc020b024 <vprintfmt+0x126>
ffffffffc020b05a:	864e                	mv	a2,s3
ffffffffc020b05c:	85ca                	mv	a1,s2
ffffffffc020b05e:	03000513          	li	a0,48
ffffffffc020b062:	e042                	sd	a6,0(sp)
ffffffffc020b064:	9482                	jalr	s1
ffffffffc020b066:	864e                	mv	a2,s3
ffffffffc020b068:	85ca                	mv	a1,s2
ffffffffc020b06a:	07800513          	li	a0,120
ffffffffc020b06e:	9482                	jalr	s1
ffffffffc020b070:	000ab683          	ld	a3,0(s5)
ffffffffc020b074:	6802                	ld	a6,0(sp)
ffffffffc020b076:	4741                	li	a4,16
ffffffffc020b078:	0aa1                	addi	s5,s5,8
ffffffffc020b07a:	b76d                	j	ffffffffc020b024 <vprintfmt+0x126>
ffffffffc020b07c:	864e                	mv	a2,s3
ffffffffc020b07e:	85ca                	mv	a1,s2
ffffffffc020b080:	02500513          	li	a0,37
ffffffffc020b084:	9482                	jalr	s1
ffffffffc020b086:	b57d                	j	ffffffffc020af34 <vprintfmt+0x36>
ffffffffc020b088:	000aad03          	lw	s10,0(s5)
ffffffffc020b08c:	8466                	mv	s0,s9
ffffffffc020b08e:	0aa1                	addi	s5,s5,8
ffffffffc020b090:	b7a5                	j	ffffffffc020aff8 <vprintfmt+0xfa>
ffffffffc020b092:	4785                	li	a5,1
ffffffffc020b094:	008a8613          	addi	a2,s5,8
ffffffffc020b098:	00b7c463          	blt	a5,a1,ffffffffc020b0a0 <vprintfmt+0x1a2>
ffffffffc020b09c:	12058763          	beqz	a1,ffffffffc020b1ca <vprintfmt+0x2cc>
ffffffffc020b0a0:	000ab683          	ld	a3,0(s5)
ffffffffc020b0a4:	4721                	li	a4,8
ffffffffc020b0a6:	8ab2                	mv	s5,a2
ffffffffc020b0a8:	bfb5                	j	ffffffffc020b024 <vprintfmt+0x126>
ffffffffc020b0aa:	87ee                	mv	a5,s11
ffffffffc020b0ac:	000dd363          	bgez	s11,ffffffffc020b0b2 <vprintfmt+0x1b4>
ffffffffc020b0b0:	4781                	li	a5,0
ffffffffc020b0b2:	00078d9b          	sext.w	s11,a5
ffffffffc020b0b6:	8466                	mv	s0,s9
ffffffffc020b0b8:	b55d                	j	ffffffffc020af5e <vprintfmt+0x60>
ffffffffc020b0ba:	0008041b          	sext.w	s0,a6
ffffffffc020b0be:	fd340793          	addi	a5,s0,-45
ffffffffc020b0c2:	01b02733          	sgtz	a4,s11
ffffffffc020b0c6:	00f037b3          	snez	a5,a5
ffffffffc020b0ca:	8ff9                	and	a5,a5,a4
ffffffffc020b0cc:	000ab703          	ld	a4,0(s5)
ffffffffc020b0d0:	008a8693          	addi	a3,s5,8
ffffffffc020b0d4:	e436                	sd	a3,8(sp)
ffffffffc020b0d6:	12070563          	beqz	a4,ffffffffc020b200 <vprintfmt+0x302>
ffffffffc020b0da:	12079d63          	bnez	a5,ffffffffc020b214 <vprintfmt+0x316>
ffffffffc020b0de:	00074783          	lbu	a5,0(a4)
ffffffffc020b0e2:	0007851b          	sext.w	a0,a5
ffffffffc020b0e6:	c78d                	beqz	a5,ffffffffc020b110 <vprintfmt+0x212>
ffffffffc020b0e8:	00170a93          	addi	s5,a4,1
ffffffffc020b0ec:	547d                	li	s0,-1
ffffffffc020b0ee:	000d4563          	bltz	s10,ffffffffc020b0f8 <vprintfmt+0x1fa>
ffffffffc020b0f2:	3d7d                	addiw	s10,s10,-1
ffffffffc020b0f4:	008d0e63          	beq	s10,s0,ffffffffc020b110 <vprintfmt+0x212>
ffffffffc020b0f8:	020c1863          	bnez	s8,ffffffffc020b128 <vprintfmt+0x22a>
ffffffffc020b0fc:	864e                	mv	a2,s3
ffffffffc020b0fe:	85ca                	mv	a1,s2
ffffffffc020b100:	9482                	jalr	s1
ffffffffc020b102:	000ac783          	lbu	a5,0(s5)
ffffffffc020b106:	0a85                	addi	s5,s5,1
ffffffffc020b108:	3dfd                	addiw	s11,s11,-1
ffffffffc020b10a:	0007851b          	sext.w	a0,a5
ffffffffc020b10e:	f3e5                	bnez	a5,ffffffffc020b0ee <vprintfmt+0x1f0>
ffffffffc020b110:	01b05a63          	blez	s11,ffffffffc020b124 <vprintfmt+0x226>
ffffffffc020b114:	864e                	mv	a2,s3
ffffffffc020b116:	85ca                	mv	a1,s2
ffffffffc020b118:	02000513          	li	a0,32
ffffffffc020b11c:	3dfd                	addiw	s11,s11,-1
ffffffffc020b11e:	9482                	jalr	s1
ffffffffc020b120:	fe0d9ae3          	bnez	s11,ffffffffc020b114 <vprintfmt+0x216>
ffffffffc020b124:	6aa2                	ld	s5,8(sp)
ffffffffc020b126:	b539                	j	ffffffffc020af34 <vprintfmt+0x36>
ffffffffc020b128:	3781                	addiw	a5,a5,-32
ffffffffc020b12a:	05e00713          	li	a4,94
ffffffffc020b12e:	fcf777e3          	bgeu	a4,a5,ffffffffc020b0fc <vprintfmt+0x1fe>
ffffffffc020b132:	03f00513          	li	a0,63
ffffffffc020b136:	864e                	mv	a2,s3
ffffffffc020b138:	85ca                	mv	a1,s2
ffffffffc020b13a:	9482                	jalr	s1
ffffffffc020b13c:	000ac783          	lbu	a5,0(s5)
ffffffffc020b140:	0a85                	addi	s5,s5,1
ffffffffc020b142:	3dfd                	addiw	s11,s11,-1
ffffffffc020b144:	0007851b          	sext.w	a0,a5
ffffffffc020b148:	d7e1                	beqz	a5,ffffffffc020b110 <vprintfmt+0x212>
ffffffffc020b14a:	fa0d54e3          	bgez	s10,ffffffffc020b0f2 <vprintfmt+0x1f4>
ffffffffc020b14e:	bfe9                	j	ffffffffc020b128 <vprintfmt+0x22a>
ffffffffc020b150:	000aa783          	lw	a5,0(s5)
ffffffffc020b154:	46e1                	li	a3,24
ffffffffc020b156:	0aa1                	addi	s5,s5,8
ffffffffc020b158:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020b15c:	8fb9                	xor	a5,a5,a4
ffffffffc020b15e:	40e7873b          	subw	a4,a5,a4
ffffffffc020b162:	02e6c663          	blt	a3,a4,ffffffffc020b18e <vprintfmt+0x290>
ffffffffc020b166:	00004797          	auipc	a5,0x4
ffffffffc020b16a:	3a278793          	addi	a5,a5,930 # ffffffffc020f508 <error_string>
ffffffffc020b16e:	00371693          	slli	a3,a4,0x3
ffffffffc020b172:	97b6                	add	a5,a5,a3
ffffffffc020b174:	639c                	ld	a5,0(a5)
ffffffffc020b176:	cf81                	beqz	a5,ffffffffc020b18e <vprintfmt+0x290>
ffffffffc020b178:	873e                	mv	a4,a5
ffffffffc020b17a:	00000697          	auipc	a3,0x0
ffffffffc020b17e:	2b668693          	addi	a3,a3,694 # ffffffffc020b430 <etext+0x2e>
ffffffffc020b182:	864a                	mv	a2,s2
ffffffffc020b184:	85ce                	mv	a1,s3
ffffffffc020b186:	8526                	mv	a0,s1
ffffffffc020b188:	0f2000ef          	jal	ffffffffc020b27a <printfmt>
ffffffffc020b18c:	b365                	j	ffffffffc020af34 <vprintfmt+0x36>
ffffffffc020b18e:	00003697          	auipc	a3,0x3
ffffffffc020b192:	59a68693          	addi	a3,a3,1434 # ffffffffc020e728 <etext+0x3326>
ffffffffc020b196:	864a                	mv	a2,s2
ffffffffc020b198:	85ce                	mv	a1,s3
ffffffffc020b19a:	8526                	mv	a0,s1
ffffffffc020b19c:	0de000ef          	jal	ffffffffc020b27a <printfmt>
ffffffffc020b1a0:	bb51                	j	ffffffffc020af34 <vprintfmt+0x36>
ffffffffc020b1a2:	4785                	li	a5,1
ffffffffc020b1a4:	008a8c13          	addi	s8,s5,8
ffffffffc020b1a8:	00b7c363          	blt	a5,a1,ffffffffc020b1ae <vprintfmt+0x2b0>
ffffffffc020b1ac:	cd81                	beqz	a1,ffffffffc020b1c4 <vprintfmt+0x2c6>
ffffffffc020b1ae:	000ab403          	ld	s0,0(s5)
ffffffffc020b1b2:	02044b63          	bltz	s0,ffffffffc020b1e8 <vprintfmt+0x2ea>
ffffffffc020b1b6:	86a2                	mv	a3,s0
ffffffffc020b1b8:	8ae2                	mv	s5,s8
ffffffffc020b1ba:	4729                	li	a4,10
ffffffffc020b1bc:	b5a5                	j	ffffffffc020b024 <vprintfmt+0x126>
ffffffffc020b1be:	2585                	addiw	a1,a1,1
ffffffffc020b1c0:	8466                	mv	s0,s9
ffffffffc020b1c2:	bb71                	j	ffffffffc020af5e <vprintfmt+0x60>
ffffffffc020b1c4:	000aa403          	lw	s0,0(s5)
ffffffffc020b1c8:	b7ed                	j	ffffffffc020b1b2 <vprintfmt+0x2b4>
ffffffffc020b1ca:	000ae683          	lwu	a3,0(s5)
ffffffffc020b1ce:	4721                	li	a4,8
ffffffffc020b1d0:	8ab2                	mv	s5,a2
ffffffffc020b1d2:	bd89                	j	ffffffffc020b024 <vprintfmt+0x126>
ffffffffc020b1d4:	000ae683          	lwu	a3,0(s5)
ffffffffc020b1d8:	4729                	li	a4,10
ffffffffc020b1da:	8ab2                	mv	s5,a2
ffffffffc020b1dc:	b5a1                	j	ffffffffc020b024 <vprintfmt+0x126>
ffffffffc020b1de:	000ae683          	lwu	a3,0(s5)
ffffffffc020b1e2:	4741                	li	a4,16
ffffffffc020b1e4:	8ab2                	mv	s5,a2
ffffffffc020b1e6:	bd3d                	j	ffffffffc020b024 <vprintfmt+0x126>
ffffffffc020b1e8:	864e                	mv	a2,s3
ffffffffc020b1ea:	85ca                	mv	a1,s2
ffffffffc020b1ec:	02d00513          	li	a0,45
ffffffffc020b1f0:	e042                	sd	a6,0(sp)
ffffffffc020b1f2:	9482                	jalr	s1
ffffffffc020b1f4:	6802                	ld	a6,0(sp)
ffffffffc020b1f6:	408006b3          	neg	a3,s0
ffffffffc020b1fa:	8ae2                	mv	s5,s8
ffffffffc020b1fc:	4729                	li	a4,10
ffffffffc020b1fe:	b51d                	j	ffffffffc020b024 <vprintfmt+0x126>
ffffffffc020b200:	eba1                	bnez	a5,ffffffffc020b250 <vprintfmt+0x352>
ffffffffc020b202:	02800793          	li	a5,40
ffffffffc020b206:	853e                	mv	a0,a5
ffffffffc020b208:	00003a97          	auipc	s5,0x3
ffffffffc020b20c:	519a8a93          	addi	s5,s5,1305 # ffffffffc020e721 <etext+0x331f>
ffffffffc020b210:	547d                	li	s0,-1
ffffffffc020b212:	bdf1                	j	ffffffffc020b0ee <vprintfmt+0x1f0>
ffffffffc020b214:	853a                	mv	a0,a4
ffffffffc020b216:	85ea                	mv	a1,s10
ffffffffc020b218:	e03a                	sd	a4,0(sp)
ffffffffc020b21a:	0e4000ef          	jal	ffffffffc020b2fe <strnlen>
ffffffffc020b21e:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020b222:	6702                	ld	a4,0(sp)
ffffffffc020b224:	01b05b63          	blez	s11,ffffffffc020b23a <vprintfmt+0x33c>
ffffffffc020b228:	864e                	mv	a2,s3
ffffffffc020b22a:	85ca                	mv	a1,s2
ffffffffc020b22c:	8522                	mv	a0,s0
ffffffffc020b22e:	e03a                	sd	a4,0(sp)
ffffffffc020b230:	3dfd                	addiw	s11,s11,-1
ffffffffc020b232:	9482                	jalr	s1
ffffffffc020b234:	6702                	ld	a4,0(sp)
ffffffffc020b236:	fe0d99e3          	bnez	s11,ffffffffc020b228 <vprintfmt+0x32a>
ffffffffc020b23a:	00074783          	lbu	a5,0(a4)
ffffffffc020b23e:	0007851b          	sext.w	a0,a5
ffffffffc020b242:	ee0781e3          	beqz	a5,ffffffffc020b124 <vprintfmt+0x226>
ffffffffc020b246:	00170a93          	addi	s5,a4,1
ffffffffc020b24a:	b54d                	j	ffffffffc020b0ec <vprintfmt+0x1ee>
ffffffffc020b24c:	8466                	mv	s0,s9
ffffffffc020b24e:	b36d                	j	ffffffffc020aff8 <vprintfmt+0xfa>
ffffffffc020b250:	85ea                	mv	a1,s10
ffffffffc020b252:	00003517          	auipc	a0,0x3
ffffffffc020b256:	4ce50513          	addi	a0,a0,1230 # ffffffffc020e720 <etext+0x331e>
ffffffffc020b25a:	0a4000ef          	jal	ffffffffc020b2fe <strnlen>
ffffffffc020b25e:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020b262:	02800793          	li	a5,40
ffffffffc020b266:	00003717          	auipc	a4,0x3
ffffffffc020b26a:	4ba70713          	addi	a4,a4,1210 # ffffffffc020e720 <etext+0x331e>
ffffffffc020b26e:	853e                	mv	a0,a5
ffffffffc020b270:	fbb04ce3          	bgtz	s11,ffffffffc020b228 <vprintfmt+0x32a>
ffffffffc020b274:	00170a93          	addi	s5,a4,1
ffffffffc020b278:	bd95                	j	ffffffffc020b0ec <vprintfmt+0x1ee>

ffffffffc020b27a <printfmt>:
ffffffffc020b27a:	7139                	addi	sp,sp,-64
ffffffffc020b27c:	02010313          	addi	t1,sp,32
ffffffffc020b280:	f03a                	sd	a4,32(sp)
ffffffffc020b282:	871a                	mv	a4,t1
ffffffffc020b284:	ec06                	sd	ra,24(sp)
ffffffffc020b286:	f43e                	sd	a5,40(sp)
ffffffffc020b288:	f842                	sd	a6,48(sp)
ffffffffc020b28a:	fc46                	sd	a7,56(sp)
ffffffffc020b28c:	e41a                	sd	t1,8(sp)
ffffffffc020b28e:	c71ff0ef          	jal	ffffffffc020aefe <vprintfmt>
ffffffffc020b292:	60e2                	ld	ra,24(sp)
ffffffffc020b294:	6121                	addi	sp,sp,64
ffffffffc020b296:	8082                	ret

ffffffffc020b298 <snprintf>:
ffffffffc020b298:	711d                	addi	sp,sp,-96
ffffffffc020b29a:	15fd                	addi	a1,a1,-1
ffffffffc020b29c:	95aa                	add	a1,a1,a0
ffffffffc020b29e:	03810313          	addi	t1,sp,56
ffffffffc020b2a2:	f406                	sd	ra,40(sp)
ffffffffc020b2a4:	e82e                	sd	a1,16(sp)
ffffffffc020b2a6:	e42a                	sd	a0,8(sp)
ffffffffc020b2a8:	fc36                	sd	a3,56(sp)
ffffffffc020b2aa:	e0ba                	sd	a4,64(sp)
ffffffffc020b2ac:	e4be                	sd	a5,72(sp)
ffffffffc020b2ae:	e8c2                	sd	a6,80(sp)
ffffffffc020b2b0:	ecc6                	sd	a7,88(sp)
ffffffffc020b2b2:	cc02                	sw	zero,24(sp)
ffffffffc020b2b4:	e01a                	sd	t1,0(sp)
ffffffffc020b2b6:	c515                	beqz	a0,ffffffffc020b2e2 <snprintf+0x4a>
ffffffffc020b2b8:	02a5e563          	bltu	a1,a0,ffffffffc020b2e2 <snprintf+0x4a>
ffffffffc020b2bc:	75dd                	lui	a1,0xffff7
ffffffffc020b2be:	86b2                	mv	a3,a2
ffffffffc020b2c0:	00000517          	auipc	a0,0x0
ffffffffc020b2c4:	c2450513          	addi	a0,a0,-988 # ffffffffc020aee4 <sprintputch>
ffffffffc020b2c8:	871a                	mv	a4,t1
ffffffffc020b2ca:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020b2ce:	0030                	addi	a2,sp,8
ffffffffc020b2d0:	c2fff0ef          	jal	ffffffffc020aefe <vprintfmt>
ffffffffc020b2d4:	67a2                	ld	a5,8(sp)
ffffffffc020b2d6:	00078023          	sb	zero,0(a5)
ffffffffc020b2da:	4562                	lw	a0,24(sp)
ffffffffc020b2dc:	70a2                	ld	ra,40(sp)
ffffffffc020b2de:	6125                	addi	sp,sp,96
ffffffffc020b2e0:	8082                	ret
ffffffffc020b2e2:	5575                	li	a0,-3
ffffffffc020b2e4:	bfe5                	j	ffffffffc020b2dc <snprintf+0x44>

ffffffffc020b2e6 <strlen>:
ffffffffc020b2e6:	00054783          	lbu	a5,0(a0)
ffffffffc020b2ea:	cb81                	beqz	a5,ffffffffc020b2fa <strlen+0x14>
ffffffffc020b2ec:	4781                	li	a5,0
ffffffffc020b2ee:	0785                	addi	a5,a5,1
ffffffffc020b2f0:	00f50733          	add	a4,a0,a5
ffffffffc020b2f4:	00074703          	lbu	a4,0(a4)
ffffffffc020b2f8:	fb7d                	bnez	a4,ffffffffc020b2ee <strlen+0x8>
ffffffffc020b2fa:	853e                	mv	a0,a5
ffffffffc020b2fc:	8082                	ret

ffffffffc020b2fe <strnlen>:
ffffffffc020b2fe:	4781                	li	a5,0
ffffffffc020b300:	e589                	bnez	a1,ffffffffc020b30a <strnlen+0xc>
ffffffffc020b302:	a811                	j	ffffffffc020b316 <strnlen+0x18>
ffffffffc020b304:	0785                	addi	a5,a5,1
ffffffffc020b306:	00f58863          	beq	a1,a5,ffffffffc020b316 <strnlen+0x18>
ffffffffc020b30a:	00f50733          	add	a4,a0,a5
ffffffffc020b30e:	00074703          	lbu	a4,0(a4)
ffffffffc020b312:	fb6d                	bnez	a4,ffffffffc020b304 <strnlen+0x6>
ffffffffc020b314:	85be                	mv	a1,a5
ffffffffc020b316:	852e                	mv	a0,a1
ffffffffc020b318:	8082                	ret

ffffffffc020b31a <strcpy>:
ffffffffc020b31a:	87aa                	mv	a5,a0
ffffffffc020b31c:	0005c703          	lbu	a4,0(a1)
ffffffffc020b320:	0585                	addi	a1,a1,1
ffffffffc020b322:	0785                	addi	a5,a5,1
ffffffffc020b324:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b328:	fb75                	bnez	a4,ffffffffc020b31c <strcpy+0x2>
ffffffffc020b32a:	8082                	ret

ffffffffc020b32c <strcmp>:
ffffffffc020b32c:	00054783          	lbu	a5,0(a0)
ffffffffc020b330:	e791                	bnez	a5,ffffffffc020b33c <strcmp+0x10>
ffffffffc020b332:	a01d                	j	ffffffffc020b358 <strcmp+0x2c>
ffffffffc020b334:	00054783          	lbu	a5,0(a0)
ffffffffc020b338:	cb99                	beqz	a5,ffffffffc020b34e <strcmp+0x22>
ffffffffc020b33a:	0585                	addi	a1,a1,1
ffffffffc020b33c:	0005c703          	lbu	a4,0(a1)
ffffffffc020b340:	0505                	addi	a0,a0,1
ffffffffc020b342:	fef709e3          	beq	a4,a5,ffffffffc020b334 <strcmp+0x8>
ffffffffc020b346:	0007851b          	sext.w	a0,a5
ffffffffc020b34a:	9d19                	subw	a0,a0,a4
ffffffffc020b34c:	8082                	ret
ffffffffc020b34e:	0015c703          	lbu	a4,1(a1)
ffffffffc020b352:	4501                	li	a0,0
ffffffffc020b354:	9d19                	subw	a0,a0,a4
ffffffffc020b356:	8082                	ret
ffffffffc020b358:	0005c703          	lbu	a4,0(a1)
ffffffffc020b35c:	4501                	li	a0,0
ffffffffc020b35e:	b7f5                	j	ffffffffc020b34a <strcmp+0x1e>

ffffffffc020b360 <strncmp>:
ffffffffc020b360:	ce01                	beqz	a2,ffffffffc020b378 <strncmp+0x18>
ffffffffc020b362:	00054783          	lbu	a5,0(a0)
ffffffffc020b366:	167d                	addi	a2,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020b368:	cb91                	beqz	a5,ffffffffc020b37c <strncmp+0x1c>
ffffffffc020b36a:	0005c703          	lbu	a4,0(a1)
ffffffffc020b36e:	00f71763          	bne	a4,a5,ffffffffc020b37c <strncmp+0x1c>
ffffffffc020b372:	0505                	addi	a0,a0,1
ffffffffc020b374:	0585                	addi	a1,a1,1
ffffffffc020b376:	f675                	bnez	a2,ffffffffc020b362 <strncmp+0x2>
ffffffffc020b378:	4501                	li	a0,0
ffffffffc020b37a:	8082                	ret
ffffffffc020b37c:	00054503          	lbu	a0,0(a0)
ffffffffc020b380:	0005c783          	lbu	a5,0(a1)
ffffffffc020b384:	9d1d                	subw	a0,a0,a5
ffffffffc020b386:	8082                	ret

ffffffffc020b388 <strchr>:
ffffffffc020b388:	a021                	j	ffffffffc020b390 <strchr+0x8>
ffffffffc020b38a:	00f58763          	beq	a1,a5,ffffffffc020b398 <strchr+0x10>
ffffffffc020b38e:	0505                	addi	a0,a0,1
ffffffffc020b390:	00054783          	lbu	a5,0(a0)
ffffffffc020b394:	fbfd                	bnez	a5,ffffffffc020b38a <strchr+0x2>
ffffffffc020b396:	4501                	li	a0,0
ffffffffc020b398:	8082                	ret

ffffffffc020b39a <memset>:
ffffffffc020b39a:	ca01                	beqz	a2,ffffffffc020b3aa <memset+0x10>
ffffffffc020b39c:	962a                	add	a2,a2,a0
ffffffffc020b39e:	87aa                	mv	a5,a0
ffffffffc020b3a0:	0785                	addi	a5,a5,1
ffffffffc020b3a2:	feb78fa3          	sb	a1,-1(a5)
ffffffffc020b3a6:	fef61de3          	bne	a2,a5,ffffffffc020b3a0 <memset+0x6>
ffffffffc020b3aa:	8082                	ret

ffffffffc020b3ac <memmove>:
ffffffffc020b3ac:	02a5f163          	bgeu	a1,a0,ffffffffc020b3ce <memmove+0x22>
ffffffffc020b3b0:	00c587b3          	add	a5,a1,a2
ffffffffc020b3b4:	00f57d63          	bgeu	a0,a5,ffffffffc020b3ce <memmove+0x22>
ffffffffc020b3b8:	c61d                	beqz	a2,ffffffffc020b3e6 <memmove+0x3a>
ffffffffc020b3ba:	962a                	add	a2,a2,a0
ffffffffc020b3bc:	fff7c703          	lbu	a4,-1(a5)
ffffffffc020b3c0:	17fd                	addi	a5,a5,-1
ffffffffc020b3c2:	167d                	addi	a2,a2,-1
ffffffffc020b3c4:	00e60023          	sb	a4,0(a2)
ffffffffc020b3c8:	fef59ae3          	bne	a1,a5,ffffffffc020b3bc <memmove+0x10>
ffffffffc020b3cc:	8082                	ret
ffffffffc020b3ce:	00c586b3          	add	a3,a1,a2
ffffffffc020b3d2:	87aa                	mv	a5,a0
ffffffffc020b3d4:	ca11                	beqz	a2,ffffffffc020b3e8 <memmove+0x3c>
ffffffffc020b3d6:	0005c703          	lbu	a4,0(a1)
ffffffffc020b3da:	0585                	addi	a1,a1,1
ffffffffc020b3dc:	0785                	addi	a5,a5,1
ffffffffc020b3de:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b3e2:	feb69ae3          	bne	a3,a1,ffffffffc020b3d6 <memmove+0x2a>
ffffffffc020b3e6:	8082                	ret
ffffffffc020b3e8:	8082                	ret

ffffffffc020b3ea <memcpy>:
ffffffffc020b3ea:	ca19                	beqz	a2,ffffffffc020b400 <memcpy+0x16>
ffffffffc020b3ec:	962e                	add	a2,a2,a1
ffffffffc020b3ee:	87aa                	mv	a5,a0
ffffffffc020b3f0:	0005c703          	lbu	a4,0(a1)
ffffffffc020b3f4:	0585                	addi	a1,a1,1
ffffffffc020b3f6:	0785                	addi	a5,a5,1
ffffffffc020b3f8:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b3fc:	feb61ae3          	bne	a2,a1,ffffffffc020b3f0 <memcpy+0x6>
ffffffffc020b400:	8082                	ret
