
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
ffffffffc0200062:	5300b0ef          	jal	ffffffffc020b592 <memset>
ffffffffc0200066:	54e000ef          	jal	ffffffffc02005b4 <cons_init>
ffffffffc020006a:	0000b597          	auipc	a1,0xb
ffffffffc020006e:	59658593          	addi	a1,a1,1430 # ffffffffc020b600 <etext+0x6>
ffffffffc0200072:	0000b517          	auipc	a0,0xb
ffffffffc0200076:	5ae50513          	addi	a0,a0,1454 # ffffffffc020b620 <etext+0x26>
ffffffffc020007a:	12c000ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020007e:	1ac000ef          	jal	ffffffffc020022a <print_kerninfo>
ffffffffc0200082:	68c000ef          	jal	ffffffffc020070e <dtb_init>
ffffffffc0200086:	263020ef          	jal	ffffffffc0202ae8 <pmm_init>
ffffffffc020008a:	3ed000ef          	jal	ffffffffc0200c76 <pic_init>
ffffffffc020008e:	50f000ef          	jal	ffffffffc0200d9c <idt_init>
ffffffffc0200092:	55d030ef          	jal	ffffffffc0203dee <vmm_init>
ffffffffc0200096:	0f8070ef          	jal	ffffffffc020718e <sched_init>
ffffffffc020009a:	4fd060ef          	jal	ffffffffc0206d96 <proc_init>
ffffffffc020009e:	1b7000ef          	jal	ffffffffc0200a54 <ide_init>
ffffffffc02000a2:	7d5040ef          	jal	ffffffffc0205076 <fs_init>
ffffffffc02000a6:	452000ef          	jal	ffffffffc02004f8 <clock_init>
ffffffffc02000aa:	3c1000ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02000ae:	6bd060ef          	jal	ffffffffc0206f6a <cpu_idle>

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
ffffffffc02000c6:	56650513          	addi	a0,a0,1382 # ffffffffc020b628 <etext+0x2e>
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
ffffffffc020016e:	454000ef          	jal	ffffffffc02005c2 <cons_putc>
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
ffffffffc020019a:	75d0a0ef          	jal	ffffffffc020b0f6 <vprintfmt>
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
ffffffffc02001d4:	7230a0ef          	jal	ffffffffc020b0f6 <vprintfmt>
ffffffffc02001d8:	60e2                	ld	ra,24(sp)
ffffffffc02001da:	4512                	lw	a0,4(sp)
ffffffffc02001dc:	6125                	addi	sp,sp,96
ffffffffc02001de:	8082                	ret

ffffffffc02001e0 <cputchar>:
ffffffffc02001e0:	a6cd                	j	ffffffffc02005c2 <cons_putc>

ffffffffc02001e2 <getchar>:
ffffffffc02001e2:	1141                	addi	sp,sp,-16
ffffffffc02001e4:	e406                	sd	ra,8(sp)
ffffffffc02001e6:	444000ef          	jal	ffffffffc020062a <cons_getc>
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
ffffffffc02001fc:	2e20b0ef          	jal	ffffffffc020b4de <strlen>
ffffffffc0200200:	842a                	mv	s0,a0
ffffffffc0200202:	0505                	addi	a0,a0,1
ffffffffc0200204:	64d010ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc0200208:	87aa                	mv	a5,a0
ffffffffc020020a:	c911                	beqz	a0,ffffffffc020021e <strdup+0x2c>
ffffffffc020020c:	8622                	mv	a2,s0
ffffffffc020020e:	85a6                	mv	a1,s1
ffffffffc0200210:	e42a                	sd	a0,8(sp)
ffffffffc0200212:	3d00b0ef          	jal	ffffffffc020b5e2 <memcpy>
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
ffffffffc0200230:	40450513          	addi	a0,a0,1028 # ffffffffc020b630 <etext+0x36>
ffffffffc0200234:	e406                	sd	ra,8(sp)
ffffffffc0200236:	f71ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020023a:	00000597          	auipc	a1,0x0
ffffffffc020023e:	e1058593          	addi	a1,a1,-496 # ffffffffc020004a <kern_init>
ffffffffc0200242:	0000b517          	auipc	a0,0xb
ffffffffc0200246:	40e50513          	addi	a0,a0,1038 # ffffffffc020b650 <etext+0x56>
ffffffffc020024a:	f5dff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020024e:	0000b597          	auipc	a1,0xb
ffffffffc0200252:	3ac58593          	addi	a1,a1,940 # ffffffffc020b5fa <etext>
ffffffffc0200256:	0000b517          	auipc	a0,0xb
ffffffffc020025a:	41a50513          	addi	a0,a0,1050 # ffffffffc020b670 <etext+0x76>
ffffffffc020025e:	f49ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200262:	00091597          	auipc	a1,0x91
ffffffffc0200266:	dfe58593          	addi	a1,a1,-514 # ffffffffc0291060 <buf>
ffffffffc020026a:	0000b517          	auipc	a0,0xb
ffffffffc020026e:	42650513          	addi	a0,a0,1062 # ffffffffc020b690 <etext+0x96>
ffffffffc0200272:	f35ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200276:	00096597          	auipc	a1,0x96
ffffffffc020027a:	69a58593          	addi	a1,a1,1690 # ffffffffc0296910 <end>
ffffffffc020027e:	0000b517          	auipc	a0,0xb
ffffffffc0200282:	43250513          	addi	a0,a0,1074 # ffffffffc020b6b0 <etext+0xb6>
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
ffffffffc02002ae:	42650513          	addi	a0,a0,1062 # ffffffffc020b6d0 <etext+0xd6>
ffffffffc02002b2:	0141                	addi	sp,sp,16
ffffffffc02002b4:	bdcd                	j	ffffffffc02001a6 <cprintf>

ffffffffc02002b6 <print_stackframe>:
ffffffffc02002b6:	1141                	addi	sp,sp,-16
ffffffffc02002b8:	0000b617          	auipc	a2,0xb
ffffffffc02002bc:	44860613          	addi	a2,a2,1096 # ffffffffc020b700 <etext+0x106>
ffffffffc02002c0:	04e00593          	li	a1,78
ffffffffc02002c4:	0000b517          	auipc	a0,0xb
ffffffffc02002c8:	45450513          	addi	a0,a0,1108 # ffffffffc020b718 <etext+0x11e>
ffffffffc02002cc:	e406                	sd	ra,8(sp)
ffffffffc02002ce:	17c000ef          	jal	ffffffffc020044a <__panic>

ffffffffc02002d2 <mon_help>:
ffffffffc02002d2:	1101                	addi	sp,sp,-32
ffffffffc02002d4:	e822                	sd	s0,16(sp)
ffffffffc02002d6:	e426                	sd	s1,8(sp)
ffffffffc02002d8:	ec06                	sd	ra,24(sp)
ffffffffc02002da:	0000f417          	auipc	s0,0xf
ffffffffc02002de:	88e40413          	addi	s0,s0,-1906 # ffffffffc020eb68 <commands>
ffffffffc02002e2:	0000f497          	auipc	s1,0xf
ffffffffc02002e6:	8ce48493          	addi	s1,s1,-1842 # ffffffffc020ebb0 <commands+0x48>
ffffffffc02002ea:	6410                	ld	a2,8(s0)
ffffffffc02002ec:	600c                	ld	a1,0(s0)
ffffffffc02002ee:	0000b517          	auipc	a0,0xb
ffffffffc02002f2:	44250513          	addi	a0,a0,1090 # ffffffffc020b730 <etext+0x136>
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
ffffffffc0200336:	40e50513          	addi	a0,a0,1038 # ffffffffc020b740 <etext+0x146>
ffffffffc020033a:	fd06                	sd	ra,184(sp)
ffffffffc020033c:	f922                	sd	s0,176(sp)
ffffffffc020033e:	f526                	sd	s1,168(sp)
ffffffffc0200340:	ed4e                	sd	s3,152(sp)
ffffffffc0200342:	e556                	sd	s5,136(sp)
ffffffffc0200344:	e15a                	sd	s6,128(sp)
ffffffffc0200346:	e61ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020034a:	0000b517          	auipc	a0,0xb
ffffffffc020034e:	41e50513          	addi	a0,a0,1054 # ffffffffc020b768 <etext+0x16e>
ffffffffc0200352:	e55ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200356:	000a0563          	beqz	s4,ffffffffc0200360 <kmonitor+0x34>
ffffffffc020035a:	8552                	mv	a0,s4
ffffffffc020035c:	429000ef          	jal	ffffffffc0200f84 <print_trapframe>
ffffffffc0200360:	0000fa97          	auipc	s5,0xf
ffffffffc0200364:	808a8a93          	addi	s5,s5,-2040 # ffffffffc020eb68 <commands>
ffffffffc0200368:	49bd                	li	s3,15
ffffffffc020036a:	0000b517          	auipc	a0,0xb
ffffffffc020036e:	42650513          	addi	a0,a0,1062 # ffffffffc020b790 <etext+0x196>
ffffffffc0200372:	d41ff0ef          	jal	ffffffffc02000b2 <readline>
ffffffffc0200376:	842a                	mv	s0,a0
ffffffffc0200378:	d96d                	beqz	a0,ffffffffc020036a <kmonitor+0x3e>
ffffffffc020037a:	00054583          	lbu	a1,0(a0)
ffffffffc020037e:	4481                	li	s1,0
ffffffffc0200380:	e99d                	bnez	a1,ffffffffc02003b6 <kmonitor+0x8a>
ffffffffc0200382:	8b26                	mv	s6,s1
ffffffffc0200384:	fe0b03e3          	beqz	s6,ffffffffc020036a <kmonitor+0x3e>
ffffffffc0200388:	0000e497          	auipc	s1,0xe
ffffffffc020038c:	7e048493          	addi	s1,s1,2016 # ffffffffc020eb68 <commands>
ffffffffc0200390:	4401                	li	s0,0
ffffffffc0200392:	6582                	ld	a1,0(sp)
ffffffffc0200394:	6088                	ld	a0,0(s1)
ffffffffc0200396:	18e0b0ef          	jal	ffffffffc020b524 <strcmp>
ffffffffc020039a:	478d                	li	a5,3
ffffffffc020039c:	c149                	beqz	a0,ffffffffc020041e <kmonitor+0xf2>
ffffffffc020039e:	2405                	addiw	s0,s0,1
ffffffffc02003a0:	04e1                	addi	s1,s1,24
ffffffffc02003a2:	fef418e3          	bne	s0,a5,ffffffffc0200392 <kmonitor+0x66>
ffffffffc02003a6:	6582                	ld	a1,0(sp)
ffffffffc02003a8:	0000b517          	auipc	a0,0xb
ffffffffc02003ac:	41850513          	addi	a0,a0,1048 # ffffffffc020b7c0 <etext+0x1c6>
ffffffffc02003b0:	df7ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02003b4:	bf5d                	j	ffffffffc020036a <kmonitor+0x3e>
ffffffffc02003b6:	0000b517          	auipc	a0,0xb
ffffffffc02003ba:	3e250513          	addi	a0,a0,994 # ffffffffc020b798 <etext+0x19e>
ffffffffc02003be:	1c20b0ef          	jal	ffffffffc020b580 <strchr>
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
ffffffffc02003fc:	3a050513          	addi	a0,a0,928 # ffffffffc020b798 <etext+0x19e>
ffffffffc0200400:	1800b0ef          	jal	ffffffffc020b580 <strchr>
ffffffffc0200404:	d575                	beqz	a0,ffffffffc02003f0 <kmonitor+0xc4>
ffffffffc0200406:	00044583          	lbu	a1,0(s0)
ffffffffc020040a:	dda5                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc020040c:	b76d                	j	ffffffffc02003b6 <kmonitor+0x8a>
ffffffffc020040e:	45c1                	li	a1,16
ffffffffc0200410:	0000b517          	auipc	a0,0xb
ffffffffc0200414:	39050513          	addi	a0,a0,912 # ffffffffc020b7a0 <etext+0x1a6>
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
ffffffffc0200474:	3f850513          	addi	a0,a0,1016 # ffffffffc020b868 <etext+0x26e>
ffffffffc0200478:	00096697          	auipc	a3,0x96
ffffffffc020047c:	3ee6b823          	sd	a4,1008(a3) # ffffffffc0296868 <is_panic>
ffffffffc0200480:	e43e                	sd	a5,8(sp)
ffffffffc0200482:	d25ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200486:	65a2                	ld	a1,8(sp)
ffffffffc0200488:	8522                	mv	a0,s0
ffffffffc020048a:	cf7ff0ef          	jal	ffffffffc0200180 <vcprintf>
ffffffffc020048e:	0000b517          	auipc	a0,0xb
ffffffffc0200492:	3fa50513          	addi	a0,a0,1018 # ffffffffc020b888 <etext+0x28e>
ffffffffc0200496:	d11ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020049a:	6442                	ld	s0,16(sp)
ffffffffc020049c:	4501                	li	a0,0
ffffffffc020049e:	4581                	li	a1,0
ffffffffc02004a0:	4601                	li	a2,0
ffffffffc02004a2:	48a1                	li	a7,8
ffffffffc02004a4:	00000073          	ecall
ffffffffc02004a8:	7c8000ef          	jal	ffffffffc0200c70 <intr_disable>
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
ffffffffc02004c6:	3ce50513          	addi	a0,a0,974 # ffffffffc020b890 <etext+0x296>
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
ffffffffc02004e8:	3a450513          	addi	a0,a0,932 # ffffffffc020b888 <etext+0x28e>
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
ffffffffc020051a:	39a50513          	addi	a0,a0,922 # ffffffffc020b8b0 <etext+0x2b6>
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

ffffffffc0200540 <serial_intr>:
ffffffffc0200540:	1141                	addi	sp,sp,-16
ffffffffc0200542:	e022                	sd	s0,0(sp)
ffffffffc0200544:	e406                	sd	ra,8(sp)
ffffffffc0200546:	07f00413          	li	s0,127
ffffffffc020054a:	4501                	li	a0,0
ffffffffc020054c:	4581                	li	a1,0
ffffffffc020054e:	4601                	li	a2,0
ffffffffc0200550:	4889                	li	a7,2
ffffffffc0200552:	00000073          	ecall
ffffffffc0200556:	0005079b          	sext.w	a5,a0
ffffffffc020055a:	0407c963          	bltz	a5,ffffffffc02005ac <serial_intr+0x6c>
ffffffffc020055e:	04878563          	beq	a5,s0,ffffffffc02005a8 <serial_intr+0x68>
ffffffffc0200562:	0ff57513          	zext.b	a0,a0
ffffffffc0200566:	d3f5                	beqz	a5,ffffffffc020054a <serial_intr+0xa>
ffffffffc0200568:	00091717          	auipc	a4,0x91
ffffffffc020056c:	0fc72703          	lw	a4,252(a4) # ffffffffc0291664 <cons+0x204>
ffffffffc0200570:	00091797          	auipc	a5,0x91
ffffffffc0200574:	ef078793          	addi	a5,a5,-272 # ffffffffc0291460 <cons>
ffffffffc0200578:	02071693          	slli	a3,a4,0x20
ffffffffc020057c:	9281                	srli	a3,a3,0x20
ffffffffc020057e:	2705                	addiw	a4,a4,1
ffffffffc0200580:	20e7a223          	sw	a4,516(a5)
ffffffffc0200584:	97b6                	add	a5,a5,a3
ffffffffc0200586:	00a78023          	sb	a0,0(a5)
ffffffffc020058a:	680080ef          	jal	ffffffffc0208c0a <dev_stdin_write>
ffffffffc020058e:	00091717          	auipc	a4,0x91
ffffffffc0200592:	0d672703          	lw	a4,214(a4) # ffffffffc0291664 <cons+0x204>
ffffffffc0200596:	20000793          	li	a5,512
ffffffffc020059a:	faf718e3          	bne	a4,a5,ffffffffc020054a <serial_intr+0xa>
ffffffffc020059e:	00091797          	auipc	a5,0x91
ffffffffc02005a2:	0c07a323          	sw	zero,198(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc02005a6:	b755                	j	ffffffffc020054a <serial_intr+0xa>
ffffffffc02005a8:	4521                	li	a0,8
ffffffffc02005aa:	bf7d                	j	ffffffffc0200568 <serial_intr+0x28>
ffffffffc02005ac:	60a2                	ld	ra,8(sp)
ffffffffc02005ae:	6402                	ld	s0,0(sp)
ffffffffc02005b0:	0141                	addi	sp,sp,16
ffffffffc02005b2:	8082                	ret

ffffffffc02005b4 <cons_init>:
ffffffffc02005b4:	4501                	li	a0,0
ffffffffc02005b6:	4581                	li	a1,0
ffffffffc02005b8:	4601                	li	a2,0
ffffffffc02005ba:	4889                	li	a7,2
ffffffffc02005bc:	00000073          	ecall
ffffffffc02005c0:	8082                	ret

ffffffffc02005c2 <cons_putc>:
ffffffffc02005c2:	1101                	addi	sp,sp,-32
ffffffffc02005c4:	ec06                	sd	ra,24(sp)
ffffffffc02005c6:	100027f3          	csrr	a5,sstatus
ffffffffc02005ca:	8b89                	andi	a5,a5,2
ffffffffc02005cc:	ef95                	bnez	a5,ffffffffc0200608 <cons_putc+0x46>
ffffffffc02005ce:	47a1                	li	a5,8
ffffffffc02005d0:	00f50a63          	beq	a0,a5,ffffffffc02005e4 <cons_putc+0x22>
ffffffffc02005d4:	4581                	li	a1,0
ffffffffc02005d6:	4601                	li	a2,0
ffffffffc02005d8:	4885                	li	a7,1
ffffffffc02005da:	00000073          	ecall
ffffffffc02005de:	60e2                	ld	ra,24(sp)
ffffffffc02005e0:	6105                	addi	sp,sp,32
ffffffffc02005e2:	8082                	ret
ffffffffc02005e4:	4781                	li	a5,0
ffffffffc02005e6:	4521                	li	a0,8
ffffffffc02005e8:	4581                	li	a1,0
ffffffffc02005ea:	4601                	li	a2,0
ffffffffc02005ec:	4885                	li	a7,1
ffffffffc02005ee:	00000073          	ecall
ffffffffc02005f2:	02000513          	li	a0,32
ffffffffc02005f6:	00000073          	ecall
ffffffffc02005fa:	4521                	li	a0,8
ffffffffc02005fc:	00000073          	ecall
ffffffffc0200600:	dff9                	beqz	a5,ffffffffc02005de <cons_putc+0x1c>
ffffffffc0200602:	60e2                	ld	ra,24(sp)
ffffffffc0200604:	6105                	addi	sp,sp,32
ffffffffc0200606:	a595                	j	ffffffffc0200c6a <intr_enable>
ffffffffc0200608:	e42a                	sd	a0,8(sp)
ffffffffc020060a:	666000ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc020060e:	6522                	ld	a0,8(sp)
ffffffffc0200610:	47a1                	li	a5,8
ffffffffc0200612:	00f50a63          	beq	a0,a5,ffffffffc0200626 <cons_putc+0x64>
ffffffffc0200616:	4581                	li	a1,0
ffffffffc0200618:	4601                	li	a2,0
ffffffffc020061a:	4885                	li	a7,1
ffffffffc020061c:	00000073          	ecall
ffffffffc0200620:	60e2                	ld	ra,24(sp)
ffffffffc0200622:	6105                	addi	sp,sp,32
ffffffffc0200624:	a599                	j	ffffffffc0200c6a <intr_enable>
ffffffffc0200626:	4785                	li	a5,1
ffffffffc0200628:	bf7d                	j	ffffffffc02005e6 <cons_putc+0x24>

ffffffffc020062a <cons_getc>:
ffffffffc020062a:	7179                	addi	sp,sp,-48
ffffffffc020062c:	f406                	sd	ra,40(sp)
ffffffffc020062e:	f022                	sd	s0,32(sp)
ffffffffc0200630:	ec26                	sd	s1,24(sp)
ffffffffc0200632:	e84a                	sd	s2,16(sp)
ffffffffc0200634:	100027f3          	csrr	a5,sstatus
ffffffffc0200638:	8b89                	andi	a5,a5,2
ffffffffc020063a:	4901                	li	s2,0
ffffffffc020063c:	e7e9                	bnez	a5,ffffffffc0200706 <cons_getc+0xdc>
ffffffffc020063e:	00091497          	auipc	s1,0x91
ffffffffc0200642:	e2248493          	addi	s1,s1,-478 # ffffffffc0291460 <cons>
ffffffffc0200646:	07f00413          	li	s0,127
ffffffffc020064a:	4501                	li	a0,0
ffffffffc020064c:	4581                	li	a1,0
ffffffffc020064e:	4601                	li	a2,0
ffffffffc0200650:	4889                	li	a7,2
ffffffffc0200652:	00000073          	ecall
ffffffffc0200656:	0005079b          	sext.w	a5,a0
ffffffffc020065a:	0407c663          	bltz	a5,ffffffffc02006a6 <cons_getc+0x7c>
ffffffffc020065e:	04878263          	beq	a5,s0,ffffffffc02006a2 <cons_getc+0x78>
ffffffffc0200662:	0ff57513          	zext.b	a0,a0
ffffffffc0200666:	d3f5                	beqz	a5,ffffffffc020064a <cons_getc+0x20>
ffffffffc0200668:	00091797          	auipc	a5,0x91
ffffffffc020066c:	ffc7a783          	lw	a5,-4(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc0200670:	02079713          	slli	a4,a5,0x20
ffffffffc0200674:	9301                	srli	a4,a4,0x20
ffffffffc0200676:	2785                	addiw	a5,a5,1
ffffffffc0200678:	20f4a223          	sw	a5,516(s1)
ffffffffc020067c:	00e487b3          	add	a5,s1,a4
ffffffffc0200680:	00a78023          	sb	a0,0(a5)
ffffffffc0200684:	586080ef          	jal	ffffffffc0208c0a <dev_stdin_write>
ffffffffc0200688:	00091717          	auipc	a4,0x91
ffffffffc020068c:	fdc72703          	lw	a4,-36(a4) # ffffffffc0291664 <cons+0x204>
ffffffffc0200690:	20000793          	li	a5,512
ffffffffc0200694:	faf71be3          	bne	a4,a5,ffffffffc020064a <cons_getc+0x20>
ffffffffc0200698:	00091797          	auipc	a5,0x91
ffffffffc020069c:	fc07a623          	sw	zero,-52(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc02006a0:	b76d                	j	ffffffffc020064a <cons_getc+0x20>
ffffffffc02006a2:	4521                	li	a0,8
ffffffffc02006a4:	b7d1                	j	ffffffffc0200668 <cons_getc+0x3e>
ffffffffc02006a6:	00091797          	auipc	a5,0x91
ffffffffc02006aa:	fba7a783          	lw	a5,-70(a5) # ffffffffc0291660 <cons+0x200>
ffffffffc02006ae:	00091717          	auipc	a4,0x91
ffffffffc02006b2:	fb672703          	lw	a4,-74(a4) # ffffffffc0291664 <cons+0x204>
ffffffffc02006b6:	4501                	li	a0,0
ffffffffc02006b8:	00f70f63          	beq	a4,a5,ffffffffc02006d6 <cons_getc+0xac>
ffffffffc02006bc:	02079713          	slli	a4,a5,0x20
ffffffffc02006c0:	9301                	srli	a4,a4,0x20
ffffffffc02006c2:	2785                	addiw	a5,a5,1
ffffffffc02006c4:	20f4a023          	sw	a5,512(s1)
ffffffffc02006c8:	94ba                	add	s1,s1,a4
ffffffffc02006ca:	20000713          	li	a4,512
ffffffffc02006ce:	0004c503          	lbu	a0,0(s1)
ffffffffc02006d2:	00e78a63          	beq	a5,a4,ffffffffc02006e6 <cons_getc+0xbc>
ffffffffc02006d6:	00091e63          	bnez	s2,ffffffffc02006f2 <cons_getc+0xc8>
ffffffffc02006da:	70a2                	ld	ra,40(sp)
ffffffffc02006dc:	7402                	ld	s0,32(sp)
ffffffffc02006de:	64e2                	ld	s1,24(sp)
ffffffffc02006e0:	6942                	ld	s2,16(sp)
ffffffffc02006e2:	6145                	addi	sp,sp,48
ffffffffc02006e4:	8082                	ret
ffffffffc02006e6:	00091797          	auipc	a5,0x91
ffffffffc02006ea:	f607ad23          	sw	zero,-134(a5) # ffffffffc0291660 <cons+0x200>
ffffffffc02006ee:	fe0906e3          	beqz	s2,ffffffffc02006da <cons_getc+0xb0>
ffffffffc02006f2:	e42a                	sd	a0,8(sp)
ffffffffc02006f4:	576000ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02006f8:	70a2                	ld	ra,40(sp)
ffffffffc02006fa:	7402                	ld	s0,32(sp)
ffffffffc02006fc:	6522                	ld	a0,8(sp)
ffffffffc02006fe:	64e2                	ld	s1,24(sp)
ffffffffc0200700:	6942                	ld	s2,16(sp)
ffffffffc0200702:	6145                	addi	sp,sp,48
ffffffffc0200704:	8082                	ret
ffffffffc0200706:	56a000ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc020070a:	4905                	li	s2,1
ffffffffc020070c:	bf0d                	j	ffffffffc020063e <cons_getc+0x14>

ffffffffc020070e <dtb_init>:
ffffffffc020070e:	7179                	addi	sp,sp,-48
ffffffffc0200710:	0000b517          	auipc	a0,0xb
ffffffffc0200714:	1c050513          	addi	a0,a0,448 # ffffffffc020b8d0 <etext+0x2d6>
ffffffffc0200718:	f406                	sd	ra,40(sp)
ffffffffc020071a:	f022                	sd	s0,32(sp)
ffffffffc020071c:	a8bff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200720:	00014597          	auipc	a1,0x14
ffffffffc0200724:	8e05b583          	ld	a1,-1824(a1) # ffffffffc0214000 <boot_hartid>
ffffffffc0200728:	0000b517          	auipc	a0,0xb
ffffffffc020072c:	1b850513          	addi	a0,a0,440 # ffffffffc020b8e0 <etext+0x2e6>
ffffffffc0200730:	00014417          	auipc	s0,0x14
ffffffffc0200734:	8d840413          	addi	s0,s0,-1832 # ffffffffc0214008 <boot_dtb>
ffffffffc0200738:	a6fff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020073c:	600c                	ld	a1,0(s0)
ffffffffc020073e:	0000b517          	auipc	a0,0xb
ffffffffc0200742:	1b250513          	addi	a0,a0,434 # ffffffffc020b8f0 <etext+0x2f6>
ffffffffc0200746:	a61ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020074a:	6018                	ld	a4,0(s0)
ffffffffc020074c:	0000b517          	auipc	a0,0xb
ffffffffc0200750:	1bc50513          	addi	a0,a0,444 # ffffffffc020b908 <etext+0x30e>
ffffffffc0200754:	10070163          	beqz	a4,ffffffffc0200856 <dtb_init+0x148>
ffffffffc0200758:	57f5                	li	a5,-3
ffffffffc020075a:	07fa                	slli	a5,a5,0x1e
ffffffffc020075c:	973e                	add	a4,a4,a5
ffffffffc020075e:	431c                	lw	a5,0(a4)
ffffffffc0200760:	d00e06b7          	lui	a3,0xd00e0
ffffffffc0200764:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfe495dd>
ffffffffc0200768:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020076c:	0187961b          	slliw	a2,a5,0x18
ffffffffc0200770:	0187d51b          	srliw	a0,a5,0x18
ffffffffc0200774:	0ff5f593          	zext.b	a1,a1
ffffffffc0200778:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020077c:	05c2                	slli	a1,a1,0x10
ffffffffc020077e:	8e49                	or	a2,a2,a0
ffffffffc0200780:	0ff7f793          	zext.b	a5,a5
ffffffffc0200784:	8dd1                	or	a1,a1,a2
ffffffffc0200786:	07a2                	slli	a5,a5,0x8
ffffffffc0200788:	8ddd                	or	a1,a1,a5
ffffffffc020078a:	00ff0837          	lui	a6,0xff0
ffffffffc020078e:	0cd59863          	bne	a1,a3,ffffffffc020085e <dtb_init+0x150>
ffffffffc0200792:	4710                	lw	a2,8(a4)
ffffffffc0200794:	4754                	lw	a3,12(a4)
ffffffffc0200796:	e84a                	sd	s2,16(sp)
ffffffffc0200798:	0086541b          	srliw	s0,a2,0x8
ffffffffc020079c:	0086d79b          	srliw	a5,a3,0x8
ffffffffc02007a0:	01865e1b          	srliw	t3,a2,0x18
ffffffffc02007a4:	0186d89b          	srliw	a7,a3,0x18
ffffffffc02007a8:	0186151b          	slliw	a0,a2,0x18
ffffffffc02007ac:	0186959b          	slliw	a1,a3,0x18
ffffffffc02007b0:	0104141b          	slliw	s0,s0,0x10
ffffffffc02007b4:	0106561b          	srliw	a2,a2,0x10
ffffffffc02007b8:	0107979b          	slliw	a5,a5,0x10
ffffffffc02007bc:	0106d69b          	srliw	a3,a3,0x10
ffffffffc02007c0:	01c56533          	or	a0,a0,t3
ffffffffc02007c4:	0115e5b3          	or	a1,a1,a7
ffffffffc02007c8:	01047433          	and	s0,s0,a6
ffffffffc02007cc:	0ff67613          	zext.b	a2,a2
ffffffffc02007d0:	0107f7b3          	and	a5,a5,a6
ffffffffc02007d4:	0ff6f693          	zext.b	a3,a3
ffffffffc02007d8:	8c49                	or	s0,s0,a0
ffffffffc02007da:	0622                	slli	a2,a2,0x8
ffffffffc02007dc:	8fcd                	or	a5,a5,a1
ffffffffc02007de:	06a2                	slli	a3,a3,0x8
ffffffffc02007e0:	8c51                	or	s0,s0,a2
ffffffffc02007e2:	8fd5                	or	a5,a5,a3
ffffffffc02007e4:	1402                	slli	s0,s0,0x20
ffffffffc02007e6:	1782                	slli	a5,a5,0x20
ffffffffc02007e8:	9001                	srli	s0,s0,0x20
ffffffffc02007ea:	9381                	srli	a5,a5,0x20
ffffffffc02007ec:	ec26                	sd	s1,24(sp)
ffffffffc02007ee:	4301                	li	t1,0
ffffffffc02007f0:	488d                	li	a7,3
ffffffffc02007f2:	943a                	add	s0,s0,a4
ffffffffc02007f4:	00e78933          	add	s2,a5,a4
ffffffffc02007f8:	4e05                	li	t3,1
ffffffffc02007fa:	4018                	lw	a4,0(s0)
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
ffffffffc0200820:	05178763          	beq	a5,a7,ffffffffc020086e <dtb_init+0x160>
ffffffffc0200824:	0411                	addi	s0,s0,4
ffffffffc0200826:	00f8e963          	bltu	a7,a5,ffffffffc0200838 <dtb_init+0x12a>
ffffffffc020082a:	07c78d63          	beq	a5,t3,ffffffffc02008a4 <dtb_init+0x196>
ffffffffc020082e:	4709                	li	a4,2
ffffffffc0200830:	00e79763          	bne	a5,a4,ffffffffc020083e <dtb_init+0x130>
ffffffffc0200834:	4301                	li	t1,0
ffffffffc0200836:	b7d1                	j	ffffffffc02007fa <dtb_init+0xec>
ffffffffc0200838:	4711                	li	a4,4
ffffffffc020083a:	fce780e3          	beq	a5,a4,ffffffffc02007fa <dtb_init+0xec>
ffffffffc020083e:	0000b517          	auipc	a0,0xb
ffffffffc0200842:	19250513          	addi	a0,a0,402 # ffffffffc020b9d0 <etext+0x3d6>
ffffffffc0200846:	961ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020084a:	64e2                	ld	s1,24(sp)
ffffffffc020084c:	6942                	ld	s2,16(sp)
ffffffffc020084e:	0000b517          	auipc	a0,0xb
ffffffffc0200852:	1ba50513          	addi	a0,a0,442 # ffffffffc020ba08 <etext+0x40e>
ffffffffc0200856:	7402                	ld	s0,32(sp)
ffffffffc0200858:	70a2                	ld	ra,40(sp)
ffffffffc020085a:	6145                	addi	sp,sp,48
ffffffffc020085c:	b2a9                	j	ffffffffc02001a6 <cprintf>
ffffffffc020085e:	7402                	ld	s0,32(sp)
ffffffffc0200860:	70a2                	ld	ra,40(sp)
ffffffffc0200862:	0000b517          	auipc	a0,0xb
ffffffffc0200866:	0c650513          	addi	a0,a0,198 # ffffffffc020b928 <etext+0x32e>
ffffffffc020086a:	6145                	addi	sp,sp,48
ffffffffc020086c:	ba2d                	j	ffffffffc02001a6 <cprintf>
ffffffffc020086e:	4058                	lw	a4,4(s0)
ffffffffc0200870:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200874:	0187169b          	slliw	a3,a4,0x18
ffffffffc0200878:	0187561b          	srliw	a2,a4,0x18
ffffffffc020087c:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200880:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200884:	0107f7b3          	and	a5,a5,a6
ffffffffc0200888:	8ed1                	or	a3,a3,a2
ffffffffc020088a:	0ff77713          	zext.b	a4,a4
ffffffffc020088e:	8fd5                	or	a5,a5,a3
ffffffffc0200890:	0722                	slli	a4,a4,0x8
ffffffffc0200892:	8fd9                	or	a5,a5,a4
ffffffffc0200894:	04031463          	bnez	t1,ffffffffc02008dc <dtb_init+0x1ce>
ffffffffc0200898:	1782                	slli	a5,a5,0x20
ffffffffc020089a:	9381                	srli	a5,a5,0x20
ffffffffc020089c:	043d                	addi	s0,s0,15
ffffffffc020089e:	943e                	add	s0,s0,a5
ffffffffc02008a0:	9871                	andi	s0,s0,-4
ffffffffc02008a2:	bfa1                	j	ffffffffc02007fa <dtb_init+0xec>
ffffffffc02008a4:	8522                	mv	a0,s0
ffffffffc02008a6:	e01a                	sd	t1,0(sp)
ffffffffc02008a8:	4370a0ef          	jal	ffffffffc020b4de <strlen>
ffffffffc02008ac:	84aa                	mv	s1,a0
ffffffffc02008ae:	4619                	li	a2,6
ffffffffc02008b0:	8522                	mv	a0,s0
ffffffffc02008b2:	0000b597          	auipc	a1,0xb
ffffffffc02008b6:	09e58593          	addi	a1,a1,158 # ffffffffc020b950 <etext+0x356>
ffffffffc02008ba:	49f0a0ef          	jal	ffffffffc020b558 <strncmp>
ffffffffc02008be:	6302                	ld	t1,0(sp)
ffffffffc02008c0:	0411                	addi	s0,s0,4
ffffffffc02008c2:	0004879b          	sext.w	a5,s1
ffffffffc02008c6:	943e                	add	s0,s0,a5
ffffffffc02008c8:	00153513          	seqz	a0,a0
ffffffffc02008cc:	9871                	andi	s0,s0,-4
ffffffffc02008ce:	00a36333          	or	t1,t1,a0
ffffffffc02008d2:	00ff0837          	lui	a6,0xff0
ffffffffc02008d6:	488d                	li	a7,3
ffffffffc02008d8:	4e05                	li	t3,1
ffffffffc02008da:	b705                	j	ffffffffc02007fa <dtb_init+0xec>
ffffffffc02008dc:	4418                	lw	a4,8(s0)
ffffffffc02008de:	0000b597          	auipc	a1,0xb
ffffffffc02008e2:	07a58593          	addi	a1,a1,122 # ffffffffc020b958 <etext+0x35e>
ffffffffc02008e6:	e43e                	sd	a5,8(sp)
ffffffffc02008e8:	0087551b          	srliw	a0,a4,0x8
ffffffffc02008ec:	0187561b          	srliw	a2,a4,0x18
ffffffffc02008f0:	0187169b          	slliw	a3,a4,0x18
ffffffffc02008f4:	0105151b          	slliw	a0,a0,0x10
ffffffffc02008f8:	0107571b          	srliw	a4,a4,0x10
ffffffffc02008fc:	01057533          	and	a0,a0,a6
ffffffffc0200900:	8ed1                	or	a3,a3,a2
ffffffffc0200902:	0ff77713          	zext.b	a4,a4
ffffffffc0200906:	0722                	slli	a4,a4,0x8
ffffffffc0200908:	8d55                	or	a0,a0,a3
ffffffffc020090a:	8d59                	or	a0,a0,a4
ffffffffc020090c:	1502                	slli	a0,a0,0x20
ffffffffc020090e:	9101                	srli	a0,a0,0x20
ffffffffc0200910:	954a                	add	a0,a0,s2
ffffffffc0200912:	e01a                	sd	t1,0(sp)
ffffffffc0200914:	4110a0ef          	jal	ffffffffc020b524 <strcmp>
ffffffffc0200918:	67a2                	ld	a5,8(sp)
ffffffffc020091a:	473d                	li	a4,15
ffffffffc020091c:	6302                	ld	t1,0(sp)
ffffffffc020091e:	00ff0837          	lui	a6,0xff0
ffffffffc0200922:	488d                	li	a7,3
ffffffffc0200924:	4e05                	li	t3,1
ffffffffc0200926:	f6f779e3          	bgeu	a4,a5,ffffffffc0200898 <dtb_init+0x18a>
ffffffffc020092a:	f53d                	bnez	a0,ffffffffc0200898 <dtb_init+0x18a>
ffffffffc020092c:	00c43683          	ld	a3,12(s0)
ffffffffc0200930:	01443703          	ld	a4,20(s0)
ffffffffc0200934:	0000b517          	auipc	a0,0xb
ffffffffc0200938:	02c50513          	addi	a0,a0,44 # ffffffffc020b960 <etext+0x366>
ffffffffc020093c:	4206d793          	srai	a5,a3,0x20
ffffffffc0200940:	0087d31b          	srliw	t1,a5,0x8
ffffffffc0200944:	00871f93          	slli	t6,a4,0x8
ffffffffc0200948:	42075893          	srai	a7,a4,0x20
ffffffffc020094c:	0187df1b          	srliw	t5,a5,0x18
ffffffffc0200950:	0187959b          	slliw	a1,a5,0x18
ffffffffc0200954:	0103131b          	slliw	t1,t1,0x10
ffffffffc0200958:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020095c:	420fd613          	srai	a2,t6,0x20
ffffffffc0200960:	0188de9b          	srliw	t4,a7,0x18
ffffffffc0200964:	01037333          	and	t1,t1,a6
ffffffffc0200968:	01889e1b          	slliw	t3,a7,0x18
ffffffffc020096c:	01e5e5b3          	or	a1,a1,t5
ffffffffc0200970:	0ff7f793          	zext.b	a5,a5
ffffffffc0200974:	01de6e33          	or	t3,t3,t4
ffffffffc0200978:	0065e5b3          	or	a1,a1,t1
ffffffffc020097c:	01067633          	and	a2,a2,a6
ffffffffc0200980:	0086d31b          	srliw	t1,a3,0x8
ffffffffc0200984:	0087541b          	srliw	s0,a4,0x8
ffffffffc0200988:	07a2                	slli	a5,a5,0x8
ffffffffc020098a:	0108d89b          	srliw	a7,a7,0x10
ffffffffc020098e:	0186df1b          	srliw	t5,a3,0x18
ffffffffc0200992:	01875e9b          	srliw	t4,a4,0x18
ffffffffc0200996:	8ddd                	or	a1,a1,a5
ffffffffc0200998:	01c66633          	or	a2,a2,t3
ffffffffc020099c:	0186979b          	slliw	a5,a3,0x18
ffffffffc02009a0:	01871e1b          	slliw	t3,a4,0x18
ffffffffc02009a4:	0ff8f893          	zext.b	a7,a7
ffffffffc02009a8:	0103131b          	slliw	t1,t1,0x10
ffffffffc02009ac:	0106d69b          	srliw	a3,a3,0x10
ffffffffc02009b0:	0104141b          	slliw	s0,s0,0x10
ffffffffc02009b4:	0107571b          	srliw	a4,a4,0x10
ffffffffc02009b8:	01037333          	and	t1,t1,a6
ffffffffc02009bc:	08a2                	slli	a7,a7,0x8
ffffffffc02009be:	01e7e7b3          	or	a5,a5,t5
ffffffffc02009c2:	01047433          	and	s0,s0,a6
ffffffffc02009c6:	0ff6f693          	zext.b	a3,a3
ffffffffc02009ca:	01de6833          	or	a6,t3,t4
ffffffffc02009ce:	0ff77713          	zext.b	a4,a4
ffffffffc02009d2:	01166633          	or	a2,a2,a7
ffffffffc02009d6:	0067e7b3          	or	a5,a5,t1
ffffffffc02009da:	06a2                	slli	a3,a3,0x8
ffffffffc02009dc:	01046433          	or	s0,s0,a6
ffffffffc02009e0:	0722                	slli	a4,a4,0x8
ffffffffc02009e2:	8fd5                	or	a5,a5,a3
ffffffffc02009e4:	8c59                	or	s0,s0,a4
ffffffffc02009e6:	1582                	slli	a1,a1,0x20
ffffffffc02009e8:	1602                	slli	a2,a2,0x20
ffffffffc02009ea:	1782                	slli	a5,a5,0x20
ffffffffc02009ec:	9201                	srli	a2,a2,0x20
ffffffffc02009ee:	9181                	srli	a1,a1,0x20
ffffffffc02009f0:	1402                	slli	s0,s0,0x20
ffffffffc02009f2:	00b7e4b3          	or	s1,a5,a1
ffffffffc02009f6:	8c51                	or	s0,s0,a2
ffffffffc02009f8:	faeff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02009fc:	85a6                	mv	a1,s1
ffffffffc02009fe:	0000b517          	auipc	a0,0xb
ffffffffc0200a02:	f8250513          	addi	a0,a0,-126 # ffffffffc020b980 <etext+0x386>
ffffffffc0200a06:	fa0ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200a0a:	01445613          	srli	a2,s0,0x14
ffffffffc0200a0e:	85a2                	mv	a1,s0
ffffffffc0200a10:	0000b517          	auipc	a0,0xb
ffffffffc0200a14:	f8850513          	addi	a0,a0,-120 # ffffffffc020b998 <etext+0x39e>
ffffffffc0200a18:	f8eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200a1c:	009405b3          	add	a1,s0,s1
ffffffffc0200a20:	15fd                	addi	a1,a1,-1
ffffffffc0200a22:	0000b517          	auipc	a0,0xb
ffffffffc0200a26:	f9650513          	addi	a0,a0,-106 # ffffffffc020b9b8 <etext+0x3be>
ffffffffc0200a2a:	f7cff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200a2e:	00096797          	auipc	a5,0x96
ffffffffc0200a32:	e497b923          	sd	s1,-430(a5) # ffffffffc0296880 <memory_base>
ffffffffc0200a36:	00096797          	auipc	a5,0x96
ffffffffc0200a3a:	e487b123          	sd	s0,-446(a5) # ffffffffc0296878 <memory_size>
ffffffffc0200a3e:	b531                	j	ffffffffc020084a <dtb_init+0x13c>

ffffffffc0200a40 <get_memory_base>:
ffffffffc0200a40:	00096517          	auipc	a0,0x96
ffffffffc0200a44:	e4053503          	ld	a0,-448(a0) # ffffffffc0296880 <memory_base>
ffffffffc0200a48:	8082                	ret

ffffffffc0200a4a <get_memory_size>:
ffffffffc0200a4a:	00096517          	auipc	a0,0x96
ffffffffc0200a4e:	e2e53503          	ld	a0,-466(a0) # ffffffffc0296878 <memory_size>
ffffffffc0200a52:	8082                	ret

ffffffffc0200a54 <ide_init>:
ffffffffc0200a54:	1141                	addi	sp,sp,-16
ffffffffc0200a56:	00091597          	auipc	a1,0x91
ffffffffc0200a5a:	c6258593          	addi	a1,a1,-926 # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200a5e:	4505                	li	a0,1
ffffffffc0200a60:	00091797          	auipc	a5,0x91
ffffffffc0200a64:	c007a423          	sw	zero,-1016(a5) # ffffffffc0291668 <ide_devices>
ffffffffc0200a68:	00091797          	auipc	a5,0x91
ffffffffc0200a6c:	c407a823          	sw	zero,-944(a5) # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200a70:	00091797          	auipc	a5,0x91
ffffffffc0200a74:	c807ac23          	sw	zero,-872(a5) # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200a78:	00091797          	auipc	a5,0x91
ffffffffc0200a7c:	ce07a023          	sw	zero,-800(a5) # ffffffffc0291758 <ide_devices+0xf0>
ffffffffc0200a80:	e406                	sd	ra,8(sp)
ffffffffc0200a82:	24c000ef          	jal	ffffffffc0200cce <ramdisk_init>
ffffffffc0200a86:	00091797          	auipc	a5,0x91
ffffffffc0200a8a:	c327a783          	lw	a5,-974(a5) # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200a8e:	c385                	beqz	a5,ffffffffc0200aae <ide_init+0x5a>
ffffffffc0200a90:	00091597          	auipc	a1,0x91
ffffffffc0200a94:	c7858593          	addi	a1,a1,-904 # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200a98:	4509                	li	a0,2
ffffffffc0200a9a:	234000ef          	jal	ffffffffc0200cce <ramdisk_init>
ffffffffc0200a9e:	00091797          	auipc	a5,0x91
ffffffffc0200aa2:	c6a7a783          	lw	a5,-918(a5) # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200aa6:	c39d                	beqz	a5,ffffffffc0200acc <ide_init+0x78>
ffffffffc0200aa8:	60a2                	ld	ra,8(sp)
ffffffffc0200aaa:	0141                	addi	sp,sp,16
ffffffffc0200aac:	8082                	ret
ffffffffc0200aae:	0000b697          	auipc	a3,0xb
ffffffffc0200ab2:	f7268693          	addi	a3,a3,-142 # ffffffffc020ba20 <etext+0x426>
ffffffffc0200ab6:	0000b617          	auipc	a2,0xb
ffffffffc0200aba:	f8260613          	addi	a2,a2,-126 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0200abe:	45c5                	li	a1,17
ffffffffc0200ac0:	0000b517          	auipc	a0,0xb
ffffffffc0200ac4:	f9050513          	addi	a0,a0,-112 # ffffffffc020ba50 <etext+0x456>
ffffffffc0200ac8:	983ff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0200acc:	0000b697          	auipc	a3,0xb
ffffffffc0200ad0:	f9c68693          	addi	a3,a3,-100 # ffffffffc020ba68 <etext+0x46e>
ffffffffc0200ad4:	0000b617          	auipc	a2,0xb
ffffffffc0200ad8:	f6460613          	addi	a2,a2,-156 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0200adc:	45d1                	li	a1,20
ffffffffc0200ade:	0000b517          	auipc	a0,0xb
ffffffffc0200ae2:	f7250513          	addi	a0,a0,-142 # ffffffffc020ba50 <etext+0x456>
ffffffffc0200ae6:	965ff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200aea <ide_device_valid>:
ffffffffc0200aea:	478d                	li	a5,3
ffffffffc0200aec:	00a7ef63          	bltu	a5,a0,ffffffffc0200b0a <ide_device_valid+0x20>
ffffffffc0200af0:	00251793          	slli	a5,a0,0x2
ffffffffc0200af4:	97aa                	add	a5,a5,a0
ffffffffc0200af6:	00091717          	auipc	a4,0x91
ffffffffc0200afa:	b7270713          	addi	a4,a4,-1166 # ffffffffc0291668 <ide_devices>
ffffffffc0200afe:	0792                	slli	a5,a5,0x4
ffffffffc0200b00:	97ba                	add	a5,a5,a4
ffffffffc0200b02:	4388                	lw	a0,0(a5)
ffffffffc0200b04:	00a03533          	snez	a0,a0
ffffffffc0200b08:	8082                	ret
ffffffffc0200b0a:	4501                	li	a0,0
ffffffffc0200b0c:	8082                	ret

ffffffffc0200b0e <ide_device_size>:
ffffffffc0200b0e:	478d                	li	a5,3
ffffffffc0200b10:	02a7e163          	bltu	a5,a0,ffffffffc0200b32 <ide_device_size+0x24>
ffffffffc0200b14:	00251793          	slli	a5,a0,0x2
ffffffffc0200b18:	97aa                	add	a5,a5,a0
ffffffffc0200b1a:	00091717          	auipc	a4,0x91
ffffffffc0200b1e:	b4e70713          	addi	a4,a4,-1202 # ffffffffc0291668 <ide_devices>
ffffffffc0200b22:	0792                	slli	a5,a5,0x4
ffffffffc0200b24:	97ba                	add	a5,a5,a4
ffffffffc0200b26:	4398                	lw	a4,0(a5)
ffffffffc0200b28:	4501                	li	a0,0
ffffffffc0200b2a:	c709                	beqz	a4,ffffffffc0200b34 <ide_device_size+0x26>
ffffffffc0200b2c:	0087e503          	lwu	a0,8(a5)
ffffffffc0200b30:	8082                	ret
ffffffffc0200b32:	4501                	li	a0,0
ffffffffc0200b34:	8082                	ret

ffffffffc0200b36 <ide_read_secs>:
ffffffffc0200b36:	1141                	addi	sp,sp,-16
ffffffffc0200b38:	e406                	sd	ra,8(sp)
ffffffffc0200b3a:	0816b793          	sltiu	a5,a3,129
ffffffffc0200b3e:	cba9                	beqz	a5,ffffffffc0200b90 <ide_read_secs+0x5a>
ffffffffc0200b40:	478d                	li	a5,3
ffffffffc0200b42:	0005081b          	sext.w	a6,a0
ffffffffc0200b46:	04a7e563          	bltu	a5,a0,ffffffffc0200b90 <ide_read_secs+0x5a>
ffffffffc0200b4a:	00281793          	slli	a5,a6,0x2
ffffffffc0200b4e:	97c2                	add	a5,a5,a6
ffffffffc0200b50:	0792                	slli	a5,a5,0x4
ffffffffc0200b52:	00091817          	auipc	a6,0x91
ffffffffc0200b56:	b1680813          	addi	a6,a6,-1258 # ffffffffc0291668 <ide_devices>
ffffffffc0200b5a:	97c2                	add	a5,a5,a6
ffffffffc0200b5c:	0007a883          	lw	a7,0(a5)
ffffffffc0200b60:	02088863          	beqz	a7,ffffffffc0200b90 <ide_read_secs+0x5a>
ffffffffc0200b64:	100008b7          	lui	a7,0x10000
ffffffffc0200b68:	0515f463          	bgeu	a1,a7,ffffffffc0200bb0 <ide_read_secs+0x7a>
ffffffffc0200b6c:	1582                	slli	a1,a1,0x20
ffffffffc0200b6e:	9181                	srli	a1,a1,0x20
ffffffffc0200b70:	00d58733          	add	a4,a1,a3
ffffffffc0200b74:	02e8ee63          	bltu	a7,a4,ffffffffc0200bb0 <ide_read_secs+0x7a>
ffffffffc0200b78:	00251713          	slli	a4,a0,0x2
ffffffffc0200b7c:	0407b883          	ld	a7,64(a5)
ffffffffc0200b80:	60a2                	ld	ra,8(sp)
ffffffffc0200b82:	00a707b3          	add	a5,a4,a0
ffffffffc0200b86:	0792                	slli	a5,a5,0x4
ffffffffc0200b88:	00f80533          	add	a0,a6,a5
ffffffffc0200b8c:	0141                	addi	sp,sp,16
ffffffffc0200b8e:	8882                	jr	a7
ffffffffc0200b90:	0000b697          	auipc	a3,0xb
ffffffffc0200b94:	ef068693          	addi	a3,a3,-272 # ffffffffc020ba80 <etext+0x486>
ffffffffc0200b98:	0000b617          	auipc	a2,0xb
ffffffffc0200b9c:	ea060613          	addi	a2,a2,-352 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0200ba0:	02200593          	li	a1,34
ffffffffc0200ba4:	0000b517          	auipc	a0,0xb
ffffffffc0200ba8:	eac50513          	addi	a0,a0,-340 # ffffffffc020ba50 <etext+0x456>
ffffffffc0200bac:	89fff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0200bb0:	0000b697          	auipc	a3,0xb
ffffffffc0200bb4:	ef868693          	addi	a3,a3,-264 # ffffffffc020baa8 <etext+0x4ae>
ffffffffc0200bb8:	0000b617          	auipc	a2,0xb
ffffffffc0200bbc:	e8060613          	addi	a2,a2,-384 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0200bc0:	02300593          	li	a1,35
ffffffffc0200bc4:	0000b517          	auipc	a0,0xb
ffffffffc0200bc8:	e8c50513          	addi	a0,a0,-372 # ffffffffc020ba50 <etext+0x456>
ffffffffc0200bcc:	87fff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200bd0 <ide_write_secs>:
ffffffffc0200bd0:	1141                	addi	sp,sp,-16
ffffffffc0200bd2:	e406                	sd	ra,8(sp)
ffffffffc0200bd4:	0816b793          	sltiu	a5,a3,129
ffffffffc0200bd8:	cba9                	beqz	a5,ffffffffc0200c2a <ide_write_secs+0x5a>
ffffffffc0200bda:	478d                	li	a5,3
ffffffffc0200bdc:	0005081b          	sext.w	a6,a0
ffffffffc0200be0:	04a7e563          	bltu	a5,a0,ffffffffc0200c2a <ide_write_secs+0x5a>
ffffffffc0200be4:	00281793          	slli	a5,a6,0x2
ffffffffc0200be8:	97c2                	add	a5,a5,a6
ffffffffc0200bea:	0792                	slli	a5,a5,0x4
ffffffffc0200bec:	00091817          	auipc	a6,0x91
ffffffffc0200bf0:	a7c80813          	addi	a6,a6,-1412 # ffffffffc0291668 <ide_devices>
ffffffffc0200bf4:	97c2                	add	a5,a5,a6
ffffffffc0200bf6:	0007a883          	lw	a7,0(a5)
ffffffffc0200bfa:	02088863          	beqz	a7,ffffffffc0200c2a <ide_write_secs+0x5a>
ffffffffc0200bfe:	100008b7          	lui	a7,0x10000
ffffffffc0200c02:	0515f463          	bgeu	a1,a7,ffffffffc0200c4a <ide_write_secs+0x7a>
ffffffffc0200c06:	1582                	slli	a1,a1,0x20
ffffffffc0200c08:	9181                	srli	a1,a1,0x20
ffffffffc0200c0a:	00d58733          	add	a4,a1,a3
ffffffffc0200c0e:	02e8ee63          	bltu	a7,a4,ffffffffc0200c4a <ide_write_secs+0x7a>
ffffffffc0200c12:	00251713          	slli	a4,a0,0x2
ffffffffc0200c16:	0487b883          	ld	a7,72(a5)
ffffffffc0200c1a:	60a2                	ld	ra,8(sp)
ffffffffc0200c1c:	00a707b3          	add	a5,a4,a0
ffffffffc0200c20:	0792                	slli	a5,a5,0x4
ffffffffc0200c22:	00f80533          	add	a0,a6,a5
ffffffffc0200c26:	0141                	addi	sp,sp,16
ffffffffc0200c28:	8882                	jr	a7
ffffffffc0200c2a:	0000b697          	auipc	a3,0xb
ffffffffc0200c2e:	e5668693          	addi	a3,a3,-426 # ffffffffc020ba80 <etext+0x486>
ffffffffc0200c32:	0000b617          	auipc	a2,0xb
ffffffffc0200c36:	e0660613          	addi	a2,a2,-506 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0200c3a:	02900593          	li	a1,41
ffffffffc0200c3e:	0000b517          	auipc	a0,0xb
ffffffffc0200c42:	e1250513          	addi	a0,a0,-494 # ffffffffc020ba50 <etext+0x456>
ffffffffc0200c46:	805ff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0200c4a:	0000b697          	auipc	a3,0xb
ffffffffc0200c4e:	e5e68693          	addi	a3,a3,-418 # ffffffffc020baa8 <etext+0x4ae>
ffffffffc0200c52:	0000b617          	auipc	a2,0xb
ffffffffc0200c56:	de660613          	addi	a2,a2,-538 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0200c5a:	02a00593          	li	a1,42
ffffffffc0200c5e:	0000b517          	auipc	a0,0xb
ffffffffc0200c62:	df250513          	addi	a0,a0,-526 # ffffffffc020ba50 <etext+0x456>
ffffffffc0200c66:	fe4ff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200c6a <intr_enable>:
ffffffffc0200c6a:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200c6e:	8082                	ret

ffffffffc0200c70 <intr_disable>:
ffffffffc0200c70:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200c74:	8082                	ret

ffffffffc0200c76 <pic_init>:
ffffffffc0200c76:	8082                	ret

ffffffffc0200c78 <ramdisk_write>:
ffffffffc0200c78:	00856783          	lwu	a5,8(a0)
ffffffffc0200c7c:	1141                	addi	sp,sp,-16
ffffffffc0200c7e:	e406                	sd	ra,8(sp)
ffffffffc0200c80:	8f8d                	sub	a5,a5,a1
ffffffffc0200c82:	8732                	mv	a4,a2
ffffffffc0200c84:	00f6f363          	bgeu	a3,a5,ffffffffc0200c8a <ramdisk_write+0x12>
ffffffffc0200c88:	87b6                	mv	a5,a3
ffffffffc0200c8a:	6914                	ld	a3,16(a0)
ffffffffc0200c8c:	00959513          	slli	a0,a1,0x9
ffffffffc0200c90:	00979613          	slli	a2,a5,0x9
ffffffffc0200c94:	9536                	add	a0,a0,a3
ffffffffc0200c96:	85ba                	mv	a1,a4
ffffffffc0200c98:	14b0a0ef          	jal	ffffffffc020b5e2 <memcpy>
ffffffffc0200c9c:	60a2                	ld	ra,8(sp)
ffffffffc0200c9e:	4501                	li	a0,0
ffffffffc0200ca0:	0141                	addi	sp,sp,16
ffffffffc0200ca2:	8082                	ret

ffffffffc0200ca4 <ramdisk_read>:
ffffffffc0200ca4:	00856783          	lwu	a5,8(a0)
ffffffffc0200ca8:	1141                	addi	sp,sp,-16
ffffffffc0200caa:	e406                	sd	ra,8(sp)
ffffffffc0200cac:	8f8d                	sub	a5,a5,a1
ffffffffc0200cae:	872a                	mv	a4,a0
ffffffffc0200cb0:	8532                	mv	a0,a2
ffffffffc0200cb2:	00f6f363          	bgeu	a3,a5,ffffffffc0200cb8 <ramdisk_read+0x14>
ffffffffc0200cb6:	87b6                	mv	a5,a3
ffffffffc0200cb8:	6b18                	ld	a4,16(a4)
ffffffffc0200cba:	05a6                	slli	a1,a1,0x9
ffffffffc0200cbc:	00979613          	slli	a2,a5,0x9
ffffffffc0200cc0:	95ba                	add	a1,a1,a4
ffffffffc0200cc2:	1210a0ef          	jal	ffffffffc020b5e2 <memcpy>
ffffffffc0200cc6:	60a2                	ld	ra,8(sp)
ffffffffc0200cc8:	4501                	li	a0,0
ffffffffc0200cca:	0141                	addi	sp,sp,16
ffffffffc0200ccc:	8082                	ret

ffffffffc0200cce <ramdisk_init>:
ffffffffc0200cce:	7179                	addi	sp,sp,-48
ffffffffc0200cd0:	f022                	sd	s0,32(sp)
ffffffffc0200cd2:	ec26                	sd	s1,24(sp)
ffffffffc0200cd4:	842e                	mv	s0,a1
ffffffffc0200cd6:	84aa                	mv	s1,a0
ffffffffc0200cd8:	05000613          	li	a2,80
ffffffffc0200cdc:	852e                	mv	a0,a1
ffffffffc0200cde:	4581                	li	a1,0
ffffffffc0200ce0:	f406                	sd	ra,40(sp)
ffffffffc0200ce2:	0b10a0ef          	jal	ffffffffc020b592 <memset>
ffffffffc0200ce6:	4785                	li	a5,1
ffffffffc0200ce8:	06f48a63          	beq	s1,a5,ffffffffc0200d5c <ramdisk_init+0x8e>
ffffffffc0200cec:	4789                	li	a5,2
ffffffffc0200cee:	00090617          	auipc	a2,0x90
ffffffffc0200cf2:	32260613          	addi	a2,a2,802 # ffffffffc0291010 <arena>
ffffffffc0200cf6:	0001b597          	auipc	a1,0x1b
ffffffffc0200cfa:	01a58593          	addi	a1,a1,26 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200cfe:	08f49363          	bne	s1,a5,ffffffffc0200d84 <ramdisk_init+0xb6>
ffffffffc0200d02:	06c58763          	beq	a1,a2,ffffffffc0200d70 <ramdisk_init+0xa2>
ffffffffc0200d06:	40b604b3          	sub	s1,a2,a1
ffffffffc0200d0a:	86a6                	mv	a3,s1
ffffffffc0200d0c:	167d                	addi	a2,a2,-1
ffffffffc0200d0e:	0000b517          	auipc	a0,0xb
ffffffffc0200d12:	df250513          	addi	a0,a0,-526 # ffffffffc020bb00 <etext+0x506>
ffffffffc0200d16:	e42e                	sd	a1,8(sp)
ffffffffc0200d18:	c8eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d1c:	65a2                	ld	a1,8(sp)
ffffffffc0200d1e:	57fd                	li	a5,-1
ffffffffc0200d20:	1782                	slli	a5,a5,0x20
ffffffffc0200d22:	0094d69b          	srliw	a3,s1,0x9
ffffffffc0200d26:	0785                	addi	a5,a5,1
ffffffffc0200d28:	e80c                	sd	a1,16(s0)
ffffffffc0200d2a:	e01c                	sd	a5,0(s0)
ffffffffc0200d2c:	c414                	sw	a3,8(s0)
ffffffffc0200d2e:	02040513          	addi	a0,s0,32
ffffffffc0200d32:	0000b597          	auipc	a1,0xb
ffffffffc0200d36:	e2658593          	addi	a1,a1,-474 # ffffffffc020bb58 <etext+0x55e>
ffffffffc0200d3a:	7d80a0ef          	jal	ffffffffc020b512 <strcpy>
ffffffffc0200d3e:	00000717          	auipc	a4,0x0
ffffffffc0200d42:	f6670713          	addi	a4,a4,-154 # ffffffffc0200ca4 <ramdisk_read>
ffffffffc0200d46:	00000797          	auipc	a5,0x0
ffffffffc0200d4a:	f3278793          	addi	a5,a5,-206 # ffffffffc0200c78 <ramdisk_write>
ffffffffc0200d4e:	70a2                	ld	ra,40(sp)
ffffffffc0200d50:	e038                	sd	a4,64(s0)
ffffffffc0200d52:	e43c                	sd	a5,72(s0)
ffffffffc0200d54:	7402                	ld	s0,32(sp)
ffffffffc0200d56:	64e2                	ld	s1,24(sp)
ffffffffc0200d58:	6145                	addi	sp,sp,48
ffffffffc0200d5a:	8082                	ret
ffffffffc0200d5c:	0001b617          	auipc	a2,0x1b
ffffffffc0200d60:	fb460613          	addi	a2,a2,-76 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200d64:	00013597          	auipc	a1,0x13
ffffffffc0200d68:	2ac58593          	addi	a1,a1,684 # ffffffffc0214010 <_binary_bin_swap_img_start>
ffffffffc0200d6c:	f8c59de3          	bne	a1,a2,ffffffffc0200d06 <ramdisk_init+0x38>
ffffffffc0200d70:	7402                	ld	s0,32(sp)
ffffffffc0200d72:	70a2                	ld	ra,40(sp)
ffffffffc0200d74:	64e2                	ld	s1,24(sp)
ffffffffc0200d76:	0000b517          	auipc	a0,0xb
ffffffffc0200d7a:	d7250513          	addi	a0,a0,-654 # ffffffffc020bae8 <etext+0x4ee>
ffffffffc0200d7e:	6145                	addi	sp,sp,48
ffffffffc0200d80:	c26ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200d84:	0000b617          	auipc	a2,0xb
ffffffffc0200d88:	da460613          	addi	a2,a2,-604 # ffffffffc020bb28 <etext+0x52e>
ffffffffc0200d8c:	03200593          	li	a1,50
ffffffffc0200d90:	0000b517          	auipc	a0,0xb
ffffffffc0200d94:	db050513          	addi	a0,a0,-592 # ffffffffc020bb40 <etext+0x546>
ffffffffc0200d98:	eb2ff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200d9c <idt_init>:
ffffffffc0200d9c:	14005073          	csrwi	sscratch,0
ffffffffc0200da0:	00000797          	auipc	a5,0x0
ffffffffc0200da4:	47478793          	addi	a5,a5,1140 # ffffffffc0201214 <__alltraps>
ffffffffc0200da8:	10579073          	csrw	stvec,a5
ffffffffc0200dac:	000407b7          	lui	a5,0x40
ffffffffc0200db0:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200db4:	8082                	ret

ffffffffc0200db6 <print_regs>:
ffffffffc0200db6:	610c                	ld	a1,0(a0)
ffffffffc0200db8:	1141                	addi	sp,sp,-16
ffffffffc0200dba:	e022                	sd	s0,0(sp)
ffffffffc0200dbc:	842a                	mv	s0,a0
ffffffffc0200dbe:	0000b517          	auipc	a0,0xb
ffffffffc0200dc2:	daa50513          	addi	a0,a0,-598 # ffffffffc020bb68 <etext+0x56e>
ffffffffc0200dc6:	e406                	sd	ra,8(sp)
ffffffffc0200dc8:	bdeff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200dcc:	640c                	ld	a1,8(s0)
ffffffffc0200dce:	0000b517          	auipc	a0,0xb
ffffffffc0200dd2:	db250513          	addi	a0,a0,-590 # ffffffffc020bb80 <etext+0x586>
ffffffffc0200dd6:	bd0ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200dda:	680c                	ld	a1,16(s0)
ffffffffc0200ddc:	0000b517          	auipc	a0,0xb
ffffffffc0200de0:	dbc50513          	addi	a0,a0,-580 # ffffffffc020bb98 <etext+0x59e>
ffffffffc0200de4:	bc2ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200de8:	6c0c                	ld	a1,24(s0)
ffffffffc0200dea:	0000b517          	auipc	a0,0xb
ffffffffc0200dee:	dc650513          	addi	a0,a0,-570 # ffffffffc020bbb0 <etext+0x5b6>
ffffffffc0200df2:	bb4ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200df6:	700c                	ld	a1,32(s0)
ffffffffc0200df8:	0000b517          	auipc	a0,0xb
ffffffffc0200dfc:	dd050513          	addi	a0,a0,-560 # ffffffffc020bbc8 <etext+0x5ce>
ffffffffc0200e00:	ba6ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e04:	740c                	ld	a1,40(s0)
ffffffffc0200e06:	0000b517          	auipc	a0,0xb
ffffffffc0200e0a:	dda50513          	addi	a0,a0,-550 # ffffffffc020bbe0 <etext+0x5e6>
ffffffffc0200e0e:	b98ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e12:	780c                	ld	a1,48(s0)
ffffffffc0200e14:	0000b517          	auipc	a0,0xb
ffffffffc0200e18:	de450513          	addi	a0,a0,-540 # ffffffffc020bbf8 <etext+0x5fe>
ffffffffc0200e1c:	b8aff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e20:	7c0c                	ld	a1,56(s0)
ffffffffc0200e22:	0000b517          	auipc	a0,0xb
ffffffffc0200e26:	dee50513          	addi	a0,a0,-530 # ffffffffc020bc10 <etext+0x616>
ffffffffc0200e2a:	b7cff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e2e:	602c                	ld	a1,64(s0)
ffffffffc0200e30:	0000b517          	auipc	a0,0xb
ffffffffc0200e34:	df850513          	addi	a0,a0,-520 # ffffffffc020bc28 <etext+0x62e>
ffffffffc0200e38:	b6eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e3c:	642c                	ld	a1,72(s0)
ffffffffc0200e3e:	0000b517          	auipc	a0,0xb
ffffffffc0200e42:	e0250513          	addi	a0,a0,-510 # ffffffffc020bc40 <etext+0x646>
ffffffffc0200e46:	b60ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e4a:	682c                	ld	a1,80(s0)
ffffffffc0200e4c:	0000b517          	auipc	a0,0xb
ffffffffc0200e50:	e0c50513          	addi	a0,a0,-500 # ffffffffc020bc58 <etext+0x65e>
ffffffffc0200e54:	b52ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e58:	6c2c                	ld	a1,88(s0)
ffffffffc0200e5a:	0000b517          	auipc	a0,0xb
ffffffffc0200e5e:	e1650513          	addi	a0,a0,-490 # ffffffffc020bc70 <etext+0x676>
ffffffffc0200e62:	b44ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e66:	702c                	ld	a1,96(s0)
ffffffffc0200e68:	0000b517          	auipc	a0,0xb
ffffffffc0200e6c:	e2050513          	addi	a0,a0,-480 # ffffffffc020bc88 <etext+0x68e>
ffffffffc0200e70:	b36ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e74:	742c                	ld	a1,104(s0)
ffffffffc0200e76:	0000b517          	auipc	a0,0xb
ffffffffc0200e7a:	e2a50513          	addi	a0,a0,-470 # ffffffffc020bca0 <etext+0x6a6>
ffffffffc0200e7e:	b28ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e82:	782c                	ld	a1,112(s0)
ffffffffc0200e84:	0000b517          	auipc	a0,0xb
ffffffffc0200e88:	e3450513          	addi	a0,a0,-460 # ffffffffc020bcb8 <etext+0x6be>
ffffffffc0200e8c:	b1aff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e90:	7c2c                	ld	a1,120(s0)
ffffffffc0200e92:	0000b517          	auipc	a0,0xb
ffffffffc0200e96:	e3e50513          	addi	a0,a0,-450 # ffffffffc020bcd0 <etext+0x6d6>
ffffffffc0200e9a:	b0cff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e9e:	604c                	ld	a1,128(s0)
ffffffffc0200ea0:	0000b517          	auipc	a0,0xb
ffffffffc0200ea4:	e4850513          	addi	a0,a0,-440 # ffffffffc020bce8 <etext+0x6ee>
ffffffffc0200ea8:	afeff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200eac:	644c                	ld	a1,136(s0)
ffffffffc0200eae:	0000b517          	auipc	a0,0xb
ffffffffc0200eb2:	e5250513          	addi	a0,a0,-430 # ffffffffc020bd00 <etext+0x706>
ffffffffc0200eb6:	af0ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200eba:	684c                	ld	a1,144(s0)
ffffffffc0200ebc:	0000b517          	auipc	a0,0xb
ffffffffc0200ec0:	e5c50513          	addi	a0,a0,-420 # ffffffffc020bd18 <etext+0x71e>
ffffffffc0200ec4:	ae2ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ec8:	6c4c                	ld	a1,152(s0)
ffffffffc0200eca:	0000b517          	auipc	a0,0xb
ffffffffc0200ece:	e6650513          	addi	a0,a0,-410 # ffffffffc020bd30 <etext+0x736>
ffffffffc0200ed2:	ad4ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ed6:	704c                	ld	a1,160(s0)
ffffffffc0200ed8:	0000b517          	auipc	a0,0xb
ffffffffc0200edc:	e7050513          	addi	a0,a0,-400 # ffffffffc020bd48 <etext+0x74e>
ffffffffc0200ee0:	ac6ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ee4:	744c                	ld	a1,168(s0)
ffffffffc0200ee6:	0000b517          	auipc	a0,0xb
ffffffffc0200eea:	e7a50513          	addi	a0,a0,-390 # ffffffffc020bd60 <etext+0x766>
ffffffffc0200eee:	ab8ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ef2:	784c                	ld	a1,176(s0)
ffffffffc0200ef4:	0000b517          	auipc	a0,0xb
ffffffffc0200ef8:	e8450513          	addi	a0,a0,-380 # ffffffffc020bd78 <etext+0x77e>
ffffffffc0200efc:	aaaff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f00:	7c4c                	ld	a1,184(s0)
ffffffffc0200f02:	0000b517          	auipc	a0,0xb
ffffffffc0200f06:	e8e50513          	addi	a0,a0,-370 # ffffffffc020bd90 <etext+0x796>
ffffffffc0200f0a:	a9cff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f0e:	606c                	ld	a1,192(s0)
ffffffffc0200f10:	0000b517          	auipc	a0,0xb
ffffffffc0200f14:	e9850513          	addi	a0,a0,-360 # ffffffffc020bda8 <etext+0x7ae>
ffffffffc0200f18:	a8eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f1c:	646c                	ld	a1,200(s0)
ffffffffc0200f1e:	0000b517          	auipc	a0,0xb
ffffffffc0200f22:	ea250513          	addi	a0,a0,-350 # ffffffffc020bdc0 <etext+0x7c6>
ffffffffc0200f26:	a80ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f2a:	686c                	ld	a1,208(s0)
ffffffffc0200f2c:	0000b517          	auipc	a0,0xb
ffffffffc0200f30:	eac50513          	addi	a0,a0,-340 # ffffffffc020bdd8 <etext+0x7de>
ffffffffc0200f34:	a72ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f38:	6c6c                	ld	a1,216(s0)
ffffffffc0200f3a:	0000b517          	auipc	a0,0xb
ffffffffc0200f3e:	eb650513          	addi	a0,a0,-330 # ffffffffc020bdf0 <etext+0x7f6>
ffffffffc0200f42:	a64ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f46:	706c                	ld	a1,224(s0)
ffffffffc0200f48:	0000b517          	auipc	a0,0xb
ffffffffc0200f4c:	ec050513          	addi	a0,a0,-320 # ffffffffc020be08 <etext+0x80e>
ffffffffc0200f50:	a56ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f54:	746c                	ld	a1,232(s0)
ffffffffc0200f56:	0000b517          	auipc	a0,0xb
ffffffffc0200f5a:	eca50513          	addi	a0,a0,-310 # ffffffffc020be20 <etext+0x826>
ffffffffc0200f5e:	a48ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f62:	786c                	ld	a1,240(s0)
ffffffffc0200f64:	0000b517          	auipc	a0,0xb
ffffffffc0200f68:	ed450513          	addi	a0,a0,-300 # ffffffffc020be38 <etext+0x83e>
ffffffffc0200f6c:	a3aff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f70:	7c6c                	ld	a1,248(s0)
ffffffffc0200f72:	6402                	ld	s0,0(sp)
ffffffffc0200f74:	60a2                	ld	ra,8(sp)
ffffffffc0200f76:	0000b517          	auipc	a0,0xb
ffffffffc0200f7a:	eda50513          	addi	a0,a0,-294 # ffffffffc020be50 <etext+0x856>
ffffffffc0200f7e:	0141                	addi	sp,sp,16
ffffffffc0200f80:	a26ff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200f84 <print_trapframe>:
ffffffffc0200f84:	1141                	addi	sp,sp,-16
ffffffffc0200f86:	e022                	sd	s0,0(sp)
ffffffffc0200f88:	85aa                	mv	a1,a0
ffffffffc0200f8a:	842a                	mv	s0,a0
ffffffffc0200f8c:	0000b517          	auipc	a0,0xb
ffffffffc0200f90:	edc50513          	addi	a0,a0,-292 # ffffffffc020be68 <etext+0x86e>
ffffffffc0200f94:	e406                	sd	ra,8(sp)
ffffffffc0200f96:	a10ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f9a:	8522                	mv	a0,s0
ffffffffc0200f9c:	e1bff0ef          	jal	ffffffffc0200db6 <print_regs>
ffffffffc0200fa0:	10043583          	ld	a1,256(s0)
ffffffffc0200fa4:	0000b517          	auipc	a0,0xb
ffffffffc0200fa8:	edc50513          	addi	a0,a0,-292 # ffffffffc020be80 <etext+0x886>
ffffffffc0200fac:	9faff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200fb0:	10843583          	ld	a1,264(s0)
ffffffffc0200fb4:	0000b517          	auipc	a0,0xb
ffffffffc0200fb8:	ee450513          	addi	a0,a0,-284 # ffffffffc020be98 <etext+0x89e>
ffffffffc0200fbc:	9eaff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200fc0:	11043583          	ld	a1,272(s0)
ffffffffc0200fc4:	0000b517          	auipc	a0,0xb
ffffffffc0200fc8:	eec50513          	addi	a0,a0,-276 # ffffffffc020beb0 <etext+0x8b6>
ffffffffc0200fcc:	9daff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200fd0:	11843583          	ld	a1,280(s0)
ffffffffc0200fd4:	6402                	ld	s0,0(sp)
ffffffffc0200fd6:	60a2                	ld	ra,8(sp)
ffffffffc0200fd8:	0000b517          	auipc	a0,0xb
ffffffffc0200fdc:	ee850513          	addi	a0,a0,-280 # ffffffffc020bec0 <etext+0x8c6>
ffffffffc0200fe0:	0141                	addi	sp,sp,16
ffffffffc0200fe2:	9c4ff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200fe6 <interrupt_handler>:
ffffffffc0200fe6:	11853783          	ld	a5,280(a0)
ffffffffc0200fea:	472d                	li	a4,11
ffffffffc0200fec:	0786                	slli	a5,a5,0x1
ffffffffc0200fee:	8385                	srli	a5,a5,0x1
ffffffffc0200ff0:	06f76c63          	bltu	a4,a5,ffffffffc0201068 <interrupt_handler+0x82>
ffffffffc0200ff4:	0000e717          	auipc	a4,0xe
ffffffffc0200ff8:	bbc70713          	addi	a4,a4,-1092 # ffffffffc020ebb0 <commands+0x48>
ffffffffc0200ffc:	078a                	slli	a5,a5,0x2
ffffffffc0200ffe:	97ba                	add	a5,a5,a4
ffffffffc0201000:	439c                	lw	a5,0(a5)
ffffffffc0201002:	97ba                	add	a5,a5,a4
ffffffffc0201004:	8782                	jr	a5
ffffffffc0201006:	0000b517          	auipc	a0,0xb
ffffffffc020100a:	f3250513          	addi	a0,a0,-206 # ffffffffc020bf38 <etext+0x93e>
ffffffffc020100e:	998ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201012:	0000b517          	auipc	a0,0xb
ffffffffc0201016:	f0650513          	addi	a0,a0,-250 # ffffffffc020bf18 <etext+0x91e>
ffffffffc020101a:	98cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020101e:	0000b517          	auipc	a0,0xb
ffffffffc0201022:	eba50513          	addi	a0,a0,-326 # ffffffffc020bed8 <etext+0x8de>
ffffffffc0201026:	980ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020102a:	0000b517          	auipc	a0,0xb
ffffffffc020102e:	ece50513          	addi	a0,a0,-306 # ffffffffc020bef8 <etext+0x8fe>
ffffffffc0201032:	974ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201036:	1141                	addi	sp,sp,-16
ffffffffc0201038:	e406                	sd	ra,8(sp)
ffffffffc020103a:	ceeff0ef          	jal	ffffffffc0200528 <clock_set_next_event>
ffffffffc020103e:	d02ff0ef          	jal	ffffffffc0200540 <serial_intr>
ffffffffc0201042:	00096797          	auipc	a5,0x96
ffffffffc0201046:	82e7b783          	ld	a5,-2002(a5) # ffffffffc0296870 <ticks>
ffffffffc020104a:	60a2                	ld	ra,8(sp)
ffffffffc020104c:	0785                	addi	a5,a5,1
ffffffffc020104e:	00096717          	auipc	a4,0x96
ffffffffc0201052:	82f73123          	sd	a5,-2014(a4) # ffffffffc0296870 <ticks>
ffffffffc0201056:	0141                	addi	sp,sp,16
ffffffffc0201058:	48c0606f          	j	ffffffffc02074e4 <run_timer_list>
ffffffffc020105c:	0000b517          	auipc	a0,0xb
ffffffffc0201060:	efc50513          	addi	a0,a0,-260 # ffffffffc020bf58 <etext+0x95e>
ffffffffc0201064:	942ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201068:	bf31                	j	ffffffffc0200f84 <print_trapframe>

ffffffffc020106a <exception_handler>:
ffffffffc020106a:	11853783          	ld	a5,280(a0)
ffffffffc020106e:	473d                	li	a4,15
ffffffffc0201070:	10f76e63          	bltu	a4,a5,ffffffffc020118c <exception_handler+0x122>
ffffffffc0201074:	0000e717          	auipc	a4,0xe
ffffffffc0201078:	b6c70713          	addi	a4,a4,-1172 # ffffffffc020ebe0 <commands+0x78>
ffffffffc020107c:	078a                	slli	a5,a5,0x2
ffffffffc020107e:	97ba                	add	a5,a5,a4
ffffffffc0201080:	439c                	lw	a5,0(a5)
ffffffffc0201082:	1101                	addi	sp,sp,-32
ffffffffc0201084:	ec06                	sd	ra,24(sp)
ffffffffc0201086:	97ba                	add	a5,a5,a4
ffffffffc0201088:	86aa                	mv	a3,a0
ffffffffc020108a:	8782                	jr	a5
ffffffffc020108c:	e42a                	sd	a0,8(sp)
ffffffffc020108e:	0000b517          	auipc	a0,0xb
ffffffffc0201092:	fd250513          	addi	a0,a0,-46 # ffffffffc020c060 <etext+0xa66>
ffffffffc0201096:	910ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020109a:	66a2                	ld	a3,8(sp)
ffffffffc020109c:	1086b783          	ld	a5,264(a3)
ffffffffc02010a0:	60e2                	ld	ra,24(sp)
ffffffffc02010a2:	0791                	addi	a5,a5,4
ffffffffc02010a4:	10f6b423          	sd	a5,264(a3)
ffffffffc02010a8:	6105                	addi	sp,sp,32
ffffffffc02010aa:	68a0606f          	j	ffffffffc0207734 <syscall>
ffffffffc02010ae:	60e2                	ld	ra,24(sp)
ffffffffc02010b0:	0000b517          	auipc	a0,0xb
ffffffffc02010b4:	fd050513          	addi	a0,a0,-48 # ffffffffc020c080 <etext+0xa86>
ffffffffc02010b8:	6105                	addi	sp,sp,32
ffffffffc02010ba:	8ecff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010be:	60e2                	ld	ra,24(sp)
ffffffffc02010c0:	0000b517          	auipc	a0,0xb
ffffffffc02010c4:	fe050513          	addi	a0,a0,-32 # ffffffffc020c0a0 <etext+0xaa6>
ffffffffc02010c8:	6105                	addi	sp,sp,32
ffffffffc02010ca:	8dcff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010ce:	60e2                	ld	ra,24(sp)
ffffffffc02010d0:	0000b517          	auipc	a0,0xb
ffffffffc02010d4:	ff050513          	addi	a0,a0,-16 # ffffffffc020c0c0 <etext+0xac6>
ffffffffc02010d8:	6105                	addi	sp,sp,32
ffffffffc02010da:	8ccff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010de:	60e2                	ld	ra,24(sp)
ffffffffc02010e0:	0000b517          	auipc	a0,0xb
ffffffffc02010e4:	ff850513          	addi	a0,a0,-8 # ffffffffc020c0d8 <etext+0xade>
ffffffffc02010e8:	6105                	addi	sp,sp,32
ffffffffc02010ea:	8bcff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010ee:	60e2                	ld	ra,24(sp)
ffffffffc02010f0:	0000b517          	auipc	a0,0xb
ffffffffc02010f4:	00050513          	mv	a0,a0
ffffffffc02010f8:	6105                	addi	sp,sp,32
ffffffffc02010fa:	8acff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010fe:	60e2                	ld	ra,24(sp)
ffffffffc0201100:	0000b517          	auipc	a0,0xb
ffffffffc0201104:	e7850513          	addi	a0,a0,-392 # ffffffffc020bf78 <etext+0x97e>
ffffffffc0201108:	6105                	addi	sp,sp,32
ffffffffc020110a:	89cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020110e:	60e2                	ld	ra,24(sp)
ffffffffc0201110:	0000b517          	auipc	a0,0xb
ffffffffc0201114:	e8850513          	addi	a0,a0,-376 # ffffffffc020bf98 <etext+0x99e>
ffffffffc0201118:	6105                	addi	sp,sp,32
ffffffffc020111a:	88cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020111e:	60e2                	ld	ra,24(sp)
ffffffffc0201120:	0000b517          	auipc	a0,0xb
ffffffffc0201124:	e9850513          	addi	a0,a0,-360 # ffffffffc020bfb8 <etext+0x9be>
ffffffffc0201128:	6105                	addi	sp,sp,32
ffffffffc020112a:	87cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020112e:	60e2                	ld	ra,24(sp)
ffffffffc0201130:	0000b517          	auipc	a0,0xb
ffffffffc0201134:	ea050513          	addi	a0,a0,-352 # ffffffffc020bfd0 <etext+0x9d6>
ffffffffc0201138:	6105                	addi	sp,sp,32
ffffffffc020113a:	86cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020113e:	60e2                	ld	ra,24(sp)
ffffffffc0201140:	0000b517          	auipc	a0,0xb
ffffffffc0201144:	ea050513          	addi	a0,a0,-352 # ffffffffc020bfe0 <etext+0x9e6>
ffffffffc0201148:	6105                	addi	sp,sp,32
ffffffffc020114a:	85cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020114e:	60e2                	ld	ra,24(sp)
ffffffffc0201150:	0000b517          	auipc	a0,0xb
ffffffffc0201154:	eb050513          	addi	a0,a0,-336 # ffffffffc020c000 <etext+0xa06>
ffffffffc0201158:	6105                	addi	sp,sp,32
ffffffffc020115a:	84cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020115e:	60e2                	ld	ra,24(sp)
ffffffffc0201160:	0000b517          	auipc	a0,0xb
ffffffffc0201164:	ee850513          	addi	a0,a0,-280 # ffffffffc020c048 <etext+0xa4e>
ffffffffc0201168:	6105                	addi	sp,sp,32
ffffffffc020116a:	83cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020116e:	60e2                	ld	ra,24(sp)
ffffffffc0201170:	6105                	addi	sp,sp,32
ffffffffc0201172:	bd09                	j	ffffffffc0200f84 <print_trapframe>
ffffffffc0201174:	0000b617          	auipc	a2,0xb
ffffffffc0201178:	ea460613          	addi	a2,a2,-348 # ffffffffc020c018 <etext+0xa1e>
ffffffffc020117c:	0b100593          	li	a1,177
ffffffffc0201180:	0000b517          	auipc	a0,0xb
ffffffffc0201184:	eb050513          	addi	a0,a0,-336 # ffffffffc020c030 <etext+0xa36>
ffffffffc0201188:	ac2ff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020118c:	bbe5                	j	ffffffffc0200f84 <print_trapframe>

ffffffffc020118e <trap>:
ffffffffc020118e:	00095717          	auipc	a4,0x95
ffffffffc0201192:	73a73703          	ld	a4,1850(a4) # ffffffffc02968c8 <current>
ffffffffc0201196:	11853583          	ld	a1,280(a0)
ffffffffc020119a:	cf21                	beqz	a4,ffffffffc02011f2 <trap+0x64>
ffffffffc020119c:	10053603          	ld	a2,256(a0)
ffffffffc02011a0:	0a073803          	ld	a6,160(a4)
ffffffffc02011a4:	1101                	addi	sp,sp,-32
ffffffffc02011a6:	ec06                	sd	ra,24(sp)
ffffffffc02011a8:	10067613          	andi	a2,a2,256
ffffffffc02011ac:	f348                	sd	a0,160(a4)
ffffffffc02011ae:	e432                	sd	a2,8(sp)
ffffffffc02011b0:	e042                	sd	a6,0(sp)
ffffffffc02011b2:	0205c763          	bltz	a1,ffffffffc02011e0 <trap+0x52>
ffffffffc02011b6:	eb5ff0ef          	jal	ffffffffc020106a <exception_handler>
ffffffffc02011ba:	6622                	ld	a2,8(sp)
ffffffffc02011bc:	6802                	ld	a6,0(sp)
ffffffffc02011be:	00095697          	auipc	a3,0x95
ffffffffc02011c2:	70a68693          	addi	a3,a3,1802 # ffffffffc02968c8 <current>
ffffffffc02011c6:	6298                	ld	a4,0(a3)
ffffffffc02011c8:	0b073023          	sd	a6,160(a4)
ffffffffc02011cc:	e619                	bnez	a2,ffffffffc02011da <trap+0x4c>
ffffffffc02011ce:	0b072783          	lw	a5,176(a4)
ffffffffc02011d2:	8b85                	andi	a5,a5,1
ffffffffc02011d4:	e79d                	bnez	a5,ffffffffc0201202 <trap+0x74>
ffffffffc02011d6:	6f1c                	ld	a5,24(a4)
ffffffffc02011d8:	e38d                	bnez	a5,ffffffffc02011fa <trap+0x6c>
ffffffffc02011da:	60e2                	ld	ra,24(sp)
ffffffffc02011dc:	6105                	addi	sp,sp,32
ffffffffc02011de:	8082                	ret
ffffffffc02011e0:	e07ff0ef          	jal	ffffffffc0200fe6 <interrupt_handler>
ffffffffc02011e4:	6802                	ld	a6,0(sp)
ffffffffc02011e6:	6622                	ld	a2,8(sp)
ffffffffc02011e8:	00095697          	auipc	a3,0x95
ffffffffc02011ec:	6e068693          	addi	a3,a3,1760 # ffffffffc02968c8 <current>
ffffffffc02011f0:	bfd9                	j	ffffffffc02011c6 <trap+0x38>
ffffffffc02011f2:	0005c363          	bltz	a1,ffffffffc02011f8 <trap+0x6a>
ffffffffc02011f6:	bd95                	j	ffffffffc020106a <exception_handler>
ffffffffc02011f8:	b3fd                	j	ffffffffc0200fe6 <interrupt_handler>
ffffffffc02011fa:	60e2                	ld	ra,24(sp)
ffffffffc02011fc:	6105                	addi	sp,sp,32
ffffffffc02011fe:	0dc0606f          	j	ffffffffc02072da <schedule>
ffffffffc0201202:	555d                	li	a0,-9
ffffffffc0201204:	565040ef          	jal	ffffffffc0205f68 <do_exit>
ffffffffc0201208:	00095717          	auipc	a4,0x95
ffffffffc020120c:	6c073703          	ld	a4,1728(a4) # ffffffffc02968c8 <current>
ffffffffc0201210:	b7d9                	j	ffffffffc02011d6 <trap+0x48>
	...

ffffffffc0201214 <__alltraps>:
ffffffffc0201214:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0201218:	00011463          	bnez	sp,ffffffffc0201220 <__alltraps+0xc>
ffffffffc020121c:	14002173          	csrr	sp,sscratch
ffffffffc0201220:	712d                	addi	sp,sp,-288
ffffffffc0201222:	e002                	sd	zero,0(sp)
ffffffffc0201224:	e406                	sd	ra,8(sp)
ffffffffc0201226:	ec0e                	sd	gp,24(sp)
ffffffffc0201228:	f012                	sd	tp,32(sp)
ffffffffc020122a:	f416                	sd	t0,40(sp)
ffffffffc020122c:	f81a                	sd	t1,48(sp)
ffffffffc020122e:	fc1e                	sd	t2,56(sp)
ffffffffc0201230:	e0a2                	sd	s0,64(sp)
ffffffffc0201232:	e4a6                	sd	s1,72(sp)
ffffffffc0201234:	e8aa                	sd	a0,80(sp)
ffffffffc0201236:	ecae                	sd	a1,88(sp)
ffffffffc0201238:	f0b2                	sd	a2,96(sp)
ffffffffc020123a:	f4b6                	sd	a3,104(sp)
ffffffffc020123c:	f8ba                	sd	a4,112(sp)
ffffffffc020123e:	fcbe                	sd	a5,120(sp)
ffffffffc0201240:	e142                	sd	a6,128(sp)
ffffffffc0201242:	e546                	sd	a7,136(sp)
ffffffffc0201244:	e94a                	sd	s2,144(sp)
ffffffffc0201246:	ed4e                	sd	s3,152(sp)
ffffffffc0201248:	f152                	sd	s4,160(sp)
ffffffffc020124a:	f556                	sd	s5,168(sp)
ffffffffc020124c:	f95a                	sd	s6,176(sp)
ffffffffc020124e:	fd5e                	sd	s7,184(sp)
ffffffffc0201250:	e1e2                	sd	s8,192(sp)
ffffffffc0201252:	e5e6                	sd	s9,200(sp)
ffffffffc0201254:	e9ea                	sd	s10,208(sp)
ffffffffc0201256:	edee                	sd	s11,216(sp)
ffffffffc0201258:	f1f2                	sd	t3,224(sp)
ffffffffc020125a:	f5f6                	sd	t4,232(sp)
ffffffffc020125c:	f9fa                	sd	t5,240(sp)
ffffffffc020125e:	fdfe                	sd	t6,248(sp)
ffffffffc0201260:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0201264:	100024f3          	csrr	s1,sstatus
ffffffffc0201268:	14102973          	csrr	s2,sepc
ffffffffc020126c:	143029f3          	csrr	s3,stval
ffffffffc0201270:	14202a73          	csrr	s4,scause
ffffffffc0201274:	e822                	sd	s0,16(sp)
ffffffffc0201276:	e226                	sd	s1,256(sp)
ffffffffc0201278:	e64a                	sd	s2,264(sp)
ffffffffc020127a:	ea4e                	sd	s3,272(sp)
ffffffffc020127c:	ee52                	sd	s4,280(sp)
ffffffffc020127e:	850a                	mv	a0,sp
ffffffffc0201280:	f0fff0ef          	jal	ffffffffc020118e <trap>

ffffffffc0201284 <__trapret>:
ffffffffc0201284:	6492                	ld	s1,256(sp)
ffffffffc0201286:	6932                	ld	s2,264(sp)
ffffffffc0201288:	1004f413          	andi	s0,s1,256
ffffffffc020128c:	e401                	bnez	s0,ffffffffc0201294 <__trapret+0x10>
ffffffffc020128e:	1200                	addi	s0,sp,288
ffffffffc0201290:	14041073          	csrw	sscratch,s0
ffffffffc0201294:	10049073          	csrw	sstatus,s1
ffffffffc0201298:	14191073          	csrw	sepc,s2
ffffffffc020129c:	60a2                	ld	ra,8(sp)
ffffffffc020129e:	61e2                	ld	gp,24(sp)
ffffffffc02012a0:	7202                	ld	tp,32(sp)
ffffffffc02012a2:	72a2                	ld	t0,40(sp)
ffffffffc02012a4:	7342                	ld	t1,48(sp)
ffffffffc02012a6:	73e2                	ld	t2,56(sp)
ffffffffc02012a8:	6406                	ld	s0,64(sp)
ffffffffc02012aa:	64a6                	ld	s1,72(sp)
ffffffffc02012ac:	6546                	ld	a0,80(sp)
ffffffffc02012ae:	65e6                	ld	a1,88(sp)
ffffffffc02012b0:	7606                	ld	a2,96(sp)
ffffffffc02012b2:	76a6                	ld	a3,104(sp)
ffffffffc02012b4:	7746                	ld	a4,112(sp)
ffffffffc02012b6:	77e6                	ld	a5,120(sp)
ffffffffc02012b8:	680a                	ld	a6,128(sp)
ffffffffc02012ba:	68aa                	ld	a7,136(sp)
ffffffffc02012bc:	694a                	ld	s2,144(sp)
ffffffffc02012be:	69ea                	ld	s3,152(sp)
ffffffffc02012c0:	7a0a                	ld	s4,160(sp)
ffffffffc02012c2:	7aaa                	ld	s5,168(sp)
ffffffffc02012c4:	7b4a                	ld	s6,176(sp)
ffffffffc02012c6:	7bea                	ld	s7,184(sp)
ffffffffc02012c8:	6c0e                	ld	s8,192(sp)
ffffffffc02012ca:	6cae                	ld	s9,200(sp)
ffffffffc02012cc:	6d4e                	ld	s10,208(sp)
ffffffffc02012ce:	6dee                	ld	s11,216(sp)
ffffffffc02012d0:	7e0e                	ld	t3,224(sp)
ffffffffc02012d2:	7eae                	ld	t4,232(sp)
ffffffffc02012d4:	7f4e                	ld	t5,240(sp)
ffffffffc02012d6:	7fee                	ld	t6,248(sp)
ffffffffc02012d8:	6142                	ld	sp,16(sp)
ffffffffc02012da:	10200073          	sret

ffffffffc02012de <forkrets>:
ffffffffc02012de:	812a                	mv	sp,a0
ffffffffc02012e0:	b755                	j	ffffffffc0201284 <__trapret>

ffffffffc02012e2 <default_init>:
ffffffffc02012e2:	00090797          	auipc	a5,0x90
ffffffffc02012e6:	4c678793          	addi	a5,a5,1222 # ffffffffc02917a8 <free_area>
ffffffffc02012ea:	e79c                	sd	a5,8(a5)
ffffffffc02012ec:	e39c                	sd	a5,0(a5)
ffffffffc02012ee:	0007a823          	sw	zero,16(a5)
ffffffffc02012f2:	8082                	ret

ffffffffc02012f4 <default_nr_free_pages>:
ffffffffc02012f4:	00090517          	auipc	a0,0x90
ffffffffc02012f8:	4c456503          	lwu	a0,1220(a0) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02012fc:	8082                	ret

ffffffffc02012fe <default_check>:
ffffffffc02012fe:	711d                	addi	sp,sp,-96
ffffffffc0201300:	e0ca                	sd	s2,64(sp)
ffffffffc0201302:	00090917          	auipc	s2,0x90
ffffffffc0201306:	4a690913          	addi	s2,s2,1190 # ffffffffc02917a8 <free_area>
ffffffffc020130a:	00893783          	ld	a5,8(s2)
ffffffffc020130e:	ec86                	sd	ra,88(sp)
ffffffffc0201310:	e8a2                	sd	s0,80(sp)
ffffffffc0201312:	e4a6                	sd	s1,72(sp)
ffffffffc0201314:	fc4e                	sd	s3,56(sp)
ffffffffc0201316:	f852                	sd	s4,48(sp)
ffffffffc0201318:	f456                	sd	s5,40(sp)
ffffffffc020131a:	f05a                	sd	s6,32(sp)
ffffffffc020131c:	ec5e                	sd	s7,24(sp)
ffffffffc020131e:	e862                	sd	s8,16(sp)
ffffffffc0201320:	e466                	sd	s9,8(sp)
ffffffffc0201322:	2f278363          	beq	a5,s2,ffffffffc0201608 <default_check+0x30a>
ffffffffc0201326:	4401                	li	s0,0
ffffffffc0201328:	4481                	li	s1,0
ffffffffc020132a:	ff07b703          	ld	a4,-16(a5)
ffffffffc020132e:	8b09                	andi	a4,a4,2
ffffffffc0201330:	2e070063          	beqz	a4,ffffffffc0201610 <default_check+0x312>
ffffffffc0201334:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201338:	679c                	ld	a5,8(a5)
ffffffffc020133a:	2485                	addiw	s1,s1,1
ffffffffc020133c:	9c39                	addw	s0,s0,a4
ffffffffc020133e:	ff2796e3          	bne	a5,s2,ffffffffc020132a <default_check+0x2c>
ffffffffc0201342:	89a2                	mv	s3,s0
ffffffffc0201344:	743000ef          	jal	ffffffffc0202286 <nr_free_pages>
ffffffffc0201348:	73351463          	bne	a0,s3,ffffffffc0201a70 <default_check+0x772>
ffffffffc020134c:	4505                	li	a0,1
ffffffffc020134e:	6c7000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc0201352:	8a2a                	mv	s4,a0
ffffffffc0201354:	44050e63          	beqz	a0,ffffffffc02017b0 <default_check+0x4b2>
ffffffffc0201358:	4505                	li	a0,1
ffffffffc020135a:	6bb000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc020135e:	89aa                	mv	s3,a0
ffffffffc0201360:	72050863          	beqz	a0,ffffffffc0201a90 <default_check+0x792>
ffffffffc0201364:	4505                	li	a0,1
ffffffffc0201366:	6af000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc020136a:	8aaa                	mv	s5,a0
ffffffffc020136c:	4c050263          	beqz	a0,ffffffffc0201830 <default_check+0x532>
ffffffffc0201370:	40a987b3          	sub	a5,s3,a0
ffffffffc0201374:	40aa0733          	sub	a4,s4,a0
ffffffffc0201378:	0017b793          	seqz	a5,a5
ffffffffc020137c:	00173713          	seqz	a4,a4
ffffffffc0201380:	8fd9                	or	a5,a5,a4
ffffffffc0201382:	30079763          	bnez	a5,ffffffffc0201690 <default_check+0x392>
ffffffffc0201386:	313a0563          	beq	s4,s3,ffffffffc0201690 <default_check+0x392>
ffffffffc020138a:	000a2783          	lw	a5,0(s4)
ffffffffc020138e:	2a079163          	bnez	a5,ffffffffc0201630 <default_check+0x332>
ffffffffc0201392:	0009a783          	lw	a5,0(s3)
ffffffffc0201396:	28079d63          	bnez	a5,ffffffffc0201630 <default_check+0x332>
ffffffffc020139a:	411c                	lw	a5,0(a0)
ffffffffc020139c:	28079a63          	bnez	a5,ffffffffc0201630 <default_check+0x332>
ffffffffc02013a0:	00095797          	auipc	a5,0x95
ffffffffc02013a4:	5187b783          	ld	a5,1304(a5) # ffffffffc02968b8 <pages>
ffffffffc02013a8:	0000e617          	auipc	a2,0xe
ffffffffc02013ac:	48063603          	ld	a2,1152(a2) # ffffffffc020f828 <nbase>
ffffffffc02013b0:	00095697          	auipc	a3,0x95
ffffffffc02013b4:	5006b683          	ld	a3,1280(a3) # ffffffffc02968b0 <npage>
ffffffffc02013b8:	40fa0733          	sub	a4,s4,a5
ffffffffc02013bc:	8719                	srai	a4,a4,0x6
ffffffffc02013be:	9732                	add	a4,a4,a2
ffffffffc02013c0:	0732                	slli	a4,a4,0xc
ffffffffc02013c2:	06b2                	slli	a3,a3,0xc
ffffffffc02013c4:	2ad77663          	bgeu	a4,a3,ffffffffc0201670 <default_check+0x372>
ffffffffc02013c8:	40f98733          	sub	a4,s3,a5
ffffffffc02013cc:	8719                	srai	a4,a4,0x6
ffffffffc02013ce:	9732                	add	a4,a4,a2
ffffffffc02013d0:	0732                	slli	a4,a4,0xc
ffffffffc02013d2:	4cd77f63          	bgeu	a4,a3,ffffffffc02018b0 <default_check+0x5b2>
ffffffffc02013d6:	40f507b3          	sub	a5,a0,a5
ffffffffc02013da:	8799                	srai	a5,a5,0x6
ffffffffc02013dc:	97b2                	add	a5,a5,a2
ffffffffc02013de:	07b2                	slli	a5,a5,0xc
ffffffffc02013e0:	32d7f863          	bgeu	a5,a3,ffffffffc0201710 <default_check+0x412>
ffffffffc02013e4:	4505                	li	a0,1
ffffffffc02013e6:	00093c03          	ld	s8,0(s2)
ffffffffc02013ea:	00893b83          	ld	s7,8(s2)
ffffffffc02013ee:	00090b17          	auipc	s6,0x90
ffffffffc02013f2:	3cab2b03          	lw	s6,970(s6) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02013f6:	01293023          	sd	s2,0(s2)
ffffffffc02013fa:	01293423          	sd	s2,8(s2)
ffffffffc02013fe:	00090797          	auipc	a5,0x90
ffffffffc0201402:	3a07ad23          	sw	zero,954(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201406:	60f000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc020140a:	2e051363          	bnez	a0,ffffffffc02016f0 <default_check+0x3f2>
ffffffffc020140e:	8552                	mv	a0,s4
ffffffffc0201410:	4585                	li	a1,1
ffffffffc0201412:	63d000ef          	jal	ffffffffc020224e <free_pages>
ffffffffc0201416:	854e                	mv	a0,s3
ffffffffc0201418:	4585                	li	a1,1
ffffffffc020141a:	635000ef          	jal	ffffffffc020224e <free_pages>
ffffffffc020141e:	8556                	mv	a0,s5
ffffffffc0201420:	4585                	li	a1,1
ffffffffc0201422:	62d000ef          	jal	ffffffffc020224e <free_pages>
ffffffffc0201426:	00090717          	auipc	a4,0x90
ffffffffc020142a:	39272703          	lw	a4,914(a4) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020142e:	478d                	li	a5,3
ffffffffc0201430:	2af71063          	bne	a4,a5,ffffffffc02016d0 <default_check+0x3d2>
ffffffffc0201434:	4505                	li	a0,1
ffffffffc0201436:	5df000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc020143a:	89aa                	mv	s3,a0
ffffffffc020143c:	26050a63          	beqz	a0,ffffffffc02016b0 <default_check+0x3b2>
ffffffffc0201440:	4505                	li	a0,1
ffffffffc0201442:	5d3000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc0201446:	8aaa                	mv	s5,a0
ffffffffc0201448:	3c050463          	beqz	a0,ffffffffc0201810 <default_check+0x512>
ffffffffc020144c:	4505                	li	a0,1
ffffffffc020144e:	5c7000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc0201452:	8a2a                	mv	s4,a0
ffffffffc0201454:	38050e63          	beqz	a0,ffffffffc02017f0 <default_check+0x4f2>
ffffffffc0201458:	4505                	li	a0,1
ffffffffc020145a:	5bb000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc020145e:	36051963          	bnez	a0,ffffffffc02017d0 <default_check+0x4d2>
ffffffffc0201462:	4585                	li	a1,1
ffffffffc0201464:	854e                	mv	a0,s3
ffffffffc0201466:	5e9000ef          	jal	ffffffffc020224e <free_pages>
ffffffffc020146a:	00893783          	ld	a5,8(s2)
ffffffffc020146e:	1f278163          	beq	a5,s2,ffffffffc0201650 <default_check+0x352>
ffffffffc0201472:	4505                	li	a0,1
ffffffffc0201474:	5a1000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc0201478:	8caa                	mv	s9,a0
ffffffffc020147a:	30a99b63          	bne	s3,a0,ffffffffc0201790 <default_check+0x492>
ffffffffc020147e:	4505                	li	a0,1
ffffffffc0201480:	595000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc0201484:	2e051663          	bnez	a0,ffffffffc0201770 <default_check+0x472>
ffffffffc0201488:	00090797          	auipc	a5,0x90
ffffffffc020148c:	3307a783          	lw	a5,816(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201490:	2c079063          	bnez	a5,ffffffffc0201750 <default_check+0x452>
ffffffffc0201494:	8566                	mv	a0,s9
ffffffffc0201496:	4585                	li	a1,1
ffffffffc0201498:	01893023          	sd	s8,0(s2)
ffffffffc020149c:	01793423          	sd	s7,8(s2)
ffffffffc02014a0:	01692823          	sw	s6,16(s2)
ffffffffc02014a4:	5ab000ef          	jal	ffffffffc020224e <free_pages>
ffffffffc02014a8:	8556                	mv	a0,s5
ffffffffc02014aa:	4585                	li	a1,1
ffffffffc02014ac:	5a3000ef          	jal	ffffffffc020224e <free_pages>
ffffffffc02014b0:	8552                	mv	a0,s4
ffffffffc02014b2:	4585                	li	a1,1
ffffffffc02014b4:	59b000ef          	jal	ffffffffc020224e <free_pages>
ffffffffc02014b8:	4515                	li	a0,5
ffffffffc02014ba:	55b000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc02014be:	89aa                	mv	s3,a0
ffffffffc02014c0:	26050863          	beqz	a0,ffffffffc0201730 <default_check+0x432>
ffffffffc02014c4:	651c                	ld	a5,8(a0)
ffffffffc02014c6:	8b89                	andi	a5,a5,2
ffffffffc02014c8:	54079463          	bnez	a5,ffffffffc0201a10 <default_check+0x712>
ffffffffc02014cc:	4505                	li	a0,1
ffffffffc02014ce:	00093b83          	ld	s7,0(s2)
ffffffffc02014d2:	00893b03          	ld	s6,8(s2)
ffffffffc02014d6:	01293023          	sd	s2,0(s2)
ffffffffc02014da:	01293423          	sd	s2,8(s2)
ffffffffc02014de:	537000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc02014e2:	50051763          	bnez	a0,ffffffffc02019f0 <default_check+0x6f2>
ffffffffc02014e6:	08098a13          	addi	s4,s3,128
ffffffffc02014ea:	8552                	mv	a0,s4
ffffffffc02014ec:	458d                	li	a1,3
ffffffffc02014ee:	00090c17          	auipc	s8,0x90
ffffffffc02014f2:	2cac2c03          	lw	s8,714(s8) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02014f6:	00090797          	auipc	a5,0x90
ffffffffc02014fa:	2c07a123          	sw	zero,706(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02014fe:	551000ef          	jal	ffffffffc020224e <free_pages>
ffffffffc0201502:	4511                	li	a0,4
ffffffffc0201504:	511000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc0201508:	4c051463          	bnez	a0,ffffffffc02019d0 <default_check+0x6d2>
ffffffffc020150c:	0889b783          	ld	a5,136(s3)
ffffffffc0201510:	8b89                	andi	a5,a5,2
ffffffffc0201512:	48078f63          	beqz	a5,ffffffffc02019b0 <default_check+0x6b2>
ffffffffc0201516:	0909a503          	lw	a0,144(s3)
ffffffffc020151a:	478d                	li	a5,3
ffffffffc020151c:	48f51a63          	bne	a0,a5,ffffffffc02019b0 <default_check+0x6b2>
ffffffffc0201520:	4f5000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc0201524:	8aaa                	mv	s5,a0
ffffffffc0201526:	46050563          	beqz	a0,ffffffffc0201990 <default_check+0x692>
ffffffffc020152a:	4505                	li	a0,1
ffffffffc020152c:	4e9000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc0201530:	44051063          	bnez	a0,ffffffffc0201970 <default_check+0x672>
ffffffffc0201534:	415a1e63          	bne	s4,s5,ffffffffc0201950 <default_check+0x652>
ffffffffc0201538:	4585                	li	a1,1
ffffffffc020153a:	854e                	mv	a0,s3
ffffffffc020153c:	513000ef          	jal	ffffffffc020224e <free_pages>
ffffffffc0201540:	8552                	mv	a0,s4
ffffffffc0201542:	458d                	li	a1,3
ffffffffc0201544:	50b000ef          	jal	ffffffffc020224e <free_pages>
ffffffffc0201548:	0089b783          	ld	a5,8(s3)
ffffffffc020154c:	8b89                	andi	a5,a5,2
ffffffffc020154e:	3e078163          	beqz	a5,ffffffffc0201930 <default_check+0x632>
ffffffffc0201552:	0109aa83          	lw	s5,16(s3)
ffffffffc0201556:	4785                	li	a5,1
ffffffffc0201558:	3cfa9c63          	bne	s5,a5,ffffffffc0201930 <default_check+0x632>
ffffffffc020155c:	008a3783          	ld	a5,8(s4)
ffffffffc0201560:	8b89                	andi	a5,a5,2
ffffffffc0201562:	3a078763          	beqz	a5,ffffffffc0201910 <default_check+0x612>
ffffffffc0201566:	010a2703          	lw	a4,16(s4)
ffffffffc020156a:	478d                	li	a5,3
ffffffffc020156c:	3af71263          	bne	a4,a5,ffffffffc0201910 <default_check+0x612>
ffffffffc0201570:	8556                	mv	a0,s5
ffffffffc0201572:	4a3000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc0201576:	36a99d63          	bne	s3,a0,ffffffffc02018f0 <default_check+0x5f2>
ffffffffc020157a:	85d6                	mv	a1,s5
ffffffffc020157c:	4d3000ef          	jal	ffffffffc020224e <free_pages>
ffffffffc0201580:	4509                	li	a0,2
ffffffffc0201582:	493000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc0201586:	34aa1563          	bne	s4,a0,ffffffffc02018d0 <default_check+0x5d2>
ffffffffc020158a:	4589                	li	a1,2
ffffffffc020158c:	4c3000ef          	jal	ffffffffc020224e <free_pages>
ffffffffc0201590:	04098513          	addi	a0,s3,64
ffffffffc0201594:	85d6                	mv	a1,s5
ffffffffc0201596:	4b9000ef          	jal	ffffffffc020224e <free_pages>
ffffffffc020159a:	4515                	li	a0,5
ffffffffc020159c:	479000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc02015a0:	89aa                	mv	s3,a0
ffffffffc02015a2:	48050763          	beqz	a0,ffffffffc0201a30 <default_check+0x732>
ffffffffc02015a6:	8556                	mv	a0,s5
ffffffffc02015a8:	46d000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc02015ac:	2e051263          	bnez	a0,ffffffffc0201890 <default_check+0x592>
ffffffffc02015b0:	00090797          	auipc	a5,0x90
ffffffffc02015b4:	2087a783          	lw	a5,520(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02015b8:	2a079c63          	bnez	a5,ffffffffc0201870 <default_check+0x572>
ffffffffc02015bc:	854e                	mv	a0,s3
ffffffffc02015be:	4595                	li	a1,5
ffffffffc02015c0:	01892823          	sw	s8,16(s2)
ffffffffc02015c4:	01793023          	sd	s7,0(s2)
ffffffffc02015c8:	01693423          	sd	s6,8(s2)
ffffffffc02015cc:	483000ef          	jal	ffffffffc020224e <free_pages>
ffffffffc02015d0:	00893783          	ld	a5,8(s2)
ffffffffc02015d4:	01278963          	beq	a5,s2,ffffffffc02015e6 <default_check+0x2e8>
ffffffffc02015d8:	ff87a703          	lw	a4,-8(a5)
ffffffffc02015dc:	679c                	ld	a5,8(a5)
ffffffffc02015de:	34fd                	addiw	s1,s1,-1
ffffffffc02015e0:	9c19                	subw	s0,s0,a4
ffffffffc02015e2:	ff279be3          	bne	a5,s2,ffffffffc02015d8 <default_check+0x2da>
ffffffffc02015e6:	26049563          	bnez	s1,ffffffffc0201850 <default_check+0x552>
ffffffffc02015ea:	46041363          	bnez	s0,ffffffffc0201a50 <default_check+0x752>
ffffffffc02015ee:	60e6                	ld	ra,88(sp)
ffffffffc02015f0:	6446                	ld	s0,80(sp)
ffffffffc02015f2:	64a6                	ld	s1,72(sp)
ffffffffc02015f4:	6906                	ld	s2,64(sp)
ffffffffc02015f6:	79e2                	ld	s3,56(sp)
ffffffffc02015f8:	7a42                	ld	s4,48(sp)
ffffffffc02015fa:	7aa2                	ld	s5,40(sp)
ffffffffc02015fc:	7b02                	ld	s6,32(sp)
ffffffffc02015fe:	6be2                	ld	s7,24(sp)
ffffffffc0201600:	6c42                	ld	s8,16(sp)
ffffffffc0201602:	6ca2                	ld	s9,8(sp)
ffffffffc0201604:	6125                	addi	sp,sp,96
ffffffffc0201606:	8082                	ret
ffffffffc0201608:	4981                	li	s3,0
ffffffffc020160a:	4401                	li	s0,0
ffffffffc020160c:	4481                	li	s1,0
ffffffffc020160e:	bb1d                	j	ffffffffc0201344 <default_check+0x46>
ffffffffc0201610:	0000b697          	auipc	a3,0xb
ffffffffc0201614:	af868693          	addi	a3,a3,-1288 # ffffffffc020c108 <etext+0xb0e>
ffffffffc0201618:	0000a617          	auipc	a2,0xa
ffffffffc020161c:	42060613          	addi	a2,a2,1056 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201620:	0ef00593          	li	a1,239
ffffffffc0201624:	0000b517          	auipc	a0,0xb
ffffffffc0201628:	af450513          	addi	a0,a0,-1292 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020162c:	e1ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201630:	0000b697          	auipc	a3,0xb
ffffffffc0201634:	ba868693          	addi	a3,a3,-1112 # ffffffffc020c1d8 <etext+0xbde>
ffffffffc0201638:	0000a617          	auipc	a2,0xa
ffffffffc020163c:	40060613          	addi	a2,a2,1024 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201640:	0bd00593          	li	a1,189
ffffffffc0201644:	0000b517          	auipc	a0,0xb
ffffffffc0201648:	ad450513          	addi	a0,a0,-1324 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020164c:	dfffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201650:	0000b697          	auipc	a3,0xb
ffffffffc0201654:	c5068693          	addi	a3,a3,-944 # ffffffffc020c2a0 <etext+0xca6>
ffffffffc0201658:	0000a617          	auipc	a2,0xa
ffffffffc020165c:	3e060613          	addi	a2,a2,992 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201660:	0d800593          	li	a1,216
ffffffffc0201664:	0000b517          	auipc	a0,0xb
ffffffffc0201668:	ab450513          	addi	a0,a0,-1356 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020166c:	ddffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201670:	0000b697          	auipc	a3,0xb
ffffffffc0201674:	ba868693          	addi	a3,a3,-1112 # ffffffffc020c218 <etext+0xc1e>
ffffffffc0201678:	0000a617          	auipc	a2,0xa
ffffffffc020167c:	3c060613          	addi	a2,a2,960 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201680:	0bf00593          	li	a1,191
ffffffffc0201684:	0000b517          	auipc	a0,0xb
ffffffffc0201688:	a9450513          	addi	a0,a0,-1388 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020168c:	dbffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201690:	0000b697          	auipc	a3,0xb
ffffffffc0201694:	b2068693          	addi	a3,a3,-1248 # ffffffffc020c1b0 <etext+0xbb6>
ffffffffc0201698:	0000a617          	auipc	a2,0xa
ffffffffc020169c:	3a060613          	addi	a2,a2,928 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02016a0:	0bc00593          	li	a1,188
ffffffffc02016a4:	0000b517          	auipc	a0,0xb
ffffffffc02016a8:	a7450513          	addi	a0,a0,-1420 # ffffffffc020c118 <etext+0xb1e>
ffffffffc02016ac:	d9ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02016b0:	0000b697          	auipc	a3,0xb
ffffffffc02016b4:	aa068693          	addi	a3,a3,-1376 # ffffffffc020c150 <etext+0xb56>
ffffffffc02016b8:	0000a617          	auipc	a2,0xa
ffffffffc02016bc:	38060613          	addi	a2,a2,896 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02016c0:	0d100593          	li	a1,209
ffffffffc02016c4:	0000b517          	auipc	a0,0xb
ffffffffc02016c8:	a5450513          	addi	a0,a0,-1452 # ffffffffc020c118 <etext+0xb1e>
ffffffffc02016cc:	d7ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02016d0:	0000b697          	auipc	a3,0xb
ffffffffc02016d4:	bc068693          	addi	a3,a3,-1088 # ffffffffc020c290 <etext+0xc96>
ffffffffc02016d8:	0000a617          	auipc	a2,0xa
ffffffffc02016dc:	36060613          	addi	a2,a2,864 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02016e0:	0cf00593          	li	a1,207
ffffffffc02016e4:	0000b517          	auipc	a0,0xb
ffffffffc02016e8:	a3450513          	addi	a0,a0,-1484 # ffffffffc020c118 <etext+0xb1e>
ffffffffc02016ec:	d5ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02016f0:	0000b697          	auipc	a3,0xb
ffffffffc02016f4:	b8868693          	addi	a3,a3,-1144 # ffffffffc020c278 <etext+0xc7e>
ffffffffc02016f8:	0000a617          	auipc	a2,0xa
ffffffffc02016fc:	34060613          	addi	a2,a2,832 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201700:	0ca00593          	li	a1,202
ffffffffc0201704:	0000b517          	auipc	a0,0xb
ffffffffc0201708:	a1450513          	addi	a0,a0,-1516 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020170c:	d3ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201710:	0000b697          	auipc	a3,0xb
ffffffffc0201714:	b4868693          	addi	a3,a3,-1208 # ffffffffc020c258 <etext+0xc5e>
ffffffffc0201718:	0000a617          	auipc	a2,0xa
ffffffffc020171c:	32060613          	addi	a2,a2,800 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201720:	0c100593          	li	a1,193
ffffffffc0201724:	0000b517          	auipc	a0,0xb
ffffffffc0201728:	9f450513          	addi	a0,a0,-1548 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020172c:	d1ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201730:	0000b697          	auipc	a3,0xb
ffffffffc0201734:	bb868693          	addi	a3,a3,-1096 # ffffffffc020c2e8 <etext+0xcee>
ffffffffc0201738:	0000a617          	auipc	a2,0xa
ffffffffc020173c:	30060613          	addi	a2,a2,768 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201740:	0f700593          	li	a1,247
ffffffffc0201744:	0000b517          	auipc	a0,0xb
ffffffffc0201748:	9d450513          	addi	a0,a0,-1580 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020174c:	cfffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201750:	0000b697          	auipc	a3,0xb
ffffffffc0201754:	b8868693          	addi	a3,a3,-1144 # ffffffffc020c2d8 <etext+0xcde>
ffffffffc0201758:	0000a617          	auipc	a2,0xa
ffffffffc020175c:	2e060613          	addi	a2,a2,736 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201760:	0de00593          	li	a1,222
ffffffffc0201764:	0000b517          	auipc	a0,0xb
ffffffffc0201768:	9b450513          	addi	a0,a0,-1612 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020176c:	cdffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201770:	0000b697          	auipc	a3,0xb
ffffffffc0201774:	b0868693          	addi	a3,a3,-1272 # ffffffffc020c278 <etext+0xc7e>
ffffffffc0201778:	0000a617          	auipc	a2,0xa
ffffffffc020177c:	2c060613          	addi	a2,a2,704 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201780:	0dc00593          	li	a1,220
ffffffffc0201784:	0000b517          	auipc	a0,0xb
ffffffffc0201788:	99450513          	addi	a0,a0,-1644 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020178c:	cbffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201790:	0000b697          	auipc	a3,0xb
ffffffffc0201794:	b2868693          	addi	a3,a3,-1240 # ffffffffc020c2b8 <etext+0xcbe>
ffffffffc0201798:	0000a617          	auipc	a2,0xa
ffffffffc020179c:	2a060613          	addi	a2,a2,672 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02017a0:	0db00593          	li	a1,219
ffffffffc02017a4:	0000b517          	auipc	a0,0xb
ffffffffc02017a8:	97450513          	addi	a0,a0,-1676 # ffffffffc020c118 <etext+0xb1e>
ffffffffc02017ac:	c9ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02017b0:	0000b697          	auipc	a3,0xb
ffffffffc02017b4:	9a068693          	addi	a3,a3,-1632 # ffffffffc020c150 <etext+0xb56>
ffffffffc02017b8:	0000a617          	auipc	a2,0xa
ffffffffc02017bc:	28060613          	addi	a2,a2,640 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02017c0:	0b800593          	li	a1,184
ffffffffc02017c4:	0000b517          	auipc	a0,0xb
ffffffffc02017c8:	95450513          	addi	a0,a0,-1708 # ffffffffc020c118 <etext+0xb1e>
ffffffffc02017cc:	c7ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02017d0:	0000b697          	auipc	a3,0xb
ffffffffc02017d4:	aa868693          	addi	a3,a3,-1368 # ffffffffc020c278 <etext+0xc7e>
ffffffffc02017d8:	0000a617          	auipc	a2,0xa
ffffffffc02017dc:	26060613          	addi	a2,a2,608 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02017e0:	0d500593          	li	a1,213
ffffffffc02017e4:	0000b517          	auipc	a0,0xb
ffffffffc02017e8:	93450513          	addi	a0,a0,-1740 # ffffffffc020c118 <etext+0xb1e>
ffffffffc02017ec:	c5ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02017f0:	0000b697          	auipc	a3,0xb
ffffffffc02017f4:	9a068693          	addi	a3,a3,-1632 # ffffffffc020c190 <etext+0xb96>
ffffffffc02017f8:	0000a617          	auipc	a2,0xa
ffffffffc02017fc:	24060613          	addi	a2,a2,576 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201800:	0d300593          	li	a1,211
ffffffffc0201804:	0000b517          	auipc	a0,0xb
ffffffffc0201808:	91450513          	addi	a0,a0,-1772 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020180c:	c3ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201810:	0000b697          	auipc	a3,0xb
ffffffffc0201814:	96068693          	addi	a3,a3,-1696 # ffffffffc020c170 <etext+0xb76>
ffffffffc0201818:	0000a617          	auipc	a2,0xa
ffffffffc020181c:	22060613          	addi	a2,a2,544 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201820:	0d200593          	li	a1,210
ffffffffc0201824:	0000b517          	auipc	a0,0xb
ffffffffc0201828:	8f450513          	addi	a0,a0,-1804 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020182c:	c1ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201830:	0000b697          	auipc	a3,0xb
ffffffffc0201834:	96068693          	addi	a3,a3,-1696 # ffffffffc020c190 <etext+0xb96>
ffffffffc0201838:	0000a617          	auipc	a2,0xa
ffffffffc020183c:	20060613          	addi	a2,a2,512 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201840:	0ba00593          	li	a1,186
ffffffffc0201844:	0000b517          	auipc	a0,0xb
ffffffffc0201848:	8d450513          	addi	a0,a0,-1836 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020184c:	bfffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201850:	0000b697          	auipc	a3,0xb
ffffffffc0201854:	be868693          	addi	a3,a3,-1048 # ffffffffc020c438 <etext+0xe3e>
ffffffffc0201858:	0000a617          	auipc	a2,0xa
ffffffffc020185c:	1e060613          	addi	a2,a2,480 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201860:	12400593          	li	a1,292
ffffffffc0201864:	0000b517          	auipc	a0,0xb
ffffffffc0201868:	8b450513          	addi	a0,a0,-1868 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020186c:	bdffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201870:	0000b697          	auipc	a3,0xb
ffffffffc0201874:	a6868693          	addi	a3,a3,-1432 # ffffffffc020c2d8 <etext+0xcde>
ffffffffc0201878:	0000a617          	auipc	a2,0xa
ffffffffc020187c:	1c060613          	addi	a2,a2,448 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201880:	11900593          	li	a1,281
ffffffffc0201884:	0000b517          	auipc	a0,0xb
ffffffffc0201888:	89450513          	addi	a0,a0,-1900 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020188c:	bbffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201890:	0000b697          	auipc	a3,0xb
ffffffffc0201894:	9e868693          	addi	a3,a3,-1560 # ffffffffc020c278 <etext+0xc7e>
ffffffffc0201898:	0000a617          	auipc	a2,0xa
ffffffffc020189c:	1a060613          	addi	a2,a2,416 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02018a0:	11700593          	li	a1,279
ffffffffc02018a4:	0000b517          	auipc	a0,0xb
ffffffffc02018a8:	87450513          	addi	a0,a0,-1932 # ffffffffc020c118 <etext+0xb1e>
ffffffffc02018ac:	b9ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02018b0:	0000b697          	auipc	a3,0xb
ffffffffc02018b4:	98868693          	addi	a3,a3,-1656 # ffffffffc020c238 <etext+0xc3e>
ffffffffc02018b8:	0000a617          	auipc	a2,0xa
ffffffffc02018bc:	18060613          	addi	a2,a2,384 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02018c0:	0c000593          	li	a1,192
ffffffffc02018c4:	0000b517          	auipc	a0,0xb
ffffffffc02018c8:	85450513          	addi	a0,a0,-1964 # ffffffffc020c118 <etext+0xb1e>
ffffffffc02018cc:	b7ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02018d0:	0000b697          	auipc	a3,0xb
ffffffffc02018d4:	b2868693          	addi	a3,a3,-1240 # ffffffffc020c3f8 <etext+0xdfe>
ffffffffc02018d8:	0000a617          	auipc	a2,0xa
ffffffffc02018dc:	16060613          	addi	a2,a2,352 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02018e0:	11100593          	li	a1,273
ffffffffc02018e4:	0000b517          	auipc	a0,0xb
ffffffffc02018e8:	83450513          	addi	a0,a0,-1996 # ffffffffc020c118 <etext+0xb1e>
ffffffffc02018ec:	b5ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02018f0:	0000b697          	auipc	a3,0xb
ffffffffc02018f4:	ae868693          	addi	a3,a3,-1304 # ffffffffc020c3d8 <etext+0xdde>
ffffffffc02018f8:	0000a617          	auipc	a2,0xa
ffffffffc02018fc:	14060613          	addi	a2,a2,320 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201900:	10f00593          	li	a1,271
ffffffffc0201904:	0000b517          	auipc	a0,0xb
ffffffffc0201908:	81450513          	addi	a0,a0,-2028 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020190c:	b3ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201910:	0000b697          	auipc	a3,0xb
ffffffffc0201914:	aa068693          	addi	a3,a3,-1376 # ffffffffc020c3b0 <etext+0xdb6>
ffffffffc0201918:	0000a617          	auipc	a2,0xa
ffffffffc020191c:	12060613          	addi	a2,a2,288 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201920:	10d00593          	li	a1,269
ffffffffc0201924:	0000a517          	auipc	a0,0xa
ffffffffc0201928:	7f450513          	addi	a0,a0,2036 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020192c:	b1ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201930:	0000b697          	auipc	a3,0xb
ffffffffc0201934:	a5868693          	addi	a3,a3,-1448 # ffffffffc020c388 <etext+0xd8e>
ffffffffc0201938:	0000a617          	auipc	a2,0xa
ffffffffc020193c:	10060613          	addi	a2,a2,256 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201940:	10c00593          	li	a1,268
ffffffffc0201944:	0000a517          	auipc	a0,0xa
ffffffffc0201948:	7d450513          	addi	a0,a0,2004 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020194c:	afffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201950:	0000b697          	auipc	a3,0xb
ffffffffc0201954:	a2868693          	addi	a3,a3,-1496 # ffffffffc020c378 <etext+0xd7e>
ffffffffc0201958:	0000a617          	auipc	a2,0xa
ffffffffc020195c:	0e060613          	addi	a2,a2,224 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201960:	10700593          	li	a1,263
ffffffffc0201964:	0000a517          	auipc	a0,0xa
ffffffffc0201968:	7b450513          	addi	a0,a0,1972 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020196c:	adffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201970:	0000b697          	auipc	a3,0xb
ffffffffc0201974:	90868693          	addi	a3,a3,-1784 # ffffffffc020c278 <etext+0xc7e>
ffffffffc0201978:	0000a617          	auipc	a2,0xa
ffffffffc020197c:	0c060613          	addi	a2,a2,192 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201980:	10600593          	li	a1,262
ffffffffc0201984:	0000a517          	auipc	a0,0xa
ffffffffc0201988:	79450513          	addi	a0,a0,1940 # ffffffffc020c118 <etext+0xb1e>
ffffffffc020198c:	abffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201990:	0000b697          	auipc	a3,0xb
ffffffffc0201994:	9c868693          	addi	a3,a3,-1592 # ffffffffc020c358 <etext+0xd5e>
ffffffffc0201998:	0000a617          	auipc	a2,0xa
ffffffffc020199c:	0a060613          	addi	a2,a2,160 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02019a0:	10500593          	li	a1,261
ffffffffc02019a4:	0000a517          	auipc	a0,0xa
ffffffffc02019a8:	77450513          	addi	a0,a0,1908 # ffffffffc020c118 <etext+0xb1e>
ffffffffc02019ac:	a9ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02019b0:	0000b697          	auipc	a3,0xb
ffffffffc02019b4:	97868693          	addi	a3,a3,-1672 # ffffffffc020c328 <etext+0xd2e>
ffffffffc02019b8:	0000a617          	auipc	a2,0xa
ffffffffc02019bc:	08060613          	addi	a2,a2,128 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02019c0:	10400593          	li	a1,260
ffffffffc02019c4:	0000a517          	auipc	a0,0xa
ffffffffc02019c8:	75450513          	addi	a0,a0,1876 # ffffffffc020c118 <etext+0xb1e>
ffffffffc02019cc:	a7ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02019d0:	0000b697          	auipc	a3,0xb
ffffffffc02019d4:	94068693          	addi	a3,a3,-1728 # ffffffffc020c310 <etext+0xd16>
ffffffffc02019d8:	0000a617          	auipc	a2,0xa
ffffffffc02019dc:	06060613          	addi	a2,a2,96 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02019e0:	10300593          	li	a1,259
ffffffffc02019e4:	0000a517          	auipc	a0,0xa
ffffffffc02019e8:	73450513          	addi	a0,a0,1844 # ffffffffc020c118 <etext+0xb1e>
ffffffffc02019ec:	a5ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02019f0:	0000b697          	auipc	a3,0xb
ffffffffc02019f4:	88868693          	addi	a3,a3,-1912 # ffffffffc020c278 <etext+0xc7e>
ffffffffc02019f8:	0000a617          	auipc	a2,0xa
ffffffffc02019fc:	04060613          	addi	a2,a2,64 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201a00:	0fd00593          	li	a1,253
ffffffffc0201a04:	0000a517          	auipc	a0,0xa
ffffffffc0201a08:	71450513          	addi	a0,a0,1812 # ffffffffc020c118 <etext+0xb1e>
ffffffffc0201a0c:	a3ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201a10:	0000b697          	auipc	a3,0xb
ffffffffc0201a14:	8e868693          	addi	a3,a3,-1816 # ffffffffc020c2f8 <etext+0xcfe>
ffffffffc0201a18:	0000a617          	auipc	a2,0xa
ffffffffc0201a1c:	02060613          	addi	a2,a2,32 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201a20:	0f800593          	li	a1,248
ffffffffc0201a24:	0000a517          	auipc	a0,0xa
ffffffffc0201a28:	6f450513          	addi	a0,a0,1780 # ffffffffc020c118 <etext+0xb1e>
ffffffffc0201a2c:	a1ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201a30:	0000b697          	auipc	a3,0xb
ffffffffc0201a34:	9e868693          	addi	a3,a3,-1560 # ffffffffc020c418 <etext+0xe1e>
ffffffffc0201a38:	0000a617          	auipc	a2,0xa
ffffffffc0201a3c:	00060613          	mv	a2,a2
ffffffffc0201a40:	11600593          	li	a1,278
ffffffffc0201a44:	0000a517          	auipc	a0,0xa
ffffffffc0201a48:	6d450513          	addi	a0,a0,1748 # ffffffffc020c118 <etext+0xb1e>
ffffffffc0201a4c:	9fffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201a50:	0000b697          	auipc	a3,0xb
ffffffffc0201a54:	9f868693          	addi	a3,a3,-1544 # ffffffffc020c448 <etext+0xe4e>
ffffffffc0201a58:	0000a617          	auipc	a2,0xa
ffffffffc0201a5c:	fe060613          	addi	a2,a2,-32 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201a60:	12500593          	li	a1,293
ffffffffc0201a64:	0000a517          	auipc	a0,0xa
ffffffffc0201a68:	6b450513          	addi	a0,a0,1716 # ffffffffc020c118 <etext+0xb1e>
ffffffffc0201a6c:	9dffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201a70:	0000a697          	auipc	a3,0xa
ffffffffc0201a74:	6c068693          	addi	a3,a3,1728 # ffffffffc020c130 <etext+0xb36>
ffffffffc0201a78:	0000a617          	auipc	a2,0xa
ffffffffc0201a7c:	fc060613          	addi	a2,a2,-64 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201a80:	0f200593          	li	a1,242
ffffffffc0201a84:	0000a517          	auipc	a0,0xa
ffffffffc0201a88:	69450513          	addi	a0,a0,1684 # ffffffffc020c118 <etext+0xb1e>
ffffffffc0201a8c:	9bffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201a90:	0000a697          	auipc	a3,0xa
ffffffffc0201a94:	6e068693          	addi	a3,a3,1760 # ffffffffc020c170 <etext+0xb76>
ffffffffc0201a98:	0000a617          	auipc	a2,0xa
ffffffffc0201a9c:	fa060613          	addi	a2,a2,-96 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201aa0:	0b900593          	li	a1,185
ffffffffc0201aa4:	0000a517          	auipc	a0,0xa
ffffffffc0201aa8:	67450513          	addi	a0,a0,1652 # ffffffffc020c118 <etext+0xb1e>
ffffffffc0201aac:	99ffe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201ab0 <default_free_pages>:
ffffffffc0201ab0:	1141                	addi	sp,sp,-16
ffffffffc0201ab2:	e406                	sd	ra,8(sp)
ffffffffc0201ab4:	14058663          	beqz	a1,ffffffffc0201c00 <default_free_pages+0x150>
ffffffffc0201ab8:	00659713          	slli	a4,a1,0x6
ffffffffc0201abc:	00e506b3          	add	a3,a0,a4
ffffffffc0201ac0:	87aa                	mv	a5,a0
ffffffffc0201ac2:	c30d                	beqz	a4,ffffffffc0201ae4 <default_free_pages+0x34>
ffffffffc0201ac4:	6798                	ld	a4,8(a5)
ffffffffc0201ac6:	8b05                	andi	a4,a4,1
ffffffffc0201ac8:	10071c63          	bnez	a4,ffffffffc0201be0 <default_free_pages+0x130>
ffffffffc0201acc:	6798                	ld	a4,8(a5)
ffffffffc0201ace:	8b09                	andi	a4,a4,2
ffffffffc0201ad0:	10071863          	bnez	a4,ffffffffc0201be0 <default_free_pages+0x130>
ffffffffc0201ad4:	0007b423          	sd	zero,8(a5)
ffffffffc0201ad8:	0007a023          	sw	zero,0(a5)
ffffffffc0201adc:	04078793          	addi	a5,a5,64
ffffffffc0201ae0:	fed792e3          	bne	a5,a3,ffffffffc0201ac4 <default_free_pages+0x14>
ffffffffc0201ae4:	c90c                	sw	a1,16(a0)
ffffffffc0201ae6:	00850893          	addi	a7,a0,8
ffffffffc0201aea:	4789                	li	a5,2
ffffffffc0201aec:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc0201af0:	00090717          	auipc	a4,0x90
ffffffffc0201af4:	cc872703          	lw	a4,-824(a4) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201af8:	00090697          	auipc	a3,0x90
ffffffffc0201afc:	cb068693          	addi	a3,a3,-848 # ffffffffc02917a8 <free_area>
ffffffffc0201b00:	669c                	ld	a5,8(a3)
ffffffffc0201b02:	9f2d                	addw	a4,a4,a1
ffffffffc0201b04:	ca98                	sw	a4,16(a3)
ffffffffc0201b06:	0ad78163          	beq	a5,a3,ffffffffc0201ba8 <default_free_pages+0xf8>
ffffffffc0201b0a:	fe878713          	addi	a4,a5,-24
ffffffffc0201b0e:	4581                	li	a1,0
ffffffffc0201b10:	01850613          	addi	a2,a0,24
ffffffffc0201b14:	00e56a63          	bltu	a0,a4,ffffffffc0201b28 <default_free_pages+0x78>
ffffffffc0201b18:	6798                	ld	a4,8(a5)
ffffffffc0201b1a:	04d70c63          	beq	a4,a3,ffffffffc0201b72 <default_free_pages+0xc2>
ffffffffc0201b1e:	87ba                	mv	a5,a4
ffffffffc0201b20:	fe878713          	addi	a4,a5,-24
ffffffffc0201b24:	fee57ae3          	bgeu	a0,a4,ffffffffc0201b18 <default_free_pages+0x68>
ffffffffc0201b28:	c199                	beqz	a1,ffffffffc0201b2e <default_free_pages+0x7e>
ffffffffc0201b2a:	0106b023          	sd	a6,0(a3)
ffffffffc0201b2e:	6398                	ld	a4,0(a5)
ffffffffc0201b30:	e390                	sd	a2,0(a5)
ffffffffc0201b32:	e710                	sd	a2,8(a4)
ffffffffc0201b34:	ed18                	sd	a4,24(a0)
ffffffffc0201b36:	f11c                	sd	a5,32(a0)
ffffffffc0201b38:	00d70d63          	beq	a4,a3,ffffffffc0201b52 <default_free_pages+0xa2>
ffffffffc0201b3c:	ff872583          	lw	a1,-8(a4)
ffffffffc0201b40:	fe870613          	addi	a2,a4,-24
ffffffffc0201b44:	02059813          	slli	a6,a1,0x20
ffffffffc0201b48:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201b4c:	97b2                	add	a5,a5,a2
ffffffffc0201b4e:	02f50c63          	beq	a0,a5,ffffffffc0201b86 <default_free_pages+0xd6>
ffffffffc0201b52:	711c                	ld	a5,32(a0)
ffffffffc0201b54:	00d78c63          	beq	a5,a3,ffffffffc0201b6c <default_free_pages+0xbc>
ffffffffc0201b58:	4910                	lw	a2,16(a0)
ffffffffc0201b5a:	fe878693          	addi	a3,a5,-24
ffffffffc0201b5e:	02061593          	slli	a1,a2,0x20
ffffffffc0201b62:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201b66:	972a                	add	a4,a4,a0
ffffffffc0201b68:	04e68c63          	beq	a3,a4,ffffffffc0201bc0 <default_free_pages+0x110>
ffffffffc0201b6c:	60a2                	ld	ra,8(sp)
ffffffffc0201b6e:	0141                	addi	sp,sp,16
ffffffffc0201b70:	8082                	ret
ffffffffc0201b72:	e790                	sd	a2,8(a5)
ffffffffc0201b74:	f114                	sd	a3,32(a0)
ffffffffc0201b76:	6798                	ld	a4,8(a5)
ffffffffc0201b78:	ed1c                	sd	a5,24(a0)
ffffffffc0201b7a:	8832                	mv	a6,a2
ffffffffc0201b7c:	02d70f63          	beq	a4,a3,ffffffffc0201bba <default_free_pages+0x10a>
ffffffffc0201b80:	4585                	li	a1,1
ffffffffc0201b82:	87ba                	mv	a5,a4
ffffffffc0201b84:	bf71                	j	ffffffffc0201b20 <default_free_pages+0x70>
ffffffffc0201b86:	491c                	lw	a5,16(a0)
ffffffffc0201b88:	5875                	li	a6,-3
ffffffffc0201b8a:	9fad                	addw	a5,a5,a1
ffffffffc0201b8c:	fef72c23          	sw	a5,-8(a4)
ffffffffc0201b90:	6108b02f          	amoand.d	zero,a6,(a7)
ffffffffc0201b94:	01853803          	ld	a6,24(a0)
ffffffffc0201b98:	710c                	ld	a1,32(a0)
ffffffffc0201b9a:	8532                	mv	a0,a2
ffffffffc0201b9c:	00b83423          	sd	a1,8(a6)
ffffffffc0201ba0:	671c                	ld	a5,8(a4)
ffffffffc0201ba2:	0105b023          	sd	a6,0(a1)
ffffffffc0201ba6:	b77d                	j	ffffffffc0201b54 <default_free_pages+0xa4>
ffffffffc0201ba8:	60a2                	ld	ra,8(sp)
ffffffffc0201baa:	01850713          	addi	a4,a0,24
ffffffffc0201bae:	f11c                	sd	a5,32(a0)
ffffffffc0201bb0:	ed1c                	sd	a5,24(a0)
ffffffffc0201bb2:	e398                	sd	a4,0(a5)
ffffffffc0201bb4:	e798                	sd	a4,8(a5)
ffffffffc0201bb6:	0141                	addi	sp,sp,16
ffffffffc0201bb8:	8082                	ret
ffffffffc0201bba:	e290                	sd	a2,0(a3)
ffffffffc0201bbc:	873e                	mv	a4,a5
ffffffffc0201bbe:	bfad                	j	ffffffffc0201b38 <default_free_pages+0x88>
ffffffffc0201bc0:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201bc4:	56f5                	li	a3,-3
ffffffffc0201bc6:	9f31                	addw	a4,a4,a2
ffffffffc0201bc8:	c918                	sw	a4,16(a0)
ffffffffc0201bca:	ff078713          	addi	a4,a5,-16
ffffffffc0201bce:	60d7302f          	amoand.d	zero,a3,(a4)
ffffffffc0201bd2:	6398                	ld	a4,0(a5)
ffffffffc0201bd4:	679c                	ld	a5,8(a5)
ffffffffc0201bd6:	60a2                	ld	ra,8(sp)
ffffffffc0201bd8:	e71c                	sd	a5,8(a4)
ffffffffc0201bda:	e398                	sd	a4,0(a5)
ffffffffc0201bdc:	0141                	addi	sp,sp,16
ffffffffc0201bde:	8082                	ret
ffffffffc0201be0:	0000b697          	auipc	a3,0xb
ffffffffc0201be4:	88068693          	addi	a3,a3,-1920 # ffffffffc020c460 <etext+0xe66>
ffffffffc0201be8:	0000a617          	auipc	a2,0xa
ffffffffc0201bec:	e5060613          	addi	a2,a2,-432 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201bf0:	08200593          	li	a1,130
ffffffffc0201bf4:	0000a517          	auipc	a0,0xa
ffffffffc0201bf8:	52450513          	addi	a0,a0,1316 # ffffffffc020c118 <etext+0xb1e>
ffffffffc0201bfc:	84ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201c00:	0000b697          	auipc	a3,0xb
ffffffffc0201c04:	85868693          	addi	a3,a3,-1960 # ffffffffc020c458 <etext+0xe5e>
ffffffffc0201c08:	0000a617          	auipc	a2,0xa
ffffffffc0201c0c:	e3060613          	addi	a2,a2,-464 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201c10:	07f00593          	li	a1,127
ffffffffc0201c14:	0000a517          	auipc	a0,0xa
ffffffffc0201c18:	50450513          	addi	a0,a0,1284 # ffffffffc020c118 <etext+0xb1e>
ffffffffc0201c1c:	82ffe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201c20 <default_alloc_pages>:
ffffffffc0201c20:	c951                	beqz	a0,ffffffffc0201cb4 <default_alloc_pages+0x94>
ffffffffc0201c22:	00090597          	auipc	a1,0x90
ffffffffc0201c26:	b965a583          	lw	a1,-1130(a1) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201c2a:	86aa                	mv	a3,a0
ffffffffc0201c2c:	02059793          	slli	a5,a1,0x20
ffffffffc0201c30:	9381                	srli	a5,a5,0x20
ffffffffc0201c32:	00a7ef63          	bltu	a5,a0,ffffffffc0201c50 <default_alloc_pages+0x30>
ffffffffc0201c36:	00090617          	auipc	a2,0x90
ffffffffc0201c3a:	b7260613          	addi	a2,a2,-1166 # ffffffffc02917a8 <free_area>
ffffffffc0201c3e:	87b2                	mv	a5,a2
ffffffffc0201c40:	a029                	j	ffffffffc0201c4a <default_alloc_pages+0x2a>
ffffffffc0201c42:	ff87e703          	lwu	a4,-8(a5)
ffffffffc0201c46:	00d77763          	bgeu	a4,a3,ffffffffc0201c54 <default_alloc_pages+0x34>
ffffffffc0201c4a:	679c                	ld	a5,8(a5)
ffffffffc0201c4c:	fec79be3          	bne	a5,a2,ffffffffc0201c42 <default_alloc_pages+0x22>
ffffffffc0201c50:	4501                	li	a0,0
ffffffffc0201c52:	8082                	ret
ffffffffc0201c54:	ff87a883          	lw	a7,-8(a5)
ffffffffc0201c58:	0007b803          	ld	a6,0(a5)
ffffffffc0201c5c:	6798                	ld	a4,8(a5)
ffffffffc0201c5e:	02089313          	slli	t1,a7,0x20
ffffffffc0201c62:	02035313          	srli	t1,t1,0x20
ffffffffc0201c66:	00e83423          	sd	a4,8(a6)
ffffffffc0201c6a:	01073023          	sd	a6,0(a4)
ffffffffc0201c6e:	fe878513          	addi	a0,a5,-24
ffffffffc0201c72:	0266fa63          	bgeu	a3,t1,ffffffffc0201ca6 <default_alloc_pages+0x86>
ffffffffc0201c76:	00669713          	slli	a4,a3,0x6
ffffffffc0201c7a:	40d888bb          	subw	a7,a7,a3
ffffffffc0201c7e:	972a                	add	a4,a4,a0
ffffffffc0201c80:	01172823          	sw	a7,16(a4)
ffffffffc0201c84:	00870313          	addi	t1,a4,8
ffffffffc0201c88:	4889                	li	a7,2
ffffffffc0201c8a:	4113302f          	amoor.d	zero,a7,(t1)
ffffffffc0201c8e:	00883883          	ld	a7,8(a6)
ffffffffc0201c92:	01870313          	addi	t1,a4,24
ffffffffc0201c96:	0068b023          	sd	t1,0(a7) # 10000000 <_binary_bin_sfs_img_size+0xff8ad00>
ffffffffc0201c9a:	00683423          	sd	t1,8(a6)
ffffffffc0201c9e:	03173023          	sd	a7,32(a4)
ffffffffc0201ca2:	01073c23          	sd	a6,24(a4)
ffffffffc0201ca6:	9d95                	subw	a1,a1,a3
ffffffffc0201ca8:	ca0c                	sw	a1,16(a2)
ffffffffc0201caa:	5775                	li	a4,-3
ffffffffc0201cac:	17c1                	addi	a5,a5,-16
ffffffffc0201cae:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0201cb2:	8082                	ret
ffffffffc0201cb4:	1141                	addi	sp,sp,-16
ffffffffc0201cb6:	0000a697          	auipc	a3,0xa
ffffffffc0201cba:	7a268693          	addi	a3,a3,1954 # ffffffffc020c458 <etext+0xe5e>
ffffffffc0201cbe:	0000a617          	auipc	a2,0xa
ffffffffc0201cc2:	d7a60613          	addi	a2,a2,-646 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201cc6:	06100593          	li	a1,97
ffffffffc0201cca:	0000a517          	auipc	a0,0xa
ffffffffc0201cce:	44e50513          	addi	a0,a0,1102 # ffffffffc020c118 <etext+0xb1e>
ffffffffc0201cd2:	e406                	sd	ra,8(sp)
ffffffffc0201cd4:	f76fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201cd8 <default_init_memmap>:
ffffffffc0201cd8:	1141                	addi	sp,sp,-16
ffffffffc0201cda:	e406                	sd	ra,8(sp)
ffffffffc0201cdc:	c9e1                	beqz	a1,ffffffffc0201dac <default_init_memmap+0xd4>
ffffffffc0201cde:	00659713          	slli	a4,a1,0x6
ffffffffc0201ce2:	00e506b3          	add	a3,a0,a4
ffffffffc0201ce6:	87aa                	mv	a5,a0
ffffffffc0201ce8:	cf11                	beqz	a4,ffffffffc0201d04 <default_init_memmap+0x2c>
ffffffffc0201cea:	6798                	ld	a4,8(a5)
ffffffffc0201cec:	8b05                	andi	a4,a4,1
ffffffffc0201cee:	cf59                	beqz	a4,ffffffffc0201d8c <default_init_memmap+0xb4>
ffffffffc0201cf0:	0007a823          	sw	zero,16(a5)
ffffffffc0201cf4:	0007b423          	sd	zero,8(a5)
ffffffffc0201cf8:	0007a023          	sw	zero,0(a5)
ffffffffc0201cfc:	04078793          	addi	a5,a5,64
ffffffffc0201d00:	fed795e3          	bne	a5,a3,ffffffffc0201cea <default_init_memmap+0x12>
ffffffffc0201d04:	c90c                	sw	a1,16(a0)
ffffffffc0201d06:	4789                	li	a5,2
ffffffffc0201d08:	00850713          	addi	a4,a0,8
ffffffffc0201d0c:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0201d10:	00090717          	auipc	a4,0x90
ffffffffc0201d14:	aa872703          	lw	a4,-1368(a4) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201d18:	00090697          	auipc	a3,0x90
ffffffffc0201d1c:	a9068693          	addi	a3,a3,-1392 # ffffffffc02917a8 <free_area>
ffffffffc0201d20:	669c                	ld	a5,8(a3)
ffffffffc0201d22:	9f2d                	addw	a4,a4,a1
ffffffffc0201d24:	ca98                	sw	a4,16(a3)
ffffffffc0201d26:	04d78663          	beq	a5,a3,ffffffffc0201d72 <default_init_memmap+0x9a>
ffffffffc0201d2a:	fe878713          	addi	a4,a5,-24
ffffffffc0201d2e:	4581                	li	a1,0
ffffffffc0201d30:	01850613          	addi	a2,a0,24
ffffffffc0201d34:	00e56a63          	bltu	a0,a4,ffffffffc0201d48 <default_init_memmap+0x70>
ffffffffc0201d38:	6798                	ld	a4,8(a5)
ffffffffc0201d3a:	02d70263          	beq	a4,a3,ffffffffc0201d5e <default_init_memmap+0x86>
ffffffffc0201d3e:	87ba                	mv	a5,a4
ffffffffc0201d40:	fe878713          	addi	a4,a5,-24
ffffffffc0201d44:	fee57ae3          	bgeu	a0,a4,ffffffffc0201d38 <default_init_memmap+0x60>
ffffffffc0201d48:	c199                	beqz	a1,ffffffffc0201d4e <default_init_memmap+0x76>
ffffffffc0201d4a:	0106b023          	sd	a6,0(a3)
ffffffffc0201d4e:	6398                	ld	a4,0(a5)
ffffffffc0201d50:	60a2                	ld	ra,8(sp)
ffffffffc0201d52:	e390                	sd	a2,0(a5)
ffffffffc0201d54:	e710                	sd	a2,8(a4)
ffffffffc0201d56:	ed18                	sd	a4,24(a0)
ffffffffc0201d58:	f11c                	sd	a5,32(a0)
ffffffffc0201d5a:	0141                	addi	sp,sp,16
ffffffffc0201d5c:	8082                	ret
ffffffffc0201d5e:	e790                	sd	a2,8(a5)
ffffffffc0201d60:	f114                	sd	a3,32(a0)
ffffffffc0201d62:	6798                	ld	a4,8(a5)
ffffffffc0201d64:	ed1c                	sd	a5,24(a0)
ffffffffc0201d66:	8832                	mv	a6,a2
ffffffffc0201d68:	00d70e63          	beq	a4,a3,ffffffffc0201d84 <default_init_memmap+0xac>
ffffffffc0201d6c:	4585                	li	a1,1
ffffffffc0201d6e:	87ba                	mv	a5,a4
ffffffffc0201d70:	bfc1                	j	ffffffffc0201d40 <default_init_memmap+0x68>
ffffffffc0201d72:	60a2                	ld	ra,8(sp)
ffffffffc0201d74:	01850713          	addi	a4,a0,24
ffffffffc0201d78:	f11c                	sd	a5,32(a0)
ffffffffc0201d7a:	ed1c                	sd	a5,24(a0)
ffffffffc0201d7c:	e398                	sd	a4,0(a5)
ffffffffc0201d7e:	e798                	sd	a4,8(a5)
ffffffffc0201d80:	0141                	addi	sp,sp,16
ffffffffc0201d82:	8082                	ret
ffffffffc0201d84:	60a2                	ld	ra,8(sp)
ffffffffc0201d86:	e290                	sd	a2,0(a3)
ffffffffc0201d88:	0141                	addi	sp,sp,16
ffffffffc0201d8a:	8082                	ret
ffffffffc0201d8c:	0000a697          	auipc	a3,0xa
ffffffffc0201d90:	6fc68693          	addi	a3,a3,1788 # ffffffffc020c488 <etext+0xe8e>
ffffffffc0201d94:	0000a617          	auipc	a2,0xa
ffffffffc0201d98:	ca460613          	addi	a2,a2,-860 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201d9c:	04800593          	li	a1,72
ffffffffc0201da0:	0000a517          	auipc	a0,0xa
ffffffffc0201da4:	37850513          	addi	a0,a0,888 # ffffffffc020c118 <etext+0xb1e>
ffffffffc0201da8:	ea2fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201dac:	0000a697          	auipc	a3,0xa
ffffffffc0201db0:	6ac68693          	addi	a3,a3,1708 # ffffffffc020c458 <etext+0xe5e>
ffffffffc0201db4:	0000a617          	auipc	a2,0xa
ffffffffc0201db8:	c8460613          	addi	a2,a2,-892 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0201dbc:	04500593          	li	a1,69
ffffffffc0201dc0:	0000a517          	auipc	a0,0xa
ffffffffc0201dc4:	35850513          	addi	a0,a0,856 # ffffffffc020c118 <etext+0xb1e>
ffffffffc0201dc8:	e82fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201dcc <slob_free>:
ffffffffc0201dcc:	c531                	beqz	a0,ffffffffc0201e18 <slob_free+0x4c>
ffffffffc0201dce:	e9b9                	bnez	a1,ffffffffc0201e24 <slob_free+0x58>
ffffffffc0201dd0:	100027f3          	csrr	a5,sstatus
ffffffffc0201dd4:	8b89                	andi	a5,a5,2
ffffffffc0201dd6:	4581                	li	a1,0
ffffffffc0201dd8:	efb1                	bnez	a5,ffffffffc0201e34 <slob_free+0x68>
ffffffffc0201dda:	0008f797          	auipc	a5,0x8f
ffffffffc0201dde:	2767b783          	ld	a5,630(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201de2:	873e                	mv	a4,a5
ffffffffc0201de4:	679c                	ld	a5,8(a5)
ffffffffc0201de6:	02a77a63          	bgeu	a4,a0,ffffffffc0201e1a <slob_free+0x4e>
ffffffffc0201dea:	00f56463          	bltu	a0,a5,ffffffffc0201df2 <slob_free+0x26>
ffffffffc0201dee:	fef76ae3          	bltu	a4,a5,ffffffffc0201de2 <slob_free+0x16>
ffffffffc0201df2:	4110                	lw	a2,0(a0)
ffffffffc0201df4:	00461693          	slli	a3,a2,0x4
ffffffffc0201df8:	96aa                	add	a3,a3,a0
ffffffffc0201dfa:	0ad78463          	beq	a5,a3,ffffffffc0201ea2 <slob_free+0xd6>
ffffffffc0201dfe:	4310                	lw	a2,0(a4)
ffffffffc0201e00:	e51c                	sd	a5,8(a0)
ffffffffc0201e02:	00461693          	slli	a3,a2,0x4
ffffffffc0201e06:	96ba                	add	a3,a3,a4
ffffffffc0201e08:	08d50163          	beq	a0,a3,ffffffffc0201e8a <slob_free+0xbe>
ffffffffc0201e0c:	e708                	sd	a0,8(a4)
ffffffffc0201e0e:	0008f797          	auipc	a5,0x8f
ffffffffc0201e12:	24e7b123          	sd	a4,578(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201e16:	e9a5                	bnez	a1,ffffffffc0201e86 <slob_free+0xba>
ffffffffc0201e18:	8082                	ret
ffffffffc0201e1a:	fcf574e3          	bgeu	a0,a5,ffffffffc0201de2 <slob_free+0x16>
ffffffffc0201e1e:	fcf762e3          	bltu	a4,a5,ffffffffc0201de2 <slob_free+0x16>
ffffffffc0201e22:	bfc1                	j	ffffffffc0201df2 <slob_free+0x26>
ffffffffc0201e24:	25bd                	addiw	a1,a1,15
ffffffffc0201e26:	8191                	srli	a1,a1,0x4
ffffffffc0201e28:	c10c                	sw	a1,0(a0)
ffffffffc0201e2a:	100027f3          	csrr	a5,sstatus
ffffffffc0201e2e:	8b89                	andi	a5,a5,2
ffffffffc0201e30:	4581                	li	a1,0
ffffffffc0201e32:	d7c5                	beqz	a5,ffffffffc0201dda <slob_free+0xe>
ffffffffc0201e34:	1101                	addi	sp,sp,-32
ffffffffc0201e36:	e42a                	sd	a0,8(sp)
ffffffffc0201e38:	ec06                	sd	ra,24(sp)
ffffffffc0201e3a:	e37fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0201e3e:	6522                	ld	a0,8(sp)
ffffffffc0201e40:	0008f797          	auipc	a5,0x8f
ffffffffc0201e44:	2107b783          	ld	a5,528(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201e48:	4585                	li	a1,1
ffffffffc0201e4a:	873e                	mv	a4,a5
ffffffffc0201e4c:	679c                	ld	a5,8(a5)
ffffffffc0201e4e:	06a77663          	bgeu	a4,a0,ffffffffc0201eba <slob_free+0xee>
ffffffffc0201e52:	00f56463          	bltu	a0,a5,ffffffffc0201e5a <slob_free+0x8e>
ffffffffc0201e56:	fef76ae3          	bltu	a4,a5,ffffffffc0201e4a <slob_free+0x7e>
ffffffffc0201e5a:	4110                	lw	a2,0(a0)
ffffffffc0201e5c:	00461693          	slli	a3,a2,0x4
ffffffffc0201e60:	96aa                	add	a3,a3,a0
ffffffffc0201e62:	06d78363          	beq	a5,a3,ffffffffc0201ec8 <slob_free+0xfc>
ffffffffc0201e66:	4310                	lw	a2,0(a4)
ffffffffc0201e68:	e51c                	sd	a5,8(a0)
ffffffffc0201e6a:	00461693          	slli	a3,a2,0x4
ffffffffc0201e6e:	96ba                	add	a3,a3,a4
ffffffffc0201e70:	06d50163          	beq	a0,a3,ffffffffc0201ed2 <slob_free+0x106>
ffffffffc0201e74:	e708                	sd	a0,8(a4)
ffffffffc0201e76:	0008f797          	auipc	a5,0x8f
ffffffffc0201e7a:	1ce7bd23          	sd	a4,474(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201e7e:	e1a9                	bnez	a1,ffffffffc0201ec0 <slob_free+0xf4>
ffffffffc0201e80:	60e2                	ld	ra,24(sp)
ffffffffc0201e82:	6105                	addi	sp,sp,32
ffffffffc0201e84:	8082                	ret
ffffffffc0201e86:	de5fe06f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc0201e8a:	4114                	lw	a3,0(a0)
ffffffffc0201e8c:	853e                	mv	a0,a5
ffffffffc0201e8e:	e708                	sd	a0,8(a4)
ffffffffc0201e90:	00c687bb          	addw	a5,a3,a2
ffffffffc0201e94:	c31c                	sw	a5,0(a4)
ffffffffc0201e96:	0008f797          	auipc	a5,0x8f
ffffffffc0201e9a:	1ae7bd23          	sd	a4,442(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201e9e:	ddad                	beqz	a1,ffffffffc0201e18 <slob_free+0x4c>
ffffffffc0201ea0:	b7dd                	j	ffffffffc0201e86 <slob_free+0xba>
ffffffffc0201ea2:	4394                	lw	a3,0(a5)
ffffffffc0201ea4:	679c                	ld	a5,8(a5)
ffffffffc0201ea6:	9eb1                	addw	a3,a3,a2
ffffffffc0201ea8:	c114                	sw	a3,0(a0)
ffffffffc0201eaa:	4310                	lw	a2,0(a4)
ffffffffc0201eac:	e51c                	sd	a5,8(a0)
ffffffffc0201eae:	00461693          	slli	a3,a2,0x4
ffffffffc0201eb2:	96ba                	add	a3,a3,a4
ffffffffc0201eb4:	f4d51ce3          	bne	a0,a3,ffffffffc0201e0c <slob_free+0x40>
ffffffffc0201eb8:	bfc9                	j	ffffffffc0201e8a <slob_free+0xbe>
ffffffffc0201eba:	f8f56ee3          	bltu	a0,a5,ffffffffc0201e56 <slob_free+0x8a>
ffffffffc0201ebe:	b771                	j	ffffffffc0201e4a <slob_free+0x7e>
ffffffffc0201ec0:	60e2                	ld	ra,24(sp)
ffffffffc0201ec2:	6105                	addi	sp,sp,32
ffffffffc0201ec4:	da7fe06f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc0201ec8:	4394                	lw	a3,0(a5)
ffffffffc0201eca:	679c                	ld	a5,8(a5)
ffffffffc0201ecc:	9eb1                	addw	a3,a3,a2
ffffffffc0201ece:	c114                	sw	a3,0(a0)
ffffffffc0201ed0:	bf59                	j	ffffffffc0201e66 <slob_free+0x9a>
ffffffffc0201ed2:	4114                	lw	a3,0(a0)
ffffffffc0201ed4:	853e                	mv	a0,a5
ffffffffc0201ed6:	00c687bb          	addw	a5,a3,a2
ffffffffc0201eda:	c31c                	sw	a5,0(a4)
ffffffffc0201edc:	bf61                	j	ffffffffc0201e74 <slob_free+0xa8>

ffffffffc0201ede <__slob_get_free_pages.constprop.0>:
ffffffffc0201ede:	4785                	li	a5,1
ffffffffc0201ee0:	1141                	addi	sp,sp,-16
ffffffffc0201ee2:	00a7953b          	sllw	a0,a5,a0
ffffffffc0201ee6:	e406                	sd	ra,8(sp)
ffffffffc0201ee8:	32c000ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc0201eec:	c91d                	beqz	a0,ffffffffc0201f22 <__slob_get_free_pages.constprop.0+0x44>
ffffffffc0201eee:	00095697          	auipc	a3,0x95
ffffffffc0201ef2:	9ca6b683          	ld	a3,-1590(a3) # ffffffffc02968b8 <pages>
ffffffffc0201ef6:	0000e797          	auipc	a5,0xe
ffffffffc0201efa:	9327b783          	ld	a5,-1742(a5) # ffffffffc020f828 <nbase>
ffffffffc0201efe:	00095717          	auipc	a4,0x95
ffffffffc0201f02:	9b273703          	ld	a4,-1614(a4) # ffffffffc02968b0 <npage>
ffffffffc0201f06:	8d15                	sub	a0,a0,a3
ffffffffc0201f08:	8519                	srai	a0,a0,0x6
ffffffffc0201f0a:	953e                	add	a0,a0,a5
ffffffffc0201f0c:	00c51793          	slli	a5,a0,0xc
ffffffffc0201f10:	83b1                	srli	a5,a5,0xc
ffffffffc0201f12:	0532                	slli	a0,a0,0xc
ffffffffc0201f14:	00e7fa63          	bgeu	a5,a4,ffffffffc0201f28 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201f18:	00095797          	auipc	a5,0x95
ffffffffc0201f1c:	9907b783          	ld	a5,-1648(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0201f20:	953e                	add	a0,a0,a5
ffffffffc0201f22:	60a2                	ld	ra,8(sp)
ffffffffc0201f24:	0141                	addi	sp,sp,16
ffffffffc0201f26:	8082                	ret
ffffffffc0201f28:	86aa                	mv	a3,a0
ffffffffc0201f2a:	0000a617          	auipc	a2,0xa
ffffffffc0201f2e:	58660613          	addi	a2,a2,1414 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc0201f32:	07100593          	li	a1,113
ffffffffc0201f36:	0000a517          	auipc	a0,0xa
ffffffffc0201f3a:	5a250513          	addi	a0,a0,1442 # ffffffffc020c4d8 <etext+0xede>
ffffffffc0201f3e:	d0cfe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201f42 <slob_alloc.constprop.0>:
ffffffffc0201f42:	7179                	addi	sp,sp,-48
ffffffffc0201f44:	f406                	sd	ra,40(sp)
ffffffffc0201f46:	f022                	sd	s0,32(sp)
ffffffffc0201f48:	ec26                	sd	s1,24(sp)
ffffffffc0201f4a:	01050713          	addi	a4,a0,16
ffffffffc0201f4e:	6785                	lui	a5,0x1
ffffffffc0201f50:	0af77e63          	bgeu	a4,a5,ffffffffc020200c <slob_alloc.constprop.0+0xca>
ffffffffc0201f54:	00f50413          	addi	s0,a0,15
ffffffffc0201f58:	8011                	srli	s0,s0,0x4
ffffffffc0201f5a:	2401                	sext.w	s0,s0
ffffffffc0201f5c:	100025f3          	csrr	a1,sstatus
ffffffffc0201f60:	8989                	andi	a1,a1,2
ffffffffc0201f62:	edd1                	bnez	a1,ffffffffc0201ffe <slob_alloc.constprop.0+0xbc>
ffffffffc0201f64:	0008f497          	auipc	s1,0x8f
ffffffffc0201f68:	0ec48493          	addi	s1,s1,236 # ffffffffc0291050 <slobfree>
ffffffffc0201f6c:	6090                	ld	a2,0(s1)
ffffffffc0201f6e:	6618                	ld	a4,8(a2)
ffffffffc0201f70:	4314                	lw	a3,0(a4)
ffffffffc0201f72:	0886da63          	bge	a3,s0,ffffffffc0202006 <slob_alloc.constprop.0+0xc4>
ffffffffc0201f76:	00e60a63          	beq	a2,a4,ffffffffc0201f8a <slob_alloc.constprop.0+0x48>
ffffffffc0201f7a:	671c                	ld	a5,8(a4)
ffffffffc0201f7c:	4394                	lw	a3,0(a5)
ffffffffc0201f7e:	0286d863          	bge	a3,s0,ffffffffc0201fae <slob_alloc.constprop.0+0x6c>
ffffffffc0201f82:	6090                	ld	a2,0(s1)
ffffffffc0201f84:	873e                	mv	a4,a5
ffffffffc0201f86:	fee61ae3          	bne	a2,a4,ffffffffc0201f7a <slob_alloc.constprop.0+0x38>
ffffffffc0201f8a:	e9b1                	bnez	a1,ffffffffc0201fde <slob_alloc.constprop.0+0x9c>
ffffffffc0201f8c:	4501                	li	a0,0
ffffffffc0201f8e:	f51ff0ef          	jal	ffffffffc0201ede <__slob_get_free_pages.constprop.0>
ffffffffc0201f92:	87aa                	mv	a5,a0
ffffffffc0201f94:	c915                	beqz	a0,ffffffffc0201fc8 <slob_alloc.constprop.0+0x86>
ffffffffc0201f96:	6585                	lui	a1,0x1
ffffffffc0201f98:	e35ff0ef          	jal	ffffffffc0201dcc <slob_free>
ffffffffc0201f9c:	100025f3          	csrr	a1,sstatus
ffffffffc0201fa0:	8989                	andi	a1,a1,2
ffffffffc0201fa2:	e98d                	bnez	a1,ffffffffc0201fd4 <slob_alloc.constprop.0+0x92>
ffffffffc0201fa4:	6098                	ld	a4,0(s1)
ffffffffc0201fa6:	671c                	ld	a5,8(a4)
ffffffffc0201fa8:	4394                	lw	a3,0(a5)
ffffffffc0201faa:	fc86cce3          	blt	a3,s0,ffffffffc0201f82 <slob_alloc.constprop.0+0x40>
ffffffffc0201fae:	04d40563          	beq	s0,a3,ffffffffc0201ff8 <slob_alloc.constprop.0+0xb6>
ffffffffc0201fb2:	00441613          	slli	a2,s0,0x4
ffffffffc0201fb6:	963e                	add	a2,a2,a5
ffffffffc0201fb8:	e710                	sd	a2,8(a4)
ffffffffc0201fba:	6788                	ld	a0,8(a5)
ffffffffc0201fbc:	9e81                	subw	a3,a3,s0
ffffffffc0201fbe:	c214                	sw	a3,0(a2)
ffffffffc0201fc0:	e608                	sd	a0,8(a2)
ffffffffc0201fc2:	c380                	sw	s0,0(a5)
ffffffffc0201fc4:	e098                	sd	a4,0(s1)
ffffffffc0201fc6:	ed99                	bnez	a1,ffffffffc0201fe4 <slob_alloc.constprop.0+0xa2>
ffffffffc0201fc8:	70a2                	ld	ra,40(sp)
ffffffffc0201fca:	7402                	ld	s0,32(sp)
ffffffffc0201fcc:	64e2                	ld	s1,24(sp)
ffffffffc0201fce:	853e                	mv	a0,a5
ffffffffc0201fd0:	6145                	addi	sp,sp,48
ffffffffc0201fd2:	8082                	ret
ffffffffc0201fd4:	c9dfe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0201fd8:	6098                	ld	a4,0(s1)
ffffffffc0201fda:	4585                	li	a1,1
ffffffffc0201fdc:	b7e9                	j	ffffffffc0201fa6 <slob_alloc.constprop.0+0x64>
ffffffffc0201fde:	c8dfe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0201fe2:	b76d                	j	ffffffffc0201f8c <slob_alloc.constprop.0+0x4a>
ffffffffc0201fe4:	e43e                	sd	a5,8(sp)
ffffffffc0201fe6:	c85fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0201fea:	67a2                	ld	a5,8(sp)
ffffffffc0201fec:	70a2                	ld	ra,40(sp)
ffffffffc0201fee:	7402                	ld	s0,32(sp)
ffffffffc0201ff0:	64e2                	ld	s1,24(sp)
ffffffffc0201ff2:	853e                	mv	a0,a5
ffffffffc0201ff4:	6145                	addi	sp,sp,48
ffffffffc0201ff6:	8082                	ret
ffffffffc0201ff8:	6794                	ld	a3,8(a5)
ffffffffc0201ffa:	e714                	sd	a3,8(a4)
ffffffffc0201ffc:	b7e1                	j	ffffffffc0201fc4 <slob_alloc.constprop.0+0x82>
ffffffffc0201ffe:	c73fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0202002:	4585                	li	a1,1
ffffffffc0202004:	b785                	j	ffffffffc0201f64 <slob_alloc.constprop.0+0x22>
ffffffffc0202006:	87ba                	mv	a5,a4
ffffffffc0202008:	8732                	mv	a4,a2
ffffffffc020200a:	b755                	j	ffffffffc0201fae <slob_alloc.constprop.0+0x6c>
ffffffffc020200c:	0000a697          	auipc	a3,0xa
ffffffffc0202010:	4dc68693          	addi	a3,a3,1244 # ffffffffc020c4e8 <etext+0xeee>
ffffffffc0202014:	0000a617          	auipc	a2,0xa
ffffffffc0202018:	a2460613          	addi	a2,a2,-1500 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020201c:	06300593          	li	a1,99
ffffffffc0202020:	0000a517          	auipc	a0,0xa
ffffffffc0202024:	4e850513          	addi	a0,a0,1256 # ffffffffc020c508 <etext+0xf0e>
ffffffffc0202028:	c22fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020202c <kmalloc_init>:
ffffffffc020202c:	1141                	addi	sp,sp,-16
ffffffffc020202e:	0000a517          	auipc	a0,0xa
ffffffffc0202032:	4f250513          	addi	a0,a0,1266 # ffffffffc020c520 <etext+0xf26>
ffffffffc0202036:	e406                	sd	ra,8(sp)
ffffffffc0202038:	96efe0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020203c:	60a2                	ld	ra,8(sp)
ffffffffc020203e:	0000a517          	auipc	a0,0xa
ffffffffc0202042:	4fa50513          	addi	a0,a0,1274 # ffffffffc020c538 <etext+0xf3e>
ffffffffc0202046:	0141                	addi	sp,sp,16
ffffffffc0202048:	95efe06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc020204c <kallocated>:
ffffffffc020204c:	4501                	li	a0,0
ffffffffc020204e:	8082                	ret

ffffffffc0202050 <kmalloc>:
ffffffffc0202050:	1101                	addi	sp,sp,-32
ffffffffc0202052:	6685                	lui	a3,0x1
ffffffffc0202054:	ec06                	sd	ra,24(sp)
ffffffffc0202056:	16bd                	addi	a3,a3,-17 # fef <_binary_bin_swap_img_size-0x6d11>
ffffffffc0202058:	04a6f963          	bgeu	a3,a0,ffffffffc02020aa <kmalloc+0x5a>
ffffffffc020205c:	e42a                	sd	a0,8(sp)
ffffffffc020205e:	4561                	li	a0,24
ffffffffc0202060:	e822                	sd	s0,16(sp)
ffffffffc0202062:	ee1ff0ef          	jal	ffffffffc0201f42 <slob_alloc.constprop.0>
ffffffffc0202066:	842a                	mv	s0,a0
ffffffffc0202068:	c541                	beqz	a0,ffffffffc02020f0 <kmalloc+0xa0>
ffffffffc020206a:	47a2                	lw	a5,8(sp)
ffffffffc020206c:	6705                	lui	a4,0x1
ffffffffc020206e:	4501                	li	a0,0
ffffffffc0202070:	00f75763          	bge	a4,a5,ffffffffc020207e <kmalloc+0x2e>
ffffffffc0202074:	4017d79b          	sraiw	a5,a5,0x1
ffffffffc0202078:	2505                	addiw	a0,a0,1
ffffffffc020207a:	fef74de3          	blt	a4,a5,ffffffffc0202074 <kmalloc+0x24>
ffffffffc020207e:	c008                	sw	a0,0(s0)
ffffffffc0202080:	e5fff0ef          	jal	ffffffffc0201ede <__slob_get_free_pages.constprop.0>
ffffffffc0202084:	e408                	sd	a0,8(s0)
ffffffffc0202086:	cd31                	beqz	a0,ffffffffc02020e2 <kmalloc+0x92>
ffffffffc0202088:	100027f3          	csrr	a5,sstatus
ffffffffc020208c:	8b89                	andi	a5,a5,2
ffffffffc020208e:	eb85                	bnez	a5,ffffffffc02020be <kmalloc+0x6e>
ffffffffc0202090:	00094797          	auipc	a5,0x94
ffffffffc0202094:	7f87b783          	ld	a5,2040(a5) # ffffffffc0296888 <bigblocks>
ffffffffc0202098:	00094717          	auipc	a4,0x94
ffffffffc020209c:	7e873823          	sd	s0,2032(a4) # ffffffffc0296888 <bigblocks>
ffffffffc02020a0:	e81c                	sd	a5,16(s0)
ffffffffc02020a2:	6442                	ld	s0,16(sp)
ffffffffc02020a4:	60e2                	ld	ra,24(sp)
ffffffffc02020a6:	6105                	addi	sp,sp,32
ffffffffc02020a8:	8082                	ret
ffffffffc02020aa:	0541                	addi	a0,a0,16
ffffffffc02020ac:	e97ff0ef          	jal	ffffffffc0201f42 <slob_alloc.constprop.0>
ffffffffc02020b0:	87aa                	mv	a5,a0
ffffffffc02020b2:	0541                	addi	a0,a0,16
ffffffffc02020b4:	fbe5                	bnez	a5,ffffffffc02020a4 <kmalloc+0x54>
ffffffffc02020b6:	4501                	li	a0,0
ffffffffc02020b8:	60e2                	ld	ra,24(sp)
ffffffffc02020ba:	6105                	addi	sp,sp,32
ffffffffc02020bc:	8082                	ret
ffffffffc02020be:	bb3fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02020c2:	00094797          	auipc	a5,0x94
ffffffffc02020c6:	7c67b783          	ld	a5,1990(a5) # ffffffffc0296888 <bigblocks>
ffffffffc02020ca:	00094717          	auipc	a4,0x94
ffffffffc02020ce:	7a873f23          	sd	s0,1982(a4) # ffffffffc0296888 <bigblocks>
ffffffffc02020d2:	e81c                	sd	a5,16(s0)
ffffffffc02020d4:	b97fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02020d8:	6408                	ld	a0,8(s0)
ffffffffc02020da:	60e2                	ld	ra,24(sp)
ffffffffc02020dc:	6442                	ld	s0,16(sp)
ffffffffc02020de:	6105                	addi	sp,sp,32
ffffffffc02020e0:	8082                	ret
ffffffffc02020e2:	8522                	mv	a0,s0
ffffffffc02020e4:	45e1                	li	a1,24
ffffffffc02020e6:	ce7ff0ef          	jal	ffffffffc0201dcc <slob_free>
ffffffffc02020ea:	4501                	li	a0,0
ffffffffc02020ec:	6442                	ld	s0,16(sp)
ffffffffc02020ee:	b7e9                	j	ffffffffc02020b8 <kmalloc+0x68>
ffffffffc02020f0:	6442                	ld	s0,16(sp)
ffffffffc02020f2:	4501                	li	a0,0
ffffffffc02020f4:	b7d1                	j	ffffffffc02020b8 <kmalloc+0x68>

ffffffffc02020f6 <kfree>:
ffffffffc02020f6:	c579                	beqz	a0,ffffffffc02021c4 <kfree+0xce>
ffffffffc02020f8:	03451793          	slli	a5,a0,0x34
ffffffffc02020fc:	e3e1                	bnez	a5,ffffffffc02021bc <kfree+0xc6>
ffffffffc02020fe:	1101                	addi	sp,sp,-32
ffffffffc0202100:	ec06                	sd	ra,24(sp)
ffffffffc0202102:	100027f3          	csrr	a5,sstatus
ffffffffc0202106:	8b89                	andi	a5,a5,2
ffffffffc0202108:	e7c1                	bnez	a5,ffffffffc0202190 <kfree+0x9a>
ffffffffc020210a:	00094797          	auipc	a5,0x94
ffffffffc020210e:	77e7b783          	ld	a5,1918(a5) # ffffffffc0296888 <bigblocks>
ffffffffc0202112:	4581                	li	a1,0
ffffffffc0202114:	cbad                	beqz	a5,ffffffffc0202186 <kfree+0x90>
ffffffffc0202116:	00094617          	auipc	a2,0x94
ffffffffc020211a:	77260613          	addi	a2,a2,1906 # ffffffffc0296888 <bigblocks>
ffffffffc020211e:	a021                	j	ffffffffc0202126 <kfree+0x30>
ffffffffc0202120:	01070613          	addi	a2,a4,16
ffffffffc0202124:	c3a5                	beqz	a5,ffffffffc0202184 <kfree+0x8e>
ffffffffc0202126:	6794                	ld	a3,8(a5)
ffffffffc0202128:	873e                	mv	a4,a5
ffffffffc020212a:	6b9c                	ld	a5,16(a5)
ffffffffc020212c:	fea69ae3          	bne	a3,a0,ffffffffc0202120 <kfree+0x2a>
ffffffffc0202130:	e21c                	sd	a5,0(a2)
ffffffffc0202132:	edb5                	bnez	a1,ffffffffc02021ae <kfree+0xb8>
ffffffffc0202134:	c02007b7          	lui	a5,0xc0200
ffffffffc0202138:	0af56363          	bltu	a0,a5,ffffffffc02021de <kfree+0xe8>
ffffffffc020213c:	00094797          	auipc	a5,0x94
ffffffffc0202140:	76c7b783          	ld	a5,1900(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202144:	00094697          	auipc	a3,0x94
ffffffffc0202148:	76c6b683          	ld	a3,1900(a3) # ffffffffc02968b0 <npage>
ffffffffc020214c:	8d1d                	sub	a0,a0,a5
ffffffffc020214e:	00c55793          	srli	a5,a0,0xc
ffffffffc0202152:	06d7fa63          	bgeu	a5,a3,ffffffffc02021c6 <kfree+0xd0>
ffffffffc0202156:	0000d617          	auipc	a2,0xd
ffffffffc020215a:	6d263603          	ld	a2,1746(a2) # ffffffffc020f828 <nbase>
ffffffffc020215e:	00094517          	auipc	a0,0x94
ffffffffc0202162:	75a53503          	ld	a0,1882(a0) # ffffffffc02968b8 <pages>
ffffffffc0202166:	4314                	lw	a3,0(a4)
ffffffffc0202168:	8f91                	sub	a5,a5,a2
ffffffffc020216a:	079a                	slli	a5,a5,0x6
ffffffffc020216c:	4585                	li	a1,1
ffffffffc020216e:	953e                	add	a0,a0,a5
ffffffffc0202170:	00d595bb          	sllw	a1,a1,a3
ffffffffc0202174:	e03a                	sd	a4,0(sp)
ffffffffc0202176:	0d8000ef          	jal	ffffffffc020224e <free_pages>
ffffffffc020217a:	6502                	ld	a0,0(sp)
ffffffffc020217c:	60e2                	ld	ra,24(sp)
ffffffffc020217e:	45e1                	li	a1,24
ffffffffc0202180:	6105                	addi	sp,sp,32
ffffffffc0202182:	b1a9                	j	ffffffffc0201dcc <slob_free>
ffffffffc0202184:	e185                	bnez	a1,ffffffffc02021a4 <kfree+0xae>
ffffffffc0202186:	60e2                	ld	ra,24(sp)
ffffffffc0202188:	1541                	addi	a0,a0,-16
ffffffffc020218a:	4581                	li	a1,0
ffffffffc020218c:	6105                	addi	sp,sp,32
ffffffffc020218e:	b93d                	j	ffffffffc0201dcc <slob_free>
ffffffffc0202190:	e02a                	sd	a0,0(sp)
ffffffffc0202192:	adffe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0202196:	00094797          	auipc	a5,0x94
ffffffffc020219a:	6f27b783          	ld	a5,1778(a5) # ffffffffc0296888 <bigblocks>
ffffffffc020219e:	6502                	ld	a0,0(sp)
ffffffffc02021a0:	4585                	li	a1,1
ffffffffc02021a2:	fbb5                	bnez	a5,ffffffffc0202116 <kfree+0x20>
ffffffffc02021a4:	e02a                	sd	a0,0(sp)
ffffffffc02021a6:	ac5fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02021aa:	6502                	ld	a0,0(sp)
ffffffffc02021ac:	bfe9                	j	ffffffffc0202186 <kfree+0x90>
ffffffffc02021ae:	e42a                	sd	a0,8(sp)
ffffffffc02021b0:	e03a                	sd	a4,0(sp)
ffffffffc02021b2:	ab9fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02021b6:	6522                	ld	a0,8(sp)
ffffffffc02021b8:	6702                	ld	a4,0(sp)
ffffffffc02021ba:	bfad                	j	ffffffffc0202134 <kfree+0x3e>
ffffffffc02021bc:	1541                	addi	a0,a0,-16
ffffffffc02021be:	4581                	li	a1,0
ffffffffc02021c0:	c0dff06f          	j	ffffffffc0201dcc <slob_free>
ffffffffc02021c4:	8082                	ret
ffffffffc02021c6:	0000a617          	auipc	a2,0xa
ffffffffc02021ca:	3ba60613          	addi	a2,a2,954 # ffffffffc020c580 <etext+0xf86>
ffffffffc02021ce:	06900593          	li	a1,105
ffffffffc02021d2:	0000a517          	auipc	a0,0xa
ffffffffc02021d6:	30650513          	addi	a0,a0,774 # ffffffffc020c4d8 <etext+0xede>
ffffffffc02021da:	a70fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02021de:	86aa                	mv	a3,a0
ffffffffc02021e0:	0000a617          	auipc	a2,0xa
ffffffffc02021e4:	37860613          	addi	a2,a2,888 # ffffffffc020c558 <etext+0xf5e>
ffffffffc02021e8:	07700593          	li	a1,119
ffffffffc02021ec:	0000a517          	auipc	a0,0xa
ffffffffc02021f0:	2ec50513          	addi	a0,a0,748 # ffffffffc020c4d8 <etext+0xede>
ffffffffc02021f4:	a56fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02021f8 <pa2page.part.0>:
ffffffffc02021f8:	1141                	addi	sp,sp,-16
ffffffffc02021fa:	0000a617          	auipc	a2,0xa
ffffffffc02021fe:	38660613          	addi	a2,a2,902 # ffffffffc020c580 <etext+0xf86>
ffffffffc0202202:	06900593          	li	a1,105
ffffffffc0202206:	0000a517          	auipc	a0,0xa
ffffffffc020220a:	2d250513          	addi	a0,a0,722 # ffffffffc020c4d8 <etext+0xede>
ffffffffc020220e:	e406                	sd	ra,8(sp)
ffffffffc0202210:	a3afe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0202214 <alloc_pages>:
ffffffffc0202214:	100027f3          	csrr	a5,sstatus
ffffffffc0202218:	8b89                	andi	a5,a5,2
ffffffffc020221a:	e799                	bnez	a5,ffffffffc0202228 <alloc_pages+0x14>
ffffffffc020221c:	00094797          	auipc	a5,0x94
ffffffffc0202220:	6747b783          	ld	a5,1652(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202224:	6f9c                	ld	a5,24(a5)
ffffffffc0202226:	8782                	jr	a5
ffffffffc0202228:	1101                	addi	sp,sp,-32
ffffffffc020222a:	ec06                	sd	ra,24(sp)
ffffffffc020222c:	e42a                	sd	a0,8(sp)
ffffffffc020222e:	a43fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0202232:	00094797          	auipc	a5,0x94
ffffffffc0202236:	65e7b783          	ld	a5,1630(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc020223a:	6522                	ld	a0,8(sp)
ffffffffc020223c:	6f9c                	ld	a5,24(a5)
ffffffffc020223e:	9782                	jalr	a5
ffffffffc0202240:	e42a                	sd	a0,8(sp)
ffffffffc0202242:	a29fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0202246:	60e2                	ld	ra,24(sp)
ffffffffc0202248:	6522                	ld	a0,8(sp)
ffffffffc020224a:	6105                	addi	sp,sp,32
ffffffffc020224c:	8082                	ret

ffffffffc020224e <free_pages>:
ffffffffc020224e:	100027f3          	csrr	a5,sstatus
ffffffffc0202252:	8b89                	andi	a5,a5,2
ffffffffc0202254:	e799                	bnez	a5,ffffffffc0202262 <free_pages+0x14>
ffffffffc0202256:	00094797          	auipc	a5,0x94
ffffffffc020225a:	63a7b783          	ld	a5,1594(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc020225e:	739c                	ld	a5,32(a5)
ffffffffc0202260:	8782                	jr	a5
ffffffffc0202262:	1101                	addi	sp,sp,-32
ffffffffc0202264:	ec06                	sd	ra,24(sp)
ffffffffc0202266:	e42e                	sd	a1,8(sp)
ffffffffc0202268:	e02a                	sd	a0,0(sp)
ffffffffc020226a:	a07fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc020226e:	00094797          	auipc	a5,0x94
ffffffffc0202272:	6227b783          	ld	a5,1570(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202276:	65a2                	ld	a1,8(sp)
ffffffffc0202278:	6502                	ld	a0,0(sp)
ffffffffc020227a:	739c                	ld	a5,32(a5)
ffffffffc020227c:	9782                	jalr	a5
ffffffffc020227e:	60e2                	ld	ra,24(sp)
ffffffffc0202280:	6105                	addi	sp,sp,32
ffffffffc0202282:	9e9fe06f          	j	ffffffffc0200c6a <intr_enable>

ffffffffc0202286 <nr_free_pages>:
ffffffffc0202286:	100027f3          	csrr	a5,sstatus
ffffffffc020228a:	8b89                	andi	a5,a5,2
ffffffffc020228c:	e799                	bnez	a5,ffffffffc020229a <nr_free_pages+0x14>
ffffffffc020228e:	00094797          	auipc	a5,0x94
ffffffffc0202292:	6027b783          	ld	a5,1538(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202296:	779c                	ld	a5,40(a5)
ffffffffc0202298:	8782                	jr	a5
ffffffffc020229a:	1101                	addi	sp,sp,-32
ffffffffc020229c:	ec06                	sd	ra,24(sp)
ffffffffc020229e:	9d3fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02022a2:	00094797          	auipc	a5,0x94
ffffffffc02022a6:	5ee7b783          	ld	a5,1518(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02022aa:	779c                	ld	a5,40(a5)
ffffffffc02022ac:	9782                	jalr	a5
ffffffffc02022ae:	e42a                	sd	a0,8(sp)
ffffffffc02022b0:	9bbfe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02022b4:	60e2                	ld	ra,24(sp)
ffffffffc02022b6:	6522                	ld	a0,8(sp)
ffffffffc02022b8:	6105                	addi	sp,sp,32
ffffffffc02022ba:	8082                	ret

ffffffffc02022bc <get_pte>:
ffffffffc02022bc:	01e5d793          	srli	a5,a1,0x1e
ffffffffc02022c0:	1ff7f793          	andi	a5,a5,511
ffffffffc02022c4:	078e                	slli	a5,a5,0x3
ffffffffc02022c6:	00f50733          	add	a4,a0,a5
ffffffffc02022ca:	6314                	ld	a3,0(a4)
ffffffffc02022cc:	7139                	addi	sp,sp,-64
ffffffffc02022ce:	f822                	sd	s0,48(sp)
ffffffffc02022d0:	f426                	sd	s1,40(sp)
ffffffffc02022d2:	fc06                	sd	ra,56(sp)
ffffffffc02022d4:	0016f793          	andi	a5,a3,1
ffffffffc02022d8:	842e                	mv	s0,a1
ffffffffc02022da:	8832                	mv	a6,a2
ffffffffc02022dc:	00094497          	auipc	s1,0x94
ffffffffc02022e0:	5d448493          	addi	s1,s1,1492 # ffffffffc02968b0 <npage>
ffffffffc02022e4:	ebd1                	bnez	a5,ffffffffc0202378 <get_pte+0xbc>
ffffffffc02022e6:	16060d63          	beqz	a2,ffffffffc0202460 <get_pte+0x1a4>
ffffffffc02022ea:	100027f3          	csrr	a5,sstatus
ffffffffc02022ee:	8b89                	andi	a5,a5,2
ffffffffc02022f0:	16079e63          	bnez	a5,ffffffffc020246c <get_pte+0x1b0>
ffffffffc02022f4:	00094797          	auipc	a5,0x94
ffffffffc02022f8:	59c7b783          	ld	a5,1436(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02022fc:	4505                	li	a0,1
ffffffffc02022fe:	e43a                	sd	a4,8(sp)
ffffffffc0202300:	6f9c                	ld	a5,24(a5)
ffffffffc0202302:	e832                	sd	a2,16(sp)
ffffffffc0202304:	9782                	jalr	a5
ffffffffc0202306:	6722                	ld	a4,8(sp)
ffffffffc0202308:	6842                	ld	a6,16(sp)
ffffffffc020230a:	87aa                	mv	a5,a0
ffffffffc020230c:	14078a63          	beqz	a5,ffffffffc0202460 <get_pte+0x1a4>
ffffffffc0202310:	00094517          	auipc	a0,0x94
ffffffffc0202314:	5a853503          	ld	a0,1448(a0) # ffffffffc02968b8 <pages>
ffffffffc0202318:	000808b7          	lui	a7,0x80
ffffffffc020231c:	00094497          	auipc	s1,0x94
ffffffffc0202320:	59448493          	addi	s1,s1,1428 # ffffffffc02968b0 <npage>
ffffffffc0202324:	40a78533          	sub	a0,a5,a0
ffffffffc0202328:	8519                	srai	a0,a0,0x6
ffffffffc020232a:	9546                	add	a0,a0,a7
ffffffffc020232c:	6090                	ld	a2,0(s1)
ffffffffc020232e:	00c51693          	slli	a3,a0,0xc
ffffffffc0202332:	4585                	li	a1,1
ffffffffc0202334:	82b1                	srli	a3,a3,0xc
ffffffffc0202336:	c38c                	sw	a1,0(a5)
ffffffffc0202338:	0532                	slli	a0,a0,0xc
ffffffffc020233a:	1ac6f763          	bgeu	a3,a2,ffffffffc02024e8 <get_pte+0x22c>
ffffffffc020233e:	00094697          	auipc	a3,0x94
ffffffffc0202342:	56a6b683          	ld	a3,1386(a3) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202346:	6605                	lui	a2,0x1
ffffffffc0202348:	4581                	li	a1,0
ffffffffc020234a:	9536                	add	a0,a0,a3
ffffffffc020234c:	ec42                	sd	a6,24(sp)
ffffffffc020234e:	e83e                	sd	a5,16(sp)
ffffffffc0202350:	e43a                	sd	a4,8(sp)
ffffffffc0202352:	240090ef          	jal	ffffffffc020b592 <memset>
ffffffffc0202356:	00094697          	auipc	a3,0x94
ffffffffc020235a:	5626b683          	ld	a3,1378(a3) # ffffffffc02968b8 <pages>
ffffffffc020235e:	67c2                	ld	a5,16(sp)
ffffffffc0202360:	000808b7          	lui	a7,0x80
ffffffffc0202364:	6722                	ld	a4,8(sp)
ffffffffc0202366:	40d786b3          	sub	a3,a5,a3
ffffffffc020236a:	8699                	srai	a3,a3,0x6
ffffffffc020236c:	96c6                	add	a3,a3,a7
ffffffffc020236e:	06aa                	slli	a3,a3,0xa
ffffffffc0202370:	6862                	ld	a6,24(sp)
ffffffffc0202372:	0116e693          	ori	a3,a3,17
ffffffffc0202376:	e314                	sd	a3,0(a4)
ffffffffc0202378:	c006f693          	andi	a3,a3,-1024
ffffffffc020237c:	6098                	ld	a4,0(s1)
ffffffffc020237e:	068a                	slli	a3,a3,0x2
ffffffffc0202380:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202384:	14e7f663          	bgeu	a5,a4,ffffffffc02024d0 <get_pte+0x214>
ffffffffc0202388:	00094897          	auipc	a7,0x94
ffffffffc020238c:	52088893          	addi	a7,a7,1312 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202390:	0008b603          	ld	a2,0(a7)
ffffffffc0202394:	01545793          	srli	a5,s0,0x15
ffffffffc0202398:	1ff7f793          	andi	a5,a5,511
ffffffffc020239c:	96b2                	add	a3,a3,a2
ffffffffc020239e:	078e                	slli	a5,a5,0x3
ffffffffc02023a0:	97b6                	add	a5,a5,a3
ffffffffc02023a2:	6394                	ld	a3,0(a5)
ffffffffc02023a4:	0016f613          	andi	a2,a3,1
ffffffffc02023a8:	e659                	bnez	a2,ffffffffc0202436 <get_pte+0x17a>
ffffffffc02023aa:	0a080b63          	beqz	a6,ffffffffc0202460 <get_pte+0x1a4>
ffffffffc02023ae:	10002773          	csrr	a4,sstatus
ffffffffc02023b2:	8b09                	andi	a4,a4,2
ffffffffc02023b4:	ef71                	bnez	a4,ffffffffc0202490 <get_pte+0x1d4>
ffffffffc02023b6:	00094717          	auipc	a4,0x94
ffffffffc02023ba:	4da73703          	ld	a4,1242(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc02023be:	4505                	li	a0,1
ffffffffc02023c0:	e43e                	sd	a5,8(sp)
ffffffffc02023c2:	6f18                	ld	a4,24(a4)
ffffffffc02023c4:	9702                	jalr	a4
ffffffffc02023c6:	67a2                	ld	a5,8(sp)
ffffffffc02023c8:	872a                	mv	a4,a0
ffffffffc02023ca:	00094897          	auipc	a7,0x94
ffffffffc02023ce:	4de88893          	addi	a7,a7,1246 # ffffffffc02968a8 <va_pa_offset>
ffffffffc02023d2:	c759                	beqz	a4,ffffffffc0202460 <get_pte+0x1a4>
ffffffffc02023d4:	00094697          	auipc	a3,0x94
ffffffffc02023d8:	4e46b683          	ld	a3,1252(a3) # ffffffffc02968b8 <pages>
ffffffffc02023dc:	00080837          	lui	a6,0x80
ffffffffc02023e0:	608c                	ld	a1,0(s1)
ffffffffc02023e2:	40d706b3          	sub	a3,a4,a3
ffffffffc02023e6:	8699                	srai	a3,a3,0x6
ffffffffc02023e8:	96c2                	add	a3,a3,a6
ffffffffc02023ea:	00c69613          	slli	a2,a3,0xc
ffffffffc02023ee:	4505                	li	a0,1
ffffffffc02023f0:	8231                	srli	a2,a2,0xc
ffffffffc02023f2:	c308                	sw	a0,0(a4)
ffffffffc02023f4:	06b2                	slli	a3,a3,0xc
ffffffffc02023f6:	10b67663          	bgeu	a2,a1,ffffffffc0202502 <get_pte+0x246>
ffffffffc02023fa:	0008b503          	ld	a0,0(a7)
ffffffffc02023fe:	6605                	lui	a2,0x1
ffffffffc0202400:	4581                	li	a1,0
ffffffffc0202402:	9536                	add	a0,a0,a3
ffffffffc0202404:	e83a                	sd	a4,16(sp)
ffffffffc0202406:	e43e                	sd	a5,8(sp)
ffffffffc0202408:	18a090ef          	jal	ffffffffc020b592 <memset>
ffffffffc020240c:	00094697          	auipc	a3,0x94
ffffffffc0202410:	4ac6b683          	ld	a3,1196(a3) # ffffffffc02968b8 <pages>
ffffffffc0202414:	6742                	ld	a4,16(sp)
ffffffffc0202416:	00080837          	lui	a6,0x80
ffffffffc020241a:	67a2                	ld	a5,8(sp)
ffffffffc020241c:	40d706b3          	sub	a3,a4,a3
ffffffffc0202420:	8699                	srai	a3,a3,0x6
ffffffffc0202422:	96c2                	add	a3,a3,a6
ffffffffc0202424:	06aa                	slli	a3,a3,0xa
ffffffffc0202426:	0116e693          	ori	a3,a3,17
ffffffffc020242a:	e394                	sd	a3,0(a5)
ffffffffc020242c:	6098                	ld	a4,0(s1)
ffffffffc020242e:	00094897          	auipc	a7,0x94
ffffffffc0202432:	47a88893          	addi	a7,a7,1146 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202436:	c006f693          	andi	a3,a3,-1024
ffffffffc020243a:	068a                	slli	a3,a3,0x2
ffffffffc020243c:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202440:	06e7fc63          	bgeu	a5,a4,ffffffffc02024b8 <get_pte+0x1fc>
ffffffffc0202444:	0008b783          	ld	a5,0(a7)
ffffffffc0202448:	8031                	srli	s0,s0,0xc
ffffffffc020244a:	1ff47413          	andi	s0,s0,511
ffffffffc020244e:	040e                	slli	s0,s0,0x3
ffffffffc0202450:	96be                	add	a3,a3,a5
ffffffffc0202452:	70e2                	ld	ra,56(sp)
ffffffffc0202454:	00868533          	add	a0,a3,s0
ffffffffc0202458:	7442                	ld	s0,48(sp)
ffffffffc020245a:	74a2                	ld	s1,40(sp)
ffffffffc020245c:	6121                	addi	sp,sp,64
ffffffffc020245e:	8082                	ret
ffffffffc0202460:	70e2                	ld	ra,56(sp)
ffffffffc0202462:	7442                	ld	s0,48(sp)
ffffffffc0202464:	74a2                	ld	s1,40(sp)
ffffffffc0202466:	4501                	li	a0,0
ffffffffc0202468:	6121                	addi	sp,sp,64
ffffffffc020246a:	8082                	ret
ffffffffc020246c:	e83a                	sd	a4,16(sp)
ffffffffc020246e:	ec32                	sd	a2,24(sp)
ffffffffc0202470:	801fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0202474:	00094797          	auipc	a5,0x94
ffffffffc0202478:	41c7b783          	ld	a5,1052(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc020247c:	4505                	li	a0,1
ffffffffc020247e:	6f9c                	ld	a5,24(a5)
ffffffffc0202480:	9782                	jalr	a5
ffffffffc0202482:	e42a                	sd	a0,8(sp)
ffffffffc0202484:	fe6fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0202488:	6862                	ld	a6,24(sp)
ffffffffc020248a:	6742                	ld	a4,16(sp)
ffffffffc020248c:	67a2                	ld	a5,8(sp)
ffffffffc020248e:	bdbd                	j	ffffffffc020230c <get_pte+0x50>
ffffffffc0202490:	e83e                	sd	a5,16(sp)
ffffffffc0202492:	fdefe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0202496:	00094717          	auipc	a4,0x94
ffffffffc020249a:	3fa73703          	ld	a4,1018(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc020249e:	4505                	li	a0,1
ffffffffc02024a0:	6f18                	ld	a4,24(a4)
ffffffffc02024a2:	9702                	jalr	a4
ffffffffc02024a4:	e42a                	sd	a0,8(sp)
ffffffffc02024a6:	fc4fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02024aa:	6722                	ld	a4,8(sp)
ffffffffc02024ac:	67c2                	ld	a5,16(sp)
ffffffffc02024ae:	00094897          	auipc	a7,0x94
ffffffffc02024b2:	3fa88893          	addi	a7,a7,1018 # ffffffffc02968a8 <va_pa_offset>
ffffffffc02024b6:	bf31                	j	ffffffffc02023d2 <get_pte+0x116>
ffffffffc02024b8:	0000a617          	auipc	a2,0xa
ffffffffc02024bc:	ff860613          	addi	a2,a2,-8 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc02024c0:	0f900593          	li	a1,249
ffffffffc02024c4:	0000a517          	auipc	a0,0xa
ffffffffc02024c8:	0dc50513          	addi	a0,a0,220 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02024cc:	f7ffd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02024d0:	0000a617          	auipc	a2,0xa
ffffffffc02024d4:	fe060613          	addi	a2,a2,-32 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc02024d8:	0ec00593          	li	a1,236
ffffffffc02024dc:	0000a517          	auipc	a0,0xa
ffffffffc02024e0:	0c450513          	addi	a0,a0,196 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02024e4:	f67fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02024e8:	86aa                	mv	a3,a0
ffffffffc02024ea:	0000a617          	auipc	a2,0xa
ffffffffc02024ee:	fc660613          	addi	a2,a2,-58 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc02024f2:	0e800593          	li	a1,232
ffffffffc02024f6:	0000a517          	auipc	a0,0xa
ffffffffc02024fa:	0aa50513          	addi	a0,a0,170 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02024fe:	f4dfd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202502:	0000a617          	auipc	a2,0xa
ffffffffc0202506:	fae60613          	addi	a2,a2,-82 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc020250a:	0f600593          	li	a1,246
ffffffffc020250e:	0000a517          	auipc	a0,0xa
ffffffffc0202512:	09250513          	addi	a0,a0,146 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0202516:	f35fd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020251a <get_page>:
ffffffffc020251a:	1141                	addi	sp,sp,-16
ffffffffc020251c:	e022                	sd	s0,0(sp)
ffffffffc020251e:	8432                	mv	s0,a2
ffffffffc0202520:	4601                	li	a2,0
ffffffffc0202522:	e406                	sd	ra,8(sp)
ffffffffc0202524:	d99ff0ef          	jal	ffffffffc02022bc <get_pte>
ffffffffc0202528:	c011                	beqz	s0,ffffffffc020252c <get_page+0x12>
ffffffffc020252a:	e008                	sd	a0,0(s0)
ffffffffc020252c:	c511                	beqz	a0,ffffffffc0202538 <get_page+0x1e>
ffffffffc020252e:	611c                	ld	a5,0(a0)
ffffffffc0202530:	4501                	li	a0,0
ffffffffc0202532:	0017f713          	andi	a4,a5,1
ffffffffc0202536:	e709                	bnez	a4,ffffffffc0202540 <get_page+0x26>
ffffffffc0202538:	60a2                	ld	ra,8(sp)
ffffffffc020253a:	6402                	ld	s0,0(sp)
ffffffffc020253c:	0141                	addi	sp,sp,16
ffffffffc020253e:	8082                	ret
ffffffffc0202540:	00094717          	auipc	a4,0x94
ffffffffc0202544:	37073703          	ld	a4,880(a4) # ffffffffc02968b0 <npage>
ffffffffc0202548:	078a                	slli	a5,a5,0x2
ffffffffc020254a:	83b1                	srli	a5,a5,0xc
ffffffffc020254c:	00e7ff63          	bgeu	a5,a4,ffffffffc020256a <get_page+0x50>
ffffffffc0202550:	00094517          	auipc	a0,0x94
ffffffffc0202554:	36853503          	ld	a0,872(a0) # ffffffffc02968b8 <pages>
ffffffffc0202558:	60a2                	ld	ra,8(sp)
ffffffffc020255a:	6402                	ld	s0,0(sp)
ffffffffc020255c:	079a                	slli	a5,a5,0x6
ffffffffc020255e:	fe000737          	lui	a4,0xfe000
ffffffffc0202562:	97ba                	add	a5,a5,a4
ffffffffc0202564:	953e                	add	a0,a0,a5
ffffffffc0202566:	0141                	addi	sp,sp,16
ffffffffc0202568:	8082                	ret
ffffffffc020256a:	c8fff0ef          	jal	ffffffffc02021f8 <pa2page.part.0>

ffffffffc020256e <unmap_range>:
ffffffffc020256e:	715d                	addi	sp,sp,-80
ffffffffc0202570:	00c5e7b3          	or	a5,a1,a2
ffffffffc0202574:	e486                	sd	ra,72(sp)
ffffffffc0202576:	e0a2                	sd	s0,64(sp)
ffffffffc0202578:	fc26                	sd	s1,56(sp)
ffffffffc020257a:	f84a                	sd	s2,48(sp)
ffffffffc020257c:	f44e                	sd	s3,40(sp)
ffffffffc020257e:	f052                	sd	s4,32(sp)
ffffffffc0202580:	ec56                	sd	s5,24(sp)
ffffffffc0202582:	03479713          	slli	a4,a5,0x34
ffffffffc0202586:	ef61                	bnez	a4,ffffffffc020265e <unmap_range+0xf0>
ffffffffc0202588:	00200a37          	lui	s4,0x200
ffffffffc020258c:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc0202590:	0145b733          	sltu	a4,a1,s4
ffffffffc0202594:	0017b793          	seqz	a5,a5
ffffffffc0202598:	8fd9                	or	a5,a5,a4
ffffffffc020259a:	842e                	mv	s0,a1
ffffffffc020259c:	84b2                	mv	s1,a2
ffffffffc020259e:	e3e5                	bnez	a5,ffffffffc020267e <unmap_range+0x110>
ffffffffc02025a0:	4785                	li	a5,1
ffffffffc02025a2:	07fe                	slli	a5,a5,0x1f
ffffffffc02025a4:	0785                	addi	a5,a5,1
ffffffffc02025a6:	892a                	mv	s2,a0
ffffffffc02025a8:	6985                	lui	s3,0x1
ffffffffc02025aa:	ffe00ab7          	lui	s5,0xffe00
ffffffffc02025ae:	0cf67863          	bgeu	a2,a5,ffffffffc020267e <unmap_range+0x110>
ffffffffc02025b2:	4601                	li	a2,0
ffffffffc02025b4:	85a2                	mv	a1,s0
ffffffffc02025b6:	854a                	mv	a0,s2
ffffffffc02025b8:	d05ff0ef          	jal	ffffffffc02022bc <get_pte>
ffffffffc02025bc:	87aa                	mv	a5,a0
ffffffffc02025be:	cd31                	beqz	a0,ffffffffc020261a <unmap_range+0xac>
ffffffffc02025c0:	6118                	ld	a4,0(a0)
ffffffffc02025c2:	ef11                	bnez	a4,ffffffffc02025de <unmap_range+0x70>
ffffffffc02025c4:	944e                	add	s0,s0,s3
ffffffffc02025c6:	c019                	beqz	s0,ffffffffc02025cc <unmap_range+0x5e>
ffffffffc02025c8:	fe9465e3          	bltu	s0,s1,ffffffffc02025b2 <unmap_range+0x44>
ffffffffc02025cc:	60a6                	ld	ra,72(sp)
ffffffffc02025ce:	6406                	ld	s0,64(sp)
ffffffffc02025d0:	74e2                	ld	s1,56(sp)
ffffffffc02025d2:	7942                	ld	s2,48(sp)
ffffffffc02025d4:	79a2                	ld	s3,40(sp)
ffffffffc02025d6:	7a02                	ld	s4,32(sp)
ffffffffc02025d8:	6ae2                	ld	s5,24(sp)
ffffffffc02025da:	6161                	addi	sp,sp,80
ffffffffc02025dc:	8082                	ret
ffffffffc02025de:	00177693          	andi	a3,a4,1
ffffffffc02025e2:	d2ed                	beqz	a3,ffffffffc02025c4 <unmap_range+0x56>
ffffffffc02025e4:	00094697          	auipc	a3,0x94
ffffffffc02025e8:	2cc6b683          	ld	a3,716(a3) # ffffffffc02968b0 <npage>
ffffffffc02025ec:	070a                	slli	a4,a4,0x2
ffffffffc02025ee:	8331                	srli	a4,a4,0xc
ffffffffc02025f0:	0ad77763          	bgeu	a4,a3,ffffffffc020269e <unmap_range+0x130>
ffffffffc02025f4:	00094517          	auipc	a0,0x94
ffffffffc02025f8:	2c453503          	ld	a0,708(a0) # ffffffffc02968b8 <pages>
ffffffffc02025fc:	071a                	slli	a4,a4,0x6
ffffffffc02025fe:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202602:	9736                	add	a4,a4,a3
ffffffffc0202604:	953a                	add	a0,a0,a4
ffffffffc0202606:	4118                	lw	a4,0(a0)
ffffffffc0202608:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3dd696ef>
ffffffffc020260a:	c118                	sw	a4,0(a0)
ffffffffc020260c:	cb19                	beqz	a4,ffffffffc0202622 <unmap_range+0xb4>
ffffffffc020260e:	0007b023          	sd	zero,0(a5)
ffffffffc0202612:	12040073          	sfence.vma	s0
ffffffffc0202616:	944e                	add	s0,s0,s3
ffffffffc0202618:	b77d                	j	ffffffffc02025c6 <unmap_range+0x58>
ffffffffc020261a:	9452                	add	s0,s0,s4
ffffffffc020261c:	01547433          	and	s0,s0,s5
ffffffffc0202620:	b75d                	j	ffffffffc02025c6 <unmap_range+0x58>
ffffffffc0202622:	10002773          	csrr	a4,sstatus
ffffffffc0202626:	8b09                	andi	a4,a4,2
ffffffffc0202628:	eb19                	bnez	a4,ffffffffc020263e <unmap_range+0xd0>
ffffffffc020262a:	00094717          	auipc	a4,0x94
ffffffffc020262e:	26673703          	ld	a4,614(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc0202632:	4585                	li	a1,1
ffffffffc0202634:	e03e                	sd	a5,0(sp)
ffffffffc0202636:	7318                	ld	a4,32(a4)
ffffffffc0202638:	9702                	jalr	a4
ffffffffc020263a:	6782                	ld	a5,0(sp)
ffffffffc020263c:	bfc9                	j	ffffffffc020260e <unmap_range+0xa0>
ffffffffc020263e:	e43e                	sd	a5,8(sp)
ffffffffc0202640:	e02a                	sd	a0,0(sp)
ffffffffc0202642:	e2efe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0202646:	00094717          	auipc	a4,0x94
ffffffffc020264a:	24a73703          	ld	a4,586(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc020264e:	6502                	ld	a0,0(sp)
ffffffffc0202650:	4585                	li	a1,1
ffffffffc0202652:	7318                	ld	a4,32(a4)
ffffffffc0202654:	9702                	jalr	a4
ffffffffc0202656:	e14fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc020265a:	67a2                	ld	a5,8(sp)
ffffffffc020265c:	bf4d                	j	ffffffffc020260e <unmap_range+0xa0>
ffffffffc020265e:	0000a697          	auipc	a3,0xa
ffffffffc0202662:	f5268693          	addi	a3,a3,-174 # ffffffffc020c5b0 <etext+0xfb6>
ffffffffc0202666:	00009617          	auipc	a2,0x9
ffffffffc020266a:	3d260613          	addi	a2,a2,978 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020266e:	12100593          	li	a1,289
ffffffffc0202672:	0000a517          	auipc	a0,0xa
ffffffffc0202676:	f2e50513          	addi	a0,a0,-210 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020267a:	dd1fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020267e:	0000a697          	auipc	a3,0xa
ffffffffc0202682:	f6268693          	addi	a3,a3,-158 # ffffffffc020c5e0 <etext+0xfe6>
ffffffffc0202686:	00009617          	auipc	a2,0x9
ffffffffc020268a:	3b260613          	addi	a2,a2,946 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020268e:	12200593          	li	a1,290
ffffffffc0202692:	0000a517          	auipc	a0,0xa
ffffffffc0202696:	f0e50513          	addi	a0,a0,-242 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020269a:	db1fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020269e:	b5bff0ef          	jal	ffffffffc02021f8 <pa2page.part.0>

ffffffffc02026a2 <exit_range>:
ffffffffc02026a2:	7135                	addi	sp,sp,-160
ffffffffc02026a4:	00c5e7b3          	or	a5,a1,a2
ffffffffc02026a8:	ed06                	sd	ra,152(sp)
ffffffffc02026aa:	e922                	sd	s0,144(sp)
ffffffffc02026ac:	e526                	sd	s1,136(sp)
ffffffffc02026ae:	e14a                	sd	s2,128(sp)
ffffffffc02026b0:	fcce                	sd	s3,120(sp)
ffffffffc02026b2:	f8d2                	sd	s4,112(sp)
ffffffffc02026b4:	f4d6                	sd	s5,104(sp)
ffffffffc02026b6:	f0da                	sd	s6,96(sp)
ffffffffc02026b8:	ecde                	sd	s7,88(sp)
ffffffffc02026ba:	17d2                	slli	a5,a5,0x34
ffffffffc02026bc:	22079263          	bnez	a5,ffffffffc02028e0 <exit_range+0x23e>
ffffffffc02026c0:	00200937          	lui	s2,0x200
ffffffffc02026c4:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc02026c8:	0125b733          	sltu	a4,a1,s2
ffffffffc02026cc:	0017b793          	seqz	a5,a5
ffffffffc02026d0:	8fd9                	or	a5,a5,a4
ffffffffc02026d2:	26079263          	bnez	a5,ffffffffc0202936 <exit_range+0x294>
ffffffffc02026d6:	4785                	li	a5,1
ffffffffc02026d8:	07fe                	slli	a5,a5,0x1f
ffffffffc02026da:	0785                	addi	a5,a5,1
ffffffffc02026dc:	24f67d63          	bgeu	a2,a5,ffffffffc0202936 <exit_range+0x294>
ffffffffc02026e0:	c00004b7          	lui	s1,0xc0000
ffffffffc02026e4:	ffe007b7          	lui	a5,0xffe00
ffffffffc02026e8:	8a2a                	mv	s4,a0
ffffffffc02026ea:	8ced                	and	s1,s1,a1
ffffffffc02026ec:	00f5f833          	and	a6,a1,a5
ffffffffc02026f0:	00094a97          	auipc	s5,0x94
ffffffffc02026f4:	1c0a8a93          	addi	s5,s5,448 # ffffffffc02968b0 <npage>
ffffffffc02026f8:	400009b7          	lui	s3,0x40000
ffffffffc02026fc:	a809                	j	ffffffffc020270e <exit_range+0x6c>
ffffffffc02026fe:	013487b3          	add	a5,s1,s3
ffffffffc0202702:	400004b7          	lui	s1,0x40000
ffffffffc0202706:	8826                	mv	a6,s1
ffffffffc0202708:	c3f1                	beqz	a5,ffffffffc02027cc <exit_range+0x12a>
ffffffffc020270a:	0cc7f163          	bgeu	a5,a2,ffffffffc02027cc <exit_range+0x12a>
ffffffffc020270e:	01e4d413          	srli	s0,s1,0x1e
ffffffffc0202712:	1ff47413          	andi	s0,s0,511
ffffffffc0202716:	040e                	slli	s0,s0,0x3
ffffffffc0202718:	9452                	add	s0,s0,s4
ffffffffc020271a:	00043883          	ld	a7,0(s0)
ffffffffc020271e:	0018f793          	andi	a5,a7,1
ffffffffc0202722:	dff1                	beqz	a5,ffffffffc02026fe <exit_range+0x5c>
ffffffffc0202724:	000ab783          	ld	a5,0(s5)
ffffffffc0202728:	088a                	slli	a7,a7,0x2
ffffffffc020272a:	00c8d893          	srli	a7,a7,0xc
ffffffffc020272e:	20f8f263          	bgeu	a7,a5,ffffffffc0202932 <exit_range+0x290>
ffffffffc0202732:	fff802b7          	lui	t0,0xfff80
ffffffffc0202736:	00588f33          	add	t5,a7,t0
ffffffffc020273a:	000803b7          	lui	t2,0x80
ffffffffc020273e:	007f0733          	add	a4,t5,t2
ffffffffc0202742:	00c71e13          	slli	t3,a4,0xc
ffffffffc0202746:	0f1a                	slli	t5,t5,0x6
ffffffffc0202748:	1cf77863          	bgeu	a4,a5,ffffffffc0202918 <exit_range+0x276>
ffffffffc020274c:	00094f97          	auipc	t6,0x94
ffffffffc0202750:	15cf8f93          	addi	t6,t6,348 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202754:	000fb783          	ld	a5,0(t6)
ffffffffc0202758:	4e85                	li	t4,1
ffffffffc020275a:	6b05                	lui	s6,0x1
ffffffffc020275c:	9e3e                	add	t3,t3,a5
ffffffffc020275e:	01348333          	add	t1,s1,s3
ffffffffc0202762:	01585713          	srli	a4,a6,0x15
ffffffffc0202766:	1ff77713          	andi	a4,a4,511
ffffffffc020276a:	070e                	slli	a4,a4,0x3
ffffffffc020276c:	9772                	add	a4,a4,t3
ffffffffc020276e:	631c                	ld	a5,0(a4)
ffffffffc0202770:	0017f693          	andi	a3,a5,1
ffffffffc0202774:	e6bd                	bnez	a3,ffffffffc02027e2 <exit_range+0x140>
ffffffffc0202776:	4e81                	li	t4,0
ffffffffc0202778:	984a                	add	a6,a6,s2
ffffffffc020277a:	00080863          	beqz	a6,ffffffffc020278a <exit_range+0xe8>
ffffffffc020277e:	879a                	mv	a5,t1
ffffffffc0202780:	00667363          	bgeu	a2,t1,ffffffffc0202786 <exit_range+0xe4>
ffffffffc0202784:	87b2                	mv	a5,a2
ffffffffc0202786:	fcf86ee3          	bltu	a6,a5,ffffffffc0202762 <exit_range+0xc0>
ffffffffc020278a:	f60e8ae3          	beqz	t4,ffffffffc02026fe <exit_range+0x5c>
ffffffffc020278e:	000ab783          	ld	a5,0(s5)
ffffffffc0202792:	1af8f063          	bgeu	a7,a5,ffffffffc0202932 <exit_range+0x290>
ffffffffc0202796:	00094517          	auipc	a0,0x94
ffffffffc020279a:	12253503          	ld	a0,290(a0) # ffffffffc02968b8 <pages>
ffffffffc020279e:	957a                	add	a0,a0,t5
ffffffffc02027a0:	100027f3          	csrr	a5,sstatus
ffffffffc02027a4:	8b89                	andi	a5,a5,2
ffffffffc02027a6:	10079b63          	bnez	a5,ffffffffc02028bc <exit_range+0x21a>
ffffffffc02027aa:	00094797          	auipc	a5,0x94
ffffffffc02027ae:	0e67b783          	ld	a5,230(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02027b2:	4585                	li	a1,1
ffffffffc02027b4:	e432                	sd	a2,8(sp)
ffffffffc02027b6:	739c                	ld	a5,32(a5)
ffffffffc02027b8:	9782                	jalr	a5
ffffffffc02027ba:	6622                	ld	a2,8(sp)
ffffffffc02027bc:	00043023          	sd	zero,0(s0)
ffffffffc02027c0:	013487b3          	add	a5,s1,s3
ffffffffc02027c4:	400004b7          	lui	s1,0x40000
ffffffffc02027c8:	8826                	mv	a6,s1
ffffffffc02027ca:	f3a1                	bnez	a5,ffffffffc020270a <exit_range+0x68>
ffffffffc02027cc:	60ea                	ld	ra,152(sp)
ffffffffc02027ce:	644a                	ld	s0,144(sp)
ffffffffc02027d0:	64aa                	ld	s1,136(sp)
ffffffffc02027d2:	690a                	ld	s2,128(sp)
ffffffffc02027d4:	79e6                	ld	s3,120(sp)
ffffffffc02027d6:	7a46                	ld	s4,112(sp)
ffffffffc02027d8:	7aa6                	ld	s5,104(sp)
ffffffffc02027da:	7b06                	ld	s6,96(sp)
ffffffffc02027dc:	6be6                	ld	s7,88(sp)
ffffffffc02027de:	610d                	addi	sp,sp,160
ffffffffc02027e0:	8082                	ret
ffffffffc02027e2:	000ab503          	ld	a0,0(s5)
ffffffffc02027e6:	078a                	slli	a5,a5,0x2
ffffffffc02027e8:	83b1                	srli	a5,a5,0xc
ffffffffc02027ea:	14a7f463          	bgeu	a5,a0,ffffffffc0202932 <exit_range+0x290>
ffffffffc02027ee:	9796                	add	a5,a5,t0
ffffffffc02027f0:	00778bb3          	add	s7,a5,t2
ffffffffc02027f4:	00679593          	slli	a1,a5,0x6
ffffffffc02027f8:	00cb9693          	slli	a3,s7,0xc
ffffffffc02027fc:	10abf263          	bgeu	s7,a0,ffffffffc0202900 <exit_range+0x25e>
ffffffffc0202800:	000fb783          	ld	a5,0(t6)
ffffffffc0202804:	96be                	add	a3,a3,a5
ffffffffc0202806:	01668533          	add	a0,a3,s6
ffffffffc020280a:	629c                	ld	a5,0(a3)
ffffffffc020280c:	8b85                	andi	a5,a5,1
ffffffffc020280e:	f7ad                	bnez	a5,ffffffffc0202778 <exit_range+0xd6>
ffffffffc0202810:	06a1                	addi	a3,a3,8
ffffffffc0202812:	fea69ce3          	bne	a3,a0,ffffffffc020280a <exit_range+0x168>
ffffffffc0202816:	00094517          	auipc	a0,0x94
ffffffffc020281a:	0a253503          	ld	a0,162(a0) # ffffffffc02968b8 <pages>
ffffffffc020281e:	952e                	add	a0,a0,a1
ffffffffc0202820:	100027f3          	csrr	a5,sstatus
ffffffffc0202824:	8b89                	andi	a5,a5,2
ffffffffc0202826:	e3b9                	bnez	a5,ffffffffc020286c <exit_range+0x1ca>
ffffffffc0202828:	00094797          	auipc	a5,0x94
ffffffffc020282c:	0687b783          	ld	a5,104(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202830:	4585                	li	a1,1
ffffffffc0202832:	e0b2                	sd	a2,64(sp)
ffffffffc0202834:	739c                	ld	a5,32(a5)
ffffffffc0202836:	fc1a                	sd	t1,56(sp)
ffffffffc0202838:	f846                	sd	a7,48(sp)
ffffffffc020283a:	f47a                	sd	t5,40(sp)
ffffffffc020283c:	f072                	sd	t3,32(sp)
ffffffffc020283e:	ec76                	sd	t4,24(sp)
ffffffffc0202840:	e842                	sd	a6,16(sp)
ffffffffc0202842:	e43a                	sd	a4,8(sp)
ffffffffc0202844:	9782                	jalr	a5
ffffffffc0202846:	6722                	ld	a4,8(sp)
ffffffffc0202848:	6842                	ld	a6,16(sp)
ffffffffc020284a:	6ee2                	ld	t4,24(sp)
ffffffffc020284c:	7e02                	ld	t3,32(sp)
ffffffffc020284e:	7f22                	ld	t5,40(sp)
ffffffffc0202850:	78c2                	ld	a7,48(sp)
ffffffffc0202852:	7362                	ld	t1,56(sp)
ffffffffc0202854:	6606                	ld	a2,64(sp)
ffffffffc0202856:	fff802b7          	lui	t0,0xfff80
ffffffffc020285a:	000803b7          	lui	t2,0x80
ffffffffc020285e:	00094f97          	auipc	t6,0x94
ffffffffc0202862:	04af8f93          	addi	t6,t6,74 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202866:	00073023          	sd	zero,0(a4)
ffffffffc020286a:	b739                	j	ffffffffc0202778 <exit_range+0xd6>
ffffffffc020286c:	e4b2                	sd	a2,72(sp)
ffffffffc020286e:	e09a                	sd	t1,64(sp)
ffffffffc0202870:	fc46                	sd	a7,56(sp)
ffffffffc0202872:	f47a                	sd	t5,40(sp)
ffffffffc0202874:	f072                	sd	t3,32(sp)
ffffffffc0202876:	ec76                	sd	t4,24(sp)
ffffffffc0202878:	e842                	sd	a6,16(sp)
ffffffffc020287a:	e43a                	sd	a4,8(sp)
ffffffffc020287c:	f82a                	sd	a0,48(sp)
ffffffffc020287e:	bf2fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0202882:	00094797          	auipc	a5,0x94
ffffffffc0202886:	00e7b783          	ld	a5,14(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc020288a:	7542                	ld	a0,48(sp)
ffffffffc020288c:	4585                	li	a1,1
ffffffffc020288e:	739c                	ld	a5,32(a5)
ffffffffc0202890:	9782                	jalr	a5
ffffffffc0202892:	bd8fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0202896:	6722                	ld	a4,8(sp)
ffffffffc0202898:	6626                	ld	a2,72(sp)
ffffffffc020289a:	6306                	ld	t1,64(sp)
ffffffffc020289c:	78e2                	ld	a7,56(sp)
ffffffffc020289e:	7f22                	ld	t5,40(sp)
ffffffffc02028a0:	7e02                	ld	t3,32(sp)
ffffffffc02028a2:	6ee2                	ld	t4,24(sp)
ffffffffc02028a4:	6842                	ld	a6,16(sp)
ffffffffc02028a6:	00094f97          	auipc	t6,0x94
ffffffffc02028aa:	002f8f93          	addi	t6,t6,2 # ffffffffc02968a8 <va_pa_offset>
ffffffffc02028ae:	000803b7          	lui	t2,0x80
ffffffffc02028b2:	fff802b7          	lui	t0,0xfff80
ffffffffc02028b6:	00073023          	sd	zero,0(a4)
ffffffffc02028ba:	bd7d                	j	ffffffffc0202778 <exit_range+0xd6>
ffffffffc02028bc:	e832                	sd	a2,16(sp)
ffffffffc02028be:	e42a                	sd	a0,8(sp)
ffffffffc02028c0:	bb0fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02028c4:	00094797          	auipc	a5,0x94
ffffffffc02028c8:	fcc7b783          	ld	a5,-52(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02028cc:	6522                	ld	a0,8(sp)
ffffffffc02028ce:	4585                	li	a1,1
ffffffffc02028d0:	739c                	ld	a5,32(a5)
ffffffffc02028d2:	9782                	jalr	a5
ffffffffc02028d4:	b96fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02028d8:	6642                	ld	a2,16(sp)
ffffffffc02028da:	00043023          	sd	zero,0(s0)
ffffffffc02028de:	b5cd                	j	ffffffffc02027c0 <exit_range+0x11e>
ffffffffc02028e0:	0000a697          	auipc	a3,0xa
ffffffffc02028e4:	cd068693          	addi	a3,a3,-816 # ffffffffc020c5b0 <etext+0xfb6>
ffffffffc02028e8:	00009617          	auipc	a2,0x9
ffffffffc02028ec:	15060613          	addi	a2,a2,336 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02028f0:	13600593          	li	a1,310
ffffffffc02028f4:	0000a517          	auipc	a0,0xa
ffffffffc02028f8:	cac50513          	addi	a0,a0,-852 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02028fc:	b4ffd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202900:	0000a617          	auipc	a2,0xa
ffffffffc0202904:	bb060613          	addi	a2,a2,-1104 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc0202908:	07100593          	li	a1,113
ffffffffc020290c:	0000a517          	auipc	a0,0xa
ffffffffc0202910:	bcc50513          	addi	a0,a0,-1076 # ffffffffc020c4d8 <etext+0xede>
ffffffffc0202914:	b37fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202918:	86f2                	mv	a3,t3
ffffffffc020291a:	0000a617          	auipc	a2,0xa
ffffffffc020291e:	b9660613          	addi	a2,a2,-1130 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc0202922:	07100593          	li	a1,113
ffffffffc0202926:	0000a517          	auipc	a0,0xa
ffffffffc020292a:	bb250513          	addi	a0,a0,-1102 # ffffffffc020c4d8 <etext+0xede>
ffffffffc020292e:	b1dfd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202932:	8c7ff0ef          	jal	ffffffffc02021f8 <pa2page.part.0>
ffffffffc0202936:	0000a697          	auipc	a3,0xa
ffffffffc020293a:	caa68693          	addi	a3,a3,-854 # ffffffffc020c5e0 <etext+0xfe6>
ffffffffc020293e:	00009617          	auipc	a2,0x9
ffffffffc0202942:	0fa60613          	addi	a2,a2,250 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0202946:	13700593          	li	a1,311
ffffffffc020294a:	0000a517          	auipc	a0,0xa
ffffffffc020294e:	c5650513          	addi	a0,a0,-938 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0202952:	af9fd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0202956 <page_remove>:
ffffffffc0202956:	1101                	addi	sp,sp,-32
ffffffffc0202958:	4601                	li	a2,0
ffffffffc020295a:	e822                	sd	s0,16(sp)
ffffffffc020295c:	ec06                	sd	ra,24(sp)
ffffffffc020295e:	842e                	mv	s0,a1
ffffffffc0202960:	95dff0ef          	jal	ffffffffc02022bc <get_pte>
ffffffffc0202964:	c511                	beqz	a0,ffffffffc0202970 <page_remove+0x1a>
ffffffffc0202966:	6118                	ld	a4,0(a0)
ffffffffc0202968:	87aa                	mv	a5,a0
ffffffffc020296a:	00177693          	andi	a3,a4,1
ffffffffc020296e:	e689                	bnez	a3,ffffffffc0202978 <page_remove+0x22>
ffffffffc0202970:	60e2                	ld	ra,24(sp)
ffffffffc0202972:	6442                	ld	s0,16(sp)
ffffffffc0202974:	6105                	addi	sp,sp,32
ffffffffc0202976:	8082                	ret
ffffffffc0202978:	00094697          	auipc	a3,0x94
ffffffffc020297c:	f386b683          	ld	a3,-200(a3) # ffffffffc02968b0 <npage>
ffffffffc0202980:	070a                	slli	a4,a4,0x2
ffffffffc0202982:	8331                	srli	a4,a4,0xc
ffffffffc0202984:	06d77563          	bgeu	a4,a3,ffffffffc02029ee <page_remove+0x98>
ffffffffc0202988:	00094517          	auipc	a0,0x94
ffffffffc020298c:	f3053503          	ld	a0,-208(a0) # ffffffffc02968b8 <pages>
ffffffffc0202990:	071a                	slli	a4,a4,0x6
ffffffffc0202992:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202996:	9736                	add	a4,a4,a3
ffffffffc0202998:	953a                	add	a0,a0,a4
ffffffffc020299a:	4118                	lw	a4,0(a0)
ffffffffc020299c:	377d                	addiw	a4,a4,-1
ffffffffc020299e:	c118                	sw	a4,0(a0)
ffffffffc02029a0:	cb09                	beqz	a4,ffffffffc02029b2 <page_remove+0x5c>
ffffffffc02029a2:	0007b023          	sd	zero,0(a5)
ffffffffc02029a6:	12040073          	sfence.vma	s0
ffffffffc02029aa:	60e2                	ld	ra,24(sp)
ffffffffc02029ac:	6442                	ld	s0,16(sp)
ffffffffc02029ae:	6105                	addi	sp,sp,32
ffffffffc02029b0:	8082                	ret
ffffffffc02029b2:	10002773          	csrr	a4,sstatus
ffffffffc02029b6:	8b09                	andi	a4,a4,2
ffffffffc02029b8:	eb19                	bnez	a4,ffffffffc02029ce <page_remove+0x78>
ffffffffc02029ba:	00094717          	auipc	a4,0x94
ffffffffc02029be:	ed673703          	ld	a4,-298(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc02029c2:	4585                	li	a1,1
ffffffffc02029c4:	e03e                	sd	a5,0(sp)
ffffffffc02029c6:	7318                	ld	a4,32(a4)
ffffffffc02029c8:	9702                	jalr	a4
ffffffffc02029ca:	6782                	ld	a5,0(sp)
ffffffffc02029cc:	bfd9                	j	ffffffffc02029a2 <page_remove+0x4c>
ffffffffc02029ce:	e43e                	sd	a5,8(sp)
ffffffffc02029d0:	e02a                	sd	a0,0(sp)
ffffffffc02029d2:	a9efe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02029d6:	00094717          	auipc	a4,0x94
ffffffffc02029da:	eba73703          	ld	a4,-326(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc02029de:	6502                	ld	a0,0(sp)
ffffffffc02029e0:	4585                	li	a1,1
ffffffffc02029e2:	7318                	ld	a4,32(a4)
ffffffffc02029e4:	9702                	jalr	a4
ffffffffc02029e6:	a84fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02029ea:	67a2                	ld	a5,8(sp)
ffffffffc02029ec:	bf5d                	j	ffffffffc02029a2 <page_remove+0x4c>
ffffffffc02029ee:	80bff0ef          	jal	ffffffffc02021f8 <pa2page.part.0>

ffffffffc02029f2 <page_insert>:
ffffffffc02029f2:	7139                	addi	sp,sp,-64
ffffffffc02029f4:	f426                	sd	s1,40(sp)
ffffffffc02029f6:	84b2                	mv	s1,a2
ffffffffc02029f8:	f822                	sd	s0,48(sp)
ffffffffc02029fa:	4605                	li	a2,1
ffffffffc02029fc:	842e                	mv	s0,a1
ffffffffc02029fe:	85a6                	mv	a1,s1
ffffffffc0202a00:	fc06                	sd	ra,56(sp)
ffffffffc0202a02:	e436                	sd	a3,8(sp)
ffffffffc0202a04:	8b9ff0ef          	jal	ffffffffc02022bc <get_pte>
ffffffffc0202a08:	cd61                	beqz	a0,ffffffffc0202ae0 <page_insert+0xee>
ffffffffc0202a0a:	400c                	lw	a1,0(s0)
ffffffffc0202a0c:	611c                	ld	a5,0(a0)
ffffffffc0202a0e:	66a2                	ld	a3,8(sp)
ffffffffc0202a10:	0015861b          	addiw	a2,a1,1 # 1001 <_binary_bin_swap_img_size-0x6cff>
ffffffffc0202a14:	c010                	sw	a2,0(s0)
ffffffffc0202a16:	0017f613          	andi	a2,a5,1
ffffffffc0202a1a:	872a                	mv	a4,a0
ffffffffc0202a1c:	e61d                	bnez	a2,ffffffffc0202a4a <page_insert+0x58>
ffffffffc0202a1e:	00094617          	auipc	a2,0x94
ffffffffc0202a22:	e9a63603          	ld	a2,-358(a2) # ffffffffc02968b8 <pages>
ffffffffc0202a26:	8c11                	sub	s0,s0,a2
ffffffffc0202a28:	8419                	srai	s0,s0,0x6
ffffffffc0202a2a:	200007b7          	lui	a5,0x20000
ffffffffc0202a2e:	042a                	slli	s0,s0,0xa
ffffffffc0202a30:	943e                	add	s0,s0,a5
ffffffffc0202a32:	8ec1                	or	a3,a3,s0
ffffffffc0202a34:	0016e693          	ori	a3,a3,1
ffffffffc0202a38:	e314                	sd	a3,0(a4)
ffffffffc0202a3a:	12048073          	sfence.vma	s1
ffffffffc0202a3e:	4501                	li	a0,0
ffffffffc0202a40:	70e2                	ld	ra,56(sp)
ffffffffc0202a42:	7442                	ld	s0,48(sp)
ffffffffc0202a44:	74a2                	ld	s1,40(sp)
ffffffffc0202a46:	6121                	addi	sp,sp,64
ffffffffc0202a48:	8082                	ret
ffffffffc0202a4a:	00094617          	auipc	a2,0x94
ffffffffc0202a4e:	e6663603          	ld	a2,-410(a2) # ffffffffc02968b0 <npage>
ffffffffc0202a52:	078a                	slli	a5,a5,0x2
ffffffffc0202a54:	83b1                	srli	a5,a5,0xc
ffffffffc0202a56:	08c7f763          	bgeu	a5,a2,ffffffffc0202ae4 <page_insert+0xf2>
ffffffffc0202a5a:	00094617          	auipc	a2,0x94
ffffffffc0202a5e:	e5e63603          	ld	a2,-418(a2) # ffffffffc02968b8 <pages>
ffffffffc0202a62:	fe000537          	lui	a0,0xfe000
ffffffffc0202a66:	079a                	slli	a5,a5,0x6
ffffffffc0202a68:	97aa                	add	a5,a5,a0
ffffffffc0202a6a:	00f60533          	add	a0,a2,a5
ffffffffc0202a6e:	00a40963          	beq	s0,a0,ffffffffc0202a80 <page_insert+0x8e>
ffffffffc0202a72:	411c                	lw	a5,0(a0)
ffffffffc0202a74:	37fd                	addiw	a5,a5,-1 # 1fffffff <_binary_bin_sfs_img_size+0x1ff8acff>
ffffffffc0202a76:	c11c                	sw	a5,0(a0)
ffffffffc0202a78:	c791                	beqz	a5,ffffffffc0202a84 <page_insert+0x92>
ffffffffc0202a7a:	12048073          	sfence.vma	s1
ffffffffc0202a7e:	b765                	j	ffffffffc0202a26 <page_insert+0x34>
ffffffffc0202a80:	c00c                	sw	a1,0(s0)
ffffffffc0202a82:	b755                	j	ffffffffc0202a26 <page_insert+0x34>
ffffffffc0202a84:	100027f3          	csrr	a5,sstatus
ffffffffc0202a88:	8b89                	andi	a5,a5,2
ffffffffc0202a8a:	e39d                	bnez	a5,ffffffffc0202ab0 <page_insert+0xbe>
ffffffffc0202a8c:	00094797          	auipc	a5,0x94
ffffffffc0202a90:	e047b783          	ld	a5,-508(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202a94:	4585                	li	a1,1
ffffffffc0202a96:	e83a                	sd	a4,16(sp)
ffffffffc0202a98:	739c                	ld	a5,32(a5)
ffffffffc0202a9a:	e436                	sd	a3,8(sp)
ffffffffc0202a9c:	9782                	jalr	a5
ffffffffc0202a9e:	00094617          	auipc	a2,0x94
ffffffffc0202aa2:	e1a63603          	ld	a2,-486(a2) # ffffffffc02968b8 <pages>
ffffffffc0202aa6:	66a2                	ld	a3,8(sp)
ffffffffc0202aa8:	6742                	ld	a4,16(sp)
ffffffffc0202aaa:	12048073          	sfence.vma	s1
ffffffffc0202aae:	bfa5                	j	ffffffffc0202a26 <page_insert+0x34>
ffffffffc0202ab0:	ec3a                	sd	a4,24(sp)
ffffffffc0202ab2:	e836                	sd	a3,16(sp)
ffffffffc0202ab4:	e42a                	sd	a0,8(sp)
ffffffffc0202ab6:	9bafe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0202aba:	00094797          	auipc	a5,0x94
ffffffffc0202abe:	dd67b783          	ld	a5,-554(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202ac2:	6522                	ld	a0,8(sp)
ffffffffc0202ac4:	4585                	li	a1,1
ffffffffc0202ac6:	739c                	ld	a5,32(a5)
ffffffffc0202ac8:	9782                	jalr	a5
ffffffffc0202aca:	9a0fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0202ace:	00094617          	auipc	a2,0x94
ffffffffc0202ad2:	dea63603          	ld	a2,-534(a2) # ffffffffc02968b8 <pages>
ffffffffc0202ad6:	6762                	ld	a4,24(sp)
ffffffffc0202ad8:	66c2                	ld	a3,16(sp)
ffffffffc0202ada:	12048073          	sfence.vma	s1
ffffffffc0202ade:	b7a1                	j	ffffffffc0202a26 <page_insert+0x34>
ffffffffc0202ae0:	5571                	li	a0,-4
ffffffffc0202ae2:	bfb9                	j	ffffffffc0202a40 <page_insert+0x4e>
ffffffffc0202ae4:	f14ff0ef          	jal	ffffffffc02021f8 <pa2page.part.0>

ffffffffc0202ae8 <pmm_init>:
ffffffffc0202ae8:	0000c797          	auipc	a5,0xc
ffffffffc0202aec:	13878793          	addi	a5,a5,312 # ffffffffc020ec20 <default_pmm_manager>
ffffffffc0202af0:	638c                	ld	a1,0(a5)
ffffffffc0202af2:	7159                	addi	sp,sp,-112
ffffffffc0202af4:	f486                	sd	ra,104(sp)
ffffffffc0202af6:	e8ca                	sd	s2,80(sp)
ffffffffc0202af8:	e4ce                	sd	s3,72(sp)
ffffffffc0202afa:	f85a                	sd	s6,48(sp)
ffffffffc0202afc:	f0a2                	sd	s0,96(sp)
ffffffffc0202afe:	eca6                	sd	s1,88(sp)
ffffffffc0202b00:	e0d2                	sd	s4,64(sp)
ffffffffc0202b02:	fc56                	sd	s5,56(sp)
ffffffffc0202b04:	f45e                	sd	s7,40(sp)
ffffffffc0202b06:	f062                	sd	s8,32(sp)
ffffffffc0202b08:	ec66                	sd	s9,24(sp)
ffffffffc0202b0a:	00094b17          	auipc	s6,0x94
ffffffffc0202b0e:	d86b0b13          	addi	s6,s6,-634 # ffffffffc0296890 <pmm_manager>
ffffffffc0202b12:	0000a517          	auipc	a0,0xa
ffffffffc0202b16:	ae650513          	addi	a0,a0,-1306 # ffffffffc020c5f8 <etext+0xffe>
ffffffffc0202b1a:	00fb3023          	sd	a5,0(s6)
ffffffffc0202b1e:	e88fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202b22:	000b3783          	ld	a5,0(s6)
ffffffffc0202b26:	00094997          	auipc	s3,0x94
ffffffffc0202b2a:	d8298993          	addi	s3,s3,-638 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202b2e:	679c                	ld	a5,8(a5)
ffffffffc0202b30:	9782                	jalr	a5
ffffffffc0202b32:	57f5                	li	a5,-3
ffffffffc0202b34:	07fa                	slli	a5,a5,0x1e
ffffffffc0202b36:	00f9b023          	sd	a5,0(s3)
ffffffffc0202b3a:	f07fd0ef          	jal	ffffffffc0200a40 <get_memory_base>
ffffffffc0202b3e:	892a                	mv	s2,a0
ffffffffc0202b40:	f0bfd0ef          	jal	ffffffffc0200a4a <get_memory_size>
ffffffffc0202b44:	70050e63          	beqz	a0,ffffffffc0203260 <pmm_init+0x778>
ffffffffc0202b48:	84aa                	mv	s1,a0
ffffffffc0202b4a:	0000a517          	auipc	a0,0xa
ffffffffc0202b4e:	ae650513          	addi	a0,a0,-1306 # ffffffffc020c630 <etext+0x1036>
ffffffffc0202b52:	e54fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202b56:	00990433          	add	s0,s2,s1
ffffffffc0202b5a:	864a                	mv	a2,s2
ffffffffc0202b5c:	85a6                	mv	a1,s1
ffffffffc0202b5e:	fff40693          	addi	a3,s0,-1
ffffffffc0202b62:	0000a517          	auipc	a0,0xa
ffffffffc0202b66:	ae650513          	addi	a0,a0,-1306 # ffffffffc020c648 <etext+0x104e>
ffffffffc0202b6a:	e3cfd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202b6e:	c80007b7          	lui	a5,0xc8000
ffffffffc0202b72:	8522                	mv	a0,s0
ffffffffc0202b74:	5287ed63          	bltu	a5,s0,ffffffffc02030ae <pmm_init+0x5c6>
ffffffffc0202b78:	77fd                	lui	a5,0xfffff
ffffffffc0202b7a:	00095617          	auipc	a2,0x95
ffffffffc0202b7e:	d9560613          	addi	a2,a2,-619 # ffffffffc029790f <end+0xfff>
ffffffffc0202b82:	8e7d                	and	a2,a2,a5
ffffffffc0202b84:	8131                	srli	a0,a0,0xc
ffffffffc0202b86:	00094b97          	auipc	s7,0x94
ffffffffc0202b8a:	d32b8b93          	addi	s7,s7,-718 # ffffffffc02968b8 <pages>
ffffffffc0202b8e:	00094497          	auipc	s1,0x94
ffffffffc0202b92:	d2248493          	addi	s1,s1,-734 # ffffffffc02968b0 <npage>
ffffffffc0202b96:	00cbb023          	sd	a2,0(s7)
ffffffffc0202b9a:	e088                	sd	a0,0(s1)
ffffffffc0202b9c:	000807b7          	lui	a5,0x80
ffffffffc0202ba0:	86b2                	mv	a3,a2
ffffffffc0202ba2:	02f50763          	beq	a0,a5,ffffffffc0202bd0 <pmm_init+0xe8>
ffffffffc0202ba6:	4701                	li	a4,0
ffffffffc0202ba8:	4585                	li	a1,1
ffffffffc0202baa:	fff806b7          	lui	a3,0xfff80
ffffffffc0202bae:	00671793          	slli	a5,a4,0x6
ffffffffc0202bb2:	97b2                	add	a5,a5,a2
ffffffffc0202bb4:	07a1                	addi	a5,a5,8 # 80008 <_binary_bin_sfs_img_size+0xad08>
ffffffffc0202bb6:	40b7b02f          	amoor.d	zero,a1,(a5)
ffffffffc0202bba:	6088                	ld	a0,0(s1)
ffffffffc0202bbc:	0705                	addi	a4,a4,1
ffffffffc0202bbe:	000bb603          	ld	a2,0(s7)
ffffffffc0202bc2:	00d507b3          	add	a5,a0,a3
ffffffffc0202bc6:	fef764e3          	bltu	a4,a5,ffffffffc0202bae <pmm_init+0xc6>
ffffffffc0202bca:	079a                	slli	a5,a5,0x6
ffffffffc0202bcc:	00f606b3          	add	a3,a2,a5
ffffffffc0202bd0:	c02007b7          	lui	a5,0xc0200
ffffffffc0202bd4:	16f6eee3          	bltu	a3,a5,ffffffffc0203550 <pmm_init+0xa68>
ffffffffc0202bd8:	0009b583          	ld	a1,0(s3)
ffffffffc0202bdc:	77fd                	lui	a5,0xfffff
ffffffffc0202bde:	8c7d                	and	s0,s0,a5
ffffffffc0202be0:	8e8d                	sub	a3,a3,a1
ffffffffc0202be2:	4e86ed63          	bltu	a3,s0,ffffffffc02030dc <pmm_init+0x5f4>
ffffffffc0202be6:	0000a517          	auipc	a0,0xa
ffffffffc0202bea:	a8a50513          	addi	a0,a0,-1398 # ffffffffc020c670 <etext+0x1076>
ffffffffc0202bee:	db8fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202bf2:	000b3783          	ld	a5,0(s6)
ffffffffc0202bf6:	00094917          	auipc	s2,0x94
ffffffffc0202bfa:	caa90913          	addi	s2,s2,-854 # ffffffffc02968a0 <boot_pgdir_va>
ffffffffc0202bfe:	7b9c                	ld	a5,48(a5)
ffffffffc0202c00:	9782                	jalr	a5
ffffffffc0202c02:	0000a517          	auipc	a0,0xa
ffffffffc0202c06:	a8650513          	addi	a0,a0,-1402 # ffffffffc020c688 <etext+0x108e>
ffffffffc0202c0a:	d9cfd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202c0e:	00010697          	auipc	a3,0x10
ffffffffc0202c12:	3f268693          	addi	a3,a3,1010 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc0202c16:	00d93023          	sd	a3,0(s2)
ffffffffc0202c1a:	c02007b7          	lui	a5,0xc0200
ffffffffc0202c1e:	2af6eee3          	bltu	a3,a5,ffffffffc02036da <pmm_init+0xbf2>
ffffffffc0202c22:	0009b783          	ld	a5,0(s3)
ffffffffc0202c26:	8e9d                	sub	a3,a3,a5
ffffffffc0202c28:	00094797          	auipc	a5,0x94
ffffffffc0202c2c:	c6d7b823          	sd	a3,-912(a5) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc0202c30:	100027f3          	csrr	a5,sstatus
ffffffffc0202c34:	8b89                	andi	a5,a5,2
ffffffffc0202c36:	48079963          	bnez	a5,ffffffffc02030c8 <pmm_init+0x5e0>
ffffffffc0202c3a:	000b3783          	ld	a5,0(s6)
ffffffffc0202c3e:	779c                	ld	a5,40(a5)
ffffffffc0202c40:	9782                	jalr	a5
ffffffffc0202c42:	842a                	mv	s0,a0
ffffffffc0202c44:	6098                	ld	a4,0(s1)
ffffffffc0202c46:	c80007b7          	lui	a5,0xc8000
ffffffffc0202c4a:	83b1                	srli	a5,a5,0xc
ffffffffc0202c4c:	66e7e663          	bltu	a5,a4,ffffffffc02032b8 <pmm_init+0x7d0>
ffffffffc0202c50:	00093503          	ld	a0,0(s2)
ffffffffc0202c54:	64050263          	beqz	a0,ffffffffc0203298 <pmm_init+0x7b0>
ffffffffc0202c58:	03451793          	slli	a5,a0,0x34
ffffffffc0202c5c:	62079e63          	bnez	a5,ffffffffc0203298 <pmm_init+0x7b0>
ffffffffc0202c60:	4601                	li	a2,0
ffffffffc0202c62:	4581                	li	a1,0
ffffffffc0202c64:	8b7ff0ef          	jal	ffffffffc020251a <get_page>
ffffffffc0202c68:	240519e3          	bnez	a0,ffffffffc02036ba <pmm_init+0xbd2>
ffffffffc0202c6c:	100027f3          	csrr	a5,sstatus
ffffffffc0202c70:	8b89                	andi	a5,a5,2
ffffffffc0202c72:	44079063          	bnez	a5,ffffffffc02030b2 <pmm_init+0x5ca>
ffffffffc0202c76:	000b3783          	ld	a5,0(s6)
ffffffffc0202c7a:	4505                	li	a0,1
ffffffffc0202c7c:	6f9c                	ld	a5,24(a5)
ffffffffc0202c7e:	9782                	jalr	a5
ffffffffc0202c80:	8a2a                	mv	s4,a0
ffffffffc0202c82:	00093503          	ld	a0,0(s2)
ffffffffc0202c86:	4681                	li	a3,0
ffffffffc0202c88:	4601                	li	a2,0
ffffffffc0202c8a:	85d2                	mv	a1,s4
ffffffffc0202c8c:	d67ff0ef          	jal	ffffffffc02029f2 <page_insert>
ffffffffc0202c90:	280511e3          	bnez	a0,ffffffffc0203712 <pmm_init+0xc2a>
ffffffffc0202c94:	00093503          	ld	a0,0(s2)
ffffffffc0202c98:	4601                	li	a2,0
ffffffffc0202c9a:	4581                	li	a1,0
ffffffffc0202c9c:	e20ff0ef          	jal	ffffffffc02022bc <get_pte>
ffffffffc0202ca0:	240509e3          	beqz	a0,ffffffffc02036f2 <pmm_init+0xc0a>
ffffffffc0202ca4:	611c                	ld	a5,0(a0)
ffffffffc0202ca6:	0017f713          	andi	a4,a5,1
ffffffffc0202caa:	58070f63          	beqz	a4,ffffffffc0203248 <pmm_init+0x760>
ffffffffc0202cae:	6098                	ld	a4,0(s1)
ffffffffc0202cb0:	078a                	slli	a5,a5,0x2
ffffffffc0202cb2:	83b1                	srli	a5,a5,0xc
ffffffffc0202cb4:	58e7f863          	bgeu	a5,a4,ffffffffc0203244 <pmm_init+0x75c>
ffffffffc0202cb8:	000bb683          	ld	a3,0(s7)
ffffffffc0202cbc:	079a                	slli	a5,a5,0x6
ffffffffc0202cbe:	fe000637          	lui	a2,0xfe000
ffffffffc0202cc2:	97b2                	add	a5,a5,a2
ffffffffc0202cc4:	97b6                	add	a5,a5,a3
ffffffffc0202cc6:	14fa1ae3          	bne	s4,a5,ffffffffc020361a <pmm_init+0xb32>
ffffffffc0202cca:	000a2683          	lw	a3,0(s4) # 200000 <_binary_bin_sfs_img_size+0x18ad00>
ffffffffc0202cce:	4785                	li	a5,1
ffffffffc0202cd0:	12f695e3          	bne	a3,a5,ffffffffc02035fa <pmm_init+0xb12>
ffffffffc0202cd4:	00093503          	ld	a0,0(s2)
ffffffffc0202cd8:	77fd                	lui	a5,0xfffff
ffffffffc0202cda:	6114                	ld	a3,0(a0)
ffffffffc0202cdc:	068a                	slli	a3,a3,0x2
ffffffffc0202cde:	8efd                	and	a3,a3,a5
ffffffffc0202ce0:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202ce4:	0ee67fe3          	bgeu	a2,a4,ffffffffc02035e2 <pmm_init+0xafa>
ffffffffc0202ce8:	0009bc03          	ld	s8,0(s3)
ffffffffc0202cec:	96e2                	add	a3,a3,s8
ffffffffc0202cee:	0006ba83          	ld	s5,0(a3)
ffffffffc0202cf2:	0a8a                	slli	s5,s5,0x2
ffffffffc0202cf4:	00fafab3          	and	s5,s5,a5
ffffffffc0202cf8:	00cad793          	srli	a5,s5,0xc
ffffffffc0202cfc:	0ce7f6e3          	bgeu	a5,a4,ffffffffc02035c8 <pmm_init+0xae0>
ffffffffc0202d00:	4601                	li	a2,0
ffffffffc0202d02:	6585                	lui	a1,0x1
ffffffffc0202d04:	9c56                	add	s8,s8,s5
ffffffffc0202d06:	db6ff0ef          	jal	ffffffffc02022bc <get_pte>
ffffffffc0202d0a:	0c21                	addi	s8,s8,8
ffffffffc0202d0c:	05851ee3          	bne	a0,s8,ffffffffc0203568 <pmm_init+0xa80>
ffffffffc0202d10:	100027f3          	csrr	a5,sstatus
ffffffffc0202d14:	8b89                	andi	a5,a5,2
ffffffffc0202d16:	3e079b63          	bnez	a5,ffffffffc020310c <pmm_init+0x624>
ffffffffc0202d1a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d1e:	4505                	li	a0,1
ffffffffc0202d20:	6f9c                	ld	a5,24(a5)
ffffffffc0202d22:	9782                	jalr	a5
ffffffffc0202d24:	8c2a                	mv	s8,a0
ffffffffc0202d26:	00093503          	ld	a0,0(s2)
ffffffffc0202d2a:	46d1                	li	a3,20
ffffffffc0202d2c:	6605                	lui	a2,0x1
ffffffffc0202d2e:	85e2                	mv	a1,s8
ffffffffc0202d30:	cc3ff0ef          	jal	ffffffffc02029f2 <page_insert>
ffffffffc0202d34:	06051ae3          	bnez	a0,ffffffffc02035a8 <pmm_init+0xac0>
ffffffffc0202d38:	00093503          	ld	a0,0(s2)
ffffffffc0202d3c:	4601                	li	a2,0
ffffffffc0202d3e:	6585                	lui	a1,0x1
ffffffffc0202d40:	d7cff0ef          	jal	ffffffffc02022bc <get_pte>
ffffffffc0202d44:	040502e3          	beqz	a0,ffffffffc0203588 <pmm_init+0xaa0>
ffffffffc0202d48:	611c                	ld	a5,0(a0)
ffffffffc0202d4a:	0107f713          	andi	a4,a5,16
ffffffffc0202d4e:	7e070163          	beqz	a4,ffffffffc0203530 <pmm_init+0xa48>
ffffffffc0202d52:	8b91                	andi	a5,a5,4
ffffffffc0202d54:	7a078e63          	beqz	a5,ffffffffc0203510 <pmm_init+0xa28>
ffffffffc0202d58:	00093503          	ld	a0,0(s2)
ffffffffc0202d5c:	611c                	ld	a5,0(a0)
ffffffffc0202d5e:	8bc1                	andi	a5,a5,16
ffffffffc0202d60:	78078863          	beqz	a5,ffffffffc02034f0 <pmm_init+0xa08>
ffffffffc0202d64:	000c2703          	lw	a4,0(s8)
ffffffffc0202d68:	4785                	li	a5,1
ffffffffc0202d6a:	76f71363          	bne	a4,a5,ffffffffc02034d0 <pmm_init+0x9e8>
ffffffffc0202d6e:	4681                	li	a3,0
ffffffffc0202d70:	6605                	lui	a2,0x1
ffffffffc0202d72:	85d2                	mv	a1,s4
ffffffffc0202d74:	c7fff0ef          	jal	ffffffffc02029f2 <page_insert>
ffffffffc0202d78:	72051c63          	bnez	a0,ffffffffc02034b0 <pmm_init+0x9c8>
ffffffffc0202d7c:	000a2703          	lw	a4,0(s4)
ffffffffc0202d80:	4789                	li	a5,2
ffffffffc0202d82:	70f71763          	bne	a4,a5,ffffffffc0203490 <pmm_init+0x9a8>
ffffffffc0202d86:	000c2783          	lw	a5,0(s8)
ffffffffc0202d8a:	6e079363          	bnez	a5,ffffffffc0203470 <pmm_init+0x988>
ffffffffc0202d8e:	00093503          	ld	a0,0(s2)
ffffffffc0202d92:	4601                	li	a2,0
ffffffffc0202d94:	6585                	lui	a1,0x1
ffffffffc0202d96:	d26ff0ef          	jal	ffffffffc02022bc <get_pte>
ffffffffc0202d9a:	6a050b63          	beqz	a0,ffffffffc0203450 <pmm_init+0x968>
ffffffffc0202d9e:	6118                	ld	a4,0(a0)
ffffffffc0202da0:	00177793          	andi	a5,a4,1
ffffffffc0202da4:	4a078263          	beqz	a5,ffffffffc0203248 <pmm_init+0x760>
ffffffffc0202da8:	6094                	ld	a3,0(s1)
ffffffffc0202daa:	00271793          	slli	a5,a4,0x2
ffffffffc0202dae:	83b1                	srli	a5,a5,0xc
ffffffffc0202db0:	48d7fa63          	bgeu	a5,a3,ffffffffc0203244 <pmm_init+0x75c>
ffffffffc0202db4:	000bb683          	ld	a3,0(s7)
ffffffffc0202db8:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202dbc:	97d6                	add	a5,a5,s5
ffffffffc0202dbe:	079a                	slli	a5,a5,0x6
ffffffffc0202dc0:	97b6                	add	a5,a5,a3
ffffffffc0202dc2:	66fa1763          	bne	s4,a5,ffffffffc0203430 <pmm_init+0x948>
ffffffffc0202dc6:	8b41                	andi	a4,a4,16
ffffffffc0202dc8:	64071463          	bnez	a4,ffffffffc0203410 <pmm_init+0x928>
ffffffffc0202dcc:	00093503          	ld	a0,0(s2)
ffffffffc0202dd0:	4581                	li	a1,0
ffffffffc0202dd2:	b85ff0ef          	jal	ffffffffc0202956 <page_remove>
ffffffffc0202dd6:	000a2c83          	lw	s9,0(s4)
ffffffffc0202dda:	4785                	li	a5,1
ffffffffc0202ddc:	60fc9a63          	bne	s9,a5,ffffffffc02033f0 <pmm_init+0x908>
ffffffffc0202de0:	000c2783          	lw	a5,0(s8)
ffffffffc0202de4:	5e079663          	bnez	a5,ffffffffc02033d0 <pmm_init+0x8e8>
ffffffffc0202de8:	00093503          	ld	a0,0(s2)
ffffffffc0202dec:	6585                	lui	a1,0x1
ffffffffc0202dee:	b69ff0ef          	jal	ffffffffc0202956 <page_remove>
ffffffffc0202df2:	000a2783          	lw	a5,0(s4)
ffffffffc0202df6:	52079d63          	bnez	a5,ffffffffc0203330 <pmm_init+0x848>
ffffffffc0202dfa:	000c2783          	lw	a5,0(s8)
ffffffffc0202dfe:	50079963          	bnez	a5,ffffffffc0203310 <pmm_init+0x828>
ffffffffc0202e02:	00093a03          	ld	s4,0(s2)
ffffffffc0202e06:	6098                	ld	a4,0(s1)
ffffffffc0202e08:	000a3783          	ld	a5,0(s4)
ffffffffc0202e0c:	078a                	slli	a5,a5,0x2
ffffffffc0202e0e:	83b1                	srli	a5,a5,0xc
ffffffffc0202e10:	42e7fa63          	bgeu	a5,a4,ffffffffc0203244 <pmm_init+0x75c>
ffffffffc0202e14:	000bb503          	ld	a0,0(s7)
ffffffffc0202e18:	97d6                	add	a5,a5,s5
ffffffffc0202e1a:	079a                	slli	a5,a5,0x6
ffffffffc0202e1c:	00f506b3          	add	a3,a0,a5
ffffffffc0202e20:	4294                	lw	a3,0(a3)
ffffffffc0202e22:	4d969763          	bne	a3,s9,ffffffffc02032f0 <pmm_init+0x808>
ffffffffc0202e26:	8799                	srai	a5,a5,0x6
ffffffffc0202e28:	00080637          	lui	a2,0x80
ffffffffc0202e2c:	97b2                	add	a5,a5,a2
ffffffffc0202e2e:	00c79693          	slli	a3,a5,0xc
ffffffffc0202e32:	4ae7f363          	bgeu	a5,a4,ffffffffc02032d8 <pmm_init+0x7f0>
ffffffffc0202e36:	0009b783          	ld	a5,0(s3)
ffffffffc0202e3a:	97b6                	add	a5,a5,a3
ffffffffc0202e3c:	639c                	ld	a5,0(a5)
ffffffffc0202e3e:	078a                	slli	a5,a5,0x2
ffffffffc0202e40:	83b1                	srli	a5,a5,0xc
ffffffffc0202e42:	40e7f163          	bgeu	a5,a4,ffffffffc0203244 <pmm_init+0x75c>
ffffffffc0202e46:	8f91                	sub	a5,a5,a2
ffffffffc0202e48:	079a                	slli	a5,a5,0x6
ffffffffc0202e4a:	953e                	add	a0,a0,a5
ffffffffc0202e4c:	100027f3          	csrr	a5,sstatus
ffffffffc0202e50:	8b89                	andi	a5,a5,2
ffffffffc0202e52:	30079863          	bnez	a5,ffffffffc0203162 <pmm_init+0x67a>
ffffffffc0202e56:	000b3783          	ld	a5,0(s6)
ffffffffc0202e5a:	4585                	li	a1,1
ffffffffc0202e5c:	739c                	ld	a5,32(a5)
ffffffffc0202e5e:	9782                	jalr	a5
ffffffffc0202e60:	000a3783          	ld	a5,0(s4)
ffffffffc0202e64:	6098                	ld	a4,0(s1)
ffffffffc0202e66:	078a                	slli	a5,a5,0x2
ffffffffc0202e68:	83b1                	srli	a5,a5,0xc
ffffffffc0202e6a:	3ce7fd63          	bgeu	a5,a4,ffffffffc0203244 <pmm_init+0x75c>
ffffffffc0202e6e:	000bb503          	ld	a0,0(s7)
ffffffffc0202e72:	fe000737          	lui	a4,0xfe000
ffffffffc0202e76:	079a                	slli	a5,a5,0x6
ffffffffc0202e78:	97ba                	add	a5,a5,a4
ffffffffc0202e7a:	953e                	add	a0,a0,a5
ffffffffc0202e7c:	100027f3          	csrr	a5,sstatus
ffffffffc0202e80:	8b89                	andi	a5,a5,2
ffffffffc0202e82:	2c079463          	bnez	a5,ffffffffc020314a <pmm_init+0x662>
ffffffffc0202e86:	000b3783          	ld	a5,0(s6)
ffffffffc0202e8a:	4585                	li	a1,1
ffffffffc0202e8c:	739c                	ld	a5,32(a5)
ffffffffc0202e8e:	9782                	jalr	a5
ffffffffc0202e90:	00093783          	ld	a5,0(s2)
ffffffffc0202e94:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0202e98:	12000073          	sfence.vma
ffffffffc0202e9c:	100027f3          	csrr	a5,sstatus
ffffffffc0202ea0:	8b89                	andi	a5,a5,2
ffffffffc0202ea2:	28079a63          	bnez	a5,ffffffffc0203136 <pmm_init+0x64e>
ffffffffc0202ea6:	000b3783          	ld	a5,0(s6)
ffffffffc0202eaa:	779c                	ld	a5,40(a5)
ffffffffc0202eac:	9782                	jalr	a5
ffffffffc0202eae:	8a2a                	mv	s4,a0
ffffffffc0202eb0:	4d441063          	bne	s0,s4,ffffffffc0203370 <pmm_init+0x888>
ffffffffc0202eb4:	0000a517          	auipc	a0,0xa
ffffffffc0202eb8:	b2450513          	addi	a0,a0,-1244 # ffffffffc020c9d8 <etext+0x13de>
ffffffffc0202ebc:	aeafd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202ec0:	100027f3          	csrr	a5,sstatus
ffffffffc0202ec4:	8b89                	andi	a5,a5,2
ffffffffc0202ec6:	24079e63          	bnez	a5,ffffffffc0203122 <pmm_init+0x63a>
ffffffffc0202eca:	000b3783          	ld	a5,0(s6)
ffffffffc0202ece:	779c                	ld	a5,40(a5)
ffffffffc0202ed0:	9782                	jalr	a5
ffffffffc0202ed2:	8c2a                	mv	s8,a0
ffffffffc0202ed4:	609c                	ld	a5,0(s1)
ffffffffc0202ed6:	c0200437          	lui	s0,0xc0200
ffffffffc0202eda:	7a7d                	lui	s4,0xfffff
ffffffffc0202edc:	00c79713          	slli	a4,a5,0xc
ffffffffc0202ee0:	6a85                	lui	s5,0x1
ffffffffc0202ee2:	02e47c63          	bgeu	s0,a4,ffffffffc0202f1a <pmm_init+0x432>
ffffffffc0202ee6:	00c45713          	srli	a4,s0,0xc
ffffffffc0202eea:	30f77063          	bgeu	a4,a5,ffffffffc02031ea <pmm_init+0x702>
ffffffffc0202eee:	0009b583          	ld	a1,0(s3)
ffffffffc0202ef2:	00093503          	ld	a0,0(s2)
ffffffffc0202ef6:	4601                	li	a2,0
ffffffffc0202ef8:	95a2                	add	a1,a1,s0
ffffffffc0202efa:	bc2ff0ef          	jal	ffffffffc02022bc <get_pte>
ffffffffc0202efe:	32050363          	beqz	a0,ffffffffc0203224 <pmm_init+0x73c>
ffffffffc0202f02:	611c                	ld	a5,0(a0)
ffffffffc0202f04:	078a                	slli	a5,a5,0x2
ffffffffc0202f06:	0147f7b3          	and	a5,a5,s4
ffffffffc0202f0a:	2e879d63          	bne	a5,s0,ffffffffc0203204 <pmm_init+0x71c>
ffffffffc0202f0e:	609c                	ld	a5,0(s1)
ffffffffc0202f10:	9456                	add	s0,s0,s5
ffffffffc0202f12:	00c79713          	slli	a4,a5,0xc
ffffffffc0202f16:	fce468e3          	bltu	s0,a4,ffffffffc0202ee6 <pmm_init+0x3fe>
ffffffffc0202f1a:	00093783          	ld	a5,0(s2)
ffffffffc0202f1e:	639c                	ld	a5,0(a5)
ffffffffc0202f20:	42079863          	bnez	a5,ffffffffc0203350 <pmm_init+0x868>
ffffffffc0202f24:	100027f3          	csrr	a5,sstatus
ffffffffc0202f28:	8b89                	andi	a5,a5,2
ffffffffc0202f2a:	24079863          	bnez	a5,ffffffffc020317a <pmm_init+0x692>
ffffffffc0202f2e:	000b3783          	ld	a5,0(s6)
ffffffffc0202f32:	4505                	li	a0,1
ffffffffc0202f34:	6f9c                	ld	a5,24(a5)
ffffffffc0202f36:	9782                	jalr	a5
ffffffffc0202f38:	842a                	mv	s0,a0
ffffffffc0202f3a:	00093503          	ld	a0,0(s2)
ffffffffc0202f3e:	4699                	li	a3,6
ffffffffc0202f40:	10000613          	li	a2,256
ffffffffc0202f44:	85a2                	mv	a1,s0
ffffffffc0202f46:	aadff0ef          	jal	ffffffffc02029f2 <page_insert>
ffffffffc0202f4a:	46051363          	bnez	a0,ffffffffc02033b0 <pmm_init+0x8c8>
ffffffffc0202f4e:	4018                	lw	a4,0(s0)
ffffffffc0202f50:	4785                	li	a5,1
ffffffffc0202f52:	42f71f63          	bne	a4,a5,ffffffffc0203390 <pmm_init+0x8a8>
ffffffffc0202f56:	00093503          	ld	a0,0(s2)
ffffffffc0202f5a:	6605                	lui	a2,0x1
ffffffffc0202f5c:	10060613          	addi	a2,a2,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc0202f60:	4699                	li	a3,6
ffffffffc0202f62:	85a2                	mv	a1,s0
ffffffffc0202f64:	a8fff0ef          	jal	ffffffffc02029f2 <page_insert>
ffffffffc0202f68:	72051963          	bnez	a0,ffffffffc020369a <pmm_init+0xbb2>
ffffffffc0202f6c:	4018                	lw	a4,0(s0)
ffffffffc0202f6e:	4789                	li	a5,2
ffffffffc0202f70:	70f71563          	bne	a4,a5,ffffffffc020367a <pmm_init+0xb92>
ffffffffc0202f74:	0000a597          	auipc	a1,0xa
ffffffffc0202f78:	bac58593          	addi	a1,a1,-1108 # ffffffffc020cb20 <etext+0x1526>
ffffffffc0202f7c:	10000513          	li	a0,256
ffffffffc0202f80:	592080ef          	jal	ffffffffc020b512 <strcpy>
ffffffffc0202f84:	6585                	lui	a1,0x1
ffffffffc0202f86:	10058593          	addi	a1,a1,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc0202f8a:	10000513          	li	a0,256
ffffffffc0202f8e:	596080ef          	jal	ffffffffc020b524 <strcmp>
ffffffffc0202f92:	6c051463          	bnez	a0,ffffffffc020365a <pmm_init+0xb72>
ffffffffc0202f96:	000bb683          	ld	a3,0(s7)
ffffffffc0202f9a:	000807b7          	lui	a5,0x80
ffffffffc0202f9e:	6098                	ld	a4,0(s1)
ffffffffc0202fa0:	40d406b3          	sub	a3,s0,a3
ffffffffc0202fa4:	8699                	srai	a3,a3,0x6
ffffffffc0202fa6:	96be                	add	a3,a3,a5
ffffffffc0202fa8:	00c69793          	slli	a5,a3,0xc
ffffffffc0202fac:	83b1                	srli	a5,a5,0xc
ffffffffc0202fae:	06b2                	slli	a3,a3,0xc
ffffffffc0202fb0:	32e7f463          	bgeu	a5,a4,ffffffffc02032d8 <pmm_init+0x7f0>
ffffffffc0202fb4:	0009b783          	ld	a5,0(s3)
ffffffffc0202fb8:	10000513          	li	a0,256
ffffffffc0202fbc:	97b6                	add	a5,a5,a3
ffffffffc0202fbe:	10078023          	sb	zero,256(a5) # 80100 <_binary_bin_sfs_img_size+0xae00>
ffffffffc0202fc2:	51c080ef          	jal	ffffffffc020b4de <strlen>
ffffffffc0202fc6:	66051a63          	bnez	a0,ffffffffc020363a <pmm_init+0xb52>
ffffffffc0202fca:	00093a03          	ld	s4,0(s2)
ffffffffc0202fce:	6098                	ld	a4,0(s1)
ffffffffc0202fd0:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0202fd4:	078a                	slli	a5,a5,0x2
ffffffffc0202fd6:	83b1                	srli	a5,a5,0xc
ffffffffc0202fd8:	26e7f663          	bgeu	a5,a4,ffffffffc0203244 <pmm_init+0x75c>
ffffffffc0202fdc:	00c79693          	slli	a3,a5,0xc
ffffffffc0202fe0:	2ee7fc63          	bgeu	a5,a4,ffffffffc02032d8 <pmm_init+0x7f0>
ffffffffc0202fe4:	0009b783          	ld	a5,0(s3)
ffffffffc0202fe8:	00f689b3          	add	s3,a3,a5
ffffffffc0202fec:	100027f3          	csrr	a5,sstatus
ffffffffc0202ff0:	8b89                	andi	a5,a5,2
ffffffffc0202ff2:	1e079163          	bnez	a5,ffffffffc02031d4 <pmm_init+0x6ec>
ffffffffc0202ff6:	000b3783          	ld	a5,0(s6)
ffffffffc0202ffa:	8522                	mv	a0,s0
ffffffffc0202ffc:	4585                	li	a1,1
ffffffffc0202ffe:	739c                	ld	a5,32(a5)
ffffffffc0203000:	9782                	jalr	a5
ffffffffc0203002:	0009b783          	ld	a5,0(s3)
ffffffffc0203006:	6098                	ld	a4,0(s1)
ffffffffc0203008:	078a                	slli	a5,a5,0x2
ffffffffc020300a:	83b1                	srli	a5,a5,0xc
ffffffffc020300c:	22e7fc63          	bgeu	a5,a4,ffffffffc0203244 <pmm_init+0x75c>
ffffffffc0203010:	000bb503          	ld	a0,0(s7)
ffffffffc0203014:	fe000737          	lui	a4,0xfe000
ffffffffc0203018:	079a                	slli	a5,a5,0x6
ffffffffc020301a:	97ba                	add	a5,a5,a4
ffffffffc020301c:	953e                	add	a0,a0,a5
ffffffffc020301e:	100027f3          	csrr	a5,sstatus
ffffffffc0203022:	8b89                	andi	a5,a5,2
ffffffffc0203024:	18079c63          	bnez	a5,ffffffffc02031bc <pmm_init+0x6d4>
ffffffffc0203028:	000b3783          	ld	a5,0(s6)
ffffffffc020302c:	4585                	li	a1,1
ffffffffc020302e:	739c                	ld	a5,32(a5)
ffffffffc0203030:	9782                	jalr	a5
ffffffffc0203032:	000a3783          	ld	a5,0(s4)
ffffffffc0203036:	6098                	ld	a4,0(s1)
ffffffffc0203038:	078a                	slli	a5,a5,0x2
ffffffffc020303a:	83b1                	srli	a5,a5,0xc
ffffffffc020303c:	20e7f463          	bgeu	a5,a4,ffffffffc0203244 <pmm_init+0x75c>
ffffffffc0203040:	000bb503          	ld	a0,0(s7)
ffffffffc0203044:	fe000737          	lui	a4,0xfe000
ffffffffc0203048:	079a                	slli	a5,a5,0x6
ffffffffc020304a:	97ba                	add	a5,a5,a4
ffffffffc020304c:	953e                	add	a0,a0,a5
ffffffffc020304e:	100027f3          	csrr	a5,sstatus
ffffffffc0203052:	8b89                	andi	a5,a5,2
ffffffffc0203054:	14079863          	bnez	a5,ffffffffc02031a4 <pmm_init+0x6bc>
ffffffffc0203058:	000b3783          	ld	a5,0(s6)
ffffffffc020305c:	4585                	li	a1,1
ffffffffc020305e:	739c                	ld	a5,32(a5)
ffffffffc0203060:	9782                	jalr	a5
ffffffffc0203062:	00093783          	ld	a5,0(s2)
ffffffffc0203066:	0007b023          	sd	zero,0(a5)
ffffffffc020306a:	12000073          	sfence.vma
ffffffffc020306e:	100027f3          	csrr	a5,sstatus
ffffffffc0203072:	8b89                	andi	a5,a5,2
ffffffffc0203074:	10079e63          	bnez	a5,ffffffffc0203190 <pmm_init+0x6a8>
ffffffffc0203078:	000b3783          	ld	a5,0(s6)
ffffffffc020307c:	779c                	ld	a5,40(a5)
ffffffffc020307e:	9782                	jalr	a5
ffffffffc0203080:	842a                	mv	s0,a0
ffffffffc0203082:	1e8c1b63          	bne	s8,s0,ffffffffc0203278 <pmm_init+0x790>
ffffffffc0203086:	0000a517          	auipc	a0,0xa
ffffffffc020308a:	b1250513          	addi	a0,a0,-1262 # ffffffffc020cb98 <etext+0x159e>
ffffffffc020308e:	918fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0203092:	7406                	ld	s0,96(sp)
ffffffffc0203094:	70a6                	ld	ra,104(sp)
ffffffffc0203096:	64e6                	ld	s1,88(sp)
ffffffffc0203098:	6946                	ld	s2,80(sp)
ffffffffc020309a:	69a6                	ld	s3,72(sp)
ffffffffc020309c:	6a06                	ld	s4,64(sp)
ffffffffc020309e:	7ae2                	ld	s5,56(sp)
ffffffffc02030a0:	7b42                	ld	s6,48(sp)
ffffffffc02030a2:	7ba2                	ld	s7,40(sp)
ffffffffc02030a4:	7c02                	ld	s8,32(sp)
ffffffffc02030a6:	6ce2                	ld	s9,24(sp)
ffffffffc02030a8:	6165                	addi	sp,sp,112
ffffffffc02030aa:	f83fe06f          	j	ffffffffc020202c <kmalloc_init>
ffffffffc02030ae:	853e                	mv	a0,a5
ffffffffc02030b0:	b4e1                	j	ffffffffc0202b78 <pmm_init+0x90>
ffffffffc02030b2:	bbffd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02030b6:	000b3783          	ld	a5,0(s6)
ffffffffc02030ba:	4505                	li	a0,1
ffffffffc02030bc:	6f9c                	ld	a5,24(a5)
ffffffffc02030be:	9782                	jalr	a5
ffffffffc02030c0:	8a2a                	mv	s4,a0
ffffffffc02030c2:	ba9fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02030c6:	be75                	j	ffffffffc0202c82 <pmm_init+0x19a>
ffffffffc02030c8:	ba9fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02030cc:	000b3783          	ld	a5,0(s6)
ffffffffc02030d0:	779c                	ld	a5,40(a5)
ffffffffc02030d2:	9782                	jalr	a5
ffffffffc02030d4:	842a                	mv	s0,a0
ffffffffc02030d6:	b95fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02030da:	b6ad                	j	ffffffffc0202c44 <pmm_init+0x15c>
ffffffffc02030dc:	6705                	lui	a4,0x1
ffffffffc02030de:	177d                	addi	a4,a4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc02030e0:	96ba                	add	a3,a3,a4
ffffffffc02030e2:	8ff5                	and	a5,a5,a3
ffffffffc02030e4:	00c7d713          	srli	a4,a5,0xc
ffffffffc02030e8:	14a77e63          	bgeu	a4,a0,ffffffffc0203244 <pmm_init+0x75c>
ffffffffc02030ec:	000b3683          	ld	a3,0(s6)
ffffffffc02030f0:	8c1d                	sub	s0,s0,a5
ffffffffc02030f2:	071a                	slli	a4,a4,0x6
ffffffffc02030f4:	fe0007b7          	lui	a5,0xfe000
ffffffffc02030f8:	973e                	add	a4,a4,a5
ffffffffc02030fa:	6a9c                	ld	a5,16(a3)
ffffffffc02030fc:	00c45593          	srli	a1,s0,0xc
ffffffffc0203100:	00e60533          	add	a0,a2,a4
ffffffffc0203104:	9782                	jalr	a5
ffffffffc0203106:	0009b583          	ld	a1,0(s3)
ffffffffc020310a:	bcf1                	j	ffffffffc0202be6 <pmm_init+0xfe>
ffffffffc020310c:	b65fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0203110:	000b3783          	ld	a5,0(s6)
ffffffffc0203114:	4505                	li	a0,1
ffffffffc0203116:	6f9c                	ld	a5,24(a5)
ffffffffc0203118:	9782                	jalr	a5
ffffffffc020311a:	8c2a                	mv	s8,a0
ffffffffc020311c:	b4ffd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0203120:	b119                	j	ffffffffc0202d26 <pmm_init+0x23e>
ffffffffc0203122:	b4ffd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0203126:	000b3783          	ld	a5,0(s6)
ffffffffc020312a:	779c                	ld	a5,40(a5)
ffffffffc020312c:	9782                	jalr	a5
ffffffffc020312e:	8c2a                	mv	s8,a0
ffffffffc0203130:	b3bfd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0203134:	b345                	j	ffffffffc0202ed4 <pmm_init+0x3ec>
ffffffffc0203136:	b3bfd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc020313a:	000b3783          	ld	a5,0(s6)
ffffffffc020313e:	779c                	ld	a5,40(a5)
ffffffffc0203140:	9782                	jalr	a5
ffffffffc0203142:	8a2a                	mv	s4,a0
ffffffffc0203144:	b27fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0203148:	b3a5                	j	ffffffffc0202eb0 <pmm_init+0x3c8>
ffffffffc020314a:	e42a                	sd	a0,8(sp)
ffffffffc020314c:	b25fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0203150:	000b3783          	ld	a5,0(s6)
ffffffffc0203154:	6522                	ld	a0,8(sp)
ffffffffc0203156:	4585                	li	a1,1
ffffffffc0203158:	739c                	ld	a5,32(a5)
ffffffffc020315a:	9782                	jalr	a5
ffffffffc020315c:	b0ffd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0203160:	bb05                	j	ffffffffc0202e90 <pmm_init+0x3a8>
ffffffffc0203162:	e42a                	sd	a0,8(sp)
ffffffffc0203164:	b0dfd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0203168:	000b3783          	ld	a5,0(s6)
ffffffffc020316c:	6522                	ld	a0,8(sp)
ffffffffc020316e:	4585                	li	a1,1
ffffffffc0203170:	739c                	ld	a5,32(a5)
ffffffffc0203172:	9782                	jalr	a5
ffffffffc0203174:	af7fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0203178:	b1e5                	j	ffffffffc0202e60 <pmm_init+0x378>
ffffffffc020317a:	af7fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc020317e:	000b3783          	ld	a5,0(s6)
ffffffffc0203182:	4505                	li	a0,1
ffffffffc0203184:	6f9c                	ld	a5,24(a5)
ffffffffc0203186:	9782                	jalr	a5
ffffffffc0203188:	842a                	mv	s0,a0
ffffffffc020318a:	ae1fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc020318e:	b375                	j	ffffffffc0202f3a <pmm_init+0x452>
ffffffffc0203190:	ae1fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0203194:	000b3783          	ld	a5,0(s6)
ffffffffc0203198:	779c                	ld	a5,40(a5)
ffffffffc020319a:	9782                	jalr	a5
ffffffffc020319c:	842a                	mv	s0,a0
ffffffffc020319e:	acdfd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02031a2:	b5c5                	j	ffffffffc0203082 <pmm_init+0x59a>
ffffffffc02031a4:	e42a                	sd	a0,8(sp)
ffffffffc02031a6:	acbfd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02031aa:	000b3783          	ld	a5,0(s6)
ffffffffc02031ae:	6522                	ld	a0,8(sp)
ffffffffc02031b0:	4585                	li	a1,1
ffffffffc02031b2:	739c                	ld	a5,32(a5)
ffffffffc02031b4:	9782                	jalr	a5
ffffffffc02031b6:	ab5fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02031ba:	b565                	j	ffffffffc0203062 <pmm_init+0x57a>
ffffffffc02031bc:	e42a                	sd	a0,8(sp)
ffffffffc02031be:	ab3fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02031c2:	000b3783          	ld	a5,0(s6)
ffffffffc02031c6:	6522                	ld	a0,8(sp)
ffffffffc02031c8:	4585                	li	a1,1
ffffffffc02031ca:	739c                	ld	a5,32(a5)
ffffffffc02031cc:	9782                	jalr	a5
ffffffffc02031ce:	a9dfd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02031d2:	b585                	j	ffffffffc0203032 <pmm_init+0x54a>
ffffffffc02031d4:	a9dfd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02031d8:	000b3783          	ld	a5,0(s6)
ffffffffc02031dc:	8522                	mv	a0,s0
ffffffffc02031de:	4585                	li	a1,1
ffffffffc02031e0:	739c                	ld	a5,32(a5)
ffffffffc02031e2:	9782                	jalr	a5
ffffffffc02031e4:	a87fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02031e8:	bd29                	j	ffffffffc0203002 <pmm_init+0x51a>
ffffffffc02031ea:	86a2                	mv	a3,s0
ffffffffc02031ec:	00009617          	auipc	a2,0x9
ffffffffc02031f0:	2c460613          	addi	a2,a2,708 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc02031f4:	25100593          	li	a1,593
ffffffffc02031f8:	00009517          	auipc	a0,0x9
ffffffffc02031fc:	3a850513          	addi	a0,a0,936 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203200:	a4afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203204:	0000a697          	auipc	a3,0xa
ffffffffc0203208:	83468693          	addi	a3,a3,-1996 # ffffffffc020ca38 <etext+0x143e>
ffffffffc020320c:	00009617          	auipc	a2,0x9
ffffffffc0203210:	82c60613          	addi	a2,a2,-2004 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203214:	25200593          	li	a1,594
ffffffffc0203218:	00009517          	auipc	a0,0x9
ffffffffc020321c:	38850513          	addi	a0,a0,904 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203220:	a2afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203224:	00009697          	auipc	a3,0x9
ffffffffc0203228:	7d468693          	addi	a3,a3,2004 # ffffffffc020c9f8 <etext+0x13fe>
ffffffffc020322c:	00009617          	auipc	a2,0x9
ffffffffc0203230:	80c60613          	addi	a2,a2,-2036 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203234:	25100593          	li	a1,593
ffffffffc0203238:	00009517          	auipc	a0,0x9
ffffffffc020323c:	36850513          	addi	a0,a0,872 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203240:	a0afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203244:	fb5fe0ef          	jal	ffffffffc02021f8 <pa2page.part.0>
ffffffffc0203248:	00009617          	auipc	a2,0x9
ffffffffc020324c:	55060613          	addi	a2,a2,1360 # ffffffffc020c798 <etext+0x119e>
ffffffffc0203250:	07f00593          	li	a1,127
ffffffffc0203254:	00009517          	auipc	a0,0x9
ffffffffc0203258:	28450513          	addi	a0,a0,644 # ffffffffc020c4d8 <etext+0xede>
ffffffffc020325c:	9eefd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203260:	00009617          	auipc	a2,0x9
ffffffffc0203264:	3b060613          	addi	a2,a2,944 # ffffffffc020c610 <etext+0x1016>
ffffffffc0203268:	06400593          	li	a1,100
ffffffffc020326c:	00009517          	auipc	a0,0x9
ffffffffc0203270:	33450513          	addi	a0,a0,820 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203274:	9d6fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203278:	00009697          	auipc	a3,0x9
ffffffffc020327c:	73868693          	addi	a3,a3,1848 # ffffffffc020c9b0 <etext+0x13b6>
ffffffffc0203280:	00008617          	auipc	a2,0x8
ffffffffc0203284:	7b860613          	addi	a2,a2,1976 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203288:	26c00593          	li	a1,620
ffffffffc020328c:	00009517          	auipc	a0,0x9
ffffffffc0203290:	31450513          	addi	a0,a0,788 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203294:	9b6fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203298:	00009697          	auipc	a3,0x9
ffffffffc020329c:	43068693          	addi	a3,a3,1072 # ffffffffc020c6c8 <etext+0x10ce>
ffffffffc02032a0:	00008617          	auipc	a2,0x8
ffffffffc02032a4:	79860613          	addi	a2,a2,1944 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02032a8:	21300593          	li	a1,531
ffffffffc02032ac:	00009517          	auipc	a0,0x9
ffffffffc02032b0:	2f450513          	addi	a0,a0,756 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02032b4:	996fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02032b8:	00009697          	auipc	a3,0x9
ffffffffc02032bc:	3f068693          	addi	a3,a3,1008 # ffffffffc020c6a8 <etext+0x10ae>
ffffffffc02032c0:	00008617          	auipc	a2,0x8
ffffffffc02032c4:	77860613          	addi	a2,a2,1912 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02032c8:	21200593          	li	a1,530
ffffffffc02032cc:	00009517          	auipc	a0,0x9
ffffffffc02032d0:	2d450513          	addi	a0,a0,724 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02032d4:	976fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02032d8:	00009617          	auipc	a2,0x9
ffffffffc02032dc:	1d860613          	addi	a2,a2,472 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc02032e0:	07100593          	li	a1,113
ffffffffc02032e4:	00009517          	auipc	a0,0x9
ffffffffc02032e8:	1f450513          	addi	a0,a0,500 # ffffffffc020c4d8 <etext+0xede>
ffffffffc02032ec:	95efd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02032f0:	00009697          	auipc	a3,0x9
ffffffffc02032f4:	69068693          	addi	a3,a3,1680 # ffffffffc020c980 <etext+0x1386>
ffffffffc02032f8:	00008617          	auipc	a2,0x8
ffffffffc02032fc:	74060613          	addi	a2,a2,1856 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203300:	23a00593          	li	a1,570
ffffffffc0203304:	00009517          	auipc	a0,0x9
ffffffffc0203308:	29c50513          	addi	a0,a0,668 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020330c:	93efd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203310:	00009697          	auipc	a3,0x9
ffffffffc0203314:	62868693          	addi	a3,a3,1576 # ffffffffc020c938 <etext+0x133e>
ffffffffc0203318:	00008617          	auipc	a2,0x8
ffffffffc020331c:	72060613          	addi	a2,a2,1824 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203320:	23800593          	li	a1,568
ffffffffc0203324:	00009517          	auipc	a0,0x9
ffffffffc0203328:	27c50513          	addi	a0,a0,636 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020332c:	91efd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203330:	00009697          	auipc	a3,0x9
ffffffffc0203334:	63868693          	addi	a3,a3,1592 # ffffffffc020c968 <etext+0x136e>
ffffffffc0203338:	00008617          	auipc	a2,0x8
ffffffffc020333c:	70060613          	addi	a2,a2,1792 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203340:	23700593          	li	a1,567
ffffffffc0203344:	00009517          	auipc	a0,0x9
ffffffffc0203348:	25c50513          	addi	a0,a0,604 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020334c:	8fefd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203350:	00009697          	auipc	a3,0x9
ffffffffc0203354:	70068693          	addi	a3,a3,1792 # ffffffffc020ca50 <etext+0x1456>
ffffffffc0203358:	00008617          	auipc	a2,0x8
ffffffffc020335c:	6e060613          	addi	a2,a2,1760 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203360:	25500593          	li	a1,597
ffffffffc0203364:	00009517          	auipc	a0,0x9
ffffffffc0203368:	23c50513          	addi	a0,a0,572 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020336c:	8defd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203370:	00009697          	auipc	a3,0x9
ffffffffc0203374:	64068693          	addi	a3,a3,1600 # ffffffffc020c9b0 <etext+0x13b6>
ffffffffc0203378:	00008617          	auipc	a2,0x8
ffffffffc020337c:	6c060613          	addi	a2,a2,1728 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203380:	24200593          	li	a1,578
ffffffffc0203384:	00009517          	auipc	a0,0x9
ffffffffc0203388:	21c50513          	addi	a0,a0,540 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020338c:	8befd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203390:	00009697          	auipc	a3,0x9
ffffffffc0203394:	71868693          	addi	a3,a3,1816 # ffffffffc020caa8 <etext+0x14ae>
ffffffffc0203398:	00008617          	auipc	a2,0x8
ffffffffc020339c:	6a060613          	addi	a2,a2,1696 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02033a0:	25a00593          	li	a1,602
ffffffffc02033a4:	00009517          	auipc	a0,0x9
ffffffffc02033a8:	1fc50513          	addi	a0,a0,508 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02033ac:	89efd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02033b0:	00009697          	auipc	a3,0x9
ffffffffc02033b4:	6b868693          	addi	a3,a3,1720 # ffffffffc020ca68 <etext+0x146e>
ffffffffc02033b8:	00008617          	auipc	a2,0x8
ffffffffc02033bc:	68060613          	addi	a2,a2,1664 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02033c0:	25900593          	li	a1,601
ffffffffc02033c4:	00009517          	auipc	a0,0x9
ffffffffc02033c8:	1dc50513          	addi	a0,a0,476 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02033cc:	87efd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02033d0:	00009697          	auipc	a3,0x9
ffffffffc02033d4:	56868693          	addi	a3,a3,1384 # ffffffffc020c938 <etext+0x133e>
ffffffffc02033d8:	00008617          	auipc	a2,0x8
ffffffffc02033dc:	66060613          	addi	a2,a2,1632 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02033e0:	23400593          	li	a1,564
ffffffffc02033e4:	00009517          	auipc	a0,0x9
ffffffffc02033e8:	1bc50513          	addi	a0,a0,444 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02033ec:	85efd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02033f0:	00009697          	auipc	a3,0x9
ffffffffc02033f4:	3e868693          	addi	a3,a3,1000 # ffffffffc020c7d8 <etext+0x11de>
ffffffffc02033f8:	00008617          	auipc	a2,0x8
ffffffffc02033fc:	64060613          	addi	a2,a2,1600 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203400:	23300593          	li	a1,563
ffffffffc0203404:	00009517          	auipc	a0,0x9
ffffffffc0203408:	19c50513          	addi	a0,a0,412 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020340c:	83efd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203410:	00009697          	auipc	a3,0x9
ffffffffc0203414:	54068693          	addi	a3,a3,1344 # ffffffffc020c950 <etext+0x1356>
ffffffffc0203418:	00008617          	auipc	a2,0x8
ffffffffc020341c:	62060613          	addi	a2,a2,1568 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203420:	23000593          	li	a1,560
ffffffffc0203424:	00009517          	auipc	a0,0x9
ffffffffc0203428:	17c50513          	addi	a0,a0,380 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020342c:	81efd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203430:	00009697          	auipc	a3,0x9
ffffffffc0203434:	39068693          	addi	a3,a3,912 # ffffffffc020c7c0 <etext+0x11c6>
ffffffffc0203438:	00008617          	auipc	a2,0x8
ffffffffc020343c:	60060613          	addi	a2,a2,1536 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203440:	22f00593          	li	a1,559
ffffffffc0203444:	00009517          	auipc	a0,0x9
ffffffffc0203448:	15c50513          	addi	a0,a0,348 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020344c:	ffffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203450:	00009697          	auipc	a3,0x9
ffffffffc0203454:	41068693          	addi	a3,a3,1040 # ffffffffc020c860 <etext+0x1266>
ffffffffc0203458:	00008617          	auipc	a2,0x8
ffffffffc020345c:	5e060613          	addi	a2,a2,1504 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203460:	22e00593          	li	a1,558
ffffffffc0203464:	00009517          	auipc	a0,0x9
ffffffffc0203468:	13c50513          	addi	a0,a0,316 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020346c:	fdffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203470:	00009697          	auipc	a3,0x9
ffffffffc0203474:	4c868693          	addi	a3,a3,1224 # ffffffffc020c938 <etext+0x133e>
ffffffffc0203478:	00008617          	auipc	a2,0x8
ffffffffc020347c:	5c060613          	addi	a2,a2,1472 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203480:	22d00593          	li	a1,557
ffffffffc0203484:	00009517          	auipc	a0,0x9
ffffffffc0203488:	11c50513          	addi	a0,a0,284 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020348c:	fbffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203490:	00009697          	auipc	a3,0x9
ffffffffc0203494:	49068693          	addi	a3,a3,1168 # ffffffffc020c920 <etext+0x1326>
ffffffffc0203498:	00008617          	auipc	a2,0x8
ffffffffc020349c:	5a060613          	addi	a2,a2,1440 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02034a0:	22c00593          	li	a1,556
ffffffffc02034a4:	00009517          	auipc	a0,0x9
ffffffffc02034a8:	0fc50513          	addi	a0,a0,252 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02034ac:	f9ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02034b0:	00009697          	auipc	a3,0x9
ffffffffc02034b4:	44068693          	addi	a3,a3,1088 # ffffffffc020c8f0 <etext+0x12f6>
ffffffffc02034b8:	00008617          	auipc	a2,0x8
ffffffffc02034bc:	58060613          	addi	a2,a2,1408 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02034c0:	22b00593          	li	a1,555
ffffffffc02034c4:	00009517          	auipc	a0,0x9
ffffffffc02034c8:	0dc50513          	addi	a0,a0,220 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02034cc:	f7ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02034d0:	00009697          	auipc	a3,0x9
ffffffffc02034d4:	40868693          	addi	a3,a3,1032 # ffffffffc020c8d8 <etext+0x12de>
ffffffffc02034d8:	00008617          	auipc	a2,0x8
ffffffffc02034dc:	56060613          	addi	a2,a2,1376 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02034e0:	22900593          	li	a1,553
ffffffffc02034e4:	00009517          	auipc	a0,0x9
ffffffffc02034e8:	0bc50513          	addi	a0,a0,188 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02034ec:	f5ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02034f0:	00009697          	auipc	a3,0x9
ffffffffc02034f4:	3c868693          	addi	a3,a3,968 # ffffffffc020c8b8 <etext+0x12be>
ffffffffc02034f8:	00008617          	auipc	a2,0x8
ffffffffc02034fc:	54060613          	addi	a2,a2,1344 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203500:	22800593          	li	a1,552
ffffffffc0203504:	00009517          	auipc	a0,0x9
ffffffffc0203508:	09c50513          	addi	a0,a0,156 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020350c:	f3ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203510:	00009697          	auipc	a3,0x9
ffffffffc0203514:	39868693          	addi	a3,a3,920 # ffffffffc020c8a8 <etext+0x12ae>
ffffffffc0203518:	00008617          	auipc	a2,0x8
ffffffffc020351c:	52060613          	addi	a2,a2,1312 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203520:	22700593          	li	a1,551
ffffffffc0203524:	00009517          	auipc	a0,0x9
ffffffffc0203528:	07c50513          	addi	a0,a0,124 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020352c:	f1ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203530:	00009697          	auipc	a3,0x9
ffffffffc0203534:	36868693          	addi	a3,a3,872 # ffffffffc020c898 <etext+0x129e>
ffffffffc0203538:	00008617          	auipc	a2,0x8
ffffffffc020353c:	50060613          	addi	a2,a2,1280 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203540:	22600593          	li	a1,550
ffffffffc0203544:	00009517          	auipc	a0,0x9
ffffffffc0203548:	05c50513          	addi	a0,a0,92 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020354c:	efffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203550:	00009617          	auipc	a2,0x9
ffffffffc0203554:	00860613          	addi	a2,a2,8 # ffffffffc020c558 <etext+0xf5e>
ffffffffc0203558:	08000593          	li	a1,128
ffffffffc020355c:	00009517          	auipc	a0,0x9
ffffffffc0203560:	04450513          	addi	a0,a0,68 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203564:	ee7fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203568:	00009697          	auipc	a3,0x9
ffffffffc020356c:	28868693          	addi	a3,a3,648 # ffffffffc020c7f0 <etext+0x11f6>
ffffffffc0203570:	00008617          	auipc	a2,0x8
ffffffffc0203574:	4c860613          	addi	a2,a2,1224 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203578:	22100593          	li	a1,545
ffffffffc020357c:	00009517          	auipc	a0,0x9
ffffffffc0203580:	02450513          	addi	a0,a0,36 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203584:	ec7fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203588:	00009697          	auipc	a3,0x9
ffffffffc020358c:	2d868693          	addi	a3,a3,728 # ffffffffc020c860 <etext+0x1266>
ffffffffc0203590:	00008617          	auipc	a2,0x8
ffffffffc0203594:	4a860613          	addi	a2,a2,1192 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203598:	22500593          	li	a1,549
ffffffffc020359c:	00009517          	auipc	a0,0x9
ffffffffc02035a0:	00450513          	addi	a0,a0,4 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02035a4:	ea7fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035a8:	00009697          	auipc	a3,0x9
ffffffffc02035ac:	27868693          	addi	a3,a3,632 # ffffffffc020c820 <etext+0x1226>
ffffffffc02035b0:	00008617          	auipc	a2,0x8
ffffffffc02035b4:	48860613          	addi	a2,a2,1160 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02035b8:	22400593          	li	a1,548
ffffffffc02035bc:	00009517          	auipc	a0,0x9
ffffffffc02035c0:	fe450513          	addi	a0,a0,-28 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02035c4:	e87fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035c8:	86d6                	mv	a3,s5
ffffffffc02035ca:	00009617          	auipc	a2,0x9
ffffffffc02035ce:	ee660613          	addi	a2,a2,-282 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc02035d2:	22000593          	li	a1,544
ffffffffc02035d6:	00009517          	auipc	a0,0x9
ffffffffc02035da:	fca50513          	addi	a0,a0,-54 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02035de:	e6dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035e2:	00009617          	auipc	a2,0x9
ffffffffc02035e6:	ece60613          	addi	a2,a2,-306 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc02035ea:	21f00593          	li	a1,543
ffffffffc02035ee:	00009517          	auipc	a0,0x9
ffffffffc02035f2:	fb250513          	addi	a0,a0,-78 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02035f6:	e55fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035fa:	00009697          	auipc	a3,0x9
ffffffffc02035fe:	1de68693          	addi	a3,a3,478 # ffffffffc020c7d8 <etext+0x11de>
ffffffffc0203602:	00008617          	auipc	a2,0x8
ffffffffc0203606:	43660613          	addi	a2,a2,1078 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020360a:	21d00593          	li	a1,541
ffffffffc020360e:	00009517          	auipc	a0,0x9
ffffffffc0203612:	f9250513          	addi	a0,a0,-110 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203616:	e35fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020361a:	00009697          	auipc	a3,0x9
ffffffffc020361e:	1a668693          	addi	a3,a3,422 # ffffffffc020c7c0 <etext+0x11c6>
ffffffffc0203622:	00008617          	auipc	a2,0x8
ffffffffc0203626:	41660613          	addi	a2,a2,1046 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020362a:	21c00593          	li	a1,540
ffffffffc020362e:	00009517          	auipc	a0,0x9
ffffffffc0203632:	f7250513          	addi	a0,a0,-142 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203636:	e15fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020363a:	00009697          	auipc	a3,0x9
ffffffffc020363e:	53668693          	addi	a3,a3,1334 # ffffffffc020cb70 <etext+0x1576>
ffffffffc0203642:	00008617          	auipc	a2,0x8
ffffffffc0203646:	3f660613          	addi	a2,a2,1014 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020364a:	26300593          	li	a1,611
ffffffffc020364e:	00009517          	auipc	a0,0x9
ffffffffc0203652:	f5250513          	addi	a0,a0,-174 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203656:	df5fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020365a:	00009697          	auipc	a3,0x9
ffffffffc020365e:	4de68693          	addi	a3,a3,1246 # ffffffffc020cb38 <etext+0x153e>
ffffffffc0203662:	00008617          	auipc	a2,0x8
ffffffffc0203666:	3d660613          	addi	a2,a2,982 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020366a:	26000593          	li	a1,608
ffffffffc020366e:	00009517          	auipc	a0,0x9
ffffffffc0203672:	f3250513          	addi	a0,a0,-206 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203676:	dd5fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020367a:	00009697          	auipc	a3,0x9
ffffffffc020367e:	48e68693          	addi	a3,a3,1166 # ffffffffc020cb08 <etext+0x150e>
ffffffffc0203682:	00008617          	auipc	a2,0x8
ffffffffc0203686:	3b660613          	addi	a2,a2,950 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020368a:	25c00593          	li	a1,604
ffffffffc020368e:	00009517          	auipc	a0,0x9
ffffffffc0203692:	f1250513          	addi	a0,a0,-238 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203696:	db5fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020369a:	00009697          	auipc	a3,0x9
ffffffffc020369e:	42668693          	addi	a3,a3,1062 # ffffffffc020cac0 <etext+0x14c6>
ffffffffc02036a2:	00008617          	auipc	a2,0x8
ffffffffc02036a6:	39660613          	addi	a2,a2,918 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02036aa:	25b00593          	li	a1,603
ffffffffc02036ae:	00009517          	auipc	a0,0x9
ffffffffc02036b2:	ef250513          	addi	a0,a0,-270 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02036b6:	d95fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02036ba:	00009697          	auipc	a3,0x9
ffffffffc02036be:	04e68693          	addi	a3,a3,78 # ffffffffc020c708 <etext+0x110e>
ffffffffc02036c2:	00008617          	auipc	a2,0x8
ffffffffc02036c6:	37660613          	addi	a2,a2,886 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02036ca:	21400593          	li	a1,532
ffffffffc02036ce:	00009517          	auipc	a0,0x9
ffffffffc02036d2:	ed250513          	addi	a0,a0,-302 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02036d6:	d75fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02036da:	00009617          	auipc	a2,0x9
ffffffffc02036de:	e7e60613          	addi	a2,a2,-386 # ffffffffc020c558 <etext+0xf5e>
ffffffffc02036e2:	0c800593          	li	a1,200
ffffffffc02036e6:	00009517          	auipc	a0,0x9
ffffffffc02036ea:	eba50513          	addi	a0,a0,-326 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02036ee:	d5dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02036f2:	00009697          	auipc	a3,0x9
ffffffffc02036f6:	07668693          	addi	a3,a3,118 # ffffffffc020c768 <etext+0x116e>
ffffffffc02036fa:	00008617          	auipc	a2,0x8
ffffffffc02036fe:	33e60613          	addi	a2,a2,830 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203702:	21b00593          	li	a1,539
ffffffffc0203706:	00009517          	auipc	a0,0x9
ffffffffc020370a:	e9a50513          	addi	a0,a0,-358 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020370e:	d3dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203712:	00009697          	auipc	a3,0x9
ffffffffc0203716:	02668693          	addi	a3,a3,38 # ffffffffc020c738 <etext+0x113e>
ffffffffc020371a:	00008617          	auipc	a2,0x8
ffffffffc020371e:	31e60613          	addi	a2,a2,798 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203722:	21800593          	li	a1,536
ffffffffc0203726:	00009517          	auipc	a0,0x9
ffffffffc020372a:	e7a50513          	addi	a0,a0,-390 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020372e:	d1dfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203732 <copy_range>:
ffffffffc0203732:	7159                	addi	sp,sp,-112
ffffffffc0203734:	00d667b3          	or	a5,a2,a3
ffffffffc0203738:	f486                	sd	ra,104(sp)
ffffffffc020373a:	f0a2                	sd	s0,96(sp)
ffffffffc020373c:	eca6                	sd	s1,88(sp)
ffffffffc020373e:	e8ca                	sd	s2,80(sp)
ffffffffc0203740:	e4ce                	sd	s3,72(sp)
ffffffffc0203742:	e0d2                	sd	s4,64(sp)
ffffffffc0203744:	fc56                	sd	s5,56(sp)
ffffffffc0203746:	f85a                	sd	s6,48(sp)
ffffffffc0203748:	f45e                	sd	s7,40(sp)
ffffffffc020374a:	f062                	sd	s8,32(sp)
ffffffffc020374c:	ec66                	sd	s9,24(sp)
ffffffffc020374e:	e86a                	sd	s10,16(sp)
ffffffffc0203750:	e46e                	sd	s11,8(sp)
ffffffffc0203752:	03479713          	slli	a4,a5,0x34
ffffffffc0203756:	20071f63          	bnez	a4,ffffffffc0203974 <copy_range+0x242>
ffffffffc020375a:	002007b7          	lui	a5,0x200
ffffffffc020375e:	00d63733          	sltu	a4,a2,a3
ffffffffc0203762:	00f637b3          	sltu	a5,a2,a5
ffffffffc0203766:	00173713          	seqz	a4,a4
ffffffffc020376a:	8fd9                	or	a5,a5,a4
ffffffffc020376c:	8432                	mv	s0,a2
ffffffffc020376e:	8936                	mv	s2,a3
ffffffffc0203770:	1e079263          	bnez	a5,ffffffffc0203954 <copy_range+0x222>
ffffffffc0203774:	4785                	li	a5,1
ffffffffc0203776:	07fe                	slli	a5,a5,0x1f
ffffffffc0203778:	0785                	addi	a5,a5,1 # 200001 <_binary_bin_sfs_img_size+0x18ad01>
ffffffffc020377a:	1cf6fd63          	bgeu	a3,a5,ffffffffc0203954 <copy_range+0x222>
ffffffffc020377e:	5b7d                	li	s6,-1
ffffffffc0203780:	8baa                	mv	s7,a0
ffffffffc0203782:	8a2e                	mv	s4,a1
ffffffffc0203784:	6a85                	lui	s5,0x1
ffffffffc0203786:	00cb5b13          	srli	s6,s6,0xc
ffffffffc020378a:	00093c97          	auipc	s9,0x93
ffffffffc020378e:	126c8c93          	addi	s9,s9,294 # ffffffffc02968b0 <npage>
ffffffffc0203792:	00093c17          	auipc	s8,0x93
ffffffffc0203796:	126c0c13          	addi	s8,s8,294 # ffffffffc02968b8 <pages>
ffffffffc020379a:	fff80d37          	lui	s10,0xfff80
ffffffffc020379e:	4601                	li	a2,0
ffffffffc02037a0:	85a2                	mv	a1,s0
ffffffffc02037a2:	8552                	mv	a0,s4
ffffffffc02037a4:	b19fe0ef          	jal	ffffffffc02022bc <get_pte>
ffffffffc02037a8:	84aa                	mv	s1,a0
ffffffffc02037aa:	0e050a63          	beqz	a0,ffffffffc020389e <copy_range+0x16c>
ffffffffc02037ae:	611c                	ld	a5,0(a0)
ffffffffc02037b0:	8b85                	andi	a5,a5,1
ffffffffc02037b2:	e78d                	bnez	a5,ffffffffc02037dc <copy_range+0xaa>
ffffffffc02037b4:	9456                	add	s0,s0,s5
ffffffffc02037b6:	c019                	beqz	s0,ffffffffc02037bc <copy_range+0x8a>
ffffffffc02037b8:	ff2463e3          	bltu	s0,s2,ffffffffc020379e <copy_range+0x6c>
ffffffffc02037bc:	4501                	li	a0,0
ffffffffc02037be:	70a6                	ld	ra,104(sp)
ffffffffc02037c0:	7406                	ld	s0,96(sp)
ffffffffc02037c2:	64e6                	ld	s1,88(sp)
ffffffffc02037c4:	6946                	ld	s2,80(sp)
ffffffffc02037c6:	69a6                	ld	s3,72(sp)
ffffffffc02037c8:	6a06                	ld	s4,64(sp)
ffffffffc02037ca:	7ae2                	ld	s5,56(sp)
ffffffffc02037cc:	7b42                	ld	s6,48(sp)
ffffffffc02037ce:	7ba2                	ld	s7,40(sp)
ffffffffc02037d0:	7c02                	ld	s8,32(sp)
ffffffffc02037d2:	6ce2                	ld	s9,24(sp)
ffffffffc02037d4:	6d42                	ld	s10,16(sp)
ffffffffc02037d6:	6da2                	ld	s11,8(sp)
ffffffffc02037d8:	6165                	addi	sp,sp,112
ffffffffc02037da:	8082                	ret
ffffffffc02037dc:	4605                	li	a2,1
ffffffffc02037de:	85a2                	mv	a1,s0
ffffffffc02037e0:	855e                	mv	a0,s7
ffffffffc02037e2:	adbfe0ef          	jal	ffffffffc02022bc <get_pte>
ffffffffc02037e6:	c165                	beqz	a0,ffffffffc02038c6 <copy_range+0x194>
ffffffffc02037e8:	0004b983          	ld	s3,0(s1)
ffffffffc02037ec:	0019f793          	andi	a5,s3,1
ffffffffc02037f0:	14078663          	beqz	a5,ffffffffc020393c <copy_range+0x20a>
ffffffffc02037f4:	000cb703          	ld	a4,0(s9)
ffffffffc02037f8:	00299793          	slli	a5,s3,0x2
ffffffffc02037fc:	83b1                	srli	a5,a5,0xc
ffffffffc02037fe:	12e7f363          	bgeu	a5,a4,ffffffffc0203924 <copy_range+0x1f2>
ffffffffc0203802:	000c3483          	ld	s1,0(s8)
ffffffffc0203806:	97ea                	add	a5,a5,s10
ffffffffc0203808:	079a                	slli	a5,a5,0x6
ffffffffc020380a:	94be                	add	s1,s1,a5
ffffffffc020380c:	100027f3          	csrr	a5,sstatus
ffffffffc0203810:	8b89                	andi	a5,a5,2
ffffffffc0203812:	efc9                	bnez	a5,ffffffffc02038ac <copy_range+0x17a>
ffffffffc0203814:	00093797          	auipc	a5,0x93
ffffffffc0203818:	07c7b783          	ld	a5,124(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc020381c:	4505                	li	a0,1
ffffffffc020381e:	6f9c                	ld	a5,24(a5)
ffffffffc0203820:	9782                	jalr	a5
ffffffffc0203822:	8daa                	mv	s11,a0
ffffffffc0203824:	c0e5                	beqz	s1,ffffffffc0203904 <copy_range+0x1d2>
ffffffffc0203826:	0a0d8f63          	beqz	s11,ffffffffc02038e4 <copy_range+0x1b2>
ffffffffc020382a:	000c3783          	ld	a5,0(s8)
ffffffffc020382e:	00080637          	lui	a2,0x80
ffffffffc0203832:	000cb703          	ld	a4,0(s9)
ffffffffc0203836:	40f486b3          	sub	a3,s1,a5
ffffffffc020383a:	8699                	srai	a3,a3,0x6
ffffffffc020383c:	96b2                	add	a3,a3,a2
ffffffffc020383e:	0166f5b3          	and	a1,a3,s6
ffffffffc0203842:	06b2                	slli	a3,a3,0xc
ffffffffc0203844:	08e5f463          	bgeu	a1,a4,ffffffffc02038cc <copy_range+0x19a>
ffffffffc0203848:	40fd87b3          	sub	a5,s11,a5
ffffffffc020384c:	8799                	srai	a5,a5,0x6
ffffffffc020384e:	97b2                	add	a5,a5,a2
ffffffffc0203850:	0167f633          	and	a2,a5,s6
ffffffffc0203854:	07b2                	slli	a5,a5,0xc
ffffffffc0203856:	06e67a63          	bgeu	a2,a4,ffffffffc02038ca <copy_range+0x198>
ffffffffc020385a:	00093517          	auipc	a0,0x93
ffffffffc020385e:	04e53503          	ld	a0,78(a0) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0203862:	6605                	lui	a2,0x1
ffffffffc0203864:	00a685b3          	add	a1,a3,a0
ffffffffc0203868:	953e                	add	a0,a0,a5
ffffffffc020386a:	579070ef          	jal	ffffffffc020b5e2 <memcpy>
ffffffffc020386e:	01f9f693          	andi	a3,s3,31
ffffffffc0203872:	85ee                	mv	a1,s11
ffffffffc0203874:	8622                	mv	a2,s0
ffffffffc0203876:	855e                	mv	a0,s7
ffffffffc0203878:	97aff0ef          	jal	ffffffffc02029f2 <page_insert>
ffffffffc020387c:	dd05                	beqz	a0,ffffffffc02037b4 <copy_range+0x82>
ffffffffc020387e:	00009697          	auipc	a3,0x9
ffffffffc0203882:	35a68693          	addi	a3,a3,858 # ffffffffc020cbd8 <etext+0x15de>
ffffffffc0203886:	00008617          	auipc	a2,0x8
ffffffffc020388a:	1b260613          	addi	a2,a2,434 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020388e:	1b000593          	li	a1,432
ffffffffc0203892:	00009517          	auipc	a0,0x9
ffffffffc0203896:	d0e50513          	addi	a0,a0,-754 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc020389a:	bb1fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020389e:	002007b7          	lui	a5,0x200
ffffffffc02038a2:	97a2                	add	a5,a5,s0
ffffffffc02038a4:	ffe00437          	lui	s0,0xffe00
ffffffffc02038a8:	8c7d                	and	s0,s0,a5
ffffffffc02038aa:	b731                	j	ffffffffc02037b6 <copy_range+0x84>
ffffffffc02038ac:	bc4fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02038b0:	00093797          	auipc	a5,0x93
ffffffffc02038b4:	fe07b783          	ld	a5,-32(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02038b8:	4505                	li	a0,1
ffffffffc02038ba:	6f9c                	ld	a5,24(a5)
ffffffffc02038bc:	9782                	jalr	a5
ffffffffc02038be:	8daa                	mv	s11,a0
ffffffffc02038c0:	baafd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02038c4:	b785                	j	ffffffffc0203824 <copy_range+0xf2>
ffffffffc02038c6:	5571                	li	a0,-4
ffffffffc02038c8:	bddd                	j	ffffffffc02037be <copy_range+0x8c>
ffffffffc02038ca:	86be                	mv	a3,a5
ffffffffc02038cc:	00009617          	auipc	a2,0x9
ffffffffc02038d0:	be460613          	addi	a2,a2,-1052 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc02038d4:	07100593          	li	a1,113
ffffffffc02038d8:	00009517          	auipc	a0,0x9
ffffffffc02038dc:	c0050513          	addi	a0,a0,-1024 # ffffffffc020c4d8 <etext+0xede>
ffffffffc02038e0:	b6bfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02038e4:	00009697          	auipc	a3,0x9
ffffffffc02038e8:	2e468693          	addi	a3,a3,740 # ffffffffc020cbc8 <etext+0x15ce>
ffffffffc02038ec:	00008617          	auipc	a2,0x8
ffffffffc02038f0:	14c60613          	addi	a2,a2,332 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02038f4:	19600593          	li	a1,406
ffffffffc02038f8:	00009517          	auipc	a0,0x9
ffffffffc02038fc:	ca850513          	addi	a0,a0,-856 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203900:	b4bfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203904:	00009697          	auipc	a3,0x9
ffffffffc0203908:	2b468693          	addi	a3,a3,692 # ffffffffc020cbb8 <etext+0x15be>
ffffffffc020390c:	00008617          	auipc	a2,0x8
ffffffffc0203910:	12c60613          	addi	a2,a2,300 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203914:	19500593          	li	a1,405
ffffffffc0203918:	00009517          	auipc	a0,0x9
ffffffffc020391c:	c8850513          	addi	a0,a0,-888 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203920:	b2bfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203924:	00009617          	auipc	a2,0x9
ffffffffc0203928:	c5c60613          	addi	a2,a2,-932 # ffffffffc020c580 <etext+0xf86>
ffffffffc020392c:	06900593          	li	a1,105
ffffffffc0203930:	00009517          	auipc	a0,0x9
ffffffffc0203934:	ba850513          	addi	a0,a0,-1112 # ffffffffc020c4d8 <etext+0xede>
ffffffffc0203938:	b13fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020393c:	00009617          	auipc	a2,0x9
ffffffffc0203940:	e5c60613          	addi	a2,a2,-420 # ffffffffc020c798 <etext+0x119e>
ffffffffc0203944:	07f00593          	li	a1,127
ffffffffc0203948:	00009517          	auipc	a0,0x9
ffffffffc020394c:	b9050513          	addi	a0,a0,-1136 # ffffffffc020c4d8 <etext+0xede>
ffffffffc0203950:	afbfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203954:	00009697          	auipc	a3,0x9
ffffffffc0203958:	c8c68693          	addi	a3,a3,-884 # ffffffffc020c5e0 <etext+0xfe6>
ffffffffc020395c:	00008617          	auipc	a2,0x8
ffffffffc0203960:	0dc60613          	addi	a2,a2,220 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203964:	17d00593          	li	a1,381
ffffffffc0203968:	00009517          	auipc	a0,0x9
ffffffffc020396c:	c3850513          	addi	a0,a0,-968 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203970:	adbfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203974:	00009697          	auipc	a3,0x9
ffffffffc0203978:	c3c68693          	addi	a3,a3,-964 # ffffffffc020c5b0 <etext+0xfb6>
ffffffffc020397c:	00008617          	auipc	a2,0x8
ffffffffc0203980:	0bc60613          	addi	a2,a2,188 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203984:	17c00593          	li	a1,380
ffffffffc0203988:	00009517          	auipc	a0,0x9
ffffffffc020398c:	c1850513          	addi	a0,a0,-1000 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc0203990:	abbfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203994 <pgdir_alloc_page>:
ffffffffc0203994:	7139                	addi	sp,sp,-64
ffffffffc0203996:	f426                	sd	s1,40(sp)
ffffffffc0203998:	f04a                	sd	s2,32(sp)
ffffffffc020399a:	ec4e                	sd	s3,24(sp)
ffffffffc020399c:	fc06                	sd	ra,56(sp)
ffffffffc020399e:	f822                	sd	s0,48(sp)
ffffffffc02039a0:	892a                	mv	s2,a0
ffffffffc02039a2:	84ae                	mv	s1,a1
ffffffffc02039a4:	89b2                	mv	s3,a2
ffffffffc02039a6:	100027f3          	csrr	a5,sstatus
ffffffffc02039aa:	8b89                	andi	a5,a5,2
ffffffffc02039ac:	ebb5                	bnez	a5,ffffffffc0203a20 <pgdir_alloc_page+0x8c>
ffffffffc02039ae:	00093417          	auipc	s0,0x93
ffffffffc02039b2:	ee240413          	addi	s0,s0,-286 # ffffffffc0296890 <pmm_manager>
ffffffffc02039b6:	601c                	ld	a5,0(s0)
ffffffffc02039b8:	4505                	li	a0,1
ffffffffc02039ba:	6f9c                	ld	a5,24(a5)
ffffffffc02039bc:	9782                	jalr	a5
ffffffffc02039be:	85aa                	mv	a1,a0
ffffffffc02039c0:	c5b9                	beqz	a1,ffffffffc0203a0e <pgdir_alloc_page+0x7a>
ffffffffc02039c2:	86ce                	mv	a3,s3
ffffffffc02039c4:	854a                	mv	a0,s2
ffffffffc02039c6:	8626                	mv	a2,s1
ffffffffc02039c8:	e42e                	sd	a1,8(sp)
ffffffffc02039ca:	828ff0ef          	jal	ffffffffc02029f2 <page_insert>
ffffffffc02039ce:	65a2                	ld	a1,8(sp)
ffffffffc02039d0:	e515                	bnez	a0,ffffffffc02039fc <pgdir_alloc_page+0x68>
ffffffffc02039d2:	4198                	lw	a4,0(a1)
ffffffffc02039d4:	fd84                	sd	s1,56(a1)
ffffffffc02039d6:	4785                	li	a5,1
ffffffffc02039d8:	02f70c63          	beq	a4,a5,ffffffffc0203a10 <pgdir_alloc_page+0x7c>
ffffffffc02039dc:	00009697          	auipc	a3,0x9
ffffffffc02039e0:	20c68693          	addi	a3,a3,524 # ffffffffc020cbe8 <etext+0x15ee>
ffffffffc02039e4:	00008617          	auipc	a2,0x8
ffffffffc02039e8:	05460613          	addi	a2,a2,84 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02039ec:	1f900593          	li	a1,505
ffffffffc02039f0:	00009517          	auipc	a0,0x9
ffffffffc02039f4:	bb050513          	addi	a0,a0,-1104 # ffffffffc020c5a0 <etext+0xfa6>
ffffffffc02039f8:	a53fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02039fc:	100027f3          	csrr	a5,sstatus
ffffffffc0203a00:	8b89                	andi	a5,a5,2
ffffffffc0203a02:	ef95                	bnez	a5,ffffffffc0203a3e <pgdir_alloc_page+0xaa>
ffffffffc0203a04:	601c                	ld	a5,0(s0)
ffffffffc0203a06:	852e                	mv	a0,a1
ffffffffc0203a08:	4585                	li	a1,1
ffffffffc0203a0a:	739c                	ld	a5,32(a5)
ffffffffc0203a0c:	9782                	jalr	a5
ffffffffc0203a0e:	4581                	li	a1,0
ffffffffc0203a10:	70e2                	ld	ra,56(sp)
ffffffffc0203a12:	7442                	ld	s0,48(sp)
ffffffffc0203a14:	74a2                	ld	s1,40(sp)
ffffffffc0203a16:	7902                	ld	s2,32(sp)
ffffffffc0203a18:	69e2                	ld	s3,24(sp)
ffffffffc0203a1a:	852e                	mv	a0,a1
ffffffffc0203a1c:	6121                	addi	sp,sp,64
ffffffffc0203a1e:	8082                	ret
ffffffffc0203a20:	a50fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0203a24:	00093417          	auipc	s0,0x93
ffffffffc0203a28:	e6c40413          	addi	s0,s0,-404 # ffffffffc0296890 <pmm_manager>
ffffffffc0203a2c:	601c                	ld	a5,0(s0)
ffffffffc0203a2e:	4505                	li	a0,1
ffffffffc0203a30:	6f9c                	ld	a5,24(a5)
ffffffffc0203a32:	9782                	jalr	a5
ffffffffc0203a34:	e42a                	sd	a0,8(sp)
ffffffffc0203a36:	a34fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0203a3a:	65a2                	ld	a1,8(sp)
ffffffffc0203a3c:	b751                	j	ffffffffc02039c0 <pgdir_alloc_page+0x2c>
ffffffffc0203a3e:	a32fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0203a42:	601c                	ld	a5,0(s0)
ffffffffc0203a44:	6522                	ld	a0,8(sp)
ffffffffc0203a46:	4585                	li	a1,1
ffffffffc0203a48:	739c                	ld	a5,32(a5)
ffffffffc0203a4a:	9782                	jalr	a5
ffffffffc0203a4c:	a1efd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0203a50:	bf7d                	j	ffffffffc0203a0e <pgdir_alloc_page+0x7a>

ffffffffc0203a52 <check_vma_overlap.part.0>:
ffffffffc0203a52:	1141                	addi	sp,sp,-16
ffffffffc0203a54:	00009697          	auipc	a3,0x9
ffffffffc0203a58:	1ac68693          	addi	a3,a3,428 # ffffffffc020cc00 <etext+0x1606>
ffffffffc0203a5c:	00008617          	auipc	a2,0x8
ffffffffc0203a60:	fdc60613          	addi	a2,a2,-36 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203a64:	07400593          	li	a1,116
ffffffffc0203a68:	00009517          	auipc	a0,0x9
ffffffffc0203a6c:	1b850513          	addi	a0,a0,440 # ffffffffc020cc20 <etext+0x1626>
ffffffffc0203a70:	e406                	sd	ra,8(sp)
ffffffffc0203a72:	9d9fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203a76 <mm_create>:
ffffffffc0203a76:	1101                	addi	sp,sp,-32
ffffffffc0203a78:	05800513          	li	a0,88
ffffffffc0203a7c:	ec06                	sd	ra,24(sp)
ffffffffc0203a7e:	dd2fe0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc0203a82:	87aa                	mv	a5,a0
ffffffffc0203a84:	c505                	beqz	a0,ffffffffc0203aac <mm_create+0x36>
ffffffffc0203a86:	e788                	sd	a0,8(a5)
ffffffffc0203a88:	e388                	sd	a0,0(a5)
ffffffffc0203a8a:	00053823          	sd	zero,16(a0)
ffffffffc0203a8e:	00053c23          	sd	zero,24(a0)
ffffffffc0203a92:	02052023          	sw	zero,32(a0)
ffffffffc0203a96:	02053423          	sd	zero,40(a0)
ffffffffc0203a9a:	02052823          	sw	zero,48(a0)
ffffffffc0203a9e:	4585                	li	a1,1
ffffffffc0203aa0:	03850513          	addi	a0,a0,56
ffffffffc0203aa4:	e43e                	sd	a5,8(sp)
ffffffffc0203aa6:	169000ef          	jal	ffffffffc020440e <sem_init>
ffffffffc0203aaa:	67a2                	ld	a5,8(sp)
ffffffffc0203aac:	60e2                	ld	ra,24(sp)
ffffffffc0203aae:	853e                	mv	a0,a5
ffffffffc0203ab0:	6105                	addi	sp,sp,32
ffffffffc0203ab2:	8082                	ret

ffffffffc0203ab4 <find_vma>:
ffffffffc0203ab4:	c505                	beqz	a0,ffffffffc0203adc <find_vma+0x28>
ffffffffc0203ab6:	691c                	ld	a5,16(a0)
ffffffffc0203ab8:	c781                	beqz	a5,ffffffffc0203ac0 <find_vma+0xc>
ffffffffc0203aba:	6798                	ld	a4,8(a5)
ffffffffc0203abc:	02e5f363          	bgeu	a1,a4,ffffffffc0203ae2 <find_vma+0x2e>
ffffffffc0203ac0:	651c                	ld	a5,8(a0)
ffffffffc0203ac2:	00f50d63          	beq	a0,a5,ffffffffc0203adc <find_vma+0x28>
ffffffffc0203ac6:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203aca:	00e5e663          	bltu	a1,a4,ffffffffc0203ad6 <find_vma+0x22>
ffffffffc0203ace:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203ad2:	00e5ee63          	bltu	a1,a4,ffffffffc0203aee <find_vma+0x3a>
ffffffffc0203ad6:	679c                	ld	a5,8(a5)
ffffffffc0203ad8:	fef517e3          	bne	a0,a5,ffffffffc0203ac6 <find_vma+0x12>
ffffffffc0203adc:	4781                	li	a5,0
ffffffffc0203ade:	853e                	mv	a0,a5
ffffffffc0203ae0:	8082                	ret
ffffffffc0203ae2:	6b98                	ld	a4,16(a5)
ffffffffc0203ae4:	fce5fee3          	bgeu	a1,a4,ffffffffc0203ac0 <find_vma+0xc>
ffffffffc0203ae8:	e91c                	sd	a5,16(a0)
ffffffffc0203aea:	853e                	mv	a0,a5
ffffffffc0203aec:	8082                	ret
ffffffffc0203aee:	1781                	addi	a5,a5,-32
ffffffffc0203af0:	e91c                	sd	a5,16(a0)
ffffffffc0203af2:	bfe5                	j	ffffffffc0203aea <find_vma+0x36>

ffffffffc0203af4 <insert_vma_struct>:
ffffffffc0203af4:	6590                	ld	a2,8(a1)
ffffffffc0203af6:	0105b803          	ld	a6,16(a1)
ffffffffc0203afa:	1141                	addi	sp,sp,-16
ffffffffc0203afc:	e406                	sd	ra,8(sp)
ffffffffc0203afe:	87aa                	mv	a5,a0
ffffffffc0203b00:	01066763          	bltu	a2,a6,ffffffffc0203b0e <insert_vma_struct+0x1a>
ffffffffc0203b04:	a8b9                	j	ffffffffc0203b62 <insert_vma_struct+0x6e>
ffffffffc0203b06:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203b0a:	04e66763          	bltu	a2,a4,ffffffffc0203b58 <insert_vma_struct+0x64>
ffffffffc0203b0e:	86be                	mv	a3,a5
ffffffffc0203b10:	679c                	ld	a5,8(a5)
ffffffffc0203b12:	fef51ae3          	bne	a0,a5,ffffffffc0203b06 <insert_vma_struct+0x12>
ffffffffc0203b16:	02a68463          	beq	a3,a0,ffffffffc0203b3e <insert_vma_struct+0x4a>
ffffffffc0203b1a:	ff06b703          	ld	a4,-16(a3)
ffffffffc0203b1e:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203b22:	08e8f063          	bgeu	a7,a4,ffffffffc0203ba2 <insert_vma_struct+0xae>
ffffffffc0203b26:	04e66e63          	bltu	a2,a4,ffffffffc0203b82 <insert_vma_struct+0x8e>
ffffffffc0203b2a:	00f50a63          	beq	a0,a5,ffffffffc0203b3e <insert_vma_struct+0x4a>
ffffffffc0203b2e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203b32:	05076863          	bltu	a4,a6,ffffffffc0203b82 <insert_vma_struct+0x8e>
ffffffffc0203b36:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203b3a:	02c77263          	bgeu	a4,a2,ffffffffc0203b5e <insert_vma_struct+0x6a>
ffffffffc0203b3e:	5118                	lw	a4,32(a0)
ffffffffc0203b40:	e188                	sd	a0,0(a1)
ffffffffc0203b42:	02058613          	addi	a2,a1,32
ffffffffc0203b46:	e390                	sd	a2,0(a5)
ffffffffc0203b48:	e690                	sd	a2,8(a3)
ffffffffc0203b4a:	60a2                	ld	ra,8(sp)
ffffffffc0203b4c:	f59c                	sd	a5,40(a1)
ffffffffc0203b4e:	f194                	sd	a3,32(a1)
ffffffffc0203b50:	2705                	addiw	a4,a4,1
ffffffffc0203b52:	d118                	sw	a4,32(a0)
ffffffffc0203b54:	0141                	addi	sp,sp,16
ffffffffc0203b56:	8082                	ret
ffffffffc0203b58:	fca691e3          	bne	a3,a0,ffffffffc0203b1a <insert_vma_struct+0x26>
ffffffffc0203b5c:	bfd9                	j	ffffffffc0203b32 <insert_vma_struct+0x3e>
ffffffffc0203b5e:	ef5ff0ef          	jal	ffffffffc0203a52 <check_vma_overlap.part.0>
ffffffffc0203b62:	00009697          	auipc	a3,0x9
ffffffffc0203b66:	0ce68693          	addi	a3,a3,206 # ffffffffc020cc30 <etext+0x1636>
ffffffffc0203b6a:	00008617          	auipc	a2,0x8
ffffffffc0203b6e:	ece60613          	addi	a2,a2,-306 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203b72:	07a00593          	li	a1,122
ffffffffc0203b76:	00009517          	auipc	a0,0x9
ffffffffc0203b7a:	0aa50513          	addi	a0,a0,170 # ffffffffc020cc20 <etext+0x1626>
ffffffffc0203b7e:	8cdfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203b82:	00009697          	auipc	a3,0x9
ffffffffc0203b86:	0ee68693          	addi	a3,a3,238 # ffffffffc020cc70 <etext+0x1676>
ffffffffc0203b8a:	00008617          	auipc	a2,0x8
ffffffffc0203b8e:	eae60613          	addi	a2,a2,-338 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203b92:	07300593          	li	a1,115
ffffffffc0203b96:	00009517          	auipc	a0,0x9
ffffffffc0203b9a:	08a50513          	addi	a0,a0,138 # ffffffffc020cc20 <etext+0x1626>
ffffffffc0203b9e:	8adfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203ba2:	00009697          	auipc	a3,0x9
ffffffffc0203ba6:	0ae68693          	addi	a3,a3,174 # ffffffffc020cc50 <etext+0x1656>
ffffffffc0203baa:	00008617          	auipc	a2,0x8
ffffffffc0203bae:	e8e60613          	addi	a2,a2,-370 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203bb2:	07200593          	li	a1,114
ffffffffc0203bb6:	00009517          	auipc	a0,0x9
ffffffffc0203bba:	06a50513          	addi	a0,a0,106 # ffffffffc020cc20 <etext+0x1626>
ffffffffc0203bbe:	88dfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203bc2 <mm_destroy>:
ffffffffc0203bc2:	591c                	lw	a5,48(a0)
ffffffffc0203bc4:	1141                	addi	sp,sp,-16
ffffffffc0203bc6:	e406                	sd	ra,8(sp)
ffffffffc0203bc8:	e022                	sd	s0,0(sp)
ffffffffc0203bca:	e78d                	bnez	a5,ffffffffc0203bf4 <mm_destroy+0x32>
ffffffffc0203bcc:	842a                	mv	s0,a0
ffffffffc0203bce:	6508                	ld	a0,8(a0)
ffffffffc0203bd0:	00a40c63          	beq	s0,a0,ffffffffc0203be8 <mm_destroy+0x26>
ffffffffc0203bd4:	6118                	ld	a4,0(a0)
ffffffffc0203bd6:	651c                	ld	a5,8(a0)
ffffffffc0203bd8:	1501                	addi	a0,a0,-32
ffffffffc0203bda:	e71c                	sd	a5,8(a4)
ffffffffc0203bdc:	e398                	sd	a4,0(a5)
ffffffffc0203bde:	d18fe0ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc0203be2:	6408                	ld	a0,8(s0)
ffffffffc0203be4:	fea418e3          	bne	s0,a0,ffffffffc0203bd4 <mm_destroy+0x12>
ffffffffc0203be8:	8522                	mv	a0,s0
ffffffffc0203bea:	6402                	ld	s0,0(sp)
ffffffffc0203bec:	60a2                	ld	ra,8(sp)
ffffffffc0203bee:	0141                	addi	sp,sp,16
ffffffffc0203bf0:	d06fe06f          	j	ffffffffc02020f6 <kfree>
ffffffffc0203bf4:	00009697          	auipc	a3,0x9
ffffffffc0203bf8:	09c68693          	addi	a3,a3,156 # ffffffffc020cc90 <etext+0x1696>
ffffffffc0203bfc:	00008617          	auipc	a2,0x8
ffffffffc0203c00:	e3c60613          	addi	a2,a2,-452 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203c04:	09e00593          	li	a1,158
ffffffffc0203c08:	00009517          	auipc	a0,0x9
ffffffffc0203c0c:	01850513          	addi	a0,a0,24 # ffffffffc020cc20 <etext+0x1626>
ffffffffc0203c10:	83bfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203c14 <mm_map>:
ffffffffc0203c14:	6785                	lui	a5,0x1
ffffffffc0203c16:	17fd                	addi	a5,a5,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0203c18:	963e                	add	a2,a2,a5
ffffffffc0203c1a:	4785                	li	a5,1
ffffffffc0203c1c:	7139                	addi	sp,sp,-64
ffffffffc0203c1e:	962e                	add	a2,a2,a1
ffffffffc0203c20:	787d                	lui	a6,0xfffff
ffffffffc0203c22:	07fe                	slli	a5,a5,0x1f
ffffffffc0203c24:	f822                	sd	s0,48(sp)
ffffffffc0203c26:	f426                	sd	s1,40(sp)
ffffffffc0203c28:	01067433          	and	s0,a2,a6
ffffffffc0203c2c:	0105f4b3          	and	s1,a1,a6
ffffffffc0203c30:	0785                	addi	a5,a5,1
ffffffffc0203c32:	0084b633          	sltu	a2,s1,s0
ffffffffc0203c36:	00f437b3          	sltu	a5,s0,a5
ffffffffc0203c3a:	00163613          	seqz	a2,a2
ffffffffc0203c3e:	0017b793          	seqz	a5,a5
ffffffffc0203c42:	fc06                	sd	ra,56(sp)
ffffffffc0203c44:	8fd1                	or	a5,a5,a2
ffffffffc0203c46:	ebbd                	bnez	a5,ffffffffc0203cbc <mm_map+0xa8>
ffffffffc0203c48:	002007b7          	lui	a5,0x200
ffffffffc0203c4c:	06f4e863          	bltu	s1,a5,ffffffffc0203cbc <mm_map+0xa8>
ffffffffc0203c50:	f04a                	sd	s2,32(sp)
ffffffffc0203c52:	ec4e                	sd	s3,24(sp)
ffffffffc0203c54:	e852                	sd	s4,16(sp)
ffffffffc0203c56:	892a                	mv	s2,a0
ffffffffc0203c58:	89ba                	mv	s3,a4
ffffffffc0203c5a:	8a36                	mv	s4,a3
ffffffffc0203c5c:	c135                	beqz	a0,ffffffffc0203cc0 <mm_map+0xac>
ffffffffc0203c5e:	85a6                	mv	a1,s1
ffffffffc0203c60:	e55ff0ef          	jal	ffffffffc0203ab4 <find_vma>
ffffffffc0203c64:	c501                	beqz	a0,ffffffffc0203c6c <mm_map+0x58>
ffffffffc0203c66:	651c                	ld	a5,8(a0)
ffffffffc0203c68:	0487e763          	bltu	a5,s0,ffffffffc0203cb6 <mm_map+0xa2>
ffffffffc0203c6c:	03000513          	li	a0,48
ffffffffc0203c70:	be0fe0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc0203c74:	85aa                	mv	a1,a0
ffffffffc0203c76:	5571                	li	a0,-4
ffffffffc0203c78:	c59d                	beqz	a1,ffffffffc0203ca6 <mm_map+0x92>
ffffffffc0203c7a:	e584                	sd	s1,8(a1)
ffffffffc0203c7c:	e980                	sd	s0,16(a1)
ffffffffc0203c7e:	0145ac23          	sw	s4,24(a1)
ffffffffc0203c82:	854a                	mv	a0,s2
ffffffffc0203c84:	e42e                	sd	a1,8(sp)
ffffffffc0203c86:	e6fff0ef          	jal	ffffffffc0203af4 <insert_vma_struct>
ffffffffc0203c8a:	65a2                	ld	a1,8(sp)
ffffffffc0203c8c:	00098463          	beqz	s3,ffffffffc0203c94 <mm_map+0x80>
ffffffffc0203c90:	00b9b023          	sd	a1,0(s3)
ffffffffc0203c94:	7902                	ld	s2,32(sp)
ffffffffc0203c96:	69e2                	ld	s3,24(sp)
ffffffffc0203c98:	6a42                	ld	s4,16(sp)
ffffffffc0203c9a:	4501                	li	a0,0
ffffffffc0203c9c:	70e2                	ld	ra,56(sp)
ffffffffc0203c9e:	7442                	ld	s0,48(sp)
ffffffffc0203ca0:	74a2                	ld	s1,40(sp)
ffffffffc0203ca2:	6121                	addi	sp,sp,64
ffffffffc0203ca4:	8082                	ret
ffffffffc0203ca6:	70e2                	ld	ra,56(sp)
ffffffffc0203ca8:	7442                	ld	s0,48(sp)
ffffffffc0203caa:	7902                	ld	s2,32(sp)
ffffffffc0203cac:	69e2                	ld	s3,24(sp)
ffffffffc0203cae:	6a42                	ld	s4,16(sp)
ffffffffc0203cb0:	74a2                	ld	s1,40(sp)
ffffffffc0203cb2:	6121                	addi	sp,sp,64
ffffffffc0203cb4:	8082                	ret
ffffffffc0203cb6:	7902                	ld	s2,32(sp)
ffffffffc0203cb8:	69e2                	ld	s3,24(sp)
ffffffffc0203cba:	6a42                	ld	s4,16(sp)
ffffffffc0203cbc:	5575                	li	a0,-3
ffffffffc0203cbe:	bff9                	j	ffffffffc0203c9c <mm_map+0x88>
ffffffffc0203cc0:	00009697          	auipc	a3,0x9
ffffffffc0203cc4:	fe868693          	addi	a3,a3,-24 # ffffffffc020cca8 <etext+0x16ae>
ffffffffc0203cc8:	00008617          	auipc	a2,0x8
ffffffffc0203ccc:	d7060613          	addi	a2,a2,-656 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203cd0:	0b300593          	li	a1,179
ffffffffc0203cd4:	00009517          	auipc	a0,0x9
ffffffffc0203cd8:	f4c50513          	addi	a0,a0,-180 # ffffffffc020cc20 <etext+0x1626>
ffffffffc0203cdc:	f6efc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203ce0 <dup_mmap>:
ffffffffc0203ce0:	7139                	addi	sp,sp,-64
ffffffffc0203ce2:	fc06                	sd	ra,56(sp)
ffffffffc0203ce4:	f822                	sd	s0,48(sp)
ffffffffc0203ce6:	f426                	sd	s1,40(sp)
ffffffffc0203ce8:	f04a                	sd	s2,32(sp)
ffffffffc0203cea:	ec4e                	sd	s3,24(sp)
ffffffffc0203cec:	e852                	sd	s4,16(sp)
ffffffffc0203cee:	e456                	sd	s5,8(sp)
ffffffffc0203cf0:	c525                	beqz	a0,ffffffffc0203d58 <dup_mmap+0x78>
ffffffffc0203cf2:	892a                	mv	s2,a0
ffffffffc0203cf4:	84ae                	mv	s1,a1
ffffffffc0203cf6:	842e                	mv	s0,a1
ffffffffc0203cf8:	c1a5                	beqz	a1,ffffffffc0203d58 <dup_mmap+0x78>
ffffffffc0203cfa:	6000                	ld	s0,0(s0)
ffffffffc0203cfc:	04848c63          	beq	s1,s0,ffffffffc0203d54 <dup_mmap+0x74>
ffffffffc0203d00:	03000513          	li	a0,48
ffffffffc0203d04:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203d08:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203d0c:	ff842983          	lw	s3,-8(s0)
ffffffffc0203d10:	b40fe0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc0203d14:	c515                	beqz	a0,ffffffffc0203d40 <dup_mmap+0x60>
ffffffffc0203d16:	85aa                	mv	a1,a0
ffffffffc0203d18:	01553423          	sd	s5,8(a0)
ffffffffc0203d1c:	01453823          	sd	s4,16(a0)
ffffffffc0203d20:	01352c23          	sw	s3,24(a0)
ffffffffc0203d24:	854a                	mv	a0,s2
ffffffffc0203d26:	dcfff0ef          	jal	ffffffffc0203af4 <insert_vma_struct>
ffffffffc0203d2a:	ff043683          	ld	a3,-16(s0)
ffffffffc0203d2e:	fe843603          	ld	a2,-24(s0)
ffffffffc0203d32:	6c8c                	ld	a1,24(s1)
ffffffffc0203d34:	01893503          	ld	a0,24(s2)
ffffffffc0203d38:	4701                	li	a4,0
ffffffffc0203d3a:	9f9ff0ef          	jal	ffffffffc0203732 <copy_range>
ffffffffc0203d3e:	dd55                	beqz	a0,ffffffffc0203cfa <dup_mmap+0x1a>
ffffffffc0203d40:	5571                	li	a0,-4
ffffffffc0203d42:	70e2                	ld	ra,56(sp)
ffffffffc0203d44:	7442                	ld	s0,48(sp)
ffffffffc0203d46:	74a2                	ld	s1,40(sp)
ffffffffc0203d48:	7902                	ld	s2,32(sp)
ffffffffc0203d4a:	69e2                	ld	s3,24(sp)
ffffffffc0203d4c:	6a42                	ld	s4,16(sp)
ffffffffc0203d4e:	6aa2                	ld	s5,8(sp)
ffffffffc0203d50:	6121                	addi	sp,sp,64
ffffffffc0203d52:	8082                	ret
ffffffffc0203d54:	4501                	li	a0,0
ffffffffc0203d56:	b7f5                	j	ffffffffc0203d42 <dup_mmap+0x62>
ffffffffc0203d58:	00009697          	auipc	a3,0x9
ffffffffc0203d5c:	f6068693          	addi	a3,a3,-160 # ffffffffc020ccb8 <etext+0x16be>
ffffffffc0203d60:	00008617          	auipc	a2,0x8
ffffffffc0203d64:	cd860613          	addi	a2,a2,-808 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203d68:	0cf00593          	li	a1,207
ffffffffc0203d6c:	00009517          	auipc	a0,0x9
ffffffffc0203d70:	eb450513          	addi	a0,a0,-332 # ffffffffc020cc20 <etext+0x1626>
ffffffffc0203d74:	ed6fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203d78 <exit_mmap>:
ffffffffc0203d78:	1101                	addi	sp,sp,-32
ffffffffc0203d7a:	ec06                	sd	ra,24(sp)
ffffffffc0203d7c:	e822                	sd	s0,16(sp)
ffffffffc0203d7e:	e426                	sd	s1,8(sp)
ffffffffc0203d80:	e04a                	sd	s2,0(sp)
ffffffffc0203d82:	c531                	beqz	a0,ffffffffc0203dce <exit_mmap+0x56>
ffffffffc0203d84:	591c                	lw	a5,48(a0)
ffffffffc0203d86:	84aa                	mv	s1,a0
ffffffffc0203d88:	e3b9                	bnez	a5,ffffffffc0203dce <exit_mmap+0x56>
ffffffffc0203d8a:	6500                	ld	s0,8(a0)
ffffffffc0203d8c:	01853903          	ld	s2,24(a0)
ffffffffc0203d90:	02850663          	beq	a0,s0,ffffffffc0203dbc <exit_mmap+0x44>
ffffffffc0203d94:	ff043603          	ld	a2,-16(s0)
ffffffffc0203d98:	fe843583          	ld	a1,-24(s0)
ffffffffc0203d9c:	854a                	mv	a0,s2
ffffffffc0203d9e:	fd0fe0ef          	jal	ffffffffc020256e <unmap_range>
ffffffffc0203da2:	6400                	ld	s0,8(s0)
ffffffffc0203da4:	fe8498e3          	bne	s1,s0,ffffffffc0203d94 <exit_mmap+0x1c>
ffffffffc0203da8:	6400                	ld	s0,8(s0)
ffffffffc0203daa:	00848c63          	beq	s1,s0,ffffffffc0203dc2 <exit_mmap+0x4a>
ffffffffc0203dae:	ff043603          	ld	a2,-16(s0)
ffffffffc0203db2:	fe843583          	ld	a1,-24(s0)
ffffffffc0203db6:	854a                	mv	a0,s2
ffffffffc0203db8:	8ebfe0ef          	jal	ffffffffc02026a2 <exit_range>
ffffffffc0203dbc:	6400                	ld	s0,8(s0)
ffffffffc0203dbe:	fe8498e3          	bne	s1,s0,ffffffffc0203dae <exit_mmap+0x36>
ffffffffc0203dc2:	60e2                	ld	ra,24(sp)
ffffffffc0203dc4:	6442                	ld	s0,16(sp)
ffffffffc0203dc6:	64a2                	ld	s1,8(sp)
ffffffffc0203dc8:	6902                	ld	s2,0(sp)
ffffffffc0203dca:	6105                	addi	sp,sp,32
ffffffffc0203dcc:	8082                	ret
ffffffffc0203dce:	00009697          	auipc	a3,0x9
ffffffffc0203dd2:	f0a68693          	addi	a3,a3,-246 # ffffffffc020ccd8 <etext+0x16de>
ffffffffc0203dd6:	00008617          	auipc	a2,0x8
ffffffffc0203dda:	c6260613          	addi	a2,a2,-926 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203dde:	0e800593          	li	a1,232
ffffffffc0203de2:	00009517          	auipc	a0,0x9
ffffffffc0203de6:	e3e50513          	addi	a0,a0,-450 # ffffffffc020cc20 <etext+0x1626>
ffffffffc0203dea:	e60fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203dee <vmm_init>:
ffffffffc0203dee:	7179                	addi	sp,sp,-48
ffffffffc0203df0:	05800513          	li	a0,88
ffffffffc0203df4:	f406                	sd	ra,40(sp)
ffffffffc0203df6:	f022                	sd	s0,32(sp)
ffffffffc0203df8:	ec26                	sd	s1,24(sp)
ffffffffc0203dfa:	e84a                	sd	s2,16(sp)
ffffffffc0203dfc:	e44e                	sd	s3,8(sp)
ffffffffc0203dfe:	e052                	sd	s4,0(sp)
ffffffffc0203e00:	a50fe0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc0203e04:	16050f63          	beqz	a0,ffffffffc0203f82 <vmm_init+0x194>
ffffffffc0203e08:	e508                	sd	a0,8(a0)
ffffffffc0203e0a:	e108                	sd	a0,0(a0)
ffffffffc0203e0c:	00053823          	sd	zero,16(a0)
ffffffffc0203e10:	00053c23          	sd	zero,24(a0)
ffffffffc0203e14:	02052023          	sw	zero,32(a0)
ffffffffc0203e18:	02053423          	sd	zero,40(a0)
ffffffffc0203e1c:	02052823          	sw	zero,48(a0)
ffffffffc0203e20:	842a                	mv	s0,a0
ffffffffc0203e22:	4585                	li	a1,1
ffffffffc0203e24:	03850513          	addi	a0,a0,56
ffffffffc0203e28:	5e6000ef          	jal	ffffffffc020440e <sem_init>
ffffffffc0203e2c:	03200493          	li	s1,50
ffffffffc0203e30:	03000513          	li	a0,48
ffffffffc0203e34:	a1cfe0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc0203e38:	12050563          	beqz	a0,ffffffffc0203f62 <vmm_init+0x174>
ffffffffc0203e3c:	00248793          	addi	a5,s1,2
ffffffffc0203e40:	e504                	sd	s1,8(a0)
ffffffffc0203e42:	00052c23          	sw	zero,24(a0)
ffffffffc0203e46:	e91c                	sd	a5,16(a0)
ffffffffc0203e48:	85aa                	mv	a1,a0
ffffffffc0203e4a:	14ed                	addi	s1,s1,-5
ffffffffc0203e4c:	8522                	mv	a0,s0
ffffffffc0203e4e:	ca7ff0ef          	jal	ffffffffc0203af4 <insert_vma_struct>
ffffffffc0203e52:	fcf9                	bnez	s1,ffffffffc0203e30 <vmm_init+0x42>
ffffffffc0203e54:	03700493          	li	s1,55
ffffffffc0203e58:	1f900913          	li	s2,505
ffffffffc0203e5c:	03000513          	li	a0,48
ffffffffc0203e60:	9f0fe0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc0203e64:	12050f63          	beqz	a0,ffffffffc0203fa2 <vmm_init+0x1b4>
ffffffffc0203e68:	00248793          	addi	a5,s1,2
ffffffffc0203e6c:	e504                	sd	s1,8(a0)
ffffffffc0203e6e:	00052c23          	sw	zero,24(a0)
ffffffffc0203e72:	e91c                	sd	a5,16(a0)
ffffffffc0203e74:	85aa                	mv	a1,a0
ffffffffc0203e76:	0495                	addi	s1,s1,5
ffffffffc0203e78:	8522                	mv	a0,s0
ffffffffc0203e7a:	c7bff0ef          	jal	ffffffffc0203af4 <insert_vma_struct>
ffffffffc0203e7e:	fd249fe3          	bne	s1,s2,ffffffffc0203e5c <vmm_init+0x6e>
ffffffffc0203e82:	641c                	ld	a5,8(s0)
ffffffffc0203e84:	471d                	li	a4,7
ffffffffc0203e86:	1fb00593          	li	a1,507
ffffffffc0203e8a:	1ef40c63          	beq	s0,a5,ffffffffc0204082 <vmm_init+0x294>
ffffffffc0203e8e:	fe87b603          	ld	a2,-24(a5) # 1fffe8 <_binary_bin_sfs_img_size+0x18ace8>
ffffffffc0203e92:	ffe70693          	addi	a3,a4,-2
ffffffffc0203e96:	12d61663          	bne	a2,a3,ffffffffc0203fc2 <vmm_init+0x1d4>
ffffffffc0203e9a:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203e9e:	12e69263          	bne	a3,a4,ffffffffc0203fc2 <vmm_init+0x1d4>
ffffffffc0203ea2:	0715                	addi	a4,a4,5
ffffffffc0203ea4:	679c                	ld	a5,8(a5)
ffffffffc0203ea6:	feb712e3          	bne	a4,a1,ffffffffc0203e8a <vmm_init+0x9c>
ffffffffc0203eaa:	491d                	li	s2,7
ffffffffc0203eac:	4495                	li	s1,5
ffffffffc0203eae:	85a6                	mv	a1,s1
ffffffffc0203eb0:	8522                	mv	a0,s0
ffffffffc0203eb2:	c03ff0ef          	jal	ffffffffc0203ab4 <find_vma>
ffffffffc0203eb6:	8a2a                	mv	s4,a0
ffffffffc0203eb8:	20050563          	beqz	a0,ffffffffc02040c2 <vmm_init+0x2d4>
ffffffffc0203ebc:	00148593          	addi	a1,s1,1
ffffffffc0203ec0:	8522                	mv	a0,s0
ffffffffc0203ec2:	bf3ff0ef          	jal	ffffffffc0203ab4 <find_vma>
ffffffffc0203ec6:	89aa                	mv	s3,a0
ffffffffc0203ec8:	1c050d63          	beqz	a0,ffffffffc02040a2 <vmm_init+0x2b4>
ffffffffc0203ecc:	85ca                	mv	a1,s2
ffffffffc0203ece:	8522                	mv	a0,s0
ffffffffc0203ed0:	be5ff0ef          	jal	ffffffffc0203ab4 <find_vma>
ffffffffc0203ed4:	18051763          	bnez	a0,ffffffffc0204062 <vmm_init+0x274>
ffffffffc0203ed8:	00348593          	addi	a1,s1,3
ffffffffc0203edc:	8522                	mv	a0,s0
ffffffffc0203ede:	bd7ff0ef          	jal	ffffffffc0203ab4 <find_vma>
ffffffffc0203ee2:	16051063          	bnez	a0,ffffffffc0204042 <vmm_init+0x254>
ffffffffc0203ee6:	00448593          	addi	a1,s1,4
ffffffffc0203eea:	8522                	mv	a0,s0
ffffffffc0203eec:	bc9ff0ef          	jal	ffffffffc0203ab4 <find_vma>
ffffffffc0203ef0:	12051963          	bnez	a0,ffffffffc0204022 <vmm_init+0x234>
ffffffffc0203ef4:	008a3783          	ld	a5,8(s4)
ffffffffc0203ef8:	10979563          	bne	a5,s1,ffffffffc0204002 <vmm_init+0x214>
ffffffffc0203efc:	010a3783          	ld	a5,16(s4)
ffffffffc0203f00:	11279163          	bne	a5,s2,ffffffffc0204002 <vmm_init+0x214>
ffffffffc0203f04:	0089b783          	ld	a5,8(s3)
ffffffffc0203f08:	0c979d63          	bne	a5,s1,ffffffffc0203fe2 <vmm_init+0x1f4>
ffffffffc0203f0c:	0109b783          	ld	a5,16(s3)
ffffffffc0203f10:	0d279963          	bne	a5,s2,ffffffffc0203fe2 <vmm_init+0x1f4>
ffffffffc0203f14:	0495                	addi	s1,s1,5
ffffffffc0203f16:	1f900793          	li	a5,505
ffffffffc0203f1a:	0915                	addi	s2,s2,5
ffffffffc0203f1c:	f8f499e3          	bne	s1,a5,ffffffffc0203eae <vmm_init+0xc0>
ffffffffc0203f20:	4491                	li	s1,4
ffffffffc0203f22:	597d                	li	s2,-1
ffffffffc0203f24:	85a6                	mv	a1,s1
ffffffffc0203f26:	8522                	mv	a0,s0
ffffffffc0203f28:	b8dff0ef          	jal	ffffffffc0203ab4 <find_vma>
ffffffffc0203f2c:	1a051b63          	bnez	a0,ffffffffc02040e2 <vmm_init+0x2f4>
ffffffffc0203f30:	14fd                	addi	s1,s1,-1
ffffffffc0203f32:	ff2499e3          	bne	s1,s2,ffffffffc0203f24 <vmm_init+0x136>
ffffffffc0203f36:	8522                	mv	a0,s0
ffffffffc0203f38:	c8bff0ef          	jal	ffffffffc0203bc2 <mm_destroy>
ffffffffc0203f3c:	00009517          	auipc	a0,0x9
ffffffffc0203f40:	f0c50513          	addi	a0,a0,-244 # ffffffffc020ce48 <etext+0x184e>
ffffffffc0203f44:	a62fc0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0203f48:	7402                	ld	s0,32(sp)
ffffffffc0203f4a:	70a2                	ld	ra,40(sp)
ffffffffc0203f4c:	64e2                	ld	s1,24(sp)
ffffffffc0203f4e:	6942                	ld	s2,16(sp)
ffffffffc0203f50:	69a2                	ld	s3,8(sp)
ffffffffc0203f52:	6a02                	ld	s4,0(sp)
ffffffffc0203f54:	00009517          	auipc	a0,0x9
ffffffffc0203f58:	f1450513          	addi	a0,a0,-236 # ffffffffc020ce68 <etext+0x186e>
ffffffffc0203f5c:	6145                	addi	sp,sp,48
ffffffffc0203f5e:	a48fc06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0203f62:	00009697          	auipc	a3,0x9
ffffffffc0203f66:	d9668693          	addi	a3,a3,-618 # ffffffffc020ccf8 <etext+0x16fe>
ffffffffc0203f6a:	00008617          	auipc	a2,0x8
ffffffffc0203f6e:	ace60613          	addi	a2,a2,-1330 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203f72:	12c00593          	li	a1,300
ffffffffc0203f76:	00009517          	auipc	a0,0x9
ffffffffc0203f7a:	caa50513          	addi	a0,a0,-854 # ffffffffc020cc20 <etext+0x1626>
ffffffffc0203f7e:	cccfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203f82:	00009697          	auipc	a3,0x9
ffffffffc0203f86:	d2668693          	addi	a3,a3,-730 # ffffffffc020cca8 <etext+0x16ae>
ffffffffc0203f8a:	00008617          	auipc	a2,0x8
ffffffffc0203f8e:	aae60613          	addi	a2,a2,-1362 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203f92:	12400593          	li	a1,292
ffffffffc0203f96:	00009517          	auipc	a0,0x9
ffffffffc0203f9a:	c8a50513          	addi	a0,a0,-886 # ffffffffc020cc20 <etext+0x1626>
ffffffffc0203f9e:	cacfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203fa2:	00009697          	auipc	a3,0x9
ffffffffc0203fa6:	d5668693          	addi	a3,a3,-682 # ffffffffc020ccf8 <etext+0x16fe>
ffffffffc0203faa:	00008617          	auipc	a2,0x8
ffffffffc0203fae:	a8e60613          	addi	a2,a2,-1394 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203fb2:	13300593          	li	a1,307
ffffffffc0203fb6:	00009517          	auipc	a0,0x9
ffffffffc0203fba:	c6a50513          	addi	a0,a0,-918 # ffffffffc020cc20 <etext+0x1626>
ffffffffc0203fbe:	c8cfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203fc2:	00009697          	auipc	a3,0x9
ffffffffc0203fc6:	d5e68693          	addi	a3,a3,-674 # ffffffffc020cd20 <etext+0x1726>
ffffffffc0203fca:	00008617          	auipc	a2,0x8
ffffffffc0203fce:	a6e60613          	addi	a2,a2,-1426 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203fd2:	13d00593          	li	a1,317
ffffffffc0203fd6:	00009517          	auipc	a0,0x9
ffffffffc0203fda:	c4a50513          	addi	a0,a0,-950 # ffffffffc020cc20 <etext+0x1626>
ffffffffc0203fde:	c6cfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203fe2:	00009697          	auipc	a3,0x9
ffffffffc0203fe6:	df668693          	addi	a3,a3,-522 # ffffffffc020cdd8 <etext+0x17de>
ffffffffc0203fea:	00008617          	auipc	a2,0x8
ffffffffc0203fee:	a4e60613          	addi	a2,a2,-1458 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0203ff2:	14f00593          	li	a1,335
ffffffffc0203ff6:	00009517          	auipc	a0,0x9
ffffffffc0203ffa:	c2a50513          	addi	a0,a0,-982 # ffffffffc020cc20 <etext+0x1626>
ffffffffc0203ffe:	c4cfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204002:	00009697          	auipc	a3,0x9
ffffffffc0204006:	da668693          	addi	a3,a3,-602 # ffffffffc020cda8 <etext+0x17ae>
ffffffffc020400a:	00008617          	auipc	a2,0x8
ffffffffc020400e:	a2e60613          	addi	a2,a2,-1490 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204012:	14e00593          	li	a1,334
ffffffffc0204016:	00009517          	auipc	a0,0x9
ffffffffc020401a:	c0a50513          	addi	a0,a0,-1014 # ffffffffc020cc20 <etext+0x1626>
ffffffffc020401e:	c2cfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204022:	00009697          	auipc	a3,0x9
ffffffffc0204026:	d7668693          	addi	a3,a3,-650 # ffffffffc020cd98 <etext+0x179e>
ffffffffc020402a:	00008617          	auipc	a2,0x8
ffffffffc020402e:	a0e60613          	addi	a2,a2,-1522 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204032:	14c00593          	li	a1,332
ffffffffc0204036:	00009517          	auipc	a0,0x9
ffffffffc020403a:	bea50513          	addi	a0,a0,-1046 # ffffffffc020cc20 <etext+0x1626>
ffffffffc020403e:	c0cfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204042:	00009697          	auipc	a3,0x9
ffffffffc0204046:	d4668693          	addi	a3,a3,-698 # ffffffffc020cd88 <etext+0x178e>
ffffffffc020404a:	00008617          	auipc	a2,0x8
ffffffffc020404e:	9ee60613          	addi	a2,a2,-1554 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204052:	14a00593          	li	a1,330
ffffffffc0204056:	00009517          	auipc	a0,0x9
ffffffffc020405a:	bca50513          	addi	a0,a0,-1078 # ffffffffc020cc20 <etext+0x1626>
ffffffffc020405e:	becfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204062:	00009697          	auipc	a3,0x9
ffffffffc0204066:	d1668693          	addi	a3,a3,-746 # ffffffffc020cd78 <etext+0x177e>
ffffffffc020406a:	00008617          	auipc	a2,0x8
ffffffffc020406e:	9ce60613          	addi	a2,a2,-1586 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204072:	14800593          	li	a1,328
ffffffffc0204076:	00009517          	auipc	a0,0x9
ffffffffc020407a:	baa50513          	addi	a0,a0,-1110 # ffffffffc020cc20 <etext+0x1626>
ffffffffc020407e:	bccfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204082:	00009697          	auipc	a3,0x9
ffffffffc0204086:	c8668693          	addi	a3,a3,-890 # ffffffffc020cd08 <etext+0x170e>
ffffffffc020408a:	00008617          	auipc	a2,0x8
ffffffffc020408e:	9ae60613          	addi	a2,a2,-1618 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204092:	13b00593          	li	a1,315
ffffffffc0204096:	00009517          	auipc	a0,0x9
ffffffffc020409a:	b8a50513          	addi	a0,a0,-1142 # ffffffffc020cc20 <etext+0x1626>
ffffffffc020409e:	bacfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02040a2:	00009697          	auipc	a3,0x9
ffffffffc02040a6:	cc668693          	addi	a3,a3,-826 # ffffffffc020cd68 <etext+0x176e>
ffffffffc02040aa:	00008617          	auipc	a2,0x8
ffffffffc02040ae:	98e60613          	addi	a2,a2,-1650 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02040b2:	14600593          	li	a1,326
ffffffffc02040b6:	00009517          	auipc	a0,0x9
ffffffffc02040ba:	b6a50513          	addi	a0,a0,-1174 # ffffffffc020cc20 <etext+0x1626>
ffffffffc02040be:	b8cfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02040c2:	00009697          	auipc	a3,0x9
ffffffffc02040c6:	c9668693          	addi	a3,a3,-874 # ffffffffc020cd58 <etext+0x175e>
ffffffffc02040ca:	00008617          	auipc	a2,0x8
ffffffffc02040ce:	96e60613          	addi	a2,a2,-1682 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02040d2:	14400593          	li	a1,324
ffffffffc02040d6:	00009517          	auipc	a0,0x9
ffffffffc02040da:	b4a50513          	addi	a0,a0,-1206 # ffffffffc020cc20 <etext+0x1626>
ffffffffc02040de:	b6cfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02040e2:	6914                	ld	a3,16(a0)
ffffffffc02040e4:	6510                	ld	a2,8(a0)
ffffffffc02040e6:	0004859b          	sext.w	a1,s1
ffffffffc02040ea:	00009517          	auipc	a0,0x9
ffffffffc02040ee:	d1e50513          	addi	a0,a0,-738 # ffffffffc020ce08 <etext+0x180e>
ffffffffc02040f2:	8b4fc0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02040f6:	00009697          	auipc	a3,0x9
ffffffffc02040fa:	d3a68693          	addi	a3,a3,-710 # ffffffffc020ce30 <etext+0x1836>
ffffffffc02040fe:	00008617          	auipc	a2,0x8
ffffffffc0204102:	93a60613          	addi	a2,a2,-1734 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204106:	15900593          	li	a1,345
ffffffffc020410a:	00009517          	auipc	a0,0x9
ffffffffc020410e:	b1650513          	addi	a0,a0,-1258 # ffffffffc020cc20 <etext+0x1626>
ffffffffc0204112:	b38fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204116 <user_mem_check>:
ffffffffc0204116:	7179                	addi	sp,sp,-48
ffffffffc0204118:	f022                	sd	s0,32(sp)
ffffffffc020411a:	f406                	sd	ra,40(sp)
ffffffffc020411c:	842e                	mv	s0,a1
ffffffffc020411e:	c52d                	beqz	a0,ffffffffc0204188 <user_mem_check+0x72>
ffffffffc0204120:	002007b7          	lui	a5,0x200
ffffffffc0204124:	04f5ed63          	bltu	a1,a5,ffffffffc020417e <user_mem_check+0x68>
ffffffffc0204128:	ec26                	sd	s1,24(sp)
ffffffffc020412a:	00c584b3          	add	s1,a1,a2
ffffffffc020412e:	0695ff63          	bgeu	a1,s1,ffffffffc02041ac <user_mem_check+0x96>
ffffffffc0204132:	4785                	li	a5,1
ffffffffc0204134:	07fe                	slli	a5,a5,0x1f
ffffffffc0204136:	0785                	addi	a5,a5,1 # 200001 <_binary_bin_sfs_img_size+0x18ad01>
ffffffffc0204138:	06f4fa63          	bgeu	s1,a5,ffffffffc02041ac <user_mem_check+0x96>
ffffffffc020413c:	e84a                	sd	s2,16(sp)
ffffffffc020413e:	e44e                	sd	s3,8(sp)
ffffffffc0204140:	8936                	mv	s2,a3
ffffffffc0204142:	89aa                	mv	s3,a0
ffffffffc0204144:	a829                	j	ffffffffc020415e <user_mem_check+0x48>
ffffffffc0204146:	6685                	lui	a3,0x1
ffffffffc0204148:	9736                	add	a4,a4,a3
ffffffffc020414a:	0027f693          	andi	a3,a5,2
ffffffffc020414e:	8ba1                	andi	a5,a5,8
ffffffffc0204150:	c685                	beqz	a3,ffffffffc0204178 <user_mem_check+0x62>
ffffffffc0204152:	c399                	beqz	a5,ffffffffc0204158 <user_mem_check+0x42>
ffffffffc0204154:	02e46263          	bltu	s0,a4,ffffffffc0204178 <user_mem_check+0x62>
ffffffffc0204158:	6900                	ld	s0,16(a0)
ffffffffc020415a:	04947b63          	bgeu	s0,s1,ffffffffc02041b0 <user_mem_check+0x9a>
ffffffffc020415e:	85a2                	mv	a1,s0
ffffffffc0204160:	854e                	mv	a0,s3
ffffffffc0204162:	953ff0ef          	jal	ffffffffc0203ab4 <find_vma>
ffffffffc0204166:	c909                	beqz	a0,ffffffffc0204178 <user_mem_check+0x62>
ffffffffc0204168:	6518                	ld	a4,8(a0)
ffffffffc020416a:	00e46763          	bltu	s0,a4,ffffffffc0204178 <user_mem_check+0x62>
ffffffffc020416e:	4d1c                	lw	a5,24(a0)
ffffffffc0204170:	fc091be3          	bnez	s2,ffffffffc0204146 <user_mem_check+0x30>
ffffffffc0204174:	8b85                	andi	a5,a5,1
ffffffffc0204176:	f3ed                	bnez	a5,ffffffffc0204158 <user_mem_check+0x42>
ffffffffc0204178:	64e2                	ld	s1,24(sp)
ffffffffc020417a:	6942                	ld	s2,16(sp)
ffffffffc020417c:	69a2                	ld	s3,8(sp)
ffffffffc020417e:	4501                	li	a0,0
ffffffffc0204180:	70a2                	ld	ra,40(sp)
ffffffffc0204182:	7402                	ld	s0,32(sp)
ffffffffc0204184:	6145                	addi	sp,sp,48
ffffffffc0204186:	8082                	ret
ffffffffc0204188:	c02007b7          	lui	a5,0xc0200
ffffffffc020418c:	fef5eae3          	bltu	a1,a5,ffffffffc0204180 <user_mem_check+0x6a>
ffffffffc0204190:	c80007b7          	lui	a5,0xc8000
ffffffffc0204194:	962e                	add	a2,a2,a1
ffffffffc0204196:	0785                	addi	a5,a5,1 # ffffffffc8000001 <end+0x7d696f1>
ffffffffc0204198:	00c5b433          	sltu	s0,a1,a2
ffffffffc020419c:	00f63633          	sltu	a2,a2,a5
ffffffffc02041a0:	70a2                	ld	ra,40(sp)
ffffffffc02041a2:	00867533          	and	a0,a2,s0
ffffffffc02041a6:	7402                	ld	s0,32(sp)
ffffffffc02041a8:	6145                	addi	sp,sp,48
ffffffffc02041aa:	8082                	ret
ffffffffc02041ac:	64e2                	ld	s1,24(sp)
ffffffffc02041ae:	bfc1                	j	ffffffffc020417e <user_mem_check+0x68>
ffffffffc02041b0:	64e2                	ld	s1,24(sp)
ffffffffc02041b2:	6942                	ld	s2,16(sp)
ffffffffc02041b4:	69a2                	ld	s3,8(sp)
ffffffffc02041b6:	4505                	li	a0,1
ffffffffc02041b8:	b7e1                	j	ffffffffc0204180 <user_mem_check+0x6a>

ffffffffc02041ba <copy_from_user>:
ffffffffc02041ba:	7179                	addi	sp,sp,-48
ffffffffc02041bc:	f022                	sd	s0,32(sp)
ffffffffc02041be:	8432                	mv	s0,a2
ffffffffc02041c0:	ec26                	sd	s1,24(sp)
ffffffffc02041c2:	8636                	mv	a2,a3
ffffffffc02041c4:	84ae                	mv	s1,a1
ffffffffc02041c6:	86ba                	mv	a3,a4
ffffffffc02041c8:	85a2                	mv	a1,s0
ffffffffc02041ca:	f406                	sd	ra,40(sp)
ffffffffc02041cc:	e032                	sd	a2,0(sp)
ffffffffc02041ce:	f49ff0ef          	jal	ffffffffc0204116 <user_mem_check>
ffffffffc02041d2:	87aa                	mv	a5,a0
ffffffffc02041d4:	c901                	beqz	a0,ffffffffc02041e4 <copy_from_user+0x2a>
ffffffffc02041d6:	6602                	ld	a2,0(sp)
ffffffffc02041d8:	e42a                	sd	a0,8(sp)
ffffffffc02041da:	85a2                	mv	a1,s0
ffffffffc02041dc:	8526                	mv	a0,s1
ffffffffc02041de:	404070ef          	jal	ffffffffc020b5e2 <memcpy>
ffffffffc02041e2:	67a2                	ld	a5,8(sp)
ffffffffc02041e4:	70a2                	ld	ra,40(sp)
ffffffffc02041e6:	7402                	ld	s0,32(sp)
ffffffffc02041e8:	64e2                	ld	s1,24(sp)
ffffffffc02041ea:	853e                	mv	a0,a5
ffffffffc02041ec:	6145                	addi	sp,sp,48
ffffffffc02041ee:	8082                	ret

ffffffffc02041f0 <copy_to_user>:
ffffffffc02041f0:	7179                	addi	sp,sp,-48
ffffffffc02041f2:	f022                	sd	s0,32(sp)
ffffffffc02041f4:	8436                	mv	s0,a3
ffffffffc02041f6:	e84a                	sd	s2,16(sp)
ffffffffc02041f8:	4685                	li	a3,1
ffffffffc02041fa:	8932                	mv	s2,a2
ffffffffc02041fc:	8622                	mv	a2,s0
ffffffffc02041fe:	ec26                	sd	s1,24(sp)
ffffffffc0204200:	f406                	sd	ra,40(sp)
ffffffffc0204202:	84ae                	mv	s1,a1
ffffffffc0204204:	f13ff0ef          	jal	ffffffffc0204116 <user_mem_check>
ffffffffc0204208:	87aa                	mv	a5,a0
ffffffffc020420a:	c901                	beqz	a0,ffffffffc020421a <copy_to_user+0x2a>
ffffffffc020420c:	e42a                	sd	a0,8(sp)
ffffffffc020420e:	8622                	mv	a2,s0
ffffffffc0204210:	85ca                	mv	a1,s2
ffffffffc0204212:	8526                	mv	a0,s1
ffffffffc0204214:	3ce070ef          	jal	ffffffffc020b5e2 <memcpy>
ffffffffc0204218:	67a2                	ld	a5,8(sp)
ffffffffc020421a:	70a2                	ld	ra,40(sp)
ffffffffc020421c:	7402                	ld	s0,32(sp)
ffffffffc020421e:	64e2                	ld	s1,24(sp)
ffffffffc0204220:	6942                	ld	s2,16(sp)
ffffffffc0204222:	853e                	mv	a0,a5
ffffffffc0204224:	6145                	addi	sp,sp,48
ffffffffc0204226:	8082                	ret

ffffffffc0204228 <copy_string>:
ffffffffc0204228:	6785                	lui	a5,0x1
ffffffffc020422a:	97b2                	add	a5,a5,a2
ffffffffc020422c:	777d                	lui	a4,0xfffff
ffffffffc020422e:	7139                	addi	sp,sp,-64
ffffffffc0204230:	8ff9                	and	a5,a5,a4
ffffffffc0204232:	f822                	sd	s0,48(sp)
ffffffffc0204234:	f426                	sd	s1,40(sp)
ffffffffc0204236:	ec4e                	sd	s3,24(sp)
ffffffffc0204238:	e456                	sd	s5,8(sp)
ffffffffc020423a:	e05a                	sd	s6,0(sp)
ffffffffc020423c:	fc06                	sd	ra,56(sp)
ffffffffc020423e:	f04a                	sd	s2,32(sp)
ffffffffc0204240:	e852                	sd	s4,16(sp)
ffffffffc0204242:	40c78433          	sub	s0,a5,a2
ffffffffc0204246:	84b2                	mv	s1,a2
ffffffffc0204248:	89b6                	mv	s3,a3
ffffffffc020424a:	8aae                	mv	s5,a1
ffffffffc020424c:	8b2a                	mv	s6,a0
ffffffffc020424e:	0086f363          	bgeu	a3,s0,ffffffffc0204254 <copy_string+0x2c>
ffffffffc0204252:	8436                	mv	s0,a3
ffffffffc0204254:	4901                	li	s2,0
ffffffffc0204256:	e82d                	bnez	s0,ffffffffc02042c8 <copy_string+0xa0>
ffffffffc0204258:	4681                	li	a3,0
ffffffffc020425a:	8622                	mv	a2,s0
ffffffffc020425c:	85a6                	mv	a1,s1
ffffffffc020425e:	855a                	mv	a0,s6
ffffffffc0204260:	eb7ff0ef          	jal	ffffffffc0204116 <user_mem_check>
ffffffffc0204264:	8a2a                	mv	s4,a0
ffffffffc0204266:	c529                	beqz	a0,ffffffffc02042b0 <copy_string+0x88>
ffffffffc0204268:	8556                	mv	a0,s5
ffffffffc020426a:	8622                	mv	a2,s0
ffffffffc020426c:	85a6                	mv	a1,s1
ffffffffc020426e:	374070ef          	jal	ffffffffc020b5e2 <memcpy>
ffffffffc0204272:	9aa2                	add	s5,s5,s0
ffffffffc0204274:	05246c63          	bltu	s0,s2,ffffffffc02042cc <copy_string+0xa4>
ffffffffc0204278:	03340c63          	beq	s0,s3,ffffffffc02042b0 <copy_string+0x88>
ffffffffc020427c:	408989b3          	sub	s3,s3,s0
ffffffffc0204280:	6785                	lui	a5,0x1
ffffffffc0204282:	94a2                	add	s1,s1,s0
ffffffffc0204284:	894e                	mv	s2,s3
ffffffffc0204286:	0137f363          	bgeu	a5,s3,ffffffffc020428c <copy_string+0x64>
ffffffffc020428a:	893e                	mv	s2,a5
ffffffffc020428c:	4401                	li	s0,0
ffffffffc020428e:	a021                	j	ffffffffc0204296 <copy_string+0x6e>
ffffffffc0204290:	0405                	addi	s0,s0,1
ffffffffc0204292:	fd2403e3          	beq	s0,s2,ffffffffc0204258 <copy_string+0x30>
ffffffffc0204296:	008487b3          	add	a5,s1,s0
ffffffffc020429a:	0007c783          	lbu	a5,0(a5) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc020429e:	fbed                	bnez	a5,ffffffffc0204290 <copy_string+0x68>
ffffffffc02042a0:	4681                	li	a3,0
ffffffffc02042a2:	8622                	mv	a2,s0
ffffffffc02042a4:	85a6                	mv	a1,s1
ffffffffc02042a6:	855a                	mv	a0,s6
ffffffffc02042a8:	e6fff0ef          	jal	ffffffffc0204116 <user_mem_check>
ffffffffc02042ac:	8a2a                	mv	s4,a0
ffffffffc02042ae:	fd4d                	bnez	a0,ffffffffc0204268 <copy_string+0x40>
ffffffffc02042b0:	4a01                	li	s4,0
ffffffffc02042b2:	70e2                	ld	ra,56(sp)
ffffffffc02042b4:	7442                	ld	s0,48(sp)
ffffffffc02042b6:	74a2                	ld	s1,40(sp)
ffffffffc02042b8:	7902                	ld	s2,32(sp)
ffffffffc02042ba:	69e2                	ld	s3,24(sp)
ffffffffc02042bc:	6aa2                	ld	s5,8(sp)
ffffffffc02042be:	6b02                	ld	s6,0(sp)
ffffffffc02042c0:	8552                	mv	a0,s4
ffffffffc02042c2:	6a42                	ld	s4,16(sp)
ffffffffc02042c4:	6121                	addi	sp,sp,64
ffffffffc02042c6:	8082                	ret
ffffffffc02042c8:	8922                	mv	s2,s0
ffffffffc02042ca:	b7c9                	j	ffffffffc020428c <copy_string+0x64>
ffffffffc02042cc:	ff3402e3          	beq	s0,s3,ffffffffc02042b0 <copy_string+0x88>
ffffffffc02042d0:	000a8023          	sb	zero,0(s5) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc02042d4:	bff9                	j	ffffffffc02042b2 <copy_string+0x8a>

ffffffffc02042d6 <__down.constprop.0>:
ffffffffc02042d6:	711d                	addi	sp,sp,-96
ffffffffc02042d8:	ec86                	sd	ra,88(sp)
ffffffffc02042da:	100027f3          	csrr	a5,sstatus
ffffffffc02042de:	8b89                	andi	a5,a5,2
ffffffffc02042e0:	eba1                	bnez	a5,ffffffffc0204330 <__down.constprop.0+0x5a>
ffffffffc02042e2:	411c                	lw	a5,0(a0)
ffffffffc02042e4:	00f05863          	blez	a5,ffffffffc02042f4 <__down.constprop.0+0x1e>
ffffffffc02042e8:	37fd                	addiw	a5,a5,-1
ffffffffc02042ea:	c11c                	sw	a5,0(a0)
ffffffffc02042ec:	60e6                	ld	ra,88(sp)
ffffffffc02042ee:	4501                	li	a0,0
ffffffffc02042f0:	6125                	addi	sp,sp,96
ffffffffc02042f2:	8082                	ret
ffffffffc02042f4:	0521                	addi	a0,a0,8
ffffffffc02042f6:	082c                	addi	a1,sp,24
ffffffffc02042f8:	10000613          	li	a2,256
ffffffffc02042fc:	e8a2                	sd	s0,80(sp)
ffffffffc02042fe:	e4a6                	sd	s1,72(sp)
ffffffffc0204300:	0820                	addi	s0,sp,24
ffffffffc0204302:	84aa                	mv	s1,a0
ffffffffc0204304:	2d0000ef          	jal	ffffffffc02045d4 <wait_current_set>
ffffffffc0204308:	7d3020ef          	jal	ffffffffc02072da <schedule>
ffffffffc020430c:	100027f3          	csrr	a5,sstatus
ffffffffc0204310:	8b89                	andi	a5,a5,2
ffffffffc0204312:	efa9                	bnez	a5,ffffffffc020436c <__down.constprop.0+0x96>
ffffffffc0204314:	8522                	mv	a0,s0
ffffffffc0204316:	192000ef          	jal	ffffffffc02044a8 <wait_in_queue>
ffffffffc020431a:	e521                	bnez	a0,ffffffffc0204362 <__down.constprop.0+0x8c>
ffffffffc020431c:	5502                	lw	a0,32(sp)
ffffffffc020431e:	10000793          	li	a5,256
ffffffffc0204322:	6446                	ld	s0,80(sp)
ffffffffc0204324:	64a6                	ld	s1,72(sp)
ffffffffc0204326:	fcf503e3          	beq	a0,a5,ffffffffc02042ec <__down.constprop.0+0x16>
ffffffffc020432a:	60e6                	ld	ra,88(sp)
ffffffffc020432c:	6125                	addi	sp,sp,96
ffffffffc020432e:	8082                	ret
ffffffffc0204330:	e42a                	sd	a0,8(sp)
ffffffffc0204332:	93ffc0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0204336:	6522                	ld	a0,8(sp)
ffffffffc0204338:	411c                	lw	a5,0(a0)
ffffffffc020433a:	00f05763          	blez	a5,ffffffffc0204348 <__down.constprop.0+0x72>
ffffffffc020433e:	37fd                	addiw	a5,a5,-1
ffffffffc0204340:	c11c                	sw	a5,0(a0)
ffffffffc0204342:	929fc0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0204346:	b75d                	j	ffffffffc02042ec <__down.constprop.0+0x16>
ffffffffc0204348:	0521                	addi	a0,a0,8
ffffffffc020434a:	082c                	addi	a1,sp,24
ffffffffc020434c:	10000613          	li	a2,256
ffffffffc0204350:	e8a2                	sd	s0,80(sp)
ffffffffc0204352:	e4a6                	sd	s1,72(sp)
ffffffffc0204354:	0820                	addi	s0,sp,24
ffffffffc0204356:	84aa                	mv	s1,a0
ffffffffc0204358:	27c000ef          	jal	ffffffffc02045d4 <wait_current_set>
ffffffffc020435c:	90ffc0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0204360:	b765                	j	ffffffffc0204308 <__down.constprop.0+0x32>
ffffffffc0204362:	85a2                	mv	a1,s0
ffffffffc0204364:	8526                	mv	a0,s1
ffffffffc0204366:	0e8000ef          	jal	ffffffffc020444e <wait_queue_del>
ffffffffc020436a:	bf4d                	j	ffffffffc020431c <__down.constprop.0+0x46>
ffffffffc020436c:	905fc0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0204370:	8522                	mv	a0,s0
ffffffffc0204372:	136000ef          	jal	ffffffffc02044a8 <wait_in_queue>
ffffffffc0204376:	e501                	bnez	a0,ffffffffc020437e <__down.constprop.0+0xa8>
ffffffffc0204378:	8f3fc0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc020437c:	b745                	j	ffffffffc020431c <__down.constprop.0+0x46>
ffffffffc020437e:	85a2                	mv	a1,s0
ffffffffc0204380:	8526                	mv	a0,s1
ffffffffc0204382:	0cc000ef          	jal	ffffffffc020444e <wait_queue_del>
ffffffffc0204386:	bfcd                	j	ffffffffc0204378 <__down.constprop.0+0xa2>

ffffffffc0204388 <__up.constprop.0>:
ffffffffc0204388:	1101                	addi	sp,sp,-32
ffffffffc020438a:	e426                	sd	s1,8(sp)
ffffffffc020438c:	ec06                	sd	ra,24(sp)
ffffffffc020438e:	e822                	sd	s0,16(sp)
ffffffffc0204390:	e04a                	sd	s2,0(sp)
ffffffffc0204392:	84aa                	mv	s1,a0
ffffffffc0204394:	100027f3          	csrr	a5,sstatus
ffffffffc0204398:	8b89                	andi	a5,a5,2
ffffffffc020439a:	4901                	li	s2,0
ffffffffc020439c:	e7b1                	bnez	a5,ffffffffc02043e8 <__up.constprop.0+0x60>
ffffffffc020439e:	00848413          	addi	s0,s1,8
ffffffffc02043a2:	8522                	mv	a0,s0
ffffffffc02043a4:	0e8000ef          	jal	ffffffffc020448c <wait_queue_first>
ffffffffc02043a8:	cd05                	beqz	a0,ffffffffc02043e0 <__up.constprop.0+0x58>
ffffffffc02043aa:	6118                	ld	a4,0(a0)
ffffffffc02043ac:	10000793          	li	a5,256
ffffffffc02043b0:	0ec72603          	lw	a2,236(a4) # fffffffffffff0ec <end+0x3fd687dc>
ffffffffc02043b4:	02f61e63          	bne	a2,a5,ffffffffc02043f0 <__up.constprop.0+0x68>
ffffffffc02043b8:	85aa                	mv	a1,a0
ffffffffc02043ba:	4685                	li	a3,1
ffffffffc02043bc:	8522                	mv	a0,s0
ffffffffc02043be:	0f8000ef          	jal	ffffffffc02044b6 <wakeup_wait>
ffffffffc02043c2:	00091863          	bnez	s2,ffffffffc02043d2 <__up.constprop.0+0x4a>
ffffffffc02043c6:	60e2                	ld	ra,24(sp)
ffffffffc02043c8:	6442                	ld	s0,16(sp)
ffffffffc02043ca:	64a2                	ld	s1,8(sp)
ffffffffc02043cc:	6902                	ld	s2,0(sp)
ffffffffc02043ce:	6105                	addi	sp,sp,32
ffffffffc02043d0:	8082                	ret
ffffffffc02043d2:	6442                	ld	s0,16(sp)
ffffffffc02043d4:	60e2                	ld	ra,24(sp)
ffffffffc02043d6:	64a2                	ld	s1,8(sp)
ffffffffc02043d8:	6902                	ld	s2,0(sp)
ffffffffc02043da:	6105                	addi	sp,sp,32
ffffffffc02043dc:	88ffc06f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc02043e0:	409c                	lw	a5,0(s1)
ffffffffc02043e2:	2785                	addiw	a5,a5,1
ffffffffc02043e4:	c09c                	sw	a5,0(s1)
ffffffffc02043e6:	bff1                	j	ffffffffc02043c2 <__up.constprop.0+0x3a>
ffffffffc02043e8:	889fc0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02043ec:	4905                	li	s2,1
ffffffffc02043ee:	bf45                	j	ffffffffc020439e <__up.constprop.0+0x16>
ffffffffc02043f0:	00009697          	auipc	a3,0x9
ffffffffc02043f4:	a9068693          	addi	a3,a3,-1392 # ffffffffc020ce80 <etext+0x1886>
ffffffffc02043f8:	00007617          	auipc	a2,0x7
ffffffffc02043fc:	64060613          	addi	a2,a2,1600 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204400:	45e5                	li	a1,25
ffffffffc0204402:	00009517          	auipc	a0,0x9
ffffffffc0204406:	aa650513          	addi	a0,a0,-1370 # ffffffffc020cea8 <etext+0x18ae>
ffffffffc020440a:	840fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020440e <sem_init>:
ffffffffc020440e:	c10c                	sw	a1,0(a0)
ffffffffc0204410:	0521                	addi	a0,a0,8
ffffffffc0204412:	a81d                	j	ffffffffc0204448 <wait_queue_init>

ffffffffc0204414 <up>:
ffffffffc0204414:	f75ff06f          	j	ffffffffc0204388 <__up.constprop.0>

ffffffffc0204418 <down>:
ffffffffc0204418:	1141                	addi	sp,sp,-16
ffffffffc020441a:	e406                	sd	ra,8(sp)
ffffffffc020441c:	ebbff0ef          	jal	ffffffffc02042d6 <__down.constprop.0>
ffffffffc0204420:	e501                	bnez	a0,ffffffffc0204428 <down+0x10>
ffffffffc0204422:	60a2                	ld	ra,8(sp)
ffffffffc0204424:	0141                	addi	sp,sp,16
ffffffffc0204426:	8082                	ret
ffffffffc0204428:	00009697          	auipc	a3,0x9
ffffffffc020442c:	a9068693          	addi	a3,a3,-1392 # ffffffffc020ceb8 <etext+0x18be>
ffffffffc0204430:	00007617          	auipc	a2,0x7
ffffffffc0204434:	60860613          	addi	a2,a2,1544 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204438:	04000593          	li	a1,64
ffffffffc020443c:	00009517          	auipc	a0,0x9
ffffffffc0204440:	a6c50513          	addi	a0,a0,-1428 # ffffffffc020cea8 <etext+0x18ae>
ffffffffc0204444:	806fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204448 <wait_queue_init>:
ffffffffc0204448:	e508                	sd	a0,8(a0)
ffffffffc020444a:	e108                	sd	a0,0(a0)
ffffffffc020444c:	8082                	ret

ffffffffc020444e <wait_queue_del>:
ffffffffc020444e:	7198                	ld	a4,32(a1)
ffffffffc0204450:	01858793          	addi	a5,a1,24
ffffffffc0204454:	00e78b63          	beq	a5,a4,ffffffffc020446a <wait_queue_del+0x1c>
ffffffffc0204458:	6994                	ld	a3,16(a1)
ffffffffc020445a:	00a69863          	bne	a3,a0,ffffffffc020446a <wait_queue_del+0x1c>
ffffffffc020445e:	6d94                	ld	a3,24(a1)
ffffffffc0204460:	e698                	sd	a4,8(a3)
ffffffffc0204462:	e314                	sd	a3,0(a4)
ffffffffc0204464:	f19c                	sd	a5,32(a1)
ffffffffc0204466:	ed9c                	sd	a5,24(a1)
ffffffffc0204468:	8082                	ret
ffffffffc020446a:	1141                	addi	sp,sp,-16
ffffffffc020446c:	00009697          	auipc	a3,0x9
ffffffffc0204470:	aac68693          	addi	a3,a3,-1364 # ffffffffc020cf18 <etext+0x191e>
ffffffffc0204474:	00007617          	auipc	a2,0x7
ffffffffc0204478:	5c460613          	addi	a2,a2,1476 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020447c:	45f1                	li	a1,28
ffffffffc020447e:	00009517          	auipc	a0,0x9
ffffffffc0204482:	a8250513          	addi	a0,a0,-1406 # ffffffffc020cf00 <etext+0x1906>
ffffffffc0204486:	e406                	sd	ra,8(sp)
ffffffffc0204488:	fc3fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020448c <wait_queue_first>:
ffffffffc020448c:	651c                	ld	a5,8(a0)
ffffffffc020448e:	00f50563          	beq	a0,a5,ffffffffc0204498 <wait_queue_first+0xc>
ffffffffc0204492:	fe878513          	addi	a0,a5,-24
ffffffffc0204496:	8082                	ret
ffffffffc0204498:	4501                	li	a0,0
ffffffffc020449a:	8082                	ret

ffffffffc020449c <wait_queue_empty>:
ffffffffc020449c:	651c                	ld	a5,8(a0)
ffffffffc020449e:	40a78533          	sub	a0,a5,a0
ffffffffc02044a2:	00153513          	seqz	a0,a0
ffffffffc02044a6:	8082                	ret

ffffffffc02044a8 <wait_in_queue>:
ffffffffc02044a8:	711c                	ld	a5,32(a0)
ffffffffc02044aa:	0561                	addi	a0,a0,24
ffffffffc02044ac:	40a78533          	sub	a0,a5,a0
ffffffffc02044b0:	00a03533          	snez	a0,a0
ffffffffc02044b4:	8082                	ret

ffffffffc02044b6 <wakeup_wait>:
ffffffffc02044b6:	e689                	bnez	a3,ffffffffc02044c0 <wakeup_wait+0xa>
ffffffffc02044b8:	6188                	ld	a0,0(a1)
ffffffffc02044ba:	c590                	sw	a2,8(a1)
ffffffffc02044bc:	5270206f          	j	ffffffffc02071e2 <wakeup_proc>
ffffffffc02044c0:	7198                	ld	a4,32(a1)
ffffffffc02044c2:	01858793          	addi	a5,a1,24
ffffffffc02044c6:	00e78e63          	beq	a5,a4,ffffffffc02044e2 <wakeup_wait+0x2c>
ffffffffc02044ca:	6994                	ld	a3,16(a1)
ffffffffc02044cc:	00d51b63          	bne	a0,a3,ffffffffc02044e2 <wakeup_wait+0x2c>
ffffffffc02044d0:	6d94                	ld	a3,24(a1)
ffffffffc02044d2:	6188                	ld	a0,0(a1)
ffffffffc02044d4:	e698                	sd	a4,8(a3)
ffffffffc02044d6:	e314                	sd	a3,0(a4)
ffffffffc02044d8:	f19c                	sd	a5,32(a1)
ffffffffc02044da:	ed9c                	sd	a5,24(a1)
ffffffffc02044dc:	c590                	sw	a2,8(a1)
ffffffffc02044de:	5050206f          	j	ffffffffc02071e2 <wakeup_proc>
ffffffffc02044e2:	1141                	addi	sp,sp,-16
ffffffffc02044e4:	00009697          	auipc	a3,0x9
ffffffffc02044e8:	a3468693          	addi	a3,a3,-1484 # ffffffffc020cf18 <etext+0x191e>
ffffffffc02044ec:	00007617          	auipc	a2,0x7
ffffffffc02044f0:	54c60613          	addi	a2,a2,1356 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02044f4:	45f1                	li	a1,28
ffffffffc02044f6:	00009517          	auipc	a0,0x9
ffffffffc02044fa:	a0a50513          	addi	a0,a0,-1526 # ffffffffc020cf00 <etext+0x1906>
ffffffffc02044fe:	e406                	sd	ra,8(sp)
ffffffffc0204500:	f4bfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204504 <wakeup_queue>:
ffffffffc0204504:	651c                	ld	a5,8(a0)
ffffffffc0204506:	0aa78763          	beq	a5,a0,ffffffffc02045b4 <wakeup_queue+0xb0>
ffffffffc020450a:	1101                	addi	sp,sp,-32
ffffffffc020450c:	e822                	sd	s0,16(sp)
ffffffffc020450e:	e426                	sd	s1,8(sp)
ffffffffc0204510:	e04a                	sd	s2,0(sp)
ffffffffc0204512:	ec06                	sd	ra,24(sp)
ffffffffc0204514:	892e                	mv	s2,a1
ffffffffc0204516:	84aa                	mv	s1,a0
ffffffffc0204518:	fe878413          	addi	s0,a5,-24
ffffffffc020451c:	ee29                	bnez	a2,ffffffffc0204576 <wakeup_queue+0x72>
ffffffffc020451e:	6008                	ld	a0,0(s0)
ffffffffc0204520:	01242423          	sw	s2,8(s0)
ffffffffc0204524:	4bf020ef          	jal	ffffffffc02071e2 <wakeup_proc>
ffffffffc0204528:	701c                	ld	a5,32(s0)
ffffffffc020452a:	01840713          	addi	a4,s0,24
ffffffffc020452e:	02e78463          	beq	a5,a4,ffffffffc0204556 <wakeup_queue+0x52>
ffffffffc0204532:	6818                	ld	a4,16(s0)
ffffffffc0204534:	02e49163          	bne	s1,a4,ffffffffc0204556 <wakeup_queue+0x52>
ffffffffc0204538:	06f48863          	beq	s1,a5,ffffffffc02045a8 <wakeup_queue+0xa4>
ffffffffc020453c:	fe87b503          	ld	a0,-24(a5)
ffffffffc0204540:	ff27a823          	sw	s2,-16(a5)
ffffffffc0204544:	fe878413          	addi	s0,a5,-24
ffffffffc0204548:	49b020ef          	jal	ffffffffc02071e2 <wakeup_proc>
ffffffffc020454c:	701c                	ld	a5,32(s0)
ffffffffc020454e:	01840713          	addi	a4,s0,24
ffffffffc0204552:	fee790e3          	bne	a5,a4,ffffffffc0204532 <wakeup_queue+0x2e>
ffffffffc0204556:	00009697          	auipc	a3,0x9
ffffffffc020455a:	9c268693          	addi	a3,a3,-1598 # ffffffffc020cf18 <etext+0x191e>
ffffffffc020455e:	00007617          	auipc	a2,0x7
ffffffffc0204562:	4da60613          	addi	a2,a2,1242 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204566:	02200593          	li	a1,34
ffffffffc020456a:	00009517          	auipc	a0,0x9
ffffffffc020456e:	99650513          	addi	a0,a0,-1642 # ffffffffc020cf00 <etext+0x1906>
ffffffffc0204572:	ed9fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204576:	6798                	ld	a4,8(a5)
ffffffffc0204578:	00e79863          	bne	a5,a4,ffffffffc0204588 <wakeup_queue+0x84>
ffffffffc020457c:	a82d                	j	ffffffffc02045b6 <wakeup_queue+0xb2>
ffffffffc020457e:	6418                	ld	a4,8(s0)
ffffffffc0204580:	87a2                	mv	a5,s0
ffffffffc0204582:	1421                	addi	s0,s0,-24
ffffffffc0204584:	02e78963          	beq	a5,a4,ffffffffc02045b6 <wakeup_queue+0xb2>
ffffffffc0204588:	6814                	ld	a3,16(s0)
ffffffffc020458a:	02d49663          	bne	s1,a3,ffffffffc02045b6 <wakeup_queue+0xb2>
ffffffffc020458e:	6c14                	ld	a3,24(s0)
ffffffffc0204590:	6008                	ld	a0,0(s0)
ffffffffc0204592:	e698                	sd	a4,8(a3)
ffffffffc0204594:	e314                	sd	a3,0(a4)
ffffffffc0204596:	f01c                	sd	a5,32(s0)
ffffffffc0204598:	ec1c                	sd	a5,24(s0)
ffffffffc020459a:	01242423          	sw	s2,8(s0)
ffffffffc020459e:	445020ef          	jal	ffffffffc02071e2 <wakeup_proc>
ffffffffc02045a2:	6480                	ld	s0,8(s1)
ffffffffc02045a4:	fc849de3          	bne	s1,s0,ffffffffc020457e <wakeup_queue+0x7a>
ffffffffc02045a8:	60e2                	ld	ra,24(sp)
ffffffffc02045aa:	6442                	ld	s0,16(sp)
ffffffffc02045ac:	64a2                	ld	s1,8(sp)
ffffffffc02045ae:	6902                	ld	s2,0(sp)
ffffffffc02045b0:	6105                	addi	sp,sp,32
ffffffffc02045b2:	8082                	ret
ffffffffc02045b4:	8082                	ret
ffffffffc02045b6:	00009697          	auipc	a3,0x9
ffffffffc02045ba:	96268693          	addi	a3,a3,-1694 # ffffffffc020cf18 <etext+0x191e>
ffffffffc02045be:	00007617          	auipc	a2,0x7
ffffffffc02045c2:	47a60613          	addi	a2,a2,1146 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02045c6:	45f1                	li	a1,28
ffffffffc02045c8:	00009517          	auipc	a0,0x9
ffffffffc02045cc:	93850513          	addi	a0,a0,-1736 # ffffffffc020cf00 <etext+0x1906>
ffffffffc02045d0:	e7bfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02045d4 <wait_current_set>:
ffffffffc02045d4:	00092797          	auipc	a5,0x92
ffffffffc02045d8:	2f47b783          	ld	a5,756(a5) # ffffffffc02968c8 <current>
ffffffffc02045dc:	c39d                	beqz	a5,ffffffffc0204602 <wait_current_set+0x2e>
ffffffffc02045de:	80000737          	lui	a4,0x80000
ffffffffc02045e2:	c598                	sw	a4,8(a1)
ffffffffc02045e4:	01858713          	addi	a4,a1,24
ffffffffc02045e8:	ed98                	sd	a4,24(a1)
ffffffffc02045ea:	e19c                	sd	a5,0(a1)
ffffffffc02045ec:	0ec7a623          	sw	a2,236(a5)
ffffffffc02045f0:	4605                	li	a2,1
ffffffffc02045f2:	6114                	ld	a3,0(a0)
ffffffffc02045f4:	c390                	sw	a2,0(a5)
ffffffffc02045f6:	e988                	sd	a0,16(a1)
ffffffffc02045f8:	e118                	sd	a4,0(a0)
ffffffffc02045fa:	e698                	sd	a4,8(a3)
ffffffffc02045fc:	ed94                	sd	a3,24(a1)
ffffffffc02045fe:	f188                	sd	a0,32(a1)
ffffffffc0204600:	8082                	ret
ffffffffc0204602:	1141                	addi	sp,sp,-16
ffffffffc0204604:	00009697          	auipc	a3,0x9
ffffffffc0204608:	95468693          	addi	a3,a3,-1708 # ffffffffc020cf58 <etext+0x195e>
ffffffffc020460c:	00007617          	auipc	a2,0x7
ffffffffc0204610:	42c60613          	addi	a2,a2,1068 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204614:	07400593          	li	a1,116
ffffffffc0204618:	00009517          	auipc	a0,0x9
ffffffffc020461c:	8e850513          	addi	a0,a0,-1816 # ffffffffc020cf00 <etext+0x1906>
ffffffffc0204620:	e406                	sd	ra,8(sp)
ffffffffc0204622:	e29fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204626 <get_fd_array.part.0>:
ffffffffc0204626:	1141                	addi	sp,sp,-16
ffffffffc0204628:	00009697          	auipc	a3,0x9
ffffffffc020462c:	94068693          	addi	a3,a3,-1728 # ffffffffc020cf68 <etext+0x196e>
ffffffffc0204630:	00007617          	auipc	a2,0x7
ffffffffc0204634:	40860613          	addi	a2,a2,1032 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204638:	45d1                	li	a1,20
ffffffffc020463a:	00009517          	auipc	a0,0x9
ffffffffc020463e:	95e50513          	addi	a0,a0,-1698 # ffffffffc020cf98 <etext+0x199e>
ffffffffc0204642:	e406                	sd	ra,8(sp)
ffffffffc0204644:	e07fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204648 <fd_array_alloc>:
ffffffffc0204648:	00092797          	auipc	a5,0x92
ffffffffc020464c:	2807b783          	ld	a5,640(a5) # ffffffffc02968c8 <current>
ffffffffc0204650:	1141                	addi	sp,sp,-16
ffffffffc0204652:	e406                	sd	ra,8(sp)
ffffffffc0204654:	1487b783          	ld	a5,328(a5)
ffffffffc0204658:	cfb9                	beqz	a5,ffffffffc02046b6 <fd_array_alloc+0x6e>
ffffffffc020465a:	4b98                	lw	a4,16(a5)
ffffffffc020465c:	04e05d63          	blez	a4,ffffffffc02046b6 <fd_array_alloc+0x6e>
ffffffffc0204660:	775d                	lui	a4,0xffff7
ffffffffc0204662:	ad970713          	addi	a4,a4,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0204666:	679c                	ld	a5,8(a5)
ffffffffc0204668:	02e50763          	beq	a0,a4,ffffffffc0204696 <fd_array_alloc+0x4e>
ffffffffc020466c:	04700713          	li	a4,71
ffffffffc0204670:	04a76163          	bltu	a4,a0,ffffffffc02046b2 <fd_array_alloc+0x6a>
ffffffffc0204674:	00351713          	slli	a4,a0,0x3
ffffffffc0204678:	8f09                	sub	a4,a4,a0
ffffffffc020467a:	070e                	slli	a4,a4,0x3
ffffffffc020467c:	97ba                	add	a5,a5,a4
ffffffffc020467e:	4398                	lw	a4,0(a5)
ffffffffc0204680:	e71d                	bnez	a4,ffffffffc02046ae <fd_array_alloc+0x66>
ffffffffc0204682:	5b88                	lw	a0,48(a5)
ffffffffc0204684:	e91d                	bnez	a0,ffffffffc02046ba <fd_array_alloc+0x72>
ffffffffc0204686:	4705                	li	a4,1
ffffffffc0204688:	0207b423          	sd	zero,40(a5)
ffffffffc020468c:	c398                	sw	a4,0(a5)
ffffffffc020468e:	e19c                	sd	a5,0(a1)
ffffffffc0204690:	60a2                	ld	ra,8(sp)
ffffffffc0204692:	0141                	addi	sp,sp,16
ffffffffc0204694:	8082                	ret
ffffffffc0204696:	7ff78693          	addi	a3,a5,2047
ffffffffc020469a:	7c168693          	addi	a3,a3,1985
ffffffffc020469e:	4398                	lw	a4,0(a5)
ffffffffc02046a0:	d36d                	beqz	a4,ffffffffc0204682 <fd_array_alloc+0x3a>
ffffffffc02046a2:	03878793          	addi	a5,a5,56
ffffffffc02046a6:	fed79ce3          	bne	a5,a3,ffffffffc020469e <fd_array_alloc+0x56>
ffffffffc02046aa:	5529                	li	a0,-22
ffffffffc02046ac:	b7d5                	j	ffffffffc0204690 <fd_array_alloc+0x48>
ffffffffc02046ae:	5545                	li	a0,-15
ffffffffc02046b0:	b7c5                	j	ffffffffc0204690 <fd_array_alloc+0x48>
ffffffffc02046b2:	5575                	li	a0,-3
ffffffffc02046b4:	bff1                	j	ffffffffc0204690 <fd_array_alloc+0x48>
ffffffffc02046b6:	f71ff0ef          	jal	ffffffffc0204626 <get_fd_array.part.0>
ffffffffc02046ba:	00009697          	auipc	a3,0x9
ffffffffc02046be:	8ee68693          	addi	a3,a3,-1810 # ffffffffc020cfa8 <etext+0x19ae>
ffffffffc02046c2:	00007617          	auipc	a2,0x7
ffffffffc02046c6:	37660613          	addi	a2,a2,886 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02046ca:	03b00593          	li	a1,59
ffffffffc02046ce:	00009517          	auipc	a0,0x9
ffffffffc02046d2:	8ca50513          	addi	a0,a0,-1846 # ffffffffc020cf98 <etext+0x199e>
ffffffffc02046d6:	d75fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02046da <fd_array_free>:
ffffffffc02046da:	4118                	lw	a4,0(a0)
ffffffffc02046dc:	1101                	addi	sp,sp,-32
ffffffffc02046de:	ec06                	sd	ra,24(sp)
ffffffffc02046e0:	4685                	li	a3,1
ffffffffc02046e2:	ffd77613          	andi	a2,a4,-3
ffffffffc02046e6:	04d61763          	bne	a2,a3,ffffffffc0204734 <fd_array_free+0x5a>
ffffffffc02046ea:	5914                	lw	a3,48(a0)
ffffffffc02046ec:	87aa                	mv	a5,a0
ffffffffc02046ee:	e29d                	bnez	a3,ffffffffc0204714 <fd_array_free+0x3a>
ffffffffc02046f0:	468d                	li	a3,3
ffffffffc02046f2:	00d70763          	beq	a4,a3,ffffffffc0204700 <fd_array_free+0x26>
ffffffffc02046f6:	60e2                	ld	ra,24(sp)
ffffffffc02046f8:	0007a023          	sw	zero,0(a5)
ffffffffc02046fc:	6105                	addi	sp,sp,32
ffffffffc02046fe:	8082                	ret
ffffffffc0204700:	7508                	ld	a0,40(a0)
ffffffffc0204702:	e43e                	sd	a5,8(sp)
ffffffffc0204704:	219030ef          	jal	ffffffffc020811c <vfs_close>
ffffffffc0204708:	67a2                	ld	a5,8(sp)
ffffffffc020470a:	60e2                	ld	ra,24(sp)
ffffffffc020470c:	0007a023          	sw	zero,0(a5)
ffffffffc0204710:	6105                	addi	sp,sp,32
ffffffffc0204712:	8082                	ret
ffffffffc0204714:	00009697          	auipc	a3,0x9
ffffffffc0204718:	89468693          	addi	a3,a3,-1900 # ffffffffc020cfa8 <etext+0x19ae>
ffffffffc020471c:	00007617          	auipc	a2,0x7
ffffffffc0204720:	31c60613          	addi	a2,a2,796 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204724:	04500593          	li	a1,69
ffffffffc0204728:	00009517          	auipc	a0,0x9
ffffffffc020472c:	87050513          	addi	a0,a0,-1936 # ffffffffc020cf98 <etext+0x199e>
ffffffffc0204730:	d1bfb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204734:	00009697          	auipc	a3,0x9
ffffffffc0204738:	8ac68693          	addi	a3,a3,-1876 # ffffffffc020cfe0 <etext+0x19e6>
ffffffffc020473c:	00007617          	auipc	a2,0x7
ffffffffc0204740:	2fc60613          	addi	a2,a2,764 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204744:	04400593          	li	a1,68
ffffffffc0204748:	00009517          	auipc	a0,0x9
ffffffffc020474c:	85050513          	addi	a0,a0,-1968 # ffffffffc020cf98 <etext+0x199e>
ffffffffc0204750:	cfbfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204754 <fd_array_release>:
ffffffffc0204754:	411c                	lw	a5,0(a0)
ffffffffc0204756:	1141                	addi	sp,sp,-16
ffffffffc0204758:	e406                	sd	ra,8(sp)
ffffffffc020475a:	4685                	li	a3,1
ffffffffc020475c:	37f9                	addiw	a5,a5,-2
ffffffffc020475e:	02f6ef63          	bltu	a3,a5,ffffffffc020479c <fd_array_release+0x48>
ffffffffc0204762:	591c                	lw	a5,48(a0)
ffffffffc0204764:	00f05c63          	blez	a5,ffffffffc020477c <fd_array_release+0x28>
ffffffffc0204768:	37fd                	addiw	a5,a5,-1
ffffffffc020476a:	d91c                	sw	a5,48(a0)
ffffffffc020476c:	c781                	beqz	a5,ffffffffc0204774 <fd_array_release+0x20>
ffffffffc020476e:	60a2                	ld	ra,8(sp)
ffffffffc0204770:	0141                	addi	sp,sp,16
ffffffffc0204772:	8082                	ret
ffffffffc0204774:	60a2                	ld	ra,8(sp)
ffffffffc0204776:	0141                	addi	sp,sp,16
ffffffffc0204778:	f63ff06f          	j	ffffffffc02046da <fd_array_free>
ffffffffc020477c:	00009697          	auipc	a3,0x9
ffffffffc0204780:	8d468693          	addi	a3,a3,-1836 # ffffffffc020d050 <etext+0x1a56>
ffffffffc0204784:	00007617          	auipc	a2,0x7
ffffffffc0204788:	2b460613          	addi	a2,a2,692 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020478c:	05600593          	li	a1,86
ffffffffc0204790:	00009517          	auipc	a0,0x9
ffffffffc0204794:	80850513          	addi	a0,a0,-2040 # ffffffffc020cf98 <etext+0x199e>
ffffffffc0204798:	cb3fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020479c:	00009697          	auipc	a3,0x9
ffffffffc02047a0:	87c68693          	addi	a3,a3,-1924 # ffffffffc020d018 <etext+0x1a1e>
ffffffffc02047a4:	00007617          	auipc	a2,0x7
ffffffffc02047a8:	29460613          	addi	a2,a2,660 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02047ac:	05500593          	li	a1,85
ffffffffc02047b0:	00008517          	auipc	a0,0x8
ffffffffc02047b4:	7e850513          	addi	a0,a0,2024 # ffffffffc020cf98 <etext+0x199e>
ffffffffc02047b8:	c93fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02047bc <fd_array_open.part.0>:
ffffffffc02047bc:	1141                	addi	sp,sp,-16
ffffffffc02047be:	00009697          	auipc	a3,0x9
ffffffffc02047c2:	8aa68693          	addi	a3,a3,-1878 # ffffffffc020d068 <etext+0x1a6e>
ffffffffc02047c6:	00007617          	auipc	a2,0x7
ffffffffc02047ca:	27260613          	addi	a2,a2,626 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02047ce:	05f00593          	li	a1,95
ffffffffc02047d2:	00008517          	auipc	a0,0x8
ffffffffc02047d6:	7c650513          	addi	a0,a0,1990 # ffffffffc020cf98 <etext+0x199e>
ffffffffc02047da:	e406                	sd	ra,8(sp)
ffffffffc02047dc:	c6ffb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02047e0 <fd_array_init>:
ffffffffc02047e0:	4781                	li	a5,0
ffffffffc02047e2:	04800713          	li	a4,72
ffffffffc02047e6:	cd1c                	sw	a5,24(a0)
ffffffffc02047e8:	02052823          	sw	zero,48(a0)
ffffffffc02047ec:	00052023          	sw	zero,0(a0)
ffffffffc02047f0:	2785                	addiw	a5,a5,1
ffffffffc02047f2:	03850513          	addi	a0,a0,56
ffffffffc02047f6:	fee798e3          	bne	a5,a4,ffffffffc02047e6 <fd_array_init+0x6>
ffffffffc02047fa:	8082                	ret

ffffffffc02047fc <fd_array_close>:
ffffffffc02047fc:	4114                	lw	a3,0(a0)
ffffffffc02047fe:	1101                	addi	sp,sp,-32
ffffffffc0204800:	ec06                	sd	ra,24(sp)
ffffffffc0204802:	4789                	li	a5,2
ffffffffc0204804:	04f69863          	bne	a3,a5,ffffffffc0204854 <fd_array_close+0x58>
ffffffffc0204808:	591c                	lw	a5,48(a0)
ffffffffc020480a:	872a                	mv	a4,a0
ffffffffc020480c:	02f05463          	blez	a5,ffffffffc0204834 <fd_array_close+0x38>
ffffffffc0204810:	37fd                	addiw	a5,a5,-1
ffffffffc0204812:	468d                	li	a3,3
ffffffffc0204814:	d91c                	sw	a5,48(a0)
ffffffffc0204816:	c114                	sw	a3,0(a0)
ffffffffc0204818:	c781                	beqz	a5,ffffffffc0204820 <fd_array_close+0x24>
ffffffffc020481a:	60e2                	ld	ra,24(sp)
ffffffffc020481c:	6105                	addi	sp,sp,32
ffffffffc020481e:	8082                	ret
ffffffffc0204820:	7508                	ld	a0,40(a0)
ffffffffc0204822:	e43a                	sd	a4,8(sp)
ffffffffc0204824:	0f9030ef          	jal	ffffffffc020811c <vfs_close>
ffffffffc0204828:	6722                	ld	a4,8(sp)
ffffffffc020482a:	60e2                	ld	ra,24(sp)
ffffffffc020482c:	00072023          	sw	zero,0(a4)
ffffffffc0204830:	6105                	addi	sp,sp,32
ffffffffc0204832:	8082                	ret
ffffffffc0204834:	00009697          	auipc	a3,0x9
ffffffffc0204838:	81c68693          	addi	a3,a3,-2020 # ffffffffc020d050 <etext+0x1a56>
ffffffffc020483c:	00007617          	auipc	a2,0x7
ffffffffc0204840:	1fc60613          	addi	a2,a2,508 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204844:	06800593          	li	a1,104
ffffffffc0204848:	00008517          	auipc	a0,0x8
ffffffffc020484c:	75050513          	addi	a0,a0,1872 # ffffffffc020cf98 <etext+0x199e>
ffffffffc0204850:	bfbfb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204854:	00008697          	auipc	a3,0x8
ffffffffc0204858:	76c68693          	addi	a3,a3,1900 # ffffffffc020cfc0 <etext+0x19c6>
ffffffffc020485c:	00007617          	auipc	a2,0x7
ffffffffc0204860:	1dc60613          	addi	a2,a2,476 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204864:	06700593          	li	a1,103
ffffffffc0204868:	00008517          	auipc	a0,0x8
ffffffffc020486c:	73050513          	addi	a0,a0,1840 # ffffffffc020cf98 <etext+0x199e>
ffffffffc0204870:	bdbfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204874 <fd_array_dup>:
ffffffffc0204874:	4118                	lw	a4,0(a0)
ffffffffc0204876:	1101                	addi	sp,sp,-32
ffffffffc0204878:	ec06                	sd	ra,24(sp)
ffffffffc020487a:	e822                	sd	s0,16(sp)
ffffffffc020487c:	e426                	sd	s1,8(sp)
ffffffffc020487e:	e04a                	sd	s2,0(sp)
ffffffffc0204880:	4785                	li	a5,1
ffffffffc0204882:	04f71563          	bne	a4,a5,ffffffffc02048cc <fd_array_dup+0x58>
ffffffffc0204886:	0005a903          	lw	s2,0(a1)
ffffffffc020488a:	4789                	li	a5,2
ffffffffc020488c:	04f91063          	bne	s2,a5,ffffffffc02048cc <fd_array_dup+0x58>
ffffffffc0204890:	719c                	ld	a5,32(a1)
ffffffffc0204892:	7584                	ld	s1,40(a1)
ffffffffc0204894:	842a                	mv	s0,a0
ffffffffc0204896:	f11c                	sd	a5,32(a0)
ffffffffc0204898:	699c                	ld	a5,16(a1)
ffffffffc020489a:	6598                	ld	a4,8(a1)
ffffffffc020489c:	8526                	mv	a0,s1
ffffffffc020489e:	e81c                	sd	a5,16(s0)
ffffffffc02048a0:	e418                	sd	a4,8(s0)
ffffffffc02048a2:	78f020ef          	jal	ffffffffc0207830 <inode_ref_inc>
ffffffffc02048a6:	8526                	mv	a0,s1
ffffffffc02048a8:	793020ef          	jal	ffffffffc020783a <inode_open_inc>
ffffffffc02048ac:	401c                	lw	a5,0(s0)
ffffffffc02048ae:	f404                	sd	s1,40(s0)
ffffffffc02048b0:	17fd                	addi	a5,a5,-1
ffffffffc02048b2:	ef8d                	bnez	a5,ffffffffc02048ec <fd_array_dup+0x78>
ffffffffc02048b4:	cc85                	beqz	s1,ffffffffc02048ec <fd_array_dup+0x78>
ffffffffc02048b6:	581c                	lw	a5,48(s0)
ffffffffc02048b8:	01242023          	sw	s2,0(s0)
ffffffffc02048bc:	60e2                	ld	ra,24(sp)
ffffffffc02048be:	2785                	addiw	a5,a5,1
ffffffffc02048c0:	d81c                	sw	a5,48(s0)
ffffffffc02048c2:	6442                	ld	s0,16(sp)
ffffffffc02048c4:	64a2                	ld	s1,8(sp)
ffffffffc02048c6:	6902                	ld	s2,0(sp)
ffffffffc02048c8:	6105                	addi	sp,sp,32
ffffffffc02048ca:	8082                	ret
ffffffffc02048cc:	00008697          	auipc	a3,0x8
ffffffffc02048d0:	7cc68693          	addi	a3,a3,1996 # ffffffffc020d098 <etext+0x1a9e>
ffffffffc02048d4:	00007617          	auipc	a2,0x7
ffffffffc02048d8:	16460613          	addi	a2,a2,356 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02048dc:	07300593          	li	a1,115
ffffffffc02048e0:	00008517          	auipc	a0,0x8
ffffffffc02048e4:	6b850513          	addi	a0,a0,1720 # ffffffffc020cf98 <etext+0x199e>
ffffffffc02048e8:	b63fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02048ec:	ed1ff0ef          	jal	ffffffffc02047bc <fd_array_open.part.0>

ffffffffc02048f0 <file_testfd>:
ffffffffc02048f0:	04700793          	li	a5,71
ffffffffc02048f4:	04a7e263          	bltu	a5,a0,ffffffffc0204938 <file_testfd+0x48>
ffffffffc02048f8:	00092797          	auipc	a5,0x92
ffffffffc02048fc:	fd07b783          	ld	a5,-48(a5) # ffffffffc02968c8 <current>
ffffffffc0204900:	1487b783          	ld	a5,328(a5)
ffffffffc0204904:	cf85                	beqz	a5,ffffffffc020493c <file_testfd+0x4c>
ffffffffc0204906:	4b98                	lw	a4,16(a5)
ffffffffc0204908:	02e05a63          	blez	a4,ffffffffc020493c <file_testfd+0x4c>
ffffffffc020490c:	6798                	ld	a4,8(a5)
ffffffffc020490e:	00351793          	slli	a5,a0,0x3
ffffffffc0204912:	8f89                	sub	a5,a5,a0
ffffffffc0204914:	078e                	slli	a5,a5,0x3
ffffffffc0204916:	97ba                	add	a5,a5,a4
ffffffffc0204918:	4394                	lw	a3,0(a5)
ffffffffc020491a:	4709                	li	a4,2
ffffffffc020491c:	00e69e63          	bne	a3,a4,ffffffffc0204938 <file_testfd+0x48>
ffffffffc0204920:	4f98                	lw	a4,24(a5)
ffffffffc0204922:	00a71b63          	bne	a4,a0,ffffffffc0204938 <file_testfd+0x48>
ffffffffc0204926:	c199                	beqz	a1,ffffffffc020492c <file_testfd+0x3c>
ffffffffc0204928:	6788                	ld	a0,8(a5)
ffffffffc020492a:	c901                	beqz	a0,ffffffffc020493a <file_testfd+0x4a>
ffffffffc020492c:	4505                	li	a0,1
ffffffffc020492e:	c611                	beqz	a2,ffffffffc020493a <file_testfd+0x4a>
ffffffffc0204930:	6b88                	ld	a0,16(a5)
ffffffffc0204932:	00a03533          	snez	a0,a0
ffffffffc0204936:	8082                	ret
ffffffffc0204938:	4501                	li	a0,0
ffffffffc020493a:	8082                	ret
ffffffffc020493c:	1141                	addi	sp,sp,-16
ffffffffc020493e:	e406                	sd	ra,8(sp)
ffffffffc0204940:	ce7ff0ef          	jal	ffffffffc0204626 <get_fd_array.part.0>

ffffffffc0204944 <file_open>:
ffffffffc0204944:	0035f793          	andi	a5,a1,3
ffffffffc0204948:	470d                	li	a4,3
ffffffffc020494a:	0ee78563          	beq	a5,a4,ffffffffc0204a34 <file_open+0xf0>
ffffffffc020494e:	078e                	slli	a5,a5,0x3
ffffffffc0204950:	0000a717          	auipc	a4,0xa
ffffffffc0204954:	30870713          	addi	a4,a4,776 # ffffffffc020ec58 <CSWTCH.79>
ffffffffc0204958:	0000a697          	auipc	a3,0xa
ffffffffc020495c:	31868693          	addi	a3,a3,792 # ffffffffc020ec70 <CSWTCH.78>
ffffffffc0204960:	96be                	add	a3,a3,a5
ffffffffc0204962:	97ba                	add	a5,a5,a4
ffffffffc0204964:	7159                	addi	sp,sp,-112
ffffffffc0204966:	639c                	ld	a5,0(a5)
ffffffffc0204968:	6298                	ld	a4,0(a3)
ffffffffc020496a:	eca6                	sd	s1,88(sp)
ffffffffc020496c:	84aa                	mv	s1,a0
ffffffffc020496e:	755d                	lui	a0,0xffff7
ffffffffc0204970:	f0a2                	sd	s0,96(sp)
ffffffffc0204972:	ad950513          	addi	a0,a0,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0204976:	842e                	mv	s0,a1
ffffffffc0204978:	080c                	addi	a1,sp,16
ffffffffc020497a:	e8ca                	sd	s2,80(sp)
ffffffffc020497c:	e4ce                	sd	s3,72(sp)
ffffffffc020497e:	f486                	sd	ra,104(sp)
ffffffffc0204980:	89be                	mv	s3,a5
ffffffffc0204982:	893a                	mv	s2,a4
ffffffffc0204984:	cc5ff0ef          	jal	ffffffffc0204648 <fd_array_alloc>
ffffffffc0204988:	87aa                	mv	a5,a0
ffffffffc020498a:	c909                	beqz	a0,ffffffffc020499c <file_open+0x58>
ffffffffc020498c:	70a6                	ld	ra,104(sp)
ffffffffc020498e:	7406                	ld	s0,96(sp)
ffffffffc0204990:	64e6                	ld	s1,88(sp)
ffffffffc0204992:	6946                	ld	s2,80(sp)
ffffffffc0204994:	69a6                	ld	s3,72(sp)
ffffffffc0204996:	853e                	mv	a0,a5
ffffffffc0204998:	6165                	addi	sp,sp,112
ffffffffc020499a:	8082                	ret
ffffffffc020499c:	8526                	mv	a0,s1
ffffffffc020499e:	0830                	addi	a2,sp,24
ffffffffc02049a0:	85a2                	mv	a1,s0
ffffffffc02049a2:	5a4030ef          	jal	ffffffffc0207f46 <vfs_open>
ffffffffc02049a6:	6742                	ld	a4,16(sp)
ffffffffc02049a8:	e141                	bnez	a0,ffffffffc0204a28 <file_open+0xe4>
ffffffffc02049aa:	02073023          	sd	zero,32(a4)
ffffffffc02049ae:	02047593          	andi	a1,s0,32
ffffffffc02049b2:	c98d                	beqz	a1,ffffffffc02049e4 <file_open+0xa0>
ffffffffc02049b4:	6562                	ld	a0,24(sp)
ffffffffc02049b6:	c541                	beqz	a0,ffffffffc0204a3e <file_open+0xfa>
ffffffffc02049b8:	793c                	ld	a5,112(a0)
ffffffffc02049ba:	c3d1                	beqz	a5,ffffffffc0204a3e <file_open+0xfa>
ffffffffc02049bc:	779c                	ld	a5,40(a5)
ffffffffc02049be:	c3c1                	beqz	a5,ffffffffc0204a3e <file_open+0xfa>
ffffffffc02049c0:	00008597          	auipc	a1,0x8
ffffffffc02049c4:	76058593          	addi	a1,a1,1888 # ffffffffc020d120 <etext+0x1b26>
ffffffffc02049c8:	e43a                	sd	a4,8(sp)
ffffffffc02049ca:	e02a                	sd	a0,0(sp)
ffffffffc02049cc:	679020ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc02049d0:	6502                	ld	a0,0(sp)
ffffffffc02049d2:	100c                	addi	a1,sp,32
ffffffffc02049d4:	793c                	ld	a5,112(a0)
ffffffffc02049d6:	6562                	ld	a0,24(sp)
ffffffffc02049d8:	779c                	ld	a5,40(a5)
ffffffffc02049da:	9782                	jalr	a5
ffffffffc02049dc:	6722                	ld	a4,8(sp)
ffffffffc02049de:	e91d                	bnez	a0,ffffffffc0204a14 <file_open+0xd0>
ffffffffc02049e0:	77e2                	ld	a5,56(sp)
ffffffffc02049e2:	f31c                	sd	a5,32(a4)
ffffffffc02049e4:	66e2                	ld	a3,24(sp)
ffffffffc02049e6:	431c                	lw	a5,0(a4)
ffffffffc02049e8:	01273423          	sd	s2,8(a4)
ffffffffc02049ec:	01373823          	sd	s3,16(a4)
ffffffffc02049f0:	f714                	sd	a3,40(a4)
ffffffffc02049f2:	17fd                	addi	a5,a5,-1
ffffffffc02049f4:	e3b9                	bnez	a5,ffffffffc0204a3a <file_open+0xf6>
ffffffffc02049f6:	c2b1                	beqz	a3,ffffffffc0204a3a <file_open+0xf6>
ffffffffc02049f8:	5b1c                	lw	a5,48(a4)
ffffffffc02049fa:	70a6                	ld	ra,104(sp)
ffffffffc02049fc:	7406                	ld	s0,96(sp)
ffffffffc02049fe:	2785                	addiw	a5,a5,1
ffffffffc0204a00:	db1c                	sw	a5,48(a4)
ffffffffc0204a02:	4f1c                	lw	a5,24(a4)
ffffffffc0204a04:	4689                	li	a3,2
ffffffffc0204a06:	c314                	sw	a3,0(a4)
ffffffffc0204a08:	64e6                	ld	s1,88(sp)
ffffffffc0204a0a:	6946                	ld	s2,80(sp)
ffffffffc0204a0c:	69a6                	ld	s3,72(sp)
ffffffffc0204a0e:	853e                	mv	a0,a5
ffffffffc0204a10:	6165                	addi	sp,sp,112
ffffffffc0204a12:	8082                	ret
ffffffffc0204a14:	e42a                	sd	a0,8(sp)
ffffffffc0204a16:	6562                	ld	a0,24(sp)
ffffffffc0204a18:	e03a                	sd	a4,0(sp)
ffffffffc0204a1a:	702030ef          	jal	ffffffffc020811c <vfs_close>
ffffffffc0204a1e:	6502                	ld	a0,0(sp)
ffffffffc0204a20:	cbbff0ef          	jal	ffffffffc02046da <fd_array_free>
ffffffffc0204a24:	67a2                	ld	a5,8(sp)
ffffffffc0204a26:	b79d                	j	ffffffffc020498c <file_open+0x48>
ffffffffc0204a28:	e02a                	sd	a0,0(sp)
ffffffffc0204a2a:	853a                	mv	a0,a4
ffffffffc0204a2c:	cafff0ef          	jal	ffffffffc02046da <fd_array_free>
ffffffffc0204a30:	6782                	ld	a5,0(sp)
ffffffffc0204a32:	bfa9                	j	ffffffffc020498c <file_open+0x48>
ffffffffc0204a34:	57f5                	li	a5,-3
ffffffffc0204a36:	853e                	mv	a0,a5
ffffffffc0204a38:	8082                	ret
ffffffffc0204a3a:	d83ff0ef          	jal	ffffffffc02047bc <fd_array_open.part.0>
ffffffffc0204a3e:	00008697          	auipc	a3,0x8
ffffffffc0204a42:	69268693          	addi	a3,a3,1682 # ffffffffc020d0d0 <etext+0x1ad6>
ffffffffc0204a46:	00007617          	auipc	a2,0x7
ffffffffc0204a4a:	ff260613          	addi	a2,a2,-14 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204a4e:	0b500593          	li	a1,181
ffffffffc0204a52:	00008517          	auipc	a0,0x8
ffffffffc0204a56:	54650513          	addi	a0,a0,1350 # ffffffffc020cf98 <etext+0x199e>
ffffffffc0204a5a:	9f1fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204a5e <file_close>:
ffffffffc0204a5e:	04700793          	li	a5,71
ffffffffc0204a62:	04a7e663          	bltu	a5,a0,ffffffffc0204aae <file_close+0x50>
ffffffffc0204a66:	00092717          	auipc	a4,0x92
ffffffffc0204a6a:	e6273703          	ld	a4,-414(a4) # ffffffffc02968c8 <current>
ffffffffc0204a6e:	1141                	addi	sp,sp,-16
ffffffffc0204a70:	e406                	sd	ra,8(sp)
ffffffffc0204a72:	14873703          	ld	a4,328(a4)
ffffffffc0204a76:	87aa                	mv	a5,a0
ffffffffc0204a78:	cf0d                	beqz	a4,ffffffffc0204ab2 <file_close+0x54>
ffffffffc0204a7a:	4b14                	lw	a3,16(a4)
ffffffffc0204a7c:	02d05b63          	blez	a3,ffffffffc0204ab2 <file_close+0x54>
ffffffffc0204a80:	6708                	ld	a0,8(a4)
ffffffffc0204a82:	00379713          	slli	a4,a5,0x3
ffffffffc0204a86:	8f1d                	sub	a4,a4,a5
ffffffffc0204a88:	070e                	slli	a4,a4,0x3
ffffffffc0204a8a:	953a                	add	a0,a0,a4
ffffffffc0204a8c:	4114                	lw	a3,0(a0)
ffffffffc0204a8e:	4709                	li	a4,2
ffffffffc0204a90:	00e69b63          	bne	a3,a4,ffffffffc0204aa6 <file_close+0x48>
ffffffffc0204a94:	4d18                	lw	a4,24(a0)
ffffffffc0204a96:	00f71863          	bne	a4,a5,ffffffffc0204aa6 <file_close+0x48>
ffffffffc0204a9a:	d63ff0ef          	jal	ffffffffc02047fc <fd_array_close>
ffffffffc0204a9e:	60a2                	ld	ra,8(sp)
ffffffffc0204aa0:	4501                	li	a0,0
ffffffffc0204aa2:	0141                	addi	sp,sp,16
ffffffffc0204aa4:	8082                	ret
ffffffffc0204aa6:	60a2                	ld	ra,8(sp)
ffffffffc0204aa8:	5575                	li	a0,-3
ffffffffc0204aaa:	0141                	addi	sp,sp,16
ffffffffc0204aac:	8082                	ret
ffffffffc0204aae:	5575                	li	a0,-3
ffffffffc0204ab0:	8082                	ret
ffffffffc0204ab2:	b75ff0ef          	jal	ffffffffc0204626 <get_fd_array.part.0>

ffffffffc0204ab6 <file_read>:
ffffffffc0204ab6:	711d                	addi	sp,sp,-96
ffffffffc0204ab8:	ec86                	sd	ra,88(sp)
ffffffffc0204aba:	e0ca                	sd	s2,64(sp)
ffffffffc0204abc:	0006b023          	sd	zero,0(a3)
ffffffffc0204ac0:	04700793          	li	a5,71
ffffffffc0204ac4:	0aa7ec63          	bltu	a5,a0,ffffffffc0204b7c <file_read+0xc6>
ffffffffc0204ac8:	00092797          	auipc	a5,0x92
ffffffffc0204acc:	e007b783          	ld	a5,-512(a5) # ffffffffc02968c8 <current>
ffffffffc0204ad0:	e4a6                	sd	s1,72(sp)
ffffffffc0204ad2:	e8a2                	sd	s0,80(sp)
ffffffffc0204ad4:	1487b783          	ld	a5,328(a5)
ffffffffc0204ad8:	fc4e                	sd	s3,56(sp)
ffffffffc0204ada:	84b6                	mv	s1,a3
ffffffffc0204adc:	c3f1                	beqz	a5,ffffffffc0204ba0 <file_read+0xea>
ffffffffc0204ade:	4b98                	lw	a4,16(a5)
ffffffffc0204ae0:	0ce05063          	blez	a4,ffffffffc0204ba0 <file_read+0xea>
ffffffffc0204ae4:	6780                	ld	s0,8(a5)
ffffffffc0204ae6:	00351793          	slli	a5,a0,0x3
ffffffffc0204aea:	8f89                	sub	a5,a5,a0
ffffffffc0204aec:	078e                	slli	a5,a5,0x3
ffffffffc0204aee:	943e                	add	s0,s0,a5
ffffffffc0204af0:	00042983          	lw	s3,0(s0)
ffffffffc0204af4:	4789                	li	a5,2
ffffffffc0204af6:	06f99a63          	bne	s3,a5,ffffffffc0204b6a <file_read+0xb4>
ffffffffc0204afa:	4c1c                	lw	a5,24(s0)
ffffffffc0204afc:	06a79763          	bne	a5,a0,ffffffffc0204b6a <file_read+0xb4>
ffffffffc0204b00:	641c                	ld	a5,8(s0)
ffffffffc0204b02:	c7a5                	beqz	a5,ffffffffc0204b6a <file_read+0xb4>
ffffffffc0204b04:	581c                	lw	a5,48(s0)
ffffffffc0204b06:	7014                	ld	a3,32(s0)
ffffffffc0204b08:	0808                	addi	a0,sp,16
ffffffffc0204b0a:	2785                	addiw	a5,a5,1
ffffffffc0204b0c:	d81c                	sw	a5,48(s0)
ffffffffc0204b0e:	7a0000ef          	jal	ffffffffc02052ae <iobuf_init>
ffffffffc0204b12:	892a                	mv	s2,a0
ffffffffc0204b14:	7408                	ld	a0,40(s0)
ffffffffc0204b16:	c52d                	beqz	a0,ffffffffc0204b80 <file_read+0xca>
ffffffffc0204b18:	793c                	ld	a5,112(a0)
ffffffffc0204b1a:	c3bd                	beqz	a5,ffffffffc0204b80 <file_read+0xca>
ffffffffc0204b1c:	6f9c                	ld	a5,24(a5)
ffffffffc0204b1e:	c3ad                	beqz	a5,ffffffffc0204b80 <file_read+0xca>
ffffffffc0204b20:	00008597          	auipc	a1,0x8
ffffffffc0204b24:	65858593          	addi	a1,a1,1624 # ffffffffc020d178 <etext+0x1b7e>
ffffffffc0204b28:	e42a                	sd	a0,8(sp)
ffffffffc0204b2a:	51b020ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc0204b2e:	6522                	ld	a0,8(sp)
ffffffffc0204b30:	85ca                	mv	a1,s2
ffffffffc0204b32:	793c                	ld	a5,112(a0)
ffffffffc0204b34:	7408                	ld	a0,40(s0)
ffffffffc0204b36:	6f9c                	ld	a5,24(a5)
ffffffffc0204b38:	9782                	jalr	a5
ffffffffc0204b3a:	01093783          	ld	a5,16(s2)
ffffffffc0204b3e:	01893683          	ld	a3,24(s2)
ffffffffc0204b42:	4018                	lw	a4,0(s0)
ffffffffc0204b44:	892a                	mv	s2,a0
ffffffffc0204b46:	8f95                	sub	a5,a5,a3
ffffffffc0204b48:	01371563          	bne	a4,s3,ffffffffc0204b52 <file_read+0x9c>
ffffffffc0204b4c:	7018                	ld	a4,32(s0)
ffffffffc0204b4e:	973e                	add	a4,a4,a5
ffffffffc0204b50:	f018                	sd	a4,32(s0)
ffffffffc0204b52:	e09c                	sd	a5,0(s1)
ffffffffc0204b54:	8522                	mv	a0,s0
ffffffffc0204b56:	bffff0ef          	jal	ffffffffc0204754 <fd_array_release>
ffffffffc0204b5a:	6446                	ld	s0,80(sp)
ffffffffc0204b5c:	64a6                	ld	s1,72(sp)
ffffffffc0204b5e:	79e2                	ld	s3,56(sp)
ffffffffc0204b60:	60e6                	ld	ra,88(sp)
ffffffffc0204b62:	854a                	mv	a0,s2
ffffffffc0204b64:	6906                	ld	s2,64(sp)
ffffffffc0204b66:	6125                	addi	sp,sp,96
ffffffffc0204b68:	8082                	ret
ffffffffc0204b6a:	6446                	ld	s0,80(sp)
ffffffffc0204b6c:	60e6                	ld	ra,88(sp)
ffffffffc0204b6e:	5975                	li	s2,-3
ffffffffc0204b70:	64a6                	ld	s1,72(sp)
ffffffffc0204b72:	79e2                	ld	s3,56(sp)
ffffffffc0204b74:	854a                	mv	a0,s2
ffffffffc0204b76:	6906                	ld	s2,64(sp)
ffffffffc0204b78:	6125                	addi	sp,sp,96
ffffffffc0204b7a:	8082                	ret
ffffffffc0204b7c:	5975                	li	s2,-3
ffffffffc0204b7e:	b7cd                	j	ffffffffc0204b60 <file_read+0xaa>
ffffffffc0204b80:	00008697          	auipc	a3,0x8
ffffffffc0204b84:	5a868693          	addi	a3,a3,1448 # ffffffffc020d128 <etext+0x1b2e>
ffffffffc0204b88:	00007617          	auipc	a2,0x7
ffffffffc0204b8c:	eb060613          	addi	a2,a2,-336 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204b90:	0de00593          	li	a1,222
ffffffffc0204b94:	00008517          	auipc	a0,0x8
ffffffffc0204b98:	40450513          	addi	a0,a0,1028 # ffffffffc020cf98 <etext+0x199e>
ffffffffc0204b9c:	8affb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204ba0:	a87ff0ef          	jal	ffffffffc0204626 <get_fd_array.part.0>

ffffffffc0204ba4 <file_write>:
ffffffffc0204ba4:	711d                	addi	sp,sp,-96
ffffffffc0204ba6:	ec86                	sd	ra,88(sp)
ffffffffc0204ba8:	e0ca                	sd	s2,64(sp)
ffffffffc0204baa:	0006b023          	sd	zero,0(a3)
ffffffffc0204bae:	04700793          	li	a5,71
ffffffffc0204bb2:	0aa7ec63          	bltu	a5,a0,ffffffffc0204c6a <file_write+0xc6>
ffffffffc0204bb6:	00092797          	auipc	a5,0x92
ffffffffc0204bba:	d127b783          	ld	a5,-750(a5) # ffffffffc02968c8 <current>
ffffffffc0204bbe:	e4a6                	sd	s1,72(sp)
ffffffffc0204bc0:	e8a2                	sd	s0,80(sp)
ffffffffc0204bc2:	1487b783          	ld	a5,328(a5)
ffffffffc0204bc6:	fc4e                	sd	s3,56(sp)
ffffffffc0204bc8:	84b6                	mv	s1,a3
ffffffffc0204bca:	c3f1                	beqz	a5,ffffffffc0204c8e <file_write+0xea>
ffffffffc0204bcc:	4b98                	lw	a4,16(a5)
ffffffffc0204bce:	0ce05063          	blez	a4,ffffffffc0204c8e <file_write+0xea>
ffffffffc0204bd2:	6780                	ld	s0,8(a5)
ffffffffc0204bd4:	00351793          	slli	a5,a0,0x3
ffffffffc0204bd8:	8f89                	sub	a5,a5,a0
ffffffffc0204bda:	078e                	slli	a5,a5,0x3
ffffffffc0204bdc:	943e                	add	s0,s0,a5
ffffffffc0204bde:	00042983          	lw	s3,0(s0)
ffffffffc0204be2:	4789                	li	a5,2
ffffffffc0204be4:	06f99a63          	bne	s3,a5,ffffffffc0204c58 <file_write+0xb4>
ffffffffc0204be8:	4c1c                	lw	a5,24(s0)
ffffffffc0204bea:	06a79763          	bne	a5,a0,ffffffffc0204c58 <file_write+0xb4>
ffffffffc0204bee:	681c                	ld	a5,16(s0)
ffffffffc0204bf0:	c7a5                	beqz	a5,ffffffffc0204c58 <file_write+0xb4>
ffffffffc0204bf2:	581c                	lw	a5,48(s0)
ffffffffc0204bf4:	7014                	ld	a3,32(s0)
ffffffffc0204bf6:	0808                	addi	a0,sp,16
ffffffffc0204bf8:	2785                	addiw	a5,a5,1
ffffffffc0204bfa:	d81c                	sw	a5,48(s0)
ffffffffc0204bfc:	6b2000ef          	jal	ffffffffc02052ae <iobuf_init>
ffffffffc0204c00:	892a                	mv	s2,a0
ffffffffc0204c02:	7408                	ld	a0,40(s0)
ffffffffc0204c04:	c52d                	beqz	a0,ffffffffc0204c6e <file_write+0xca>
ffffffffc0204c06:	793c                	ld	a5,112(a0)
ffffffffc0204c08:	c3bd                	beqz	a5,ffffffffc0204c6e <file_write+0xca>
ffffffffc0204c0a:	739c                	ld	a5,32(a5)
ffffffffc0204c0c:	c3ad                	beqz	a5,ffffffffc0204c6e <file_write+0xca>
ffffffffc0204c0e:	00008597          	auipc	a1,0x8
ffffffffc0204c12:	5c258593          	addi	a1,a1,1474 # ffffffffc020d1d0 <etext+0x1bd6>
ffffffffc0204c16:	e42a                	sd	a0,8(sp)
ffffffffc0204c18:	42d020ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc0204c1c:	6522                	ld	a0,8(sp)
ffffffffc0204c1e:	85ca                	mv	a1,s2
ffffffffc0204c20:	793c                	ld	a5,112(a0)
ffffffffc0204c22:	7408                	ld	a0,40(s0)
ffffffffc0204c24:	739c                	ld	a5,32(a5)
ffffffffc0204c26:	9782                	jalr	a5
ffffffffc0204c28:	01093783          	ld	a5,16(s2)
ffffffffc0204c2c:	01893683          	ld	a3,24(s2)
ffffffffc0204c30:	4018                	lw	a4,0(s0)
ffffffffc0204c32:	892a                	mv	s2,a0
ffffffffc0204c34:	8f95                	sub	a5,a5,a3
ffffffffc0204c36:	01371563          	bne	a4,s3,ffffffffc0204c40 <file_write+0x9c>
ffffffffc0204c3a:	7018                	ld	a4,32(s0)
ffffffffc0204c3c:	973e                	add	a4,a4,a5
ffffffffc0204c3e:	f018                	sd	a4,32(s0)
ffffffffc0204c40:	e09c                	sd	a5,0(s1)
ffffffffc0204c42:	8522                	mv	a0,s0
ffffffffc0204c44:	b11ff0ef          	jal	ffffffffc0204754 <fd_array_release>
ffffffffc0204c48:	6446                	ld	s0,80(sp)
ffffffffc0204c4a:	64a6                	ld	s1,72(sp)
ffffffffc0204c4c:	79e2                	ld	s3,56(sp)
ffffffffc0204c4e:	60e6                	ld	ra,88(sp)
ffffffffc0204c50:	854a                	mv	a0,s2
ffffffffc0204c52:	6906                	ld	s2,64(sp)
ffffffffc0204c54:	6125                	addi	sp,sp,96
ffffffffc0204c56:	8082                	ret
ffffffffc0204c58:	6446                	ld	s0,80(sp)
ffffffffc0204c5a:	60e6                	ld	ra,88(sp)
ffffffffc0204c5c:	5975                	li	s2,-3
ffffffffc0204c5e:	64a6                	ld	s1,72(sp)
ffffffffc0204c60:	79e2                	ld	s3,56(sp)
ffffffffc0204c62:	854a                	mv	a0,s2
ffffffffc0204c64:	6906                	ld	s2,64(sp)
ffffffffc0204c66:	6125                	addi	sp,sp,96
ffffffffc0204c68:	8082                	ret
ffffffffc0204c6a:	5975                	li	s2,-3
ffffffffc0204c6c:	b7cd                	j	ffffffffc0204c4e <file_write+0xaa>
ffffffffc0204c6e:	00008697          	auipc	a3,0x8
ffffffffc0204c72:	51268693          	addi	a3,a3,1298 # ffffffffc020d180 <etext+0x1b86>
ffffffffc0204c76:	00007617          	auipc	a2,0x7
ffffffffc0204c7a:	dc260613          	addi	a2,a2,-574 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204c7e:	0f800593          	li	a1,248
ffffffffc0204c82:	00008517          	auipc	a0,0x8
ffffffffc0204c86:	31650513          	addi	a0,a0,790 # ffffffffc020cf98 <etext+0x199e>
ffffffffc0204c8a:	fc0fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204c8e:	999ff0ef          	jal	ffffffffc0204626 <get_fd_array.part.0>

ffffffffc0204c92 <file_seek>:
ffffffffc0204c92:	7139                	addi	sp,sp,-64
ffffffffc0204c94:	fc06                	sd	ra,56(sp)
ffffffffc0204c96:	f426                	sd	s1,40(sp)
ffffffffc0204c98:	04700793          	li	a5,71
ffffffffc0204c9c:	0ca7e563          	bltu	a5,a0,ffffffffc0204d66 <file_seek+0xd4>
ffffffffc0204ca0:	00092797          	auipc	a5,0x92
ffffffffc0204ca4:	c287b783          	ld	a5,-984(a5) # ffffffffc02968c8 <current>
ffffffffc0204ca8:	f822                	sd	s0,48(sp)
ffffffffc0204caa:	1487b783          	ld	a5,328(a5)
ffffffffc0204cae:	c3e9                	beqz	a5,ffffffffc0204d70 <file_seek+0xde>
ffffffffc0204cb0:	4b98                	lw	a4,16(a5)
ffffffffc0204cb2:	0ae05f63          	blez	a4,ffffffffc0204d70 <file_seek+0xde>
ffffffffc0204cb6:	6780                	ld	s0,8(a5)
ffffffffc0204cb8:	00351793          	slli	a5,a0,0x3
ffffffffc0204cbc:	8f89                	sub	a5,a5,a0
ffffffffc0204cbe:	078e                	slli	a5,a5,0x3
ffffffffc0204cc0:	943e                	add	s0,s0,a5
ffffffffc0204cc2:	4018                	lw	a4,0(s0)
ffffffffc0204cc4:	4789                	li	a5,2
ffffffffc0204cc6:	0af71263          	bne	a4,a5,ffffffffc0204d6a <file_seek+0xd8>
ffffffffc0204cca:	4c1c                	lw	a5,24(s0)
ffffffffc0204ccc:	f04a                	sd	s2,32(sp)
ffffffffc0204cce:	08a79863          	bne	a5,a0,ffffffffc0204d5e <file_seek+0xcc>
ffffffffc0204cd2:	581c                	lw	a5,48(s0)
ffffffffc0204cd4:	4685                	li	a3,1
ffffffffc0204cd6:	892e                	mv	s2,a1
ffffffffc0204cd8:	2785                	addiw	a5,a5,1
ffffffffc0204cda:	d81c                	sw	a5,48(s0)
ffffffffc0204cdc:	06d60d63          	beq	a2,a3,ffffffffc0204d56 <file_seek+0xc4>
ffffffffc0204ce0:	04e60463          	beq	a2,a4,ffffffffc0204d28 <file_seek+0x96>
ffffffffc0204ce4:	54f5                	li	s1,-3
ffffffffc0204ce6:	e61d                	bnez	a2,ffffffffc0204d14 <file_seek+0x82>
ffffffffc0204ce8:	7404                	ld	s1,40(s0)
ffffffffc0204cea:	c4d1                	beqz	s1,ffffffffc0204d76 <file_seek+0xe4>
ffffffffc0204cec:	78bc                	ld	a5,112(s1)
ffffffffc0204cee:	c7c1                	beqz	a5,ffffffffc0204d76 <file_seek+0xe4>
ffffffffc0204cf0:	6fbc                	ld	a5,88(a5)
ffffffffc0204cf2:	c3d1                	beqz	a5,ffffffffc0204d76 <file_seek+0xe4>
ffffffffc0204cf4:	8526                	mv	a0,s1
ffffffffc0204cf6:	00008597          	auipc	a1,0x8
ffffffffc0204cfa:	53258593          	addi	a1,a1,1330 # ffffffffc020d228 <etext+0x1c2e>
ffffffffc0204cfe:	347020ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc0204d02:	78bc                	ld	a5,112(s1)
ffffffffc0204d04:	7408                	ld	a0,40(s0)
ffffffffc0204d06:	85ca                	mv	a1,s2
ffffffffc0204d08:	6fbc                	ld	a5,88(a5)
ffffffffc0204d0a:	9782                	jalr	a5
ffffffffc0204d0c:	84aa                	mv	s1,a0
ffffffffc0204d0e:	e119                	bnez	a0,ffffffffc0204d14 <file_seek+0x82>
ffffffffc0204d10:	03243023          	sd	s2,32(s0)
ffffffffc0204d14:	8522                	mv	a0,s0
ffffffffc0204d16:	a3fff0ef          	jal	ffffffffc0204754 <fd_array_release>
ffffffffc0204d1a:	7442                	ld	s0,48(sp)
ffffffffc0204d1c:	7902                	ld	s2,32(sp)
ffffffffc0204d1e:	70e2                	ld	ra,56(sp)
ffffffffc0204d20:	8526                	mv	a0,s1
ffffffffc0204d22:	74a2                	ld	s1,40(sp)
ffffffffc0204d24:	6121                	addi	sp,sp,64
ffffffffc0204d26:	8082                	ret
ffffffffc0204d28:	7404                	ld	s1,40(s0)
ffffffffc0204d2a:	c4b5                	beqz	s1,ffffffffc0204d96 <file_seek+0x104>
ffffffffc0204d2c:	78bc                	ld	a5,112(s1)
ffffffffc0204d2e:	c7a5                	beqz	a5,ffffffffc0204d96 <file_seek+0x104>
ffffffffc0204d30:	779c                	ld	a5,40(a5)
ffffffffc0204d32:	c3b5                	beqz	a5,ffffffffc0204d96 <file_seek+0x104>
ffffffffc0204d34:	8526                	mv	a0,s1
ffffffffc0204d36:	00008597          	auipc	a1,0x8
ffffffffc0204d3a:	3ea58593          	addi	a1,a1,1002 # ffffffffc020d120 <etext+0x1b26>
ffffffffc0204d3e:	307020ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc0204d42:	78bc                	ld	a5,112(s1)
ffffffffc0204d44:	7408                	ld	a0,40(s0)
ffffffffc0204d46:	858a                	mv	a1,sp
ffffffffc0204d48:	779c                	ld	a5,40(a5)
ffffffffc0204d4a:	9782                	jalr	a5
ffffffffc0204d4c:	84aa                	mv	s1,a0
ffffffffc0204d4e:	f179                	bnez	a0,ffffffffc0204d14 <file_seek+0x82>
ffffffffc0204d50:	67e2                	ld	a5,24(sp)
ffffffffc0204d52:	993e                	add	s2,s2,a5
ffffffffc0204d54:	bf51                	j	ffffffffc0204ce8 <file_seek+0x56>
ffffffffc0204d56:	701c                	ld	a5,32(s0)
ffffffffc0204d58:	00f58933          	add	s2,a1,a5
ffffffffc0204d5c:	b771                	j	ffffffffc0204ce8 <file_seek+0x56>
ffffffffc0204d5e:	7442                	ld	s0,48(sp)
ffffffffc0204d60:	7902                	ld	s2,32(sp)
ffffffffc0204d62:	54f5                	li	s1,-3
ffffffffc0204d64:	bf6d                	j	ffffffffc0204d1e <file_seek+0x8c>
ffffffffc0204d66:	54f5                	li	s1,-3
ffffffffc0204d68:	bf5d                	j	ffffffffc0204d1e <file_seek+0x8c>
ffffffffc0204d6a:	7442                	ld	s0,48(sp)
ffffffffc0204d6c:	54f5                	li	s1,-3
ffffffffc0204d6e:	bf45                	j	ffffffffc0204d1e <file_seek+0x8c>
ffffffffc0204d70:	f04a                	sd	s2,32(sp)
ffffffffc0204d72:	8b5ff0ef          	jal	ffffffffc0204626 <get_fd_array.part.0>
ffffffffc0204d76:	00008697          	auipc	a3,0x8
ffffffffc0204d7a:	46268693          	addi	a3,a3,1122 # ffffffffc020d1d8 <etext+0x1bde>
ffffffffc0204d7e:	00007617          	auipc	a2,0x7
ffffffffc0204d82:	cba60613          	addi	a2,a2,-838 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204d86:	11a00593          	li	a1,282
ffffffffc0204d8a:	00008517          	auipc	a0,0x8
ffffffffc0204d8e:	20e50513          	addi	a0,a0,526 # ffffffffc020cf98 <etext+0x199e>
ffffffffc0204d92:	eb8fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204d96:	00008697          	auipc	a3,0x8
ffffffffc0204d9a:	33a68693          	addi	a3,a3,826 # ffffffffc020d0d0 <etext+0x1ad6>
ffffffffc0204d9e:	00007617          	auipc	a2,0x7
ffffffffc0204da2:	c9a60613          	addi	a2,a2,-870 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204da6:	11200593          	li	a1,274
ffffffffc0204daa:	00008517          	auipc	a0,0x8
ffffffffc0204dae:	1ee50513          	addi	a0,a0,494 # ffffffffc020cf98 <etext+0x199e>
ffffffffc0204db2:	e98fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204db6 <file_fstat>:
ffffffffc0204db6:	7179                	addi	sp,sp,-48
ffffffffc0204db8:	f406                	sd	ra,40(sp)
ffffffffc0204dba:	f022                	sd	s0,32(sp)
ffffffffc0204dbc:	04700793          	li	a5,71
ffffffffc0204dc0:	08a7e363          	bltu	a5,a0,ffffffffc0204e46 <file_fstat+0x90>
ffffffffc0204dc4:	00092797          	auipc	a5,0x92
ffffffffc0204dc8:	b047b783          	ld	a5,-1276(a5) # ffffffffc02968c8 <current>
ffffffffc0204dcc:	ec26                	sd	s1,24(sp)
ffffffffc0204dce:	84ae                	mv	s1,a1
ffffffffc0204dd0:	1487b783          	ld	a5,328(a5)
ffffffffc0204dd4:	cbd9                	beqz	a5,ffffffffc0204e6a <file_fstat+0xb4>
ffffffffc0204dd6:	4b98                	lw	a4,16(a5)
ffffffffc0204dd8:	08e05963          	blez	a4,ffffffffc0204e6a <file_fstat+0xb4>
ffffffffc0204ddc:	6780                	ld	s0,8(a5)
ffffffffc0204dde:	00351793          	slli	a5,a0,0x3
ffffffffc0204de2:	8f89                	sub	a5,a5,a0
ffffffffc0204de4:	078e                	slli	a5,a5,0x3
ffffffffc0204de6:	943e                	add	s0,s0,a5
ffffffffc0204de8:	4018                	lw	a4,0(s0)
ffffffffc0204dea:	4789                	li	a5,2
ffffffffc0204dec:	04f71663          	bne	a4,a5,ffffffffc0204e38 <file_fstat+0x82>
ffffffffc0204df0:	4c1c                	lw	a5,24(s0)
ffffffffc0204df2:	04a79363          	bne	a5,a0,ffffffffc0204e38 <file_fstat+0x82>
ffffffffc0204df6:	581c                	lw	a5,48(s0)
ffffffffc0204df8:	7408                	ld	a0,40(s0)
ffffffffc0204dfa:	2785                	addiw	a5,a5,1
ffffffffc0204dfc:	d81c                	sw	a5,48(s0)
ffffffffc0204dfe:	c531                	beqz	a0,ffffffffc0204e4a <file_fstat+0x94>
ffffffffc0204e00:	793c                	ld	a5,112(a0)
ffffffffc0204e02:	c7a1                	beqz	a5,ffffffffc0204e4a <file_fstat+0x94>
ffffffffc0204e04:	779c                	ld	a5,40(a5)
ffffffffc0204e06:	c3b1                	beqz	a5,ffffffffc0204e4a <file_fstat+0x94>
ffffffffc0204e08:	00008597          	auipc	a1,0x8
ffffffffc0204e0c:	31858593          	addi	a1,a1,792 # ffffffffc020d120 <etext+0x1b26>
ffffffffc0204e10:	e42a                	sd	a0,8(sp)
ffffffffc0204e12:	233020ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc0204e16:	6522                	ld	a0,8(sp)
ffffffffc0204e18:	85a6                	mv	a1,s1
ffffffffc0204e1a:	793c                	ld	a5,112(a0)
ffffffffc0204e1c:	7408                	ld	a0,40(s0)
ffffffffc0204e1e:	779c                	ld	a5,40(a5)
ffffffffc0204e20:	9782                	jalr	a5
ffffffffc0204e22:	87aa                	mv	a5,a0
ffffffffc0204e24:	8522                	mv	a0,s0
ffffffffc0204e26:	843e                	mv	s0,a5
ffffffffc0204e28:	92dff0ef          	jal	ffffffffc0204754 <fd_array_release>
ffffffffc0204e2c:	64e2                	ld	s1,24(sp)
ffffffffc0204e2e:	70a2                	ld	ra,40(sp)
ffffffffc0204e30:	8522                	mv	a0,s0
ffffffffc0204e32:	7402                	ld	s0,32(sp)
ffffffffc0204e34:	6145                	addi	sp,sp,48
ffffffffc0204e36:	8082                	ret
ffffffffc0204e38:	5475                	li	s0,-3
ffffffffc0204e3a:	70a2                	ld	ra,40(sp)
ffffffffc0204e3c:	8522                	mv	a0,s0
ffffffffc0204e3e:	7402                	ld	s0,32(sp)
ffffffffc0204e40:	64e2                	ld	s1,24(sp)
ffffffffc0204e42:	6145                	addi	sp,sp,48
ffffffffc0204e44:	8082                	ret
ffffffffc0204e46:	5475                	li	s0,-3
ffffffffc0204e48:	b7dd                	j	ffffffffc0204e2e <file_fstat+0x78>
ffffffffc0204e4a:	00008697          	auipc	a3,0x8
ffffffffc0204e4e:	28668693          	addi	a3,a3,646 # ffffffffc020d0d0 <etext+0x1ad6>
ffffffffc0204e52:	00007617          	auipc	a2,0x7
ffffffffc0204e56:	be660613          	addi	a2,a2,-1050 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204e5a:	12c00593          	li	a1,300
ffffffffc0204e5e:	00008517          	auipc	a0,0x8
ffffffffc0204e62:	13a50513          	addi	a0,a0,314 # ffffffffc020cf98 <etext+0x199e>
ffffffffc0204e66:	de4fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204e6a:	fbcff0ef          	jal	ffffffffc0204626 <get_fd_array.part.0>

ffffffffc0204e6e <file_fsync>:
ffffffffc0204e6e:	1101                	addi	sp,sp,-32
ffffffffc0204e70:	ec06                	sd	ra,24(sp)
ffffffffc0204e72:	e822                	sd	s0,16(sp)
ffffffffc0204e74:	04700793          	li	a5,71
ffffffffc0204e78:	06a7e863          	bltu	a5,a0,ffffffffc0204ee8 <file_fsync+0x7a>
ffffffffc0204e7c:	00092797          	auipc	a5,0x92
ffffffffc0204e80:	a4c7b783          	ld	a5,-1460(a5) # ffffffffc02968c8 <current>
ffffffffc0204e84:	1487b783          	ld	a5,328(a5)
ffffffffc0204e88:	c7d1                	beqz	a5,ffffffffc0204f14 <file_fsync+0xa6>
ffffffffc0204e8a:	4b98                	lw	a4,16(a5)
ffffffffc0204e8c:	08e05463          	blez	a4,ffffffffc0204f14 <file_fsync+0xa6>
ffffffffc0204e90:	6780                	ld	s0,8(a5)
ffffffffc0204e92:	00351793          	slli	a5,a0,0x3
ffffffffc0204e96:	8f89                	sub	a5,a5,a0
ffffffffc0204e98:	078e                	slli	a5,a5,0x3
ffffffffc0204e9a:	943e                	add	s0,s0,a5
ffffffffc0204e9c:	4018                	lw	a4,0(s0)
ffffffffc0204e9e:	4789                	li	a5,2
ffffffffc0204ea0:	04f71463          	bne	a4,a5,ffffffffc0204ee8 <file_fsync+0x7a>
ffffffffc0204ea4:	4c1c                	lw	a5,24(s0)
ffffffffc0204ea6:	04a79163          	bne	a5,a0,ffffffffc0204ee8 <file_fsync+0x7a>
ffffffffc0204eaa:	581c                	lw	a5,48(s0)
ffffffffc0204eac:	7408                	ld	a0,40(s0)
ffffffffc0204eae:	2785                	addiw	a5,a5,1
ffffffffc0204eb0:	d81c                	sw	a5,48(s0)
ffffffffc0204eb2:	c129                	beqz	a0,ffffffffc0204ef4 <file_fsync+0x86>
ffffffffc0204eb4:	793c                	ld	a5,112(a0)
ffffffffc0204eb6:	cf9d                	beqz	a5,ffffffffc0204ef4 <file_fsync+0x86>
ffffffffc0204eb8:	7b9c                	ld	a5,48(a5)
ffffffffc0204eba:	cf8d                	beqz	a5,ffffffffc0204ef4 <file_fsync+0x86>
ffffffffc0204ebc:	00008597          	auipc	a1,0x8
ffffffffc0204ec0:	3c458593          	addi	a1,a1,964 # ffffffffc020d280 <etext+0x1c86>
ffffffffc0204ec4:	e42a                	sd	a0,8(sp)
ffffffffc0204ec6:	17f020ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc0204eca:	6522                	ld	a0,8(sp)
ffffffffc0204ecc:	793c                	ld	a5,112(a0)
ffffffffc0204ece:	7408                	ld	a0,40(s0)
ffffffffc0204ed0:	7b9c                	ld	a5,48(a5)
ffffffffc0204ed2:	9782                	jalr	a5
ffffffffc0204ed4:	87aa                	mv	a5,a0
ffffffffc0204ed6:	8522                	mv	a0,s0
ffffffffc0204ed8:	843e                	mv	s0,a5
ffffffffc0204eda:	87bff0ef          	jal	ffffffffc0204754 <fd_array_release>
ffffffffc0204ede:	60e2                	ld	ra,24(sp)
ffffffffc0204ee0:	8522                	mv	a0,s0
ffffffffc0204ee2:	6442                	ld	s0,16(sp)
ffffffffc0204ee4:	6105                	addi	sp,sp,32
ffffffffc0204ee6:	8082                	ret
ffffffffc0204ee8:	5475                	li	s0,-3
ffffffffc0204eea:	60e2                	ld	ra,24(sp)
ffffffffc0204eec:	8522                	mv	a0,s0
ffffffffc0204eee:	6442                	ld	s0,16(sp)
ffffffffc0204ef0:	6105                	addi	sp,sp,32
ffffffffc0204ef2:	8082                	ret
ffffffffc0204ef4:	00008697          	auipc	a3,0x8
ffffffffc0204ef8:	33c68693          	addi	a3,a3,828 # ffffffffc020d230 <etext+0x1c36>
ffffffffc0204efc:	00007617          	auipc	a2,0x7
ffffffffc0204f00:	b3c60613          	addi	a2,a2,-1220 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204f04:	13a00593          	li	a1,314
ffffffffc0204f08:	00008517          	auipc	a0,0x8
ffffffffc0204f0c:	09050513          	addi	a0,a0,144 # ffffffffc020cf98 <etext+0x199e>
ffffffffc0204f10:	d3afb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204f14:	f12ff0ef          	jal	ffffffffc0204626 <get_fd_array.part.0>

ffffffffc0204f18 <file_getdirentry>:
ffffffffc0204f18:	715d                	addi	sp,sp,-80
ffffffffc0204f1a:	e486                	sd	ra,72(sp)
ffffffffc0204f1c:	f84a                	sd	s2,48(sp)
ffffffffc0204f1e:	04700793          	li	a5,71
ffffffffc0204f22:	0aa7e963          	bltu	a5,a0,ffffffffc0204fd4 <file_getdirentry+0xbc>
ffffffffc0204f26:	00092797          	auipc	a5,0x92
ffffffffc0204f2a:	9a27b783          	ld	a5,-1630(a5) # ffffffffc02968c8 <current>
ffffffffc0204f2e:	fc26                	sd	s1,56(sp)
ffffffffc0204f30:	e0a2                	sd	s0,64(sp)
ffffffffc0204f32:	1487b783          	ld	a5,328(a5)
ffffffffc0204f36:	84ae                	mv	s1,a1
ffffffffc0204f38:	c7e1                	beqz	a5,ffffffffc0205000 <file_getdirentry+0xe8>
ffffffffc0204f3a:	4b98                	lw	a4,16(a5)
ffffffffc0204f3c:	0ce05263          	blez	a4,ffffffffc0205000 <file_getdirentry+0xe8>
ffffffffc0204f40:	6780                	ld	s0,8(a5)
ffffffffc0204f42:	00351793          	slli	a5,a0,0x3
ffffffffc0204f46:	8f89                	sub	a5,a5,a0
ffffffffc0204f48:	078e                	slli	a5,a5,0x3
ffffffffc0204f4a:	943e                	add	s0,s0,a5
ffffffffc0204f4c:	4018                	lw	a4,0(s0)
ffffffffc0204f4e:	4789                	li	a5,2
ffffffffc0204f50:	08f71463          	bne	a4,a5,ffffffffc0204fd8 <file_getdirentry+0xc0>
ffffffffc0204f54:	4c1c                	lw	a5,24(s0)
ffffffffc0204f56:	f44e                	sd	s3,40(sp)
ffffffffc0204f58:	06a79963          	bne	a5,a0,ffffffffc0204fca <file_getdirentry+0xb2>
ffffffffc0204f5c:	581c                	lw	a5,48(s0)
ffffffffc0204f5e:	6194                	ld	a3,0(a1)
ffffffffc0204f60:	10000613          	li	a2,256
ffffffffc0204f64:	2785                	addiw	a5,a5,1
ffffffffc0204f66:	d81c                	sw	a5,48(s0)
ffffffffc0204f68:	05a1                	addi	a1,a1,8
ffffffffc0204f6a:	850a                	mv	a0,sp
ffffffffc0204f6c:	342000ef          	jal	ffffffffc02052ae <iobuf_init>
ffffffffc0204f70:	02843903          	ld	s2,40(s0)
ffffffffc0204f74:	89aa                	mv	s3,a0
ffffffffc0204f76:	06090563          	beqz	s2,ffffffffc0204fe0 <file_getdirentry+0xc8>
ffffffffc0204f7a:	07093783          	ld	a5,112(s2)
ffffffffc0204f7e:	c3ad                	beqz	a5,ffffffffc0204fe0 <file_getdirentry+0xc8>
ffffffffc0204f80:	63bc                	ld	a5,64(a5)
ffffffffc0204f82:	cfb9                	beqz	a5,ffffffffc0204fe0 <file_getdirentry+0xc8>
ffffffffc0204f84:	854a                	mv	a0,s2
ffffffffc0204f86:	00008597          	auipc	a1,0x8
ffffffffc0204f8a:	35a58593          	addi	a1,a1,858 # ffffffffc020d2e0 <etext+0x1ce6>
ffffffffc0204f8e:	0b7020ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc0204f92:	07093783          	ld	a5,112(s2)
ffffffffc0204f96:	7408                	ld	a0,40(s0)
ffffffffc0204f98:	85ce                	mv	a1,s3
ffffffffc0204f9a:	63bc                	ld	a5,64(a5)
ffffffffc0204f9c:	9782                	jalr	a5
ffffffffc0204f9e:	892a                	mv	s2,a0
ffffffffc0204fa0:	cd01                	beqz	a0,ffffffffc0204fb8 <file_getdirentry+0xa0>
ffffffffc0204fa2:	8522                	mv	a0,s0
ffffffffc0204fa4:	fb0ff0ef          	jal	ffffffffc0204754 <fd_array_release>
ffffffffc0204fa8:	6406                	ld	s0,64(sp)
ffffffffc0204faa:	74e2                	ld	s1,56(sp)
ffffffffc0204fac:	79a2                	ld	s3,40(sp)
ffffffffc0204fae:	60a6                	ld	ra,72(sp)
ffffffffc0204fb0:	854a                	mv	a0,s2
ffffffffc0204fb2:	7942                	ld	s2,48(sp)
ffffffffc0204fb4:	6161                	addi	sp,sp,80
ffffffffc0204fb6:	8082                	ret
ffffffffc0204fb8:	609c                	ld	a5,0(s1)
ffffffffc0204fba:	0109b683          	ld	a3,16(s3)
ffffffffc0204fbe:	0189b703          	ld	a4,24(s3)
ffffffffc0204fc2:	97b6                	add	a5,a5,a3
ffffffffc0204fc4:	8f99                	sub	a5,a5,a4
ffffffffc0204fc6:	e09c                	sd	a5,0(s1)
ffffffffc0204fc8:	bfe9                	j	ffffffffc0204fa2 <file_getdirentry+0x8a>
ffffffffc0204fca:	6406                	ld	s0,64(sp)
ffffffffc0204fcc:	74e2                	ld	s1,56(sp)
ffffffffc0204fce:	79a2                	ld	s3,40(sp)
ffffffffc0204fd0:	5975                	li	s2,-3
ffffffffc0204fd2:	bff1                	j	ffffffffc0204fae <file_getdirentry+0x96>
ffffffffc0204fd4:	5975                	li	s2,-3
ffffffffc0204fd6:	bfe1                	j	ffffffffc0204fae <file_getdirentry+0x96>
ffffffffc0204fd8:	6406                	ld	s0,64(sp)
ffffffffc0204fda:	74e2                	ld	s1,56(sp)
ffffffffc0204fdc:	5975                	li	s2,-3
ffffffffc0204fde:	bfc1                	j	ffffffffc0204fae <file_getdirentry+0x96>
ffffffffc0204fe0:	00008697          	auipc	a3,0x8
ffffffffc0204fe4:	2a868693          	addi	a3,a3,680 # ffffffffc020d288 <etext+0x1c8e>
ffffffffc0204fe8:	00007617          	auipc	a2,0x7
ffffffffc0204fec:	a5060613          	addi	a2,a2,-1456 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0204ff0:	14a00593          	li	a1,330
ffffffffc0204ff4:	00008517          	auipc	a0,0x8
ffffffffc0204ff8:	fa450513          	addi	a0,a0,-92 # ffffffffc020cf98 <etext+0x199e>
ffffffffc0204ffc:	c4efb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205000:	f44e                	sd	s3,40(sp)
ffffffffc0205002:	e24ff0ef          	jal	ffffffffc0204626 <get_fd_array.part.0>

ffffffffc0205006 <file_dup>:
ffffffffc0205006:	04700713          	li	a4,71
ffffffffc020500a:	06a76263          	bltu	a4,a0,ffffffffc020506e <file_dup+0x68>
ffffffffc020500e:	00092717          	auipc	a4,0x92
ffffffffc0205012:	8ba73703          	ld	a4,-1862(a4) # ffffffffc02968c8 <current>
ffffffffc0205016:	7179                	addi	sp,sp,-48
ffffffffc0205018:	f406                	sd	ra,40(sp)
ffffffffc020501a:	14873703          	ld	a4,328(a4)
ffffffffc020501e:	f022                	sd	s0,32(sp)
ffffffffc0205020:	87aa                	mv	a5,a0
ffffffffc0205022:	852e                	mv	a0,a1
ffffffffc0205024:	c739                	beqz	a4,ffffffffc0205072 <file_dup+0x6c>
ffffffffc0205026:	4b14                	lw	a3,16(a4)
ffffffffc0205028:	04d05563          	blez	a3,ffffffffc0205072 <file_dup+0x6c>
ffffffffc020502c:	6700                	ld	s0,8(a4)
ffffffffc020502e:	00379713          	slli	a4,a5,0x3
ffffffffc0205032:	8f1d                	sub	a4,a4,a5
ffffffffc0205034:	070e                	slli	a4,a4,0x3
ffffffffc0205036:	943a                	add	s0,s0,a4
ffffffffc0205038:	4014                	lw	a3,0(s0)
ffffffffc020503a:	4709                	li	a4,2
ffffffffc020503c:	02e69463          	bne	a3,a4,ffffffffc0205064 <file_dup+0x5e>
ffffffffc0205040:	4c18                	lw	a4,24(s0)
ffffffffc0205042:	02f71163          	bne	a4,a5,ffffffffc0205064 <file_dup+0x5e>
ffffffffc0205046:	082c                	addi	a1,sp,24
ffffffffc0205048:	e00ff0ef          	jal	ffffffffc0204648 <fd_array_alloc>
ffffffffc020504c:	e901                	bnez	a0,ffffffffc020505c <file_dup+0x56>
ffffffffc020504e:	6562                	ld	a0,24(sp)
ffffffffc0205050:	85a2                	mv	a1,s0
ffffffffc0205052:	e42a                	sd	a0,8(sp)
ffffffffc0205054:	821ff0ef          	jal	ffffffffc0204874 <fd_array_dup>
ffffffffc0205058:	6522                	ld	a0,8(sp)
ffffffffc020505a:	4d08                	lw	a0,24(a0)
ffffffffc020505c:	70a2                	ld	ra,40(sp)
ffffffffc020505e:	7402                	ld	s0,32(sp)
ffffffffc0205060:	6145                	addi	sp,sp,48
ffffffffc0205062:	8082                	ret
ffffffffc0205064:	70a2                	ld	ra,40(sp)
ffffffffc0205066:	7402                	ld	s0,32(sp)
ffffffffc0205068:	5575                	li	a0,-3
ffffffffc020506a:	6145                	addi	sp,sp,48
ffffffffc020506c:	8082                	ret
ffffffffc020506e:	5575                	li	a0,-3
ffffffffc0205070:	8082                	ret
ffffffffc0205072:	db4ff0ef          	jal	ffffffffc0204626 <get_fd_array.part.0>

ffffffffc0205076 <fs_init>:
ffffffffc0205076:	1141                	addi	sp,sp,-16
ffffffffc0205078:	e406                	sd	ra,8(sp)
ffffffffc020507a:	1d5020ef          	jal	ffffffffc0207a4e <vfs_init>
ffffffffc020507e:	6e2030ef          	jal	ffffffffc0208760 <dev_init>
ffffffffc0205082:	60a2                	ld	ra,8(sp)
ffffffffc0205084:	0141                	addi	sp,sp,16
ffffffffc0205086:	0560406f          	j	ffffffffc02090dc <sfs_init>

ffffffffc020508a <fs_cleanup>:
ffffffffc020508a:	4410206f          	j	ffffffffc0207cca <vfs_cleanup>

ffffffffc020508e <lock_files>:
ffffffffc020508e:	0561                	addi	a0,a0,24
ffffffffc0205090:	b88ff06f          	j	ffffffffc0204418 <down>

ffffffffc0205094 <unlock_files>:
ffffffffc0205094:	0561                	addi	a0,a0,24
ffffffffc0205096:	b7eff06f          	j	ffffffffc0204414 <up>

ffffffffc020509a <files_create>:
ffffffffc020509a:	1141                	addi	sp,sp,-16
ffffffffc020509c:	6505                	lui	a0,0x1
ffffffffc020509e:	e022                	sd	s0,0(sp)
ffffffffc02050a0:	e406                	sd	ra,8(sp)
ffffffffc02050a2:	faffc0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc02050a6:	842a                	mv	s0,a0
ffffffffc02050a8:	cd19                	beqz	a0,ffffffffc02050c6 <files_create+0x2c>
ffffffffc02050aa:	03050793          	addi	a5,a0,48 # 1030 <_binary_bin_swap_img_size-0x6cd0>
ffffffffc02050ae:	e51c                	sd	a5,8(a0)
ffffffffc02050b0:	00053023          	sd	zero,0(a0)
ffffffffc02050b4:	00052823          	sw	zero,16(a0)
ffffffffc02050b8:	4585                	li	a1,1
ffffffffc02050ba:	0561                	addi	a0,a0,24
ffffffffc02050bc:	b52ff0ef          	jal	ffffffffc020440e <sem_init>
ffffffffc02050c0:	6408                	ld	a0,8(s0)
ffffffffc02050c2:	f1eff0ef          	jal	ffffffffc02047e0 <fd_array_init>
ffffffffc02050c6:	60a2                	ld	ra,8(sp)
ffffffffc02050c8:	8522                	mv	a0,s0
ffffffffc02050ca:	6402                	ld	s0,0(sp)
ffffffffc02050cc:	0141                	addi	sp,sp,16
ffffffffc02050ce:	8082                	ret

ffffffffc02050d0 <files_destroy>:
ffffffffc02050d0:	7179                	addi	sp,sp,-48
ffffffffc02050d2:	f406                	sd	ra,40(sp)
ffffffffc02050d4:	f022                	sd	s0,32(sp)
ffffffffc02050d6:	ec26                	sd	s1,24(sp)
ffffffffc02050d8:	e84a                	sd	s2,16(sp)
ffffffffc02050da:	e44e                	sd	s3,8(sp)
ffffffffc02050dc:	c52d                	beqz	a0,ffffffffc0205146 <files_destroy+0x76>
ffffffffc02050de:	491c                	lw	a5,16(a0)
ffffffffc02050e0:	89aa                	mv	s3,a0
ffffffffc02050e2:	e3b5                	bnez	a5,ffffffffc0205146 <files_destroy+0x76>
ffffffffc02050e4:	6108                	ld	a0,0(a0)
ffffffffc02050e6:	c119                	beqz	a0,ffffffffc02050ec <files_destroy+0x1c>
ffffffffc02050e8:	017020ef          	jal	ffffffffc02078fe <inode_ref_dec>
ffffffffc02050ec:	0089b403          	ld	s0,8(s3)
ffffffffc02050f0:	4909                	li	s2,2
ffffffffc02050f2:	7ff40493          	addi	s1,s0,2047
ffffffffc02050f6:	7c148493          	addi	s1,s1,1985
ffffffffc02050fa:	401c                	lw	a5,0(s0)
ffffffffc02050fc:	03278063          	beq	a5,s2,ffffffffc020511c <files_destroy+0x4c>
ffffffffc0205100:	e39d                	bnez	a5,ffffffffc0205126 <files_destroy+0x56>
ffffffffc0205102:	03840413          	addi	s0,s0,56
ffffffffc0205106:	fe941ae3          	bne	s0,s1,ffffffffc02050fa <files_destroy+0x2a>
ffffffffc020510a:	7402                	ld	s0,32(sp)
ffffffffc020510c:	70a2                	ld	ra,40(sp)
ffffffffc020510e:	64e2                	ld	s1,24(sp)
ffffffffc0205110:	6942                	ld	s2,16(sp)
ffffffffc0205112:	854e                	mv	a0,s3
ffffffffc0205114:	69a2                	ld	s3,8(sp)
ffffffffc0205116:	6145                	addi	sp,sp,48
ffffffffc0205118:	fdffc06f          	j	ffffffffc02020f6 <kfree>
ffffffffc020511c:	8522                	mv	a0,s0
ffffffffc020511e:	edeff0ef          	jal	ffffffffc02047fc <fd_array_close>
ffffffffc0205122:	401c                	lw	a5,0(s0)
ffffffffc0205124:	bff1                	j	ffffffffc0205100 <files_destroy+0x30>
ffffffffc0205126:	00008697          	auipc	a3,0x8
ffffffffc020512a:	20a68693          	addi	a3,a3,522 # ffffffffc020d330 <etext+0x1d36>
ffffffffc020512e:	00007617          	auipc	a2,0x7
ffffffffc0205132:	90a60613          	addi	a2,a2,-1782 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0205136:	03d00593          	li	a1,61
ffffffffc020513a:	00008517          	auipc	a0,0x8
ffffffffc020513e:	1e650513          	addi	a0,a0,486 # ffffffffc020d320 <etext+0x1d26>
ffffffffc0205142:	b08fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205146:	00008697          	auipc	a3,0x8
ffffffffc020514a:	1aa68693          	addi	a3,a3,426 # ffffffffc020d2f0 <etext+0x1cf6>
ffffffffc020514e:	00007617          	auipc	a2,0x7
ffffffffc0205152:	8ea60613          	addi	a2,a2,-1814 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0205156:	03300593          	li	a1,51
ffffffffc020515a:	00008517          	auipc	a0,0x8
ffffffffc020515e:	1c650513          	addi	a0,a0,454 # ffffffffc020d320 <etext+0x1d26>
ffffffffc0205162:	ae8fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205166 <files_closeall>:
ffffffffc0205166:	1101                	addi	sp,sp,-32
ffffffffc0205168:	ec06                	sd	ra,24(sp)
ffffffffc020516a:	e822                	sd	s0,16(sp)
ffffffffc020516c:	e426                	sd	s1,8(sp)
ffffffffc020516e:	e04a                	sd	s2,0(sp)
ffffffffc0205170:	c129                	beqz	a0,ffffffffc02051b2 <files_closeall+0x4c>
ffffffffc0205172:	491c                	lw	a5,16(a0)
ffffffffc0205174:	02f05f63          	blez	a5,ffffffffc02051b2 <files_closeall+0x4c>
ffffffffc0205178:	6500                	ld	s0,8(a0)
ffffffffc020517a:	4909                	li	s2,2
ffffffffc020517c:	7ff40493          	addi	s1,s0,2047
ffffffffc0205180:	7c148493          	addi	s1,s1,1985
ffffffffc0205184:	07040413          	addi	s0,s0,112
ffffffffc0205188:	a029                	j	ffffffffc0205192 <files_closeall+0x2c>
ffffffffc020518a:	03840413          	addi	s0,s0,56
ffffffffc020518e:	00940c63          	beq	s0,s1,ffffffffc02051a6 <files_closeall+0x40>
ffffffffc0205192:	401c                	lw	a5,0(s0)
ffffffffc0205194:	ff279be3          	bne	a5,s2,ffffffffc020518a <files_closeall+0x24>
ffffffffc0205198:	8522                	mv	a0,s0
ffffffffc020519a:	03840413          	addi	s0,s0,56
ffffffffc020519e:	e5eff0ef          	jal	ffffffffc02047fc <fd_array_close>
ffffffffc02051a2:	fe9418e3          	bne	s0,s1,ffffffffc0205192 <files_closeall+0x2c>
ffffffffc02051a6:	60e2                	ld	ra,24(sp)
ffffffffc02051a8:	6442                	ld	s0,16(sp)
ffffffffc02051aa:	64a2                	ld	s1,8(sp)
ffffffffc02051ac:	6902                	ld	s2,0(sp)
ffffffffc02051ae:	6105                	addi	sp,sp,32
ffffffffc02051b0:	8082                	ret
ffffffffc02051b2:	00008697          	auipc	a3,0x8
ffffffffc02051b6:	db668693          	addi	a3,a3,-586 # ffffffffc020cf68 <etext+0x196e>
ffffffffc02051ba:	00007617          	auipc	a2,0x7
ffffffffc02051be:	87e60613          	addi	a2,a2,-1922 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02051c2:	04500593          	li	a1,69
ffffffffc02051c6:	00008517          	auipc	a0,0x8
ffffffffc02051ca:	15a50513          	addi	a0,a0,346 # ffffffffc020d320 <etext+0x1d26>
ffffffffc02051ce:	a7cfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02051d2 <dup_files>:
ffffffffc02051d2:	7179                	addi	sp,sp,-48
ffffffffc02051d4:	f406                	sd	ra,40(sp)
ffffffffc02051d6:	f022                	sd	s0,32(sp)
ffffffffc02051d8:	ec26                	sd	s1,24(sp)
ffffffffc02051da:	e84a                	sd	s2,16(sp)
ffffffffc02051dc:	e44e                	sd	s3,8(sp)
ffffffffc02051de:	e052                	sd	s4,0(sp)
ffffffffc02051e0:	c52d                	beqz	a0,ffffffffc020524a <dup_files+0x78>
ffffffffc02051e2:	842e                	mv	s0,a1
ffffffffc02051e4:	c1bd                	beqz	a1,ffffffffc020524a <dup_files+0x78>
ffffffffc02051e6:	491c                	lw	a5,16(a0)
ffffffffc02051e8:	84aa                	mv	s1,a0
ffffffffc02051ea:	e3c1                	bnez	a5,ffffffffc020526a <dup_files+0x98>
ffffffffc02051ec:	499c                	lw	a5,16(a1)
ffffffffc02051ee:	06f05e63          	blez	a5,ffffffffc020526a <dup_files+0x98>
ffffffffc02051f2:	6188                	ld	a0,0(a1)
ffffffffc02051f4:	e088                	sd	a0,0(s1)
ffffffffc02051f6:	c119                	beqz	a0,ffffffffc02051fc <dup_files+0x2a>
ffffffffc02051f8:	638020ef          	jal	ffffffffc0207830 <inode_ref_inc>
ffffffffc02051fc:	6400                	ld	s0,8(s0)
ffffffffc02051fe:	6484                	ld	s1,8(s1)
ffffffffc0205200:	4989                	li	s3,2
ffffffffc0205202:	7ff40913          	addi	s2,s0,2047
ffffffffc0205206:	7c190913          	addi	s2,s2,1985
ffffffffc020520a:	4a05                	li	s4,1
ffffffffc020520c:	a039                	j	ffffffffc020521a <dup_files+0x48>
ffffffffc020520e:	03840413          	addi	s0,s0,56
ffffffffc0205212:	03848493          	addi	s1,s1,56
ffffffffc0205216:	03240163          	beq	s0,s2,ffffffffc0205238 <dup_files+0x66>
ffffffffc020521a:	401c                	lw	a5,0(s0)
ffffffffc020521c:	ff3799e3          	bne	a5,s3,ffffffffc020520e <dup_files+0x3c>
ffffffffc0205220:	0144a023          	sw	s4,0(s1)
ffffffffc0205224:	85a2                	mv	a1,s0
ffffffffc0205226:	8526                	mv	a0,s1
ffffffffc0205228:	03840413          	addi	s0,s0,56
ffffffffc020522c:	e48ff0ef          	jal	ffffffffc0204874 <fd_array_dup>
ffffffffc0205230:	03848493          	addi	s1,s1,56
ffffffffc0205234:	ff2413e3          	bne	s0,s2,ffffffffc020521a <dup_files+0x48>
ffffffffc0205238:	70a2                	ld	ra,40(sp)
ffffffffc020523a:	7402                	ld	s0,32(sp)
ffffffffc020523c:	64e2                	ld	s1,24(sp)
ffffffffc020523e:	6942                	ld	s2,16(sp)
ffffffffc0205240:	69a2                	ld	s3,8(sp)
ffffffffc0205242:	6a02                	ld	s4,0(sp)
ffffffffc0205244:	4501                	li	a0,0
ffffffffc0205246:	6145                	addi	sp,sp,48
ffffffffc0205248:	8082                	ret
ffffffffc020524a:	00008697          	auipc	a3,0x8
ffffffffc020524e:	a6e68693          	addi	a3,a3,-1426 # ffffffffc020ccb8 <etext+0x16be>
ffffffffc0205252:	00006617          	auipc	a2,0x6
ffffffffc0205256:	7e660613          	addi	a2,a2,2022 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020525a:	05300593          	li	a1,83
ffffffffc020525e:	00008517          	auipc	a0,0x8
ffffffffc0205262:	0c250513          	addi	a0,a0,194 # ffffffffc020d320 <etext+0x1d26>
ffffffffc0205266:	9e4fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020526a:	00008697          	auipc	a3,0x8
ffffffffc020526e:	0de68693          	addi	a3,a3,222 # ffffffffc020d348 <etext+0x1d4e>
ffffffffc0205272:	00006617          	auipc	a2,0x6
ffffffffc0205276:	7c660613          	addi	a2,a2,1990 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020527a:	05400593          	li	a1,84
ffffffffc020527e:	00008517          	auipc	a0,0x8
ffffffffc0205282:	0a250513          	addi	a0,a0,162 # ffffffffc020d320 <etext+0x1d26>
ffffffffc0205286:	9c4fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020528a <iobuf_skip.part.0>:
ffffffffc020528a:	1141                	addi	sp,sp,-16
ffffffffc020528c:	00008697          	auipc	a3,0x8
ffffffffc0205290:	0ec68693          	addi	a3,a3,236 # ffffffffc020d378 <etext+0x1d7e>
ffffffffc0205294:	00006617          	auipc	a2,0x6
ffffffffc0205298:	7a460613          	addi	a2,a2,1956 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020529c:	04a00593          	li	a1,74
ffffffffc02052a0:	00008517          	auipc	a0,0x8
ffffffffc02052a4:	0f050513          	addi	a0,a0,240 # ffffffffc020d390 <etext+0x1d96>
ffffffffc02052a8:	e406                	sd	ra,8(sp)
ffffffffc02052aa:	9a0fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02052ae <iobuf_init>:
ffffffffc02052ae:	e10c                	sd	a1,0(a0)
ffffffffc02052b0:	e514                	sd	a3,8(a0)
ffffffffc02052b2:	ed10                	sd	a2,24(a0)
ffffffffc02052b4:	e910                	sd	a2,16(a0)
ffffffffc02052b6:	8082                	ret

ffffffffc02052b8 <iobuf_move>:
ffffffffc02052b8:	6d1c                	ld	a5,24(a0)
ffffffffc02052ba:	88aa                	mv	a7,a0
ffffffffc02052bc:	8832                	mv	a6,a2
ffffffffc02052be:	00f67363          	bgeu	a2,a5,ffffffffc02052c4 <iobuf_move+0xc>
ffffffffc02052c2:	87b2                	mv	a5,a2
ffffffffc02052c4:	cfa1                	beqz	a5,ffffffffc020531c <iobuf_move+0x64>
ffffffffc02052c6:	7179                	addi	sp,sp,-48
ffffffffc02052c8:	f406                	sd	ra,40(sp)
ffffffffc02052ca:	0008b503          	ld	a0,0(a7)
ffffffffc02052ce:	cea9                	beqz	a3,ffffffffc0205328 <iobuf_move+0x70>
ffffffffc02052d0:	863e                	mv	a2,a5
ffffffffc02052d2:	ec3a                	sd	a4,24(sp)
ffffffffc02052d4:	e846                	sd	a7,16(sp)
ffffffffc02052d6:	e442                	sd	a6,8(sp)
ffffffffc02052d8:	e03e                	sd	a5,0(sp)
ffffffffc02052da:	2ca060ef          	jal	ffffffffc020b5a4 <memmove>
ffffffffc02052de:	68c2                	ld	a7,16(sp)
ffffffffc02052e0:	6782                	ld	a5,0(sp)
ffffffffc02052e2:	6822                	ld	a6,8(sp)
ffffffffc02052e4:	0188b683          	ld	a3,24(a7)
ffffffffc02052e8:	6762                	ld	a4,24(sp)
ffffffffc02052ea:	04f6e763          	bltu	a3,a5,ffffffffc0205338 <iobuf_move+0x80>
ffffffffc02052ee:	0008b583          	ld	a1,0(a7)
ffffffffc02052f2:	0088b603          	ld	a2,8(a7)
ffffffffc02052f6:	8e9d                	sub	a3,a3,a5
ffffffffc02052f8:	95be                	add	a1,a1,a5
ffffffffc02052fa:	963e                	add	a2,a2,a5
ffffffffc02052fc:	00d8bc23          	sd	a3,24(a7)
ffffffffc0205300:	00b8b023          	sd	a1,0(a7)
ffffffffc0205304:	00c8b423          	sd	a2,8(a7)
ffffffffc0205308:	40f80833          	sub	a6,a6,a5
ffffffffc020530c:	c311                	beqz	a4,ffffffffc0205310 <iobuf_move+0x58>
ffffffffc020530e:	e31c                	sd	a5,0(a4)
ffffffffc0205310:	02081263          	bnez	a6,ffffffffc0205334 <iobuf_move+0x7c>
ffffffffc0205314:	4501                	li	a0,0
ffffffffc0205316:	70a2                	ld	ra,40(sp)
ffffffffc0205318:	6145                	addi	sp,sp,48
ffffffffc020531a:	8082                	ret
ffffffffc020531c:	c311                	beqz	a4,ffffffffc0205320 <iobuf_move+0x68>
ffffffffc020531e:	e31c                	sd	a5,0(a4)
ffffffffc0205320:	00081863          	bnez	a6,ffffffffc0205330 <iobuf_move+0x78>
ffffffffc0205324:	4501                	li	a0,0
ffffffffc0205326:	8082                	ret
ffffffffc0205328:	86ae                	mv	a3,a1
ffffffffc020532a:	85aa                	mv	a1,a0
ffffffffc020532c:	8536                	mv	a0,a3
ffffffffc020532e:	b74d                	j	ffffffffc02052d0 <iobuf_move+0x18>
ffffffffc0205330:	5571                	li	a0,-4
ffffffffc0205332:	8082                	ret
ffffffffc0205334:	5571                	li	a0,-4
ffffffffc0205336:	b7c5                	j	ffffffffc0205316 <iobuf_move+0x5e>
ffffffffc0205338:	f53ff0ef          	jal	ffffffffc020528a <iobuf_skip.part.0>

ffffffffc020533c <iobuf_skip>:
ffffffffc020533c:	6d1c                	ld	a5,24(a0)
ffffffffc020533e:	00b7eb63          	bltu	a5,a1,ffffffffc0205354 <iobuf_skip+0x18>
ffffffffc0205342:	6114                	ld	a3,0(a0)
ffffffffc0205344:	6518                	ld	a4,8(a0)
ffffffffc0205346:	8f8d                	sub	a5,a5,a1
ffffffffc0205348:	96ae                	add	a3,a3,a1
ffffffffc020534a:	972e                	add	a4,a4,a1
ffffffffc020534c:	ed1c                	sd	a5,24(a0)
ffffffffc020534e:	e114                	sd	a3,0(a0)
ffffffffc0205350:	e518                	sd	a4,8(a0)
ffffffffc0205352:	8082                	ret
ffffffffc0205354:	1141                	addi	sp,sp,-16
ffffffffc0205356:	e406                	sd	ra,8(sp)
ffffffffc0205358:	f33ff0ef          	jal	ffffffffc020528a <iobuf_skip.part.0>

ffffffffc020535c <copy_path>:
ffffffffc020535c:	7139                	addi	sp,sp,-64
ffffffffc020535e:	f04a                	sd	s2,32(sp)
ffffffffc0205360:	00091917          	auipc	s2,0x91
ffffffffc0205364:	56890913          	addi	s2,s2,1384 # ffffffffc02968c8 <current>
ffffffffc0205368:	00093783          	ld	a5,0(s2)
ffffffffc020536c:	e852                	sd	s4,16(sp)
ffffffffc020536e:	8a2a                	mv	s4,a0
ffffffffc0205370:	6505                	lui	a0,0x1
ffffffffc0205372:	f426                	sd	s1,40(sp)
ffffffffc0205374:	ec4e                	sd	s3,24(sp)
ffffffffc0205376:	fc06                	sd	ra,56(sp)
ffffffffc0205378:	7784                	ld	s1,40(a5)
ffffffffc020537a:	89ae                	mv	s3,a1
ffffffffc020537c:	cd5fc0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc0205380:	c92d                	beqz	a0,ffffffffc02053f2 <copy_path+0x96>
ffffffffc0205382:	f822                	sd	s0,48(sp)
ffffffffc0205384:	842a                	mv	s0,a0
ffffffffc0205386:	c0b1                	beqz	s1,ffffffffc02053ca <copy_path+0x6e>
ffffffffc0205388:	03848513          	addi	a0,s1,56
ffffffffc020538c:	88cff0ef          	jal	ffffffffc0204418 <down>
ffffffffc0205390:	00093783          	ld	a5,0(s2)
ffffffffc0205394:	c399                	beqz	a5,ffffffffc020539a <copy_path+0x3e>
ffffffffc0205396:	43dc                	lw	a5,4(a5)
ffffffffc0205398:	c8bc                	sw	a5,80(s1)
ffffffffc020539a:	864e                	mv	a2,s3
ffffffffc020539c:	6685                	lui	a3,0x1
ffffffffc020539e:	85a2                	mv	a1,s0
ffffffffc02053a0:	8526                	mv	a0,s1
ffffffffc02053a2:	e87fe0ef          	jal	ffffffffc0204228 <copy_string>
ffffffffc02053a6:	cd1d                	beqz	a0,ffffffffc02053e4 <copy_path+0x88>
ffffffffc02053a8:	03848513          	addi	a0,s1,56
ffffffffc02053ac:	868ff0ef          	jal	ffffffffc0204414 <up>
ffffffffc02053b0:	0404a823          	sw	zero,80(s1)
ffffffffc02053b4:	008a3023          	sd	s0,0(s4)
ffffffffc02053b8:	7442                	ld	s0,48(sp)
ffffffffc02053ba:	4501                	li	a0,0
ffffffffc02053bc:	70e2                	ld	ra,56(sp)
ffffffffc02053be:	74a2                	ld	s1,40(sp)
ffffffffc02053c0:	7902                	ld	s2,32(sp)
ffffffffc02053c2:	69e2                	ld	s3,24(sp)
ffffffffc02053c4:	6a42                	ld	s4,16(sp)
ffffffffc02053c6:	6121                	addi	sp,sp,64
ffffffffc02053c8:	8082                	ret
ffffffffc02053ca:	85aa                	mv	a1,a0
ffffffffc02053cc:	864e                	mv	a2,s3
ffffffffc02053ce:	6685                	lui	a3,0x1
ffffffffc02053d0:	4501                	li	a0,0
ffffffffc02053d2:	e57fe0ef          	jal	ffffffffc0204228 <copy_string>
ffffffffc02053d6:	fd79                	bnez	a0,ffffffffc02053b4 <copy_path+0x58>
ffffffffc02053d8:	8522                	mv	a0,s0
ffffffffc02053da:	d1dfc0ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc02053de:	5575                	li	a0,-3
ffffffffc02053e0:	7442                	ld	s0,48(sp)
ffffffffc02053e2:	bfe9                	j	ffffffffc02053bc <copy_path+0x60>
ffffffffc02053e4:	03848513          	addi	a0,s1,56
ffffffffc02053e8:	82cff0ef          	jal	ffffffffc0204414 <up>
ffffffffc02053ec:	0404a823          	sw	zero,80(s1)
ffffffffc02053f0:	b7e5                	j	ffffffffc02053d8 <copy_path+0x7c>
ffffffffc02053f2:	5571                	li	a0,-4
ffffffffc02053f4:	b7e1                	j	ffffffffc02053bc <copy_path+0x60>

ffffffffc02053f6 <sysfile_open>:
ffffffffc02053f6:	7179                	addi	sp,sp,-48
ffffffffc02053f8:	f022                	sd	s0,32(sp)
ffffffffc02053fa:	842e                	mv	s0,a1
ffffffffc02053fc:	85aa                	mv	a1,a0
ffffffffc02053fe:	0828                	addi	a0,sp,24
ffffffffc0205400:	f406                	sd	ra,40(sp)
ffffffffc0205402:	f5bff0ef          	jal	ffffffffc020535c <copy_path>
ffffffffc0205406:	87aa                	mv	a5,a0
ffffffffc0205408:	ed09                	bnez	a0,ffffffffc0205422 <sysfile_open+0x2c>
ffffffffc020540a:	6762                	ld	a4,24(sp)
ffffffffc020540c:	85a2                	mv	a1,s0
ffffffffc020540e:	853a                	mv	a0,a4
ffffffffc0205410:	e43a                	sd	a4,8(sp)
ffffffffc0205412:	d32ff0ef          	jal	ffffffffc0204944 <file_open>
ffffffffc0205416:	6722                	ld	a4,8(sp)
ffffffffc0205418:	e42a                	sd	a0,8(sp)
ffffffffc020541a:	853a                	mv	a0,a4
ffffffffc020541c:	cdbfc0ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc0205420:	67a2                	ld	a5,8(sp)
ffffffffc0205422:	70a2                	ld	ra,40(sp)
ffffffffc0205424:	7402                	ld	s0,32(sp)
ffffffffc0205426:	853e                	mv	a0,a5
ffffffffc0205428:	6145                	addi	sp,sp,48
ffffffffc020542a:	8082                	ret

ffffffffc020542c <sysfile_close>:
ffffffffc020542c:	e32ff06f          	j	ffffffffc0204a5e <file_close>

ffffffffc0205430 <sysfile_read>:
ffffffffc0205430:	7119                	addi	sp,sp,-128
ffffffffc0205432:	f466                	sd	s9,40(sp)
ffffffffc0205434:	fc86                	sd	ra,120(sp)
ffffffffc0205436:	4c81                	li	s9,0
ffffffffc0205438:	e611                	bnez	a2,ffffffffc0205444 <sysfile_read+0x14>
ffffffffc020543a:	70e6                	ld	ra,120(sp)
ffffffffc020543c:	8566                	mv	a0,s9
ffffffffc020543e:	7ca2                	ld	s9,40(sp)
ffffffffc0205440:	6109                	addi	sp,sp,128
ffffffffc0205442:	8082                	ret
ffffffffc0205444:	f862                	sd	s8,48(sp)
ffffffffc0205446:	00091c17          	auipc	s8,0x91
ffffffffc020544a:	482c0c13          	addi	s8,s8,1154 # ffffffffc02968c8 <current>
ffffffffc020544e:	000c3783          	ld	a5,0(s8)
ffffffffc0205452:	f8a2                	sd	s0,112(sp)
ffffffffc0205454:	f0ca                	sd	s2,96(sp)
ffffffffc0205456:	8432                	mv	s0,a2
ffffffffc0205458:	892e                	mv	s2,a1
ffffffffc020545a:	4601                	li	a2,0
ffffffffc020545c:	4585                	li	a1,1
ffffffffc020545e:	f4a6                	sd	s1,104(sp)
ffffffffc0205460:	e8d2                	sd	s4,80(sp)
ffffffffc0205462:	7784                	ld	s1,40(a5)
ffffffffc0205464:	8a2a                	mv	s4,a0
ffffffffc0205466:	c8aff0ef          	jal	ffffffffc02048f0 <file_testfd>
ffffffffc020546a:	c969                	beqz	a0,ffffffffc020553c <sysfile_read+0x10c>
ffffffffc020546c:	6505                	lui	a0,0x1
ffffffffc020546e:	ecce                	sd	s3,88(sp)
ffffffffc0205470:	be1fc0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc0205474:	89aa                	mv	s3,a0
ffffffffc0205476:	c971                	beqz	a0,ffffffffc020554a <sysfile_read+0x11a>
ffffffffc0205478:	e4d6                	sd	s5,72(sp)
ffffffffc020547a:	e0da                	sd	s6,64(sp)
ffffffffc020547c:	6a85                	lui	s5,0x1
ffffffffc020547e:	4b01                	li	s6,0
ffffffffc0205480:	09546863          	bltu	s0,s5,ffffffffc0205510 <sysfile_read+0xe0>
ffffffffc0205484:	6785                	lui	a5,0x1
ffffffffc0205486:	863e                	mv	a2,a5
ffffffffc0205488:	0834                	addi	a3,sp,24
ffffffffc020548a:	85ce                	mv	a1,s3
ffffffffc020548c:	8552                	mv	a0,s4
ffffffffc020548e:	ec3e                	sd	a5,24(sp)
ffffffffc0205490:	e26ff0ef          	jal	ffffffffc0204ab6 <file_read>
ffffffffc0205494:	66e2                	ld	a3,24(sp)
ffffffffc0205496:	8caa                	mv	s9,a0
ffffffffc0205498:	e68d                	bnez	a3,ffffffffc02054c2 <sysfile_read+0x92>
ffffffffc020549a:	854e                	mv	a0,s3
ffffffffc020549c:	c5bfc0ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc02054a0:	000b0463          	beqz	s6,ffffffffc02054a8 <sysfile_read+0x78>
ffffffffc02054a4:	000b0c9b          	sext.w	s9,s6
ffffffffc02054a8:	7446                	ld	s0,112(sp)
ffffffffc02054aa:	70e6                	ld	ra,120(sp)
ffffffffc02054ac:	74a6                	ld	s1,104(sp)
ffffffffc02054ae:	7906                	ld	s2,96(sp)
ffffffffc02054b0:	69e6                	ld	s3,88(sp)
ffffffffc02054b2:	6a46                	ld	s4,80(sp)
ffffffffc02054b4:	6aa6                	ld	s5,72(sp)
ffffffffc02054b6:	6b06                	ld	s6,64(sp)
ffffffffc02054b8:	7c42                	ld	s8,48(sp)
ffffffffc02054ba:	8566                	mv	a0,s9
ffffffffc02054bc:	7ca2                	ld	s9,40(sp)
ffffffffc02054be:	6109                	addi	sp,sp,128
ffffffffc02054c0:	8082                	ret
ffffffffc02054c2:	c899                	beqz	s1,ffffffffc02054d8 <sysfile_read+0xa8>
ffffffffc02054c4:	03848513          	addi	a0,s1,56
ffffffffc02054c8:	f51fe0ef          	jal	ffffffffc0204418 <down>
ffffffffc02054cc:	000c3783          	ld	a5,0(s8)
ffffffffc02054d0:	66e2                	ld	a3,24(sp)
ffffffffc02054d2:	c399                	beqz	a5,ffffffffc02054d8 <sysfile_read+0xa8>
ffffffffc02054d4:	43dc                	lw	a5,4(a5)
ffffffffc02054d6:	c8bc                	sw	a5,80(s1)
ffffffffc02054d8:	864e                	mv	a2,s3
ffffffffc02054da:	85ca                	mv	a1,s2
ffffffffc02054dc:	8526                	mv	a0,s1
ffffffffc02054de:	d13fe0ef          	jal	ffffffffc02041f0 <copy_to_user>
ffffffffc02054e2:	c915                	beqz	a0,ffffffffc0205516 <sysfile_read+0xe6>
ffffffffc02054e4:	67e2                	ld	a5,24(sp)
ffffffffc02054e6:	06f46a63          	bltu	s0,a5,ffffffffc020555a <sysfile_read+0x12a>
ffffffffc02054ea:	9b3e                	add	s6,s6,a5
ffffffffc02054ec:	c889                	beqz	s1,ffffffffc02054fe <sysfile_read+0xce>
ffffffffc02054ee:	03848513          	addi	a0,s1,56
ffffffffc02054f2:	e43e                	sd	a5,8(sp)
ffffffffc02054f4:	f21fe0ef          	jal	ffffffffc0204414 <up>
ffffffffc02054f8:	67a2                	ld	a5,8(sp)
ffffffffc02054fa:	0404a823          	sw	zero,80(s1)
ffffffffc02054fe:	f80c9ee3          	bnez	s9,ffffffffc020549a <sysfile_read+0x6a>
ffffffffc0205502:	6762                	ld	a4,24(sp)
ffffffffc0205504:	db59                	beqz	a4,ffffffffc020549a <sysfile_read+0x6a>
ffffffffc0205506:	8c1d                	sub	s0,s0,a5
ffffffffc0205508:	d849                	beqz	s0,ffffffffc020549a <sysfile_read+0x6a>
ffffffffc020550a:	993e                	add	s2,s2,a5
ffffffffc020550c:	f7547ce3          	bgeu	s0,s5,ffffffffc0205484 <sysfile_read+0x54>
ffffffffc0205510:	87a2                	mv	a5,s0
ffffffffc0205512:	8622                	mv	a2,s0
ffffffffc0205514:	bf95                	j	ffffffffc0205488 <sysfile_read+0x58>
ffffffffc0205516:	000c8a63          	beqz	s9,ffffffffc020552a <sysfile_read+0xfa>
ffffffffc020551a:	d0c1                	beqz	s1,ffffffffc020549a <sysfile_read+0x6a>
ffffffffc020551c:	03848513          	addi	a0,s1,56
ffffffffc0205520:	ef5fe0ef          	jal	ffffffffc0204414 <up>
ffffffffc0205524:	0404a823          	sw	zero,80(s1)
ffffffffc0205528:	bf8d                	j	ffffffffc020549a <sysfile_read+0x6a>
ffffffffc020552a:	c499                	beqz	s1,ffffffffc0205538 <sysfile_read+0x108>
ffffffffc020552c:	03848513          	addi	a0,s1,56
ffffffffc0205530:	ee5fe0ef          	jal	ffffffffc0204414 <up>
ffffffffc0205534:	0404a823          	sw	zero,80(s1)
ffffffffc0205538:	5cf5                	li	s9,-3
ffffffffc020553a:	b785                	j	ffffffffc020549a <sysfile_read+0x6a>
ffffffffc020553c:	7446                	ld	s0,112(sp)
ffffffffc020553e:	74a6                	ld	s1,104(sp)
ffffffffc0205540:	7906                	ld	s2,96(sp)
ffffffffc0205542:	6a46                	ld	s4,80(sp)
ffffffffc0205544:	7c42                	ld	s8,48(sp)
ffffffffc0205546:	5cf5                	li	s9,-3
ffffffffc0205548:	bdcd                	j	ffffffffc020543a <sysfile_read+0xa>
ffffffffc020554a:	7446                	ld	s0,112(sp)
ffffffffc020554c:	74a6                	ld	s1,104(sp)
ffffffffc020554e:	7906                	ld	s2,96(sp)
ffffffffc0205550:	69e6                	ld	s3,88(sp)
ffffffffc0205552:	6a46                	ld	s4,80(sp)
ffffffffc0205554:	7c42                	ld	s8,48(sp)
ffffffffc0205556:	5cf1                	li	s9,-4
ffffffffc0205558:	b5cd                	j	ffffffffc020543a <sysfile_read+0xa>
ffffffffc020555a:	00008697          	auipc	a3,0x8
ffffffffc020555e:	e4668693          	addi	a3,a3,-442 # ffffffffc020d3a0 <etext+0x1da6>
ffffffffc0205562:	00006617          	auipc	a2,0x6
ffffffffc0205566:	4d660613          	addi	a2,a2,1238 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020556a:	05500593          	li	a1,85
ffffffffc020556e:	00008517          	auipc	a0,0x8
ffffffffc0205572:	e4250513          	addi	a0,a0,-446 # ffffffffc020d3b0 <etext+0x1db6>
ffffffffc0205576:	fc5e                	sd	s7,56(sp)
ffffffffc0205578:	ed3fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020557c <sysfile_write>:
ffffffffc020557c:	e601                	bnez	a2,ffffffffc0205584 <sysfile_write+0x8>
ffffffffc020557e:	4701                	li	a4,0
ffffffffc0205580:	853a                	mv	a0,a4
ffffffffc0205582:	8082                	ret
ffffffffc0205584:	7159                	addi	sp,sp,-112
ffffffffc0205586:	f062                	sd	s8,32(sp)
ffffffffc0205588:	00091c17          	auipc	s8,0x91
ffffffffc020558c:	340c0c13          	addi	s8,s8,832 # ffffffffc02968c8 <current>
ffffffffc0205590:	000c3783          	ld	a5,0(s8)
ffffffffc0205594:	f0a2                	sd	s0,96(sp)
ffffffffc0205596:	eca6                	sd	s1,88(sp)
ffffffffc0205598:	8432                	mv	s0,a2
ffffffffc020559a:	84ae                	mv	s1,a1
ffffffffc020559c:	4605                	li	a2,1
ffffffffc020559e:	4581                	li	a1,0
ffffffffc02055a0:	e8ca                	sd	s2,80(sp)
ffffffffc02055a2:	e0d2                	sd	s4,64(sp)
ffffffffc02055a4:	f486                	sd	ra,104(sp)
ffffffffc02055a6:	0287b903          	ld	s2,40(a5) # 1028 <_binary_bin_swap_img_size-0x6cd8>
ffffffffc02055aa:	8a2a                	mv	s4,a0
ffffffffc02055ac:	b44ff0ef          	jal	ffffffffc02048f0 <file_testfd>
ffffffffc02055b0:	c969                	beqz	a0,ffffffffc0205682 <sysfile_write+0x106>
ffffffffc02055b2:	6505                	lui	a0,0x1
ffffffffc02055b4:	e4ce                	sd	s3,72(sp)
ffffffffc02055b6:	a9bfc0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc02055ba:	89aa                	mv	s3,a0
ffffffffc02055bc:	c569                	beqz	a0,ffffffffc0205686 <sysfile_write+0x10a>
ffffffffc02055be:	fc56                	sd	s5,56(sp)
ffffffffc02055c0:	f45e                	sd	s7,40(sp)
ffffffffc02055c2:	4a81                	li	s5,0
ffffffffc02055c4:	6b85                	lui	s7,0x1
ffffffffc02055c6:	86a2                	mv	a3,s0
ffffffffc02055c8:	008bf363          	bgeu	s7,s0,ffffffffc02055ce <sysfile_write+0x52>
ffffffffc02055cc:	6685                	lui	a3,0x1
ffffffffc02055ce:	ec36                	sd	a3,24(sp)
ffffffffc02055d0:	04090e63          	beqz	s2,ffffffffc020562c <sysfile_write+0xb0>
ffffffffc02055d4:	03890513          	addi	a0,s2,56
ffffffffc02055d8:	e41fe0ef          	jal	ffffffffc0204418 <down>
ffffffffc02055dc:	000c3783          	ld	a5,0(s8)
ffffffffc02055e0:	c781                	beqz	a5,ffffffffc02055e8 <sysfile_write+0x6c>
ffffffffc02055e2:	43dc                	lw	a5,4(a5)
ffffffffc02055e4:	04f92823          	sw	a5,80(s2)
ffffffffc02055e8:	66e2                	ld	a3,24(sp)
ffffffffc02055ea:	4701                	li	a4,0
ffffffffc02055ec:	8626                	mv	a2,s1
ffffffffc02055ee:	85ce                	mv	a1,s3
ffffffffc02055f0:	854a                	mv	a0,s2
ffffffffc02055f2:	bc9fe0ef          	jal	ffffffffc02041ba <copy_from_user>
ffffffffc02055f6:	ed3d                	bnez	a0,ffffffffc0205674 <sysfile_write+0xf8>
ffffffffc02055f8:	03890513          	addi	a0,s2,56
ffffffffc02055fc:	e19fe0ef          	jal	ffffffffc0204414 <up>
ffffffffc0205600:	04092823          	sw	zero,80(s2)
ffffffffc0205604:	5775                	li	a4,-3
ffffffffc0205606:	854e                	mv	a0,s3
ffffffffc0205608:	e43a                	sd	a4,8(sp)
ffffffffc020560a:	aedfc0ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc020560e:	6722                	ld	a4,8(sp)
ffffffffc0205610:	040a9c63          	bnez	s5,ffffffffc0205668 <sysfile_write+0xec>
ffffffffc0205614:	69a6                	ld	s3,72(sp)
ffffffffc0205616:	7ae2                	ld	s5,56(sp)
ffffffffc0205618:	7ba2                	ld	s7,40(sp)
ffffffffc020561a:	70a6                	ld	ra,104(sp)
ffffffffc020561c:	7406                	ld	s0,96(sp)
ffffffffc020561e:	64e6                	ld	s1,88(sp)
ffffffffc0205620:	6946                	ld	s2,80(sp)
ffffffffc0205622:	6a06                	ld	s4,64(sp)
ffffffffc0205624:	7c02                	ld	s8,32(sp)
ffffffffc0205626:	853a                	mv	a0,a4
ffffffffc0205628:	6165                	addi	sp,sp,112
ffffffffc020562a:	8082                	ret
ffffffffc020562c:	4701                	li	a4,0
ffffffffc020562e:	8626                	mv	a2,s1
ffffffffc0205630:	85ce                	mv	a1,s3
ffffffffc0205632:	4501                	li	a0,0
ffffffffc0205634:	b87fe0ef          	jal	ffffffffc02041ba <copy_from_user>
ffffffffc0205638:	d571                	beqz	a0,ffffffffc0205604 <sysfile_write+0x88>
ffffffffc020563a:	6662                	ld	a2,24(sp)
ffffffffc020563c:	0834                	addi	a3,sp,24
ffffffffc020563e:	85ce                	mv	a1,s3
ffffffffc0205640:	8552                	mv	a0,s4
ffffffffc0205642:	d62ff0ef          	jal	ffffffffc0204ba4 <file_write>
ffffffffc0205646:	67e2                	ld	a5,24(sp)
ffffffffc0205648:	872a                	mv	a4,a0
ffffffffc020564a:	dfd5                	beqz	a5,ffffffffc0205606 <sysfile_write+0x8a>
ffffffffc020564c:	04f46063          	bltu	s0,a5,ffffffffc020568c <sysfile_write+0x110>
ffffffffc0205650:	9abe                	add	s5,s5,a5
ffffffffc0205652:	f955                	bnez	a0,ffffffffc0205606 <sysfile_write+0x8a>
ffffffffc0205654:	8c1d                	sub	s0,s0,a5
ffffffffc0205656:	94be                	add	s1,s1,a5
ffffffffc0205658:	f43d                	bnez	s0,ffffffffc02055c6 <sysfile_write+0x4a>
ffffffffc020565a:	854e                	mv	a0,s3
ffffffffc020565c:	e43a                	sd	a4,8(sp)
ffffffffc020565e:	a99fc0ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc0205662:	6722                	ld	a4,8(sp)
ffffffffc0205664:	fa0a88e3          	beqz	s5,ffffffffc0205614 <sysfile_write+0x98>
ffffffffc0205668:	000a871b          	sext.w	a4,s5
ffffffffc020566c:	69a6                	ld	s3,72(sp)
ffffffffc020566e:	7ae2                	ld	s5,56(sp)
ffffffffc0205670:	7ba2                	ld	s7,40(sp)
ffffffffc0205672:	b765                	j	ffffffffc020561a <sysfile_write+0x9e>
ffffffffc0205674:	03890513          	addi	a0,s2,56
ffffffffc0205678:	d9dfe0ef          	jal	ffffffffc0204414 <up>
ffffffffc020567c:	04092823          	sw	zero,80(s2)
ffffffffc0205680:	bf6d                	j	ffffffffc020563a <sysfile_write+0xbe>
ffffffffc0205682:	5775                	li	a4,-3
ffffffffc0205684:	bf59                	j	ffffffffc020561a <sysfile_write+0x9e>
ffffffffc0205686:	69a6                	ld	s3,72(sp)
ffffffffc0205688:	5771                	li	a4,-4
ffffffffc020568a:	bf41                	j	ffffffffc020561a <sysfile_write+0x9e>
ffffffffc020568c:	00008697          	auipc	a3,0x8
ffffffffc0205690:	d1468693          	addi	a3,a3,-748 # ffffffffc020d3a0 <etext+0x1da6>
ffffffffc0205694:	00006617          	auipc	a2,0x6
ffffffffc0205698:	3a460613          	addi	a2,a2,932 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020569c:	08a00593          	li	a1,138
ffffffffc02056a0:	00008517          	auipc	a0,0x8
ffffffffc02056a4:	d1050513          	addi	a0,a0,-752 # ffffffffc020d3b0 <etext+0x1db6>
ffffffffc02056a8:	f85a                	sd	s6,48(sp)
ffffffffc02056aa:	da1fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02056ae <sysfile_seek>:
ffffffffc02056ae:	de4ff06f          	j	ffffffffc0204c92 <file_seek>

ffffffffc02056b2 <sysfile_fstat>:
ffffffffc02056b2:	715d                	addi	sp,sp,-80
ffffffffc02056b4:	f84a                	sd	s2,48(sp)
ffffffffc02056b6:	00091917          	auipc	s2,0x91
ffffffffc02056ba:	21290913          	addi	s2,s2,530 # ffffffffc02968c8 <current>
ffffffffc02056be:	00093783          	ld	a5,0(s2)
ffffffffc02056c2:	f44e                	sd	s3,40(sp)
ffffffffc02056c4:	89ae                	mv	s3,a1
ffffffffc02056c6:	858a                	mv	a1,sp
ffffffffc02056c8:	e0a2                	sd	s0,64(sp)
ffffffffc02056ca:	fc26                	sd	s1,56(sp)
ffffffffc02056cc:	e486                	sd	ra,72(sp)
ffffffffc02056ce:	7784                	ld	s1,40(a5)
ffffffffc02056d0:	ee6ff0ef          	jal	ffffffffc0204db6 <file_fstat>
ffffffffc02056d4:	842a                	mv	s0,a0
ffffffffc02056d6:	e915                	bnez	a0,ffffffffc020570a <sysfile_fstat+0x58>
ffffffffc02056d8:	c0a9                	beqz	s1,ffffffffc020571a <sysfile_fstat+0x68>
ffffffffc02056da:	03848513          	addi	a0,s1,56
ffffffffc02056de:	d3bfe0ef          	jal	ffffffffc0204418 <down>
ffffffffc02056e2:	00093783          	ld	a5,0(s2)
ffffffffc02056e6:	c399                	beqz	a5,ffffffffc02056ec <sysfile_fstat+0x3a>
ffffffffc02056e8:	43dc                	lw	a5,4(a5)
ffffffffc02056ea:	c8bc                	sw	a5,80(s1)
ffffffffc02056ec:	860a                	mv	a2,sp
ffffffffc02056ee:	85ce                	mv	a1,s3
ffffffffc02056f0:	02000693          	li	a3,32
ffffffffc02056f4:	8526                	mv	a0,s1
ffffffffc02056f6:	afbfe0ef          	jal	ffffffffc02041f0 <copy_to_user>
ffffffffc02056fa:	e111                	bnez	a0,ffffffffc02056fe <sysfile_fstat+0x4c>
ffffffffc02056fc:	5475                	li	s0,-3
ffffffffc02056fe:	03848513          	addi	a0,s1,56
ffffffffc0205702:	d13fe0ef          	jal	ffffffffc0204414 <up>
ffffffffc0205706:	0404a823          	sw	zero,80(s1)
ffffffffc020570a:	60a6                	ld	ra,72(sp)
ffffffffc020570c:	8522                	mv	a0,s0
ffffffffc020570e:	6406                	ld	s0,64(sp)
ffffffffc0205710:	74e2                	ld	s1,56(sp)
ffffffffc0205712:	7942                	ld	s2,48(sp)
ffffffffc0205714:	79a2                	ld	s3,40(sp)
ffffffffc0205716:	6161                	addi	sp,sp,80
ffffffffc0205718:	8082                	ret
ffffffffc020571a:	860a                	mv	a2,sp
ffffffffc020571c:	85ce                	mv	a1,s3
ffffffffc020571e:	02000693          	li	a3,32
ffffffffc0205722:	acffe0ef          	jal	ffffffffc02041f0 <copy_to_user>
ffffffffc0205726:	f175                	bnez	a0,ffffffffc020570a <sysfile_fstat+0x58>
ffffffffc0205728:	5475                	li	s0,-3
ffffffffc020572a:	60a6                	ld	ra,72(sp)
ffffffffc020572c:	8522                	mv	a0,s0
ffffffffc020572e:	6406                	ld	s0,64(sp)
ffffffffc0205730:	74e2                	ld	s1,56(sp)
ffffffffc0205732:	7942                	ld	s2,48(sp)
ffffffffc0205734:	79a2                	ld	s3,40(sp)
ffffffffc0205736:	6161                	addi	sp,sp,80
ffffffffc0205738:	8082                	ret

ffffffffc020573a <sysfile_fsync>:
ffffffffc020573a:	f34ff06f          	j	ffffffffc0204e6e <file_fsync>

ffffffffc020573e <sysfile_getcwd>:
ffffffffc020573e:	c1d5                	beqz	a1,ffffffffc02057e2 <sysfile_getcwd+0xa4>
ffffffffc0205740:	00091717          	auipc	a4,0x91
ffffffffc0205744:	18873703          	ld	a4,392(a4) # ffffffffc02968c8 <current>
ffffffffc0205748:	711d                	addi	sp,sp,-96
ffffffffc020574a:	e8a2                	sd	s0,80(sp)
ffffffffc020574c:	7700                	ld	s0,40(a4)
ffffffffc020574e:	e4a6                	sd	s1,72(sp)
ffffffffc0205750:	e0ca                	sd	s2,64(sp)
ffffffffc0205752:	ec86                	sd	ra,88(sp)
ffffffffc0205754:	892a                	mv	s2,a0
ffffffffc0205756:	84ae                	mv	s1,a1
ffffffffc0205758:	c039                	beqz	s0,ffffffffc020579e <sysfile_getcwd+0x60>
ffffffffc020575a:	03840513          	addi	a0,s0,56
ffffffffc020575e:	cbbfe0ef          	jal	ffffffffc0204418 <down>
ffffffffc0205762:	00091797          	auipc	a5,0x91
ffffffffc0205766:	1667b783          	ld	a5,358(a5) # ffffffffc02968c8 <current>
ffffffffc020576a:	c399                	beqz	a5,ffffffffc0205770 <sysfile_getcwd+0x32>
ffffffffc020576c:	43dc                	lw	a5,4(a5)
ffffffffc020576e:	c83c                	sw	a5,80(s0)
ffffffffc0205770:	4685                	li	a3,1
ffffffffc0205772:	8626                	mv	a2,s1
ffffffffc0205774:	85ca                	mv	a1,s2
ffffffffc0205776:	8522                	mv	a0,s0
ffffffffc0205778:	99ffe0ef          	jal	ffffffffc0204116 <user_mem_check>
ffffffffc020577c:	57f5                	li	a5,-3
ffffffffc020577e:	e921                	bnez	a0,ffffffffc02057ce <sysfile_getcwd+0x90>
ffffffffc0205780:	03840513          	addi	a0,s0,56
ffffffffc0205784:	e43e                	sd	a5,8(sp)
ffffffffc0205786:	c8ffe0ef          	jal	ffffffffc0204414 <up>
ffffffffc020578a:	67a2                	ld	a5,8(sp)
ffffffffc020578c:	04042823          	sw	zero,80(s0)
ffffffffc0205790:	60e6                	ld	ra,88(sp)
ffffffffc0205792:	6446                	ld	s0,80(sp)
ffffffffc0205794:	64a6                	ld	s1,72(sp)
ffffffffc0205796:	6906                	ld	s2,64(sp)
ffffffffc0205798:	853e                	mv	a0,a5
ffffffffc020579a:	6125                	addi	sp,sp,96
ffffffffc020579c:	8082                	ret
ffffffffc020579e:	862e                	mv	a2,a1
ffffffffc02057a0:	4685                	li	a3,1
ffffffffc02057a2:	85aa                	mv	a1,a0
ffffffffc02057a4:	4501                	li	a0,0
ffffffffc02057a6:	971fe0ef          	jal	ffffffffc0204116 <user_mem_check>
ffffffffc02057aa:	57f5                	li	a5,-3
ffffffffc02057ac:	d175                	beqz	a0,ffffffffc0205790 <sysfile_getcwd+0x52>
ffffffffc02057ae:	8626                	mv	a2,s1
ffffffffc02057b0:	85ca                	mv	a1,s2
ffffffffc02057b2:	4681                	li	a3,0
ffffffffc02057b4:	0808                	addi	a0,sp,16
ffffffffc02057b6:	af9ff0ef          	jal	ffffffffc02052ae <iobuf_init>
ffffffffc02057ba:	45d020ef          	jal	ffffffffc0208416 <vfs_getcwd>
ffffffffc02057be:	60e6                	ld	ra,88(sp)
ffffffffc02057c0:	6446                	ld	s0,80(sp)
ffffffffc02057c2:	87aa                	mv	a5,a0
ffffffffc02057c4:	64a6                	ld	s1,72(sp)
ffffffffc02057c6:	6906                	ld	s2,64(sp)
ffffffffc02057c8:	853e                	mv	a0,a5
ffffffffc02057ca:	6125                	addi	sp,sp,96
ffffffffc02057cc:	8082                	ret
ffffffffc02057ce:	8626                	mv	a2,s1
ffffffffc02057d0:	85ca                	mv	a1,s2
ffffffffc02057d2:	4681                	li	a3,0
ffffffffc02057d4:	0808                	addi	a0,sp,16
ffffffffc02057d6:	ad9ff0ef          	jal	ffffffffc02052ae <iobuf_init>
ffffffffc02057da:	43d020ef          	jal	ffffffffc0208416 <vfs_getcwd>
ffffffffc02057de:	87aa                	mv	a5,a0
ffffffffc02057e0:	b745                	j	ffffffffc0205780 <sysfile_getcwd+0x42>
ffffffffc02057e2:	57f5                	li	a5,-3
ffffffffc02057e4:	853e                	mv	a0,a5
ffffffffc02057e6:	8082                	ret

ffffffffc02057e8 <sysfile_getdirentry>:
ffffffffc02057e8:	7139                	addi	sp,sp,-64
ffffffffc02057ea:	ec4e                	sd	s3,24(sp)
ffffffffc02057ec:	00091997          	auipc	s3,0x91
ffffffffc02057f0:	0dc98993          	addi	s3,s3,220 # ffffffffc02968c8 <current>
ffffffffc02057f4:	0009b783          	ld	a5,0(s3)
ffffffffc02057f8:	f04a                	sd	s2,32(sp)
ffffffffc02057fa:	892a                	mv	s2,a0
ffffffffc02057fc:	10800513          	li	a0,264
ffffffffc0205800:	f426                	sd	s1,40(sp)
ffffffffc0205802:	e852                	sd	s4,16(sp)
ffffffffc0205804:	fc06                	sd	ra,56(sp)
ffffffffc0205806:	7784                	ld	s1,40(a5)
ffffffffc0205808:	8a2e                	mv	s4,a1
ffffffffc020580a:	847fc0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc020580e:	c179                	beqz	a0,ffffffffc02058d4 <sysfile_getdirentry+0xec>
ffffffffc0205810:	f822                	sd	s0,48(sp)
ffffffffc0205812:	842a                	mv	s0,a0
ffffffffc0205814:	c8d1                	beqz	s1,ffffffffc02058a8 <sysfile_getdirentry+0xc0>
ffffffffc0205816:	03848513          	addi	a0,s1,56
ffffffffc020581a:	bfffe0ef          	jal	ffffffffc0204418 <down>
ffffffffc020581e:	0009b783          	ld	a5,0(s3)
ffffffffc0205822:	c399                	beqz	a5,ffffffffc0205828 <sysfile_getdirentry+0x40>
ffffffffc0205824:	43dc                	lw	a5,4(a5)
ffffffffc0205826:	c8bc                	sw	a5,80(s1)
ffffffffc0205828:	4705                	li	a4,1
ffffffffc020582a:	46a1                	li	a3,8
ffffffffc020582c:	8652                	mv	a2,s4
ffffffffc020582e:	85a2                	mv	a1,s0
ffffffffc0205830:	8526                	mv	a0,s1
ffffffffc0205832:	989fe0ef          	jal	ffffffffc02041ba <copy_from_user>
ffffffffc0205836:	e505                	bnez	a0,ffffffffc020585e <sysfile_getdirentry+0x76>
ffffffffc0205838:	03848513          	addi	a0,s1,56
ffffffffc020583c:	bd9fe0ef          	jal	ffffffffc0204414 <up>
ffffffffc0205840:	0404a823          	sw	zero,80(s1)
ffffffffc0205844:	5975                	li	s2,-3
ffffffffc0205846:	8522                	mv	a0,s0
ffffffffc0205848:	8affc0ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc020584c:	7442                	ld	s0,48(sp)
ffffffffc020584e:	70e2                	ld	ra,56(sp)
ffffffffc0205850:	74a2                	ld	s1,40(sp)
ffffffffc0205852:	69e2                	ld	s3,24(sp)
ffffffffc0205854:	6a42                	ld	s4,16(sp)
ffffffffc0205856:	854a                	mv	a0,s2
ffffffffc0205858:	7902                	ld	s2,32(sp)
ffffffffc020585a:	6121                	addi	sp,sp,64
ffffffffc020585c:	8082                	ret
ffffffffc020585e:	03848513          	addi	a0,s1,56
ffffffffc0205862:	bb3fe0ef          	jal	ffffffffc0204414 <up>
ffffffffc0205866:	854a                	mv	a0,s2
ffffffffc0205868:	0404a823          	sw	zero,80(s1)
ffffffffc020586c:	85a2                	mv	a1,s0
ffffffffc020586e:	eaaff0ef          	jal	ffffffffc0204f18 <file_getdirentry>
ffffffffc0205872:	892a                	mv	s2,a0
ffffffffc0205874:	f969                	bnez	a0,ffffffffc0205846 <sysfile_getdirentry+0x5e>
ffffffffc0205876:	03848513          	addi	a0,s1,56
ffffffffc020587a:	b9ffe0ef          	jal	ffffffffc0204418 <down>
ffffffffc020587e:	0009b783          	ld	a5,0(s3)
ffffffffc0205882:	c399                	beqz	a5,ffffffffc0205888 <sysfile_getdirentry+0xa0>
ffffffffc0205884:	43dc                	lw	a5,4(a5)
ffffffffc0205886:	c8bc                	sw	a5,80(s1)
ffffffffc0205888:	85d2                	mv	a1,s4
ffffffffc020588a:	10800693          	li	a3,264
ffffffffc020588e:	8622                	mv	a2,s0
ffffffffc0205890:	8526                	mv	a0,s1
ffffffffc0205892:	95ffe0ef          	jal	ffffffffc02041f0 <copy_to_user>
ffffffffc0205896:	e111                	bnez	a0,ffffffffc020589a <sysfile_getdirentry+0xb2>
ffffffffc0205898:	5975                	li	s2,-3
ffffffffc020589a:	03848513          	addi	a0,s1,56
ffffffffc020589e:	b77fe0ef          	jal	ffffffffc0204414 <up>
ffffffffc02058a2:	0404a823          	sw	zero,80(s1)
ffffffffc02058a6:	b745                	j	ffffffffc0205846 <sysfile_getdirentry+0x5e>
ffffffffc02058a8:	85aa                	mv	a1,a0
ffffffffc02058aa:	4705                	li	a4,1
ffffffffc02058ac:	46a1                	li	a3,8
ffffffffc02058ae:	8652                	mv	a2,s4
ffffffffc02058b0:	4501                	li	a0,0
ffffffffc02058b2:	909fe0ef          	jal	ffffffffc02041ba <copy_from_user>
ffffffffc02058b6:	d559                	beqz	a0,ffffffffc0205844 <sysfile_getdirentry+0x5c>
ffffffffc02058b8:	854a                	mv	a0,s2
ffffffffc02058ba:	85a2                	mv	a1,s0
ffffffffc02058bc:	e5cff0ef          	jal	ffffffffc0204f18 <file_getdirentry>
ffffffffc02058c0:	892a                	mv	s2,a0
ffffffffc02058c2:	f151                	bnez	a0,ffffffffc0205846 <sysfile_getdirentry+0x5e>
ffffffffc02058c4:	85d2                	mv	a1,s4
ffffffffc02058c6:	10800693          	li	a3,264
ffffffffc02058ca:	8622                	mv	a2,s0
ffffffffc02058cc:	925fe0ef          	jal	ffffffffc02041f0 <copy_to_user>
ffffffffc02058d0:	f93d                	bnez	a0,ffffffffc0205846 <sysfile_getdirentry+0x5e>
ffffffffc02058d2:	bf8d                	j	ffffffffc0205844 <sysfile_getdirentry+0x5c>
ffffffffc02058d4:	5971                	li	s2,-4
ffffffffc02058d6:	bfa5                	j	ffffffffc020584e <sysfile_getdirentry+0x66>

ffffffffc02058d8 <sysfile_dup>:
ffffffffc02058d8:	f2eff06f          	j	ffffffffc0205006 <file_dup>

ffffffffc02058dc <kernel_thread_entry>:
ffffffffc02058dc:	8526                	mv	a0,s1
ffffffffc02058de:	9402                	jalr	s0
ffffffffc02058e0:	688000ef          	jal	ffffffffc0205f68 <do_exit>

ffffffffc02058e4 <alloc_proc>:
ffffffffc02058e4:	1141                	addi	sp,sp,-16
ffffffffc02058e6:	15000513          	li	a0,336
ffffffffc02058ea:	e022                	sd	s0,0(sp)
ffffffffc02058ec:	e406                	sd	ra,8(sp)
ffffffffc02058ee:	f62fc0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc02058f2:	842a                	mv	s0,a0
ffffffffc02058f4:	c141                	beqz	a0,ffffffffc0205974 <alloc_proc+0x90>
ffffffffc02058f6:	57fd                	li	a5,-1
ffffffffc02058f8:	1782                	slli	a5,a5,0x20
ffffffffc02058fa:	e11c                	sd	a5,0(a0)
ffffffffc02058fc:	00052423          	sw	zero,8(a0)
ffffffffc0205900:	00053823          	sd	zero,16(a0)
ffffffffc0205904:	00053c23          	sd	zero,24(a0)
ffffffffc0205908:	02053023          	sd	zero,32(a0)
ffffffffc020590c:	02053423          	sd	zero,40(a0)
ffffffffc0205910:	07000613          	li	a2,112
ffffffffc0205914:	4581                	li	a1,0
ffffffffc0205916:	03050513          	addi	a0,a0,48
ffffffffc020591a:	479050ef          	jal	ffffffffc020b592 <memset>
ffffffffc020591e:	00091797          	auipc	a5,0x91
ffffffffc0205922:	f7a7b783          	ld	a5,-134(a5) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc0205926:	0a043023          	sd	zero,160(s0)
ffffffffc020592a:	0a042823          	sw	zero,176(s0)
ffffffffc020592e:	f45c                	sd	a5,168(s0)
ffffffffc0205930:	0b440513          	addi	a0,s0,180
ffffffffc0205934:	463d                	li	a2,15
ffffffffc0205936:	4581                	li	a1,0
ffffffffc0205938:	45b050ef          	jal	ffffffffc020b592 <memset>
ffffffffc020593c:	11040793          	addi	a5,s0,272
ffffffffc0205940:	0e042623          	sw	zero,236(s0)
ffffffffc0205944:	0e043c23          	sd	zero,248(s0)
ffffffffc0205948:	10043023          	sd	zero,256(s0)
ffffffffc020594c:	0e043823          	sd	zero,240(s0)
ffffffffc0205950:	10043423          	sd	zero,264(s0)
ffffffffc0205954:	12042023          	sw	zero,288(s0)
ffffffffc0205958:	12043423          	sd	zero,296(s0)
ffffffffc020595c:	12043c23          	sd	zero,312(s0)
ffffffffc0205960:	12043823          	sd	zero,304(s0)
ffffffffc0205964:	14043023          	sd	zero,320(s0)
ffffffffc0205968:	14043423          	sd	zero,328(s0)
ffffffffc020596c:	10f43c23          	sd	a5,280(s0)
ffffffffc0205970:	10f43823          	sd	a5,272(s0)
ffffffffc0205974:	60a2                	ld	ra,8(sp)
ffffffffc0205976:	8522                	mv	a0,s0
ffffffffc0205978:	6402                	ld	s0,0(sp)
ffffffffc020597a:	0141                	addi	sp,sp,16
ffffffffc020597c:	8082                	ret

ffffffffc020597e <forkret>:
ffffffffc020597e:	00091797          	auipc	a5,0x91
ffffffffc0205982:	f4a7b783          	ld	a5,-182(a5) # ffffffffc02968c8 <current>
ffffffffc0205986:	73c8                	ld	a0,160(a5)
ffffffffc0205988:	957fb06f          	j	ffffffffc02012de <forkrets>

ffffffffc020598c <put_pgdir.isra.0>:
ffffffffc020598c:	1141                	addi	sp,sp,-16
ffffffffc020598e:	e406                	sd	ra,8(sp)
ffffffffc0205990:	c02007b7          	lui	a5,0xc0200
ffffffffc0205994:	02f56f63          	bltu	a0,a5,ffffffffc02059d2 <put_pgdir.isra.0+0x46>
ffffffffc0205998:	00091797          	auipc	a5,0x91
ffffffffc020599c:	f107b783          	ld	a5,-240(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc02059a0:	00091717          	auipc	a4,0x91
ffffffffc02059a4:	f1073703          	ld	a4,-240(a4) # ffffffffc02968b0 <npage>
ffffffffc02059a8:	8d1d                	sub	a0,a0,a5
ffffffffc02059aa:	00c55793          	srli	a5,a0,0xc
ffffffffc02059ae:	02e7ff63          	bgeu	a5,a4,ffffffffc02059ec <put_pgdir.isra.0+0x60>
ffffffffc02059b2:	0000a717          	auipc	a4,0xa
ffffffffc02059b6:	e7673703          	ld	a4,-394(a4) # ffffffffc020f828 <nbase>
ffffffffc02059ba:	00091517          	auipc	a0,0x91
ffffffffc02059be:	efe53503          	ld	a0,-258(a0) # ffffffffc02968b8 <pages>
ffffffffc02059c2:	60a2                	ld	ra,8(sp)
ffffffffc02059c4:	8f99                	sub	a5,a5,a4
ffffffffc02059c6:	079a                	slli	a5,a5,0x6
ffffffffc02059c8:	4585                	li	a1,1
ffffffffc02059ca:	953e                	add	a0,a0,a5
ffffffffc02059cc:	0141                	addi	sp,sp,16
ffffffffc02059ce:	881fc06f          	j	ffffffffc020224e <free_pages>
ffffffffc02059d2:	86aa                	mv	a3,a0
ffffffffc02059d4:	00007617          	auipc	a2,0x7
ffffffffc02059d8:	b8460613          	addi	a2,a2,-1148 # ffffffffc020c558 <etext+0xf5e>
ffffffffc02059dc:	07700593          	li	a1,119
ffffffffc02059e0:	00007517          	auipc	a0,0x7
ffffffffc02059e4:	af850513          	addi	a0,a0,-1288 # ffffffffc020c4d8 <etext+0xede>
ffffffffc02059e8:	a63fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02059ec:	00007617          	auipc	a2,0x7
ffffffffc02059f0:	b9460613          	addi	a2,a2,-1132 # ffffffffc020c580 <etext+0xf86>
ffffffffc02059f4:	06900593          	li	a1,105
ffffffffc02059f8:	00007517          	auipc	a0,0x7
ffffffffc02059fc:	ae050513          	addi	a0,a0,-1312 # ffffffffc020c4d8 <etext+0xede>
ffffffffc0205a00:	a4bfa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205a04 <setup_pgdir>:
ffffffffc0205a04:	1101                	addi	sp,sp,-32
ffffffffc0205a06:	e426                	sd	s1,8(sp)
ffffffffc0205a08:	84aa                	mv	s1,a0
ffffffffc0205a0a:	4505                	li	a0,1
ffffffffc0205a0c:	ec06                	sd	ra,24(sp)
ffffffffc0205a0e:	807fc0ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc0205a12:	cd29                	beqz	a0,ffffffffc0205a6c <setup_pgdir+0x68>
ffffffffc0205a14:	00091697          	auipc	a3,0x91
ffffffffc0205a18:	ea46b683          	ld	a3,-348(a3) # ffffffffc02968b8 <pages>
ffffffffc0205a1c:	0000a797          	auipc	a5,0xa
ffffffffc0205a20:	e0c7b783          	ld	a5,-500(a5) # ffffffffc020f828 <nbase>
ffffffffc0205a24:	00091717          	auipc	a4,0x91
ffffffffc0205a28:	e8c73703          	ld	a4,-372(a4) # ffffffffc02968b0 <npage>
ffffffffc0205a2c:	40d506b3          	sub	a3,a0,a3
ffffffffc0205a30:	8699                	srai	a3,a3,0x6
ffffffffc0205a32:	96be                	add	a3,a3,a5
ffffffffc0205a34:	00c69793          	slli	a5,a3,0xc
ffffffffc0205a38:	e822                	sd	s0,16(sp)
ffffffffc0205a3a:	83b1                	srli	a5,a5,0xc
ffffffffc0205a3c:	06b2                	slli	a3,a3,0xc
ffffffffc0205a3e:	02e7f963          	bgeu	a5,a4,ffffffffc0205a70 <setup_pgdir+0x6c>
ffffffffc0205a42:	00091797          	auipc	a5,0x91
ffffffffc0205a46:	e667b783          	ld	a5,-410(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0205a4a:	00091597          	auipc	a1,0x91
ffffffffc0205a4e:	e565b583          	ld	a1,-426(a1) # ffffffffc02968a0 <boot_pgdir_va>
ffffffffc0205a52:	6605                	lui	a2,0x1
ffffffffc0205a54:	00f68433          	add	s0,a3,a5
ffffffffc0205a58:	8522                	mv	a0,s0
ffffffffc0205a5a:	389050ef          	jal	ffffffffc020b5e2 <memcpy>
ffffffffc0205a5e:	ec80                	sd	s0,24(s1)
ffffffffc0205a60:	6442                	ld	s0,16(sp)
ffffffffc0205a62:	4501                	li	a0,0
ffffffffc0205a64:	60e2                	ld	ra,24(sp)
ffffffffc0205a66:	64a2                	ld	s1,8(sp)
ffffffffc0205a68:	6105                	addi	sp,sp,32
ffffffffc0205a6a:	8082                	ret
ffffffffc0205a6c:	5571                	li	a0,-4
ffffffffc0205a6e:	bfdd                	j	ffffffffc0205a64 <setup_pgdir+0x60>
ffffffffc0205a70:	00007617          	auipc	a2,0x7
ffffffffc0205a74:	a4060613          	addi	a2,a2,-1472 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc0205a78:	07100593          	li	a1,113
ffffffffc0205a7c:	00007517          	auipc	a0,0x7
ffffffffc0205a80:	a5c50513          	addi	a0,a0,-1444 # ffffffffc020c4d8 <etext+0xede>
ffffffffc0205a84:	9c7fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205a88 <proc_run>:
ffffffffc0205a88:	00091697          	auipc	a3,0x91
ffffffffc0205a8c:	e406b683          	ld	a3,-448(a3) # ffffffffc02968c8 <current>
ffffffffc0205a90:	04a68663          	beq	a3,a0,ffffffffc0205adc <proc_run+0x54>
ffffffffc0205a94:	1101                	addi	sp,sp,-32
ffffffffc0205a96:	ec06                	sd	ra,24(sp)
ffffffffc0205a98:	100027f3          	csrr	a5,sstatus
ffffffffc0205a9c:	8b89                	andi	a5,a5,2
ffffffffc0205a9e:	4601                	li	a2,0
ffffffffc0205aa0:	ef9d                	bnez	a5,ffffffffc0205ade <proc_run+0x56>
ffffffffc0205aa2:	755c                	ld	a5,168(a0)
ffffffffc0205aa4:	577d                	li	a4,-1
ffffffffc0205aa6:	177e                	slli	a4,a4,0x3f
ffffffffc0205aa8:	83b1                	srli	a5,a5,0xc
ffffffffc0205aaa:	e032                	sd	a2,0(sp)
ffffffffc0205aac:	00091597          	auipc	a1,0x91
ffffffffc0205ab0:	e0a5be23          	sd	a0,-484(a1) # ffffffffc02968c8 <current>
ffffffffc0205ab4:	8fd9                	or	a5,a5,a4
ffffffffc0205ab6:	18079073          	csrw	satp,a5
ffffffffc0205aba:	12000073          	sfence.vma
ffffffffc0205abe:	03050593          	addi	a1,a0,48
ffffffffc0205ac2:	03068513          	addi	a0,a3,48
ffffffffc0205ac6:	572010ef          	jal	ffffffffc0207038 <switch_to>
ffffffffc0205aca:	6602                	ld	a2,0(sp)
ffffffffc0205acc:	e601                	bnez	a2,ffffffffc0205ad4 <proc_run+0x4c>
ffffffffc0205ace:	60e2                	ld	ra,24(sp)
ffffffffc0205ad0:	6105                	addi	sp,sp,32
ffffffffc0205ad2:	8082                	ret
ffffffffc0205ad4:	60e2                	ld	ra,24(sp)
ffffffffc0205ad6:	6105                	addi	sp,sp,32
ffffffffc0205ad8:	992fb06f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc0205adc:	8082                	ret
ffffffffc0205ade:	e42a                	sd	a0,8(sp)
ffffffffc0205ae0:	e036                	sd	a3,0(sp)
ffffffffc0205ae2:	98efb0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0205ae6:	6522                	ld	a0,8(sp)
ffffffffc0205ae8:	6682                	ld	a3,0(sp)
ffffffffc0205aea:	4605                	li	a2,1
ffffffffc0205aec:	bf5d                	j	ffffffffc0205aa2 <proc_run+0x1a>

ffffffffc0205aee <do_fork>:
ffffffffc0205aee:	00091717          	auipc	a4,0x91
ffffffffc0205af2:	dd272703          	lw	a4,-558(a4) # ffffffffc02968c0 <nr_process>
ffffffffc0205af6:	6785                	lui	a5,0x1
ffffffffc0205af8:	34f75a63          	bge	a4,a5,ffffffffc0205e4c <do_fork+0x35e>
ffffffffc0205afc:	7119                	addi	sp,sp,-128
ffffffffc0205afe:	f8a2                	sd	s0,112(sp)
ffffffffc0205b00:	f4a6                	sd	s1,104(sp)
ffffffffc0205b02:	f0ca                	sd	s2,96(sp)
ffffffffc0205b04:	ecce                	sd	s3,88(sp)
ffffffffc0205b06:	fc86                	sd	ra,120(sp)
ffffffffc0205b08:	892e                	mv	s2,a1
ffffffffc0205b0a:	84b2                	mv	s1,a2
ffffffffc0205b0c:	89aa                	mv	s3,a0
ffffffffc0205b0e:	dd7ff0ef          	jal	ffffffffc02058e4 <alloc_proc>
ffffffffc0205b12:	842a                	mv	s0,a0
ffffffffc0205b14:	2a050263          	beqz	a0,ffffffffc0205db8 <do_fork+0x2ca>
ffffffffc0205b18:	f466                	sd	s9,40(sp)
ffffffffc0205b1a:	00091c97          	auipc	s9,0x91
ffffffffc0205b1e:	daec8c93          	addi	s9,s9,-594 # ffffffffc02968c8 <current>
ffffffffc0205b22:	000cb783          	ld	a5,0(s9)
ffffffffc0205b26:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_bin_swap_img_size-0x6c14>
ffffffffc0205b2a:	f11c                	sd	a5,32(a0)
ffffffffc0205b2c:	3a071163          	bnez	a4,ffffffffc0205ece <do_fork+0x3e0>
ffffffffc0205b30:	4509                	li	a0,2
ffffffffc0205b32:	ee2fc0ef          	jal	ffffffffc0202214 <alloc_pages>
ffffffffc0205b36:	26050d63          	beqz	a0,ffffffffc0205db0 <do_fork+0x2c2>
ffffffffc0205b3a:	e4d6                	sd	s5,72(sp)
ffffffffc0205b3c:	00091a97          	auipc	s5,0x91
ffffffffc0205b40:	d7ca8a93          	addi	s5,s5,-644 # ffffffffc02968b8 <pages>
ffffffffc0205b44:	000ab783          	ld	a5,0(s5)
ffffffffc0205b48:	e8d2                	sd	s4,80(sp)
ffffffffc0205b4a:	0000aa17          	auipc	s4,0xa
ffffffffc0205b4e:	cdea3a03          	ld	s4,-802(s4) # ffffffffc020f828 <nbase>
ffffffffc0205b52:	40f506b3          	sub	a3,a0,a5
ffffffffc0205b56:	e0da                	sd	s6,64(sp)
ffffffffc0205b58:	8699                	srai	a3,a3,0x6
ffffffffc0205b5a:	00091b17          	auipc	s6,0x91
ffffffffc0205b5e:	d56b0b13          	addi	s6,s6,-682 # ffffffffc02968b0 <npage>
ffffffffc0205b62:	96d2                	add	a3,a3,s4
ffffffffc0205b64:	000b3703          	ld	a4,0(s6)
ffffffffc0205b68:	00c69793          	slli	a5,a3,0xc
ffffffffc0205b6c:	fc5e                	sd	s7,56(sp)
ffffffffc0205b6e:	f862                	sd	s8,48(sp)
ffffffffc0205b70:	83b1                	srli	a5,a5,0xc
ffffffffc0205b72:	06b2                	slli	a3,a3,0xc
ffffffffc0205b74:	38e7f463          	bgeu	a5,a4,ffffffffc0205efc <do_fork+0x40e>
ffffffffc0205b78:	000cb703          	ld	a4,0(s9)
ffffffffc0205b7c:	00091b97          	auipc	s7,0x91
ffffffffc0205b80:	d2cb8b93          	addi	s7,s7,-724 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0205b84:	000bb783          	ld	a5,0(s7)
ffffffffc0205b88:	02873c03          	ld	s8,40(a4)
ffffffffc0205b8c:	96be                	add	a3,a3,a5
ffffffffc0205b8e:	e814                	sd	a3,16(s0)
ffffffffc0205b90:	020c0a63          	beqz	s8,ffffffffc0205bc4 <do_fork+0xd6>
ffffffffc0205b94:	1009f793          	andi	a5,s3,256
ffffffffc0205b98:	1c078363          	beqz	a5,ffffffffc0205d5e <do_fork+0x270>
ffffffffc0205b9c:	030c2703          	lw	a4,48(s8)
ffffffffc0205ba0:	018c3783          	ld	a5,24(s8)
ffffffffc0205ba4:	c02006b7          	lui	a3,0xc0200
ffffffffc0205ba8:	2705                	addiw	a4,a4,1
ffffffffc0205baa:	02ec2823          	sw	a4,48(s8)
ffffffffc0205bae:	03843423          	sd	s8,40(s0)
ffffffffc0205bb2:	2ed7ef63          	bltu	a5,a3,ffffffffc0205eb0 <do_fork+0x3c2>
ffffffffc0205bb6:	000bb603          	ld	a2,0(s7)
ffffffffc0205bba:	000cb703          	ld	a4,0(s9)
ffffffffc0205bbe:	6814                	ld	a3,16(s0)
ffffffffc0205bc0:	8f91                	sub	a5,a5,a2
ffffffffc0205bc2:	f45c                	sd	a5,168(s0)
ffffffffc0205bc4:	6789                	lui	a5,0x2
ffffffffc0205bc6:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0205bca:	96be                	add	a3,a3,a5
ffffffffc0205bcc:	f054                	sd	a3,160(s0)
ffffffffc0205bce:	87b6                	mv	a5,a3
ffffffffc0205bd0:	12048613          	addi	a2,s1,288
ffffffffc0205bd4:	688c                	ld	a1,16(s1)
ffffffffc0205bd6:	0004b803          	ld	a6,0(s1)
ffffffffc0205bda:	6488                	ld	a0,8(s1)
ffffffffc0205bdc:	eb8c                	sd	a1,16(a5)
ffffffffc0205bde:	0107b023          	sd	a6,0(a5)
ffffffffc0205be2:	e788                	sd	a0,8(a5)
ffffffffc0205be4:	6c8c                	ld	a1,24(s1)
ffffffffc0205be6:	02048493          	addi	s1,s1,32
ffffffffc0205bea:	02078793          	addi	a5,a5,32
ffffffffc0205bee:	feb7bc23          	sd	a1,-8(a5)
ffffffffc0205bf2:	fec491e3          	bne	s1,a2,ffffffffc0205bd4 <do_fork+0xe6>
ffffffffc0205bf6:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
ffffffffc0205bfa:	1c090163          	beqz	s2,ffffffffc0205dbc <do_fork+0x2ce>
ffffffffc0205bfe:	14873483          	ld	s1,328(a4)
ffffffffc0205c02:	00000797          	auipc	a5,0x0
ffffffffc0205c06:	d7c78793          	addi	a5,a5,-644 # ffffffffc020597e <forkret>
ffffffffc0205c0a:	0126b823          	sd	s2,16(a3)
ffffffffc0205c0e:	fc14                	sd	a3,56(s0)
ffffffffc0205c10:	f81c                	sd	a5,48(s0)
ffffffffc0205c12:	24048f63          	beqz	s1,ffffffffc0205e70 <do_fork+0x382>
ffffffffc0205c16:	03499793          	slli	a5,s3,0x34
ffffffffc0205c1a:	0007cd63          	bltz	a5,ffffffffc0205c34 <do_fork+0x146>
ffffffffc0205c1e:	c7cff0ef          	jal	ffffffffc020509a <files_create>
ffffffffc0205c22:	892a                	mv	s2,a0
ffffffffc0205c24:	20050163          	beqz	a0,ffffffffc0205e26 <do_fork+0x338>
ffffffffc0205c28:	85a6                	mv	a1,s1
ffffffffc0205c2a:	da8ff0ef          	jal	ffffffffc02051d2 <dup_files>
ffffffffc0205c2e:	84ca                	mv	s1,s2
ffffffffc0205c30:	1e051863          	bnez	a0,ffffffffc0205e20 <do_fork+0x332>
ffffffffc0205c34:	489c                	lw	a5,16(s1)
ffffffffc0205c36:	2785                	addiw	a5,a5,1
ffffffffc0205c38:	c89c                	sw	a5,16(s1)
ffffffffc0205c3a:	14943423          	sd	s1,328(s0)
ffffffffc0205c3e:	100027f3          	csrr	a5,sstatus
ffffffffc0205c42:	8b89                	andi	a5,a5,2
ffffffffc0205c44:	1c079a63          	bnez	a5,ffffffffc0205e18 <do_fork+0x32a>
ffffffffc0205c48:	4901                	li	s2,0
ffffffffc0205c4a:	0008b517          	auipc	a0,0x8b
ffffffffc0205c4e:	41252503          	lw	a0,1042(a0) # ffffffffc029105c <last_pid.1>
ffffffffc0205c52:	6789                	lui	a5,0x2
ffffffffc0205c54:	2505                	addiw	a0,a0,1
ffffffffc0205c56:	0008b717          	auipc	a4,0x8b
ffffffffc0205c5a:	40a72323          	sw	a0,1030(a4) # ffffffffc029105c <last_pid.1>
ffffffffc0205c5e:	16f55163          	bge	a0,a5,ffffffffc0205dc0 <do_fork+0x2d2>
ffffffffc0205c62:	0008b797          	auipc	a5,0x8b
ffffffffc0205c66:	3f67a783          	lw	a5,1014(a5) # ffffffffc0291058 <next_safe.0>
ffffffffc0205c6a:	00090497          	auipc	s1,0x90
ffffffffc0205c6e:	b5648493          	addi	s1,s1,-1194 # ffffffffc02957c0 <proc_list>
ffffffffc0205c72:	06f54563          	blt	a0,a5,ffffffffc0205cdc <do_fork+0x1ee>
ffffffffc0205c76:	00090497          	auipc	s1,0x90
ffffffffc0205c7a:	b4a48493          	addi	s1,s1,-1206 # ffffffffc02957c0 <proc_list>
ffffffffc0205c7e:	0084b883          	ld	a7,8(s1)
ffffffffc0205c82:	6789                	lui	a5,0x2
ffffffffc0205c84:	0008b717          	auipc	a4,0x8b
ffffffffc0205c88:	3cf72a23          	sw	a5,980(a4) # ffffffffc0291058 <next_safe.0>
ffffffffc0205c8c:	86aa                	mv	a3,a0
ffffffffc0205c8e:	4581                	li	a1,0
ffffffffc0205c90:	04988063          	beq	a7,s1,ffffffffc0205cd0 <do_fork+0x1e2>
ffffffffc0205c94:	882e                	mv	a6,a1
ffffffffc0205c96:	87c6                	mv	a5,a7
ffffffffc0205c98:	6609                	lui	a2,0x2
ffffffffc0205c9a:	a811                	j	ffffffffc0205cae <do_fork+0x1c0>
ffffffffc0205c9c:	00e6d663          	bge	a3,a4,ffffffffc0205ca8 <do_fork+0x1ba>
ffffffffc0205ca0:	00c75463          	bge	a4,a2,ffffffffc0205ca8 <do_fork+0x1ba>
ffffffffc0205ca4:	863a                	mv	a2,a4
ffffffffc0205ca6:	4805                	li	a6,1
ffffffffc0205ca8:	679c                	ld	a5,8(a5)
ffffffffc0205caa:	00978d63          	beq	a5,s1,ffffffffc0205cc4 <do_fork+0x1d6>
ffffffffc0205cae:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_bin_swap_img_size-0x5dc4>
ffffffffc0205cb2:	fed715e3          	bne	a4,a3,ffffffffc0205c9c <do_fork+0x1ae>
ffffffffc0205cb6:	2685                	addiw	a3,a3,1
ffffffffc0205cb8:	10c6dd63          	bge	a3,a2,ffffffffc0205dd2 <do_fork+0x2e4>
ffffffffc0205cbc:	679c                	ld	a5,8(a5)
ffffffffc0205cbe:	4585                	li	a1,1
ffffffffc0205cc0:	fe9797e3          	bne	a5,s1,ffffffffc0205cae <do_fork+0x1c0>
ffffffffc0205cc4:	00080663          	beqz	a6,ffffffffc0205cd0 <do_fork+0x1e2>
ffffffffc0205cc8:	0008b797          	auipc	a5,0x8b
ffffffffc0205ccc:	38c7a823          	sw	a2,912(a5) # ffffffffc0291058 <next_safe.0>
ffffffffc0205cd0:	c591                	beqz	a1,ffffffffc0205cdc <do_fork+0x1ee>
ffffffffc0205cd2:	0008b797          	auipc	a5,0x8b
ffffffffc0205cd6:	38d7a523          	sw	a3,906(a5) # ffffffffc029105c <last_pid.1>
ffffffffc0205cda:	8536                	mv	a0,a3
ffffffffc0205cdc:	c048                	sw	a0,4(s0)
ffffffffc0205cde:	45a9                	li	a1,10
ffffffffc0205ce0:	376050ef          	jal	ffffffffc020b056 <hash32>
ffffffffc0205ce4:	02051793          	slli	a5,a0,0x20
ffffffffc0205ce8:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0205cec:	0008c797          	auipc	a5,0x8c
ffffffffc0205cf0:	ad478793          	addi	a5,a5,-1324 # ffffffffc02917c0 <hash_list>
ffffffffc0205cf4:	953e                	add	a0,a0,a5
ffffffffc0205cf6:	6518                	ld	a4,8(a0)
ffffffffc0205cf8:	0d840793          	addi	a5,s0,216
ffffffffc0205cfc:	6490                	ld	a2,8(s1)
ffffffffc0205cfe:	e31c                	sd	a5,0(a4)
ffffffffc0205d00:	e51c                	sd	a5,8(a0)
ffffffffc0205d02:	f078                	sd	a4,224(s0)
ffffffffc0205d04:	0c840793          	addi	a5,s0,200
ffffffffc0205d08:	7018                	ld	a4,32(s0)
ffffffffc0205d0a:	ec68                	sd	a0,216(s0)
ffffffffc0205d0c:	e21c                	sd	a5,0(a2)
ffffffffc0205d0e:	0e043c23          	sd	zero,248(s0)
ffffffffc0205d12:	7b74                	ld	a3,240(a4)
ffffffffc0205d14:	e49c                	sd	a5,8(s1)
ffffffffc0205d16:	e870                	sd	a2,208(s0)
ffffffffc0205d18:	e464                	sd	s1,200(s0)
ffffffffc0205d1a:	10d43023          	sd	a3,256(s0)
ffffffffc0205d1e:	c299                	beqz	a3,ffffffffc0205d24 <do_fork+0x236>
ffffffffc0205d20:	fee0                	sd	s0,248(a3)
ffffffffc0205d22:	7018                	ld	a4,32(s0)
ffffffffc0205d24:	00091797          	auipc	a5,0x91
ffffffffc0205d28:	b9c7a783          	lw	a5,-1124(a5) # ffffffffc02968c0 <nr_process>
ffffffffc0205d2c:	fb60                	sd	s0,240(a4)
ffffffffc0205d2e:	2785                	addiw	a5,a5,1
ffffffffc0205d30:	00091717          	auipc	a4,0x91
ffffffffc0205d34:	b8f72823          	sw	a5,-1136(a4) # ffffffffc02968c0 <nr_process>
ffffffffc0205d38:	08091a63          	bnez	s2,ffffffffc0205dcc <do_fork+0x2de>
ffffffffc0205d3c:	8522                	mv	a0,s0
ffffffffc0205d3e:	4a4010ef          	jal	ffffffffc02071e2 <wakeup_proc>
ffffffffc0205d42:	4048                	lw	a0,4(s0)
ffffffffc0205d44:	6a46                	ld	s4,80(sp)
ffffffffc0205d46:	6aa6                	ld	s5,72(sp)
ffffffffc0205d48:	6b06                	ld	s6,64(sp)
ffffffffc0205d4a:	7be2                	ld	s7,56(sp)
ffffffffc0205d4c:	7c42                	ld	s8,48(sp)
ffffffffc0205d4e:	7ca2                	ld	s9,40(sp)
ffffffffc0205d50:	70e6                	ld	ra,120(sp)
ffffffffc0205d52:	7446                	ld	s0,112(sp)
ffffffffc0205d54:	74a6                	ld	s1,104(sp)
ffffffffc0205d56:	7906                	ld	s2,96(sp)
ffffffffc0205d58:	69e6                	ld	s3,88(sp)
ffffffffc0205d5a:	6109                	addi	sp,sp,128
ffffffffc0205d5c:	8082                	ret
ffffffffc0205d5e:	f06a                	sd	s10,32(sp)
ffffffffc0205d60:	d17fd0ef          	jal	ffffffffc0203a76 <mm_create>
ffffffffc0205d64:	8d2a                	mv	s10,a0
ffffffffc0205d66:	0e050563          	beqz	a0,ffffffffc0205e50 <do_fork+0x362>
ffffffffc0205d6a:	c9bff0ef          	jal	ffffffffc0205a04 <setup_pgdir>
ffffffffc0205d6e:	c925                	beqz	a0,ffffffffc0205dde <do_fork+0x2f0>
ffffffffc0205d70:	856a                	mv	a0,s10
ffffffffc0205d72:	e51fd0ef          	jal	ffffffffc0203bc2 <mm_destroy>
ffffffffc0205d76:	7d02                	ld	s10,32(sp)
ffffffffc0205d78:	6814                	ld	a3,16(s0)
ffffffffc0205d7a:	c02007b7          	lui	a5,0xc0200
ffffffffc0205d7e:	0cf6eb63          	bltu	a3,a5,ffffffffc0205e54 <do_fork+0x366>
ffffffffc0205d82:	000bb783          	ld	a5,0(s7)
ffffffffc0205d86:	000b3703          	ld	a4,0(s6)
ffffffffc0205d8a:	40f687b3          	sub	a5,a3,a5
ffffffffc0205d8e:	83b1                	srli	a5,a5,0xc
ffffffffc0205d90:	10e7f263          	bgeu	a5,a4,ffffffffc0205e94 <do_fork+0x3a6>
ffffffffc0205d94:	000ab503          	ld	a0,0(s5)
ffffffffc0205d98:	414787b3          	sub	a5,a5,s4
ffffffffc0205d9c:	079a                	slli	a5,a5,0x6
ffffffffc0205d9e:	953e                	add	a0,a0,a5
ffffffffc0205da0:	4589                	li	a1,2
ffffffffc0205da2:	cacfc0ef          	jal	ffffffffc020224e <free_pages>
ffffffffc0205da6:	6a46                	ld	s4,80(sp)
ffffffffc0205da8:	6aa6                	ld	s5,72(sp)
ffffffffc0205daa:	6b06                	ld	s6,64(sp)
ffffffffc0205dac:	7be2                	ld	s7,56(sp)
ffffffffc0205dae:	7c42                	ld	s8,48(sp)
ffffffffc0205db0:	8522                	mv	a0,s0
ffffffffc0205db2:	b44fc0ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc0205db6:	7ca2                	ld	s9,40(sp)
ffffffffc0205db8:	5571                	li	a0,-4
ffffffffc0205dba:	bf59                	j	ffffffffc0205d50 <do_fork+0x262>
ffffffffc0205dbc:	8936                	mv	s2,a3
ffffffffc0205dbe:	b581                	j	ffffffffc0205bfe <do_fork+0x110>
ffffffffc0205dc0:	4505                	li	a0,1
ffffffffc0205dc2:	0008b797          	auipc	a5,0x8b
ffffffffc0205dc6:	28a7ad23          	sw	a0,666(a5) # ffffffffc029105c <last_pid.1>
ffffffffc0205dca:	b575                	j	ffffffffc0205c76 <do_fork+0x188>
ffffffffc0205dcc:	e9ffa0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0205dd0:	b7b5                	j	ffffffffc0205d3c <do_fork+0x24e>
ffffffffc0205dd2:	6789                	lui	a5,0x2
ffffffffc0205dd4:	00f6c363          	blt	a3,a5,ffffffffc0205dda <do_fork+0x2ec>
ffffffffc0205dd8:	4685                	li	a3,1
ffffffffc0205dda:	4585                	li	a1,1
ffffffffc0205ddc:	bd55                	j	ffffffffc0205c90 <do_fork+0x1a2>
ffffffffc0205dde:	038c0793          	addi	a5,s8,56
ffffffffc0205de2:	853e                	mv	a0,a5
ffffffffc0205de4:	e43e                	sd	a5,8(sp)
ffffffffc0205de6:	ec6e                	sd	s11,24(sp)
ffffffffc0205de8:	e30fe0ef          	jal	ffffffffc0204418 <down>
ffffffffc0205dec:	000cb783          	ld	a5,0(s9)
ffffffffc0205df0:	c781                	beqz	a5,ffffffffc0205df8 <do_fork+0x30a>
ffffffffc0205df2:	43dc                	lw	a5,4(a5)
ffffffffc0205df4:	04fc2823          	sw	a5,80(s8)
ffffffffc0205df8:	85e2                	mv	a1,s8
ffffffffc0205dfa:	856a                	mv	a0,s10
ffffffffc0205dfc:	ee5fd0ef          	jal	ffffffffc0203ce0 <dup_mmap>
ffffffffc0205e00:	8daa                	mv	s11,a0
ffffffffc0205e02:	6522                	ld	a0,8(sp)
ffffffffc0205e04:	e10fe0ef          	jal	ffffffffc0204414 <up>
ffffffffc0205e08:	040c2823          	sw	zero,80(s8)
ffffffffc0205e0c:	8c6a                	mv	s8,s10
ffffffffc0205e0e:	020d9663          	bnez	s11,ffffffffc0205e3a <do_fork+0x34c>
ffffffffc0205e12:	7d02                	ld	s10,32(sp)
ffffffffc0205e14:	6de2                	ld	s11,24(sp)
ffffffffc0205e16:	b359                	j	ffffffffc0205b9c <do_fork+0xae>
ffffffffc0205e18:	e59fa0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0205e1c:	4905                	li	s2,1
ffffffffc0205e1e:	b535                	j	ffffffffc0205c4a <do_fork+0x15c>
ffffffffc0205e20:	854a                	mv	a0,s2
ffffffffc0205e22:	aaeff0ef          	jal	ffffffffc02050d0 <files_destroy>
ffffffffc0205e26:	14843503          	ld	a0,328(s0)
ffffffffc0205e2a:	d539                	beqz	a0,ffffffffc0205d78 <do_fork+0x28a>
ffffffffc0205e2c:	491c                	lw	a5,16(a0)
ffffffffc0205e2e:	37fd                	addiw	a5,a5,-1 # 1fff <_binary_bin_swap_img_size-0x5d01>
ffffffffc0205e30:	c91c                	sw	a5,16(a0)
ffffffffc0205e32:	f3b9                	bnez	a5,ffffffffc0205d78 <do_fork+0x28a>
ffffffffc0205e34:	a9cff0ef          	jal	ffffffffc02050d0 <files_destroy>
ffffffffc0205e38:	b781                	j	ffffffffc0205d78 <do_fork+0x28a>
ffffffffc0205e3a:	856a                	mv	a0,s10
ffffffffc0205e3c:	f3dfd0ef          	jal	ffffffffc0203d78 <exit_mmap>
ffffffffc0205e40:	018d3503          	ld	a0,24(s10) # fffffffffff80018 <end+0x3fce9708>
ffffffffc0205e44:	b49ff0ef          	jal	ffffffffc020598c <put_pgdir.isra.0>
ffffffffc0205e48:	6de2                	ld	s11,24(sp)
ffffffffc0205e4a:	b71d                	j	ffffffffc0205d70 <do_fork+0x282>
ffffffffc0205e4c:	556d                	li	a0,-5
ffffffffc0205e4e:	8082                	ret
ffffffffc0205e50:	7d02                	ld	s10,32(sp)
ffffffffc0205e52:	b71d                	j	ffffffffc0205d78 <do_fork+0x28a>
ffffffffc0205e54:	00006617          	auipc	a2,0x6
ffffffffc0205e58:	70460613          	addi	a2,a2,1796 # ffffffffc020c558 <etext+0xf5e>
ffffffffc0205e5c:	07700593          	li	a1,119
ffffffffc0205e60:	00006517          	auipc	a0,0x6
ffffffffc0205e64:	67850513          	addi	a0,a0,1656 # ffffffffc020c4d8 <etext+0xede>
ffffffffc0205e68:	f06a                	sd	s10,32(sp)
ffffffffc0205e6a:	ec6e                	sd	s11,24(sp)
ffffffffc0205e6c:	ddefa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205e70:	00007697          	auipc	a3,0x7
ffffffffc0205e74:	59068693          	addi	a3,a3,1424 # ffffffffc020d400 <etext+0x1e06>
ffffffffc0205e78:	00006617          	auipc	a2,0x6
ffffffffc0205e7c:	bc060613          	addi	a2,a2,-1088 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0205e80:	1bd00593          	li	a1,445
ffffffffc0205e84:	00007517          	auipc	a0,0x7
ffffffffc0205e88:	56450513          	addi	a0,a0,1380 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0205e8c:	f06a                	sd	s10,32(sp)
ffffffffc0205e8e:	ec6e                	sd	s11,24(sp)
ffffffffc0205e90:	dbafa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205e94:	00006617          	auipc	a2,0x6
ffffffffc0205e98:	6ec60613          	addi	a2,a2,1772 # ffffffffc020c580 <etext+0xf86>
ffffffffc0205e9c:	06900593          	li	a1,105
ffffffffc0205ea0:	00006517          	auipc	a0,0x6
ffffffffc0205ea4:	63850513          	addi	a0,a0,1592 # ffffffffc020c4d8 <etext+0xede>
ffffffffc0205ea8:	f06a                	sd	s10,32(sp)
ffffffffc0205eaa:	ec6e                	sd	s11,24(sp)
ffffffffc0205eac:	d9efa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205eb0:	86be                	mv	a3,a5
ffffffffc0205eb2:	00006617          	auipc	a2,0x6
ffffffffc0205eb6:	6a660613          	addi	a2,a2,1702 # ffffffffc020c558 <etext+0xf5e>
ffffffffc0205eba:	19d00593          	li	a1,413
ffffffffc0205ebe:	00007517          	auipc	a0,0x7
ffffffffc0205ec2:	52a50513          	addi	a0,a0,1322 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0205ec6:	f06a                	sd	s10,32(sp)
ffffffffc0205ec8:	ec6e                	sd	s11,24(sp)
ffffffffc0205eca:	d80fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205ece:	00007697          	auipc	a3,0x7
ffffffffc0205ed2:	4fa68693          	addi	a3,a3,1274 # ffffffffc020d3c8 <etext+0x1dce>
ffffffffc0205ed6:	00006617          	auipc	a2,0x6
ffffffffc0205eda:	b6260613          	addi	a2,a2,-1182 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0205ede:	22100593          	li	a1,545
ffffffffc0205ee2:	00007517          	auipc	a0,0x7
ffffffffc0205ee6:	50650513          	addi	a0,a0,1286 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0205eea:	e8d2                	sd	s4,80(sp)
ffffffffc0205eec:	e4d6                	sd	s5,72(sp)
ffffffffc0205eee:	e0da                	sd	s6,64(sp)
ffffffffc0205ef0:	fc5e                	sd	s7,56(sp)
ffffffffc0205ef2:	f862                	sd	s8,48(sp)
ffffffffc0205ef4:	f06a                	sd	s10,32(sp)
ffffffffc0205ef6:	ec6e                	sd	s11,24(sp)
ffffffffc0205ef8:	d52fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205efc:	00006617          	auipc	a2,0x6
ffffffffc0205f00:	5b460613          	addi	a2,a2,1460 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc0205f04:	07100593          	li	a1,113
ffffffffc0205f08:	00006517          	auipc	a0,0x6
ffffffffc0205f0c:	5d050513          	addi	a0,a0,1488 # ffffffffc020c4d8 <etext+0xede>
ffffffffc0205f10:	f06a                	sd	s10,32(sp)
ffffffffc0205f12:	ec6e                	sd	s11,24(sp)
ffffffffc0205f14:	d36fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205f18 <kernel_thread>:
ffffffffc0205f18:	7129                	addi	sp,sp,-320
ffffffffc0205f1a:	fa22                	sd	s0,304(sp)
ffffffffc0205f1c:	f626                	sd	s1,296(sp)
ffffffffc0205f1e:	f24a                	sd	s2,288(sp)
ffffffffc0205f20:	842a                	mv	s0,a0
ffffffffc0205f22:	84ae                	mv	s1,a1
ffffffffc0205f24:	8932                	mv	s2,a2
ffffffffc0205f26:	850a                	mv	a0,sp
ffffffffc0205f28:	12000613          	li	a2,288
ffffffffc0205f2c:	4581                	li	a1,0
ffffffffc0205f2e:	fe06                	sd	ra,312(sp)
ffffffffc0205f30:	662050ef          	jal	ffffffffc020b592 <memset>
ffffffffc0205f34:	e0a2                	sd	s0,64(sp)
ffffffffc0205f36:	e4a6                	sd	s1,72(sp)
ffffffffc0205f38:	100027f3          	csrr	a5,sstatus
ffffffffc0205f3c:	edd7f793          	andi	a5,a5,-291
ffffffffc0205f40:	1207e793          	ori	a5,a5,288
ffffffffc0205f44:	860a                	mv	a2,sp
ffffffffc0205f46:	10096513          	ori	a0,s2,256
ffffffffc0205f4a:	00000717          	auipc	a4,0x0
ffffffffc0205f4e:	99270713          	addi	a4,a4,-1646 # ffffffffc02058dc <kernel_thread_entry>
ffffffffc0205f52:	4581                	li	a1,0
ffffffffc0205f54:	e23e                	sd	a5,256(sp)
ffffffffc0205f56:	e63a                	sd	a4,264(sp)
ffffffffc0205f58:	b97ff0ef          	jal	ffffffffc0205aee <do_fork>
ffffffffc0205f5c:	70f2                	ld	ra,312(sp)
ffffffffc0205f5e:	7452                	ld	s0,304(sp)
ffffffffc0205f60:	74b2                	ld	s1,296(sp)
ffffffffc0205f62:	7912                	ld	s2,288(sp)
ffffffffc0205f64:	6131                	addi	sp,sp,320
ffffffffc0205f66:	8082                	ret

ffffffffc0205f68 <do_exit>:
ffffffffc0205f68:	7179                	addi	sp,sp,-48
ffffffffc0205f6a:	f022                	sd	s0,32(sp)
ffffffffc0205f6c:	00091417          	auipc	s0,0x91
ffffffffc0205f70:	95c40413          	addi	s0,s0,-1700 # ffffffffc02968c8 <current>
ffffffffc0205f74:	601c                	ld	a5,0(s0)
ffffffffc0205f76:	00091717          	auipc	a4,0x91
ffffffffc0205f7a:	96273703          	ld	a4,-1694(a4) # ffffffffc02968d8 <idleproc>
ffffffffc0205f7e:	f406                	sd	ra,40(sp)
ffffffffc0205f80:	ec26                	sd	s1,24(sp)
ffffffffc0205f82:	0ee78763          	beq	a5,a4,ffffffffc0206070 <do_exit+0x108>
ffffffffc0205f86:	00091497          	auipc	s1,0x91
ffffffffc0205f8a:	94a48493          	addi	s1,s1,-1718 # ffffffffc02968d0 <initproc>
ffffffffc0205f8e:	6098                	ld	a4,0(s1)
ffffffffc0205f90:	e84a                	sd	s2,16(sp)
ffffffffc0205f92:	10e78863          	beq	a5,a4,ffffffffc02060a2 <do_exit+0x13a>
ffffffffc0205f96:	7798                	ld	a4,40(a5)
ffffffffc0205f98:	892a                	mv	s2,a0
ffffffffc0205f9a:	cb0d                	beqz	a4,ffffffffc0205fcc <do_exit+0x64>
ffffffffc0205f9c:	00091797          	auipc	a5,0x91
ffffffffc0205fa0:	8fc7b783          	ld	a5,-1796(a5) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc0205fa4:	56fd                	li	a3,-1
ffffffffc0205fa6:	16fe                	slli	a3,a3,0x3f
ffffffffc0205fa8:	83b1                	srli	a5,a5,0xc
ffffffffc0205faa:	8fd5                	or	a5,a5,a3
ffffffffc0205fac:	18079073          	csrw	satp,a5
ffffffffc0205fb0:	5b1c                	lw	a5,48(a4)
ffffffffc0205fb2:	37fd                	addiw	a5,a5,-1
ffffffffc0205fb4:	db1c                	sw	a5,48(a4)
ffffffffc0205fb6:	cbf1                	beqz	a5,ffffffffc020608a <do_exit+0x122>
ffffffffc0205fb8:	601c                	ld	a5,0(s0)
ffffffffc0205fba:	1487b503          	ld	a0,328(a5)
ffffffffc0205fbe:	0207b423          	sd	zero,40(a5)
ffffffffc0205fc2:	c509                	beqz	a0,ffffffffc0205fcc <do_exit+0x64>
ffffffffc0205fc4:	491c                	lw	a5,16(a0)
ffffffffc0205fc6:	37fd                	addiw	a5,a5,-1
ffffffffc0205fc8:	c91c                	sw	a5,16(a0)
ffffffffc0205fca:	c3c5                	beqz	a5,ffffffffc020606a <do_exit+0x102>
ffffffffc0205fcc:	601c                	ld	a5,0(s0)
ffffffffc0205fce:	470d                	li	a4,3
ffffffffc0205fd0:	0f27a423          	sw	s2,232(a5)
ffffffffc0205fd4:	c398                	sw	a4,0(a5)
ffffffffc0205fd6:	100027f3          	csrr	a5,sstatus
ffffffffc0205fda:	8b89                	andi	a5,a5,2
ffffffffc0205fdc:	4901                	li	s2,0
ffffffffc0205fde:	0c079e63          	bnez	a5,ffffffffc02060ba <do_exit+0x152>
ffffffffc0205fe2:	6018                	ld	a4,0(s0)
ffffffffc0205fe4:	800007b7          	lui	a5,0x80000
ffffffffc0205fe8:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc0205fea:	7308                	ld	a0,32(a4)
ffffffffc0205fec:	0ec52703          	lw	a4,236(a0)
ffffffffc0205ff0:	0cf70963          	beq	a4,a5,ffffffffc02060c2 <do_exit+0x15a>
ffffffffc0205ff4:	6018                	ld	a4,0(s0)
ffffffffc0205ff6:	7b7c                	ld	a5,240(a4)
ffffffffc0205ff8:	c7a1                	beqz	a5,ffffffffc0206040 <do_exit+0xd8>
ffffffffc0205ffa:	800005b7          	lui	a1,0x80000
ffffffffc0205ffe:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc0206000:	460d                	li	a2,3
ffffffffc0206002:	a021                	j	ffffffffc020600a <do_exit+0xa2>
ffffffffc0206004:	6018                	ld	a4,0(s0)
ffffffffc0206006:	7b7c                	ld	a5,240(a4)
ffffffffc0206008:	cf85                	beqz	a5,ffffffffc0206040 <do_exit+0xd8>
ffffffffc020600a:	1007b683          	ld	a3,256(a5)
ffffffffc020600e:	6088                	ld	a0,0(s1)
ffffffffc0206010:	fb74                	sd	a3,240(a4)
ffffffffc0206012:	0e07bc23          	sd	zero,248(a5)
ffffffffc0206016:	7978                	ld	a4,240(a0)
ffffffffc0206018:	10e7b023          	sd	a4,256(a5)
ffffffffc020601c:	c311                	beqz	a4,ffffffffc0206020 <do_exit+0xb8>
ffffffffc020601e:	ff7c                	sd	a5,248(a4)
ffffffffc0206020:	4398                	lw	a4,0(a5)
ffffffffc0206022:	f388                	sd	a0,32(a5)
ffffffffc0206024:	f97c                	sd	a5,240(a0)
ffffffffc0206026:	fcc71fe3          	bne	a4,a2,ffffffffc0206004 <do_exit+0x9c>
ffffffffc020602a:	0ec52783          	lw	a5,236(a0)
ffffffffc020602e:	fcb79be3          	bne	a5,a1,ffffffffc0206004 <do_exit+0x9c>
ffffffffc0206032:	1b0010ef          	jal	ffffffffc02071e2 <wakeup_proc>
ffffffffc0206036:	800005b7          	lui	a1,0x80000
ffffffffc020603a:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc020603c:	460d                	li	a2,3
ffffffffc020603e:	b7d9                	j	ffffffffc0206004 <do_exit+0x9c>
ffffffffc0206040:	02091263          	bnez	s2,ffffffffc0206064 <do_exit+0xfc>
ffffffffc0206044:	296010ef          	jal	ffffffffc02072da <schedule>
ffffffffc0206048:	601c                	ld	a5,0(s0)
ffffffffc020604a:	00007617          	auipc	a2,0x7
ffffffffc020604e:	3ee60613          	addi	a2,a2,1006 # ffffffffc020d438 <etext+0x1e3e>
ffffffffc0206052:	29000593          	li	a1,656
ffffffffc0206056:	43d4                	lw	a3,4(a5)
ffffffffc0206058:	00007517          	auipc	a0,0x7
ffffffffc020605c:	39050513          	addi	a0,a0,912 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206060:	beafa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206064:	c07fa0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0206068:	bff1                	j	ffffffffc0206044 <do_exit+0xdc>
ffffffffc020606a:	866ff0ef          	jal	ffffffffc02050d0 <files_destroy>
ffffffffc020606e:	bfb9                	j	ffffffffc0205fcc <do_exit+0x64>
ffffffffc0206070:	00007617          	auipc	a2,0x7
ffffffffc0206074:	3a860613          	addi	a2,a2,936 # ffffffffc020d418 <etext+0x1e1e>
ffffffffc0206078:	25b00593          	li	a1,603
ffffffffc020607c:	00007517          	auipc	a0,0x7
ffffffffc0206080:	36c50513          	addi	a0,a0,876 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206084:	e84a                	sd	s2,16(sp)
ffffffffc0206086:	bc4fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020608a:	853a                	mv	a0,a4
ffffffffc020608c:	e43a                	sd	a4,8(sp)
ffffffffc020608e:	cebfd0ef          	jal	ffffffffc0203d78 <exit_mmap>
ffffffffc0206092:	6722                	ld	a4,8(sp)
ffffffffc0206094:	6f08                	ld	a0,24(a4)
ffffffffc0206096:	8f7ff0ef          	jal	ffffffffc020598c <put_pgdir.isra.0>
ffffffffc020609a:	6522                	ld	a0,8(sp)
ffffffffc020609c:	b27fd0ef          	jal	ffffffffc0203bc2 <mm_destroy>
ffffffffc02060a0:	bf21                	j	ffffffffc0205fb8 <do_exit+0x50>
ffffffffc02060a2:	00007617          	auipc	a2,0x7
ffffffffc02060a6:	38660613          	addi	a2,a2,902 # ffffffffc020d428 <etext+0x1e2e>
ffffffffc02060aa:	25f00593          	li	a1,607
ffffffffc02060ae:	00007517          	auipc	a0,0x7
ffffffffc02060b2:	33a50513          	addi	a0,a0,826 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc02060b6:	b94fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02060ba:	bb7fa0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02060be:	4905                	li	s2,1
ffffffffc02060c0:	b70d                	j	ffffffffc0205fe2 <do_exit+0x7a>
ffffffffc02060c2:	120010ef          	jal	ffffffffc02071e2 <wakeup_proc>
ffffffffc02060c6:	b73d                	j	ffffffffc0205ff4 <do_exit+0x8c>

ffffffffc02060c8 <do_wait.part.0>:
ffffffffc02060c8:	7179                	addi	sp,sp,-48
ffffffffc02060ca:	ec26                	sd	s1,24(sp)
ffffffffc02060cc:	e84a                	sd	s2,16(sp)
ffffffffc02060ce:	e44e                	sd	s3,8(sp)
ffffffffc02060d0:	f406                	sd	ra,40(sp)
ffffffffc02060d2:	f022                	sd	s0,32(sp)
ffffffffc02060d4:	84aa                	mv	s1,a0
ffffffffc02060d6:	892e                	mv	s2,a1
ffffffffc02060d8:	00090997          	auipc	s3,0x90
ffffffffc02060dc:	7f098993          	addi	s3,s3,2032 # ffffffffc02968c8 <current>
ffffffffc02060e0:	cd19                	beqz	a0,ffffffffc02060fe <do_wait.part.0+0x36>
ffffffffc02060e2:	6789                	lui	a5,0x2
ffffffffc02060e4:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_bin_swap_img_size-0x5d02>
ffffffffc02060e6:	fff5071b          	addiw	a4,a0,-1
ffffffffc02060ea:	12e7f563          	bgeu	a5,a4,ffffffffc0206214 <do_wait.part.0+0x14c>
ffffffffc02060ee:	70a2                	ld	ra,40(sp)
ffffffffc02060f0:	7402                	ld	s0,32(sp)
ffffffffc02060f2:	64e2                	ld	s1,24(sp)
ffffffffc02060f4:	6942                	ld	s2,16(sp)
ffffffffc02060f6:	69a2                	ld	s3,8(sp)
ffffffffc02060f8:	5579                	li	a0,-2
ffffffffc02060fa:	6145                	addi	sp,sp,48
ffffffffc02060fc:	8082                	ret
ffffffffc02060fe:	0009b703          	ld	a4,0(s3)
ffffffffc0206102:	7b60                	ld	s0,240(a4)
ffffffffc0206104:	d46d                	beqz	s0,ffffffffc02060ee <do_wait.part.0+0x26>
ffffffffc0206106:	468d                	li	a3,3
ffffffffc0206108:	a021                	j	ffffffffc0206110 <do_wait.part.0+0x48>
ffffffffc020610a:	10043403          	ld	s0,256(s0)
ffffffffc020610e:	c075                	beqz	s0,ffffffffc02061f2 <do_wait.part.0+0x12a>
ffffffffc0206110:	401c                	lw	a5,0(s0)
ffffffffc0206112:	fed79ce3          	bne	a5,a3,ffffffffc020610a <do_wait.part.0+0x42>
ffffffffc0206116:	00090797          	auipc	a5,0x90
ffffffffc020611a:	7c27b783          	ld	a5,1986(a5) # ffffffffc02968d8 <idleproc>
ffffffffc020611e:	14878263          	beq	a5,s0,ffffffffc0206262 <do_wait.part.0+0x19a>
ffffffffc0206122:	00090797          	auipc	a5,0x90
ffffffffc0206126:	7ae7b783          	ld	a5,1966(a5) # ffffffffc02968d0 <initproc>
ffffffffc020612a:	12f40c63          	beq	s0,a5,ffffffffc0206262 <do_wait.part.0+0x19a>
ffffffffc020612e:	00090663          	beqz	s2,ffffffffc020613a <do_wait.part.0+0x72>
ffffffffc0206132:	0e842783          	lw	a5,232(s0)
ffffffffc0206136:	00f92023          	sw	a5,0(s2)
ffffffffc020613a:	100027f3          	csrr	a5,sstatus
ffffffffc020613e:	8b89                	andi	a5,a5,2
ffffffffc0206140:	4601                	li	a2,0
ffffffffc0206142:	10079963          	bnez	a5,ffffffffc0206254 <do_wait.part.0+0x18c>
ffffffffc0206146:	6c74                	ld	a3,216(s0)
ffffffffc0206148:	7078                	ld	a4,224(s0)
ffffffffc020614a:	10043783          	ld	a5,256(s0)
ffffffffc020614e:	e698                	sd	a4,8(a3)
ffffffffc0206150:	e314                	sd	a3,0(a4)
ffffffffc0206152:	6474                	ld	a3,200(s0)
ffffffffc0206154:	6878                	ld	a4,208(s0)
ffffffffc0206156:	e698                	sd	a4,8(a3)
ffffffffc0206158:	e314                	sd	a3,0(a4)
ffffffffc020615a:	c789                	beqz	a5,ffffffffc0206164 <do_wait.part.0+0x9c>
ffffffffc020615c:	7c78                	ld	a4,248(s0)
ffffffffc020615e:	fff8                	sd	a4,248(a5)
ffffffffc0206160:	10043783          	ld	a5,256(s0)
ffffffffc0206164:	7c78                	ld	a4,248(s0)
ffffffffc0206166:	c36d                	beqz	a4,ffffffffc0206248 <do_wait.part.0+0x180>
ffffffffc0206168:	10f73023          	sd	a5,256(a4)
ffffffffc020616c:	00090797          	auipc	a5,0x90
ffffffffc0206170:	7547a783          	lw	a5,1876(a5) # ffffffffc02968c0 <nr_process>
ffffffffc0206174:	37fd                	addiw	a5,a5,-1
ffffffffc0206176:	00090717          	auipc	a4,0x90
ffffffffc020617a:	74f72523          	sw	a5,1866(a4) # ffffffffc02968c0 <nr_process>
ffffffffc020617e:	e271                	bnez	a2,ffffffffc0206242 <do_wait.part.0+0x17a>
ffffffffc0206180:	6814                	ld	a3,16(s0)
ffffffffc0206182:	c02007b7          	lui	a5,0xc0200
ffffffffc0206186:	10f6e663          	bltu	a3,a5,ffffffffc0206292 <do_wait.part.0+0x1ca>
ffffffffc020618a:	00090717          	auipc	a4,0x90
ffffffffc020618e:	71e73703          	ld	a4,1822(a4) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0206192:	00090797          	auipc	a5,0x90
ffffffffc0206196:	71e7b783          	ld	a5,1822(a5) # ffffffffc02968b0 <npage>
ffffffffc020619a:	8e99                	sub	a3,a3,a4
ffffffffc020619c:	82b1                	srli	a3,a3,0xc
ffffffffc020619e:	0cf6fe63          	bgeu	a3,a5,ffffffffc020627a <do_wait.part.0+0x1b2>
ffffffffc02061a2:	00009797          	auipc	a5,0x9
ffffffffc02061a6:	6867b783          	ld	a5,1670(a5) # ffffffffc020f828 <nbase>
ffffffffc02061aa:	00090517          	auipc	a0,0x90
ffffffffc02061ae:	70e53503          	ld	a0,1806(a0) # ffffffffc02968b8 <pages>
ffffffffc02061b2:	4589                	li	a1,2
ffffffffc02061b4:	8e9d                	sub	a3,a3,a5
ffffffffc02061b6:	069a                	slli	a3,a3,0x6
ffffffffc02061b8:	9536                	add	a0,a0,a3
ffffffffc02061ba:	894fc0ef          	jal	ffffffffc020224e <free_pages>
ffffffffc02061be:	8522                	mv	a0,s0
ffffffffc02061c0:	f37fb0ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc02061c4:	70a2                	ld	ra,40(sp)
ffffffffc02061c6:	7402                	ld	s0,32(sp)
ffffffffc02061c8:	64e2                	ld	s1,24(sp)
ffffffffc02061ca:	6942                	ld	s2,16(sp)
ffffffffc02061cc:	69a2                	ld	s3,8(sp)
ffffffffc02061ce:	4501                	li	a0,0
ffffffffc02061d0:	6145                	addi	sp,sp,48
ffffffffc02061d2:	8082                	ret
ffffffffc02061d4:	00090997          	auipc	s3,0x90
ffffffffc02061d8:	6f498993          	addi	s3,s3,1780 # ffffffffc02968c8 <current>
ffffffffc02061dc:	0009b703          	ld	a4,0(s3)
ffffffffc02061e0:	f487b683          	ld	a3,-184(a5)
ffffffffc02061e4:	f0e695e3          	bne	a3,a4,ffffffffc02060ee <do_wait.part.0+0x26>
ffffffffc02061e8:	f287a603          	lw	a2,-216(a5)
ffffffffc02061ec:	468d                	li	a3,3
ffffffffc02061ee:	06d60063          	beq	a2,a3,ffffffffc020624e <do_wait.part.0+0x186>
ffffffffc02061f2:	800007b7          	lui	a5,0x80000
ffffffffc02061f6:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc02061f8:	4685                	li	a3,1
ffffffffc02061fa:	0ef72623          	sw	a5,236(a4)
ffffffffc02061fe:	c314                	sw	a3,0(a4)
ffffffffc0206200:	0da010ef          	jal	ffffffffc02072da <schedule>
ffffffffc0206204:	0009b783          	ld	a5,0(s3)
ffffffffc0206208:	0b07a783          	lw	a5,176(a5)
ffffffffc020620c:	8b85                	andi	a5,a5,1
ffffffffc020620e:	e7b9                	bnez	a5,ffffffffc020625c <do_wait.part.0+0x194>
ffffffffc0206210:	ee0487e3          	beqz	s1,ffffffffc02060fe <do_wait.part.0+0x36>
ffffffffc0206214:	45a9                	li	a1,10
ffffffffc0206216:	8526                	mv	a0,s1
ffffffffc0206218:	63f040ef          	jal	ffffffffc020b056 <hash32>
ffffffffc020621c:	02051793          	slli	a5,a0,0x20
ffffffffc0206220:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206224:	0008b797          	auipc	a5,0x8b
ffffffffc0206228:	59c78793          	addi	a5,a5,1436 # ffffffffc02917c0 <hash_list>
ffffffffc020622c:	953e                	add	a0,a0,a5
ffffffffc020622e:	87aa                	mv	a5,a0
ffffffffc0206230:	a029                	j	ffffffffc020623a <do_wait.part.0+0x172>
ffffffffc0206232:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0206236:	f8970fe3          	beq	a4,s1,ffffffffc02061d4 <do_wait.part.0+0x10c>
ffffffffc020623a:	679c                	ld	a5,8(a5)
ffffffffc020623c:	fef51be3          	bne	a0,a5,ffffffffc0206232 <do_wait.part.0+0x16a>
ffffffffc0206240:	b57d                	j	ffffffffc02060ee <do_wait.part.0+0x26>
ffffffffc0206242:	a29fa0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0206246:	bf2d                	j	ffffffffc0206180 <do_wait.part.0+0xb8>
ffffffffc0206248:	7018                	ld	a4,32(s0)
ffffffffc020624a:	fb7c                	sd	a5,240(a4)
ffffffffc020624c:	b705                	j	ffffffffc020616c <do_wait.part.0+0xa4>
ffffffffc020624e:	f2878413          	addi	s0,a5,-216
ffffffffc0206252:	b5d1                	j	ffffffffc0206116 <do_wait.part.0+0x4e>
ffffffffc0206254:	a1dfa0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0206258:	4605                	li	a2,1
ffffffffc020625a:	b5f5                	j	ffffffffc0206146 <do_wait.part.0+0x7e>
ffffffffc020625c:	555d                	li	a0,-9
ffffffffc020625e:	d0bff0ef          	jal	ffffffffc0205f68 <do_exit>
ffffffffc0206262:	00007617          	auipc	a2,0x7
ffffffffc0206266:	1f660613          	addi	a2,a2,502 # ffffffffc020d458 <etext+0x1e5e>
ffffffffc020626a:	40f00593          	li	a1,1039
ffffffffc020626e:	00007517          	auipc	a0,0x7
ffffffffc0206272:	17a50513          	addi	a0,a0,378 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206276:	9d4fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020627a:	00006617          	auipc	a2,0x6
ffffffffc020627e:	30660613          	addi	a2,a2,774 # ffffffffc020c580 <etext+0xf86>
ffffffffc0206282:	06900593          	li	a1,105
ffffffffc0206286:	00006517          	auipc	a0,0x6
ffffffffc020628a:	25250513          	addi	a0,a0,594 # ffffffffc020c4d8 <etext+0xede>
ffffffffc020628e:	9bcfa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206292:	00006617          	auipc	a2,0x6
ffffffffc0206296:	2c660613          	addi	a2,a2,710 # ffffffffc020c558 <etext+0xf5e>
ffffffffc020629a:	07700593          	li	a1,119
ffffffffc020629e:	00006517          	auipc	a0,0x6
ffffffffc02062a2:	23a50513          	addi	a0,a0,570 # ffffffffc020c4d8 <etext+0xede>
ffffffffc02062a6:	9a4fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02062aa <init_main>:
ffffffffc02062aa:	1141                	addi	sp,sp,-16
ffffffffc02062ac:	00007517          	auipc	a0,0x7
ffffffffc02062b0:	1cc50513          	addi	a0,a0,460 # ffffffffc020d478 <etext+0x1e7e>
ffffffffc02062b4:	e406                	sd	ra,8(sp)
ffffffffc02062b6:	7b0010ef          	jal	ffffffffc0207a66 <vfs_set_bootfs>
ffffffffc02062ba:	e179                	bnez	a0,ffffffffc0206380 <init_main+0xd6>
ffffffffc02062bc:	fcbfb0ef          	jal	ffffffffc0202286 <nr_free_pages>
ffffffffc02062c0:	d8dfb0ef          	jal	ffffffffc020204c <kallocated>
ffffffffc02062c4:	4601                	li	a2,0
ffffffffc02062c6:	4581                	li	a1,0
ffffffffc02062c8:	00001517          	auipc	a0,0x1
ffffffffc02062cc:	97850513          	addi	a0,a0,-1672 # ffffffffc0206c40 <user_main>
ffffffffc02062d0:	c49ff0ef          	jal	ffffffffc0205f18 <kernel_thread>
ffffffffc02062d4:	00a04563          	bgtz	a0,ffffffffc02062de <init_main+0x34>
ffffffffc02062d8:	a841                	j	ffffffffc0206368 <init_main+0xbe>
ffffffffc02062da:	000010ef          	jal	ffffffffc02072da <schedule>
ffffffffc02062de:	4581                	li	a1,0
ffffffffc02062e0:	4501                	li	a0,0
ffffffffc02062e2:	de7ff0ef          	jal	ffffffffc02060c8 <do_wait.part.0>
ffffffffc02062e6:	d975                	beqz	a0,ffffffffc02062da <init_main+0x30>
ffffffffc02062e8:	da3fe0ef          	jal	ffffffffc020508a <fs_cleanup>
ffffffffc02062ec:	00007517          	auipc	a0,0x7
ffffffffc02062f0:	1d450513          	addi	a0,a0,468 # ffffffffc020d4c0 <etext+0x1ec6>
ffffffffc02062f4:	eb3f90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02062f8:	00090797          	auipc	a5,0x90
ffffffffc02062fc:	5d87b783          	ld	a5,1496(a5) # ffffffffc02968d0 <initproc>
ffffffffc0206300:	7bf8                	ld	a4,240(a5)
ffffffffc0206302:	e339                	bnez	a4,ffffffffc0206348 <init_main+0x9e>
ffffffffc0206304:	7ff8                	ld	a4,248(a5)
ffffffffc0206306:	e329                	bnez	a4,ffffffffc0206348 <init_main+0x9e>
ffffffffc0206308:	1007b703          	ld	a4,256(a5)
ffffffffc020630c:	ef15                	bnez	a4,ffffffffc0206348 <init_main+0x9e>
ffffffffc020630e:	00090697          	auipc	a3,0x90
ffffffffc0206312:	5b26a683          	lw	a3,1458(a3) # ffffffffc02968c0 <nr_process>
ffffffffc0206316:	4709                	li	a4,2
ffffffffc0206318:	0ce69163          	bne	a3,a4,ffffffffc02063da <init_main+0x130>
ffffffffc020631c:	0008f717          	auipc	a4,0x8f
ffffffffc0206320:	4a470713          	addi	a4,a4,1188 # ffffffffc02957c0 <proc_list>
ffffffffc0206324:	6714                	ld	a3,8(a4)
ffffffffc0206326:	0c878793          	addi	a5,a5,200
ffffffffc020632a:	08d79863          	bne	a5,a3,ffffffffc02063ba <init_main+0x110>
ffffffffc020632e:	6318                	ld	a4,0(a4)
ffffffffc0206330:	06e79563          	bne	a5,a4,ffffffffc020639a <init_main+0xf0>
ffffffffc0206334:	00007517          	auipc	a0,0x7
ffffffffc0206338:	27450513          	addi	a0,a0,628 # ffffffffc020d5a8 <etext+0x1fae>
ffffffffc020633c:	e6bf90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0206340:	60a2                	ld	ra,8(sp)
ffffffffc0206342:	4501                	li	a0,0
ffffffffc0206344:	0141                	addi	sp,sp,16
ffffffffc0206346:	8082                	ret
ffffffffc0206348:	00007697          	auipc	a3,0x7
ffffffffc020634c:	1a068693          	addi	a3,a3,416 # ffffffffc020d4e8 <etext+0x1eee>
ffffffffc0206350:	00005617          	auipc	a2,0x5
ffffffffc0206354:	6e860613          	addi	a2,a2,1768 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0206358:	48500593          	li	a1,1157
ffffffffc020635c:	00007517          	auipc	a0,0x7
ffffffffc0206360:	08c50513          	addi	a0,a0,140 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206364:	8e6fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206368:	00007617          	auipc	a2,0x7
ffffffffc020636c:	13860613          	addi	a2,a2,312 # ffffffffc020d4a0 <etext+0x1ea6>
ffffffffc0206370:	47800593          	li	a1,1144
ffffffffc0206374:	00007517          	auipc	a0,0x7
ffffffffc0206378:	07450513          	addi	a0,a0,116 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc020637c:	8cefa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206380:	86aa                	mv	a3,a0
ffffffffc0206382:	00007617          	auipc	a2,0x7
ffffffffc0206386:	0fe60613          	addi	a2,a2,254 # ffffffffc020d480 <etext+0x1e86>
ffffffffc020638a:	47000593          	li	a1,1136
ffffffffc020638e:	00007517          	auipc	a0,0x7
ffffffffc0206392:	05a50513          	addi	a0,a0,90 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206396:	8b4fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020639a:	00007697          	auipc	a3,0x7
ffffffffc020639e:	1de68693          	addi	a3,a3,478 # ffffffffc020d578 <etext+0x1f7e>
ffffffffc02063a2:	00005617          	auipc	a2,0x5
ffffffffc02063a6:	69660613          	addi	a2,a2,1686 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02063aa:	48800593          	li	a1,1160
ffffffffc02063ae:	00007517          	auipc	a0,0x7
ffffffffc02063b2:	03a50513          	addi	a0,a0,58 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc02063b6:	894fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02063ba:	00007697          	auipc	a3,0x7
ffffffffc02063be:	18e68693          	addi	a3,a3,398 # ffffffffc020d548 <etext+0x1f4e>
ffffffffc02063c2:	00005617          	auipc	a2,0x5
ffffffffc02063c6:	67660613          	addi	a2,a2,1654 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02063ca:	48700593          	li	a1,1159
ffffffffc02063ce:	00007517          	auipc	a0,0x7
ffffffffc02063d2:	01a50513          	addi	a0,a0,26 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc02063d6:	874fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02063da:	00007697          	auipc	a3,0x7
ffffffffc02063de:	15e68693          	addi	a3,a3,350 # ffffffffc020d538 <etext+0x1f3e>
ffffffffc02063e2:	00005617          	auipc	a2,0x5
ffffffffc02063e6:	65660613          	addi	a2,a2,1622 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02063ea:	48600593          	li	a1,1158
ffffffffc02063ee:	00007517          	auipc	a0,0x7
ffffffffc02063f2:	ffa50513          	addi	a0,a0,-6 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc02063f6:	854fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02063fa <do_execve>:
ffffffffc02063fa:	db010113          	addi	sp,sp,-592
ffffffffc02063fe:	21613823          	sd	s6,528(sp)
ffffffffc0206402:	24113423          	sd	ra,584(sp)
ffffffffc0206406:	f7ee                	sd	s11,488(sp)
ffffffffc0206408:	fff58b1b          	addiw	s6,a1,-1
ffffffffc020640c:	47fd                	li	a5,31
ffffffffc020640e:	5f67ea63          	bltu	a5,s6,ffffffffc0206a02 <do_execve+0x608>
ffffffffc0206412:	23213823          	sd	s2,560(sp)
ffffffffc0206416:	00090917          	auipc	s2,0x90
ffffffffc020641a:	4b290913          	addi	s2,s2,1202 # ffffffffc02968c8 <current>
ffffffffc020641e:	00093783          	ld	a5,0(s2)
ffffffffc0206422:	21513c23          	sd	s5,536(sp)
ffffffffc0206426:	24813023          	sd	s0,576(sp)
ffffffffc020642a:	0287ba83          	ld	s5,40(a5)
ffffffffc020642e:	22913c23          	sd	s1,568(sp)
ffffffffc0206432:	21813023          	sd	s8,512(sp)
ffffffffc0206436:	84aa                	mv	s1,a0
ffffffffc0206438:	8c32                	mv	s8,a2
ffffffffc020643a:	842e                	mv	s0,a1
ffffffffc020643c:	08a8                	addi	a0,sp,88
ffffffffc020643e:	4641                	li	a2,16
ffffffffc0206440:	4581                	li	a1,0
ffffffffc0206442:	150050ef          	jal	ffffffffc020b592 <memset>
ffffffffc0206446:	000a8c63          	beqz	s5,ffffffffc020645e <do_execve+0x64>
ffffffffc020644a:	038a8513          	addi	a0,s5,56
ffffffffc020644e:	fcbfd0ef          	jal	ffffffffc0204418 <down>
ffffffffc0206452:	00093783          	ld	a5,0(s2)
ffffffffc0206456:	c781                	beqz	a5,ffffffffc020645e <do_execve+0x64>
ffffffffc0206458:	43dc                	lw	a5,4(a5)
ffffffffc020645a:	04faa823          	sw	a5,80(s5)
ffffffffc020645e:	1c048963          	beqz	s1,ffffffffc0206630 <do_execve+0x236>
ffffffffc0206462:	8626                	mv	a2,s1
ffffffffc0206464:	46c1                	li	a3,16
ffffffffc0206466:	08ac                	addi	a1,sp,88
ffffffffc0206468:	8556                	mv	a0,s5
ffffffffc020646a:	dbffd0ef          	jal	ffffffffc0204228 <copy_string>
ffffffffc020646e:	56050863          	beqz	a0,ffffffffc02069de <do_execve+0x5e4>
ffffffffc0206472:	23413023          	sd	s4,544(sp)
ffffffffc0206476:	fbea                	sd	s10,496(sp)
ffffffffc0206478:	00341d13          	slli	s10,s0,0x3
ffffffffc020647c:	866a                	mv	a2,s10
ffffffffc020647e:	4681                	li	a3,0
ffffffffc0206480:	85e2                	mv	a1,s8
ffffffffc0206482:	8556                	mv	a0,s5
ffffffffc0206484:	8a62                	mv	s4,s8
ffffffffc0206486:	c91fd0ef          	jal	ffffffffc0204116 <user_mem_check>
ffffffffc020648a:	6a050963          	beqz	a0,ffffffffc0206b3c <do_execve+0x742>
ffffffffc020648e:	23313423          	sd	s3,552(sp)
ffffffffc0206492:	21713423          	sd	s7,520(sp)
ffffffffc0206496:	4981                	li	s3,0
ffffffffc0206498:	0e010b93          	addi	s7,sp,224
ffffffffc020649c:	6505                	lui	a0,0x1
ffffffffc020649e:	bb3fb0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc02064a2:	84aa                	mv	s1,a0
ffffffffc02064a4:	10050863          	beqz	a0,ffffffffc02065b4 <do_execve+0x1ba>
ffffffffc02064a8:	000a3603          	ld	a2,0(s4)
ffffffffc02064ac:	85aa                	mv	a1,a0
ffffffffc02064ae:	6685                	lui	a3,0x1
ffffffffc02064b0:	8556                	mv	a0,s5
ffffffffc02064b2:	d77fd0ef          	jal	ffffffffc0204228 <copy_string>
ffffffffc02064b6:	16050863          	beqz	a0,ffffffffc0206626 <do_execve+0x22c>
ffffffffc02064ba:	009bb023          	sd	s1,0(s7)
ffffffffc02064be:	2985                	addiw	s3,s3,1
ffffffffc02064c0:	0ba1                	addi	s7,s7,8
ffffffffc02064c2:	0a21                	addi	s4,s4,8
ffffffffc02064c4:	fd341ce3          	bne	s0,s3,ffffffffc020649c <do_execve+0xa2>
ffffffffc02064c8:	ffe6                	sd	s9,504(sp)
ffffffffc02064ca:	000c3483          	ld	s1,0(s8)
ffffffffc02064ce:	0a0a8663          	beqz	s5,ffffffffc020657a <do_execve+0x180>
ffffffffc02064d2:	038a8513          	addi	a0,s5,56
ffffffffc02064d6:	f3ffd0ef          	jal	ffffffffc0204414 <up>
ffffffffc02064da:	00093783          	ld	a5,0(s2)
ffffffffc02064de:	040aa823          	sw	zero,80(s5)
ffffffffc02064e2:	1487b503          	ld	a0,328(a5)
ffffffffc02064e6:	c81fe0ef          	jal	ffffffffc0205166 <files_closeall>
ffffffffc02064ea:	8526                	mv	a0,s1
ffffffffc02064ec:	4581                	li	a1,0
ffffffffc02064ee:	f09fe0ef          	jal	ffffffffc02053f6 <sysfile_open>
ffffffffc02064f2:	8a2a                	mv	s4,a0
ffffffffc02064f4:	6c054463          	bltz	a0,ffffffffc0206bbc <do_execve+0x7c2>
ffffffffc02064f8:	00090797          	auipc	a5,0x90
ffffffffc02064fc:	3a07b783          	ld	a5,928(a5) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc0206500:	577d                	li	a4,-1
ffffffffc0206502:	177e                	slli	a4,a4,0x3f
ffffffffc0206504:	83b1                	srli	a5,a5,0xc
ffffffffc0206506:	8fd9                	or	a5,a5,a4
ffffffffc0206508:	18079073          	csrw	satp,a5
ffffffffc020650c:	030aa783          	lw	a5,48(s5)
ffffffffc0206510:	37fd                	addiw	a5,a5,-1
ffffffffc0206512:	02faa823          	sw	a5,48(s5)
ffffffffc0206516:	14078f63          	beqz	a5,ffffffffc0206674 <do_execve+0x27a>
ffffffffc020651a:	00093783          	ld	a5,0(s2)
ffffffffc020651e:	0207b423          	sd	zero,40(a5)
ffffffffc0206522:	d54fd0ef          	jal	ffffffffc0203a76 <mm_create>
ffffffffc0206526:	89aa                	mv	s3,a0
ffffffffc0206528:	5df1                	li	s11,-4
ffffffffc020652a:	c505                	beqz	a0,ffffffffc0206552 <do_execve+0x158>
ffffffffc020652c:	cd8ff0ef          	jal	ffffffffc0205a04 <setup_pgdir>
ffffffffc0206530:	5df1                	li	s11,-4
ffffffffc0206532:	ed09                	bnez	a0,ffffffffc020654c <do_execve+0x152>
ffffffffc0206534:	4601                	li	a2,0
ffffffffc0206536:	4581                	li	a1,0
ffffffffc0206538:	8552                	mv	a0,s4
ffffffffc020653a:	974ff0ef          	jal	ffffffffc02056ae <sysfile_seek>
ffffffffc020653e:	8daa                	mv	s11,a0
ffffffffc0206540:	10050963          	beqz	a0,ffffffffc0206652 <do_execve+0x258>
ffffffffc0206544:	0189b503          	ld	a0,24(s3)
ffffffffc0206548:	c44ff0ef          	jal	ffffffffc020598c <put_pgdir.isra.0>
ffffffffc020654c:	854e                	mv	a0,s3
ffffffffc020654e:	e74fd0ef          	jal	ffffffffc0203bc2 <mm_destroy>
ffffffffc0206552:	0d010913          	addi	s2,sp,208
ffffffffc0206556:	020b1713          	slli	a4,s6,0x20
ffffffffc020655a:	01d75793          	srli	a5,a4,0x1d
ffffffffc020655e:	996a                	add	s2,s2,s10
ffffffffc0206560:	09a0                	addi	s0,sp,216
ffffffffc0206562:	40f90933          	sub	s2,s2,a5
ffffffffc0206566:	946a                	add	s0,s0,s10
ffffffffc0206568:	6008                	ld	a0,0(s0)
ffffffffc020656a:	1461                	addi	s0,s0,-8
ffffffffc020656c:	b8bfb0ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc0206570:	ff241ce3          	bne	s0,s2,ffffffffc0206568 <do_execve+0x16e>
ffffffffc0206574:	856e                	mv	a0,s11
ffffffffc0206576:	9f3ff0ef          	jal	ffffffffc0205f68 <do_exit>
ffffffffc020657a:	00093783          	ld	a5,0(s2)
ffffffffc020657e:	1487b503          	ld	a0,328(a5)
ffffffffc0206582:	be5fe0ef          	jal	ffffffffc0205166 <files_closeall>
ffffffffc0206586:	8526                	mv	a0,s1
ffffffffc0206588:	4581                	li	a1,0
ffffffffc020658a:	e6dfe0ef          	jal	ffffffffc02053f6 <sysfile_open>
ffffffffc020658e:	8a2a                	mv	s4,a0
ffffffffc0206590:	0a054f63          	bltz	a0,ffffffffc020664e <do_execve+0x254>
ffffffffc0206594:	00093783          	ld	a5,0(s2)
ffffffffc0206598:	779c                	ld	a5,40(a5)
ffffffffc020659a:	d7c1                	beqz	a5,ffffffffc0206522 <do_execve+0x128>
ffffffffc020659c:	00007617          	auipc	a2,0x7
ffffffffc02065a0:	03c60613          	addi	a2,a2,60 # ffffffffc020d5d8 <etext+0x1fde>
ffffffffc02065a4:	2aa00593          	li	a1,682
ffffffffc02065a8:	00007517          	auipc	a0,0x7
ffffffffc02065ac:	e4050513          	addi	a0,a0,-448 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc02065b0:	e9bf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc02065b4:	5df1                	li	s11,-4
ffffffffc02065b6:	02098663          	beqz	s3,ffffffffc02065e2 <do_execve+0x1e8>
ffffffffc02065ba:	00399793          	slli	a5,s3,0x3
ffffffffc02065be:	39fd                	addiw	s3,s3,-1
ffffffffc02065c0:	0d010913          	addi	s2,sp,208
ffffffffc02065c4:	02099713          	slli	a4,s3,0x20
ffffffffc02065c8:	01d75993          	srli	s3,a4,0x1d
ffffffffc02065cc:	993e                	add	s2,s2,a5
ffffffffc02065ce:	09a0                	addi	s0,sp,216
ffffffffc02065d0:	41390933          	sub	s2,s2,s3
ffffffffc02065d4:	943e                	add	s0,s0,a5
ffffffffc02065d6:	6008                	ld	a0,0(s0)
ffffffffc02065d8:	1461                	addi	s0,s0,-8
ffffffffc02065da:	b1dfb0ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc02065de:	ff241ce3          	bne	s0,s2,ffffffffc02065d6 <do_execve+0x1dc>
ffffffffc02065e2:	22813983          	ld	s3,552(sp)
ffffffffc02065e6:	20813b83          	ld	s7,520(sp)
ffffffffc02065ea:	000a8863          	beqz	s5,ffffffffc02065fa <do_execve+0x200>
ffffffffc02065ee:	038a8513          	addi	a0,s5,56
ffffffffc02065f2:	e23fd0ef          	jal	ffffffffc0204414 <up>
ffffffffc02065f6:	040aa823          	sw	zero,80(s5)
ffffffffc02065fa:	24013403          	ld	s0,576(sp)
ffffffffc02065fe:	23813483          	ld	s1,568(sp)
ffffffffc0206602:	23013903          	ld	s2,560(sp)
ffffffffc0206606:	22013a03          	ld	s4,544(sp)
ffffffffc020660a:	21813a83          	ld	s5,536(sp)
ffffffffc020660e:	20013c03          	ld	s8,512(sp)
ffffffffc0206612:	7d5e                	ld	s10,496(sp)
ffffffffc0206614:	24813083          	ld	ra,584(sp)
ffffffffc0206618:	21013b03          	ld	s6,528(sp)
ffffffffc020661c:	856e                	mv	a0,s11
ffffffffc020661e:	7dbe                	ld	s11,488(sp)
ffffffffc0206620:	25010113          	addi	sp,sp,592
ffffffffc0206624:	8082                	ret
ffffffffc0206626:	8526                	mv	a0,s1
ffffffffc0206628:	acffb0ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc020662c:	5df5                	li	s11,-3
ffffffffc020662e:	b761                	j	ffffffffc02065b6 <do_execve+0x1bc>
ffffffffc0206630:	00093783          	ld	a5,0(s2)
ffffffffc0206634:	00007617          	auipc	a2,0x7
ffffffffc0206638:	f9460613          	addi	a2,a2,-108 # ffffffffc020d5c8 <etext+0x1fce>
ffffffffc020663c:	45c1                	li	a1,16
ffffffffc020663e:	43d4                	lw	a3,4(a5)
ffffffffc0206640:	08a8                	addi	a0,sp,88
ffffffffc0206642:	23413023          	sd	s4,544(sp)
ffffffffc0206646:	fbea                	sd	s10,496(sp)
ffffffffc0206648:	649040ef          	jal	ffffffffc020b490 <snprintf>
ffffffffc020664c:	b535                	j	ffffffffc0206478 <do_execve+0x7e>
ffffffffc020664e:	8daa                	mv	s11,a0
ffffffffc0206650:	b709                	j	ffffffffc0206552 <do_execve+0x158>
ffffffffc0206652:	04000613          	li	a2,64
ffffffffc0206656:	110c                	addi	a1,sp,160
ffffffffc0206658:	8552                	mv	a0,s4
ffffffffc020665a:	dd7fe0ef          	jal	ffffffffc0205430 <sysfile_read>
ffffffffc020665e:	04000793          	li	a5,64
ffffffffc0206662:	02f50463          	beq	a0,a5,ffffffffc020668a <do_execve+0x290>
ffffffffc0206666:	84aa                	mv	s1,a0
ffffffffc0206668:	00054363          	bltz	a0,ffffffffc020666e <do_execve+0x274>
ffffffffc020666c:	54fd                	li	s1,-1
ffffffffc020666e:	00048d9b          	sext.w	s11,s1
ffffffffc0206672:	bdc9                	j	ffffffffc0206544 <do_execve+0x14a>
ffffffffc0206674:	8556                	mv	a0,s5
ffffffffc0206676:	f02fd0ef          	jal	ffffffffc0203d78 <exit_mmap>
ffffffffc020667a:	018ab503          	ld	a0,24(s5)
ffffffffc020667e:	b0eff0ef          	jal	ffffffffc020598c <put_pgdir.isra.0>
ffffffffc0206682:	8556                	mv	a0,s5
ffffffffc0206684:	d3efd0ef          	jal	ffffffffc0203bc2 <mm_destroy>
ffffffffc0206688:	bd49                	j	ffffffffc020651a <do_execve+0x120>
ffffffffc020668a:	570a                	lw	a4,160(sp)
ffffffffc020668c:	464c47b7          	lui	a5,0x464c4
ffffffffc0206690:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_bin_sfs_img_size+0x4644f27f>
ffffffffc0206694:	32f71163          	bne	a4,a5,ffffffffc02069b6 <do_execve+0x5bc>
ffffffffc0206698:	0d815783          	lhu	a5,216(sp)
ffffffffc020669c:	cba5                	beqz	a5,ffffffffc020670c <do_execve+0x312>
ffffffffc020669e:	f402                	sd	zero,40(sp)
ffffffffc02066a0:	4a81                	li	s5,0
ffffffffc02066a2:	e082                	sd	zero,64(sp)
ffffffffc02066a4:	f06a                	sd	s10,32(sp)
ffffffffc02066a6:	e452                	sd	s4,8(sp)
ffffffffc02066a8:	e4a2                	sd	s0,72(sp)
ffffffffc02066aa:	658e                	ld	a1,192(sp)
ffffffffc02066ac:	6422                	ld	s0,8(sp)
ffffffffc02066ae:	77a2                	ld	a5,40(sp)
ffffffffc02066b0:	4601                	li	a2,0
ffffffffc02066b2:	8522                	mv	a0,s0
ffffffffc02066b4:	95be                	add	a1,a1,a5
ffffffffc02066b6:	ff9fe0ef          	jal	ffffffffc02056ae <sysfile_seek>
ffffffffc02066ba:	20051763          	bnez	a0,ffffffffc02068c8 <do_execve+0x4ce>
ffffffffc02066be:	03800613          	li	a2,56
ffffffffc02066c2:	10ac                	addi	a1,sp,104
ffffffffc02066c4:	8522                	mv	a0,s0
ffffffffc02066c6:	d6bfe0ef          	jal	ffffffffc0205430 <sysfile_read>
ffffffffc02066ca:	03800793          	li	a5,56
ffffffffc02066ce:	00f50d63          	beq	a0,a5,ffffffffc02066e8 <do_execve+0x2ee>
ffffffffc02066d2:	7d02                	ld	s10,32(sp)
ffffffffc02066d4:	84aa                	mv	s1,a0
ffffffffc02066d6:	00054363          	bltz	a0,ffffffffc02066dc <do_execve+0x2e2>
ffffffffc02066da:	54fd                	li	s1,-1
ffffffffc02066dc:	00048d9b          	sext.w	s11,s1
ffffffffc02066e0:	854e                	mv	a0,s3
ffffffffc02066e2:	e96fd0ef          	jal	ffffffffc0203d78 <exit_mmap>
ffffffffc02066e6:	bdb9                	j	ffffffffc0206544 <do_execve+0x14a>
ffffffffc02066e8:	57a6                	lw	a5,104(sp)
ffffffffc02066ea:	4705                	li	a4,1
ffffffffc02066ec:	1ee78163          	beq	a5,a4,ffffffffc02068ce <do_execve+0x4d4>
ffffffffc02066f0:	6706                	ld	a4,64(sp)
ffffffffc02066f2:	76a2                	ld	a3,40(sp)
ffffffffc02066f4:	0d815783          	lhu	a5,216(sp)
ffffffffc02066f8:	2705                	addiw	a4,a4,1
ffffffffc02066fa:	03868693          	addi	a3,a3,56 # 1038 <_binary_bin_swap_img_size-0x6cc8>
ffffffffc02066fe:	e0ba                	sd	a4,64(sp)
ffffffffc0206700:	f436                	sd	a3,40(sp)
ffffffffc0206702:	faf764e3          	bltu	a4,a5,ffffffffc02066aa <do_execve+0x2b0>
ffffffffc0206706:	7d02                	ld	s10,32(sp)
ffffffffc0206708:	6a22                	ld	s4,8(sp)
ffffffffc020670a:	6426                	ld	s0,72(sp)
ffffffffc020670c:	8552                	mv	a0,s4
ffffffffc020670e:	d1ffe0ef          	jal	ffffffffc020542c <sysfile_close>
ffffffffc0206712:	854e                	mv	a0,s3
ffffffffc0206714:	4701                	li	a4,0
ffffffffc0206716:	46ad                	li	a3,11
ffffffffc0206718:	00100637          	lui	a2,0x100
ffffffffc020671c:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0206720:	cf4fd0ef          	jal	ffffffffc0203c14 <mm_map>
ffffffffc0206724:	8daa                	mv	s11,a0
ffffffffc0206726:	fd4d                	bnez	a0,ffffffffc02066e0 <do_execve+0x2e6>
ffffffffc0206728:	0189b503          	ld	a0,24(s3)
ffffffffc020672c:	467d                	li	a2,31
ffffffffc020672e:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0206732:	a62fd0ef          	jal	ffffffffc0203994 <pgdir_alloc_page>
ffffffffc0206736:	4e050563          	beqz	a0,ffffffffc0206c20 <do_execve+0x826>
ffffffffc020673a:	0189b503          	ld	a0,24(s3)
ffffffffc020673e:	467d                	li	a2,31
ffffffffc0206740:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0206744:	a50fd0ef          	jal	ffffffffc0203994 <pgdir_alloc_page>
ffffffffc0206748:	4a050c63          	beqz	a0,ffffffffc0206c00 <do_execve+0x806>
ffffffffc020674c:	0189b503          	ld	a0,24(s3)
ffffffffc0206750:	467d                	li	a2,31
ffffffffc0206752:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0206756:	a3efd0ef          	jal	ffffffffc0203994 <pgdir_alloc_page>
ffffffffc020675a:	48050363          	beqz	a0,ffffffffc0206be0 <do_execve+0x7e6>
ffffffffc020675e:	0189b503          	ld	a0,24(s3)
ffffffffc0206762:	467d                	li	a2,31
ffffffffc0206764:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0206768:	a2cfd0ef          	jal	ffffffffc0203994 <pgdir_alloc_page>
ffffffffc020676c:	44050a63          	beqz	a0,ffffffffc0206bc0 <do_execve+0x7c6>
ffffffffc0206770:	0309a783          	lw	a5,48(s3)
ffffffffc0206774:	00093603          	ld	a2,0(s2)
ffffffffc0206778:	0189b683          	ld	a3,24(s3)
ffffffffc020677c:	2785                	addiw	a5,a5,1
ffffffffc020677e:	02f9a823          	sw	a5,48(s3)
ffffffffc0206782:	03363423          	sd	s3,40(a2) # 100028 <_binary_bin_sfs_img_size+0x8ad28>
ffffffffc0206786:	c02007b7          	lui	a5,0xc0200
ffffffffc020678a:	40f6e063          	bltu	a3,a5,ffffffffc0206b8a <do_execve+0x790>
ffffffffc020678e:	00090797          	auipc	a5,0x90
ffffffffc0206792:	11a7b783          	ld	a5,282(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0206796:	577d                	li	a4,-1
ffffffffc0206798:	177e                	slli	a4,a4,0x3f
ffffffffc020679a:	8e9d                	sub	a3,a3,a5
ffffffffc020679c:	00c6d793          	srli	a5,a3,0xc
ffffffffc02067a0:	f654                	sd	a3,168(a2)
ffffffffc02067a2:	8fd9                	or	a5,a5,a4
ffffffffc02067a4:	18079073          	csrw	satp,a5
ffffffffc02067a8:	4a01                	li	s4,0
ffffffffc02067aa:	0e010a93          	addi	s5,sp,224
ffffffffc02067ae:	4981                	li	s3,0
ffffffffc02067b0:	000ab503          	ld	a0,0(s5)
ffffffffc02067b4:	6585                	lui	a1,0x1
ffffffffc02067b6:	2985                	addiw	s3,s3,1
ffffffffc02067b8:	53f040ef          	jal	ffffffffc020b4f6 <strnlen>
ffffffffc02067bc:	00150793          	addi	a5,a0,1
ffffffffc02067c0:	0aa1                	addi	s5,s5,8
ffffffffc02067c2:	01478a3b          	addw	s4,a5,s4
ffffffffc02067c6:	fe89e5e3          	bltu	s3,s0,ffffffffc02067b0 <do_execve+0x3b6>
ffffffffc02067ca:	100009b7          	lui	s3,0x10000
ffffffffc02067ce:	003a5a1b          	srliw	s4,s4,0x3
ffffffffc02067d2:	19fd                	addi	s3,s3,-1 # fffffff <_binary_bin_sfs_img_size+0xff8acff>
ffffffffc02067d4:	414989b3          	sub	s3,s3,s4
ffffffffc02067d8:	098e                	slli	s3,s3,0x3
ffffffffc02067da:	119c                	addi	a5,sp,224
ffffffffc02067dc:	41a98ab3          	sub	s5,s3,s10
ffffffffc02067e0:	40fa8c33          	sub	s8,s5,a5
ffffffffc02067e4:	8a3e                	mv	s4,a5
ffffffffc02067e6:	4c81                	li	s9,0
ffffffffc02067e8:	4b81                	li	s7,0
ffffffffc02067ea:	000a3483          	ld	s1,0(s4)
ffffffffc02067ee:	020b9513          	slli	a0,s7,0x20
ffffffffc02067f2:	9101                	srli	a0,a0,0x20
ffffffffc02067f4:	85a6                	mv	a1,s1
ffffffffc02067f6:	954e                	add	a0,a0,s3
ffffffffc02067f8:	51b040ef          	jal	ffffffffc020b512 <strcpy>
ffffffffc02067fc:	014c07b3          	add	a5,s8,s4
ffffffffc0206800:	872a                	mv	a4,a0
ffffffffc0206802:	e398                	sd	a4,0(a5)
ffffffffc0206804:	8526                	mv	a0,s1
ffffffffc0206806:	6585                	lui	a1,0x1
ffffffffc0206808:	4ef040ef          	jal	ffffffffc020b4f6 <strnlen>
ffffffffc020680c:	00150793          	addi	a5,a0,1
ffffffffc0206810:	2c85                	addiw	s9,s9,1
ffffffffc0206812:	0a21                	addi	s4,s4,8
ffffffffc0206814:	01778bbb          	addw	s7,a5,s7
ffffffffc0206818:	fc8ce9e3          	bltu	s9,s0,ffffffffc02067ea <do_execve+0x3f0>
ffffffffc020681c:	00093783          	ld	a5,0(s2)
ffffffffc0206820:	fe8aae23          	sw	s0,-4(s5)
ffffffffc0206824:	12000613          	li	a2,288
ffffffffc0206828:	0a07ba03          	ld	s4,160(a5)
ffffffffc020682c:	4581                	li	a1,0
ffffffffc020682e:	1af1                	addi	s5,s5,-4
ffffffffc0206830:	100a3403          	ld	s0,256(s4)
ffffffffc0206834:	8552                	mv	a0,s4
ffffffffc0206836:	55d040ef          	jal	ffffffffc020b592 <memset>
ffffffffc020683a:	776a                	ld	a4,184(sp)
ffffffffc020683c:	edf47793          	andi	a5,s0,-289
ffffffffc0206840:	0d010993          	addi	s3,sp,208
ffffffffc0206844:	020b1613          	slli	a2,s6,0x20
ffffffffc0206848:	0207e793          	ori	a5,a5,32
ffffffffc020684c:	ff8afa93          	andi	s5,s5,-8
ffffffffc0206850:	01d65693          	srli	a3,a2,0x1d
ffffffffc0206854:	99ea                	add	s3,s3,s10
ffffffffc0206856:	09a0                	addi	s0,sp,216
ffffffffc0206858:	10fa3023          	sd	a5,256(s4)
ffffffffc020685c:	015a3823          	sd	s5,16(s4)
ffffffffc0206860:	40d989b3          	sub	s3,s3,a3
ffffffffc0206864:	946a                	add	s0,s0,s10
ffffffffc0206866:	10ea3423          	sd	a4,264(s4)
ffffffffc020686a:	6008                	ld	a0,0(s0)
ffffffffc020686c:	1461                	addi	s0,s0,-8
ffffffffc020686e:	889fb0ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc0206872:	ff341ce3          	bne	s0,s3,ffffffffc020686a <do_execve+0x470>
ffffffffc0206876:	00093403          	ld	s0,0(s2)
ffffffffc020687a:	4641                	li	a2,16
ffffffffc020687c:	4581                	li	a1,0
ffffffffc020687e:	0b440413          	addi	s0,s0,180
ffffffffc0206882:	8522                	mv	a0,s0
ffffffffc0206884:	50f040ef          	jal	ffffffffc020b592 <memset>
ffffffffc0206888:	08ac                	addi	a1,sp,88
ffffffffc020688a:	8522                	mv	a0,s0
ffffffffc020688c:	463d                	li	a2,15
ffffffffc020688e:	555040ef          	jal	ffffffffc020b5e2 <memcpy>
ffffffffc0206892:	24813083          	ld	ra,584(sp)
ffffffffc0206896:	24013403          	ld	s0,576(sp)
ffffffffc020689a:	23813483          	ld	s1,568(sp)
ffffffffc020689e:	23013903          	ld	s2,560(sp)
ffffffffc02068a2:	22813983          	ld	s3,552(sp)
ffffffffc02068a6:	22013a03          	ld	s4,544(sp)
ffffffffc02068aa:	21813a83          	ld	s5,536(sp)
ffffffffc02068ae:	20813b83          	ld	s7,520(sp)
ffffffffc02068b2:	20013c03          	ld	s8,512(sp)
ffffffffc02068b6:	7cfe                	ld	s9,504(sp)
ffffffffc02068b8:	7d5e                	ld	s10,496(sp)
ffffffffc02068ba:	21013b03          	ld	s6,528(sp)
ffffffffc02068be:	856e                	mv	a0,s11
ffffffffc02068c0:	7dbe                	ld	s11,488(sp)
ffffffffc02068c2:	25010113          	addi	sp,sp,592
ffffffffc02068c6:	8082                	ret
ffffffffc02068c8:	7d02                	ld	s10,32(sp)
ffffffffc02068ca:	8daa                	mv	s11,a0
ffffffffc02068cc:	bd11                	j	ffffffffc02066e0 <do_execve+0x2e6>
ffffffffc02068ce:	664a                	ld	a2,144(sp)
ffffffffc02068d0:	67aa                	ld	a5,136(sp)
ffffffffc02068d2:	26f66c63          	bltu	a2,a5,ffffffffc0206b4a <do_execve+0x750>
ffffffffc02068d6:	57b6                	lw	a5,108(sp)
ffffffffc02068d8:	0027971b          	slliw	a4,a5,0x2
ffffffffc02068dc:	0027f693          	andi	a3,a5,2
ffffffffc02068e0:	8b11                	andi	a4,a4,4
ffffffffc02068e2:	8b91                	andi	a5,a5,4
ffffffffc02068e4:	caf9                	beqz	a3,ffffffffc02069ba <do_execve+0x5c0>
ffffffffc02068e6:	24079463          	bnez	a5,ffffffffc0206b2e <do_execve+0x734>
ffffffffc02068ea:	47dd                	li	a5,23
ffffffffc02068ec:	00276693          	ori	a3,a4,2
ffffffffc02068f0:	ec3e                	sd	a5,24(sp)
ffffffffc02068f2:	c709                	beqz	a4,ffffffffc02068fc <do_execve+0x502>
ffffffffc02068f4:	67e2                	ld	a5,24(sp)
ffffffffc02068f6:	0087e793          	ori	a5,a5,8
ffffffffc02068fa:	ec3e                	sd	a5,24(sp)
ffffffffc02068fc:	75e6                	ld	a1,120(sp)
ffffffffc02068fe:	4701                	li	a4,0
ffffffffc0206900:	854e                	mv	a0,s3
ffffffffc0206902:	b12fd0ef          	jal	ffffffffc0203c14 <mm_map>
ffffffffc0206906:	f169                	bnez	a0,ffffffffc02068c8 <do_execve+0x4ce>
ffffffffc0206908:	74e6                	ld	s1,120(sp)
ffffffffc020690a:	662a                	ld	a2,136(sp)
ffffffffc020690c:	77fd                	lui	a5,0xfffff
ffffffffc020690e:	00f4fa33          	and	s4,s1,a5
ffffffffc0206912:	00c48c33          	add	s8,s1,a2
ffffffffc0206916:	2384f763          	bgeu	s1,s8,ffffffffc0206b44 <do_execve+0x74a>
ffffffffc020691a:	577d                	li	a4,-1
ffffffffc020691c:	7bc6                	ld	s7,112(sp)
ffffffffc020691e:	00c75793          	srli	a5,a4,0xc
ffffffffc0206922:	f83e                	sd	a5,48(sp)
ffffffffc0206924:	00090d97          	auipc	s11,0x90
ffffffffc0206928:	f94d8d93          	addi	s11,s11,-108 # ffffffffc02968b8 <pages>
ffffffffc020692c:	00009c97          	auipc	s9,0x9
ffffffffc0206930:	efcc8c93          	addi	s9,s9,-260 # ffffffffc020f828 <nbase>
ffffffffc0206934:	fc5a                	sd	s6,56(sp)
ffffffffc0206936:	e84e                	sd	s3,16(sp)
ffffffffc0206938:	67c2                	ld	a5,16(sp)
ffffffffc020693a:	6662                	ld	a2,24(sp)
ffffffffc020693c:	85d2                	mv	a1,s4
ffffffffc020693e:	6f88                	ld	a0,24(a5)
ffffffffc0206940:	854fd0ef          	jal	ffffffffc0203994 <pgdir_alloc_page>
ffffffffc0206944:	8d2a                	mv	s10,a0
ffffffffc0206946:	c161                	beqz	a0,ffffffffc0206a06 <do_execve+0x60c>
ffffffffc0206948:	6785                	lui	a5,0x1
ffffffffc020694a:	00fa0b33          	add	s6,s4,a5
ffffffffc020694e:	409c09b3          	sub	s3,s8,s1
ffffffffc0206952:	016c6463          	bltu	s8,s6,ffffffffc020695a <do_execve+0x560>
ffffffffc0206956:	409b09b3          	sub	s3,s6,s1
ffffffffc020695a:	000db403          	ld	s0,0(s11)
ffffffffc020695e:	000cb583          	ld	a1,0(s9)
ffffffffc0206962:	77c2                	ld	a5,48(sp)
ffffffffc0206964:	408d0433          	sub	s0,s10,s0
ffffffffc0206968:	8419                	srai	s0,s0,0x6
ffffffffc020696a:	00090617          	auipc	a2,0x90
ffffffffc020696e:	f4663603          	ld	a2,-186(a2) # ffffffffc02968b0 <npage>
ffffffffc0206972:	942e                	add	s0,s0,a1
ffffffffc0206974:	00f475b3          	and	a1,s0,a5
ffffffffc0206978:	0432                	slli	s0,s0,0xc
ffffffffc020697a:	22c5f463          	bgeu	a1,a2,ffffffffc0206ba2 <do_execve+0x7a8>
ffffffffc020697e:	6522                	ld	a0,8(sp)
ffffffffc0206980:	4601                	li	a2,0
ffffffffc0206982:	85de                	mv	a1,s7
ffffffffc0206984:	00090a97          	auipc	s5,0x90
ffffffffc0206988:	f24aba83          	ld	s5,-220(s5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc020698c:	d23fe0ef          	jal	ffffffffc02056ae <sysfile_seek>
ffffffffc0206990:	e131                	bnez	a0,ffffffffc02069d4 <do_execve+0x5da>
ffffffffc0206992:	6522                	ld	a0,8(sp)
ffffffffc0206994:	9aa2                	add	s5,s5,s0
ffffffffc0206996:	414485b3          	sub	a1,s1,s4
ffffffffc020699a:	95d6                	add	a1,a1,s5
ffffffffc020699c:	864e                	mv	a2,s3
ffffffffc020699e:	a93fe0ef          	jal	ffffffffc0205430 <sysfile_read>
ffffffffc02069a2:	02a98363          	beq	s3,a0,ffffffffc02069c8 <do_execve+0x5ce>
ffffffffc02069a6:	7d02                	ld	s10,32(sp)
ffffffffc02069a8:	7b62                	ld	s6,56(sp)
ffffffffc02069aa:	69c2                	ld	s3,16(sp)
ffffffffc02069ac:	84aa                	mv	s1,a0
ffffffffc02069ae:	d20547e3          	bltz	a0,ffffffffc02066dc <do_execve+0x2e2>
ffffffffc02069b2:	54fd                	li	s1,-1
ffffffffc02069b4:	b325                	j	ffffffffc02066dc <do_execve+0x2e2>
ffffffffc02069b6:	5de1                	li	s11,-8
ffffffffc02069b8:	b671                	j	ffffffffc0206544 <do_execve+0x14a>
ffffffffc02069ba:	16078663          	beqz	a5,ffffffffc0206b26 <do_execve+0x72c>
ffffffffc02069be:	47cd                	li	a5,19
ffffffffc02069c0:	00176693          	ori	a3,a4,1
ffffffffc02069c4:	ec3e                	sd	a5,24(sp)
ffffffffc02069c6:	b735                	j	ffffffffc02068f2 <do_execve+0x4f8>
ffffffffc02069c8:	94ce                	add	s1,s1,s3
ffffffffc02069ca:	9bce                	add	s7,s7,s3
ffffffffc02069cc:	0584f263          	bgeu	s1,s8,ffffffffc0206a10 <do_execve+0x616>
ffffffffc02069d0:	8a5a                	mv	s4,s6
ffffffffc02069d2:	b79d                	j	ffffffffc0206938 <do_execve+0x53e>
ffffffffc02069d4:	7d02                	ld	s10,32(sp)
ffffffffc02069d6:	7b62                	ld	s6,56(sp)
ffffffffc02069d8:	69c2                	ld	s3,16(sp)
ffffffffc02069da:	8daa                	mv	s11,a0
ffffffffc02069dc:	b311                	j	ffffffffc02066e0 <do_execve+0x2e6>
ffffffffc02069de:	000a8863          	beqz	s5,ffffffffc02069ee <do_execve+0x5f4>
ffffffffc02069e2:	038a8513          	addi	a0,s5,56
ffffffffc02069e6:	a2ffd0ef          	jal	ffffffffc0204414 <up>
ffffffffc02069ea:	040aa823          	sw	zero,80(s5)
ffffffffc02069ee:	24013403          	ld	s0,576(sp)
ffffffffc02069f2:	23813483          	ld	s1,568(sp)
ffffffffc02069f6:	23013903          	ld	s2,560(sp)
ffffffffc02069fa:	21813a83          	ld	s5,536(sp)
ffffffffc02069fe:	20013c03          	ld	s8,512(sp)
ffffffffc0206a02:	5df5                	li	s11,-3
ffffffffc0206a04:	b901                	j	ffffffffc0206614 <do_execve+0x21a>
ffffffffc0206a06:	7d02                	ld	s10,32(sp)
ffffffffc0206a08:	7b62                	ld	s6,56(sp)
ffffffffc0206a0a:	69c2                	ld	s3,16(sp)
ffffffffc0206a0c:	5df1                	li	s11,-4
ffffffffc0206a0e:	b9c9                	j	ffffffffc02066e0 <do_execve+0x2e6>
ffffffffc0206a10:	8aea                	mv	s5,s10
ffffffffc0206a12:	69c2                	ld	s3,16(sp)
ffffffffc0206a14:	8d5a                	mv	s10,s6
ffffffffc0206a16:	7866                	ld	a6,120(sp)
ffffffffc0206a18:	7b62                	ld	s6,56(sp)
ffffffffc0206a1a:	66ca                	ld	a3,144(sp)
ffffffffc0206a1c:	00d80433          	add	s0,a6,a3
ffffffffc0206a20:	07a4f863          	bgeu	s1,s10,ffffffffc0206a90 <do_execve+0x696>
ffffffffc0206a24:	cc9406e3          	beq	s0,s1,ffffffffc02066f0 <do_execve+0x2f6>
ffffffffc0206a28:	40940a33          	sub	s4,s0,s1
ffffffffc0206a2c:	01a46463          	bltu	s0,s10,ffffffffc0206a34 <do_execve+0x63a>
ffffffffc0206a30:	409d0a33          	sub	s4,s10,s1
ffffffffc0206a34:	00090697          	auipc	a3,0x90
ffffffffc0206a38:	e846b683          	ld	a3,-380(a3) # ffffffffc02968b8 <pages>
ffffffffc0206a3c:	00009617          	auipc	a2,0x9
ffffffffc0206a40:	dec63603          	ld	a2,-532(a2) # ffffffffc020f828 <nbase>
ffffffffc0206a44:	00090597          	auipc	a1,0x90
ffffffffc0206a48:	e6c5b583          	ld	a1,-404(a1) # ffffffffc02968b0 <npage>
ffffffffc0206a4c:	40da86b3          	sub	a3,s5,a3
ffffffffc0206a50:	8699                	srai	a3,a3,0x6
ffffffffc0206a52:	96b2                	add	a3,a3,a2
ffffffffc0206a54:	00c69613          	slli	a2,a3,0xc
ffffffffc0206a58:	8231                	srli	a2,a2,0xc
ffffffffc0206a5a:	06b2                	slli	a3,a3,0xc
ffffffffc0206a5c:	0eb67b63          	bgeu	a2,a1,ffffffffc0206b52 <do_execve+0x758>
ffffffffc0206a60:	00090617          	auipc	a2,0x90
ffffffffc0206a64:	e4863603          	ld	a2,-440(a2) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0206a68:	6505                	lui	a0,0x1
ffffffffc0206a6a:	9526                	add	a0,a0,s1
ffffffffc0206a6c:	96b2                	add	a3,a3,a2
ffffffffc0206a6e:	41a50533          	sub	a0,a0,s10
ffffffffc0206a72:	9536                	add	a0,a0,a3
ffffffffc0206a74:	8652                	mv	a2,s4
ffffffffc0206a76:	4581                	li	a1,0
ffffffffc0206a78:	31b040ef          	jal	ffffffffc020b592 <memset>
ffffffffc0206a7c:	94d2                	add	s1,s1,s4
ffffffffc0206a7e:	01a436b3          	sltu	a3,s0,s10
ffffffffc0206a82:	01a47463          	bgeu	s0,s10,ffffffffc0206a8a <do_execve+0x690>
ffffffffc0206a86:	c69405e3          	beq	s0,s1,ffffffffc02066f0 <do_execve+0x2f6>
ffffffffc0206a8a:	e2e5                	bnez	a3,ffffffffc0206b6a <do_execve+0x770>
ffffffffc0206a8c:	0da49f63          	bne	s1,s10,ffffffffc0206b6a <do_execve+0x770>
ffffffffc0206a90:	c684f0e3          	bgeu	s1,s0,ffffffffc02066f0 <do_execve+0x2f6>
ffffffffc0206a94:	57fd                	li	a5,-1
ffffffffc0206a96:	83b1                	srli	a5,a5,0xc
ffffffffc0206a98:	e83e                	sd	a5,16(sp)
ffffffffc0206a9a:	00090c97          	auipc	s9,0x90
ffffffffc0206a9e:	e1ec8c93          	addi	s9,s9,-482 # ffffffffc02968b8 <pages>
ffffffffc0206aa2:	00009c17          	auipc	s8,0x9
ffffffffc0206aa6:	d86c0c13          	addi	s8,s8,-634 # ffffffffc020f828 <nbase>
ffffffffc0206aaa:	00090b97          	auipc	s7,0x90
ffffffffc0206aae:	e06b8b93          	addi	s7,s7,-506 # ffffffffc02968b0 <npage>
ffffffffc0206ab2:	00090d97          	auipc	s11,0x90
ffffffffc0206ab6:	df6d8d93          	addi	s11,s11,-522 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0206aba:	f85a                	sd	s6,48(sp)
ffffffffc0206abc:	a889                	j	ffffffffc0206b0e <do_execve+0x714>
ffffffffc0206abe:	6785                	lui	a5,0x1
ffffffffc0206ac0:	00fd0a33          	add	s4,s10,a5
ffffffffc0206ac4:	40940b33          	sub	s6,s0,s1
ffffffffc0206ac8:	01446463          	bltu	s0,s4,ffffffffc0206ad0 <do_execve+0x6d6>
ffffffffc0206acc:	409a0b33          	sub	s6,s4,s1
ffffffffc0206ad0:	000cb783          	ld	a5,0(s9)
ffffffffc0206ad4:	000c3583          	ld	a1,0(s8)
ffffffffc0206ad8:	6742                	ld	a4,16(sp)
ffffffffc0206ada:	40fa87b3          	sub	a5,s5,a5
ffffffffc0206ade:	8799                	srai	a5,a5,0x6
ffffffffc0206ae0:	000bb683          	ld	a3,0(s7)
ffffffffc0206ae4:	97ae                	add	a5,a5,a1
ffffffffc0206ae6:	00e7f5b3          	and	a1,a5,a4
ffffffffc0206aea:	07b2                	slli	a5,a5,0xc
ffffffffc0206aec:	06d5f263          	bgeu	a1,a3,ffffffffc0206b50 <do_execve+0x756>
ffffffffc0206af0:	000db683          	ld	a3,0(s11)
ffffffffc0206af4:	41a48d33          	sub	s10,s1,s10
ffffffffc0206af8:	865a                	mv	a2,s6
ffffffffc0206afa:	97b6                	add	a5,a5,a3
ffffffffc0206afc:	01a78533          	add	a0,a5,s10
ffffffffc0206b00:	4581                	li	a1,0
ffffffffc0206b02:	94da                	add	s1,s1,s6
ffffffffc0206b04:	28f040ef          	jal	ffffffffc020b592 <memset>
ffffffffc0206b08:	0284f863          	bgeu	s1,s0,ffffffffc0206b38 <do_execve+0x73e>
ffffffffc0206b0c:	8d52                	mv	s10,s4
ffffffffc0206b0e:	0189b503          	ld	a0,24(s3)
ffffffffc0206b12:	6662                	ld	a2,24(sp)
ffffffffc0206b14:	85ea                	mv	a1,s10
ffffffffc0206b16:	e7ffc0ef          	jal	ffffffffc0203994 <pgdir_alloc_page>
ffffffffc0206b1a:	8aaa                	mv	s5,a0
ffffffffc0206b1c:	f14d                	bnez	a0,ffffffffc0206abe <do_execve+0x6c4>
ffffffffc0206b1e:	7d02                	ld	s10,32(sp)
ffffffffc0206b20:	7b42                	ld	s6,48(sp)
ffffffffc0206b22:	5df1                	li	s11,-4
ffffffffc0206b24:	be75                	j	ffffffffc02066e0 <do_execve+0x2e6>
ffffffffc0206b26:	47c5                	li	a5,17
ffffffffc0206b28:	86ba                	mv	a3,a4
ffffffffc0206b2a:	ec3e                	sd	a5,24(sp)
ffffffffc0206b2c:	b3d9                	j	ffffffffc02068f2 <do_execve+0x4f8>
ffffffffc0206b2e:	47dd                	li	a5,23
ffffffffc0206b30:	00376693          	ori	a3,a4,3
ffffffffc0206b34:	ec3e                	sd	a5,24(sp)
ffffffffc0206b36:	bb75                	j	ffffffffc02068f2 <do_execve+0x4f8>
ffffffffc0206b38:	7b42                	ld	s6,48(sp)
ffffffffc0206b3a:	be5d                	j	ffffffffc02066f0 <do_execve+0x2f6>
ffffffffc0206b3c:	5df5                	li	s11,-3
ffffffffc0206b3e:	aa0a98e3          	bnez	s5,ffffffffc02065ee <do_execve+0x1f4>
ffffffffc0206b42:	bc65                	j	ffffffffc02065fa <do_execve+0x200>
ffffffffc0206b44:	8d52                	mv	s10,s4
ffffffffc0206b46:	8826                	mv	a6,s1
ffffffffc0206b48:	bdc9                	j	ffffffffc0206a1a <do_execve+0x620>
ffffffffc0206b4a:	7d02                	ld	s10,32(sp)
ffffffffc0206b4c:	5de1                	li	s11,-8
ffffffffc0206b4e:	be49                	j	ffffffffc02066e0 <do_execve+0x2e6>
ffffffffc0206b50:	86be                	mv	a3,a5
ffffffffc0206b52:	00006617          	auipc	a2,0x6
ffffffffc0206b56:	95e60613          	addi	a2,a2,-1698 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc0206b5a:	07100593          	li	a1,113
ffffffffc0206b5e:	00006517          	auipc	a0,0x6
ffffffffc0206b62:	97a50513          	addi	a0,a0,-1670 # ffffffffc020c4d8 <etext+0xede>
ffffffffc0206b66:	8e5f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206b6a:	00007697          	auipc	a3,0x7
ffffffffc0206b6e:	a9668693          	addi	a3,a3,-1386 # ffffffffc020d600 <etext+0x2006>
ffffffffc0206b72:	00005617          	auipc	a2,0x5
ffffffffc0206b76:	ec660613          	addi	a2,a2,-314 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0206b7a:	30f00593          	li	a1,783
ffffffffc0206b7e:	00007517          	auipc	a0,0x7
ffffffffc0206b82:	86a50513          	addi	a0,a0,-1942 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206b86:	8c5f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206b8a:	00006617          	auipc	a2,0x6
ffffffffc0206b8e:	9ce60613          	addi	a2,a2,-1586 # ffffffffc020c558 <etext+0xf5e>
ffffffffc0206b92:	32f00593          	li	a1,815
ffffffffc0206b96:	00007517          	auipc	a0,0x7
ffffffffc0206b9a:	85250513          	addi	a0,a0,-1966 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206b9e:	8adf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206ba2:	86a2                	mv	a3,s0
ffffffffc0206ba4:	00006617          	auipc	a2,0x6
ffffffffc0206ba8:	90c60613          	addi	a2,a2,-1780 # ffffffffc020c4b0 <etext+0xeb6>
ffffffffc0206bac:	07100593          	li	a1,113
ffffffffc0206bb0:	00006517          	auipc	a0,0x6
ffffffffc0206bb4:	92850513          	addi	a0,a0,-1752 # ffffffffc020c4d8 <etext+0xede>
ffffffffc0206bb8:	893f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206bbc:	8daa                	mv	s11,a0
ffffffffc0206bbe:	ba51                	j	ffffffffc0206552 <do_execve+0x158>
ffffffffc0206bc0:	00007697          	auipc	a3,0x7
ffffffffc0206bc4:	b5868693          	addi	a3,a3,-1192 # ffffffffc020d718 <etext+0x211e>
ffffffffc0206bc8:	00005617          	auipc	a2,0x5
ffffffffc0206bcc:	e7060613          	addi	a2,a2,-400 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0206bd0:	32a00593          	li	a1,810
ffffffffc0206bd4:	00007517          	auipc	a0,0x7
ffffffffc0206bd8:	81450513          	addi	a0,a0,-2028 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206bdc:	86ff90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206be0:	00007697          	auipc	a3,0x7
ffffffffc0206be4:	af068693          	addi	a3,a3,-1296 # ffffffffc020d6d0 <etext+0x20d6>
ffffffffc0206be8:	00005617          	auipc	a2,0x5
ffffffffc0206bec:	e5060613          	addi	a2,a2,-432 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0206bf0:	32900593          	li	a1,809
ffffffffc0206bf4:	00006517          	auipc	a0,0x6
ffffffffc0206bf8:	7f450513          	addi	a0,a0,2036 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206bfc:	84ff90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206c00:	00007697          	auipc	a3,0x7
ffffffffc0206c04:	a8868693          	addi	a3,a3,-1400 # ffffffffc020d688 <etext+0x208e>
ffffffffc0206c08:	00005617          	auipc	a2,0x5
ffffffffc0206c0c:	e3060613          	addi	a2,a2,-464 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0206c10:	32800593          	li	a1,808
ffffffffc0206c14:	00006517          	auipc	a0,0x6
ffffffffc0206c18:	7d450513          	addi	a0,a0,2004 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206c1c:	82ff90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206c20:	00007697          	auipc	a3,0x7
ffffffffc0206c24:	a2068693          	addi	a3,a3,-1504 # ffffffffc020d640 <etext+0x2046>
ffffffffc0206c28:	00005617          	auipc	a2,0x5
ffffffffc0206c2c:	e1060613          	addi	a2,a2,-496 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0206c30:	32700593          	li	a1,807
ffffffffc0206c34:	00006517          	auipc	a0,0x6
ffffffffc0206c38:	7b450513          	addi	a0,a0,1972 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206c3c:	80ff90ef          	jal	ffffffffc020044a <__panic>

ffffffffc0206c40 <user_main>:
ffffffffc0206c40:	7179                	addi	sp,sp,-48
ffffffffc0206c42:	e84a                	sd	s2,16(sp)
ffffffffc0206c44:	00090917          	auipc	s2,0x90
ffffffffc0206c48:	c8490913          	addi	s2,s2,-892 # ffffffffc02968c8 <current>
ffffffffc0206c4c:	00093783          	ld	a5,0(s2)
ffffffffc0206c50:	00007617          	auipc	a2,0x7
ffffffffc0206c54:	b1060613          	addi	a2,a2,-1264 # ffffffffc020d760 <etext+0x2166>
ffffffffc0206c58:	00007517          	auipc	a0,0x7
ffffffffc0206c5c:	b1050513          	addi	a0,a0,-1264 # ffffffffc020d768 <etext+0x216e>
ffffffffc0206c60:	43cc                	lw	a1,4(a5)
ffffffffc0206c62:	f406                	sd	ra,40(sp)
ffffffffc0206c64:	f022                	sd	s0,32(sp)
ffffffffc0206c66:	ec26                	sd	s1,24(sp)
ffffffffc0206c68:	e402                	sd	zero,8(sp)
ffffffffc0206c6a:	e032                	sd	a2,0(sp)
ffffffffc0206c6c:	d3af90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0206c70:	6782                	ld	a5,0(sp)
ffffffffc0206c72:	cfb9                	beqz	a5,ffffffffc0206cd0 <user_main+0x90>
ffffffffc0206c74:	003c                	addi	a5,sp,8
ffffffffc0206c76:	4401                	li	s0,0
ffffffffc0206c78:	6398                	ld	a4,0(a5)
ffffffffc0206c7a:	07a1                	addi	a5,a5,8 # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc0206c7c:	0405                	addi	s0,s0,1
ffffffffc0206c7e:	ff6d                	bnez	a4,ffffffffc0206c78 <user_main+0x38>
ffffffffc0206c80:	00093703          	ld	a4,0(s2)
ffffffffc0206c84:	6789                	lui	a5,0x2
ffffffffc0206c86:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0206c8a:	6b04                	ld	s1,16(a4)
ffffffffc0206c8c:	734c                	ld	a1,160(a4)
ffffffffc0206c8e:	12000613          	li	a2,288
ffffffffc0206c92:	94be                	add	s1,s1,a5
ffffffffc0206c94:	8526                	mv	a0,s1
ffffffffc0206c96:	14d040ef          	jal	ffffffffc020b5e2 <memcpy>
ffffffffc0206c9a:	00093783          	ld	a5,0(s2)
ffffffffc0206c9e:	0004059b          	sext.w	a1,s0
ffffffffc0206ca2:	860a                	mv	a2,sp
ffffffffc0206ca4:	f3c4                	sd	s1,160(a5)
ffffffffc0206ca6:	00007517          	auipc	a0,0x7
ffffffffc0206caa:	aba50513          	addi	a0,a0,-1350 # ffffffffc020d760 <etext+0x2166>
ffffffffc0206cae:	f4cff0ef          	jal	ffffffffc02063fa <do_execve>
ffffffffc0206cb2:	8126                	mv	sp,s1
ffffffffc0206cb4:	dd0fa06f          	j	ffffffffc0201284 <__trapret>
ffffffffc0206cb8:	00007617          	auipc	a2,0x7
ffffffffc0206cbc:	ad860613          	addi	a2,a2,-1320 # ffffffffc020d790 <etext+0x2196>
ffffffffc0206cc0:	46600593          	li	a1,1126
ffffffffc0206cc4:	00006517          	auipc	a0,0x6
ffffffffc0206cc8:	72450513          	addi	a0,a0,1828 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206ccc:	f7ef90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206cd0:	4401                	li	s0,0
ffffffffc0206cd2:	b77d                	j	ffffffffc0206c80 <user_main+0x40>

ffffffffc0206cd4 <do_yield>:
ffffffffc0206cd4:	00090797          	auipc	a5,0x90
ffffffffc0206cd8:	bf47b783          	ld	a5,-1036(a5) # ffffffffc02968c8 <current>
ffffffffc0206cdc:	4705                	li	a4,1
ffffffffc0206cde:	4501                	li	a0,0
ffffffffc0206ce0:	ef98                	sd	a4,24(a5)
ffffffffc0206ce2:	8082                	ret

ffffffffc0206ce4 <do_wait>:
ffffffffc0206ce4:	c59d                	beqz	a1,ffffffffc0206d12 <do_wait+0x2e>
ffffffffc0206ce6:	1101                	addi	sp,sp,-32
ffffffffc0206ce8:	e02a                	sd	a0,0(sp)
ffffffffc0206cea:	00090517          	auipc	a0,0x90
ffffffffc0206cee:	bde53503          	ld	a0,-1058(a0) # ffffffffc02968c8 <current>
ffffffffc0206cf2:	4685                	li	a3,1
ffffffffc0206cf4:	4611                	li	a2,4
ffffffffc0206cf6:	7508                	ld	a0,40(a0)
ffffffffc0206cf8:	ec06                	sd	ra,24(sp)
ffffffffc0206cfa:	e42e                	sd	a1,8(sp)
ffffffffc0206cfc:	c1afd0ef          	jal	ffffffffc0204116 <user_mem_check>
ffffffffc0206d00:	6702                	ld	a4,0(sp)
ffffffffc0206d02:	67a2                	ld	a5,8(sp)
ffffffffc0206d04:	c909                	beqz	a0,ffffffffc0206d16 <do_wait+0x32>
ffffffffc0206d06:	60e2                	ld	ra,24(sp)
ffffffffc0206d08:	85be                	mv	a1,a5
ffffffffc0206d0a:	853a                	mv	a0,a4
ffffffffc0206d0c:	6105                	addi	sp,sp,32
ffffffffc0206d0e:	bbaff06f          	j	ffffffffc02060c8 <do_wait.part.0>
ffffffffc0206d12:	bb6ff06f          	j	ffffffffc02060c8 <do_wait.part.0>
ffffffffc0206d16:	60e2                	ld	ra,24(sp)
ffffffffc0206d18:	5575                	li	a0,-3
ffffffffc0206d1a:	6105                	addi	sp,sp,32
ffffffffc0206d1c:	8082                	ret

ffffffffc0206d1e <do_kill>:
ffffffffc0206d1e:	6789                	lui	a5,0x2
ffffffffc0206d20:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206d24:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_bin_swap_img_size-0x5d02>
ffffffffc0206d26:	06e7e463          	bltu	a5,a4,ffffffffc0206d8e <do_kill+0x70>
ffffffffc0206d2a:	1101                	addi	sp,sp,-32
ffffffffc0206d2c:	45a9                	li	a1,10
ffffffffc0206d2e:	ec06                	sd	ra,24(sp)
ffffffffc0206d30:	e42a                	sd	a0,8(sp)
ffffffffc0206d32:	324040ef          	jal	ffffffffc020b056 <hash32>
ffffffffc0206d36:	02051793          	slli	a5,a0,0x20
ffffffffc0206d3a:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0206d3e:	0008b797          	auipc	a5,0x8b
ffffffffc0206d42:	a8278793          	addi	a5,a5,-1406 # ffffffffc02917c0 <hash_list>
ffffffffc0206d46:	96be                	add	a3,a3,a5
ffffffffc0206d48:	6622                	ld	a2,8(sp)
ffffffffc0206d4a:	8536                	mv	a0,a3
ffffffffc0206d4c:	a029                	j	ffffffffc0206d56 <do_kill+0x38>
ffffffffc0206d4e:	f2c52703          	lw	a4,-212(a0)
ffffffffc0206d52:	00c70963          	beq	a4,a2,ffffffffc0206d64 <do_kill+0x46>
ffffffffc0206d56:	6508                	ld	a0,8(a0)
ffffffffc0206d58:	fea69be3          	bne	a3,a0,ffffffffc0206d4e <do_kill+0x30>
ffffffffc0206d5c:	60e2                	ld	ra,24(sp)
ffffffffc0206d5e:	5575                	li	a0,-3
ffffffffc0206d60:	6105                	addi	sp,sp,32
ffffffffc0206d62:	8082                	ret
ffffffffc0206d64:	fd852703          	lw	a4,-40(a0)
ffffffffc0206d68:	00177693          	andi	a3,a4,1
ffffffffc0206d6c:	e29d                	bnez	a3,ffffffffc0206d92 <do_kill+0x74>
ffffffffc0206d6e:	4954                	lw	a3,20(a0)
ffffffffc0206d70:	00176713          	ori	a4,a4,1
ffffffffc0206d74:	fce52c23          	sw	a4,-40(a0)
ffffffffc0206d78:	0006c663          	bltz	a3,ffffffffc0206d84 <do_kill+0x66>
ffffffffc0206d7c:	4501                	li	a0,0
ffffffffc0206d7e:	60e2                	ld	ra,24(sp)
ffffffffc0206d80:	6105                	addi	sp,sp,32
ffffffffc0206d82:	8082                	ret
ffffffffc0206d84:	f2850513          	addi	a0,a0,-216
ffffffffc0206d88:	45a000ef          	jal	ffffffffc02071e2 <wakeup_proc>
ffffffffc0206d8c:	bfc5                	j	ffffffffc0206d7c <do_kill+0x5e>
ffffffffc0206d8e:	5575                	li	a0,-3
ffffffffc0206d90:	8082                	ret
ffffffffc0206d92:	555d                	li	a0,-9
ffffffffc0206d94:	b7ed                	j	ffffffffc0206d7e <do_kill+0x60>

ffffffffc0206d96 <proc_init>:
ffffffffc0206d96:	1101                	addi	sp,sp,-32
ffffffffc0206d98:	e426                	sd	s1,8(sp)
ffffffffc0206d9a:	0008f797          	auipc	a5,0x8f
ffffffffc0206d9e:	a2678793          	addi	a5,a5,-1498 # ffffffffc02957c0 <proc_list>
ffffffffc0206da2:	ec06                	sd	ra,24(sp)
ffffffffc0206da4:	e822                	sd	s0,16(sp)
ffffffffc0206da6:	e04a                	sd	s2,0(sp)
ffffffffc0206da8:	0008b497          	auipc	s1,0x8b
ffffffffc0206dac:	a1848493          	addi	s1,s1,-1512 # ffffffffc02917c0 <hash_list>
ffffffffc0206db0:	e79c                	sd	a5,8(a5)
ffffffffc0206db2:	e39c                	sd	a5,0(a5)
ffffffffc0206db4:	0008f717          	auipc	a4,0x8f
ffffffffc0206db8:	a0c70713          	addi	a4,a4,-1524 # ffffffffc02957c0 <proc_list>
ffffffffc0206dbc:	87a6                	mv	a5,s1
ffffffffc0206dbe:	e79c                	sd	a5,8(a5)
ffffffffc0206dc0:	e39c                	sd	a5,0(a5)
ffffffffc0206dc2:	07c1                	addi	a5,a5,16
ffffffffc0206dc4:	fee79de3          	bne	a5,a4,ffffffffc0206dbe <proc_init+0x28>
ffffffffc0206dc8:	b1dfe0ef          	jal	ffffffffc02058e4 <alloc_proc>
ffffffffc0206dcc:	00090917          	auipc	s2,0x90
ffffffffc0206dd0:	b0c90913          	addi	s2,s2,-1268 # ffffffffc02968d8 <idleproc>
ffffffffc0206dd4:	00a93023          	sd	a0,0(s2)
ffffffffc0206dd8:	842a                	mv	s0,a0
ffffffffc0206dda:	12050c63          	beqz	a0,ffffffffc0206f12 <proc_init+0x17c>
ffffffffc0206dde:	4689                	li	a3,2
ffffffffc0206de0:	0000a717          	auipc	a4,0xa
ffffffffc0206de4:	22070713          	addi	a4,a4,544 # ffffffffc0211000 <bootstack>
ffffffffc0206de8:	4785                	li	a5,1
ffffffffc0206dea:	e114                	sd	a3,0(a0)
ffffffffc0206dec:	e918                	sd	a4,16(a0)
ffffffffc0206dee:	ed1c                	sd	a5,24(a0)
ffffffffc0206df0:	aaafe0ef          	jal	ffffffffc020509a <files_create>
ffffffffc0206df4:	14a43423          	sd	a0,328(s0)
ffffffffc0206df8:	10050163          	beqz	a0,ffffffffc0206efa <proc_init+0x164>
ffffffffc0206dfc:	00093403          	ld	s0,0(s2)
ffffffffc0206e00:	4641                	li	a2,16
ffffffffc0206e02:	4581                	li	a1,0
ffffffffc0206e04:	14843703          	ld	a4,328(s0)
ffffffffc0206e08:	0b440413          	addi	s0,s0,180
ffffffffc0206e0c:	8522                	mv	a0,s0
ffffffffc0206e0e:	4b1c                	lw	a5,16(a4)
ffffffffc0206e10:	2785                	addiw	a5,a5,1
ffffffffc0206e12:	cb1c                	sw	a5,16(a4)
ffffffffc0206e14:	77e040ef          	jal	ffffffffc020b592 <memset>
ffffffffc0206e18:	8522                	mv	a0,s0
ffffffffc0206e1a:	463d                	li	a2,15
ffffffffc0206e1c:	00007597          	auipc	a1,0x7
ffffffffc0206e20:	9d458593          	addi	a1,a1,-1580 # ffffffffc020d7f0 <etext+0x21f6>
ffffffffc0206e24:	7be040ef          	jal	ffffffffc020b5e2 <memcpy>
ffffffffc0206e28:	00090797          	auipc	a5,0x90
ffffffffc0206e2c:	a987a783          	lw	a5,-1384(a5) # ffffffffc02968c0 <nr_process>
ffffffffc0206e30:	00093703          	ld	a4,0(s2)
ffffffffc0206e34:	4601                	li	a2,0
ffffffffc0206e36:	2785                	addiw	a5,a5,1
ffffffffc0206e38:	4581                	li	a1,0
ffffffffc0206e3a:	fffff517          	auipc	a0,0xfffff
ffffffffc0206e3e:	47050513          	addi	a0,a0,1136 # ffffffffc02062aa <init_main>
ffffffffc0206e42:	00090697          	auipc	a3,0x90
ffffffffc0206e46:	a8e6b323          	sd	a4,-1402(a3) # ffffffffc02968c8 <current>
ffffffffc0206e4a:	00090717          	auipc	a4,0x90
ffffffffc0206e4e:	a6f72b23          	sw	a5,-1418(a4) # ffffffffc02968c0 <nr_process>
ffffffffc0206e52:	8c6ff0ef          	jal	ffffffffc0205f18 <kernel_thread>
ffffffffc0206e56:	842a                	mv	s0,a0
ffffffffc0206e58:	08a05563          	blez	a0,ffffffffc0206ee2 <proc_init+0x14c>
ffffffffc0206e5c:	6789                	lui	a5,0x2
ffffffffc0206e5e:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_bin_swap_img_size-0x5d02>
ffffffffc0206e60:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206e64:	02e7e463          	bltu	a5,a4,ffffffffc0206e8c <proc_init+0xf6>
ffffffffc0206e68:	45a9                	li	a1,10
ffffffffc0206e6a:	1ec040ef          	jal	ffffffffc020b056 <hash32>
ffffffffc0206e6e:	02051713          	slli	a4,a0,0x20
ffffffffc0206e72:	01c75793          	srli	a5,a4,0x1c
ffffffffc0206e76:	00f486b3          	add	a3,s1,a5
ffffffffc0206e7a:	87b6                	mv	a5,a3
ffffffffc0206e7c:	a029                	j	ffffffffc0206e86 <proc_init+0xf0>
ffffffffc0206e7e:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0206e82:	04870d63          	beq	a4,s0,ffffffffc0206edc <proc_init+0x146>
ffffffffc0206e86:	679c                	ld	a5,8(a5)
ffffffffc0206e88:	fef69be3          	bne	a3,a5,ffffffffc0206e7e <proc_init+0xe8>
ffffffffc0206e8c:	4781                	li	a5,0
ffffffffc0206e8e:	0b478413          	addi	s0,a5,180
ffffffffc0206e92:	4641                	li	a2,16
ffffffffc0206e94:	4581                	li	a1,0
ffffffffc0206e96:	8522                	mv	a0,s0
ffffffffc0206e98:	00090717          	auipc	a4,0x90
ffffffffc0206e9c:	a2f73c23          	sd	a5,-1480(a4) # ffffffffc02968d0 <initproc>
ffffffffc0206ea0:	6f2040ef          	jal	ffffffffc020b592 <memset>
ffffffffc0206ea4:	8522                	mv	a0,s0
ffffffffc0206ea6:	463d                	li	a2,15
ffffffffc0206ea8:	00007597          	auipc	a1,0x7
ffffffffc0206eac:	97058593          	addi	a1,a1,-1680 # ffffffffc020d818 <etext+0x221e>
ffffffffc0206eb0:	732040ef          	jal	ffffffffc020b5e2 <memcpy>
ffffffffc0206eb4:	00093783          	ld	a5,0(s2)
ffffffffc0206eb8:	cbc9                	beqz	a5,ffffffffc0206f4a <proc_init+0x1b4>
ffffffffc0206eba:	43dc                	lw	a5,4(a5)
ffffffffc0206ebc:	e7d9                	bnez	a5,ffffffffc0206f4a <proc_init+0x1b4>
ffffffffc0206ebe:	00090797          	auipc	a5,0x90
ffffffffc0206ec2:	a127b783          	ld	a5,-1518(a5) # ffffffffc02968d0 <initproc>
ffffffffc0206ec6:	c3b5                	beqz	a5,ffffffffc0206f2a <proc_init+0x194>
ffffffffc0206ec8:	43d8                	lw	a4,4(a5)
ffffffffc0206eca:	4785                	li	a5,1
ffffffffc0206ecc:	04f71f63          	bne	a4,a5,ffffffffc0206f2a <proc_init+0x194>
ffffffffc0206ed0:	60e2                	ld	ra,24(sp)
ffffffffc0206ed2:	6442                	ld	s0,16(sp)
ffffffffc0206ed4:	64a2                	ld	s1,8(sp)
ffffffffc0206ed6:	6902                	ld	s2,0(sp)
ffffffffc0206ed8:	6105                	addi	sp,sp,32
ffffffffc0206eda:	8082                	ret
ffffffffc0206edc:	f2878793          	addi	a5,a5,-216
ffffffffc0206ee0:	b77d                	j	ffffffffc0206e8e <proc_init+0xf8>
ffffffffc0206ee2:	00007617          	auipc	a2,0x7
ffffffffc0206ee6:	91660613          	addi	a2,a2,-1770 # ffffffffc020d7f8 <etext+0x21fe>
ffffffffc0206eea:	4b200593          	li	a1,1202
ffffffffc0206eee:	00006517          	auipc	a0,0x6
ffffffffc0206ef2:	4fa50513          	addi	a0,a0,1274 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206ef6:	d54f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206efa:	00007617          	auipc	a2,0x7
ffffffffc0206efe:	8ce60613          	addi	a2,a2,-1842 # ffffffffc020d7c8 <etext+0x21ce>
ffffffffc0206f02:	4a600593          	li	a1,1190
ffffffffc0206f06:	00006517          	auipc	a0,0x6
ffffffffc0206f0a:	4e250513          	addi	a0,a0,1250 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206f0e:	d3cf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206f12:	00007617          	auipc	a2,0x7
ffffffffc0206f16:	89e60613          	addi	a2,a2,-1890 # ffffffffc020d7b0 <etext+0x21b6>
ffffffffc0206f1a:	49c00593          	li	a1,1180
ffffffffc0206f1e:	00006517          	auipc	a0,0x6
ffffffffc0206f22:	4ca50513          	addi	a0,a0,1226 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206f26:	d24f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206f2a:	00007697          	auipc	a3,0x7
ffffffffc0206f2e:	91e68693          	addi	a3,a3,-1762 # ffffffffc020d848 <etext+0x224e>
ffffffffc0206f32:	00005617          	auipc	a2,0x5
ffffffffc0206f36:	b0660613          	addi	a2,a2,-1274 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0206f3a:	4b900593          	li	a1,1209
ffffffffc0206f3e:	00006517          	auipc	a0,0x6
ffffffffc0206f42:	4aa50513          	addi	a0,a0,1194 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206f46:	d04f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206f4a:	00007697          	auipc	a3,0x7
ffffffffc0206f4e:	8d668693          	addi	a3,a3,-1834 # ffffffffc020d820 <etext+0x2226>
ffffffffc0206f52:	00005617          	auipc	a2,0x5
ffffffffc0206f56:	ae660613          	addi	a2,a2,-1306 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0206f5a:	4b800593          	li	a1,1208
ffffffffc0206f5e:	00006517          	auipc	a0,0x6
ffffffffc0206f62:	48a50513          	addi	a0,a0,1162 # ffffffffc020d3e8 <etext+0x1dee>
ffffffffc0206f66:	ce4f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc0206f6a <cpu_idle>:
ffffffffc0206f6a:	1141                	addi	sp,sp,-16
ffffffffc0206f6c:	e022                	sd	s0,0(sp)
ffffffffc0206f6e:	e406                	sd	ra,8(sp)
ffffffffc0206f70:	00090417          	auipc	s0,0x90
ffffffffc0206f74:	95840413          	addi	s0,s0,-1704 # ffffffffc02968c8 <current>
ffffffffc0206f78:	6018                	ld	a4,0(s0)
ffffffffc0206f7a:	6f1c                	ld	a5,24(a4)
ffffffffc0206f7c:	dffd                	beqz	a5,ffffffffc0206f7a <cpu_idle+0x10>
ffffffffc0206f7e:	35c000ef          	jal	ffffffffc02072da <schedule>
ffffffffc0206f82:	bfdd                	j	ffffffffc0206f78 <cpu_idle+0xe>

ffffffffc0206f84 <lab6_set_priority>:
ffffffffc0206f84:	1101                	addi	sp,sp,-32
ffffffffc0206f86:	85aa                	mv	a1,a0
ffffffffc0206f88:	e42a                	sd	a0,8(sp)
ffffffffc0206f8a:	00007517          	auipc	a0,0x7
ffffffffc0206f8e:	8e650513          	addi	a0,a0,-1818 # ffffffffc020d870 <etext+0x2276>
ffffffffc0206f92:	ec06                	sd	ra,24(sp)
ffffffffc0206f94:	a12f90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0206f98:	65a2                	ld	a1,8(sp)
ffffffffc0206f9a:	00090717          	auipc	a4,0x90
ffffffffc0206f9e:	92e73703          	ld	a4,-1746(a4) # ffffffffc02968c8 <current>
ffffffffc0206fa2:	4785                	li	a5,1
ffffffffc0206fa4:	c191                	beqz	a1,ffffffffc0206fa8 <lab6_set_priority+0x24>
ffffffffc0206fa6:	87ae                	mv	a5,a1
ffffffffc0206fa8:	60e2                	ld	ra,24(sp)
ffffffffc0206faa:	14f72223          	sw	a5,324(a4)
ffffffffc0206fae:	6105                	addi	sp,sp,32
ffffffffc0206fb0:	8082                	ret

ffffffffc0206fb2 <do_sleep>:
ffffffffc0206fb2:	c531                	beqz	a0,ffffffffc0206ffe <do_sleep+0x4c>
ffffffffc0206fb4:	7139                	addi	sp,sp,-64
ffffffffc0206fb6:	fc06                	sd	ra,56(sp)
ffffffffc0206fb8:	f822                	sd	s0,48(sp)
ffffffffc0206fba:	100027f3          	csrr	a5,sstatus
ffffffffc0206fbe:	8b89                	andi	a5,a5,2
ffffffffc0206fc0:	e3a9                	bnez	a5,ffffffffc0207002 <do_sleep+0x50>
ffffffffc0206fc2:	00090797          	auipc	a5,0x90
ffffffffc0206fc6:	9067b783          	ld	a5,-1786(a5) # ffffffffc02968c8 <current>
ffffffffc0206fca:	1014                	addi	a3,sp,32
ffffffffc0206fcc:	80000737          	lui	a4,0x80000
ffffffffc0206fd0:	c82a                	sw	a0,16(sp)
ffffffffc0206fd2:	f436                	sd	a3,40(sp)
ffffffffc0206fd4:	f036                	sd	a3,32(sp)
ffffffffc0206fd6:	ec3e                	sd	a5,24(sp)
ffffffffc0206fd8:	4685                	li	a3,1
ffffffffc0206fda:	0709                	addi	a4,a4,2 # ffffffff80000002 <_binary_bin_sfs_img_size+0xffffffff7ff8ad02>
ffffffffc0206fdc:	0808                	addi	a0,sp,16
ffffffffc0206fde:	c394                	sw	a3,0(a5)
ffffffffc0206fe0:	0ee7a623          	sw	a4,236(a5)
ffffffffc0206fe4:	842a                	mv	s0,a0
ffffffffc0206fe6:	3aa000ef          	jal	ffffffffc0207390 <add_timer>
ffffffffc0206fea:	2f0000ef          	jal	ffffffffc02072da <schedule>
ffffffffc0206fee:	8522                	mv	a0,s0
ffffffffc0206ff0:	466000ef          	jal	ffffffffc0207456 <del_timer>
ffffffffc0206ff4:	70e2                	ld	ra,56(sp)
ffffffffc0206ff6:	7442                	ld	s0,48(sp)
ffffffffc0206ff8:	4501                	li	a0,0
ffffffffc0206ffa:	6121                	addi	sp,sp,64
ffffffffc0206ffc:	8082                	ret
ffffffffc0206ffe:	4501                	li	a0,0
ffffffffc0207000:	8082                	ret
ffffffffc0207002:	e42a                	sd	a0,8(sp)
ffffffffc0207004:	c6df90ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0207008:	00090797          	auipc	a5,0x90
ffffffffc020700c:	8c07b783          	ld	a5,-1856(a5) # ffffffffc02968c8 <current>
ffffffffc0207010:	6522                	ld	a0,8(sp)
ffffffffc0207012:	1014                	addi	a3,sp,32
ffffffffc0207014:	80000737          	lui	a4,0x80000
ffffffffc0207018:	c82a                	sw	a0,16(sp)
ffffffffc020701a:	f436                	sd	a3,40(sp)
ffffffffc020701c:	f036                	sd	a3,32(sp)
ffffffffc020701e:	ec3e                	sd	a5,24(sp)
ffffffffc0207020:	4685                	li	a3,1
ffffffffc0207022:	0709                	addi	a4,a4,2 # ffffffff80000002 <_binary_bin_sfs_img_size+0xffffffff7ff8ad02>
ffffffffc0207024:	0808                	addi	a0,sp,16
ffffffffc0207026:	c394                	sw	a3,0(a5)
ffffffffc0207028:	0ee7a623          	sw	a4,236(a5)
ffffffffc020702c:	842a                	mv	s0,a0
ffffffffc020702e:	362000ef          	jal	ffffffffc0207390 <add_timer>
ffffffffc0207032:	c39f90ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0207036:	bf55                	j	ffffffffc0206fea <do_sleep+0x38>

ffffffffc0207038 <switch_to>:
ffffffffc0207038:	00153023          	sd	ra,0(a0)
ffffffffc020703c:	00253423          	sd	sp,8(a0)
ffffffffc0207040:	e900                	sd	s0,16(a0)
ffffffffc0207042:	ed04                	sd	s1,24(a0)
ffffffffc0207044:	03253023          	sd	s2,32(a0)
ffffffffc0207048:	03353423          	sd	s3,40(a0)
ffffffffc020704c:	03453823          	sd	s4,48(a0)
ffffffffc0207050:	03553c23          	sd	s5,56(a0)
ffffffffc0207054:	05653023          	sd	s6,64(a0)
ffffffffc0207058:	05753423          	sd	s7,72(a0)
ffffffffc020705c:	05853823          	sd	s8,80(a0)
ffffffffc0207060:	05953c23          	sd	s9,88(a0)
ffffffffc0207064:	07a53023          	sd	s10,96(a0)
ffffffffc0207068:	07b53423          	sd	s11,104(a0)
ffffffffc020706c:	0005b083          	ld	ra,0(a1)
ffffffffc0207070:	0085b103          	ld	sp,8(a1)
ffffffffc0207074:	6980                	ld	s0,16(a1)
ffffffffc0207076:	6d84                	ld	s1,24(a1)
ffffffffc0207078:	0205b903          	ld	s2,32(a1)
ffffffffc020707c:	0285b983          	ld	s3,40(a1)
ffffffffc0207080:	0305ba03          	ld	s4,48(a1)
ffffffffc0207084:	0385ba83          	ld	s5,56(a1)
ffffffffc0207088:	0405bb03          	ld	s6,64(a1)
ffffffffc020708c:	0485bb83          	ld	s7,72(a1)
ffffffffc0207090:	0505bc03          	ld	s8,80(a1)
ffffffffc0207094:	0585bc83          	ld	s9,88(a1)
ffffffffc0207098:	0605bd03          	ld	s10,96(a1)
ffffffffc020709c:	0685bd83          	ld	s11,104(a1)
ffffffffc02070a0:	8082                	ret

ffffffffc02070a2 <RR_init>:
ffffffffc02070a2:	e508                	sd	a0,8(a0)
ffffffffc02070a4:	e108                	sd	a0,0(a0)
ffffffffc02070a6:	00052823          	sw	zero,16(a0)
ffffffffc02070aa:	00053c23          	sd	zero,24(a0)
ffffffffc02070ae:	8082                	ret

ffffffffc02070b0 <RR_pick_next>:
ffffffffc02070b0:	651c                	ld	a5,8(a0)
ffffffffc02070b2:	00f50563          	beq	a0,a5,ffffffffc02070bc <RR_pick_next+0xc>
ffffffffc02070b6:	ef078513          	addi	a0,a5,-272
ffffffffc02070ba:	8082                	ret
ffffffffc02070bc:	4501                	li	a0,0
ffffffffc02070be:	8082                	ret

ffffffffc02070c0 <RR_proc_tick>:
ffffffffc02070c0:	00090797          	auipc	a5,0x90
ffffffffc02070c4:	8187b783          	ld	a5,-2024(a5) # ffffffffc02968d8 <idleproc>
ffffffffc02070c8:	00b78d63          	beq	a5,a1,ffffffffc02070e2 <RR_proc_tick+0x22>
ffffffffc02070cc:	c999                	beqz	a1,ffffffffc02070e2 <RR_proc_tick+0x22>
ffffffffc02070ce:	1205a783          	lw	a5,288(a1)
ffffffffc02070d2:	00f05563          	blez	a5,ffffffffc02070dc <RR_proc_tick+0x1c>
ffffffffc02070d6:	37fd                	addiw	a5,a5,-1
ffffffffc02070d8:	12f5a023          	sw	a5,288(a1)
ffffffffc02070dc:	e399                	bnez	a5,ffffffffc02070e2 <RR_proc_tick+0x22>
ffffffffc02070de:	4785                	li	a5,1
ffffffffc02070e0:	ed9c                	sd	a5,24(a1)
ffffffffc02070e2:	8082                	ret

ffffffffc02070e4 <RR_dequeue>:
ffffffffc02070e4:	c59d                	beqz	a1,ffffffffc0207112 <RR_dequeue+0x2e>
ffffffffc02070e6:	1085b783          	ld	a5,264(a1)
ffffffffc02070ea:	02a79463          	bne	a5,a0,ffffffffc0207112 <RR_dequeue+0x2e>
ffffffffc02070ee:	1105b503          	ld	a0,272(a1)
ffffffffc02070f2:	1185b603          	ld	a2,280(a1)
ffffffffc02070f6:	4b98                	lw	a4,16(a5)
ffffffffc02070f8:	11058693          	addi	a3,a1,272
ffffffffc02070fc:	e510                	sd	a2,8(a0)
ffffffffc02070fe:	e208                	sd	a0,0(a2)
ffffffffc0207100:	1005b423          	sd	zero,264(a1)
ffffffffc0207104:	377d                	addiw	a4,a4,-1
ffffffffc0207106:	10d5bc23          	sd	a3,280(a1)
ffffffffc020710a:	10d5b823          	sd	a3,272(a1)
ffffffffc020710e:	cb98                	sw	a4,16(a5)
ffffffffc0207110:	8082                	ret
ffffffffc0207112:	1141                	addi	sp,sp,-16
ffffffffc0207114:	00006697          	auipc	a3,0x6
ffffffffc0207118:	77468693          	addi	a3,a3,1908 # ffffffffc020d888 <etext+0x228e>
ffffffffc020711c:	00005617          	auipc	a2,0x5
ffffffffc0207120:	91c60613          	addi	a2,a2,-1764 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0207124:	03300593          	li	a1,51
ffffffffc0207128:	00006517          	auipc	a0,0x6
ffffffffc020712c:	77850513          	addi	a0,a0,1912 # ffffffffc020d8a0 <etext+0x22a6>
ffffffffc0207130:	e406                	sd	ra,8(sp)
ffffffffc0207132:	b18f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207136 <RR_enqueue>:
ffffffffc0207136:	c995                	beqz	a1,ffffffffc020716a <RR_enqueue+0x34>
ffffffffc0207138:	6114                	ld	a3,0(a0)
ffffffffc020713a:	4918                	lw	a4,16(a0)
ffffffffc020713c:	11058793          	addi	a5,a1,272
ffffffffc0207140:	e11c                	sd	a5,0(a0)
ffffffffc0207142:	e69c                	sd	a5,8(a3)
ffffffffc0207144:	0008f617          	auipc	a2,0x8f
ffffffffc0207148:	79463603          	ld	a2,1940(a2) # ffffffffc02968d8 <idleproc>
ffffffffc020714c:	10d5b823          	sd	a3,272(a1)
ffffffffc0207150:	10a5bc23          	sd	a0,280(a1)
ffffffffc0207154:	10a5b423          	sd	a0,264(a1)
ffffffffc0207158:	0017079b          	addiw	a5,a4,1
ffffffffc020715c:	c91c                	sw	a5,16(a0)
ffffffffc020715e:	00b60563          	beq	a2,a1,ffffffffc0207168 <RR_enqueue+0x32>
ffffffffc0207162:	495c                	lw	a5,20(a0)
ffffffffc0207164:	12f5a023          	sw	a5,288(a1)
ffffffffc0207168:	8082                	ret
ffffffffc020716a:	1141                	addi	sp,sp,-16
ffffffffc020716c:	00006697          	auipc	a3,0x6
ffffffffc0207170:	75468693          	addi	a3,a3,1876 # ffffffffc020d8c0 <etext+0x22c6>
ffffffffc0207174:	00005617          	auipc	a2,0x5
ffffffffc0207178:	8c460613          	addi	a2,a2,-1852 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020717c:	02200593          	li	a1,34
ffffffffc0207180:	00006517          	auipc	a0,0x6
ffffffffc0207184:	72050513          	addi	a0,a0,1824 # ffffffffc020d8a0 <etext+0x22a6>
ffffffffc0207188:	e406                	sd	ra,8(sp)
ffffffffc020718a:	ac0f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc020718e <sched_init>:
ffffffffc020718e:	0008a797          	auipc	a5,0x8a
ffffffffc0207192:	e9278793          	addi	a5,a5,-366 # ffffffffc0291020 <default_sched_class>
ffffffffc0207196:	1141                	addi	sp,sp,-16
ffffffffc0207198:	6794                	ld	a3,8(a5)
ffffffffc020719a:	0008f717          	auipc	a4,0x8f
ffffffffc020719e:	74f73723          	sd	a5,1870(a4) # ffffffffc02968e8 <sched_class>
ffffffffc02071a2:	e406                	sd	ra,8(sp)
ffffffffc02071a4:	0008e797          	auipc	a5,0x8e
ffffffffc02071a8:	64c78793          	addi	a5,a5,1612 # ffffffffc02957f0 <timer_list>
ffffffffc02071ac:	0008e717          	auipc	a4,0x8e
ffffffffc02071b0:	62470713          	addi	a4,a4,1572 # ffffffffc02957d0 <__rq>
ffffffffc02071b4:	4615                	li	a2,5
ffffffffc02071b6:	e79c                	sd	a5,8(a5)
ffffffffc02071b8:	e39c                	sd	a5,0(a5)
ffffffffc02071ba:	853a                	mv	a0,a4
ffffffffc02071bc:	cb50                	sw	a2,20(a4)
ffffffffc02071be:	0008f797          	auipc	a5,0x8f
ffffffffc02071c2:	72e7b123          	sd	a4,1826(a5) # ffffffffc02968e0 <rq>
ffffffffc02071c6:	9682                	jalr	a3
ffffffffc02071c8:	0008f797          	auipc	a5,0x8f
ffffffffc02071cc:	7207b783          	ld	a5,1824(a5) # ffffffffc02968e8 <sched_class>
ffffffffc02071d0:	60a2                	ld	ra,8(sp)
ffffffffc02071d2:	00006517          	auipc	a0,0x6
ffffffffc02071d6:	70650513          	addi	a0,a0,1798 # ffffffffc020d8d8 <etext+0x22de>
ffffffffc02071da:	638c                	ld	a1,0(a5)
ffffffffc02071dc:	0141                	addi	sp,sp,16
ffffffffc02071de:	fc9f806f          	j	ffffffffc02001a6 <cprintf>

ffffffffc02071e2 <wakeup_proc>:
ffffffffc02071e2:	4118                	lw	a4,0(a0)
ffffffffc02071e4:	1101                	addi	sp,sp,-32
ffffffffc02071e6:	ec06                	sd	ra,24(sp)
ffffffffc02071e8:	478d                	li	a5,3
ffffffffc02071ea:	0cf70863          	beq	a4,a5,ffffffffc02072ba <wakeup_proc+0xd8>
ffffffffc02071ee:	85aa                	mv	a1,a0
ffffffffc02071f0:	100027f3          	csrr	a5,sstatus
ffffffffc02071f4:	8b89                	andi	a5,a5,2
ffffffffc02071f6:	e3b1                	bnez	a5,ffffffffc020723a <wakeup_proc+0x58>
ffffffffc02071f8:	4789                	li	a5,2
ffffffffc02071fa:	08f70563          	beq	a4,a5,ffffffffc0207284 <wakeup_proc+0xa2>
ffffffffc02071fe:	0008f717          	auipc	a4,0x8f
ffffffffc0207202:	6ca73703          	ld	a4,1738(a4) # ffffffffc02968c8 <current>
ffffffffc0207206:	0e052623          	sw	zero,236(a0)
ffffffffc020720a:	c11c                	sw	a5,0(a0)
ffffffffc020720c:	02e50463          	beq	a0,a4,ffffffffc0207234 <wakeup_proc+0x52>
ffffffffc0207210:	0008f797          	auipc	a5,0x8f
ffffffffc0207214:	6c87b783          	ld	a5,1736(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0207218:	00f50e63          	beq	a0,a5,ffffffffc0207234 <wakeup_proc+0x52>
ffffffffc020721c:	0008f797          	auipc	a5,0x8f
ffffffffc0207220:	6cc7b783          	ld	a5,1740(a5) # ffffffffc02968e8 <sched_class>
ffffffffc0207224:	60e2                	ld	ra,24(sp)
ffffffffc0207226:	0008f517          	auipc	a0,0x8f
ffffffffc020722a:	6ba53503          	ld	a0,1722(a0) # ffffffffc02968e0 <rq>
ffffffffc020722e:	6b9c                	ld	a5,16(a5)
ffffffffc0207230:	6105                	addi	sp,sp,32
ffffffffc0207232:	8782                	jr	a5
ffffffffc0207234:	60e2                	ld	ra,24(sp)
ffffffffc0207236:	6105                	addi	sp,sp,32
ffffffffc0207238:	8082                	ret
ffffffffc020723a:	e42a                	sd	a0,8(sp)
ffffffffc020723c:	a35f90ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0207240:	65a2                	ld	a1,8(sp)
ffffffffc0207242:	4789                	li	a5,2
ffffffffc0207244:	4198                	lw	a4,0(a1)
ffffffffc0207246:	04f70d63          	beq	a4,a5,ffffffffc02072a0 <wakeup_proc+0xbe>
ffffffffc020724a:	0008f717          	auipc	a4,0x8f
ffffffffc020724e:	67e73703          	ld	a4,1662(a4) # ffffffffc02968c8 <current>
ffffffffc0207252:	0e05a623          	sw	zero,236(a1)
ffffffffc0207256:	c19c                	sw	a5,0(a1)
ffffffffc0207258:	02e58263          	beq	a1,a4,ffffffffc020727c <wakeup_proc+0x9a>
ffffffffc020725c:	0008f797          	auipc	a5,0x8f
ffffffffc0207260:	67c7b783          	ld	a5,1660(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0207264:	00f58c63          	beq	a1,a5,ffffffffc020727c <wakeup_proc+0x9a>
ffffffffc0207268:	0008f797          	auipc	a5,0x8f
ffffffffc020726c:	6807b783          	ld	a5,1664(a5) # ffffffffc02968e8 <sched_class>
ffffffffc0207270:	0008f517          	auipc	a0,0x8f
ffffffffc0207274:	67053503          	ld	a0,1648(a0) # ffffffffc02968e0 <rq>
ffffffffc0207278:	6b9c                	ld	a5,16(a5)
ffffffffc020727a:	9782                	jalr	a5
ffffffffc020727c:	60e2                	ld	ra,24(sp)
ffffffffc020727e:	6105                	addi	sp,sp,32
ffffffffc0207280:	9ebf906f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc0207284:	60e2                	ld	ra,24(sp)
ffffffffc0207286:	00006617          	auipc	a2,0x6
ffffffffc020728a:	6a260613          	addi	a2,a2,1698 # ffffffffc020d928 <etext+0x232e>
ffffffffc020728e:	05200593          	li	a1,82
ffffffffc0207292:	00006517          	auipc	a0,0x6
ffffffffc0207296:	67e50513          	addi	a0,a0,1662 # ffffffffc020d910 <etext+0x2316>
ffffffffc020729a:	6105                	addi	sp,sp,32
ffffffffc020729c:	a18f906f          	j	ffffffffc02004b4 <__warn>
ffffffffc02072a0:	00006617          	auipc	a2,0x6
ffffffffc02072a4:	68860613          	addi	a2,a2,1672 # ffffffffc020d928 <etext+0x232e>
ffffffffc02072a8:	05200593          	li	a1,82
ffffffffc02072ac:	00006517          	auipc	a0,0x6
ffffffffc02072b0:	66450513          	addi	a0,a0,1636 # ffffffffc020d910 <etext+0x2316>
ffffffffc02072b4:	a00f90ef          	jal	ffffffffc02004b4 <__warn>
ffffffffc02072b8:	b7d1                	j	ffffffffc020727c <wakeup_proc+0x9a>
ffffffffc02072ba:	00006697          	auipc	a3,0x6
ffffffffc02072be:	63668693          	addi	a3,a3,1590 # ffffffffc020d8f0 <etext+0x22f6>
ffffffffc02072c2:	00004617          	auipc	a2,0x4
ffffffffc02072c6:	77660613          	addi	a2,a2,1910 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02072ca:	04300593          	li	a1,67
ffffffffc02072ce:	00006517          	auipc	a0,0x6
ffffffffc02072d2:	64250513          	addi	a0,a0,1602 # ffffffffc020d910 <etext+0x2316>
ffffffffc02072d6:	974f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc02072da <schedule>:
ffffffffc02072da:	7139                	addi	sp,sp,-64
ffffffffc02072dc:	fc06                	sd	ra,56(sp)
ffffffffc02072de:	f822                	sd	s0,48(sp)
ffffffffc02072e0:	f426                	sd	s1,40(sp)
ffffffffc02072e2:	f04a                	sd	s2,32(sp)
ffffffffc02072e4:	ec4e                	sd	s3,24(sp)
ffffffffc02072e6:	100027f3          	csrr	a5,sstatus
ffffffffc02072ea:	8b89                	andi	a5,a5,2
ffffffffc02072ec:	4981                	li	s3,0
ffffffffc02072ee:	efc9                	bnez	a5,ffffffffc0207388 <schedule+0xae>
ffffffffc02072f0:	0008f417          	auipc	s0,0x8f
ffffffffc02072f4:	5d840413          	addi	s0,s0,1496 # ffffffffc02968c8 <current>
ffffffffc02072f8:	600c                	ld	a1,0(s0)
ffffffffc02072fa:	4789                	li	a5,2
ffffffffc02072fc:	0008f497          	auipc	s1,0x8f
ffffffffc0207300:	5e448493          	addi	s1,s1,1508 # ffffffffc02968e0 <rq>
ffffffffc0207304:	4198                	lw	a4,0(a1)
ffffffffc0207306:	0005bc23          	sd	zero,24(a1)
ffffffffc020730a:	0008f917          	auipc	s2,0x8f
ffffffffc020730e:	5de90913          	addi	s2,s2,1502 # ffffffffc02968e8 <sched_class>
ffffffffc0207312:	04f70f63          	beq	a4,a5,ffffffffc0207370 <schedule+0x96>
ffffffffc0207316:	00093783          	ld	a5,0(s2)
ffffffffc020731a:	6088                	ld	a0,0(s1)
ffffffffc020731c:	739c                	ld	a5,32(a5)
ffffffffc020731e:	9782                	jalr	a5
ffffffffc0207320:	85aa                	mv	a1,a0
ffffffffc0207322:	c131                	beqz	a0,ffffffffc0207366 <schedule+0x8c>
ffffffffc0207324:	00093783          	ld	a5,0(s2)
ffffffffc0207328:	6088                	ld	a0,0(s1)
ffffffffc020732a:	e42e                	sd	a1,8(sp)
ffffffffc020732c:	6f9c                	ld	a5,24(a5)
ffffffffc020732e:	9782                	jalr	a5
ffffffffc0207330:	65a2                	ld	a1,8(sp)
ffffffffc0207332:	459c                	lw	a5,8(a1)
ffffffffc0207334:	6018                	ld	a4,0(s0)
ffffffffc0207336:	2785                	addiw	a5,a5,1
ffffffffc0207338:	c59c                	sw	a5,8(a1)
ffffffffc020733a:	00b70563          	beq	a4,a1,ffffffffc0207344 <schedule+0x6a>
ffffffffc020733e:	852e                	mv	a0,a1
ffffffffc0207340:	f48fe0ef          	jal	ffffffffc0205a88 <proc_run>
ffffffffc0207344:	00099963          	bnez	s3,ffffffffc0207356 <schedule+0x7c>
ffffffffc0207348:	70e2                	ld	ra,56(sp)
ffffffffc020734a:	7442                	ld	s0,48(sp)
ffffffffc020734c:	74a2                	ld	s1,40(sp)
ffffffffc020734e:	7902                	ld	s2,32(sp)
ffffffffc0207350:	69e2                	ld	s3,24(sp)
ffffffffc0207352:	6121                	addi	sp,sp,64
ffffffffc0207354:	8082                	ret
ffffffffc0207356:	7442                	ld	s0,48(sp)
ffffffffc0207358:	70e2                	ld	ra,56(sp)
ffffffffc020735a:	74a2                	ld	s1,40(sp)
ffffffffc020735c:	7902                	ld	s2,32(sp)
ffffffffc020735e:	69e2                	ld	s3,24(sp)
ffffffffc0207360:	6121                	addi	sp,sp,64
ffffffffc0207362:	909f906f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc0207366:	0008f597          	auipc	a1,0x8f
ffffffffc020736a:	5725b583          	ld	a1,1394(a1) # ffffffffc02968d8 <idleproc>
ffffffffc020736e:	b7d1                	j	ffffffffc0207332 <schedule+0x58>
ffffffffc0207370:	0008f797          	auipc	a5,0x8f
ffffffffc0207374:	5687b783          	ld	a5,1384(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0207378:	f8f58fe3          	beq	a1,a5,ffffffffc0207316 <schedule+0x3c>
ffffffffc020737c:	00093783          	ld	a5,0(s2)
ffffffffc0207380:	6088                	ld	a0,0(s1)
ffffffffc0207382:	6b9c                	ld	a5,16(a5)
ffffffffc0207384:	9782                	jalr	a5
ffffffffc0207386:	bf41                	j	ffffffffc0207316 <schedule+0x3c>
ffffffffc0207388:	8e9f90ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc020738c:	4985                	li	s3,1
ffffffffc020738e:	b78d                	j	ffffffffc02072f0 <schedule+0x16>

ffffffffc0207390 <add_timer>:
ffffffffc0207390:	1101                	addi	sp,sp,-32
ffffffffc0207392:	ec06                	sd	ra,24(sp)
ffffffffc0207394:	100027f3          	csrr	a5,sstatus
ffffffffc0207398:	8b89                	andi	a5,a5,2
ffffffffc020739a:	4801                	li	a6,0
ffffffffc020739c:	e7bd                	bnez	a5,ffffffffc020740a <add_timer+0x7a>
ffffffffc020739e:	4118                	lw	a4,0(a0)
ffffffffc02073a0:	cb3d                	beqz	a4,ffffffffc0207416 <add_timer+0x86>
ffffffffc02073a2:	651c                	ld	a5,8(a0)
ffffffffc02073a4:	cbad                	beqz	a5,ffffffffc0207416 <add_timer+0x86>
ffffffffc02073a6:	6d1c                	ld	a5,24(a0)
ffffffffc02073a8:	01050593          	addi	a1,a0,16
ffffffffc02073ac:	08f59563          	bne	a1,a5,ffffffffc0207436 <add_timer+0xa6>
ffffffffc02073b0:	0008e617          	auipc	a2,0x8e
ffffffffc02073b4:	44060613          	addi	a2,a2,1088 # ffffffffc02957f0 <timer_list>
ffffffffc02073b8:	661c                	ld	a5,8(a2)
ffffffffc02073ba:	00c79863          	bne	a5,a2,ffffffffc02073ca <add_timer+0x3a>
ffffffffc02073be:	a805                	j	ffffffffc02073ee <add_timer+0x5e>
ffffffffc02073c0:	679c                	ld	a5,8(a5)
ffffffffc02073c2:	9f15                	subw	a4,a4,a3
ffffffffc02073c4:	c118                	sw	a4,0(a0)
ffffffffc02073c6:	02c78463          	beq	a5,a2,ffffffffc02073ee <add_timer+0x5e>
ffffffffc02073ca:	ff07a683          	lw	a3,-16(a5)
ffffffffc02073ce:	fed779e3          	bgeu	a4,a3,ffffffffc02073c0 <add_timer+0x30>
ffffffffc02073d2:	9e99                	subw	a3,a3,a4
ffffffffc02073d4:	6398                	ld	a4,0(a5)
ffffffffc02073d6:	fed7a823          	sw	a3,-16(a5)
ffffffffc02073da:	e38c                	sd	a1,0(a5)
ffffffffc02073dc:	e70c                	sd	a1,8(a4)
ffffffffc02073de:	e918                	sd	a4,16(a0)
ffffffffc02073e0:	ed1c                	sd	a5,24(a0)
ffffffffc02073e2:	02080163          	beqz	a6,ffffffffc0207404 <add_timer+0x74>
ffffffffc02073e6:	60e2                	ld	ra,24(sp)
ffffffffc02073e8:	6105                	addi	sp,sp,32
ffffffffc02073ea:	881f906f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc02073ee:	0008e797          	auipc	a5,0x8e
ffffffffc02073f2:	40278793          	addi	a5,a5,1026 # ffffffffc02957f0 <timer_list>
ffffffffc02073f6:	6398                	ld	a4,0(a5)
ffffffffc02073f8:	e38c                	sd	a1,0(a5)
ffffffffc02073fa:	e70c                	sd	a1,8(a4)
ffffffffc02073fc:	e918                	sd	a4,16(a0)
ffffffffc02073fe:	ed1c                	sd	a5,24(a0)
ffffffffc0207400:	fe0813e3          	bnez	a6,ffffffffc02073e6 <add_timer+0x56>
ffffffffc0207404:	60e2                	ld	ra,24(sp)
ffffffffc0207406:	6105                	addi	sp,sp,32
ffffffffc0207408:	8082                	ret
ffffffffc020740a:	e42a                	sd	a0,8(sp)
ffffffffc020740c:	865f90ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0207410:	6522                	ld	a0,8(sp)
ffffffffc0207412:	4805                	li	a6,1
ffffffffc0207414:	b769                	j	ffffffffc020739e <add_timer+0xe>
ffffffffc0207416:	00006697          	auipc	a3,0x6
ffffffffc020741a:	53268693          	addi	a3,a3,1330 # ffffffffc020d948 <etext+0x234e>
ffffffffc020741e:	00004617          	auipc	a2,0x4
ffffffffc0207422:	61a60613          	addi	a2,a2,1562 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0207426:	07a00593          	li	a1,122
ffffffffc020742a:	00006517          	auipc	a0,0x6
ffffffffc020742e:	4e650513          	addi	a0,a0,1254 # ffffffffc020d910 <etext+0x2316>
ffffffffc0207432:	818f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207436:	00006697          	auipc	a3,0x6
ffffffffc020743a:	54268693          	addi	a3,a3,1346 # ffffffffc020d978 <etext+0x237e>
ffffffffc020743e:	00004617          	auipc	a2,0x4
ffffffffc0207442:	5fa60613          	addi	a2,a2,1530 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0207446:	07b00593          	li	a1,123
ffffffffc020744a:	00006517          	auipc	a0,0x6
ffffffffc020744e:	4c650513          	addi	a0,a0,1222 # ffffffffc020d910 <etext+0x2316>
ffffffffc0207452:	ff9f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207456 <del_timer>:
ffffffffc0207456:	100027f3          	csrr	a5,sstatus
ffffffffc020745a:	8b89                	andi	a5,a5,2
ffffffffc020745c:	ef95                	bnez	a5,ffffffffc0207498 <del_timer+0x42>
ffffffffc020745e:	6d1c                	ld	a5,24(a0)
ffffffffc0207460:	01050713          	addi	a4,a0,16
ffffffffc0207464:	4601                	li	a2,0
ffffffffc0207466:	02f70863          	beq	a4,a5,ffffffffc0207496 <del_timer+0x40>
ffffffffc020746a:	0008e597          	auipc	a1,0x8e
ffffffffc020746e:	38658593          	addi	a1,a1,902 # ffffffffc02957f0 <timer_list>
ffffffffc0207472:	4114                	lw	a3,0(a0)
ffffffffc0207474:	00b78863          	beq	a5,a1,ffffffffc0207484 <del_timer+0x2e>
ffffffffc0207478:	c691                	beqz	a3,ffffffffc0207484 <del_timer+0x2e>
ffffffffc020747a:	ff07a583          	lw	a1,-16(a5)
ffffffffc020747e:	9ead                	addw	a3,a3,a1
ffffffffc0207480:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207484:	6914                	ld	a3,16(a0)
ffffffffc0207486:	e69c                	sd	a5,8(a3)
ffffffffc0207488:	e394                	sd	a3,0(a5)
ffffffffc020748a:	ed18                	sd	a4,24(a0)
ffffffffc020748c:	e918                	sd	a4,16(a0)
ffffffffc020748e:	e211                	bnez	a2,ffffffffc0207492 <del_timer+0x3c>
ffffffffc0207490:	8082                	ret
ffffffffc0207492:	fd8f906f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc0207496:	8082                	ret
ffffffffc0207498:	1101                	addi	sp,sp,-32
ffffffffc020749a:	e42a                	sd	a0,8(sp)
ffffffffc020749c:	ec06                	sd	ra,24(sp)
ffffffffc020749e:	fd2f90ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02074a2:	6522                	ld	a0,8(sp)
ffffffffc02074a4:	4605                	li	a2,1
ffffffffc02074a6:	6d1c                	ld	a5,24(a0)
ffffffffc02074a8:	01050713          	addi	a4,a0,16
ffffffffc02074ac:	02f70863          	beq	a4,a5,ffffffffc02074dc <del_timer+0x86>
ffffffffc02074b0:	0008e597          	auipc	a1,0x8e
ffffffffc02074b4:	34058593          	addi	a1,a1,832 # ffffffffc02957f0 <timer_list>
ffffffffc02074b8:	4114                	lw	a3,0(a0)
ffffffffc02074ba:	00b78863          	beq	a5,a1,ffffffffc02074ca <del_timer+0x74>
ffffffffc02074be:	c691                	beqz	a3,ffffffffc02074ca <del_timer+0x74>
ffffffffc02074c0:	ff07a583          	lw	a1,-16(a5)
ffffffffc02074c4:	9ead                	addw	a3,a3,a1
ffffffffc02074c6:	fed7a823          	sw	a3,-16(a5)
ffffffffc02074ca:	6914                	ld	a3,16(a0)
ffffffffc02074cc:	e69c                	sd	a5,8(a3)
ffffffffc02074ce:	e394                	sd	a3,0(a5)
ffffffffc02074d0:	ed18                	sd	a4,24(a0)
ffffffffc02074d2:	e918                	sd	a4,16(a0)
ffffffffc02074d4:	e601                	bnez	a2,ffffffffc02074dc <del_timer+0x86>
ffffffffc02074d6:	60e2                	ld	ra,24(sp)
ffffffffc02074d8:	6105                	addi	sp,sp,32
ffffffffc02074da:	8082                	ret
ffffffffc02074dc:	60e2                	ld	ra,24(sp)
ffffffffc02074de:	6105                	addi	sp,sp,32
ffffffffc02074e0:	f8af906f          	j	ffffffffc0200c6a <intr_enable>

ffffffffc02074e4 <run_timer_list>:
ffffffffc02074e4:	7179                	addi	sp,sp,-48
ffffffffc02074e6:	f406                	sd	ra,40(sp)
ffffffffc02074e8:	f022                	sd	s0,32(sp)
ffffffffc02074ea:	e44e                	sd	s3,8(sp)
ffffffffc02074ec:	e052                	sd	s4,0(sp)
ffffffffc02074ee:	100027f3          	csrr	a5,sstatus
ffffffffc02074f2:	8b89                	andi	a5,a5,2
ffffffffc02074f4:	0e079b63          	bnez	a5,ffffffffc02075ea <run_timer_list+0x106>
ffffffffc02074f8:	0008e997          	auipc	s3,0x8e
ffffffffc02074fc:	2f898993          	addi	s3,s3,760 # ffffffffc02957f0 <timer_list>
ffffffffc0207500:	0089b403          	ld	s0,8(s3)
ffffffffc0207504:	4a01                	li	s4,0
ffffffffc0207506:	0d340463          	beq	s0,s3,ffffffffc02075ce <run_timer_list+0xea>
ffffffffc020750a:	ff042783          	lw	a5,-16(s0)
ffffffffc020750e:	12078763          	beqz	a5,ffffffffc020763c <run_timer_list+0x158>
ffffffffc0207512:	e84a                	sd	s2,16(sp)
ffffffffc0207514:	37fd                	addiw	a5,a5,-1
ffffffffc0207516:	fef42823          	sw	a5,-16(s0)
ffffffffc020751a:	ff040913          	addi	s2,s0,-16
ffffffffc020751e:	efb1                	bnez	a5,ffffffffc020757a <run_timer_list+0x96>
ffffffffc0207520:	ec26                	sd	s1,24(sp)
ffffffffc0207522:	a005                	j	ffffffffc0207542 <run_timer_list+0x5e>
ffffffffc0207524:	0e07dc63          	bgez	a5,ffffffffc020761c <run_timer_list+0x138>
ffffffffc0207528:	8526                	mv	a0,s1
ffffffffc020752a:	cb9ff0ef          	jal	ffffffffc02071e2 <wakeup_proc>
ffffffffc020752e:	854a                	mv	a0,s2
ffffffffc0207530:	f27ff0ef          	jal	ffffffffc0207456 <del_timer>
ffffffffc0207534:	05340263          	beq	s0,s3,ffffffffc0207578 <run_timer_list+0x94>
ffffffffc0207538:	ff042783          	lw	a5,-16(s0)
ffffffffc020753c:	ff040913          	addi	s2,s0,-16
ffffffffc0207540:	ef85                	bnez	a5,ffffffffc0207578 <run_timer_list+0x94>
ffffffffc0207542:	00893483          	ld	s1,8(s2)
ffffffffc0207546:	6400                	ld	s0,8(s0)
ffffffffc0207548:	0ec4a783          	lw	a5,236(s1)
ffffffffc020754c:	ffe1                	bnez	a5,ffffffffc0207524 <run_timer_list+0x40>
ffffffffc020754e:	40d4                	lw	a3,4(s1)
ffffffffc0207550:	00006617          	auipc	a2,0x6
ffffffffc0207554:	49060613          	addi	a2,a2,1168 # ffffffffc020d9e0 <etext+0x23e6>
ffffffffc0207558:	0ba00593          	li	a1,186
ffffffffc020755c:	00006517          	auipc	a0,0x6
ffffffffc0207560:	3b450513          	addi	a0,a0,948 # ffffffffc020d910 <etext+0x2316>
ffffffffc0207564:	f51f80ef          	jal	ffffffffc02004b4 <__warn>
ffffffffc0207568:	8526                	mv	a0,s1
ffffffffc020756a:	c79ff0ef          	jal	ffffffffc02071e2 <wakeup_proc>
ffffffffc020756e:	854a                	mv	a0,s2
ffffffffc0207570:	ee7ff0ef          	jal	ffffffffc0207456 <del_timer>
ffffffffc0207574:	fd3412e3          	bne	s0,s3,ffffffffc0207538 <run_timer_list+0x54>
ffffffffc0207578:	64e2                	ld	s1,24(sp)
ffffffffc020757a:	0008f597          	auipc	a1,0x8f
ffffffffc020757e:	34e5b583          	ld	a1,846(a1) # ffffffffc02968c8 <current>
ffffffffc0207582:	cd85                	beqz	a1,ffffffffc02075ba <run_timer_list+0xd6>
ffffffffc0207584:	0008f797          	auipc	a5,0x8f
ffffffffc0207588:	3547b783          	ld	a5,852(a5) # ffffffffc02968d8 <idleproc>
ffffffffc020758c:	02f58563          	beq	a1,a5,ffffffffc02075b6 <run_timer_list+0xd2>
ffffffffc0207590:	6942                	ld	s2,16(sp)
ffffffffc0207592:	0008f797          	auipc	a5,0x8f
ffffffffc0207596:	3567b783          	ld	a5,854(a5) # ffffffffc02968e8 <sched_class>
ffffffffc020759a:	0008f517          	auipc	a0,0x8f
ffffffffc020759e:	34653503          	ld	a0,838(a0) # ffffffffc02968e0 <rq>
ffffffffc02075a2:	779c                	ld	a5,40(a5)
ffffffffc02075a4:	9782                	jalr	a5
ffffffffc02075a6:	000a1d63          	bnez	s4,ffffffffc02075c0 <run_timer_list+0xdc>
ffffffffc02075aa:	70a2                	ld	ra,40(sp)
ffffffffc02075ac:	7402                	ld	s0,32(sp)
ffffffffc02075ae:	69a2                	ld	s3,8(sp)
ffffffffc02075b0:	6a02                	ld	s4,0(sp)
ffffffffc02075b2:	6145                	addi	sp,sp,48
ffffffffc02075b4:	8082                	ret
ffffffffc02075b6:	4785                	li	a5,1
ffffffffc02075b8:	ed9c                	sd	a5,24(a1)
ffffffffc02075ba:	6942                	ld	s2,16(sp)
ffffffffc02075bc:	fe0a07e3          	beqz	s4,ffffffffc02075aa <run_timer_list+0xc6>
ffffffffc02075c0:	7402                	ld	s0,32(sp)
ffffffffc02075c2:	70a2                	ld	ra,40(sp)
ffffffffc02075c4:	69a2                	ld	s3,8(sp)
ffffffffc02075c6:	6a02                	ld	s4,0(sp)
ffffffffc02075c8:	6145                	addi	sp,sp,48
ffffffffc02075ca:	ea0f906f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc02075ce:	0008f597          	auipc	a1,0x8f
ffffffffc02075d2:	2fa5b583          	ld	a1,762(a1) # ffffffffc02968c8 <current>
ffffffffc02075d6:	d9f1                	beqz	a1,ffffffffc02075aa <run_timer_list+0xc6>
ffffffffc02075d8:	0008f797          	auipc	a5,0x8f
ffffffffc02075dc:	3007b783          	ld	a5,768(a5) # ffffffffc02968d8 <idleproc>
ffffffffc02075e0:	fab799e3          	bne	a5,a1,ffffffffc0207592 <run_timer_list+0xae>
ffffffffc02075e4:	4705                	li	a4,1
ffffffffc02075e6:	ef98                	sd	a4,24(a5)
ffffffffc02075e8:	b7c9                	j	ffffffffc02075aa <run_timer_list+0xc6>
ffffffffc02075ea:	0008e997          	auipc	s3,0x8e
ffffffffc02075ee:	20698993          	addi	s3,s3,518 # ffffffffc02957f0 <timer_list>
ffffffffc02075f2:	e7ef90ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02075f6:	0089b403          	ld	s0,8(s3)
ffffffffc02075fa:	4a05                	li	s4,1
ffffffffc02075fc:	f13417e3          	bne	s0,s3,ffffffffc020750a <run_timer_list+0x26>
ffffffffc0207600:	0008f597          	auipc	a1,0x8f
ffffffffc0207604:	2c85b583          	ld	a1,712(a1) # ffffffffc02968c8 <current>
ffffffffc0207608:	ddc5                	beqz	a1,ffffffffc02075c0 <run_timer_list+0xdc>
ffffffffc020760a:	0008f797          	auipc	a5,0x8f
ffffffffc020760e:	2ce7b783          	ld	a5,718(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0207612:	f8f590e3          	bne	a1,a5,ffffffffc0207592 <run_timer_list+0xae>
ffffffffc0207616:	0145bc23          	sd	s4,24(a1)
ffffffffc020761a:	b75d                	j	ffffffffc02075c0 <run_timer_list+0xdc>
ffffffffc020761c:	00006697          	auipc	a3,0x6
ffffffffc0207620:	39c68693          	addi	a3,a3,924 # ffffffffc020d9b8 <etext+0x23be>
ffffffffc0207624:	00004617          	auipc	a2,0x4
ffffffffc0207628:	41460613          	addi	a2,a2,1044 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020762c:	0b600593          	li	a1,182
ffffffffc0207630:	00006517          	auipc	a0,0x6
ffffffffc0207634:	2e050513          	addi	a0,a0,736 # ffffffffc020d910 <etext+0x2316>
ffffffffc0207638:	e13f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc020763c:	00006697          	auipc	a3,0x6
ffffffffc0207640:	36468693          	addi	a3,a3,868 # ffffffffc020d9a0 <etext+0x23a6>
ffffffffc0207644:	00004617          	auipc	a2,0x4
ffffffffc0207648:	3f460613          	addi	a2,a2,1012 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020764c:	0ae00593          	li	a1,174
ffffffffc0207650:	00006517          	auipc	a0,0x6
ffffffffc0207654:	2c050513          	addi	a0,a0,704 # ffffffffc020d910 <etext+0x2316>
ffffffffc0207658:	ec26                	sd	s1,24(sp)
ffffffffc020765a:	e84a                	sd	s2,16(sp)
ffffffffc020765c:	deff80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207660 <sys_getpid>:
ffffffffc0207660:	0008f797          	auipc	a5,0x8f
ffffffffc0207664:	2687b783          	ld	a5,616(a5) # ffffffffc02968c8 <current>
ffffffffc0207668:	43c8                	lw	a0,4(a5)
ffffffffc020766a:	8082                	ret

ffffffffc020766c <sys_pgdir>:
ffffffffc020766c:	4501                	li	a0,0
ffffffffc020766e:	8082                	ret

ffffffffc0207670 <sys_gettime>:
ffffffffc0207670:	0008f797          	auipc	a5,0x8f
ffffffffc0207674:	2007b783          	ld	a5,512(a5) # ffffffffc0296870 <ticks>
ffffffffc0207678:	0027951b          	slliw	a0,a5,0x2
ffffffffc020767c:	9d3d                	addw	a0,a0,a5
ffffffffc020767e:	0015151b          	slliw	a0,a0,0x1
ffffffffc0207682:	8082                	ret

ffffffffc0207684 <sys_lab6_set_priority>:
ffffffffc0207684:	4108                	lw	a0,0(a0)
ffffffffc0207686:	1141                	addi	sp,sp,-16
ffffffffc0207688:	e406                	sd	ra,8(sp)
ffffffffc020768a:	8fbff0ef          	jal	ffffffffc0206f84 <lab6_set_priority>
ffffffffc020768e:	60a2                	ld	ra,8(sp)
ffffffffc0207690:	4501                	li	a0,0
ffffffffc0207692:	0141                	addi	sp,sp,16
ffffffffc0207694:	8082                	ret

ffffffffc0207696 <sys_dup>:
ffffffffc0207696:	450c                	lw	a1,8(a0)
ffffffffc0207698:	4108                	lw	a0,0(a0)
ffffffffc020769a:	a3efe06f          	j	ffffffffc02058d8 <sysfile_dup>

ffffffffc020769e <sys_getdirentry>:
ffffffffc020769e:	650c                	ld	a1,8(a0)
ffffffffc02076a0:	4108                	lw	a0,0(a0)
ffffffffc02076a2:	946fe06f          	j	ffffffffc02057e8 <sysfile_getdirentry>

ffffffffc02076a6 <sys_getcwd>:
ffffffffc02076a6:	650c                	ld	a1,8(a0)
ffffffffc02076a8:	6108                	ld	a0,0(a0)
ffffffffc02076aa:	894fe06f          	j	ffffffffc020573e <sysfile_getcwd>

ffffffffc02076ae <sys_fsync>:
ffffffffc02076ae:	4108                	lw	a0,0(a0)
ffffffffc02076b0:	88afe06f          	j	ffffffffc020573a <sysfile_fsync>

ffffffffc02076b4 <sys_fstat>:
ffffffffc02076b4:	650c                	ld	a1,8(a0)
ffffffffc02076b6:	4108                	lw	a0,0(a0)
ffffffffc02076b8:	ffbfd06f          	j	ffffffffc02056b2 <sysfile_fstat>

ffffffffc02076bc <sys_seek>:
ffffffffc02076bc:	4910                	lw	a2,16(a0)
ffffffffc02076be:	650c                	ld	a1,8(a0)
ffffffffc02076c0:	4108                	lw	a0,0(a0)
ffffffffc02076c2:	fedfd06f          	j	ffffffffc02056ae <sysfile_seek>

ffffffffc02076c6 <sys_write>:
ffffffffc02076c6:	6910                	ld	a2,16(a0)
ffffffffc02076c8:	650c                	ld	a1,8(a0)
ffffffffc02076ca:	4108                	lw	a0,0(a0)
ffffffffc02076cc:	eb1fd06f          	j	ffffffffc020557c <sysfile_write>

ffffffffc02076d0 <sys_read>:
ffffffffc02076d0:	6910                	ld	a2,16(a0)
ffffffffc02076d2:	650c                	ld	a1,8(a0)
ffffffffc02076d4:	4108                	lw	a0,0(a0)
ffffffffc02076d6:	d5bfd06f          	j	ffffffffc0205430 <sysfile_read>

ffffffffc02076da <sys_close>:
ffffffffc02076da:	4108                	lw	a0,0(a0)
ffffffffc02076dc:	d51fd06f          	j	ffffffffc020542c <sysfile_close>

ffffffffc02076e0 <sys_open>:
ffffffffc02076e0:	450c                	lw	a1,8(a0)
ffffffffc02076e2:	6108                	ld	a0,0(a0)
ffffffffc02076e4:	d13fd06f          	j	ffffffffc02053f6 <sysfile_open>

ffffffffc02076e8 <sys_putc>:
ffffffffc02076e8:	4108                	lw	a0,0(a0)
ffffffffc02076ea:	1141                	addi	sp,sp,-16
ffffffffc02076ec:	e406                	sd	ra,8(sp)
ffffffffc02076ee:	af3f80ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc02076f2:	60a2                	ld	ra,8(sp)
ffffffffc02076f4:	4501                	li	a0,0
ffffffffc02076f6:	0141                	addi	sp,sp,16
ffffffffc02076f8:	8082                	ret

ffffffffc02076fa <sys_kill>:
ffffffffc02076fa:	4108                	lw	a0,0(a0)
ffffffffc02076fc:	e22ff06f          	j	ffffffffc0206d1e <do_kill>

ffffffffc0207700 <sys_sleep>:
ffffffffc0207700:	4108                	lw	a0,0(a0)
ffffffffc0207702:	8b1ff06f          	j	ffffffffc0206fb2 <do_sleep>

ffffffffc0207706 <sys_yield>:
ffffffffc0207706:	dceff06f          	j	ffffffffc0206cd4 <do_yield>

ffffffffc020770a <sys_exec>:
ffffffffc020770a:	6910                	ld	a2,16(a0)
ffffffffc020770c:	450c                	lw	a1,8(a0)
ffffffffc020770e:	6108                	ld	a0,0(a0)
ffffffffc0207710:	cebfe06f          	j	ffffffffc02063fa <do_execve>

ffffffffc0207714 <sys_wait>:
ffffffffc0207714:	650c                	ld	a1,8(a0)
ffffffffc0207716:	4108                	lw	a0,0(a0)
ffffffffc0207718:	dccff06f          	j	ffffffffc0206ce4 <do_wait>

ffffffffc020771c <sys_fork>:
ffffffffc020771c:	0008f797          	auipc	a5,0x8f
ffffffffc0207720:	1ac7b783          	ld	a5,428(a5) # ffffffffc02968c8 <current>
ffffffffc0207724:	4501                	li	a0,0
ffffffffc0207726:	73d0                	ld	a2,160(a5)
ffffffffc0207728:	6a0c                	ld	a1,16(a2)
ffffffffc020772a:	bc4fe06f          	j	ffffffffc0205aee <do_fork>

ffffffffc020772e <sys_exit>:
ffffffffc020772e:	4108                	lw	a0,0(a0)
ffffffffc0207730:	839fe06f          	j	ffffffffc0205f68 <do_exit>

ffffffffc0207734 <syscall>:
ffffffffc0207734:	0008f697          	auipc	a3,0x8f
ffffffffc0207738:	1946b683          	ld	a3,404(a3) # ffffffffc02968c8 <current>
ffffffffc020773c:	715d                	addi	sp,sp,-80
ffffffffc020773e:	e0a2                	sd	s0,64(sp)
ffffffffc0207740:	72c0                	ld	s0,160(a3)
ffffffffc0207742:	e486                	sd	ra,72(sp)
ffffffffc0207744:	0ff00793          	li	a5,255
ffffffffc0207748:	4834                	lw	a3,80(s0)
ffffffffc020774a:	02d7ec63          	bltu	a5,a3,ffffffffc0207782 <syscall+0x4e>
ffffffffc020774e:	00007797          	auipc	a5,0x7
ffffffffc0207752:	53a78793          	addi	a5,a5,1338 # ffffffffc020ec88 <syscalls>
ffffffffc0207756:	00369613          	slli	a2,a3,0x3
ffffffffc020775a:	97b2                	add	a5,a5,a2
ffffffffc020775c:	639c                	ld	a5,0(a5)
ffffffffc020775e:	c395                	beqz	a5,ffffffffc0207782 <syscall+0x4e>
ffffffffc0207760:	7028                	ld	a0,96(s0)
ffffffffc0207762:	742c                	ld	a1,104(s0)
ffffffffc0207764:	7830                	ld	a2,112(s0)
ffffffffc0207766:	7c34                	ld	a3,120(s0)
ffffffffc0207768:	6c38                	ld	a4,88(s0)
ffffffffc020776a:	f02a                	sd	a0,32(sp)
ffffffffc020776c:	f42e                	sd	a1,40(sp)
ffffffffc020776e:	f832                	sd	a2,48(sp)
ffffffffc0207770:	fc36                	sd	a3,56(sp)
ffffffffc0207772:	ec3a                	sd	a4,24(sp)
ffffffffc0207774:	0828                	addi	a0,sp,24
ffffffffc0207776:	9782                	jalr	a5
ffffffffc0207778:	60a6                	ld	ra,72(sp)
ffffffffc020777a:	e828                	sd	a0,80(s0)
ffffffffc020777c:	6406                	ld	s0,64(sp)
ffffffffc020777e:	6161                	addi	sp,sp,80
ffffffffc0207780:	8082                	ret
ffffffffc0207782:	8522                	mv	a0,s0
ffffffffc0207784:	e436                	sd	a3,8(sp)
ffffffffc0207786:	ffef90ef          	jal	ffffffffc0200f84 <print_trapframe>
ffffffffc020778a:	0008f797          	auipc	a5,0x8f
ffffffffc020778e:	13e7b783          	ld	a5,318(a5) # ffffffffc02968c8 <current>
ffffffffc0207792:	66a2                	ld	a3,8(sp)
ffffffffc0207794:	00006617          	auipc	a2,0x6
ffffffffc0207798:	26c60613          	addi	a2,a2,620 # ffffffffc020da00 <etext+0x2406>
ffffffffc020779c:	43d8                	lw	a4,4(a5)
ffffffffc020779e:	0d800593          	li	a1,216
ffffffffc02077a2:	0b478793          	addi	a5,a5,180
ffffffffc02077a6:	00006517          	auipc	a0,0x6
ffffffffc02077aa:	28a50513          	addi	a0,a0,650 # ffffffffc020da30 <etext+0x2436>
ffffffffc02077ae:	c9df80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02077b2 <__alloc_inode>:
ffffffffc02077b2:	1141                	addi	sp,sp,-16
ffffffffc02077b4:	e022                	sd	s0,0(sp)
ffffffffc02077b6:	842a                	mv	s0,a0
ffffffffc02077b8:	07800513          	li	a0,120
ffffffffc02077bc:	e406                	sd	ra,8(sp)
ffffffffc02077be:	893fa0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc02077c2:	c111                	beqz	a0,ffffffffc02077c6 <__alloc_inode+0x14>
ffffffffc02077c4:	cd20                	sw	s0,88(a0)
ffffffffc02077c6:	60a2                	ld	ra,8(sp)
ffffffffc02077c8:	6402                	ld	s0,0(sp)
ffffffffc02077ca:	0141                	addi	sp,sp,16
ffffffffc02077cc:	8082                	ret

ffffffffc02077ce <inode_init>:
ffffffffc02077ce:	4785                	li	a5,1
ffffffffc02077d0:	06052023          	sw	zero,96(a0)
ffffffffc02077d4:	f92c                	sd	a1,112(a0)
ffffffffc02077d6:	f530                	sd	a2,104(a0)
ffffffffc02077d8:	cd7c                	sw	a5,92(a0)
ffffffffc02077da:	8082                	ret

ffffffffc02077dc <inode_kill>:
ffffffffc02077dc:	4d78                	lw	a4,92(a0)
ffffffffc02077de:	1141                	addi	sp,sp,-16
ffffffffc02077e0:	e406                	sd	ra,8(sp)
ffffffffc02077e2:	e719                	bnez	a4,ffffffffc02077f0 <inode_kill+0x14>
ffffffffc02077e4:	513c                	lw	a5,96(a0)
ffffffffc02077e6:	e78d                	bnez	a5,ffffffffc0207810 <inode_kill+0x34>
ffffffffc02077e8:	60a2                	ld	ra,8(sp)
ffffffffc02077ea:	0141                	addi	sp,sp,16
ffffffffc02077ec:	90bfa06f          	j	ffffffffc02020f6 <kfree>
ffffffffc02077f0:	00006697          	auipc	a3,0x6
ffffffffc02077f4:	25868693          	addi	a3,a3,600 # ffffffffc020da48 <etext+0x244e>
ffffffffc02077f8:	00004617          	auipc	a2,0x4
ffffffffc02077fc:	24060613          	addi	a2,a2,576 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0207800:	02900593          	li	a1,41
ffffffffc0207804:	00006517          	auipc	a0,0x6
ffffffffc0207808:	26450513          	addi	a0,a0,612 # ffffffffc020da68 <etext+0x246e>
ffffffffc020780c:	c3ff80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207810:	00006697          	auipc	a3,0x6
ffffffffc0207814:	27068693          	addi	a3,a3,624 # ffffffffc020da80 <etext+0x2486>
ffffffffc0207818:	00004617          	auipc	a2,0x4
ffffffffc020781c:	22060613          	addi	a2,a2,544 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0207820:	02a00593          	li	a1,42
ffffffffc0207824:	00006517          	auipc	a0,0x6
ffffffffc0207828:	24450513          	addi	a0,a0,580 # ffffffffc020da68 <etext+0x246e>
ffffffffc020782c:	c1ff80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207830 <inode_ref_inc>:
ffffffffc0207830:	4d7c                	lw	a5,92(a0)
ffffffffc0207832:	2785                	addiw	a5,a5,1
ffffffffc0207834:	cd7c                	sw	a5,92(a0)
ffffffffc0207836:	853e                	mv	a0,a5
ffffffffc0207838:	8082                	ret

ffffffffc020783a <inode_open_inc>:
ffffffffc020783a:	513c                	lw	a5,96(a0)
ffffffffc020783c:	2785                	addiw	a5,a5,1
ffffffffc020783e:	d13c                	sw	a5,96(a0)
ffffffffc0207840:	853e                	mv	a0,a5
ffffffffc0207842:	8082                	ret

ffffffffc0207844 <inode_check>:
ffffffffc0207844:	1141                	addi	sp,sp,-16
ffffffffc0207846:	e406                	sd	ra,8(sp)
ffffffffc0207848:	c91d                	beqz	a0,ffffffffc020787e <inode_check+0x3a>
ffffffffc020784a:	793c                	ld	a5,112(a0)
ffffffffc020784c:	cb8d                	beqz	a5,ffffffffc020787e <inode_check+0x3a>
ffffffffc020784e:	6398                	ld	a4,0(a5)
ffffffffc0207850:	4625d7b7          	lui	a5,0x4625d
ffffffffc0207854:	0786                	slli	a5,a5,0x1
ffffffffc0207856:	47678793          	addi	a5,a5,1142 # 4625d476 <_binary_bin_sfs_img_size+0x461e8176>
ffffffffc020785a:	08f71263          	bne	a4,a5,ffffffffc02078de <inode_check+0x9a>
ffffffffc020785e:	4d74                	lw	a3,92(a0)
ffffffffc0207860:	5138                	lw	a4,96(a0)
ffffffffc0207862:	04e6ce63          	blt	a3,a4,ffffffffc02078be <inode_check+0x7a>
ffffffffc0207866:	01f7579b          	srliw	a5,a4,0x1f
ffffffffc020786a:	ebb1                	bnez	a5,ffffffffc02078be <inode_check+0x7a>
ffffffffc020786c:	67c1                	lui	a5,0x10
ffffffffc020786e:	17fd                	addi	a5,a5,-1 # ffff <_binary_bin_swap_img_size+0x82ff>
ffffffffc0207870:	02d7c763          	blt	a5,a3,ffffffffc020789e <inode_check+0x5a>
ffffffffc0207874:	02e7c563          	blt	a5,a4,ffffffffc020789e <inode_check+0x5a>
ffffffffc0207878:	60a2                	ld	ra,8(sp)
ffffffffc020787a:	0141                	addi	sp,sp,16
ffffffffc020787c:	8082                	ret
ffffffffc020787e:	00006697          	auipc	a3,0x6
ffffffffc0207882:	22268693          	addi	a3,a3,546 # ffffffffc020daa0 <etext+0x24a6>
ffffffffc0207886:	00004617          	auipc	a2,0x4
ffffffffc020788a:	1b260613          	addi	a2,a2,434 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020788e:	06e00593          	li	a1,110
ffffffffc0207892:	00006517          	auipc	a0,0x6
ffffffffc0207896:	1d650513          	addi	a0,a0,470 # ffffffffc020da68 <etext+0x246e>
ffffffffc020789a:	bb1f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc020789e:	00006697          	auipc	a3,0x6
ffffffffc02078a2:	28268693          	addi	a3,a3,642 # ffffffffc020db20 <etext+0x2526>
ffffffffc02078a6:	00004617          	auipc	a2,0x4
ffffffffc02078aa:	19260613          	addi	a2,a2,402 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02078ae:	07200593          	li	a1,114
ffffffffc02078b2:	00006517          	auipc	a0,0x6
ffffffffc02078b6:	1b650513          	addi	a0,a0,438 # ffffffffc020da68 <etext+0x246e>
ffffffffc02078ba:	b91f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02078be:	00006697          	auipc	a3,0x6
ffffffffc02078c2:	23268693          	addi	a3,a3,562 # ffffffffc020daf0 <etext+0x24f6>
ffffffffc02078c6:	00004617          	auipc	a2,0x4
ffffffffc02078ca:	17260613          	addi	a2,a2,370 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02078ce:	07100593          	li	a1,113
ffffffffc02078d2:	00006517          	auipc	a0,0x6
ffffffffc02078d6:	19650513          	addi	a0,a0,406 # ffffffffc020da68 <etext+0x246e>
ffffffffc02078da:	b71f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02078de:	00006697          	auipc	a3,0x6
ffffffffc02078e2:	1ea68693          	addi	a3,a3,490 # ffffffffc020dac8 <etext+0x24ce>
ffffffffc02078e6:	00004617          	auipc	a2,0x4
ffffffffc02078ea:	15260613          	addi	a2,a2,338 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02078ee:	06f00593          	li	a1,111
ffffffffc02078f2:	00006517          	auipc	a0,0x6
ffffffffc02078f6:	17650513          	addi	a0,a0,374 # ffffffffc020da68 <etext+0x246e>
ffffffffc02078fa:	b51f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02078fe <inode_ref_dec>:
ffffffffc02078fe:	4d7c                	lw	a5,92(a0)
ffffffffc0207900:	7179                	addi	sp,sp,-48
ffffffffc0207902:	f406                	sd	ra,40(sp)
ffffffffc0207904:	06f05b63          	blez	a5,ffffffffc020797a <inode_ref_dec+0x7c>
ffffffffc0207908:	37fd                	addiw	a5,a5,-1
ffffffffc020790a:	cd7c                	sw	a5,92(a0)
ffffffffc020790c:	e795                	bnez	a5,ffffffffc0207938 <inode_ref_dec+0x3a>
ffffffffc020790e:	7934                	ld	a3,112(a0)
ffffffffc0207910:	c6a9                	beqz	a3,ffffffffc020795a <inode_ref_dec+0x5c>
ffffffffc0207912:	66b4                	ld	a3,72(a3)
ffffffffc0207914:	c2b9                	beqz	a3,ffffffffc020795a <inode_ref_dec+0x5c>
ffffffffc0207916:	00006597          	auipc	a1,0x6
ffffffffc020791a:	2ba58593          	addi	a1,a1,698 # ffffffffc020dbd0 <etext+0x25d6>
ffffffffc020791e:	e83e                	sd	a5,16(sp)
ffffffffc0207920:	ec2a                	sd	a0,24(sp)
ffffffffc0207922:	e436                	sd	a3,8(sp)
ffffffffc0207924:	f21ff0ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc0207928:	6562                	ld	a0,24(sp)
ffffffffc020792a:	66a2                	ld	a3,8(sp)
ffffffffc020792c:	9682                	jalr	a3
ffffffffc020792e:	00f50713          	addi	a4,a0,15
ffffffffc0207932:	67c2                	ld	a5,16(sp)
ffffffffc0207934:	c311                	beqz	a4,ffffffffc0207938 <inode_ref_dec+0x3a>
ffffffffc0207936:	e509                	bnez	a0,ffffffffc0207940 <inode_ref_dec+0x42>
ffffffffc0207938:	70a2                	ld	ra,40(sp)
ffffffffc020793a:	853e                	mv	a0,a5
ffffffffc020793c:	6145                	addi	sp,sp,48
ffffffffc020793e:	8082                	ret
ffffffffc0207940:	85aa                	mv	a1,a0
ffffffffc0207942:	00006517          	auipc	a0,0x6
ffffffffc0207946:	29650513          	addi	a0,a0,662 # ffffffffc020dbd8 <etext+0x25de>
ffffffffc020794a:	e43e                	sd	a5,8(sp)
ffffffffc020794c:	85bf80ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0207950:	67a2                	ld	a5,8(sp)
ffffffffc0207952:	70a2                	ld	ra,40(sp)
ffffffffc0207954:	853e                	mv	a0,a5
ffffffffc0207956:	6145                	addi	sp,sp,48
ffffffffc0207958:	8082                	ret
ffffffffc020795a:	00006697          	auipc	a3,0x6
ffffffffc020795e:	22668693          	addi	a3,a3,550 # ffffffffc020db80 <etext+0x2586>
ffffffffc0207962:	00004617          	auipc	a2,0x4
ffffffffc0207966:	0d660613          	addi	a2,a2,214 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020796a:	04400593          	li	a1,68
ffffffffc020796e:	00006517          	auipc	a0,0x6
ffffffffc0207972:	0fa50513          	addi	a0,a0,250 # ffffffffc020da68 <etext+0x246e>
ffffffffc0207976:	ad5f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc020797a:	00006697          	auipc	a3,0x6
ffffffffc020797e:	1e668693          	addi	a3,a3,486 # ffffffffc020db60 <etext+0x2566>
ffffffffc0207982:	00004617          	auipc	a2,0x4
ffffffffc0207986:	0b660613          	addi	a2,a2,182 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020798a:	03f00593          	li	a1,63
ffffffffc020798e:	00006517          	auipc	a0,0x6
ffffffffc0207992:	0da50513          	addi	a0,a0,218 # ffffffffc020da68 <etext+0x246e>
ffffffffc0207996:	ab5f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc020799a <inode_open_dec>:
ffffffffc020799a:	513c                	lw	a5,96(a0)
ffffffffc020799c:	7179                	addi	sp,sp,-48
ffffffffc020799e:	f406                	sd	ra,40(sp)
ffffffffc02079a0:	06f05863          	blez	a5,ffffffffc0207a10 <inode_open_dec+0x76>
ffffffffc02079a4:	37fd                	addiw	a5,a5,-1
ffffffffc02079a6:	d13c                	sw	a5,96(a0)
ffffffffc02079a8:	e39d                	bnez	a5,ffffffffc02079ce <inode_open_dec+0x34>
ffffffffc02079aa:	7934                	ld	a3,112(a0)
ffffffffc02079ac:	c2b1                	beqz	a3,ffffffffc02079f0 <inode_open_dec+0x56>
ffffffffc02079ae:	6a94                	ld	a3,16(a3)
ffffffffc02079b0:	c2a1                	beqz	a3,ffffffffc02079f0 <inode_open_dec+0x56>
ffffffffc02079b2:	00006597          	auipc	a1,0x6
ffffffffc02079b6:	2b658593          	addi	a1,a1,694 # ffffffffc020dc68 <etext+0x266e>
ffffffffc02079ba:	e83e                	sd	a5,16(sp)
ffffffffc02079bc:	ec2a                	sd	a0,24(sp)
ffffffffc02079be:	e436                	sd	a3,8(sp)
ffffffffc02079c0:	e85ff0ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc02079c4:	6562                	ld	a0,24(sp)
ffffffffc02079c6:	66a2                	ld	a3,8(sp)
ffffffffc02079c8:	9682                	jalr	a3
ffffffffc02079ca:	67c2                	ld	a5,16(sp)
ffffffffc02079cc:	e509                	bnez	a0,ffffffffc02079d6 <inode_open_dec+0x3c>
ffffffffc02079ce:	70a2                	ld	ra,40(sp)
ffffffffc02079d0:	853e                	mv	a0,a5
ffffffffc02079d2:	6145                	addi	sp,sp,48
ffffffffc02079d4:	8082                	ret
ffffffffc02079d6:	85aa                	mv	a1,a0
ffffffffc02079d8:	00006517          	auipc	a0,0x6
ffffffffc02079dc:	29850513          	addi	a0,a0,664 # ffffffffc020dc70 <etext+0x2676>
ffffffffc02079e0:	e43e                	sd	a5,8(sp)
ffffffffc02079e2:	fc4f80ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02079e6:	67a2                	ld	a5,8(sp)
ffffffffc02079e8:	70a2                	ld	ra,40(sp)
ffffffffc02079ea:	853e                	mv	a0,a5
ffffffffc02079ec:	6145                	addi	sp,sp,48
ffffffffc02079ee:	8082                	ret
ffffffffc02079f0:	00006697          	auipc	a3,0x6
ffffffffc02079f4:	22868693          	addi	a3,a3,552 # ffffffffc020dc18 <etext+0x261e>
ffffffffc02079f8:	00004617          	auipc	a2,0x4
ffffffffc02079fc:	04060613          	addi	a2,a2,64 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0207a00:	06100593          	li	a1,97
ffffffffc0207a04:	00006517          	auipc	a0,0x6
ffffffffc0207a08:	06450513          	addi	a0,a0,100 # ffffffffc020da68 <etext+0x246e>
ffffffffc0207a0c:	a3ff80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207a10:	00006697          	auipc	a3,0x6
ffffffffc0207a14:	1e868693          	addi	a3,a3,488 # ffffffffc020dbf8 <etext+0x25fe>
ffffffffc0207a18:	00004617          	auipc	a2,0x4
ffffffffc0207a1c:	02060613          	addi	a2,a2,32 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0207a20:	05c00593          	li	a1,92
ffffffffc0207a24:	00006517          	auipc	a0,0x6
ffffffffc0207a28:	04450513          	addi	a0,a0,68 # ffffffffc020da68 <etext+0x246e>
ffffffffc0207a2c:	a1ff80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207a30 <__alloc_fs>:
ffffffffc0207a30:	1141                	addi	sp,sp,-16
ffffffffc0207a32:	e022                	sd	s0,0(sp)
ffffffffc0207a34:	842a                	mv	s0,a0
ffffffffc0207a36:	0d800513          	li	a0,216
ffffffffc0207a3a:	e406                	sd	ra,8(sp)
ffffffffc0207a3c:	e14fa0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc0207a40:	c119                	beqz	a0,ffffffffc0207a46 <__alloc_fs+0x16>
ffffffffc0207a42:	0a852823          	sw	s0,176(a0)
ffffffffc0207a46:	60a2                	ld	ra,8(sp)
ffffffffc0207a48:	6402                	ld	s0,0(sp)
ffffffffc0207a4a:	0141                	addi	sp,sp,16
ffffffffc0207a4c:	8082                	ret

ffffffffc0207a4e <vfs_init>:
ffffffffc0207a4e:	1141                	addi	sp,sp,-16
ffffffffc0207a50:	4585                	li	a1,1
ffffffffc0207a52:	0008e517          	auipc	a0,0x8e
ffffffffc0207a56:	dae50513          	addi	a0,a0,-594 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207a5a:	e406                	sd	ra,8(sp)
ffffffffc0207a5c:	9b3fc0ef          	jal	ffffffffc020440e <sem_init>
ffffffffc0207a60:	60a2                	ld	ra,8(sp)
ffffffffc0207a62:	0141                	addi	sp,sp,16
ffffffffc0207a64:	a4b1                	j	ffffffffc0207cb0 <vfs_devlist_init>

ffffffffc0207a66 <vfs_set_bootfs>:
ffffffffc0207a66:	7179                	addi	sp,sp,-48
ffffffffc0207a68:	f022                	sd	s0,32(sp)
ffffffffc0207a6a:	f406                	sd	ra,40(sp)
ffffffffc0207a6c:	ec02                	sd	zero,24(sp)
ffffffffc0207a6e:	842a                	mv	s0,a0
ffffffffc0207a70:	c515                	beqz	a0,ffffffffc0207a9c <vfs_set_bootfs+0x36>
ffffffffc0207a72:	03a00593          	li	a1,58
ffffffffc0207a76:	30b030ef          	jal	ffffffffc020b580 <strchr>
ffffffffc0207a7a:	c125                	beqz	a0,ffffffffc0207ada <vfs_set_bootfs+0x74>
ffffffffc0207a7c:	00154783          	lbu	a5,1(a0)
ffffffffc0207a80:	efa9                	bnez	a5,ffffffffc0207ada <vfs_set_bootfs+0x74>
ffffffffc0207a82:	8522                	mv	a0,s0
ffffffffc0207a84:	163000ef          	jal	ffffffffc02083e6 <vfs_chdir>
ffffffffc0207a88:	c509                	beqz	a0,ffffffffc0207a92 <vfs_set_bootfs+0x2c>
ffffffffc0207a8a:	70a2                	ld	ra,40(sp)
ffffffffc0207a8c:	7402                	ld	s0,32(sp)
ffffffffc0207a8e:	6145                	addi	sp,sp,48
ffffffffc0207a90:	8082                	ret
ffffffffc0207a92:	0828                	addi	a0,sp,24
ffffffffc0207a94:	05f000ef          	jal	ffffffffc02082f2 <vfs_get_curdir>
ffffffffc0207a98:	f96d                	bnez	a0,ffffffffc0207a8a <vfs_set_bootfs+0x24>
ffffffffc0207a9a:	6462                	ld	s0,24(sp)
ffffffffc0207a9c:	0008e517          	auipc	a0,0x8e
ffffffffc0207aa0:	d6450513          	addi	a0,a0,-668 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207aa4:	975fc0ef          	jal	ffffffffc0204418 <down>
ffffffffc0207aa8:	0008f797          	auipc	a5,0x8f
ffffffffc0207aac:	e487b783          	ld	a5,-440(a5) # ffffffffc02968f0 <bootfs_node>
ffffffffc0207ab0:	0008e517          	auipc	a0,0x8e
ffffffffc0207ab4:	d5050513          	addi	a0,a0,-688 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207ab8:	0008f717          	auipc	a4,0x8f
ffffffffc0207abc:	e2873c23          	sd	s0,-456(a4) # ffffffffc02968f0 <bootfs_node>
ffffffffc0207ac0:	e43e                	sd	a5,8(sp)
ffffffffc0207ac2:	953fc0ef          	jal	ffffffffc0204414 <up>
ffffffffc0207ac6:	67a2                	ld	a5,8(sp)
ffffffffc0207ac8:	c781                	beqz	a5,ffffffffc0207ad0 <vfs_set_bootfs+0x6a>
ffffffffc0207aca:	853e                	mv	a0,a5
ffffffffc0207acc:	e33ff0ef          	jal	ffffffffc02078fe <inode_ref_dec>
ffffffffc0207ad0:	70a2                	ld	ra,40(sp)
ffffffffc0207ad2:	7402                	ld	s0,32(sp)
ffffffffc0207ad4:	4501                	li	a0,0
ffffffffc0207ad6:	6145                	addi	sp,sp,48
ffffffffc0207ad8:	8082                	ret
ffffffffc0207ada:	5575                	li	a0,-3
ffffffffc0207adc:	b77d                	j	ffffffffc0207a8a <vfs_set_bootfs+0x24>

ffffffffc0207ade <vfs_get_bootfs>:
ffffffffc0207ade:	1101                	addi	sp,sp,-32
ffffffffc0207ae0:	e426                	sd	s1,8(sp)
ffffffffc0207ae2:	0008f497          	auipc	s1,0x8f
ffffffffc0207ae6:	e0e48493          	addi	s1,s1,-498 # ffffffffc02968f0 <bootfs_node>
ffffffffc0207aea:	609c                	ld	a5,0(s1)
ffffffffc0207aec:	ec06                	sd	ra,24(sp)
ffffffffc0207aee:	c3b1                	beqz	a5,ffffffffc0207b32 <vfs_get_bootfs+0x54>
ffffffffc0207af0:	e822                	sd	s0,16(sp)
ffffffffc0207af2:	842a                	mv	s0,a0
ffffffffc0207af4:	0008e517          	auipc	a0,0x8e
ffffffffc0207af8:	d0c50513          	addi	a0,a0,-756 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207afc:	91dfc0ef          	jal	ffffffffc0204418 <down>
ffffffffc0207b00:	6084                	ld	s1,0(s1)
ffffffffc0207b02:	c08d                	beqz	s1,ffffffffc0207b24 <vfs_get_bootfs+0x46>
ffffffffc0207b04:	8526                	mv	a0,s1
ffffffffc0207b06:	d2bff0ef          	jal	ffffffffc0207830 <inode_ref_inc>
ffffffffc0207b0a:	0008e517          	auipc	a0,0x8e
ffffffffc0207b0e:	cf650513          	addi	a0,a0,-778 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207b12:	903fc0ef          	jal	ffffffffc0204414 <up>
ffffffffc0207b16:	60e2                	ld	ra,24(sp)
ffffffffc0207b18:	e004                	sd	s1,0(s0)
ffffffffc0207b1a:	6442                	ld	s0,16(sp)
ffffffffc0207b1c:	64a2                	ld	s1,8(sp)
ffffffffc0207b1e:	4501                	li	a0,0
ffffffffc0207b20:	6105                	addi	sp,sp,32
ffffffffc0207b22:	8082                	ret
ffffffffc0207b24:	0008e517          	auipc	a0,0x8e
ffffffffc0207b28:	cdc50513          	addi	a0,a0,-804 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207b2c:	8e9fc0ef          	jal	ffffffffc0204414 <up>
ffffffffc0207b30:	6442                	ld	s0,16(sp)
ffffffffc0207b32:	60e2                	ld	ra,24(sp)
ffffffffc0207b34:	64a2                	ld	s1,8(sp)
ffffffffc0207b36:	5541                	li	a0,-16
ffffffffc0207b38:	6105                	addi	sp,sp,32
ffffffffc0207b3a:	8082                	ret

ffffffffc0207b3c <vfs_do_add>:
ffffffffc0207b3c:	7139                	addi	sp,sp,-64
ffffffffc0207b3e:	fc06                	sd	ra,56(sp)
ffffffffc0207b40:	f822                	sd	s0,48(sp)
ffffffffc0207b42:	e852                	sd	s4,16(sp)
ffffffffc0207b44:	e456                	sd	s5,8(sp)
ffffffffc0207b46:	e05a                	sd	s6,0(sp)
ffffffffc0207b48:	10050f63          	beqz	a0,ffffffffc0207c66 <vfs_do_add+0x12a>
ffffffffc0207b4c:	00d5e7b3          	or	a5,a1,a3
ffffffffc0207b50:	842a                	mv	s0,a0
ffffffffc0207b52:	8a2e                	mv	s4,a1
ffffffffc0207b54:	8b32                	mv	s6,a2
ffffffffc0207b56:	8ab6                	mv	s5,a3
ffffffffc0207b58:	cb89                	beqz	a5,ffffffffc0207b6a <vfs_do_add+0x2e>
ffffffffc0207b5a:	0e058363          	beqz	a1,ffffffffc0207c40 <vfs_do_add+0x104>
ffffffffc0207b5e:	4db8                	lw	a4,88(a1)
ffffffffc0207b60:	6785                	lui	a5,0x1
ffffffffc0207b62:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0207b66:	0cf71d63          	bne	a4,a5,ffffffffc0207c40 <vfs_do_add+0x104>
ffffffffc0207b6a:	8522                	mv	a0,s0
ffffffffc0207b6c:	173030ef          	jal	ffffffffc020b4de <strlen>
ffffffffc0207b70:	47fd                	li	a5,31
ffffffffc0207b72:	0ca7e263          	bltu	a5,a0,ffffffffc0207c36 <vfs_do_add+0xfa>
ffffffffc0207b76:	8522                	mv	a0,s0
ffffffffc0207b78:	f426                	sd	s1,40(sp)
ffffffffc0207b7a:	e78f80ef          	jal	ffffffffc02001f2 <strdup>
ffffffffc0207b7e:	84aa                	mv	s1,a0
ffffffffc0207b80:	cd4d                	beqz	a0,ffffffffc0207c3a <vfs_do_add+0xfe>
ffffffffc0207b82:	03000513          	li	a0,48
ffffffffc0207b86:	ec4e                	sd	s3,24(sp)
ffffffffc0207b88:	cc8fa0ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc0207b8c:	89aa                	mv	s3,a0
ffffffffc0207b8e:	c935                	beqz	a0,ffffffffc0207c02 <vfs_do_add+0xc6>
ffffffffc0207b90:	f04a                	sd	s2,32(sp)
ffffffffc0207b92:	0008e517          	auipc	a0,0x8e
ffffffffc0207b96:	c8650513          	addi	a0,a0,-890 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207b9a:	0008e917          	auipc	s2,0x8e
ffffffffc0207b9e:	c9690913          	addi	s2,s2,-874 # ffffffffc0295830 <vdev_list>
ffffffffc0207ba2:	877fc0ef          	jal	ffffffffc0204418 <down>
ffffffffc0207ba6:	844a                	mv	s0,s2
ffffffffc0207ba8:	a039                	j	ffffffffc0207bb6 <vfs_do_add+0x7a>
ffffffffc0207baa:	fe043503          	ld	a0,-32(s0)
ffffffffc0207bae:	85a6                	mv	a1,s1
ffffffffc0207bb0:	175030ef          	jal	ffffffffc020b524 <strcmp>
ffffffffc0207bb4:	c52d                	beqz	a0,ffffffffc0207c1e <vfs_do_add+0xe2>
ffffffffc0207bb6:	6400                	ld	s0,8(s0)
ffffffffc0207bb8:	ff2419e3          	bne	s0,s2,ffffffffc0207baa <vfs_do_add+0x6e>
ffffffffc0207bbc:	6418                	ld	a4,8(s0)
ffffffffc0207bbe:	02098793          	addi	a5,s3,32
ffffffffc0207bc2:	0099b023          	sd	s1,0(s3)
ffffffffc0207bc6:	0149b423          	sd	s4,8(s3)
ffffffffc0207bca:	0159bc23          	sd	s5,24(s3)
ffffffffc0207bce:	0169b823          	sd	s6,16(s3)
ffffffffc0207bd2:	e31c                	sd	a5,0(a4)
ffffffffc0207bd4:	0289b023          	sd	s0,32(s3)
ffffffffc0207bd8:	02e9b423          	sd	a4,40(s3)
ffffffffc0207bdc:	0008e517          	auipc	a0,0x8e
ffffffffc0207be0:	c3c50513          	addi	a0,a0,-964 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207be4:	e41c                	sd	a5,8(s0)
ffffffffc0207be6:	82ffc0ef          	jal	ffffffffc0204414 <up>
ffffffffc0207bea:	74a2                	ld	s1,40(sp)
ffffffffc0207bec:	7902                	ld	s2,32(sp)
ffffffffc0207bee:	69e2                	ld	s3,24(sp)
ffffffffc0207bf0:	4401                	li	s0,0
ffffffffc0207bf2:	70e2                	ld	ra,56(sp)
ffffffffc0207bf4:	8522                	mv	a0,s0
ffffffffc0207bf6:	7442                	ld	s0,48(sp)
ffffffffc0207bf8:	6a42                	ld	s4,16(sp)
ffffffffc0207bfa:	6aa2                	ld	s5,8(sp)
ffffffffc0207bfc:	6b02                	ld	s6,0(sp)
ffffffffc0207bfe:	6121                	addi	sp,sp,64
ffffffffc0207c00:	8082                	ret
ffffffffc0207c02:	5471                	li	s0,-4
ffffffffc0207c04:	8526                	mv	a0,s1
ffffffffc0207c06:	cf0fa0ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc0207c0a:	70e2                	ld	ra,56(sp)
ffffffffc0207c0c:	8522                	mv	a0,s0
ffffffffc0207c0e:	7442                	ld	s0,48(sp)
ffffffffc0207c10:	74a2                	ld	s1,40(sp)
ffffffffc0207c12:	69e2                	ld	s3,24(sp)
ffffffffc0207c14:	6a42                	ld	s4,16(sp)
ffffffffc0207c16:	6aa2                	ld	s5,8(sp)
ffffffffc0207c18:	6b02                	ld	s6,0(sp)
ffffffffc0207c1a:	6121                	addi	sp,sp,64
ffffffffc0207c1c:	8082                	ret
ffffffffc0207c1e:	0008e517          	auipc	a0,0x8e
ffffffffc0207c22:	bfa50513          	addi	a0,a0,-1030 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207c26:	feefc0ef          	jal	ffffffffc0204414 <up>
ffffffffc0207c2a:	854e                	mv	a0,s3
ffffffffc0207c2c:	ccafa0ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc0207c30:	5425                	li	s0,-23
ffffffffc0207c32:	7902                	ld	s2,32(sp)
ffffffffc0207c34:	bfc1                	j	ffffffffc0207c04 <vfs_do_add+0xc8>
ffffffffc0207c36:	5451                	li	s0,-12
ffffffffc0207c38:	bf6d                	j	ffffffffc0207bf2 <vfs_do_add+0xb6>
ffffffffc0207c3a:	74a2                	ld	s1,40(sp)
ffffffffc0207c3c:	5471                	li	s0,-4
ffffffffc0207c3e:	bf55                	j	ffffffffc0207bf2 <vfs_do_add+0xb6>
ffffffffc0207c40:	00006697          	auipc	a3,0x6
ffffffffc0207c44:	07868693          	addi	a3,a3,120 # ffffffffc020dcb8 <etext+0x26be>
ffffffffc0207c48:	00004617          	auipc	a2,0x4
ffffffffc0207c4c:	df060613          	addi	a2,a2,-528 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0207c50:	08f00593          	li	a1,143
ffffffffc0207c54:	00006517          	auipc	a0,0x6
ffffffffc0207c58:	04c50513          	addi	a0,a0,76 # ffffffffc020dca0 <etext+0x26a6>
ffffffffc0207c5c:	f426                	sd	s1,40(sp)
ffffffffc0207c5e:	f04a                	sd	s2,32(sp)
ffffffffc0207c60:	ec4e                	sd	s3,24(sp)
ffffffffc0207c62:	fe8f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207c66:	00006697          	auipc	a3,0x6
ffffffffc0207c6a:	02a68693          	addi	a3,a3,42 # ffffffffc020dc90 <etext+0x2696>
ffffffffc0207c6e:	00004617          	auipc	a2,0x4
ffffffffc0207c72:	dca60613          	addi	a2,a2,-566 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0207c76:	08e00593          	li	a1,142
ffffffffc0207c7a:	00006517          	auipc	a0,0x6
ffffffffc0207c7e:	02650513          	addi	a0,a0,38 # ffffffffc020dca0 <etext+0x26a6>
ffffffffc0207c82:	f426                	sd	s1,40(sp)
ffffffffc0207c84:	f04a                	sd	s2,32(sp)
ffffffffc0207c86:	ec4e                	sd	s3,24(sp)
ffffffffc0207c88:	fc2f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207c8c <find_mount.part.0>:
ffffffffc0207c8c:	1141                	addi	sp,sp,-16
ffffffffc0207c8e:	00006697          	auipc	a3,0x6
ffffffffc0207c92:	00268693          	addi	a3,a3,2 # ffffffffc020dc90 <etext+0x2696>
ffffffffc0207c96:	00004617          	auipc	a2,0x4
ffffffffc0207c9a:	da260613          	addi	a2,a2,-606 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0207c9e:	0cd00593          	li	a1,205
ffffffffc0207ca2:	00006517          	auipc	a0,0x6
ffffffffc0207ca6:	ffe50513          	addi	a0,a0,-2 # ffffffffc020dca0 <etext+0x26a6>
ffffffffc0207caa:	e406                	sd	ra,8(sp)
ffffffffc0207cac:	f9ef80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207cb0 <vfs_devlist_init>:
ffffffffc0207cb0:	0008e797          	auipc	a5,0x8e
ffffffffc0207cb4:	b8078793          	addi	a5,a5,-1152 # ffffffffc0295830 <vdev_list>
ffffffffc0207cb8:	4585                	li	a1,1
ffffffffc0207cba:	0008e517          	auipc	a0,0x8e
ffffffffc0207cbe:	b5e50513          	addi	a0,a0,-1186 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207cc2:	e79c                	sd	a5,8(a5)
ffffffffc0207cc4:	e39c                	sd	a5,0(a5)
ffffffffc0207cc6:	f48fc06f          	j	ffffffffc020440e <sem_init>

ffffffffc0207cca <vfs_cleanup>:
ffffffffc0207cca:	1101                	addi	sp,sp,-32
ffffffffc0207ccc:	e426                	sd	s1,8(sp)
ffffffffc0207cce:	0008e497          	auipc	s1,0x8e
ffffffffc0207cd2:	b6248493          	addi	s1,s1,-1182 # ffffffffc0295830 <vdev_list>
ffffffffc0207cd6:	649c                	ld	a5,8(s1)
ffffffffc0207cd8:	ec06                	sd	ra,24(sp)
ffffffffc0207cda:	02978f63          	beq	a5,s1,ffffffffc0207d18 <vfs_cleanup+0x4e>
ffffffffc0207cde:	0008e517          	auipc	a0,0x8e
ffffffffc0207ce2:	b3a50513          	addi	a0,a0,-1222 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207ce6:	e822                	sd	s0,16(sp)
ffffffffc0207ce8:	f30fc0ef          	jal	ffffffffc0204418 <down>
ffffffffc0207cec:	6480                	ld	s0,8(s1)
ffffffffc0207cee:	00940b63          	beq	s0,s1,ffffffffc0207d04 <vfs_cleanup+0x3a>
ffffffffc0207cf2:	ff043783          	ld	a5,-16(s0)
ffffffffc0207cf6:	853e                	mv	a0,a5
ffffffffc0207cf8:	c399                	beqz	a5,ffffffffc0207cfe <vfs_cleanup+0x34>
ffffffffc0207cfa:	6bfc                	ld	a5,208(a5)
ffffffffc0207cfc:	9782                	jalr	a5
ffffffffc0207cfe:	6400                	ld	s0,8(s0)
ffffffffc0207d00:	fe9419e3          	bne	s0,s1,ffffffffc0207cf2 <vfs_cleanup+0x28>
ffffffffc0207d04:	6442                	ld	s0,16(sp)
ffffffffc0207d06:	60e2                	ld	ra,24(sp)
ffffffffc0207d08:	64a2                	ld	s1,8(sp)
ffffffffc0207d0a:	0008e517          	auipc	a0,0x8e
ffffffffc0207d0e:	b0e50513          	addi	a0,a0,-1266 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207d12:	6105                	addi	sp,sp,32
ffffffffc0207d14:	f00fc06f          	j	ffffffffc0204414 <up>
ffffffffc0207d18:	60e2                	ld	ra,24(sp)
ffffffffc0207d1a:	64a2                	ld	s1,8(sp)
ffffffffc0207d1c:	6105                	addi	sp,sp,32
ffffffffc0207d1e:	8082                	ret

ffffffffc0207d20 <vfs_get_root>:
ffffffffc0207d20:	7179                	addi	sp,sp,-48
ffffffffc0207d22:	f406                	sd	ra,40(sp)
ffffffffc0207d24:	c949                	beqz	a0,ffffffffc0207db6 <vfs_get_root+0x96>
ffffffffc0207d26:	e84a                	sd	s2,16(sp)
ffffffffc0207d28:	0008e917          	auipc	s2,0x8e
ffffffffc0207d2c:	b0890913          	addi	s2,s2,-1272 # ffffffffc0295830 <vdev_list>
ffffffffc0207d30:	00893783          	ld	a5,8(s2)
ffffffffc0207d34:	ec26                	sd	s1,24(sp)
ffffffffc0207d36:	07278e63          	beq	a5,s2,ffffffffc0207db2 <vfs_get_root+0x92>
ffffffffc0207d3a:	e44e                	sd	s3,8(sp)
ffffffffc0207d3c:	89aa                	mv	s3,a0
ffffffffc0207d3e:	0008e517          	auipc	a0,0x8e
ffffffffc0207d42:	ada50513          	addi	a0,a0,-1318 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207d46:	f022                	sd	s0,32(sp)
ffffffffc0207d48:	e052                	sd	s4,0(sp)
ffffffffc0207d4a:	844a                	mv	s0,s2
ffffffffc0207d4c:	8a2e                	mv	s4,a1
ffffffffc0207d4e:	ecafc0ef          	jal	ffffffffc0204418 <down>
ffffffffc0207d52:	a801                	j	ffffffffc0207d62 <vfs_get_root+0x42>
ffffffffc0207d54:	fe043583          	ld	a1,-32(s0)
ffffffffc0207d58:	854e                	mv	a0,s3
ffffffffc0207d5a:	7ca030ef          	jal	ffffffffc020b524 <strcmp>
ffffffffc0207d5e:	84aa                	mv	s1,a0
ffffffffc0207d60:	c505                	beqz	a0,ffffffffc0207d88 <vfs_get_root+0x68>
ffffffffc0207d62:	6400                	ld	s0,8(s0)
ffffffffc0207d64:	ff2418e3          	bne	s0,s2,ffffffffc0207d54 <vfs_get_root+0x34>
ffffffffc0207d68:	54cd                	li	s1,-13
ffffffffc0207d6a:	0008e517          	auipc	a0,0x8e
ffffffffc0207d6e:	aae50513          	addi	a0,a0,-1362 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207d72:	ea2fc0ef          	jal	ffffffffc0204414 <up>
ffffffffc0207d76:	7402                	ld	s0,32(sp)
ffffffffc0207d78:	69a2                	ld	s3,8(sp)
ffffffffc0207d7a:	6a02                	ld	s4,0(sp)
ffffffffc0207d7c:	70a2                	ld	ra,40(sp)
ffffffffc0207d7e:	6942                	ld	s2,16(sp)
ffffffffc0207d80:	8526                	mv	a0,s1
ffffffffc0207d82:	64e2                	ld	s1,24(sp)
ffffffffc0207d84:	6145                	addi	sp,sp,48
ffffffffc0207d86:	8082                	ret
ffffffffc0207d88:	ff043503          	ld	a0,-16(s0)
ffffffffc0207d8c:	c519                	beqz	a0,ffffffffc0207d9a <vfs_get_root+0x7a>
ffffffffc0207d8e:	617c                	ld	a5,192(a0)
ffffffffc0207d90:	9782                	jalr	a5
ffffffffc0207d92:	c519                	beqz	a0,ffffffffc0207da0 <vfs_get_root+0x80>
ffffffffc0207d94:	00aa3023          	sd	a0,0(s4)
ffffffffc0207d98:	bfc9                	j	ffffffffc0207d6a <vfs_get_root+0x4a>
ffffffffc0207d9a:	ff843783          	ld	a5,-8(s0)
ffffffffc0207d9e:	c399                	beqz	a5,ffffffffc0207da4 <vfs_get_root+0x84>
ffffffffc0207da0:	54c9                	li	s1,-14
ffffffffc0207da2:	b7e1                	j	ffffffffc0207d6a <vfs_get_root+0x4a>
ffffffffc0207da4:	fe843503          	ld	a0,-24(s0)
ffffffffc0207da8:	a89ff0ef          	jal	ffffffffc0207830 <inode_ref_inc>
ffffffffc0207dac:	fe843503          	ld	a0,-24(s0)
ffffffffc0207db0:	b7cd                	j	ffffffffc0207d92 <vfs_get_root+0x72>
ffffffffc0207db2:	54cd                	li	s1,-13
ffffffffc0207db4:	b7e1                	j	ffffffffc0207d7c <vfs_get_root+0x5c>
ffffffffc0207db6:	00006697          	auipc	a3,0x6
ffffffffc0207dba:	eda68693          	addi	a3,a3,-294 # ffffffffc020dc90 <etext+0x2696>
ffffffffc0207dbe:	00004617          	auipc	a2,0x4
ffffffffc0207dc2:	c7a60613          	addi	a2,a2,-902 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0207dc6:	04500593          	li	a1,69
ffffffffc0207dca:	00006517          	auipc	a0,0x6
ffffffffc0207dce:	ed650513          	addi	a0,a0,-298 # ffffffffc020dca0 <etext+0x26a6>
ffffffffc0207dd2:	f022                	sd	s0,32(sp)
ffffffffc0207dd4:	ec26                	sd	s1,24(sp)
ffffffffc0207dd6:	e84a                	sd	s2,16(sp)
ffffffffc0207dd8:	e44e                	sd	s3,8(sp)
ffffffffc0207dda:	e052                	sd	s4,0(sp)
ffffffffc0207ddc:	e6ef80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207de0 <vfs_get_devname>:
ffffffffc0207de0:	0008e697          	auipc	a3,0x8e
ffffffffc0207de4:	a5068693          	addi	a3,a3,-1456 # ffffffffc0295830 <vdev_list>
ffffffffc0207de8:	87b6                	mv	a5,a3
ffffffffc0207dea:	e511                	bnez	a0,ffffffffc0207df6 <vfs_get_devname+0x16>
ffffffffc0207dec:	a829                	j	ffffffffc0207e06 <vfs_get_devname+0x26>
ffffffffc0207dee:	ff07b703          	ld	a4,-16(a5)
ffffffffc0207df2:	00a70763          	beq	a4,a0,ffffffffc0207e00 <vfs_get_devname+0x20>
ffffffffc0207df6:	679c                	ld	a5,8(a5)
ffffffffc0207df8:	fed79be3          	bne	a5,a3,ffffffffc0207dee <vfs_get_devname+0xe>
ffffffffc0207dfc:	4501                	li	a0,0
ffffffffc0207dfe:	8082                	ret
ffffffffc0207e00:	fe07b503          	ld	a0,-32(a5)
ffffffffc0207e04:	8082                	ret
ffffffffc0207e06:	1141                	addi	sp,sp,-16
ffffffffc0207e08:	00006697          	auipc	a3,0x6
ffffffffc0207e0c:	f1068693          	addi	a3,a3,-240 # ffffffffc020dd18 <etext+0x271e>
ffffffffc0207e10:	00004617          	auipc	a2,0x4
ffffffffc0207e14:	c2860613          	addi	a2,a2,-984 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0207e18:	06a00593          	li	a1,106
ffffffffc0207e1c:	00006517          	auipc	a0,0x6
ffffffffc0207e20:	e8450513          	addi	a0,a0,-380 # ffffffffc020dca0 <etext+0x26a6>
ffffffffc0207e24:	e406                	sd	ra,8(sp)
ffffffffc0207e26:	e24f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207e2a <vfs_add_dev>:
ffffffffc0207e2a:	86b2                	mv	a3,a2
ffffffffc0207e2c:	4601                	li	a2,0
ffffffffc0207e2e:	d0fff06f          	j	ffffffffc0207b3c <vfs_do_add>

ffffffffc0207e32 <vfs_mount>:
ffffffffc0207e32:	7179                	addi	sp,sp,-48
ffffffffc0207e34:	e84a                	sd	s2,16(sp)
ffffffffc0207e36:	892a                	mv	s2,a0
ffffffffc0207e38:	0008e517          	auipc	a0,0x8e
ffffffffc0207e3c:	9e050513          	addi	a0,a0,-1568 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207e40:	e44e                	sd	s3,8(sp)
ffffffffc0207e42:	f406                	sd	ra,40(sp)
ffffffffc0207e44:	f022                	sd	s0,32(sp)
ffffffffc0207e46:	ec26                	sd	s1,24(sp)
ffffffffc0207e48:	89ae                	mv	s3,a1
ffffffffc0207e4a:	dcefc0ef          	jal	ffffffffc0204418 <down>
ffffffffc0207e4e:	0c090a63          	beqz	s2,ffffffffc0207f22 <vfs_mount+0xf0>
ffffffffc0207e52:	0008e497          	auipc	s1,0x8e
ffffffffc0207e56:	9de48493          	addi	s1,s1,-1570 # ffffffffc0295830 <vdev_list>
ffffffffc0207e5a:	6480                	ld	s0,8(s1)
ffffffffc0207e5c:	00941663          	bne	s0,s1,ffffffffc0207e68 <vfs_mount+0x36>
ffffffffc0207e60:	a8ad                	j	ffffffffc0207eda <vfs_mount+0xa8>
ffffffffc0207e62:	6400                	ld	s0,8(s0)
ffffffffc0207e64:	06940b63          	beq	s0,s1,ffffffffc0207eda <vfs_mount+0xa8>
ffffffffc0207e68:	ff843783          	ld	a5,-8(s0)
ffffffffc0207e6c:	dbfd                	beqz	a5,ffffffffc0207e62 <vfs_mount+0x30>
ffffffffc0207e6e:	fe043503          	ld	a0,-32(s0)
ffffffffc0207e72:	85ca                	mv	a1,s2
ffffffffc0207e74:	6b0030ef          	jal	ffffffffc020b524 <strcmp>
ffffffffc0207e78:	f56d                	bnez	a0,ffffffffc0207e62 <vfs_mount+0x30>
ffffffffc0207e7a:	ff043783          	ld	a5,-16(s0)
ffffffffc0207e7e:	e3a5                	bnez	a5,ffffffffc0207ede <vfs_mount+0xac>
ffffffffc0207e80:	fe043783          	ld	a5,-32(s0)
ffffffffc0207e84:	cfbd                	beqz	a5,ffffffffc0207f02 <vfs_mount+0xd0>
ffffffffc0207e86:	ff843783          	ld	a5,-8(s0)
ffffffffc0207e8a:	cfa5                	beqz	a5,ffffffffc0207f02 <vfs_mount+0xd0>
ffffffffc0207e8c:	fe843503          	ld	a0,-24(s0)
ffffffffc0207e90:	c929                	beqz	a0,ffffffffc0207ee2 <vfs_mount+0xb0>
ffffffffc0207e92:	4d38                	lw	a4,88(a0)
ffffffffc0207e94:	6785                	lui	a5,0x1
ffffffffc0207e96:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0207e9a:	04f71463          	bne	a4,a5,ffffffffc0207ee2 <vfs_mount+0xb0>
ffffffffc0207e9e:	ff040593          	addi	a1,s0,-16
ffffffffc0207ea2:	9982                	jalr	s3
ffffffffc0207ea4:	84aa                	mv	s1,a0
ffffffffc0207ea6:	ed01                	bnez	a0,ffffffffc0207ebe <vfs_mount+0x8c>
ffffffffc0207ea8:	ff043783          	ld	a5,-16(s0)
ffffffffc0207eac:	cfad                	beqz	a5,ffffffffc0207f26 <vfs_mount+0xf4>
ffffffffc0207eae:	fe043583          	ld	a1,-32(s0)
ffffffffc0207eb2:	00006517          	auipc	a0,0x6
ffffffffc0207eb6:	ef650513          	addi	a0,a0,-266 # ffffffffc020dda8 <etext+0x27ae>
ffffffffc0207eba:	aecf80ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0207ebe:	0008e517          	auipc	a0,0x8e
ffffffffc0207ec2:	95a50513          	addi	a0,a0,-1702 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207ec6:	d4efc0ef          	jal	ffffffffc0204414 <up>
ffffffffc0207eca:	70a2                	ld	ra,40(sp)
ffffffffc0207ecc:	7402                	ld	s0,32(sp)
ffffffffc0207ece:	6942                	ld	s2,16(sp)
ffffffffc0207ed0:	69a2                	ld	s3,8(sp)
ffffffffc0207ed2:	8526                	mv	a0,s1
ffffffffc0207ed4:	64e2                	ld	s1,24(sp)
ffffffffc0207ed6:	6145                	addi	sp,sp,48
ffffffffc0207ed8:	8082                	ret
ffffffffc0207eda:	54cd                	li	s1,-13
ffffffffc0207edc:	b7cd                	j	ffffffffc0207ebe <vfs_mount+0x8c>
ffffffffc0207ede:	54c5                	li	s1,-15
ffffffffc0207ee0:	bff9                	j	ffffffffc0207ebe <vfs_mount+0x8c>
ffffffffc0207ee2:	00006697          	auipc	a3,0x6
ffffffffc0207ee6:	e7668693          	addi	a3,a3,-394 # ffffffffc020dd58 <etext+0x275e>
ffffffffc0207eea:	00004617          	auipc	a2,0x4
ffffffffc0207eee:	b4e60613          	addi	a2,a2,-1202 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0207ef2:	0ed00593          	li	a1,237
ffffffffc0207ef6:	00006517          	auipc	a0,0x6
ffffffffc0207efa:	daa50513          	addi	a0,a0,-598 # ffffffffc020dca0 <etext+0x26a6>
ffffffffc0207efe:	d4cf80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207f02:	00006697          	auipc	a3,0x6
ffffffffc0207f06:	e2668693          	addi	a3,a3,-474 # ffffffffc020dd28 <etext+0x272e>
ffffffffc0207f0a:	00004617          	auipc	a2,0x4
ffffffffc0207f0e:	b2e60613          	addi	a2,a2,-1234 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0207f12:	0eb00593          	li	a1,235
ffffffffc0207f16:	00006517          	auipc	a0,0x6
ffffffffc0207f1a:	d8a50513          	addi	a0,a0,-630 # ffffffffc020dca0 <etext+0x26a6>
ffffffffc0207f1e:	d2cf80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207f22:	d6bff0ef          	jal	ffffffffc0207c8c <find_mount.part.0>
ffffffffc0207f26:	00006697          	auipc	a3,0x6
ffffffffc0207f2a:	e6a68693          	addi	a3,a3,-406 # ffffffffc020dd90 <etext+0x2796>
ffffffffc0207f2e:	00004617          	auipc	a2,0x4
ffffffffc0207f32:	b0a60613          	addi	a2,a2,-1270 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0207f36:	0ef00593          	li	a1,239
ffffffffc0207f3a:	00006517          	auipc	a0,0x6
ffffffffc0207f3e:	d6650513          	addi	a0,a0,-666 # ffffffffc020dca0 <etext+0x26a6>
ffffffffc0207f42:	d08f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207f46 <vfs_open>:
ffffffffc0207f46:	7159                	addi	sp,sp,-112
ffffffffc0207f48:	f486                	sd	ra,104(sp)
ffffffffc0207f4a:	e0d2                	sd	s4,64(sp)
ffffffffc0207f4c:	0035f793          	andi	a5,a1,3
ffffffffc0207f50:	10078363          	beqz	a5,ffffffffc0208056 <vfs_open+0x110>
ffffffffc0207f54:	470d                	li	a4,3
ffffffffc0207f56:	12e78163          	beq	a5,a4,ffffffffc0208078 <vfs_open+0x132>
ffffffffc0207f5a:	f0a2                	sd	s0,96(sp)
ffffffffc0207f5c:	eca6                	sd	s1,88(sp)
ffffffffc0207f5e:	e8ca                	sd	s2,80(sp)
ffffffffc0207f60:	e4ce                	sd	s3,72(sp)
ffffffffc0207f62:	fc56                	sd	s5,56(sp)
ffffffffc0207f64:	f85a                	sd	s6,48(sp)
ffffffffc0207f66:	0105fa13          	andi	s4,a1,16
ffffffffc0207f6a:	842e                	mv	s0,a1
ffffffffc0207f6c:	00447793          	andi	a5,s0,4
ffffffffc0207f70:	8b32                	mv	s6,a2
ffffffffc0207f72:	082c                	addi	a1,sp,24
ffffffffc0207f74:	00345613          	srli	a2,s0,0x3
ffffffffc0207f78:	8abe                	mv	s5,a5
ffffffffc0207f7a:	0027d493          	srli	s1,a5,0x2
ffffffffc0207f7e:	892a                	mv	s2,a0
ffffffffc0207f80:	00167993          	andi	s3,a2,1
ffffffffc0207f84:	2ba000ef          	jal	ffffffffc020823e <vfs_lookup>
ffffffffc0207f88:	87aa                	mv	a5,a0
ffffffffc0207f8a:	c175                	beqz	a0,ffffffffc020806e <vfs_open+0x128>
ffffffffc0207f8c:	01050713          	addi	a4,a0,16
ffffffffc0207f90:	eb45                	bnez	a4,ffffffffc0208040 <vfs_open+0xfa>
ffffffffc0207f92:	c4dd                	beqz	s1,ffffffffc0208040 <vfs_open+0xfa>
ffffffffc0207f94:	854a                	mv	a0,s2
ffffffffc0207f96:	1010                	addi	a2,sp,32
ffffffffc0207f98:	102c                	addi	a1,sp,40
ffffffffc0207f9a:	32e000ef          	jal	ffffffffc02082c8 <vfs_lookup_parent>
ffffffffc0207f9e:	87aa                	mv	a5,a0
ffffffffc0207fa0:	e145                	bnez	a0,ffffffffc0208040 <vfs_open+0xfa>
ffffffffc0207fa2:	7522                	ld	a0,40(sp)
ffffffffc0207fa4:	14050c63          	beqz	a0,ffffffffc02080fc <vfs_open+0x1b6>
ffffffffc0207fa8:	793c                	ld	a5,112(a0)
ffffffffc0207faa:	14078963          	beqz	a5,ffffffffc02080fc <vfs_open+0x1b6>
ffffffffc0207fae:	77bc                	ld	a5,104(a5)
ffffffffc0207fb0:	14078663          	beqz	a5,ffffffffc02080fc <vfs_open+0x1b6>
ffffffffc0207fb4:	00006597          	auipc	a1,0x6
ffffffffc0207fb8:	e6c58593          	addi	a1,a1,-404 # ffffffffc020de20 <etext+0x2826>
ffffffffc0207fbc:	e42a                	sd	a0,8(sp)
ffffffffc0207fbe:	887ff0ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc0207fc2:	6522                	ld	a0,8(sp)
ffffffffc0207fc4:	7582                	ld	a1,32(sp)
ffffffffc0207fc6:	0834                	addi	a3,sp,24
ffffffffc0207fc8:	793c                	ld	a5,112(a0)
ffffffffc0207fca:	7522                	ld	a0,40(sp)
ffffffffc0207fcc:	864e                	mv	a2,s3
ffffffffc0207fce:	77bc                	ld	a5,104(a5)
ffffffffc0207fd0:	9782                	jalr	a5
ffffffffc0207fd2:	6562                	ld	a0,24(sp)
ffffffffc0207fd4:	10050463          	beqz	a0,ffffffffc02080dc <vfs_open+0x196>
ffffffffc0207fd8:	793c                	ld	a5,112(a0)
ffffffffc0207fda:	c3e9                	beqz	a5,ffffffffc020809c <vfs_open+0x156>
ffffffffc0207fdc:	679c                	ld	a5,8(a5)
ffffffffc0207fde:	cfdd                	beqz	a5,ffffffffc020809c <vfs_open+0x156>
ffffffffc0207fe0:	00006597          	auipc	a1,0x6
ffffffffc0207fe4:	ea858593          	addi	a1,a1,-344 # ffffffffc020de88 <etext+0x288e>
ffffffffc0207fe8:	e42a                	sd	a0,8(sp)
ffffffffc0207fea:	85bff0ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc0207fee:	6522                	ld	a0,8(sp)
ffffffffc0207ff0:	85a2                	mv	a1,s0
ffffffffc0207ff2:	793c                	ld	a5,112(a0)
ffffffffc0207ff4:	6562                	ld	a0,24(sp)
ffffffffc0207ff6:	679c                	ld	a5,8(a5)
ffffffffc0207ff8:	9782                	jalr	a5
ffffffffc0207ffa:	87aa                	mv	a5,a0
ffffffffc0207ffc:	e43e                	sd	a5,8(sp)
ffffffffc0207ffe:	6562                	ld	a0,24(sp)
ffffffffc0208000:	e3d1                	bnez	a5,ffffffffc0208084 <vfs_open+0x13e>
ffffffffc0208002:	839ff0ef          	jal	ffffffffc020783a <inode_open_inc>
ffffffffc0208006:	014ae733          	or	a4,s5,s4
ffffffffc020800a:	67a2                	ld	a5,8(sp)
ffffffffc020800c:	c71d                	beqz	a4,ffffffffc020803a <vfs_open+0xf4>
ffffffffc020800e:	6462                	ld	s0,24(sp)
ffffffffc0208010:	c455                	beqz	s0,ffffffffc02080bc <vfs_open+0x176>
ffffffffc0208012:	7838                	ld	a4,112(s0)
ffffffffc0208014:	c745                	beqz	a4,ffffffffc02080bc <vfs_open+0x176>
ffffffffc0208016:	7338                	ld	a4,96(a4)
ffffffffc0208018:	c355                	beqz	a4,ffffffffc02080bc <vfs_open+0x176>
ffffffffc020801a:	8522                	mv	a0,s0
ffffffffc020801c:	00006597          	auipc	a1,0x6
ffffffffc0208020:	ecc58593          	addi	a1,a1,-308 # ffffffffc020dee8 <etext+0x28ee>
ffffffffc0208024:	e43e                	sd	a5,8(sp)
ffffffffc0208026:	81fff0ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc020802a:	7838                	ld	a4,112(s0)
ffffffffc020802c:	6562                	ld	a0,24(sp)
ffffffffc020802e:	4581                	li	a1,0
ffffffffc0208030:	7338                	ld	a4,96(a4)
ffffffffc0208032:	9702                	jalr	a4
ffffffffc0208034:	67a2                	ld	a5,8(sp)
ffffffffc0208036:	842a                	mv	s0,a0
ffffffffc0208038:	e931                	bnez	a0,ffffffffc020808c <vfs_open+0x146>
ffffffffc020803a:	6762                	ld	a4,24(sp)
ffffffffc020803c:	00eb3023          	sd	a4,0(s6)
ffffffffc0208040:	7406                	ld	s0,96(sp)
ffffffffc0208042:	64e6                	ld	s1,88(sp)
ffffffffc0208044:	6946                	ld	s2,80(sp)
ffffffffc0208046:	69a6                	ld	s3,72(sp)
ffffffffc0208048:	7ae2                	ld	s5,56(sp)
ffffffffc020804a:	7b42                	ld	s6,48(sp)
ffffffffc020804c:	70a6                	ld	ra,104(sp)
ffffffffc020804e:	6a06                	ld	s4,64(sp)
ffffffffc0208050:	853e                	mv	a0,a5
ffffffffc0208052:	6165                	addi	sp,sp,112
ffffffffc0208054:	8082                	ret
ffffffffc0208056:	0105f713          	andi	a4,a1,16
ffffffffc020805a:	8a3a                	mv	s4,a4
ffffffffc020805c:	57f5                	li	a5,-3
ffffffffc020805e:	f77d                	bnez	a4,ffffffffc020804c <vfs_open+0x106>
ffffffffc0208060:	f0a2                	sd	s0,96(sp)
ffffffffc0208062:	eca6                	sd	s1,88(sp)
ffffffffc0208064:	e8ca                	sd	s2,80(sp)
ffffffffc0208066:	e4ce                	sd	s3,72(sp)
ffffffffc0208068:	fc56                	sd	s5,56(sp)
ffffffffc020806a:	f85a                	sd	s6,48(sp)
ffffffffc020806c:	bdfd                	j	ffffffffc0207f6a <vfs_open+0x24>
ffffffffc020806e:	f60982e3          	beqz	s3,ffffffffc0207fd2 <vfs_open+0x8c>
ffffffffc0208072:	d0a5                	beqz	s1,ffffffffc0207fd2 <vfs_open+0x8c>
ffffffffc0208074:	57a5                	li	a5,-23
ffffffffc0208076:	b7e9                	j	ffffffffc0208040 <vfs_open+0xfa>
ffffffffc0208078:	70a6                	ld	ra,104(sp)
ffffffffc020807a:	57f5                	li	a5,-3
ffffffffc020807c:	6a06                	ld	s4,64(sp)
ffffffffc020807e:	853e                	mv	a0,a5
ffffffffc0208080:	6165                	addi	sp,sp,112
ffffffffc0208082:	8082                	ret
ffffffffc0208084:	87bff0ef          	jal	ffffffffc02078fe <inode_ref_dec>
ffffffffc0208088:	67a2                	ld	a5,8(sp)
ffffffffc020808a:	bf5d                	j	ffffffffc0208040 <vfs_open+0xfa>
ffffffffc020808c:	6562                	ld	a0,24(sp)
ffffffffc020808e:	90dff0ef          	jal	ffffffffc020799a <inode_open_dec>
ffffffffc0208092:	6562                	ld	a0,24(sp)
ffffffffc0208094:	86bff0ef          	jal	ffffffffc02078fe <inode_ref_dec>
ffffffffc0208098:	87a2                	mv	a5,s0
ffffffffc020809a:	b75d                	j	ffffffffc0208040 <vfs_open+0xfa>
ffffffffc020809c:	00006697          	auipc	a3,0x6
ffffffffc02080a0:	d9c68693          	addi	a3,a3,-612 # ffffffffc020de38 <etext+0x283e>
ffffffffc02080a4:	00004617          	auipc	a2,0x4
ffffffffc02080a8:	99460613          	addi	a2,a2,-1644 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02080ac:	03300593          	li	a1,51
ffffffffc02080b0:	00006517          	auipc	a0,0x6
ffffffffc02080b4:	d5850513          	addi	a0,a0,-680 # ffffffffc020de08 <etext+0x280e>
ffffffffc02080b8:	b92f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02080bc:	00006697          	auipc	a3,0x6
ffffffffc02080c0:	dd468693          	addi	a3,a3,-556 # ffffffffc020de90 <etext+0x2896>
ffffffffc02080c4:	00004617          	auipc	a2,0x4
ffffffffc02080c8:	97460613          	addi	a2,a2,-1676 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02080cc:	03a00593          	li	a1,58
ffffffffc02080d0:	00006517          	auipc	a0,0x6
ffffffffc02080d4:	d3850513          	addi	a0,a0,-712 # ffffffffc020de08 <etext+0x280e>
ffffffffc02080d8:	b72f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02080dc:	00006697          	auipc	a3,0x6
ffffffffc02080e0:	d4c68693          	addi	a3,a3,-692 # ffffffffc020de28 <etext+0x282e>
ffffffffc02080e4:	00004617          	auipc	a2,0x4
ffffffffc02080e8:	95460613          	addi	a2,a2,-1708 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02080ec:	03100593          	li	a1,49
ffffffffc02080f0:	00006517          	auipc	a0,0x6
ffffffffc02080f4:	d1850513          	addi	a0,a0,-744 # ffffffffc020de08 <etext+0x280e>
ffffffffc02080f8:	b52f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02080fc:	00006697          	auipc	a3,0x6
ffffffffc0208100:	cbc68693          	addi	a3,a3,-836 # ffffffffc020ddb8 <etext+0x27be>
ffffffffc0208104:	00004617          	auipc	a2,0x4
ffffffffc0208108:	93460613          	addi	a2,a2,-1740 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020810c:	02c00593          	li	a1,44
ffffffffc0208110:	00006517          	auipc	a0,0x6
ffffffffc0208114:	cf850513          	addi	a0,a0,-776 # ffffffffc020de08 <etext+0x280e>
ffffffffc0208118:	b32f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc020811c <vfs_close>:
ffffffffc020811c:	1141                	addi	sp,sp,-16
ffffffffc020811e:	e406                	sd	ra,8(sp)
ffffffffc0208120:	e022                	sd	s0,0(sp)
ffffffffc0208122:	842a                	mv	s0,a0
ffffffffc0208124:	877ff0ef          	jal	ffffffffc020799a <inode_open_dec>
ffffffffc0208128:	8522                	mv	a0,s0
ffffffffc020812a:	fd4ff0ef          	jal	ffffffffc02078fe <inode_ref_dec>
ffffffffc020812e:	60a2                	ld	ra,8(sp)
ffffffffc0208130:	6402                	ld	s0,0(sp)
ffffffffc0208132:	4501                	li	a0,0
ffffffffc0208134:	0141                	addi	sp,sp,16
ffffffffc0208136:	8082                	ret

ffffffffc0208138 <get_device>:
ffffffffc0208138:	00054e03          	lbu	t3,0(a0)
ffffffffc020813c:	020e0463          	beqz	t3,ffffffffc0208164 <get_device+0x2c>
ffffffffc0208140:	00150693          	addi	a3,a0,1
ffffffffc0208144:	8736                	mv	a4,a3
ffffffffc0208146:	87f2                	mv	a5,t3
ffffffffc0208148:	4801                	li	a6,0
ffffffffc020814a:	03a00893          	li	a7,58
ffffffffc020814e:	02f00313          	li	t1,47
ffffffffc0208152:	01178c63          	beq	a5,a7,ffffffffc020816a <get_device+0x32>
ffffffffc0208156:	02678e63          	beq	a5,t1,ffffffffc0208192 <get_device+0x5a>
ffffffffc020815a:	00074783          	lbu	a5,0(a4)
ffffffffc020815e:	0705                	addi	a4,a4,1
ffffffffc0208160:	2805                	addiw	a6,a6,1 # fffffffffffff001 <end+0x3fd686f1>
ffffffffc0208162:	fbe5                	bnez	a5,ffffffffc0208152 <get_device+0x1a>
ffffffffc0208164:	e188                	sd	a0,0(a1)
ffffffffc0208166:	8532                	mv	a0,a2
ffffffffc0208168:	a269                	j	ffffffffc02082f2 <vfs_get_curdir>
ffffffffc020816a:	02080663          	beqz	a6,ffffffffc0208196 <get_device+0x5e>
ffffffffc020816e:	01050733          	add	a4,a0,a6
ffffffffc0208172:	010687b3          	add	a5,a3,a6
ffffffffc0208176:	00070023          	sb	zero,0(a4)
ffffffffc020817a:	02f00813          	li	a6,47
ffffffffc020817e:	86be                	mv	a3,a5
ffffffffc0208180:	0007c703          	lbu	a4,0(a5)
ffffffffc0208184:	0785                	addi	a5,a5,1
ffffffffc0208186:	ff070ce3          	beq	a4,a6,ffffffffc020817e <get_device+0x46>
ffffffffc020818a:	e194                	sd	a3,0(a1)
ffffffffc020818c:	85b2                	mv	a1,a2
ffffffffc020818e:	b93ff06f          	j	ffffffffc0207d20 <vfs_get_root>
ffffffffc0208192:	fc0819e3          	bnez	a6,ffffffffc0208164 <get_device+0x2c>
ffffffffc0208196:	7139                	addi	sp,sp,-64
ffffffffc0208198:	f822                	sd	s0,48(sp)
ffffffffc020819a:	f426                	sd	s1,40(sp)
ffffffffc020819c:	fc06                	sd	ra,56(sp)
ffffffffc020819e:	02f00793          	li	a5,47
ffffffffc02081a2:	8432                	mv	s0,a2
ffffffffc02081a4:	84ae                	mv	s1,a1
ffffffffc02081a6:	04fe0563          	beq	t3,a5,ffffffffc02081f0 <get_device+0xb8>
ffffffffc02081aa:	03a00793          	li	a5,58
ffffffffc02081ae:	06fe1863          	bne	t3,a5,ffffffffc020821e <get_device+0xe6>
ffffffffc02081b2:	0828                	addi	a0,sp,24
ffffffffc02081b4:	e436                	sd	a3,8(sp)
ffffffffc02081b6:	13c000ef          	jal	ffffffffc02082f2 <vfs_get_curdir>
ffffffffc02081ba:	e515                	bnez	a0,ffffffffc02081e6 <get_device+0xae>
ffffffffc02081bc:	67e2                	ld	a5,24(sp)
ffffffffc02081be:	77a8                	ld	a0,104(a5)
ffffffffc02081c0:	cd1d                	beqz	a0,ffffffffc02081fe <get_device+0xc6>
ffffffffc02081c2:	617c                	ld	a5,192(a0)
ffffffffc02081c4:	9782                	jalr	a5
ffffffffc02081c6:	87aa                	mv	a5,a0
ffffffffc02081c8:	6562                	ld	a0,24(sp)
ffffffffc02081ca:	e01c                	sd	a5,0(s0)
ffffffffc02081cc:	f32ff0ef          	jal	ffffffffc02078fe <inode_ref_dec>
ffffffffc02081d0:	66a2                	ld	a3,8(sp)
ffffffffc02081d2:	02f00713          	li	a4,47
ffffffffc02081d6:	a011                	j	ffffffffc02081da <get_device+0xa2>
ffffffffc02081d8:	0685                	addi	a3,a3,1
ffffffffc02081da:	0006c783          	lbu	a5,0(a3)
ffffffffc02081de:	fee78de3          	beq	a5,a4,ffffffffc02081d8 <get_device+0xa0>
ffffffffc02081e2:	e094                	sd	a3,0(s1)
ffffffffc02081e4:	4501                	li	a0,0
ffffffffc02081e6:	70e2                	ld	ra,56(sp)
ffffffffc02081e8:	7442                	ld	s0,48(sp)
ffffffffc02081ea:	74a2                	ld	s1,40(sp)
ffffffffc02081ec:	6121                	addi	sp,sp,64
ffffffffc02081ee:	8082                	ret
ffffffffc02081f0:	8532                	mv	a0,a2
ffffffffc02081f2:	e436                	sd	a3,8(sp)
ffffffffc02081f4:	8ebff0ef          	jal	ffffffffc0207ade <vfs_get_bootfs>
ffffffffc02081f8:	66a2                	ld	a3,8(sp)
ffffffffc02081fa:	dd61                	beqz	a0,ffffffffc02081d2 <get_device+0x9a>
ffffffffc02081fc:	b7ed                	j	ffffffffc02081e6 <get_device+0xae>
ffffffffc02081fe:	00006697          	auipc	a3,0x6
ffffffffc0208202:	d2268693          	addi	a3,a3,-734 # ffffffffc020df20 <etext+0x2926>
ffffffffc0208206:	00004617          	auipc	a2,0x4
ffffffffc020820a:	83260613          	addi	a2,a2,-1998 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020820e:	03900593          	li	a1,57
ffffffffc0208212:	00006517          	auipc	a0,0x6
ffffffffc0208216:	cf650513          	addi	a0,a0,-778 # ffffffffc020df08 <etext+0x290e>
ffffffffc020821a:	a30f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc020821e:	00006697          	auipc	a3,0x6
ffffffffc0208222:	cda68693          	addi	a3,a3,-806 # ffffffffc020def8 <etext+0x28fe>
ffffffffc0208226:	00004617          	auipc	a2,0x4
ffffffffc020822a:	81260613          	addi	a2,a2,-2030 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020822e:	03300593          	li	a1,51
ffffffffc0208232:	00006517          	auipc	a0,0x6
ffffffffc0208236:	cd650513          	addi	a0,a0,-810 # ffffffffc020df08 <etext+0x290e>
ffffffffc020823a:	a10f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc020823e <vfs_lookup>:
ffffffffc020823e:	7139                	addi	sp,sp,-64
ffffffffc0208240:	f822                	sd	s0,48(sp)
ffffffffc0208242:	1030                	addi	a2,sp,40
ffffffffc0208244:	842e                	mv	s0,a1
ffffffffc0208246:	082c                	addi	a1,sp,24
ffffffffc0208248:	fc06                	sd	ra,56(sp)
ffffffffc020824a:	ec2a                	sd	a0,24(sp)
ffffffffc020824c:	eedff0ef          	jal	ffffffffc0208138 <get_device>
ffffffffc0208250:	87aa                	mv	a5,a0
ffffffffc0208252:	e121                	bnez	a0,ffffffffc0208292 <vfs_lookup+0x54>
ffffffffc0208254:	6762                	ld	a4,24(sp)
ffffffffc0208256:	7522                	ld	a0,40(sp)
ffffffffc0208258:	00074683          	lbu	a3,0(a4)
ffffffffc020825c:	c2a1                	beqz	a3,ffffffffc020829c <vfs_lookup+0x5e>
ffffffffc020825e:	c529                	beqz	a0,ffffffffc02082a8 <vfs_lookup+0x6a>
ffffffffc0208260:	793c                	ld	a5,112(a0)
ffffffffc0208262:	c3b9                	beqz	a5,ffffffffc02082a8 <vfs_lookup+0x6a>
ffffffffc0208264:	7bbc                	ld	a5,112(a5)
ffffffffc0208266:	c3a9                	beqz	a5,ffffffffc02082a8 <vfs_lookup+0x6a>
ffffffffc0208268:	00006597          	auipc	a1,0x6
ffffffffc020826c:	d2058593          	addi	a1,a1,-736 # ffffffffc020df88 <etext+0x298e>
ffffffffc0208270:	e83a                	sd	a4,16(sp)
ffffffffc0208272:	e42a                	sd	a0,8(sp)
ffffffffc0208274:	dd0ff0ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc0208278:	6522                	ld	a0,8(sp)
ffffffffc020827a:	65c2                	ld	a1,16(sp)
ffffffffc020827c:	8622                	mv	a2,s0
ffffffffc020827e:	793c                	ld	a5,112(a0)
ffffffffc0208280:	7522                	ld	a0,40(sp)
ffffffffc0208282:	7bbc                	ld	a5,112(a5)
ffffffffc0208284:	9782                	jalr	a5
ffffffffc0208286:	87aa                	mv	a5,a0
ffffffffc0208288:	7522                	ld	a0,40(sp)
ffffffffc020828a:	e43e                	sd	a5,8(sp)
ffffffffc020828c:	e72ff0ef          	jal	ffffffffc02078fe <inode_ref_dec>
ffffffffc0208290:	67a2                	ld	a5,8(sp)
ffffffffc0208292:	70e2                	ld	ra,56(sp)
ffffffffc0208294:	7442                	ld	s0,48(sp)
ffffffffc0208296:	853e                	mv	a0,a5
ffffffffc0208298:	6121                	addi	sp,sp,64
ffffffffc020829a:	8082                	ret
ffffffffc020829c:	e008                	sd	a0,0(s0)
ffffffffc020829e:	70e2                	ld	ra,56(sp)
ffffffffc02082a0:	7442                	ld	s0,48(sp)
ffffffffc02082a2:	853e                	mv	a0,a5
ffffffffc02082a4:	6121                	addi	sp,sp,64
ffffffffc02082a6:	8082                	ret
ffffffffc02082a8:	00006697          	auipc	a3,0x6
ffffffffc02082ac:	c9068693          	addi	a3,a3,-880 # ffffffffc020df38 <etext+0x293e>
ffffffffc02082b0:	00003617          	auipc	a2,0x3
ffffffffc02082b4:	78860613          	addi	a2,a2,1928 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02082b8:	04f00593          	li	a1,79
ffffffffc02082bc:	00006517          	auipc	a0,0x6
ffffffffc02082c0:	c4c50513          	addi	a0,a0,-948 # ffffffffc020df08 <etext+0x290e>
ffffffffc02082c4:	986f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02082c8 <vfs_lookup_parent>:
ffffffffc02082c8:	7139                	addi	sp,sp,-64
ffffffffc02082ca:	f822                	sd	s0,48(sp)
ffffffffc02082cc:	f426                	sd	s1,40(sp)
ffffffffc02082ce:	8432                	mv	s0,a2
ffffffffc02082d0:	84ae                	mv	s1,a1
ffffffffc02082d2:	0830                	addi	a2,sp,24
ffffffffc02082d4:	002c                	addi	a1,sp,8
ffffffffc02082d6:	fc06                	sd	ra,56(sp)
ffffffffc02082d8:	e42a                	sd	a0,8(sp)
ffffffffc02082da:	e5fff0ef          	jal	ffffffffc0208138 <get_device>
ffffffffc02082de:	e509                	bnez	a0,ffffffffc02082e8 <vfs_lookup_parent+0x20>
ffffffffc02082e0:	6722                	ld	a4,8(sp)
ffffffffc02082e2:	67e2                	ld	a5,24(sp)
ffffffffc02082e4:	e018                	sd	a4,0(s0)
ffffffffc02082e6:	e09c                	sd	a5,0(s1)
ffffffffc02082e8:	70e2                	ld	ra,56(sp)
ffffffffc02082ea:	7442                	ld	s0,48(sp)
ffffffffc02082ec:	74a2                	ld	s1,40(sp)
ffffffffc02082ee:	6121                	addi	sp,sp,64
ffffffffc02082f0:	8082                	ret

ffffffffc02082f2 <vfs_get_curdir>:
ffffffffc02082f2:	0008e797          	auipc	a5,0x8e
ffffffffc02082f6:	5d67b783          	ld	a5,1494(a5) # ffffffffc02968c8 <current>
ffffffffc02082fa:	1101                	addi	sp,sp,-32
ffffffffc02082fc:	e822                	sd	s0,16(sp)
ffffffffc02082fe:	1487b783          	ld	a5,328(a5)
ffffffffc0208302:	ec06                	sd	ra,24(sp)
ffffffffc0208304:	6380                	ld	s0,0(a5)
ffffffffc0208306:	cc09                	beqz	s0,ffffffffc0208320 <vfs_get_curdir+0x2e>
ffffffffc0208308:	e426                	sd	s1,8(sp)
ffffffffc020830a:	84aa                	mv	s1,a0
ffffffffc020830c:	8522                	mv	a0,s0
ffffffffc020830e:	d22ff0ef          	jal	ffffffffc0207830 <inode_ref_inc>
ffffffffc0208312:	e080                	sd	s0,0(s1)
ffffffffc0208314:	64a2                	ld	s1,8(sp)
ffffffffc0208316:	4501                	li	a0,0
ffffffffc0208318:	60e2                	ld	ra,24(sp)
ffffffffc020831a:	6442                	ld	s0,16(sp)
ffffffffc020831c:	6105                	addi	sp,sp,32
ffffffffc020831e:	8082                	ret
ffffffffc0208320:	5541                	li	a0,-16
ffffffffc0208322:	bfdd                	j	ffffffffc0208318 <vfs_get_curdir+0x26>

ffffffffc0208324 <vfs_set_curdir>:
ffffffffc0208324:	7139                	addi	sp,sp,-64
ffffffffc0208326:	f04a                	sd	s2,32(sp)
ffffffffc0208328:	0008e917          	auipc	s2,0x8e
ffffffffc020832c:	5a090913          	addi	s2,s2,1440 # ffffffffc02968c8 <current>
ffffffffc0208330:	00093783          	ld	a5,0(s2)
ffffffffc0208334:	f822                	sd	s0,48(sp)
ffffffffc0208336:	842a                	mv	s0,a0
ffffffffc0208338:	1487b503          	ld	a0,328(a5)
ffffffffc020833c:	fc06                	sd	ra,56(sp)
ffffffffc020833e:	f426                	sd	s1,40(sp)
ffffffffc0208340:	d4ffc0ef          	jal	ffffffffc020508e <lock_files>
ffffffffc0208344:	00093783          	ld	a5,0(s2)
ffffffffc0208348:	1487b503          	ld	a0,328(a5)
ffffffffc020834c:	611c                	ld	a5,0(a0)
ffffffffc020834e:	06f40a63          	beq	s0,a5,ffffffffc02083c2 <vfs_set_curdir+0x9e>
ffffffffc0208352:	c02d                	beqz	s0,ffffffffc02083b4 <vfs_set_curdir+0x90>
ffffffffc0208354:	7838                	ld	a4,112(s0)
ffffffffc0208356:	cb25                	beqz	a4,ffffffffc02083c6 <vfs_set_curdir+0xa2>
ffffffffc0208358:	6b38                	ld	a4,80(a4)
ffffffffc020835a:	c735                	beqz	a4,ffffffffc02083c6 <vfs_set_curdir+0xa2>
ffffffffc020835c:	00006597          	auipc	a1,0x6
ffffffffc0208360:	c9c58593          	addi	a1,a1,-868 # ffffffffc020dff8 <etext+0x29fe>
ffffffffc0208364:	8522                	mv	a0,s0
ffffffffc0208366:	e43e                	sd	a5,8(sp)
ffffffffc0208368:	cdcff0ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc020836c:	7838                	ld	a4,112(s0)
ffffffffc020836e:	086c                	addi	a1,sp,28
ffffffffc0208370:	8522                	mv	a0,s0
ffffffffc0208372:	6b38                	ld	a4,80(a4)
ffffffffc0208374:	9702                	jalr	a4
ffffffffc0208376:	84aa                	mv	s1,a0
ffffffffc0208378:	e909                	bnez	a0,ffffffffc020838a <vfs_set_curdir+0x66>
ffffffffc020837a:	4772                	lw	a4,28(sp)
ffffffffc020837c:	4609                	li	a2,2
ffffffffc020837e:	54b9                	li	s1,-18
ffffffffc0208380:	40c75693          	srai	a3,a4,0xc
ffffffffc0208384:	8a9d                	andi	a3,a3,7
ffffffffc0208386:	00c68f63          	beq	a3,a2,ffffffffc02083a4 <vfs_set_curdir+0x80>
ffffffffc020838a:	00093783          	ld	a5,0(s2)
ffffffffc020838e:	1487b503          	ld	a0,328(a5)
ffffffffc0208392:	d03fc0ef          	jal	ffffffffc0205094 <unlock_files>
ffffffffc0208396:	70e2                	ld	ra,56(sp)
ffffffffc0208398:	7442                	ld	s0,48(sp)
ffffffffc020839a:	7902                	ld	s2,32(sp)
ffffffffc020839c:	8526                	mv	a0,s1
ffffffffc020839e:	74a2                	ld	s1,40(sp)
ffffffffc02083a0:	6121                	addi	sp,sp,64
ffffffffc02083a2:	8082                	ret
ffffffffc02083a4:	8522                	mv	a0,s0
ffffffffc02083a6:	c8aff0ef          	jal	ffffffffc0207830 <inode_ref_inc>
ffffffffc02083aa:	00093703          	ld	a4,0(s2)
ffffffffc02083ae:	67a2                	ld	a5,8(sp)
ffffffffc02083b0:	14873503          	ld	a0,328(a4)
ffffffffc02083b4:	e100                	sd	s0,0(a0)
ffffffffc02083b6:	4481                	li	s1,0
ffffffffc02083b8:	dfe9                	beqz	a5,ffffffffc0208392 <vfs_set_curdir+0x6e>
ffffffffc02083ba:	853e                	mv	a0,a5
ffffffffc02083bc:	d42ff0ef          	jal	ffffffffc02078fe <inode_ref_dec>
ffffffffc02083c0:	b7e9                	j	ffffffffc020838a <vfs_set_curdir+0x66>
ffffffffc02083c2:	4481                	li	s1,0
ffffffffc02083c4:	b7f9                	j	ffffffffc0208392 <vfs_set_curdir+0x6e>
ffffffffc02083c6:	00006697          	auipc	a3,0x6
ffffffffc02083ca:	bca68693          	addi	a3,a3,-1078 # ffffffffc020df90 <etext+0x2996>
ffffffffc02083ce:	00003617          	auipc	a2,0x3
ffffffffc02083d2:	66a60613          	addi	a2,a2,1642 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02083d6:	04300593          	li	a1,67
ffffffffc02083da:	00006517          	auipc	a0,0x6
ffffffffc02083de:	c0650513          	addi	a0,a0,-1018 # ffffffffc020dfe0 <etext+0x29e6>
ffffffffc02083e2:	868f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02083e6 <vfs_chdir>:
ffffffffc02083e6:	7179                	addi	sp,sp,-48
ffffffffc02083e8:	082c                	addi	a1,sp,24
ffffffffc02083ea:	f406                	sd	ra,40(sp)
ffffffffc02083ec:	e53ff0ef          	jal	ffffffffc020823e <vfs_lookup>
ffffffffc02083f0:	87aa                	mv	a5,a0
ffffffffc02083f2:	c509                	beqz	a0,ffffffffc02083fc <vfs_chdir+0x16>
ffffffffc02083f4:	70a2                	ld	ra,40(sp)
ffffffffc02083f6:	853e                	mv	a0,a5
ffffffffc02083f8:	6145                	addi	sp,sp,48
ffffffffc02083fa:	8082                	ret
ffffffffc02083fc:	6562                	ld	a0,24(sp)
ffffffffc02083fe:	f27ff0ef          	jal	ffffffffc0208324 <vfs_set_curdir>
ffffffffc0208402:	87aa                	mv	a5,a0
ffffffffc0208404:	6562                	ld	a0,24(sp)
ffffffffc0208406:	e43e                	sd	a5,8(sp)
ffffffffc0208408:	cf6ff0ef          	jal	ffffffffc02078fe <inode_ref_dec>
ffffffffc020840c:	67a2                	ld	a5,8(sp)
ffffffffc020840e:	70a2                	ld	ra,40(sp)
ffffffffc0208410:	853e                	mv	a0,a5
ffffffffc0208412:	6145                	addi	sp,sp,48
ffffffffc0208414:	8082                	ret

ffffffffc0208416 <vfs_getcwd>:
ffffffffc0208416:	0008e797          	auipc	a5,0x8e
ffffffffc020841a:	4b27b783          	ld	a5,1202(a5) # ffffffffc02968c8 <current>
ffffffffc020841e:	7179                	addi	sp,sp,-48
ffffffffc0208420:	ec26                	sd	s1,24(sp)
ffffffffc0208422:	1487b783          	ld	a5,328(a5)
ffffffffc0208426:	f406                	sd	ra,40(sp)
ffffffffc0208428:	f022                	sd	s0,32(sp)
ffffffffc020842a:	6384                	ld	s1,0(a5)
ffffffffc020842c:	c0c1                	beqz	s1,ffffffffc02084ac <vfs_getcwd+0x96>
ffffffffc020842e:	e84a                	sd	s2,16(sp)
ffffffffc0208430:	892a                	mv	s2,a0
ffffffffc0208432:	8526                	mv	a0,s1
ffffffffc0208434:	bfcff0ef          	jal	ffffffffc0207830 <inode_ref_inc>
ffffffffc0208438:	74a8                	ld	a0,104(s1)
ffffffffc020843a:	c93d                	beqz	a0,ffffffffc02084b0 <vfs_getcwd+0x9a>
ffffffffc020843c:	9a5ff0ef          	jal	ffffffffc0207de0 <vfs_get_devname>
ffffffffc0208440:	842a                	mv	s0,a0
ffffffffc0208442:	09c030ef          	jal	ffffffffc020b4de <strlen>
ffffffffc0208446:	862a                	mv	a2,a0
ffffffffc0208448:	85a2                	mv	a1,s0
ffffffffc020844a:	854a                	mv	a0,s2
ffffffffc020844c:	4701                	li	a4,0
ffffffffc020844e:	4685                	li	a3,1
ffffffffc0208450:	e69fc0ef          	jal	ffffffffc02052b8 <iobuf_move>
ffffffffc0208454:	842a                	mv	s0,a0
ffffffffc0208456:	c919                	beqz	a0,ffffffffc020846c <vfs_getcwd+0x56>
ffffffffc0208458:	8526                	mv	a0,s1
ffffffffc020845a:	ca4ff0ef          	jal	ffffffffc02078fe <inode_ref_dec>
ffffffffc020845e:	6942                	ld	s2,16(sp)
ffffffffc0208460:	70a2                	ld	ra,40(sp)
ffffffffc0208462:	8522                	mv	a0,s0
ffffffffc0208464:	7402                	ld	s0,32(sp)
ffffffffc0208466:	64e2                	ld	s1,24(sp)
ffffffffc0208468:	6145                	addi	sp,sp,48
ffffffffc020846a:	8082                	ret
ffffffffc020846c:	4685                	li	a3,1
ffffffffc020846e:	03a00793          	li	a5,58
ffffffffc0208472:	8636                	mv	a2,a3
ffffffffc0208474:	4701                	li	a4,0
ffffffffc0208476:	00f10593          	addi	a1,sp,15
ffffffffc020847a:	854a                	mv	a0,s2
ffffffffc020847c:	00f107a3          	sb	a5,15(sp)
ffffffffc0208480:	e39fc0ef          	jal	ffffffffc02052b8 <iobuf_move>
ffffffffc0208484:	842a                	mv	s0,a0
ffffffffc0208486:	f969                	bnez	a0,ffffffffc0208458 <vfs_getcwd+0x42>
ffffffffc0208488:	78bc                	ld	a5,112(s1)
ffffffffc020848a:	c3b9                	beqz	a5,ffffffffc02084d0 <vfs_getcwd+0xba>
ffffffffc020848c:	7f9c                	ld	a5,56(a5)
ffffffffc020848e:	c3a9                	beqz	a5,ffffffffc02084d0 <vfs_getcwd+0xba>
ffffffffc0208490:	00006597          	auipc	a1,0x6
ffffffffc0208494:	bc858593          	addi	a1,a1,-1080 # ffffffffc020e058 <etext+0x2a5e>
ffffffffc0208498:	8526                	mv	a0,s1
ffffffffc020849a:	baaff0ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc020849e:	78bc                	ld	a5,112(s1)
ffffffffc02084a0:	85ca                	mv	a1,s2
ffffffffc02084a2:	8526                	mv	a0,s1
ffffffffc02084a4:	7f9c                	ld	a5,56(a5)
ffffffffc02084a6:	9782                	jalr	a5
ffffffffc02084a8:	842a                	mv	s0,a0
ffffffffc02084aa:	b77d                	j	ffffffffc0208458 <vfs_getcwd+0x42>
ffffffffc02084ac:	5441                	li	s0,-16
ffffffffc02084ae:	bf4d                	j	ffffffffc0208460 <vfs_getcwd+0x4a>
ffffffffc02084b0:	00006697          	auipc	a3,0x6
ffffffffc02084b4:	a7068693          	addi	a3,a3,-1424 # ffffffffc020df20 <etext+0x2926>
ffffffffc02084b8:	00003617          	auipc	a2,0x3
ffffffffc02084bc:	58060613          	addi	a2,a2,1408 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02084c0:	06e00593          	li	a1,110
ffffffffc02084c4:	00006517          	auipc	a0,0x6
ffffffffc02084c8:	b1c50513          	addi	a0,a0,-1252 # ffffffffc020dfe0 <etext+0x29e6>
ffffffffc02084cc:	f7ff70ef          	jal	ffffffffc020044a <__panic>
ffffffffc02084d0:	00006697          	auipc	a3,0x6
ffffffffc02084d4:	b3068693          	addi	a3,a3,-1232 # ffffffffc020e000 <etext+0x2a06>
ffffffffc02084d8:	00003617          	auipc	a2,0x3
ffffffffc02084dc:	56060613          	addi	a2,a2,1376 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02084e0:	07800593          	li	a1,120
ffffffffc02084e4:	00006517          	auipc	a0,0x6
ffffffffc02084e8:	afc50513          	addi	a0,a0,-1284 # ffffffffc020dfe0 <etext+0x29e6>
ffffffffc02084ec:	f5ff70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02084f0 <dev_lookup>:
ffffffffc02084f0:	0005c703          	lbu	a4,0(a1)
ffffffffc02084f4:	ef11                	bnez	a4,ffffffffc0208510 <dev_lookup+0x20>
ffffffffc02084f6:	1101                	addi	sp,sp,-32
ffffffffc02084f8:	ec06                	sd	ra,24(sp)
ffffffffc02084fa:	e032                	sd	a2,0(sp)
ffffffffc02084fc:	e42a                	sd	a0,8(sp)
ffffffffc02084fe:	b32ff0ef          	jal	ffffffffc0207830 <inode_ref_inc>
ffffffffc0208502:	6602                	ld	a2,0(sp)
ffffffffc0208504:	67a2                	ld	a5,8(sp)
ffffffffc0208506:	60e2                	ld	ra,24(sp)
ffffffffc0208508:	4501                	li	a0,0
ffffffffc020850a:	e21c                	sd	a5,0(a2)
ffffffffc020850c:	6105                	addi	sp,sp,32
ffffffffc020850e:	8082                	ret
ffffffffc0208510:	5541                	li	a0,-16
ffffffffc0208512:	8082                	ret

ffffffffc0208514 <dev_fstat>:
ffffffffc0208514:	1101                	addi	sp,sp,-32
ffffffffc0208516:	e822                	sd	s0,16(sp)
ffffffffc0208518:	e426                	sd	s1,8(sp)
ffffffffc020851a:	842a                	mv	s0,a0
ffffffffc020851c:	84ae                	mv	s1,a1
ffffffffc020851e:	852e                	mv	a0,a1
ffffffffc0208520:	02000613          	li	a2,32
ffffffffc0208524:	4581                	li	a1,0
ffffffffc0208526:	ec06                	sd	ra,24(sp)
ffffffffc0208528:	06a030ef          	jal	ffffffffc020b592 <memset>
ffffffffc020852c:	c429                	beqz	s0,ffffffffc0208576 <dev_fstat+0x62>
ffffffffc020852e:	783c                	ld	a5,112(s0)
ffffffffc0208530:	c3b9                	beqz	a5,ffffffffc0208576 <dev_fstat+0x62>
ffffffffc0208532:	6bbc                	ld	a5,80(a5)
ffffffffc0208534:	c3a9                	beqz	a5,ffffffffc0208576 <dev_fstat+0x62>
ffffffffc0208536:	00006597          	auipc	a1,0x6
ffffffffc020853a:	ac258593          	addi	a1,a1,-1342 # ffffffffc020dff8 <etext+0x29fe>
ffffffffc020853e:	8522                	mv	a0,s0
ffffffffc0208540:	b04ff0ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc0208544:	783c                	ld	a5,112(s0)
ffffffffc0208546:	85a6                	mv	a1,s1
ffffffffc0208548:	8522                	mv	a0,s0
ffffffffc020854a:	6bbc                	ld	a5,80(a5)
ffffffffc020854c:	9782                	jalr	a5
ffffffffc020854e:	ed19                	bnez	a0,ffffffffc020856c <dev_fstat+0x58>
ffffffffc0208550:	4c38                	lw	a4,88(s0)
ffffffffc0208552:	6785                	lui	a5,0x1
ffffffffc0208554:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208558:	02f71f63          	bne	a4,a5,ffffffffc0208596 <dev_fstat+0x82>
ffffffffc020855c:	6018                	ld	a4,0(s0)
ffffffffc020855e:	641c                	ld	a5,8(s0)
ffffffffc0208560:	4685                	li	a3,1
ffffffffc0208562:	e898                	sd	a4,16(s1)
ffffffffc0208564:	02e787b3          	mul	a5,a5,a4
ffffffffc0208568:	e494                	sd	a3,8(s1)
ffffffffc020856a:	ec9c                	sd	a5,24(s1)
ffffffffc020856c:	60e2                	ld	ra,24(sp)
ffffffffc020856e:	6442                	ld	s0,16(sp)
ffffffffc0208570:	64a2                	ld	s1,8(sp)
ffffffffc0208572:	6105                	addi	sp,sp,32
ffffffffc0208574:	8082                	ret
ffffffffc0208576:	00006697          	auipc	a3,0x6
ffffffffc020857a:	a1a68693          	addi	a3,a3,-1510 # ffffffffc020df90 <etext+0x2996>
ffffffffc020857e:	00003617          	auipc	a2,0x3
ffffffffc0208582:	4ba60613          	addi	a2,a2,1210 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0208586:	04200593          	li	a1,66
ffffffffc020858a:	00006517          	auipc	a0,0x6
ffffffffc020858e:	ade50513          	addi	a0,a0,-1314 # ffffffffc020e068 <etext+0x2a6e>
ffffffffc0208592:	eb9f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208596:	00005697          	auipc	a3,0x5
ffffffffc020859a:	7c268693          	addi	a3,a3,1986 # ffffffffc020dd58 <etext+0x275e>
ffffffffc020859e:	00003617          	auipc	a2,0x3
ffffffffc02085a2:	49a60613          	addi	a2,a2,1178 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02085a6:	04500593          	li	a1,69
ffffffffc02085aa:	00006517          	auipc	a0,0x6
ffffffffc02085ae:	abe50513          	addi	a0,a0,-1346 # ffffffffc020e068 <etext+0x2a6e>
ffffffffc02085b2:	e99f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02085b6 <dev_ioctl>:
ffffffffc02085b6:	c909                	beqz	a0,ffffffffc02085c8 <dev_ioctl+0x12>
ffffffffc02085b8:	4d34                	lw	a3,88(a0)
ffffffffc02085ba:	6705                	lui	a4,0x1
ffffffffc02085bc:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02085c0:	00e69463          	bne	a3,a4,ffffffffc02085c8 <dev_ioctl+0x12>
ffffffffc02085c4:	751c                	ld	a5,40(a0)
ffffffffc02085c6:	8782                	jr	a5
ffffffffc02085c8:	1141                	addi	sp,sp,-16
ffffffffc02085ca:	00005697          	auipc	a3,0x5
ffffffffc02085ce:	78e68693          	addi	a3,a3,1934 # ffffffffc020dd58 <etext+0x275e>
ffffffffc02085d2:	00003617          	auipc	a2,0x3
ffffffffc02085d6:	46660613          	addi	a2,a2,1126 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02085da:	03500593          	li	a1,53
ffffffffc02085de:	00006517          	auipc	a0,0x6
ffffffffc02085e2:	a8a50513          	addi	a0,a0,-1398 # ffffffffc020e068 <etext+0x2a6e>
ffffffffc02085e6:	e406                	sd	ra,8(sp)
ffffffffc02085e8:	e63f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02085ec <dev_tryseek>:
ffffffffc02085ec:	c51d                	beqz	a0,ffffffffc020861a <dev_tryseek+0x2e>
ffffffffc02085ee:	4d38                	lw	a4,88(a0)
ffffffffc02085f0:	6785                	lui	a5,0x1
ffffffffc02085f2:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02085f6:	02f71263          	bne	a4,a5,ffffffffc020861a <dev_tryseek+0x2e>
ffffffffc02085fa:	611c                	ld	a5,0(a0)
ffffffffc02085fc:	cf89                	beqz	a5,ffffffffc0208616 <dev_tryseek+0x2a>
ffffffffc02085fe:	6518                	ld	a4,8(a0)
ffffffffc0208600:	02e5f6b3          	remu	a3,a1,a4
ffffffffc0208604:	ea89                	bnez	a3,ffffffffc0208616 <dev_tryseek+0x2a>
ffffffffc0208606:	0005c863          	bltz	a1,ffffffffc0208616 <dev_tryseek+0x2a>
ffffffffc020860a:	02e787b3          	mul	a5,a5,a4
ffffffffc020860e:	4501                	li	a0,0
ffffffffc0208610:	00f5f363          	bgeu	a1,a5,ffffffffc0208616 <dev_tryseek+0x2a>
ffffffffc0208614:	8082                	ret
ffffffffc0208616:	5575                	li	a0,-3
ffffffffc0208618:	8082                	ret
ffffffffc020861a:	1141                	addi	sp,sp,-16
ffffffffc020861c:	00005697          	auipc	a3,0x5
ffffffffc0208620:	73c68693          	addi	a3,a3,1852 # ffffffffc020dd58 <etext+0x275e>
ffffffffc0208624:	00003617          	auipc	a2,0x3
ffffffffc0208628:	41460613          	addi	a2,a2,1044 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020862c:	05f00593          	li	a1,95
ffffffffc0208630:	00006517          	auipc	a0,0x6
ffffffffc0208634:	a3850513          	addi	a0,a0,-1480 # ffffffffc020e068 <etext+0x2a6e>
ffffffffc0208638:	e406                	sd	ra,8(sp)
ffffffffc020863a:	e11f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc020863e <dev_gettype>:
ffffffffc020863e:	cd11                	beqz	a0,ffffffffc020865a <dev_gettype+0x1c>
ffffffffc0208640:	4d38                	lw	a4,88(a0)
ffffffffc0208642:	6785                	lui	a5,0x1
ffffffffc0208644:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208648:	00f71963          	bne	a4,a5,ffffffffc020865a <dev_gettype+0x1c>
ffffffffc020864c:	6118                	ld	a4,0(a0)
ffffffffc020864e:	6791                	lui	a5,0x4
ffffffffc0208650:	c311                	beqz	a4,ffffffffc0208654 <dev_gettype+0x16>
ffffffffc0208652:	6795                	lui	a5,0x5
ffffffffc0208654:	c19c                	sw	a5,0(a1)
ffffffffc0208656:	4501                	li	a0,0
ffffffffc0208658:	8082                	ret
ffffffffc020865a:	1141                	addi	sp,sp,-16
ffffffffc020865c:	00005697          	auipc	a3,0x5
ffffffffc0208660:	6fc68693          	addi	a3,a3,1788 # ffffffffc020dd58 <etext+0x275e>
ffffffffc0208664:	00003617          	auipc	a2,0x3
ffffffffc0208668:	3d460613          	addi	a2,a2,980 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020866c:	05300593          	li	a1,83
ffffffffc0208670:	00006517          	auipc	a0,0x6
ffffffffc0208674:	9f850513          	addi	a0,a0,-1544 # ffffffffc020e068 <etext+0x2a6e>
ffffffffc0208678:	e406                	sd	ra,8(sp)
ffffffffc020867a:	dd1f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc020867e <dev_write>:
ffffffffc020867e:	c911                	beqz	a0,ffffffffc0208692 <dev_write+0x14>
ffffffffc0208680:	4d34                	lw	a3,88(a0)
ffffffffc0208682:	6705                	lui	a4,0x1
ffffffffc0208684:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208688:	00e69563          	bne	a3,a4,ffffffffc0208692 <dev_write+0x14>
ffffffffc020868c:	711c                	ld	a5,32(a0)
ffffffffc020868e:	4605                	li	a2,1
ffffffffc0208690:	8782                	jr	a5
ffffffffc0208692:	1141                	addi	sp,sp,-16
ffffffffc0208694:	00005697          	auipc	a3,0x5
ffffffffc0208698:	6c468693          	addi	a3,a3,1732 # ffffffffc020dd58 <etext+0x275e>
ffffffffc020869c:	00003617          	auipc	a2,0x3
ffffffffc02086a0:	39c60613          	addi	a2,a2,924 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02086a4:	02c00593          	li	a1,44
ffffffffc02086a8:	00006517          	auipc	a0,0x6
ffffffffc02086ac:	9c050513          	addi	a0,a0,-1600 # ffffffffc020e068 <etext+0x2a6e>
ffffffffc02086b0:	e406                	sd	ra,8(sp)
ffffffffc02086b2:	d99f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02086b6 <dev_read>:
ffffffffc02086b6:	c911                	beqz	a0,ffffffffc02086ca <dev_read+0x14>
ffffffffc02086b8:	4d34                	lw	a3,88(a0)
ffffffffc02086ba:	6705                	lui	a4,0x1
ffffffffc02086bc:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02086c0:	00e69563          	bne	a3,a4,ffffffffc02086ca <dev_read+0x14>
ffffffffc02086c4:	711c                	ld	a5,32(a0)
ffffffffc02086c6:	4601                	li	a2,0
ffffffffc02086c8:	8782                	jr	a5
ffffffffc02086ca:	1141                	addi	sp,sp,-16
ffffffffc02086cc:	00005697          	auipc	a3,0x5
ffffffffc02086d0:	68c68693          	addi	a3,a3,1676 # ffffffffc020dd58 <etext+0x275e>
ffffffffc02086d4:	00003617          	auipc	a2,0x3
ffffffffc02086d8:	36460613          	addi	a2,a2,868 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02086dc:	02300593          	li	a1,35
ffffffffc02086e0:	00006517          	auipc	a0,0x6
ffffffffc02086e4:	98850513          	addi	a0,a0,-1656 # ffffffffc020e068 <etext+0x2a6e>
ffffffffc02086e8:	e406                	sd	ra,8(sp)
ffffffffc02086ea:	d61f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02086ee <dev_close>:
ffffffffc02086ee:	c909                	beqz	a0,ffffffffc0208700 <dev_close+0x12>
ffffffffc02086f0:	4d34                	lw	a3,88(a0)
ffffffffc02086f2:	6705                	lui	a4,0x1
ffffffffc02086f4:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02086f8:	00e69463          	bne	a3,a4,ffffffffc0208700 <dev_close+0x12>
ffffffffc02086fc:	6d1c                	ld	a5,24(a0)
ffffffffc02086fe:	8782                	jr	a5
ffffffffc0208700:	1141                	addi	sp,sp,-16
ffffffffc0208702:	00005697          	auipc	a3,0x5
ffffffffc0208706:	65668693          	addi	a3,a3,1622 # ffffffffc020dd58 <etext+0x275e>
ffffffffc020870a:	00003617          	auipc	a2,0x3
ffffffffc020870e:	32e60613          	addi	a2,a2,814 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0208712:	45e9                	li	a1,26
ffffffffc0208714:	00006517          	auipc	a0,0x6
ffffffffc0208718:	95450513          	addi	a0,a0,-1708 # ffffffffc020e068 <etext+0x2a6e>
ffffffffc020871c:	e406                	sd	ra,8(sp)
ffffffffc020871e:	d2df70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208722 <dev_open>:
ffffffffc0208722:	03c5f793          	andi	a5,a1,60
ffffffffc0208726:	eb91                	bnez	a5,ffffffffc020873a <dev_open+0x18>
ffffffffc0208728:	c919                	beqz	a0,ffffffffc020873e <dev_open+0x1c>
ffffffffc020872a:	4d34                	lw	a3,88(a0)
ffffffffc020872c:	6785                	lui	a5,0x1
ffffffffc020872e:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208732:	00f69663          	bne	a3,a5,ffffffffc020873e <dev_open+0x1c>
ffffffffc0208736:	691c                	ld	a5,16(a0)
ffffffffc0208738:	8782                	jr	a5
ffffffffc020873a:	5575                	li	a0,-3
ffffffffc020873c:	8082                	ret
ffffffffc020873e:	1141                	addi	sp,sp,-16
ffffffffc0208740:	00005697          	auipc	a3,0x5
ffffffffc0208744:	61868693          	addi	a3,a3,1560 # ffffffffc020dd58 <etext+0x275e>
ffffffffc0208748:	00003617          	auipc	a2,0x3
ffffffffc020874c:	2f060613          	addi	a2,a2,752 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0208750:	45c5                	li	a1,17
ffffffffc0208752:	00006517          	auipc	a0,0x6
ffffffffc0208756:	91650513          	addi	a0,a0,-1770 # ffffffffc020e068 <etext+0x2a6e>
ffffffffc020875a:	e406                	sd	ra,8(sp)
ffffffffc020875c:	ceff70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208760 <dev_init>:
ffffffffc0208760:	1141                	addi	sp,sp,-16
ffffffffc0208762:	e406                	sd	ra,8(sp)
ffffffffc0208764:	544000ef          	jal	ffffffffc0208ca8 <dev_init_stdin>
ffffffffc0208768:	65c000ef          	jal	ffffffffc0208dc4 <dev_init_stdout>
ffffffffc020876c:	60a2                	ld	ra,8(sp)
ffffffffc020876e:	0141                	addi	sp,sp,16
ffffffffc0208770:	ac01                	j	ffffffffc0208980 <dev_init_disk0>

ffffffffc0208772 <dev_create_inode>:
ffffffffc0208772:	6505                	lui	a0,0x1
ffffffffc0208774:	1101                	addi	sp,sp,-32
ffffffffc0208776:	23450513          	addi	a0,a0,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc020877a:	ec06                	sd	ra,24(sp)
ffffffffc020877c:	836ff0ef          	jal	ffffffffc02077b2 <__alloc_inode>
ffffffffc0208780:	87aa                	mv	a5,a0
ffffffffc0208782:	c911                	beqz	a0,ffffffffc0208796 <dev_create_inode+0x24>
ffffffffc0208784:	4601                	li	a2,0
ffffffffc0208786:	00007597          	auipc	a1,0x7
ffffffffc020878a:	d0258593          	addi	a1,a1,-766 # ffffffffc020f488 <dev_node_ops>
ffffffffc020878e:	e42a                	sd	a0,8(sp)
ffffffffc0208790:	83eff0ef          	jal	ffffffffc02077ce <inode_init>
ffffffffc0208794:	67a2                	ld	a5,8(sp)
ffffffffc0208796:	60e2                	ld	ra,24(sp)
ffffffffc0208798:	853e                	mv	a0,a5
ffffffffc020879a:	6105                	addi	sp,sp,32
ffffffffc020879c:	8082                	ret

ffffffffc020879e <disk0_open>:
ffffffffc020879e:	4501                	li	a0,0
ffffffffc02087a0:	8082                	ret

ffffffffc02087a2 <disk0_close>:
ffffffffc02087a2:	4501                	li	a0,0
ffffffffc02087a4:	8082                	ret

ffffffffc02087a6 <disk0_ioctl>:
ffffffffc02087a6:	5531                	li	a0,-20
ffffffffc02087a8:	8082                	ret

ffffffffc02087aa <disk0_io>:
ffffffffc02087aa:	711d                	addi	sp,sp,-96
ffffffffc02087ac:	6594                	ld	a3,8(a1)
ffffffffc02087ae:	e8a2                	sd	s0,80(sp)
ffffffffc02087b0:	6d80                	ld	s0,24(a1)
ffffffffc02087b2:	6785                	lui	a5,0x1
ffffffffc02087b4:	17fd                	addi	a5,a5,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc02087b6:	0086e733          	or	a4,a3,s0
ffffffffc02087ba:	ec86                	sd	ra,88(sp)
ffffffffc02087bc:	8f7d                	and	a4,a4,a5
ffffffffc02087be:	14071663          	bnez	a4,ffffffffc020890a <disk0_io+0x160>
ffffffffc02087c2:	e0ca                	sd	s2,64(sp)
ffffffffc02087c4:	43f6d913          	srai	s2,a3,0x3f
ffffffffc02087c8:	00f97933          	and	s2,s2,a5
ffffffffc02087cc:	9936                	add	s2,s2,a3
ffffffffc02087ce:	40c95913          	srai	s2,s2,0xc
ffffffffc02087d2:	00c45793          	srli	a5,s0,0xc
ffffffffc02087d6:	0127873b          	addw	a4,a5,s2
ffffffffc02087da:	6114                	ld	a3,0(a0)
ffffffffc02087dc:	1702                	slli	a4,a4,0x20
ffffffffc02087de:	9301                	srli	a4,a4,0x20
ffffffffc02087e0:	2901                	sext.w	s2,s2
ffffffffc02087e2:	2781                	sext.w	a5,a5
ffffffffc02087e4:	12e6e063          	bltu	a3,a4,ffffffffc0208904 <disk0_io+0x15a>
ffffffffc02087e8:	e799                	bnez	a5,ffffffffc02087f6 <disk0_io+0x4c>
ffffffffc02087ea:	6906                	ld	s2,64(sp)
ffffffffc02087ec:	4501                	li	a0,0
ffffffffc02087ee:	60e6                	ld	ra,88(sp)
ffffffffc02087f0:	6446                	ld	s0,80(sp)
ffffffffc02087f2:	6125                	addi	sp,sp,96
ffffffffc02087f4:	8082                	ret
ffffffffc02087f6:	0008d517          	auipc	a0,0x8d
ffffffffc02087fa:	04a50513          	addi	a0,a0,74 # ffffffffc0295840 <disk0_sem>
ffffffffc02087fe:	e4a6                	sd	s1,72(sp)
ffffffffc0208800:	f852                	sd	s4,48(sp)
ffffffffc0208802:	f456                	sd	s5,40(sp)
ffffffffc0208804:	84b2                	mv	s1,a2
ffffffffc0208806:	8aae                	mv	s5,a1
ffffffffc0208808:	0008ea17          	auipc	s4,0x8e
ffffffffc020880c:	0f0a0a13          	addi	s4,s4,240 # ffffffffc02968f8 <disk0_buffer>
ffffffffc0208810:	c09fb0ef          	jal	ffffffffc0204418 <down>
ffffffffc0208814:	000a3603          	ld	a2,0(s4)
ffffffffc0208818:	e8ad                	bnez	s1,ffffffffc020888a <disk0_io+0xe0>
ffffffffc020881a:	e862                	sd	s8,16(sp)
ffffffffc020881c:	fc4e                	sd	s3,56(sp)
ffffffffc020881e:	ec5e                	sd	s7,24(sp)
ffffffffc0208820:	6c11                	lui	s8,0x4
ffffffffc0208822:	a029                	j	ffffffffc020882c <disk0_io+0x82>
ffffffffc0208824:	000a3603          	ld	a2,0(s4)
ffffffffc0208828:	0129893b          	addw	s2,s3,s2
ffffffffc020882c:	84a2                	mv	s1,s0
ffffffffc020882e:	008c7363          	bgeu	s8,s0,ffffffffc0208834 <disk0_io+0x8a>
ffffffffc0208832:	6491                	lui	s1,0x4
ffffffffc0208834:	00c4d993          	srli	s3,s1,0xc
ffffffffc0208838:	2981                	sext.w	s3,s3
ffffffffc020883a:	00399b9b          	slliw	s7,s3,0x3
ffffffffc020883e:	020b9693          	slli	a3,s7,0x20
ffffffffc0208842:	9281                	srli	a3,a3,0x20
ffffffffc0208844:	0039159b          	slliw	a1,s2,0x3
ffffffffc0208848:	4509                	li	a0,2
ffffffffc020884a:	aecf80ef          	jal	ffffffffc0200b36 <ide_read_secs>
ffffffffc020884e:	e16d                	bnez	a0,ffffffffc0208930 <disk0_io+0x186>
ffffffffc0208850:	000a3583          	ld	a1,0(s4)
ffffffffc0208854:	0038                	addi	a4,sp,8
ffffffffc0208856:	4685                	li	a3,1
ffffffffc0208858:	8626                	mv	a2,s1
ffffffffc020885a:	8556                	mv	a0,s5
ffffffffc020885c:	a5dfc0ef          	jal	ffffffffc02052b8 <iobuf_move>
ffffffffc0208860:	67a2                	ld	a5,8(sp)
ffffffffc0208862:	0a979663          	bne	a5,s1,ffffffffc020890e <disk0_io+0x164>
ffffffffc0208866:	03449793          	slli	a5,s1,0x34
ffffffffc020886a:	e3d5                	bnez	a5,ffffffffc020890e <disk0_io+0x164>
ffffffffc020886c:	8c05                	sub	s0,s0,s1
ffffffffc020886e:	f85d                	bnez	s0,ffffffffc0208824 <disk0_io+0x7a>
ffffffffc0208870:	79e2                	ld	s3,56(sp)
ffffffffc0208872:	6be2                	ld	s7,24(sp)
ffffffffc0208874:	6c42                	ld	s8,16(sp)
ffffffffc0208876:	0008d517          	auipc	a0,0x8d
ffffffffc020887a:	fca50513          	addi	a0,a0,-54 # ffffffffc0295840 <disk0_sem>
ffffffffc020887e:	b97fb0ef          	jal	ffffffffc0204414 <up>
ffffffffc0208882:	64a6                	ld	s1,72(sp)
ffffffffc0208884:	7a42                	ld	s4,48(sp)
ffffffffc0208886:	7aa2                	ld	s5,40(sp)
ffffffffc0208888:	b78d                	j	ffffffffc02087ea <disk0_io+0x40>
ffffffffc020888a:	f05a                	sd	s6,32(sp)
ffffffffc020888c:	a029                	j	ffffffffc0208896 <disk0_io+0xec>
ffffffffc020888e:	000a3603          	ld	a2,0(s4)
ffffffffc0208892:	0124893b          	addw	s2,s1,s2
ffffffffc0208896:	85b2                	mv	a1,a2
ffffffffc0208898:	0038                	addi	a4,sp,8
ffffffffc020889a:	4681                	li	a3,0
ffffffffc020889c:	6611                	lui	a2,0x4
ffffffffc020889e:	8556                	mv	a0,s5
ffffffffc02088a0:	a19fc0ef          	jal	ffffffffc02052b8 <iobuf_move>
ffffffffc02088a4:	67a2                	ld	a5,8(sp)
ffffffffc02088a6:	fff78713          	addi	a4,a5,-1
ffffffffc02088aa:	02877a63          	bgeu	a4,s0,ffffffffc02088de <disk0_io+0x134>
ffffffffc02088ae:	03479713          	slli	a4,a5,0x34
ffffffffc02088b2:	e715                	bnez	a4,ffffffffc02088de <disk0_io+0x134>
ffffffffc02088b4:	83b1                	srli	a5,a5,0xc
ffffffffc02088b6:	0007849b          	sext.w	s1,a5
ffffffffc02088ba:	00349b1b          	slliw	s6,s1,0x3
ffffffffc02088be:	000a3603          	ld	a2,0(s4)
ffffffffc02088c2:	020b1693          	slli	a3,s6,0x20
ffffffffc02088c6:	9281                	srli	a3,a3,0x20
ffffffffc02088c8:	0039159b          	slliw	a1,s2,0x3
ffffffffc02088cc:	4509                	li	a0,2
ffffffffc02088ce:	b02f80ef          	jal	ffffffffc0200bd0 <ide_write_secs>
ffffffffc02088d2:	e151                	bnez	a0,ffffffffc0208956 <disk0_io+0x1ac>
ffffffffc02088d4:	67a2                	ld	a5,8(sp)
ffffffffc02088d6:	8c1d                	sub	s0,s0,a5
ffffffffc02088d8:	f85d                	bnez	s0,ffffffffc020888e <disk0_io+0xe4>
ffffffffc02088da:	7b02                	ld	s6,32(sp)
ffffffffc02088dc:	bf69                	j	ffffffffc0208876 <disk0_io+0xcc>
ffffffffc02088de:	00005697          	auipc	a3,0x5
ffffffffc02088e2:	7a268693          	addi	a3,a3,1954 # ffffffffc020e080 <etext+0x2a86>
ffffffffc02088e6:	00003617          	auipc	a2,0x3
ffffffffc02088ea:	15260613          	addi	a2,a2,338 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02088ee:	05700593          	li	a1,87
ffffffffc02088f2:	00005517          	auipc	a0,0x5
ffffffffc02088f6:	7ce50513          	addi	a0,a0,1998 # ffffffffc020e0c0 <etext+0x2ac6>
ffffffffc02088fa:	fc4e                	sd	s3,56(sp)
ffffffffc02088fc:	ec5e                	sd	s7,24(sp)
ffffffffc02088fe:	e862                	sd	s8,16(sp)
ffffffffc0208900:	b4bf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208904:	6906                	ld	s2,64(sp)
ffffffffc0208906:	5575                	li	a0,-3
ffffffffc0208908:	b5dd                	j	ffffffffc02087ee <disk0_io+0x44>
ffffffffc020890a:	5575                	li	a0,-3
ffffffffc020890c:	b5cd                	j	ffffffffc02087ee <disk0_io+0x44>
ffffffffc020890e:	00006697          	auipc	a3,0x6
ffffffffc0208912:	86a68693          	addi	a3,a3,-1942 # ffffffffc020e178 <etext+0x2b7e>
ffffffffc0208916:	00003617          	auipc	a2,0x3
ffffffffc020891a:	12260613          	addi	a2,a2,290 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020891e:	06200593          	li	a1,98
ffffffffc0208922:	00005517          	auipc	a0,0x5
ffffffffc0208926:	79e50513          	addi	a0,a0,1950 # ffffffffc020e0c0 <etext+0x2ac6>
ffffffffc020892a:	f05a                	sd	s6,32(sp)
ffffffffc020892c:	b1ff70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208930:	88aa                	mv	a7,a0
ffffffffc0208932:	885e                	mv	a6,s7
ffffffffc0208934:	87ce                	mv	a5,s3
ffffffffc0208936:	0039171b          	slliw	a4,s2,0x3
ffffffffc020893a:	86ca                	mv	a3,s2
ffffffffc020893c:	00005617          	auipc	a2,0x5
ffffffffc0208940:	7f460613          	addi	a2,a2,2036 # ffffffffc020e130 <etext+0x2b36>
ffffffffc0208944:	02d00593          	li	a1,45
ffffffffc0208948:	00005517          	auipc	a0,0x5
ffffffffc020894c:	77850513          	addi	a0,a0,1912 # ffffffffc020e0c0 <etext+0x2ac6>
ffffffffc0208950:	f05a                	sd	s6,32(sp)
ffffffffc0208952:	af9f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208956:	88aa                	mv	a7,a0
ffffffffc0208958:	885a                	mv	a6,s6
ffffffffc020895a:	87a6                	mv	a5,s1
ffffffffc020895c:	0039171b          	slliw	a4,s2,0x3
ffffffffc0208960:	86ca                	mv	a3,s2
ffffffffc0208962:	00005617          	auipc	a2,0x5
ffffffffc0208966:	77e60613          	addi	a2,a2,1918 # ffffffffc020e0e0 <etext+0x2ae6>
ffffffffc020896a:	03700593          	li	a1,55
ffffffffc020896e:	00005517          	auipc	a0,0x5
ffffffffc0208972:	75250513          	addi	a0,a0,1874 # ffffffffc020e0c0 <etext+0x2ac6>
ffffffffc0208976:	fc4e                	sd	s3,56(sp)
ffffffffc0208978:	ec5e                	sd	s7,24(sp)
ffffffffc020897a:	e862                	sd	s8,16(sp)
ffffffffc020897c:	acff70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208980 <dev_init_disk0>:
ffffffffc0208980:	1101                	addi	sp,sp,-32
ffffffffc0208982:	ec06                	sd	ra,24(sp)
ffffffffc0208984:	e822                	sd	s0,16(sp)
ffffffffc0208986:	e426                	sd	s1,8(sp)
ffffffffc0208988:	debff0ef          	jal	ffffffffc0208772 <dev_create_inode>
ffffffffc020898c:	c541                	beqz	a0,ffffffffc0208a14 <dev_init_disk0+0x94>
ffffffffc020898e:	4d38                	lw	a4,88(a0)
ffffffffc0208990:	6785                	lui	a5,0x1
ffffffffc0208992:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208996:	842a                	mv	s0,a0
ffffffffc0208998:	6485                	lui	s1,0x1
ffffffffc020899a:	0cf71e63          	bne	a4,a5,ffffffffc0208a76 <dev_init_disk0+0xf6>
ffffffffc020899e:	4509                	li	a0,2
ffffffffc02089a0:	94af80ef          	jal	ffffffffc0200aea <ide_device_valid>
ffffffffc02089a4:	cd4d                	beqz	a0,ffffffffc0208a5e <dev_init_disk0+0xde>
ffffffffc02089a6:	4509                	li	a0,2
ffffffffc02089a8:	966f80ef          	jal	ffffffffc0200b0e <ide_device_size>
ffffffffc02089ac:	00000797          	auipc	a5,0x0
ffffffffc02089b0:	dfa78793          	addi	a5,a5,-518 # ffffffffc02087a6 <disk0_ioctl>
ffffffffc02089b4:	00000617          	auipc	a2,0x0
ffffffffc02089b8:	dea60613          	addi	a2,a2,-534 # ffffffffc020879e <disk0_open>
ffffffffc02089bc:	00000697          	auipc	a3,0x0
ffffffffc02089c0:	de668693          	addi	a3,a3,-538 # ffffffffc02087a2 <disk0_close>
ffffffffc02089c4:	00000717          	auipc	a4,0x0
ffffffffc02089c8:	de670713          	addi	a4,a4,-538 # ffffffffc02087aa <disk0_io>
ffffffffc02089cc:	810d                	srli	a0,a0,0x3
ffffffffc02089ce:	f41c                	sd	a5,40(s0)
ffffffffc02089d0:	e008                	sd	a0,0(s0)
ffffffffc02089d2:	e810                	sd	a2,16(s0)
ffffffffc02089d4:	ec14                	sd	a3,24(s0)
ffffffffc02089d6:	f018                	sd	a4,32(s0)
ffffffffc02089d8:	4585                	li	a1,1
ffffffffc02089da:	0008d517          	auipc	a0,0x8d
ffffffffc02089de:	e6650513          	addi	a0,a0,-410 # ffffffffc0295840 <disk0_sem>
ffffffffc02089e2:	e404                	sd	s1,8(s0)
ffffffffc02089e4:	a2bfb0ef          	jal	ffffffffc020440e <sem_init>
ffffffffc02089e8:	6511                	lui	a0,0x4
ffffffffc02089ea:	e66f90ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc02089ee:	0008e797          	auipc	a5,0x8e
ffffffffc02089f2:	f0a7b523          	sd	a0,-246(a5) # ffffffffc02968f8 <disk0_buffer>
ffffffffc02089f6:	c921                	beqz	a0,ffffffffc0208a46 <dev_init_disk0+0xc6>
ffffffffc02089f8:	85a2                	mv	a1,s0
ffffffffc02089fa:	4605                	li	a2,1
ffffffffc02089fc:	00006517          	auipc	a0,0x6
ffffffffc0208a00:	80c50513          	addi	a0,a0,-2036 # ffffffffc020e208 <etext+0x2c0e>
ffffffffc0208a04:	c26ff0ef          	jal	ffffffffc0207e2a <vfs_add_dev>
ffffffffc0208a08:	e115                	bnez	a0,ffffffffc0208a2c <dev_init_disk0+0xac>
ffffffffc0208a0a:	60e2                	ld	ra,24(sp)
ffffffffc0208a0c:	6442                	ld	s0,16(sp)
ffffffffc0208a0e:	64a2                	ld	s1,8(sp)
ffffffffc0208a10:	6105                	addi	sp,sp,32
ffffffffc0208a12:	8082                	ret
ffffffffc0208a14:	00005617          	auipc	a2,0x5
ffffffffc0208a18:	79460613          	addi	a2,a2,1940 # ffffffffc020e1a8 <etext+0x2bae>
ffffffffc0208a1c:	08700593          	li	a1,135
ffffffffc0208a20:	00005517          	auipc	a0,0x5
ffffffffc0208a24:	6a050513          	addi	a0,a0,1696 # ffffffffc020e0c0 <etext+0x2ac6>
ffffffffc0208a28:	a23f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208a2c:	86aa                	mv	a3,a0
ffffffffc0208a2e:	00005617          	auipc	a2,0x5
ffffffffc0208a32:	7e260613          	addi	a2,a2,2018 # ffffffffc020e210 <etext+0x2c16>
ffffffffc0208a36:	08d00593          	li	a1,141
ffffffffc0208a3a:	00005517          	auipc	a0,0x5
ffffffffc0208a3e:	68650513          	addi	a0,a0,1670 # ffffffffc020e0c0 <etext+0x2ac6>
ffffffffc0208a42:	a09f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208a46:	00005617          	auipc	a2,0x5
ffffffffc0208a4a:	7a260613          	addi	a2,a2,1954 # ffffffffc020e1e8 <etext+0x2bee>
ffffffffc0208a4e:	07f00593          	li	a1,127
ffffffffc0208a52:	00005517          	auipc	a0,0x5
ffffffffc0208a56:	66e50513          	addi	a0,a0,1646 # ffffffffc020e0c0 <etext+0x2ac6>
ffffffffc0208a5a:	9f1f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208a5e:	00005617          	auipc	a2,0x5
ffffffffc0208a62:	76a60613          	addi	a2,a2,1898 # ffffffffc020e1c8 <etext+0x2bce>
ffffffffc0208a66:	07300593          	li	a1,115
ffffffffc0208a6a:	00005517          	auipc	a0,0x5
ffffffffc0208a6e:	65650513          	addi	a0,a0,1622 # ffffffffc020e0c0 <etext+0x2ac6>
ffffffffc0208a72:	9d9f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208a76:	00005697          	auipc	a3,0x5
ffffffffc0208a7a:	2e268693          	addi	a3,a3,738 # ffffffffc020dd58 <etext+0x275e>
ffffffffc0208a7e:	00003617          	auipc	a2,0x3
ffffffffc0208a82:	fba60613          	addi	a2,a2,-70 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0208a86:	08900593          	li	a1,137
ffffffffc0208a8a:	00005517          	auipc	a0,0x5
ffffffffc0208a8e:	63650513          	addi	a0,a0,1590 # ffffffffc020e0c0 <etext+0x2ac6>
ffffffffc0208a92:	9b9f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208a96 <stdin_open>:
ffffffffc0208a96:	e199                	bnez	a1,ffffffffc0208a9c <stdin_open+0x6>
ffffffffc0208a98:	4501                	li	a0,0
ffffffffc0208a9a:	8082                	ret
ffffffffc0208a9c:	5575                	li	a0,-3
ffffffffc0208a9e:	8082                	ret

ffffffffc0208aa0 <stdin_close>:
ffffffffc0208aa0:	4501                	li	a0,0
ffffffffc0208aa2:	8082                	ret

ffffffffc0208aa4 <stdin_ioctl>:
ffffffffc0208aa4:	5575                	li	a0,-3
ffffffffc0208aa6:	8082                	ret

ffffffffc0208aa8 <stdin_io>:
ffffffffc0208aa8:	14061f63          	bnez	a2,ffffffffc0208c06 <stdin_io+0x15e>
ffffffffc0208aac:	7175                	addi	sp,sp,-144
ffffffffc0208aae:	ecd6                	sd	s5,88(sp)
ffffffffc0208ab0:	e8da                	sd	s6,80(sp)
ffffffffc0208ab2:	e4de                	sd	s7,72(sp)
ffffffffc0208ab4:	0185bb03          	ld	s6,24(a1)
ffffffffc0208ab8:	0005bb83          	ld	s7,0(a1)
ffffffffc0208abc:	e506                	sd	ra,136(sp)
ffffffffc0208abe:	e122                	sd	s0,128(sp)
ffffffffc0208ac0:	8aae                	mv	s5,a1
ffffffffc0208ac2:	100027f3          	csrr	a5,sstatus
ffffffffc0208ac6:	8b89                	andi	a5,a5,2
ffffffffc0208ac8:	12079663          	bnez	a5,ffffffffc0208bf4 <stdin_io+0x14c>
ffffffffc0208acc:	4401                	li	s0,0
ffffffffc0208ace:	120b0a63          	beqz	s6,ffffffffc0208c02 <stdin_io+0x15a>
ffffffffc0208ad2:	f8ca                	sd	s2,112(sp)
ffffffffc0208ad4:	0008e917          	auipc	s2,0x8e
ffffffffc0208ad8:	e3490913          	addi	s2,s2,-460 # ffffffffc0296908 <p_rpos>
ffffffffc0208adc:	00093783          	ld	a5,0(s2)
ffffffffc0208ae0:	fca6                	sd	s1,120(sp)
ffffffffc0208ae2:	6705                	lui	a4,0x1
ffffffffc0208ae4:	800004b7          	lui	s1,0x80000
ffffffffc0208ae8:	f4ce                	sd	s3,104(sp)
ffffffffc0208aea:	f0d2                	sd	s4,96(sp)
ffffffffc0208aec:	e0e2                	sd	s8,64(sp)
ffffffffc0208aee:	0491                	addi	s1,s1,4 # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc0208af0:	fff70c13          	addi	s8,a4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0208af4:	4a01                	li	s4,0
ffffffffc0208af6:	0008e997          	auipc	s3,0x8e
ffffffffc0208afa:	e0a98993          	addi	s3,s3,-502 # ffffffffc0296900 <p_wpos>
ffffffffc0208afe:	0009b703          	ld	a4,0(s3)
ffffffffc0208b02:	02e7d763          	bge	a5,a4,ffffffffc0208b30 <stdin_io+0x88>
ffffffffc0208b06:	a045                	j	ffffffffc0208ba6 <stdin_io+0xfe>
ffffffffc0208b08:	fd2fe0ef          	jal	ffffffffc02072da <schedule>
ffffffffc0208b0c:	100027f3          	csrr	a5,sstatus
ffffffffc0208b10:	8b89                	andi	a5,a5,2
ffffffffc0208b12:	4401                	li	s0,0
ffffffffc0208b14:	e3b1                	bnez	a5,ffffffffc0208b58 <stdin_io+0xb0>
ffffffffc0208b16:	0828                	addi	a0,sp,24
ffffffffc0208b18:	991fb0ef          	jal	ffffffffc02044a8 <wait_in_queue>
ffffffffc0208b1c:	e529                	bnez	a0,ffffffffc0208b66 <stdin_io+0xbe>
ffffffffc0208b1e:	5782                	lw	a5,32(sp)
ffffffffc0208b20:	04979d63          	bne	a5,s1,ffffffffc0208b7a <stdin_io+0xd2>
ffffffffc0208b24:	00093783          	ld	a5,0(s2)
ffffffffc0208b28:	0009b703          	ld	a4,0(s3)
ffffffffc0208b2c:	06e7cd63          	blt	a5,a4,ffffffffc0208ba6 <stdin_io+0xfe>
ffffffffc0208b30:	80000637          	lui	a2,0x80000
ffffffffc0208b34:	0611                	addi	a2,a2,4 # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc0208b36:	082c                	addi	a1,sp,24
ffffffffc0208b38:	0008d517          	auipc	a0,0x8d
ffffffffc0208b3c:	d2050513          	addi	a0,a0,-736 # ffffffffc0295858 <__wait_queue>
ffffffffc0208b40:	a95fb0ef          	jal	ffffffffc02045d4 <wait_current_set>
ffffffffc0208b44:	d071                	beqz	s0,ffffffffc0208b08 <stdin_io+0x60>
ffffffffc0208b46:	924f80ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0208b4a:	f90fe0ef          	jal	ffffffffc02072da <schedule>
ffffffffc0208b4e:	100027f3          	csrr	a5,sstatus
ffffffffc0208b52:	8b89                	andi	a5,a5,2
ffffffffc0208b54:	4401                	li	s0,0
ffffffffc0208b56:	d3e1                	beqz	a5,ffffffffc0208b16 <stdin_io+0x6e>
ffffffffc0208b58:	918f80ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0208b5c:	0828                	addi	a0,sp,24
ffffffffc0208b5e:	4405                	li	s0,1
ffffffffc0208b60:	949fb0ef          	jal	ffffffffc02044a8 <wait_in_queue>
ffffffffc0208b64:	dd4d                	beqz	a0,ffffffffc0208b1e <stdin_io+0x76>
ffffffffc0208b66:	082c                	addi	a1,sp,24
ffffffffc0208b68:	0008d517          	auipc	a0,0x8d
ffffffffc0208b6c:	cf050513          	addi	a0,a0,-784 # ffffffffc0295858 <__wait_queue>
ffffffffc0208b70:	8dffb0ef          	jal	ffffffffc020444e <wait_queue_del>
ffffffffc0208b74:	5782                	lw	a5,32(sp)
ffffffffc0208b76:	fa9787e3          	beq	a5,s1,ffffffffc0208b24 <stdin_io+0x7c>
ffffffffc0208b7a:	000a051b          	sext.w	a0,s4
ffffffffc0208b7e:	e42d                	bnez	s0,ffffffffc0208be8 <stdin_io+0x140>
ffffffffc0208b80:	c519                	beqz	a0,ffffffffc0208b8e <stdin_io+0xe6>
ffffffffc0208b82:	018ab783          	ld	a5,24(s5)
ffffffffc0208b86:	414787b3          	sub	a5,a5,s4
ffffffffc0208b8a:	00fabc23          	sd	a5,24(s5)
ffffffffc0208b8e:	74e6                	ld	s1,120(sp)
ffffffffc0208b90:	7946                	ld	s2,112(sp)
ffffffffc0208b92:	79a6                	ld	s3,104(sp)
ffffffffc0208b94:	7a06                	ld	s4,96(sp)
ffffffffc0208b96:	6c06                	ld	s8,64(sp)
ffffffffc0208b98:	60aa                	ld	ra,136(sp)
ffffffffc0208b9a:	640a                	ld	s0,128(sp)
ffffffffc0208b9c:	6ae6                	ld	s5,88(sp)
ffffffffc0208b9e:	6b46                	ld	s6,80(sp)
ffffffffc0208ba0:	6ba6                	ld	s7,72(sp)
ffffffffc0208ba2:	6149                	addi	sp,sp,144
ffffffffc0208ba4:	8082                	ret
ffffffffc0208ba6:	43f7d693          	srai	a3,a5,0x3f
ffffffffc0208baa:	92d1                	srli	a3,a3,0x34
ffffffffc0208bac:	00d78733          	add	a4,a5,a3
ffffffffc0208bb0:	01877733          	and	a4,a4,s8
ffffffffc0208bb4:	8f15                	sub	a4,a4,a3
ffffffffc0208bb6:	0008d697          	auipc	a3,0x8d
ffffffffc0208bba:	cb268693          	addi	a3,a3,-846 # ffffffffc0295868 <stdin_buffer>
ffffffffc0208bbe:	9736                	add	a4,a4,a3
ffffffffc0208bc0:	00074683          	lbu	a3,0(a4)
ffffffffc0208bc4:	0785                	addi	a5,a5,1
ffffffffc0208bc6:	014b8733          	add	a4,s7,s4
ffffffffc0208bca:	001a051b          	addiw	a0,s4,1
ffffffffc0208bce:	00f93023          	sd	a5,0(s2)
ffffffffc0208bd2:	00d70023          	sb	a3,0(a4)
ffffffffc0208bd6:	0a05                	addi	s4,s4,1
ffffffffc0208bd8:	f36a63e3          	bltu	s4,s6,ffffffffc0208afe <stdin_io+0x56>
ffffffffc0208bdc:	d05d                	beqz	s0,ffffffffc0208b82 <stdin_io+0xda>
ffffffffc0208bde:	e42a                	sd	a0,8(sp)
ffffffffc0208be0:	88af80ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0208be4:	6522                	ld	a0,8(sp)
ffffffffc0208be6:	bf71                	j	ffffffffc0208b82 <stdin_io+0xda>
ffffffffc0208be8:	e42a                	sd	a0,8(sp)
ffffffffc0208bea:	880f80ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0208bee:	6522                	ld	a0,8(sp)
ffffffffc0208bf0:	f949                	bnez	a0,ffffffffc0208b82 <stdin_io+0xda>
ffffffffc0208bf2:	bf71                	j	ffffffffc0208b8e <stdin_io+0xe6>
ffffffffc0208bf4:	87cf80ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0208bf8:	4405                	li	s0,1
ffffffffc0208bfa:	ec0b1ce3          	bnez	s6,ffffffffc0208ad2 <stdin_io+0x2a>
ffffffffc0208bfe:	86cf80ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0208c02:	4501                	li	a0,0
ffffffffc0208c04:	bf51                	j	ffffffffc0208b98 <stdin_io+0xf0>
ffffffffc0208c06:	5575                	li	a0,-3
ffffffffc0208c08:	8082                	ret

ffffffffc0208c0a <dev_stdin_write>:
ffffffffc0208c0a:	e111                	bnez	a0,ffffffffc0208c0e <dev_stdin_write+0x4>
ffffffffc0208c0c:	8082                	ret
ffffffffc0208c0e:	1101                	addi	sp,sp,-32
ffffffffc0208c10:	ec06                	sd	ra,24(sp)
ffffffffc0208c12:	e822                	sd	s0,16(sp)
ffffffffc0208c14:	100027f3          	csrr	a5,sstatus
ffffffffc0208c18:	8b89                	andi	a5,a5,2
ffffffffc0208c1a:	4401                	li	s0,0
ffffffffc0208c1c:	e3c1                	bnez	a5,ffffffffc0208c9c <dev_stdin_write+0x92>
ffffffffc0208c1e:	0008e717          	auipc	a4,0x8e
ffffffffc0208c22:	ce273703          	ld	a4,-798(a4) # ffffffffc0296900 <p_wpos>
ffffffffc0208c26:	6585                	lui	a1,0x1
ffffffffc0208c28:	fff58613          	addi	a2,a1,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0208c2c:	43f75693          	srai	a3,a4,0x3f
ffffffffc0208c30:	92d1                	srli	a3,a3,0x34
ffffffffc0208c32:	00d707b3          	add	a5,a4,a3
ffffffffc0208c36:	8ff1                	and	a5,a5,a2
ffffffffc0208c38:	0008e617          	auipc	a2,0x8e
ffffffffc0208c3c:	cd063603          	ld	a2,-816(a2) # ffffffffc0296908 <p_rpos>
ffffffffc0208c40:	8f95                	sub	a5,a5,a3
ffffffffc0208c42:	0008d697          	auipc	a3,0x8d
ffffffffc0208c46:	c2668693          	addi	a3,a3,-986 # ffffffffc0295868 <stdin_buffer>
ffffffffc0208c4a:	97b6                	add	a5,a5,a3
ffffffffc0208c4c:	00a78023          	sb	a0,0(a5)
ffffffffc0208c50:	40c707b3          	sub	a5,a4,a2
ffffffffc0208c54:	00b7d763          	bge	a5,a1,ffffffffc0208c62 <dev_stdin_write+0x58>
ffffffffc0208c58:	0705                	addi	a4,a4,1
ffffffffc0208c5a:	0008e797          	auipc	a5,0x8e
ffffffffc0208c5e:	cae7b323          	sd	a4,-858(a5) # ffffffffc0296900 <p_wpos>
ffffffffc0208c62:	0008d517          	auipc	a0,0x8d
ffffffffc0208c66:	bf650513          	addi	a0,a0,-1034 # ffffffffc0295858 <__wait_queue>
ffffffffc0208c6a:	833fb0ef          	jal	ffffffffc020449c <wait_queue_empty>
ffffffffc0208c6e:	c919                	beqz	a0,ffffffffc0208c84 <dev_stdin_write+0x7a>
ffffffffc0208c70:	e409                	bnez	s0,ffffffffc0208c7a <dev_stdin_write+0x70>
ffffffffc0208c72:	60e2                	ld	ra,24(sp)
ffffffffc0208c74:	6442                	ld	s0,16(sp)
ffffffffc0208c76:	6105                	addi	sp,sp,32
ffffffffc0208c78:	8082                	ret
ffffffffc0208c7a:	6442                	ld	s0,16(sp)
ffffffffc0208c7c:	60e2                	ld	ra,24(sp)
ffffffffc0208c7e:	6105                	addi	sp,sp,32
ffffffffc0208c80:	febf706f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc0208c84:	800005b7          	lui	a1,0x80000
ffffffffc0208c88:	0591                	addi	a1,a1,4 # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc0208c8a:	4605                	li	a2,1
ffffffffc0208c8c:	0008d517          	auipc	a0,0x8d
ffffffffc0208c90:	bcc50513          	addi	a0,a0,-1076 # ffffffffc0295858 <__wait_queue>
ffffffffc0208c94:	871fb0ef          	jal	ffffffffc0204504 <wakeup_queue>
ffffffffc0208c98:	dc69                	beqz	s0,ffffffffc0208c72 <dev_stdin_write+0x68>
ffffffffc0208c9a:	b7c5                	j	ffffffffc0208c7a <dev_stdin_write+0x70>
ffffffffc0208c9c:	e42a                	sd	a0,8(sp)
ffffffffc0208c9e:	fd3f70ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0208ca2:	6522                	ld	a0,8(sp)
ffffffffc0208ca4:	4405                	li	s0,1
ffffffffc0208ca6:	bfa5                	j	ffffffffc0208c1e <dev_stdin_write+0x14>

ffffffffc0208ca8 <dev_init_stdin>:
ffffffffc0208ca8:	1101                	addi	sp,sp,-32
ffffffffc0208caa:	ec06                	sd	ra,24(sp)
ffffffffc0208cac:	ac7ff0ef          	jal	ffffffffc0208772 <dev_create_inode>
ffffffffc0208cb0:	c935                	beqz	a0,ffffffffc0208d24 <dev_init_stdin+0x7c>
ffffffffc0208cb2:	4d38                	lw	a4,88(a0)
ffffffffc0208cb4:	6785                	lui	a5,0x1
ffffffffc0208cb6:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208cba:	08f71e63          	bne	a4,a5,ffffffffc0208d56 <dev_init_stdin+0xae>
ffffffffc0208cbe:	4785                	li	a5,1
ffffffffc0208cc0:	e51c                	sd	a5,8(a0)
ffffffffc0208cc2:	00000797          	auipc	a5,0x0
ffffffffc0208cc6:	dd478793          	addi	a5,a5,-556 # ffffffffc0208a96 <stdin_open>
ffffffffc0208cca:	e91c                	sd	a5,16(a0)
ffffffffc0208ccc:	00000797          	auipc	a5,0x0
ffffffffc0208cd0:	dd478793          	addi	a5,a5,-556 # ffffffffc0208aa0 <stdin_close>
ffffffffc0208cd4:	ed1c                	sd	a5,24(a0)
ffffffffc0208cd6:	00000797          	auipc	a5,0x0
ffffffffc0208cda:	dd278793          	addi	a5,a5,-558 # ffffffffc0208aa8 <stdin_io>
ffffffffc0208cde:	f11c                	sd	a5,32(a0)
ffffffffc0208ce0:	00000797          	auipc	a5,0x0
ffffffffc0208ce4:	dc478793          	addi	a5,a5,-572 # ffffffffc0208aa4 <stdin_ioctl>
ffffffffc0208ce8:	f51c                	sd	a5,40(a0)
ffffffffc0208cea:	00053023          	sd	zero,0(a0)
ffffffffc0208cee:	e42a                	sd	a0,8(sp)
ffffffffc0208cf0:	0008d517          	auipc	a0,0x8d
ffffffffc0208cf4:	b6850513          	addi	a0,a0,-1176 # ffffffffc0295858 <__wait_queue>
ffffffffc0208cf8:	0008e797          	auipc	a5,0x8e
ffffffffc0208cfc:	c007b423          	sd	zero,-1016(a5) # ffffffffc0296900 <p_wpos>
ffffffffc0208d00:	0008e797          	auipc	a5,0x8e
ffffffffc0208d04:	c007b423          	sd	zero,-1016(a5) # ffffffffc0296908 <p_rpos>
ffffffffc0208d08:	f40fb0ef          	jal	ffffffffc0204448 <wait_queue_init>
ffffffffc0208d0c:	65a2                	ld	a1,8(sp)
ffffffffc0208d0e:	4601                	li	a2,0
ffffffffc0208d10:	00005517          	auipc	a0,0x5
ffffffffc0208d14:	56050513          	addi	a0,a0,1376 # ffffffffc020e270 <etext+0x2c76>
ffffffffc0208d18:	912ff0ef          	jal	ffffffffc0207e2a <vfs_add_dev>
ffffffffc0208d1c:	e105                	bnez	a0,ffffffffc0208d3c <dev_init_stdin+0x94>
ffffffffc0208d1e:	60e2                	ld	ra,24(sp)
ffffffffc0208d20:	6105                	addi	sp,sp,32
ffffffffc0208d22:	8082                	ret
ffffffffc0208d24:	00005617          	auipc	a2,0x5
ffffffffc0208d28:	50c60613          	addi	a2,a2,1292 # ffffffffc020e230 <etext+0x2c36>
ffffffffc0208d2c:	07500593          	li	a1,117
ffffffffc0208d30:	00005517          	auipc	a0,0x5
ffffffffc0208d34:	52050513          	addi	a0,a0,1312 # ffffffffc020e250 <etext+0x2c56>
ffffffffc0208d38:	f12f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208d3c:	86aa                	mv	a3,a0
ffffffffc0208d3e:	00005617          	auipc	a2,0x5
ffffffffc0208d42:	53a60613          	addi	a2,a2,1338 # ffffffffc020e278 <etext+0x2c7e>
ffffffffc0208d46:	07b00593          	li	a1,123
ffffffffc0208d4a:	00005517          	auipc	a0,0x5
ffffffffc0208d4e:	50650513          	addi	a0,a0,1286 # ffffffffc020e250 <etext+0x2c56>
ffffffffc0208d52:	ef8f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208d56:	00005697          	auipc	a3,0x5
ffffffffc0208d5a:	00268693          	addi	a3,a3,2 # ffffffffc020dd58 <etext+0x275e>
ffffffffc0208d5e:	00003617          	auipc	a2,0x3
ffffffffc0208d62:	cda60613          	addi	a2,a2,-806 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0208d66:	07700593          	li	a1,119
ffffffffc0208d6a:	00005517          	auipc	a0,0x5
ffffffffc0208d6e:	4e650513          	addi	a0,a0,1254 # ffffffffc020e250 <etext+0x2c56>
ffffffffc0208d72:	ed8f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208d76 <stdout_open>:
ffffffffc0208d76:	4785                	li	a5,1
ffffffffc0208d78:	00f59463          	bne	a1,a5,ffffffffc0208d80 <stdout_open+0xa>
ffffffffc0208d7c:	4501                	li	a0,0
ffffffffc0208d7e:	8082                	ret
ffffffffc0208d80:	5575                	li	a0,-3
ffffffffc0208d82:	8082                	ret

ffffffffc0208d84 <stdout_close>:
ffffffffc0208d84:	4501                	li	a0,0
ffffffffc0208d86:	8082                	ret

ffffffffc0208d88 <stdout_ioctl>:
ffffffffc0208d88:	5575                	li	a0,-3
ffffffffc0208d8a:	8082                	ret

ffffffffc0208d8c <stdout_io>:
ffffffffc0208d8c:	ca15                	beqz	a2,ffffffffc0208dc0 <stdout_io+0x34>
ffffffffc0208d8e:	6d9c                	ld	a5,24(a1)
ffffffffc0208d90:	c795                	beqz	a5,ffffffffc0208dbc <stdout_io+0x30>
ffffffffc0208d92:	1101                	addi	sp,sp,-32
ffffffffc0208d94:	e822                	sd	s0,16(sp)
ffffffffc0208d96:	6180                	ld	s0,0(a1)
ffffffffc0208d98:	e426                	sd	s1,8(sp)
ffffffffc0208d9a:	ec06                	sd	ra,24(sp)
ffffffffc0208d9c:	84ae                	mv	s1,a1
ffffffffc0208d9e:	00044503          	lbu	a0,0(s0)
ffffffffc0208da2:	0405                	addi	s0,s0,1
ffffffffc0208da4:	c3cf70ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc0208da8:	6c9c                	ld	a5,24(s1)
ffffffffc0208daa:	17fd                	addi	a5,a5,-1
ffffffffc0208dac:	ec9c                	sd	a5,24(s1)
ffffffffc0208dae:	fbe5                	bnez	a5,ffffffffc0208d9e <stdout_io+0x12>
ffffffffc0208db0:	60e2                	ld	ra,24(sp)
ffffffffc0208db2:	6442                	ld	s0,16(sp)
ffffffffc0208db4:	64a2                	ld	s1,8(sp)
ffffffffc0208db6:	4501                	li	a0,0
ffffffffc0208db8:	6105                	addi	sp,sp,32
ffffffffc0208dba:	8082                	ret
ffffffffc0208dbc:	4501                	li	a0,0
ffffffffc0208dbe:	8082                	ret
ffffffffc0208dc0:	5575                	li	a0,-3
ffffffffc0208dc2:	8082                	ret

ffffffffc0208dc4 <dev_init_stdout>:
ffffffffc0208dc4:	1141                	addi	sp,sp,-16
ffffffffc0208dc6:	e406                	sd	ra,8(sp)
ffffffffc0208dc8:	9abff0ef          	jal	ffffffffc0208772 <dev_create_inode>
ffffffffc0208dcc:	c939                	beqz	a0,ffffffffc0208e22 <dev_init_stdout+0x5e>
ffffffffc0208dce:	4d38                	lw	a4,88(a0)
ffffffffc0208dd0:	6785                	lui	a5,0x1
ffffffffc0208dd2:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208dd6:	06f71f63          	bne	a4,a5,ffffffffc0208e54 <dev_init_stdout+0x90>
ffffffffc0208dda:	4785                	li	a5,1
ffffffffc0208ddc:	e51c                	sd	a5,8(a0)
ffffffffc0208dde:	00000797          	auipc	a5,0x0
ffffffffc0208de2:	f9878793          	addi	a5,a5,-104 # ffffffffc0208d76 <stdout_open>
ffffffffc0208de6:	e91c                	sd	a5,16(a0)
ffffffffc0208de8:	00000797          	auipc	a5,0x0
ffffffffc0208dec:	f9c78793          	addi	a5,a5,-100 # ffffffffc0208d84 <stdout_close>
ffffffffc0208df0:	ed1c                	sd	a5,24(a0)
ffffffffc0208df2:	00000797          	auipc	a5,0x0
ffffffffc0208df6:	f9a78793          	addi	a5,a5,-102 # ffffffffc0208d8c <stdout_io>
ffffffffc0208dfa:	f11c                	sd	a5,32(a0)
ffffffffc0208dfc:	00000797          	auipc	a5,0x0
ffffffffc0208e00:	f8c78793          	addi	a5,a5,-116 # ffffffffc0208d88 <stdout_ioctl>
ffffffffc0208e04:	f51c                	sd	a5,40(a0)
ffffffffc0208e06:	00053023          	sd	zero,0(a0)
ffffffffc0208e0a:	85aa                	mv	a1,a0
ffffffffc0208e0c:	4601                	li	a2,0
ffffffffc0208e0e:	00005517          	auipc	a0,0x5
ffffffffc0208e12:	4ca50513          	addi	a0,a0,1226 # ffffffffc020e2d8 <etext+0x2cde>
ffffffffc0208e16:	814ff0ef          	jal	ffffffffc0207e2a <vfs_add_dev>
ffffffffc0208e1a:	e105                	bnez	a0,ffffffffc0208e3a <dev_init_stdout+0x76>
ffffffffc0208e1c:	60a2                	ld	ra,8(sp)
ffffffffc0208e1e:	0141                	addi	sp,sp,16
ffffffffc0208e20:	8082                	ret
ffffffffc0208e22:	00005617          	auipc	a2,0x5
ffffffffc0208e26:	47660613          	addi	a2,a2,1142 # ffffffffc020e298 <etext+0x2c9e>
ffffffffc0208e2a:	03700593          	li	a1,55
ffffffffc0208e2e:	00005517          	auipc	a0,0x5
ffffffffc0208e32:	48a50513          	addi	a0,a0,1162 # ffffffffc020e2b8 <etext+0x2cbe>
ffffffffc0208e36:	e14f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208e3a:	86aa                	mv	a3,a0
ffffffffc0208e3c:	00005617          	auipc	a2,0x5
ffffffffc0208e40:	4a460613          	addi	a2,a2,1188 # ffffffffc020e2e0 <etext+0x2ce6>
ffffffffc0208e44:	03d00593          	li	a1,61
ffffffffc0208e48:	00005517          	auipc	a0,0x5
ffffffffc0208e4c:	47050513          	addi	a0,a0,1136 # ffffffffc020e2b8 <etext+0x2cbe>
ffffffffc0208e50:	dfaf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208e54:	00005697          	auipc	a3,0x5
ffffffffc0208e58:	f0468693          	addi	a3,a3,-252 # ffffffffc020dd58 <etext+0x275e>
ffffffffc0208e5c:	00003617          	auipc	a2,0x3
ffffffffc0208e60:	bdc60613          	addi	a2,a2,-1060 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0208e64:	03900593          	li	a1,57
ffffffffc0208e68:	00005517          	auipc	a0,0x5
ffffffffc0208e6c:	45050513          	addi	a0,a0,1104 # ffffffffc020e2b8 <etext+0x2cbe>
ffffffffc0208e70:	ddaf70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208e74 <bitmap_translate.part.0>:
ffffffffc0208e74:	1141                	addi	sp,sp,-16
ffffffffc0208e76:	00005697          	auipc	a3,0x5
ffffffffc0208e7a:	48a68693          	addi	a3,a3,1162 # ffffffffc020e300 <etext+0x2d06>
ffffffffc0208e7e:	00003617          	auipc	a2,0x3
ffffffffc0208e82:	bba60613          	addi	a2,a2,-1094 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0208e86:	04c00593          	li	a1,76
ffffffffc0208e8a:	00005517          	auipc	a0,0x5
ffffffffc0208e8e:	48e50513          	addi	a0,a0,1166 # ffffffffc020e318 <etext+0x2d1e>
ffffffffc0208e92:	e406                	sd	ra,8(sp)
ffffffffc0208e94:	db6f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208e98 <bitmap_create>:
ffffffffc0208e98:	7139                	addi	sp,sp,-64
ffffffffc0208e9a:	fc06                	sd	ra,56(sp)
ffffffffc0208e9c:	f822                	sd	s0,48(sp)
ffffffffc0208e9e:	f426                	sd	s1,40(sp)
ffffffffc0208ea0:	c179                	beqz	a0,ffffffffc0208f66 <bitmap_create+0xce>
ffffffffc0208ea2:	842a                	mv	s0,a0
ffffffffc0208ea4:	4541                	li	a0,16
ffffffffc0208ea6:	9aaf90ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc0208eaa:	84aa                	mv	s1,a0
ffffffffc0208eac:	c555                	beqz	a0,ffffffffc0208f58 <bitmap_create+0xc0>
ffffffffc0208eae:	e852                	sd	s4,16(sp)
ffffffffc0208eb0:	02041a13          	slli	s4,s0,0x20
ffffffffc0208eb4:	020a5a13          	srli	s4,s4,0x20
ffffffffc0208eb8:	f04a                	sd	s2,32(sp)
ffffffffc0208eba:	01fa0913          	addi	s2,s4,31
ffffffffc0208ebe:	ec4e                	sd	s3,24(sp)
ffffffffc0208ec0:	00595993          	srli	s3,s2,0x5
ffffffffc0208ec4:	00299613          	slli	a2,s3,0x2
ffffffffc0208ec8:	8532                	mv	a0,a2
ffffffffc0208eca:	e432                	sd	a2,8(sp)
ffffffffc0208ecc:	984f90ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc0208ed0:	6622                	ld	a2,8(sp)
ffffffffc0208ed2:	cd2d                	beqz	a0,ffffffffc0208f4c <bitmap_create+0xb4>
ffffffffc0208ed4:	c080                	sw	s0,0(s1)
ffffffffc0208ed6:	0134a223          	sw	s3,4(s1)
ffffffffc0208eda:	0ff00593          	li	a1,255
ffffffffc0208ede:	6b4020ef          	jal	ffffffffc020b592 <memset>
ffffffffc0208ee2:	4785                	li	a5,1
ffffffffc0208ee4:	1796                	slli	a5,a5,0x25
ffffffffc0208ee6:	1781                	addi	a5,a5,-32
ffffffffc0208ee8:	e488                	sd	a0,8(s1)
ffffffffc0208eea:	00f97933          	and	s2,s2,a5
ffffffffc0208eee:	052a0663          	beq	s4,s2,ffffffffc0208f3a <bitmap_create+0xa2>
ffffffffc0208ef2:	39fd                	addiw	s3,s3,-1
ffffffffc0208ef4:	0054571b          	srliw	a4,s0,0x5
ffffffffc0208ef8:	0b371963          	bne	a4,s3,ffffffffc0208faa <bitmap_create+0x112>
ffffffffc0208efc:	0057179b          	slliw	a5,a4,0x5
ffffffffc0208f00:	40f407bb          	subw	a5,s0,a5
ffffffffc0208f04:	fff7861b          	addiw	a2,a5,-1
ffffffffc0208f08:	46f9                	li	a3,30
ffffffffc0208f0a:	08c6e063          	bltu	a3,a2,ffffffffc0208f8a <bitmap_create+0xf2>
ffffffffc0208f0e:	070a                	slli	a4,a4,0x2
ffffffffc0208f10:	953a                	add	a0,a0,a4
ffffffffc0208f12:	4118                	lw	a4,0(a0)
ffffffffc0208f14:	4585                	li	a1,1
ffffffffc0208f16:	02000613          	li	a2,32
ffffffffc0208f1a:	00f596bb          	sllw	a3,a1,a5
ffffffffc0208f1e:	2785                	addiw	a5,a5,1
ffffffffc0208f20:	8f35                	xor	a4,a4,a3
ffffffffc0208f22:	fec79ce3          	bne	a5,a2,ffffffffc0208f1a <bitmap_create+0x82>
ffffffffc0208f26:	7442                	ld	s0,48(sp)
ffffffffc0208f28:	70e2                	ld	ra,56(sp)
ffffffffc0208f2a:	c118                	sw	a4,0(a0)
ffffffffc0208f2c:	7902                	ld	s2,32(sp)
ffffffffc0208f2e:	69e2                	ld	s3,24(sp)
ffffffffc0208f30:	6a42                	ld	s4,16(sp)
ffffffffc0208f32:	8526                	mv	a0,s1
ffffffffc0208f34:	74a2                	ld	s1,40(sp)
ffffffffc0208f36:	6121                	addi	sp,sp,64
ffffffffc0208f38:	8082                	ret
ffffffffc0208f3a:	7442                	ld	s0,48(sp)
ffffffffc0208f3c:	70e2                	ld	ra,56(sp)
ffffffffc0208f3e:	7902                	ld	s2,32(sp)
ffffffffc0208f40:	69e2                	ld	s3,24(sp)
ffffffffc0208f42:	6a42                	ld	s4,16(sp)
ffffffffc0208f44:	8526                	mv	a0,s1
ffffffffc0208f46:	74a2                	ld	s1,40(sp)
ffffffffc0208f48:	6121                	addi	sp,sp,64
ffffffffc0208f4a:	8082                	ret
ffffffffc0208f4c:	8526                	mv	a0,s1
ffffffffc0208f4e:	9a8f90ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc0208f52:	7902                	ld	s2,32(sp)
ffffffffc0208f54:	69e2                	ld	s3,24(sp)
ffffffffc0208f56:	6a42                	ld	s4,16(sp)
ffffffffc0208f58:	7442                	ld	s0,48(sp)
ffffffffc0208f5a:	70e2                	ld	ra,56(sp)
ffffffffc0208f5c:	4481                	li	s1,0
ffffffffc0208f5e:	8526                	mv	a0,s1
ffffffffc0208f60:	74a2                	ld	s1,40(sp)
ffffffffc0208f62:	6121                	addi	sp,sp,64
ffffffffc0208f64:	8082                	ret
ffffffffc0208f66:	00005697          	auipc	a3,0x5
ffffffffc0208f6a:	3ca68693          	addi	a3,a3,970 # ffffffffc020e330 <etext+0x2d36>
ffffffffc0208f6e:	00003617          	auipc	a2,0x3
ffffffffc0208f72:	aca60613          	addi	a2,a2,-1334 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0208f76:	45d5                	li	a1,21
ffffffffc0208f78:	00005517          	auipc	a0,0x5
ffffffffc0208f7c:	3a050513          	addi	a0,a0,928 # ffffffffc020e318 <etext+0x2d1e>
ffffffffc0208f80:	f04a                	sd	s2,32(sp)
ffffffffc0208f82:	ec4e                	sd	s3,24(sp)
ffffffffc0208f84:	e852                	sd	s4,16(sp)
ffffffffc0208f86:	cc4f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208f8a:	00005697          	auipc	a3,0x5
ffffffffc0208f8e:	3e668693          	addi	a3,a3,998 # ffffffffc020e370 <etext+0x2d76>
ffffffffc0208f92:	00003617          	auipc	a2,0x3
ffffffffc0208f96:	aa660613          	addi	a2,a2,-1370 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0208f9a:	02b00593          	li	a1,43
ffffffffc0208f9e:	00005517          	auipc	a0,0x5
ffffffffc0208fa2:	37a50513          	addi	a0,a0,890 # ffffffffc020e318 <etext+0x2d1e>
ffffffffc0208fa6:	ca4f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208faa:	00005697          	auipc	a3,0x5
ffffffffc0208fae:	3ae68693          	addi	a3,a3,942 # ffffffffc020e358 <etext+0x2d5e>
ffffffffc0208fb2:	00003617          	auipc	a2,0x3
ffffffffc0208fb6:	a8660613          	addi	a2,a2,-1402 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0208fba:	02a00593          	li	a1,42
ffffffffc0208fbe:	00005517          	auipc	a0,0x5
ffffffffc0208fc2:	35a50513          	addi	a0,a0,858 # ffffffffc020e318 <etext+0x2d1e>
ffffffffc0208fc6:	c84f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208fca <bitmap_alloc>:
ffffffffc0208fca:	4150                	lw	a2,4(a0)
ffffffffc0208fcc:	c229                	beqz	a2,ffffffffc020900e <bitmap_alloc+0x44>
ffffffffc0208fce:	6518                	ld	a4,8(a0)
ffffffffc0208fd0:	4781                	li	a5,0
ffffffffc0208fd2:	a029                	j	ffffffffc0208fdc <bitmap_alloc+0x12>
ffffffffc0208fd4:	2785                	addiw	a5,a5,1
ffffffffc0208fd6:	0711                	addi	a4,a4,4
ffffffffc0208fd8:	02f60b63          	beq	a2,a5,ffffffffc020900e <bitmap_alloc+0x44>
ffffffffc0208fdc:	4314                	lw	a3,0(a4)
ffffffffc0208fde:	dafd                	beqz	a3,ffffffffc0208fd4 <bitmap_alloc+0xa>
ffffffffc0208fe0:	0016f613          	andi	a2,a3,1
ffffffffc0208fe4:	ea29                	bnez	a2,ffffffffc0209036 <bitmap_alloc+0x6c>
ffffffffc0208fe6:	02000893          	li	a7,32
ffffffffc0208fea:	4305                	li	t1,1
ffffffffc0208fec:	2605                	addiw	a2,a2,1
ffffffffc0208fee:	03160263          	beq	a2,a7,ffffffffc0209012 <bitmap_alloc+0x48>
ffffffffc0208ff2:	00c3153b          	sllw	a0,t1,a2
ffffffffc0208ff6:	00a6f833          	and	a6,a3,a0
ffffffffc0208ffa:	fe0809e3          	beqz	a6,ffffffffc0208fec <bitmap_alloc+0x22>
ffffffffc0208ffe:	8ea9                	xor	a3,a3,a0
ffffffffc0209000:	0057979b          	slliw	a5,a5,0x5
ffffffffc0209004:	c314                	sw	a3,0(a4)
ffffffffc0209006:	9fb1                	addw	a5,a5,a2
ffffffffc0209008:	c19c                	sw	a5,0(a1)
ffffffffc020900a:	4501                	li	a0,0
ffffffffc020900c:	8082                	ret
ffffffffc020900e:	5571                	li	a0,-4
ffffffffc0209010:	8082                	ret
ffffffffc0209012:	1141                	addi	sp,sp,-16
ffffffffc0209014:	00005697          	auipc	a3,0x5
ffffffffc0209018:	38468693          	addi	a3,a3,900 # ffffffffc020e398 <etext+0x2d9e>
ffffffffc020901c:	00003617          	auipc	a2,0x3
ffffffffc0209020:	a1c60613          	addi	a2,a2,-1508 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209024:	04300593          	li	a1,67
ffffffffc0209028:	00005517          	auipc	a0,0x5
ffffffffc020902c:	2f050513          	addi	a0,a0,752 # ffffffffc020e318 <etext+0x2d1e>
ffffffffc0209030:	e406                	sd	ra,8(sp)
ffffffffc0209032:	c18f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209036:	8532                	mv	a0,a2
ffffffffc0209038:	4601                	li	a2,0
ffffffffc020903a:	b7d1                	j	ffffffffc0208ffe <bitmap_alloc+0x34>

ffffffffc020903c <bitmap_test>:
ffffffffc020903c:	411c                	lw	a5,0(a0)
ffffffffc020903e:	00f5ff63          	bgeu	a1,a5,ffffffffc020905c <bitmap_test+0x20>
ffffffffc0209042:	651c                	ld	a5,8(a0)
ffffffffc0209044:	0055d71b          	srliw	a4,a1,0x5
ffffffffc0209048:	070a                	slli	a4,a4,0x2
ffffffffc020904a:	97ba                	add	a5,a5,a4
ffffffffc020904c:	439c                	lw	a5,0(a5)
ffffffffc020904e:	4505                	li	a0,1
ffffffffc0209050:	00b5153b          	sllw	a0,a0,a1
ffffffffc0209054:	8d7d                	and	a0,a0,a5
ffffffffc0209056:	1502                	slli	a0,a0,0x20
ffffffffc0209058:	9101                	srli	a0,a0,0x20
ffffffffc020905a:	8082                	ret
ffffffffc020905c:	1141                	addi	sp,sp,-16
ffffffffc020905e:	e406                	sd	ra,8(sp)
ffffffffc0209060:	e15ff0ef          	jal	ffffffffc0208e74 <bitmap_translate.part.0>

ffffffffc0209064 <bitmap_free>:
ffffffffc0209064:	411c                	lw	a5,0(a0)
ffffffffc0209066:	1141                	addi	sp,sp,-16
ffffffffc0209068:	e406                	sd	ra,8(sp)
ffffffffc020906a:	02f5f363          	bgeu	a1,a5,ffffffffc0209090 <bitmap_free+0x2c>
ffffffffc020906e:	651c                	ld	a5,8(a0)
ffffffffc0209070:	0055d71b          	srliw	a4,a1,0x5
ffffffffc0209074:	070a                	slli	a4,a4,0x2
ffffffffc0209076:	97ba                	add	a5,a5,a4
ffffffffc0209078:	4394                	lw	a3,0(a5)
ffffffffc020907a:	4705                	li	a4,1
ffffffffc020907c:	00b715bb          	sllw	a1,a4,a1
ffffffffc0209080:	00b6f733          	and	a4,a3,a1
ffffffffc0209084:	eb01                	bnez	a4,ffffffffc0209094 <bitmap_free+0x30>
ffffffffc0209086:	60a2                	ld	ra,8(sp)
ffffffffc0209088:	8ecd                	or	a3,a3,a1
ffffffffc020908a:	c394                	sw	a3,0(a5)
ffffffffc020908c:	0141                	addi	sp,sp,16
ffffffffc020908e:	8082                	ret
ffffffffc0209090:	de5ff0ef          	jal	ffffffffc0208e74 <bitmap_translate.part.0>
ffffffffc0209094:	00005697          	auipc	a3,0x5
ffffffffc0209098:	30c68693          	addi	a3,a3,780 # ffffffffc020e3a0 <etext+0x2da6>
ffffffffc020909c:	00003617          	auipc	a2,0x3
ffffffffc02090a0:	99c60613          	addi	a2,a2,-1636 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02090a4:	05f00593          	li	a1,95
ffffffffc02090a8:	00005517          	auipc	a0,0x5
ffffffffc02090ac:	27050513          	addi	a0,a0,624 # ffffffffc020e318 <etext+0x2d1e>
ffffffffc02090b0:	b9af70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02090b4 <bitmap_destroy>:
ffffffffc02090b4:	1141                	addi	sp,sp,-16
ffffffffc02090b6:	e022                	sd	s0,0(sp)
ffffffffc02090b8:	842a                	mv	s0,a0
ffffffffc02090ba:	6508                	ld	a0,8(a0)
ffffffffc02090bc:	e406                	sd	ra,8(sp)
ffffffffc02090be:	838f90ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc02090c2:	8522                	mv	a0,s0
ffffffffc02090c4:	6402                	ld	s0,0(sp)
ffffffffc02090c6:	60a2                	ld	ra,8(sp)
ffffffffc02090c8:	0141                	addi	sp,sp,16
ffffffffc02090ca:	82cf906f          	j	ffffffffc02020f6 <kfree>

ffffffffc02090ce <bitmap_getdata>:
ffffffffc02090ce:	c589                	beqz	a1,ffffffffc02090d8 <bitmap_getdata+0xa>
ffffffffc02090d0:	00456783          	lwu	a5,4(a0)
ffffffffc02090d4:	078a                	slli	a5,a5,0x2
ffffffffc02090d6:	e19c                	sd	a5,0(a1)
ffffffffc02090d8:	6508                	ld	a0,8(a0)
ffffffffc02090da:	8082                	ret

ffffffffc02090dc <sfs_init>:
ffffffffc02090dc:	1141                	addi	sp,sp,-16
ffffffffc02090de:	00005517          	auipc	a0,0x5
ffffffffc02090e2:	12a50513          	addi	a0,a0,298 # ffffffffc020e208 <etext+0x2c0e>
ffffffffc02090e6:	e406                	sd	ra,8(sp)
ffffffffc02090e8:	576000ef          	jal	ffffffffc020965e <sfs_mount>
ffffffffc02090ec:	e501                	bnez	a0,ffffffffc02090f4 <sfs_init+0x18>
ffffffffc02090ee:	60a2                	ld	ra,8(sp)
ffffffffc02090f0:	0141                	addi	sp,sp,16
ffffffffc02090f2:	8082                	ret
ffffffffc02090f4:	86aa                	mv	a3,a0
ffffffffc02090f6:	00005617          	auipc	a2,0x5
ffffffffc02090fa:	2ba60613          	addi	a2,a2,698 # ffffffffc020e3b0 <etext+0x2db6>
ffffffffc02090fe:	45c1                	li	a1,16
ffffffffc0209100:	00005517          	auipc	a0,0x5
ffffffffc0209104:	2d050513          	addi	a0,a0,720 # ffffffffc020e3d0 <etext+0x2dd6>
ffffffffc0209108:	b42f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc020910c <sfs_unmount>:
ffffffffc020910c:	1141                	addi	sp,sp,-16
ffffffffc020910e:	e406                	sd	ra,8(sp)
ffffffffc0209110:	e022                	sd	s0,0(sp)
ffffffffc0209112:	cd1d                	beqz	a0,ffffffffc0209150 <sfs_unmount+0x44>
ffffffffc0209114:	0b052783          	lw	a5,176(a0)
ffffffffc0209118:	842a                	mv	s0,a0
ffffffffc020911a:	eb9d                	bnez	a5,ffffffffc0209150 <sfs_unmount+0x44>
ffffffffc020911c:	7158                	ld	a4,160(a0)
ffffffffc020911e:	09850793          	addi	a5,a0,152
ffffffffc0209122:	02f71563          	bne	a4,a5,ffffffffc020914c <sfs_unmount+0x40>
ffffffffc0209126:	613c                	ld	a5,64(a0)
ffffffffc0209128:	e7a1                	bnez	a5,ffffffffc0209170 <sfs_unmount+0x64>
ffffffffc020912a:	7d08                	ld	a0,56(a0)
ffffffffc020912c:	f89ff0ef          	jal	ffffffffc02090b4 <bitmap_destroy>
ffffffffc0209130:	6428                	ld	a0,72(s0)
ffffffffc0209132:	fc5f80ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc0209136:	7448                	ld	a0,168(s0)
ffffffffc0209138:	fbff80ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc020913c:	8522                	mv	a0,s0
ffffffffc020913e:	fb9f80ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc0209142:	4501                	li	a0,0
ffffffffc0209144:	60a2                	ld	ra,8(sp)
ffffffffc0209146:	6402                	ld	s0,0(sp)
ffffffffc0209148:	0141                	addi	sp,sp,16
ffffffffc020914a:	8082                	ret
ffffffffc020914c:	5545                	li	a0,-15
ffffffffc020914e:	bfdd                	j	ffffffffc0209144 <sfs_unmount+0x38>
ffffffffc0209150:	00005697          	auipc	a3,0x5
ffffffffc0209154:	29868693          	addi	a3,a3,664 # ffffffffc020e3e8 <etext+0x2dee>
ffffffffc0209158:	00003617          	auipc	a2,0x3
ffffffffc020915c:	8e060613          	addi	a2,a2,-1824 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209160:	04100593          	li	a1,65
ffffffffc0209164:	00005517          	auipc	a0,0x5
ffffffffc0209168:	2b450513          	addi	a0,a0,692 # ffffffffc020e418 <etext+0x2e1e>
ffffffffc020916c:	adef70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209170:	00005697          	auipc	a3,0x5
ffffffffc0209174:	2c068693          	addi	a3,a3,704 # ffffffffc020e430 <etext+0x2e36>
ffffffffc0209178:	00003617          	auipc	a2,0x3
ffffffffc020917c:	8c060613          	addi	a2,a2,-1856 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209180:	04500593          	li	a1,69
ffffffffc0209184:	00005517          	auipc	a0,0x5
ffffffffc0209188:	29450513          	addi	a0,a0,660 # ffffffffc020e418 <etext+0x2e1e>
ffffffffc020918c:	abef70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209190 <sfs_cleanup>:
ffffffffc0209190:	1101                	addi	sp,sp,-32
ffffffffc0209192:	ec06                	sd	ra,24(sp)
ffffffffc0209194:	e426                	sd	s1,8(sp)
ffffffffc0209196:	c13d                	beqz	a0,ffffffffc02091fc <sfs_cleanup+0x6c>
ffffffffc0209198:	0b052783          	lw	a5,176(a0)
ffffffffc020919c:	84aa                	mv	s1,a0
ffffffffc020919e:	efb9                	bnez	a5,ffffffffc02091fc <sfs_cleanup+0x6c>
ffffffffc02091a0:	4158                	lw	a4,4(a0)
ffffffffc02091a2:	4514                	lw	a3,8(a0)
ffffffffc02091a4:	00c50593          	addi	a1,a0,12
ffffffffc02091a8:	00005517          	auipc	a0,0x5
ffffffffc02091ac:	2a050513          	addi	a0,a0,672 # ffffffffc020e448 <etext+0x2e4e>
ffffffffc02091b0:	40d7063b          	subw	a2,a4,a3
ffffffffc02091b4:	e822                	sd	s0,16(sp)
ffffffffc02091b6:	ff1f60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02091ba:	02000413          	li	s0,32
ffffffffc02091be:	a019                	j	ffffffffc02091c4 <sfs_cleanup+0x34>
ffffffffc02091c0:	347d                	addiw	s0,s0,-1
ffffffffc02091c2:	c811                	beqz	s0,ffffffffc02091d6 <sfs_cleanup+0x46>
ffffffffc02091c4:	7cdc                	ld	a5,184(s1)
ffffffffc02091c6:	8526                	mv	a0,s1
ffffffffc02091c8:	9782                	jalr	a5
ffffffffc02091ca:	f97d                	bnez	a0,ffffffffc02091c0 <sfs_cleanup+0x30>
ffffffffc02091cc:	6442                	ld	s0,16(sp)
ffffffffc02091ce:	60e2                	ld	ra,24(sp)
ffffffffc02091d0:	64a2                	ld	s1,8(sp)
ffffffffc02091d2:	6105                	addi	sp,sp,32
ffffffffc02091d4:	8082                	ret
ffffffffc02091d6:	6442                	ld	s0,16(sp)
ffffffffc02091d8:	60e2                	ld	ra,24(sp)
ffffffffc02091da:	00c48693          	addi	a3,s1,12
ffffffffc02091de:	64a2                	ld	s1,8(sp)
ffffffffc02091e0:	872a                	mv	a4,a0
ffffffffc02091e2:	00005617          	auipc	a2,0x5
ffffffffc02091e6:	28660613          	addi	a2,a2,646 # ffffffffc020e468 <etext+0x2e6e>
ffffffffc02091ea:	05f00593          	li	a1,95
ffffffffc02091ee:	00005517          	auipc	a0,0x5
ffffffffc02091f2:	22a50513          	addi	a0,a0,554 # ffffffffc020e418 <etext+0x2e1e>
ffffffffc02091f6:	6105                	addi	sp,sp,32
ffffffffc02091f8:	abcf706f          	j	ffffffffc02004b4 <__warn>
ffffffffc02091fc:	00005697          	auipc	a3,0x5
ffffffffc0209200:	1ec68693          	addi	a3,a3,492 # ffffffffc020e3e8 <etext+0x2dee>
ffffffffc0209204:	00003617          	auipc	a2,0x3
ffffffffc0209208:	83460613          	addi	a2,a2,-1996 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020920c:	05400593          	li	a1,84
ffffffffc0209210:	00005517          	auipc	a0,0x5
ffffffffc0209214:	20850513          	addi	a0,a0,520 # ffffffffc020e418 <etext+0x2e1e>
ffffffffc0209218:	e822                	sd	s0,16(sp)
ffffffffc020921a:	e04a                	sd	s2,0(sp)
ffffffffc020921c:	a2ef70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209220 <sfs_sync>:
ffffffffc0209220:	7179                	addi	sp,sp,-48
ffffffffc0209222:	f406                	sd	ra,40(sp)
ffffffffc0209224:	e44e                	sd	s3,8(sp)
ffffffffc0209226:	c94d                	beqz	a0,ffffffffc02092d8 <sfs_sync+0xb8>
ffffffffc0209228:	0b052783          	lw	a5,176(a0)
ffffffffc020922c:	89aa                	mv	s3,a0
ffffffffc020922e:	e7cd                	bnez	a5,ffffffffc02092d8 <sfs_sync+0xb8>
ffffffffc0209230:	f022                	sd	s0,32(sp)
ffffffffc0209232:	e84a                	sd	s2,16(sp)
ffffffffc0209234:	603010ef          	jal	ffffffffc020b036 <lock_sfs_fs>
ffffffffc0209238:	0a09b403          	ld	s0,160(s3)
ffffffffc020923c:	09898913          	addi	s2,s3,152
ffffffffc0209240:	02890663          	beq	s2,s0,ffffffffc020926c <sfs_sync+0x4c>
ffffffffc0209244:	7c1c                	ld	a5,56(s0)
ffffffffc0209246:	cbad                	beqz	a5,ffffffffc02092b8 <sfs_sync+0x98>
ffffffffc0209248:	7b9c                	ld	a5,48(a5)
ffffffffc020924a:	c7bd                	beqz	a5,ffffffffc02092b8 <sfs_sync+0x98>
ffffffffc020924c:	fc840513          	addi	a0,s0,-56
ffffffffc0209250:	00004597          	auipc	a1,0x4
ffffffffc0209254:	03058593          	addi	a1,a1,48 # ffffffffc020d280 <etext+0x1c86>
ffffffffc0209258:	decfe0ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc020925c:	7c1c                	ld	a5,56(s0)
ffffffffc020925e:	fc840513          	addi	a0,s0,-56
ffffffffc0209262:	7b9c                	ld	a5,48(a5)
ffffffffc0209264:	9782                	jalr	a5
ffffffffc0209266:	6400                	ld	s0,8(s0)
ffffffffc0209268:	fc891ee3          	bne	s2,s0,ffffffffc0209244 <sfs_sync+0x24>
ffffffffc020926c:	854e                	mv	a0,s3
ffffffffc020926e:	5d9010ef          	jal	ffffffffc020b046 <unlock_sfs_fs>
ffffffffc0209272:	0409b783          	ld	a5,64(s3)
ffffffffc0209276:	4501                	li	a0,0
ffffffffc0209278:	e799                	bnez	a5,ffffffffc0209286 <sfs_sync+0x66>
ffffffffc020927a:	7402                	ld	s0,32(sp)
ffffffffc020927c:	70a2                	ld	ra,40(sp)
ffffffffc020927e:	6942                	ld	s2,16(sp)
ffffffffc0209280:	69a2                	ld	s3,8(sp)
ffffffffc0209282:	6145                	addi	sp,sp,48
ffffffffc0209284:	8082                	ret
ffffffffc0209286:	0409b023          	sd	zero,64(s3)
ffffffffc020928a:	854e                	mv	a0,s3
ffffffffc020928c:	48b010ef          	jal	ffffffffc020af16 <sfs_sync_super>
ffffffffc0209290:	c911                	beqz	a0,ffffffffc02092a4 <sfs_sync+0x84>
ffffffffc0209292:	7402                	ld	s0,32(sp)
ffffffffc0209294:	70a2                	ld	ra,40(sp)
ffffffffc0209296:	4785                	li	a5,1
ffffffffc0209298:	04f9b023          	sd	a5,64(s3)
ffffffffc020929c:	6942                	ld	s2,16(sp)
ffffffffc020929e:	69a2                	ld	s3,8(sp)
ffffffffc02092a0:	6145                	addi	sp,sp,48
ffffffffc02092a2:	8082                	ret
ffffffffc02092a4:	854e                	mv	a0,s3
ffffffffc02092a6:	4b7010ef          	jal	ffffffffc020af5c <sfs_sync_freemap>
ffffffffc02092aa:	f565                	bnez	a0,ffffffffc0209292 <sfs_sync+0x72>
ffffffffc02092ac:	7402                	ld	s0,32(sp)
ffffffffc02092ae:	70a2                	ld	ra,40(sp)
ffffffffc02092b0:	6942                	ld	s2,16(sp)
ffffffffc02092b2:	69a2                	ld	s3,8(sp)
ffffffffc02092b4:	6145                	addi	sp,sp,48
ffffffffc02092b6:	8082                	ret
ffffffffc02092b8:	00004697          	auipc	a3,0x4
ffffffffc02092bc:	f7868693          	addi	a3,a3,-136 # ffffffffc020d230 <etext+0x1c36>
ffffffffc02092c0:	00002617          	auipc	a2,0x2
ffffffffc02092c4:	77860613          	addi	a2,a2,1912 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02092c8:	45ed                	li	a1,27
ffffffffc02092ca:	00005517          	auipc	a0,0x5
ffffffffc02092ce:	14e50513          	addi	a0,a0,334 # ffffffffc020e418 <etext+0x2e1e>
ffffffffc02092d2:	ec26                	sd	s1,24(sp)
ffffffffc02092d4:	976f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc02092d8:	00005697          	auipc	a3,0x5
ffffffffc02092dc:	11068693          	addi	a3,a3,272 # ffffffffc020e3e8 <etext+0x2dee>
ffffffffc02092e0:	00002617          	auipc	a2,0x2
ffffffffc02092e4:	75860613          	addi	a2,a2,1880 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02092e8:	45d5                	li	a1,21
ffffffffc02092ea:	00005517          	auipc	a0,0x5
ffffffffc02092ee:	12e50513          	addi	a0,a0,302 # ffffffffc020e418 <etext+0x2e1e>
ffffffffc02092f2:	f022                	sd	s0,32(sp)
ffffffffc02092f4:	ec26                	sd	s1,24(sp)
ffffffffc02092f6:	e84a                	sd	s2,16(sp)
ffffffffc02092f8:	952f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02092fc <sfs_get_root>:
ffffffffc02092fc:	1101                	addi	sp,sp,-32
ffffffffc02092fe:	ec06                	sd	ra,24(sp)
ffffffffc0209300:	cd09                	beqz	a0,ffffffffc020931a <sfs_get_root+0x1e>
ffffffffc0209302:	0b052783          	lw	a5,176(a0)
ffffffffc0209306:	eb91                	bnez	a5,ffffffffc020931a <sfs_get_root+0x1e>
ffffffffc0209308:	4605                	li	a2,1
ffffffffc020930a:	002c                	addi	a1,sp,8
ffffffffc020930c:	368010ef          	jal	ffffffffc020a674 <sfs_load_inode>
ffffffffc0209310:	e50d                	bnez	a0,ffffffffc020933a <sfs_get_root+0x3e>
ffffffffc0209312:	60e2                	ld	ra,24(sp)
ffffffffc0209314:	6522                	ld	a0,8(sp)
ffffffffc0209316:	6105                	addi	sp,sp,32
ffffffffc0209318:	8082                	ret
ffffffffc020931a:	00005697          	auipc	a3,0x5
ffffffffc020931e:	0ce68693          	addi	a3,a3,206 # ffffffffc020e3e8 <etext+0x2dee>
ffffffffc0209322:	00002617          	auipc	a2,0x2
ffffffffc0209326:	71660613          	addi	a2,a2,1814 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020932a:	03600593          	li	a1,54
ffffffffc020932e:	00005517          	auipc	a0,0x5
ffffffffc0209332:	0ea50513          	addi	a0,a0,234 # ffffffffc020e418 <etext+0x2e1e>
ffffffffc0209336:	914f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020933a:	86aa                	mv	a3,a0
ffffffffc020933c:	00005617          	auipc	a2,0x5
ffffffffc0209340:	14c60613          	addi	a2,a2,332 # ffffffffc020e488 <etext+0x2e8e>
ffffffffc0209344:	03700593          	li	a1,55
ffffffffc0209348:	00005517          	auipc	a0,0x5
ffffffffc020934c:	0d050513          	addi	a0,a0,208 # ffffffffc020e418 <etext+0x2e1e>
ffffffffc0209350:	8faf70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209354 <sfs_do_mount>:
ffffffffc0209354:	7171                	addi	sp,sp,-176
ffffffffc0209356:	e54e                	sd	s3,136(sp)
ffffffffc0209358:	00853983          	ld	s3,8(a0)
ffffffffc020935c:	f506                	sd	ra,168(sp)
ffffffffc020935e:	6785                	lui	a5,0x1
ffffffffc0209360:	26f99a63          	bne	s3,a5,ffffffffc02095d4 <sfs_do_mount+0x280>
ffffffffc0209364:	ed26                	sd	s1,152(sp)
ffffffffc0209366:	84aa                	mv	s1,a0
ffffffffc0209368:	4501                	li	a0,0
ffffffffc020936a:	f122                	sd	s0,160(sp)
ffffffffc020936c:	f4de                	sd	s7,104(sp)
ffffffffc020936e:	8bae                	mv	s7,a1
ffffffffc0209370:	ec0fe0ef          	jal	ffffffffc0207a30 <__alloc_fs>
ffffffffc0209374:	842a                	mv	s0,a0
ffffffffc0209376:	26050663          	beqz	a0,ffffffffc02095e2 <sfs_do_mount+0x28e>
ffffffffc020937a:	e152                	sd	s4,128(sp)
ffffffffc020937c:	0b052a03          	lw	s4,176(a0)
ffffffffc0209380:	e94a                	sd	s2,144(sp)
ffffffffc0209382:	280a1763          	bnez	s4,ffffffffc0209610 <sfs_do_mount+0x2bc>
ffffffffc0209386:	f904                	sd	s1,48(a0)
ffffffffc0209388:	854e                	mv	a0,s3
ffffffffc020938a:	cc7f80ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc020938e:	e428                	sd	a0,72(s0)
ffffffffc0209390:	892a                	mv	s2,a0
ffffffffc0209392:	16050863          	beqz	a0,ffffffffc0209502 <sfs_do_mount+0x1ae>
ffffffffc0209396:	864e                	mv	a2,s3
ffffffffc0209398:	4681                	li	a3,0
ffffffffc020939a:	85ca                	mv	a1,s2
ffffffffc020939c:	1008                	addi	a0,sp,32
ffffffffc020939e:	f11fb0ef          	jal	ffffffffc02052ae <iobuf_init>
ffffffffc02093a2:	709c                	ld	a5,32(s1)
ffffffffc02093a4:	85aa                	mv	a1,a0
ffffffffc02093a6:	4601                	li	a2,0
ffffffffc02093a8:	8526                	mv	a0,s1
ffffffffc02093aa:	9782                	jalr	a5
ffffffffc02093ac:	89aa                	mv	s3,a0
ffffffffc02093ae:	12051a63          	bnez	a0,ffffffffc02094e2 <sfs_do_mount+0x18e>
ffffffffc02093b2:	00092583          	lw	a1,0(s2)
ffffffffc02093b6:	2f8dc637          	lui	a2,0x2f8dc
ffffffffc02093ba:	e2a60613          	addi	a2,a2,-470 # 2f8dbe2a <_binary_bin_sfs_img_size+0x2f866b2a>
ffffffffc02093be:	14c59d63          	bne	a1,a2,ffffffffc0209518 <sfs_do_mount+0x1c4>
ffffffffc02093c2:	00492783          	lw	a5,4(s2)
ffffffffc02093c6:	6090                	ld	a2,0(s1)
ffffffffc02093c8:	02079713          	slli	a4,a5,0x20
ffffffffc02093cc:	9301                	srli	a4,a4,0x20
ffffffffc02093ce:	12e66c63          	bltu	a2,a4,ffffffffc0209506 <sfs_do_mount+0x1b2>
ffffffffc02093d2:	e4ee                	sd	s11,72(sp)
ffffffffc02093d4:	01892503          	lw	a0,24(s2)
ffffffffc02093d8:	00892e03          	lw	t3,8(s2)
ffffffffc02093dc:	00c92303          	lw	t1,12(s2)
ffffffffc02093e0:	01092883          	lw	a7,16(s2)
ffffffffc02093e4:	01492803          	lw	a6,20(s2)
ffffffffc02093e8:	01c92603          	lw	a2,28(s2)
ffffffffc02093ec:	02092683          	lw	a3,32(s2)
ffffffffc02093f0:	02492703          	lw	a4,36(s2)
ffffffffc02093f4:	020905a3          	sb	zero,43(s2)
ffffffffc02093f8:	cc08                	sw	a0,24(s0)
ffffffffc02093fa:	01c42423          	sw	t3,8(s0)
ffffffffc02093fe:	00642623          	sw	t1,12(s0)
ffffffffc0209402:	01142823          	sw	a7,16(s0)
ffffffffc0209406:	01042a23          	sw	a6,20(s0)
ffffffffc020940a:	cc50                	sw	a2,28(s0)
ffffffffc020940c:	d014                	sw	a3,32(s0)
ffffffffc020940e:	d058                	sw	a4,36(s0)
ffffffffc0209410:	c00c                	sw	a1,0(s0)
ffffffffc0209412:	c05c                	sw	a5,4(s0)
ffffffffc0209414:	02892783          	lw	a5,40(s2)
ffffffffc0209418:	6511                	lui	a0,0x4
ffffffffc020941a:	d41c                	sw	a5,40(s0)
ffffffffc020941c:	c35f80ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc0209420:	f448                	sd	a0,168(s0)
ffffffffc0209422:	87aa                	mv	a5,a0
ffffffffc0209424:	8daa                	mv	s11,a0
ffffffffc0209426:	1a050963          	beqz	a0,ffffffffc02095d8 <sfs_do_mount+0x284>
ffffffffc020942a:	6711                	lui	a4,0x4
ffffffffc020942c:	fcd6                	sd	s5,120(sp)
ffffffffc020942e:	ece6                	sd	s9,88(sp)
ffffffffc0209430:	e8ea                	sd	s10,80(sp)
ffffffffc0209432:	972a                	add	a4,a4,a0
ffffffffc0209434:	e79c                	sd	a5,8(a5)
ffffffffc0209436:	e39c                	sd	a5,0(a5)
ffffffffc0209438:	07c1                	addi	a5,a5,16 # 1010 <_binary_bin_swap_img_size-0x6cf0>
ffffffffc020943a:	fee79de3          	bne	a5,a4,ffffffffc0209434 <sfs_do_mount+0xe0>
ffffffffc020943e:	00496783          	lwu	a5,4(s2)
ffffffffc0209442:	6721                	lui	a4,0x8
ffffffffc0209444:	fff70a93          	addi	s5,a4,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc0209448:	97d6                	add	a5,a5,s5
ffffffffc020944a:	7761                	lui	a4,0xffff8
ffffffffc020944c:	8ff9                	and	a5,a5,a4
ffffffffc020944e:	0007851b          	sext.w	a0,a5
ffffffffc0209452:	00078c9b          	sext.w	s9,a5
ffffffffc0209456:	a43ff0ef          	jal	ffffffffc0208e98 <bitmap_create>
ffffffffc020945a:	fc08                	sd	a0,56(s0)
ffffffffc020945c:	8d2a                	mv	s10,a0
ffffffffc020945e:	16050963          	beqz	a0,ffffffffc02095d0 <sfs_do_mount+0x27c>
ffffffffc0209462:	00492783          	lw	a5,4(s2)
ffffffffc0209466:	082c                	addi	a1,sp,24
ffffffffc0209468:	e43e                	sd	a5,8(sp)
ffffffffc020946a:	c65ff0ef          	jal	ffffffffc02090ce <bitmap_getdata>
ffffffffc020946e:	16050f63          	beqz	a0,ffffffffc02095ec <sfs_do_mount+0x298>
ffffffffc0209472:	00816783          	lwu	a5,8(sp)
ffffffffc0209476:	66e2                	ld	a3,24(sp)
ffffffffc0209478:	97d6                	add	a5,a5,s5
ffffffffc020947a:	83bd                	srli	a5,a5,0xf
ffffffffc020947c:	00c7971b          	slliw	a4,a5,0xc
ffffffffc0209480:	1702                	slli	a4,a4,0x20
ffffffffc0209482:	9301                	srli	a4,a4,0x20
ffffffffc0209484:	16d71463          	bne	a4,a3,ffffffffc02095ec <sfs_do_mount+0x298>
ffffffffc0209488:	f0e2                	sd	s8,96(sp)
ffffffffc020948a:	00c79713          	slli	a4,a5,0xc
ffffffffc020948e:	00e50c33          	add	s8,a0,a4
ffffffffc0209492:	8aaa                	mv	s5,a0
ffffffffc0209494:	cbd9                	beqz	a5,ffffffffc020952a <sfs_do_mount+0x1d6>
ffffffffc0209496:	6789                	lui	a5,0x2
ffffffffc0209498:	f8da                	sd	s6,112(sp)
ffffffffc020949a:	40a78b3b          	subw	s6,a5,a0
ffffffffc020949e:	a029                	j	ffffffffc02094a8 <sfs_do_mount+0x154>
ffffffffc02094a0:	6785                	lui	a5,0x1
ffffffffc02094a2:	9abe                	add	s5,s5,a5
ffffffffc02094a4:	098a8263          	beq	s5,s8,ffffffffc0209528 <sfs_do_mount+0x1d4>
ffffffffc02094a8:	015b06bb          	addw	a3,s6,s5
ffffffffc02094ac:	1682                	slli	a3,a3,0x20
ffffffffc02094ae:	6605                	lui	a2,0x1
ffffffffc02094b0:	85d6                	mv	a1,s5
ffffffffc02094b2:	9281                	srli	a3,a3,0x20
ffffffffc02094b4:	1008                	addi	a0,sp,32
ffffffffc02094b6:	df9fb0ef          	jal	ffffffffc02052ae <iobuf_init>
ffffffffc02094ba:	709c                	ld	a5,32(s1)
ffffffffc02094bc:	85aa                	mv	a1,a0
ffffffffc02094be:	4601                	li	a2,0
ffffffffc02094c0:	8526                	mv	a0,s1
ffffffffc02094c2:	9782                	jalr	a5
ffffffffc02094c4:	dd71                	beqz	a0,ffffffffc02094a0 <sfs_do_mount+0x14c>
ffffffffc02094c6:	e42a                	sd	a0,8(sp)
ffffffffc02094c8:	856a                	mv	a0,s10
ffffffffc02094ca:	bebff0ef          	jal	ffffffffc02090b4 <bitmap_destroy>
ffffffffc02094ce:	69a2                	ld	s3,8(sp)
ffffffffc02094d0:	7b46                	ld	s6,112(sp)
ffffffffc02094d2:	7c06                	ld	s8,96(sp)
ffffffffc02094d4:	856e                	mv	a0,s11
ffffffffc02094d6:	c21f80ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc02094da:	7ae6                	ld	s5,120(sp)
ffffffffc02094dc:	6ce6                	ld	s9,88(sp)
ffffffffc02094de:	6d46                	ld	s10,80(sp)
ffffffffc02094e0:	6da6                	ld	s11,72(sp)
ffffffffc02094e2:	854a                	mv	a0,s2
ffffffffc02094e4:	c13f80ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc02094e8:	8522                	mv	a0,s0
ffffffffc02094ea:	c0df80ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc02094ee:	740a                	ld	s0,160(sp)
ffffffffc02094f0:	64ea                	ld	s1,152(sp)
ffffffffc02094f2:	694a                	ld	s2,144(sp)
ffffffffc02094f4:	6a0a                	ld	s4,128(sp)
ffffffffc02094f6:	7ba6                	ld	s7,104(sp)
ffffffffc02094f8:	70aa                	ld	ra,168(sp)
ffffffffc02094fa:	854e                	mv	a0,s3
ffffffffc02094fc:	69aa                	ld	s3,136(sp)
ffffffffc02094fe:	614d                	addi	sp,sp,176
ffffffffc0209500:	8082                	ret
ffffffffc0209502:	59f1                	li	s3,-4
ffffffffc0209504:	b7d5                	j	ffffffffc02094e8 <sfs_do_mount+0x194>
ffffffffc0209506:	85be                	mv	a1,a5
ffffffffc0209508:	00005517          	auipc	a0,0x5
ffffffffc020950c:	fd850513          	addi	a0,a0,-40 # ffffffffc020e4e0 <etext+0x2ee6>
ffffffffc0209510:	c97f60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0209514:	59f5                	li	s3,-3
ffffffffc0209516:	b7f1                	j	ffffffffc02094e2 <sfs_do_mount+0x18e>
ffffffffc0209518:	00005517          	auipc	a0,0x5
ffffffffc020951c:	f9050513          	addi	a0,a0,-112 # ffffffffc020e4a8 <etext+0x2eae>
ffffffffc0209520:	c87f60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0209524:	59f5                	li	s3,-3
ffffffffc0209526:	bf75                	j	ffffffffc02094e2 <sfs_do_mount+0x18e>
ffffffffc0209528:	7b46                	ld	s6,112(sp)
ffffffffc020952a:	00442903          	lw	s2,4(s0)
ffffffffc020952e:	0a0c8863          	beqz	s9,ffffffffc02095de <sfs_do_mount+0x28a>
ffffffffc0209532:	4481                	li	s1,0
ffffffffc0209534:	85a6                	mv	a1,s1
ffffffffc0209536:	856a                	mv	a0,s10
ffffffffc0209538:	b05ff0ef          	jal	ffffffffc020903c <bitmap_test>
ffffffffc020953c:	c111                	beqz	a0,ffffffffc0209540 <sfs_do_mount+0x1ec>
ffffffffc020953e:	2a05                	addiw	s4,s4,1
ffffffffc0209540:	2485                	addiw	s1,s1,1
ffffffffc0209542:	fe9c99e3          	bne	s9,s1,ffffffffc0209534 <sfs_do_mount+0x1e0>
ffffffffc0209546:	441c                	lw	a5,8(s0)
ffffffffc0209548:	0f479a63          	bne	a5,s4,ffffffffc020963c <sfs_do_mount+0x2e8>
ffffffffc020954c:	05040513          	addi	a0,s0,80
ffffffffc0209550:	04043023          	sd	zero,64(s0)
ffffffffc0209554:	4585                	li	a1,1
ffffffffc0209556:	eb9fa0ef          	jal	ffffffffc020440e <sem_init>
ffffffffc020955a:	06840513          	addi	a0,s0,104
ffffffffc020955e:	4585                	li	a1,1
ffffffffc0209560:	eaffa0ef          	jal	ffffffffc020440e <sem_init>
ffffffffc0209564:	08040513          	addi	a0,s0,128
ffffffffc0209568:	4585                	li	a1,1
ffffffffc020956a:	ea5fa0ef          	jal	ffffffffc020440e <sem_init>
ffffffffc020956e:	09840793          	addi	a5,s0,152
ffffffffc0209572:	4149063b          	subw	a2,s2,s4
ffffffffc0209576:	f05c                	sd	a5,160(s0)
ffffffffc0209578:	ec5c                	sd	a5,152(s0)
ffffffffc020957a:	874a                	mv	a4,s2
ffffffffc020957c:	86d2                	mv	a3,s4
ffffffffc020957e:	00c40593          	addi	a1,s0,12
ffffffffc0209582:	00005517          	auipc	a0,0x5
ffffffffc0209586:	fee50513          	addi	a0,a0,-18 # ffffffffc020e570 <etext+0x2f76>
ffffffffc020958a:	c1df60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020958e:	00000617          	auipc	a2,0x0
ffffffffc0209592:	c9260613          	addi	a2,a2,-878 # ffffffffc0209220 <sfs_sync>
ffffffffc0209596:	00000697          	auipc	a3,0x0
ffffffffc020959a:	d6668693          	addi	a3,a3,-666 # ffffffffc02092fc <sfs_get_root>
ffffffffc020959e:	00000717          	auipc	a4,0x0
ffffffffc02095a2:	b6e70713          	addi	a4,a4,-1170 # ffffffffc020910c <sfs_unmount>
ffffffffc02095a6:	00000797          	auipc	a5,0x0
ffffffffc02095aa:	bea78793          	addi	a5,a5,-1046 # ffffffffc0209190 <sfs_cleanup>
ffffffffc02095ae:	fc50                	sd	a2,184(s0)
ffffffffc02095b0:	e074                	sd	a3,192(s0)
ffffffffc02095b2:	e478                	sd	a4,200(s0)
ffffffffc02095b4:	e87c                	sd	a5,208(s0)
ffffffffc02095b6:	008bb023          	sd	s0,0(s7)
ffffffffc02095ba:	64ea                	ld	s1,152(sp)
ffffffffc02095bc:	740a                	ld	s0,160(sp)
ffffffffc02095be:	694a                	ld	s2,144(sp)
ffffffffc02095c0:	6a0a                	ld	s4,128(sp)
ffffffffc02095c2:	7ae6                	ld	s5,120(sp)
ffffffffc02095c4:	7ba6                	ld	s7,104(sp)
ffffffffc02095c6:	7c06                	ld	s8,96(sp)
ffffffffc02095c8:	6ce6                	ld	s9,88(sp)
ffffffffc02095ca:	6d46                	ld	s10,80(sp)
ffffffffc02095cc:	6da6                	ld	s11,72(sp)
ffffffffc02095ce:	b72d                	j	ffffffffc02094f8 <sfs_do_mount+0x1a4>
ffffffffc02095d0:	59f1                	li	s3,-4
ffffffffc02095d2:	b709                	j	ffffffffc02094d4 <sfs_do_mount+0x180>
ffffffffc02095d4:	59c9                	li	s3,-14
ffffffffc02095d6:	b70d                	j	ffffffffc02094f8 <sfs_do_mount+0x1a4>
ffffffffc02095d8:	6da6                	ld	s11,72(sp)
ffffffffc02095da:	59f1                	li	s3,-4
ffffffffc02095dc:	b719                	j	ffffffffc02094e2 <sfs_do_mount+0x18e>
ffffffffc02095de:	4a01                	li	s4,0
ffffffffc02095e0:	b79d                	j	ffffffffc0209546 <sfs_do_mount+0x1f2>
ffffffffc02095e2:	740a                	ld	s0,160(sp)
ffffffffc02095e4:	64ea                	ld	s1,152(sp)
ffffffffc02095e6:	7ba6                	ld	s7,104(sp)
ffffffffc02095e8:	59f1                	li	s3,-4
ffffffffc02095ea:	b739                	j	ffffffffc02094f8 <sfs_do_mount+0x1a4>
ffffffffc02095ec:	00005697          	auipc	a3,0x5
ffffffffc02095f0:	f2468693          	addi	a3,a3,-220 # ffffffffc020e510 <etext+0x2f16>
ffffffffc02095f4:	00002617          	auipc	a2,0x2
ffffffffc02095f8:	44460613          	addi	a2,a2,1092 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02095fc:	08300593          	li	a1,131
ffffffffc0209600:	00005517          	auipc	a0,0x5
ffffffffc0209604:	e1850513          	addi	a0,a0,-488 # ffffffffc020e418 <etext+0x2e1e>
ffffffffc0209608:	f8da                	sd	s6,112(sp)
ffffffffc020960a:	f0e2                	sd	s8,96(sp)
ffffffffc020960c:	e3ff60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209610:	00005697          	auipc	a3,0x5
ffffffffc0209614:	dd868693          	addi	a3,a3,-552 # ffffffffc020e3e8 <etext+0x2dee>
ffffffffc0209618:	00002617          	auipc	a2,0x2
ffffffffc020961c:	42060613          	addi	a2,a2,1056 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209620:	0a300593          	li	a1,163
ffffffffc0209624:	00005517          	auipc	a0,0x5
ffffffffc0209628:	df450513          	addi	a0,a0,-524 # ffffffffc020e418 <etext+0x2e1e>
ffffffffc020962c:	fcd6                	sd	s5,120(sp)
ffffffffc020962e:	f8da                	sd	s6,112(sp)
ffffffffc0209630:	f0e2                	sd	s8,96(sp)
ffffffffc0209632:	ece6                	sd	s9,88(sp)
ffffffffc0209634:	e8ea                	sd	s10,80(sp)
ffffffffc0209636:	e4ee                	sd	s11,72(sp)
ffffffffc0209638:	e13f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020963c:	00005697          	auipc	a3,0x5
ffffffffc0209640:	f0468693          	addi	a3,a3,-252 # ffffffffc020e540 <etext+0x2f46>
ffffffffc0209644:	00002617          	auipc	a2,0x2
ffffffffc0209648:	3f460613          	addi	a2,a2,1012 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020964c:	0e000593          	li	a1,224
ffffffffc0209650:	00005517          	auipc	a0,0x5
ffffffffc0209654:	dc850513          	addi	a0,a0,-568 # ffffffffc020e418 <etext+0x2e1e>
ffffffffc0209658:	f8da                	sd	s6,112(sp)
ffffffffc020965a:	df1f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020965e <sfs_mount>:
ffffffffc020965e:	00000597          	auipc	a1,0x0
ffffffffc0209662:	cf658593          	addi	a1,a1,-778 # ffffffffc0209354 <sfs_do_mount>
ffffffffc0209666:	fccfe06f          	j	ffffffffc0207e32 <vfs_mount>

ffffffffc020966a <sfs_opendir>:
ffffffffc020966a:	0235f593          	andi	a1,a1,35
ffffffffc020966e:	e199                	bnez	a1,ffffffffc0209674 <sfs_opendir+0xa>
ffffffffc0209670:	4501                	li	a0,0
ffffffffc0209672:	8082                	ret
ffffffffc0209674:	553d                	li	a0,-17
ffffffffc0209676:	8082                	ret

ffffffffc0209678 <sfs_openfile>:
ffffffffc0209678:	4501                	li	a0,0
ffffffffc020967a:	8082                	ret

ffffffffc020967c <sfs_gettype>:
ffffffffc020967c:	1141                	addi	sp,sp,-16
ffffffffc020967e:	e406                	sd	ra,8(sp)
ffffffffc0209680:	c529                	beqz	a0,ffffffffc02096ca <sfs_gettype+0x4e>
ffffffffc0209682:	4d38                	lw	a4,88(a0)
ffffffffc0209684:	6785                	lui	a5,0x1
ffffffffc0209686:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020968a:	04f71063          	bne	a4,a5,ffffffffc02096ca <sfs_gettype+0x4e>
ffffffffc020968e:	6118                	ld	a4,0(a0)
ffffffffc0209690:	4789                	li	a5,2
ffffffffc0209692:	00475683          	lhu	a3,4(a4)
ffffffffc0209696:	02f68463          	beq	a3,a5,ffffffffc02096be <sfs_gettype+0x42>
ffffffffc020969a:	478d                	li	a5,3
ffffffffc020969c:	00f68b63          	beq	a3,a5,ffffffffc02096b2 <sfs_gettype+0x36>
ffffffffc02096a0:	4705                	li	a4,1
ffffffffc02096a2:	6785                	lui	a5,0x1
ffffffffc02096a4:	04e69363          	bne	a3,a4,ffffffffc02096ea <sfs_gettype+0x6e>
ffffffffc02096a8:	60a2                	ld	ra,8(sp)
ffffffffc02096aa:	c19c                	sw	a5,0(a1)
ffffffffc02096ac:	4501                	li	a0,0
ffffffffc02096ae:	0141                	addi	sp,sp,16
ffffffffc02096b0:	8082                	ret
ffffffffc02096b2:	60a2                	ld	ra,8(sp)
ffffffffc02096b4:	678d                	lui	a5,0x3
ffffffffc02096b6:	c19c                	sw	a5,0(a1)
ffffffffc02096b8:	4501                	li	a0,0
ffffffffc02096ba:	0141                	addi	sp,sp,16
ffffffffc02096bc:	8082                	ret
ffffffffc02096be:	60a2                	ld	ra,8(sp)
ffffffffc02096c0:	6789                	lui	a5,0x2
ffffffffc02096c2:	c19c                	sw	a5,0(a1)
ffffffffc02096c4:	4501                	li	a0,0
ffffffffc02096c6:	0141                	addi	sp,sp,16
ffffffffc02096c8:	8082                	ret
ffffffffc02096ca:	00005697          	auipc	a3,0x5
ffffffffc02096ce:	ec668693          	addi	a3,a3,-314 # ffffffffc020e590 <etext+0x2f96>
ffffffffc02096d2:	00002617          	auipc	a2,0x2
ffffffffc02096d6:	36660613          	addi	a2,a2,870 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02096da:	38600593          	li	a1,902
ffffffffc02096de:	00005517          	auipc	a0,0x5
ffffffffc02096e2:	eea50513          	addi	a0,a0,-278 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc02096e6:	d65f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc02096ea:	00005617          	auipc	a2,0x5
ffffffffc02096ee:	ef660613          	addi	a2,a2,-266 # ffffffffc020e5e0 <etext+0x2fe6>
ffffffffc02096f2:	39200593          	li	a1,914
ffffffffc02096f6:	00005517          	auipc	a0,0x5
ffffffffc02096fa:	ed250513          	addi	a0,a0,-302 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc02096fe:	d4df60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209702 <sfs_fsync>:
ffffffffc0209702:	7530                	ld	a2,104(a0)
ffffffffc0209704:	7179                	addi	sp,sp,-48
ffffffffc0209706:	f406                	sd	ra,40(sp)
ffffffffc0209708:	ca2d                	beqz	a2,ffffffffc020977a <sfs_fsync+0x78>
ffffffffc020970a:	0b062703          	lw	a4,176(a2)
ffffffffc020970e:	e735                	bnez	a4,ffffffffc020977a <sfs_fsync+0x78>
ffffffffc0209710:	4d34                	lw	a3,88(a0)
ffffffffc0209712:	6705                	lui	a4,0x1
ffffffffc0209714:	23570713          	addi	a4,a4,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209718:	08e69263          	bne	a3,a4,ffffffffc020979c <sfs_fsync+0x9a>
ffffffffc020971c:	6914                	ld	a3,16(a0)
ffffffffc020971e:	4701                	li	a4,0
ffffffffc0209720:	e689                	bnez	a3,ffffffffc020972a <sfs_fsync+0x28>
ffffffffc0209722:	70a2                	ld	ra,40(sp)
ffffffffc0209724:	853a                	mv	a0,a4
ffffffffc0209726:	6145                	addi	sp,sp,48
ffffffffc0209728:	8082                	ret
ffffffffc020972a:	f022                	sd	s0,32(sp)
ffffffffc020972c:	e42a                	sd	a0,8(sp)
ffffffffc020972e:	02050413          	addi	s0,a0,32
ffffffffc0209732:	02050513          	addi	a0,a0,32
ffffffffc0209736:	ec3a                	sd	a4,24(sp)
ffffffffc0209738:	e832                	sd	a2,16(sp)
ffffffffc020973a:	cdffa0ef          	jal	ffffffffc0204418 <down>
ffffffffc020973e:	67a2                	ld	a5,8(sp)
ffffffffc0209740:	6762                	ld	a4,24(sp)
ffffffffc0209742:	6b94                	ld	a3,16(a5)
ffffffffc0209744:	ea99                	bnez	a3,ffffffffc020975a <sfs_fsync+0x58>
ffffffffc0209746:	8522                	mv	a0,s0
ffffffffc0209748:	e43a                	sd	a4,8(sp)
ffffffffc020974a:	ccbfa0ef          	jal	ffffffffc0204414 <up>
ffffffffc020974e:	6722                	ld	a4,8(sp)
ffffffffc0209750:	7402                	ld	s0,32(sp)
ffffffffc0209752:	70a2                	ld	ra,40(sp)
ffffffffc0209754:	853a                	mv	a0,a4
ffffffffc0209756:	6145                	addi	sp,sp,48
ffffffffc0209758:	8082                	ret
ffffffffc020975a:	4794                	lw	a3,8(a5)
ffffffffc020975c:	638c                	ld	a1,0(a5)
ffffffffc020975e:	6542                	ld	a0,16(sp)
ffffffffc0209760:	4701                	li	a4,0
ffffffffc0209762:	0007b823          	sd	zero,16(a5) # 2010 <_binary_bin_swap_img_size-0x5cf0>
ffffffffc0209766:	04000613          	li	a2,64
ffffffffc020976a:	718010ef          	jal	ffffffffc020ae82 <sfs_wbuf>
ffffffffc020976e:	872a                	mv	a4,a0
ffffffffc0209770:	d979                	beqz	a0,ffffffffc0209746 <sfs_fsync+0x44>
ffffffffc0209772:	67a2                	ld	a5,8(sp)
ffffffffc0209774:	4685                	li	a3,1
ffffffffc0209776:	eb94                	sd	a3,16(a5)
ffffffffc0209778:	b7f9                	j	ffffffffc0209746 <sfs_fsync+0x44>
ffffffffc020977a:	00005697          	auipc	a3,0x5
ffffffffc020977e:	c6e68693          	addi	a3,a3,-914 # ffffffffc020e3e8 <etext+0x2dee>
ffffffffc0209782:	00002617          	auipc	a2,0x2
ffffffffc0209786:	2b660613          	addi	a2,a2,694 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020978a:	2ca00593          	li	a1,714
ffffffffc020978e:	00005517          	auipc	a0,0x5
ffffffffc0209792:	e3a50513          	addi	a0,a0,-454 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209796:	f022                	sd	s0,32(sp)
ffffffffc0209798:	cb3f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020979c:	00005697          	auipc	a3,0x5
ffffffffc02097a0:	df468693          	addi	a3,a3,-524 # ffffffffc020e590 <etext+0x2f96>
ffffffffc02097a4:	00002617          	auipc	a2,0x2
ffffffffc02097a8:	29460613          	addi	a2,a2,660 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02097ac:	2cb00593          	li	a1,715
ffffffffc02097b0:	00005517          	auipc	a0,0x5
ffffffffc02097b4:	e1850513          	addi	a0,a0,-488 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc02097b8:	f022                	sd	s0,32(sp)
ffffffffc02097ba:	c91f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc02097be <sfs_fstat>:
ffffffffc02097be:	1101                	addi	sp,sp,-32
ffffffffc02097c0:	e822                	sd	s0,16(sp)
ffffffffc02097c2:	e426                	sd	s1,8(sp)
ffffffffc02097c4:	842a                	mv	s0,a0
ffffffffc02097c6:	84ae                	mv	s1,a1
ffffffffc02097c8:	852e                	mv	a0,a1
ffffffffc02097ca:	02000613          	li	a2,32
ffffffffc02097ce:	4581                	li	a1,0
ffffffffc02097d0:	ec06                	sd	ra,24(sp)
ffffffffc02097d2:	5c1010ef          	jal	ffffffffc020b592 <memset>
ffffffffc02097d6:	c439                	beqz	s0,ffffffffc0209824 <sfs_fstat+0x66>
ffffffffc02097d8:	783c                	ld	a5,112(s0)
ffffffffc02097da:	c7a9                	beqz	a5,ffffffffc0209824 <sfs_fstat+0x66>
ffffffffc02097dc:	6bbc                	ld	a5,80(a5)
ffffffffc02097de:	c3b9                	beqz	a5,ffffffffc0209824 <sfs_fstat+0x66>
ffffffffc02097e0:	00005597          	auipc	a1,0x5
ffffffffc02097e4:	81858593          	addi	a1,a1,-2024 # ffffffffc020dff8 <etext+0x29fe>
ffffffffc02097e8:	8522                	mv	a0,s0
ffffffffc02097ea:	85afe0ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc02097ee:	783c                	ld	a5,112(s0)
ffffffffc02097f0:	85a6                	mv	a1,s1
ffffffffc02097f2:	8522                	mv	a0,s0
ffffffffc02097f4:	6bbc                	ld	a5,80(a5)
ffffffffc02097f6:	9782                	jalr	a5
ffffffffc02097f8:	e10d                	bnez	a0,ffffffffc020981a <sfs_fstat+0x5c>
ffffffffc02097fa:	4c38                	lw	a4,88(s0)
ffffffffc02097fc:	6785                	lui	a5,0x1
ffffffffc02097fe:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209802:	04f71163          	bne	a4,a5,ffffffffc0209844 <sfs_fstat+0x86>
ffffffffc0209806:	601c                	ld	a5,0(s0)
ffffffffc0209808:	0067d683          	lhu	a3,6(a5)
ffffffffc020980c:	0087e703          	lwu	a4,8(a5)
ffffffffc0209810:	0007e783          	lwu	a5,0(a5)
ffffffffc0209814:	e494                	sd	a3,8(s1)
ffffffffc0209816:	e898                	sd	a4,16(s1)
ffffffffc0209818:	ec9c                	sd	a5,24(s1)
ffffffffc020981a:	60e2                	ld	ra,24(sp)
ffffffffc020981c:	6442                	ld	s0,16(sp)
ffffffffc020981e:	64a2                	ld	s1,8(sp)
ffffffffc0209820:	6105                	addi	sp,sp,32
ffffffffc0209822:	8082                	ret
ffffffffc0209824:	00004697          	auipc	a3,0x4
ffffffffc0209828:	76c68693          	addi	a3,a3,1900 # ffffffffc020df90 <etext+0x2996>
ffffffffc020982c:	00002617          	auipc	a2,0x2
ffffffffc0209830:	20c60613          	addi	a2,a2,524 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209834:	2bb00593          	li	a1,699
ffffffffc0209838:	00005517          	auipc	a0,0x5
ffffffffc020983c:	d9050513          	addi	a0,a0,-624 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209840:	c0bf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209844:	00005697          	auipc	a3,0x5
ffffffffc0209848:	d4c68693          	addi	a3,a3,-692 # ffffffffc020e590 <etext+0x2f96>
ffffffffc020984c:	00002617          	auipc	a2,0x2
ffffffffc0209850:	1ec60613          	addi	a2,a2,492 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209854:	2be00593          	li	a1,702
ffffffffc0209858:	00005517          	auipc	a0,0x5
ffffffffc020985c:	d7050513          	addi	a0,a0,-656 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209860:	bebf60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209864 <sfs_tryseek>:
ffffffffc0209864:	08000737          	lui	a4,0x8000
ffffffffc0209868:	04e5f863          	bgeu	a1,a4,ffffffffc02098b8 <sfs_tryseek+0x54>
ffffffffc020986c:	1101                	addi	sp,sp,-32
ffffffffc020986e:	ec06                	sd	ra,24(sp)
ffffffffc0209870:	c531                	beqz	a0,ffffffffc02098bc <sfs_tryseek+0x58>
ffffffffc0209872:	4d30                	lw	a2,88(a0)
ffffffffc0209874:	6685                	lui	a3,0x1
ffffffffc0209876:	23568693          	addi	a3,a3,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020987a:	04d61163          	bne	a2,a3,ffffffffc02098bc <sfs_tryseek+0x58>
ffffffffc020987e:	6114                	ld	a3,0(a0)
ffffffffc0209880:	0006e683          	lwu	a3,0(a3)
ffffffffc0209884:	02b6d663          	bge	a3,a1,ffffffffc02098b0 <sfs_tryseek+0x4c>
ffffffffc0209888:	7934                	ld	a3,112(a0)
ffffffffc020988a:	caa9                	beqz	a3,ffffffffc02098dc <sfs_tryseek+0x78>
ffffffffc020988c:	72b4                	ld	a3,96(a3)
ffffffffc020988e:	c6b9                	beqz	a3,ffffffffc02098dc <sfs_tryseek+0x78>
ffffffffc0209890:	e02e                	sd	a1,0(sp)
ffffffffc0209892:	00004597          	auipc	a1,0x4
ffffffffc0209896:	65658593          	addi	a1,a1,1622 # ffffffffc020dee8 <etext+0x28ee>
ffffffffc020989a:	e42a                	sd	a0,8(sp)
ffffffffc020989c:	fa9fd0ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc02098a0:	67a2                	ld	a5,8(sp)
ffffffffc02098a2:	6582                	ld	a1,0(sp)
ffffffffc02098a4:	60e2                	ld	ra,24(sp)
ffffffffc02098a6:	7bb4                	ld	a3,112(a5)
ffffffffc02098a8:	853e                	mv	a0,a5
ffffffffc02098aa:	72bc                	ld	a5,96(a3)
ffffffffc02098ac:	6105                	addi	sp,sp,32
ffffffffc02098ae:	8782                	jr	a5
ffffffffc02098b0:	60e2                	ld	ra,24(sp)
ffffffffc02098b2:	4501                	li	a0,0
ffffffffc02098b4:	6105                	addi	sp,sp,32
ffffffffc02098b6:	8082                	ret
ffffffffc02098b8:	5575                	li	a0,-3
ffffffffc02098ba:	8082                	ret
ffffffffc02098bc:	00005697          	auipc	a3,0x5
ffffffffc02098c0:	cd468693          	addi	a3,a3,-812 # ffffffffc020e590 <etext+0x2f96>
ffffffffc02098c4:	00002617          	auipc	a2,0x2
ffffffffc02098c8:	17460613          	addi	a2,a2,372 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02098cc:	39d00593          	li	a1,925
ffffffffc02098d0:	00005517          	auipc	a0,0x5
ffffffffc02098d4:	cf850513          	addi	a0,a0,-776 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc02098d8:	b73f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc02098dc:	00004697          	auipc	a3,0x4
ffffffffc02098e0:	5b468693          	addi	a3,a3,1460 # ffffffffc020de90 <etext+0x2896>
ffffffffc02098e4:	00002617          	auipc	a2,0x2
ffffffffc02098e8:	15460613          	addi	a2,a2,340 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02098ec:	39f00593          	li	a1,927
ffffffffc02098f0:	00005517          	auipc	a0,0x5
ffffffffc02098f4:	cd850513          	addi	a0,a0,-808 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc02098f8:	b53f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc02098fc <sfs_close>:
ffffffffc02098fc:	1141                	addi	sp,sp,-16
ffffffffc02098fe:	e406                	sd	ra,8(sp)
ffffffffc0209900:	e022                	sd	s0,0(sp)
ffffffffc0209902:	c11d                	beqz	a0,ffffffffc0209928 <sfs_close+0x2c>
ffffffffc0209904:	793c                	ld	a5,112(a0)
ffffffffc0209906:	842a                	mv	s0,a0
ffffffffc0209908:	c385                	beqz	a5,ffffffffc0209928 <sfs_close+0x2c>
ffffffffc020990a:	7b9c                	ld	a5,48(a5)
ffffffffc020990c:	cf91                	beqz	a5,ffffffffc0209928 <sfs_close+0x2c>
ffffffffc020990e:	00004597          	auipc	a1,0x4
ffffffffc0209912:	97258593          	addi	a1,a1,-1678 # ffffffffc020d280 <etext+0x1c86>
ffffffffc0209916:	f2ffd0ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc020991a:	783c                	ld	a5,112(s0)
ffffffffc020991c:	8522                	mv	a0,s0
ffffffffc020991e:	6402                	ld	s0,0(sp)
ffffffffc0209920:	60a2                	ld	ra,8(sp)
ffffffffc0209922:	7b9c                	ld	a5,48(a5)
ffffffffc0209924:	0141                	addi	sp,sp,16
ffffffffc0209926:	8782                	jr	a5
ffffffffc0209928:	00004697          	auipc	a3,0x4
ffffffffc020992c:	90868693          	addi	a3,a3,-1784 # ffffffffc020d230 <etext+0x1c36>
ffffffffc0209930:	00002617          	auipc	a2,0x2
ffffffffc0209934:	10860613          	addi	a2,a2,264 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209938:	21c00593          	li	a1,540
ffffffffc020993c:	00005517          	auipc	a0,0x5
ffffffffc0209940:	c8c50513          	addi	a0,a0,-884 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209944:	b07f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209948 <sfs_io.part.0>:
ffffffffc0209948:	1141                	addi	sp,sp,-16
ffffffffc020994a:	00005697          	auipc	a3,0x5
ffffffffc020994e:	c4668693          	addi	a3,a3,-954 # ffffffffc020e590 <etext+0x2f96>
ffffffffc0209952:	00002617          	auipc	a2,0x2
ffffffffc0209956:	0e660613          	addi	a2,a2,230 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020995a:	29a00593          	li	a1,666
ffffffffc020995e:	00005517          	auipc	a0,0x5
ffffffffc0209962:	c6a50513          	addi	a0,a0,-918 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209966:	e406                	sd	ra,8(sp)
ffffffffc0209968:	ae3f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020996c <sfs_block_free>:
ffffffffc020996c:	1101                	addi	sp,sp,-32
ffffffffc020996e:	e822                	sd	s0,16(sp)
ffffffffc0209970:	e426                	sd	s1,8(sp)
ffffffffc0209972:	ec06                	sd	ra,24(sp)
ffffffffc0209974:	84ae                	mv	s1,a1
ffffffffc0209976:	842a                	mv	s0,a0
ffffffffc0209978:	c595                	beqz	a1,ffffffffc02099a4 <sfs_block_free+0x38>
ffffffffc020997a:	415c                	lw	a5,4(a0)
ffffffffc020997c:	02f5f463          	bgeu	a1,a5,ffffffffc02099a4 <sfs_block_free+0x38>
ffffffffc0209980:	7d08                	ld	a0,56(a0)
ffffffffc0209982:	ebaff0ef          	jal	ffffffffc020903c <bitmap_test>
ffffffffc0209986:	ed0d                	bnez	a0,ffffffffc02099c0 <sfs_block_free+0x54>
ffffffffc0209988:	7c08                	ld	a0,56(s0)
ffffffffc020998a:	85a6                	mv	a1,s1
ffffffffc020998c:	ed8ff0ef          	jal	ffffffffc0209064 <bitmap_free>
ffffffffc0209990:	441c                	lw	a5,8(s0)
ffffffffc0209992:	4705                	li	a4,1
ffffffffc0209994:	60e2                	ld	ra,24(sp)
ffffffffc0209996:	2785                	addiw	a5,a5,1
ffffffffc0209998:	e038                	sd	a4,64(s0)
ffffffffc020999a:	c41c                	sw	a5,8(s0)
ffffffffc020999c:	6442                	ld	s0,16(sp)
ffffffffc020999e:	64a2                	ld	s1,8(sp)
ffffffffc02099a0:	6105                	addi	sp,sp,32
ffffffffc02099a2:	8082                	ret
ffffffffc02099a4:	4054                	lw	a3,4(s0)
ffffffffc02099a6:	8726                	mv	a4,s1
ffffffffc02099a8:	00005617          	auipc	a2,0x5
ffffffffc02099ac:	c5060613          	addi	a2,a2,-944 # ffffffffc020e5f8 <etext+0x2ffe>
ffffffffc02099b0:	05300593          	li	a1,83
ffffffffc02099b4:	00005517          	auipc	a0,0x5
ffffffffc02099b8:	c1450513          	addi	a0,a0,-1004 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc02099bc:	a8ff60ef          	jal	ffffffffc020044a <__panic>
ffffffffc02099c0:	00005697          	auipc	a3,0x5
ffffffffc02099c4:	c7068693          	addi	a3,a3,-912 # ffffffffc020e630 <etext+0x3036>
ffffffffc02099c8:	00002617          	auipc	a2,0x2
ffffffffc02099cc:	07060613          	addi	a2,a2,112 # ffffffffc020ba38 <etext+0x43e>
ffffffffc02099d0:	06a00593          	li	a1,106
ffffffffc02099d4:	00005517          	auipc	a0,0x5
ffffffffc02099d8:	bf450513          	addi	a0,a0,-1036 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc02099dc:	a6ff60ef          	jal	ffffffffc020044a <__panic>

ffffffffc02099e0 <sfs_reclaim>:
ffffffffc02099e0:	1101                	addi	sp,sp,-32
ffffffffc02099e2:	e426                	sd	s1,8(sp)
ffffffffc02099e4:	7524                	ld	s1,104(a0)
ffffffffc02099e6:	ec06                	sd	ra,24(sp)
ffffffffc02099e8:	e822                	sd	s0,16(sp)
ffffffffc02099ea:	e04a                	sd	s2,0(sp)
ffffffffc02099ec:	0e048963          	beqz	s1,ffffffffc0209ade <sfs_reclaim+0xfe>
ffffffffc02099f0:	0b04a783          	lw	a5,176(s1)
ffffffffc02099f4:	0e079563          	bnez	a5,ffffffffc0209ade <sfs_reclaim+0xfe>
ffffffffc02099f8:	4d38                	lw	a4,88(a0)
ffffffffc02099fa:	6785                	lui	a5,0x1
ffffffffc02099fc:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209a00:	842a                	mv	s0,a0
ffffffffc0209a02:	10f71e63          	bne	a4,a5,ffffffffc0209b1e <sfs_reclaim+0x13e>
ffffffffc0209a06:	8526                	mv	a0,s1
ffffffffc0209a08:	62e010ef          	jal	ffffffffc020b036 <lock_sfs_fs>
ffffffffc0209a0c:	4c1c                	lw	a5,24(s0)
ffffffffc0209a0e:	0ef05863          	blez	a5,ffffffffc0209afe <sfs_reclaim+0x11e>
ffffffffc0209a12:	37fd                	addiw	a5,a5,-1
ffffffffc0209a14:	cc1c                	sw	a5,24(s0)
ffffffffc0209a16:	ebd9                	bnez	a5,ffffffffc0209aac <sfs_reclaim+0xcc>
ffffffffc0209a18:	05c42903          	lw	s2,92(s0)
ffffffffc0209a1c:	08091863          	bnez	s2,ffffffffc0209aac <sfs_reclaim+0xcc>
ffffffffc0209a20:	601c                	ld	a5,0(s0)
ffffffffc0209a22:	0067d783          	lhu	a5,6(a5)
ffffffffc0209a26:	e785                	bnez	a5,ffffffffc0209a4e <sfs_reclaim+0x6e>
ffffffffc0209a28:	783c                	ld	a5,112(s0)
ffffffffc0209a2a:	10078a63          	beqz	a5,ffffffffc0209b3e <sfs_reclaim+0x15e>
ffffffffc0209a2e:	73bc                	ld	a5,96(a5)
ffffffffc0209a30:	10078763          	beqz	a5,ffffffffc0209b3e <sfs_reclaim+0x15e>
ffffffffc0209a34:	00004597          	auipc	a1,0x4
ffffffffc0209a38:	4b458593          	addi	a1,a1,1204 # ffffffffc020dee8 <etext+0x28ee>
ffffffffc0209a3c:	8522                	mv	a0,s0
ffffffffc0209a3e:	e07fd0ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc0209a42:	783c                	ld	a5,112(s0)
ffffffffc0209a44:	8522                	mv	a0,s0
ffffffffc0209a46:	4581                	li	a1,0
ffffffffc0209a48:	73bc                	ld	a5,96(a5)
ffffffffc0209a4a:	9782                	jalr	a5
ffffffffc0209a4c:	e559                	bnez	a0,ffffffffc0209ada <sfs_reclaim+0xfa>
ffffffffc0209a4e:	681c                	ld	a5,16(s0)
ffffffffc0209a50:	c39d                	beqz	a5,ffffffffc0209a76 <sfs_reclaim+0x96>
ffffffffc0209a52:	783c                	ld	a5,112(s0)
ffffffffc0209a54:	10078563          	beqz	a5,ffffffffc0209b5e <sfs_reclaim+0x17e>
ffffffffc0209a58:	7b9c                	ld	a5,48(a5)
ffffffffc0209a5a:	10078263          	beqz	a5,ffffffffc0209b5e <sfs_reclaim+0x17e>
ffffffffc0209a5e:	8522                	mv	a0,s0
ffffffffc0209a60:	00004597          	auipc	a1,0x4
ffffffffc0209a64:	82058593          	addi	a1,a1,-2016 # ffffffffc020d280 <etext+0x1c86>
ffffffffc0209a68:	dddfd0ef          	jal	ffffffffc0207844 <inode_check>
ffffffffc0209a6c:	783c                	ld	a5,112(s0)
ffffffffc0209a6e:	8522                	mv	a0,s0
ffffffffc0209a70:	7b9c                	ld	a5,48(a5)
ffffffffc0209a72:	9782                	jalr	a5
ffffffffc0209a74:	e13d                	bnez	a0,ffffffffc0209ada <sfs_reclaim+0xfa>
ffffffffc0209a76:	7c18                	ld	a4,56(s0)
ffffffffc0209a78:	603c                	ld	a5,64(s0)
ffffffffc0209a7a:	8526                	mv	a0,s1
ffffffffc0209a7c:	e71c                	sd	a5,8(a4)
ffffffffc0209a7e:	e398                	sd	a4,0(a5)
ffffffffc0209a80:	6438                	ld	a4,72(s0)
ffffffffc0209a82:	683c                	ld	a5,80(s0)
ffffffffc0209a84:	e71c                	sd	a5,8(a4)
ffffffffc0209a86:	e398                	sd	a4,0(a5)
ffffffffc0209a88:	5be010ef          	jal	ffffffffc020b046 <unlock_sfs_fs>
ffffffffc0209a8c:	6008                	ld	a0,0(s0)
ffffffffc0209a8e:	00655783          	lhu	a5,6(a0)
ffffffffc0209a92:	cb85                	beqz	a5,ffffffffc0209ac2 <sfs_reclaim+0xe2>
ffffffffc0209a94:	e62f80ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc0209a98:	8522                	mv	a0,s0
ffffffffc0209a9a:	d43fd0ef          	jal	ffffffffc02077dc <inode_kill>
ffffffffc0209a9e:	60e2                	ld	ra,24(sp)
ffffffffc0209aa0:	6442                	ld	s0,16(sp)
ffffffffc0209aa2:	64a2                	ld	s1,8(sp)
ffffffffc0209aa4:	854a                	mv	a0,s2
ffffffffc0209aa6:	6902                	ld	s2,0(sp)
ffffffffc0209aa8:	6105                	addi	sp,sp,32
ffffffffc0209aaa:	8082                	ret
ffffffffc0209aac:	5945                	li	s2,-15
ffffffffc0209aae:	8526                	mv	a0,s1
ffffffffc0209ab0:	596010ef          	jal	ffffffffc020b046 <unlock_sfs_fs>
ffffffffc0209ab4:	60e2                	ld	ra,24(sp)
ffffffffc0209ab6:	6442                	ld	s0,16(sp)
ffffffffc0209ab8:	64a2                	ld	s1,8(sp)
ffffffffc0209aba:	854a                	mv	a0,s2
ffffffffc0209abc:	6902                	ld	s2,0(sp)
ffffffffc0209abe:	6105                	addi	sp,sp,32
ffffffffc0209ac0:	8082                	ret
ffffffffc0209ac2:	440c                	lw	a1,8(s0)
ffffffffc0209ac4:	8526                	mv	a0,s1
ffffffffc0209ac6:	ea7ff0ef          	jal	ffffffffc020996c <sfs_block_free>
ffffffffc0209aca:	6008                	ld	a0,0(s0)
ffffffffc0209acc:	5d4c                	lw	a1,60(a0)
ffffffffc0209ace:	d1f9                	beqz	a1,ffffffffc0209a94 <sfs_reclaim+0xb4>
ffffffffc0209ad0:	8526                	mv	a0,s1
ffffffffc0209ad2:	e9bff0ef          	jal	ffffffffc020996c <sfs_block_free>
ffffffffc0209ad6:	6008                	ld	a0,0(s0)
ffffffffc0209ad8:	bf75                	j	ffffffffc0209a94 <sfs_reclaim+0xb4>
ffffffffc0209ada:	892a                	mv	s2,a0
ffffffffc0209adc:	bfc9                	j	ffffffffc0209aae <sfs_reclaim+0xce>
ffffffffc0209ade:	00005697          	auipc	a3,0x5
ffffffffc0209ae2:	90a68693          	addi	a3,a3,-1782 # ffffffffc020e3e8 <etext+0x2dee>
ffffffffc0209ae6:	00002617          	auipc	a2,0x2
ffffffffc0209aea:	f5260613          	addi	a2,a2,-174 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209aee:	35b00593          	li	a1,859
ffffffffc0209af2:	00005517          	auipc	a0,0x5
ffffffffc0209af6:	ad650513          	addi	a0,a0,-1322 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209afa:	951f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209afe:	00005697          	auipc	a3,0x5
ffffffffc0209b02:	b5268693          	addi	a3,a3,-1198 # ffffffffc020e650 <etext+0x3056>
ffffffffc0209b06:	00002617          	auipc	a2,0x2
ffffffffc0209b0a:	f3260613          	addi	a2,a2,-206 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209b0e:	36100593          	li	a1,865
ffffffffc0209b12:	00005517          	auipc	a0,0x5
ffffffffc0209b16:	ab650513          	addi	a0,a0,-1354 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209b1a:	931f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209b1e:	00005697          	auipc	a3,0x5
ffffffffc0209b22:	a7268693          	addi	a3,a3,-1422 # ffffffffc020e590 <etext+0x2f96>
ffffffffc0209b26:	00002617          	auipc	a2,0x2
ffffffffc0209b2a:	f1260613          	addi	a2,a2,-238 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209b2e:	35c00593          	li	a1,860
ffffffffc0209b32:	00005517          	auipc	a0,0x5
ffffffffc0209b36:	a9650513          	addi	a0,a0,-1386 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209b3a:	911f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209b3e:	00004697          	auipc	a3,0x4
ffffffffc0209b42:	35268693          	addi	a3,a3,850 # ffffffffc020de90 <etext+0x2896>
ffffffffc0209b46:	00002617          	auipc	a2,0x2
ffffffffc0209b4a:	ef260613          	addi	a2,a2,-270 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209b4e:	36600593          	li	a1,870
ffffffffc0209b52:	00005517          	auipc	a0,0x5
ffffffffc0209b56:	a7650513          	addi	a0,a0,-1418 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209b5a:	8f1f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209b5e:	00003697          	auipc	a3,0x3
ffffffffc0209b62:	6d268693          	addi	a3,a3,1746 # ffffffffc020d230 <etext+0x1c36>
ffffffffc0209b66:	00002617          	auipc	a2,0x2
ffffffffc0209b6a:	ed260613          	addi	a2,a2,-302 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209b6e:	36b00593          	li	a1,875
ffffffffc0209b72:	00005517          	auipc	a0,0x5
ffffffffc0209b76:	a5650513          	addi	a0,a0,-1450 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209b7a:	8d1f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209b7e <sfs_block_alloc>:
ffffffffc0209b7e:	1101                	addi	sp,sp,-32
ffffffffc0209b80:	e822                	sd	s0,16(sp)
ffffffffc0209b82:	842a                	mv	s0,a0
ffffffffc0209b84:	7d08                	ld	a0,56(a0)
ffffffffc0209b86:	e426                	sd	s1,8(sp)
ffffffffc0209b88:	ec06                	sd	ra,24(sp)
ffffffffc0209b8a:	84ae                	mv	s1,a1
ffffffffc0209b8c:	c3eff0ef          	jal	ffffffffc0208fca <bitmap_alloc>
ffffffffc0209b90:	e90d                	bnez	a0,ffffffffc0209bc2 <sfs_block_alloc+0x44>
ffffffffc0209b92:	441c                	lw	a5,8(s0)
ffffffffc0209b94:	cbb5                	beqz	a5,ffffffffc0209c08 <sfs_block_alloc+0x8a>
ffffffffc0209b96:	37fd                	addiw	a5,a5,-1
ffffffffc0209b98:	c41c                	sw	a5,8(s0)
ffffffffc0209b9a:	408c                	lw	a1,0(s1)
ffffffffc0209b9c:	4605                	li	a2,1
ffffffffc0209b9e:	e030                	sd	a2,64(s0)
ffffffffc0209ba0:	c595                	beqz	a1,ffffffffc0209bcc <sfs_block_alloc+0x4e>
ffffffffc0209ba2:	405c                	lw	a5,4(s0)
ffffffffc0209ba4:	02f5f463          	bgeu	a1,a5,ffffffffc0209bcc <sfs_block_alloc+0x4e>
ffffffffc0209ba8:	7c08                	ld	a0,56(s0)
ffffffffc0209baa:	c92ff0ef          	jal	ffffffffc020903c <bitmap_test>
ffffffffc0209bae:	4605                	li	a2,1
ffffffffc0209bb0:	ed05                	bnez	a0,ffffffffc0209be8 <sfs_block_alloc+0x6a>
ffffffffc0209bb2:	8522                	mv	a0,s0
ffffffffc0209bb4:	6442                	ld	s0,16(sp)
ffffffffc0209bb6:	408c                	lw	a1,0(s1)
ffffffffc0209bb8:	60e2                	ld	ra,24(sp)
ffffffffc0209bba:	64a2                	ld	s1,8(sp)
ffffffffc0209bbc:	6105                	addi	sp,sp,32
ffffffffc0209bbe:	4180106f          	j	ffffffffc020afd6 <sfs_clear_block>
ffffffffc0209bc2:	60e2                	ld	ra,24(sp)
ffffffffc0209bc4:	6442                	ld	s0,16(sp)
ffffffffc0209bc6:	64a2                	ld	s1,8(sp)
ffffffffc0209bc8:	6105                	addi	sp,sp,32
ffffffffc0209bca:	8082                	ret
ffffffffc0209bcc:	4054                	lw	a3,4(s0)
ffffffffc0209bce:	872e                	mv	a4,a1
ffffffffc0209bd0:	00005617          	auipc	a2,0x5
ffffffffc0209bd4:	a2860613          	addi	a2,a2,-1496 # ffffffffc020e5f8 <etext+0x2ffe>
ffffffffc0209bd8:	05300593          	li	a1,83
ffffffffc0209bdc:	00005517          	auipc	a0,0x5
ffffffffc0209be0:	9ec50513          	addi	a0,a0,-1556 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209be4:	867f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209be8:	00005697          	auipc	a3,0x5
ffffffffc0209bec:	aa068693          	addi	a3,a3,-1376 # ffffffffc020e688 <etext+0x308e>
ffffffffc0209bf0:	00002617          	auipc	a2,0x2
ffffffffc0209bf4:	e4860613          	addi	a2,a2,-440 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209bf8:	06100593          	li	a1,97
ffffffffc0209bfc:	00005517          	auipc	a0,0x5
ffffffffc0209c00:	9cc50513          	addi	a0,a0,-1588 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209c04:	847f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209c08:	00005697          	auipc	a3,0x5
ffffffffc0209c0c:	a6068693          	addi	a3,a3,-1440 # ffffffffc020e668 <etext+0x306e>
ffffffffc0209c10:	00002617          	auipc	a2,0x2
ffffffffc0209c14:	e2860613          	addi	a2,a2,-472 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209c18:	05f00593          	li	a1,95
ffffffffc0209c1c:	00005517          	auipc	a0,0x5
ffffffffc0209c20:	9ac50513          	addi	a0,a0,-1620 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209c24:	827f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209c28 <sfs_bmap_load_nolock>:
ffffffffc0209c28:	711d                	addi	sp,sp,-96
ffffffffc0209c2a:	e4a6                	sd	s1,72(sp)
ffffffffc0209c2c:	6184                	ld	s1,0(a1)
ffffffffc0209c2e:	e0ca                	sd	s2,64(sp)
ffffffffc0209c30:	ec86                	sd	ra,88(sp)
ffffffffc0209c32:	0084a903          	lw	s2,8(s1)
ffffffffc0209c36:	e8a2                	sd	s0,80(sp)
ffffffffc0209c38:	fc4e                	sd	s3,56(sp)
ffffffffc0209c3a:	f852                	sd	s4,48(sp)
ffffffffc0209c3c:	1ac96663          	bltu	s2,a2,ffffffffc0209de8 <sfs_bmap_load_nolock+0x1c0>
ffffffffc0209c40:	47ad                	li	a5,11
ffffffffc0209c42:	882e                	mv	a6,a1
ffffffffc0209c44:	8432                	mv	s0,a2
ffffffffc0209c46:	8a36                	mv	s4,a3
ffffffffc0209c48:	89aa                	mv	s3,a0
ffffffffc0209c4a:	04c7f963          	bgeu	a5,a2,ffffffffc0209c9c <sfs_bmap_load_nolock+0x74>
ffffffffc0209c4e:	ff46079b          	addiw	a5,a2,-12
ffffffffc0209c52:	3ff00713          	li	a4,1023
ffffffffc0209c56:	f456                	sd	s5,40(sp)
ffffffffc0209c58:	1af76a63          	bltu	a4,a5,ffffffffc0209e0c <sfs_bmap_load_nolock+0x1e4>
ffffffffc0209c5c:	03c4a883          	lw	a7,60(s1)
ffffffffc0209c60:	02079713          	slli	a4,a5,0x20
ffffffffc0209c64:	01e75793          	srli	a5,a4,0x1e
ffffffffc0209c68:	ce02                	sw	zero,28(sp)
ffffffffc0209c6a:	cc46                	sw	a7,24(sp)
ffffffffc0209c6c:	8abe                	mv	s5,a5
ffffffffc0209c6e:	12089063          	bnez	a7,ffffffffc0209d8e <sfs_bmap_load_nolock+0x166>
ffffffffc0209c72:	08c90c63          	beq	s2,a2,ffffffffc0209d0a <sfs_bmap_load_nolock+0xe2>
ffffffffc0209c76:	7aa2                	ld	s5,40(sp)
ffffffffc0209c78:	4581                	li	a1,0
ffffffffc0209c7a:	0049a683          	lw	a3,4(s3)
ffffffffc0209c7e:	f456                	sd	s5,40(sp)
ffffffffc0209c80:	f05a                	sd	s6,32(sp)
ffffffffc0209c82:	872e                	mv	a4,a1
ffffffffc0209c84:	00005617          	auipc	a2,0x5
ffffffffc0209c88:	97460613          	addi	a2,a2,-1676 # ffffffffc020e5f8 <etext+0x2ffe>
ffffffffc0209c8c:	05300593          	li	a1,83
ffffffffc0209c90:	00005517          	auipc	a0,0x5
ffffffffc0209c94:	93850513          	addi	a0,a0,-1736 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209c98:	fb2f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209c9c:	02061793          	slli	a5,a2,0x20
ffffffffc0209ca0:	01e7d713          	srli	a4,a5,0x1e
ffffffffc0209ca4:	9726                	add	a4,a4,s1
ffffffffc0209ca6:	474c                	lw	a1,12(a4)
ffffffffc0209ca8:	ca2e                	sw	a1,20(sp)
ffffffffc0209caa:	e581                	bnez	a1,ffffffffc0209cb2 <sfs_bmap_load_nolock+0x8a>
ffffffffc0209cac:	0cc90063          	beq	s2,a2,ffffffffc0209d6c <sfs_bmap_load_nolock+0x144>
ffffffffc0209cb0:	d5e1                	beqz	a1,ffffffffc0209c78 <sfs_bmap_load_nolock+0x50>
ffffffffc0209cb2:	0049a683          	lw	a3,4(s3)
ffffffffc0209cb6:	16d5f863          	bgeu	a1,a3,ffffffffc0209e26 <sfs_bmap_load_nolock+0x1fe>
ffffffffc0209cba:	0389b503          	ld	a0,56(s3)
ffffffffc0209cbe:	b7eff0ef          	jal	ffffffffc020903c <bitmap_test>
ffffffffc0209cc2:	18051763          	bnez	a0,ffffffffc0209e50 <sfs_bmap_load_nolock+0x228>
ffffffffc0209cc6:	45d2                	lw	a1,20(sp)
ffffffffc0209cc8:	0049a783          	lw	a5,4(s3)
ffffffffc0209ccc:	d5d5                	beqz	a1,ffffffffc0209c78 <sfs_bmap_load_nolock+0x50>
ffffffffc0209cce:	faf5f6e3          	bgeu	a1,a5,ffffffffc0209c7a <sfs_bmap_load_nolock+0x52>
ffffffffc0209cd2:	0389b503          	ld	a0,56(s3)
ffffffffc0209cd6:	e02e                	sd	a1,0(sp)
ffffffffc0209cd8:	b64ff0ef          	jal	ffffffffc020903c <bitmap_test>
ffffffffc0209cdc:	6582                	ld	a1,0(sp)
ffffffffc0209cde:	14051763          	bnez	a0,ffffffffc0209e2c <sfs_bmap_load_nolock+0x204>
ffffffffc0209ce2:	02890063          	beq	s2,s0,ffffffffc0209d02 <sfs_bmap_load_nolock+0xda>
ffffffffc0209ce6:	000a0463          	beqz	s4,ffffffffc0209cee <sfs_bmap_load_nolock+0xc6>
ffffffffc0209cea:	00ba2023          	sw	a1,0(s4)
ffffffffc0209cee:	4781                	li	a5,0
ffffffffc0209cf0:	6446                	ld	s0,80(sp)
ffffffffc0209cf2:	60e6                	ld	ra,88(sp)
ffffffffc0209cf4:	79e2                	ld	s3,56(sp)
ffffffffc0209cf6:	7a42                	ld	s4,48(sp)
ffffffffc0209cf8:	64a6                	ld	s1,72(sp)
ffffffffc0209cfa:	6906                	ld	s2,64(sp)
ffffffffc0209cfc:	853e                	mv	a0,a5
ffffffffc0209cfe:	6125                	addi	sp,sp,96
ffffffffc0209d00:	8082                	ret
ffffffffc0209d02:	449c                	lw	a5,8(s1)
ffffffffc0209d04:	2785                	addiw	a5,a5,1
ffffffffc0209d06:	c49c                	sw	a5,8(s1)
ffffffffc0209d08:	bff9                	j	ffffffffc0209ce6 <sfs_bmap_load_nolock+0xbe>
ffffffffc0209d0a:	082c                	addi	a1,sp,24
ffffffffc0209d0c:	e046                	sd	a7,0(sp)
ffffffffc0209d0e:	e442                	sd	a6,8(sp)
ffffffffc0209d10:	e6fff0ef          	jal	ffffffffc0209b7e <sfs_block_alloc>
ffffffffc0209d14:	87aa                	mv	a5,a0
ffffffffc0209d16:	ed5d                	bnez	a0,ffffffffc0209dd4 <sfs_bmap_load_nolock+0x1ac>
ffffffffc0209d18:	6882                	ld	a7,0(sp)
ffffffffc0209d1a:	6822                	ld	a6,8(sp)
ffffffffc0209d1c:	f05a                	sd	s6,32(sp)
ffffffffc0209d1e:	01c10b13          	addi	s6,sp,28
ffffffffc0209d22:	85da                	mv	a1,s6
ffffffffc0209d24:	854e                	mv	a0,s3
ffffffffc0209d26:	e046                	sd	a7,0(sp)
ffffffffc0209d28:	e442                	sd	a6,8(sp)
ffffffffc0209d2a:	e55ff0ef          	jal	ffffffffc0209b7e <sfs_block_alloc>
ffffffffc0209d2e:	6882                	ld	a7,0(sp)
ffffffffc0209d30:	87aa                	mv	a5,a0
ffffffffc0209d32:	e959                	bnez	a0,ffffffffc0209dc8 <sfs_bmap_load_nolock+0x1a0>
ffffffffc0209d34:	46e2                	lw	a3,24(sp)
ffffffffc0209d36:	85da                	mv	a1,s6
ffffffffc0209d38:	8756                	mv	a4,s5
ffffffffc0209d3a:	4611                	li	a2,4
ffffffffc0209d3c:	854e                	mv	a0,s3
ffffffffc0209d3e:	e046                	sd	a7,0(sp)
ffffffffc0209d40:	142010ef          	jal	ffffffffc020ae82 <sfs_wbuf>
ffffffffc0209d44:	45f2                	lw	a1,28(sp)
ffffffffc0209d46:	6882                	ld	a7,0(sp)
ffffffffc0209d48:	e92d                	bnez	a0,ffffffffc0209dba <sfs_bmap_load_nolock+0x192>
ffffffffc0209d4a:	5cd8                	lw	a4,60(s1)
ffffffffc0209d4c:	47e2                	lw	a5,24(sp)
ffffffffc0209d4e:	6822                	ld	a6,8(sp)
ffffffffc0209d50:	ca2e                	sw	a1,20(sp)
ffffffffc0209d52:	00f70863          	beq	a4,a5,ffffffffc0209d62 <sfs_bmap_load_nolock+0x13a>
ffffffffc0209d56:	10071f63          	bnez	a4,ffffffffc0209e74 <sfs_bmap_load_nolock+0x24c>
ffffffffc0209d5a:	dcdc                	sw	a5,60(s1)
ffffffffc0209d5c:	4785                	li	a5,1
ffffffffc0209d5e:	00f83823          	sd	a5,16(a6)
ffffffffc0209d62:	7aa2                	ld	s5,40(sp)
ffffffffc0209d64:	7b02                	ld	s6,32(sp)
ffffffffc0209d66:	f00589e3          	beqz	a1,ffffffffc0209c78 <sfs_bmap_load_nolock+0x50>
ffffffffc0209d6a:	b7a1                	j	ffffffffc0209cb2 <sfs_bmap_load_nolock+0x8a>
ffffffffc0209d6c:	084c                	addi	a1,sp,20
ffffffffc0209d6e:	e03a                	sd	a4,0(sp)
ffffffffc0209d70:	e442                	sd	a6,8(sp)
ffffffffc0209d72:	e0dff0ef          	jal	ffffffffc0209b7e <sfs_block_alloc>
ffffffffc0209d76:	87aa                	mv	a5,a0
ffffffffc0209d78:	fd25                	bnez	a0,ffffffffc0209cf0 <sfs_bmap_load_nolock+0xc8>
ffffffffc0209d7a:	45d2                	lw	a1,20(sp)
ffffffffc0209d7c:	6702                	ld	a4,0(sp)
ffffffffc0209d7e:	6822                	ld	a6,8(sp)
ffffffffc0209d80:	4785                	li	a5,1
ffffffffc0209d82:	c74c                	sw	a1,12(a4)
ffffffffc0209d84:	00f83823          	sd	a5,16(a6)
ffffffffc0209d88:	ee0588e3          	beqz	a1,ffffffffc0209c78 <sfs_bmap_load_nolock+0x50>
ffffffffc0209d8c:	b71d                	j	ffffffffc0209cb2 <sfs_bmap_load_nolock+0x8a>
ffffffffc0209d8e:	e02e                	sd	a1,0(sp)
ffffffffc0209d90:	873e                	mv	a4,a5
ffffffffc0209d92:	086c                	addi	a1,sp,28
ffffffffc0209d94:	86c6                	mv	a3,a7
ffffffffc0209d96:	4611                	li	a2,4
ffffffffc0209d98:	f05a                	sd	s6,32(sp)
ffffffffc0209d9a:	e446                	sd	a7,8(sp)
ffffffffc0209d9c:	066010ef          	jal	ffffffffc020ae02 <sfs_rbuf>
ffffffffc0209da0:	01c10b13          	addi	s6,sp,28
ffffffffc0209da4:	87aa                	mv	a5,a0
ffffffffc0209da6:	e505                	bnez	a0,ffffffffc0209dce <sfs_bmap_load_nolock+0x1a6>
ffffffffc0209da8:	45f2                	lw	a1,28(sp)
ffffffffc0209daa:	6802                	ld	a6,0(sp)
ffffffffc0209dac:	00891463          	bne	s2,s0,ffffffffc0209db4 <sfs_bmap_load_nolock+0x18c>
ffffffffc0209db0:	68a2                	ld	a7,8(sp)
ffffffffc0209db2:	d9a5                	beqz	a1,ffffffffc0209d22 <sfs_bmap_load_nolock+0xfa>
ffffffffc0209db4:	5cd8                	lw	a4,60(s1)
ffffffffc0209db6:	47e2                	lw	a5,24(sp)
ffffffffc0209db8:	bf61                	j	ffffffffc0209d50 <sfs_bmap_load_nolock+0x128>
ffffffffc0209dba:	e42a                	sd	a0,8(sp)
ffffffffc0209dbc:	854e                	mv	a0,s3
ffffffffc0209dbe:	e046                	sd	a7,0(sp)
ffffffffc0209dc0:	badff0ef          	jal	ffffffffc020996c <sfs_block_free>
ffffffffc0209dc4:	6882                	ld	a7,0(sp)
ffffffffc0209dc6:	67a2                	ld	a5,8(sp)
ffffffffc0209dc8:	45e2                	lw	a1,24(sp)
ffffffffc0209dca:	00b89763          	bne	a7,a1,ffffffffc0209dd8 <sfs_bmap_load_nolock+0x1b0>
ffffffffc0209dce:	7aa2                	ld	s5,40(sp)
ffffffffc0209dd0:	7b02                	ld	s6,32(sp)
ffffffffc0209dd2:	bf39                	j	ffffffffc0209cf0 <sfs_bmap_load_nolock+0xc8>
ffffffffc0209dd4:	7aa2                	ld	s5,40(sp)
ffffffffc0209dd6:	bf29                	j	ffffffffc0209cf0 <sfs_bmap_load_nolock+0xc8>
ffffffffc0209dd8:	854e                	mv	a0,s3
ffffffffc0209dda:	e03e                	sd	a5,0(sp)
ffffffffc0209ddc:	b91ff0ef          	jal	ffffffffc020996c <sfs_block_free>
ffffffffc0209de0:	6782                	ld	a5,0(sp)
ffffffffc0209de2:	7aa2                	ld	s5,40(sp)
ffffffffc0209de4:	7b02                	ld	s6,32(sp)
ffffffffc0209de6:	b729                	j	ffffffffc0209cf0 <sfs_bmap_load_nolock+0xc8>
ffffffffc0209de8:	00005697          	auipc	a3,0x5
ffffffffc0209dec:	8c868693          	addi	a3,a3,-1848 # ffffffffc020e6b0 <etext+0x30b6>
ffffffffc0209df0:	00002617          	auipc	a2,0x2
ffffffffc0209df4:	c4860613          	addi	a2,a2,-952 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209df8:	16400593          	li	a1,356
ffffffffc0209dfc:	00004517          	auipc	a0,0x4
ffffffffc0209e00:	7cc50513          	addi	a0,a0,1996 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209e04:	f456                	sd	s5,40(sp)
ffffffffc0209e06:	f05a                	sd	s6,32(sp)
ffffffffc0209e08:	e42f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209e0c:	00005617          	auipc	a2,0x5
ffffffffc0209e10:	8d460613          	addi	a2,a2,-1836 # ffffffffc020e6e0 <etext+0x30e6>
ffffffffc0209e14:	11e00593          	li	a1,286
ffffffffc0209e18:	00004517          	auipc	a0,0x4
ffffffffc0209e1c:	7b050513          	addi	a0,a0,1968 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209e20:	f05a                	sd	s6,32(sp)
ffffffffc0209e22:	e28f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209e26:	f456                	sd	s5,40(sp)
ffffffffc0209e28:	f05a                	sd	s6,32(sp)
ffffffffc0209e2a:	bda1                	j	ffffffffc0209c82 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209e2c:	00005697          	auipc	a3,0x5
ffffffffc0209e30:	80468693          	addi	a3,a3,-2044 # ffffffffc020e630 <etext+0x3036>
ffffffffc0209e34:	00002617          	auipc	a2,0x2
ffffffffc0209e38:	c0460613          	addi	a2,a2,-1020 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209e3c:	16b00593          	li	a1,363
ffffffffc0209e40:	00004517          	auipc	a0,0x4
ffffffffc0209e44:	78850513          	addi	a0,a0,1928 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209e48:	f456                	sd	s5,40(sp)
ffffffffc0209e4a:	f05a                	sd	s6,32(sp)
ffffffffc0209e4c:	dfef60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209e50:	00005697          	auipc	a3,0x5
ffffffffc0209e54:	8c068693          	addi	a3,a3,-1856 # ffffffffc020e710 <etext+0x3116>
ffffffffc0209e58:	00002617          	auipc	a2,0x2
ffffffffc0209e5c:	be060613          	addi	a2,a2,-1056 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209e60:	12100593          	li	a1,289
ffffffffc0209e64:	00004517          	auipc	a0,0x4
ffffffffc0209e68:	76450513          	addi	a0,a0,1892 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209e6c:	f456                	sd	s5,40(sp)
ffffffffc0209e6e:	f05a                	sd	s6,32(sp)
ffffffffc0209e70:	ddaf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209e74:	00005697          	auipc	a3,0x5
ffffffffc0209e78:	85468693          	addi	a3,a3,-1964 # ffffffffc020e6c8 <etext+0x30ce>
ffffffffc0209e7c:	00002617          	auipc	a2,0x2
ffffffffc0209e80:	bbc60613          	addi	a2,a2,-1092 # ffffffffc020ba38 <etext+0x43e>
ffffffffc0209e84:	11800593          	li	a1,280
ffffffffc0209e88:	00004517          	auipc	a0,0x4
ffffffffc0209e8c:	74050513          	addi	a0,a0,1856 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc0209e90:	dbaf60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209e94 <sfs_io_nolock>:
ffffffffc0209e94:	7175                	addi	sp,sp,-144
ffffffffc0209e96:	f8ca                	sd	s2,112(sp)
ffffffffc0209e98:	892e                	mv	s2,a1
ffffffffc0209e9a:	618c                	ld	a1,0(a1)
ffffffffc0209e9c:	e506                	sd	ra,136(sp)
ffffffffc0209e9e:	4809                	li	a6,2
ffffffffc0209ea0:	0045d883          	lhu	a7,4(a1)
ffffffffc0209ea4:	e122                	sd	s0,128(sp)
ffffffffc0209ea6:	fca6                	sd	s1,120(sp)
ffffffffc0209ea8:	1d088a63          	beq	a7,a6,ffffffffc020a07c <sfs_io_nolock+0x1e8>
ffffffffc0209eac:	00073803          	ld	a6,0(a4) # 8000000 <_binary_bin_sfs_img_size+0x7f8ad00>
ffffffffc0209eb0:	84ba                	mv	s1,a4
ffffffffc0209eb2:	0004b023          	sd	zero,0(s1)
ffffffffc0209eb6:	08000737          	lui	a4,0x8000
ffffffffc0209eba:	8436                	mv	s0,a3
ffffffffc0209ebc:	9836                	add	a6,a6,a3
ffffffffc0209ebe:	8336                	mv	t1,a3
ffffffffc0209ec0:	1ae6fc63          	bgeu	a3,a4,ffffffffc020a078 <sfs_io_nolock+0x1e4>
ffffffffc0209ec4:	1ad84a63          	blt	a6,a3,ffffffffc020a078 <sfs_io_nolock+0x1e4>
ffffffffc0209ec8:	f4ce                	sd	s3,104(sp)
ffffffffc0209eca:	89aa                	mv	s3,a0
ffffffffc0209ecc:	4501                	li	a0,0
ffffffffc0209ece:	13068d63          	beq	a3,a6,ffffffffc020a008 <sfs_io_nolock+0x174>
ffffffffc0209ed2:	f0d2                	sd	s4,96(sp)
ffffffffc0209ed4:	e8da                	sd	s6,80(sp)
ffffffffc0209ed6:	e4de                	sd	s7,72(sp)
ffffffffc0209ed8:	8a32                	mv	s4,a2
ffffffffc0209eda:	01077363          	bgeu	a4,a6,ffffffffc0209ee0 <sfs_io_nolock+0x4c>
ffffffffc0209ede:	883a                	mv	a6,a4
ffffffffc0209ee0:	cfd5                	beqz	a5,ffffffffc0209f9c <sfs_io_nolock+0x108>
ffffffffc0209ee2:	ecd6                	sd	s5,88(sp)
ffffffffc0209ee4:	00001b97          	auipc	s7,0x1
ffffffffc0209ee8:	ebcb8b93          	addi	s7,s7,-324 # ffffffffc020ada0 <sfs_wblock>
ffffffffc0209eec:	00001b17          	auipc	s6,0x1
ffffffffc0209ef0:	f96b0b13          	addi	s6,s6,-106 # ffffffffc020ae82 <sfs_wbuf>
ffffffffc0209ef4:	6605                	lui	a2,0x1
ffffffffc0209ef6:	40c45693          	srai	a3,s0,0xc
ffffffffc0209efa:	fff60713          	addi	a4,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0209efe:	40c85793          	srai	a5,a6,0xc
ffffffffc0209f02:	9f95                	subw	a5,a5,a3
ffffffffc0209f04:	8f61                	and	a4,a4,s0
ffffffffc0209f06:	00068a9b          	sext.w	s5,a3
ffffffffc0209f0a:	8e3e                	mv	t3,a5
ffffffffc0209f0c:	cb4d                	beqz	a4,ffffffffc0209fbe <sfs_io_nolock+0x12a>
ffffffffc0209f0e:	40880e33          	sub	t3,a6,s0
ffffffffc0209f12:	10079263          	bnez	a5,ffffffffc020a016 <sfs_io_nolock+0x182>
ffffffffc0209f16:	1874                	addi	a3,sp,60
ffffffffc0209f18:	8656                	mv	a2,s5
ffffffffc0209f1a:	85ca                	mv	a1,s2
ffffffffc0209f1c:	854e                	mv	a0,s3
ffffffffc0209f1e:	e41a                	sd	t1,8(sp)
ffffffffc0209f20:	f43e                	sd	a5,40(sp)
ffffffffc0209f22:	ec3a                	sd	a4,24(sp)
ffffffffc0209f24:	f042                	sd	a6,32(sp)
ffffffffc0209f26:	e872                	sd	t3,16(sp)
ffffffffc0209f28:	d01ff0ef          	jal	ffffffffc0209c28 <sfs_bmap_load_nolock>
ffffffffc0209f2c:	6322                	ld	t1,8(sp)
ffffffffc0209f2e:	4881                	li	a7,0
ffffffffc0209f30:	ed0d                	bnez	a0,ffffffffc0209f6a <sfs_io_nolock+0xd6>
ffffffffc0209f32:	56f2                	lw	a3,60(sp)
ffffffffc0209f34:	6762                	ld	a4,24(sp)
ffffffffc0209f36:	6642                	ld	a2,16(sp)
ffffffffc0209f38:	85d2                	mv	a1,s4
ffffffffc0209f3a:	854e                	mv	a0,s3
ffffffffc0209f3c:	9b02                	jalr	s6
ffffffffc0209f3e:	6322                	ld	t1,8(sp)
ffffffffc0209f40:	4881                	li	a7,0
ffffffffc0209f42:	e505                	bnez	a0,ffffffffc0209f6a <sfs_io_nolock+0xd6>
ffffffffc0209f44:	77a2                	ld	a5,40(sp)
ffffffffc0209f46:	68c2                	ld	a7,16(sp)
ffffffffc0209f48:	7802                	ld	a6,32(sp)
ffffffffc0209f4a:	10078a63          	beqz	a5,ffffffffc020a05e <sfs_io_nolock+0x1ca>
ffffffffc0209f4e:	fff78e1b          	addiw	t3,a5,-1
ffffffffc0209f52:	9a46                	add	s4,s4,a7
ffffffffc0209f54:	2a85                	addiw	s5,s5,1
ffffffffc0209f56:	060e1763          	bnez	t3,ffffffffc0209fc4 <sfs_io_nolock+0x130>
ffffffffc0209f5a:	1852                	slli	a6,a6,0x34
ffffffffc0209f5c:	03485793          	srli	a5,a6,0x34
ffffffffc0209f60:	0c081863          	bnez	a6,ffffffffc020a030 <sfs_io_nolock+0x19c>
ffffffffc0209f64:	01140333          	add	t1,s0,a7
ffffffffc0209f68:	4501                	li	a0,0
ffffffffc0209f6a:	00093783          	ld	a5,0(s2)
ffffffffc0209f6e:	0114b023          	sd	a7,0(s1)
ffffffffc0209f72:	0007e703          	lwu	a4,0(a5)
ffffffffc0209f76:	00677863          	bgeu	a4,t1,ffffffffc0209f86 <sfs_io_nolock+0xf2>
ffffffffc0209f7a:	0114043b          	addw	s0,s0,a7
ffffffffc0209f7e:	c380                	sw	s0,0(a5)
ffffffffc0209f80:	4785                	li	a5,1
ffffffffc0209f82:	00f93823          	sd	a5,16(s2)
ffffffffc0209f86:	79a6                	ld	s3,104(sp)
ffffffffc0209f88:	7a06                	ld	s4,96(sp)
ffffffffc0209f8a:	6ae6                	ld	s5,88(sp)
ffffffffc0209f8c:	6b46                	ld	s6,80(sp)
ffffffffc0209f8e:	6ba6                	ld	s7,72(sp)
ffffffffc0209f90:	640a                	ld	s0,128(sp)
ffffffffc0209f92:	60aa                	ld	ra,136(sp)
ffffffffc0209f94:	74e6                	ld	s1,120(sp)
ffffffffc0209f96:	7946                	ld	s2,112(sp)
ffffffffc0209f98:	6149                	addi	sp,sp,144
ffffffffc0209f9a:	8082                	ret
ffffffffc0209f9c:	0005e783          	lwu	a5,0(a1)
ffffffffc0209fa0:	4501                	li	a0,0
ffffffffc0209fa2:	0cf45163          	bge	s0,a5,ffffffffc020a064 <sfs_io_nolock+0x1d0>
ffffffffc0209fa6:	ecd6                	sd	s5,88(sp)
ffffffffc0209fa8:	0707ca63          	blt	a5,a6,ffffffffc020a01c <sfs_io_nolock+0x188>
ffffffffc0209fac:	00001b97          	auipc	s7,0x1
ffffffffc0209fb0:	d92b8b93          	addi	s7,s7,-622 # ffffffffc020ad3e <sfs_rblock>
ffffffffc0209fb4:	00001b17          	auipc	s6,0x1
ffffffffc0209fb8:	e4eb0b13          	addi	s6,s6,-434 # ffffffffc020ae02 <sfs_rbuf>
ffffffffc0209fbc:	bf25                	j	ffffffffc0209ef4 <sfs_io_nolock+0x60>
ffffffffc0209fbe:	4881                	li	a7,0
ffffffffc0209fc0:	f80e0de3          	beqz	t3,ffffffffc0209f5a <sfs_io_nolock+0xc6>
ffffffffc0209fc4:	1874                	addi	a3,sp,60
ffffffffc0209fc6:	8656                	mv	a2,s5
ffffffffc0209fc8:	85ca                	mv	a1,s2
ffffffffc0209fca:	854e                	mv	a0,s3
ffffffffc0209fcc:	ec72                	sd	t3,24(sp)
ffffffffc0209fce:	e846                	sd	a7,16(sp)
ffffffffc0209fd0:	e442                	sd	a6,8(sp)
ffffffffc0209fd2:	c57ff0ef          	jal	ffffffffc0209c28 <sfs_bmap_load_nolock>
ffffffffc0209fd6:	6822                	ld	a6,8(sp)
ffffffffc0209fd8:	68c2                	ld	a7,16(sp)
ffffffffc0209fda:	6e62                	ld	t3,24(sp)
ffffffffc0209fdc:	e149                	bnez	a0,ffffffffc020a05e <sfs_io_nolock+0x1ca>
ffffffffc0209fde:	5672                	lw	a2,60(sp)
ffffffffc0209fe0:	86f2                	mv	a3,t3
ffffffffc0209fe2:	85d2                	mv	a1,s4
ffffffffc0209fe4:	854e                	mv	a0,s3
ffffffffc0209fe6:	ec46                	sd	a7,24(sp)
ffffffffc0209fe8:	e842                	sd	a6,16(sp)
ffffffffc0209fea:	e472                	sd	t3,8(sp)
ffffffffc0209fec:	9b82                	jalr	s7
ffffffffc0209fee:	6e22                	ld	t3,8(sp)
ffffffffc0209ff0:	6842                	ld	a6,16(sp)
ffffffffc0209ff2:	68e2                	ld	a7,24(sp)
ffffffffc0209ff4:	e52d                	bnez	a0,ffffffffc020a05e <sfs_io_nolock+0x1ca>
ffffffffc0209ff6:	00ce179b          	slliw	a5,t3,0xc
ffffffffc0209ffa:	1782                	slli	a5,a5,0x20
ffffffffc0209ffc:	9381                	srli	a5,a5,0x20
ffffffffc0209ffe:	01ca8abb          	addw	s5,s5,t3
ffffffffc020a002:	98be                	add	a7,a7,a5
ffffffffc020a004:	9a3e                	add	s4,s4,a5
ffffffffc020a006:	bf91                	j	ffffffffc0209f5a <sfs_io_nolock+0xc6>
ffffffffc020a008:	640a                	ld	s0,128(sp)
ffffffffc020a00a:	60aa                	ld	ra,136(sp)
ffffffffc020a00c:	79a6                	ld	s3,104(sp)
ffffffffc020a00e:	74e6                	ld	s1,120(sp)
ffffffffc020a010:	7946                	ld	s2,112(sp)
ffffffffc020a012:	6149                	addi	sp,sp,144
ffffffffc020a014:	8082                	ret
ffffffffc020a016:	40e60e33          	sub	t3,a2,a4
ffffffffc020a01a:	bdf5                	j	ffffffffc0209f16 <sfs_io_nolock+0x82>
ffffffffc020a01c:	883e                	mv	a6,a5
ffffffffc020a01e:	00001b97          	auipc	s7,0x1
ffffffffc020a022:	d20b8b93          	addi	s7,s7,-736 # ffffffffc020ad3e <sfs_rblock>
ffffffffc020a026:	00001b17          	auipc	s6,0x1
ffffffffc020a02a:	ddcb0b13          	addi	s6,s6,-548 # ffffffffc020ae02 <sfs_rbuf>
ffffffffc020a02e:	b5d9                	j	ffffffffc0209ef4 <sfs_io_nolock+0x60>
ffffffffc020a030:	8656                	mv	a2,s5
ffffffffc020a032:	1874                	addi	a3,sp,60
ffffffffc020a034:	85ca                	mv	a1,s2
ffffffffc020a036:	854e                	mv	a0,s3
ffffffffc020a038:	e846                	sd	a7,16(sp)
ffffffffc020a03a:	e43e                	sd	a5,8(sp)
ffffffffc020a03c:	bedff0ef          	jal	ffffffffc0209c28 <sfs_bmap_load_nolock>
ffffffffc020a040:	67a2                	ld	a5,8(sp)
ffffffffc020a042:	68c2                	ld	a7,16(sp)
ffffffffc020a044:	ed09                	bnez	a0,ffffffffc020a05e <sfs_io_nolock+0x1ca>
ffffffffc020a046:	56f2                	lw	a3,60(sp)
ffffffffc020a048:	863e                	mv	a2,a5
ffffffffc020a04a:	85d2                	mv	a1,s4
ffffffffc020a04c:	854e                	mv	a0,s3
ffffffffc020a04e:	4701                	li	a4,0
ffffffffc020a050:	e846                	sd	a7,16(sp)
ffffffffc020a052:	e43e                	sd	a5,8(sp)
ffffffffc020a054:	9b02                	jalr	s6
ffffffffc020a056:	67a2                	ld	a5,8(sp)
ffffffffc020a058:	68c2                	ld	a7,16(sp)
ffffffffc020a05a:	e111                	bnez	a0,ffffffffc020a05e <sfs_io_nolock+0x1ca>
ffffffffc020a05c:	98be                	add	a7,a7,a5
ffffffffc020a05e:	01140333          	add	t1,s0,a7
ffffffffc020a062:	b721                	j	ffffffffc0209f6a <sfs_io_nolock+0xd6>
ffffffffc020a064:	640a                	ld	s0,128(sp)
ffffffffc020a066:	60aa                	ld	ra,136(sp)
ffffffffc020a068:	79a6                	ld	s3,104(sp)
ffffffffc020a06a:	7a06                	ld	s4,96(sp)
ffffffffc020a06c:	6b46                	ld	s6,80(sp)
ffffffffc020a06e:	6ba6                	ld	s7,72(sp)
ffffffffc020a070:	74e6                	ld	s1,120(sp)
ffffffffc020a072:	7946                	ld	s2,112(sp)
ffffffffc020a074:	6149                	addi	sp,sp,144
ffffffffc020a076:	8082                	ret
ffffffffc020a078:	5575                	li	a0,-3
ffffffffc020a07a:	bf19                	j	ffffffffc0209f90 <sfs_io_nolock+0xfc>
ffffffffc020a07c:	00004697          	auipc	a3,0x4
ffffffffc020a080:	6bc68693          	addi	a3,a3,1724 # ffffffffc020e738 <etext+0x313e>
ffffffffc020a084:	00002617          	auipc	a2,0x2
ffffffffc020a088:	9b460613          	addi	a2,a2,-1612 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a08c:	22b00593          	li	a1,555
ffffffffc020a090:	00004517          	auipc	a0,0x4
ffffffffc020a094:	53850513          	addi	a0,a0,1336 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a098:	f4ce                	sd	s3,104(sp)
ffffffffc020a09a:	f0d2                	sd	s4,96(sp)
ffffffffc020a09c:	ecd6                	sd	s5,88(sp)
ffffffffc020a09e:	e8da                	sd	s6,80(sp)
ffffffffc020a0a0:	e4de                	sd	s7,72(sp)
ffffffffc020a0a2:	ba8f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a0a6 <sfs_read>:
ffffffffc020a0a6:	7139                	addi	sp,sp,-64
ffffffffc020a0a8:	f04a                	sd	s2,32(sp)
ffffffffc020a0aa:	06853903          	ld	s2,104(a0)
ffffffffc020a0ae:	fc06                	sd	ra,56(sp)
ffffffffc020a0b0:	f822                	sd	s0,48(sp)
ffffffffc020a0b2:	f426                	sd	s1,40(sp)
ffffffffc020a0b4:	ec4e                	sd	s3,24(sp)
ffffffffc020a0b6:	04090e63          	beqz	s2,ffffffffc020a112 <sfs_read+0x6c>
ffffffffc020a0ba:	0b092783          	lw	a5,176(s2)
ffffffffc020a0be:	ebb1                	bnez	a5,ffffffffc020a112 <sfs_read+0x6c>
ffffffffc020a0c0:	4d38                	lw	a4,88(a0)
ffffffffc020a0c2:	6785                	lui	a5,0x1
ffffffffc020a0c4:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a0c8:	842a                	mv	s0,a0
ffffffffc020a0ca:	06f71463          	bne	a4,a5,ffffffffc020a132 <sfs_read+0x8c>
ffffffffc020a0ce:	02050993          	addi	s3,a0,32
ffffffffc020a0d2:	854e                	mv	a0,s3
ffffffffc020a0d4:	84ae                	mv	s1,a1
ffffffffc020a0d6:	b42fa0ef          	jal	ffffffffc0204418 <down>
ffffffffc020a0da:	6c9c                	ld	a5,24(s1)
ffffffffc020a0dc:	6494                	ld	a3,8(s1)
ffffffffc020a0de:	6090                	ld	a2,0(s1)
ffffffffc020a0e0:	85a2                	mv	a1,s0
ffffffffc020a0e2:	e43e                	sd	a5,8(sp)
ffffffffc020a0e4:	854a                	mv	a0,s2
ffffffffc020a0e6:	0038                	addi	a4,sp,8
ffffffffc020a0e8:	4781                	li	a5,0
ffffffffc020a0ea:	dabff0ef          	jal	ffffffffc0209e94 <sfs_io_nolock>
ffffffffc020a0ee:	65a2                	ld	a1,8(sp)
ffffffffc020a0f0:	842a                	mv	s0,a0
ffffffffc020a0f2:	ed81                	bnez	a1,ffffffffc020a10a <sfs_read+0x64>
ffffffffc020a0f4:	854e                	mv	a0,s3
ffffffffc020a0f6:	b1efa0ef          	jal	ffffffffc0204414 <up>
ffffffffc020a0fa:	70e2                	ld	ra,56(sp)
ffffffffc020a0fc:	8522                	mv	a0,s0
ffffffffc020a0fe:	7442                	ld	s0,48(sp)
ffffffffc020a100:	74a2                	ld	s1,40(sp)
ffffffffc020a102:	7902                	ld	s2,32(sp)
ffffffffc020a104:	69e2                	ld	s3,24(sp)
ffffffffc020a106:	6121                	addi	sp,sp,64
ffffffffc020a108:	8082                	ret
ffffffffc020a10a:	8526                	mv	a0,s1
ffffffffc020a10c:	a30fb0ef          	jal	ffffffffc020533c <iobuf_skip>
ffffffffc020a110:	b7d5                	j	ffffffffc020a0f4 <sfs_read+0x4e>
ffffffffc020a112:	00004697          	auipc	a3,0x4
ffffffffc020a116:	2d668693          	addi	a3,a3,726 # ffffffffc020e3e8 <etext+0x2dee>
ffffffffc020a11a:	00002617          	auipc	a2,0x2
ffffffffc020a11e:	91e60613          	addi	a2,a2,-1762 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a122:	29900593          	li	a1,665
ffffffffc020a126:	00004517          	auipc	a0,0x4
ffffffffc020a12a:	4a250513          	addi	a0,a0,1186 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a12e:	b1cf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a132:	817ff0ef          	jal	ffffffffc0209948 <sfs_io.part.0>

ffffffffc020a136 <sfs_write>:
ffffffffc020a136:	7139                	addi	sp,sp,-64
ffffffffc020a138:	f04a                	sd	s2,32(sp)
ffffffffc020a13a:	06853903          	ld	s2,104(a0)
ffffffffc020a13e:	fc06                	sd	ra,56(sp)
ffffffffc020a140:	f822                	sd	s0,48(sp)
ffffffffc020a142:	f426                	sd	s1,40(sp)
ffffffffc020a144:	ec4e                	sd	s3,24(sp)
ffffffffc020a146:	04090e63          	beqz	s2,ffffffffc020a1a2 <sfs_write+0x6c>
ffffffffc020a14a:	0b092783          	lw	a5,176(s2)
ffffffffc020a14e:	ebb1                	bnez	a5,ffffffffc020a1a2 <sfs_write+0x6c>
ffffffffc020a150:	4d38                	lw	a4,88(a0)
ffffffffc020a152:	6785                	lui	a5,0x1
ffffffffc020a154:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a158:	842a                	mv	s0,a0
ffffffffc020a15a:	06f71463          	bne	a4,a5,ffffffffc020a1c2 <sfs_write+0x8c>
ffffffffc020a15e:	02050993          	addi	s3,a0,32
ffffffffc020a162:	854e                	mv	a0,s3
ffffffffc020a164:	84ae                	mv	s1,a1
ffffffffc020a166:	ab2fa0ef          	jal	ffffffffc0204418 <down>
ffffffffc020a16a:	6c9c                	ld	a5,24(s1)
ffffffffc020a16c:	6494                	ld	a3,8(s1)
ffffffffc020a16e:	6090                	ld	a2,0(s1)
ffffffffc020a170:	85a2                	mv	a1,s0
ffffffffc020a172:	e43e                	sd	a5,8(sp)
ffffffffc020a174:	854a                	mv	a0,s2
ffffffffc020a176:	0038                	addi	a4,sp,8
ffffffffc020a178:	4785                	li	a5,1
ffffffffc020a17a:	d1bff0ef          	jal	ffffffffc0209e94 <sfs_io_nolock>
ffffffffc020a17e:	65a2                	ld	a1,8(sp)
ffffffffc020a180:	842a                	mv	s0,a0
ffffffffc020a182:	ed81                	bnez	a1,ffffffffc020a19a <sfs_write+0x64>
ffffffffc020a184:	854e                	mv	a0,s3
ffffffffc020a186:	a8efa0ef          	jal	ffffffffc0204414 <up>
ffffffffc020a18a:	70e2                	ld	ra,56(sp)
ffffffffc020a18c:	8522                	mv	a0,s0
ffffffffc020a18e:	7442                	ld	s0,48(sp)
ffffffffc020a190:	74a2                	ld	s1,40(sp)
ffffffffc020a192:	7902                	ld	s2,32(sp)
ffffffffc020a194:	69e2                	ld	s3,24(sp)
ffffffffc020a196:	6121                	addi	sp,sp,64
ffffffffc020a198:	8082                	ret
ffffffffc020a19a:	8526                	mv	a0,s1
ffffffffc020a19c:	9a0fb0ef          	jal	ffffffffc020533c <iobuf_skip>
ffffffffc020a1a0:	b7d5                	j	ffffffffc020a184 <sfs_write+0x4e>
ffffffffc020a1a2:	00004697          	auipc	a3,0x4
ffffffffc020a1a6:	24668693          	addi	a3,a3,582 # ffffffffc020e3e8 <etext+0x2dee>
ffffffffc020a1aa:	00002617          	auipc	a2,0x2
ffffffffc020a1ae:	88e60613          	addi	a2,a2,-1906 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a1b2:	29900593          	li	a1,665
ffffffffc020a1b6:	00004517          	auipc	a0,0x4
ffffffffc020a1ba:	41250513          	addi	a0,a0,1042 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a1be:	a8cf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a1c2:	f86ff0ef          	jal	ffffffffc0209948 <sfs_io.part.0>

ffffffffc020a1c6 <sfs_dirent_read_nolock>:
ffffffffc020a1c6:	619c                	ld	a5,0(a1)
ffffffffc020a1c8:	7139                	addi	sp,sp,-64
ffffffffc020a1ca:	f426                	sd	s1,40(sp)
ffffffffc020a1cc:	84b6                	mv	s1,a3
ffffffffc020a1ce:	0047d683          	lhu	a3,4(a5)
ffffffffc020a1d2:	fc06                	sd	ra,56(sp)
ffffffffc020a1d4:	f822                	sd	s0,48(sp)
ffffffffc020a1d6:	4709                	li	a4,2
ffffffffc020a1d8:	04e69963          	bne	a3,a4,ffffffffc020a22a <sfs_dirent_read_nolock+0x64>
ffffffffc020a1dc:	479c                	lw	a5,8(a5)
ffffffffc020a1de:	04f67663          	bgeu	a2,a5,ffffffffc020a22a <sfs_dirent_read_nolock+0x64>
ffffffffc020a1e2:	0874                	addi	a3,sp,28
ffffffffc020a1e4:	842a                	mv	s0,a0
ffffffffc020a1e6:	a43ff0ef          	jal	ffffffffc0209c28 <sfs_bmap_load_nolock>
ffffffffc020a1ea:	c511                	beqz	a0,ffffffffc020a1f6 <sfs_dirent_read_nolock+0x30>
ffffffffc020a1ec:	70e2                	ld	ra,56(sp)
ffffffffc020a1ee:	7442                	ld	s0,48(sp)
ffffffffc020a1f0:	74a2                	ld	s1,40(sp)
ffffffffc020a1f2:	6121                	addi	sp,sp,64
ffffffffc020a1f4:	8082                	ret
ffffffffc020a1f6:	45f2                	lw	a1,28(sp)
ffffffffc020a1f8:	c9a9                	beqz	a1,ffffffffc020a24a <sfs_dirent_read_nolock+0x84>
ffffffffc020a1fa:	405c                	lw	a5,4(s0)
ffffffffc020a1fc:	04f5f763          	bgeu	a1,a5,ffffffffc020a24a <sfs_dirent_read_nolock+0x84>
ffffffffc020a200:	7c08                	ld	a0,56(s0)
ffffffffc020a202:	e42e                	sd	a1,8(sp)
ffffffffc020a204:	e39fe0ef          	jal	ffffffffc020903c <bitmap_test>
ffffffffc020a208:	ed39                	bnez	a0,ffffffffc020a266 <sfs_dirent_read_nolock+0xa0>
ffffffffc020a20a:	66a2                	ld	a3,8(sp)
ffffffffc020a20c:	8522                	mv	a0,s0
ffffffffc020a20e:	4701                	li	a4,0
ffffffffc020a210:	10400613          	li	a2,260
ffffffffc020a214:	85a6                	mv	a1,s1
ffffffffc020a216:	3ed000ef          	jal	ffffffffc020ae02 <sfs_rbuf>
ffffffffc020a21a:	f969                	bnez	a0,ffffffffc020a1ec <sfs_dirent_read_nolock+0x26>
ffffffffc020a21c:	100481a3          	sb	zero,259(s1)
ffffffffc020a220:	70e2                	ld	ra,56(sp)
ffffffffc020a222:	7442                	ld	s0,48(sp)
ffffffffc020a224:	74a2                	ld	s1,40(sp)
ffffffffc020a226:	6121                	addi	sp,sp,64
ffffffffc020a228:	8082                	ret
ffffffffc020a22a:	00004697          	auipc	a3,0x4
ffffffffc020a22e:	52e68693          	addi	a3,a3,1326 # ffffffffc020e758 <etext+0x315e>
ffffffffc020a232:	00002617          	auipc	a2,0x2
ffffffffc020a236:	80660613          	addi	a2,a2,-2042 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a23a:	18e00593          	li	a1,398
ffffffffc020a23e:	00004517          	auipc	a0,0x4
ffffffffc020a242:	38a50513          	addi	a0,a0,906 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a246:	a04f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a24a:	4054                	lw	a3,4(s0)
ffffffffc020a24c:	872e                	mv	a4,a1
ffffffffc020a24e:	00004617          	auipc	a2,0x4
ffffffffc020a252:	3aa60613          	addi	a2,a2,938 # ffffffffc020e5f8 <etext+0x2ffe>
ffffffffc020a256:	05300593          	li	a1,83
ffffffffc020a25a:	00004517          	auipc	a0,0x4
ffffffffc020a25e:	36e50513          	addi	a0,a0,878 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a262:	9e8f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a266:	00004697          	auipc	a3,0x4
ffffffffc020a26a:	3ca68693          	addi	a3,a3,970 # ffffffffc020e630 <etext+0x3036>
ffffffffc020a26e:	00001617          	auipc	a2,0x1
ffffffffc020a272:	7ca60613          	addi	a2,a2,1994 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a276:	19500593          	li	a1,405
ffffffffc020a27a:	00004517          	auipc	a0,0x4
ffffffffc020a27e:	34e50513          	addi	a0,a0,846 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a282:	9c8f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a286 <sfs_getdirentry>:
ffffffffc020a286:	715d                	addi	sp,sp,-80
ffffffffc020a288:	f052                	sd	s4,32(sp)
ffffffffc020a28a:	8a2a                	mv	s4,a0
ffffffffc020a28c:	10400513          	li	a0,260
ffffffffc020a290:	e85a                	sd	s6,16(sp)
ffffffffc020a292:	e486                	sd	ra,72(sp)
ffffffffc020a294:	e0a2                	sd	s0,64(sp)
ffffffffc020a296:	8b2e                	mv	s6,a1
ffffffffc020a298:	db9f70ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc020a29c:	0e050963          	beqz	a0,ffffffffc020a38e <sfs_getdirentry+0x108>
ffffffffc020a2a0:	ec56                	sd	s5,24(sp)
ffffffffc020a2a2:	068a3a83          	ld	s5,104(s4)
ffffffffc020a2a6:	0e0a8663          	beqz	s5,ffffffffc020a392 <sfs_getdirentry+0x10c>
ffffffffc020a2aa:	0b0aa783          	lw	a5,176(s5)
ffffffffc020a2ae:	0e079263          	bnez	a5,ffffffffc020a392 <sfs_getdirentry+0x10c>
ffffffffc020a2b2:	058a2703          	lw	a4,88(s4)
ffffffffc020a2b6:	6785                	lui	a5,0x1
ffffffffc020a2b8:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a2bc:	10f71063          	bne	a4,a5,ffffffffc020a3bc <sfs_getdirentry+0x136>
ffffffffc020a2c0:	f44e                	sd	s3,40(sp)
ffffffffc020a2c2:	57fd                	li	a5,-1
ffffffffc020a2c4:	008b3983          	ld	s3,8(s6)
ffffffffc020a2c8:	17fe                	slli	a5,a5,0x3f
ffffffffc020a2ca:	0ff78793          	addi	a5,a5,255
ffffffffc020a2ce:	00f9f7b3          	and	a5,s3,a5
ffffffffc020a2d2:	e3d5                	bnez	a5,ffffffffc020a376 <sfs_getdirentry+0xf0>
ffffffffc020a2d4:	000a3783          	ld	a5,0(s4)
ffffffffc020a2d8:	0089d993          	srli	s3,s3,0x8
ffffffffc020a2dc:	2981                	sext.w	s3,s3
ffffffffc020a2de:	479c                	lw	a5,8(a5)
ffffffffc020a2e0:	0b37e163          	bltu	a5,s3,ffffffffc020a382 <sfs_getdirentry+0xfc>
ffffffffc020a2e4:	f84a                	sd	s2,48(sp)
ffffffffc020a2e6:	892a                	mv	s2,a0
ffffffffc020a2e8:	020a0513          	addi	a0,s4,32
ffffffffc020a2ec:	e45e                	sd	s7,8(sp)
ffffffffc020a2ee:	92afa0ef          	jal	ffffffffc0204418 <down>
ffffffffc020a2f2:	000a3783          	ld	a5,0(s4)
ffffffffc020a2f6:	0087ab83          	lw	s7,8(a5)
ffffffffc020a2fa:	07705c63          	blez	s7,ffffffffc020a372 <sfs_getdirentry+0xec>
ffffffffc020a2fe:	fc26                	sd	s1,56(sp)
ffffffffc020a300:	4481                	li	s1,0
ffffffffc020a302:	a811                	j	ffffffffc020a316 <sfs_getdirentry+0x90>
ffffffffc020a304:	00092783          	lw	a5,0(s2)
ffffffffc020a308:	c781                	beqz	a5,ffffffffc020a310 <sfs_getdirentry+0x8a>
ffffffffc020a30a:	02098463          	beqz	s3,ffffffffc020a332 <sfs_getdirentry+0xac>
ffffffffc020a30e:	39fd                	addiw	s3,s3,-1
ffffffffc020a310:	2485                	addiw	s1,s1,1
ffffffffc020a312:	049b8d63          	beq	s7,s1,ffffffffc020a36c <sfs_getdirentry+0xe6>
ffffffffc020a316:	86ca                	mv	a3,s2
ffffffffc020a318:	8626                	mv	a2,s1
ffffffffc020a31a:	85d2                	mv	a1,s4
ffffffffc020a31c:	8556                	mv	a0,s5
ffffffffc020a31e:	ea9ff0ef          	jal	ffffffffc020a1c6 <sfs_dirent_read_nolock>
ffffffffc020a322:	842a                	mv	s0,a0
ffffffffc020a324:	d165                	beqz	a0,ffffffffc020a304 <sfs_getdirentry+0x7e>
ffffffffc020a326:	74e2                	ld	s1,56(sp)
ffffffffc020a328:	020a0513          	addi	a0,s4,32
ffffffffc020a32c:	8e8fa0ef          	jal	ffffffffc0204414 <up>
ffffffffc020a330:	a005                	j	ffffffffc020a350 <sfs_getdirentry+0xca>
ffffffffc020a332:	020a0513          	addi	a0,s4,32
ffffffffc020a336:	8defa0ef          	jal	ffffffffc0204414 <up>
ffffffffc020a33a:	855a                	mv	a0,s6
ffffffffc020a33c:	00490593          	addi	a1,s2,4
ffffffffc020a340:	4701                	li	a4,0
ffffffffc020a342:	4685                	li	a3,1
ffffffffc020a344:	10000613          	li	a2,256
ffffffffc020a348:	f71fa0ef          	jal	ffffffffc02052b8 <iobuf_move>
ffffffffc020a34c:	74e2                	ld	s1,56(sp)
ffffffffc020a34e:	842a                	mv	s0,a0
ffffffffc020a350:	854a                	mv	a0,s2
ffffffffc020a352:	da5f70ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc020a356:	7942                	ld	s2,48(sp)
ffffffffc020a358:	79a2                	ld	s3,40(sp)
ffffffffc020a35a:	6ae2                	ld	s5,24(sp)
ffffffffc020a35c:	6ba2                	ld	s7,8(sp)
ffffffffc020a35e:	60a6                	ld	ra,72(sp)
ffffffffc020a360:	8522                	mv	a0,s0
ffffffffc020a362:	6406                	ld	s0,64(sp)
ffffffffc020a364:	7a02                	ld	s4,32(sp)
ffffffffc020a366:	6b42                	ld	s6,16(sp)
ffffffffc020a368:	6161                	addi	sp,sp,80
ffffffffc020a36a:	8082                	ret
ffffffffc020a36c:	74e2                	ld	s1,56(sp)
ffffffffc020a36e:	5441                	li	s0,-16
ffffffffc020a370:	bf65                	j	ffffffffc020a328 <sfs_getdirentry+0xa2>
ffffffffc020a372:	5441                	li	s0,-16
ffffffffc020a374:	bf55                	j	ffffffffc020a328 <sfs_getdirentry+0xa2>
ffffffffc020a376:	d81f70ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc020a37a:	5475                	li	s0,-3
ffffffffc020a37c:	79a2                	ld	s3,40(sp)
ffffffffc020a37e:	6ae2                	ld	s5,24(sp)
ffffffffc020a380:	bff9                	j	ffffffffc020a35e <sfs_getdirentry+0xd8>
ffffffffc020a382:	d75f70ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc020a386:	5441                	li	s0,-16
ffffffffc020a388:	79a2                	ld	s3,40(sp)
ffffffffc020a38a:	6ae2                	ld	s5,24(sp)
ffffffffc020a38c:	bfc9                	j	ffffffffc020a35e <sfs_getdirentry+0xd8>
ffffffffc020a38e:	5471                	li	s0,-4
ffffffffc020a390:	b7f9                	j	ffffffffc020a35e <sfs_getdirentry+0xd8>
ffffffffc020a392:	00004697          	auipc	a3,0x4
ffffffffc020a396:	05668693          	addi	a3,a3,86 # ffffffffc020e3e8 <etext+0x2dee>
ffffffffc020a39a:	00001617          	auipc	a2,0x1
ffffffffc020a39e:	69e60613          	addi	a2,a2,1694 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a3a2:	33d00593          	li	a1,829
ffffffffc020a3a6:	00004517          	auipc	a0,0x4
ffffffffc020a3aa:	22250513          	addi	a0,a0,546 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a3ae:	fc26                	sd	s1,56(sp)
ffffffffc020a3b0:	f84a                	sd	s2,48(sp)
ffffffffc020a3b2:	f44e                	sd	s3,40(sp)
ffffffffc020a3b4:	e45e                	sd	s7,8(sp)
ffffffffc020a3b6:	e062                	sd	s8,0(sp)
ffffffffc020a3b8:	892f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a3bc:	00004697          	auipc	a3,0x4
ffffffffc020a3c0:	1d468693          	addi	a3,a3,468 # ffffffffc020e590 <etext+0x2f96>
ffffffffc020a3c4:	00001617          	auipc	a2,0x1
ffffffffc020a3c8:	67460613          	addi	a2,a2,1652 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a3cc:	33e00593          	li	a1,830
ffffffffc020a3d0:	00004517          	auipc	a0,0x4
ffffffffc020a3d4:	1f850513          	addi	a0,a0,504 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a3d8:	fc26                	sd	s1,56(sp)
ffffffffc020a3da:	f84a                	sd	s2,48(sp)
ffffffffc020a3dc:	f44e                	sd	s3,40(sp)
ffffffffc020a3de:	e45e                	sd	s7,8(sp)
ffffffffc020a3e0:	e062                	sd	s8,0(sp)
ffffffffc020a3e2:	868f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a3e6 <sfs_truncfile>:
ffffffffc020a3e6:	080007b7          	lui	a5,0x8000
ffffffffc020a3ea:	1ab7eb63          	bltu	a5,a1,ffffffffc020a5a0 <sfs_truncfile+0x1ba>
ffffffffc020a3ee:	7159                	addi	sp,sp,-112
ffffffffc020a3f0:	e0d2                	sd	s4,64(sp)
ffffffffc020a3f2:	06853a03          	ld	s4,104(a0)
ffffffffc020a3f6:	e8ca                	sd	s2,80(sp)
ffffffffc020a3f8:	e4ce                	sd	s3,72(sp)
ffffffffc020a3fa:	f486                	sd	ra,104(sp)
ffffffffc020a3fc:	f0a2                	sd	s0,96(sp)
ffffffffc020a3fe:	fc56                	sd	s5,56(sp)
ffffffffc020a400:	892a                	mv	s2,a0
ffffffffc020a402:	89ae                	mv	s3,a1
ffffffffc020a404:	1a0a0163          	beqz	s4,ffffffffc020a5a6 <sfs_truncfile+0x1c0>
ffffffffc020a408:	0b0a2783          	lw	a5,176(s4)
ffffffffc020a40c:	18079d63          	bnez	a5,ffffffffc020a5a6 <sfs_truncfile+0x1c0>
ffffffffc020a410:	4d38                	lw	a4,88(a0)
ffffffffc020a412:	6785                	lui	a5,0x1
ffffffffc020a414:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a418:	6405                	lui	s0,0x1
ffffffffc020a41a:	1cf71963          	bne	a4,a5,ffffffffc020a5ec <sfs_truncfile+0x206>
ffffffffc020a41e:	00053a83          	ld	s5,0(a0)
ffffffffc020a422:	147d                	addi	s0,s0,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020a424:	942e                	add	s0,s0,a1
ffffffffc020a426:	000ae783          	lwu	a5,0(s5)
ffffffffc020a42a:	8031                	srli	s0,s0,0xc
ffffffffc020a42c:	2401                	sext.w	s0,s0
ffffffffc020a42e:	02b79063          	bne	a5,a1,ffffffffc020a44e <sfs_truncfile+0x68>
ffffffffc020a432:	008aa703          	lw	a4,8(s5)
ffffffffc020a436:	4781                	li	a5,0
ffffffffc020a438:	1c871c63          	bne	a4,s0,ffffffffc020a610 <sfs_truncfile+0x22a>
ffffffffc020a43c:	70a6                	ld	ra,104(sp)
ffffffffc020a43e:	7406                	ld	s0,96(sp)
ffffffffc020a440:	6946                	ld	s2,80(sp)
ffffffffc020a442:	69a6                	ld	s3,72(sp)
ffffffffc020a444:	6a06                	ld	s4,64(sp)
ffffffffc020a446:	7ae2                	ld	s5,56(sp)
ffffffffc020a448:	853e                	mv	a0,a5
ffffffffc020a44a:	6165                	addi	sp,sp,112
ffffffffc020a44c:	8082                	ret
ffffffffc020a44e:	02050513          	addi	a0,a0,32
ffffffffc020a452:	eca6                	sd	s1,88(sp)
ffffffffc020a454:	fc5f90ef          	jal	ffffffffc0204418 <down>
ffffffffc020a458:	008aa483          	lw	s1,8(s5)
ffffffffc020a45c:	0c84e363          	bltu	s1,s0,ffffffffc020a522 <sfs_truncfile+0x13c>
ffffffffc020a460:	0c947e63          	bgeu	s0,s1,ffffffffc020a53c <sfs_truncfile+0x156>
ffffffffc020a464:	48ad                	li	a7,11
ffffffffc020a466:	4305                	li	t1,1
ffffffffc020a468:	a895                	j	ffffffffc020a4dc <sfs_truncfile+0xf6>
ffffffffc020a46a:	37cd                	addiw	a5,a5,-13
ffffffffc020a46c:	3ff00693          	li	a3,1023
ffffffffc020a470:	04f6ef63          	bltu	a3,a5,ffffffffc020a4ce <sfs_truncfile+0xe8>
ffffffffc020a474:	03c82683          	lw	a3,60(a6)
ffffffffc020a478:	cab9                	beqz	a3,ffffffffc020a4ce <sfs_truncfile+0xe8>
ffffffffc020a47a:	004a2603          	lw	a2,4(s4)
ffffffffc020a47e:	1ac6fb63          	bgeu	a3,a2,ffffffffc020a634 <sfs_truncfile+0x24e>
ffffffffc020a482:	038a3503          	ld	a0,56(s4)
ffffffffc020a486:	85b6                	mv	a1,a3
ffffffffc020a488:	e436                	sd	a3,8(sp)
ffffffffc020a48a:	e842                	sd	a6,16(sp)
ffffffffc020a48c:	ec3e                	sd	a5,24(sp)
ffffffffc020a48e:	baffe0ef          	jal	ffffffffc020903c <bitmap_test>
ffffffffc020a492:	66a2                	ld	a3,8(sp)
ffffffffc020a494:	6842                	ld	a6,16(sp)
ffffffffc020a496:	67e2                	ld	a5,24(sp)
ffffffffc020a498:	1a051d63          	bnez	a0,ffffffffc020a652 <sfs_truncfile+0x26c>
ffffffffc020a49c:	02079613          	slli	a2,a5,0x20
ffffffffc020a4a0:	01e65713          	srli	a4,a2,0x1e
ffffffffc020a4a4:	102c                	addi	a1,sp,40
ffffffffc020a4a6:	4611                	li	a2,4
ffffffffc020a4a8:	8552                	mv	a0,s4
ffffffffc020a4aa:	ec42                	sd	a6,24(sp)
ffffffffc020a4ac:	e83a                	sd	a4,16(sp)
ffffffffc020a4ae:	e436                	sd	a3,8(sp)
ffffffffc020a4b0:	d602                	sw	zero,44(sp)
ffffffffc020a4b2:	151000ef          	jal	ffffffffc020ae02 <sfs_rbuf>
ffffffffc020a4b6:	87aa                	mv	a5,a0
ffffffffc020a4b8:	e941                	bnez	a0,ffffffffc020a548 <sfs_truncfile+0x162>
ffffffffc020a4ba:	57a2                	lw	a5,40(sp)
ffffffffc020a4bc:	66a2                	ld	a3,8(sp)
ffffffffc020a4be:	6742                	ld	a4,16(sp)
ffffffffc020a4c0:	6862                	ld	a6,24(sp)
ffffffffc020a4c2:	48ad                	li	a7,11
ffffffffc020a4c4:	4305                	li	t1,1
ffffffffc020a4c6:	ebd5                	bnez	a5,ffffffffc020a57a <sfs_truncfile+0x194>
ffffffffc020a4c8:	00882703          	lw	a4,8(a6)
ffffffffc020a4cc:	377d                	addiw	a4,a4,-1 # 7ffffff <_binary_bin_sfs_img_size+0x7f8acff>
ffffffffc020a4ce:	00e82423          	sw	a4,8(a6)
ffffffffc020a4d2:	00693823          	sd	t1,16(s2)
ffffffffc020a4d6:	34fd                	addiw	s1,s1,-1
ffffffffc020a4d8:	04940e63          	beq	s0,s1,ffffffffc020a534 <sfs_truncfile+0x14e>
ffffffffc020a4dc:	00093803          	ld	a6,0(s2)
ffffffffc020a4e0:	00882783          	lw	a5,8(a6)
ffffffffc020a4e4:	0e078363          	beqz	a5,ffffffffc020a5ca <sfs_truncfile+0x1e4>
ffffffffc020a4e8:	fff7871b          	addiw	a4,a5,-1
ffffffffc020a4ec:	f6e8efe3          	bltu	a7,a4,ffffffffc020a46a <sfs_truncfile+0x84>
ffffffffc020a4f0:	02071693          	slli	a3,a4,0x20
ffffffffc020a4f4:	01e6d793          	srli	a5,a3,0x1e
ffffffffc020a4f8:	97c2                	add	a5,a5,a6
ffffffffc020a4fa:	47cc                	lw	a1,12(a5)
ffffffffc020a4fc:	d9e9                	beqz	a1,ffffffffc020a4ce <sfs_truncfile+0xe8>
ffffffffc020a4fe:	8552                	mv	a0,s4
ffffffffc020a500:	e83e                	sd	a5,16(sp)
ffffffffc020a502:	e442                	sd	a6,8(sp)
ffffffffc020a504:	c68ff0ef          	jal	ffffffffc020996c <sfs_block_free>
ffffffffc020a508:	67c2                	ld	a5,16(sp)
ffffffffc020a50a:	6822                	ld	a6,8(sp)
ffffffffc020a50c:	48ad                	li	a7,11
ffffffffc020a50e:	0007a623          	sw	zero,12(a5)
ffffffffc020a512:	00882703          	lw	a4,8(a6)
ffffffffc020a516:	4305                	li	t1,1
ffffffffc020a518:	377d                	addiw	a4,a4,-1
ffffffffc020a51a:	bf55                	j	ffffffffc020a4ce <sfs_truncfile+0xe8>
ffffffffc020a51c:	2485                	addiw	s1,s1,1
ffffffffc020a51e:	00940b63          	beq	s0,s1,ffffffffc020a534 <sfs_truncfile+0x14e>
ffffffffc020a522:	4681                	li	a3,0
ffffffffc020a524:	8626                	mv	a2,s1
ffffffffc020a526:	85ca                	mv	a1,s2
ffffffffc020a528:	8552                	mv	a0,s4
ffffffffc020a52a:	efeff0ef          	jal	ffffffffc0209c28 <sfs_bmap_load_nolock>
ffffffffc020a52e:	87aa                	mv	a5,a0
ffffffffc020a530:	d575                	beqz	a0,ffffffffc020a51c <sfs_truncfile+0x136>
ffffffffc020a532:	a819                	j	ffffffffc020a548 <sfs_truncfile+0x162>
ffffffffc020a534:	008aa783          	lw	a5,8(s5)
ffffffffc020a538:	02879063          	bne	a5,s0,ffffffffc020a558 <sfs_truncfile+0x172>
ffffffffc020a53c:	4785                	li	a5,1
ffffffffc020a53e:	013aa023          	sw	s3,0(s5)
ffffffffc020a542:	00f93823          	sd	a5,16(s2)
ffffffffc020a546:	4781                	li	a5,0
ffffffffc020a548:	02090513          	addi	a0,s2,32
ffffffffc020a54c:	e43e                	sd	a5,8(sp)
ffffffffc020a54e:	ec7f90ef          	jal	ffffffffc0204414 <up>
ffffffffc020a552:	67a2                	ld	a5,8(sp)
ffffffffc020a554:	64e6                	ld	s1,88(sp)
ffffffffc020a556:	b5dd                	j	ffffffffc020a43c <sfs_truncfile+0x56>
ffffffffc020a558:	00004697          	auipc	a3,0x4
ffffffffc020a55c:	2b868693          	addi	a3,a3,696 # ffffffffc020e810 <etext+0x3216>
ffffffffc020a560:	00001617          	auipc	a2,0x1
ffffffffc020a564:	4d860613          	addi	a2,a2,1240 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a568:	3cd00593          	li	a1,973
ffffffffc020a56c:	00004517          	auipc	a0,0x4
ffffffffc020a570:	05c50513          	addi	a0,a0,92 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a574:	f85a                	sd	s6,48(sp)
ffffffffc020a576:	ed5f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a57a:	4611                	li	a2,4
ffffffffc020a57c:	106c                	addi	a1,sp,44
ffffffffc020a57e:	8552                	mv	a0,s4
ffffffffc020a580:	e442                	sd	a6,8(sp)
ffffffffc020a582:	101000ef          	jal	ffffffffc020ae82 <sfs_wbuf>
ffffffffc020a586:	87aa                	mv	a5,a0
ffffffffc020a588:	f161                	bnez	a0,ffffffffc020a548 <sfs_truncfile+0x162>
ffffffffc020a58a:	55a2                	lw	a1,40(sp)
ffffffffc020a58c:	8552                	mv	a0,s4
ffffffffc020a58e:	bdeff0ef          	jal	ffffffffc020996c <sfs_block_free>
ffffffffc020a592:	6822                	ld	a6,8(sp)
ffffffffc020a594:	4305                	li	t1,1
ffffffffc020a596:	48ad                	li	a7,11
ffffffffc020a598:	00882703          	lw	a4,8(a6)
ffffffffc020a59c:	377d                	addiw	a4,a4,-1
ffffffffc020a59e:	bf05                	j	ffffffffc020a4ce <sfs_truncfile+0xe8>
ffffffffc020a5a0:	57f5                	li	a5,-3
ffffffffc020a5a2:	853e                	mv	a0,a5
ffffffffc020a5a4:	8082                	ret
ffffffffc020a5a6:	00004697          	auipc	a3,0x4
ffffffffc020a5aa:	e4268693          	addi	a3,a3,-446 # ffffffffc020e3e8 <etext+0x2dee>
ffffffffc020a5ae:	00001617          	auipc	a2,0x1
ffffffffc020a5b2:	48a60613          	addi	a2,a2,1162 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a5b6:	3ac00593          	li	a1,940
ffffffffc020a5ba:	00004517          	auipc	a0,0x4
ffffffffc020a5be:	00e50513          	addi	a0,a0,14 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a5c2:	eca6                	sd	s1,88(sp)
ffffffffc020a5c4:	f85a                	sd	s6,48(sp)
ffffffffc020a5c6:	e85f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a5ca:	00004697          	auipc	a3,0x4
ffffffffc020a5ce:	1f668693          	addi	a3,a3,502 # ffffffffc020e7c0 <etext+0x31c6>
ffffffffc020a5d2:	00001617          	auipc	a2,0x1
ffffffffc020a5d6:	46660613          	addi	a2,a2,1126 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a5da:	17b00593          	li	a1,379
ffffffffc020a5de:	00004517          	auipc	a0,0x4
ffffffffc020a5e2:	fea50513          	addi	a0,a0,-22 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a5e6:	f85a                	sd	s6,48(sp)
ffffffffc020a5e8:	e63f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a5ec:	00004697          	auipc	a3,0x4
ffffffffc020a5f0:	fa468693          	addi	a3,a3,-92 # ffffffffc020e590 <etext+0x2f96>
ffffffffc020a5f4:	00001617          	auipc	a2,0x1
ffffffffc020a5f8:	44460613          	addi	a2,a2,1092 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a5fc:	3ad00593          	li	a1,941
ffffffffc020a600:	00004517          	auipc	a0,0x4
ffffffffc020a604:	fc850513          	addi	a0,a0,-56 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a608:	eca6                	sd	s1,88(sp)
ffffffffc020a60a:	f85a                	sd	s6,48(sp)
ffffffffc020a60c:	e3ff50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a610:	00004697          	auipc	a3,0x4
ffffffffc020a614:	19868693          	addi	a3,a3,408 # ffffffffc020e7a8 <etext+0x31ae>
ffffffffc020a618:	00001617          	auipc	a2,0x1
ffffffffc020a61c:	42060613          	addi	a2,a2,1056 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a620:	3b400593          	li	a1,948
ffffffffc020a624:	00004517          	auipc	a0,0x4
ffffffffc020a628:	fa450513          	addi	a0,a0,-92 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a62c:	eca6                	sd	s1,88(sp)
ffffffffc020a62e:	f85a                	sd	s6,48(sp)
ffffffffc020a630:	e1bf50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a634:	8736                	mv	a4,a3
ffffffffc020a636:	05300593          	li	a1,83
ffffffffc020a63a:	86b2                	mv	a3,a2
ffffffffc020a63c:	00004517          	auipc	a0,0x4
ffffffffc020a640:	f8c50513          	addi	a0,a0,-116 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a644:	00004617          	auipc	a2,0x4
ffffffffc020a648:	fb460613          	addi	a2,a2,-76 # ffffffffc020e5f8 <etext+0x2ffe>
ffffffffc020a64c:	f85a                	sd	s6,48(sp)
ffffffffc020a64e:	dfdf50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a652:	00004697          	auipc	a3,0x4
ffffffffc020a656:	18668693          	addi	a3,a3,390 # ffffffffc020e7d8 <etext+0x31de>
ffffffffc020a65a:	00001617          	auipc	a2,0x1
ffffffffc020a65e:	3de60613          	addi	a2,a2,990 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a662:	12b00593          	li	a1,299
ffffffffc020a666:	00004517          	auipc	a0,0x4
ffffffffc020a66a:	f6250513          	addi	a0,a0,-158 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a66e:	f85a                	sd	s6,48(sp)
ffffffffc020a670:	ddbf50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a674 <sfs_load_inode>:
ffffffffc020a674:	7139                	addi	sp,sp,-64
ffffffffc020a676:	fc06                	sd	ra,56(sp)
ffffffffc020a678:	f822                	sd	s0,48(sp)
ffffffffc020a67a:	f426                	sd	s1,40(sp)
ffffffffc020a67c:	f04a                	sd	s2,32(sp)
ffffffffc020a67e:	84b2                	mv	s1,a2
ffffffffc020a680:	892a                	mv	s2,a0
ffffffffc020a682:	ec4e                	sd	s3,24(sp)
ffffffffc020a684:	89ae                	mv	s3,a1
ffffffffc020a686:	1b1000ef          	jal	ffffffffc020b036 <lock_sfs_fs>
ffffffffc020a68a:	8526                	mv	a0,s1
ffffffffc020a68c:	45a9                	li	a1,10
ffffffffc020a68e:	0a893403          	ld	s0,168(s2)
ffffffffc020a692:	1c5000ef          	jal	ffffffffc020b056 <hash32>
ffffffffc020a696:	02051793          	slli	a5,a0,0x20
ffffffffc020a69a:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020a69e:	00a406b3          	add	a3,s0,a0
ffffffffc020a6a2:	87b6                	mv	a5,a3
ffffffffc020a6a4:	a029                	j	ffffffffc020a6ae <sfs_load_inode+0x3a>
ffffffffc020a6a6:	fc07a703          	lw	a4,-64(a5)
ffffffffc020a6aa:	10970563          	beq	a4,s1,ffffffffc020a7b4 <sfs_load_inode+0x140>
ffffffffc020a6ae:	679c                	ld	a5,8(a5)
ffffffffc020a6b0:	fef69be3          	bne	a3,a5,ffffffffc020a6a6 <sfs_load_inode+0x32>
ffffffffc020a6b4:	04000513          	li	a0,64
ffffffffc020a6b8:	999f70ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc020a6bc:	87aa                	mv	a5,a0
ffffffffc020a6be:	10050b63          	beqz	a0,ffffffffc020a7d4 <sfs_load_inode+0x160>
ffffffffc020a6c2:	14048f63          	beqz	s1,ffffffffc020a820 <sfs_load_inode+0x1ac>
ffffffffc020a6c6:	00492703          	lw	a4,4(s2)
ffffffffc020a6ca:	14e4fb63          	bgeu	s1,a4,ffffffffc020a820 <sfs_load_inode+0x1ac>
ffffffffc020a6ce:	03893503          	ld	a0,56(s2)
ffffffffc020a6d2:	85a6                	mv	a1,s1
ffffffffc020a6d4:	e43e                	sd	a5,8(sp)
ffffffffc020a6d6:	967fe0ef          	jal	ffffffffc020903c <bitmap_test>
ffffffffc020a6da:	16051263          	bnez	a0,ffffffffc020a83e <sfs_load_inode+0x1ca>
ffffffffc020a6de:	65a2                	ld	a1,8(sp)
ffffffffc020a6e0:	4701                	li	a4,0
ffffffffc020a6e2:	86a6                	mv	a3,s1
ffffffffc020a6e4:	04000613          	li	a2,64
ffffffffc020a6e8:	854a                	mv	a0,s2
ffffffffc020a6ea:	718000ef          	jal	ffffffffc020ae02 <sfs_rbuf>
ffffffffc020a6ee:	67a2                	ld	a5,8(sp)
ffffffffc020a6f0:	842a                	mv	s0,a0
ffffffffc020a6f2:	0e051e63          	bnez	a0,ffffffffc020a7ee <sfs_load_inode+0x17a>
ffffffffc020a6f6:	0067d703          	lhu	a4,6(a5)
ffffffffc020a6fa:	10070363          	beqz	a4,ffffffffc020a800 <sfs_load_inode+0x18c>
ffffffffc020a6fe:	6505                	lui	a0,0x1
ffffffffc020a700:	23550513          	addi	a0,a0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a704:	e43e                	sd	a5,8(sp)
ffffffffc020a706:	8acfd0ef          	jal	ffffffffc02077b2 <__alloc_inode>
ffffffffc020a70a:	67a2                	ld	a5,8(sp)
ffffffffc020a70c:	842a                	mv	s0,a0
ffffffffc020a70e:	cd79                	beqz	a0,ffffffffc020a7ec <sfs_load_inode+0x178>
ffffffffc020a710:	0047d683          	lhu	a3,4(a5)
ffffffffc020a714:	4705                	li	a4,1
ffffffffc020a716:	0ee68063          	beq	a3,a4,ffffffffc020a7f6 <sfs_load_inode+0x182>
ffffffffc020a71a:	4709                	li	a4,2
ffffffffc020a71c:	00005597          	auipc	a1,0x5
ffffffffc020a720:	e6c58593          	addi	a1,a1,-404 # ffffffffc020f588 <sfs_node_dirops>
ffffffffc020a724:	16e69d63          	bne	a3,a4,ffffffffc020a89e <sfs_load_inode+0x22a>
ffffffffc020a728:	864a                	mv	a2,s2
ffffffffc020a72a:	8522                	mv	a0,s0
ffffffffc020a72c:	e43e                	sd	a5,8(sp)
ffffffffc020a72e:	8a0fd0ef          	jal	ffffffffc02077ce <inode_init>
ffffffffc020a732:	4c34                	lw	a3,88(s0)
ffffffffc020a734:	6705                	lui	a4,0x1
ffffffffc020a736:	23570713          	addi	a4,a4,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a73a:	67a2                	ld	a5,8(sp)
ffffffffc020a73c:	14e69163          	bne	a3,a4,ffffffffc020a87e <sfs_load_inode+0x20a>
ffffffffc020a740:	4585                	li	a1,1
ffffffffc020a742:	e01c                	sd	a5,0(s0)
ffffffffc020a744:	c404                	sw	s1,8(s0)
ffffffffc020a746:	00043823          	sd	zero,16(s0)
ffffffffc020a74a:	cc0c                	sw	a1,24(s0)
ffffffffc020a74c:	02040513          	addi	a0,s0,32
ffffffffc020a750:	e436                	sd	a3,8(sp)
ffffffffc020a752:	cbdf90ef          	jal	ffffffffc020440e <sem_init>
ffffffffc020a756:	4c3c                	lw	a5,88(s0)
ffffffffc020a758:	66a2                	ld	a3,8(sp)
ffffffffc020a75a:	10d79263          	bne	a5,a3,ffffffffc020a85e <sfs_load_inode+0x1ea>
ffffffffc020a75e:	0a093703          	ld	a4,160(s2)
ffffffffc020a762:	03840793          	addi	a5,s0,56
ffffffffc020a766:	4408                	lw	a0,8(s0)
ffffffffc020a768:	e31c                	sd	a5,0(a4)
ffffffffc020a76a:	0af93023          	sd	a5,160(s2)
ffffffffc020a76e:	09890793          	addi	a5,s2,152
ffffffffc020a772:	e038                	sd	a4,64(s0)
ffffffffc020a774:	fc1c                	sd	a5,56(s0)
ffffffffc020a776:	45a9                	li	a1,10
ffffffffc020a778:	0a893483          	ld	s1,168(s2)
ffffffffc020a77c:	0db000ef          	jal	ffffffffc020b056 <hash32>
ffffffffc020a780:	02051713          	slli	a4,a0,0x20
ffffffffc020a784:	01c75793          	srli	a5,a4,0x1c
ffffffffc020a788:	97a6                	add	a5,a5,s1
ffffffffc020a78a:	6798                	ld	a4,8(a5)
ffffffffc020a78c:	04840693          	addi	a3,s0,72
ffffffffc020a790:	e314                	sd	a3,0(a4)
ffffffffc020a792:	e794                	sd	a3,8(a5)
ffffffffc020a794:	e838                	sd	a4,80(s0)
ffffffffc020a796:	e43c                	sd	a5,72(s0)
ffffffffc020a798:	854a                	mv	a0,s2
ffffffffc020a79a:	0ad000ef          	jal	ffffffffc020b046 <unlock_sfs_fs>
ffffffffc020a79e:	0089b023          	sd	s0,0(s3)
ffffffffc020a7a2:	4401                	li	s0,0
ffffffffc020a7a4:	70e2                	ld	ra,56(sp)
ffffffffc020a7a6:	8522                	mv	a0,s0
ffffffffc020a7a8:	7442                	ld	s0,48(sp)
ffffffffc020a7aa:	74a2                	ld	s1,40(sp)
ffffffffc020a7ac:	7902                	ld	s2,32(sp)
ffffffffc020a7ae:	69e2                	ld	s3,24(sp)
ffffffffc020a7b0:	6121                	addi	sp,sp,64
ffffffffc020a7b2:	8082                	ret
ffffffffc020a7b4:	fb878413          	addi	s0,a5,-72
ffffffffc020a7b8:	8522                	mv	a0,s0
ffffffffc020a7ba:	e43e                	sd	a5,8(sp)
ffffffffc020a7bc:	874fd0ef          	jal	ffffffffc0207830 <inode_ref_inc>
ffffffffc020a7c0:	4705                	li	a4,1
ffffffffc020a7c2:	67a2                	ld	a5,8(sp)
ffffffffc020a7c4:	fce51ae3          	bne	a0,a4,ffffffffc020a798 <sfs_load_inode+0x124>
ffffffffc020a7c8:	fd07a703          	lw	a4,-48(a5)
ffffffffc020a7cc:	2705                	addiw	a4,a4,1
ffffffffc020a7ce:	fce7a823          	sw	a4,-48(a5)
ffffffffc020a7d2:	b7d9                	j	ffffffffc020a798 <sfs_load_inode+0x124>
ffffffffc020a7d4:	5471                	li	s0,-4
ffffffffc020a7d6:	854a                	mv	a0,s2
ffffffffc020a7d8:	06f000ef          	jal	ffffffffc020b046 <unlock_sfs_fs>
ffffffffc020a7dc:	70e2                	ld	ra,56(sp)
ffffffffc020a7de:	8522                	mv	a0,s0
ffffffffc020a7e0:	7442                	ld	s0,48(sp)
ffffffffc020a7e2:	74a2                	ld	s1,40(sp)
ffffffffc020a7e4:	7902                	ld	s2,32(sp)
ffffffffc020a7e6:	69e2                	ld	s3,24(sp)
ffffffffc020a7e8:	6121                	addi	sp,sp,64
ffffffffc020a7ea:	8082                	ret
ffffffffc020a7ec:	5471                	li	s0,-4
ffffffffc020a7ee:	853e                	mv	a0,a5
ffffffffc020a7f0:	907f70ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc020a7f4:	b7cd                	j	ffffffffc020a7d6 <sfs_load_inode+0x162>
ffffffffc020a7f6:	00005597          	auipc	a1,0x5
ffffffffc020a7fa:	d1258593          	addi	a1,a1,-750 # ffffffffc020f508 <sfs_node_fileops>
ffffffffc020a7fe:	b72d                	j	ffffffffc020a728 <sfs_load_inode+0xb4>
ffffffffc020a800:	00004697          	auipc	a3,0x4
ffffffffc020a804:	02868693          	addi	a3,a3,40 # ffffffffc020e828 <etext+0x322e>
ffffffffc020a808:	00001617          	auipc	a2,0x1
ffffffffc020a80c:	23060613          	addi	a2,a2,560 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a810:	0ad00593          	li	a1,173
ffffffffc020a814:	00004517          	auipc	a0,0x4
ffffffffc020a818:	db450513          	addi	a0,a0,-588 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a81c:	c2ff50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a820:	00492683          	lw	a3,4(s2)
ffffffffc020a824:	8726                	mv	a4,s1
ffffffffc020a826:	00004617          	auipc	a2,0x4
ffffffffc020a82a:	dd260613          	addi	a2,a2,-558 # ffffffffc020e5f8 <etext+0x2ffe>
ffffffffc020a82e:	05300593          	li	a1,83
ffffffffc020a832:	00004517          	auipc	a0,0x4
ffffffffc020a836:	d9650513          	addi	a0,a0,-618 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a83a:	c11f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a83e:	00004697          	auipc	a3,0x4
ffffffffc020a842:	df268693          	addi	a3,a3,-526 # ffffffffc020e630 <etext+0x3036>
ffffffffc020a846:	00001617          	auipc	a2,0x1
ffffffffc020a84a:	1f260613          	addi	a2,a2,498 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a84e:	0a800593          	li	a1,168
ffffffffc020a852:	00004517          	auipc	a0,0x4
ffffffffc020a856:	d7650513          	addi	a0,a0,-650 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a85a:	bf1f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a85e:	00004697          	auipc	a3,0x4
ffffffffc020a862:	d3268693          	addi	a3,a3,-718 # ffffffffc020e590 <etext+0x2f96>
ffffffffc020a866:	00001617          	auipc	a2,0x1
ffffffffc020a86a:	1d260613          	addi	a2,a2,466 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a86e:	0b100593          	li	a1,177
ffffffffc020a872:	00004517          	auipc	a0,0x4
ffffffffc020a876:	d5650513          	addi	a0,a0,-682 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a87a:	bd1f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a87e:	00004697          	auipc	a3,0x4
ffffffffc020a882:	d1268693          	addi	a3,a3,-750 # ffffffffc020e590 <etext+0x2f96>
ffffffffc020a886:	00001617          	auipc	a2,0x1
ffffffffc020a88a:	1b260613          	addi	a2,a2,434 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a88e:	07700593          	li	a1,119
ffffffffc020a892:	00004517          	auipc	a0,0x4
ffffffffc020a896:	d3650513          	addi	a0,a0,-714 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a89a:	bb1f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a89e:	00004617          	auipc	a2,0x4
ffffffffc020a8a2:	d4260613          	addi	a2,a2,-702 # ffffffffc020e5e0 <etext+0x2fe6>
ffffffffc020a8a6:	02e00593          	li	a1,46
ffffffffc020a8aa:	00004517          	auipc	a0,0x4
ffffffffc020a8ae:	d1e50513          	addi	a0,a0,-738 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a8b2:	b99f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a8b6 <sfs_lookup_once.constprop.0>:
ffffffffc020a8b6:	711d                	addi	sp,sp,-96
ffffffffc020a8b8:	f852                	sd	s4,48(sp)
ffffffffc020a8ba:	8a2a                	mv	s4,a0
ffffffffc020a8bc:	02058513          	addi	a0,a1,32
ffffffffc020a8c0:	ec86                	sd	ra,88(sp)
ffffffffc020a8c2:	e0ca                	sd	s2,64(sp)
ffffffffc020a8c4:	f456                	sd	s5,40(sp)
ffffffffc020a8c6:	e862                	sd	s8,16(sp)
ffffffffc020a8c8:	8ab2                	mv	s5,a2
ffffffffc020a8ca:	892e                	mv	s2,a1
ffffffffc020a8cc:	8c36                	mv	s8,a3
ffffffffc020a8ce:	b4bf90ef          	jal	ffffffffc0204418 <down>
ffffffffc020a8d2:	8556                	mv	a0,s5
ffffffffc020a8d4:	40b000ef          	jal	ffffffffc020b4de <strlen>
ffffffffc020a8d8:	0ff00793          	li	a5,255
ffffffffc020a8dc:	0aa7e963          	bltu	a5,a0,ffffffffc020a98e <sfs_lookup_once.constprop.0+0xd8>
ffffffffc020a8e0:	10400513          	li	a0,260
ffffffffc020a8e4:	e4a6                	sd	s1,72(sp)
ffffffffc020a8e6:	f6af70ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc020a8ea:	84aa                	mv	s1,a0
ffffffffc020a8ec:	c959                	beqz	a0,ffffffffc020a982 <sfs_lookup_once.constprop.0+0xcc>
ffffffffc020a8ee:	00093783          	ld	a5,0(s2)
ffffffffc020a8f2:	fc4e                	sd	s3,56(sp)
ffffffffc020a8f4:	0087a983          	lw	s3,8(a5)
ffffffffc020a8f8:	05305d63          	blez	s3,ffffffffc020a952 <sfs_lookup_once.constprop.0+0x9c>
ffffffffc020a8fc:	e8a2                	sd	s0,80(sp)
ffffffffc020a8fe:	4401                	li	s0,0
ffffffffc020a900:	a821                	j	ffffffffc020a918 <sfs_lookup_once.constprop.0+0x62>
ffffffffc020a902:	409c                	lw	a5,0(s1)
ffffffffc020a904:	c799                	beqz	a5,ffffffffc020a912 <sfs_lookup_once.constprop.0+0x5c>
ffffffffc020a906:	00448593          	addi	a1,s1,4
ffffffffc020a90a:	8556                	mv	a0,s5
ffffffffc020a90c:	419000ef          	jal	ffffffffc020b524 <strcmp>
ffffffffc020a910:	c139                	beqz	a0,ffffffffc020a956 <sfs_lookup_once.constprop.0+0xa0>
ffffffffc020a912:	2405                	addiw	s0,s0,1
ffffffffc020a914:	02898e63          	beq	s3,s0,ffffffffc020a950 <sfs_lookup_once.constprop.0+0x9a>
ffffffffc020a918:	86a6                	mv	a3,s1
ffffffffc020a91a:	8622                	mv	a2,s0
ffffffffc020a91c:	85ca                	mv	a1,s2
ffffffffc020a91e:	8552                	mv	a0,s4
ffffffffc020a920:	8a7ff0ef          	jal	ffffffffc020a1c6 <sfs_dirent_read_nolock>
ffffffffc020a924:	87aa                	mv	a5,a0
ffffffffc020a926:	dd71                	beqz	a0,ffffffffc020a902 <sfs_lookup_once.constprop.0+0x4c>
ffffffffc020a928:	6446                	ld	s0,80(sp)
ffffffffc020a92a:	8526                	mv	a0,s1
ffffffffc020a92c:	e43e                	sd	a5,8(sp)
ffffffffc020a92e:	fc8f70ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc020a932:	02090513          	addi	a0,s2,32
ffffffffc020a936:	adff90ef          	jal	ffffffffc0204414 <up>
ffffffffc020a93a:	67a2                	ld	a5,8(sp)
ffffffffc020a93c:	79e2                	ld	s3,56(sp)
ffffffffc020a93e:	60e6                	ld	ra,88(sp)
ffffffffc020a940:	64a6                	ld	s1,72(sp)
ffffffffc020a942:	6906                	ld	s2,64(sp)
ffffffffc020a944:	7a42                	ld	s4,48(sp)
ffffffffc020a946:	7aa2                	ld	s5,40(sp)
ffffffffc020a948:	6c42                	ld	s8,16(sp)
ffffffffc020a94a:	853e                	mv	a0,a5
ffffffffc020a94c:	6125                	addi	sp,sp,96
ffffffffc020a94e:	8082                	ret
ffffffffc020a950:	6446                	ld	s0,80(sp)
ffffffffc020a952:	57c1                	li	a5,-16
ffffffffc020a954:	bfd9                	j	ffffffffc020a92a <sfs_lookup_once.constprop.0+0x74>
ffffffffc020a956:	8526                	mv	a0,s1
ffffffffc020a958:	4080                	lw	s0,0(s1)
ffffffffc020a95a:	f9cf70ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc020a95e:	02090513          	addi	a0,s2,32
ffffffffc020a962:	ab3f90ef          	jal	ffffffffc0204414 <up>
ffffffffc020a966:	8622                	mv	a2,s0
ffffffffc020a968:	6446                	ld	s0,80(sp)
ffffffffc020a96a:	64a6                	ld	s1,72(sp)
ffffffffc020a96c:	79e2                	ld	s3,56(sp)
ffffffffc020a96e:	60e6                	ld	ra,88(sp)
ffffffffc020a970:	6906                	ld	s2,64(sp)
ffffffffc020a972:	7aa2                	ld	s5,40(sp)
ffffffffc020a974:	85e2                	mv	a1,s8
ffffffffc020a976:	8552                	mv	a0,s4
ffffffffc020a978:	6c42                	ld	s8,16(sp)
ffffffffc020a97a:	7a42                	ld	s4,48(sp)
ffffffffc020a97c:	6125                	addi	sp,sp,96
ffffffffc020a97e:	cf7ff06f          	j	ffffffffc020a674 <sfs_load_inode>
ffffffffc020a982:	02090513          	addi	a0,s2,32
ffffffffc020a986:	a8ff90ef          	jal	ffffffffc0204414 <up>
ffffffffc020a98a:	57f1                	li	a5,-4
ffffffffc020a98c:	bf4d                	j	ffffffffc020a93e <sfs_lookup_once.constprop.0+0x88>
ffffffffc020a98e:	00004697          	auipc	a3,0x4
ffffffffc020a992:	eb268693          	addi	a3,a3,-334 # ffffffffc020e840 <etext+0x3246>
ffffffffc020a996:	00001617          	auipc	a2,0x1
ffffffffc020a99a:	0a260613          	addi	a2,a2,162 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020a99e:	1ba00593          	li	a1,442
ffffffffc020a9a2:	00004517          	auipc	a0,0x4
ffffffffc020a9a6:	c2650513          	addi	a0,a0,-986 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020a9aa:	e8a2                	sd	s0,80(sp)
ffffffffc020a9ac:	e4a6                	sd	s1,72(sp)
ffffffffc020a9ae:	fc4e                	sd	s3,56(sp)
ffffffffc020a9b0:	f05a                	sd	s6,32(sp)
ffffffffc020a9b2:	ec5e                	sd	s7,24(sp)
ffffffffc020a9b4:	a97f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a9b8 <sfs_namefile>:
ffffffffc020a9b8:	6d9c                	ld	a5,24(a1)
ffffffffc020a9ba:	7175                	addi	sp,sp,-144
ffffffffc020a9bc:	f86a                	sd	s10,48(sp)
ffffffffc020a9be:	e506                	sd	ra,136(sp)
ffffffffc020a9c0:	f46e                	sd	s11,40(sp)
ffffffffc020a9c2:	4d09                	li	s10,2
ffffffffc020a9c4:	1afd7763          	bgeu	s10,a5,ffffffffc020ab72 <sfs_namefile+0x1ba>
ffffffffc020a9c8:	f4ce                	sd	s3,104(sp)
ffffffffc020a9ca:	89aa                	mv	s3,a0
ffffffffc020a9cc:	10400513          	li	a0,260
ffffffffc020a9d0:	fca6                	sd	s1,120(sp)
ffffffffc020a9d2:	e42e                	sd	a1,8(sp)
ffffffffc020a9d4:	e7cf70ef          	jal	ffffffffc0202050 <kmalloc>
ffffffffc020a9d8:	84aa                	mv	s1,a0
ffffffffc020a9da:	18050a63          	beqz	a0,ffffffffc020ab6e <sfs_namefile+0x1b6>
ffffffffc020a9de:	f0d2                	sd	s4,96(sp)
ffffffffc020a9e0:	0689ba03          	ld	s4,104(s3)
ffffffffc020a9e4:	1e0a0c63          	beqz	s4,ffffffffc020abdc <sfs_namefile+0x224>
ffffffffc020a9e8:	0b0a2783          	lw	a5,176(s4)
ffffffffc020a9ec:	1e079863          	bnez	a5,ffffffffc020abdc <sfs_namefile+0x224>
ffffffffc020a9f0:	0589a703          	lw	a4,88(s3)
ffffffffc020a9f4:	6785                	lui	a5,0x1
ffffffffc020a9f6:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a9fa:	e03a                	sd	a4,0(sp)
ffffffffc020a9fc:	e122                	sd	s0,128(sp)
ffffffffc020a9fe:	f8ca                	sd	s2,112(sp)
ffffffffc020aa00:	ecd6                	sd	s5,88(sp)
ffffffffc020aa02:	e8da                	sd	s6,80(sp)
ffffffffc020aa04:	e4de                	sd	s7,72(sp)
ffffffffc020aa06:	e0e2                	sd	s8,64(sp)
ffffffffc020aa08:	1af71963          	bne	a4,a5,ffffffffc020abba <sfs_namefile+0x202>
ffffffffc020aa0c:	6722                	ld	a4,8(sp)
ffffffffc020aa0e:	854e                	mv	a0,s3
ffffffffc020aa10:	8b4e                	mv	s6,s3
ffffffffc020aa12:	6f1c                	ld	a5,24(a4)
ffffffffc020aa14:	00073a83          	ld	s5,0(a4)
ffffffffc020aa18:	ffe78c13          	addi	s8,a5,-2
ffffffffc020aa1c:	9abe                	add	s5,s5,a5
ffffffffc020aa1e:	e13fc0ef          	jal	ffffffffc0207830 <inode_ref_inc>
ffffffffc020aa22:	0834                	addi	a3,sp,24
ffffffffc020aa24:	00004617          	auipc	a2,0x4
ffffffffc020aa28:	e4460613          	addi	a2,a2,-444 # ffffffffc020e868 <etext+0x326e>
ffffffffc020aa2c:	85da                	mv	a1,s6
ffffffffc020aa2e:	8552                	mv	a0,s4
ffffffffc020aa30:	e87ff0ef          	jal	ffffffffc020a8b6 <sfs_lookup_once.constprop.0>
ffffffffc020aa34:	8daa                	mv	s11,a0
ffffffffc020aa36:	e94d                	bnez	a0,ffffffffc020aae8 <sfs_namefile+0x130>
ffffffffc020aa38:	854e                	mv	a0,s3
ffffffffc020aa3a:	008b2903          	lw	s2,8(s6)
ffffffffc020aa3e:	ec1fc0ef          	jal	ffffffffc02078fe <inode_ref_dec>
ffffffffc020aa42:	6462                	ld	s0,24(sp)
ffffffffc020aa44:	0f340563          	beq	s0,s3,ffffffffc020ab2e <sfs_namefile+0x176>
ffffffffc020aa48:	14040863          	beqz	s0,ffffffffc020ab98 <sfs_namefile+0x1e0>
ffffffffc020aa4c:	4c38                	lw	a4,88(s0)
ffffffffc020aa4e:	6782                	ld	a5,0(sp)
ffffffffc020aa50:	14f71463          	bne	a4,a5,ffffffffc020ab98 <sfs_namefile+0x1e0>
ffffffffc020aa54:	4418                	lw	a4,8(s0)
ffffffffc020aa56:	13270063          	beq	a4,s2,ffffffffc020ab76 <sfs_namefile+0x1be>
ffffffffc020aa5a:	6018                	ld	a4,0(s0)
ffffffffc020aa5c:	00475703          	lhu	a4,4(a4)
ffffffffc020aa60:	11a71b63          	bne	a4,s10,ffffffffc020ab76 <sfs_namefile+0x1be>
ffffffffc020aa64:	02040b93          	addi	s7,s0,32
ffffffffc020aa68:	855e                	mv	a0,s7
ffffffffc020aa6a:	9aff90ef          	jal	ffffffffc0204418 <down>
ffffffffc020aa6e:	6018                	ld	a4,0(s0)
ffffffffc020aa70:	00872983          	lw	s3,8(a4)
ffffffffc020aa74:	0b305763          	blez	s3,ffffffffc020ab22 <sfs_namefile+0x16a>
ffffffffc020aa78:	8b22                	mv	s6,s0
ffffffffc020aa7a:	a039                	j	ffffffffc020aa88 <sfs_namefile+0xd0>
ffffffffc020aa7c:	4098                	lw	a4,0(s1)
ffffffffc020aa7e:	01270e63          	beq	a4,s2,ffffffffc020aa9a <sfs_namefile+0xe2>
ffffffffc020aa82:	2d85                	addiw	s11,s11,1
ffffffffc020aa84:	09b98763          	beq	s3,s11,ffffffffc020ab12 <sfs_namefile+0x15a>
ffffffffc020aa88:	86a6                	mv	a3,s1
ffffffffc020aa8a:	866e                	mv	a2,s11
ffffffffc020aa8c:	85a2                	mv	a1,s0
ffffffffc020aa8e:	8552                	mv	a0,s4
ffffffffc020aa90:	f36ff0ef          	jal	ffffffffc020a1c6 <sfs_dirent_read_nolock>
ffffffffc020aa94:	872a                	mv	a4,a0
ffffffffc020aa96:	d17d                	beqz	a0,ffffffffc020aa7c <sfs_namefile+0xc4>
ffffffffc020aa98:	a8b5                	j	ffffffffc020ab14 <sfs_namefile+0x15c>
ffffffffc020aa9a:	855e                	mv	a0,s7
ffffffffc020aa9c:	979f90ef          	jal	ffffffffc0204414 <up>
ffffffffc020aaa0:	00448513          	addi	a0,s1,4
ffffffffc020aaa4:	23b000ef          	jal	ffffffffc020b4de <strlen>
ffffffffc020aaa8:	00150793          	addi	a5,a0,1
ffffffffc020aaac:	0afc6e63          	bltu	s8,a5,ffffffffc020ab68 <sfs_namefile+0x1b0>
ffffffffc020aab0:	fff54913          	not	s2,a0
ffffffffc020aab4:	862a                	mv	a2,a0
ffffffffc020aab6:	00448593          	addi	a1,s1,4
ffffffffc020aaba:	012a8533          	add	a0,s5,s2
ffffffffc020aabe:	40fc0c33          	sub	s8,s8,a5
ffffffffc020aac2:	321000ef          	jal	ffffffffc020b5e2 <memcpy>
ffffffffc020aac6:	02f00793          	li	a5,47
ffffffffc020aaca:	fefa8fa3          	sb	a5,-1(s5)
ffffffffc020aace:	0834                	addi	a3,sp,24
ffffffffc020aad0:	00004617          	auipc	a2,0x4
ffffffffc020aad4:	d9860613          	addi	a2,a2,-616 # ffffffffc020e868 <etext+0x326e>
ffffffffc020aad8:	85da                	mv	a1,s6
ffffffffc020aada:	8552                	mv	a0,s4
ffffffffc020aadc:	ddbff0ef          	jal	ffffffffc020a8b6 <sfs_lookup_once.constprop.0>
ffffffffc020aae0:	89a2                	mv	s3,s0
ffffffffc020aae2:	9aca                	add	s5,s5,s2
ffffffffc020aae4:	8daa                	mv	s11,a0
ffffffffc020aae6:	d929                	beqz	a0,ffffffffc020aa38 <sfs_namefile+0x80>
ffffffffc020aae8:	854e                	mv	a0,s3
ffffffffc020aaea:	e15fc0ef          	jal	ffffffffc02078fe <inode_ref_dec>
ffffffffc020aaee:	8526                	mv	a0,s1
ffffffffc020aaf0:	e06f70ef          	jal	ffffffffc02020f6 <kfree>
ffffffffc020aaf4:	640a                	ld	s0,128(sp)
ffffffffc020aaf6:	74e6                	ld	s1,120(sp)
ffffffffc020aaf8:	7946                	ld	s2,112(sp)
ffffffffc020aafa:	79a6                	ld	s3,104(sp)
ffffffffc020aafc:	7a06                	ld	s4,96(sp)
ffffffffc020aafe:	6ae6                	ld	s5,88(sp)
ffffffffc020ab00:	6b46                	ld	s6,80(sp)
ffffffffc020ab02:	6ba6                	ld	s7,72(sp)
ffffffffc020ab04:	6c06                	ld	s8,64(sp)
ffffffffc020ab06:	60aa                	ld	ra,136(sp)
ffffffffc020ab08:	7d42                	ld	s10,48(sp)
ffffffffc020ab0a:	856e                	mv	a0,s11
ffffffffc020ab0c:	7da2                	ld	s11,40(sp)
ffffffffc020ab0e:	6149                	addi	sp,sp,144
ffffffffc020ab10:	8082                	ret
ffffffffc020ab12:	5741                	li	a4,-16
ffffffffc020ab14:	855e                	mv	a0,s7
ffffffffc020ab16:	e03a                	sd	a4,0(sp)
ffffffffc020ab18:	89a2                	mv	s3,s0
ffffffffc020ab1a:	8fbf90ef          	jal	ffffffffc0204414 <up>
ffffffffc020ab1e:	6d82                	ld	s11,0(sp)
ffffffffc020ab20:	b7e1                	j	ffffffffc020aae8 <sfs_namefile+0x130>
ffffffffc020ab22:	855e                	mv	a0,s7
ffffffffc020ab24:	8f1f90ef          	jal	ffffffffc0204414 <up>
ffffffffc020ab28:	89a2                	mv	s3,s0
ffffffffc020ab2a:	5dc1                	li	s11,-16
ffffffffc020ab2c:	bf75                	j	ffffffffc020aae8 <sfs_namefile+0x130>
ffffffffc020ab2e:	854e                	mv	a0,s3
ffffffffc020ab30:	dcffc0ef          	jal	ffffffffc02078fe <inode_ref_dec>
ffffffffc020ab34:	6922                	ld	s2,8(sp)
ffffffffc020ab36:	85d6                	mv	a1,s5
ffffffffc020ab38:	01893403          	ld	s0,24(s2)
ffffffffc020ab3c:	00093503          	ld	a0,0(s2)
ffffffffc020ab40:	1479                	addi	s0,s0,-2
ffffffffc020ab42:	41840433          	sub	s0,s0,s8
ffffffffc020ab46:	8622                	mv	a2,s0
ffffffffc020ab48:	0505                	addi	a0,a0,1
ffffffffc020ab4a:	25b000ef          	jal	ffffffffc020b5a4 <memmove>
ffffffffc020ab4e:	02f00713          	li	a4,47
ffffffffc020ab52:	fee50fa3          	sb	a4,-1(a0)
ffffffffc020ab56:	00850733          	add	a4,a0,s0
ffffffffc020ab5a:	00070023          	sb	zero,0(a4)
ffffffffc020ab5e:	854a                	mv	a0,s2
ffffffffc020ab60:	85a2                	mv	a1,s0
ffffffffc020ab62:	fdafa0ef          	jal	ffffffffc020533c <iobuf_skip>
ffffffffc020ab66:	b761                	j	ffffffffc020aaee <sfs_namefile+0x136>
ffffffffc020ab68:	89a2                	mv	s3,s0
ffffffffc020ab6a:	5df1                	li	s11,-4
ffffffffc020ab6c:	bfb5                	j	ffffffffc020aae8 <sfs_namefile+0x130>
ffffffffc020ab6e:	74e6                	ld	s1,120(sp)
ffffffffc020ab70:	79a6                	ld	s3,104(sp)
ffffffffc020ab72:	5df1                	li	s11,-4
ffffffffc020ab74:	bf49                	j	ffffffffc020ab06 <sfs_namefile+0x14e>
ffffffffc020ab76:	00004697          	auipc	a3,0x4
ffffffffc020ab7a:	cfa68693          	addi	a3,a3,-774 # ffffffffc020e870 <etext+0x3276>
ffffffffc020ab7e:	00001617          	auipc	a2,0x1
ffffffffc020ab82:	eba60613          	addi	a2,a2,-326 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020ab86:	2fc00593          	li	a1,764
ffffffffc020ab8a:	00004517          	auipc	a0,0x4
ffffffffc020ab8e:	a3e50513          	addi	a0,a0,-1474 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020ab92:	fc66                	sd	s9,56(sp)
ffffffffc020ab94:	8b7f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ab98:	00004697          	auipc	a3,0x4
ffffffffc020ab9c:	9f868693          	addi	a3,a3,-1544 # ffffffffc020e590 <etext+0x2f96>
ffffffffc020aba0:	00001617          	auipc	a2,0x1
ffffffffc020aba4:	e9860613          	addi	a2,a2,-360 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020aba8:	2fb00593          	li	a1,763
ffffffffc020abac:	00004517          	auipc	a0,0x4
ffffffffc020abb0:	a1c50513          	addi	a0,a0,-1508 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020abb4:	fc66                	sd	s9,56(sp)
ffffffffc020abb6:	895f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020abba:	00004697          	auipc	a3,0x4
ffffffffc020abbe:	9d668693          	addi	a3,a3,-1578 # ffffffffc020e590 <etext+0x2f96>
ffffffffc020abc2:	00001617          	auipc	a2,0x1
ffffffffc020abc6:	e7660613          	addi	a2,a2,-394 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020abca:	2e800593          	li	a1,744
ffffffffc020abce:	00004517          	auipc	a0,0x4
ffffffffc020abd2:	9fa50513          	addi	a0,a0,-1542 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020abd6:	fc66                	sd	s9,56(sp)
ffffffffc020abd8:	873f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020abdc:	00004697          	auipc	a3,0x4
ffffffffc020abe0:	80c68693          	addi	a3,a3,-2036 # ffffffffc020e3e8 <etext+0x2dee>
ffffffffc020abe4:	00001617          	auipc	a2,0x1
ffffffffc020abe8:	e5460613          	addi	a2,a2,-428 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020abec:	2e700593          	li	a1,743
ffffffffc020abf0:	00004517          	auipc	a0,0x4
ffffffffc020abf4:	9d850513          	addi	a0,a0,-1576 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020abf8:	e122                	sd	s0,128(sp)
ffffffffc020abfa:	f8ca                	sd	s2,112(sp)
ffffffffc020abfc:	ecd6                	sd	s5,88(sp)
ffffffffc020abfe:	e8da                	sd	s6,80(sp)
ffffffffc020ac00:	e4de                	sd	s7,72(sp)
ffffffffc020ac02:	e0e2                	sd	s8,64(sp)
ffffffffc020ac04:	fc66                	sd	s9,56(sp)
ffffffffc020ac06:	845f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020ac0a <sfs_lookup>:
ffffffffc020ac0a:	7139                	addi	sp,sp,-64
ffffffffc020ac0c:	f426                	sd	s1,40(sp)
ffffffffc020ac0e:	7524                	ld	s1,104(a0)
ffffffffc020ac10:	fc06                	sd	ra,56(sp)
ffffffffc020ac12:	f822                	sd	s0,48(sp)
ffffffffc020ac14:	f04a                	sd	s2,32(sp)
ffffffffc020ac16:	c4b5                	beqz	s1,ffffffffc020ac82 <sfs_lookup+0x78>
ffffffffc020ac18:	0b04a783          	lw	a5,176(s1)
ffffffffc020ac1c:	e3bd                	bnez	a5,ffffffffc020ac82 <sfs_lookup+0x78>
ffffffffc020ac1e:	0005c783          	lbu	a5,0(a1)
ffffffffc020ac22:	c3c5                	beqz	a5,ffffffffc020acc2 <sfs_lookup+0xb8>
ffffffffc020ac24:	fd178793          	addi	a5,a5,-47
ffffffffc020ac28:	cfc9                	beqz	a5,ffffffffc020acc2 <sfs_lookup+0xb8>
ffffffffc020ac2a:	842a                	mv	s0,a0
ffffffffc020ac2c:	8932                	mv	s2,a2
ffffffffc020ac2e:	e42e                	sd	a1,8(sp)
ffffffffc020ac30:	c01fc0ef          	jal	ffffffffc0207830 <inode_ref_inc>
ffffffffc020ac34:	4c38                	lw	a4,88(s0)
ffffffffc020ac36:	6785                	lui	a5,0x1
ffffffffc020ac38:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020ac3c:	06f71363          	bne	a4,a5,ffffffffc020aca2 <sfs_lookup+0x98>
ffffffffc020ac40:	6018                	ld	a4,0(s0)
ffffffffc020ac42:	4789                	li	a5,2
ffffffffc020ac44:	00475703          	lhu	a4,4(a4)
ffffffffc020ac48:	02f71863          	bne	a4,a5,ffffffffc020ac78 <sfs_lookup+0x6e>
ffffffffc020ac4c:	6622                	ld	a2,8(sp)
ffffffffc020ac4e:	85a2                	mv	a1,s0
ffffffffc020ac50:	8526                	mv	a0,s1
ffffffffc020ac52:	0834                	addi	a3,sp,24
ffffffffc020ac54:	c63ff0ef          	jal	ffffffffc020a8b6 <sfs_lookup_once.constprop.0>
ffffffffc020ac58:	87aa                	mv	a5,a0
ffffffffc020ac5a:	8522                	mv	a0,s0
ffffffffc020ac5c:	843e                	mv	s0,a5
ffffffffc020ac5e:	ca1fc0ef          	jal	ffffffffc02078fe <inode_ref_dec>
ffffffffc020ac62:	e401                	bnez	s0,ffffffffc020ac6a <sfs_lookup+0x60>
ffffffffc020ac64:	67e2                	ld	a5,24(sp)
ffffffffc020ac66:	00f93023          	sd	a5,0(s2)
ffffffffc020ac6a:	70e2                	ld	ra,56(sp)
ffffffffc020ac6c:	8522                	mv	a0,s0
ffffffffc020ac6e:	7442                	ld	s0,48(sp)
ffffffffc020ac70:	74a2                	ld	s1,40(sp)
ffffffffc020ac72:	7902                	ld	s2,32(sp)
ffffffffc020ac74:	6121                	addi	sp,sp,64
ffffffffc020ac76:	8082                	ret
ffffffffc020ac78:	8522                	mv	a0,s0
ffffffffc020ac7a:	c85fc0ef          	jal	ffffffffc02078fe <inode_ref_dec>
ffffffffc020ac7e:	5439                	li	s0,-18
ffffffffc020ac80:	b7ed                	j	ffffffffc020ac6a <sfs_lookup+0x60>
ffffffffc020ac82:	00003697          	auipc	a3,0x3
ffffffffc020ac86:	76668693          	addi	a3,a3,1894 # ffffffffc020e3e8 <etext+0x2dee>
ffffffffc020ac8a:	00001617          	auipc	a2,0x1
ffffffffc020ac8e:	dae60613          	addi	a2,a2,-594 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020ac92:	3dd00593          	li	a1,989
ffffffffc020ac96:	00004517          	auipc	a0,0x4
ffffffffc020ac9a:	93250513          	addi	a0,a0,-1742 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020ac9e:	facf50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020aca2:	00004697          	auipc	a3,0x4
ffffffffc020aca6:	8ee68693          	addi	a3,a3,-1810 # ffffffffc020e590 <etext+0x2f96>
ffffffffc020acaa:	00001617          	auipc	a2,0x1
ffffffffc020acae:	d8e60613          	addi	a2,a2,-626 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020acb2:	3e000593          	li	a1,992
ffffffffc020acb6:	00004517          	auipc	a0,0x4
ffffffffc020acba:	91250513          	addi	a0,a0,-1774 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020acbe:	f8cf50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020acc2:	00004697          	auipc	a3,0x4
ffffffffc020acc6:	be668693          	addi	a3,a3,-1050 # ffffffffc020e8a8 <etext+0x32ae>
ffffffffc020acca:	00001617          	auipc	a2,0x1
ffffffffc020acce:	d6e60613          	addi	a2,a2,-658 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020acd2:	3de00593          	li	a1,990
ffffffffc020acd6:	00004517          	auipc	a0,0x4
ffffffffc020acda:	8f250513          	addi	a0,a0,-1806 # ffffffffc020e5c8 <etext+0x2fce>
ffffffffc020acde:	f6cf50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020ace2 <sfs_rwblock_nolock>:
ffffffffc020ace2:	7139                	addi	sp,sp,-64
ffffffffc020ace4:	f822                	sd	s0,48(sp)
ffffffffc020ace6:	f426                	sd	s1,40(sp)
ffffffffc020ace8:	fc06                	sd	ra,56(sp)
ffffffffc020acea:	842a                	mv	s0,a0
ffffffffc020acec:	84b6                	mv	s1,a3
ffffffffc020acee:	e219                	bnez	a2,ffffffffc020acf4 <sfs_rwblock_nolock+0x12>
ffffffffc020acf0:	8b05                	andi	a4,a4,1
ffffffffc020acf2:	e71d                	bnez	a4,ffffffffc020ad20 <sfs_rwblock_nolock+0x3e>
ffffffffc020acf4:	405c                	lw	a5,4(s0)
ffffffffc020acf6:	02f67563          	bgeu	a2,a5,ffffffffc020ad20 <sfs_rwblock_nolock+0x3e>
ffffffffc020acfa:	00c6161b          	slliw	a2,a2,0xc
ffffffffc020acfe:	02061693          	slli	a3,a2,0x20
ffffffffc020ad02:	9281                	srli	a3,a3,0x20
ffffffffc020ad04:	6605                	lui	a2,0x1
ffffffffc020ad06:	850a                	mv	a0,sp
ffffffffc020ad08:	da6fa0ef          	jal	ffffffffc02052ae <iobuf_init>
ffffffffc020ad0c:	85aa                	mv	a1,a0
ffffffffc020ad0e:	7808                	ld	a0,48(s0)
ffffffffc020ad10:	8626                	mv	a2,s1
ffffffffc020ad12:	7118                	ld	a4,32(a0)
ffffffffc020ad14:	9702                	jalr	a4
ffffffffc020ad16:	70e2                	ld	ra,56(sp)
ffffffffc020ad18:	7442                	ld	s0,48(sp)
ffffffffc020ad1a:	74a2                	ld	s1,40(sp)
ffffffffc020ad1c:	6121                	addi	sp,sp,64
ffffffffc020ad1e:	8082                	ret
ffffffffc020ad20:	00004697          	auipc	a3,0x4
ffffffffc020ad24:	ba868693          	addi	a3,a3,-1112 # ffffffffc020e8c8 <etext+0x32ce>
ffffffffc020ad28:	00001617          	auipc	a2,0x1
ffffffffc020ad2c:	d1060613          	addi	a2,a2,-752 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020ad30:	45d5                	li	a1,21
ffffffffc020ad32:	00004517          	auipc	a0,0x4
ffffffffc020ad36:	bce50513          	addi	a0,a0,-1074 # ffffffffc020e900 <etext+0x3306>
ffffffffc020ad3a:	f10f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020ad3e <sfs_rblock>:
ffffffffc020ad3e:	7139                	addi	sp,sp,-64
ffffffffc020ad40:	ec4e                	sd	s3,24(sp)
ffffffffc020ad42:	89b6                	mv	s3,a3
ffffffffc020ad44:	f822                	sd	s0,48(sp)
ffffffffc020ad46:	f04a                	sd	s2,32(sp)
ffffffffc020ad48:	e852                	sd	s4,16(sp)
ffffffffc020ad4a:	fc06                	sd	ra,56(sp)
ffffffffc020ad4c:	f426                	sd	s1,40(sp)
ffffffffc020ad4e:	892e                	mv	s2,a1
ffffffffc020ad50:	8432                	mv	s0,a2
ffffffffc020ad52:	8a2a                	mv	s4,a0
ffffffffc020ad54:	2ea000ef          	jal	ffffffffc020b03e <lock_sfs_io>
ffffffffc020ad58:	02098763          	beqz	s3,ffffffffc020ad86 <sfs_rblock+0x48>
ffffffffc020ad5c:	e456                	sd	s5,8(sp)
ffffffffc020ad5e:	013409bb          	addw	s3,s0,s3
ffffffffc020ad62:	6a85                	lui	s5,0x1
ffffffffc020ad64:	a021                	j	ffffffffc020ad6c <sfs_rblock+0x2e>
ffffffffc020ad66:	9956                	add	s2,s2,s5
ffffffffc020ad68:	01340e63          	beq	s0,s3,ffffffffc020ad84 <sfs_rblock+0x46>
ffffffffc020ad6c:	8622                	mv	a2,s0
ffffffffc020ad6e:	4705                	li	a4,1
ffffffffc020ad70:	4681                	li	a3,0
ffffffffc020ad72:	85ca                	mv	a1,s2
ffffffffc020ad74:	8552                	mv	a0,s4
ffffffffc020ad76:	f6dff0ef          	jal	ffffffffc020ace2 <sfs_rwblock_nolock>
ffffffffc020ad7a:	84aa                	mv	s1,a0
ffffffffc020ad7c:	2405                	addiw	s0,s0,1
ffffffffc020ad7e:	d565                	beqz	a0,ffffffffc020ad66 <sfs_rblock+0x28>
ffffffffc020ad80:	6aa2                	ld	s5,8(sp)
ffffffffc020ad82:	a019                	j	ffffffffc020ad88 <sfs_rblock+0x4a>
ffffffffc020ad84:	6aa2                	ld	s5,8(sp)
ffffffffc020ad86:	4481                	li	s1,0
ffffffffc020ad88:	8552                	mv	a0,s4
ffffffffc020ad8a:	2c4000ef          	jal	ffffffffc020b04e <unlock_sfs_io>
ffffffffc020ad8e:	70e2                	ld	ra,56(sp)
ffffffffc020ad90:	7442                	ld	s0,48(sp)
ffffffffc020ad92:	7902                	ld	s2,32(sp)
ffffffffc020ad94:	69e2                	ld	s3,24(sp)
ffffffffc020ad96:	6a42                	ld	s4,16(sp)
ffffffffc020ad98:	8526                	mv	a0,s1
ffffffffc020ad9a:	74a2                	ld	s1,40(sp)
ffffffffc020ad9c:	6121                	addi	sp,sp,64
ffffffffc020ad9e:	8082                	ret

ffffffffc020ada0 <sfs_wblock>:
ffffffffc020ada0:	7139                	addi	sp,sp,-64
ffffffffc020ada2:	ec4e                	sd	s3,24(sp)
ffffffffc020ada4:	89b6                	mv	s3,a3
ffffffffc020ada6:	f822                	sd	s0,48(sp)
ffffffffc020ada8:	f04a                	sd	s2,32(sp)
ffffffffc020adaa:	e852                	sd	s4,16(sp)
ffffffffc020adac:	fc06                	sd	ra,56(sp)
ffffffffc020adae:	f426                	sd	s1,40(sp)
ffffffffc020adb0:	892e                	mv	s2,a1
ffffffffc020adb2:	8432                	mv	s0,a2
ffffffffc020adb4:	8a2a                	mv	s4,a0
ffffffffc020adb6:	288000ef          	jal	ffffffffc020b03e <lock_sfs_io>
ffffffffc020adba:	02098763          	beqz	s3,ffffffffc020ade8 <sfs_wblock+0x48>
ffffffffc020adbe:	e456                	sd	s5,8(sp)
ffffffffc020adc0:	013409bb          	addw	s3,s0,s3
ffffffffc020adc4:	6a85                	lui	s5,0x1
ffffffffc020adc6:	a021                	j	ffffffffc020adce <sfs_wblock+0x2e>
ffffffffc020adc8:	9956                	add	s2,s2,s5
ffffffffc020adca:	01340e63          	beq	s0,s3,ffffffffc020ade6 <sfs_wblock+0x46>
ffffffffc020adce:	4705                	li	a4,1
ffffffffc020add0:	8622                	mv	a2,s0
ffffffffc020add2:	86ba                	mv	a3,a4
ffffffffc020add4:	85ca                	mv	a1,s2
ffffffffc020add6:	8552                	mv	a0,s4
ffffffffc020add8:	f0bff0ef          	jal	ffffffffc020ace2 <sfs_rwblock_nolock>
ffffffffc020addc:	84aa                	mv	s1,a0
ffffffffc020adde:	2405                	addiw	s0,s0,1
ffffffffc020ade0:	d565                	beqz	a0,ffffffffc020adc8 <sfs_wblock+0x28>
ffffffffc020ade2:	6aa2                	ld	s5,8(sp)
ffffffffc020ade4:	a019                	j	ffffffffc020adea <sfs_wblock+0x4a>
ffffffffc020ade6:	6aa2                	ld	s5,8(sp)
ffffffffc020ade8:	4481                	li	s1,0
ffffffffc020adea:	8552                	mv	a0,s4
ffffffffc020adec:	262000ef          	jal	ffffffffc020b04e <unlock_sfs_io>
ffffffffc020adf0:	70e2                	ld	ra,56(sp)
ffffffffc020adf2:	7442                	ld	s0,48(sp)
ffffffffc020adf4:	7902                	ld	s2,32(sp)
ffffffffc020adf6:	69e2                	ld	s3,24(sp)
ffffffffc020adf8:	6a42                	ld	s4,16(sp)
ffffffffc020adfa:	8526                	mv	a0,s1
ffffffffc020adfc:	74a2                	ld	s1,40(sp)
ffffffffc020adfe:	6121                	addi	sp,sp,64
ffffffffc020ae00:	8082                	ret

ffffffffc020ae02 <sfs_rbuf>:
ffffffffc020ae02:	7179                	addi	sp,sp,-48
ffffffffc020ae04:	f406                	sd	ra,40(sp)
ffffffffc020ae06:	f022                	sd	s0,32(sp)
ffffffffc020ae08:	ec26                	sd	s1,24(sp)
ffffffffc020ae0a:	e84a                	sd	s2,16(sp)
ffffffffc020ae0c:	e44e                	sd	s3,8(sp)
ffffffffc020ae0e:	e052                	sd	s4,0(sp)
ffffffffc020ae10:	6785                	lui	a5,0x1
ffffffffc020ae12:	04f77863          	bgeu	a4,a5,ffffffffc020ae62 <sfs_rbuf+0x60>
ffffffffc020ae16:	84ba                	mv	s1,a4
ffffffffc020ae18:	9732                	add	a4,a4,a2
ffffffffc020ae1a:	04e7e463          	bltu	a5,a4,ffffffffc020ae62 <sfs_rbuf+0x60>
ffffffffc020ae1e:	8936                	mv	s2,a3
ffffffffc020ae20:	842a                	mv	s0,a0
ffffffffc020ae22:	89ae                	mv	s3,a1
ffffffffc020ae24:	8a32                	mv	s4,a2
ffffffffc020ae26:	218000ef          	jal	ffffffffc020b03e <lock_sfs_io>
ffffffffc020ae2a:	642c                	ld	a1,72(s0)
ffffffffc020ae2c:	864a                	mv	a2,s2
ffffffffc020ae2e:	8522                	mv	a0,s0
ffffffffc020ae30:	4705                	li	a4,1
ffffffffc020ae32:	4681                	li	a3,0
ffffffffc020ae34:	eafff0ef          	jal	ffffffffc020ace2 <sfs_rwblock_nolock>
ffffffffc020ae38:	892a                	mv	s2,a0
ffffffffc020ae3a:	cd09                	beqz	a0,ffffffffc020ae54 <sfs_rbuf+0x52>
ffffffffc020ae3c:	8522                	mv	a0,s0
ffffffffc020ae3e:	210000ef          	jal	ffffffffc020b04e <unlock_sfs_io>
ffffffffc020ae42:	70a2                	ld	ra,40(sp)
ffffffffc020ae44:	7402                	ld	s0,32(sp)
ffffffffc020ae46:	64e2                	ld	s1,24(sp)
ffffffffc020ae48:	69a2                	ld	s3,8(sp)
ffffffffc020ae4a:	6a02                	ld	s4,0(sp)
ffffffffc020ae4c:	854a                	mv	a0,s2
ffffffffc020ae4e:	6942                	ld	s2,16(sp)
ffffffffc020ae50:	6145                	addi	sp,sp,48
ffffffffc020ae52:	8082                	ret
ffffffffc020ae54:	642c                	ld	a1,72(s0)
ffffffffc020ae56:	8652                	mv	a2,s4
ffffffffc020ae58:	854e                	mv	a0,s3
ffffffffc020ae5a:	95a6                	add	a1,a1,s1
ffffffffc020ae5c:	786000ef          	jal	ffffffffc020b5e2 <memcpy>
ffffffffc020ae60:	bff1                	j	ffffffffc020ae3c <sfs_rbuf+0x3a>
ffffffffc020ae62:	00004697          	auipc	a3,0x4
ffffffffc020ae66:	ab668693          	addi	a3,a3,-1354 # ffffffffc020e918 <etext+0x331e>
ffffffffc020ae6a:	00001617          	auipc	a2,0x1
ffffffffc020ae6e:	bce60613          	addi	a2,a2,-1074 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020ae72:	05500593          	li	a1,85
ffffffffc020ae76:	00004517          	auipc	a0,0x4
ffffffffc020ae7a:	a8a50513          	addi	a0,a0,-1398 # ffffffffc020e900 <etext+0x3306>
ffffffffc020ae7e:	dccf50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020ae82 <sfs_wbuf>:
ffffffffc020ae82:	7139                	addi	sp,sp,-64
ffffffffc020ae84:	fc06                	sd	ra,56(sp)
ffffffffc020ae86:	f822                	sd	s0,48(sp)
ffffffffc020ae88:	f426                	sd	s1,40(sp)
ffffffffc020ae8a:	f04a                	sd	s2,32(sp)
ffffffffc020ae8c:	ec4e                	sd	s3,24(sp)
ffffffffc020ae8e:	e852                	sd	s4,16(sp)
ffffffffc020ae90:	e456                	sd	s5,8(sp)
ffffffffc020ae92:	6785                	lui	a5,0x1
ffffffffc020ae94:	06f77163          	bgeu	a4,a5,ffffffffc020aef6 <sfs_wbuf+0x74>
ffffffffc020ae98:	893a                	mv	s2,a4
ffffffffc020ae9a:	9732                	add	a4,a4,a2
ffffffffc020ae9c:	04e7ed63          	bltu	a5,a4,ffffffffc020aef6 <sfs_wbuf+0x74>
ffffffffc020aea0:	89b6                	mv	s3,a3
ffffffffc020aea2:	84aa                	mv	s1,a0
ffffffffc020aea4:	8a2e                	mv	s4,a1
ffffffffc020aea6:	8ab2                	mv	s5,a2
ffffffffc020aea8:	196000ef          	jal	ffffffffc020b03e <lock_sfs_io>
ffffffffc020aeac:	64ac                	ld	a1,72(s1)
ffffffffc020aeae:	864e                	mv	a2,s3
ffffffffc020aeb0:	8526                	mv	a0,s1
ffffffffc020aeb2:	4705                	li	a4,1
ffffffffc020aeb4:	4681                	li	a3,0
ffffffffc020aeb6:	e2dff0ef          	jal	ffffffffc020ace2 <sfs_rwblock_nolock>
ffffffffc020aeba:	842a                	mv	s0,a0
ffffffffc020aebc:	cd11                	beqz	a0,ffffffffc020aed8 <sfs_wbuf+0x56>
ffffffffc020aebe:	8526                	mv	a0,s1
ffffffffc020aec0:	18e000ef          	jal	ffffffffc020b04e <unlock_sfs_io>
ffffffffc020aec4:	70e2                	ld	ra,56(sp)
ffffffffc020aec6:	8522                	mv	a0,s0
ffffffffc020aec8:	7442                	ld	s0,48(sp)
ffffffffc020aeca:	74a2                	ld	s1,40(sp)
ffffffffc020aecc:	7902                	ld	s2,32(sp)
ffffffffc020aece:	69e2                	ld	s3,24(sp)
ffffffffc020aed0:	6a42                	ld	s4,16(sp)
ffffffffc020aed2:	6aa2                	ld	s5,8(sp)
ffffffffc020aed4:	6121                	addi	sp,sp,64
ffffffffc020aed6:	8082                	ret
ffffffffc020aed8:	64a8                	ld	a0,72(s1)
ffffffffc020aeda:	8656                	mv	a2,s5
ffffffffc020aedc:	85d2                	mv	a1,s4
ffffffffc020aede:	954a                	add	a0,a0,s2
ffffffffc020aee0:	702000ef          	jal	ffffffffc020b5e2 <memcpy>
ffffffffc020aee4:	64ac                	ld	a1,72(s1)
ffffffffc020aee6:	4705                	li	a4,1
ffffffffc020aee8:	864e                	mv	a2,s3
ffffffffc020aeea:	8526                	mv	a0,s1
ffffffffc020aeec:	86ba                	mv	a3,a4
ffffffffc020aeee:	df5ff0ef          	jal	ffffffffc020ace2 <sfs_rwblock_nolock>
ffffffffc020aef2:	842a                	mv	s0,a0
ffffffffc020aef4:	b7e9                	j	ffffffffc020aebe <sfs_wbuf+0x3c>
ffffffffc020aef6:	00004697          	auipc	a3,0x4
ffffffffc020aefa:	a2268693          	addi	a3,a3,-1502 # ffffffffc020e918 <etext+0x331e>
ffffffffc020aefe:	00001617          	auipc	a2,0x1
ffffffffc020af02:	b3a60613          	addi	a2,a2,-1222 # ffffffffc020ba38 <etext+0x43e>
ffffffffc020af06:	06b00593          	li	a1,107
ffffffffc020af0a:	00004517          	auipc	a0,0x4
ffffffffc020af0e:	9f650513          	addi	a0,a0,-1546 # ffffffffc020e900 <etext+0x3306>
ffffffffc020af12:	d38f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020af16 <sfs_sync_super>:
ffffffffc020af16:	1101                	addi	sp,sp,-32
ffffffffc020af18:	ec06                	sd	ra,24(sp)
ffffffffc020af1a:	e822                	sd	s0,16(sp)
ffffffffc020af1c:	e426                	sd	s1,8(sp)
ffffffffc020af1e:	842a                	mv	s0,a0
ffffffffc020af20:	11e000ef          	jal	ffffffffc020b03e <lock_sfs_io>
ffffffffc020af24:	6428                	ld	a0,72(s0)
ffffffffc020af26:	6605                	lui	a2,0x1
ffffffffc020af28:	4581                	li	a1,0
ffffffffc020af2a:	668000ef          	jal	ffffffffc020b592 <memset>
ffffffffc020af2e:	6428                	ld	a0,72(s0)
ffffffffc020af30:	85a2                	mv	a1,s0
ffffffffc020af32:	02c00613          	li	a2,44
ffffffffc020af36:	6ac000ef          	jal	ffffffffc020b5e2 <memcpy>
ffffffffc020af3a:	642c                	ld	a1,72(s0)
ffffffffc020af3c:	8522                	mv	a0,s0
ffffffffc020af3e:	4701                	li	a4,0
ffffffffc020af40:	4685                	li	a3,1
ffffffffc020af42:	4601                	li	a2,0
ffffffffc020af44:	d9fff0ef          	jal	ffffffffc020ace2 <sfs_rwblock_nolock>
ffffffffc020af48:	84aa                	mv	s1,a0
ffffffffc020af4a:	8522                	mv	a0,s0
ffffffffc020af4c:	102000ef          	jal	ffffffffc020b04e <unlock_sfs_io>
ffffffffc020af50:	60e2                	ld	ra,24(sp)
ffffffffc020af52:	6442                	ld	s0,16(sp)
ffffffffc020af54:	8526                	mv	a0,s1
ffffffffc020af56:	64a2                	ld	s1,8(sp)
ffffffffc020af58:	6105                	addi	sp,sp,32
ffffffffc020af5a:	8082                	ret

ffffffffc020af5c <sfs_sync_freemap>:
ffffffffc020af5c:	7139                	addi	sp,sp,-64
ffffffffc020af5e:	ec4e                	sd	s3,24(sp)
ffffffffc020af60:	e852                	sd	s4,16(sp)
ffffffffc020af62:	00456983          	lwu	s3,4(a0)
ffffffffc020af66:	8a2a                	mv	s4,a0
ffffffffc020af68:	7d08                	ld	a0,56(a0)
ffffffffc020af6a:	67a1                	lui	a5,0x8
ffffffffc020af6c:	17fd                	addi	a5,a5,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc020af6e:	4581                	li	a1,0
ffffffffc020af70:	f822                	sd	s0,48(sp)
ffffffffc020af72:	fc06                	sd	ra,56(sp)
ffffffffc020af74:	f426                	sd	s1,40(sp)
ffffffffc020af76:	99be                	add	s3,s3,a5
ffffffffc020af78:	956fe0ef          	jal	ffffffffc02090ce <bitmap_getdata>
ffffffffc020af7c:	00f9d993          	srli	s3,s3,0xf
ffffffffc020af80:	842a                	mv	s0,a0
ffffffffc020af82:	8552                	mv	a0,s4
ffffffffc020af84:	0ba000ef          	jal	ffffffffc020b03e <lock_sfs_io>
ffffffffc020af88:	02098b63          	beqz	s3,ffffffffc020afbe <sfs_sync_freemap+0x62>
ffffffffc020af8c:	09b2                	slli	s3,s3,0xc
ffffffffc020af8e:	f04a                	sd	s2,32(sp)
ffffffffc020af90:	e456                	sd	s5,8(sp)
ffffffffc020af92:	99a2                	add	s3,s3,s0
ffffffffc020af94:	4909                	li	s2,2
ffffffffc020af96:	6a85                	lui	s5,0x1
ffffffffc020af98:	a021                	j	ffffffffc020afa0 <sfs_sync_freemap+0x44>
ffffffffc020af9a:	2905                	addiw	s2,s2,1
ffffffffc020af9c:	01340f63          	beq	s0,s3,ffffffffc020afba <sfs_sync_freemap+0x5e>
ffffffffc020afa0:	4705                	li	a4,1
ffffffffc020afa2:	85a2                	mv	a1,s0
ffffffffc020afa4:	86ba                	mv	a3,a4
ffffffffc020afa6:	864a                	mv	a2,s2
ffffffffc020afa8:	8552                	mv	a0,s4
ffffffffc020afaa:	d39ff0ef          	jal	ffffffffc020ace2 <sfs_rwblock_nolock>
ffffffffc020afae:	84aa                	mv	s1,a0
ffffffffc020afb0:	9456                	add	s0,s0,s5
ffffffffc020afb2:	d565                	beqz	a0,ffffffffc020af9a <sfs_sync_freemap+0x3e>
ffffffffc020afb4:	7902                	ld	s2,32(sp)
ffffffffc020afb6:	6aa2                	ld	s5,8(sp)
ffffffffc020afb8:	a021                	j	ffffffffc020afc0 <sfs_sync_freemap+0x64>
ffffffffc020afba:	7902                	ld	s2,32(sp)
ffffffffc020afbc:	6aa2                	ld	s5,8(sp)
ffffffffc020afbe:	4481                	li	s1,0
ffffffffc020afc0:	8552                	mv	a0,s4
ffffffffc020afc2:	08c000ef          	jal	ffffffffc020b04e <unlock_sfs_io>
ffffffffc020afc6:	70e2                	ld	ra,56(sp)
ffffffffc020afc8:	7442                	ld	s0,48(sp)
ffffffffc020afca:	69e2                	ld	s3,24(sp)
ffffffffc020afcc:	6a42                	ld	s4,16(sp)
ffffffffc020afce:	8526                	mv	a0,s1
ffffffffc020afd0:	74a2                	ld	s1,40(sp)
ffffffffc020afd2:	6121                	addi	sp,sp,64
ffffffffc020afd4:	8082                	ret

ffffffffc020afd6 <sfs_clear_block>:
ffffffffc020afd6:	7179                	addi	sp,sp,-48
ffffffffc020afd8:	f022                	sd	s0,32(sp)
ffffffffc020afda:	e84a                	sd	s2,16(sp)
ffffffffc020afdc:	e44e                	sd	s3,8(sp)
ffffffffc020afde:	f406                	sd	ra,40(sp)
ffffffffc020afe0:	89b2                	mv	s3,a2
ffffffffc020afe2:	ec26                	sd	s1,24(sp)
ffffffffc020afe4:	842e                	mv	s0,a1
ffffffffc020afe6:	892a                	mv	s2,a0
ffffffffc020afe8:	056000ef          	jal	ffffffffc020b03e <lock_sfs_io>
ffffffffc020afec:	04893503          	ld	a0,72(s2)
ffffffffc020aff0:	6605                	lui	a2,0x1
ffffffffc020aff2:	4581                	li	a1,0
ffffffffc020aff4:	59e000ef          	jal	ffffffffc020b592 <memset>
ffffffffc020aff8:	02098d63          	beqz	s3,ffffffffc020b032 <sfs_clear_block+0x5c>
ffffffffc020affc:	013409bb          	addw	s3,s0,s3
ffffffffc020b000:	a019                	j	ffffffffc020b006 <sfs_clear_block+0x30>
ffffffffc020b002:	03340863          	beq	s0,s3,ffffffffc020b032 <sfs_clear_block+0x5c>
ffffffffc020b006:	04893583          	ld	a1,72(s2)
ffffffffc020b00a:	4705                	li	a4,1
ffffffffc020b00c:	8622                	mv	a2,s0
ffffffffc020b00e:	86ba                	mv	a3,a4
ffffffffc020b010:	854a                	mv	a0,s2
ffffffffc020b012:	cd1ff0ef          	jal	ffffffffc020ace2 <sfs_rwblock_nolock>
ffffffffc020b016:	84aa                	mv	s1,a0
ffffffffc020b018:	2405                	addiw	s0,s0,1
ffffffffc020b01a:	d565                	beqz	a0,ffffffffc020b002 <sfs_clear_block+0x2c>
ffffffffc020b01c:	854a                	mv	a0,s2
ffffffffc020b01e:	030000ef          	jal	ffffffffc020b04e <unlock_sfs_io>
ffffffffc020b022:	70a2                	ld	ra,40(sp)
ffffffffc020b024:	7402                	ld	s0,32(sp)
ffffffffc020b026:	6942                	ld	s2,16(sp)
ffffffffc020b028:	69a2                	ld	s3,8(sp)
ffffffffc020b02a:	8526                	mv	a0,s1
ffffffffc020b02c:	64e2                	ld	s1,24(sp)
ffffffffc020b02e:	6145                	addi	sp,sp,48
ffffffffc020b030:	8082                	ret
ffffffffc020b032:	4481                	li	s1,0
ffffffffc020b034:	b7e5                	j	ffffffffc020b01c <sfs_clear_block+0x46>

ffffffffc020b036 <lock_sfs_fs>:
ffffffffc020b036:	05050513          	addi	a0,a0,80
ffffffffc020b03a:	bdef906f          	j	ffffffffc0204418 <down>

ffffffffc020b03e <lock_sfs_io>:
ffffffffc020b03e:	06850513          	addi	a0,a0,104
ffffffffc020b042:	bd6f906f          	j	ffffffffc0204418 <down>

ffffffffc020b046 <unlock_sfs_fs>:
ffffffffc020b046:	05050513          	addi	a0,a0,80
ffffffffc020b04a:	bcaf906f          	j	ffffffffc0204414 <up>

ffffffffc020b04e <unlock_sfs_io>:
ffffffffc020b04e:	06850513          	addi	a0,a0,104
ffffffffc020b052:	bc2f906f          	j	ffffffffc0204414 <up>

ffffffffc020b056 <hash32>:
ffffffffc020b056:	9e3707b7          	lui	a5,0x9e370
ffffffffc020b05a:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <_binary_bin_sfs_img_size+0xffffffff9e2fad01>
ffffffffc020b05c:	02a787bb          	mulw	a5,a5,a0
ffffffffc020b060:	02000513          	li	a0,32
ffffffffc020b064:	9d0d                	subw	a0,a0,a1
ffffffffc020b066:	00a7d53b          	srlw	a0,a5,a0
ffffffffc020b06a:	8082                	ret

ffffffffc020b06c <printnum>:
ffffffffc020b06c:	7139                	addi	sp,sp,-64
ffffffffc020b06e:	02071893          	slli	a7,a4,0x20
ffffffffc020b072:	f822                	sd	s0,48(sp)
ffffffffc020b074:	f426                	sd	s1,40(sp)
ffffffffc020b076:	f04a                	sd	s2,32(sp)
ffffffffc020b078:	ec4e                	sd	s3,24(sp)
ffffffffc020b07a:	e456                	sd	s5,8(sp)
ffffffffc020b07c:	0208d893          	srli	a7,a7,0x20
ffffffffc020b080:	fc06                	sd	ra,56(sp)
ffffffffc020b082:	0316fab3          	remu	s5,a3,a7
ffffffffc020b086:	fff7841b          	addiw	s0,a5,-1
ffffffffc020b08a:	84aa                	mv	s1,a0
ffffffffc020b08c:	89ae                	mv	s3,a1
ffffffffc020b08e:	8932                	mv	s2,a2
ffffffffc020b090:	0516f063          	bgeu	a3,a7,ffffffffc020b0d0 <printnum+0x64>
ffffffffc020b094:	e852                	sd	s4,16(sp)
ffffffffc020b096:	4705                	li	a4,1
ffffffffc020b098:	8a42                	mv	s4,a6
ffffffffc020b09a:	00f75863          	bge	a4,a5,ffffffffc020b0aa <printnum+0x3e>
ffffffffc020b09e:	864e                	mv	a2,s3
ffffffffc020b0a0:	85ca                	mv	a1,s2
ffffffffc020b0a2:	8552                	mv	a0,s4
ffffffffc020b0a4:	347d                	addiw	s0,s0,-1
ffffffffc020b0a6:	9482                	jalr	s1
ffffffffc020b0a8:	f87d                	bnez	s0,ffffffffc020b09e <printnum+0x32>
ffffffffc020b0aa:	6a42                	ld	s4,16(sp)
ffffffffc020b0ac:	00004797          	auipc	a5,0x4
ffffffffc020b0b0:	8b478793          	addi	a5,a5,-1868 # ffffffffc020e960 <etext+0x3366>
ffffffffc020b0b4:	97d6                	add	a5,a5,s5
ffffffffc020b0b6:	7442                	ld	s0,48(sp)
ffffffffc020b0b8:	0007c503          	lbu	a0,0(a5)
ffffffffc020b0bc:	70e2                	ld	ra,56(sp)
ffffffffc020b0be:	6aa2                	ld	s5,8(sp)
ffffffffc020b0c0:	864e                	mv	a2,s3
ffffffffc020b0c2:	85ca                	mv	a1,s2
ffffffffc020b0c4:	69e2                	ld	s3,24(sp)
ffffffffc020b0c6:	7902                	ld	s2,32(sp)
ffffffffc020b0c8:	87a6                	mv	a5,s1
ffffffffc020b0ca:	74a2                	ld	s1,40(sp)
ffffffffc020b0cc:	6121                	addi	sp,sp,64
ffffffffc020b0ce:	8782                	jr	a5
ffffffffc020b0d0:	0316d6b3          	divu	a3,a3,a7
ffffffffc020b0d4:	87a2                	mv	a5,s0
ffffffffc020b0d6:	f97ff0ef          	jal	ffffffffc020b06c <printnum>
ffffffffc020b0da:	bfc9                	j	ffffffffc020b0ac <printnum+0x40>

ffffffffc020b0dc <sprintputch>:
ffffffffc020b0dc:	499c                	lw	a5,16(a1)
ffffffffc020b0de:	6198                	ld	a4,0(a1)
ffffffffc020b0e0:	6594                	ld	a3,8(a1)
ffffffffc020b0e2:	2785                	addiw	a5,a5,1
ffffffffc020b0e4:	c99c                	sw	a5,16(a1)
ffffffffc020b0e6:	00d77763          	bgeu	a4,a3,ffffffffc020b0f4 <sprintputch+0x18>
ffffffffc020b0ea:	00170793          	addi	a5,a4,1
ffffffffc020b0ee:	e19c                	sd	a5,0(a1)
ffffffffc020b0f0:	00a70023          	sb	a0,0(a4)
ffffffffc020b0f4:	8082                	ret

ffffffffc020b0f6 <vprintfmt>:
ffffffffc020b0f6:	7119                	addi	sp,sp,-128
ffffffffc020b0f8:	f4a6                	sd	s1,104(sp)
ffffffffc020b0fa:	f0ca                	sd	s2,96(sp)
ffffffffc020b0fc:	ecce                	sd	s3,88(sp)
ffffffffc020b0fe:	e8d2                	sd	s4,80(sp)
ffffffffc020b100:	e4d6                	sd	s5,72(sp)
ffffffffc020b102:	e0da                	sd	s6,64(sp)
ffffffffc020b104:	fc5e                	sd	s7,56(sp)
ffffffffc020b106:	f466                	sd	s9,40(sp)
ffffffffc020b108:	fc86                	sd	ra,120(sp)
ffffffffc020b10a:	f8a2                	sd	s0,112(sp)
ffffffffc020b10c:	f862                	sd	s8,48(sp)
ffffffffc020b10e:	f06a                	sd	s10,32(sp)
ffffffffc020b110:	ec6e                	sd	s11,24(sp)
ffffffffc020b112:	84aa                	mv	s1,a0
ffffffffc020b114:	8cb6                	mv	s9,a3
ffffffffc020b116:	8aba                	mv	s5,a4
ffffffffc020b118:	89ae                	mv	s3,a1
ffffffffc020b11a:	8932                	mv	s2,a2
ffffffffc020b11c:	02500a13          	li	s4,37
ffffffffc020b120:	05500b93          	li	s7,85
ffffffffc020b124:	00004b17          	auipc	s6,0x4
ffffffffc020b128:	4e4b0b13          	addi	s6,s6,1252 # ffffffffc020f608 <sfs_node_dirops+0x80>
ffffffffc020b12c:	000cc503          	lbu	a0,0(s9)
ffffffffc020b130:	001c8413          	addi	s0,s9,1
ffffffffc020b134:	01450b63          	beq	a0,s4,ffffffffc020b14a <vprintfmt+0x54>
ffffffffc020b138:	cd15                	beqz	a0,ffffffffc020b174 <vprintfmt+0x7e>
ffffffffc020b13a:	864e                	mv	a2,s3
ffffffffc020b13c:	85ca                	mv	a1,s2
ffffffffc020b13e:	9482                	jalr	s1
ffffffffc020b140:	00044503          	lbu	a0,0(s0)
ffffffffc020b144:	0405                	addi	s0,s0,1
ffffffffc020b146:	ff4519e3          	bne	a0,s4,ffffffffc020b138 <vprintfmt+0x42>
ffffffffc020b14a:	5d7d                	li	s10,-1
ffffffffc020b14c:	8dea                	mv	s11,s10
ffffffffc020b14e:	02000813          	li	a6,32
ffffffffc020b152:	4c01                	li	s8,0
ffffffffc020b154:	4581                	li	a1,0
ffffffffc020b156:	00044703          	lbu	a4,0(s0)
ffffffffc020b15a:	00140c93          	addi	s9,s0,1
ffffffffc020b15e:	fdd7061b          	addiw	a2,a4,-35
ffffffffc020b162:	0ff67613          	zext.b	a2,a2
ffffffffc020b166:	02cbe663          	bltu	s7,a2,ffffffffc020b192 <vprintfmt+0x9c>
ffffffffc020b16a:	060a                	slli	a2,a2,0x2
ffffffffc020b16c:	965a                	add	a2,a2,s6
ffffffffc020b16e:	421c                	lw	a5,0(a2)
ffffffffc020b170:	97da                	add	a5,a5,s6
ffffffffc020b172:	8782                	jr	a5
ffffffffc020b174:	70e6                	ld	ra,120(sp)
ffffffffc020b176:	7446                	ld	s0,112(sp)
ffffffffc020b178:	74a6                	ld	s1,104(sp)
ffffffffc020b17a:	7906                	ld	s2,96(sp)
ffffffffc020b17c:	69e6                	ld	s3,88(sp)
ffffffffc020b17e:	6a46                	ld	s4,80(sp)
ffffffffc020b180:	6aa6                	ld	s5,72(sp)
ffffffffc020b182:	6b06                	ld	s6,64(sp)
ffffffffc020b184:	7be2                	ld	s7,56(sp)
ffffffffc020b186:	7c42                	ld	s8,48(sp)
ffffffffc020b188:	7ca2                	ld	s9,40(sp)
ffffffffc020b18a:	7d02                	ld	s10,32(sp)
ffffffffc020b18c:	6de2                	ld	s11,24(sp)
ffffffffc020b18e:	6109                	addi	sp,sp,128
ffffffffc020b190:	8082                	ret
ffffffffc020b192:	864e                	mv	a2,s3
ffffffffc020b194:	85ca                	mv	a1,s2
ffffffffc020b196:	02500513          	li	a0,37
ffffffffc020b19a:	9482                	jalr	s1
ffffffffc020b19c:	fff44783          	lbu	a5,-1(s0)
ffffffffc020b1a0:	02500713          	li	a4,37
ffffffffc020b1a4:	8ca2                	mv	s9,s0
ffffffffc020b1a6:	f8e783e3          	beq	a5,a4,ffffffffc020b12c <vprintfmt+0x36>
ffffffffc020b1aa:	ffecc783          	lbu	a5,-2(s9)
ffffffffc020b1ae:	1cfd                	addi	s9,s9,-1
ffffffffc020b1b0:	fee79de3          	bne	a5,a4,ffffffffc020b1aa <vprintfmt+0xb4>
ffffffffc020b1b4:	bfa5                	j	ffffffffc020b12c <vprintfmt+0x36>
ffffffffc020b1b6:	00144683          	lbu	a3,1(s0)
ffffffffc020b1ba:	4525                	li	a0,9
ffffffffc020b1bc:	fd070d1b          	addiw	s10,a4,-48
ffffffffc020b1c0:	fd06879b          	addiw	a5,a3,-48
ffffffffc020b1c4:	28f56063          	bltu	a0,a5,ffffffffc020b444 <vprintfmt+0x34e>
ffffffffc020b1c8:	2681                	sext.w	a3,a3
ffffffffc020b1ca:	8466                	mv	s0,s9
ffffffffc020b1cc:	002d179b          	slliw	a5,s10,0x2
ffffffffc020b1d0:	00144703          	lbu	a4,1(s0)
ffffffffc020b1d4:	01a787bb          	addw	a5,a5,s10
ffffffffc020b1d8:	0017979b          	slliw	a5,a5,0x1
ffffffffc020b1dc:	9fb5                	addw	a5,a5,a3
ffffffffc020b1de:	fd07061b          	addiw	a2,a4,-48
ffffffffc020b1e2:	0405                	addi	s0,s0,1
ffffffffc020b1e4:	fd078d1b          	addiw	s10,a5,-48
ffffffffc020b1e8:	0007069b          	sext.w	a3,a4
ffffffffc020b1ec:	fec570e3          	bgeu	a0,a2,ffffffffc020b1cc <vprintfmt+0xd6>
ffffffffc020b1f0:	f60dd3e3          	bgez	s11,ffffffffc020b156 <vprintfmt+0x60>
ffffffffc020b1f4:	8dea                	mv	s11,s10
ffffffffc020b1f6:	5d7d                	li	s10,-1
ffffffffc020b1f8:	bfb9                	j	ffffffffc020b156 <vprintfmt+0x60>
ffffffffc020b1fa:	883a                	mv	a6,a4
ffffffffc020b1fc:	8466                	mv	s0,s9
ffffffffc020b1fe:	bfa1                	j	ffffffffc020b156 <vprintfmt+0x60>
ffffffffc020b200:	8466                	mv	s0,s9
ffffffffc020b202:	4c05                	li	s8,1
ffffffffc020b204:	bf89                	j	ffffffffc020b156 <vprintfmt+0x60>
ffffffffc020b206:	4785                	li	a5,1
ffffffffc020b208:	008a8613          	addi	a2,s5,8 # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc020b20c:	00b7c463          	blt	a5,a1,ffffffffc020b214 <vprintfmt+0x11e>
ffffffffc020b210:	1c058363          	beqz	a1,ffffffffc020b3d6 <vprintfmt+0x2e0>
ffffffffc020b214:	000ab683          	ld	a3,0(s5)
ffffffffc020b218:	4741                	li	a4,16
ffffffffc020b21a:	8ab2                	mv	s5,a2
ffffffffc020b21c:	2801                	sext.w	a6,a6
ffffffffc020b21e:	87ee                	mv	a5,s11
ffffffffc020b220:	864a                	mv	a2,s2
ffffffffc020b222:	85ce                	mv	a1,s3
ffffffffc020b224:	8526                	mv	a0,s1
ffffffffc020b226:	e47ff0ef          	jal	ffffffffc020b06c <printnum>
ffffffffc020b22a:	b709                	j	ffffffffc020b12c <vprintfmt+0x36>
ffffffffc020b22c:	000aa503          	lw	a0,0(s5)
ffffffffc020b230:	864e                	mv	a2,s3
ffffffffc020b232:	85ca                	mv	a1,s2
ffffffffc020b234:	9482                	jalr	s1
ffffffffc020b236:	0aa1                	addi	s5,s5,8
ffffffffc020b238:	bdd5                	j	ffffffffc020b12c <vprintfmt+0x36>
ffffffffc020b23a:	4785                	li	a5,1
ffffffffc020b23c:	008a8613          	addi	a2,s5,8
ffffffffc020b240:	00b7c463          	blt	a5,a1,ffffffffc020b248 <vprintfmt+0x152>
ffffffffc020b244:	18058463          	beqz	a1,ffffffffc020b3cc <vprintfmt+0x2d6>
ffffffffc020b248:	000ab683          	ld	a3,0(s5)
ffffffffc020b24c:	4729                	li	a4,10
ffffffffc020b24e:	8ab2                	mv	s5,a2
ffffffffc020b250:	b7f1                	j	ffffffffc020b21c <vprintfmt+0x126>
ffffffffc020b252:	864e                	mv	a2,s3
ffffffffc020b254:	85ca                	mv	a1,s2
ffffffffc020b256:	03000513          	li	a0,48
ffffffffc020b25a:	e042                	sd	a6,0(sp)
ffffffffc020b25c:	9482                	jalr	s1
ffffffffc020b25e:	864e                	mv	a2,s3
ffffffffc020b260:	85ca                	mv	a1,s2
ffffffffc020b262:	07800513          	li	a0,120
ffffffffc020b266:	9482                	jalr	s1
ffffffffc020b268:	000ab683          	ld	a3,0(s5)
ffffffffc020b26c:	6802                	ld	a6,0(sp)
ffffffffc020b26e:	4741                	li	a4,16
ffffffffc020b270:	0aa1                	addi	s5,s5,8
ffffffffc020b272:	b76d                	j	ffffffffc020b21c <vprintfmt+0x126>
ffffffffc020b274:	864e                	mv	a2,s3
ffffffffc020b276:	85ca                	mv	a1,s2
ffffffffc020b278:	02500513          	li	a0,37
ffffffffc020b27c:	9482                	jalr	s1
ffffffffc020b27e:	b57d                	j	ffffffffc020b12c <vprintfmt+0x36>
ffffffffc020b280:	000aad03          	lw	s10,0(s5)
ffffffffc020b284:	8466                	mv	s0,s9
ffffffffc020b286:	0aa1                	addi	s5,s5,8
ffffffffc020b288:	b7a5                	j	ffffffffc020b1f0 <vprintfmt+0xfa>
ffffffffc020b28a:	4785                	li	a5,1
ffffffffc020b28c:	008a8613          	addi	a2,s5,8
ffffffffc020b290:	00b7c463          	blt	a5,a1,ffffffffc020b298 <vprintfmt+0x1a2>
ffffffffc020b294:	12058763          	beqz	a1,ffffffffc020b3c2 <vprintfmt+0x2cc>
ffffffffc020b298:	000ab683          	ld	a3,0(s5)
ffffffffc020b29c:	4721                	li	a4,8
ffffffffc020b29e:	8ab2                	mv	s5,a2
ffffffffc020b2a0:	bfb5                	j	ffffffffc020b21c <vprintfmt+0x126>
ffffffffc020b2a2:	87ee                	mv	a5,s11
ffffffffc020b2a4:	000dd363          	bgez	s11,ffffffffc020b2aa <vprintfmt+0x1b4>
ffffffffc020b2a8:	4781                	li	a5,0
ffffffffc020b2aa:	00078d9b          	sext.w	s11,a5
ffffffffc020b2ae:	8466                	mv	s0,s9
ffffffffc020b2b0:	b55d                	j	ffffffffc020b156 <vprintfmt+0x60>
ffffffffc020b2b2:	0008041b          	sext.w	s0,a6
ffffffffc020b2b6:	fd340793          	addi	a5,s0,-45
ffffffffc020b2ba:	01b02733          	sgtz	a4,s11
ffffffffc020b2be:	00f037b3          	snez	a5,a5
ffffffffc020b2c2:	8ff9                	and	a5,a5,a4
ffffffffc020b2c4:	000ab703          	ld	a4,0(s5)
ffffffffc020b2c8:	008a8693          	addi	a3,s5,8
ffffffffc020b2cc:	e436                	sd	a3,8(sp)
ffffffffc020b2ce:	12070563          	beqz	a4,ffffffffc020b3f8 <vprintfmt+0x302>
ffffffffc020b2d2:	12079d63          	bnez	a5,ffffffffc020b40c <vprintfmt+0x316>
ffffffffc020b2d6:	00074783          	lbu	a5,0(a4)
ffffffffc020b2da:	0007851b          	sext.w	a0,a5
ffffffffc020b2de:	c78d                	beqz	a5,ffffffffc020b308 <vprintfmt+0x212>
ffffffffc020b2e0:	00170a93          	addi	s5,a4,1
ffffffffc020b2e4:	547d                	li	s0,-1
ffffffffc020b2e6:	000d4563          	bltz	s10,ffffffffc020b2f0 <vprintfmt+0x1fa>
ffffffffc020b2ea:	3d7d                	addiw	s10,s10,-1
ffffffffc020b2ec:	008d0e63          	beq	s10,s0,ffffffffc020b308 <vprintfmt+0x212>
ffffffffc020b2f0:	020c1863          	bnez	s8,ffffffffc020b320 <vprintfmt+0x22a>
ffffffffc020b2f4:	864e                	mv	a2,s3
ffffffffc020b2f6:	85ca                	mv	a1,s2
ffffffffc020b2f8:	9482                	jalr	s1
ffffffffc020b2fa:	000ac783          	lbu	a5,0(s5)
ffffffffc020b2fe:	0a85                	addi	s5,s5,1
ffffffffc020b300:	3dfd                	addiw	s11,s11,-1
ffffffffc020b302:	0007851b          	sext.w	a0,a5
ffffffffc020b306:	f3e5                	bnez	a5,ffffffffc020b2e6 <vprintfmt+0x1f0>
ffffffffc020b308:	01b05a63          	blez	s11,ffffffffc020b31c <vprintfmt+0x226>
ffffffffc020b30c:	864e                	mv	a2,s3
ffffffffc020b30e:	85ca                	mv	a1,s2
ffffffffc020b310:	02000513          	li	a0,32
ffffffffc020b314:	3dfd                	addiw	s11,s11,-1
ffffffffc020b316:	9482                	jalr	s1
ffffffffc020b318:	fe0d9ae3          	bnez	s11,ffffffffc020b30c <vprintfmt+0x216>
ffffffffc020b31c:	6aa2                	ld	s5,8(sp)
ffffffffc020b31e:	b539                	j	ffffffffc020b12c <vprintfmt+0x36>
ffffffffc020b320:	3781                	addiw	a5,a5,-32
ffffffffc020b322:	05e00713          	li	a4,94
ffffffffc020b326:	fcf777e3          	bgeu	a4,a5,ffffffffc020b2f4 <vprintfmt+0x1fe>
ffffffffc020b32a:	03f00513          	li	a0,63
ffffffffc020b32e:	864e                	mv	a2,s3
ffffffffc020b330:	85ca                	mv	a1,s2
ffffffffc020b332:	9482                	jalr	s1
ffffffffc020b334:	000ac783          	lbu	a5,0(s5)
ffffffffc020b338:	0a85                	addi	s5,s5,1
ffffffffc020b33a:	3dfd                	addiw	s11,s11,-1
ffffffffc020b33c:	0007851b          	sext.w	a0,a5
ffffffffc020b340:	d7e1                	beqz	a5,ffffffffc020b308 <vprintfmt+0x212>
ffffffffc020b342:	fa0d54e3          	bgez	s10,ffffffffc020b2ea <vprintfmt+0x1f4>
ffffffffc020b346:	bfe9                	j	ffffffffc020b320 <vprintfmt+0x22a>
ffffffffc020b348:	000aa783          	lw	a5,0(s5)
ffffffffc020b34c:	46e1                	li	a3,24
ffffffffc020b34e:	0aa1                	addi	s5,s5,8
ffffffffc020b350:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020b354:	8fb9                	xor	a5,a5,a4
ffffffffc020b356:	40e7873b          	subw	a4,a5,a4
ffffffffc020b35a:	02e6c663          	blt	a3,a4,ffffffffc020b386 <vprintfmt+0x290>
ffffffffc020b35e:	00004797          	auipc	a5,0x4
ffffffffc020b362:	40278793          	addi	a5,a5,1026 # ffffffffc020f760 <error_string>
ffffffffc020b366:	00371693          	slli	a3,a4,0x3
ffffffffc020b36a:	97b6                	add	a5,a5,a3
ffffffffc020b36c:	639c                	ld	a5,0(a5)
ffffffffc020b36e:	cf81                	beqz	a5,ffffffffc020b386 <vprintfmt+0x290>
ffffffffc020b370:	873e                	mv	a4,a5
ffffffffc020b372:	00000697          	auipc	a3,0x0
ffffffffc020b376:	2b668693          	addi	a3,a3,694 # ffffffffc020b628 <etext+0x2e>
ffffffffc020b37a:	864a                	mv	a2,s2
ffffffffc020b37c:	85ce                	mv	a1,s3
ffffffffc020b37e:	8526                	mv	a0,s1
ffffffffc020b380:	0f2000ef          	jal	ffffffffc020b472 <printfmt>
ffffffffc020b384:	b365                	j	ffffffffc020b12c <vprintfmt+0x36>
ffffffffc020b386:	00003697          	auipc	a3,0x3
ffffffffc020b38a:	5fa68693          	addi	a3,a3,1530 # ffffffffc020e980 <etext+0x3386>
ffffffffc020b38e:	864a                	mv	a2,s2
ffffffffc020b390:	85ce                	mv	a1,s3
ffffffffc020b392:	8526                	mv	a0,s1
ffffffffc020b394:	0de000ef          	jal	ffffffffc020b472 <printfmt>
ffffffffc020b398:	bb51                	j	ffffffffc020b12c <vprintfmt+0x36>
ffffffffc020b39a:	4785                	li	a5,1
ffffffffc020b39c:	008a8c13          	addi	s8,s5,8
ffffffffc020b3a0:	00b7c363          	blt	a5,a1,ffffffffc020b3a6 <vprintfmt+0x2b0>
ffffffffc020b3a4:	cd81                	beqz	a1,ffffffffc020b3bc <vprintfmt+0x2c6>
ffffffffc020b3a6:	000ab403          	ld	s0,0(s5)
ffffffffc020b3aa:	02044b63          	bltz	s0,ffffffffc020b3e0 <vprintfmt+0x2ea>
ffffffffc020b3ae:	86a2                	mv	a3,s0
ffffffffc020b3b0:	8ae2                	mv	s5,s8
ffffffffc020b3b2:	4729                	li	a4,10
ffffffffc020b3b4:	b5a5                	j	ffffffffc020b21c <vprintfmt+0x126>
ffffffffc020b3b6:	2585                	addiw	a1,a1,1
ffffffffc020b3b8:	8466                	mv	s0,s9
ffffffffc020b3ba:	bb71                	j	ffffffffc020b156 <vprintfmt+0x60>
ffffffffc020b3bc:	000aa403          	lw	s0,0(s5)
ffffffffc020b3c0:	b7ed                	j	ffffffffc020b3aa <vprintfmt+0x2b4>
ffffffffc020b3c2:	000ae683          	lwu	a3,0(s5)
ffffffffc020b3c6:	4721                	li	a4,8
ffffffffc020b3c8:	8ab2                	mv	s5,a2
ffffffffc020b3ca:	bd89                	j	ffffffffc020b21c <vprintfmt+0x126>
ffffffffc020b3cc:	000ae683          	lwu	a3,0(s5)
ffffffffc020b3d0:	4729                	li	a4,10
ffffffffc020b3d2:	8ab2                	mv	s5,a2
ffffffffc020b3d4:	b5a1                	j	ffffffffc020b21c <vprintfmt+0x126>
ffffffffc020b3d6:	000ae683          	lwu	a3,0(s5)
ffffffffc020b3da:	4741                	li	a4,16
ffffffffc020b3dc:	8ab2                	mv	s5,a2
ffffffffc020b3de:	bd3d                	j	ffffffffc020b21c <vprintfmt+0x126>
ffffffffc020b3e0:	864e                	mv	a2,s3
ffffffffc020b3e2:	85ca                	mv	a1,s2
ffffffffc020b3e4:	02d00513          	li	a0,45
ffffffffc020b3e8:	e042                	sd	a6,0(sp)
ffffffffc020b3ea:	9482                	jalr	s1
ffffffffc020b3ec:	6802                	ld	a6,0(sp)
ffffffffc020b3ee:	408006b3          	neg	a3,s0
ffffffffc020b3f2:	8ae2                	mv	s5,s8
ffffffffc020b3f4:	4729                	li	a4,10
ffffffffc020b3f6:	b51d                	j	ffffffffc020b21c <vprintfmt+0x126>
ffffffffc020b3f8:	eba1                	bnez	a5,ffffffffc020b448 <vprintfmt+0x352>
ffffffffc020b3fa:	02800793          	li	a5,40
ffffffffc020b3fe:	853e                	mv	a0,a5
ffffffffc020b400:	00003a97          	auipc	s5,0x3
ffffffffc020b404:	579a8a93          	addi	s5,s5,1401 # ffffffffc020e979 <etext+0x337f>
ffffffffc020b408:	547d                	li	s0,-1
ffffffffc020b40a:	bdf1                	j	ffffffffc020b2e6 <vprintfmt+0x1f0>
ffffffffc020b40c:	853a                	mv	a0,a4
ffffffffc020b40e:	85ea                	mv	a1,s10
ffffffffc020b410:	e03a                	sd	a4,0(sp)
ffffffffc020b412:	0e4000ef          	jal	ffffffffc020b4f6 <strnlen>
ffffffffc020b416:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020b41a:	6702                	ld	a4,0(sp)
ffffffffc020b41c:	01b05b63          	blez	s11,ffffffffc020b432 <vprintfmt+0x33c>
ffffffffc020b420:	864e                	mv	a2,s3
ffffffffc020b422:	85ca                	mv	a1,s2
ffffffffc020b424:	8522                	mv	a0,s0
ffffffffc020b426:	e03a                	sd	a4,0(sp)
ffffffffc020b428:	3dfd                	addiw	s11,s11,-1
ffffffffc020b42a:	9482                	jalr	s1
ffffffffc020b42c:	6702                	ld	a4,0(sp)
ffffffffc020b42e:	fe0d99e3          	bnez	s11,ffffffffc020b420 <vprintfmt+0x32a>
ffffffffc020b432:	00074783          	lbu	a5,0(a4)
ffffffffc020b436:	0007851b          	sext.w	a0,a5
ffffffffc020b43a:	ee0781e3          	beqz	a5,ffffffffc020b31c <vprintfmt+0x226>
ffffffffc020b43e:	00170a93          	addi	s5,a4,1
ffffffffc020b442:	b54d                	j	ffffffffc020b2e4 <vprintfmt+0x1ee>
ffffffffc020b444:	8466                	mv	s0,s9
ffffffffc020b446:	b36d                	j	ffffffffc020b1f0 <vprintfmt+0xfa>
ffffffffc020b448:	85ea                	mv	a1,s10
ffffffffc020b44a:	00003517          	auipc	a0,0x3
ffffffffc020b44e:	52e50513          	addi	a0,a0,1326 # ffffffffc020e978 <etext+0x337e>
ffffffffc020b452:	0a4000ef          	jal	ffffffffc020b4f6 <strnlen>
ffffffffc020b456:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020b45a:	02800793          	li	a5,40
ffffffffc020b45e:	00003717          	auipc	a4,0x3
ffffffffc020b462:	51a70713          	addi	a4,a4,1306 # ffffffffc020e978 <etext+0x337e>
ffffffffc020b466:	853e                	mv	a0,a5
ffffffffc020b468:	fbb04ce3          	bgtz	s11,ffffffffc020b420 <vprintfmt+0x32a>
ffffffffc020b46c:	00170a93          	addi	s5,a4,1
ffffffffc020b470:	bd95                	j	ffffffffc020b2e4 <vprintfmt+0x1ee>

ffffffffc020b472 <printfmt>:
ffffffffc020b472:	7139                	addi	sp,sp,-64
ffffffffc020b474:	02010313          	addi	t1,sp,32
ffffffffc020b478:	f03a                	sd	a4,32(sp)
ffffffffc020b47a:	871a                	mv	a4,t1
ffffffffc020b47c:	ec06                	sd	ra,24(sp)
ffffffffc020b47e:	f43e                	sd	a5,40(sp)
ffffffffc020b480:	f842                	sd	a6,48(sp)
ffffffffc020b482:	fc46                	sd	a7,56(sp)
ffffffffc020b484:	e41a                	sd	t1,8(sp)
ffffffffc020b486:	c71ff0ef          	jal	ffffffffc020b0f6 <vprintfmt>
ffffffffc020b48a:	60e2                	ld	ra,24(sp)
ffffffffc020b48c:	6121                	addi	sp,sp,64
ffffffffc020b48e:	8082                	ret

ffffffffc020b490 <snprintf>:
ffffffffc020b490:	711d                	addi	sp,sp,-96
ffffffffc020b492:	15fd                	addi	a1,a1,-1
ffffffffc020b494:	95aa                	add	a1,a1,a0
ffffffffc020b496:	03810313          	addi	t1,sp,56
ffffffffc020b49a:	f406                	sd	ra,40(sp)
ffffffffc020b49c:	e82e                	sd	a1,16(sp)
ffffffffc020b49e:	e42a                	sd	a0,8(sp)
ffffffffc020b4a0:	fc36                	sd	a3,56(sp)
ffffffffc020b4a2:	e0ba                	sd	a4,64(sp)
ffffffffc020b4a4:	e4be                	sd	a5,72(sp)
ffffffffc020b4a6:	e8c2                	sd	a6,80(sp)
ffffffffc020b4a8:	ecc6                	sd	a7,88(sp)
ffffffffc020b4aa:	cc02                	sw	zero,24(sp)
ffffffffc020b4ac:	e01a                	sd	t1,0(sp)
ffffffffc020b4ae:	c515                	beqz	a0,ffffffffc020b4da <snprintf+0x4a>
ffffffffc020b4b0:	02a5e563          	bltu	a1,a0,ffffffffc020b4da <snprintf+0x4a>
ffffffffc020b4b4:	75dd                	lui	a1,0xffff7
ffffffffc020b4b6:	86b2                	mv	a3,a2
ffffffffc020b4b8:	00000517          	auipc	a0,0x0
ffffffffc020b4bc:	c2450513          	addi	a0,a0,-988 # ffffffffc020b0dc <sprintputch>
ffffffffc020b4c0:	871a                	mv	a4,t1
ffffffffc020b4c2:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020b4c6:	0030                	addi	a2,sp,8
ffffffffc020b4c8:	c2fff0ef          	jal	ffffffffc020b0f6 <vprintfmt>
ffffffffc020b4cc:	67a2                	ld	a5,8(sp)
ffffffffc020b4ce:	00078023          	sb	zero,0(a5)
ffffffffc020b4d2:	4562                	lw	a0,24(sp)
ffffffffc020b4d4:	70a2                	ld	ra,40(sp)
ffffffffc020b4d6:	6125                	addi	sp,sp,96
ffffffffc020b4d8:	8082                	ret
ffffffffc020b4da:	5575                	li	a0,-3
ffffffffc020b4dc:	bfe5                	j	ffffffffc020b4d4 <snprintf+0x44>

ffffffffc020b4de <strlen>:
ffffffffc020b4de:	00054783          	lbu	a5,0(a0)
ffffffffc020b4e2:	cb81                	beqz	a5,ffffffffc020b4f2 <strlen+0x14>
ffffffffc020b4e4:	4781                	li	a5,0
ffffffffc020b4e6:	0785                	addi	a5,a5,1
ffffffffc020b4e8:	00f50733          	add	a4,a0,a5
ffffffffc020b4ec:	00074703          	lbu	a4,0(a4)
ffffffffc020b4f0:	fb7d                	bnez	a4,ffffffffc020b4e6 <strlen+0x8>
ffffffffc020b4f2:	853e                	mv	a0,a5
ffffffffc020b4f4:	8082                	ret

ffffffffc020b4f6 <strnlen>:
ffffffffc020b4f6:	4781                	li	a5,0
ffffffffc020b4f8:	e589                	bnez	a1,ffffffffc020b502 <strnlen+0xc>
ffffffffc020b4fa:	a811                	j	ffffffffc020b50e <strnlen+0x18>
ffffffffc020b4fc:	0785                	addi	a5,a5,1
ffffffffc020b4fe:	00f58863          	beq	a1,a5,ffffffffc020b50e <strnlen+0x18>
ffffffffc020b502:	00f50733          	add	a4,a0,a5
ffffffffc020b506:	00074703          	lbu	a4,0(a4)
ffffffffc020b50a:	fb6d                	bnez	a4,ffffffffc020b4fc <strnlen+0x6>
ffffffffc020b50c:	85be                	mv	a1,a5
ffffffffc020b50e:	852e                	mv	a0,a1
ffffffffc020b510:	8082                	ret

ffffffffc020b512 <strcpy>:
ffffffffc020b512:	87aa                	mv	a5,a0
ffffffffc020b514:	0005c703          	lbu	a4,0(a1)
ffffffffc020b518:	0585                	addi	a1,a1,1
ffffffffc020b51a:	0785                	addi	a5,a5,1
ffffffffc020b51c:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b520:	fb75                	bnez	a4,ffffffffc020b514 <strcpy+0x2>
ffffffffc020b522:	8082                	ret

ffffffffc020b524 <strcmp>:
ffffffffc020b524:	00054783          	lbu	a5,0(a0)
ffffffffc020b528:	e791                	bnez	a5,ffffffffc020b534 <strcmp+0x10>
ffffffffc020b52a:	a01d                	j	ffffffffc020b550 <strcmp+0x2c>
ffffffffc020b52c:	00054783          	lbu	a5,0(a0)
ffffffffc020b530:	cb99                	beqz	a5,ffffffffc020b546 <strcmp+0x22>
ffffffffc020b532:	0585                	addi	a1,a1,1
ffffffffc020b534:	0005c703          	lbu	a4,0(a1)
ffffffffc020b538:	0505                	addi	a0,a0,1
ffffffffc020b53a:	fef709e3          	beq	a4,a5,ffffffffc020b52c <strcmp+0x8>
ffffffffc020b53e:	0007851b          	sext.w	a0,a5
ffffffffc020b542:	9d19                	subw	a0,a0,a4
ffffffffc020b544:	8082                	ret
ffffffffc020b546:	0015c703          	lbu	a4,1(a1)
ffffffffc020b54a:	4501                	li	a0,0
ffffffffc020b54c:	9d19                	subw	a0,a0,a4
ffffffffc020b54e:	8082                	ret
ffffffffc020b550:	0005c703          	lbu	a4,0(a1)
ffffffffc020b554:	4501                	li	a0,0
ffffffffc020b556:	b7f5                	j	ffffffffc020b542 <strcmp+0x1e>

ffffffffc020b558 <strncmp>:
ffffffffc020b558:	ce01                	beqz	a2,ffffffffc020b570 <strncmp+0x18>
ffffffffc020b55a:	00054783          	lbu	a5,0(a0)
ffffffffc020b55e:	167d                	addi	a2,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020b560:	cb91                	beqz	a5,ffffffffc020b574 <strncmp+0x1c>
ffffffffc020b562:	0005c703          	lbu	a4,0(a1)
ffffffffc020b566:	00f71763          	bne	a4,a5,ffffffffc020b574 <strncmp+0x1c>
ffffffffc020b56a:	0505                	addi	a0,a0,1
ffffffffc020b56c:	0585                	addi	a1,a1,1
ffffffffc020b56e:	f675                	bnez	a2,ffffffffc020b55a <strncmp+0x2>
ffffffffc020b570:	4501                	li	a0,0
ffffffffc020b572:	8082                	ret
ffffffffc020b574:	00054503          	lbu	a0,0(a0)
ffffffffc020b578:	0005c783          	lbu	a5,0(a1)
ffffffffc020b57c:	9d1d                	subw	a0,a0,a5
ffffffffc020b57e:	8082                	ret

ffffffffc020b580 <strchr>:
ffffffffc020b580:	a021                	j	ffffffffc020b588 <strchr+0x8>
ffffffffc020b582:	00f58763          	beq	a1,a5,ffffffffc020b590 <strchr+0x10>
ffffffffc020b586:	0505                	addi	a0,a0,1
ffffffffc020b588:	00054783          	lbu	a5,0(a0)
ffffffffc020b58c:	fbfd                	bnez	a5,ffffffffc020b582 <strchr+0x2>
ffffffffc020b58e:	4501                	li	a0,0
ffffffffc020b590:	8082                	ret

ffffffffc020b592 <memset>:
ffffffffc020b592:	ca01                	beqz	a2,ffffffffc020b5a2 <memset+0x10>
ffffffffc020b594:	962a                	add	a2,a2,a0
ffffffffc020b596:	87aa                	mv	a5,a0
ffffffffc020b598:	0785                	addi	a5,a5,1
ffffffffc020b59a:	feb78fa3          	sb	a1,-1(a5)
ffffffffc020b59e:	fef61de3          	bne	a2,a5,ffffffffc020b598 <memset+0x6>
ffffffffc020b5a2:	8082                	ret

ffffffffc020b5a4 <memmove>:
ffffffffc020b5a4:	02a5f163          	bgeu	a1,a0,ffffffffc020b5c6 <memmove+0x22>
ffffffffc020b5a8:	00c587b3          	add	a5,a1,a2
ffffffffc020b5ac:	00f57d63          	bgeu	a0,a5,ffffffffc020b5c6 <memmove+0x22>
ffffffffc020b5b0:	c61d                	beqz	a2,ffffffffc020b5de <memmove+0x3a>
ffffffffc020b5b2:	962a                	add	a2,a2,a0
ffffffffc020b5b4:	fff7c703          	lbu	a4,-1(a5)
ffffffffc020b5b8:	17fd                	addi	a5,a5,-1
ffffffffc020b5ba:	167d                	addi	a2,a2,-1
ffffffffc020b5bc:	00e60023          	sb	a4,0(a2)
ffffffffc020b5c0:	fef59ae3          	bne	a1,a5,ffffffffc020b5b4 <memmove+0x10>
ffffffffc020b5c4:	8082                	ret
ffffffffc020b5c6:	00c586b3          	add	a3,a1,a2
ffffffffc020b5ca:	87aa                	mv	a5,a0
ffffffffc020b5cc:	ca11                	beqz	a2,ffffffffc020b5e0 <memmove+0x3c>
ffffffffc020b5ce:	0005c703          	lbu	a4,0(a1)
ffffffffc020b5d2:	0585                	addi	a1,a1,1
ffffffffc020b5d4:	0785                	addi	a5,a5,1
ffffffffc020b5d6:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b5da:	feb69ae3          	bne	a3,a1,ffffffffc020b5ce <memmove+0x2a>
ffffffffc020b5de:	8082                	ret
ffffffffc020b5e0:	8082                	ret

ffffffffc020b5e2 <memcpy>:
ffffffffc020b5e2:	ca19                	beqz	a2,ffffffffc020b5f8 <memcpy+0x16>
ffffffffc020b5e4:	962e                	add	a2,a2,a1
ffffffffc020b5e6:	87aa                	mv	a5,a0
ffffffffc020b5e8:	0005c703          	lbu	a4,0(a1)
ffffffffc020b5ec:	0585                	addi	a1,a1,1
ffffffffc020b5ee:	0785                	addi	a5,a5,1
ffffffffc020b5f0:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b5f4:	feb61ae3          	bne	a2,a1,ffffffffc020b5e8 <memcpy+0x6>
ffffffffc020b5f8:	8082                	ret
